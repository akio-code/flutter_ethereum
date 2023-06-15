// SPDX-License-Identifier: UNLICENSED
// sepolia contract: 0x12D85959751F255CF3763cDF5b256a3aB317c6f1
pragma solidity ^0.8.0;

contract Ownable {
    address private owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    modifier onlyValidAddress(address _newAddress) {
        require(_newAddress != address(0), "Invalid new owner address");
        _;
    }

    function getOwner() public view returns (address) {
        return owner;
    }
}

contract RentContract is Ownable {
    uint256 private constant MONTHS_OF_RENT = 36;

    mapping(address => Contract) private contracts;

    struct Contract {
        address owner;
        address tenant;
        uint256[MONTHS_OF_RENT] rentals;
    }

    modifier existingContract() {
        require(
            contracts[msg.sender].owner != address(0),
            "Contract does not exist"
        );
        _;
    }

    modifier validMonth(uint256 _month) {
        require(_month > 0 && _month <= MONTHS_OF_RENT, "Invalid month");
        _;
    }

    constructor() {}

    function createContract(address _tenant, uint256 _rentValue)
    public
    returns (bool)
    {
        uint256[MONTHS_OF_RENT] memory rentals;
        for (uint256 i = 0; i < MONTHS_OF_RENT; i++) {
            rentals[i] = _rentValue;
        }

        contracts[msg.sender] = Contract(msg.sender, _tenant, rentals);

        return true;
    }

    function getMyContract()
    public
    view
    existingContract
    returns (Contract memory)
    {
        return contracts[msg.sender];
    }

    function updateContractRentals(uint256 _currentMonth, uint256 _newValue)
    public
    onlyOwner
    existingContract
    validMonth(_currentMonth)
    returns (bool)
    {
        uint256[MONTHS_OF_RENT] memory rentals;
        for (uint256 i = 0; i < MONTHS_OF_RENT; i++) {
            if (i < _currentMonth) {
                rentals[i] = contracts[msg.sender].rentals[i];
            } else {
                rentals[i] = _newValue;
            }
        }

        contracts[msg.sender] = Contract(
            msg.sender,
            contracts[msg.sender].tenant,
            rentals
        );

        return true;
    }

    function transferRentOwnership(address _newOwner)
    public
    onlyOwner
    onlyValidAddress(_newOwner)
    {
        Contract memory contractData = contracts[msg.sender];
        contractData.owner = _newOwner;

        delete contracts[msg.sender];
        contracts[_newOwner] = contractData;
    }
}
