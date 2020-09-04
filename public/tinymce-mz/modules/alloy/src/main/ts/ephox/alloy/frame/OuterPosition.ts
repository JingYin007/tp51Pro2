import { document } from '@ephox/dom-globals';
import { Arr, Fun } from '@ephox/katamari';
import { Element, Location, Position, Scroll } from '@ephox/sugar';

import * as Frames from './Frames';
import * as Navigation from './Navigation';

const find = (element: Element): Position => {
  const doc = Element.fromDom(document);
  const scroll = Scroll.get(doc);

  // Get the path of iframe elements to this element.
  const path = Frames.pathTo(element, Navigation);

  return path.fold(Fun.curry(Location.absolute, element), (frames) => {
    const offset = Location.viewport(element);

    const r = Arr.foldr(frames, (b, a) => {
      const loc = Location.viewport(a);
      return {
        left: b.left + loc.left(),
        top: b.top + loc.top()
      };
    }, { left: 0, top: 0 });

    return Position(r.left + offset.left() + scroll.left(), r.top + offset.top() + scroll.top());
  });
};

export {
  find
};
