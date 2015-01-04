package System
{
	import Component.Camera.CameraManager;
	
	import Core.GameManager;
	
	import Node.CameraNode;
	
	import ash.core.Engine;
	import ash.core.NodeList;
	import ash.core.System;

	public class CameraSystem extends System
	{
		private var cameraList:NodeList;
		
		public function CameraSystem()
		{
			super();
		}
		
		
		/**
		 * 添加到ASH引擎 
		 * */
		override public function addToEngine(engine:Engine):void
		{
			cameraList = engine.getNodeList( CameraNode );
			cameraList.nodeAdded.add( onAddCamera );
			cameraList.nodeRemoved.add( onRemoveCamera );
		}
		
		
		
		/**
		 * 添加相机节点
		 * */
		private function onAddCamera( node:CameraNode ):void
		{
			CameraManager.getInstance().createCameraController( node.camera.type, GameManager.getInstance().view.camera, node.camera.targe );
		}
		
		
		
		/**
		 * 移除相机节点
		 * */
		private function onRemoveCamera( node:CameraNode ):void
		{
		
		}
		
		
		
		/**
		 * 从引擎中移除
		 * */
		override public function removeFromEngine( engine:Engine ):void
		{
			
		}
		
		
		
		/**
		 * 每帧更新
		 * */
		override public function update(time : Number):void
		{
			CameraManager.getInstance().updata( time );
		}
		
	}
}