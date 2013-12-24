/*
 * Copyright (C) 2013 Maurycy Zarzycki
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

package net.retrocade.retrocamel.interfaces {
    public interface IRetrocamelSound {
        function play(loop:uint = 0, volumeModifier:Number = 1, pan:Number = 0):void;
        function pause():void;
        function stop():void;
        function resume():void;
        function get pauseTime():Number;
        function get loops():uint;
        function set loops(value:uint):void;
        function get volume():Number;
        function set volume(value:Number):void;
        function get pan():Number;
        function set pan(value:Number):void;
        function get isPlaying():Boolean;
        function get position():Number;
        function get length():Number;

        function dispose():void;

    }
}