// checks if any of the file names contains something besides a hypen (underscore, space, etc)

const getAllDocs = require('./get-all-docs');
const fs = require('fs');
const yaml = require('js-yaml');

const getProperties = (doc) => {
    // get everything between the first set of --- and the second set of ---
    const frontMatter = doc.match(/---([\s\S]*?)---/)[1];
    if(!frontMatter) return {};
    return yaml.load(frontMatter);
};

const checkContributors = (dir) => {
    const docPaths = getAllDocs(dir);
    let invalidContributorDocs = [];

    for(let filePath of docPaths){
        // check each document to see if front matter has properly formatted contributors
        const doc = fs.readFileSync(filePath, 'utf8');
        const properties = getProperties(doc);
        if(properties && properties.contributors){
            for(let contributor of properties.contributors){
                if(!contributor.name || !contributor.name.length){
                    invalidContributorDocs.push({
                        filePath,
                        reason: 'name',
                        contributor
                    });
                }

                if(!contributor.github || !contributor.github.length){
                    invalidContributorDocs.push({
                        filePath,
                        reason: 'github',
                        contributor
                    });
                }
            }
        }
    }

    if(invalidContributorDocs.length > 0){
        for(let invalidDoc of invalidContributorDocs){
            console.log(`Invalid contributor in ${invalidDoc.filePath}: invalid ${invalidDoc.reason} -- ${JSON.stringify(invalidDoc.contributor)}`);
        }
    }


    // console.log(docPaths);
}

checkContributors('./native');
checkContributors('./evm');
