require("dotenv").config();

var EventHubClient = require("@azure/event-hubs").EventHubClient;
const envEhConnectionString = "EH_CONNECTIONSTRING";
const envEhEntityPath = "EH_NAME";
const ehConnectionString = process.env[envEhConnectionString] || "";
const ehEntityPath = process.env[envEhEntityPath] || "";

var DocumentClient = require("documentdb").DocumentClient;
const envDbHost = "DB_ENDPOINT";
const envDbKey = "DB_KEY";
const envDbName = "DB_NAME";
const envDbColName = "DB_COLLECTION";
const dbHost = process.env[envDbHost] || "";
const dbKey = process.env[envDbKey] || "";
const dbName = process.env[envDbName] || "";
const dbColName = process.env[envDbColName] || "";
const dbLink = "dbs/" + dbName;
const dbColLink = dbLink + "/colls/" + dbColName;

const uuidv4 = require("uuid/v4");

function sleep (time) {
  return new Promise((resolve) => setTimeout(resolve, time));
}

(async () => {
  var ehClient = EventHubClient.createFromConnectionString(
    ehConnectionString, ehEntityPath
  );

  var dbClient = new DocumentClient(dbHost, { masterKey: dbKey });

  var id = uuidv4();

  console.log("uuid = " + id);

  var data = {
    body: {
      uuid: id
    }
  };

  await ehClient.send(data);

  // Wait to make sure the event makes its way
  // through the function and into cosmos
  await sleep(35000);

  // Query for the GUID in cosmos
  var querySpec = {
    query: "SELECT * FROM c WHERE c.uuid = @uuid",
    parameters: [
      {
        name: "@uuid",
        value: id
      }
    ]
  };

  var iterator = dbClient.queryDocuments(dbColLink, querySpec);

  await iterator.toArray((err, results) => {
    if (err) {
      assert.fail(JSON.stringify(err, null, 2));
    }

    var length = results.length;

    if (length > 0)
    {
      console.log("TEST_SUCCESS");
    }
    else
    {
      console.log("TEST_FAIL");
    }

    process.exit();
  });
})()
  .catch(err => console.log("error: ", err));
