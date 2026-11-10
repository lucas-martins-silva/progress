&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
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
{include/i-prgvrs.i V06AD107 2.00.00.016 } /*** 010016 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v06ad107 MUT}
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

{include/i-vrtab.i empresa}
{cdp/cdcfgdis.i}
{cdp/cdcfgmat.i}

/* Parameters Definitions ---                                           */

def var c-cep-unformat as char.
def var c-formato      as char no-undo.
def var c-cep-aux      as char format "x(12)" no-undo.

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
&Scoped-define EXTERNAL-TABLES estabelec
&Scoped-define FIRST-EXTERNAL-TABLE estabelec


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR estabelec.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS estabelec.cidade estabelec.estado ~
estabelec.pais estabelec.ep-codigo estabelec.cgc estabelec.ins-estadual 
&Scoped-define ENABLED-TABLES estabelec
&Scoped-define FIRST-ENABLED-TABLE estabelec
&Scoped-Define ENABLED-OBJECTS RECT-5
&Scoped-Define DISPLAYED-FIELDS estabelec.cidade estabelec.estado ~
estabelec.pais estabelec.ep-codigo estabelec.cgc estabelec.ins-estadual 
&Scoped-define DISPLAYED-TABLES estabelec
&Scoped-define FIRST-DISPLAYED-TABLE estabelec
&Scoped-Define DISPLAYED-OBJECTS c-endereco c-bairro c-cep c-empresa ~
rs-trib-pis 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS rs-trib-pis c-endereco c-bairro

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
DEFINE VARIABLE c-bairro AS CHARACTER FORMAT "X(60)":U 
     LABEL "Bairro" 
     VIEW-AS FILL-IN 
     SIZE 58 BY .88 NO-UNDO.

DEFINE VARIABLE c-cep AS CHARACTER FORMAT "X(12)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-empresa AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-endereco AS CHARACTER FORMAT "X(60)":U 
     LABEL "Endere‡o" 
     VIEW-AS FILL-IN 
     SIZE 58 BY .88 NO-UNDO.

DEFINE VARIABLE rs-trib-pis AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Tributado", 1,
"Isento", 2
     SIZE 14.86 BY 1.67 NO-UNDO.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 28 BY 2.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     c-endereco AT ROW 1.5 COL 24 COLON-ALIGNED WIDGET-ID 2
     c-bairro AT ROW 2.5 COL 24 COLON-ALIGNED WIDGET-ID 4
     estabelec.cidade AT ROW 3.54 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 26.43 BY .88
     estabelec.estado AT ROW 3.54 COL 51 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5.43 BY .88
     estabelec.pais AT ROW 4.54 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .88
     c-cep AT ROW 5.54 COL 24 COLON-ALIGNED
     estabelec.ep-codigo AT ROW 6.54 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     c-empresa AT ROW 6.54 COL 29.57 COLON-ALIGNED NO-LABEL
     estabelec.cgc AT ROW 7.54 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20.43 BY .88
     estabelec.ins-estadual AT ROW 8.54 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20.43 BY .88
     rs-trib-pis AT ROW 10.58 COL 28.14 NO-LABEL
     "Tributa‡Æo PIS/COFINS" VIEW-AS TEXT
          SIZE 21.72 BY .67 AT ROW 9.5 COL 27.29
     RECT-5 AT ROW 9.83 COL 26
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.estabelec
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
         HEIGHT             = 11.71
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
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-cep IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-empresa IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET rs-trib-pis IN FRAME f-main
   NO-ENABLE 2                                                          */
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

&Scoped-define SELF-NAME c-cep
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cep V-table-Win
ON LEAVE OF c-cep IN FRAME f-main
DO:
  assign c-formato = input frame {&FRAME-NAME} c-cep no-error.

  if  ERROR-STATUS:ERROR then do:
      assign c-cep:format in frame {&FRAME-NAME} = "x(12)".
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

/*{utp/ut-field.i mgadm estabelec condado 1}
 * assign estabelec.pais:label in frame {&frame-name} = return-value.*/



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
  {src/adm/template/row-list.i "estabelec"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "estabelec"}

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

  {include/i-valid.i}
  assign input frame {&frame-name} rs-trib-pis
         input frame {&frame-name} c-endereco
         input frame {&frame-name} c-bairro.

  assign c-cep-unformat = replace(input frame {&frame-name} c-cep,".","")
         c-cep-unformat = replace(c-cep-unformat,",","") 
         c-cep-unformat = replace(c-cep-unformat,"-","")
         c-cep-unformat = replace(c-cep-unformat,";","").

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  assign estabelec.cep = integer(c-cep-unformat).
  &if "{&bf_mat_versao_ems}" >= "2.06" &then
     ASSIGN estabelec.idi-tributac-cofins = INPUT FRAME {&frame-name} rs-trib-pis.
  &else
     ASSIGN OVERLAY(estabelec.CHAR-2,99,1) = string(int(rs-trib-pis)).
  &endif
  
     IF AVAIL estabelec THEN
         ASSIGN estabelec.endereco = INPUT FRAME {&FRAME-NAME} c-endereco
                estabelec.bairro   = INPUT FRAME {&FRAME-NAME} c-bairro.
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
  ASSIGN rs-trib-pis:SENSITIVE IN FRAME {&FRAME-NAME} = NO
         c-endereco :SENSITIVE IN FRAME {&FRAME-NAME} = NO
         c-bairro   :SENSITIVE IN FRAME {&FRAME-NAME} = NO. 

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute PRIOR to standard behavior. */
  if available estabelec then do:
     if not avail empresa or empresa.ep-codigo <> estabelec.ep-codigo then
        find empresa where empresa.ep-codigo = estabelec.ep-codigo no-lock no-error.
     if available empresa then do:
        assign c-empresa:screen-value in frame {&frame-name} = empresa.nome.
     end.
     else
        assign c-empresa:screen-value in frame {&frame-name} = "".
  end.

  if available estabelec then do:
      assign c-cep     = string(estabelec.cep)
             c-formato = input frame {&FRAME-NAME} c-cep 
             c-endereco:SCREEN-VALUE IN FRAME {&FRAME-NAME} = estabelec.endereco
             c-bairro  :SCREEN-VALUE IN FRAME {&FRAME-NAME} = estabelec.bairro no-error.

       if  ERROR-STATUS:ERROR then 
          assign c-cep:format in frame {&FRAME-NAME} = "x(12)".
       else 
          assign c-cep:format in frame {&FRAME-NAME} = param-global.formato-cep.
  end. 

  if avail estabelec then do:
     assign c-cep-aux = param-global.formato-cep
            c-cep-aux = replace(c-cep-aux,".","")
            c-cep-aux = replace(c-cep-aux,"-","")
            c-cep-aux = replace(c-cep-aux,";","").
     
     if length(string(estabelec.cep)) < length(c-cep-aux) then
        assign c-cep:screen-value in frame {&frame-name} = fill("0",length(c-cep-aux) - length(string(estabelec.cep))) + string(estabelec.cep).
     ELSE
         assign c-cep:screen-value in frame {&frame-name} = string(estabelec.cep).

     apply 'leave':U to estabelec.ep-codigo in frame {&FRAME-NAME}.
  end.

  /* Code placed here will execute AFTER standard behavior.    */
  &if '{&BF_DIS_VERSAO_EMS}' >= '2.06' &then
    IF estabelec.idi-tributac-cofins = 0 THEN
        INPUT FRAME {&FRAME-NAME} rs-trib-pis:SCREEN-VALUE = "1".
    ELSE
        IF estabelec.idi-tributac-cofins = 1 THEN
            INPUT FRAME {&FRAME-NAME} rs-trib-pis:SCREEN-VALUE = "1".
        ELSE
            INPUT FRAME {&FRAME-NAME} rs-trib-pis:SCREEN-VALUE = "2".
  &else
       ASSIGN rs-trib-pis = int(SUBSTR(estabelec.CHAR-2,99,1)).
       DISP rs-trib-pis WITH FRAME {&FRAME-NAME}.

       IF  SUBSTR(estabelec.CHAR-2,99,1) = "" THEN DO:
           ASSIGN rs-trib-pis = 2.
           DISP rs-trib-pis WITH FRAME {&FRAME-NAME}.
       END.

  &endif
  
  INPUT FRAME {&FRAME-NAME} c-endereco:SCREEN-VALUE = estabelec.endereco.
  INPUT FRAME {&FRAME-NAME} c-bairro:SCREEN-VALUE   = estabelec.bairro.

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
  ASSIGN rs-trib-pis:SENSITIVE IN FRAME {&FRAME-NAME} = YES
         c-endereco :SENSITIVE IN FRAME {&FRAME-NAME} = YES
         c-bairro   :SENSITIVE IN FRAME {&FRAME-NAME} = YES.   

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

  find first param-global no-lock no-error.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  if avail param-global then
     assign estabelec.cgc:format in frame {&frame-name} = param-global.formato-id-federal
            estabelec.cgc:label  in frame {&FRAME-NAME} = param-global.label-cgc.


  {utp/ut-liter.i "CEP" * R}
  assign c-cep:label  in frame {&frame-name} = return-value
         c-cep:format in frame {&frame-name} = param-global.formato-cep.

  /* Code placed here will execute AFTER standard behavior.    */



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

  find empresa where 
       estabelec.ep-codigo = empresa.ep-codigo no-lock no-error.
  if avail empresa then
     assign gr-empresa = rowid(empresa).     

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
  {src/adm/template/snd-list.i "estabelec"}

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

