/*
Wolven kit - 0.6.0.1
30.12.2021
*/
function OverwriteRenderSettings() 
{
	var world : CWorld = theGame.GetWorld();
	var environmentDN : CEnvironmentDefinition;
	
	world.shadowConfig.numCascades = 3;
	world.shadowConfig.cascadeRange1 = 6;
	world.shadowConfig.cascadeRange2 = 30;
	world.shadowConfig.cascadeRange3 = 78;
	
	world.shadowConfig.cascadeFilterSize1 = 0.02;
	world.shadowConfig.cascadeFilterSize2 = 0.08;
	world.shadowConfig.cascadeFilterSize3 = 0.25;
	
	world.shadowConfig.terrainShadowsDistance = 10000;
}
