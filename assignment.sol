// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Assignment{
    address public merchant;
    address public buyer;
    uint256 public price;

    constructor() {
        merchant = msg.sender;
    }

    event Received(address, uint256);
    event Withdraw(address, uint256);

    modifier isMerchant() {
        require(msg.sender == merchant, "Caller is not Merchant");
        _;
    }
    function setPrice(uint256 _price) public isMerchant{
        price = _price;
    }
    
    function getAmount() public view returns(uint256){
        // 3000000 is gas limit set in Remix IDE and 24.91 is gas price per unit
        uint256 gasFee = 3000000 * 24.91;
        uint256 amountToPay = price + gasFee;
        return amountToPay;
    }

    receive() external payable{
        emit Received(msg.sender, msg.value);
    }

    function balance() public view returns (uint256){
        return payable(address(this)).balance;
    }

    function withdrawMoney() public isMerchant{
        address payable to = payable(msg.sender);
        to.transfer(balance());
    }

}