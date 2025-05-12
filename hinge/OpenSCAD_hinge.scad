module leaf (w, t, h, knuckle_dia, screw_dia){
 assert(screw_dia>=w/8);
 assert(screw_dia<w && screw_dia<h/2);
 assert(knuckle_dia>=t);
 union(){
  difference(){
   cube([w, t, h], center=true);
   translate([0, 0, h/4])
    rotate([90, 0, 0])
     cylinder(h=t, d=screw_dia, center = true);
   translate([0, 0, -h/4])
    rotate([90, 0, 0])
     cylinder(h=t, d=screw_dia, center = true);
  };
  translate([w/2 + knuckle_dia/4, 0, -h/4])
   cube([knuckle_dia/2, t, h/2], center = true);
  translate([w/2 + knuckle_dia/2, 0, -h/4])
   cylinder(h=h/2, d=knuckle_dia, center = true);
 }
}


module hinge (w, t, h, screw_dia, pin_dia, knuckle_dia){
 assert(pin_dia>=knuckle_dia*0.8);
 assert(pin_dia<knuckle_dia);
 union(){
  //Leaf with pin
  union(){
   leaf(w=w, t=t, h=h, knuckle_dia=knuckle_dia, screw_dia=screw_dia);
   translate([w/2+knuckle_dia/2, 0, h/4])
    cylinder(h=h/2, d=pin_dia-1, center = true);
  }
  //Leaf with hole
  difference(){
   translate([0, knuckle_dia*2, 0])
    leaf(w=w, t=t, h=h, knuckle_dia=knuckle_dia, screw_dia=screw_dia);
   translate([w/2+knuckle_dia/2, knuckle_dia*2, -h/4])
    cylinder(h=h/2, d=pin_dia, center = true);  
  }
 }
}

hinge(w=25, t=4, h=50, screw_dia=10, pin_dia=8, knuckle_dia=10);