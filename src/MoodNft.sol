//SPDX-License-Identifier:MIT

pragma solidity 0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64}from"@openzeppelin/contracts/utils/Base64.sol";
contract MoodNft is ERC721{
    //Errors
    error MoodNft__CantFlipMoodIfNotOwner();
    uint256 private s_tokenCounter;
    string private s_sadSvgImageUri;
    string private s_happySvgImageuri;


    enum Mood{
        HAPPY,
        SAD
    }
    mapping(uint256=>Mood)private s_tokenIdtoMood;
    constructor(string memory sadSvgImageUri,string memory happySvgImageUri) ERC721("MoodNft","MN"){

        s_tokenCounter=0;
        s_happySvgImageuri=happySvgImageUri;
        s_sadSvgImageUri=sadSvgImageUri;
    }
    function mintNft()public{
      _safeMint(msg.sender,s_tokenCounter);
      s_tokenIdtoMood[s_tokenCounter]=Mood.HAPPY;
      s_tokenCounter++;
    }
    function flipMood(uint256 tokenId)public{
        //only want the nft owner to be able to change the mood
        if(_ownerOf(tokenId)!=msg.sender){
            revert MoodNft__CantFlipMoodIfNotOwner();
        }
        if(s_tokenIdtoMood[tokenId]==Mood.HAPPY){
          s_tokenIdtoMood[tokenId]=Mood.SAD;
        }
        else{
            s_tokenIdtoMood[tokenId]=Mood.HAPPY;
        }
    }
    function _baseURI()internal pure override returns (string memory){
        return "data:application/json;base64,";
    }

    function tokenURI(uint256 tokenId)public view override returns (string memory){
        string memory imageURI;
        if(s_tokenIdtoMood[tokenId]==Mood.HAPPY){
          imageURI=s_happySvgImageuri;
        }else{
            imageURI=s_sadSvgImageUri;
        }
        return string(
       abi.encodePacked(
        _baseURI()
        ,Base64.encode( bytes(abi.encodePacked('{"name":"',name(),'", "description:An nft that reflects the owners mood.", "attributes":[{"trait_type":"moodines","value":100}], "image":"',imageURI,'"  }')))))
        ;
    }

}