// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "lib/forge-std/src/Script.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {FractionFactory} from "../src/FractionFactory.sol";

contract DeployFactory is Script {
    function run() external {
        address factoryAdmin = vm.envAddress("DEPLOYER");
        IERC20 fractalToken = IERC20(vm.envAddress("FRACTAL_TOKEN"));
        address freAddress = vm.envAddress("RULES_ENGINE_ADDRESS");

        vm.startBroadcast();
        new FractionFactory(factoryAdmin, fractalToken, freAddress);
        vm.stopBroadcast();
    }
}
