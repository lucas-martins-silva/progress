/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AQ0327RP 2.00.00.027 } /*** 010027 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i AQ0327RP MAQ}
&ENDIF

/******************************************************************************
**
**  Programa: AQ0327RP
**
**  Data....: Dezembro de 2016
**
**  Objetivo: Geraá∆o NF Complementar Produtor
**
**  Versao..: 
**         
******************************************************************************/

def new shared var h-acomp          as handle                 no-undo.

def var l-imprime                as log        initial yes      no-undo.
def var c-titulo-p               as char       format "x(20)"   no-undo.
def var c-destino                as char       format "x(20)"   no-undo.             
def var c-contas                 as char       format "x(08)"   no-undo.
DEF VAR l-achou-tt-retorno       AS LOG                         NO-UNDO.
DEF VAR c-msg-obs                AS CHAR                        NO-UNDO.
DEF VAR c-ano                    AS CHAR       FORMAT "X(4)"    NO-UNDO.
DEF VAR c-per-ini                AS DATE                        NO-UNDO.
DEF VAR c-per-fim                AS DATE                        NO-UNDO.
DEF VAR l-erro                   AS LOG                         /*NO-UNDO n„o usar NO-UNDO, vari·vel de controle de transaÁ„o*/ .
def var c-opcao                  as CHARACTER                   NO-UNDO.

def buffer b-fechto-produt-period for fechto-produt-period.

{cdp/cd9701.i}
{aqp/aqapi004.i}
{aqp/aqapi004.i1 "new"} /* Definicao  tt-retorno-nota tt-erro-imp tt-fechto-docto New Shared */

DEF VAR de-total-item         LIKE item-doc-est.preco-total[1]    NO-UNDO.
DEF VAR c-nom-produt-rural    LIKE tt-erro-imp.nom-produt-rural   NO-UNDO.
DEF VAR c-cdn-produt-rural    AS CHAR                             NO-UNDO.
DEF VAR h-cdapi034            AS HANDLE                           NO-UNDO.
DEF VAR h-aqapi004            AS HANDLE                           NO-UNDO.
def var i-cod-regra-utilizada as integer                          NO-UNDO.

form tt-erro-imp.cdn-produt-rural COLUMN-LABEL "Produtor"
     tt-erro-imp.nom-produt-rural COLUMN-LABEL "Nome"
     tt-erro-imp.cd-erro          COLUMN-LABEL "Erro"
     tt-erro-imp.desc-erro        COLUMN-LABEL "Descriá∆o" format "x(80)" 
     with width 132 down frame f-erros stream-io.

RUN utp/ut-trfrrp.p (INPUT FRAME f-erros:HANDLE).

FORM tt-retorno-nota.cod-emitente COLUMN-LABEL "Produtor"
     tt-retorno-nota.nome-abrev   COLUMN-LABEL "Nome"
     tt-retorno-nota.cod-propried COLUMN-LABEL "Propriedade"
     tt-retorno-nota.nro-docto
     tt-retorno-nota.nat-operacao
     tt-digita.quantidade         COLUMN-LABEL "Quantidade" 
     tt-digita.val-unit           COLUMN-LABEL "Vl. Unit†rio" FORMAT ">>>,>>9.9999"
     tt-digita.val-total          COLUMN-LABEL "Vl. Total"
     tt-retorno-nota.total-item   COLUMN-LABEL "Vl. Total Merc" skip
     WITH WIDTH 132 DOWN FRAME f-nota STREAM-IO.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-nota:HANDLE).

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

for each tt-raw-digita:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
end.

form                     
   skip(2)
   c-titulo-p  no-label      colon 14 skip(1)
   c-destino                 colon 20
   tt-param.arquivo no-label          skip(1)
   tt-param.usuario          colon 20 skip(1)
   with stream-io side-labels no-attr-space no-box width 132 frame f-impressao. 
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-impressao:HANDLE).

{include/i-rpvar.i}

{utp/ut-liter.i Impress∆o_: *}
assign c-titulo-p = return-value.                       
{utp/ut-liter.i Destino *}
assign c-destino:label in frame f-impressao = return-value.
{utp/ut-liter.i Usu†rio *}
assign tt-param.usuario:label in frame f-impressao = return-value.          


find first param-global no-lock no-error.
if  avail param-global then
    assign c-empresa  = param-global.grupo.
    
{utp/ut-liter.i Geraá∆o_Notas_Produtor MAQ}
assign c-titulo-relat = return-value.

{utp/ut-liter.i AQUISIÄÂES_RURAIS maq}  
assign c-programa     = "AQ0327"
       c-sistema      = return-value.

{include/i-rpcab.i}
{include/i-rpout.i}

view frame f-cabec.
view frame f-rodape.

RUN aqp/aqapi004.p PERSISTENT SET h-aqapi004.

/*executa api para geraá∆o da nota fiscal*/
RUN pi-execute IN h-aqapi004 (INPUT 1, /*Nota fiscal Complementar*/
                              INPUT TABLE tt-param,
                              INPUT TABLE tt-digita,
                              OUTPUT TABLE tt-retorno-nota,
                              OUTPUT TABLE tt-erro-imp).

IF h-aqapi004 <> ? THEN DO:
    DELETE PROCEDURE h-aqapi004.
    ASSIGN h-aqapi004 = ?.    
END.

FOR EACH tt-retorno-nota:

    FIND FIRST tt-digita
         WHERE tt-digita.cdn-produt   = tt-retorno-nota.cod-emitente 
           AND tt-digita.cod-propried = tt-retorno-nota.cod-propried NO-ERROR.

    DISP tt-retorno-nota.cod-emitente
         tt-retorno-nota.nome-abrev
         tt-retorno-nota.cod-propried
         tt-retorno-nota.nro-docto
         tt-retorno-nota.nat-operacao
         tt-digita.quantidade WHEN AVAIL tt-digita
         tt-digita.val-unit   WHEN AVAIL tt-digita 
         tt-digita.val-total  WHEN AVAIL tt-digita 
         tt-retorno-nota.total-item
         WITH DOWN FRAME f-nota.
    DOWN WITH FRAME f-nota.
END.

/*imprime registro de erros*/
FOR EACH tt-erro-imp
    BREAK BY tt-erro-imp.cdn-produt-rural:

    IF FIRST-OF(tt-erro-imp.cdn-produt-rural) THEN
        ASSIGN c-cdn-produt-rural = string(tt-erro-imp.cdn-produt-rural)
               c-nom-produt-rural = tt-erro-imp.nom-produt-rural.
    ELSE
        ASSIGN c-cdn-produt-rural = ""
               c-nom-produt-rural = "".

    disp c-cdn-produt-rural @ tt-erro-imp.cdn-produt-rural    
         c-nom-produt-rural @ tt-erro-imp.nom-produt-rural
         tt-erro-imp.cd-erro         
         tt-erro-imp.desc-erro 
         with frame f-erros.
        down with frame f-erros.
    
    
END.

/*Imprime Destino*/
if l-imprime = yes then
  page.                

if tt-param.destino = 1 then do:
   {utp/ut-liter.i Impressora *}
   assign c-destino = return-value.
end.
if tt-param.destino = 2 then do:
   {utp/ut-liter.i Arquivo *}
   assign c-destino = return-value.
end.
if tt-param.destino = 3 then do:
   {utp/ut-liter.i Terminal *}
   assign c-destino = return-value.
end.
display c-titulo-p
        c-destino
        tt-param.arquivo
        tt-param.usuario with frame f-impressao.                           

{include/i-rpclo.i}

return "OK".


