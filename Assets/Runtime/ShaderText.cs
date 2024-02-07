using Gist2.Adapter;
using System.Collections;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using Unity.Mathematics;
using Unity.VisualScripting;
using UnityEngine;

namespace AsciiShader {

    [ExecuteAlways]
    public class ShaderText : MonoBehaviour {

        [SerializeField]
        protected Tuner tuner = new();

        protected GraphicsList<uint> textBuffer;

        protected Renderer rend;
        protected MaterialPropertyBlock block;

        #region unity
        void OnEnable() {
            rend = GetComponent<Renderer>();

            block = new();

            textBuffer = new(size => {
                var buf = new GraphicsBuffer(
                    GraphicsBuffer.Target.Structured,
                    size,
                    Marshal.SizeOf<uint>());
                return buf;
            });
        }
        void OnDisable() {
            if (textBuffer != null) {
                textBuffer.Dispose();
                textBuffer = null;
            }
        }
        void Update() {
            textBuffer.Clear();
            for (var i = 0; i < tuner.text.Length; i++)
                textBuffer.Add(tuner.text[i]);

            var rect = new float4(0f, 0f, 1f, 1f);

            rend.GetPropertyBlock(block);
            block.SetInt(P_Text_Length, textBuffer.Count);
            block.SetBuffer(P_Text_Buffer, textBuffer);
            block.SetVector(P_FirstChar_Rect, rect);
            rend.SetPropertyBlock(block);
        }
        #endregion

        #region declarations
        public static readonly int P_Text_Length = Shader.PropertyToID("_Text_Length");
        public static readonly int P_Text_Buffer = Shader.PropertyToID("_Text");
        public static readonly int P_FirstChar_Rect = Shader.PropertyToID("_FirstChar_Rect");

        [System.Serializable]
        public class Tuner {
            public string text = "";
        }
        #endregion
    }
}
