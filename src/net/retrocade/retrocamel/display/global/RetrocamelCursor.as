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
 * Date: 02.07.13
 * Time: 20:25
 * To change this template use File | Settings | File Templates.
 */
package net.retrocade.retrocamel.display.global {

    import flash.ui.Mouse;

    import net.retrocade.retrocamel.core.RetrocamelInputManager;

    import net.retrocade.retrocamel.core.retrocamel_int;
    import net.retrocade.retrocamel.core.RetrocamelStarlingCore;

    import starling.display.Image;
    import starling.textures.Texture;

    use namespace retrocamel_int;

    public class RetrocamelCursor {
        private static var _isStartlingCursorEnabled:Boolean = false;
        private static var _cursorStarling:Image;
        private static var _cursorStarlingTexture:Texture;
        private static var _cursorOffsetX:int;
        private static var _cursorOffsetY:int;
        private static var _isMouseHidden:Boolean = false;

        public static function get isMouseHidden():Boolean {
            return _isMouseHidden;
        }

        public static function set isMouseHidden(value:Boolean):void {
            if (value != _isMouseHidden) {
                if (value) {
                    Mouse.hide();
                } else {
                    Mouse.show();
                }

                _isMouseHidden = value;
            }
        }

        public static function setCursorTexture(texture:Texture, offsetX:int, offsetY:int):void {
            _cursorOffsetX = offsetX;
            _cursorOffsetY = offsetY;

            if (_isStartlingCursorEnabled) {
                setStarlingCursor(texture);
            }
        }

        public static function update():void {
            isMouseHidden = (_cursorStarling != null);

            if (_cursorStarling) {
                _cursorStarling.moveToFront();

                _cursorStarling.x = RetrocamelInputManager.mouseX + _cursorOffsetX;
                _cursorStarling.y = RetrocamelInputManager.mouseY + _cursorOffsetY;
            }
        }

        private static function setStarlingCursor(texture:Texture):void {
            if (_cursorStarlingTexture == texture) {
                return;
            }

            if (_cursorStarling) {
                _cursorStarlingTexture.dispose();
                _cursorStarlingTexture = null;

                if (!texture) {
                    RetrocamelStarlingCore.starlingRoot.removeChild(_cursorStarling);

                    _cursorStarling.dispose();
                    _cursorStarling = null;
                    return;
                }
            }

            if (texture) {
                _cursorStarlingTexture = texture;

                if (!_cursorStarling) {
                    _cursorStarling = new Image(_cursorStarlingTexture);
                    _cursorStarling.touchable = false;
                    RetrocamelStarlingCore.starlingRoot.addChild(_cursorStarling);
                } else {
                    _cursorStarling.texture = _cursorStarlingTexture;
                    _cursorStarling.readjustSize();
                }
            }
        }

        retrocamel_int static function initializeStarling():void {
            _isStartlingCursorEnabled = true;
        }
    }
}
