import cadquery as cq
import math
import numpy as np

def rotate_x_matrix(angle):
    rads = math.radians(angle)
    rx = np.array([[1, 0, 0],
    [0, math.cos(rads), -math.sin(rads)],
    [0, math.sin(rads), math.cos(rads)]])
    v = np.array([[0],[0],[1]])
    res = np.dot(rx,v)
    return (res[0][0],res[1][0],res[2][0])

def cap(dia, height):
    shape = cq.Workplane('YZ', origin=(-height/2, 0, 0))\
        .circle(dia/2).extrude(height)
    for i in range(10):
        cutout = cq.Workplane('YZ', 
                              origin=(-height/2,
                                      math.cos(math.radians(36*i))*dia*0.55, 
                                      math.sin(math.radians(36*i))*dia*0.55))\
                                                .circle(dia/8).extrude(height)
        shape = shape.cut(cutout)
    return shape

def hinge_point(outer_dia, inner_dia, inner_length):
    back_cap = cap(dia=outer_dia, height=5).translate(((-inner_length/2)-2.5, 0, 0))
    middle = cq.Workplane('YZ', origin=(-inner_length/2, 0, 0))\
        .circle(inner_dia/2).extrude(inner_length)
    front_cap = cap(dia=outer_dia, height=5).translate(((inner_length/2)+2.5, 0, 0))
    front_circle = middle.faces("%PLANE").faces("<X").edges("%CIRCLE")
    front_circle.tag("front_circle")
    back_circle = middle.faces("%PLANE").faces(">X").edges("%CIRCLE")
    back_circle.tag("back_circle")
    return back_cap.union(middle).union(front_cap)

def lamp_base(dia, height, screw_dia, mnt_length, mnt_width, mnt_thickness):
    base = cq.Workplane('XY').cylinder(height,dia/2)
    atch_bx =cq.Workplane('YZ').box(mnt_width, mnt_length, mnt_thickness)
    atch_rnd = cq.Workplane('YZ', origin=(-mnt_thickness/2, 0, mnt_length/2))\
        .circle(mnt_width / 2).extrude(mnt_thickness)
    atch_hole = cq.Workplane('YZ', origin=(-mnt_thickness/2, 0, mnt_length/2))\
        .circle(screw_dia / 2).extrude(mnt_thickness)
    atch = atch_bx.union(atch_rnd).cut(atch_hole).translate((-mnt_thickness/2, 
        (dia/2)-(mnt_width/2)-10, (height/2)+(mnt_length/2)))
    base_shape = base.union(atch)
    hole = base_shape.faces("%PLANE").faces(">Z").faces(">X")\
    .edges("%CIRCLE").edges(">>Z[-2]")
    hole.tag("hole")
    return base_shape
    
def lamp_shade(l_dia, u_dia, h, atch_l, atch_w, atch_th, screw_dia):
    cone = cq.Solid.makeCone(l_dia/2, u_dia/2, h).translate((0, 0, -h/2))
    inner_cone = cq.Solid.makeCone(l_dia/2-6, u_dia/2-6, h).translate((0, 0, -h/2))
    atch = cq.Workplane('XZ').rect(atch_th, atch_w).extrude(-atch_l)
    atch_rnd = cq.Workplane('YZ', origin=(-atch_th/2, atch_l, 0))\
        .circle(atch_w/2).extrude(atch_th)
    atch_hole = cq.Workplane('YZ', origin=(-atch_th/2,
    atch_l, 0)).circle(screw_dia / 2).extrude(atch_th)
    atch = atch.union(atch_rnd).cut(atch_hole)
    shade = atch.union(cone).cut(inner_cone)
    hole = shade.faces("%PLANE").faces("<X").edges("%CIRCLE").edges(">>Y[0]")
    hole.tag("hole")
    angle_edge = atch.faces("<Y").edges(">X")
    angle_edge.tag("angle_edge")
    return shade

def lamp_arm(l, w, th, screw_dia):
    block = cq.Workplane('XY').center(0, 0).box(th, w, l)
    atch_rnd_btm = cq.Workplane('YZ', origin=(-th/2, 0, -l/2))\
        .circle(w/2).extrude(th)
    atch_hole_btm = cq.Workplane('YZ', origin=(-th/2, 0, -l/2))\
        .circle(screw_dia / 2).extrude(th)
    atch_rnd_top = cq.Workplane('YZ', origin=(-th/2, 0, l/2))\
        .circle(w / 2).extrude(th)
    atch_hole_top = cq.Workplane('YZ', origin=(-th/2, 0, l/2))\
        .circle(screw_dia / 2).extrude(th)
    arm_shape = block.union(atch_rnd_btm).cut(atch_hole_btm)\
        .union(atch_rnd_top).cut(atch_hole_top)
    front = arm_shape.faces("<X")
    front.tag("front")
    back = arm_shape.faces(">X")
    back.tag("back")
    front_bottom_hole = front.edges("%CIRCLE").edges("<<Z[-2]")
    front_bottom_hole.tag("front_bottom_hole")
    front_top_hole = front.edges("%CIRCLE").edges(">>Z[-2]")
    front_top_hole.tag("front_top_hole")
    back_bottom_hole = back.edges("%CIRCLE").edges("<<Z[-2]")
    back_bottom_hole.tag("back_bottom_hole")
    back_top_hole = back.edges("%CIRCLE").edges(">>Z[-2]")
    back_top_hole.tag("back_top_hole")
    angle_edge = front.edges("<<Y[0]")
    angle_edge.tag("angle_edge")
    return arm_shape

def lamp(base_dia, base_height, lower_arm_length, lower_arm_angle,  upper_arm_length, upper_arm_angle, arm_width, arm_thickness, shade_lower_dia, shade_upper_dia, shade_height, shade_angle, screw_dia):
    lamp_shade_atch_l = arm_width + (shade_lower_dia / 2)
    base = lamp_base(dia=base_dia, height=base_height, screw_dia=screw_dia, mnt_length=arm_width - screw_dia, mnt_width=arm_width, mnt_thickness=arm_thickness)
    base_hinge = hinge_point(outer_dia=arm_width, inner_dia=screw_dia, inner_length=arm_thickness*2)
    lower_arm = lamp_arm(l=lower_arm_length, w=arm_width, screw_dia=screw_dia, th=arm_thickness)
    upper_arm = lamp_arm(l=upper_arm_length, w=arm_width, screw_dia=screw_dia, th=arm_thickness)
    arms_hinge = hinge_point(outer_dia=arm_width, inner_dia=screw_dia, inner_length=arm_thickness*2)
    shade = lamp_shade(l_dia=shade_lower_dia, u_dia=shade_upper_dia, h=shade_height, atch_l=lamp_shade_atch_l, atch_w=arm_width, atch_th=arm_thickness, screw_dia=screw_dia)
    shade_hinge = hinge_point(outer_dia=arm_width, inner_dia=screw_dia, inner_length=arm_thickness*2)
    assy = (cq.Assembly()
    .add(base, name="base")
    .add(base_hinge, name="base_hinge")
    .add(lower_arm, name="lower_arm")
    .add(upper_arm, name="upper_arm")
    .add(arms_hinge, name="arms_hinge")
    .add(shade, name="shade")
    .add(shade_hinge, name="shade_hinge"))\
        .constrain("base?hole", "lower_arm?front_bottom_hole", "Plane", param=0)\
        .constrain("lower_arm?front_top_hole", "upper_arm?back_bottom_hole", "Plane", param=0)\
        .constrain("lower_arm?back_bottom_hole", "base_hinge?back_circle", "Plane", param=0)\
        .constrain("upper_arm?back_top_hole", "shade?hole", "Plane", param=0)\
        .constrain("lower_arm?angle_edge", "FixedAxis", rotate_x_matrix(lower_arm_angle))\
        .constrain("upper_arm?angle_edge", "FixedAxis", rotate_x_matrix(upper_arm_angle))\
        .constrain("lower_arm?back_top_hole", "arms_hinge?back_circle", "Plane", param=0)\
        .constrain("shade?angle_edge", "FixedAxis", rotate_x_matrix(shade_angle))\
        .constrain("upper_arm?front_top_hole", "shade_hinge?front_circle", "Plane", param=0)
    assy.solve()
    return assy

if __name__ == "__main__":
    basic_lamp = lamp(
        base_dia=100,
        base_height=15,
        lower_arm_length=120,
        lower_arm_angle=-30,
        upper_arm_length=80,
        upper_arm_angle=45,
        arm_width=30,
        arm_thickness=5,
        shade_lower_dia=80,
        shade_upper_dia=40,
        shade_height=50,
        shade_angle=-10,
        screw_dia=8)
    basic_lamp.save("lamp.stl", "STL")