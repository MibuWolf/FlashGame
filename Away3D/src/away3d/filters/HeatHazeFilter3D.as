package away3d.filters
{
	import away3d.arcane;
	import away3d.core.managers.Stage3DProxy;
	import away3d.core.traverse.EntityCollector;
	import away3d.filters.Filter3DBase;
	import away3d.textures.RenderTexture;
	
	import away3d.core.render.HeatHazeRenderer;
	import away3d.filters.tasks.Filter3DHeatHazeTask;
	
	use namespace arcane;
	
	/**
	 * 热扰动 
	 * @author vancopper
	 * 
	 */    
	public class HeatHazeFilter3D extends Filter3DBase
	{
		private var _heatFilterTask:Filter3DHeatHazeTask;
		private var _renderTexture:RenderTexture;
		private var _render:HeatHazeRenderer;
		
		public function HeatHazeFilter3D()
		{
			_renderTexture = new RenderTexture(2,2);
			_heatFilterTask = new Filter3DHeatHazeTask();
			_render = new HeatHazeRenderer();
			addTask(_heatFilterTask);
		}
		
		public function helpRender(stage3DProxy : Stage3DProxy, collector:EntityCollector, textureRatioX:Number, textureRatioY:Number):void
		{
			var stage3DIndex:int = stage3DProxy.stage3DIndex;
			_render.stage3DProxy = stage3DProxy;
			_render.textureRatioX = textureRatioX;
			_render.textureRatioY = textureRatioY;
			_heatFilterTask.heatMap = _renderTexture;
			_render.render(collector, _renderTexture.getTextureForStage3D(stage3DProxy));
		}
		
		override public function dispose():void
		{
			super.dispose();
			_renderTexture.dispose();
		}
		
		override public function set textureWidth(value : int):void
		{
			super.textureWidth = value;
			_renderTexture.width = value;
		}
		
		override public function set textureHeight(value:int):void
		{
			super.textureHeight = value;
			_renderTexture.height = value;
		}
		
		/**
		 * 热扰动强度 
		 */
		public function get disturb():Number
		{
			return _heatFilterTask.disturb;
		}
		
		/**
		 * @private
		 */
		public function set disturb(value:Number):void
		{
			_heatFilterTask.disturb = value;
		}
		
	}
}