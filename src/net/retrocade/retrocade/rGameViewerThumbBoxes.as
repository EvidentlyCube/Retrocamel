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
 * User: Ryc
 * Date: 16.09.13
 * Time: 20:14
 * To change this template use File | Settings | File Templates.
 */
package net.retrocade.retrocade {
    import net.retrocade.retrocamel.display.global.RetrocamelTooltip;
    import flash.display.InteractiveObject;
    import flash.display.Shape;
    import flash.events.MouseEvent;
    import flash.filters.BevelFilter;
    import flash.geom.ColorTransform;
    import flash.net.URLRequest;
    import flash.net.navigateToURL;

    import net.retrocade.retrocamel.display.flash.RetrocamelSprite;

    public class rGameViewerThumbBoxes extends RetrocamelSprite{
        private static var _colorTransform:ColorTransform = new ColorTransform();

        private var _games:Vector.<rGameViewerGame>;
        private var _boxes:Vector.<InteractiveObject>;
        private var _boxEdge:Number;

        public function rGameViewerThumbBoxes(boxEdge:Number){
            _games = new Vector.<rGameViewerGame>();
            _boxes = new Vector.<InteractiveObject>();

            _boxEdge = boxEdge;
        }

        public function addGame(game:rGameViewerGame):void{
            _games.push(game);

            var thumbLoader:InteractiveObject = getGameBox(game.imageUrl);
            RetrocamelTooltip.hook(thumbLoader, game.header, true);

            addChild(thumbLoader);
            _boxes.push(thumbLoader);

            reorder();
        }

        public function getGameBox(imageUrl:String):RetrocamelSprite{
            var thumbLoader:rGameViewerThumbLoader = new rGameViewerThumbLoader();
            thumbLoader.loadImage(imageUrl);

            thumbLoader.x = 0;
            thumbLoader.y = 0;
            thumbLoader.width = _boxEdge;
            thumbLoader.height = _boxEdge;

            thumbLoader.filters = [ new BevelFilter(_boxEdge / 5, 45, 0xFFFFFF, 1, 0, 1, _boxEdge / 2, _boxEdge / 2, 0.1) ];

            var container:RetrocamelSprite = new RetrocamelSprite();

            container.buttonMode = true;
            container.addChild(thumbLoader);

            container.addEventListener(MouseEvent.CLICK, onBoxClicked);
            container.addEventListener(MouseEvent.ROLL_OVER, onBoxRollOver);
            container.addEventListener(MouseEvent.ROLL_OUT, onBoxRollOut);

            var blackOverlay:Shape = new Shape();
            blackOverlay.graphics.beginFill(0);
            blackOverlay.graphics.drawRect(0, 0, _boxEdge, _boxEdge);
            blackOverlay.graphics.drawRoundRect(2, 2, _boxEdge - 4, _boxEdge - 4, 5, 5);

            container.addChild(blackOverlay);

            var mask:Shape = new Shape();
            mask.graphics.beginFill(0);
            mask.graphics.drawRoundRect(0, 0, _boxEdge, _boxEdge, 5, 5);

            container.mask = mask;
            container.addChild(mask);

            return container;
        }

        private function reorder():void{
            var lastX:Number = 0;

            for each(var thumbLoader:InteractiveObject in _boxes){
                thumbLoader.x = lastX;

                lastX += thumbLoader.width + _boxEdge / 20;
            }
        }

        private function onBoxClicked(event:MouseEvent):void {
            var boxIndex:int = _boxes.indexOf(event.currentTarget as InteractiveObject);
            var gameUrl:String = _games[boxIndex].targetUrl;

            navigateToURL(new URLRequest(gameUrl), "_blank");
        }

        private function onBoxRollOver(event:MouseEvent):void{
            var box:* = event.target;

            _colorTransform.blueOffset = 50;
            _colorTransform.redOffset = 50;
            _colorTransform.greenOffset = 50;

            box.getChildAt(0).transform.colorTransform = _colorTransform;
        }

        private function onBoxRollOut(event:MouseEvent):void{
            var box:* = event.target;

            _colorTransform.blueOffset = 0;
            _colorTransform.redOffset = 0;
            _colorTransform.greenOffset = 0;

            box.getChildAt(0).transform.colorTransform = _colorTransform;
        }
    }
}
