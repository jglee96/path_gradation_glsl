#version 300 es

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;
out vec4 fragColor;
int arrLength = 64;
int gsLength = 3;

float sp[3];
vec3 sc[3];

bool pointInTriangle(vec2 p, vec2 p0, vec2 p1) {
    float A = 0.5 * ( -p0.y * p1.x + p0.x * p1.y);
    float sign = A < 0. ? -1. : 1.;
    float s = (- p0.y * p.x + p0.x * p.y) * sign;
    float t = (p0.x * p1.y - p0.y * p1.x + (p0.y - p1.y) * p.x + (p1.x - p0.x) * p.y) * sign;
    
    return s > 0. && t > 0. && (s + t) < 2. * A * sign;
}

float perpDistance(vec2 st, vec2 cpt, vec2 npt) {
    vec2 e;
    e.xy = normalize(npt - cpt).yx * vec2(-1.0, 1.0);
    vec2 pq = st - npt;
    return dot(e, pq) / length(e);
}

vec3 shape (vec2 st, vec2[64] vertices) {
    sp[0] = 0.2;
    sp[1] = 0.5;
    sp[2] = 0.8;
    sc[0] = vec3(0.7412, 0.1176, 0.3451);
    sc[1] = vec3(0.902, 0.8588, 0.0392);
    sc[2] = vec3(1.0, 0.0, 0.0);
    for (int i=0; i<arrLength; i++) {
        int cdx = i;
        int ndx = i + 1;
        if (i == arrLength-1) ndx = 0;

        vec2 cpt = vertices[cdx];
        vec2 npt = vertices[ndx];
        float maxDist = perpDistance(vec2(0., 0.), cpt, npt);

        if (pointInTriangle(st, cpt, npt)) {
            float ratio = (maxDist - perpDistance(st, cpt, npt)) / maxDist;
            float fp = sp[0];
            float ep = sp[gsLength - 1];
            vec3 fc = sc[0];
            vec3 ec = sc[gsLength - 1];
            if (ratio < fp) {
                return fc;
            } else if (ratio > ep) {
                return ec;
            } else {
                for (int j=0; j<gsLength-1; j++) {
                    if (sp[j] <= ratio && sp[j+1] >= ratio) {
                        return mix(sc[j], sc[j+1], (ratio - sp[j]) / (sp[j+1] - sp[j]));
                    }
                }
            }
        }
    }
    return vec3(1.);
}

void main() {
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    st = st * 2. - 1.;

    float rad = 0.5;
    vec2 loc = vec2(0.) + vec2(sin(u_time)*rad, cos(u_time)*rad);
    st += loc;

    // flatness 0.25
    vec2 vertices[64];
    vertices[0] = vec2(0, -0.5088);
    vertices[1] = vec2(0.0422, -0.6107);
    vertices[2] = vec2(0.0905, -0.6994);
    vertices[3] = vec2(0.144, -0.7752);
    vertices[4] = vec2(0.202, -0.8385);
    vertices[5] = vec2(0.2634, -0.8897);
    vertices[6] = vec2(0.3274, -0.9292);
    vertices[7] = vec2(0.3931, -0.9572);
    vertices[8] = vec2(0.4596, -0.9743);
    vertices[9] = vec2(0.5261, -0.9806);
    vertices[10] = vec2(0.5917, -0.9767);
    vertices[11] = vec2(0.6554, -0.9628);
    vertices[12] = vec2(0.7164, -0.9394);
    vertices[13] = vec2(0.7738, -0.9067);
    vertices[14] = vec2(0.8266, -0.8652);
    vertices[15] = vec2(0.8742, -0.8152);
    vertices[16] = vec2(0.9154, -0.757);
    vertices[17] = vec2(0.9495, -0.6912);
    vertices[18] = vec2(0.9756, -0.6179);
    vertices[19] = vec2(0.9927, -0.5376);
    vertices[20] = vec2(1, -0.4506);
    vertices[21] = vec2(0.9966, -0.3574);
    vertices[22] = vec2(0.9817, -0.2582);
    vertices[23] = vec2(0.9542, -0.1534);
    vertices[24] = vec2(0.9135, -0.0434);
    vertices[25] = vec2(0.8584, 0.0715);
    vertices[26] = vec2(0.7883, 0.1908);
    vertices[27] = vec2(0.7021, 0.3143);
    vertices[28] = vec2(0.599, 0.4415);
    vertices[29] = vec2(0.4782, 0.5721);
    vertices[30] = vec2(0.3386, 0.7057);
    vertices[31] = vec2(0.1795, 0.842);
    vertices[32] = vec2(0, 0.9806);
    vertices[33] = vec2(-0.1795, 0.842);
    vertices[34] = vec2(-0.3386, 0.7057);
    vertices[35] = vec2(-0.4781, 0.5721);
    vertices[36] = vec2(-0.599, 0.4415);
    vertices[37] = vec2(-0.7021, 0.3143);
    vertices[38] = vec2(-0.7882, 0.1908);
    vertices[39] = vec2(-0.8584, 0.0715);
    vertices[40] = vec2(-0.9134, -0.0434);
    vertices[41] = vec2(-0.9542, -0.1534);
    vertices[42] = vec2(-0.9816, -0.2581);
    vertices[43] = vec2(-0.9966, -0.3574);
    vertices[44] = vec2(-1, -0.4506);
    vertices[45] = vec2(-0.9927, -0.5376);
    vertices[46] = vec2(-0.9755, -0.6179);
    vertices[47] = vec2(-0.9495, -0.6912);
    vertices[48] = vec2(-0.9154, -0.757);
    vertices[49] = vec2(-0.8741, -0.8152);
    vertices[50] = vec2(-0.8266, -0.8652);
    vertices[51] = vec2(-0.7737, -0.9067);
    vertices[52] = vec2(-0.7164, -0.9394);
    vertices[53] = vec2(-0.6554, -0.9628);
    vertices[54] = vec2(-0.5917, -0.9767);
    vertices[55] = vec2(-0.5261, -0.9806);
    vertices[56] = vec2(-0.4596, -0.9743);
    vertices[57] = vec2(-0.3931, -0.9572);
    vertices[58] = vec2(-0.3274, -0.9292);
    vertices[59] = vec2(-0.2634, -0.8897);
    vertices[60] = vec2(-0.2019, -0.8385);
    vertices[61] = vec2(-0.144, -0.7752);
    vertices[62] = vec2(-0.0905, -0.6994);
    vertices[63] = vec2(-0.0422, -0.6107);

// flatness 1.
    // vec2 vertices[38];
    // vertices[0] = vec2(0, -0.5108);
    // vertices[1] = vec2(0.0905, -0.7013);
    // vertices[2] = vec2(0.2019, -0.8405);
    // vertices[3] = vec2(0.3274, -0.9312);
    // vertices[4] = vec2(0.4596, -0.9762);
    // vertices[5] = vec2(0.5917, -0.9787);
    // vertices[6] = vec2(0.7164, -0.9413);
    // vertices[7] = vec2(0.8266, -0.8672);
    // vertices[8] = vec2(0.9154, -0.759);
    // vertices[9] = vec2(0.9755, -0.6199);
    // vertices[10] = vec2(1, -0.4526);
    // vertices[11] = vec2(0.9817, -0.2601);
    // vertices[12] = vec2(0.9134, -0.0453);
    // vertices[13] = vec2(0.7883, 0.1888);
    // vertices[14] = vec2(0.7021, 0.3123);
    // vertices[15] = vec2(0.599, 0.4395);
    // vertices[16] = vec2(0.4782, 0.5701);
    // vertices[17] = vec2(0.3386, 0.7037);
    // vertices[18] = vec2(0.1795, 0.84);
    // vertices[19] = vec2(0, 0.9787);
    // vertices[20] = vec2(-0.1795, 0.84);
    // vertices[21] = vec2(-0.3386, 0.7037);
    // vertices[22] = vec2(-0.4782, 0.5701);
    // vertices[23] = vec2(-0.599, 0.4395);
    // vertices[24] = vec2(-0.7021, 0.3123);
    // vertices[25] = vec2(-0.7883, 0.1888);
    // vertices[26] = vec2(-0.9134, -0.0453);
    // vertices[27] = vec2(-0.9816, -0.2601);
    // vertices[28] = vec2(-1, -0.4526);
    // vertices[29] = vec2(-0.9755, -0.6199);
    // vertices[30] = vec2(-0.9154, -0.759);
    // vertices[31] = vec2(-0.8266, -0.8672);
    // vertices[32] = vec2(-0.7163, -0.9413);
    // vertices[33] = vec2(-0.5916, -0.9787);
    // vertices[34] = vec2(-0.4596, -0.9762);
    // vertices[35] = vec2(-0.3273, -0.9312);
    // vertices[36] = vec2(-0.2019, -0.8405);
    // vertices[37] = vec2(-0.0904, -0.7013);

    vec3 color = shape(st, vertices);

    fragColor = vec4(color, 1.0);
}