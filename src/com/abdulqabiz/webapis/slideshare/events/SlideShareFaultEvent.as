package com.abdulqabiz.webapis.slideshare.events
{
	import flash.events.Event;
	
	public class SlideShareFaultEvent extends Event
	{
		
		public static const ERROR:String = "error";
		
			
		private var _errorCode:int;
		private var _errorMessage:String;
		
		
		public function SlideShareFaultEvent(type:String, 
										   bubbles:Boolean = false, 
										   cancelable:Boolean = false ) {
										   	
			super( type, bubbles, cancelable );	
		}
		
		
		public function get errorCode():int 
		{
			return _errorCode;	
		}
		
		public function set errorCode(value:int):void 
		{
			_errorCode = value;	
		}
		
	
		public function get errorMessage():String 
		{
			return _errorMessage;	
		}
		
		public function set errorMessage(value:String):void 
		{
			_errorMessage = value;	
		}
		
	}	
	
}
    
