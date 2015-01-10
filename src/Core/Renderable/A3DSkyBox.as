package Core.Renderable
{
	import Core.ResourcesManager;
	
	import away3d.containers.ObjectContainer3D;
	import away3d.primitives.SkyBox;
	import away3d.textures.BitmapCubeTexture;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	public class A3DSkyBox  extends ObjectContainer3D
	{
		private var _skyBox:SkyBox;						// 天空盒
		private var _cubeTexture:String;				// 天空盒纹理
		
		// 天空盒的六个面的数据
		private var _posX:BitmapData;	
		private var _negX:BitmapData;
		private var _posY:BitmapData;
		private var _negY:BitmapData;
		private var _posZ:BitmapData;
		private var _negZ:BitmapData;
		
		public function A3DSkyBox( posX:String, negX:String, posY:String, negY:String, posZ:String, negZ:String )
		{
			if( posX )
			{
				ResourcesManager.getInstance().loadTexture( posX, onLoadPosX );
			}
			
			if( negX )
			{
				ResourcesManager.getInstance().loadTexture( negX, onLoadNegX );
			}
			
			if( posY )
			{
				ResourcesManager.getInstance().loadTexture( posY, onLoadPosY );
			}
			
			if( negY )
			{
				ResourcesManager.getInstance().loadTexture( negY, onLoadNegY );
			}
			
			if( posZ )
			{
				ResourcesManager.getInstance().loadTexture( posZ, onLoadPosZ );
			}
			
			if( negZ )
			{
				ResourcesManager.getInstance().loadTexture( negZ, onLoadNegZ );
			}
		}
		
		
		private function onLoadPosX( bitmap:Bitmap ):void
		{
			if( bitmap )
			{
				_posX = bitmap.bitmapData;
			}
			
			initSkyBox();
		}
		
		private function onLoadPosY( bitmap:Bitmap ):void
		{
			if( bitmap )
			{
				_posY = bitmap.bitmapData;
			}
			
			initSkyBox();
		}
		
		private function onLoadPosZ( bitmap:Bitmap ):void
		{
			if( bitmap )
			{
				_posZ = bitmap.bitmapData;
			}
			
			initSkyBox();
		}
		
		private function onLoadNegX( bitmap:Bitmap ):void
		{
			if( bitmap )
			{
				_negX = bitmap.bitmapData;
			}
			
			initSkyBox();
		}
		
		private function onLoadNegY( bitmap:Bitmap ):void
		{
			if( bitmap )
			{
				_negY = bitmap.bitmapData;
			}
			
			initSkyBox();
		}
		
		private function onLoadNegZ( bitmap:Bitmap ):void
		{
			if( bitmap )
			{
				_negZ = bitmap.bitmapData;
			}
			
			initSkyBox();
		}
		
		private function initSkyBox():void
		{
			if( _posX && _posY && _posZ && _negX && _negY && _negZ )
			{
				if( this._skyBox )
				{
					this._skyBox.dispose();
					this._skyBox = null;
				}

				var cube:BitmapCubeTexture = new BitmapCubeTexture( _posX, _negX, _posY, _negY, _posZ, _negZ );
				this._skyBox = new SkyBox( cube );
				
				this.addChild( this._skyBox );
			}
		}
		
		
		override public function dispose():void
		{
			super.dispose();
			
			if( this._skyBox )
			{
				this._skyBox.dispose();
				this._skyBox = null;
			}
			
			if( _posX )
			{
				_posX.dispose();
				_posX = null;
			}
			
			if( _negX )
			{
				_negX.dispose();
				_negX = null;
			}
			
			if( _posY )
			{
				_posY.dispose();
				_posY = null;
			}
			
			if( _negY )
			{
				_negY.dispose();
				_negY = null;
			}
			
			if( _posZ )
			{
				_posZ.dispose();
				_posZ = null;
			}
			
			if( _negZ )
			{
				_negZ.dispose();
				_negZ = null;
			}
		}

		public function get skyBox():SkyBox
		{
			return _skyBox;
		}

		public function set skyBox(value:SkyBox):void
		{
			_skyBox = value;
		}

	}
}