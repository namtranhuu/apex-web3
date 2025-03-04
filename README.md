# Apex Web3 App

This project demonstrates how to connect Web3 data to Salesforce objects (Account, Contact, Lead) using Apex.

## Manually create metadata types for the app config
[Custom metadata Types](https://trailhead.salesforce.com/content/learn/modules/custom_metadata_types_dec/cmt_create)

![Create Custom Metadata](https://github.com/namtranhuu/apex-web3/blob/main/create-custom-metadata-types.png?raw=true)

## Installing the app using a Scratch Org

1. Set up your environment. Follow the steps in the [Quick Start: Lightning Web Components](https://trailhead.salesforce.com/content/learn/projects/quick-start-lightning-web-components/) Trailhead project. The steps include:

    - Enable Dev Hub in your Trailhead Playground
    - Install Salesforce CLI
    - Install Visual Studio Code
    - Install the Visual Studio Code Salesforce extensions

1. If you haven't already done so, authorize with your hub org and provide it with an alias (**myhuborg** in the command below):

    ```
    sf org login web -d -a myhuborg
    ```
2. Clone the apex-web3 repository:

    ```
    git clone https://github.com/namtranhuu/apex-web3
    cd apex-web3
    ```

3. Create a scratch org and provide it with an alias (**apex-web3** in the command below):

    ```
    sf org create scratch -d -f config/project-scratch-def.json -a apex-web3
    ```

4. Push the app to your scratch org:

    ```
    sf project deploy start
    ```

5. Assign the permission set to your user:
    ```sh
     sf org assign permset -n Apex_Web3
    ```

6. Open the scratch org:
    ```sh
    sf org open
    ```

## Developer Edition
If you are setting up a Developer Edition: go to **Setup**, under **Platform Cache**, and click the "Request Trial Capacity" button. [Request a Platform Cache Trial](https://help.salesforce.com/articleView?id=data_platform_cache_trial.htm&type=5)


1. If you haven't already done so, authorize with your hub org and provide it with an alias (**myhuborg** in the command below):

    ```
    sf org login web -d -a myhuborg
    ```
2. Clone the apex-web3 repository:

    ```
    git clone https://github.com/trailheadapps/apex-recipes
    cd apex-web3
    ```

3. Run this command in a terminal to deploy the app.

    ```
    sf project deploy start -d force-app
    ```

4. Assign the `Apex_Web3` permission set to the default user.

    ```
    sf org assign permset -n Apex_Web3
    ```
## Update Infura API keys for app config

[You can get API key here](https://www.infura.io/)

![Create Custom Metadata](https://github.com/namtranhuu/apex-web3/blob/main/api_keys.png?raw=true)

## Add remote sites to allow requests sent to infura API endpoint

![Remote Sites](https://github.com/namtranhuu/apex-web3/blob/main/remote-sites.png?raw=true)

## Edit Contact,Lead,Account page tempaltes. Add Web3 Container

![Edit Page Template](https://github.com/namtranhuu/apex-web3/blob/main/edit-page-template.png?raw=true)

![Add Web3 Container](https://github.com/namtranhuu/apex-web3/blob/main/web3Container.png?raw=true)
