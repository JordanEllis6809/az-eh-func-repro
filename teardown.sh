subscription=$1

# Make sure the subscription was passed in
if [ -z "$subscription" ]; then
  echo "Error: Please provide your Azure subscription name as first arguemnt."
  exit 1
fi

# Login and set sub
az login
az account set --subscription "$1"

pushd ./resources
terraform destroy -auto-approve
popd