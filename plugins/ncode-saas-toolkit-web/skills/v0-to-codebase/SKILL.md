---
name: v0-to-codebase
description: How to export v0.dev projects and integrate them into existing Next.js codebases. Covers connecting v0 to GitHub, syncing with local development, and migrating from v0 to Claude Code. Use when transitioning from v0 to local development.
---

# v0 to Codebase

## v0 and Your Codebase

v0.dev creates Next.js projects that deploy to Vercel. When you're ready to work locally with Claude Code, you need to connect v0 to your GitHub repo.

## Option 1: v0 GitHub Sync (Recommended)

v0 can connect directly to a GitHub repository:

1. In v0, click the **Git** icon in the sidebar
2. Connect to GitHub and select your repo (or create new)
3. v0 pushes code to the repo automatically
4. Vercel auto-deploys from the repo

Now you can:
- Edit in v0 for quick visual changes
- Edit locally with Claude Code for complex features
- Both push to the same GitHub repo

## Option 2: Clone from v0

If you started in v0 and want to go fully local:

```bash
# 1. Connect v0 to GitHub first (see above)
# 2. Clone the repo locally
git clone https://github.com/your-username/your-project.git
cd your-project

# 3. Install dependencies
npm install

# 4. Pull environment variables from Vercel
vercel link  # Link to your Vercel project
vercel env pull .env.local  # Pull env vars

# 5. Run locally
npm run dev
```

## What v0 Generates

A v0 project is a standard Next.js app:

```
your-project/
  app/
    layout.tsx        # Root layout
    page.tsx          # Home page
    globals.css       # Global styles (Tailwind)
  components/
    ui/               # shadcn/ui components
    ...               # Your custom components
  lib/
    utils.ts          # Utility functions
  public/             # Static files
  package.json
  tailwind.config.ts
  tsconfig.json
```

## After Cloning: Set Up for Claude Code

```bash
# 1. Initialize Supabase locally (if using)
supabase init
supabase link --project-ref your-project-ref
supabase db pull

# 2. Add CLAUDE.md for project context
# Claude Code will understand your project better with this file
```

Recommended CLAUDE.md for a v0 project:

```markdown
# CLAUDE.md

## Stack
- Next.js 15 (App Router)
- Supabase (database + auth)
- Vercel (hosting)
- Tailwind CSS + shadcn/ui
- Polar.sh (payments)

## Commands
- `npm run dev` - Start dev server
- `supabase start` - Start local Supabase
- `vercel dev` - Dev with Vercel env vars

## Structure
- `app/` - Pages and API routes
- `components/ui/` - shadcn/ui components
- `components/` - Custom components
- `lib/` - Utilities and Supabase client
```

## Supabase Connection

v0 connects to Supabase via the Vercel Marketplace. The environment variables are already set in Vercel. Pull them locally:

```bash
vercel env pull .env.local
```

This gives you `SUPABASE_URL`, `SUPABASE_ANON_KEY`, etc.

## When to Use v0 vs Claude Code

| Task | Use v0 | Use Claude Code |
|------|--------|----------------|
| Quick UI prototyping | Yes | |
| Visual design iteration | Yes | |
| Complex business logic | | Yes |
| Multi-file refactoring | | Yes |
| Database migrations | | Yes |
| API routes with tools | | Yes |
| Deployment config | | Yes |

The typical flow: **Start in v0 for the UI, then move to Claude Code for everything else.**
