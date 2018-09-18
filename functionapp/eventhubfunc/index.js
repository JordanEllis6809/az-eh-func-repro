var DocumentClient = require("documentdb").DocumentClient;

const host = process.env["DB_ENDPOINT"];
const key = process.env["DB_KEY"];
const databaseName = process.env["DB_NAME"];
const collectionName = process.env["DB_COLLECTION"];

const client = new DocumentClient(host, { masterKey: key });
const dbLink = "dbs/" + databaseName;
const collLink = dbLink + "/colls/" + collectionName;

module.exports = function (context, eventHubMessages) {

  eventHubMessages.forEach(message => {
    context.log(`Processed message: ${JSON.stringify(message)}`);
    client.createDocument(collLink, message);
  }).then(() => context.done() );
};
