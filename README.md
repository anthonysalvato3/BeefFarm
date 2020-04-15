<b>Contract address:</b> 0x7f1f398FBc3Ff44F8ee9B0D8Db4e121087C55290
<br>
<b>Transaction hash:</b> 0x9c933030e0ed5be5ebab8d7ce76f01d4cb1c5bf5fe9c54c5e0bb14b89497cb76
<br>
<b>Libraries used:</b> truffle, mocha/chai, web3js, truffle-assertions
<br>
<b>Versions:</b>
<ul>
  <li>Truffle v5.1.14-nodeLTS.0 (core: 5.1.13)</li>
  <li>Solidity v0.5.16 (solc-js)</li>
  <li>Node v12.16.1</li>
  <li>Web3.js v1.2.1</li>
</ul>
<body>
  The truffle-assertions libary is used to easily test that events are emitted.
</body>

### Installing

Clone this repository:

```
git clone https://github.com/anthonysalvato3/beeffarm.git
```

Change directory to ```project-6``` folder and install all requisite npm packages (as listed in ```package.json```):

```
cd project-6
npm install
```

Launch Ganache on port 7545, or specify your own port in truffle-config.js. Use the mnemonic below for TESTING ONLY.

```
ganache-cli -m "spirit supply whale amount human item harsh scare congress discover talent hamster" --port 7545
```

To compile smart contracts:

```
truffle compile
```

Migrate smart contracts to your ganache instance:

```
truffle migrate
```

Test smart contracts:

```
truffle test
```

To run the frontend DApp on the included webpack server:

```
npm run dev
```

To test proper role authorizations, uncomment the addRoles() functionality in app.js.

## Built With

* [Ethereum](https://www.ethereum.org/) - Ethereum is a decentralized platform that runs smart contracts
* [Truffle Framework](http://truffleframework.com/) - Truffle is the most popular development framework for Ethereum with a mission to make your life a whole lot easier.


## Authors

Project is based on (https://github.com/udacity/nd1309-Project-6b-Example-Template)
<br>
See (https://github.com/udacity/nd1309-Project-6b-Example-Template/graphs/contributors) and (https://github.com/anthonysalvato3/beeffarm/graphs/contributors)

## Acknowledgments

* Solidity
* Ganache
* Truffle
