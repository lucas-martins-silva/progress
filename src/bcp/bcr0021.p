/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BCR0021 2.00.00.013}  /*** 010013 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i bcr0021 MBC}
&ENDIF

/*****************************************************************************
**
**       Programa: bcr0021.p
**
**       Data....: 08/04/99
**
**       Autor...: DATASUL S.A.
**
**       Objetivo: Relat¢rio de Extensäes do Item
**
**       VersÆo..: 1.00.000 - bc
**
**       OBS.....: Este fonte foi gerado pelo Data Viewer
**
*******************************************************************************/



/****************** Defini‡Æo de Tabelas Tempor rias do Relat¢rio **********************/

def temp-table tt-raw-digita NO-UNDO
    field raw-digita as raw.

define temp-table tt-param NO-UNDO
    field destino              as integer
    field arquivo              as char
    field usuario              as char
    field data-exec            as date
    field hora-exec            as integer
    field parametro            as logical
    field formato              as integer
    field v_num_tip_aces_usuar as integer
&IF "{&mguni_version}" >= "2.071" &THEN
    field ep-codigo            LIKE empresa.ep-codigo
&ELSE
    field ep-codigo            as integer
&ENDIF
    field c-it-codigo-ini like bc-ext-item.it-codigo
    field c-it-codigo-fim like bc-ext-item.it-codigo
.

/****************** INCLUDE COM VARIµVEIS GLOBAIS *********************/

{bcp/bcproxy.i2}    /* Defini‡äes das procedures para integra‡Æo com o Magnus i.00 */
{include/i_fnctrad.i}
{utp/ut-glob.i}

/****************** FIM INCLUDE COM VARIµVEIS GLOBAIS *********************/
/****************** Defini‡ao de Parƒmetros do Relat¢rio *********************/ 

/****************** Defini‡ao de Vari veis de Sele‡Æo do Relat¢rio *********************/ 

def new shared var c-it-codigo-ini like bc-ext-item.it-codigo format "x(16)" initial "" no-undo.
def new shared var c-it-codigo-fim like bc-ext-item.it-codigo format "x(16)" initial "ZZZZZZZZZZZZZZZZ" no-undo.

/****************** Defini‡ao de Vari veis p/ Campos Virtuais do Relat¢rio *******************/ 

/****************** Defini‡ao de Vari veis Campo do Layout do Relat¢rio **********************/ 

/****************** Defini‡ao de Vari veis do Relat¢rio NÆo Pedidas em Tela ******************/ 

/****************** Defini‡ao de Vari veis de Total do Relat¢rio *****************************/ 

/****************** Defini‡ao de Vari veis dos Calculos do Relat¢rio *************************/ 

def input param raw-param as raw no-undo.
def input param table for tt-raw-digita.

/****************** Defini‡ao de Vari veis de Processamento do Relat¢rio *********************/

def var h-acomp              as handle no-undo.
def var v-cod-destino-impres as char   no-undo.
def var v-num-reg-lidos      as int    no-undo.
def var v-num-point          as int    no-undo.
def var v-num-set            as int    no-undo.
def var v-num-linha          as int    no-undo.
Def Var v-Ltr                As Char   No-undo.
Def Var v-Ltr1               As Char   No-undo.

/****************** Defini‡ao de Forms do Relat¢rio 132 Colunas ***************************************/ 

form bc-ext-item.it-codigo column-label "Item" format "x(16)" at 001
     ttItem.desc-item column-label "Descri‡Æo" format "x(40)" at 018
     bc-ext-item.it-codigo-ext-1 column-label "Item Externo - 1" format "x(16)" at 059
     bc-ext-item.imprime-etiq column-label "Imp Etiq?" format "Sim/NÆo" at 076
     bc-ext-item.qt-etiq-item column-label "Qtd/Etq" format ">>>,>>9.999" at 086
     bc-ext-item.tipo-etiq column-label "Tp Etq" format "9999" at 098
     bc-ext-item.qt-etiq-total column-label "Qtd/Etq Tot" format ">>>,>>9.999" at 105
     bc-ext-item.tipo-etiq-total column-label "Tp Etq Tot" format "9999" at 117
     with down width 132 no-box stream-io frame f-relat-09-132.
{utp/ut-liter.i Sim/NÆo *}
Assign bc-ext-item.imprime-etiq:format In Frame f-relat-09-132 = Return-value.
&IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEN
    If Search("utp/ut-trfrrp.p") <> ? Or Search("utp/ut-trfrrp.r") <> ? Then
        Run utp/ut-trfrrp.p (input Frame f-relat-09-132:Handle).
&ENDIF

create tt-param.
raw-transfer raw-param to tt-param.

def temp-table tt-editor no-undo
    field linha      as integer
    field conteudo   as character format "x(80)"
    index editor-id is primary unique linha.


{include/i-rpvar.i}


{utp/ut-liter.i Relat¢rio_de_Extensäes_do_Item *}
assign c-programa     = "bcr0021"
       c-versao       = "1.00"
       c-revisao      = "000"
       c-titulo-relat = Return-value.
{utp/ut-liter.i Coleta_de_Dados *}
Assign c-sistema      = Return-value.

if  tt-param.formato = 2 then do:


{include/i-rpcab.i &stream="str-rp"}

end. /* tt-param.formato = 2 */


{include/i-rpout.i &stream="stream str-rp"}

    assign i-ep-codigo-usuario = tt-param.ep-codigo
           v_cdn_empres_usuar  = i-ep-codigo-usuario.

    assign c-it-codigo-ini = tt-param.c-it-codigo-ini
           c-it-codigo-fim = tt-param.c-it-codigo-fim
           c-it-codigo-fim = tt-param.c-it-codigo-fim
.


{varinc/var00002.i}

run utp/ut-acomp.p persistent set h-acomp.

find first empresa no-lock
    where empresa.ep-codigo = i-ep-codigo-usuario no-error.
if  avail empresa
then
    assign c-empresa = empresa.razao-social.
else
    assign c-empresa = "".


/* for each e disp */

def var l-imprime as logical no-undo.

assign l-imprime = no.
if  tt-param.destino = 1
then
    assign v-cod-destino-impres = "Impressora".
else
    if  tt-param.destino = 2
    then
        assign v-cod-destino-impres = "Arquivo".
    else
        assign v-cod-destino-impres = "Terminal".

Run utp/ut-liter.p (input v-cod-destino-impres,"*","").
Assign v-cod-destino-impres = Return-value.

{utp/ut-liter.i "Imp Etiq?" * L}
assign bc-ext-item.imprime-etiq:label = trim(return-value).
{utp/ut-liter.i "Qtd/Etq" * L}
assign bc-ext-item.qt-etiq-item:label = trim(return-value).
{utp/ut-liter.i "Tp Etq" * L}
assign bc-ext-item.tipo-etiq:label = trim(return-value).


run utp/ut-acomp.p persistent set h-acomp.

run pi-inicializar in h-acomp(input "ExtensÆo do Item").

assign v-num-reg-lidos = 0.

for  each bc-ext-item no-lock
    where bc-ext-item.it-codigo >= c-it-codigo-ini
      and bc-ext-item.it-codigo <= c-it-codigo-fim
    break by bc-ext-item.it-codigo
          by bc-ext-item.imprime-etiq:

    run pi-verifica-item  ( input bc-ext-item.it-codigo,
                            input bc-ext-item.it-codigo,
                            input 0,   /* Tipo de Acesso 0=Currente .... */
                            input 1).

    assign v-num-reg-lidos = v-num-reg-lidos + 1.
    run pi-acompanhar in h-acomp(input string(bc-ext-item.it-codigo)).

    /***  CàDIGO PARA SAÖDA EM 132 COLUNAS ***/

    if  tt-param.formato = 2 then do:

        view stream str-rp frame f-cabec.
        view stream str-rp frame f-rodape.
        assign l-imprime = yes.
        display stream str-rp bc-ext-item.it-codigo
                              ttItem.desc-item when avail ttitem
                              bc-ext-item.it-codigo-ext-1
                              bc-ext-item.imprime-etiq
                              bc-ext-item.qt-etiq-item
                              bc-ext-item.tipo-etiq
                              bc-ext-item.qt-etiq-total
                              bc-ext-item.tipo-etiq-total
                with stream-io frame f-relat-09-132.
        down stream str-rp with frame f-relat-09-132.
    end.
    
end.


if  l-imprime = no then do:
    if  tt-param.formato = 2 then do:
        view stream str-rp frame f-cabec.
        view stream str-rp frame f-rodape.
    end.
    disp stream str-rp " " with stream-io frame f-nulo.
end.


run pi-finalizar in h-acomp.

page stream str-rp.

if  tt-param.parametro then do:

   {utp/ut-liter.i SELE€ÇO *}
   disp stream str-rp Return-value skip(01) with stream-io frame f-imp-sel.
   disp stream str-rp 
      c-it-codigo-ini colon 17 "|< >|" c-it-codigo-fim no-label
        with stream-io side-labels overlay row 038 frame f-imp-sel.

   {utp/ut-liter.i CLASSIFICA€ÇO *}
   disp stream str-rp Return-value  Format "x(13)" skip(01) with stream-io frame f-imp-cla.
   {utp/ut-liter.i ___Por_Item *}
   disp stream str-rp Return-value Format "x(11)"
        with stream-io side-labels overlay row 038 frame f-imp-cla.

   {utp/ut-liter.i IMPRESSÇO *}
   put stream str-rp unformatted skip(1) Return-value skip(1).

   {utp/ut-liter.i Destino_:_ *}
   put stream str-rp  unformatted skip "    " Return-value v-cod-destino-impres " - " tt-param.arquivo format "x(40)".
   {utp/ut-liter.i Execu‡Æo:_ *}
   put stream str-rp  unformatted skip "    " Return-value if i-num-ped-exec-rpw = 0 then "On-Line" else "Batch".
   {utp/ut-liter.i 80_Colunas *}
   Assign v-Ltr = Return-value.
   {utp/ut-liter.i 132_Colunas *}
   Assign v-Ltr1 = Return-value.
   {utp/ut-liter.i Formato_:_ *}
   put stream str-rp  unformatted skip "    " Return-value if tt-param.formato = 1 then v-Ltr else v-Ltr1.
   {utp/ut-liter.i Usu rio_:_ *}
   put stream str-rp  unformatted skip "    " Return-value tt-param.usuario.

end.

output stream str-rp close.


{include/i-rpclo.i &stream="stream str-rp"}



procedure pi-print-editor:

    def input param c-editor    as char    no-undo.
    def input param i-len       as integer no-undo.

    def var i-linha  as integer no-undo.
    def var i-aux    as integer no-undo.
    def var c-aux    as char    no-undo.
    def var c-ret    as char    no-undo.

    for each tt-editor:
        delete tt-editor.
    end.

    assign c-ret = chr(255) + chr(255).

    do  while c-editor <> "":
        if  c-editor <> "" then do:
            assign i-aux = index(c-editor, chr(10)).
            if  i-aux > i-len or (i-aux = 0 and length(c-editor) > i-len) then
                assign i-aux = r-index(c-editor, " ", i-len + 1).
            if  i-aux = 0 then
                assign c-aux = substr(c-editor, 1, i-len)
                       c-editor = substr(c-editor, i-len + 1).
            else
                assign c-aux = substr(c-editor, 1, i-aux - 1)
                       c-editor = substr(c-editor, i-aux + 1).
            if  i-len = 0 then
                assign entry(1, c-ret, chr(255)) = c-aux.
            else do:
                assign i-linha = i-linha + 1.
                create tt-editor.
                assign tt-editor.linha    = i-linha
                       tt-editor.conteudo = c-aux.
            end.
        end.
        if  i-len = 0 then
            return c-ret.
    end.
    return c-ret.
end procedure.

return 'OK'.

