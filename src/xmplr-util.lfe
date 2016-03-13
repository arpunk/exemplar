(defmodule xmplr-util
  (export all))

(include-lib "clj/include/predicates.lfe")

(defun get-exemplar-version ()
  (lutil:get-app-src-version "src/exemplar.app.src"))

(defun get-versions ()
  (++ (lutil:get-version)
      `(#(exemplar ,(get-exemplar-version)))))

(defun elements?
  (('())
    'false)
  ((elements)
    (lists:all #'element?/1 elements)))

(defun element?
  ((element) (when (not (is_list element)))
    'false)
  ((element) (when (=/= 3 (length element)))
    'false)
  ((element)
    (cond
      ((and (all-2-tuples? element) (has-element-names? element))
        'true)
      ('true
        'false))))

(defun has-element-names? (element)
  (=:= (proplists:get_keys element) '(attrs content tag)))

(defun attrs? (data)
  "a list of attr/value key pairs has to have an even number of elements. The
  first element also has to be an atom. In fact, all even-indexed (zero-based
  counting) elements have to be atoms.

  If these criteria are not met, the list is not an attr collection."
  (let* ((len (length data))
         (`#(,names ,values) (lutil-type:partition-list data))
         (evens-atoms? (== (length names) (length values))))
    (and (list? data) (and (> len 0) (and (even? len) evens-atoms?)))))

(defun all-2-tuples?
  (('())
    'false)
  ((xs)
    (lists:all #'2-tuple?/1 xs)))

(defun 2-tuple? (t)
  (andalso (is_tuple t) (is_atom (element 1 t)) (=:= 2 (size t))))

(defun attr->str
  ((name value) (when (is_atom name))
    (attr->str (atom_to_list name) value))
  ((name value)
    (++ name "=\"" value "\" ")))

(defun attrs->str (attrs)
  (let ((`#(,names ,values) (lutil-type:partition-list attrs)))
    (lists:concat
      (lists:zipwith #'attr->str/2 names values))))