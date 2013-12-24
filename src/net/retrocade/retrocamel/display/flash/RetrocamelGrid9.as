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
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import net.retrocade.retrocamel.display.flash.RetrocamelSprite;

    /**
     * ...
     * @author Maurycy Zarzycki
     */
    public class RetrocamelGrid9 extends RetrocamelSprite{
        /****************************************************************************************************************/
        /**                                                                                           STATIC FUNCTIONS  */
        /****************************************************************************************************************/

        private static var _gridLibrary:Array = [];

        public static function make(name:String, bitmapData:BitmapData, x:uint, y:uint, width:uint, height:uint):void{
            var g:RetrocamelGrid9     = new RetrocamelGrid9();
            var r:Rectangle = new Rectangle();
            var p:Point     = new Point();

            g._widthLeft    = x;
            g._widthRight   = bitmapData.width - width - x;
            g._heightTop    = y;
            g._heightBottom = bitmapData.height - height - y;
            g._minWidth     = g._widthLeft + g._widthRight;
            g._minHeight    = g._heightTop + g._heightBottom;

            r.x         = 0;
            r.y         = 0;
            r.width     = x;
            r.height    = y;
            g._topLeftBD = new BitmapData(x, y, true, 0);
            g._topLeftBD.copyPixels(bitmapData, r, p, null, null,true);

            r.x         = x;
            r.y         = 0;
            r.width     = width;
            r.height    = y;
            g._topBD     = new BitmapData(width, y, true, 0);
            g._topBD.copyPixels(bitmapData, r, p, null, null,true);

            r.x          = x + width;
            r.y          = 0;
            r.width      = g._widthRight;
            r.height     = y;
            g._topRightBD = new BitmapData(g._widthRight, y, true, 0);
            g._topRightBD.copyPixels(bitmapData, r, p, null, null,true);

            r.x      = 0;
            r.y      = y;
            r.width  = x;
            r.height = height;
            g._leftBD = new BitmapData(x, height, true, 0);
            g._leftBD.copyPixels(bitmapData, r, p, null, null,true);

            r.x       = x;
            r.y       = y;
            r.width   = width;
            r.height  = height;
            g._midBD = new BitmapData(width, height, true, 0);
            g._midBD.copyPixels(bitmapData, r, p, null, null,true);


            r.x       = x + width;
            r.y       = y;
            r.width   = g._widthRight;
            r.height  = height;
            g._rightBD = new BitmapData(g._widthRight, height, true, 0);
            g._rightBD.copyPixels(bitmapData, r, p, null, null,true);

            r.x            = 0;
            r.y            = y + height;
            r.width        = x;
            r.height       = g._heightBottom;
            g._bottomLeftBD = new BitmapData(x, g._heightBottom, true, 0);
            g._bottomLeftBD.copyPixels(bitmapData, r, p, null, null,true);

            r.x        = x;
            r.y        = y + height;
            r.width    = width;
            r.height   = g._heightBottom;
            g._bottomBD = new BitmapData(width, g._heightBottom, true, 0);
            g._bottomBD.copyPixels(bitmapData, r, p, null, null,true);

            r.x             = x + width;
            r.y             = y + height;
            r.width         = g._widthRight;
            r.height        = g._heightBottom;
            g._bottomRightBD = new BitmapData(g._widthRight, g._heightBottom, true, 0);
            g._bottomRightBD.copyPixels(bitmapData, r, p, null, null,true);

            _gridLibrary[name] = g;
        }

        public static function getGrid(name:String, dontScale:Boolean = false):RetrocamelGrid9{
            var g:RetrocamelGrid9 = new RetrocamelGrid9(dontScale);
            var c:RetrocamelGrid9 = _gridLibrary[name];

            g._topLeftBD     = c._topLeftBD;
            g._topBD         = c._topBD;
            g._topRightBD    = c._topRightBD;
            g._leftBD        = c._leftBD;
            g._midBD         = c._midBD;
            g._rightBD       = c._rightBD;
            g._bottomLeftBD  = c._bottomLeftBD;
            g._bottomBD      = c._bottomBD;
            g._bottomRightBD = c._bottomRightBD;

            g._widthLeft     = c._widthLeft;
            g._widthRight    = c._widthRight;
            g._heightTop     = c._heightTop;
            g._heightBottom  = c._heightBottom;
            g._minWidth      = c._minWidth;
            g._minHeight     = c._minHeight;

            if (!dontScale){
                g._topLeft       = new Bitmap(g._topLeftBD);
                g._top           = new Bitmap(g._topBD);
                g._topRight      = new Bitmap(g._topRightBD);
                g._left          = new Bitmap(g._leftBD);
                g._mid           = new Bitmap(g._midBD);
                g._right         = new Bitmap(g._rightBD);
                g._bottomLeft    = new Bitmap(g._bottomLeftBD);
                g._bottom        = new Bitmap(g._bottomBD);
                g._bottomRight   = new Bitmap(g._bottomRightBD);

                g.addChild(g._topLeft);
                g.addChild(g._top);
                g.addChild(g._topRight);
                g.addChild(g._left);
                g.addChild(g._mid);
                g.addChild(g._right);
                g.addChild(g._bottomLeft);
                g.addChild(g._bottom);
                g.addChild(g._bottomRight);

                g._top       .x = g._widthLeft;
                g._bottom    .x = g._widthLeft;
                g._left      .y = g._heightTop;
                g._right     .y = g._heightTop;
                g._mid       .x = g._widthLeft;
                g._mid       .y = g._heightTop;
            }

            g.width  = g._minWidth;
            g.height = g._minHeight;

            return g;
        }




        /****************************************************************************************************************/
        /**                                                                                                   VARIABLES */
        /****************************************************************************************************************/

        // ::::::::::::::::::::::::::::::::::::::::::::::
        // :: Unchangeable variables
        // ::::::::::::::::::::::::::::::::::::::::::::::

        private var _topLeftBD    :BitmapData;
        private var _topBD        :BitmapData;
        private var _topRightBD   :BitmapData;
        private var _leftBD       :BitmapData;
        private var _midBD        :BitmapData;
        private var _rightBD      :BitmapData;
        private var _bottomLeftBD :BitmapData;
        private var _bottomBD     :BitmapData;
        private var _bottomRightBD:BitmapData;

        private var _topLeft    :Bitmap;
        private var _top        :Bitmap;
        private var _topRight   :Bitmap;
        private var _left       :Bitmap;
        private var _mid        :Bitmap;
        private var _right      :Bitmap;
        private var _bottomLeft :Bitmap;
        private var _bottom     :Bitmap;
        private var _bottomRight:Bitmap;

        public function get widthLeft():uint {
            return _widthLeft;
        }

        public function get widthRight():uint {
            return _widthRight;
        }

        public function get heightTop():uint {
            return _heightTop;
        }

        public function get heightBottom():uint {
            return _heightBottom;
        }

        private var _widthLeft   :uint;
        private var _widthRight  :uint;
        private var _heightTop   :uint;
        private var _heightBottom:uint;

        private var _minWidth    :uint;
        private var _minHeight   :uint;

        private var _dontScale   :Boolean;
        private var _matrix      :Matrix;



        // ::::::::::::::::::::::::::::::::::::::::::::::
        // :: Inner Dimensions and Positions
        // ::::::::::::::::::::::::::::::::::::::::::::::

        /**
         * Accesses the height of the inner part of the grid
         */
        public function get innerWidth():Number{
            return width - _minWidth;
        }

        /**
         * @private
         */
        public function set innerWidth(value:Number):void{
            width = value + _minWidth;
        }

        /**
         * Accesses the height of the inner part of the grid
         */
        public function get innerHeight():Number{
            return height - _minHeight;
        }

        /**
         * @private
         */
        public function set innerHeight(value:Number):void{
            height = value + _minHeight;
        }

        /**
         * Accesses the X position of the inner part of the grid
         */
        public function get innerX():Number{
            return x + _widthLeft;
        }

        /**
         * @private
         */
        public function set innerX(value:Number):void{
            x = value - _widthLeft;
        }

        /**
         * Accesses the Y position of the inner part of the grid
         */
        public function get innerY():Number{
            return y + _heightTop;
        }

        /**
         * @private
         */
        public function set innerY(value:Number):void{
            y = value - _heightTop;
        }




        /****************************************************************************************************************/
        /**                                                                                                   OVERRIDES */
        /****************************************************************************************************************/

        override public function set width(value:Number):void{
            value |= 0;

            if (value < _minWidth)
                value = _minWidth;

            if (_dontScale){
                redraw(value, height);

            } else {
                _bottom.width = _mid.width = _top.width = value - _minWidth | 0;

                _topRight.x = _right.x = _bottomRight.x = value - _widthRight | 0;
            }
        }

        override public function set height(value:Number):void{
            value |= 0;

            if (value < _minHeight)
                value = _minHeight;

            if (_dontScale){
                redraw(width, value);

            } else {
                _left.height = _mid.height = _right.height = value - _minHeight | 0;

                _bottomLeft.y = _bottom.y = _bottomRight.y = value - _heightBottom | 0;
            }
        }

        override public function set x(value:Number):void{
            super.x = value | 0;
        }

        override public function set y(value:Number):void{
            super.y = value | 0;
        }

        public function RetrocamelGrid9(dontScale:Boolean = false):void{
            _dontScale = dontScale;
            _matrix = new Matrix();
        }

        private function redraw(newWidth:uint, newHeight:uint):void{
            graphics.clear();

            // Draw Top Left
            _matrix.tx = _matrix.ty = 0;
            graphics.beginBitmapFill(_topLeftBD, _matrix);
            graphics.drawRect(0, 0, _topLeftBD.width, _topLeftBD.height);

            // Draw Top
            _matrix.tx = _widthLeft;
            _matrix.ty = 0;
            graphics.beginBitmapFill(_topBD, _matrix);
            graphics.drawRect(_widthLeft, 0, newWidth - _widthLeft - _widthRight, _topBD.height);

            // Draw Top Right
            _matrix.tx = newWidth - _widthRight;
            _matrix.ty = 0;
            graphics.beginBitmapFill(_topRightBD, _matrix);
            graphics.drawRect(newWidth - _widthRight, 0, _widthRight, _topRightBD.height);

            // Draw Left
            _matrix.tx = 0;
            _matrix.ty = _heightTop;
            graphics.beginBitmapFill(_leftBD, _matrix);
            graphics.drawRect(0, _heightTop, _leftBD.width, newHeight - _heightTop - _heightBottom);

            // Draw Bottom Left
            _matrix.tx = 0;
            _matrix.ty = newHeight - _heightBottom;
            graphics.beginBitmapFill(_bottomLeftBD, _matrix);
            graphics.drawRect(0, newHeight - _heightBottom, _bottomLeftBD.width, _heightBottom);

            // Draw Right
            _matrix.tx = newWidth - _widthRight;
            _matrix.ty = _heightTop;
            graphics.beginBitmapFill(_rightBD, _matrix);
            graphics.drawRect(newWidth - _widthRight,
                              _heightTop,
                              _rightBD.width,
                              newHeight - _heightTop - _heightBottom);

            // Draw Bottom
            _matrix.tx = _widthLeft;
            _matrix.ty = newHeight - _heightBottom;
            graphics.beginBitmapFill(_bottomBD, _matrix);
            graphics.drawRect(_widthLeft,
                              newHeight - _heightBottom,
                              newWidth - _widthLeft - _widthRight,
                              _bottomBD.height);

            // Draw Bottom Right
            _matrix.tx = newWidth - _widthRight;
            _matrix.ty = newHeight - _heightBottom;
            graphics.beginBitmapFill(_bottomRightBD, _matrix);
            graphics.drawRect(newWidth - _widthRight,
                              newHeight - _heightBottom,
                              _bottomRightBD.width,
                              _bottomRightBD.height);

            // Draw Center
            _matrix.tx = _widthLeft;
            _matrix.ty = _heightTop;
            graphics.beginBitmapFill(_midBD, _matrix);
            graphics.drawRect(_widthLeft,
                              _heightTop,
                              newWidth - _widthLeft - _widthRight,
                              newHeight - _heightTop - _heightBottom);
        }
    }
}