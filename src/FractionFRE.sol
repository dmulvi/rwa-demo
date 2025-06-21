import "@thrackle-io/forte-rules-engine/src/client/RulesEngineClient.sol";

// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.24;

/**
 * @title Template Contract for Testing the Rules Engine
 * @author @mpetersoCode55, @ShaneDuncan602, @TJ-Everett, @VoR0220
 * @dev This file serves as a template for dynamically injecting custom Solidity modifiers into smart contracts.
 *              It defines an abstract contract that extends the `RulesEngineClient` contract, providing a placeholder
 *              for modifiers that are generated and injected programmatically.
 */
abstract contract FractionFRE is RulesEngineClient {
    modifier checkRulesBefore_update(address to, uint256 tokenId) {
        bytes memory encoded = abi.encodeWithSelector(msg.sig, to, tokenId);
        _invokeRulesEngine(encoded);
        _;
    }

    modifier checkRulesAfter_update(address to, uint256 tokenId) {
        bytes memory encoded = abi.encodeWithSelector(msg.sig, to, tokenId);
        _;
        _invokeRulesEngine(encoded);
    }
}
