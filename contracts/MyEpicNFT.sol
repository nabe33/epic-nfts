// MyEpicNFT.sol
// SPDX-License-Identifier: MIT
// 2023/1/19(&2/6,10) T. Watanabe

pragma solidity ^0.8.17;

// いくつかの OpenZeppelinコントラクトをimport
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

// SVGとJSONをBase64に変換する関数
import { Base64 } from "./libraries/Base64.sol";

// importしたOpenZeppelinのコントラクトを継承して
// 継承したコントラクトのメソッドにアクセスできるようになる．ERC721=NFT
contract MyEpicNFT is ERC721URIStorage {
  // OpenZeppelinがtokenIdsを簡単に追跡するために提供するライブラリを呼び出す
  using Counters for Counters.Counter;
  // _tokenIds初期化 (_tokenIds = 0)
  Counters.Counter private _tokenIds;

  // SVGコードを作成．変更されるのは表示する単語のみ．
  // すべてのNFTにSVGコードを適用するために，baseSvg変数を作成
  string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

  // 3つの配列 string[]にランダムな単語を設定
  string[] firstWords = ["Big", "Small", "High", "Low", "Wide", "Narrow", "Giant", "Tiny", "Fast", "Slow"];
  string[] secondWords = ["Red", "White", "Yellow", "Green", "Black", "Blue", "Transparent", "Violet", "Orange", "Purple"];
  string[] thirdWords = ["Boy", "Girl", "Dog", "Cat", "Pig", "Flower", "Woods", "Cloud", "Osean", "Mountains"];


  // event設定
  event NewEpicNFTMinted(address sender, uint256 tokenId);

  // NFTトークンの名前とそのシンボルを渡す
  constructor() ERC721 ("nabeNFT", "nabe") {
    console.log("This is my NFT contract.");
  }

  // シードを生成する関数を作成
  function random(string memory input) internal pure returns (uint256) {
    return uint256(keccak256(abi.encodePacked(input)));
  }

  // 各配列からランダムに単語を選ぶ関数を3つ作成

  // pickRandomFirstWords関数は3セットの最初の単語を選ぶ
  function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {
    // seedとなるrandを作成
    uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
    console.log("seed rand: ", rand);
    // firstWords配列の長さを基準に rand番目の単語を選ぶ
    rand = rand % firstWords.length;
    console.log("randomly selected first word: rand=", rand);
    return firstWords[rand];
  }

  // pickRandomSecondWords関数は3セットの2番目の単語を選ぶ
  function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
    rand = rand % secondWords.length;
    return secondWords[rand];
  }

  // pickRandomThirdWords関数は3セットの3番目の単語を選ぶ
  function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
    rand = rand % thirdWords.length;
    return thirdWords[rand];
  }


  // ************* ************* ************* *************
  // ユーザ(フロントエンド)がNFTのミント数を取得するためのgetter関数
  function getMintCounter() public view returns (uint) {
    uint256 newMintId = _tokenIds.current();
    console.log("getMintCounter/newMintId; ", newMintId);
    return newMintId; // newItemId
  }

  // ユーザが(フロントエンド)NFTを取得するために実行する関数 
  function makeAnEpicNFT() public {
    // 現在のtokenId（0から始まる）を取得
    uint256 newItemId = _tokenIds.current();
    
    // MintできるNFTの数を制限
    console.log("**********************");
    console.log("newItemId: ", newItemId);
    if ( newItemId >= 10 ) { return; }
    console.log("Still lower than the allowed Mint numbers");

    // 3つの配列からそれぞれ1単語をランダムに取り出す
    string memory first = pickRandomFirstWord(newItemId);
    string memory second = pickRandomSecondWord(newItemId);
    string memory third = pickRandomThirdWord(newItemId);

    string memory combinedWord = string(abi.encodePacked(first, second, third));

    // 3つの単語を連結してSVGを完成させる
    string memory finalSvg = string(abi.encodePacked(baseSvg, combinedWord,"</text></svg>"));
    //console.log("\n------ SVG data -------");
    //console.log(finalSvg);
    //console.log("-----------------------\n");

    // JSONファイルを所定の位置に取得してbase64としてエンコード
    string memory json = Base64.encode(
      bytes(
        string(
          abi.encodePacked(
            '{"name": "',
            // NFTのタイトル（生成された単語が入る場所）
            combinedWord,
            '", "description": "A highly acclaimed NFT collection of squares.", "image": "data:image/svg+xml;base64,',
            // SVGをbase64でエンコードした結果を返す
            Base64.encode(bytes(finalSvg)),
            '"}'
          )
        )
      )
    );
    
    // データの先頭に data:application/json;base64 を追加
    string memory finalTokenUri = string(
      abi.encodePacked("data:application/json;base64,", json)
    );

    //console.log("\n----- Token URI -----");
    //console.log(finalTokenUri);
    //console.log("---------------------\n");

    // msg.senderを使ってNFTを送信者にMint
    _safeMint(msg.sender, newItemId);

    //tokenURLを設定
    _setTokenURI(newItemId, finalTokenUri);
    //_setTokenURI(newItemId, "data:application/json;base64,ewogICJuYW1lIjogIkVwaWNOZnRDcmVhdG9yIiwKICAiZGVzY3JpcHRpb24iOiAiVGhlIGhpZ2hseSBhY2NsYWltZWQgc3F1YXJlIGNvbGxlY3Rpb24iLAogICJpbWFnZSI6ICJkYXRhOmltYWdlL3N2Zyt4bWw7YmFzZTY0LFBITjJad29nSUhodGJHNXpQU0pvZEhSd09pOHZkM2QzTG5jekxtOXlaeTh5TURBd0wzTjJaeUlLSUNCd2NtVnpaWEoyWlVGemNHVmpkRkpoZEdsdlBTSjRUV2x1V1UxcGJpQnRaV1YwSWdvZ0lIWnBaWGRDYjNnOUlqQWdNQ0F6TlRBZ016VXdJZ28rQ2lBZ1BITjBlV3hsUGdvZ0lDQWdMbUpoYzJVZ2V3b2dJQ0FnSUNCbWFXeHNPaUIzYUdsMFpUc0tJQ0FnSUNBZ1ptOXVkQzFtWVcxcGJIazZJSE5sY21sbU93b2dJQ0FnSUNCbWIyNTBMWE5wZW1VNklERTBjSGc3Q2lBZ0lDQjlDaUFnUEM5emRIbHNaVDRLSUNBOGNtVmpkQ0IzYVdSMGFEMGlNVEF3SlNJZ2FHVnBaMmgwUFNJeE1EQWxJaUJtYVd4c1BTSmliR0ZqYXlJZ0x6NEtJQ0E4ZEdWNGRBb2dJQ0FnZUQwaU5UQWxJZ29nSUNBZ2VUMGlOVEFsSWdvZ0lDQWdZMnhoYzNNOUltSmhjMlVpQ2lBZ0lDQmtiMjFwYm1GdWRDMWlZWE5sYkdsdVpUMGliV2xrWkd4bElnb2dJQ0FnZEdWNGRDMWhibU5vYjNJOUltMXBaR1JzWlNJS0lDQStDaUFnSUNCRmNHbGpUbVowUTNKbFlYUnZjZ29nSUR3dmRHVjRkRDRLUEM5emRtYysiCn0=");
    //_setTokenURI(newItemId, "https://api.npoint.io/1de1805e61c8b6d38faa");

    // NFTがいつ誰に作成されたかを確認
    console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

    // 次のNFTがMINTされるときのカウンターをインクリメント
    _tokenIds.increment();

    // eventをemit
    emit NewEpicNFTMinted(msg.sender, newItemId);
  }
}
