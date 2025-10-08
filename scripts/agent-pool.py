#!/usr/bin/env python3
"""
Agent Pool Manager
Manages a pool of specialized agents for different task types.
"""

import json
import os
from datetime import datetime
from typing import Dict, List, Optional
from dataclasses import dataclass, asdict


@dataclass
class Agent:
    """Represents a specialized agent."""
    id: str
    name: str
    description: str
    skills: List[str]
    cost_multiplier: float  # 1.0 = baseline cost
    success_rate: float  # Historical success rate (0.0-1.0)
    avg_tokens_per_task: int
    avg_duration_minutes: int
    tasks_completed: int
    tasks_failed: int
    available: bool = True

    def to_dict(self) -> Dict:
        """Convert to dictionary."""
        return asdict(self)

    @classmethod
    def from_dict(cls, data: Dict) -> 'Agent':
        """Create from dictionary."""
        return cls(**data)


class AgentPool:
    """Manages pool of specialized agents."""

    def __init__(self, config_path: str = '.automation/config/agents.json'):
        self.config_path = config_path
        self.agents: Dict[str, Agent] = {}
        self.telemetry_dir = 'telemetry/agents'
        os.makedirs(os.path.dirname(config_path), exist_ok=True)
        os.makedirs(self.telemetry_dir, exist_ok=True)
        self._load_agents()

    def _load_agents(self):
        """Load agents from config file."""
        if os.path.exists(self.config_path):
            with open(self.config_path, 'r', encoding='utf-8') as f:
                data = json.load(f)
                self.agents = {
                    agent_id: Agent.from_dict(agent_data)
                    for agent_id, agent_data in data.get('agents', {}).items()
                }
        else:
            # Initialize with default agents
            self._create_default_agents()

    def _create_default_agents(self):
        """Create default specialized agents."""
        default_agents = [
            Agent(
                id='general',
                name='General Purpose Agent',
                description='Versatile agent for all task types',
                skills=['refactor', 'feature', 'bugfix', 'testing', 'i18n', 'docs'],
                cost_multiplier=1.0,
                success_rate=0.85,
                avg_tokens_per_task=8000,
                avg_duration_minutes=30,
                tasks_completed=0,
                tasks_failed=0
            ),
            Agent(
                id='refactor-specialist',
                name='Refactoring Specialist',
                description='Expert in code refactoring and architecture',
                skills=['refactor', 'architecture', 'patterns', 'solid'],
                cost_multiplier=0.8,
                success_rate=0.90,
                avg_tokens_per_task=6000,
                avg_duration_minutes=25,
                tasks_completed=0,
                tasks_failed=0
            ),
            Agent(
                id='testing-specialist',
                name='Testing Specialist',
                description='Expert in unit, widget, and integration tests',
                skills=['testing', 'unit-tests', 'widget-tests', 'integration-tests', 'coverage'],
                cost_multiplier=0.7,
                success_rate=0.92,
                avg_tokens_per_task=5000,
                avg_duration_minutes=20,
                tasks_completed=0,
                tasks_failed=0
            ),
            Agent(
                id='i18n-specialist',
                name='Internationalization Specialist',
                description='Expert in translations and localization',
                skills=['i18n', 'l10n', 'translations', 'arb', 'plurals'],
                cost_multiplier=0.6,
                success_rate=0.95,
                avg_tokens_per_task=4000,
                avg_duration_minutes=15,
                tasks_completed=0,
                tasks_failed=0
            ),
            Agent(
                id='bugfix-specialist',
                name='Bug Fix Specialist',
                description='Expert in debugging and fixing issues',
                skills=['bugfix', 'debugging', 'troubleshooting', 'analysis'],
                cost_multiplier=0.9,
                success_rate=0.88,
                avg_tokens_per_task=7000,
                avg_duration_minutes=28,
                tasks_completed=0,
                tasks_failed=0
            ),
        ]

        for agent in default_agents:
            self.agents[agent.id] = agent

        self._save_agents()

    def _save_agents(self):
        """Save agents to config file."""
        data = {
            'agents': {
                agent_id: agent.to_dict()
                for agent_id, agent in self.agents.items()
            },
            'last_updated': datetime.now().isoformat()
        }

        with open(self.config_path, 'w', encoding='utf-8') as f:
            json.dump(data, f, indent=2)

    def get_agent(self, agent_id: str) -> Optional[Agent]:
        """Get agent by ID."""
        return self.agents.get(agent_id)

    def get_available_agents(self) -> List[Agent]:
        """Get all available agents."""
        return [agent for agent in self.agents.values() if agent.available]

    def get_agents_by_skill(self, skill: str) -> List[Agent]:
        """Get agents that have a specific skill."""
        return [
            agent for agent in self.agents.values()
            if skill in agent.skills and agent.available
        ]

    def select_best_agent(self, task_type: str, complexity: str = 'moderate') -> Optional[Agent]:
        """
        Select the best agent for a task based on skills and performance.

        Args:
            task_type: Type of task (refactor, testing, i18n, bugfix, feature)
            complexity: Task complexity (simple, moderate, complex, very_complex)

        Returns:
            Best agent or None if no suitable agent found
        """
        candidates = self.get_agents_by_skill(task_type)

        if not candidates:
            # Fallback to general agent
            return self.get_agent('general')

        # Score candidates
        scores = []
        for agent in candidates:
            # Base score from success rate
            score = agent.success_rate * 100

            # Bonus for lower cost
            cost_bonus = (2.0 - agent.cost_multiplier) * 10
            score += cost_bonus

            # Bonus for efficiency (fewer tokens)
            efficiency_bonus = max(0, (10000 - agent.avg_tokens_per_task) / 1000)
            score += efficiency_bonus

            # Penalty for high complexity if agent is not suited
            if complexity in ['complex', 'very_complex']:
                if agent.id != 'general' and task_type not in ['refactor', 'testing']:
                    score *= 0.9

            scores.append((agent, score))

        # Sort by score descending
        scores.sort(key=lambda x: x[1], reverse=True)

        return scores[0][0] if scores else None

    def update_agent_stats(
        self,
        agent_id: str,
        success: bool,
        tokens_used: int,
        duration_minutes: int
    ):
        """Update agent statistics after task completion."""
        agent = self.get_agent(agent_id)
        if not agent:
            return

        # Update counters
        if success:
            agent.tasks_completed += 1
        else:
            agent.tasks_failed += 1

        # Update success rate (exponential moving average)
        total_tasks = agent.tasks_completed + agent.tasks_failed
        if total_tasks > 0:
            agent.success_rate = agent.tasks_completed / total_tasks

        # Update average tokens (moving average)
        if agent.tasks_completed > 0:
            alpha = 0.3  # Weight for new value
            agent.avg_tokens_per_task = int(
                alpha * tokens_used + (1 - alpha) * agent.avg_tokens_per_task
            )

        # Update average duration (moving average)
        if agent.tasks_completed > 0:
            agent.avg_duration_minutes = int(
                alpha * duration_minutes + (1 - alpha) * agent.avg_duration_minutes
            )

        self._save_agents()

        # Log telemetry
        self._log_agent_telemetry(agent_id, success, tokens_used, duration_minutes)

    def _log_agent_telemetry(
        self,
        agent_id: str,
        success: bool,
        tokens_used: int,
        duration_minutes: int
    ):
        """Log agent performance telemetry."""
        telemetry = {
            'agent_id': agent_id,
            'timestamp': datetime.now().isoformat(),
            'success': success,
            'tokens_used': tokens_used,
            'duration_minutes': duration_minutes,
            'efficiency': (1 if success else 0) * 10000 / max(tokens_used, 1)
        }

        filename = f"{self.telemetry_dir}/agent-{agent_id}-{datetime.now().strftime('%Y%m%d')}.json"

        # Append to daily file
        entries = []
        if os.path.exists(filename):
            with open(filename, 'r', encoding='utf-8') as f:
                entries = json.load(f)

        entries.append(telemetry)

        with open(filename, 'w', encoding='utf-8') as f:
            json.dump(entries, f, indent=2)

    def get_agent_performance_report(self, agent_id: str) -> Dict:
        """Get performance report for an agent."""
        agent = self.get_agent(agent_id)
        if not agent:
            return {}

        total_tasks = agent.tasks_completed + agent.tasks_failed

        return {
            'agent_id': agent_id,
            'name': agent.name,
            'skills': agent.skills,
            'total_tasks': total_tasks,
            'tasks_completed': agent.tasks_completed,
            'tasks_failed': agent.tasks_failed,
            'success_rate': agent.success_rate,
            'avg_tokens_per_task': agent.avg_tokens_per_task,
            'avg_duration_minutes': agent.avg_duration_minutes,
            'efficiency': (agent.tasks_completed / max(total_tasks, 1)) * 10000 / max(agent.avg_tokens_per_task, 1),
            'cost_multiplier': agent.cost_multiplier
        }

    def get_pool_summary(self) -> Dict:
        """Get summary of entire agent pool."""
        agents = list(self.agents.values())
        total_tasks = sum(a.tasks_completed + a.tasks_failed for a in agents)
        total_completed = sum(a.tasks_completed for a in agents)

        return {
            'total_agents': len(agents),
            'available_agents': len([a for a in agents if a.available]),
            'total_tasks_processed': total_tasks,
            'total_tasks_completed': total_completed,
            'overall_success_rate': total_completed / max(total_tasks, 1),
            'agents': [self.get_agent_performance_report(a.id) for a in agents]
        }


def main():
    """CLI for agent pool management."""
    import sys

    pool = AgentPool()

    if len(sys.argv) < 2:
        print("Usage: python agent-pool.py [command]")
        print("Commands:")
        print("  list              - List all agents")
        print("  summary           - Show pool summary")
        print("  select <type>     - Select best agent for task type")
        print("  report <agent_id> - Show agent performance report")
        return

    command = sys.argv[1]

    if command == 'list':
        print("\n=== Agent Pool ===\n")
        for agent in pool.agents.values():
            status = "✓ Available" if agent.available else "✗ Unavailable"
            print(f"{agent.id}: {agent.name} ({status})")
            print(f"  Skills: {', '.join(agent.skills)}")
            print(f"  Success Rate: {agent.success_rate:.1%}")
            print(f"  Avg Tokens: {agent.avg_tokens_per_task}")
            print(f"  Tasks: {agent.tasks_completed} completed, {agent.tasks_failed} failed")
            print()

    elif command == 'summary':
        summary = pool.get_pool_summary()
        print("\n=== Pool Summary ===\n")
        print(f"Total Agents: {summary['total_agents']}")
        print(f"Available: {summary['available_agents']}")
        print(f"Total Tasks: {summary['total_tasks_processed']}")
        print(f"Success Rate: {summary['overall_success_rate']:.1%}")
        print()

    elif command == 'select' and len(sys.argv) > 2:
        task_type = sys.argv[2]
        complexity = sys.argv[3] if len(sys.argv) > 3 else 'moderate'
        agent = pool.select_best_agent(task_type, complexity)
        if agent:
            print(f"\n✓ Selected: {agent.name} (id: {agent.id})")
            print(f"  Success Rate: {agent.success_rate:.1%}")
            print(f"  Avg Tokens: {agent.avg_tokens_per_task}")
            print(f"  Avg Duration: {agent.avg_duration_minutes} min")
        else:
            print(f"No suitable agent found for task type: {task_type}")

    elif command == 'report' and len(sys.argv) > 2:
        agent_id = sys.argv[2]
        report = pool.get_agent_performance_report(agent_id)
        if report:
            print(f"\n=== {report['name']} ===\n")
            print(f"Total Tasks: {report['total_tasks']}")
            print(f"Success Rate: {report['success_rate']:.1%}")
            print(f"Avg Tokens: {report['avg_tokens_per_task']}")
            print(f"Avg Duration: {report['avg_duration_minutes']} min")
            print(f"Efficiency: {report['efficiency']:.1f} tasks/10k")
        else:
            print(f"Agent not found: {agent_id}")

    else:
        print(f"Unknown command: {command}")


if __name__ == '__main__':
    main()
