require "./lib/configuration"
require "./api_level"
require "./asset_manager"
require "./private"

# `Configuration` is an opaque type used to get and set various subsystem
# configurations.
class AndroidNDK::Configuration
  # Defines flags and constants for various subsystem configurations.
  enum Orientation : Int32
    # Value corresponding to the
    # [`port`](https://developer.android.com/guide/topics/resources/providing-resources#OrientationQualifier)
    # resource qualifier.
    Port = Lib::ACONFIGURATION_ORIENTATION_PORT

    # Value corresponding to the
    # [`land`](https://developer.android.com/guide/topics/resources/providing-resources#OrientationQualifier)
    # resource qualifier.
    Land = Lib::ACONFIGURATION_ORIENTATION_LAND

    # Not currently supported or used.
    @[Deprecated]
    Square = Lib::ACONFIGURATION_ORIENTATION_SQUARE
  end

  # Defines flags and constants for various subsystem configurations.
  enum Touchscreen : Int32
    # Value corresponding to the
    # [`notouch`](https://developer.android.com/guide/topics/resources/providing-resources#TouchscreenQualifier)
    # resource qualifier.
    NoTouch = Lib::ACONFIGURATION_TOUCHSCREEN_NOTOUCH

    # Not currently supported or used.
    @[Deprecated]
    Stylus = Lib::ACONFIGURATION_TOUCHSCREEN_STYLUS

    # Value corresponding to the
    # [`finger`](https://developer.android.com/guide/topics/resources/providing-resources#TouchscreenQualifier)
    # resource qualifier.
    Finger = Lib::ACONFIGURATION_TOUCHSCREEN_FINGER
  end

  # Defines flags and constants for various subsystem configurations.
  module Density
    # Default density.
    Default = Lib::ACONFIGURATION_DENSITY_DEFAULT

    # Value corresponding to the
    # [`ldpi`](https://developer.android.com/guide/topics/resources/providing-resources#DensityQualifier)
    # resource qualifier.
    Low = Lib::ACONFIGURATION_DENSITY_LOW

    # Value corresponding to the
    # [`mdpi`](https://developer.android.com/guide/topics/resources/providing-resources#DensityQualifier)
    # resource qualifier.
    Medium = Lib::ACONFIGURATION_DENSITY_MEDIUM

    # Value corresponding to the
    # [`tvdpi`](https://developer.android.com/guide/topics/resources/providing-resources#DensityQualifier)
    # resource qualifier.
    TV = Lib::ACONFIGURATION_DENSITY_TV

    # Value corresponding to the
    # [`hdpi`](https://developer.android.com/guide/topics/resources/providing-resources#DensityQualifier)
    # resource qualifier.
    High = Lib::ACONFIGURATION_DENSITY_HIGH

    # Value corresponding to the
    # [`xhdpi`](https://developer.android.com/guide/topics/resources/providing-resources#DensityQualifier)
    # resource qualifier.
    XHigh = Lib::ACONFIGURATION_DENSITY_XHIGH

    # Value corresponding to the
    # [`xxhdpi`](https://developer.android.com/guide/topics/resources/providing-resources#DensityQualifier)
    # resource qualifier.
    XXHigh = Lib::ACONFIGURATION_DENSITY_XXHIGH

    # Value corresponding to the
    # [`xxxhdpi`](https://developer.android.com/guide/topics/resources/providing-resources#DensityQualifier)
    # resource qualifier.
    XXXHigh = Lib::ACONFIGURATION_DENSITY_XXXHIGH

    # No density specified.
    None = Lib::ACONFIGURATION_DENSITY_NONE
  end

  # Defines flags and constants for various subsystem configurations.
  enum Keyboard : Int32
    # Value corresponding to the
    # [`nokeys`](https://developer.android.com/guide/topics/resources/providing-resources.html#ImeQualifier)
    # resource qualifier.
    NoKeys = Lib::ACONFIGURATION_KEYBOARD_NOKEYS

    # Value corresponding to the
    # [`qwerty`](https://developer.android.com/guide/topics/resources/providing-resources.html#ImeQualifier)
    # resource qualifier.
    Qwerty = Lib::ACONFIGURATION_KEYBOARD_QWERTY

    # Value corresponding to the
    # [`12key`](https://developer.android.com/guide/topics/resources/providing-resources.html#ImeQualifier)
    # resource qualifier.
    TwelveKey = Lib::ACONFIGURATION_KEYBOARD_12KEY
  end

  # Defines flags and constants for various subsystem configurations.
  enum Navigation : Int32
    # Value corresponding to the
    # [`nonav`](https://developer.android.com@/guide/topics/resources/providing-resources.html#NavigationQualifier)
    # resource qualifier.
    NoNav = Lib::ACONFIGURATION_NAVIGATION_NONAV

    # Value corresponding to the
    # [`dpad`](https://developer.android.com/guide/topics/resources/providing-resources.html#NavigationQualifier)
    # resource qualifier.
    DPad = Lib::ACONFIGURATION_NAVIGATION_DPAD

    # Value corresponding to the
    # [`trackball`](https://developer.android.com/guide/topics/resources/providing-resources.html#NavigationQualifier)
    # resource qualifier.
    Trackball = Lib::ACONFIGURATION_NAVIGATION_TRACKBALL

    # Value corresponding to the
    # [`wheel`](https://developer.android.com/guide/topics/resources/providing-resources.html#NavigationQualifier)
    # resource qualifier.
    Wheel = Lib::ACONFIGURATION_NAVIGATION_WHEEL
  end

  # Defines flags and constants for various subsystem configurations.
  enum KeysHidden : Int32
    # Value corresponding to the
    # [`keysexposed`](https://developer.android.com/guide/topics/resources/providing-resources.html#KeyboardAvailQualifier)
    # resource qualifier.
    No = Lib::ACONFIGURATION_KEYSHIDDEN_NO

    # Value corresponding to the
    # [`keyshidden`](https://developer.android.com/guide/topics/resources/providing-resources.html#KeyboardAvailQualifier)
    # resource qualifier.
    Yes = Lib::ACONFIGURATION_KEYSHIDDEN_YES

    # Value corresponding to the
    # [`keyssoft`](https://developer.android.com/guide/topics/resources/providing-resources.html#KeyboardAvailQualifier)
    # resource qualifier.
    Soft = Lib::ACONFIGURATION_KEYSHIDDEN_SOFT
  end

  # Defines flags and constants for various subsystem configurations.
  enum NavHidden : Int32
    # Value corresponding to the
    # [`navexposed`](https://developer.android.com/guide/topics/resources/providing-resources.html#NavAvailQualifier)
    # resource qualifier.
    No = Lib::ACONFIGURATION_NAVHIDDEN_NO

    # Value corresponding to the
    # [`navhidden`](https://developer.android.com/guide/topics/resources/providing-resources.html#NavAvailQualifier)
    # resource qualifier.
    Yes = Lib::ACONFIGURATION_NAVHIDDEN_YES
  end

  # Defines flags and constants for various subsystem configurations.
  enum ScreenSize : Int32
    # Value indicating the screen is at least
    # approximately 320x426 dp units, corresponding to the
    # [`small`](https://developer.android.com/guide/topics/resources/providing-resources.html#ScreenSizeQualifier)
    # resource qualifier.
    Small = Lib::ACONFIGURATION_SCREENSIZE_SMALL

    # Value indicating the screen is at least
    # approximately 320x470 dp units, corresponding to the
    # [`normal`](https://developer.android.com/guide/topics/resources/providing-resources.html#ScreenSizeQualifier)
    # resource qualifier.
    Normal = Lib::ACONFIGURATION_SCREENSIZE_NORMAL

    # Value indicating the screen is at least
    # approximately 480x640 dp units, corresponding to the
    # [`large`](https://developer.android.com/guide/topics/resources/providing-resources.html#ScreenSizeQualifier)
    # resource qualifier.
    Large = Lib::ACONFIGURATION_SCREENSIZE_LARGE

    # Value indicating the screen is at least
    # approximately 720x960 dp units, corresponding to the
    # [`xlarge`](https://developer.android.com/guide/topics/resources/providing-resources.html#ScreenSizeQualifier)
    # resource qualifier.
    XLarge = Lib::ACONFIGURATION_SCREENSIZE_XLARGE
  end

  # Defines flags and constants for various subsystem configurations.
  enum ScreenLong : Int32
    # Value that corresponds to the
    # [`notlong`](https://developer.android.com/guide/topics/resources/providing-resources.html#ScreenAspectQualifier)
    # resource qualifier.
    No = Lib::ACONFIGURATION_SCREENLONG_NO

    # Value that corresponds to the
    # [`long`](https://developer.android.com/guide/topics/resources/providing-resources.html#ScreenAspectQualifier)
    # resource qualifier.
    Yes = Lib::ACONFIGURATION_SCREENLONG_YES
  end

  # Defines flags and constants for various subsystem configurations.
  enum ScreenRound : Int32
    No  = Lib::ACONFIGURATION_SCREENROUND_NO
    Yes = Lib::ACONFIGURATION_SCREENROUND_YES
  end

  # Defines flags and constants for various subsystem configurations.
  enum WideColorGamut : Int32
    # Value that corresponds to
    # [`nowidecg`](https://developer.android.com/guide/topics/resources/providing-resources.html#WideColorGamutQualifier)
    # resource qualifier specified.
    No = Lib::ACONFIGURATION_WIDE_COLOR_GAMUT_NO

    # Value that corresponds to
    # [`widecg`](https://developer.android.com/guide/topics/resources/providing-resources.html#WideColorGamutQualifier)
    # resource qualifier specified.
    Yes = Lib::ACONFIGURATION_WIDE_COLOR_GAMUT_YES
  end

  # Defines flags and constants for various subsystem configurations.
  enum HDR : Int32
    # Value that corresponds to
    # [`lowdr`](https://developer.android.com/guide/topics/resources/providing-resources.html#HDRQualifier)
    # resource qualifier specified.
    No = Lib::ACONFIGURATION_HDR_NO

    # Value that corresponds to
    # [`highdr`](https://developer.android.com/guide/topics/resources/providing-resources.html#HDRQualifier)
    # resource qualifier specified.
    Yes = Lib::ACONFIGURATION_HDR_YES
  end

  # Defines flags and constants for various subsystem configurations.
  enum UIModeType : Int32
    # Value that corresponds to
    # [no UI mode type](https://developer.android.com/guide/topics/resources/providing-resources.html#UiModeQualifier)
    # resource qualifier specified.
    Normal = Lib::ACONFIGURATION_UI_MODE_TYPE_NORMAL

    # UI mode: value that corresponds to
    # [`desk`](https://developer.android.com/guide/topics/resources/providing-resources.html#UiModeQualifier)
    # resource qualifier specified.
    Desk = Lib::ACONFIGURATION_UI_MODE_TYPE_DESK

    # UI mode: value that corresponds to
    # [`car`](https://developer.android.com/guide/topics/resources/providing-resources.html#UiModeQualifier)
    # resource qualifier specified.
    Car = Lib::ACONFIGURATION_UI_MODE_TYPE_CAR

    # UI mode: value that corresponds to
    # [`television`](https://developer.android.com/guide/topics/resources/providing-resources.html#UiModeQualifier)
    # resource qualifier specified.
    Television = Lib::ACONFIGURATION_UI_MODE_TYPE_TELEVISION

    # UI mode: value that corresponds to
    # [`appliance`](https://developer.android.com/guide/topics/resources/providing-resources.html#UiModeQualifier)
    # resource qualifier specified.
    Appliance = Lib::ACONFIGURATION_UI_MODE_TYPE_APPLIANCE

    # UI mode: value that corresponds to
    # [`watch`](https://developer.android.com/guide/topics/resources/providing-resources.html#UiModeQualifier)
    # resource qualifier specified.
    Watch = Lib::ACONFIGURATION_UI_MODE_TYPE_WATCH

    # UI mode: value that corresponds to
    # [`vr`](https://developer.android.com/guide/topics/resources/providing-resources.html#UiModeQualifier)
    # resource qualifier specified.
    VRHeadset = Lib::ACONFIGURATION_UI_MODE_TYPE_VR_HEADSET
  end

  # Defines flags and constants for various subsystem configurations.
  enum UIModeNight : Int32
    # Value that corresponds to
    # [`notnight`](https://developer.android.com/guide/topics/resources/providing-resources.html#NightQualifier)
    # resource qualifier specified.
    No = Lib::ACONFIGURATION_UI_MODE_NIGHT_NO

    # Value that corresponds to
    # [`night`](https://developer.android.com/guide/topics/resources/providing-resources.html#NightQualifier)
    # resource qualifier specified.
    Yes = Lib::ACONFIGURATION_UI_MODE_NIGHT_YES
  end

  # Defines flags and constants for various subsystem configurations.
  enum LayoutDirection : Int32
    # Value that corresponds to
    # [`ldltr`](https://developer.android.com/guide/topics/resources/providing-resources.html#LayoutDirectionQualifier)
    # resource qualifier specified.
    LTR = Lib::ACONFIGURATION_LAYOUTDIR_LTR

    # Value that corresponds to
    # [`ldrtl`](https://developer.android.com/guide/topics/resources/providing-resources.html#LayoutDirectionQualifier)
    # resource qualifier specified.
    RTL = Lib::ACONFIGURATION_LAYOUTDIR_RTL
  end

  private def initialize(@data : Lib::AConfiguration*)
  end

  def to_unsafe
    @data
  end

  def finalize
    Lib.AConfiguration_delete(self)
  end

  def_equals_and_hash @data

  # Creates a new `Configuration`, initialized with no values set.
  def self.new
    new(Lib.AConfiguration_new)
  end

  # Updates the configuration based on the current configuration in the given
  # `AssetManager`.
  def load_from(asset_manager : AssetManager) : Nil
    Lib.AConfiguration_fromAssetManager(self, asset_manager)
  end

  # Copies the contents of *other* to `self`.
  def copy_from(other : Configuration) : Nil
    Lib.AConfiguration_copy(self, other)
  end

  # Returns the current MCC (Mobile Country Code) set in the configuration, or
  # `nil` if not set.
  def mcc : Int32?
    mcc = Lib.AConfiguration_getMcc(self)
    mcc unless mcc == 0
  end

  # Sets the current *mcc* (Mobile Country Code) in the configuration. Pass `0`
  # or `nil` to clear.
  def mcc=(mcc : Int32?) : Int32?
    Lib.AConfiguration_setMcc(self, mcc || 0)
    mcc
  end

  # Returns the current MNC (Mobile Network Code) set in the configuration, or
  # `nil` if not set.
  def mnc : Int32?
    mnc = Lib.AConfiguration_getMnc(self)
    return 0 if mnc == Lib::ACONFIGURATION_MNC_ZERO
    mnc unless mnc == 0
  end

  # Sets the current *mnc* (Mobile Network Code) in the configuration. Pass
  # `nil` to clear.
  def mnc=(mnc : Int32?) : Int32?
    case mnc
    when 0
      value = Lib::ACONFIGURATION_MNC_ZERO
    when Lib::ACONFIGURATION_MNC_ZERO
      raise ArgumentError.new
    when nil
      value = 0
    else
      value = mnc
    end
    Lib.AConfiguration_setMnc(self, value)
    mnc
  end

  # Returns the current language code set in the configuration. The output will
  # consist of two characters. If a language is not set, returns `nil`.
  def language : String?
    chars = uninitialized UInt8[2]
    Lib.AConfiguration_getLanguage(self, chars.to_unsafe)
    String.new(chars.to_slice) unless chars[0] == 0
  end

  # Sets the current language code in the configuration. Raises `ArgumentError`
  # if *language* is neither a two-character ASCII string nor `nil`.
  def language=(language : String?) : String?
    bytes = language || "\0\0"
    unless bytes.ascii_only? && bytes.bytesize == 2
      raise ArgumentError.new "`language` must be a two-character ASCII string"
    end
    Lib.AConfiguration_setLanguage(self, bytes.to_unsafe)
    language
  end

  # Returns the current country code set in the configuration. The output will
  # consist of two characters. If a country is not set, returns `nil.
  def country : String?
    chars = uninitialized UInt8[2]
    Lib.AConfiguration_getCountry(self, chars.to_unsafe)
    String.new(chars.to_slice) unless chars[0] == 0
  end

  # Sets the current country code in the configuration. Raises `ArgumentError`
  # if *country* is neither a two-character ASCII string nor `nil`.
  def country=(country : String?) : String?
    bytes = country || "\0\0"
    unless bytes.ascii_only? && bytes.bytesize == 2
      raise ArgumentError.new "`language` must be a two-character ASCII string"
    end
    Lib.AConfiguration_setLanguage(self, bytes.to_unsafe)
    country
  end

  # Returns the current `Orientation` set in the configuration.
  def orientation : Orientation?
    value = Lib.AConfiguration_getOrientation(self)
    Orientation.from_value(value) unless value == Lib::ACONFIGURATION_ORIENTATION_ANY
  end

  # Sets the current *orientation* in the configuration.
  def orientation=(orientation : Orientation?) : Orientation?
    value = orientation ? orientation.value : Lib::ACONFIGURATION_ORIENTATION_ANY
    Lib.AConfiguration_setOrientation(self, value)
    orientation
  end

  # Returns the current `Touchscreen` set in the configuration.
  def touchscreen : Touchscreen?
    value = Lib.AConfiguration_getTouchscreen(self)
    Touchscreen.from_value(value) unless value == Lib::ACONFIGURATION_TOUCHSCREEN_ANY
  end

  # Sets the current *touchscreen* in the configuration.
  def touchscreen=(touchscreen : Touchscreen?) : Touchscreen?
    value = touchscreen ? touchscreen.value : Lib::ACONFIGURATION_TOUCHSCREEN_ANY
    Lib.AConfiguration_setTouchscreen(self, value)
    touchscreen
  end

  # Returns the current density set in the configuration.
  def density : Int32?
    value = Lib.AConfiguration_getDensity(self)
    value unless value == Lib::ACONFIGURATION_DENSITY_ANY
  end

  # Sets the current *density* in the configuration.
  def density=(density : Int32?) : Int32?
    if density
      raise ArgumentError.new if density == Lib::ACONFIGURATION_DENSITY_ANY
      value = density
    else
      value = Lib::ACONFIGURATION_DENSITY_ANY
    end
    Lib.AConfiguration_setDensity(self, value)
    density
  end

  # Returns the current `Keyboard` set in the configuration.
  def keyboard : Keyboard?
    value = Lib.AConfiguration_getKeyboard(self)
    Keyboard.from_value(value) unless value == Lib::ACONFIGURATION_KEYBOARD_ANY
  end

  # Sets the current *keyboard* in the configuration.
  def keyboard=(keyboard : Keyboard?) : Keyboard?
    value = keyboard ? keyboard.value : Lib::ACONFIGURATION_KEYBOARD_ANY
    Lib.AConfiguration_setKeyboard(self, value)
    keyboard
  end

  # Returns the current `Navigation` set in the configuration.
  def navigation : Navigation?
    value = Lib.AConfiguration_getNavigation(self)
    Navigation.from_value(value) unless value == Lib::ACONFIGURATION_NAVIGATION_ANY
  end

  # Sets the current *navigation* in the configuration.
  def navigation=(navigation : Navigation?) : Navigation?
    value = navigation ? navigation.value : Lib::ACONFIGURATION_NAVIGATION_ANY
    Lib.AConfiguration_setNavigation(self, value)
    navigation
  end

  # Returns the current `KeysHidden` set in the configuration.
  def keys_hidden : KeysHidden?
    value = Lib.AConfiguration_getKeysHidden(self)
    KeysHidden.from_value(value) unless value == Lib::ACONFIGURATION_KEYSHIDDEN_ANY
  end

  # Sets the current *keys_hidden* in the configuration.
  def keys_hidden=(keys_hidden : KeysHidden?) : KeysHidden?
    value = keys_hidden ? keys_hidden.value : Lib::ACONFIGURATION_KEYSHIDDEN_ANY
    Lib.AConfiguration_setKeysHidden(self, value)
    keys_hidden
  end

  # Returns the current `NavHidden` set in the configuration.
  def nav_hidden : NavHidden?
    value = Lib.AConfiguration_getNavHidden(self)
    NavHidden.from_value(value) unless value == Lib::ACONFIGURATION_NAVHIDDEN_ANY
  end

  # Sets the current *nav_hidden* in the configuration.
  def nav_hidden=(nav_hidden : NavHidden?) : NavHidden?
    value = nav_hidden ? nav_hidden.value : Lib::ACONFIGURATION_NAVHIDDEN_ANY
    Lib.AConfiguration_setNavHidden(self, value)
    nav_hidden
  end

  # Returns the current SDK (API) version set in the configuration.
  def sdk_version : Int32
    Lib.AConfiguration_getSdkVersion(self)
  end

  # Sets the current SDK version in the configuration.
  def sdk_version=(sdk_version : Int32) : Int32
    Lib.AConfiguration_setSdkVersion(self, sdk_version)
    sdk_version
  end

  # Returns the current `ScreenSize` set in the configuration.
  def screen_size : ScreenSize?
    value = Lib.AConfiguration_getScreenSize(self)
    ScreenSize.from_value(value) unless value == Lib::ACONFIGURATION_SCREENSIZE_ANY
  end

  # Sets the current *screen_size* in the configuration.
  def screen_size=(screen_size : ScreenSize?) : ScreenSize?
    value = screen_size ? screen_size.value : Lib::ACONFIGURATION_SCREENSIZE_ANY
    Lib.AConfiguration_setScreenSize(self, value)
    screen_size
  end

  # Returns the current `ScreenLong` set in the configuration.
  def screen_long : ScreenLong?
    value = Lib.AConfiguration_getScreenLong(self)
    ScreenLong.from_value(value) unless value == Lib::ACONFIGURATION_SCREENLONG_ANY
  end

  # Sets the current *screen_long* in the configuration.
  def screen_long=(screen_long : ScreenLong?) : ScreenLong?
    value = screen_long ? screen_long.value : Lib::ACONFIGURATION_SCREENLONG_ANY
    Lib.AConfiguration_setScreenLong(self, value)
    screen_long
  end

  # Returns the current `ScreenRound` set in the configuration.
  #
  # Returns `nil` below API level 30.
  def screen_round : ScreenRound?
    {% if API_LEVEL >= 30 %}
      value = Lib.AConfiguration_getScreenRound(self)
      ScreenRound.from_value(value) unless value == Lib::ACONFIGURATION_SCREENROUND_ANY
    {% end %}
  end

  # Sets the current *screen_round* in the configuration.
  def screen_round=(screen_round : ScreenRound?) : ScreenRound?
    value = screen_round ? screen_round.value : Lib::ACONFIGURATION_SCREENROUND_ANY
    Lib.AConfiguration_setScreenRound(self, value)
    screen_round
  end

  # Returns the current `UIModeType` set in the configuration.
  def ui_mode_type : UIModeType?
    value = Lib.AConfiguration_getUiModeType(self)
    UIModeType.from_value(value) unless value == Lib::ACONFIGURATION_UI_MODE_TYPE_ANY
  end

  # Sets the current UI mode type in the configuration.
  def ui_mode_type=(ui_mode_type : UIModeType?) : UIModeType?
    value = ui_mode_type ? ui_mode_type.value : Lib::ACONFIGURATION_UI_MODE_TYPE_ANY
    Lib.AConfiguration_setUiModeType(self, value)
    ui_mode_type
  end

  # Returns the current `UiModeNight` set in the configuration.
  def ui_mode_night : UIModeNight?
    value = Lib.AConfiguration_getUiModeNight(self)
    UIModeNight.from_value(value) unless value == Lib::ACONFIGURATION_UI_MODE_NIGHT_ANY
  end

  # Sets the current *ui_mode_night* in the configuration.
  def ui_mode_night=(ui_mode_night : UIModeNight?) : UIModeNight?
    value = ui_mode_night ? ui_mode_night.value : Lib::ACONFIGURATION_UI_MODE_NIGHT_ANY
    Lib.AConfiguration_setUiModeNight(self, value)
    ui_mode_night
  end

  # Returns the current configuration screen width in dp units, or `nil` if not
  # set.
  def screen_width_dp : Int32?
    dp = Lib.AConfiguration_getScreenWidthDp(self)
    dp unless dp == Lib::ACONFIGURATION_SCREEN_WIDTH_DP_ANY
  end

  # Sets the configuration's current screen width in dp units.
  def screen_width_dp=(screen_width_dp : Int32?) : Int32?
    if screen_width_dp
      raise ArgumentError.new if screen_width_dp == Lib::ACONFIGURATION_SCREEN_WIDTH_DP_ANY
      dp = screen_width_dp
    else
      dp = Lib::ACONFIGURATION_SCREEN_WIDTH_DP_ANY
    end
    Lib.AConfiguration_setScreenWidthDp(self, dp)
    screen_width_dp
  end

  # Returns the current configuration screen height in dp units, or `nil` if not
  # set.
  def screen_height_dp : Int32?
    dp = Lib.AConfiguration_getScreenHeightDp(self)
    dp unless dp == Lib::ACONFIGURATION_SCREEN_HEIGHT_DP_ANY
  end

  # Sets the configuration's current screen height in dp units.
  def screen_height_dp=(screen_height_dp : Int32?) : Int32?
    if screen_height_dp
      raise ArgumentError.new if screen_height_dp == Lib::ACONFIGURATION_SCREEN_HEIGHT_DP_ANY
      dp = screen_height_dp
    else
      dp = Lib::ACONFIGURATION_SCREEN_HEIGHT_DP_ANY
    end
    Lib.AConfiguration_setScreenHeightDp(self, dp)
    screen_height_dp
  end

  # Return the configuration's smallest screen width in dp units, or `nil` if
  # not set.
  def smallest_screen_width_dp : Int32?
    dp = Lib.AConfiguration_getSmallestScreenWidthDp(self)
    dp unless dp == Lib::ACONFIGURATION_SMALLEST_SCREEN_WIDTH_DP_ANY
  end

  # Sets the configuration's smallest screen width in dp units.
  def smallest_screen_width_dp=(smallest_screen_width_dp : Int32?) : Int32?
    if smallest_screen_width_dp
      raise ArgumentError.new if smallest_screen_width_dp == Lib::ACONFIGURATION_SMALLEST_SCREEN_WIDTH_DP_ANY
      dp = smallest_screen_width_dp
    else
      dp = Lib::ACONFIGURATION_SMALLEST_SCREEN_WIDTH_DP_ANY
    end
    Lib.AConfiguration_setSmallestScreenWidthDp(self, dp)
    smallest_screen_width_dp
  end

  # Returns the current `LayoutDirection` set in the configuration.
  #
  # Returns `nil` below API level 17.
  def layout_direction : LayoutDirection?
    {% if API_LEVEL >= 17 %}
      value = Lib.AConfiguration_getLayoutDirection(self)
      LayoutDirection.from_value(value) unless value == Lib::ACONFIGURATION_LAYOUTDIR_ANY
    {% end %}
  end

  # Sets the current layout direction in the configuration.
  #
  # Has no effect below API level 17.
  def layout_direction=(layout_direction : LayoutDirection?) : LayoutDirection?
    {% if API_LEVEL >= 17 %}
      value = layout_direction ? layout_direction.value : Lib::ACONFIGURATION_LAYOUTDIR_ANY
      Lib.AConfiguration_setLayoutDirection(self, value)
    {% end %}
    layout_direction
  end

  # Performs a diff between two configurations. Returns a set of the following
  # strings, each string present meaning that configuration element
  # is different between the configurations:
  #
  # * `"mcc"`
  # * `"mnc"`
  # * `"locale"`
  # * `"touchscreen"`
  # * `"keyboard"`
  # * `"keys_hidden"`
  # * `"navigation"`
  # * `"orientation"`
  # * `"density"`
  # * `"screen_size"`
  # * `"sdk_version"`
  # * `"screen_long"`
  # * `"ui_mode_type"`
  # * `"smallest_screen_width_dp"`
  # * `"layout_direction"`
  # * `"screen_round"`
  # * `"color_mode"`
  def diff(other : Configuration) : Set(String)
    diff = Lib.AConfiguration_diff(self, other)
    set = Set(String).new(diff.popcount)
    set << "mcc" if diff.bits_set? Lib::ACONFIGURATION_MCC
    set << "mnc" if diff.bits_set? Lib::ACONFIGURATION_MNC
    set << "locale" if diff.bits_set? Lib::ACONFIGURATION_LOCALE
    set << "touchscreen" if diff.bits_set? Lib::ACONFIGURATION_TOUCHSCREEN
    set << "keyboard" if diff.bits_set? Lib::ACONFIGURATION_KEYBOARD
    set << "keys_hidden" if diff.bits_set? Lib::ACONFIGURATION_KEYBOARD_HIDDEN
    set << "navigation" if diff.bits_set? Lib::ACONFIGURATION_NAVIGATION
    set << "orientation" if diff.bits_set? Lib::ACONFIGURATION_ORIENTATION
    set << "density" if diff.bits_set? Lib::ACONFIGURATION_DENSITY
    set << "screen_size" if diff.bits_set? Lib::ACONFIGURATION_SCREEN_SIZE
    set << "sdk_version" if diff.bits_set? Lib::ACONFIGURATION_VERSION
    set << "screen_long" if diff.bits_set? Lib::ACONFIGURATION_SCREEN_LAYOUT
    set << "ui_mode_type" if diff.bits_set? Lib::ACONFIGURATION_UI_MODE
    set << "smallest_screen_width_dp" if diff.bits_set? Lib::ACONFIGURATION_SMALLEST_SCREEN_SIZE
    set << "layout_direction" if diff.bits_set? Lib::ACONFIGURATION_LAYOUTDIR
    set << "screen_round" if diff.bits_set? Lib::ACONFIGURATION_SCREEN_ROUND
    set << "color_mode" if diff.bits_set? Lib::ACONFIGURATION_COLOR_MODE
    set
  end

  # Determines whether `self` is a valid configuration for use within the
  # environment *requested*. Returns `false` if there are any values in `base`
  # that conflict with *requested*. Returns `true` if it does not conflict.
  def matches?(requested : Configuration) : Bool
    Lib.AConfiguration_match(self, requested) != 0
  end

  # Determines whether the configuration in `self` is better than the existing
  # configuration in *base*. If `requested` is not `nil`, this decision is based
  # on the overall configuration given there. If it is `nil`, this decision is
  # simply based on which configuration is more specific. Returns `true` if
  # `self` is better than *base*.
  #
  # This assumes you have already filtered the configurations with `#matches?`.
  def better_than?(base : Configuration, requested : Configuration?) : Bool
    Lib.AConfiguration_isBetterThan(base, self, Private.nilable_unsafe(requested)) != 0
  end
end
