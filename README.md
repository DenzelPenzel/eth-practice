# Requirements

- node: 16.13.1
- npm: 8.1.2

# What's a Wei?

A wei is the smallest sub-unit of Ether — there are 10^18 wei in one ether.

# What address called your function?

msg.sender

# Using indexed

In order to filter events and only listen for changes related to the current user, Solidity contract would have to use
the indexed keyword, like we did in the Transfer event of our ERC721 implementation:

```event Transfer(address indexed _from, address indexed_to, uint256 _tokenId);```

```
// Use `filter` to only fire this code when `_to` equals `userAccount`
cryptoZombies.events.Transfer({ filter: { _to: userAccount } })
    .on("data", function(event) {
        let data = event.returnValues;
        // The current user just received a zombie!
        // Do something here to update the UI to show it
    })
    .on("error", console.error);
```

# Querying past events

We can even query past events using getPastEvents, and use the filters fromBlock and toBlock to give Solidity a time
range for the event logs ("block" in this case referring to the Ethereum block number):

```
cryptoZombies.getPastEvents("NewZombie", { fromBlock: 0, toBlock: "latest" })
    .then(function(events) {
    // `events` is an array of `event` objects that we can iterate, like we did above
    // This code will get us a list of every zombie that was ever created
    });
```

# Advanced Sample Hardhat Project

This project demonstrates an advanced Hardhat use case, integrating other tools commonly used alongside Hardhat in the ecosystem.

The project comes with a sample contract, a test for that contract, a sample script that deploys that contract, and an example of a task implementation, which simply lists the available accounts. It also comes with a variety of other tools, preconfigured to work with the project code.

Try running some of the following tasks:

```shell
npx hardhat accounts
npx hardhat compile
npx hardhat clean
npx hardhat test
npx hardhat node
npx hardhat help
REPORT_GAS=true npx hardhat test
npx hardhat coverage
npx hardhat run scripts/deploy.ts
TS_NODE_FILES=true npx ts-node scripts/deploy.ts
npx eslint '**/*.{js,ts}'
npx eslint '**/*.{js,ts}' --fix
npx prettier '**/*.{json,sol,md}' --check
npx prettier '**/*.{json,sol,md}' --write
npx solhint 'contracts/**/*.sol'
npx solhint 'contracts/**/*.sol' --fix

npx webpack
cd dist
python -m http.server 6969

npx hardhat node
npx hardhat run scripts/deploy.ts --network localhost

cat artifacts/contracts/Hero.sol/Hero.json | jq .deployedBytecode 
```

# Etherscan verification

To try out Etherscan verification, you first need to deploy a contract to an Ethereum network that's supported by Etherscan, such as Ropsten.

In this project, copy the .env.example file to a file named .env, and then edit it to fill in the details. Enter your Etherscan API key, your Ropsten node URL (eg from Alchemy), and the private key of the account which will send the deployment transaction. With a valid .env file in place, first deploy your contract:

```shell
hardhat run --network ropsten scripts/sample-script.ts
```

Then, copy the deployment address and paste it in to replace `DEPLOYED_CONTRACT_ADDRESS` in this command:

```shell
npx hardhat verify --network ropsten DEPLOYED_CONTRACT_ADDRESS "Hello, Hardhat!"
```

# Performance optimizations

For faster runs of your tests and scripts, consider skipping ts-node's type checking by setting the environment
variable `TS_NODE_TRANSPILE_ONLY` to `1` in hardhat's environment. For more details
see [the documentation](https://hardhat.org/guides/typescript.html#performance-optimizations).
