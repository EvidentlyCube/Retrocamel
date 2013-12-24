/*
 * Copyright (C) 2013 Maurycy Zarzycki
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

package net.retrocade.retrocamel.global{

    import com.fgl.FGLAds;

    import net.retrocade.retrocamel.core.*;

    import com.newgrounds.*;
    import com.newgrounds.components.FlashAd;
    import com.newgrounds.components.ScoreBrowser;
    
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.Loader;
    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.net.LocalConnection;
    import flash.net.URLRequest;
    import flash.system.Security;
    
    import mochi.as3.MochiAd;
    import mochi.as3.MochiScores;
    import mochi.as3.MochiServices;

    import net.retrocade.retrocamel.core.RetrocamelCore;

    import net.retrocade.retrocamel.display.flash.RetrocamelButton;
    import net.retrocade.utils.UtilsString;
    
    use namespace retrocamel_int;
    
    /**
     * ...
     * @author Maurycy Zarzycki
     */
    public class RetrocamelThirdPartyApi {
        
        public static const API_NONE :uint = 0;
        public static const API_MOCHI:uint = 1;
        public static const API_NG   :uint = 2;
        public static const API_KONG :uint = 3;

        public static const AD_NONE :uint = 0;
        public static const AD_MOCHI:uint = 1;
        public static const AD_NG   :uint = 2;
        public static const AD_FGL   :uint = 3;

        public static const SIZE_AD_WIDTH:uint = 300;
        public static const SIZE_AD_HEIGHT:uint = 250;
        
        
        private static var _root:MovieClip;
        
        private static var _adType :uint = AD_NONE;
        private static var _apiType:uint = API_NONE;
        
        private static var _connectionFailed:Boolean = false;
        
        public static var domain:String;
        
        public static var canCheat:Boolean = false;
        
        public static var defaultApi:uint = API_NG;
        public static var defaultAds:uint = AD_NG;
        
        public static function get isMochiLiveUpdates():Boolean{
            return (_root.stage.getChildAt(0) != _root);
        }
        
        public static function get canSubmitScores():Boolean{
            return !_connectionFailed && (_apiType == API_NG || _apiType == API_MOCHI);
        }
        
        public static function get canViewScores():Boolean{
            return !_connectionFailed && (_apiType == API_NG || _apiType == API_MOCHI);
        }
        
        public static function get isApiKong():Boolean{
            return _apiType == API_KONG;
        }
        
        public static function get isApiMochi():Boolean{
            return _apiType == API_MOCHI;
        }

        public static function get isAdsFGL():Boolean{
            return _adType === AD_FGL;
        }
        
        public static function get isApiNG():Boolean{
            return _apiType == API_NG;
        }
        
        public static function get isAdsMochi():Boolean{
            return _adType == AD_MOCHI;
        }
        
        public static function get isAdsNG():Boolean{
            return _adType == AD_NG;
        }
        
        /**
         * Initializes the Api's metadata
         */ 
        public static function init(root:MovieClip, emulateDomain:String = ""):void {
            _root = root;

            var _lc:LocalConnection = new LocalConnection();

            domain = _lc.domain;

            if (emulateDomain && domain.indexOf("localhost") !== -1) {
                domain = emulateDomain;
            }

            else {
                var domain2:String = root.stage.loaderInfo.url;

                if (!UtilsString.beginsWith(domain2, "file:")) {
                    domain2 = domain2.replace(/(https?|ftp|file):\/\/(www\.)?/i, "");
                    domain2 = domain2.replace(/(.+?)(\/|\\|\?|#).+/i, "$1");

                    domain = domain2;
                }
            }

            _adType = defaultAds;
            _apiType = defaultApi;

            // Check where we are and set permissions:
            domain = domain.toLowerCase();

            if (domain.indexOf("kongregate") !== -1) {
                _adType = AD_NONE;
                _apiType = API_KONG;

            } else if (domain.indexOf("mochi") !== -1) {
                _adType = AD_MOCHI;
                _apiType = API_MOCHI;

            } else if (domain.indexOf("newgrounds") !== -1 || domain.indexOf("ungrounded") !== -1) {
                _adType = AD_NG;
                _apiType = API_NG;

            } else if (domain.indexOf("flashgamelicense") !== -1 || domain.indexOf("flashgamedistribution") !== -1) {
                _adType = AD_FGL;
            }
        }
        
        /**
         * Connects the necessary APIs
         */
        public static function connectServices():void {
            if (isAdsMochi || isApiMochi) {
                connect_Mochi();
            }
            
            if (isAdsNG || isApiNG) {
                connect_NG();
            }
            
            if (isApiKong) {
                connect_Kong();
            }

            if (isAdsFGL){
                connect_FGL();
            }
        }
         
        /**
         * Checks if the services are ready
         * @return true if the services are ready and the connection was not failed
         */
        public static function isServiceReady():Boolean {
            var ready:Boolean = true;
            
            if (_apiType == API_KONG && !isReady_Kong()){
                ready = false;
            }
            
            if ((_adType == AD_NG || _apiType == API_NG) && !isReady_NG()){
                ready = false;
            }
            
            if ((_adType == AD_MOCHI || _apiType == API_MOCHI) && !isReady_Mochi()){
                ready = false;
            }

            if (isAdsFGL && !isReady_FGL()){
                ready = false;
            }
            
            return ready || _connectionFailed;
        }
        
        public static function showPreloaderAp(callback:Function):void{
            if (_connectionFailed){
                callback();
                return;
            }

            if (!callback){
                callback = function():void{};
            }
            
            if (_adType == AD_MOCHI){
                showPreloaderAp_Mochi(callback);
            } else if (_adType == AD_FGL){
                showPreloaderAd_FGL(callback);
            } else {
                callback();
            }
        }
        
        /**
         * Adds a static ad to the given display object 
         * @param addTo The display object to which the ad should be added
         * @return The added display object or null
         */
        public static function addAd(addTo:DisplayObjectContainer):DisplayObject {
            if (_connectionFailed)
                return null;
            
            switch(_adType) {
                case(AD_NG):
                    return addAd_NG(addTo);
                
                case(AD_MOCHI):
                    return addAd_Mochi(addTo);
            }
            
            return null;
        }
        
        public static function showScores(board:String, callback:Function):void{
            if (_connectionFailed){
                callback();
                return;
            }
            
            switch(_apiType){
                case(API_NG):
                    showScores_NG(board, callback);
                    return;
                    
                case(API_MOCHI):
                    showScores_Mochi(board, callback);
                    return;
            }
        }
        
        /**
         * Submits a score 
         * @param value Score value
         * @param board Boad ID, leave null
         * @param callback Function to be called after score is submitted and window closed
         * 
         */
        public static function sendScore(value:Number, board:String, callback:Function):void{
            if (_connectionFailed){
                callback();
                return;
            }
            
            switch(_apiType){
                case(API_NG):
                    sendScore_NG(value, board, callback);
                    return;
                    
                case(API_MOCHI):
                    sendScore_Mochi(value, board, callback);
                    return;
            }
        }
        
        public static function submitAchievement(name:String, value:* = null):void {
            if (_connectionFailed)
                return;
            
            switch(_apiType) {
                case(API_NG):
                    submitAchievement_NG(name);
                    break;
                
                case(API_KONG):
                    submitAchievement_Kong(name, value);
                    break;
            }
        }
        
        
        
        
        /******************************************************************************************************/
        /**                                                                                       NEWGROUNDS  */
        /******************************************************************************************************/
        
        // ::::::::::::::::::::::::::::::::::::::::::::::
        // :: Is ready?
        // ::::::::::::::::::::::::::::::::::::::::::::::
        
        private static function isReady_NG():Boolean {
            return _ng_isApiLoaded;
        }
        
        
        
        // ::::::::::::::::::::::::::::::::::::::::::::::
        // :: Connect
        // ::::::::::::::::::::::::::::::::::::::::::::::
        
        private static var _ng_isApiLoaded:Boolean = false;
        
        private static function connect_NG():void {
            API.addEventListener(APIEvent.API_CONNECTED, onConnect_NG);
            API.connect(_root, RetrocamelCore.settings.apiNewgroundsId, RetrocamelCore.settings.apiNewgroundsKey);
        }
        
        private static function onConnect_NG(e:APIEvent):void {
            if (!e.success)
                _connectionFailed = true;
            else
                _ng_isApiLoaded = true;
        }
        
        
        
        // ::::::::::::::::::::::::::::::::::::::::::::::
        // :: Static ad
        // ::::::::::::::::::::::::::::::::::::::::::::::
        
        private static function addAd_NG(addTo:DisplayObjectContainer):DisplayObject{
            var ngAd:FlashAd = new FlashAd();
            ngAd.showBorder = false;
            addTo.addChild(ngAd);
            
            return ngAd;
        }
        
        
        
        
        // ::::::::::::::::::::::::::::::::::::::::::::::
        // :: Achievement
        // ::::::::::::::::::::::::::::::::::::::::::::::
        
        private static function submitAchievement_NG(name:String):void {
            API.unlockMedal(name);
        }
        
        
        
        // ::::::::::::::::::::::::::::::::::::::::::::::
        // :: Show Score
        // ::::::::::::::::::::::::::::::::::::::::::::::
        
        private static var _ng_showScore_callback:Function;
        private static var _ng_showScore_board   :String;
        private static var _ng_showScore_browser :ScoreBrowser;
        private static var _ng_showScore_button  :RetrocamelButton;
        
        private static function showScores_NG(board:String, callback:Function):void{
            _ng_showScore_browser                = new ScoreBrowser();
            _ng_showScore_browser.scoreBoardName = _ng_sendScore_board;
            _ng_showScore_browser.x              = (RetrocamelCore.settings.gameWidth  - _ng_showScore_browser.width)  / 2;
            _ng_showScore_browser.y              = (RetrocamelCore.settings.gameHeight - _ng_showScore_browser.height) / 2;
            
            _ng_showScore_browser.loadScores();
            
            _ng_showScore_button = RetrocamelCore.make.button(onScoreShowClose_NG, "Close");
            _ng_showScore_button.alignCenter();
            _ng_showScore_button.y = _ng_showScore_browser.y + _ng_showScore_browser.height + 10 | 0;
            
            _root.addChild(_ng_showScore_browser);
            _root.addChild(_ng_showScore_button);
        }
        
        private static function onScoreShowClose_NG():void{
            _root.removeChild(_ng_showScore_browser);
            _root.removeChild(_ng_showScore_button);
            
            if (_ng_showScore_callback != null)
                _ng_showScore_callback();
            
            _ng_showScore_browser = null;
            _ng_showScore_button  = null;
        }
        
        // ::::::::::::::::::::::::::::::::::::::::::::::
        // :: Send Score
        // ::::::::::::::::::::::::::::::::::::::::::::::
        
        private static var _ng_sendScore_callback:Function;
        private static var _ng_sendScore_board   :String;
        private static var _ng_sendScore_browser :ScoreBrowser;
        private static var _ng_sendScore_button  :RetrocamelButton;
        
        private static function sendScore_NG(value:Number, board:String, callback:Function):void{
            _ng_sendScore_callback = callback;
            _ng_sendScore_board    = board;
            
            API.postScore(board, value);
            API.addEventListener(APIEvent.SCORE_POSTED, onScoreSent_NG);
        }
        
        private static function onScoreSent_NG(e:APIEvent):void{
            API.removeEventListener(APIEvent.SCORE_POSTED, onScoreSent_NG);
            
            _ng_sendScore_browser                = new ScoreBrowser();
            _ng_sendScore_browser.scoreBoardName = _ng_sendScore_board;
            _ng_sendScore_browser.x              = (RetrocamelCore.settings.gameWidth  - _ng_sendScore_browser.width)  / 2;
            _ng_sendScore_browser.y              = (RetrocamelCore.settings.gameHeight - _ng_sendScore_browser.height) / 2;
            
            _ng_sendScore_browser.loadScores();
            
            _ng_sendScore_button = RetrocamelCore.make.button(onScoreSentClose_NG, "Close");
            _ng_sendScore_button.alignCenter();
            _ng_sendScore_button.y = _ng_sendScore_browser.y + _ng_sendScore_browser.height + 10 | 0;
            
            _root.addChild(_ng_sendScore_browser);
            _root.addChild(_ng_sendScore_button);
        }
        
        private static function onScoreSentClose_NG():void{
            _root.removeChild(_ng_sendScore_browser);
            _root.removeChild(_ng_sendScore_button);
            
            if (_ng_sendScore_callback != null)
                _ng_sendScore_callback();
            
            _ng_sendScore_browser = null;
            _ng_sendScore_button  = null;
        }


        /******************************************************************************************************/
        /**                                                                               FLASH GAME LICENSE  */
        /******************************************************************************************************/

        private static var _fgl_isReady:Boolean = false;
        private static var _fgl_isFailed:Boolean = false;
        private static var _fgl_popupAdCallback:Function;
        private static var _fgl_waitingForPopupAd:Boolean;

        private static function isReady_FGL():Boolean{
            return _fgl_isReady;
        }

        private static function connect_FGL():void{
            new FGLAds(RetrocamelDisplayManager.flashStage, RetrocamelCore.settings.apiFlashGameLicenseId);

            FGLAds.api.addEventListener(FGLAds.EVT_API_READY, onConnectSuccess_FGL);
            FGLAds.api.addEventListener(FGLAds.EVT_NETWORKING_ERROR, onConnectError_FGL);
            FGLAds.api.addEventListener(FGLAds.EVT_AD_CLOSED, onAdClosed_FGL);
        }

        private static function onConnectSuccess_FGL(event:Event):void{
            _fgl_isReady = true;

            updateState_FGL();
        }

        private static function onConnectError_FGL(event:Event):void{
            _connectionFailed = false;

            _fgl_isReady = true;
            _fgl_isFailed = true;

            updateState_FGL();
        }

        private static function showPreloaderAd_FGL(callback:Function):void{
            _fgl_popupAdCallback = callback;
            _fgl_waitingForPopupAd = true;

            updateState_FGL();
        }

        private static function updateState_FGL():void{
            if (!_fgl_isReady){
                return;
            }

            if (_fgl_popupAdCallback){
                if (_fgl_isFailed){
                    _fgl_popupAdCallback();
                    _fgl_popupAdCallback = null;

                } else if (_fgl_waitingForPopupAd){
                    FGLAds.api.showAdPopup();
                    _fgl_waitingForPopupAd = false;
                }
            }
        }

        private static function onAdClosed_FGL(event:Event):void{
            _fgl_popupAdCallback();
            _fgl_popupAdCallback = null;
        }


        /******************************************************************************************************/
        /**                                                                                       KONGREGATE  */
        /******************************************************************************************************/
        
        // ::::::::::::::::::::::::::::::::::::::::::::::
        // :: Is ready?
        // ::::::::::::::::::::::::::::::::::::::::::::::
        
        private static function isReady_Kong():Boolean {
            return _kong_api != null;
        }
        
        
        
        // ::::::::::::::::::::::::::::::::::::::::::::::
        // :: Connect
        // ::::::::::::::::::::::::::::::::::::::::::::::
        
        private static var _kong_loader:Loader;
        private static var _kong_api   :*;
        
        private static function connect_Kong():void {
            var apiPath:String = _root.loaderInfo.parameters.kongregate_api_path ||
                "http://www.kongregate.com/flash/API_AS3_Local.swf";
            
            Security.allowDomain(apiPath);
            
            var request:URLRequest = new URLRequest(apiPath);
            _kong_loader = new Loader();
            _kong_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onConnect_Kong);
            _kong_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onConnectFail_Kong);
            _kong_loader.load(request);
            _root.addChild(_kong_loader);
        }
        
        private static function onConnect_Kong(e:Event):void {
            _kong_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onConnect_Kong);
            _kong_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onConnectFail_Kong);
            _kong_loader = null;
            
            _kong_api = e.target.content;
            
            _kong_api.services.connect();
        }
        
        private static function onConnectFail_Kong(e:IOErrorEvent):void {
            _kong_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onConnect_Kong);
            _kong_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onConnectFail_Kong);
            _kong_loader = null;
            
            _connectionFailed = true;
        }
        
        
        // ::::::::::::::::::::::::::::::::::::::::::::::
        // :: Submit achievement
        // ::::::::::::::::::::::::::::::::::::::::::::::
        
        private static function submitAchievement_Kong(name:String, value:*):void {
            _kong_api.stats.submit(name, value);
        }
        
        
        
        
        /******************************************************************************************************/
        /**                                                                                      MOCHI MEDIA  */
        /******************************************************************************************************/
        
        // ::::::::::::::::::::::::::::::::::::::::::::::
        // :: Is ready?
        // ::::::::::::::::::::::::::::::::::::::::::::::
        
        private static function isReady_Mochi():Boolean {
            return MochiServices.connected;
        }
        
        
        
        // ::::::::::::::::::::::::::::::::::::::::::::::
        // :: Connect
        // ::::::::::::::::::::::::::::::::::::::::::::::
        
        private static function connect_Mochi():void {
            MochiServices.connect(RetrocamelCore.settings.mochiSettings.id, _root, onConnectError_Mochi);
        }
        
        private static function onConnectError_Mochi(...rest):void {
            _connectionFailed = true;
        }
        
        
        
        // ::::::::::::::::::::::::::::::::::::::::::::::
        // :: Static Ad
        // ::::::::::::::::::::::::::::::::::::::::::::::
        
        private static function addAd_Mochi(addTo:DisplayObjectContainer):DisplayObject{
            var mochiAd:MovieClip = new MovieClip();

            addTo.addChild(mochiAd);
            
            MochiAd.showClickAwayAd( { clip:mochiAd, id:RetrocamelCore.settings.mochiSettings.id } );
            
            return mochiAd;
        }
        
        private static function showPreloaderAp_Mochi(callback:Function):void{
            MochiAd.showPreGameAd({
                clip: _root,
                id: RetrocamelCore.settings.mochiSettings.id,
                res: RetrocamelCore.settings.mochiSettings.preAdResolution,
                outline: RetrocamelCore.settings.mochiSettings.preAdOutlineColor,
                background: RetrocamelCore.settings.mochiSettings.preAdBackgroundColor,
                color: RetrocamelCore.settings.mochiSettings.preAdBarColor,
                ad_finished: callback
            });
        }
        
        
        // ::::::::::::::::::::::::::::::::::::::::::::::
        // :: Show Score
        // ::::::::::::::::::::::::::::::::::::::::::::::
        
        private static function showScores_Mochi(board:String, callback:Function):void{
            var scoreObject:Object = RetrocamelCore.settings.mochiSettings.getScoreObject(board);
            
            var boardID:String = scoreObject.f(0,"");
            MochiScores.showLeaderboard({
                boardID: boardID, 
                onClose: callback,
                onError: callback,
                res: RetrocamelCore.settings.mochiSettings.preAdResolution,
                showTableRank: true,
                previewScores: true
            });
        }
        
        
        
        // ::::::::::::::::::::::::::::::::::::::::::::::
        // :: Send Score
        // ::::::::::::::::::::::::::::::::::::::::::::::
        
        private static function sendScore_Mochi(value:Number, board:String, callback:Function):void{
            var scoreObject:Object = RetrocamelCore.settings.mochiSettings.getScoreObject(board);
            
            var boardID:String = scoreObject.f(0,"");
            MochiScores.showLeaderboard({
                boardID: boardID, 
                score: value,
                onClose: callback,
                onError: callback,
                res: RetrocamelCore.settings.mochiSettings.preAdResolution,
                showTableRank: true,
                previewScores: true
            });
        }
    }
}