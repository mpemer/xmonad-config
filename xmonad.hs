-- xmonad config used by Vic Fryzel
-- Author: Vic Fryzel
-- http://github.com/vicfryzel/xmonad-config

import System.IO
import System.Exit
import XMonad
import XMonad.Actions.Navigation2D
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Layout.Fullscreen
import XMonad.Layout.NoBorders
import XMonad.Layout.Spiral
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns
import XMonad.Layout.ResizableTile
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import qualified XMonad.StackSet as W
import qualified Data.Map        as M


------------------------------------------------------------------------
-- Terminal
-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal = "/usr/bin/konsole"

-- The command to lock the screen or show the screensaver.
myScreensaver = "/usr/bin/gnome-screensaver-command --lock"

-- The command to take a selective screenshot, where you select
-- what you'd like to capture on the screen.
mySelectScreenshot = "shutter -s"

-- The command to take a fullscreen screenshot.
myScreenshot = "shutter f"

-- The command to use as a launcher, to launch commands that don't have
-- preset keybindings.
myLauncher = "$(yeganesh -x -- -fn '-*-terminus-*-r-normal-*-*-120-*-*-*-*-iso8859-*' -nb '#000000' -nf '#FFFFFF' -sb '#7C7C7C' -sf '#CEFFAC')"


------------------------------------------------------------------------
-- Workspaces
-- The default number of workspaces (virtual screens) and their names.
--
myWorkspaces = ["0:term","1:emacs","2:chromium","3:chrome","4:-","5:-","6:-","7:-","8:-","9:-","10:chat","11:vm","12:vpn"] ++ map show [6..9]


------------------------------------------------------------------------
-- Window rules
-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
    [ className =? "chromium-browser"   --> doShift "2:chromium"
    , className =? "Google-chrome"      --> doShift "3:chrome"
    , resource  =? "desktop_window"     --> doIgnore
    , className =? "Galculator"         --> doFloat
    , className =? "Steam"              --> doFloat
    , className =? "Gimp"               --> doFloat
    , resource  =? "gpicview"           --> doFloat
    , className =? "MPlayer"            --> doFloat
    , className =? "Xchat"              --> doShift "10:chat"
    , className =? "VirtualBox"         --> doShift "11:vm"
    , className =? "Firefox"            --> doShift "12:vpn"
    , className =? "stalonetray"        --> doIgnore
    , isFullscreen --> (doF W.focusDown <+> doFullFloat)]


------------------------------------------------------------------------
-- Layouts
-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
myLayout = avoidStruts (
    -- ThreeColMid 1 (3/100) (1/2) |||
    -- Tall 1 (3/100) (1/2) |||
    ResizableTall 1 (3/100) (1/2) [] |||
    spiral (6/7)) |||
    -- Mirror (Tall 1 (3/100) (1/2)) |||
    tabbed shrinkText tabConfig |||
    Full |||
    noBorders (fullscreenFull Full)


------------------------------------------------------------------------
-- Colors and borders
-- Currently based on the ir_black theme.
--
myNormalBorderColor  = "#7c7c7c"
myFocusedBorderColor = "#ffb6b0"

-- Colors for text and backgrounds of each tab when in "Tabbed" layout.
tabConfig = defaultTheme {
    activeBorderColor = "#7C7C7C",
    activeTextColor = "#CEFFAC",
    activeColor = "#000000",
    inactiveBorderColor = "#7C7C7C",
    inactiveTextColor = "#EEEEEE",
    inactiveColor = "#000000"
}

-- Color of current window title in xmobar.
xmobarTitleColor = "#FFB6B0"

-- Color of current workspace in xmobar.
xmobarCurrentWorkspaceColor = "#CEFFAC"

-- Width of the window border in pixels.
myBorderWidth = 1


------------------------------------------------------------------------
-- Key bindings
--
-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask = mod4Mask

myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
  ----------------------------------------------------------------------
  -- Custom key bindings
  --

  -- Start a terminal.  Terminal to start is specified by myTerminal variable.
  [ ((modMask .|. shiftMask, xK_Return),
     spawn $ XMonad.terminal conf)

  -- Lock the screen using command specified by myScreensaver.
  , ((modMask .|. controlMask, xK_l),
     spawn myScreensaver)

  -- Spawn the launcher using command specified by myLauncher.
  -- Use this to launch programs without a key binding.
  , ((modMask, xK_p),
     spawn myLauncher)

  -- Take a selective screenshot using the command specified by mySelectScreenshot.
  , ((modMask .|. shiftMask, xK_p),
     spawn mySelectScreenshot)

  -- Take a full screenshot using the command specified by myScreenshot.
  , ((modMask .|. controlMask .|. shiftMask, xK_p),
     spawn myScreenshot)

  -- mute button
  , ((0, 0x1008FF12),
     spawn "/home/mpemer/src/xmonad-pulsevolume/pulse-volume.sh toggle")

  -- volumeup button
  , ((0, 0x1008FF13),
     spawn "/home/mpemer/src/xmonad-pulsevolume/pulse-volume.sh increase")

  -- volumedown button
  , ((0, 0x1008FF11),
     spawn "/home/mpemer/src/xmonad-pulsevolume/pulse-volume.sh decrease")

  -- mute button
  , ((0, 0x1008ffb2),
     spawn "/home/mpemer/src/xmonad-pulsevolume/pulse-volume.sh mictoggle")

  -- volumeup button
  , ((controlMask, 0x1008FF13),
     spawn "/home/mpemer/src/xmonad-pulsevolume/pulse-volume.sh micincrease")

  -- volumedown button
  , ((controlMask, 0x1008FF11),
     spawn "/home/mpemer/src/xmonad-pulsevolume/pulse-volume.sh micdecrease")

  -- backlightdown button
  , ((0, 0x1008FF03),
     spawn "xbacklight -dec 10")

  -- backlightup button
  , ((0, 0x1008FF02),
     spawn "xbacklight -inc 10")

  -- wifi button
  , ((0, 0x1008ff95),
     spawn "if [ \"$(nmcli r wifi)\" = \"enabled\" ]; then nmcli r wifi off; else nmcli r wifi on; fi")

  , ((controlMask, 0x1008ff95),
     spawn "if [ \"$(nmcli r wwan)\" = \"enabled\" ]; then nmcli r wwan off; else nmcli r wwan on; fi")

  -- Audio previous.
  , ((0, 0x1008FF16),
     spawn "")

  -- Play/pause.
  , ((0, 0x1008FF14),
     spawn "")

  -- Audio next.
  , ((0, 0x1008FF17),
     spawn "")

  -- Eject CD tray.
  , ((0, 0x1008FF2C),
     spawn "eject -T")

--  : wireless button

  --------------------------------------------------------------------
  -- "Standard" xmonad key bindings
  --

  -- Close focused window.
  , ((modMask .|. shiftMask, xK_c),
     kill)

  -- Cycle through the available layout algorithms.
  , ((modMask, xK_space),
     sendMessage NextLayout)

  --  Reset the layouts on the current workspace to default.
  , ((modMask .|. shiftMask, xK_space),
     setLayout $ XMonad.layoutHook conf)

  -- Resize viewed windows to the correct size.
  , ((modMask, xK_n),
     refresh)

  -- Move focus to the next window.
  , ((modMask, xK_Tab),
     windows W.focusDown)

  -- Move focus to the next window.
  , ((modMask, xK_j),
     windows W.focusDown)

  -- Move focus to the previous window.
  , ((modMask, xK_k),
     windows W.focusUp  )

  -- Move focus to the master window.
  , ((modMask, xK_m),
     windows W.focusMaster  )

  -- Swap the focused window and the master window.
  , ((modMask, xK_Return),
     windows W.swapMaster)

  -- Swap the focused window with the next window.
  , ((modMask .|. shiftMask, xK_j),
     windows W.swapDown  )

  -- Swap the focused window with the previous window.
  , ((modMask .|. shiftMask, xK_k),
     windows W.swapUp    )

  -- Shrink the master area.
  , ((modMask, xK_h),
     sendMessage Shrink)
  , ((modMask .|. shiftMask, xK_Left), sendMessage Shrink)

  -- Expand the master area.
  , ((modMask, xK_l),
     sendMessage Expand)
  , ((modMask .|. shiftMask, xK_Right), sendMessage Expand)

  -- Push window back into tiling.
  , ((modMask, xK_t),
     withFocused $ windows . W.sink)

  -- Increment the number of windows in the master area.
  , ((modMask, xK_comma),
     sendMessage (IncMasterN 1))

  -- Decrement the number of windows in the master area.
  , ((modMask, xK_period),
     sendMessage (IncMasterN (-1)))

  -- Toggle the status bar gap.
  -- TODO: update this binding with avoidStruts, ((modMask, xK_b),

  -- Quit xmonad.
  , ((modMask .|. shiftMask, xK_q),
     io (exitWith ExitSuccess))

  -- Restart xmonad.
  , ((modMask, xK_q),
     restart "xmonad" True)

  -- Resizable Tall
  , ((modMask, xK_a), sendMessage MirrorShrink)
  , ((modMask .|. shiftMask, xK_Down), sendMessage MirrorShrink)
  , ((modMask, xK_z), sendMessage MirrorExpand)
  , ((modMask .|. shiftMask, xK_Up), sendMessage MirrorExpand)


    -- Switch between layers
  , ((modMask,                 xK_space), switchLayer)
    
    -- Directional navigation of windows
  , ((modMask,                 xK_Right), windowGo R False)
  , ((modMask,                 xK_Left ), windowGo L False)
  , ((modMask,                 xK_Up   ), windowGo U False)
  , ((modMask,                 xK_Down ), windowGo D False)
    
    -- Swap adjacent windows
  , ((modMask .|. controlMask, xK_Right), windowSwap R False)
  , ((modMask .|. controlMask, xK_Left ), windowSwap L False)
  , ((modMask .|. controlMask, xK_Up   ), windowSwap U False)
  , ((modMask .|. controlMask, xK_Down ), windowSwap D False)
    
    -- Directional navigation of screens
  , ((modMask,                 xK_r    ), screenGo R False)
  , ((modMask,                 xK_l    ), screenGo L False)
  , ((modMask,                 xK_u    ), screenGo U False)
  , ((modMask,                 xK_d    ), screenGo D False)
    
    -- Swap workspaces on adjacent screens
  , ((modMask .|. controlMask, xK_r    ), screenSwap R False)
  , ((modMask .|. controlMask, xK_l    ), screenSwap L False)
  , ((modMask .|. controlMask, xK_u    ), screenSwap U False)
  , ((modMask .|. controlMask, xK_d    ), screenSwap D False)
    
    -- Send window to adjacent screen
  , ((modMask .|. mod1Mask,    xK_r    ), windowToScreen R False)
  , ((modMask .|. mod1Mask,    xK_l    ), windowToScreen L False)
  , ((modMask .|. mod1Mask,    xK_u    ), windowToScreen U False)
  , ((modMask .|. mod1Mask,    xK_d    ), windowToScreen D False)
  ]
  ++

  -- mod-[1..9,0], Switch to workspace N
  -- mod-shift-[1..9,0], Move client to workspace N
  [((m .|. modMask, k), windows $ f i)
      | (i, k) <- zip (XMonad.workspaces conf) [xK_grave,xK_1, xK_2, xK_3, xK_4, xK_5, xK_6, xK_7, xK_8, xK_9, xK_0, xK_minus, xK_equal]
      , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
--  ++

-- This was the old numbered list range
--      | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]

  -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
  -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
--  [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
--      | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
--      , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


------------------------------------------------------------------------
-- Mouse bindings
--
-- Focus rules
-- True if your focus should follow your mouse cursor.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $
  [
    -- mod-button1, Set the window to floating mode and move by dragging
    ((modMask, button1),
     (\w -> focus w >> mouseMoveWindow w))

    -- mod-button2, Raise the window to the top of the stack
    , ((modMask, button2),
       (\w -> focus w >> windows W.swapMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modMask, button3),
       (\w -> focus w >> mouseResizeWindow w))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
  ]


------------------------------------------------------------------------
-- Status bars and logging
-- Perform an arbitrary action on each internal state change or X event.
-- See the 'DynamicLog' extension for examples.
--
-- To emulate dwm's status bar
--
-- > logHook = dynamicLogDzen
--


------------------------------------------------------------------------
-- Startup hook
-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = return ()


------------------------------------------------------------------------
-- Run xmonad with all the defaults we set up.
--
main = do
  xmproc <- spawnPipe "xmobar ~/.xmonad/xmobar.hs"
  xmonad $ withNavigation2DConfig defaultNavigation2DConfig $ defaults {
      logHook = dynamicLogWithPP $ xmobarPP {
            ppOutput = hPutStrLn xmproc
          , ppTitle = xmobarColor xmobarTitleColor "" . shorten 100
          , ppCurrent = xmobarColor xmobarCurrentWorkspaceColor ""
          , ppSep = "   "
      }
      , manageHook = manageDocks <+> myManageHook
      , startupHook = setWMName "LG3D"
  }


------------------------------------------------------------------------
-- Combine it all together
-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
defaults = defaultConfig {
    -- simple stuff
    terminal           = myTerminal,
    focusFollowsMouse  = myFocusFollowsMouse,
    borderWidth        = myBorderWidth,
    modMask            = myModMask,
    workspaces         = myWorkspaces,
    normalBorderColor  = myNormalBorderColor,
    focusedBorderColor = myFocusedBorderColor,

    -- key bindings
    keys               = myKeys,
    mouseBindings      = myMouseBindings,

    -- hooks, layouts
    layoutHook         = smartBorders $ myLayout,
    manageHook         = myManageHook,
    startupHook        = myStartupHook
}
