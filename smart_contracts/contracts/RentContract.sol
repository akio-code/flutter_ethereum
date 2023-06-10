// contracts/RentContract.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RentContract {
    string public locador;
    string public locatario;
    uint256[36] alugueis;

    constructor(string memory _locador, string memory _locatario, uint256 _valorAluguel) {
        locador = _locador;
        locatario = _locatario;
        for(uint i = 0; i < 36; i++) {
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

    function atualizarProximosAlugueis(uint8 _mesAtual, uint256 _valor) public {
        for(uint i = _mesAtual; i < 36; i++) {
            alugueis[i] = _valor;
        }
    }
}