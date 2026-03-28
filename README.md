# dotfiles / quickshell config

> ⚠️ **Personal configuration** — This is my personal [Quickshell](https://quickshell.outfoxxed.me/) setup. It is tailored to my specific hardware and system, and will likely **not work out of the box** on other devices. Feel free to use it as a reference or starting point, but expect to make adjustments.

---

## Screenshots

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/37057d97-16b0-442d-a093-a99f41c723ed" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/bc39f954-04d6-4c3c-94e4-9b175f504289" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/29ae2a32-ff1e-4762-877e-e900b439e67a" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/f7389565-ed26-427e-9ef4-81ff938eb2b3" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/a858a031-ed8e-48ac-9ce0-bbf67b4dd73e" />



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

Run this command to clone the repo and create a symlink to the config location. 
```
git clone https://github.com/Bxrnenbaum/Malachite-Quickshell/
cd Malachite-Quickshell/
rm -rf ~/.config/quickshell/
ln -s "$(pwd)/quickshell" ~/.config/quickshell
```

Keep in mind that this completely erases the ~/.config/quickshell folder. Make sure to backup existing config files first.

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
