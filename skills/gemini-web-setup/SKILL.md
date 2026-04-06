---
name: gemini-web-setup
description: Setting up Google Gemini as the LLM provider with @ai-sdk/google. Covers API keys, model selection, streaming patterns, and configuration. Use when integrating Gemini into a Next.js app via the Vercel AI SDK.
---

# Gemini Web Setup

## Install

```bash
npm install ai @ai-sdk/google zod
```

## Environment Variable

```bash
# .env.local
GOOGLE_GENERATIVE_AI_API_KEY=your_key_here
```

Get your key: https://aistudio.google.com/apikey

## Available Models

| Model | Best For | Speed | Cost |
|-------|---------|-------|------|
| `gemini-2.5-flash` | Most tasks - good balance of speed and quality | Fast | Low |
| `gemini-2.5-pro` | Complex reasoning, long context | Slower | Higher |
| `gemini-2.0-flash` | Image generation (native) | Fast | Low |
| `gemini-3-flash-preview` | Latest features (preview) | Fast | Low |

**Default recommendation:** `gemini-2.5-flash` for most SaaS features.

## Basic Usage

```typescript
import { google } from '@ai-sdk/google';
import { generateText, streamText, Output } from 'ai';
import { z } from 'zod';

// One-shot text generation
const { text } = await generateText({
  model: google('gemini-2.5-flash'),
  prompt: 'Explain SaaS in one paragraph',
});

// Streaming (for chat UIs)
const result = streamText({
  model: google('gemini-2.5-flash'),
  messages: [{ role: 'user', content: 'Hello!' }],
});

// Structured output (typed JSON)
// NOTE: generateObject() is DEPRECATED in AI SDK v5+
// Use generateText() with Output.object() instead:
const { output } = await generateText({
  model: google('gemini-2.5-flash'),
  output: Output.object({
    schema: z.object({ title: z.string(), summary: z.string() }),
  }),
  prompt: 'Summarize this article...',
});
// output.title and output.summary are type-safe
```

## Structured Streaming

```typescript
import { streamText, Output } from 'ai';

const { partialOutputStream } = streamText({
  model: google('gemini-2.5-flash'),
  output: Output.object({
    schema: z.object({ title: z.string(), summary: z.string() }),
  }),
  prompt: 'Summarize this article...',
});

for await (const partial of partialOutputStream) {
  console.log(partial); // partial object, updates as tokens arrive
}
```

## Chat API Route Pattern

```typescript
// app/api/chat/route.ts
import { google } from '@ai-sdk/google';
import { streamText } from 'ai';

export async function POST(req: Request) {
  const { messages } = await req.json();

  const result = streamText({
    model: google('gemini-2.5-flash'),
    system: 'You are a helpful assistant for our SaaS product.',
    messages,
  });

  return result.toDataStreamResponse();
}
```

## Via Vercel AI Gateway (Alternative)

Instead of using your own API key, you can route through Vercel's AI Gateway:

```typescript
import { createOpenAI } from '@ai-sdk/openai';

const gateway = createOpenAI({
  baseURL: 'https://gateway.ai.vercel.app/v1',
  apiKey: process.env.VERCEL_AI_GATEWAY_KEY,
});

const model = gateway('google/gemini-2.5-flash');
```

Benefits: unified billing through Vercel, automatic failover, usage tracking.

## Cost Estimates

Gemini's free tier covers most development:
- Free: Up to 1M tokens on some models
- Paid: ~$0.075 per 1M input tokens (flash models)

For a SaaS with 100 daily users making 10 requests each: ~$1-5/month.

## Switching Providers

The beauty of the AI SDK is provider switching. Change one line:

```typescript
// From Gemini:
import { google } from '@ai-sdk/google';
const model = google('gemini-2.5-flash');

// To OpenAI:
import { openai } from '@ai-sdk/openai';
const model = openai('gpt-4o');

// To Anthropic:
import { anthropic } from '@ai-sdk/anthropic';
const model = anthropic('claude-sonnet-4-5-20250514');
```

Everything else (tools, streaming, structured output) stays the same.
