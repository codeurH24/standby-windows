

initService_bandwidth()


Func initService_bandwidth()

  Global $hWnd_bandwidth




   ; si DonwloadMeter est deja lancer
	 If WinExists("[CLASS:Autoit V3] ") Then
	   ConsoleWrite ( "DonwloadMeter est deja lancer"& @CRLF)
	   ConsoleWrite ( "hWnd = "&$hWnd_bandwidth& @CRLF)
	  return true
   Else
	  ; Exécute le DonwloadMeter
	  ConsoleWrite ( "Exécute le DonwloadMeter "& $hWnd_bandwidth & @CRLF)
      Run("data/DonwloadMeter.exe")
   EndIf




	; Attend que la fenêtre du DonwloadMeter apparaisse.
	consoleWrite ( "Attend que la fenêtre du DonwloadMeter apparaisse. 20s"& @CRLF)
    $hWnd_bandwidth = WinWait("Network ", "", 20)

   ; si DonwloadMeter est lancer
   If WinExists("Network ") Then
	  ; cache de la fenêtre DonwloadMeter
	  WinSetState($hWnd_bandwidth, "", @SW_HIDE)
   Else
	  return false
   EndIf




    Return true
EndFunc   ;==> fin du programme


Func closeService_bandwidth()
   Global $hWnd_bandwidth
   WinClose($hWnd_bandwidth)
   WinClose("Network Usage Information NyxNight")
EndFunc