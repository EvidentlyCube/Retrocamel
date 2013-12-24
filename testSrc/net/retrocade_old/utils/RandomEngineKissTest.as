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
 * User: mzarzycki
 * Date: 02.10.13
 * Time: 10:11
 * To change this template use File | Settings | File Templates.
 */
package net.retrocade_old.utils {

    import net.retrocade.functions.printf;
    import random.RandomEngineKiss;

    import org.flexunit.assertThat;

    import org.flexunit.asserts.assertEquals;
    import org.flexunit.asserts.assertTrue;

    public class RandomEngineKissTest {
        private static const DEFAULT_SEED_A:int = 58000;
        private static const DEFAULT_SEED_B:int = 68000;
        private static const DEFAULT_SEED_C1:int = 78000;
        private static const DEFAULT_SEED_C2:int = 88000;
        private static const DEFAULT_SEED_C3:int = 1;
        private var _kiss:RandomEngineKiss;

        [Before]
        public function setUp():void {
            _kiss = new RandomEngineKiss();

            sub_setSeedToDefault();
        }

        private function sub_setSeedToDefault(){
            _kiss.setSeedSingular(
                    DEFAULT_SEED_A,
                    DEFAULT_SEED_B,
                    DEFAULT_SEED_C1,
                    DEFAULT_SEED_C2,
                    DEFAULT_SEED_C3
            );
        }

        public function RandomEngineKissTest() {
        }

        [Test]
        public function testSetSeedFromString():void {
            _kiss.setSeed("1:2:3:4:0");

            assertEquals(1, _kiss.seed1);
            assertEquals(2, _kiss.seed2);
            assertEquals(3, _kiss.seed3A);
            assertEquals(4, _kiss.seed3B);
            assertEquals(0, _kiss.seed3C);
        }

        [Test]
        public function testGetUint():void {
            var firstUint:uint = _kiss.getUint();

            sub_setSeedToDefault();

            var secondUint:uint = _kiss.getUint();

            assertEquals(firstUint, secondUint);
        }

        [Test]
        public function testSetSeed():void {
            assertEquals(DEFAULT_SEED_A, _kiss.seed1);
            assertEquals(DEFAULT_SEED_B, _kiss.seed2);
            assertEquals(DEFAULT_SEED_C1, _kiss.seed3A);
            assertEquals(DEFAULT_SEED_C2, _kiss.seed3B);
            assertEquals(DEFAULT_SEED_C3, _kiss.seed3C);
        }

        [Test]
        public function testGetSeedAsString():void {
            var retrievedSeed:String = _kiss.getSeed();
            var generatedSeed:String = printf("%%:%%:%%:%%:%%", DEFAULT_SEED_A, DEFAULT_SEED_B, DEFAULT_SEED_C1, DEFAULT_SEED_C2, DEFAULT_SEED_C3);

            assertEquals(generatedSeed, retrievedSeed);
        }

        [Test]
        public function testGetNumber():void{
            var tests:int = 100;
            var results:Array = [];

            while (tests--){
                var result:Number = _kiss.getNumber();

                assertEquals(-1, results.indexOf(result));
                results.push(result);
            }

            trace(results);
        }

        [Test]
        public function testGetNumberRange():void{
            var tests:int = 10000;

            var rangeDown:Number = 1.73;
            var rangeTop:Number = 7.33;
            while (tests--){
                var randomResult:Number = _kiss.getNumberRange(rangeDown, rangeTop);

                assertTrue(randomResult >= rangeDown);
                assertTrue(randomResult <= rangeTop);
            }
        }
    }
}
