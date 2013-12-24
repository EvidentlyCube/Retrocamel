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
    import net.retrocade.utils.UtilsString;

    public class RetrocamelLocaleParserRetrocadeProperties extends RetrocamelLocaleParserAbstract{
        public static function parse(textContainer:*, languageCode:String):void{
            var fileString:String = getText(textContainer);

            fileString = fileString.replace(/(\x0D\x0A|\x0D)/gm, "\x0A");
            fileString = fileString.replace(/\/\/\/\/\^\x0A\x20*/gm, "\\n\\n");
            fileString = fileString.replace(/\/\/\/\/\x0A\x20*/gm, " \\n\\n");
            fileString = fileString.replace(/\/\/\/\^\x0A\x20*/gm, "\\n");
            fileString = fileString.replace(/\/\/\/\x0A\x20*/gm, " \\n");
            fileString = fileString.replace(/\/\/\^\x0A\x20*/gm, "");
            fileString = fileString.replace(/\/\/\x0A\x20*/gm, " ");

            var lines:Array = fileString.split("\x0A");

            var i:uint = 0;
            var l:uint = lines.length;

            var line     :String;
            var lineBreak:int;

            for (; i < l; i++) {
                line      = lines[i];

                if (line.charAt(0) == "#")
                    continue;

                lineBreak = line.indexOf('=');

                if (lineBreak === -1){
                    if (UtilsString.trim(line).length > 0){
                        trace("Language ("+languageCode+", ) parse error: " + line);
                    }
                    continue;
                }

                line = line.replace(/(\r|\n)/g, '');
                line = line.replace(/\\n/g, "\n");
                line = line.replace(/\\t/g, "  ");

                RetrocamelLocale.set(languageCode, line.substr(0, lineBreak), line.substr(lineBreak + 1));
            }
        }
    }
}
