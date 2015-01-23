package System
{
	import Camera.CameraManager;
	
	import Component.Scene.RenderObjectComponent;
	
	import Core.GameRoot;
	
	import Node.MovementNode;
	
	import ash.core.Engine;
	import ash.core.NodeList;
	import ash.core.System;
	
	import away3d.core.math.MathConsts;
	
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	public class MoveControlSystem extends System
	{
		private var _moveList:NodeList;
		
		private var _meMoveNode:MovementNode;
		
		private var _bWDown:Boolean = false;
		private var _bADown:Boolean = false;
		private var _bSDown:Boolean = false;
		private var _bDDown:Boolean = false;
		
		public function MoveControlSystem()
		{
			super();
		}
		
		
		/**
		 * 添加到ASH引擎 
		 * */
		override public function addToEngine(engine:Engine):void
		{
			_moveList = engine.getNodeList( MovementNode );
			_moveList.nodeAdded.add( onAdded );
			_moveList.nodeRemoved.add( onRemoved );
			
			
			GameRoot.getInstance().stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			GameRoot.getInstance().stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		
		private function onAdded(node:MovementNode):void
		{
			_meMoveNode = node;
		}
		
		private function onRemoved(node:MovementNode):void
		{
			_meMoveNode = null;
		}
		
		
		/**
		 * 从引擎中移除
		 * */
		override public function removeFromEngine( engine:Engine ):void
		{
			GameRoot.getInstance().stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			GameRoot.getInstance().stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		
		private function onKeyDown( e:KeyboardEvent ):void
		{
			if( !_meMoveNode )
				return;
			
			var obj:RenderObjectComponent = _meMoveNode.entity.get( RenderObjectComponent );
			
			switch( e.keyCode )
			{
				case Keyboard.W:
				{
					this._bWDown = true;
				}break;
				case Keyboard.S:
				{
					this._bSDown = true;
				}break;
				case Keyboard.A:
				{
					this._bADown = true;
				}break;
				case Keyboard.D:
				{
					this._bDDown = true;
				}break;
				
				case Keyboard.SPACE:
				{
					CameraManager.getInstance().lock = !CameraManager.getInstance().lock;
				}break;
			}
		}
		
		private function onKeyUp( e:KeyboardEvent ):void
		{
			if( !_meMoveNode )
				return;
			var obj:RenderObjectComponent = _meMoveNode.entity.get( RenderObjectComponent );
			
			switch( e.keyCode )
			{
				case Keyboard.W:
				{
					_bWDown = false;
				}break;
				case Keyboard.A:
				{
					_bADown = false;
				}break;
				case Keyboard.S:
				{
					_bSDown = false;
				}break;
				case Keyboard.D:
				{
					_bDDown = false;
				}break;
			}
			
		}
		
		override public function update(time:Number):void
		{
			if( !CameraManager.getInstance().lock )
				return;
			
			if( !_meMoveNode )
				return;
			
			var obj:RenderObjectComponent = _meMoveNode.entity.get( RenderObjectComponent );
			
			if( !obj )
				return;
			
			if( this._bWDown )
			{
				if( ( _meMoveNode.postion.roation.y >= 0 && _meMoveNode.postion.roation.y <= 90 ) || ( _meMoveNode.postion.roation.y >= 270 && _meMoveNode.postion.roation.y <= 360 ) )
				{
					_meMoveNode.postion.postion.z -= Math.abs( Math.cos( _meMoveNode.postion.roation.y * MathConsts.DEGREES_TO_RADIANS ) ) * _meMoveNode.postion.fSpeed;
				}
				else
				{
					_meMoveNode.postion.postion.z += Math.abs(Math.cos( _meMoveNode.postion.roation.y  * MathConsts.DEGREES_TO_RADIANS)) * _meMoveNode.postion.fSpeed;
				}
				
				if( ( _meMoveNode.postion.roation.y >= 0 && _meMoveNode.postion.roation.y <= 180 ) )
				{
					_meMoveNode.postion.postion.x -= Math.abs(Math.sin( _meMoveNode.postion.roation.y  * MathConsts.DEGREES_TO_RADIANS )) * _meMoveNode.postion.fSpeed;
				}
				else
				{
					_meMoveNode.postion.postion.x += Math.abs(Math.sin( _meMoveNode.postion.roation.y  * MathConsts.DEGREES_TO_RADIANS )) * _meMoveNode.postion.fSpeed;
				}
				
				if( obj )
				{
					obj.action = "Walk";
				}
			}
			
			if( this._bSDown )
			{
				if( ( _meMoveNode.postion.roation.y >= 0 && _meMoveNode.postion.roation.y <= 90 ) || ( _meMoveNode.postion.roation.y >= 270 && _meMoveNode.postion.roation.y <= 360 ) )
				{
					_meMoveNode.postion.postion.z += Math.abs( Math.cos( _meMoveNode.postion.roation.y * MathConsts.DEGREES_TO_RADIANS ) ) * _meMoveNode.postion.fSpeed;
				}
				else
				{
					_meMoveNode.postion.postion.z -= Math.abs(Math.cos( _meMoveNode.postion.roation.y  * MathConsts.DEGREES_TO_RADIANS)) * _meMoveNode.postion.fSpeed;
				}
				
				if( ( _meMoveNode.postion.roation.y >= 0 && _meMoveNode.postion.roation.y <= 180 ) )
				{
					_meMoveNode.postion.postion.x += Math.abs(Math.sin( _meMoveNode.postion.roation.y  * MathConsts.DEGREES_TO_RADIANS )) * _meMoveNode.postion.fSpeed;
				}
				else
				{
					_meMoveNode.postion.postion.x -= Math.abs(Math.sin( _meMoveNode.postion.roation.y  * MathConsts.DEGREES_TO_RADIANS )) * _meMoveNode.postion.fSpeed;
				}
				
				obj.action = "Walk";
			}
			
			if( this._bADown )
			{
				_meMoveNode.postion.roation.y -= 2;
			}
			
			if( this._bDDown )
			{
				_meMoveNode.postion.roation.y += 2;
			}
			
			if( _meMoveNode.postion.roation.y > 360 )
			{
				_meMoveNode.postion.roation.y -= 360;
			}
			
			if( _meMoveNode.postion.roation.y < 0 )
			{
				_meMoveNode.postion.roation.y += 360;
			}
			
			if( !_bWDown && !_bADown && !_bSDown && !_bDDown )
			{
				obj.action = "Breathe";
			}
		}
	}
}