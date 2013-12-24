/*
 * Copyright (C) 2013 Maurycy Zarzycki
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

package net.retrocade.retrocamel.display.layers{
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.Graphics;
    import flash.display.Sprite;
    
    /**
     * A Layer which consists of Sprite object, classical display list
     */
    public class RetrocamelLayerFlashSprite extends RetrocamelLayerFlash{

        /**
         * The Sprite which makes this layer
         */
        private var _layer:Sprite;

        /**
         * Returns the display object of this layer
         */
        override public function get layer():DisplayObject{
            return _layer;
        }

        /**
         * Creates a new Sprite Layer and attaches it to the top of the Display tree
         */
        public function RetrocamelLayerFlashSprite(addAt:Number = -1){
            _layer = new Sprite;
            
            addLayer(addAt);
        }

        /**
         * Adds a DisplayObject to this layer
         * @param d DisplayObject to be added
         */
        public function add(d:DisplayObject):void{
            _layer.addChild(d);
        }

        public function get graphics():Graphics{
            return _layer.graphics;
        }

        /**
         * Adds an rObjectDisplay to this layer
         * @param d rObjectDisplay to be added
         * @param index index at which to add
         */
        public function addAt(d:DisplayObject, index:uint):void{
            _layer.addChildAt(d, index);
        }
        
        /**
         * Removes all children from this layer
         */
        override public function clear():void{
            var i:uint = _layer.numChildren;
            
            while(i--){
                _layer.removeChildAt(i);
            }

            _layer.graphics.clear();
        }

        /**
         * Sets the layer alpha
         */
        public function set alpha(value:Number):void{
            _layer.alpha = value;
        }

        /**
        * Checks if given DisplayObject is added to this layer
        * @param d The DisplayObject to be checked
        * @return True if this layer contains d
        */
        public function contains(d:DisplayObject):Boolean{
            return _layer.contains(d);
        }

        /**
         * Removes an DisplayObject from this layer
         * @param d The DisplayObject to be removed
         */
        public function remove(d:DisplayObject):void{
            _layer.removeChild(d);
        }

        override public function set inputEnabled(value:Boolean):void {
            _layer.mouseChildren = _layer.mouseEnabled = value;
        }

        override public function get inputEnabled():Boolean {
            return _layer.mouseChildren;
        }

        public function set mouseChildren(value:Boolean):void{
            _layer.mouseChildren = value;
        }
    }
}