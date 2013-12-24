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
 * Created by Skell on 11.12.13.
 */
package net.retrocade.log {
    import net.retrocade.functions.printf;
    import net.retrocade.utils.UtilsString;

    public class Logger {
        public var logCallback:Function;

        public function Logger(){
        }

        public function log(message:String, logType:LogType):void{
            var date:Date = new Date();
            var logMessage:String = printf(
                "[%%-%%-%% %%:%%:%%.%% %%] %%",
                UtilsString.padLeft(date.date, 2),
                UtilsString.padLeft(date.month + 1, 2),
                date.fullYear + 1,
                UtilsString.padLeft(date.hours, 2),
                UtilsString.padLeft(date.minutes, 2),
                UtilsString.padLeft(date.seconds, 2),
                UtilsString.padLeft(date.milliseconds, 3),
                logType.name,
                message
            );

            if (logCallback !== null && logCallback.length == 1){
                logCallback(logMessage);
            } else {
                trace(logMessage);
            }
        }
    }
}
