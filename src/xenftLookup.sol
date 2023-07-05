pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

interface IXENTorrent {
    function vmuCount(uint256 tokenId) external view returns (uint256);
    function xenBurned(uint256 tokenId) external view returns (uint256);
    function mintInfo(uint256 tokenId) external view returns (uint256);
}

contract XenftLookup {
    using Strings for uint256;

    IXENTorrent private xentorrent;
    IERC721 private erc721; // Replace with the correct ERC721 contract interface

    constructor(address xentorrentAddress, address erc721Address) {
        xentorrent = IXENTorrent(xentorrentAddress);
        erc721 = IERC721(erc721Address);
    }

    function getNFTInfoAttributes(uint256 tokenId) public view returns (
        uint256,
        uint256,
        uint256,
        uint256,
        uint256,
        uint256,
        uint256
    ) {
        require(xentorrent.vmuCount(tokenId) > 0, "NFTAttributesLookup: Invalid token ID");

        uint256 info = xentorrent.mintInfo(tokenId);

        return (
            tokenId,
            xentorrent.vmuCount(tokenId),
            xentorrent.xenBurned(tokenId),
            (info >> 240) & 0xFFFF, // term
            (info >> 176) & 0xFFFFFFFFFFFFFFFF, // maturityTs
            (info >> 48) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, // rank
            (info >> 32) & 0xFFFF // amp
        );
    }

    function getNFTExtraAttributes(uint256 tokenId) public view returns (
        uint256,
        bool,
        bool,
        address,
        bool
    ) {
        require(xentorrent.vmuCount(tokenId) > 0, "NFTAttributesLookup: Invalid token ID");

        uint256 info = xentorrent.mintInfo(tokenId);

        return (
            (info >> 16) & 0xFFFF, // eaa
            ((info >> 15) & 1) != 0, // apex
            ((info >> 14) & 1) != 0, // limited
            erc721.ownerOf(tokenId), // owner
            (info & 1) != 0 // redeemed
        );
    }

  

    function getNFTProgress(uint256 tokenId) public view returns (uint256) {
        (,, , uint256 term, uint256 maturityTs,,) = getNFTInfoAttributes(tokenId);
        uint256 termInSeconds = term * 1 days;
        
        // Check if termInSeconds is larger than maturityTs
        if (termInSeconds > maturityTs) {
            return 0;
        }
        
        uint256 startTs = maturityTs - termInSeconds;
        uint256 currentTime = block.timestamp;

        if(currentTime < startTs) {
            return 0;
        } else if(currentTime > maturityTs) {
            return 100;
        } else {
            uint256 totalDuration = maturityTs - startTs;
            uint256 elapsedDuration = currentTime - startTs;

            // Calculate the progress as a percentage
            // Multiply by 100 first to avoid truncation when dividing.
            uint256 progress = (elapsedDuration * 100) / totalDuration;
            return progress;
        }
    }




    function _decodeMintInfo(uint256 info) private pure returns (string memory) {
        // decode mint info here
        // ...
    }

    function addressToUint256(address _address) private pure returns (uint256) {
        return uint256(uint160(_address));
    }


    function addressToString(address _address) private pure returns (string memory) {
        uint256 value = addressToUint256(_address);
        bytes32 valueBytes = bytes32(value);
        bytes memory alphabet = "0123456789abcdef";

        bytes memory str = new bytes(42);
        str[0] = '0';
        str[1] = 'x';
        for (uint256 i = 0; i < 20; i++) {
            str[2 + i * 2] = alphabet[uint8(valueBytes[i + 12] >> 4)];
            str[3 + i * 2] = alphabet[uint8(valueBytes[i + 12] & 0x0f)];
        }

        return string(str);
    }


}