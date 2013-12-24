/*
 * Copyright (C) 2013 Maurycy Zarzycki
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

package net.retrocade.retrocamel.core{
    import flash.display.Stage;
    import flash.geom.Rectangle;

    import net.retrocade.retrocamel.core.RetrocamelDisplayManager;
    import net.retrocade.retrocamel.core.retrocamel_int;
    import net.retrocade.retrocamel.display.global.RetrocamelCursor;
    import net.retrocade.retrocamel.interfaces.IRetrocamelStarlingRoot;

    import starling.animation.Juggler;
    import starling.core.Starling;
    import starling.display.Sprite;
    import starling.events.Event;

    use namespace retrocamel_int;
    
    public class RetrocamelStarlingCore{
        retrocamel_int static var _starlingInstance:Starling;
        retrocamel_int static var _starlingRoot    :Sprite;  
        
        public static function get starlingInstance():Starling{
            return _starlingInstance;
        }
        
        public static function get starlingRoot():Sprite{
            return _starlingRoot;
        }
        
        private static var _initializeCallback:Function;

        private static var _isInitialized:Boolean = false;
        
        public static function initialize(root:Class, stage:Stage, viewPort:Rectangle = null, onInitializeCallback:Function = null):void{
            _initializeCallback = onInitializeCallback;

            checkRootClass(root);

            Starling.multitouchEnabled = true;
            
            _starlingInstance = new Starling(root, stage, viewPort, null, 'auto', 'baseline');
            _starlingInstance.addEventListener(Event.ROOT_CREATED, onStarlingCreated);
            _starlingInstance.antiAliasing = 0;
            _starlingInstance.start();
            
            _starlingInstance.simulateMultitouch = true;
        }
        
        public static function get juggler():Juggler{
            return _starlingInstance.juggler;
        }
        
        private static function onStarlingCreated(e:Event):void{
            _isInitialized = true;

            _starlingRoot = e.data as Sprite;
            RetrocamelDisplayManager.initializeStarling(_starlingRoot.stage);
            RetrocamelCursor.initializeStarling();
            
            if (_initializeCallback != null){
                _initializeCallback();
            }

            IRetrocamelStarlingRoot(_starlingRoot).init();
        }

        private static function checkRootClass(cls:Class):void{
            var instance:* = new cls;

            if (!(instance is Sprite)){
                throw new ArgumentError("Passed class should extends starling.display.Sprite");
            }

            if (!(instance is IRetrocamelStarlingRoot)){
                throw new ArgumentError("Passed class should implements rIStarlingRoot");
            }
        }

        public static function get isInitialized():Boolean {
            return _isInitialized;
        }
    }
}