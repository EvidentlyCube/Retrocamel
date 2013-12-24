/*
 * Copyright (C) 2013 Maurycy Zarzycki
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

package net.retrocade.retrocamel.components{
    import flash.events.EventDispatcher;

    import net.retrocade.retrocamel.core.RetrocamelCore;

    public class RetrocamelStateBase extends EventDispatcher{
        protected var _defaultGroup:RetrocamelUpdatableGroup;
        
        public function get defaultGroup():RetrocamelUpdatableGroup{
            return _defaultGroup;
        }
        
        public function RetrocamelStateBase(){
            _defaultGroup = new RetrocamelUpdatableGroup
        }
        
        
        
        /****************************************************************************************************************/
        /**                                                                                                  OVERRIDES  */
        /****************************************************************************************************************/   
        
        /**
         * Called when state is set 
         */
        public function create():void{
            resize();
        }

        final public function isSet():Boolean{
            return RetrocamelCore.currentState == this;
        }
        
        /**
         * Called when state is unset 
         */
        public function destroy():void{
            _defaultGroup.clear();
        }
        
        /**
         * State update 
         */
        public function update():void{
            _defaultGroup.update();
        }

        public function resize():void{

        }
        
        /**
         * Sets this state, useful when you are working with State Instance variable
         */
        final public function setToMe():void{
            RetrocamelCore.setState(this);
        }
    }
}