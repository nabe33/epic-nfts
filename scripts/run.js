// run.js
const main = async () => {
  // コントラクトがコンパイルします
  // コントラクトを扱うために必要なファイルが'artifcts'ディレクトリの直下に生成される
  const nftContractFactory = await hre.ethers.getContractFactory("MyEpicNFT");
  // HardhatがローカルなEternetを作成
  const nftContract = await nftContractFactory.deploy();
  // コントラクトがMintされ，ローカルのブロックチェーンにdeployされるまで待つ
  await nftContract.deployed();
  console.log("Contract deployes to:", nftContract.address);

  // makeAnEpicNFT関数を呼び出すとNFTがMINTされる
  let txn = await nftContract.makeAnEpicNFT();
  // Mintingが仮想マイナーによって承認されるのを待つ
  await txn.wait();
  // makeAnEpicNFT関数をもう一度呼び出す．NFTがまたMINTされる
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