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
 * Date: 02.10.13
 * Time: 14:18
 * To change this template use File | Settings | File Templates.
 */
package net.retrocade.retrocamel.model {

    public class RetrocamelMochiSettings {
        public var id:String;
        public var preAdResolution:String;
        public var preAdOutlineColor:uint;
        public var preAdBackgroundColor:uint;
        public var preAdBarColor:uint;

        private var _scores:Object = [];

        public function getScoreObject(scoreName:String):Object{
            return _scores[scoreName];
        }

        public function addScoreObject(scoreName:String, object:Object):void{
            _scores[scoreName] = object;
        }
    }
}
