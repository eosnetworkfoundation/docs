// checks if any of the file names contains something besides a hypen (underscore, space, etc)

const getAllDocs = require('./get-all-docs');

const checkNames = () => {
    const docPaths = getAllDocs();
    let filesWithUnderscores = [];

    for(let filePath of docPaths){
        const fileName = filePath.split('/').pop();
        if(fileName.split('').filter(x => x === '_').length > 1){
            filesWithUnderscores.push(fileName);
        }
    }

    if(filesWithUnderscores.length > 0){
        throw new Error(`Files contains an underscore: ${JSON.stringify(filesWithUnderscores, null, 2)}`);
    }


    // console.log(docPaths);
}

checkNames();
