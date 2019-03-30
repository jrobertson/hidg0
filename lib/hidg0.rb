#!/usr/bin/env ruby

# file: hidg0.rb

# description: Used with a Raspberry PI Zero plugged into a computer to act as USB Keyboard (HID)

# This gem was made possible thanks to the code from [Turn Your Raspberry Pi Zero into a USB Keyboard (HID)](https://randomnerdtutorials.com/raspberry-pi-zero-usb-keyboard-hid/)

# The following USB HID keyboard IDs were obtained from https://gist.github.com/MightyPork/6da26e382a7ad91b5496ee55fdc73db2#file-usb_hid_keys-h-L36-L76

require 'c32'

NULL_CHAR = 0.chr

=begin

# Reference notes

## Datum representation

Keyboard sends the data to PC in 8 bytes


    1 byte: modifier keys (Control, Shift, Alt, etc.), where each bit corresponds to a key
    1 byte: unused/reserved for OEM
    6 bytes: pressed key codes
    
coped from: https://www.rmedgar.com/blog/using-rpi-zero-as-keyboard-send-reports

## Modifier keys

BYTE1 BYTE2 BYTE3 BYTE4 BYTE5 BYTE6 BYTE7 BYTE8
here:
BYTE1 --
|--bit0: Left Control if push down is 1
|--bit1: Left Shift if push down is 1
|--bit2: Left Alt if push down is 1
|--bit3: Left GUI if push down is 1
|--bit4: Right Control if push down is 1
|--bit5: Right Shift if push down is 1
|--bit6: Right Alt if push down is 1
|--bit7: Right GUI if push down is 1

BYTE3 to BYTE8 is the key.

copied from: https://forum.micropython.org/viewtopic.php?t=2021
=end

# represented in BYTE1

h = %i(right_gui rightalt rightshift rightctrl left_gui left_alt leftshift leftctrl).\
    reverse.map.with_index {|x,i| [x, (2 ** i)]}.to_h

MODIFIERS = h.merge({shift: h[:leftshift], alt: h[:left_alt], 
                     ctrl: h[:leftctrl], control: h[:leftctrl], 
                     windows_key: h[:right_gui]})

=begin
                              byte1    byte2   byte3   bytes4...bytes8    
 e.g. 'right shift' + a #=> 0x32.chr + 0.chr + 0x04.chr + (0.chr*5)
 
=end 

# represented in BYTE3 to BYTE8
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
  :"\n" => 40,
  cr: 40,  
  esc: 41,  # Keyboard ESCAPE
  backspace: 42,  # Keyboard DELETE (Backspace)
  tab: 43,  # Keyboard Tab
  space: 44,  # Keyboard Spacebar
  :' ' => 44,  # Keyboard Spacebar
  minus: 45,  # Keyboard - and _
  :'-' => 45,
  equal: 46,  # Keyboard = and +
  :'=' => 46,
  leftbrace: 47,  # Keyboard [ and {
  :'[' => 47,
  rightbrace: 48,  # Keyboard ] and }
  :']' => 48,
  backslash: 49,  # Keyboard  and |
  hashtilde: 50,  # Keyboard Non-US # and ~
  :'#' => 50,
  semicolon: 51,  # Keyboard ; and :
  :';' => 51,
  apostrophe: 52,  # Keyboard ' and "
  :"'" => 52,
  grave: 53,  # Keyboard ` and ~
  :'`' => 53,
  comma: 54,  # Keyboard , and <
  :',' => 54,  # Keyboard , and <
  dot: 55,  # Keyboard . and >
  :'.' => 55,
  slash: 56,  # Keyboard / and ?
  :'/' => 56,
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
  end: 77,  # Keyboard End
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
  :'102nd' => 100,  # Keyboard Non-US  and |
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
  media_calc: 251,
  A: :a, 
  B: :b, 
  C: :c, 
  D: :d, 
  E: :e, 
  F: :f, 
  G: :g, 
  H: :h, 
  I: :i, 
  J: :j, 
  K: :k, 
  L: :l, 
  M: :m, 
  N: :n, 
  O: :o, 
  P: :p, 
  Q: :q, 
  R: :r, 
  S: :s, 
  T: :t, 
  U: :u, 
  V: :v, 
  W: :w, 
  X: :x, 
  Y: :y, 
  Z: :z,
  :'!' => :'1', 
  :'@' => :'2', 
  :'$' => :'4', 
  :'%' => :'5', 
  :'^' => :'6', 
  :'&' => :'7', 
  :'*' => :'8', 
  :'(' => :'9', 
  :')' => :'0', 
  :'_' => :minus, 
  :'+' => :equal, 
  :'{' => :leftbrace, 
  :'}' => :rightbrace, 
  :'|' => :backslash, 
  :'~' => :hashtilde, 
  :':' => :semicolon, 
  :'"' => :apostrophe, 
  :'<' => :comma, 
  :'>' => :dot, 
  :'?' => :slash, 
  clear: :numlock, 
  down_arrow: :kp2, 
  pagedn: :kp3, 
  left_arrow: :kp4, 
  right_arrow: :kp6, 
  up_arrow: :kp8, 
  page_up: :kp9,
  windows_key: 0
}

class HidG0
  using ColouredText

  def initialize(dev='/dev/hidg0', debug: false, humanspeed: true)
    @dev, @debug = dev, debug
    @duration = humanspeed ? 0.3 : 0
  end

  def keypress(key, duration: 0)

    keydown(key.strip); sleep(duration); release_keys()

  end

  def sendkeys(s)
    
    # current keymapping is for en-gb
    
    # £ is "\u{00A3}" in unicode
    [["\u{00A3}","{shift+3}"],['"','{shift+2}']]\
        .map {|x,y| s.gsub!(x,y) }
    
    s.gsub(/\s*(?=\{)|(?<=\})\s*/,'').scan(/\{[^\}]+\}|./).each do |x|
      
      puts ('x: ' + x.inspect).debug if @debug
      
      if x.length == 1 and x[0] != '{' then
        
        keypress x, duration: @duration
        
      else
        
        # split by semicolon
        
        x[1..-2].split(/\s*;\s*/).each do |instruction|
        
          keys = instruction.split('+')        
        

          puts ('keys: ' + keys.inspect).debug if @debug              
          
          if keys.length > 1 then
                        
            # e.g. keys #=> ['ctrl', 's']
          
            key = KEYS[keys.pop.to_sym]          
            modifier = keys.map {|x| MODIFIERS[x.to_sym]}.inject(:+)
            
            if @debug then
              puts ('key: ' + key.inspect).debug
              puts ('modifier: ' + modifier.inspect).debug
            end
            
            write_report(modifier.chr + NULL_CHAR + key.chr + NULL_CHAR*5)
            release_keys()
            
          else
               
            key = keys.first
            
            if key =~ /sleep/ then
              
              seconds = key[/(?<=sleep )\d+(?:\.\d+)/]
              puts ('sleeping for ' + seconds + 'seconds').info if @debug
              sleep seconds.to_f
              
            else
            
              keypress key, duration: @duration
            end
          end
        end
      end
    end
    
  end

  private
  
  def keydown(key)
    
    puts 'keydown | key: ' + key.inspect if @debug
    
    return write_report(8.chr + NULL_CHAR*7) if key.to_s =~ /^windows_key$/
    
    if KEYS[key.to_sym].is_a? Integer then 

      write_report(NULL_CHAR*2 + KEYS[key.to_sym].chr + NULL_CHAR*5)
      
    else 
      
      # the key can be reproduced by combining tke key press with the shift key
      puts ('KEYS[key.to_sym]: ' + KEYS[key.to_sym].inspect).debug if @debug
      write_report(MODIFIERS[:shift].chr + NULL_CHAR + \
                   KEYS[KEYS[key.to_sym]].chr + NULL_CHAR*5)      
      
    end    
    
  end
  
  def release_keys()
    write_report(NULL_CHAR*8)
  end

  def write_report(report)
    open(@dev, 'wb+') {|f| f.write report }
  end
end

