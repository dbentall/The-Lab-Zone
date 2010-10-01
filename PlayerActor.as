package  
{
	import Box2D.Collision.Shapes.b2CircleDef;
	import Box2D.Collision.Shapes.b2PolygonDef;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;

	/**
	 * ...
	 * @author Daniel Bentall
	 */
	public class PlayerActor extends Actor
	{
		private static const BALL_DIAMETER:int = 40;
		var parent:DisplayObjectContainer;
		private var BulletVel:Number = 30;
		private var bulletTime:int = 0;
		private const bulletPeriod:int = 6;
		private var runForce = 20;
		private var jumpForce = 8;
		private var userControlled:Boolean;
		private var health:int;
		private const runSpeed:Number = 2;
		
		public function PlayerActor(parent:DisplayObjectContainer, location:Point, sprite:Sprite, userControlled:Boolean = false) 
		{	
			this.userControlled = userControlled;
			
			sprite.scaleX = BALL_DIAMETER / sprite.width;
			sprite.scaleY = BALL_DIAMETER / sprite.height;
			this.parent = parent;
			parent.addChild(sprite);
			
			var playerShapeDef:b2PolygonDef = new b2PolygonDef();
			playerShapeDef.SetAsBox(sprite.width / 2 / PhysiVals.met2pix, sprite.height / 2 / PhysiVals.met2pix);
			if (userControlled) {
				playerShapeDef.density = 1;
				playerShapeDef.friction = 0.6;
				playerShapeDef.restitution = 0.3;
				
			}
			else {
				playerShapeDef.density = 0.5;
				playerShapeDef.friction = 0.0;
				playerShapeDef.restitution = 1;
			}
			
			var playerBodyDef:b2BodyDef = new b2BodyDef();
			playerBodyDef.fixedRotation = true;
			playerBodyDef.position.Set(location.x / PhysiVals.met2pix, location.y / PhysiVals.met2pix);
			
			var playerBody:b2Body = PhysiVals.world.CreateBody(playerBodyDef);
			playerBody.CreateShape(playerShapeDef);
			playerBody.SetMassFromShapes();
			health = 100;
			
			super(playerBody, sprite);
		}
		
		public function takeDamage():void {
			health -= 10;
			if (health < 0) {
				Gideons_01._actorsToRemove.push(this);
			}
		}
		
		override protected function childSpecificUpdating():void 
		{
			if (_costume.y > _costume.stage.stageHeight) {
				dispatchEvent(new PlayerEvent(PlayerEvent.BALL_OFF_SCREEN));
			}
			if (!userControlled && this._body.GetLinearVelocity().Length() > runSpeed) {
				var newSpeed:b2Vec2 = this._body.GetLinearVelocity();
				Normalize(newSpeed);
				MultiplyByScalar(newSpeed, runSpeed);
				this._body.SetLinearVelocity(newSpeed);
			}
			
			playerActions();
			//trace((Gideons_01._mouseX - super._costume.x) + " " + (Gideons_01._mouseY - super._costume.y));
			super.childSpecificUpdating();
		}
		
		private function playerActions():void
		{
			if (userControlled) {
				if(_onGround_f){
					if (super._jump_f) {
						super._body.ApplyImpulse(new b2Vec2(0, -jumpForce) ,new b2Vec2(0, 0));
					}
					if (super._left_f) {
						super._body.ApplyForce(new b2Vec2(-runForce, 0) ,new b2Vec2(0, 0));
					}
					if (super._right_f) {
						super._body.ApplyForce(new b2Vec2(runForce, 0) ,new b2Vec2(0, 0));
					}
				}
				else {
					if (super._left_f) {
						super._body.ApplyForce(new b2Vec2(-runForce/2, 0) ,new b2Vec2(0, 0));
					}
					if (super._right_f) {
						super._body.ApplyForce(new b2Vec2(runForce/2, 0) ,new b2Vec2(0, 0));
					}
				}
				
				if (super._shoot_f && bulletTime > bulletPeriod) {
					var mouseDir:b2Vec2 = new b2Vec2(Gideons_01._mouseX - super._costume.x, Gideons_01._mouseY - super._costume.y);
					Normalize(mouseDir);
					MultiplyByScalar(mouseDir, BulletVel);
					var bullet:PegActor = new PegActor(parent, new Point(super._costume.x + mouseDir.x, super._costume.y + mouseDir.y), mouseDir);
					Gideons_01._allActors.push(bullet);
					//trace("bang!");
					bulletTime = 0;
				}
				
				bulletTime++;
				
			}
			else {
				var dir:b2Vec2 = new b2Vec2(Gideons_01._player._costume.x - this._costume.x, Gideons_01._player._costume.y - this._costume.y);
				Normalize(dir);
				MultiplyByScalar(dir, runForce);
				super._body.ApplyForce(dir, new b2Vec2(0, 0));
			}
		}
		
		private function MultiplyByScalar(vector:b2Vec2, scalar:Number):void
		{
			vector.x *= scalar;
			vector.y *= scalar;
		}
		
		private function Normalize(vector:b2Vec2):void
		{
			var length:Number = Math.sqrt(vector.x * vector.x + vector.y * vector.y);
			vector.x /= length;
			vector.y /= length;
		}
		
	}

}