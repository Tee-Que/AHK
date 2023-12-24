
/*
------------------------------------------------------------------------------
★ 念のため、左右同時クリックで、右クリックになるようにしておく。
    [G604 未使用時用時] 一時的に右クリックトリガーを切りたい場合は、
    以下の左右同時クリックへの RButton 割り付けを、チルダを付けて ~RButton にしてやれば右クリックは復活する。
------------------------------------------------------------------------------
*/
RButton & LButton::RButton

/*
------------------------------------------------------------------------------
    G Hub のオンボードメモリからの変換 (G604)
; G600 については、vk07 とか無害なキーを割当可能なら、薬指ボタンに vk07 を充てた方が良いかも。
    ※ 現在 vk07 は windows 標準のキャプチャ機能に割当られているっぽい。
┌──┬──┐    ┌──┐
│F15 │F18 │    │F20 │
├──┼──┤    ├──┤
│F14 │F17 │    │F19 │
├──┼──┤    └──┘
│F13 │F16 │
└──┴──┘
※ 上面の F19, F20 を割り当てているボタンは同時押し出来ないっぽい。 (G604 側の特性)
------------------------------------------------------------------------------
*/


/*
------------------------------------------------------------------------------
★ G604 のサイドボタン割当： アクティブウインドウ毎に
------------------------------------------------------------------------------
*/

#IfWinActive ahk_class classFoxitReader
	;F13::LCtrl ; G4 (手前下) ← 共通設定
    ;F14::MButton ; G5 (中列下) ← 共通設定
    F15::^u ; G6 (奥下)
    ;F16::LShift ; G7 (手前上) ← 共通設定
    ;F17::RButton ; G8 (中列上) ← 共通設定
    F18::^h ; G9 (奥上)
    ; 右クリック押下時
    ;RButton & F13::AltTab ← 共通設定
    RButton & F14::+^l
    RButton & F15::^w
    ;RButton & F16::#Tab ← 共通設定
    RButton & F17::^t
    RButton & F18::^e

    ; ★ 右クリ＋ホイール押しで Esc
    RButton & MButton::Esc

    ; ★ ホイールの調整
    ; チルト → 横スライドや通常の戻る/進むが機能していないので、ホイールチルトを戻る/進むに割り当て。
    WheelLeft::!/
    WheelRight::!sc073 ; バックスラッシュが打てないのでスキャンコードで指定
    ; RButton & WheelLeft::!Left ← 共通設定
    ; RButton & WheelRight::!Right ← 共通設定

    ; ページ指定欄にフォーカス
    ^Space::
        MouseGetPos, x0, y0
        WinGetPos, X, Y, Width, Height
        MouseMove, Width * 0.46, Height - 24
        MouseClick, left
        MouseMove, x0, y0
    Return
#IfWinActive



#IfWinActive ahk_exe Notion.exe
	;F13::LCtrl ; G4 (手前下) ← 共通設定
    ;F14::MButton ; G5 (中列下) ← 共通設定
    F15::^u ; G6 (奥下)
    ;F16::LShift ; G7 (手前上) ← 共通設定
    ;F17::RButton ; G8 (中列上) ← 共通設定
    F18::^b ; G9 (奥上)
    ; 右クリック押下時
    ;RButton & F13::AltTab ← 共通設定
    ;RButton & F14::+^l
    ;RButton & F15::^w
    ;RButton & F16::#Tab ← 共通設定
    ;RButton & F17::^t
    ;RButton & F18::^e

    ; ★ 右クリ＋ホイール押しで Esc
    RButton & MButton::Esc

    ; ★ ホイールの調整
    ; チルト → 横スライドや通常の戻る/進むが機能していないので、ホイールチルトを戻る/進むに割り当て。
    ;WheelLeft::
    ;WheelRight::
    RButton & WheelLeft::^sc01B ; 共通設定の戻る進むを上書き
    RButton & WheelRight::^sc02B ; 共通設定の戻る進むを上書き
    Return
#IfWinActive



#IfWinActive ahk_exe LVEDVIEWER.exe
    ; ページ指定欄にフォーカス
    ^E::
        MouseGetPos, x0, y0
        WinGetPos, X, Y, Width, Height
        MouseMove, 260, 60
        MouseClick, left
        MouseMove, x0, y0
    Return
    ^F::
        MouseGetPos, x0, y0
        WinGetPos, X, Y, Width, Height
        MouseMove, Width * 0.43, 120
        MouseClick, left
        MouseMove, x0, y0
    Return
#IfWinActive



/*
------------------------------------------------------------------------------
★ G604 のサイドボタン割当： アクティブウインドウ無し時
------------------------------------------------------------------------------
*/

; ★ トップ部分のボタンとホイールの調整
; 右クリック ＋ チルト → 戻る/進むに割当
RButton & WheelLeft::!Left
RButton & WheelRight::!Right
; 右クリック ＋ 左の脇のボタン → F19/F20 にして、コピペと Win+V に割り付け。
F19::Send,^c
F20::Send,^v
RButton & F20::Send,#v

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


; ★ サイドのボタンの割当 候補 ① ： 右クリックは生かしたまま修飾キーとしても使用
; Send 以下の F13-24 の部分を適宜変更する。
F13::LCtrl ; G4 (手前下)
F14::MButton ; G5 (中列下)
;F15::Return ; G6 (奥下)
F16::LShift ; G7 (手前上)
F17::RButton ; G8 (中列上)
;F18::Return ; G9 (奥上)
; 右クリック押下時
RButton & F13::AltTab
;RButton & F14::Return
;RButton & F15::Return
RButton & F16::#Tab
;RButton & F17::Return
;RButton & F18::Return

; ★ 候補 ②
; RButton は GetKyeState(RButton, P) で物理的な押し下げ状態を判定する分岐の方が良いかも。
/*
F13::GetKeyState(Rbutton, "P") ? [] : Rbutton
*/


