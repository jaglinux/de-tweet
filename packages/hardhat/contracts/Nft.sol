pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Data} from "./Data.sol";

contract Nft is ERC721 {
    constructor(string memory name, string memory symbol ) ERC721(name, symbol) {
    }

    function MintTweet(Data.tweet storage t) internal {
        
    }
}