Shader "Projector/Masked Projection" {
    Properties
    {
        [HDR] _Color("Main Color", Color) = (1,1,1,1)
        _Tex("Texture To Project", 2D) = "white" {}
        _Mask("Mask", 2D) = "white" {}
        [Toggle(UV2)] _UV2("Use Second UV Map?", Float) = 0
    }

    Subshader{
        Tags {"Queue" = "Transparent"}
        Pass {
            ZWrite Off
            Cull Off
            ColorMask RGBA
            Blend SrcAlpha OneMinusSrcAlpha
            Offset -1, -1
    
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag  
            #pragma shader_feature UV2
            #include "UnityCG.cginc"
    
            struct v2f {
                float4 uv : TEXCOORD0;
                float4 pos : SV_POSITION;
                float4 normal : NORMAL;
            };
    
            float4x4 unity_Projector;
            float4x4 unity_ProjectorClip;
            float4 _Color;
    
            v2f vert(appdata_full v)
            {
                v2f o;

                float x = v.texcoord.x;
                float y = v.texcoord.y;

                #if UV2
                x = v.texcoord2.x;
                y = v.texcoord2.y;
                #endif

                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = float4(x, y, 0, 0);

                return o;
            }
    
            sampler2D _Mask, _Tex;
    
            fixed4 frag(v2f i) : SV_Target
            {
                float4 col = tex2D(_Tex, i.uv.xy) * _Color * tex2D(_Mask, i.uv.xy).r;
                
                return col;
            }
            ENDCG
        }
    }
}