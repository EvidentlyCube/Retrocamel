/*
 * Copyright (C) 2013 Maurycy Zarzycki
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

package net.retrocade.helpers{
    import flash.display.Loader;
    import flash.events.Event;
    import flash.events.HTTPStatusEvent;
    import flash.events.IOErrorEvent;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;
    import flash.net.URLVariables;

    public class RetrocamelLoader extends Loader{
        public var successCallback:Function;
        public var failureCallback:Function;

        public function RetrocamelLoader(url:String, success:Function = null, failure:Function = null){
            super();
            var ur:URLRequest = new URLRequest(url);

            successCallback = success;
            failureCallback = failure;


            contentLoaderInfo.addEventListener(Event.COMPLETE,              onComplete);
            contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,       onError);

            load(ur);
        }

        private function onComplete(e:Event):void{
            if (successCallback != null)
                if (successCallback.length == 1)
                    successCallback(e);
                else
                    successCallback();

            unset();
        }

        private function onError(e:Event):void{
            if (failureCallback != null)
                if (failureCallback.length == 1)
                    failureCallback(e);
                else
                    failureCallback();

            unset();
        }

        private function unset():void{
            contentLoaderInfo.removeEventListener(Event.COMPLETE,        onComplete);
            contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onError);
            
            successCallback = null;
            failureCallback = null;
        }
    }
}