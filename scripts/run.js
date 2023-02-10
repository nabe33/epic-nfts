// run.js
const main = async () => {
  // コントラクトがコンパイルします
  // コントラクトを扱うために必要なファイルが'artifcts'ディレクトリの直下に生成される
  const nftContractFactory = await hre.ethers.getContractFactory("MyEpicNFT");
  // HardhatがローカルなEternetを作成
  const nftContract = await nftContractFactory.deploy();
  // コントラクトがMintされ，ローカルのブロックチェーンにdeployされるまで待つ
  await nftContract.deployed();
  console.log("run.js::Contract deployes to:", nftContract.address);
   //
   let MintedId = await nftContract.getMintCounter();
   console.log("run.js/MintId: ", MintedId);

  // makeAnEpicNFT関数を呼び出すとNFTがMINTされる
  let txn = await nftContract.makeAnEpicNFT();
  // Mintingが仮想マイナーによって承認されるのを待つ
  await txn.wait();

  // makeAnEpicNFT関数をもう一度呼び出す．NFTがまたMINTされる
  txn = await nftContract.makeAnEpicNFT();
  // Mintingが仮想マイナーによって承認されるのを待つ
  await txn.wait();

  // makeAnEpicNFT関数を3回目に呼び出す．NFTがまたMINTされる
  txn = await nftContract.makeAnEpicNFT();
  // Mintingが仮想マイナーによって承認されるのを待つ
  await txn.wait();

  // makeAnEpicNFT関数を4回目に呼び出す．NFTがまたMINTされる
  txn = await nftContract.makeAnEpicNFT();
  // Mintingが仮想マイナーによって承認されるのを待つ
  await txn.wait();

  // makeAnEpicNFT関数を5回目に呼び出す．これは生成数制限で拒否されるはず
  txn = await nftContract.makeAnEpicNFT();
  // Mintingが仮想マイナーによって承認されるのを待つ
  await txn.wait();

  // makeAnEpicNFT関数を5回目に呼び出す．これは生成数制限で拒否されるはず
  txn = await nftContract.makeAnEpicNFT();
  // Mintingが仮想マイナーによって承認されるのを待つ
  await txn.wait();
};

// エラー処理
const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();