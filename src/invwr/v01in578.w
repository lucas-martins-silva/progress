&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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
{include/i-prgvrs.i V01IN578 2.00.00.003}  /*** 010003 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN578 MUT}
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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES item-contrat
&Scoped-define FIRST-EXTERNAL-TABLE item-contrat


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR item-contrat.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS formula-reaj.dat-prox-reaj ~
formula-reaj.dat-preco-base 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}dat-prox-reaj ~{&FP2}dat-prox-reaj ~{&FP3}~
 ~{&FP1}dat-preco-base ~{&FP2}dat-preco-base ~{&FP3}
&Scoped-define ENABLED-TABLES formula-reaj
&Scoped-define FIRST-ENABLED-TABLE formula-reaj
&Scoped-Define ENABLED-OBJECTS RECT-11 
&Scoped-Define DISPLAYED-FIELDS formula-reaj.dat-prox-reaj ~
formula-reaj.dat-preco-base item-contrat.un formula-reaj.mo-codigo[1] ~
formula-reaj.dat-indice[1] formula-reaj.perc-reaj[1] ~
formula-reaj.mo-codigo[2] formula-reaj.dat-indice[2] ~
formula-reaj.perc-reaj[2] formula-reaj.mo-codigo[3] ~
formula-reaj.dat-indice[3] formula-reaj.perc-reaj[3] ~
formula-reaj.mo-codigo[4] formula-reaj.dat-indice[4] ~
formula-reaj.perc-reaj[4] formula-reaj.mo-codigo[5] ~
formula-reaj.dat-indice[5] formula-reaj.perc-reaj[5] 
&Scoped-Define DISPLAYED-OBJECTS fi-moeda fi-data-indice fi-perc-reaj ind-1 ~
ind-2 ind-3 ind-4 ind-5 

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
DEFINE VARIABLE fi-data-indice AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 12 BY .67 NO-UNDO.

DEFINE VARIABLE fi-moeda AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 8 BY .67 NO-UNDO.

DEFINE VARIABLE fi-perc-reaj AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE ind-1 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 10 BY .67 NO-UNDO.

DEFINE VARIABLE ind-2 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 10 BY .67 NO-UNDO.

DEFINE VARIABLE ind-3 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 10 BY .67 NO-UNDO.

DEFINE VARIABLE ind-4 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 10 BY .67 NO-UNDO.

DEFINE VARIABLE ind-5 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 10 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 80 BY 8.17.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     formula-reaj.dat-prox-reaj AT ROW 1.58 COL 48.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     formula-reaj.dat-preco-base AT ROW 1.67 COL 15.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     item-contrat.un AT ROW 2 COL 74.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 1 BY 1
     formula-reaj.mo-codigo[1] AT ROW 3.75 COL 25.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 3.43 BY .88
     formula-reaj.dat-indice[1] AT ROW 3.75 COL 32.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     formula-reaj.perc-reaj[1] AT ROW 3.75 COL 47.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     formula-reaj.mo-codigo[2] AT ROW 4.75 COL 25.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 3.43 BY .88
     formula-reaj.dat-indice[2] AT ROW 4.75 COL 32.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     formula-reaj.perc-reaj[2] AT ROW 4.75 COL 47.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     formula-reaj.mo-codigo[3] AT ROW 5.75 COL 25.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 3.43 BY .88
     formula-reaj.dat-indice[3] AT ROW 5.75 COL 32.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     formula-reaj.perc-reaj[3] AT ROW 5.75 COL 47.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     formula-reaj.mo-codigo[4] AT ROW 6.75 COL 25.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 3.43 BY .88
     formula-reaj.dat-indice[4] AT ROW 6.75 COL 32.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     formula-reaj.perc-reaj[4] AT ROW 6.75 COL 47.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     formula-reaj.mo-codigo[5] AT ROW 7.75 COL 25.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 3.43 BY .88
     formula-reaj.dat-indice[5] AT ROW 7.75 COL 32.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     formula-reaj.perc-reaj[5] AT ROW 7.75 COL 47.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     fi-moeda AT ROW 2.92 COL 23.86 COLON-ALIGNED NO-LABEL
     fi-data-indice AT ROW 2.92 COL 32.43 COLON-ALIGNED NO-LABEL
     fi-perc-reaj AT ROW 2.92 COL 47.86 COLON-ALIGNED NO-LABEL
     ind-1 AT ROW 3.83 COL 14.43 COLON-ALIGNED NO-LABEL
     ind-2 AT ROW 4.83 COL 14.43 COLON-ALIGNED NO-LABEL
     ind-3 AT ROW 5.83 COL 14.43 COLON-ALIGNED NO-LABEL
     ind-4 AT ROW 6.83 COL 14.43 COLON-ALIGNED NO-LABEL
     ind-5 AT ROW 7.83 COL 14.43 COLON-ALIGNED NO-LABEL
     RECT-11 AT ROW 1.17 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.item-contrat
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 8.58
         WIDTH              = 81.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN formula-reaj.dat-indice[1] IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN formula-reaj.dat-indice[2] IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN formula-reaj.dat-indice[3] IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN formula-reaj.dat-indice[4] IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN formula-reaj.dat-indice[5] IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-data-indice IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-moeda IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-perc-reaj IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ind-1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ind-2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ind-3 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ind-4 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ind-5 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN formula-reaj.mo-codigo[1] IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN formula-reaj.mo-codigo[2] IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN formula-reaj.mo-codigo[3] IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN formula-reaj.mo-codigo[4] IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN formula-reaj.mo-codigo[5] IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN formula-reaj.perc-reaj[1] IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN formula-reaj.perc-reaj[2] IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN formula-reaj.perc-reaj[3] IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN formula-reaj.perc-reaj[4] IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN formula-reaj.perc-reaj[5] IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN item-contrat.un IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       item-contrat.un:HIDDEN IN FRAME f-main           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-main
/* Query rebuild information for FRAME f-main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME f-main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win _ADM-ROW-AVAILABLE
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
  {src/adm/template/row-list.i "item-contrat"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "item-contrat"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win _DEFAULT-DISABLE
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
 
  find formula-reaj where
       formula-reaj.nr-contrato  = item-contrat.nr-contrato and
       formula-reaj.num-seq-item = item-contrat.num-seq-item
       no-lock no-error.
  if not avail formula-reaj then
  assign formula-reaj.dat-preco-base:screen-value in frame {&frame-name} = ""
         formula-reaj.mo-codigo[1]:screen-value in frame {&frame-name} = string(0)
         formula-reaj.mo-codigo[2]:screen-value in frame {&frame-name} = string(0)
         formula-reaj.mo-codigo[3]:screen-value in frame {&frame-name} = string(0)
         formula-reaj.mo-codigo[4]:screen-value in frame {&frame-name} = string(0)
         formula-reaj.mo-codigo[5]:screen-value in frame {&frame-name} = string(0)
         formula-reaj.dat-indic[1]:screen-value in frame {&frame-name} = ""
         formula-reaj.dat-indic[2]:screen-value in frame {&frame-name} = ""
         formula-reaj.dat-indic[3]:screen-value in frame {&frame-name} = ""
         formula-reaj.dat-indic[4]:screen-value in frame {&frame-name} = ""
         formula-reaj.dat-indic[5]:screen-value in frame {&frame-name} = ""
         formula-reaj.perc-reaj[1]:screen-value in frame {&frame-name} = string(0)
         formula-reaj.perc-reaj[2]:screen-value in frame {&frame-name} = string(0)
         formula-reaj.perc-reaj[3]:screen-value in frame {&frame-name} = string(0)
         formula-reaj.perc-reaj[4]:screen-value in frame {&frame-name} = string(0)
         formula-reaj.perc-reaj[5]:screen-value in frame {&frame-name} = string(0)
         formula-reaj.dat-prox-reaj:screen-value in frame {&frame-name} = "".
  else 
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  {utp/ut-liter.i Indicador_1 * r}
  assign ind-1:screen-value in frame {&frame-name} = return-value.
  {utp/ut-liter.i Indicador_2 * r}
  assign ind-2:screen-value in frame {&frame-name} = return-value.
  {utp/ut-liter.i Indicador_3 * r}
  assign ind-3:screen-value in frame {&frame-name} = return-value.
  {utp/ut-liter.i Indicador_4 * r}
  assign ind-4:screen-value in frame {&frame-name} = return-value.
  {utp/ut-liter.i Indicador_5 * r}
  assign ind-5:screen-value in frame {&frame-name} = return-value.
  {utp/ut-liter.i Moeda * r}
  assign fi-moeda:screen-value in frame {&frame-name} = return-value.
  {utp/ut-liter.i Dat_Indice * r}
  assign fi-data-indice:screen-value in frame {&frame-name} = return-value.
  {utp/ut-liter.i Perc_Reaj * r}
  assign fi-perc-reaj:screen-value in frame {&frame-name} = trim(return-value).
      
  /* Code placed here will execute AFTER standard behavior.    */

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
  
  if adm-new-record = yes then
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
  /* Dispatch standard ADM method.                             */
 
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-parent V-table-Win 
PROCEDURE pi-atualiza-parent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
     define input parameter v-row-parent-externo as rowid no-undo.
     
     assign v-row-parent = v-row-parent-externo.
 
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "item-contrat"}

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


