trigger Web3Trigger on Wallet__c (before insert, before update, after insert, after update) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            // Logic for handling before insert
        } else if (Trigger.isUpdate) {
            // Logic for handling before update
        }
    } else if (Trigger.isAfter) {
        if (Trigger.isInsert || Trigger.isUpdate) {
            // Enqueue the queueable class to perform the callout asynchronously
            //System.enqueueJob(new UpdateBalancesQueueable(Trigger.new));
        }
    }
}