&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
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
{include/i-prgvrs.i V02IN295 2.00.00.016}  /*** 010016 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V02IN295 MUT}
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

{include/i-vrtab.i cond-pagto}
{include/i-vrtab.i mensagem}

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var i-numero-ped as int no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES pedido-compr
&Scoped-define FIRST-EXTERNAL-TABLE pedido-compr


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR pedido-compr.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS pedido-compr.end-entrega ~
pedido-compr.end-cobranca pedido-compr.data-pedido ~
pedido-compr.cod-cond-pag pedido-compr.cod-mensagem ~
pedido-compr.emergencial pedido-compr.dt-prev-pgto
&Scoped-define ENABLED-TABLES pedido-compr
&Scoped-define FIRST-ENABLED-TABLE pedido-compr
&Scoped-Define ENABLED-OBJECTS RECT-1 
&Scoped-Define DISPLAYED-FIELDS pedido-compr.end-entrega ~
pedido-compr.end-cobranca pedido-compr.data-pedido ~
pedido-compr.cod-cond-pag pedido-compr.cod-mensagem ~
pedido-compr.emergencial pedido-compr.dt-prev-pgto 
&Scoped-define DISPLAYED-TABLES pedido-compr
&Scoped-define FIRST-DISPLAYED-TABLE pedido-compr
&Scoped-Define DISPLAYED-OBJECTS c-natureza c-nome-abrev c-frete ~
cb-local-entrega c-situacao 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS cb-local-entrega 
&Scoped-define ADM-ASSIGN-FIELDS cb-local-entrega 
&Scoped-define ADM-MODIFY-FIELDS cb-local-entrega 

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
DEFINE BUTTON bt-detalhar 
     LABEL "Detalhar" 
     SIZE 10.43 BY 1.

DEFINE VARIABLE cb-local-entrega AS CHARACTER FORMAT "X(256)":U 
     LABEL "Local Entrega" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 21.86 BY 1 NO-UNDO.

DEFINE VARIABLE c-frete AS CHARACTER FORMAT "X(6)":U 
     LABEL "Frete" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-natureza AS CHARACTER FORMAT "X(256)":U 
     LABEL "Natureza" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-abrev AS CHARACTER FORMAT "X(14)" 
     LABEL "Nome Abreviado":R17 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-situacao AS CHARACTER FORMAT "X(15)" INITIAL "1" 
     LABEL "Situa‡Æo":R10 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.72 BY 6.29.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     c-natureza AT ROW 1.21 COL 18.14 COLON-ALIGNED
     pedido-compr.end-entrega AT ROW 1.21 COL 57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     c-nome-abrev AT ROW 2.21 COL 18.14 COLON-ALIGNED HELP
          "Nome abreviado do cliente/fornecedor"
     pedido-compr.end-cobranca AT ROW 2.21 COL 57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     bt-detalhar AT ROW 3.13 COL 65.14
     pedido-compr.data-pedido AT ROW 3.21 COL 18.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     pedido-compr.cod-cond-pag AT ROW 3.21 COL 57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     c-frete AT ROW 4.21 COL 18.14 COLON-ALIGNED
     pedido-compr.cod-mensagem AT ROW 4.21 COL 57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     pedido-compr.emergencial AT ROW 4.21 COL 64.72
          VIEW-AS TOGGLE-BOX
          SIZE 21.57 BY .83
    pedido-compr.dt-prev-pgto AT ROW 6.21 COL 18.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88

     cb-local-entrega AT ROW 5.17 COL 57 COLON-ALIGNED
     c-situacao AT ROW 5.21 COL 18.14 COLON-ALIGNED HELP
          "Informe a Situa‡Æo do Pedido de Compra"
     RECT-1 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.pedido-compr
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
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
         HEIGHT             = 5.42
         WIDTH              = 86.29.
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
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON bt-detalhar IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-frete IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-natureza IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nome-abrev IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-situacao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-local-entrega IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
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

&Scoped-define SELF-NAME bt-detalhar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-detalhar V-table-Win
ON CHOOSE OF bt-detalhar IN FRAME f-main /* Detalhar */
DO:
    assign i-numero-ped = pedido-compr.num-pedido.
    run ccp/cc0509f.w (input i-numero-ped).
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
  
  {utp/ut-field.i mgind pedido-compr natureza 1}
  assign c-natureza:label in frame {&FRAME-NAME} = trim(return-value).
  
  {utp/ut-field.i mgadm emitente nome-abrev 1}
  assign c-nome-abrev:label in frame {&FRAME-NAME} = trim(return-value).
  
  {utp/ut-field.i mgind pedido-compr frete 1}
  assign c-frete:label in frame {&FRAME-NAME} = trim(return-value).
  
  {utp/ut-field.i mgind pedido-compr situacao 1}
  assign c-situacao:label in frame {&FRAME-NAME} = trim(return-value).
  
  assign cb-local-entrega:list-items in frame {&frame-name} = {ininc/i08in295.i 03}.

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
  {src/adm/template/row-list.i "pedido-compr"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "pedido-compr"}

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
  
  find emitente where emitente.cod-emitente = pedido-compr.cod-emitente no-lock no-error.
  if avail emitente then do:
      assign c-nome-abrev = emitente.nome-abrev.
  end. 

  IF  avail pedido-compr and
           pedido-compr.cod-cond-pag = 0 THEN
      enable bt-detalhar with frame {&frame-name}.
  ELSE
      disable bt-detalhar with frame {&frame-name}.

   FOR FIRST param-compra NO-LOCK:
       IF param-compra.consid-dt-prev-pagto THEN
           ASSIGN pedido-compr.dt-prev-pgto:HIDDEN = NO.
       ELSE 
           ASSIGN pedido-compr.dt-prev-pgto:HIDDEN = YES.
   END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  if avail pedido-compr then do with frame {&frame-name}:

      RUN utp/ut-liter.p (INPUT {ininc/i03in295.i 04 pedido-compr.frete},
                          INPUT "",
                          INPUT "").

      assign c-frete:SCREEN-VALUE = RETURN-VALUE.

      RUN utp/ut-liter.p (INPUT {ininc/i01in295.i 04 pedido-compr.natureza},
                          INPUT "",
                          INPUT "").

      ASSIGN c-natureza:screen-value = RETURN-VALUE.

      RUN utp/ut-liter.p (INPUT {ininc/i02in295.i 04 pedido-compr.situacao},
                          INPUT "",
                          INPUT "").

      ASSIGN c-situacao:screen-value = RETURN-VALUE. 

      assign cb-local-entrega:screen-value = {ininc/i08in295.i 04 pedido-compr.local-entrega}
             no-error.
  end.
  else do:

      RUN utp/ut-liter.p (INPUT {ininc/i03in295.i 04 1},
                          INPUT "",
                          INPUT "").

      assign c-frete:SCREEN-VALUE = RETURN-VALUE.

      RUN utp/ut-liter.p (INPUT {ininc/i01in295.i 04 1},
                          INPUT "",
                          INPUT "").

      ASSIGN c-natureza:screen-value = RETURN-VALUE.

      RUN utp/ut-liter.p (INPUT {ininc/i02in295.i 04 1},
                          INPUT "",
                          INPUT "").

      ASSIGN c-situacao:screen-value = RETURN-VALUE. 

      assign cb-local-entrega:screen-value = {ininc/i08in295.i 04 1}.
  end.    
  
            

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
  
  find cond-pagto where 
       pedido-compr.cod-cond-pag = cond-pagto.cod-cond-pag no-lock no-error.
  if avail cond-pagto then
     assign gr-cond-pagto = rowid(cond-pagto).
     
  find mensagem where
       pedido-compr.cod-mensagem = mensagem.cod-mensagem no-lock no-error.
  if avail mensagem then
     assign gr-mensagem = rowid(mensagem).             

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
  {src/adm/template/snd-list.i "pedido-compr"}

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

