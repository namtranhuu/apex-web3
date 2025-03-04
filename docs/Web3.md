# Web3 Class

## Constructors
### `Web3()`

#### Signature
```apex
public Web3()
```

## Methods
### `manageUserInteraction(userId, action)`

#### Signature
```apex
public void manageUserInteraction(String userId, String action)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| userId | String |  |
| action | String |  |

#### Return Type
**void**

---

### `updateBalances(wallets)`

#### Signature
```apex
public static List<Balance__c> updateBalances(List<Wallet__c> wallets)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| wallets | List&lt;Wallet__c&gt; |  |

#### Return Type
**List&lt;Balance__c&gt;**

---

### `fetchBalanceFromBlockchain(address, blockchain)`

#### Signature
```apex
private static Decimal fetchBalanceFromBlockchain(String address, String blockchain)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| address | String |  |
| blockchain | String |  |

#### Return Type
**Decimal**

---

### `hexToDecimal(hex)`

#### Signature
```apex
private static Decimal hexToDecimal(String hex)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| hex | String |  |

#### Return Type
**Decimal**