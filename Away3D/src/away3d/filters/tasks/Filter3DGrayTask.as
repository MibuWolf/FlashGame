package away3d.filters.tasks
{
	import away3d.cameras.Camera3D;
	import away3d.core.managers.Stage3DProxy;
	
	import flash.display3D.Context3DProgramType;
	import flash.display3D.textures.Texture;

	public class Filter3DGrayTask extends Filter3DTaskBase
	{
		private var _data:Vector.<Number>;
		
		public function Filter3DGrayTask()
		{
			super();
			_data = Vector.<Number>([ 0.3, 0.59, 0.11, 0 ]);
		}
		
		
		override protected function getFragmentCode():String
		{
			var code:String = "";
						
			code += "tex ft0, v0, fs0 <2d,linear,clamp>\n";
			code += "mul ft0.x, ft0.x, fc0.x\n";
			code += "mul ft0.y, ft0.y, fc0.y\n";
			code += "mul ft0.z, ft0.z, fc0.z\n";
			code += "add ft0.x, ft0.x, ft0.y\n";
			code += "add ft0.x, ft0.x, ft0.z\n";
			code += "mov ft0.y, ft0.x\n";
			code += "mov ft0.z, ft0.x\n";
			code += "mov oc, ft0";
			
			return code;
		}
		
		override public function activate(stage3DProxy:Stage3DProxy, camera3D:Camera3D, depthTexture:Texture):void
		{
			stage3DProxy.context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, _data, 1);
		}
	}
}