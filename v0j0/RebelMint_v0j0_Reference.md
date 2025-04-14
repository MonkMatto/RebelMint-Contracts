# RebelMint Contract Version 0 JSON 0 Notes

## Template Deployments
### Ethereum
Testnet: 0xBb657C226D81F967F5C9133a1663d47E9B73981B
  ID: 11155111
  Name: ethereum-testnet-sepolia
  Explorer: https://sepolia.etherscan.io/
Mainnet: 0x9763141Aa64d07741b0263d8cFb273119adB839a
  ID: 1 (0x1)
  Name: ethereum-mainnet
  Explorer: https://etherscan.io/


### Base
Testnet: 
  ID: 84532 (0x14a34)
  Name: base-testnet-sepolia
  Explorer: https://sepolia.basescan.org/
Mainnet: 
  ID: 8453 (0x2105)
  Name: base-mainnet
  Explorer: https://basescan.org/


### Optimism
Testnet: 
  ID: 11155420 (0xaa37dc)
  Name: op-testnet-sepolia
  Explorer: https://sepolia-optimism.etherscan.io/
Mainnet: 
  ID: 10 (0xa)
  Name: op-mainnet
  Explorer: https://optimistic.etherscan.io/


### Shape
Testnet: 
  ID: 11011 (0x2b03)
  Name: shape-testnet-sepolia
  Explorer: https://explorer-sepolia.shape.network/
Mainnet: 
  ID: 360 (0x168)
  Name: shape-mainnet
  Explorer: https://shapescan.xyz/


### Arbitrum 
Testnet: 
  ID: 421614 (0x66eee)
  Name: arbitrum-testnet-sepolia
  Explorer: https://sepolia.arbiscan.io/
Mainnet: 
  ID: 42161 (0xa4b1)
  Name: arbitrum-mainnet
  Explorer: https://arbiscan.io/


### Polygon 
Testnet: 
  ID: 80002 (0x13882)
  Name: polygon-testnet-amoy
  Explorer: https://amoy.polygonscan.com/
Mainnet: 
  ID: 137 (0x89)
  Name: polygon-mainnet
  Explorer: https://polygonscan.com/


### Abstract - Not-Deployed, JSON-RPC-Errors
Testnet:
  ID: 11124 (0x2b74)
  Name: absract-testnet-sepolia
  Explorer: https://sepolia.abscan.org/
Mainnet:
  ID: 2741 (0xab5)
  Name: abstract-mainnet
  Explorer: https://abscan.org/


## Compilation/Verification Settings
License: MIT
compiler 0.8.26+commit.8a97fa7a
compiler EVM Version: cancun
optimization enabled at 200 runs


## Contract Verification
After a template contract is deployed and verified on a chain, explorers should auto-verify new contracts deployed to that chain.
To verify the first contract - or if autoverify fails, use the Flattened.sol file and the above Compilation Settings.
Deployed Bytecode from the verified contract should match the DeployedBytecodeReference.

## JSON Data Returned From Contract
(test data from existing collections)

`getCollectionDataJSON()` returns only collection info.

```json
{
  "contract_code": "v0j0",
  "collection_name": "RebelMint Beta",
  "artist_name": "Matto",
  "collection_description": "This time we got the cost in base units and decimals in the returned JSON.",
  "default_funds_receiver": "0x983f10b69c6c8d72539750786911359619df313d",
  "royalty_bps": "700",
  "owner_address": "0xe4c8efd2ed3051b22ea3eede1af266452b0e66e9"
}
```

`getSingleTokenDataJSON(id)` returns token data for a single token. Note: the 0x0 address denotes payment in Eth.

```json
{
  "token_id": "0",
  "is_token_sale_active": false,
  "token_cost": "1000000000000",
  "decimals": "18",
  "currency_address": "0x0000000000000000000000000000000000000000",
  "current_supply": "0",
  "max_supply": "777",
  "uri": "https://arweave.net/P_XbqLatAX9x98rSC-pzPCdt0B5OlqFsdMKUelK7SWY"
}
```

`getAllTokenDataJSON()` wraps all individual token data into one object.

```json
{
  "tokens": [
    {
      "token_id": "0",
      "is_token_sale_active": true,
      "token_cost": "1000000000000",
      "decimals": "18",
      "currency_address": "0x0000000000000000000000000000000000000000",
      "current_supply": "0",
      "max_supply": "777",
      "uri": "https://arweave.net/P_XbqLatAX9x98rSC-pzPCdt0B5OlqFsdMKUelK7SWY"
    },
    {
      "token_id": "1",
      "is_token_sale_active": true,
      "token_cost": "500000000000000000000",
      "decimals": "18",
      "currency_address": "0xcc335a42a2b62aa7990e723cdbd4e73fb9214d88",
      "current_supply": "0",
      "max_supply": "1111",
      "uri": "https://arweave.net/4UjiH7ST0_3L0Qe_kBFHMrZCCvSLzaIhTgWfgoyi7gk"
    },
    {
      "token_id": "2",
      "is_token_sale_active": false,
      "token_cost": "100000000000000",
      "decimals": "18",
      "currency_address": "0x0000000000000000000000000000000000000000",
      "current_supply": "0",
      "max_supply": "99",
      "uri": "https://token.artblocks.io/430000107"
    },
    {
      "token_id": "3",
      "is_token_sale_active": false,
      "token_cost": "10000000000000",
      "decimals": "18",
      "currency_address": "0x0000000000000000000000000000000000000000",
      "current_supply": "0",
      "max_supply": "1000000000",
      "uri": "https://midnightbreeze.mypinata.cloud/ipfs/QmQgqB5hFVfVddk7BpA2vfW1MyaFhHrZpvjKyc3DKpM3iv/1199"
    }
  ]
}
```

`getCollectionAndTokenDataJSON()` assembles collection and token data into one object.

```json
{
  "contract_code": "v0j0",
  "collection_name": "RebelMint Beta",
  "artist_name": "Matto",
  "collection_description": "This time we got the cost in base units and decimals in the returned JSON.",
  "default_funds_receiver": "0x983f10b69c6c8d72539750786911359619df313d",
  "royalty_bps": "700",
  "owner_address": "0xe4c8efd2ed3051b22ea3eede1af266452b0e66e9",
  "tokens": [
    {
      "token_id": "0",
      "is_token_sale_active": true,
      "token_cost": "1000000000000",
      "decimals": "18",
      "currency_address": "0x0000000000000000000000000000000000000000",
      "current_supply": "0",
      "max_supply": "777",
      "uri": "https://arweave.net/P_XbqLatAX9x98rSC-pzPCdt0B5OlqFsdMKUelK7SWY"
    },
    {
      "token_id": "1",
      "is_token_sale_active": true,
      "token_cost": "500000000000000000000",
      "decimals": "18",
      "currency_address": "0xcc335a42a2b62aa7990e723cdbd4e73fb9214d88",
      "current_supply": "0",
      "max_supply": "1111",
      "uri": "https://arweave.net/4UjiH7ST0_3L0Qe_kBFHMrZCCvSLzaIhTgWfgoyi7gk"
    },
    {
      "token_id": "2",
      "is_token_sale_active": false,
      "token_cost": "100000000000000",
      "decimals": "18",
      "currency_address": "0x0000000000000000000000000000000000000000",
      "current_supply": "0",
      "max_supply": "99",
      "uri": "https://token.artblocks.io/430000107"
    },
    {
      "token_id": "3",
      "is_token_sale_active": false,
      "token_cost": "10000000000000",
      "decimals": "18",
      "currency_address": "0x0000000000000000000000000000000000000000",
      "current_supply": "0",
      "max_supply": "1000000000",
      "uri": "https://midnightbreeze.mypinata.cloud/ipfs/QmQgqB5hFVfVddk7BpA2vfW1MyaFhHrZpvjKyc3DKpM3iv/1199"
    }
  ]
}
```
