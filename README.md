# A.Villegas Working Environment

This repository contains my personal working environment configuration.
It is intended to bootstrap a complete, opinionated, and reproducible Linux setup focused on productivity and development.

This project exists to centralize and automate the installation of my dotfiles and related configuration in a **modular**, **maintainable**, and **explicit** way.

---

## Overview

The goal of this repository is to provide a clean and predictable way to deploy my working environment across systems, without manual tweaking or hidden side effects.

The setup reflects how I work daily and evolves alongside my workflow.

---

## Installation

Clone the repository and run the installer:

```sh
git clone https://github.com/r2dedios/my_environment.git ~/.villegas
cd ~/.villegas
# The install script requires sudo permissions in case you want to install
packages
sudo bash ./install.sh

# Enjoy :)
```

The installer guides you through the setup process and allows you to select which components should be installed.

The script is designed to be re-runnable without breaking existing configurations.

---

## Design Principles

- Explicit over implicit
- No silent overwrites
- No destructive actions without confirmation
- Readable configuration files
- Minimal magic

This repository prioritizes clarity and maintainability over cleverness.

---

## Disclaimer

This is an opinionated setup tailored to my personal workflow.
It is shared publicly for reference, inspiration, or reuse.

Feel free to fork it or adapt parts of it to your own environment.

---

## License

GPL-3.0 License: The GPL-3.0 license allows users to freely use, modify, and redistribute the software, but requires that any distributed derivative work remains open source under the same license and does not impose additional restrictions.
