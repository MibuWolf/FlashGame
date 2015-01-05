package Camera
{
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;

	public interface ICameraModel
	{
		
		// 键盘按下
		function onKeyDown(event:KeyboardEvent):void;
		
		// 键盘谈起
		function onKeyUp(event:KeyboardEvent):void;
		
		// 鼠标按下
		function onMouseDown(event:MouseEvent):void;
		
		// 鼠标弹起
		function onMouseUp(event:MouseEvent):void;
		
		// 鼠标移动
		function onMouseMove(event:MouseEvent):void;
		
		
		// 每帧更新
		function onUpdata(time:Number):void;
		
	}
}