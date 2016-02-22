;;;; [cmgr] .emacs

;(setq debug-on-error t)

(setq backup-inhibited t)
(setq auto-save-default nil)

(global-linum-mode 1)
(setq linum-format "%4d ")

(defun pydoc (term)
  "Show pydoc documentation."
  (interactive "spydoc: ")
  (get-buffer-create "*pydoc*")
  (switch-to-buffer "*pydoc*")
  (erase-buffer)
  (call-process "pydoc" nil "*pydoc*" nil term)
  (beginning-of-buffer))

(defun execute-current-buffer ()
  "Execute current buffer asynchronously and capture output in *scratch*."
  (interactive)
  (let ((filename buffer-file-name))
    (switch-to-buffer "*scratch*")
    (start-process filename "*scratch*" filename)))

(defun insert-shebang (lang)
  "Insert shebang line and make file executable. Error checking could be better."
  (interactive "sInterpreter:")
  (let ((m (point-marker)))
    (goto-char (point-min))
    (insert (format "#!/usr/env %s\n\n" lang))
    (goto-char m)
    (set-marker m nil))
  (set-file-modes buffer-file-name ?\755))

(global-set-key [f2] 'execute-current-buffer)

; need to look into per mode key commands.
(global-set-key [f3] 'pydoc)