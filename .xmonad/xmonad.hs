------------------------------------------------------------------------
-- import
------------------------------------------------------------------------

import XMonad hiding ( (|||) ) -- jump to layout
import XMonad.Layout.LayoutCombinators (JumpToLayout(..), (|||)) -- jump to layout
import XMonad.Config.Desktop
import System.Exit
import System.Directory                  (getCurrentDirectory)
import qualified XMonad.StackSet as W
import XMonad.Layout.IfMax
import Control.Monad (liftM,liftM2, zipWithM_)

-- data
import Data.Char (isSpace, toUpper)
import qualified Data.List as L
import Data.Monoid
import Data.Maybe (isJust, fromMaybe)
import Data.Ratio ((%)) -- for video
import Data.Default.Class (def)
import qualified Data.Map as M

-- system
import System.IO (hPutStrLn, Handle) -- for xmobar

-- util
import XMonad.Util.Run (safeSpawn, unsafeSpawn, runInTerm, spawnPipe)
import XMonad.Util.SpawnOnce
import XMonad.Util.EZConfig (additionalKeysP, additionalMouseBindings)
import XMonad.Util.NamedWindows
import XMonad.Util.WorkspaceCompare

-- hooks
import XMonad.Hooks.DynamicLog (xmobarPP, dynamicLogWithPP, ppOutput, ppCurrent, ppVisible, ppHidden, ppHiddenNoWindows, ppTitle, ppUrgent, ppExtras, ppOrder, ppSep, ppWsSep, ppLayout, ppSort, shorten, wrap, xmobarColor, xmobarAction)
import qualified XMonad.Hooks.StatusBar as Bars
import XMonad.Hooks.ManageDocks (avoidStruts, docksStartupHook, manageDocks, ToggleStruts(..))
import XMonad.Hooks.EwmhDesktops -- to show workspaces in application switchers
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.RefocusLast
import XMonad.Hooks.SetWMName

-- actions
import qualified XMonad.Actions.Search      as S
import XMonad.Actions.CycleWindows
import XMonad.Actions.PhysicalScreens
import XMonad.Actions.GroupNavigation
import XMonad.Actions.CycleWS
import qualified XMonad.Actions.Navigation2D as Nav2D
import XMonad.Actions.CopyWindow -- for dwm window style tagging
import XMonad.Actions.Warp

-- layout
import XMonad.Layout.SimplestFloat
import XMonad.Layout.TrackFloating
import XMonad.Layout.NoFrillsDecoration
import XMonad.Layout.ThreeColumns
import XMonad.Layout.Simplest
import XMonad.Layout.TabBarDecoration
import XMonad.Layout.Tabbed
import XMonad.Layout.Renamed (renamed, Rename(Replace))
import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing
import XMonad.Layout.ResizableTile
import XMonad.Layout.SubLayouts
import XMonad.Layout.WindowNavigation
import XMonad.Layout.IndependentScreens as IS

------------------------------------------------------------------------
-- variables
------------------------------------------------------------------------

myModMask = mod4Mask -- Sets modkey to super/windows key
myTerminal = "st" -- Sets default terminal
myBorderWidth = 0 -- Sets border width for windows
myNormalBorderColor = "#839496"
myFocusedBorderColor = "#268BD2"
myppCurrentFg = "#000000"
myppCurrentBg = "#ffffff:9"
myppVisibleBg = "#777777:9"
myppVisibleBgCur = "#777777:9"
myppVisibleBgFocus = "#ffffff:9"
myppHiddenFg = "#000000"
myppHiddenBg = "#333333:9"
myppHiddenNoWindowsFg = "#444444"
myppHiddenNoWindowsBg = "#151515:9"
myppTitle = "#FDF6E3"
myppUrgent = "#DC322F"

xmobarEscape = concatMap doubleLts
  where doubleLts '<' = "<<"
        doubleLts x   = [x]

myWorkspaces :: [String]
myWorkspaces = clickable . (map xmobarEscape) $ ["  1  ","  2  ","  3  ","  4  ","  5  ","  6  ","  7  ","  8  ","  9  ",  "  0  "]
  where
         clickable l = [ "<action=xdotool key super+" ++ show (n) ++ ">" ++ ws ++ "</action>" |
                             (i,ws) <- zip ([1..9] ++ [0]) l,
                            let n = i ]

windowCount :: X (Maybe String)
windowCount = Just . show . length . W.index . windowset <$> get


------------------------------------------------------------------------
-- desktop notifications -- dunst package required
------------------------------------------------------------------------

data LibNotifyUrgencyHook = LibNotifyUrgencyHook deriving (Read, Show)

instance UrgencyHook LibNotifyUrgencyHook where
    urgencyHook LibNotifyUrgencyHook w = do
        name     <- getName w
        Just idx <- fmap (W.findTag w) $ gets windowset

        safeSpawn "notify-send" [show name, "workspace " ++ idx]

------------------------------------------------------------------------
-- Startup hook
------------------------------------------------------------------------

myStartupHook = do
  spawnOnce "/home/bndo/bin/autostart.sh &"


------------------------------------------------------------------------
-- layout
------------------------------------------------------------------------

base03  = "#000000"
base02  = "#073642"
base01  = "#586e75"
base00  = "#30374d"
base0   = "#839496"
base1   = "#93a1a1"
base2   = "#eee8d5"
base3   = "#fdf6e3"
grey    = "#bbbbbb"
yellow  = "#b58900"
orange  = "#cb4b16"
red     = "#dc322f"
magenta = "#d33682"
violet  = "#6c71c4"
white  = "#ffffff"
blue    = "#268bd2"
cyan    = "#2aa198"
green       = "#859900"

-- sizes
gap         = 8
topbar      = 23
border      = 0
prompt      = 20
status      = 20

active      = base00
activeWarn  = red
inactive    = base02
focusColor  = blue
unfocusColor = base02

myFont      = "xft:Consolas:size=10"
myBigFont   = "xft:Monego:pixelsize=120"
-- myBigFont   = "-*-helvetica-medium-*-*-*-*-240-*-*-*-*-*-*"
-- this is a "fake title" used as a highlight bar in lieu of full borders
-- (I find this a cleaner and less visually intrusive solution)
topBarTheme = def
    { fontName              = myFont
    , inactiveBorderColor   = base03
    , inactiveColor         = base03
    , inactiveTextColor     = base03
    , activeBorderColor     = active
    , activeColor           = active
    , activeTextColor       = white
    , urgentBorderColor     = red
    , urgentTextColor       = yellow
    , decoHeight            = topbar
    }

myTabTheme = def
    { fontName              = myFont
    , inactiveBorderColor   = base03
    , inactiveColor         = base03
    , inactiveTextColor     = white
    , activeBorderColor     = white
    , activeColor           = white
    , activeTextColor       = base03
    , decoHeight            = topbar
    }

myLayout = avoidStruts $ (trackFloating (tiled ||| full ||| cMaster ||| float))
  where
     -- full
     full = renamed [Replace "Full"]
       -- $ windowNavigation
       -- $ addTabs shrinkText myTabTheme $ subLayout [] Simplest
       $ spacingRaw False (Border gap 0 0 0) True (Border 0 0 0 0) True
       $ configurableNavigation noNavigateBorders $ noBorders (Full)

     -- tiled
     tiled = renamed [Replace "Tile"]
       -- $ ifMax 1 (spacingRaw False (Border 30 0 30 0) True (Border 0 30 0 30) True
       -- $ ResizableTall 1 (3/100) (3/5) [])

       -- $ noFrillsDeco shrinkText topBarTheme
       -- $ windowNavigation $ subTabbed
       $ addTabs shrinkText myTabTheme $ subLayout [] Simplest
       $ spacingRaw False (Border 0 gap 0 gap) True (Border gap 0 gap 0) True
       $ configurableNavigation noNavigateBorders $ ResizableTall 1 (3/100) (3/5) []

     -- grid
     cMaster = renamed [Replace "CM"]
       -- $ ifMax 1 (spacingRaw False (Border gap 0 gap 0) True (Border 0 gap 0 gap) True
                  -- $ ResizableTall 1 (3/100) (3/5) [])

       -- $ noFrillsDeco shrinkText topBarTheme
       $ addTabs shrinkText myTabTheme $ subLayout [] Simplest
       $ spacingRaw False (Border gap 0 gap 0) True (Border 0 gap 0 gap) True
       $ configurableNavigation noNavigateBorders $ ThreeColMid 1 (3/100) (1/2)

     -- bsp
     float = renamed [Replace "Float"]
       -- $ ifMax 1 (spacingRaw False (Border gap 0 gap 0) True (Border 0 gap 0 gap) True
       -- $ ResizableTall 1 (3/100) (3/5) [])

       -- $ noFrillsDeco shrinkText topBarTheme
       $ configurableNavigation noNavigateBorders $ simplestFloat

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 3/5

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

------------------------------------------------------------------------
-- Window rules:
------------------------------------------------------------------------

myManageHook = composeAll
    [ className =? "mpv"            --> doRectFloat (W.RationalRect (1 % 4) (1 % 4) (1 % 2) (1 % 2))
    , className =? "Gimp"           --> doFloat
    , className =? "Pavucontrol"    --> doShift (myWorkspaces !! 5)
    , className =? "feh"            --> doFloat
    , className =? "Firefox" <&&> resource =? "Toolkit" --> doFloat -- firefox pip
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore
    , isFullscreen --> doFullFloat
    , transience'
    ]


focusedTitleOnScreen :: ScreenId -> X (String -> String)
focusedTitleOnScreen n = do
    ws <- gets windowset
    let ss = (W.current ws) : (W.visible ws)
        s  = L.find ((n==) . W.screen) ss
        t  = maybe Nothing
                   (W.stack . W.workspace)
                   s
    m <- maybe (return "<empty>")
               (fmap show . getName . W.focus)
               t
    let x = if n == (W.screen . W.current) ws
               then xmobarColor myppCurrentFg myppCurrentBg . wrap " " " " . shorten 30 $ m
               else xmobarColor "grey"  ""  . shorten 30 $ m
    return (\ _ -> x)

workspaceOnScreen :: ScreenId -> X (String -> String)
workspaceOnScreen n = do
   w <- gets windowset
   let tag = fromMaybe "<???>" $ W.lookupWorkspace n w
       foc = W.currentTag w
       fmt1 = if tag == foc then cur else vis
          where
            cur = xmobarColor myppCurrentFg myppCurrentBg
            vis = xmobarColor myppCurrentFg myppVisibleBgCur
   return fmt1

visibleOnScreen :: ScreenId -> X (String -> String)
visibleOnScreen n = do
   w <- gets windowset
   let tag = fromMaybe "<???>" $ W.lookupWorkspace n w
       foc = W.currentTag w
       fmt1 = if tag == foc then cur else vis
          where
            cur = xmobarColor myppCurrentFg myppVisibleBg
            vis = xmobarColor myppCurrentFg myppVisibleBgFocus
   return fmt1

layoutOnScreen :: ScreenId -> X (String -> String)
layoutOnScreen n = do
   w <- gets windowset
   let tag = fromMaybe "<???>" $ W.lookupWorkspace n w
       foc = W.currentTag w
       fmt1 = if tag == foc then cur else vis
          where
            cur = xmobarColor myppCurrentFg myppCurrentBg
            vis = xmobarColor myppHiddenNoWindowsBg myppHiddenNoWindowsBg
   return fmt1

myLogHook :: XConfig l -> Handle -> Handle -> X ()
myLogHook c u0 u1 = do
    g0 <- focusedTitleOnScreen 0
    g1 <- focusedTitleOnScreen 1
    h0 <- Main.workspaceOnScreen 0
    h1 <- Main.workspaceOnScreen 1
    v0 <- visibleOnScreen 0
    v1 <- visibleOnScreen 1
    l0 <- layoutOnScreen 0
    l1 <- layoutOnScreen 1

    idHook
       <+> dynamicLogWithPP (topPP u0 g0 h0 v0 l0)
       <+> dynamicLogWithPP (topPP u1 g1 h1 v1 l1)
       <+> logHook c

             where
                topPP u g h v l = xmobarPP
                   { ppOutput   = hPutStrLn u
                   , ppCurrent  = h
                   , ppVisible  = v
                   , ppHidden   = xmobarColor myppHiddenFg myppHiddenBg
                   , ppHiddenNoWindows = xmobarColor  myppHiddenNoWindowsFg myppHiddenNoWindowsBg
                   , ppSep =  "  "                     -- Separators in xmobar
                   , ppWsSep    = " "
                   , ppTitle    = const ""
                   , ppLayout = l . wrap " " " "
                   , ppExtras = [windowCount]                          -- # of windows current workspace
                   , ppOrder  = \(ws:l:ex) -> [ws, l]
                   }

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
------------------------------------------------------------------------
toggleOrViewNoSP = toggleOrDoSkip ["NSP"] W.greedyView

myKeys =
    [("M-" ++ m ++ k, windows $ f i)
        | (i, k) <- zip (myWorkspaces) (map show ([1 :: Int .. 9 :: Int] ++ [0 :: Int]))
        , (f, m) <- [(W.view, ""), (W.greedyView, "C-"), (W.shift, "S-"), (copy, "S-C-")]]
    ++
    [("M-M3-0", windows copyToAll)   -- copy window to all workspaces
     , ("M-M3-S-0", killAllOtherCopies)  -- kill copies of window on other workspaces
     , ("M-M1-k", sendMessage MirrorExpand)
     , ("M-M1-j", sendMessage MirrorShrink)
     , ("M-M1-h", sendMessage Shrink)
     , ("M-M1-l", sendMessage Expand)
     , ("M-S-b", sendMessage ToggleStruts)
     , ("M-f", sendMessage $ JumpToLayout "Full")
     , ("M-t", sendMessage $ JumpToLayout "Tile")
     , ("M-M3-t", sendMessage $ JumpToLayout "Float")
     , ("M-g", sendMessage $ JumpToLayout "Grid")
     , ("M-b", sendMessage $ JumpToLayout "BSP")
     , ("M-c", sendMessage $ JumpToLayout "CM")
     , ("M-i", sendMessage (IncMasterN 1))
     , ("M-d", sendMessage (IncMasterN (-1)))
     , ("M-u", moveTo Next (hiddenWS :&: Not emptyWS))
     , ("M-y", moveTo Prev (hiddenWS :&: Not emptyWS))
     , ("M-<Tab>", toggleWS' ["NSP"])
     , ("M1-<Tab>", toggleFocus)
     , ("M-p", spawn "~/.config/rofi/launchers/type-7/launcher.sh")
     , ("M-S-q", spawn "end-session")
     , ("M-z", spawn "em1")
     , ("M-S-z", spawn "em2")
     , ("M-x", spawn "em3")
     , ("M-S-x", spawn "em4")
     , ("M-n", spawn "flash_window")
     , ("M-C-h", sendMessage $ pullGroup L)
     , ("M-C-l", sendMessage $ pullGroup R)
     , ("M-C-k", sendMessage $ pullGroup U)
     , ("M-C-j", sendMessage $ pullGroup D)
     , ("M3-w", withFocused (sendMessage . MergeAll))
     , ("M3-S-w", withFocused (sendMessage . UnMerge))
     , ("M-M3-h", onGroup W.focusUp')
     , ("M-M3-l", onGroup W.focusDown')
        -- Switch between layers
     , ("M-s", Nav2D.switchLayer)
     , ("M-M1-0", sequence_ [toggleScreenSpacingEnabled, toggleWindowSpacingEnabled])

     , ("M-o", warpToWindow (9%10) (9%10))
     , ("M-.", sequence_ [viewScreen def 1, warpToScreen 1 (1%2) (1%2), warpToWindow (9%10) (9%10)])
     , ("M-,", sequence_ [viewScreen def 0, warpToScreen 0 (1%2) (1%2), warpToWindow (9%10) (9%10)])
     , ("M-S-.", sequence_ [sendToScreen def 1, viewScreen def 1, warpToScreen 1 (1%2) (1%2), warpToWindow (9%10) (9%10)])
     , ("M-S-,", sequence_ [sendToScreen def 0, viewScreen def 0, warpToScreen 0 (1%2) (1%2), warpToWindow (9%10) (9%10)])
     -- Directional navigation of windows
     , ("M-l", myFocus R)
     , ("M-h" , myFocus L)
     , ("M-k"   , myFocus U)
     , ("M-j" , myFocus D)
     , ("M-S-l", sendMessage $ Swap R)
     , ("M-S-h" , sendMessage $ Swap L)
     , ("M-S-k"   , sendMessage $ Swap U)
     , ("M-S-j" , sendMessage $ Swap D)
     , ("M-<Return>" , sequence_ [windows W.focusMaster, toggleFocus, windows W.swapMaster])
     , ("<XF86AudioMute>", spawn "volume mute")
     , ("<XF86AudioLowerVolume>", spawn "volume down")
     , ("<XF86AudioRaiseVolume>", spawn "volume up")
     , ("<XF86MonBrightnessUp>", spawn "brightness up")
     , ("<XF86MonBrightnessDown>", spawn "brightness down")
     , ("M-=", spawn "bluefilter up")
     , ("M--", spawn "bluefilter down")
     , ("M3-=", spawn "screenshot all")
     , ("C-M3-=", spawn "screenshot selection")
     , ("M1-M3-=", spawn "screenshot focus")
     , ("S-M3-=", spawn "screenshot delay")
     , ("M1-S-M3-=", spawn "screenshot delay-focus")
     , ("M-[", spawn "dunstctl history-pop")
     , ("M-;", spawn "scratchpad --toggle 1")
     , ("M-'", spawn "scratchpad --toggle 2")
     , ("M-S-s", toggleFloat)
     , ("M-M1-<Space>", spawn "kbdlayout")
     , ("M3-<Backspace>", spawn "setxkbmap && dunstify -i keyboard reset")
    ]

centreRect = W.RationalRect (1/6) (1/6) (2/3) (2/3)

-- If the window is floating then (f), if tiled then (n)
floatOrNot f n = withFocused $ \windowId -> do
    floats <- gets (W.floating . windowset)
    if windowId `M.member` floats -- if the current window is floating...
       then f
       else n

-- Centre and float a window (retain size)
centreFloat win = do
    (_, W.RationalRect x y w h) <- floatLocation win
    windows $ W.float win (W.RationalRect ((1 - w) / 2) ((1 - h) / 2) w h)
    return ()

-- Float a window in the centre
centreFloat' w = windows $ W.float w centreRect

-- Make a window my 'standard size' (half of the screen) keeping the centre of the window fixed
standardSize win = do
    (_, W.RationalRect x y w h) <- floatLocation win
    windows $ W.float win (W.RationalRect x y 0.5 0.5)
    return ()


-- Float and centre a tiled window, sink a floating window
toggleFloat = floatOrNot (withFocused $ windows . W.sink) (sequence_ [(withFocused centreFloat'), toggleFocus, toggleFocus])

-- Get the name of the active layout.
getActiveLayoutDescription :: X String
getActiveLayoutDescription = do
    workspaces <- gets windowset
    return $ description . W.layout . W.workspace . W.current $ workspaces

myFocusNotFloat dir = do
  layout <- getActiveLayoutDescription
  case layout of
    "Full" -> case dir of
                D -> windows W.focusDown
                U -> windows W.focusUp
                R -> windows W.focusDown
                L -> windows W.focusUp
    _      -> sendMessage $ Go dir
myFocus dir = floatOrNot (sequence_ [Nav2D.windowGo dir False, windows W.swapMaster]) (myFocusNotFloat dir)


myNav2DConf = def
    { Nav2D.defaultTiledNavigation    = Nav2D.centerNavigation
    , Nav2D.floatNavigation           = Nav2D.centerNavigation
    , Nav2D.screenNavigation          = Nav2D.lineNavigation
    , Nav2D.layoutNavigation          = [("Full", Nav2D.centerNavigation)
    -- line/center same results   ,("Simple Tabs", lineNavigation)
    --                            ,("Simple Tabs", centerNavigation)
                                        ]
    , Nav2D.unmappedWindowRect  = [("Full", Nav2D.singleWindowRect)
    -- works but breaks tab deco  ,("Simple Tabs", singleWindowRect)
    -- doesn't work but deco ok   ,("Simple Tabs", fullScreenRect)
                                  ]
    }

------------------------------------------------------------------------
-- main
------------------------------------------------------------------------

main = do
    xmproc0 <- spawnPipe "xmobar -x 0 /home/bndo/.xmonad/xmobarrc0"
    xmproc1 <- spawnPipe "xmobar -x 1 /home/bndo/.xmonad/xmobarrc1"
    xmonad $ withUrgencyHook LibNotifyUrgencyHook
      $ Nav2D.withNavigation2DConfig myNav2DConf
      $ ewmh desktopConfig
        { manageHook = ( isFullscreen --> doFullFloat ) <+> manageDocks <+>  myManageHook <+> manageHook desktopConfig
        , startupHook        = myStartupHook <+> setWMName "LG3D"
        , layoutHook         = myLayout
        , handleEventHook    = handleEventHook desktopConfig <+> refocusLastWhen refocusingIsActive
        , workspaces         = myWorkspaces
        , borderWidth        = myBorderWidth
        , terminal           = myTerminal
        , modMask            = myModMask
        , normalBorderColor  = myNormalBorderColor
        , focusedBorderColor = myFocusedBorderColor
        , logHook = myLogHook def xmproc0 xmproc1 >> refocusLastLogHook
          }
          `additionalKeysP` myKeys
