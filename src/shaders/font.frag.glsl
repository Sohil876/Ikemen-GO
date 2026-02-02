#if __VERSION__ >= 450
#define COMPAT_TEXTURE texture
#define COMPAT_FRAGCOLOR FragColor
layout(location = 0) out vec4 FragColor;
layout(location = 0) in vec2 fragTexCoord;

layout(push_constant, std430) uniform u {
	vec4 textColor;
};
layout(binding = 0) uniform sampler2D tex;
#else
	// FIX: Only use Modern syntax (in/out) if GLES 3.0+ (Version 300)
	#if __VERSION__ >= 130 || (defined(GL_ES) && __VERSION__ >= 300)
		#ifdef GL_ES
			precision highp float;
			precision highp int;
		#endif

		#define COMPAT_VARYING in
		#define COMPAT_TEXTURE texture
		#define COMPAT_FRAGCOLOR FragColor
		out vec4 FragColor;
	#else
		// --- LEGACY PATH (GLES 2.0 / GL 2.1) ---
		#define COMPAT_VARYING varying
		#define COMPAT_TEXTURE texture2D
		#define COMPAT_FRAGCOLOR gl_FragColor
		// [CRITICAL FIX] Inject Precision for Android GLES 2.0
		#ifdef GL_ES
			precision highp float;
			precision highp int;
		#endif
	#endif

	// These must be STANDALONE for RegisterUniforms to work in GLES
	uniform vec4 textColor;
	uniform sampler2D tex;
	COMPAT_VARYING vec2 fragTexCoord;
#endif


void main()
{
	vec4 texColor = COMPAT_TEXTURE(tex, fragTexCoord);
	vec4 sampled = vec4(1.0, 1.0, 1.0, texColor.r);
    COMPAT_FRAGCOLOR = min(textColor, vec4(1.0, 1.0, 1.0, 1.0)) * sampled;
}