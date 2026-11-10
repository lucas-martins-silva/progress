/************************************************************************
***
***  app/ap1002i.i - Defini‡Æo de Variaveis Locais.
***
************************************************************************/

def var i-cont         as integer.
def var i-aux          as integer init 0.
def var i-erro         as integer init 0.
def var i-qte-erro     as integer init 0.
def var l-data-cons    as logical init no.
def var da-ta-cons-ini as date format "99/99/9999".
def var da-ta-cons-fim as date format "99/99/9999".
def var c-message      as char format "x(40)".
def var c-numero       like tit-ap.pedido format "x(15)".
def var i-cod-trans    as int.
def var c-cod-ocor     as char format "x".
def var h-acomp        as handle no-undo.
def var c-numero-banco like tit-ap.titulo-banco format "x(15)" no-undo.

def var c-descr-erros as char format "x(65)" extent 95 init
    [ "100 - Conta Corrente nao Cadastrada",
      "104 - Codigo do Banco nao Cadastrado",
      "105 - Codigo da Agencia nao Cadastrado",
      "106 - Codigo do Cliente nao Cadastrado",
      "132 - Fornecedor nao Cadastrado",
      "133 - Dados Incompletos ou Invalidos",
      "134 - Dados incompletos referente ao tipo de pagamento",
      "137 - Numero do documento diferente",
      "139 - Compromisso nao Cadastrado",
      "142 - Data da baixa incompativel com a data de pagamento",
      "150 - Cliente nao cadastrado",
      "151 - Cliente nao cadastrado produto Payments",
      "152 - Cliente nao cadastrado no banco de dados (RB-PES)",
      "157 - Agencia Conta Corrente Invalida",
      "158 - Numero da conta corrente invalido",
      "159 - Codigo de endereco p/correspondencia invlaido",
      "161 - Caixa Postal nao informada",
      "162 - Caixa Postal interna nao informada",
      "181 - Tipo de Documento invalido",
      "197 - Data Pagto Feriado Sucursal de Pagto ou de Debito",
      "198 - Compromisso ja Debitado",
      "201 - Cod. do Fornecedor deve ser numerico",
      "202 - Cod. do Fornecedor com Digito Invalido",
      "203 - CGC / CPF Deve ser Numerico",
      "204 - CGC / CPF Com Digito Invalido",
      "206 - Banco para Credito Deve ser Numerico",
      "207 - Agencia para Credito Deve ser Numerico",
      "208 - Agencia do Banco de Boston nao existente",
      "210 - Banco para Credito nao existente",
      "211 - Agencia/Conta do Banco de Boston nao existente",
      "212 - Cliente nao troca arquivos com o sistema de pagtos",
      "213 - Arquivo ja processado",
      "214 - Convenio nao cadastrado",
      "216 - Vencimento invalido para tipo de pagamento COB",
      "221 - Reg de Header nao cadastrado",
      "223 - Banco de pagamento nao numerico",
      "233 - Agencia invlaida",
      "235 - Cliente nao autorizou pagto p/hoje",
      "240 - Data de pagto maior que vencimento nao permitida",
      "241 - Data de Debito alterada p/proximo dia util",
      "250 - Dt. Vencimento ou valor zerado",
      "251 - Data de Vencimento Invalida",
      "252 - Tipo de Pagamento Invalido",
      "253 - Data de pagamento invalida",
      "254 - Banco Portador do Titulo Deve ser Numerico",
      "255 - Agencia para Pagamento Invalida",
      "258 - Tipo de Documento do Compromisso nao Cadastrado",
      "259 - Moeda nao Cadastrada",
      "260 - Data Pagto deve ser maior que data processamento",
      "261 - Banco Portador do Titulo nao Cadastrado",
      "262 - Agencia para Pagamento nao Cadastrada",
      "264 - Dados Incompletos para Pagamento",
      "265 - Pagamento em DOC faltando dados",
      "266 - Pagamento em C/C faltando dados",
      "267 - Pagamento em COB faltando dados",
      "299 - Codigo de barras invalido",
      "300 - Remessa sem registro de Detalhe",
      "301 - Data de Recebimento Menor que data Referencia",
      "302 - Numero do registro Header diferente de 1",
      "303 - Registro Header Invalido",
      "304 - Movimento sem registro header",
      "305 - Registro nao identificado",
      "306 - Volume com dados duplicados",
      "312 - Numero do Documento(compromisso) Invalido",
      "313 - Compromisso ja Cadastrado",
      "315 - Valor do Abatimento Invalido",
      "316 - Valor do Juro/Multa Invalido",
      "317 - C/C Deve ser Numerica",
      "320 -Titulo nao capturado. Erro no CGC sacado",
      "321 - Titulo capturado indevidamente p/este convenio",
      "322 - Nao existem instrucoes para titulo",
      "323 - Sucursal do Convencio diferente do Header",
      "324 - Agencia/Cliente esta Diferente do Registro Header",
      "325 - Falta Registro Numerico XXXX",
      "326 - Registro Fora de Ordem",
      "327 - Numerico do Registro Deve ser Numerico",
      "328 - Identificacao do Cliente diferente do inicio",
      "329 - Codigo de operacao invalido",
      "330 - Codigo de ocorrencia invalido",
      "331 - Valor Autorizado Invalido",
      "332 - Compromisso Invalido",
      "333 - Compromisso nao Pode ser Bloqueado",
      "334 - Compromisso nao Pode ser Desbloqueado",
      "335 - Codigo de Alegacao Invalido",
      "336 - Descricao de Alegacao Invalida",
      "337 - Identificacao do Cliente Invalido",
      "340 - Compromisso nao pode ser excluido, ja foi debitado",
      "350 - Comprimisso com outra moeda invalido",
      "355 - Moeda invalida",
      "810 - Nao existe Header no arquivo",
      "812 - Versao do arquivo diferente no controle",
      "859 - Compromisso ja autorizado",
      "999 - Compromisso ja liquidado",
      " "].
     
/* Fim da include */
