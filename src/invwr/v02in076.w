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
{include/i-prgvrs.i V02IN076 2.00.00.002}  /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V02IN076 MUT}
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

{cdp/cdcfgman.i}

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES cot-rede-p
&Scoped-define FIRST-EXTERNAL-TABLE cot-rede-p


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR cot-rede-p.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS cot-rede-p.it-codigo cot-rede-p.overlap ~
cot-rede-p.transporte 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}it-codigo ~{&FP2}it-codigo ~{&FP3}~
 ~{&FP1}overlap ~{&FP2}overlap ~{&FP3}~
 ~{&FP1}transporte ~{&FP2}transporte ~{&FP3}
&Scoped-define ENABLED-TABLES cot-rede-p
&Scoped-define FIRST-ENABLED-TABLE cot-rede-p
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS cot-rede-p.it-codigo cot-rede-p.op-codigo ~
cot-rede-p.op-predeces cot-rede-p.overlap cot-rede-p.transporte 
&Scoped-Define DISPLAYED-OBJECTS c-desc-item c-desc-op-codigo ~
c-desc-op-predec cb-un-med-tempo 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,List-3,List-4,List-5,List-6      */
&Scoped-define ADM-CREATE-FIELDS cot-rede-p.op-codigo ~
cot-rede-p.op-predeces cb-un-med-tempo 
&Scoped-define ADM-ASSIGN-FIELDS cb-un-med-tempo 
&Scoped-define List-3 cb-un-med-tempo 

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
DEFINE VARIABLE cb-un-med-tempo AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "","" 
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "x(60)" 
     VIEW-AS FILL-IN 
     SIZE 35.43 BY .88.

DEFINE VARIABLE c-desc-op-codigo AS CHARACTER FORMAT "X(34)":U 
     VIEW-AS FILL-IN 
     SIZE 45.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-op-predec AS CHARACTER FORMAT "X(34)":U 
     VIEW-AS FILL-IN 
     SIZE 45.14 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 3.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 2.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     cot-rede-p.it-codigo AT ROW 1.17 COL 27.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     c-desc-item AT ROW 1.17 COL 44.86 COLON-ALIGNED NO-LABEL
     cot-rede-p.op-codigo AT ROW 2.17 COL 27.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     c-desc-op-codigo AT ROW 2.17 COL 35.14 COLON-ALIGNED NO-LABEL
     cot-rede-p.op-predeces AT ROW 3.17 COL 27.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     c-desc-op-predec AT ROW 3.17 COL 35.14 COLON-ALIGNED NO-LABEL
     cot-rede-p.overlap AT ROW 4.54 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     cb-un-med-tempo AT ROW 5.5 COL 39.57 COLON-ALIGNED NO-LABEL
     cot-rede-p.transporte AT ROW 5.54 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.72 BY .88
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 4.38 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.cot-rede-p
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
         HEIGHT             = 5.79
         WIDTH              = 89.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-item IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-op-codigo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-op-predec IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-un-med-tempo IN FRAME F-Main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN cot-rede-p.op-codigo IN FRAME F-Main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN cot-rede-p.op-predeces IN FRAME F-Main
   NO-ENABLE 1                                                          */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME cot-rede-p.op-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cot-rede-p.op-codigo V-table-Win
ON F5 OF cot-rede-p.op-codigo IN FRAME F-Main /* Opera‡Æo Sucessora */
DO:

  assign l-implanta = yes.

  {include/zoomvar.i &prog-zoom="inzoom/z04in263.w"
                     &campo=cot-rede-p.op-codigo
                     &campozoom=op-codigo
                     &campo2=c-desc-op-codigo
                     &campozoom2=descricao}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cot-rede-p.op-codigo V-table-Win
ON LEAVE OF cot-rede-p.op-codigo IN FRAME F-Main /* Opera‡Æo Sucessora */
DO:
   {include/leave.i &tabela=operacao
                    &atributo-ref=descricao
                    &variavel-ref=c-desc-op-codigo
                    &where="operacao.it-codigo   = input frame {&frame-name} cot-rede-p.it-codigo and
                            operacao.cod-roteiro = cot-rede-p.cod-roteiro and 
                            operacao.op-codigo   = input frame {&frame-name} cot-rede-p.op-codigo"}  
   if not avail operacao then do:
      {utp/ut-field.i mgind cot-rede-p op-codigo 1}
      run utp/ut-msgs.p (input "show",
                     input 56,
                     input return-value).
      return NO-APPLY.
   end.                         
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cot-rede-p.op-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF cot-rede-p.op-codigo IN FRAME F-Main /* Opera‡Æo Sucessora */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cot-rede-p.op-predeces
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cot-rede-p.op-predeces V-table-Win
ON F5 OF cot-rede-p.op-predeces IN FRAME F-Main /* Opera‡Æo Predecessora */
DO:

  assign l-implanta = yes.


  {include/zoomvar.i &prog-zoom="inzoom/z04in263.w"
                     &campo=cot-rede-p.op-predeces
                     &campozoom=op-codigo
                     &campo2=c-desc-op-predec
                     &campozoom2=descricao}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cot-rede-p.op-predeces V-table-Win
ON LEAVE OF cot-rede-p.op-predeces IN FRAME F-Main /* Opera‡Æo Predecessora */
DO:
   {include/leave.i &tabela=operacao
                    &atributo-ref=descricao
                    &variavel-ref=c-desc-op-predec
                    &where="operacao.it-codigo   = input frame {&frame-name} cot-rede-p.it-codigo and
                            operacao.cod-roteiro = cot-rede-p.cod-roteiro and 
                            operacao.op-codigo   = input frame {&frame-name} cot-rede-p.op-predeces"}  
   if not avail operacao then do:
      {utp/ut-field.i mgind cot-rede-p op-predeces 1}
      run utp/ut-msgs.p (input "show",
                     input 56,
                     input return-value).
      return NO-APPLY.
   end.                         
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cot-rede-p.op-predeces V-table-Win
ON MOUSE-SELECT-DBLCLICK OF cot-rede-p.op-predeces IN FRAME F-Main /* Opera‡Æo Predecessora */
DO:
  apply 'F5' to self.
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
  {src/adm/template/row-list.i "cot-rede-p"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "cot-rede-p"}

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
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
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

  if avail cot-rede-p then do:

       /* procurar descricao da operacao (op-codigo) */
       
       &IF DEFINED (bf_man_204) &THEN
           find item where 
                item.it-codigo = cot-rede-p.it-codigo no-lock no-error.
           if  avail item then
               assign c-desc-item:screen-value in frame {&frame-name} = item.desc-item.
       &ELSE
            find cot-item 
                where cot-item.item-cotacao = cot-rede-p.it-codigo no-lock no-error.
            if  avail cot-item then
                assign c-desc-item:screen-value in frame {&frame-name} = string(cot-item.descricao-1, "x(18)") + cot-item.descricao-2.
       &ENDIF
       
       find cot-oper 
            where cot-oper.num-id-cot-oper = cot-rede-p.num-id-operacao-sucess
            no-lock no-error.

       assign c-desc-op-codigo:screen-value in frame {&frame-name} = if avail cot-oper then cot-oper.descricao else "":U.
       
       /* procurar descricao da operacao predecessora (op-predeces) */
       find cot-oper 
            where cot-oper.num-id-cot-oper = cot-rede-p.num-id-operacao-predec
            no-lock no-error.
       assign c-desc-op-predec:screen-value in frame {&frame-name} = if avail cot-oper then cot-oper.descricao else "":U.
       
       assign cb-un-med-tempo:screen-value in frame {&frame-name} = {ininc/i02in261.i 04 cot-rede-p.un-med-tempo}.
  end.
  else do with frame {&frame-name}:   
       assign cb-un-med-tempo:screen-value  = {ininc/i02in261.i 04 1}.
  end.

  /* Code placed here will execute AFTER standard behavior.    */

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
   assign cb-un-med-tempo:list-items in frame {&frame-name} = {ininc/i02in261.i 03}.

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
  {src/adm/template/snd-list.i "cot-rede-p"}

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
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


