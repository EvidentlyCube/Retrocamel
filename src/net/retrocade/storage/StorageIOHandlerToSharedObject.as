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
 * Created with IntelliJ IDEA.
 * User: Ryc
 * Date: 16.03.13
 * Time: 16:54
 * To change this template use File | Settings | File Templates.
 */
package net.retrocade.storage {
    import flash.net.SharedObject;

    public class StorageIOHandlerToSharedObject implements IStorageIOHandler{
        private var _sharedObject:SharedObject;

        public function StorageIOHandlerToSharedObject(name:String){
            _sharedObject = SharedObject.getLocal(name);
        }

        public function write(data:Object):void{
            _sharedObject.data.data = data;
            _sharedObject.flush();
        }

        public function read():Object{
            try{
                var data:Object = _sharedObject.data.data;

                if (data != null){
                    return data;
                } else {
                    return {};
                }
            } catch (error:Error){
                return {};
            }

            return {};
        }
    }
}
