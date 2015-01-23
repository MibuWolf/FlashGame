package Component.Scene
{
	import Component.IComponent;
	
	import Core.Renderable.A3DSkyBox;
	import Core.Renderable.A3DSun;
	import Core.Renderable.A3DTerrain;
	import Core.Renderable.A3DWater;

	/**
	 * 场景组件包含了场景中的地形 天空盒 太阳 水等效果
	 * */
	public class SceneComponent extends IComponent
	{
		private var _terrain:A3DTerrain;
		private var _skyBox:A3DSkyBox;
		private var _sun:A3DSun;
		private var _water:A3DWater;
		
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
			
			if( _sun )
			{
				_sun.dispose();
				_sun = null;
			}
			
			if( _water )
			{
				_water.dispose();
				_water = null;
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

		public function get water():A3DWater
		{
			return _water;
		}

		public function set water(value:A3DWater):void
		{
			_water = value;
		}


	}
}