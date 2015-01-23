package Node
{
	import Component.Scene.ContainerComponent;
	import Component.Scene.RenderObjectComponent;
	
	import ash.core.Node;

	public class RenderObjectNode extends Node
	{
		public var container:ContainerComponent;			// 容器
		public var renderObj:RenderObjectComponent;			// 渲染对象
	}
}