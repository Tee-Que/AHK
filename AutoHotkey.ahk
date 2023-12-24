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
● 別のスクリプトファイルの読み込み
------------------------------------------------------------------------------
*/
#Include *i %A_ScriptDir%/G604.ahk
#Include *i %A_ScriptDir%/G600.ahk

/*
------------------------------------------------------------------------------
● AHK の調整ショートカットとして、こんな感じのスクリプトを仕込んでおいた方が楽かも。
------------------------------------------------------------------------------
*/
^!R::Reload  ; Ctrl + Alt + R でスクリプトを再読み込み.
^!E::Edit  ; Ctrl + Alt + E でスクリプトを編集.

; ★ キーボード用

/*
------------------------------------------------------------------------------
変換/無変換を修飾キーとして扱うための準備
変換/無変換を押し続けている限りリピートせず待機
※ スキャンコード：無変換 sc07B [vk1D], 変換 sc079 [vk1C]
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
   ⓪ 文字入力時の変換や削除の簡略化
        文字入力中の変換  で出来るようにしてみる。
        Delte, BackSpace を、変換 + α で代用してみる。
------------------------------------------------------------------------------
*/
~sc07B & I::Send,^i ; Ctrl+T → 無変換 sc07B
~sc079 & T::Send,^t ; Ctrl+I → 変換 sc079

/*
~sc079 & sc027::Send,{Blind}{BS}
~sc079 & sc028::Send,{Blind}{Delete}
*/
; ↓ カーソル移動を IJKL に変えた流れで、BackSpace を P、Detele を ; (sc027) → : (sc028) に変更
~sc079 & P::Send,{Blind}{BS}
~sc079 & sc028::Send,{Blind}{Delete}

~sc079 & H::Send,{Blind}{BS}
~sc079 & G::Send,{Blind}{Delete}

/*
------------------------------------------------------------------------------
   ① Keyboard de cursor 移動
       マウスを使わない場合真っ先に面倒になるのが移動、選択系の操作
       通常位置のカーソルキーを使っていると手の移動がとても多くなってしまう
       ホームポジションからカーソルキーが使えるとマウスよりも便利になる
------------------------------------------------------------------------------
*/

/*
; Vim エディタ風のカーソル移動 (変換キー)
~sc079 & H::Send,{Blind}{Left}    ; 変換 + H = 左カーソルキー
~sc079 & J::Send,{Blind}{Down}    ; 変換 + J = 下カーソルキー
~sc079 & K::Send,{Blind}{Up}      ; 変換 + K = 上カーソルキー
~sc079 & L::Send,{Blind}{Right}   ; 変換 + L = 右カーソルキー
*/

/*
; Home/End, Page Up/Down も割り当てた (無変換キー)
~sc07B & H::Send,{Blind}{Home}    ; 無変換 + H = Home
~sc07B & J::Send,{Blind}{PgUp}    ; 無変換 + J = Page Up
~sc07B & K::Send,{Blind}{PgDn}    ; 無変換 + K = Page Down
~sc07B & L::Send,{Blind}{End}     ; 無変換 + L = End
*/
;   ↓ Home/End, Page Up/Down。無変換に割り当てると typo でいちいち半角入力になるので、変換キー + 下段のキーにした例。
/*
~sc079 & N::Send,{Blind}{Home}    ; 変換 + N = Home
~sc079 & M::Send,{Blind}{PgUp}    ; 変換 + M = Page Up
~sc079 & ,::Send,{Blind}{PgDn}    ; 変換 + , = Page Down
~sc079 & .::Send,{Blind}{End}     ; 変換 + . = End
*/
;  ↓ 上段のキーに設定変更 (Home/End, Page Up/Down)
/*
~sc079 & Y::Send,{Blind}{Home}    ; 変換 + Y = Home
~sc079 & U::Send,{Blind}{PgUp}    ; 変換 + U = Page Up
~sc079 & I::Send,{Blind}{PgDn}    ; 変換 + I = Page Down
~sc079 & O::Send,{Blind}{End}     ; 変換 + O = End
*/

;   ↓ 矢印キー割当を、HJKL → IJKL (WASD 的な感じに変更)
;   ↓ Home/End, PgUp/Dn も周りに配置し直し
~sc079 & I::Send,{Blind}{Up}      ; 変換 + I = 上カーソルキー
~sc079 & J::Send,{Blind}{Left}    ; 変換 + J = 左カーソルキー
~sc079 & K::Send,{Blind}{Down}    ; 変換 + K = 下カーソルキー
~sc079 & L::Send,{Blind}{Right}   ; 変換 + L = 右カーソルキー

~sc079 & U::Send,{Blind}{Home}    ; 変換 + U = Home
~sc079 & M::Send,{Blind}{End}     ; 変換 + M = End
~sc079 & O::Send,{Blind}{PgUp}    ; 変換 + O = Page Up
~sc079 & .::Send,{Blind}{PgDn}    ; 変換 + . = Page Down

; BackSpace, Delte を張り直し (⓪ 文字入力時の変換や削除の簡略化 の所に追記)
; 余った下中央の "," にコンテクストメニュー。キーボードの App. Key (キーカーソル位置に出る)
    ; AppsKey sc15D コンテキストメニューの表示 (ネイティブの割当で Shift + F10 もあるらしい)
; 右下の "/" が余るので Esc 割り振っておく
~sc079 & ,::Send,{Blind}{AppsKey}
~sc079 & /::Send,{Blind}{Esc}


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
; 無変換 + WASD = マウスカーソル上, 左, 下, 右
; そのままだと細かい操作には向くが大きな移動には遅すぎる
; カーソル操作中に Shift キーを一瞬押すといい感じにブースト移動
; CtrlとShiftでの加速減速はWindowsのマウスキー機能を踏襲
; 精密操作がしたい時は、無変換+Ctrl+WASD でカーソルを細かく動かせる。
;   ↓   割当を WASD から ESDF に変更
;   ↓   クリックを左側の QAZ に配置
*/


~sc07B & E::
~sc07B & S::
~sc07B & D::
~sc07B & F::
    While (GetKeyState("sc07B", "P"))                 ; 無変換キーが押され続けている間マウス移動の処理をループさせる
    {
        MoveX := 0, MoveY := 0                       ; MouseMove で相対座標で動かすために、変数 MoveX MoveY を用意する。
        MoveY += GetKeyState("E", "P") ? -11 : 0     ; GetKeyState() と ?:演算子(条件) (三項演算子) の組み合わせ
        MoveX += GetKeyState("S", "P") ? -11 : 0
        MoveY += GetKeyState("D", "P") ? 11 : 0
        MoveX += GetKeyState("F", "P") ? 11 : 0
        MoveX *= GetKeyState("Ctrl", "P") ? 5 : 1   ; Ctrlキーが押されている間は座標を10倍にし続ける(スピードアップ)
        MoveY *= GetKeyState("Ctrl", "P") ? 5 : 1
        MoveX *= GetKeyState("Shift", "P") ? 0.3 : 1 ; Shiftキーが押されている間は座標を30%にする（スピードダウン）
        MoveY *= GetKeyState("Shift", "P") ? 0.3 : 1
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

; 無変換 を押している間は、QAZ を中左右クリックとして扱う。
; (無変換を押しながら左手のみでマウス操作を可能にした。)
~sc07B & Q::MouseClick,middle,,,,,D
~sc07B & Q Up::MouseClick,middle,,,,,U
~sc07B & A::MouseClick,left,,,,,D
~sc07B & A Up::MouseClick,left,,,,,U
~sc07B & Z::MouseClick,right,,,,,D
~sc07B & Z Up::MouseClick,right,,,,,U

~sc07B & R::MouseClick,WheelUp,,,,,D
~sc07B & R Up::MouseClick,WheelUp,,,,,U
~sc07B & V::MouseClick,WheelDown,,,,,D
~sc07B & V Up::MouseClick,WheelDown,,,,,U
