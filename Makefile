# Makefile for managing chezmoi configuration
# ============================================
.DEFAULT_GOAL := help

SHELL := /bin/bash
TIMESTAMP := $(shell date -u +"%Y-%m-%dT%H-%M-%S")
CONFIG_DIR := $(HOME)/.config
BACKUP_DIR := $(CONFIG_DIR).$(TIMESTAMP)
CHEZMOI := $(shell command -v chezmoi 2>/dev/null || echo "")

# --------------------------------------------
# uninstall: Safely remove chezmoi setup
# --------------------------------------------
uninstall:
ifeq ($(CHEZMOI),)
	@echo "❌ chezmoi not found. Aborting uninstall."
	exit 1
else
	@echo "✅ chezmoi found at $(CHEZMOI)"
	@echo "🧹 Running chezmoi purge..."
	chezmoi purge
endif
	@echo "📦 Backing up ~/.config to $(BACKUP_DIR)"
	@if [ -d "$(CONFIG_DIR)" ]; then mv "$(CONFIG_DIR)" "$(BACKUP_DIR)"; fi
	@echo "🔁 Setting default shell to bash"
	@chsh -s /bin/bash $$(whoami) || echo "⚠️  Could not change shell automatically (may require sudo)."
	@echo "✅ Uninstall complete."

# --------------------------------------------
# install-remote: run setup script
# --------------------------------------------
install-remote:
	@echo "⚙️  Running .setup.sh..."
	@chmod +x ./.setup.sh
	./.setup.sh
	@echo "✅ Remote install complete."

# --------------------------------------------
# install-local: apply local chezmoi source
# --------------------------------------------
install-local:
ifeq ($(CHEZMOI),)
	@echo "❌ chezmoi not found. Please install chezmoi first."
	exit 1
else
	@echo "📂 Applying local chezmoi configuration..."
	chezmoi apply --source .
	@echo "✅ Local install complete."
endif

# --------------------------------------------
# clean-cache: clear chezmoi script state
# --------------------------------------------
clean-cache:
ifeq ($(CHEZMOI),)
	@echo "❌ chezmoi not found. Cannot clean cache."
	exit 1
else
	@echo "🧽 Cleaning chezmoi scriptState cache..."
	chezmoi state delete-bucket --bucket=scriptState
	@echo "✅ Cache cleaned."
endif

# --------------------------------------------
# help: display available targets
# --------------------------------------------
help:
	@echo "Makefile for chezmoi configuration"
	@echo
	@echo "Available targets:"
	@echo "  uninstall       - Remove chezmoi config, backup ~/.config, reset shell to bash"
	@echo "  install-remote  - Run .setup.sh installer"
	@echo "  install-local   - Apply chezmoi config from local source"
	@echo "  clean-cache     - Clear chezmoi scriptState cache"
	@echo "  help            - Show this help message"
