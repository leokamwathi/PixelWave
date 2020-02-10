shader_type canvas_item;

mat2 rotatex(float a) { return mat2(vec2(cos(a),-sin(a)),vec2(sin(a),cos(a))); }
mat2 rotate(float a,float b) { return mat2(vec2(cos(a)/b,-sin(a)/b),vec2(sin(a)/b,cos(a)/b)); }
float noise(float x, sampler2D iChannel0 ) { return texture(iChannel0,vec2(x)).x;}

uniform float WEBN = 50;
void fragment() {
	vec2 p = (2.0*FRAGCOORD.xy-(1.0/SCREEN_PIXEL_SIZE).xy)/(1.0/SCREEN_PIXEL_SIZE).y;
	float l = 0.0;
	float mz = 0.0;
		
	for (float i=0.; i < WEBN; i+=1.0) {
		float fi = i/WEBN*acos(-1.)*0.1; //2.0
		float n = noise(fi,TEXTURE);
		
		float z = 1.0-mod(TIME/2.0+i/WEBN,0.5);	 //1.0
		vec2 o = p;
		o += vec2(sin(2.5*fi+TIME)*2.5,cos(2.0*fi+TIME))*z;
		o *= rotate(TIME*n*2.0,z*15.);
		l += (smoothstep(0.98,1.0,sin(mod(length(o),0.5)*30.0)))*(0.75-z);//0.25
		mz = min(mz,z);
	}
	float w1 = sin(TIME);
	float w2 = cos(TIME);
	vec3 col = mix(vec3(0.0,0.0,0.0),vec3(w2,w1,1.0),l*(0.85+mz)); //0.25
	COLOR = vec4(col,1.0);
}