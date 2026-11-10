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
{include/i-prgvrs.i V10IN261 2.00.00.003 } /*** 010003 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V10IN261 MUT}
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
&Scoped-define EXTERNAL-TABLES oper-pad
&Scoped-define FIRST-EXTERNAL-TABLE oper-pad


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR oper-pad.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS c-cod-un-operac de-val-operac-item ~
de-qtd-tempo-pos-proces de-qtd-capac-operac de-eficiencia fi-cod-grp-setup ~
rt-mold7 
&Scoped-Define DISPLAYED-OBJECTS v-unidades c-cod-un-operac c-desc-un ~
de-val-operac-item de-qtd-tempo-pos-proces c-desc-un-med-tempo ~
de-qtd-capac-operac de-qtd-carga-batch de-eficiencia c-cod-unid-capac ~
c-desc-capac v-lote-medio fi-cod-grp-setup 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS c-cod-un-operac de-val-operac-item ~
de-qtd-tempo-pos-proces de-eficiencia c-cod-unid-capac 

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

DEFINE VARIABLE fi-cod-grp-setup AS CHARACTER FORMAT "X(16)" 
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

DEFINE RECTANGLE rt-mold7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.57 BY 9.71.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     v-unidades AT ROW 1.71 COL 22 COLON-ALIGNED
     c-cod-un-operac AT ROW 2.71 COL 22 COLON-ALIGNED
     c-desc-un AT ROW 2.71 COL 27.29 COLON-ALIGNED NO-LABEL
     de-val-operac-item AT ROW 3.71 COL 22 COLON-ALIGNED
     de-qtd-tempo-pos-proces AT ROW 5.21 COL 22 COLON-ALIGNED
     c-desc-un-med-tempo AT ROW 5.21 COL 30.43 COLON-ALIGNED NO-LABEL
     de-qtd-capac-operac AT ROW 6.71 COL 22 COLON-ALIGNED
     de-qtd-carga-batch AT ROW 7.71 COL 22 COLON-ALIGNED
     de-eficiencia AT ROW 9.21 COL 22 COLON-ALIGNED
     de-perc-refugo AT ROW 4.5 COL 75 COLON-ALIGNED
     de-perc-retrab AT ROW 5.5 COL 75 COLON-ALIGNED
     c-cod-unid-capac AT ROW 6.71 COL 54 COLON-ALIGNED
     c-desc-capac AT ROW 6.71 COL 62.14 COLON-ALIGNED NO-LABEL
     v-lote-medio AT ROW 7.71 COL 54 COLON-ALIGNED
     fi-cod-grp-setup AT ROW 8.71 COL 54 COLON-ALIGNED HELP
          "C¢digo Grupo Setup"
     rt-mold7 AT ROW 1 COL 1.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 85.72 BY 9.88.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.oper-pad
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
         HEIGHT             = 9.88
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
   NOT-VISIBLE Custom                                                   */
ASSIGN 
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-cod-un-operac IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN c-cod-unid-capac IN FRAME f-main
   NO-ENABLE 2                                                          */
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

/* SETTINGS FOR FILL-IN de-qtd-carga-batch IN FRAME f-main
   NO-ENABLE                                                            */
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
  &if defined (bf_man_sfc_lc) &then
      if avail grup-maquina and grup-maquina.ind-tempo-operac = 3 then do:
         assign v-lote-medio:screen-value in frame {&frame-name} = string
                (grup-maquina.qtd-carga-batch / input frame {&frame-name} de-qtd-capac-operac
                * input frame {&frame-name} v-unidades).
      end.  
  &endif    
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
  {src/adm/template/row-list.i "oper-pad"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "oper-pad"}

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

  do with frame {&frame-name}:

     assign v-unidades:hidden                  = false
            de-qtd-capac-operac:screen-value   = string(1)
            de-val-operac-item:screen-value    = string(1)
            de-eficiencia:screen-value         = "100".

     IF l-sfc-mudancas THEN DO:
         ASSIGN de-perc-refugo:SCREEN-VALUE = "0,00"
                de-perc-retrab:SCREEN-VALUE = "0,00"
                fi-cod-grp-setup:SCREEN-VALUE = "".
     END.

  end.
  
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
  
  if not frame {&frame-name}:validate() then
     return 'ADM-ERROR':U.
  
  &if defined (bf_man_sfc_lc) &then
      assign p-val-operac-item      = input frame {&frame-name} de-val-operac-item
             p-cod-un-operac        = input frame {&frame-name} c-cod-un-operac
             p-qtd-tempo-pos-proces = input frame {&frame-name} de-qtd-tempo-pos-proces
             p-qtd-capac-operac     = input frame {&frame-name} de-qtd-capac-operac.
  &endif

  assign p-unidades = input frame {&frame-name} v-unidades.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  
  if  return-value = 'ADM-ERROR':U THEN
      return 'ADM-ERROR':U.


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
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  DO with frame {&frame-name} on error undo, return "ADM-ERROR":
     ASSIGN {&ADM-CREATE-FIELDS} {&ADM-MODIFY-FIELDS}.

     &if defined (bf_man_sfc_lc) &then  
     assign oper-pad.val-operac-item      = input frame {&frame-name} de-val-operac-item
            oper-pad.cod-un-operac        = input frame {&frame-name} c-cod-un-operac
            oper-pad.qtd-tempo-pos-proces = input frame {&frame-name} de-qtd-tempo-pos-proces
            oper-pad.qtd-capac-operac     = input frame {&frame-name} de-qtd-capac-operac
            oper-pad.cod-unid-capac       = input frame {&frame-name} c-cod-unid-capac
            oper-pad.qtd-carga-batch      = input frame {&frame-name} de-qtd-carga-batch
            oper-pad.dec-1                = input frame {&frame-name} de-eficiencia.

     &IF DEFINED(bf_man_204) &THEN
         IF l-sfc-mudancas THEN DO:
             &IF DEFINED(bf_man_207) &THEN
                ASSIGN oper-pad.val-perc-refugo = INPUT FRAME {&FRAME-NAME} de-perc-refugo
                       oper-pad.val-perc-retrab = INPUT FRAME {&FRAME-NAME} de-perc-retrab.
             &ELSE
                ASSIGN OVERLAY(oper-pad.char-1,100,5) = STRING(INPUT FRAME {&FRAME-NAME} de-perc-refugo)
                       OVERLAY(oper-pad.char-1,105,5) = STRING(INPUT FRAME {&FRAME-NAME} de-perc-retrab).

             &ENDIF
             ASSIGN oper-pad.cod-grp-setup = input frame {&frame-name} fi-cod-grp-setup.
         END.
     &ENDIF

     &endif.

     IF ERROR-STATUS:ERROR THEN
        RUN dispatch IN THIS-PROCEDURE ('show-erros':U ).
               
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

  /* Dispatch standard ADM method.                               */
  /* RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U). */

  /* Code placed here will execute AFTER standard behavior.      */

  &if  defined(ADM-MODIFY-FIELDS) &then
      disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
  
  IF l-sfc-mudancas THEN DO WITH FRAME {&FRAME-NAME}:
      ASSIGN de-perc-refugo:SENSITIVE = FALSE
             de-perc-retrab:SENSITIVE = FALSE
             fi-cod-grp-setup:SENSITIVE = FALSE.
  END.
 
  RUN notify ('disable-fields, GROUP-ASSIGN-TARGET':U). 
  
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

  /* RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) . */

  /* Code placed here will execute AFTER standard behavior.    */
  
  &if defined (bf_man_sfc_lc) &then
  if avail oper-pad then do:
     &if defined (bf_man_204) &then
         IF  l-sfc-mudancas THEN DO:
             ASSIGN fi-cod-grp-setup:SCREEN-VALUE IN FRAME {&FRAME-NAME} = oper-pad.cod-grp-setup.
         END.
     &endif
     if oper-pad.tipo-oper = 1 then do with frame {&frame-name}:
        assign v-unidades                           = oper-pad.nr-unidades 
               v-unidades:screen-value              = string(v-unidades)
               c-desc-un-med-tempo:screen-value     = string(oper-pad.un-med-tempo)
               de-val-operac-item:screen-value      = string(oper-pad.val-operac-item)
               c-cod-un-operac:screen-value         = oper-pad.cod-un-operac
               de-qtd-tempo-pos-proces:screen-value = string(oper-pad.qtd-tempo-pos-proces)
               de-qtd-capac-operac:screen-value     = string(oper-pad.qtd-capac-operac)
               de-eficiencia:screen-value           = string(oper-pad.dec-1).

        &IF DEFINED(bf_man_204) &THEN
            IF l-sfc-mudancas THEN DO:
                &IF DEFINED(bf_man_207) &THEN
                    ASSIGN de-perc-refugo:SCREEN-VALUE = STRING(oper-pad.val-perc-refugo)
                           de-perc-retrab:SCREEN-VALUE = STRING(oper-pad.val-perc-retrab).    
                &ELSE
                    ASSIGN de-perc-refugo:SCREEN-VALUE = SUBSTRING(oper-pad.char-1,100,5) 
                           de-perc-retrab:SCREEN-VALUE = SUBSTRING(oper-pad.char-1,105,5).
                &ENDIF
            END.
        &ENDIF
 

        find first grup-maquina
             where grup-maquina.gm-codigo = oper-pad.gm-codigo no-lock no-error.
        IF AVAIL grup-maquina THEN DO:

            ASSIGN c-cod-unid-capac:screen-value        = grup-maquina.cod-unid-capac
                   de-qtd-carga-batch:screen-value      = string(grup-maquina.qtd-carga-batch).
    
            if grup-maquina.ind-tempo-operac = 3 then
               assign v-lote-medio:screen-value = string(grup-maquina.qtd-carga-batch / 
                                                  oper-pad.qtd-capac-operac * v-unidades).
        END.

        find first unid-capac
             where unid-capac.cod-unid-capac = c-cod-unid-capac:screen-value no-lock no-error.
        assign c-desc-capac:screen-value = if avail unid-capac then unid-capac.des-unid-capac else "":U.
              
        find first tab-unidade
             where tab-unidade.un = c-cod-un-operac:screen-value no-lock no-error.
        assign c-desc-un:screen-value = if avail tab-unidade then tab-unidade.descricao else "":U.
              
     end.
   end.
   &endif

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
  /* RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) . */
  
  RUN notify ('enable-fields, GROUP-ASSIGN-TARGET':U).

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
  
  IF l-sfc-mudancas THEN DO WITH FRAME {&FRAME-NAME}:
      ASSIGN de-perc-refugo:SENSITIVE = TRUE
             de-perc-retrab:SENSITIVE = TRUE
             fi-cod-grp-setup:SENSITIVE = TRUE.
  END.
 
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  
  find first param-global no-lock no-error.
  
  /* Code placed here will execute PRIOR to standard behavior. */

  &if defined (bf_man_sfc_lc) &then

      if avail oper-pad then
         assign v-unidades:screen-value          in frame {&frame-name} = string(oper-pad.nr-unidades) 
                c-desc-un-med-tempo:screen-value in frame {&frame-name} = string(oper-pad.un-med-tempo).

      if avail grup-maquina and grup-maquina.ind-tempo-operac = 3 then do:
         assign v-lote-medio:screen-value in frame {&frame-name} = string
               (grup-maquina.qtd-carga-batch / input frame {&frame-name} de-qtd-capac-operac
               * input frame {&frame-name} v-unidades).
      end.      
  &endif

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
  
  find first grup-maquina
       where grup-maquina.gm-codigo = oper-pad.gm-codigo no-lock no-error.
  
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

&if defined (bf_man_sfc_lc) &then
    find first grup-maquina
         where grup-maquina.gm-codigo = p-grup-maquina no-lock no-error.

    assign c-cod-unid-capac:screen-value in frame {&frame-name}   = string(grup-maquina.cod-unid-capac)
           de-qtd-carga-batch:screen-value in frame {&frame-name} = string(grup-maquina.qtd-carga-batch).
    
    if grup-maquina.ind-tempo-operac = 3 then
        assign v-lote-medio:screen-value in frame {&frame-name} = string(grup-maquina.qtd-carga-batch / oper-pad.qtd-capac-operac * input frame {&frame-name} v-unidades).
    else 
        assign v-lote-medio:screen-value in frame {&frame-name} = "".
        
    find first unid-capac
         where unid-capac.cod-unid-capac = grup-maquina.cod-unid-capac no-lock no-error.
    assign c-desc-capac:screen-value in frame {&frame-name} = if avail unid-capac then unid-capac.des-unid-capac 
                                                              else "":U.
&endif
             
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
  
  /* Verifica se a operaá∆o Ç Interna e se a un med tempo Ç Dias */

  &if defined (bf_man_sfc_lc) &then
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

  &endif
  
  &if defined (bf_man_204) &then
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
      END.
  &endif

          
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
  {src/adm/template/snd-list.i "oper-pad"}

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

