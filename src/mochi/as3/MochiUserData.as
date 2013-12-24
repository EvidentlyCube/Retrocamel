/*
 * Copyright (C) 2013 Maurycy Zarzycki
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

/**
* MochiUserData
* Connection class for all Mochi User Data Services
* @author Mochi Media
*
* This class is EXPERIMENTAL!
*
*/

package mochi.as3 {
    import flash.utils.ByteArray;
    import flash.net.URLRequest;
    import flash.net.URLRequestHeader;
    import flash.net.URLRequestMethod;
    import flash.net.URLVariables;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.ObjectEncoding;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.EventDispatcher;
    import flash.events.SecurityErrorEvent;

    public class MochiUserData extends EventDispatcher {
        public var _loader:URLLoader;
        public var key:String = null;
        public var data:* = null;
        public var error:Event = null;
        public var operation:String = null;
        public var callback:Function = null;

        public function MochiUserData(key:String = "", callback:Function = null) {
            this.key = key;
            this.callback = callback;
        }

        public function serialize(obj:*):ByteArray {
            var arr:ByteArray = new ByteArray();
            arr.objectEncoding = ObjectEncoding.AMF3;
            arr.writeObject(obj);
            arr.compress();
            return arr;
        }

        public function deserialize(arr:ByteArray):* {
            arr.objectEncoding = ObjectEncoding.AMF3;
            arr.uncompress();
            return arr.readObject();
        }

        public function request(_operation:String, _data:ByteArray):void {
            operation = _operation;

            var api_url:String = MochiSocial.getAPIURL();
            var api_token:String = MochiSocial.getAPIToken();
            if (api_url == null || api_token == null) {
                errorHandler(new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false, "not logged in"));
                return;
            }

            _loader = new URLLoader();
            var args:URLVariables = new URLVariables();
            args.op = _operation;
            args.key = key;
            var req:URLRequest = new URLRequest(MochiSocial.getAPIURL() + "/" + "MochiUserData?" + args.toString());
            req.method = URLRequestMethod.POST;
            req.contentType = "application/x-mochi-userdata";
            req.requestHeaders = [
                new URLRequestHeader("x-mochi-services-version", MochiServices.getVersion()),
                new URLRequestHeader("x-mochi-api-token", api_token)
            ];
            req.data = _data;

            _loader.dataFormat = URLLoaderDataFormat.BINARY;
            _loader.addEventListener(Event.COMPLETE, completeHandler);
            _loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
            _loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            try {
                _loader.load(req);
            } catch (e:SecurityError) {
                errorHandler(new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false, "security error: " + e.toString()));
            }
        }

        public function completeHandler(event:Event):void {
            try {
                if (_loader.data.length) {
                    data = deserialize(_loader.data);
                } else {
                    data = null;
                }
            } catch (e:Error) {
                errorHandler(new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false, "deserialize error: " + e.toString()));
                return;
            }
            if (callback != null) {
                performCallback();
            } else {
                dispatchEvent(event);
            }
            close();
        }

        public function errorHandler(event:IOErrorEvent):void {
            data = null;
            error = event;
            if (callback != null) {
                performCallback();
            } else {
                dispatchEvent(event);
            }
            close();
        }

        public function securityErrorHandler(event:SecurityErrorEvent):void {
            errorHandler(new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false, "security error: " + event.toString()));
        }

        public function performCallback():void {
            try {
                callback(this);
            } catch (e:Error) {
                trace("[MochiUserData] exception during callback: " + e);
            }
        }

        public function close():void {
            if (_loader) {
                _loader.removeEventListener(Event.COMPLETE, completeHandler);
                _loader.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
                _loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
                _loader.close();
                _loader = null;
            }
            error = null;
            callback = null;
        }

        public function getEvent():void {
            request("get", serialize(null));
        }

        public function putEvent(obj:*):void {
            request("put", serialize(obj));
        }

        public override function toString():String {
            return "[MochiUserData operation=" + operation + " key=\"" + key + "\" data=" + data + " error=\"" + error + "\"]";
        }

        public static function get(key:String, callback:Function):void {
            var userData:MochiUserData = new MochiUserData(key, callback);
            userData.getEvent();
        }

        public static function put(key:String, obj:*, callback:Function):void {
            var userData:MochiUserData = new MochiUserData(key, callback);
            userData.putEvent(obj);
        }
    }
}
