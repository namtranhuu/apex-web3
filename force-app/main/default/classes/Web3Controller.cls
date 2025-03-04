public with sharing class Web3Controller {
    // Get all wallets + balances for a Contact, Account, or Lead
    @AuraEnabled(cacheable=true)
    public static List<Wallet__c> getWallets(Id recordId) {
        if (recordId == null) {
            throw new IllegalArgumentException('recordId cannot be null');
        }
        String sObjectType = recordId.getSObjectType().getDescribe().getName();
        String fieldName;
        
        if (sObjectType == 'Contact') {
            fieldName = 'Contact__c';
        } else if (sObjectType == 'Account') {
            fieldName = 'Account__c';
        } else if (sObjectType == 'Lead') {
            fieldName = 'Lead__c';
        } else {
            throw new IllegalArgumentException('Unsupported sObject type: ' + sObjectType);
        }

        String query = 'SELECT Id, Name, Address__c, Account__c, Contact__c, Lead__c, ' +
                       '(SELECT Blockchain__c, Amount__c, Name FROM WalletBalance__r) ' +
                       'FROM Wallet__c WHERE ' + fieldName + ' = :recordId ORDER BY CreatedDate DESC';
        return Database.query(query);
    }

    // Create new wallet for Contact, Account, or Lead
    @AuraEnabled
    public static Wallet__c createWallet(Id recordId, String address) {
        if (recordId == null || String.isBlank(address)) {
            throw new IllegalArgumentException('recordId and address are required');
        }
        String sObjectType = recordId.getSObjectType().getDescribe().getName();
        String fieldName;
        
        if (sObjectType == 'Contact') {
            fieldName = 'Contact__c';
        } else if (sObjectType == 'Account') {
            fieldName = 'Account__c';
        } else if (sObjectType == 'Lead') {
            fieldName = 'Lead__c';
        } else {
            throw new IllegalArgumentException('Unsupported sObject type: ' + sObjectType);
        }
        // Check if a wallet with the same address already exists for the given Contact
        String query = 'SELECT Id FROM Wallet__c WHERE ' + fieldName + ' = :recordId AND Address__c = :address LIMIT 1';
        List<Wallet__c> existingWallets = Database.query(query);
        if (!existingWallets.isEmpty()) {
            throw new IllegalArgumentException('A wallet with this address already exists for the given ' + sObjectType);
        }

        Wallet__c wallet = new Wallet__c();
        wallet.put(fieldName, recordId);
        wallet.Address__c = address;
        try {
            insert wallet;
        } catch (DmlException e) {
            System.debug('Error inserting Wallet__c record: ' + e.getMessage());
            throw e;
        }
        return wallet;
    }

    // Sync Balances Contact, Account, or Lead
    @AuraEnabled
    public static List<Balance__c> updateBalances(Id recordId) {
        if (recordId == null) {
            throw new IllegalArgumentException('recordId is required');
        }
        List<Wallet__c> wallets = getWallets(recordId);
        if (wallets.size() > 0) {
            return Web3.updateBalances(wallets);
        }
        return new List<Balance__c>();
    }
}