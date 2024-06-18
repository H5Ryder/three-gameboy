import { useTexture, OrbitControls, useGLTF, Environment,Stage } from "@react-three/drei";
import { Canvas, useLoader } from "react-three-fiber";
import { TextureLoader } from "three";
import { useControls } from "leva";
import {
  ToneMapping,
  EffectComposer,
  Bloom,
  Scanline,
} from "@react-three/postprocessing";
import { ToneMappingMode } from "postprocessing";

import Gameboy from "./components/Gameboy";

export default function Experience() {
  const {
    posX,
    posY,
    posZ,
    main,
    buttons_ab,
    dPad,
    buttons_selStart,
    luminanceThreshold,
  } = useControls("General", {
    posX: {
      value: -1.97,
      min: -4,
      max: 4,
      step: 0.01,
    },
    posY: {
      value: -2.05,
      min: -4,
      max: 4,
      step: 0.01,
    },
    posZ: {
      value: 0.67,
      min: -4,
      max: 4,
      step: 0.01,
    },
    luminanceThreshold: {
      value: 3.61,
      min: -4,
      max: 10,
      step: 0.01,
    },
    main: "#f5f5f5",
    buttons_ab: "#e85497",
    dPad: "#5f5f5f",
    buttons_selStart: "#aaaaaa",
  });

  let colors = { main, buttons_ab, dPad, buttons_selStart };

  return (
    <>
      <EffectComposer>
        <Bloom mipmapBlur intensity={10.0} luminanceThreshold={luminanceThreshold} />
        <ToneMapping mode={ToneMappingMode.ACES_FILMIC} />
      </EffectComposer>

      <color args={["#fffff"]} attach="background" />

      <OrbitControls makeDefault />
      

      <Gameboy {...{ colors, posX, posY, posZ }} />
  
     

    </>
  );
}
