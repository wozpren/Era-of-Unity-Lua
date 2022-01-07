Shader "lcl/shader2D/outline"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Width("_Width",Range(0,10)) = 1
        _BloomColor("_BloomColor",Color)=(1,1,1,1)
    }
    // ---------------------------【子着色器】---------------------------
    SubShader
    {
        // 渲染队列采用 透明
        Tags{
            "Queue" = "Transparent"
        }
        Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            //顶点着色器输入结构体 
			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float2 up_uv : TEXCOORD1;
				float2 down_uv : TEXCOORD2;
				float2 left_uv : TEXCOORD3;
				float2 right_uv : TEXCOORD4;
			};

            sampler2D _MainTex;
			float4 _MainTex_TexelSize;
			float _Width;
			float4 _BloomColor;

            v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				o.up_uv = o.uv + float2(0, 1)*_Width*_MainTex_TexelSize.xy;
				o.down_uv = o.uv + float2(0, -1)*_Width*_MainTex_TexelSize.xy;
				o.left_uv = o.uv + float2(-1,0)*_Width*_MainTex_TexelSize.xy;
				o.right_uv = o.uv + float2(1, 0)*_Width*_MainTex_TexelSize.xy;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				float w = tex2D(_MainTex, i.up_uv).a * tex2D(_MainTex, i.down_uv).a *tex2D(_MainTex, i.left_uv).a *tex2D(_MainTex, i.right_uv).a;
				col.rgb = lerp(_BloomColor.rgb, col.rgb, w);
				return col;
			}

            ENDCG
        }
    }
}