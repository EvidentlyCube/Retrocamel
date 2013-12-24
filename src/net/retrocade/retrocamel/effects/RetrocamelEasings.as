/*
 * Copyright (C) 2013 Maurycy Zarzycki
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

package net.retrocade.retrocamel.effects {
    public class RetrocamelEasings {
        private static const PI_HALF:Number = Math.PI / 2;

        /**
         * Start slow and accelerate
         */
        public static function quadraticIn(pos:Number):Number {
            return pos * pos;
        }

        /**
         * Start fast and decelerate
         */
        public static function quadraticOut(pos:Number):Number {
            pos -= 1;
            return 1 - pos * pos;
        }

        /**
         * Start slow and accelerate, then decelerate from the middle
         */
        public static function quadraticInOut(pos:Number):Number {
            if (pos < 0.5) {
                return 0.5 * pos * pos;
            }

            pos -= 2;

            return 0.5 * (2 - pos * pos);
        }

        /**
         * Start very slow and accelerate
         */
        public static function cubicIn(pos:Number):Number {
            return pos * pos * pos;
        }

        /**
         * Start very fast and decelerate
         */
        public static function cubicOut(pos:Number):Number {
            pos -= 1;
            return pos * pos * pos + 1;
        }

        public static function cubicInOut(pos:Number):Number {
            if (pos < 0.5) {
                return 0.5 * pos * pos * pos;
            }

            pos -= 2;

            return 0.5 * (pos * pos * pos + 2);
        }

        public static function sineIn(pos:Number):Number {
            return -1 * Math.cos(pos * PI_HALF) + 1;
        }

        public static function sineOut(pos:Number):Number {
            return Math.sin(pos * PI_HALF);
        }

        public static function sineInOut(pos:Number):Number {
            return -0.5 * (Math.cos(Math.PI * pos) - 1);
        }

        public static function exponentialIn(t:Number):Number {
            return (t == 0) ? 0 : 1 * Math.pow(2, 10 * (t - 1));
        }

        public static function exponentialOut(t:Number):Number {
            return (t == 1) ? 1 : 1 * (-Math.pow(2, -10 * t) + 1);
        }

        public static function exponentialInOut(t:Number):Number {
            if (t == 0) {
                return 0;
            }

            if (t == 1) {
                return 1;
            }

            if ((t /= 0.5) < 1) {
                return 0.5 * Math.pow(2, 10 * (t - 1));
            }

            return 0.5 * (-Math.pow(2, -10 * --t) + 2);
        }
    }
}