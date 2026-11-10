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
{include/i-prgvrs.i V09IN253 2.00.00.004}  /*** "010004" ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V09IN253 MUT}
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

def var i-par-tipo-oper as integer no-undo.

{cdp/cdcfgman.i}

def var p-unidades             like oper-pad.nr-unidades            no-undo.
def var p-val-operac-item      as decimal format ">,>>9.9999"       no-undo.
def var p-cod-un-operac        as char    format "x(2)"             no-undo.
def var p-qtd-tempo-pos-proces as decimal format ">,>>9.99"         no-undo.
def var p-qtd-capac-operac     as decimal format ">,>>>,>>9.9999"   no-undo.
DEF VAR l-sfc-mudancas         AS LOGICAL                           NO-UNDO.
DEF VAR hProgramZoom           AS HANDLE                            NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES op-altern
&Scoped-define FIRST-EXTERNAL-TABLE op-altern


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR op-altern.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS c-cod-un-operac de-val-operac-item ~
de-qtd-tempo-pos-proces de-qtd-capac-operac de-eficiencia fi-cod-grp-setup ~
rt-mold-3 
&Scoped-Define DISPLAYED-OBJECTS v-unidades c-cod-un-operac c-desc-un ~
de-val-operac-item de-qtd-tempo-pos-proces c-desc-un-med-tempo ~
de-qtd-capac-operac de-qtd-carga-batch de-eficiencia c-cod-unid-capac ~
c-desc-capac v-lote-medio fi-cod-grp-setup 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS c-cod-un-operac de-val-operac-item ~
de-qtd-tempo-pos-proces de-qtd-capac-operac de-qtd-carga-batch ~
de-eficiencia 

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
DEFINE VARIABLE c-cod-un-operac AS CHARACTER FORMAT "X(2)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 4.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-unid-capac AS CHARACTER FORMAT "X(8)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-capac AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-un AS CHARACTER FORMAT "X(15)":U 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-un-med-tempo AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE de-eficiencia AS DECIMAL FORMAT ">>9.99":U INITIAL 100 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE de-perc-refugo AS DECIMAL FORMAT ">9.99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE de-perc-retrab AS DECIMAL FORMAT ">9.99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE de-qtd-capac-operac AS DECIMAL FORMAT ">,>>>,>>9.9999":U INITIAL 1 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE de-qtd-carga-batch AS DECIMAL FORMAT ">,>>>,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE de-qtd-tempo-pos-proces AS DECIMAL FORMAT ">,>>9.99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE de-val-operac-item AS DECIMAL FORMAT ">,>>9.9999":U INITIAL 1 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-grp-setup AS CHARACTER FORMAT "x(16)" 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-lote-medio AS DECIMAL FORMAT ">,>>>,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE v-unidades AS INTEGER FORMAT ">>>>9":U INITIAL 100 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 5.29 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.72 BY 8.96.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     v-unidades AT ROW 1.25 COL 22 COLON-ALIGNED
     c-cod-un-operac AT ROW 2.25 COL 22 COLON-ALIGNED
     c-desc-un AT ROW 2.25 COL 27.57 COLON-ALIGNED NO-LABEL
     de-val-operac-item AT ROW 3.25 COL 22 COLON-ALIGNED
     de-qtd-tempo-pos-proces AT ROW 4.75 COL 22 COLON-ALIGNED
     c-desc-un-med-tempo AT ROW 4.75 COL 30.57 COLON-ALIGNED NO-LABEL
     de-qtd-capac-operac AT ROW 6.25 COL 22 COLON-ALIGNED
     de-qtd-carga-batch AT ROW 7.25 COL 22 COLON-ALIGNED
     de-eficiencia AT ROW 8.75 COL 22 COLON-ALIGNED
     de-perc-refugo AT ROW 4 COL 75 COLON-ALIGNED
     de-perc-retrab AT ROW 5 COL 75 COLON-ALIGNED
     c-cod-unid-capac AT ROW 6.25 COL 54 COLON-ALIGNED
     c-desc-capac AT ROW 6.25 COL 62.14 COLON-ALIGNED NO-LABEL
     v-lote-medio AT ROW 7.25 COL 54 COLON-ALIGNED
     fi-cod-grp-setup AT ROW 8.25 COL 54 COLON-ALIGNED HELP
          "C¢digo Grupo Setup"
     rt-mold-3 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.op-altern
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
         HEIGHT             = 8.96
         WIDTH              = 85.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{include/i-auxtab.i}
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
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-cod-un-operac IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN c-cod-unid-capac IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-capac IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-un IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-un-med-tempo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-eficiencia IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN de-perc-refugo IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       de-perc-refugo:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN de-perc-retrab IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       de-perc-retrab:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN de-qtd-capac-operac IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN de-qtd-carga-batch IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN de-qtd-tempo-pos-proces IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN de-val-operac-item IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN v-lote-medio IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-unidades IN FRAME f-main
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

&Scoped-define SELF-NAME c-cod-un-operac
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-un-operac V-table-Win
ON F5 OF c-cod-un-operac IN FRAME f-main
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="inzoom/z01in417.w"
                     &campo=c-cod-un-operac
                     &campozoom=un
                     &campo2=c-desc-un
                     &campozoom2=descricao}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-un-operac V-table-Win
ON LEAVE OF c-cod-un-operac IN FRAME f-main
DO:
  {include/leave.i &tabela=tab-unidade
                    &atributo-ref=descricao
                    &variavel-ref=c-desc-un
                    &where="tab-unidade.un = input frame {&frame-name} c-cod-un-operac"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-un-operac V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-un-operac IN FRAME f-main
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-unid-capac
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-unid-capac V-table-Win
ON LEAVE OF c-cod-unid-capac IN FRAME f-main
DO:
    {include/leave.i &tabela=unid-capac
                     &atributo-ref=des-unid-capac
                     &variavel-ref=c-desc-capac
                     &where="unid-capac.cod-unid-capac = input frame {&frame-name} c-cod-unid-capac"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME de-qtd-capac-operac
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-qtd-capac-operac V-table-Win
ON LEAVE OF de-qtd-capac-operac IN FRAME f-main
DO:
    if avail grup-maquina and grup-maquina.ind-tempo-operac = 3 then do:
       assign v-lote-medio:screen-value in frame {&frame-name} = string
              (grup-maquina.qtd-carga-batch / input frame {&frame-name} de-qtd-capac-operac
              * input frame {&frame-name} v-unidades).
    end.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-grp-setup
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-grp-setup V-table-Win
ON F5 OF fi-cod-grp-setup IN FRAME f-main
DO:
    {method/ZoomFields.i
           &ProgramZoom="mfzoom/z01mf631.w"
           &FieldZoom1="cod-reduc-prepar"
           &FieldScreen1="fi-cod-grp-setup"
           &Frame1="f-main"
           &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-grp-setup V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-cod-grp-setup IN FRAME f-main
DO:
    APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

ASSIGN l-sfc-mudancas = FALSE.                       
RUN sfc/sf9999.p (OUTPUT l-sfc-mudancas).
IF fi-cod-grp-setup:LOAD-MOUSE-POINTER ("Image/lupa.cur") IN FRAME {&FRAME-NAME} THEN.

if c-cod-un-operac:load-mouse-pointer ("Image~\lupa.cur") in frame {&frame-name} then.

{utp/ut-field.i mgind oper-pad nr-unidades 01}
assign v-unidades:label in frame {&frame-name} = return-value.

{utp/ut-field.i mgind oper-pad val-operac-item 01}
assign de-val-operac-item:label in frame {&frame-name} = return-value.

{utp/ut-field.i mgind oper-pad cod-un-operac 01}
assign c-cod-un-operac:label in frame {&frame-name} = return-value.

{utp/ut-field.i mgind oper-pad qtd-tempo-pos-proces 01}
assign de-qtd-tempo-pos-proces:label in frame {&frame-name} = return-value.

{utp/ut-field.i mgind oper-pad qtd-capac-operac 01}
assign de-qtd-capac-operac:label in frame {&frame-name} = return-value.

{utp/ut-field.i mgind grup-maquina cod-unid-capac 02}
assign c-cod-unid-capac:label in frame {&frame-name} = return-value.

{utp/ut-field.i mgind grup-maquina qtd-carga-batch 01}
assign de-qtd-carga-batch:label in frame {&frame-name} = return-value.

{utp/ut-liter.i Tam_MÇdio_Lote * R}
assign v-lote-medio:label in frame {&frame-name} = return-value.

{utp/ut-liter.i Eficiància_para_CRP * R}
assign de-eficiencia:label in frame {&frame-name} = return-value.

IF l-sfc-mudancas THEN DO:
    {utp/ut-liter.i Perc._Padr∆o_Refugo * R}
    assign de-perc-refugo:label in frame {&frame-name} = return-value.
    {utp/ut-liter.i Perc._Padr∆o_Retrabalho * R}
    assign de-perc-retrab:label in frame {&frame-name} = return-value.
    {utp/ut-liter.i Redutor_de_Setup * R}
    ASSIGN fi-cod-grp-setup:LABEL IN FRAME {&FRAME-NAME} = RETURN-VALUE.
END.

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
  {src/adm/template/row-list.i "op-altern"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "op-altern"}

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
   
    find first operacao
         where rowid(operacao) = v-row-parent no-lock no-error.
    find first op-altern 
         where op-altern.num-id-operacao = operacao.num-id-operacao no-lock no-error.
    find first item
         where item.it-codigo = operacao.it-codigo no-lock no-error.
           
    assign c-cod-un-operac:screen-value in frame {&frame-name} = if avail item then item.un else "":U.
                               
    find first tab-unidade
         where tab-unidade.un = c-cod-un-operac:screen-value in frame {&frame-name} no-lock no-error.

    assign c-desc-un:screen-value in frame {&frame-name} = if avail tab-unidade then tab-unidade.descricao else "":U
           de-eficiencia:screen-value = "100".

    IF l-sfc-mudancas THEN DO:
        ASSIGN de-perc-refugo:SCREEN-VALUE     = "0,00"
               de-perc-retrab:SCREEN-VALUE     = "0,00"
               fi-cod-grp-setup:SCREEN-VALUE   = ""
               de-val-operac-item:SCREEN-VALUE = "1":U.
    END.

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
  /* {include/i-valid.i} */
  
  if not frame {&frame-name}:validate() then
     return 'ADM-ERROR':U.
  
  assign p-val-operac-item      = input frame {&frame-name} de-val-operac-item
           p-cod-un-operac        = input frame {&frame-name} c-cod-un-operac
           p-qtd-tempo-pos-proces = input frame {&frame-name} de-qtd-tempo-pos-proces
           p-qtd-capac-operac     = input frame {&frame-name} de-qtd-capac-operac.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
       RETURN 'ADM-ERROR':U.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  
  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  /* RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) . */

  /* Code placed here will execute AFTER standard behavior.    */

  assign op-altern.val-operac-item      = p-val-operac-item
         op-altern.cod-un-operac        = p-cod-un-operac
         op-altern.qtd-tempo-pos-proces = p-qtd-tempo-pos-proces
         op-altern.qtd-capac-operac     = p-qtd-capac-operac
         op-altern.dec-1                = input frame {&frame-name} de-eficiencia.
 
  IF l-sfc-mudancas THEN DO:
      ASSIGN op-altern.val-perc-refugo = INPUT FRAME {&FRAME-NAME} de-perc-refugo
             op-altern.val-perc-retrab = INPUT FRAME {&FRAME-NAME} de-perc-retrab.
  
      ASSIGN op-altern.cod-grp-setup = input frame {&frame-name} fi-cod-grp-setup.          
  END.

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
  /* RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ). */

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
  
  IF l-sfc-mudancas THEN DO WITH FRAME {&FRAME-NAME}:
      ASSIGN de-perc-refugo:SENSITIVE = FALSE
             de-perc-retrab:SENSITIVE = FALSE
             fi-cod-grp-setup:SENSITIVE = FALSE.
  END.
  
  run notify ('disable-fields, group-assign-target':U).
  
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
  /* RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ). */

  /* Code placed here will execute AFTER standard behavior.    */
 

  
      if avail op-altern then do:
         if op-altern.tipo-oper = 1 then do with frame {&frame-name}:
            find first grup-maquina
                 where grup-maquina.gm-codigo = op-altern.gm-codigo no-lock no-error.
                 
            assign v-unidades                           = op-altern.nr-unidades
                   v-unidades:screen-value              = string(v-unidades)
                   de-val-operac-item:screen-value      = string(op-altern.val-operac-item)
                   c-cod-un-operac:screen-value         = op-altern.cod-un-operac
                   de-qtd-tempo-pos-proces:screen-value = string(op-altern.qtd-tempo-pos-proces)
                   de-qtd-capac-operac:screen-value     = string(op-altern.qtd-capac-operac)
                   c-cod-unid-capac:screen-value        = if avail grup-maquina then
                                                             grup-maquina.cod-unid-capac
                                                          else " "
                   de-qtd-carga-batch:screen-value      = if avail grup-maquina then
                                                             string(grup-maquina.qtd-carga-batch)
                                                          else " "
                   de-eficiencia:screen-value           = string(op-altern.dec-1).

          
            IF l-sfc-mudancas THEN DO:          
                ASSIGN de-perc-refugo:SCREEN-VALUE = STRING(op-altern.val-perc-refugo)
                       de-perc-retrab:SCREEN-VALUE = STRING(op-altern.val-perc-retrab).    

                ASSIGN fi-cod-grp-setup:SCREEN-VALUE IN FRAME {&FRAME-NAME} = op-altern.cod-grp-setup.                    
            END.
          

            if avail grup-maquina and grup-maquina.ind-tempo-operac = 3 then do:
               assign v-lote-medio:screen-value in frame {&frame-name} = string(
                      grup-maquina.qtd-carga-batch / op-altern.qtd-capac-operac * 
                      input frame {&frame-name} v-unidades).
            end.
            find first unid-capac
                 where unid-capac.cod-unid-capac = c-cod-unid-capac:screen-value no-lock no-error.
            assign c-desc-capac:screen-value = if avail unid-capac then unid-capac.des-unid-capac else "":U.
             
            find first tab-unidade
                 where tab-unidade.un = c-cod-un-operac:screen-value no-lock no-error.
            assign c-desc-un:screen-value = if avail tab-unidade then tab-unidade.descricao else "":U.           
         end.
      end.
      else do:
         find first operacao
              where rowid(operacao) = v-row-parent no-lock no-error.
         find first item
              where item.it-codigo = operacao.it-codigo no-lock no-error.
             
         assign c-cod-un-operac:screen-value in frame {&frame-name} = if avail item then item.un else "":U.
                                 
         find first tab-unidade
              where tab-unidade.un = c-cod-un-operac:screen-value in frame {&frame-name} no-lock no-error.
         assign c-desc-un:screen-value in frame {&frame-name} = if avail tab-unidade then tab-unidade.descricao else "":U.
         IF  l-sfc-mudancas THEN
             ASSIGN fi-cod-grp-setup:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
      end.      
 
  
  
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
  /* RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) . */

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
  
  IF l-sfc-mudancas THEN DO WITH FRAME {&FRAME-NAME}:
      ASSIGN de-perc-refugo:SENSITIVE = TRUE
             de-perc-retrab:SENSITIVE = TRUE
             fi-cod-grp-setup:SENSITIVE = TRUE.
  END.

  run notify ('enable-fields, group-assign-target':U).
  
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

  if avail op-altern then do:
     if op-altern.tipo-oper = 1 then do with frame {&frame-name}:
        find first grup-maquina
             where grup-maquina.gm-codigo = op-altern.gm-codigo no-lock no-error.

        if avail grup-maquina and grup-maquina.ind-tempo-operac = 3 then  do:
           assign v-lote-medio:screen-value in frame {&frame-name} = string
                  (grup-maquina.qtd-carga-batch / input frame {&frame-name} de-qtd-capac-operac
                  * input frame {&frame-name} v-unidades).			  
        end.
     end.
  end.      

  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF l-sfc-mudancas THEN DO WITH FRAME {&FRAME-NAME}:
      ASSIGN de-perc-refugo:HIDDEN = FALSE
             de-perc-retrab:HIDDEN = FALSE.
  END.
  ELSE
      ASSIGN fi-cod-grp-setup:HIDDEN IN FRAME {&FRAME-NAME} = YES.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-dados V-table-Win 
PROCEDURE pi-atualiza-dados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

&if defined (bf_man_sfc_lc) &then  
  
  def input parameter p-unidades          as integer no-undo.
  def input parameter p-desc-un-med-tempo as char    no-undo.

  assign  v-unidades = p-unidades
          v-unidades:screen-value in frame {&frame-name} = string(p-unidades)
          c-desc-un-med-tempo  = p-desc-un-med-tempo
          c-desc-un-med-tempo:screen-value  in frame {&frame-name} = string(p-desc-un-med-tempo).
  
    if avail grup-maquina and grup-maquina.ind-tempo-operac = 3 then do:
     assign v-lote-medio:screen-value in frame {&frame-name} = string
           (grup-maquina.qtd-carga-batch / input frame {&frame-name} de-qtd-capac-operac
           * input frame {&frame-name} v-unidades).
  end.      
   
  &endif  


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-grup-maquina V-table-Win 
PROCEDURE pi-grup-maquina :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param p-grup-maquina like grup-maquina.gm-codigo.

define variable d-lote-medio as decimal no-undo.


find first grup-maquina
	 where grup-maquina.gm-codigo = p-grup-maquina no-lock no-error.

if avail grup-maquina then do:
   assign c-cod-unid-capac:screen-value   in frame {&frame-name} = string(grup-maquina.cod-unid-capac)
		  de-qtd-carga-batch:screen-value in frame {&frame-name} = string(grup-maquina.qtd-carga-batch).

	if grup-maquina.ind-tempo-operac = 3 then  do:
	  assign d-lote-medio = grup-maquina.qtd-carga-batch / decimal(input frame {&frame-name} de-qtd-capac-operac) * v-unidades.
	  if d-lote-medio = ? then 
			assign d-lote-medio = 0.
			
	  assign v-lote-medio:screen-value in frame {&frame-name} = string(d-lote-medio).	
   end.
   else do:
	  assign v-lote-medio:screen-value in frame {&frame-name} = "".
   end. 
   find first unid-capac
		where unid-capac.cod-unid-capac = grup-maquina.cod-unid-capac no-lock no-error.
   assign c-desc-capac:screen-value in frame {&frame-name} = if avail unid-capac then unid-capac.des-unid-capac 
														  else "":U.
end.   


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-oper-pad V-table-Win 
PROCEDURE pi-oper-pad :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param p-nr-oper-pad like oper-pad.nr-oper-pad.


find first oper-pad
	 where oper-pad.nr-oper-pad = p-nr-oper-pad no-lock no-error.
find first grup-maquina
	 where grup-maquina.gm-codigo = oper-pad.gm-codigo no-lock no-error.

assign c-cod-unid-capac:screen-value        in frame {&frame-name}  = string(grup-maquina.cod-unid-capac)
	   de-qtd-carga-batch:screen-value      in frame {&frame-name}  = string(grup-maquina.qtd-carga-batch)
	   de-qtd-tempo-pos-proces:screen-value in frame {&frame-name}  = string(oper-pad.qtd-tempo-pos-proces)
	   de-qtd-capac-operac:screen-value     in frame {&frame-name}  = string(oper-pad.qtd-capac-operac)
	   de-val-operac-item:screen-value      in frame {&frame-name}  = string(oper-pad.val-operac-item)
	   c-cod-un-operac:screen-value         in frame {&frame-name}  = string(oper-pad.cod-un-operac)
	   v-unidades:screen-value              in frame {&frame-name}  = string(oper-pad.nr-unidades)
	   de-eficiencia:screen-value           in frame {&frame-name}  = string(oper-pad.dec-1).

IF l-sfc-mudancas THEN DO:
	&IF DEFINED(bf_man_207) &THEN
		ASSIGN de-perc-refugo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(oper-pad.val-perc-refugo)
			   de-perc-retrab:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(oper-pad.val-perc-retrab).
	&ELSE
		ASSIGN de-perc-refugo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = SUBSTRING(oper-pad.char-1,100,5)
			   de-perc-retrab:SCREEN-VALUE IN FRAME {&FRAME-NAME} = SUBSTRING(oper-pad.char-1,105,5).
	&ENDIF
END.

if grup-maquina.ind-tempo-operac = 3 then do:
	assign v-lote-medio:screen-value in frame {&frame-name} = string(grup-maquina.qtd-carga-batch / 
		   op-altern.qtd-capac-operac * v-unidades).
end.
else do:
	assign v-lote-medio:screen-value in frame {&frame-name} = "".
end.   
find first unid-capac
	 where unid-capac.cod-unid-capac = grup-maquina.cod-unid-capac no-lock no-error.
assign c-desc-capac:screen-value in frame {&frame-name} = if avail unid-capac then unid-capac.des-unid-capac 
														  else "":U.
														  
find first tab-unidade
	 where tab-unidade.un = oper-pad.cod-un-operac no-lock no-error.
assign c-desc-un = if avail tab-unidade then tab-unidade.descricao else "":U.                                                              
    


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
  ainda n∆o foi criado.       
------------------------------------------------------------------------------*/
  {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */
   

   if input frame {&frame-name} c-cod-un-operac <> "" then do:
  	   find first tab-unidade
  	   	   where tab-unidade.un = input frame {&frame-name} c-cod-un-operac no-lock no-error.
  	   if not avail tab-unidade then do:
  	   	   {utp/ut-field.i mgind tab-unidade un 01}
  	   	   {include/i-vldprg.i}
  	       run utp/ut-msgs.p (input 'show',
  	   					      input 56,
  	   					      input return-value).
  	   	   apply 'entry' to c-cod-un-operac in frame {&frame-name}.
  	   	   return 'adm-error'. 
  	   end.
   end.
   
   if input frame {&frame-name} de-eficiencia > 100 then do:
  	   run utp/ut-msgs.p (input 'show',
  					      input 27303,
  					      input return-value).
  	   apply 'entry' to de-eficiencia in frame {&frame-name}.
   end.

      IF  l-sfc-mudancas THEN DO:
         /*** Se C¢digo de Redutor de Preparaá∆o Ç v†lido ***/
         IF  INPUT FRAME {&FRAME-NAME} fi-cod-grp-setup <> "" AND
             NOT(CAN-FIND(reduc-prepar-aloc
                    WHERE reduc-prepar-aloc.cod-reduc-prepar = INPUT FRAME {&FRAME-NAME} fi-cod-grp-setup)) THEN DO:
             {utp/ut-liter.i Reduá∆o_Preparaá∆o_Alocaá∆o *} 
             RUN utp/ut-msgs.p (INPUT "show",
                                INPUT 56,
                                INPUT RETURN-VALUE).
             APPLY "entry" TO fi-cod-grp-setup IN FRAME {&FRAME-NAME}.
             RETURN 'ADM-ERROR':U.
         END.

         IF INPUT FRAME {&FRAME-NAME} de-val-operac-item <= 0 THEN DO:
             {utp/ut-liter.i Relaá∆o_Operac/Item *} 
             RUN utp/ut-msgs.p (INPUT "show",
                                INPUT 1491,
                                INPUT RETURN-VALUE).
             APPLY "entry" TO de-val-operac-item IN FRAME {&FRAME-NAME}.
             RETURN 'ADM-ERROR':U.
         END.
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
  {src/adm/template/snd-list.i "op-altern"}

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

