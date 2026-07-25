# Anne Pro 2 Tools

This is an alternative firmware update tool for the Anne Pro 2. It can update
the main, LED, and BLE MCUs through the keyboard's USB IAP firmware.

Please put the keyboard into IAP mode by holding down `esc` while
plugging it in to the computer before running this tool.

## Safety behavior

The tool reads the IAP layout reported by the keyboard before erasing anything.
An explicit `--base` is accepted only when it matches that device-reported
address. It also validates the target's IAP mode, matches each reply to the
target/command/key that produced it, aborts on non-zero status or timeout, and
returns a non-zero process exit status on failure.

The protocol does not currently provide a verified readback path. A successful
transfer therefore proves that every erase/write request received a success
status, not that flash contents were independently read back and compared.

Read the layout and target modes without writing:

```bash
./target/release/annepro2_tools --probe
```

## Build

```bash
cargo build --release
```

Flash a main-MCU image and leave the keyboard in IAP:

```bash
./target/release/annepro2_tools a.bin
```

Flash a BLE image, then restart the keyboard:

```bash
./target/release/annepro2_tools --target ble --boot ble.bin
```

Supported target names are `main`/`key`, `led`, and `ble`. Do not supply
`--base` during normal use; the value is discovered from IAP. The option exists
for diagnostics and refuses mismatches.

## Nix flake support

For development, run `nix-shell` or `nix develop`.

The flake can also run the tool directly:

```shell
nix run github:OpenAnnePro/AnnePro2-Tools annepro2_tools -- --help
nix run github:OpenAnnePro/AnnePro2-Tools/master annepro2_tools -- --help
nix run github:OpenAnnePro/AnnePro2-Tools annepro2_tools --boot fw.bin
```
