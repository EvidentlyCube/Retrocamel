/*
 * Copyright (C) 2013 Maurycy Zarzycki
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

package net.retrocade.data {
    import net.retrocade.retrocamel.core.retrocamel_int;

    use namespace retrocamel_int;

    public class RetrocamelTileGrid {
        private var _width:uint;
        private var _height:uint;
        private var _tileWidth:uint;
        private var _tileHeight:uint;
        private var _array:Array = [];

        public function RetrocamelTileGrid(width:uint, height:uint, tileWidth:uint, tileHeight:uint) {
            _width = width;
            _height = height;
            _tileWidth = tileWidth;
            _tileHeight = tileHeight;
        }

        public function init(width:uint, height:uint):void {
            _width = width;
            _height = height;

            _array = [];
        }

        public function clear():void {
            _array.splice(0);
        }

        public function getArray():Array {
            return _array;
        }

        public function set(x:Number, y:Number, item:*):void {
            x = x / _tileWidth | 0;
            y = y / _tileHeight | 0;

            if (x < 0 || y < 0 || x >= _width || y >= _height) {
                return;
            }

            _array[x + y * _width] = item;
        }

        public function get(x:Number, y:Number):* {
            x = x / _tileWidth | 0;
            y = y / _tileHeight | 0;

            if (x < 0 || y < 0 || x >= _width || y >= _height) {
                return null;
            }

            return _array[x + y * _width];
        }

        public function setTile(x:Number, y:Number, item:*):void {
            if (x < 0 || y < 0 || x >= _width || y >= _height) {
                return;
            }

            _array[x + y * _width] = item;
        }

        public function getTile(x:Number, y:Number):* {
            if (x < 0 || y < 0 || x >= _width || y >= _height) {
                return null;
            }

            return _array[x + y * _width];
        }
    }
}