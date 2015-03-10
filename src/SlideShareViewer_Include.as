// ActionScript file

import flash.events.MouseEvent;
import flash.system.Security;

import mx.events.ListEvent;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;
import mx.utils.ObjectUtil;
import mx.utils.StringUtil;

private static const SEARCH_CRITERIA:Array = ["user", "tag", "text"];
private static const SLIDESHARE_PLAYER_URL:String = 
	"http://s3.amazonaws.com/slideshare/ssplayer2.swf?doc={0}";

private static const SLIDESHARE_RSS_FEED_URL:String = "http://www.slideshare.net/rss/{0}/{1}";

private var httpService:HTTPService;

private function appCreationCompletHandler ()
{
	httpService = new HTTPService ();
	httpService.addEventListener(ResultEvent.RESULT, httpServiceResultHandler);
	httpService.addEventListener (FaultEvent.FAULT, httpServiceFaultHandler);
	httpService.resultFormat = HTTPService.RESULT_FORMAT_OBJECT;
	
	searchButton.addEventListener(MouseEvent.CLICK, searchButtonHandler);
	slideList.addEventListener (ListEvent.CHANGE, slideListChangeHandler);
	
}

private function searchButtonHandler (event:MouseEvent):void
{
	var criteria:String = String (searchCriteria.selectedValue);
	var text:String = searchText.text;
	var url:String = "";
	if (text.length > 0)
	{
		url = StringUtil.substitute(SLIDESHARE_RSS_FEED_URL, criteria, text);
		loadFeed (url);
	}
}

private function loadFeed (url:String):void
{
	httpService.url = url;
	httpService.send();
}


private function httpServiceResultHandler (event:ResultEvent):void
{
	trace (ObjectUtil.toString(event.result));
	slideList.dataProvider = event.result.rss.channel.item;
	slideList.labelFunction = function (item)
	{
		return item.title;
	}
	
}
private function slideListChangeHandler (event:ListEvent):void
{
	var data:Object = slideList.selectedItem;
	var str:String = data.group.thumbnail.url;
	var li = str.lastIndexOf("/");
	str = str.slice(li+1, str.length);
	li = str.lastIndexOf ("-thumbnail-2");
	var id:String = str.slice(0, li);
	var url:String = StringUtil.substitute(SLIDESHARE_PLAYER_URL, id);
	trace ("URL: " + url);
	Security.allowDomain("*");
	swfLoader.load(url);
	
}
private function httpServiceFaultHandler (event:FaultEvent):void
{
	
}
private function loadSlideShow (id:String):void
{
	
}