package  
{
	import Box2D.Collision.Shapes.b2PolygonDef;
	import Box2D.Collision.Shapes.b2ShapeDef;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Daniel Bentall
	 */
	public class Platforms extends Actor
	{
		
		public function Platforms(parent:DisplayObjectContainer) 
		{			
			var platform:Sprite = Gideons_01._platform;
			var platformShapeDef:b2PolygonDef = new b2PolygonDef();
			platformShapeDef.SetAsBox(platform.width / 2 / PhysiVals.met2pix, platform.height / 2 / PhysiVals.met2pix);
			platformShapeDef.density = 0;
			platformShapeDef.friction = 0.6;
			platformShapeDef.restitution = 0.3;
			
			var allPlatforms:Array = [];
			for (var i:int = 0; i < platform.numChildren; i++) {
				allPlatforms.push(platform.getChildAt(i));
			}
			
			var allShapeDefs:Array = [];
			var allBodyDefs:Array = [];
			
			for each(var subPlatform:Sprite in allPlatforms) {
				var newShapeDef:b2PolygonDef = new b2PolygonDef();
				newShapeDef.SetAsBox(subPlatform.width / 2 / PhysiVals.met2pix, subPlatform.height / 2 / PhysiVals.met2pix);
				newShapeDef.restitution = 0.2;
				newShapeDef.friction = 0.5;
				newShapeDef.density = 0;
				
				allShapeDefs.push(newShapeDef);
				
				var staticBodyDef:b2BodyDef = new b2BodyDef();
				staticBodyDef.position.Set(subPlatform.x / PhysiVals.met2pix, subPlatform.y / PhysiVals.met2pix);
				
				allBodyDefs.push(staticBodyDef);
				
				var staticBody:b2Body = PhysiVals.world.CreateBody(staticBodyDef);
				
				staticBody.CreateShape(newShapeDef);
				staticBody.SetMassFromShapes();
				super(staticBody, platform);
			}
			
			
		}
		
		override protected function updateMyLook():void 
		{
			
		}
	}

}