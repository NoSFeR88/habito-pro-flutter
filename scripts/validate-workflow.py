#!/usr/bin/env python3
"""
Workflow Template Validation Script
Validates that PRs/commits follow workflow templates and compares actual vs projected metrics.
"""

import json
import os
import re
import subprocess
from datetime import datetime
from typing import Dict, List, Optional, Tuple


# Workflow templates with expected token ranges
WORKFLOW_TEMPLATES = {
    'add-feature': {
        'name': 'Add Feature',
        'expected_tokens': (10000, 25000),
        'expected_duration': (40, 80),
        'patterns': ['feat:', 'feature:', 'add:'],
        'files_typical': ['lib/screens/', 'lib/widgets/', 'lib/providers/'],
        'savings_vs_manual': 0.60
    },
    'fix-bug': {
        'name': 'Fix Bug',
        'expected_tokens': (5000, 15000),
        'expected_duration': (20, 50),
        'patterns': ['fix:', 'bug:', 'bugfix:'],
        'files_typical': ['lib/', 'test/'],
        'savings_vs_manual': 0.67
    },
    'add-translation': {
        'name': 'Add Translation',
        'expected_tokens': (3000, 8000),
        'expected_duration': (15, 30),
        'patterns': ['i18n:', 'l10n:', 'translation:', 'locale:'],
        'files_typical': ['lib/l10n/', '.arb'],
        'savings_vs_manual': 0.50
    },
    'refactor': {
        'name': 'Refactor',
        'expected_tokens': (8000, 20000),
        'expected_duration': (30, 60),
        'patterns': ['refactor:', 'refact:', 'cleanup:'],
        'files_typical': ['lib/'],
        'savings_vs_manual': 0.61
    },
    'add-tests': {
        'name': 'Add Tests',
        'expected_tokens': (6000, 15000),
        'expected_duration': (25, 50),
        'patterns': ['test:', 'tests:', 'testing:'],
        'files_typical': ['test/'],
        'savings_vs_manual': 0.59
    },
    'update-dependencies': {
        'name': 'Update Dependencies',
        'expected_tokens': (4000, 10000),
        'expected_duration': (15, 35),
        'patterns': ['deps:', 'dependency:', 'dependencies:', 'chore(deps):'],
        'files_typical': ['pubspec.yaml', 'pubspec.lock'],
        'savings_vs_manual': 0.60
    },
    'create-pr': {
        'name': 'Create PR',
        'expected_tokens': (5000, 12000),
        'expected_duration': (20, 40),
        'patterns': ['pr:', 'pull-request:'],
        'files_typical': [],
        'savings_vs_manual': 0.63
    },
    'review-code': {
        'name': 'Review Code',
        'expected_tokens': (6000, 15000),
        'expected_duration': (25, 50),
        'patterns': ['review:', 'code-review:'],
        'files_typical': [],
        'savings_vs_manual': 0.60
    }
}


def run_command(cmd: List[str]) -> Tuple[str, int]:
    """Run shell command and return output."""
    try:
        result = subprocess.run(cmd, capture_output=True, text=True, check=False)
        return result.stdout.strip(), result.returncode
    except Exception as e:
        return f"Error: {e}", 1


def get_commit_message(commit_sha: str = 'HEAD') -> str:
    """Get commit message."""
    output, _ = run_command(['git', 'log', '-1', '--pretty=%B', commit_sha])
    return output


def detect_workflow_template(commit_message: str, changed_files: List[str]) -> Optional[str]:
    """Detect which workflow template was likely used."""
    commit_lower = commit_message.lower()

    # Check commit message patterns
    for template_id, template in WORKFLOW_TEMPLATES.items():
        for pattern in template['patterns']:
            if pattern.lower() in commit_lower:
                return template_id

    # Check file patterns if no commit pattern match
    if changed_files:
        for template_id, template in WORKFLOW_TEMPLATES.items():
            if template['files_typical']:
                for file_pattern in template['files_typical']:
                    if any(file_pattern in f for f in changed_files):
                        return template_id

    return None


def get_changed_files(base: str = 'HEAD~1', head: str = 'HEAD') -> List[str]:
    """Get list of changed files."""
    output, _ = run_command(['git', 'diff', '--name-only', f'{base}..{head}'])
    return [f for f in output.split('\n') if f]


def validate_commit_structure(commit_message: str) -> Dict:
    """Validate commit message follows conventional commits."""
    # Pattern: type(scope): subject
    pattern = r'^(feat|fix|docs|style|refactor|perf|test|chore|ci|i18n|l10n)(\([a-z\-]+\))?: .{1,100}'

    matches = re.match(pattern, commit_message, re.MULTILINE)

    return {
        'valid': bool(matches),
        'message': commit_message.split('\n')[0] if commit_message else '',
        'follows_convention': bool(matches)
    }


def estimate_actual_metrics(changed_files: List[str]) -> Dict:
    """Estimate actual tokens and duration from changes."""
    # Get diff stats
    output, _ = run_command(['git', 'diff', '--stat', 'HEAD~1..HEAD'])

    insertions = 0
    deletions = 0

    for line in output.split('\n'):
        if 'insertion' in line or 'deletion' in line:
            parts = line.split(',')
            for part in parts:
                if 'insertion' in part:
                    insertions = int(part.strip().split()[0])
                if 'deletion' in part:
                    deletions = int(part.strip().split()[0])

    # Rough estimation
    tokens_per_line = 3
    base_tokens = len(changed_files) * 100
    change_tokens = (insertions + deletions) * tokens_per_line

    estimated_tokens = base_tokens + change_tokens
    estimated_duration = max(10, int(estimated_tokens / 500))  # 500 tokens per minute baseline

    return {
        'estimated_tokens': estimated_tokens,
        'estimated_duration_minutes': estimated_duration,
        'files_changed': len(changed_files),
        'insertions': insertions,
        'deletions': deletions
    }


def validate_against_template(
    template_id: str,
    actual_metrics: Dict,
    commit_message: str
) -> Dict:
    """Validate actual metrics against template expectations."""
    template = WORKFLOW_TEMPLATES.get(template_id)
    if not template:
        return {'valid': False, 'reason': 'Template not found'}

    tokens = actual_metrics['estimated_tokens']
    duration = actual_metrics['estimated_duration_minutes']

    # Check if within expected ranges
    tokens_in_range = template['expected_tokens'][0] <= tokens <= template['expected_tokens'][1]
    duration_in_range = template['expected_duration'][0] <= duration <= template['expected_duration'][1]

    # Calculate variance
    tokens_mid = sum(template['expected_tokens']) / 2
    duration_mid = sum(template['expected_duration']) / 2

    tokens_variance = ((tokens - tokens_mid) / tokens_mid) * 100
    duration_variance = ((duration - duration_mid) / duration_mid) * 100

    # Determine if acceptable
    acceptable = abs(tokens_variance) <= 50 and abs(duration_variance) <= 50

    validation = {
        'valid': tokens_in_range and duration_in_range,
        'acceptable': acceptable,
        'template_name': template['name'],
        'expected_tokens': template['expected_tokens'],
        'actual_tokens': tokens,
        'tokens_in_range': tokens_in_range,
        'tokens_variance_percent': round(tokens_variance, 1),
        'expected_duration': template['expected_duration'],
        'actual_duration': duration,
        'duration_in_range': duration_in_range,
        'duration_variance_percent': round(duration_variance, 1),
        'projected_savings': template['savings_vs_manual']
    }

    # Add warnings/recommendations
    warnings = []
    if not tokens_in_range:
        if tokens > template['expected_tokens'][1]:
            warnings.append(f"⚠️ Token usage {tokens_variance:+.1f}% higher than template - consider splitting task")
        else:
            warnings.append(f"✓ Token usage {abs(tokens_variance):.1f}% lower than template - excellent!")

    if not duration_in_range:
        if duration > template['expected_duration'][1]:
            warnings.append(f"⚠️ Duration {duration_variance:+.1f}% longer than template - optimize workflow")
        else:
            warnings.append(f"✓ Duration {abs(duration_variance):.1f}% shorter than template - great efficiency!")

    validation['warnings'] = warnings

    return validation


def generate_report(
    commit_message: str,
    template_id: Optional[str],
    actual_metrics: Dict,
    validation: Optional[Dict],
    commit_structure: Dict
) -> str:
    """Generate validation report."""
    report = "## 🔍 Workflow Template Validation Report\n\n"

    # Commit structure
    report += "### 📝 Commit Message\n\n"
    if commit_structure['valid']:
        report += f"✅ **Valid**: Follows conventional commits\n"
    else:
        report += f"❌ **Invalid**: Does not follow conventional commits\n"
    report += f"- Message: `{commit_structure['message']}`\n\n"

    # Template detection
    report += "### 🎯 Template Detection\n\n"
    if template_id:
        template_name = WORKFLOW_TEMPLATES[template_id]['name']
        report += f"✅ **Detected**: `{template_name}` (id: `{template_id}`)\n\n"
    else:
        report += f"❌ **Not detected**: No matching template found\n"
        report += f"💡 Consider using workflow templates from `docs/WORKFLOW_TEMPLATES.md`\n\n"
        return report

    # Actual metrics
    report += "### 📊 Actual Metrics\n\n"
    report += f"- **Files Changed**: {actual_metrics['files_changed']}\n"
    report += f"- **Lines**: +{actual_metrics['insertions']} -{actual_metrics['deletions']}\n"
    report += f"- **Estimated Tokens**: {actual_metrics['estimated_tokens']:,}\n"
    report += f"- **Estimated Duration**: {actual_metrics['estimated_duration_minutes']} minutes\n\n"

    # Validation
    if validation:
        report += "### ✅ Validation Results\n\n"

        status_emoji = "✅" if validation['valid'] else ("⚠️" if validation['acceptable'] else "❌")
        status_text = "VALID" if validation['valid'] else ("ACCEPTABLE" if validation['acceptable'] else "OUT OF RANGE")

        report += f"{status_emoji} **Status**: {status_text}\n\n"

        # Tokens comparison
        report += f"**Tokens**:\n"
        report += f"- Expected: {validation['expected_tokens'][0]:,} - {validation['expected_tokens'][1]:,}\n"
        report += f"- Actual: {validation['actual_tokens']:,} ({validation['tokens_variance_percent']:+.1f}%)\n"
        report += f"- In Range: {'✅ Yes' if validation['tokens_in_range'] else '❌ No'}\n\n"

        # Duration comparison
        report += f"**Duration**:\n"
        report += f"- Expected: {validation['expected_duration'][0]} - {validation['expected_duration'][1]} min\n"
        report += f"- Actual: {validation['actual_duration']} min ({validation['duration_variance_percent']:+.1f}%)\n"
        report += f"- In Range: {'✅ Yes' if validation['duration_in_range'] else '❌ No'}\n\n"

        # Warnings
        if validation['warnings']:
            report += "**Observations**:\n"
            for warning in validation['warnings']:
                report += f"- {warning}\n"
            report += "\n"

        # Projected savings
        savings_percent = validation['projected_savings'] * 100
        report += f"**Projected Savings**: {savings_percent:.0f}% vs manual workflow\n\n"

    # Recommendations
    report += "### 💡 Recommendations\n\n"
    if validation and validation['valid']:
        report += "- ✅ Excellent! Workflow matches template expectations\n"
        report += "- 📊 Log this session for telemetry analysis\n"
    elif validation and validation['acceptable']:
        report += "- ⚠️ Metrics within acceptable range but outside ideal\n"
        report += "- 📝 Review workflow for optimization opportunities\n"
    else:
        report += "- ❌ Metrics significantly deviate from template\n"
        report += "- 🔍 Review `docs/WORKFLOW_TEMPLATES.md` for guidance\n"
        report += "- 💬 Consider updating template if task was inherently complex\n"

    report += f"\n---\n*Validation generated at {datetime.now().strftime('%Y-%m-%d %H:%M:%S')} UTC*\n"

    return report


def main():
    """Main entry point."""
    print("🔍 Validating workflow template...\n")

    # Get commit info
    commit_message = get_commit_message()
    changed_files = get_changed_files()

    print(f"Commit: {commit_message.split(chr(10))[0]}")
    print(f"Files changed: {len(changed_files)}\n")

    # Validate commit structure
    commit_structure = validate_commit_structure(commit_message)

    # Detect template
    template_id = detect_workflow_template(commit_message, changed_files)

    # Estimate actual metrics
    actual_metrics = estimate_actual_metrics(changed_files)

    # Validate against template
    validation = None
    if template_id:
        validation = validate_against_template(template_id, actual_metrics, commit_message)

    # Generate report
    report = generate_report(commit_message, template_id, actual_metrics, validation, commit_structure)

    print(report)

    # Save report
    os.makedirs('.automation/workflow-validation', exist_ok=True)
    timestamp = datetime.now().strftime('%Y%m%d-%H%M%S')
    report_file = f'.automation/workflow-validation/validation-{timestamp}.md'

    with open(report_file, 'w', encoding='utf-8') as f:
        f.write(report)

    print(f"\n✅ Report saved to: {report_file}")

    # Exit code
    if validation and validation['valid']:
        return 0
    elif validation and validation['acceptable']:
        return 0
    else:
        return 1


if __name__ == '__main__':
    import sys
    sys.exit(main())
