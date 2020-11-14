------------------------------------------------------------------------
-- import
------------------------------------------------------------------------

import XMonad hiding ( (|||) ) -- jump to layout
import XMonad.Layout.LayoutCombinators (JumpToLayout(..), (|||)) -- jump to layout
import XMonad.Config.Desktop
import System.Exit
import qualified XMonad.StackSet as W
import XMonad.Layout.IfMax

-- data
import Data.Char (isSpace)
import Data.List
import Data.Monoid
import Data.Maybe (isJust)
import Data.Ratio ((%)) -- for video
import qualified Data.Map as M

-- system
import System.IO (hPutStrLn) -- for xmobar

-- util
import XMonad.Util.Run (safeSpawn, unsafeSpawn, runInTerm, spawnPipe)
import XMonad.Util.SpawnOnce
import XMonad.Util.EZConfig (additionalKeysP, additionalMouseBindings)
import XMonad.Util.NamedScratchpad
import XMonad.Util.NamedWindows
import XMonad.Util.WorkspaceCompare

-- hooks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks (avoidStruts, docksStartupHook, manageDocks, ToggleStruts(..))
import XMonad.Hooks.EwmhDesktops -- to show workspaces in application switchers
import XMonad.Hooks.ManageHelpers (isFullscreen, isDialog,  doFullFloat, doCenterFloat, doRectFloat)
import XMonad.Hooks.Place (placeHook, withGaps)
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.InsertPosition
import XMonad.Hooks.RefocusLast

-- actions
import XMonad.Actions.CycleWindows
import XMonad.Actions.GroupNavigation
import XMonad.Actions.CycleWS
import XMonad.Actions.Navigation2D
import XMonad.Actions.CopyWindow -- for dwm window style tagging
import XMonad.Actions.GridSelect -- for dwm window style tagging
import XMonad.Actions.UpdatePointer -- update mouse postion
import XMonad.Actions.Promote -- update mouse postion

-- layout
import XMonad.Layout.NoFrillsDecoration
import XMonad.Layout.ThreeColumns
import XMonad.Layout.Simplest
import XMonad.Layout.TabBarDecoration
import XMonad.Layout.Tabbed
import XMonad.Layout.Renamed (renamed, Rename(Replace))
import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing
import XMonad.Layout.GridVariants
import XMonad.Layout.ResizableTile
import XMonad.Layout.BinarySpacePartition
import XMonad.Layout.SubLayouts
import XMonad.Layout.WindowNavigation

------------------------------------------------------------------------
-- variables
------------------------------------------------------------------------

myModMask = mod4Mask -- Sets modkey to super/windows key
myTerminal = "st" -- Sets default terminal
myBorderWidth = 0 -- Sets border width for windows
myNormalBorderColor = "#839496"
myFocusedBorderColor = "#268BD2"
myppCurrent = "#ffffff"
myppVisible = "#cb4b16"
myppHidden = "#777777"
myppHiddenNoWindows = "#444444"
myppTitle = "#FDF6E3"
myppUrgent = "#DC322F"
xmobarEscape = concatMap doubleLts
  where doubleLts '<' = "<<"
        doubleLts x   = [x]

myWorkspaces :: [String]        
myWorkspaces = clickable . (map xmobarEscape) $ ["1","2","3","4","5","6","7","8","9"]
  where                                                                       
         clickable l = [ "<action=xdotool key super+" ++ show (n) ++ ">" ++ ws ++ "</action>" |
                             (i,ws) <- zip [1..9] l,                                        
                            let n = i ]
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

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
gap         = 10
topbar      = 20
border      = 0
prompt      = 20
status      = 20

active      = base00
activeWarn  = red
inactive    = base02
focusColor  = blue
unfocusColor = base02

myFont      = "xft:Monego:pixelsize=1"
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
    , activeTextColor       = active
    , urgentBorderColor     = red
    , urgentTextColor       = yellow
    , decoHeight            = topbar
    }

myTabTheme = def
    { fontName              = myFont
    , inactiveBorderColor   = base03
    , inactiveColor         = base03
    , inactiveTextColor     = base03
    , activeBorderColor     = active
    , activeColor           = active
    , activeTextColor       = active
    , decoHeight            = topbar
    }

myLayout = avoidStruts $ (tiled ||| full ||| cMaster ||| grid ||| bsp)
  where
     -- full
     full = renamed [Replace "[Full]"]
       -- $ windowNavigation
       -- $ addTabs shrinkText myTabTheme $ subLayout [] Simplest
       $ noBorders (Full)

     -- tiled
     tiled = renamed [Replace "[Tile]"]
       -- $ ifMax 1 (spacingRaw False (Border 10 0 10 0) True (Border 0 10 0 10) True
       -- $ ResizableTall 1 (3/100) (3/5) [])

       -- $ noFrillsDeco shrinkText topBarTheme           
       -- $ windowNavigation $ subTabbed
       $ windowNavigation
       $ addTabs shrinkText myTabTheme $ subLayout [] Simplest
       $ spacingRaw False (Border 10 0 10 0) True (Border 0 10 0 10) True
       $ ResizableTall 1 (3/100) (3/5) []

     -- grid
     cMaster = renamed [Replace "[CM]"]
       -- $ ifMax 1 (spacingRaw False (Border 10 0 10 0) True (Border 0 10 0 10) True
                  -- $ ResizableTall 1 (3/100) (3/5) [])

       -- $ noFrillsDeco shrinkText topBarTheme
       $ windowNavigation
       $ addTabs shrinkText myTabTheme $ subLayout [] Simplest
       $ spacingRaw False (Border 10 0 10 0) True (Border 0 10 0 10) True
       $ ThreeColMid 1 (3/100) (1/2)

     grid = renamed [Replace "[Grid]"]
       -- $ ifMax 1 (spacingRaw False (Border 10 0 10 0) True (Border 0 10 0 10) True
       -- $ ResizableTall 1 (3/100) (3/5) [])

       -- $ noFrillsDeco shrinkText topBarTheme
       $ windowNavigation
       $ addTabs shrinkText myTabTheme $ subLayout [] Simplest
       $ spacingRaw False (Border 10 0 10 0) True (Border 0 10 0 10) True
       $ Grid (16/10)

     -- bsp
     bsp = renamed [Replace "[BSP]"]
       -- $ ifMax 1 (spacingRaw False (Border 10 0 10 0) True (Border 0 10 0 10) True
       -- $ ResizableTall 1 (3/100) (3/5) [])

       -- $ noFrillsDeco shrinkText topBarTheme
       $ windowNavigation
       $ addTabs shrinkText myTabTheme $ subLayout [] Simplest
       $ spacingRaw False (Border 10 0 10 0) True (Border 0 10 0 10) True
       $ emptyBSP

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
    , className =? "discord"        --> doFloat
    , className =? "main.exe"       --> doRectFloat (W.RationalRect (1 % 4) (1 % 4) (1 % 2) (1 % 2))
    , className =? "Firefox" <&&> resource =? "Toolkit" --> doFloat -- firefox pip
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore
    , isFullscreen --> doFullFloat
    ] <+> namedScratchpadManageHook myScratchpads

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
------------------------------------------------------------------------

myKeys =
    [("M-" ++ m ++ k, windows $ f i)
        | (i, k) <- zip (myWorkspaces) (map show [1 :: Int ..])
        , (f, m) <- [(W.view, ""), (W.shift, "S-"), (copy, "S-C-")]]
    ++
    [("M-S-0", windows copyToAll)   -- copy window to all workspaces
     , ("M-C-0", killAllOtherCopies)  -- kill copies of window on other workspaces
     , ("M-M1-j", sendMessage MirrorExpand)
     , ("M-M1-k", sendMessage MirrorShrink)
     , ("M-M1-h", sendMessage Shrink)
     , ("M-M1-l", sendMessage Expand)
     , ("M-S-b", sendMessage ToggleStruts)
     , ("M-f", sendMessage $ JumpToLayout "[Full]")
     , ("M-t", sendMessage $ JumpToLayout "[Tile]")
     , ("M-g", sendMessage $ JumpToLayout "[Grid]")
     , ("M-b", sendMessage $ JumpToLayout "[BSP]")
     , ("M-c", sendMessage $ JumpToLayout "[CM]")
     , ("M-i", sendMessage (IncMasterN 1))
     , ("M-d", sendMessage (IncMasterN (-1)))
     , ("M-<Tab>", toggleWS)
     , ("M1-<Tab>", toggleFocus)
     , ("M-p", spawn "dmenu_run -w 3775 -x 15")
     , ("M-S-q", spawn "end-session")
     , ("M-z", spawn "em1")
     , ("M-S-z", spawn "em2")
     , ("M-x", spawn "em3")
     , ("M-S-x", spawn "em4")
     , ("M-n", spawn "flash_window")
     , ("M-C-h", sendMessage $ pullGroup XMonad.Layout.WindowNavigation.L)
     , ("M-C-l", sendMessage $ pullGroup XMonad.Layout.WindowNavigation.R)
     , ("M-C-k", sendMessage $ pullGroup U)
     , ("M-C-j", sendMessage $ pullGroup D)
     , ("M-w", withFocused (sendMessage . MergeAll))
     , ("M-S-w", withFocused (sendMessage . UnMerge))
     , ("M-,", onGroup W.focusUp')
     , ("M-.", onGroup W.focusDown')
     , ("M-C-<Space>", namedScratchpadAction myScratchpads "terminal")
     , ("M-C-<Return>", namedScratchpadAction myScratchpads "emacs-scratch")
     , ("M-0", goToSelected defaultGSConfig)
        -- Switch between layers
     , ("M-s", switchLayer)

     -- Directional navigation of windows
     , ("M-l", windowGo XMonad.Layout.BinarySpacePartition.R False)
     , ("M-h" , windowGo XMonad.Layout.BinarySpacePartition.L False)
     , ("M-k"   , windowGo U False)
     , ("M-j" , windowGo D False)
     , ("M-S-l", windowSwap XMonad.Layout.BinarySpacePartition.R False)
     , ("M-S-h" , windowSwap XMonad.Layout.BinarySpacePartition.L False)
     , ("M-S-k"   , windowSwap U False)
     , ("M-S-j" , windowSwap D False)
     -- , ("M-<Return>" , promote)
     , ("<XF86AudioMute>", spawn "volume mute")
     , ("<XF86AudioLowerVolume>", spawn "volume down")
     , ("<XF86AudioRaiseVolume>", spawn "volume up")
     , ("<XF86MonBrightnessUp>", spawn "bluefilter up")
     , ("<XF86MonBrightnessDown>", spawn "bluefilter down")
     , ("<Print>", spawn "screenshot all")
     , ("C-<Print>", spawn "screenshot selection")
     , ("M1-<Print>", spawn "screenshot focus")
     , ("S-<Print>", spawn "screenshot delay")
     , ("M1-S-<Print>", spawn "screenshot delay-focus")
     , ("M-;", spawn "scratchpad --toggle 1")
     , ("M-'", spawn "scratchpad --toggle 2")
     , ("M-S-s", withFocused toggleFloat)
     , ("M1-<Space>", spawn "kbdlayout")
    ]
     where
            toggleFloat w = windows (\s -> if M.member w (W.floating s)
                            then W.sink w s
                            else (W.float w (W.RationalRect (1/5) (1/30) (3/5) (19/20)) s))


------------------------------------------------------------------------
-- scratchpads
------------------------------------------------------------------------

myScratchpads = [ NS "terminal" spawnTerm findTerm manageTerm
              , NS "emacs-scratch" spawnEmacsScratch findEmacsScratch manageEmacsScratch
                ]
    where
    role = stringProperty "WM_WINDOW_ROLE"
    spawnTerm = myTerminal ++  " -t scratchpad-st"
    findTerm = title =? "scratchpad-st"
    manageTerm = nonFloating
    findEmacsScratch = title =? "emacs-scratch"
    spawnEmacsScratch = "emacsclient -a='' -nc --frame-parameters='(quote (name . \"emacs-scratch\"))'"
    manageEmacsScratch = nonFloating

------------------------------------------------------------------------
-- main
------------------------------------------------------------------------

myNav2DConf = def
    { defaultTiledNavigation    = centerNavigation
    , floatNavigation           = centerNavigation
    , screenNavigation          = lineNavigation
    , layoutNavigation          = [("[Full]",          centerNavigation)
    -- line/center same results   ,("Simple Tabs", lineNavigation)
    --                            ,("Simple Tabs", centerNavigation)
                                  ]
    , unmappedWindowRect        = [("[Full]", singleWindowRect)
    -- works but breaks tab deco  ,("Simple Tabs", singleWindowRect)
    -- doesn't work but deco ok   ,("Simple Tabs", fullScreenRect)
                                  ]
    }
  
main = do
    xmproc0 <- spawnPipe "xmobar /home/bndo/.xmonad/xmobarrc"
    xmonad $ withUrgencyHook LibNotifyUrgencyHook
      $ withNavigation2DConfig myNav2DConf
      $ ewmh desktopConfig
        { manageHook = ( isFullscreen --> doFullFloat ) <+> manageDocks <+> insertPosition End Newer <+> myManageHook <+> manageHook desktopConfig
        , startupHook        = myStartupHook
        , layoutHook         = myLayout
        , handleEventHook    = handleEventHook desktopConfig <+> refocusLastWhen refocusingIsActive
        , workspaces         = myWorkspaces
        , borderWidth        = myBorderWidth
        , terminal           = myTerminal
        , modMask            = myModMask
        , normalBorderColor  = myNormalBorderColor
        , focusedBorderColor = myFocusedBorderColor
        , logHook = dynamicLogWithPP xmobarPP
                        { ppOutput = \x -> hPutStrLn xmproc0 x
                        , ppCurrent = xmobarColor myppCurrent "" . wrap " [" "] " -- Current workspace in xmobar
                        , ppVisible = xmobarColor myppVisible "" . wrap " " " "               -- Visible but not current workspace
                        , ppHidden = xmobarColor myppHidden "" . wrap " *" " "             -- Hidden workspaces in xmobar
                        , ppHiddenNoWindows = xmobarColor  myppHiddenNoWindows "" . wrap " " " "        -- Hidden workspaces (no windows)
                        , ppSep =  "<fc=#586E75>   </fc>"                     -- Separators in xmobar
                        , ppUrgent = xmobarColor  myppUrgent "" . wrap "!" "!"  -- Urgent workspace
                        , ppExtras = [windowCount]                          -- # of windows current workspace
                        , ppOrder  = \(ws:l:t:ex) -> [ws, l]++ex
                        } >> refocusLastLogHook
          }
          `additionalKeysP` myKeys
