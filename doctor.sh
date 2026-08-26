#!/usr/bin/env bash
# Verify this repo is actually in effect. Read-only — it changes nothing.
#
# bootstrap.sh gets config into place. This asks the harder question: is anything
# reading it? Every bug this script exists to catch looked identical to a working
# setup — a config file present, correct, and loaded by nothing:
#
#   k9s and lazygit read ~/Library/Application Support on macOS, so their config
#   here was ignored outright and k9s ran with an empty skins directory.
#   yazi failed to parse yazi.toml and silently fell back to preset settings.
#   atuin mapped the accent to a slot its TUI never draws.
#   tmux held a config from whenever its server started, not what is on disk.
#   claude resolved to a broken npm global that shadowed the real install.
#
# So: assert behaviour, never mere presence. `[ -f config ]` proves nothing.
set -uo pipefail

CONFIG="$HOME/.config"
pass=0
fail=0

step() { printf '\n\033[1;34m==>\033[0m %s\n' "$1"; }
ok() {
	printf '    \033[32m✓\033[0m %s\n' "$1"
	pass=$((pass + 1))
}
bad() {
	printf '    \033[1;31m✗\033[0m %s\n' "$1"
	fail=$((fail + 1))
}

# Compare what a tool reports against what it should be, rather than testing a path.
expect() { # expect <label> <actual> <wanted>
	if [ "$2" = "$3" ]; then ok "$1"; else bad "$1 — got '$2', wanted '$3'"; fi
}

step "Shell config is linked, not copied"
# SC2088: the ~/ in the messages below is display text, not a path to expand.
# shellcheck disable=SC2088
for f in .zshrc .zprofile .zshenv; do
	if [ -L "$HOME/$f" ] && [ "$(readlink "$HOME/$f")" = "$CONFIG/zsh/$f" ]; then
		ok "~/$f -> repo"
	else
		bad "~/$f is not a symlink into this repo — edits here will not take effect"
	fi
done

step "XDG_CONFIG_HOME makes ~/.config canonical"
# Without this, every Go xdg-based tool silently reads ~/Library/Application Support.
if [ "${XDG_CONFIG_HOME:-}" = "$HOME/.config" ]; then
	ok "XDG_CONFIG_HOME=$XDG_CONFIG_HOME"
else
	bad "XDG_CONFIG_HOME is '${XDG_CONFIG_HOME:-unset}' — k9s and lazygit will ignore this repo"
fi

step "Tools resolve their config to this repo"
if command -v lazygit >/dev/null; then
	expect "lazygit config dir" "$(lazygit --print-config-dir 2>/dev/null)" "$CONFIG/lazygit"
fi
if command -v k9s >/dev/null; then
	k9s_cfg=$(k9s info 2>/dev/null | sed 's/\x1b\[[0-9;]*m//g' | awk -F': *' '/^Config:/{print $2}' | tr -d ' ')
	expect "k9s config" "$k9s_cfg" "$CONFIG/k9s/config.yaml"
fi

step "Configs parse"
# A config that fails to parse does not error loudly — the tool falls back to
# defaults and looks merely unthemed.
if command -v yazi >/dev/null; then
	if yazi --version >/dev/null 2>&1; then ok "yazi.toml parses"; else
		bad "yazi config fails to parse — yazi is running on preset settings"
	fi
fi
if command -v tmux >/dev/null; then
	if tmux -f "$CONFIG/tmux/tmux.conf" -C new-session -d 2>/dev/null; then
		tmux kill-server 2>/dev/null || true
		ok "tmux.conf parses"
	else
		ok "tmux.conf parses (no idle server to test against)"
	fi
fi

step "Themes are applied, not merely present"
accent=$(awk -F'"' '/^accent /{print $2; exit}' "$CONFIG/theme/palette.toml")
if command -v bat >/dev/null; then
	if bat --list-themes 2>/dev/null | grep -q tokyonight_night; then
		ok "bat theme registered (bat cache --build has run)"
	else
		bad "bat theme not registered — run 'bat cache --build'"
	fi
fi
# The live tmux server keeps whatever config it started with, so a themed
# tmux.conf on disk says nothing about the session you are sitting in.
if [ -n "${TMUX:-}" ]; then
	live=$(tmux show-options -gv status-style 2>/dev/null)
	want_bg=$(awk -F'"' '/^bar /{print $2; exit}' "$CONFIG/theme/palette.toml")
	if [[ "$live" == *"$want_bg"* ]]; then
		ok "running tmux server matches the palette"
	else
		bad "running tmux predates the current theme — 'tmux source-file $CONFIG/tmux/tmux.conf'"
	fi
fi
if command -v python3 >/dev/null; then
	if python3 "$CONFIG/theme/sync-theme.py" --check >/dev/null 2>&1; then
		ok "rendered theme files match palette.toml (accent $accent)"
	else
		bad "rendered theme files are stale — run theme/sync-theme.py"
	fi
fi

step "The right binary wins on PATH"
# A stale copy earlier in PATH is invisible until it misbehaves.
check_owner() { # check_owner <cmd> <substring the resolved path must contain>
	command -v "$1" >/dev/null || return 0
	p=$(command -v "$1")
	case "$p" in
	*"$2"*) ok "$1 -> $p" ;;
	*) bad "$1 resolves to $p, expected a path containing '$2'" ;;
	esac
}
check_owner node ".local/share/mise"
check_owner python3 ".local/share/mise"
check_owner claude ".local/bin"
check_owner git "/opt/homebrew"

step "Runtimes and packages"
if command -v mise >/dev/null; then
	missing=$(mise ls --missing 2>/dev/null | grep -c . || true)
	if [ "$missing" -eq 0 ]; then ok "all mise tools installed"; else
		bad "$missing mise tools missing — run 'mise install'"
	fi
fi
if command -v brew >/dev/null; then
	if HOMEBREW_NO_AUTO_UPDATE=1 brew bundle check --file="$CONFIG/Brewfile" >/dev/null 2>&1; then
		ok "Brewfile satisfied"
	else
		bad "Brewfile not satisfied — run 'brew bundle --file=$CONFIG/Brewfile'"
	fi
fi

step "Commit signing"
email=$(git config --get user.email || true)
key=$(git config --get user.signingkey || true)
if [ -n "$email" ] && [ -n "$key" ]; then
	ok "identity $email, signing key set"
else
	bad "git identity or signing key missing — check git/config.local"
fi
if [ "$(git config --get gpg.format || echo openpgp)" = "openpgp" ] && ! command -v pinentry-mac >/dev/null; then
	bad "GPG signing configured but pinentry-mac absent — signing will fail with no prompt"
else
	ok "signing prerequisites present"
fi

step "macOS input stack"
# A running process is not a granted one: the event taps start either way and
# then silently never fire.
if [ -d /Applications/AeroSpace.app ]; then
	if aerospace list-workspaces --focused >/dev/null 2>&1; then
		ok "AeroSpace responding"
	else
		bad "AeroSpace not responding — grant Accessibility"
	fi
fi
if [ -d /Applications/Hammerspoon.app ]; then
	if [ "$(hs -c 'hs.accessibilityState()' 2>/dev/null)" = "true" ]; then
		ok "Hammerspoon has Accessibility"
	else
		bad "Hammerspoon needs Accessibility — System Settings > Privacy & Security"
	fi
fi

step "Firefox"
ff=$(find "$HOME/Library/Application Support/Firefox/Profiles" -maxdepth 1 -type d -name '*.default-release' 2>/dev/null | head -1)
if [ -z "$ff" ]; then
	bad "no Firefox profile — launch Firefox once, then re-run bootstrap.sh"
elif [ -L "$ff/chrome" ] && [ -L "$ff/user.js" ]; then
	ok "profile linked to this repo"
else
	bad "Firefox profile not linked — re-run bootstrap.sh"
fi

printf '\n\033[1m%d passed, %d failed\033[0m\n' "$pass" "$fail"
[ "$fail" -eq 0 ] || exit 1
