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
{include/i-prgvrs.i V05IN128 2.00.00.001}  /*** 010101 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v02in128 MUT}
&ENDIF

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
 
/* global variable definitions */
def new global shared var v-row-parent as rowid no-undo.
 
def new global shared var gr-movto-estoq as rowid no-undo.
 
/* Parameters Definitions ---                                           */
 
/* Local Variable Definitions ---                                       */
 
def var c-conta   like movto-estoq.conta-contabil NO-UNDO.
DEF VAR i-empresa LIKE param-global.empresa-prin  NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES movto-estoq
&Scoped-define FIRST-EXTERNAL-TABLE movto-estoq


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR movto-estoq.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS movto-estoq.nr-ord-produ 
&Scoped-define ENABLED-TABLES movto-estoq
&Scoped-define FIRST-ENABLED-TABLE movto-estoq
&Scoped-Define ENABLED-OBJECTS rt-mold 
&Scoped-Define DISPLAYED-FIELDS movto-estoq.nr-ord-produ 
&Scoped-define DISPLAYED-TABLES movto-estoq
&Scoped-define FIRST-DISPLAYED-TABLE movto-estoq
&Scoped-Define DISPLAYED-OBJECTS cEstado fi-des-man-corr fi-conta-ordem ~
cDescCtOrdem fi-conta-despesa cDescCtDespesa 

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
     SIZE 40.86 BY .88 NO-UNDO.

DEFINE VARIABLE cDescCtOrdem AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 40.86 BY .88 NO-UNDO.

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

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 84 BY 12.33.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     movto-estoq.nr-ord-produ AT ROW 1.25 COL 18.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13.72 BY .88
     cEstado AT ROW 1.25 COL 69.29 COLON-ALIGNED
     fi-des-man-corr AT ROW 2.25 COL 18.43 COLON-ALIGNED
     fi-conta-ordem AT ROW 3.25 COL 18.29 COLON-ALIGNED
     cDescCtOrdem AT ROW 3.25 COL 33.57 COLON-ALIGNED NO-LABEL
     fi-conta-despesa AT ROW 4.25 COL 18.29 COLON-ALIGNED
     cDescCtDespesa AT ROW 4.25 COL 33.57 COLON-ALIGNED NO-LABEL
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.movto-estoq
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
         HEIGHT             = 12.5
         WIDTH              = 84.57.
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
       FRAME f-main:HEIGHT           = 12.5
       FRAME f-main:WIDTH            = 84.57.

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


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
 
  /************************ INTERNAL PROCEDURES ********************/
 
{utp/ut-field.i mgmnt ord-manut estado 1}
ASSIGN cEstado:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

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
  {src/adm/template/row-list.i "movto-estoq"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "movto-estoq"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
 
  /* Code placed here will execute PRIOR to standard behavior. */
  {include/i-valid.i}
  /* Ponha na pi-validate todas as valida‡äes */
  /* NÆo gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
  /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
  /* Code placed here will execute AFTER standard behavior.    */
 
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
RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
 
/* Code placed here will execute AFTER standard behavior.    */
    
/* Carrega e Mostra informa‡äes da Ordem de Manuten‡Æo */
RUN piOrdemManut IN THIS-PROCEDURE.

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
  run get-attribute ('adm-new-record').
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

{utp/ut-field.i mgmnt ord-manut estado 1}
ASSIGN cEstado:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).
    
find first param-global no-lock no-error.
if  avail param-global then do with frame {&frame-name}:
    assign i-empresa = param-global.empresa-prin.
end.
 
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
  if avail movto-estoq then
      assign gr-movto-estoq = rowid(movto-estoq).
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: NÆo fazer assign aqui. Nesta procedure
  devem ser colocadas apenas valida‡äes, pois neste ponto do programa o registro 
  ainda nÆo foi criado.       
------------------------------------------------------------------------------*/
  {include/i-vldfrm.i} /* Valida‡Æo de dicion rio */
 
   /*Segue um exemplo de valida‡Æo de programa 
 *    find tabela where tabela.campo1 = c-variavel and
 *                      tabela.campo2 > i-variavel no-lock no-error.
 *    {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
 *    run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *    return 'ADM-ERROR':U.*/
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piOrdemManut V-table-Win 
PROCEDURE piOrdemManut :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FIND FIRST ord-manut
         WHERE ord-manut.nr-ord-produ = INPUT FRAME {&FRAME-NAME} movto-estoq.nr-ord-produ NO-LOCK NO-ERROR.
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
       ASSIGN fi-des-man-corr   = ord-manut.des-man-corr
              fi-conta-ordem    = ord-manut.conta-ordem
              fi-conta-despesa  = ord-manut.conta-despesa.
    END.
    ELSE DO:
        ASSIGN cEstado           = ""
               fi-des-man-corr   = ""
               fi-conta-ordem    = ""
               fi-conta-despesa  = "".
    END. 
    DISP cEstado
         fi-des-man-corr
         fi-conta-ordem
         fi-conta-despesa WITH FRAME {&FRAME-NAME}.
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
  {src/adm/template/snd-list.i "movto-estoq"}

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

