#!/usr/bin/env python3
"""
Telemetry Dashboard - Session Viewer
Part of Plan Maestro Phase 3: Scale

Usage:
    python scripts/telemetry-dashboard.py             # Show summary
    python scripts/telemetry-dashboard.py --detailed  # Show per-session details
    python scripts/telemetry-dashboard.py --export    # Export to markdown
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

        # Optional detailed view
        if '--detailed' in sys.argv:
            show_session_details(sessions)

        # Optional export
        if '--export' in sys.argv:
            timestamp = datetime.now().strftime("%Y%m%d-%H%M%S")
            export_report(sessions, metrics, f"telemetry/reports/dashboard-{timestamp}.md")

        print("=" * 70)
        print()
        print("[TIP] Use --detailed for per-session breakdown")
        print("[TIP] Use --export to generate markdown report")
        print()

        return 0

    except Exception as e:
        print(f"[ERROR] {e}")
        return 1

if __name__ == "__main__":
    sys.exit(main())
