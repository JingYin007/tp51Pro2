import { Element as DomElement, Range, Window } from '@ephox/dom-globals';
import { Arr } from '@ephox/katamari';
import Element from '../../api/node/Element';
import * as Node from '../../api/node/Node';
import * as SelectorFilter from '../../api/search/SelectorFilter';
import * as Selectors from '../../api/search/Selectors';
import { Selection } from '../../api/selection/Selection';
import * as NativeRange from '../core/NativeRange';
import * as SelectionDirection from '../core/SelectionDirection';

const withinContainer = (win: Window, ancestor: Element<DomElement>, outerRange: Range, selector: string) => {
  const innerRange = NativeRange.create(win);
  const self = Selectors.is(ancestor, selector) ? [ ancestor ] : [];
  const elements = self.concat(SelectorFilter.descendants(ancestor, selector));
  return Arr.filter(elements, (elem) => {
    // Mutate the selection to save creating new ranges each time
    NativeRange.selectNodeContentsUsing(innerRange, elem);
    return NativeRange.isWithin(outerRange, innerRange);
  });
};

const find = (win: Window, selection: Selection, selector: string) => {
  // Reverse the selection if it is RTL when doing the comparison
  const outerRange = SelectionDirection.asLtrRange(win, selection);
  const ancestor = Element.fromDom(outerRange.commonAncestorContainer);
  // Note, this might need to change when we have to start looking for non elements.
  return Node.isElement(ancestor) ?
    withinContainer(win, ancestor, outerRange, selector) : [];
};

export {
  find
};
