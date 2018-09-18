subscription=$1

# Make sure the subscription was passed in
if [ -z "$subscription" ]; then
  echo "Error: Please provide your Azure subscription name as first arguemnt."
  exit 1
fi

# remove the function app resources (service plan, storage, function app)
pushd ./resources
terraform destroy -target=azurerm_function_app.functionapp -auto-approve
terraform destroy -target=azurerm_storage_account.storage -auto-approve
terraform destroy -target=azurerm_app_service_plan.plan -auto-approve
popd

# deploy the resources again
source ./setup.sh "$subscription"

# sleep to make sure the environment is finished provisioning
echo "sleeping for 90s while the environment finishes provisioning."
echo "whithout this, the function app is unavailable when trying to upload source..."
sleep 90

config="./az.config"

# open config file and grab needed variables
funcapprg=$(cat $config | sed -n 1p)
funcappname=$(cat $config | sed -n 2p)

# zip the functions
if [ -d "./.build" ]; then
  rm -r "./.build"
fi
mkdir ./.build
pushd ./functionapp
pushd ./eventhubfunc
npm i
popd
zip -r ../.build/source.zip ./
popd

# upload the zip
echo "deploying function source to app..."
az functionapp deployment source config-zip \
  --resource-group $funcapprg \
  --name $funcappname \
  --src ./.build/source.zip

# restart function app
echo "restarting function app..."
az functionapp restart \
  --resource-group $funcapprg \
  --name $funcappname

echo "sleeping for 20 to make sure it's back up and running..."
sleep 20

# run test
echo "running the test (send EH event, wait for func to process it, check cosmos for it)..."
pushd ./test
npm i
output=$(node index.js)
echo $output
popd

# verify it didn't work
if [[ $output == *"TEST_FAIL"* ]]; then
  echo "The test failed..."
  echo "Please do the following steps:"
  echo "1. Open your browser, go to your azure portal."
  echo "2. Click on the 'eh-func-repro' resource group."
  echo "3. Open the 'db-eh-func-repro' cosmos resource, verify the Testing collection is empty."
  echo "4. Open the 'funcapp-eh-func-repro' resource."
  echo "5. Click on the 'eventhubfunc' function. This will wake up the function, and will now process the eventhub message that was sent."
  echo "6. Go back to the cosmos data explorer, and now you can see the event in the collection."
else
  echo "The test succeeded. This isn't supposed to happen."
fi

echo "NOTE: If you'd like to rerun this scenario manually, please just run 'node index.js' from within the test directory."
