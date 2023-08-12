const { DefaultAzureCredential } = require("@azure/identity");
const { BlobServiceClient } = require("@azure/storage-blob");

module.exports = async function(context, req) {
    const account = process.env["STORAGE_ACCOUNT_NAME"];
    const containerName = process.env["CONTAINER_NAME"];
    const blobName = process.env["BLOB_NAME"];

    const url = `https://${account}.blob.core.windows.net`;
    const credential = new DefaultAzureCredential();
    const blobServiceClient = new BlobServiceClient(url, credential);
    const containerClient = blobServiceClient.getContainerClient(containerName);
    const blobClient = containerClient.getBlobClient(blobName);

    let blobContent;
    try {
        const buffer = await blobClient.downloadToBuffer();
        blobContent = buffer.toString();
    } catch (error) {
        context.res = {
            status: 500,
            body: `Failed to retrieve blob content: ${error.message}`
        };
        return;
    }

    context.res = {
        body: blobContent,
        headers: {
            'Content-Type': 'text/html'
        }
    };
};