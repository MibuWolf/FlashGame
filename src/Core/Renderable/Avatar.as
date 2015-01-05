package Core.Renderable
{
	import away3d.animators.SkeletonAnimationSet;
	import away3d.animators.SkeletonAnimator;
	import away3d.animators.nodes.AnimationNodeBase;
	import away3d.animators.nodes.SkeletonClipNode;
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import away3d.events.AssetEvent;
	import away3d.events.LoaderEvent;
	import away3d.library.AssetLibrary;
	import away3d.library.AssetLibraryBundle;
	import away3d.library.assets.AssetType;
	import away3d.loaders.parsers.MD2Parser;
	
	import flash.utils.Dictionary;

	public class Avatar extends ObjectContainer3D
	{
		public static var bundles:Dictionary = new Dictionary();
				
		private var _ID:String;			// 模型ID
		private var _action:String;		// 当前动作
		private var _mesh:Mesh;			// 网格数据
		private var _type:String;		// 资源类型(之后会统一类型)
		
		
		public function Avatar( __ID:String, __type:String = "md2" )
		{
			_type = __type;
			ID = __ID
		}

		public function get ID():String
		{
			return _ID;
		}

		public function set ID(value:String):void
		{
			if( _ID == value )
				return;
			
			_ID = value;
			
			if( bundles[_ID] == null )
			{
				var  path:String = "embeds/Avatar/" + _ID + "/" + _ID + "." + _type;
				var loader:AssetLibraryBundle = AssetLibrary.getBundle( _ID );
				loader.load( path, null, null, new MD2Parser() );
				loader.addEventListener( AssetEvent.ASSET_COMPLETE, onAssetComplete, false, 0, false );
				loader.addEventListener( LoaderEvent.RESOURCE_COMPLETE, onResourceComplete, false, 0, false );
				bundles[_ID] = true;
			}
		}
		
		
		/**
		 * 播放动作
		 * @param 		__action 动作名称
		 * @param  		__bLoop 是否循环播放
		 * */
		public function Play( __action:String, __bLoop:Boolean = true ):void
		{
			if( _action == __action )
				return;
			
			if( !_mesh || !this._mesh.animator )
				return;
			
			var skeletonAni:SkeletonAnimator = this._mesh.animator as SkeletonAnimator;
			
			if( !skeletonAni || !skeletonAni.animationSet )
				return;
			
			if( !skeletonAni.animationSet.hasAnimation( _action ) )
			{
				trace(" Cannot Find action in AnimationSet  which name is  " + _action);
			}
			
			var animationNode:AnimationNodeBase = skeletonAni.animationSet.getAnimation( _action );
			if( !animationNode )
				return;
			
			var skeletonNode:SkeletonClipNode = animationNode as SkeletonClipNode;
			
			if( !skeletonNode )
				return;
			
			_action = __action;
			skeletonNode.looping = __bLoop;
			
			skeletonAni.play( _action );
		}
		
		
		
		private function onAssetComplete( e:AssetEvent ):void
		{
			var loader:AssetLibraryBundle = e.target as AssetLibraryBundle;
			loader.addEventListener( AssetEvent.ASSET_COMPLETE, onAssetComplete, false, 0, false );
			loader.addEventListener( LoaderEvent.RESOURCE_COMPLETE, onResourceComplete, false, 0, false );
			
			if( e.asset.assetType == AssetType.MESH )
			{
				if( _mesh )
				{
					_mesh.disposeWithAnimatorAndChildren();
				}
				
				_mesh = e.asset as Mesh;
			}
				
		}
		
		private function onResourceComplete( e:LoaderEvent ):void
		{
			
		}

	}
}