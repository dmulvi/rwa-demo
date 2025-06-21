// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Fraction} from "./Fraction.sol"; // Import the Fraction ERC-721 contract

contract FractionFactory is Ownable {
    // this is the ERC-20/BEP-20 Fractal token
    IERC20 public paymentToken;
    address public freAddress;

    event TokenCreated(address tokenAddress);
    event PaymentTokenUpdated(address paymentToken);
    event FreAddressUpdated(address freAddress);

    constructor(
        address _tokenAdmin,
        IERC20 _paymentToken,
        address _freAddress
    ) Ownable(_tokenAdmin) {
        paymentToken = IERC20(_paymentToken);
        freAddress = _freAddress;
    }

    function createFractionatedToken(
        string memory name,
        string memory symbol,
        uint256 totalSupply,
        uint256 mintPrice,
        address paymentRecipient
    ) external returns (address) {
        Fraction token = new Fraction(
            name,
            symbol,
            totalSupply,
            msg.sender,
            paymentToken,
            mintPrice,
            paymentRecipient,
            freAddress
        );
        emit TokenCreated(address(token));

        return address(token);
    }

    function setPaymentToken(IERC20 _paymentToken) external onlyOwner {
        paymentToken = IERC20(_paymentToken);
        emit PaymentTokenUpdated(address(_paymentToken));
    }

    function setFreAddress(address _freAddress) external onlyOwner {
        freAddress = _freAddress;
        emit FreAddressUpdated(_freAddress);
    }
}
