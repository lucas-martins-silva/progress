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
{include/i-prgvrs.i V28IN270 2.00.00.012}  /*** 010012 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V28IN270 MUT}
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
def new global shared var gr-ord-manut as rowid no-undo.

/* Parameters Definitions ---                                           */
{cdp/cdcfgmnt.i}
{cdp/cd9911.i}
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
&Scoped-define EXTERNAL-TABLES ord-manut
&Scoped-define FIRST-EXTERNAL-TABLE ord-manut


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR ord-manut.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ord-manut.nr-ord-produ 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}nr-ord-produ ~{&FP2}nr-ord-produ ~{&FP3}
&Scoped-define ENABLED-TABLES ord-manut
&Scoped-define FIRST-ENABLED-TABLE ord-manut
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS ord-manut.nr-ord-produ ord-manut.dt-manut ~
ord-manut.cd-equipto ord-manut.cd-tag ord-manut.cd-parada 
&Scoped-Define DISPLAYED-OBJECTS cb-estado c-cd-manut c-desc-manut ~
c-desc-tipomanut c-desc-bem 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS ord-manut.dt-manut ord-manut.cd-equipto ~
ord-manut.cd-tag ord-manut.cd-parada 
&Scoped-define ADM-MODIFY-FIELDS c-cd-manut c-desc-manut c-desc-tipomanut ~
c-desc-bem 

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
DEFINE VARIABLE cb-estado AS CHARACTER FORMAT "X(16)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "","" 
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE c-cd-manut AS CHARACTER FORMAT "x(8)" 
     LABEL "Manuten‡Æo":R12 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-unid-negoc AS CHARACTER FORMAT "X(3)":U 
     LABEL "Unidade Neg¢cio" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88.

DEFINE VARIABLE c-des-unid-negoc AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 60.43 BY .88.

DEFINE VARIABLE c-desc-bem AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 48 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-manut AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 51.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-tipomanut AS CHARACTER FORMAT "x(30)" 
     LABEL "":R11 
     VIEW-AS FILL-IN 
     SIZE 66 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 1.33.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 5.33.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     ord-manut.nr-ord-produ AT ROW 1.25 COL 10 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     cb-estado AT ROW 1.25 COL 36 COLON-ALIGNED
     ord-manut.dt-manut AT ROW 1.25 COL 74 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     c-cd-manut AT ROW 2.58 COL 19 COLON-ALIGNED
     c-desc-manut AT ROW 2.58 COL 33.29 COLON-ALIGNED NO-LABEL
     c-desc-tipomanut AT ROW 3.58 COL 19 COLON-ALIGNED
     ord-manut.cd-equipto AT ROW 4.58 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     c-desc-bem AT ROW 4.58 COL 37 COLON-ALIGNED NO-LABEL
     ord-manut.cd-tag AT ROW 5.58 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     ord-manut.cd-parada AT ROW 5.58 COL 54.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     c-cod-unid-negoc AT ROW 6.58 COL 19 COLON-ALIGNED
     c-des-unid-negoc AT ROW 6.58 COL 24.57 COLON-ALIGNED NO-LABEL
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 2.42 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.ord-manut
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
         HEIGHT             = 6.75
         WIDTH              = 90.
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

/* SETTINGS FOR FILL-IN c-cd-manut IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN c-cod-unid-negoc IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN c-des-unid-negoc IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN c-desc-bem IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN c-desc-manut IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN c-desc-tipomanut IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR COMBO-BOX cb-estado IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ord-manut.cd-equipto IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN ord-manut.cd-parada IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN ord-manut.cd-tag IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN ord-manut.dt-manut IN FRAME f-main
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

    {utp/ut-field.i mgind ord-manut estado 1}
    assign cb-estado:label in frame {&frame-name} = trim(return-value).

    {utp/ut-field.i mgind tipo-manut tp-manut 1}
    assign c-desc-tipomanut:label  = trim(return-value).

    {utp/ut-field.i mgind ord-manut cd-manut 1}
    assign c-cd-manut:label = return-value.

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
  {src/adm/template/row-list.i "ord-manut"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "ord-manut"}

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

    if avail ord-manut then do:

       assign v-row-parent = rowid(ord-manut).
       find equipto
            where equipto.cd-equipto = ord-manut.cd-equipto 
            no-lock no-error.

       find manut
            where manut.cd-manut = ord-manut.cd-manut 
            no-lock no-error.

       find tipo-manut
            where tipo-manut.cd-tipo = ord-manut.cd-tipo 
            no-lock no-error.

       assign c-cd-manut =  ord-manut.cd-manut
              c-desc-manut = if avail manut then manut.descricao
                             else ord-manut.des-man-corr
              c-desc-tipomanut = if avail tipo-manut then tipo-manut.descricao
                                 else " "
              c-desc-bem = IF AVAIL equipto THEN equipto.descricao ELSE " ". 
    end.          

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

    /* Code placed here will execute AFTER standard behavior.    */

    if  avail ord-manut then do with frame {&frame-name}:
        assign cb-estado:screen-value = {varinc/var00014.i 04 ord-manut.estado}.
    end.
    else do:
        assign cb-estado:screen-value = {varinc/var00014.i 04 1}.
    end.

    find first param-mi no-lock no-error.
       if avail param-mi and param-mi.formato-cd-equipto <> " " then do:
          assign ord-manut.cd-equipto:format in frame {&frame-name} = param-mi.formato-cd-equipto.
    end.
    if avail param-mi and param-mi.formato-cd-tag <> " " then do:
       assign ord-manut.cd-tag:format in frame {&frame-name} = param-mi.formato-cd-tag.
    end.

  IF AVAIL ord-manut THEN DO WITH FRAME {&FRAME-NAME}:
      IF l-usa-unid-negoc THEN DO:
          &IF DEFINED(bf_mnt_ems207) &THEN
              ASSIGN c-cod-unid-negoc:SCREEN-VALUE = ord-manut.cod-unid-negoc.
          &ELSEIF DEFINED(bf_mnt_ems206b) &then
              ASSIGN c-cod-unid-negoc:SCREEN-VALUE = SUBSTRING(ord-manut.char-1,19,3).
          &ENDIF
          &IF DEFINED(bf_mnt_ems206b) &THEN
              FOR FIRST unid-negoc NO-LOCK
                  WHERE unid-negoc.cod-unid-negoc = c-cod-unid-negoc:SCREEN-VALUE:
              END.
              ASSIGN c-des-unid-negoc:SCREEN-VALUE = IF AVAIL unid-negoc THEN unid-negoc.des-unid-negoc ELSE "":U.
          &ENDIF
      END.
  END.

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

  find first param-global
      no-lock no-error.
  find first param-estoq
      no-lock no-error.
  find first param-mi
      no-lock no-error.

  do  with frame {&frame-name}:
      assign cb-estado:list-items = {varinc/var00014.i 03}. 
  end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF l-usa-unid-negoc THEN DO WITH FRAME {&FRAME-NAME}:
      ASSIGN c-cod-unid-negoc:VISIBLE = YES
             c-des-unid-negoc:VISIBLE = YES.
  END.
  ELSE DO WITH FRAME {&FRAME-NAME}:
      ASSIGN c-cod-unid-negoc:VISIBLE = NO
             c-des-unid-negoc:VISIBLE = NO.
  END.

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

  if  avail ord-manut then
      assign gr-ord-manut = rowid(ord-manut).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mostra-dados V-table-Win 
PROCEDURE pi-mostra-dados :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
/*
 * define input parameter da-par-reporte   as date format "99/99/9999" no-undo.
 * 
 * assign da-reporte:screen-value   in frame {&frame-name} = string(da-par-reporte)
 *        da-reporte = da-par-reporte.
 * 
 * RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .*/

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
  {src/adm/template/snd-list.i "ord-manut"}

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


