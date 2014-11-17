# Griddy - OSX's missing window manager

With the lastest changes to OS X Apple did away with the green traffic light's "expand" functionality, and replaced it with  "full screen" instead. However, for a person with a 4k display and a 15" rMBP running at its native 2880x1800 resolution this comes as a detriment since no app can take advantage of, nor should they deserve to take up, such high resolution screens all by themselves.

Enter Griddy.



# Demo

### Main Window Demo
![Main Window Demo](https://raw.githubusercontent.com/yansun0/Griddy/master/Demo/1.gif)

### Preference Popup Demo
![Preference Popup Demo](https://raw.githubusercontent.com/yansun0/Griddy/master/Demo/2.gif)

### Dark/Light Demo
![Preference Popup Demo](https://raw.githubusercontent.com/yansun0/Griddy/master/Demo/3.gif)


# Features

Griddy is modeled after [Divvy](http://mizage.com/divvy/) with a boatload of additional features, and a fresh Yosemite styled UI.

### Completed Features
* tile windows by drag selecting on the main window
* activate/hide Main Window by shortcut `Cmd+G`, Dock Icon and/or StatusItem (menu bar)
  - you can enable/disable Dock Icon and StatusItem activations in the preferences
* Customizable window size as either absolute side (pixels) or percentage of the screen
* Preview customizations before they take place
* Cutomize the number of Grids shown in the main window
* New StatusItem icon
* Choose between force/not-forced window movement and resizing
* Yosemite Styles for the Main Window, and Hover Window
* Support light/dark modes
* Support screen changes (add/remove screens, change resolutions)

### InDev Features
* open on login
* customizable shortcuts

### Future Features
* hotkey functionalities (full screen, left 1/2, etc.)
* width x height label on Hover Window
* Onboarding for the Accessibility requirement



# Installation

NOTICE: Griddy is barely alpha, its nowhere near feature complete, nor fully tested. I do not hold any responsibilies for damages to your system this may cause.

Prereq: have a system with the latest `OSX 10.10` build

### Option 1: build it yourself
1. Have `Xcode 6.1` installed on your system.

2. Clone this repo and build it

3. Enable developer mode on your mac if you haven't done so already

4. Go into `System Preferences` -> `Security & Privacy` -> `Accessibility` and allow `Xcode` and/or `Griddy` depending where you're running it from.

### Option 2: use the release candidate
1. Clone this repo

2. copy Griddy/Griddy.app into your /Application folder

3. Go into `System Preferences` -> `Security & Privacy` -> `Accessibility` and and `Griddy`.
