//
// Polar Scope illuminator for Skywatcher mounts
// with battery compartment/switch
// Copyright (C) 2020 Danny Havenith
//

// tube diameter (mm)
tube_d = 35;    

// height of the tabs that go into the tube (mm)
tube_h = 8;     

// gap between tabs
gap = 2;  

// diameter of cap
cap_d = 43 + 5; 

// depth of insert for original cap in the back
cap_insert = 6; 

// "vertical wall" thickness
vwall = 1.9;

// wall thickness of cap
wall = 1.4; 

// wall thickness of battery holder
wall2= 1.4; 

// diameter of LED legs.
led_d = 0.8;
 
// How far the bottom LED leg extends into the battery holder
led_inset = 8; 

battery_d = 20 + .2; // battery diameter, including some slack
battery_h = 3.2 + 0.1; // battery height, including some slack

cap_h = 2 * vwall + battery_h + 3;
cap_insert_d = tube_d + 0.4;
protector_w = gap; // width of small protector bump of LED leads.

D = 0.01 + 0; // generic overlap of parts.
$fn=200 + 0;

module cap() {
    difference() {

        union() {
            translate([0,0,cap_h - D])
                difference()
                {
                    // wall
                    cylinder( d = tube_d, h = tube_h + D);

                    // 4 cutouts in outer wall
                    translate([0,0,-D])
                    union() {
                        translate([-gap/2, -tube_d/2 - D, 0  ])
                            cube([gap, tube_d + 2*D, tube_h + 3*D]);
                        rotate([0,0,90])
                            translate([-gap/2, -tube_d/2 - D, 0  ])
                                cube([gap, tube_d + 2*D, tube_h + 3*D]);
                    }
                }
            //cap
            cylinder( d = cap_d, h = cap_h);
        }
        translate([0,0,-D])
            cylinder( d = tube_d - 2 * wall, h = tube_h + cap_h + 2 * D);
            
        // make room in the back to insert the original cap
        // make it a bit wider to allow for imprecise circles
        translate([0,0,-D])
            cylinder( d = cap_insert_d, h = cap_insert + D);
    }
    
    // small bump to protect the LED leads when inserting the original cap
    translate([cap_insert_d/2-wall, -protector_w/2, 0])
        cube([wall+D, protector_w, wall]);
}

// a circle that encloses a CR2032 battery
module hoop( h=battery_h, inset=0) {
    difference() {
        cylinder( d=battery_d+2*wall2, h = h);
        translate( [0,0,-D ])
        cylinder( d=battery_d-inset, h=h+2*D);
}
}



module battery_holder() {
    shift = .2 * battery_d;
    hang = .6; // compensate for hanging bridge

    //battery holder, "on" position
    difference() {
        hoop(h=battery_h + hang);
        
        translate([shift, -battery_d/2, -D])
            cube([battery_d, battery_d, battery_h + hang + 2*D]);
        
        translate([-(wall2+battery_d/2), -led_d/2, battery_h - led_d])
            cube( [wall2 + led_inset + D, led_d, led_d+D]);

    }
    
    // bottom support battery, bar.
    // This keeps the battery from rotating around Y
    //  when in the "off" position
    // and guides it when moving to the "on" position.
    translate([0,0,-(vwall)])
    difference() {
        translate([-(battery_d/2), -vwall, 0])
            cube([battery_d/2 + shift/2 , 2 * vwall, vwall + D]);
        translate([-(wall2+battery_d/2+D), -led_d/2, vwall - led_d])
            cube( [wall2 + led_inset + D, led_d, led_d+ 2 * D]);
    }
    
    // top support battery holder "on"
    translate([0, 0, battery_h])
    difference() {
        hoop(inset=2, h = vwall);
        translate([ shift, -(battery_d/2+wall2), -D])
            cube([battery_d, battery_d + 2 * wall2 , battery_h + 2*D]);
        translate([-(shift+battery_d)+1, -(battery_d/2+wall2), -D])
            cube([battery_d, battery_d + 2 * wall2, battery_h + 2*D]);
    }

    // bottom support battery holder "on"
    translate([0, 0, -vwall])
    difference() {
        hoop(inset=4, h=vwall);
        
        translate([shift, -(battery_d/2+wall2), -D])
            cube([battery_d, battery_d+ 2 * wall2 , battery_h + 2*D]);
        
        translate([-(shift+battery_d) + 1, -(battery_d/2 + wall2), -D])
            cube([battery_d, battery_d + 2 * wall2, battery_h + 2*D]);
    }
    
    // roof
    translate([0,0,battery_h + hang - D])
    difference() {
       cylinder(d=battery_d + 2*wall2, h=vwall);
        
        translate([-shift,-(battery_d/2 + wall2 + D), -D])
            cube([battery_d + 2*wall2, battery_d + 2 * wall2 + 2*D, vwall + 2*D]);
    }

    // floor
    translate([0,0, -vwall])
    difference() {
       cylinder(d=battery_d + 2*wall2, h=vwall + D);
        
        translate([-shift,-(battery_d/2 + wall2 + D), -D])
            cube([battery_d + 2*wall2, battery_d + 2 * wall2 + 2*D, vwall + 3*D]);
            
        translate([-(wall2+battery_d/2+D), -led_d/2, vwall - led_d])
            cube( [wall2 + led_inset + D, led_d, led_d+ 2 * D]);
    }

    
    // battery holder "off" position
    translate([2*shift - D, 0, 0])
    difference() {
        hoop();
        
        translate([ 2 * shift, -(battery_d/2+wall2), -D])
            cube([battery_d, battery_d + 2 * wall2, battery_h + 2*D]);
        
        translate([-(shift+battery_d), -battery_d/2, -D])
            cube([battery_d, battery_d, battery_h + 2*D]);
    }

    finger_gap = 10; // gap at end to prevent fingers being pinched
    // bottom support battery holder "off"
    translate([2*shift - D, 0, -vwall])
    difference() {
        hoop(inset=4, h=vwall);
        
        translate([ 2 * shift, -(battery_d/2+wall2), -D])
            cube([battery_d, battery_d+ 2 * wall2 , battery_h + 2*D]);
        
        translate([-(shift+battery_d), -(battery_d/2 + wall2), -D])
            cube([battery_d, battery_d + 2 * wall2, battery_h + 2*D]);
            
        translate([0, -finger_gap/2, -D])
            cube([battery_d, finger_gap, vwall + 2*D]);
    }

    // top support battery holder "off"
    translate([2*shift - D, 0, battery_h])
    difference() {
        hoop(inset=2, h = vwall);
        translate([ 2 * shift, -(battery_d/2+wall2), -D])
            cube([battery_d, battery_d + 2 * wall2 , battery_h + 2*D]);
        translate([-(shift+battery_d), -(battery_d/2+wall2), -D])
            cube([battery_d, battery_d + 2 * wall2, battery_h + 2*D]);
        translate([0, -finger_gap/2, -D])
            cube([battery_d, finger_gap, vwall + 2*D]);
    }


    
}

module polar_illuminator() {

    connection_overlap = 6;
    battery_offset = cap_d/2 - wall2;
    difference() {
        union() {
            // cap that fits in the polar scope tube
            cap();
            
            // battery holder, partially overlapping
            translate([battery_offset + battery_d/2 + wall2 ,0,vwall])
                battery_holder();
                
            // extra plane for a more robust connection between
            // cap and battery holder.
            translate( [cap_insert_d/2 , -battery_d/2,0])
                cube([ 2 * connection_overlap, battery_d, vwall]);
            
        }
        translate([0, -led_d/2, vwall - led_d])
            cube([cap_d/2 + led_inset + D, led_d, led_d + D]);

        translate([0, -led_d/2, vwall + battery_h - led_d])
            cube([cap_d/2 + D, led_d, led_d + D]);
    }
}

polar_illuminator();
//battery_holder();



