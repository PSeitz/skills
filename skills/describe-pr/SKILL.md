---
description: Generate a comprehensive PR description and use it when opening a pull request
disable-model-invocation: true
---

# Open PR With Description

Use this skill when the user wants to open a pull request with a clear, comprehensive description based on the current branch's changes.

## Steps to follow:

1. **Understand the branch and target:**
   - Check the current branch: `git branch --show-current`
   - Refuse to open a PR directly from `main` or `master` unless the user explicitly confirms
   - Determine the likely base branch with `git remote show origin` or repository defaults
   - If the base branch is unclear, ask the user which branch to target

2. **Check whether a PR already exists:**
   - Run: `gh pr view --json url,number,title,state 2>/dev/null`
   - If a PR already exists for the branch, tell the user and ask whether to update it instead of creating a new one

3. **Gather change information before opening the PR:**
   - Fetch the base branch if needed: `git fetch origin {base}`
   - Review the diff: `git diff origin/{base}...HEAD`
   - Review changed files: `git diff --name-status origin/{base}...HEAD`
   - Review commits: `git log --oneline origin/{base}..HEAD`
   - For context, read relevant files touched by the diff when needed

4. **Analyze the changes thoroughly:**
   - Understand the purpose and impact of each change
   - Identify user-facing changes versus internal implementation details
   - Look for breaking changes, migration requirements, or operational risks
   - Note any follow-up work or manual testing needs

5. **Run practical verification:**
   - Infer relevant checks from the repository and changes, such as tests, type checks, linters, builds, or targeted commands
   - Run verification commands when practical and safe
   - Document commands that passed, failed, or were skipped
   - Note any manual testing the user should complete

6. **Generate the PR title and body:**
   - Create a concise PR title if one was not provided by the user
   - Write a scannable PR body with sections such as:
     - Summary
     - Changes
     - User impact
     - Breaking changes or migration notes, if any
     - Verification
   - Focus on the "why" as much as the "what"
   - Keep technical details reviewer-focused and avoid filler

7. **Open the pull request:**
   - Save the generated body to a temporary file, for example `/tmp/{repo_name}_pr_body.md`
   - Show the title and body to the user before creating the PR unless they explicitly asked to create it without confirmation
   - Create the PR with:
     - `gh pr create --base {base} --title "{title}" --body-file /tmp/{repo_name}_pr_body.md`
   - If GitHub reports that no default remote repository is set, instruct the user to run `gh repo set-default`

8. **After opening the PR:**
   - Confirm the PR URL
   - Mention any verification failures, skipped checks, or manual testing that remains
   - If requested, update the PR body with `gh pr edit {number} --body-file /tmp/{repo_name}_pr_body.md`

## Important notes:
- Be thorough but concise; PR descriptions should be easy to scan.
- Include breaking changes or migration notes prominently.
- If the PR touches multiple components, organize the description accordingly.
- Always attempt relevant verification commands when possible.
- Clearly communicate which verification steps need manual testing.
