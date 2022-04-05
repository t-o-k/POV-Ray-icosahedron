// ===== 1 ======= 2 ======= 3 ======= 4 ======= 5 ======= 6 ======= 7
/*

https://github.com/t-o-k/POV-Ray-icosahedron

Copyright (c) 2022 Tor Olav Kristensen, http://subcube.com

Use of this source code is governed by the GNU Lesser General                                                                    

Public License version 3, which can be found in the LICENSE file.

*/
// ===== 1 ======= 2 ======= 3 ======= 4 ======= 5 ======= 6 ======= 7

#version 3.7;

global_settings { assumed_gamma 1.0 }

#declare Bk = color rgb <0, 0, 0>;
#declare Rd = color rgb <1, 0, 0>;
#declare Gn = color rgb <0, 1, 0>;
#declare Bu = color rgb <0, 0, 1>;
#declare Cy = color rgb <0, 1, 1>;
#declare Mg = color rgb <1, 0, 1>;
#declare Ye = color rgb <1, 1, 0>;
#declare Wh = color rgb <1, 1, 1>;

// ===== 1 ======= 2 ======= 3 ======= 4 ======= 5 ======= 6 ======= 7

#macro SmallerTriangle(S, p0, p1, p2)

    #local pCtr = (p0 + p1 + p2)/3;

    triangle {
        S*p0, S*p1, S*p2
        translate (1 - S)*pCtr
    }

#end // macro SmallerTriangle


#macro TriangleEdges(p0, p1, p2, R)

    union {
        cylinder { p0, p1, R }
        cylinder { p1, p2, R }
        cylinder { p2, p0, R }
    }

#end // macro TriangleEdges


#macro TriangleVertices(p0, p1, p2, R)

    union {
        sphere { p0, R }
        sphere { p1, R }
        sphere { p2, R }
    }

#end // macro TriangleVertices


#macro QuadrilateralEdges(p0, p1, p2, p3, R)

    union {
        cylinder { p0, p1, R }
        cylinder { p1, p2, R }
        cylinder { p2, p3, R }
        cylinder { p3, p0, R }
    }

#end // macro QuadrilateralEdges


#macro QuadrilateralVertices(p0, p1, p2, p3, R)

    union {
        sphere { p0, R }
        sphere { p1, R }
        sphere { p2, R }
        sphere { p3, R }
    }

#end // macro QuadrilateralVertices


#macro TransformFromVectors(vX, vY, vZ, pT)

    transform {
        matrix <
            vX.x, vX.y, vX.z,
            vY.x, vY.y, vY.z,
            vZ.x, vZ.y, vZ.z,
            pT.x, pT.y, pT.z
        >
    }

#end // macro TransformFromVectors


#macro ReorientTransform(vFrom, vTo)

    #local vF = vnormalize(vFrom);
    #local vT = vnormalize(vTo);
    #local vAxis = vcross(vF, vT);
    #local Dot = min(max(-1, vdot(vF, vT)), +1);
    #local Angle = degrees(acos(Dot));

    TransformFromVectors(
        vaxis_rotate(x, vAxis, Angle),
        vaxis_rotate(y, vAxis, Angle),
        vaxis_rotate(z, vAxis, Angle),
        <0, 0, 0>
    )

#end // macro ReorientTransform

// ===== 1 ======= 2 ======= 3 ======= 4 ======= 5 ======= 6 ======= 7

// Golden Ratio

//   0 < B < A
//   A/B = (A + B)/A
//   A^2 = (A + B)*B
//   A^2 - A*B - B^2 = 0
//   A = (1 + sqrt(5))/2*B

#declare Phi = (1 + sqrt(5))/2; // = 1.618033988749...

#declare B = 1;
#declare A = Phi*B;

// Vertices in 3 Golden Rectangles

// Rectangle vertices in the XY-plane
#declare pXY0 = <-B, -A,  0>;
#declare pXY1 = <+B, -A,  0>;
#declare pXY2 = <+B, +A,  0>;
#declare pXY3 = <-B, +A,  0>;

// Rectangle vertices in the YZ-plane
#declare pYZ0 = < 0, -B, -A>;
#declare pYZ1 = < 0, +B, -A>;
#declare pYZ2 = < 0, +B, +A>;
#declare pYZ3 = < 0, -B, +A>;

// Rectangle vertices in the ZX-plane
#declare pZX0 = <-A,  0, -B>;
#declare pZX1 = <-A,  0, +B>;
#declare pZX2 = <+A,  0, +B>;
#declare pZX3 = <+A,  0, -B>;

// ===== 1 ======= 2 ======= 3 ======= 4 ======= 5 ======= 6 ======= 7

#declare Tr = 0.28;

#declare RadiusCyl = 0.01;
#declare RadiusSph = 0.03;

#declare RegularIcosahedronFrame =
    union {
        union {
            QuadrilateralVertices(pXY0, pXY1, pXY2, pXY3, RadiusSph)
            pigment { color 3*Rd }
        }
        union {
            QuadrilateralVertices(pYZ0, pYZ1, pYZ2, pYZ3, RadiusSph)
            pigment { color 3*Gn }
        }
        union {
            QuadrilateralVertices(pZX0, pZX1, pZX2, pZX3, RadiusSph)
            pigment { color 3*Bu }
        }
        union {
            cylinder { pXY0, pXY1, RadiusCyl }
            cylinder { pXY2, pXY3, RadiusCyl }

            cylinder { pYZ0, pYZ1, RadiusCyl }
            cylinder { pYZ2, pYZ3, RadiusCyl }

            cylinder { pZX0, pZX1, RadiusCyl }
            cylinder { pZX2, pZX3, RadiusCyl }

            TriangleEdges(pXY0, pZX0, pYZ0, RadiusCyl)
            TriangleEdges(pXY0, pYZ3, pZX1, RadiusCyl)
            TriangleEdges(pYZ0, pZX3, pXY1, RadiusCyl)
            TriangleEdges(pZX0, pXY3, pYZ1, RadiusCyl)
            TriangleEdges(pZX2, pXY2, pYZ2, RadiusCyl)
            TriangleEdges(pXY2, pZX3, pYZ1, RadiusCyl)
            TriangleEdges(pYZ2, pXY3, pZX1, RadiusCyl)
            TriangleEdges(pZX2, pYZ3, pXY1, RadiusCyl)

            pigment { color 2*Wh }
        }
    }

#declare S = 0.8;

#declare RegularIcosahedronTriangles =
    union {
        SmallerTriangle(S, pXY0, pZX0, pYZ0)
        SmallerTriangle(S, pXY0, pYZ3, pZX1)
        SmallerTriangle(S, pYZ0, pZX3, pXY1)
        SmallerTriangle(S, pZX0, pXY3, pYZ1)

        SmallerTriangle(S, pXY2, pYZ2, pZX2)
        SmallerTriangle(S, pXY2, pZX3, pYZ1)
        SmallerTriangle(S, pYZ2, pXY3, pZX1)
        SmallerTriangle(S, pZX2, pYZ3, pXY1)

        SmallerTriangle(S, pXY0, pXY1, pYZ3)
        SmallerTriangle(S, pXY1, pXY0, pYZ0)
        SmallerTriangle(S, pXY2, pXY3, pYZ2)
        SmallerTriangle(S, pXY3, pXY2, pYZ1)

        SmallerTriangle(S, pYZ0, pYZ1, pZX3)
        SmallerTriangle(S, pYZ1, pYZ0, pZX0)
        SmallerTriangle(S, pYZ2, pYZ3, pZX2)
        SmallerTriangle(S, pYZ3, pYZ2, pZX1)

        SmallerTriangle(S, pZX0, pZX1, pXY3)
        SmallerTriangle(S, pZX1, pZX0, pXY0)
        SmallerTriangle(S, pZX2, pZX3, pXY2)
        SmallerTriangle(S, pZX3, pZX2, pXY1)

        pigment { color rgbt <1, 1, 1, Tr> }
    }

#declare RegularIcosahedron =
    union {
        object { RegularIcosahedronFrame }
        object { RegularIcosahedronTriangles }
    }

object {
    RegularIcosahedron
    ReorientTransform(pXY0 - 0*z, -z)
}

// ===== 1 ======= 2 ======= 3 ======= 4 ======= 5 ======= 6 ======= 7

background { color (3*Rd + 1*Bu)/50 }

light_source {
    100*<-1, -1, -3>
    color Wh
    shadowless
}

light_source {
    100*<-2, 2, 1>
    color Wh/5
    shadowless
}

#declare AR = image_width/image_height;

camera {
    orthographic
    direction +z
    right +AR*x
    up +y
    sky +y
    location -24*z
    angle 15
}

// ===== 1 ======= 2 ======= 3 ======= 4 ======= 5 ======= 6 ======= 7

#declare URL = "https://github.com/t-o-k/POV-Ray-icosahedron"

text {
    ttf "timrom.ttf" URL 1e-6, 0
    texture {
        pigment { color Wh/5 }
        finish {
            diffuse 0
            emission color Wh
        }
    }
    scale <1, 1, 1>/5
    translate <-1.9, -2.2, 0.0>
}

// ===== 1 ======= 2 ======= 3 ======= 4 ======= 5 ======= 6 ======= 7
