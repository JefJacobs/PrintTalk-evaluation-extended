module cap(dia, height){
 difference(){cylinder(h=height, d=dia, center=true);
  union(){
   for(i=[0:9]){
    translate([cos(36*i)*dia*0.55, sin(36*i)*dia*0.55, 0])
     cylinder(h=height, d=dia/4, center=true);    
}}}}

module hinge_point(outer_dia, inner_dia, inner_length){
 union(){
  translate([(-inner_length/2)-2.5, 0, 0]) rotate([0, 90, 0]) 
   cap(dia=outer_dia, height=5);
  rotate([0, 90, 0]) cylinder(h=inner_length, d=inner_dia, center=true);
  translate([(inner_length/2)+2.5, 0, 0]) rotate([0, 90, 0])
   cap(dia=outer_dia, height=5);
}}

module lamp_shade(l_dia, u_dia, h, atch_l, atch_w, atch_th, screw_dia, screw_x, screw_y, screw_z){
 assert(atch_l >= atch_w);
 assert(atch_l >= l_dia - u_dia);
 assert(u_dia >= 8);
 assert(l_dia >= h);
 assert((0.8 * l_dia) > u_dia);
 assert(h >= (atch_w + 10));
 difference(){
  union(){
  cylinder(h=h, d1=l_dia, d2=u_dia, center=true);
   difference(){
    union(){
     translate([0, atch_l/2, 0]) 
      cube([atch_th, atch_l, atch_w], center=true);
     translate([0, atch_l, 0]) rotate([0, 90, 0]) 
      cylinder(d=atch_w, h=atch_th, center=true);
    }
    translate([0, atch_l, 0]) rotate([0, 90, 0]) 
     cylinder(d=screw_dia, h=atch_th, center=true);
  }}
  cylinder(h=h, d1=l_dia-6, d2=u_dia-6 , center=true);
}}

module lamp_base(dia, height, screw_dia, mnt_l, mnt_w, mnt_th) {
 assert(mnt_l >= mnt_w/2);
 assert(dia >= (mnt_w + 5));
 assert(height >= 5);
 cylinder(h=height, d=dia, center=true);
  translate([-mnt_th/2, (dia/2)-(mnt_w/2)-10, (height/2)+(mnt_l/2)])
   difference(){
    union(){
     cube([mnt_th, mnt_w, mnt_l], center=true);
     translate([0, 0, mnt_l/2]) rotate([0, 90, 0])
      cylinder(h=mnt_th, d=mnt_w, center=true);
    }
    translate([0, 0, mnt_l/2]) rotate([0, 90, 0])
     cylinder(h=mnt_th, d=screw_dia, center=true);
}}

module lamp_arm(l, w, th, screw_dia){
 assert(l >= (10+(2*w)))
 difference(){
  union(){
   cube([th, w , l], center=true);
   translate([0, 0, -l/2]) rotate([0, 90, 0]) 
    cylinder(h=th, d=w, center=true);
   translate([0, 0, l/2]) rotate([0, 90, 0]) 
    cylinder(h=th, d=w, center=true);
  }
  translate([0, 0, -l/2]) rotate([0, 90, 0]) 
   cylinder(h=th, d=screw_dia, center=true);
  translate([0, 0, l/2]) rotate([0, 90, 0]) 
   cylinder(h=th, d=screw_dia, center=true);
}}

module lamp(base_dia, base_height, lower_arm_length, lower_arm_angle, upper_arm_length, upper_arm_angle, arm_width, arm_thickness, shade_lower_dia, shade_upper_dia, shade_height, shade_angle, screw_dia) {
 assert(arm_thickness >= 4);
 assert(arm_width >= arm_thickness+4);
   
 base_screw_y=(base_dia/2)-(arm_width/2)-10; 
 base_screw_z = base_height/2+(arm_width-screw_dia);

 lower_arm_pos_delta_y = sin(lower_arm_angle)*(lower_arm_length/2);
 lower_arm_y=base_screw_y-lower_arm_pos_delta_y;
 lower_arm_pos_delta_z = cos(lower_arm_angle)*(lower_arm_length/2);
 lower_arm_z=base_screw_z+lower_arm_pos_delta_z;

 upper_arm_pos_delta_y = sin(upper_arm_angle)*(upper_arm_length/2);
 upper_arm_y=lower_arm_y-lower_arm_pos_delta_y-upper_arm_pos_delta_y;
 upper_arm_pos_delta_z = cos(upper_arm_angle)*(upper_arm_length/2);
 upper_arm_z=lower_arm_z+lower_arm_pos_delta_z+upper_arm_pos_delta_z;

 lamp_shade_atch_l=arm_width+(shade_lower_dia/2);
 lamp_shade_pos_delta_y = cos(shade_angle) * lamp_shade_atch_l;
 lamp_shade_y=(upper_arm_y-upper_arm_pos_delta_y-lamp_shade_pos_delta_y);
 lamp_shade_pos_delta_z = sin(shade_angle) * lamp_shade_atch_l;
 lamp_shade_z=upper_arm_z+upper_arm_pos_delta_z-lamp_shade_pos_delta_z;
 
 lamp_base(dia=base_dia, height=base_height, screw_dia=screw_dia, mnt_l=arm_width-screw_dia, mnt_w=arm_width, mnt_th=arm_thickness);
 translate([arm_thickness/2, lower_arm_y, lower_arm_z])
  rotate([lower_arm_angle, 0, 0])
   lamp_arm(l=lower_arm_length, w=arm_width, screw_dia=screw_dia, th=arm_thickness);
 translate([0, base_screw_y, base_screw_z])
  hinge_point(outer_dia=arm_width, inner_dia=screw_dia, inner_length=arm_thickness*2);
 translate([-arm_thickness/2, upper_arm_y, upper_arm_z])
  rotate([upper_arm_angle, 0, 0])
   lamp_arm(l=upper_arm_length, w=arm_width, screw_dia=screw_dia, th=arm_thickness);
 translate([0, lower_arm_y-lower_arm_pos_delta_y, lower_arm_z+lower_arm_pos_delta_z])
  hinge_point(outer_dia=arm_width, inner_dia=screw_dia, inner_length=arm_thickness*2);
 translate([arm_thickness/2, lamp_shade_y, lamp_shade_z])
  rotate([shade_angle, 0, 0])
   lamp_shade(l_dia=shade_lower_dia, u_dia=shade_upper_dia, h=shade_height, atch_l=lamp_shade_atch_l, atch_w=arm_width, atch_th=arm_thickness, screw_dia=screw_dia);
 translate([0, upper_arm_y-upper_arm_pos_delta_y, upper_arm_z+upper_arm_pos_delta_z])
  hinge_point(outer_dia=arm_width, inner_dia=screw_dia, inner_length=arm_thickness*2);   
}

lamp(
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
  screw_dia=8);