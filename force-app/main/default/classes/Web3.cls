public with sharing class Web3 {
    public Web3() {
        // Constructor logic for initializing Web3
    }

    public void manageUserInteraction(String userId, String action) {
        // Logic to manage user interactions with web3 technologies
    }

    public static List<Balance__c> updateBalances(List<Wallet__c> wallets) {
        List<Balance__c> balances = new List<Balance__c>();
        List<Balance__c> balancesToUpsert = new List<Balance__c>();
        Set<Id> walletIds = new Set<Id>();
        for (Wallet__c wallet : wallets) {
            try {
                // Fetch balances from Ethereum and Polygon
                Decimal ethereumBalance = fetchBalanceFromBlockchain(wallet.Address__c, 'Ethereum');
                Decimal polygonBalance = fetchBalanceFromBlockchain(wallet.Address__c, 'Polygon');

                balances.add(new Balance__c(WalletAddress__c = wallet.Id, Blockchain__c = 'Ethereum', Amount__c = ethereumBalance));
                balances.add(new Balance__c(WalletAddress__c = wallet.Id, Blockchain__c = 'Polygon', Amount__c = polygonBalance));
                walletIds.add(wallet.Id);
            } catch (Exception e) {
                System.debug('Error : ' + wallet.Address__c);
            }

        }
        if (balances.size() > 0) {
            // Query existing balances for the wallets
            Map<String, Map<String, Balance__c>> existingBalances = new Map<String, Map<String, Balance__c>>();
            for (Balance__c balance : [SELECT Id, Blockchain__c, Amount__c, WalletAddress__c FROM Balance__c WHERE WalletAddress__c IN :walletIds]) {
                if (!existingBalances.containsKey(balance.WalletAddress__c)) {
                    existingBalances.put(balance.WalletAddress__c, new Map<String, Balance__c>());
                }
                existingBalances.get(balance.WalletAddress__c).put(balance.Blockchain__c, balance);
            }
            for (Balance__c balance : balances) {
                if(balance.Blockchain__c == 'Ethereum') {
                    if (existingBalances.containsKey(balance.WalletAddress__c) && existingBalances.get(balance.WalletAddress__c).containsKey('Ethereum')) {
                        Balance__c existingEthereumBalance = existingBalances.get(balance.WalletAddress__c).get('Ethereum');
                        existingEthereumBalance.Amount__c = balance.Amount__c;
                        balancesToUpsert.add(existingEthereumBalance);
                    } else {
                        balancesToUpsert.add(balance);
                    }
                } else if(balance.Blockchain__c == 'Polygon'){
                    if (existingBalances.containsKey(balance.WalletAddress__c) && existingBalances.get(balance.WalletAddress__c).containsKey('Polygon')) {
                        Balance__c existingPolygonBalance = existingBalances.get(balance.WalletAddress__c).get('Polygon');
                        existingPolygonBalance.Amount__c = balance.Amount__c;
                        balancesToUpsert.add(existingPolygonBalance);
                    } else {
                        balancesToUpsert.add(balance);
                    }
                }
            }
            upsert balancesToUpsert;
        }
        return balancesToUpsert;
    }

    private static Decimal fetchBalanceFromBlockchain(String address, String blockchain) {
        BlockchainAPIConfig__mdt config = [SELECT Endpoint__c, API_Key__c FROM BlockchainAPIConfig__mdt WHERE Blockchain__c = :blockchain LIMIT 1];
        if (config == null) {
            return 0;
        }

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String endpoint = config.Endpoint__c.replace('{apikey}', config.API_Key__c);
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        String body = '{"jsonrpc":"2.0","method":"eth_getBalance","params":["' + address + '", "latest"],"id":1}';
        request.setBody(body);
        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200) {
            Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            if (blockchain == 'Ethereum' || blockchain == 'Polygon') {
                String balanceHex = (String) result.get('result');
                return hexToDecimal(balanceHex);
            }
        }
        return 0;
    }

    private static Decimal hexToDecimal(String hex) {
        if (String.isBlank(hex)) {
            throw new IllegalArgumentException('Hex string cannot be null or empty');
        }
        
        if (hex.startsWith('0x')) {
            hex = hex.substring(2); // Remove "0x" prefix if present
        }
        
        Decimal result = 0;
        String hexChars = '0123456789ABCDEF';
        hex = hex.toUpperCase(); // Normalize case
        
        for (Integer i = 0; i < hex.length(); i++) {
            String currentChar = hex.substring(i, i + 1);
            Integer digit = hexChars.indexOf(currentChar);
            
            if (digit == -1) {
                throw new IllegalArgumentException('Invalid hex character: ' + currentChar);
            }
            
            result = result * 16 + digit;
        }
        // Convert to Ethereum amount (divide by 10^18)
        result = result / Math.pow(10, 18);
        
        // Round to 18 decimal places
        result = result.setScale(18, System.RoundingMode.HALF_UP);
        return result;
    }
    
}