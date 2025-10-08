#!/usr/bin/env python3
"""
Automated Insights - Anomaly Detection & Proactive Alerts
Part of Plan Maestro Phase 3: Scale

Automatically detects:
- High token consumption sessions
- Low efficiency patterns
- Anomalies vs historical trends
- Proactive optimization opportunities

Usage:
    python scripts/automated-insights.py
    python scripts/automated-insights.py --alerts
"""

import json
import glob
import os
import sys
from datetime import datetime
from statistics import mean, stdev

# Configuration
SESSIONS_PATH = "telemetry/sessions"
HIGH_TOKENS_THRESHOLD = 100000
LOW_EFFICIENCY_THRESHOLD = 3.0
ANOMALY_STD_DEV = 2.0  # Standard deviations for anomaly detection

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

def calculate_efficiency(session):
    """Calculate efficiency for a session"""
    if session['tokens_used'] == 0:
        return 0
    return round((session['tasks_completed'] / (session['tokens_used'] / 10000)), 1)

def detect_high_token_sessions(sessions):
    """Detect sessions with abnormally high token usage"""
    alerts = []

    for s in sessions:
        if s['tokens_used'] > HIGH_TOKENS_THRESHOLD:
            alerts.append({
                'type': 'HIGH_TOKENS',
                'severity': 'HIGH',
                'session_id': s['session_id'],
                'tokens': s['tokens_used'],
                'threshold': HIGH_TOKENS_THRESHOLD,
                'message': f"Session {s['session_id']} used {s['tokens_used']:,} tokens (>{HIGH_TOKENS_THRESHOLD:,} threshold)"
            })

    return alerts

def detect_low_efficiency(sessions):
    """Detect sessions with low efficiency"""
    alerts = []

    for s in sessions:
        eff = calculate_efficiency(s)
        if eff < LOW_EFFICIENCY_THRESHOLD:
            alerts.append({
                'type': 'LOW_EFFICIENCY',
                'severity': 'MEDIUM',
                'session_id': s['session_id'],
                'efficiency': eff,
                'threshold': LOW_EFFICIENCY_THRESHOLD,
                'message': f"Session {s['session_id']} efficiency {eff} tasks/10k (<{LOW_EFFICIENCY_THRESHOLD} threshold)"
            })

    return alerts

def detect_anomalies(sessions):
    """Detect statistical anomalies in sessions"""
    if len(sessions) < 3:
        return []

    alerts = []

    # Token usage anomalies
    tokens = [s['tokens_used'] for s in sessions]
    tokens_mean = mean(tokens)
    tokens_std = stdev(tokens) if len(tokens) > 1 else 0

    for s in sessions:
        if tokens_std > 0:
            z_score = (s['tokens_used'] - tokens_mean) / tokens_std
            if abs(z_score) > ANOMALY_STD_DEV:
                alerts.append({
                    'type': 'ANOMALY_TOKENS',
                    'severity': 'MEDIUM',
                    'session_id': s['session_id'],
                    'value': s['tokens_used'],
                    'mean': round(tokens_mean, 0),
                    'z_score': round(z_score, 2),
                    'message': f"Session {s['session_id']} token usage anomaly: {s['tokens_used']:,} (z={z_score:.1f}, mean={tokens_mean:,.0f})"
                })

    # Efficiency anomalies
    efficiencies = [calculate_efficiency(s) for s in sessions]
    eff_mean = mean(efficiencies)
    eff_std = stdev(efficiencies) if len(efficiencies) > 1 else 0

    for s in sessions:
        eff = calculate_efficiency(s)
        if eff_std > 0:
            z_score = (eff - eff_mean) / eff_std
            if z_score < -ANOMALY_STD_DEV:  # Only alert on LOW efficiency anomalies
                alerts.append({
                    'type': 'ANOMALY_EFFICIENCY',
                    'severity': 'MEDIUM',
                    'session_id': s['session_id'],
                    'value': eff,
                    'mean': round(eff_mean, 1),
                    'z_score': round(z_score, 2),
                    'message': f"Session {s['session_id']} efficiency anomaly: {eff} tasks/10k (z={z_score:.1f}, mean={eff_mean:.1f})"
                })

    return alerts

def detect_declining_trend(sessions):
    """Detect if efficiency is declining over time"""
    if len(sessions) < 4:
        return []

    alerts = []

    # Split into older vs recent
    mid = len(sessions) // 2
    older = sessions[:mid]
    recent = sessions[mid:]

    older_eff = mean([calculate_efficiency(s) for s in older])
    recent_eff = mean([calculate_efficiency(s) for s in recent])

    # Alert if recent sessions are significantly worse
    if recent_eff < older_eff * 0.8:  # 20% decline
        pct_decline = ((older_eff - recent_eff) / older_eff * 100)
        alerts.append({
            'type': 'DECLINING_TREND',
            'severity': 'HIGH',
            'older_eff': round(older_eff, 1),
            'recent_eff': round(recent_eff, 1),
            'decline_pct': round(pct_decline, 1),
            'message': f"Efficiency declining: {older_eff:.1f} -> {recent_eff:.1f} tasks/10k (-{pct_decline:.1f}%)"
        })

    return alerts

def generate_recommendations(all_alerts):
    """Generate actionable recommendations based on alerts"""
    recommendations = []

    # High tokens alerts
    high_token_alerts = [a for a in all_alerts if a['type'] == 'HIGH_TOKENS']
    if high_token_alerts:
        recommendations.append({
            'priority': 'HIGH',
            'category': 'Token Optimization',
            'finding': f"{len(high_token_alerts)} sessions exceeded token threshold",
            'action': "Review and cache frequently accessed context. Use PROJECT_INDEX.md for quick lookups.",
            'sessions': [a['session_id'] for a in high_token_alerts]
        })

    # Low efficiency alerts
    low_eff_alerts = [a for a in all_alerts if a['type'] == 'LOW_EFFICIENCY']
    if len(low_eff_alerts) > len(all_alerts) * 0.5:  # More than 50% of sessions
        recommendations.append({
            'priority': 'HIGH',
            'category': 'Workflow Efficiency',
            'finding': f"{len(low_eff_alerts)} sessions with low efficiency ({len(low_eff_alerts)}/{len(all_alerts)})",
            'action': "Implement structured context loading. Break complex tasks into smaller steps.",
            'sessions': [a['session_id'] for a in low_eff_alerts[:3]]
        })

    # Declining trend
    declining_alerts = [a for a in all_alerts if a['type'] == 'DECLINING_TREND']
    if declining_alerts:
        alert = declining_alerts[0]
        recommendations.append({
            'priority': 'CRITICAL',
            'category': 'Performance Regression',
            'finding': f"Efficiency declining {alert['decline_pct']:.1f}%",
            'action': "URGENT: Investigate recent workflow changes. Compare recent vs older sessions.",
            'data': f"{alert['older_eff']} -> {alert['recent_eff']} tasks/10k"
        })

    return recommendations

def print_header():
    """Display header"""
    print()
    print("=" * 80)
    print("  AUTOMATED INSIGHTS - Anomaly Detection & Alerts")
    print("=" * 80)
    print()

def print_alerts(alerts):
    """Display alerts by severity"""
    if not alerts:
        print("[OK] No anomalies detected - all sessions within normal parameters")
        print()
        return

    # Group by severity
    critical = [a for a in alerts if a['severity'] == 'CRITICAL']
    high = [a for a in alerts if a['severity'] == 'HIGH']
    medium = [a for a in alerts if a['severity'] == 'MEDIUM']

    if critical:
        print("[CRITICAL ALERTS]")
        print("-" * 80)
        for alert in critical:
            print(f"[!!] {alert['message']}")
        print()

    if high:
        print("[HIGH PRIORITY ALERTS]")
        print("-" * 80)
        for alert in high:
            print(f"[!] {alert['message']}")
        print()

    if medium:
        print("[MEDIUM PRIORITY ALERTS]")
        print("-" * 80)
        for alert in medium:
            print(f"[~] {alert['message']}")
        print()

def print_recommendations(recommendations):
    """Display actionable recommendations"""
    if not recommendations:
        return

    print("[ACTIONABLE RECOMMENDATIONS]")
    print("=" * 80)

    for i, rec in enumerate(recommendations, 1):
        priority_symbol = {
            'CRITICAL': '[!!]',
            'HIGH': '[!]',
            'MEDIUM': '[~]'
        }.get(rec['priority'], '[ ]')

        print(f"\n{priority_symbol} {rec['priority']}: {rec['category']}")
        print("-" * 80)
        print(f"Finding: {rec['finding']}")
        print(f"Action:  {rec['action']}")

        if 'sessions' in rec:
            print(f"Affected: Sessions {', '.join(rec['sessions'])}")
        if 'data' in rec:
            print(f"Data:    {rec['data']}")

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

        print(f"Analyzing {len(sessions)} sessions...")
        print()

        # Run detections
        all_alerts = []

        all_alerts.extend(detect_high_token_sessions(sessions))
        all_alerts.extend(detect_low_efficiency(sessions))
        all_alerts.extend(detect_anomalies(sessions))
        all_alerts.extend(detect_declining_trend(sessions))

        # Display alerts
        print_alerts(all_alerts)

        # Generate and show recommendations
        recommendations = generate_recommendations(all_alerts)
        print_recommendations(recommendations)

        # Summary
        print("=" * 80)
        print()
        print(f"[SUMMARY] {len(all_alerts)} alerts detected, {len(recommendations)} recommendations")

        if all_alerts:
            print("[TIP] Review recommendations and address high-priority items first")
        else:
            print("[TIP] Keep monitoring for anomalies in future sessions")

        print()

        return 0

    except Exception as e:
        print(f"[ERROR] {e}")
        import traceback
        traceback.print_exc()
        return 1

if __name__ == "__main__":
    sys.exit(main())
