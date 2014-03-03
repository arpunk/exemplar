(defmacro defelem arg
  (let ((tag (car arg)))
    `(progn
      (defun ,tag (content)
        (: exemplar-xml xml (atom_to_list ',tag) content))
      (defun ,tag (attrs content)
        (: exemplar-xml xml (atom_to_list ',tag) attrs content)))))
