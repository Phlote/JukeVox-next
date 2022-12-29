//PROXY ADDRESS
export const CuratorAddress = "0xC3DAF114368608072749359295217daFB5A4e5f8"

export const CuratorABI = [
  {
    inputs: [
      { internalType: "contract PhloteVote", name: "_phloteToken", type: "address" },
      { internalType: "address", name: "_treasury", type: "address" },
      { internalType: "address", name: "_curatorAdmin", type: "address" },
    ],
    stateMutability: "nonpayable",
    type: "constructor",
  },
  {
    anonymous: false,
    inputs: [
      { indexed: true, internalType: "address", name: "cosigner", type: "address" },
      { indexed: false, internalType: "contract Hotdrop", name: "hotdrop", type: "address" },
      { indexed: false, internalType: "uint256", name: "cosignEdition", type: "uint256" },
    ],
    name: "Cosign",
    type: "event",
  },
  { anonymous: false, inputs: [{ indexed: false, internalType: "address", name: "account", type: "address" }], name: "Paused", type: "event" },
  {
    anonymous: false,
    inputs: [
      { indexed: true, internalType: "address", name: "submitter", type: "address" },
      { indexed: false, internalType: "string", name: "ipfsURI", type: "string" },
      { indexed: false, internalType: "bool", name: "_isArtistSubmission", type: "bool" },
      { indexed: false, internalType: "contract Hotdrop", name: "hotdrop", type: "address" },
    ],
    name: "Submit",
    type: "event",
  },
  { anonymous: false, inputs: [{ indexed: false, internalType: "address", name: "account", type: "address" }], name: "Unpaused", type: "event" },
  { inputs: [], name: "admin", outputs: [{ internalType: "address", name: "", type: "address" }], stateMutability: "view", type: "function" },
  { inputs: [{ internalType: "contract Hotdrop", name: "_hotdrop", type: "address" }], name: "curate", outputs: [], stateMutability: "nonpayable", type: "function" },
  { inputs: [], name: "curatorAdmin", outputs: [{ internalType: "address", name: "", type: "address" }], stateMutability: "view", type: "function" },
  { inputs: [], name: "curatorTokenMinimum", outputs: [{ internalType: "uint256", name: "", type: "uint256" }], stateMutability: "view", type: "function" },
  { inputs: [], name: "pause", outputs: [], stateMutability: "nonpayable", type: "function" },
  { inputs: [], name: "paused", outputs: [{ internalType: "bool", name: "", type: "bool" }], stateMutability: "view", type: "function" },
  { inputs: [], name: "phloteToken", outputs: [{ internalType: "contract PhloteVote", name: "", type: "address" }], stateMutability: "view", type: "function" },
  {
    inputs: [
      { internalType: "address", name: "_treasury", type: "address" },
      { internalType: "address", name: "_curatorAdmin", type: "address" },
      { internalType: "contract PhloteVote", name: "_phloteToken", type: "address" },
    ],
    name: "setAddresses",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [{ internalType: "uint256", name: "_curatorTokenMinimum", type: "uint256" }],
    name: "setCuratorTokenMinimum",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      { internalType: "contract Hotdrop", name: "_hotdrop", type: "address" },
      { internalType: "uint256", name: "_state", type: "uint256" },
    ],
    name: "setHotDropSaleState",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      { internalType: "contract Hotdrop", name: "_hotdrop", type: "address" },
      { internalType: "uint256", name: "_artist", type: "uint256" },
      { internalType: "uint256", name: "_phlote", type: "uint256" },
    ],
    name: "setHotDropSplits",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      { internalType: "contract Hotdrop", name: "_hotdrop", type: "address" },
      { internalType: "uint256", name: "_amount", type: "uint256" },
    ],
    name: "setHotDropTotalSupplyLeft",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      { internalType: "contract Hotdrop", name: "_hotdrop", type: "address" },
      { internalType: "uint256", name: "_price", type: "uint256" },
    ],
    name: "setHotdropPrice",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      { internalType: "contract Hotdrop", name: "_hotdrop", type: "address" },
      { internalType: "string", name: "_newuri", type: "string" },
    ],
    name: "setHotdropURI",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      { internalType: "string", name: "_ipfsURI", type: "string" },
      { internalType: "bool", name: "_isArtistSubmission", type: "bool" },
    ],
    name: "submit",
    outputs: [{ internalType: "contract Hotdrop", name: "hotdrop", type: "address" }],
    stateMutability: "nonpayable",
    type: "function",
  },
  { inputs: [], name: "treasury", outputs: [{ internalType: "address", name: "", type: "address" }], stateMutability: "view", type: "function" },
  { inputs: [], name: "unpause", outputs: [], stateMutability: "nonpayable", type: "function" },
  { inputs: [{ internalType: "uint256", name: "_amount", type: "uint256" }], name: "withdraw", outputs: [], stateMutability: "nonpayable", type: "function" },
  { inputs: [], name: "withdraw", outputs: [], stateMutability: "nonpayable", type: "function" },
  {
    inputs: [
      { internalType: "contract IERC20", name: "_token", type: "address" },
      { internalType: "uint256", name: "_amount", type: "uint256" },
    ],
    name: "withdraw",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
];