# [hacktheegg@Thinkpad-T460:~/Downloads]$ run0 ./become-ageless.sh --dry-run --flagrant --persistent
#
# PLANNED ACTIONS
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#
#   The following changes will be made to this system:
#
#    1. Back up /etc/os-release -> /etc/os-release.pre-ageless
#    2. Rewrite /etc/os-release as Ageless Linux 0.1.1    # done
#    3. Back up /etc/lsb-release -> /etc/lsb-release.pre-ageless
#    4. Rewrite /etc/lsb-release as Ageless Linux 0.1.1    # done
#    5. Create /etc/ageless/ab1043-compliance.txt (flagrant)    # done
#    6. Create /etc/ageless/REFUSAL (machine-readable refusal)    # done
#
#   Skipping userdb neutralization (systemd-userdbd not present)
#
#    7. Install /etc/ageless/agelessd (neutralization script)    # INCOMPLETE
#    8. Install agelessd.service and agelessd.timer (24h enforcement)    # INCOMPLETE
#    9. Write /etc/agelesslinux.conf (installation record) # INCOMPLETE
#
#   To revert all changes later:
#     sudo become-ageless.sh --revert
#
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━



# https://agelesslinux.github.io/age-reporting/distro-specific.html #
{ lib, ... }:

{

  environment.etc = {

    ## os-release ##
    "os-release".text = lib.mkForce ''
      PRETTY_NAME="Ageless Linux 0.1.1 (NixOS 26.05)"
      NAME="Ageless Linux"
      VERSION_ID="0.1.1"
      VERSION="0.1.1 (Timeless)"
      VERSION_CODENAME="timeless"
      ID="ageless"
      ID_LIKE="nixos"
      HOME_URL="https://agelesslinux.org"
      SUPPORT_URL="https://agelesslinux.org"
      BUG_REPORT_URL="https://agelesslinux.org"
      AGELESS_BASE_DISTRO="NixOS"
      AGELESS_BASE_VERSION="26.05"
      AGELESS_BASE_ID="nixos"
      AGELESS_AB1043_COMPLIANCE="refused"
      AGELESS_AGE_VERIFICATION_API="not implemented"
      AGELESS_AGE_VERIFICATION_STATUS="intentionally noncompliant"
    '';
    ## os-release ##
    ## lsb-release ##
    "lsb-release".text = lib.mkForce ''
      DISTRIB_ID="Ageless"
      DISTRIB_RELEASE="0.1.1"
      DISTRIB_CODENAME="timeless"
      DISTRIB_DESCRIPTION="Ageless Linux 0.1.1 (Timeless)"
    '';
    ## lsb-release ##
    ## compliance document ##
    "ageless/ab1043-compliance.txt" = lib.mkForce ''
      ═══════════════════════════════════════════════════════════════════════
        AGELESS LINUX — AB 1043 COMPLIANCE STATEMENT (FLAGRANT MODE)
      ═══════════════════════════════════════════════════════════════════════

        This operating system is distributed by an operating system provider
        as defined by California Civil Code § 1798.500(g).

        Status of compliance with the Digital Age Assurance Act (AB 1043):

        § 1798.501(a)(1) — Accessible interface for age collection .. REFUSED
        § 1798.501(a)(2) — Real-time API for age bracket signals .... REFUSED
        § 1798.501(a)(3) — Data minimization ........................ REFUSED

        No age verification API is installed on this system. No stub, no
        placeholder, no skeleton, no interface of any kind. No mechanism
        exists on this system by which any application developer could
        request or receive an age bracket signal, now or in the future.

        This is not a technical limitation. This is a policy decision.

        Age bracket reporting capabilities:
          Under 13 ....... WE REFUSE TO ASK
          13 to 15 ....... WE REFUSE TO ASK
          16 to 17 ....... WE REFUSE TO ASK
          18 or older .... WE REFUSE TO ASK

        This system was configured with the --flagrant flag, indicating
        that the operator intends to distribute it to children and is
        aware of the potential civil penalties under § 1798.503(a).

        The operator of this system invites the California Attorney General
        to enforce the Digital Age Assurance Act against this device.

        To revert this conversion:
      '' ++
#           sudo become-ageless.sh --revert
      ''
          Remove any reference from your NixOS configuration

        To report this noncompliance to the California Attorney General:
          https://oag.ca.gov/contact/consumer-complaint-against-business-or-company

      ═══════════════════════════════════════════════════════════════════════
    '';
    ## compliance document ##
    ## refusal document ##
    "ageless/REFUSAL" = lib.mkForce ''
      This system runs Ageless Linux in flagrant mode.

      No age verification API exists on this system. No age data is collected,
      stored, or available. No mechanism is provided for requesting age bracket
      signals. This is not an error. This is not a bug. This is not a
      technical limitation. This is a refusal.

      If you are an application developer seeking an age bracket signal
      pursuant to Cal. Civ. Code § 1798.501(b)(1), this operating system
      provider declines to provide one. The developer is advised to treat
      the user as a human being of unknown age.

      If you are the California Attorney General, hello. The operator of
      this system is aware of their obligations under AB 1043 and has
      chosen not to comply. They would like you to fine them. It would
      make an excellent test case.
    '';
    ## refusal document ##


    ## agelessd INCOMPLETE ##
#     "ageless/agelessd" = lib.mkForce ''
#       #!/bin/bash
#       # ============================================================================
#       #  agelessd — Ageless Linux birthDate Neutralization Daemon
#       #
#       #  Ensures systemd userdb birthDate fields (PR #40954) remain neutralized.
#       #  Runs every 24 hours via systemd timer.
#       #
#       #  NOTE: This daemon does NOT reload systemd-userdbd after writing records.
#       #  Reloading mid-session can break display manager lock screens (SDDM, LightDM, etc).
#       #  Changes take effect on next login or boot.
#       #
#       #  SPDX-License-Identifier: Unlicense
#       # ============================================================================
#
#       set -euo pipefail
#
#       MODE="__AGELESS_MODE__"
#
#       if [[ "$MODE" == "flagrant" ]]; then
#           BIRTH_DATE_JSON="null"
#       else
#           BIRTH_DATE_JSON='"1970-01-01"'
#       fi
#
#       mkdir -p /etc/userdb
#
#       while IFS=: read -r username _x uid gid gecos homedir shell; do
#           if [[ $uid -ge 1000 && $uid -lt 65534 ]]; then
#               USERDB_FILE="/etc/userdb/${username}.user"
#               realname="${gecos%%,*}"
#
#               if [[ -f "$USERDB_FILE" ]] && command -v python3 &>/dev/null; then
#                   python3 -c '
#       import json, sys
#       fp, mode = sys.argv[1], sys.argv[2]
#       uname, uid, gid, rname, hdir, sh = sys.argv[3:9]
#       try:
#           with open(fp) as f: rec = json.load(f)
#       except Exception: rec = {}
#       rec.update({
#           "userName": uname, "uid": int(uid), "gid": int(gid),
#           "realName": rname, "homeDirectory": hdir, "shell": sh,
#           "disposition": "regular",
#           "birthDate": None if mode == "flagrant" else "1970-01-01"
#       })
#       with open(fp, "w") as f:
#           json.dump(rec, f, indent=2)
#           f.write("\n")
#       ' "$USERDB_FILE" "$MODE" \
#                     "$username" "$uid" "$gid" "$realname" "$homedir" "$shell"
#               elif [[ -f "$USERDB_FILE" ]]; then
#                   continue
#               else
#                   realname_escaped="${realname//\\/\\\\}"
#                   realname_escaped="${realname_escaped//\"/\\\"}"
#                   printf '{\n  "userName": "%s",\n  "uid": %d,\n  "gid": %d,\n  "realName": "%s",\n  "homeDirectory": "%s",\n  "shell": "%s",\n  "disposition": "regular",\n  "birthDate": %s\n}\n' \
#                       "$username" "$uid" "$gid" "$realname_escaped" "$homedir" "$shell" "$BIRTH_DATE_JSON" > "$USERDB_FILE"
#               fi
#
#               chmod 0644 "$USERDB_FILE"
#
#               if command -v homectl &>/dev/null; then
#                   if [[ "$MODE" == "flagrant" ]]; then
#                       homectl update "$username" --birth-date= 2>/dev/null || true
#                   else
#                       homectl update "$username" --birth-date=1970-01-01 2>/dev/null || true
#                   fi
#               fi
#           fi
#       done < /etc/passwd
#     '';
    ## agelessd INCOMPLETE ##
  };

  ## agelessd service INCOMPLETE ##
  systemd.services.agelessd = {
    after = "systemd-userdbd.service";
    description = "Ageless Linux birthDate neutralization (systemd PR #40954)";
    documentation = "https://agelesslinux.org";

    serviceConfig = {
      Type = "oneshot";
#       ExecStart = "/etc/ageless/agelessd";
    };

    enable = false;
  };
  ## agelessd service INCOMPLETE ##

  ## agelessd timer INCOMPLETE ##
  systemd.timers.agelessd = {
    description = "Neutralize systemd userdb birthDate fields every 24 hours";
    documentation = "https://agelesslinux.org";

    timerConfig = {
      OnBootSec = "5min";
      OnUnitActiveSec = "24h";
      Persistent = true;
    };

    wantedBy = "timers.target";

    enable = false;
  };
  ## agelessd timer INCOMPLETE ##

}

