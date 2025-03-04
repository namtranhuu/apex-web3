@isTest
public class Web3Test {
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

        // Create custom metadata records for BlockchainAPIConfig__mdt
        BlockchainAPIConfig__mdt ethereumConfig = new BlockchainAPIConfig__mdt(
            MasterLabel = 'Ethereum',
            Blockchain__c = 'Ethereum',
            Endpoint__c = 'https://mainnet.infura.io/v3/{apikey}',
            API_Key__c = 'test-api-key'
        );
        insert ethereumConfig;

        BlockchainAPIConfig__mdt polygonConfig = new BlockchainAPIConfig__mdt(
            MasterLabel = 'Polygon',
            Blockchain__c = 'Polygon',
            Endpoint__c = 'https://polygon-mainnet.infura.io/v3/{apikey}',
            API_Key__c = 'test-api-key'
        );
        insert polygonConfig;
    }

    @isTest
    static void testUpdateBalances() {
        // Query test wallets
        List<Wallet__c> testWallets = [SELECT Id, Address__c FROM Wallet__c];

        // Call the updateBalances method
        Test.startTest();
        List<Balance__c> updatedBalances = Web3.updateBalances(testWallets);
        Test.stopTest();

        // Verify the results
        System.assertNotEquals(0, updatedBalances.size(), 'Balances should be updated');
        for (Balance__c balance : updatedBalances) {
            System.assertNotEquals(0, balance.Amount__c, 'Balance amount should be updated');
        }
    }

    @isTest
    static void testFetchBalanceFromBlockchain() {
        // Call the fetchBalanceFromBlockchain method
        Test.startTest();
        Decimal ethereumBalance = Web3.fetchBalanceFromBlockchain('0x1234567890abcdef1234567890abcdef12345678', 'Ethereum');
        Decimal polygonBalance = Web3.fetchBalanceFromBlockchain('0xabcdef1234567890abcdef1234567890abcdef12', 'Polygon');
        Test.stopTest();

        // Verify the results
        System.assertNotEquals(0, ethereumBalance, 'Ethereum balance should be fetched');
        System.assertNotEquals(0, polygonBalance, 'Polygon balance should be fetched');
    }

    @isTest
    static void testHexToDecimal() {
        // Call the hexToDecimal method
        Decimal result = Web3.hexToDecimal('0x1bc16d674ec80000');

        // Verify the result
        System.assertEquals(2, result, 'Hex to decimal conversion should be correct');
    }
}