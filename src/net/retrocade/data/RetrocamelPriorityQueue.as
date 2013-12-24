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
 * Date: 08.02.13
 * Time: 11:54
 * To change this template use File | Settings | File Templates.
 */
package net.retrocade.data {
    public class RetrocamelPriorityQueue {
        private var _firstElement:PriorityElement;
        private var _lastElement:PriorityElement;

        public function addFromEnd(item:Object, priority:int):void {
            var addedElement:PriorityElement = PriorityElement.newInstance;
            addedElement.item = item;
            addedElement.priority = priority;

            if (!_lastElement) {
                _lastElement = addedElement;
                _firstElement = addedElement;
            } else {
                var smallerPriorityElement:PriorityElement = _lastElement;
                while (smallerPriorityElement && smallerPriorityElement.priority > priority) {
                    smallerPriorityElement = smallerPriorityElement.prevItem;
                }

                if (!smallerPriorityElement) {
                    addedElement.nextItem = _firstElement;
                    _firstElement.prevItem = addedElement;
                    _firstElement = addedElement;
                } else {
                    addedElement.prevItem = smallerPriorityElement;
                    addedElement.nextItem = smallerPriorityElement.nextItem;

                    if (addedElement.nextItem) {
                        addedElement.nextItem.prevItem = addedElement;
                    } else {
                        _lastElement = addedElement;
                    }

                    smallerPriorityElement.nextItem = addedElement;
                }
            }
        }

        public function shift():* {
            if (_firstElement) {
                var returnedItem:* = _firstElement.item;

                var toDestroy:PriorityElement = _firstElement;
                _firstElement = toDestroy.nextItem;
                if (!toDestroy.nextItem) {
                    _lastElement = null;
                }
                toDestroy.destroy();

                return returnedItem;
            } else {
                return null;
            }
        }
    }
}


class PriorityElement {
    private static var _pool:Vector.<PriorityElement>;
    private static var _poolIndex:int = 0;
    private static var _poolLength:int = 512;

    {
        _pool = new Vector.<PriorityElement>();
        _pool.length = _poolLength;
    }

    public static function get newInstance():PriorityElement {
        if (_poolIndex > 0) {
            return _pool[--_poolIndex];
        } else {
            return new PriorityElement();
        }
    }

    public var item:*;
    public var priority:int;
    public var nextItem:PriorityElement;
    public var prevItem:PriorityElement;

    public function destroy():void {
        item = null;
        priority = 0;

        if (nextItem) {
            nextItem.prevItem = prevItem;
        }

        if (prevItem) {
            prevItem.nextItem = nextItem;
        }

        nextItem = null;
        prevItem = null;

        if (_poolIndex == _poolLength) {
            _poolLength *= 2;
            _pool.length = _poolLength;
        }

        _pool[_poolIndex++] = this;
    }
}
