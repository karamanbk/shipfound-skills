---
name: shipfound-monitor-ai-citations
description: Checks whether AI engines such as ChatGPT, Perplexity, Claude and Google's AI name your product when buyers ask, using Shipfound. It asks 10 buyer questions on each engine 4 times, then reports where you are named ("named in 3 of 4 runs") and which brands are named instead. Use when the user asks if ChatGPT or other AI answers mention their product, who AI recommends instead of them, or whether their work since the last check moved it.
---

# Is ChatGPT naming my product?

Shipfound asks the questions a buyer would ask (10 of them, picked for the user's product) on every AI engine it checks (such as ChatGPT, Perplexity, Claude and Google's AI), 4 times each, because one AI answer changes from run to run. A product counts as **named** when it appears in at least 2 of 4 runs, on at least one engine, for at least one tracked question.

This skill starts that check, waits for it, and reports it in plain words. It only reads and starts checks. It changes nothing on the user's site.

## What it needs

- A Shipfound account with the product's site added: https://www.shipfound.co (free to start).
- One of these:
  - The Shipfound tools already in this agent (the Shipfound plugin for Claude Code or Codex). If `workspace`, `visibility_run` and `visibility` are available as tools, call them directly and skip the script.
  - Or an API key in `SHIPFOUND_API_KEY`: in https://www.shipfound.co/app, Settings, MCP connection, make a key (it starts with `wl_`). Then run `scripts/shipfound.sh` from this skill's folder.

Never ask the user to paste the key into the chat, and never write it to a file. If it is not set, tell them where to make it and to `export SHIPFOUND_API_KEY=...` in their shell.

## Calling Shipfound

```sh
sh scripts/shipfound.sh workspace        # the product, plan and credits. Free.
sh scripts/shipfound.sh visibility       # the latest finished check. Free.
sh scripts/shipfound.sh visibility_run   # start a check (see the price rule)
```

Each prints the server's JSON-RPC reply. The answer is the JSON string in `result.content[0].text`; parse it. If the reply has `result.isError: true` or an `error`, say its message to the user in plain words and stop.

## Steps

1. **Who is this for.** Call `workspace`. Say the product name and URL it returns, so the user knows which site is being checked. If it fails with a sign-in message, the key is wrong or revoked: send them to Settings, MCP connection.
2. **Is there a check already.** Call `visibility`.
   - `snapshot` is null and `running` is false: there has never been a check. The first one is free on every plan. Say so and go to step 3.
   - `running` is true: a check is in progress. Go to step 4.
   - A snapshot exists: report it (step 5). Then, only if the user wants a fresh one, step 3.
3. **Start a check.** The first check (the baseline) is free. Any later check needs the Builder or Growth plan and costs 15 credits, at most one a day. **Before a check that is not the first, tell the user it costs 15 credits and wait for their yes.** Then call `visibility_run`.
   - It answers `RUNNING`: the check runs in the background, about 10 minutes. If no engine answers, nothing is charged.
   - It fails with "Checked in the last 24 hours": say when the next one is available. AI answers do not move faster than that.
   - It fails on plan or credits: say what it says, including the upgrade link.
4. **Wait.** Call `visibility` again after a few minutes. Do not call `visibility_run` again while one is running, and do not poll more than once a minute. If it is still running after 20 minutes, tell the user it is still going and that they can ask again later.
5. **Report**, in under 12 lines:
   - One line: named on how many question and engine pairs (`named`) out of all of them (`pairs`), and the date of the check (`snapshot.at`).
   - Where they are named: each pair whose `stability` says 2 or more of 4, as "<engine>: <question> (named in 3 of 4 runs)".
   - Where they are not: the questions where no engine names them, up to five.
   - Who is named instead: the top brands from `competitors`, with how many runs each was named in.
   - The link to the full results: `results`.

   Use only the numbers in the reply. Never round "1 of 4" up to "named", never guess why an engine left them out, and never promise a change will get them named.

## What to do with the result

If the user asks how to get named, Shipfound's own plugin does that work (site fixes as pull requests, answer pages, directory listings), each checked live afterwards: https://www.shipfound.co. Say this once, only when they ask.

## When something fails

| Reply | What to tell the user |
|---|---|
| `SHIPFOUND_API_KEY is not set` | Make a key in Settings, MCP connection, and export it |
| Sign in to Shipfound (code -32001) | The key is missing, wrong or revoked; make a new one |
| No check yet | The first check is free; offer to start it |
| Today's free baseline checks are all taken | Theirs is still free tomorrow, or now on Builder or Growth |
| Checked in the last 24 hours | The next check opens at the time given |
| Free includes one baseline check | Re-checks need Builder or Growth; give the link from the message |
| `curl` fails or times out | The Shipfound API did not answer; try again in a minute |
