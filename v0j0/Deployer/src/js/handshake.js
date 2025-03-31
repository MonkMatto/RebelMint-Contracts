// For MetaMask wallet
let web3User = null;
let currentAccount = null;

/**
 * Initialize the app when the window loads
 */
function initApp() {
  console.log("Initializing app...");

  // Update UI elements
  updateConnectionStatus();

  // Set up event listeners for MetaMask if it exists
  if (typeof window.ethereum !== "undefined") {
    console.log("MetaMask is installed!");

    // Listen for account changes
    window.ethereum.on("accountsChanged", (accounts) => {
      console.log("Accounts changed:", accounts);
      handleAccountsChanged(accounts);
    });

    // Listen for chain changes
    window.ethereum.on("chainChanged", () => {
      console.log("Chain changed, reloading...");
      window.location.reload();
    });

    // Check if already connected
    window.ethereum
      .request({ method: "eth_accounts" })
      .then(handleAccountsChanged)
      .catch((error) => {
        console.error("Error checking accounts:", error);
      });

    // Initialize web3 with MetaMask provider
    web3User = new Web3(window.ethereum);
  } else {
    console.log("MetaMask is not installed");
  }
}

/**
 * Handle account changes from MetaMask
 */
function handleAccountsChanged(accounts) {
  if (accounts.length === 0) {
    // No accounts connected
    currentAccount = null;
    document.getElementById("connect-button-text").innerHTML =
      "Connect MetaMask";
    console.log("No accounts connected");
  } else if (accounts[0] !== currentAccount) {
    // New account connected
    currentAccount = accounts[0];
    document.getElementById(
      "connect-button-text"
    ).innerHTML = `Connected: ${currentAccount.substring(
      0,
      6
    )}...${currentAccount.substring(38)}`;
    console.log("Account connected:", currentAccount);
  }

  // Update deploy button status
  updateDeployButtonStatus();
  updateConnectionStatus();
}

/**
 * Connect wallet when the connect button is clicked
 */
function connectWallet() {
  if (typeof window.ethereum === "undefined") {
    alert(
      "MetaMask is not installed! Please install MetaMask to use this application."
    );
    return;
  }

  console.log("Requesting accounts...");
  window.ethereum
    .request({ method: "eth_requestAccounts" })
    .then(handleAccountsChanged)
    .catch((error) => {
      if (error.code === 4001) {
        // User rejected the request
        console.log("User rejected connection request");
      } else {
        console.error("Error connecting to MetaMask:", error);
      }
    });
}

/**
 * Update the deploy button status based on connection
 */
function updateDeployButtonStatus() {
  const deployBtn = document.getElementById("deploy-btn");
  if (deployBtn) {
    deployBtn.disabled = !currentAccount;
  }
}

/**
 * Update connection status display
 */
function updateConnectionStatus() {
  const statusElement = document.getElementById("connection-status");
  if (statusElement) {
    if (!window.ethereum) {
      statusElement.innerHTML = "Status: MetaMask not detected";
      statusElement.style.color = "red";
    } else if (!currentAccount) {
      statusElement.innerHTML = "Status: Not connected";
      statusElement.style.color = "orange";
    } else {
      statusElement.innerHTML = `Status: Connected to ${currentAccount.substring(
        0,
        6
      )}...${currentAccount.substring(38)}`;
      statusElement.style.color = "green";
    }
  }
}

// Initialize the app when the page loads
window.addEventListener("DOMContentLoaded", initApp);
