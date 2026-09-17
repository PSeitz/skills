# Restore Pi agents nested in Neovim terminals

## Goal

After a reboot, restore the Neovim workspace and resume every Pi agent that was running in its ToggleTerm slot, without manually reopening terminals and selecting sessions.

## Current setup

- tmux uses `tmux-resurrect` and `tmux-continuum`.
- `~/.tmux.conf` maps a directly running `pi` process to `pi -c` during restoration.
- Neovim uses `akinsho/toggleterm.nvim` with five stable terminal slots.
- Neovim uses `rmagatti/auto-session` to save and restore workspaces.
- `sessionoptions` includes buffers and blank windows, so terminal buffers/windows can be recreated.
- ToggleTerm has `persist_size` and `persist_mode` enabled. These persist UI state during a Neovim process, not commands or processes across restarts.

Relevant files:

- `~/.tmux.conf`
- `~/.local/share/chezmoi/dot_tmux.conf`
- `~/.config/nvim/lua/plugins/toggleterm.lua`
- `~/.config/nvim/lua/plugins/auto-session.lua`
- `~/.config/nvim/lua/options.lua`

## Why tmux alone cannot restore nested agents

tmux-resurrect records the foreground process associated with each tmux pane. For a standalone Pi pane, that process is `pi`, and the restore mapping can run `pi -c`.

When Pi runs inside a Neovim terminal, tmux sees `nvim`. Pi is a descendant managed by Neovim's terminal job, so tmux does not know which Neovim terminal slots contain agents. Restoring Neovim can recreate terminal buffers as fresh shells, but it cannot restore the old OS processes.

## Why `pi -c` is insufficient inside ToggleTerm

`pi -c` resumes the most recently modified Pi session for the current working directory. Multiple ToggleTerm slots can run independent agents in the same project. Running `pi -c` in every restored slot could therefore open the same session multiple times instead of restoring the original one-to-one mapping.

The exact mapping must be persisted:

```text
Neovim workspace + ToggleTerm slot -> working directory + Pi session ID
```

Restoration can then use:

```sh
cd <working-directory> && pi --session <session-id>
```

## Feasible design

### 1. Give each terminal a stable identity

When creating ToggleTerm slots 1 through 5, inject environment values identifying at least:

- the slot number;
- the Neovim workspace/project;
- optionally a unique Neovim instance identifier.

The identity must survive hiding and reopening a slot within the same Neovim process.

### 2. Record Pi session identity

Add a small global Pi extension. On Pi session start or switch, it records:

- `PI_SESSION_ID` or the session manager's current ID;
- current working directory;
- ToggleTerm slot/workspace values inherited from the environment;
- whether the session is currently associated with that slot.

On normal Pi exit, mark the slot inactive so completed agents are not relaunched. The registry should be written atomically under Pi state storage, not into a project repository.

### 3. Integrate with auto-session

Use auto-session's `save_extra_data` and `restore_extra_data` hooks:

- save the active slot mappings with the Neovim workspace session;
- after workspace restoration, recreate only slots that had active Pi agents;
- set each terminal's saved working directory;
- start `pi --session <exact-id>` in that slot;
- leave ordinary shell terminals as ordinary shells.

An alternative is to keep the registry entirely in Pi state storage and let auto-session store only the workspace/slot keys.

### 4. Avoid duplicate restoration

Before launching an agent, check that:

- the mapped session file still exists;
- no live process has already claimed the same mapping;
- the terminal slot does not already have a running job;
- the saved working directory still exists.

If restoration cannot be performed safely, open a shell and show a warning rather than guessing with `pi -c`.

## Existing-agent migration

Existing Pi processes do not expose their session ID in their command-line arguments, so they cannot be mapped reliably by inspecting the process tree alone.

A one-time migration is required after installing the extension:

1. Reload or restart each currently running Pi agent so the extension can record its identity.
2. Save the Neovim session.
3. Verify the registry contains a distinct session ID for every active slot, especially when several slots share one working directory.

Do not infer session IDs merely from modification times; concurrent agents make that ambiguous.

## Implementation boundaries

Likely changes:

- Neovim config: stable slot environment, auto-session save/restore hooks, and terminal recreation.
- New Pi extension: session-to-terminal registration and cleanup.
- Tests or a dry-run command for inspecting the saved mapping.

No tmux-resurrect changes are needed for nested agents. The existing `pi -> pi -c` rule remains useful only for Pi processes running directly in tmux panes.

## Validation plan

1. Start two or more Pi agents in different ToggleTerm slots in the same project.
2. Confirm each slot records a different exact session ID.
3. Start an ordinary shell in another slot and confirm it is not marked as an agent.
4. Save the Neovim session and inspect the persisted mapping.
5. Restart Neovim and verify slot, directory, and exact Pi session restoration.
6. Restore through tmux-continuum after a reboot and repeat the checks.
7. Verify missing projects or deleted Pi sessions fail safely without relaunch loops.

## Open decisions

- Whether Pi state or auto-session extra data is the source of truth.
- Whether restoration should happen automatically or require confirmation when more than one agent is present.
- How to define “active” after a hard reboot, where no normal exit hook runs.
- Whether a slot should retain its mapping after the user exits Pi back to the shell.
