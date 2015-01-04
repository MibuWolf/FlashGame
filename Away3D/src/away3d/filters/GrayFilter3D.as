package away3d.filters
{
	import away3d.core.managers.Stage3DProxy;
	import away3d.filters.tasks.Filter3DGrayTask;
	
	import flash.display3D.textures.Texture;

	public class GrayFilter3D  extends Filter3DBase
	{
		private var _grayTask:Filter3DGrayTask;
		
		public function GrayFilter3D()
		{
			super();
			addTask(_grayTask = new Filter3DGrayTask());
		}
		
	}
}