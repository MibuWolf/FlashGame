package System
{
	import Core.GameRoot;
	import Core.Renderable.A3DMesh;
	
	import Node.RenderObjectNode;
	
	import ash.core.Engine;
	import ash.core.NodeList;
	import ash.core.System;
	
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.CubeGeometry;

	public class RenderObjectSystem extends System
	{
		private var _objectList:NodeList;
		
		public function RenderObjectSystem()
		{
			super();
		}
		
		/**
		 * 添加到ASH引擎 
		 * */
		override public function addToEngine(engine:Engine):void
		{
			_objectList = engine.getNodeList( RenderObjectNode );
			
			_objectList.nodeAdded.add( onAdded );
			_objectList.nodeRemoved.add( onRemoved );
		}
		
		
		private function onAdded( node:RenderObjectNode ):void
		{
			if( !node.container.container )
			{
				node.container.container = new ObjectContainer3D();
			}
			GameRoot.getInstance().view.scene.addChild( node.container.container );
			
			if( !node.renderObj.mesh )
			{
				node.renderObj.mesh = new A3DMesh( node.renderObj.name, node.renderObj.tex, node.renderObj.noramlTex, node.renderObj.speTex );
			}
			node.container.container.addChild( node.renderObj.mesh ); 
		} 
		
		
		private function onRemoved( node:RenderObjectNode ):void
		{
			node.container.dispose();
			node.renderObj.dispose();
		}
		
		
		/**
		 * 从引擎中移除
		 * */
		override public function removeFromEngine( engine:Engine ):void
		{
			for( var node:RenderObjectNode = _objectList.head; node; node = node.next )
			{
				onRemoved( node );
			}
		}
		
		
		
		override public function update(time:Number):void
		{
			for( var node:RenderObjectNode = _objectList.head; node; node = node.next )
			{
				if( node.renderObj.mesh )
				{
					node.renderObj.mesh.updata();
				}
			}
		}
	}
}