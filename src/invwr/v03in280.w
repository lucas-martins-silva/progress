&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgcad            ORACLE
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
{include/i-prgvrs.i V03IN280 2.00.00.020 } /*** "010020" 14/11/2023 11:37:08  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i V03IN280 MUT}
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

def var c-handle  as character no-undo.
def var wh-cc0104 as handle    no-undo.
DEFINE VAR l-considera AS LOGICAL NO-UNDO.
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
&Scoped-define EXTERNAL-TABLES param-compra
&Scoped-define FIRST-EXTERNAL-TABLE param-compra


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR param-compra.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS param-compra.end-cobr-pad ~
param-compra.end-entr-pad param-compra.cod-cond-pag ~
param-compra.cod-mensagem param-compra.log-multi-unid-medid 
&Scoped-define ENABLED-TABLES param-compra
&Scoped-define FIRST-ENABLED-TABLE param-compra
&Scoped-Define ENABLED-OBJECTS RECT-5 RECT-6 RECT-7 RECT-8 ~
tg-considera-dias-uteis tg-cria-pend-incompleta tg-sugere-narrativa-item 
&Scoped-Define DISPLAYED-FIELDS param-compra.end-cobr-pad ~
param-compra.end-entr-pad param-compra.cod-cond-pag ~
param-compra.cod-mensagem param-compra.log-multi-unid-medid 
&Scoped-define DISPLAYED-TABLES param-compra
&Scoped-define FIRST-DISPLAYED-TABLE param-compra
&Scoped-Define DISPLAYED-OBJECTS fi-end-cobr-pad fi-end-entr-pad ~
fi-cod-cond-pag fi-cod-mensagem tg-considera-dias-uteis ~
tg-cria-pend-incompleta tg-sugere-narrativa-item 

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
DEFINE VARIABLE fi-cod-cond-pag AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-mensagem AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE fi-end-cobr-pad AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE fi-end-entr-pad AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 84 BY 5.75.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 84 BY 1.92.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 42.14 BY 2.25.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 41 BY 2.25.

DEFINE VARIABLE tg-considera-dias-uteis AS LOGICAL INITIAL no 
     LABEL "Considera Apenas Dias Èteis" 
     VIEW-AS TOGGLE-BOX
     SIZE 29 BY 1.25 TOOLTIP "Considera Apenas Dias Èteis" NO-UNDO.

DEFINE VARIABLE tg-cria-pend-incompleta AS LOGICAL INITIAL no 
     LABEL "Cria como Pendente de Compl. / Incompleta" 
     VIEW-AS TOGGLE-BOX
     SIZE 38.72 BY .83 NO-UNDO.

DEFINE VARIABLE tg-sugere-narrativa-item AS LOGICAL INITIAL no 
     LABEL "Sugere narrativa do item" 
     VIEW-AS TOGGLE-BOX
     SIZE 28 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     param-compra.end-cobr-pad AT ROW 1.88 COL 24.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.43 BY .88
     fi-end-cobr-pad AT ROW 1.88 COL 32.57 COLON-ALIGNED NO-LABEL
     param-compra.end-entr-pad AT ROW 2.88 COL 24.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.43 BY .88
     fi-end-entr-pad AT ROW 2.88 COL 32.57 COLON-ALIGNED NO-LABEL
     param-compra.cod-cond-pag AT ROW 3.88 COL 24.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     fi-cod-cond-pag AT ROW 3.88 COL 30 COLON-ALIGNED NO-LABEL
     param-compra.cod-mensagem AT ROW 4.88 COL 24.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.38 BY .88
     fi-cod-mensagem AT ROW 4.88 COL 30.52 COLON-ALIGNED NO-LABEL
     param-compra.log-multi-unid-medid AT ROW 5.75 COL 26.72
          VIEW-AS TOGGLE-BOX
          SIZE 35 BY .83
     tg-considera-dias-uteis AT ROW 7.63 COL 2.29 WIDGET-ID 6
     tg-cria-pend-incompleta AT ROW 10.29 COL 2.29 WIDGET-ID 18
     tg-sugere-narrativa-item AT ROW 10.29 COL 44.14 WIDGET-ID 12
     "Data Entrega" VIEW-AS TEXT
          SIZE 13 BY .75 AT ROW 6.83 COL 2 WIDGET-ID 4
     "Inclus∆o de Solicitaá∆o" VIEW-AS TEXT
          SIZE 21 BY .67 AT ROW 9.29 COL 2 WIDGET-ID 16
     "Inclus∆o de Ordem" VIEW-AS TEXT
          SIZE 19 BY .67 AT ROW 9.29 COL 44 WIDGET-ID 10
     RECT-5 AT ROW 1 COL 1
     RECT-6 AT ROW 7.21 COL 1 WIDGET-ID 2
     RECT-7 AT ROW 9.54 COL 42.86 WIDGET-ID 8
     RECT-8 AT ROW 9.54 COL 1 WIDGET-ID 14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.param-compra
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
         HEIGHT             = 10.96
         WIDTH              = 84.72.
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

/* SETTINGS FOR FILL-IN fi-cod-cond-pag IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-cod-mensagem IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-end-cobr-pad IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-end-entr-pad IN FRAME f-main
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

&Scoped-define SELF-NAME param-compra.cod-cond-pag
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-compra.cod-cond-pag V-table-Win
ON F5 OF param-compra.cod-cond-pag IN FRAME f-main /* Condiá∆o Pagamento */
DO:
    assign l-implanta = yes.
    {include/zoomvar.i &prog-zoom=adzoom/z01ad039.w
                       &campo=param-compra.cod-cond-pag
                       &campozoom=cod-cond-pag}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-compra.cod-cond-pag V-table-Win
ON LEAVE OF param-compra.cod-cond-pag IN FRAME f-main /* Condiá∆o Pagamento */
DO:
  {include/leave.i &tabela=cond-pagto
                   &atributo-ref=descricao
                   &variavel-ref=fi-cod-cond-pag
                   &where="cond-pagto.cod-cond-pag = input frame {&frame-name}
                   param-compra.cod-cond-pag"}   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-compra.cod-cond-pag V-table-Win
ON MOUSE-SELECT-DBLCLICK OF param-compra.cod-cond-pag IN FRAME f-main /* Condiá∆o Pagamento */
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-compra.cod-mensagem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-compra.cod-mensagem V-table-Win
ON F5 OF param-compra.cod-mensagem IN FRAME f-main /* Mensagem Padr∆o */
DO:
    assign l-implanta = yes.
    {include/zoomvar.i &prog-zoom=adzoom/z01ad176.w
                       &campo=param-compra.cod-mensagem
                       &campozoom=cod-mensagem}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-compra.cod-mensagem V-table-Win
ON LEAVE OF param-compra.cod-mensagem IN FRAME f-main /* Mensagem Padr∆o */
DO:
  {include/leave.i &tabela=mensagem
                   &atributo-ref=descricao
                   &variavel-ref=fi-cod-mensagem
                   &where="mensagem.cod-mensagem = input frame {&frame-name}
                   param-compra.cod-mensagem"}   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-compra.cod-mensagem V-table-Win
ON MOUSE-SELECT-DBLCLICK OF param-compra.cod-mensagem IN FRAME f-main /* Mensagem Padr∆o */
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-compra.end-cobr-pad
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-compra.end-cobr-pad V-table-Win
ON F5 OF param-compra.end-cobr-pad IN FRAME f-main /* Est Cobranáa Padr∆o */
DO:
  assign l-implanta = yes.
  
    {include/zoomvar.i &prog-zoom=adzoom/z01ad107.w
                       &campo=param-compra.end-cobr-pad
                       &campozoom=cod-estabel}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-compra.end-cobr-pad V-table-Win
ON LEAVE OF param-compra.end-cobr-pad IN FRAME f-main /* Est Cobranáa Padr∆o */
DO:
  {include/leave.i &tabela=estabelec
                   &atributo-ref=nome
                   &variavel-ref=fi-end-cobr-pad
                   &where="estabelec.cod-estabel = input frame {&frame-name}
                     param-compra.end-cobr-pad"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-compra.end-cobr-pad V-table-Win
ON MOUSE-SELECT-DBLCLICK OF param-compra.end-cobr-pad IN FRAME f-main /* Est Cobranáa Padr∆o */
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-compra.end-entr-pad
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-compra.end-entr-pad V-table-Win
ON F5 OF param-compra.end-entr-pad IN FRAME f-main /* Est Entrega Padr∆o */
DO:
  assign l-implanta = yes.
  
    {include/zoomvar.i &prog-zoom=adzoom/z01ad107.w
                       &campo=param-compra.end-entr-pad
                       &campozoom=cod-estabel}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-compra.end-entr-pad V-table-Win
ON LEAVE OF param-compra.end-entr-pad IN FRAME f-main /* Est Entrega Padr∆o */
DO:
   {include/leave.i &tabela=estabelec
                    &atributo-ref=nome
                    &variavel-ref=fi-end-entr-pad
                    &where="estabelec.cod-estabel = input frame {&frame-name}
                     param-compra.end-entr-pad"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-compra.end-entr-pad V-table-Win
ON MOUSE-SELECT-DBLCLICK OF param-compra.end-entr-pad IN FRAME f-main /* Est Entrega Padr∆o */
DO:
    apply "F5" to self.
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

  if param-compra.end-cobr-pad:load-mouse-pointer("Image~\lupa.cur") then .
  if param-compra.end-entr-pad:load-mouse-pointer("Image~\lupa.cur") then .
  if param-compra.cod-mensagem:load-mouse-pointer("Image~\lupa.cur") then .
  if param-compra.cod-cond-pag:load-mouse-pointer("Image~\lupa.cur") then .  
  find estabelec where
       estabelec.cod-estabel = input param-compra.end-cobr-pad no-lock no-error.
  assign fi-end-cobr-pad = if avail estabelec then estabelec.nome else "".
  find estabelec where
       estabelec.cod-estabel = input param-compra.end-entr-pad no-lock no-error.
  assign fi-end-entr-pad = if avail estabelec then estabelec.nome else "". 
  find cond-pagto where
       cond-pagto.cod-cond-pag = input param-compra.cod-cond-pag no-lock no-error.
  assign fi-cod-cond-pag = if avail cond-pagto then cond-pagto.descricao else "".
  find mensagem where
       mensagem.cod-mensagem = input param-compra.cod-mensagem no-lock no-error.
  assign fi-cod-mensagem = if avail mensagem then mensagem.descricao else "".

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
  {src/adm/template/row-list.i "param-compra"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "param-compra"}

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
  {include/i-valid.i}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  
  ASSIGN l-considera = input frame {&FRAME-NAME} tg-considera-dias-uteis
         input frame {&FRAME-NAME} tg-sugere-narrativa-item
         input frame {&FRAME-NAME} tg-cria-pend-incompleta.

  IF AVAIL param-compra THEN DO: 
      IF l-considera THEN
         ASSIGN OVERLAY(param-compra.char-1,136,1) = "1".
      ELSE 
         ASSIGN OVERLAY(param-compra.char-1,136,1) = " ".

      ASSIGN OVERLAY(param-compra.char-2,138,1) = IF tg-sugere-narrativa-item THEN "Y":U ELSE "N":U
             OVERLAY(param-compra.char-2,145,1) = IF tg-cria-pend-incompleta  THEN "Y":U ELSE "N":U.
  END.

if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy V-table-Win 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .

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
  find estabelec where 
       estabelec.cod-estabel = param-compra.end-cobr-pad 
       no-lock no-error.
  assign fi-end-cobr-pad = if avail estabelec then estabelec.nome else "":U.
  find estabelec where 
       estabelec.cod-estabel = param-compra.end-entr-pad 
       no-lock no-error.
  assign fi-end-entr-pad = if avail estabelec then estabelec.nome else "":U.

  find cond-pagto where 
       cond-pagto.cod-cond-pag = param-compra.cod-cond-pag
       no-lock no-error.
  assign fi-cod-cond-pag = if avail cond-pagto then cond-pagto.descricao else "":U.

  find mensagem where 
       mensagem.cod-mensagem = param-compra.cod-mensagem
       no-lock no-error.
  assign fi-cod-mensagem = if avail mensagem then mensagem.descricao else "":U.

  ASSIGN tg-considera-dias-uteis = (Substring(param-compra.char-1,136,1) = "1")
         tg-sugere-narrativa-item = (Substring(param-compra.char-2,138,1) = "Y":U)
         tg-cria-pend-incompleta  = (Substring(param-compra.char-2,145,1) = "Y":U).
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate V-table-Win 
PROCEDURE pi-validate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{include/i-vldfrm.i}

DO  WITH FRAME {&FRAME-NAME}: 
      RUN Who-Is-The-Container IN adm-broker-hdl
          (INPUT this-procedure,
           OUTPUT c-handle).                  
      assign wh-cc0104 = widget-handle(c-handle).
      find estabelec where 
           estabelec.cod-estabel = param-compra.end-cobr-pad:screen-value
           no-lock no-error.
      if  not avail estabelec then do:
          {include/i-vldprg.i}
          {utp/ut-table.i mgadm estabelec 1}
          run utp/ut-msgs.p (input "show", input 56, input return-value).        
          RUN select-page IN wh-cc0104 (3).                    
          apply "entry":U to param-compra.end-cobr-pad.                   
          RETURN 'ADM-ERROR':U.                     
      end.
      find estabelec where
           estabelec.cod-estabel = param-compra.end-entr-pad:screen-value no-lock no-error.
      if  not avail estabelec then do:
          {include/i-vldprg.i}
          {utp/ut-table.i mgadm estabelec 1}
          run utp/ut-msgs.p (input "show", input 56, input return-value).        
          RUN select-page IN wh-cc0104 (3).                    
          apply "entry":U to param-compra.end-entr-pad.                   
          RETURN 'ADM-ERROR':U.                     
      end.
      find cond-pagto where 
           cond-pagto.cod-cond-pag = integer(param-compra.cod-cond-pag:screen-value)
           no-lock no-error.
      if  not avail cond-pagto then do:
          {include/i-vldprg.i}
          {utp/ut-table.i mgadm cond-pagto 1}
          run utp/ut-msgs.p (input "show", input 56, input return-value).        
          RUN select-page IN wh-cc0104 (3).                    
          apply "entry":U to param-compra.cod-cond-pag.                   
          RETURN 'ADM-ERROR':U.                     
      end.
      find mensagem where 
           mensagem.cod-mensagem = integer(param-compra.cod-mensagem:screen-value)
           no-lock no-error.
      if  not avail mensagem then do:
          {include/i-vldprg.i}
          {utp/ut-table.i mgadm mensagem 1}
          run utp/ut-msgs.p (input "show", input 56, input return-value).        
          RUN select-page IN wh-cc0104 (3).                    
          apply "entry":U to param-compra.cod-mensagem.                   
          RETURN 'ADM-ERROR':U.                     
      end.
  END.

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
  {src/adm/template/snd-list.i "param-compra"}

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

