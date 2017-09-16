# ethereum
Some simple steps to get started with geth.

# Setting Up
Install everything you need to interact with the Ethereum blockchain:
```
sudo apt-get install software-properties-common
sudo add-apt-repository -y ppa:ethereum/ethereum
sudo apt-get update
sudo apt-get install ethereum solc
```

Create a genesis file `genesis.json` in the working directory. You may want to set the difficulty close to 0 for faster mining.
```
{
  "config": {
    "chainId": 1907,
    "homesteadBlock": 0,
    "eip155Block": 0,
    "eip158Block": 0
  },
  "difficulty": "40",
  "gasLimit": "2100000",
  "alloc": {}
}
```

Create a new data directory for your first node, and launch the geth console:
```
mkdir node1
geth --datadir node1 init genesis.json
geth --datadir node1 console
```

Create your first account:
```
> personal.newAccount()
```

Simple commands in geth console:
```
> eth.coinbase // This will show your default address
> eth.accounts // Returns a list of addresses
> eth.getBalance(eth.coinbase)
> miner.start(1)
> miner.stop()
> personal.unlockAccount(eth.coinbase)
> eth.sendTransaction({from: eth.coinbase, to: eth.accounts[1], value: web3.toWei(3, "ether")}) // You need to mine this in order for transaction to be valid
> eth.hashrate // Check mining speed
```

Example contract `simple.sol`
```
pragma solidity ^0.4.13;

contract Simple {
  function arithmetics(uint _a, uint _b) returns (uint o_sum, uint o_product) {
    o_sum = _a + _b;
    o_product = _a * _b;
  }

  function multiply(uint _a, uint _b) returns (uint) {
    return _a * _b;
  }
}
```

Compile the contract:
```
# Compile into Simple.abi and Simple.bin
solc -o . --bin --abi simple.sol 
```

In the geth console, submit your contract:
```
> var simpleContract = eth.contract([{"constant":false,"inputs":[{"name":"_a","type":"uint256"},{"name":"_b","type":"uint256"}],"name":"multiply","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_a","type":"uint256"},{"name":"_b","type":"uint256"}],"name":"arithmetics","outputs":[{"name":"o_sum","type":"uint256"},{"name":"o_product","type":"uint256"}],"payable":false,"stateMutability":"nonpayable","type":"function"}])
```

You may need to unlock your account before the next step:
```
> personal.unlockAccount(eth.coinbase)
```

Prefix the contents of `Simple.bin` with `0x`, and assign to `simple.data`:
```
> var simple = simpleContract.new({from: eth.coinbase, data: "0x6060604052341561000f57600080fd5b5b6101178061001f6000396000f30060606040526000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff168063165c4a161460475780638c12d8f0146084575b600080fd5b3415605157600080fd5b606e600480803590602001909190803590602001909190505060c8565b6040518082815260200191505060405180910390f35b3415608e57600080fd5b60ab600480803590602001909190803590602001909190505060d6565b604051808381526020018281526020019250505060405180910390f35b600081830290505b92915050565b600080828401915082840290505b92509290505600a165627a7a7230582038f8b635def3c2c587b5b3f653637f12fec9a3f6e1bfb5921d9283f96506d51d0029", gas: 50000})
```

This contract would then need to be mined into the blockchain before its functions can be called.
```
> miner.start(1)
> miner.stop()
true
> simple.multiply
function()
> simple.multiply.call(4,5)
20
> simple.arithmetics.call(10,2)
[12, 20]
```

# References
[First steps with Ethereum Private Networks and Smart Contracts on Ubuntu 16.04](https://alanbuxton.wordpress.com/2017/07/19/first-steps-with-ethereum-private-networks-and-smart-contracts-on-ubuntu-16-04/)
