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
        // SubShader tags
        Tags
        {
            // Memo: Set these to Transparent to allow transparency
            "RenderType"="Transparent" // tag to inform the render pipeline of what type this is
            "Queue"="Transparent" // changes the render order
        }

        Pass
        {
            // Which side to draw (from the monitor perspective).
            // Front = front side
            // Off = both side
            // Back = back side (default, when not defined)
            Cull Off
            
            // Whether to write to depth buffer
            // Off = will not hide anything behind the object
            // default will hide anything behind the object
            ZWrite Off
            
            // Whether to read depth buffer
            // LEqual = draws object in front of this shader (culled, default) -> Less Equal
            // GEqual = draw only when behind other object (culled) -> Greater Equal
            // Always = always draw
            ZTest LEqual
            
            // blending
            // syntax: Blend <Src> (+) <Dst>
            Blend One One // Additive
//            Blend DstColor Zero // Multiply
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"

            #define TAU 6.28318530718
            
            float4 _ColorA;
            float4 _ColorB;
            float _ColorStart;
            float _ColorEnd;

            struct MeshData
            {
                float4 vertex : POSITION;
                float3 normals : NORMAL;
                float2 uv0 : TEXCOORD0;
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
                o.normal = UnityObjectToWorldNormal(v.normals);
                o.uv = v.uv0;
                return o;
            }

            float InverseLerp(float a, float b, float v)
            {
                return (v-a)/(b-a);
            }

            float4 frag (Interpolators i) : SV_Target
            {
                // default time variable by Unity as a float4 defining different scales of time.
                // y is second, w is a second divided by 20.
                // _Time.xyzw; 
                
                float xOffset = cos(i.uv.x * TAU * 8) * 0.01;
                float t = cos((i.uv.y + xOffset - _Time.y * 0.1) * TAU * 5) * 0.5 + 0.5;
                t *= 1 - i.uv.y;

                float topBottomRemover = (abs(i.normal.y) < 0.999); // hack to remove top/bottom part (where uv are perpendicular)
                float waves = t *  topBottomRemover;
                float4 gradient = lerp(_ColorA, _ColorB, i.uv.y);

                return gradient * waves;
            }
            ENDCG
        }
    }
}
