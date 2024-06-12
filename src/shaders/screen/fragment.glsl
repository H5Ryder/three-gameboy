varying vec2 vUv;
uniform sampler2D uPictureTexture;
uniform float uRows;
uniform float uColumns;
uniform float uOffset;
uniform float uTime;

vec2 curveRemapUV(vec2 uv) {
    // as we near the edge of our screen apply greater distortion using a cubic function
    uv = uv * 2.0 - 1.0;
    vec2 offset = abs(uv.yx) / vec2(15, 4);
    uv = uv + uv * offset * offset;
    uv = uv * 0.5 + 0.5;
    return uv;
}

void main() {

    //float lightIntensity = sin(vUv.x*1200.0);
    //vec3 black = vec3(0.0, 0.0, 0.0);
    //vec3 finalColor = mix(baseColor.rgb, black, lightIntensity);

    float remainderX = mod(vUv.x * uRows, 1.0);
    float remainder2X = mod(vUv.x * uRows * 0.5, 1.0);
    float remainderY = mod((vUv.y + step(0.5, remainder2X) * 0.05) * 30.0, 1.0);

    float strength = step(0.5, remainderY);

    float red = step(0.17, remainderX) - step(0.34, remainderX);
    float green = step(0.51, remainderX) - step(0.66, remainderX);
    float blue = step(0.83, remainderX) - step(1.0, remainderX);

    vec4 textureColor = texture2D(uPictureTexture, vUv);
    vec4 textureColorTop = texture2D(uPictureTexture, vec2(vUv.x, vUv.y - (1.0/30.0)*(remainderY)));
    vec4 textureColorBottom = texture2D(uPictureTexture, vec2(vUv.x, vUv.y + (1.0/30.0)*(1.0 - remainderY)));
    textureColor = (textureColorTop + textureColorBottom)/2.0;
//red * strength*textureColor.r
    gl_FragColor = vec4(red * strength * textureColor.r, green * strength * textureColor.g, blue * strength * textureColor.b, 1.0);

//     gl_FragColor = textureColor;

}