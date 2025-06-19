# Nushell Environment Setup for Kali WSL

This project sets up a modern terminal environment using:

- [Nushell](https://www.nushell.sh/)
- [Starship](https://starship.rs/)
- [Zoxide](https://github.com/ajeetdsouza/zoxide)
- [bat](https://github.com/sharkdp/bat)
- [eza](https://github.com/eza-community/eza)
- [fish](https://fishshell.com/)

It works for both the current user and root in Kali Linux WSL.

---

## 🔧 Installation

To install everything (packages, Nushell, Starship, config files, and shell defaults), run:

```bash
chmod +x install.sh
./install.sh
```

## 🔄 Updating Configs

If you've made changes to env.nu, config.nu, or starship.toml, update the configs by:

```bash
chmod +x update_cfgs.sh
./update_cfgs.sh
```