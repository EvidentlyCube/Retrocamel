/*
 * Copyright (C) 2013 Maurycy Zarzycki
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

package net.retrocade.retrocamel.components {

    import net.retrocade.retrocamel.components.RetrocamelUpdatableObject;


    public class RetrocamelDisplayObject extends RetrocamelUpdatableObject {

        /****************************************************************************************************************/
        /**                                                                                                  VARIABLES  */
        /****************************************************************************************************************/

        // ::::::::::::::::::::::::::::::::::::::::::::::
        // :: X Position
        // ::::::::::::::::::::::::::::::::::::::::::::::

        /**
         * X position of the object
         */
        protected var _x:Number;
        /**
         * Y position of the object
         */
        protected var _y:Number;
        /**
         * Width of the object, always unsigned integer
         */
        protected var _width:uint;
        /**
         * Height of the object, always unsigned integer
         */
        protected var _height:uint;
        /**
         * Graphics of the object
         */
        protected var _gfx:*;

        /****************************************************************************************************************/

        public function RetrocamelDisplayObject() {
            super();
        }

        public function draw():void {

        }


        // ::::::::::::::::::::::::::::::::::::::::::::::
        // :: Y Position
        // ::::::::::::::::::::::::::::::::::::::::::::::

        /**
         * X position of the object
         */
        public function get x():Number {
            return _x;
        }

        /**
         * @private
         */
        public function set x(value:Number):void {
            _x = value;
        }

        public function get center():Number {
            return _x + _width / 2;
        }

        public function set center(value:Number):void {
            _x = value - _width / 2;
        }

        public function get right():Number {
            return _x + _width - 1;
        }

        public function set right(value:Number):void {
            _x = value - _width + 1;
        }

        /**
         * Y position of the object
         */
        public function get y():Number {
            return _y;
        }


        // ::::::::::::::::::::::::::::::::::::::::::::::
        // :: Dimensions
        // ::::::::::::::::::::::::::::::::::::::::::::::

        /**
         * @private
         */
        public function set y(value:Number):void {
            _y = value;
        }

        public function get middle():Number {
            return _y + _height / 2;
        }

        public function set middle(value:Number):void {
            _y = value - _height / 2;
        }

        public function get bottom():Number {
            return _y + _height - 1;
        }


        // ::::::::::::::::::::::::::::::::::::::::::::::
        // :: Graphic
        // ::::::::::::::::::::::::::::::::::::::::::::::

        public function set bottom(value:Number):void {
            _y = value - _height + 1;
        }

        public function get width():uint {
            return _width;
        }

        /****************************************************************************************************************/
        /**                                                                                                  FUNCTIONS  */

        public function get height():Number {
            return _height;
        }

        /**
         * Retrieves the DisplayObject representing this object, if any is set
         */
        public function get gfx():* {
            return _gfx;
        }
    }
}