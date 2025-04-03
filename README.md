## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```

forge init
forge build
anvil

forge create SimpleStorage --rpc-url http://127.0.0.1:7545 --interactive --broadcast
forge create SimpleStorage --interactive --broadcast
forge create SimpleStorage --rpc-url http://127.0.0.1:8545 --private-key 0x2a871d0798f97d79848a013d4936a73bf4cc922c825d33c1cf7073dff6d409c6

forge script script/DeploySimpleStorage.s.sol
forge script script/DeploySimpleStorage.s.sol --rpc-url http://127.0.0.1:8545 --broadcast --private-key 0x2a871d0798f97d79848a013d4936a73bf4cc922c825d33c1cf7073dff6d409c6
forge script script/DeploySimpleStorage.s.sol --rpc-url $RPC_URL --broadcast --private-key $PRIVATE_KEY

cast send 0xA15BB66138824a1c7167f5E85b957d04Dd34E468 "store(uint256)" 123 --rpc-url http://127.0.0.1:8545 --private-key 0x2a871d0798f97d79848a013d4936a73bf4cc922c825d33c1cf7073dff6d409c6

cast call 0xA15BB66138824a1c7167f5E85b957d04Dd34E468 "retrieve()"

#十六进制转十进制
```
cast --to-base 0x000000000000000000000000000000000000000000000000000000000000007b dec
```

https://dashboard.alchemy.com/
https://eth-sepolia.g.alchemy.com/v2/sVijOTG4-TPy_OUyH_UJUy2Zh74f7o0E

forge install smartcontractkit/chainlink-brownie-contracts@1.3.0

forge test --vv    //vv表示日志可见性

forge test -m 方法名 -vvv  //测试独立方法脚本
forge test -m 方法名 -vvv --fork-url 地址
forge test --match-test testFundIsWithoutEnoughEth

forge coverage --fork-url 地址  //测试覆盖率

chisel //测试工具

//检查测试消耗多少gas
```
forge snapshot --match-test testWithdrawWithMultipleFunders 
```

```
    //计算消耗多少gas
        uint256 gasStart = gasleft(); // Get the current gas left
        vm.txGasPrice(GAS_PRICE); // Set the gas price for the transaction
        vm.startPrank(fundMe.getOwner()); // Simulate a transaction from the owner
        fundMe.withdraw();

        uint256 gasEnd = gasleft();
        uint256 gasUsed = (gasStart - gasEnd) * GAS_PRICE; // Calculate the gas used for the transaction
        console.log("Gas used: ", gasUsed);
```

```
forge inspect FundMe storageLayout
//告诉你FundMe合约的存储布局
```


```
forge script script/Interactions.s.sol:FundFundMe --rpc-url http://127.0.0.1:8545 --private-key 0x2a871d0798f97d79848a013d4936a73bf4cc922c825d33c1cf7073dff6d409c6 --broadcast --force
```

```
forge test --fork-url $SEPOLIA_RPC_URL
```

#git
```
//初始化 Git 仓库的命令
git init -b main  
//主要用于显示当前工作目录和暂存区的状态信息，帮助你了解文件的修改情况，比如哪些文件被修改了、哪些文件被添加到了暂存区、哪些文件是新创建的还未被跟踪等
git status  
//将当前工作目录下所有被修改或者新创建的文件添加到 Git 的暂存区（也称为索引）。暂存区是介于工作目录和本地仓库之间的一个中间区域，它允许你选择性地将文件的修改分组，然后再一起提交到本地仓库。
git add . 
```