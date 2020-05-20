
#include <WinAPISys.au3>
#include <ColorPicker.au3>

Global $OverlayLabelColor = 0xFFFF00
Global $PingBGColor = 0x000000

; Create custom (4 x 5) color palette
Dim $aPalette[20] = _
		[0xFFFFFF, 0x000000, 0xC0C0C0, 0x808080, _
		0xFF0000, 0x800000, 0xFFFF00, 0x808000, _
		0x00FF00, 0x008000, 0x00FFFF, 0x008080, _
		0x0000FF, 0x000080, 0xFF00FF, 0x800080, _
		0xC0DCC0, 0xA6CAF0, 0xFFFBF0, 0xA0A0A4]

GUICreate("ColorPicker", 200, 200)

Global $GUI_cp_PingLabel = _GUIColorPicker_Create('', 15, 40, 50, 23, $OverlayLabelColor, BitOR($CP_FLAG_CHOOSERBUTTON, $CP_FLAG_ARROWSTYLE, $CP_FLAG_MOUSEWHEEL), $aPalette, 4, 5, 0, '', 'More...')
Global $GUI_cp_PingBG = _GUIColorPicker_Create('', 15, 64, 50, 23, $PingBGColor, BitOR($CP_FLAG_CHOOSERBUTTON, $CP_FLAG_ARROWSTYLE, $CP_FLAG_MOUSEWHEEL), $aPalette, 4, 5, 0, '', 'More...')

GUISetState(@SW_SHOW)

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
	EndSwitch
WEnd
