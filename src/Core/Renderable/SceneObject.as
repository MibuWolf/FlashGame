package Core.Renderable
{
	import Core.GameRoot;
	import Core.ResourcesManager;
	
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import away3d.extrusions.Elevation;
	import away3d.library.AssetLibrary;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.SkyBox;
	import away3d.textures.BitmapTexture;
	import away3d.textures.Texture2DBase;
	import away3d.utils.Cast;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import mx.resources.ResourceManager;

	public class SceneObject  extends ObjectContainer3D
	{
		private var _terrain:Elevation;					// 地形
		private var _terrainTexture:String;				// 地形纹理
		private var _terrainMaterial:TextureMaterial;	// 地形材质
		private var _terrainHTex:String;				// 地形高度纹理
		private var _terrainHBitmapData:BitmapData;		// 高度图
		
		private var _skyBox:SkyBox;						// 天空盒
		private var _cubeTexture:String;				// 天空盒纹理
		
		private var _sceneObj:Mesh;						// 场景
		private var _sceneID:String;					// 场景ID
		
		
		public function SceneObject( terrainTex:String = null, terrainHTex:String = null, cubeTex:String = null, objName:String = null )
		{
			if( terrainTex && terrainHTex )
			{
				_terrainTexture = terrainTex;		_terrainHTex = terrainHTex;
				
				ResourcesManager.getInstance().loadTexture( _terrainTexture, onLoadTerrainTex );
				ResourcesManager.getInstance().loadTexture( _terrainHTex, onLoadTerrainHTex );
			}
			
			GameRoot.getInstance().view.scene.addChild( this );
		}
		
		private function onLoadTerrainTex( bitmap:Bitmap ):void
		{
			if( !bitmap )
				return;
			
			var tex:BitmapTexture = new BitmapTexture( bitmap.bitmapData );
			this._terrainMaterial = new TextureMaterial( tex );
			
			if( _terrainHBitmapData )
			{
				_terrain = new Elevation(_terrainMaterial, _terrainHBitmapData, 5000, 1300, 5000, 250, 250);
				addChild( _terrain );
			}
		}
		
		private function onLoadTerrainHTex( bitmap:Bitmap ):void
		{
			if( !bitmap )
				return;
			
			_terrainHBitmapData = bitmap.bitmapData;
			
			if( _terrainMaterial )
			{
				_terrain = new Elevation(_terrainMaterial, _terrainHBitmapData, 5000, 1300, 5000, 250, 250);
				addChild( _terrain );
			}
		}
		
		
		override public function dispose():void
		{
			super.dispose();
			
			_terrain = null;
			_terrainTexture = null;
			_terrainHTex = null;
			_terrainMaterial.dispose();
			_terrainMaterial = null;
			
			_skyBox = null;
			_cubeTexture = null;
			_terrainHBitmapData.dispose();
			_terrainHBitmapData = null;
			
			_scene = null;
			_sceneID = null;
		}
	}
}