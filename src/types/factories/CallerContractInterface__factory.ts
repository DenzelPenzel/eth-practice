/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import { Signer, utils, Contract, ContractFactory, Overrides } from "ethers";
import { Provider, TransactionRequest } from "@ethersproject/providers";
import type {
  CallerContractInterface,
  CallerContractInterfaceInterface,
} from "../CallerContractInterface";

const _abi = [
  {
    inputs: [
      {
        internalType: "uint256",
        name: "_ethPrice",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "id",
        type: "uint256",
      },
    ],
    name: "callback",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
];

const _bytecode =
  "0x608060405234801561001057600080fd5b5060e78061001f6000396000f3fe6080604052348015600f57600080fd5b506004361060285760003560e01c8063b5d73ba414602d575b600080fd5b60436004803603810190603f9190605c565b6045565b005b5050565b600081359050605681609d565b92915050565b60008060408385031215606e57600080fd5b6000607a858286016049565b92505060206089858286016049565b9150509250929050565b6000819050919050565b60a4816093565b811460ae57600080fd5b5056fea2646970667358221220e63efd0160e2dc9fe24f96fe5bee165e7e0976b61e68847e7cc5ef7f9da260df64736f6c63430008040033";

export class CallerContractInterface__factory extends ContractFactory {
  constructor(
    ...args: [signer: Signer] | ConstructorParameters<typeof ContractFactory>
  ) {
    if (args.length === 1) {
      super(_abi, _bytecode, args[0]);
    } else {
      super(...args);
    }
  }

  deploy(
    overrides?: Overrides & { from?: string | Promise<string> }
  ): Promise<CallerContractInterface> {
    return super.deploy(overrides || {}) as Promise<CallerContractInterface>;
  }
  getDeployTransaction(
    overrides?: Overrides & { from?: string | Promise<string> }
  ): TransactionRequest {
    return super.getDeployTransaction(overrides || {});
  }
  attach(address: string): CallerContractInterface {
    return super.attach(address) as CallerContractInterface;
  }
  connect(signer: Signer): CallerContractInterface__factory {
    return super.connect(signer) as CallerContractInterface__factory;
  }
  static readonly bytecode = _bytecode;
  static readonly abi = _abi;
  static createInterface(): CallerContractInterfaceInterface {
    return new utils.Interface(_abi) as CallerContractInterfaceInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): CallerContractInterface {
    return new Contract(
      address,
      _abi,
      signerOrProvider
    ) as CallerContractInterface;
  }
}
