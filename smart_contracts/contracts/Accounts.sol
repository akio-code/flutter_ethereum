// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Accounts {
    mapping(address => Account) public accounts;
    uint public totalAccounts;

    struct Account {
        string nameAccount;
        address addressAccount;
        uint balance;
        bool status;
    }

    modifier onlyExistingAccount(address _addressAccount) {
        require(accounts[_addressAccount].status == true, "Account doesn't exist");
        _;
    }

    function addAccount(
        string _nameAccount,
        address _addressAccount,
        uint256 _initialDeposit)
    external
    returns (bool) {
        require(_initialDeposit > 0, "No deposit, no play");
        require(_addressAccount != address(0), "Invalid address");
        require(accounts[_addressAccount].status == false, "Existing account");

        Account newAccount = Account(_nameAccount, _addressAccount, _initialDeposit, true);
        accounts[_addressAccount] = newAccount;
        totalAccounts++;

        return true;
    }

    function setBalance(
        address _addressAccount,
        uint _newBalance)
    external
    onlyExistingAccount(_addressAccount)
    returns (bool) {
        require(_newBalance > 0, "Invalid balance");

        accounts[_addressAccount].balance = _newBalance;

        return true;
    }

    function excludeAccount(
        address _addressAccount)
    external
    onlyExistingAccount(_addressAccount)
    returns(bool) {
        accounts[_addressAccount].status == false;
        totalAccounts--;
        return true;
    }

    function getAccountData(
        address _accountAddress)
    external
    view
    onlyExistingAccount(_accountAddress)
    returns (Account) {
        return accounts[_accountAddress];
    }
}
