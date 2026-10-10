# Shipfound skills

Agent skills for [Shipfound](https://www.shipfound.co), for Claude Code, Codex, Cursor and other agents that read `SKILL.md`.

## shipfound-monitor-ai-citations

Checks whether ChatGPT and other AI engines name your product when buyers ask, and who they name instead.

```sh
npx skills add karamanbk/shipfound-skills
```

**What it needs**

- A Shipfound account with your site added: https://www.shipfound.co. The first check is free.
- An API key: in the Shipfound app, Settings, MCP connection, make a key (it starts with `wl_`), then `export SHIPFOUND_API_KEY=wl_...`. If you use the Shipfound plugin, the skill uses its tools and needs no key.

**Try asking your agent**

- "Is ChatGPT naming my product?"
- "Which brands does AI recommend instead of us?"
- "Did anything change since the last AI visibility check?"

The skill reads and starts checks only; it changes nothing on your site. A first check is free; later checks cost 15 Shipfound credits on Builder or Growth, and the skill asks before starting one. Its script talks only to the Shipfound API and keeps nothing on disk.

## Licence

MIT
