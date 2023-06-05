const path = require("path");
const fs = require("fs");

const dir = `./docs`;

const getAllDocs = () => {
    let files = [];
    const iterateFiles = (_files, _path = "") => {
        _files.map(file => {
            if(!path.extname(file)){
                iterateFiles(fs.readdirSync(path.join(dir, _path, file)), _path + '/' + file);
            }
            else if(path.extname(file) === '.md'){
                files.push(path.normalize(path.join(dir, _path, file)).replace(/\\/g, '/'));
            }
        });
    }

    iterateFiles(fs.readdirSync(dir));

    return files;
}

module.exports = getAllDocs;
