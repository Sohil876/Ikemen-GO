#if __VERSION__ >= 450
    #define COMPAT_TEXTURE texture
    layout(push_constant, std430) uniform u {
        layout(offset = 8) float CurrentTime; // Note: removed redundant 'uniform' keyword inside block
    };
    layout(binding = 0) uniform sampler2D Texture;
    layout(location = 0) in vec2 texcoord;
    layout(location = 0) out vec4 FragColor;
#else
    // FIX: Only use Modern syntax (in/out) if GLES 3.0+
    #if __VERSION__ >= 130 || (defined(GL_ES) && __VERSION__ >= 300)
        #define COMPAT_VARYING in
        #define COMPAT_TEXTURE texture
        #ifdef GL_ES
            precision highp float;
            precision highp int;
        #endif
        out vec4 FragColor;
    #else
        // --- LEGACY PATH (GLES 2.0) ---
        #define COMPAT_VARYING varying
        #define FragColor gl_FragColor
        #define COMPAT_TEXTURE texture2D
        // [CRITICAL FIX] Add Precision for Android GLES 2.0
        #ifdef GL_ES
            precision highp float;
            precision highp int;
        #endif
    #endif

    uniform sampler2D Texture;
    uniform float CurrentTime; // Keep it here for compatibility even if unused in main
    COMPAT_VARYING vec2 texcoord;
#endif

void main(void) {
    FragColor = COMPAT_TEXTURE(Texture, texcoord);
}