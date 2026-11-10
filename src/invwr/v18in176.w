&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          movind           PROGRESS
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
{include/i-prgvrs.i V18IN176 2.00.00.023}  /*** 010023 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V18IN176 MUT}
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
 
/* Parameters Definitions ---                                           */
 
/* Local Variable Definitions ---                                       */
 
    def var v-row-parent      as rowid                        no-undo.
    def var c-it-codigo       as char                         no-undo.
    def var l-frete           as logical                      no-undo.
    def var de-vl-ipi-outras  like item-doc-est.ipi-outras[1] no-undo.
    def var de-calculado      as dec                          no-undo.
    def var de-informado      as dec                          no-undo.
 
    def new global shared var gr-docum-est  as rowid no-undo.
    def new global shared var i-programa-re as integer no-undo.
    /**
    ***  Recebimento     1 - Normal
    ***                  2 - F°sico
    ***                  3 - Internacional
    **/
 
    def buffer b-unid-estabel for unid-feder.
    def buffer b-unid-emit    for unid-feder.
    def buffer b-emit-estab   for emitente.
 
    {rep/re9800.i}
    {cdp/cd4305.i1}
    {rep/re1907.i02}
    {rep/re1907.i03}
 
    def buffer b-tt-docto    for tt-docto.
    def buffer b-tt-it-docto for tt-it-docto.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES item-doc-est
&Scoped-define FIRST-EXTERNAL-TABLE item-doc-est


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR item-doc-est.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS item-doc-est.class-fiscal ~
item-doc-est.aliquota-ipi item-doc-est.ipi-ntrib[1] ~
item-doc-est.ipi-outras[1] item-doc-est.base-ipi[1] ~
item-doc-est.valor-ipi[1] item-doc-est.aliquota-icm item-doc-est.log-2 ~
item-doc-est.aliquota-iss 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}class-fiscal ~{&FP2}class-fiscal ~{&FP3}~
 ~{&FP1}aliquota-ipi ~{&FP2}aliquota-ipi ~{&FP3}~
 ~{&FP1}ipi-ntrib[1] ~{&FP2}ipi-ntrib[1] ~{&FP3}~
 ~{&FP1}ipi-outras[1] ~{&FP2}ipi-outras[1] ~{&FP3}~
 ~{&FP1}base-ipi[1] ~{&FP2}base-ipi[1] ~{&FP3}~
 ~{&FP1}valor-ipi[1] ~{&FP2}valor-ipi[1] ~{&FP3}~
 ~{&FP1}aliquota-icm ~{&FP2}aliquota-icm ~{&FP3}~
 ~{&FP1}aliquota-iss ~{&FP2}aliquota-iss ~{&FP3}
&Scoped-define ENABLED-TABLES item-doc-est
&Scoped-define FIRST-ENABLED-TABLE item-doc-est
&Scoped-Define ENABLED-OBJECTS rt-key rt-key-2 rt-key-4 rt-mold-6 
&Scoped-Define DISPLAYED-FIELDS item-doc-est.class-fiscal ~
item-doc-est.aliquota-ipi item-doc-est.ipi-ntrib[1] ~
item-doc-est.ipi-outras[1] item-doc-est.base-ipi[1] ~
item-doc-est.valor-ipi[1] item-doc-est.aliquota-icm item-doc-est.log-2 ~
item-doc-est.aliquota-iss 
&Scoped-Define DISPLAYED-OBJECTS c-desc-class-fiscal cd-trib-ipi ~
cd-trib-icm perc-red-icm cd-trib-iss 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-MODIFY-FIELDS cd-trib-ipi cd-trib-icm cd-trib-iss 

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
DEFINE VARIABLE cd-trib-icm AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tributaá∆o ICMS" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     SIZE 21.14 BY 1 NO-UNDO.

DEFINE VARIABLE cd-trib-ipi AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tributaá∆o IPI" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     SIZE 21.14 BY 1 NO-UNDO.

DEFINE VARIABLE cd-trib-iss AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tributaá∆o ISS" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     SIZE 21.14 BY 1 NO-UNDO.

DEFINE VARIABLE c-desc-class-fiscal AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50.29 BY .88 NO-UNDO.

DEFINE VARIABLE perc-red-icm AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "Perc Red ICMS":R16 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 41.72 BY 4.67.

DEFINE RECTANGLE rt-key-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 41.72 BY 2.67.

DEFINE RECTANGLE rt-key-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 44 BY 7.5.

DEFINE RECTANGLE rt-mold-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 86.29 BY 1.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     item-doc-est.class-fiscal AT ROW 1.33 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     c-desc-class-fiscal AT ROW 1.33 COL 33.86 COLON-ALIGNED NO-LABEL
     cd-trib-ipi AT ROW 3.33 COL 20.72 COLON-ALIGNED
     item-doc-est.aliquota-ipi AT ROW 4.5 COL 20.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     item-doc-est.ipi-ntrib[1] AT ROW 5.5 COL 20.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     item-doc-est.ipi-outras[1] AT ROW 6.5 COL 20.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     item-doc-est.base-ipi[1] AT ROW 7.5 COL 20.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     item-doc-est.valor-ipi[1] AT ROW 8.5 COL 20.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     cd-trib-icm AT ROW 3 COL 63 COLON-ALIGNED
     item-doc-est.aliquota-icm AT ROW 4.17 COL 63 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     perc-red-icm AT ROW 5.17 COL 63 COLON-ALIGNED
     item-doc-est.log-2 AT ROW 6.17 COL 65
          VIEW-AS TOGGLE-BOX
          SIZE 16.72 BY .83
     cd-trib-iss AT ROW 7.83 COL 63 COLON-ALIGNED
     item-doc-est.aliquota-iss AT ROW 9 COL 63 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     rt-key AT ROW 2.67 COL 45.57
     rt-key-2 AT ROW 7.5 COL 45.57
     rt-key-4 AT ROW 2.67 COL 1
     rt-mold-6 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.item-doc-est
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
         HEIGHT             = 9.17
         WIDTH              = 86.43.
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

/* SETTINGS FOR FILL-IN c-desc-class-fiscal IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cd-trib-icm IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR COMBO-BOX cd-trib-ipi IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR COMBO-BOX cd-trib-iss IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN perc-red-icm IN FRAME f-main
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */
 
{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME item-doc-est.aliquota-icm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.aliquota-icm V-table-Win
ON LEAVE OF item-doc-est.aliquota-icm IN FRAME f-main /* Aliquota ICMS */
DO:
 
    assign tt-it-imposto.aliquota-icm = input frame {&frame-name} item-doc-est.aliquota-icm.
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-doc-est.aliquota-ipi
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.aliquota-ipi V-table-Win
ON ENTRY OF item-doc-est.aliquota-ipi IN FRAME f-main /* Aliquota IPI */
DO:
    assign item-doc-est.aliquota-ipi:modified in frame {&FRAME-NAME} = no.
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.aliquota-ipi V-table-Win
ON LEAVE OF item-doc-est.aliquota-ipi IN FRAME f-main /* Aliquota IPI */
DO:
 
    assign tt-it-imposto.aliquota-ipi = input frame {&frame-name} item-doc-est.aliquota-ipi.
    assign tt-it-imposto.perc-red-ipi = natur-oper.perc-red-ipi.  
    if  item-doc-est.aliquota-ipi:modified in frame {&FRAME-NAME} then do:     
        run pi-calc-ipi (input ?,
                         input ?,
                         input ?,
                         input ?).
        if  input frame {&frame-name} item-doc-est.aliquota-ipi = 0 then 
            assign tt-it-imposto.cd-trib-ipi = {ininc/i10in172.i 06 cd-trib-ipi}.
    end.        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-doc-est.aliquota-iss
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.aliquota-iss V-table-Win
ON LEAVE OF item-doc-est.aliquota-iss IN FRAME f-main /* Aliquota ISS */
DO:
    assign tt-it-imposto.aliquota-iss = input frame {&frame-name} item-doc-est.aliquota-iss.
    run pi-calcula-iss.
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cd-trib-icm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cd-trib-icm V-table-Win
ON VALUE-CHANGED OF cd-trib-icm IN FRAME f-main /* Tributaá∆o ICMS */
DO:
 
    assign input frame {&frame-name} cd-trib-icm.
    assign tt-it-imposto.cd-trib-icm = {ininc/i07in122.i 06 cd-trib-icm}.
 
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cd-trib-ipi
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cd-trib-ipi V-table-Win
ON ENTRY OF cd-trib-ipi IN FRAME f-main /* Tributaá∆o IPI */
DO:
    assign cd-trib-ipi:modified in frame {&FRAME-NAME} = no.
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cd-trib-ipi V-table-Win
ON LEAVE OF cd-trib-ipi IN FRAME f-main /* Tributaá∆o IPI */
DO:
 
    assign input frame {&frame-name} cd-trib-ipi.
    assign tt-it-imposto.cd-trib-ipi = {ininc/i10in172.i 06 cd-trib-ipi}.
    if  cd-trib-ipi:modified in frame {&FRAME-NAME} then do:
        run pi-calc-ipi (input ?,
                         input ?,
                         input ?,
                         input ?).
        assign tt-it-imposto.cd-trib-ipi = {ininc/i10in172.i 06 cd-trib-ipi}.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cd-trib-iss
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cd-trib-iss V-table-Win
ON VALUE-CHANGED OF cd-trib-iss IN FRAME f-main /* Tributaá∆o ISS */
DO:
 
    assign input frame {&frame-name} cd-trib-iss.
    assign tt-it-imposto.cd-trib-iss = {ininc/i11in172.i 06 cd-trib-iss}.
    run pi-calcula-iss.
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-doc-est.class-fiscal
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.class-fiscal V-table-Win
ON F5 OF item-doc-est.class-fiscal IN FRAME f-main /* Classificaá∆o Fiscal */
DO:
    assign l-implanta = yes.
    {include/zoomvar.i &prog-zoom=inzoom/z01in046.w
                       &campo=item-doc-est.class-fiscal
                       &campozoom=class-fiscal}
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.class-fiscal V-table-Win
ON LEAVE OF item-doc-est.class-fiscal IN FRAME f-main /* Classificaá∆o Fiscal */
DO:
 
    {include/leave.i &tabela=classif-fisc
                     &atributo-ref=descricao
                     &variavel-ref=c-desc-class-fiscal
                     &where="classif-fisc.class-fiscal = input frame {&frame-name}
                             item-doc-est.class-fiscal"}
 
    if  adm-new-record 
        and item-doc-est.class-fiscal:modified in frame {&FRAME-NAME} then do:
        /* Determina Aliquota IPI */
        if  param-re.orig-aliq-ip  = 1
            and avail classif-fisc  then 
            assign tt-it-imposto.aliquota-ipi = classif-fisc.aliquota-ipi.
        else 
            assign tt-it-imposto.aliquota-ipi = item.aliquota-ipi.
        assign item-doc-est.aliquota-ipi:screen-value in frame {&frame-name} =
                                                string(tt-it-imposto.aliquota-ipi).
 
        run pi-calc-ipi (input ?,
                         input ?,
                         input ?,
                         input ?).  
    end. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.class-fiscal V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item-doc-est.class-fiscal IN FRAME f-main /* Classificaá∆o Fiscal */
DO:
          apply "F5" to self.
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-doc-est.log-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.log-2 V-table-Win
ON VALUE-CHANGED OF item-doc-est.log-2 IN FRAME f-main /* log-2 */
DO:
 
    assign tt-it-imposto.ind-icm-ret = input frame {&frame-name} item-doc-est.log-2.  
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME perc-red-icm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL perc-red-icm V-table-Win
ON LEAVE OF perc-red-icm IN FRAME f-main /* Perc Red ICMS */
DO:
 
    assign tt-it-imposto.perc-red-icm = input frame {&frame-name} perc-red-icm.  
 
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
 
    do with frame {&frame-name}:
        {utp/ut-liter.i Tributaá∆o_IPI * L}
        assign cd-trib-ipi:label = return-value.
        {utp/ut-liter.i Base_IPI_Isento * L}
        assign item-doc-est.ipi-ntrib[1]:label = return-value.
        {utp/ut-liter.i Base_IPI_Outros * L}
        assign item-doc-est.ipi-outras[1]:label = return-value.    
        {utp/ut-liter.i Base_IPI_Trib. * L}
        assign item-doc-est.base-ipi[1]:label = return-value.    
        {utp/ut-liter.i Valor_IPI * L}
        assign item-doc-est.valor-ipi[1]:label = return-value.    
        {utp/ut-liter.i Tributaá∆o_ICMS * L}
        assign cd-trib-icm:label in frame {&frame-name} = return-value.    
        {utp/ut-liter.i ICMS_Retido * L}
        assign item-doc-est.log-2:label = return-value.    
        {utp/ut-liter.i Tributaá∆o_ISS * L}
        assign cd-trib-iss:label = return-value.
        {utp/ut-liter.i Perc._Reduá∆o * L}
        assign perc-red-icm:label = return-value.    
    end.
 
    if item-doc-est.class-fiscal:load-mouse-pointer("image/lupa.cur")
        in frame {&frame-name} then .
 
     find param-re where
          param-re.usuario = c-seg-usuario
            no-lock no-error.        
     find first param-global
            no-lock no-error.
     find first param-compra
            no-lock no-error.        
 
     find docum-est where
        rowid(docum-est) = gr-docum-est
        no-lock no-error.
    if avail docum-est then do:
        find emitente where
            emitente.cod-emitente = docum-est.cod-emitente
            no-lock no-error.
        find natur-oper where
            natur-oper.nat-operacao = docum-est.nat-operacao
            no-lock no-error.
        find estabelec where
            estabelec.cod-estabel = docum-est.cod-estabel
            no-lock no-error.
        find b-emit-estab where
            b-emit-estab.cod-emitente = estabelec.cod-emitente 
            no-lock no-error.
        find b-unid-emit where
            b-unid-emit.pais   = emitente.pais    and 
            b-unid-emit.estado = emitente.estado
            no-lock no-error.
        find b-unid-estabel where
            b-unid-estabel.pais   = estabelec.pais  and 
            b-unid-estabel.estado = estabelec.estado
            no-lock no-error.
        run pi-seta-flags-observacao (docum-est.cod-observa, 
                                      docum-est.nat-operacao).
    end.

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
  {src/adm/template/row-list.i "item-doc-est"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "item-doc-est"}

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
 
  /* Code placed here will execute PRIOR to standard behavior. */
 
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .
 
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
   assign input frame {&frame-name} cd-trib-ipi
           input frame {&frame-name} cd-trib-icm
           input frame {&frame-name} cd-trib-iss.
 
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  if RETURN-VALUE = 'ADM-ERROR':U then 
      return 'ADM-ERROR':U.
 
    assign item-doc-est.cd-trib-ipi = {ininc/i10in172.i 06 cd-trib-ipi}
           item-doc-est.cd-trib-iss = {ininc/i11in172.i 06 cd-trib-iss}
           item-doc-est.cd-trib-icm = {ininc/i07in122.i 06 cd-trib-icm}.
 
    if  item-doc-est.cd-trib-ipi = 0 then 
        assign item-doc-est.cd-trib-ipi = 2.
    if  item-doc-est.cd-trib-icm = 0 then 
        assign item-doc-est.cd-trib-icm = 2.
    if  item-doc-est.cd-trib-iss = 0 then 
        assign item-doc-est.cd-trib-iss = 2.
 
    find first tt-docto no-error.
    if available tt-docto then
        delete tt-docto.        
    find first tt-it-docto no-error.
    if available tt-it-docto then        
        delete tt-it-docto.        
 
    find first tt-it-imposto no-error.
 
    if  available tt-it-imposto then do:
        assign item-doc-est.base-iss    = tt-it-imposto.vl-biss-it
               item-doc-est.iss-ntrib   = tt-it-imposto.vl-issnt-it
               item-doc-est.iss-outras  = tt-it-imposto.vl-issou-it
               item-doc-est.valor-iss   = tt-it-imposto.vl-iss-it.
 
        if  ( l-comercio or natur-oper.perc-red-ipi > 0 )
        and ( tt-it-imposto.cd-trib-ipi = 3 and tt-it-imposto.aliquota-ipi > 0 ) then
            assign item-doc-est.ipi-outras[2] = tt-it-imposto.vl-ipi-outras.       
 
        delete tt-it-imposto.
    end.        
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-cancel-record V-table-Win 
PROCEDURE local-cancel-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
 
  /* Code placed here will execute PRIOR to standard behavior. */
 
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .
 
 
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
 
    find first tt-docto no-error.
    if available tt-docto then
        delete tt-docto.        
    find first tt-it-docto no-error.
    if available tt-it-docto then        
        delete tt-it-docto.        
    find first tt-it-imposto no-error.
    if available tt-it-imposto then        
        delete tt-it-imposto.
 
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
 
    if available item-doc-est then do with frame {&frame-name}:
        assign cd-trib-ipi:screen-value = {ininc/i10in172.i 04 item-doc-est.cd-trib-ipi}.
        assign cd-trib-iss:screen-value = {ininc/i11in172.i 04 item-doc-est.cd-trib-iss}.
        assign cd-trib-icm:screen-value = {ininc/i07in122.i 04 item-doc-est.cd-trib-icm}.
    end.
    else do:
        assign cd-trib-ipi:screen-value = {ininc/i10in172.i 04 01}.
        assign cd-trib-iss:screen-value = {ininc/i11in172.i 04 01}.
        assign cd-trib-icm:screen-value = {ininc/i07in122.i 04 01}.
    end.
 
    find classif-fisc where
        classif-fisc.class-fiscal = input frame {&frame-name} item-doc-est.class-fiscal
        no-lock no-error.
    if available classif-fisc then
        assign c-desc-class-fiscal:screen-value in frame {&frame-name} = classif-fisc.descricao.
    else
        assign c-desc-class-fiscal:screen-value in frame {&frame-name} = "".
    if avail item-doc-est then do:
       find first natur-oper where
                  natur-oper.nat-operacao = item-doc-est.nat-oper no-lock no-error.
 
       perc-red-icm:screen-value in frame {&frame-name} = string(natur-oper.perc-red-icm).
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
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .
 
  /* Code placed here will execute AFTER standard behavior.    */
 
  /*if adm-new-record = yes then*/
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
 
  disable item-doc-est.ipi-ntrib[1] 
          item-doc-est.ipi-outras[1]
          item-doc-est.base-ipi[1] 
          item-doc-est.valor-ipi[1] with frame {&frame-name}.        
 
  if  l-servicos then 
      disable item-doc-est.class-fiscal
              cd-trib-ipi
              item-doc-est.aliquota-ipi 
              cd-trib-icm
              item-doc-est.aliquota-icm
              item-doc-est.log-2 with frame {&frame-name}.
  else 
      disable cd-trib-iss
              item-doc-est.aliquota-iss with frame {&frame-name}.
 
 
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
 
    do with frame {&frame-name}:
        assign cd-trib-ipi:list-items = {ininc/i10in172.i 03}.
        assign cd-trib-icm:list-items = {ininc/i07in122.i 03}.
        assign cd-trib-iss:list-items = {ininc/i11in172.i 03}.
    end.
 
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
 
    do with frame {&frame-name}:
        {utp/ut-liter.i Tributaá∆o_IPI * L}
        assign cd-trib-ipi:label = return-value.
        {utp/ut-liter.i Base_IPI_Isento * L}
        assign item-doc-est.ipi-ntrib[1]:label = return-value.
        {utp/ut-liter.i Base_IPI_Outros * L}
        assign item-doc-est.ipi-outras[1]:label = return-value.    
        {utp/ut-liter.i Base_IPI_Trib. * L}
        assign item-doc-est.base-ipi[1]:label = return-value.    
        {utp/ut-liter.i Valor_IPI * L}
        assign item-doc-est.valor-ipi[1]:label = return-value.    
        {utp/ut-liter.i Tributaá∆o_ICMS * L}
        assign cd-trib-icm:label in frame {&frame-name} = return-value.    
        {utp/ut-liter.i ICMS_Retido * L}
        assign item-doc-est.log-2:label = return-value.    
        {utp/ut-liter.i Tributaá∆o_ISS * L}
        assign cd-trib-iss:label in frame {&frame-name} = return-value.
        {utp/ut-liter.i Perc._Reduá∆o * L}
        assign perc-red-icm:label = return-value.    
    end.
 
 
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-calc-ipi V-table-Win 
PROCEDURE pi-calc-ipi :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param de-vl-merc-ori as decimal no-undo.
    def input param de-desconto    as decimal no-undo.
    def input param de-despesas    as decimal no-undo.
    def input param de-frete       as decimal no-undo.
 
 
    if  de-desconto > 0 then
        assign tt-it-docto.per-des-item = 1.
 
    if  de-vl-merc-ori <> ? then 
        assign tt-it-docto.vl-merc-ori = de-vl-merc-ori
               tt-it-docto.vl-merc-liq = tt-it-docto.vl-merc-ori - de-desconto
               tt-it-docto.vl-seguro   = if  de-despesas >= de-frete 
                                         then de-despesas - de-frete
                                         else 0
               tt-it-docto.vl-frete    = de-frete.                
 
    if  not l-servicos then do:
        assign tt-it-imposto.perc-red-ipi = natur-oper.perc-red-ipi.
        run pi-calcula-ipi.
    end.
 
    find first tt-docto no-error.
    find first tt-it-docto no-error.
    find first tt-it-imposto no-error.
 
    if  not l-servicos then do:
 
        /* Quando a tributaá∆o de IPI Ç alterada de Outros para Isento, o campo IPI Outras  */
        /* da tt-it-imposto n∆o esta sendo zerado pelo programa de c†culo de IPI ( CD4306 ) */
 
        if  cd-trib-ipi:modified in frame {&frame-name}
        and input frame {&frame-name} cd-trib-ipi = "Isento" then
            assign tt-it-imposto.vl-ipi-outras = 0.
 
        if  l-comercio 
        and {ininc/i10in172.i 06 cd-trib-ipi} = 4 then
            assign tt-it-imposto.cd-trib-ipi = 1
                   cd-trib-ipi:screen-value in frame {&frame-name} = {ininc/i10in172.i 04 01}.        
 
        assign item-doc-est.aliquota-ipi:screen-value in frame {&frame-name} =
                                         string(tt-it-imposto.aliquota-ipi)
 
               item-doc-est.ipi-ntrib[1]:screen-value in frame {&frame-name} =
                                         string(tt-it-imposto.vl-ipint).
 
        if  ( l-comercio or natur-oper.perc-red-ipi > 0 )
        and ( tt-it-imposto.cd-trib-ipi = 3 and tt-it-imposto.aliquota-ipi > 0 ) then
            assign item-doc-est.ipi-outras[1]:screen-value in frame {&frame-name} = 
                                              string( tt-it-imposto.vl-ipiou - tt-it-imposto.vl-ipi-outras ).
        else 
            assign item-doc-est.ipi-outras[1]:screen-value in frame {&frame-name} = 
                                              string(tt-it-imposto.vl-ipiou).
 
        assign de-vl-ipi-outras = input frame {&frame-name} item-doc-est.ipi-outras[1]
               item-doc-est.base-ipi[1]:screen-value in frame {&frame-name} = string(tt-it-imposto.vl-bipi-it)
 
               item-doc-est.valor-ipi[1]:screen-value in frame {&frame-name} = string(tt-it-imposto.vl-ipi-it).
 
        if  param-re.ped-imp-nota then do:            
            if tt-it-imposto.vl-ipint <> 0 then
                enable item-doc-est.ipi-ntrib[1] with frame {&frame-name}.
            else
                disable item-doc-est.ipi-ntrib[1] with frame {&frame-name}.
 
            if tt-it-imposto.vl-ipiou <> 0 then
                enable item-doc-est.ipi-outras[1] with frame {&frame-name}.        
            else
                disable item-doc-est.ipi-outras[1] with frame {&frame-name}.        
 
            if tt-it-imposto.vl-bipi-it <> 0 then
                enable item-doc-est.base-ipi[1] with frame {&frame-name}.
            else
                disable item-doc-est.base-ipi[1] with frame {&frame-name}.
 
            if tt-it-imposto.vl-ipi-it <> 0 then
                enable item-doc-est.valor-ipi[1] with frame {&frame-name}.
            else
                disable item-doc-est.valor-ipi[1] with frame {&frame-name}.        
        end.
 
        run cdp/cd4315.p (input tt-it-docto.seq-tt-it-docto,
                          input b-unid-estabel.nr-tb-pauta,
                          input b-unid-emit.nr-tb-pauta,
                          input tt-it-docto.cod-refer,
                          input natur-oper.venda-ativo,
                          input (if available b-emit-estab then b-emit-estab.natureza else 2),
                          input table tt-docto,
                          input table tt-it-docto,
                          input-output table tt-it-imposto).        
 
        if  natur-oper.subs-trib 
        and l-frete then do:
            assign item-doc-est.log-2:checked in frame {&frame-name} = yes.
            find first tt-it-imposto no-error.
            assign tt-it-imposto.ind-icm-ret = yes.
       end.
 
    end.
    else do:                
        if  not adm-new-record 
        and avail item-doc-est then 
            assign tt-it-imposto.aliquota-iss = item-doc-est.aliquota-iss.
        else 
            assign tt-it-imposto.aliquota-iss = item.aliquota-iss.
 
        assign item-doc-est.aliquota-iss:screen-value in frame {&frame-name} =
                                                string(tt-it-imposto.aliquota-iss).
        run pi-calcula-iss.                                                
 
    end.
    find first tt-docto no-error.
    find first tt-it-docto no-error.
    find first tt-it-imposto no-error.
 
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-calcula-iss V-table-Win 
PROCEDURE pi-calcula-iss :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
    run cdp/cd4307.p (input tt-it-docto.seq-tt-it-docto,
                      input 1,
                      input yes,
                      input table tt-it-docto,
                      input-output table tt-it-imposto).      
 
    find first tt-it-docto no-error.
    find first tt-it-imposto no-error.
 
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-fisico V-table-Win 
PROCEDURE pi-fisico :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-imposto V-table-Win 
PROCEDURE pi-gera-imposto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
    find first tt-it-imposto no-error.
    if not available tt-it-imposto then do:
        /* Criaá∆o da tt-docto, tt-it-docto e tt-it-imposto */
        {rep/re1001.i08}
 
    end.
    find item where
        item.it-codigo = tt-it-docto.it-codigo
        no-lock no-error.
 
    if  l-servicos then do:
 
        if  not adm-new-record and avail item-doc-est then 
            assign tt-it-imposto.cd-trib-iss = item-doc-est.cd-trib-iss.
        else do:
 
            run cdp/cd4304.p (item.cd-trib-iss,
                              natur-oper.cd-trib-iss,
                              output tt-it-imposto.cd-trib-iss).
 
            if  tt-it-imposto.cd-trib-iss = 1 
            or  tt-it-imposto.cd-trib-iss = 4 then                  
                assign tt-it-imposto.cd-trib-iss = 3.
        end.
 
        assign tt-it-imposto.cd-trib-ipi = 2
               tt-it-imposto.cd-trib-icm = 2.
 
        assign cd-trib-ipi:screen-value in frame {&frame-name} = {ininc/i10in172.i 04 tt-it-imposto.cd-trib-ipi}.
        assign cd-trib-iss:screen-value in frame {&frame-name} = {ininc/i11in172.i 04 tt-it-imposto.cd-trib-iss}.
        assign cd-trib-icm:screen-value in frame {&frame-name} = {ininc/i07in122.i 04 tt-it-imposto.cd-trib-icm}.
    end.
    else do:
        if  adm-new-record then do:
            assign tt-it-docto.class-fiscal = item.class-fiscal.
 
            find classif-fisc 
                where classif-fisc.class-fiscal = tt-it-docto.class-fiscal
                no-lock no-error.
 
            run pi-tributa-ipi (output tt-it-imposto.cd-trib-ipi,
                                output tt-it-imposto.aliquota-ipi).
            run pi-tributa-icm (input c-it-codigo,
                                output tt-it-imposto.cd-trib-icm,
                                output tt-it-imposto.aliquota-icm).
        end.
        else do:
            if  avail item-doc-est then 
                assign tt-it-imposto.cd-trib-ipi  = item-doc-est.cd-trib-ipi
                       tt-it-imposto.cd-trib-icm  = item-doc-est.cd-trib-icm
                       tt-it-imposto.aliquota-ipi = item-doc-est.aliquota-ipi
                       tt-it-imposto.aliquota-icm = item-doc-est.aliquota-icm 
                       tt-it-docto.class-fiscal   = item-doc-est.class-fiscal.
 
            find classif-fisc 
                where classif-fisc.class-fiscal = tt-it-docto.class-fiscal
                no-lock no-error.
 
        end.                                           
 
        assign cd-trib-ipi:screen-value in frame {&frame-name} = {ininc/i10in172.i 04 tt-it-imposto.cd-trib-ipi}
               cd-trib-iss:screen-value in frame {&frame-name} = {ininc/i11in172.i 04 tt-it-imposto.cd-trib-iss}
               cd-trib-icm:screen-value in frame {&frame-name} = {ininc/i07in122.i 04 tt-it-imposto.cd-trib-icm}
               item-doc-est.aliquota-ipi:screen-value in frame {&frame-name} =
                                                string(tt-it-imposto.aliquota-ipi)
               item-doc-est.aliquota-icm:screen-value in frame {&frame-name} = 
                                                string(tt-it-imposto.aliquota-icm)
               item-doc-est.class-fiscal:screen-value in frame {&frame-name} = tt-it-docto.class-fiscal
               perc-red-icm:screen-value in frame {&frame-name} = string(natur-oper.perc-red-icm)
               tt-it-imposto.perc-red-icm                       = natur-oper.perc-red-icm
               tt-it-imposto.perc-red-ipi                       = natur-oper.perc-red-ipi.
 
        if  available classif-fisc then
            assign c-desc-class-fiscal:screen-value in frame {&frame-name} = classif-fisc.descricao.
        else
            assign c-desc-class-fiscal:screen-value in frame {&frame-name} = "".
 
    end.
 
    if  not adm-new-record 
    and avail item-doc-est then do:
        assign tt-it-docto.vl-merc-ori    = item-doc-est.preco-total[1]
               tt-it-docto.vl-merc-liq    = tt-it-docto.vl-merc-ori 
                                          - item-doc-est.desconto[1]
               tt-it-docto.vl-seguro      = item-doc-est.despesas[1]
                                          - item-doc-est.pr-total-cmi
               tt-it-docto.vl-frete       = item-doc-est.pr-total-cmi
               tt-it-imposto.aliquota-ipi = item-doc-est.aliquota-ipi
               tt-it-imposto.cd-trib-ipi  = item-doc-est.cd-trib-ipi.
 
        if  not l-servicos then do:
            run pi-calcula-ipi.
            find first tt-it-imposto no-error.
 
            assign de-vl-ipi-outras = item-doc-est.ipi-outras[1].
 
            if  param-re.ped-imp-nota then do:
                if  tt-it-imposto.vl-ipint <> 0 then
                    enable item-doc-est.ipi-ntrib[1] with frame {&frame-name}.
 
                if  tt-it-imposto.vl-ipiou <> 0 then
                    enable item-doc-est.ipi-outras[1] with frame {&frame-name}.        
 
                if tt-it-imposto.vl-bipi-it <> 0 then
                    enable item-doc-est.base-ipi[1] with frame {&frame-name}.
 
                if tt-it-imposto.vl-ipi-it <> 0 then
                    enable item-doc-est.valor-ipi[1] with frame {&frame-name}.
            end.                    
        end.                
    end.    
 
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-internacional V-table-Win 
PROCEDURE pi-internacional :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-passa-item V-table-Win 
PROCEDURE pi-passa-item :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 def input param p-sequencia like item-doc-est.sequencia.
 def input param p-it-codigo like item.it-codigo.
 
    assign c-it-codigo = p-it-codigo.    
    find item where
        item.it-codigo = c-it-codigo
        no-lock no-error.
    find familia where
        familia.fm-codigo = item.fm-codigo
        no-lock no-error.
    find item-fornec where
        item-fornec.cod-emitente = docum-est.cod-emitente and
        item-fornec.it-codigo    = c-it-codigo
        no-lock no-error.
 
    assign l-frete = can-do("16,26",substring(natur-oper.nat-operacao,1,2)).
 
    if l-servicos then do:
        disable item-doc-est.class-fiscal
                cd-trib-ipi
                item-doc-est.aliquota-ipi  with frame {&frame-name}.
        enable cd-trib-iss
               item-doc-est.aliquota-iss with frame {&frame-name}.
        disable cd-trib-icm
                item-doc-est.aliquota-icm
                item-doc-est.log-2 with frame {&frame-name}.
    end.
    else do:
         if param-re.pd-cf-item 
         or item.tipo-contr = 4 then
            enable item-doc-est.class-fiscal with frame {&frame-name}.
        else
            disable item-doc-est.class-fiscal with frame {&frame-name}.

        if  param-re.pd-cd-ipi then
            enable cd-trib-ipi with frame {&frame-name}.
        else
            disable cd-trib-ipi with frame {&frame-name}.

        if  param-re.pd-aliq-ipi then
            enable item-doc-est.aliquota-ipi with frame {&frame-name}.
        else
            disable item-doc-est.aliquota-ipi with frame {&frame-name}.

        disable cd-trib-iss
                item-doc-est.aliquota-iss with frame {&frame-name}.

        if  param-re.pd-cd-icm then
            enable cd-trib-icm with frame {&frame-name}.
        else
            disable cd-trib-icm with frame {&frame-name}.

        if  param-re.pd-aliq-icms then    
            enable item-doc-est.aliquota-icm with frame {&frame-name}.
        else     
            disable item-doc-est.aliquota-icm with frame {&frame-name}.

        if  not l-frete
        and natur-oper.subs-trib then
            enable item-doc-est.log-2 with frame {&frame-name}.
        else
            disable item-doc-est.log-2 with frame {&frame-name}.
    end.
 
    find first tt-it-docto no-error.
    if available tt-it-docto then 
        assign tt-it-docto.it-codigo = item.it-codigo.
 
    run pi-gera-imposto.
 
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recebimento V-table-Win 
PROCEDURE pi-recebimento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
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
  /* A l¢gica abaixo est† fora do padr∆o, mas funciona. Se for colocada a i-vldfrm.i
   no in°cio da procedure, o programa efetua a validaá∆o do dicion†rio, mas como 
   o atributo class-fiscal pode estar desabilitado, ele n∆o mostra a mensagem e fica parado.
   Esta foi a melhor alternativa encontrada para resolver o problema. */
 
 def var i-seq-item     like item-doc-est.sequencia no-undo.
 def var de-val-aux     as   decimal                no-undo.
 
 RUN Get-Field-Screen-Value IN adm-broker-hdl
       (INPUT this-procedure, INPUT "it-codigo":U).    
 assign c-it-codigo = return-value.    
 
 RUN Get-Field-Screen-Value IN adm-broker-hdl
     (INPUT this-procedure, INPUT "sequencia":U). 
 assign i-seq-item = int(return-value).
 
 find item 
    where item.it-codigo = c-it-codigo no-lock no-error.
 
 find classif-fisc where
      classif-fisc.class-fiscal = input frame {&frame-name} 
      item-doc-est.class-fiscal no-lock no-error.
 
 if avail classif-fisc then do:
   {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */
 end.
 else 
 if  docum-est.cod-observ <> 4 
 and ( param-re.pd-cf-item or item.tipo-contr = 4 ) then do:
      {include/i-vldprg.i} 
      {utp/ut-table.i mgind classif-fisc 1}
      run utp/ut-msgs.p (input "show":U, input 2, input return-value).
      apply "entry" to item-doc-est.class-fiscal in frame {&frame-name}.
      return 'ADM-ERROR':U.
 end.
 
 find first tt-it-imposto no-lock no-error.
 
 if not available tt-it-imposto then
    run pi-gera-imposto (yes).
 
 if ( input frame {&frame-name} item-doc-est.ipi-ntrib[1]  <> tt-it-imposto.vl-ipint-it 
 or   input frame {&frame-name} item-doc-est.base-ipi[1]   <> tt-it-imposto.vl-bipi-it    
 or   input frame {&frame-name} item-doc-est.valor-ipi[1]  <> tt-it-imposto.vl-ipi-it  
 or   input frame {&frame-name} item-doc-est.ipi-outras[1] <> de-vl-ipi-outras )
 and  not l-servicos then do:   
 
        /* mensagem: Valor de IPI nao confere com o calculado. Confirma? */
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show":U,input 15199,input " ").
        if return-value <> "yes" then do:                           
            apply 'entry' to item-doc-est.ipi-ntrib[1] in frame {&frame-name}.
            return 'adm-error':U.
        end.
        else  do:
            if  input frame {&frame-name} item-doc-est.valor-ipi[1]  <> tt-it-imposto.vl-ipi-it then do:
                assign de-val-aux = abs( input frame {&frame-name} item-doc-est.valor-ipi[1] - tt-it-imposto.vl-ipi-it ).
                run rep/re9995.p (rowid(docum-est),
                                  tt-it-imposto.vl-ipi-it,
                                  input frame {&frame-name} item-doc-est.valor-ipi[1],
                                  5507,
                                  no,
                                  i-seq-item,
                                  ( if de-val-aux > param-re.dec-1 then 1 else 2)  ). 
            end.
 
            if  input frame {&frame-name} item-doc-est.ipi-ntrib[1]  <> tt-it-imposto.vl-ipint-it 
            or  input frame {&frame-name} item-doc-est.base-ipi[1]   <> tt-it-imposto.vl-bipi-it 
            or  input frame {&frame-name} item-doc-est.ipi-outras[1] <> de-vl-ipi-outras then do:
 
                if  input frame {&frame-name} item-doc-est.base-ipi[1]   <> tt-it-imposto.vl-bipi-it then
                    assign de-calculado = tt-it-imposto.vl-bipi-it
                           de-informado = input frame {&frame-name} item-doc-est.base-ipi[1].
                else
                if  input frame {&frame-name} item-doc-est.ipi-outras[1] <> de-vl-ipi-outras then
                    assign de-calculado = de-vl-ipi-outras
                           de-informado = input frame {&frame-name} item-doc-est.ipi-outras[1].
                else
                if  input frame {&frame-name} item-doc-est.ipi-ntrib[1]  <> tt-it-imposto.vl-ipint-it then
                    assign de-calculado = tt-it-imposto.vl-ipint
                           de-informado = input frame {&frame-name} item-doc-est.ipi-ntrib[1].

                assign de-val-aux = abs( de-informado - de-calculado ).               
                run rep/re9995.p (rowid(docum-est),
                                  de-calculado,
                                  de-informado,
                                  5506,
                                  no,
                                  i-seq-item,
                                  ( if de-val-aux > param-re.dec-1 then 1 else 2)  ).
            end.                                  
        end.                              
 end.
 else do:
 
      run rep/re9995.p (rowid(docum-est),
                        0,
                        0,
                        5507,
                        yes,
                        i-seq-item,
                        2).
      run rep/re9995.p (rowid(docum-est),
                        0,
                        0,
                        5506,
                        yes,
                        i-seq-item,
                        2).
 
 end.
 
 
 if  l-servicos then do:
     if  tt-it-imposto.cd-trib-iss <> 2 
     and tt-it-imposto.cd-trib-iss <> 3 then do:
         /* mensagem: C¢digo de tributaá∆o ISS inv†lido */
         {include/i-vldprg.i}
         {utp/ut-field.i mgind item-doc-est cd-trib-iss 01}
         run utp/ut-msgs.p (input "show":U,input 158,input return-value).
         apply 'entry' to cd-trib-iss in frame {&frame-name}.
         return 'adm-error':U.
     end.
 end.
 
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
  {src/adm/template/snd-list.i "item-doc-est"}

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


