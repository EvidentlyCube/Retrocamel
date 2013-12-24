/*
 * Copyright (C) 2013 Maurycy Zarzycki
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

package net.retrocade.retrocade {
    import flash.events.MouseEvent;
    import flash.net.URLRequest;
    import flash.net.navigateToURL;
    import flash.utils.getTimer;

    import net.retrocade.retrocamel.core.RetrocamelBitmapManager;
    import net.retrocade.retrocamel.core.RetrocamelCore;
    import net.retrocade.retrocamel.core.RetrocamelDisplayManager;
    import net.retrocade.retrocamel.core.retrocamel_int;
    import net.retrocade.retrocamel.display.flash.RetrocamelBitmap;
    import net.retrocade.retrocamel.display.flash.RetrocamelSprite;
    import net.retrocade.utils.UtilsGraphic;
    import net.retrocade.retrocamel.display.flash.RetrocamelButton;

    use namespace retrocamel_int;

    public class RetrocadeBottomBar extends RetrocamelSprite {
        [Embed(source="/net/retrocade/assets/bottomBar/background.png")]
        private static var __gfx_bg__:Class;
        [Embed(source="/net/retrocade/assets/bottomBar/retrocade_logo.png")]
        private static var __gfx_retr_logo__:Class;
        [Embed(source="/net/retrocade/assets/bottomBar/retrocade_text.png")]
        private static var __gfx_retr_text__:Class;
        [Embed(source="/net/retrocade/assets/bottomBar/retrocade_text_pl.png")]
        private static var __gfx_retr_text_pl__:Class;
        [Embed(source="/net/retrocade/assets/bottomBar/help_icon.png")]
        private static var __gfx_help_icon__:Class;
        [Embed(source="/net/retrocade/assets/bottomBar/help_text.png")]
        private static var __gfx_help_text__:Class;
        [Embed(source="/net/retrocade/assets/bottomBar/help_text_pl.png")]
        private static var __gfx_help_text_pl__:Class;
        [Embed(source="/net/retrocade/assets/bottomBar/hide_icon.png")]
        private static var __gfx_hide_icon__:Class;
        [Embed(source="/net/retrocade/assets/bottomBar/hide_text.png")]
        private static var __gfx_hide_text__:Class;
        [Embed(source="/net/retrocade/assets/bottomBar/hide_text_pl.png")]
        private static var __gfx_hide_text_pl__:Class;
        [Embed(source="/net/retrocade/assets/bottomBar/hide_return.png")]
        private static var __gfx_hide_return__:Class;
        [Embed(source="/net/retrocade/assets/bottomBar/hide_return_pl.png")]
        private static var __gfx_hide_return_pl__:Class;
        private static var _self:RetrocadeBottomBar;
        //noinspection JSFieldCanBeLocal
        private static var _background:RetrocamelBitmap;
        private static var _buttonLogo:RetrocamelButton;
        private static var _buttonLogo_icon:RetrocamelBitmap;
        private static var _buttonLogo_text:RetrocamelBitmap;
        private static var _buttonLogo_isHovered:Boolean = false;
        private static var _buttonLogo_cycleTimer:uint = 0;
        private static var _buttonHelp:RetrocamelButton;
        private static var _buttonHelp_icon:RetrocamelBitmap;
        private static var _buttonHelp_text:RetrocamelBitmap;
        private static var _buttonHelp_isHovered:Boolean = false;
        private static var _buttonHelp_cycleTimer:uint = 0;
        private static var _walkthroughUrl:String;
        private static var _buttonHide:RetrocamelButton;
        private static var _buttonHide_icon:RetrocamelBitmap;
        private static var _buttonHide_text:RetrocamelBitmap;
        private static var _buttonHide_isHovered:Boolean = false;
        private static var _buttonHide_cycleTimer:uint = 0;
        private static var _overlay:RetrocamelSprite;
        //noinspection JSFieldCanBeLocal
        private static var _overlayText:RetrocamelBitmap;
        private static var _overlayClickTime:Number;
        private static var _overlayVisible:Boolean = false;
        private static var _homepageUrl:String = "http://portal.retrocade_old.net";

        public static function set homepageUrl(value:String):void {
            _homepageUrl = value;
        }

        public static function set walkthroughUrl(value:String):void {
            _walkthroughUrl = value;
        }

        public static function initBackground():void {
            if (_self) {
                return;
            }

            _self = new RetrocadeBottomBar();

            _background = RetrocamelBitmapManager.getB(__gfx_bg__);

            _self.addChild(_background);

            RetrocamelDisplayManager._bottomBar = _self;
            RetrocamelDisplayManager._flashApplication.addChild(_self);
        }

        public static function initAll(isPl:Boolean):void {
            initBackground();
            initLogo(isPl);
            initWalkthrough(isPl);
            initHide(isPl);
        }

        private static function initLogo(isPl:Boolean):void {
            _buttonLogo = new RetrocamelButton(onLogoClick, onLogoOver, onLogoOut);
            _buttonLogo_icon = RetrocamelBitmapManager.getB(__gfx_retr_logo__);
            _buttonLogo_text = RetrocamelBitmapManager.getB(isPl ? __gfx_retr_text_pl__ : __gfx_retr_text__);
            _buttonLogo_text.x = _buttonLogo_icon.width + 5;
            _buttonLogo_text.alignMiddleParent(0, _buttonLogo_icon.height);
            _buttonLogo.addChild(_buttonLogo_icon);
            _buttonLogo.addChild(_buttonLogo_text);
            _buttonLogo.x = 5;
            _buttonLogo.alignMiddleParent(0, 40);

            _buttonLogo.alpha = 0;

            _self.addChild(_buttonLogo);
        }

        private static function initHide(isPl:Boolean):void {
            _buttonHide = new RetrocamelButton(onHideClick, onHideOver, onHideOut);
            _buttonHide_icon = RetrocamelBitmapManager.getB(__gfx_hide_icon__);
            _buttonHide_text = RetrocamelBitmapManager.getB(isPl ? __gfx_hide_text_pl__ : __gfx_hide_text__);
            _buttonHide_text.right = _buttonHide_icon.width;
            _buttonHide_text.alignMiddleParent(3, _buttonHide_icon.height);
            _buttonHide.addChild(_buttonHide_icon);
            _buttonHide.addChild(_buttonHide_text);
            _buttonHide.right = RetrocamelCore.settings.swfWidth;

            _overlay = new RetrocamelSprite();
            UtilsGraphic.draw(_overlay).rectFill(0, 0, RetrocamelCore.settings.swfWidth, 40, 0, 0.85);
            _overlayText = RetrocamelBitmapManager.getB(isPl ? __gfx_hide_return_pl__ : __gfx_hide_return__);
            _overlayText.alignCenterParent(0, RetrocamelCore.settings.swfWidth);
            _overlayText.alignMiddleParent(0, 40);
            _overlay.addChild(_overlayText);
            _overlay.buttonMode = true;
            _overlay.addEventListener(MouseEvent.CLICK, onOverlayClick);

            _self.addChild(_buttonHide);
            _self.addChild(_overlay);

            _overlay.visible = false;
            _overlay.alpha = 0;

            _buttonHide.alpha = 0;
        }

        private static function initWalkthrough(isPl:Boolean):void {
            _buttonHelp = new RetrocamelButton(onHelpClick, onHelpOver, onHelpOut);
            _buttonHelp_icon = RetrocamelBitmapManager.getB(__gfx_help_icon__);
            _buttonHelp_text = RetrocamelBitmapManager.getB(isPl ? __gfx_help_text_pl__ : __gfx_help_text__);
            _buttonHelp_text.x = _buttonHelp_icon.width / 2;
            _buttonHelp_text.alignMiddleParent(3, _buttonHelp_icon.height);
            _buttonHelp.addChild(_buttonHelp_icon);
            _buttonHelp.addChild(_buttonHelp_text);
            _buttonHelp.x = _buttonLogo.right + 40;
            _buttonHelp.alignMiddleParent(0, 40);

            _self.addChild(_buttonHelp);

            _buttonHelp.alpha = 0;
        }

        private static function onLogoClick():void {
            navigateToURL(new URLRequest(_homepageUrl), '_blank');
        }

        private static function onLogoOver():void {
            _buttonLogo_isHovered = true;
        }

        private static function onLogoOut():void {
            _buttonLogo_isHovered = false;
        }

        private static function onHelpClick():void {
            navigateToURL(new URLRequest(_walkthroughUrl), '_blank');
        }

        private static function onHelpOver():void {
            _buttonHelp_isHovered = true;
        }

        private static function onHelpOut():void {
            _buttonHelp_isHovered = false;
        }

        private static function onHideClick():void {
            _overlayVisible = true;
        }

        private static function onHideOver():void {
            _buttonHide_isHovered = true;
        }

        private static function onHideOut():void {
            _buttonHide_isHovered = false;
        }

        public function RetrocadeBottomBar() {
            y = RetrocamelCore.settings.swfHeight - 40;
        }

        private static function onOverlayClick(e:MouseEvent):void {
            if (getTimer() - _overlayClickTime < 500) {
                _overlayVisible = false;
            }

            _overlayClickTime = getTimer();
        }

        retrocamel_int static function update():void {
            if (!_self) {
                return;
            }

            if (_buttonLogo) {
                if (_buttonLogo.alpha < 1) {
                    _buttonLogo.alpha += 0.0625;
                }

                if (_buttonLogo_isHovered || _buttonLogo_cycleTimer) {
                    _buttonLogo_cycleTimer = (_buttonLogo_cycleTimer + 4) % 180;

                    _buttonLogo_text.x = _buttonLogo_icon.width + 5 + Math.sin(_buttonLogo_cycleTimer * Math.PI / 180) * 15;
                }

            }

            if (_buttonHelp) {
                if (_buttonHelp.alpha < 1) {
                    _buttonHelp.alpha += 0.0625;
                }

                if (_buttonHelp_isHovered || _buttonHelp_cycleTimer) {
                    _buttonHelp_cycleTimer = (_buttonHelp_cycleTimer + 9) % 180;

                    _buttonHelp_text.x = _buttonHelp_icon.width / 2 + Math.sin(_buttonHelp_cycleTimer * Math.PI / 180) * 8;
                }
            }

            if (_buttonHide) {
                if (_buttonHide.alpha < 1) {
                    _buttonHide.alpha += 0.0625;
                }

                if (_buttonHide_isHovered || _buttonHide_cycleTimer) {
                    _buttonHide_cycleTimer = (_buttonHide_cycleTimer + 4) % 180;

                    _buttonHide_text.x = _buttonHide_icon.width / 2 - Math.sin(_buttonHide_cycleTimer * Math.PI / 180) * 5;
                }

                if (_overlayVisible == false) {
                    if (_overlay.alpha > 0) {
                        _overlay.alpha -= 0.0625;
                        _overlay.visible = (_overlay.alpha > 0);
                    }
                } else {
                    if (_overlay.alpha < 1) {
                        _overlay.alpha += 0.0625;
                        _overlay.visible = true;
                    }
                }
            }

            if (_self.alpha < 1) {
                _self.alpha += 0.0625;
            }
        }
    }
}