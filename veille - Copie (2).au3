
#include <_XMLDomWrapper_.au3>
#include <Date.au3>
#include <MsgBoxConstants.au3>
#include <FileConstants.au3>
#include <MouseOnEvent.au3>
#include <config.au3>
#include <config_anykey.au3>




; empeche d'avoir un ecran de login a la sortie de veille
;RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Personalization", "NoLockScreen", "REG_DWORD",  1)

; si la config veut enlever l'ecran de login
if $NO_LOCK_SCREEN = 1 Then
	Global $NoLockScreenValue = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Personalization", "NoLockScreen")
	$NoLockScreenValue = Number( $NoLockScreenValue )

	; si dans le registre windows (regedit) il n y a pas la valeur NoLockScreen et que la config veut enlever l'ecran de login a la sortie de la veille
	; alor en creer NoLockScreen = 1 dans la base de registre
	if $NoLockScreenValue = 0 and $NO_LOCK_SCREEN = 1 Then
		RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Personalization", "NoLockScreen", "REG_DWORD",  1)
	Endif

Else ; sinon on verifie qu'on n'as pas laisser cette valeur dans le registre

	Global $NoLockScreenValue = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Personalization", "NoLockScreen")
	$NoLockScreenValue = Number( $NoLockScreenValue )


	if $NoLockScreenValue = 1 Then
		RegDelete( "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Personalization", "NoLockScreen" )
	Endif
Endif

If $NO_LOCK_SCREEN = 1 Then
	ecranDeVerouillage(0)
Else
	ecranDeVerouillage(1)
Endif


HotKeySet ( "!{DOWN}", "shortcutKey" )


; efface le contenue du log si il existe a chaque lancement du programme
effaceLog()


; reste a faire
; - une playliste des titre de fenetre empechant le non execution du programe
;   qui ce limite pour linstant a youtube: winFocusOffTitle("- YouTube -")

;-  reorganiser le etapes de fa�on a revenir sur le test d'utilisateur inactif (bouger souris)

; - determinier un temps pour declencher le standby  si une page genre youtube dure plus de 2h



$setInactifUser = false
; boucle du programme. Continue tant que le debit est trop �l�v�
While $setInactifUser = false or $nonStop = true


	Global $time=0











	print ( "Relance ")
	;lance ou relance freemeter
	if initService_bandwidth() <> true Then
	   MsgBox ( 0, "Program erreur", "FreeMeter est introuvable" , 60 )
	   Exit
	Endif
	Sleep(800)
	print ( " Effectu�"& @CRLF)







	; demande que l'utilisateur soit actif pour commencer le programme
	; Cela permet de detecter si le pc est sortir de la veille sans relancer la veille trop tot
	; fonnctionne seulement si la config est programmer pour moins de 60 secondes
	if $STANDBY_TIME < 60 and $mise_en_veille = true Then
		$time_start_wait = _NowCalc()
		waitActifUser()
	EndIf

   ;DETECTION DE L'UTILISATEUR INACTIF
    While $setInactifUser = false

		if isInactifUser() then
			print ( "Inactif User " & @CRLF)
			$setInactifUser = true
		EndIf
    WEnd




	; Fait une pause dans le programme si il y a un copier coller en cour.
	$copierCollerEnCour = false
	Do
		if WinGetText("[CLASS:OperationStatusWindow]")<> "" Then
			print ( "Copie en cour d�tecter "& WinGetTitle("[CLASS:OperationStatusWindow]") & @CRLF)
			$copierCollerEnCour = true
		Else
			$copierCollerEnCour = false
		Endif
		Sleep(500)
	Until  $copierCollerEnCour = false














   ; DETECTION D'un telechargement avec pour limite par defaut de 100 kB/s (voir fichier config)
   $birateMoyen = averageBirateKB()
   print ( "debit detecter "& $birateMoyen  & " kB/s de moyenne"& @CRLF)
   if $birateMoyen > $LOW_LIMIT_DOWNLOAD Then
	  $setInactifUser = false
   Else
	  ; force la reverification d'une inactivit� de l'utilisateur
	  $setInactifUser = false
	  ; compteur d'inativit� remis a zero
	  $EPOCH = _NowCalc()
	  ; fermeture du programme freemeter
	  closeService_bandwidth()
	  ; mise en veille du pc (valeur 32 par defaut)
	  Shutdown( Int( Number($SHUTDOWN_TYPE) ))
	  $mise_en_veille = true
	  Sleep(3000)
   EndIf
WEnd


; fermeture du programme freemeter
closeService_bandwidth()
; mise en veille du pc (valeur 32 par defaut)
Shutdown( Int( Number($SHUTDOWN_TYPE) ))




















Func shortcutKey()
	Global $time = 99999
	print( "Bye" & @CRLF )
EndFunc








func ecranDeVerouillage( $etat)

if $etat = 0 then
	if FileExists ( "C:\Windows\SystemApps\Microsoft.LockApp_cw5n1h2txyewy" ) Then

		DirMove ( "C:\Windows\SystemApps\Microsoft.LockApp_cw5n1h2txyewy", "C:\Windows\SystemApps\Microsoft.LockApp_cw5n1h2txyewy_back" , 1 )
		ConsoleWrite( "suppressions de l'ecran de verouillage" & @CRLF )

	EndIf
Else

	if FileExists ( "C:\Windows\SystemApps\Microsoft.LockApp_cw5n1h2txyewy_back" ) Then

		DirMove ( "C:\Windows\SystemApps\Microsoft.LockApp_cw5n1h2txyewy_back", "C:\Windows\SystemApps\Microsoft.LockApp_cw5n1h2txyewy" , 1 )
		ConsoleWrite( "installation de l'ecran de verouillage" & @CRLF )
	Else
		ConsoleWrite( "echec"  & @CRLF)
	EndIf
EndIf

EndFunc






Func effaceLog()
	If $NO_LOG = 0 then
		If Not FileCreate("./data.log", "") Then

		Else
			Global $hFileOpen_OVERWRITE = FileOpen("./data.log", $FO_OVERWRITE )
			FileWrite($hFileOpen_OVERWRITE, "")
			FileClose($hFileOpen_OVERWRITE)
		Endif
	Endif
EndFunc





#include <fonctions_anykey.au3>


; affiche dans la console un message et permet de revenir dessus grace au log
; car l'editeur Scite disparrait apres la mise en veille
Func print($message)
	If $NO_LOG = 0 then
		If Not FileCreate("./data.log", "") Then

		Else
			Global $hFileOpen = FileOpen("./data.log", $FO_APPEND)
			consoleWrite ($message)
			FileWriteLine($hFileOpen, $message)
			FileClose($hFileOpen)
		Endif
	Else
		consoleWrite ($message)
	Endif
EndFunc





;Cr�ez un fichier.
Func FileCreate($sFilePath, $sString)
    Local $bReturn = True ; Cr�e une variable pour stocker une valeur bool�enne.
    If FileExists($sFilePath) = 0 Then $bReturn = FileWrite($sFilePath, $sString) = 1 ; Si FileWrite retourne 1 ce sera Vrai sinon Faux.
    Return $bReturn ; Retourne la valeur bool�enne soit Vrai ou Faux, en fonction de la valeur de retour de FileWrite.
EndFunc   ;== > FileCreate







Func winFocusOffTitle($findme)

	$sortirAttenteYoutube = false
	while $sortirAttenteYoutube = false

		if StringInStr(WinGetTitle("[ACTIVE]"), $findme) Then
			consoleWrite ( "Blacklist d�tecter "& @CRLF)
		Else
			$sortirAttenteYoutube = true
		Endif
		Sleep(10)
	WEnd
EndFunc






Func waitActifUser()

   local $aPos
   local $aPosCache
   $aPos = MouseGetPos()
   $aPosCache = $aPos[0]

   while 1

	  Global $time_start_wait
	  $NOW = _NowCalc()
	  $time = Number( _DateDiff("s", $time_start_wait, $NOW) )
	  ;print ( "time " & $time & @CRLF)
	  if $time > 59 Then
		  ExitLoop
	  EndIf



	  $aPos = MouseGetPos()

	  if $aPos[0] <> $aPosCache Then
		 return true
	  Endif

	  $aPosCache = $aPos[0]

	  Sleep(300)
	  ControlSetText('', '', 'Scintilla2', '')
	  consoleWrite ( "Wait "&$time& @CRLF)


   WEnd

EndFunc




Func averageBirateKB()

   $loopCount = 0
   $average_birate_inKB = 0;
   $current_birate_inKB = 0;

   global $hWnd_bandwidth
   Global $LOW_LIMIT_DOWNLOAD

   While $loopCount < 50
	  ; recupere le debit a partir du program freemeter lanc�
	  Local $sBitrates = ControlGetText($hWnd_bandwidth, "", "[CLASS:WindowsForms10.STATIC.app.0.33c0d9d; INSTANCE:1]")

	  ; determine la valeur si c'est en bytes ou kilo byte
	  Local $iPosition = StringInStr($sBitrates, " B/s")
	  if $iPosition Then
		 ;ConsoleWrite ( "D�bit en bytes"  )
	  Endif

	  Local $iPosition = StringInStr($sBitrates, " kB/s")
	  if $iPosition Then
		 ;ConsoleWrite ( "D�bit en kilo bytes"  )
		 $current_birate_inKB = Number($sBitrates)
	  Endif

	  Local $iPosition = StringInStr($sBitrates, " mB/s")
	  if $iPosition Then
		 ;ConsoleWrite ( "D�bit en mega bytes"  )
		 $current_birate_inKB = Number($sBitrates) * 1000
	  Endif

	  ; calcule le birate
	  $average_birate_inKB = ($average_birate_inKB + $current_birate_inKB ) /2

		if $average_birate_inKB > $LOW_LIMIT_DOWNLOAD Then
			return Int( $average_birate_inKB )
		Endif

	  ; Affiche le debit dans la console autoit
	  ;ConsoleWrite ( " " & Number($sBitrates) &  @CRLF)

	  ; compte le nombre de boucle pour verifier le debit sur un interval de temp
	  $loopCount = $loopCount + 1
	  Sleep(100)
   WEnd

   return Int( $average_birate_inKB )

EndFunc





Func closeService_bandwidth()
   Global $hWnd_bandwidth
   WinClose($hWnd_bandwidth)
EndFunc











Func moletteActifUser()
	$EPOCH = _NowCalc()
EndFunc



Func isInactifUser()
   Local $aPos
   Local $aPosCache
   Global $time = 0
   Global $STANDBY_TIME
   Global $EPOCH

   ; DETECTION DE L'UTILISATEUR INACTIF
   while  $time < $STANDBY_TIME-1



	  $aPos = MouseGetPos()


	  if $aPos[0] <> $aPosCache or $AKeyWasPressed = 1 Then
		 $EPOCH = _NowCalc()
		 $AKeyWasPressed = 0
	  Endif


	  $aPosCache  = $aPos[0]

	  $NOW = _NowCalc()
	  $time = Number( _DateDiff("s", $EPOCH, $NOW) )
	  print ( "time " & $time & @CRLF)


		; detection de page youtube active.
		; L'utilisateur est considerer actif
		winFocusOffTitle("- YouTube -")

		; detecte le mouvement (roulement) de la molette
		_MouseSetOnEvent($MOUSE_WHEELSCROLL_EVENT, "moletteActifUser", 0, 1)
	  Sleep(990)
   WEnd

   return true

EndFunc








 Func initService_bandwidth()

   Global $DIR_LOCATION_FREEMETER
   Global $hWnd_bandwidth

   ; si FreeMeter est deja lancer
   consoleWrite ( "si FreeMeter est deja lancer"& @CRLF)
   If WinExists("[CLASS:WindowsForms10.Window.8.app.0.33c0d9d]") Then
	  return true
   Else
	  ; Ex�cute le FreeMeter
	  consoleWrite ( "Ex�cute le FreeMeter"& @CRLF)
      Run($DIR_LOCATION_FREEMETER&"/FreeMeter.exe")
   EndIf








    ; Attend que la fen�tre du FreeMeter apparaisse.
	consoleWrite ( "Attend que la fen�tre du FreeMeter apparaisse. 20s"& @CRLF)
    $hWnd_bandwidth = WinWait("[CLASS:WindowsForms10.Window.8.app.0.33c0d9d]", "", 20)

   ; si FreeMeter est lancer
   If WinExists("[CLASS:WindowsForms10.Window.8.app.0.33c0d9d]") Then
	  ; cache de la fen�tre FreeMeter.
	  WinSetState($hWnd_bandwidth, "", @SW_HIDE)
   Else
	  return false
   EndIf




    Return true
 EndFunc   ;==> fin du programme










