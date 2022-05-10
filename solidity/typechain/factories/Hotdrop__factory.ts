/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import { Signer, utils, Contract, ContractFactory, Overrides } from "ethers";
import { Provider, TransactionRequest } from "@ethersproject/providers";
import type { Hotdrop, HotdropInterface } from "../Hotdrop";

const _abi = [
  {
    inputs: [
      {
        internalType: "address",
        name: "_submitter",
        type: "address",
      },
    ],
    stateMutability: "nonpayable",
    type: "constructor",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "account",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "operator",
        type: "address",
      },
      {
        indexed: false,
        internalType: "bool",
        name: "approved",
        type: "bool",
      },
    ],
    name: "ApprovalForAll",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "previousOwner",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "newOwner",
        type: "address",
      },
    ],
    name: "OwnershipTransferred",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "address",
        name: "account",
        type: "address",
      },
    ],
    name: "Paused",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "operator",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "from",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "to",
        type: "address",
      },
      {
        indexed: false,
        internalType: "uint256[]",
        name: "ids",
        type: "uint256[]",
      },
      {
        indexed: false,
        internalType: "uint256[]",
        name: "values",
        type: "uint256[]",
      },
    ],
    name: "TransferBatch",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "operator",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "from",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "to",
        type: "address",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "id",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "value",
        type: "uint256",
      },
    ],
    name: "TransferSingle",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "string",
        name: "value",
        type: "string",
      },
      {
        indexed: true,
        internalType: "uint256",
        name: "id",
        type: "uint256",
      },
    ],
    name: "URI",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "address",
        name: "account",
        type: "address",
      },
    ],
    name: "Unpaused",
    type: "event",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    name: "COSIGN_COSTS",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "COSIGN_REWARD",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "ID_PHLOTE",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "NFTS_PER_COSIGN",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "account",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "id",
        type: "uint256",
      },
    ],
    name: "balanceOf",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address[]",
        name: "accounts",
        type: "address[]",
      },
      {
        internalType: "uint256[]",
        name: "ids",
        type: "uint256[]",
      },
    ],
    name: "balanceOfBatch",
    outputs: [
      {
        internalType: "uint256[]",
        name: "",
        type: "uint256[]",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "account",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "id",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "value",
        type: "uint256",
      },
    ],
    name: "burn",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "account",
        type: "address",
      },
      {
        internalType: "uint256[]",
        name: "ids",
        type: "uint256[]",
      },
      {
        internalType: "uint256[]",
        name: "values",
        type: "uint256[]",
      },
    ],
    name: "burnBatch",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    name: "cosigners",
    outputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "cosigns",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "curated",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "id",
        type: "uint256",
      },
    ],
    name: "exists",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "account",
        type: "address",
      },
      {
        internalType: "address",
        name: "operator",
        type: "address",
      },
    ],
    name: "isApprovedForAll",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "account",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "id",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "amount",
        type: "uint256",
      },
      {
        internalType: "bytes",
        name: "data",
        type: "bytes",
      },
    ],
    name: "mint",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "to",
        type: "address",
      },
      {
        internalType: "uint256[]",
        name: "ids",
        type: "uint256[]",
      },
      {
        internalType: "uint256[]",
        name: "amounts",
        type: "uint256[]",
      },
      {
        internalType: "bytes",
        name: "data",
        type: "bytes",
      },
    ],
    name: "mintBatch",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "owner",
    outputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "pause",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "paused",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "_cosigner",
        type: "address",
      },
    ],
    name: "phlote",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "renounceOwnership",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "from",
        type: "address",
      },
      {
        internalType: "address",
        name: "to",
        type: "address",
      },
      {
        internalType: "uint256[]",
        name: "ids",
        type: "uint256[]",
      },
      {
        internalType: "uint256[]",
        name: "amounts",
        type: "uint256[]",
      },
      {
        internalType: "bytes",
        name: "data",
        type: "bytes",
      },
    ],
    name: "safeBatchTransferFrom",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "from",
        type: "address",
      },
      {
        internalType: "address",
        name: "to",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "id",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "amount",
        type: "uint256",
      },
      {
        internalType: "bytes",
        name: "data",
        type: "bytes",
      },
    ],
    name: "safeTransferFrom",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "operator",
        type: "address",
      },
      {
        internalType: "bool",
        name: "approved",
        type: "bool",
      },
    ],
    name: "setApprovalForAll",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "string",
        name: "newuri",
        type: "string",
      },
    ],
    name: "setURI",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "submitter",
    outputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "bytes4",
        name: "interfaceId",
        type: "bytes4",
      },
    ],
    name: "supportsInterface",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "id",
        type: "uint256",
      },
    ],
    name: "totalSupply",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "newOwner",
        type: "address",
      },
    ],
    name: "transferOwnership",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "unpause",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    name: "uri",
    outputs: [
      {
        internalType: "string",
        name: "",
        type: "string",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
];

const _bytecode =
  "0x6000600590815567d02ab486cedc00006007556101206040526802b5e3af16b18800006080908152680340aad21b3b70000060a0526803cb71f51fc558000060c0526804563918244f40000060e0526804e1003b28d9280000610100526200006b916008919062000178565b5060056012556013805460ff191690553480156200008857600080fd5b506040516200299638038062002996833981016040819052620000ab916200025a565b6040518060600160405280602981526020016200296d60299139620000d0816200010d565b50620000dc3362000126565b6003805460ff60a01b19169055600680546001600160a01b0383166001600160a01b031990911617905550620002c9565b805162000122906002906020840190620001c6565b5050565b600380546001600160a01b038381166001600160a01b0319831681179093556040519116919082907f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e090600090a35050565b8260058101928215620001b4579160200282015b82811115620001b457825182906001600160481b03169055916020019190600101906200018c565b50620001c292915062000243565b5090565b828054620001d4906200028c565b90600052602060002090601f016020900481019282620001f85760008555620001b4565b82601f106200021357805160ff1916838001178555620001b4565b82800160010185558215620001b4579182015b82811115620001b457825182559160200191906001019062000226565b5b80821115620001c2576000815560010162000244565b6000602082840312156200026d57600080fd5b81516001600160a01b03811681146200028557600080fd5b9392505050565b600181811c90821680620002a157607f821691505b60208210811415620002c357634e487b7160e01b600052602260045260246000fd5b50919050565b61269480620002d96000396000f3fe608060405234801561001057600080fd5b50600436106101d95760003560e01c806370166af711610104578063a22cb465116100a2578063f242432a11610071578063f242432a1461042e578063f2fde38b14610441578063f4fdccf814610454578063f5298aca1461045d57600080fd5b8063a22cb465146103b6578063bd85b039146103c9578063cf42d4d9146103e9578063e985e9c5146103f257600080fd5b80638456cb59116100de5780638456cb591461037d57806389275407146103855780638da5cb5b146103925780638dc45d9a146103a357600080fd5b806370166af71461034f578063715018a614610362578063731133e91461036a57600080fd5b80633f4ba83a1161017c5780634f558e791161014b5780634f558e79146102dd57806351061ce8146102ff5780635c975abb1461032a5780636b20c4541461033c57600080fd5b80633f4ba83a14610295578063404d21951461029d5780634ba7db30146102a65780634e1273f4146102bd57600080fd5b80630e89341c116101b85780630e89341c1461023c578063114ea6671461025c5780631f7fdffa1461026f5780632eb2c2d61461028257600080fd5b8062fdd58e146101de57806301ffc9a71461020457806302fe530514610227575b600080fd5b6101f16101ec366004611b41565b610470565b6040519081526020015b60405180910390f35b610217610212366004611b81565b610507565b60405190151581526020016101fb565b61023a610235366004611c46565b610559565b005b61024f61024a366004611c97565b61058f565b6040516101fb9190611cfd565b6101f161026a366004611d10565b610623565b61023a61027d366004611de0565b6106c6565b61023a610290366004611e79565b61073e565b61023a6107d5565b6101f160125481565b6005546000908152600460205260409020546101f1565b6102d06102cb366004611f23565b610809565b6040516101fb9190612029565b6102176102eb366004611c97565b600090815260046020526040902054151590565b61031261030d366004611c97565b610933565b6040516001600160a01b0390911681526020016101fb565b600354600160a01b900460ff16610217565b61023a61034a36600461203c565b610953565b6101f161035d366004611c97565b61099b565b61023a6109b2565b61023a6103783660046120b0565b6109e6565b61023a610ab8565b6013546102179060ff1681565b6003546001600160a01b0316610312565b600654610312906001600160a01b031681565b61023a6103c4366004612105565b610aea565b6101f16103d7366004611c97565b60009081526004602052604090205490565b6101f160075481565b610217610400366004612141565b6001600160a01b03918216600090815260016020908152604080832093909416825291909152205460ff1690565b61023a61043c366004612174565b610af9565b61023a61044f366004611d10565b610b3e565b6101f160055481565b61023a61046b3660046121d9565b610bd6565b60006001600160a01b0383166104e15760405162461bcd60e51b815260206004820152602b60248201527f455243313135353a2062616c616e636520717565727920666f7220746865207a60448201526a65726f206164647265737360a81b60648201526084015b60405180910390fd5b506000908152602081815260408083206001600160a01b03949094168352929052205490565b60006001600160e01b03198216636cdb3d1360e11b148061053857506001600160e01b031982166303a24d0760e21b145b8061055357506301ffc9a760e01b6001600160e01b03198316145b92915050565b6003546001600160a01b031633146105835760405162461bcd60e51b81526004016104d89061220c565b61058c81610c19565b50565b60606002805461059e90612241565b80601f01602080910402602001604051908101604052809291908181526020018280546105ca90612241565b80156106175780601f106105ec57610100808354040283529160200191610617565b820191906000526020600020905b8154815290600101906020018083116105fa57829003601f168201915b50505050509050919050565b6003546000906001600160a01b031633146106505760405162461bcd60e51b81526004016104d89061220c565b6013805460ff1916600117905560055460009081526004602052604081205461067a906001612292565b60405160200161068c91815260200190565b60405160208183030381529060405290506106ac836005546001846109e6565b50506005546000908152600460205260409020545b919050565b6003546001600160a01b031633146106f05760405162461bcd60e51b81526004016104d89061220c565b60405162461bcd60e51b815260206004820152601f60248201527f64697361626c656420666f72206e6f772e20757365205f6d696e74282e2e290060448201526064016104d8565b50505050565b6001600160a01b03851633148061075a575061075a8533610400565b6107c15760405162461bcd60e51b815260206004820152603260248201527f455243313135353a207472616e736665722063616c6c6572206973206e6f74206044820152711bdddb995c881b9bdc88185c1c1c9bdd995960721b60648201526084016104d8565b6107ce8585858585610d2c565b5050505050565b6003546001600160a01b031633146107ff5760405162461bcd60e51b81526004016104d89061220c565b610807610ed6565b565b6060815183511461086e5760405162461bcd60e51b815260206004820152602960248201527f455243313135353a206163636f756e747320616e6420696473206c656e677468604482015268040dad2e6dac2e8c6d60bb1b60648201526084016104d8565b6000835167ffffffffffffffff81111561088a5761088a611ba5565b6040519080825280602002602001820160405280156108b3578160200160208202803683370190505b50905060005b845181101561092b576108fe8582815181106108d7576108d76122aa565b60200260200101518583815181106108f1576108f16122aa565b6020026020010151610470565b828281518110610910576109106122aa565b6020908102919091010152610924816122c0565b90506108b9565b509392505050565b600d816005811061094357600080fd5b01546001600160a01b0316905081565b6001600160a01b03831633148061096f575061096f8333610400565b61098b5760405162461bcd60e51b81526004016104d8906122db565b610996838383610f73565b505050565b600881600581106109ab57600080fd5b0154905081565b6003546001600160a01b031633146109dc5760405162461bcd60e51b81526004016104d89061220c565b610807600061110f565b6003546001600160a01b03163314610a105760405162461bcd60e51b81526004016104d89061220c565b6005805460009081526004602052604090205410610a625760405162461bcd60e51b815260206004820152600f60248201526e63616e2774206d696e74206d6f726560881b60448201526064016104d8565b83600d610a7d60055460009081526004602052604090205490565b60058110610a8d57610a8d6122aa565b0180546001600160a01b0319166001600160a01b039290921691909117905561073884848484611161565b6003546001600160a01b03163314610ae25760405162461bcd60e51b81526004016104d89061220c565b610807611284565b610af533838361130c565b5050565b6001600160a01b038516331480610b155750610b158533610400565b610b315760405162461bcd60e51b81526004016104d8906122db565b6107ce85858585856113ed565b6003546001600160a01b03163314610b685760405162461bcd60e51b81526004016104d89061220c565b6001600160a01b038116610bcd5760405162461bcd60e51b815260206004820152602660248201527f4f776e61626c653a206e6577206f776e657220697320746865207a65726f206160448201526564647265737360d01b60648201526084016104d8565b61058c8161110f565b6001600160a01b038316331480610bf25750610bf28333610400565b610c0e5760405162461bcd60e51b81526004016104d8906122db565b610996838383611525565b8051610af5906002906020840190611a91565b8451811015610cc457838181518110610c4757610c476122aa565b6020026020010151600080878481518110610c6457610c646122aa565b602002602001015181526020019081526020016000206000886001600160a01b03166001600160a01b031681526020019081526020016000206000828254610cac9190612292565b90915550819050610cbc816122c0565b915050610c2c565b50846001600160a01b031660006001600160a01b0316826001600160a01b03167f4a39dc06d4c0dbc64b70af90fd698a233a518aa5d07e595d983b8c0526c8f7fb8787604051610d1592919061236c565b60405180910390a46107ce81600087878787611698565b8151835114610d4d5760405162461bcd60e51b81526004016104d890612324565b6001600160a01b038416610d735760405162461bcd60e51b81526004016104d89061239a565b33610d8281878787878761163d565b60005b8451811015610e68576000858281518110610da257610da26122aa565b602002602001015190506000858381518110610dc057610dc06122aa565b602090810291909101810151600084815280835260408082206001600160a01b038e168352909352919091205490915081811015610e105760405162461bcd60e51b81526004016104d8906123df565b6000838152602081815260408083206001600160a01b038e8116855292528083208585039055908b16825281208054849290610e4d908490612292565b9250508190555050505080610e61906122c0565b9050610d85565b50846001600160a01b0316866001600160a01b0316826001600160a01b03167f4a39dc06d4c0dbc64b70af90fd698a233a518aa5d07e595d983b8c0526c8f7fb8787604051610eb892919061236c565b60405180910390a4610ece818787878787611698565b505050505050565b600354600160a01b900460ff16610f265760405162461bcd60e51b815260206004820152601460248201527314185d5cd8589b194e881b9bdd081c185d5cd95960621b60448201526064016104d8565b6003805460ff60a01b191690557f5db9ee0a495bf2e6ff9c91a7834c1ba4fdd244a5e8aa4e537bd38aeae4b073aa335b6040516001600160a01b03909116815260200160405180910390a1565b6001600160a01b038316610f995760405162461bcd60e51b81526004016104d890612429565b8051825114610fba5760405162461bcd60e51b81526004016104d890612324565b6000339050610fdd8185600086866040518060200160405280600081525061163d565b60005b83518110156110a2576000848281518110610ffd57610ffd6122aa565b60200260200101519050600084838151811061101b5761101b6122aa565b602090810291909101810151600084815280835260408082206001600160a01b038c16835290935291909120549091508181101561106b5760405162461bcd60e51b81526004016104d89061246c565b6000928352602083815260408085206001600160a01b038b168652909152909220910390558061109a816122c0565b915050610fe0565b5060006001600160a01b0316846001600160a01b0316826001600160a01b03167f4a39dc06d4c0dbc64b70af90fd698a233a518aa5d07e595d983b8c0526c8f7fb86866040516110f392919061236c565b60405180910390a4604080516020810190915260009052610738565b600380546001600160a01b038381166001600160a01b0319831681179093556040519116919082907f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e090600090a35050565b6001600160a01b0384166111c15760405162461bcd60e51b815260206004820152602160248201527f455243313135353a206d696e7420746f20746865207a65726f206164647265736044820152607360f81b60648201526084016104d8565b3360006111cd85611803565b905060006111da85611803565b90506111eb8360008985858961163d565b6000868152602081815260408083206001600160a01b038b1684529091528120805487929061121b908490612292565b909155505060408051878152602081018790526001600160a01b03808a1692600092918716917fc3d58168c5ae7397731d063d5bbf3d657854427343f4c083240f7aacaa2d0f62910160405180910390a461127b8360008989898961184e565b50505050505050565b600354600160a01b900460ff16156112d15760405162461bcd60e51b815260206004820152601060248201526f14185d5cd8589b194e881c185d5cd95960821b60448201526064016104d8565b6003805460ff60a01b1916600160a01b1790557f62e78cea01bee320cd4e420270b5ea74000d11b0c9f74754ebdbfc544b05a258610f563390565b816001600160a01b0316836001600160a01b031614156113805760405162461bcd60e51b815260206004820152602960248201527f455243313135353a2073657474696e6720617070726f76616c20737461747573604482015268103337b91039b2b63360b91b60648201526084016104d8565b6001600160a01b03838116600081815260016020908152604080832094871680845294825291829020805460ff191686151590811790915591519182527f17307eab39ab6107e8899845ad3d59bd9653f200f220920489ca2b5937696c31910160405180910390a3505050565b6001600160a01b0384166114135760405162461bcd60e51b81526004016104d89061239a565b33600061141f85611803565b9050600061142c85611803565b905061143c83898985858961163d565b6000868152602081815260408083206001600160a01b038c1684529091529020548581101561147d5760405162461bcd60e51b81526004016104d8906123df565b6000878152602081815260408083206001600160a01b038d8116855292528083208985039055908a168252812080548892906114ba908490612292565b909155505060408051888152602081018890526001600160a01b03808b16928c821692918816917fc3d58168c5ae7397731d063d5bbf3d657854427343f4c083240f7aacaa2d0f62910160405180910390a461151a848a8a8a8a8a61184e565b505050505050505050565b6001600160a01b03831661154b5760405162461bcd60e51b81526004016104d890612429565b33600061155784611803565b9050600061156484611803565b90506115848387600085856040518060200160405280600081525061163d565b6000858152602081815260408083206001600160a01b038a168452909152902054848110156115c55760405162461bcd60e51b81526004016104d89061246c565b6000868152602081815260408083206001600160a01b038b81168086529184528285208a8703905582518b81529384018a90529092908816917fc3d58168c5ae7397731d063d5bbf3d657854427343f4c083240f7aacaa2d0f62910160405180910390a460408051602081019091526000905261127b565b600354600160a01b900460ff161561168a5760405162461bcd60e51b815260206004820152601060248201526f14185d5cd8589b194e881c185d5cd95960821b60448201526064016104d8565b610ece868686868686611918565b6001600160a01b0384163b15610ece5760405163bc197c8160e01b81526001600160a01b0385169063bc197c81906116dc90899089908890889088906004016124b0565b602060405180830381600087803b1580156116f657600080fd5b505af1925050508015611726575060408051601f3d908101601f191682019092526117239181019061250e565b60015b6117d35761173261252b565b806308c379a0141561176c5750611747612547565b80611752575061176e565b8060405162461bcd60e51b81526004016104d89190611cfd565b505b60405162461bcd60e51b815260206004820152603460248201527f455243313135353a207472616e7366657220746f206e6f6e20455243313135356044820152732932b1b2b4bb32b91034b6b83632b6b2b73a32b960611b60648201526084016104d8565b6001600160e01b0319811663bc197c8160e01b1461127b5760405162461bcd60e51b81526004016104d8906125d1565b6040805160018082528183019092526060916000919060208083019080368337019050509050828160008151811061183d5761183d6122aa565b602090810291909101015292915050565b6001600160a01b0384163b15610ece5760405163f23a6e6160e01b81526001600160a01b0385169063f23a6e61906118929089908990889088908890600401612619565b602060405180830381600087803b1580156118ac57600080fd5b505af19250505080156118dc575060408051601f3d908101601f191682019092526118d99181019061250e565b60015b6118e85761173261252b565b6001600160e01b0319811663f23a6e6160e01b1461127b5760405162461bcd60e51b81526004016104d8906125d1565b6001600160a01b03851661199f5760005b835181101561199d57828181518110611944576119446122aa565b602002602001015160046000868481518110611962576119626122aa565b6020026020010151815260200190815260200160002060008282546119879190612292565b909155506119969050816122c0565b9050611929565b505b6001600160a01b038416610ece5760005b835181101561127b5760008482815181106119cd576119cd6122aa565b6020026020010151905060008483815181106119eb576119eb6122aa565b6020026020010151905060006004600084815260200190815260200160002054905081811015611a6e5760405162461bcd60e51b815260206004820152602860248201527f455243313135353a206275726e20616d6f756e74206578636565647320746f74604482015267616c537570706c7960c01b60648201526084016104d8565b60009283526004602052604090922091039055611a8a816122c0565b90506119b0565b828054611a9d90612241565b90600052602060002090601f016020900481019282611abf5760008555611b05565b82601f10611ad857805160ff1916838001178555611b05565b82800160010185558215611b05579182015b82811115611b05578251825591602001919060010190611aea565b50611b11929150611b15565b5090565b5b80821115611b115760008155600101611b16565b80356001600160a01b03811681146106c157600080fd5b60008060408385031215611b5457600080fd5b611b5d83611b2a565b946020939093013593505050565b6001600160e01b03198116811461058c57600080fd5b600060208284031215611b9357600080fd5b8135611b9e81611b6b565b9392505050565b634e487b7160e01b600052604160045260246000fd5b601f8201601f1916810167ffffffffffffffff81118282101715611be157611be1611ba5565b6040525050565b600067ffffffffffffffff831115611c0257611c02611ba5565b604051611c19601f8501601f191660200182611bbb565b809150838152848484011115611c2e57600080fd5b83836020830137600060208583010152509392505050565b600060208284031215611c5857600080fd5b813567ffffffffffffffff811115611c6f57600080fd5b8201601f81018413611c8057600080fd5b611c8f84823560208401611be8565b949350505050565b600060208284031215611ca957600080fd5b5035919050565b6000815180845260005b81811015611cd657602081850181015186830182015201611cba565b81811115611ce8576000602083870101525b50601f01601f19169290920160200192915050565b602081526000611b9e6020830184611cb0565b600060208284031215611d2257600080fd5b611b9e82611b2a565b600067ffffffffffffffff821115611d4557611d45611ba5565b5060051b60200190565b600082601f830112611d6057600080fd5b81356020611d6d82611d2b565b604051611d7a8282611bbb565b83815260059390931b8501820192828101915086841115611d9a57600080fd5b8286015b84811015611db55780358352918301918301611d9e565b509695505050505050565b600082601f830112611dd157600080fd5b611b9e83833560208501611be8565b60008060008060808587031215611df657600080fd5b611dff85611b2a565b9350602085013567ffffffffffffffff80821115611e1c57600080fd5b611e2888838901611d4f565b94506040870135915080821115611e3e57600080fd5b611e4a88838901611d4f565b93506060870135915080821115611e6057600080fd5b50611e6d87828801611dc0565b91505092959194509250565b600080600080600060a08688031215611e9157600080fd5b611e9a86611b2a565b9450611ea860208701611b2a565b9350604086013567ffffffffffffffff80821115611ec557600080fd5b611ed189838a01611d4f565b94506060880135915080821115611ee757600080fd5b611ef389838a01611d4f565b93506080880135915080821115611f0957600080fd5b50611f1688828901611dc0565b9150509295509295909350565b60008060408385031215611f3657600080fd5b823567ffffffffffffffff80821115611f4e57600080fd5b818501915085601f830112611f6257600080fd5b81356020611f6f82611d2b565b604051611f7c8282611bbb565b83815260059390931b8501820192828101915089841115611f9c57600080fd5b948201945b83861015611fc157611fb286611b2a565b82529482019490820190611fa1565b96505086013592505080821115611fd757600080fd5b50611fe485828601611d4f565b9150509250929050565b600081518084526020808501945080840160005b8381101561201e57815187529582019590820190600101612002565b509495945050505050565b602081526000611b9e6020830184611fee565b60008060006060848603121561205157600080fd5b61205a84611b2a565b9250602084013567ffffffffffffffff8082111561207757600080fd5b61208387838801611d4f565b9350604086013591508082111561209957600080fd5b506120a686828701611d4f565b9150509250925092565b600080600080608085870312156120c657600080fd5b6120cf85611b2a565b93506020850135925060408501359150606085013567ffffffffffffffff8111156120f957600080fd5b611e6d87828801611dc0565b6000806040838503121561211857600080fd5b61212183611b2a565b91506020830135801515811461213657600080fd5b809150509250929050565b6000806040838503121561215457600080fd5b61215d83611b2a565b915061216b60208401611b2a565b90509250929050565b600080600080600060a0868803121561218c57600080fd5b61219586611b2a565b94506121a360208701611b2a565b93506040860135925060608601359150608086013567ffffffffffffffff8111156121cd57600080fd5b611f1688828901611dc0565b6000806000606084860312156121ee57600080fd5b6121f784611b2a565b95602085013595506040909401359392505050565b6020808252818101527f4f776e61626c653a2063616c6c6572206973206e6f7420746865206f776e6572604082015260600190565b600181811c9082168061225557607f821691505b6020821081141561227657634e487b7160e01b600052602260045260246000fd5b50919050565b634e487b7160e01b600052601160045260246000fd5b600082198211156122a5576122a561227c565b500190565b634e487b7160e01b600052603260045260246000fd5b60006000198214156122d4576122d461227c565b5060010190565b60208082526029908201527f455243313135353a2063616c6c6572206973206e6f74206f776e6572206e6f7260408201526808185c1c1c9bdd995960ba1b606082015260800190565b60208082526028908201527f455243313135353a2069647320616e6420616d6f756e7473206c656e677468206040820152670dad2e6dac2e8c6d60c31b606082015260800190565b60408152600061237f6040830185611fee565b82810360208401526123918185611fee565b95945050505050565b60208082526025908201527f455243313135353a207472616e7366657220746f20746865207a65726f206164604082015264647265737360d81b606082015260800190565b6020808252602a908201527f455243313135353a20696e73756666696369656e742062616c616e636520666f60408201526939103a3930b739b332b960b11b606082015260800190565b60208082526023908201527f455243313135353a206275726e2066726f6d20746865207a65726f206164647260408201526265737360e81b606082015260800190565b60208082526024908201527f455243313135353a206275726e20616d6f756e7420657863656564732062616c604082015263616e636560e01b606082015260800190565b6001600160a01b0386811682528516602082015260a0604082018190526000906124dc90830186611fee565b82810360608401526124ee8186611fee565b905082810360808401526125028185611cb0565b98975050505050505050565b60006020828403121561252057600080fd5b8151611b9e81611b6b565b600060033d11156125445760046000803e5060005160e01c5b90565b600060443d10156125555790565b6040516003193d81016004833e81513d67ffffffffffffffff816024840111818411171561258557505050505090565b828501915081518181111561259d5750505050505090565b843d87010160208285010111156125b75750505050505090565b6125c660208286010187611bbb565b509095945050505050565b60208082526028908201527f455243313135353a204552433131353552656365697665722072656a656374656040820152676420746f6b656e7360c01b606082015260800190565b6001600160a01b03868116825285166020820152604081018490526060810183905260a06080820181905260009061265390830184611cb0565b97965050505050505056fea2646970667358221220712ffa69796dc98bd6d3575e4ebb65fe0acba32a28b833a220332d91537e75c164736f6c6343000809003368747470733a2f2f697066732e70686c6f74652e78797a2f686f7464726f702f7b69647d2e6a736f6e";

type HotdropConstructorParams =
  | [signer?: Signer]
  | ConstructorParameters<typeof ContractFactory>;

const isSuperArgs = (
  xs: HotdropConstructorParams
): xs is ConstructorParameters<typeof ContractFactory> => xs.length > 1;

export class Hotdrop__factory extends ContractFactory {
  constructor(...args: HotdropConstructorParams) {
    if (isSuperArgs(args)) {
      super(...args);
    } else {
      super(_abi, _bytecode, args[0]);
    }
    this.contractName = "Hotdrop";
  }

  deploy(
    _submitter: string,
    overrides?: Overrides & { from?: string | Promise<string> }
  ): Promise<Hotdrop> {
    return super.deploy(_submitter, overrides || {}) as Promise<Hotdrop>;
  }
  getDeployTransaction(
    _submitter: string,
    overrides?: Overrides & { from?: string | Promise<string> }
  ): TransactionRequest {
    return super.getDeployTransaction(_submitter, overrides || {});
  }
  attach(address: string): Hotdrop {
    return super.attach(address) as Hotdrop;
  }
  connect(signer: Signer): Hotdrop__factory {
    return super.connect(signer) as Hotdrop__factory;
  }
  static readonly contractName: "Hotdrop";
  public readonly contractName: "Hotdrop";
  static readonly bytecode = _bytecode;
  static readonly abi = _abi;
  static createInterface(): HotdropInterface {
    return new utils.Interface(_abi) as HotdropInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): Hotdrop {
    return new Contract(address, _abi, signerOrProvider) as Hotdrop;
  }
}
