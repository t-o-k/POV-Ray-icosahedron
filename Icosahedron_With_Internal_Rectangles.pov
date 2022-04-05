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
            QuadrilateralEdges(pXY0, pXY1, pXY2, pXY3, RadiusCyl)
            QuadrilateralVertices(pXY0, pXY1, pXY2, pXY3, RadiusSph)
            pigment { color 3*Rd }
        }
        union {
            QuadrilateralVertices(pYZ0, pYZ1, pYZ2, pYZ3, RadiusSph)
            QuadrilateralEdges(pYZ0, pYZ1, pYZ2, pYZ3, RadiusCyl)
            pigment { color 3*Gn }
        }
        union {
            QuadrilateralVertices(pZX0, pZX1, pZX2, pZX3, RadiusSph)
            QuadrilateralEdges(pZX0, pZX1, pZX2, pZX3, RadiusCyl)
            pigment { color 3*Bu }
        }
        union {
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

#declare RegularIcosahedronMesh =
    mesh {
        triangle { pXY0, pZX0, pYZ0 }
        triangle { pXY0, pYZ3, pZX1 }
        triangle { pYZ0, pZX3, pXY1 }
        triangle { pZX0, pXY3, pYZ1 }

        triangle { pXY2, pYZ2, pZX2 }
        triangle { pXY2, pZX3, pYZ1 }
        triangle { pYZ2, pXY3, pZX1 }
        triangle { pZX2, pYZ3, pXY1 }

        triangle { pXY0, pXY1, pYZ3 }
        triangle { pXY1, pXY0, pYZ0 }
        triangle { pXY2, pXY3, pYZ2 }
        triangle { pXY3, pXY2, pYZ1 }

        triangle { pYZ0, pYZ1, pZX3 }
        triangle { pYZ1, pYZ0, pZX0 }
        triangle { pYZ2, pYZ3, pZX2 }
        triangle { pYZ3, pYZ2, pZX1 }

        triangle { pZX0, pZX1, pXY3 }
        triangle { pZX1, pZX0, pXY0 }
        triangle { pZX2, pZX3, pXY2 }
        triangle { pZX3, pZX2, pXY1 }

        pigment { color rgbt <1, 1, 1, Tr> }
    }

#declare RegularIcosahedron =
    union {
        object { RegularIcosahedronFrame }
        object { RegularIcosahedronMesh }
    }

object {
    RegularIcosahedron
    ReorientTransform(x + y + z, -z)
    rotate -10*z
}

// ===== 1 ======= 2 ======= 3 ======= 4 ======= 5 ======= 6 ======= 7

background { color (3*Bu + 2*Gn)/30 }

light_source {
    100*<-2, 2, 1>
    color Wh
    shadowless
}

light_source {
    100*<-1, -1, -3>
    color Wh/5
    shadowless
}

#declare AR = image_width/image_height;

camera {
    // orthographic
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
    pigment { color 0.3*Wh }
        finish {
            diffuse 0
            emission color Wh
        }
    }
    scale <1, 1, 1>/5
    translate <-1.9, -2.2, 0.0>
}

// ===== 1 ======= 2 ======= 3 ======= 4 ======= 5 ======= 6 ======= 7
