/*
 * Copyright (C) 2013 Maurycy Zarzycki
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

package com.adobe.serialization.json {

    public class JSONToken {
    
        private var _type:int;
        private var _value:Object;
        
        /**
         * Creates a new JSONToken with a specific token type and value.
         *
         * @param type The JSONTokenType of the token
         * @param value The value of the token
         * @langversion ActionScript 3.0
         * @playerversion Flash 9.0
         * @tiptext
         */
        public function JSONToken( type:int = -1 /* JSONTokenType.UNKNOWN */, value:Object = null ) {
            _type = type;
            _value = value;
        }
        
        /**
         * Returns the type of the token.
         *
         * @see com.adobe.serialization.json.JSONTokenType
         * @langversion ActionScript 3.0
         * @playerversion Flash 9.0
         * @tiptext
         */
        public function get type():int {
            return _type;    
        }
        
        /**
         * Sets the type of the token.
         *
         * @see com.adobe.serialization.json.JSONTokenType
         * @langversion ActionScript 3.0
         * @playerversion Flash 9.0
         * @tiptext
         */
        public function set type( value:int ):void {
            _type = value;    
        }
        
        /**
         * Gets the value of the token
         *
         * @see com.adobe.serialization.json.JSONTokenType
         * @langversion ActionScript 3.0
         * @playerversion Flash 9.0
         * @tiptext
         */
        public function get value():Object {
            return _value;    
        }
        
        /**
         * Sets the value of the token
         *
         * @see com.adobe.serialization.json.JSONTokenType
         * @langversion ActionScript 3.0
         * @playerversion Flash 9.0
         * @tiptext
         */
        public function set value ( v:Object ):void {
            _value = v;    
        }

    }
    
}