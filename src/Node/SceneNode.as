package Node
{
	import Component.Scene.SceneComponent;
	
	import ash.core.Node;

	public class SceneNode extends Node
	{
		private var _scene:SceneComponent;
		
		public function SceneNode()
		{
		}

		public function get scene():SceneComponent
		{
			return _scene;
		}

		public function set scene(value:SceneComponent):void
		{
			_scene = value;
		}

	}
}