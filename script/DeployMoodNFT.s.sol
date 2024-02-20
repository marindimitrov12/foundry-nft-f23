//SPDX-License-Identifier:MIT

pragma solidity 0.8.20;

import {Script,console}from "forge-std/Script.sol";
import {MoodNft}from "../src/MoodNft.sol";
import {Base64}from "@openzeppelin/contracts/utils/Base64.sol";
contract DeployMoodNFT is Script{
    MoodNft moodNft;

 function run()external returns(MoodNft){
  string memory sadSvg=vm.readFile("./images/sad.svg");
  string memory happySvg=vm.readFile("./images/happy.svg");
  vm.startBroadcast();
  moodNft=new MoodNft(svgToImageURI(sadSvg),svgToImageURI(happySvg));
  vm.stopBroadcast();
  return moodNft;
 }
 function svgToImageURI(string memory svg)public pure returns(string memory){
    string memory baseURL="data:image/svg+xml;base64,";
    string memory svgBse64Encoded=Base64.encode(bytes(string(abi.encodePacked(svg))));
    return string(abi.encodePacked(baseURL,svgBse64Encoded));
 }
 
}