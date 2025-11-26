# JavaScript Action - Educational Guide

## 🎓 What is a JavaScript Action?

A JavaScript action is a Node.js application that runs directly on the workflow runner. It's the most flexible type of action, allowing you to leverage the entire npm ecosystem while maintaining fast execution.

## 🏗️ Structure

A JavaScript action consists of:
- **`action.yml`**: Metadata file defining inputs, outputs, and execution
- **`index.js`**: Main JavaScript file (entry point)
- **`package.json`**: Node.js project file with dependencies
- **`node_modules/`**: npm packages (not committed to git)

## 🔍 Key Concepts

### 1. **Direct Runner Execution**

JavaScript actions run on the workflow runner's Node.js runtime:
- ✅ No container overhead (fast startup)
- ✅ Access to runner filesystem and environment
- ✅ Full npm ecosystem available
- ⚠️ Requires Node.js on the runner (usually pre-installed)
- ⚠️ Version specified in `action.yml` must be available

### 2. **@actions/core Package**

The `@actions/core` package is GitHub's official toolkit for actions:

```javascript
const core = require('@actions/core');

// Reading inputs
const input = core.getInput('input-name', { required: true });

// Setting outputs
core.setOutput('output-name', 'value');

// Logging
core.info('Info message');
core.warning('Warning message');
core.error('Error message');
core.debug('Debug message'); // Only if ACTIONS_STEP_DEBUG=true

// Failing the action
core.setFailed('Error message');

// Annotations
core.notice('Notice annotation');

// Grouping logs
core.startGroup('Group name');
// ... log statements
core.endGroup();

// Exporting variables
core.exportVariable('VAR_NAME', 'value');

// Setting secrets (masks values in logs)
core.setSecret('sensitive-value');
```

### 3. **@actions/github Package**

The `@actions/github` package provides GitHub context and API access:

```javascript
const github = require('@actions/github');

// Access context information
const { context } = github;
console.log(context.repo.owner);      // Repository owner
console.log(context.repo.repo);       // Repository name
console.log(context.sha);             // Commit SHA
console.log(context.ref);             // Git ref
console.log(context.actor);           // User who triggered
console.log(context.eventName);       // Event type
console.log(context.payload);         // Event payload

// Create authenticated API client (requires token)
const token = core.getInput('github-token');
const octokit = github.getOctokit(token);

// Make API calls
const { data: issue } = await octokit.rest.issues.get({
  owner: context.repo.owner,
  repo: context.repo.repo,
  issue_number: 123
});
```

### 4. **Error Handling**

Always wrap your code in try/catch and use `core.setFailed()`:

```javascript
async function run() {
  try {
    // Your action logic here
  } catch (error) {
    core.setFailed(`Action failed: ${error.message}`);
  }
}

run();
```

### 5. **Dependencies**

Install dependencies before committing:

```bash
npm install @actions/core @actions/github
```

**Important**: Commit `node_modules/` or distribute the action differently:
- **Option 1**: Commit `node_modules/` (simple but large)
- **Option 2**: Use `@vercel/ncc` to bundle code
- **Option 3**: Use GitHub's distribution workflow

For this demo, we'll commit `node_modules/`.

## 📚 When to Use JavaScript Actions

**Use JavaScript Actions When:**
- ✅ Need complex logic or algorithms
- ✅ Want to use npm packages
- ✅ Need to process data or files
- ✅ Need to call APIs (GitHub or external)
- ✅ Want fast execution (no container)
- ✅ Need cross-platform support

**Use Composite Actions When:**
- ✅ Just bundling shell commands
- ✅ Don't need custom logic

**Use Docker Actions When:**
- ✅ Need specific tool versions
- ✅ Complex system dependencies
- ✅ Language other than JavaScript

## 🔧 How This Example Works

This JavaScript action demonstrates:

1. **Input Handling**: Reads `input-text` and `operation-type`
2. **GitHub Context**: Displays repository, event, and workflow info
3. **Custom Logic**: Implements three operations:
   - **analyze**: Count characters, words, lines
   - **transform**: Uppercase, lowercase, reverse text
   - **validate**: Check text against rules
4. **Output Generation**: Produces JSON results and metadata
5. **Logging Levels**: Shows info, debug, notice, warning

## 🚀 Using This Action

In a workflow:

```yaml
- name: Run JavaScript Action
  uses: ./action-javascript
  id: js-action
  with:
    input-text: 'Hello GitHub Actions!'
    operation-type: 'analyze'

- name: Display Results
  run: |
    echo "Result: ${{ steps.js-action.outputs.processed-text }}"
    echo "Time: ${{ steps.js-action.outputs.timestamp }}"
```

## 💡 Best Practices

1. **Always Use Try/Catch**: Handle errors gracefully
2. **Validate Inputs**: Check inputs before processing
3. **Use Appropriate Log Levels**: info for progress, debug for details
4. **Set Meaningful Outputs**: Help users understand results
5. **Document Your Code**: Explain why, not just what
6. **Test Locally**: Use `node index.js` with environment variables
7. **Keep Dependencies Minimal**: Only include what you need
8. **Use TypeScript (Optional)**: For better type safety

## 🧪 Testing Locally

Set environment variables to simulate GitHub Actions:

```bash
export INPUT_INPUT-TEXT="test text"
export INPUT_OPERATION-TYPE="analyze"
node index.js
```

Note: Input names are converted to environment variables:
- `input-text` → `INPUT_INPUT-TEXT`
- Format: `INPUT_<NAME_IN_UPPERCASE>`

## 🎯 Learning Exercises

Try modifying this action to:
1. Add a new operation type (e.g., 'encrypt')
2. Use the GitHub API to fetch repository info
3. Write results to a file
4. Add input validation with helpful error messages
5. Group related log statements with `core.startGroup()`
6. Add a `pre` or `post` script in action.yml

## 📦 Distributing Your Action

For production actions, consider:

1. **Using ncc to bundle**:
```bash
npm install -g @vercel/ncc
ncc build index.js -o dist
# Update action.yml: main: 'dist/index.js'
```

2. **Versioning with tags**:
```bash
git tag -a v1 -m "Version 1"
git push origin v1
```

3. **Publishing to GitHub Marketplace**:
   - Make repository public
   - Add proper README and LICENSE
   - Create a release

## 📖 Further Reading

- [GitHub Docs: Creating a JavaScript Action](https://docs.github.com/en/actions/creating-actions/creating-a-javascript-action)
- [@actions/core API](https://github.com/actions/toolkit/tree/main/packages/core)
- [@actions/github API](https://github.com/actions/toolkit/tree/main/packages/github)
- [Octokit REST API](https://octokit.github.io/rest.js/)

---

**Remember**: JavaScript actions give you the full power of Node.js and npm while running fast and directly on the runner!
