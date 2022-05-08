// ===== 1 ======= 2 ======= 3 ======= 4 ======= 5 ======= 6 ======= 7
/*

https://github.com/t-o-k/POV-Ray-icosahedron

Copyright (c) 2022 Tor Olav Kristensen, http://subcube.com

Use of this source code is governed by the GNU Lesser General
Public License version 3, which can be found in the LICENSE file.

*/
// ===== 1 ======= 2 ======= 3 ======= 4 ======= 5 ======= 6 ======= 7

// Render options:
// +a0.1 +w940 +h814 +FN +ua

#version 3.7;

global_settings { assumed_gamma 1.0 }

#declare Tr = color rgbt <0, 0, 0, 1>;

#declare Bk = color rgb <0, 0, 0>;
#declare Rd = color rgb <1, 0, 0>;
#declare Gn = color rgb <0, 1, 0>;
#declare Bu = color rgb <0, 0, 1>;
#declare Cy = color rgb <0, 1, 1>;
#declare Mg = color rgb <1, 0, 1>;
#declare Ye = color rgb <1, 1, 0>;
#declare Wh = color rgb <1, 1, 1>;

default {
    finish {
        diffuse 0
        emission color Wh
    }
}

// ===== 1 ======= 2 ======= 3 ======= 4 ======= 5 ======= 6 ======= 7

#macro ObjectPigment(Object, ColorOutside, ColorInside)

    pigment {
        object {
            Object
            color ColorOutside
            color ColorInside
        }
    }

#end // macro ObjectPigment


#macro PigmentGridMesh(Vertices2A, Pigment)

    #local SizeI = dimension_size(Vertices2A, 1);
    #local SizeJ = dimension_size(Vertices2A, 2);
    #local W = SizeI - 1;
    #local H = SizeJ - 1;
    
    mesh {
        #local I0 = 0;
        #while (I0 < SizeI-1)
            #local IP = I0 + 1;
            #local J0 = 0;
            #while (J0 < SizeJ-1)
                #local JP = J0 + 1;
                triangle {
                    Vertices2A[IP][J0],
                    Vertices2A[I0][J0],
                    Vertices2A[IP][JP]
                    uv_vectors
                        <IP/W, J0/H>,
                        <I0/W, J0/H>,
                        <IP/W, JP/H>
                }
                triangle {
                    Vertices2A[I0][JP],
                    Vertices2A[IP][JP],
                    Vertices2A[I0][J0]
                    uv_vectors
                        <I0/W, JP/H>,
                        <IP/W, JP/H>,
                        <I0/W, J0/H>
                }
                #local J0 = JP;
            #end // while
            #local I0 = IP;
        #end // while
        texture {
            uv_mapping
            pigment { Pigment }
        }
    }

#end // macro PigmentGridMesh

// ===== 1 ======= 2 ======= 3 ======= 4 ======= 5 ======= 6 ======= 7

// Arrow shaped prism
// The cross section of this will be uv-mapped onto a mesh

#declare UA = 0.00;
#declare UB = 0.80;
#declare UC = 0.82;
#declare UD = 1.00;

#declare VA = 0.00;
#declare VB = 0.35;
#declare VC = 0.50;
#declare VD = 0.65;
#declare VE = 1.00;

#declare Arrow = 
    prism {
        linear_sweep
        linear_spline
        -1,
        +1,
        9,
        <UA, VC>,
        <UA, VB>,
        <UC, VB>,
        <UB, VA>,
        <UD, VC>,
        <UB, VE>,
        <UC, VD>,
        <UA, VD>,
        <UA, VC>
        rotate -90*x
    }

// Mesh along a circle segment

#declare SizeW = 101; // Vertices along "width" of mesh
#declare SizeH = 11; // Vertices along "height" of mesh

#declare MeshVertices = array[SizeW][SizeH];

#declare D = 10; // Circle segment is (120 - 2*D) degrees

#declare RotDir = -1; // Clockwise arrows
// #declare RotDir = +1; // Anticlockwise arrows


#for (CntW, 0, SizeW-1)
    #declare Angle = (D + CntW/(SizeW - 1)*(120 - 2*D));
    #for (CntH, 0, SizeH-1)
        #declare Radius = 150 + CntH*8;
        #declare MeshVertices[CntW][CntH] =
            vrotate(Radius*y, RotDir*Angle*z)
        ;
    #end // for
#end // for

#declare CircleSegment =
    PigmentGridMesh(
        MeshVertices,
        ObjectPigment(
            Arrow,
            color Tr,
            color Bk
        )
    )

#declare ArrowCircle =
    union {
        object {
            CircleSegment
            rotate -120*z
        }
        object {
            CircleSegment
        }
        object {
            CircleSegment
            rotate +120*z
        }
    }    

// ===== 1 ======= 2 ======= 3 ======= 4 ======= 5 ======= 6 ======= 7

#declare Radials =
    union {
        cylinder {
            40*y, 230*y, 4
            rotate(-120*z)
        }
        cylinder {
            40*y, 230*y, 4
        }
        cylinder {
            40*y, 230*y, 4
            rotate(+120*z)
        }
        pigment { color 0.3*Wh }
    }

// ===== 1 ======= 2 ======= 3 ======= 4 ======= 5 ======= 6 ======= 7

#declare CenterDot =
    disc {
        0*z, -z, 16
        pigment { color Bk }
    }

// ===== 1 ======= 2 ======= 3 ======= 4 ======= 5 ======= 6 ======= 7

#declare SolidTriangle =
    prism {
        linear_sweep
        linear_spline
        -1,
        +1,
        4,
        <cos(+3/6*pi), sin(+3/6*pi)>,
        <cos(-1/6*pi), sin(-1/6*pi)>,
        <cos(-5/6*pi), sin(-5/6*pi)>,
        <cos(+3/6*pi), sin(+3/6*pi)>
    }

#declare DX1 = 470;  // 2*470 = 940
#declare W1 = DX1*tan(pi/6);
#declare DY1 = DX1*tan(pi/3); // 814.063
#declare Radius1 = DY1 - W1;

#declare DX2 = 430;
#declare DY2 = DX2*tan(pi/3);
#declare W2 = DX2*tan(pi/6);
#declare DY2 = DX2*tan(pi/3);
#declare Radius2 = DY2 - W2;

#declare Triangle =
    difference {
        object {
            SolidTriangle
            scale <Radius1, 10, Radius1>
        }
        object {
            SolidTriangle
            scale <Radius2, 20, Radius2>
        }
        rotate -90*x
        pigment { color 0.3*Wh }
    }

// ===== 1 ======= 2 ======= 3 ======= 4 ======= 5 ======= 6 ======= 7

#declare Coordinates =
    union {
        text {
            ttf "timrom.ttf" "(0.0, 0.0)" 1, 0
            scale 50*<1, 1, 1>
            translate -11.9*y
            translate -440*x
        }
        text {
            ttf "timrom.ttf" "(0.5, 1.0)" 1, 0
            scale 50*<1, 1, 1>
            translate -11.9*y
            translate -440*x
            rotate -120*z
        }
        text {
            ttf "timrom.ttf" "(1.0, 0.0)" 1, 0
            scale 50*<1, 1, 1>
            translate -11.9*y
            translate -440*x
            rotate +120*z
        }
        rotate +30*z
        pigment { color Bk }
    }


// ===== 1 ======= 2 ======= 3 ======= 4 ======= 5 ======= 6 ======= 7

#declare URL = "https://github.com/t-o-k/POV-Ray-icosahedron"

#declare TextURL =
    text {
        ttf "timrom.ttf" URL 1, 0
        pigment { color Bk }
        scale 30*<1, 1, 1>
        rotate 60*z
        translate -420*x -140*y
    }

union {
    object { TextURL     translate +10*z }
    object { Coordinates translate +20*z }
    object { CenterDot   translate +30*z }
    object { Radials     translate +40*z }
    object { ArrowCircle translate +50*z }
    object { Triangle    translate +60*z }
    translate -Radius1/4*y
}

// ===== 1 ======= 2 ======= 3 ======= 4 ======= 5 ======= 6 ======= 7

background {
    color Wh // or color <1.0, 1.0, 1.0, 0.3> or color Tr
}

camera {
    orthographic
    direction +z
    right +image_width*x
    up +image_height*y
    sky +y
    location -z
}

// ===== 1 ======= 2 ======= 3 ======= 4 ======= 5 ======= 6 ======= 7
