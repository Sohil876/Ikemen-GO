#if __VERSION__ >= 450
layout(location = 0) in vec2 vert;
layout(location = 1) in vec2 vertTexCoord;
layout(push_constant, std430) uniform u {
layout(offset = 16) vec2 resolution;
};
layout(location = 0) out vec2 fragTexCoord;
#else
	// FIX: Consistent check for Modern GL vs Legacy GL
	#if __VERSION__ >= 130 || (defined(GL_ES) && __VERSION__ >= 300)
		#define COMPAT_VARYING out
		#define COMPAT_ATTRIBUTE in
	#else
		// --- LEGACY PATH (GLES 2.0) ---
		#define COMPAT_VARYING varying
		#define COMPAT_ATTRIBUTE attribute
		// [SAFETY] Enforce High Precision to match the Fragment Shader
		#ifdef GL_ES
			precision highp float;
			precision highp int;
		#endif
	#endif

	uniform vec2 resolution;

	COMPAT_ATTRIBUTE vec2 vert;
	COMPAT_ATTRIBUTE vec2 vertTexCoord;
	COMPAT_VARYING vec2 fragTexCoord;
#endif

void main() {
	fragTexCoord = vertTexCoord;

	// convert the rectangle from pixels to 0.0 to 1.0
	vec2 res = resolution;
	if(res.x < 1.0) res.x = 1.0;
	if(res.y < 1.0) res.y = 1.0;

	vec2 zeroToOne = vert / res;

	// convert from 0->1 to 0->2
	vec2 zeroToTwo = zeroToOne * 2.0;

	// convert from 0->2 to -1->+1 (clipspace)
	vec2 clipSpace = zeroToTwo - 1.0;

	gl_Position = vec4(clipSpace * vec2(1.0, -1.0), 0.0, 1.0);
}