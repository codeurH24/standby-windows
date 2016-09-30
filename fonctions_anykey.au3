Func _llkb($nCode, $wParam, $lParam)
    If $nCode = $HC_ACTION Then $AKeyWasPressed = 1
    Return _CallNextHookEx($hHkk, $nCode, $wParam, $lParam)
EndFunc ;==>_llkb

Func _CallNextHookEx($hhk, $nCode, $wParam, $lParam)
    Local $aTmp = DllCall("user32.dll", "lparam", "CallNextHookEx", "ptr", $hhk, "int", $nCode, "wparam", $wParam, "lparam", $lParam)
    Return $aTmp[0]
EndFunc ;==>_CallNextHookExtf