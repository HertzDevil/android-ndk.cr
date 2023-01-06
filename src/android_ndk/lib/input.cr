# <android/input.h>

require "./api_level"
require "./looper"

module AndroidNDK
  lib Lib
    enum AKeyState
      UNKNOWN = -1
      UP      =  0
      DOWN    =  1
      VIRTUAL =  2
    end

    @[Flags]
    enum AMeta
      ALT_ON         =     0x02
      ALT_LEFT_ON    =     0x10
      ALT_RIGHT_ON   =     0x20
      SHIFT_ON       =     0x01
      SHIFT_LEFT_ON  =     0x40
      SHIFT_RIGHT_ON =     0x80
      SYM_ON         =     0x04
      FUNCTION_ON    =     0x08
      CTRL_ON        =   0x1000
      CTRL_LEFT_ON   =   0x2000
      CTRL_RIGHT_ON  =   0x4000
      META_ON        =  0x10000
      META_LEFT_ON   =  0x20000
      META_RIGHT_ON  =  0x40000
      CAPS_LOCK_ON   = 0x100000
      NUM_LOCK_ON    = 0x200000
      SCROLL_LOCK_ON = 0x400000
    end

    alias AInputEvent = Void

    AINPUT_EVENT_TYPE_KEY        = 1
    AINPUT_EVENT_TYPE_MOTION     = 2
    AINPUT_EVENT_TYPE_FOCUS      = 3
    AINPUT_EVENT_TYPE_CAPTURE    = 4
    AINPUT_EVENT_TYPE_DRAG       = 5
    AINPUT_EVENT_TYPE_TOUCH_MODE = 6

    enum AKeyEventAction
      DOWN     = 0
      UP       = 1
      MULTIPLE = 2
    end

    @[Flags]
    enum AKeyEventFlag
      WOKE_HERE           =   0x1
      SOFT_KEYBOARD       =   0x2
      KEEP_TOUCH_MODE     =   0x4
      FROM_SYSTEM         =   0x8
      EDITOR_ACTION       =  0x10
      CANCELED            =  0x20
      VIRTUAL_HARD_KEY    =  0x40
      LONG_PRESS          =  0x80
      CANCELED_LONG_PRESS = 0x100
      TRACKING            = 0x200
      FALLBACK            = 0x400
    end

    AMOTION_EVENT_ACTION_POINTER_INDEX_SHIFT = 8

    AMOTION_EVENT_ACTION_MASK               =   0xff
    AMOTION_EVENT_ACTION_POINTER_INDEX_MASK = 0xff00
    AMOTION_EVENT_ACTION_DOWN               =      0
    AMOTION_EVENT_ACTION_UP                 =      1
    AMOTION_EVENT_ACTION_MOVE               =      2
    AMOTION_EVENT_ACTION_CANCEL             =      3
    AMOTION_EVENT_ACTION_OUTSIDE            =      4
    AMOTION_EVENT_ACTION_POINTER_DOWN       =      5
    AMOTION_EVENT_ACTION_POINTER_UP         =      6
    AMOTION_EVENT_ACTION_HOVER_MOVE         =      7
    AMOTION_EVENT_ACTION_SCROLL             =      8
    AMOTION_EVENT_ACTION_HOVER_ENTER        =      9
    AMOTION_EVENT_ACTION_HOVER_EXIT         =     10
    AMOTION_EVENT_ACTION_BUTTON_PRESS       =     11
    AMOTION_EVENT_ACTION_BUTTON_RELEASE     =     12

    AMOTION_EVENT_FLAG_WINDOW_IS_OBSCURED = 0x1

    AMOTION_EVENT_EDGE_FLAG_TOP    = 0x01
    AMOTION_EVENT_EDGE_FLAG_BOTTOM = 0x02
    AMOTION_EVENT_EDGE_FLAG_LEFT   = 0x04
    AMOTION_EVENT_EDGE_FLAG_RIGHT  = 0x08

    enum AMotionEventAxis
      X           =  0
      Y           =  1
      PRESSURE    =  2
      SIZE        =  3
      TOUCH_MAJOR =  4
      TOUCH_MINOR =  5
      TOOL_MAJOR  =  6
      TOOL_MINOR  =  7
      ORIENTATION =  8
      VSCROLL     =  9
      HSCROLL     = 10
      Z           = 11
      RX          = 12
      RY          = 13
      RZ          = 14
      HAT_X       = 15
      HAT_Y       = 16
      LTRIGGER    = 17
      RTRIGGER    = 18
      THROTTLE    = 19
      RUDDER      = 20
      WHEEL       = 21
      GAS         = 22
      BRAKE       = 23
      DISTANCE    = 24
      TILT        = 25
      SCROLL      = 26
      RELATIVE_X  = 27
      RELATIVE_Y  = 28
      GENERIC_1   = 32
      GENERIC_2   = 33
      GENERIC_3   = 34
      GENERIC_4   = 35
      GENERIC_5   = 36
      GENERIC_6   = 37
      GENERIC_7   = 38
      GENERIC_8   = 39
      GENERIC_9   = 40
      GENERIC_10  = 41
      GENERIC_11  = 42
      GENERIC_12  = 43
      GENERIC_13  = 44
      GENERIC_14  = 45
      GENERIC_15  = 46
      GENERIC_16  = 47
    end

    @[Flags]
    enum AMotionEventButton
      PRIMARY
      SECONDARY
      TERTIARY
      BACK
      FORWARD
      STYLUS_PRIMARY
      STYLUS_SECONDARY
    end

    enum AMotionEventToolType
      UNKNOWN = 0
      FINGER  = 1
      STYLUS  = 2
      MOUSE   = 3
      ERASER  = 4
      PALM    = 5
    end

    enum AMotionClassification : UInt32
      NONE              = 0
      AMBIGUOUS_GESTURE = 1
      DEEP_PRESS        = 2
    end

    @[Flags]
    enum AInputSourceClass
      MASK       = 0x000000ff
      BUTTON     = 0x00000001
      POINTER    = 0x00000002
      NAVIGATION = 0x00000004
      POSITION   = 0x00000008
      JOYSTICK   = 0x00000010
    end

    @[Flags]
    enum AInputSource : UInt32
      UNKNOWN          = 0x00000000
      KEYBOARD         = 0x00000100 | 0x00000001 # AINPUT_SOURCE_CLASS_BUTTON
      DPAD             = 0x00000200 | 0x00000001 # AINPUT_SOURCE_CLASS_BUTTON
      GAMEPAD          = 0x00000400 | 0x00000001 # AINPUT_SOURCE_CLASS_BUTTON
      TOUCHSCREEN      = 0x00001000 | 0x00000002 # AINPUT_SOURCE_CLASS_POINTER
      MOUSE            = 0x00002000 | 0x00000002 # AINPUT_SOURCE_CLASS_POINTER
      STYLUS           = 0x00004000 | 0x00000002 # AINPUT_SOURCE_CLASS_POINTER
      BLUETOOTH_STYLUS = 0x00008000 | 0x00004000 # AINPUT_SOURCE_STYLUS
      TRACKBALL        = 0x00010000 | 0x00000004 # AINPUT_SOURCE_CLASS_NAVIGATION
      MOUSE_RELATIVE   = 0x00020000 | 0x00000004 # AINPUT_SOURCE_CLASS_NAVIGATION
      TOUCHPAD         = 0x00100000 | 0x00000008 # AINPUT_SOURCE_CLASS_POSITION
      TOUCH_NAVIGATION = 0x00200000 | 0x00000000 # AINPUT_SOURCE_CLASS_NONE
      JOYSTICK         = 0x01000000 | 0x00000010 # AINPUT_SOURCE_CLASS_JOYSTICK
      HDMI             = 0x02000000 | 0x00000001 # AINPUT_SOURCE_CLASS_BUTTON
      SENSOR           = 0x04000000 | 0x00000000 # AINPUT_SOURCE_CLASS_NONE
      ROTARY_ENCODER   = 0x00400000 | 0x00000000 # AINPUT_SOURCE_CLASS_NONE
      ANY              = 0xffffff00
    end

    enum AInputKeyboardType
      NONE           = 0
      NON_ALPHABETIC = 1
      ALPHABETIC     = 2
    end

    enum AInputMotionRange
      X           = 0
      Y           = 1
      PRESSURE    = 2
      SIZE        = 3
      TOUCH_MAJOR = 4
      TOUCH_MINOR = 5
      TOOL_MAJOR  = 6
      TOOL_MINOR  = 7
      ORIENTATION = 8
    end

    fun AInputEvent_getType(event : AInputEvent*) : Int32
    fun AInputEvent_getDeviceId(event : AInputEvent*) : Int32
    fun AInputEvent_getSource(event : AInputEvent*) : Int32
    {% if ANDROID_API >= 31 %}
      fun AInputEvent_release(event : AInputEvent*)
    {% end %}

    fun AKeyEvent_getAction(key_event : AInputEvent*) : Int32
    fun AKeyEvent_getFlags(key_event : AInputEvent*) : Int32
    fun AKeyEvent_getKeyCode(key_event : AInputEvent*) : Int32
    fun AKeyEvent_getScanCode(key_event : AInputEvent*) : Int32
    fun AKeyEvent_getMetaState(key_event : AInputEvent*) : Int32
    fun AKeyEvent_getRepeatCount(key_event : AInputEvent*) : Int32
    fun AKeyEvent_getDownTime(key_event : AInputEvent*) : Int64
    fun AKeyEvent_getEventTime(key_event : AInputEvent*) : Int64
    {% if ANDROID_API >= 31 %}
      fun AKeyEvent_fromJava(env : JNIEnv*, keyEvent : JObject) : AInputEvent*
    {% end %}

    fun AMotionEvent_getAction(motion_event : AInputEvent*) : Int32
    fun AMotionEvent_getFlags(motion_event : AInputEvent*) : Int32
    fun AMotionEvent_getMetaState(motion_event : AInputEvent*) : Int32
    fun AMotionEvent_getButtonState(motion_event : AInputEvent*) : Int32
    fun AMotionEvent_getEdgeFlags(motion_event : AInputEvent*) : Int32
    fun AMotionEvent_getDownTime(motion_event : AInputEvent*) : Int64
    fun AMotionEvent_getEventTime(motion_event : AInputEvent*) : Int64
    fun AMotionEvent_getXOffset(motion_event : AInputEvent*) : Float
    fun AMotionEvent_getYOffset(motion_event : AInputEvent*) : Float
    fun AMotionEvent_getXPrecision(motion_event : AInputEvent*) : Float
    fun AMotionEvent_getYPrecision(motion_event : AInputEvent*) : Float
    fun AMotionEvent_getPointerCount(motion_event : AInputEvent*) : SizeT
    fun AMotionEvent_getPointerId(motion_event : AInputEvent*, pointer_index : SizeT) : Int32
    fun AMotionEvent_getToolType(motion_event : AInputEvent*, pointer_index : SizeT) : Int32
    fun AMotionEvent_getRawX(motion_event : AInputEvent*, pointer_index : SizeT) : Float
    fun AMotionEvent_getRawY(motion_event : AInputEvent*, pointer_index : SizeT) : Float
    fun AMotionEvent_getX(motion_event : AInputEvent*, pointer_index : SizeT) : Float
    fun AMotionEvent_getY(motion_event : AInputEvent*, pointer_index : SizeT) : Float
    fun AMotionEvent_getPressure(motion_event : AInputEvent*, pointer_index : SizeT) : Float
    fun AMotionEvent_getSize(motion_event : AInputEvent*, pointer_index : SizeT) : Float
    fun AMotionEvent_getTouchMajor(motion_event : AInputEvent*, pointer_index : SizeT) : Float
    fun AMotionEvent_getTouchMinor(motion_event : AInputEvent*, pointer_index : SizeT) : Float
    fun AMotionEvent_getToolMajor(motion_event : AInputEvent*, pointer_index : SizeT) : Float
    fun AMotionEvent_getToolMinor(motion_event : AInputEvent*, pointer_index : SizeT) : Float
    fun AMotionEvent_getOrientation(motion_event : AInputEvent*, pointer_index : SizeT) : Float
    fun AMotionEvent_getAxisValue(motion_event : AInputEvent*, axis : Int32, pointer_index : SizeT) : Float
    fun AMotionEvent_getHistorySize(motion_event : AInputEvent*) : SizeT
    fun AMotionEvent_getHistoricalEventTime(motion_event : AInputEvent*, history_index : SizeT) : Int64
    fun AMotionEvent_getHistoricalRawX(motion_event : AInputEvent*, pointer_index : SizeT, history_index : SizeT) : Float
    fun AMotionEvent_getHistoricalRawY(motion_event : AInputEvent*, pointer_index : SizeT, history_index : SizeT) : Float
    fun AMotionEvent_getHistoricalX(motion_event : AInputEvent*, pointer_index : SizeT, history_index : SizeT) : Float
    fun AMotionEvent_getHistoricalY(motion_event : AInputEvent*, pointer_index : SizeT, history_index : SizeT) : Float
    fun AMotionEvent_getHistoricalPressure(motion_event : AInputEvent*, pointer_index : SizeT, history_index : SizeT) : Float
    fun AMotionEvent_getHistoricalSize(motion_event : AInputEvent*, pointer_index : SizeT, history_index : SizeT) : Float
    fun AMotionEvent_getHistoricalTouchMajor(motion_event : AInputEvent*, pointer_index : SizeT, history_index : SizeT) : Float
    fun AMotionEvent_getHistoricalTouchMinor(motion_event : AInputEvent*, pointer_index : SizeT, history_index : SizeT) : Float
    fun AMotionEvent_getHistoricalToolMajor(motion_event : AInputEvent*, pointer_index : SizeT, history_index : SizeT) : Float
    fun AMotionEvent_getHistoricalToolMinor(motion_event : AInputEvent*, pointer_index : SizeT, history_index : SizeT) : Float
    fun AMotionEvent_getHistoricalOrientation(motion_event : AInputEvent*, pointer_index : SizeT, history_index : SizeT) : Float
    fun AMotionEvent_getHistoricalAxisValue(motion_event : AInputEvent*, axis : Int32, pointer_index : SizeT, history_index : SizeT) : Float
    {% if ANDROID_API >= ANDROID_API_T %}
      fun AMotionEvent_getActionButton(motion_event : AInputEvent*) : Int32
      fun AMotionEvent_getClassification(motion_event : AInputEvent*) : Int32
    {% end %}
    {% if ANDROID_API >= 31 %}
      fun AMotionEvent_fromJava(env : JNIEnv*, motionEvent : JObject) : AInputEvent*
    {% end %}

    alias AInputQueue = Void

    fun AInputQueue_attachLooper(queue : AInputQueue*, looper : ALooper*, ident : Int, callback : ALooper_callbackFunc, data : Void*)
    fun AInputQueue_detachLooper(queue : AInputQueue*)
    fun AInputQueue_hasEvents(queue : AInputQueue*) : Int32
    fun AInputQueue_getEvent(queue : AInputQueue*, outEvent : AInputEvent**) : Int32
    fun AInputQueue_preDispatchEvent(queue : AInputQueue*, event : AInputEvent*) : Int32
    fun AInputQueue_finishEvent(queue : AInputQueue*, event : AInputEvent*, handled : Int)
    {% if ANDROID_API >= 33 %}
      fun AInputQueue_fromJava(env : JNIEnv*, inputQueue : JObject) : AInputQueue*
    {% end %}
  end
end
