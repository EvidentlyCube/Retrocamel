/*
 * Copyright (C) 2013 Maurycy Zarzycki
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

package net.retrocade.retrocamel.display.starling {
    import flash.errors.IllegalOperationError;

    import starling.animation.IAnimatable;
    import starling.display.Image;
    import starling.textures.Texture;

    /** A MovieClip is a simple way to display an animation depicted by a list of textures.
     *
     *  <p>Pass the frames of the movie in a vector of textures to the constructor. The movie clip
     *  will have the width and height of the first frame. If you group your frames with the help
     *  of a texture atlas (which is recommended), use the <code>getTextures</code>-method of the
     *  atlas to receive the textures in the correct (alphabetic) order.</p>
     *
     *  <p>You can specify the desired framerate via the constructor. You can, however, manually
     *  give each frame a custom duration. You can also play a sound whenever a certain frame
     *  appears.</p>
     *
     *  <p>The methods <code>play</code> and <code>pause</code> control playback of the movie. You
     *  will receive an event of type <code>Event.MovieCompleted</code> when the movie finished
     *  playback. If the movie is looping, the event is dispatched once per loop.</p>
     *
     *  <p>As any animated object, a movie clip has to be added to a juggler (or have its
     *  <code>advanceTime</code> method called regularly) to run. The movie will dispatch
     *  an event of type "Event.COMPLETE" whenever it has displayed its last frame.</p>
     *
     *  @see starling.textures.TextureAtlas
     */
    public class RetrocamelMovieClipStarling extends Image implements IAnimatable {
        protected var _textures:Vector.<Texture>;
        private var _frameDuration:Number;
        private var _totalTime:Number;
        private var _currentTime:Number;
        protected var _currentFrame:int;
        protected var _isPlaying:Boolean;
        private var _isLooping:Boolean;

        /**
         *  Creates a movie clip from the provided textures and with the specified default framerate.
         *  The movie will have the size of the first frame.
         */
        public function RetrocamelMovieClipStarling(textures:Vector.<Texture>, fps:Number = 12) {
            super(textures[0]);

            init(textures, fps);
        }

        public function addFrame(texture:Texture):void {
            _textures.push(texture);
            _totalTime = _frameDuration * numFrames;
        }

        /**
         * Adds a frame at a certain index, optionally with a sound and a custom duration.
         */
        public function addFrameAt(frameID:int, texture:Texture):void {
            if (frameID < 0 || frameID > numFrames) {
                throw new ArgumentError("Invalid frame id");
            }

            _textures.splice(frameID, 0, texture);
            _totalTime = _frameDuration * numFrames;
        }

        /**
         * Removes the frame at a certain ID. The successors will move down.
         */
        public function removeFrameAt(frameID:int):void {
            if (frameID < 0 || frameID >= numFrames) {
                throw new ArgumentError("Invalid frame id");
            }
            if (numFrames == 1) {
                throw new IllegalOperationError("Movie clip must not be empty");
            }

            _textures.splice(frameID, 1);

            _totalTime = _frameDuration * numFrames;
        }

        /** Returns the texture of a certain frame. */
        public function getFrameTexture(frameID:int):Texture {
            if (frameID < 0 || frameID >= numFrames) {
                throw new ArgumentError("Invalid frame id");
            }
            return _textures[frameID];
        }

        /** Sets the texture of a certain frame. */
        public function setFrameTexture(frameID:int, texture:Texture):void {
            if (frameID < 0 || frameID >= numFrames) {
                throw new ArgumentError("Invalid frame id");
            }
            _textures[frameID] = texture;
        }

        /** Starts playback. Beware that the clip has to be added to a juggler, too! */
        public function play():void {
            _isPlaying = true;
        }

        // playback methods

        /** Pauses playback. */
        public function pause():void {
            _isPlaying = false;
        }

        /** Stops playback, resetting "currentFrame" to zero. */
        public function stop():void {
            _isPlaying = false;
            currentFrame = 0;
        }

        /** @inheritDoc */
        public function advanceTime(passedTime:Number):void {
            if (passedTime < 0) {
                throw new ArgumentError("passedTime can't be smaller than 0");
            }

            var oldTime:int = _currentTime;
            var previousFrame:int = _currentFrame;
            var newFrame:int = _currentFrame;

            if (_isPlaying && passedTime > 0.0) {
                _currentTime += passedTime;

                _currentTime = (_currentTime + passedTime) % _totalTime;
                newFrame = (_currentTime / _frameDuration) | 0;
            }

            if (!_isLooping && _currentTime < oldTime){
                stop();

            } else if (previousFrame != newFrame) {
                _currentFrame = newFrame;
                texture = _textures[_currentFrame];
            }
        }

        // IAnimatable

        private function init(textures:Vector.<Texture>, fps:Number):void {
            if (fps <= 0) {
                throw new ArgumentError("Invalid fps: " + fps);
            }
            var numFrames:int = textures.length;

            _frameDuration = 1000 / fps;
            _isPlaying = true;
            _currentTime = 0.0;
            _currentFrame = 0;
            _totalTime = _frameDuration * numFrames;
            _textures = textures.concat();
            _isLooping = true;
        }

        // properties  

        /** The total number of frames. */
        public function get numFrames():int {
            return _textures.length;
        }

        /** The index of the frame that is currently displayed. */
        public function get currentFrame():int {
            return _currentFrame;
        }

        public function set currentFrame(value:int):void {
            _currentFrame = value % numFrames;
            _currentTime = value * _frameDuration;

            texture = _textures[_currentFrame];
        }

        /** The default number of frames per second. Individual frames can have different
         *  durations. If you change the fps, the durations of all frames will be scaled
         *  relatively to the previous value. */
        public function get fps():Number {
            return 1.0 / _frameDuration;
        }

        public function set fps(value:Number):void {
            if (value <= 0) {
                throw new ArgumentError("Invalid fps: " + value);
            }

            var newFrameDuration:Number = 1000 / value;

            _currentTime *= newFrameDuration / _frameDuration;
            _frameDuration = newFrameDuration;
            _totalTime = _frameDuration * numFrames;
        }

        /** Indicates if the clip is still playing. Returns <code>false</code> when the end
         *  is reached. */
        public function get isPlaying():Boolean {
            return _isPlaying;
        }

        public function get isLooping():Boolean {
            return _isLooping;
        }

        public function set isLooping(value:Boolean):void {
            _isLooping = value;
        }

        public function get frameDuration():Number {
            return _frameDuration;
        }

        public function get totalTime():Number {
            return _totalTime;
        }

        public function get currentTime():Number {
            return _currentTime;
        }

        public function get textures():Vector.<Texture>{
            return _textures;
        }
    }
}