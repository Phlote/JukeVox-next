//PROXY ADDRESS
export const CuratorAddress = "0x85E6b6F7Bcf9d5f701851661C8D582977AA8304f"

//Implementation Address
export const CuratorImplementationAddress = "0x2f7DCF3c296F74b172be8ffDDa7bf6bEdA72d0D9"

export const CuratorABI = [
  {
    "anonymous": false,
    "inputs": [{
      "indexed": true,
      "internalType": "address",
      "name": "cosigner",
      "type": "address"
    }, {
      "indexed": false,
      "internalType": "contract Hotdrop",
      "name": "hotdrop",
      "type": "address"
    }, { "indexed": false, "internalType": "uint256", "name": "cosignEdition", "type": "uint256" }],
    "name": "Cosign",
    "type": "event"
  }, {
    "anonymous": false,
    "inputs": [{ "indexed": false, "internalType": "uint8", "name": "version", "type": "uint8" }],
    "name": "Initialized",
    "type": "event"
  }, {
    "anonymous": false,
    "inputs": [{ "indexed": false, "internalType": "address", "name": "account", "type": "address" }],
    "name": "Paused",
    "type": "event"
  }, {
    "anonymous": false,
    "inputs": [{ "indexed": true, "internalType": "bytes32", "name": "role", "type": "bytes32" }, {
      "indexed": true,
      "internalType": "bytes32",
      "name": "previousAdminRole",
      "type": "bytes32"
    }, { "indexed": true, "internalType": "bytes32", "name": "newAdminRole", "type": "bytes32" }],
    "name": "RoleAdminChanged",
    "type": "event"
  }, {
    "anonymous": false,
    "inputs": [{ "indexed": true, "internalType": "bytes32", "name": "role", "type": "bytes32" }, {
      "indexed": true,
      "internalType": "address",
      "name": "account",
      "type": "address"
    }, { "indexed": true, "internalType": "address", "name": "sender", "type": "address" }],
    "name": "RoleGranted",
    "type": "event"
  }, {
    "anonymous": false,
    "inputs": [{ "indexed": true, "internalType": "bytes32", "name": "role", "type": "bytes32" }, {
      "indexed": true,
      "internalType": "address",
      "name": "account",
      "type": "address"
    }, { "indexed": true, "internalType": "address", "name": "sender", "type": "address" }],
    "name": "RoleRevoked",
    "type": "event"
  }, {
    "anonymous": false,
    "inputs": [{
      "indexed": true,
      "internalType": "address",
      "name": "submitter",
      "type": "address"
    }, { "indexed": false, "internalType": "string", "name": "ipfsURI", "type": "string" }, {
      "indexed": false,
      "internalType": "bool",
      "name": "_isArtistSubmission",
      "type": "bool"
    }, { "indexed": false, "internalType": "contract Hotdrop", "name": "hotdrop", "type": "address" }],
    "name": "Submit",
    "type": "event"
  }, {
    "anonymous": false,
    "inputs": [{ "indexed": false, "internalType": "address", "name": "account", "type": "address" }],
    "name": "Unpaused",
    "type": "event"
  }, {
    "inputs": [],
    "name": "CURATOR",
    "outputs": [{ "internalType": "bytes32", "name": "", "type": "bytes32" }],
    "stateMutability": "view",
    "type": "function"
  }, {
    "inputs": [],
    "name": "CURATOR_ADMIN",
    "outputs": [{ "internalType": "bytes32", "name": "", "type": "bytes32" }],
    "stateMutability": "view",
    "type": "function"
  }, {
    "inputs": [],
    "name": "DEFAULT_ADMIN_ROLE",
    "outputs": [{ "internalType": "bytes32", "name": "", "type": "bytes32" }],
    "stateMutability": "view",
    "type": "function"
  }, {
    "inputs": [],
    "name": "admin",
    "outputs": [{ "internalType": "address", "name": "", "type": "address" }],
    "stateMutability": "view",
    "type": "function"
  }, {
    "inputs": [{ "internalType": "contract Hotdrop", "name": "_hotdrop", "type": "address" }],
    "name": "curate",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  }, {
    "inputs": [],
    "name": "curatorAdmin",
    "outputs": [{ "internalType": "address", "name": "", "type": "address" }],
    "stateMutability": "view",
    "type": "function"
  }, {
    "inputs": [],
    "name": "curatorTokenMinimum",
    "outputs": [{ "internalType": "uint256", "name": "", "type": "uint256" }],
    "stateMutability": "view",
    "type": "function"
  }, {
    "inputs": [{ "internalType": "bytes32", "name": "role", "type": "bytes32" }],
    "name": "getRoleAdmin",
    "outputs": [{ "internalType": "bytes32", "name": "", "type": "bytes32" }],
    "stateMutability": "view",
    "type": "function"
  }, {
    "inputs": [{ "internalType": "bytes32", "name": "role", "type": "bytes32" }, {
      "internalType": "uint256",
      "name": "index",
      "type": "uint256"
    }],
    "name": "getRoleMember",
    "outputs": [{ "internalType": "address", "name": "", "type": "address" }],
    "stateMutability": "view",
    "type": "function"
  }, {
    "inputs": [{ "internalType": "bytes32", "name": "role", "type": "bytes32" }],
    "name": "getRoleMemberCount",
    "outputs": [{ "internalType": "uint256", "name": "", "type": "uint256" }],
    "stateMutability": "view",
    "type": "function"
  }, {
    "inputs": [{ "internalType": "address", "name": "_newCurator", "type": "address" }],
    "name": "grantCuratorRole",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  }, {
    "inputs": [{ "internalType": "bytes32", "name": "role", "type": "bytes32" }, {
      "internalType": "address",
      "name": "account",
      "type": "address"
    }], "name": "grantRole", "outputs": [], "stateMutability": "nonpayable", "type": "function"
  }, {
    "inputs": [{ "internalType": "bytes32", "name": "role", "type": "bytes32" }, {
      "internalType": "address",
      "name": "account",
      "type": "address"
    }],
    "name": "hasRole",
    "outputs": [{ "internalType": "bool", "name": "", "type": "bool" }],
    "stateMutability": "view",
    "type": "function"
  }, {
    "inputs": [{
      "internalType": "contract PhloteVote",
      "name": "_phloteToken",
      "type": "address"
    }, { "internalType": "address", "name": "_treasury", "type": "address" }, {
      "internalType": "address",
      "name": "_curatorAdmin",
      "type": "address"
    }], "name": "initialize", "outputs": [], "stateMutability": "nonpayable", "type": "function"
  }, {
    "inputs": [{
      "internalType": "contract PhloteVote",
      "name": "_phloteToken",
      "type": "address"
    }, { "internalType": "address", "name": "_treasury", "type": "address" }, {
      "internalType": "address",
      "name": "_curatorAdmin",
      "type": "address"
    }], "name": "onUpgrade", "outputs": [], "stateMutability": "nonpayable", "type": "function"
  }, {
    "inputs": [],
    "name": "pause",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  }, {
    "inputs": [],
    "name": "paused",
    "outputs": [{ "internalType": "bool", "name": "", "type": "bool" }],
    "stateMutability": "view",
    "type": "function"
  }, {
    "inputs": [],
    "name": "phloteToken",
    "outputs": [{ "internalType": "contract PhloteVote", "name": "", "type": "address" }],
    "stateMutability": "view",
    "type": "function"
  }, {
    "inputs": [{ "internalType": "bytes32", "name": "role", "type": "bytes32" }, {
      "internalType": "address",
      "name": "account",
      "type": "address"
    }], "name": "renounceRole", "outputs": [], "stateMutability": "nonpayable", "type": "function"
  }, {
    "inputs": [{ "internalType": "address", "name": "_oldCurator", "type": "address" }],
    "name": "revokeCuratorRole",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  }, {
    "inputs": [{ "internalType": "bytes32", "name": "role", "type": "bytes32" }, {
      "internalType": "address",
      "name": "account",
      "type": "address"
    }], "name": "revokeRole", "outputs": [], "stateMutability": "nonpayable", "type": "function"
  }, {
    "inputs": [{ "internalType": "address", "name": "_treasury", "type": "address" }, {
      "internalType": "address",
      "name": "_curatorAdmin",
      "type": "address"
    }], "name": "setAddresses", "outputs": [], "stateMutability": "nonpayable", "type": "function"
  }, {
    "inputs": [{ "internalType": "uint256", "name": "_curatorTokenMinimum", "type": "uint256" }],
    "name": "setCuratorTokenMinimum",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  }, {
    "inputs": [{ "internalType": "string", "name": "_ipfsURI", "type": "string" }, {
      "internalType": "bool",
      "name": "_isArtistSubmission",
      "type": "bool"
    }],
    "name": "submit",
    "outputs": [{ "internalType": "contract Hotdrop", "name": "hotdrop", "type": "address" }],
    "stateMutability": "nonpayable",
    "type": "function"
  }, {
    "inputs": [{ "internalType": "bytes4", "name": "interfaceId", "type": "bytes4" }],
    "name": "supportsInterface",
    "outputs": [{ "internalType": "bool", "name": "", "type": "bool" }],
    "stateMutability": "view",
    "type": "function"
  }, {
    "inputs": [],
    "name": "treasury",
    "outputs": [{ "internalType": "address", "name": "", "type": "address" }],
    "stateMutability": "view",
    "type": "function"
  }, {
    "inputs": [],
    "name": "unpause",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  }, {
    "inputs": [{ "internalType": "uint256", "name": "_amount", "type": "uint256" }],
    "name": "withdraw",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  }, { "inputs": [], "name": "withdraw", "outputs": [], "stateMutability": "nonpayable", "type": "function" }, {
    "inputs": [{ "internalType": "contract IERC20", "name": "_token", "type": "address" }, {
      "internalType": "uint256",
      "name": "_amount",
      "type": "uint256"
    }], "name": "withdraw", "outputs": [], "stateMutability": "nonpayable", "type": "function"
  }
]
