import XMonad
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.Spacing
import XMonad.Layout.Renamed
import XMonad.Layout.ThreeColumns
import XMonad.Layout.NoBorders
import XMonad.Layout.Grid
import XMonad.Util.EZConfig
import XMonad.Util.Run

colorBlack   = "#1d1f21"
colorRed     = "#cc6666"
colorGreen   = "#b5bd68"
colorYellow  = "#f0c674"
colorBlue    = "#81a2be"
colorMagenta = "#b294bb"
colorCyan    = "#8abeb7"
colorWhite   = "#c5c8c6"

myLayout = smartBorders $ three ||| tiled ||| mtiled ||| grid |||  Full
    where
        nmaster  = 1
        ratio    = 1/2
        delta    = 3/100
        space    =  spacingRaw False (Border 16 0 16 0) True (Border 0 16 0 16) True
        rename n = renamed [Replace n]
        three    = rename "|M|" $ space $ ThreeColMid nmaster delta (4/10)
        tiled    = rename "T" $ space $ Tall nmaster delta ratio
        mtiled   = rename "MT" $ space $ Mirror $ Tall nmaster delta ratio
        grid     = rename "G" $ space $ Grid
        full     = rename "F" $ Full

-- appName   = 1st element in WM_CLASS(STRING)
-- className = 2nd element in WM_CLASS(STRING)
-- title     = WM_NAME(STRING)
myManageHook = composeAll
    [ className =? "mpv"                --> doFloat
    , appName   =? "Blender"            --> doFloat
    , title     =? "Picture-in-Picture" --> doFloat
    , appName   =? "gimp"               --> doFloat
    ]

myKeys =
    [ ("M-f", safeSpawnProg "firefox")
    , ("M-b", safeSpawnProg "blender")
    , ("M-g", safeSpawnProg "gimp")
    , ("M-z", safeSpawn "i3lock" ["-c", "000000"])
    ]

myPP = xmobarPP
    { ppCurrent   = xmobarColor colorBlack colorBlue
    , ppVisible   = xmobarColor colorWhite "#404040"
    , ppHidden    = xmobarColor colorWhite colorBlack
    , ppSep       = xmobarColor colorBlue colorBlack " | "
    , ppTitle     = xmobarColor colorGreen colorBlack
    }

m4_changequote(!,!)m4_dnl
myConfig = desktopConfig
    { terminal    = "alacritty -e tmux"
    , modMask     = mod4Mask
    , layoutHook  = myLayout
    , manageHook  = myManageHook
    , normalBorderColor = "#6f6f6f"
    , focusedBorderColor = colorGreen
    }
    `additionalKeysP`
    myKeys
m4_changequote()m4_dnl

toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask .|. shiftMask, xK_b)

main = xmonad =<< statusBar "xmobar" myPP toggleStrutsKey myConfig
