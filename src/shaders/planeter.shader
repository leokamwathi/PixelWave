shader_type canvas_item;

uniform vec2 ONE = vec2(1.0, 0.0);
uniform vec2 EPS = vec2(1e-3, 0.0);
//uniform vec2 iMouse;
uniform vec2 iMouse = vec2(400,400);

uniform float pi = 3.1415926;
//varying float time;

float N(vec2 p)
{
   p = mod(p, 4.0);
   return fract(sin(p.x * 41784.0) + sin(p.y * 32424.0));
}

float smN2(vec2 p)
{
	vec2 fp = floor(p);
	vec2 pf = smoothstep(0.0, 1.0, fract(p));
	return mix( mix(N(fp), N(fp + ONE), pf.x), 
			   mix(N(fp + ONE.yx), N(fp + ONE.xx), pf.x), pf.y);
}


float fbm2(vec2 p)
{
	float f = 0.0, x;
	for(int i = 1; i <= 9; ++i)
	{
		x = exp2(float(i));
		f += smN2(p * x) / x;
	}
	return f;
}

// Scalar field for the surface undulations.
float field(vec2 p, float time)
{
	p *= 0.5;
	return mix(smN2(p * 4.0), smN2(p * 5.0), 0.5 + 0.5 * cos(time * 0.1));
}

// Vector field extracted from the scalar field.
vec2 flow(vec2 p,float time)
{
	float f0 = field(p,time);
	float f1 = field(p + EPS.xy,time);
	float f2 = field(p + EPS.yx,time);
	return normalize(vec2(f1 - f0, f2 - f0)).yx * vec2(-1, 1) * 0.01;
}

// Maps a scalar value to a range of interpolated colours.
vec3 col(float x)
{
	x *= 60.0;
	return max(vec3(0.0), vec3(cos(x), cos(x * 1.2), cos(x * 1.7)));
}

// Returns the distance along the given ray to a sphere at the origin.
float trace(vec3 ro, vec3 rd)
{
	float ds = dot(rd, ro) * dot(rd, ro) - dot(ro, ro) + 1.0;
	
	if(ds < 0.0)
		return 1e3;
	else
		return -dot(rd, ro) - sqrt(ds);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord, in vec2 iResolution, in float iTime, in sampler2D iChannel0 )
{
	float time = iTime;
	vec2 t = fragCoord.xy / iResolution.xy * 2.0 - vec2(1.0);
	t.x *= iResolution.x / iResolution.y;
	
	vec3 ro = vec3(0.0, 0.0, 3.5), rd = normalize(vec3(t, -3.0));
	
	float f = trace(ro, rd);

	if(f > 1e2)
	{
		// No intersection. Make a colourful background.
		float d = length(t);
		float a = 1.0 - smoothstep(0.9, 1.4, d);
		d *= 10.0;
		d -= iTime;
		fragColor.rgb = 0.6 * a * (vec3(0.5) + 0.5 * vec3(cos(d), cos(d*1.3), cos(d * 1.5)));
		fragColor.rgb *= texture(iChannel0, vec2(atan(t.y, t.x), d * 0.01)).rrr;
		return;
	}
	
	vec3 rp = ro + rd * f;
	vec2 uv = vec2(atan(rp.z, rp.x) / pi * 2.0, acos(rp.y) / pi * 2.0 - 1.0);
	vec3 n = normalize(rp);

	uv.x += iTime * 0.02 * 2.0 + iMouse.x / iResolution.x * 2.0;
	uv.y += iTime * 0.013 * 2.0 + iMouse.y / iResolution.y * 2.0;

	float wsum = 0.0;
	float csum = 0.0;
	
	// Perform line integral convolution.
	int count = 32;
	for(int i = 0; i < count; ++i)
	{
		float w = 1.0;
		csum += fbm2(uv * 8.0) * 0.5 * (0.5 + 0.5 * cos(float(i) / float(count) * 3.1415926 * 4.0 + time * 4.0)) * w;
		wsum += w;
		
		// Step the sampling point by the vector field.
		uv += flow(uv,iTime);
	}
	
	csum /= wsum;
	csum += texture(iChannel0, uv).r * 0.02;

	fragColor.rgb = col(mix(csum, 0.1, pow(abs(t.y) * 0.7, 2.0))) * mix(0.5, 1.0, abs(t.y));

	fragColor.rgb += 1.2 * vec3(0.7, 0.3, 1.0) * pow(1.0 - normalize(n).z, 2.0) * 0.5;
	fragColor.rgb += 1.5 * vec3(1.0) * pow(1.0 - normalize(n).z, 8.0) * 0.5;
	
	fragColor.rgb *= 1.6;
}

void fragmenter(){
	//vec2 iResolution=1./TEXTURE_PIXEL_SIZE;
	//mainImage(FRAGCOORD,COLOR,iResolution,TIME,TEXTURE);
	
	}
	
void fragment(){
	vec2 iResolution=1./TEXTURE_PIXEL_SIZE;
	//float time = TIME;
	//vec4 fragCoord = FRAGCOORD;
	
	
	vec2 t = FRAGCOORD.xy / iResolution.xy * 2.0 - vec2(1.0);
	t.x *= iResolution.x / iResolution.y;
	
	vec3 ro = vec3(0.0, 0.0, 3.5), rd = normalize(vec3(t, -3.0));
	
	float f = trace(ro, rd);

	if(f > 1e2)
	{
		// No intersection. Make a colourful background.
		float d = length(t);
		float a = 1.0 - smoothstep(0.9, 1.4, d);
		d *= 10.0;
		d -= TIME;
		COLOR.rgb = 0.6 * a * (vec3(0.5) + 0.5 * vec3(cos(d), cos(d*1.3), cos(d * 1.5)));
		COLOR.rgb *= texture(TEXTURE, vec2(atan(t.y, t.x), d * 0.01)).rrr;
		return;
	}
	
	vec3 rp = ro + rd * f;
	vec2 uv = vec2(atan(rp.z, rp.x) / pi * 2.0, acos(rp.y) / pi * 2.0 - 1.0);
	vec3 n = normalize(rp);

	uv.x += TIME * 0.02 * 2.0 + iMouse.x / iResolution.x * 2.0;
	uv.y += TIME * 0.013 * 2.0 + iMouse.y / iResolution.y * 2.0;

	float wsum = 0.0;
	float csum = 0.0;
	
	// Perform line integral convolution.
	int count = 32;
	for(int i = 0; i < count; ++i)
	{
		float w = 1.0;
		csum += fbm2(uv * 8.0) * 0.5 * (0.5 + 0.5 * cos(float(i) / float(count) * 3.1415926 * 4.0 + TIME * 4.0)) * w;
		wsum += w;
		
		// Step the sampling point by the vector field.
		uv += flow(uv,TIME);
	}
	
	csum /= wsum;
	csum += texture(TEXTURE, uv).r * 0.02; //0.02

	COLOR.rgb = col(mix(csum, 0.1, pow(abs(t.y) * 0.7, 2.0))) * mix(0.5, 1.0, abs(t.y));

	COLOR.rgb += 1.2 * vec3(0.7, 0.3, 1.0) * pow(1.0 - normalize(n).z, 2.0) * 0.5;
	COLOR.rgb += 1.5 * vec3(1.0) * pow(1.0 - normalize(n).z, 8.0) * 0.5;
	
	COLOR.rgb *= 1.6;
	
	}