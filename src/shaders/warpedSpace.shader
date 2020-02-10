shader_type canvas_item;
//https://www.shadertoy.com/view/Xl3yD2
uniform float tau = 6.28318530718;

float sin01(float x) {
	return (sin(x*tau)+1.)/2.;
}
float cos01(float x) {
	return (cos(x*tau)+1.)/2.;
}

// rand func from theartofcode (youtube channel)
vec2 rand01(vec2 p) {
	vec3 pp = vec3(p.x,p.y,1);
    vec3 a = fract(pp.xyz * vec3(123.5, 234.34, 345.65));
    a += dot(a, a+34.45);
    
    return fract (vec2(a.x * a.y, a.y * a.z));
}

float distFn(float t, vec2 from, vec2 to) {
	float x = length (from - to);
    return pow (x, cos01(t/10.)*4.+1.2);
}

float voronoi(vec2 uv, float t, float seed, float size) {
    
    float minDist = 100.;
    
    float gridSize = size;
    
    vec2 cellUv = fract(uv * gridSize) - 0.5;
    vec2 cellCoord = floor(uv * gridSize);
    
    for (float x = -1.; x <= 1.; ++ x) {
        for (float y = -1.; y <= 1.; ++ y) {
            vec2 cellOffset = vec2(x,y);
            
            // Random 0-1 for each cell
            vec2 rand01Cell = rand01(cellOffset + cellCoord + seed);
			
            // Get position of point in cell
            vec2 point = cellOffset + sin(rand01Cell * (t+10.)) * .5;
            
			// Get distance between pixel and point
            float dist = distFn(t, cellUv, point);
    		minDist = min(minDist, dist);
        }
    }
    
    return minDist;
}

void fragment()
{
    // Center coordinates at 0
    vec2 uv = (2.*FRAGCOORD.xy - (1.0 / SCREEN_PIXEL_SIZE).xy)/(1.0 / SCREEN_PIXEL_SIZE).y;
    
    float t = TIME * .2; //.7
    
	// Distort uv coordinates
    float amplitude = .15; //.05
    float turbulence = 0.4; // 0.8
    uv.xy += sin01(uv.x*turbulence + t/3.) * amplitude;
    uv.xy -= sin01(uv.y*turbulence + t/3.) * amplitude;
    
	// Apply layers of voronoi
    float v1 = voronoi(uv, t, 0.5, 2.5) * 3.9; // 1.
    float v2 = voronoi(uv, t * 4., 0., 4.) * 4.4; // .4
    float v3 = voronoi(uv, t * 8., 0.3, 10.) * .0; // red 0.15
    float v4 = voronoi(uv, t * 8., 0.2, 2.) * .0; // .08
    
    // Color each of the layers
    vec3 col1 = v1 * vec3(.45, 0., 1.);
    vec3 col2 = v2 * vec3(.0, .5, .8);
    vec3 col3 = v3 * vec3(1., .2, 0.);
    vec3 col4 = v4 * vec3(1., 1., 0.);
    
    // Flashes
    int timeIndex = int(fract(t) * 0.); // 0 to 9
    vec3 background = vec3(0.);
    float bright = 0.1;//0.4
    if (timeIndex == 7 || timeIndex == 9) {
        vec3 backCol = vec3(.1, .0, .2);
        background = (1.-v1-v2-v3-v4) * backCol;
        bright = 1.4;
    }
    
    // Sum up the colors
    vec3 colSum = col1 + col2 + col3 + col4 + background;
    
    // Adjust brightness
    colSum *= bright;
    
    // Output to screen
    COLOR = vec4(colSum,1.0);
}