package  
{
	import Box2D.Dynamics.b2Body;
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author Daniel Bentall
	 */
	public class Actor extends EventDispatcher
	{
		
		public var _body:b2Body;
		public var _costume:DisplayObject;
		protected var _jump_f:Boolean = false;
		protected var _left_f:Boolean = false;
		protected var _right_f:Boolean = false;
		protected var _shoot_f:Boolean = false;
		protected var _onGround_f:Boolean = false;
		
		public function Actor(myBody:b2Body, myCostume:DisplayObject) 
		{
			_body = myBody;
			_body.SetUserData(this);
			_costume = myCostume;
			//_costume.name = "bin";
			updateMyLook();
		}
		
		public function updateNow():void
		{
			if(!_body.IsStatic()){
				updateMyLook();
			}
			childSpecificUpdating();
		}
		
		protected function childSpecificUpdating():void {
			//for overriding
		}
		
		public function destroy():void
		{
			//if (this._costume != null && this._body != null) {
				cleanupBeforeRemoving();
				_costume.parent.removeChild(_costume); //  _costume.parent.getChildByName("bin"));
				PhysiVals.world.DestroyBody(_body);
				//trace(this._costume);
			//}
		}
		
		private function cleanupBeforeRemoving():void {
			//for overriding
		}
		
		protected function updateMyLook():void
		{
			_costume.x = _body.GetPosition().x * PhysiVals.met2pix;
			_costume.y = _body.GetPosition().y * PhysiVals.met2pix;
			_costume.rotation = _body.GetAngle() / PhysiVals.deg2rad;
		}
		
		public function set jump_f(value:Boolean):void 
		{
			_jump_f = value;
		}
		
		public function set left_f(value:Boolean):void 
		{
			_left_f = value;
		}
		
		public function set right_f(value:Boolean):void 
		{
			_right_f = value;
		}
		
		public function set shoot_f(value:Boolean):void 
		{
			_shoot_f = value;
		}
		
		public function set onGround_f(value:Boolean):void 
		{
			_onGround_f = value;
		}
		
	}

}