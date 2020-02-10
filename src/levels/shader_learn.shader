shader_type canvas_item;

uniform float PI = 3.1415926535;

float circleShape(vec2 position, float radius){
	return step(radius, length(position-vec2(0.5)));
}

float heartShape(vec2 position){
float a = atan(position.y,position.x)/PI; 
float rad = length(position);

return smoothstep (-0.01, 0.01, a-rad); // / when p1, smoothstep returns 1; when p2, smoothstep returns 0;
	/*
	float f = 1.0;
	float m = radians(360.);
	float ratex = 5.*(16./f*(sin(m)*sin(m)*sin(m)));
	float ratey = 5.*(float((13./f) * cos(m) - 5./f*cos(2.*m)-2./f*cos(3.*m)-1./f*cos(4.*m)));
	float x = (16./f*(sin(r)*sin(r)*sin(r)))/ratex;
	float y = (float((13./f) * cos(r) - 5./f*cos(2.*r)-2./f*cos(3.*r)-1./f*cos(4.*r)))/ratey;
	
	if(position.x == x || position.y == y){
		return 1.0;
	}else{
		return 0.0;
	}
	*/
}
float rectShape(vec2 position, vec2 scale){
	scale = vec2(0.5) - scale * 0.5;
	vec2 shaper = vec2(step(scale.x, position.x), step(scale.y,position.y));
	shaper *= vec2(step(scale.x,1.0-position.x),step(scale.y, 1.0-position.y));
	return shaper.x * shaper.y;
}

float squareShape(vec2 position, float side){
	float left = step(0.5-side,position.x);	
	float right = step(0.5+side,position.x);	
	float up = step(0.5-side,position.y);	
	float down = step(0.5+side,position.y);	
	return ((2.0-((up-down)+(left-right)))-1.0)*-1.0;
}

float polygonShape(vec2 position, float radius, float sides){
	position = position * 2.0 - 1.0;
	float angle = atan(position.x,position.y);
	float slice = PI * 2.0 / sides;
	return step(radius,cos(floor(0.5+angle/slice)* slice - angle)* length(position));
}

float starShape(vec2 position, float radius, float sides){
	position = position * 2.0 - 1.0;
	float angle = atan(position.x,position.y);
	float slice = PI * 2.0 / sides;
	return step(radius,cos(floor(angle/slice)* slice - angle)* length(position));
}

void fragment()
{
	vec2 resolution = (1.0/SCREEN_PIXEL_SIZE);
	vec2 position = FRAGCOORD.xy/resolution ;
	// position.x = 2.0-position.x /(resolution.x/resolution.y)*10.; //* 2.0/resolution.x;-
	//position.y = position.y * 1.0/resolution.y;
	
	vec3 color = vec3(0.0);
	float modulate = 0.2 + 0.2* sin(TIME);
	// circle
	// float circle = circleShape(position,modulate);
	// color = vec3(circle);
	
	/*
	float rectagle = rectShape(position,vec2(modulate));
	color = vec3(rectagle);
	*/
	
	// float polygon = polygonShape(position,modulate,6.);
	// color = vec3(polygon);
	/*
	float square = squareShape(position,modulate);
	float squareb = squareShape(position,modulate-0.01);
	float squaresum = square;
	color = vec3(squaresum);
	if (squareb==1.0){
		color = vec3(0.0)
	}
	*/
	
	float heart = heartShape(position);
	color = vec3(heart);
	COLOR = vec4(color,1.0);
	
	// vec2 uv = FRAGCOORD.xy / (1.0/SCREEN_PIXEL_SIZE).xy;
	
	/*
    float scale = 5.0;
    float i = TIME*.5;
    vec4 o = vec4(0.0);
	
    uv-= scale*0.5;
    
    mat2 m = mat2(vec2(cos(uv.x-i),sin(sin(uv.x)+i)),vec2(cos(uv.y+i),cos(uv.y-i*.5)));
    uv = uv*m;
    
    float dist = length(uv);
    float a = atan(uv.y,uv.x);
    o.r = mod(dist,1.0);
    o.g = mod(a,0.5)*2.0;
    o.b = mod(uv.x*uv.y,1.0);
    o.rgb = (1.0-cos(o.rgb-0.5))*5.0;
	
	COLOR = vec4(o.r,o.g,o.b,a);
	//COLOR = o;
	*/
}


