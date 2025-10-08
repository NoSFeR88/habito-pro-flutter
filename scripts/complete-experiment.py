#!/usr/bin/env python3
"""
A/B Testing - Complete Experiment Execution
Records metrics and completes an experiment execution.

Usage:
    python scripts/complete-experiment.py --execution exec-20251008-230000-1234 --tokens 5000 --duration 30 --quality 9 --bugs 0
    python scripts/complete-experiment.py --list-pending
"""

import json
import argparse
import sys
from datetime import datetime
from pathlib import Path

# Paths
EXECUTION_LOG = Path("telemetry/experiments/execution_log.json")
RESULTS_DIR = Path("telemetry/experiments/results")


def load_execution_log():
    """Load execution log."""
    if not EXECUTION_LOG.exists():
        print("Error: No execution log found")
        sys.exit(1)

    with open(EXECUTION_LOG, 'r', encoding='utf-8') as f:
        return json.load(f)


def save_execution_log(data):
    """Save execution log."""
    with open(EXECUTION_LOG, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2)


def save_result(experiment_id, execution_id, result):
    """Save individual result to results directory."""
    RESULTS_DIR.mkdir(parents=True, exist_ok=True)

    result_file = RESULTS_DIR / f"{experiment_id}_results.json"

    if result_file.exists():
        with open(result_file, 'r', encoding='utf-8') as f:
            results = json.load(f)
    else:
        results = {"experiment_id": experiment_id, "results": []}

    results['results'].append(result)

    with open(result_file, 'w', encoding='utf-8') as f:
        json.dump(results, f, indent=2)


def list_pending_executions():
    """List all pending (running) executions."""
    log = load_execution_log()

    pending = [e for e in log.get('executions', []) if e['status'] == 'running']

    if not pending:
        print("\nNo pending executions found.\n")
        return

    print("\n=== PENDING EXECUTIONS ===\n")
    for exec in pending:
        print(f"Execution ID: {exec['execution_id']}")
        print(f"  Experiment: {exec['experiment_id']}")
        print(f"  Variant: {exec['variant_name']} ({exec['variant_id']})")
        print(f"  Task: {exec['task_description']}")
        print(f"  Started: {exec['started_at']}")
        print()


def complete_execution(execution_id, metrics):
    """Complete an execution with recorded metrics."""
    log = load_execution_log()

    # Find execution
    execution = next((e for e in log['executions'] if e['execution_id'] == execution_id), None)

    if not execution:
        print(f"Error: Execution '{execution_id}' not found")
        sys.exit(1)

    if execution['status'] != 'running':
        print(f"Error: Execution '{execution_id}' is already {execution['status']}")
        sys.exit(1)

    # Update execution
    execution['metrics'] = metrics
    execution['completed_at'] = datetime.now().isoformat()
    execution['status'] = 'completed'

    # Calculate duration if not provided
    if 'duration_minutes' not in metrics:
        started = datetime.fromisoformat(execution['started_at'])
        completed = datetime.fromisoformat(execution['completed_at'])
        duration = (completed - started).total_seconds() / 60
        execution['metrics']['duration_minutes'] = round(duration, 2)

    # Save updated log
    save_execution_log(log)

    # Save to results file
    result = {
        "execution_id": execution_id,
        "variant_id": execution['variant_id'],
        "task_description": execution['task_description'],
        "started_at": execution['started_at'],
        "completed_at": execution['completed_at'],
        "metrics": execution['metrics']
    }
    save_result(execution['experiment_id'], execution_id, result)

    # Print summary
    print(f"\n{'='*60}")
    print(f"EXECUTION COMPLETED")
    print(f"{'='*60}\n")
    print(f"Execution ID: {execution_id}")
    print(f"Experiment: {execution['experiment_id']}")
    print(f"Variant: {execution['variant_name']} ({execution['variant_id']})")
    print(f"\nRecorded Metrics:")
    for key, value in metrics.items():
        metric_name = key.replace('_', ' ').title()
        print(f"  - {metric_name}: {value}")

    print(f"\n{'='*60}")
    print(f"NEXT STEPS:")
    print(f"{'='*60}\n")
    print(f"1. Continue with more samples or")
    print(f"2. Run analysis: python scripts/analyze-experiment.py --experiment {execution['experiment_id']}")
    print()


def main():
    parser = argparse.ArgumentParser(description='A/B Testing - Complete Execution')
    parser.add_argument('--execution', type=str, help='Execution ID to complete')
    parser.add_argument('--tokens', type=int, help='Tokens used')
    parser.add_argument('--duration', type=float, help='Duration in minutes')
    parser.add_argument('--quality', type=int, help='Quality score (0-10)')
    parser.add_argument('--bugs', type=int, help='Bugs introduced')
    parser.add_argument('--list-pending', action='store_true', help='List pending executions')

    args = parser.parse_args()

    if args.list_pending:
        list_pending_executions()
        return

    if not args.execution:
        print("Error: --execution required")
        print("\nUsage:")
        print('  python scripts/complete-experiment.py --execution exec-... --tokens 5000 --duration 30 --quality 9 --bugs 0')
        print('  python scripts/complete-experiment.py --list-pending')
        sys.exit(1)

    # Build metrics from args
    metrics = {}
    if args.tokens is not None:
        metrics['tokens_used'] = args.tokens
    if args.duration is not None:
        metrics['duration_minutes'] = args.duration
    if args.quality is not None:
        metrics['quality_score'] = args.quality
    if args.bugs is not None:
        metrics['bugs_introduced'] = args.bugs

    if not metrics:
        print("Error: At least one metric required (--tokens, --duration, --quality, --bugs)")
        sys.exit(1)

    complete_execution(args.execution, metrics)


if __name__ == "__main__":
    main()
