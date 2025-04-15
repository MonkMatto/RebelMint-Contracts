// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "@openzeppelin/contracts/interfaces/IERC2981.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

interface I_ERC20 {
    function balanceOf(address account) external view returns (uint256);
    function decimals() external view returns (uint8);
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);
    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);
}

/// @title RebelMint_v0j0
/// @notice RebelMint is a contract for minting and selling NFTs as ERC-1155 tokens.
/// This contract integrates with other open source RebelMint website and react components.
/// RebelMint is designed to enable artists to mint and sell NFTs with a variety of payment options without having fees taken by a platform.
/// The contract can support multiple tokens, each with its own cost, max supply, funds receiver address, and URI string.
/// It supports royalties with ERC-2981 and can accept payment in ETH or ERC-20 tokens.
/// @dev A view function, getCollectionData, returns the collection data as a JSON string for easy incorporation into a front-end.
/// Each RebelMint contract release will have a different contract code returned as a top level key (contract_code) in the collection data JSON.
/// For example, "v0j0" denotes that it's version 0 of the RebelMint contract and is using JSON structure type 0.
/// Future contracts will have different version numbers, but they may have the same JSON type number if they use same JSON structure.
/// Front ends should check the contract code and JSON type standard to appropriately display the collection data and mint tokens.
/// This contract does not use constructor parameters so that all deployed bytecode will be identical if using the same compilation settings.
/// If there is a bytecode mismatch between a deployed contract and the reference deployment, RebelMint contract components will not be compatible by default.
/// @custom:security-contact monkmatto@protonmail.com
contract RebelMint_v0j0 is
    ERC1155,
    IERC2981,
    Ownable,
    ERC1155Burnable,
    ERC1155Supply
{
    using Strings for string;

    constructor() ERC1155("") Ownable() {}

    struct tokenData {
        address currencyAddress;
        bool isTokenSaleActive;
        uint8 decimals;
        uint256 tokenCost;
        uint256 maxSupply;
        string tokenUri;
    }

    string public contractCode = "v0j0";
    uint96 public royaltyBPS;
    address public defaultFundsReceiver;
    string public collectionName;
    string public artistName;
    string public collectionDescription;
    tokenData[] public allTokenData;
    mapping (uint256 => address) private fundsReceiverOverride;

    event CollectionUpdate();
    event TokenUpdate(tokenData token);
    event TokenDeleted(uint256 indexed tokenId, tokenData token);
    event FundsReceiverOverride(uint256 indexed tokenId, address fundsReceiverOverride);

    /// @notice Sets the collection data including name, artist, description, funds receiver and royalty BPS
    /// @param _collectionName Name of the collection
    /// @param _artistName Name of the artist
    /// @param _collectionDescription Description of the collection
    /// @param _defaultFundsReceiver Defaul address that will receive mint funds, DO NOT USE AN EXCHANGE ADDRESS
    /// @param _royaltyBPS Royalty basis points (max 1000)
    function setCollectionData(
        string memory _collectionName,
        string memory _artistName,
        string memory _collectionDescription,
        address _defaultFundsReceiver,
        uint96 _royaltyBPS
    ) external onlyOwner {
        require(_royaltyBPS <= 1000, "Royalty BPS too high");
        require(_defaultFundsReceiver != address(0), "Funds receiver cannot be 0x0");
        royaltyBPS = _royaltyBPS;
        defaultFundsReceiver = _defaultFundsReceiver;
        collectionName = _collectionName;
        artistName = _artistName;
        collectionDescription = _collectionDescription;
        emit CollectionUpdate();
    }

    /// @notice Creates a token and sets data including cost, currency address, max supply, and URI
    /// @param tokenCost Cost of the token in the base units of the specified currency (e.g. 1000000000000000000 for 1 ETH)
    /// @param currencyAddress The 0x0 address for Eth or the contract address of the ERC-20 token used for payment
    /// @param maxSupply Maximum supply of the token
    /// @param tokenUri URI of the token metadata
    function createToken(
        uint256 tokenCost,
        address currencyAddress,
        uint256 maxSupply,
        string memory tokenUri
    ) external onlyOwner {
        require(defaultFundsReceiver != address(0), "Collection data not set");
        require(maxSupply > 0, "Max supply must be greater than 0");
        uint8 decimals = _getDecimals(currencyAddress);
        allTokenData.push(
            tokenData(
                currencyAddress,
                false,
                decimals,
                tokenCost,
                maxSupply,
                tokenUri
            )
        );
        emit TokenUpdate(allTokenData[allTokenData.length - 1]);
    }

    /// @notice Allows updates to the default funds receiver address and royalty BPS
    /// @dev Funds receiver overrides can be set for individual tokens by the current funds receiver of that token and the contract owner
    /// @param _defaultFundsReceiver Default address that will receive mint funds, DO NOT USE AN EXCHANGE ADDRESS
    /// @param _royaltyBPS Royalty basis points (max 1000)
    function updateDefaultFundsReceiverAndRoyaltyBPS(
        address _defaultFundsReceiver,
        uint96 _royaltyBPS
    ) external onlyOwner {
        require(_royaltyBPS <= 1000, "Royalty BPS too high");
        require(_defaultFundsReceiver != address(0), "Funds receiver cannot be 0x0");
        royaltyBPS = _royaltyBPS;
        defaultFundsReceiver = _defaultFundsReceiver;
        emit CollectionUpdate();
    }

    /// @notice Allows the owner to override the funds receiver for a specific token
    /// @param id ID of the token
    /// @param _fundsReceiverOverride Address that will receive mint funds, DO NOT USE AN EXCHANGE ADDRESS
    function setFundsReceiverOverride(
        uint256 id,
        address _fundsReceiverOverride
    ) external {
        require(id < allTokenData.length, "Token ID does not exist");
        address currentFundsReceiver = getFundsReceiver(id);
        require(msg.sender == owner() || msg.sender == currentFundsReceiver, "Unauthorized");
        fundsReceiverOverride[id] = _fundsReceiverOverride;
        emit FundsReceiverOverride(id, _fundsReceiverOverride);
    }

    /// @notice Returns the funds receiver for a specific token
    /// @param id ID of the token
    /// @return Address of the funds receiver
    function getFundsReceiver(
        uint256 id
    ) public view returns (address) {
        require(id < allTokenData.length, "Token ID does not exist");
        return fundsReceiverOverride[id] == address(0) ? defaultFundsReceiver : fundsReceiverOverride[id];
    }

    /// @notice Updates the cost of a token and the currency address
    /// @param id ID of the token
    /// @param tokenCost Cost of the token in the specified currency
    /// @param currencyAddress Address of the ERC-20 token used for payment (0x0 for ETH)
    function updateTokenCostAndCurrency(
        uint256 id,
        uint256 tokenCost,
        address currencyAddress
    ) external onlyOwner {
        require(id < allTokenData.length, "Token ID does not exist");
        allTokenData[id].isTokenSaleActive = false;
        allTokenData[id].tokenCost = tokenCost;
        allTokenData[id].currencyAddress = currencyAddress;
        uint8 decimals = _getDecimals(currencyAddress);
        allTokenData[id].decimals = decimals;
        emit TokenUpdate(allTokenData[id]);
    }

    /// @notice Allows toggling the sale status of a token if minting is not complete
    /// @param id ID of the token
    /// @param isTokenSaleActive New sale status of the token
    function updateTokenSaleStatus(
        uint256 id,
        bool isTokenSaleActive
    ) external onlyOwner {
        require(id < allTokenData.length, "Token ID does not exist");
        require(
            totalSupply(id) < allTokenData[id].maxSupply,
            "Minting is complete"
        );
        allTokenData[id].isTokenSaleActive = isTokenSaleActive;
        emit TokenUpdate(allTokenData[id]);
    }

    /// @notice Lowers the max supply of a token
    /// @param id ID of the token
    /// @param newSupply New max supply of the token
    function updateTokenSupply(
        uint256 id,
        uint256 newSupply
    ) external onlyOwner {
        require(id < allTokenData.length, "Token ID does not exist");
        require(
            newSupply <= allTokenData[id].maxSupply,
            "New supply cannot be higher than current max supply"
        );
        require(
            newSupply >= totalSupply(id),
            "New supply cannot be lower than currently minted supply"
        );
        if (newSupply == totalSupply(id)) {
            allTokenData[id].isTokenSaleActive = false;
        }
        allTokenData[id].maxSupply = newSupply;
        emit TokenUpdate(allTokenData[id]);
    }

    /// @notice Updates the URI of a token
    /// @param id ID of the token
    /// @param tokenUri URI of the token metadata
    function updateTokenUri(
        uint256 id,
        string memory tokenUri
    ) external onlyOwner {
        require(id < allTokenData.length, "Token ID does not exist");
        allTokenData[id].tokenUri = tokenUri;
        emit TokenUpdate(allTokenData[id]);
    }

    /// @notice Allows the contract owner to delete the last token if it has not been minted
    function deleteLastUnmintedToken() external onlyOwner {
        require(allTokenData.length > 0, "No tokens exist");
        uint256 lastTokenId = allTokenData.length - 1;
        require(
            totalSupply(lastTokenId) == 0,
            "Cannot delete a token with minted supply"
        );
        tokenData memory deletedToken = allTokenData[lastTokenId];
        allTokenData.pop();
        emit TokenDeleted(lastTokenId, deletedToken);
    }

    /// @notice Mints a specified amount of a token to a specified address
    /// @param to Address to receive the token
    /// @param id ID of the token
    /// @param amount Amount of the token to mint
    function mint(address to, uint256 id, uint256 amount) external payable {
        require(allTokenData[id].isTokenSaleActive, "Sale is closed");
        _preMintChecks(id, amount);
        address currencyAddress = allTokenData[id].currencyAddress;
        uint256 totalCost = allTokenData[id].tokenCost * amount;
        address mintFundsReceiver = getFundsReceiver(id);
        if (currencyAddress == address(0)) {
            // Use ETH for payment
            require(msg.value == totalCost, "Incorrect value sent");
            (bool success, ) = payable(mintFundsReceiver).call{
                value: msg.value
            }("");
            require(success, "ETH transfer failed");
        } else {
            // Use ERC-20 token for payment
            I_ERC20 currency = I_ERC20(currencyAddress);
            require(
                currency.allowance(msg.sender, address(this)) >= totalCost,
                "ERC20 allowance too low"
            );
            require(
                currency.balanceOf(msg.sender) >= totalCost,
                "ERC20 balance too low"
            );
            require(
                currency.transferFrom(msg.sender, mintFundsReceiver, totalCost),
                "ERC20 transfer failed"
            );
        }

        _mint(to, id, amount, "");
        _postMintChecks(id);
    }

    /// @notice Owner-only minting function that doesn't accept payment
    /// @dev This function is for minting tokens without requiring payment and
    /// does not require the token sale to be active.
    /// @param to Address to receive the token
    /// @param id ID of the token
    /// @param amount Amount of the token to mint
    function ownerMint(address to, uint256 id, uint256 amount) public onlyOwner {
        _preMintChecks(id, amount);
        _mint(to, id, amount, "");
        _postMintChecks(id);
    }

    /// @notice Returns the number of tokens created in the collection
    function getTokenCount() external view returns (uint256) {
        return allTokenData.length;
    }

    /// @notice Returns the token data for a specific token as a JSON string
    /// @dev Returns a JSON string with the following keys: token_id, is_token_sale_active, token_cost, currency_address, current_supply, max_supply, uri
    /// The value of "token_cost" is in the base units of the specified currency
    /// @param id ID of the token
    /// @return A JSON string representing the token data
    function getSingleTokenDataJSON(
        uint256 id
    ) public view returns (string memory) {
        require(id < allTokenData.length, "Token ID does not exist");
        string memory tokenDataJSON = string(
            abi.encodePacked(
                "{",
                '"token_id": "',
                Strings.toString(id),
                '", "is_token_sale_active": ',
                allTokenData[id].isTokenSaleActive ? "true" : "false",
                ', "token_cost": "',
                Strings.toString(allTokenData[id].tokenCost),
                '", "decimals": "',
                Strings.toString(allTokenData[id].decimals),
                '", "currency_address": "',
                Strings.toHexString(
                    uint160(allTokenData[id].currencyAddress),
                    20
                ),
                '", "current_supply": "',
                Strings.toString(totalSupply(id)),
                '", "max_supply": "',
                Strings.toString(allTokenData[id].maxSupply),
                '", "uri": "',
                allTokenData[id].tokenUri,
                '"}'
            )
        );
        return tokenDataJSON;
    }

    /// @notice Returns all token data as a JSON string
    /// @return A JSON string representing the token data
    function getAllTokenDataJSON() external view returns (string memory) {
        string memory allTokenDataJSON = string(
            abi.encodePacked("{", _allTokenDataBuilder(), "}")
        );
        return allTokenDataJSON;
    }

    /// @notice Returns the collection data as a JSON string
    /// @return A JSON string representing the collection data
    /// @dev Returns a JSON string with the following keys: contract_version, collection_name, artist_name, collection_description, funds_receiver, royalty_bps, owner_address
    function getCollectionDataJSON() external view returns (string memory) {
        string memory collectionDataJSON = string(
            abi.encodePacked("{", _collectionDataBuilder(), "}")
        );
        return collectionDataJSON;
    }

    /// @notice Returns the collection and token data as a JSON string
    /// @return A JSON string representing the collection and token data
    function getCollectionAndTokenDataJSON()
        external
        view
        returns (string memory)
    {
        string memory collectionAndTokenDataJSON = string(
            abi.encodePacked(
                "{",
                _collectionDataBuilder(),
                ",",
                _allTokenDataBuilder(),
                "}"
            )
        );
        return collectionAndTokenDataJSON;
    }

    /// @notice Returns the royalty information for a token
    /// @param id ID of the token
    /// @param salePrice Sale price of the token
    /// @return Address of the royalty receiver and the royalty amount
    function royaltyInfo(
        uint256 id,
        uint256 salePrice
    ) external view override returns (address, uint256) {
        uint256 royaltyAmount = (salePrice * royaltyBPS) / 10000;
        address royaltyReceiver = getFundsReceiver(id);
        return (royaltyReceiver, royaltyAmount);
    }

    /// @notice Checks if the contract supports a specific interface
    /// @param interfaceId The interface ID to check
    /// @return True if the interface is supported, false otherwise
    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override(ERC1155, IERC165) returns (bool) {
        return
            interfaceId == type(IERC2981).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    /// @notice Returns the URI for a specific token
    /// @param id ID of the token
    /// @return URI of the token
    function uri(
        uint256 id
    ) public view override(ERC1155) returns (string memory) {
        return allTokenData[id].tokenUri;
    }

    /// @notice Internal function to return all token data as a JSON string
    function _allTokenDataBuilder() internal view returns (string memory) {
        string memory tokenDataBuild = '"tokens": [';
        for (uint256 i = 0; i < allTokenData.length; i++) {
            tokenDataBuild = string(
                abi.encodePacked(
                    tokenDataBuild,
                    getSingleTokenDataJSON(i),
                    i < allTokenData.length - 1 ? "," : ""
                )
            );
        }
        tokenDataBuild = string(abi.encodePacked(tokenDataBuild, "]"));
        return tokenDataBuild;
    }

    /// @notice Internal function to return the collection data as a JSON string
    function _collectionDataBuilder() internal view returns (string memory) {
        return
            string(
                abi.encodePacked(
                    '"contract_code": "',
                    contractCode,
                    '", "collection_name": "',
                    collectionName,
                    '", "artist_name": "',
                    artistName,
                    '", "collection_description": "',
                    collectionDescription,
                    '", "default_funds_receiver": "',
                    Strings.toHexString(uint160(defaultFundsReceiver), 20),
                    '", "royalty_bps": "',
                    Strings.toString(royaltyBPS),
                    '", "owner_address": "',
                    Strings.toHexString(uint160(owner()), 20),
                    '"'
                )
            );
    }

    /// @notice Returns the decimals of a currency
    /// @param currencyAddress Address of the ERC-20 token used for payment (0x0 for ETH)
    /// @return Decimals of the currency
    function _getDecimals(
        address currencyAddress
    ) internal view returns (uint8) {
        uint8 decimals;
        if (currencyAddress != address(0)) {
            decimals = I_ERC20(currencyAddress).decimals();
            require(decimals <= 18, "Currency Contract Not Compatible");
        } else {
            decimals = 18;
        }
        return decimals;
    }

    /// @notice Internal function to perform pre-mint checks
    /// @dev Requires that the token ID exists and that the total supply after 
    /// minting would not exceed the max supply.
    /// @param id ID of the token
    /// @param amount Amount of the token to mint
    function _preMintChecks(uint256 id, uint256 amount) internal view {
        require(id < allTokenData.length, "Token ID does not exist");
        require(
            totalSupply(id) + amount <= allTokenData[id].maxSupply,
            "Exceeds max supply"
        );
    }

    /// @notice Internal function to perform post-mint checks
    /// @dev If the total supply of the token equals the max supply, 
    /// the token sale is deactivated.
    /// @param id ID of the token
    function _postMintChecks(uint256 id) internal {
        if (totalSupply(id) == allTokenData[id].maxSupply) {
            allTokenData[id].isTokenSaleActive = false;
        }
    }

    /// @notice Updates the token balances
    /// @param from Address sending the tokens
    /// @param to Address receiving the tokens
    /// @param ids Array of token IDs being transferred
    /// @param values Array of amounts of tokens being transferred
    function _update(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory values
    ) internal override(ERC1155, ERC1155Supply) {
        super._update(from, to, ids, values);
    }
}
