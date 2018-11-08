pragma solidity 0.4.25;
 contract UsoDeImagem {
	
    string public nomeEmpresa;
    address agente;
    address artista;
	
    modifier somenteArtista() {
        require(msg.sender==artista, "Somente artista pode realizar essa operação");
        _;
    }
     constructor() public {
        nomeEmpresa = "Artista SuperPop Ltda";
        artista = msg.sender;
    }
	
    function definirNomeDaEmpresa(string qualNomeDaEmpresa) public somenteArtista  {
        nomeEmpresa = qualNomeDaEmpresa;
    }
     function definirAgente(address qualAgente) public somenteArtista  {
        require(qualAgente != address(0), "Endereço de agente invalido");
        agente = qualAgente;
    }
	
    function receberPeloUso() public payable {
        require(msg.value >= 100 szabo, "Por favor pague o valor mínimo");
        if (agente != address(0)) {
            agente.transfer((msg.value * 10) / 100);
        }
    }
}
  
37  aula12/index.html
@@ -0,0 +1,37 @@
<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Direito de Uso de Produção Artística</title>
</head>
<body>
    <div class="container">
        <div>
            <h1>Página de gestão de direitos artísticos de: <span id="spanNomeEmpresa"></span></h1>
        </div>
        <div id="statusConexao"></div>
        <hr>
        <div>
            <form action="#" id="formNomeEmpresa" name="formNomeEmpresa">
                <div>
                    Nome da empresa:
                </div>
                <div>
                    <input type="text" name="campoNomeEmpresa" id="campoNomeEmpresa" size="100">
                </div>
                <div>
                    <button onclick="registrarNomeEmpresa(); return false;"> Registrar no Blockchain </button>
                </div>
            </form>
            <div id="statusTransacaoNomeEmpresa"></div>
        </div>
    </div>
    <script src="js/conexaoweb3.js"></script>
    <script src="js/usodeimagem.js"></script>
    <script>
        obtemNomeEmpresa();
    </script>
</body>
</html> 
  
41  aula12/js/conexaoweb3.js
@@ -0,0 +1,41 @@
var contaUsuario;
 // Verifica a conexão Web3 e a conta do usuario
function verificaConta() {
    var statusConexao = document.getElementById("statusConexao");
    // Verifica o status da conexão 
    if (web3 && web3.isConnected()) {
        if (web3.eth.accounts[0] == undefined)  {
            console.info('Não esta conectado ao Metamask');
            statusConexao.innerHTML = "Desconectado";  
        }  else {
            console.info('Conectado. Qual versão da lib Web3 foi injetado pelo Metamask? ' + web3.version.api);
            contaUsuario = web3.eth.accounts[0];
            statusConexao.innerHTML = 'Conectado a conta ' + contaUsuario;  
        }
    } else {
        statusConexao.innerHTML = 'Desconectado';
    }
}
 window.addEventListener('load', async (event) => {
    var statusConexao = document.getElementById("statusConexao");
    // Navegadores com novo Metamask    
    if (window.ethereum) {
        window.web3 = new Web3(ethereum);
        try {
            // Solicita acesso a carteira Ethereum se necessário
            await ethereum.enable()
            console.log("Usando nova versão");
            // Contas agora estão expostas                  
        } catch (error) { // Usuário ainda não deu permissão para acessar a carteira Ethereum        
            alert('Por favor, dê permissão para acessarmos a sua carteira Ethereum.');
            statusConexao.innerHTML = 'Desconectado';
        }
    } else if (window.web3) { // Navegadores DApp antigos
        window.web3 = new Web3(web3.currentProvider)
    } else { // 
        alert('Para utilizar os nossos serviços você precisa instalar o Metamask. Por favor, visite: metamask.io');
    }
    verificaConta();
});
  
91  aula12/js/usodeimagem.js
@@ -0,0 +1,91 @@
const contratoUsoDeImagemABI = [
	{
		"constant": true,
		"inputs": [],
		"name": "nomeEmpresa",
		"outputs": [
			{
				"name": "",
				"type": "string"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [],
		"name": "receberPeloUso",
		"outputs": [],
		"payable": true,
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "qualAgente",
				"type": "address"
			}
		],
		"name": "definirAgente",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "qualNomeDaEmpresa",
				"type": "string"
			}
		],
		"name": "definirNomeDaEmpresa",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "constructor"
	}
];
 var contratoUsoDeImagem = web3.eth.contract(contratoUsoDeImagemABI).at("0xcb5eb5a839b07d97faf2103c133e5f078123d5e7");
 function obtemNomeEmpresa() {
    contratoUsoDeImagem.nomeEmpresa({from: contaUsuario, gas: 3000000, value: 0}, function (err, resultado) {
        if (err)    {
            console.log("Erro");
            console.error(err);
        } else {
            console.log("Resultado");
            let objStatus = document.getElementById("spanNomeEmpresa");
            console.log(resultado);
            objStatus.innerText = resultado;
        }
    });
}
 function registrarNomeEmpresa() {
	var statusTransacao = document.getElementById("statusTransacaoNomeEmpresa");
	var nomeEmpresa = document.formNomeEmpresa.campoNomeEmpresa.value;
	contratoUsoDeImagem.definirNomeDaEmpresa(nomeEmpresa, {from: contaUsuario, gas: 3000000, value: 0}, function (err, resultado) {
        if (err)    {
            console.log("Erro");
			console.error(err);
			statusTransacao.innerHTML = "Erro: " + err;
        } else {
            console.log("Resultado");
            console.log(resultado);
            statusTransacao.innerHTML = "Sucesso: " + err;
        }
    });
} 
