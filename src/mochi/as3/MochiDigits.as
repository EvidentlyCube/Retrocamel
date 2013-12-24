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
* MochiServices
* Connection class for all MochiAds Remote Services
* @author Mochi Media
*/

package mochi.as3
{
    final public class MochiDigits
    {
        private var Fragment:Number;
        private var Sibling:MochiDigits;
        private var Encoder:Number;

        /**
         * Method: MochiDigits
         * Construct and initialize the value of a MochiDigit
         * @param   digit: initialization value
         * @param   index: internal use only
         */
        public function MochiDigits( digit:Number = 0, index:uint = 0 ):void
        {
            Encoder = 0;
            setValue( digit, index );
        }

        public function get value():Number
        {
            return Number(this.toString());
        }

        public function set value(v:Number):void
        {
            setValue( v );
        }

        /**
         * Method: add
         * Increments the stored value by a specified amount
         * @param   inc: Value to add to the stored variable
         */
        public function addValue(inc:Number):void
        {
            value += inc;
        }

        /**
         * Method: setValue
         * Resets the stored value
         * @param   digit: initialization value
         * @param   index: internal use only
         */
        public function setValue( digit:Number = 0, index:uint = 0 ):void
        {
            var s:String = digit.toString();
            Fragment = s.charCodeAt(index++) ^ Encoder;

            if( index < s.length )
                Sibling = new MochiDigits(digit,index);
            else
                Sibling = null;

            reencode();
        }

        /**
         * Method: reencode
         * Reencodes the stored number without changing its value
         */
        public function reencode():void
        {
            var newEncode:uint = int(0x7FFFFFFF * Math.random());

            Fragment ^= newEncode ^ Encoder;
            Encoder = newEncode;
        }

        /**
         * Method: toString
         * Returns the stored number as a formatted string
         */
        public function toString():String
        {
            var s:String = String.fromCharCode(Fragment ^ Encoder);

            if( Sibling != null)
                s += Sibling.toString();

            return s;
        }
    }
}
