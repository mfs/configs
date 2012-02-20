;;;; [cmgr] .emacs

(defun execute-current-buffer ()
  "Execute current buffer asynchronously and capture output in *scratch*."
  (interactive)
  (let ((filename buffer-file-name))
    (switch-to-buffer "*scratch*")
    (start-process filename "*scratch*" filename)))


(global-set-key [f2] 'execute-current-buffer)

