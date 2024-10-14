# edi this configuration file to define what should be installed on your system.  help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{lib, config, pkgs, neovimUtils, wrapNeovimUnstable, ...}:

let
     binpath = lib.makeBinPath (with pkgs; [
     luajit # required for luarocks.nvim to work
     marksman
     # python311Packages.python-lsp-server
     # python311Packages.yapf
     # python311Packages.rope
     # python311Packages.pycodestyle
     # python311Packages.mccabe
     texlab # TeX LSP
     # ... other language servers and stuff only nvim needs
   ]);

   neovimConfig = pkgs.neovimUtils.makeNeovimConfig {
     # ... whatever else you normally have here
     extraLuaPackages = p: [ p.luarocks p.magick ];
     extraPackages = p: [p.imagemagick];
     withNodeJs = true;
     # withRuby = false;
     withPython3 = true;
     customRC = "luafile ~/.config/nvim/init.lua";
   };
   fullConfig = (neovimConfig // {
     wrapperArgs = lib.escapeShellArgs neovimConfig.wrapperArgs
       + " --prefix PATH : ${binpath}"; # this is the important part!
   });

   tex = (pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-full
            beamertheme-trigon
            beamertheme-metropolis;
   });

   # home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/";
   # home-manager = {
   #      url = "github:nix-community/home-manager";
   #      inputs.nixpkgs.follows = "nixpkgs";
   # };
  in
  {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # (import "${home-manager}/nixos")
      (import <home-manager/nixos>)
    ];
    home-manager.users.morris= {
      /* The home.stateVersion option does not have a default and must be set */
      home.stateVersion = "24.05";
      home.enableNixpkgsReleaseCheck = true;
      /* Here goes the rest of your home-manager config, e.g. home.packages = [ pkgs.foo ]; */

     # programs.neovim = {
     #    enable = true;
     #    package = pkgs.neovim-nightly;
     #    extraPackages = [ pkgs.imagemagick ];
     #    extraLuaPackages = ps: [ ps.magick ];
     # };

    programs.fish = {
	enable = true;
	shellAliases = {
		v = "nvim";
		za = "zathura";
		l = "lsd";
		la = "lsd -a";
		ls = "lsd";
        cat = "bat";
		CONF = "cd ~/.config";
		DL = "cd ~/Downloads/";
        ecc = "sudo -E -s nvim /etc/nixos/configuration.nix";
		upd = "sudo nixos-rebuild switch";
	};

    shellInit = '' 
        set -g fish_key_bindings fish_vi_key_bindings
    '';
	interactiveShellInit = ''
		set fish_greeting # Disable greeting
				'';
	plugins = [
		{ name = "autopair"; src = pkgs.fishPlugins.autopair.src; }
		{ name = "tide"; src = pkgs.fishPlugins.tide.src; }
		{ name = "fzf-fish"; src = pkgs.fishPlugins.fzf-fish.src; }
		{ name = "grc"; src = pkgs.fishPlugins.grc.src; }
		{ name = "z"; src = pkgs.fishPlugins.z.src; }
		# { name = "grc"; src = pkgs.fishPlugins.grc.src; }
			
	]; 

      };
    

	# # MPD
	# services.mpd = {
	# enable = true;
	# user = "morris";
	# musicDirectory = "/home/morris/Music";
	# extraConfig = ''
	# audio_output {
	#   type "pipewire"
	#   name "My PipeWire Output"
	# }
	# '';
	# # Optional:
	# # network.listenAddress = "any"; # if you want to allow non-localhost connections
	# # startWhenNeeded = true; # systemd feature: only start MPD service upon connection to its socket
	# };

    };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nix"; # Define your hostname.

  swapDevices = [ {
    device = "/var/lib/swapfile";
    size = 16*1024;
  } ];

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.wireless.networks.eduroam = {
    auth = ''
        key_mgmt=WPA-EAP
        eap=password
        identity="s6momueh@uni-bonn.de"
        password="%662e594QMQxB"
        '';
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
   i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
 services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable CUPS to print documents.
  boot.supportedFilesystems = [ "ntfs" ];

  # Enable sound with pipewire.
  # sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = 
  {
  morris = {
    isNormalUser = true;
    description = "morris";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
         ];
    };

  nik = {
    isNormalUser = true;
    description = "nik";
    extraGroups = [ "networkmanager" "wheel" ];
    home = "/home/nik";
    packages = with pkgs; [
      firefox
         ];
    };
  };
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

   # List packages installed in system profile. To search, run:
  # $ nix search wget
      
    # This is what I used to get neovim runnning in home-manager, but I'll try without it
   nixpkgs.overlays = [
        # (import (builtins.fetchTarball {
        #     url = 
        #             "https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz";
        # buildInputs = oldAttrs.buildInputs ++ [ super.tree-sitter ];
        # fullConfig;
        # })) 
    (_: super: {
       neovim-custom = pkgs.wrapNeovimUnstable
         (super.neovim-unwrapped.overrideAttrs (oldAttrs: {
           version = "master";
           buildInputs = oldAttrs.buildInputs ++ [ super.tree-sitter ];
         })) fullConfig;
     })
   ];

  environment.systemPackages = with pkgs; [
    # BASIC Utilities
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    neovim-custom
    ffmpeg # Tool for converting all sorts of media files 
    ripgrep # required for Telescope
    tree-sitter
    fd # required for Telescope
    ripgrep-all # Find text in jpg/pdf/mkv basically anything
    wget
    gnumake
    zip
    unzip
    avahi
    ghostscript
    wl-clipboard
    macchina
    mawk
    z-lua
    # Drivers that I (think I) need
    dpkg # For unpacking .deb files
    foomatic-db 
    ipp-usb
    nssmdns
    binutils
    patchelf
    system-config-printer
    gparted
    # GNOME Stuff
    gnome-tweaks # Gnome Tweaks to allow for various tweaks
    gnome-pomodoro
    gnome-solanum
    gnomeExtensions.gsconnect
    gnome.networkmanager-openconnect
    gnome.gvfs
    gdb
    openconnect
    evolution
    thunderbird
    adwaita-qt
    qgnomeplatform-qt6
    themechanger
    appimage-run

    # Office Stuff
    libreoffice
    hyphen
    hyphenDicts.en_US
    hunspell
    poppler_utils # For pdf preview
    odt2txt # For preview of LibreOffice Documents
    zathura # PDF Viewer
    avogadro2
    labplot # KDE Origin Clone
    gnuplot
    eplot
    zotero # Citation Management
    # texlive.combined.scheme-full # LaTeX
    tex
    pandoc # Convert between TeX, Word, md and html
    reveal-md # Make presentations from Markdown
    texlab # TeX LSP
    xournalpp # Allows me to sign PDFs
    inkscape # Create Vector images 
    fontconfig
    pstoedit # For LaTeX support in inkscape
    gimp # Image Manipulation
    pdftk
    nicotine-plus
    syncthing
    signal-desktop-beta
    pango
    ranger
    vifm # It's supposed to be faster than ranger?
    ffmpegthumbnailer # For Video Thumbnails in Ranger
    atool # For archive preview
    w3m 
    libpng12
    rhythmbox
    mpd
    mpdris2 # Integrates MPD into system menu etc.
    ncmpcpp
    cmus
    # displaylink
    picard
    beets
    librewolf
    brave
    fish
    fishPlugins.grc
    lsd
    bat
    # steam
    discord
    zoom
    grc
    fishPlugins.fzf-fish
    fishPlugins.autopair
    fishPlugins.tide
    sshfs
    # tlp # I think this is not needed when power saving is activated
    papirus-icon-theme
    luna-icons
    kitty
    mpv
    yt-dlp # but this one is much superior
    celluloid # Frontend for MPV
    #morris: Torrent clients
    transmission_4
    qbittorrent
    git
    # Programming Languages and Such
    gcc
    lua
    luajit
    luajitPackages.luarocks
    lua-language-server
    imagemagick
    luajitPackages.magick
    marksman
    # clang
    cl
    zig
    efibootmgr
        obs-studio
    samba
    nmap
    cifs-utils
    openconnect
    cacert
    foot # A terminal emulator which doesn't suck that much
    # python311Packages.python-lsp-server
    # python311Packages.yapf
    # python311Packages.rope
    # python311Packages.pycodestyle
    # python311Packages.mccabe
    (python3.withPackages(ps: with ps; [
        numpy
        pandas
        matplotlib
        scipy
        # pysmiles
        networkx
        dbus-python
        more-itertools
        python-lsp-server
        python-lsp-jsonrpc
        python-fontconfig
        yapf
        rope
        pycodestyle
        mccabe
    ]))
    tealdeer # tldr terminal programs	
    inxi 
    fd
    fzf
    hwinfo
    memtest86plus
    btop
    bottom
    spotify
    gjs
    ## Silly terminal stuff
    # cmatrix
    # hollywood
  ];

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    nerdfonts
    liberation_ttf
    arkpandora_ttf
    aileron
    helvetica-neue-lt-std
  ];

    environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
    gedit
    epiphany
    gnome-music
    geary
    gnome-characters
    iagno # go game
    atomix # puzzle game
    tali # poker game
  ]) ++ (with pkgs.gnome; [
    # gnome-terminal
      ]);

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
    programs.firefox.nativeMessagingHosts.gsconnect = true;
    programs.fish.enable = true;
    programs.steam = {
  	enable = true;
  	remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  	dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
	};
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  users.defaultUserShell = pkgs.fish;
  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;

   fileSystems."/mnt/share/muehlpointner" = {
      device = "//172.16.18.200/muehlpointner";
      fsType = "cifs";
      options = let
        # this line prevents hanging on network split
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";

      in ["${automount_opts},credentials=/etc/nixos/smb-secrets"];
  };

  # List services that you want to enable:
  services.flatpak.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  programs.ssh.startAgent = true;

  # GNOME Keyring
  services.gnome.gnome-keyring.enable = true;

  # GVFS
  services.samba = {
    enable = true;
    package = pkgs.sambaFull;
    openFirewall = true;
    shares = {
        public = {
            path = "/mnt/share/muehlpointner";
            browseable = "yes";
            "read only" = "no";
            "guest ok" = "no";
            "create mask" = "0644";
            "directory mask" = "0755";
            "force user" = "muehlpointner";
            "force group" = "ASOKO";
            };
    };
  };

  services.samba-wsdd = {
  enable = true;
  openFirewall = true;
};

  services.gvfs.enable = true;
  # Avahi for Network discovery stuff
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # QT Adwaita-theme
  qt = {
        enable = true;
        platformTheme = "gnome";
        style = "adwaita";
        # style = "adwaita-dark";
  };
  # qt.style = "adwaita";

  # Enable TLP Power saving
  services.power-profiles-daemon.enable = false;
  services.tlp.enable = true;

  # Enable DisplayLink
  # services.server.videoDrivers = ["displaylink" "modesetting"];

  # MPD
  services.mpd = {
  enable = true;
  user = "morris";
  musicDirectory = "/home/morris/Music";
  extraConfig = ''
  audio_output {
    type "pipewire"
    name "My PipeWire Output"
  }
  '';
  # Optional:
  # network.listenAddress = "any"; # if you want to allow non-localhost connections
  # startWhenNeeded = true; # systemd feature: only start MPD service upon connection to its socket
  };

  services.fprintd.enable = true;
  services.fprintd.tod.enable = true;
  services.fprintd.tod.driver = pkgs.libfprint-2-tod1-vfs0090;

  services.fwupd.enable = true;

  systemd.services.mpd.environment = {
   # https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/609
   XDG_RUNTIME_DIR = "/run/user/1000"; # User-id 1000 must match above user. MPD will look inside this directory for the PipeWire socket.
   };

   # systemd.user.services.mpd = "morris";
   # systemd.user.services = {

   # mpd = "morris";
   #      
   # };
  # Open ports in the firewall.
  
  networking.firewall.allowedTCPPortRanges = [
  # KDE Connect
  { from = 1714; to = 1764; }
	];
  networking.firewall.allowedUDPPortRanges = [
  # KDE Connect
  { from = 1714; to = 1764; }
	];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;
  networking.firewall.extraCommands = ''iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns'';
  networking.firewall.allowPing = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}


