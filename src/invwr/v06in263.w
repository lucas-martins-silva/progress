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
{include/i-prgvrs.i V06IN263 2.00.00.010}  /*** 010010 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V06IN263 MUT}
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

def new global shared var v-row-parent as rowid no-undo.

{cep/ce1234.i} /*** Defini‡Æo TTs e Vari veis - Valida‡Æo Decimais ***/

{cdp/cdcfgman.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES operacao
&Scoped-define FIRST-EXTERNAL-TABLE operacao


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR operacao.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS operacao.data-base operacao.preco-base ~
operacao.preco-ul-ent operacao.data-ult-ent operacao.preco-repos ~
operacao.data-ult-rep operacao.preco-medio[1] operacao.preco-padrao 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}data-base ~{&FP2}data-base ~{&FP3}~
 ~{&FP1}preco-base ~{&FP2}preco-base ~{&FP3}~
 ~{&FP1}preco-ul-ent ~{&FP2}preco-ul-ent ~{&FP3}~
 ~{&FP1}data-ult-ent ~{&FP2}data-ult-ent ~{&FP3}~
 ~{&FP1}preco-repos ~{&FP2}preco-repos ~{&FP3}~
 ~{&FP1}data-ult-rep ~{&FP2}data-ult-rep ~{&FP3}~
 ~{&FP1}preco-medio[1] ~{&FP2}preco-medio[1] ~{&FP3}~
 ~{&FP1}preco-padrao ~{&FP2}preco-padrao ~{&FP3}
&Scoped-define ENABLED-TABLES operacao
&Scoped-define FIRST-ENABLED-TABLE operacao
&Scoped-Define ENABLED-OBJECTS rt-mold rt-key 
&Scoped-Define DISPLAYED-FIELDS operacao.it-codigo operacao.op-codigo ~
operacao.descricao operacao.data-base operacao.preco-base ~
operacao.preco-ul-ent operacao.data-ult-ent operacao.preco-repos ~
operacao.data-ult-rep operacao.preco-medio[1] operacao.preco-padrao 
&Scoped-Define DISPLAYED-OBJECTS c-descricao-item 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS operacao.op-codigo 

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
DEFINE VARIABLE c-descricao-item AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 44.14 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 2.33.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 8.58.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     operacao.it-codigo AT ROW 1.25 COL 24.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     c-descricao-item AT ROW 1.25 COL 41.86 COLON-ALIGNED NO-LABEL
     operacao.op-codigo AT ROW 2.25 COL 24.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     operacao.descricao AT ROW 2.25 COL 31.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 35.43 BY .88
     operacao.data-base AT ROW 3.71 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     operacao.preco-base AT ROW 4.71 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.72 BY .88
     operacao.preco-ul-ent AT ROW 5.71 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.72 BY .88
     operacao.data-ult-ent AT ROW 6.71 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     operacao.preco-repos AT ROW 7.71 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.72 BY .88
     operacao.data-ult-rep AT ROW 8.71 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     operacao.preco-medio[1] AT ROW 9.71 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.72 BY .88
     operacao.preco-padrao AT ROW 10.79 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     rt-mold AT ROW 3.42 COL 1
     rt-key AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.operacao
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY
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
         HEIGHT             = 11.04
         WIDTH              = 88.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit L-To-R, COLUMNS                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-descricao-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN operacao.descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN operacao.it-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN operacao.op-codigo IN FRAME f-main
   NO-ENABLE 1                                                          */
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
{utp/ut-field.i mgind operacao preco-medio 1}
assign operacao.preco-medio[1]:label in frame {&frame-name} = trim(return-value).

&IF  DEFINED (bf_man_custeio_item) &THEN
{utp/ut-liter.i Pre‡o_On-line * R}
assign operacao.preco-padrao:label in frame {&frame-name} = trim(return-value).
&ENDIF

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
  {src/adm/template/row-list.i "operacao"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "operacao"}

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

  find item where item.it-codigo = operacao.it-codigo  no-lock no-error.

  find first param-estoq no-lock no-error.

  /* Valida‡Æo Casas Decimais */

  assign l-rejeita-dec = no
         operacao.preco-base:screen-value     in frame {&frame-name} = string(fn_vld_ajust_dec(input frame {&frame-name} 
                                                                       operacao.preco-base, 0))
         operacao.preco-ul-ent:screen-value   in frame {&frame-name} = string( fn_vld_ajust_dec(input frame {&frame-name} 
                                                                       operacao.preco-ul-ent, 0))
         operacao.preco-repos:screen-value    in frame {&frame-name} = string( fn_vld_ajust_dec(input frame {&frame-name} 
                                                                       operacao.preco-repos, 0))
         operacao.preco-medio[1]:screen-value in frame {&frame-name} = string( fn_vld_ajust_dec(input frame {&frame-name} 
                                                                       operacao.preco-medio[1], 0))
         operacao.preco-padrao:screen-value   in frame {&frame-name} = string( fn_vld_ajust_dec(input frame {&frame-name} 
                                                                       operacao.preco-padrao, 0)).

  if  l-rejeita-dec then do:
      run utp/ut-msgs.p (input "show":U, 
                         input 18100, 
                         input " ").
      return 'ADM-ERROR':U.        
  end.

  if  not avail param-estoq then do:
      {utp/ut-table.i mgind param-estoq 1}  
      run utp/ut-msgs.p (input "show" , 
                         input 56 , 
                         input return-value). 
      return 'ADM-ERROR':U.
  end.     

  if  param-estoq.tem-moeda1 = yes then do:
      run cdp/cd0812.p (input  param-estoq.moeda1,
                        input  0,
                        input  frame {&frame-name} operacao.preco-medio[1],
                        input  today,
                        output operacao.preco-medio[2]).

      if  operacao.preco-medio[2]  = ? then
          assign operacao.preco-medio[2] = 0.    
      else 
         assign operacao.preco-medio[2] = fn_vld_ajust_dec(operacao.preco-medio[2], param-estoq.moeda1).

  end.
  else 
     assign operacao.preco-medio[2] = 0.

  if  param-estoq.tem-moeda2 = yes then do:
      run cdp/cd0812.p (input  param-estoq.moeda2,
                        input  0,
                        input  frame {&frame-name} operacao.preco-medio[1],
                        input  today,
                        output operacao.preco-medio[3]).

      if  operacao.preco-medio[3]  = ? then
          assign operacao.preco-medio[3] = 0.    
      else 
         assign operacao.preco-medio[3] = fn_vld_ajust_dec(operacao.preco-medio[3], param-estoq.moeda2).
  end.
  else 
     assign operacao.preco-medio[3] = 0.   

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

if   available operacao
then do: find item where item.it-codigo = operacao.it-codigo no-lock no-error.
         assign c-descricao-item = if avail item
                               then item.desc-item
                               else "":U.
end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

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
  {src/adm/template/snd-list.i "operacao"}

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


