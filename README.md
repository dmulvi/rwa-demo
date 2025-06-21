## Art Fractionalizer Demo

This is a demo project that leverages tooling from Forte.io to build a compliance focused real world asset application.

Initial experimentation:

deploy the fractal token

```bash
# deploy the ERC-20 ecosystem token
forge script script/Fractal.s.sol --ffi --broadcast --non-interactive --rpc-url $RPC_URL --private-key $PRIV_KEY --verify
```

anvil fractal: `0xb7278A61aa25c888815aFC32Ad3cC52fF24fE575`

---

setup the fraction contract that factory will deploy

add the modifiers

```bash
npx tsx sdk.ts injectModifiers policies/ofac-deny-erc721.json src/FractionFRE.sol src/Fraction.sol
```

---

deploy the factory contract

```bash
forge script script/FractionFactory.s.sol --ffi --broadcast --non-interactive --rpc-url $RPC_URL --private-key $PRIV_KEY --verify
```

bsc-testnet factory address: `0x361432816390275698fCd02918D599361744a7B3`

call the factory and set the mintPrice to 5 FRCTL

```bash
cast send $FACTORY_ADDRESS "createFractionatedToken(string,string,uint256,uint256,address)" "Danny" "DANNY" 10000 5000000000000000000 $DEPLOYER --rpc-url $RPC_URL --private-key $PRIV_KEY --json > tx.json
```

now parse the tx.json to get the contract address of newly deployed token

```bash
jq '.logs[0].address' tx.json
```

cast call 0xa16e02e87b7454126e5e10d957a927a7f5b5d2be "name()(string)" --rpc-url $RPC_URL --private-key $PRIV_KEY
cast call 0xa16e02e87b7454126e5e10d957a927a7f5b5d2be "balanceOf(address)(uint256)" 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 --rpc-url $RPC_URL --private-key $PRIV_KEY

Building Your Own

OFAC Deny List - link to repo, indicate existing deployed addresses on Base Sepolia, BNB Testnet, and Polygon Amoy

## The AMM/Liquidity Stuff

Fractal BEP-20: `0xCB2D4264c81917939Bd44701472367f7eCe62727`

deployed sanction list and oracle denied adapter to bsc testnet (having issues viewing on explorer and verifying though, may need to redo)

- this is preventing creating the erc20-deny policy on bsc testnet as of now

BNB testnet pool factory: `0x996EbF593a0C0FB0D0e7359e63705407Cb6130C5`
deployer allow list: `0x86cc738D7eB10b77e485bEcCFb36352538e4A8D3`
y token allow list: `0x142753dd09b0BA4C2705D09A4f01C64ED041ae39`

### deployer allow list

cast call 0x996EbF593a0C0FB0D0e7359e63705407Cb6130C5 "getDeployerAllowList()(address)" --rpc-url $RPC_URL
cast call 0x86cc738D7eB10b77e485bEcCFb36352538e4A8D3 "isAllowed(address)(bool)" 0x_DEPLOYER_WALLET --rpc-url $RPC_URL

### y token allowlist

cast call 0x996EbF593a0C0FB0D0e7359e63705407Cb6130C5 "getYTokenAllowList()(address)" --rpc-url $RPC_URL
cast call 0x142753dd09b0BA4C2705D09A4f01C64ED041ae39 "isAllowed(address)(bool)" 0xC39c934A04682229f98961a4cE84eF75572C338C --rpc-url $RPC_URL

## Policies

This repo includes three pre-defined policies that will help you build a compliance focused RWA application.... - list them out - provide details on each - the AMM trading one must be manually deployed post pool deployment.

Sanctions List and Oracly Deny adapter deployed to BSC Testnet
see fre-oracle-adapter-chainalysis repo for deploy directions

KYC access level

```bash
forge script scripts/KYC.s.sol --rpc-url $RPC_URL --private-key $PRIV_KEY --broadcast --verify
```

KYC contract: `0xC38E1aCF67A1a8BB29b590069411316034e8BCb6` (verification failing due to bsc issue as of now)

## Working Locally

Included `anvilState.json` file includes FRE and OFAC sanctions list adapter contract at `0x0B306BF915C4d645ff596e518fAf3F9669b97016`.

Hackathon Ideas:

- add support for EIP-7943
- make the fractionalization quantity adjustable
- add more sophisticated rules
- build a UI that allows uploading the artwork, split it into 10k pieces so that when users mint their NFT is a chunk of the fractionalized art.
- enforce a range for totalSupply of the erc-721 (10-10K) or something
- make the contracts upgradeable

amm only trading

- only allow the amm contract
- allow all EOAs

Extra Rules

- min hold time for NFT

- only allow minting of NFT if rules engine address is set or something to make sure
