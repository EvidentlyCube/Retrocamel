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
    import flash.utils.getQualifiedClassName;

    public class RetrocamelEffectSequence extends RetrocamelEffectBase {
        public static function make():RetrocamelEffectSequence {
            return new RetrocamelEffectSequence();
        }

        private var _effectStack:Vector.<RetrocamelEffectBase>;
        private var _currentEffect:RetrocamelEffectBase;

        public function RetrocamelEffectSequence() {
            _effectStack = new Vector.<RetrocamelEffectBase>();
        }

        override public function skip():void {
            if (_currentEffect) {
                _currentEffect.skip();
            }

            for each(var effect:RetrocamelEffectBase in _effectStack) {
                effect.run(addTo).skip();
            }

            super.skip();
        }

        override protected function finish():void {
            _currentEffect = null;
            _effectStack = null;

            super.finish();
        }

        override public function update():void {
            if (!_currentEffect) {
                _currentEffect = _effectStack.shift();
                _currentEffect.run(addTo);
            }

            if (_currentEffect.hasFinished) {
                _currentEffect = null;

                if (_effectStack.length === 0) {
                    finish();
                } else {
                    update();
                }
            }
        }

        public function skipCurrentEffect():void{
            if (_currentEffect){
                _currentEffect.skip();
                _currentEffect = null;
            }
        }

        public function addEffect(effect:RetrocamelEffectBase):RetrocamelEffectSequence {
            if (!effect) {
                throw new ArgumentError("Added effect cannot be null");
            } else if (effect.isRunning) {
                throw new ArgumentError("Cannot add running effect to effect sequence");
            }

            _effectStack.push(effect);

            return this;
        }

        public function addEffects(...rest:Array):RetrocamelEffectSequence {
            for each(var effect:Object in rest) {
                if (effect is RetrocamelEffectBase) {
                    addEffect(effect as RetrocamelEffectBase);
                } else {
                    throw new ArgumentError("Cannot add '" + getQualifiedClassName(effect) + "' to effect sequence.");
                }
            }

            return this;
        }
    }
}