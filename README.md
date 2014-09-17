Griddy - OSX's missing window manager
======



#Introductions

With the lastest changes to OSX Apple did away with the "expand" green button and replaced it with the "full screen" instead. However, for a person with a 4k display and running my rMBP on 2880x1800 this comes as a detriment isn't no app can take advantage nor should they deserve to take up such high resolution screens in their entirely.

Enter Griddy.



# Features

Griddy is modeled after [Divvy](http://mizage.com/divvy/) with a boatload of additional features, and a fresh Yosemite styled UI.

### Completed Features
* tile windows by drag selecting on the main window
* activate/hide Main Window by shortcut `Cmd+G`, Dock Icon and/or StatusItem (menu bar)
  - you can enable/disable Dock Icon and StatusItem activations in the preferences
* Customizable window size as either absolute side (pixels) or percentage of the screen
* Preview customizations before they take place
* Cutomize the number of Grids shown in the main window

### InDev Features
* Yosemite Styles for the Preferences, Main Window, and Hover Window
* Support light/dark modes
* New StatusItem icon

### Future Features
* open on login
* customizable shortcuts
* customize tile margins
* hotkey functionalities (full screen, left 1/2, etc.)
* width x height label on Hover Window
* Onboarding for the Accessibility requirement
* Support screen changes (add/remove screens, change resolutions)


# Installation
NOTICE: Griddy is pre-alpha, its nowhere near feature complete, nor fully tested. I do not hold any responsibilies for damages to your system this may cause.

1. Have a system with the latest `OSX 10.10` build

2. Install `Xcode 6.1`

3. Clone this repo and build it

4. Enable developer mode on your mac if you haven't done so already

5. Go into `System Preferences` -> `Security & Privacy` -> `Accessibility` allow `Xcode` and/or `Griddy` depending where you're running it from.
