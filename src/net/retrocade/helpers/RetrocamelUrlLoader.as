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
    import flash.errors.IOError;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;
    import flash.net.URLVariables;

    /**
     * ...
     * @author Maurycy Zarzycki
     */
    public class RetrocamelUrlLoader extends URLLoader{

        private var _successCallback:Function;
        private var _failureCallback:Function;

        private var _urlRequest  :URLRequest;
        private var _urlVariables:URLVariables;

        private var _isFinished  :Boolean = false;

        public function get isFinished():Boolean{
            return _isFinished;
        }

        private var _inProgress:Boolean = true;

        public function get inProgress():Boolean {
            return _inProgress;
        }

        /**
         * Useful for storing additional information in the loader
         */
        public var metaData:*;



        /******************************************************************************************************/
        /**                                                                                        FUNCTIONS  */
        /******************************************************************************************************/

        public function RetrocamelUrlLoader(url:String, data:Object = null, successCallback:Function = null, failureCallback:Function = null, dataFormat:String = "text"){
            super(null);
			
            _urlVariables = new URLVariables();
            for(var i:String in data)
                _urlVariables[i] = data[i];

            _urlRequest        = new URLRequest(url);
            _urlRequest.data   = _urlVariables;
            _urlRequest.method = URLRequestMethod.POST;

            this.dataFormat = dataFormat;

            _successCallback = successCallback;
            _failureCallback = failureCallback;

            if (_successCallback != null)
                addEventListener(Event.COMPLETE, onSuccess);

            if (_failureCallback != null){
                addEventListener(IOErrorEvent.IO_ERROR, onError);
                addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
            }

            load(_urlRequest);
        }

        private function onSuccess(e:Event):void{
            _isFinished = true;
            _inProgress = false;

            if (_successCallback != null){
                if (_successCallback.length == 1)
                    _successCallback(data);
                else
                    _successCallback();
            }

            clearListeners();
        }

        private function onError(e:*):void{
            _isFinished = true;
            _inProgress = false;

            if (_failureCallback != null) {
                if (_failureCallback.length == 1)
                    _failureCallback(e);
                else
                    _failureCallback();
            }

            clearListeners();
        }

        private function clearListeners():void{
            removeEventListener(Event.COMPLETE, onSuccess);
            removeEventListener(IOErrorEvent.IO_ERROR, onError);
            removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);

            _successCallback = null;
            _failureCallback = null;
        }
    }
}