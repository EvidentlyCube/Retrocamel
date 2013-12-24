/*
 * Copyright (C) 2013 Maurycy Zarzycki
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

package net.retrocade.retrocamel.display.flash{

    import net.retrocade.helpers.ColorMatrixFilterHelper;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import net.retrocade.retrocamel.display.flash.RetrocamelSprite;

    import net.retrocade.retrocamel.core.RetrocamelDisplayManager;
    import net.retrocade.retrocamel.core.retrocamel_int;

    use namespace retrocamel_int;

    public class RetrocamelButton extends RetrocamelSprite{
        /****************************************************************************************************************/
        /**                                                                                                  VARIABLES  */
        /****************************************************************************************************************/

        // ::::::::::::::::::::::::::::::::::::::::::::::
        // :: Enabled
        // ::::::::::::::::::::::::::::::::::::::::::::::

        protected var _enabled:Boolean = true;

        public function get enabled():Boolean{
            return _enabled;
        }

        public function set enabled(value:Boolean):void{
            if (value)
                enable();
            else
                disable();
        }

        protected var _clickDisabled:Boolean = false;

        public function set clickDisabled(disabled:Boolean):void{
            _clickDisabled = disabled;

            buttonMode = !disabled;

            colorizer.luminosity = disabled ? 0.6 : 1;
        }



        // ::::::::::::::::::::::::::::::::::::::::::::::
        // :: Misc
        // ::::::::::::::::::::::::::::::::::::::::::::::

        public var colorizer:ColorMatrixFilterHelper;

        public var mouseDownCallback:Function;
        public var mouseUpCallback:Function;
        public var clickCallback    :Function;
        public var rollOverCallback :Function;
        public var rollOutCallback  :Function;

        public var ignoreHighlight  :Boolean = false;

        public var data:*;

        protected var clickRegister:Boolean = false;




        /****************************************************************************************************************/
        /**                                                                                                  FUNCTIONS  */
        /****************************************************************************************************************/

        // ::::::::::::::::::::::::::::::::::::::::::::::
        // :: Constructor
        // ::::::::::::::::::::::::::::::::::::::::::::::

        public function RetrocamelButton(clickCallback:Function, rollOverCallback:Function = null, rollOutCallback:Function = null, enabled:Boolean = true){
            colorizer = new ColorMatrixFilterHelper(this);

            this.clickCallback = clickCallback;

            this.rollOverCallback = rollOverCallback;
            this.rollOutCallback  = rollOutCallback;

            addEventListener(Event.ADDED_TO_STAGE,     addEventListeners);
            addEventListener(Event.REMOVED_FROM_STAGE, removeEventListeners);

            buttonMode = true;

            this.enabled = enabled;
        }

        protected function addEventListeners(e:*):void{
            addEventListener(MouseEvent.MOUSE_DOWN, onTouchBegin, false, 0, true);
            addEventListener(MouseEvent.MOUSE_UP,   onTouchEnd,   false, 0, true);
            addEventListener(MouseEvent.ROLL_OVER,  onRollOver,  false, 0, true);
            addEventListener(MouseEvent.ROLL_OUT,   onRollOut,   false, 0, true);

            RetrocamelDisplayManager.flashStage.addEventListener(MouseEvent.MOUSE_UP, onStageTouchEnd, false, 0, true);
        }

        protected function removeEventListeners(e:*):void{
            removeEventListener(MouseEvent.MOUSE_DOWN, onTouchBegin);
            removeEventListener(MouseEvent.MOUSE_UP,   onTouchEnd);
            removeEventListener(MouseEvent.ROLL_OVER,  onRollOver);
            removeEventListener(MouseEvent.ROLL_OUT,   onRollOut);

            RetrocamelDisplayManager.flashStage.removeEventListener(MouseEvent.MOUSE_UP, onStageTouchEnd);
        }



        // ::::::::::::::::::::::::::::::::::::::::::::::
        // :: Enabling
        // ::::::::::::::::::::::::::::::::::::::::::::::

        public function enable():void{
            _enabled = true;

            mouseChildren = true;
            mouseEnabled  = true;

            colorizer.saturation = 1;
            colorizer.luminosity = 1;
        }

        public function disable():void{
            mouseChildren = false;
            mouseEnabled  = false;

            colorizer.saturation = 0;
            colorizer.luminosity = 0.75;
        }



        // ::::::::::::::::::::::::::::::::::::::::::::::
        // :: Roll Effect
        // ::::::::::::::::::::::::::::::::::::::::::::::

        public function rollOverEffect():void {
            colorizer.brightness = 50;
        }

        public function rollOutEffect():void {
            colorizer.brightness = 0;
        }



        /****************************************************************************************************************/
        /**                                                                                            EVENT LISTENERS  */
        /****************************************************************************************************************/

        protected function onRollOver(e:MouseEvent):void{
            if (!ignoreHighlight)
                rollOverEffect();

            if (rollOverCallback != null)
                if (rollOverCallback.length)
                    rollOverCallback(this);
                else
                    rollOverCallback();
        }

        protected function onRollOut(e:MouseEvent):void{
            if (!ignoreHighlight)
                rollOutEffect();

            if (rollOutCallback != null)
                if (rollOutCallback.length)
                    rollOutCallback(this);
                else
                    rollOutCallback();
        }

        protected function onClick(e:MouseEvent):void{
            clickRegister = false;

            if (_clickDisabled)
                return;

            if (clickCallback != null)
                if (clickCallback.length)
                    clickCallback(this);
                else
                    clickCallback();

            if (stage)
                stage.focus = stage;
        }

        protected function onTouchBegin(e:MouseEvent):void{
            clickRegister = true;

            if (_clickDisabled)
                return;

            if (mouseDownCallback != null)
                if (mouseDownCallback.length)
                    mouseDownCallback(this);
                else
                    mouseDownCallback();
        }

        protected function onTouchEnd(e:MouseEvent):void{
            if (_clickDisabled)
                return;

            if (mouseUpCallback != null)
                if (mouseUpCallback.length)
                    mouseUpCallback(this);
                else
                    mouseUpCallback();

            if (clickRegister)
                onClick(e);
        }

        protected function onStageTouchEnd(e:MouseEvent):void{
            clickRegister = false;
        }
    }
}