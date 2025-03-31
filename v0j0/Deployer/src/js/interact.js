var error;

async function deploy() {
  if (!web3User) {
      console.error('Wallet client not available');
      return;
  }

  if (!ABI || !CBC) {
      console.error('ABI or bytecode not available');
      return;
  }

  try {
      // Create contract instance
      const contract = new web3User.eth.Contract(ABI);

      // Create deployment txn
      const deployTx = contract.deploy({
          data: `0x${CBC}`,
          arguments: [] // Add constructor arguments here if needed
      });

      // Estimate gas
      const gas = await deployTx.estimateGas({ from: currentAccount });

      // Send the transaction to deploy the contract
      const newContractInstance = await deployTx.send({
          from: currentAccount,
          gas: gas
      });

      console.log('Contract deployed at address:', newContractInstance.options.address);
  } catch (error) {
      console.error('Error deploying contract:', error);
  }
}