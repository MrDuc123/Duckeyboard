# 🦆 Duckeyboard - Custom Keyboard Firmware

This repository contains the configuration and firmware setup for my custom keyboard, **Duckeycat**, using [ZMK Firmware](https://zmk.dev/).

## 🧠 Overview

This repo is structured for use with ZMK and includes keymaps, overlays, and board/shield configurations.

## 🗂️ Directory Structure

```
config/
├── boards/shields/duckeycat/
│   └── duckeycat.conf        # Shield-specific config for Duckeycat
├── duckeycat.keymap          # Custom keymap definition
├── duckeycat.overlay         # Hardware overlay
├── duckeycat.zmk.yml         # Build configuration for ZMK
├── duckeycat.conf            # General config
├── Kconfig.defconfig         # Optional kernel config
├── Kconfig.shield            # Shield-specific Kconfig
├── west.yml                  # Project manifest
```

## 🚀 How to Build

1. **Clone the repo and initialize submodules:**

```bash
git clone https://github.com/YOUR_USERNAME/duckeyboard.git
cd duckeyboard
west init -l config
west update
```

2. **Build firmware:**

```bash
west build -s zmk/app -d build/left -b nice_nano_v2 -- -DSHIELD=duckeycat_left
west build -s zmk/app -d build/right -b nice_nano_v2 -- -DSHIELD=duckeycat_right
```

> Replace `nice_nano_v2` with your actual MCU if different.

3. **Flash the firmware** using `nRF Connect` or `dfu-util`.

## 🎛️ Features

- QWERTY base layer
- Function and media layers
- Layer toggles
- Custom layout with ZMK

## 📦 Requirements

- Python 3.8+
- [West tool](https://docs.zephyrproject.org/latest/develop/west/)
- ARM toolchain (as required by ZMK)
- ZMK source as submodule or linked

## 🛠️ Tips

- Use [ZMK Keymap Editor](https://zmk.dev/docs/tools) for easy layout visualization
- Run `west update` regularly to keep dependencies in sync

## 📜 License

MIT License or your preferred open-source license.
