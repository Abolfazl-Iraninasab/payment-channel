# @version ^0.2.0

# a payment channel between 2 parties : receiver and sender 

receiver: public(address)
sender: public(address)


@external
@payable
def __init__(_receiver: address):
    self.receiver = _receiver
    self.sender = msg.sender

 
@internal
@pure
def _msgHash(_amount: uint256) -> bytes32:
    return keccak256(concat(
        convert(self, bytes32),
        convert(_amount, bytes32) 
    ))


@external
@view
def msgHash(_amount: uint256) -> bytes32:
    return self._msgHash(_amount)
  

@internal
@view
def _ethMsgHash(_amount: uint256) -> bytes32:
    hash: bytes32 = self._msgHash(_amount)
    return keccak256(
        concat(
            b'\x19Ethereum Signed Message:\n32',
            hash
        )
    )


@external
@view
def ethMsgHash(_amount: uint256) -> bytes32:
    return self._ethMsgHash(_amount)


@internal
@view
def _sigVerify(_amount: uint256, _sig: Bytes[65]) -> bool:
    ethSignedMsg: bytes32 = self._ethMsgHash(_amount)

    #  first we should split the signature into 3 parts :
    #  r and s are cryptographic parameters used for digital signature

    r: uint256 = convert(slice(_sig, 0, 32), uint256)
    s: uint256 = convert(slice(_sig, 32, 32), uint256)
    v: uint256 = convert(slice(_sig, 64, 1), uint256)

    # ecrecover() is a built-in function that returns the address of signer :
    return ecrecover(ethSignedMsg, v, r, s) == self.sender


@external
@view
def sigVerify(_amount: uint256, _sig: Bytes[65]) -> bool:
    return self._sigVerify(_amount, _sig)


@nonreentrant("ethWithdrawal")                 # secured against reentrancy attack
@external
def end(_amount: uint256, _sig: Bytes[65]):
    assert msg.sender == self.receiver, "only receiver can execute this function "
    assert self._sigVerify(_amount, _sig), "invalid signature"
    assert self.balance >= _amount, "insufficient contract balance"

    # send Ether to user
    raw_call(self.receiver, b'\x00', value=_amount)

    # send remaining Eth to owner and delete the contract 
    selfdestruct(self.sender)     
    


