#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=ico_apM_icon.ico
#AutoIt3Wrapper_Res_Description=Pinging tool
#AutoIt3Wrapper_Res_Fileversion=0.0.0.4
#AutoIt3Wrapper_Res_ProductVersion=0.0.0.4
#AutoIt3Wrapper_Res_CompanyName=4Wobi
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------------------------

Program: Ping-Overlay
Author:	Wobi
Date:	17.03.2020
Version: 0.0.0.4
Function: Ping a address with overlay

	Copyright (C) 2020 4Wobi.com - All rights reserved.

#ce ----------------------------------------------------------------------------------------------

#include <WinApi.au3>
#include <MsgBoxConstants.au3>
#include <GuiTab.au3>
#include <lib/ColorPicker.au3>
#include <WinAPISysWin.au3>
#include <Constants.au3>
#include <GUIConstants.au3>
#include <Date.au3>
#include <TrayConstants.au3>

#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiStatusBar.au3>
#include <StaticConstants.au3>
#include <TabConstants.au3>
#include <WindowsConstants.au3>
#include <SliderConstants.au3>


Opt('MustDeclareVars', 1)
Opt("TrayOnEventMode", 0)
Opt("TrayMenuMode", 3)
Opt("TrayAutoPause", 0)


TraySetIcon("ico_apM_icon.ico")
TraySetClick(16)


Dim Const $log = @ScriptDir & "\log\" & _NowDate() & ".log"
Global $is_minimized = 0
Global $is_overlayd = 0
Global $VERSION = "0.0.0.4"
Global $VDate = "17.03.2020"
Global $SleepTime = 1000
Global $ActualTime = TimerInit()
Global $DiffTime
Global $StartPing = 0
Global $gSleep = 1
Global $maxping = 500
Global $PingOverlayOffsetX = 50
Global $PingOverlayOffsetY = $PingOverlayOffsetX
Global $PingOVerlayColorTrans = 0x009DE7
Global $OverlayLabelColor = 0xFFFF00
Global $PingBGColor = 0x000000
Global $OverlayPingLabelLow = 0xFF0000
Global $GUI_cor_PingOverlayW = 71
Global $GUI_cor_PingOverlayH = 38
Global $DebugState = 0
Global $SavePingtoFile = 0
Global $pingadress = "8.8.8.8"
Global $ZeroPing = 0
Global $ZeroPingMin = 9
Global $ZeroPingMax = 10

; Create custom (4 x 5) color palette
Dim $aPalette[20] = _
		[0xFFFFFF, 0x000000, 0xC0C0C0, 0x808080, _
		0xFF0000, 0x800000, 0xFFFF00, 0x808000, _
		0x00FF00, 0x008000, 0x00FFFF, 0x008080, _
		0x0000FF, 0x000080, 0xFF00FF, 0x800080, _
		0xC0DCC0, 0xA6CAF0, 0xFFFBF0, 0xA0A0A4]


#Region ### START Koda GUI section ### Form=\\rapposfatboy\rappo\temtem\autoit\bot\gui_ping.kxf
Global $GUI_f_Pinger = GUICreate("4Wobi - Pinger", 256, 178, 317, 231)
Global $GUI_smi_Program = GUICtrlCreateMenu("&Program")
Global $GUI_smi_Start = GUICtrlCreateMenuItem("Start" & @TAB & "F5", $GUI_smi_Program)
Global $GUI_smi_Stop = GUICtrlCreateMenuItem("&Stop" & @TAB & "F6", $GUI_smi_Program)
GUICtrlSetState(-1, $GUI_DISABLE)
Global $GUI_smi_ = GUICtrlCreateMenuItem("", $GUI_smi_Program)
Global $GUI_smi_Exit = GUICtrlCreateMenuItem("&Exit", $GUI_smi_Program)
Global $GUI_smi_Options = GUICtrlCreateMenu("&Options")
Global $GUI_smi_AlwaysOnTop = GUICtrlCreateMenuItem("&AlwaysOnTop", $GUI_smi_Options)
Global $GUI_smi_Debug = GUICtrlCreateMenuItem("Debug", $GUI_smi_Options)
Global $GUI_smi_Help = GUICtrlCreateMenu("&Help")
Global $GUI_smi_HelpSub = GUICtrlCreateMenuItem("Help" & @TAB & "F1", $GUI_smi_Help)
Global $GUI_smi_About = GUICtrlCreateMenuItem("&About", $GUI_smi_Help)
Global $GUI_smi_Update = GUICtrlCreateMenuItem("&Update", $GUI_smi_Help)
GUICtrlSetState(-1, $GUI_DISABLE)
Global $GUI_sb = _GUICtrlStatusBar_Create($GUI_f_Pinger, -1, "", -1, $WS_EX_STATICEDGE)
Global $aParts[] = [55, 135, 190, 250]
_GUICtrlStatusBar_SetParts($GUI_sb, $aParts)
_GUICtrlStatusBar_SetText($GUI_sb, "Status", 0)
_GUICtrlStatusBar_SetText($GUI_sb, "Ping", 1)
_GUICtrlStatusBar_SetText($GUI_sb, "ErrorMsg", 2)
_GUICtrlStatusBar_SetText($GUI_sb, "", 3)
Global $GUI_t_MainTab = GUICtrlCreateTab(0, 0, 249, 137)
Global $GUI_ts_Ping = GUICtrlCreateTabItem("Ping")
Global $GUI_g_Ping = GUICtrlCreateGroup("Ping", 4, 25, 241, 106)
Global $GUI_i_Delay = GUICtrlCreateInput("500", 52, 49, 106, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
Global $GUI_l_Delay = GUICtrlCreateLabel("Delay", 12, 51, 31, 17)
Global $GUI_cb_SavePingToFile = GUICtrlCreateCheckbox("Save Data", 160, 49, 80, 17)
Global $GUI_l_Adress = GUICtrlCreateLabel("Adress", 12, 75, 36, 17)
Global $GUI_i_Adress = GUICtrlCreateInput("8.8.8.8", 52, 73, 106, 21)
Global $GUI_comb_Address = GUICtrlCreateCombo("Default", 52, 97, 106, 21, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "Dead by Daylight|Costum")
Global $GUI_b_Edit = GUICtrlCreateButton("Edit", 170, 97, 59, 21)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlCreateGroup("", -99, -99, 1, 1)
Global $GUI_ts_Overlay = GUICtrlCreateTabItem("Overlay")
Global $GUI_g_Overlay = GUICtrlCreateGroup("Overlay", 4, 25, 241, 105)
Global $GUI_cb_Overlay = GUICtrlCreateCheckbox("Overlay", 10, 49, 57, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
Global $GUI_rb_TopLeft = GUICtrlCreateRadio("TopLeft", 12, 81, 57, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
Global $GUI_rb_TopRight = GUICtrlCreateRadio("TopRight", 84, 81, 65, 17)
Global $GUI_rb_BottomLeft = GUICtrlCreateRadio("BottomLeft", 12, 105, 65, 17)
Global $GUI_rb_BottomRight = GUICtrlCreateRadio("BottomRight", 84, 105, 73, 17)
Global $GUI_cb_OverlayBG = GUICtrlCreateCheckbox("Background", 68, 49, 80, 17)
Global $GUI_i_OverlayOffSetX = GUICtrlCreateInput("50", 153, 40, 33, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
Global $GUI_i_OverlayOffSetY = GUICtrlCreateInput("50", 153, 64, 33, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
; Create Picker2 with custom color palette
Global $GUI_cp_PingLabel = _GUIColorPicker_Create('', 192, 40, 50, 23, $OverlayLabelColor, BitOR($CP_FLAG_CHOOSERBUTTON, $CP_FLAG_ARROWSTYLE, $CP_FLAG_MOUSEWHEEL), $aPalette, 4, 5, 0, '', 'More...')
Global $GUI_cp_PingBG = _GUIColorPicker_Create('', 192, 64, 50, 23, $PingBGColor, BitOR($CP_FLAG_CHOOSERBUTTON, $CP_FLAG_ARROWSTYLE, $CP_FLAG_MOUSEWHEEL), $aPalette, 4, 5, 0, '', 'More...')
Global $GUI_s_OverlayTP = GUICtrlCreateSlider(168, 96, 70, 29, BitOR($GUI_SS_DEFAULT_SLIDER, $TBS_NOTICKS))
GUICtrlSetLimit(-1, 255, 0)
GUICtrlSetData(-1, 255)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateTabItem("")
Dim $GUI_f_Pinger_AccelTable[3][2] = [["{F5}", $GUI_smi_Start], ["{F6}", $GUI_smi_Stop], ["{F1}", $GUI_smi_HelpSub]]
GUISetAccelerators($GUI_f_Pinger_AccelTable)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

Global $PingOverlay = GUICreate("4Wobi-PingerOverlay", $GUI_cor_PingOverlayW, $GUI_cor_PingOverlayH, 0, 0, $WS_POPUP, $WS_EX_LAYERED + $WS_EX_TOOLWINDOW)
WinMove($PingOverlay, "", 0 + 50, 0 + 50)
GUISetBkColor($PingOVerlayColorTrans)
_WinAPI_SetLayeredWindowAttributes($PingOverlay, $PingOVerlayColorTrans, 255)    ; Bildhintergrund transparent machen.
WinSetOnTop($PingOverlay, "", $WINDOWS_ONTOP)
Global $GUI_l_PingOverlay = GUICtrlCreateLabel("Ping", 0, 0, 71, 42, $SS_CENTER)
GUICtrlSetFont(-1, 25, 700, 0, "MS Sans Serif")
GUICtrlSetColor(-1, $OverlayLabelColor)
;GUISetState(@SW_HIDE, $PingOverlay)
GUISetState(@SW_SHOW, $PingOverlay)


Global $Tray_mi_OpenClose = TrayCreateItem("Open/Close")
Global $Tray_m_Overlay = TrayCreateMenu("Overlay")
Global $Tray_mi_HideShowOverlay = TrayCreateItem("Hide/Show", $Tray_m_Overlay)
Global $Tray_mi_StartStopOverlay = TrayCreateItem("Start/Stop", $Tray_m_Overlay)
TrayCreateItem("")
Global $Tray_mi_Exit = TrayCreateItem("Exit")

TraySetState($TRAY_ICONSTATE_SHOW)

TraySetToolTip("4Wobi - Pinger")


If FileExists(@ScriptDir & "\log") Then
Else
	DirCreate(@ScriptDir & "\log")
EndIf


While 1
	Sleep($gSleep)

	Local $nMsg = GUIGetMsg()
	If $nMsg <> 0 Then
		If $nMsg <> -11 Then
			debug("$nMsg:" & $nMsg)
		EndIf
	EndIf

	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit


		Case $GUI_EVENT_MINIMIZE
			GUISetState(@SW_HIDE, $GUI_f_Pinger)
			$is_minimized = 1
			debug("$is_minimized: " & $is_minimized)

		Case $GUI_smi_Exit
			Exit

		Case $GUI_smi_Start
			StartPing()
		Case $GUI_smi_Stop
			StopPing()

		Case $GUI_smi_AlwaysOnTop
			AoT()

		Case $GUI_smi_Debug
			DebugTab()

		Case $GUI_smi_HelpSub
			ShellExecute(@ScriptDir & "\4Wobi-Pinger.chm")

		Case $GUI_i_Delay
			debug("$GUI_i_Delay: " & GUICtrlRead($GUI_i_Delay))

		Case $GUI_i_Adress
			InputAddress()

		Case $GUI_comb_Address
			debug("$GUI_comb_Address: " & GUICtrlRead($GUI_comb_Address))
			AddressComb()

		Case $GUI_cp_PingLabel
			$OverlayLabelColor = _GUIColorPicker_GetColor($GUI_cp_PingLabel)
			GUICtrlSetColor($GUI_l_PingOverlay, $OverlayLabelColor)

		Case $GUI_cp_PingBG
			$PingBGColor = _GUIColorPicker_GetColor($GUI_cp_PingBG)
			If GUICtrlRead($GUI_cb_OverlayBG) = 1 Then
				GUISetBkColor($PingBGColor, $PingOverlay)
			EndIf

		Case $GUI_smi_About

			AboutFunc()

			#cs
			MsgBox(64 + 262144, 'About', 'Version: ' & $VERSION & @CRLF & _
					"Date: " & $VDate & @CRLF, 0, $GUI_f_Pinger)
			#ce

		Case $GUI_cb_SavePingToFile
			Switch GUICtrlRead($GUI_cb_SavePingToFile)
				Case 1
					$SavePingtoFile = 1

				Case 4
					$SavePingtoFile = 0

			EndSwitch

		Case $GUI_s_OverlayTP
			_WinAPI_SetLayeredWindowAttributes($PingOverlay, $PingOVerlayColorTrans, GUICtrlRead($GUI_s_OverlayTP))

		Case $GUI_rb_TopLeft
			WinMove($PingOverlay, "", 0 + $PingOverlayOffsetX, 0 + $PingOverlayOffsetY)
		Case $GUI_rb_TopRight
			WinMove($PingOverlay, "", @DesktopWidth - $PingOverlayOffsetX - $GUI_cor_PingOverlayW, 0 + $PingOverlayOffsetY)
		Case $GUI_rb_BottomLeft
			WinMove($PingOverlay, "", 0 + $PingOverlayOffsetX, @DesktopHeight - $PingOverlayOffsetY - $GUI_cor_PingOverlayH)
		Case $GUI_rb_BottomRight
			WinMove($PingOverlay, "", @DesktopWidth - $PingOverlayOffsetX - $GUI_cor_PingOverlayW, @DesktopHeight - $PingOverlayOffsetY - $GUI_cor_PingOverlayH)

		Case $GUI_cb_Overlay
			Switch GUICtrlRead($GUI_cb_Overlay)
				Case 1
					GUISetState(@SW_SHOW, $PingOverlay)
					$is_overlayd = 0
				Case 4
					GUISetState(@SW_HIDE, $PingOverlay)
					$is_overlayd = 1
			EndSwitch

		Case $GUI_cb_OverlayBG
			Switch GUICtrlRead($GUI_cb_OverlayBG)
				Case 1
					GUISetBkColor($PingBGColor, $PingOverlay)
				Case 4
					GUISetBkColor($PingOVerlayColorTrans, $PingOverlay)
			EndSwitch

		Case $GUI_i_OverlayOffSetX
			OverlayOffset()

		Case $GUI_i_OverlayOffSetY
			OverlayOffset()

	EndSwitch


	$nMsg = TrayGetMsg()
	Switch $nMsg

		Case $TRAY_EVENT_PRIMARYUP
			ToggleTray()

		Case $Tray_mi_Exit
			Exit

		Case $Tray_mi_OpenClose
			ToggleTray()

		Case $Tray_mi_HideShowOverlay
			ToggleOverlay()

		Case $Tray_mi_StartStopOverlay
			Switch $StartPing
				Case 0
					StartPing()
				Case 1
					StopPing()
			EndSwitch

	EndSwitch

	If $StartPing = 1 Then
		UDF_Ping()
	EndIf

WEnd

Func StartPing()

	$StartPing = 1 ;TurnOnPingUDF

	GUICtrlSetState($GUI_smi_Start, $GUI_DISABLE)
	GUICtrlSetState($GUI_smi_Stop, $GUI_ENABLE)
	_GUICtrlStatusBar_SetText($GUI_sb, "Running", 0)         ;ChangeStatusBar(0) to Running
	_GUICtrlStatusBar_SetText($GUI_sb, "", 2)
	debug("$StartPing: " & $StartPing)

	Return

EndFunc   ;==>StartPing


Func StopPing()

	$StartPing = 0 ;TurnOffPingUDF
	GUICtrlSetState($GUI_smi_Stop, $GUI_DISABLE)
	GUICtrlSetState($GUI_smi_Start, $GUI_ENABLE)
	_GUICtrlStatusBar_SetText($GUI_sb, "Stoped", 0) ;ChangeStatusBar(0) to Stoped(0)
	_GUICtrlStatusBar_SetText($GUI_sb, "Ping", 1) ;ChangeStatusBar(1) RemovePing
	GUICtrlSetData($GUI_l_PingOverlay, "Stop") ;ChangeStateOverlay Stop
	TraySetToolTip("4Wobi - Pinger: Stoped")

	debug("$StartPing: " & $StartPing)

	Return

EndFunc   ;==>StopPing

Func UDF_Ping()

	If $ZeroPing >= $ZeroPingMin And $ZeroPing < $ZeroPingMax Then
		$SleepTime = 1000 * $ZeroPing
	ElseIf $ZeroPing >= $ZeroPingMax Then
		$SleepTime = 1000 * $ZeroPingMax
	Else
		$SleepTime = (GUICtrlRead($GUI_i_Delay) + 10)
	EndIf

	$DiffTime = TimerDiff($ActualTime)
	If $DiffTime > $SleepTime Then

		$ActualTime = TimerInit()


		If _IsInternetConnected() = True Then

		Else

		EndIf


		Local $ping = Ping($pingadress, ($GUI_i_Delay))


		If $ping Then
			debug("Pinging: " & $ping)
			_GUICtrlStatusBar_SetText($GUI_sb, "", 2)
		Else
			Local $pingerror = @error
			debug("PingErrorCode: " & @error)

			If $pingerror = 1 Then
				_GUICtrlStatusBar_SetText($GUI_sb, "Error 4", 1)
				StopPing()
				Return
			ElseIf $pingerror = 2 Then
				_GUICtrlStatusBar_SetText($GUI_sb, "Error 2", 2)

			ElseIf $pingerror = 3 Then
				_GUICtrlStatusBar_SetText($GUI_sb, "Error 3", 2)
				StopPing()
				Return
			ElseIf $pingerror = 4 Then
				_GUICtrlStatusBar_SetText($GUI_sb, "Error 4", 2)
				StopPing()
				MsgBox(48 + 4096, "Error 4", "Please Check Your Ping - Address!", 0, $GUI_f_Pinger)
				GUICtrlSetBkColor($GUI_i_Adress, 0xFF0000)
				Return
			EndIf
		EndIf


		If $ping = 0 Then
			$ZeroPing += 1
		Else
			$ZeroPing = 0
		EndIf


		If $ZeroPing >= $ZeroPingMin And $ZeroPing < $ZeroPingMax Then
			debug("$ZeroPing: " & $ZeroPing)
			_GUICtrlStatusBar_SetText($GUI_sb, $ZeroPing & "s", 3)
			GUICtrlSetFont(-1, 25, 700, 8, "MS Sans Serif")
		ElseIf $ZeroPing >= 30 Then
			debug("$ZeroPing: " & $ZeroPing)
			_GUICtrlStatusBar_SetText($GUI_sb, "30s", 3)
			GUICtrlSetFont(-1, 25, 700, 8, "MS Sans Serif")
		Else
			_GUICtrlStatusBar_SetText($GUI_sb, "", 3)
			GUICtrlSetFont(-1, 25, 700, 0, "MS Sans Serif")
		EndIf


		GUICtrlSetData($GUI_l_PingOverlay, $ping)


		If $ping < 1 Then
			GUICtrlSetColor($GUI_l_PingOverlay, $OverlayPingLabelLow)
		Else
			GUICtrlSetColor($GUI_l_PingOverlay, $OverlayLabelColor)
		EndIf


		_GUICtrlStatusBar_SetText($GUI_sb, "Ping " & $ping & "ms", 1)

		TraySetToolTip("4Wobi - Pinger: " & $ping & "ms")

		If $SavePingtoFile = 1 Then
			Local $message = _Now() & @TAB & $pingadress & @TAB & $ping
			FileWriteLine($log, $message)
			debug("Save to File: " & @TAB & $log & @CRLF & @TAB & @TAB & @TAB & "msg:" & $message)
		EndIf

	EndIf

	Return

EndFunc   ;==>UDF_Ping

Func InputAddress()

	$pingadress = GUICtrlRead($GUI_i_Adress)
	GUICtrlSetBkColor($GUI_i_Adress, 0xFFFFFF)
	GUICtrlSetData($GUI_comb_Address, "Costum")

	Return

EndFunc   ;==>InputAddress

Func OverlayOffset()

	$PingOverlayOffsetX = GUICtrlRead($GUI_i_OverlayOffSetX)
	$PingOverlayOffsetY = GUICtrlRead($GUI_i_OverlayOffSetY)

	If GUICtrlRead($GUI_rb_TopLeft) = $GUI_CHECKED Then
		WinMove($PingOverlay, "", 0 + $PingOverlayOffsetX, 0 + $PingOverlayOffsetY)

	ElseIf GUICtrlRead($GUI_rb_TopRight) = $GUI_CHECKED Then
		WinMove($PingOverlay, "", @DesktopWidth - $PingOverlayOffsetX - $GUI_cor_PingOverlayW, 0 + $PingOverlayOffsetY)

	ElseIf GUICtrlRead($GUI_rb_BottomLeft) = $GUI_CHECKED Then
		WinMove($PingOverlay, "", 0 + $PingOverlayOffsetX, @DesktopHeight - $PingOverlayOffsetY - $GUI_cor_PingOverlayH)

	ElseIf GUICtrlRead($GUI_rb_BottomRight) = $GUI_CHECKED Then
		WinMove($PingOverlay, "", @DesktopWidth - $PingOverlayOffsetX - $GUI_cor_PingOverlayW, @DesktopHeight - $PingOverlayOffsetY - $GUI_cor_PingOverlayH)

	Else

	EndIf

	debug("$PingOverlayOffsetX: " & $PingOverlayOffsetX & @CRLF & "$PingOverlayOffsetX: " & $PingOverlayOffsetY)

	Return

EndFunc   ;==>OverlayOffset

Func AoT()
	If BitAND(GUICtrlRead($GUI_smi_AlwaysOnTop), $GUI_CHECKED) = $GUI_CHECKED Then
		GUICtrlSetState($GUI_smi_AlwaysOnTop, $GUI_UNCHECKED)
		WinSetOnTop($GUI_f_Pinger, "", $WINDOWS_NOONTOP)
	Else
		GUICtrlSetState($GUI_smi_AlwaysOnTop, $GUI_CHECKED)
		WinSetOnTop($GUI_f_Pinger, "", $WINDOWS_ONTOP)
	EndIf

	debug("$GUI_smi_AlwaysOnTop: " & GUICtrlRead($GUI_smi_AlwaysOnTop))

	Return

EndFunc   ;==>AoT

Func DebugTab()

	If BitAND(GUICtrlRead($GUI_smi_Debug), $GUI_CHECKED) = $GUI_CHECKED Then
		GUICtrlSetState($GUI_smi_Debug, $GUI_UNCHECKED)
		$DebugState = 0
	Else
		GUICtrlSetState($GUI_smi_Debug, $GUI_CHECKED)
		$DebugState = 1
	EndIf

	debug("$DebugState: " & $DebugState)

	Return

EndFunc   ;==>DebugTab

Func AddressComb()

	Local $string = GUICtrlRead($GUI_comb_Address)

	If $string = "Dead by Daylight" Then
		GUICtrlSetData($GUI_i_Adress, "steam.live.bhvrdbd.com")
		$pingadress = GUICtrlRead($GUI_i_Adress)
	Else
		GUICtrlSetData($GUI_i_Adress, "8.8.8.8")
		$pingadress = GUICtrlRead($GUI_i_Adress)
	EndIf

	debug("AddressComb(): " & $string)

	Return

EndFunc   ;==>AddressComb

Func ToggleOverlay()
	If $is_overlayd = 1 Then
		GUISetState(@SW_SHOW, $PingOverlay)
		GUICtrlSetState($GUI_cb_Overlay, $GUI_CHECKED)
		$is_overlayd = 0
	Else
		GUISetState(@SW_HIDE, $PingOverlay)
		GUICtrlSetState($GUI_cb_Overlay, $GUI_UNCHECKED)
		$is_overlayd = 1
	EndIf

EndFunc   ;==>ToggleOverlay

Func ToggleTray()
	If $is_minimized = 1 Then
		GUISetState(@SW_SHOW, $GUI_f_Pinger)
		$is_minimized = 0
	Else
		GUISetState(@SW_HIDE, $GUI_f_Pinger)
		$is_minimized = 1
	EndIf
	debug("$is_minimized: " & $is_minimized)
EndFunc   ;==>ToggleTray

Func AboutFunc()

	GUISetState(@SW_DISABLE, $GUI_f_Pinger)
	GUICtrlSetData($GUI_l_PingOverlay, "---")

	Local $GUI_f_About = GUICreate('About', 322, 194, -1, -1, BitXOR($GUI_SS_DEFAULT_GUI, $WS_MINIMIZEBOX), BitOR($WS_EX_TOPMOST, $WS_EX_WINDOWEDGE), WinGetHandle(AutoItWinGetTitle()))
	Local $GUI_g_About = GUICtrlCreateGroup("", 8, 8, 305, 145)
	Local $GUI_im_Image = GUICtrlCreatePic("", 16, 24, 105, 97)
	Local $GUI_l_ProductName = GUICtrlCreateLabel("Pinger Tool", 128, 24, 72, 17)
	Local $GUI_l_Version = GUICtrlCreateLabel("Version: " & $VERSION, 128, 64, 100, 17)
	Local $GUI_l_Version = GUICtrlCreateLabel("Date: " & $VDate, 128, 84, 100, 17)
	Local $GUI_l_Copyright = GUICtrlCreateLabel("by 4Wobi", 16, 128, 48, 17)
	Local $GUI_g_Buttons = GUICtrlCreateGroup("", 232, 8, 81, 81)
	Local $GUI_b_Donate = GUICtrlCreateButton("Donate", 232, 16, 75, 25)
	GUICtrlSetState(-1, $GUI_DISABLE)
	Local $GUI_b_Website = GUICtrlCreateButton("Website", 232, 40, 75, 25)
	GUICtrlSetState(-1, $GUI_DISABLE)
	Local $GUI_b_Forum = GUICtrlCreateButton("Forum", 232, 64, 75, 25)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	Local $GUI_b_AboutOK = GUICtrlCreateButton("&OK", 236, 160, 75, 25, 0)
	GUISetState(@SW_SHOW)

	While 1

		$nMsg = GUIGetMsg()

		If $nMsg <> 0 Then
			If $nMsg <> -11 Then
				debug("$nMsg:" & $nMsg)
			EndIf
		EndIf

		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete($GUI_f_About)
				ExitLoop

			Case $GUI_b_AboutOK
				GUIDelete($GUI_f_About)
				ExitLoop
		EndSwitch
	WEnd

	GUISetState(@SW_ENABLE, $GUI_f_Pinger)
	WinActivate($GUI_f_Pinger)

	If $StartPing = 0 Then
		GUICtrlSetData($GUI_l_PingOverlay, "Ping")
	EndIf

	Return

EndFunc   ;==>AboutFunc

Func _IsInternetConnected()
	Local $aReturn = DllCall('connect.dll', 'long', 'IsInternetConnected')
	If @error Then
		Return SetError(1, 0, False)
	EndIf
	Return $aReturn[0] = 0
EndFunc   ;==>_IsInternetConnected

Func debug($a)
	If $DebugState = 1 Then ConsoleWrite(@SEC & @TAB & " " & $a & @CRLF)
EndFunc   ;==>debug
