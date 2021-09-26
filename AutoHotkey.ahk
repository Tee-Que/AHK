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
● AHK の調整ショートカットとして、こんな感じのスクリプトを仕込んでおいた方が楽かも。
    ; Ctrl + Alt + R でスクリプトを再読み込み.
	; Ctrl + Alt + E でスクリプトを編集.
	^!R::Reload
    ^!E::Edit
------------------------------------------------------------------------------
*/


; ★ キーボード用

/*
------------------------------------------------------------------------------
変換を修飾キーとして扱うための準備
変換を押し続けている限りリピートせず待機
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
------------------------------------------------------------------------------
    G Hub のオンボードメモリからの変換 (G604)
------------------------------------------------------------------------------
*/
; ★ 候補 ①
; G600 については、vk07 とか無害なキーを割当可能なら、薬指ボタンに vk07 を充てた方が良いかも。
/*
F13::Send, ; G4 (手前下)
F14::Send, ; G5
F15::Send, ; G6 (奥下)
F16::Send, ; G7 (手前上)
F17::Send, ; G8
F18::Send, ; G9 (奥上)
~RButton & F13::Send, 
~RButton & F14::Send, 
~RButton & F15::Send, 
~RButton & F16::Send, 
~RButton & F17::Send, 
~RButton & F18::Send, 
*/

; ★ 候補 ②
; RButton は GetKyeState(RButton, P) で物理的な押し下げ状態を判定する分岐の方が良いかも。
/*

*/