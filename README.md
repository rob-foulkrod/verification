# GitHub Actions Learning Repository

Welcome to this educational repository! This project demonstrates the three types of GitHub Actions and how to orchestrate them together.

## 🎯 What You'll Learn

This repository is a hands-on tutorial for understanding GitHub Actions at a deep level. You'll explore:

1. **Composite Actions** - Reusable workflows composed of multiple steps
2. **JavaScript Actions** - Custom actions written in Node.js
3. **Docker Container Actions** - Actions packaged as Docker containers
4. **Action Orchestration** - How to compose actions together
5. **Workflow Dispatch** - Manual workflow triggering

## 📚 Repository Structure

```
.
├── action-composite/          # Simple composite action demo
│   ├── action.yml            # Action metadata
│   └── README.md             # Educational documentation
│
├── action-javascript/         # JavaScript action with @actions/core
│   ├── index.js              # Main action logic
│   ├── package.json          # Node.js dependencies
│   ├── node_modules/         # npm dependencies (committed)
│   ├── action.yml            # Action metadata
│   └── README.md             # Educational documentation
│
├── action-docker/             # Docker container action
│   ├── Dockerfile            # Container definition
│   ├── entrypoint.sh         # Container entrypoint script
│   ├── action.yml            # Action metadata
│   └── README.md             # Educational documentation
│
└── .github/
    └── workflows/
        └── demo.yml          # Demo workflow that orchestrates all actions
```

## 🚀 Getting Started

### Running the Demo

1. Navigate to the **Actions** tab in this repository
2. Select the **"Demo Workflow"** from the left sidebar
3. Click **"Run workflow"** button
4. Select the branch and click **"Run workflow"**
5. Watch as all three action types execute in sequence!

### What Happens When You Run It?

The workflow will orchestrate all three action types in sequence:
1. Execute the **Composite Action** (runs shell commands)
2. Execute the **JavaScript Action** (runs Node.js code with @actions/core)
3. Execute the **Docker Container Action** (runs in an Alpine Linux container)
4. Display a **combined summary** of all results

Each action will output detailed educational messages explaining what it's doing and why.

## 🔍 Deep Dive: Action Types

### Composite Actions

**Location:** `action-composite/`

Composite actions allow you to combine multiple workflow steps into a single reusable action. They're perfect for:
- Grouping common setup steps
- Avoiding duplication across workflows
- Creating reusable workflows without writing code

**Key Concept:** They run directly on the workflow runner using shell commands.

### JavaScript Actions

**Location:** `action-javascript/`

JavaScript actions run directly on the runner and can use the @actions/core and @actions/github libraries. They're ideal for:
- Complex logic and data processing
- Direct API interactions
- Fast execution (no container overhead)
- Cross-platform compatibility

**Key Concept:** They execute as Node.js scripts with access to GitHub context and APIs.

### Docker Container Actions

**Location:** `action-docker/`

Docker container actions package your action in a Docker container. They're best for:
- Specific tool versions or dependencies
- Consistent execution environments
- Using languages other than JavaScript
- Complex system requirements

**Key Concept:** They run in an isolated container with complete control over the environment.

### Orchestrator Actions

**Location:** `.github/workflows/demo.yml`

This workflow demonstrates how to orchestrate multiple actions together. It shows:
- Using local actions with relative paths (`./action-name`)
- Passing inputs from workflow_dispatch to actions
- Capturing and using action outputs
- Chaining actions together in a workflow
- Job dependencies with `needs:`

**Key Concept:** Workflows can orchestrate multiple actions, enabling powerful automation pipelines.

## 💡 Why This Matters

Understanding these three action types and how to compose them is crucial for:
- **CI/CD Automation** - Building robust deployment pipelines
- **Code Quality** - Automating testing, linting, and security scans
- **DevOps Excellence** - Creating reusable, maintainable automation
- **Team Efficiency** - Sharing workflows across projects and teams

## 🎓 Learning Path

We recommend exploring in this order:

1. Read `action-composite/README.md` - Understand the simplest action type
2. Read `action-javascript/README.md` - Learn how to add custom logic
3. Read `action-docker/README.md` - Master containerized actions
4. Study `.github/workflows/demo.yml` - Understand workflow orchestration
5. Run the workflow with different inputs and observe the results

## 📖 Additional Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Creating a Composite Action](https://docs.github.com/en/actions/creating-actions/creating-a-composite-action)
- [Creating a JavaScript Action](https://docs.github.com/en/actions/creating-actions/creating-a-javascript-action)
- [Creating a Docker Container Action](https://docs.github.com/en/actions/creating-actions/creating-a-docker-container-action)

## 🤝 Contributing

This is an educational repository. Feel free to:
- Fork and experiment
- Suggest improvements via issues
- Share your learnings

## 📄 License

See LICENSE file for details.

---

**Happy Learning! 🎉**

*Remember: The best way to learn is by doing. Fork this repo, modify the actions, and see what happens!*