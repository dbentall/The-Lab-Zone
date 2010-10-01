package  
{
	import Box2D.Collision.Shapes.b2CircleDef;
	import Box2D.Collision.Shapes.b2PolygonDef;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Daniel Bentall
	 */
	public class ObjectCreator extends Actor
	{
		
		public function ObjectCreator(parent:DisplayObjectContainer, sprite:Sprite, isSquare:Boolean = true, friction:Number = 0.5, density:Number = 1, restitution:Number = 0.4) {
			
			parent.addChild(sprite);
			
			if (isSquare) {
				//var objectShapeDef:b2PolygonDef = new b2PolygonDef();
				//objectShapeDef.setAsBox(sprite.width / 2 / PhysiVals.met2pix, sprite.height / 2 / PhysiVals.met2pix);
			}
			else {
				var objectShapeDef:b2CircleDef = new b2CircleDef();
				objectShapeDef.radius = sprite.width / 2 / PhysiVals.met2pix;
			}
			objectShapeDef.density = density;
			objectShapeDef.friction = friction;
			objectShapeDef.restitution = restitution;
			
			var objectBodyDef:b2BodyDef = new b2BodyDef();
			objectBodyDef.fixedRotation = true;
			
			var objectBody:b2Body = PhysiVals.world.CreateBody(objectBodyDef);
			objectBody.CreateShape(objectShapeDef);
			objectBody.SetMassFromShapes();
			
			super(objectBody, sprite);
		}
	}

}