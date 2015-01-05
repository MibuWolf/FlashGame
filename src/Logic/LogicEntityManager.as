package Logic
{
	import Component.Scene.SceneComponent;
	
	import Core.Renderable.SceneObject;
	
	import ash.core.Entity;
	import ash.tools.ComponentPool;

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
		
		
		public function changeScene( terrainTex:String = null, terrainHTex:String = null, cubeTex:String = null, objName:String = null ):Entity
		{
			var entity:Entity = new Entity();
			var sceneComponent:SceneComponent = ComponentPool.get( SceneComponent );
			sceneComponent.scene = new SceneObject( terrainTex, terrainHTex, cubeTex, objName );
			entity.add( sceneComponent );
			
			return entity;
		}
		
		
	}
}