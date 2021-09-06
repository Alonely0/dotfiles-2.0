import Graphics.X11.ExtraTypes.XF86
    ( xF86XK_AudioLowerVolume,
      xF86XK_AudioRaiseVolume,
      xF86XK_AudioMute,
      xF86XK_MonBrightnessDown,
      xF86XK_MonBrightnessUp,
      xF86XK_AudioPlay,
      xF86XK_AudioPrev,
      xF86XK_AudioNext )
import qualified Data.Map as M
import Data.Maybe ( maybeToList )
import Data.Monoid ()
import XMonad
import XMonad.Actions.CycleWS
import XMonad.Layout
import XMonad.Layout.Hidden
import XMonad.Layout.CenteredMaster
import XMonad.Layout.Grid
import XMonad.Layout.Spiral
import XMonad.Layout.IfMax
import XMonad.Layout.Fullscreen
    ( fullscreenEventHook,
    fullscreenManageHook,
    fullscreenSupport,
    fullscreenFull )
import XMonad.Layout.Spacing ( spacingRaw, Border(Border) )
import XMonad.Layout.Gaps
    ( Direction2D(D, L, R, U),
      gaps,
      setGaps,
      GapMessage(DecGap, ToggleGaps, IncGap) )
import XMonad.Util.SpawnOnce ( spawnOnce )
import XMonad.Hooks.EwmhDesktops ( ewmh )
import Control.Monad ( join, when )
import XMonad.Hooks.ManageDocks
    ( avoidStruts,
    docks,
    manageDocks,
    Direction2D(D, L, R, U) )
import XMonad.Hooks.ManageHelpers ( doFullFloat, isFullscreen )
import qualified XMonad.StackSet as W

-- Preferred terminal program
myTerminal           = "alacritty"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse  :: Bool
myFocusFollowsMouse  = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses   :: Bool
myClickJustFocuses   = False

-- Width of the window border in pixels.
myBorderWidth        = 2

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "super key (normally windows key)" is usually mod4Mask.
myModMask            = mod4Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
myWorkspaces         = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]

-- Border colors for unfocused and focused windows, respectively.
myNormalBorderColor  = "#32302f"
myFocusedBorderColor = "#5e5e5e"

addNETSupported      :: Atom -> X ()
addNETSupported x    = withDisplay $ \dpy -> do
    r               <- asks theRoot
    a_NET_SUPPORTED <- getAtom "_NET_SUPPORTED"
    a               <- getAtom "ATOM"
    liftIO $ do
       sup <- (join . maybeToList) <$> getWindowProperty32 dpy a_NET_SUPPORTED r
       when (fromIntegral x `notElem` sup) $
         changeProperty32 dpy r a_NET_SUPPORTED a propModeAppend [fromIntegral x]

addEWMHFullscreen    :: X ()
addEWMHFullscreen    = do
    wms <- getAtom "_NET_WM_STATE"
    wfs <- getAtom "_NET_WM_STATE_FULLSCREEN"
    mapM_ addNETSupported [wms, wfs]

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
myKeys conf@(XConfig { XMonad.modMask = modm }) = M.fromList $
    -- Show all windows
    [ ((modm,                 xK_p                    ), spawn "rofi -show window")

    -- Cycle non-empty workspaces with mod+tab or mod+shift+tab
    , ((modm,                 xK_Tab                  ), moveTo Next NonEmptyWS)
    , ((modm .|. shiftMask,   xK_Tab                  ), moveTo Prev NonEmptyWS)
    
    -- launch rofi and dashboard
    , ((modm,                 xK_o                    ), spawn "rofi -show drun")
    
    -- Lock screen
    ,((modm,                  xK_BackSpace            ), spawn "xautolock -locknow")

    -- Audio keys
    , ((0,                    xF86XK_AudioPlay        ), spawn "playerctl play-pause")
    , ((0,                    xF86XK_AudioPrev        ), spawn "playerctl previous")
    , ((0,                    xF86XK_AudioNext        ), spawn "playerctl next")
    , ((0,                    xF86XK_AudioRaiseVolume ), spawn "pactl set-sink-volume 0 +5%")
    , ((0,                    xF86XK_AudioLowerVolume ), spawn "pactl set-sink-volume 0 -5%")
    , ((0,                    xF86XK_AudioMute        ), spawn "pactl set-sink-mute 0 toggle")

    -- Brightness keys
    , ((0,                    xF86XK_MonBrightnessUp  ), spawn "brightnessctl s +10%")
    , ((0,                    xF86XK_MonBrightnessDown), spawn "brightnessctl s 10-%")
 
    -- close focused window
    , ((modm .|. shiftMask,   xK_c                    ), kill)

    -- Rotate through the available layout algorithms
    , ((modm,                 xK_space                ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask,   xK_space                ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm,                 xK_n                    ), refresh)

    -- Move focus to the next window
    , ((modm,                 xK_Tab                  ), windows W.focusDown)
  
    -- Move focus to the next window
    , ((modm,                 xK_j                    ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,                 xK_k                    ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,                 xK_apostrophe           ), windows W.focusMaster)

    -- Swap the focused window and the master window
    , ((modm,                 xK_semicolon            ), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask,   xK_j                    ), windows W.swapDown)

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask,   xK_k                    ), windows W.swapUp)

    -- Shrink the master area
    , ((modm,                 xK_h                    ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,                 xK_l                    ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,                 xK_t                    ), withFocused $ windows . W.sink)

    -- Quit xmonad
    , ((modm .|. shiftMask,   xK_q                    ), spawn "killall xmonad-x86_64-l")

    -- Restart xmonad
    , ((modm,                 xK_q                    ), spawn "xmonad --recompile; xmonad --restart")
   ]
    ++

    -- mod+[N where N = 1-9] = Switch to workspace N
    -- mod+shift+[N where = 1-9] = Move client to workspace N
    [ ((m .|. modm,           k                       ), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    -- mod+[wer], Switch to physical/Xinerama screens 1, 2, or 3
    -- mod+shift+[wer], Move client to screen 1, 2, or 3
    [ ((m .|. modm,           key                     ), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
myMouseBindings (XConfig { XMonad.modMask = modm }) = M.fromList $
    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
myLayout = avoidStruts(inlay ||| Mirror l_tiled ||| centerMaster Grid ||| Full)
  where
     -- optimize space by changing between tiled and spiral
     -- algorithms depending on the number of windows
     inlay    = ifMax limit l_tiled (l_spiral)
     limit    = 4

     -- default spiral algorithm moves windows & sizes them creating
     -- a fibonacci spiral
     l_spiral = spiral sp_ratio
     sp_ratio = 6/7

     -- default tiling algorithm partitions the screen into two panes
     l_tiled    = Tall nmaster delta tl_ratio
     nmaster  = 1
     tl_ratio = 1/2
     delta    = 3/100

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- $ xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
myManageHook = fullscreenManageHook <+> manageDocks <+> composeAll
    [ className =?  "MPlayer"        --> doFloat
    , className =?  "Xmessage"       --> doFloat
    , className =?  "Gimp-2.99"      --> doFloat
    , resource  =?  "desktop_window" --> doIgnore
    , isFullscreen                   --> doFullFloat
    ]

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
myEventHook = mempty

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
myLogHook   = return ()

-----------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts
myStartupHook = do
  spawnOnce "xrandr --output HDMI-1-0 --primary --left-of HDMI-1-0 --output HDMI-1-0 --auto --right-of eDP-1"
  spawnOnce "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"
  spawnOnce "picom -f"
  spawnOnce "dunst"
  spawnOnce "feh --bg-scale ~/wallpaper.png"
  spawnOnce "polybar main"
  spawnOnce "~/.gem/ruby/3.0.0/bin/fusuma"
  -- uncomment the line below if you have a ROG laptop. for more info see the installation section in the readme
  -- spawnOnce "$HOME/bin/rog_bindings"
  spawnOnce "xautolock -time 5 -locker 'sh -c \"maim /tmp/lock.png; betterlockscreen --update /tmp/lock.png --fx blur --blur 2.3 > /dev/null; betterlockscreen -l blur > /dev/null\"'"

------------------------------------------------------------------------
-- Setup config and run xmonad (no need to modify this)

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
cfg = def {
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,
        keys               = myKeys,
        mouseBindings      = myMouseBindings,
        manageHook         = myManageHook, 
        layoutHook         = gaps [(L,7), (R,7), (U,7), (D,7)] $ spacingRaw True (Border 7 7 7 7) True (Border 7 7 7 7) True $ myLayout,
        handleEventHook    = myEventHook,
        logHook            = myLogHook,
        startupHook        = myStartupHook >> addEWMHFullscreen
    }

-- Run xmonad with the settings you specify.
main :: IO ()
main = xmonad $ fullscreenSupport $ docks $ ewmh cfg

