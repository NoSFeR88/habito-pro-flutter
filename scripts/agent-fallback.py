#!/usr/bin/env python3
"""
Agent Fallback Strategy
Handles agent failures and provides resilient task execution.
"""

import json
import os
from datetime import datetime
from typing import Dict, List, Optional
import sys

sys.path.insert(0, os.path.dirname(__file__))
from agent_pool import AgentPool
from smart_router import SmartRouter


class FallbackStrategy:
    """Manages fallback strategies for agent failures."""

    def __init__(self):
        self.agent_pool = AgentPool()
        self.router = SmartRouter()
        self.failure_log = '.automation/fallback-log.json'
        self.alert_threshold = 2  # Alert after N consecutive failures
        os.makedirs(os.path.dirname(self.failure_log), exist_ok=True)

    def execute_with_fallback(
        self,
        task_description: str,
        changed_files: List[str] = None,
        max_retries: int = 3
    ) -> Dict:
        """
        Execute task with automatic fallback on failure.

        Args:
            task_description: Task description
            changed_files: List of changed files
            max_retries: Maximum retry attempts

        Returns:
            Execution result with agent used and fallback history
        """
        execution_history = []
        current_attempt = 0

        # Initial routing
        routing_decision = self.router.route_task(task_description, changed_files)

        if not routing_decision['success']:
            return {
                'success': False,
                'error': 'Initial routing failed',
                'history': []
            }

        primary_agent_id = routing_decision['agent_id']
        current_agent_id = primary_agent_id

        while current_attempt < max_retries:
            current_attempt += 1

            # Simulate task execution (in reality, this would call actual agent)
            result = self._execute_task(
                agent_id=current_agent_id,
                task_description=task_description,
                attempt=current_attempt
            )

            execution_history.append({
                'attempt': current_attempt,
                'agent_id': current_agent_id,
                'success': result['success'],
                'reason': result.get('reason', ''),
                'timestamp': datetime.now().isoformat()
            })

            if result['success']:
                # Success! Log and return
                self._log_success(
                    task_description,
                    current_agent_id,
                    execution_history
                )

                return {
                    'success': True,
                    'agent_id': current_agent_id,
                    'attempts': current_attempt,
                    'fallback_used': current_agent_id != primary_agent_id,
                    'history': execution_history,
                    'result': result
                }

            # Failure - determine fallback
            if current_attempt < max_retries:
                fallback_agent = self._select_fallback_agent(
                    current_agent_id,
                    routing_decision['task_type'],
                    execution_history
                )

                if fallback_agent:
                    current_agent_id = fallback_agent.id
                    print(f"⚠️  Attempt {current_attempt} failed. Falling back to {fallback_agent.name}...")
                else:
                    # No fallback available
                    break

        # All retries exhausted
        self._log_failure(task_description, execution_history)
        self._check_alert_threshold(primary_agent_id)

        return {
            'success': False,
            'error': 'All retry attempts exhausted',
            'attempts': current_attempt,
            'history': execution_history
        }

    def _execute_task(self, agent_id: str, task_description: str, attempt: int) -> Dict:
        """
        Simulate task execution (placeholder).
        In production, this would call the actual agent.
        """
        agent = self.agent_pool.get_agent(agent_id)

        if not agent:
            return {'success': False, 'reason': 'Agent not found'}

        # Simulate execution based on agent success rate
        # In production, this would be actual task execution
        import random
        success_roll = random.random()

        if success_roll <= agent.success_rate:
            return {
                'success': True,
                'tokens_used': agent.avg_tokens_per_task,
                'duration_minutes': agent.avg_duration_minutes
            }
        else:
            return {
                'success': False,
                'reason': f'Agent execution failed (simulated based on {agent.success_rate:.0%} success rate)'
            }

    def _select_fallback_agent(
        self,
        failed_agent_id: str,
        task_type: str,
        execution_history: List[Dict]
    ) -> Optional:
        """Select fallback agent after failure."""
        # Get agents with required skill
        candidates = self.agent_pool.get_agents_by_skill(task_type)

        # Filter out already tried agents
        tried_agents = {entry['agent_id'] for entry in execution_history}
        candidates = [a for a in candidates if a.id not in tried_agents]

        if not candidates:
            # No more candidates, try general agent if not already tried
            general = self.agent_pool.get_agent('general')
            if general and general.id not in tried_agents:
                return general
            return None

        # Sort by success rate
        candidates.sort(key=lambda a: a.success_rate, reverse=True)

        return candidates[0]

    def _log_success(
        self,
        task_description: str,
        agent_id: str,
        execution_history: List[Dict]
    ):
        """Log successful task execution."""
        log_entry = {
            'timestamp': datetime.now().isoformat(),
            'task_description': task_description,
            'final_agent_id': agent_id,
            'success': True,
            'attempts': len(execution_history),
            'history': execution_history
        }

        self._append_to_log(log_entry)

        # Update agent stats
        final_attempt = execution_history[-1]
        if 'result' in final_attempt:
            self.agent_pool.update_agent_stats(
                agent_id=agent_id,
                success=True,
                tokens_used=final_attempt['result'].get('tokens_used', 0),
                duration_minutes=final_attempt['result'].get('duration_minutes', 0)
            )

    def _log_failure(self, task_description: str, execution_history: List[Dict]):
        """Log failed task execution."""
        log_entry = {
            'timestamp': datetime.now().isoformat(),
            'task_description': task_description,
            'success': False,
            'attempts': len(execution_history),
            'history': execution_history
        }

        self._append_to_log(log_entry)

        # Update stats for all failed agents
        for entry in execution_history:
            if not entry['success']:
                self.agent_pool.update_agent_stats(
                    agent_id=entry['agent_id'],
                    success=False,
                    tokens_used=5000,  # Estimated tokens for failed attempt
                    duration_minutes=10  # Estimated duration for failed attempt
                )

    def _append_to_log(self, log_entry: Dict):
        """Append entry to fallback log."""
        logs = []
        if os.path.exists(self.failure_log):
            with open(self.failure_log, 'r', encoding='utf-8') as f:
                logs = json.load(f)

        logs.append(log_entry)

        # Keep last 100 entries
        logs = logs[-100:]

        with open(self.failure_log, 'w', encoding='utf-8') as f:
            json.dump(logs, f, indent=2)

    def _check_alert_threshold(self, agent_id: str):
        """Check if agent has exceeded failure threshold and alert."""
        if not os.path.exists(self.failure_log):
            return

        with open(self.failure_log, 'r', encoding='utf-8') as f:
            logs = json.load(f)

        # Count consecutive failures for this agent
        consecutive_failures = 0
        for entry in reversed(logs):
            if not entry['success'] and entry['history']:
                # Check if this agent was involved
                if any(h['agent_id'] == agent_id and not h['success'] for h in entry['history']):
                    consecutive_failures += 1
                else:
                    break

        if consecutive_failures >= self.alert_threshold:
            self._create_alert(agent_id, consecutive_failures)

    def _create_alert(self, agent_id: str, failure_count: int):
        """Create alert for agent with high failure rate."""
        agent = self.agent_pool.get_agent(agent_id)
        alert = {
            'timestamp': datetime.now().isoformat(),
            'agent_id': agent_id,
            'agent_name': agent.name if agent else 'Unknown',
            'consecutive_failures': failure_count,
            'severity': 'high' if failure_count >= 3 else 'medium',
            'recommendation': f'Review {agent.name if agent else agent_id} performance and routing decisions'
        }

        # Save alert
        alerts_file = '.automation/alerts/agent-failures.json'
        os.makedirs(os.path.dirname(alerts_file), exist_ok=True)

        alerts = []
        if os.path.exists(alerts_file):
            with open(alerts_file, 'r', encoding='utf-8') as f:
                alerts = json.load(f)

        alerts.append(alert)

        with open(alerts_file, 'w', encoding='utf-8') as f:
            json.dump(alerts, f, indent=2)

        print(f"⚠️  ALERT: {agent.name if agent else agent_id} has {failure_count} consecutive failures!")

    def get_fallback_stats(self) -> Dict:
        """Get fallback statistics."""
        if not os.path.exists(self.failure_log):
            return {
                'total_executions': 0,
                'successful': 0,
                'failed': 0,
                'fallback_used_count': 0,
                'avg_attempts': 0.0
            }

        with open(self.failure_log, 'r', encoding='utf-8') as f:
            logs = json.load(f)

        total = len(logs)
        successful = sum(1 for e in logs if e['success'])
        failed = total - successful
        fallback_used = sum(1 for e in logs if e.get('attempts', 1) > 1)
        avg_attempts = sum(e.get('attempts', 1) for e in logs) / total if total > 0 else 0

        return {
            'total_executions': total,
            'successful': successful,
            'failed': failed,
            'success_rate': successful / total if total > 0 else 0,
            'fallback_used_count': fallback_used,
            'fallback_used_percent': fallback_used / total * 100 if total > 0 else 0,
            'avg_attempts': round(avg_attempts, 2)
        }


def main():
    """CLI for fallback strategy testing."""
    if len(sys.argv) < 2:
        print("Usage: python agent-fallback.py [command] [args]")
        print("\nCommands:")
        print("  execute <description>   - Execute task with fallback")
        print("  stats                   - Show fallback statistics")
        print("\nExample:")
        print('  python agent-fallback.py execute "Add unit tests for habit provider"')
        return

    command = sys.argv[1]
    strategy = FallbackStrategy()

    if command == 'execute':
        if len(sys.argv) < 3:
            print("Error: Task description required")
            return

        description = ' '.join(sys.argv[2:])

        print(f"\n🚀 Executing task with fallback strategy...")
        print(f"Task: {description}\n")

        result = strategy.execute_with_fallback(description)

        if result['success']:
            print(f"\n✅ Task completed successfully!")
            print(f"Agent: {result['agent_id']}")
            print(f"Attempts: {result['attempts']}")
            if result['fallback_used']:
                print(f"⚠️  Fallback was used (primary agent failed)")
        else:
            print(f"\n❌ Task failed after {result['attempts']} attempts")
            print(f"Error: {result['error']}")

        print(f"\nExecution History:")
        for entry in result['history']:
            status = '✅' if entry['success'] else '❌'
            print(f"  {status} Attempt {entry['attempt']}: {entry['agent_id']} - {entry.get('reason', 'Success' if entry['success'] else 'Failed')}")

    elif command == 'stats':
        stats = strategy.get_fallback_stats()

        print(f"\n📊 Fallback Strategy Statistics\n")
        print(f"Total Executions: {stats['total_executions']}")
        print(f"Successful: {stats['successful']} ({stats['success_rate']:.0%})")
        print(f"Failed: {stats['failed']}")
        print(f"Fallback Used: {stats['fallback_used_count']} ({stats['fallback_used_percent']:.1f}%)")
        print(f"Average Attempts: {stats['avg_attempts']}")

    else:
        print(f"Unknown command: {command}")


if __name__ == '__main__':
    main()
