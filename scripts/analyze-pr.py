#!/usr/bin/env python3
"""
PR Auto-Analysis Script
Analyzes PRs and estimates complexity, tokens needed, and provides recommendations.
"""

import json
import os
import sys
import subprocess
from datetime import datetime
from typing import Dict, List, Tuple

# Token estimation constants
TOKENS_PER_LINE = 3  # Average tokens per line of code
TOKENS_PER_FILE = 100  # Base tokens for reading a file
COMPLEXITY_MULTIPLIERS = {
    'simple': 1.0,    # Simple changes (docs, config)
    'moderate': 1.5,  # Moderate changes (UI, logic)
    'complex': 2.5,   # Complex changes (architecture, refactoring)
    'very_complex': 4.0  # Very complex (multi-file refactoring)
}

# File type complexity mapping
FILE_COMPLEXITY = {
    '.md': 'simple',
    '.yml': 'simple',
    '.yaml': 'simple',
    '.json': 'simple',
    '.txt': 'simple',
    '.arb': 'simple',
    '.dart': 'moderate',
    '.py': 'moderate',
    '.ps1': 'moderate',
    '.sh': 'moderate',
}


def run_command(cmd: List[str]) -> Tuple[str, int]:
    """Run a shell command and return output and exit code."""
    try:
        result = subprocess.run(
            cmd,
            capture_output=True,
            text=True,
            check=False
        )
        return result.stdout.strip(), result.returncode
    except Exception as e:
        return f"Error: {e}", 1


def get_pr_diff(base_branch: str = 'origin/master', head_branch: str = 'HEAD') -> Dict:
    """Get PR diff statistics."""
    # Get changed files
    files_cmd = ['git', 'diff', '--name-only', f'{base_branch}...{head_branch}']
    files_output, _ = run_command(files_cmd)
    changed_files = [f for f in files_output.split('\n') if f]

    # Get diff stats
    stats_cmd = ['git', 'diff', '--stat', f'{base_branch}...{head_branch}']
    stats_output, _ = run_command(stats_cmd)

    # Parse insertions and deletions
    insertions = 0
    deletions = 0
    for line in stats_output.split('\n'):
        if 'insertion' in line or 'deletion' in line:
            parts = line.split(',')
            for part in parts:
                if 'insertion' in part:
                    insertions = int(part.strip().split()[0])
                if 'deletion' in part:
                    deletions = int(part.strip().split()[0])

    return {
        'files_changed': len(changed_files),
        'changed_files': changed_files,
        'insertions': insertions,
        'deletions': deletions,
        'total_changes': insertions + deletions
    }


def classify_complexity(diff: Dict) -> str:
    """Classify PR complexity based on diff statistics."""
    files_changed = diff['files_changed']
    total_changes = diff['total_changes']

    # Simple heuristics
    if files_changed == 1 and total_changes < 50:
        return 'simple'
    elif files_changed <= 3 and total_changes < 200:
        return 'moderate'
    elif files_changed <= 10 and total_changes < 500:
        return 'complex'
    else:
        return 'very_complex'


def estimate_tokens(diff: Dict, complexity: str) -> int:
    """Estimate tokens needed for PR review/implementation."""
    base_tokens = 0

    # Tokens for reading changed files
    base_tokens += diff['files_changed'] * TOKENS_PER_FILE

    # Tokens for changed lines
    base_tokens += diff['total_changes'] * TOKENS_PER_LINE

    # Apply complexity multiplier
    multiplier = COMPLEXITY_MULTIPLIERS.get(complexity, 1.5)
    estimated_tokens = int(base_tokens * multiplier)

    return estimated_tokens


def estimate_duration(tokens: int, complexity: str) -> int:
    """Estimate duration in minutes based on tokens and complexity."""
    # Base rate: 5000 tokens per 10 minutes (optimal efficiency)
    base_minutes = (tokens / 5000) * 10

    # Add complexity overhead
    overhead_multipliers = {
        'simple': 1.0,
        'moderate': 1.2,
        'complex': 1.5,
        'very_complex': 2.0
    }
    multiplier = overhead_multipliers.get(complexity, 1.2)

    return int(base_minutes * multiplier)


def get_workflow_template_recommendation(changed_files: List[str]) -> str:
    """Recommend workflow template based on changed files."""
    if any('test' in f.lower() for f in changed_files):
        return 'add-tests'
    elif any(f.endswith('.arb') for f in changed_files):
        return 'add-translation'
    elif any('pubspec.yaml' in f for f in changed_files):
        return 'update-dependencies'
    elif any('refactor' in f.lower() for f in changed_files):
        return 'refactor'
    elif any('fix' in f.lower() or 'bug' in f.lower() for f in changed_files):
        return 'fix-bug'
    else:
        return 'add-feature'


def generate_recommendations(diff: Dict, complexity: str, tokens: int, duration: int) -> List[str]:
    """Generate actionable recommendations for PR."""
    recommendations = []

    # Complexity-based recommendations
    if complexity == 'very_complex':
        recommendations.append("⚠️ Very complex PR - consider breaking into smaller PRs")
        recommendations.append("📋 Use workflow template to optimize token usage")

    # File-based recommendations
    if diff['files_changed'] > 10:
        recommendations.append(f"📦 {diff['files_changed']} files changed - batch operations recommended")

    # Token optimization
    if tokens > 20000:
        recommendations.append(f"🚀 Estimated {tokens} tokens - use context caching")
        recommendations.append("⚡ Consider using optimized-bootstrap.ps1 for context loading")

    # Duration optimization
    if duration > 60:
        recommendations.append(f"⏱️ Estimated {duration} minutes - schedule extended session")

    # Template recommendation
    template = get_workflow_template_recommendation(diff['changed_files'])
    recommendations.append(f"📘 Recommended template: `{template}` (see docs/WORKFLOW_TEMPLATES.md)")

    # Efficiency tips
    if complexity in ['complex', 'very_complex']:
        recommendations.append("💡 Tip: Use automated-insights.py after completion")

    return recommendations


def format_comment(diff: Dict, complexity: str, tokens: int, duration: int, recommendations: List[str]) -> str:
    """Format analysis as GitHub comment."""
    comment = "## 🤖 PR Auto-Analysis Report\n\n"

    # Summary
    comment += "### 📊 Summary\n\n"
    comment += f"- **Complexity**: {complexity.upper()}\n"
    comment += f"- **Files Changed**: {diff['files_changed']}\n"
    comment += f"- **Lines Changed**: +{diff['insertions']} -{diff['deletions']} (total: {diff['total_changes']})\n"
    comment += f"- **Estimated Tokens**: ~{tokens:,}\n"
    comment += f"- **Estimated Duration**: ~{duration} minutes\n"
    comment += f"- **Efficiency Target**: {(1 / (tokens / 10000)):.1f} tasks/10k tokens\n\n"

    # Complexity indicator
    complexity_emojis = {
        'simple': '🟢',
        'moderate': '🟡',
        'complex': '🟠',
        'very_complex': '🔴'
    }
    emoji = complexity_emojis.get(complexity, '⚪')
    comment += f"**Complexity Level**: {emoji} {complexity.upper()}\n\n"

    # Recommendations
    comment += "### 💡 Recommendations\n\n"
    for i, rec in enumerate(recommendations, 1):
        comment += f"{i}. {rec}\n"

    comment += "\n### 📚 Resources\n\n"
    comment += "- [Workflow Templates](docs/WORKFLOW_TEMPLATES.md)\n"
    comment += "- [Efficiency Best Practices](docs/EFFICIENCY_BEST_PRACTICES.md)\n"
    comment += "- [Quick Start Guide](docs/QUICK_START_OPTIMIZED.md)\n"

    comment += f"\n---\n*Analysis generated at {datetime.now().strftime('%Y-%m-%d %H:%M:%S')} UTC*\n"

    return comment


def main():
    """Main entry point."""
    # Get PR diff
    base_branch = os.environ.get('BASE_BRANCH', 'origin/master')
    head_branch = os.environ.get('HEAD_BRANCH', 'HEAD')

    print(f"Analyzing PR: {base_branch}...{head_branch}")

    diff = get_pr_diff(base_branch, head_branch)

    if diff['files_changed'] == 0:
        print("No changes detected in PR")
        return 0

    # Classify complexity
    complexity = classify_complexity(diff)

    # Estimate tokens and duration
    tokens = estimate_tokens(diff, complexity)
    duration = estimate_duration(tokens, complexity)

    # Generate recommendations
    recommendations = generate_recommendations(diff, complexity, tokens, duration)

    # Format comment
    comment = format_comment(diff, complexity, tokens, duration, recommendations)

    # Output results
    print("\n" + comment)

    # Save to file for GitHub Actions
    output_file = os.environ.get('GITHUB_OUTPUT')
    if output_file:
        with open(output_file, 'a', encoding='utf-8') as f:
            # Use delimiter to avoid issues with multiline content
            f.write("comment<<EOF\n")
            f.write(comment)
            f.write("\nEOF\n")

    # Also save analysis as JSON
    analysis = {
        'timestamp': datetime.now().isoformat(),
        'diff': diff,
        'complexity': complexity,
        'estimated_tokens': tokens,
        'estimated_duration_minutes': duration,
        'recommendations': recommendations
    }

    os.makedirs('.automation/pr-analysis', exist_ok=True)
    pr_number = os.environ.get('PR_NUMBER', 'unknown')
    with open(f'.automation/pr-analysis/pr-{pr_number}.json', 'w', encoding='utf-8') as f:
        json.dump(analysis, f, indent=2)

    print(f"\n✅ Analysis saved to .automation/pr-analysis/pr-{pr_number}.json")

    return 0


if __name__ == '__main__':
    sys.exit(main())
