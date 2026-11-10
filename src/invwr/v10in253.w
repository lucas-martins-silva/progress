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
{include/i-prgvrs.i V10IN253 2.00.00.001}  /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V10IN253 MUT}
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
def new global shared var gr-op-altern as rowid no-undo. 

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def buffer b-op-altern for op-altern.
def var i-un-med-tempo as integer no-undo.

{cdp/cdcfgman.i}

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
&Scoped-Define ENABLED-OBJECTS rt-mold-3 
&Scoped-Define DISPLAYED-OBJECTS v-unidades c-cod-un-operac c-desc-un ~
de-val-operac-item de-qtd-tempo-pos-proces c-un-med-tempo ~
de-qtd-capac-operac c-cod-unid-capac c-desc-capac de-qtd-carga-batch ~
v-lote-medio de-eficiencia 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS c-un-med-tempo 
&Scoped-define ADM-ASSIGN-FIELDS c-un-med-tempo 
&Scoped-define ADM-MODIFY-FIELDS c-un-med-tempo 

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

DEFINE VARIABLE c-un-med-tempo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE de-eficiencia AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

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
     SIZE 85.72 BY 7.42.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     v-unidades AT ROW 1.25 COL 20.86 COLON-ALIGNED
     c-cod-un-operac AT ROW 2.25 COL 20.86 COLON-ALIGNED
     c-desc-un AT ROW 2.25 COL 26.43 COLON-ALIGNED NO-LABEL
     de-val-operac-item AT ROW 3.25 COL 20.86 COLON-ALIGNED
     de-qtd-tempo-pos-proces AT ROW 4.25 COL 20.86 COLON-ALIGNED
     c-un-med-tempo AT ROW 4.25 COL 29.43 COLON-ALIGNED NO-LABEL
     de-qtd-capac-operac AT ROW 5.25 COL 20.86 COLON-ALIGNED
     c-cod-unid-capac AT ROW 5.25 COL 54.86 COLON-ALIGNED
     c-desc-capac AT ROW 5.25 COL 63.43 COLON-ALIGNED NO-LABEL
     de-qtd-carga-batch AT ROW 6.25 COL 20.86 COLON-ALIGNED
     v-lote-medio AT ROW 6.25 COL 54.86 COLON-ALIGNED
     de-eficiencia AT ROW 7.25 COL 20.86 COLON-ALIGNED
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
         HEIGHT             = 7.42
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

/* SETTINGS FOR FILL-IN c-cod-un-operac IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-cod-unid-capac IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-capac IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-un IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-un-med-tempo IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN de-eficiencia IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-qtd-capac-operac IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-qtd-carga-batch IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-qtd-tempo-pos-proces IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-val-operac-item IN FRAME f-main
   NO-ENABLE                                                            */
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
                    &where="tab-unidade.un = input frame {&frame-name} c-cod-un-operac}
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


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

{utp/ut-field.i mgind operacao nr-unidades 01}
assign v-unidades:label in frame {&frame-name} = return-value.

&if defined (bf_man_sfc_lc) &then

{utp/ut-field.i mgind operacao val-operac-item 01}
assign de-val-operac-item:label in frame {&frame-name} = return-value.

{utp/ut-field.i mgind operacao cod-un-operac 01}
assign c-cod-un-operac:label in frame {&frame-name} = return-value.

{utp/ut-field.i mgind operacao qtd-tempo-pos-proces 01}
assign de-qtd-tempo-pos-proces:label in frame {&frame-name} = return-value.

{utp/ut-field.i mgind operacao qtd-capac-operac 01}
assign de-qtd-capac-operac:label in frame {&frame-name} = return-value.

{utp/ut-field.i mgind grup-maquina cod-unid-capac 02}
assign c-cod-unid-capac:label in frame {&frame-name} = return-value.

{utp/ut-field.i mgind grup-maquina qtd-carga-batch 01}
assign de-qtd-carga-batch:label in frame {&frame-name} = return-value.

{utp/ut-liter.i Tam_M‚dio_Lote * R}
assign v-lote-medio:label in frame {&frame-name} = return-value.

{utp/ut-liter.i Eficiˆncia_para_CRP * R}
assign de-eficiencia:label in frame {&frame-name} = return-value.

&endif
   
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ).
  
  /* Code placed here will execute AFTER standard behavior.    */
  if avail op-altern then do with frame {&frame-name}:
     find oper-pad     where oper-pad.nr-oper-pad   = op-altern.nr-oper-pad no-lock no-error.
     assign c-un-med-tempo:screen-value           = {ininc/i02in261.i 04 op-altern.un-med-tempo}.   
  end.

  &if defined (bf_man_sfc_lc) &then
      if avail op-altern then do:
         if op-altern.tipo-oper = 1 then do with frame {&frame-name}:
             find first grup-maquina
                  where grup-maquina.gm-codigo = op-altern.gm-codigo no-lock no-error.

             assign v-unidades              = op-altern.nr-unidades 
                    de-val-operac-item      = op-altern.val-operac-item
                    c-cod-un-operac         = op-altern.cod-un-operac
                    de-qtd-tempo-pos-proces = op-altern.qtd-tempo-pos-proces
                    de-qtd-capac-operac     = op-altern.qtd-capac-operac
                    c-cod-unid-capac        = grup-maquina.cod-unid-capac
                    de-qtd-carga-batch      = grup-maquina.qtd-carga-batch
                    de-eficiencia           = op-altern.dec-1.
             
             assign v-unidades:screen-value              = string(v-unidades)
                    de-val-operac-item:screen-value      = string(op-altern.val-operac-item)
                    c-cod-un-operac:screen-value         = op-altern.cod-un-operac
                    de-qtd-tempo-pos-proces:screen-value = string(op-altern.qtd-tempo-pos-proces)
                    de-qtd-capac-operac:screen-value     = string(op-altern.qtd-capac-operac)
                    c-cod-unid-capac:screen-value        = grup-maquina.cod-unid-capac
                    de-qtd-carga-batch:screen-value      = string(grup-maquina.qtd-carga-batch)
                    de-eficiencia:screen-value           = string(op-altern.dec-1).





             if grup-maquina.ind-tempo-operac = 3 then
                assign v-lote-medio:screen-value in frame {&frame-name} = string
                (grup-maquina.qtd-carga-batch / input frame {&frame-name} de-qtd-capac-operac
                * input frame {&frame-name} v-unidades).
                                 
             find first unid-capac
                  where unid-capac.cod-unid-capac = grup-maquina.cod-unid-capac no-lock no-error.
             assign c-desc-capac:screen-value = if avail unid-capac then unid-capac.des-unid-capac else "":U.
             
             find first tab-unidade
                  where tab-unidade.un = op-altern.cod-un-operac no-lock no-error.
             assign c-desc-un:screen-value = if avail tab-unidade then tab-unidade.descricao else "":U.
             
         end.
         ELSE DO:
            assign v-unidades:SCREEN-VALUE                = " "
                   de-val-operac-item:SCREEN-VALUE        = " "
                   c-cod-un-operac:SCREEN-VALUE           = " "
                   c-desc-un:SCREEN-VALUE                 = " "
                   de-qtd-tempo-pos-proces:SCREEN-VALUE   = " "
                   c-un-med-tempo:SCREEN-VALUE            = " "
                   de-qtd-capac-operac:SCREEN-VALUE       = " "
                   c-cod-unid-capac:SCREEN-VALUE          = " "
                   c-desc-capac:SCREEN-VALUE              = " "
                   de-qtd-carga-batch:SCREEN-VALUE        = " "
                   v-lote-medio:SCREEN-VALUE              = " "
                   de-eficiencia:SCREEN-VALUE             = " ".
         END.
      end.
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

