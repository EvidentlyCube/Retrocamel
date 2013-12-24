/*
 * Copyright (C) 2013 Maurycy Zarzycki
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

package CPMStar {
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	
	public class AdLoader extends flash.display.Sprite {
		
		private var cpmstarLoader:Loader;
		private var contentspotid:String;
		public function AdLoader(contentspotid:String) {
			this.contentspotid = contentspotid;
			addEventListener(Event.ADDED, addedHandler);
            
            graphics.beginFill(0xFFFFFF);
            graphics.drawRect(-1, -1, 302, 252);
            graphics.beginFill(0);
            graphics.drawRect(0, 0, 300, 250);
		}
		private function addedHandler(event:Event):void {
			removeEventListener(Event.ADDED, addedHandler);			
			Security.allowDomain("server.cpmstar.com");
			var cpmstarViewSWFUrl:String = "http://server.cpmstar.com/adviewas3.swf";
			var container:DisplayObjectContainer = parent;
			cpmstarLoader = new Loader();
			cpmstarLoader.contentLoaderInfo.addEventListener(Event.INIT, dispatchHandler, false, 0, true);
			cpmstarLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, dispatchHandler, false, 0, true);
			cpmstarLoader.load(new URLRequest(cpmstarViewSWFUrl + "?contentspotid="+contentspotid));
			addChild(cpmstarLoader);
		}
		private function dispatchHandler(event:Event):void {
			dispatchEvent(event);
		}
	}
}
