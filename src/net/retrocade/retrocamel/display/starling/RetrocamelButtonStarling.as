/*
 * Copyright (C) 2013 Maurycy Zarzycki
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

package net.retrocade.retrocamel.display.starling{
    import flash.utils.clearTimeout;
    import flash.utils.setTimeout;

    import net.retrocade.retrocamel.core.retrocamel_int;

    import starling.display.DisplayObjectContainer;

    import starling.display.Sprite;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;

    use namespace retrocamel_int;

    public class RetrocamelButtonStarling extends Sprite{
        /****************************************************************************************************************/
        /**                                                                                                  VARIABLES  */
        /****************************************************************************************************************/

            public var clickable:Boolean = true;

        // ::::::::::::::::::::::::::::::::::::::::::::::
        // :: Enabled
        // ::::::::::::::::::::::::::::::::::::::::::::::

        protected var _enabled:Boolean = true;

        public function get enabled():Boolean{
            return _enabled;
        }

        public function set enabled(value:Boolean):void{
            if (_enabled == value){
                return;
            }

            _enabled = value;

            if (value){
                effectEnabled();
            } else {
                effectDisabled();
            }
        }

        public var clickEffectDuration:uint = 250;

        override public function set x(value:Number):void{
            super.x = value | 0;
        }

        override public function set y(value:Number):void{
            super.y = value | 0;
        }

        private var _clickEffectTimer:Number;



        // ::::::::::::::::::::::::::::::::::::::::::::::
        // :: Misc
        // ::::::::::::::::::::::::::::::::::::::::::::::

        public var clickCallback    :Function;

        public var data:Object;


        /****************************************************************************************************************/
        /**                                                                                                  FUNCTIONS  */
        /****************************************************************************************************************/

            // ::::::::::::::::::::::::::::::::::::::::::::::
            // :: Constructor
            // ::::::::::::::::::::::::::::::::::::::::::::::

        public function RetrocamelButtonStarling(clickCallback:Function){
            this.clickCallback = clickCallback;

            addEventListener(TouchEvent.TOUCH, onTouch);

            data = {};
        }

        public function destroy():void{
            removeChildren();

            removeEventListener(TouchEvent.TOUCH, onTouch);
            clickCallback = null;

            data = null;

            if (_clickEffectTimer){
                clearTimeout(_clickEffectTimer);
            }
        }

        protected function effectDisabled():void{
            alpha = 1;
        }

        protected function effectEnabled():void{
            alpha = 0.5;
        }

        protected function rollOverEffect():void{
            alpha = 0.8;
        }

        protected function rollOutEffect():void{
            alpha = 1;
        }

        protected function clickEffect():void{
            alpha = 0.7;
        }

        protected function unclickEffect():void{
            alpha = 1;
        }

        protected function onTouch(e:TouchEvent):void{
            var touch:Touch = e.getTouch(this);

            if (!clickable){
                return;
            }

            if (!touch){
                rollOutEffect();
            } else if (touch.phase == TouchPhase.HOVER){
                rollOverEffect();
            } else if (touch.phase == TouchPhase.ENDED){
                onClicked();
            }
        }

        protected function onClicked():void{
            if (!canClick()){
                return;
            }

            if (_clickEffectTimer){
                clearTimeout(_clickEffectTimer);
            }

            clickEffect();
            _clickEffectTimer = setTimeout(unclickEffect, clickEffectDuration);

            if (clickCallback !== null){
                if (clickCallback.length == 0){
                    clickCallback();
                } else {
                    clickCallback(this);
                }
            }
        }

        final protected function canClick():Boolean{
            if (_enabled == false){
                return false;
            }

            var crawl:DisplayObjectContainer = this;

            do{
                if (!crawl.touchable){
                    return false;
                }
                crawl = crawl.parent;
            } while (crawl);

            return true;
        }
    }
}