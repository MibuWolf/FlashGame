package Component
{
	import flash.geom.Vector3D;

	public class Motion extends IComponet
	{
		private var _postion:Vector3D = new Vector3D();		// 当前位置
		private var _speed:Vector3D = new Vector3D();		// 当前速度
		
		
		public function Motion()
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

		public function get speed():Vector3D
		{
			return _speed;
		}

		public function set speed(value:Vector3D):void
		{
			_speed = value;
		}

		
		override public function dispose():void
		{
			_postion.x = _postion.y = _postion.z = 0;
			_speed.x = _speed.y = _speed.z = 0;
		}
	}
}