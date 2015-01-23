package System
{
	import Node.MovementNode;
	import Node.SceneNode;
	
	import ash.core.Engine;
	import ash.core.NodeList;
	import ash.core.System;
	
	import away3d.containers.ObjectContainer3D;

	public class MovementSystem extends System
	{
		private var _moveList:NodeList;
		private var _sceneList:NodeList;
		
		private var _curScene:SceneNode;
		
		public function MovementSystem()
		{
			super();
		}
		
		/**
		 * 添加到ASH引擎 
		 * */
		override public function addToEngine(engine:Engine):void
		{
			_moveList = engine.getNodeList( MovementNode );
			_sceneList = engine.getNodeList( SceneNode );
			_curScene = _sceneList.head;
			_sceneList.nodeAdded.add( onAddScene );
			_sceneList.nodeRemoved.add( onRemoveScene );
			
			_moveList.nodeAdded.add( onAdded );
			_moveList.nodeRemoved.add( onRemoved );
		}
		
		
		private function onAddScene( node:SceneNode ):void
		{
			_curScene = node;
		}
		
		private function onRemoveScene( node:SceneNode ):void
		{
			_curScene = null;
		}
		
		private function onAdded( node:MovementNode ):void
		{
			if( !node.container.container )
				node.container.container = new ObjectContainer3D();
			
			node.container.container.x = node.postion.postion.x;
			node.container.container.y = node.postion.postion.y;
			node.container.container.z = node.postion.postion.z;
			
			node.container.container.rotationX = node.postion.roation.x;
			node.container.container.rotationY = node.postion.roation.y;
			node.container.container.rotationZ = node.postion.roation.z;
		} 
		
		
		private function onRemoved( node:MovementNode ):void
		{
			node.container.dispose();
			node.postion.dispose();
		}
		
		
		/**
		 * 从引擎中移除
		 * */
		override public function removeFromEngine( engine:Engine ):void
		{
			for( var node:MovementNode = _moveList.head; node; node = node.next )
			{
				onRemoved( node );
			}
		}
		
		
		
		override public function update(time:Number):void
		{
			for( var node:MovementNode = _moveList.head; node; node = node.next )
			{
				node.container.container.rotationX = node.postion.roation.x;
				node.container.container.rotationY = node.postion.roation.y;
				node.container.container.rotationZ = node.postion.roation.z;
				
				if( _curScene && _curScene.scene.terrain )
				{
					node.postion.postion.y = _curScene.scene.terrain.getHeight( node.postion.postion.x, node.postion.postion.z );
				}
				
				node.container.container.x = node.postion.postion.x;	node.container.container.y = node.postion.postion.y;	node.container.container.z = node.postion.postion.z;

				if( _curScene && _curScene.scene.water )
				{
					_curScene.scene.water.clcFluid( node.container.container.scenePosition );
				}
			}
		}
	}
}