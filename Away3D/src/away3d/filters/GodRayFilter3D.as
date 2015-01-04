package away3d.filters
{
	import away3d.filters.Filter3DBase;
	import away3d.filters.tasks.Filter3DGodRayTask;
	
	
	/**
	 * GodRays Effect
	 * @author vancopper
	 * 
	 */	
	public class GodRayFilter3D extends Filter3DBase
	{
		
		private var _godRaysTask:Filter3DGodRayTask;

		public function GodRayFilter3D()
		{
			super();
			_godRaysTask = new Filter3DGodRayTask();
			addTask(_godRaysTask);
		}
		
		public function set lightX(value:Number):void { _godRaysTask.lightX = value; }
		public function get lightX():Number { return _godRaysTask.lightX; }
		
		public function set lightY(value:Number):void { _godRaysTask.lightY = value; }
		public function get lightY():Number { return _godRaysTask.lightY; }
		
		public function set decay(value:Number):void { _godRaysTask.decay = value; }
		public function get decay():Number { return _godRaysTask.decay; }
		
		public function set exposure(value:Number):void { _godRaysTask.exposure = value; }
		public function get exposure():Number { return _godRaysTask.exposure; }
		
		public function set weight(value:Number):void { _godRaysTask.weight = value; }
		public function get weight():Number { return _godRaysTask.weight; }
		
		public function set density(value:Number):void { _godRaysTask.density = value; }
		public function get density():Number { return _godRaysTask.density; }
	}
}