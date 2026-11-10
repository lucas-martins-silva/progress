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
****************************************************************************/
{include/i-prgvrs.i V41IN090 2.00.00.002 } /*** "010002" 15/06/2026 14:31:49 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V41IN090 MUT}
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
def var v-row-parent as rowid   no-undo.

{rep/re0701.i}
{cdp/cdcfgmat.i}

DEFINE TEMP-TABLE tt-ext-docum-est NO-UNDO LIKE ext-docum-est
       FIELD r-Rowid AS ROWID.

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
&Scoped-define EXTERNAL-TABLES docum-est
&Scoped-define FIRST-EXTERNAL-TABLE docum-est


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR docum-est.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-button rt-key base-ibs-uf valor-ibs-uf ~
base-ibs-mun valor-ibs-mun base-cbs fi-base-cbs-it fi-base-cbs-dif ~
valor-cbs fi-valor-cbs-it fi-valor-cbs-dif fi-valor-is fi-valor-is-it ~
fi-valor-is-dif FILL-IN-1 fi-tot-nota fi-tot-itens fi-diferenca 
&Scoped-Define DISPLAYED-OBJECTS base-ibs-uf fi-base-ibs-uf-it ~
fi-base-ibs-uf-dif fi-valor-ibs-uf-it fi-valor-ibs-uf-dif valor-ibs-uf ~
base-ibs-mun fi-base-ibs-mun-it fi-base-ibs-mun-dif valor-ibs-mun ~
fi-valor-ibs-mun-it fi-valor-ibs-mun-dif base-cbs fi-base-cbs-it ~
fi-base-cbs-dif valor-cbs fi-valor-cbs-it fi-valor-cbs-dif fi-valor-is ~
fi-valor-is-it fi-valor-is-dif FILL-IN-1 fi-tot-nota fi-tot-itens ~
fi-diferenca 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS base-ibs-uf valor-ibs-uf base-ibs-mun ~
valor-ibs-mun 

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
DEFINE VARIABLE base-cbs AS DECIMAL FORMAT ">>>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Base CBS" 
     VIEW-AS FILL-IN 
     SIZE 19.57 BY .88 NO-UNDO.

DEFINE VARIABLE base-ibs-mun AS DECIMAL FORMAT ">>>>>,>>>,>>9.99" INITIAL 0 
     LABEL "Base IBS Mun":R23 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88.

DEFINE VARIABLE base-ibs-uf AS DECIMAL FORMAT ">>>>>,>>>,>>9.99" INITIAL 0 
     LABEL "Base IBS UF" 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88.

DEFINE VARIABLE fi-base-cbs-dif AS DECIMAL FORMAT ">>>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-base-cbs-it AS DECIMAL FORMAT ">>>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-base-ibs-mun-dif AS DECIMAL FORMAT "->>>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-base-ibs-mun-it AS DECIMAL FORMAT "->>>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-base-ibs-uf-dif AS DECIMAL FORMAT "->>>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-base-ibs-uf-it AS DECIMAL FORMAT "->>>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-diferenca AS CHARACTER FORMAT "X(50)":U 
      VIEW-AS TEXT 
     SIZE 15.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-tot-itens AS CHARACTER FORMAT "X(50)":U 
      VIEW-AS TEXT 
     SIZE 23.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-tot-nota AS CHARACTER FORMAT "X(50)":U 
      VIEW-AS TEXT 
     SIZE 21.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-valor-cbs-dif AS DECIMAL FORMAT ">>>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-valor-cbs-it AS DECIMAL FORMAT ">>>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-valor-ibs-mun-dif AS DECIMAL FORMAT "->>>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-valor-ibs-mun-it AS DECIMAL FORMAT "->>>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-valor-ibs-uf-dif AS DECIMAL FORMAT "->>>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-valor-ibs-uf-it AS DECIMAL FORMAT "->>>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88 NO-UNDO.
     
DEFINE VARIABLE fi-valor-is AS DECIMAL FORMAT ">>>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Valor IS" 
     VIEW-AS FILL-IN 
     SIZE 19.57 BY .88 NO-UNDO.
DEFINE VARIABLE fi-valor-is-it AS DECIMAL FORMAT ">>>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88 NO-UNDO.
DEFINE VARIABLE fi-valor-is-dif AS DECIMAL FORMAT "->>>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88 NO-UNDO.     

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 5.14 BY .88 NO-UNDO.

DEFINE VARIABLE valor-cbs AS DECIMAL FORMAT ">>>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Valor CBS" 
     VIEW-AS FILL-IN 
     SIZE 19.57 BY .88 NO-UNDO.

DEFINE VARIABLE valor-ibs-mun AS DECIMAL FORMAT ">>>>>,>>>,>>9.99" INITIAL 0 
     LABEL "Valor IBS Mun":R20 
     VIEW-AS FILL-IN 
     SIZE 19.57 BY .88.

DEFINE VARIABLE valor-ibs-uf AS DECIMAL FORMAT ">>>>>,>>>,>>9.99" INITIAL 0 
     LABEL "Valor IBS UF" 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 61.72 BY 1
     BGCOLOR 7 .

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85.57 BY 13.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     base-ibs-uf AT ROW 2.63 COL 21.72 COLON-ALIGNED
     fi-base-ibs-uf-it AT ROW 2.63 COL 42.72 COLON-ALIGNED NO-LABEL
     fi-base-ibs-uf-dif AT ROW 2.63 COL 63.72 COLON-ALIGNED NO-LABEL
     fi-valor-ibs-uf-it AT ROW 3.54 COL 42.72 COLON-ALIGNED NO-LABEL
     fi-valor-ibs-uf-dif AT ROW 3.54 COL 63.72 COLON-ALIGNED NO-LABEL
     valor-ibs-uf AT ROW 3.58 COL 21.72 COLON-ALIGNED
     base-ibs-mun AT ROW 4.54 COL 21.72 COLON-ALIGNED
     fi-base-ibs-mun-it AT ROW 4.54 COL 42.72 COLON-ALIGNED NO-LABEL
     fi-base-ibs-mun-dif AT ROW 4.54 COL 63.72 COLON-ALIGNED NO-LABEL
     valor-ibs-mun AT ROW 5.5 COL 21.72 COLON-ALIGNED
     fi-valor-ibs-mun-it AT ROW 5.5 COL 42.72 COLON-ALIGNED NO-LABEL
     fi-valor-ibs-mun-dif AT ROW 5.5 COL 63.72 COLON-ALIGNED NO-LABEL
     base-cbs AT ROW 6.46 COL 21.72 COLON-ALIGNED WIDGET-ID 2
     fi-base-cbs-it AT ROW 6.46 COL 42.72 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     fi-base-cbs-dif AT ROW 6.46 COL 63.72 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     valor-cbs AT ROW 7.42 COL 21.72 COLON-ALIGNED WIDGET-ID 4
     fi-valor-cbs-it AT ROW 7.42 COL 42.72 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     fi-valor-cbs-dif AT ROW 7.42 COL 63.72 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     fi-valor-is AT ROW 8.38 COL 21.72 COLON-ALIGNED 
     fi-valor-is-it AT ROW 8.38 COL 42.72 COLON-ALIGNED NO-LABEL 
     fi-valor-is-dif AT ROW 8.38 COL 63.72 COLON-ALIGNED NO-LABEL
     FILL-IN-1 AT ROW 1.63 COL 21.86 COLON-ALIGNED NO-LABEL
     fi-tot-nota AT ROW 1.63 COL 48.29 RIGHT-ALIGNED NO-LABEL
     fi-tot-itens AT ROW 1.63 COL 45 COLON-ALIGNED NO-LABEL
     fi-diferenca AT ROW 1.63 COL 67.72 COLON-ALIGNED NO-LABEL
     rt-button AT ROW 1.58 COL 23.57
     rt-key AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.docum-est
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
         HEIGHT             = 13.71
         WIDTH              = 86.
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
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN base-ibs-mun IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN base-ibs-uf IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN fi-base-ibs-mun-dif IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-base-ibs-mun-it IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-base-ibs-uf-dif IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-base-ibs-uf-it IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-tot-nota IN FRAME f-main
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN fi-valor-ibs-mun-dif IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-valor-ibs-mun-it IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-valor-ibs-uf-dif IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-valor-ibs-uf-it IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN valor-ibs-mun IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN valor-ibs-uf IN FRAME f-main
   2                                                                    */
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

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

  find param-re where param-re.usuario = c-seg-usuario
        no-lock no-error.

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
  {src/adm/template/row-list.i "docum-est"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "docum-est"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  {utp/ut-liter.i Total_da_Nota MRE L}  
  assign fi-tot-nota:screen-value in frame {&FRAME-NAME}  = return-value.

  {utp/ut-liter.i Total_dos_Ötens MRE L}  
  assign fi-tot-itens:screen-value in frame {&FRAME-NAME}  = return-value.

  {utp/ut-liter.i Diferen‡a MRE L}  
  assign fi-diferenca:screen-value in frame {&FRAME-NAME}  = return-value.
 
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
  {utp/ut-liter.i Total_da_Nota MRE L}  
  assign fi-tot-nota:screen-value in frame {&FRAME-NAME}  = return-value.

  {utp/ut-liter.i Total_dos_Ötens MRE L}  
  assign fi-tot-itens:screen-value in frame {&FRAME-NAME}  = return-value.

  {utp/ut-liter.i Diferen‡a MRE L}  
  assign fi-diferenca:screen-value in frame {&FRAME-NAME}  = return-value.
  
  RUN obterTotaisIbsCbs.

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
  
  RUN initializeFieldsValue.

  /* Code placed here will execute AFTER standard behavior.    */
  {utp/ut-liter.i Total_da_Nota MRE L}  
  assign fi-tot-nota:screen-value in frame {&FRAME-NAME}  = return-value.

  {utp/ut-liter.i Total_dos_Ötens MRE L}  
  assign fi-tot-itens:screen-value in frame {&FRAME-NAME}  = return-value.

  {utp/ut-liter.i Diferen‡a MRE L}  
  assign fi-diferenca:screen-value in frame {&FRAME-NAME}  = return-value.

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
  {src/adm/template/snd-list.i "docum-est"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeFieldsValue V-table-Win 
PROCEDURE initializeFieldsValue :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
    ASSIGN base-cbs:SCREEN-VALUE             = "0"
           base-ibs-mun:SCREEN-VALUE         = "0"
           base-ibs-uf:SCREEN-VALUE          = "0"  
           fi-base-cbs-dif:SCREEN-VALUE      = "0"
           fi-base-cbs-it:SCREEN-VALUE       = "0"
           fi-base-ibs-mun-dif:SCREEN-VALUE  = "0"
           fi-base-ibs-mun-it:SCREEN-VALUE   = "0"
           fi-base-ibs-uf-dif:SCREEN-VALUE   = "0"
           fi-base-ibs-uf-it:SCREEN-VALUE    = "0"
           fi-valor-cbs-dif:SCREEN-VALUE     = "0"
           fi-valor-cbs-it:SCREEN-VALUE      = "0"
           fi-valor-ibs-mun-dif:SCREEN-VALUE = "0"
           fi-valor-ibs-mun-it:SCREEN-VALUE  = "0"
           fi-valor-ibs-uf-dif:SCREEN-VALUE  = "0"
           fi-valor-ibs-uf-it:SCREEN-VALUE   = "0"
           valor-cbs:SCREEN-VALUE            = "0"
           valor-ibs-mun:SCREEN-VALUE        = "0"
           valor-ibs-uf:SCREEN-VALUE         = "0"
           fi-valor-is:SCREEN-VALUE          = "0"
           fi-valor-is-it:SCREEN-VALUE       = "0"
           fi-valor-is-dif:SCREEN-VALUE      = "0"
           base-cbs:SENSITIVE                = NO
           base-ibs-mun:SENSITIVE            = NO
           base-ibs-uf:SENSITIVE             = NO  
           fi-base-cbs-dif:SENSITIVE         = NO
           fi-base-cbs-it:SENSITIVE          = NO
           fi-base-ibs-mun-dif:SENSITIVE     = NO
           fi-base-ibs-mun-it:SENSITIVE      = NO
           fi-base-ibs-uf-dif:SENSITIVE      = NO
           fi-base-ibs-uf-it:SENSITIVE       = NO
           fi-valor-cbs-dif:SENSITIVE        = NO
           fi-valor-cbs-it:SENSITIVE         = NO
           fi-valor-ibs-mun-dif:SENSITIVE    = NO
           fi-valor-ibs-mun-it:SENSITIVE     = NO
           fi-valor-ibs-uf-dif:SENSITIVE     = NO
           fi-valor-ibs-uf-it:SENSITIVE      = NO
           valor-cbs:SENSITIVE               = NO
           valor-ibs-mun:SENSITIVE           = NO
           valor-ibs-uf:SENSITIVE            = NO
           fi-valor-is:SENSITIVE             = NO
           fi-valor-is-it:SENSITIVE          = NO
           fi-valor-is-dif:SENSITIVE         = NO
           .
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE obterTotaisIbsCbs V-table-Win 
PROCEDURE obterTotaisIbsCbs :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/

FOR EACH docum-est-tribut NO-LOCK 
    WHERE docum-est-tribut.cod-serie-docto = docum-est.serie-docto
      AND docum-est-tribut.cod-num-docto = docum-est.nro-docto
      AND docum-est-tribut.cdn-emitente = docum-est.cod-emitente
      AND docum-est-tribut.cod-natur-operac = docum-est.nat-operacao:
      
    IF docum-est-tribut.nom-trib <> rep.imp.Imposto:CBS
    AND docum-est-tribut.nom-trib <> rep.imp.Imposto:IBS-UF
    AND docum-est-tribut.nom-trib <> rep.imp.Imposto:IBS-MUN
    AND docum-est-tribut.nom-trib <> rep.imp.Imposto:IS THEN NEXT.

    IF docum-est-tribut.cod-campo <> rep.imp.AtributoImposto:BASE
    AND docum-est-tribut.cod-campo <> rep.imp.AtributoImposto:VALOR THEN NEXT.

    CASE docum-est-tribut.cod-campo:
        WHEN rep.imp.AtributoImposto:BASE THEN DO:
            IF docum-est-tribut.nom-trib = rep.imp.Imposto:CBS THEN DO:
                ASSIGN base-cbs:SCREEN-VALUE IN FRAME {&FRAME-NAME} = docum-est-tribut.cod-conteudo
                       fi-base-cbs-it:SCREEN-VALUE IN FRAME {&FRAME-NAME} = docum-est-tribut.cod-conteudo
                       fi-base-cbs-dif:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0".
            END.
            IF docum-est-tribut.nom-trib = rep.imp.Imposto:IBS-UF THEN DO:
                ASSIGN base-ibs-uf:SCREEN-VALUE IN FRAME {&FRAME-NAME} = docum-est-tribut.cod-conteudo
                       fi-base-ibs-uf-it:SCREEN-VALUE IN FRAME {&FRAME-NAME} = docum-est-tribut.cod-conteudo
                       fi-base-ibs-uf-dif:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0".
            END.
            IF docum-est-tribut.nom-trib = rep.imp.Imposto:IBS-MUN THEN DO:
                ASSIGN base-ibs-mun:SCREEN-VALUE IN FRAME {&FRAME-NAME} = docum-est-tribut.cod-conteudo
                       fi-base-ibs-mun-it:SCREEN-VALUE IN FRAME {&FRAME-NAME} = docum-est-tribut.cod-conteudo
                       fi-base-ibs-mun-dif:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0".
            END.  
        END.
        WHEN rep.imp.AtributoImposto:VALOR THEN DO:
            IF docum-est-tribut.nom-trib = rep.imp.Imposto:CBS THEN DO:
                ASSIGN valor-cbs:SCREEN-VALUE IN FRAME {&FRAME-NAME} = docum-est-tribut.cod-conteudo
                       fi-valor-cbs-it:SCREEN-VALUE IN FRAME {&FRAME-NAME} = docum-est-tribut.cod-conteudo
                       fi-valor-cbs-dif:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0".
            END.
            IF docum-est-tribut.nom-trib = rep.imp.Imposto:IBS-UF THEN DO:
                ASSIGN valor-ibs-uf:SCREEN-VALUE IN FRAME {&FRAME-NAME} = docum-est-tribut.cod-conteudo
                       fi-valor-ibs-uf-it:SCREEN-VALUE IN FRAME {&FRAME-NAME} = docum-est-tribut.cod-conteudo
                       fi-valor-ibs-uf-dif:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0".
            END.
            IF docum-est-tribut.nom-trib = rep.imp.Imposto:IBS-MUN THEN DO:
                ASSIGN valor-ibs-mun:SCREEN-VALUE IN FRAME {&FRAME-NAME} = docum-est-tribut.cod-conteudo
                       fi-valor-ibs-mun-it:SCREEN-VALUE IN FRAME {&FRAME-NAME} = docum-est-tribut.cod-conteudo
                       fi-valor-ibs-mun-dif:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0".
            END.  
            IF docum-est-tribut.nom-trib = rep.imp.Imposto:IS THEN DO:
                ASSIGN fi-valor-is:SCREEN-VALUE IN FRAME {&FRAME-NAME} = docum-est-tribut.cod-conteudo
                       fi-valor-is-it:SCREEN-VALUE IN FRAME {&FRAME-NAME} = docum-est-tribut.cod-conteudo
                       fi-valor-is-dif:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0".
            END.
        END.
    END CASE.
END.    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

