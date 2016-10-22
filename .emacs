; ---- language-env DON'T MODIFY THIS LINE!
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 日本語表示の設定
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(when (featurep 'mule)
  ;; Mule-UCS-Unicode for emacsen 20.x and 21.x
  (when (and (>= emacs-major-version 20)
             (<= emacs-major-version 21))
    (if (fboundp 'un-define-debian)
        (un-define-debian)
      (if (locate-library "un-define")
          (require 'un-define))))
  (let ((case-fold-search t)
        locale vars cs)
    (setq vars '("LC_ALL" "LC_CTYPE" "LANG"))
    (while (and vars (not (setq locale (getenv (car vars)))))
      (setq vars (cdr vars)))
    (or locale (setq locale "C"))
    (when (string-match "^ja" locale)
      ;; prefer japanese-jisx0208 characters
      (when (and (featurep 'un-define)
                 (not (featurep 'xemacs))) ;; for Emacs 20.x and 21.x
        (require 'un-supple)
        (un-supple-enable 'jisx0221)
        (un-supple-enable 'windows))
      (when (fboundp 'utf-translate-cjk-set-unicode-range) ;; for Emacs 22.x
        (utf-translate-cjk-set-unicode-range
         '((#x00a2 . #x00a3) (#x00a7 . #x00a8) (#x00ac . #x00ac)
           (#x00b0 . #x00b1) (#x00b4 . #x00b4) (#x00b6 . #x00b6)
           (#x00d7 . #x00d7) (#x00f7 . #x00f7) (#x0370 . #x03ff)
           (#x0400 . #x04ff) (#x2000 . #x206f) (#x2100 . #x214f)
           (#x2103 . #x2103) (#x212b . #x212b) (#x2190 . #x21ff)
           (#x2200 . #x22ff) (#x2300 . #x23ff) (#x2500 . #x257f)
           (#x25a0 . #x25ff) (#x2600 . #x26ff) (#x2e80 . #xd7a3)
           (#xff00 . #xffef))))
      (set-language-environment "Japanese")
      (prefer-coding-system 'utf-8)
      (prefer-coding-system 'euc-jp))
    (cond
     ((string-match "UTF-?8" locale)
      (setq cs 'utf-8))
     ((string-match "EUC-?JP" locale)
      (setq cs 'euc-jp))
     ((string-match "SJIS\\|Shift_?JIS" locale)
      (setq cs 'shift_jis)))
    (when cs
      (prefer-coding-system cs)
      (set-keyboard-coding-system cs)
      (set-terminal-coding-system cs))))

; 日本語 info が文字化けしないように
(auto-compression-mode t)
; xemacs の shell-mode で 日本語 EUC が使えるようにする
(if (featurep 'xemacs)
    (add-hook 'shell-mode-hook (function
       (lambda () (set-buffer-process-coding-system 'euc-japan 'euc-japan))))
)
; 日本語 grep
(if (file-exists-p "/usr/bin/lgrep")
    (setq grep-command "lgrep -n ")
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 漢字変換 (Anthy) の設定
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(set-input-method "japanese-anthy")
(toggle-input-method nil)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Xでのカラー表示
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'font-lock)
(if (not (featurep 'xemacs))
    (global-font-lock-mode t)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; C プログラムの書式
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(defun my-c-mode-common-hook ()
;   (c-set-style "linux") (setq indent-tabs-mode t) ;linux 式がいいとき
;      /usr/src/linux/Documentation/CodingStyle 参照
;   (c-set-style "k&r") ;k&r式がいいときはこれを有効にする
;   (c-set-style "gnu") ;デフォルトの設定
; )
;(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; いろいろ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Deleteキーでカーソル位置の文字が消えるようにする
(global-set-key [delete] 'delete-char)
;; C-h キーでカーソルの左の文字が消えるようにする。
;; ただし、もともと C-h はヘルプなので、
;; これを有効にすると、ヘルプを使うときには
;; M-x help や F1 を使う必要があります。
;(global-set-key "\C-h" 'backward-delete-char)

; ---- language-env end DON'T MODIFY THIS LINE!
