#!/usr/bin/env python3
"""
Agent Performance Tracking Dashboard
Generates visual performance reports for all agents.
"""

import json
import os
from datetime import datetime
from typing import Dict, List
import sys

sys.path.insert(0, os.path.dirname(__file__))
from agent_pool import AgentPool


class AgentPerformanceDashboard:
    """Tracks and visualizes agent performance."""

    def __init__(self):
        self.agent_pool = AgentPool()
        self.output_dir = 'telemetry/reports'
        os.makedirs(self.output_dir, exist_ok=True)

    def generate_heatmap_data(self) -> Dict:
        """Generate agent x task_type heatmap data."""
        # Load routing log to get agent-task mappings
        routing_log = '.automation/routing-log.json'

        if not os.path.exists(routing_log):
            return {'agents': [], 'task_types': [], 'data': []}

        with open(routing_log, 'r', encoding='utf-8') as f:
            logs = json.load(f)

        # Build heatmap matrix
        agent_task_matrix = {}
        task_types = set()

        for entry in logs:
            decision = entry['decision']
            agent_id = decision['agent_id']
            task_type = decision['task_type']

            task_types.add(task_type)

            if agent_id not in agent_task_matrix:
                agent_task_matrix[agent_id] = {}

            if task_type not in agent_task_matrix[agent_id]:
                agent_task_matrix[agent_id][task_type] = {
                    'count': 0,
                    'total_confidence': 0.0
                }

            agent_task_matrix[agent_id][task_type]['count'] += 1
            agent_task_matrix[agent_id][task_type]['total_confidence'] += decision['confidence']

        # Calculate average confidence for each cell
        agents = sorted(agent_task_matrix.keys())
        task_types_sorted = sorted(task_types)

        heatmap_data = []
        for agent in agents:
            row = []
            for task_type in task_types_sorted:
                if task_type in agent_task_matrix[agent]:
                    count = agent_task_matrix[agent][task_type]['count']
                    avg_confidence = agent_task_matrix[agent][task_type]['total_confidence'] / count
                    row.append({
                        'count': count,
                        'confidence': round(avg_confidence, 2)
                    })
                else:
                    row.append({'count': 0, 'confidence': 0.0})
            heatmap_data.append(row)

        return {
            'agents': agents,
            'task_types': task_types_sorted,
            'data': heatmap_data
        }

    def generate_leaderboard(self) -> List[Dict]:
        """Generate agent leaderboard."""
        summary = self.agent_pool.get_pool_summary()
        agents = summary['agents']

        # Sort by efficiency
        leaderboard = sorted(
            agents,
            key=lambda a: a['efficiency'],
            reverse=True
        )

        return leaderboard

    def generate_report(self) -> str:
        """Generate complete performance report."""
        summary = self.agent_pool.get_pool_summary()
        heatmap = self.generate_heatmap_data()
        leaderboard = self.generate_leaderboard()

        report = "# 🤖 Agent Performance Dashboard\n\n"
        report += f"**Generated**: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n\n"
        report += "---\n\n"

        # Pool Summary
        report += "## 📊 Pool Summary\n\n"
        report += f"- **Total Agents**: {summary['total_agents']}\n"
        report += f"- **Available Agents**: {summary['available_agents']}\n"
        report += f"- **Total Tasks Processed**: {summary['total_tasks_processed']}\n"
        report += f"- **Overall Success Rate**: {summary['overall_success_rate']:.1%}\n\n"

        # Leaderboard
        report += "## 🏆 Agent Leaderboard\n\n"
        report += "| Rank | Agent | Efficiency | Success Rate | Avg Tokens | Cost |\n"
        report += "|------|-------|------------|--------------|------------|------|\n"

        for i, agent in enumerate(leaderboard, 1):
            medal = {1: '🥇', 2: '🥈', 3: '🥉'}.get(i, f'{i}.')
            name = agent['name'].replace(' Agent', '')
            efficiency = agent['efficiency']
            success = agent['success_rate']
            tokens = agent['avg_tokens_per_task']
            cost = agent['cost_multiplier']

            report += f"| {medal} | {name} | {efficiency:.1f} | {success:.0%} | {tokens:,} | {cost}x |\n"

        report += "\n"

        # Detailed Agent Stats
        report += "## 📈 Detailed Agent Statistics\n\n"

        for agent in leaderboard:
            report += f"### {agent['name']}\n\n"
            report += f"- **ID**: `{agent['agent_id']}`\n"
            report += f"- **Skills**: {', '.join(agent['skills'])}\n"
            report += f"- **Total Tasks**: {agent['total_tasks']}\n"
            report += f"- **Success Rate**: {agent['success_rate']:.1%} ({agent['tasks_completed']}/{agent['total_tasks']})\n"
            report += f"- **Efficiency**: {agent['efficiency']:.1f} tasks/10k tokens\n"
            report += f"- **Avg Tokens/Task**: {agent['avg_tokens_per_task']:,}\n"
            report += f"- **Avg Duration**: {agent['avg_duration_minutes']} minutes\n"
            report += f"- **Cost Multiplier**: {agent['cost_multiplier']}x\n\n"

        # Heatmap (text representation)
        if heatmap['data']:
            report += "## 🗺️ Agent × Task Type Heatmap\n\n"
            report += "Shows routing confidence for each agent-task combination.\n\n"

            # Header
            report += "| Agent | " + " | ".join(heatmap['task_types']) + " |\n"
            report += "|-------|" + "|".join(["-------"] * len(heatmap['task_types'])) + "|\n"

            # Data rows
            for i, agent_id in enumerate(heatmap['agents']):
                row_data = []
                for cell in heatmap['data'][i]:
                    if cell['count'] > 0:
                        emoji = '🟢' if cell['confidence'] >= 0.7 else '🟡' if cell['confidence'] >= 0.5 else '🔴'
                        row_data.append(f"{emoji} {cell['confidence']:.0%}")
                    else:
                        row_data.append("—")

                report += f"| {agent_id} | " + " | ".join(row_data) + " |\n"

            report += "\n"
            report += "Legend: 🟢 High confidence (≥70%) | 🟡 Medium (50-69%) | 🔴 Low (<50%) | — No data\n\n"

        # Recommendations
        report += "## 💡 Recommendations\n\n"

        # Find underutilized agents
        min_tasks = min(a['total_tasks'] for a in leaderboard) if leaderboard else 0
        underutilized = [a for a in leaderboard if a['total_tasks'] == min_tasks and min_tasks < 5]

        if underutilized:
            report += "### Underutilized Agents\n\n"
            for agent in underutilized:
                report += f"- **{agent['name']}**: Only {agent['total_tasks']} tasks. "
                report += f"Consider routing more {', '.join(agent['skills'])} tasks to this agent.\n"
            report += "\n"

        # Find low performers
        avg_success = summary['overall_success_rate']
        low_performers = [a for a in leaderboard if a['success_rate'] < avg_success and a['total_tasks'] > 3]

        if low_performers:
            report += "### Performance Issues\n\n"
            for agent in low_performers:
                report += f"- **{agent['name']}**: Success rate {agent['success_rate']:.0%} below average ({avg_success:.0%}). "
                report += f"Review recent failures and adjust routing.\n"
            report += "\n"

        # Top performers
        top_performers = [a for a in leaderboard[:3] if a['total_tasks'] > 5]

        if top_performers:
            report += "### Top Performers\n\n"
            for agent in top_performers:
                savings = (1 - agent['cost_multiplier']) * 100
                report += f"- **{agent['name']}**: {agent['efficiency']:.1f} efficiency, {agent['success_rate']:.0%} success rate"
                if savings > 0:
                    report += f", {savings:.0f}% cost savings"
                report += "\n"
            report += "\n"

        report += "---\n\n"
        report += "*Dashboard generated by agent-performance-dashboard.py*\n"

        return report

    def save_report(self, report: str):
        """Save report to file."""
        timestamp = datetime.now().strftime('%Y%m%d-%H%M%S')
        filename = f'{self.output_dir}/agent-performance-{timestamp}.md'

        with open(filename, 'w', encoding='utf-8') as f:
            f.write(report)

        # Also save as latest
        latest_file = f'{self.output_dir}/agent-performance-latest.md'
        with open(latest_file, 'w', encoding='utf-8') as f:
            f.write(report)

        return filename

    def generate_json_export(self) -> Dict:
        """Export performance data as JSON for dashboards."""
        summary = self.agent_pool.get_pool_summary()
        heatmap = self.generate_heatmap_data()
        leaderboard = self.generate_leaderboard()

        return {
            'generated_at': datetime.now().isoformat(),
            'summary': summary,
            'leaderboard': leaderboard,
            'heatmap': heatmap
        }

    def save_json_export(self):
        """Save JSON export."""
        data = self.generate_json_export()
        filename = f'{self.output_dir}/agent-performance-data.json'

        with open(filename, 'w', encoding='utf-8') as f:
            json.dump(data, f, indent=2)

        return filename


def main():
    """CLI for agent performance dashboard."""
    dashboard = AgentPerformanceDashboard()

    if len(sys.argv) > 1 and sys.argv[1] == 'json':
        # JSON export mode
        json_file = dashboard.save_json_export()
        print(f"✅ JSON export saved to: {json_file}")
    else:
        # Report mode
        report = dashboard.generate_report()
        print(report)

        # Save to file
        filename = dashboard.save_report(report)
        print(f"\n✅ Report saved to: {filename}")

        # Also save JSON
        json_file = dashboard.save_json_export()
        print(f"✅ JSON data saved to: {json_file}")


if __name__ == '__main__':
    main()
