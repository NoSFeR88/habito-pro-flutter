#!/usr/bin/env python3
"""
A/B Testing - Experiment Execution
Executes tasks with assigned variant and logs results for analysis.

Usage:
    python scripts/run-experiment.py --experiment exp-001-workflow-templates --task "Fix bug in habit provider"
    python scripts/run-experiment.py --list-experiments
    python scripts/run-experiment.py --experiment exp-001-workflow-templates --status
"""

import json
import argparse
import random
import sys
from datetime import datetime
from pathlib import Path

# Paths
EXPERIMENTS_FILE = Path("telemetry/experiments/experiments.json")
RESULTS_DIR = Path("telemetry/experiments/results")
EXECUTION_LOG = Path("telemetry/experiments/execution_log.json")


def load_experiments():
    """Load experiments configuration."""
    if not EXPERIMENTS_FILE.exists():
        print(f"Error: Experiments file not found at {EXPERIMENTS_FILE}")
        sys.exit(1)

    with open(EXPERIMENTS_FILE, 'r', encoding='utf-8') as f:
        return json.load(f)


def save_experiments(data):
    """Save updated experiments configuration."""
    with open(EXPERIMENTS_FILE, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2)


def load_execution_log():
    """Load execution log."""
    if not EXECUTION_LOG.exists():
        return {"executions": []}

    with open(EXECUTION_LOG, 'r', encoding='utf-8') as f:
        return json.load(f)


def save_execution_log(data):
    """Save execution log."""
    EXECUTION_LOG.parent.mkdir(parents=True, exist_ok=True)
    with open(EXECUTION_LOG, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2)


def assign_variant(experiment):
    """Assign variant using configured allocation strategy."""
    allocation = experiment.get('allocation', 'random_50_50')

    if allocation == 'random_50_50':
        return random.choice(experiment['variants'])

    # Add more allocation strategies here (e.g., weighted, adaptive)
    return random.choice(experiment['variants'])


def list_experiments(data):
    """List all experiments with status."""
    print("\n=== AVAILABLE EXPERIMENTS ===\n")

    for exp in data['experiments']:
        status_emoji = "🟢" if exp['status'] == 'active' else "🔵" if exp['status'] == 'planned' else "⚪"
        print(f"{status_emoji} {exp['experiment_id']}")
        print(f"   Name: {exp['name']}")
        print(f"   Status: {exp['status']}")
        print(f"   Samples: {exp['current_samples']}/{exp['sample_size']}")
        print(f"   Variants: {', '.join([v['id'] for v in exp['variants']])}")
        print()


def show_experiment_status(data, experiment_id):
    """Show detailed status of an experiment."""
    exp = next((e for e in data['experiments'] if e['experiment_id'] == experiment_id), None)

    if not exp:
        print(f"Error: Experiment '{experiment_id}' not found")
        sys.exit(1)

    print(f"\n=== EXPERIMENT STATUS: {exp['experiment_id']} ===\n")
    print(f"Name: {exp['name']}")
    print(f"Description: {exp['description']}")
    print(f"Status: {exp['status']}")
    print(f"Progress: {exp['current_samples']}/{exp['sample_size']} samples")
    print(f"\nVariants:")
    for v in exp['variants']:
        print(f"  - {v['id']}: {v['name']}")

    print(f"\nMetrics tracked:")
    for m in exp['metrics']:
        print(f"  - {m['name']} ({m['unit']}) - {m['target']}")

    # Load execution log to show variant distribution
    log = load_execution_log()
    exp_executions = [e for e in log.get('executions', []) if e['experiment_id'] == experiment_id]

    if exp_executions:
        print(f"\nVariant Distribution:")
        variant_counts = {}
        for e in exp_executions:
            variant_id = e['variant_id']
            variant_counts[variant_id] = variant_counts.get(variant_id, 0) + 1

        for variant_id, count in variant_counts.items():
            print(f"  - {variant_id}: {count} executions")


def start_experiment_execution(experiment_id, task_description):
    """Start experiment execution and assign variant."""
    data = load_experiments()

    # Find experiment
    exp = next((e for e in data['experiments'] if e['experiment_id'] == experiment_id), None)

    if not exp:
        print(f"Error: Experiment '{experiment_id}' not found")
        sys.exit(1)

    if exp['status'] != 'active':
        print(f"Error: Experiment '{experiment_id}' is not active (status: {exp['status']})")
        sys.exit(1)

    if exp['current_samples'] >= exp['sample_size']:
        print(f"Warning: Experiment '{experiment_id}' has reached sample size ({exp['sample_size']})")
        print("Consider running analysis with analyze-experiment.py")
        response = input("Continue anyway? (y/n): ")
        if response.lower() != 'y':
            sys.exit(0)

    # Assign variant
    assigned_variant = assign_variant(exp)

    # Create execution record
    execution = {
        "execution_id": f"exec-{datetime.now().strftime('%Y%m%d-%H%M%S')}-{random.randint(1000, 9999)}",
        "experiment_id": experiment_id,
        "variant_id": assigned_variant['id'],
        "variant_name": assigned_variant['name'],
        "task_description": task_description,
        "started_at": datetime.now().isoformat(),
        "constraints": assigned_variant.get('constraints', {}),
        "status": "running",
        "metrics": {}
    }

    # Update experiment count
    exp['current_samples'] += 1
    save_experiments(data)

    # Log execution
    log = load_execution_log()
    log['executions'].append(execution)
    save_execution_log(log)

    # Print execution details
    print(f"\n{'='*60}")
    print(f"EXPERIMENT EXECUTION STARTED")
    print(f"{'='*60}\n")
    print(f"Execution ID: {execution['execution_id']}")
    print(f"Experiment: {exp['name']}")
    print(f"Variant Assigned: {assigned_variant['name']} ({assigned_variant['id']})")
    print(f"Task: {task_description}")
    print(f"\n{'='*60}")
    print(f"CONSTRAINTS TO FOLLOW:")
    print(f"{'='*60}\n")

    for key, value in assigned_variant.get('constraints', {}).items():
        constraint_text = key.replace('_', ' ').title()
        print(f"  - {constraint_text}: {value}")

    print(f"\n{'='*60}")
    print(f"METRICS TO TRACK:")
    print(f"{'='*60}\n")

    for metric in exp['metrics']:
        print(f"  - {metric['name']} ({metric['unit']}) - {metric['target']}")

    print(f"\n{'='*60}")
    print(f"NEXT STEPS:")
    print(f"{'='*60}\n")
    print(f"1. Execute task following variant constraints")
    print(f"2. Record metrics during execution")
    print(f"3. Run: python scripts/complete-experiment.py --execution {execution['execution_id']}")
    print(f"\nExecution log saved to: {EXECUTION_LOG}\n")

    return execution


def main():
    parser = argparse.ArgumentParser(description='A/B Testing - Run Experiment')
    parser.add_argument('--experiment', type=str, help='Experiment ID to run')
    parser.add_argument('--task', type=str, help='Task description')
    parser.add_argument('--list-experiments', action='store_true', help='List all experiments')
    parser.add_argument('--status', action='store_true', help='Show experiment status')

    args = parser.parse_args()

    data = load_experiments()

    if args.list_experiments:
        list_experiments(data)
        return

    if args.status:
        if not args.experiment:
            print("Error: --experiment required with --status")
            sys.exit(1)
        show_experiment_status(data, args.experiment)
        return

    if not args.experiment or not args.task:
        print("Error: --experiment and --task are required")
        print("\nUsage:")
        print('  python scripts/run-experiment.py --experiment exp-001-workflow-templates --task "Fix bug"')
        print('  python scripts/run-experiment.py --list-experiments')
        print('  python scripts/run-experiment.py --experiment exp-001-workflow-templates --status')
        sys.exit(1)

    start_experiment_execution(args.experiment, args.task)


if __name__ == "__main__":
    main()
