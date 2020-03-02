# Kiosk 

This repo contains tools to build a boot-to-electron disk image using mkosi,
electron, electron-packer, lightdm, openbox, and a few other tools. 

# Building

1. Install virtualbox (hard dep)
2. Install deps
  * node v10.16.0
  * npm 6.9.0
  * mkosi 5
3. `make install`
4. Boot the VM created in VirtualBox

# Licenses 

The code under `viewport/` was generated with (basel-init)[https://github.com/baseljs/basel-app]
and is licensed under `viewport/LICENSE`. All other code in this repository is
licensed under MIT governed by `LICENSE`.
