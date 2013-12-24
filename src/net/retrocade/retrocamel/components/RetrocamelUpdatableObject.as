/*
 * Copyright (C) 2013 Maurycy Zarzycki
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

package net.retrocade.retrocamel.components {

    import net.retrocade.retrocamel.core.RetrocamelCore;
    import net.retrocade.retrocamel.components.RetrocamelUpdatableGroup;
    import net.retrocade.retrocamel.interfaces.IRetrocamelUpdatable;

    public class RetrocamelUpdatableObject implements IRetrocamelUpdatable {
        /**
         * If false object is not automatically updated
         */
        public var active:Boolean = true;

        public function update():void {
        }


        /****************************************************************************************************************/
        /**                                                                                        ADDING AND REMOVING  */

        final public function addDefault():void {
            defaultGroup.add(this);
        }

        final public function addAtDefault(index:uint):void {
            defaultGroup.addAt(this, index);
        }

        final public function nullifyDefault():void {
            defaultGroup.nullify(this);
        }

        final public function removeDefault():void {
            defaultGroup.remove(this);
        }

        /****************************************************************************************************************/

        public function get defaultGroup():RetrocamelUpdatableGroup {
            return RetrocamelCore.currentState.defaultGroup;
        }
    }
}