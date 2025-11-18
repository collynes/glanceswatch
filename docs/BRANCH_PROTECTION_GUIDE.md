# GitHub Branch Protection Setup Guide

This guide explains how to set up branch protection for the GlanceWatch repository to maintain code quality and require reviews before merging.

## 📋 Branch Strategy

- **`main`** - Production-ready code, tagged releases only (protected)
- **`develop`** - Integration branch for features (protected, default for PRs)
- **`feature/*`** - Feature branches (created from `develop`)
- **`bugfix/*`** - Bug fix branches (created from `develop`)
- **`hotfix/*`** - Emergency fixes (created from `main`)

---

## 🛡️ Setting Up Branch Protection

### Step 1: Create the `develop` Branch

```bash
# In your local repository
cd /path/to/glanceswatch

# Create develop branch from main
git checkout main
git pull origin main
git checkout -b develop
git push -u origin develop
```

### Step 2: Set `develop` as Default Branch

1. Go to your repository on GitHub: https://github.com/collynes/glanceswatch
2. Click **Settings** (requires admin access)
3. Click **Branches** in the left sidebar
4. Under "Default branch", click the switch icon
5. Select **`develop`** from the dropdown
6. Click **Update**
7. Confirm the change

**Result**: All new PRs will now target `develop` by default

### Step 3: Protect the `main` Branch

1. Go to **Settings** → **Branches**
2. Click **Add branch protection rule**
3. Branch name pattern: `main`
4. Enable the following settings:

#### Required Settings:
- ✅ **Require a pull request before merging**
  - ✅ Require approvals: **1** (or more for stricter control)
  - ✅ Dismiss stale pull request approvals when new commits are pushed
  - ✅ Require review from Code Owners (optional)

- ✅ **Require status checks to pass before merging**
  - ✅ Require branches to be up to date before merging
  - Add status checks (if you have CI/CD):
    - `tests` (pytest)
    - `lint` (ruff/black)
    - `build` (package build)

- ✅ **Require conversation resolution before merging**
  - All comments must be resolved before merging

- ✅ **Require linear history**
  - Enforces a linear commit history (no merge commits)

- ✅ **Do not allow bypassing the above settings**
  - Even admins must follow these rules

#### Optional Settings:
- ⚠️ **Restrict who can push to matching branches**
  - Add yourself as an allowed user
  - This prevents direct pushes (only PRs allowed)

- ⚠️ **Allow force pushes**: ❌ (disabled)
- ⚠️ **Allow deletions**: ❌ (disabled)

5. Click **Create** to save the rule

### Step 4: Protect the `develop` Branch

Repeat Step 3 for the `develop` branch with slightly relaxed settings:

1. Branch name pattern: `develop`
2. Enable settings:
   - ✅ **Require a pull request before merging**
     - Require approvals: **1**
   - ✅ **Require status checks to pass before merging**
   - ✅ **Require conversation resolution before merging**
   - ⚠️ Allow force pushes: ❌ (disabled)
   - ⚠️ Allow deletions: ❌ (disabled)

3. Click **Create**

---

## 🔄 Workflow After Protection

### For Contributors

```bash
# 1. Fork the repository on GitHub

# 2. Clone your fork
git clone https://github.com/YOUR_USERNAME/glanceswatch.git
cd glanceswatch

# 3. Add upstream remote
git remote add upstream https://github.com/collynes/glanceswatch.git

# 4. Create feature branch from develop
git checkout develop
git pull upstream develop
git checkout -b feature/my-feature

# 5. Make changes and commit
git add .
git commit -m "feat: add my feature"

# 6. Push to your fork
git push origin feature/my-feature

# 7. Create Pull Request on GitHub
#    - Target: collynes/glanceswatch:develop
#    - Source: YOUR_USERNAME/glanceswatch:feature/my-feature
```

### For Maintainers (You)

```bash
# 1. Review PRs targeting `develop`
# 2. Request changes if needed
# 3. Approve and merge to `develop` via GitHub UI

# 4. When ready to release:
git checkout develop
git pull origin develop

# Create release branch
git checkout -b release/v1.2.3

# Update version numbers in:
# - app/__init__.py
# - pyproject.toml
# - npm-package/package.json

# Commit version bump
git add .
git commit -m "chore: bump version to 1.2.3"

# Merge to main via PR
git push origin release/v1.2.3

# Create PR: release/v1.2.3 → main
# After approval and merge:

# Tag the release
git checkout main
git pull origin main
git tag -a v1.2.3 -m "Release version 1.2.3"
git push origin v1.2.3

# Merge back to develop
git checkout develop
git merge main
git push origin develop

# Deploy
bash scripts/deploy.sh
```

---

## 🚨 Emergency Hotfixes

For critical bugs in production (`main`):

```bash
# 1. Create hotfix branch from main
git checkout main
git pull origin main
git checkout -b hotfix/critical-bug

# 2. Fix the bug
git add .
git commit -m "fix: critical bug in production"

# 3. Push and create PR to main
git push origin hotfix/critical-bug

# 4. After merge to main:
# - Tag the hotfix release
# - Merge main back to develop
# - Deploy immediately
```

---

## ✅ Verification

After setting up branch protection:

1. Try to push directly to `main`:
   ```bash
   git checkout main
   git commit --allow-empty -m "test"
   git push origin main
   ```
   **Expected**: ❌ Push rejected (if "Restrict pushes" is enabled)

2. Try to merge without review:
   - Create a test PR targeting `main`
   - Try to merge without approval
   **Expected**: ❌ Merge blocked

3. Create a proper PR workflow:
   - Create feature branch from `develop`
   - Push and create PR to `develop`
   - Request review
   - After approval, merge should work ✅

---

## 📊 GitHub Actions (Optional)

To enforce status checks, add CI/CD workflow:

Create `.github/workflows/ci.yml`:

```yaml
name: CI

on:
  pull_request:
    branches: [main, develop]
  push:
    branches: [main, develop]

jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        python-version: ['3.8', '3.9', '3.10', '3.11', '3.12']
    
    steps:
    - uses: actions/checkout@v4
    - name: Set up Python
      uses: actions/setup-python@v4
      with:
        python-version: ${{ matrix.python-version }}
    
    - name: Install dependencies
      run: |
        pip install -e ".[dev]"
    
    - name: Lint with Ruff
      run: ruff check app/ tests/
    
    - name: Format check with Black
      run: black --check app/ tests/
    
    - name: Run tests
      run: pytest --cov=app --cov-report=xml
    
    - name: Upload coverage
      uses: codecov/codecov-action@v3
      with:
        file: ./coverage.xml
```

---

## 📚 Additional Resources

- [GitHub Branch Protection Rules](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches)
- [Git Flow Workflow](https://nvie.com/posts/a-successful-git-branching-model/)
- [Conventional Commits](https://www.conventionalcommits.org/)

---

## 🎯 Quick Checklist

- [ ] Create `develop` branch
- [ ] Set `develop` as default branch
- [ ] Protect `main` branch (require PR + review)
- [ ] Protect `develop` branch (require PR + review)
- [ ] Update CONTRIBUTING.md with workflow
- [ ] Add PR template
- [ ] Add issue templates
- [ ] (Optional) Set up GitHub Actions for CI/CD
- [ ] Test the workflow with a sample PR

---

**Ready to protect your branches and enforce quality! 🛡️**
