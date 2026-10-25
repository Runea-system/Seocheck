// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

/// @title Moondeng - 2,222 baby hippos on BNB Chain
/// Mint by wallet or by Binance Agentic Wallet (any wallet can call).
contract Moondeng is ERC721, Ownable {
    using Strings for uint256;

    uint256 public constant MAX_SUPPLY = 2222;
    uint256[5] public tierPrice = [
        0.0002 ether, // 0 Free
        0.001 ether,  // 1 Splash
        0.002 ether,  // 2 Cool
        0.003 ether,  // 3 Astro
        0.004 ether   // 4 King
    ];

    uint256 public maxPerWallet = 5;
    uint256 public totalMinted;
    bool public mintOpen;
    string private baseURI;

    mapping(address => uint256) public mintedBy;
    mapping(uint256 => uint8) public tierOf;

    constructor(string memory _baseURI, address _owner) ERC721("Moondeng", "MOODENG") Ownable(_owner) {
        baseURI = _baseURI;
    }

    // ---------- mint ----------
    function freeMint(uint256 qty) external payable {
        _mintTier(0, qty);
    }

    /// tier 1-4: 0.001 / 0.002 / 0.003 / 0.004 BNB each
    function mintTier(uint8 tier, uint256 qty) external payable {
        require(tier >= 1 && tier <= 4, "bad tier");
        _mintTier(tier, qty);
    }

    function _mintTier(uint8 tier, uint256 qty) internal {
        require(mintOpen, "mint closed");
        require(msg.sender == tx.origin, "no contracts");
        require(qty > 0, "qty 0");
        require(totalMinted + qty <= MAX_SUPPLY, "sold out");
        require(mintedBy[msg.sender] + qty <= maxPerWallet, "wallet limit");
        require(msg.value == tierPrice[tier] * qty, "wrong BNB amount");

        mintedBy[msg.sender] += qty;
        for (uint256 i = 0; i < qty; i++) {
            uint256 id = ++totalMinted;
            tierOf[id] = tier;
            _safeMint(msg.sender, id);
        }
    }

    // ---------- metadata ----------
    function tokenURI(uint256 id) public view override returns (string memory) {
        _requireOwned(id);
        return string(abi.encodePacked(baseURI, id.toString(), ".json"));
    }

    // ---------- owner ----------
    function setMintOpen(bool open) external onlyOwner { mintOpen = open; }
    function setBaseURI(string calldata uri) external onlyOwner { baseURI = uri; }
    function setMaxPerWallet(uint256 m) external onlyOwner { maxPerWallet = m; }

    function withdraw() external onlyOwner {
        (bool ok, ) = payable(owner()).call{value: address(this).balance}("");
        require(ok, "withdraw failed");
    }
}
