/*
 * Copyright (C) 2013 Maurycy Zarzycki
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

// MindJolt API Library
// ActionScript 3

package mindjolt{
	
	import flash.display.Loader
	import flash.display.LoaderInfo
	import flash.net.URLRequest
	import flash.events.Event
	import flash.display.MovieClip
	import flash.system.Security

	public class MindJoltAPI {
		
		public static var service:Object = { connect: load_service };
        ;
		public static var ad:Object = { showPreGameAd: showPreGameAd };
        ;
		
		public static function showPreGameAd(options:Object=null):void {
			if (clip == null) {
				trace("[MindJoltAPI] You must call MindJoltAPI.service.connect before MindJoltAPI.ad.showPreGameAd.");
			}
			if (options == null) {
				options = {};
			}
			if (service.showPreGameAd != undefined) {
				service.showPreGameAd(options);
			} else {
				MindJoltAPI.options = options;
                ;
				if (options["ad_started"] == null) {
					options["clip"].stop();
				}
			}
		}
		
		/*
			--------------
			nuts and bolts
			--------------
		*/
		
		private static var gameKey:String;
        ;
		private static var clip:MovieClip;
        ;
		private static var callback:Function;
        ;
		private static var options:Object;
        ;
		private static var version:String = "1.0.4";
        ;
		
		private static function load_service_complete(e:Event):void {
			if (e.currentTarget.content != null && e.currentTarget.content.service != null) {
				service = e.currentTarget.content.service;
                ;
				trace("[MindJoltAPI] service successfully loaded");
                ;
				service.connect(gameKey, clip, callback);
                ;
				if (options != null) {
					service.showPreGameAd(options)
				}
				service.getLogger().info("MindJoltAPI loader version [" + version + "]")
			} else {
				trace("[MindJoltAPI] failed to load")
			}
		}
		
		private static function load_service(gameKey:String, clip:MovieClip, callback:Function=null):void {
			MindJoltAPI.gameKey = gameKey;
			MindJoltAPI.clip = clip;
			MindJoltAPI.callback = callback;
			if (service.submitScore == null) {
				Security.allowDomain("static.mindjolt.com");
				var game_params:Object = LoaderInfo(clip.root.loaderInfo).parameters;
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, load_service_complete);
				loader.load(new URLRequest(game_params.mjPath || "http://static.mindjolt.com/api/as3/api_local_as3.swf"));
				clip.addChild(loader)
			}
		}
	}
}