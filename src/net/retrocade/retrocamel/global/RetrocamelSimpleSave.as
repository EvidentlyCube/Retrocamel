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

    import net.retrocade.retrocamel.core.*;
    import flash.net.SharedObject;
    
    import net.retrocade.utils.UtilsCrypto;

    use namespace retrocamel_int;

    public class RetrocamelSimpleSave{
        /****************************************************************************************************************/
        /**                                                                                                  VARIABLES  */
        /****************************************************************************************************************/

        /**
         * Shared object used to work with saves
         */
        private static var currentSharedObject:SharedObject;
        
        /**
         * An array of shared objects: storagename => SharedObject 
         */
        private static var sharedObjects:Array = [];




        /****************************************************************************************************************/
        /**                                                                                                  FUNCTIONS  */
        /****************************************************************************************************************/

        public function RetrocamelSimpleSave(){ new Error("Can't instantiate SaveLoad object - please use static methods only!") }

        public static function setStorage(storageName:String):void{
            if (!storageName || storageName.length == 0)
                throw new ArgumentError("Invalid storage name");
            
            if (sharedObjects[storageName])
                currentSharedObject = sharedObjects[storageName];
            else {
                currentSharedObject = SharedObject.getLocal(storageName, "/");
                sharedObjects[storageName] = currentSharedObject;
            }
        }



        // ::::::::::::::::::::::::::::::::::::::::::::::::
        // :: Save & Load
        // ::::::::::::::::::::::::::::::::::::::::::::::::

        /**
         * Writes data to the currently set SharedObject or the one with a specified name. 
         * If you try to access a storage which hasn't been previosly set even once you'll get an error.
         * @param dataName Name of the data to save
         * @param data Value to save
         * @param storageName Optional custom storage name
         */
        public static function write(dataName:String, data:*, storageName:String = null):void{
            var so:SharedObject;
            
            if (storageName){
                if (!sharedObjects[storageName])
                    throw new Error("Tried to access not yet created storage: " + storageName);
                
                so = sharedObjects[storageName];
            } else 
                so = currentSharedObject;
                
            currentSharedObject.data[dataName] = data;
        }

        /**
         * Reads data from the currently set SharedObject or the one with a specified name. If the data was not set
         * the default value will be retrieved instead.
         * If you try to access a storage which hasn't been previosly set even once you'll get an error. 
         * @param dataName Name of the data to read
         * @param defaultVal Default value to return if no data was found
         * @param storageName Optional custom storage name
         * @return Previously written data
         */
        public static function read(dataName:String, defaultVal:*, storageName:String = null):*{
            var so:SharedObject;
            if (storageName){
                if (!sharedObjects[storageName])
                    throw new Error("Tried to access not yet created storage: " + storageName);
                
                so = sharedObjects[storageName];
            } else
                so = currentSharedObject;
            
            if (!so.data.hasOwnProperty(dataName))
                return defaultVal;

            return so.data[dataName];
        }

        /**
         * Writes data to the currently set SharedObject or the one with a specified name.
         * Also perfoorms a flush.
         * If you try to access a storage which hasn't been previosly set even once you'll get an error.
         * @param dataName Name of the data to save
         * @param data Value to save
         * @param storageName Optional custom storage name
         */
        public static function writeFlush(dataName:String, data:*, storageName:String = null):void{
            write(dataName, data, storageName);
            flush();
        }

        /**
         * Removed data from the currently set SharedObject or the one with a specified name.
         * If you try to access a storage which hasn't been previosly set even once you'll get an error. 
         * @param name Name of the ddata to remove
         * @param storageName Optional custom storage name
         */
        public static function deleteData(name:String, storageName:String = null):void{
            var so:SharedObject;
            if (storageName){
                if (!sharedObjects[storageName])
                    throw new Error("Tried to access not yet created storage: " + storageName);
                
                so = sharedObjects[storageName];
            } else
                so = currentSharedObject;
            
            delete so.data[name];
        }
        
        /**
         * Flushes the currently set SharedObject or the one with a specified name.
         * If you try to access a storage which hasn't been previosly set even once you'll get an error. 
         * @param size The requested diskspace 
         * @param storageName Optional custom storage name
         */
        public static function flush(size:int = 0, storageName:String = null):void{
            var so:SharedObject;
            if (storageName){
                if (!sharedObjects[storageName])
                    throw new Error("Tried to access not yet created storage: " + storageName);
                
                so = sharedObjects[storageName];
            } else
                so = currentSharedObject;
            
            so.flush(size);
        }

    }
}