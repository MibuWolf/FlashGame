package Logic
{
	import Component.Scene.SceneComponent;
	
	import Core.GameRoot;
	import Core.Renderable.A3DSun;
	import Core.Renderable.A3DSkyBox;
	import Core.Renderable.A3DTerrain;
	
	import ash.core.Entity;
	import ash.tools.ComponentPool;
	
	import away3d.primitives.SkyBox;
	
	import flash.geom.Vector3D;

	public class LogicEntityManager
	{
		static private var _instance:LogicEntityManager;
		
		public function LogicEntityManager()
		{
			
		}
		
		
		static public function getInstance():LogicEntityManager
		{
			if( !_instance )
			{
				_instance = new LogicEntityManager();
			}
			
			return _instance;
		}
		
		
		public function changeScene():Entity
		{
			var entity:Entity = new Entity();
			var sceneComponent:SceneComponent = ComponentPool.get( SceneComponent );
			
			sceneComponent.terrain = new A3DTerrain( "E:/Code/flashgame/bin-debug/embeds/terrain/terrain_diffuse.jpg","E:/Code/flashgame/bin-debug/embeds/terrain/terrain_heights.jpg" );
			
			sceneComponent.skyBox = new A3DSkyBox( "E:/Code/flashgame/bin-debug/embeds/skybox/posx.jpg", "E:/Code/flashgame/bin-debug/embeds/skybox/negx.jpg",
				"E:/Code/flashgame/bin-debug/embeds/skybox/posy.jpg", "E:/Code/flashgame/bin-debug/embeds/skybox/negy.jpg",
				"E:/Code/flashgame/bin-debug/embeds/skybox/posz.jpg", "E:/Code/flashgame/bin-debug/embeds/skybox/negz.jpg" );
			
			var array:Array = new Array();
			var sunPos:Vector3D = new Vector3D( 0, 4000, 3000 );
			
			array.push( {name:"E:/Code/flashgame/bin-debug/embeds/lensflare/flare10.jpg",size:3.2,postion:-0.01,opacity:147.9} );
			array.push( {name:"E:/Code/flashgame/bin-debug/embeds/lensflare/flare11.jpg",size:4.8,postion:0,opacity:30.6} );
			array.push( {name:"E:/Code/flashgame/bin-debug/embeds/lensflare/flare0.jpg",size:2,postion:0,opacity:25.5} );
			array.push( {name:"E:/Code/flashgame/bin-debug/embeds/lensflare/flare7.jpg",size:3,postion:0,opacity:15.5} );
			array.push( {name:"E:/Code/flashgame/bin-debug/embeds/lensflare/flare12.jpg",size:0.4,postion:0.36,opacity:27.9} );
			array.push( {name:"E:/Code/flashgame/bin-debug/embeds/lensflare/flare4.jpg",size:0.2,postion:0.31,opacity:20.4} );
			array.push( {name:"E:/Code/flashgame/bin-debug/embeds/lensflare/flare5.jpg",size:1,postion:0,opacity:36.8} );
			array.push( {name:"E:/Code/flashgame/bin-debug/embeds/lensflare/flare6.jpg",size:1.2,postion:0.96,opacity:36.7} );
			array.push( {name:"E:/Code/flashgame/bin-debug/embeds/lensflare/flare1.jpg",size:1.72,postion:1.2,opacity:40.2} );
			array.push( {name:"E:/Code/flashgame/bin-debug/embeds/lensflare/flare8.jpg",size:2.72,postion:1.48,opacity:46.9} );
			array.push( {name:"E:/Code/flashgame/bin-debug/embeds/lensflare/flare9.jpg",size:0.5,postion:1.82,opacity:52.3} );
			array.push( {name:"E:/Code/flashgame/bin-debug/embeds/lensflare/flare10.jpg",size:3.2,postion:2.1,opacity:59.6} );
			array.push( {name:"E:/Code/flashgame/bin-debug/embeds/lensflare/flare2.jpg",size:2,postion:2.36,opacity:68.4} );
			
			sceneComponent.sun = new A3DSun( "E:/Code/flashgame/bin-debug/embeds/lensflare/flare2.jpg", sunPos, array );
			
			entity.add( sceneComponent );
			
			GameRoot.getInstance().ashEngine.addEntity( entity );
			return entity;
		}
		
		
	}
}