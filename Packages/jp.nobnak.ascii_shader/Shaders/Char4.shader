Shader "Unlit/Char4" {
    Properties {
        _MainTex ("Main Texture", 2D) = "white" {}
        _Color ("Color", Vector) = (1,1,1,1)

        _Text ("Char", Vector) = (65,122,48,57)
    }
    SubShader {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }
        Cull Off
        ZTest LEqual
        ZWrite Off
        Blend SrcAlpha OneMinusSrcAlpha

        Pass {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/jp.nobnak.ascii_shader/ShaderLibrary/FontTexture.hlslinc"

            struct appdata {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _Color;
            uint4 _Text;

            v2f vert (appdata v) {
                v2f o;
                o.vertex = TransformObjectToHClip(v.vertex.xyz);
                o.uv = v.uv * float2(2, 1);
                return o;
            }

            float4 frag (v2f i) : SV_Target {
                float4 f = FontTexture_GetText4(i.uv, _Text);
                float4 cmain = tex2D(_MainTex, i.uv);
                float4 c = cmain * _Color;
                c.a *= f.x;
                return c;
            }
            ENDHLSL
        }
    }
}
