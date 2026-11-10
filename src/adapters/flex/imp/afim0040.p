 /*
 * Copyright (c) 2010, TOTVS S/A. Todos os direitos reservados.
 *
 * Os Programas desta Aplicaá∆o (que incluem tanto o software quanto a sua
 * documentaá∆o) contÇm informaá‰es propriet†rias da TOTVS S/A; eles s∆o
 * licenciados de acordo com um contrato de licenáa contendo restriá‰es de uso e
 * confidencialidade, e s∆o tambÇm protegidos pela Lei 9609/98 e 9610/98,
 * respectivamente Lei do Software e Lei dos Direitos Autorais. Engenharia
 * reversa, descompilaá∆o e desmontagem dos programas s∆o proibidos. Nenhuma
 * parte destes programas pode ser reproduzida ou transmitida de nenhuma forma e
 * por nenhum meio, eletrìnico ou mecÉnico, por motivo algum, sem a permiss∆o
 * escrita da TOTVS S/A.
 */
{include/CallFlex.i}

{include/i-prgvrs.i afim0040 2.00.00.000}

def new global shared var p-num-pedido    as integer  no-undo.
def new global shared var l-add-ccp       as logical   no-undo.
def new global shared var p-cod-emitente  as   integer               no-undo.
def new global shared var gr-pedido-compr as rowid   no-undo.

FIND FIRST pedido-compr WHERE pedido-compr.num-pedido = int(zParams) NO-LOCK NO-ERROR.

assign p-num-pedido    = int(zParams)
       l-add-ccp       = yes
       gr-pedido-compr = ROWID(pedido-compr).

run value("imp/im0040.w").

