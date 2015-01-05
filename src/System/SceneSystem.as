package System
{
	import Core.GameRoot;
	
	import Node.SceneNode;
	
	import ash.core.Engine;
	import ash.core.NodeList;
	import ash.core.System;
	
	import away3d.entities.Mesh;
	import away3d.extrusions.Elevation;
	import away3d.materials.ColorMaterial;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.CubeGeometry;
	import away3d.primitives.PlaneGeometry;
	import away3d.utils.Cast;

	public class SceneSystem extends System
	{
		private var _testScene:Mesh;
		
		private var terrainMaterial:TextureMaterial;
		[Embed(source="/../bin-debug/embeds/terrain/terrain_diffuse.jpg")]
		private var Albedo:Class;  
		
		[Embed(source="/../bin-debug/embeds/terrain/terrain_heights.jpg")]
		private var HeightMap:Class;
		
		private var _sceneList:NodeList;
		
		public function SceneSystem()
		{
			super();
		}
		
		
		/**
		 * 添加到ASH引擎 
		 * */
		override public function addToEngine(engine:Engine):void
		{
//			terrainMaterial = new TextureMaterial(Cast.bitmapTexture(Albedo));;
//			terrainMaterial.ambientColor = 0x303040;
//			terrainMaterial.ambient = 1;
//			terrainMaterial.specular = .2;
//			var terrain:Elevation = new Elevation(terrainMaterial, Cast.bitmapData(HeightMap), 5000, 1300, 5000, 250, 250);
//			GameRoot.getInstance().view.scene.addChild( terrain );
			
			_sceneList = engine.getNodeList( SceneNode );
			
			_sceneList.nodeAdded.add( onAdded );
			_sceneList.nodeRemoved.add( onRemoved );
		}
		
		
		private function onAdded( node:SceneNode ):void
		{
			
		}
		
		
		private function onRemoved( node:SceneNode ):void
		{
		
		}
		
		
		/**
		 * 从引擎中移除
		 * */
		override public function removeFromEngine( engine:Engine ):void
		{
		
		}
		
		
		
		override public function update(time:Number):void
		{
		
		}
	}
}