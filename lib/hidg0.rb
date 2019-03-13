#!/usr/bin/env ruby

# file: hidg0.rb

# description: Used with a Raspberry PI Zero plugged into a computer to act as USB Keyboard (HID)

# This gem was made possible thanks to the code from [Turn Your Raspberry Pi Zero into a USB Keyboard (HID)](https://randomnerdtutorials.com/raspberry-pi-zero-usb-keyboard-hid/)

# The following USB HID keyboard IDs were obtained from https://gist.github.com/MightyPork/6da26e382a7ad91b5496ee55fdc73db2#file-usb_hid_keys-h-L36-L76


NULL_CHAR = 0.chr

KEYS = {
  none: 0,  # No key pressed
  err_ovf: 1,  # Keyboard Error Roll Over - used for all slots if too many keys are pressed ("Phantom key")
  a: 4,  # Keyboard a and A
  b: 5,  # Keyboard b and B
  c: 6,  # Keyboard c and C
  d: 7,  # Keyboard d and D
  e: 8,  # Keyboard e and E
  f: 9,  # Keyboard f and F
  g: 10,  # Keyboard g and G
  h: 11,  # Keyboard h and H
  i: 12,  # Keyboard i and I
  j: 13,  # Keyboard j and J
  k: 14,  # Keyboard k and K
  l: 15,  # Keyboard l and L
  m: 16,  # Keyboard m and M
  n: 17,  # Keyboard n and N
  o: 18,  # Keyboard o and O
  p: 19,  # Keyboard p and P
  q: 20,  # Keyboard q and Q
  r: 21,  # Keyboard r and R
  s: 22,  # Keyboard s and S
  t: 23,  # Keyboard t and T
  u: 24,  # Keyboard u and U
  v: 25,  # Keyboard v and V
  w: 26,  # Keyboard w and W
  x: 27,  # Keyboard x and X
  y: 28,  # Keyboard y and Y
  z: 29,  # Keyboard z and Z
  :'1' => 30,  # Keyboard 1 and !
  :'2' => 31,  # Keyboard 2 and @
  :'3' => 32,  # Keyboard 3 and #
  :'4' => 33,  # Keyboard 4 and $
  :'5' => 34,  # Keyboard 5 and %
  :'6' => 35,  # Keyboard 6 and ^
  :'7' => 36,  # Keyboard 7 and &
  :'8' => 37,  # Keyboard 8 and *
  :'9' => 38,  # Keyboard 9 and (
  :'0' => 39,  # Keyboard 0 and )
  enter: 40,  # Keyboard Return (ENTER)
  esc: 41,  # Keyboard ESCAPE
  backspace: 42,  # Keyboard DELETE (Backspace)
  tab: 43,  # Keyboard Tab
  space: 44,  # Keyboard Spacebar
  minus: 45,  # Keyboard - and _
  equal: 46,  # Keyboard = and +
  leftbrace: 47,  # Keyboard [ and {
  rightbrace: 48,  # Keyboard ] and }
  backslash: 49,  # Keyboard  and |
  hashtilde: 50,  # Keyboard Non-US # and ~
  semicolon: 51,  # Keyboard ; and :
  apostrophe: 52,  # Keyboard ' and "
  grave: 53,  # Keyboard ` and ~
  comma: 54,  # Keyboard , and <
  dot: 55,  # Keyboard . and >
  slash: 56,  # Keyboard / and ?
  capslock: 57,  # Keyboard Caps Lock
  f1: 58,  # Keyboard F1
  f2: 59,  # Keyboard F2
  f3: 60,  # Keyboard F3
  f4: 61,  # Keyboard F4
  f5: 62,  # Keyboard F5
  f6: 63,  # Keyboard F6
  f7: 64,  # Keyboard F7
  f8: 65,  # Keyboard F8
  f9: 66,  # Keyboard F9
  f10: 67,  # Keyboard F10
  f11: 68,  # Keyboard F11
  f12: 69,  # Keyboard F12
  sysrq: 70,  # Keyboard Print Screen
  scrolllock: 71,  # Keyboard Scroll Lock
  pause: 72,  # Keyboard Pause
  insert: 73,  # Keyboard Insert
  home: 74,  # Keyboard Home
  pageup: 75,  # Keyboard Page Up
  delete: 76,  # Keyboard Delete Forward
  _end: 77,  # Keyboard End
  pagedown: 78,  # Keyboard Page Down
  right: 79,  # Keyboard Right Arrow
  left: 80,  # Keyboard Left Arrow
  down: 81,  # Keyboard Down Arrow
  up: 82,  # Keyboard Up Arrow
  numlock: 83,  # Keyboard Num Lock and Clear
  kpslash: 84,  # Keypad /
  kpasterisk: 85,  # Keypad *
  kpminus: 86,  # Keypad -
  kpplus: 87,  # Keypad +
  kpenter: 88,  # Keypad ENTER
  kp1: 89,  # Keypad 1 and End
  kp2: 90,  # Keypad 2 and Down Arrow
  kp3: 91,  # Keypad 3 and PageDn
  kp4: 92,  # Keypad 4 and Left Arrow
  kp5: 93,  # Keypad 5
  kp6: 94,  # Keypad 6 and Right Arrow
  kp7: 95,  # Keypad 7 and Home
  kp8: 96,  # Keypad 8 and Up Arrow
  kp9: 97,  # Keypad 9 and Page Up
  kp0: 98,  # Keypad 0 and Insert
  kpdot: 99,  # Keypad . and Delete
  _102nd: 100,  # Keyboard Non-US  and |
  compose: 101,  # Keyboard Application
  power: 102,  # Keyboard Power
  kpequal: 103,  # Keypad =
  f13: 104,  # Keyboard F13
  f14: 105,  # Keyboard F14
  f15: 106,  # Keyboard F15
  f16: 107,  # Keyboard F16
  f17: 108,  # Keyboard F17
  f18: 109,  # Keyboard F18
  f19: 110,  # Keyboard F19
  f20: 111,  # Keyboard F20
  f21: 112,  # Keyboard F21
  f22: 113,  # Keyboard F22
  f23: 114,  # Keyboard F23
  f24: 115,  # Keyboard F24
  open: 116,  # Keyboard Execute
  help: 117,  # Keyboard Help
  props: 118,  # Keyboard Menu
  front: 119,  # Keyboard Select
  stop: 120,  # Keyboard Stop
  again: 121,  # Keyboard Again
  undo: 122,  # Keyboard Undo
  cut: 123,  # Keyboard Cut
  copy: 124,  # Keyboard Copy
  paste: 125,  # Keyboard Paste
  find: 126,  # Keyboard Find
  mute: 127,  # Keyboard Mute
  volumeup: 128,  # Keyboard Volume Up
  volumedown: 129,  # Keyboard Volume Down
  kpcomma: 133,  # Keypad Comma
  ro: 135,  # Keyboard International1
  katakanahiragana: 136,  # Keyboard International2
  yen: 137,  # Keyboard International3
  henkan: 138,  # Keyboard International4
  muhenkan: 139,  # Keyboard International5
  kpjpcomma: 140,  # Keyboard International6
  hangeul: 144,  # Keyboard LANG1
  hanja: 145,  # Keyboard LANG2
  katakana: 146,  # Keyboard LANG3
  hiragana: 147,  # Keyboard LANG4
  zenkakuhankaku: 148,  # Keyboard LANG5
  kpleftparen: 182,  # Keypad (
  kprightparen: 183,  # Keypad )
  leftctrl: 224,  # Keyboard Left Control
  leftshift: 225,  # Keyboard Left Shift
  leftalt: 226,  # Keyboard Left Alt
  leftmeta: 227,  # Keyboard Left GUI
  rightctrl: 228,  # Keyboard Right Control
  rightshift: 229,  # Keyboard Right Shift
  rightalt: 230,  # Keyboard Right Alt
  rightmeta: 231,  # Keyboard Right GUI
  media_playpause: 232,  
  media_stopcd: 233,  
  media_previoussong: 234,  
  media_nextsong: 235,  
  media_ejectcd: 236,  
  media_volumeup: 237,  
  media_volumedown: 238,  
  media_mute: 239,  
  media_www: 240,  
  media_back: 241,  
  media_forward: 242,  
  media_stop: 243,  
  media_find: 244,  
  media_scrollup: 245,  
  media_scrolldown: 246,  
  media_edit: 247,  
  media_sleep: 248,  
  media_coffee: 249,  
  media_refresh: 250,  
  media_calc: 251
}

class HidG0

  def initialize(dev='/dev/hidg0')
    @dev = dev
  end

  def keypress(key)

    write_report(NULL_CHAR*2 + KEYS[key.to_sym].chr + NULL_CHAR*5)

    # Release keys
    write_report(NULL_CHAR*8)

  end

  def sendkeys()
  end

  private

  def write_report(report)
    open(@dev, 'wb+') {|f| f.write report }
  end
end
