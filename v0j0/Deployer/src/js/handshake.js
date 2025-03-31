const web3 = new Web3("https://eth-mainnet.g.alchemy.com/v2/ntDFj2vzjk0_DT1C2hmgzvbF9VMhzGW7"); // Production API link locked to domain and contracts. :)

const ADDRESS = "0x74C093fD987Fff140677Aa83B6CC4680B8ef2956";
// const mainContractAlchemy = new web3.eth.Contract(HAIKU_ABI, ADDRESS);

let web3User = null; // For MetaMask or any Ethereum-compatible wallet
let uriContractUser = null

/*****************************************/
/* Detect the MetaMask Ethereum provider */
/*****************************************/
async function getProvider(){
    const provider = await detectEthereumProvider();
    if (provider) {
        startApp(provider);
    } else {
        console.log('Please install MetaMask!');
    }
}

getProvider();

function startApp(provider) {
    if (provider !== window.ethereum) {
        console.error('Do you have multiple wallets installed?');
    }
    web3User = new Web3(provider); // Initialize user's web3

    // Now initialize the user's contract object
    // uriContractUser = new web3User.eth.Contract(HAIKU_ABI, ADDRESS);

    // Attach event handlers
    ethereum.on('chainChanged', handleChainChanged);
    ethereum.on('accountsChanged', handleAccountsChanged);

    // Check for existing accounts
    ethereum
        .request({ method: 'eth_accounts' })
        .then(handleAccountsChanged)
        .catch(handleError);
}

function handleChainChanged() {
    window.location.reload();
}

let currentAccount = null;

function handleAccountsChanged(accounts) {
    if (accounts.length === 0) {
        console.log('Please connect to MetaMask.');
        document.getElementById("connect-button-text").innerHTML =
          "Connect MetaMask";
    } else if (accounts[0] !== currentAccount) {
        currentAccount = accounts[0];
        console.log("Account connected:", currentAccount);
        document.getElementById("connect-button-text").innerHTML =
          `Wallet Connected: ${currentAccount}`;
        // if (currentAccount === "0xA6a4Fe416F8Bf46bc3bCA068aC8b1fC4DF760653") {
        //   document.getElementById("connect-button-text").innerHTML =
        //     "Artist Wallet Connected";
        // } else {
        //   document.getElementById("connect-button-text").innerHTML =
        //     "Wrong Wallet Connected!";
        // }
    }
}

function handleError(error) {
    console.error(error);
}

function connectWallet() {
    ethereum
        .request({ method: 'eth_requestAccounts' })
        .then(handleAccountsChanged)
        .catch(handleError);
}