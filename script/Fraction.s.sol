// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "lib/forge-std/src/Script.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Fraction} from "../src/Fraction.sol";

// this deploy script mostly exists so that I can deploy and verify a copy of the Fraction contract
// so that when the factory deploys subsequent versions of them they will also appear as verified.
// if/when the underlying Fraction.sol contract changes and the factory deploys that, then a new copy of
// Fraction.sol must be deployed to ensure the factory deployed contracts are also verified.

contract DeployFraction is Script {
    function run() external {
        address owner = vm.envAddress("DEPLOYER");
        IERC20 fractalToken = IERC20(vm.envAddress("FRACTAL_TOKEN"));
        address freAddress = vm.envAddress("RULES_ENGINE_ADDRESS");

        vm.startBroadcast();
        new Fraction(
            "Danny",
            "DANNY",
            10000,
            owner,
            fractalToken,
            5000000000000000000,
            owner,
            freAddress
        );
        vm.stopBroadcast();
    }
}
