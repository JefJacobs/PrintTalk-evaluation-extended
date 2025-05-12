module bottom_cyl (height){
    difference(){
        cylinder(h=height, d=6.5, center = true);
        cylinder(h=height, d=4.8, center = true);
    }
}

module block (l, w, h, clearance){
    difference(){
        cube([l*8-clearance, w*8-clearance, h], center = true);
        translate([0, 0, -0.61])
            cube([(l*8-clearance)-2.4, (w*8-clearance)-2.4, h-1.2], center = true);
        }
}

module brick (l){
    cyl_delta = 8;
    bottom_cyl_begin_x = -(l/2-1)*cyl_delta;
    top_cyl_begin_x = -((l/2)*cyl_delta)+cyl_delta/2;
    union(){
        block(l=l, w=2, h=9.6, clearance=0.2);
        for(i=[0:l-2]){
            translate([bottom_cyl_begin_x+i*cyl_delta, 0, -0.6])
                bottom_cyl(height=8.4);
            }
        for(i=[0:l-1]){
            translate([top_cyl_begin_x+i*cyl_delta, -4, 5.7])
                cylinder(h=1.8, d=4.8, center = true);
            }
        for(i=[0:l-1]){
            translate([top_cyl_begin_x+i*cyl_delta, 4, 5.7])
                cylinder(h=1.8, d=4.8, center = true);
            }
        }
}

brick(l=4);