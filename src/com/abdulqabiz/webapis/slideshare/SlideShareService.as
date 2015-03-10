package com.abdulqabiz.webapis.slideshare
{
	import com.abdulqabiz.webapis.slideshare.events.*;
	import com.adobe.crypto.SHA1;
	
	import flash.events.*;
	import flash.net.*;
	import flash.xml.*;
	
	
	[Event(name="slideshowUpload", type="com.abdulqabiz.webapis.slideshare.events.SlideShareResultEvent")]
	[Event(name="slideshowById", type="com.abdulqabiz.webapis.slideshare.events.SlideShareResultEvent")]
	[Event(name="slideshowByTag", type="com.abdulqabiz.webapis.slideshare.events.SlideShareResultEvent")]
	[Event(name="slideshowByUser", type="com.abdulqabiz.webapis.slideshare.events.SlideShareResultEvent")]
	[Event(name="slideshowByGroup", type="com.abdulqabiz.webapis.slideshare.events.SlideShareResultEvent")]
	[Event(name="error", type="com.abdulqabiz.webapis.slideshare.events.SlideShareFaultEvent")]
	
	public class SlideShareService extends EventDispatcher
	{
		public static const END_POINT:String = "http://www.slideshare.net/api/1/";
		
		
		
		private var _apiKey:String;
		private var _secret:String;
		
		private var username:String;
		private var password:String;
		
		private var slideShowMetadata:SlideShowMetadata;
		
		private var urlLoader:URLLoader;
		private var fileReferenceList:FileReferenceList;
		private var fileReference:FileReference;
		private var uploadCount:uint = 0;
		
		public function SlideShareService (_apiKey:String, _secret:String, username:String=null, password:String=null)
		{
			this._apiKey = _apiKey;
			this._secret = _secret;
			this.username = username;
			this.password = password;
			
			urlLoader = new URLLoader ();
			//urlLoader.addEventListener(
			
		}
		
		public function getSlideShow (id:String):void
		{
			var param:Param = new Param ("slideshow_id", id);
			invokeMethod ("get_slideshow", getSlideShowHandler);
		}
		
		private function getSlideShowHandler (event:Event):void
		{
			urlLoader.removeEventListener (Event.COMPLETE, getSlideShowHandler);
			processResponse (event.target.data);
			
		}
		
		public function getSlideShowByUser (user:String):void
		{
			var userParam:Param = new Param ("username_for", user);
			invokeMethod ("get_slideshow_by_user", getSlideShowByUserHandler, null, null,userParam)
	
		}
		
		private function getSlideShowByUserHandler (event:Event):void
		{
			urlLoader.removeEventListener (Event.COMPLETE, getSlideShowByUserHandler);
			processResponse (event.target.data);		
			
			
		}
		
		public function getSlideShowFromGroup (group:String):void
		{
			var param:Param = new Param ("group_name", group);
			invokeMethod ("get_slideshow_from_group", getSlideShowFromGroupHandler, null, null,param)
	
		}
		
		private function getSlideShowFromGroupHandler (event:Event):void
		{
			urlLoader.removeEventListener (Event.COMPLETE, getSlideShowFromGroupHandler);
			processResponse (event.target.data);		
			
			
		}
		
		public function getSlideShowByTag (tag:String):void
		{
			var param:Param = new Param ("tag", tag);
			invokeMethod ("get_slideshow_by_tag", getSlideShowByTagHandler, null, null,param)
	
		}
		
		private function getSlideShowByTagHandler (event:Event):void
		{
			urlLoader.removeEventListener (Event.COMPLETE, getSlideShowByTagHandler);
			processResponse (event.target.data);		
			
			
		}
		
		public function uploadFile (fileReference:FileReference, metadata:SlideShowMetadata, username:String=null, password:String=null):void
		{
			if (username != null)
			{
				this.username = username;
			}
			if (password != null)
			{
				this.password = password;
			}
			if (!this.username && !this.password)
			{
				trace ("Username and Password not set");
				return;
			} 
			if (metadata.title == null)
			{
				trace ("Title is required while uploading");
				return;
			}
			if (!fileReference)
			{
				
				return;
			}
			this.fileReference = fileReference;
			this.slideShowMetadata = metadata;
				
			fileReference.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, fileReferenceHandler);
			fileReference.addEventListener(ProgressEvent.PROGRESS, fileReferenceHandler);
			fileReference.addEventListener(IOErrorEvent.IO_ERROR, fileReferenceHandler);
			
			var uploadParams:Array = [];
			var titleParam:Param  = new Param ("slideshow_title", slideShowMetadata.title);
			uploadParams.push (titleParam);
			
			if (slideShowMetadata.tags != null)
			{
				var tagsParam:Param = new Param ("slideshow_tags", slideShowMetadata.tags );
				uploadParams.push (tagsParam);
			}
			if (slideShowMetadata.description != null)
			{
				
				var descriptionParam:Param = new Param ("slideshow_description", slideShowMetadata.description);
				uploadParams.push (descriptionParam);
			}
			if (slideShowMetadata.isPublic == false)
			{				
				var makeSrcPublic:Param = new Param ("make_src_public", "N");
				uploadParams.push(makeSrcPublic);
			}
			
				var request:URLRequest = constructRequest ("upload_slideshow", this.username, this.password, 
					uploadParams);
				trace ("Start Uploading");
				fileReference.upload(request, "slideshow_srcfile", true);
			
		}
			
			
		private function fileReferenceHandler (event:Event)
		{
			var e;
			trace ("event: " + event.type);
			switch (event.type)
			{
				case DataEvent.UPLOAD_COMPLETE_DATA:
					e = DataEvent (event);
					trace (DataEvent (event).text);
					processResponse (DataEvent (event).text);
					this.slideShowMetadata = null;					
					break;
				case ProgressEvent.PROGRESS:
					e = ProgressEvent (event);
						trace (e.bytesLoaded + "/" + e.bytesTotal);
					break;
				case IOErrorEvent.IO_ERROR:
					trace ("IO Error");
					break;
			}
		}
		
		private function invokeMethod (method:String, callBack:Function, username:String=null, 
				password:String=null,...params:Array):void
		{
			var request:URLRequest = constructRequest (method, username, password, params);
			urlLoader.addEventListener(Event.COMPLETE, callBack);
			urlLoader.load(request);
			
		}
		
		private function constructRequest (method:String, username:String=null, password:String=null, params:Array=null):URLRequest
		{
			
			var d:Date = new Date ();
			
			var ts:Number = d.getTime ()/1000;
			var hash:String = SHA1.hash(_secret + ts);
			
			var urlVars:URLVariables = new URLVariables ();
			urlVars.api_key = _apiKey;
			urlVars.ts = ts;
			urlVars.hash = hash;
			if (username != null && password != null)
			{
				urlVars.username = username;
				urlVars.password = password;
			}
			
			const len:uint = params.length;
			for ( var i:int = 0; i < len; i++ ) 
			{
				// Do we have an argument name, or do we create one
				if ( params[i] is Param ) 
				{
					var p:Param = params[i];
					urlVars[p.name] = p.value;
				
				}
			}
			
			var url:String = END_POINT + method;
			var request:URLRequest = new URLRequest (url);
			request.method = URLRequestMethod.POST;
			request.data = urlVars;
			return request;
		}
		
		private function processResponse (response:String):Object
		{
			var doc:XMLDocument = new XMLDocument();
			doc.ignoreWhite = true;
			doc.parseXML(response);
			
			var rsp:XMLNode = doc.firstChild;
			doc = null;
			var result:Object = new Object ();
			result.data = new Object ();
			var o:Object;
			
			const nodeName:String = rsp.nodeName;
			
			switch (nodeName)
			{
				case "SlideShareServiceError":
					result.success = false;
					var error:SlideShareFaultEvent = new SlideShareFaultEvent (SlideShareFaultEvent.ERROR);
					error.errorCode = rsp.firstChild.attributes.id;
					error.errorMessage = rsp.firstChild.nodeValue;
					dispatchEvent (error);
				break;
				case "User":
				case "Group":
				case "Tag":
					o = getSlideShowListObject (XML (rsp));
					//trace (ObjectUtil.toString (result));
					var resultEvent:SlideShareResultEvent = new SlideShareResultEvent ("slideshowBy" + nodeName);
					resultEvent.data = o.list;
					
					dispatchEvent(resultEvent);
				break;
				case "SlideShowUploaded":
					var id:Number =  parseInt (XML (rsp).SlideShowID);
					var resultEvent:SlideShareResultEvent = 
						new SlideShareResultEvent (SlideShareResultEvent.SLIDESHOW_UPLOAD);
					resultEvent.data = id;
					dispatchEvent(resultEvent);
				break;
				case "SlideShow":
					o = getSlideShowObject (XML (rsp));
					
					var resultEvent:SlideShareResultEvent = 
						new SlideShareResultEvent (SlideShareResultEvent.SLIDESHOW_BY_ID);
					resultEvent.data = o;
					dispatchEvent(resultEvent);					
				break;
					
			}
			
			return result
		}
		
		private function getSlideShowListObject (xml:XML):Object
		{
			var result:Object = new Object ();
			result.count = parseInt (xml.count.toString ());
			result.name = xml.name.toString ();
			result.list = new Array ();
			
			var slideshows:XMLList = xml..Slideshow;
			
			const len:uint = slideshows.length();
			
			for (var i:uint = 0; i < len; ++i)
			{
				var x:XML = slideshows[i];
				
				var ss:SlideShowMetadata = getSlideShowObject (x);
				
				result.list.push(ss);
			}
			
			return result;
		}
		
		private function getSlideShowObject (x:XML):SlideShowMetadata
		{
			
				var ss:SlideShowMetadata = new SlideShowMetadata ();
				ss.id = parseInt (x.ID.toString ());
				ss.title = x.Title.toString ();
				ss.description = x.Description.toString ();
				ss.embedCode = x.EmbedCode.toString ();
				ss.permalink = x.PermaLink.toString ();
				ss.views = parseInt (x.Views.toString ());
				ss.status = x.Status.toString ();
				if (x.hasOwnProperty("Tags"))
				{
					ss.tags = x.Tags.toString ();
					ss.tagsList = ss.tags.split(",");
				}
				ss.thumbnailURL = x.Thumbnail.toString ();
				ss.statusDescription = x.StatusDescription.toString ();
				ss.transcript = x.Transcript.toString ();
		
			return ss;		
		}
		
		
		
		
		
		
		
	}
}