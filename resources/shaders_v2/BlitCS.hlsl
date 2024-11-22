Texture2D<float4> source : register(t0);
RWTexture2D<float4> target : register(u0);

[numthreads(8, 8, 1)]
void CSMain( uint3 thread_id : SV_DispatchThreadID )
{
    target[thread_id.xy] = source.Load(int3(thread_id.xy, 0));
}