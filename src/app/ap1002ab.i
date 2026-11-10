/************************************************************************
***
***  app/ap1002ab.i - Defini‡Æo de Variaveis Locais.
***
************************************************************************/

def var i-cont        as integer.
def var l-data-cons   as logical init no.
def var da-ta-cons-ini as date format "99/99/9999".
def var da-ta-cons-fim as date format "99/99/9999".
def var c-message      as char format "x(40)".
def var c-numero    like tit-ap.pedido format "x(15)".
def var c-cod-trans   as char format "xx".
def var c-cod-oper    as char format "x".
def var h-acomp        as handle  no-undo.

def var c-descr-erros as char format "x(65)" extent 84 init
    ["100 - Conta-corrente nao cadastrada",
     "104 - Codigo Banco nao cadastrado",
     "105 - Codigo Agencia nao cadastrado",
     "106 - Codigo do cliente nao cadastrado",
     "112 - Transacao invalida - ja cadastrado",
     "113 - Transacao invalida - nao cadastrado",
     "117 - Compromisso nao foi autorizado para pagamento",
     "132 - Codigo fornecedor nao cadastrado",
     "139 - Compromisso nao cadastrado",
     "145 - Autoriz. invalida-preencher valor juros-multa conf. mensagem",
     "148 - Transacao invalida - redigitacao pendente",
     "157 - Agencia c/c invalida",
     "158 - Numero c/c invalido",
     "195 - Pagto em cob. Age debito deve ser igual Age pagto",
     "196 - Pagto em cob. data pagto deve ser igual data vencimento",
     "197 - Data pagamento e' feriado na Age pagto ou Age debito",
     "198 - Compromisso ja foi debitado do cliente",
     "200 - Nome e endereco de fornecedor obrigatorios",
     "201 - Cod. fornecedor nao numerio",
     "202 - Cod. fornecedor c/ digito invalido",
     "203 - CGC/CPF nao numerico",
     "204 - CGC/CPF c/ digito invalido",
     "205 - Ramo atividade nao numerico",
     "206 - Banco p/ credito nao numerico",
     "207 - Agencia p/ credito nao numerico",
     "208 - Agencia do Bandeirantes nao esta cadastrada",
     "210 - Banco p/ credito nao esta cadastrado",
     "212 - Cliente nao troca fita de",
     "216 - Data vencimento invalida para pagto em 'cob'",
     "217 - Compromisso bloqueado por insuficiencia de saldo",
     "224 - Numero da lista debito invalido",
     "225 - Senha da lista debito invalida",
     "250 - Data vencimento ou valor zerados ou nao numerico",
     "251 - Data de vencimento invalida",
     "252 - Tipo de pagamento invalido",
     "253 - Data de pagamento invalida",
     "254 - Banco portador do titulo nao numerico",
     "255 - Agencia de pagamento invalida",
     "258 - Tipo de documento de compromisso nao cadastrado",
     "259 - Moeda nao esta cadastrada",
     "261 - Banco portador nao esta cadastrado",
     "262 - Agencia de pagamento nao esta cadastrado",
     "264 - Dados incompletos para pagamento",
     "265 - Pagto em doc faltando dados",
     "266 - Pagto em cc faltando dados",
     "267 - Pagto em cob faltando dados",
     "269 - Camara compensacao x agencia pagto incompativel",
     "270 - Camara compensacao nao existe para o banco",
     "271 - Tipo docto BLQ, tipo de pagto deve ser BLQ",
     "272 - Tipo de pagto BLQ, tipo de docto deve ser BLQ",
     "273 - BLQ deve ter obrigatoriamente informacoes codigo de barras",
     "274 - Tipo de docto COB, tipo de pagto deve ser COB",
     "275 - Tipo de pagto COB, tipo de docto deve ser COB",
     "290 - Nosso numero invalido",
     "301 - Data recebimento menor data referencia",
     "302 - Numero registro do header diferente",
     "303 - Registro de header do movimento invalido",
     "304 - Movimento sem header",
     "305 - Registro do arquivo remessa nao identificado",
     "306 - Volume com dados duplicados",
     "312 - Numero compromisso invalido",
     "313 - Compromisso ja cadastrado",
     "314 - Camara compensacao invalida",
     "315 - Valor abatimento invalido",
     "316 - Valor juros-multa invalido",
     "317 - Conta-corrente nao numerica",
     "323 - Tipo codigo inscricao invalido",
     "324 - Agencia/Cliente diferente do header",
     "325 - Falta de registro numerico xxxx",
     "326 - Registro fora de ordem",
     "327 - Numero registro nao numerico",
     "328 - Identificacao cliente diferente do inicial",
     "329 - Codigo operacao invalido",
     "330 - Codigo ocorrencia invalido",
     "331 - Valor autorizado invalido",
     "332 - Compromisso invalido",
     "333 - Compromisso nao pode ser bloqueado",
     "334 - Compromisso nao pode ser desbloqueado",
     "335 - Codigo alegacao invalida",
     "336 - Descricao da alegacao invalida",
     "337 - Identificacao do cliente invalida",
     "340 - Fornecedor nao cadastrado",
     "346 - Codigo de barras invalido",
     " "].
     
/* Fim da include */
