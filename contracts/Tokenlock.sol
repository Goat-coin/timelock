// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/// @title Token Lock Contract
/// @author Affax, milkycyborg
/// @dev Contract that locks team tokens for a year
/// In Code We Trust.
contract LPLock is Ownable {
  using SafeERC20 for IERC20;

  uint256 public constant lockLength = 365 days;
  IERC20 public constant lockedToken = IERC20(0xd33bfc66b39189e3452c6e65e56572a6228dd61b);

  uint256 public lockAmount = 0;
  uint256 public startTime = 0;
  bool public locked = false;
  bool public done = false;

  function lockLP(uint256 amount) external onlyOwner {
    require(!done, "Already used");
    require(!locked, "Already locked");

    lockedToken.safeTransferFrom(_msgSender(), address(this), amount);

    lockAmount = amount;
    startTime = block.timestamp;
    locked = true;
  }

  function unlockLP() external onlyOwner {
    require(block.timestamp >= startTime + lockLength, "Not unlocked");
    require(locked, "Not locked");

    lockedToken.safeTransfer(_msgSender(), lockAmount);

    locked = false;
    done = true;
  }
}
