# XenftLookup (Development Version)

⚠️ **IMPORTANT**: This version of XenftLookup Solidity smart contract is currently under active development and is **NOT** ready for production use. It's highly recommended to test and adjust the contract according to your own requirements before using it for any production level applications.

XenftLookup is an open-source Ethereum contract designed to provide an interface for interacting with XENft Non-Fungible Tokens (NFTs). It provides foundational functionality for looking up specific information about NFTs based on their unique token ID. Its ease-of-use design allows anyone to integrate it into their decentralized applications (dApps).

## Features

- Retrieve detailed information about a specific NFT, including VMU count, XEN tokens burned, term, maturity timestamp, rank, and amp.
- Get additional attributes like EAA, Apex status, whether it's limited, and the owner of the NFT.
- Calculate the progress of the NFT based on its term and maturity timestamp, returned as a percentage.
- Convert an Ethereum address into a uint256 or a string, handy for various utility purposes.
- Interact with the `xentorrent` and a specified ERC721 contract directly.

## Setup & Installation



1. Make sure you have `nodejs` and `npm` installed. You can verify this by running `node -v` and `npm -v`. If you haven't installed these, check out [nodejs.org](https://nodejs.org/) for installation instructions.

2. Install the required npm packages. Run the following command:
```bash
npm install @openzeppelin/contracts
```

3. Clone this repository to your local machine. If you have git installed, run:
```bash
git clone https://github.com/your-repo/XenftLookup
```

## Usage

You will need to import this contract into your existing contract and instantiate it with the addresses of your `xentorrent` contract and ERC721 contract.

Below is an example of how you might do this:

```solidity
import "./XenftLookup.sol";

contract MyContract {
    XenftLookup private xenftLookup;

    constructor() {
        xenftLookup = new XenftLookup(xentorrentAddress, erc721Address);
    }

    function someFunction(uint256 tokenId) public {
        uint256 progress = xenftLookup.getNFTProgress(tokenId);
        // Do something with the progress...
    }
}
```

## Testing

This contract has been thoroughly tested through Foundry testing.

To run tests locally, use the following command:
```bash
npm run test
```

## Contributing

We welcome contributions from the community. If you'd like to contribute, please fork the repository, make your changes, and submit a pull request.

For any major changes, please open an issue first to discuss what you would like to change.

## License

This project is open-source, provided under the MIT License. See [LICENSE.md](LICENSE.md) for details.