#Persistent
#SingleInstance, Force ; 実行中のスクリプトがもうひとつ起動されたとき、自動的に既存のプロセスを終了して新たに実行開始する
#NoEnv
#UseHook ; 無限ループを避けるための記載 (割当で出力されたキーを更にスクリプト上で検索するのを避ける。)
#InstallKeybdHook ; キー押下状態を常に監視。修飾キーが押しっぱなし防止（その代わり、ホットキーをすり抜けてしまうことがある）
#InstallMouseHook
#HotkeyInterval, 2000
#MaxHotkeysPerInterval, 200
Process, Priority,, Realtime
SendMode, Input ; スクリプトの作業ディレクトリを実行スクリプトが置いてあるディレクトリにする。作業ディレクトリは、相対パスを指定したときに基準となるディレクトリである。基本はプログラムが実行された場所が作業ディレクトリになる
SetWorkingDir %A_ScriptDir%
SetTitleMatchMode, 2

Return

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
● AHK の調整ショートカットとして、こんな感じのスクリプトを仕込んでおいた方が楽かも。
------------------------------------------------------------------------------
*/
; Ctrl + Alt + R でスクリプトを再読み込み.
; Ctrl + Alt + E でスクリプトを編集.
^!R::Reload
^!E::Edit

; ★ キーボード用

/*
------------------------------------------------------------------------------
変換/無変換を修飾キーとして扱うための準備
変換/無変換を押し続けている限りリピートせず待機
※ スキャンコード：変換 sc079 [vk1C], 無変換 sc07B [vk1D]
------------------------------------------------------------------------------
*/

$sc079::
    startTime := A_TickCount ; A_TickCount = OS が起動してからの時間
    KeyWait, sc079 ; KeyWait = 後の引数を指定しなければ、Key Up まで待機する。
    keyPressDuration := A_TickCount - startTime ; キーを押している時間を測定
    If (A_ThisHotkey == "$sc079" and keyPressDuration < 200) {
        Send,{sc079}
    }
    Return
    ; A_ThisHotkey = 直前に実行されたホットキーのラベル名が格納される組み込み変数
        ; 変換を押している間に他のホットキーが発動した場合は入力しない
    ; keyPressDuration < 200 → 変換を長押ししていた場合も入力しない (秒数については titration 必要)
Return

$sc07B::
    startTime := A_TickCount ; A_TickCount = OS が起動してからの時間
    KeyWait, sc07B ; KeyWait = 後の引数を指定しなければ、Key Up まで待機する。
    keyPressDuration := A_TickCount - startTime ; キーを押している時間を測定
    If (A_ThisHotkey == "$sc07B" and keyPressDuration < 200) {
        Send,{sc07B}
    }
    Return
Return

/*
------------------------------------------------------------------------------
   ① Keyboard de cursor 移動
       マウスを使わない場合真っ先に面倒になるのが移動、選択系の操作
       通常位置のカーソルキーを使っていると手の移動がとても多くなってしまう
       ホームポジションからカーソルキーが使えるとマウスよりも便利になる
------------------------------------------------------------------------------
*/

; Vim エディタ風のカーソル移動 (変換キー)
~sc079 & H::Send,{Blind}{Left}    ; 変換 + H = 左カーソルキー
~sc079 & J::Send,{Blind}{Down}    ; 変換 + J = 下カーソルキー
~sc079 & K::Send,{Blind}{Up}      ; 変換 + K = 上カーソルキー
~sc079 & L::Send,{Blind}{Right}   ; 変換 + L = 右カーソルキー

/*
; Home/End, Page Up/Down も割り当てた (無変換キー)
~sc07B & H::Send,{Blind}{Home}    ; 無変換 + H = Home
~sc07B & J::Send,{Blind}{PgUp}    ; 無変換 + J = Page Up
~sc07B & K::Send,{Blind}{PgDn}    ; 無変換 + K = Page Down
~sc07B & L::Send,{Blind}{End}     ; 無変換 + L = End
*/

; Home/End, Page Up/Down。無変換に割り当てると typo でいちいち半角入力になるので、変換キー + 下段のキーにした例。
~sc079 & N::Send,{Blind}{Home}    ; 変換 + N = Home
~sc079 & M::Send,{Blind}{PgUp}    ; 変換 + M = Page Up
~sc079 & ,::Send,{Blind}{PgDn}    ; 変換 + , = Page Down
~sc079 & .::Send,{Blind}{End}     ; 変換 + . = End

/*
; 候補 ①： CapsLock sc03A は不安定らしい
; Send なので、Shift を押しながらカーソルを移動して文字列選択みたいのは無理そう。(下記)
sc03A & h::send, {Blind}{Left}
sc03A & J::send, {Blind}{Down}
sc03A & k::send, {Blind}{Up}
sc03A & l::send, {Blind}{Right}

; Ctrl+Shift で ^+h::^+h とかを別途指定すれば代替できるよう
; [ Alt でカーソル移動、Alt+Shift でカーソル選択を可能にしたもの ]
; ! は Alt
!h::Send {Left}
!j::Send {Down}
!k::Send {Up}
!l::Send {Right}
; + はShift
!+h::Send +{Left}
!+j::Send +{Down}
!+k::Send +{Up}
!+l::Send +{Right}
; 上部メニューがアクティブになるのを抑制
*~LAlt::Send {Blind}{vk07}
*~RAlt::Send {Blind}{vk07}
*/

; CapsLock の有効利用 (CapsLock は動作が不安定なよう)


/*
-----------------------------------------------------------------------------
    ② Keyboard de Mouse Cursor 移動
       ちょっとしたマウスの操作が必要な場合に、
       無変換を押しながらマウスカーソルを移動できるようにしたもの。
------------------------------------------------------------------------------
; 変換 + WASD = マウスカーソル上, 左, 下, 右
; そのままだと細かい操作には向くが大きな移動には遅すぎる
; カーソル操作中に Shift キーを一瞬押すといい感じにブースト移動
; CtrlとShiftでの加速減速はWindowsのマウスキー機能を踏襲
; 精密操作がしたい時は、無変換+Ctrl+WASD でカーソルを細かく動かせる。
*/
~sc07B & W::
~sc07B & A::
~sc07B & S::
~sc07B & D::
    While (GetKeyState("sc07B", "P"))                 ; 無変換キーが押され続けている間マウス移動の処理をループさせる
    {
        MoveX := 0, MoveY := 0                       ; MouseMove で相対座標で動かすために、変数 MoveX MoveY を用意する。
        MoveY += GetKeyState("W", "P") ? -11 : 0     ; GetKeyState() と ?:演算子(条件) (三項演算子) の組み合わせ
        MoveX += GetKeyState("A", "P") ? -11 : 0
        MoveY += GetKeyState("S", "P") ? 11 : 0
        MoveX += GetKeyState("D", "P") ? 11 : 0
        MoveX *= GetKeyState("Shift", "P") ? 5 : 1   ; Ctrlキーが押されている間は座標を10倍にし続ける(スピードアップ)
        MoveY *= GetKeyState("Shift", "P") ? 5 : 1
        MoveX *= GetKeyState("Ctrl", "P") ? 0.3 : 1 ; Shiftキーが押されている間は座標を30%にする（スピードダウン）
        MoveY *= GetKeyState("Ctrl", "P") ? 0.3 : 1
        MouseMove, %MoveX%, %MoveY%, 1, R            ; マウスカーソルを移動。MouseMove, X, Y [, Speed, R]。R は現在のカーソル位置からの相対座標になる。
        Sleep, 10                                     ; 負荷が高い場合は設定を変更 設定できる値は-1、0、10～m秒 詳細はSleep
    }
    Return
Return

; 無変換 を押している間は、JK を左右クリックとして扱う。
; (無変換を押しながら左右の手でマウスを完全エミュレート出来る状態に。)
~sc07B & J::MouseClick,left,,,,,D
~sc07B & J Up::MouseClick,left,,,,,U
~sc07B & K::MouseClick,right,,,,,D
~sc07B & K Up::MouseClick,right,,,,,U

/*
------------------------------------------------------------------------------
    G Hub のオンボードメモリからの変換 (G604)
; G600 については、vk07 とか無害なキーを割当可能なら、薬指ボタンに vk07 を充てた方が良いかも。
    ※ 現在 vk07 は windows 標準のキャプチャ機能に割当られているっぽい。
------------------------------------------------------------------------------
*/
; ★ トップ部分のボタンの調整
; 右クリック ＋ チルト → 戻る/進むに割当
RButton & WheelLeft::!Left
RButton & WheelRight::!Right
; 右クリック ＋ 左クリックの脇のボタン → F19/F20 にして、コピペと Win+V に割り付け。
F19::Send,^c
F20::Send,^v
RButton & F20::Send,#v


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