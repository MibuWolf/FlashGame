package Core.Renderable
{
	import Core.GameRoot;
	import Core.ResourcesManager;
	
	import away3d.containers.ObjectContainer3D;
	import away3d.core.pick.PickingColliderType;
	import away3d.entities.Mesh;
	import away3d.lights.PointLight;
	import away3d.materials.ColorMaterial;
	import away3d.materials.MaterialBase;
	import away3d.materials.SkyBoxMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.materials.methods.EnvMapMethod;
	import away3d.materials.methods.FresnelSpecularMethod;
	import away3d.materials.methods.SimpleWaterNormalMethod;
	import away3d.primitives.PlaneGeometry;
	import away3d.textures.BitmapCubeTexture;
	import away3d.textures.BitmapTexture;
	import away3d.textures.CubeTextureBase;
	import away3d.textures.Texture2DBase;
	
	import flash.display.Bitmap;

	public class A3DWater extends ObjectContainer3D
	{
		private var plane:Mesh;					// 水平面
		private var skyBox:A3DSkyBox;			// 天空盒子
		private var normalTex1:Texture2DBase;	// 法线贴图1
		private var normalTex2:Texture2DBase;	// 法线贴图2
		
		private var bInitSkyBox:Boolean = false;
		
		private var normalMethod:SimpleWaterNormalMethod;
		
		public function A3DWater( width:Number, heigh:Number, SegmentsX:uint, SegmentsY:uint, skybox:A3DSkyBox, normalTex1:String, normalTex2:String )
		{
			var mat:ColorMaterial = initMaterial( skybox );
			
			initPlane( width, heigh, SegmentsX, SegmentsY, mat );
			
			ResourcesManager.getInstance().loadTexture( normalTex1 , onLoadNormal1 );
			ResourcesManager.getInstance().loadTexture( normalTex2 , onLoadNormal2 );
		}
		
		
		// 初始化水平面材质
		private function initMaterial( skybox:A3DSkyBox ):ColorMaterial
		{
			var mat:ColorMaterial = new ColorMaterial(0xaa404070);
			mat.specular = 0.2;
			mat.ambient = 0.25;
			mat.ambientColor = 0x111199;
			mat.ambient = 1;
			skyBox = skybox;
			mat.lightPicker = GameRoot.getInstance().mainLightPick;
			mat.gloss = 100;
			mat.specular = 1;
			mat.repeat = true;
			
			var fresnelMethod:FresnelSpecularMethod = new FresnelSpecularMethod();
			fresnelMethod.normalReflectance = .3;
			mat.specularMethod = fresnelMethod;
			
			if( skyBox && skyBox.skyBox )
			{
				var cube:CubeTextureBase =  (skyBox.skyBox.material as SkyBoxMaterial).cubeMap;
				
				var envMethod:EnvMapMethod = new EnvMapMethod(cube);
				mat.addMethod( envMethod );
			}
			
			return mat;
		}
		
		
		// 初始化水平面
		public function	initPlane( width:Number, heigh:Number, SegmentsX:uint, SegmentsY:uint, mat:ColorMaterial ):void
		{
			var planeGeometry:PlaneGeometry = new PlaneGeometry( width, heigh, SegmentsX, SegmentsY );
			
			plane = new Mesh( planeGeometry, mat );
			plane.x -= width/2;
			plane.z -= heigh/2;
			plane.y = 290;
			plane.mouseEnabled = true;
			plane.pickingCollider = PickingColliderType.BOUNDS_ONLY;
			plane.geometry.convertToSeparateBuffers();
			plane.geometry.subGeometries[0].autoDeriveVertexNormals = false;
			plane.geometry.subGeometries[0].autoDeriveVertexTangents = false;
			plane.geometry.scaleUV(80, 80);
			
			this.addChild( plane );
		}
		
		
		// 法线贴图1加载完成
		private function onLoadNormal1( bip:Bitmap ):void
		{
			if( !bip )
				return;
			
			normalTex1 = new BitmapTexture( bip.bitmapData );
			
			if( normalTex2 )
			{
				normalMethod = new SimpleWaterNormalMethod( normalTex1, normalTex2 );
				( plane.material as ColorMaterial ).normalMethod = normalMethod;
			}
		}
		
		
		// 法线贴图2加载完成
		private function onLoadNormal2( bip:Bitmap ):void
		{
			if( !bip )
				return;
			
			normalTex2 = new BitmapTexture( bip.bitmapData );
			
			if( normalTex1 )
			{
				normalMethod = new SimpleWaterNormalMethod( normalTex1, normalTex2 );
				( plane.material as ColorMaterial ).normalMethod = normalMethod;
			}
		}
		
		
		public function updata():void
		{
			if( !bInitSkyBox && skyBox && skyBox.skyBox && plane )
			{
				var mat:ColorMaterial = plane.material as ColorMaterial;
				var cube:CubeTextureBase =  (skyBox.skyBox.material as SkyBoxMaterial).cubeMap;
				
				var envMethod:EnvMapMethod = new EnvMapMethod(cube);
				mat.addMethod( envMethod );
				bInitSkyBox = true;
			}
			
			if( normalMethod )
			{
				normalMethod.water1OffsetX += 0.002;
				normalMethod.water1OffsetY -= 0.0024;
				normalMethod.water2OffsetX += 0.001;
				normalMethod.water2OffsetY -= 0.0015;
			}
		}
	}
}