package  
{
	import Box2D.Collision.b2ContactPoint;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2ContactListener;
	
	/**
	 * ...
	 * @author Daniel Bentall
	 */
	public class PuggleContactListener extends b2ContactListener
	{
		
		public function PuggleContactListener() 
		{
			
		}
		
		override public function Add(point:b2ContactPoint):void 
		{
			if (point.shape1.GetBody().GetUserData() is Platforms && point.shape2.GetBody().GetUserData() is PlayerActor) {
				PlayerActor(point.shape2.GetBody().GetUserData()).onGround_f = true;
				//trace(
			}
			else if(point.shape2.GetBody().GetUserData() is Platforms && point.shape1.GetBody().GetUserData() is PlayerActor) {
				PlayerActor(point.shape1.GetBody().GetUserData()).onGround_f = true;
			}
			
			if (point.shape1.GetBody().GetUserData() is Platforms && point.shape2.GetBody().GetUserData() is PegActor) {
				Gideons_01._actorsToRemove.push(Actor(point.shape2.GetBody().GetUserData()));
				point.shape2.GetBody().SetLinearVelocity(new b2Vec2(0, 0));
			}
			else if(point.shape2.GetBody().GetUserData() is Platforms && point.shape1.GetBody().GetUserData() is PegActor) {
				Gideons_01._actorsToRemove.push(Actor(point.shape1.GetBody().GetUserData()));
				point.shape1.GetBody().SetLinearVelocity(new b2Vec2(0, 0));
			}
			
			if (point.shape1.GetBody().GetUserData() is PlayerActor && point.shape2.GetBody().GetUserData() is PegActor) {
				Gideons_01._actorsToRemove.push(Actor(point.shape2.GetBody().GetUserData()));
				PlayerActor(point.shape1.GetBody().GetUserData()).takeDamage();
				point.shape2.GetBody().SetLinearVelocity(new b2Vec2(0, 0));
			}
			else if(point.shape2.GetBody().GetUserData() is PlayerActor && point.shape1.GetBody().GetUserData() is PegActor) {
				Gideons_01._actorsToRemove.push(Actor(point.shape2.GetBody().GetUserData()));
				PlayerActor(point.shape2.GetBody().GetUserData()).takeDamage();
				point.shape1.GetBody().SetLinearVelocity(new b2Vec2(0, 0));
			}
			
			super.Add(point);
		}
		
		override public function Remove(point:b2ContactPoint):void 
		{
			if (point.shape1.GetBody().GetUserData() is Platforms && point.shape2.GetBody().GetUserData() is PlayerActor) {
				PlayerActor(point.shape2.GetBody().GetUserData()).onGround_f = false;
			}
			else if(point.shape2.GetBody().GetUserData() is Platforms && point.shape1.GetBody().GetUserData() is PlayerActor) {
				PlayerActor(point.shape1.GetBody().GetUserData()).onGround_f = false;
			}
			
			super.Remove(point);
		}
	}

}