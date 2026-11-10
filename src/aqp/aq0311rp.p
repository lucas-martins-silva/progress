/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AQ0311RP 2.00.00.026 } /*** 010026 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i AQ0311RP MAQ}
&ENDIF

/******************************************************************************
**
**  Programa: AQ0311RP
**
**  Data....: MAIO de 2016
**
**  Objetivo: Geraá∆o NF Produtor
**
**  Versao..: 
**         
******************************************************************************/

def new shared var h-acomp          as handle                 no-undo.

def var l-imprime                as log        initial yes      no-undo.
def var c-titulo-p               as char       format "x(20)"   no-undo.
def var c-destino                as char       format "x(20)"   no-undo.             

{aqp/aqapi004.i}
{aqp/aqapi004.i1 "new"} /* Definicao  tt-retorno-nota tt-erro-imp tt-fechto-docto New Shared */

{cdp/cd9701.i}

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

form tt-retorno-nota.cod-emitente    COLUMN-LABEL "Produtor"
     tt-retorno-nota.nome-abrev          COLUMN-LABEL "Nome"
     tt-retorno-nota.nro-docto
     tt-retorno-nota.nat-operacao
     tt-retorno-nota.total-item COLUMN-LABEL "Vl. Total Merc" skip
     with width 132 down frame f-nota stream-io. 
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
assign c-programa     = "AQ0311"
       c-sistema      = return-value.

{include/i-rpcab.i}
{include/i-rpout.i}

view frame f-cabec.
view frame f-rodape.

RUN aqp/aqapi004.p PERSISTENT SET h-aqapi004.

/*executa api para geraá∆o da nota fiscal*/
RUN pi-execute IN h-aqapi004 (INPUT 0, /*Nota fiscal Padr∆o*/
                              INPUT TABLE tt-param,
                              INPUT TABLE tt-digita,
                              OUTPUT TABLE tt-retorno-nota,
                              OUTPUT TABLE tt-erro-imp).

IF h-aqapi004 <> ? THEN DO:
    DELETE PROCEDURE h-aqapi004.
    ASSIGN h-aqapi004 = ?.    
END.

FOR EACH tt-retorno-nota:
    DISP tt-retorno-nota.cod-emitente
         tt-retorno-nota.nome-abrev
         tt-retorno-nota.nro-docto
         tt-retorno-nota.nat-operacao
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


