package Node
{
	import Component.Movement.MovementComponent;
	import Component.Scene.ContainerComponent;
	
	import ash.core.Node;
	
	import away3d.core.render.PositionRenderer;

	public class MovementNode extends Node
	{		
		public var container:ContainerComponent;			// 容器
		public var postion:MovementComponent;				// 移动
	}
}