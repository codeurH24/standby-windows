;Global Const $WH_KEYBOARD_LL = 13
Global Const $HC_ACTION = 0

;ToolTip("When your ready press a key")

$pllkb = DllCallbackRegister ("_llkb", "lparam", "int;wparam;lparam")
$hModule = DllCall("kernel32.dll", "ptr", "GetModuleHandle", "ptr", 0)
$hModule = $hModule[0]
$hHkk = DllCall("user32.dll", "ptr", "SetWindowsHookEx", "int", $WH_KEYBOARD_LL, "ptr", DllCallbackGetPtr($pllkb), "ptr", $hModule, "dword", 0)
$hHkk = $hHkk[0]

$AKeyWasPressed = 0