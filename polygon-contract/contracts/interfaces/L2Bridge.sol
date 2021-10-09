//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.0;

interface L2Bridge {

    function send(
        uint256 chainId,
        address recipient,
        uint256 amount,
        uint256 bonderFee,
        uint256 amountOutMin,
        uint256 deadline
    )
        external;
}