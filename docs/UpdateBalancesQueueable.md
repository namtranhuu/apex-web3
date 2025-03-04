# UpdateBalancesQueueable Class

**Implements**

Queueable, 
Database.AllowsCallouts

## Fields
### `wallets`

#### Signature
```apex
private wallets
```

#### Type
List&lt;Wallet__c&gt;

## Constructors
### `UpdateBalancesQueueable(wallets)`

#### Signature
```apex
public UpdateBalancesQueueable(List<Wallet__c> wallets)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| wallets | List&lt;Wallet__c&gt; |  |

## Methods
### `execute(context)`

#### Signature
```apex
public void execute(QueueableContext context)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| context | QueueableContext |  |

#### Return Type
**void**