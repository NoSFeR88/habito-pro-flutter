#!/usr/bin/env python3
"""
Pattern Analysis - Identify optimization opportunities
Part of Plan Maestro Phase 4: Optimize

Analyzes telemetry data to identify:
- High token consumption patterns
- Low efficiency patterns
- Common task types and their costs
- Optimization opportunities

Usage:
    python scripts/analyze-patterns.py
    python scripts/analyze-patterns.py --recommendations
"""

import json
import glob
import os
import sys
from datetime import datetime
from pathlib import Path
from collections import defaultdict

# Configuration
SESSIONS_PATH = "telemetry/sessions"
TOKENS_PATH = "telemetry/tokens"
MIN_EFFICIENCY = 5.0
HIGH_TOKENS_THRESHOLD = 10000  # Per operation

def load_sessions():
    """Load all session JSON files"""
    pattern = os.path.join(SESSIONS_PATH, "session-*.json")
    files = sorted(glob.glob(pattern))

    sessions = []
    for file in files:
        with open(file, 'r') as f:
            data = json.load(f)
            data['file'] = os.path.basename(file)
            sessions.append(data)

    return sessions

def load_token_logs():
    """Load all token operation logs"""
    pattern = os.path.join(TOKENS_PATH, "tokens-*.json")
    files = sorted(glob.glob(pattern))

    operations = []
    for file in files:
        with open(file, 'r') as f:
            data = json.load(f)
            operations.append(data)

    return operations

def analyze_high_cost_operations(operations):
    """Identify operations that consume many tokens"""
    high_cost = [op for op in operations if op['tokens_used'] > HIGH_TOKENS_THRESHOLD]

    # Group by operation type
    by_type = defaultdict(list)
    for op in high_cost:
        op_type = op['operation'].split()[0]  # First word (Read, Grep, etc.)
        by_type[op_type].append(op)

    return {
        'total_high_cost': len(high_cost),
        'by_type': dict(by_type),
        'top_consumers': sorted(high_cost, key=lambda x: x['tokens_used'], reverse=True)[:5]
    }

def analyze_session_patterns(sessions):
    """Identify patterns in session efficiency"""
    # Calculate efficiency for each session
    sessions_with_eff = []
    for s in sessions:
        eff = round((s['tasks_completed'] / (s['tokens_used'] / 10000)), 1) if s['tokens_used'] > 0 else 0
        sessions_with_eff.append({
            'session_id': s['session_id'],
            'efficiency': eff,
            'tokens': s['tokens_used'],
            'tasks': s['tasks_completed'],
            'duration': s['duration_minutes'],
            'notes': s.get('notes', '')
        })

    # Categorize sessions
    low_eff = [s for s in sessions_with_eff if s['efficiency'] < MIN_EFFICIENCY]
    high_eff = [s for s in sessions_with_eff if s['efficiency'] >= MIN_EFFICIENCY * 2]

    return {
        'low_efficiency': low_eff,
        'high_efficiency': high_eff,
        'avg_efficiency': round(sum(s['efficiency'] for s in sessions_with_eff) / len(sessions_with_eff), 1) if sessions_with_eff else 0
    }

def identify_repetitive_patterns(operations):
    """Find repetitive operations that could be optimized"""
    # Count operations by type
    operation_counts = defaultdict(int)
    operation_tokens = defaultdict(int)

    for op in operations:
        op_type = op['operation']
        operation_counts[op_type] += 1
        operation_tokens[op_type] += op['tokens_used']

    # Find operations done more than 5 times
    repetitive = {
        op: {
            'count': count,
            'total_tokens': operation_tokens[op],
            'avg_tokens': round(operation_tokens[op] / count, 0)
        }
        for op, count in operation_counts.items()
        if count > 5
    }

    return sorted(repetitive.items(), key=lambda x: x[1]['total_tokens'], reverse=True)

def generate_recommendations(patterns, session_patterns, repetitive):
    """Generate actionable optimization recommendations"""
    recommendations = []

    # High cost operations
    if patterns['total_high_cost'] > 0:
        recommendations.append({
            'category': 'High Token Operations',
            'severity': 'HIGH',
            'finding': f"{patterns['total_high_cost']} operations consumed >{HIGH_TOKENS_THRESHOLD} tokens",
            'recommendation': 'Consider caching results or splitting large operations',
            'examples': [op['operation'] for op in patterns['top_consumers'][:3]]
        })

    # Low efficiency sessions
    if session_patterns['low_efficiency']:
        avg_low_eff = round(sum(s['efficiency'] for s in session_patterns['low_efficiency']) / len(session_patterns['low_efficiency']), 1)
        recommendations.append({
            'category': 'Session Efficiency',
            'severity': 'MEDIUM',
            'finding': f"{len(session_patterns['low_efficiency'])} sessions below target efficiency ({avg_low_eff} avg)",
            'recommendation': 'Focus on completing more tasks per token spent. Break down complex tasks into smaller steps.',
            'sessions': [s['session_id'] for s in session_patterns['low_efficiency'][:3]]
        })

    # Repetitive operations
    if repetitive:
        top_repetitive = repetitive[0]
        recommendations.append({
            'category': 'Repetitive Operations',
            'severity': 'MEDIUM',
            'finding': f"Operation '{top_repetitive[0]}' executed {top_repetitive[1]['count']} times ({top_repetitive[1]['total_tokens']:,} tokens total)",
            'recommendation': 'Cache results or create indexed documentation for frequently accessed information',
            'operation': top_repetitive[0]
        })

    # Overall efficiency
    if session_patterns['avg_efficiency'] < MIN_EFFICIENCY:
        recommendations.append({
            'category': 'Overall Efficiency',
            'severity': 'HIGH',
            'finding': f"Average efficiency {session_patterns['avg_efficiency']} is below target {MIN_EFFICIENCY}",
            'recommendation': 'Review workflow: reduce exploratory searches, use direct file reads when paths are known, leverage PROJECT_INDEX.md',
            'action': 'Implement structured context loading protocol'
        })

    return recommendations

def print_header():
    """Display header"""
    print()
    print("=" * 80)
    print("  PATTERN ANALYSIS - Optimization Opportunities")
    print("=" * 80)
    print()

def print_patterns(patterns):
    """Display pattern analysis"""
    print("[HIGH COST OPERATIONS]")
    print("-" * 80)
    print(f"Total operations >{HIGH_TOKENS_THRESHOLD} tokens: {patterns['total_high_cost']}")

    if patterns['by_type']:
        print("\nBreakdown by type:")
        for op_type, ops in sorted(patterns['by_type'].items(), key=lambda x: len(x[1]), reverse=True):
            total_tokens = sum(op['tokens_used'] for op in ops)
            print(f"  - {op_type}: {len(ops)} operations, {total_tokens:,} tokens total")

    if patterns['top_consumers']:
        print("\nTop 5 most expensive operations:")
        for i, op in enumerate(patterns['top_consumers'], 1):
            print(f"  {i}. {op['operation']} - {op['tokens_used']:,} tokens")
    print()

def print_session_patterns(session_patterns):
    """Display session efficiency patterns"""
    print("[SESSION EFFICIENCY PATTERNS]")
    print("-" * 80)
    print(f"Average efficiency: {session_patterns['avg_efficiency']} tasks/10k tokens")
    print(f"Low efficiency sessions: {len(session_patterns['low_efficiency'])}")
    print(f"High efficiency sessions: {len(session_patterns['high_efficiency'])}")

    if session_patterns['low_efficiency']:
        print("\nLow efficiency sessions (need optimization):")
        for s in session_patterns['low_efficiency'][:5]:
            print(f"  - Session {s['session_id']}: {s['efficiency']} tasks/10k ({s['tasks']} tasks, {s['tokens']:,} tokens)")

    if session_patterns['high_efficiency']:
        print("\nHigh efficiency sessions (best practices):")
        for s in session_patterns['high_efficiency'][:3]:
            print(f"  - Session {s['session_id']}: {s['efficiency']} tasks/10k ({s['tasks']} tasks, {s['tokens']:,} tokens)")
    print()

def print_repetitive(repetitive):
    """Display repetitive operations"""
    print("[REPETITIVE OPERATIONS]")
    print("-" * 80)

    if not repetitive:
        print("No highly repetitive operations found (good!)")
    else:
        print(f"Found {len(repetitive)} operations executed >5 times:\n")
        for op, data in repetitive[:5]:
            print(f"  - {op}")
            print(f"    Count: {data['count']} times")
            print(f"    Total tokens: {data['total_tokens']:,}")
            print(f"    Avg tokens: {data['avg_tokens']:,}")
            print()

def print_recommendations(recommendations):
    """Display optimization recommendations"""
    print("[OPTIMIZATION RECOMMENDATIONS]")
    print("=" * 80)

    if not recommendations:
        print("✅ No major optimization opportunities identified!")
        print("   Your workflow is already efficient.")
        return

    for i, rec in enumerate(recommendations, 1):
        severity_symbol = {
            'HIGH': '[!]',
            'MEDIUM': '[~]',
            'LOW': '[*]'
        }.get(rec['severity'], '[ ]')

        print(f"\n{severity_symbol} {rec['severity']}: {rec['category']}")
        print("-" * 80)
        print(f"Finding: {rec['finding']}")
        print(f"Recommendation: {rec['recommendation']}")

        if 'examples' in rec:
            print(f"Examples: {', '.join(rec['examples'][:3])}")
        if 'sessions' in rec:
            print(f"Affected sessions: {', '.join(rec['sessions'])}")
        if 'operation' in rec:
            print(f"Operation: {rec['operation']}")
        if 'action' in rec:
            print(f"Action: {rec['action']}")

    print()

def main():
    """Main execution"""
    try:
        print_header()

        # Load data
        sessions = load_sessions()
        operations = load_token_logs()

        if not sessions:
            print("[!] No session data found")
            return 1

        if not operations:
            print("[!] No token operation logs found")
            print("    Token-level analysis unavailable")
            operations = []

        # Analyze patterns
        patterns = analyze_high_cost_operations(operations) if operations else {'total_high_cost': 0, 'by_type': {}, 'top_consumers': []}
        session_patterns = analyze_session_patterns(sessions)
        repetitive = identify_repetitive_patterns(operations) if operations else []

        # Display results
        if operations:
            print_patterns(patterns)
        print_session_patterns(session_patterns)
        if operations:
            print_repetitive(repetitive)

        # Generate and show recommendations
        if '--recommendations' in sys.argv or True:  # Always show recommendations
            recommendations = generate_recommendations(patterns, session_patterns, repetitive)
            print_recommendations(recommendations)

        print("=" * 80)
        print()
        print("[TIP] Review recommendations and implement optimizations in next session")
        print("[TIP] Use telemetry data to track improvement over time")
        print()

        return 0

    except Exception as e:
        print(f"[ERROR] {e}")
        import traceback
        traceback.print_exc()
        return 1

if __name__ == "__main__":
    sys.exit(main())
