// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "lib/forge-std/src/Script.sol";
import {Fractal} from "../src/Fractal.sol";

contract DeployFractal is Script {
    function run() external {
        vm.startBroadcast();
        new Fractal("Fractal", "FRCTL");
        vm.stopBroadcast();
    }
}
