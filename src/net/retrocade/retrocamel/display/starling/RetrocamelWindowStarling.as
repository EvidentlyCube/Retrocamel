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
    import flash.geom.Rectangle;
    
    import net.retrocade.retrocamel.core.RetrocamelCore;
    import net.retrocade.retrocamel.core.RetrocamelDisplayManager;
    import net.retrocade.retrocamel.core.RetrocamelWindowsManager;
    import net.retrocade.retrocamel.core.retrocamel_int;
    import net.retrocade.retrocamel.interfaces.IRetrocamelWindow;
    import net.retrocade.retrocamel.core.RetrocamelStarlingCore;
    
    import starling.display.Sprite;

    use namespace retrocamel_int;

    /**
     * ...
     * @author Maurycy Zarzycki
     */
    public class RetrocamelWindowStarling extends Sprite implements IRetrocamelWindow{
        /****************************************************************************************************************/
        /**                                                                                                  VARIABLES  */
        /****************************************************************************************************************/

        /**
         * Should this window block input to all underlying windows?
         */
        protected var _blockUnder:Boolean = true;

        public function get blockUnder():Boolean{
            return _blockUnder;
        }

        /**
         * Should the game be paused when this window is displayed?
         */
        protected var _pauseGame :Boolean = true;

        public function get pauseGame():Boolean{
            return _pauseGame;
        }




        // ::::::::::::::::::::::::::::::::::::::::::::::
        // :: Helpers
        // ::::::::::::::::::::::::::::::::::::::::::::::

        /**
         * HELPER: Value of touchab;e before block
         */
        private var _lastTouchable:Boolean = true;

        private var _isBlocked        :Boolean = false;

        public function isBlocked():Boolean {
            return _isBlocked;
        }



        /****************************************************************************************************************/
        /**                                                                                                  FUNCTIONS  */
        /****************************************************************************************************************/

        /**
         * Adds the window to display and show it
         */
        public function show():void{
            RetrocamelWindowsManager.addWindow(this);
        }

        /**
         * Remove the window from the display
         */
        public function hide():void{
            RetrocamelWindowsManager.removeWindow(this);
        }

        public function resize():void{}

        /**
         * Called by windows manager when window above it blocks this one
         */
        public function block():void{
            if (_isBlocked)
                return;

            _isBlocked = true;
            _lastTouchable = touchable;
            
            touchable = false;
        }

        public function unblock():void{
            _isBlocked = false;
            touchable = _lastTouchable
        }

        public function update():void{}
    }
}