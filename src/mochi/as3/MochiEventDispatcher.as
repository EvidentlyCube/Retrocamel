/*
 * Copyright (C) 2013 Maurycy Zarzycki
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

package mochi.as3 {
    public class MochiEventDispatcher
    {
        // Event table
        private var eventTable:Object;

        public function MochiEventDispatcher():void
        {
            eventTable = {};
        }

        public function addEventListener ( event:String, delegate:Function ):void
        {
            // Make sure we don't refire events
            removeEventListener( event, delegate );

            eventTable[event].push( delegate );
        }

        public function removeEventListener ( event:String, delegate:Function ):void
        {
            // Abort if event is not monitored
            if( eventTable[event] == undefined )
            {
                eventTable[event] = [];
                return ;
            }

            for( var s:Object in eventTable[event] )
            {
                if( eventTable[event][s] != delegate )
                    continue ;

                eventTable[event].splice(Number(s),1);
            }
        }

        public function triggerEvent ( event:String, args:Object ):void
        {
            // Abort if event is not monitored
            if( eventTable[event] == undefined )
                return ;

            for( var i:Object in eventTable[event] )
                eventTable[event][i](args);
        }
    }
}
