using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace AsciiShader {

    [ExecuteAlways]
    public class TextEffect : MonoBehaviour {

        [SerializeField]
        protected Links links = new();

        #region unity
        void OnRenderImage(RenderTexture source, RenderTexture destination) {
            var mat = links.material;

            if (mat == null) {
                Graphics.Blit(source, destination);
                return;
            }
            Graphics.Blit(source, destination, mat);
        }
        #endregion

        #region declarations
        [System.Serializable]
        public class Links {
            public Material material;
        }
        #endregion
    }
}
