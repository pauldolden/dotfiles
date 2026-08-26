# dotfiles

macOS (Apple Silicon), zsh, Ghostty, Neovim, Firefox. Everything is themed from
one palette — the terminal stack and the browser both.

One repo, many machines. The tracked tree is identical everywhere; everything
that differs — identity, signing method, projects root, employer tooling,
package set — lives in untracked `.local` files that the bootstrap seeds. So
"are these machines in sync?" is answerable by comparing one commit SHA, and a
fix made on any of them reaches the rest with `git pull`.

---

## New machine runbook

### Phase 1 — The unlock chain

Order is load-bearing. Each step gates the next.

| # | Step | Unlocks |
|---|------|---------|
| 1 | macOS setup, Apple ID, **FileVault on** | — |
| 2 | 1Password + browser extension; restore `~/.gnupg` from backup | Commit signing |
| 3 | `xcode-select --install` | git, compilers, iOS builds |
| 4 | Homebrew | everything below |
| 5 | `git clone git@github.com:pauldolden/dotfiles.git ~/.config` | shell, nvim, ghostty |

```bash
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
git clone git@github.com:pauldolden/dotfiles.git ~/.config
```

> **Gotcha:** commits are signed with a GPG key that is **not** in this repo and
> **not** in 1Password's SSH agent. Restore `~/.gnupg` before your first commit
> or signing fails. `~/.gnupg/gpg-agent.conf` names `pinentry-mac` by absolute
> path, so the Brewfile installs it — without it GPG has no way to prompt and
> signing fails with no visible error.

### Phase 2 — Run the bootstrap

```bash
~/.config/bootstrap.sh
```

> Everything machine-specific lives in untracked files, each seeded from a
> tracked `.example` sibling on first run. The bootstrap derives that list from
> the `.example` files themselves, so adding one needs no edit to the script.
>
> | File | Holds |
> |------|-------|
> | `git/config.local` | `user.name`, `user.email`, `user.signingkey` **and the signing method** — included last by `git/config` |
> | `bootstrap.local` | `ATUIN_BACKUP_DOC` / `ATUIN_BACKUP_VAULT` for shell-history restore |
> | `zsh/aliases.local.zsh` | Projects root, `ZSH_LOCAL_PATH`, per-machine app aliases |
> | `zsh/functions.local.zsh` | Employer infrastructure — DB proxies, cluster helpers |
> | `zsh/secrets.zsh` | Anything that must not reach the repo |
> | `Brewfile.local` | One machine's toolchain, installed after the shared Brewfile |
> | `mise/conf.d/local.toml` | Version pins a cluster or project forces |
> | `theme/palette.local.toml` | Slot overrides, so one machine can retune without forking the palette |
> | `profile.local.toml` | Which modules this machine runs — see below |
> | `ai/claude/settings.json` | Claude Code writes a generated threat model back into this file — never tracked |
>
> Signing method lives in `config.local` rather than the tracked `git/config`
> because machines differ: GPG on one, an SSH key held by the 1Password agent on
> another. Same reason as the rest of the table — the tracked file stays true
> everywhere.
>
> `gh/hosts.yml` is untracked too — run `gh auth login` to write your own.

Idempotent, so re-run it any time — the `bootstrap` alias runs it and reloads the
shell in one go, which is the normal way to pick up a change to this repo. It
installs the Brewfile (CLI tools, casks and the **Nerd Font** — without which
every glyph renders as tofu), links shell and agent config into `$HOME`, wires
the git hooks, applies the macOS defaults the input stack depends on, symlinks
the Firefox profile config and installs its add-on policies, installs runtimes
via mise, builds the bat theme cache, brings up the podman machine, wires the
docker compose plugin, renders the MCP configs, and restores atuin history from
1Password if it isn't already there.

Phase 1 is deliberately not scripted — the 1Password GUI and Xcode CLT are both
interactive.

> **Gotcha:** Homebrew's `podman` formula ships `gvproxy` and `vfkit` but **not**
> `krunkit`, and podman defaults to the `libkrun` provider on Apple Silicon — so a
> CLI-only install dies at `podman machine start` with *"There is a problem finding
> the 'krunkit' binary"*. The Brewfile pins the `libkrun/krun` tap and trusts its
> formulae, so the bootstrap covers it.

### Phase 3 — First launches

```bash
exec zsh -l
```

- `nvim` — LazyVim installs plugins, then `:Mason` for LSPs (slowest step, start it early)
- `tmux` — tpm self-bootstraps and installs plugins on first run
- `zsh/fzf-tab/` is an upstream clone, gitignored, cloned by `.zshrc` on first run
- **Firefox** — launch once so the profile exists, then **re-run the bootstrap** to
  symlink `user.js` and `chrome/` into it. Sidebery installs itself on that
  first launch via `firefox/policies.json`.
- **Sidebery** — import `firefox/sidebery-settings.json` (settings > Help > Import), and
  paste `firefox/sidebery/pinknight.css` into settings > Styles editor > Sidebar.

> **Gotcha:** the Firefox profile directory carries a random prefix, so it is the one
> destination in this repo that cannot be declared — the bootstrap discovers
> `*.default-release` instead. A machine that has never launched Firefox has no profile
> to link into, which is why the browser needs the bootstrap run twice on a rebuild.

See `docs/BROWSER.md` for why Firefox replaced Arc.
- **Hammerspoon** — grant Accessibility. The event taps start regardless and then
  silently never fire without it, so a running Hammerspoon is not a working one.
- **AeroSpace** — grant Accessibility. It tiles every open window the moment it launches.
- **Log out and back in** once, for `spans-displays` (see `macos/defaults.sh`).

See `docs/MACOS_INPUT.md` for why these replaced Mos and BetterTouchTool, and
`KEYBINDINGS.md` for every binding in one place — AeroSpace's are the ones you will not
guess, since the workspace row sits on `cmd-alt` to keep Option+3 free for `#`.

**Sign into 1Password CLI (`op signin`) before the bootstrap** if you want atuin history
restored automatically — the script skips that step when `op` isn't authenticated, and
restoring after atuin has created an empty db is messier.

### Phase 4 — Accounts

```bash
gh auth login
gcloud init          # only if a project needs it
corepack enable      # yarn/pnpm shims, once
```

---

## Layout

| Path | What |
| --- | --- |
| `zsh/` | `.zshrc`, `.zprofile`, `.zshenv`, aliases, exports, functions |
| `nvim/` | LazyVim |
| `ghostty/`, `tmux/` | Terminal + multiplexer |
| `starship.toml` | Prompt |
| `git/hooks/` | Global hooks — enabled via `core.hooksPath` |
| `mise/` | Runtime versions and most CLI tooling |
| `bat/`, `btop/`, `yazi/`, `k9s/`, `lazygit/` | Tool configs + themes |
| `theme/` | Canonical palette + renderer for every themed config |
| `firefox/` | Prefs, policies and chrome CSS — symlinked into the profile by the bootstrap |
| `aerospace/` | Tiling WM — read from `~/.config` natively, no symlink |
| `hammerspoon/` | Scroll direction + mouse buttons — `init.lua` symlinked into `~/.hammerspoon` |
| `macos/` | System `defaults` the input config depends on |
| `docs/` | Decision records — why the browser and input stack are what they are |
| `KEYBINDINGS.md` | Cheatsheet for every tool's bindings — nvim, tmux, AeroSpace, shell |

## Modules

`profile.toml` declares what a machine runs. A module that is off skips its
bootstrap steps rather than configuring something nothing will read — which
matters because this repo *is* `~/.config`, so a rendered config is read by its
app the moment that app exists, whether or not you wanted it.

| Module | Off means |
| --- | --- |
| `aerospace` | Not started, not checked |
| `hammerspoon` | `~/.hammerspoon/init.lua` not linked, not started |
| `firefox` | No profile discovery, no policies written into the app bundle |
| `containers` | podman machine not initialised, compose plugin not wired |
| `rust` | rustup not installed — `mise install` cannot build rust |

Everything defaults on, and an **unknown name is treated as on**, so a profile
written before a module existed still gets it. Override per machine in an
untracked `profile.local.toml`; never edit `profile.toml` to turn something off
for one machine, or every other machine inherits the decision.

Turning a module off does not uninstall its packages — the Brewfile is a flat
list with no notion of which package belongs to which module. That is tracked
separately.

## Conventions

- **Work on `main`.** The working tree *is* the live config directory, so `git switch`
  does not merely change what you are editing — it creates and deletes files that
  running programs are reading. Feature branches are a trap in this repo; commit to `main`.
- **Runtimes and CLI tooling** via `mise`, not nvm/asdf/rustup or a manual Go install.
  `mise/config.toml` declares node, python, go, rust and bun alongside the CLI tools;
  `mise install` provisions the lot. Per-project overrides via `.mise.toml`.
- **The Brewfile keeps what mise cannot.** System libraries (`libpq`, `poppler`,
  `gstreamer`, `pkgconf`), zsh plugins that are sourced from brew's `share/`, podman and
  `krunkit`, the hook and daemon tools (`atuin`, `direnv`, `betterleaks`), `mise` itself,
  `pinentry-mac` (named by absolute path in `gpg-agent.conf`), and `btop`, whose mise
  package is Linux-only.
- **Do not run `brew bundle cleanup --force`** without reading the list first. The
  bootstrap reports the drift instead of acting on it.
- **Per-project env** via `direnv`.
- **Secrets never land in this repo.** `betterleaks` runs as a global pre-commit hook.
  Bypass with `--no-verify` only for confirmed false positives.
- **Machine-local state** (`gcloud/`, `raycast/`, `github-copilot/`, `1Password/`) is gitignored.
- `DOCKER_HOST` derives from `$TMPDIR` — never hardcode the path. `$TMPDIR` is itself
  redirected to `~/.cache/tmp` in `zsh/exports.zsh` so its contents survive macOS's
  sweep of `/var/folders`, and the derivation normalises the trailing slash because the
  system value has one and the override does not. The socket is named after the podman
  machine (`podman-machine-default-api.sock`), so renaming the machine breaks it silently.

## Projects

`~/dev` is flat: every project is a direct child, so `FZF_DEPTH=1` finds all of
them and `fp` / `tmux-sessionizer` need no per-tree tuning. Git worktrees sit
beside their repo as siblings (`repo`, `repo-<feature>`), which the flat layout
accommodates for free. The root itself is machine-local — `proj` and
`ZSH_LOCAL_PATH` both come from `zsh/aliases.local.zsh`.

## AI tooling

One instruction file, one MCP source of truth, no tokens on disk.

| Path | What |
| --- | --- |
| `ai/AGENTS.md` | Single instruction file. `~/AGENTS.md` and `~/CLAUDE.md` both symlink to it |
| `ai/mcp-servers.json` | Canonical MCP server definitions — 1Password `op://` refs, no literal secrets |
| `ai/sync-mcp.py` | Renders the tool-specific configs from canonical |
| `ai/claude/settings.json` | Claude Code plugins + permissions |
| `ai/skills/` | Hand-written Claude skills. Symlink each into `~/.claude/skills/` |

```bash
python3 ~/.config/ai/sync-mcp.py     # after editing mcp-servers.json
```

Writes `~/.claude.json` (merged in place — it is a mutable state file, and only its
global `mcpServers` key is replaced, so project-scoped servers survive) and
`~/.copilot/mcp-config.json` (overwritten).

**`docker` is a real binary, not an alias.** It used to be `alias docker=podman`, which
broke MCP servers — they spawn without a shell, so the alias did not exist and the
command silently failed. The `docker` formula plus `DOCKER_HOST` pointing at podman's
socket fixes that: every caller resolves it, shell or not. Podman is still what runs
the containers.

## Theming

One palette, 18 configs, no hand-edited hex — browser chrome included.

| Path | What |
| --- | --- |
| `theme/palette.toml` | Canonical source — semantic slots, contrast floors, upstream hex map |
| `theme/sync-theme.py` | Renders every themed config from the palette |
| `theme/templates/` | Files this repo authors — `{{slot}}` placeholders |
| `theme/upstream/` | Vendored theme files — hex literals rewritten through `[source]` |

```bash
python3 ~/.config/theme/sync-theme.py           # after editing palette.toml
python3 ~/.config/theme/sync-theme.py --check   # fail if rendered output is stale
```

The path under `templates/` or `upstream/` **is** the destination relative to
`~/.config`, so adding a file needs no registration in the script.

- **Slots are roles, not colours.** `accent`, `bg`, `err` — never `pink`. Changing a
  slot's value rethemes everything; renaming its key means editing every consumer again.
- **Semantic slots stay legible.** btop's temperature gradient, lazygit's diffs and
  atuin's alerts encode meaning in hue. A theme's identity belongs in chrome
  (`bar`, `panel`, `accent`), not in `ok`/`warn`/`err`.
- **Contrast is enforced.** `[[contrast]]` pairs are asserted on every render and the
  run aborts below the floor, so a retune cannot ship unreadable chrome.
- **Machine overrides.** An untracked `theme/palette.local.toml` overrides individual
  slots, so this machine can drift from the work one without forking the palette.
- Rendered files are committed, so a fresh clone is themed before bootstrap runs.
  **Edit the template or the palette, never the rendered file.**

`bat` caches its themes — run `bat cache --build` after a palette change.

## Not managed here

Not reproducible from this repo — carry these by hand when moving machines:

| Path | Why |
| --- | --- |
| `~/.local/share/atuin/` | Shell history + encryption key. Stored as a 1Password document |
| `~/.gnupg` | GPG keys — these sign every commit, and nothing else has a copy |
| Anything under a machine-local root | Notes vaults, manuscripts, scratch trees — named only in `.local` files |

`~/.gitconfig` is now `git/config` in this repo, read natively by git via XDG. A
leftover `~/.gitconfig` **overrides** the XDG file for any single-valued key, so
it is moved aside rather than left in place.
