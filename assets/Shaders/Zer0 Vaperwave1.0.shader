// Shader by Zer0#9999
// Zer0 Vaporwave V1

Shader "!Zer0/Vaporwave V1 (kills particles)"
{
	Properties
	{
		_OffsetXRed("Offset X Red", Range( -1 , 1)) = 0
		_OffsetYRed("Offset Y Red", Range( -1 , 1)) = 0
		_OffsetXGreen("Offset X Green", Range( -1 , 1)) = 0
		_OffsetYGreen("Offset Y Green", Range( -1 , 1)) = 0
		_OffsetXBlue("Offset X Blue", Range( -1 , 1)) = 0
		_OffsetYBlue("Offset Y Blue", Range( -1 , 1)) = 0
		_Effect("Effect", Float) = 0
		[Toggle]_EnableGreen("Enable Green", Float) = 1
		[Toggle]_EnableBluie("Enable Bluie", Float) = 1
		[Toggle]_EnableRed("Enable Red", Float) = 1
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Pass
		{
			ColorMask 0
			ZTest Greater
			ZWrite On
		}

		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		ZWrite On
		ZTest Always
		Offset  10 , 1
		Blend SrcAlpha OneMinusSrcAlpha
		GrabPass{ }
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		struct Input
		{
			float4 screenPos;
		};

		uniform float _EnableRed;
		uniform sampler2D _GrabTexture;
		uniform float _OffsetXRed;
		uniform float _OffsetYRed;
		uniform float _Effect;
		uniform float _EnableGreen;
		uniform float _OffsetXGreen;
		uniform float _OffsetYGreen;
		uniform float _EnableBluie;
		uniform float _OffsetXBlue;
		uniform float _OffsetYBlue;


		inline float4 ASE_ComputeGrabScreenPos( float4 pos )
		{
			#if UNITY_UV_STARTS_AT_TOP
			float scale = -1.0;
			#else
			float scale = 1.0;
			#endif
			float4 o = pos;
			o.y = pos.w * 0.5f;
			o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
			return o;
		}


		inline fixed4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return fixed4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float4 appendResult192 = (float4(_OffsetXRed , _OffsetYRed , 0 , 0));
			float4 screenColor86 = tex2D( _GrabTexture, ( ase_grabScreenPosNorm + appendResult192 ).xy );
			float4 temp_cast_1 = (screenColor86.r).xxxx;
			float4 screenColor222 = tex2Dproj( _GrabTexture, UNITY_PROJ_COORD( ase_grabScreenPos ) );
			float4 appendResult223 = (float4(screenColor222.g , screenColor222.b , 0 , 0));
			float4 lerpResult208 = lerp( temp_cast_1 , appendResult223 , _Effect);
			float4 appendResult203 = (float4(_OffsetXGreen , _OffsetYGreen , 0 , 0));
			float4 screenColor175 = tex2D( _GrabTexture, ( ase_grabScreenPosNorm + appendResult203 ).xy );
			float4 temp_cast_4 = (screenColor175.g).xxxx;
			float4 appendResult224 = (float4(screenColor222.r , screenColor222.b , 0 , 0));
			float4 lerpResult209 = lerp( temp_cast_4 , appendResult224 , _Effect);
			float4 appendResult197 = (float4(_OffsetXBlue , _OffsetYBlue , 0 , 0));
			float4 screenColor164 = tex2D( _GrabTexture, ( ase_grabScreenPosNorm + appendResult197 ).xy );
			float4 temp_cast_7 = (screenColor164.b).xxxx;
			float4 appendResult225 = (float4(screenColor222.g , screenColor222.r , 0 , 0));
			float4 lerpResult210 = lerp( temp_cast_7 , appendResult225 , _Effect);
			float4 appendResult161 = (float4(lerp(float4( 0,0,0,0 ),lerpResult208,_EnableRed).x , lerp(float4( 0,0,0,0 ),lerpResult209,_EnableGreen).x , lerp(float4( 0,0,0,0 ),lerpResult210,_EnableBluie).xy));
			o.Emission = appendResult161.xyz;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}