# Dotfiles

<p xmlns:dct="http://purl.org/dc/terms/" xmlns:vcard="http://www.w3.org/2001/vcard-rdf/3.0#">
  <a rel="license"
     href="http://creativecommons.org/publicdomain/zero/1.0/">
    <img src="http://i.creativecommons.org/p/zero/1.0/88x31.png" style="border-style: none;" alt="CC0" />
  </a>
  <br />
  To the extent possible under law,
  <a rel="dct:publisher"
     href="https://github.com/Alonely0">
    <span property="dct:title">Guillem Jara</span></a>
  has waived all copyright and related or neighboring rights to
  <span property="dct:title">his dotfiles</span>.
This work is published from:
<span property="vcard:Country" datatype="dct:ISO3166"
      content="ES" about="https://github.com/Alonely0">
  Spain</span>.
</p>

## Gallery

### Desktop
What you'll see when there are no windows.

<img src="https://raw.githubusercontent.com/Alonely0/dotfiles-2.0/master/images/desktop.png">


### Intelligent layout
This XMonad layout changes its algorithm depending on the number of windows, changing between `Tall` (normal tiling) and `Spiral` (fibonacci spiral) when there are more than 4 windows.

<img src="https://raw.githubusercontent.com/Alonely0/dotfiles-2.0/master/images/tiling+spiral.png">


### Mirror + Tiled layout
This XMonad layout uses the `Tall` algorithm (normal tiling) modified with the Mirror preset, which creates an horizontal layout.

<img src="https://raw.githubusercontent.com/Alonely0/dotfiles-2.0/master/images/mirror-tiled.png">


### Centered Master + Grid layout
This XMonad layout uses the `Grid` algorithm (grid-ish tiling) modified with the Centered Master preset, which creates a layout which puts all windows in a grid behind its master.

<img src="https://raw.githubusercontent.com/Alonely0/dotfiles-2.0/master/images/centeredmaster+grid.png">


### Rofi menu
Shows applications and windows.

<img src="https://raw.githubusercontent.com/Alonely0/dotfiles-2.0/master/images/rofi-drun.png"> <img src="https://raw.githubusercontent.com/Alonely0/dotfiles-2.0/master/images/rofi-window.png">


### Polybar
Polybar shows:
  * workspace & window title
  * date & time
  * home partition usage, memory usage, cpu usage, cpu temperature, battery, volume, current Spotify song & system tray.

<img src="https://raw.githubusercontent.com/Alonely0/dotfiles-2.0/master/images/polybar.png">


### Lockscreen
A lockscreen that blurs screen content.

<img src="https://raw.githubusercontent.com/Alonely0/dotfiles-2.0/master/images/lockscreen.png">


### NeoVim
A simple neovim config, if you want something closer to an IDE consider NvChad instead.

<img src="https://raw.githubusercontent.com/Alonely0/dotfiles-2.0/master/images/nvim.png">


### Ranger *(with NeoVim integration)*
A CLI file manager with integration with NeoVim.

<img src="https://raw.githubusercontent.com/Alonely0/dotfiles-2.0/master/images/ranger.png">

### Tmux
A simple but powerful terminal multiplexer.

<img src="https://raw.githubusercontent.com/Alonely0/dotfiles-2.0/master/images/tmux.png">


---

## Dependencies
- [XMonad](https://XMonad.org/), [XMonad-Contrib](https://github.com/XMonad/XMonad-contrib), [wmctrl](https://www.freedesktop.org/wiki/Software/wmctrl/) and all that stuff: Required

- [Polybar (Git)](https://github.com/polybar/polybar): Required if you want a bar on the top of your screen.

- [NeoVim (Git)](https://github.com/neovim/neovim): Optional if you use another editor such as Emacs and you don't care about using my NeoVim config.

- [Ranger (Git)](https://github.com/ranger/ranger) & [Ueberzug (Git)](https://github.com/seebye/ueberzug): Optional if you use another file manager such as Thunar and you don't care about using my Ranger dotfiles.

- [Ibhagwan's Picom fork](https://github.com/ibhagwan/picom): Required.

- [Rofi (Git)](https://github.com/davatorium/rofi): If you want a menu, it's required.

- [ZSH](https://www.zsh.org/), [Oh my ZSH](https://ohmyz.sh) and [Starship](https://starship.rs): If you want to use my zsh dotfiles, then all of them are required.

- [Tuxfetch](https://github.com/Alonely0/jfetch): Optional

- [Alacritty](https://github.com/alacritty/alacritty): If you want to use my terminal dotfiles, then it's required.

- [Tmux](https://github.com/tmux/tmux): Optional if you don't wanna use a terminal multiplexer.

- [Xautolock](https://github.com/l0b0/xautolock) & [Betterlockscreen](https://github.com/betterlockscreen/betterlockscreen): Required if you want a lockscreen.

- [Dunst (Git)](https://dunst-project.org/): Required, elsewhere you won't have notifications without changing stuff in XMonad config (specifically the line where you spawn the dunst daemon).

- [Fusuma (and all its plugins)](https://github.com/iberianpig/fusuma): Optional, lets you use my touchpad gestures.

- [PlayerCTL](https://github.com/altdesktop/playerctl): Optional, lets you use next/prev/pause keys in your keyboard.

- [BrightnessCTL](https://github.com/Hummer12007/brightnessctl): Optional, lets you use your brightness+/brightness+ keys in your keyboard

- Am I missing something? Open up an issue or make a pull request with the changes.

---

## Installation
Backup your dotfiles, and then move all the content of the repo except the `images` folder and this readme to your `~`. Then, compile XMonad with `xmonad --recompile`.

If you have a ROG laptop, you can use a little script included in the dotfiles that will let you set custom bindings to the keys like ROG logo and Aura RGB. For setting it up, install [asusctl](https://gitlab.com/asus-linux/asusctl) and [python3](https://python.org) and uncomment `.XMonad/XMonad.hs:277`. Edit `.config/rog_bindings.yaml` if you wanna set custom bindings. Recompile XMonad and you're done.

If you also want the Duckduckgo theme, go to your browser's settings and set your new tab URL to this: ```https://duckduckgo.com/?kae=-1&kbc=1&kv=-1&kak=-1&kaq=-1&kaj=m&kap=-1&kp=-2&kao=-1&kav=1&kax=-1&kay=b&k8=9e9485&kx=b8bb26&kj=32302f&k21=32302f&k9=a19276&kaa=818180&k7=1e1e1e```

---

## Troubleshooting
- My wallpaper is gone!
    Ensure FEH is installed and edit the line of XMonad's config that launches it setting other image path.
- When logging in, suddenly my greeter pops up again/Xorg crashes!
    Open a TTY, log in with your user and write `xmonad --recompile`. Then come back to your greeter/original tty and try again.

---

## Thanks to...
- [Axarva](https://github.com/Axarva) for their XMonad configuration (which has been simplified a lot).
- [Jimmy](https://github.com/Jimmysit0) for his fetch and his advices.
- [Garuda Linux Team](https://garudalinux.org/about.html) for a lot of the aliases of the `.zshrc`. (Yep, I used Garuda linux for a couple of months)

**A lot of thanks!**
