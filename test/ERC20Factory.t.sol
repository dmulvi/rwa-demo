// test/ERC20Factory.t.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "lib/forge-std/src/Test.sol";
import "../src/ERC20Factory.sol";
import "../src/ERC20Token.sol";

contract ERC20FactoryTest is Test {
    ERC20Factory factory;

    function setUp() public {
        factory = new ERC20Factory();
    }

    function testCreateERC20Token() public {
        factory.createERC20Token("TestToken", "TTK", 1000);
        // You can add more assertions here to validate the created token.
    }
}
