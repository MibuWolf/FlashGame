package Core
{
	import Camera.CameraManager;
	import Camera.CameraType;
	
	import Logic.LogicEntityManager;
	
	import System.MoveControlSystem;
	import System.MovementSystem;
	import System.RenderObjectSystem;
	import System.SceneSystem;
	import System.SystemPriority;
	
	import ash.core.Engine;
	
	import away3d.cameras.Camera3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.core.managers.Stage3DManager;
	import away3d.core.managers.Stage3DProxy;
	import away3d.core.render.RendererBase;
	import away3d.debug.Trident;
	import away3d.events.Stage3DEvent;
	import away3d.lights.DirectionalLight;
	import away3d.materials.lightpickers.LightPickerBase;
	import away3d.materials.lightpickers.StaticLightPicker;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;

	public class GameRoot
	{	
		// away3d相关
		private var _stage3DManger:Stage3DManager;
		private var _stage3DProxy:Stage3DProxy;
		private var _profile:String = "baseline"
		private var _view:View3D;
		private var _viewSecond:View3D;
		private var _mainLight:DirectionalLight;
		private var _mainLightPick:LightPickerBase;
		
		private var _ashEngine:Engine;
		private var _lastFrameTime:int;			// 上一帧执行的机器时间
		
		private var _stage:Stage;					// 主舞台
		
		static private var _instance:GameRoot
		
		public function GameRoot()
		{
			_ashEngine = new Engine();
			getTimer()
		}
		
		
		/**
		 * 	获取ViewManager实例
		 * */
		static public function getInstance():GameRoot
		{
			if( !_instance )
			{
				_instance = new GameRoot();
			}
			
			return _instance;
		}
		
		
		/**
		 * 初始化
		 * */
		public function Init( __stage:Stage ):void
		{
			_stage = __stage;
			
			InitAway3D();
			InitEventListener();
		}
		
		
		
		/**
		 * 创建View
		 * */
		public function CreateView( scene:Scene3D = null, camera:Camera3D = null, renderer:RendererBase = null, forceSoftware:Boolean = false ):View3D
		{
			if( _view )
			{
				_view.dispose();
				_view = null;
			}
		
			_view = new View3D( scene, camera, renderer, forceSoftware, _profile );
			_view.stage3DProxy = _stage3DProxy;	
			_stage.addChild( _view );
			onResize(null);
			
			_view.camera.lens.far = 10000;
			_view.camera.lens.near = 1;
			_view.camera.y = 300;
			
			
			_mainLight = new DirectionalLight(300, -300, -5000);
			_mainLight.color = 0xfffdc5;
			_mainLight.ambient = 1;
			_view.scene.addChild(_mainLight);
			
			var t:Trident = new Trident( 500 );
			t.x = -50;	t.y =290; t.z = -1000;
			_view.scene.addChild( t );
			
			_mainLightPick = new StaticLightPicker( [_mainLight] );
			
			CameraManager.getInstance().createCameraController( CameraType.FIRSTPERSONMODEL, _view.camera, null, 180, 0 );
			
			return _view;
		}
		
		
		
		/**
		 * 创建第二个View3D
		 * */
		public function CreateSecondView( scene:Scene3D = null, camera:Camera3D = null, renderer:RendererBase = null, forceSoftware:Boolean = false ):View3D
		{
			if( _viewSecond )
			{
				_viewSecond.dispose();
				_viewSecond = null;
			}
			
			_viewSecond = new View3D( scene, camera, renderer, forceSoftware, _profile );
			
			_viewSecond.stage3DProxy = _stage3DProxy;
			_viewSecond.shareContext = true;
			
			return _viewSecond;
		}
		
		
		
		/**
		 * 初始化away3d
		 * */
		private function InitAway3D():void
		{
			if( !_stage3DManger && _stage )
			{
				_stage3DManger = Stage3DManager.getInstance( _stage );
				_stage3DProxy = _stage3DManger.getFreeStage3DProxy( false, _profile );
				_stage3DProxy.addEventListener( Stage3DEvent.CONTEXT3D_CREATED, onContextCreated );
				_stage3DProxy.antiAlias = 0;
			}
			else
			{
				onContextCreated( null );
			}
		}
		
		
		/**
		 * 初始化侦听
		 * */
		private function InitEventListener():void
		{
			_lastFrameTime = getTimer();
			this._stage.addEventListener( Event.ENTER_FRAME, onFrame );
			this._stage.addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
			this._stage.addEventListener( MouseEvent.MOUSE_UP, onMouseUp );
			this._stage.addEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
			this._stage.addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
			this._stage.addEventListener( KeyboardEvent.KEY_UP, onKeyUp );
			this._stage.addEventListener( Event.RESIZE, onResize );
		}
		
		
		
		/**
		 * 创建完成真正开始初始化
		 * */
		private function onContextCreated(e:Stage3DEvent):void
		{
			_stage3DProxy.removeEventListener( Stage3DEvent.CONTEXT3D_CREATED, onContextCreated );
			
			this.CreateView();
			
			InitSystem();
			
			LogicEntityManager.getInstance().changeScene();
			LogicEntityManager.getInstance().CreatePlayer();
		}
		
		
		/**
		 * 初始化ecs系统
		 * */
		private function InitSystem():void
		{
			_ashEngine.addSystem( new SceneSystem(), SystemPriority.UPDATE );
			_ashEngine.addSystem( new RenderObjectSystem(), SystemPriority.UPDATE );
			_ashEngine.addSystem( new MovementSystem(), SystemPriority.UPDATE );
			_ashEngine.addSystem( new MoveControlSystem(), SystemPriority.UPDATE );
		}
		
		
		
		/**
		 * 鼠标按下事件回调
		 * */
		private function onMouseDown(e:MouseEvent):void
		{
			CameraManager.getInstance().onMouseDown( e );
		}
		
		
		/**
		 * 鼠标弹起事件回调
		 * */
		private function onMouseUp(e:MouseEvent):void
		{
			CameraManager.getInstance().onMouseUp( e );
		}
		
		
		
		/**
		 * 鼠标移动事件回调
		 * */
		private function onMouseMove(e:MouseEvent):void
		{
			CameraManager.getInstance().onMouseMove( e );
		}
		
		
		/**
		 * 鼠标按下事件回调
		 * */
		private function onKeyDown(e:KeyboardEvent):void
		{
			CameraManager.getInstance().onKeyDown( e );
		}
		
		
		/**
		 * 鼠标弹起事件回调
		 * */
		private function onKeyUp(e:KeyboardEvent):void
		{
			CameraManager.getInstance().onKeyUp( e );
		}
		
		
		/**
		 * 舞台大小发生变化
		 * */
		private function onResize(e:Event):void
		{
			if( this._view )
			{
				this._view.width = this.stage.stageWidth;
				this._view.height = this.stage.stageHeight;
			}
		}
		
		
		/**
		 * 帧回调
		 * */
		private function	onFrame( e:Event ):void
		{
			if( _view )
			{
				_view.render();
			}
			
			if( _viewSecond )
			{
				_viewSecond.render();
			}
			
			if( _ashEngine )
			{
				var curTime:int = getTimer();
				var deltTime:int = curTime - _lastFrameTime;
				CameraManager.getInstance().updata( deltTime );
				_ashEngine.update( deltTime );
				_lastFrameTime = curTime;
			}
		}
		

		public function get view():View3D
		{
			return _view;
		}

		public function set view(value:View3D):void
		{
			_view = value;
		}

		public function get stage():Stage
		{
			return _stage;
		}

		public function set stage(value:Stage):void
		{
			_stage = value;
		}

		public function get ashEngine():Engine
		{
			return _ashEngine;
		}

		public function set ashEngine(value:Engine):void
		{
			_ashEngine = value;
		}

		public function get mainLight():DirectionalLight
		{
			return _mainLight;
		}

		public function set mainLight(value:DirectionalLight):void
		{
			_mainLight = value;
		}

		public function get mainLightPick():LightPickerBase
		{
			return _mainLightPick;
		}

		public function set mainLightPick(value:LightPickerBase):void
		{
			_mainLightPick = value;
		}


	}
}