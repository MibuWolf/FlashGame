package Component.Scene
{
	import Component.IComponet;
	
	import Core.Renderable.SceneObject;

	public class SceneComponent extends IComponet
	{
		private var _scene:SceneObject;
		
		public function SceneComponent()
		{
			
		}
		
		
		override public function dispose():void
		{
			_scene.dispose();
			_scene = null;
		}
		

		public function get scene():SceneObject
		{
			return _scene;
		}

		public function set scene(value:SceneObject):void
		{
			_scene = value;
		}

	}
}