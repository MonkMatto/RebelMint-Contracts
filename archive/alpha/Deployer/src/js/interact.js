/**
 * Deploy the contract
 */
async function deploy() {
  // Check prerequisites
  if (!window.ethereum) {
    alert("MetaMask not detected! Please install MetaMask.");
    return;
  }

  if (!currentAccount) {
    alert("Please connect your wallet first");
    return;
  }

  if (!ABI || !CBC) {
    console.error("Contract data missing:", { ABI: !!ABI, CBC: !!CBC });
    alert("Contract data not available. Check your console for more details.");
    return;
  }

  // Update UI
  const deployBtn = document.getElementById("deploy-btn");
  const statusText = document.getElementById("mint-next-text");
  const statusElement = document.getElementById("deployment-status");

  try {
    // Update UI to show deployment in progress
    if (statusText) statusText.textContent = "Deploying...";
    if (deployBtn) deployBtn.disabled = true;
    if (statusElement) {
      statusElement.textContent = "Deployment in progress...";
      statusElement.style.color = "orange";
    }

    console.log("Creating contract instance...");

    // Create contract instance with user's web3
    const contract = new web3User.eth.Contract(ABI);

    // Prepare deployment transaction
    const bytecode = CBC.startsWith("0x") ? CBC : `0x${CBC}`;
    const deployTx = contract.deploy({
      data: bytecode,
      arguments: [], // Add constructor arguments if needed
    });

    // Estimate gas
    console.log("Estimating gas...");
    let gasEstimate;
    try {
      gasEstimate = await deployTx.estimateGas({ from: currentAccount });
      // Add 20% buffer
      gasEstimate = Math.floor(gasEstimate * 1.2);
      console.log("Gas estimate with buffer:", gasEstimate);
    } catch (gasError) {
      console.warn("Gas estimation failed:", gasError);
      gasEstimate = 3000000; // Fallback
      console.log("Using fallback gas limit:", gasEstimate);
    }

    // Deploy the contract
    console.log("Sending deployment transaction...");
    const deployedContract = await deployTx.send({
      from: currentAccount,
      gas: gasEstimate,
    });

    // Deployment successful
    const contractAddress = deployedContract.options.address;
    console.log("Contract deployed at:", contractAddress);

    // Update UI with success
    if (statusText) statusText.textContent = "Deployed!";
    if (statusElement) {
      statusElement.innerHTML = `Contract deployed at: <a href="https://etherscan.io/address/${contractAddress}" target="_blank">${contractAddress}</a>`;
      statusElement.style.color = "green";
    }

    // Enable the button after delay
    setTimeout(() => {
      if (deployBtn) deployBtn.disabled = false;
      if (statusText) statusText.textContent = "Deploy Again";
    }, 3000);
  } catch (error) {
    // Handle deployment error
    console.error("Deployment failed:", error);

    // Update UI with error
    if (statusText) statusText.textContent = "Deploy Failed";
    if (statusElement) {
      statusElement.textContent = `Error: ${error.message || "Unknown error"}`;
      statusElement.style.color = "red";
    }

    // Alert the user
    alert(`Deployment failed: ${error.message || "Unknown error"}`);

    // Reset the button after delay
    setTimeout(() => {
      if (deployBtn) deployBtn.disabled = false;
      if (statusText) statusText.textContent = "Deploy";
    }, 3000);
  }
}
