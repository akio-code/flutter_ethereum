// contracts/RentContract.sol
// SPDX-License-Identifier: MIT
// contract sepolia: 0xbc73BF81c7a2c82A059c712D924DC1d547b87BA5

pragma solidity ^0.8.0;

contract RentContract {
    uint private constant totalMeses = 36;
    string public locador;
    string public locatario;
    uint256[totalMeses] alugueis;

    modifier somenteParteValida(uint _parte) {
        require(_parte == 1 || _parte ==2, "Parte invalida");
        _;
    }

    modifier somenteMesValido(uint _mes) {
        require(_mes > 0 || _mes <= totalMeses, "Mes invalido");
        _;
    }

    constructor(
        string memory _locador,
        string memory _locatario,
        uint256 _valorAluguel)
    {
        locador = _locador;
        locatario = _locatario;
        for(uint i = 0; i < totalMeses; i++) {
            alugueis[i] = _valorAluguel;
        }
    }

    function aluguelDoMes(
        uint8 _mes)
    public
    view
    somenteMesValido(_mes)
    returns (uint256) {
        return alugueis[_mes - 1];
    }

    function partes()
    public
    view
    returns(string memory _locador, string memory _locatario){
        return (locador, locatario);
    }

    function mudarParte(
        string memory _nome,
        uint8 _parte)
    public
    somenteParteValida(_parte)
    returns (bool) {
        if (_parte == 1) {
            locador = _nome;
        } else if (_parte == 2) {
            locatario = _nome;
        }
        return true;
    }

    function atualizarProximosAlugueis(
        uint8 _mesAtual,
        uint256 _valorAumento)
    public
    somenteMesValido(_mesAtual)
    returns (bool) {
        for(uint i = (_mesAtual - 1); i < totalMeses; i++) {
            alugueis[i] = alugueis[i] + _valorAumento;
        }
        return true;
    }
}
