#if __VERSION__ >= 450
    layout(location = 0) in vec2 VertCoord;
    layout(location = 0) out vec2 texcoord;
#else
    // FIX: Only use Modern syntax (in/out) if GLES 3.0+
    #if __VERSION__ >= 130 || (defined(GL_ES) && __VERSION__ >= 300)
        #define COMPAT_VARYING out
        #define COMPAT_ATTRIBUTE in
        #ifdef GL_ES
            precision highp float;
            precision highp int;
        #endif
    #else
        // --- LEGACY PATH (GLES 2.0) ---
        #define COMPAT_VARYING varying
        #define COMPAT_ATTRIBUTE attribute
        // [SAFETY] Enforce High Precision for Vertex Shader
        #ifdef GL_ES
            precision highp float;
            precision highp int;
        #endif
    #endif

    uniform vec2 TextureSize;
    COMPAT_ATTRIBUTE vec2 VertCoord;
    COMPAT_VARYING vec2 texcoord;
#endif

void main() {
    gl_Position = vec4(VertCoord, 0.0, 1.0);
    // Standard quad-to-UV mapping
    texcoord = (VertCoord + 1.0) / 2.0;
}
