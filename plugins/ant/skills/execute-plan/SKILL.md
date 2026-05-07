---
user-invocable: true
name: execute-plan
description: Execute implementation plan using parallel subagents. Use when you have a plan URL/file to implement.
---

# Execute Plan

You are executing an implementation plan using the superpowers:executing-plans skill with systematic parallel subagents.

**Announce at start:** "I'm using the execute-plan skill to implement this plan."

## Platform Compatibility

In Claude Code, use the referenced `superpowers:*` skills when they are available. In Codex, or whenever those skills are unavailable, route execution through `ant:implementation-orchestrator`: load the plan, confirm execution mode, create or reuse `implementation-plan.md`, delegate to an implementation lead, use slice workers only when useful, and finish with review and verification.

When the instructions mention `AskUserQuestion`, use the native question UI if available; otherwise ask directly in chat. When they mention the `Read` or `Task` tool, use the host's equivalent file-reading or subagent/delegation capability.

## Step 1: Get Plan Location

Parse the user's command for a URL or file path argument. Examples:
- `/ant:execute-plan https://docs.google.com/document/d/xxx` → use that URL
- `/ant:execute-plan /path/to/plan.md` → use that file path
- `/ant:execute-plan` (no argument) → ask the user

If no argument was provided, simply ask: "Paste the plan URL or file path:"

Wait for the user's response with the URL/path.

## Step 2: Get Execution Mode

Ask the user:
- Question: "How do you want to execute the plan steps?"
- Header: "Exec mode"
- Options:
  - "All at once (Recommended)" - Execute all steps using parallel subagents where possible
  - "In batches of 3" - Execute 3 steps at a time, report progress, wait for feedback
  - "Custom batch size" - User specifies how many steps per batch
  - "One by one" - Execute each step individually with confirmation between steps

If user selects "Custom batch size", ask follow-up:
- Question: "How many steps per batch?"
- Header: "Batch size"
- Options:
  - "2 steps"
  - "5 steps"
  - "10 steps"

## Step 2.5: Get Execution Strategy

Ask the user:
- Question: "Which execution strategy do you want to use?"
- Header: "Strategy"
- Options:
  - "Fast (Recommended)" - Parallel execution without reviews. Quick but less safe.
  - "With reviews" - Each task gets spec compliance + code quality review. Slower but catches issues early.
  - "Hybrid" - Parallel execution, then one combined review at the end of each batch.

## Step 3: Load Plan

If the plan location is a Google Docs URL:
- Use the `ant:google-docs` skill to load the document content
- Select "Full document" when asked

If the plan location is a local file:
- Read the file using the available file reader

## Step 4: Execute

If `superpowers:executing-plans` is unavailable, use `ant:implementation-orchestrator` for the execution flow and preserve the selected execution mode and review strategy as constraints.

Invoke the `superpowers:executing-plans` skill with this context:

**Execution mode:** [the mode from Step 2]

**Model selection for subagents:** For each subagent/delegation call, choose the model based on step complexity:

| Model | When to use |
|-------|-------------|
| `haiku` | Step is clearly defined with explicit file paths, code snippets, or mechanical changes. E.g., "Create file X with content Y", "Add import Z", simple CRUD. **Default for well-specified steps.** |
| `sonnet` | Step requires moderate reasoning or decision-making. E.g., "Implement function that does X" without exact code, refactoring, component integration. |
| `opus` | Step requires complex architectural decisions, creative problem-solving, or has ambiguous requirements. Use sparingly. |

Detailed plans from `superpowers:write-plan` typically work well with `haiku` for most steps.

---

### Execution Strategy Instructions

**If "Fast" strategy:**

Use `superpowers:dispatching-parallel-agents` skill for parallel execution of independent tasks within each batch. No review steps.

**If "With reviews" strategy:**

Use `superpowers:subagent-driven-development` skill. This executes tasks sequentially with two mandatory review stages per task:
1. Implementer → Spec reviewer (loop until approved) → Code quality reviewer (loop until approved)

**If "Hybrid" strategy:**

1. Use `superpowers:dispatching-parallel-agents` to execute all tasks in the batch in parallel
2. After batch completes, dispatch one combined reviewer subagent to check spec compliance and code quality for all tasks
3. Fix any issues before proceeding to next batch

---

Follow the `superpowers:executing-plans` skill for the overall flow (batching, checkpoints, completion).
