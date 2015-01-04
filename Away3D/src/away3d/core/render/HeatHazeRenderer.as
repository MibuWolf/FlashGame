package away3d.core.render
{
	import flash.display3D.textures.TextureBase;
	
	import away3d.arcane;
	import away3d.cameras.Camera3D;
	import away3d.core.data.RenderableListItem;
	import away3d.core.render.RendererBase;
	import away3d.core.traverse.EntityCollector;
	import away3d.materials.MaterialBase;
	
	use namespace arcane;
	
	public class HeatHazeRenderer extends RendererBase
	{
		
		private var _activeMaterial:MaterialBase;
		
		public function HeatHazeRenderer()
		{
		}
		
		override protected function draw(entityCollector:EntityCollector, target:TextureBase):void
		{
			drawRenderables(entityCollector.particleRenderableHead, entityCollector, true);
			if (_activeMaterial)
			{
				_activeMaterial.deactivate(_stage3DProxy);
			}
			_activeMaterial = null;
		}
		
		private function drawRenderables(renderableListItem:RenderableListItem, entityCollector:EntityCollector, flag:Boolean):void
		{
			var numPasses:uint;
			var i:uint;
			var renderableListItem1:RenderableListItem;
			var heatHazeType:int;
			var camera:Camera3D = entityCollector.camera;
			while (renderableListItem) {
				_activeMaterial = renderableListItem.renderable.material;
				_activeMaterial.updateMaterial(_stage3DProxy.context3D);
				numPasses = _activeMaterial.numPasses;
				i = 0;
				do  
				{
					renderableListItem1 = renderableListItem;
					_activeMaterial.activatePass(i, _stage3DProxy, camera);
					do  
					{
						heatHazeType = renderableListItem1.renderable.sourceEntity.heatHazeType;
						if (heatHazeType != 0)
						{
							_activeMaterial.renderPass(i, renderableListItem1.renderable, _stage3DProxy, entityCollector, _rttViewProjectionMatrix);
						} 
						renderableListItem1 = renderableListItem1.next;
					} while (renderableListItem1 && renderableListItem1.renderable.material == _activeMaterial);
					
					_activeMaterial.deactivatePass(i, _stage3DProxy);
				} while (++i < numPasses)
				renderableListItem = renderableListItem1;
			}
		}
	}
}