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
cast send $FACTORY_ADDRESS "createFractionatedToken(string,string,uint256,uint256,address)" "Danny" "DJM" 10000 5000000000000000000 $DEPLOYER --rpc-url $RPC_URL --private-key $PRIV_KEY --json > tx.json

cast send $FACTORY_ADDRESS "createFractionatedToken(string,string,uint256,uint256,address)" "Danny2" "DJM" 10000 1000000000000000000 $DEPLOYER --rpc-url $RPC_URL --private-key $PRIV_KEY --json > tx.json

# update the paymentToken in the factory for new fraction deployments
cast send $FACTORY_ADDRESS "setPaymentToken(address)" $FRACTAL_TOKEN --rpc-url $RPC_URL --private-key $PRIV_KEY

cast call $FACTORY_ADDRESS "paymentToken()(address)" --rpc-url $RPC_URL

cast call $FRACTION_ADDRESS "paymentToken()(address)" --rpc-url $RPC_URL
```

now parse the tx.json to get the contract address of newly deployed token

```bash
export FRACTION_ADDRESS=$(jq -r '.logs[0].address' tx.json)
```

- set calling contract admin

```bash
cast send $FRACTION_ADDRESS "setCallingContractAdmin(address)" $DEPLOYER --rpc-url $RPC_URL --private-key $PRIV_KEY
```

- apply the policies to the new contract

```bash
npx tsx sdk.ts setupPolicy policies/kyc-level.json

export POLICY_ID=

npx tsx sdk.ts applyPolicy $POLICY_ID $FRACTION_ADDRESS
```

now I need to mint agaist this to test the rules

- send some of the fractal token to an address to test out the mint
- don't forget to set the approval first

```bash
cast send $FRACTAL_TOKEN "approve(address,uint256)" $FRACTION_ADDRESS "25000000000000000000" --rpc-url $RPC_URL --private-key $PRIV_KEY

cast send $FRACTAL_TOKEN "approve(address,uint256)" $FRACTION_ADDRESS "25000000000000000000" --rpc-url $RPC_URL --private-key 0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d

cast send $FRACTAL_TOKEN "transfer(address,uint256)" 0x70997970C51812dc3A010C7d01b50e0d17dc79C8 250000000000000000000 --rpc-url $RPC_URL --private-key $PRIV_KEY

cast call $FRACTAL_TOKEN "allowance(address,address)(uint256)" 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 $FRACTION_ADDRESS --rpc-url $RPC_URL
```

```bash
cast send $FRACTION_ADDRESS "mint(address,uint256)" 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC 1 --rpc-url $RPC_URL --private-key $PRIV_KEY

cast send $FRACTION_ADDRESS "mint(address,uint256)" 0x8576acc5c05d6ce88f4e49bf65bdf0c62f91353c 1 --rpc-url $RPC_URL --private-key $PRIV_KEY

cast send $FRACTION_ADDRESS "mint(address,uint256)" 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 1 --rpc-url $RPC_URL --private-key $PRIV_KEY

cast send $FRACTION_ADDRESS "mint(address,uint256)" 0x70997970C51812dc3A010C7d01b50e0d17dc79C8 1 --rpc-url $RPC_URL --private-key 0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d
```

What's next?

- mint some of the fractionalized art tokens
- determine how many are left by calling contract (for use in the web application)

KYC, AML, OFAC, rules are very flexible and they can be used for non-compliance things as well

if you going to do the forte track, this is how I'd approach it

It is in development, don't be stuck, come talk to me! Or discord, TG, etc,
Let me know and I can come check in on you.

slide that describes at a high level of the project (my demo) - these are the things I did: - RWA - policies - these token contracts are integrated with the fRE (and I'll cover that in a minute)

- define the policy live
- orient them with the docs
- demonstrate the testing of it working/not working

```bash
cast call $FRACTAL_TOKEN "name()(string)" --rpc-url $RPC_URL
cast call $FRACTAL_TOKEN "balanceOf(address)(uint256)" 0x70997970C51812dc3A010C7d01b50e0d17dc79C8 --rpc-url $RPC_URL
cast call $FRACTION_ADDRESS "name()(string)" --rpc-url $RPC_URL
```

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
forge script script/KYC.s.sol --rpc-url $RPC_URL --private-key $PRIV_KEY --broadcast --verify
```

KYC contract: `0xC38E1aCF67A1a8BB29b590069411316034e8BCb6` (verification failing due to bsc issue as of now)

## Working Locally

Included `anvilState.json` file includes FRE and OFAC sanctions list adapter contract at `0x0B306BF915C4d645ff596e518fAf3F9669b97016`.

```bash
cast call 0x0B306BF915C4d645ff596e518fAf3F9669b97016 "isDenied(address)(bool)" 0x8576acc5c05d6ce88f4e49bf65bdf0c62f91353c --rpc-url $RPC_URL
```

KYC contract is deployed at `$KYC_CONTRACT`

```bash
cast send $KYC_CONTRACT "setKycLevel(address,uint256)" 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 3 --rpc-url $RPC_URL --private-key $PRIV_KEY

cast send $KYC_CONTRACT "setKycLevel(address,uint256)" 0x70997970C51812dc3A010C7d01b50e0d17dc79C8 3 --rpc-url $RPC_URL --private-key $PRIV_KEY

cast call $KYC_CONTRACT "getKycLevel(address)(uint256)" 0x8576acc5c05d6ce88f4e49bf65bdf0c62f91353c --rpc-url $RPC_URL

cast call $KYC_CONTRACT "getKycLevel(address)(uint256)" 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC --rpc-url $RPC_URL


cast call $FRACTION_ADDRESS "balanceOf(address)(uint256)" 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 --rpc-url $RPC_URL
# Boolean version

cast send $KYC_CONTRACT "setKycBool(address,bool)" 0x70997970C51812dc3A010C7d01b50e0d17dc79C8 true --rpc-url $RPC_URL --private-key $PRIV_KEY

cast call $KYC_CONTRACT "getKycBool(address)(bool)" 0x70997970C51812dc3A010C7d01b50e0d17dc79C8 --rpc-url $RPC_URL
cast call $KYC_CONTRACT "getKycBool(address)(bool)" 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC --rpc-url $RPC_URL
```

Hackathon Ideas:

- add support for EIP-7943
- make the fractionalization quantity adjustable
- add more sophisticated rules
- build a UI that allows uploading the artwork, split it into 10k pieces so that when users mint, their NFT is a chunk of the fractionalized art.
- enforce a range for totalSupply of the erc-721 (10-10K) or something
- make the contracts upgradeable

amm only trading

- only allow the amm contract
- allow all EOAs

get anvilstate file that includes:

- fractal token
- ofac adapter
- kyc FC

Workshop flow

- start with slides
- discuss compliance
  - kyc/aml
  - ofac sanctions list
- mention the rules engine and what it does
  - separate the compliance logic from the rest of your app
  - many other use cases of course
    - incentive alignment
      - gaming example with NFT level

FAQs

calling function to test a policy and get : execution reverted data 0x
potential causes - error in the function you're calling to test. Try testing the same function w/o rules engine enabled. If it works then problem is with the policy - if your policy uses a foreign contract call, but the address is wrong you will get this error
