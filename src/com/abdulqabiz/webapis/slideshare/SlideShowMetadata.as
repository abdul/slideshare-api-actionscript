package com.abdulqabiz.webapis.slideshare
{
	public class SlideShowMetadata
	{
		public var id:Number;
		public var title:String;
		public var description:String;
		public var tags:String;
		public var tagsList:Array;
		public var embedCode:String;
		public var thumbnailURL:String;
		public var permalink:String;
		public var views:uint;
		public var transcript:String;
		
		public var status:uint;
		public var statusDescription:String;
		public var isPublic:Boolean = true;
	}
}
