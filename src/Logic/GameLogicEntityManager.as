package Logic
{
	public class GameLogicEntityManager
	{
		static private var _instance:GameLogicEntityManager;
		
		public function GameLogicEntityManager()
		{
			
		}
		
		
		static public function getInstance():GameLogicEntityManager
		{
			if( !_instance )
			{
				_instance = new GameLogicEntityManager();
			}
			
			return _instance;
		}
		
		
		
		
	}
}