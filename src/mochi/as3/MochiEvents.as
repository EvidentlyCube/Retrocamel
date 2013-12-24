/*
 * Copyright (C) 2013 Maurycy Zarzycki
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

package mochi.as3 {
    import flash.display.MovieClip;

    public class MochiEvents {
        public static const ACHIEVEMENTS_OWNED:String = "AchievementOwned";
        public static const ACHIEVEMENT_NEW:String = "AchievementReceived";
        public static const GAME_ACHIEVEMENTS:String = "GameAchievements";

        public static const ERROR:String = "Error";
        // error types
        public static const IO_ERROR:String = "IOError";
        public static const IO_PENDING:String = "IOPending";

        public static const ALIGN_TOP_LEFT:String = "ALIGN_TL";
        public static const ALIGN_TOP:String = "ALIGN_T";
        public static const ALIGN_TOP_RIGHT:String = "ALIGN_TR";
        public static const ALIGN_LEFT:String = "ALIGN_L";
        public static const ALIGN_CENTER:String = "ALIGN_C";
        public static const ALIGN_RIGHT:String = "ALIGN_R";
        public static const ALIGN_BOTTOM_LEFT:String = "ALIGN_BL";
        public static const ALIGN_BOTTOM:String = "ALIGN_B";
        public static const ALIGN_BOTTOM_RIGHT:String = "ALIGN_BR";

        public static const FORMAT_SHORT:String = "ShortForm";
        public static const FORMAT_LONG:String = "LongForm";
        public static const FORMAT_NONE:String = "NoForm";

        private static var gameStart:Number;
        private static var levelStart:Number;

        private static var _dispatcher:MochiEventDispatcher = new MochiEventDispatcher();

        public static function getVersion():String {
            return MochiServices.getVersion();
        }

        /**
         * Method: getAchievements
         * Calls GAME_ACHIEVEMENTS event, passing an object with all achievements in system
         */
        public static function getAchievements(properties:Object = null):void
        {
            MochiServices.send("events_getAchievements", properties);
        }

        public static function unlockAchievement(properties:Object):void
        {
            MochiServices.send("events_unlockAchievement", properties);
        }

        // --- Basic Event Tracking -----
        public static function startSession( achievementID:String ):void
        {
            // TODO: THIS SHOULD BE CALLED FROM CONNECT!
            MochiServices.send("events_beginSession", { achievementID: achievementID }, null, null );
        }

        // --- UI Notification system ---
        public static function showAwards(options:Object = null):void
        {
            MochiServices.setContainer();
            MochiServices.stayOnTop();
            MochiServices.send("events_showAwards", options );
        }

        public static function setNotifications( style:Object ):void
        {
            MochiServices.setContainer();
            MochiServices.bringToTop();
            MochiServices.send("events_setNotifications", style, null, null );
        }

        // --- Callback system ----------
        public static function addEventListener( eventType:String, delegate:Function ):void
        {
            _dispatcher.addEventListener( eventType, delegate );
        }

        public static function triggerEvent( eventType:String, args:Object ):void
        {
            _dispatcher.triggerEvent( eventType, args );
        }

        public static function removeEventListener( eventType:String, delegate:Function ):void
        {
            _dispatcher.removeEventListener( eventType, delegate );
        }

        // --- Tracking events ----------

        public static function startPlay( tag:String = 'gameplay' ):void {
            MochiServices.send("events_setRoundID", { tag:String(tag) }, null, null );
        }

        public static function endPlay():void {
            MochiServices.send("events_clearRoundID", null, null, null );
        }

        public static function trackEvent( tag:String, value:* = null ):void {
            MochiServices.send("events_trackEvent", { tag: tag, value:value }, null, null );
        }
    }
}
