package Camera
{
	import away3d.cameras.Camera3D;
	import away3d.containers.ObjectContainer3D;
	import away3d.controllers.FirstPersonController;
	import away3d.entities.Entity;
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;

	public class FirstCameraModel implements ICameraModel
	{
		private var _cameraController:FirstPersonController;
		private var _type:int;
		
		
		//rotation variables
		private var move:Boolean = false;
		private var lastPanAngle:Number;
		private var lastTiltAngle:Number;
		private var lastMouseX:Number;
		private var lastMouseY:Number;
		private var curMouseX:Number = 0;
		private var curMouseY:Number = 0;
		
		//movement variables
		private var drag:Number = 0.5;
		private var walkIncrement:Number = 2;
		private var strafeIncrement:Number = 2;
		private var walkSpeed:Number = 0;
		private var strafeSpeed:Number = 0;
		private var walkAcceleration:Number = 0;
		private var strafeAcceleration:Number = 0;
		
		
		public function FirstCameraModel( targetObject:Camera3D, __target:ObjectContainer3D = null, panAngle:Number = 0, tiltAngle:Number = 90 )
		{
			_cameraController = new FirstPersonController( targetObject, panAngle, tiltAngle );
			_type = CameraType.FIRSTPERSONMODEL;
		}
		
		
		/**
		 * Key down listener for camera control
		 */
		public function onKeyDown(event:KeyboardEvent):void
		{
			switch (event.keyCode) {
				case Keyboard.UP:
				case Keyboard.W:
					walkAcceleration = walkIncrement;
					break;
				case Keyboard.DOWN:
				case Keyboard.S:
					walkAcceleration = -walkIncrement;
					break;
				case Keyboard.LEFT:
				case Keyboard.A:
					strafeAcceleration = -strafeIncrement;
					break;
				case Keyboard.RIGHT:
				case Keyboard.D:
					strafeAcceleration = strafeIncrement;
					break;
			}
		}
		
		/**
		 * Key up listener for camera control
		 */
		public function onKeyUp(event:KeyboardEvent):void
		{
			switch (event.keyCode) {
				case Keyboard.UP:
				case Keyboard.W:
				case Keyboard.DOWN:
				case Keyboard.S:
					walkAcceleration = 0; 
					break;
				case Keyboard.LEFT:
				case Keyboard.A:
				case Keyboard.RIGHT:
				case Keyboard.D:
					strafeAcceleration = 0;
					break;
			}
		}
		
		/**
		 * Mouse down listener for navigation
		 */
		public function onMouseDown(event:MouseEvent):void
		{
			move = true;
			lastPanAngle = _cameraController.panAngle;
			lastTiltAngle = _cameraController.tiltAngle;
			lastMouseX = event.stageX;
			lastMouseY = event.stageY;
			curMouseX = event.stageX;
			curMouseY = event.stageY;
		}
		
		/**
		 * Mouse up listener for navigation
		 */
		public function onMouseUp(event:MouseEvent):void
		{
			move = false;
		}
		
		
		/**
		 * Mouse down listener for navigation
		 */
		public function onMouseMove(event:MouseEvent):void
		{
			if( move )
			{
				curMouseX = event.stageX;
				curMouseY = event.stageY;
			}
		}
		
		
		
		public function onUpdata( time:Number ):void
		{
			if (move) {
				_cameraController.panAngle = 0.3*(curMouseX - lastMouseX) + lastPanAngle;
				_cameraController.tiltAngle = 0.3*(curMouseY - lastMouseY) + lastTiltAngle;
				
			}
			
			if (walkSpeed || walkAcceleration) {
				walkSpeed = (walkSpeed + walkAcceleration)*drag;
				if (Math.abs(walkSpeed) < 0.01)
					walkSpeed = 0;
				_cameraController.incrementWalk(walkSpeed);
			}
			
			if (strafeSpeed || strafeAcceleration) {
				strafeSpeed = (strafeSpeed + strafeAcceleration)*drag;
				if (Math.abs(strafeSpeed) < 0.01)
					strafeSpeed = 0;
				_cameraController.incrementStrafe(strafeSpeed);
			}
		}
	}
}