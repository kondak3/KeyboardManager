# VKKeyboardManager

## Requirements:

- iOS 7 or higher

- Automatic Reference Counting (ARC)


## Usage:
- Drag and drop "VKKeyboardManager" folder into your resource

- Import "VKKeyboardManger.h" in "AppDelegate.h" file

```
// add this code in "AppDelegate.m" didFinishLaunchingWithOptions method...
[[VKKeyboardManager shared] setEnable];
[VKKeyboardManager shared].keyboard_gap = 5.0; // default vaule 5.0 and max 100.0
```
