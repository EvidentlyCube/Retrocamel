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
    import net.retrocade.retrocamel.core.RetrocamelCore;
    import net.retrocade.retrocamel.core.retrocamel_int;
    import net.retrocade.retrocamel.display.layers.RetrocamelLayerFlashSprite;

    use namespace retrocamel_int;

    public class RetrocamelEffectSolidScreen extends RetrocamelScreenEffectBase {
        public static function make():RetrocamelEffectSolidScreen {
            return new RetrocamelEffectSolidScreen();
        }

        private var _alpha:Number = 1;
        private var _color:uint = 0x000000;

        public function RetrocamelEffectSolidScreen() {
            super(new RetrocamelLayerFlashSprite());
        }

        override public function update():void {
        }

        override public function run(addTo:RetrocamelUpdatableGroup = null):RetrocamelEffectBase {
            typedLayer.graphics.beginFill(_color, _alpha);
            typedLayer.graphics.drawRect(0, 0, RetrocamelCore.settings.gameWidth, RetrocamelCore.settings.gameHeight);
            typedLayer.graphics.endFill();

            return super.run(addTo);
        }

        public function alpha(value:Number):RetrocamelEffectSolidScreen {
            _alpha = value;

            return this;
        }

        public function color(value:uint):RetrocamelEffectSolidScreen {
            _color = value;

            return this;
        }

        public function get flashSpriteLayer():RetrocamelLayerFlashSprite {
            return typedLayer;
        }

        private function get typedLayer():RetrocamelLayerFlashSprite {
            return RetrocamelLayerFlashSprite(_layer);
        }
    }
}