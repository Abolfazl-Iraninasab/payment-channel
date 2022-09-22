## **Decentralized payment system using vyper**

Payment channel enables stream of payments between 2 parties.

sender exchanges signatures offchain and receiver only needs to submitt a single transaction to finalize the payments.

### **sign a transaction message using** `msgHash( _amount )` **and MetaMask :**

1) deploy the contract and get the hash of your message with function below : 
```
msgHash(_amount)
```

open browser console and then :

2) assign MsgHash with the value of msgHash(_amount) 
```
    MsgHash =  
```

3) enable metamask:
```
    ethereum.enable()  
```

4) get connected account of your metamask :
```
ethereum.request({ method: 'eth_requestAccounts' }).then(function (accounts) {  
    CurrentAccount = accounts[0];  
    console.log('current account: ' + CurrentAccount); 
}); 
```

5) send a request to sign the message with metamask : 
```
    ethereum.request({method : "personal_sign" , params : [CurrentAccount, MsgHash]})  
```

