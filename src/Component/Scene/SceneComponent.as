package Component.Scene
{
	import Component.IComponet;
	
	import Core.Renderable.A3DSun;
	import Core.Renderable.A3DSkyBox;
	import Core.Renderable.A3DTerrain;

	public class SceneComponent extends IComponet
	{
		private var _terrain:A3DTerrain;
		private var _skyBox:A3DSkyBox;
		private var _sun:A3DSun;
		
		public function SceneComponent()
		{
			
		}
		
		
		override public function dispose():void
		{
			if( _terrain )
			{
				_terrain.dispose();
				_terrain = null;
			}
			
			if( _skyBox )
			{
				_skyBox.dispose();
				_skyBox = null;
			}
		}
		

		public function get terrain():A3DTerrain
		{
			return _terrain;
		}

		public function set terrain(value:A3DTerrain):void
		{
			_terrain = value;
		}

		public function get skyBox():A3DSkyBox
		{
			return _skyBox;
		}

		public function set skyBox(value:A3DSkyBox):void
		{
			_skyBox = value;
		}

		public function get sun():A3DSun
		{
			return _sun;
		}

		public function set sun(value:A3DSun):void
		{
			_sun = value;
		}


	}
}