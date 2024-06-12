import { useTexture, OrbitControls, useGLTF } from "@react-three/drei";
import { Canvas, useLoader } from "react-three-fiber";
import { TextureLoader } from "three";
import { useControls } from "leva";


import Gameboy from "./components/Gameboy";

export default function Experience() {

    const {posX, posY, posZ, main,buttons_ab,dPad,buttons_selStart} = useControls('General',{
        posX: 
        {
            value: -1.97,
            min: -4,
            max: 4,
            step: 0.01
        },
        posY: 
        {
            value: -2.05,
            min: -4,
            max: 4,
            step: 0.01
        },
        posZ: 
        {
            value: 0.67,
            min: -4,
            max: 4,
            step: 0.01
        },
        main: "#f5f5f5",
        buttons_ab: "#e85497",
        dPad: "#5f5f5f",
        buttons_selStart: "#aaaaaa",

    })

    



    let colors = {main,buttons_ab,dPad,buttons_selStart}
    


  return (
    <>
      <color args={["#202020"]} attach="background" />
      <OrbitControls makeDefault />
      <directionalLight castShadow position={[1, 2, 3]} intensity={1.5} />
      <ambientLight intensity={0.5} />
      <axesHelper args={[2, 2, 2]} />
      <Gameboy {...{colors,posX,posY,posZ}} />
    </>
  );
}
