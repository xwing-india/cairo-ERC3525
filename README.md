## about 
this repository is for cairo-ERC3525 

protostar init 
protostar install https://github.com/CairOpen/cairopen-contracts
protostar install https://github.com/OpenZeppelin/cairo-contracts
protostar build --cairo-path ./lib/cairo_contracts/src

deploy to local devnet
protostar -p devnet deploy ./build/ERC3525.json --inputs 111 2 222 333
deploy to testnet
protostar -p testnet deploy ./build/ERC3525.json --inputs 111 2 222 333