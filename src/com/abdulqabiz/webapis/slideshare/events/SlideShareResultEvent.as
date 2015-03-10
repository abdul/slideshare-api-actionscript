package com.abdulqabiz.webapis.slideshare.events 
{
	import flash.events.Event;
	public class SlideShareResultEvent extends Event
	{
		
		public static const SLIDESHOW_UPLOAD:String = "slideshowUpload";
		public static const SLIDESHOW_BY_ID:String = "slideshowById";
		public static const SLIDESHOW_BY_TAG:String = "slideshowByTag";
		public static const SLIDESHOW_BY_USER:String = "slideshowByUser";
		public static const SLIDESHOW_FROM_GROUP:String = "slideshowByGroup";
		
		/**
		 * True if the event is the result of a successful call,
		 * False if the call failed
		 */
		public var data:Object;
		
		/**
		 * Constructs a new SlideShareResultEvent
		 */
		public function SlideShareResultEvent( type:String, 
										   bubbles:Boolean = false, 
										   cancelable:Boolean = false ) {
										   	
			super( type, bubbles, cancelable );
		}
	
	}
	
}
