import json from 'rollup-plugin-json';

module.exports = {
  output: {
    name: 'bundle',
    globals: {some_global_var: 'runtime_name_of_global_var'},
    // FIXME: the version placeholder below should be replaced with stamp_data somewhere
    banner: `/**
 * @license A dummy license banner that goes at the top of the file.
 * This is version v0.0.0-PLACEHOLDER
 */
`
  },
  plugins: [
    json({preferConst: true}),
  ],
};