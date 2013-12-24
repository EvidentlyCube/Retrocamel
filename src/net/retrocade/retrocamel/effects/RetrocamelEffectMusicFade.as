/*
 * Copyright (C) 2013 Maurycy Zarzycki
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

package net.retrocade.retrocamel.effects {
    import net.retrocade.retrocamel.components.RetrocamelUpdatableGroup;
    import net.retrocade.retrocamel.core.RetrocamelSoundManager;
    import net.retrocade.retrocamel.core.retrocamel_int;

    use namespace retrocamel_int;

    public class RetrocamelEffectMusicFade extends RetrocamelEffectBase {
        private static var _currentMusicFade:RetrocamelEffectMusicFade;
        private var _fadeFrom:Number;
        private var _fadeTo:Number;

        public static function make(fadeTo:Number):RetrocamelEffectMusicFade{
            return new RetrocamelEffectMusicFade(fadeTo);
        }

        public function RetrocamelEffectMusicFade(fadeTo:Number) {
            _fadeFrom = RetrocamelSoundManager.musicFadeVolume;
            _fadeTo = fadeTo;
        }

        override public function update():void {
            if (_blocked) {
                return blockUpdate();
            }

            RetrocamelSoundManager.musicFadeVolume = getInterval(_fadeFrom, _fadeTo);

            super.update();
        }

        override protected function finish():void {
            RetrocamelSoundManager.musicFadeVolume = _fadeTo;

            _currentMusicFade = null;

            super.finish();
        }

        public function fadeFrom(value:Number):RetrocamelEffectMusicFade{
            _fadeFrom = value;

            return this;
        }

        override public function run(addTo:RetrocamelUpdatableGroup = null):RetrocamelEffectBase {
            if (_currentMusicFade) {
                _currentMusicFade.finish();
                _currentMusicFade = this;
            }

            return super.run(addTo);
        }
    }
}