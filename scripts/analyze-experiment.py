#!/usr/bin/env python3
"""
A/B Testing - Statistical Analysis
Analyzes experiment results with statistical rigor.

Usage:
    python scripts/analyze-experiment.py --experiment exp-001-workflow-templates
    python scripts/analyze-experiment.py --experiment exp-001-workflow-templates --export-report
"""

import json
import argparse
import sys
from pathlib import Path
from datetime import datetime
from collections import defaultdict
import math

# Paths
EXPERIMENTS_FILE = Path("telemetry/experiments/experiments.json")
RESULTS_DIR = Path("telemetry/experiments/results")
REPORTS_DIR = Path("telemetry/experiments/reports")


def load_experiments():
    """Load experiments configuration."""
    with open(EXPERIMENTS_FILE, 'r', encoding='utf-8') as f:
        return json.load(f)


def load_results(experiment_id):
    """Load results for an experiment."""
    result_file = RESULTS_DIR / f"{experiment_id}_results.json"

    if not result_file.exists():
        print(f"Error: No results found for experiment '{experiment_id}'")
        sys.exit(1)

    with open(result_file, 'r', encoding='utf-8') as f:
        return json.load(f)


def calculate_mean(values):
    """Calculate mean of a list."""
    if not values:
        return 0
    return sum(values) / len(values)


def calculate_std(values):
    """Calculate standard deviation."""
    if len(values) < 2:
        return 0

    mean = calculate_mean(values)
    variance = sum((x - mean) ** 2 for x in values) / (len(values) - 1)
    return math.sqrt(variance)


def calculate_t_statistic(group_a, group_b):
    """Calculate t-statistic for two groups."""
    mean_a = calculate_mean(group_a)
    mean_b = calculate_mean(group_b)
    std_a = calculate_std(group_a)
    std_b = calculate_std(group_b)
    n_a = len(group_a)
    n_b = len(group_b)

    if n_a < 2 or n_b < 2:
        return 0, 1.0  # Not enough samples

    # Pooled standard deviation
    pooled_std = math.sqrt(((n_a - 1) * std_a ** 2 + (n_b - 1) * std_b ** 2) / (n_a + n_b - 2))

    if pooled_std == 0:
        return 0, 1.0

    # T-statistic
    t_stat = (mean_a - mean_b) / (pooled_std * math.sqrt(1/n_a + 1/n_b))

    # Degrees of freedom
    df = n_a + n_b - 2

    # Approximate p-value (simplified, for more accuracy use scipy.stats)
    # For now, use critical values: t > 2.0 (p < 0.05), t > 2.6 (p < 0.01)
    if abs(t_stat) > 2.6:
        p_value = 0.01
    elif abs(t_stat) > 2.0:
        p_value = 0.05
    else:
        p_value = 0.10

    return t_stat, p_value


def calculate_cohens_d(group_a, group_b):
    """Calculate Cohen's d effect size."""
    mean_a = calculate_mean(group_a)
    mean_b = calculate_mean(group_b)
    std_a = calculate_std(group_a)
    std_b = calculate_std(group_b)
    n_a = len(group_a)
    n_b = len(group_b)

    if n_a < 2 or n_b < 2:
        return 0

    # Pooled standard deviation
    pooled_std = math.sqrt(((n_a - 1) * std_a ** 2 + (n_b - 1) * std_b ** 2) / (n_a + n_b - 2))

    if pooled_std == 0:
        return 0

    return (mean_a - mean_b) / pooled_std


def interpret_effect_size(d):
    """Interpret Cohen's d effect size."""
    abs_d = abs(d)
    if abs_d < 0.2:
        return "negligible"
    elif abs_d < 0.5:
        return "small"
    elif abs_d < 0.8:
        return "medium"
    else:
        return "large"


def analyze_experiment(experiment_id):
    """Analyze experiment results with statistical tests."""
    experiments_data = load_experiments()
    exp = next((e for e in experiments_data['experiments'] if e['experiment_id'] == experiment_id), None)

    if not exp:
        print(f"Error: Experiment '{experiment_id}' not found")
        sys.exit(1)

    results_data = load_results(experiment_id)
    results = results_data['results']

    if len(results) < 2:
        print(f"Error: Not enough results to analyze (need at least 2, have {len(results)})")
        sys.exit(1)

    # Group results by variant
    variant_data = defaultdict(lambda: defaultdict(list))

    for result in results:
        variant_id = result['variant_id']
        for metric_name, metric_value in result['metrics'].items():
            variant_data[variant_id][metric_name].append(metric_value)

    # Get variant IDs
    variant_ids = list(variant_data.keys())

    if len(variant_ids) != 2:
        print(f"Error: A/B testing requires exactly 2 variants, found {len(variant_ids)}")
        sys.exit(1)

    variant_a_id = variant_ids[0]
    variant_b_id = variant_ids[1]

    # Print header
    print(f"\n{'='*80}")
    print(f"A/B TESTING STATISTICAL ANALYSIS")
    print(f"{'='*80}\n")
    print(f"Experiment: {exp['name']}")
    print(f"ID: {experiment_id}")
    print(f"Total Samples: {len(results)}")
    print(f"\nVariant A: {variant_a_id} (n={len([r for r in results if r['variant_id'] == variant_a_id])})")
    print(f"Variant B: {variant_b_id} (n={len([r for r in results if r['variant_id'] == variant_b_id])})")

    # Analyze each metric
    print(f"\n{'='*80}")
    print(f"METRIC ANALYSIS")
    print(f"{'='*80}\n")

    analysis_results = []

    for metric in exp['metrics']:
        metric_name = metric['name']
        metric_target = metric['target']

        if metric_name not in variant_data[variant_a_id] or metric_name not in variant_data[variant_b_id]:
            continue

        values_a = variant_data[variant_a_id][metric_name]
        values_b = variant_data[variant_b_id][metric_name]

        mean_a = calculate_mean(values_a)
        mean_b = calculate_mean(values_b)
        std_a = calculate_std(values_a)
        std_b = calculate_std(values_b)

        t_stat, p_value = calculate_t_statistic(values_a, values_b)
        cohens_d = calculate_cohens_d(values_a, values_b)
        effect_interpretation = interpret_effect_size(cohens_d)

        # Determine winner
        if metric_target == 'minimize':
            winner = variant_a_id if mean_a < mean_b else variant_b_id
            improvement = ((mean_b - mean_a) / mean_b * 100) if mean_b > 0 else 0
        else:  # maximize
            winner = variant_a_id if mean_a > mean_b else variant_b_id
            improvement = ((mean_a - mean_b) / mean_b * 100) if mean_b > 0 else 0

        significant = p_value < 0.05

        print(f"Metric: {metric_name} ({metric['unit']}) - Target: {metric_target}")
        print(f"  Variant A ({variant_a_id}): mean={mean_a:.2f}, std={std_a:.2f}")
        print(f"  Variant B ({variant_b_id}): mean={mean_b:.2f}, std={std_b:.2f}")
        print(f"  t-statistic: {t_stat:.3f}, p-value: {p_value:.3f}")
        print(f"  Cohen's d: {cohens_d:.3f} ({effect_interpretation})")
        print(f"  Winner: {winner} ({abs(improvement):.1f}% improvement)")
        print(f"  Significant: {'YES' if significant else 'NO'} (p < 0.05)")
        print()

        analysis_results.append({
            "metric_name": metric_name,
            "variant_a_mean": round(mean_a, 2),
            "variant_b_mean": round(mean_b, 2),
            "t_statistic": round(t_stat, 3),
            "p_value": p_value,
            "cohens_d": round(cohens_d, 3),
            "effect_size": effect_interpretation,
            "winner": winner,
            "improvement_percent": round(abs(improvement), 1),
            "significant": significant
        })

    # Overall recommendation
    print(f"{'='*80}")
    print(f"RECOMMENDATION")
    print(f"{'='*80}\n")

    significant_wins = [r for r in analysis_results if r['significant']]
    large_effects = [r for r in analysis_results if r['cohens_d'] >= 0.5]

    global_settings = experiments_data['global_settings']
    auto_threshold = global_settings['auto_adoption_threshold']

    # Check if we should auto-adopt
    should_auto_adopt = False
    if significant_wins and large_effects:
        # Check if any metric meets auto-adoption criteria
        for result in analysis_results:
            if result['p_value'] <= auto_threshold['p_value'] and abs(result['cohens_d']) >= auto_threshold['effect_size']:
                should_auto_adopt = True
                break

    if should_auto_adopt:
        print("AUTO-ADOPTION RECOMMENDED")
        print(f"  - Found significant results (p < {auto_threshold['p_value']})")
        print(f"  - Large effect size (d >= {auto_threshold['effect_size']})")
        print(f"  - Sample size: {len(results)}/{exp['sample_size']}")
        print(f"\nAction: Adopt winning variant as default")
    elif significant_wins:
        print("PROMISING RESULTS - CONTINUE TESTING")
        print(f"  - Found {len(significant_wins)} significant result(s)")
        print(f"  - Need larger effect size for auto-adoption")
        print(f"\nAction: Continue collecting samples")
    else:
        print("NO SIGNIFICANT DIFFERENCE")
        print(f"  - No statistically significant results found")
        print(f"  - May need more samples or variants are equivalent")
        print(f"\nAction: Continue testing or conclude variants are similar")

    print()

    return {
        "experiment_id": experiment_id,
        "analyzed_at": datetime.now().isoformat(),
        "sample_size": len(results),
        "variants": {
            "a": variant_a_id,
            "b": variant_b_id
        },
        "metrics": analysis_results,
        "recommendation": "auto_adopt" if should_auto_adopt else "continue" if significant_wins else "inconclusive"
    }


def export_report(experiment_id, analysis):
    """Export analysis report to file."""
    REPORTS_DIR.mkdir(parents=True, exist_ok=True)

    report_file = REPORTS_DIR / f"{experiment_id}_analysis_{datetime.now().strftime('%Y%m%d')}.json"

    with open(report_file, 'w', encoding='utf-8') as f:
        json.dump(analysis, f, indent=2)

    print(f"Report exported to: {report_file}")


def main():
    parser = argparse.ArgumentParser(description='A/B Testing - Statistical Analysis')
    parser.add_argument('--experiment', type=str, required=True, help='Experiment ID to analyze')
    parser.add_argument('--export-report', action='store_true', help='Export analysis report to file')

    args = parser.parse_args()

    analysis = analyze_experiment(args.experiment)

    if args.export_report:
        export_report(args.experiment, analysis)


if __name__ == "__main__":
    main()
