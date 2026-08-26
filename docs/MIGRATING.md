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

### If your old setup predates the `.local` layer

Then none of those files exist in `~/.config.old`, and the table above will
carry over nothing while appearing to work. Your machine-specific content is
sitting **inside the tracked files** — which the clone in step 2 replaced.

This is the case for any fork of this repo made before the split, and it is the
one way to lose real work here. Read the old tracked files and extract, before
`~/.config.old` goes anywhere:

| Look in `~/.config.old/` | Extract to | Looking for |
| --- | --- | --- |
| `zsh/functions.zsh` | `zsh/functions.local.zsh` | Functions naming an employer project, cluster, port or namespace |
| `zsh/aliases.zsh` | `zsh/aliases.local.zsh` | `proj`, app-focus aliases, anything rooted outside the repo |
| `zsh/.zshrc` | `zsh/completions.local.zsh` | Generated completion blocks — tools whose installer appends to the rc file |
| `zsh/exports.zsh` | `zsh/aliases.local.zsh` | Extra PATH entries → `ZSH_LOCAL_PATH` |
| `mise/config.toml` | `mise/conf.d/local.toml` | Version pins a cluster forces, rather than current stable |
| `Brewfile` | `Brewfile.local` | Taps and formulae only this machine needs |
| `ai/AGENTS.md` | `ai/AGENTS.local.md` | Sections about one employer's codebases |
| `ai/mcp-servers.json` | `ai/mcp-servers.local.json` | Servers pointing at internal endpoints |

A useful diff to drive this:

```bash
diff -r --exclude=.git ~/.config.old ~/.config | less
```

Everything it reports that is true of *this machine only* belongs in a `.local`
file. Everything true of *every* machine is either already upstream or worth a
pull request.

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

---

## Appendix: what a complete overlay looks like

A worked example, from the second machine this repo was split for. Placeholders
stand in for the real project, cluster and organisation names — that machine's
actual overlay stays on that machine, which is the point of the layer.

Reading it top to bottom shows the rule: **nothing here names a thing that is
true of more than one machine.**

`zsh/aliases.local.zsh`

```zsh
## Extra PATH entries, consumed by the path+= block in .zshrc.
ZSH_LOCAL_PATH=($HOME/bin)

alias proj='cd ~/dev/work/'

## Apps in this machine's daily loop
alias wt='wo "Microsoft Teams"'
alias wd='wo TablePlus'
```

`zsh/functions.local.zsh` — employer infrastructure, the clearest case for the
layer. Nothing below means anything on another machine.

```zsh
function dbp() {
  case $1 in
    dev)  PORT=6003 ;;
    uat)  PORT=6004 ;;
    prod) PORT=6005 ;;
    *)    echo "Unknown stage"; return 1 ;;
  esac
  cloud-sql-proxy <project>-"$1":<region>:<instance> --port "$PORT"
}

function get_pod_logs() {
  [ -z "$1" ] && { echo "Please provide a pod name filter."; return 1; }
  kubectl get pods -n <namespace> | grep "$1" | awk '{print $1}' |
    xargs -I {} kubectl logs -n <namespace> {}
}
```

`zsh/completions.local.zsh` — separate from the above because it is sourced
after `compinit`. A `compdef` call in `functions.local.zsh` is silently skipped,
which looks exactly like a completion that does not work.

```zsh
if type compdef &>/dev/null; then
  # generated completion blocks go here
fi
```

`mise/conf.d/local.toml`

```toml
[tools]
# One minor either side of the cluster, not latest.
kubectl = "1.36"
# Upstream still tags v1 as latest, and v1 takes different flags.
cloud-sql-proxy = "2"
```

`Brewfile.local`

```ruby
tap "fluxcd/tap"
brew "libpq"
```

`profile.local.toml` — the input stack is off by default; a managed machine may
not be able to grant Accessibility at all.

```toml
[modules]
# aerospace = true
# hammerspoon = true
```

`ai/mcp-servers.local.json` — secrets stay as `op://` references, resolved at
run time. A literal credential never belongs here, tracked or not.

```json
{
  "servers": {
    "sonarqube": {
      "targets": ["claude"],
      "type": "stdio",
      "command": "op",
      "env": { "SONARQUBE_TOKEN": "op://<vault>/<item>/credential" }
    }
  }
}
```

`ai/AGENTS.local.md` — instructions true of one employer's codebases only:
compliance rules, internal service names, house conventions.

`git/config.local` — identity, and the signing *method*, which differs by
machine: GPG on one, an SSH key held by the 1Password agent on another.

```gitconfig
[user]
	name = Your Name
	email = you@example.com
	signingkey = ssh-ed25519 AAAA...
[gpg]
	format = ssh
[gpg "ssh"]
	program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
	allowedSignersFile = ~/.config/git/allowed_signers
```
