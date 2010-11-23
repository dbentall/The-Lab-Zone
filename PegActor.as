package
{
	import Box2D.Collision.Shapes.b2CircleDef;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Daniel Bentall
	 */
	public class PegActor extends Actor
	{
		private static const PEG_DIAM:int = 4;
		
		private var _beenHit:Boolean;
		private var pegMovie:MovieClip;
		private var pegBody:b2Body;
		
		public function PegActor(parent:DisplayObjectContainer, location:Point, initVel:b2Vec2)
		{
			_beenHit = false;
			
			pegMovie = new PegMovie();
			pegMovie.scaleX = PEG_DIAM / PhysiVals.met2pix;
			pegMovie.scaleY = PEG_DIAM / PhysiVals.met2pix;
			parent.addChild(pegMovie);
			
			var pegShapeDef:b2CircleDef = new b2CircleDef();
			pegShapeDef.radius = PEG_DIAM / 2 / PhysiVals.met2pix;
			pegShapeDef.density = 1;
			pegShapeDef.friction = 0.1;
			pegShapeDef.restitution = 0.8;
			
			var pegBodyDef:b2BodyDef = new b2BodyDef();
			pegBodyDef.position.Set(location.x / PhysiVals.met2pix, location.y / PhysiVals.met2pix);
			
			pegBody = PhysiVals.world.CreateBody(pegBodyDef);
			pegBody.CreateShape(pegShapeDef);
			pegBody.SetMassFromShapes();
			
			pegBody.SetLinearVelocity(initVel);
			
			super(pegBody, pegMovie);
			
			setMyMovieFrame();
		}
		
		override protected function childSpecificUpdating():void
		{
			pegMovie.rotation = Angle(pegBody.GetLinearVelocity()) / PhysiVals.deg2rad;
			super.childSpecificUpdating();
		}
		
		private function Angle(vector:b2Vec2):Number
		{
			var number:Number = Math.tan(vector.y / vector.x);
			//trace("angle: " + number.toString());
			return number;
		}
		
		
		public function hitObject():void
		{
			if (!_beenHit) {
				_beenHit = true;
				setMyMovieFrame();
			}
		}
		
		private function setMyMovieFrame():void
		{
			
		}
		
	}

}