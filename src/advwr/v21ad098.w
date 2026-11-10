&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgcad            PROGRESS
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
{include/i-prgvrs.i V21AD098 2.00.00.011 } /*** 010011 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v21ad098 MUT}
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

{cdp/cdcfgdis.i}
def var c-nome-abrev like emitente.nome-abrev no-undo.
def var c-atrib      as char no-undo format 'x(15)'.

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
&Scoped-define EXTERNAL-TABLES emitente
&Scoped-define FIRST-EXTERNAL-TABLE emitente


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR emitente.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS emitente.cod-entrega emitente.tp-qt-prg 
&Scoped-define ENABLED-TABLES emitente
&Scoped-define FIRST-ENABLED-TABLE emitente
&Scoped-Define ENABLED-OBJECTS RECT-25 RECT-3 RECT-4 rect-conf-prog ~
rect-conf-prog-2 
&Scoped-Define DISPLAYED-FIELDS emitente.cod-entrega emitente.tp-qt-prg 
&Scoped-define DISPLAYED-TABLES emitente
&Scoped-define FIRST-DISPLAYED-TABLE emitente
&Scoped-Define DISPLAYED-OBJECTS rs-ind-atraso rs-Conf-Prog ~
l-chamado-montadora 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS emitente.cod-entrega 
&Scoped-define ADM-ASSIGN-FIELDS emitente.cod-entrega 
&Scoped-define ADM-MODIFY-FIELDS emitente.cod-entrega rs-ind-atraso ~
l-chamado-montadora 

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
DEFINE VARIABLE text-2 AS CHARACTER FORMAT "X(256)":U INITIAL "Indicador Atraso"
      VIEW-AS TEXT 
     SIZE 25.72 BY .67 NO-UNDO.

DEFINE VARIABLE text-3 AS CHARACTER FORMAT "X(256)":U INITIAL "Tipo Qtd" 
      VIEW-AS TEXT 
     SIZE 26.29 BY .67 NO-UNDO.

DEFINE VARIABLE text-4 AS CHARACTER FORMAT "X(256)":U INITIAL "Atualizaá∆o Confirmaá∆o Programa" 
      VIEW-AS TEXT 
     SIZE 25 BY .67 NO-UNDO.

DEFINE VARIABLE rs-Conf-Prog AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Sobrep‰e", 1,
"Acumula", 2
     SIZE 12 BY 2.25 NO-UNDO.

DEFINE VARIABLE rs-ind-atraso AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "N∆o Informa", 1,
"Informa", 2
     SIZE 30.29 BY 1.88 NO-UNDO.

DEFINE RECTANGLE RECT-25
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 76.29 BY 1.58.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 37.86 BY 2.92.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 37.86 BY 2.88.

DEFINE RECTANGLE rect-conf-prog
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 76.29 BY 2.75.

DEFINE RECTANGLE rect-conf-prog-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 76.29 BY 1.92.

DEFINE VARIABLE l-chamado-montadora AS LOGICAL INITIAL no 
     LABEL "Gera Chamado Montadora" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     emitente.cod-entrega AT ROW 1.42 COL 30 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.14 BY .88
     rs-ind-atraso AT ROW 3.92 COL 4.86 NO-LABEL
     emitente.tp-qt-prg AT ROW 3.71 COL 42.14 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "L°quida", 1,
"Acumulada", 2
          SIZE 28.14 BY 1.54
     rs-Conf-Prog AT ROW 6.75 COL 31 HELP
          "Confirmaá∆o Programaá∆o Entrega" NO-LABEL
     text-2 AT ROW 2.96 COL 1.14 COLON-ALIGNED NO-LABEL
     l-chamado-montadora AT ROW 10 COL 31 HELP
          "Gera Chamado Montadora"
     text-3 AT ROW 2.96 COL 39.14 COLON-ALIGNED NO-LABEL
     text-4 AT ROW 6.25 COL 1 COLON-ALIGNED NO-LABEL
     RECT-25 AT ROW 1.08 COL 1
     RECT-3 AT ROW 3.25 COL 1.14
     RECT-4 AT ROW 3.25 COL 39.57
     rect-conf-prog AT ROW 6.5 COL 1
     rect-conf-prog-2 AT ROW 9.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.emitente
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
         HEIGHT             = 10.42
         WIDTH              = 76.43.
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

/* SETTINGS FOR FILL-IN emitente.cod-entrega IN FRAME f-main
   1 2 3                                                                */
/* SETTINGS FOR TOGGLE-BOX l-chamado-montadora IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR RADIO-SET rs-Conf-Prog IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       rs-Conf-Prog:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR RADIO-SET rs-ind-atraso IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN text-2 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN text-3 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN text-4 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       text-4:HIDDEN IN FRAME f-main           = TRUE.

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

&Scoped-define SELF-NAME emitente.cod-entrega
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL emitente.cod-entrega V-table-Win
ON F5 OF emitente.cod-entrega IN FRAME f-main /* Entrega */
DO:

  RUN Get-Field-Screen-Value IN adm-broker-hdl (this-procedure, 'nome-abrev').
  assign c-nome-abrev = return-value.

  l-implanta = yes.
  {include/zoomvar.i &prog-zoom=dizoom/z01di102.w
                     &campozoom=cod-entrega
                     &campo=emitente.cod-entrega
                     &parametros="run pi-seta-inicial in wh-pesquisa (input c-nome-abrev)."}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL emitente.cod-entrega V-table-Win
ON MOUSE-SELECT-DBLCLICK OF emitente.cod-entrega IN FRAME f-main /* Entrega */
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF 

  {utp/ut-liter.i Entrega_Padr∆o *}
  assign emitente.cod-entrega:label in frame {&frame-name} = trim(return-value).


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
  {src/adm/template/row-list.i "emitente"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "emitente"}

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

  {utp/ut-liter.i Entrega_Padr∆o *}
  assign emitente.cod-entrega:label in frame {&frame-name} = trim(return-value).
  assign rs-ind-atraso:sensitive in frame {&frame-name} = yes.

  &IF "{&bf_dis_versao_ems}" >= "2.02" &THEN
  ASSIGN rs-conf-prog:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
  &ENDIF

  assign l-chamado-montadora:sensitive in frame {&frame-name} = yes.

  /* Code placed here will execute AFTER standard behavior.    */

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

  /* Dispatch standard ADM method.           */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  if RETURN-VALUE = 'ADM-ERROR':U then 
     return 'ADM-ERROR':U.

  assign emitente.ind-atraso = input frame {&frame-name} rs-ind-atraso.

  &IF "{&bf_dis_versao_ems}" >= "2.02" &THEN
    FOR FIRST dist-emitente EXCLUSIVE-LOCK
        WHERE dist-emitente.cod-emitente = emitente.cod-emitente:
        &IF "{&bf_dis_versao_ems}" >= "2.06" &THEN
        ASSIGN dist-emitente.idi-confir-programac-entreg = INPUT FRAME {&frame-name} rs-conf-prog.
        &ELSE
        ASSIGN OVERLAY(dist-emitente.char-1,22,1) = IF INPUT FRAME {&FRAME-NAME} rs-conf-prog = 1
                                                       THEN ""
                                                       ELSE STRING(INPUT FRAME {&FRAME-NAME} rs-conf-prog).
        &ENDIF
    END.      
  &ENDIF

  &IF "{&bf_dis_versao_ems}" >= "2.09" &THEN
      assign emitente.log-gera-chamado = input frame {&FRAME-NAME} l-chamado-montadora.
  &ELSE
      assign overlay(emitente.char-1, 101,1) = if l-chamado-montadora:checked in frame {&FRAME-NAME} then 's' else 'n'.
  &ENDIF
    
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

  assign rs-ind-atraso:sensitive in frame {&frame-name} = no.

  &IF "{&bf_dis_versao_ems}" >= "2.02" &THEN
  ASSIGN rs-conf-prog:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
  &ENDIF                                                   
  
  assign l-chamado-montadora:sensitive in frame {&frame-name} = no.

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

  if avail emitente then
     assign rs-ind-atraso:screen-value in frame {&frame-name} = string(emitente.ind-atraso)
            l-chamado-montadora:screen-value in frame {&frame-name} = &IF "{&bf_dis_versao_ems}" >= "2.09" &THEN
                                                                          emitente.log-gera-chamado
                                                                      &ELSE
                                                                          IF SUBSTR(emitente.char-1,101,1) = 's':U
                                                                          THEN 'yes':U
                                                                          ELSE 'no':U
                                                                      &ENDIF .
  else assign rs-ind-atraso = 1.   

  &IF "{&bf_dis_versao_ems}" >= "2.02" &THEN
      ASSIGN rs-conf-prog:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "1".
      IF AVAIL emitente THEN DO:
          FOR FIRST dist-emitente FIELDS( cod-emitente 
                                          &IF "{&bf_dis_versao_ems}" >= "2.06" 
                                              &THEN idi-confir-programac-entreg
                                              &ELSE char-1
                                          &ENDIF ) 
               WHERE dist-emitente.cod-emitente = emitente.cod-emitente NO-LOCK:
          END.
          IF AVAIL dist-emitente THEN
              ASSIGN rs-conf-prog:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 
                       &IF "{&bf_dis_versao_ems}" >= "2.06" &THEN
                           string(dist-emitente.idi-confir-programac-entreg)
                       &ELSE
                       IF SUBSTR(dist-emitente.char-1,22,1) = ""
                           THEN "1"
                           ELSE "2"
                       &ENDIF .
      END.
      DISP text-2 text-3 text-4 WITH FRAME {&FRAME-NAME}.
  &ENDIF

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
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  assign rs-ind-atraso:sensitive in frame {&frame-name} = yes.

  &IF "{&bf_dis_versao_ems}" >= "2.02" &THEN
  ASSIGN rs-conf-prog:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
  &ENDIF

  assign l-chamado-montadora:sensitive in frame {&frame-name} = yes.

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

  if  emitente.cod-entrega:load-mouse-pointer('image/lupa.cur') in frame {&frame-name} then.

  &IF '{&BF_DIS_VERSAO_EMS}' >= '2.02' &THEN
     {utp/ut-liter.i N∆o_Informa MCD c}
     assign c-atrib = trim(return-value) + ", 1," .

     {utp/ut-liter.i Informa MCD c}
     assign c-atrib = c-atrib + trim(return-value) + ", 2," .

     {utp/ut-liter.i Sumaria MCD c}
     assign c-atrib = c-atrib + trim(return-value) + ", 3" .

     assign rs-ind-atraso:radio-buttons in frame {&frame-name} = c-atrib
            rs-ind-atraso:sensitive in frame {&frame-name} = no.

     ASSIGN rs-conf-prog:HIDDEN   IN FRAME {&FRAME-NAME} = NO
            rect-conf-prog:HIDDEN IN FRAME {&FRAME-NAME} = NO
            text-4:HIDDEN         IN FRAME {&FRAME-NAME} = NO.
  &ENDIF  

  &IF '{&BF_DIS_VERSAO_EMS}' < '2.02' &THEN 
  
      {utp/ut-liter.i N∆o_Informa MCD c}
      assign c-atrib = trim(return-value) + ", 1," .

      {utp/ut-liter.i Informa MCD c}
      assign c-atrib = c-atrib + trim(return-value) + ", 2" .

      assign rs-ind-atraso:radio-buttons in frame {&frame-name} = c-atrib
             rs-ind-atraso:sensitive in frame {&frame-name} = no.

      ASSIGN rs-conf-prog:HIDDEN   IN FRAME {&FRAME-NAME} = YES
             rect-conf-prog:HIDDEN IN FRAME {&FRAME-NAME} = YES
             text-4:HIDDEN         IN FRAME {&FRAME-NAME} = YES.
  &ENDIF

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{include/i-vldfrm.i} /* Validaá∆o de dicion†rio */

RUN Get-Field-Screen-Value IN adm-broker-hdl (this-procedure, 'nome-abrev').
assign c-nome-abrev = return-value.

/***** Entrega n∆o Cadastrada *****/
if  not can-find (first loc-entr where loc-entr.cod-entrega =
                        input frame {&frame-name} emitente.cod-entrega and
                        loc-entr.nome-abrev  = c-nome-abrev) then do:
    {include/i-vldprg.i} 
    {utp/ut-table.i mgadm loc-entr 1}
    run utp/ut-msgs.p ('show', 2, trim(return-value)).
    apply 'entry' to emitente.cod-entrega.
    return 'ADM-ERROR'.
end.

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
  {src/adm/template/snd-list.i "emitente"}

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

