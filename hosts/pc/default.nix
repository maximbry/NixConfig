{ lib, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix

    ../common/global
    ../common/users/f

    ../common/tweak/common
    ../common/tweak/desktop

    ../common/optional/sound.nix
    ../common/optional/network-manager.nix
    ../common/optional/zram.nix
    ../common/optional/all-fs.nix
    ../common/optional/virtualisation
    ../common/optional/ananicy.nix
    ../common/optional/dns
    ../common/optional/irqbalance.nix
    ../common/optional/auto-cpufreq.nix
    ../common/optional/thermald.nix
    ../common/optional/time
    ../common/optional/oomd.nix
    ../common/optional/cgroups.nix
    ../common/optional/faster-shutdown.nix
    ../common/optional/plymouth.nix
  ];

  # temporary
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  services.prelockd = {
    enable = true;
    extraConfig =
''
$LOCK_PATH_REGEX=/bin/|/sbin/|/usr/|/lib

$MAX_FILE_SIZE_MIB=50
$MAX_TOTAL_SIZE_MIB=250
$MAX_TOTAL_SIZE_PERCENT=5

$VERBOSITY=1000

$POLL_INTERVAL_SEC=30

@LOCK_PATH  MIN_ENTRY=1  FROM_LATEST=3

$LOCK_ONLY_CRITICAL=True

@CRITICAL_CGROUP2_REGEX  /user\.slice/user-\d+\.slice/user@\d+\.service.+

@CRITICAL_NAME_LIST  sh, bash, fish, zsh, sshd, agetty, getty, login
@CRITICAL_NAME_LIST  systemd, systemd-logind, dbus-daemon, dbus-broker
@CRITICAL_NAME_LIST  X, Xorg, Xwayland, pulseaudio, pipewire
@CRITICAL_NAME_LIST  gnome-shell, gnome-session-b, gnome-screensav, gnome-panel, gnome-flashback, gnome-screensav, metacity
@CRITICAL_NAME_LIST  plasmashell, plasma-desktop, kwin_wayland, kwin_x11, kwin, kded4, knotify4, kded5, kdeinit5
@CRITICAL_NAME_LIST  cinnamon, cinnamon-sessio, cinnamon-screen
@CRITICAL_NAME_LIST  mate-session, marco, mate-settings-d, mate-screensave, mate-panel
@CRITICAL_NAME_LIST  lxqt-panel, lxqt-notificati, lxqt-session
@CRITICAL_NAME_LIST  xfwm4, xfdesktop, xfce4-session, xfsettingsd, xfconfd, xfce4-notifyd, xfce4-screensav, xfce4-panel
@CRITICAL_NAME_LIST  lxsession, xscreensaver, light-locker, lxpanel
@CRITICAL_NAME_LIST  gala, gala-daemon, notification-da
@CRITICAL_NAME_LIST  budgie-wm, budgie-daemon, budgie-panel
@CRITICAL_NAME_LIST  i3, icewm, icewm-session, openbox, fluxbox, awesome, bspwm, sway, wayfire, compiz

@CRITICAL_NAME_LIST  gnome-terminal-, konsole, xfce4-terminal, mate-terminal, lxterminal, qterminal
@CRITICAL_NAME_LIST  nautilus, nautilus-deskto, dolphin, pcmanfm-qt, pcmanfm, caja, nemo-desktop, nemo, Thunar

'';
  };
  services.memavaild = {
    enable = true;
    extraConfig = ''
  ## This is memavaild config file.
  ## Lines starting with $ contains required config keys and values.
  ## Lines starting with @ contain optional config keys that may be repeated.
  ## Other lines will be ignored.

  ## condition for starting correction
  $MIN_MEM_AVAILABLE=2.5%

  ## correction step: to what level are we trying to restore available memory
  $TARGET_MEM_AVAILABLE=3%
  $MAX_CORRECTION_STEP_MIB=50

  ## in how many seconds to remove limits if available memory is above the
  ## specified threshold
  $CANCEL_LIMITS_ABOVE_MEM_AVAILABLE=4%
  $CANCEL_LIMITS_IN_TIME=20

  ## remove limits if the free swap volume is below the specified
  $CANCEL_LIMITS_BELOW_SWAP_FREE_MIB=100

  ## monitoring intensity
  $MEM_FILL_RATE=4000
  $MAX_INTERVAL=3
  $MIN_INTERVAL=0.2
  $CORRECTION_INTERVAL=0.1

  $VERBOSITY=1

  $MIN_UID=1000


  @LIMIT  CGROUP=system.slice  MIN_MEM_HIGH_PERCENT=10  RELATIVE_SHARE=1

  @LIMIT  CGROUP=user.slice    MIN_MEM_HIGH_PERCENT=10  RELATIVE_SHARE=1

  # @LIMIT  CGROUP=user.slice/user-$UID.slice  MIN_MEM_HIGH_PERCENT=10  RELATIVE_SHARE=1


  # @LIMIT  CGROUP=user.slice/user-$UID.slice/user@$UID.service/app.slice/app-org.gnome.Terminal.slice  MIN_MEM_HIGH_PERCENT=5  RELATIVE_SHARE=0.2

  # @LIMIT  CGROUP=user.slice/user-$UID.slice/user@$UID.service/gnome-terminal-server.service  MIN_MEM_HIGH_PERCENT=5  RELATIVE_SHARE=0.2


  # @LIMIT  CGROUP=user.slice/user-$UID.slice/user@$UID.service/idle.slice  MIN_MEM_HIGH_PERCENT=5  RELATIVE_SHARE=0.2

  # @LIMIT  CGROUP=idle.slice  MIN_MEM_HIGH_PERCENT=5  RELATIVE_SHARE=0.2

  ## set this in ~/.bashrc
  ## alias idle-run='systemd-run --slice=idle.slice --shell'  # on modern Distros
  ## alias idle-run='systemd-run --setenv=XPWD=$PWD --slice=idle.slice --uid=$UID --gid=$UID -t $SHELL'  # on Debian 9
'';
  };

  boot.kernelPackages = pkgs.linuxPackages_cachyos;
  networking.firewall.enable = false;
  networking.hostName = "pc";
  networking.hostId = lib.mkDefault "8425e349";
}
