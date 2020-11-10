Shader "Projector/UV Projection" {
    Properties
    {
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
    
            struct v2f
            {
                float4 uv : TEXCOORD0;
                float4 pos : SV_POSITION;
            };
    
            float4x4 unity_Projector;
            float4x4 unity_ProjectorClip;
    
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
                o.uv = float4(x, y, x, y);

                return o;
            }
        
            fixed4 frag(v2f i) : SV_Target
            {
                float4 col = float4(i.uv.xy, 0, 1);
                
                return col;
            }
            ENDCG
        }
    }
}