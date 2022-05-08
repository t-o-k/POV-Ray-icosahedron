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

default {
    finish {
        diffuse 0
        emission color Wh
    }
}

// ===== 1 ======= 2 ======= 3 ======= 4 ======= 5 ======= 6 ======= 7
// Some macros from vectors.inc, which can be found here:
// https://github.com/t-o-k/Useful-POV-Ray-macros

#macro FunctionValue(Fn, v0)

    Fn(v0.x, v0.y, v0.z)

#end // macro FunctionValue


#macro VectorTransform(v0, Transform)

    FunctionValue(function { transform { Transform } }, v0)

#end // macro VectorTransform


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

#macro Mesh2(Vertices, UV_Coordinates, FaceIndices, PigmentUV)

    #local M =
        max(
            dimension_size(Vertices, 1),
            dimension_size(UV_Coordinates, 1)
        )
    ;
    #local N = dimension_size(FaceIndices, 1);

    mesh2 {
        vertex_vectors {
            M,
            #for (I, 0, M-1)
                Vertices[I]
            #end // for
        }
        uv_vectors {
            M,
            #for (I, 0, M-1)
                UV_Coordinates[I]
            #end // for
        }
        face_indices {
            N,
            #for (I, 0, N-1)
                <
                    FaceIndices[I][0],
                    FaceIndices[I][1],
                    FaceIndices[I][2]
                >
            #end // for
        }
        uv_mapping
        pigment { PigmentUV }
    }
    
#end // macro Mesh2


#macro CenterOfObject(Object)

    ((min_extent(Object) + max_extent(Object))/2)

#end // macro CenterOfObject


#macro CylinderTriangle(p0, p1, p2, R)

    union {
        sphere { p0, R }
        sphere { p1, R }
        sphere { p2, R }
        cylinder { p0, p1, R }
        cylinder { p1, p2, R }
        cylinder { p2, p0, R }
    }

#end // macro CylinderTriangle


#macro CylinderQuadrilateral(p0, p1, p2, p3, R)

    union {
        sphere{ p0, R }
        sphere{ p1, R }
        sphere{ p2, R }
        sphere{ p3, R }
        cylinder { p0, p1, R }
        cylinder { p1, p2, R }
        cylinder { p2, p3, R }
        cylinder { p3, p0, R }
    }

#end // macro CylinderQuadrilateral

// ===== 1 ======= 2 ======= 3 ======= 4 ======= 5 ======= 6 ======= 7
/*
    The Golden Ratio:
    B/A = A/(A + B) 
    B^2 + A*B = A^2
    B^2 + A*B - A^2 = 0
    B = (sqrt(5) - 1)/2*A
*/

#declare A = 1;
#declare B = (sqrt(5) - 1)/2*A;

#declare C = A/2;
#declare D = (A + B)/2;

// ZX-plane
#declare pY0 = <-D,  0, -C>;
#declare pY1 = <-D,  0, +C>;
#declare pY2 = <+D,  0, +C>;
#declare pY3 = <+D,  0, -C>;

// XY-plane
#declare pZ0 = <-C, -D,  0>;
#declare pZ1 = <+C, -D,  0>;
#declare pZ2 = <+C, +D,  0>;
#declare pZ3 = <-C, +D,  0>;

// YZ-plane
#declare pX0 = < 0, -C, -D>;
#declare pX1 = < 0, +C, -D>;
#declare pX2 = < 0, +C, +D>;
#declare pX3 = < 0, -C, +D>;

#declare PP =
    array[22] {
        pX1,  // 00
        pX1,  // 01
        pX1,  // 02
        pX1,  // 03
        pX1,  // 04

        pY3,  // 05
        pZ2,  // 06
        pZ3,  // 07
        pY0,  // 08
        pX0,  // 09
        pY3,  // 10

        pY2,  // 11
        pX2,  // 12
        pY1,  // 13
        pZ0,  // 14
        pZ1,  // 15
        pY2,  // 16

        pX3,  // 17
        pX3,  // 18
        pX3,  // 19
        pX3,  // 20
        pX3   // 21
    }
;

#declare Transform = ReorientTransform(PP[0], y)

#declare QQ = array[22];
#for (I, 0, 21)
    #declare QQ[I] = VectorTransform(PP[I], Transform);
#end // for

#declare CylR = 0.001;
#declare SphR = 0.008;

#declare Quadrilaterals = 
    union {
        object {
            CylinderQuadrilateral(QQ[ 8], QQ[13], QQ[11], QQ[ 5], CylR)
            // pigment { color Rd }
        }
        object {
            CylinderQuadrilateral(QQ[14], QQ[15], QQ[ 6], QQ[ 7], CylR)
            // pigment { color Gn }
        }
        object {
            CylinderQuadrilateral(QQ[ 9], QQ[ 0], QQ[12], QQ[17], CylR)
            // pigment { color Bu }                                   
        }
        pigment { color Bk }
    }

#declare Vertices = 
    union {
        union {
            sphere { QQ[ 8], SphR }
            sphere { QQ[13], SphR }
            sphere { QQ[11], SphR }
            sphere { QQ[ 5], SphR }
            pigment { color Rd }
        }
        union {
            sphere { QQ[14], SphR }
            sphere { QQ[15], SphR }
            sphere { QQ[ 6], SphR }
            sphere { QQ[ 7], SphR }
            pigment { color Gn }
        }
        union {
            sphere { QQ[ 9], SphR }
            sphere { QQ[ 0], SphR }
            sphere { QQ[12], SphR }
            sphere { QQ[17], SphR }
            pigment { color Bu }                                   
        }
    }

#declare Triangles = 
    union {
        CylinderTriangle(QQ[13], QQ[14], QQ[19], CylR)
        CylinderTriangle(QQ[ 5], QQ[ 0], QQ[ 6], CylR)
        CylinderTriangle(QQ[ 8], QQ[ 9], QQ[14], CylR)
        CylinderTriangle(QQ[11], QQ[ 6], QQ[12], CylR)
    
        CylinderTriangle(QQ[13], QQ[12], QQ[ 7], CylR)
        CylinderTriangle(QQ[10], QQ[15], QQ[ 9], CylR)
        CylinderTriangle(QQ[ 8], QQ[ 7], QQ[ 2], CylR)
        CylinderTriangle(QQ[16], QQ[21], QQ[15], CylR)
    
        pigment { color Bk }
    }

// ===== 1 ======= 2 ======= 3 ======= 4 ======= 5 ======= 6 ======= 7

#declare NoOfTriangles = 20;

#declare II =
    array[NoOfTriangles][3] {

        { 13,  14,  19 },
        {  5,   0,   6 },
        {  8,   9,  14 },
        { 11,   6,  12 },

        { 13,  12,   7 },
        { 10,  15,   9 },
        {  8,   7,   2 },
        { 16,  21,  15 },

        {  8,   3,   9 },
        { 13,  18,  12 },
        { 11,  12,  17 },
        { 10,   9,   4 },

        { 14,  13,   8 },
        { 15,  10,  16 },
        {  6,  11,   5 },
        {  7,   8,  13 },

        {  9,  15,  14 },
        {  1,   7,   6 },
        { 12,   6,   7 },
        { 20,  14,  15 }
    }
;

#declare W = 11;
#declare H = 3;

#declare UV =
    array[22] {
        < 1/W, 3/H>,  //  0
        < 3/W, 3/H>,  //  1
        < 5/W, 3/H>,  //  2
        < 7/W, 3/H>,  //  3
        < 9/W, 3/H>,  //  4
        < 0/W, 2/H>,  //  5
        < 2/W, 2/H>,  //  6
        < 4/W, 2/H>,  //  7
        < 6/W, 2/H>,  //  8
        < 8/W, 2/H>,  //  9
        <10/W, 2/H>,  // 10
        < 1/W, 1/H>,  // 11
        < 3/W, 1/H>,  // 12
        < 5/W, 1/H>,  // 13
        < 7/W, 1/H>,  // 14
        < 9/W, 1/H>,  // 15
        <11/W, 1/H>,  // 16
        < 2/W, 0/H>,  // 17
        < 4/W, 0/H>,  // 18
        < 6/W, 0/H>,  // 19
        < 8/W, 0/H>,  // 20
        <10/W, 0/H>   // 21
    }
;

#declare MapPigment = 
    pigment {
        image_map {
            png "IcosahedralWorldMap.png"
            map_type 0  // planar
            interpolate 2  // bilinear
            once
        }
    }

union {
    Mesh2(QQ, UV, II, MapPigment)
    object { Quadrilaterals }
    object { Triangles }
    object { Vertices }
    rotate -2/10*360*y
}

// ===== 1 ======= 2 ======= 3 ======= 4 ======= 5 ======= 6 ======= 7

background { color Bu/10 + Gn/20 }

camera {
    orthographic
    location -2.2*z
    look_at 0*z
}

// ===== 1 ======= 2 ======= 3 ======= 4 ======= 5 ======= 6 ======= 7

#declare URL = "https://github.com/t-o-k/POV-Ray-icosahedron"

#declare Attr = "Map data from OpenStreetMap 2020-01-03"

#declare Font = "timrom.ttf"
    
#declare TextURL = 
    text {
        ttf Font URL 1e-3, 0
        scale <1, 1, 1>/14
    }

#declare TextAttr = 
    text {
        ttf Font Attr 1e-3, 0
        scale <1, 1, 1>/14
    }

union {
    object {
        TextURL
        translate -CenterOfObject(TextURL)
        translate +<0.00, 1.02, 0.00>
    }
    object {
        TextAttr
        translate -CenterOfObject(TextAttr)
        translate -<0.00, 1.02, 0.00>
    }
    pigment { color Wh/2 }
}

// ===== 1 ======= 2 ======= 3 ======= 4 ======= 5 ======= 6 ======= 7
