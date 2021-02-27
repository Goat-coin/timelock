// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/// @title Token Lock Contract
/// @author milkycyborg
/// @dev Contract that locks 1/5 of treasury tokens for 5 month
/// In Code We Trust.
contract TokenLock is Ownable {
  using SafeERC20 for IERC20;

  uint256 public constant lockLength = 150 days;
  IERC20 public constant lockedToken = IERC20(0x7c67DCCb04b67d4666fd97B2a00bb6D9B8D82E3F);

  uint256 public lockAmount = 0;
  uint256 public startTime = 0;
  bool public locked = false;
  bool public done = false;

  function lockToken(uint256 amount) external onlyOwner {
    require(!done, "Already used");
    require(!locked, "Already locked");

    lockedToken.safeTransferFrom(_msgSender(), address(this), amount);

    lockAmount = amount;
    startTime = block.timestamp;
    locked = true;
  }

  function unlockToken() external onlyOwner {
    require(block.timestamp >= startTime + lockLength, "Not unlocked");
    require(locked, "Not locked");

    lockedToken.safeTransfer(_msgSender(), lockAmount);

    locked = false;
    done = true;
  }
}
