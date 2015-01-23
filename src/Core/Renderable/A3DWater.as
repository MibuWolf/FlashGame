package Core.Renderable
{
	import Core.GameRoot;
	import Core.Renderable.ShallowWater.DisturbanceBrush;
	import Core.Renderable.ShallowWater.FluidDisturb;
	import Core.Renderable.ShallowWater.ShallowFluid;
	import Core.ResourcesManager;
	
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.SubGeometry;
	import away3d.core.pick.PickingColliderType;
	import away3d.entities.Mesh;
	import away3d.events.MouseEvent3D;
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
	import flash.display.Sprite;
	import flash.geom.Vector3D;

	public class A3DWater extends ObjectContainer3D
	{
		private var plane:Mesh;					// 水平面
		private var skyBox:A3DSkyBox;			// 天空盒子
		private var normalTex1:Texture2DBase;	// 法线贴图1
		private var normalTex2:Texture2DBase;	// 法线贴图2
		
		private var bInitSkyBox:Boolean = false;
		private var normalMethod:SimpleWaterNormalMethod;	// 水的法线计算方法
		
		// 流体
		private var _fluid:ShallowFluid;		
		private var _fluidDisturb:FluidDisturb;
		private var _mouseBrush:DisturbanceBrush;
		
		private var _planeDisturb:Boolean = false;
		private var _mouseBrushLife:uint = 0;
		private var _mouseBrushStrength:Number = -5;
		private var _planeX:Number;
		private var _planeY:Number;
		private var _planeSize:Number;
		private var _gridDimension:uint = 250;
		private var _gridSpacing:uint = 5;
		
		[Embed(source="/../bin-debug/embeds/assets.swf", symbol="Brush3")]
		private var Brush3:Class;
		
		public function A3DWater( width:Number, heigh:Number, SegmentsX:uint, SegmentsY:uint, skybox:A3DSkyBox, normalTex1:String, normalTex2:String )
		{
			_planeSize = width;
			
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
			var planeSegments:uint = (_gridDimension - 1);
			_planeSize = planeSegments*_gridSpacing;
			
			var planeGeometry:PlaneGeometry = new PlaneGeometry( _planeSize, _planeSize, planeSegments, planeSegments );
			
			plane = new Mesh( planeGeometry, mat );
			plane.x = 0;
			plane.z = 0;
			plane.y = 290;
			plane.mouseEnabled = true;
			plane.pickingCollider = PickingColliderType.BOUNDS_ONLY;
			plane.geometry.convertToSeparateBuffers();
			plane.geometry.subGeometries[0].autoDeriveVertexNormals = false;
			plane.geometry.subGeometries[0].autoDeriveVertexTangents = false;
			plane.geometry.scaleUV(80, 80);
			
			this.addChild( plane );
			
			initFluid( _planeSize, _planeSize, planeSegments, planeSegments );

		}
		
		// 初始化流体
		private function initFluid( width:Number, heigh:Number, SegmentsX:uint, SegmentsY:uint ):void
		{		
			var drop:Sprite = new Brush3() as Sprite;
			_mouseBrush = new DisturbanceBrush();
			_mouseBrush.fromSprite(drop);
			
			// Fluid.
			var dt:Number = 1 / 30;
			var viscosity:Number = 0.3;
			var waveVelocity:Number = 0.99; // < 1 or the sim will collapse.
			_fluid = new ShallowFluid(SegmentsX+1, SegmentsX + 1, width / SegmentsX, dt, waveVelocity, viscosity);
			
			// Disturbance util.
			_fluidDisturb = new FluidDisturb(_fluid);
			
		}
		
		
		// 计算产生水的波动效果
		private var _helpVec:Vector3D = new Vector3D();
		private var _helpDirVec:Vector3D = new Vector3D( 0, -1, 0 );
		public function clcFluid( pos:Vector3D, height:Number = 100 ):void
		{
			if( !plane || !pos )
			{
				_planeDisturb = false;
				return;
			}
			
			_helpVec.x = pos.x;	_helpVec.y = pos.y + height;	_helpVec.z = pos.z;
			var bSuc:Boolean = plane.isIntersectingRay( _helpVec, _helpDirVec );
			if( !bSuc )
			{
				_planeDisturb = false;
				return;
			}
			
			_planeDisturb = true;
			updatePlaneCoords( ( _helpVec.x - plane.scenePosition.x ), ( _helpVec.z - plane.scenePosition.z ) );
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
		
		private function updatePlaneCoords(x:Number, y:Number):void
		{
			_planeX = x/_planeSize;
			_planeY = y/_planeSize;
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
			
			updataFluid();
		}
		
		
		private function updataFluid():void
		{
			if( !_fluid || !_fluidDisturb )
				return;
			
			// Update fluid.
			_fluid.evaluate();
			
			// Update memory disturbances.
			_fluidDisturb.updateMemoryDisturbances();
			
			// Update plane to fluid.
			var subGeometry:SubGeometry = plane.geometry.subGeometries[0] as SubGeometry;
			subGeometry.updateVertexData(_fluid.points);
			subGeometry.updateVertexNormalData(_fluid.normals);
			subGeometry.updateVertexTangentData(_fluid.tangents);
			plane.rotationX = 90;
			plane.x = -1100;
			plane.z = -1300;
			
			if (_planeDisturb) {
				if (_mouseBrushLife == 0)
					_fluidDisturb.disturbBitmapInstant(_planeX, _planeY, -_mouseBrushStrength, _mouseBrush.bitmapData);
				else
					_fluidDisturb.disturbBitmapMemory(_planeX, _planeY, -5*_mouseBrushStrength, _mouseBrush.bitmapData, _mouseBrushLife, 0.1);
			}
		}
	}
}