//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import {ILendingPool} from "./interfaces/ILendingPool.sol";
import {ILendingPoolAddressesProvider} from "./interfaces/ILendingPoolAddressesProvider.sol";
import {L2Bridge} from "./interfaces/L2Bridge.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract BuycoinsL2 is Ownable {
    ILendingPoolAddressesProvider public lendingPoolAddressesProvider;
    ILendingPool public lendingPool;
    L2Bridge public l2Bridge;

    // Goelri chain id. hardcoded for now
    uint256 public immutable GOERLI_CHAINID = 5;

    IERC20 public token;

    // @TODO Emit events

    constructor(address _lendingPoolAddressesProvider, address hopL2Bridge, address _token) {
        lendingPoolAddressesProvider = ILendingPoolAddressesProvider(_lendingPoolAddressesProvider);
        lendingPool = ILendingPool(lendingPoolAddressesProvider.getLendingPool());
        l2Bridge = L2Bridge(hopL2Bridge);
        token = IERC20(_token);
    }

    function getBalance() public view returns(uint256) {
        return IERC20(token).balanceOf(address(this));
    }

    function deposit(uint256 _amount) private onlyOwner {
        require(_amount > 0);
        IERC20(token).approve(address(lendingPool), _amount);
        lendingPool.deposit(address(token), _amount, address(this), 0);
    }

    function withdraw(uint256 _amount) private onlyOwner{
        require(_amount > 0);
        lendingPool.withdraw(address(token), _amount, address(this));
    }

    function transferToL1(address _to, uint256 _amount, uint256 _bonderFee) private onlyOwner{
        
        l2Bridge.send(GOERLI_CHAINID, _to, _amount, _bonderFee, 1, block.timestamp + 15);
    }
    function yieldFarm() private onlyOwner {

    }

}
