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
 * Time: 17:35
 * To change this template use File | Settings | File Templates.
 */
package net.retrocade.storage {
    import net.retrocade.camel.global.retrocamel_int;
    import net.retrocade.storage.Storage;
    import net.retrocade.utils.UString;

    import org.flexunit.Assert;

    public class StorageTest {
        public function StorageTest() {
            Storage.init(new MockHandler(), "12345678abcdefgh", "salto", 1234);
            Storage.registerIntegrityViolationCallback(failTest);
        }

        [Test]
        public function testReadAndWrite():void{
            var key:String = "myKey";
            var value:String = "myValue";

            Storage.writeString(key, value);
            Assert.assertEquals(value, Storage.readString(key, null));
        }

        [Test]
        public function testIOHandler():void{
            for (var i:int = 0; i < 100; i++){
                var key:String = UString.randomText(10);
                var value:String = UString.randomText(10);

                Storage.writeString(key, value);

                Storage.save();
                Storage.retrocamel_int::load();

                Assert.assertEquals(value, Storage.readString(key, null));
            }
        }

        public function failTest():void{
            Assert.fail("Integrity test failure");
        }
    }
}

import flash.utils.ByteArray;

import net.retrocade.storage.IStorageIOHandler;

class MockHandler implements IStorageIOHandler{
    public var _data:ByteArray;
    public function read():ByteArray{
        return _data;
    }
    public function write(object:ByteArray):void{
        _data = object;
        _data.position = 0;
    }
}