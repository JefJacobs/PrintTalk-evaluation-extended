(shape: cap (dia height)
 (script:
  (cylinder #:diameter dia #:height height)
  (cut: (named: cutouts ((shape: ()
                          (script:
                           (for _ in (range 10)
                            (cylinder #:diameter (/ dia 4) #:height height))))))))
 (constraints:
  (assert: (circular #:shapes cutouts #:radius (* dia 0.55)))))

(shape: hinge-point (outer-dia inner-dia inner-length)
 (script:
  (cap #:dia outer-dia #:height 5 #:rot-y 90 #:x (- (/ inner-length -2) 2.5))
  (cylinder #:diameter inner-dia #:height inner-length #:rot-y 90)
  (cap #:dia outer-dia #:height 5 #:rot-y 90 #:x (+ (/ inner-length 2) 2.5))))
  
(shape: lamp-shade
 (l-dia u-dia h atch-l atch-w atch-th screw-dia screw-x screw-y screw-z)
 (script:
  (cone #:lower-diameter l-dia #:upper-diameter u-dia #:height h)
  (cuboid #:height atch-w #:width atch-l #:length atch-th #:y (/ atch-l 2))
  (cylinder #:diameter atch-w #:height atch-th
            #:y atch-l #:rot-y 90)
  (cut: (cylinder #:diameter screw-dia #:height atch-th
                  #:y atch-l #:rot-y 90))
  (cut: (cone #:lower-diameter (- l-dia 6)
              #:upper-diameter (- u-dia 6) #:height h)))
 (constraints:
  (assert: (>= atch-l atch-w))
  (assert: (= atch-l (+ atch-w (/ l-dia 2))))
  (assert: (>= atch-l (- l-dia u-dia)))
  (assert: (>= u-dia 8))
  (assert: (>= l-dia h))
  (assert: (> (* 0.8 l-dia) u-dia))
  (assert: (>= h (+ atch-w 10)))
  (assert: (= screw-x x))
  (assert: (= screw-y (+ y (* (cos rot-x) atch-l))))
  (assert: (= screw-z (+ z (* (sin rot-x) atch-l))))))

(shape: lamp-base (dia height screw-dia screw-x screw-y screw-z mnt-l mnt-w mnt-th)
 (script:
  (named: base (cylinder #:diameter dia #:height height))
  (cuboid #:height mnt-l #:width mnt-w #:length mnt-th
   #:x (/ mnt-th -2) #:y (- (/ dia 2) (+ (/ mnt-w 2) 10)) #:z (+ (/ height 2) (/ mnt-l 2)))
  (cylinder #:diameter mnt-w #:height mnt-th
   #:x (/ mnt-th -2) #:y (- (/ dia 2) (+ (/ mnt-w 2) 10)) #:z (+ (/ height 2) mnt-l) #:rot-y 90)
  (cut: (named: sh (cylinder #:diameter screw-dia #:height mnt-th
   #:x (/ mnt-th -2) #:y (- (/ dia 2) (+ (/ mnt-w 2) 10)) #:z (+ (/ height 2) mnt-l) #:rot-y 90))))
 (constraints:
  (assert: (>= mnt-l (/ mnt-w 2)))
  (assert: (>= dia (+ mnt-w 5)))
  (assert: (>= height 5))
  (assert: (= screw-x (- x (/ mnt-th 2))))
  (assert: (= screw-y (+ y (- (/ dia 2) (+ (/ mnt-w 2) 10)))))
  (assert: (= screw-z (+ z (/ height 2) mnt-l)))))

(shape: lamp-arm (l w th screw-dia s1-x s1-y s1-z s2-x s2-y s2-z)
 (script:
  (cuboid #:height l #:width w #:length th)
  (cylinder #:diameter w #:height th #:z (/ l -2) #:rot-y 90)
  (cylinder #:diameter w #:height th #:z (/ l 2) #:rot-y 90)
  (cut: (named: s1 (cylinder #:diameter screw-dia #:height th
                             #:z (/ l -2) #:rot-y 90)))
  (cut: (named: s2 (cylinder #:diameter screw-dia #:height th
                             #:z (/ l 2) #:rot-y 90))))
 (constraints:
  (assert: (>= l (+ 10 (* 2 w))))
  (assert: (= s1-x x))
  (assert: (= s2-x x))
  (assert: (= s1-y (+ y (* (sin rot-x) (/ l 2)))))
  (assert: (= s2-y (- y (* (sin rot-x) (/ l 2)))))
  (assert: (= s1-z (- z (* (cos rot-x) (/ l 2)))))
  (assert: (= s2-z (+ z (* (cos rot-x) (/ l 2)))))
  (assert: (< screw-dia w))))

(shape: lamp (base-dia base-height lower-arm-length lower-arm-angle upper-arm-length upper-arm-angle arm-width arm-thickness shade-lower-dia shade-upper-dia shade-height shade-angle screw-dia)
 (script:
  (named: base (lamp-base #:dia base-dia #:height base-height #:screw-dia screw-dia #:mnt-w arm-width #:mnt-th arm-thickness))
  (named: l-arm (lamp-arm #:l lower-arm-length #:w arm-width #:screw-dia screw-dia #:th arm-thickness #:rot-x lower-arm-angle))
  (hinge-point #:outer-dia arm-width #:inner-dia screw-dia #:inner-length (* 2 arm-thickness) #:x (+ base.screw-x (/ arm-thickness 2)) #:y base.screw-y #:z base.screw-z)
  (named: u-arm (lamp-arm #:l upper-arm-length #:w arm-width #:screw-dia screw-dia #:th arm-thickness #:rot-x upper-arm-angle))
  (hinge-point #:outer-dia arm-width #:inner-dia screw-dia #:inner-length (* 2 arm-thickness) #:x (- l-arm.s2-x (/ arm-thickness 2)) #:y l-arm.s2-y #:z l-arm.s2-z)
  (named: shade (lamp-shade #:l-dia shade-lower-dia #:u-dia shade-upper-dia #:h shade-height #:atch-w arm-width #:atch-th arm-thickness #:screw-dia screw-dia #:rot-x shade-angle))
  (hinge-point #:outer-dia arm-width #:inner-dia screw-dia #:inner-length (* 2 arm-thickness) #:x (+ u-arm.s2-x (/ arm-thickness 2)) #:y u-arm.s2-y #:z u-arm.s2-z))
 (constraints:
  (assert: (>= arm-thickness 4))
  (assert: (>= arm-width (+ arm-thickness 4)))
  (assert: (= (+ base.screw-x arm-thickness) l-arm.s1-x))
  (assert: (= base.screw-y l-arm.s1-y))
  (assert: (= base.screw-z l-arm.s1-z))
  (assert: (= base.screw-x u-arm.s1-x))
  (assert: (= l-arm.s2-y u-arm.s1-y))
  (assert: (= l-arm.s2-z u-arm.s1-z))
  (assert: (= (+ base.screw-x arm-thickness) shade.screw-x))
  (assert: (= u-arm.s2-y shade.screw-y))
  (assert: (= u-arm.s2-z shade.screw-z))))

(print: (lamp
  #:base-dia 100
  #:base-height 15
  #:lower-arm-length 120
  #:lower-arm-angle -30
  #:upper-arm-length 80
  #:upper-arm-angle 45
  #:arm-width 30
  #:arm-thickness 8
  #:shade-lower-dia 80
  #:shade-upper-dia 40
  #:shade-height 50
  #:shade-angle -10
  #:screw-dia 8)
 "lamp.stl")