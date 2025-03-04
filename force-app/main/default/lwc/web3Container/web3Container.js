import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import getWallets from '@salesforce/apex/Web3Controller.getWallets';
import createWallet from '@salesforce/apex/Web3Controller.createWallet';
import updateBalances from '@salesforce/apex/Web3Controller.updateBalances';

export default class Web3Container extends LightningElement {
    @api recordId; // Contact/Lead/Account ID
    wallets = [];
    newWalletAddress = '';
    wiredWalletsResult;
    loaded = false;

    @wire(getWallets, { recordId: '$recordId' })
    wiredWallets(result) {
        console.log(result);
        this.wiredWalletsResult = result;
        let { data, error } = result;
        if(!data?.length){
            data = [];
        }
        if (data) {
            this.wallets = data;
        } else if (error) {
            alert('Error fetching wallets:' + JSON.stringify(error));
        }
        this.loaded = true;
    }

    @api
    async addWallet() {
        this.loaded = false;
        try {
            const validated = this.newWalletAddress?.length == 42 && this.newWalletAddress?.match(/(\b0x[a-f0-9]{40}\b)/g);
            if(validated){
                await createWallet({ recordId: this.recordId, address: this.newWalletAddress });
                await updateBalances({ recordId: this.recordId });
                refreshApex(this.wiredWalletsResult)
                    .then(() => {
                        // Optionally, you can perform additional actions after the refresh
                        console.error('Wallets refreshed successfully');
                    })
                    .catch(error => {
                        console.error('Error refreshing wallets:', error);
                    });
            } else {
                alert('Invalid wallet address');
            }
        }  catch (error) {
            alert('An error occurred when adding wallet address');
        }
        this.loaded = true;
    }

    handleInputChange(event) {
        if (event.target.name === 'newWalletAddress') {
            this.newWalletAddress = event.target.value?.toLowerCase();
        }
    }
}