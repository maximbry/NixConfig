{ pkgs, ... }: {
  services.nohang = {
    enable = true;
    desktop = true;
    extraConfig = ''
      ## This is the configuration file of the nohang daemon.

      ## The configuration includes the following sections:
      ##  0. Check kernel messages for OOM events
      ##  1. Common zram settings
      ##  2. Common PSI settings
      ##  3. Poll rate
      ##  4. Warnings and notifications
      ##  5. Soft (SIGTERM) threshold
      ##  6. Hard (SIGKILL) threshold
      ##  7. Customize victim selection: adjusting badness of processes
      ##  8. Customize soft corrective actions
      ##  9. Misc settings
      ## 10. Verbosity, debug, logging

      ## WARNING!
      ##  - Lines starting with #, tabs and whitespace characters are comments.
      ##  - Lines starting with @ contain optional parameters that may be repeated.
      ##  - All values are case sensitive.
      ##  - nohang doesn't forbid you to shoot yourself in the foot. Be careful!
      ##  - Restart the daemon after editing the file to apply the new settings.
      ##  - You can find the file with default values here: :TARGET_DATADIR:/nohang/nohang.conf

      ## To find config keys descriptions see man(8) nohang

      ###############################################################################

      ##  0. Check kernel messages for OOM events

      #   @check_kmsg
      ##  Type: boolean
      ##  Comment/uncomment to disable/enable checking kmsg for OOM events

      #   @debug_kmsg
      ##  Type: boolean
      ##  Comment/uncomment to disable/enable debug checking kmsg

      ###############################################################################

          1. Common zram settings

          Key: zram_checking_enabled
          Description:
          Type: boolean
          Valid values: True | False
          Default value: False

      zram_checking_enabled = True

      ###############################################################################

          2. Common PSI settings

          Key: psi_checking_enabled
          Description:
          Type: boolean
          Valid values: True | False
          Default value: True

      psi_checking_enabled = True

          Key: psi_path
          Description:
          Type: string
          Valid values: any string
          Default value: /proc/pressure/memory

      psi_path = /proc/pressure/memory

          Key: psi_metrics
          Description:
          Type: string
          Valid values: some_avg10, some_avg60, some_avg300,
                        full_avg10, full_avg60, full_avg300
          Default value: full_avg10

      psi_metrics = full_avg10

          Key: psi_excess_duration
          Description:
          Type: float
          Valid values: >= 0
          Default value: 30

      psi_excess_duration = 30

          Key: psi_post_action_delay
          Description:
          Type: float
          Valid values: >= 10
          Default value: 15

      psi_post_action_delay = 15

      ###############################################################################

          3. Poll rate

          Key: fill_rate_mem
          Description:
          Type: float
          Valid values: >= 100
          Default value: 6000

      fill_rate_mem  = 6000

          Key: fill_rate_swap
          Description:
          Type: float
          Valid values: >= 100
          Default value: 2000

      fill_rate_swap = 2000

          Key: fill_rate_zram
          Description:
          Type: float
          Valid values: >= 100
          Default value: 4000

      fill_rate_zram = 4000

          Key: max_sleep
          Description:
          Type: float
          Valid values: >= 0.01 and >= min_sleep
          Default value: 3

      max_sleep = 3

          Key: min_sleep
          Description:
          Type: float
          Valid values: >= 0.01 and <= max_sleep
          Default value: 0.1

      min_sleep = 0.1

      ###############################################################################

          4. Warnings and notifications

          4.1. GUI notifications after corrective actions

          Key: post_action_gui_notifications
          Description:
          Type: boolean
          Valid values: True | False
          Default value: True

      post_action_gui_notifications = True

          Key: hide_corrective_action_type
          Description:
          Type: boolean
          Valid values: True | False
          Default value: False

      hide_corrective_action_type = False

          4.2. Low memory warnings

          Key: low_memory_warnings_enabled
          Description:
          Type: boolean
          Valid values: True | False
          Default value: True

      low_memory_warnings_enabled = True

          Key: warning_exe
          Description:
          Type: string
          Valid values: any string
          Default value: (empty string)

      warning_exe =

          Key: warning_threshold_min_mem
          Description:
          Type: float (with % or M)
          Valid values: from the range [0; 100] %
          Default value: 20 %

      warning_threshold_min_mem  = 20 %

          Key: warning_threshold_min_swap
          Description:
          Type: float (with % or M)
          Valid values: [0; 100] % or >= 0 M
          Default value: 20 %

      warning_threshold_min_swap = 25 %

          Key: warning_threshold_max_zram
          Description:
          Type: float (with % or M)
          Valid values: from the range [0; 100] %
          Default value: 45 %

      warning_threshold_max_zram = 45 %

          Key: warning_threshold_max_psi
          Description:
          Type: float
          Valid values: from the range [0; 100]
          Default value: 10

      warning_threshold_max_psi  = 10

          Key: min_post_warning_delay
          Description:
          Type: float
          Valid values: >= 1
          Default value: 60

      min_post_warning_delay = 60

          Key: env_cache_time
          Description:
          Type: float
          Valid values: >= 0
          Default value: 300

      env_cache_time = 300

      ###############################################################################

          5. Soft threshold (thresholds for sending the SIGTERM signal or
                             implementing other soft corrective action)

          Key: soft_threshold_min_mem
          Description:
          Type: float (with % or M)
          Valid values: from the range [0; 50] %
          Default value: 5 %

      soft_threshold_min_mem = 5 %

          Key: soft_threshold_min_swap
          Description:
          Type: float (with % or M)
          Valid values: [0; 100] % or >= 0 M
          Default value: 10 %

      soft_threshold_min_swap = 10 %

          Key: soft_threshold_max_zram
          Description:
          Type: float (with % or M)
          Valid values: from the range [10; 90] %
          Default value: 55 %

      soft_threshold_max_zram = 55 %

          Key: soft_threshold_max_psi
          Description:
          Type: float
          Valid values: from the range [5; 100]
          Default value: 40

      soft_threshold_max_psi  = 40

      ###############################################################################

          6. Hard threshold (thresholds for sending the SIGKILL signal)

          Key: hard_threshold_min_mem
          Description:
          Type: float (with % or M)
          Valid values: from the range [0; 50] %
          Default value: 2 %

      hard_threshold_min_mem = 2 %

          Key: hard_threshold_min_swap
          Description:
          Type: float (with % or M)
          Valid values: [0; 100] % or >= 0 M
          Default value: 4 %

      hard_threshold_min_swap = 4 %

          Key: hard_threshold_max_zram
          Description:
          Type: float (with % or M)
          Valid values: from the range [10; 90] %
          Default value: 60 %

      hard_threshold_max_zram = 60 %

          Key: hard_threshold_max_psi
          Description:
          Type: float
          Valid values: from the range [5; 100]
          Default value: 90

      hard_threshold_max_psi = 90

      ###############################################################################

          7. Customize victim selection: adjusting badness of processes

          7.1. Ignore positive oom_score_adj

          Key: ignore_positive_oom_score_adj
          Description:
          Type: boolean
          Valid values: True | False
          Default value: False

      ignore_positive_oom_score_adj = False

          7.2.1. Matching process names with RE patterns change their badness

          Syntax:

          @BADNESS_ADJ_RE_NAME  badness_adj  ///  RE_pattern

          New badness value will be += badness_adj

          It is possible to compare multiple patterns
          with different badness_adj values.

          Example:
          @BADNESS_ADJ_RE_NAME -500 /// ^sshd$

          Prefer terminating Firefox tabs instead of terminating the entire browser.
          (In Chromium and Electron-based apps child processes get oom_score_adj=300
          by default.)
      @BADNESS_ADJ_RE_NAME   200  ///  ^(Web Content|Privileged Cont|file:// Content)$

      @BADNESS_ADJ_RE_NAME  -200  ///  ^(dnf|yum|packagekitd)$


          7.2.2. Matching CGroup_v1-line with RE patterns

          @BADNESS_ADJ_RE_CGROUP_V1 -50 ///  ^/system\.slice/

          @BADNESS_ADJ_RE_CGROUP_V1  50 ///  /foo\.service$

          @BADNESS_ADJ_RE_CGROUP_V1 -50 ///  ^/user\.slice/

          7.2.3. Matching CGroup_v2-line with RE patterns

          @BADNESS_ADJ_RE_CGROUP_V2  100 /// ^/workload

          7.2.4. Matching eUIDs with RE patterns

          @BADNESS_ADJ_RE_UID -100 /// ^0$

          7.2.5. Matching /proc/[pid]/exe realpath with RE patterns

          Example:
          @BADNESS_ADJ_RE_REALPATH  20  ///  ^/nix/store/.*/bin/foo$

          Protect X.
      @BADNESS_ADJ_RE_REALPATH -200  ///  ^/nix/store/.*(/libexec/Xorg|/lib/xorg/Xorg|/lib/Xorg|/bin/X|/bin/Xorg|/bin/Xwayland|/bin/weston|/bin/sway)$

          Protect GNOME.
      @BADNESS_ADJ_RE_REALPATH -200  ///  ^/nix/store/.*(/bin/gnome-shell|/bin/metacity|/bin/mutter|/lib/gnome-session/gnome-session-binary|/libexec/gnome-session-binary|/libexec/gnome-session-ctl)$

          Protect KDE Plasma.
      @BADNESS_ADJ_RE_REALPATH -200  ///  ^/nix/store/.*(/bin/plasma-desktop|/bin/plasmashell|/bin/plasma_session|/bin/kwin|/bin/kwin_x11|/bin/kwin_wayland)$
      @BADNESS_ADJ_RE_REALPATH -200  ///  ^/nix/store/.*(/bin/startplasma-wayland|/lib/x86_64-linux-gnu/libexec/startplasma-waylandsession|/bin/ksmserver)$

          Protect Cinnamon.
      @BADNESS_ADJ_RE_REALPATH -200  ///  ^/nix/store/.*(/bin/cinnamon|/bin/muffin|/bin/cinnamon-session|/bin/cinnamon-launcher)$

          Protect Xfce.
      @BADNESS_ADJ_RE_REALPATH -200  ///  ^/nix/store/.*(/bin/xfwm4|/bin/xfce4-session|/bin/xfce4-panel|/bin/xfdesktop)$

          Protect Mate.
      @BADNESS_ADJ_RE_REALPATH -200  ///  ^/nix/store/.*(/bin/marco|/bin/mate-session|/bin/caja|/bin/mate-panel)$

          Protect LXQt.
      @BADNESS_ADJ_RE_REALPATH -200  ///  ^/nix/store/.*(/bin/lxqt-panel|/bin/pcmanfm-qt|/bin/lxqt-session)$

          Protect Budgie Desktop.
      @BADNESS_ADJ_RE_REALPATH -200  ///  ^/nix/store/.*(/bin/budgie-wm|/bin/budgie-panel)$

          Protect other.
      @BADNESS_ADJ_RE_REALPATH -200  ///  ^/nix/store/.*(/bin/compiz|/bin/openbox|/bin/fluxbox|/bin/awesome|/bin/icewm|/bin/enlightenment|/bin/gala|/bin/wingpanel|/bin/i3)$

          Protect display managers.
      @BADNESS_ADJ_RE_REALPATH -200  ///  ^/nix/store/.*(/sbin/gdm|/sbin/gdm3|/sbin/sddm|/bin/sddm|/lib/x86_64-linux-gnu/sddm/sddm-helper|/bin/slim|/sbin/lightdm|/libexec/gdm-session-worker|/libexec/gdm-wayland-session|/lib/gdm3/gdm-wayland-session|/lib/gdm3/gdm-session-worker)$
      @BADNESS_ADJ_RE_REALPATH -200  ///  ^/nix/store/.*/lib/gdm3/

          Protect systemd-logind.
      @BADNESS_ADJ_RE_REALPATH -200  ///  ^/nix/store/.*(/lib/systemd/systemd-logind|/lib/systemd/systemd-logind)$

          Protect `systemd --user`.
      @BADNESS_ADJ_RE_REALPATH -200  ///  ^/nix/store/.*(/lib/systemd/systemd|/lib/systemd/systemd)$

          Protect dbus.
      @BADNESS_ADJ_RE_REALPATH -200  ///  ^/nix/store/.*(/bin/dbus-daemon|/bin/dbus-run-session|/bin/dbus-broker-launcher|/bin/dbus-broker)$

          Protect package managers and distro installers.
      @BADNESS_ADJ_RE_REALPATH -200  ///  ^/nix/store/.*(/bin/calamares|/bin/dpkg|/bin/pacman|/bin/yay|/bin/pamac|/bin/pamac-daemon|/bin/pamac-manager)$

          Prefer stress.
          @BADNESS_ADJ_RE_REALPATH  900  ///  ^/nix/store/.*(/bin/stress|/bin/stress-ng)$


          7.2.6. Matching /proc/[pid]/cwd realpath with RE patterns

          @BADNESS_ADJ_RE_CWD  200  ///  ^/home/

          7.2.7. Matching cmdlines with RE patterns
          WARNING: using this option can greatly slow down the search for a victim
          in conditions of heavily swapping.

          Prefer Chromium tabs and Electron-based apps
          @BADNESS_ADJ_RE_CMDLINE  200 /// --type=renderer

          Prefer Firefox tabs (Web Content and WebExtensions)
          @BADNESS_ADJ_RE_CMDLINE  100 /// -appomni

          @BADNESS_ADJ_RE_CMDLINE -200 /// ^/nix/store/.*/lib/virtualbox

          7.2.8. Matching environ with RE patterns
          WARNING: using this option can greatly slow down the search for a victim
          in conditions of heavily swapping.

          @BADNESS_ADJ_RE_ENVIRON 100 /// USER=user


          Note that you can control badness also via systemd units via
          OOMScoreAdjust, see
          www.freedesktop.org/software/systemd/man/systemd.exec.html#OOMScoreAdjust=

      ###############################################################################

          8. Customize soft corrective actions

          Run the command instead of sending a signal with at soft corrective action
          if the victim's name or cgroup matches the regular expression.

          Syntax:
          KEY                         REGEXP      SEPARATOR     COMMAND

          @SOFT_ACTION_RE_NAME       ^foo$             /// kill -USR1  $PID
          @SOFT_ACTION_RE_CGROUP_V1  ^/system\.slice/  /// systemctl restart $SERVICE
          @SOFT_ACTION_RE_CGROUP_V2  /foo\.service$    /// systemctl restart $SERVICE

          $PID will be replaced by process PID.
          $NAME will be replaced by process name.
          $SERVICE will be replaced by .service if it exists (overwise it will be
                                                              relpaced by empty line)

      ###############################################################################

          9. Misc settings

          Key: max_soft_exit_time
          Description:
          Type: float
          Valid values: >= 0.1
          Default value: 10

      max_soft_exit_time = 10

          Key: post_kill_exe
          Description:
          Type: string
          Valid values: any string
          Default value: (empty string)

      post_kill_exe =

          Key: min_badness
          Description:
          Type: integer
          Valid values: >= 1
          Default value: 1

      min_badness = 1

          Key: post_soft_action_delay
          Description:
          Type: float
          Valid values: >= 0.1
          Default value: 3

      post_soft_action_delay = 3

          Key: post_zombie_delay
          Description:
          Type: float
          Valid values: >= 0
          Default value: 0.1

      post_zombie_delay = 0.1

          Key: victim_cache_time
          Description:
          Type: float
          Valid values: >= 0
          Default value: 10

      victim_cache_time = 10

          Key: exe_timeout
          Description:
          Type: float
          Valid values: >= 0.1
          Default value: 20

      exe_timeout = 20

      ###############################################################################

         10. Verbosity, debug, logging

          Key: print_config_at_startup
          Description:
          Type: boolean
          Valid values: True | False
          Default value: False

      print_config_at_startup = False

          Key: print_mem_check_results
          Description:
          Type: boolean
          Valid values: True | False
          Default value: False

      print_mem_check_results = False

          Key: min_mem_report_interval
          Description:
          Type: float
          Valid values: >= 0
          Default value: 60

      min_mem_report_interval = 60

          Key: print_proc_table
          Description:
          Type: boolean
          Valid values: True | False
          Default value: False

      print_proc_table = False

          Key: extra_table_info
          Description:
          WARNING: using "cmdline" or "environ" keys can greatly slow down
          the search for a victim in conditions of heavy swapping.
          Type: string
          Valid values: None, cgroup_v1, cgroup_v2, realpath,
                        cwd, cmdline, environ
          Default value: None

      extra_table_info = None

          Key: print_victim_status
          Description:
          Type: boolean
          Valid values: True | False
          Default value: True

      print_victim_status = True

          Key: print_victim_cmdline
          Description:
          Type: boolean
          Valid values: True | False
          Default value: False

      print_victim_cmdline = False

          Key: max_victim_ancestry_depth
          Description:
          Type: integer
          Valid values: >= 1
          Default value: 3

      max_victim_ancestry_depth = 3

          Key: print_statistics
          Description:
          Type: boolean
          Valid values: True | False
          Default value: True

      print_statistics = True

          Key: debug_psi
          Description:
          Type: boolean
          Valid values: True | False
          Default value: False

      debug_psi = False

          Key: debug_gui_notifications
          Description:
          Type: boolean
          Valid values: True | False
          Default value: False

      debug_gui_notifications = False

          Key: debug_sleep
          Description:
          Type: boolean
          Valid values: True | False
          Default value: False

      debug_sleep = False

          Key: debug_threading
          Description:
          Type: boolean
          Valid values: True | False
          Default value: False

      debug_threading = False

          Key: separate_log
          Description:
          Type: boolean
          Valid values: True | False
          Default value: False

      separate_log = False

      ###############################################################################

          Use cases, feature requests and any questions are welcome:
          https://github.com/hakavlad/nohang/issues
    '';
  };

  services.dbus.packages = [
    pkgs.nohang
  ];
}
