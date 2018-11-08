@@ -86,7 +86,7 @@ function registrarNomeEmpresa() {
        } else {
            console.log("Resultado");
            console.log(resultado);
            statusTransacao.innerHTML = "Sucesso: " + resultado;
            statusTransacao.innerHTML = "Transação enviada ao Blockchain Ethereum. Faça a monitoração pelo hash: " + resultado;
        }
    });
} 
