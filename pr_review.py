#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
pr_review.py - Automated PR Review Command

Analyzes pull request changes using RAG + LSP for comprehensive code review.

Usage:
    python pr_review.py <pr-number>
    python pr_review.py <branch-name>
    python pr_review.py --current

Examples:
    python pr_review.py 123
    python pr_review.py feature/new-widget
    python pr_review.py --current

Author: Claude IDE System
Version: 1.0.0
Date: 2025-10-09
"""

import sys
import subprocess
from pathlib import Path
from typing import List, Dict, Optional
import json
from datetime import datetime

# Add parent to path
sys.path.insert(0, str(Path(__file__).parent.parent))

# Import UTF-8 protection
from utils.encoding import init_utf8_output, safe_print
init_utf8_output()

from rag.vector_store import VectorStoreManager


def run_command(cmd: List[str]) -> tuple:
    """Run shell command and return output."""
    try:
        result = subprocess.run(
            cmd,
            capture_output=True,
            text=True,
            encoding='utf-8',
            errors='replace'
        )
        return result.returncode, result.stdout, result.stderr
    except Exception as e:
        return 1, "", str(e)


def get_pr_files(pr_ref: str = None) -> List[str]:
    """Get list of changed files in PR."""

    # Determine base branch (usually main or master)
    code, output, _ = run_command(['git', 'rev-parse', '--abbrev-ref', 'HEAD'])
    current_branch = output.strip()

    # Determine comparison branch
    if pr_ref == '--current' or pr_ref is None:
        # Compare current branch with main/master
        code, output, _ = run_command(['git', 'remote', 'show', 'origin'])
        if 'HEAD branch: main' in output:
            base = 'main'
        elif 'HEAD branch: master' in output:
            base = 'master'
        else:
            base = 'main'  # default

        compare = f"origin/{base}...HEAD"
    else:
        # Compare specific PR branch
        compare = pr_ref

    # Get changed files
    code, output, _ = run_command(['git', 'diff', '--name-only', compare])

    if code != 0:
        return []

    files = [f.strip() for f in output.split('\n') if f.strip()]
    return files


def get_file_diff(file_path: str, pr_ref: str = None) -> str:
    """Get diff for specific file."""

    if pr_ref == '--current' or pr_ref is None:
        # Get base branch
        code, output, _ = run_command(['git', 'remote', 'show', 'origin'])
        if 'HEAD branch: main' in output:
            base = 'origin/main'
        else:
            base = 'origin/master'

        compare = base
    else:
        compare = pr_ref

    code, output, _ = run_command(['git', 'diff', compare, '--', file_path])
    return output if code == 0 else ""


def analyze_file_changes(file_path: str, diff: str, vector_store: VectorStoreManager) -> Dict:
    """Analyze changes in a file using RAG."""

    # Extract added lines (lines starting with +)
    added_lines = [
        line[1:] for line in diff.split('\n')
        if line.startswith('+') and not line.startswith('+++')
    ]

    # Extract removed lines (lines starting with -)
    removed_lines = [
        line[1:] for line in diff.split('\n')
        if line.startswith('-') and not line.startswith('---')
    ]

    # Create search query from changes
    change_context = ' '.join(added_lines[:10])  # First 10 added lines

    issues = []
    suggestions = []

    # Check for common issues

    # 1. Hardcoded strings
    if any('Text(' in line and 'AppLocalizations' not in line for line in added_lines):
        issues.append({
            'type': 'i18n',
            'severity': 'medium',
            'message': 'Hardcoded strings detected. Use AppLocalizations for i18n.'
        })

    # 2. Magic numbers
    if any(any(str(num) in line for num in range(10, 100)) for line in added_lines):
        issues.append({
            'type': 'magic_number',
            'severity': 'low',
            'message': 'Magic numbers detected. Consider using named constants.'
        })

    # 3. TODO/FIXME
    if any('TODO' in line or 'FIXME' in line for line in added_lines):
        issues.append({
            'type': 'incomplete',
            'severity': 'medium',
            'message': 'TODO/FIXME comments found. Complete before merging.'
        })

    # 4. Large additions without tests
    if len(added_lines) > 50 and 'test' not in file_path.lower():
        issues.append({
            'type': 'test_coverage',
            'severity': 'high',
            'message': f'Large change ({len(added_lines)} lines) without tests.'
        })

    # 5. Commented code
    if any(line.strip().startswith('//') and len(line) > 20 for line in added_lines):
        commented_count = sum(1 for line in added_lines if line.strip().startswith('//'))
        if commented_count > 5:
            issues.append({
                'type': 'commented_code',
                'severity': 'low',
                'message': f'{commented_count} lines of commented code. Remove if unused.'
            })

    # Search for similar implementations using RAG
    if change_context.strip():
        try:
            similar_code = vector_store.search(
                change_context,
                collection='code',
                top_k=3
            )

            if similar_code:
                suggestions.append({
                    'type': 'pattern',
                    'message': 'Found similar implementations in codebase:',
                    'examples': [
                        {
                            'file': r['file'],
                            'similarity': f"{r['score'] * 100:.0f}%"
                        }
                        for r in similar_code[:2]
                    ]
                })
        except:
            pass  # RAG search failed, continue without suggestions

    return {
        'file': file_path,
        'lines_added': len(added_lines),
        'lines_removed': len(removed_lines),
        'issues': issues,
        'suggestions': suggestions
    }


def generate_review_report(analyses: List[Dict], pr_ref: str) -> Dict:
    """Generate comprehensive review report."""

    total_issues = sum(len(a['issues']) for a in analyses)
    high_severity = sum(
        len([i for i in a['issues'] if i['severity'] == 'high'])
        for a in analyses
    )
    medium_severity = sum(
        len([i for i in a['issues'] if i['severity'] == 'medium'])
        for a in analyses
    )

    total_lines_added = sum(a['lines_added'] for a in analyses)
    total_lines_removed = sum(a['lines_removed'] for a in analyses)

    # Determine approval status
    if high_severity > 0:
        status = 'CHANGES_REQUESTED'
        emoji = '❌'
    elif medium_severity > 3:
        status = 'CHANGES_REQUESTED'
        emoji = '⚠️'
    elif total_issues > 0:
        status = 'COMMENT'
        emoji = '💬'
    else:
        status = 'APPROVED'
        emoji = '✅'

    return {
        'pr_ref': pr_ref,
        'status': status,
        'emoji': emoji,
        'files_changed': len(analyses),
        'lines_added': total_lines_added,
        'lines_removed': total_lines_removed,
        'total_issues': total_issues,
        'high_severity': high_severity,
        'medium_severity': medium_severity,
        'analyses': analyses,
        'generated_at': datetime.now().isoformat()
    }


def print_review_report(report: Dict):
    """Print review report in readable format."""

    print("\n" + "="*70)
    print("PR CODE REVIEW")
    print("="*70)

    print(f"\nPR: {report['pr_ref']}")
    print(f"Status: {report['emoji']} {report['status']}")
    print(f"Files changed: {report['files_changed']}")
    print(f"Lines: +{report['lines_added']} -{report['lines_removed']}")

    if report['total_issues'] > 0:
        print(f"\nIssues found: {report['total_issues']}")
        print(f"  High severity: {report['high_severity']}")
        print(f"  Medium severity: {report['medium_severity']}")

    print("\n" + "="*70)
    print("FILE-BY-FILE ANALYSIS")
    print("="*70)

    for analysis in report['analyses']:
        print(f"\n📄 {analysis['file']}")
        print(f"   +{analysis['lines_added']} -{analysis['lines_removed']} lines")

        if analysis['issues']:
            print(f"\n   Issues ({len(analysis['issues'])}):")
            for issue in analysis['issues']:
                severity_emoji = {
                    'high': '🔴',
                    'medium': '🟡',
                    'low': '🟢'
                }.get(issue['severity'], '⚪')

                print(f"   {severity_emoji} [{issue['severity'].upper()}] {issue['message']}")

        if analysis['suggestions']:
            print(f"\n   Suggestions:")
            for suggestion in analysis['suggestions']:
                print(f"   💡 {suggestion['message']}")
                if 'examples' in suggestion:
                    for ex in suggestion['examples']:
                        print(f"      - {ex['file']} ({ex['similarity']} similar)")

    print("\n" + "="*70)
    print("SUMMARY")
    print("="*70)

    if report['status'] == 'APPROVED':
        safe_print("\n✅ APPROVED - No major issues found")
        print("   Code looks good! Consider merging.")
    elif report['status'] == 'COMMENT':
        safe_print("\n💬 COMMENT - Minor issues found")
        print("   Review comments above. Fix if needed.")
    else:
        safe_print("\n❌ CHANGES REQUESTED - Issues require attention")
        print("   Please address high/medium severity issues before merging.")

    print()


def main():
    """Main entry point."""

    if len(sys.argv) < 2 or '--help' in sys.argv:
        print(__doc__)
        return 0

    pr_ref = sys.argv[1]

    print(f"\n🔍 Analyzing PR: {pr_ref}")

    # Get changed files
    print("\nFetching changed files...")
    files = get_pr_files(pr_ref)

    if not files:
        safe_print("\n[!] No files changed or error fetching changes")
        return 1

    print(f"Found {len(files)} changed files")

    # Filter to code files only
    code_extensions = {'.dart', '.py', '.js', '.ts', '.tsx', '.jsx', '.java', '.go', '.rs'}
    code_files = [f for f in files if Path(f).suffix in code_extensions]

    if not code_files:
        safe_print("\n[!] No code files to review")
        return 0

    print(f"Reviewing {len(code_files)} code files...")

    # Initialize RAG
    current = Path.cwd()
    while current != current.parent:
        if (current / '.claude-ide').exists():
            project_root = str(current)
            break
        current = current.parent
    else:
        project_root = str(Path.cwd())

    print("\nLoading vector store...")
    vector_store = VectorStoreManager(project_root)

    # Analyze each file
    analyses = []
    for i, file_path in enumerate(code_files, 1):
        print(f"\nAnalyzing ({i}/{len(code_files)}): {file_path}")

        diff = get_file_diff(file_path, pr_ref)
        if not diff:
            continue

        analysis = analyze_file_changes(file_path, diff, vector_store)
        analyses.append(analysis)

    # Generate and print report
    report = generate_review_report(analyses, pr_ref)
    print_review_report(report)

    # Save report
    report_dir = Path(project_root) / '.claude-ide' / 'logs' / 'pr-reviews'
    report_dir.mkdir(parents=True, exist_ok=True)

    report_file = report_dir / f"pr-review-{datetime.now().strftime('%Y%m%d-%H%M%S')}.json"
    with open(report_file, 'w', encoding='utf-8') as f:
        json.dump(report, f, indent=2, ensure_ascii=False)

    safe_print(f"\n[OK] Report saved: {report_file}")

    # Exit code based on status
    if report['status'] == 'APPROVED':
        return 0
    elif report['status'] == 'COMMENT':
        return 0
    else:
        return 1  # Changes requested


if __name__ == "__main__":
    sys.exit(main())
