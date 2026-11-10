&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          movind           PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i V07IN385 2.00.00.002} /*** "010002" 09/01/2026 14:41:40  ***/
 
/*------------------------------------------------------------------------
 
  File:
 
  Description: from VIEWER.W - Template for SmartViewer Objects
 
  Input Parameters:
      <none>
 
  Output Parameters:
      <none>
 
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/
 
/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */
 
CREATE WIDGET-POOL.
 
/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w
 
/* Parameters Definitions ---                                           */
 
/* Local Variable Definitions ---                                       */
 
{include/i-vrtab.i item}
{include/i-vrtab.i emitente}
{include/i-vrtab.i tab-unidade}
{include/i-vrtab.i estabelec}
{include/i-vrtab.i conta-contab}
{include/i-vrtab.i deposito}
{include/i-vrtab.i localizacao}
{include/i-vrtab.i lote}

{cdp/cdcfgdis.i}

def var i-empresa like param-global.empresa-prin no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES it-requisicao
&Scoped-define FIRST-EXTERNAL-TABLE it-requisicao


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR it-requisicao.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-mold RECT-3 fiText-2 
&Scoped-Define DISPLAYED-OBJECTS fi-nr-ord-produ cEstado fi-des-man-corr ~
fiCdEqpto fiDescEqpto fi-num-tarefa fiDescTarefa fi-conta-ordem ~
cDescCtOrdem fi-conta-despesa cDescCtDespesa rsTpReq fiText-2 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "",
     Keys-Supplied = ""':U).
/**************************
</EXECUTING-CODE> */   
 
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE cDescCtDespesa AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 51.14 BY .88 NO-UNDO.

DEFINE VARIABLE cDescCtOrdem AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 51.14 BY .88 NO-UNDO.

DEFINE VARIABLE cEstado AS CHARACTER FORMAT "X(15)":U 
     LABEL "Estado" 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-conta-despesa AS CHARACTER FORMAT "x(17)" 
     LABEL "Conta Despesa":R16 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE fi-conta-ordem AS CHARACTER FORMAT "x(17)" 
     LABEL "Conta Ordem":R14 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE fi-des-man-corr AS CHARACTER FORMAT "x(50)" 
     LABEL "Descri‡Æo":R11 
     VIEW-AS FILL-IN 
     SIZE 63.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nr-ord-produ AS INTEGER FORMAT ">>>,>>>,>>9" INITIAL 0 
     LABEL "Nr Ordem":R10 
     VIEW-AS FILL-IN 
     SIZE 13.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-num-tarefa AS INTEGER FORMAT ">>>>>" INITIAL 0 
     LABEL "Tarefa OM":R11 
     VIEW-AS FILL-IN 
     SIZE 6.86 BY .88 NO-UNDO.

DEFINE VARIABLE fiCdEqpto AS CHARACTER FORMAT "X(16)":U 
     LABEL "Equipamento" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescEqpto AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescTarefa AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 59.14 BY .88 NO-UNDO.

DEFINE VARIABLE fiText-2 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 12.43 BY .63 NO-UNDO.

DEFINE VARIABLE rsTpReq AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Requisi‡Æo Estoque", 1,
"Solicita‡Æo Compras", 2
     SIZE 23 BY 2 NO-UNDO.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 30 BY 2.46.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 84.86 BY 9.33.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     fi-nr-ord-produ AT ROW 1.25 COL 16.57 COLON-ALIGNED HELP
          "N£mero da ordem"
     cEstado AT ROW 1.25 COL 70 COLON-ALIGNED
     fi-des-man-corr AT ROW 2.25 COL 16.57 COLON-ALIGNED
     fiCdEqpto AT ROW 3.25 COL 16.57 COLON-ALIGNED
     fiDescEqpto AT ROW 3.25 COL 33 COLON-ALIGNED NO-LABEL
     fi-num-tarefa AT ROW 4.25 COL 16.57 COLON-ALIGNED HELP
          "N£mero da tarefa da ordem"
     fiDescTarefa AT ROW 4.25 COL 23.86 COLON-ALIGNED NO-LABEL
     fi-conta-ordem AT ROW 5.25 COL 16.57 COLON-ALIGNED
     cDescCtOrdem AT ROW 5.25 COL 31.86 COLON-ALIGNED NO-LABEL
     fi-conta-despesa AT ROW 6.25 COL 16.57 COLON-ALIGNED
     cDescCtDespesa AT ROW 6.25 COL 31.86 COLON-ALIGNED NO-LABEL
     rsTpReq AT ROW 7.79 COL 58.57 NO-LABEL
     it-requisicao.it-codigo AT ROW 9.25 COL 9 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     fiText-2 AT ROW 7.29 COL 54 COLON-ALIGNED NO-LABEL
     rt-mold AT ROW 1 COL 1
     RECT-3 AT ROW 7.54 COL 55
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.it-requisicao
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 9.33
         WIDTH              = 85.43.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */
 
{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME f-main:HIDDEN           = TRUE
       FRAME f-main:HEIGHT           = 9.33
       FRAME f-main:WIDTH            = 85.43.

/* SETTINGS FOR FILL-IN cDescCtDespesa IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cDescCtOrdem IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cEstado IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       cEstado:READ-ONLY IN FRAME f-main        = TRUE.

/* SETTINGS FOR FILL-IN fi-conta-despesa IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       fi-conta-despesa:READ-ONLY IN FRAME f-main        = TRUE.

/* SETTINGS FOR FILL-IN fi-conta-ordem IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       fi-conta-ordem:READ-ONLY IN FRAME f-main        = TRUE.

/* SETTINGS FOR FILL-IN fi-des-man-corr IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       fi-des-man-corr:READ-ONLY IN FRAME f-main        = TRUE.

/* SETTINGS FOR FILL-IN fi-nr-ord-produ IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       fi-nr-ord-produ:READ-ONLY IN FRAME f-main        = TRUE.

/* SETTINGS FOR FILL-IN fi-num-tarefa IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       fi-num-tarefa:READ-ONLY IN FRAME f-main        = TRUE.

/* SETTINGS FOR FILL-IN fiCdEqpto IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       fiCdEqpto:READ-ONLY IN FRAME f-main        = TRUE.

/* SETTINGS FOR FILL-IN fiDescEqpto IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       fiDescEqpto:READ-ONLY IN FRAME f-main        = TRUE.

/* SETTINGS FOR FILL-IN fiDescTarefa IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       fiDescTarefa:READ-ONLY IN FRAME f-main        = TRUE.

/* SETTINGS FOR FILL-IN it-requisicao.it-codigo IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       it-requisicao.it-codigo:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR RADIO-SET rsTpReq IN FRAME f-main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-main
/* Query rebuild information for FRAME f-main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME f-main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME fi-conta-despesa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-conta-despesa V-table-Win
ON LEAVE OF fi-conta-despesa IN FRAME f-main /* Conta Despesa */
DO:
    FIND FIRST conta-contab
         WHERE conta-contab.conta-contabil = INPUT FRAME {&FRAME-NAME} fi-conta-despesa
           AND conta-contab.ep-codigo      = i-empresa NO-LOCK NO-ERROR.
    IF  AVAIL conta-contab THEN
        ASSIGN cDescCtDespesa:SCREEN-VALUE IN FRAME {&FRAME-NAME} = conta-contab.titulo.
    ELSE
        ASSIGN cDescCtDespesa:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-conta-ordem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-conta-ordem V-table-Win
ON LEAVE OF fi-conta-ordem IN FRAME f-main /* Conta Ordem */
DO:
    FIND FIRST conta-contab
         WHERE conta-contab.conta-contabil = INPUT FRAME {&FRAME-NAME} fi-conta-ordem
           AND conta-contab.ep-codigo      = i-empresa NO-LOCK NO-ERROR.
    IF  AVAIL conta-contab THEN
        ASSIGN cDescCtOrdem:SCREEN-VALUE IN FRAME {&FRAME-NAME} = conta-contab.titulo.
    ELSE
        ASSIGN cDescCtOrdem:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-num-tarefa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-num-tarefa V-table-Win
ON LEAVE OF fi-num-tarefa IN FRAME f-main /* Tarefa OM */
DO:
    FIND FIRST ord-taref
         WHERE ord-taref.nr-ord-produ = INPUT FRAME {&FRAME-NAME} fi-nr-ord-produ
           AND ord-taref.cd-tarefa    = INPUT FRAME {&FRAME-NAME} fi-num-tarefa NO-LOCK NO-ERROR.
    IF  AVAIL ord-taref THEN
        ASSIGN fiDescTarefa:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ord-taref.descricao.
    ELSE
        ASSIGN fiDescTarefa:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiCdEqpto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiCdEqpto V-table-Win
ON LEAVE OF fiCdEqpto IN FRAME f-main /* Equipamento */
DO:
    FIND FIRST equipto
         WHERE equipto.cd-equipto = INPUT FRAME {&FRAME-NAME} fiCdEqpto NO-LOCK NO-ERROR.
    IF  AVAIL equipto THEN
        ASSIGN fiDescEqpto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = equipto.descricao.
    ELSE
        ASSIGN fiDescEqpto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
  {utp/ut-liter.i "Tipo_Requisi‡Æo"}
  assign fiText-2 = return-value.
 
  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
 
  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win  _ADM-ROW-AVAILABLE
PROCEDURE adm-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Dispatched to this procedure when the Record-
               Source has a new row available.  This procedure
               tries to get the new row (or foriegn keys) from
               the Record-Source and process it.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/row-head.i}

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "it-requisicao"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "it-requisicao"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME f-main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields V-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
 
  /* Code placed here will execute PRIOR to standard behavior. */
 
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .
 
  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
 
  /* Code placed here will execute PRIOR to standard behavior. */
 
  /* Dispatch standard ADM method.                             */
 

  if available it-requisicao then do:
     assign i-empresa = param-global.empresa-prin.
  end.

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
  /* Code placed here will execute AFTER standard behavior.    */

  RUN pi-ordem-manut IN THIS-PROCEDURE.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
 
  /* Code placed here will execute PRIOR to standard behavior. */
 
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .
 
  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

    find first param-global no-lock no-error.  

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
 
  /* Code placed here will execute AFTER standard behavior.    */
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-row-available V-table-Win 
PROCEDURE local-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
 
  /* Code placed here will execute PRIOR to standard behavior. */
 
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'row-available':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record V-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
 
  /* Code placed here will execute PRIOR to standard behavior. */
  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.
 
  /* Ponha aqui a valida‡Æo de chave duplicada */
 
  /* Ponha aqui as demais valida‡äes */
 
  /* Obs.: CASO A VALIDA€ÇO FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */
 
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
 
  /* Code placed here will execute AFTER standard behavior.    */
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-ordem-manut V-table-Win 
PROCEDURE pi-ordem-manut :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN fi-nr-ord-produ   = 0
           cEstado           = ""
           fi-des-man-corr   = ""
           fiCdEqpto         = ""
           fiDescEqpto       = ""
           fi-num-tarefa     = 0
           fiDescTarefa      = ""
           fi-conta-ordem    = ""
           cDescCtOrdem      = ""
           fi-conta-despesa  = ""
           cDescCtDespesa    = "".
    IF  AVAIL it-requisicao THEN DO:
        FIND FIRST req-ord-produc
             WHERE req-ord-produc.nr-requisicao = it-requisicao.nr-requisicao
               AND req-ord-produc.sequencia     = it-requisicao.sequencia NO-LOCK NO-ERROR.
        IF  AVAIL req-ord-produc THEN DO:
            /*FOR FIRST requisicao
                WHERE requisicao.nr-requisicao = it-requisicao.nr-requisicao NO-LOCK.
            END.
            */
            FIND FIRST ord-manut
                 WHERE ord-manut.nr-ord-produ = req-ord-produc.nr-ord-produ NO-LOCK NO-ERROR.
            IF  AVAIL ord-manut THEN DO:
               /* Carrega Informa‡äes da Ordem de Manuten‡Æo */
               &if  "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                   DO:
                      RUN utp/ut-liter.p (TRIM({ininc/i01in271.i 4 ord-manut.estado}), "*", "").
                      ASSIGN cEstado = RETURN-VALUE.
                   END.
               &else
                   ASSIGN cEstado = {ininc/i01in271.i 4 ord-manut.estado}.
               &endif
               ASSIGN fi-nr-ord-produ   = ord-manut.nr-ord-produ
                      fi-des-man-corr   = ord-manut.des-man-corr
                      fiCdEqpto         = ord-manut.cd-equipto
                      fi-num-tarefa     = req-ord-produc.num-tarefa
                      fi-conta-ordem    = ord-manut.conta-ordem
                      fi-conta-despesa  = ord-manut.conta-despesa
                      rsTpReq           = req-ord-produc.tp-requis.
            END.
        END.
    END.

    DISP fi-nr-ord-produ
         cEstado
         fi-des-man-corr
         fiCdEqpto
         fi-num-tarefa
         fi-conta-ordem
         fi-conta-despesa
         rsTpReq WITH FRAME {&FRAME-NAME}.
    APPLY "LEAVE":U TO fiCdEqpto.
    APPLY "LEAVE":U TO fi-num-tarefa.
    APPLY "LEAVE":U TO fi-conta-ordem.
    APPLY "LEAVE":U TO fi-conta-despesa.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "it-requisicao"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed V-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.
 
  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/vstates.i}
  END CASE.
  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

