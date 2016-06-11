import XMonad
import qualified Data.Map as M
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.Exit
import System.IO

main = do
    xmproc <- spawnPipe "/usr/bin/xmobar /home/ben/.xmonad/xmobarrc"
    --xmproc2 <- spawnPipe "/usr/bin/xmobar /home/ben/.xmonad/xmobarrc2"
    xmonad $ defaultConfig
        { workspaces = myWorkspaces
        , manageHook = manageDocks <+> myManageHook
                        <+> manageHook defaultConfig
        , layoutHook = avoidStruts  $  layoutHook defaultConfig
        , logHook = dynamicLogWithPP xmobarPP

                        { ppOutput = hPutStrLn xmproc
                        , ppTitle = xmobarColor "green" "" . shorten 100
                        }
        , modMask = myModMask
        , borderWidth = myBorderWidth
        , keys = myKeys <+> keys defaultConfig
        } `additionalKeys`
        [ ((mod4Mask .|. shiftMask, xK_z), spawn "xscreensaver-command -lock")
        , ((mod4Mask .|. shiftMask, xK_j), spawn "conkeror")
        , ((mod4Mask .|. shiftMask, xK_k), spawn "iceweasel")
        , ((mod4Mask .|. shiftMask, xK_l), spawn "icedove")
        , ((mod4Mask .|. shiftMask, xK_f), spawn "emacsclient -c -a emacs")
        --, ((mod4Mask .|. shiftMask, xK_d), spawn "thunar")
        , ((mod4Mask .|. shiftMask, xK_d), spawn "x-terminal-emulator -e mc")
        , ((mod4Mask .|. shiftMask, xK_m), spawn "x-terminal-emulator -e mocp")
        --, ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
        --, ((0, xK_Print), spawn "scrot")
        ]

myModMask     = mod4Mask -- Win key or Super_L
myBorderWidth = 3
myWorkspaces = ["1", "2", "3", "4", "5", "6:email", "7:passwd", "8:todo", "9:music"]

myManageHook = composeAll
    [ className =? "Wine" --> doFloat
    , className =? "Gimp" --> doFloat

    -- For Glastonbury
    --, className =? "Iceweasel" --> doFloat
    --, className =? "Tk" --> doFloat
    --, className =? "Toplevel" --> doFloat
    ]


--- http://xmonad.org/xmonad-docs/xmonad-contrib/XMonad-Doc-Extending.html#Extending_xmonad
myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
    [
    --- Override default logout to effectively remove it
    ((modMask .|. shiftMask, xK_q), return ())
    , ((modMask .|. shiftMask, xK_F12), io (exitWith ExitSuccess))
    ]


--- Could ask for confirmation when quitting: http://stackoverflow.com/questions/9993966/xmonad-confirmation-when-restarting
