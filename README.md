# FocusAssist8

A work-in-progress focus timer.

## Installation

- First, download the file from [GitHub Releases](https://github.com/crystalreef22/FocusAssist8/releases/)

### MacOS

1. Open `FocusAssist8_<version>_mac.dmg`, drag the app to the Applications folder.

2. Then, open a terminal and run
`sudo xattr -r -d com.apple.quarantine /Applications/FocusAssist8.app`
so that apple doesn't think the app is a damaged virus.

### Windows

- If you would like to try the app, download and extract `FocusAssist8_<version>_win_portable.zip` to any directory.
- To install, download `FocusAssist8_<version>_win_installer.exe` (this was made with Inno Setup). Then, simply run the installer and follow the instructions.

### Linux

Open a Github issue and I'll make sure to build it for Linux someday

## Features & Usage

Go set this app to display on all desktops. It is more useful that way.\
This app should display as an window like the following:\
<img width="312" alt="Screenshot 2025-01-01 at 1 51 30 PM" src="https://github.com/user-attachments/assets/fb88091e-834e-4ac4-b70d-39965d1f72f8" />

The "Timer name..." field is just an empty text field that does nothing. I recommend you write down what task you want to do here or what you want to do once the timer finishes.\
The blue buttons, in order from left to right, do the following:
1. Pause (or mute alarm)
2. Reset timer
3. Add one minute
4. Remove one minute
5. Set the timer
6. Show Focus Window

Modes:

- Alarm: play a ringtone when the timer expires
- Silence: same, but no sound plays
- Show Focus Window: show focus window when expires

### Focus Window

When active, this will cover the entire screen and stop you from doing anything until you hold the mouse down for a few seconds to clear it. **This does not work properly on multi-monitor setups**

-----

That is all for now.
