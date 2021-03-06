;;;load-path を追加する関数を定義
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory
              (expand-file-name (concat user-emacs-directory path))))
        (add-to-list 'load-path default-directory)
        (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
            (normal-top-level-add-subdirs-to-load-path))))))

;; 引数のディレクトリとそのサブディレクトリをload-pathに追加
(add-to-load-path "elisp" "helm" "helm-descbinds" "elpa")

(require 'package)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)

(defun require-package (package &optional min-version no-refresh)
  "Install given PACKAGE, optionally requiring MIN-VERSION.
If NO-REFRESH is non-nil, the available package lists will not be
re-downloaded in order to locate PACKAGE."
  (if (package-installed-p package min-version)
    t
    (if (or (assoc package package-archive-contents) no-refresh)
      (if (boundp 'package-selected-packages)
        ;; Record this as a package the user installed explicitly
        (package-install package nil)
        (package-install package))
      (progn
        (package-refresh-contents)
        (require-package package min-version t)))))

(defun maybe-require-package (package &optional min-version no-refresh)
  "Try to install PACKAGE, and return non-nil if successful.
In the event of failure, return nil and print a warning message.
Optionally require MIN-VERSION.  If NO-REFRESH is non-nil, the
available package lists will not be re-downloaded in order to
locate PACKAGE."
  (condition-case err
    (require-package package min-version no-refresh)
    (error
      (message "Couldn't install optional package `%s': %S" package err)
      nil)))

(maybe-require-package 'helm-gtags)
(maybe-require-package 'auto-highlight-symbol)
(maybe-require-package 'jade-mode)
(maybe-require-package 'sws-mode)
(maybe-require-package 'magit)
(maybe-require-package 'multiple-cursors)
(maybe-require-package 'neotree)
(maybe-require-package 'ac-php)
(maybe-require-package 'mozc)
(maybe-require-package 'pcomplete)
(maybe-require-package 'sqlplus)
(maybe-require-package 'yasnippet)
(maybe-require-package 'sync-recentf)
(maybe-require-package 'dirtree)
(maybe-require-package 'recentf-ext)
(maybe-require-package 'ac-slime)
(maybe-require-package 'slime)
(maybe-require-package 'js2-mode)
(maybe-require-package 'cc-mode)
(maybe-require-package 'web-mode)
(maybe-require-package 'smartparens)
(maybe-require-package 'undo-tree)
(maybe-require-package 'wgrep)
(maybe-require-package 'migemo)
(maybe-require-package 'color-moccur)
;;(maybe-require-package 'auto-complete-config)
(maybe-require-package 'auto-complete)
(maybe-require-package 'helm-descbinds)
;;(maybe-require-package 'helm-config)
;;(maybe-require-package 'auto-install)
;;(maybe-require-package 'ucs-normalize)
(maybe-require-package 'powerline)
  
(require 'powerline)
(defconst color1 "SteelBlue")
(defconst color2 "OliveDrab2")
(set-face-attribute 'mode-line nil
                    :foreground "#fff"
                    :background color1
                    :bold t
                    :box nil)

(set-face-attribute 'powerline-active1 nil
                    :foreground "gray23"
                    :background color2
                    :bold t
                    :box nil
                    :inherit 'mode-line)

(set-face-attribute 'powerline-active2 nil
                    :foreground "white smoke"
                    :background "gray20"
                    :bold t
                    :box nil
                    :inherit 'mode-line)

(set-face-attribute 'mode-line-inactive nil
                    :foreground "#fff"
                    :background color1
                    :bold t
                    :box nil)

(set-face-attribute 'powerline-inactive1 nil
                    :foreground "gray23"
                    :background color2
                    :bold t
                    :box nil
                    :inherit 'mode-line)

(set-face-attribute 'powerline-inactive2 nil
                    :foreground "white smoke"
                    :background "gray20"
                    :bold t
                    :box nil
                    :inherit 'mode-line)

(powerline-center-theme)

;;Emacsからgtagsを使えるようにする
(require 'helm-gtags)
;;; Enable helm-gtags-mode
(add-hook 'c-mode-hook 'helm-gtags-mode)
(add-hook 'c++-mode-hook 'helm-gtags-mode)
(add-hook 'asm-mode-hook 'helm-gtags-mode)
(add-hook 'js2-mode-hook 'helm-gtags-mode)
;; customize
(custom-set-variables
 '(helm-gtags-path-style 'relative)
 '(helm-gtags-ignore-case t)
 '(helm-gtags-auto-update t))
;; key bindings
(eval-after-load "helm-gtags"
  '(progn
     (define-key helm-gtags-mode-map (kbd "M-t") 'helm-gtags-find-tag)
     (define-key helm-gtags-mode-map (kbd "M-r") 'helm-gtags-find-rtag)
     (define-key helm-gtags-mode-map (kbd "M-s") 'helm-gtags-find-symbol)
     (define-key helm-gtags-mode-map (kbd "C-c <") 'helm-gtags-previous-history)
     (define-key helm-gtags-mode-map (kbd "C-c >") 'helm-gtags-next-history)
     (define-key helm-gtags-mode-map (kbd "M-,") 'helm-gtags-pop-stack)))

;; ターミナル以外はツールバー、スクロールバーを非表示
(when window-system
  ;; tool-barを非表示
  (tool-bar-mode 0)
  ;; scroll-barを非表示
  (scroll-bar-mode 0))

;; CocoaEmacs以外はメニューバーを非表示
;;(unless (eq window-system 'ns)

;; menu-barを非表示
;;  (menu-bar-mode 0))

;; C-hをバックスペースにする
;; 入力されるキーシーケンスを置き換える
;; ?\C-?はDELのキーシケンス
(keyboard-translate ?\C-h ?\C-?)

;; C-mにnewline-and-indentを割り当てる。
;; 先ほどとは異なりglobal-set-keyを利用
(global-set-key (kbd "C-m") 'newline-and-indent)

;; 折り返しトグルコマンド
(define-key global-map (kbd "C-c l") 'toggle-truncate-lines)

;; "C-t" でウィンドウを切り替える。初期値はtranspose-chars
;;デフォルトはC-x o
(define-key global-map (kbd "C-t") 'other-window)

;; パスの設定
(add-to-list 'exec-path "/opt/local/bin")
(add-to-list 'exec-path "/usr/local/bin")
(add-to-list 'exec-path "~/bin")

;; 文字コードを指定する
(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)

;;  ファイル名の扱い
;; Mac OS Xの場合のファイル名の設定
(when (eq system-type 'darwin)
  (require 'ucs-normalize)
  (set-file-name-coding-system 'utf-8-hfs)
  (setq locale-coding-system 'utf-8-hfs))

;; Windowsの場合のファイル名の設定
(when (eq window-system 'w32)
  (set-file-name-coding-system 'utf-8);;cp932
  (setq locale-coding-system 'utf-8));;cp932

;; モードラインに関する設定
;; カラム番号も表示
(column-number-mode t)

;; ファイルサイズを表示
(size-indication-mode t)

;; リージョン内の行数と文字数をモードラインに表示する（範囲指定時のみ）
;; http://d.hatena.ne.jp/sonota88/20110224/1298557375
(defun count-lines-and-chars ()
  (if mark-active
      (format "%d lines,%d chars "
              (count-lines (region-beginning) (region-end))
              (- (region-end) (region-beginning)))
      ;; これだとエコーエリアがチラつく
      ;;(count-lines-region (region-beginning) (region-end))
    ""))
(add-to-list 'default-mode-line-format
             '(:eval (count-lines-and-chars)))

;; タイトルバーにファイルのフルパスを表示
(setq frame-title-format "%f")

;; 行番号を常に表示する
(global-linum-mode t)

;; タブ文字の表示幅
;; TABの表示幅。初期値は8
(setq-default tab-width 4)

;; インデントにタブ文字を使用しない
(setq-default indent-tabs-mode nil)

;; C、C++、JAVA、PHPなどのインデント
(add-hook 'c-mode-common-hook
          '(lambda ()
             (c-set-style "bsd")))

;; フェイス
;; リージョンの背景色を変更
(set-face-background 'region "darkgreen")

(load-theme 'misterioso t)

;; フォントの設定
;;mac
(when (eq window-system 'ns)
(set-face-attribute 'default nil
                    :family "Ricty Diminished"
                    :height 120)
(set-fontset-font (frame-parameter nil 'font)
                  'japanese-jisx0208
                  (cons "Ricty Diminished" "iso10646-1"))
(set-fontset-font (frame-parameter nil 'font)
                  'japanese-jisx0212
                  (cons "Ricty Diminished" "iso10646-1"))
(set-fontset-font (frame-parameter nil 'font)
                  'katakana-jisx0201
                  (cons "Ricty Diminished " "iso10646-1")))

;;windows
(when (eq system-type 'windows-nt)
  ;; asciiフォントをConsolasに
  (set-face-attribute 'default nil
                      :family "Consolas"
                      :height 110)
  ;; 日本語フォントをメイリオに
  (set-fontset-font
   nil
   'japanese-jisx0208
   (font-spec :family "メイリオ"))
  ;; フォントの横幅を調節する
  (setq face-font-rescale-alist
        '((".*Consolas.*" . 1.0)
          (".*メイリオ.*" . 1.15)
          ("-cdac$" . 1.3))))

;;linux
(when (eq window-system 'x)
(set-face-attribute 'default nil
                    :family "Ricty"
                    :height 100)
(set-fontset-font (frame-parameter nil 'font)
                  'japanese-jisx0208
                  (cons "Ricty" "iso10646-1"))
(set-fontset-font (frame-parameter nil 'font)
                  'japanese-jisx0212
                  (cons "Ricty" "iso10646-1"))
(set-fontset-font (frame-parameter nil 'font)
                  'katakana-jisx0201
                  (cons "Ricty" "iso10646-1")))

;; 現在行のハイライト
(defface my-hl-line-face
  ;; 背景がdarkならば背景色を紺に
  '((((class color) (background dark))
     (:background "NavyBlue" t))
    ;; 背景がlightならば背景色を緑に
    (((class color) (background light))
     (:background "LightGoldenrodYellow" t))
    (t (:bold t)))
  "hl-line's my face")
(setq hl-line-face 'my-hl-line-face)
(global-hl-line-mode t)

;; 括弧の対応関係のハイライト
;; paren-mode：対応する括弧を強調して表示する
(setq show-paren-delay 0) ; 表示までの秒数。初期値は0.125
(show-paren-mode t) ; 有効化

;; parenのスタイル: expressionは括弧内も強調表示
(setq show-paren-style 'expression)

;; フェイスを変更する
(set-face-background 'show-paren-match-face nil)
(set-face-underline 'show-paren-match-face "yellow")

;; ロックファイルを作成しない
(setq create-lockfiles nil)

;; バックアップとオートセーブの設定
;; バックアップファイルを作成しない
(setq make-backup-files nil) ; 初期値はta

;; オートセーブファイルを作らない
(setq auto-save-default nil) ; 初期値はt

;; バックアップファイルの作成場所をシステムのTempディレクトリに変更する
(setq backup-directory-alist
       `((".*" . ,temporary-file-directory)))

;; オートセーブファイルの作成場所をシステムのTempディレクトリに変更する
(setq auto-save-file-name-transforms
       `((".*" ,temporary-file-directory t)))

;; バックアップとオートセーブファイルを~/.emacs.d/backups/へ集める
;;(add-to-list 'backup-directory-alist
;;             (cons "." "~/.emacs.d/backups/"))
;;(setq auto-save-file-name-transforms
;;      `((".*" ,(expand-file-name "~/.emacs.d/backups/") t)))

;; オートセーブファイル作成までの秒間隔
;;(setq auto-save-timeout 15)

;; オートセーブファイル作成までのタイプ間隔
;;(setq auto-save-interval 60)

;; ファイルが #! から始まる場合、+xを付けて保存する
;;(add-hook 'after-save-hook
;;          'executable-make-buffer-file-executable-if-script-p)

;; emacs-lisp-mode-hook用の関数を定義
(defun elisp-mode-hooks ()
  "lisp-mode-hooks"
  (when (require 'eldoc nil t)
    (setq eldoc-idle-delay 0.2)
    (setq eldoc-echo-area-use-multiline-p t)
    (turn-on-eldoc-mode)))

;; emacs-lisp-modeのフックをセット
(add-hook 'emacs-lisp-mode-hook 'elisp-mode-hooks)

;; auto-installの設定
;;  (require 'auto-install)
;; インストールディレクトリを設定する 初期値は ~/.emacs.d/auto-install/		
;;(setq auto-install-directory "~/.emacs.d/elisp/")		
   ;; EmacsWikiに登録されているelisp の名前を取得する		
;;   (auto-install-update-emacswiki-package-name t)		
		
   ;; 必要であればプロキシの設定を行う		
   ;; (setq url-proxy-services '(("http" . "localhost:8339")))		
   ;; install-elisp の関数を利用 可能にする		
;;(auto-install-compatibility-setup)

;;helmをインストール(候補検索をして何らかのアクションを行う)
;;helmの設定
(require 'helm-config)
(helm-mode 1)
(global-set-key (kbd "M-x") 'helm-M-x)

(require 'helm-descbinds)
(helm-descbinds-mode)

;; Auto Completeの設定
;;http://keisanbutsuriya.hateblo.jp/entry/2015/02/08/175005より
(require 'auto-complete)
(require 'auto-complete-config)
(ac-config-default)
(add-to-list 'ac-modes 'text-mode)         ;; text-modeでも自動的に有効にする
(add-to-list 'ac-modes 'fundamental-mode)  ;; fundamental-mode
(add-to-list 'ac-modes 'org-mode)
(add-to-list 'ac-modes 'yatex-mode)
(add-to-list 'ac-modes 'web-mode)
(add-to-list 'ac-modes 'sql-mode)
(add-to-list 'ac-modes 'jade-mode)
(add-to-list 'ac-modes 'js2-mode)

(ac-set-trigger-key "TAB")
(setq ac-use-menu-map t)       ;; 補完メニュー表示時にC-n/C-pで補完候補選択
(setq ac-use-fuzzy t)          ;; 曖昧マッチ

;; 検索結果をリストアップする──color-moccur
;; color-moccurの設定
(when (require 'color-moccur nil t)
;; M-oにoccur-by-moccurを割り当て
(define-key global-map (kbd "M-o") 'occur-by-moccur)
;; スペース区切りでAND検索
(setq moccur-split-word t)
;; ディレクトリ検索のとき除外するファイル
(add-to-list 'dmoccur-exclusion-mask "\\.DS_Store")
(add-to-list 'dmoccur-exclusion-mask "^#.+#$")
;; Migemoを利用できる環境であればMigemoを使う
(when (and (executable-find "cmigemo")
     (require 'migemo nil t))
(setq moccur-use-migemo t)))

;; grepの結果を直接編集──wgrep
;; wgrepの設定
(require 'wgrep)

;; アンドゥの分岐履歴──undo-tree
;; undo-treeの設定
(require 'undo-tree)
(global-undo-tree-mode)

;;カッコやクウォートなどの対応関係を自動挿入・管理するパッケージ
(require 'smartparens)
;;すべてのモードで使用する(自動起動)
(smartparens-global-mode t)

;;閉じ括弧の自動挿入
(electric-pair-mode 1)

;;web-mode
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
;;(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

(require 'cc-mode)
;; c-mode-common-hook  C/C++ の設定
(add-hook 'c-mode-common-hook
          (lambda ()
            (setq c-default-style "k&r") ;; カーニハン・リッチースタイル
            (setq indent-tabs-mode nil)  ;; タブは利用しない
            (setq c-basic-offset 2)      ;; indent は 2 スペース
            ))
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

(require 'js2-mode)
(add-to-list 'auto-mode-alist '("\\.js\\'". js2-mode))

;;flycheck
(add-hook 'after-init-hook #'global-flycheck-mode)
(defalias 'perl-mode 'cperl-mode)
(setq auto-mode-alist (append '(("\\.psgi$" . cperl-mode)) auto-mode-alist))
(setq auto-mode-alist (append '(("\\.cgi$" . cperl-mode)) auto-mode-alist))
(setq auto-mode-alist (append '(("\\.pl$" . cperl-mode)) auto-mode-alist))
(setq auto-mode-alist (append '(("\\.pm$" . cperl-mode)) auto-mode-alist))
(setq auto-mode-alist (append '(("\\.t$" . cperl-mode)) auto-mode-alist))

(add-hook 'cperl-mode-hook
          '(lambda ()
             ;; インデント設定
             (cperl-set-style "PerlStyle")
             (custom-set-variables
              '(cperl-indent-parens-as-block t)
              '(cperl-close-paren-offset -4)
              '(cperl-indent-subs-specially nil))
             )
         )

;; 警告音もフラッシュも全て無効(警告音が完全に鳴らなくなるので注意)
(setq visible-bell t)
(setq ring-bell-function 'ignore)

;; slime
(when (require 'slime nil t)
(setq inferior-lisp-program "clisp")
(slime-setup '(slime-repl slime-fancy slime-banner))
(setq slime-net-coding-system 'utf-8-unix)

(require 'ac-slime)
(add-hook 'slime-mode-hook 'set-up-slime-ac)
(add-hook 'slime-repl-mode-hook 'set-up-slime-ac))

(put 'downcase-region 'disabled nil)

(require 'recentf-ext)

;; ディレクトリツリー
(require 'dirtree)
;;起動時の画面フルサイズ
(set-frame-parameter nil 'fullscreen 'maximized)

(require 'sync-recentf)
(setq recentf-auto-cleanup 60)
(recentf-mode 1)

;;上書きモードにする
(delete-selection-mode t)

;;yasnippet
(require 'yasnippet)
(yas-global-mode 1)

;;cua-modeの設定（矩形選択）ctrl+Enterで矩形選択モードに入る
(cua-mode t)
;CUAキーバインドを無効化
(setq cua-enable-cua-keys nil)


(eval-after-load "sql"
  '(load-library "sql-indent"))

(defun sql-mode-hooks()
  (setq sql-indent-offset 2)
  (setq indent-tabs-mode nil)
  ;;(sql-set-product "oracle")
  )

(add-hook 'sql-mode-hook 'sql-mode-hooks)


(require 'sqlplus)
(add-to-list 'auto-mode-alist '("\\.sqp\\'" . sqlplus-mode))

;;shellのPathを引き継ぐ
(when (eq window-system 'ns)
(exec-path-from-shell-initialize))
(when (eq window-system 'x)
  (exec-path-from-shell-initialize))

;;gtags用環境変数の設定
(setenv "GTAGSLABEL" "pygments")

;; eshell での補完に auto-complete.el を使う

(require 'pcomplete)
(add-to-list 'ac-modes 'eshell-mode)
(ac-define-source pcomplete
  '((candidates . pcomplete-completions)))
(defun my-ac-eshell-mode ()
  (setq ac-sources
        '(ac-source-pcomplete
          ac-source-filename
          ac-source-files-in-current-dir
          ac-source-words-in-buffer
          ac-source-dictionary)))
(add-hook 'eshell-mode-hook
          (lambda ()
            (my-ac-eshell-mode)
            (define-key eshell-mode-map (kbd "C-i") 'auto-complete)
            (define-key eshell-mode-map [(tab)] 'auto-complete)))

;;helm を使う部分
;;helm で履歴から入力
(add-hook 'eshell-mode-hook
          #'(lambda ()
              (define-key eshell-mode-map
                (kbd "C-p")
               'helm-eshell-history)))
;;helm で補完
(add-hook 'eshell-mode-hook
          #'(lambda ()
              (define-key eshell-mode-map
                (kbd "C-n")
                'helm-esh-pcomplete)))

;; load environment value
;;(load-file (expand-file-name "~/.emacs.d/shellenv.el"))
;;(dolist (path (reverse (split-string (getenv "PATH") ":")))
;;  (add-to-list 'exec-path path))

;;Debian の im-config で fcitx を有効にすると日本語入力に Mozc を利用できるようになるが、この Mozc を Emacs でも利用するためには .emacs でも設定する必要がある。
;;まずパッケージ emacs-mozc を入れること。
;;sudo apt-get install emacs-mozc

;; emacs-mozc のロード
(when (eq window-system 'x)
  (require 'mozc)

;; 日本語入力を japanese-mozc に
(setq default-input-method "japanese-mozc"))

;;Format HTML, CSS and JavaScript/JSON by js-beautify
(eval-after-load 'js2-mode
  '(define-key js2-mode-map (kbd "C-c b") 'web-beautify-js))
;; Or if you're using 'js-mode' (a.k.a 'javascript-mode')
(eval-after-load 'js
  '(define-key js-mode-map (kbd "C-c b") 'web-beautify-js))

(eval-after-load 'json-mode
  '(define-key json-mode-map (kbd "C-c b") 'web-beautify-js))

(eval-after-load 'sgml-mode
  '(define-key html-mode-map (kbd "C-c b") 'web-beautify-html))

(eval-after-load 'web-mode
  '(define-key web-mode-map (kbd "C-c b") 'web-beautify-html))

(eval-after-load 'css-mode
  '(define-key css-mode-map (kbd "C-c b") 'web-beautify-css))


(add-hook 'php-mode-hook '(lambda ()
                           (auto-complete-mode t)

                           (require 'ac-php)
                           (setq ac-sources  '(ac-source-php ) )
                           (yas-global-mode 1)

                           (define-key php-mode-map  (kbd "C-]") 'ac-php-find-symbol-at-point)   ;goto define
                           (define-key php-mode-map  (kbd "C-[") 'ac-php-location-stack-back   ) ;go back
                           ))

;;起動時に画面分割
(split-window-horizontally)
(other-window 1)
(split-window-vertically)

;; 直前のバッファに戻る
(global-set-key (kbd "M-[") 'switch-to-prev-buffer)

;; 次のバッファに進む
(global-set-key (kbd "M-]") 'switch-to-next-buffer)

;;F8でトグルする
(require 'neotree)
(global-set-key [f8] 'neotree-toggle)

(fringe-mode 0)

;;デフォルトブラウザをchromeにする(macだけかも、あとでlinuxとかwindowsのぶんも書く)
(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome")

;;マルチカーソル
;;行選択後<C-M-return>で選択行にカーソルを追加
;;C-> で次の行にカーソル追加
;;C-< で前の行にカーソル追加
;;単語選択後 C-c C-< で画面内のその単語全てにカーソルを追加
(require 'multiple-cursors)
(global-set-key (kbd "<C-M-return>") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

;;EmacsのGitクライアント
(require 'magit)

;;jade-modeの設定（コピペ）packageもいくつか入れた。いらないかも
(require 'sws-mode)
(require 'jade-mode)

(add-to-list 'auto-mode-alist '("\.jade$" . jade-mode))

(require 'auto-highlight-symbol)
(global-auto-highlight-symbol-mode t)

;;python関係の設定
(require 'python-mode)
(setq auto-mode-alist (cons '("\\.py\\'" . python-mode) auto-mode-alist))
;;補完
(require 'jedi)
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)

(setq ac-sources
  (delete 'ac-source-words-in-same-mode-buffers ac-sources)) ;;jediの補完候補だけでいい
  (add-to-list 'ac-sources 'ac-source-filename)
  (add-to-list 'ac-sources 'ac-source-jedi-direct)
  (define-key python-mode-map "\C-ct" 'jedi:goto-definition)
  (define-key python-mode-map "\C-cb" 'jedi:goto-definition-pop-marker)
  (define-key python-mode-map "\C-cr" 'helm-jedi-related-names)

;;終了状態を、再起動後に自動で復元
(desktop-save-mode 1)
