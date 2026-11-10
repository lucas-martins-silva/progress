/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GGZ01AD098 2.00.00.003 } /*** 010003 ***/



/*************************************************************************
**    Programa.:  AGAP0804F
**    Objetivo.:  UPC para visualiza‡Æo de informa‡äes adicionais do 
**                tit-ap - AP0804F
**    Data.....:  Agosto de 2003
*************************************************************************/
{btb/btb009za.i} /* Define tt_erro */

/*********************** Defini‡Æo de Parƒmetros *************************/
DEFINE INPUT PARAMETER p-ind-event               AS CHARACTER      NO-UNDO.
DEFINE INPUT PARAMETER p-ind-object              AS CHARACTER      NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-object              AS HANDLE         NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-frame               AS WIDGET-HANDLE  NO-UNDO.
DEFINE INPUT PARAMETER p-cod-table               AS CHARACTER      NO-UNDO.
DEFINE INPUT PARAMETER p-row-table               AS ROWID          NO-UNDO.

/******************** Defini‡Æo de Vari veis Globais *********************/
DEFINE NEW GLOBAL SHARED VAR  adm-broker-hdl     AS HANDLE         NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR  h-browser-ap0804   AS HANDLE         NO-UNDO.

/******************** Defini‡Æo de Vari veis Locais **********************/
Define var  c-char                               as char           no-undo.
Define Var  c-folder                             as Char           no-undo.
Define Var  c-objects                            as Char           no-undo.
Define var  h-folder                             as handle         no-undo.
Define Var  wh-objeto                            as widget-handle  no-undo.

DEFINE NEW GLOBAL SHARED VAR wh-rowid-table      AS ROWID          NO-UNDO.

def var v-log-ok as log.
/************************** In¡cio do Programa ***************************/

assign c-char = entry(num-entries(p-wgh-object:file-name,"~/"), p-wgh-object:file-name,"~/") no-error.

/*
MESSAGE "Evento ...:"   p-ind-event   SKIP
        "Objeto ...:"   p-ind-object  SKIP
        "HObjeto...:"   p-wgh-object  SKIP
        "hFrame ...:"   p-wgh-frame   SKIP
        "Tabela ...:"   p-cod-table   SKIP
        "Rowid  ...:"   string(p-row-table)   SKIP
        "NomeObjeto:"   c-char        VIEW-AS ALERT-BOX.*/

/**************** Cria‡Æo da P gina 'Contrato' ****************/

IF p-ind-event   = "INITIALIZE" AND
   p-ind-object  = "CONTAINER"  THEN DO:

    
   RUN get-link-handle IN adm-broker-hdl (INPUT p-wgh-object,
                                          INPUT "PAGE-SOURCE":U,
                                          OUTPUT c-folder).
   ASSIGN h-folder = WIDGET-HANDLE(c-folder) NO-ERROR.

   IF VALID-HANDLE(h-folder) THEN DO:
       
      /*FOLDER 9 - CONTRATO */
      RUN create-folder-page IN h-folder (INPUT 8,
                                          INPUT "Cont‚m.":U).
      RUN create-folder-label IN h-folder (INPUT 8,
                                           INPUT "Cont‚m.":U).
      
      RUN select-page IN p-wgh-object (INPUT 8).
      RUN init-object IN p-wgh-object (INPUT "agro-upc/ggap0804-b01.w", /* Nome do Objeto Viewer */ 
                                       INPUT p-wgh-frame,
                                       INPUT "Layout = ":U,
                                       OUTPUT h-browser-ap0804).
      RUN enable-folder-page IN h-folder (INPUT 8).
      
      IF VALID-HANDLE(h-browser-ap0804) THEN
         RUN set-position IN h-browser-ap0804 (3.5 , 5.00).

      /*RUN get-link-handle IN adm-broker-hdl (INPUT p-wgh-object,
                                             INPUT "CONTAINER-TARGET":U,
                                             OUTPUT c-objects).*/
      IF VALID-HANDLE(h-browser-ap0804) THEN
         RUN dispatch IN h-browser-ap0804 ("initialize":U).

      RUN add-link IN adm-broker-hdl ( h-browser-ap0804 , 'State':U , p-wgh-object ).

      RUN select-page IN p-wgh-object (INPUT 1).
   END.
END.
