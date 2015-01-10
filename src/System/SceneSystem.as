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
			_sceneList = engine.getNodeList( SceneNode );
			
			_sceneList.nodeAdded.add( onAdded );
			_sceneList.nodeRemoved.add( onRemoved );
		}
		
		
		private function onAdded( node:SceneNode ):void
		{
			if( node.scene.terrain )
			{
				GameRoot.getInstance().view.scene.addChild( node.scene.terrain );
			}
			
			if( node.scene.skyBox )
			{
				GameRoot.getInstance().view.scene.addChild( node.scene.skyBox );
			}
			
			if( node.scene.sun )
			{
				GameRoot.getInstance().view.scene.addChild( node.scene.sun );
			}
			
			if( node.scene.water )
			{
				GameRoot.getInstance().view.scene.addChild( node.scene.water );
			}
		}
		
		
		private function onRemoved( node:SceneNode ):void
		{
			if( node.scene.terrain )
			{
				GameRoot.getInstance().view.scene.removeChild( node.scene.terrain );
			}
			
			if( node.scene.skyBox )
			{
				GameRoot.getInstance().view.scene.removeChild( node.scene.skyBox );
			}
			
			if( node.scene.sun )
			{
				GameRoot.getInstance().view.scene.removeChild( node.scene.sun );
			}
			
			if( node.scene.water )
			{
				GameRoot.getInstance().view.scene.removeChild( node.scene.water );
			}
			
			node.scene.dispose();
		}
		
		
		/**
		 * 从引擎中移除
		 * */
		override public function removeFromEngine( engine:Engine ):void
		{
		
		}
		
		
		
		override public function update(time:Number):void
		{
			for( var node:SceneNode = _sceneList.head; node; node = node.next )
			{
				if( node.scene.sun )
				{
					node.scene.sun.updata();
				}
				
				if( node.scene.water )
				{
					node.scene.water.updata();
				}
			}
		}
	}
}