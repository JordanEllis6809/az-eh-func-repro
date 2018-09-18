# Azure EventHub + Function Repro  
I've encountered a slew of problems when trying to develop CI/CD involving Azure Functions being triggered by EventHubs. This repo aims to create a slim vertical slice demonstrating this problem, so Azure developers can hopefully investigate further.  

## Bug Seen  
With a fresh deployment of your Azure resources, and a fresh upload of your Azure Function's source via zip upload, the Function is not triggered & run when events are sent through the event hub.  

## Manual Fix  
If you visit the webpage for the Azure Function, it seems to wake up the function, which then prompts it to start processing the messages in the queue. The repro steps below will take you through this.  

## Repro Overview  
In the following steps below, it'll take you through setting up a fresh Azure environment. This environment is meant to be a simple event injestion pipeline (EventHub -> Function -> CosmosDB). Once stood up, events are sent to the EventHub. The Function at this point should be triggered, and it will injest the event into CosmosDB. We then check for their existance in CosmosDB from the test. If the function is processing properly, the event will be seen in the DB. If the bug repros, the event will still be in the EventHub queue and not in CosmosDB.  

## Steps To Repro  
1. `./setup {azure_subscription}`  
    * Deploys all azure resources (RG, CosmosDB, EventHub, FunctionApp).  
    * Creates CosmosDB database & collection.  
    * Saves configuration values (ex: connection strings) for other scripts to use.  
2. `./repro {azure_subscription}`  
    * [May be unneeded] destroys & redeploys the Function's resources to Azure.  
    * Uploads the Function's source via the `az functionapp deployment source config-zip` CLI command.  
    * Restarts the Function's app.  
    * Runs the test/index.js script, which sends events to EventHub and checks for their existance in CosmosDB.  
    * Upon failure, it tells you how to manually wake the function which will make the event show up in CosmosDB.  
3. `./teardown.sh {azure_subscription}`  
    * Tears down the environment stood up in the `./setup ...` step.  
