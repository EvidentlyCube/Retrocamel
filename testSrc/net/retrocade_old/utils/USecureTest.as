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
 * Time: 17:26
 * To change this template use File | Settings | File Templates.
 */
package net.retrocade_old.utils {
    import flexunit.framework.Assert;

    import net.retrocade.utils.UtilsSecure;
    import net.retrocade.utils.UtilsString;

    public class USecureTest {
        [Test]
        public function testRotComplex_alwaysSameResult():void{
            for (var i:int = 0; i < 1000; i++){
                var testString:String = UtilsString.randomText(128);

                var result1:String = UtilsSecure.rotComplexForward(testString);
                var result2:String = UtilsSecure.rotComplexForward(testString);

                Assert.assertEquals(result1, result2);
            }
        }

        [Test]
        public function testRotComplex_sameResultForLongString():void{
            for (var i:int = 0; i < 19; i++){
                var testString:String = UtilsString.randomText(Math.pow(2, i));

                var result1:String = UtilsSecure.rotComplexForward(testString);
                var result2:String = UtilsSecure.rotComplexForward(testString);

                Assert.assertEquals(result1, result2);
            }
        }

        [Test]
        public function testRotComplex_revertsBackCorrectly():void{
            for (var i:int = 0; i < 1000; i++){
                var testString:String = UtilsString.randomText(128);

                var rottedString:String = UtilsSecure.rotComplexForward(testString);
                rottedString = UtilsSecure.rotComplexBackwards(rottedString);

                Assert.assertEquals(testString, rottedString);
            }
        }

        [Test]
        public function testRotComplex_revertsBackCorrectlyLongString():void{
            for (var i:int = 0; i < 19; i++){
                var testString:String = UtilsString.randomText(Math.pow(2, i));

                var rottedString:String = UtilsSecure.rotComplexForward(testString);
                rottedString = UtilsSecure.rotComplexBackwards(rottedString);

                Assert.assertEquals(testString, rottedString);
            }
        }
    }
}
