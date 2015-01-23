package Component.Movement
{
	import Component.IComponent;
	
	import flash.geom.Vector3D;

	public class MovementComponent extends IComponent
	{
		private var _postion:Vector3D = new Vector3D();		// 当前位置
		private var _roation:Vector3D = new Vector3D();		// 当前朝向
		private var _fSpeed:Number = 1;					// 旋转速度
		
		
		public function MovementComponent()
		{
		
		}

		public function get postion():Vector3D
		{
			return _postion;
		}

		public function set postion(value:Vector3D):void
		{
			_postion = value;
		}

		
		override public function dispose():void
		{
			_postion.x = _postion.y = _postion.z = 0;
		}

		public function get roation():Vector3D
		{
			return _roation;
		}

		public function set roation(value:Vector3D):void
		{
			_roation = value;
		}

		public function get fSpeed():Number
		{
			return _fSpeed;
		}

		public function set fSpeed(value:Number):void
		{
			_fSpeed = value;
		}


	}
}