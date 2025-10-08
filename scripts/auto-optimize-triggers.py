#!/usr/bin/env python3
"""
Auto-Optimization Triggers
Detects when to apply optimizations automatically and creates GitHub issues.
"""

import json
import os
import glob
from datetime import datetime, timedelta
from typing import Dict, List, Optional


class OptimizationTriggers:
    """Manages automatic optimization triggers."""

    def __init__(self, telemetry_dir: str = 'telemetry/sessions'):
        self.telemetry_dir = telemetry_dir
        self.triggers_file = '.automation/triggers/active-triggers.json'
        self.issues_created_file = '.automation/triggers/issues-created.json'
        os.makedirs(os.path.dirname(self.triggers_file), exist_ok=True)
        self.thresholds = {
            'low_efficiency': 3.0,  # tasks/10k tokens
            'high_tokens': 100000,  # tokens per session
            'consecutive_low': 2,   # consecutive low-efficiency sessions
            'declining_trend': 3,   # sessions to check for decline
            'coverage_min': 70.0,   # minimum coverage percentage
        }

    def load_sessions(self, last_n: int = 10) -> List[Dict]:
        """Load last N sessions."""
        session_files = glob.glob(f'{self.telemetry_dir}/session-*.json')
        session_files.sort(key=os.path.getmtime, reverse=True)

        sessions = []
        for file_path in session_files[:last_n]:
            try:
                with open(file_path, 'r', encoding='utf-8') as f:
                    sessions.append(json.load(f))
            except Exception as e:
                print(f"Warning: Could not load {file_path}: {e}")

        return sessions

    def check_low_efficiency_trigger(self, sessions: List[Dict]) -> Optional[Dict]:
        """Check if efficiency is consistently low."""
        if len(sessions) < self.thresholds['consecutive_low']:
            return None

        recent_sessions = sessions[:self.thresholds['consecutive_low']]
        all_low = all(
            s.get('efficiency', 0) < self.thresholds['low_efficiency']
            for s in recent_sessions
        )

        if all_low:
            avg_efficiency = sum(s.get('efficiency', 0) for s in recent_sessions) / len(recent_sessions)
            return {
                'trigger_id': 'low_efficiency',
                'severity': 'high',
                'title': f'Low Efficiency Alert: {avg_efficiency:.1f} tasks/10k (target: {self.thresholds["low_efficiency"]})',
                'description': f'Last {len(recent_sessions)} sessions averaged {avg_efficiency:.1f} tasks/10k tokens, below target of {self.thresholds["low_efficiency"]}.',
                'recommendations': [
                    'Review workflow templates in `docs/WORKFLOW_TEMPLATES.md`',
                    'Use context caching: `python scripts/context-cache.py --warm`',
                    'Apply optimized bootstrap: `scripts/optimized-bootstrap.ps1`',
                    'Check automated insights: `python scripts/automated-insights.py`'
                ],
                'sessions_analyzed': [s.get('session_id') for s in recent_sessions],
                'metrics': {
                    'avg_efficiency': avg_efficiency,
                    'threshold': self.thresholds['low_efficiency'],
                    'deficit': self.thresholds['low_efficiency'] - avg_efficiency
                }
            }

        return None

    def check_high_tokens_trigger(self, sessions: List[Dict]) -> Optional[Dict]:
        """Check if any session used excessive tokens."""
        high_token_sessions = [
            s for s in sessions
            if s.get('tokens_used', 0) > self.thresholds['high_tokens']
        ]

        if high_token_sessions:
            session = high_token_sessions[0]  # Most recent
            return {
                'trigger_id': 'high_tokens',
                'severity': 'medium',
                'title': f'High Token Usage: {session.get("tokens_used", 0):,} tokens',
                'description': f'Session {session.get("session_id")} used {session.get("tokens_used", 0):,} tokens, exceeding threshold of {self.thresholds["high_tokens"]:,}.',
                'recommendations': [
                    'Use targeted access patterns from `docs/EFFICIENCY_BEST_PRACTICES.md`',
                    'Enable context caching for repeated reads',
                    'Break large tasks into smaller chunks',
                    'Review `docs/QUICK_START_OPTIMIZED.md` for optimization strategies'
                ],
                'sessions_analyzed': [session.get('session_id')],
                'metrics': {
                    'tokens_used': session.get('tokens_used', 0),
                    'threshold': self.thresholds['high_tokens'],
                    'excess': session.get('tokens_used', 0) - self.thresholds['high_tokens']
                }
            }

        return None

    def check_declining_trend_trigger(self, sessions: List[Dict]) -> Optional[Dict]:
        """Check if efficiency is declining over time."""
        if len(sessions) < self.thresholds['declining_trend']:
            return None

        recent = sessions[:self.thresholds['declining_trend']]
        efficiencies = [s.get('efficiency', 0) for s in recent]

        # Simple linear trend check
        older_avg = sum(efficiencies[len(efficiencies)//2:]) / (len(efficiencies) - len(efficiencies)//2)
        newer_avg = sum(efficiencies[:len(efficiencies)//2]) / len(efficiencies)//2

        decline_percent = ((older_avg - newer_avg) / older_avg * 100) if older_avg > 0 else 0

        if decline_percent > 20:  # 20% decline
            return {
                'trigger_id': 'declining_trend',
                'severity': 'medium',
                'title': f'Declining Efficiency Trend: -{decline_percent:.1f}%',
                'description': f'Efficiency declined {decline_percent:.1f}% over last {len(recent)} sessions (from {older_avg:.1f} to {newer_avg:.1f} tasks/10k).',
                'recommendations': [
                    'Run automated insights: `python scripts/automated-insights.py`',
                    'Review recent sessions for common patterns',
                    'Check if task complexity increased recently',
                    'Consider applying A/B testing to validate optimizations'
                ],
                'sessions_analyzed': [s.get('session_id') for s in recent],
                'metrics': {
                    'older_avg': older_avg,
                    'newer_avg': newer_avg,
                    'decline_percent': decline_percent
                }
            }

        return None

    def check_all_triggers(self) -> List[Dict]:
        """Check all triggers and return active ones."""
        sessions = self.load_sessions(last_n=10)

        if not sessions:
            print("No sessions found for analysis")
            return []

        triggers = []

        # Check each trigger type
        low_eff = self.check_low_efficiency_trigger(sessions)
        if low_eff:
            triggers.append(low_eff)

        high_tok = self.check_high_tokens_trigger(sessions)
        if high_tok:
            triggers.append(high_tok)

        decline = self.check_declining_trend_trigger(sessions)
        if decline:
            triggers.append(decline)

        return triggers

    def save_triggers(self, triggers: List[Dict]):
        """Save active triggers to file."""
        data = {
            'timestamp': datetime.now().isoformat(),
            'triggers': triggers,
            'count': len(triggers)
        }

        with open(self.triggers_file, 'w', encoding='utf-8') as f:
            json.dump(data, f, indent=2)

    def load_issues_created(self) -> List[str]:
        """Load list of already created issue IDs."""
        if not os.path.exists(self.issues_created_file):
            return []

        try:
            with open(self.issues_created_file, 'r', encoding='utf-8') as f:
                data = json.load(f)
                return data.get('issue_ids', [])
        except Exception:
            return []

    def save_issue_created(self, trigger_id: str, issue_number: int):
        """Record that issue was created for trigger."""
        issues = self.load_issues_created()

        issue_id = f"{trigger_id}-{datetime.now().strftime('%Y%m%d')}"
        if issue_id not in issues:
            issues.append(issue_id)

        data = {
            'issue_ids': issues,
            'last_updated': datetime.now().isoformat()
        }

        with open(self.issues_created_file, 'w', encoding='utf-8') as f:
            json.dump(data, f, indent=2)

    def create_github_issue(self, trigger: Dict) -> bool:
        """Create GitHub issue for trigger (placeholder - requires gh CLI)."""
        # Check if already created today
        issue_id = f"{trigger['trigger_id']}-{datetime.now().strftime('%Y%m%d')}"
        existing_issues = self.load_issues_created()

        if issue_id in existing_issues:
            print(f"⏭️  Issue already created for {trigger['trigger_id']} today")
            return False

        # Format issue body
        body = f"## {trigger['title']}\n\n"
        body += f"**Severity**: {trigger['severity'].upper()}\n\n"
        body += f"### Description\n\n{trigger['description']}\n\n"
        body += "### Recommendations\n\n"
        for i, rec in enumerate(trigger['recommendations'], 1):
            body += f"{i}. {rec}\n"
        body += "\n### Metrics\n\n```json\n"
        body += json.dumps(trigger['metrics'], indent=2)
        body += "\n```\n\n"
        body += f"**Sessions Analyzed**: {', '.join(trigger['sessions_analyzed'])}\n\n"
        body += "---\n*Auto-generated by optimization trigger system*\n"

        # Save issue draft
        os.makedirs('.automation/issues', exist_ok=True)
        issue_file = f".automation/issues/{trigger['trigger_id']}-{datetime.now().strftime('%Y%m%d-%H%M%S')}.md"

        with open(issue_file, 'w', encoding='utf-8') as f:
            f.write(body)

        print(f"✅ Issue draft saved to: {issue_file}")
        print(f"📝 To create on GitHub, run:")
        print(f"   gh issue create --title \"{trigger['title']}\" --body-file \"{issue_file}\" --label optimization,auto-generated")

        # Record that we "created" the issue (draft)
        self.save_issue_created(trigger['trigger_id'], 0)

        return True


def main():
    """Main entry point."""
    print("🔍 Checking optimization triggers...\n")

    manager = OptimizationTriggers()
    triggers = manager.check_all_triggers()

    if not triggers:
        print("✅ No triggers activated - system performing well!")
        return 0

    print(f"⚠️  {len(triggers)} trigger(s) activated:\n")

    for i, trigger in enumerate(triggers, 1):
        severity_emoji = {
            'high': '🔴',
            'medium': '🟡',
            'low': '🟢'
        }.get(trigger['severity'], '⚪')

        print(f"{i}. {severity_emoji} {trigger['title']}")
        print(f"   Severity: {trigger['severity'].upper()}")
        print(f"   Description: {trigger['description']}")
        print(f"   Recommendations: {len(trigger['recommendations'])} actions")
        print()

    # Save triggers
    manager.save_triggers(triggers)
    print(f"✅ Triggers saved to: {manager.triggers_file}\n")

    # Create issues
    issues_created = 0
    for trigger in triggers:
        if manager.create_github_issue(trigger):
            issues_created += 1

    if issues_created > 0:
        print(f"\n✅ {issues_created} issue draft(s) created in .automation/issues/")
        print("💡 Review and create on GitHub using gh CLI commands above")

    return 1 if triggers else 0


if __name__ == '__main__':
    import sys
    sys.exit(main())
