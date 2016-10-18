import XMonad
import XMonad.Layout.Spacing
import XMonad.Layout.Renamed
import XMonad.Layout.ThreeColumns
import XMonad.Hooks.DynamicLog

colorBlack   = "#1d1f21"
colorRed     = "#cc6666"
colorGreen   = "#b5bd68"
colorYellow  = "#f0c674"
colorBlue    = "#81a2be"
colorMagenta = "#b294bb"
colorCyan    = "#8abeb7"
colorWhite   = "#c5c8c6"

layout =  renamed [CutWordsLeft 2] $ spacing 12 (three ||| tiled ||| Mirror tiled ||| Full)
	where
		three = ThreeColMid nmaster delta (1/3)
		tiled = Tall nmaster delta ratio
		nmaster = 1
		ratio = 1/2
		delta = 3/100

toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)

myPP = xmobarPP
	{ ppCurrent         = xmobarColor colorBlack colorBlue
	, ppVisible         = xmobarColor colorWhite "#404040"
	, ppHidden          = xmobarColor colorWhite colorBlack
	, ppHiddenNoWindows = xmobarColor colorWhite colorBlack
	, ppSep             = xmobarColor colorBlue colorBlack " | "
	, ppTitle           = xmobarColor colorGreen colorBlack
	}

main = xmonad =<< statusBar "xmobar" myPP toggleStrutsKey defaultConfig
	{ modMask            = mod4Mask
	, borderWidth        = 1
	, terminal           = "st"
	, layoutHook         = layout
	, normalBorderColor  = "#6f6f6f"
	, focusedBorderColor = colorGreen }
