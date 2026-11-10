/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0671RP 2.00.00.002} /*** "010002" 21/03/2025 09:24:36  ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0671rp MIM}
&ENDIF

{utp/ut-glob.i}

define temp-table tt-param no-undo
    field destino              as integer
    field c-destino            as char
    field arquivo              as char format "x(35)":U
    field usuario              as char format "x(12)":U
    field data-exec            as date
    field hora-exec            as integer
    field classifica           as integer
    field desc-classifica      as char format "x(40)":U
    field modelo               as char format "x(35)":U
    field c-it-codigo-ini      as char format "x(16)":U
    field c-it-codigo-fim      as char format "x(16)":U
    field i-cod-pais-ini       as integer  
    field i-cod-pais-fim       as integer  
    field i-cod-emitente-ini   as integer  
    field i-cod-emitente-fim   as integer  
    field c-cod-docto-ini      as char format "x(16)":U
    field c-cod-docto-fim      as char format "x(16)":U.

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

define buffer b-tt-digita for tt-digita.

def temp-table tt-raw-digita NO-UNDO
   field raw-digita      as raw.

define stream str-rp.

define input parameter raw-param as raw no-undo.
define input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

{include/i-rpvar.i}

/***Defini‡Æo de Vari veis***/
DEFINE VARIABLE c-lb-sel      AS CHARACTER  NO-UNDO. 
DEFINE VARIABLE c-lb-cla      AS CHARACTER  NO-UNDO.              
DEFINE VARIABLE c-lb-imp      AS CHARACTER  NO-UNDO. 
DEFINE VARIABLE c-lb-destino  AS CHARACTER  NO-UNDO. 
DEFINE VARIABLE c-lb-usuario  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-lb-execucao AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-lb-item     AS CHARACTER  NO-UNDO.  
DEFINE VARIABLE c-lb-pais     AS CHARACTER  NO-UNDO. 
DEFINE VARIABLE c-lb-fornec   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-lb-docto    AS CHARACTER  NO-UNDO. 
DEFINE VARIABLE c-nome-emit   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-nome-pais   AS CHARACTER  NO-UNDO.


/*Defini‡Æo de Frames */
form SKIP(2)
     item-docto-import.cod-docto LABEL "Documento" " - " 
     docto-import.des-docto no-label skip(1)
     with side-labels down width 132 STREAM-IO frame f-tit1.

form SKIP(2)
     item-docto-import.it-codigo  " - " 
     item.desc-item no-label skip(1)
     with side-labels down width 132 stream-io frame f-tit2.

FORM item-docto-import.it-codigo COLUMN-LABEL "Item"       FORMAT "x(16)"
     ITEM.desc-item              COLUMN-LABEL "Descri‡Æo"  FORMAT "x(45)"           
     c-nome-pais                 COLUMN-LABEL "Pa¡s"       FORMAT "x(9)"
     c-nome-emit                 COLUMN-LABEL "Fornecedor" FORMAT "x(45)"      
     with down no-box width 132 stream-io frame f-docto.

FORM item-docto-import.cod-docto COLUMN-LABEL "C¢digo Doc."          FORMAT "x(16)"   
     docto-import.des-docto      COLUMN-LABEL "Descri‡Æo Documento"  FORMAT "x(45)" 
     c-nome-pais                 COLUMN-LABEL "Pa¡s"                 FORMAT "x(9)"
     c-nome-emit                 COLUMN-LABEL "Fornecedor"           FORMAT "x(45)" 
     with down no-box width 132 stream-io frame f-item.
    

run utp/ut-trfrrp.p (input frame f-tit1:handle).
run utp/ut-trfrrp.p (input frame f-tit2:handle).
run utp/ut-trfrrp.p (input frame f-docto:handle).
run utp/ut-trfrrp.p (input frame f-item:handle).

/*Tradu‡äes*/
{utp/ut-liter.i SELE€¶O * R}
ASSIGN c-lb-sel = TRIM(RETURN-VALUE).
{utp/ut-liter.i CLASSIFICA€ÇO * R}
ASSIGN c-lb-cla = TRIM(RETURN-VALUE).
{utp/ut-liter.i IMPRESSÇO * R}
ASSIGN c-lb-imp = TRIM(RETURN-VALUE).
{utp/ut-liter.i Destino * r}
ASSIGN c-lb-destino = TRIM(RETURN-VALUE).
{utp/ut-liter.i Execu‡Æo * r}
ASSIGN c-lb-execucao = TRIM(RETURN-VALUE).
{utp/ut-liter.i Usu rio * r}
ASSIGN c-lb-usuario = TRIM(RETURN-VALUE).
{utp/ut-liter.i Item * r}
ASSIGN c-lb-item = TRIM(RETURN-VALUE).
{utp/ut-liter.i Pa¡s * r}
ASSIGN c-lb-pais = TRIM(RETURN-VALUE).
{utp/ut-liter.i Fornecedor  * r}
ASSIGN c-lb-fornec = TRIM(RETURN-VALUE).
{utp/ut-liter.i Documento * r}
ASSIGN c-lb-docto = TRIM(RETURN-VALUE).
RUN utp/ut-liter.p (INPUT tt-param.c-destino,"","").
ASSIGN tt-param.c-destino = TRIM(RETURN-VALUE).
RUN utp/ut-liter.p (INPUT REPLACE(tt-param.desc-classifica," ","_"),"","").
ASSIGN tt-param.desc-classifica = TRIM(RETURN-VALUE).
{utp/ut-liter.i Relat¢rio_de_Item_x_Documento_Importa‡Æo}
ASSIGN c-titulo-relat = TRIM(RETURN-VALUE).

{include/i-rpcab.i}
{include/i-rpout.i}


for first empresa fields (ep-codigo razao-social) where empresa.ep-codigo = i-ep-codigo-usuario NO-LOCK.
    assign c-empresa = empresa.razao-social.
end.

view frame f-cabec.
view frame f-rodape.


/*Bloco Principal*/
IF  tt-param.classifica = 1 THEN DO:
    for each item-docto-import NO-LOCK
        where   (item-docto-import.it-codigo     >= tt-param.c-it-codigo-ini
          and   item-docto-import.it-codigo      <= tt-param.c-it-codigo-fim)
          and   ((item-docto-import.cod-pais     >= tt-param.i-cod-pais-ini
          and   item-docto-import.cod-pais       <= tt-param.i-cod-pais-fim)
          or    (item-docto-import.cod-pais      = ? 
                   AND tt-param.i-cod-pais-ini = 0))
          and   ((item-docto-import.cod-emitente >= tt-param.i-cod-emitente-ini
          and   item-docto-import.cod-emitente   <= tt-param.i-cod-emitente-fim)
          or    (item-docto-import.cod-emitente   = ? 
                   AND tt-param.i-cod-emitente-ini = 0))
          and   (item-docto-import.cod-docto     >= tt-param.c-cod-docto-ini
          and   item-docto-import.cod-docto      <= tt-param.c-cod-docto-fim)
          break by item-docto-import.cod-docto
                by item-docto-import.it-codigo
                by item-docto-import.cod-pais
                by item-docto-import.cod-emitente:
         
            if first-of(item-docto-import.cod-docto) then do:
                FIND docto-import WHERE 
                     docto-import.cod-docto = item-docto-import.cod-docto NO-LOCK NO-ERROR.
                disp item-docto-import.cod-docto
                     docto-import.des-docto WHEN AVAIL docto-import
                     with frame f-tit1.
                     DOWN WITH FRAME f-tit1.
            END. /*if first-of*/
         
           find FIRST ITEM where
                item.it-codigo = item-docto-import.it-codigo no-lock no-error.
           
           IF item-docto-import.cod-emitente = ? THEN 
               ASSIGN c-nome-emit = ?.
           ELSE DO:
               find FIRST emitente 
                    where emitente.cod-emitente = item-docto-import.cod-emitente no-lock no-error.
                ASSIGN c-nome-emit = emitente.nome-emit.
           END.
               
           IF item-docto-import.cod-pais = ? THEN 
               ASSIGN c-nome-pais = ?.
           ELSE DO:
               find pais NO-LOCK WHERE 
                   pais.cod-pais = item-docto-import.cod-pais no-error.
                ASSIGN c-nome-pais = pais.nome-pais.
           END.

           disp item-docto-import.it-codigo
                ITEM.desc-item     WHEN AVAIL ITEM
                c-nome-pais 
                c-nome-emit
                with frame f-docto.
                down with frame f-docto.   
         
    END.
END.
ELSE IF tt-param.classifica = 2 THEN DO: 
    for each item-docto-import 
        where item-docto-import.it-codigo     >= tt-param.c-it-codigo-ini
          and item-docto-import.it-codigo     <= tt-param.c-it-codigo-fim
          and (item-docto-import.cod-pais     >= tt-param.i-cod-pais-ini   
          and item-docto-import.cod-pais      <= tt-param.i-cod-pais-fim 
          or (item-docto-import.cod-pais = ?
              AND tt-param.i-cod-pais-ini = 0)) 
          and (item-docto-import.cod-emitente >= tt-param.i-cod-emitente-ini
          and item-docto-import.cod-emitente  <= tt-param.i-cod-emitente-fim
           or (item-docto-import.cod-emitente  = ?  
               AND tt-param.i-cod-emitente-ini = 0))
          and item-docto-import.cod-docto     >= tt-param.c-cod-docto-ini
          and item-docto-import.cod-docto     <= tt-param.c-cod-docto-fim 
               NO-LOCK
          break by item-docto-import.it-codigo
                by item-docto-import.cod-docto
                by item-docto-import.cod-pais
                by item-docto-import.cod-emitente:
            
            if first-of(item-docto-import.it-codigo) then do:
                FIND ITEM WHERE 
                     item.it-codigo = item-docto-import.it-codigo NO-LOCK NO-ERROR.
                disp item-docto-import.it-codigo
                     item.desc-item WHEN AVAIL ITEM
                     with frame f-tit2.
                     DOWN WITH FRAME f-tit2.
            END. /*if first-of*/

           find FIRST docto-import where
                docto-import.cod-docto  = item-docto-import.cod-docto no-lock no-error.
           
           IF item-docto-import.cod-emitente = ? THEN 
               ASSIGN c-nome-emit = ?.
           ELSE DO:
               find FIRST emitente where
                    emitente.cod-emitente = item-docto-import.cod-emitente no-lock no-error.
               ASSIGN c-nome-emit = emitente.nome-emit.
           END.

           IF item-docto-import.cod-pais = ? THEN 
               ASSIGN c-nome-pais = ?.
           ELSE DO:
               find pais NO-LOCK WHERE 
                   pais.cod-pais = item-docto-import.cod-pais no-error.
                ASSIGN c-nome-pais = pais.nome-pais.
           END.

           DISP item-docto-import.cod-docto  
                docto-import.des-docto WHEN AVAIL docto-import      
                c-nome-pais                
                c-nome-emit       
                WITH FRAME f-item.
                DOWN WITH FRAME f-item.
    END.        
END.            
                
PAGE.

/*P gina de Parƒmetros*/
{utp/ut-liter.i On-line}
put unformatted
    c-lb-sel                skip(1)
    c-lb-item   at 5  " : "
    tt-param.c-it-codigo-ini    AT 22 "|<  >| " at 45 tt-param.c-it-codigo-fim
    c-lb-pais   at 5  " : "
    tt-param.i-cod-pais-ini     at 22 "|<  >| " at 45 tt-param.i-cod-pais-fim
    c-lb-fornec at 5  " : "
    tt-param.i-cod-emitente-ini at 22 "|<  >| " at 45 tt-param.i-cod-emitente-fim
    c-lb-docto  at 5  " : "
    tt-param.c-cod-docto-ini    at 22 "|<  >| " at 45 tt-param.c-cod-docto-fim
    skip(1)
    c-lb-cla                 skip(1)
    tt-param.desc-classifica at 5  skip(1)
    c-lb-imp                 skip(1)
    c-lb-destino             at 5 " : "  tt-param.c-destino " - " tt-param.arquivo
    c-lb-execucao            AT 5 " : " if i-num-ped-exec-rpw = 0 then RETURN-VALUE else "Batch"
    c-lb-usuario             at 5 " : "  tt-param.usuario.


{include/i-rpclo.i}

return "OK":U.
    




  
