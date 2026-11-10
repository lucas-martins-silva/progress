&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
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
{include/i-prgvrs.i V02IN313 2.00.00.017 } /*** 010017 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V02IN313 MUT}
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
def new global shared var gr-pl-mest   as rowid no-undo.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def buffer b-pl-mest for pl-mest.

def var c-lista-estado as char no-undo.
def var i-tipo-plano   as integer no-undo.

def var l-flag         as logical init no no-undo.

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
&Scoped-define EXTERNAL-TABLES pl-mest
&Scoped-define FIRST-EXTERNAL-TABLE pl-mest


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR pl-mest.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS pl-mest.log-2 pl-mest.calc-atp-cot ~
pl-mest.res-fabr pl-mest.saldo-fabr pl-mest.tp-seg-fabr ~
pl-mest.log-reservas-atp pl-mest.ordens-fabr pl-mest.ordens-comp ~
pl-mest.pedidos-fabr 
&Scoped-define ENABLED-TABLES pl-mest
&Scoped-define FIRST-ENABLED-TABLE pl-mest
&Scoped-Define ENABLED-OBJECTS rt-mold-2 
&Scoped-Define DISPLAYED-FIELDS pl-mest.log-2 pl-mest.calc-atp-cot ~
pl-mest.res-fabr pl-mest.saldo-fabr pl-mest.tp-seg-fabr ~
pl-mest.log-reservas-atp pl-mest.ordens-fabr pl-mest.ordens-comp ~
pl-mest.pedidos-fabr 
&Scoped-define DISPLAYED-TABLES pl-mest
&Scoped-define FIRST-DISPLAYED-TABLE pl-mest
&Scoped-Define DISPLAYED-OBJECTS cb-tipo-cl-prev 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-MODIFY-FIELDS cb-tipo-cl-prev pl-mest.res-fabr ~
pl-mest.saldo-fabr pl-mest.tp-seg-fabr pl-mest.ordens-fabr ~
pl-mest.ordens-comp pl-mest.pedidos-fabr 

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
DEFINE VARIABLE cb-tipo-cl-prev AS CHARACTER FORMAT "X(30)":U 
     LABEL "Classif Previs∆o Venda" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 27 BY 1 NO-UNDO.

DEFINE RECTANGLE rt-mold-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85.72 BY 7.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     pl-mest.log-2 AT ROW 2.5 COL 28 WIDGET-ID 2
          LABEL "N∆o Gera Previs∆o no C†lculo MPS"
          VIEW-AS TOGGLE-BOX
          SIZE 36 BY .83
     cb-tipo-cl-prev AT ROW 1.5 COL 26 COLON-ALIGNED
     pl-mest.calc-atp-cot AT ROW 6.67 COL 48
          VIEW-AS TOGGLE-BOX
          SIZE 33.57 BY .83
     pl-mest.res-fabr AT ROW 3.67 COL 10
          VIEW-AS TOGGLE-BOX
          SIZE 32.43 BY .83
     pl-mest.saldo-fabr AT ROW 4.67 COL 10
          VIEW-AS TOGGLE-BOX
          SIZE 33.14 BY .83
     pl-mest.tp-seg-fabr AT ROW 5.67 COL 10
          VIEW-AS TOGGLE-BOX
          SIZE 33.14 BY .83
     pl-mest.log-reservas-atp AT ROW 6.67 COL 10
          VIEW-AS TOGGLE-BOX
          SIZE 29.14 BY .83
     pl-mest.ordens-fabr AT ROW 3.67 COL 48
          VIEW-AS TOGGLE-BOX
          SIZE 34.72 BY .83
     pl-mest.ordens-comp AT ROW 4.67 COL 48
          VIEW-AS TOGGLE-BOX
          SIZE 35.29 BY .83
     pl-mest.pedidos-fabr AT ROW 5.67 COL 48
          VIEW-AS TOGGLE-BOX
          SIZE 35.57 BY .83
     rt-mold-2 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.pl-mest
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
         HEIGHT             = 8.29
         WIDTH              = 85.72.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR COMBO-BOX cb-tipo-cl-prev IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR TOGGLE-BOX pl-mest.log-2 IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX pl-mest.ordens-comp IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR TOGGLE-BOX pl-mest.ordens-fabr IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR TOGGLE-BOX pl-mest.pedidos-fabr IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR TOGGLE-BOX pl-mest.res-fabr IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR TOGGLE-BOX pl-mest.saldo-fabr IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR TOGGLE-BOX pl-mest.tp-seg-fabr IN FRAME f-main
   3                                                                    */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-main
/* Query rebuild information for FRAME f-main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME f-main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
{utp/ut-field.i mgind pl-mest tipo-cl-prev 1}
assign cb-tipo-cl-prev:label in frame {&frame-name} = return-value.

/*{utp/ut-field.i mgind pl-mest tp-rep-fabr 1}
assign cb-tp-rep-fabr:label in frame {&frame-name} = return-value.*/


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
  {src/adm/template/row-list.i "pl-mest"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "pl-mest"}

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
  if not frame {&frame-name}:validate() then
     return 'ADM-ERROR':U.


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  if RETURN-VALUE = 'ADM-ERROR':U then 
     return 'ADM-ERROR':U.

  /* Code placed here will execute AFTER standard behavior.    */
  do with frame {&frame-name}:
     assign pl-mest.tipo-cl-prev = {ininc/i02in313.i 06 cb-tipo-cl-prev:screen-value}
          /*pl-mest.tp-rep-fabr  = {ininc/i04in313.i 06 cb-tp-rep-fabr:screen-value}*/.
  end.

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
  disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.

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
  do with frame {&frame-name}:
     assign cb-tipo-cl-prev:screen-value = 
                 if avail pl-mest then {ininc/i02in313.i 04 pl-mest.tipo-cl-prev}
                 else {ininc/i02in313.i 04 1}
            /*cb-tp-rep-fabr:screen-value = 
                 if avail pl-mest then {ininc/i04in313.i 04 pl-mest.tp-rep-fabr}
                 else {ininc/i04in313.i 04 1}*/.
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
  run get-attribute ('adm-new-record').

  /* Dispatch standard ADM method.                             */

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  if l-flag = no then do:
     &if  defined(ADM-MODIFY-FIELDS) &then
          enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
     &endif
  end. 

  if adm-new-record = no  then do:
   if avail pl-mest then do:
        find first pr-venda 
             where pr-venda.cd-plano = pl-mest.cd-plano
             no-lock no-error.
     if avail pr-venda then 
        disable cb-tipo-cl-prev with frame {&frame-name}.
     end.
  end.

  assign pl-mest.calc-atp-cot:sensitive in frame {&frame-name} = yes.
  if avail pl-mest then do:
      if pl-mest.estado > 1 then do:
         assign pl-mest.calc-atp-cot:sensitive in frame {&frame-name} = no.
      end.   
  end.

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
  do with frame {&frame-name}:
     &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
         DEFINE VARIABLE c-lista AS CHARACTER  NO-UNDO.
         ASSIGN c-lista = {ininc/i02in313.i 03}.
         run utp/ut-lstit.p (input-output c-lista).
         assign cb-tipo-cl-prev:LIST-ITEM-PAIRS = c-lista.
     &else
         assign cb-tipo-cl-prev:list-items = {ininc/i02in313.i 03}
                /*cb-tp-rep-fabr:list-items  = {ininc/i04in313.i 03}*/ .
     &endif
  end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-pl-mest-tipo V-table-Win 
PROCEDURE pi-atualiza-pl-mest-tipo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   def var v-row-table as rowid  no-undo.

   assign v-row-parent = rowid(pl-mest).

   run cdp/cd1120a.w (input-output v-row-table, 
                      input this-procedure, 
                      "Primeiro":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recebe-valor V-table-Win 
PROCEDURE pi-recebe-valor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input parameter p-tipo-plano as integer.

assign i-tipo-plano = p-tipo-plano
       l-flag       = yes.

if  p-tipo-plano = 2 OR
    p-tipo-plano = 1 THEN
    enable cb-tipo-cl-prev 
           with frame {&frame-name}.

if  p-tipo-plano = 2 then do:
    if avail pl-mest then do:      
        disable pl-mest.log-reservas-atp
                pl-mest.ordens-comp 
                pl-mest.ordens-fabr 
                pl-mest.pedidos-fabr 
                pl-mest.res-fabr 
                pl-mest.saldo-fabr 
                pl-mest.tp-seg-fabr
                pl-mest.calc-atp-cot with frame {&frame-name}.
        assign  pl-mest.log-reservas-atp:checked in frame {&frame-name} = no
                pl-mest.ordens-comp:checked      in frame {&frame-name} = no
                pl-mest.ordens-fabr:checked      in frame {&frame-name} = no
                pl-mest.pedidos-fabr:checked     in frame {&frame-name} = no
                pl-mest.res-fabr:checked         in frame {&frame-name} = no
                pl-mest.saldo-fabr:checked       in frame {&frame-name} = no
                pl-mest.tp-seg-fabr:checked      in frame {&frame-name} = no
                pl-mest.calc-atp-cot:checked     in frame {&frame-name} = no. 
    end.     
end.
else do:
    if avail pl-mest then 
        enable pl-mest.log-reservas-atp 
               pl-mest.ordens-comp 
               pl-mest.ordens-fabr 
               pl-mest.pedidos-fabr 
               pl-mest.res-fabr 
               pl-mest.saldo-fabr 
               pl-mest.tp-seg-fabr
               pl-mest.calc-atp-cot with frame {&frame-name}.
end. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
  ainda n∆o foi criado.       
------------------------------------------------------------------------------*/
  {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */

   /*Segue um exemplo de validaá∆o de programa 
 *    find tabela where tabela.campo1 = c-variavel and
 *                      tabela.campo2 > i-variavel no-lock no-error.
 *    {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
 *    run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *    return 'ADM-ERROR':U.*/


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
  {src/adm/template/snd-list.i "pl-mest"}

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

