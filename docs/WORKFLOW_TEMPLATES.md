# 🚀 WORKFLOW TEMPLATES - RITMO

**Versión**: 1.0.0
**Creado**: 2025-10-08 (Sesión 57)
**Propósito**: Templates optimizados para tareas comunes (reduce tokens 30-50%)

---

## 📋 ÍNDICE DE TEMPLATES

1. [Add New Feature](#template-1-add-new-feature)
2. [Fix Bug](#template-2-fix-bug)
3. [Add Translation](#template-3-add-translation)
4. [Refactor Code](#template-4-refactor-code)
5. [Add Tests](#template-5-add-tests)
6. [Update Dependencies](#template-6-update-dependencies)
7. [Create PR](#template-7-create-pr)
8. [Review Code](#template-8-review-code)

---

## TEMPLATE 1: Add New Feature

### Quick Command:
```
Add feature: [FEATURE_NAME]
- Location: [SCREEN/PROVIDER/SERVICE]
- Implementation: [BRIEF_DESCRIPTION]
- i18n required: [YES/NO]
- Tests needed: [YES/NO]
```

### Optimized Workflow:
```
1. Read: docs/PROJECT_INDEX.md (find file location)
2. Read: [target_file] (analyze current code)
3. Edit: Add feature code
4. If i18n: Edit lib/l10n/app_en.arb + app_es.arb
5. If tests: Write test file
6. Bash: flutter test (validate)
7. Bash: git add + commit
```

### Example:
```
Add feature: Dark mode toggle in Settings
- Location: lib/screens/settings_screen.dart
- Implementation: Add switch widget, connect to ThemeProvider
- i18n required: YES (darkMode, lightMode keys)
- Tests needed: NO (widget test exists)

ESTIMATED TOKENS: ~8k (vs 20k without template)
```

---

## TEMPLATE 2: Fix Bug

### Quick Command:
```
Fix bug: [BUG_DESCRIPTION]
- Severity: [CRITICAL/HIGH/MEDIUM/LOW]
- Location: [FILE:LINE or "Unknown"]
- Steps to reproduce: [BRIEF_STEPS]
- Expected behavior: [WHAT_SHOULD_HAPPEN]
```

### Optimized Workflow:
```
1. If location known:
   - Read: [specific_file]
   - Edit: Apply fix
2. If location unknown:
   - Grep: [error_keyword] in relevant directory
   - Read: Top 2-3 results
   - Identify root cause
   - Edit: Apply fix
3. Bash: flutter test [affected_test] (regression check)
4. Bash: git add + commit with "fix:" prefix
```

### Example:
```
Fix bug: Notifications always in English
- Severity: CRITICAL
- Location: lib/services/notification_service.dart:145
- Steps to reproduce: Change language to ES, schedule notification
- Expected behavior: Notification in Spanish

WORKFLOW:
1. Read notification_service.dart:140-160
2. Identify: Missing AppLocalizations context
3. Edit: Pass context to notification method
4. Test: Manual validation (no automated test)
5. Commit: "fix(i18n): Localize notifications properly"

ESTIMATED TOKENS: ~5k (vs 15k exploring entire codebase)
```

---

## TEMPLATE 3: Add Translation

### Quick Command:
```
Add translation: [FEATURE_OR_SCREEN]
- Strings needed: [LIST_OF_KEYS]
- Context: [WHERE_USED]
```

### Optimized Workflow:
```
1. Read: docs/BILINGUAL_GUIDE.md:1-100 (protocol reminder)
2. Edit: lib/l10n/app_en.arb (add keys)
3. Edit: lib/l10n/app_es.arb (add translations)
4. Bash: flutter gen-l10n
5. Edit: [target_files] (replace hardcoded strings)
6. Bash: flutter test (verify no breaks)
7. Bash: git add + commit
```

### Example:
```
Add translation: Onboarding screen
- Strings needed: onboardingTitle1-3, onboardingDesc1-3, getStarted
- Context: lib/screens/onboarding_screen.dart

STEPS:
1. app_en.arb: Add 7 keys with English text
2. app_es.arb: Add 7 keys with Spanish text
3. flutter gen-l10n
4. onboarding_screen.dart: Replace Text('...') with AppLocalizations
5. Test: Verify both languages
6. Commit: "feat(i18n): Add onboarding translations"

ESTIMATED TOKENS: ~6k (vs 12k without focused approach)
```

---

## TEMPLATE 4: Refactor Code

### Quick Command:
```
Refactor: [COMPONENT_NAME]
- Reason: [WHY_REFACTOR]
- Pattern: [EXTRACT_METHOD/SOLID/DRY/etc]
- Impact: [FILES_AFFECTED]
- Breaking changes: [YES/NO]
```

### Optimized Workflow:
```
1. Read: [target_file] (understand current code)
2. If pattern unclear:
   - Read: docs/CLAUDE_GLOBAL_DEVELOPMENT_PRINCIPLES.md (SOLID section)
3. Edit: Apply refactor
4. Bash: flutter analyze (check warnings)
5. Bash: flutter test (ensure no breaks)
6. If breaking changes: Update callers
7. Bash: git add + commit with "refactor:" prefix
```

### Example:
```
Refactor: HabitProvider
- Reason: Method too long (150 lines), violates SRP
- Pattern: Extract Method + Dependency Injection
- Impact: 1 file (habit_provider.dart)
- Breaking changes: NO (internal refactor)

WORKFLOW:
1. Read habit_provider.dart:100-250
2. Identify: 3 responsibilities (CRUD, Stats, Gamification)
3. Extract: _calculateStats(), _updateGamification()
4. Test: flutter test test/providers/habit_provider_test.dart
5. Commit: "refactor(providers): Extract stats and gamification logic"

ESTIMATED TOKENS: ~7k (vs 18k without clear plan)
```

---

## TEMPLATE 5: Add Tests

### Quick Command:
```
Add tests: [COMPONENT]
- Type: [UNIT/WIDGET/INTEGRATION]
- Coverage target: [X%]
- Critical paths: [LIST]
```

### Optimized Workflow:
```
1. Read: docs/TESTING_STRATEGY.md:1-50 (quick reference)
2. Read: [component_file] (understand code to test)
3. Write: test/[component]_test.dart
4. Bash: flutter test test/[component]_test.dart
5. Bash: flutter test --coverage (check coverage)
6. Bash: git add + commit
```

### Example:
```
Add tests: PremiumProvider
- Type: UNIT
- Coverage target: 80%+
- Critical paths: canAddMoreHabits, grantPremium, isPremium getter

WORKFLOW:
1. Read test/providers/gamification_provider_test.dart (similar example)
2. Read lib/providers/premium_provider.dart
3. Write 8 test cases covering all methods
4. Run tests: flutter test test/providers/premium_provider_test.dart
5. Verify 85% coverage
6. Commit: "test(providers): Add premium_provider tests (85% coverage)"

ESTIMATED TOKENS: ~9k (vs 22k exploring testing frameworks)
```

---

## TEMPLATE 6: Update Dependencies

### Quick Command:
```
Update dependency: [PACKAGE_NAME]
- Current version: [X.Y.Z]
- Target version: [A.B.C]
- Breaking changes: [YES/NO/UNKNOWN]
- Impact: [HIGH/MEDIUM/LOW]
```

### Optimized Workflow:
```
1. If breaking changes unknown:
   - Web search: "[package] changelog [version]"
2. Edit: pubspec.yaml (update version)
3. Bash: flutter pub get
4. Bash: flutter analyze (check for errors)
5. Bash: flutter test (regression check)
6. If breaking: Fix code
7. Bash: git add + commit
```

### Example:
```
Update dependency: google_fonts
- Current version: 6.1.0
- Target version: 6.3.2
- Breaking changes: NO (minor update)
- Impact: LOW

WORKFLOW:
1. pubspec.yaml: google_fonts: ^6.3.2
2. flutter pub get
3. flutter analyze (verify no issues)
4. flutter test (all pass)
5. Commit: "chore(deps): Update google_fonts to 6.3.2"

ESTIMATED TOKENS: ~4k (vs 10k for major updates)
```

---

## TEMPLATE 7: Create PR

### Quick Command:
```
Create PR: [TITLE]
- Branch: [BRANCH_NAME]
- Changes: [SUMMARY]
- Tests: [PASSING/FAILING]
- Screenshots: [YES/NO]
```

### Optimized Workflow:
```
1. Bash: git status (verify clean)
2. Bash: flutter test (ensure all pass)
3. Bash: git add [files]
4. Bash: git commit -m "[message]" (use convention)
5. Bash: git push -u origin [branch]
6. Bash: gh pr create --title "[title]" --body "[body]"
7. If screenshots: Add to PR description
```

### Example:
```
Create PR: Add dark mode toggle
- Branch: claude/dark-mode-toggle
- Changes: Settings screen + ThemeProvider integration
- Tests: 467/467 passing
- Screenshots: NO (minor UI change)

WORKFLOW:
1. git status (2 files modified)
2. flutter test (all pass)
3. git add lib/screens/settings_screen.dart lib/providers/theme_provider.dart
4. git commit -m "feat(ui): Add dark mode toggle in settings"
5. git push -u origin claude/dark-mode-toggle
6. gh pr create --title "Add dark mode toggle" --body "..."
7. Wait for CI

ESTIMATED TOKENS: ~3k (vs 8k without automation)
```

---

## TEMPLATE 8: Review Code

### Quick Command:
```
Review: [PR_NUMBER or FILE]
- Focus: [LOGIC/STYLE/SECURITY/PERFORMANCE]
- Checklist: [YES/NO] (use standard checklist)
```

### Optimized Workflow:
```
1. If PR:
   - Bash: gh pr view [number] --comments
   - Bash: gh pr diff [number]
2. If file:
   - Read: [file_path]
3. Check:
   - Logic correctness
   - Code style (follows conventions)
   - Security (no hardcoded secrets)
   - Performance (no obvious bottlenecks)
4. Comment or approve
```

### Example:
```
Review: PR #28
- Focus: LOGIC + i18n compliance
- Checklist: YES

WORKFLOW:
1. gh pr view 28 --comments
2. gh pr diff 28 (see changes)
3. Read changed files
4. Check:
   - [x] No hardcoded strings
   - [x] Tests included
   - [x] Follows SOLID principles
   - [x] No security issues
5. gh pr review 28 --approve --body "LGTM! Nice work on i18n."

ESTIMATED TOKENS: ~6k (vs 15k ad-hoc review)
```

---

## 📊 EFFICIENCY GAINS

### Average Token Savings:

| Task Type | Without Template | With Template | Savings |
|-----------|------------------|---------------|---------|
| Add Feature | 20k | 8k | **60%** |
| Fix Bug | 15k | 5k | **67%** |
| Add Translation | 12k | 6k | **50%** |
| Refactor | 18k | 7k | **61%** |
| Add Tests | 22k | 9k | **59%** |
| Update Deps | 10k | 4k | **60%** |
| Create PR | 8k | 3k | **63%** |
| Review Code | 15k | 6k | **60%** |
| **AVERAGE** | **15k** | **6k** | **60%** |

### Time Savings:
- **Average**: 40-50% faster execution
- **Reason**: Less exploration, direct file access, clear steps

---

## 💡 TIPS FOR MAXIMUM EFFICIENCY

### 1. **Always Use PROJECT_INDEX.md First**
```
BEFORE: Grep entire codebase for "premium"
AFTER: Check PROJECT_INDEX.md → Direct read of premium_provider.dart
SAVINGS: 10k tokens
```

### 2. **Batch Related Operations**
```
BEFORE: 3 separate commits for i18n (EN, ES, gen-l10n)
AFTER: 1 workflow with all 3 steps
SAVINGS: 5k tokens (avoid re-loading context)
```

### 3. **Use Specific Line Ranges**
```
BEFORE: Read entire 500-line file
AFTER: Read file:100-150 (exact function)
SAVINGS: 8k tokens
```

### 4. **Cache Frequently Used Info**
```
KEEP IN MIND:
- Design constants location: lib/core/design_constants.dart
- i18n protocol: docs/BILINGUAL_GUIDE.md
- Test patterns: test/providers/gamification_provider_test.dart (reference)
SAVINGS: 3-5k tokens per session
```

### 5. **Combine Independent Operations**
```
EXAMPLE:
- Read 3 related files in parallel (single message)
- Run tests + analyze in sequence (&&)
SAVINGS: 2-4k tokens (avoid tool call overhead)
```

---

## 🎯 WHEN TO USE TEMPLATES

### ✅ ALWAYS Use:
- Routine tasks (add feature, fix bug, add translation)
- Tasks with clear scope
- Tasks requiring multiple steps
- Tasks done more than once

### ⚠️ MAYBE Use:
- Complex research tasks (may need exploration)
- First-time implementations (need learning)
- Emergency fixes (speed over efficiency)

### ❌ DON'T Use:
- Quick one-line changes
- Already optimal workflows
- When template is outdated

---

## 🔄 MAINTAINING TEMPLATES

### Update When:
- New patterns identified (add to WORKFLOW_TEMPLATES.md)
- Project structure changes (update file paths)
- Better approaches discovered (revise steps)

### Review Frequency:
- After every 10 sessions
- When efficiency drops
- When new tools added

---

**Created by**: Claude (Sesión 57)
**Part of**: Plan Maestro Phase 4 - Optimize
**Expected Impact**: 60% token reduction on routine tasks
**Status**: ✅ READY FOR USE
