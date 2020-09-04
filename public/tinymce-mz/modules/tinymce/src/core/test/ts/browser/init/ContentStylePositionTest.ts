import { Assertions, Pipeline, Step } from '@ephox/agar';
import { Arr } from '@ephox/katamari';
import { TinyLoader } from '@ephox/mcagar';
import { Element, Node } from '@ephox/sugar';
import Theme from 'tinymce/themes/silver/Theme';
import { UnitTest } from '@ephox/bedrock-client';
import { NodeListOf, HTMLElement } from '@ephox/dom-globals';

UnitTest.asynctest('browser.tinymce.core.init.ContentStylePositionTest', (success, failure) => {
  Theme();

  const contentStyle = '.class {color: blue;}';

  TinyLoader.setupLight(function (editor, onSuccess, onFailure) {

    Pipeline.async({}, [
      Step.sync(function () {
        const headStuff: NodeListOf<HTMLElement> = editor.getDoc().head.querySelectorAll('link, style');
        const linkIndex = Arr.findIndex(headStuff, function (elm) {
          return Node.name(Element.fromDom(elm)) === 'link';
        }).getOrDie('could not find link elemnt');
        const styleIndex = Arr.findIndex(headStuff, function (elm) {
          return elm.innerText === contentStyle;
        }).getOrDie('could not find content style tag');

        Assertions.assertEq('style tag should be after link tag', linkIndex < styleIndex, true);
      })
    ], onSuccess, onFailure);
  }, {
    content_style: contentStyle,
    base_url: '/project/tinymce/js/tinymce'
  }, success, failure);
});
