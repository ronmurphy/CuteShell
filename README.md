## What is this?
There are already many beautiful quickshell configurations but they all have different hardcoded UI tree implementations. This is my attempt to standardize it (at least for myself). This allows to actually create customizable configurations that can be hot swapped on demand. So basically this is waybar on steroids. The final goal is to make the most general API possible for minimal hot swappable configurations

### Showcase
<p align="center" width="100%">
<video src="https://github.com/user-attachments/assets/7aaeafec-4705-4117-a331-39e842153115" width="80%" controls></video>
</p>

If you have swww-daemon or brightnessctl and want to use them like in the video (brightness slider and wallpaper changer), use nixos-config-retinotopic branch (not the 'main' one). It is used for my NixOS configuration, wallpapers and other dots also available [there](https://github.com/retinotopic/nixos-config).

## Overall structure overview
The codebase is pretty simple, you can probably understand it in 5 minutes (if you know QML and JS). There are basically 3 main files: Bar.qml where you define the overall positioning of modules (left, center, right), BarModuleItem where is your general module interface, and Settings.qml where all configurations are stored (currently there are 4 default configurations as you have seen in the video). All modules inherited from BarModuleItem and stored in ./modules. The BarModuleItem consists of two types of popups, a scrollable content container that can be expanded horizontally and can contain an endless number of elements, and a general popup which parent anchoring can be generally anything. You can find more information in these 3 files. All live reload magic thanks to QML reactivity and Loader Item, there was an option to make it with Qt.createComponent and myComponent.createObject but Loader with its setSource() method makes interface boundaries more distinct and clear.

### Required dependencies
1. Quickshell 0.2.1 (Qt 6.10+)
2. Your font with nerd-fonts support (this dependency will be deleted in the future)

### Optional dependencies
These 3 dependencies are optional because you can activate and deactivate these modules in the Bar.qml file
1. Cava
2. Network Manager and dbus-monitor
3. Niri/Hyprland

### Installation
Currently this is not a standalone shell, and it doesn't have single binary, but basically:
1. Git clone it
2. cd to cloned directory
3. run 'quickshell -p .'

#### __Some important notes__:
This is a prototype and everything can still change a lot. Still yet have to be done:

1. Less coupling between configuration properties and module properties, module definitions also configurable and hot swappable.
2. Notifications
3. Greetd
4. Bluetooth
5. Left and right bar orientations
6. Many QoL improvements

### Credits
1. [Quickshell](https://quickshell.org/): peak QML toolkit for building desktop environments
2. [DankMaterialShell](https://github.com/AvengeMedia/DankMaterialShell): niri and system info services

