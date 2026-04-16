# ncode-saas-toolkit-web

Web development track extension for Claude Code. Part of the nCode course by Daniel Goldman.

## Install

```bash
# Requires base plugin first
claude plugin add dangogit/ncode-saas-toolkit

# Then install web extension
claude plugin add dangogit/ncode-saas-toolkit-web
```

## What's Included

### Custom Skills (in this plugin)
- `gemini-web-setup` - Set up Gemini as LLM provider with @ai-sdk/google
- `v0-to-codebase` - Export v0 projects into Next.js codebases
- `vercel-staging-production` - Preview deploys, production deploys, domains

### Required Marketplace Skills (install separately)

```bash
# Vercel AI SDK v5 - agents, streaming, tool calling (1,170 lines, excellent)
npx skills add wsimmonds/claude-nextjs-skills@vercel-ai-sdk -g -y

# Supabase RLS security audit (440 lines, teaches security through auditing)
npx skills add yoanbernabeu/supabase-pentest-skills@supabase-audit-rls -g -y

# Polar.sh payments (228 lines + 150K references, 30 reference files)
npx skills add bbssppllvv/essential-skills@polar-integration -g -y

# Resend email (official)
npx skills add resend/resend-skills@resend -g -y
npx skills add resend/react-email@react-email -g -y

# Supabase Postgres (official, 56.8K installs)
npx skills add supabase/agent-skills@supabase-postgres-best-practices -g -y

# Supabase + Next.js auth patterns (3.8K installs)
npx skills add sickn33/antigravity-awesome-skills@nextjs-supabase-auth -g -y

# PostHog analytics
npx skills add alinaqi/claude-bootstrap@posthog-analytics -g -y
```

## MCP Servers (connect Claude Code to your services)

```bash
# Supabase - manage database, run SQL, deploy edge functions
claude mcp add supabase -s user \
  -e SUPABASE_ACCESS_TOKEN=your_pat_here \
  -- npx -y @supabase/mcp-server-supabase@latest

# Vercel - manage deployments, env vars, logs
claude mcp add --transport http vercel https://mcp.vercel.com

# Resend - send emails, manage domains, debug delivery
claude mcp add resend -s user \
  -e RESEND_API_KEY=re_xxxxxxxxx \
  -- npx -y resend-mcp

# PostHog - query analytics, manage feature flags, run experiments
npx @posthog/wizard@latest mcp add

# Polar.sh - manage products, subscriptions, billing
claude mcp add --transport http polar https://mcp.polar.sh/mcp/polar-mcp

# Gemini - image generation, video generation, web search, research
claude mcp add gemini -s user \
  -e GEMINI_API_KEY=your_key \
  -- npx -y @rlabs-inc/gemini-mcp
```

## Recommended Additional Plugins
- `vercel-plugin` - Full Vercel ecosystem (Next.js, AI SDK, shadcn, deployment)
