/*
 * Copyright (C) 2013 Maurycy Zarzycki
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

/**
 * Created with IntelliJ IDEA.
 * User: mzarzycki
 * Date: 27.08.13
 * Time: 08:37
 * To change this template use File | Settings | File Templates.
 */
package net.retrocade.retrocade {

    import flash.display.Bitmap;
    import flash.display.Loader;
    import flash.events.Event;
    import flash.geom.Rectangle;
    import flash.net.URLRequest;

    import net.retrocade.utils.UtilsDisplay;

    public class rGameViewerThumbLoader extends Loader {
        private var _desiredWidth:Number;
        private var _desiredHeight:Number;

        private var _isImageLoaded:Boolean = false;

        private var _currentImageUrl:String;

        public function rGameViewerThumbLoader() {}

        public function loadImage(imageUrl:String):void{
            if (_isImageLoaded){
                unload();
                _isImageLoaded = false;
            }

            _currentImageUrl = imageUrl;

            contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
            load(new URLRequest(imageUrl));
        }

        private function onImageLoaded(e:Event):void{
            _isImageLoaded = true;

            if (content is Bitmap){
                Bitmap(content).smoothing = true;
            }

            resize();
        }

        private function resize():void{
            if (_isImageLoaded){
                var initialWidth:int = content.width;
                var initialHeight:int = content.height;

                $width = content.width;
                $height = content.height;

                UtilsDisplay.calculateScaleObject(content, _desiredWidth, _desiredHeight, UtilsDisplay.NO_BORDER);
                $width = $width * UtilsDisplay.lastScaleX;
                $height = $height * UtilsDisplay.lastScaleY;

                var enlargedWidth:Number = _desiredWidth / UtilsDisplay.lastScaleX;
                var enlargedHeight:Number = _desiredHeight / UtilsDisplay.lastScaleY;

                content.scrollRect = new Rectangle(
                        (content.width - enlargedWidth) / 2,
                        (content.height - enlargedHeight) / 2,
                        enlargedWidth,
                        enlargedHeight
                );
            }
        }

        protected function get $width():Number{
            return super.width;
        }

        protected function set $width(value:Number):void{
            super.width = value;
        }

        protected function get $height():Number{
            return super.height;
        }

        protected function set $height(value:Number):void{
            super.height = value;
        }

        override public function get width():Number {
            return _desiredWidth
        }

        override public function set width(value:Number):void {
            _desiredWidth = value;

            resize();
        }

        override public function get height():Number {
            return _desiredHeight
        }

        override public function set height(value:Number):void {
            _desiredHeight = value;

            resize();
        }
    }
}
