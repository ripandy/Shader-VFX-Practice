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
                float3 normals : NORMAL;
                // float4 color : COLOR;
                // float4 tangent : TANGENT;
                float2 uv0 : TEXCOORD0; // uv channels coordinate
                // float2 uv1 : TEXCOORD1;
            };

            struct Interpolators //was v2f
            {
                float4 vertex : SV_POSITION; // clip space position
                float3 normal : TEXCOORD0; // memo: normal map variable. TEXCOORD0 doesn't always maps to uv channel, just a data container. in this case it will contains MeshData's normals.
            };

            Interpolators vert (MeshData v)
            {
                Interpolators o;
                o.vertex = UnityObjectToClipPos(v.vertex); // local space -> clip space
                o.normal = v.normals; // just pass through
                return o;
            }

            float4 frag (Interpolators i) : SV_Target
            {
                // output color from normal directions.
                // memo : normal is float3, so return a float4
                return float4(i.normal, 1);
            }
            ENDCG
        }
    }
}
