; 引用元 https://gist.github.com/toriwasa/64fc9e1a8cce620b8ff92f0ae38075f7#file-autohotkey-ahk-L235

/*
変換を修飾キーとして扱うための準備
変換を押し続けている限りリピートせず待機
変換 vk1C, 無変換 vk1D
*/

$vk1C::
    startTime := A_TickCount ; A_TickCount = OS が起動してからの時間
    KeyWait, vk1C ; KeyWait = 後の引数を指定しなければ、Key Up まで待機する。
    keyPressDuration := A_TickCount - startTime ; キーを押している時間を測定
    If (A_ThisHotkey == "$vk1C" and keyPressDuration < 200) {
        Send,{vk1C}
    }
    Return
    ; A_ThisHotkey = 直前に実行されたホットキーのラベル名が格納される組み込み変数
        ; 変換を押している間に他のホットキーが発動した場合は入力しない
    ; keyPressDuration < 200 → 変換を長押ししていた場合も入力しない (秒数については titration 必要)

/*
------------------------------------------------------------------------------
   第１弾 カーソル移動
       マウスを使わない場合真っ先に面倒になるのが移動、選択系の操作
       通常位置のカーソルキーを使っていると手の移動がとても多くなってしまう
       ホームポジションからカーソルキーが使えるとマウスよりも便利になる
------------------------------------------------------------------------------
*/

; Vimエディタ派生だけど他のアプリでもよく使われてるので慣れると流用しやすい
~vk1C & H::Send,{Blind}{Left}    ; 変換 + H = 左カーソルキー
~vk1C & J::Send,{Blind}{Down}    ; 変換 + J = 下カーソルキー
~vk1C & K::Send,{Blind}{Up}      ; 変換 + K = 上カーソルキー
~vk1C & L::Send,{Blind}{Right}   ; 変換 + L = 右カーソルキー


; カーソルを一気に端に移動させられるようにしておく
; また、Excelのシート移動も可能にしておく
; 覚えやすさのため、左右のカーソルキー(H, L)の近くに置く
; 筆者のキーボード配列用
~vk1D & Y::Send,{Blind}{Home}    ; 無変換 + Y = Home
~vk1D & \::Send,{Blind}{End}     ; 無変換 + \ = End
~vk1C & Y::Send,{Blind}{PgUp}    ; 変換 + Y = Page Up
~vk1C & \::Send,{Blind}{PgDn}    ; 変換 + \ = Page Down

/*
-----------------------------------------------------------------------------
   第２弾 マウスカーソル
       カーソルキーを使った移動、選択に慣れて来ると、画面をクリックしたり邪魔なマウスカーソルをどかすといった
       ちょっとしたマウスの操作が面倒に感じるようになってくる
       そこまで細かい操作を連続で必要としない場合、ホームポジションからマウス操作を代替できるようにする
------------------------------------------------------------------------------
*/

; 変換 + WASD = マウスカーソル上, 左, 下, 右
; そのままだと細かい操作には向くが大きな移動には遅すぎる
; カーソル操作中にCtrlキーを一瞬押すといい感じにブーストできる
; CtrlとShiftでの加速減速はWindowsのマウスキー機能を踏襲
; 精密操作がしたい時は 変換+Shift+WASD でカーソルをゆっくり動かせる
~vk1C & W::
~vk1C & A::
~vk1C & S::
~vk1C & D::
    While (GetKeyState("vk1C", "P"))                 ; 変換キーが押され続けている間マウス移動の処理をループさせる
    {
        MoveX := 0, MoveY := 0
        MoveY += GetKeyState("W", "P") ? -11 : 0     ; 変換キーと一緒にIJKLが押されている間はカーソル座標を変化させ続ける
        MoveX += GetKeyState("A", "P") ? -11 : 0
        MoveY += GetKeyState("S", "P") ? 11 : 0
        MoveX += GetKeyState("D", "P") ? 11 : 0
        MoveX *= GetKeyState("Ctrl", "P") ? 10 : 1   ; Ctrlキーが押されている間は座標を10倍にし続ける(スピードアップ)
        MoveY *= GetKeyState("Ctrl", "P") ? 10 : 1
        MoveX *= GetKeyState("Shift", "P") ? 0.3 : 1 ; Shiftキーが押されている間は座標を30%にする（スピードダウン）
        MoveY *= GetKeyState("Shift", "P") ? 0.3 : 1
        MouseMove, %MoveX%, %MoveY%, 1, R            ; マウスカーソルを移動する
        Sleep, 0                                     ; 負荷が高い場合は設定を変更 設定できる値は-1、0、10～m秒 詳細はSleep
    }
    Return

; 以下は筆者のキーボード配列向け
; 変換 + Del =  左クリック（押し続けるとドラッグ）
~vk1C & BS::MouseClick,left,,,,,D
~vk1C & BS Up::MouseClick,left,,,,,U

; 以下は日本語キーボード・英語キーボード向け
; 変換 + Enter = 左クリック（押し続けるとドラッグ）
; ~vk1C & Enter::MouseClick,left,,,,,D
; ~vk1C & Enter Up::MouseClick,left,,,,,U

; 変換 + E = 右クリック
~vk1C & E::MouseClick,right

; カーソルキーでファイルを選択した場合の右クリックメニュー表示
; Windows10のエクスプローラーの場合メニュー表示後ショートカットキーで項目を選択できる
~vk1D & F::Send,{Blind}{AppsKey}    ;無変換 + F = アプリケーションキー