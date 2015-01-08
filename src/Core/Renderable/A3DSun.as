package Core.Renderable
{
	import Core.GameRoot;
	import Core.ResourcesManager;
	
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Sprite3D;
	import away3d.lights.PointLight;
	import away3d.materials.TextureMaterial;
	import away3d.textures.BitmapTexture;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	
	public class A3DSun extends ObjectContainer3D
	{
		private var sun:Sprite3D;													// 太阳
		private var sunLight:PointLight;											// 太阳光线
		private var flares:Vector.<FlareObject> = new Vector.<FlareObject>();		// 耀斑集合
		private var sunPostion:Vector3D;											// 太阳位置
		private var flareVisible:Boolean;
		
		public function A3DSun( name:String, sunPos:Vector3D, array:Array )
		{
			if( !array || array.length == 0 || !sunPos )
				return;
			
			for( var i:int = 0; i < array.length; ++i )
			{
				flares.push( new FlareObject( array[i].name, array[i].size, array[i].postion, array[i].opacity ) );
			}
			
			sunPostion = sunPos;
			
			GameRoot.getInstance().view.scene.addChild( this );
			
			ResourcesManager.getInstance().loadTexture( name, onLoadSprite );
		}
		
		
		private function onLoadSprite( sp:Bitmap ):void
		{
			if( !sp )
				return;
			
			var bitTex:BitmapTexture = new BitmapTexture( sp.bitmapData );
			var mat:TextureMaterial = new TextureMaterial( bitTex );
			mat.blendMode = BlendMode.ADD;
			sun = new Sprite3D( mat, sp.bitmapData.width, sp.bitmapData.height );
			this.sunLight = new PointLight();
			sunLight.ambient = 1;
			sunLight.diffuse = 2;
			
			sun.position = sunLight.position = sunPostion;
			sun.scale( 10 );
			this.addChild( sun );
			this.addChild( sunLight );
		}
		
		public function update():void
		{
			if( !sun )
				return;
			
			var flareVisibleOld:Boolean = flareVisible;
		
 			var sunScreenPosition:Vector3D = GameRoot.getInstance().view.project( sun.scenePosition );
			
			var xOffset:Number = sunScreenPosition.x - GameRoot.getInstance().stage.stageWidth/2;
			var yOffset:Number = sunScreenPosition.y - GameRoot.getInstance().stage.stageWidth/2;
			
			var flareObject:FlareObject;
			
			flareVisible = (sunScreenPosition.x > 0 && sunScreenPosition.x < GameRoot.getInstance().stage.stageWidth && sunScreenPosition.y > 0 &&
				sunScreenPosition.y  < GameRoot.getInstance().stage.stageHeight && sunScreenPosition.z > 0 )? true : false;
			
			//update flare visibility
			if (flareVisible != flareVisibleOld) 
			{
				for each (flareObject in flares) 
				{
					if( flareObject && flareObject.sprite )
					{
						if (flareVisible && !flareObject.sprite.parent)
							GameRoot.getInstance().stage.addChild( flareObject.sprite );
						else if(flareObject.sprite.parent)
						{
							GameRoot.getInstance().stage.removeChild(flareObject.sprite);
						}
					}

				}
			}

			//update flare position
			if (flareVisible) {
				
				var flareDirection:Point = new Point(xOffset, yOffset);
				var i:int = 0;
				for each (flareObject in flares) 
				{
					if( flareObject && flareObject.sprite )
					{
						flareObject.sprite.x = sunScreenPosition.x - flareDirection.x*flareObject.position - flareObject.sprite.width/2;
						flareObject.sprite.y = sunScreenPosition.y - flareDirection.y*flareObject.position - flareObject.sprite.height/2;
					}
				}
			}
		}
	}
}



import Core.ResourcesManager;

import away3d.containers.ObjectContainer3D;
import away3d.entities.Sprite3D;
import away3d.materials.TextureMaterial;
import away3d.textures.BitmapTexture;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.BitmapDataChannel;
import flash.geom.Point;



class FlareObject
{
	private var flareSize:Number = 144;
	
	public var sprite:Bitmap;
	
	public var size:Number;
	
	public var position:Number;
	
	public var opacity:Number;
	
	/**
	 * Constructor
	 */
	public function FlareObject( spriteName:String, size:Number, position:Number, opacity:Number ) 
	{
		if( !spriteName )
			return;
		
		ResourcesManager.getInstance().loadTexture( spriteName, onLoadSprite );
		this.size = size;
		this.position = position;
		this.opacity = opacity;
	}
	
	
	private function onLoadSprite( sp:Bitmap ):void
	{
		if( !sp )
			return;
		
		this.sprite = new Bitmap(new BitmapData(sp.bitmapData.width, sp.bitmapData.height, true, 0xFFFFFFFF));
		this.sprite.bitmapData.copyChannel(sp.bitmapData, sp.bitmapData.rect, new Point(), BitmapDataChannel.RED, BitmapDataChannel.ALPHA);
		this.sprite.alpha = opacity/100;
		this.sprite.smoothing = true;
		this.sprite.scaleX = this.sprite.scaleY = size*flareSize/sprite.width;
		this.size = size;
		this.position = position;
		this.opacity = opacity;
	}
}