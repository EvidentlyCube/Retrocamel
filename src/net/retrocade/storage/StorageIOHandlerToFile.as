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
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    import flash.utils.ByteArray;
    import flash.utils.getQualifiedClassName;

    import net.retrocade.utils.UtilsBase64;
    import net.retrocade.utils.UtilsSecure;

    public class StorageIOHandlerToFile implements IStorageIOHandler{
        private var _storagePath:File;
        private var _cryptoKey:String = "9dn2pr0kOjSU82o";
        private var _scrambleKey:int = 174763;

        public function StorageIOHandlerToFile(filePath:String, cryptoKey:String, scrambleKey:int){
            _storagePath = File.applicationStorageDirectory.resolvePath(filePath);
            _cryptoKey = cryptoKey;
            _scrambleKey = scrambleKey;
        }

        public function write(data:Object):void{
            var byteArray:ByteArray = new ByteArray();
            byteArray.writeObject(data);

            byteArray = UtilsBase64.encodeByteArrayByteArray(byteArray);
            UtilsSecure.scrambleByteArray(byteArray, _scrambleKey);

            byteArray.position = 0;

            var fileStream:FileStream = new FileStream();
            fileStream.open(_storagePath, FileMode.WRITE);

            fileStream.writeBytes(byteArray);

            fileStream.close();
        }

        public function read():Object{
            try{
                if (_storagePath.exists){
                    var fileStream:FileStream = new FileStream();
                    fileStream.open(_storagePath, FileMode.READ);

                    var byteArray:ByteArray = new ByteArray();
                    fileStream.readBytes(byteArray);
                    fileStream.close();

                    UtilsSecure.unscrambleByteArray(byteArray, _scrambleKey);

                    byteArray = UtilsBase64.decodeByteArrayByteArray(byteArray);
                    var result:Object = byteArray.readObject();

                    var className:String = getQualifiedClassName(result);
                    if (className != "Object"){
                        return {};
                    } else {
                        return result;
                    }
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
