/*
 * Copyright (C) 2013 Maurycy Zarzycki
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

package net.retrocade.log {
    import flash.errors.MemoryError;

    public class LogType {
        private static var _creationLock:Boolean = false;
        private static var _collection:Vector.<LogType> = new Vector.<LogType>();

        public static var DEBUG:LogType = new LogType(0, "<D>");
        public static var MESSAGE:LogType = new LogType(1, "<M>");
        public static var WARNING:LogType = new LogType(2, "<W>");
        public static var ERROR:LogType = new LogType(3, "<E>");

        {
            _creationLock = true;
        }

        private var _id:int;
        private var _name:String;
        private var _metadata:Object;

        public function get id():int {
            return _id;
        }

        public function get name():String {
            return _name;
        }

        public function get metadata():Object {
            return _metadata;
        }

        public function LogType(id:int, name:String, metadata:Object = null) {
            if (_creationLock) {
                throw new MemoryError("Cannot create instances of Enum class");
            }

            _id = id;
            _name = name;
            _metadata = metadata;

            _collection.push(this);
        }

        public static function byId(id:int):LogType {
            for each(var element:LogType in _collection) {
                if (element._id == id) {
                    return element;
                }
            }

            throw new ArgumentError("Invalid enum");
        }

        public static function byName(name:String):LogType {
            for each(var element:LogType in _collection) {
                if (element._name == name) {
                    return element;
                }
            }

            throw new ArgumentError("Invalid enum");
        }


        public static function hasId(id:int):Boolean {
            for each(var element:LogType in _collection) {
                if (element._id == id) {
                    return true;
                }
            }

            return false;
        }

        public static function hasName(name:String):Boolean {
            for each(var element:LogType in _collection) {
                if (element._name == name) {
                    return true;
                }
            }

            return false;
        }
    }
}
