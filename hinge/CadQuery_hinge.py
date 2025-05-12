import cadquery as cq

def leaf(w, t, h, knuckle_dia, screw_dia):
    if screw_dia < w/8:
        raise Exception("minimum value for screw_dia")
    if screw_dia > w or screw_dia>h/2:
        raise Exception("maximum value for screw_dia")
    if knuckle_dia < t:
        raise Exception("minimum value for knuckle_dia")
    body = cq.Workplane('XY',origin=(0, 0, -h/2)).rect(xLen=w, yLen=t, centered=True).extrude(h)
    sh1 = cq.Workplane('XZ', origin=(0, t/2, -h/4)).circle(radius=screw_dia/2).extrude(t)
    sh2 = cq.Workplane('XZ', origin=(0, t/2, h/4)).circle(radius=screw_dia/2).extrude(t)
    knuckle = cq.Workplane('XY',origin=(w/2 + knuckle_dia/2, 0, -h/2))\
        .circle(radius=knuckle_dia/2).extrude(h/2)
    knuckleExt = cq.Workplane('XY', origin=(w/2 + knuckle_dia/4, 0, -h / 2)) \
        .rect(xLen=knuckle_dia/2, yLen=t).extrude(h/2)
    body = body.cut(sh1).cut(sh2).add(knuckle).add(knuckleExt)
    return body

def hinge(w, t, h, screw_dia, pin_dia, knuckle_dia):
    if pin_dia < knuckle_dia*0.8:
        raise Exception("minimum value for pin_dia")
    if pin_dia >= knuckle_dia:
        raise Exception("maximum value for pin_dia")
    # Leaf with pin
    lwp = leaf(w=w, t=t, h=h, knuckle_dia=knuckle_dia, screw_dia=screw_dia)
    pin = cq.Workplane('XY', origin=(w / 2 + knuckle_dia / 2, 0, h / 2)) \
        .circle(radius=pin_dia / 2).extrude(-h / 2)
    lwp = lwp.add(pin)
    # Leaf with hole
    lwh = leaf(w=w, t=t, h=h, knuckle_dia=knuckle_dia, screw_dia=screw_dia)
    hole = cq.Workplane('XY', origin=(w / 2 + knuckle_dia / 2, 0, -h / 2)) \
        .circle(radius=pin_dia / 2).extrude(h / 2)
    lwh = lwh.cut(hole)
    assy = cq.Assembly()
    assy.add(lwp)
    assy.add(lwh.translate((0, 2*knuckle_dia, 0)))
    return assy

if __name__ == '__main__':
    shp = hinge(w=25, t=4, h=50, screw_dia=10, pin_dia=8, knuckle_dia=10)
    shp.save("hinge.stl", "STL")