Shader "Unlit/MyFirstShader"
{
    Properties
    {
        _ColorA ("Color A", Color) = (1,1,1,1)
        _ColorB ("Color B", Color) = (1,1,1,1)
        _ColorStart ("Color Start", Range(0,1)) = 1
        _ColorEnd ("Color End", Range(0,1)) = 0
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

            #define TAU 6.28318530718
            
            float4 _ColorA;
            float4 _ColorB;
            float _ColorStart;
            float _ColorEnd;

            // automatically filled out by Unity
            struct MeshData // per-vertex mesh data
            {
                float4 vertex : POSITION; // local space vertex position
                float3 normals : NORMAL; // local space normal direction
                // float4 tangent : TANGENT; // tangent direction (xyz) tangent sign (w)
                // float4 color : COLOR; // vertec colors
                float2 uv0 : TEXCOORD0; // uv0 diffuse/normal map textures
                // float4 uv1 : TEXCOORD1; // uv1 coordinates lightmap coordinates
                // float4 uv2 : TEXCOORD2; // uv2 coordinates lightmap coordinates
                // float4 uv3 : TEXCOORD3; // uv3 coordinates lightmap coordinates
            };

            // data passed from the vertex shader to the fragment shader
            // this will interpolate/blend across the triangle!
            struct Interpolators
            {
                float4 vertex : SV_POSITION; // clip space position. Required minimum, others are optionals.
                float3 normal : TEXCOORD0; // other parameter follows the semantics TEXCOORDx.
                float2 uv : TEXCOORD1; // can be defined as anything to be used by fragment shader.
            };

            // First, MeshData goes to vertex shader
            // Vertex shader supplies data to fragment shader
            Interpolators vert (MeshData v)
            {
                Interpolators o; // data structure to be passed to the fragment shader
                o.vertex = UnityObjectToClipPos(v.vertex); // set clip space
                o.normal = UnityObjectToWorldNormal(v.normals); // convert to world normals
                o.uv = v.uv0; // passthrough
                return o;
            }

            float InverseLerp(float a, float b, float v)
            {
                return (v-a)/(b-a);
            }

            float4 frag (Interpolators i) : SV_Target
            {
                float t = cos(i.uv.x * TAU * 2) * 0.5 + 0.5;

                return t;
                
                float4 outColor = lerp(_ColorA, _ColorB, t);
                
                return outColor;
            }
            ENDCG
        }
    }
}
