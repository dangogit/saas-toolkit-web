---
name: vercel-staging-production
description: Vercel deployment environments - preview deploys as staging, production deploys, custom domains, and environment variable management. Use when deploying, setting up environments, or configuring domains.
---

# Vercel Staging and Production

## How Vercel Environments Work

Vercel has three built-in environments:

| Environment | Trigger | URL | Purpose |
|-------------|---------|-----|---------|
| **Development** | `vercel dev` | localhost:3000 | Local development |
| **Preview** | Push to any branch / PR | `your-app-git-branch.vercel.app` | Staging / testing |
| **Production** | Push to main branch | `your-app.vercel.app` + custom domain | Live site |

## Preview Deploys = Staging

Every PR automatically gets a unique preview URL. This IS your staging environment:

```bash
# Push a feature branch
git push origin feature/add-pricing

# Vercel automatically deploys to:
# https://your-app-feature-add-pricing.vercel.app
```

Share this URL with testers. It uses preview environment variables.

## Environment Variables per Environment

### In Vercel Dashboard
Go to Project Settings -> Environment Variables. Each variable can be set for:
- **Production** - only production deploys
- **Preview** - only preview/staging deploys
- **Development** - only `vercel dev`

### Common Setup

```
SUPABASE_URL
  Production: https://prod-project.supabase.co
  Preview:    https://staging-project.supabase.co
  Development: http://127.0.0.1:54321

POLAR_ACCESS_TOKEN
  Production: polar_live_xxx
  Preview:    polar_sandbox_xxx
  Development: polar_sandbox_xxx

RESEND_API_KEY
  Production: re_live_xxx  (sends real emails)
  Preview:    re_test_xxx  (emails only to you)
  Development: re_test_xxx
```

### Pull to Local

```bash
vercel env pull .env.local                    # Development vars
vercel env pull .env.preview --environment preview  # Preview/staging vars
```

## Custom Domain

```bash
# Add a custom domain
vercel domains add yourdomain.com

# Or in the Vercel dashboard:
# Project Settings -> Domains -> Add
```

Vercel handles SSL certificates automatically.

## Deployment Commands

```bash
# Deploy to preview (for testing)
vercel

# Deploy to production
vercel --prod

# View deployment status
vercel ls
```

## The Workflow

```
Feature Branch (git push)
  -> Vercel Preview Deploy (staging URL)
    -> Test with staging Supabase + sandbox payments
      -> Looks good? Merge PR to main
        -> Vercel Production Deploy (live URL)
          -> Real Supabase + real payments + real users
```

## Rollback

If a production deploy breaks:

```bash
# List recent deployments
vercel ls

# Promote a previous deployment to production
vercel promote [deployment-url]
```

Or in the Vercel dashboard: Deployments -> click the working one -> Promote to Production.

## Checklist Before Going to Production

- [ ] All env vars set for Production environment in Vercel dashboard
- [ ] Production Supabase project created (separate from staging)
- [ ] RLS policies verified on production database
- [ ] Custom domain configured and DNS propagated
- [ ] Polar.sh webhooks pointing to production URL
- [ ] Resend domain verified for production emails
- [ ] PostHog configured with production project
- [ ] Error monitoring (Sentry) configured
