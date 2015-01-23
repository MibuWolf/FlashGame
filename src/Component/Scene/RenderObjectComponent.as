package Component.Scene
{
	import Component.IComponent;
	
	import Core.Renderable.A3DMesh;

	/**
	 * 场景中的渲染对象包含了 渲染对象容器 渲染模型 位置信息
	 * */
	public class RenderObjectComponent  extends IComponent
	{
		private var _name:String="";
		private var _tex:String="";
		private var _noramlTex:String="";
		private var _speTex:String="";
		private var _action:String="";
		
		private var _mesh:A3DMesh;
		
		public function RenderObjectComponent()
		{
			
		}
		
		
		override public function dispose():void
		{
			if( _mesh )
			{
				_mesh.dispose();
				_mesh = null;
			}
			
			_name = _tex = _noramlTex = _speTex = _action = "";
		}

		
		public function get mesh():A3DMesh
		{
			return _mesh;
		}

		public function set mesh(value:A3DMesh):void
		{
			_mesh = value;
		}

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		public function get tex():String
		{
			return _tex;
		}

		public function set tex(value:String):void
		{
			_tex = value;
		}

		public function get noramlTex():String
		{
			return _noramlTex;
		}

		public function set noramlTex(value:String):void
		{
			_noramlTex = value;
		}

		public function get speTex():String
		{
			return _speTex;
		}

		public function set speTex(value:String):void
		{
			_speTex = value;
		}

		public function get action():String
		{
			return _action;
		}

		public function set action(value:String):void
		{
			if( _action == value )
				return;
			
			_action = value;
			
			if( _mesh )
				_mesh.Play( _action );
		}


	}
}