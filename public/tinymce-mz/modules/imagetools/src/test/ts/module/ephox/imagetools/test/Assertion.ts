import { assert } from '@ephox/bedrock-client';
import { console } from '@ephox/dom-globals';

const assertEq = function (expected: any, actual: any, label: string) {
  assert.eq(expected, actual, 'test: ' + label + ', expected = ' + expected + ', actual = ' + actual);
  // tslint:disable-next-line:no-console
  console.log('passed');
};

export {
  assertEq
};
