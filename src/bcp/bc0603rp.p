/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC0603RP 2.00.00.012}  /*** 010012 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc0603rp MBC}
&ENDIF


/*************************************************************************
**
**     Programa BC0603RP.P
**
**************************************************************************/

def var c-lit-selecao     as char format "x(10)" no-undo.
def var c-lit-impressao   as char format "x(15)" no-undo.
def var c-lit-classific   as char format "x(20)" no-undo.
def var c-destino         as char format "x(10)" no-undo.
def var c-classific       as char format "x(20)" no-undo.
def var h-acomp           as handle              no-undo.
def var c-it-codigo       as char format "x(10)" no-undo.
def var c-desc-item       as char format "x(15)" no-undo.
def var c-nome-abrev      as char format "x(20)" no-undo.
def var c-it-codigo-1     as char format "x(16)" no-undo.
def var c-imprime-etiq    as char format "x(08)" no-undo.
def var c-qt-etiq-item    as char format "x(10)" no-undo.
def var c-tipo-etiq       as char format "x(06)" no-undo.
def var c-qt-etiq-total   as char format "x(12)" no-undo.
def var c-tipo-etiq-total as char format "x(11)" no-undo.

def new global shared var i-ep-codigo-usuario  like empresa.ep-codigo no-undo.
def new global shared var v_cdn_empres_usuar   like empresa.ep-codigo        no-undo.

{bcp/bc0603.i} /* Include para a defini‡Æo da temp-table de parƒmetros gerais */
{bcp/bcproxy.i2}    /* Defini‡äes das procedures para integra‡Æo com o Magnus i.00 */

def query qr-bc-ext-item-emit for bc-ext-item-emit, ttItem.

define temp-table tt-raw-digita NO-UNDO
    field raw-digita    as raw.

def input param r-raw as raw no-undo.
def input param table for tt-raw-digita.

create tt-param.
raw-transfer r-raw to tt-param.

run utp/ut-acomp.p persistent set h-acomp.

{utp/ut-liter.i "ExtensÆo Item Emitente" * L}
run pi-inicializar in h-acomp (input trim(return-value)).

form header
    c-it-codigo       no-label at 02
    c-desc-item       no-label at 19
    c-nome-abrev      no-label at 40
    c-it-codigo-1     no-label at 61
    c-imprime-etiq    no-label at 78
    c-qt-etiq-item    no-label at 87
    c-tipo-etiq       no-label at 100
    c-qt-etiq-total   no-label at 107
    c-tipo-etiq-total no-label at 120
    skip
    "---------------- -------------------- -------------------- ---------------- -------- ------------ ------ ------------ -----------" at 02
    skip
with side-labels stream-io width 132 page-top frame f-bc-ext-item-emit.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-bc-ext-item-emit:HANDLE).


form header
    c-nome-abrev      no-label at 02
    c-it-codigo       no-label at 23
    c-desc-item       no-label at 40
    c-it-codigo-1     no-label at 61
    c-imprime-etiq    no-label at 78
    c-qt-etiq-item    no-label at 87
    c-tipo-etiq       no-label at 100
    c-qt-etiq-total   no-label at 107
    c-tipo-etiq-total no-label at 120
    skip
    "-------------------- ---------------- -------------------- ---------------- -------- ------------ ------ ------------ -----------" at 02
with side-labels stream-io width 132 page-top frame f-bc-ext-emit-item.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-bc-ext-emit-item:HANDLE).


form
    skip(2)
    c-lit-selecao         no-label colon 30
    skip(1)
    tt-param.item-ini     format "x(16)" colon 30 "|< >|"
    tt-param.item-fim     format "x(16)" no-label
    skip
    tt-param.nome-abrev-ini format "x(16)" colon 30 "|< >|"
    tt-param.nome-abrev-fim format "x(16)" no-label
    skip(1) 
    c-lit-classific       no-label colon 30
    skip(1)
    c-classific           no-label colon 30
    skip(1)
    c-lit-impressao       no-label colon 30
    skip(1)
    c-destino             colon 30 "-"
    tt-param.arquivo      no-label format "x(30)"
with side-label stream-io width 132 frame f-fim.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-fim:HANDLE).


{utp/ut-liter.i Sele‡Æo * R}
assign c-lit-selecao = trim(return-value) + ":".

{utp/ut-liter.i ImpressÆo * R}
assign c-lit-impressao = trim(return-value) + ":".

{utp/ut-liter.i Classifica‡Æo * R}
assign c-lit-classific = trim(return-value) + ":".

{utp/ut-liter.i Destino * R}
assign c-destino:label in frame f-fim = trim(return-value).

if tt-param.i-classificacao = 1 then
    {utp/ut-liter.i "Por Item" * L}
else
    {utp/ut-liter.i "Por Emitente" * L}
assign c-classific = trim(return-value).


{utp/ut-liter.i "Item" * L}
assign  tt-param.item-ini:label in frame f-fim  = trim(return-value)
        c-it-codigo                             = trim(return-value).

{utp/ut-liter.i "Nome Abrev" * L}
assign  tt-param.nome-abrev-ini:label in frame f-fim    = trim(return-value)
        c-nome-abrev                                    = trim(return-value).

{utp/ut-liter.i Descri‡Æo * L}
assign c-desc-item = trim(return-value).

{utp/ut-liter.i "Item Externo 1" * L}
assign c-it-codigo-1 = trim(return-value).

{utp/ut-liter.i "Imp Etq?" * L}
assign c-imprime-etiq = trim(return-value).

{utp/ut-liter.i "Qtd/Etq" * L}
assign c-qt-etiq-item = trim(return-value).

{utp/ut-liter.i "Tp Etq" * L}
assign c-tipo-etiq = trim(return-value).

{utp/ut-liter.i "Qtd/Etq Tot" * L}
assign c-qt-etiq-total = trim(return-value).

{utp/ut-liter.i "Tp Etiq Tot" * L}
c-tipo-etiq-total = trim(return-value).

{include/i-rpvar.i}

assign i-ep-codigo-usuario = tt-param.ep-codigo
       v_cdn_empres_usuar  = i-ep-codigo-usuario.

find first empresa no-lock
    where empresa.ep-codigo = i-ep-codigo-usuario no-error.
if  avail empresa then
    assign c-empresa = empresa.razao-social.
else
    assign c-empresa = "".

{utp/ut-liter.i "Relat¢rio de ExtensÆo Item Emitente" * L}
assign c-titulo-relat = trim(return-value).
 
{utp/ut-liter.i "Coleta de Dados" * C}
assign c-sistema  = trim(return-value).

{include/i-rpcab.i}
{include/i-rpout.i}

view frame f-cabec.
view frame f-rodape.

if tt-param.i-classificacao = 1 then
    view frame f-bc-ext-item-emit.
else if tt-param.i-classificacao = 2 then
    view frame f-bc-ext-emit-item.

if tt-param.i-classificacao = 1
then do:
    for  each bc-ext-item-emit no-lock
        where bc-ext-item-emit.it-codigo  >= tt-param.item-ini
          and bc-ext-item-emit.it-codigo  <= tt-param.item-fim
          and bc-ext-item-emit.nome-abrev >= tt-param.nome-abrev-ini
          and bc-ext-item-emit.nome-abrev <= tt-param.nome-abrev-fim
          by bc-ext-item-emit.it-codigo
          by bc-ext-item-emit.nome-abrev.
        run pi-imprime.
    end.
end.
else if tt-param.i-classificacao = 2
then do:
    for  each bc-ext-item-emit no-lock
        where bc-ext-item-emit.it-codigo  >= tt-param.item-ini
          and bc-ext-item-emit.it-codigo  <= tt-param.item-fim
          and bc-ext-item-emit.nome-abrev >= tt-param.nome-abrev-ini
          and bc-ext-item-emit.nome-abrev <= tt-param.nome-abrev-fim
          by bc-ext-item-emit.nome-abrev
          by bc-ext-item-emit.it-codigo.
        run pi-imprime.
    end.
end.

assign c-destino = {varinc/var00002.i 04 tt-param.destino}.

disp
    c-lit-selecao
    tt-param.item-ini
    tt-param.item-fim
    tt-param.nome-abrev-ini
    tt-param.nome-abrev-fim
    c-lit-classific
    c-classific
    c-lit-impressao
    c-destino
    tt-param.arquivo
    with frame f-fim.

{include/i-rpclo.i}

run pi-finalizar in h-acomp.

return "OK".

/************************************************************************************************************/
Procedure Pi-Imprime:
    run pi-acompanhar in h-acomp (input trim(c-it-codigo)   + ": " + bc-ext-item-emit.it-codigo +
                                  c-nome-abrev              + ": " + bc-ext-item-emit.nome-abrev).

    run pi-verifica-item  ( input bc-ext-item-emit.it-codigo,
                            input bc-ext-item-emit.it-codigo,
                            input 0,   /* Tipo de Acesso 0=Currente .... */
                            input 1).
    {utp/ut-liter.i Sim/NÆo *}
    if tt-param.i-classificacao = 1 then Do:
        put bc-ext-item-emit.it-codigo                          at 02
            ttItem.desc-item                 format "x(20)"     at 19
            bc-ext-item-emit.nome-abrev                         at 40
            bc-ext-item-emit.it-codigo-ext-1                    at 61
            bc-ext-item-emit.imprime-etiq  Format Return-value  at 78
            bc-ext-item-emit.qt-etiq-item  format ">>>,>>9.999" at 87
            string(bc-ext-item-emit.tipo-etiq,"9999")           at 100
            bc-ext-item-emit.qt-etiq-total format ">>>,>>9.999" at 108
            string(bc-ext-item-emit.tipo-etiq-total,"9999")     at 127
            skip.

    End.
            
    else if tt-param.i-classificacao = 2 then
        put bc-ext-item-emit.nome-abrev                         at 02
            bc-ext-item-emit.it-codigo                          at 23
            ttItem.desc-item                 format "x(20)"     at 40
            bc-ext-item-emit.it-codigo-ext-1                    at 61
            bc-ext-item-emit.imprime-etiq Format Return-value   at 78
            bc-ext-item-emit.qt-etiq-item  format ">>>,>>9.999" at 87
            string(bc-ext-item-emit.tipo-etiq,"9999")           at 100
            bc-ext-item-emit.qt-etiq-total format ">>>,>>9.999" at 108
            string(bc-ext-item-emit.tipo-etiq-total,"9999")     at 120
            skip.

end.
