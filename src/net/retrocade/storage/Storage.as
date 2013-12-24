/*
 * Copyright (C) 2013 Maurycy Zarzycki
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

package net.retrocade.storage{
    import com.newgrounds.crypto.MD5;

    import flash.utils.ByteArray;

    import net.retrocade.retrocamel.core.retrocamel_int;

    import net.retrocade.utils.UtilsBase64;
    import net.retrocade.utils.UtilsObjects;
    import net.retrocade.utils.UtilsSecure;

    use namespace retrocamel_int;

    public class Storage{
        retrocamel_int static var _storageObject:Object;
        retrocamel_int static var _storageHash:String;

        retrocamel_int static var _cryptoKey:String = "9dn2pr0kOjSU82o";
        retrocamel_int static var _scrambleKey:int = 174763;
        retrocamel_int static var _salt:String;

        private static var _integrityViolationCallback:Function;

        private static var _ioHandler:IStorageIOHandler;

        public static function init(ioHandler:IStorageIOHandler, cryptoKey:String, salt:String, scrambleKey:int):void{
            _ioHandler = ioHandler;

            _cryptoKey = cryptoKey;
            _salt = salt;
            _scrambleKey = scrambleKey;

            load();
        }

        public static function writeObject(key:String, value:Object):void{
            var serializer:ByteArray = new ByteArray();
            serializer.writeObject(value);

            write(key, UtilsBase64.encodeByteArray(serializer));
        }

        public static function writeFlag(key:String, value:Boolean):void{
            write(key, value ? "TRUE" : "FALSE");
        }

        public static function writeNumber(key:String, value:Number):void{
            write(key, value.toString());
        }

        public static function writeString(key:String, value:String):void{
            write(key, value);
        }

        public static function readObject(key:String, defaultReturn:Object):Object{
            var value:String = read(key, null);

            if (!value){
                return defaultReturn;
            } else {
                var unserializer:ByteArray = UtilsBase64.decodeByteArray(value);
                unserializer.position = 0;

                return unserializer.readObject();
            }
        }

        public static function readFlag(key:String, defaultReturn:Boolean):Boolean{
            return read(key, defaultReturn ? "TRUE" : "FALSE") === "TRUE";
        }

        public static function readNumber(key:String, defaultReturn:Number):Number{
            return parseFloat(read(key, defaultReturn.toString()));
        }

        public static function readString(key:String, defaultReturn:String):String{
            return read(key, defaultReturn);
        }

        public static function registerIntegrityViolationCallback(callback:Function):void{
            _integrityViolationCallback = callback;
        }

        public static function has(key:String):Boolean{
            verifyIntegrity();

            key = encodeKey(key);

            return _storageObject.hasOwnProperty(key);
        }

        retrocamel_int static function load():void{
            if (_ioHandler){
                _storageObject = _ioHandler.read();
            } else {
                _storageObject = {};
            }

            regenerateHash();
        }

        public static function save():void{
            if (_ioHandler){
                _ioHandler.write(_storageObject);
            }
        }

        private static function write(key:String, value:String):void{
            verifyIntegrity();

            key = encodeKey(key);

            if (value === null){
                delete _storageObject[key];
            } else {
                value = encodeValue(value);
                _storageObject[key] = value;
            }

            regenerateHash();
        }

        private static function read(key:String, def:String):String{
            verifyIntegrity();

            key = encodeKey(key);

            if (_storageObject.hasOwnProperty(key)){
                var value:String = _storageObject[key];
                value = decodeValue(value);
                return value;
            } else {
                return def;
            }
        }

        retrocamel_int static function encodeKey(key:String):String{
            return MD5.hash(key);
        }

        private static function encodeValue(value:String):String{
            return UtilsSecure.rotComplexForward(value);
        }

        private static function decodeValue(value:String):String{
            return UtilsSecure.rotComplexBackwards(value);
        }

        private static function verifyIntegrity():void{
            if (_storageHash != generateHash(_storageObject)){
                onIntegrityViolation();
            }
        }

        private static function onIntegrityViolation():void{
            _storageObject = {};
            regenerateHash();

            save();

            if (_integrityViolationCallback != null){
                _integrityViolationCallback();
            }
        }

        private static function regenerateHash():void{
            _storageHash = generateHash(_storageObject);
        }

        private static function generateHash(toHash:Object):String{
            var string:String = UtilsObjects.toString(toHash);

            var targetHash:String = "";
            var i:int = 0;

            do {
                targetHash += UtilsSecure.hashStringJenkins(string.substr(i));

                i++;

                if (i >= string.length){
                    i = 0;
                }
            } while (targetHash.length < 32);

            return targetHash.substr(0, 32);
        }
    }
}