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
  "0x6000600590815567d02ab486cedc00006007556101206040526802b5e3af16b18800006080908152680340aad21b3b70000060a0526803cb71f51fc558000060c0526804563918244f40000060e0526804e1003b28d9280000610100526200006b916008919062000178565b5060056012556013805460ff191690553480156200008857600080fd5b50604051620028ed380380620028ed833981016040819052620000ab916200025a565b604051806060016040528060298152602001620028c460299139620000d0816200010d565b50620000dc3362000126565b6003805460ff60a01b19169055600680546001600160a01b0383166001600160a01b031990911617905550620002c9565b805162000122906002906020840190620001c6565b5050565b600380546001600160a01b038381166001600160a01b0319831681179093556040519116919082907f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e090600090a35050565b8260058101928215620001b4579160200282015b82811115620001b457825182906001600160481b03169055916020019190600101906200018c565b50620001c292915062000243565b5090565b828054620001d4906200028c565b90600052602060002090601f016020900481019282620001f85760008555620001b4565b82601f106200021357805160ff1916838001178555620001b4565b82800160010185558215620001b4579182015b82811115620001b457825182559160200191906001019062000226565b5b80821115620001c2576000815560010162000244565b6000602082840312156200026d57600080fd5b81516001600160a01b03811681146200028557600080fd5b9392505050565b600181811c90821680620002a157607f821691505b60208210811415620002c357634e487b7160e01b600052602260045260246000fd5b50919050565b6125eb80620002d96000396000f3fe608060405234801561001057600080fd5b50600436106101d95760003560e01c806370166af711610104578063a22cb465116100a2578063f242432a11610071578063f242432a1461042e578063f2fde38b14610441578063f4fdccf814610454578063f5298aca1461045d57600080fd5b8063a22cb465146103b6578063bd85b039146103c9578063cf42d4d9146103e9578063e985e9c5146103f257600080fd5b80638456cb59116100de5780638456cb591461037d57806389275407146103855780638da5cb5b146103925780638dc45d9a146103a357600080fd5b806370166af71461034f578063715018a614610362578063731133e91461036a57600080fd5b80633f4ba83a1161017c5780634f558e791161014b5780634f558e79146102dd57806351061ce8146102ff5780635c975abb1461032a5780636b20c4541461033c57600080fd5b80633f4ba83a14610295578063404d21951461029d5780634ba7db30146102a65780634e1273f4146102bd57600080fd5b80630e89341c116101b85780630e89341c1461023c578063114ea6671461025c5780631f7fdffa1461026f5780632eb2c2d61461028257600080fd5b8062fdd58e146101de57806301ffc9a71461020457806302fe530514610227575b600080fd5b6101f16101ec366004611a81565b610470565b6040519081526020015b60405180910390f35b610217610212366004611ac1565b610507565b60405190151581526020016101fb565b61023a610235366004611b86565b610559565b005b61024f61024a366004611bd7565b61058f565b6040516101fb9190611c3d565b6101f161026a366004611c50565b610623565b61023a61027d366004611d20565b6106c6565b61023a610290366004611db9565b61073e565b61023a6107d5565b6101f160125481565b6005546000908152600460205260409020546101f1565b6102d06102cb366004611e63565b610809565b6040516101fb9190611f69565b6102176102eb366004611bd7565b600090815260046020526040902054151590565b61031261030d366004611bd7565b610933565b6040516001600160a01b0390911681526020016101fb565b600354600160a01b900460ff16610217565b61023a61034a366004611f7c565b610953565b6101f161035d366004611bd7565b61099b565b61023a6109b2565b61023a610378366004611ff0565b6109e6565b61023a610ab8565b6013546102179060ff1681565b6003546001600160a01b0316610312565b600654610312906001600160a01b031681565b61023a6103c4366004612045565b610aea565b6101f16103d7366004611bd7565b60009081526004602052604090205490565b6101f160075481565b610217610400366004612081565b6001600160a01b03918216600090815260016020908152604080832093909416825291909152205460ff1690565b61023a61043c3660046120b4565b610af9565b61023a61044f366004611c50565b610b3e565b6101f160055481565b61023a61046b366004612119565b610bd6565b60006001600160a01b0383166104e15760405162461bcd60e51b815260206004820152602b60248201527f455243313135353a2062616c616e636520717565727920666f7220746865207a60448201526a65726f206164647265737360a81b60648201526084015b60405180910390fd5b506000908152602081815260408083206001600160a01b03949094168352929052205490565b60006001600160e01b03198216636cdb3d1360e11b148061053857506001600160e01b031982166303a24d0760e21b145b8061055357506301ffc9a760e01b6001600160e01b03198316145b92915050565b6003546001600160a01b031633146105835760405162461bcd60e51b81526004016104d89061214c565b61058c81610c19565b50565b60606002805461059e90612181565b80601f01602080910402602001604051908101604052809291908181526020018280546105ca90612181565b80156106175780601f106105ec57610100808354040283529160200191610617565b820191906000526020600020905b8154815290600101906020018083116105fa57829003601f168201915b50505050509050919050565b6003546000906001600160a01b031633146106505760405162461bcd60e51b81526004016104d89061214c565b6013805460ff1916600117905560055460009081526004602052604081205461067a9060016121d2565b60405160200161068c91815260200190565b60405160208183030381529060405290506106ac836005546001846109e6565b50506005546000908152600460205260409020545b919050565b6003546001600160a01b031633146106f05760405162461bcd60e51b81526004016104d89061214c565b60405162461bcd60e51b815260206004820152601f60248201527f64697361626c656420666f72206e6f772e20757365205f6d696e74282e2e290060448201526064016104d8565b50505050565b6001600160a01b03851633148061075a575061075a8533610400565b6107c15760405162461bcd60e51b815260206004820152603260248201527f455243313135353a207472616e736665722063616c6c6572206973206e6f74206044820152711bdddb995c881b9bdc88185c1c1c9bdd995960721b60648201526084016104d8565b6107ce8585858585610d2c565b5050505050565b6003546001600160a01b031633146107ff5760405162461bcd60e51b81526004016104d89061214c565b610807610ed6565b565b6060815183511461086e5760405162461bcd60e51b815260206004820152602960248201527f455243313135353a206163636f756e747320616e6420696473206c656e677468604482015268040dad2e6dac2e8c6d60bb1b60648201526084016104d8565b6000835167ffffffffffffffff81111561088a5761088a611ae5565b6040519080825280602002602001820160405280156108b3578160200160208202803683370190505b50905060005b845181101561092b576108fe8582815181106108d7576108d76121ea565b60200260200101518583815181106108f1576108f16121ea565b6020026020010151610470565b828281518110610910576109106121ea565b602090810291909101015261092481612200565b90506108b9565b509392505050565b600d816005811061094357600080fd5b01546001600160a01b0316905081565b6001600160a01b03831633148061096f575061096f8333610400565b61098b5760405162461bcd60e51b81526004016104d89061221b565b610996838383610f73565b505050565b600881600581106109ab57600080fd5b0154905081565b6003546001600160a01b031633146109dc5760405162461bcd60e51b81526004016104d89061214c565b6108076000611101565b6003546001600160a01b03163314610a105760405162461bcd60e51b81526004016104d89061214c565b6005805460009081526004602052604090205410610a625760405162461bcd60e51b815260206004820152600f60248201526e63616e2774206d696e74206d6f726560881b60448201526064016104d8565b83600d610a7d60055460009081526004602052604090205490565b60058110610a8d57610a8d6121ea565b0180546001600160a01b0319166001600160a01b039290921691909117905561073884848484611153565b6003546001600160a01b03163314610ae25760405162461bcd60e51b81526004016104d89061214c565b610807611263565b610af53383836112eb565b5050565b6001600160a01b038516331480610b155750610b158533610400565b610b315760405162461bcd60e51b81526004016104d89061221b565b6107ce85858585856113cc565b6003546001600160a01b03163314610b685760405162461bcd60e51b81526004016104d89061214c565b6001600160a01b038116610bcd5760405162461bcd60e51b815260206004820152602660248201527f4f776e61626c653a206e6577206f776e657220697320746865207a65726f206160448201526564647265737360d01b60648201526084016104d8565b61058c81611101565b6001600160a01b038316331480610bf25750610bf28333610400565b610c0e5760405162461bcd60e51b81526004016104d89061221b565b6109968383836114e9565b8051610af59060029060208401906119d1565b8451811015610cc457838181518110610c4757610c476121ea565b6020026020010151600080878481518110610c6457610c646121ea565b602002602001015181526020019081526020016000206000886001600160a01b03166001600160a01b031681526020019081526020016000206000828254610cac91906121d2565b90915550819050610cbc81612200565b915050610c2c565b50846001600160a01b031660006001600160a01b0316826001600160a01b03167f4a39dc06d4c0dbc64b70af90fd698a233a518aa5d07e595d983b8c0526c8f7fb8787604051610d159291906122ac565b60405180910390a46107ce81600087878787611645565b8151835114610d4d5760405162461bcd60e51b81526004016104d890612264565b6001600160a01b038416610d735760405162461bcd60e51b81526004016104d8906122da565b33610d828187878787876115ea565b60005b8451811015610e68576000858281518110610da257610da26121ea565b602002602001015190506000858381518110610dc057610dc06121ea565b602090810291909101810151600084815280835260408082206001600160a01b038e168352909352919091205490915081811015610e105760405162461bcd60e51b81526004016104d89061231f565b6000838152602081815260408083206001600160a01b038e8116855292528083208585039055908b16825281208054849290610e4d9084906121d2565b9250508190555050505080610e6190612200565b9050610d85565b50846001600160a01b0316866001600160a01b0316826001600160a01b03167f4a39dc06d4c0dbc64b70af90fd698a233a518aa5d07e595d983b8c0526c8f7fb8787604051610eb89291906122ac565b60405180910390a4610ece818787878787611645565b505050505050565b600354600160a01b900460ff16610f265760405162461bcd60e51b815260206004820152601460248201527314185d5cd8589b194e881b9bdd081c185d5cd95960621b60448201526064016104d8565b6003805460ff60a01b191690557f5db9ee0a495bf2e6ff9c91a7834c1ba4fdd244a5e8aa4e537bd38aeae4b073aa335b6040516001600160a01b03909116815260200160405180910390a1565b6001600160a01b038316610f995760405162461bcd60e51b81526004016104d890612369565b8051825114610fba5760405162461bcd60e51b81526004016104d890612264565b6000339050610fdd818560008686604051806020016040528060008152506115ea565b60005b83518110156110a2576000848281518110610ffd57610ffd6121ea565b60200260200101519050600084838151811061101b5761101b6121ea565b602090810291909101810151600084815280835260408082206001600160a01b038c16835290935291909120549091508181101561106b5760405162461bcd60e51b81526004016104d8906123ac565b6000928352602083815260408085206001600160a01b038b168652909152909220910390558061109a81612200565b915050610fe0565b5060006001600160a01b0316846001600160a01b0316826001600160a01b03167f4a39dc06d4c0dbc64b70af90fd698a233a518aa5d07e595d983b8c0526c8f7fb86866040516110f39291906122ac565b60405180910390a450505050565b600380546001600160a01b038381166001600160a01b0319831681179093556040519116919082907f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e090600090a35050565b6001600160a01b0384166111b35760405162461bcd60e51b815260206004820152602160248201527f455243313135353a206d696e7420746f20746865207a65726f206164647265736044820152607360f81b60648201526084016104d8565b336111d3816000876111c4886117b0565b6111cd886117b0565b876115ea565b6000848152602081815260408083206001600160a01b0389168452909152812080548592906112039084906121d2565b909155505060408051858152602081018590526001600160a01b0380881692600092918516917fc3d58168c5ae7397731d063d5bbf3d657854427343f4c083240f7aacaa2d0f62910160405180910390a46107ce816000878787876117fb565b600354600160a01b900460ff16156112b05760405162461bcd60e51b815260206004820152601060248201526f14185d5cd8589b194e881c185d5cd95960821b60448201526064016104d8565b6003805460ff60a01b1916600160a01b1790557f62e78cea01bee320cd4e420270b5ea74000d11b0c9f74754ebdbfc544b05a258610f563390565b816001600160a01b0316836001600160a01b0316141561135f5760405162461bcd60e51b815260206004820152602960248201527f455243313135353a2073657474696e6720617070726f76616c20737461747573604482015268103337b91039b2b63360b91b60648201526084016104d8565b6001600160a01b03838116600081815260016020908152604080832094871680845294825291829020805460ff191686151590811790915591519182527f17307eab39ab6107e8899845ad3d59bd9653f200f220920489ca2b5937696c31910160405180910390a3505050565b6001600160a01b0384166113f25760405162461bcd60e51b81526004016104d8906122da565b336114028187876111c4886117b0565b6000848152602081815260408083206001600160a01b038a168452909152902054838110156114435760405162461bcd60e51b81526004016104d89061231f565b6000858152602081815260408083206001600160a01b038b81168552925280832087850390559088168252812080548692906114809084906121d2565b909155505060408051868152602081018690526001600160a01b03808916928a821692918616917fc3d58168c5ae7397731d063d5bbf3d657854427343f4c083240f7aacaa2d0f62910160405180910390a46114e08288888888886117fb565b50505050505050565b6001600160a01b03831661150f5760405162461bcd60e51b81526004016104d890612369565b3361153e81856000611520876117b0565b611529876117b0565b604051806020016040528060008152506115ea565b6000838152602081815260408083206001600160a01b03881684529091529020548281101561157f5760405162461bcd60e51b81526004016104d8906123ac565b6000848152602081815260408083206001600160a01b03898116808652918452828520888703905582518981529384018890529092908616917fc3d58168c5ae7397731d063d5bbf3d657854427343f4c083240f7aacaa2d0f62910160405180910390a45050505050565b600354600160a01b900460ff16156116375760405162461bcd60e51b815260206004820152601060248201526f14185d5cd8589b194e881c185d5cd95960821b60448201526064016104d8565b610ece8686868686866118c5565b6001600160a01b0384163b15610ece5760405163bc197c8160e01b81526001600160a01b0385169063bc197c819061168990899089908890889088906004016123f0565b602060405180830381600087803b1580156116a357600080fd5b505af19250505080156116d3575060408051601f3d908101601f191682019092526116d09181019061244e565b60015b611780576116df61246b565b806308c379a0141561171957506116f4612487565b806116ff575061171b565b8060405162461bcd60e51b81526004016104d89190611c3d565b505b60405162461bcd60e51b815260206004820152603460248201527f455243313135353a207472616e7366657220746f206e6f6e20455243313135356044820152732932b1b2b4bb32b91034b6b83632b6b2b73a32b960611b60648201526084016104d8565b6001600160e01b0319811663bc197c8160e01b146114e05760405162461bcd60e51b81526004016104d890612511565b604080516001808252818301909252606091600091906020808301908036833701905050905082816000815181106117ea576117ea6121ea565b602090810291909101015292915050565b6001600160a01b0384163b15610ece5760405163f23a6e6160e01b81526001600160a01b0385169063f23a6e619061183f9089908990889088908890600401612559565b602060405180830381600087803b15801561185957600080fd5b505af1925050508015611889575060408051601f3d908101601f191682019092526118869181019061244e565b60015b611895576116df61246b565b6001600160e01b0319811663f23a6e6160e01b146114e05760405162461bcd60e51b81526004016104d890612511565b6001600160a01b03851661194c5760005b835181101561194a578281815181106118f1576118f16121ea565b60200260200101516004600086848151811061190f5761190f6121ea565b60200260200101518152602001908152602001600020600082825461193491906121d2565b90915550611943905081612200565b90506118d6565b505b6001600160a01b038416610ece5760005b83518110156114e057828181518110611978576119786121ea565b602002602001015160046000868481518110611996576119966121ea565b6020026020010151815260200190815260200160002060008282546119bb919061259e565b909155506119ca905081612200565b905061195d565b8280546119dd90612181565b90600052602060002090601f0160209004810192826119ff5760008555611a45565b82601f10611a1857805160ff1916838001178555611a45565b82800160010185558215611a45579182015b82811115611a45578251825591602001919060010190611a2a565b50611a51929150611a55565b5090565b5b80821115611a515760008155600101611a56565b80356001600160a01b03811681146106c157600080fd5b60008060408385031215611a9457600080fd5b611a9d83611a6a565b946020939093013593505050565b6001600160e01b03198116811461058c57600080fd5b600060208284031215611ad357600080fd5b8135611ade81611aab565b9392505050565b634e487b7160e01b600052604160045260246000fd5b601f8201601f1916810167ffffffffffffffff81118282101715611b2157611b21611ae5565b6040525050565b600067ffffffffffffffff831115611b4257611b42611ae5565b604051611b59601f8501601f191660200182611afb565b809150838152848484011115611b6e57600080fd5b83836020830137600060208583010152509392505050565b600060208284031215611b9857600080fd5b813567ffffffffffffffff811115611baf57600080fd5b8201601f81018413611bc057600080fd5b611bcf84823560208401611b28565b949350505050565b600060208284031215611be957600080fd5b5035919050565b6000815180845260005b81811015611c1657602081850181015186830182015201611bfa565b81811115611c28576000602083870101525b50601f01601f19169290920160200192915050565b602081526000611ade6020830184611bf0565b600060208284031215611c6257600080fd5b611ade82611a6a565b600067ffffffffffffffff821115611c8557611c85611ae5565b5060051b60200190565b600082601f830112611ca057600080fd5b81356020611cad82611c6b565b604051611cba8282611afb565b83815260059390931b8501820192828101915086841115611cda57600080fd5b8286015b84811015611cf55780358352918301918301611cde565b509695505050505050565b600082601f830112611d1157600080fd5b611ade83833560208501611b28565b60008060008060808587031215611d3657600080fd5b611d3f85611a6a565b9350602085013567ffffffffffffffff80821115611d5c57600080fd5b611d6888838901611c8f565b94506040870135915080821115611d7e57600080fd5b611d8a88838901611c8f565b93506060870135915080821115611da057600080fd5b50611dad87828801611d00565b91505092959194509250565b600080600080600060a08688031215611dd157600080fd5b611dda86611a6a565b9450611de860208701611a6a565b9350604086013567ffffffffffffffff80821115611e0557600080fd5b611e1189838a01611c8f565b94506060880135915080821115611e2757600080fd5b611e3389838a01611c8f565b93506080880135915080821115611e4957600080fd5b50611e5688828901611d00565b9150509295509295909350565b60008060408385031215611e7657600080fd5b823567ffffffffffffffff80821115611e8e57600080fd5b818501915085601f830112611ea257600080fd5b81356020611eaf82611c6b565b604051611ebc8282611afb565b83815260059390931b8501820192828101915089841115611edc57600080fd5b948201945b83861015611f0157611ef286611a6a565b82529482019490820190611ee1565b96505086013592505080821115611f1757600080fd5b50611f2485828601611c8f565b9150509250929050565b600081518084526020808501945080840160005b83811015611f5e57815187529582019590820190600101611f42565b509495945050505050565b602081526000611ade6020830184611f2e565b600080600060608486031215611f9157600080fd5b611f9a84611a6a565b9250602084013567ffffffffffffffff80821115611fb757600080fd5b611fc387838801611c8f565b93506040860135915080821115611fd957600080fd5b50611fe686828701611c8f565b9150509250925092565b6000806000806080858703121561200657600080fd5b61200f85611a6a565b93506020850135925060408501359150606085013567ffffffffffffffff81111561203957600080fd5b611dad87828801611d00565b6000806040838503121561205857600080fd5b61206183611a6a565b91506020830135801515811461207657600080fd5b809150509250929050565b6000806040838503121561209457600080fd5b61209d83611a6a565b91506120ab60208401611a6a565b90509250929050565b600080600080600060a086880312156120cc57600080fd5b6120d586611a6a565b94506120e360208701611a6a565b93506040860135925060608601359150608086013567ffffffffffffffff81111561210d57600080fd5b611e5688828901611d00565b60008060006060848603121561212e57600080fd5b61213784611a6a565b95602085013595506040909401359392505050565b6020808252818101527f4f776e61626c653a2063616c6c6572206973206e6f7420746865206f776e6572604082015260600190565b600181811c9082168061219557607f821691505b602082108114156121b657634e487b7160e01b600052602260045260246000fd5b50919050565b634e487b7160e01b600052601160045260246000fd5b600082198211156121e5576121e56121bc565b500190565b634e487b7160e01b600052603260045260246000fd5b6000600019821415612214576122146121bc565b5060010190565b60208082526029908201527f455243313135353a2063616c6c6572206973206e6f74206f776e6572206e6f7260408201526808185c1c1c9bdd995960ba1b606082015260800190565b60208082526028908201527f455243313135353a2069647320616e6420616d6f756e7473206c656e677468206040820152670dad2e6dac2e8c6d60c31b606082015260800190565b6040815260006122bf6040830185611f2e565b82810360208401526122d18185611f2e565b95945050505050565b60208082526025908201527f455243313135353a207472616e7366657220746f20746865207a65726f206164604082015264647265737360d81b606082015260800190565b6020808252602a908201527f455243313135353a20696e73756666696369656e742062616c616e636520666f60408201526939103a3930b739b332b960b11b606082015260800190565b60208082526023908201527f455243313135353a206275726e2066726f6d20746865207a65726f206164647260408201526265737360e81b606082015260800190565b60208082526024908201527f455243313135353a206275726e20616d6f756e7420657863656564732062616c604082015263616e636560e01b606082015260800190565b6001600160a01b0386811682528516602082015260a06040820181905260009061241c90830186611f2e565b828103606084015261242e8186611f2e565b905082810360808401526124428185611bf0565b98975050505050505050565b60006020828403121561246057600080fd5b8151611ade81611aab565b600060033d11156124845760046000803e5060005160e01c5b90565b600060443d10156124955790565b6040516003193d81016004833e81513d67ffffffffffffffff81602484011181841117156124c557505050505090565b82850191508151818111156124dd5750505050505090565b843d87010160208285010111156124f75750505050505090565b61250660208286010187611afb565b509095945050505050565b60208082526028908201527f455243313135353a204552433131353552656365697665722072656a656374656040820152676420746f6b656e7360c01b606082015260800190565b6001600160a01b03868116825285166020820152604081018490526060810183905260a06080820181905260009061259390830184611bf0565b979650505050505050565b6000828210156125b0576125b06121bc565b50039056fea2646970667358221220be637918bdca4c14465b1aabd822cccef9072643c00d3c89ef0e52df5b35eca864736f6c6343000809003368747470733a2f2f697066732e70686c6f74652e78797a2f686f7464726f702f7b69647d2e6a736f6e";

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
