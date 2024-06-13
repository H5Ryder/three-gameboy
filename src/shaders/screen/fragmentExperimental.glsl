varying vec2 vUv;
uniform sampler2D uPictureTexture;
uniform float uRows;
uniform float uColumns;
uniform float uBarHeight;
uniform float uBrightness;
uniform float uTime;
uniform float uBarWidth;
uniform float uThreshold;


void main() {

    // uGapX gives the % gap between the lights (3x lights 3x gaps)
    float uGapX = uBarWidth;
    // ledWidth is one "square" of red,green,blue bars and the surround black space that makes a single unit of "led"
    float ledWidth = 1.0/uColumns; 
    // ledHeight is the height of the bars within the repeating "square" (doesn't include black space surrounding)
    float ledHeight = (1.0/uRows)*uBarHeight;

    /**
    * Glitch
    **/
    float gapTime = 2.0; //Time between flicker
    float glitchTime = 2.0; //Time when flicker animation occurs
    float totalTime = gapTime + glitchTime;
    float glitchHeight = ledHeight*100.0;
    

    float remainderTime = mod(uTime,  totalTime); // Returns value from 0.0 to totalTime, returns the time in the animation the time is at
    float glitchOn = step(gapTime, remainderTime); // Bool (0 or 1) if the animation is active
    float glitchRow = ((remainderTime - gapTime)/glitchTime)*glitchOn; // Gives what % (decimal) of the way through the glitchTime we are
    float glitchRowMatch = (step(glitchRow, vUv.y) - step(glitchRow + glitchHeight , vUv.y))*cos((((glitchRow+glitchHeight*0.5)-vUv.y)/glitchHeight)*1.57)*glitchOn; // Returns bool depending if this pixel is on the correct row
    float glitchIntensity = glitchRowMatch*10.0;
    float glitchOffset = glitchRowMatch*0.05;
    


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
   
    // In the case the light bar isn't on allow a faint bit of color 
    vec4 offHue = vec4(0.008);

     //TextureColor has the rgb values of the original image texture
    vec2 averagevUv = vec2((vUv.x - glitchOffset)+ (0.5 - remainderX)*ledWidth, vUv.y + (0.5 - remainderY)*ledHeight);
    vec4 textureColor = texture2D(uPictureTexture, averagevUv);

    vec4 intensity = step(uThreshold, textureColor*uBrightness)*textureColor*(uBrightness + glitchIntensity) + offHue;
    gl_FragColor = vec4(redOn*intensity.r, greenOn*intensity.g, blueOn*intensity.b, 1.0);

}