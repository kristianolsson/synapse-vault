# Synapse Vault

The public, generic protocol-layer template for **Synapse** — a personal management system where an AI CLI agent (Claude Code, Antigravity CLI, or Gemini CLI) operates on an Obsidian-style vault of notes, tasks, links, and reminders, driven non-interactively by [Synapse Engine](https://github.com/kristianolsson/synapse-engine).

> This repo ships operating manuals and module protocols only — no personal data. Clone it to start your own private vault.

![Vault Profile Pic](assets/vault-profile.jpg)

## What this is

`synapse-vault` is a starter template, not a live vault. It contains:
- `CLAUDE.md` / `GEMINI.md` — the operating manual read automatically by each AI CLI: how to classify requests, route them to the right module, format output, and handle errors.
- One `PROTOCOL.md` per module (`tasks/`, `links/`, `reminders/`, `calendar/`, `stocks/`, `groceries/`, `email/`, `projects/`) — the specific rules for that domain.
- Empty starter data files (`tasks/master_todos.md`, `reminders/reminders.json`, etc.) so the vault works immediately after cloning.
- `.claude/agents/stock-researcher.md` — a sub-agent definition used by the stocks module.

## The `PERSONAL.md` pattern

`CLAUDE.md` and `GEMINI.md` are both fully generic — neither contains your name, family, or location. Instead, both import a single file via `@PERSONAL.md` (a syntax [Claude Code](https://code.claude.com/docs/en/memory) and [Gemini CLI](https://geminicli.com/docs/cli/gemini-md/) both support), which is gitignored here and never committed. One source of personal context feeds both providers, instead of duplicating it into two files that could drift apart.

Run `./setup.sh` after cloning to generate your own `PERSONAL.md` interactively, or copy `PERSONAL.md.example` by hand.

## Using this with Synapse Engine

[Synapse Engine](https://github.com/kristianolsson/synapse-engine) is the ingestion/dispatch layer that runs the AI CLI against this vault on a schedule and over Email/Telegram. This repo is the vault it operates on — point its `VAULT_PATH` at your clone.

## Getting started with your own private vault

This repo is a public template — don't use it as your live vault directly. Instead:

1. Clone it:
   ```bash
   git clone git@github.com:kristianolsson/synapse-vault.git my-vault
   cd my-vault
   ```
2. Run `./setup.sh` to create your `PERSONAL.md`. It's fine to do this before detaching in step 3 below — until it runs, `CLAUDE.md`/`GEMINI.md`'s `@PERSONAL.md` import just warns the file doesn't exist yet, which is harmless. `setup.sh` also automatically un-gitignores `PERSONAL.md` once it's written, since at that point this is your real vault, not the public template — it'll print the exact commands to commit it.
3. Detach it from this repo and point it at your own private repo:
   ```bash
   rm -rf .git
   git init
   git add .
   git commit -m "Initial vault from synapse-vault template"
   git remote add origin <your-private-repo-url>
   git branch -M main
   git push -u origin main
   ```
4. Replace the placeholder E*TRADE account in `stocks/options_config.yaml` (`accounts.default: "1234"`) with your real account suffix before using the stocks/options tooling — see `stocks/PROTOCOL.md` for how it's used.
5. Point [Synapse Engine](https://github.com/kristianolsson/synapse-engine)'s `VAULT_PATH` at your new vault directory.

## Structure

- `daily/`: Daily log files — created automatically on first use, not seeded here.
- `tasks/`, `links/`, `reminders/`, `calendar/`, `stocks/`, `groceries/`, `email/`: One module per domain — each has a `PROTOCOL.md` and, where applicable, starter data files.
  - `stocks/options_config.yaml` ships with a **placeholder** E*TRADE account number (`1234`) — replace `accounts.default` with your real account suffix before using the options/stocks tooling.
- `projects/`: Project notes structure — `PROTOCOL.md` and `templates/project_template.md`. Category subfolders (coding, family, finance, home, etc.) are created on demand.
- `.claude/agents/`: Sub-agent definitions available to Claude Code.
- `CLAUDE.md` / `GEMINI.md`: Operating manuals — see "The `PERSONAL.md` pattern" above for why personal context is split out.
