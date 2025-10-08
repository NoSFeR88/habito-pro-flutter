#!/usr/bin/env python3
"""
Smart Router Algorithm
Routes tasks to the best agent based on classification and performance.
"""

import json
import os
import sys
from datetime import datetime
from typing import Dict, Optional

# Import our other modules
sys.path.insert(0, os.path.dirname(__file__))
from agent_pool import AgentPool
from classify_task import TaskClassifier


class SmartRouter:
    """Routes tasks to optimal agents."""

    def __init__(self):
        self.agent_pool = AgentPool()
        self.classifier = TaskClassifier()
        self.routing_log = '.automation/routing-log.json'
        os.makedirs(os.path.dirname(self.routing_log), exist_ok=True)

    def route_task(
        self,
        description: str,
        changed_files: list = None,
        commit_message: str = None,
        complexity: str = None
    ) -> Dict:
        """
        Route a task to the best agent.

        Args:
            description: Task description
            changed_files: List of changed files (optional)
            commit_message: Commit message (optional)
            complexity: Override complexity (simple/moderate/complex/very_complex)

        Returns:
            Routing decision with agent, reasoning, and confidence
        """
        # Step 1: Classify the task
        classification = self.classifier.classify(
            description=description,
            changed_files=changed_files or [],
            commit_message=commit_message
        )

        task_type = classification['task_type']
        confidence = classification['confidence']
        detected_complexity = classification.get('typical_complexity', 'moderate')

        # Use provided complexity or detected one
        final_complexity = complexity or detected_complexity

        # Step 2: Select best agent
        agent = self.agent_pool.select_best_agent(task_type, final_complexity)

        if not agent:
            return {
                'success': False,
                'error': 'No suitable agent found',
                'classification': classification
            }

        # Step 3: Calculate routing confidence
        # Combine classification confidence with agent success rate
        routing_confidence = (confidence + agent.success_rate) / 2

        # Step 4: Build reasoning
        reasoning = [
            f"Task classified as '{task_type}' with {confidence:.0%} confidence",
            f"Agent '{agent.name}' selected (success rate: {agent.success_rate:.0%})",
            f"Expected cost multiplier: {agent.cost_multiplier}x",
            f"Estimated tokens: {agent.avg_tokens_per_task:,}",
            f"Estimated duration: {agent.avg_duration_minutes} minutes"
        ]

        # Add classification reasoning
        if classification['reasoning']:
            reasoning.append(f"Classification based on: {', '.join(classification['reasoning'])}")

        # Step 5: Calculate projected savings
        baseline_tokens = 10000  # Baseline for manual workflow
        projected_tokens = agent.avg_tokens_per_task
        savings_percent = max(0, (baseline_tokens - projected_tokens) / baseline_tokens * 100)

        # Step 6: Build routing decision
        decision = {
            'success': True,
            'agent_id': agent.id,
            'agent_name': agent.name,
            'task_type': task_type,
            'complexity': final_complexity,
            'confidence': round(routing_confidence, 2),
            'classification': classification,
            'estimated_tokens': agent.avg_tokens_per_task,
            'estimated_duration_minutes': agent.avg_duration_minutes,
            'cost_multiplier': agent.cost_multiplier,
            'projected_savings_percent': round(savings_percent, 1),
            'reasoning': reasoning,
            'alternatives': []
        }

        # Step 7: Find alternative agents
        all_agents = self.agent_pool.get_agents_by_skill(task_type)
        for alt_agent in all_agents[:3]:  # Top 3
            if alt_agent.id != agent.id:
                decision['alternatives'].append({
                    'agent_id': alt_agent.id,
                    'agent_name': alt_agent.name,
                    'success_rate': alt_agent.success_rate,
                    'cost_multiplier': alt_agent.cost_multiplier
                })

        # Step 8: Log routing decision
        self._log_routing(decision, description)

        return decision

    def _log_routing(self, decision: Dict, description: str):
        """Log routing decision for analysis."""
        log_entry = {
            'timestamp': datetime.now().isoformat(),
            'description': description,
            'decision': decision
        }

        logs = []
        if os.path.exists(self.routing_log):
            with open(self.routing_log, 'r', encoding='utf-8') as f:
                logs = json.load(f)

        logs.append(log_entry)

        # Keep last 100 entries
        logs = logs[-100:]

        with open(self.routing_log, 'w', encoding='utf-8') as f:
            json.dump(logs, f, indent=2)

    def get_routing_stats(self) -> Dict:
        """Get routing statistics."""
        if not os.path.exists(self.routing_log):
            return {
                'total_routings': 0,
                'by_agent': {},
                'by_task_type': {},
                'avg_confidence': 0.0
            }

        with open(self.routing_log, 'r', encoding='utf-8') as f:
            logs = json.load(f)

        if not logs:
            return {
                'total_routings': 0,
                'by_agent': {},
                'by_task_type': {},
                'avg_confidence': 0.0
            }

        by_agent = {}
        by_task_type = {}
        confidences = []

        for entry in logs:
            decision = entry['decision']

            agent_id = decision['agent_id']
            task_type = decision['task_type']
            confidence = decision['confidence']

            by_agent[agent_id] = by_agent.get(agent_id, 0) + 1
            by_task_type[task_type] = by_task_type.get(task_type, 0) + 1
            confidences.append(confidence)

        return {
            'total_routings': len(logs),
            'by_agent': by_agent,
            'by_task_type': by_task_type,
            'avg_confidence': round(sum(confidences) / len(confidences), 2) if confidences else 0.0,
            'high_confidence_count': sum(1 for c in confidences if c >= 0.7),
            'high_confidence_percent': round(sum(1 for c in confidences if c >= 0.7) / len(confidences) * 100, 1) if confidences else 0.0
        }

    def route_from_pr(self, pr_number: int = None) -> Dict:
        """Route based on PR analysis (integrates with analyze-pr.py)."""
        analysis_file = f'.automation/pr-analysis/pr-{pr_number}.json' if pr_number else None

        if not analysis_file or not os.path.exists(analysis_file):
            return {'success': False, 'error': 'PR analysis not found'}

        with open(analysis_file, 'r', encoding='utf-8') as f:
            analysis = json.load(f)

        # Extract info from analysis
        description = f"PR #{pr_number}: {analysis.get('complexity', 'unknown')} complexity"
        changed_files = analysis.get('diff', {}).get('changed_files', [])
        complexity = analysis.get('complexity', 'moderate')

        return self.route_task(
            description=description,
            changed_files=changed_files,
            complexity=complexity
        )


def main():
    """CLI for smart routing."""
    if len(sys.argv) < 2:
        print("Usage: python smart-router.py [command] [args]")
        print("\nCommands:")
        print("  route <description>              - Route a task")
        print("  route-pr <pr_number>             - Route based on PR analysis")
        print("  stats                            - Show routing statistics")
        print("\nExamples:")
        print('  python smart-router.py route "Add unit tests for habit provider"')
        print('  python smart-router.py route "Fix overflow in stats screen"')
        print('  python smart-router.py route-pr 27')
        print('  python smart-router.py stats')
        return

    command = sys.argv[1]
    router = SmartRouter()

    if command == 'route':
        if len(sys.argv) < 3:
            print("Error: Description required")
            return

        description = ' '.join(sys.argv[2:])
        decision = router.route_task(description)

        if not decision['success']:
            print(f"\n❌ Routing failed: {decision.get('error', 'Unknown error')}")
            return

        print(f"\n🎯 Smart Routing Decision\n")
        print(f"Task: {description}")
        print(f"\n✅ Selected Agent: {decision['agent_name']} (id: {decision['agent_id']})")
        print(f"Task Type: {decision['task_type']}")
        print(f"Complexity: {decision['complexity']}")
        print(f"Confidence: {decision['confidence']:.0%}")
        print(f"\n📊 Estimates:")
        print(f"  Tokens: {decision['estimated_tokens']:,}")
        print(f"  Duration: {decision['estimated_duration_minutes']} minutes")
        print(f"  Cost Multiplier: {decision['cost_multiplier']}x")
        print(f"  Projected Savings: {decision['projected_savings_percent']:.1f}%")
        print(f"\n💡 Reasoning:")
        for reason in decision['reasoning']:
            print(f"  - {reason}")

        if decision['alternatives']:
            print(f"\n🔄 Alternatives:")
            for alt in decision['alternatives']:
                print(f"  - {alt['agent_name']} (success: {alt['success_rate']:.0%}, cost: {alt['cost_multiplier']}x)")

    elif command == 'route-pr':
        if len(sys.argv) < 3:
            print("Error: PR number required")
            return

        pr_number = int(sys.argv[2])
        decision = router.route_from_pr(pr_number)

        if not decision['success']:
            print(f"\n❌ Routing failed: {decision.get('error', 'Unknown error')}")
            print("💡 Run analyze-pr.py first to generate PR analysis")
            return

        print(f"\n🎯 Smart Routing for PR #{pr_number}\n")
        print(f"✅ Selected Agent: {decision['agent_name']}")
        print(f"Confidence: {decision['confidence']:.0%}")
        print(f"Estimated: {decision['estimated_tokens']:,} tokens, {decision['estimated_duration_minutes']} min")

    elif command == 'stats':
        stats = router.get_routing_stats()

        print(f"\n📊 Routing Statistics\n")
        print(f"Total Routings: {stats['total_routings']}")
        print(f"Average Confidence: {stats['avg_confidence']:.0%}")
        print(f"High Confidence (≥70%): {stats.get('high_confidence_count', 0)} ({stats.get('high_confidence_percent', 0):.1f}%)")

        if stats['by_agent']:
            print(f"\nBy Agent:")
            for agent_id, count in sorted(stats['by_agent'].items(), key=lambda x: x[1], reverse=True):
                percent = (count / stats['total_routings'] * 100) if stats['total_routings'] > 0 else 0
                print(f"  {agent_id}: {count} ({percent:.1f}%)")

        if stats['by_task_type']:
            print(f"\nBy Task Type:")
            for task_type, count in sorted(stats['by_task_type'].items(), key=lambda x: x[1], reverse=True):
                percent = (count / stats['total_routings'] * 100) if stats['total_routings'] > 0 else 0
                print(f"  {task_type}: {count} ({percent:.1f}%)")

    else:
        print(f"Unknown command: {command}")


if __name__ == '__main__':
    main()
