Shader "Unlit/TextEffect" {
    Properties {
        _MainTex ("Main Texture", 2D) = "white" {}
        _Color ("Color", Color) = (1,1,1,1)

        _FontTex ("Font Texture", 2D) = "white" {}
    }
    SubShader {
        Cull Off
        ZTest Always

        Pass {
            HLSLPROGRAM
            #pragma target 5.0
            #pragma vertex vert
            #pragma fragment frag

            static const uint2 CODE = int2(48, 65);
            static const uint2 REPEAT = int2(10, 26);

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/jp.nobnak.ascii_shader/ShaderLibrary/FontTexture.hlslinc"

            struct appdata {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f {
                float2 uv : TEXCOORD0;
                float2 px : TEXCOORD1;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _Color;

            v2f vert (appdata v) {
                float2 uv = v.uv;

                v2f o;
                o.vertex = TransformObjectToHClip(float3(uv, 0));
                o.uv = uv;
                o.px = uv * _ScreenParams.xy;
                return o;
            }

            float4 frag (v2f i) : SV_Target {
                float4 cmain = tex2D(_MainTex, i.uv);

                float stride = 60;
                float size = 0.5 * stride;
                int2 code = i.px / stride;
                float2 offset_px = code * stride;

                float t = _Time.y;
                code += t * float2(20, 2);

                float4 f = 0;
                code %= REPEAT;
                for (uint j = 0; j < 2; j++) {
                    int ch = FontTexture_IndexOf(code[1 - j])[1-j];
                    f += FontTexture_GetChar(i.px, float4(offset_px, size, size), ch);
                    offset_px.x += 0.5 * size;
                }

                float4 c = cmain + f.x * _Color;
                return c;
            }
            ENDHLSL
        }
    }
}
