public class UpdateBalancesQueueable implements Queueable, Database.AllowsCallouts {
    private List<Wallet__c> wallets;

    public UpdateBalancesQueueable(List<Wallet__c> wallets) {
        this.wallets = wallets;
    }

    public void execute(QueueableContext context) {
        Web3.updateBalances(wallets);
    }
}