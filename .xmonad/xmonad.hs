import qualified Data.Map as M

import XMonad
import qualified XMonad.StackSet as W
import XMonad.Prompt
import XMonad.Prompt.Workspace
import XMonad.Layout.Spacing
import XMonad.Layout.Renamed
import XMonad.Layout.ThreeColumns
import XMonad.Layout.NoBorders
import XMonad.Hooks.DynamicLog
import XMonad.Actions.GridSelect
import XMonad.Util.Scratchpad

colorBlack   = "#1d1f21"
colorRed     = "#cc6666"
colorGreen   = "#b5bd68"
colorYellow  = "#f0c674"
colorBlue    = "#81a2be"
colorMagenta = "#b294bb"
colorCyan    = "#8abeb7"
colorWhite   = "#c5c8c6"

myWorkspaces = words "1:dev 2:web 3:gfx 4 5 6 7 8 9"

layout =  smartBorders $ three ||| tiled ||| mtiled ||| Full
	where
		nmaster  = 1
		ratio    = 1/2
		delta    = 3/100
		space    = spacing 12
		rename n = renamed [Replace n]
		three    = rename "|M|" $ space $ ThreeColMid nmaster delta (1/3)
		tiled    = rename "T" $ space $ Tall nmaster delta ratio
		mtiled   = rename "MT" $ space $ Mirror $ Tall nmaster delta ratio
		full     = rename "F" $ Full

toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList
	[ ((modm .|. shiftMask, xK_m ), workspacePrompt myXPConfig (windows . W.greedyView))
	, ((modm, xK_g), gridselectWorkspace defaultGSConfig W.greedyView)
	, ((modm, xK_x), scratchpadSpawnActionCustom "st -n scratchpad")
	]

myManageHook = composeAll
	[ className =? "MPlayer"        --> doFloat
	, className =? "Chromium"       --> doShift "2:web"
	, appName   =? "gimp"           --> doFloat ]

myPP = xmobarPP
	{ ppCurrent         = xmobarColor colorBlack colorBlue
	, ppVisible         = xmobarColor colorWhite "#404040"
	, ppHidden          = xmobarColor colorWhite colorBlack
	, ppSep             = xmobarColor colorBlue colorBlack " | "
	, ppTitle           = xmobarColor colorGreen colorBlack
	}

myXPConfig = defaultXPConfig
	{ font = "xft:Inconsolata:size=11:antialias=true:autohint=true"
	, bgColor = colorBlack
	, fgColor = colorWhite
	, position = Top
	, promptBorderWidth = 0
	}

main = xmonad =<< statusBar "xmobar" myPP toggleStrutsKey defaultConfig
	{ modMask            = mod4Mask
	, workspaces         = myWorkspaces
	, keys               = myKeys <+> keys defaultConfig
	, borderWidth        = 1
	, terminal           = "st"
	, layoutHook         = layout
	, manageHook         = myManageHook <+> scratchpadManageHook (W.RationalRect 0.25 0.25 0.5 0.5)
	, normalBorderColor  = "#6f6f6f"
	, focusedBorderColor = colorGreen }
