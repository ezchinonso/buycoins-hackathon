//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.0;

import {L1Bridge} from "./interfaces/L1Bridge.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract BuycoinsL1 is Ownable {
    L1Bridge public l1Bridge;

    // polygon testnet chainID. hardcoded for now
    uint256 public immutable T_POLYGON_CHAINID = 80001;

    IERC20 public token;

    // @TODO Emit events

    constructor(address hopL1Bridge, address _token) {
        l1Bridge = L1Bridge(hopL1Bridge);
        token = IERC20(_token);
    }

   function getBalance() public view returns(uint256) {
        return IERC20(token).balanceOf(address(this));
    }

    function transferToL2(uint256 amount, address _recipient) private onlyOwner {
        require(amount > 0 && _recipient != address(0));
        l1Bridge.sendToL2(
            T_POLYGON_CHAINID, 
            _recipient, 
            amount, 
            1, 
            block.timestamp + 15, 
            address(0), 
            0);
    }

    function transfer(uint256 _amount, address recipient) private onlyOwner {
        uint256 balance = getBalance();
        require(_amount <= balance);
        IERC20(token).transferFrom(address(this), recipient, _amount);
    }
    function transferAll(address recipient) private onlyOwner {
        transfer(getBalance(), recipient);
    }

    
}
