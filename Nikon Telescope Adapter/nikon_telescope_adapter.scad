/**
* Adapter to attach camera's with a Nikon F-mount to a telescope focuser.
* Danny Havenith, May 2020
*
* Uses Nikon F-mount sources by
* Scott Kovaleski
*  03/22/12
*/

use <NikonFMountMale.scad>

// Tube diameter(mm) 1.25" = 31.75, 2" = 50.8
tube_diameter=31.75;

// Height of cone. Choose 0 to get the shortest cone.
input_cone_height=0;

// maximum overhang angle (degrees). 45 should be safe. Lower is safer.
input_overhang_angle = 50; // [10:89]

// extent of adapter into the focuser tube
tube_length=30;    

// Length of collar
collar_length=1;   

// Wall thickness, needs to be high enough to support camera weight.
wall=3;              

collar_diameter= tube_diameter + 2.75;

// overlap of geometries
d=.01 + 0;

tube_inner_d = tube_diameter - 2*wall;

// f-mount properties.
fmount_diameter=60 + 0; // outer diameter of the Nikon F mount
fmount_d_in = 2 * 17.50;

// make sure the cone is not negative and long enough to keep the overhang
// within 45 degrees.
max_overhang_angle = min(max( 10, input_overhang_angle), 89);
overhang1 = fmount_diameter - collar_diameter;
overhang2 = tube_inner_d - fmount_d_in;
max_overhang = max( 0, max( overhang1, overhang2));
cone_height = max(max( 0, input_cone_height), 
                  max_overhang/(2*tan(max_overhang_angle)));
$fn=100+0;

// the "outer" parts of the adapter
module outer_assembly()
{
    union() {
        fmount_male();
        
        translate([0,0,-cone_height - d])
        cylinder(
            d1 = collar_diameter,
            d2 = fmount_diameter,
            h = cone_height + 2*d);
        translate([0,0,-(cone_height+collar_length)])
        cylinder(
            d=collar_diameter,
            h=collar_length + 2 * d);
        translate( [0,0,-(cone_height+tube_length+collar_length)])
        cylinder(
            d=tube_diameter,
            h=tube_length+collar_length+d);
    }
}

difference() {
    outer_assembly();
    translate([0,0,-(cone_height+tube_length+collar_length+d)])
        cylinder(
            d = tube_inner_d,
            h = tube_length+collar_length + 2 * d);
    translate( [0,0,-(cone_height+d)])
        cylinder(
            d2 = fmount_d_in,
            d1 = tube_inner_d,
            h = cone_height + 3 * d);
}
