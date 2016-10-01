	;$EPOCH = "1970/01/01 00:00:00"
	$EPOCH = _NowCalc()
	global $EPOCH

	global $time_start_wait

	global $nonStop = true

	global $hWnd_bandwidth


	Global $mise_en_veille = false


	_XMLFileOpen("config.xml")

	;$byterate_max = _XMLGetValue ( "/configuration/programme/byterate_max" )
	;$BYTERATE_MAX = $byterate_max[1]

	$standby_time = _XMLGetValue ( "/configuration/programme/standby_time" )
	Global $STANDBY_TIME
	$STANDBY_TIME = Number( $standby_time[1] )

	$low_limit_download = _XMLGetValue ( "/configuration/programme/low_limit_download" )
	$LOW_LIMIT_DOWNLOAD = Number($low_limit_download[1])
	Global $LOW_LIMIT_DOWNLOAD




	$shutdown_type = _XMLGetValue ( "/configuration/programme/shutdown" )
	$SHUTDOWN_TYPE = Number( $shutdown_type[1] )
	Global $SHUTDOWN_TYPE

	$no_lock_screen = _XMLGetValue ( "/configuration/programme/no_lock_screen" )
	$NO_LOCK_SCREEN = Number($no_lock_screen[1])
	Global $NO_LOCK_SCREEN

	$no_log = _XMLGetValue ( "/configuration/programme/no_log" )
	$NO_LOG = Number($no_log[1])
	Global $NO_LOG

	; config du programme a lancer avant mise en veille
	$call_program_enable = _XMLGetValue ( "/configuration/programme/call_program/enable" )
	$CALL_PROGRAM_ENABLE = Number($call_program_enable[1])
	Global $CALL_PROGRAM_ENABLE

	$call_program_url = _XMLGetValue ( "/configuration/programme/call_program/url" )
	$CALL_PROGRAM_URL = $call_program_url[1]
	Global $CALL_PROGRAM_URL

	$call_program_wait = _XMLGetValue ( "/configuration/programme/call_program/wait" )
	$CALL_PROGRAM_WAIT = Number($call_program_wait[1])
	Global $CALL_PROGRAM_WAIT
	; fin de config du programme a lancer avant mise en veille




















