# macOS-native config paths defeat this repo for any tool built on the Go xdg
# library: k9s and lazygit both read ~/Library/Application Support/<tool> unless
# this is set, so their config and skins here were being ignored outright — k9s
# ran unthemed with an empty skins dir. Declaring it makes ~/.config canonical
# for every such tool, present and future.
export XDG_CONFIG_HOME="$HOME/.config"

# Projects live directly at ~/dev/<project>, so depth 1 finds them all.
export FZF_DEPTH=1

# TMPDIR is redirected out of /var/folders so its contents survive macOS's
# periodic sweep of the system temp dir.
export TMPDIR="$HOME/.cache/tmp"
mkdir -p "$TMPDIR"

# Derived from TMPDIR — never hardcode the path. podman names the socket after
# the machine, so "podman-machine-default" here is the machine name and not a
# generic suffix: rename the machine and this points at a socket that never
# appears, with no error from anything that reads it.
# ${TMPDIR%/} normalises the trailing slash, which differs between the system
# TMPDIR (/var/folders/.../T/, trailing) and the override above (no trailing).
export DOCKER_HOST="unix://${TMPDIR%/}/podman/podman-machine-default-api.sock"
