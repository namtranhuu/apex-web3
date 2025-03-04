@isTest
public class UpdateBalancesQueueableTest {
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
    static void testExecute() {
        // Query test wallets
        List<Wallet__c> testWallets = [SELECT Id, Address__c FROM Wallet__c];

        // Enqueue the UpdateBalancesQueueable job
        Test.startTest();
        ID jobId = System.enqueueJob(new UpdateBalancesQueueable(testWallets));
        Test.stopTest();

        // Verify the results
        // You can query the Balance__c records to verify that they have been updated
        List<Balance__c> updatedBalances = [SELECT Id, Amount__c, Blockchain__c, WalletAddress__c FROM Balance__c WHERE WalletAddress__c IN :testWallets];
        System.assertNotEquals(0, updatedBalances.size(), 'Balances should be updated');
        for (Balance__c balance : updatedBalances) {
            System.assertNotEquals(0, balance.Amount__c, 'Balance amount should be updated');
        }
    }
}