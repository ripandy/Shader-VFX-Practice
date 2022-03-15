Shader "Unlit/MyFirstShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
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
            
            struct MeshData //was appdata. automatically filled out by unity.
            {
                float4 vertex : POSITION; // vertex position
                // float3 normals : NORMAL;
                // float4 color : COLOR;
                // float4 tangent : TANGENT;
                float2 uv0 : TEXCOORD0; // uv channels coordinate
                // float2 uv1 : TEXCOORD1;
            };

            struct Interpolators //was v2f
            {
                float4 vertex : SV_POSITION; // clip space position
                // float2 uv : TEXCOORD0; // not really a uv channel, just a data
            };

            Interpolators vert (MeshData v)
            {
                Interpolators o;
                o.vertex = UnityObjectToClipPos(v.vertex); // local space -> clip space
                return o;
            }

            float4 frag (Interpolators i) : SV_Target
            {
                // memo: swizzling
                // float4 myValue;
                // float2 otherValue = myValue.xy; 

                // output a variable _Color
                return _Color;
            }
            ENDCG
        }
    }
}
