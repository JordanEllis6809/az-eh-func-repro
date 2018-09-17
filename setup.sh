# NOTE: Run this script from within its directory

subscription=$1

# Make sure the subscription was passed in
if [ -z "$subscription" ]; then
  echo "Error: Please provide your Azure subscription name as first arguemnt."
  exit 1
fi

# Make sure terraform exists
if ! type terraform > /dev/null; then
  echo "Error: Please insteall terraform."
  exit 2
fi

# Login and set sub
az login
az account set --subscription "$1"

# Terraform init & apply our resources
pushd ./resources
  terraform init
  output=$(terraform apply -auto-approve -no-color | tee /dev/tty)
popd

# Get variables from output
dbresourcegroup=$(echo $output | grep -P -o "(?<=cosmos-db-resourcegroup = )([^\s|^^]+)")
dbconnection=$(echo $output | grep -P -o "(?<=cosmos-db-connection = )([^\s|^^]+)")
dbendpoint=$(echo $output | grep -P -o "(?<=cosmos-db-endpoint = )([^\s|^^]+)")
dbaname=$(echo $output | grep -P -o "(?<=cosmos-db-account-name = )([^\s|^^]+)")
dbcollection=$(echo $output | grep -P -o "(?<=cosmos-db-collection = )([^\s|^^]+)")
dbname=$(echo $output | grep -P -o "(?<=cosmos-db-name = )([^\s|^^]+)")
dbkey=$(echo $output | grep -P -o "(?<=cosmos-db-key = )([^\s|^^]+)")
ehnamespace=$(echo $output | grep -P -o "(?<=eventhub-namespace = )([^\s|^^]+)")
ehtestingconnection=$(echo $output | grep -P -o "(?<=eventhub-testing-conneciton = )([^\s|^^]+)")
ehtesting=$(echo $output | grep -P -o "(?<=eventhub-testing = )([^\s|^^]+)")
funcappname=$(echo $output | grep -P -o "(?<=function-app-name = )([^\s|^^]+)")
funcapprg=$(echo $output | grep -P -o "(?<=function-app-resourcegroup = )([^\s|^^]+)")

# sleep to make sure the environment is finished provisioning
sleep 20

# create the cosmos db & collection
az cosmosdb database create \
  --resource-group-name $dbresourcegroup \
  --name $dbaname \
  --db-name $dbname

az cosmosdb collection create \
  --resource-group-name $dbresourcegroup \
  --name $dbaname \
  --db-name $dbname \
  --collection-name $dbcollection \
  --throughput 1000

# TODO: save what's needed to .config file
# db connection string?
# function app name
# that it?
