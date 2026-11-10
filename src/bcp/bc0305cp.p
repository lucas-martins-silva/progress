/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC0305CP 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BC0305CP MBC}
&ENDIF


/********************************************************************************
**
**   Programa...: BC0305CP.P
**
**   Finalidade.: Cria‡Æo de etiquetas de Ordem de Produ‡Æo no Coleta de Dados.
**
**   VersÆo.....: 01.00.00 - Cria‡Æo do programa (Fabio)
**
**   Parƒmetros.: 1 - C¢digo da transa‡Æo de Recebimento do Coleta de Dados
**                2 - Temp-table tt-etiqueta
**                3 - Temp-table tt-erro
**
********************************************************************************/
/*** Defini‡Æo da temp-table de erros ***/
{cdp/cd0666.i}

/*** Defini‡Æo das temp-tables para a API de cria‡Æo de transa‡Æo do CLD tt-trans***/
{bcp/bcapi001.i}

/*** Defini»’o da temp-table para a API de rateiro da quantidade pelo fator do item/familia ***/
{bcp/bcapi011.i}

/*** Defini‡Æo da temp-table para a API de cria‡Æo de etiquetas tt-etiqueta***/
{bcp/bcapi002.i}

/*** variaveis globais ***/
{utp/ut-glob.i}

/*** Defini‡Æo dos parƒmetros de entrada ***/
def input        param c-cd-trans  as char format "X(08)" no-undo.
def input        param table for tt-etiqueta. 
def input-output param table for tt-erro. 
/**/

def new Global shared var c-seg-usuario as char format "x(12)" no-undo.

def var c-det         as char     no-undo.
def var c-liter-doc   as char     no-undo.
def var c-liter-item  as char     no-undo.
def var c-liter-qtde  as char     no-undo.
def var c-liter-data  as char     no-undo.
def var c-nro         as char     no-undo.
def var c-arquivo     as char     no-undo.
def var de-nr-embal   as decimal  no-undo.

{utp/ut-liter.i Doc * r}
assign c-liter-doc = trim(return-value).
{utp/ut-liter.i Item * r}
assign c-liter-item = trim(return-value).
{utp/ut-liter.i Qtde * r}
assign c-liter-qtde = trim(return-value).
{utp/ut-liter.i Data * r}
assign c-liter-data = trim(return-value).

for each tt-etiqueta:
    /*** Cria tt-trans e tt-etiq ***/

    for each tt-etq-item:
        delete tt-etq-item.
    end.

    create tt-etq-item.
    assign tt-etq-item.cod-versao-integracao = 1
           tt-etq-item.it-codigo             = tt-etiqueta.it-codigo
           tt-etq-item.qt-item               = tt-etiqueta.quantidade
           tt-etq-item.cd-trans              = c-cd-trans.

    run bcp/bcapi011.p (input-output table tt-etq-item).

    find first tt-etq-item no-lock no-error.

    if  return-value = "NOK" then next.

    assign c-det =  c-cd-trans
                  + " -> " + c-liter-doc
                  + ": " + string(tt-etiqueta.nr-docto)
                  + ", " + c-liter-item
                  + ": " + string(tt-etiqueta.it-codigo)
                  + ", " + c-liter-qtde
                  + ": " + trim(string(tt-etiqueta.quantidade, ">>>>>,>>9.9999"))
                  + ": " + c-liter-data
                  + ": " + string(today).

    assign tt-etiqueta.cd-trans        = c-cd-trans
           tt-etiqueta.it-codigo-ext-1 = tt-etq-item.it-codigo-ext-1
           tt-etiqueta.it-codigo-ext-2 = tt-etq-item.it-codigo-ext-2
           tt-etiqueta.it-codigo-ext-3 = tt-etq-item.it-codigo-ext-3
           tt-etiqueta.it-codigo-ext-4 = tt-etq-item.it-codigo-ext-4
           tt-etiqueta.qt-etiqueta     = tt-etq-item.qt-etiqueta
           tt-etiqueta.tipo-etiq       = tt-etq-item.tipo-etiq.

    create tt-trans.
    assign tt-trans.cod-versao-integracao = 1
           tt-trans.i-sequen              = tt-etiqueta.i-sequen
           tt-trans.cd-trans              = c-cd-trans
           tt-trans.nr-trans              = 0
           tt-trans.detalhe               = c-det
           tt-trans.usuario               = c-seg-usuario
           tt-trans.atualizada            = no
           tt-trans.etiqueta              = yes.

    raw-transfer tt-etiqueta to tt-trans.conteudo-trans.
end.

/*** Chama API de cria‡Æo de transa‡äes ***/

run bcp/bcapi001.p (input-output table tt-trans,
                    input-output table tt-erro).

find first tt-erro no-error.

if  avail tt-erro then return "NOK".
else return "OK".
