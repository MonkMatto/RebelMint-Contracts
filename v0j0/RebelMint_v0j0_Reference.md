# RebelMint Contract Version 0 JSON 0 Notes

template deployments:
Base Sepolia: 0xA97A9C1cd3e6d0bB82c571c466AaDa2578dF731C

Base Mainnet: 0x69Cc263973b1b22F7d81C5Be880A27CAd4c4E0De

## Compilation Settings
Use compiler 0.8.26+commit.8a97fa7a
Use compiler EVM Version: cancun, optimization enabled at 200 runs


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
