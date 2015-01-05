package 
{
	import Core.GameRoot;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	

	
	public class Game extends Sprite
	{
		public function Game()
		{
			this.addEventListener( Event.ADDED_TO_STAGE, init );
		}
		
		private function init( e:Event ):void
		{
			this.removeEventListener( Event.ADDED_TO_STAGE, init );
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.stageFocusRect = false;
			GameRoot.getInstance().Init( this.stage );
		}
		
	}
}

