/********************************************************
* Exemplo de codigo de zoom Flex x Progress
*
* Neste exemplo temos a chamada de um programa Progress
* a parir de um programa flex, onde pode ser passado
* parametros.
*
* Utilize o include CallFlex.i para acessar os parametros
* Existem duas variaveis, a zParams que vem com os
* parametros do flex separados por "|" (pipe) e a
* zWhSocket que e o handle do socket para que seja
* possivel enviar alguma informacao para o flex.
* Utilize a procedure sendToFlex (Parametro, valor).
* Exemplo:
* RUN sendToFlex IN zWhSocket ("Empresa", "DTS").
*
* 1.00.00.000 - 14/05/2008 - Menna - Criado o exemplo
********************************************************/

{include/CallFlex.i}

{include/i-prgvrs.i afsf0420 2.00.00.000}

/* Apresenta na tela do Progress os parametros recebidos do Flex
* Obs: 
* Todos os parâmetros enviados do Flex virao separados por "|"
*/

/* Executa o programa progress desejado */
run value("sfc/sf0420.w").