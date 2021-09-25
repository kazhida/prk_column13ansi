# Wait until Keyboard class is ready
while !$mutex
  relinquish
end

# Initialize a Keyboard
kbd = Keyboard.new

i2c = I2C.new

# i2c.init(24, 25)                  # QT Py
i2c.init(2, 3, 1, 400 * 1000, 0xFF)   # Pro Micro

# kbd.init_pins(
#   [ 4, 5, 6, 7 ],            # row0, row1,... respectively
#   [ 29, 28, 27, 26, 25, 24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14 ] # col0, col1,... respectively
# )

# Initialize modulo
kbd.init_modulo(
  i2c,
  13,
  [
    TCA9555.new(
      0x00,
      [
        [0, 0], [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], nil, nil,
        [1, 0], [1, 1], [1, 2], [1, 3], [1, 4], [1, 5], nil, nil
      ]
    ),
    TCA9555.new(
      0x01,
      [
        [0, 6], [0, 7], [0, 8], [0, 9], [0, 10], [0, 11], [0, 12], nil,
        [1, 6], [1, 7], [1, 8], [1, 9], [1, 10], [1, 11], nil, nil
      ]
    ),
    TCA9555.new(
      0x02,
      [
        [2, 0], [2, 1], [2, 2], [2, 3], [2, 4], [2, 5], nil, nil,
        [3, 0], [3, 1], [3, 2], [3, 3], [3, 4], nil, nil, nil
      ]
    ),
    TCA9555.new(
      0x03,
      [
        [2, 6], [2, 7], [2, 8], [2, 9], [2, 10], [2, 11], nil, nil,
        [3, 6], [3, 7], [3, 8], [3, 9], [3, 10], [3, 11], nil, nil
      ]
    )
  ]
)

# default layer should be added at first
kbd.add_layer :default, %i[
  KC_ESCAPE KC_Q    KC_W    KC_E        KC_R      KC_T      KC_Y      KC_U      KC_I      KC_O     KC_P      KC_MINUS   KC_BSPACE
  KL_TAB    KC_A    KC_S    KC_D        KC_F      KC_G      KC_H      KC_J      KC_K      KC_L     KC_SCOLON KC_ENTER   KC_NO
  KC_LSFT   KC_Z    KC_X    KC_C        KC_V      KC_B      KC_N      KC_M      KC_COMMA  KC_DOT   KC_UP     KC_SLASH   KC_NO
  KC_LCTL   KC_LGUI KL_DEL  KA_EISU     KG_LSPC   KS_RSPC   KL_KANA   RUBY_GUI  KC_LEFT   KC_DOWN  KC_RIGHT  KC_NO      KC_NO
]
kbd.add_layer :raise, %i[
  KC_GRAVE  KC_Q    KC_W    KC_E        KC_R      KC_T      KC_Y      KC_U      KC_I      KC_O     KC_P       KC_EQUAL  KC_BSPACE
  KL_TAB    KC_A    KC_S    KC_D        KC_F      KC_G      KC_H      KC_J      KC_K      KC_L     KC_SCOLON  KC_ENTER  KC_NO
  KC_LSFT   KC_Z    KC_X    KC_C        KC_V      KC_B      KC_N      KC_M      KC_COMMA  KC_DOT   KC_UP      KC_SLASH  KC_NO
  KC_LCTL   KC_LGUI KL_DEL  KA_EISU     KG_LSPC   KS_RSPC   KL_KANA   RUBY_GUI  KC_LEFT   KC_DOWN  KC_RIGHT  KC_NO      KC_NO
]
kbd.add_layer :lower, %i[
  KC_TILD   KC_1    KC_2    KC_3        KC_4      KC_5      KC_6      KC_7      KC_8      KC_9     KC_0       KC_EQUAL  KC_BSPACE
  KL_TAB    KC_A    KC_S    KC_D        KC_F      KC_G      KC_H      KC_J      KC_K      KC_L     KC_SCOLON  KC_ENTER  KC_NO
  KC_LSFT   KC_Z    KC_X    KC_C        KC_V      KC_B      KC_N      KC_M      KC_COMMA  KC_DOT   KC_UP      KC_SLASH  KC_NO
  KC_LCTL   KC_LGUI KL_DEL  KA_EISU     KG_LSPC   KS_RSPC   KL_KANA   RUBY_GUI  KC_LEFT   KC_DOWN  KC_RIGHT  KC_NO      KC_NO
]
kbd.add_layer :funcs, %i[
  KC_ESCAPE KC_F1   KC_F2   KC_F3       KC_F4     KC_F5     KC_F6     KC_F7     KC_F8     KC_F9    KC_F10     KC_F11    KC_F12
  KL_TAB    KC_A    KC_S    KC_D        KC_F      KC_G      KC_H      KC_J      KC_K      KC_L     KC_SCOLON  KC_ENTER  KC_NO
  KC_LSFT   KC_Z    KC_X    KC_C        KC_V      KC_B      KC_N      KC_M      KC_COMMA  KC_DOT   KC_UP      KC_SLASH  KC_NO
  KC_LCTL   KC_LGUI KL_DEL  KA_EISU     KG_LSPC   KS_RSPC   KL_KANA   RUBY_GUI  KC_LEFT   KC_DOWN  KC_RIGHT   KC_NO     KC_NO
]

#
#                   Your custom     Keycode or             Keycode (only modifiers)      Release time      Re-push time
#                   key name        Array of Keycode       or Layer Symbol to be held    threshold(ms)     threshold(ms)
#                                   or Proc                or Proc which will run        to consider as    to consider as
#                                   when you click         while you keep press          `click the key`   `hold the key`
kbd.define_mode_key :KS_RSPC,     [ :KC_SPC,               :KC_RSFT,                     120,              150 ]
kbd.define_mode_key :KG_LSPC,     [ :KC_SPC,               :KC_LGUI,                     120,              150 ]
kbd.define_mode_key :KL_TAB,      [ :KC_TAB,               :funcs,                       120,              150 ]
kbd.define_mode_key :KL_DEL,      [ :KC_DEL,               :raise,                       120,              150 ]
kbd.define_mode_key :KL_KANA,     [ :KC_LANG1,             :lower,                       120,              150 ]
kbd.define_mode_key :KA_EISU,     [ :KC_LANG2,             :KC_LALT,                     120,              150 ]
kbd.define_mode_key :RUBY_GUI,    [ Proc.new { kbd.ruby }, :KC_RGUI,                     300,              nil ]
#kbd.define_mode_key :ADJUST,      [ nil,           Proc.new { kbd.hold_layer :adjust }, nil,              nil ]
# ^^^^^^^^^^ `hold_layer` will "hold" layer while pressed

# `before_report` will work just right before reporting what keys are pushed to USB host.
# You can use it to hack data by adding an instance method to Keyboard class by yourself.
# ex) Use Keyboard#before_report filter if you want to input `":" w/o shift` and `";" w/ shift`
#kbd.before_report do
#  kbd.invert_sft if kbd.keys_include?(:KC_SCOLON)
#  # You'll be also able to write `invert_ctl`, `invert_alt` and `invert_gui`
#end

# Initialize RGBLED with pin, underglow_size, backlight_size and is_rgbw.
rgb = RGB.new(
  0,    # pin number
  0,    # size of underglow pixel
  48,   # size of backlight pixel
  false # 32bit data will be sent to a pixel if true while 24bit if false
)
# Set an effect
#  `nil` or `:off` for turning off, `:breathing` for "color breathing", `:rainbow` for "rainbow snaking"
# rgb.effect = :rainbow
rgb.effect = :breathing
# rgb.effect = :off
# Set an action when you input
#  `nil` or `:off` for turning off
# rgb.action = :thunder
# Append the feature. Will possibly be able to write `Keyboard#append(OLED.new)` in the future
kbd.append rgb

kbd.start!
