(constraint: linear-x (!shapes x0 xn dx)
 (for shape in shapes
  (assert: (= xn (+ x0 (* (- n 1) dx))))
  (assert: (= shape.x (+ x0 (* dx i))))))

(shape: bottom-cyl (height)
 (script:
  (cylinder #:diameter 6.5 #:height height)
  (cut: (cylinder #:diameter 4.8 #:height height))))

(shape: block (l w h clearance)
 (script:
  (cuboid #:length (- (* 8 l) clearance) #:width (- (* 8 w) clearance) #:height h)
  (cut: (cuboid #:length (- (- (* 8 l) clearance) 2.4) #:width (- (- (* 8 w) clearance) 2.4) #:height (- h 1.2) #:z -0.61))))

(shape: brick (!l)
 (script:
  (block #:l l #:w 2 #:h 9.6 #:clearance 0.2)
  (named: bot-cyls ((shape: () (script:
                     (for i in (range (- l 1))
                      (bottom-cyl #:height 8.4 #:z -0.6))))))
  (named: top-cyls-c1 ((shape: () (script:
                        (for i in (range l)
                         (cylinder #:diameter 4.8 #:height 1.8 #:y -4 #:z 5.7))))))
  (named: top-cyls-c2 ((shape: () (script:
                        (for i in (range l)
                         (cylinder #:diameter 4.8 #:height 1.8 #:y 4 #:z 5.7)))))))
 (constraints:
  (assert: (linear-x #:shapes bot-cyls #:x0    (- (* (- (/ l 2) 1) 8)) #:dx 8))
  (assert: (linear-x #:shapes top-cyls-c1 #:x0 (- (- (* (/ l 2) 8) 4)) #:dx 8))
  (assert: (linear-x #:shapes top-cyls-c2 #:x0 (- (- (* (/ l 2) 8) 4)) #:dx 8))))

(print: (brick #:l 4) "brick-4.stl")