package Core.Renderable
{
	import Core.GameRoot;
	import Core.ResourcesManager;
	
	import away3d.animators.SkeletonAnimationSet;
	import away3d.animators.SkeletonAnimator;
	import away3d.animators.data.Skeleton;
	import away3d.animators.nodes.SkeletonClipNode;
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import away3d.events.AssetEvent;
	import away3d.library.AssetLibrary;
	import away3d.library.AssetLibraryBundle;
	import away3d.library.assets.AssetType;
	import away3d.loaders.parsers.AWD2Parser;
	import away3d.materials.TextureMaterial;
	import away3d.materials.methods.FogMethod;
	import away3d.materials.methods.HardShadowMapMethod;
	import away3d.textures.Texture2DBase;
	import away3d.utils.Cast;
	
	import flash.display.Bitmap;
	import flash.net.URLRequest;

	public class A3DMesh extends ObjectContainer3D
	{
		private var _path:String;
		
		private var _skeletonAnimationSet:SkeletonAnimationSet;
		private var _skeletonAnimator:SkeletonAnimator;
		private var _meshLoadOver:Boolean = false;
		
		private var _materialTex:Texture2DBase;
		private var _noramlTex:Texture2DBase;
		private var _specTex:Texture2DBase;
		private var _materialLoad:TextureMaterial;
		
		private var _curAction:String="Breathe";
		
		private var _mesh:Mesh;
		
		public function A3DMesh( name:String, tex:String, noramlTex:String, speTex:String )
		{		
			_path = name;
			var loaderBulde:AssetLibraryBundle = AssetLibrary.getBundle( name );
			loaderBulde.addEventListener(AssetEvent.ASSET_COMPLETE, onAssetComplete);
			loaderBulde.load(new URLRequest("D:/Away3d/Game/Game/bin-debug/embeds/assets/PolarBear.awd"), null,null,new AWD2Parser());	
			
			ResourcesManager.getInstance().loadTexture( tex, onLoadTexture );
			ResourcesManager.getInstance().loadTexture( noramlTex, onLoadNoramlTexture );
			ResourcesManager.getInstance().loadTexture( speTex, onLoadSpeTexture );
		}
		
		private function onAssetComplete(event:AssetEvent):void
		{
			if (event.asset.assetType == AssetType.SKELETON) {
				//create a new skeleton animation set
				_skeletonAnimationSet = new SkeletonAnimationSet(3);
				
				//wrap our skeleton animation set in an animator object and add our sequence objects
				var skeletonAnimator:SkeletonAnimator = new SkeletonAnimator(_skeletonAnimationSet, event.asset as Skeleton, false);
				
				//apply our animator to our mesh
				_mesh.animator = skeletonAnimator;
				
			} else if (event.asset.assetType == AssetType.ANIMATION_NODE) {
				//create animation objects for each animation node encountered
				var animationNode:SkeletonClipNode = event.asset as SkeletonClipNode;
				
				_skeletonAnimationSet.addAnimation(animationNode);
			} else if (event.asset.assetType == AssetType.MESH) {
				_mesh = event.asset as Mesh;
					
					if( _materialLoad )
					{
						this._mesh.material = _materialLoad;
					}
					
					this._mesh.castsShadows = true;
					_meshLoadOver = true;
					_mesh.x = _mesh.y = _mesh.z = 0;
					_mesh.scale( 0.1 );
					
					this.addChild( _mesh )

			}
		}
		
		
		private function onLoadTexture( sp:Bitmap ):void
		{
			this._materialTex = Cast.bitmapTexture( sp );
			
			if( _noramlTex && _specTex )
			{
				initMaterial();
			}
		}
		
		
		private function onLoadNoramlTexture( sp:Bitmap ):void
		{
			this._noramlTex = Cast.bitmapTexture( sp );
			
			if( _noramlTex && _materialTex )
			{
				initMaterial();
			}
		}
		
		private function onLoadSpeTexture( sp:Bitmap ):void
		{
			this._specTex = Cast.bitmapTexture( sp );
			
			if( _materialTex && _specTex )
			{
				initMaterial();
			}
		}
		
		private function initMaterial():void
		{
			if( _materialLoad )
				_materialLoad.dispose();
			
			_materialLoad = new TextureMaterial(_materialTex);
			_materialLoad.shadowMethod = new HardShadowMapMethod( GameRoot.getInstance().mainLight );;
			_materialLoad.normalMap = Cast.bitmapTexture(_noramlTex);
			_materialLoad.specularMap = Cast.bitmapTexture(_specTex);
			_materialLoad.addMethod(new FogMethod(0, 3000, 0x5f5e6e));
			_materialLoad.lightPicker = GameRoot.getInstance().mainLightPick;
			
			if( _meshLoadOver )
			{
				this._mesh.material = _materialLoad;
			}
		}
		
		
		public function Play( name:String ):void
		{
			_curAction = name;
			if( !_meshLoadOver )
				return;
			
			if( ( this._mesh.animator as SkeletonAnimator ).animationSet.hasAnimation( name ) )	
			{
				( this._mesh.animator as SkeletonAnimator ).play( name );
			}
		}
		
		public function updata():void
		{
			// 消除动作中的位移(临时方案)
			if( _mesh )
			{
				_mesh.x = _mesh.y = _mesh.z = 0;
			}
		}
		
		
		override public function dispose():void
		{
			super.dispose();
			_mesh.dispose();
			_mesh = null;
			_materialLoad = null;
			_materialTex = null;
			_noramlTex = null;
			_specTex = null;
			_skeletonAnimationSet = null;
			_skeletonAnimator = null;
			_meshLoadOver = false;
			_path = null;
		}

		public function get mesh():Mesh
		{
			return _mesh;
		}

		public function set mesh(value:Mesh):void
		{
			_mesh = value;
		}

	}
}