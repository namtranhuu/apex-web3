# Web3Controller Class

## Methods
### `getWallets(recordId)`

`AURAENABLED`

#### Signature
```apex
public static List<Wallet__c> getWallets(Id recordId)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| recordId | Id |  |

#### Return Type
**List&lt;Wallet__c&gt;**

---

### `createWallet(recordId, address)`

`AURAENABLED`

#### Signature
```apex
public static Wallet__c createWallet(Id recordId, String address)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| recordId | Id |  |
| address | String |  |

#### Return Type
**Wallet__c**

---

### `updateBalances(recordId)`

`AURAENABLED`

#### Signature
```apex
public static List<Balance__c> updateBalances(Id recordId)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| recordId | Id |  |

#### Return Type
**List&lt;Balance__c&gt;**