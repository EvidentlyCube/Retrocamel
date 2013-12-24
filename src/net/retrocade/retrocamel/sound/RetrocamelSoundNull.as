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
 * Date: 08.10.13
 * Time: 10:33
 * To change this template use File | Settings | File Templates.
 */
package net.retrocade.retrocamel.sound {

    import flash.utils.clearTimeout;
    import flash.utils.getTimer;
    import flash.utils.setTimeout;

    import net.retrocade.retrocamel.interfaces.IRetrocamelSound;

    public class RetrocamelSoundNull implements IRetrocamelSound {
        private var _duration:Number;
        private var _timeoutId:uint;
        private var _timerStart:Number = 0;
        private var _loops:uint;
        private var _isRunning:Boolean = false;
        private var _isPaused:Boolean = false;
        private var _volume:Number = 1;
        private var _pan:Number = 1;
        private var _timeLeftForCurrentRepetition:Number = 0;

        public function RetrocamelSoundNull(duration:Number) {
            _duration = duration;
        }

        public function play(loops:uint = 0, volumeModifier:Number = 1, pan:Number = 0):void {
            _volume = volumeModifier;
            _pan = pan;

            subPlay(loops, _duration);
        }

        public function pause():void {
            if (_isRunning) {
                var timeDelta:Number = getTimer() - _timerStart;

                clearTimeout(_timeoutId);
                _timeoutId = 0;

                _timeLeftForCurrentRepetition = _timeLeftForCurrentRepetition - timeDelta;
                _isRunning = false;
                _isPaused = true;
            }
        }

        public function stop():void {
            pause();

            _timeLeftForCurrentRepetition = 0;
            _loops = 0;
            _isPaused = false;
        }

        public function resume():void {
            if (_isPaused) {
                subPlay(_loops, _timeLeftForCurrentRepetition);
            }
        }

        public function dispose():void {
            stop();
        }

        private function subPlay(loops:uint, durationToPlay:Number):void {
            stop();

            _loops = loops;
            _isRunning = true;
            _timeoutId = setTimeout(onTimerFinished, durationToPlay);
            _timerStart = getTimer();
            _timeLeftForCurrentRepetition = durationToPlay;
        }

        private function onTimerFinished():void {
            if (_loops) {
                play(_loops - 1, _volume, _pan);
            } else {
                stop();
            }
        }

        public function get pauseTime():Number {
            return _isPaused ? _duration - _timeLeftForCurrentRepetition : 0;
        }

        public function get loops():uint {
            return _loops;
        }

        public function set loops(value:uint):void {
            _loops = value;
        }

        public function get length():Number {
            return _duration;
        }

        public function get volume():Number {
            return _volume;
        }

        public function set volume(value:Number):void {
            _volume = value;
        }

        public function get pan():Number {
            return _pan;
        }

        public function set pan(value:Number):void {
            _pan = value;
        }

        public function get isPlaying():Boolean {
            return _isRunning;
        }

        public function get position():Number {
            return _duration - _timeLeftForCurrentRepetition + (getTimer() - _timerStart);
        }
    }
}
