# Docker Container Action - Educational Guide

## 🎓 What is a Docker Container Action?

A Docker container action packages your action in a Docker container, giving you complete control over the execution environment. It's the most flexible action type for complex dependencies and non-JavaScript languages.

## 🏗️ Structure

A Docker container action consists of:
- **`action.yml`**: Metadata defining inputs, outputs, and Docker configuration
- **`Dockerfile`**: Container image definition
- **`entrypoint.sh`**: Script that runs when the container starts
- Any additional files needed by the action

## 🔍 Key Concepts

### 1. **Container Isolation**

Docker actions run in complete isolation:
- ✅ Own filesystem and process space
- ✅ Specific tool versions guaranteed
- ✅ No interference from runner environment
- ✅ Consistent across all runners
- ⚠️ Slower startup (container build/pull)
- ⚠️ Linux-only (containers run on Linux)

### 2. **Dockerfile Basics**

The Dockerfile defines your container image:

```dockerfile
# Base image - start with something minimal
FROM alpine:3.18

# Install dependencies
RUN apk add --no-cache bash curl

# Copy your script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set working directory
WORKDIR /github/workspace

# Define what runs
ENTRYPOINT ["/entrypoint.sh"]
```

**Key Directives:**
- `FROM`: Base image to start from
- `RUN`: Execute commands during build
- `COPY`: Copy files into the image
- `WORKDIR`: Set working directory
- `ENTRYPOINT`: Command to run when container starts
- `CMD`: Default arguments to ENTRYPOINT

### 3. **Alpine Linux Best Practices**

Alpine is the recommended base for actions:

**Why Alpine?**
- Minimal size (~5MB vs ~70MB for Ubuntu)
- Security-focused
- Fast downloads and startup
- apk package manager

**Installation Pattern:**
```dockerfile
RUN apk add --no-cache \
    package1 \
    package2 \
    && echo "Cleanup commands if needed"
```

**Version Pinning:**
```dockerfile
# Loose pinning (recommended)
RUN apk add --no-cache bash=~5.2

# Exact version (strict)
RUN apk add --no-cache bash=5.2.15-r5
```

### 4. **Entrypoint Script**

The entrypoint script receives arguments and processes them:

```bash
#!/bin/bash
set -e  # Exit on error

# Arguments from action.yml
INPUT1="${1:-}"
INPUT2="${2:-default}"

# Do work
echo "Processing: $INPUT1"

# Set outputs
if [ -n "${GITHUB_OUTPUT:-}" ]; then
  echo "result=value" >> "$GITHUB_OUTPUT"
fi

exit 0
```

**Important:**
- Make it executable: `chmod +x entrypoint.sh`
- Use `set -e` for error handling
- Check `GITHUB_OUTPUT` exists before writing

### 5. **GitHub Actions Integration**

**Environment Variables Available:**
- `GITHUB_WORKSPACE`: Workspace directory
- `GITHUB_REPOSITORY`: owner/repo
- `GITHUB_ACTOR`: User who triggered
- `GITHUB_SHA`: Commit SHA
- `GITHUB_REF`: Git ref
- `GITHUB_EVENT_NAME`: Event type
- `GITHUB_WORKFLOW`: Workflow name
- `GITHUB_OUTPUT`: File for outputs
- `GITHUB_ENV`: File for variables
- `INPUT_*`: Input values (uppercase)

**Working Directory:**
- Container starts in `/github/workspace`
- This is mapped to `$GITHUB_WORKSPACE` on the runner
- Your repository is checked out here

### 6. **Passing Arguments**

In `action.yml`:
```yaml
runs:
  using: 'docker'
  image: 'Dockerfile'
  args:
    - ${{ inputs.input1 }}
    - ${{ inputs.input2 }}
```

In entrypoint script:
```bash
INPUT1="${1:-}"  # First argument
INPUT2="${2:-}"  # Second argument
```

## 📚 When to Use Docker Actions

**Use Docker Actions When:**
- ✅ Need specific tool versions (Python 3.8, Node 14, etc.)
- ✅ Complex system dependencies
- ✅ Language other than JavaScript
- ✅ Need maximum isolation
- ✅ Want consistent environment

**Use JavaScript Actions When:**
- ✅ Need fast startup
- ✅ Simple logic in Node.js
- ✅ Cross-platform required

**Use Composite Actions When:**
- ✅ Just bundling shell commands
- ✅ No complex dependencies

## 🔧 How This Example Works

This Docker action demonstrates:

1. **Alpine Base**: Minimal Linux distribution
2. **Best Practices**: Labels, caching, layer optimization
3. **Tool Installation**: bash, curl, jq, ca-certificates
4. **Argument Handling**: Three inputs with defaults
5. **Processing Logic**: Five operation types
6. **Output Generation**: result, timestamp, container-info
7. **Educational Output**: Explains what's happening

**Operations:**
- `echo`: Return message as-is
- `reverse`: Reverse the string
- `count`: Count characters and words
- `uppercase`: Convert to uppercase
- `lowercase`: Convert to lowercase

## 🚀 Using This Action

In a workflow:

```yaml
- name: Run Docker Action
  uses: ./action-docker
  id: docker
  with:
    message: 'Hello from Docker!'
    process-type: 'reverse'
    color-output: 'true'

- name: Display Result
  run: |
    echo "Result: ${{ steps.docker.outputs.result }}"
    echo "Time: ${{ steps.docker.outputs.timestamp }}"
    echo "Info: ${{ steps.docker.outputs.container-info }}"
```

## 💡 Best Practices

### Dockerfile
1. **Use Alpine**: Minimal, secure, fast
2. **Pin Versions**: Use `~` for loose pinning
3. **Minimize Layers**: Combine RUN commands
4. **Clean Cache**: Use `--no-cache` with apk
5. **Labels**: Add metadata with LABEL
6. **Non-root User**: Consider running as non-root (optional)

### Entrypoint Script
1. **Error Handling**: Use `set -e`, `set -u`, `set -o pipefail`
2. **Validate Inputs**: Check required arguments
3. **Clear Output**: Educational messages for debugging
4. **Proper Exits**: Exit 0 on success, non-zero on failure
5. **Check GITHUB_OUTPUT**: May not exist when testing locally

### Testing
1. **Test Locally**: `docker build -t test . && docker run test "arg1" "arg2"`
2. **Test in Actions**: Create a test workflow
3. **Check Size**: `docker images` - keep it small!

## 🧪 Testing Locally

Build and run the container:

```bash
# Build the image
cd action-docker
docker build -t demo-docker-action .

# Run the container
docker run demo-docker-action "Test message" "reverse" "true"

# Run with environment variables
docker run -e GITHUB_WORKSPACE=/workspace \
  -e GITHUB_REPOSITORY=owner/repo \
  demo-docker-action "Test" "count" "true"
```

## 🎯 Learning Exercises

Try modifying this action to:
1. Add Python and create a Python-based processor
2. Use a different base image (ubuntu, debian, etc.)
3. Add more processing types (ROT13, base64, etc.)
4. Install a specific tool version (e.g., Go 1.21)
5. Create a multi-stage build to reduce image size
6. Run as a non-root user for better security

## 📦 Advanced Topics

### Multi-Stage Builds

Reduce image size by using multi-stage builds:

```dockerfile
# Build stage
FROM golang:1.21-alpine AS builder
WORKDIR /app
COPY . .
RUN go build -o /app/myapp

# Runtime stage
FROM alpine:3.18
COPY --from=builder /app/myapp /myapp
ENTRYPOINT ["/myapp"]
```

### Pre-built Images

Instead of building from Dockerfile, use pre-built:

```yaml
runs:
  using: 'docker'
  image: 'docker://alpine:3.18'
  entrypoint: '/bin/sh'
  args:
    - '-c'
    - 'echo "Using pre-built image!"'
```

### Environment Variables

Set environment variables in action.yml:

```yaml
runs:
  using: 'docker'
  image: 'Dockerfile'
  env:
    CUSTOM_VAR: 'value'
    API_URL: 'https://api.example.com'
```

## 📖 Further Reading

- [GitHub Docs: Creating a Docker Container Action](https://docs.github.com/en/actions/creating-actions/creating-a-docker-container-action)
- [Dockerfile Reference](https://docs.docker.com/engine/reference/builder/)
- [Alpine Linux Packages](https://pkgs.alpinelinux.org/packages)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)

---

**Remember**: Docker actions give you complete control at the cost of startup time. Use them when you need that control!
