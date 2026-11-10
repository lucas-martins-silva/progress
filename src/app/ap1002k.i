/************************************************************************
***
***  app/ap1002k.i - Defini‡Æo de Variaveis Locais.
***
************************************************************************/

def var i-cont         as integer no-undo.
def var i-aux          as integer init 0 no-undo.
def var i-erro         as integer init 0 no-undo.
def var i-qte-erro     as integer init 0 no-undo.
def var h-acomp        as handle  no-undo.
def var l-data-cons    as logical init no no-undo.
def var da-ta-cons-ini as date format "99/99/9999" no-undo.
def var da-ta-cons-fim as date format "99/99/9999" no-undo.
def var c-message      as char format "x(40)" no-undo.
def var c-numero       like tit-ap.pedido format "x(15)" no-undo.
def var c-numero-banco like tit-ap.titulo-banco format "x(15)" no-undo.
def var i-cod-trans    as int no-undo.
def var c-cod-ocor     as char format "x" no-undo.

def var c-descr-erros as char format "x(65)" extent 73 init
    [ "100 - Conta Corrente nÆo Cadastrada",
      "112 - Transa‡Æo Inv lida - J  cadastrada",
      "114 - Altera‡Æo Inv lida - Compromisso Liberado para Pagamento",
      "130 - Compromisso com Pagamento j  Efetuado",
      "132 - Fornecedor nÆo Cadastrado",
      "139 - Compromisso nÆo Cadastrado",
      "145 - Autoriza‡Æo Inv lida Pre. Conferˆncia MSG.",
      "148 - Transa‡Æo Inv lida - Redigita‡Æo Pendente",
      "157 - Agˆncia Conta Corrente Invalida",
      "195 - Cobran‡a - Agˆncia D‚bito = Agencia para Pagamento",
      "196 - Cobran‡a - Data Pagamento = Data Vencimento",
      "197 - Data Pagto Feriado Agˆncia Pagto ou agencia Debito",
      "198 - Compromisso ja Debitado do Cliente",
      "200 - Nome/Endereco do Fornecedor Obrigat¢rio",
      "201 - Cod. do Fornecedor deve ser n£merico",
      "202 - Cod. do Fornecedor com D¡gito Inv lido",
      "203 - CGC / CPF Deve ser Num‚rico",
      "204 - CGC / CPF Com D¡gito Inv lido",
      "206 - Banco para Cr‚dito Deve ser Num‚rico",
      "207 - Agencia para Credito Deve ser Num‚rico",
      "210 - Banco para cr‚dito nÆo cadastrado",
      "213 - Volume j  processado, dados duplicados",
      "216 - Cobran‡a - Data de Pagamento Inv lida",
      "217 - Compromisso Bloqueado por Insuficiencia de Saldo",
      "250 - Dt. Vencimento ou Valor Deve ser N£merico nao Nulo",
      "251 - Data de Vencimento Invalida",
      "252 - Tipo de Pagamento Invalido",
      "253 - Data de vencimento Inv lida",
      "254 - Banco Portador do Titulo Deve ser N£merico",
      "255 - Agencia para Pagamento Inv lida",
      "258 - Tipo de Documento do Compromisso nÆo Cadastrado",
      "259 - Moeda nÆo Cadastrada",
      "260 - Data de Pagamento Menor ou Igual a Data de Hoje",
      "261 - Banco Portador do T¡tulo nao Cadastrado",
      "262 - Agencia para Pagamento nÆo Cadastrada",
      "264 - Dados Incompletos para Pagamento",
      "265 - Dados Incompletos para Pagamento com DOC",
      "266 - Dados Incompletos para Pagamento em C/C",
      "269 - Compromisso Versus Agˆncia para Pagamento Incompleto",
      "271 - Compromisso j  Autorizado ou Bloqueado",
      "303 - Data Invalida",
      "312 - N£mero do Documento(compromisso) Invalido",
      "313 - Compromisso j  Cadastrado",
      "314 - Cƒmara de Compensa‡Æo Inv lida",
      "315 - Valor do Abatimento Inv lido",
      "316 - Valor do Juro/Multa Inv lido",
      "317 - C/C Deve ser Num‚rica",
      "323 - C¢digo de Instru‡Æo Invalido",
      "324 - Agˆncia/Cliente esta Diferente do Registro Header",
      "325 - Falta Registro Num‚rico XXXX",
      "326 - Registro Fora de Ordem",
      "327 - Num‚rico do Registro Deve ser Num‚rico",
      "328 - Cliente Difere em Rela‡Æo ao Informado",
      "331 - Valor Autorizado Invalido",
      "332 - Compromisso Inv lido",
      "333 - Compromisso nÆo Pode ser Bloqueado",
      "334 - Compromisso nÆo Pode ser Desbloqueado",
      "335 - C¢digo de Alegacao Inv lido",
      "336 - Descri‡Æo de Alega‡Æo Inv lida",
      "337 - Cliente Inv lido",
      "371 - Agˆncia para cr‚dito inv lida",
      "375 - Agˆncia/Conta Corrente inv lida (TECBAN)",
      "378 - Banco/Portador inv lido",
      "379 - Banco destino inv lido",
      "382 - Compromisso Duplicado",
      "536 - Linha digit vel inv lida",
      "537 - Registro Rejeitado na cr¡tica pr‚via",
      "538 - Data inv lida para tipo de pagamento (cheque)",
      "606 - D¡gito do c¢digo de barras inv lido",
      "654 - TED inferior ao valor m¡nimo",
      "860 - Banco de destino inv lido para TED",
      " "].

/* Fim de Include */
