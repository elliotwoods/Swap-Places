//@author: Elliot Woods
//@help: Apply normals and lighting effects to DepthMesh
//@tags:
//@credits

// --------------------------------------------------------------------------------------------------
// PARAMETERS:
// --------------------------------------------------------------------------------------------------

#include "DepthMesh.fxh"

// --------------------------------------------------------------------------------------------------
// PIXELSHADERS:
// --------------------------------------------------------------------------------------------------
float4 PSTransform(vs2ps In): COLOR
{
    float4 col = (float4)0;
	col.rg = In.TexCd;
	col.a = In.existence > drop;
    return col;
}


// --------------------------------------------------------------------------------------------------
// TECHNIQUES:
// --------------------------------------------------------------------------------------------------

technique TTransform
{
    pass P0
    {
    	FillMode = Solid;
        //Wrap0 = U;  // useful when mesh is round like a sphere
        VertexShader = compile vs_3_0 VS();
        PixelShader  = compile ps_3_0 PSTransform();
    }
}