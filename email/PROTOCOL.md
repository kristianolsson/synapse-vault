# Email Module

This module governs Gmail operations using the `gmail` command-line tool.

To interact with Gmail, you MUST run the `gmail` tool, which is globally available in your environment.
Run `gmail --help` and `gmail <command> --help` to discover all available commands and arguments.

## Rules
- **Drafts only:** You can compose and reply to emails, but only as drafts. Never attempt to send — there is no send command.
- **Label resolution:** `apply-label` and `remove-label` accept label names, not IDs. Use `list-labels` first if you are unsure of the exact name.
- **Errors:** If the CLI returns an error, notify the user and do not proceed.

## Filing (Archive to Synapse)
- **To file a thread:** run `gmail apply-label <thread_id> Synapse`, then `gmail remove-label <thread_id> INBOX`. Both are safe to repeat on an already-filed thread — don't check first.
- **Missing label:** if `apply-label` reports that `Synapse` doesn't exist, run `gmail create-label Synapse` once, then retry.
- **Use thread IDs**, not the message IDs shown next to attachments in `read-thread`.
- Use these two commands rather than `archive-thread`, which is only available in some setups.
- Every task that archives email (inbox scans, action scans) files by this definition instead of spelling out its own steps.

## Tracked-from-Email Rule
- When a reminder or calendar event is created or updated from an email, file the source thread **after the action succeeds**. This covers scan-reply picks, forwarded emails ("remind me"), and "track this" / "add to calendar" replies.
- **On failure, don't file.** Leave the email in the inbox and report the error.
- **Several items from one thread:** file it once, after the last action succeeds.
- **Forwarded emails:** file the forward's own thread. File the original thread only if it can be identified unambiguously (e.g. a `gmail search` on its exact subject and sender returns one thread); otherwise leave it.
- Applies to the user's own notes-to-self too, which inbox scans otherwise skip.
- **Never file Synapse system emails** (scans, digests, reminders) under this rule — including the thread where the user replied to one. That thread stays in the inbox.

## Scan Replies
- A reply to a Synapse email that picks numbered items (e.g. "do 1 and 3", "do 2 at 18:00") does exactly those items, with any changes the user states. Items not picked are left alone.
- If the quoted email gives each item a `ref: <thread_id>` line, apply the Tracked-from-Email Rule to that thread after the item succeeds.
- If a picked number, or its `ref:`, can't be found in the quoted text, ask rather than guess.
