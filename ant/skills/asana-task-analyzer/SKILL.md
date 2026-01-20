---
name: asana-task-analyzer
description: Analyze Asana task requirements for implementers. Use when user provides an Asana task URL and wants to understand what needs to be done. Extracts task details, comments, and attachments to provide clear implementation guidance.
---

# Asana Task Analyzer

## Purpose

Analyze Asana tasks and provide **crystal clear** implementation guidance. If ANYTHING is unclear or requires assumptions, **immediately flag it**.

## Step 1: Extract Task ID from URL

Asana URLs formats:
- `https://app.asana.com/0/{project_id}/{task_id}`
- `https://app.asana.com/0/{project_id}/{task_id}/f`
- `https://app.asana.com/0/0/{task_id}/f`

Extract the **task_id** (the last numeric segment before `/f`).

## Step 2: Gather All Task Information

**ALWAYS fetch ALL of these using MCP tools:**

```
# 1. Get task details (name, description, assignee, due date, custom fields)
mcp__asana__asana_get_task(
  task_id: "{TASK_ID}",
  opt_fields: "name,notes,html_notes,assignee,assignee.name,due_on,due_at,start_on,completed,projects,projects.name,custom_fields,custom_fields.name,custom_fields.display_value,tags,tags.name,parent,parent.name,dependencies,dependents"
)

# 2. Get all comments and activity (important context!)
mcp__asana__asana_get_stories_for_task(
  task_id: "{TASK_ID}",
  opt_fields: "text,html_text,created_by,created_by.name,created_at,type,resource_subtype"
)

# 3. Get attachments (may contain specs, mockups, designs)
mcp__asana__asana_get_attachments_for_object(
  parent: "{TASK_ID}",
  opt_fields: "name,download_url,view_url,resource_type"
)
```

## Step 3: Analyze and Present

### Structure your response as:

```markdown
## 📋 Task: {task_name}

**Project:** {project_name}
**Due:** {due_date}
**Assignee:** {assignee}
**Status:** {completed ? "Done" : "Open"}

---

## 🎯 Co se po tobě chce

{Clear, actionable description of what needs to be implemented}

---

## 📝 Detailní požadavky

{Bullet points of specific requirements extracted from description and comments}

---

## 💬 Důležité z komentářů

{Key information from comments that affects implementation}

---

## 📎 Přílohy

{List attachments with links - these may contain mockups/specs!}

---

## ⚠️ NEJASNOSTI A DOMNĚNKY

{List ANYTHING that is:
- Not explicitly stated
- Could be interpreted multiple ways
- Requires clarification from task creator
- You had to assume

If nothing is unclear, state: "Zadání je jasné, žádné domněnky."}

---

## ✅ Akční kroky

1. {First concrete step}
2. {Second concrete step}
3. ...
```

## CRITICAL Rules

1. **NEVER assume** - If something isn't explicitly stated, LIST IT as unclear
2. **Read ALL comments** - Often contain crucial clarifications
3. **Check attachments** - May have mockups, designs, or specs
4. **Flag ambiguity** - Better to ask than to implement wrong
5. **Be specific** - "Implementovat funkci X" is bad, "Vytvořit endpoint /api/users který vrací..." is good

## Example Unclear Items to Flag

- "Jak má vypadat UI?" (pokud není mockup)
- "Jaké validace jsou potřeba?"
- "Co se má stát při chybě?"
- "Jaké jsou edge cases?"
- "Je potřeba zpětná kompatibilita?"
- "Jaký je očekávaný výkon/zátěž?"

## Notes

- Task ID is the numeric part at the end of the URL
- Use Czech for the output (as per examples above)
- Always check `html_notes` for formatted content
- Comments often have more detail than the main description
