// contracts/RentContract.sol
// SPDX-License-Identifier: MIT
// contract sepolia: 0x29dCF032900fF8727ff7fC02129D103109161Db3

pragma solidity ^0.8.0;

contract RentContract {
    uint private constant totalMeses = 36;
    string public locador;
    string public locatario;
    uint256[totalMeses] alugueis;

    constructor(string memory _locador, string memory _locatario, uint256 _valorAluguel) {
        locador = _locador;
        locatario = _locatario;
        for(uint i = 0; i < totalMeses; i++) {
            alugueis[i] = _valorAluguel;
        }
    }

    function aluguelDoMes(uint8 mes) public view returns (uint256) {
        return alugueis[mes - 1];
    }

    function partes() public view returns(string memory _locador, string memory _locatario) {
        return (locador, locatario);
    }

    function mudarParte(string memory _nome, uint8 _parte) public {
        if (_parte == 1) {
            locador = _nome;
        } else if (_parte == 2) {
            locatario = _nome;
        }
    }

    function atualizarProximosAlugueis(uint8 _mesAtual, uint256 _valorAumento) public {
        for(uint i = _mesAtual; i < totalMeses; i++) {
            alugueis[i] = alugueis[i] + _valorAumento;
        }
    }
}
