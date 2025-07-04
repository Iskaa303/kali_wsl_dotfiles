# env.nu
#
# Installed by:
# version = "0.104.1"
#
# Previously, environment variables were typically configured in `env.nu`.
# In general, most configuration can and should be performed in `config.nu`
# or one of the autoload directories.
#
# This file is generated for backwards compatibility for now.
# It is loaded before config.nu and login.nu
#
# See https://www.nushell.sh/book/configuration.html
#
# Also see `help config env` for more options.
#
# You can remove these comments if you want or leave
# them for future reference.

$env.PATH = [
  '/usr/local/sbin'
  '/usr/local/bin'
  '/usr/sbin'
  '/usr/bin'
  '/sbin'
  '/bin'
  '/usr/games'
  '/usr/local/games'
  '/usr/lib/wsl/lib'
  '/home/iskaa303/.local/bin'
  '/mnt/c/Users/Iskaa303/AppData/Local/Programs/Microsoft VS Code/bin'
  '/usr/local/cuda-12.9/bin'
  '/mnt/d/localcolabfold/colabfold-conda/bin'
]

$env.BROWSER = '/mnt/c/Program\ Files/LibreWolf/librewolf.exe'
$env.LD_LIBRARY_PATH = '/usr/local/cuda-12.9/lib64'

zoxide init nushell | save -f ~/.zoxide.nu