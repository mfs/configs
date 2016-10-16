import XMonad
import XMonad.Layout.Spacing
import XMonad.Layout.ThreeColumns
import XMonad.Hooks.DynamicLog

layout =  spacing 12 (three ||| tiled ||| Mirror tiled ||| Full)
	where
		three = ThreeColMid nmaster delta (1/3)
		tiled = Tall nmaster delta ratio
		nmaster = 1
		ratio = 1/2
		delta = 3/100

main = xmonad =<< xmobar defaultConfig
	{ modMask            = mod4Mask
	, borderWidth        = 1
	, terminal           = "st"
	, layoutHook         = layout
	, logHook            = dynamicLog
	, normalBorderColor  = "#6f6f6f"
	, focusedBorderColor = "#b5bd68" }
