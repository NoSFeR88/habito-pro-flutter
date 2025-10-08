#!/usr/bin/env python3
"""
Task Classification System
Classifies tasks automatically by type using pattern matching and ML-lite approach.
"""

import json
import os
import re
from typing import Dict, List, Tuple
from collections import Counter


# Task type definitions with keywords
TASK_TYPES = {
    'refactor': {
        'keywords': [
            'refactor', 'refact', 'cleanup', 'optimize', 'improve',
            'restructure', 'reorganize', 'simplify', 'clean up',
            'code quality', 'technical debt', 'architecture'
        ],
        'patterns': [
            r'\brefactor\b', r'\bclean\s*up\b', r'\boptimize\b',
            r'\brestructure\b', r'\bimprove\b'
        ],
        'file_indicators': ['lib/', 'src/'],
        'typical_complexity': 'moderate'
    },
    'testing': {
        'keywords': [
            'test', 'tests', 'testing', 'unit test', 'widget test',
            'integration test', 'e2e', 'coverage', 'mock', 'spec'
        ],
        'patterns': [
            r'\btest\b', r'\btesting\b', r'\bunit\s*test\b',
            r'\bwidget\s*test\b', r'\bcoverage\b'
        ],
        'file_indicators': ['test/', 'spec/', '_test.dart', '_spec.dart'],
        'typical_complexity': 'moderate'
    },
    'i18n': {
        'keywords': [
            'i18n', 'l10n', 'translation', 'locale', 'localization',
            'internationalization', 'language', 'translate', 'arb'
        ],
        'patterns': [
            r'\bi18n\b', r'\bl10n\b', r'\btranslat\w+\b',
            r'\blocal\w+\b', r'\blanguage\b'
        ],
        'file_indicators': ['l10n/', 'i18n/', '.arb', 'locale'],
        'typical_complexity': 'simple'
    },
    'bugfix': {
        'keywords': [
            'fix', 'bug', 'bugfix', 'issue', 'error', 'crash',
            'problem', 'resolve', 'hotfix', 'patch', 'debug'
        ],
        'patterns': [
            r'\bfix\b', r'\bbug\b', r'\bissue\b', r'\bcrash\b',
            r'\berror\b', r'\bhotfix\b'
        ],
        'file_indicators': [],
        'typical_complexity': 'moderate'
    },
    'feature': {
        'keywords': [
            'feature', 'feat', 'add', 'new', 'implement', 'create',
            'develop', 'build', 'enhancement', 'functionality'
        ],
        'patterns': [
            r'\bfeat\b', r'\bfeature\b', r'\badd\b', r'\bnew\b',
            r'\bimplement\b', r'\bcreate\b'
        ],
        'file_indicators': ['lib/screens/', 'lib/widgets/', 'lib/features/'],
        'typical_complexity': 'complex'
    },
    'docs': {
        'keywords': [
            'docs', 'documentation', 'readme', 'comment', 'docstring',
            'guide', 'tutorial', 'explain', 'document'
        ],
        'patterns': [
            r'\bdocs?\b', r'\bdocumentation\b', r'\breadme\b',
            r'\bcomment\b', r'\bguide\b'
        ],
        'file_indicators': ['docs/', 'README.md', '.md', 'CHANGELOG'],
        'typical_complexity': 'simple'
    },
    'chore': {
        'keywords': [
            'chore', 'dependency', 'dependencies', 'deps', 'upgrade',
            'update', 'version', 'bump', 'maintenance', 'config'
        ],
        'patterns': [
            r'\bchore\b', r'\bdep\w*\b', r'\bupgrade\b',
            r'\bupdate\b', r'\bversion\b', r'\bbump\b'
        ],
        'file_indicators': ['pubspec.yaml', 'package.json', '.config', '.yml'],
        'typical_complexity': 'simple'
    },
    'ci': {
        'keywords': [
            'ci', 'cd', 'pipeline', 'workflow', 'action', 'github action',
            'automation', 'deploy', 'release', 'build'
        ],
        'patterns': [
            r'\bci\b', r'\bcd\b', r'\bpipeline\b', r'\bworkflow\b',
            r'\baction\b', r'\bautomation\b'
        ],
        'file_indicators': ['.github/', '.gitlab-ci', 'Jenkinsfile', '.circleci'],
        'typical_complexity': 'moderate'
    }
}


class TaskClassifier:
    """Classifies tasks based on description and file changes."""

    def __init__(self):
        self.task_types = TASK_TYPES
        self.history_file = '.automation/classification-history.json'
        os.makedirs(os.path.dirname(self.history_file), exist_ok=True)

    def classify(
        self,
        description: str,
        changed_files: List[str] = None,
        commit_message: str = None
    ) -> Dict:
        """
        Classify a task based on description, files, and commit message.

        Returns:
            Dict with classification results including type, confidence, and reasoning
        """
        if changed_files is None:
            changed_files = []

        # Combine all text for analysis
        all_text = description.lower()
        if commit_message:
            all_text += " " + commit_message.lower()

        # Score each task type
        scores = {}
        reasoning = {}

        for task_type, config in self.task_types.items():
            score = 0
            reasons = []

            # Check keywords
            keyword_matches = 0
            for keyword in config['keywords']:
                if keyword.lower() in all_text:
                    keyword_matches += 1

            if keyword_matches > 0:
                keyword_score = min(keyword_matches * 10, 50)  # Cap at 50
                score += keyword_score
                reasons.append(f"{keyword_matches} keyword match(es)")

            # Check regex patterns
            pattern_matches = 0
            for pattern in config['patterns']:
                if re.search(pattern, all_text, re.IGNORECASE):
                    pattern_matches += 1

            if pattern_matches > 0:
                pattern_score = min(pattern_matches * 15, 40)  # Cap at 40
                score += pattern_score
                reasons.append(f"{pattern_matches} pattern match(es)")

            # Check file indicators
            file_matches = 0
            for indicator in config['file_indicators']:
                for file_path in changed_files:
                    if indicator.lower() in file_path.lower():
                        file_matches += 1
                        break

            if file_matches > 0:
                file_score = min(file_matches * 20, 30)  # Cap at 30
                score += file_score
                reasons.append(f"{file_matches} file indicator(s)")

            scores[task_type] = score
            reasoning[task_type] = reasons

        # Find top match
        if not scores or max(scores.values()) == 0:
            return {
                'task_type': 'unknown',
                'confidence': 0.0,
                'all_scores': scores,
                'reasoning': 'No clear indicators found',
                'typical_complexity': 'moderate'
            }

        sorted_types = sorted(scores.items(), key=lambda x: x[1], reverse=True)
        top_type, top_score = sorted_types[0]
        second_score = sorted_types[1][1] if len(sorted_types) > 1 else 0

        # Calculate confidence (0.0 - 1.0)
        max_possible_score = 120  # 50 (keywords) + 40 (patterns) + 30 (files)
        confidence = min(top_score / max_possible_score, 1.0)

        # Reduce confidence if another type is close
        if second_score > 0 and top_score / second_score < 1.5:
            confidence *= 0.8

        return {
            'task_type': top_type,
            'confidence': round(confidence, 2),
            'score': top_score,
            'all_scores': scores,
            'reasoning': reasoning[top_type],
            'typical_complexity': self.task_types[top_type]['typical_complexity'],
            'alternatives': [
                {'type': t, 'score': s}
                for t, s in sorted_types[1:3]
                if s > 0
            ]
        }

    def classify_batch(self, tasks: List[Dict]) -> List[Dict]:
        """Classify multiple tasks."""
        results = []
        for task in tasks:
            classification = self.classify(
                description=task.get('description', ''),
                changed_files=task.get('changed_files', []),
                commit_message=task.get('commit_message', '')
            )
            classification['task_id'] = task.get('task_id', 'unknown')
            results.append(classification)
        return results

    def save_classification(self, classification: Dict, task_id: str = None):
        """Save classification to history for learning."""
        history = []
        if os.path.exists(self.history_file):
            with open(self.history_file, 'r', encoding='utf-8') as f:
                history = json.load(f)

        entry = {
            'task_id': task_id or f"task-{len(history) + 1}",
            'classification': classification,
            'timestamp': __import__('datetime').datetime.now().isoformat()
        }

        history.append(entry)

        # Keep last 100 entries
        history = history[-100:]

        with open(self.history_file, 'w', encoding='utf-8') as f:
            json.dump(history, f, indent=2)

    def get_accuracy_stats(self) -> Dict:
        """Get classification accuracy statistics from history."""
        if not os.path.exists(self.history_file):
            return {'total': 0, 'by_type': {}, 'avg_confidence': 0.0}

        with open(self.history_file, 'r', encoding='utf-8') as f:
            history = json.load(f)

        if not history:
            return {'total': 0, 'by_type': {}, 'avg_confidence': 0.0}

        by_type = Counter()
        confidences = []

        for entry in history:
            task_type = entry['classification']['task_type']
            confidence = entry['classification']['confidence']

            by_type[task_type] += 1
            confidences.append(confidence)

        return {
            'total': len(history),
            'by_type': dict(by_type),
            'avg_confidence': round(sum(confidences) / len(confidences), 2) if confidences else 0.0,
            'high_confidence_count': sum(1 for c in confidences if c >= 0.7),
            'high_confidence_percent': round(sum(1 for c in confidences if c >= 0.7) / len(confidences) * 100, 1) if confidences else 0.0
        }


def main():
    """CLI for task classification."""
    import sys

    if len(sys.argv) < 2:
        print("Usage: python classify-task.py [command] [args]")
        print("\nCommands:")
        print("  classify <description>           - Classify a task by description")
        print("  classify-commit <sha>            - Classify a commit")
        print("  stats                            - Show classification statistics")
        print("\nExamples:")
        print('  python classify-task.py classify "Add unit tests for habit provider"')
        print('  python classify-task.py classify "Fix overflow in stats screen"')
        print('  python classify-task.py stats')
        return

    command = sys.argv[1]
    classifier = TaskClassifier()

    if command == 'classify':
        if len(sys.argv) < 3:
            print("Error: Description required")
            return

        description = ' '.join(sys.argv[2:])
        result = classifier.classify(description)

        print(f"\n🔍 Task Classification\n")
        print(f"Description: {description}")
        print(f"\nType: {result['task_type']}")
        print(f"Confidence: {result['confidence']:.0%}")
        print(f"Complexity: {result['typical_complexity']}")
        print(f"\nReasoning: {', '.join(result['reasoning']) if result['reasoning'] else 'No specific indicators'}")

        if result['alternatives']:
            print(f"\nAlternatives:")
            for alt in result['alternatives']:
                print(f"  - {alt['type']} (score: {alt['score']})")

        # Save to history
        classifier.save_classification(result)

    elif command == 'classify-commit':
        import subprocess

        sha = sys.argv[2] if len(sys.argv) > 2 else 'HEAD'

        # Get commit message
        msg_result = subprocess.run(
            ['git', 'log', '-1', '--pretty=%B', sha],
            capture_output=True,
            text=True
        )
        commit_message = msg_result.stdout.strip()

        # Get changed files
        files_result = subprocess.run(
            ['git', 'diff-tree', '--no-commit-id', '--name-only', '-r', sha],
            capture_output=True,
            text=True
        )
        changed_files = [f for f in files_result.stdout.strip().split('\n') if f]

        result = classifier.classify(
            description=commit_message,
            changed_files=changed_files,
            commit_message=commit_message
        )

        print(f"\n🔍 Commit Classification\n")
        print(f"Commit: {sha}")
        print(f"Message: {commit_message.split(chr(10))[0]}")
        print(f"Files: {len(changed_files)}")
        print(f"\nType: {result['task_type']}")
        print(f"Confidence: {result['confidence']:.0%}")
        print(f"Complexity: {result['typical_complexity']}")

        classifier.save_classification(result, f"commit-{sha[:7]}")

    elif command == 'stats':
        stats = classifier.get_accuracy_stats()

        print(f"\n📊 Classification Statistics\n")
        print(f"Total Classifications: {stats['total']}")
        print(f"Average Confidence: {stats['avg_confidence']:.0%}")
        print(f"High Confidence (≥70%): {stats.get('high_confidence_count', 0)} ({stats.get('high_confidence_percent', 0):.1f}%)")
        print(f"\nBreakdown by Type:")

        for task_type, count in sorted(stats['by_type'].items(), key=lambda x: x[1], reverse=True):
            percent = (count / stats['total'] * 100) if stats['total'] > 0 else 0
            print(f"  {task_type}: {count} ({percent:.1f}%)")

    else:
        print(f"Unknown command: {command}")


if __name__ == '__main__':
    main()
