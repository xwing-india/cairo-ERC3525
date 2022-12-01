## cairo-ERC3525
this repository is for cairo-ERC3525 (semi-fungible token)


## :warning: WARNING! :warning:

This code is entirely experimental, changing frequently and un-audited. Please do not use it in production!


## how to use
make sure you have installed protostar

```
protostar init 
protostar install https://github.com/CairOpen/cairopen-contracts
protostar install https://github.com/OpenZeppelin/cairo-contracts
protostar build --cairo-path ./lib/cairo_contracts/src ./lib/cairopen_contracts/src ./lib/extentions

//deploy to local devnet
protostar -p devnet deploy ./build/ERC3525.json --inputs YOURINPUT
//deploy to testnet
protostar -p testnet deploy ./build/ERC3525.json --inputs YOURINPUT
```

