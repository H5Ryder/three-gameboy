varying vec2 vUv;
uniform sampler2D uPictureTexture;
uniform float uRows;
uniform float uColumns;
uniform float uBarHeight;
uniform float uBrightness;
uniform float uTime;
uniform float uBarWidth;

vec2 curveRemapUV(vec2 uv) {
    // as we near the edge of our screen apply greater distortion using a cubic function
    uv = uv * 2.0 - 1.0;
    vec2 offset = abs(uv.yx) / vec2(15, 4);
    uv = uv + uv * offset * offset;
    uv = uv * 0.5 + 0.5;
    return uv;
}

void main() {

    // uGapX gives the % gap between the lights (3x lights 3x gaps)
    float uGapX = uBarWidth;


    // Cycles through 0.0 - 1.0 uColumns number of times (e.g. uColumns = 30.0 then we have 30 columns)
    float remainderX = mod(vUv.x * uColumns, 1.0);
    // Cycles through 0.0 - 1.0 uColumns/2 number of times (e.g. uColumns = 30.0 then we have 15 columns, why? So that for every other column, we can add a offset)
    float remainder2X = mod(vUv.x * uColumns * 0.5, 1.0);
    // Cycles through 0.0 - 1.0 uRows number of times, so we can set the number of light rows (e.g. uRows = 30.0 then 30 lights fit vertically)
    float remainderY = mod((vUv.y + step(0.5, remainder2X) * 0.05) * uRows, 1.0);

    //Either 0.0 or 1.0 (Binary) - Sets light color to 0.0 if we are on a gap (dark part of the screen were there are no pixels/lights)
    //uBarHeight sets the % height the lights take up (e.g. uBarHeight = 0.5 then 50% of each row is light and 50% is dark space)
    float verticalLightSwitch = step(uBarHeight, remainderY);

    // Calculates the width of the light bars   
    float lineWidth = (1.0 - 3.0 * uGapX)/3.0;

    //Calculates if the location on the plane would contain red,green or blue pixel or no pixel at all, returns either 0.0 or 1.0 (Binary)
    float redOn = (step(0.0, remainderX) - step(lineWidth, remainderX))*verticalLightSwitch;
    float greenOn = (step(lineWidth + uGapX, remainderX) - step(2.0*lineWidth + uGapX, remainderX))*verticalLightSwitch;
    float blueOn = (step(2.0*lineWidth + 2.0*uGapX, remainderX) - step(3.0*lineWidth + 2.0*uGapX, remainderX))*verticalLightSwitch;

    //TextureColor has the rgb values of the original image texture
    vec4 textureColor = texture2D(uPictureTexture, vUv);
    vec4 textureColorTop = texture2D(uPictureTexture, vec2(vUv.x, vUv.y - (1.0/uColumns)*(remainderY)));
    vec4 textureColorBottom = texture2D(uPictureTexture, vec2(vUv.x, vUv.y + (1.0/uColumns)*(1.0 - remainderY)));
    //textureColor = (textureColorTop + textureColorBottom)/2.0;

    // In the case the light bar isn't on allow a faint bit of color 
    vec4 offHue = vec4(0.1);
  
    vec4 intensity = step(1.0, textureColor*uBrightness)*textureColor*uBrightness + offHue;

    gl_FragColor = vec4(redOn*intensity.r, greenOn*intensity.g, blueOn*intensity.b, 1.0);

    //float redChannel = step(1.0, red*10.0);
    //gl_FragColor = vec4(redChannel, 0.0, 0.0, 1.0)* uBrightness ;
                                                                                                                                     
//     gl_FragColor = textureColor;

}