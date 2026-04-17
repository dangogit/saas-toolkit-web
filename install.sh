#!/usr/bin/env bash
# nCode ncode-saas-toolkit-web Installer
# https://github.com/dangogit/ncode-saas-toolkit-web
#
# Installs the web track plugin + all marketplace skills + MCP servers.
# Run the base installer first: danielthegoldman.com/ncode-saas-toolkit/install.sh

# -----------------------------------------
# Colors & helpers
# -----------------------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

print_step()       { echo -e "\n${CYAN}${BOLD}> $1${RESET}"; }
print_done()       { echo -e "  ${GREEN}[ok] $1${RESET}"; }
print_installing() { echo -e "  ${YELLOW}[..] $1...${RESET}"; }
print_error()      { echo -e "  ${RED}[!!] $1${RESET}"; }
print_info()       { echo -e "  ${CYAN}[i] $1${RESET}"; }

# -----------------------------------------
# Pre-flight check
# -----------------------------------------
if ! command -v claude &>/dev/null; then
  print_error "Claude Code is not installed."
  echo -e "  Run: ${BOLD}curl -fsSL https://danielthegoldman.com/claude-code/install.sh | bash${RESET}"
  exit 1
fi

# -----------------------------------------
# Welcome banner
# -----------------------------------------
echo ""
echo -e "${BOLD}${CYAN}+================================================+${RESET}"
echo -e "${BOLD}${CYAN}|     nCode Web Track Installer                   |${RESET}"
echo -e "${BOLD}${CYAN}|  Next.js + Supabase + Vercel + AI SDK + Gemini  |${RESET}"
echo -e "${BOLD}${CYAN}+================================================+${RESET}"
echo ""
echo -e "  This installer will set up:"
echo -e "  ${GREEN}+${RESET} ncode-saas-toolkit-web plugin (3 custom skills)"
echo -e "  ${GREEN}+${RESET} Vercel plugin (Next.js, AI SDK, shadcn, deployment)"
echo -e "  ${GREEN}+${RESET} 7 marketplace skills (AI SDK, Supabase RLS, Polar, Resend, PostHog)"
echo -e "  ${GREEN}+${RESET} 7 MCP servers (Supabase, Vercel, Resend, PostHog, Polar, Gemini, Snyk)"
echo ""

# =========================================
# PLUGINS
# =========================================

print_step "Installing web track plugin"
print_installing "Adding marketplace: dangogit/ncode-saas-toolkit-web"
claude plugin marketplace add https://github.com/dangogit/ncode-saas-toolkit-web 2>/dev/null
print_installing "Installing plugin"
claude plugin install ncode-saas-toolkit-web 2>/dev/null && \
  print_done "ncode-saas-toolkit-web installed" || \
  print_done "ncode-saas-toolkit-web already installed"

print_step "Installing Vercel plugin"
print_installing "vercel-plugin (Next.js, AI SDK, shadcn, deployment)"
claude plugin install vercel-plugin 2>/dev/null && \
  print_done "vercel-plugin installed" || \
  print_done "vercel-plugin already installed"

# =========================================
# MARKETPLACE SKILLS
# =========================================

print_step "Installing marketplace skills"

print_installing "Vercel AI SDK v5 (agents, streaming, tool calling)"
npx skills add wsimmonds/claude-nextjs-skills@vercel-ai-sdk -g -y 2>/dev/null
print_done "vercel-ai-sdk"

print_installing "Supabase RLS security audit"
npx skills add yoanbernabeu/supabase-pentest-skills@supabase-audit-rls -g -y 2>/dev/null
print_done "supabase-audit-rls"

print_installing "Polar.sh payments (30 reference files)"
npx skills add bbssppllvv/essential-skills@polar-integration -g -y 2>/dev/null
print_done "polar-integration"

print_installing "Resend email SDK (official)"
npx skills add resend/resend-skills@resend -g -y 2>/dev/null
print_done "resend"

print_installing "React Email templates (official)"
npx skills add resend/react-email@react-email -g -y 2>/dev/null
print_done "react-email"

print_installing "Supabase Postgres best practices (official)"
npx skills add supabase/agent-skills@supabase-postgres-best-practices -g -y 2>/dev/null
print_done "supabase-postgres-best-practices"

print_installing "Next.js + Supabase auth patterns"
npx skills add sickn33/antigravity-awesome-skills@nextjs-supabase-auth -g -y 2>/dev/null
print_done "nextjs-supabase-auth"

print_installing "PostHog analytics"
npx skills add alinaqi/claude-bootstrap@posthog-analytics -g -y 2>/dev/null
print_done "posthog-analytics"

print_installing "SEO audit (Section 6 - Web Advanced)"
npx skills add yahav-marketing/yahav-skills@seo-audit -g -y 2>/dev/null
print_done "seo-audit"

print_installing "OWASP security check (Section 8 - Pro Topics)"
npx skills add alinaqi/claude-bootstrap@owasp-security-check -g -y 2>/dev/null
print_done "owasp-security-check"

print_installing "Landing page design"
npx skills add yahav-marketing/yahav-skills@landing-page-design -g -y 2>/dev/null
print_done "landing-page-design"

print_installing "Internationalizing websites (Hebrew/English)"
npx skills add alinaqi/claude-bootstrap@internationalizing-websites -g -y 2>/dev/null
print_done "internationalizing-websites"

print_installing "Fullstack eval (live testing Next.js + Supabase)"
npx skills add alinaqi/claude-bootstrap@fullstack-eval -g -y 2>/dev/null
print_done "fullstack-eval"

# =========================================
# MCP SERVERS
# =========================================

print_step "Configuring MCP servers"

print_installing "Supabase MCP (database, SQL, migrations)"
claude mcp add supabase -s user -- npx -y @supabase/mcp-server-supabase@latest 2>/dev/null
print_done "Supabase MCP added"
print_info "Set your token: claude mcp update supabase -e SUPABASE_ACCESS_TOKEN=your_pat"

print_installing "Vercel MCP (deployments, env vars, logs)"
claude mcp add --transport http vercel https://mcp.vercel.com 2>/dev/null
print_done "Vercel MCP added (authenticate via /mcp in Claude Code)"

print_installing "Resend MCP (send emails, manage domains)"
claude mcp add resend -s user -- npx -y resend-mcp 2>/dev/null
print_done "Resend MCP added"
print_info "Set your key: claude mcp update resend -e RESEND_API_KEY=re_xxx"

print_installing "PostHog MCP (analytics, feature flags)"
claude mcp add --transport http posthog https://mcp.posthog.com/sse 2>/dev/null || true
print_done "PostHog MCP added"

print_installing "Polar.sh MCP (products, subscriptions)"
claude mcp add --transport http polar https://mcp.polar.sh/mcp/polar-mcp 2>/dev/null
print_done "Polar MCP added"

print_installing "Gemini MCP (image gen, video gen, web search)"
claude mcp add gemini -s user -- npx -y @rlabs-inc/gemini-mcp 2>/dev/null
print_done "Gemini MCP added"
print_info "Set your key: claude mcp update gemini -e GEMINI_API_KEY=your_key"

print_installing "Snyk MCP (security scanning: code + dependencies + IaC)"
claude mcp add snyk -s user -- npx -y snyk@latest mcp 2>/dev/null
print_done "Snyk MCP added"
print_info "Authenticate with: run 'snyk auth' in terminal (free tier sufficient)"

# -----------------------------------------
# Done!
# -----------------------------------------
echo ""
echo -e "${BOLD}${GREEN}+================================================+${RESET}"
echo -e "${BOLD}${GREEN}|        Web track ready!                         |${RESET}"
echo -e "${BOLD}${GREEN}+================================================+${RESET}"
echo ""
echo -e "  ${BOLD}What was installed:${RESET}"
echo -e "  ncode-saas-toolkit-web plugin + vercel-plugin"
echo -e "  8 marketplace skills (AI SDK, RLS, Polar, Resend, Supabase, PostHog)"
echo -e "  7 MCP servers (Supabase, Vercel, Resend, PostHog, Polar, Gemini, Snyk)"
echo ""
echo -e "  ${BOLD}API keys to configure:${RESET}"
echo -e "  ${CYAN}1.${RESET} Supabase: get a Personal Access Token from supabase.com/dashboard/account/tokens"
echo -e "  ${CYAN}2.${RESET} Resend:   get an API key from resend.com/api-keys"
echo -e "  ${CYAN}3.${RESET} Gemini:   get an API key from aistudio.google.com/apikey"
echo -e "  ${CYAN}4.${RESET} Vercel:   authenticate via /mcp inside Claude Code"
echo ""
echo -e "  ${BOLD}Start building:${RESET}"
echo -e "  ${CYAN}claude${RESET}  in any Next.js project directory"
echo ""
