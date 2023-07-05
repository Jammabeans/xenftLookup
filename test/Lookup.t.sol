// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/xenftLookup.sol";

interface ITestXENTorrent {
    function vmuCount(uint256 tokenId) external view returns (uint256);
    function xenBurned(uint256 tokenId) external view returns (uint256);
    function mintInfo(uint256 tokenId) external view returns (uint256);
}

contract XenftLookupTest is Test {
    XenftLookup public xenftLookupInstance;
    ITestXENTorrent public xentorrentInstance;
    address public xentorrentAddress = 0x0a252663DBCc0b073063D6420a40319e438Cfa59; // Replace with the real XENTorrent contract address
    
    function setUp() public {
        xenftLookupInstance = new XenftLookup(xentorrentAddress, xentorrentAddress);
        xentorrentInstance = ITestXENTorrent(xentorrentAddress);
    }
    
    function testGetNFTAttributes() public view{
        uint256 tokenId = 1; // Replace with the desired token ID to test

        // Call the getNFTInfoAttributes function from XenftLookup
        (
            uint256 tokenIdReturned,
            uint256 count,
            uint256 burned,
            uint256 term,
            uint256 maturityTs,
            uint256 rank,
            uint256 amp
        ) = xenftLookupInstance.getNFTInfoAttributes(tokenId);

        // Log the attributes for testing purposes
        console.log("Token ID: ", tokenIdReturned);
        console.log("VMU Count: ", count);
        console.log("XEN Burned: ", burned);
        console.log("Term: ", term);
        console.log("Maturity Timestamp: ", maturityTs);
        console.log("Rank: ", rank);
        console.log("AMP: ", amp);

        // Call the getNFTExtraAttributes function from XenftLookup
        (
            uint256 eaa,
            bool apex,
            bool limited,
            address owner,
            bool redeemed
        ) = xenftLookupInstance.getNFTExtraAttributes(tokenId);

        // Log the attributes for testing purposes
        console.log("EAA: ", eaa);
        console.log("Apex: ", apex);
        console.log("Limited: ", limited);
        console.log("Owner: ", owner);
        console.log("Redeemed: ", redeemed);

        // Add assertions to verify the returned attributes if necessary
    }

    function testRawMintInfo() public view{
        uint256 tokenId = 1; // Replace with the desired token ID to test
        uint256 info = xentorrentInstance.mintInfo(tokenId);

        // Log the raw mintInfo data for testing purposes
        console.log("Raw mintInfo data: ", info);
    }

    function testGetNFTProgress() public view{
        uint256 tokenId = 1; // Replace with the desired token ID to test

        // Call the getNFTProgress function from XenftLookup
        uint256 progress = xenftLookupInstance.getNFTProgress(tokenId);

        // Log the progress for testing purposes
        console.log("Progress: ", progress);

        // Add assertions to verify the returned progress if necessary
    }
    
    function testGetNFTSVGImage() public view{
        uint256 tokenId = 1; // Replace with the desired token ID to test

        // Call the getNFTSVGImage function from XenftLookup
        bytes memory svgImage = xenftLookupInstance.getNFTSVGImage(tokenId);

        // Convert byte array to hex string
        string memory svgHexString = bytesToHexString(svgImage);

        // Log the complete SVG image hex string for testing purposes
        console.log(svgHexString);
    }

    // Helper function to convert bytes array to hex string
    function bytesToHexString(bytes memory _bytes) private pure returns (string memory) {
        bytes memory hexString = new bytes(_bytes.length * 2);
        uint256 j = 0;
        for (uint256 i = 0; i < _bytes.length; i++) {
            uint8 byteValue = uint8(_bytes[i]);
            bytes2 char1 = bytes2(uint16(byteValue) << 8);
            bytes2 char2 = bytes2(uint16(byteValue));
            hexString[j++] = char1[0];
            hexString[j++] = char2[0];
        }
        return string(hexString);
    }
}
