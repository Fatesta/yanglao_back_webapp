const process = require('child_process');

const basePath = '/Users/hulang/Documents/workspace/hbManager/src/main/webapp';
process.exec(`rm -rf ${basePath}/*.js ${basePath}/*.css ${basePath}/*.html ${basePath}/*.woff ${basePath}/*.ttf ${basePath}/assets`);
process.exec(`cp -r dist/* ${basePath}`);