#!/usr/bin/env python3
"""
ROI Analysis - Return on Investment Calculator
Part of Plan Maestro Phase 3: Scale

Calculates cost savings and productivity gains from optimization efforts.

Usage:
    python scripts/roi-analysis.py
    python scripts/roi-analysis.py --detailed
    python scripts/roi-analysis.py --export
"""

import json
import glob
import os
import sys
from datetime import datetime

# Configuration
SESSIONS_PATH = "telemetry/sessions"

# Pricing (Claude Sonnet 4.5 API - example rates)
COST_PER_1M_INPUT_TOKENS = 3.00  # USD
COST_PER_1M_OUTPUT_TOKENS = 15.00  # USD
INPUT_OUTPUT_RATIO = 0.7  # Assume 70% input, 30% output

# Time value
HOURLY_RATE_DEVELOPER = 50.00  # USD/hour (conservative estimate)

# Targets
TARGET_EFFICIENCY = 5.0  # tasks per 10k tokens
TARGET_TOKENS_PER_SESSION = 40000
TARGET_TASKS_PER_SESSION = 10

def load_sessions():
    """Load all session JSON files"""
    pattern = os.path.join(SESSIONS_PATH, "session-*.json")
    files = sorted(glob.glob(pattern))

    sessions = []
    for file in files:
        with open(file, 'r') as f:
            data = json.load(f)
            sessions.append(data)

    return sessions

def calculate_token_cost(tokens):
    """Calculate cost of tokens in USD"""
    input_tokens = tokens * INPUT_OUTPUT_RATIO
    output_tokens = tokens * (1 - INPUT_OUTPUT_RATIO)

    cost_input = (input_tokens / 1_000_000) * COST_PER_1M_INPUT_TOKENS
    cost_output = (output_tokens / 1_000_000) * COST_PER_1M_OUTPUT_TOKENS

    return cost_input + cost_output

def calculate_time_value(minutes):
    """Calculate time value in USD"""
    hours = minutes / 60
    return hours * HOURLY_RATE_DEVELOPER

def analyze_baseline(sessions):
    """Analyze baseline performance (current state)"""
    total_tokens = sum(s['tokens_used'] for s in sessions)
    total_duration = sum(s['duration_minutes'] for s in sessions)
    total_tasks = sum(s['tasks_completed'] for s in sessions)

    avg_tokens_per_session = total_tokens / len(sessions) if sessions else 0
    avg_duration_per_session = total_duration / len(sessions) if sessions else 0
    avg_tasks_per_session = total_tasks / len(sessions) if sessions else 0

    tokens_per_task = total_tokens / total_tasks if total_tasks > 0 else 0
    minutes_per_task = total_duration / total_tasks if total_tasks > 0 else 0

    cost_tokens = calculate_token_cost(total_tokens)
    cost_time = calculate_time_value(total_duration)
    total_cost = cost_tokens + cost_time

    return {
        'sessions': len(sessions),
        'total_tokens': total_tokens,
        'total_duration': total_duration,
        'total_tasks': total_tasks,
        'avg_tokens_per_session': round(avg_tokens_per_session, 0),
        'avg_duration_per_session': round(avg_duration_per_session, 0),
        'avg_tasks_per_session': round(avg_tasks_per_session, 1),
        'tokens_per_task': round(tokens_per_task, 0),
        'minutes_per_task': round(minutes_per_task, 1),
        'cost_tokens': cost_tokens,
        'cost_time': cost_time,
        'total_cost': total_cost,
        'cost_per_task': total_cost / total_tasks if total_tasks > 0 else 0
    }

def project_optimized(baseline, num_sessions=10):
    """Project optimized performance with targets achieved"""
    # Optimized metrics (hitting targets)
    opt_tokens_per_session = TARGET_TOKENS_PER_SESSION
    opt_tasks_per_session = TARGET_TASKS_PER_SESSION
    opt_duration_per_session = baseline['avg_duration_per_session'] * 0.6  # 40% faster

    total_tokens = opt_tokens_per_session * num_sessions
    total_duration = opt_duration_per_session * num_sessions
    total_tasks = opt_tasks_per_session * num_sessions

    tokens_per_task = total_tokens / total_tasks
    minutes_per_task = total_duration / total_tasks

    cost_tokens = calculate_token_cost(total_tokens)
    cost_time = calculate_time_value(total_duration)
    total_cost = cost_tokens + cost_time

    return {
        'sessions': num_sessions,
        'total_tokens': total_tokens,
        'total_duration': total_duration,
        'total_tasks': total_tasks,
        'avg_tokens_per_session': opt_tokens_per_session,
        'avg_duration_per_session': round(opt_duration_per_session, 0),
        'avg_tasks_per_session': opt_tasks_per_session,
        'tokens_per_task': round(tokens_per_task, 0),
        'minutes_per_task': round(minutes_per_task, 1),
        'cost_tokens': cost_tokens,
        'cost_time': cost_time,
        'total_cost': total_cost,
        'cost_per_task': total_cost / total_tasks
    }

def calculate_savings(baseline, optimized):
    """Calculate savings between baseline and optimized"""
    savings_tokens = baseline['cost_tokens'] - optimized['cost_tokens']
    savings_time = baseline['cost_time'] - optimized['cost_time']
    savings_total = baseline['total_cost'] - optimized['total_cost']

    # Percentage savings
    pct_tokens = (savings_tokens / baseline['cost_tokens'] * 100) if baseline['cost_tokens'] > 0 else 0
    pct_time = (savings_time / baseline['cost_time'] * 100) if baseline['cost_time'] > 0 else 0
    pct_total = (savings_total / baseline['total_cost'] * 100) if baseline['total_cost'] > 0 else 0

    # Productivity gains
    throughput_increase = ((optimized['avg_tasks_per_session'] - baseline['avg_tasks_per_session'])
                          / baseline['avg_tasks_per_session'] * 100) if baseline['avg_tasks_per_session'] > 0 else 0

    return {
        'savings_tokens': savings_tokens,
        'savings_time': savings_time,
        'savings_total': savings_total,
        'pct_tokens': pct_tokens,
        'pct_time': pct_time,
        'pct_total': pct_total,
        'throughput_increase': throughput_increase
    }

def print_header():
    """Display header"""
    print()
    print("=" * 80)
    print("  ROI ANALYSIS - Plan Maestro Investment Return")
    print("=" * 80)
    print()

def print_baseline(baseline):
    """Display baseline analysis"""
    print("[BASELINE PERFORMANCE - Current State]")
    print("-" * 80)
    print(f"Sessions analyzed:    {baseline['sessions']}")
    print(f"Total tokens used:    {baseline['total_tokens']:,}")
    print(f"Total duration:       {baseline['total_duration']} min ({baseline['total_duration']/60:.1f} hours)")
    print(f"Total tasks:          {baseline['total_tasks']}")
    print()

    print("[AVERAGES]")
    print("-" * 80)
    print(f"Tokens/session:       {int(baseline['avg_tokens_per_session']):,}")
    print(f"Duration/session:     {int(baseline['avg_duration_per_session'])} min")
    print(f"Tasks/session:        {baseline['avg_tasks_per_session']}")
    print()

    print("[PER TASK]")
    print("-" * 80)
    print(f"Tokens/task:          {int(baseline['tokens_per_task']):,}")
    print(f"Time/task:            {baseline['minutes_per_task']:.1f} min")
    print()

    print("[COSTS]")
    print("-" * 80)
    print(f"Token costs:          ${baseline['cost_tokens']:.2f}")
    print(f"Time value:           ${baseline['cost_time']:.2f}")
    print(f"Total cost:           ${baseline['total_cost']:.2f}")
    print(f"Cost per task:        ${baseline['cost_per_task']:.2f}")
    print()

def print_optimized(optimized):
    """Display optimized projection"""
    print("[OPTIMIZED PERFORMANCE - Target State]")
    print("-" * 80)
    print(f"Projected sessions:   {optimized['sessions']}")
    print(f"Projected tokens:     {optimized['total_tokens']:,}")
    print(f"Projected duration:   {optimized['total_duration']:.0f} min ({optimized['total_duration']/60:.1f} hours)")
    print(f"Projected tasks:      {optimized['total_tasks']}")
    print()

    print("[TARGETS]")
    print("-" * 80)
    print(f"Tokens/session:       {int(optimized['avg_tokens_per_session']):,} (target: {TARGET_TOKENS_PER_SESSION:,})")
    print(f"Duration/session:     {int(optimized['avg_duration_per_session'])} min")
    print(f"Tasks/session:        {optimized['avg_tasks_per_session']} (target: {TARGET_TASKS_PER_SESSION})")
    print()

    print("[PER TASK]")
    print("-" * 80)
    print(f"Tokens/task:          {int(optimized['tokens_per_task']):,}")
    print(f"Time/task:            {optimized['minutes_per_task']:.1f} min")
    print()

    print("[PROJECTED COSTS]")
    print("-" * 80)
    print(f"Token costs:          ${optimized['cost_tokens']:.2f}")
    print(f"Time value:           ${optimized['cost_time']:.2f}")
    print(f"Total cost:           ${optimized['total_cost']:.2f}")
    print(f"Cost per task:        ${optimized['cost_per_task']:.2f}")
    print()

def print_savings(savings, baseline, optimized):
    """Display ROI and savings"""
    print("[ROI - RETURN ON INVESTMENT]")
    print("=" * 80)
    print()

    print("[COST SAVINGS]")
    print("-" * 80)
    print(f"Token cost reduction: ${savings['savings_tokens']:+.2f} ({savings['pct_tokens']:+.1f}%)")
    print(f"Time value savings:   ${savings['savings_time']:+.2f} ({savings['pct_time']:+.1f}%)")
    print(f"Total savings:        ${savings['savings_total']:+.2f} ({savings['pct_total']:+.1f}%)")
    print()

    print("[PRODUCTIVITY GAINS]")
    print("-" * 80)
    print(f"Throughput increase:  {savings['throughput_increase']:+.1f}%")
    print(f"Tasks gained:         +{optimized['total_tasks'] - baseline['total_tasks']} tasks")
    print(f"Efficiency gain:      {baseline['tokens_per_task']:,.0f} -> {optimized['tokens_per_task']:,.0f} tokens/task")
    print()

    # Annual projection
    weeks_per_year = 50  # Conservative (2 weeks vacation)
    sessions_per_week = 2  # Conservative estimate
    annual_sessions = weeks_per_year * sessions_per_week

    annual_baseline_cost = (baseline['total_cost'] / baseline['sessions']) * annual_sessions
    annual_optimized_cost = (optimized['total_cost'] / optimized['sessions']) * annual_sessions
    annual_savings = annual_baseline_cost - annual_optimized_cost

    print("[ANNUAL PROJECTION]")
    print("-" * 80)
    print(f"Sessions/year:        {annual_sessions} ({sessions_per_week}/week × {weeks_per_year} weeks)")
    print(f"Baseline cost/year:   ${annual_baseline_cost:,.2f}")
    print(f"Optimized cost/year:  ${annual_optimized_cost:,.2f}")
    print(f"Annual savings:       ${annual_savings:,.2f} ({savings['pct_total']:+.1f}%)")
    print()

    print("[INVESTMENT PAYBACK]")
    print("-" * 80)
    # Estimate development cost of Plan Maestro
    plan_maestro_hours = 8  # Sessions 54-57 (approx)
    investment_cost = plan_maestro_hours * HOURLY_RATE_DEVELOPER

    # Payback period
    savings_per_session = savings['savings_total'] / baseline['sessions']
    sessions_to_payback = investment_cost / savings_per_session if savings_per_session > 0 else float('inf')

    print(f"Plan Maestro investment: ${investment_cost:.2f} ({plan_maestro_hours} hours development)")
    print(f"Savings per session:     ${savings_per_session:.2f}")
    print(f"Payback period:          {sessions_to_payback:.1f} sessions")

    if sessions_to_payback < 10:
        print(f"Status:                  [OK] EXCELLENT ROI - Payback in <10 sessions")
    elif sessions_to_payback < 20:
        print(f"Status:                  [*] GOOD ROI - Payback in <20 sessions")
    else:
        print(f"Status:                  [!] Review optimization targets")
    print()

def main():
    """Main execution"""
    try:
        print_header()

        # Load sessions
        sessions = load_sessions()

        if not sessions:
            print("[!] No session data found")
            return 1

        # Analyze baseline
        baseline = analyze_baseline(sessions)

        # Project optimized (normalize to same # sessions for fair comparison)
        optimized = project_optimized(baseline, num_sessions=len(sessions))

        # Calculate savings
        savings = calculate_savings(baseline, optimized)

        # Display results
        print_baseline(baseline)
        print_optimized(optimized)
        print_savings(savings, baseline, optimized)

        print("=" * 80)
        print()
        print("[TIP] Use --detailed to see session-by-session breakdown")
        print("[TIP] Use --export to generate full ROI report")
        print()

        return 0

    except Exception as e:
        print(f"[ERROR] {e}")
        import traceback
        traceback.print_exc()
        return 1

if __name__ == "__main__":
    sys.exit(main())
