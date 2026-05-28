# ─────────────────────────────────────────────────────────────────────────────
# YUBIKEY (FIDO2 / U2F) — sudo, login, screen unlock, polkit
#
# POLICY: touch required, sufficient alone. Tap the key = authenticated.
# Password fallback still works (control = "sufficient") so you can't lock
# yourself out before keys are enrolled. Switch `control` to "required"
# below if you want NO password fallback (more secure, more brittle).
#
# ─── ENROLLMENT (do this ONCE per machine, AFTER first nixos-rebuild) ───────
#
# You have two YubiKeys (primary + backup). Enroll BOTH before you trust
# this — losing your only key locks you out everywhere.
#
# CRITICAL: pam_u2f file format puts ALL keys for one user on ONE line,
# colon-separated. The naive `pamu2fcfg | tee -a` approach produces TWO
# LINES which pam_u2f silently ignores. Use the variable-capture pattern
# below to keep both keys on the same line.
#
#   # 1. Ensure the directory exists
#   sudo mkdir -p /etc/Yubico
#
#   # 2. Plug in YubiKey #1 only — emits full line: `architect:<keydata1>`
#   LINE1=$(pamu2fcfg -u architect)
#
#   # 3. UNPLUG #1, plug in YubiKey #2 — `-n` emits `:<keydata2>` (no user)
#   KEY2=$(pamu2fcfg -n)
#
#   # 4. Write both onto the same line
#   echo "${LINE1}${KEY2}" | sudo tee /etc/Yubico/u2f_keys
#
#   # 5. Verify: one line, starts with `architect:`, then two colon-blocks
#   sudo cat /etc/Yubico/u2f_keys
#
#   # 6. Test in a NEW terminal (keep this one open as escape hatch!):
#   #    `sudo -k && sudo whoami`  → should prompt for touch
#   #    If it falls through to a password prompt, u2f didn't match —
#   #    debug here before logging out.
#
# COMMIT the u2f_keys file? NO. It's bound to specific device keypairs
# and to /etc/. It lives outside the flake. The flake turns on the
# machinery; the per-machine enrollment file proves "this key belongs here".
#
# ─── RECOVERY ESCAPE HATCHES ────────────────────────────────────────────────
# If both keys are lost or u2f auth is broken:
#   - Boot to single-user (systemd.unit=rescue.target on kernel cmdline)
#   - Or boot a NixOS live USB, chroot in, delete /etc/Yubico/u2f_keys
#   - Or use the password fallback (because control = "sufficient")
# ─────────────────────────────────────────────────────────────────────────────

{ config, lib, pkgs, ... }:

{
  # pcscd — smart-card daemon. Needed for the YubiKey to be enumerated
  # as a CCID device (for GPG, PIV, OpenPGP applets). FIDO2 alone doesn't
  # strictly need it, but you'll want it for full key functionality.
  services.pcscd.enable = true;

  # udev rules so user-space tools can talk to the key without root.
  services.udev.packages = with pkgs; [
    yubikey-personalization
    libfido2
  ];

  # PAM U2F module — enables FIDO2 challenge/response auth.
  security.pam.u2f = {
    enable = true;
    settings = {
      cue = true;                                # show "Please touch the device"
      authfile = "/etc/Yubico/u2f_keys";         # system-wide enrollment
    };
    control = "sufficient";                      # see header for "required" alt
  };

  # Apply to the services we actually want to gate behind the key.
  # Each `u2fAuth = true` inserts a `pam_u2f.so` line into that service's
  # PAM stack with the control mode above.
  security.pam.services = {
    sudo.u2fAuth = true;
    login.u2fAuth = true;
    sddm.u2fAuth = true;
    hyprlock.u2fAuth = true;
    polkit-1.u2fAuth = true;
    # ssh deliberately NOT included — for SSH, use the FIDO2-backed
    # `id_ed25519_sk` keys you already have in ~/.ssh/, which is a
    # cleaner mechanism than PAM-u2f over a remote login.
  };

  # CLI tools for managing keys, viewing slots, configuring PIV/OpenPGP/etc.
  environment.systemPackages = with pkgs; [
    yubikey-manager                              # `ykman` — main CLI
    yubikey-manager-qt                           # GUI for the same
    yubikey-personalization                      # `ykpersonalize` — OTP/HOTP
    pam_u2f                                      # provides `pamu2fcfg`
    libfido2                                     # `fido2-token`, low-level FIDO2
    age-plugin-yubikey                           # age encryption backed by YK
  ];

  # GPG agent with SSH support — if you use OpenPGP smartcard mode on the
  # key for git signing or as an SSH key source, this is the way.
  # (Independent of FIDO2/U2F above.)
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = lib.mkDefault true;
  };
}
