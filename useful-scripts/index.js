const pinataSDK = require('@pinata/sdk');
const dotenv = require('dotenv');
const fs = require('fs');

const pinata = pinataSDK(dotenv.config().parsed.API_KEY, dotenv.config().parsed.API_SECRET);

var allMetadata = [];
var imageHashes = [];
var metadataHashes = [];

let randomAmount = 3;
let topAmount = 3;
let projectName = "Random Charity"


async function clear() {
    const metadataFilter = {
        name: 'logo',
    };
    const filters = {
        status: 'pinned',
        pageLimit: 100,
        pageOffset: 0,
        metadata: metadataFilter
    };
    //Get all data
    await pinata.pinList(filters).then(async (result) => {
        console.log(result);
        for (let i = 0; i < result.rows.length; i++) {
            //Remove from pinata
            await pinata.unpin(result.rows[i].ipfs_pin_hash).then(async (result) => {
                console.log(result);
            }).catch((err) => {
                console.log(err);
            });
        }
    }).catch((err) => {
        console.log(err);
    });
}

async function publish(_name, _description) {
    //publish image
    const readableStreamForFile = fs.createReadStream('./logo.jpg'); // TODO: replace with custom image
    const options = {
        pinataMetadata: {
            name: "logo",
        },
        pinataOptions: {
        }
    };
    await pinata.pinFileToIPFS(readableStreamForFile, options).then(async (result) => {
        console.log(result);

        imageHashes.push(result.IpfsHash);

        //publish metadata
        var metadata = {
            "name": _name,
            "description": _description,
            "external_url": "endevr.io",
            "image": `ipfs://${result.IpfsHash}`,
            "attributes": []
        }
        allMetadata.push(metadata);
        const metadataOptions = {
            pinataMetadata: {
                name: _name,
            },
            pinataOptions: {
            }
        };
        await pinata.pinJSONToIPFS(metadata, metadataOptions).then(async (result) => {
            //handle results here
            console.log(result);
            metadataHashes.push(result.IpfsHash);
        }).catch((err) => {
            //handle error here
            console.log(err);
        });


    }).catch((err) => {
        //handle error here
        console.log(err);
    });
}

async function publishAll() {

    for (let i = 0; i < randomAmount; i++) {
        await publish(`${projectName} - Lucky donator #${i + 1}`, `Randomly chose donator for ${projectName} who donated on endevr.io`)
    }

    for (let i = 0; i < topAmount; i++) {
        await publish(`${projectName} - Biggest donator #${i + 1}`, `#${i + 1} biggest donator for ${projectName} who donated on endevr.io`)
    }

}



async function main() {

    //await clear();
    await publishAll();


    console.log("Data output:")
    console.log(allMetadata);
    console.log(imageHashes);
    console.log(metadataHashes);

}


main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });