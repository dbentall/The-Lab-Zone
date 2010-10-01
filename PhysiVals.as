package  
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2World;
	/**
	 * ...
	 * @author Daniel Bentall
	 */
	public class PhysiVals
	{
		
		public static const met2pix:Number = 30;
		public static const frameR:Number = 40;
		public static const deg2rad:Number = Math.PI / 180;
		public static var gravity:b2Vec2 = new b2Vec2(0, 9.8);
		
		private static var _world:b2World;
		
		public function PhysiVals() 
		{
			
		}
		
		static public function get world():b2World { return _world; }
		
		static public function set world(value:b2World):void 
		{
			_world = value;
		}
		
	}

}