// Nikon F-mount Male
// Scott Kovaleski
// 03/22/12
//
// D. Havenith, june 2020
// *  Use the "angle" parameter of rotate_extrude() to no 
// longer require the angle()-operator. Requires version 2019.05
// of OpenScad.
// *  Add a slot to receive the locking pin of the mount

r_in = 17.50; // radius of the opening
r_in_tab = 22.00; // radius inside tab
r_out_tab = 23.10; // radius outside tab, shrunk slightly to fit
r_out = 30.00; // outer radius

y_tab = 3.20; // height to bottom of tab
h_tab = 1.40; // tab height, extended slightly to allow angled support for tab

module fmount_male(height=3) { // build the Nikon male f-mount

	a1 = 72.21; // arc degrees of tab 1 starts at the dot
	a2 = 53.45; // arc degrees of next open space CCW
	a3 = 60.78-5.34; // arc degrees of tab 2 CCW minus stop
	a4 = 5.34; // arc degrees of stop
	a5 = 58.65; // arc degrees of next open space CCW
	a6 = 56.39; // arc degree of last tab
	
	slot_depth = 2;
	slot_width = 2.2;
	slot_length = 6;

    difference() {
	    // added 2 degree buffers to tabless sections to make model manifold
	    union() {
			    section_type_a(angle = a1, hp=height);
			    rotate([0,0,a1-2])
				    section_type_b(angle=a2 + 4, hp=height);
			    rotate([0,0,a1 + a2])
				    section_type_a(angle=a3 + 2, hp=height);
			    rotate([0,0,a1 + a2 + a3])
				    section_type_c(angle=a4, hp=height);
			    rotate([0,0,a1 + a2 + a3 + a4 - 2])
				    section_type_b(angle=a5 + 4, hp=height);
			    rotate([0,0,a1 + a2 + a3 + a4 + a5])
				    section_type_a(angle=a6, hp=height);
			    rotate([0,0,a1 + a2 + a3 + a4 + a5 + a6 - 2])
				    section_type_b(angle=364-a1-a2-a3-a4-a5-a6, hp=height);
	    }
	    
	    translate([ -(slot_width/2), 29.5 - slot_length, height - slot_depth + .01])
	        cube([slot_width, slot_length, slot_depth]);
	    
    }
}

module section_type_a(angle = 60, hp=25) { // section with a lip

	// hp is the height from the flange, angle is the size of the section

	// added a slanted support from paths 3 to 4 to make tabs easier to print
	rotate_extrude($fn=200, angle = angle)
		polygon(
			points=[
			[ r_in, 0],
			[ r_in,hp + y_tab + h_tab],
			[ r_out_tab,hp + y_tab + h_tab],
			[ r_out_tab,hp + y_tab + h_tab/2],
			[ r_in_tab,hp + y_tab],
			[ r_in_tab,hp],
			[ r_out,hp],
			[ r_out,0]],
			paths=[[0,1,2,3,4,5,6,7]]
		);
}

module section_type_b(angle = 60, hp=25) { // section without a tab

	// hp is the height from the flange, angle is the size of the section

	rotate_extrude($fn=200, angle = angle)
		polygon(
			points=[
			    [ r_in,0],
			    [ r_in,hp + y_tab + h_tab],
			    [ r_in_tab,hp + y_tab + h_tab],
			    [ r_in_tab,hp],
			    [ r_out,hp],
			    [ r_out,0]],
			paths=[[0,1,2,3,4,5]]
		);
}

module section_type_c(angle = 60, hp=25) { // stop for the tab
	
	// hp is the height from the flange, angle is the size of the section
	
	rotate_extrude($fn=200, angle = angle)
			polygon(
				points=[
				    [ r_in,0],
				    [ r_in,hp + y_tab + h_tab],
				    [ r_out_tab,hp + y_tab + h_tab],
				    [ r_out_tab,hp],
				    [ r_out,hp],
				    [ r_out,0]],
				paths=[[0,1,2,3,4,5]]
			);
}
