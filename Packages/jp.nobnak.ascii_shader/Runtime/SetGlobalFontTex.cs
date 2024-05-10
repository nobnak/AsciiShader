using UnityEngine;

namespace AsciiShader {
    [ExecuteAlways]
    public class SetGlobalFontTex : MonoBehaviour {

        [SerializeField]
        protected Links links = new();

        #region unity
        void Update() {
            var fontTex = links.fontTex;
            if (fontTex != null)
                Shader.SetGlobalTexture(P_FontTex, fontTex);
        }
        #endregion

        #region declarations
        public static readonly int P_FontTex = Shader.PropertyToID("_FontTex");

        [System.Serializable]
        public class Links {
            public Texture fontTex;
        }
        #endregion
    }
}