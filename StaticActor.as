package  
{
	import Box2D.Collision.Shapes.b2PolygonDef;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Collision.Shapes.b2ShapeDef;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Daniel Bentall
	 */
	public class StaticActor extends Actor
	{
		
		public function StaticActor(parent:DisplayObjectContainer, location:Point, coords:Array, spriteToUse:Class = null) 
		{
			var body:b2Body = createBodyFromCoords(coords, location);
			var sprite:Sprite;
			if (spriteToUse != null) {
				sprite = new spriteToUse();
				parent.addChild(sprite);
			}
			else {
				sprite = createSpriteFromCoords(coords, location, parent);
			}
			
			super(body, sprite);
		}
		
		private function createSpriteFromCoords(coords: Array, location:Point, parent:DisplayObjectContainer):Sprite
		{
			var newSprite:Sprite = new Sprite();
			newSprite.graphics.lineStyle(2, 0x008000);
			for each (var listOfPoints:Array in coords) {
				var firstPoint:Point = listOfPoints[0];
				newSprite.graphics.moveTo(firstPoint.x, firstPoint.y);
				newSprite.graphics.beginFill(0x008000);
				
				for each (var newPoint:Point in listOfPoints) {
					newSprite.graphics.lineTo(newPoint.x, newPoint.y);
				}
				
				newSprite.graphics.lineTo(firstPoint.x, firstPoint.y);
				newSprite.graphics.endFill();
			}
			
			newSprite.x = location.x;
			newSprite.y = location.y;
			parent.addChild(newSprite);
			
			return newSprite;
		}
		
		private function createBodyFromCoords(coords:Array, location:Point):b2Body
		{
			var allShapeDefs:Array = [];
			
			for each(var listOfPoints:Array in coords) {
				var newShapeDef:b2PolygonDef = new b2PolygonDef();
				newShapeDef.vertexCount = listOfPoints.length;
				for (var i:int = 0; i < listOfPoints.length; i++) {
					var nextPoint:Point = listOfPoints[i];
					b2Vec2(newShapeDef.vertices[i]).Set(nextPoint.x / PhysiVals.met2pix, nextPoint.y / PhysiVals.met2pix);
				}
				newShapeDef.restitution = 0.2;
				newShapeDef.friction = 0.5;
				newShapeDef.density = 0;
				
				allShapeDefs.push(newShapeDef);
			}
			var staticBodyDef:b2BodyDef = new b2BodyDef();
			staticBodyDef.position.Set(location.x / PhysiVals.met2pix, location.y / PhysiVals.met2pix);
			
			var staticBody:b2Body = PhysiVals.world.CreateBody(staticBodyDef);
			
			for each(var newShapeDefToAdd:b2ShapeDef in allShapeDefs) {
				staticBody.CreateShape(newShapeDefToAdd);
			}
			staticBody.SetMassFromShapes();
			
			return staticBody;
		}
	}
}