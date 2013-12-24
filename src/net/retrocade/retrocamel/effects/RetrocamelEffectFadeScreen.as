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

    import flash.display.Sprite;
    import flash.events.Event;

    import net.retrocade.retrocamel.components.RetrocamelUpdatableGroup;

    import net.retrocade.retrocamel.core.RetrocamelCore;
    import net.retrocade.retrocamel.core.retrocamel_int;
    import net.retrocade.retrocamel.display.layers.RetrocamelLayerFlashSprite;

    use namespace retrocamel_int;

    public class RetrocamelEffectFadeScreen extends RetrocamelScreenEffectBase {
        private var _alphaFrom:Number = 1;
        private var _alphaTo:Number = 0;
        private var _color:uint = 0x000000

        public static function make():RetrocamelEffectFadeScreen{
            return new RetrocamelEffectFadeScreen();
        }

        public static function makeOut():RetrocamelEffectFadeScreen{
            return make().alphaFrom(1).alphaTo(0);
        }

        public static function makeIn():RetrocamelEffectFadeScreen{
            return make().alphaFrom(0).alphaTo(1);
        }

        public function RetrocamelEffectFadeScreen() {
            super(new RetrocamelLayerFlashSprite());
        }

        override public function update():void {
            if (_blocked) {
                return blockUpdate();
            }

            typedLayer.alpha = 1 - _alphaFrom - (_alphaTo - _alphaFrom) * interval;

            super.update();
        }

        private function redraw():void {
            typedLayer.graphics.clear();
            typedLayer.graphics.beginFill(_color, 1);
            typedLayer.graphics.drawRect(0, 0, RetrocamelCore.settings.gameWidth, RetrocamelCore.settings.gameHeight);
            typedLayer.graphics.endFill();
        }

        override protected function onResize(e:Event):void {
            redraw();
        }

        public function alphaFrom(value:Number):RetrocamelEffectFadeScreen{
            _alphaFrom = value;

            return this;
        }

        public function alphaTo(value:Number):RetrocamelEffectFadeScreen{
            _alphaTo = value;

            return this;
        }

        public function color(value:uint):RetrocamelEffectFadeScreen{
            _color = value;

            return this;
        }

        private function get typedLayer():RetrocamelLayerFlashSprite {
            return RetrocamelLayerFlashSprite(_layer);
        }

        override public function run(addTo:RetrocamelUpdatableGroup = null):RetrocamelEffectBase {
            redraw();

            return super.run(addTo);
        }
    }
}