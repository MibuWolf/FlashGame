package Camera
{
	import away3d.cameras.Camera3D;
	import away3d.containers.ObjectContainer3D;
	import away3d.controllers.HoverController;
	import away3d.controllers.LookAtController;
	import away3d.entities.Entity;
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;

	public class CameraManager
	{
		static private var _instance:CameraManager;
		
		private var _cameraModel:ICameraModel;					// 默认相机控制
		private var _cameraModelSecond:ICameraModel;				// 第二相机控制
		
		private var _lock:Boolean;
		
		public function CameraManager()
		{
		
		}
		
		
		/** 
		 * 获取相机管理器
		 * */
		static public function getInstance():CameraManager
		{
			if( !_instance )
			{
				_instance = new CameraManager();
			}
			
			return _instance;
		}
		
		
		/**
		 * 创建默认相机管理
		 * */
		public function createCameraController( __type:int, __camera:Camera3D = null, lookAtObject:ObjectContainer3D = null, panAngle:Number = 0, tiltAngle:Number = 90 ):ICameraModel
		{
			if( _cameraModel )
			{
				_cameraModel = null;
			}
		
			_cameraModel = getCameraController( __type, __camera, lookAtObject, panAngle, tiltAngle );
			
			
			return _cameraModel;
		}
		
		
		
		/**
		 * 创建第二相机管理
		 * */
		public function createCameraSecondController( __type:int, __camera:Camera3D, __target:ObjectContainer3D = null, lookAtObject:ObjectContainer3D = null, panAngle:Number = 0, tiltAngle:Number = 90 ):ICameraModel
		{
			if( _cameraModelSecond )
			{
				_cameraModelSecond = null;
			}
			
			_cameraModelSecond = getCameraController( __type, __camera, __target, panAngle, tiltAngle );
			
			
			return _cameraModelSecond;
		}
		
		
		/**
		 * Key down listener for camera control
		 */
		public function onKeyDown(event:KeyboardEvent, bFirst:Boolean = true):void
		{  
			if( bFirst )
			{
				if( this._cameraModel )
				{
					this._cameraModel.onKeyDown( event );
				}
			}
			else
			{
				if( this._cameraModelSecond )
				{
					this._cameraModelSecond.onKeyDown( event );
				}
			}
		}
		
		
		/**
		 * Key up listener for camera control
		 */
		public function onKeyUp(event:KeyboardEvent, bFirst:Boolean = true):void
		{
			if( bFirst )
			{
				if( this._cameraModel )
				{
					this._cameraModel.onKeyUp( event );
				}
			}
			else
			{
				if( this._cameraModelSecond )
				{
					this._cameraModelSecond.onKeyUp( event );
				}
			}
		}
		
		
		/**
		 * Mouse down listener for navigation
		 */
		public function onMouseDown(event:MouseEvent, bFirst:Boolean = true):void
		{
			if( bFirst )
			{
				if( this._cameraModel )
				{
					this._cameraModel.onMouseDown( event );
				}
			}
			else
			{
				if( this._cameraModelSecond )
				{
					this._cameraModelSecond.onMouseDown( event );
				}
			}
		}
		
		/**
		 * Mouse up listener for navigation
		 */
		public function onMouseUp(event:MouseEvent, bFirst:Boolean = true):void
		{
			if( bFirst )
			{
				if( this._cameraModel )
				{
					this._cameraModel.onMouseUp( event );
				}
			}
			else
			{
				if( this._cameraModelSecond )
				{
					this._cameraModelSecond.onMouseUp( event );
				}
			}
		}
		
		
		
		/**
		 * Mouse up listener for navigation
		 */
		public function onMouseMove(event:MouseEvent, bFirst:Boolean = true):void
		{
			if( bFirst )
			{
				if( this._cameraModel )
				{
					this._cameraModel.onMouseMove( event );
				}
			}
			else
			{
				if( this._cameraModelSecond )
				{
					this._cameraModelSecond.onMouseMove( event );
				}
			}
		}
		
		
		
		// 根据相机类型获取相机控制
		private function getCameraController( __type:int, __camera:Camera3D, __target:ObjectContainer3D = null, __panAngle:Number = 0, __tiltAngle:Number = 90  ):ICameraModel
		{
			switch( __type )
			{
				case CameraType.FIRSTPERSONMODEL:
				{
					return new FirstCameraModel( __camera, __target, __panAngle, __tiltAngle );
				}
			}
			
			return null;
		}
		
		
		// 每帧更新
		public function updata( time:Number ):void
		{
			if( _cameraModel )
			{
				_cameraModel.onUpdata( time );
			}
			
			if( _cameraModelSecond )
			{
				_cameraModelSecond.onUpdata( time );
			}
		}
		
		

		public function get cameraModel():ICameraModel
		{
			return _cameraModel;
		}

		public function set cameraModel(value:ICameraModel):void
		{
			_cameraModel = value;
		}

		public function get cameraModelSecond():ICameraModel
		{
			return _cameraModelSecond;
		}

		public function set cameraModelSecond(value:ICameraModel):void
		{
			_cameraModelSecond = value;
		}

		public function get lock():Boolean
		{
			return _lock;
		}

		public function set lock(value:Boolean):void
		{
			_lock = value;
		}
		
		
	}
}