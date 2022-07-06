//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Allownce is Ownable {
    mapping(address => uint256) public allownce;

    function addAllownce(address _who, uint256 amount) public onlyOwner {
        allownce[_who] = amount;
    }

    function isOwner() public view returns (bool) {
        return owner() == msg.sender;
    }

    modifier ownerAllowed(uint256 _amount) {
        require(
            isOwner() || allownce[msg.sender] >= _amount,
            "Only Owner can do"
        );
        _;
    }

    function reduceAllownce(address _who, uint256 _amount) internal {
        allownce[_who] -= _amount;
    }

    function withdrawMoney(address payable _to, uint256 amount)
        public
        ownerAllowed(amount)
    {
        require(
            amount <= address(this).balance,
            "You don't have enough amount"
        );
        if (!isOwner()) {
            reduceAllownce(msg.sender, amount);
        }
        _to.transfer(amount);
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function sendETHtoContract(uint256 amount) public payable {
        //msg.value is the amount of wei that the msg.sender sent with this transaction.
        //If the transaction doesn't fail, then the contract now has this ETH.
    }
}
