// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract NFTMarketplace {

    struct Seller {
        address sellerAddress;
        uint256 totalEarnings;
    }

    struct NFT {
        uint256 tokenId;
        uint256 price;
        bool isSold;
        Seller sellerInfo;
    }

    mapping(uint256 => NFT) public listings;

    function listNFT(uint256 tokenId, uint256 price) external {
        require(price > 0, "Invalid price");

        listings[tokenId] = NFT({
            tokenId: tokenId,
            price: price,
            isSold: false,
            sellerInfo: Seller({
                sellerAddress: msg.sender,
                totalEarnings: 0
            })
        });
    }

    function buyNFT(uint256 tokenId) external payable {
        NFT storage item = listings[tokenId];

        require(!item.isSold, "Already sold");
        require(msg.value == item.price, "Incorrect ETH");

        item.isSold = true;
        item.sellerInfo.totalEarnings += msg.value;

       // payable(item.sellerInfo.sellerAddress).transfer(msg.value);

        (bool success,) = payable(item.sellerInfo.sellerAddress).call{value: msg.value}("");
        require(success,"transaction failed");
    }
}


// contract address - 0x020009F03aad00cc8e848218A7112A2aAE550374