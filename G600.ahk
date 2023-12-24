



/*
|
|
|
|
|
------------------------------------------------------------------------------
★ 作りかけ (以下は G604 用のスクリプトのコピー)
------------------------------------------------------------------------------
|
|
|
|
|
*/


/*
------------------------------------------------------------------------------
    G Hub のオンボードメモリからの変換 (G600)
; G600 については、右クリックの更に右のボタンは充てた方が良いかも。
    ※ 現在 vk07 は windows 標準のキャプチャ機能に割当られているっぽい。
┌──┬──┬──┐                             ┌──┬──┬──┐
│F13 │F14 │F15 │                             │無F1│無F2│ConP│
├──┼──┼──┤                             ├──┼──┼──┤
│F16 │F17 │F18 │                             │無F4│無F5│ConC│
├──┼──┼──┤ → (G-shift は +無変換 で)  ├──┼──┼──┤
│F19 │F20 │F21 │                             │無F7│無F8│volU│
├──┼──┼──┤                             ├──┼──┼──┤
│Cont│Shif│F24 │                             │AltT│WinT│volD│
└──┴──┴──┘                             └──┴──┴──┘
------------------------------------------------------------------------------

/*
; Shift + Wheel を PgUp/Down にしたいが、vivaldi は Shift + Wheel を盗られいているっぽい。
WheelDown::
    If GetKeyState("Shift")
        send, {Blind}{PgDn}
    Else
        send, {Blind}{WheelDown}
    Return
Return
*/


/*
------------------------------------------------------------------------------
★ G600 のサイドボタン割当： アクティブウインドウ毎に
------------------------------------------------------------------------------
*/

#IfWinActive ahk_class classFoxitReader
    ; ▼ 左側面
	F13::^t ; G9 
    ;F14:: ; G10
    ;F15:: ; G11
    F16::^u ; G12
    F17::^h ; G13
    ;F18:: ; G14
    F19::+^c ; G15
    F20::+^s ; G16
    F21::+^l ; G17
    ;F22:: ; G18 (G600 側で Ctrl)
    ;F23:: ; G19 (G600 側で Shift)
    F24::Esc ; G20
    
    ; ▼ G-shift あり
    ;~sc07B & F1:: ; G9
    ;~sc07B & F2:: ; G10  (G600 側で Eneter)
    ;~sc07B & F3:: ; G11 (G600 側で Ctrl+P)
    ~sc07B & F4::^w ; G12
    ~sc07B & F5::^e ; G13
    ;~sc07B & F6:: ; G14 (G600 側で Ctrl+C)
    ;~sc07B & F7:: ; G15
    ;~sc07B & F8:: ; G16
    ;~sc07B & F9:: ; G17 (G600 側で 音量↑)
    ;~sc07B & F10:: ; G18 (G600 側で Alt+Tab)
    ;~sc07B & F11:: ; G19 (G600 側で Win+Tab)
    ;~sc07B & F12:: ; G20 (G600 側で 音量↓)

    ; ▼ 上部ボタン (基本は G600 側で設定)
    WheelLeft::!/
    WheelRight::!sc073 ; バックスラッシュだが、日本語キーボードで指定できないので仮想コードで指定した
    ;^sc01B::!/ ; Ctrl+[
    ;^sc02B::!sc073 ; Ctrl+]

    ; ページ指定欄にフォーカス
    ^Space::
        MouseGetPos, x0, y0
        WinGetPos, X, Y, Width, Height
        MouseMove, 160, Height - 15
        MouseClick, left
        MouseMove, x0, y0
    Return
#IfWinActive



#IfWinActive ahk_exe Notion.exe
    ; ▼ 左側面
    ;F13:: ; G9 
    ;F14:: ; G10
    ;F15:: ; G11
    F16::^u ; G12
    F17::^b ; G13
    F18::^i ; G14
    ;F19:: ; G15
    ;F20:: ; G16
    ;F21:: ; G17
    ;F22:: ; G18 (G600 側で Ctrl)
    ;F23:: ; G19 (G600 側で Shift)
    ;F24:: ; G20

    ; ▼ G-shift あり
    ;~sc07B & F1:: ; G9
    ;~sc07B & F2:: ; G10
    ;~sc07B & F3:: ; G11 (G600 側で Ctrl+P)
    ;~sc07B & F4:: ; G12
    ;~sc07B & F5:: ; G13
    ;~sc07B & F6:: ; G14 (G600 側で Ctrl+C)
    ;~sc07B & F7:: ; G15
    ;~sc07B & F8:: ; G16
    ;~sc07B & F9:: ; G17 (G600 側で 音量↑)
    ;~sc07B & F10:: ; G18 (G600 側で Alt+Tab)
    ;~sc07B & F11:: ; G19 (G600 側で Win+Tab)
    ;~sc07B & F12:: ; G20 (G600 側で 音量↓)

    ; ▼ 上部ボタン (基本は G600 側で設定)
    ;WheelLeft:: ;
    ;WheelRight:: ; 
    ;^sc01B:: ; 
    ;^sc02B:: ; 
#IfWinActive



#IfWinActive ahk_exe LVEDVIEWER.exe
    ; 検索欄にフォーカス
    ^E::
        MouseGetPos, x0, y0
        MouseMove, 230, 45
        MouseClick, left
        MouseMove, x0, y0
    Return
    ^F::
        MouseGetPos, x0, y0
        WinGetPos, X, Y, Width, Height
        MouseMove, Width * 0.42, 100
        MouseClick, left
        MouseMove, x0, y0
    Return
#IfWinActive



/*
------------------------------------------------------------------------------
★ G600 のサイドボタン割当： アクティブウインドウ無し時
------------------------------------------------------------------------------
*/

; ★ サイドのボタンの割当 候補 ① ： 右クリックは生かしたまま修飾キーとしても使用
; Send 以下の F13-24 の部分を適宜変更する。
; ▼ 左側面
;F13:: ; G9 
;F14:: ; G10
;F15:: ; G11
;F16:: ; G12
;F17:: ; G13
;F18:: ; G14
;F19:: ; G15
;F20:: ; G16
;F21:: ; G17
;F22:: ; G18 (G600 側で Ctrl)
;F23:: ; G19 (G600 側で Shift)
;F24:: ; G20

; ▼ G-shift あり
;~sc07B & F1:: ; G9
;~sc07B & F2:: ; G10
;~sc07B & F3:: ; G11 (G600 側で Ctrl+P)
;~sc07B & F4:: ; G12
;~sc07B & F5:: ; G13
;~sc07B & F6:: ; G14 (G600 側で Ctrl+C)
;~sc07B & F7:: ; G15
;~sc07B & F8:: ; G16
;~sc07B & F9:: ; G17 (G600 側で 音量↑)
;~sc07B & F10:: ; G18 (G600 側で Alt+Tab)
;~sc07B & F11:: ; G19 (G600 側で Win+Tab)
;~sc07B & F12:: ; G20 (G600 側で 音量↓)

; ▼ 上部ボタン (基本は G600 側で設定)


; ★ 候補 ②
; RButton は GetKyeState(RButton, P) で物理的な押し下げ状態を判定する分岐の方が良いかも。
/*
F13::GetKeyState(Rbutton, "P") ? [] : Rbutton
*/


