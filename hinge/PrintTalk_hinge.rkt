(shape: leaf (w t h knuckle-dia screw-dia)
 (script:
  (cuboid #:length w #:width t #:height h)
  (cut: (cylinder #:diameter screw-dia #:height t #:z (/ h 4) #:rot-x 90))
  (cut: (cylinder #:diameter screw-dia #:height t #:z (/ h -4) #:rot-x 90))
  (cuboid #:length (/ knuckle-dia 2) #:width t #:height (/ h 2) #:x (+ (/ w 2) (/ knuckle-dia 4)) #:z (/ h -4))
  (cylinder #:diameter knuckle-dia #:height (/ h 2) #:x (+ (/ w 2) (/ knuckle-dia 2)) #:z (/ h -4)))
 (constraints:
  (assert: (>= screw-dia (/ w 8)))
  (assert: (< screw-dia w))
  (assert: (< screw-dia (/ h 2)))
  (assert: (>= knuckle-dia t))))

(shape: hinge (w t h screw-dia pin-dia knuckle-dia pin-rim)
 (script:
  ;; Leaf with pin
  (named: leaf1 (leaf #:w w #:t t #:h h #:knuckle-dia knuckle-dia #:screw-dia screw-dia))
  (named: pin (cylinder #:diameter (- pin-dia 1) #:height (/ h 2) #:x (+ (/ w 2) (/ knuckle-dia 2)) #:z (/ h 4)))
  ;; Leaf with hole
  (named: leaf2 (leaf #:w w #:t t #:h h #:knuckle-dia knuckle-dia #:screw-dia screw-dia #:y (* knuckle-dia 2)))
  (cut: (named: pin-hole (cylinder #:diameter pin-dia #:height (/ h 2) #:x (+ (/ w 2) (/ knuckle-dia 2)) #:y (* knuckle-dia 2) #:z (/ h -4)))))
 (constraints:
  (assert: (>= pin-dia (* 0.8 knuckle-dia)))
  (assert: (< pin-dia knuckle-dia))
  (assert: (= pin-rim (/ (- knuckle-dia pin-dia) 2)))
  (assert: (>= pin-rim (/ pin-dia 8)))))

(print: (hinge #:w 25 #:t 4 #:h 50 #:screw-dia 10) "hinge.stl")