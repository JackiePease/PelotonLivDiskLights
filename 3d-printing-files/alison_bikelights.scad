frameThickness=1.5;
centreCircleDiameter=15;
fn=40;
ledsInRing=[1, 8, 12, 16, 24, 32];
ringRadius=[7.5, 10, 10, 10, 10, 27];
ringAmplitude=[5, 5, 5, 5, 5, 15];
noRings=6;
height=12;
diskRadius=115/2;
diskIndent=3;
plateRadius=100;
slope=0.9;
boltDiameter=3;
numBolts=8;
 union(){
        difference(){
            color("red")
            translate([0,0,(height-frameThickness)/2])
            minkowski(){
                 linear_extrude(height = height-frameThickness, center = true, $fn = fn, scale = slope){
                     bumpy_loop(sum(ringRadius, noRings-1)-frameThickness/2, ledsInRing[noRings-1], ringAmplitude[noRings-1]);
                 }
                 sphere(r=frameThickness, $fn=fn);
             }  
             color("blue")  
             linear_extrude(height = height-frameThickness, center = false, $fn = fn, scale = slope){
                for (j = [0:1:noRings-1]){
                    makeRing(j);
                 }
             }        
             cylinder(h=diskIndent*2, r=diskRadius, $fn=fn, center=true);
             translate([0, 0, -sum(ringRadius, noRings-1)])
             cube([sum(ringRadius, noRings-1)*3,sum(ringRadius, noRings-1)*3,sum(ringRadius, noRings-1)*2],true);
        }
        linear_extrude(height = diskIndent, center = false, $fn = fn){
            difference(){
               circle(r = sum(ringRadius, noRings-1) + frameThickness/2);
               circle(r = diskRadius);
               // bolt holes
               for (k = [0:1:numBolts-1]){
                  rotate([0,0,(k*360/numBolts) - 360/numBolts])
                    translate([sum(ringRadius, noRings-1) - boltDiameter,0,0])
                    circle(r=boltDiameter/2);
               }
            }
        }
}

module makeRing(j){
    
if (j == 0){
    circle(r=ringRadius[j] - frameThickness/2, $fn=fn);
    }

else {difference(){ 
            radiusOuter = sum(ringRadius, j);
            offset(-frameThickness/2)
              bumpy_loop(radiusOuter, ledsInRing[j], ringAmplitude[j]);
            if (j > 1){
              radiusOuter1 = sum(ringRadius, j-1);
              offset(frameThickness/2)
                bumpy_loop(radiusOuter1, ledsInRing[j-1], ringAmplitude[j-1]);
            }  
            else {
              // circle(r=ringRadius[j-1] + frameThickness/2);
              offset(frameThickness/2)
                circle(r=ringRadius[j-1]);
            }
             
        // radiating lines
           if (j > 0){              radiusOuter2 = sum(ringRadius, j);
              radiusInner2 = sum(ringRadius, j-1);
              for (k = [0:1:ledsInRing[j]/2 - 1]){
                  translate([0,0,0])
                  rotate([0,0,(k*360/ledsInRing[j]) - 360/ledsInRing[j]])
                    square([radiusOuter2*2, frameThickness], center = true);
              }
           }
       }
    }
}

function sum(a,i)=(i==0)?a[0]:a[i]+sum(a,i-1);

module bumpy_loop(r, bumpsx2, amplitude) {
    bumps = bumpsx2/2;
    avR = r - amplitude;
    union(){
        polygon(points=[for (th = [0 : 360]) [
            cos(th) * (avR + sin(th * bumps) * amplitude),
            sin(th) * (avR + sin(th * bumps) * amplitude)
        ]]);
   
        polygon(points=[for (th = [0 : 360]) [
            cos(th) * (avR + sin((th + 180/bumps) * bumps) * amplitude),
            sin(th) * (avR + sin((th + 180/bumps) * bumps) * amplitude)
        ]]);
    }
}
