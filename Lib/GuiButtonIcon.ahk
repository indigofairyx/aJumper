;{ GuiButtonIcon

;------------------------------------------------
; FUNCTION to Assign an Icon to a Gui Button
; Fanatic Guru ; 2014 05 31 ; Version 2.0
; Method:
;   GuiButtonIcon(Handle, File, Options)
;
;   Parameters:
;   1) {Handle} 	HWND handle of Gui button
;   2) {File} 		File containing icon image
;   3) {Index} 		Index of icon in file
;						Optional: Default = 1
;   4) {Options}	Single letter flag followed by a number with multiple options delimited by a space
;						W = Width of Icon (default = 16)
;						H = Height of Icon (default = 16)
;						S = Size of Icon, Makes Width and Height both equal to Size
;						L = Left Margin
;						T = Top Margin
;						R = Right Margin
;						B = Botton Margin
;						A = Alignment (0 = left, 1 = right, 2 = top, 3 = bottom, 4 = center; default = 4)
;
; Return:
;   1 = icon found, 0 = icon not found
;
; Example:
; Gui, Add, Button, w70 h38 hwndIcon, Save
; GuiButtonIcon(Icon, "shell32.dll", 259, "s30 a1 r2")
;   GuiButtonIcon(Handle, File, Options)
; Gui, Show
;
GuiButtonIcon(Handle, File, Index := 1, Options := "")
{
	RegExMatch(Options, "i)w\K\d+", W), (W="") ? W := 16 :
	RegExMatch(Options, "i)h\K\d+", H), (H="") ? H := 16 :
	RegExMatch(Options, "i)s\K\d+", S), S ? W := H := S :
	RegExMatch(Options, "i)l\K\d+", L), (L="") ? L := 0 :
	RegExMatch(Options, "i)t\K\d+", T), (T="") ? T := 0 :
	RegExMatch(Options, "i)r\K\d+", R), (R="") ? R := 0 :
	RegExMatch(Options, "i)b\K\d+", B), (B="") ? B := 0 :
	RegExMatch(Options, "i)a\K\d+", A), (A="") ? A := 4 :
	Psz := A_PtrSize = "" ? 4 : A_PtrSize, DW := "UInt", Ptr := A_PtrSize = "" ? DW : "Ptr"
	VarSetCapacity( button_il, 20 + Psz, 0 )
	NumPut( normal_il := DllCall( "ImageList_Create", DW, W, DW, H, DW, 0x21, DW, 1, DW, 1 ), button_il, 0, Ptr )	; Width & Height
	NumPut( L, button_il, 0 + Psz, DW )		; Left Margin
	NumPut( T, button_il, 4 + Psz, DW )		; Top Margin
	NumPut( R, button_il, 8 + Psz, DW )		; Right Margin
	NumPut( B, button_il, 12 + Psz, DW )	; Bottom Margin	
	NumPut( A, button_il, 16 + Psz, DW )	; Alignment
	SendMessage, BCM_SETIMAGELIST := 5634, 0, &button_il,, AHK_ID %Handle%
	return IL_Add( normal_il, File, Index )
}


/*
#SingleInstance, Force
buttoniconsample:
Gui, Add, Button, w22 h22 hwndIcon
if !GuiButtonIcon(Icon, "some.exe") ; Example of Icon not found
    GuiButtonIcon(Icon, "shell32.dll") ; Not Found then do this

Gui, Add, Button, w22 h22 hwndIcon
GuiButtonIcon(Icon, A_AhkPath)
Gui, Add, Button, w22 h22 hwndIcon
GuiButtonIcon(Icon, "shell32.dll", 23)

; Gui, Add, Button, w38 h38 hwndIcon1, ; trash
Gui, Add, Button,  hwndIcon1, % "       Empty Trash      " ; trash
Gui, Add, Button, w38 h38 hwndIcon2 ; printer
Gui, Add, Button, w70 h38 hwndIcon3, Open
Gui, Add, Button, w70 h38 hwndIcon4, % " Save"
Gui, Add, Button, w70 h60 hwndIcon5, % "            Cut`n`n DANGER"
; GuiButtonIcon(Icon1, "shell32.dll", 33, "s32")
GuiButtonIcon(Icon1, "shell32.dll", 33, "s32 a0")
GuiButtonIcon(Icon2, "imageres.dll", 46, "s32 a1")
GuiButtonIcon(Icon3, "shell32.dll", 46, "s32 a0 l2")
GuiButtonIcon(Icon4, "shell32.dll", 259, "s32 a1 r2")
GuiButtonIcon(Icon5, "X:\XI\icons extracted from software\more gen Icons 24x24\009_cut_24x24.ico", 0, "s40 r20 b20")

Gui, Show

Return
GuiEscape:
GuiClose:
ExitApp 

*/
