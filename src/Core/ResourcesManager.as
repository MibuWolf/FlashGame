package Core
{
	import away3d.events.AssetEvent;
	import away3d.events.LoaderEvent;
	import away3d.library.AssetLibrary;
	import away3d.library.AssetLibraryBundle;
	import away3d.textures.BitmapTexture;
	import away3d.utils.Cast;
	
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.loadingtypes.ImageItem;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;

	public class ResourcesManager
	{
		static private var _instance:ResourcesManager;
		
		public static var meshBundles:Dictionary = new Dictionary();
		public static var meshFuns:Dictionary = new Dictionary();
		public static var textureBundles:Dictionary = new Dictionary();
		public static var textureFuns:Dictionary = new Dictionary();
		public static var cubeBundles:Dictionary = new Dictionary();
		public static var cubeFuns:Dictionary = new Dictionary();
		
		public function ResourcesManager()
		{
			
		}
		
		
		/** 
		 * 获取资源管理器
		**/
		static public function getInstance():ResourcesManager
		{
			if( !_instance )
			{
				_instance = new ResourcesManager();
			}
			
			return _instance;
		}
		
		
		/** 
		 * 加载纹理资源
		 **/
		public function loadTexture( path:String, func:Function ):void
		{	
			if( textureBundles[path] == null )
			{
				var loader:BulkLoader = BulkLoader.getLoader( path );
				
				if( !loader )
					loader = new BulkLoader( path );
				
				loader.add( path,{id:path} );
				loader.addEventListener( Event.COMPLETE, onTextureResourceComplete );
				loader.start();
				textureBundles[path] = 1;
				
				if( !textureFuns.hasOwnProperty( path ) )
				{
					textureFuns[path] = new Vector.<Function>;
				}
				
				textureFuns[path].push( func );
			}
			else if( textureBundles[path] == 1 )
			{
				if( !textureFuns.hasOwnProperty( path ) )
				{
					textureFuns = new Vector.<Function>;
				}
				
				textureFuns[path].push( func );
			}
			else
			{
				func();
			}
		}
		
		
		private function onTextureAssetComplete( e:AssetEvent ):void
		{

		}
		
		private function onTextureResourceComplete( e:Event ):void
		{	
			var loader:BulkLoader = e.target as BulkLoader;
			loader.removeEventListener( Event.COMPLETE, onTextureResourceComplete );
			var url:String =  ImageItem(loader.items[0]).id;
			textureBundles[url] = 2;
			
			if( textureFuns.hasOwnProperty( url ) )
			{
				for( var i:int = 0; i < textureFuns[url].length; ++i )
				{
					var image:ImageItem = loader.items[0] as ImageItem;
					if( image )
					{
						textureFuns[url][i]( image.content );
					}
				}
			}
			
			textureFuns[url] = null;
		}
		
		/** 
		 * 加载模型资源
		 **/
		public function loadObject( path:String, func:Function ):void
		{
			
		}
		
		
		/** 
		 * 加载立方体纹理资源
		 **/
		public function loadCubeTexture( path:String, func:Function ):void
		{
			
		}
		
	}
}