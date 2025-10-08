#!/usr/bin/env python3
"""
Telemetry Dashboard - Advanced Session Analytics
Part of Plan Maestro Phase 3: Scale

Features:
- Summary metrics with trends
- Visual charts (tokens, efficiency, tasks over time)
- Comparative analysis
- Export to markdown with embedded charts

Usage:
    python scripts/telemetry-dashboard.py             # Show summary + trends
    python scripts/telemetry-dashboard.py --detailed  # Show per-session details
    python scripts/telemetry-dashboard.py --export    # Export to markdown
    python scripts/telemetry-dashboard.py --charts    # Generate visual charts (requires matplotlib)
"""

import json
import glob
import os
import sys
from datetime import datetime
from pathlib import Path

# Configuration
SESSIONS_PATH = "telemetry/sessions"
MIN_EFFICIENCY = 5.0  # tasks per 10k tokens
MAX_TOKENS_PER_SESSION = 100000  # Alert threshold

# Try to import matplotlib for charts
try:
    import matplotlib.pyplot as plt
    import matplotlib.dates as mdates
    CHARTS_AVAILABLE = True
except ImportError:
    CHARTS_AVAILABLE = False

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

def calculate_metrics(sessions):
    """Calculate aggregate metrics"""
    total = {
        'sessions': len(sessions),
        'tokens': sum(s['tokens_used'] for s in sessions),
        'duration': sum(s['duration_minutes'] for s in sessions),
        'tasks': sum(s['tasks_completed'] for s in sessions)
    }

    total['avg_tokens'] = round(total['tokens'] / total['sessions'], 0) if total['sessions'] > 0 else 0
    total['avg_duration'] = round(total['duration'] / total['sessions'], 0) if total['sessions'] > 0 else 0
    total['avg_tasks'] = round(total['tasks'] / total['sessions'], 1) if total['sessions'] > 0 else 0
    total['efficiency'] = round((total['tasks'] / (total['tokens'] / 10000)), 1) if total['tokens'] > 0 else 0

    return total

def calculate_trends(sessions):
    """Calculate trends comparing recent vs older sessions"""
    if len(sessions) < 4:
        return None  # Not enough data for trend analysis

    # Split sessions: first half vs second half
    mid = len(sessions) // 2
    older = sessions[:mid]
    recent = sessions[mid:]

    def avg_efficiency(session_list):
        total_tasks = sum(s['tasks_completed'] for s in session_list)
        total_tokens = sum(s['tokens_used'] for s in session_list)
        return round((total_tasks / (total_tokens / 10000)), 1) if total_tokens > 0 else 0

    older_eff = avg_efficiency(older)
    recent_eff = avg_efficiency(recent)
    trend_pct = round(((recent_eff - older_eff) / older_eff * 100), 1) if older_eff > 0 else 0

    return {
        'older_efficiency': older_eff,
        'recent_efficiency': recent_eff,
        'trend_percent': trend_pct,
        'improving': recent_eff > older_eff
    }

def identify_best_worst(sessions):
    """Identify best and worst performing sessions"""
    if not sessions:
        return None

    sessions_with_eff = []
    for s in sessions:
        eff = round((s['tasks_completed'] / (s['tokens_used'] / 10000)), 1)
        sessions_with_eff.append({'session': s, 'efficiency': eff})

    sorted_sessions = sorted(sessions_with_eff, key=lambda x: x['efficiency'], reverse=True)

    return {
        'best': sorted_sessions[0],
        'worst': sorted_sessions[-1]
    }

def show_header():
    """Display dashboard header"""
    print()
    print("=" * 70)
    print("  TELEMETRY DASHBOARD - Claude Code Sessions")
    print("=" * 70)
    print()

def show_summary(sessions, metrics):
    """Display summary metrics"""
    print("[SUMMARY]")
    print("-" * 70)
    print(f"Total Sessions:       {metrics['sessions']}")
    print(f"Total Tokens Used:    {metrics['tokens']:,}")
    hours = round(metrics['duration'] / 60, 1)
    print(f"Total Duration:       {metrics['duration']} min / {hours} h")
    print(f"Total Tasks:          {metrics['tasks']}")
    print()

    print("[AVERAGES]")
    print("-" * 70)
    print(f"Avg Tokens/Session:   {int(metrics['avg_tokens']):,}")
    print(f"Avg Duration/Session: {int(metrics['avg_duration'])} min")
    print(f"Avg Tasks/Session:    {metrics['avg_tasks']}")
    print()

    eff_status = "[OK] GOOD" if metrics['efficiency'] >= MIN_EFFICIENCY else "[!] NEEDS IMPROVEMENT"
    print("[EFFICIENCY]")
    print("-" * 70)
    print(f"Tasks per 10k tokens: {metrics['efficiency']} {eff_status}")
    print(f"Target:               {MIN_EFFICIENCY}+")
    print()

def show_trends(trends):
    """Display trend analysis"""
    if not trends:
        print("[TRENDS]")
        print("-" * 70)
        print("Not enough data (need 4+ sessions)")
        print()
        return

    print("[TRENDS]")
    print("-" * 70)
    print(f"Older sessions avg:   {trends['older_efficiency']} tasks/10k")
    print(f"Recent sessions avg:  {trends['recent_efficiency']} tasks/10k")

    trend_symbol = "UP" if trends['improving'] else "DOWN"
    trend_status = "[OK] IMPROVING" if trends['improving'] else "[!] DECLINING"
    print(f"Trend:                {trend_symbol} {trends['trend_percent']:+.1f}% {trend_status}")
    print()

def show_best_worst(best_worst):
    """Display best and worst sessions"""
    if not best_worst:
        return

    print("[PERFORMANCE HIGHLIGHTS]")
    print("-" * 70)

    best = best_worst['best']
    print(f"[*] Best Session:  {best['session']['session_id']} ({best['efficiency']} tasks/10k)")
    print(f"    Date: {best['session']['date']}, Tasks: {best['session']['tasks_completed']}, Tokens: {best['session']['tokens_used']:,}")

    worst = best_worst['worst']
    print(f"[!] Worst Session: {worst['session']['session_id']} ({worst['efficiency']} tasks/10k)")
    print(f"    Date: {worst['session']['date']}, Tasks: {worst['session']['tasks_completed']}, Tokens: {worst['session']['tokens_used']:,}")
    print()

def show_session_details(sessions):
    """Display per-session breakdown"""
    print("[SESSION DETAILS]")
    print("-" * 70)
    print()

    for session in sessions:
        efficiency = round((session['tasks_completed'] / (session['tokens_used'] / 10000)), 1)
        eff_status = "[OK]" if efficiency >= MIN_EFFICIENCY else "[!]"

        print(f"Session {session['session_id']} ({session['date']})")
        print(f"  Duration: {session['duration_minutes']} min | Tokens: {session['tokens_used']:,} | Tasks: {session['tasks_completed']}")
        print(f"  Efficiency: {efficiency} tasks/10k {eff_status}")

        if session.get('notes'):
            print(f"  Notes: {session['notes']}")

        # Alerts
        if session['tokens_used'] > MAX_TOKENS_PER_SESSION:
            print(f"  [!] HIGH TOKEN USAGE")
        if efficiency < MIN_EFFICIENCY:
            print(f"  [!] LOW EFFICIENCY")

        print()

def export_report(sessions, metrics, path="telemetry/reports/dashboard.md"):
    """Export dashboard to markdown"""
    os.makedirs(os.path.dirname(path), exist_ok=True)

    report = f"""# Telemetry Dashboard Report

**Generated**: {datetime.now().strftime("%Y-%m-%d %H:%M:%S")}

---

## Summary

| Metric | Value |
|--------|-------|
| **Total Sessions** | {metrics['sessions']} |
| **Total Tokens Used** | {metrics['tokens']:,} |
| **Total Duration** | {metrics['duration']} min ({round(metrics['duration'] / 60, 1)} hours) |
| **Total Tasks** | {metrics['tasks']} |

## 📊 Averages

| Metric | Value |
|--------|-------|
| **Tokens/Session** | {int(metrics['avg_tokens']):,} |
| **Duration/Session** | {int(metrics['avg_duration'])} min |
| **Tasks/Session** | {metrics['avg_tasks']} |

## ⚡ Efficiency

| Metric | Value | Status |
|--------|-------|--------|
| **Tasks per 10k tokens** | {metrics['efficiency']} | {'✅ GOOD' if metrics['efficiency'] >= MIN_EFFICIENCY else '⚠️ NEEDS IMPROVEMENT'} |
| **Target** | {MIN_EFFICIENCY}+ | - |

---

## 📋 Session Details

| Session | Date | Duration | Tokens | Tasks | Efficiency |
|---------|------|----------|--------|-------|------------|
"""

    for session in sessions:
        efficiency = round((session['tasks_completed'] / (session['tokens_used'] / 10000)), 1)
        report += f"| {session['session_id']} | {session['date']} | {session['duration_minutes']} min | {session['tokens_used']:,} | {session['tasks_completed']} | {efficiency} |\n"

    report += f"""

---

**Notes**:
- Efficiency Target: {MIN_EFFICIENCY}+ tasks per 10k tokens
- Token Alert Threshold: {MAX_TOKENS_PER_SESSION:,} tokens per session
- Sessions with low efficiency or high token usage should be reviewed for optimization opportunities

---

*Generated by: telemetry-dashboard.py*
*Part of: Plan Maestro Phase 3 - Scale*
"""

    with open(path, 'w', encoding='utf-8') as f:
        f.write(report)

    print(f"[OK] Report exported to: {path}")

def generate_charts(sessions, output_dir="telemetry/charts"):
    """Generate visual charts using matplotlib"""
    if not CHARTS_AVAILABLE:
        print("[!] Charts unavailable: matplotlib not installed")
        print("    Install with: pip install matplotlib")
        return False

    os.makedirs(output_dir, exist_ok=True)

    # Prepare data
    session_ids = [s['session_id'] for s in sessions]
    tokens = [s['tokens_used'] for s in sessions]
    tasks = [s['tasks_completed'] for s in sessions]
    durations = [s['duration_minutes'] for s in sessions]
    efficiencies = [round((s['tasks_completed'] / (s['tokens_used'] / 10000)), 1) for s in sessions]

    # Chart 1: Tokens over time
    plt.figure(figsize=(12, 4))
    plt.subplot(1, 3, 1)
    plt.bar(session_ids, tokens, color='steelblue')
    plt.axhline(y=MAX_TOKENS_PER_SESSION, color='r', linestyle='--', label=f'Alert threshold ({MAX_TOKENS_PER_SESSION:,})')
    plt.xlabel('Session ID')
    plt.ylabel('Tokens Used')
    plt.title('Token Consumption per Session')
    plt.xticks(rotation=45)
    plt.legend()
    plt.tight_layout()

    # Chart 2: Efficiency over time
    plt.subplot(1, 3, 2)
    plt.plot(session_ids, efficiencies, marker='o', color='green', linewidth=2)
    plt.axhline(y=MIN_EFFICIENCY, color='orange', linestyle='--', label=f'Target ({MIN_EFFICIENCY})')
    plt.xlabel('Session ID')
    plt.ylabel('Efficiency (tasks/10k tokens)')
    plt.title('Efficiency Trend')
    plt.xticks(rotation=45)
    plt.legend()
    plt.tight_layout()

    # Chart 3: Tasks completed
    plt.subplot(1, 3, 3)
    plt.bar(session_ids, tasks, color='teal')
    plt.xlabel('Session ID')
    plt.ylabel('Tasks Completed')
    plt.title('Tasks Completed per Session')
    plt.xticks(rotation=45)
    plt.tight_layout()

    chart_path = os.path.join(output_dir, f"dashboard-{datetime.now().strftime('%Y%m%d-%H%M%S')}.png")
    plt.savefig(chart_path, dpi=150, bbox_inches='tight')
    print(f"[OK] Charts saved to: {chart_path}")

    plt.close()
    return True

def main():
    """Main execution"""
    try:
        show_header()

        # Load data
        sessions = load_sessions()

        if not sessions:
            print(f"[!] No session data found in {SESSIONS_PATH}")
            return 1

        # Calculate metrics
        metrics = calculate_metrics(sessions)

        # Show summary
        show_summary(sessions, metrics)

        # Show trends
        trends = calculate_trends(sessions)
        show_trends(trends)

        # Show best/worst
        best_worst = identify_best_worst(sessions)
        show_best_worst(best_worst)

        # Optional detailed view
        if '--detailed' in sys.argv:
            show_session_details(sessions)

        # Optional export
        if '--export' in sys.argv:
            timestamp = datetime.now().strftime("%Y%m%d-%H%M%S")
            export_report(sessions, metrics, f"telemetry/reports/dashboard-{timestamp}.md")

        # Optional charts
        if '--charts' in sys.argv:
            generate_charts(sessions)

        print("=" * 70)
        print()
        print("[TIP] Use --detailed for per-session breakdown")
        print("[TIP] Use --export to generate markdown report")
        print("[TIP] Use --charts to generate visual charts (requires matplotlib)")
        print()

        return 0

    except Exception as e:
        print(f"[ERROR] {e}")
        return 1

if __name__ == "__main__":
    sys.exit(main())
