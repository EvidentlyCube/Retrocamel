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

    import net.retrocade.retrocamel.components.RetrocamelUpdatableGroup;

    public class RetrocamelEffectParallel extends RetrocamelEffectBase {
        public static function make():RetrocamelEffectParallel {
            return new RetrocamelEffectParallel();
        }

        private var _canFinish:Boolean = false;

        private var _effectStack:Vector.<RetrocamelEffectBase>;

        public function RetrocamelEffectParallel() {
            _effectStack = new Vector.<RetrocamelEffectBase>();
        }

        override public function skip():void {
            for each(var effect:RetrocamelEffectBase in _effectStack) {
                if (effect.isRunning){
                    effect.skip();
                }
            }

            super.skip();
        }

        override protected function finish():void {
            _effectStack = null;

            super.finish();
        }

        override public function update():void {
            if (_canFinish){
                finish();
            }
        }


        override public function run(addTo:RetrocamelUpdatableGroup = null):RetrocamelEffectBase {
            super.run(addTo);

            for each(var effect:RetrocamelEffectBase in _effectStack){
                effect.run();
            }

            _canFinish = true;

            return this;
        }

        public function addEffect(effect:RetrocamelEffectBase):RetrocamelEffectParallel {
            if (!effect) {
                throw new ArgumentError("Added effect cannot be null");
            } else if (effect.isRunning) {
                throw new ArgumentError("Cannot add running effect to effect sequence");
            }

            _effectStack.push(effect);

            return this;
        }

        public function addEffects(...rest:Array):RetrocamelEffectParallel {
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