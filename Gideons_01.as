package  
{
	import Box2D.Collision.b2AABB;
	import Box2D.Collision.Shapes.b2CircleDef;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2World;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Daniel Bentall
	 */
	public class Gideons_01 extends Sprite
	{
		static var _allActors:Array;
		static var _actorsToRemove:Array;
		static var _player:PlayerActor;
		static var _mouseX:Number = 0;
		static var _mouseY:Number = 0;
		static var _platform:Sprite;
		private var timeElapsed:Number;
		
		public function Gideons_01() 
		{
			_platform = platform;
			_allActors = [];
			setupPhysicsWorld();
			makePlayer();
			createLevel();
			//setupDebugDraw();
			timeElapsed = 0;
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN,clickDown,false,0,true);
			stage.addEventListener(MouseEvent.MOUSE_UP,clickUp,false,0,true);
			stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP,keyUpHandler);
			addEventListener(Event.ENTER_FRAME, newFrame);
		}
		
		private function setupDebugDraw():void
		{
			var spriteToDrawOn:Sprite = new Sprite();
			addChild(spriteToDrawOn);
			
			var artistForHire:b2DebugDraw = new b2DebugDraw();
			artistForHire.m_sprite = spriteToDrawOn;
			artistForHire.m_drawScale = PhysiVals.met2pix;
			artistForHire.SetFlags(b2DebugDraw.e_shapeBit);
			artistForHire.m_lineThickness = 2;
			artistForHire.m_fillAlpha = 0.6;
			
			PhysiVals.world.SetDebugDraw(artistForHire);
		}
		
		private function newFrame(e:Event):void 
		{
			PhysiVals.world.Step(1 / PhysiVals.frameR, 10);
			for each (var actor:Actor in _allActors) {
				actor.updateNow();
			}
			
			reallyRemoveActors();
			_mouseX = root.mouseX;
			_mouseY = root.mouseY;
			timeElapsed += 1 / 60;
			
			var _enemy:PlayerActor;
			if (timeElapsed > 2) {
				_enemy = new PlayerActor(this, new Point(1200, 10), new EnemyClip());
				_enemy.addEventListener(PlayerEvent.BALL_OFF_SCREEN, playerOffScreen_h);
				_allActors.push(_enemy);
				timeElapsed = 0;
			}
		}
		
		private function reallyRemoveActors():void
		{
			var i:int = 0;
			for each (var removeMe:Actor in _actorsToRemove) {
				trace(removeMe._body);
				if (removeMe._body != null && removeMe._costume != null) {
					removeMe.destroy();
				}
				
				var actorIndex:int = _allActors.indexOf(removeMe);
				if (actorIndex > -1) {
					_allActors.splice(actorIndex, 1);
				}
				i++;
			}
			_actorsToRemove = [];
		}
		
		public function markForRemove(actorToRemove:Actor):void
		{
			if (_actorsToRemove.indexOf(actorToRemove, 0) < 0) {
				_actorsToRemove.push(actorToRemove);
			}
		}
		
		private function makePlayer():void
		{
			_player = new PlayerActor(this, new Point(200, 10), new PlayerClip(), true);
			_player.addEventListener(PlayerEvent.BALL_OFF_SCREEN, playerOffScreen_h);
			_allActors.push(_player);
			
		}
		
		private function playerOffScreen_h(e:PlayerEvent):void 
		{
			//trace("player off screen");
			var playerToRemove:PlayerActor = PlayerActor(e.currentTarget);
			markForRemove(playerToRemove);
			playerToRemove.removeEventListener(PlayerEvent.BALL_OFF_SCREEN, playerOffScreen_h);
		}
		
		private function createLevel():void
		{
			var platform:Platforms = new Platforms(this);
		}
		
		private function setupPhysicsWorld():void
		{
			var worldBounds:b2AABB = new b2AABB();
			worldBounds.lowerBound.Set( -5000 / PhysiVals.met2pix, -5000 / PhysiVals.met2pix);
			worldBounds.upperBound.Set( 5000 / PhysiVals.met2pix, 5000 / PhysiVals.met2pix);
			
			PhysiVals.world = new b2World(worldBounds, PhysiVals.gravity, true);
			PhysiVals.world.SetContactListener(new PuggleContactListener());
		}
		
		protected function clickDown(mouse:MouseEvent):void {
			_player.shoot_f = true;
		}
		
		protected function clickUp(mouse:MouseEvent):void{
			_player.shoot_f = false;
		}
		
		protected function keyDownHandler(event:KeyboardEvent):void{
			switch( event.charCode )
			{
				case 32:
					_player.jump_f = true;
					break;
					
				case 115:
					//_player.jump_f = true;
					break;
					
				case 97:
					_player.left_f = true;
					break;
					
				case 100:
					_player.right_f = true;
					break;
			}
    		//trace("Key Pressed: " + /*String.fromCharCode(event.charCode) +*/ " (character code: " + event.charCode + ")");
		}
		
		protected function keyUpHandler(event:KeyboardEvent):void
		{
			switch( event.charCode )
			{
				case 32:
					_player.jump_f = false;
					break;
					
				case 115:
					//down = false;
					break;
					
				case 97:
					_player.left_f = false;
					break;
					
				case 100:
					_player.right_f = false;
					break;
			}
		}
	}
}