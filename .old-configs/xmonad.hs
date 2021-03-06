-- xmonad.hs
-- Mike Sampson
-- [cmgr] .xmonad/xmonad.hs

-- General
import Data.List
import qualified Data.Map as M
import Data.Bits ((.|.))
import Data.Ratio
import Graphics.X11
import Text.Printf
import System.IO
import Control.Monad(liftM, liftM2)
-- XMonad Core
import XMonad hiding ( (|||) )
import XMonad.Operations
import qualified XMonad.StackSet as W
-- XMonad.Actions
import XMonad.Actions.DwmPromote
import XMonad.Actions.GridSelect
import XMonad.Actions.OnScreen
import XMonad.Actions.Search
import XMonad.Actions.Submap
-- XMonad.Hooks
import XMonad.Hooks.DynamicLog ( PP(..),
        dynamicLogWithPP, dzenColor, wrap, defaultPP )
import XMonad.Hooks.SetWMName
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.FadeInactive
-- XMonad.Layout
import XMonad.Layout hiding ( (|||) )
import XMonad.Layout.LayoutCombinators
import XMonad.Layout.NoBorders
import XMonad.Layout.Grid
import XMonad.Layout.Tabbed
import XMonad.Layout.LayoutHints
import XMonad.Layout.IndependentScreens (countScreens)
-- XMonad.Prompt
import XMonad.Prompt ( XPConfig(..), XPPosition(..), defaultXPConfig )
import XMonad.Prompt.Shell ( shellPrompt )
import XMonad.Prompt.AppendFile ( appendFilePrompt )
-- XMonad.Util
import XMonad.Util.Run
import XMonad.Util.WorkspaceCompare ( getSortByIndex, getSortByXineramaRule )
import XMonad.Util.Scratchpad

cfg :: String -> IO String
cfg str = do
    x <- runProcessWithInput "/home/mike/bin/cfg" ["get", str] []
    return(x)

color0 :: String
color0 = "#0390e1" -- blue
color1 :: String
color1 = "#90e103" -- green

font0 :: String
font0 = "-windows-proggyclean-medium-r-normal--13-80-96-96-c-70-iso8859-1"

statusBarCmd :: String
statusBarCmd =  printf
    "%s -bg '%s' -fg '%s' -w %d -sa c -fn '%s' -e '' -x 0 -ta l"
    "dzen2"
    "black"
    "grey30"
    (1380::Integer)
    font0

myWorkspaces :: [String]
myWorkspaces = map (\(x, y) -> show x ++ ":" ++ y)
                   (zip [1..9] $ words "dev web doc gfx" ++ repeat "tmp")

main = do
    din <- spawnPipe statusBarCmd
    sc <- countScreens
    term <- cfg "term"
    browser <- cfg "browser"
    xmonad $ defaultConfig
        { borderWidth        = 1
        , normalBorderColor  = "black"
        , focusedBorderColor = "gray20"
        , workspaces         = myWorkspaces
        , terminal           = term
        , modMask            = mod4Mask
        , manageHook         = myManageHook <+> scratchpadManageHookDefault
        , startupHook        = startup
        , logHook            = dynamicLogWithPP $ myPP din sc
        , layoutHook         = avoidStruts ( layoutHintsWithPlacement (0.5,0.5)
              (tiled ||| Mirror tiled ||| Full ||| Grid))
        , keys               = \c -> myKeys browser `M.union` keys defaultConfig c
        , mouseBindings      = myMouseBindings
        }
        where
            tiled = Tall 1 (3%100) (1%2)

-- need to make sure we are on correct workspace and that it has no existing
-- clients also need to spawn terminals and firefox
startup :: X ()
startup = do
          setWMName "LG3D"
          sendMessage $ JumpToLayout "Hinted Grid"

myManageHook = composeAll . concat $
    [ [ className =? c --> doCenterFloat | c <- myFloatClasses]
    , [ className =? "sun-applet-Main" --> doFloat]
    , [ className =? "-c" --> doIgnore]
    , [ title     =? t --> doCenterFloat | t <- myFloatTitles]
    , [ fmap ( "Page Info" `isInfixOf`) title --> doCenterFloat]
    , [ fmap ( "JAVA:" `isInfixOf`) title --> doCenterFloat]
    , [ className =? "URxvt" -->
            (ask >>= \w -> liftX (setOpacity w 0xcccccccc) >> idHook)]
    , [ className =? c --> doShift "2:web" | c <- ["Namoroka", "Chromium"]]
    , [ className =? "XDvi" --> doShift2 "3:doc"]
    , [ className =? "Epdfview" --> doShift2 "3:doc"]
    , [ className =? "Apvlv" --> doShift2 "3:doc"]
    , [ className =? "OpenOffice.org 3.1" --> doShift "3:doc"]
    , [ isFullscreen --> doFullFloat]
    ]
    where
        myFloatClasses = [ "MPlayer", "feh", "Xmessage", "Grip", "DClock"
                         , "Gimp", "XDosEmu", "Nitrogen", "Nvidia-settings"
                         , "VirtualBox", "Sonata", "xine", "Blender:Render"
                         , "Vdesk.py", "org-scilab-modules-jvm-Scilab"
                         , "qemu-system-x86_64"]

        myFloatTitles = ["Downloads", "Add-ons", "Namoroka Preferences"
                        , "About Namoroka", "Event Tester", "OpenGL"
                        , "Element Properties", "glint"]

        doShift1 = doF . liftM2 (.) (viewOnScreen 0) W.shift
        doShift2 = doF . liftM2 (.) (viewOnScreen 1) W.shift

-- redifine some keys
myKeys browser = M.fromList $
    [ ((mod4Mask                , xK_p      ), shellPrompt mySPConfig)
    , ((mod4Mask                , xK_Return ), dwmpromote)
    , ((mod4Mask                , xK_b      ), sendMessage ToggleStruts)
    , ((mod4Mask                , xK_g      ), goToSelected defaultGSConfig)
    , ((mod4Mask                , xK_r      ),
            spawnSelected defaultGSConfig ["gimp", "epdfview", "soffice"])
    , ((mod4Mask .|. controlMask, xK_f      ), spawn browser)
    , ((mod4Mask .|. controlMask, xK_e      ), spawn cmdPizza1)
    , ((mod4Mask .|. controlMask, xK_d      ), spawn cmdPizza2)
    , ((mod4Mask .|. controlMask, xK_n      ), spawn "nitrogen ~/images")
    , ((mod4Mask                , xK_x      ),
            scratchpadSpawnActionTerminal "urxvt")
    , ((mod4Mask                , xK_s      ),
            submap $ searchEngineMap $ promptSearch mySPConfig)
    , ((mod4Mask                , xK_c      ),
            submap $ cheatSheetMap)
    --, ((mod4Mask                , xK_s      ), )
    , ((0                       , 0x1008FF11), spawn cmdVolumeDown)
    , ((0                       , 0x1008FF12), spawn cmdVolumeMute)
    , ((0                       , 0x1008FF13), spawn cmdVolumeUp)
    ]
    where
        cmdPizza1     = browser ++ " http://www.eagleboys.com.au"
        cmdPizza2     = browser ++ " http://www.dominos.com.au"
        cmdVolumeDown = "amixer -q set 'Analog Front' '1%-'"
        cmdVolumeMute = "amixer -q set 'Analog Front' 'toggle'"
        cmdVolumeUp   = "amixer -q set 'Analog Front' '1%+'"

        searchEngineMap method = M.fromList $
            [ ((0, xK_a), method  amazon)
            , ((0, xK_d), method  dictionary)
            , ((0, xK_g), method  google)
            , ((0, xK_h), method  hoogle)
            , ((0, xK_i), method  imdb)
            , ((0, xK_w), method  wikipedia)
            , ((0, xK_y), method  youtube)
            ]

        cheatSheetDir = "~/data/reference/cheatsheets/"

        cheatSheetMap = M.fromList $
            [ ((0, xK_r), spawn $ "feh " ++ cheatSheetDir ++ "re.png")
            ]

-- my mouse buttons
myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modMask, button1), (\w -> focus w >> mouseMoveWindow w))

    -- mod-button2, Raise the window to the top of the stack
    , ((modMask, button2), (\w -> focus w >> windows W.swapMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modMask, button3), (\w -> focus w >> mouseResizeWindow w))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

-- PP config
myPP h sc = defaultPP
    { ppCurrent         = dzenColor "#000000" color0
    , ppVisible         = dzenColor "grey70" "#404040"
    , ppHidden          = dzenColor color0 "#000000"
    , ppHiddenNoWindows = dzenColor "gray70" "#000000"
    , ppUrgent          = id
    , ppSep             = dzenColor "gray70" "black" " | "
    , ppWsSep           = " "
    , ppTitle           = dzenColor color1 "black"
    , ppLayout          = dzenColor color0 "black"
    , ppOrder           = id
    , ppOutput          = hPutStrLn h
    , ppSort            = fmap (.scratchpadFilterOutWorkspace) $
                               if sc == 1 then getSortByIndex
                                          else getSortByXineramaRule
    , ppExtras          = []
    }


-- shellprompt config
mySPConfig =  defaultXPConfig
    { font              = font0
    , bgColor           = "black"
    , fgColor           = "white"
    , bgHLight          = color0
    , fgHLight          = "black"
    , borderColor       = "black"
    , promptBorderWidth = 0
    , position          = Bottom
    , height            = 15
    , historySize       = 25
    , historyFilter     = const []
    , defaultText       = ""
    , autoComplete      = Nothing
    }

