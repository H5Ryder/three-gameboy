import "./style.css";
import ReactDOM from "react-dom/client";
import { Canvas } from "@react-three/fiber";
import Experience from "./Experience.jsx";
import {
  ToneMapping,
  EffectComposer,
  Bloom,
} from "@react-three/postprocessing";
import { ToneMappingMode } from "postprocessing";

const root = ReactDOM.createRoot(document.querySelector("#root"));

root.render(
  <Canvas
    camera={{
      fov: 45,
      near: 0.1,
      far: 200,
      position: [1, 2, 20],
    }}
  >
    <Experience />
    <EffectComposer>
      <Bloom mipmapBlur intensity={1.0} luminanceThreshold={1.0} />
    </EffectComposer>
  </Canvas>
);