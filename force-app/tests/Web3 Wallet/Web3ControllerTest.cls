@isTest
public class Web3ControllerTest {
    @testSetup
    static void setup() {
        // Create test data
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Contact testContact = new Contact(FirstName = 'Test', LastName = 'Contact', AccountId = testAccount.Id);
        insert testContact;

        Wallet__c testWallet1 = new Wallet__c(Contact__c = testContact.Id, Address__c = '0x1234567890abcdef1234567890abcdef12345678');
        Wallet__c testWallet2 = new Wallet__c(Contact__c = testContact.Id, Address__c = '0xabcdef1234567890abcdef1234567890abcdef12');
        insert testWallet1;
        insert testWallet2;
    }

    @isTest
    static void testGetWallets() {
        // Query test contact
        Contact testContact = [SELECT Id FROM Contact LIMIT 1];

        // Call the getWallets method
        Test.startTest();
        List<Wallet__c> wallets = Web3Controller.getWallets(testContact.Id);
        Test.stopTest();

        // Verify the results
        System.assertNotEquals(0, wallets.size(), 'Wallets should be returned');
    }

    @isTest
    static void testCreateWallet() {
        // Query test contact
        Contact testContact = [SELECT Id FROM Contact LIMIT 1];

        // Call the createWallet method
        Test.startTest();
        Wallet__c newWallet = Web3Controller.createWallet(testContact.Id, '0xabcdefabcdefabcdefabcdefabcdefabcdefabcdef');
        Test.stopTest();

        // Verify the results
        System.assertNotEquals(null, newWallet.Id, 'New wallet should be created');
        System.assertEquals('0xabcdefabcdefabcdefabcdefabcdefabcdefabcdef', newWallet.Address__c, 'Wallet address should match');
    }

    @isTest
    static void testCreateWalletDuplicate() {
        // Query test contact
        Contact testContact = [SELECT Id FROM Contact LIMIT 1];

        // Call the createWallet method with a duplicate address
        Test.startTest();
        try {
            Web3Controller.createWallet(testContact.Id, '0x1234567890abcdef1234567890abcdef12345678');
            System.assert(false, 'Exception should be thrown for duplicate wallet address');
        } catch (IllegalArgumentException e) {
            System.assertEquals('A wallet with this address already exists for the given Contact', e.getMessage(), 'Exception message should match');
        }
        Test.stopTest();
    }

    @isTest
    static void testUpdateBalances() {
        // Query test contact
        Contact testContact = [SELECT Id FROM Contact LIMIT 1];

        // Call the updateBalances method
        Test.startTest();
        List<Balance__c> updatedBalances = Web3Controller.updateBalances(testContact.Id);
        Test.stopTest();

        // Verify the results
        System.assertNotEquals(0, updatedBalances.size(), 'Balances should be updated');
        for (Balance__c balance : updatedBalances) {
            System.assertNotEquals(0, balance.Amount__c, 'Balance amount should be updated');
        }
    }
}