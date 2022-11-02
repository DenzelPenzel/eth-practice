/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import {
  ethers,
  EventFilter,
  Signer,
  BigNumber,
  BigNumberish,
  PopulatedTransaction,
  BaseContract,
  ContractTransaction,
  Overrides,
  PayableOverrides,
  CallOverrides,
} from "ethers";
import { BytesLike } from "@ethersproject/bytes";
import { Listener, Provider } from "@ethersproject/providers";
import { FunctionFragment, EventFragment, Result } from "@ethersproject/abi";
import type { TypedEventFilter, TypedEvent, TypedListener } from "./common";

interface ZombieHelperInterface extends ethers.utils.Interface {
  functions: {
    "changeDna(uint256,uint256)": FunctionFragment;
    "changeName(uint256,string)": FunctionFragment;
    "createRandomZombie(string)": FunctionFragment;
    "feedOnKitty(uint256,uint256)": FunctionFragment;
    "getZombiesByOwner(address)": FunctionFragment;
    "isOwner()": FunctionFragment;
    "levelUp(uint256)": FunctionFragment;
    "owner()": FunctionFragment;
    "renounceOwnership()": FunctionFragment;
    "setKittyContractAddress(address)": FunctionFragment;
    "setLevelUpFee(uint256)": FunctionFragment;
    "transferOwnership(address)": FunctionFragment;
    "withdraw()": FunctionFragment;
    "zombieToOwner(uint256)": FunctionFragment;
    "zombies(uint256)": FunctionFragment;
  };

  encodeFunctionData(
    functionFragment: "changeDna",
    values: [BigNumberish, BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "changeName",
    values: [BigNumberish, string]
  ): string;
  encodeFunctionData(
    functionFragment: "createRandomZombie",
    values: [string]
  ): string;
  encodeFunctionData(
    functionFragment: "feedOnKitty",
    values: [BigNumberish, BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "getZombiesByOwner",
    values: [string]
  ): string;
  encodeFunctionData(functionFragment: "isOwner", values?: undefined): string;
  encodeFunctionData(
    functionFragment: "levelUp",
    values: [BigNumberish]
  ): string;
  encodeFunctionData(functionFragment: "owner", values?: undefined): string;
  encodeFunctionData(
    functionFragment: "renounceOwnership",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "setKittyContractAddress",
    values: [string]
  ): string;
  encodeFunctionData(
    functionFragment: "setLevelUpFee",
    values: [BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "transferOwnership",
    values: [string]
  ): string;
  encodeFunctionData(functionFragment: "withdraw", values?: undefined): string;
  encodeFunctionData(
    functionFragment: "zombieToOwner",
    values: [BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "zombies",
    values: [BigNumberish]
  ): string;

  decodeFunctionResult(functionFragment: "changeDna", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "changeName", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "createRandomZombie",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "feedOnKitty",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "getZombiesByOwner",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "isOwner", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "levelUp", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "owner", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "renounceOwnership",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "setKittyContractAddress",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "setLevelUpFee",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "transferOwnership",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "withdraw", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "zombieToOwner",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "zombies", data: BytesLike): Result;

  events: {
    "NewZombie(uint256,string,uint256)": EventFragment;
    "OwnershipTransferred(address,address)": EventFragment;
  };

  getEvent(nameOrSignatureOrTopic: "NewZombie"): EventFragment;
  getEvent(nameOrSignatureOrTopic: "OwnershipTransferred"): EventFragment;
}

export type NewZombieEvent = TypedEvent<
  [BigNumber, string, BigNumber] & {
    zombieId: BigNumber;
    name: string;
    dna: BigNumber;
  }
>;

export type OwnershipTransferredEvent = TypedEvent<
  [string, string] & { previousOwner: string; newOwner: string }
>;

export class ZombieHelper extends BaseContract {
  connect(signerOrProvider: Signer | Provider | string): this;
  attach(addressOrName: string): this;
  deployed(): Promise<this>;

  listeners<EventArgsArray extends Array<any>, EventArgsObject>(
    eventFilter?: TypedEventFilter<EventArgsArray, EventArgsObject>
  ): Array<TypedListener<EventArgsArray, EventArgsObject>>;
  off<EventArgsArray extends Array<any>, EventArgsObject>(
    eventFilter: TypedEventFilter<EventArgsArray, EventArgsObject>,
    listener: TypedListener<EventArgsArray, EventArgsObject>
  ): this;
  on<EventArgsArray extends Array<any>, EventArgsObject>(
    eventFilter: TypedEventFilter<EventArgsArray, EventArgsObject>,
    listener: TypedListener<EventArgsArray, EventArgsObject>
  ): this;
  once<EventArgsArray extends Array<any>, EventArgsObject>(
    eventFilter: TypedEventFilter<EventArgsArray, EventArgsObject>,
    listener: TypedListener<EventArgsArray, EventArgsObject>
  ): this;
  removeListener<EventArgsArray extends Array<any>, EventArgsObject>(
    eventFilter: TypedEventFilter<EventArgsArray, EventArgsObject>,
    listener: TypedListener<EventArgsArray, EventArgsObject>
  ): this;
  removeAllListeners<EventArgsArray extends Array<any>, EventArgsObject>(
    eventFilter: TypedEventFilter<EventArgsArray, EventArgsObject>
  ): this;

  listeners(eventName?: string): Array<Listener>;
  off(eventName: string, listener: Listener): this;
  on(eventName: string, listener: Listener): this;
  once(eventName: string, listener: Listener): this;
  removeListener(eventName: string, listener: Listener): this;
  removeAllListeners(eventName?: string): this;

  queryFilter<EventArgsArray extends Array<any>, EventArgsObject>(
    event: TypedEventFilter<EventArgsArray, EventArgsObject>,
    fromBlockOrBlockhash?: string | number | undefined,
    toBlock?: string | number | undefined
  ): Promise<Array<TypedEvent<EventArgsArray & EventArgsObject>>>;

  interface: ZombieHelperInterface;

  functions: {
    changeDna(
      _zombieId: BigNumberish,
      _newDna: BigNumberish,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<ContractTransaction>;

    changeName(
      _zombieId: BigNumberish,
      _newName: string,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<ContractTransaction>;

    createRandomZombie(
      _name: string,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<ContractTransaction>;

    feedOnKitty(
      _zombieId: BigNumberish,
      _kittyId: BigNumberish,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<ContractTransaction>;

    getZombiesByOwner(
      _owner: string,
      overrides?: CallOverrides
    ): Promise<[BigNumber[]]>;

    isOwner(overrides?: CallOverrides): Promise<[boolean]>;

    levelUp(
      _zombieId: BigNumberish,
      overrides?: PayableOverrides & { from?: string | Promise<string> }
    ): Promise<ContractTransaction>;

    owner(overrides?: CallOverrides): Promise<[string]>;

    renounceOwnership(
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<ContractTransaction>;

    setKittyContractAddress(
      _address: string,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<ContractTransaction>;

    setLevelUpFee(
      _fee: BigNumberish,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<ContractTransaction>;

    transferOwnership(
      newOwner: string,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<ContractTransaction>;

    withdraw(
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<ContractTransaction>;

    zombieToOwner(
      arg0: BigNumberish,
      overrides?: CallOverrides
    ): Promise<[string]>;

    zombies(
      arg0: BigNumberish,
      overrides?: CallOverrides
    ): Promise<
      [string, BigNumber, number, number, number, number] & {
        name: string;
        dna: BigNumber;
        level: number;
        readyTime: number;
        winCount: number;
        lossCount: number;
      }
    >;
  };

  changeDna(
    _zombieId: BigNumberish,
    _newDna: BigNumberish,
    overrides?: Overrides & { from?: string | Promise<string> }
  ): Promise<ContractTransaction>;

  changeName(
    _zombieId: BigNumberish,
    _newName: string,
    overrides?: Overrides & { from?: string | Promise<string> }
  ): Promise<ContractTransaction>;

  createRandomZombie(
    _name: string,
    overrides?: Overrides & { from?: string | Promise<string> }
  ): Promise<ContractTransaction>;

  feedOnKitty(
    _zombieId: BigNumberish,
    _kittyId: BigNumberish,
    overrides?: Overrides & { from?: string | Promise<string> }
  ): Promise<ContractTransaction>;

  getZombiesByOwner(
    _owner: string,
    overrides?: CallOverrides
  ): Promise<BigNumber[]>;

  isOwner(overrides?: CallOverrides): Promise<boolean>;

  levelUp(
    _zombieId: BigNumberish,
    overrides?: PayableOverrides & { from?: string | Promise<string> }
  ): Promise<ContractTransaction>;

  owner(overrides?: CallOverrides): Promise<string>;

  renounceOwnership(
    overrides?: Overrides & { from?: string | Promise<string> }
  ): Promise<ContractTransaction>;

  setKittyContractAddress(
    _address: string,
    overrides?: Overrides & { from?: string | Promise<string> }
  ): Promise<ContractTransaction>;

  setLevelUpFee(
    _fee: BigNumberish,
    overrides?: Overrides & { from?: string | Promise<string> }
  ): Promise<ContractTransaction>;

  transferOwnership(
    newOwner: string,
    overrides?: Overrides & { from?: string | Promise<string> }
  ): Promise<ContractTransaction>;

  withdraw(
    overrides?: Overrides & { from?: string | Promise<string> }
  ): Promise<ContractTransaction>;

  zombieToOwner(arg0: BigNumberish, overrides?: CallOverrides): Promise<string>;

  zombies(
    arg0: BigNumberish,
    overrides?: CallOverrides
  ): Promise<
    [string, BigNumber, number, number, number, number] & {
      name: string;
      dna: BigNumber;
      level: number;
      readyTime: number;
      winCount: number;
      lossCount: number;
    }
  >;

  callStatic: {
    changeDna(
      _zombieId: BigNumberish,
      _newDna: BigNumberish,
      overrides?: CallOverrides
    ): Promise<void>;

    changeName(
      _zombieId: BigNumberish,
      _newName: string,
      overrides?: CallOverrides
    ): Promise<void>;

    createRandomZombie(_name: string, overrides?: CallOverrides): Promise<void>;

    feedOnKitty(
      _zombieId: BigNumberish,
      _kittyId: BigNumberish,
      overrides?: CallOverrides
    ): Promise<void>;

    getZombiesByOwner(
      _owner: string,
      overrides?: CallOverrides
    ): Promise<BigNumber[]>;

    isOwner(overrides?: CallOverrides): Promise<boolean>;

    levelUp(_zombieId: BigNumberish, overrides?: CallOverrides): Promise<void>;

    owner(overrides?: CallOverrides): Promise<string>;

    renounceOwnership(overrides?: CallOverrides): Promise<void>;

    setKittyContractAddress(
      _address: string,
      overrides?: CallOverrides
    ): Promise<void>;

    setLevelUpFee(_fee: BigNumberish, overrides?: CallOverrides): Promise<void>;

    transferOwnership(
      newOwner: string,
      overrides?: CallOverrides
    ): Promise<void>;

    withdraw(overrides?: CallOverrides): Promise<void>;

    zombieToOwner(
      arg0: BigNumberish,
      overrides?: CallOverrides
    ): Promise<string>;

    zombies(
      arg0: BigNumberish,
      overrides?: CallOverrides
    ): Promise<
      [string, BigNumber, number, number, number, number] & {
        name: string;
        dna: BigNumber;
        level: number;
        readyTime: number;
        winCount: number;
        lossCount: number;
      }
    >;
  };

  filters: {
    "NewZombie(uint256,string,uint256)"(
      zombieId?: null,
      name?: null,
      dna?: null
    ): TypedEventFilter<
      [BigNumber, string, BigNumber],
      { zombieId: BigNumber; name: string; dna: BigNumber }
    >;

    NewZombie(
      zombieId?: null,
      name?: null,
      dna?: null
    ): TypedEventFilter<
      [BigNumber, string, BigNumber],
      { zombieId: BigNumber; name: string; dna: BigNumber }
    >;

    "OwnershipTransferred(address,address)"(
      previousOwner?: string | null,
      newOwner?: string | null
    ): TypedEventFilter<
      [string, string],
      { previousOwner: string; newOwner: string }
    >;

    OwnershipTransferred(
      previousOwner?: string | null,
      newOwner?: string | null
    ): TypedEventFilter<
      [string, string],
      { previousOwner: string; newOwner: string }
    >;
  };

  estimateGas: {
    changeDna(
      _zombieId: BigNumberish,
      _newDna: BigNumberish,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<BigNumber>;

    changeName(
      _zombieId: BigNumberish,
      _newName: string,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<BigNumber>;

    createRandomZombie(
      _name: string,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<BigNumber>;

    feedOnKitty(
      _zombieId: BigNumberish,
      _kittyId: BigNumberish,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<BigNumber>;

    getZombiesByOwner(
      _owner: string,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    isOwner(overrides?: CallOverrides): Promise<BigNumber>;

    levelUp(
      _zombieId: BigNumberish,
      overrides?: PayableOverrides & { from?: string | Promise<string> }
    ): Promise<BigNumber>;

    owner(overrides?: CallOverrides): Promise<BigNumber>;

    renounceOwnership(
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<BigNumber>;

    setKittyContractAddress(
      _address: string,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<BigNumber>;

    setLevelUpFee(
      _fee: BigNumberish,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<BigNumber>;

    transferOwnership(
      newOwner: string,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<BigNumber>;

    withdraw(
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<BigNumber>;

    zombieToOwner(
      arg0: BigNumberish,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    zombies(arg0: BigNumberish, overrides?: CallOverrides): Promise<BigNumber>;
  };

  populateTransaction: {
    changeDna(
      _zombieId: BigNumberish,
      _newDna: BigNumberish,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<PopulatedTransaction>;

    changeName(
      _zombieId: BigNumberish,
      _newName: string,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<PopulatedTransaction>;

    createRandomZombie(
      _name: string,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<PopulatedTransaction>;

    feedOnKitty(
      _zombieId: BigNumberish,
      _kittyId: BigNumberish,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<PopulatedTransaction>;

    getZombiesByOwner(
      _owner: string,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    isOwner(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    levelUp(
      _zombieId: BigNumberish,
      overrides?: PayableOverrides & { from?: string | Promise<string> }
    ): Promise<PopulatedTransaction>;

    owner(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    renounceOwnership(
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<PopulatedTransaction>;

    setKittyContractAddress(
      _address: string,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<PopulatedTransaction>;

    setLevelUpFee(
      _fee: BigNumberish,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<PopulatedTransaction>;

    transferOwnership(
      newOwner: string,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<PopulatedTransaction>;

    withdraw(
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<PopulatedTransaction>;

    zombieToOwner(
      arg0: BigNumberish,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    zombies(
      arg0: BigNumberish,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;
  };
}
