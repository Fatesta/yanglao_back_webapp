const { generate } = require('./generate-pages');

function PageDog(options) {}

PageDog.prototype.apply = (compiler) => {
  compiler.plugin('compile', () => {
    generate();
  });
};

module.exports = PageDog;