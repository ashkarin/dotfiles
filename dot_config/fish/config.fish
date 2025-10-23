fish_add_path ~/.local/bin
fish_add_path /opt/homebrew/bin
fish_add_path $(mise bin-paths)

# Podman configuration
set -gx BUILDAH_FORMAT docker
set -gx CONTAINER_HOST "unix:///Users/$USER/.local/share/containers/podman/machine/podman.sock"


# Load mise for version management
mise activate fish | source
starship init fish | source

# -- FZF
fzf_configure_bindings --git_log=\cl --git_status=\cg --history=\cr --directory=\cf
