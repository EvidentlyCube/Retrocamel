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
 * Time: 19:36
 * To change this template use File | Settings | File Templates.
 */
package net.retrocade_old.utils {

    import net.retrocade.utils.UtilsCrypto;
    import net.retrocade.utils.UtilsString;

    import org.flexunit.Assert;

    public class UCryptoTest {
        [Test]
        public function testEncryption_longEncodedText():void{
            var testText:String;
            var testKey:String;
            var ciphered:String;
            var deciphered:String;

            for (var i:int = 0; i < 12; i++){
                testText = UtilsString.randomText(Math.pow(2, i));
                testKey = "dabsd89abvre9";

                ciphered   = UtilsCrypto.encrypt(testText, testKey);
                deciphered = UtilsCrypto.decrypt(ciphered, testKey);

                Assert.assertEquals(testText, deciphered);
            }
        }

        [Test]
        public function testEncryption_longEncodingKeys():void{
            var testText:String;
            var testKey:String;
            var ciphered:String;
            var deciphered:String;

            for (var i:int = 1; i < 256; i++){
                testText = "This is my net.retrocade.random text";
                testKey = UtilsString.randomText(i);

                ciphered   = UtilsCrypto.encrypt(testText, testKey);
                deciphered = UtilsCrypto.decrypt(ciphered, testKey);

                Assert.assertEquals(testText, deciphered);
            }
        }
    }
}
