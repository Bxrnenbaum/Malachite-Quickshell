# dotfiles / quickshell config

> ⚠️ **Personal configuration** — This is my personal [Quickshell](https://quickshell.outfoxxed.me/) setup. It is tailored to my specific hardware and system, and will likely **not work out of the box** on other devices. Feel free to use it as a reference or starting point, but expect to make adjustments.

---

## Requirements

> Only tested on EndeavourOS and Hyprland. other distros should work the same. This config is specifically tailored to be used with Hyprland.

- Hyprland
- Quickshell
- PipeWire
- wl-clipboard
- cliphist (following lines are needed in hyprland.conf for cliphist to work properly)
    ```
    exec-once = wl-paste --type text --watch cliphist store
    exec-once = wl-paste --image --watch cliphist store
    ```

## Installation

clone the repository and put the quickshell folder inside .config

## Configuration

Colors aswell as the font can be changed in Theme.qml.

---

## Contributing

Contributions are very welcome! Whether it's a bug fix, a quality-of-life improvement, or a new feature — feel free to open a pull request.

Please follow [Conventional Commits](https://www.conventionalcommits.org/) when writing commit messages.

Common types: `feat`, `fix`, `refactor`, `style`, `chore`, `docs`, `perf`, `test`

---

## License

This project is licensed under the GNU General Public License v3.0 — see [LICENSE](LICENSE) for details.


## Attributions

Icons by [Dazzle UI](https://dazzleui.gumroad.com/l/dazzleiconsfree?ref=svgrepo.com), sourced via [SVG Repo](https://svgrepo.com) — [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)
JetBrains Mono font by [JetBrains](https://www.jetbrains.com/legalnotice/) — [SIL Open Font License 1.1](https://scripts.sil.org/OFL)
