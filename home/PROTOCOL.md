# Home Module

This module governs SmartThings home-automation operations using the `smartthings` command-line tool.

To interact with SmartThings, you MUST run the `smartthings` tool, which is globally available in your environment.
Run `smartthings --help` and `smartthings <command> --help` to discover all available commands and arguments. Never invoke the tool without running `--help` first, even if you believe you know the subcommand or flag names.

## Rules

- **Status checks — only when needed, not always:**
  - Absolute commands ("turn off the lights", "set thermostat to 68") → call `set-state` directly, no status check first. These are idempotent.
  - Relative commands ("dim the lights a bit", "bump the thermostat up 2 degrees") → call `get-status` first to compute the new value, then `set-state`.
  - Conditional commands ("if the garage is open, close it") → `get-status` first, only issue `set-state` if the condition holds.
- **Confirmation tiering:** Security-relevant actions (locks, garage door) MUST be confirmed with the user before executing — present the proposed change and wait for explicit approval. Low-stakes actions (lights, thermostat) execute silently, no confirmation needed. Same asymmetry as calendar's External Party Confirmation rule, applied to physical/security risk instead of external-party risk.
- **Device name resolution:** The CLI fuzzy-matches device names. If it reports an `ambiguous` error (multiple devices match), present the candidate device labels to the user and ask which one they meant — never guess.
- **Bulk actions:** "Turn off all the lights" resolves every matching device, then issues one `set-state` call per device — but present this to the user as a single confirmation covering the whole batch, not one confirmation per device.
- **Errors:** If the CLI returns an error, notify the user with its exact message and do not proceed — no silent retries.
- **Scene/automation triggering needs no special handling.** A calendar-triggered scene (e.g. "leaving for airport" → lock doors) is just a `Type: work` reminder that re-pipes through the normal ingestion flow into this module, identically to a user-typed message.
