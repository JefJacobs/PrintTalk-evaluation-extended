import cadquery as cq

def bottom_cyl(height):
    body = cq.Workplane('XY', origin=(0, 0, -height / 2)).circle(radius=3.25).extrude(height)
    diff = cq.Workplane('XY', origin=(0, 0, -height / 2)).circle(radius=2.4).extrude(height)
    return body.cut(diff)

def block(l, w, h, clearance):
    body = cq.Workplane('XY', origin=(0, 0, -h/2)).rect(xLen=l*8-clearance, yLen=w*8-clearance).extrude(h)
    diff = cq.Workplane('XY', origin=(0, 0, -h/2)).rect(xLen=l*8-clearance-2.4, yLen=w*8-clearance-2.4).extrude(h-1.2)
    return body.cut(diff)

def brick(l):
    cyl_delta = 8
    bottom_cyl_begin_x = -(l/2-1)*cyl_delta
    top_cyl_begin_x = -((l/2)*cyl_delta)+cyl_delta/2
    blk = block(l=l, w=2, h=9.6, clearance=0.2)
    assy = cq.Assembly()
    assy.add(blk)
    for i in range(l-1):
        bc = bottom_cyl(height=8.4).translate((bottom_cyl_begin_x + i * cyl_delta, 0, 0))
        assy.add(bc)
    for i in range(l):
        cyl = cq.Workplane('XY', origin=(top_cyl_begin_x+i*cyl_delta, -4, 4.8)).circle(radius=2.4).extrude(1.8)
        assy.add(cyl)
    for i in range(l):
        cyl = cq.Workplane('XY', origin=(top_cyl_begin_x+i*cyl_delta, 4, 4.8)).circle(radius=2.4).extrude(1.8)
        assy.add(cyl)
    return assy

if __name__ == '__main__':
    shp = brick(l=4)
    shp.save("brick-4.stl", "STL")