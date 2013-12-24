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
    import flash.display.DisplayObject;

    /**
     * ...
     * @author
     */
    public class RetrocamelEffectMove extends RetrocamelEffectBase {
        private var _initialX:Number;
        private var _initialY:Number;
        private var _targetX:Number;
        private var _targetY:Number;
        private var _target:DisplayObject;

        public static function make(target:DisplayObject):RetrocamelEffectMove{
            return new RetrocamelEffectMove(target);
        }

        public function RetrocamelEffectMove(target:DisplayObject) {
            _target = target;

            _initialX = _target.x;
            _targetX = _target.x;
            _initialY = _target.y;
            _targetY = _target.y;
        }

        override public function update():void {
            if (_blocked) {
                return blockUpdate();
            }

            _target.x = getInterval(_initialX, _targetX);
            _target.y = getInterval(_initialY, _targetY);

            super.update();
        }

        public function initialX(value:Number):RetrocamelEffectMove{
            _initialX = value;

            return this;
        }
        public function initialY(value:Number):RetrocamelEffectMove{
            _initialY = value;

            return this;
        }
        public function targetX(value:Number):RetrocamelEffectMove{
            _targetX = value;

            return this;
        }
        public function targetY(value:Number):RetrocamelEffectMove{
            _targetY = value;

            return this;
        }
    }
}