package away3d.filters.tasks
{
	import away3d.cameras.Camera3D;
	import away3d.core.managers.Stage3DProxy;
	import away3d.filters.tasks.Filter3DTaskBase;
	import away3d.textures.RenderTexture;
	
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.textures.Texture;
	
	/**
	 * 热扰动 
	 * @author vancopper
	 * 
	 */    
	public class Filter3DHeatHazeTask extends Filter3DTaskBase
	{
		private var _data:Vector.<Number>;
		public var heatMap:RenderTexture;
		
		public function Filter3DHeatHazeTask()
		{
			_data = Vector.<Number>([1, 1, 0.015, 1, 2, 2, 0, 0]);
		}
		
		override protected function getFragmentCode():String
		{
			var code:String = "";
			
			code += "tex ft1, v0, fs1 <2d, nearest>\n"
				+ "mul ft0,ft1,fc1\n"
				+ "sub ft0,ft0,fc0\n"
				+ "mul ft0,ft0,fc0.z\n"
				+ "add ft0,v0,ft0\n"
				+ "tex oc, ft0, fs0 <2d, nearest>\n";
			return code;
		}
		
		override public function activate(stage3DProxy:Stage3DProxy, camera:Camera3D, depthTexture:Texture):void
		{
			stage3DProxy.context3D.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);
			stage3DProxy.context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, _data, 2);
			stage3DProxy.context3D.setTextureAt(1, heatMap.getTextureForStage3D(stage3DProxy));
		}
		
		override public function deactivate(stage3DProxy:Stage3DProxy):void
		{
			stage3DProxy.context3D.setTextureAt(1, null);
		}
		
		/**
		 * 扰动强度 
		 */
		public function get disturb():Number
		{
			return _data[2];
		}
		
		/**
		 * @private
		 */
		public function set disturb(value:Number):void
		{
			_data[2] = value;
		}
		
	}
}