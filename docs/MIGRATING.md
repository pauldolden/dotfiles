# Migrating an existing setup onto this repo

For a machine that already has a `~/.config` — your own dotfiles, or a fork of
these. The README's runbook assumes a fresh macOS install; this does not.

The end state is that the tracked tree is identical to every other machine
running this repo, and everything that makes your machine yours lives in
untracked `.local` files. After that, "am I in sync?" is a commit SHA
comparison and a fix made anywhere arrives with `git pull`.

## 1. Keep a way back

```bash
cd ~/.config
git status --porcelain                       # commit or stash anything here first
git bundle create ~/dotfiles-old.bundle --all   # full history, offline, restorable
```

A bundle is a single file holding every commit and ref. `git clone
~/dotfiles-old.bundle` restores the lot, so this costs one file and removes any
need to hurry.

## 2. Swap the repo

`~/.config` is live configuration — programs are reading it right now — so move
it aside rather than deleting it. A running process reading a file mid-swap is
the failure this avoids.

```bash
mv ~/.config ~/.config.old
git clone https://github.com/pauldolden/dotfiles.git ~/.config
```

## 3. Carry over what was never tracked

Nothing below is in the repo, on any machine, by design. Take what applies:

| From `~/.config.old/` | Holds |
| --- | --- |
| `git/config.local` | Name, email, signing key **and signing method** |
| `zsh/secrets.zsh` | Anything that must not reach a repo |
| `zsh/aliases.local.zsh` | Projects root, `ZSH_LOCAL_PATH`, per-machine app aliases |
| `zsh/functions.local.zsh` | Employer infrastructure — DB proxies, cluster helpers |
| `zsh/completions.local.zsh` | Anything calling `compdef` (sourced after compinit) |
| `Brewfile.local` | This machine's own packages |
| `mise/conf.d/local.toml` | Version pins a cluster or project forces |
| `theme/palette.local.toml` | Palette slot overrides |
| `ai/claude/settings.json` | Never tracked — Claude Code writes a generated threat model into it |
| `ai/AGENTS.local.md` | Machine-only agent instructions |
| `ai/mcp-servers.local.json` | Machine-only MCP servers |
| `nvim/lazyvim.json`, `nvim/lazy-lock.json` | Your LazyVim extras and their lockfile |
| `gh/` | GitHub auth |
| `bootstrap.local` | `ATUIN_BACKUP_DOC` / `ATUIN_BACKUP_VAULT` |

Anything you have no equivalent for, skip — `bootstrap.sh` seeds it from its
tracked `.example` on the next run.

If you carried MCP servers over, re-render the tool configs:

```bash
python3 ~/.config/ai/sync-mcp.py
```

## 4. Choose your modules

AeroSpace and Hammerspoon are **off by default**. They tile every open window
and remap scroll and mouse buttons globally, and both need an Accessibility
grant — not something a fresh clone should inherit by accident, and not always
yours to give on a managed machine.

```bash
cat > ~/.config/profile.local.toml <<'TOML'
[modules]
aerospace = true
hammerspoon = true
# firefox = false
# containers = false
TOML
```

Omit the file and you get everything except the input stack. See the README's
Modules section for what each one turning off actually means.

## 5. Bootstrap and verify

```bash
~/.config/bootstrap.sh
exec zsh -l
~/.config/doctor.sh
```

`bootstrap.sh` is idempotent — re-run it freely. `doctor.sh` is the one that
matters here: it asserts behaviour rather than file presence, so it catches the
case where config is in place and nothing is reading it.

Expect some failures on a first run. Accessibility grants cannot be scripted —
macOS blocks any process from making them on your behalf, root included — so
`doctor.sh` detects and instructs instead.

## 6. Confirm

```bash
git -C ~/.config log -1 --format=%H
```

Same SHA on two machines means the same tracked tree. That is the whole check.

Once `doctor.sh` is clean, `rm -rf ~/.config.old`. Not before.
