# saas-toolkit-web

Web development track extension for saas-toolkit. Part of the nCode course ecosystem.

## Stack

- **Framework:** Next.js (App Router)
- **Database:** Supabase (PostgreSQL + Auth + RLS)
- **Hosting:** Vercel
- **AI:** Vercel AI SDK + Gemini (`@ai-sdk/google`)
- **Payments:** Polar.sh
- **Email:** Resend + React Email
- **UI:** shadcn/ui + Tailwind CSS
- **Analytics:** PostHog

## Auth

Default auth provider is Google OAuth via Supabase Auth. Always set up:
- Google Cloud Console OAuth consent screen
- Redirect URLs in Supabase dashboard
- `NEXT_PUBLIC_SUPABASE_URL` and `NEXT_PUBLIC_SUPABASE_ANON_KEY` in env vars

## Requires

Base plugin: `dangogit/saas-toolkit`
