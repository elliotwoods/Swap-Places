//@author: elliotwoods
//@help: lookup one in the other
//@tags: 
//@credits:

// --------------------------------------------------------------------------------------------------
// PARAMETERS:
// --------------------------------------------------------------------------------------------------

//transforms
float4x4 tW: WORLD;        //the models world matrix
float4x4 tV: VIEW;         //view matrix as set via Renderer (EX9)
float4x4 tP: PROJECTION;   //projection matrix as set via Renderer (EX9)
float4x4 tWVP: WORLDVIEWPROJECTION;

//material properties
float4 cAmb : COLOR <String uiname="Color";>  = {1, 1, 1, 1};
float Value = 1;

//texture
texture TexLookup <string uiname="Lookup";>;
sampler SampLookup = sampler_state    //sampler for doing the texture-lookup
{
    Texture   = (TexLookup);          //apply a texture to the sampler
    MipFilter = LINEAR;         //sampler states
    MinFilter = LINEAR;
    MagFilter = LINEAR;
};

//texture
texture TexNormals <string uiname="Normals";>;
sampler SampNormals = sampler_state    //sampler for doing the texture-lookup
{
    Texture   = (TexNormals);          //apply a texture to the sampler
    MipFilter = LINEAR;         //sampler states
    MinFilter = LINEAR;
    MagFilter = LINEAR;
};

texture TexWorld <string uiname="World";>;
sampler SampWorld = sampler_state    //sampler for doing the texture-lookup
{
    Texture   = (TexWorld);          //apply a texture to the sampler
    MipFilter = LINEAR;         //sampler states
    MinFilter = LINEAR;
    MagFilter = LINEAR;
};

float4x4 tTex: TEXTUREMATRIX <string uiname="Texture Transform";>;

//the data structure: vertexshader to pixelshader
//used as output data with the VS function
//and as input data with the PS function
struct vs2ps
{
    float4 Pos : POSITION;
    float4 TexCd : TEXCOORD0;
};

// --------------------------------------------------------------------------------------------------
// VERTEXSHADERS
// --------------------------------------------------------------------------------------------------

vs2ps VS(
    float4 Pos : POSITION,
    float4 TexCd : TEXCOORD0)
{
    //inititalize all fields of output struct with 0
    vs2ps Out = (vs2ps)0;

	Pos.xy *= 2;
    //transform position
    Out.Pos = mul(Pos, tW);

    //transform texturecoordinates
    Out.TexCd = mul(TexCd, tTex);

    return Out;
}

// --------------------------------------------------------------------------------------------------
// PIXELSHADERS:
// --------------------------------------------------------------------------------------------------

float3 LightPosition;
float Intensity;
float Phase;
float Frequency;
float4 PS(vs2ps In): COLOR
{
    //In.TexCd = In.TexCd / In.TexCd.w; // for perpective texture projections (e.g. shadow maps) ps_2_0

	float2 lookup = tex2D(SampLookup, In.TexCd).xy;
	
	float3 World = tex2D(SampWorld, lookup.xy).xyz;
	float3 Normals = tex2D(SampNormals, lookup.xy).xyz;
	
	float3 lightVector = World - LightPosition;
	float I = dot(normalize(lightVector), normalize(Normals));
	float4 col = I;// / pow(length(lightVector), 2)
	col.a = Value;
	
	
	//ring
	float x = length(lightVector);
	col.r = pow(cos(Frequency * (x - Phase)), 10);
	col *= length(World) > 0.4;
	col.a = Value;
    return col;
}
float4 PSNoMarker(vs2ps In): COLOR
{
    //In.TexCd = In.TexCd / In.TexCd.w; // for perpective texture projections (e.g. shadow maps) ps_2_0

	float2 lookup = tex2D(SampLookup, In.TexCd).xy;
	
	float3 World = tex2D(SampWorld, lookup.xy).xyz;
	float3 Normals = tex2D(SampNormals, lookup.xy).xyz;
	
	float3 lightVector = World - LightPosition;
	float I = dot(normalize(lightVector), normalize(Normals));
	float4 col = I;// / pow(length(lightVector), 2)
	col.a = Value;

    return col;
}

// --------------------------------------------------------------------------------------------------
// TECHNIQUES:
// --------------------------------------------------------------------------------------------------

technique TLight
{
    pass P0
    {
        //Wrap0 = U;  // useful when mesh is round like a sphere
        VertexShader = compile vs_3_0 VS();
        PixelShader = compile ps_3_0 PS();
    }
}


technique TLightNoMarker
{
    pass P0
    {
        //Wrap0 = U;  // useful when mesh is round like a sphere
        VertexShader = compile vs_3_0 VS();
        PixelShader = compile ps_3_0 PSNoMarker();
    }
}
