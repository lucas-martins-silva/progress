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
{include/i-prgvrs.i V15IN122 2.00.00.009}  /*** 010009 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v15in122 MUT}
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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

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
&Scoped-define EXTERNAL-TABLES familia
&Scoped-define FIRST-EXTERNAL-TABLE familia


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR familia.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS familia.res-int-comp familia.res-for-comp ~
familia.res-cq-comp familia.ressup-fabri familia.res-cq-fabri 
&Scoped-define ENABLED-TABLES familia
&Scoped-define FIRST-ENABLED-TABLE familia
&Scoped-Define ENABLED-OBJECTS RECT-11 RECT-13 
&Scoped-Define DISPLAYED-FIELDS familia.res-int-comp familia.res-for-comp ~
familia.res-cq-comp familia.ressup-fabri familia.res-cq-fabri 
&Scoped-define DISPLAYED-TABLES familia
&Scoped-define FIRST-DISPLAYED-TABLE familia
&Scoped-Define DISPLAYED-OBJECTS cb-tp-ressup i-cd-freq c-desc-freq ~
i-cod-fat-ponder c-desc-formula de-pto-enc de-lote-per-max i-crit-cc ~
i-crit-ce 

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
DEFINE VARIABLE cb-tp-ressup AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 3
     DROP-DOWN-LIST
     SIZE 25 BY 1 NO-UNDO.

DEFINE VARIABLE c-desc-formula AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 28.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-freq AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 28.29 BY .88 NO-UNDO.

DEFINE VARIABLE de-lote-per-max AS DECIMAL FORMAT ">>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE de-pto-enc AS DECIMAL FORMAT ">>>,>>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 24.29 BY .88 NO-UNDO.

DEFINE VARIABLE i-cd-freq AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 4.86 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-fat-ponder AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .88 NO-UNDO.

DEFINE VARIABLE i-crit-cc AS INTEGER FORMAT "9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 3 BY .88 NO-UNDO.

DEFINE VARIABLE i-crit-ce AS INTEGER FORMAT "9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 3 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 52.57 BY 9.58.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 32 BY 9.58.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     cb-tp-ressup AT ROW 2.29 COL 17.43 COLON-ALIGNED
     familia.res-int-comp AT ROW 3.21 COL 77.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     i-cd-freq AT ROW 3.29 COL 17.43 COLON-ALIGNED
     c-desc-freq AT ROW 3.29 COL 22.72 COLON-ALIGNED NO-LABEL
     familia.res-for-comp AT ROW 4.21 COL 77.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     i-cod-fat-ponder AT ROW 4.29 COL 17.43 COLON-ALIGNED
     c-desc-formula AT ROW 4.29 COL 22.72 COLON-ALIGNED NO-LABEL
     familia.res-cq-comp AT ROW 5.21 COL 77.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     de-pto-enc AT ROW 5.29 COL 17.57 COLON-ALIGNED
     familia.ressup-fabri AT ROW 6.21 COL 77.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     de-lote-per-max AT ROW 6.29 COL 17.72 COLON-ALIGNED
     familia.res-cq-fabri AT ROW 7.21 COL 77.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     i-crit-cc AT ROW 7.29 COL 17.72 COLON-ALIGNED
     i-crit-ce AT ROW 8.29 COL 17.72 COLON-ALIGNED
     RECT-11 AT ROW 1 COL 1
     RECT-13 AT ROW 1 COL 54.72
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
         HEIGHT             = 9.58
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
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME f-main:HIDDEN           = TRUE
       FRAME f-main:HEIGHT           = 9.58
       FRAME f-main:WIDTH            = 85.72.

/* SETTINGS FOR FILL-IN c-desc-formula IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-freq IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-tp-ressup IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-lote-per-max IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-pto-enc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-cd-freq IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-cod-fat-ponder IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-crit-cc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-crit-ce IN FRAME f-main
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

&Scoped-define SELF-NAME cb-tp-ressup
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-tp-ressup V-table-Win
ON VALUE-CHANGED OF cb-tp-ressup IN FRAME f-main
DO:
   if input frame {&frame-name} cb-tp-ressup <> {ininc/i01in598.i 04 3} then do:
       assign i-cd-freq:screen-value in frame {&frame-name}          = "0"
              de-lote-per-max:screen-value in frame {&frame-name}    = "0".
       disable i-cd-freq 
               de-lote-per-max
               with frame {&frame-name}.
   end.
   else
       enable  i-cd-freq 
               de-lote-per-max
               with frame {&frame-name}. 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cd-freq
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cd-freq V-table-Win
ON F5 OF i-cd-freq IN FRAME f-main
DO:
  {include/zoomvar.i &prog-zoom=adzoom/z01ad122.w
                     &campo=i-cd-freq
                     &campozoom=cd-freq}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cd-freq V-table-Win
ON LEAVE OF i-cd-freq IN FRAME f-main
DO:
  {include/leave.i &tabela=frequencia
                   &atributo-ref=descricao
                   &variavel-ref=c-desc-freq
                   &where="frequencia.cd-freq = input frame {&frame-name}
                           i-cd-freq"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cd-freq V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-cd-freq IN FRAME f-main
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cod-fat-ponder
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-fat-ponder V-table-Win
ON F5 OF i-cod-fat-ponder IN FRAME f-main
DO:
  {include/zoomvar.i &prog-zoom=inzoom/z01in659.w
                       &campo=i-cod-fat-ponder 
                       &campozoom=cod-fat-ponder}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-fat-ponder V-table-Win
ON LEAVE OF i-cod-fat-ponder IN FRAME f-main
DO:
  {include/leave.i &tabela=fat-ponder
                   &atributo-ref=descricao
                   &variavel-ref=c-desc-formula
                   &where="fat-ponder.cod-fat-ponder = input frame {&frame-name}
                           i-cod-fat-ponder"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-fat-ponder V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-cod-fat-ponder IN FRAME f-main
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF       

  if i-cd-freq:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
  if i-cod-fat-ponder:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  find current familia-mat exclusive-lock.
  /* Code placed here will execute AFTER standard behavior.    */
  assign input frame {&frame-name} i-cod-fat-ponder
         familia-mat.cod-fat-ponder = i-cod-fat-ponder
         input frame {&frame-name} de-pto-enc
         familia-mat.ponto-encomenda = de-pto-enc
         input frame {&frame-name} i-crit-cc
         familia-mat.crit-cc = i-crit-cc
         input frame {&frame-name} i-crit-ce
         familia-mat.crit-ce = i-crit-ce
         input frame {&frame-name} cb-tp-ressup
         familia-mat.tp-ressup = {ininc/i01in598.i 06 cb-tp-ressup}
         input frame {&frame-name} i-cd-freq
         familia-mat.cd-freq = i-cd-freq
         input frame {&frame-name} de-lote-per-max
         familia-mat.lote-per-max = de-lote-per-max.
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
  disable cb-tp-ressup 
          i-cd-freq
          de-lote-per-max
          i-cod-fat-ponder
          de-pto-enc
          i-crit-cc
          i-crit-ce
          with frame {&frame-name}.
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
  do  with frame {&frame-name}:
      if  avail familia then do:
          {cep/ce0102.i2 familia-mat familia}
          assign cb-tp-ressup:screen-value        = {ininc/i01in598.i 04 familia-mat.tp-ressup}
                 i-cd-freq:screen-value           = string(familia-mat.cd-freq)
                 de-lote-per-max:screen-value     = string(familia-mat.lote-per-max)
                 i-cod-fat-ponder:screen-value    = string(familia-mat.cod-fat-ponder) 
                 de-pto-enc:screen-value          = string(familia-mat.ponto-encomenda)
                 i-crit-cc:screen-value           = string(familia-mat.crit-cc)
                 i-crit-ce:screen-value           = string(familia-mat.crit-ce).
         for first fat-ponder fields(cod-fat-ponder descricao) where
             fat-ponder.cod-fat-ponder = familia-mat.cod-fat-ponder no-lock: end.
         if avail fat-ponder then
             assign c-desc-formula:screen-value = fat-ponder.descricao.
         for first frequencia fields(cd-freq descricao) where
             frequencia.cd-freq = familia-mat.cd-freq no-lock: end.
         if avail frequencia then
             assign c-desc-freq:screen-value = frequencia.descricao.
      end.
      else
          assign cb-tp-ressup:screen-value           = {ininc/i01in598.i 04 1}
                 de-lote-per-max                     = 1
                 i-cd-freq                           = 0
                 i-cod-fat-ponder:screen-value       = string(0) 
                 de-pto-enc:screen-value             = string(0)
                 i-crit-cc:screen-value              = string(0)
                 i-crit-ce:screen-value              = string(0)
                 c-desc-formula:screen-value         = " "
                 c-desc-freq:screen-value            = " ".
  end.
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
  enable cb-tp-ressup 
         i-cod-fat-ponder
         de-pto-enc
         i-crit-cc
         i-crit-ce
         with frame {&frame-name}.

  if  avail familia then do:
      {cep/ce0102.i2 familia-mat familia}
      if  familia-mat.tp-ressup <> 3 then
          disable i-cd-freq
                  de-lote-per-max
                  with frame {&frame-name}.
      else
          enable i-cd-freq
                 de-lote-per-max
                 with frame {&frame-name}.
  end.                              

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
  do  with frame {&frame-name}:

      {utp/ut-field.i mgind item-mat cd-freq 1}
      assign i-cd-freq:label in frame {&frame-name} = return-value.
      {utp/ut-field.i mgind item-mat lote-per-max 1}
      assign de-lote-per-max:label in frame {&frame-name} = return-value.
      {utp/ut-field.i mgind item-mat-estab tp-ressup 1}
      assign cb-tp-ressup:label in frame {&frame-name} = trim(return-value).
      {utp/ut-field.i mgind item-mat cod-fat-ponder 1}
      assign i-cod-fat-ponder:label in frame {&frame-name} = trim(return-value).
      {utp/ut-field.i mgind item-mat-estab ponto-encomenda 1}
      assign de-pto-enc:label in frame {&frame-name} = trim(return-value).
      {utp/ut-field.i mgind item-mat-estab crit-cc 1}
      assign i-crit-cc:label in frame {&frame-name} = trim(return-value).
      {utp/ut-field.i mgind item-mat-estab crit-ce 1}
      assign i-crit-ce:label in frame {&frame-name} = trim(return-value).      

&if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
   DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
   ASSIGN cAuxTraducao001 = {ininc/i01in598.i 03}.
   RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao001).
   ASSIGN cb-tp-ressup:LIST-ITEM-PAIRS           = cAuxTraducao001.
&else
   ASSIGN cb-tp-ressup:list-items           = {ininc/i01in598.i 03}.
&endif
ASSIGN 
             cb-tp-ressup:screen-value in frame {&frame-name} = {ininc/i01in598.i 04 1}.
  end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .


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

