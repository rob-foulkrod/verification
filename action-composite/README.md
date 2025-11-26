# Composite Action - Educational Guide

## 🎓 What is a Composite Action?

A composite action is the simplest type of GitHub Action. It allows you to bundle multiple workflow steps into a single reusable action without writing any code - just YAML!

## 🏗️ Structure

A composite action consists of a single file: `action.yml`

This file defines:
- **Metadata**: Name, description, author, branding
- **Inputs**: Parameters the action accepts
- **Outputs**: Values the action produces
- **Steps**: Shell commands to execute

## 🔍 Key Concepts

### 1. **No Code Required**
Unlike JavaScript or Docker actions, composite actions are pure YAML. Perfect for:
- Bundling shell scripts
- Reusing common setup steps
- Simple automation tasks

### 2. **Direct Runner Execution**
Composite actions run directly on the workflow runner (not in a container), which means:
- ✅ Fast startup (no container overhead)
- ✅ Access to runner environment
- ✅ Can use installed tools (git, curl, etc.)
- ⚠️ Less isolation than Docker actions
- ⚠️ Depends on runner's environment

### 3. **Inputs and Outputs**

**Inputs** make your action flexible:
```yaml
inputs:
  my-input:
    description: 'What this input does'
    required: false
    default: 'default-value'
```

Access inputs in steps: `${{ inputs.my-input }}`

**Outputs** let you pass data to subsequent steps:
```yaml
outputs:
  my-output:
    description: 'What this output contains'
    value: ${{ steps.step-id.outputs.value }}
```

Set outputs in bash:
```bash
echo "value=my-value" >> $GITHUB_OUTPUT
```

### 4. **Step Execution**

Steps run sequentially:
- Each step needs a `shell` (bash, pwsh, python, etc.)
- Steps can reference previous step outputs
- Use `id:` to reference a step later
- Use `if:` to conditionally run steps

## 📚 When to Use Composite Actions

**Use Composite Actions When:**
- ✅ Bundling shell commands
- ✅ Reusing workflow patterns
- ✅ Quick setup tasks
- ✅ You don't need custom logic
- ✅ Cross-repository workflows

**Use JavaScript Actions When:**
- ✅ Complex logic needed
- ✅ API integrations
- ✅ Data processing
- ✅ Need Node.js packages

**Use Docker Actions When:**
- ✅ Specific tool versions
- ✅ Complex dependencies
- ✅ Language-specific requirements
- ✅ Maximum isolation

## 🔧 How This Example Works

This composite action demonstrates:

1. **Educational Output**: Explains what's happening as it runs
2. **Input Handling**: Accepts `who-to-greet` and `greeting-style`
3. **Logic Processing**: Generates different greetings based on style
4. **Output Generation**: Produces `greeting-message` and `timestamp`
5. **Step Chaining**: Shows how steps can use previous step outputs

## 🚀 Using This Action

In a workflow:

```yaml
- name: Run Composite Action
  uses: ./action-composite
  id: composite
  with:
    who-to-greet: 'Alice'
    greeting-style: 'excited'

- name: Use Action Output
  run: |
    echo "Greeting: ${{ steps.composite.outputs.greeting-message }}"
    echo "Time: ${{ steps.composite.outputs.timestamp }}"
```

## 💡 Best Practices

1. **Clear Descriptions**: Make inputs/outputs self-documenting
2. **Sensible Defaults**: Provide defaults for optional inputs
3. **Error Handling**: Check for required conditions
4. **Educational Output**: Echo what's happening (especially for learning repos!)
5. **Shell Specification**: Always specify `shell:` for clarity
6. **Output Documentation**: Describe what outputs contain and their format

## 🎯 Learning Exercises

Try modifying this action to:
1. Add a new input for the greeting language
2. Add error handling if inputs are invalid
3. Create an output that counts characters in the message
4. Add a step that writes the greeting to a file
5. Use environment variables instead of direct input access

## 📖 Further Reading

- [GitHub Docs: Creating a Composite Action](https://docs.github.com/en/actions/creating-actions/creating-a-composite-action)
- [Metadata Syntax](https://docs.github.com/en/actions/creating-actions/metadata-syntax-for-github-actions)
- [Workflow Commands](https://docs.github.com/en/actions/using-workflows/workflow-commands-for-github-actions)

---

**Remember**: Composite actions are powerful because of their simplicity. When you don't need complex logic, they're often the best choice!
