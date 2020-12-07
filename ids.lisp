(defun shortest-path (start end net)
  (nreverse (ids (list (list start))
                 (lambda (state) 
                   (eql state end))
                 (lambda (path)
                   (mapcan (lambda (node)
                             (if (member node path) nil (list node)))
                           (cdr (assoc (car path) net)))))))

(defun ids (paths pred gen)
  (do* ((i 0 (1+ i))
        (res (dls (car paths) pred gen i)
             (dls (car paths) pred gen i)))
    ((listp res) res)))

(defun new-depth-p (path pred)
  (if (funcall pred (car path))
      path 
      'more-to-try))

(defun update-res (old new)
  (if (eql old 'more-to-try)
      (or new 'more-to-try)
      new))

(defun dls (path pred gen n)
  (if (<= n 0) 
      (new-depth-p path pred)
      (do ((state (funcall gen path) (cdr state))
           (res nil (update-res res (dls (cons (car state) path) pred gen (1- n)))))
          ((or (null state) (consp res))
           res))))

(test-path '() 'a 'c '((a b) (b a) (c)))
(shortest-path 'a 'f '((a b) (b c d) (c e) (d a) (e f)))
(test-path '(a b c e f) 'a 'f '((a b) (b c d) (c e) (d a) (e f)))
(shortest-path 'a 'c '((a b) (b a) (c)))
(test-path '(a c e f) 'a 'f '((a b c) (b c) (c e) (e f)))
(run-tests shortest-path)