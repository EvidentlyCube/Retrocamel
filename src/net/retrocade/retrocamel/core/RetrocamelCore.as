/*
 * Copyright (C) 2013 Maurycy Zarzycki
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

package net.retrocade.retrocamel.core {

    import net.retrocade.retrocade.RetrocadeBottomBar;
    import net.retrocade.retrocamel.display.global.RetrocamelCursor;
    import net.retrocade.retrocamel.global.RetrocamelEventsQueue;
    import net.retrocade.retrocamel.components.RetrocamelUpdatableGroup;
    import net.retrocade.retrocamel.components.RetrocamelStateBase;
    import flash.display.DisplayObjectContainer;
    import flash.display.Stage;
    import flash.events.Event;
    import flash.utils.getTimer;

    import net.retrocade.retrocamel.interfaces.IRetrocamelMake;

    import net.retrocade.retrocamel.interfaces.IRetrocamelSettings;
    import net.retrocade.retrocamel.locale.RetrocamelLocale;

    use namespace retrocamel_int;

    /**
     * ...
     * @author Maurycy Zarzycki
     */
    public class RetrocamelCore {
        /**
         * Time spent since last step
         */
        private static var _deltaTime:Number = 0;

        /**
         * Time which passed since last step
         */
        public static function get deltaTime():Number {
            return _deltaTime;
        }

        /**
         * Global updates group which is always updated before anything else
         */
        private static var _groupBefore:RetrocamelUpdatableGroup = new RetrocamelUpdatableGroup();

        /**
         * Retrieves global updates group which is always updated before everything else
         */
        public static function get groupBefore():RetrocamelUpdatableGroup {
            return _groupBefore;
        }

        /**
         * Global updates group which is always updated after anything else
         */
        private static var _groupAfter:RetrocamelUpdatableGroup = new RetrocamelUpdatableGroup();

        /**
         * Retrieves global updates group which is always updated after everything else
         */
        public static function get groupAfter():RetrocamelUpdatableGroup {
            return _groupAfter;
        }


        /**
         * Time of last enter frame
         */
        private static var _lastTime:Number = 0;

        /**
         * The settings object
         */
        retrocamel_int static var settings:IRetrocamelSettings;

        /**
         * The make object
         */
        retrocamel_int static var make:IRetrocamelMake;

        /**
         * Currently displayed state
         */
        private static var _currentState:RetrocamelStateBase;

        /**
         * Retrieves current state
         */
        public static function get currentState():RetrocamelStateBase {
            return _currentState;
        }


        /**
         * Boolean indicating if the game is currently paused
         */
        private static var _paused:Boolean = false;

        /**
         * Accesses the flag indicating if game is paused or not
         */
        public static function get paused():Boolean {
            return _paused;
        }

        /**
         * @private
         */
        public static function set paused(value:Boolean):void {
            _paused = value;
        }

        /**
         * A function to call if an error is found (only during enter frame execution).
         * The error will be passed as the first argument.
         * If not set, the error handling will work as default in flash.
         */
        public static var errorCallback:Function;

        /**
         * Initialzes the whole game
         */
        public static function initFlash(stage:Stage, main:DisplayObjectContainer, settingsInstance:IRetrocamelSettings, makeInstance:IRetrocamelMake):void {
            settings = settingsInstance;
            make = makeInstance;

            RetrocamelLocale.initialize();
            RetrocamelInputManager.initialize(stage);
            RetrocamelDisplayManager.initializeFlash(main, stage);

            RetrocamelEventsQueue.initialize();

            stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
        }


        /**
         * Changes the current state
         * @param state State to be set
         */
        public static function setState(state:RetrocamelStateBase):void {
            if (_currentState) {
                _currentState.destroy();
            }

            _currentState = state;
            _currentState.create();
        }

        private static function onEnterFrame(e:Event = null):void {
            if (errorCallback != null) {
                try {
                    onEnterFrameSub();
                } catch (error:Error) {
                    errorCallback(error);
                }
            } else {
                onEnterFrameSub();
            }
        }

        private static function onEnterFrameSub():void {
            if (RetrocamelDisplayManager.flashStage.focus && !RetrocamelDisplayManager.flashStage.focus.stage) {
                RetrocamelDisplayManager.flashStage.focus = null;
            }

            if (RetrocamelEventsQueue.autoClear) {
                RetrocamelEventsQueue.clear();
            }

            _deltaTime = getTimer() - _lastTime;
            _lastTime = getTimer();

            RetrocamelWindowsManager.update();

            _groupBefore.update();
            if (_currentState && !_paused && !RetrocamelWindowsManager.pauseGame) {
                _currentState.update();
            }
            _groupAfter.update();

            RetrocamelCursor.update();

            RetrocamelInputManager.onEnterFrameUpdate();
            RetrocadeBottomBar.update();
        }

        retrocamel_int static function onStageResized():void {
            if (_currentState) {
                _currentState.resize();
            }
        }
    }
}