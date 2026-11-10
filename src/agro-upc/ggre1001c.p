/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GGRE1001C 2.00.00.007 } /*** 010007 ***/




/**************************************************************************
**    Programa.:  GGRE1001c
**    Objetivo.:  UPC na inclusÆo da duplicata modificar o tipo de despesa
**                conforme o cadastrado no contrato (gg-contrato)
**    Data.....:  Agosto/2003
***************************************************************************/

/*********************** Defini‡Æo de Parƒmetros *************************/
define input parameter p-ind-event               as character      no-undo.
define input parameter p-ind-object              as character      no-undo.
define input parameter p-wgh-object              as handle         no-undo.
define input parameter p-wgh-frame               as widget-handle  no-undo.
define input parameter p-cod-table               as character      no-undo.
define input parameter p-row-table               as rowid          no-undo.

/******************** Defini‡Æo de Vari veis Locais **********************/
Define var  c-char                                     as char           no-undo.
Define Var  wh-objeto                                  as widget-handle  no-undo.

DEF NEW GLOBAL SHARED VAR wgh-frame               AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wgh-child               AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-dt-venc-desc-re1001c AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-vl-desconto-re1001c  AS WIDGET-HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VAR gs-val-diferenca  AS DECIMAL FORMAT "->>,>>>,>>9.99" NO-UNDO.
/******************** Vari veis para aumentar a window *******************/
{utp/ut-glob.i}
/************************** In¡cio do Programa ***************************/
assign c-char = entry(num-entries(p-wgh-object:file-name,"~/":U), p-wgh-object:file-name,"~/":U) NO-ERROR.

/***
MESSAGE "Evento ...:"   p-ind-event   SKIP
        "Objeto ...:"   p-ind-object  SKIP
        "HObjeto...:"   p-wgh-object  SKIP
        "hFrame ...:"   p-wgh-frame   SKIP
        "Tabela ...:"   p-cod-table   SKIP
        "Rowid  ...:"   string(p-row-table)   SKIP
        "NomeObjeto:"   c-char        VIEW-AS ALERT-BOX.
        ***/
     
IF  p-ind-event  = "After-Display" THEN  DO:
    ASSIGN wgh-frame = p-wgh-frame:FIRST-CHILD
           wgh-frame = wgh-frame:FIRST-CHILD.

    DO  WHILE VALID-HANDLE(wgh-frame):
        IF  wgh-frame:NAME = "fPage1"  THEN DO:
            ASSIGN wgh-child  = wgh-frame:FIRST-CHILD
                   wgh-child  = wgh-child:FIRST-CHILD.
            DO WHILE VALID-HANDLE(wgh-child):
                CASE wgh-child:NAME:
                    WHEN "vl-desconto" THEN
                        ASSIGN wh-vl-desconto-re1001c = wgh-child.
                    WHEN "dt-venc-desc" THEN
                        ASSIGN wh-dt-venc-desc-re1001c = wgh-child.
                END CASE.
                ASSIGN wgh-child = wgh-child:NEXT-SIBLING.
            END.
        END.
        ASSIGN wgh-frame = wgh-frame:NEXT-SIBLING.
    END.
    ASSIGN wh-vl-desconto-re1001c:SCREEN-VALUE = string(gs-val-diferenca)
           wh-dt-venc-desc-re1001c:SCREEN-VALUE = "31/12/9999".
END.

if p-ind-event  = "after-assign" then do:
   FIND FIRST dupli-apagar EXCLUSIVE-LOCK 
           WHERE rowid(dupli-apagar) = p-row-table NO-ERROR.
   IF AVAIL dupli-apagar THEN DO:
      FIND FIRST gg-ext-docum-est NO-LOCK
           WHERE gg-ext-docum-est.serie-docto  = dupli-apagar.serie-docto 
            AND  gg-ext-docum-est.nro-docto    = dupli-apagar.nro-docto   
            AND  gg-ext-docum-est.cod-emitente = dupli-apagar.cod-emitente
            AND  gg-ext-docum-est.nat-operacao = dupli-apagar.nat-operacao 
            AND  gg-ext-docum-est.cod-estabel  = dupli-apagar.cod-estabel NO-ERROR.
      IF AVAIL   gg-ext-docum-est THEN DO:
         FIND FIRST gg-contrato no-lock
              WHERE gg-contrato.ep-codigo  = i-ep-codigo-usuario 
              AND gg-contrato.cod-contrato = gg-ext-docum-est.cod-contrato NO-ERROR.
         IF AVAIL gg-contrato AND gg-ext-docum-est.cod-contrato <> "":U THEN
            ASSIGN dupli-apagar.tp-despesa = gg-contrato.tp-despesa
                   dupli-apagar.cod-esp    = gg-contrato.cod-esp.
      END.
   END.
   FIND CURRENT dupli-apagar NO-LOCK NO-ERROR.
END.
    
