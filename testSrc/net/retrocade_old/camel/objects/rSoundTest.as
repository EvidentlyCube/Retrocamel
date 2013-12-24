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
 * Date: 07.03.13
 * Time: 08:01
 * To change this template use File | Settings | File Templates.
 */
package net.retrocade_old.camel.objects {
    import flash.media.Sound;

    import net.retrocade.retrocamel.core.RetrocamelSoundManager;

    import net.retrocade.retrocamel.core.retrocamel_int;
    import net.retrocade.retrocamel.sound.RetrocamelSound;

    import org.flexunit.asserts.assertEquals;
    import org.flexunit.asserts.fail;

    public class rSoundTest {
        private var sound:RetrocamelSound;
        [Before]
        public function setUp():void {
            sound = new RetrocamelSound(new Sound());
        }

        [Test]
        public function testMaxVolume():void {
            for (var i:Number = 0; i <= 1; i+= 0.0625){
                sound.retrocamel_int::maxVolume = i;
                assertEquals(i, sound.retrocamel_int::maxVolume);
            }
        }

        [Test]
        public function testRealVolume():void{
            sound.retrocamel_int::maxVolume = 0.5;
            assertEquals(0.5, sound.retrocamel_int::realVolume);

            sound.volume = 0.5;
            assertEquals(0.25, sound.retrocamel_int::realVolume);
        }

        [Test]
        public function testRegisteringAsMusic():void{
            sound.registerAsMusic();
            RetrocamelSoundManager.musicVolume = 0.5;

            assertEquals(0.5, sound.retrocamel_int::maxVolume);
        }

        [Test]
        public function testRegisteringAsSound():void{
            sound.registerAsSFX();
            RetrocamelSoundManager.soundVolume = 0.5;

            assertEquals(0.5, sound.retrocamel_int::maxVolume);
        }
    }
}
