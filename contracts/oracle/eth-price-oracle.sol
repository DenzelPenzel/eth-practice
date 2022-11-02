// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "../roles.sol";
import "../ownable.sol";
import "../safemath.sol";
import "./caller-contract-interface.sol";

contract EthPriceOracle {
    using Roles for Roles.Role;
    Roles.Role private owners;
    Roles.Role private oracles;
    using SafeMath for uint256;
    uint256 private randNonce = 0;
    uint256 private modulus = 1000;
    uint256 private numOracles = 0;
    uint256 private THRESHOLD = 0;
    struct Response {
        address oracleAddress;
        address callerAddress;
        uint256 ethPrice;
    }
    mapping(uint256 => Response[]) public requestIdToResponse;
    mapping(uint256 => bool) pendingRequests;
    event GetLatestEthPriceEvent(address callerAddress, uint256 id);
    event SetLatestEthPriceEvent(uint256 ethPrice, address callerAddress);
    event AddOracleEvent(address oracleAddress);
    event RemoveOracleEvent(address oracleAddress);
    event SetThresholdEvent(uint256 threshold);

    constructor(address _owner) public {
        owners.add(_owner);
    }

    function addOracle(address _oracle) public {
        require(owners.has(msg.sender), "Not an owner!");
        require(!oracles.has(_oracle), "Already an oracle!");
        oracles.add(_oracle);
        numOracles++;
        emit AddOracleEvent(_oracle);
    }

    function removeOracle(address _oracle) public {
        require(owners.has(msg.sender), "Not an owner!");
        require(oracles.has(_oracle), "Not an oracle!");
        require(numOracles > 1, "Do not remove the last oracle!");
        oracles.remove(_oracle);
        numOracles--;
        emit RemoveOracleEvent(_oracle);
    }

    function setThreshold(uint256 _threshold) public {
        require(owners.has(msg.sender), "Not an owner!");
        THRESHOLD = _threshold;
        emit SetThresholdEvent(THRESHOLD);
    }

    function getLatestEthPrice() public returns (uint256) {
        randNonce++;
        uint256 id = uint256(
            keccak256(abi.encodePacked(block.timestamp, msg.sender, randNonce))
        ) % modulus;
        pendingRequests[id] = true;
        emit GetLatestEthPriceEvent(msg.sender, id);
        return id;
    }

    // retrieves the ETH price from the Binance public API
    function setLatestEthPrice(
        uint256 _ethPrice,
        address _callerAddress,
        uint256 _id
    ) public {
        require(oracles.has(msg.sender), "Not an oracle!");
        require(
            pendingRequests[_id],
            "This request is not in my pending list."
        );
        Response memory resp;
        resp = Response(msg.sender, _callerAddress, _ethPrice);
        requestIdToResponse[_id].push(resp);
        uint256 numResponses = requestIdToResponse[_id].length;
        if (numResponses == THRESHOLD) {
            uint256 computedEthPrice = 0;
            for (uint256 f = 0; f < requestIdToResponse[_id].length; f++) {
                computedEthPrice = computedEthPrice.add(
                    requestIdToResponse[_id][f].ethPrice
                );
            }
            computedEthPrice = computedEthPrice.div(numResponses);
            delete pendingRequests[_id];
            delete requestIdToResponse[_id];
            CallerContractInterface callerContractInstance;
            callerContractInstance = CallerContractInterface(_callerAddress);
            callerContractInstance.callback(computedEthPrice, _id);
            // notify the front-end that the price has been successfully updated
            emit SetLatestEthPriceEvent(computedEthPrice, _callerAddress);
        }
    }
}
