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
 * User: Ryc
 * Date: 23.09.13
 * Time: 16:08
 * To change this template use File | Settings | File Templates.
 */
package net.retrocade.retrocamel.locale {
    public class RetrocamelLocaleParserJavaProperties extends RetrocamelLocaleParserAbstract {
        public static function parse(textContainer:*, languageCode:String):void {
            var fileString:String = getText(textContainer);

            var props:Array = [];
            var lines:Array;
            var linesCount:int;
            var i:int;
            var s:String;
            var multiline:Boolean = false;

            const CR:String = String.fromCharCode(13);
            const LF:String = String.fromCharCode(10);
            const hasCR:Boolean = fileString.indexOf(CR) > -1;
            const hasLF:Boolean = fileString.indexOf(LF) > -1;

            // remove tabs
            fileString = fileString.replace(new RegExp(String.fromCharCode(3), "g"), "");

            // split into lines (depending on the line-end type, will split on CRLF, CR, or LF)
            lines = fileString.split((hasCR && hasLF) ? CR + LF : hasCR ? CR : LF);
            linesCount = lines.length;

            // build into array with each property
            for (i = 0; i < linesCount; i++) {
                s = stripWhitespace(String(lines[i]));

                if (s.length > 1 && s.charAt(0) != "#" && s.charAt(0) != "!") { //Ignore comments and empty lines
                    // if it's a multiline var, add this to the last one
                    if (multiline) {
                        props[props.length - 1] = String(props[props.length - 1]).substr(0, -1) + s;
                    } else {
                        props.push(s);
                    }

                    //does the property extend over more than one line?
                    multiline = s.charAt(s.length - 1) == "\\";
                }
            }

            // parse into name / value pairs
            i = props.length;
            var splitIndex:int;
            var name:String;
            while (--i > -1) {
                s = props[i];
                splitIndex = getSplitIndex(s);

                if (splitIndex == -1) {
                    props.splice(i, 1);
                    continue;
                }

                // extract and clean whitespace
                name = s.substring(0, splitIndex);
                name = stripWhitespace(name);

                fileString = s.substring(splitIndex + 1);
                fileString = stripWhitespace(fileString);
                fileString = fileString.replace(/\\n/g, "\n");

                trace("!"+name+":"+fileString+"!");
                RetrocamelLocale.set(languageCode, name, fileString);
            }
        }

        private static function getSplitIndex(value:String):int {
            const s:Array = ["=", ":"]; // can split on '=' or ':'
            var n:int = 2;
            var index1:int;
            var index2:int = value.length;
            while (--n > -1) {
                index1 = value.indexOf(s[n]);
                if (index1 > -1 && index1 < index2) {
                    index2 = index1;
                }
            }
            return (index2 == value.length - 1) ? -1 : index2;
        }

        private static function stripWhitespace(value:String):String {
            // strip empty space left and right, and consecutive spaces
            return value.replace(/^[ \s]+|[ \s]+$/g, "");
        }
    }
}
