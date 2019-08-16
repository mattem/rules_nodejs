const fs = require('fs');
const DIR = 'build_bazel_rules_nodejs/packages/rollup/test';

describe('rollup_bundle rule', () => {
  for (format of ['cjs', 'umd']) {
    it(`should build ${format} bundle`, () => {
      const actual = fs.readFileSync(require.resolve(DIR + `/bundle.${format}.js`), 'utf-8');
      const expected =
          fs.readFileSync(require.resolve(DIR + `/bundle-${format}_golden.js_`), 'utf-8');
      expect(actual).toBe(expected);
    });
  }
});
