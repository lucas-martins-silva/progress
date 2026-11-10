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
{include/i-prgvrs.i V15IN144 2.00.00.006}  /*** 010006 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V15IN144 MUT}
&ENDIF


/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

def new global shared var gr-grup-maquina as rowid no-undo.
def new global shared var c-prog-chama    as char  no-undo.

def var v-row-parent as rowid  no-undo.
def var c-lista      as char   no-undo.
def var c-overlap1   as char   no-undo.
def var c-overlap2   as char   no-undo.
def var c-minimiza1  as char   no-undo.
def var c-minimiza2  as char   no-undo.
def var h_handle     as handle no-undo.

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
&Scoped-define EXTERNAL-TABLES grup-maquina
&Scoped-define FIRST-EXTERNAL-TABLE grup-maquina


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR grup-maquina.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS grup-maquina.cd-calen 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}cd-calen ~{&FP2}cd-calen ~{&FP3}
&Scoped-define ENABLED-TABLES grup-maquina
&Scoped-define FIRST-ENABLED-TABLE grup-maquina
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 RECT-3 rt-mold 
&Scoped-Define DISPLAYED-FIELDS grup-maquina.gm-codigo ~
grup-maquina.cd-calen grup-maquina.descricao 
&Scoped-Define DISPLAYED-OBJECTS num-maquinas log-crp cb-ind-tempo-operac ~
qtd-carga-batch qtd-capac-ctrab cod-unid-capac cb-log-overlap ~
cb-log-minimiza-tempo qtd-lead-time num-operador-ctrab num-operac-simult ~
c-desc-calen c-desc-capac 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS grup-maquina.cd-calen num-maquinas log-crp ~
cb-ind-tempo-operac qtd-carga-batch qtd-capac-ctrab cod-unid-capac ~
cb-log-overlap cb-log-minimiza-tempo qtd-lead-time num-operador-ctrab ~
num-operac-simult 
&Scoped-define ADM-MODIFY-FIELDS grup-maquina.cd-calen num-maquinas log-crp ~
cb-log-overlap cb-log-minimiza-tempo 

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
DEFINE VARIABLE cb-ind-tempo-operac AS CHARACTER FORMAT "X(15)":U INITIAL "0" 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE cb-log-minimiza-tempo AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 2
     LIST-ITEMS "Item 1" 
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE cb-log-overlap AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 2
     LIST-ITEMS "Item 1" 
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE c-desc-calen AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-capac AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS FILL-IN 
     SIZE 21.57 BY .88 NO-UNDO.

DEFINE VARIABLE cod-unid-capac AS CHARACTER FORMAT "X(5)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE num-maquinas AS INTEGER FORMAT ">,>>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE num-operac-simult AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE num-operador-ctrab AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE qtd-capac-ctrab AS DECIMAL FORMAT ">,>>>,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE qtd-carga-batch AS DECIMAL FORMAT ">,>>>,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE qtd-lead-time AS DECIMAL FORMAT ">>,>>9.99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88 BY 4.88.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88 BY 2.58.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88 BY 1.38.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88 BY 2.38.

DEFINE VARIABLE log-crp AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 20.43 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     grup-maquina.gm-codigo AT ROW 1.71 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13.14 BY .88
     grup-maquina.cd-calen AT ROW 4.17 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13.14 BY .88
     num-maquinas AT ROW 5.21 COL 20 COLON-ALIGNED
     log-crp AT ROW 6.29 COL 22
     cb-ind-tempo-operac AT ROW 7.29 COL 20 COLON-ALIGNED
     qtd-carga-batch AT ROW 5.29 COL 58 COLON-ALIGNED
     qtd-capac-ctrab AT ROW 6.38 COL 58 COLON-ALIGNED
     cod-unid-capac AT ROW 7.46 COL 58 COLON-ALIGNED
     cb-log-overlap AT ROW 8.92 COL 20 COLON-ALIGNED
     cb-log-minimiza-tempo AT ROW 10.08 COL 20 COLON-ALIGNED
     qtd-lead-time AT ROW 8.92 COL 58 COLON-ALIGNED
     num-operador-ctrab AT ROW 11.63 COL 20 COLON-ALIGNED
     num-operac-simult AT ROW 11.63 COL 64 RIGHT-ALIGNED
     grup-maquina.descricao AT ROW 1.71 COL 34 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 33.14 BY .88
     c-desc-calen AT ROW 4.17 COL 34 COLON-ALIGNED NO-LABEL
     c-desc-capac AT ROW 7.46 COL 63.57 COLON-ALIGNED NO-LABEL
     RECT-1 AT ROW 3.67 COL 1
     RECT-2 AT ROW 8.71 COL 1
     RECT-3 AT ROW 11.42 COL 1
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.grup-maquina
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
         HEIGHT             = 11.79
         WIDTH              = 88.29.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-calen IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-capac IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-desc-capac:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR COMBO-BOX cb-ind-tempo-operac IN FRAME f-main
   NO-ENABLE 2                                                          */
ASSIGN 
       cb-ind-tempo-operac:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR COMBO-BOX cb-log-minimiza-tempo IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR COMBO-BOX cb-log-overlap IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN grup-maquina.cd-calen IN FRAME f-main
   2 3                                                                  */
/* SETTINGS FOR FILL-IN cod-unid-capac IN FRAME f-main
   NO-ENABLE 2                                                          */
ASSIGN 
       cod-unid-capac:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN grup-maquina.descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN grup-maquina.gm-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX log-crp IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN num-maquinas IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN num-operac-simult IN FRAME f-main
   NO-ENABLE ALIGN-R 2                                                  */
ASSIGN 
       num-operac-simult:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN num-operador-ctrab IN FRAME f-main
   NO-ENABLE 2                                                          */
ASSIGN 
       num-operador-ctrab:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN qtd-capac-ctrab IN FRAME f-main
   NO-ENABLE 2                                                          */
ASSIGN 
       qtd-capac-ctrab:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN qtd-carga-batch IN FRAME f-main
   NO-ENABLE 2                                                          */
ASSIGN 
       qtd-carga-batch:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN qtd-lead-time IN FRAME f-main
   NO-ENABLE 2                                                          */
ASSIGN 
       qtd-lead-time:HIDDEN IN FRAME f-main           = TRUE.

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




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME grup-maquina.cd-calen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL grup-maquina.cd-calen V-table-Win
ON F5 OF grup-maquina.cd-calen IN FRAME f-main /* Calend rio */
DO:
    assign l-implanta = yes.
    {include/zoomvar.i &prog-zoom="inzoom/z01in026.w"
                       &campo=grup-maquina.cd-calen
                       &campozoom=cd-calen
                       &campo2=c-desc-calen
                       &campozoom2=descricao}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL grup-maquina.cd-calen V-table-Win
ON LEAVE OF grup-maquina.cd-calen IN FRAME f-main /* Calend rio */
DO:
    {include/leave.i &tabela=calen-gener
                     &atributo-ref=descricao
                     &variavel-ref=c-desc-calen
                     &where="calen-gener.cd-calen = input frame {&frame-name} grup-maquina.cd-calen"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL grup-maquina.cd-calen V-table-Win
ON MOUSE-SELECT-DBLCLICK OF grup-maquina.cd-calen IN FRAME f-main /* Calend rio */
DO:
    apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cod-unid-capac
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-unid-capac V-table-Win
ON F5 OF cod-unid-capac IN FRAME f-main
DO:
    &if defined (bf_man_sfc_lc) &then    
        assign l-implanta = yes.
        {include/zoomvar.i &prog-zoom="inzoom/z01in460.w"
                           &campo=cod-unid-capac
                           &campozoom=cod-unid-capac
                           &campo2=c-desc-capac
                           &campozoom2=des-unid-capac}  
   &endif
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-unid-capac V-table-Win
ON LEAVE OF cod-unid-capac IN FRAME f-main
DO:
    &if defined (bf_man_sfc_lc) &then  
        {include/leave.i &tabela=unid-capac
                         &atributo-ref=des-unid-capac
                         &variavel-ref=c-desc-capac
                         &where="unid-capac.cod-unid-capac = input frame {&frame-name} cod-unid-capac"}
   &endif
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-unid-capac V-table-Win
ON MOUSE-SELECT-DBLCLICK OF cod-unid-capac IN FRAME f-main
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

if grup-maquina.cd-calen:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
if cod-unid-capac:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.


&IF DEFINED (bf_man_sfc_lc) &THEN
    {utp/ut-liter.i Capacidade_Total * R}
    assign qtd-capac-ctrab:label in frame {&frame-name} = trim(return-value).
    
    {utp/ut-field.i mgind grup-maquina cod-unid-capac 01}
    assign cod-unid-capac:label in frame {&frame-name} = return-value.

    {utp/ut-field.i mgind grup-maquina num-operador-ctrab 01}
    assign num-operador-ctrab:label in frame {&frame-name} = return-value.

    {utp/ut-field.i mgind grup-maquina num-operac-simult 01}
    assign num-operac-simult:label in frame {&frame-name} = return-value.

    {utp/ut-field.i mgind grup-maquina ind-tempo-operac 01}
    assign cb-ind-tempo-operac:label in frame {&frame-name} = return-value.

    {utp/ut-field.i mgind grup-maquina qtd-carga-batch 01}
    assign qtd-carga-batch:label in frame {&frame-name} = return-value.

    {utp/ut-field.i mgind grup-maquina qtd-lead-time 01}
    assign qtd-lead-time:label in frame {&frame-name} = return-value.
&ENDIF

{utp/ut-field.i mgind grup-maq-ext log-crp 01}
assign log-crp:label in frame {&frame-name} = return-value.

{utp/ut-liter.i Nro_Processadores * R}
assign num-maquinas:label in frame {&frame-name} = trim(return-value).

{utp/ut-field.i mgind grup-maq-ext log-overlap 01}
assign cb-log-overlap:label in frame {&frame-name} = return-value.

{utp/ut-field.i mgind grup-maq-ext log-minimiza-tempo 01}
assign cb-log-minimiza-tempo:label in frame {&frame-name} = return-value.

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
  {src/adm/template/row-list.i "grup-maquina"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "grup-maquina"}

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
    /*{include/i-valid.i}*/
    if  not frame {&frame-name}:validate() then
        return 'ADM-ERROR':U.

    &IF DEFINED (bf_man_sfc_lc) &THEN
        do with frame {&frame-name}:
            assign cb-ind-tempo-operac
                   cb-log-overlap
                   cb-log-minimiza-tempo.
        end. 
    &ENDIF
      
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.
    
    &IF DEFINED (bf_man_sfc_lc) &THEN
        assign grup-maquina.cd-calen           = input frame {&frame-name} grup-maquina.cd-calen
               grup-maquina.qtd-capac-ctrab    = input frame {&frame-name} qtd-capac-ctrab
               grup-maquina.cod-unid-capac     = input frame {&frame-name} cod-unid-capac
               grup-maquina.log-crp            = input frame {&frame-name} log-crp
               grup-maquina.num-maquinas       = input frame {&frame-name} num-maquinas
               grup-maquina.log-overlap        = if input frame {&frame-name} cb-log-overlap = c-overlap1
                                                 then yes
                                                 else no
               grup-maquina.log-minimiza-tempo = if input frame {&frame-name} cb-log-minimiza-tempo = c-minimiza1
                                                 then yes
                                                 else no
               grup-maquina.num-operador-ctrab = input frame {&frame-name} num-operador-ctrab
               grup-maquina.num-operac-simult  = input frame {&frame-name} num-operac-simult
               grup-maquina.qtd-carga-batch    = input frame {&frame-name} qtd-carga-batch
               grup-maquina.qtd-lead-time      = input frame {&frame-name} qtd-lead-time
               grup-maquina.ind-tempo-operac   = {ininc/i06in144.i 06 cb-ind-tempo-operac}.
    &ELSE
        find first grup-maq-ext
             where grup-maq-ext.gm-codigo = grup-maquina.gm-codigo exclusive-lock no-error.
        if avail grup-maq-ext then
            assign grup-maq-ext.log-crp            = input frame {&frame-name} log-crp
                   grup-maq-ext.num-maquinas       = input frame {&frame-name} num-maquinas
                   grup-maq-ext.log-overlap        = if input frame {&frame-name} cb-log-overlap = c-overlap1
                                                     then yes
                                                     else no
                   grup-maq-ext.log-minimiza-tempo = if input frame {&frame-name} cb-log-minimiza-tempo = c-minimiza1
                                                     then yes
                                                     else no.
        else do:
            create grup-maq-ext.
            buffer-copy grup-maquina to grup-maq-ext
            assign grup-maq-ext.log-crp            = input frame {&frame-name} log-crp
                   grup-maq-ext.num-maquinas       = input frame {&frame-name} num-maquinas
                   grup-maq-ext.log-overlap        = if input frame {&frame-name} cb-log-overlap = c-overlap1
                                                     then yes
                                                     else no
                   grup-maq-ext.log-minimiza-tempo = if input frame {&frame-name} cb-log-minimiza-tempo = c-minimiza1
                                                     then yes
                                                     else no.                   
        end.
    &ENDIF    

    if c-prog-chama = "pc0109" then do:
        RUN Who-Is-The-Container IN adm-broker-hdl
            (INPUT this-procedure,
             OUTPUT h_handle).    
        run pi-habilita-bt in h_handle(input yes).    
    end.
        
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
    
    &IF DEFINED (bf_man_sfc_lc) &THEN
        assign qtd-capac-ctrab:sensitive in frame {&frame-name}     = no
               cod-unid-capac:sensitive in frame {&frame-name}      = no
               num-operador-ctrab:sensitive in frame {&frame-name}  = no
               num-operac-simult:sensitive in frame {&frame-name}   = no
               qtd-carga-batch:sensitive in frame {&frame-name}     = no
               qtd-lead-time:sensitive in frame {&frame-name}       = no  
               cb-ind-tempo-operac:sensitive in frame {&frame-name} = no.         
    &ENDIF    
    
    if c-prog-chama = "pc0109" then do:
        RUN Who-Is-The-Container IN adm-broker-hdl
            (INPUT this-procedure,
             OUTPUT h_handle).     
        run pi-habilita-bt in h_handle(input yes).
    end.
    
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

    if avail grup-maquina then do:
        find first calen-gener
             where calen-gener.cd-calen = grup-maquina.cd-calen no-lock no-error.
        assign c-desc-calen = if avail calen-gener then calen-gener.descricao
                              else "":U.
    end.
                                
    &IF DEFINED (bf_man_sfc_lc) &THEN
        if avail grup-maquina then do:
            assign qtd-capac-ctrab     = grup-maquina.qtd-capac-ctrab
                   cod-unid-capac      = grup-maquina.cod-unid-capac
                   log-crp             = grup-maquina.log-crp
                   num-maquinas        = grup-maquina.num-maquinas
                   cb-log-overlap      = if grup-maquina.log-overlap 
                                         then c-overlap1
                                         else c-overlap2
                   cb-log-minimiza-tempo = if grup-maquina.log-minimiza-tempo
                                         then c-minimiza1
                                         else c-minimiza2                                
                   num-operador-ctrab  = grup-maquina.num-operador-ctrab
                   num-operac-simult   = grup-maquina.num-operac-simult
                   qtd-carga-batch     = grup-maquina.qtd-carga-batch
                   qtd-lead-time       = grup-maquina.qtd-lead-time.       
                   cb-ind-tempo-operac = {ininc/i06in144.i 04 grup-maquina.ind-tempo-operac}.
            find first unid-capac
                 where unid-capac.cod-unid-capac = grup-maquina.cod-unid-capac no-lock no-error.
            assign c-desc-capac = if avail unid-capac then unid-capac.des-unid-capac
                                  else "":U.                   
        end.
        else
            assign cb-ind-tempo-operac = {ininc/i06in144.i 04 1}.
            
        assign qtd-capac-ctrab:hidden in frame {&frame-name}     = no
               cod-unid-capac:hidden in frame {&frame-name}      = no
               num-operador-ctrab:hidden in frame {&frame-name}  = no
               num-operac-simult:hidden in frame {&frame-name}   = no
               qtd-carga-batch:hidden in frame {&frame-name}     = no
               qtd-lead-time:hidden in frame {&frame-name}       = no  
               cb-ind-tempo-operac:hidden in frame {&frame-name} = no
               c-desc-capac:hidden in frame {&frame-name}        = no.
    &ELSE
        if avail grup-maquina then do:
            find first grup-maq-ext
                 where grup-maq-ext.gm-codigo = grup-maquina.gm-codigo no-lock no-error.
            if avail grup-maq-ext then
                assign log-crp            = grup-maq-ext.log-crp
                       num-maquinas       = grup-maq-ext.num-maquinas
                       cb-log-overlap     = if grup-maq-ext.log-overlap 
                                            then c-overlap1
                                            else c-overlap2
                       cb-log-minimiza-tempo = if grup-maq-ext.log-minimiza-tempo
                                               then c-minimiza1
                                               else c-minimiza2.
            else
                assign log-crp               = yes
                       num-maquinas          = 1
                       cb-log-overlap        = c-overlap1
                       cb-log-minimiza-tempo = c-minimiza1.            
       end.
    &ENDIF  
    
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

    if c-prog-chama = "pc0109" then do:
        RUN Who-Is-The-Container IN adm-broker-hdl
            (INPUT this-procedure,
             OUTPUT h_handle).     
        run pi-habilita-bt in h_handle(input adm-new-record).
    end.

    &IF DEFINED (bf_man_sfc_lc) &THEN
        assign qtd-capac-ctrab:sensitive in frame {&frame-name}     = yes
               cod-unid-capac:sensitive in frame {&frame-name}      = yes
               num-operador-ctrab:sensitive in frame {&frame-name}  = yes
               num-operac-simult:sensitive in frame {&frame-name}   = yes
               qtd-carga-batch:sensitive in frame {&frame-name}     = yes
               qtd-lead-time:sensitive in frame {&frame-name}       = yes  
               cb-ind-tempo-operac:sensitive in frame {&frame-name} = yes.     
               
        if avail grup-maquina then do:
            if can-find(first ctrab
                        where ctrab.gm-codigo = grup-maquina.gm-codigo) then
                assign num-maquinas:sensitive in frame {&frame-name}    = no
                       qtd-capac-ctrab:sensitive in frame {&frame-name} = no.
            else
                assign num-maquinas:sensitive in frame {&frame-name}    = yes
                       qtd-capac-ctrab:sensitive in frame {&frame-name} = yes.     
        end.       
    &ELSE
        assign qtd-capac-ctrab:sensitive in frame {&frame-name}     = no
               qtd-capac-ctrab:hidden in frame {&frame-name}        = yes
               cod-unid-capac:sensitive in frame {&frame-name}      = no
               cod-unid-capac:hidden in frame {&frame-name}         = yes
               num-operador-ctrab:sensitive in frame {&frame-name}  = no
               num-operador-ctrab:hidden in frame {&frame-name}     = yes
               num-operac-simult:sensitive in frame {&frame-name}   = no
               num-operac-simult:hidden in frame {&frame-name}      = yes
               qtd-carga-batch:sensitive in frame {&frame-name}     = no
               qtd-carga-batch:hidden in frame {&frame-name}        = yes
               qtd-lead-time:sensitive in frame {&frame-name}       = no 
               qtd-lead-time:hidden in frame {&frame-name}          = yes
               cb-ind-tempo-operac:sensitive in frame {&frame-name} = no
               cb-ind-tempo-operac:hidden in frame {&frame-name}    = yes.
    &ENDIF
    
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
  
 
  assign c-lista = "".
  {utp/ut-liter.i Percentual * R}
  assign c-lista    = trim(return-value) + ","
         c-overlap1 = trim(return-value).
  {utp/ut-liter.i Quantidade * R}
  assign c-lista    = c-lista + trim(return-value)
         c-overlap2 = trim(return-value)
         cb-log-overlap:list-items  in frame {&frame-name} = c-lista.
  
  assign c-lista = "".
  {utp/ut-liter.i Setup * R}
  assign c-lista     = trim(return-value) + ","
         c-minimiza1 = trim(return-value).
  {utp/ut-liter.i Processo * R}
  assign c-lista     = c-lista + trim(return-value)
         c-minimiza2 = trim(return-value)
         cb-log-minimiza-tempo:list-items  in frame {&frame-name} = c-lista.  

  &IF DEFINED (bf_man_sfc_lc) &THEN
      assign cb-ind-tempo-operac:list-items  in frame {&frame-name}  = {ininc/i06in144.i 03}.
  &ENDIF
  
  assign grup-maquina.cd-calen:sensitive in frame {&frame-name}  = no.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

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

  if avail grup-maquina then
     assign gr-grup-maquina = rowid(grup-maquina).
     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-parent V-table-Win 
PROCEDURE pi-atualiza-parent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter v-row-parent-externo as rowid no-undo.
    
    assign v-row-parent = v-row-parent-externo.
    
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
    
/*/*    Segue um exemplo de valida‡Æo de programa */
 *     find tabela where tabela.campo1 = c-variavel and
 *                       tabela.campo2 > i-variavel no-lock no-error.
 *     
 *     /* Este include deve ser colocado sempre antes do ut-msgs.p */
 *     {include/i-vldprg.i}
 *     run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *     return 'ADM-ERROR':U.*/

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
  {src/adm/template/snd-list.i "grup-maquina"}

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


