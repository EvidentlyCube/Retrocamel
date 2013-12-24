/*
 * Copyright (C) 2013 Maurycy Zarzycki
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

package net.retrocade.retrocamel.effects{
    import flash.display.DisplayObject;
    
    import net.retrocade.retrocamel.components.RetrocamelUpdatableGroup;
    
    public class RetrocamelEffectFadeFlash extends RetrocamelEffectBase{
        private var _alphaFrom:Number = 0;
        private var _alphaTo  :Number = 1;
        
        private var _target   :DisplayObject;
        
        public static function doMany(toFade:Array, alphaFrom:Number = 1, alphaTo:Number = 1, duration:uint = 200, 
                                      callback:Function = null, addTo:RetrocamelUpdatableGroup = null):void
        {
            for each (var displayObject:DisplayObject in toFade){
                RetrocamelEffectFadeFlash.make(displayObject)
                    .alphaFrom(alphaFrom)
                    .alphaTo(alphaTo)
                    .duration(duration)
                    .callback(callback)
                    .run(addTo);
            }
        }

        public static function make(target:DisplayObject):RetrocamelEffectFadeFlash{
            return new RetrocamelEffectFadeFlash(target);
        }
        
        public function RetrocamelEffectFadeFlash(toFade:DisplayObject){
            _target = toFade;

            if (!_target.visible || _target.alpha <= 0){
                _alphaFrom = 0;
                _alphaTo = 1;
            } else {
                _alphaFrom = _target.alpha;
                _alphaTo = 0;
            }
        }
        
        override public function update():void {
            if (_blocked) {
                blockUpdate();
            } else {
                _target.visible = true;
                _target.alpha = getInterval(_alphaFrom, _alphaTo);

                super.update();
            }
        }
        
        override protected function finish():void{
            _target.alpha = _alphaTo;

            if (_target.alpha <= 0){
                _target.visible = false;
                _target.alpha = 0;
            }
            
            super.finish();
        }
        
        override public function skip():void{
            _target.alpha = _alphaTo;

            super.skip();
        }

        public function alpha(valueFrom:Number, valueTo:Number):RetrocamelEffectFadeFlash{
            return this.alphaFrom(valueFrom).alphaTo(valueTo);
        }

        public function alphaFrom(value:Number):RetrocamelEffectFadeFlash{
            _alphaFrom = value;

            return this;
        }

        public function alphaTo(value:Number):RetrocamelEffectFadeFlash{
            _alphaTo = value;

            return this;
        }
    }
}