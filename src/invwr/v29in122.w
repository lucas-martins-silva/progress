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
{include/i-prgvrs.i V29IN122 2.00.00.003}  /*** 010003 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V29IN122 MUT}
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
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES familia
&Scoped-define FIRST-EXTERNAL-TABLE familia


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR familia.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS familia.curva-abc familia.res-int-comp ~
familia.lote-minimo familia.res-for-comp familia.lote-multipl ~
familia.res-cq-comp familia.quant-segur familia.ressup-fabri ~
familia.tempo-segur familia.res-cq-fabri familia.fator-refugo ~
familia.ind-cons-prv familia.lote-economi 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}res-int-comp ~{&FP2}res-int-comp ~{&FP3}~
 ~{&FP1}lote-minimo ~{&FP2}lote-minimo ~{&FP3}~
 ~{&FP1}res-for-comp ~{&FP2}res-for-comp ~{&FP3}~
 ~{&FP1}lote-multipl ~{&FP2}lote-multipl ~{&FP3}~
 ~{&FP1}res-cq-comp ~{&FP2}res-cq-comp ~{&FP3}~
 ~{&FP1}quant-segur ~{&FP2}quant-segur ~{&FP3}~
 ~{&FP1}ressup-fabri ~{&FP2}ressup-fabri ~{&FP3}~
 ~{&FP1}tempo-segur ~{&FP2}tempo-segur ~{&FP3}~
 ~{&FP1}res-cq-fabri ~{&FP2}res-cq-fabri ~{&FP3}~
 ~{&FP1}fator-refugo ~{&FP2}fator-refugo ~{&FP3}~
 ~{&FP1}ind-cons-prv ~{&FP2}ind-cons-prv ~{&FP3}~
 ~{&FP1}lote-economi ~{&FP2}lote-economi ~{&FP3}
&Scoped-define ENABLED-TABLES familia
&Scoped-define FIRST-ENABLED-TABLE familia
&Scoped-Define ENABLED-OBJECTS rt-mold 
&Scoped-Define DISPLAYED-FIELDS familia.curva-abc familia.res-int-comp ~
familia.lote-minimo familia.res-for-comp familia.lote-multipl ~
familia.res-cq-comp familia.quant-segur familia.ressup-fabri ~
familia.tempo-segur familia.res-cq-fabri familia.fator-refugo ~
familia.ind-cons-prv familia.lote-economi 
&Scoped-Define DISPLAYED-OBJECTS c-politica c-tipo-demanda ~
c-tipo-cont-estoq-segur c-emissao-ordens c-fator-ponderacao ~
c-tipo-lote-economico 

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
DEFINE VARIABLE c-emissao-ordens AS CHARACTER FORMAT "X(13)":U 
     LABEL "Fill 2" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE c-fator-ponderacao AS CHARACTER FORMAT "X(23)":U 
     LABEL "Fill 6" 
     VIEW-AS FILL-IN 
     SIZE 23 BY .88 NO-UNDO.

DEFINE VARIABLE c-politica AS CHARACTER FORMAT "X(17)":U 
     LABEL "Fill 4" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE c-tipo-cont-estoq-segur AS CHARACTER FORMAT "X(13)":U 
     LABEL "Fill 5" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE c-tipo-demanda AS CHARACTER FORMAT "X(15)":U 
     LABEL "Fill 1" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE c-tipo-lote-economico AS CHARACTER FORMAT "X(13)":U 
     LABEL "Fill 3" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.72 BY 10.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     familia.curva-abc AT ROW 1.17 COL 26.72
          VIEW-AS TOGGLE-BOX
          SIZE 25.72 BY .88
     c-politica AT ROW 1.17 COL 66.72 COLON-ALIGNED
     c-tipo-demanda AT ROW 2.17 COL 24.57 COLON-ALIGNED
     c-tipo-cont-estoq-segur AT ROW 2.17 COL 66.72 COLON-ALIGNED
     c-emissao-ordens AT ROW 3.17 COL 24.57 COLON-ALIGNED
     familia.res-int-comp AT ROW 3.17 COL 66.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     familia.lote-minimo AT ROW 4.17 COL 24.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.29 BY .88
     familia.res-for-comp AT ROW 4.17 COL 66.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     familia.lote-multipl AT ROW 5.17 COL 24.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.29 BY .88
     familia.res-cq-comp AT ROW 5.17 COL 66.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     familia.quant-segur AT ROW 6.17 COL 24.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.29 BY .88
     familia.ressup-fabri AT ROW 6.17 COL 66.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     familia.tempo-segur AT ROW 7.17 COL 24.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     familia.res-cq-fabri AT ROW 7.17 COL 66.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     c-fator-ponderacao AT ROW 8.17 COL 24.57 COLON-ALIGNED
     familia.fator-refugo AT ROW 8.17 COL 66.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     c-tipo-lote-economico AT ROW 9.17 COL 24.72 COLON-ALIGNED
     familia.ind-cons-prv AT ROW 9.17 COL 66.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     familia.lote-economi AT ROW 10.17 COL 24.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.29 BY .88
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.familia
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
         HEIGHT             = 10.29
         WIDTH              = 86.
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

/* SETTINGS FOR FILL-IN c-emissao-ordens IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-fator-ponderacao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-politica IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tipo-cont-estoq-segur IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tipo-demanda IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tipo-lote-economico IN FRAME f-main
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
  {src/adm/template/row-list.i "familia"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "familia"}

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
  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.
  
  /* Ponha aqui a valida‡Æo de chave duplicada */
  
  /* Ponha aqui as demais valida‡äes */
  
  /* Obs.: CASO A VALIDA€ÇO FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.

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
  assign c-fator-ponderacao:screen-value in frame {&frame-name} = string(familia.fator-ponder[1])  + "" +
                                                                  string(familia.fator-ponder[2])  + "" +
                                                                  string(familia.fator-ponder[3])  + "" +
                                                                  string(familia.fator-ponder[4])  + "" +
                                                                  string(familia.fator-ponder[5])  + "" +
                                                                  string(familia.fator-ponder[6])  + "" +
                                                                  string(familia.fator-ponder[7])  + "" +
                                                                  string(familia.fator-ponder[8])  + "" +
                                                                  string(familia.fator-ponder[9])  + "" +
                                                                  string(familia.fator-ponder[10]) + "" +
                                                                  string(familia.fator-ponder[11]) + "" +
                                                                  string(familia.fator-ponder[12]). 


  {utp/ut-liter.i Dependente * R}
  if familia.demanda = 1 then 
     assign c-tipo-demanda:screen-value in frame {&frame-name} = return-value.
  {utp/ut-liter.i Independente * R}
  if familia.demanda = 2 then 
     assign c-tipo-demanda:screen-value in frame {&frame-name} = return-value.
  
  {utp/ut-liter.i Autom tica * R}
  if familia.emissao-ord = 1 then 
     assign c-emissao-ordens:screen-value in frame {&frame-name} = return-value.
  if familia.tipo-lote-ec = 1 then 
     assign c-tipo-lote-economico:screen-value in frame {&frame-name} = return-value.

  {utp/ut-liter.i Manual * R}
  if familia.demanda = 2 then 
     assign c-emissao-ordens:screen-value in frame {&frame-name} = return-value.   
  if familia.tipo-lote-ec = 2 then 
     assign c-tipo-lote-economico:screen-value in frame {&frame-name} = return-value.   
    
  {utp/ut-liter.i Per¡odo_Fixo * R}
  if familia.politica = 1 then 
     assign c-politica:screen-value in frame {&frame-name} = return-value.          
  {utp/ut-liter.i Lote_Econ“mico * R}
  if familia.politica = 2 then 
     assign c-politica:screen-value in frame {&frame-name} = return-value.
  {utp/ut-liter.i Ordem * R}
  if familia.politica = 3 then 
     assign c-politica:screen-value in frame {&frame-name} = return-value.
  {utp/ut-liter.i N¡vel_Superior * R}
  if familia.politica = 4 then 
     assign c-politica:screen-value in frame {&frame-name} = return-value.
  {utp/ut-liter.i Configurado * R}
  if familia.politica = 5 then 
     assign c-politica:screen-value in frame {&frame-name} = return-value.
     
  {utp/ut-liter.i Quantidade * R}
  if familia.tipo-est-seg = 1 then 
     assign c-tipo-cont-estoq-segur:screen-value in frame {&frame-name} = return-value. 
  {utp/ut-liter.i Tempo * R}
  if familia.tipo-est-seg = 2 then 
     assign c-tipo-cont-estoq-segur:screen-value in frame {&frame-name} = return-value.
                   
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
  {utp/ut-field.i mgind familia demanda 1}
  assign c-tipo-demanda:label in frame {&frame-name} = return-value.
  
  {utp/ut-field.i mgind familia emissao-ord 1}
  assign c-emissao-ordens:label in frame {&frame-name} = return-value.
  
  {utp/ut-field.i mgind familia tipo-lote-ec 1}
  assign c-tipo-lote-economico:label in frame {&frame-name} = return-value.
  
  {utp/ut-field.i mgind familia politica 1}
  assign c-politica:label in frame {&frame-name} = return-value.
  
  {utp/ut-field.i mgind familia tipo-est-seg 1}
  assign c-tipo-cont-estoq-segur:label in frame {&frame-name} = return-value.
  
  {utp/ut-field.i mgind familia fator-ponder 1}
  assign c-fator-ponderacao:label in frame {&frame-name} = return-value.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  {src/adm/template/snd-list.i "familia"}

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


