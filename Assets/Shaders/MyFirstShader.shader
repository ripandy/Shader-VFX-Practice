Shader "Unlit/MyFirstShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _Scale ("Scale", Float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"

            float4 _Color;
            float _Scale;
            
            struct MeshData
            {
                float4 vertex : POSITION;
                float3 normals : NORMAL;
                // float4 color : COLOR;
                // float4 tangent : TANGENT;
                float2 uv0 : TEXCOORD0;
                // float2 uv1 : TEXCOORD1;
            };

            struct Interpolators
            {
                float4 vertex : SV_POSITION;
                float3 normal : TEXCOORD0;
                float2 uv : TEXCOORD1;
            };

            Interpolators vert (MeshData v)
            {
                Interpolators o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normals); // convert to world normals
                o.uv = v.uv0 * _Scale; // multiply by scale
                return o;
            }

            float4 frag (Interpolators i) : SV_Target
            {
                return float4(i.uv, 0, 1);
            }
            ENDCG
        }
    }
}
