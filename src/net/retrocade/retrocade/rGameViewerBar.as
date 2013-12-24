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
 * Time: 08:30
 * To change this template use File | Settings | File Templates.
 */
package net.retrocade.retrocade {
    import flash.display.Shape;
    import flash.filters.DropShadowFilter;
    import flash.filters.GlowFilter;
    import flash.net.URLRequest;
    import flash.net.navigateToURL;

    import net.retrocade.retrocamel.display.flash.RetrocamelSprite;
    import net.retrocade.retrocamel.display.flash.RetrocamelButton;
    import net.retrocade.retrocamel.display.flash.RetrocamelTextField;
    import net.retrocade.utils.UtilsGraphic;

    public class rGameViewerBar extends RetrocamelSprite {
        private var _thumbWidth:int = 60;
        private var _thumbHeight:int = 60;
        private var _font:String = "font";
        private var _isEmbedFont:Boolean = true
        private var _textColor:int = 0xFFFFFF
        private var _componentWidth:int = 600;
        private var _thumb:rGameViewerThumbLoader;
        private var _headerText:RetrocamelTextField;
        private var _bodyText:RetrocamelTextField;
        private var _arrowPrev:RetrocamelButton;
        private var _arrowNext:RetrocamelButton;
        private var _clickArea:RetrocamelButton;
        private var _currentGameIndex:int = 0;
        private var _games:Vector.<rGameViewerGame>;
        private var _componentHeight:Number = 60;

        public function rGameViewerBar() {
            _games = new Vector.<rGameViewerGame>();

            _thumb = new rGameViewerThumbLoader();
            _headerText = new RetrocamelTextField();
            _bodyText = new RetrocamelTextField();
            _arrowNext = new RetrocamelButton(onArrowClicked, onArrowRollOver, onArrowRollOut);
            _arrowPrev = new RetrocamelButton(onArrowClicked, onArrowRollOver, onArrowRollOut);
            _clickArea = new RetrocamelButton(onBodyClicked, onBodyOver, onBodyOut);

            _arrowNext.addChild(getArrowNextShape());
            _arrowPrev.addChild(getArrowPrevShape());
            UtilsGraphic.draw(_clickArea).beginFill(0, 0).drawRect(0, 0, 100, 100);

            _headerText.autoSizeNone();
            _bodyText.autoSizeNone();

            _headerText.wordWrap = true;
            _bodyText.wordWrap = true;

            addChild(_thumb);
            addChild(_headerText);
            addChild(_bodyText);
            addChild(_arrowNext);
            addChild(_arrowPrev);
            addChild(_clickArea);

            font = "font";
            isEmbedFont = true;
            textColor = 0xFFFFFF;
            headerFontSize = 16;
            paragraphFontSize = 12;
            width = 600;
        }

        public function addGame(game:rGameViewerGame):void {
            _games.push(game);

            if (_games.length == 1) {
                showGame(0);
            }
        }

        public function setShadow(distance:Number = 1, alpha:Number = 1, blur:Number = 1, strength:Number = 1):void{
            var filter:Array = [];

            if (!isNaN(distance)){
                filter[0] = new DropShadowFilter(distance, 45, 0, alpha, blur, blur, strength);
            }

            _headerText.filters = filter;
            _bodyText.filters = filter;
        }

        public function showGame(index:uint):void {
            if (_games.length > index) {
                _currentGameIndex = index;

                var game:rGameViewerGame = _games[index];

                _thumb.loadImage(game.imageUrl);
                _headerText.text = game.header;
                _bodyText.text = game.paragraphText;

                relayout();
            }
        }

        private function onArrowClicked(button:RetrocamelButton):void {
            if (button == _arrowNext) {
                _currentGameIndex = (_currentGameIndex + 1) % _games.length;
            } else {
                _currentGameIndex = (_currentGameIndex - 1 + _games.length) % _games.length;
            }

            showGame(_currentGameIndex);
        }

        private function onArrowRollOver(button:RetrocamelButton):void {
            button.alpha = 0.5;
        }

        private function onArrowRollOut(button:RetrocamelButton):void {
            button.alpha = 1;
        }

        private function onBodyClicked():void {
            navigateToURL(new URLRequest(_games[_currentGameIndex].targetUrl), "_blank");
        }

        private function onBodyOver():void {
            filters = [ new GlowFilter(0xFFFFFF, 1, 6, 6, 0.6)];
        }

        private function onBodyOut():void {
            filters = [];
        }

        private function getArrowNextShape():Shape {
            var shape:Shape = new Shape();
            UtilsGraphic.draw(shape).beginFill(0xFFFFFF).moveTo(0, 0).lineTo(12, 12).lineTo(0, 24);

            return shape;
        }

        private function getArrowPrevShape():Shape {
            var shape:Shape = new Shape();
            UtilsGraphic.draw(shape).beginFill(0xFFFFFF).moveTo(12, 0).lineTo(0, 12).lineTo(12, 24);

            return shape;
        }

        private function relayout():void {
            const ARROW_WIDTH:int = 16;
            const PADDING:int = 5;
            const ARROW_OFFSET:int = ARROW_WIDTH + PADDING;
            const INTER_WIDTH:Number = _componentWidth - ARROW_OFFSET * 2;
            const TEXT_WIDTH:Number = INTER_WIDTH - _thumbWidth - PADDING;

            _arrowNext.right = _componentWidth;
            _arrowPrev.x = 0;

            _arrowNext.alignMiddleParent(0, _componentHeight);
            _arrowPrev.alignMiddleParent(0, _componentHeight);

            _thumb.x = ARROW_OFFSET;
            _headerText.x = ARROW_OFFSET + _thumbWidth + PADDING;
            _bodyText.x = ARROW_OFFSET + _thumbWidth + PADDING;
            _headerText.width = TEXT_WIDTH;
            _bodyText.width = TEXT_WIDTH;

            _thumb.y = (_componentHeight - _thumbHeight) / 2 | 0;
            _headerText.height = _headerText.textHeight + 4;
            _headerText.y = -2;
            _bodyText.y = _headerText.bottom + PADDING;
            _bodyText.height = _componentHeight + 4 - _headerText.height;

            _clickArea.width = INTER_WIDTH;
            _clickArea.height = _componentHeight;
            _clickArea.x = ARROW_OFFSET;
        }

        override public function get width():Number {
            return _componentWidth;
        }

        override public function set width(value:Number):void {
            _componentWidth = value;
            relayout();
        }

        override public function get height():Number {
            return _componentHeight;
        }

        override public function set height(value:Number):void {
            _componentHeight = value;

            if (thumbHeight > value){
                thumbHeight = value;
            }

            relayout();
        }

        public function get headerFontSize():int {
            return _headerText.size;
        }

        public function set headerFontSize(value:int):void {
            _headerText.size = value;

            relayout();
        }

        public function get paragraphFontSize():int {
            return _bodyText.size;
        }

        public function set paragraphFontSize(value:int):void {
            _bodyText.size = value;

            relayout();
        }

        public function get font():String {
            return _font;
        }

        public function set font(value:String):void {
            _font = value;
            _headerText.font = value;
            _bodyText.font = value;

            relayout();
        }

        public function get isEmbedFont():Boolean {
            return _isEmbedFont;
        }

        public function set isEmbedFont(value:Boolean):void {
            _isEmbedFont = value;
            _headerText.embedFonts = value;
            _bodyText.embedFonts = value;

            relayout();
        }

        public function get textColor():int {
            return _textColor;
        }

        public function set textColor(value:int):void {
            _textColor = value;
            _headerText.color;
            _bodyText.color;
        }

        public function get thumbWidth():int {
            return _thumbWidth;
        }

        public function set thumbWidth(value:int):void {
            _thumbWidth = value;
            _thumb.width = value;

            relayout();
        }

        public function get thumbHeight():int {
            return _thumbHeight;
        }

        public function set thumbHeight(value:int):void {
            _thumbHeight = value;
            _thumb.height = value;

            if (_componentHeight < value) {
                _componentHeight = value;
            }

            relayout();
        }
    }
}
