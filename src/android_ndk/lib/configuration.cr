# <android/configuration.h>

require "./api_level"
require "./asset_manager"

module AndroidNDK
  lib Lib
    alias AConfiguration = Void

    ACONFIGURATION_ORIENTATION_ANY    = 0x0000
    ACONFIGURATION_ORIENTATION_PORT   = 0x0001
    ACONFIGURATION_ORIENTATION_LAND   = 0x0002
    ACONFIGURATION_ORIENTATION_SQUARE = 0x0003

    ACONFIGURATION_TOUCHSCREEN_ANY     = 0x0000
    ACONFIGURATION_TOUCHSCREEN_NOTOUCH = 0x0001
    ACONFIGURATION_TOUCHSCREEN_STYLUS  = 0x0002
    ACONFIGURATION_TOUCHSCREEN_FINGER  = 0x0003

    ACONFIGURATION_DENSITY_DEFAULT =      0
    ACONFIGURATION_DENSITY_LOW     =    120
    ACONFIGURATION_DENSITY_MEDIUM  =    160
    ACONFIGURATION_DENSITY_TV      =    213
    ACONFIGURATION_DENSITY_HIGH    =    240
    ACONFIGURATION_DENSITY_XHIGH   =    320
    ACONFIGURATION_DENSITY_XXHIGH  =    480
    ACONFIGURATION_DENSITY_XXXHIGH =    640
    ACONFIGURATION_DENSITY_ANY     = 0xfffe
    ACONFIGURATION_DENSITY_NONE    = 0xffff

    ACONFIGURATION_KEYBOARD_ANY    = 0x0000
    ACONFIGURATION_KEYBOARD_NOKEYS = 0x0001
    ACONFIGURATION_KEYBOARD_QWERTY = 0x0002
    ACONFIGURATION_KEYBOARD_12KEY  = 0x0003

    ACONFIGURATION_NAVIGATION_ANY       = 0x0000
    ACONFIGURATION_NAVIGATION_NONAV     = 0x0001
    ACONFIGURATION_NAVIGATION_DPAD      = 0x0002
    ACONFIGURATION_NAVIGATION_TRACKBALL = 0x0003
    ACONFIGURATION_NAVIGATION_WHEEL     = 0x0004

    ACONFIGURATION_KEYSHIDDEN_ANY  = 0x0000
    ACONFIGURATION_KEYSHIDDEN_NO   = 0x0001
    ACONFIGURATION_KEYSHIDDEN_YES  = 0x0002
    ACONFIGURATION_KEYSHIDDEN_SOFT = 0x0003

    ACONFIGURATION_NAVHIDDEN_ANY = 0x0000
    ACONFIGURATION_NAVHIDDEN_NO  = 0x0001
    ACONFIGURATION_NAVHIDDEN_YES = 0x0002

    ACONFIGURATION_SCREENSIZE_ANY    = 0x00
    ACONFIGURATION_SCREENSIZE_SMALL  = 0x01
    ACONFIGURATION_SCREENSIZE_NORMAL = 0x02
    ACONFIGURATION_SCREENSIZE_LARGE  = 0x03
    ACONFIGURATION_SCREENSIZE_XLARGE = 0x04

    ACONFIGURATION_SCREENLONG_ANY = 0x00
    ACONFIGURATION_SCREENLONG_NO  =  0x1
    ACONFIGURATION_SCREENLONG_YES =  0x2

    ACONFIGURATION_SCREENROUND_ANY = 0x00
    ACONFIGURATION_SCREENROUND_NO  =  0x1
    ACONFIGURATION_SCREENROUND_YES =  0x2

    ACONFIGURATION_WIDE_COLOR_GAMUT_ANY = 0x00
    ACONFIGURATION_WIDE_COLOR_GAMUT_NO  =  0x1
    ACONFIGURATION_WIDE_COLOR_GAMUT_YES =  0x2

    ACONFIGURATION_HDR_ANY = 0x00
    ACONFIGURATION_HDR_NO  =  0x1
    ACONFIGURATION_HDR_YES =  0x2

    ACONFIGURATION_UI_MODE_TYPE_ANY        = 0x00
    ACONFIGURATION_UI_MODE_TYPE_NORMAL     = 0x01
    ACONFIGURATION_UI_MODE_TYPE_DESK       = 0x02
    ACONFIGURATION_UI_MODE_TYPE_CAR        = 0x03
    ACONFIGURATION_UI_MODE_TYPE_TELEVISION = 0x04
    ACONFIGURATION_UI_MODE_TYPE_APPLIANCE  = 0x05
    ACONFIGURATION_UI_MODE_TYPE_WATCH      = 0x06
    ACONFIGURATION_UI_MODE_TYPE_VR_HEADSET = 0x07

    ACONFIGURATION_UI_MODE_NIGHT_ANY = 0x00
    ACONFIGURATION_UI_MODE_NIGHT_NO  =  0x1
    ACONFIGURATION_UI_MODE_NIGHT_YES =  0x2

    ACONFIGURATION_SCREEN_WIDTH_DP_ANY = 0x0000

    ACONFIGURATION_SCREEN_HEIGHT_DP_ANY = 0x0000

    ACONFIGURATION_SMALLEST_SCREEN_WIDTH_DP_ANY = 0x0000

    ACONFIGURATION_LAYOUTDIR_ANY = 0x00
    ACONFIGURATION_LAYOUTDIR_LTR = 0x01
    ACONFIGURATION_LAYOUTDIR_RTL = 0x02

    ACONFIGURATION_MCC                  =  0x0001
    ACONFIGURATION_MNC                  =  0x0002
    ACONFIGURATION_LOCALE               =  0x0004
    ACONFIGURATION_TOUCHSCREEN          =  0x0008
    ACONFIGURATION_KEYBOARD             =  0x0010
    ACONFIGURATION_KEYBOARD_HIDDEN      =  0x0020
    ACONFIGURATION_NAVIGATION           =  0x0040
    ACONFIGURATION_ORIENTATION          =  0x0080
    ACONFIGURATION_DENSITY              =  0x0100
    ACONFIGURATION_SCREEN_SIZE          =  0x0200
    ACONFIGURATION_VERSION              =  0x0400
    ACONFIGURATION_SCREEN_LAYOUT        =  0x0800
    ACONFIGURATION_UI_MODE              =  0x1000
    ACONFIGURATION_SMALLEST_SCREEN_SIZE =  0x2000
    ACONFIGURATION_LAYOUTDIR            =  0x4000
    ACONFIGURATION_SCREEN_ROUND         =  0x8000
    ACONFIGURATION_COLOR_MODE           = 0x10000

    ACONFIGURATION_MNC_ZERO = 0xffff

    fun AConfiguration_new : AConfiguration*
    fun AConfiguration_delete(config : AConfiguration*)
    fun AConfiguration_fromAssetManager(out : AConfiguration*, am : AAssetManager*)
    fun AConfiguration_copy(dest : AConfiguration*, src : AConfiguration*)
    fun AConfiguration_getMcc(config : AConfiguration*) : Int32
    fun AConfiguration_setMcc(config : AConfiguration*, mcc : Int32)
    fun AConfiguration_getMnc(config : AConfiguration*) : Int32
    fun AConfiguration_setMnc(config : AConfiguration*, mnc : Int32)
    fun AConfiguration_getLanguage(config : AConfiguration*, outLanguage : Char*)
    fun AConfiguration_setLanguage(config : AConfiguration*, language : Char*)
    fun AConfiguration_getCountry(config : AConfiguration*, outCountry : Char*)
    fun AConfiguration_setCountry(config : AConfiguration*, country : Char*)
    fun AConfiguration_getOrientation(config : AConfiguration*) : Int32
    fun AConfiguration_setOrientation(config : AConfiguration*, orientation : Int32)
    fun AConfiguration_getTouchscreen(config : AConfiguration*) : Int32
    fun AConfiguration_setTouchscreen(config : AConfiguration*, touchscreen : Int32)
    fun AConfiguration_getDensity(config : AConfiguration*) : Int32
    fun AConfiguration_setDensity(config : AConfiguration*, density : Int32)
    fun AConfiguration_getKeyboard(config : AConfiguration*) : Int32
    fun AConfiguration_setKeyboard(config : AConfiguration*, keyboard : Int32)
    fun AConfiguration_getNavigation(config : AConfiguration*) : Int32
    fun AConfiguration_setNavigation(config : AConfiguration*, navigation : Int32)
    fun AConfiguration_getKeysHidden(config : AConfiguration*) : Int32
    fun AConfiguration_setKeysHidden(config : AConfiguration*, keysHidden : Int32)
    fun AConfiguration_getNavHidden(config : AConfiguration*) : Int32
    fun AConfiguration_setNavHidden(config : AConfiguration*, navHidden : Int32)
    fun AConfiguration_getSdkVersion(config : AConfiguration*) : Int32
    fun AConfiguration_setSdkVersion(config : AConfiguration*, sdkVersion : Int32)
    fun AConfiguration_getScreenSize(config : AConfiguration*) : Int32
    fun AConfiguration_setScreenSize(config : AConfiguration*, screenSize : Int32)
    fun AConfiguration_getScreenLong(config : AConfiguration*) : Int32
    fun AConfiguration_setScreenLong(config : AConfiguration*, screenLong : Int32)
    {% if ANDROID_API >= 30 %}
      fun AConfiguration_getScreenRound(config : AConfiguration*) : Int32
    {% end %}
    fun AConfiguration_setScreenRound(config : AConfiguration*, screenRound : Int32)
    fun AConfiguration_getUiModeType(config : AConfiguration*) : Int32
    fun AConfiguration_setUiModeType(config : AConfiguration*, uiModeType : Int32)
    fun AConfiguration_getUiModeNight(config : AConfiguration*) : Int32
    fun AConfiguration_setUiModeNight(config : AConfiguration*, uiModeNight : Int32)
    fun AConfiguration_getScreenWidthDp(config : AConfiguration*) : Int32
    fun AConfiguration_setScreenWidthDp(config : AConfiguration*, value : Int32)
    fun AConfiguration_getScreenHeightDp(config : AConfiguration*) : Int32
    fun AConfiguration_setScreenHeightDp(config : AConfiguration*, value : Int32)
    fun AConfiguration_getSmallestScreenWidthDp(config : AConfiguration*) : Int32
    fun AConfiguration_setSmallestScreenWidthDp(config : AConfiguration*, value : Int32)
    {% if ANDROID_API >= 17 %}
      fun AConfiguration_getLayoutDirection(config : AConfiguration*) : Int32
      fun AConfiguration_setLayoutDirection(config : AConfiguration*, value : Int32)
    {% end %}
    fun AConfiguration_diff(config1 : AConfiguration*, config2 : AConfiguration*) : Int32
    fun AConfiguration_match(base : AConfiguration*, requested : AConfiguration*) : Int32
    fun AConfiguration_isBetterThan(base : AConfiguration*, test : AConfiguration*, requested : AConfiguration*) : Int32
  end
end
