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
#   # 1. Plug in YubiKey #1 only
#   pamu2fcfg -u architect | sudo tee    /etc/Yubico/u2f_keys
#
#   # 2. UNPLUG #1, plug in YubiKey #2
#   pamu2fcfg -n           | sudo tee -a /etc/Yubico/u2f_keys
#   # (-n appends without re-emitting the username; same line, second key)
#
#   # 3. Verify the file has both keys on one line for `architect`
#   sudo cat /etc/Yubico/u2f_keys
#
#   # 4. Test: open a new terminal and run `sudo -k && sudo whoami`
#   #    You should be prompted to touch the key. If it falls through to
#   #    password, the u2f line didn't match — debug before logging out.
#
# COMMIT the u2f_keys file? NO. It's bound to specific device keypairs
# and to /etc/. It lives outside the flake. The flake just turns on the
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
