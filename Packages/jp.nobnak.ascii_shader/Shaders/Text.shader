Shader "Unlit/Text" {
    Properties {
        _MainTex ("Main Texture", 2D) = "white" {}
        _Color ("Color", Color) = (1,1,1,1)
    }
    SubShader {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }
        Cull Off
        ZTest LEqual
        ZWrite Off
        Blend SrcAlpha OneMinusSrcAlpha

        Pass {
            HLSLPROGRAM
            #pragma target 5.0
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

            uint _Text_Length;
            StructuredBuffer<uint> _Text;

            v2f vert (appdata v) {
                float2 uv = v.uv * float2(_Text_Length, 1);

                v2f o;
                o.vertex = TransformObjectToHClip(float3(uv, 0));
                o.uv = uv;
                return o;
            }

            float4 frag (v2f i) : SV_Target {
                float4 cmain = tex2D(_MainTex, i.uv);

                float4 f = FontTexture_GetText(i.uv, _Text, _Text_Length);
                float4 c = cmain * _Color;
                c.a *= f.x;
                return c;
            }
            ENDHLSL
        }
    }
}
