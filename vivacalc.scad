// USER VARIABLES //
// Terrarium statistics //
// Total lenght of terrarium?
terralength=2000; 
// Total height of terrarium?
terraheight=600;
// Total depth of terrarium?
terradepth=500;
// Width of the OSB boards?
boardwidth=12;
// Width of the trusses?
trusswidth=34;

// WINDOWS //
// Height of the window pane on the top?
windowpanetop=100;
// Height of the window pane on the bottom?
windowpanebottom=100;
// How much overlap should the windows have? (3cm - 5cm is common)
windowOverdraft=50;

// SUPPORTS //
// Number of additional supports, excluding trusses on the left and right?
numberofsupports=2; 

// Show/hide certain parts (will not calculate them either!)
// Show the windows?
showWindows=true;
// Show the panels on the outside?
showOuterPanels=true;
// Show the window frames?
showWindowFrames=true;
// Show the truss framework?
showFramework=true;
// Show or hide the supports?
showSupports=true;

// END OF USER VARIABLES //
// These will be derived from the above user variables and exist solely for readability.

// Outer panes
topbottompanelenght = terralength - (boardwidth*2);
backplaneheight = terraheight - (boardwidth *2);

// trusses
// vertical (blue)
verticaltrusslength = (terraheight-(trusswidth*2 + boardwidth*2));
// horizontal (red)
horizontaltrusslength = (terralength-boardwidth*2);
// deep (green)
deeptrusslength = (terradepth-(trusswidth*2+boardwidth*2));
// supports
distancebetweensupports = ((terralength - (trusswidth+boardwidth*2)) / (numberofsupports +1));


// Windows
windowlength = (terralength-(boardwidth*2)) / 2 + windowOverdraft;
windowheight = (terraheight-(boardwidth*2)-(windowpanetop + windowpanebottom));
windowwidth = (boardwidth/2);

windowplanelenght = terralength-(boardwidth*2);

echo("--8<------ BEGIN STATISTICS ------8<--");

if (showOuterPanels){
	echo(str("2x OUTER boards (orange): ", terradepth, "x", terraheight));
	echo(str("2x OUTER boards (pink): ", terradepth, "x", topbottompanelenght));
	echo(str("1x BACKPLANE board (teal): ", backplaneheight, "x", topbottompanelenght));

    // Left and right boards (orange)
	color("orange") {
		// left
		cube([boardwidth,terradepth,terraheight]);
		// right
		translate([(terralength-boardwidth),0,0]) {
			cube([boardwidth,terradepth,terraheight]);
		}
	}
	color("pink") {
		// bottom
		translate([boardwidth,0,0]) {
			cube([topbottompanelenght,terradepth,boardwidth]);
		}
		// top
		translate([boardwidth,0,(terraheight-boardwidth)]) {
			cube([topbottompanelenght,(terradepth),boardwidth]);
		}
	}
	color("teal") {
		// backplane board
		translate([boardwidth,(terradepth-boardwidth),boardwidth]) {
			cube([topbottompanelenght,boardwidth,backplaneheight]);
		}
	}
}

if(showFramework){
	color("red") {
		echo(str("4x TRUSS - horizontal (red): ", horizontaltrusslength, "(l)"));
		// Front top
		translate([boardwidth,boardwidth,(terraheight-(trusswidth+boardwidth))]) {
			cube([horizontaltrusslength,trusswidth,trusswidth]);
		}
		// Back top
		translate([boardwidth,(terradepth-(trusswidth+boardwidth)),(terraheight-(trusswidth+boardwidth))]){
			cube([horizontaltrusslength,trusswidth,trusswidth]);
		}
		// Back bottom
		translate([boardwidth,(terradepth-(trusswidth+boardwidth)),boardwidth]){
			cube([horizontaltrusslength,trusswidth,trusswidth]);
		}
		// Front bottom
		translate([boardwidth,boardwidth,boardwidth]){
			cube([horizontaltrusslength,trusswidth,trusswidth]);
		}
	}
	color("blue") {
		echo(str("4x TRUSS - vertical (blue): ", verticaltrusslength, "(l)"));
		// left front
		translate([boardwidth,boardwidth,trusswidth+boardwidth]) {
			cube([trusswidth,trusswidth,verticaltrusslength]);
		}
		// left back
		translate([boardwidth,(terradepth-(trusswidth+boardwidth)),trusswidth+boardwidth]) {
			cube([trusswidth,trusswidth,verticaltrusslength]);
		}
		// right back
		translate([(terralength-(trusswidth+boardwidth)),(terradepth-(trusswidth+boardwidth)),trusswidth+boardwidth]) {
			cube([trusswidth,trusswidth,verticaltrusslength]);
		}
		// right front
		translate([(terralength-(trusswidth+boardwidth)),boardwidth,trusswidth+boardwidth]) {
			cube([trusswidth,trusswidth,verticaltrusslength]);
		}
	}
	color("green"){
		echo(str("4x TRUSS - deep (green): ", deeptrusslength, "(l)"));
		// left bottom
		translate([boardwidth,(trusswidth+boardwidth),boardwidth]) {
			cube([trusswidth,deeptrusslength,trusswidth]);
		}
		// left top
		translate([boardwidth,trusswidth+boardwidth,(terraheight-(trusswidth+boardwidth))]) {
			cube([trusswidth,deeptrusslength,trusswidth]);
		}
		// right bottom
		translate([(terralength-(trusswidth+boardwidth)),trusswidth+boardwidth,boardwidth]) {
			cube([trusswidth,deeptrusslength,trusswidth]);
		}
		// right top
		translate([(terralength-(trusswidth+boardwidth)),trusswidth+boardwidth,(terraheight-(trusswidth+boardwidth))]) {
			cube([trusswidth,deeptrusslength,trusswidth]);
		}
	}
}

if (showSupports) {
	if(numberofsupports > 0) {
	// green
	echo(str(numberofsupports * 2, "x TRUSS - for supports, deep (green): ", deeptrusslength, "(l)"));
	echo(str(numberofsupports, "x TRUSS - for supports, vertical (blue): ", horizontaltrusslength, "(l)"));
		for (i = [1 : numberofsupports]){
			offsetleft = (distancebetweensupports*(i)+boardwidth);
			color("green") {
				// bottom
				translate([offsetleft, (trusswidth+boardwidth), boardwidth]) { 
					cube([trusswidth, deeptrusslength, trusswidth]);
				}
				// top
				translate([offsetleft, (trusswidth+boardwidth), (terraheight-(boardwidth+trusswidth))]) {
					cube([trusswidth, deeptrusslength, trusswidth]);
				}
			}
			// back
			translate([offsetleft, (terradepth-(trusswidth+boardwidth)), (boardwidth+trusswidth)]) {
				color("blue") {
					cube([trusswidth, trusswidth, verticaltrusslength]);
				}
			}
		}
	}
}

if (showWindowFrames){
	//Window frame bottom
	echo(str("1x WINDOW PANE BOTTOM (magenta): ", windowplanelenght, "(l) x ", windowpanebottom, "(h)"));
	color("magenta") {
		translate([((boardwidth)),0, boardwidth]) {
			cube([windowplanelenght, boardwidth, windowpanebottom]);
		}
	}
	echo(str("1x WINDOW PANE TOP (brown): ", windowplanelenght, "(l) x ", windowpanetop, "(h)"));
	//Window frame top
	color("brown") {
		translate([((boardwidth)),boardwidth, (terraheight-(boardwidth))]){
			rotate(a=180, v=[1,0,0]){
				 cube([windowplanelenght, boardwidth, windowpanetop]);
			}
		}
	}
}

// Windows
if (showWindows) {
	echo(str("2x WINDOW (Black): ", windowlength, "(l) x ", windowheight, "(h) x ", windowwidth, "(maximum width)"));
	color("black", 0.4) {
		translate([((boardwidth)),0,(boardwidth+windowpanebottom)]) {
			cube([windowlength, windowwidth, windowheight]);
		}
		translate([((terralength - (boardwidth+windowlength))),(boardwidth/2),(boardwidth+windowpanebottom)]){
			cube([windowlength, windowwidth, windowheight]);
		}
	}
}
echo("----8<---- END STATISTICS ----8<----");