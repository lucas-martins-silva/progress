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
{include/i-prgvrs.i V02IN087 2.00.00.016 } /*** "010016" 06/08/2026 10:30:18  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V02IN087 MUT}
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
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

{rep/re9999.i2 "new"}    /* usado na procedure pi-calcula-imposto */

def var rw-natur-oper-ac as rowid no-undo.
def var i-cod-emit     like emitente.cod-emitente no-undo.
def var c-nat-operacao as char.
def var l-inclui       as l init no no-undo.
def var de-aliq-icm-aux    like despesa-aces.aliquota-icm.
def var de-valor-aux       like despesa-aces.valor.
def var de-icm-deb-cre-aux like despesa-aces.icm-deb-cre.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES despesa-aces
&Scoped-define FIRST-EXTERNAL-TABLE despesa-aces


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR despesa-aces.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS despesa-aces.valor despesa-aces.valor-tot-rt despesa-aces.aliquota-icm ~
despesa-aces.base-icm despesa-aces.icm-deb-cre 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}valor ~{&FP2}valor ~{&FP3}~
 ~{&FP1}valor-tot-rt ~{&FP2}valor-tot-rt ~{&FP3}~
 ~{&FP1}aliquota-icm ~{&FP2}aliquota-icm ~{&FP3}~
 ~{&FP1}base-icm ~{&FP2}base-icm ~{&FP3}~
 ~{&FP1}icm-deb-cre ~{&FP2}icm-deb-cre ~{&FP3}
&Scoped-define ENABLED-TABLES despesa-aces
&Scoped-define FIRST-ENABLED-TABLE despesa-aces
&Scoped-Define ENABLED-OBJECTS RECT-4 rt-key  
&Scoped-Define DISPLAYED-FIELDS despesa-aces.valor despesa-aces.valor-tot-rt ~
despesa-aces.aliquota-icm despesa-aces.icm-nao-trib despesa-aces.icm-outras ~
despesa-aces.base-icm despesa-aces.icm-deb-cre vl-bicms-compl despesa-aces.icm-complem ~
despesa-aces.base-subs despesa-aces.vl-subs 
&Scoped-Define DISPLAYED-OBJECTS cb-cd-trib-icm  

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS despesa-aces.valor despesa-aces.valor-tot-rt ~
despesa-aces.aliquota-icm despesa-aces.icm-nao-trib despesa-aces.icm-outras ~
despesa-aces.base-icm despesa-aces.icm-deb-cre despesa-aces.icm-complem ~
despesa-aces.base-subs despesa-aces.vl-subs 
&Scoped-define ADM-MODIFY-FIELDS cb-cd-trib-icm despesa-aces.base-subs ~
despesa-aces.vl-subs 

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
DEFINE VARIABLE cb-cd-trib-icm AS CHARACTER FORMAT "X(256)":U 
     LABEL "Combo 1" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     SIZE 25.72 BY 1 NO-UNDO.

DEFINE VARIABLE vl-bicms-compl AS DECIMAL FORMAT ">>>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Base ICMS Complementar" 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 86 BY 2.5.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 86 BY 9.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     despesa-aces.valor AT ROW 1.33 COL 32.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     despesa-aces.valor-tot-rt AT ROW 2.33 COL 32.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     cb-cd-trib-icm AT ROW 3.79 COL 32.29 COLON-ALIGNED
     despesa-aces.aliquota-icm AT ROW 4.83 COL 32.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     despesa-aces.icm-nao-trib AT ROW 5.75 COL 32.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     despesa-aces.icm-outras AT ROW 6.67 COL 32.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     despesa-aces.base-icm AT ROW 7.58 COL 32.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     despesa-aces.icm-deb-cre AT ROW 8.50 COL 32.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     vl-bicms-compl AT ROW 9.42 COL 32.14 COLON-ALIGNED 
     despesa-aces.icm-complem AT ROW 10.33 COL 32.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     despesa-aces.base-subs AT ROW 11.25 COL 32.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     despesa-aces.vl-subs AT ROW 12.17 COL 32.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20.57 BY .88
     RECT-4 AT ROW 1 COL 1
     rt-key AT ROW 3.67 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.despesa-aces
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
         HEIGHT             = 12.50
         WIDTH              = 87.29.
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

/* SETTINGS FOR FILL-IN despesa-aces.aliquota-icm IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN despesa-aces.base-icm IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN despesa-aces.base-subs IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR COMBO-BOX cb-cd-trib-icm IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN despesa-aces.icm-complem IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN despesa-aces.icm-deb-cre IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN despesa-aces.icm-nao-trib IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN despesa-aces.icm-outras IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN despesa-aces.valor IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN despesa-aces.valor-tot-rt IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN despesa-aces.vl-subs IN FRAME f-main
   NO-ENABLE 2 3                                                        */
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

&Scoped-define SELF-NAME despesa-aces.aliquota-icm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL despesa-aces.aliquota-icm V-table-Win
ON ENTRY OF despesa-aces.aliquota-icm IN FRAME f-main /* Aliquota ICMS */
DO:
  assign de-aliq-icm-aux = input frame {&frame-name} despesa-aces.aliquota-icm.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL despesa-aces.aliquota-icm V-table-Win
ON LEAVE OF despesa-aces.aliquota-icm IN FRAME f-main /* Aliquota ICMS */
DO:
  assign despesa-aces.base-icm:screen-value in frame {&frame-name} = 
         input frame {&frame-name} despesa-aces.valor.
         
  RUN Get-Field-Screen-Value IN adm-broker-hdl
      (INPUT this-procedure,
       INPUT "nat-oper-ac").
  assign c-nat-operacao = return-value.
  assign c-nat-operacao = replace(c-nat-operacao,".","").
  assign c-nat-operacao = replace(c-nat-operacao,"-","").
  find first natur-oper where 
       natur-oper.nat-operacao = c-nat-operacao no-lock no-error.

    if  de-aliq-icm-aux <> input frame {&frame-name} despesa-aces.aliquota-icm
    then do:
        assign despesa-aces.icm-deb-cre:screen-value in frame {&frame-name} = 
                              string((input frame {&frame-name} despesa-aces.aliquota-icm *
                                     input frame {&frame-name} despesa-aces.base-icm) / 100).
        

    end.   
    if  de-aliq-icm-aux <> input frame {&frame-name} despesa-aces.aliquota-icm and
        natur-oper.subs-trib then do with frame {&frame-name}:
        assign despesa-aces.vl-subs:screen-value in frame {&frame-name} = 
                            string((input frame {&frame-name} despesa-aces.aliquota-icm *
                            input frame {&frame-name} despesa-aces.base-subs) / 100).    
    end.    
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-cd-trib-icm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cd-trib-icm V-table-Win
ON VALUE-CHANGED OF cb-cd-trib-icm IN FRAME f-main /* Combo 1 */
DO:
  if {ininc/i07in122.i 06 cb-cd-trib-icm:screen-value in frame {&frame-name}} = 2 then 
     do with frame {&frame-name}:
        assign despesa-aces.aliquota-icm:screen-value = "0"
               despesa-aces.base-icm:screen-value = "0"
               despesa-aces.icm-deb-cre:screen-value = "0".
        assign despesa-aces.aliquota-icm:sensitive = no
               despesa-aces.base-icm:sensitive = no
               despesa-aces.icm-deb-cre:sensitive = no.
     end.
  else
     do with frame {&frame-name}:
        assign despesa-aces.aliquota-icm:sensitive = yes
               despesa-aces.base-icm:sensitive = yes
               despesa-aces.icm-deb-cre:sensitive = yes.
     end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME despesa-aces.valor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL despesa-aces.valor V-table-Win
ON ENTRY OF despesa-aces.valor IN FRAME f-main /* Valor Total */
DO:
  assign de-valor-aux = input frame {&frame-name} despesa-aces.valor.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL despesa-aces.valor V-table-Win
ON LEAVE OF despesa-aces.valor IN FRAME f-main /* Valor Total */
DO:
    if de-valor-aux <> input frame {&frame-name} despesa-aces.valor 
    and {ininc/i07in122.i 06 cb-cd-trib-icm:screen-value in frame {&frame-name}} <> 2
        then do with frame {&frame-name}:
        if l-inclui then do:
            run pi-calcula-impostos in this-procedure (input rw-natur-oper-ac,
                                                       input i-cod-emit).
        end.
        else do:
            assign despesa-aces.base-icm:screen-value in frame {&frame-name} = 
                            input frame {&frame-name} despesa-aces.valor
                   despesa-aces.icm-deb-cre:screen-value in frame {&frame-name} = 
                            string((input frame {&frame-name} despesa-aces.valor *
                                    input frame {&frame-name} despesa-aces.aliquota-icm)
                                    / 100).
            if avail natur-oper and natur-oper.subs-trib then  
                assign despesa-aces.base-subs:screen-value in frame {&frame-name} = 
                                    input frame {&frame-name} despesa-aces.valor
                       despesa-aces.vl-subs:screen-value in frame {&frame-name} = 
                                    string((input frame {&frame-name} despesa-aces.valor *
                                    input frame {&frame-name} despesa-aces.aliquota-icm)
                                    / 100)   .                                 
        end.                                   
    end.
    
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

  {utp/ut-field.i mgind despesa-aces cd-trib-icm 1}
  assign cb-cd-trib-icm:label in frame {&frame-name} = return-value.
  
  find docum-est where rowid(docum-est) = v-row-parent no-lock no-error.
  find first param-estoq no-lock no-error.
  find first param-global no-lock no-error.

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
  {src/adm/template/row-list.i "despesa-aces"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "despesa-aces"}

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
  {include/i-valid.i}
  /* Ponha na pi-validate todas as validaá‰es */
  /* N∆o gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.

  /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
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
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  if  avail despesa-aces then do with frame {&frame-name}:
      assign cb-cd-trib-icm:screen-value = {ininc/i07in122.i 04 despesa-aces.cd-trib-icm}
             vl-bicms-compl:SCREEN-VALUE IN FRAME {&FRAME-NAME} = SUBSTRING(despesa-aces.char-2,69,20). 
  end.
  else do with frame {&frame-name}:
      assign cb-cd-trib-icm:screen-value = {ininc/i07in122.i 04 1}.
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
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
  if available despesa-aces then do:
      find first natur-oper where
           natur-oper.nat-operacao = despesa-aces.nat-oper-ac no-lock no-error.
      if avail natur-oper and natur-oper.subs-trib then  do:
          enable despesa-aces.base-subs
                 despesa-aces.vl-subs with frame {&frame-name}.
      end.
      if avail natur-oper and not natur-oper.subs-trib then  do:
          disable despesa-aces.base-subs
                  despesa-aces.vl-subs with frame {&frame-name}.
      end.
  end.

      

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE l-nt2024002 AS LOGICAL NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */
  find first param-global no-lock no-error.
  do  with frame {&frame-name}:
      assign cb-cd-trib-icm:list-items = {ininc/i07in122.i 03}.
  end.
  
  ASSIGN l-nt2024002 = CAN-FIND (FIRST funcao no-lock 
                                 WHERE funcao.cd-funcao = "spp-nt2024002"
                                   AND funcao.ativo     = YES). 
  
  IF NOT l-nt2024002 THEN DO:
      ASSIGN despesa-aces.valor-tot-rt:HIDDEN IN FRAME {&FRAME-NAME} = YES.
  END.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-calcula-impostos V-table-Win 
PROCEDURE pi-calcula-impostos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  def input param rw-natur-oper-ac as rowid no-undo.
  def input param i-cod-emit like emitente.cod-emitente.
  def buffer b-doc    for docum-est.
  def buffer b-it-doc for item-doc-est.

  def var i-emitente  as integer   no-undo.
  def var c-natureza  as character no-undo.
  def var de-aliq-icm as decimal   no-undo.
  
  RUN Get-Field-Screen-Value IN adm-broker-hdl
      (INPUT this-procedure, INPUT "cod-forn-ac").
  assign i-emitente = integer(return-value).
  find emitente where emitente.cod-emitente = i-emitente no-lock no-error.
  
  find first natur-oper where
           rowid(natur-oper) = rw-natur-oper-ac no-lock no-error.
  
  if  not avail emitente or not avail natur-oper then 
      return.
     
  create b-doc.
  assign b-doc.cod-emitente = i-emitente
         b-doc.nat-operacao = natur-oper.nat-operacao  /*c-natureza*/
         b-doc.nro-docto    = "DESPESA ACES":U
         b-doc.serie-docto  = "DES":U
         b-doc.valor-mercad = input frame {&frame-name} despesa-aces.valor
         b-doc.cod-estabel  = docum-est.cod-estabel.
  create b-it-doc.
  assign b-it-doc.cod-emitente   = b-doc.cod-emitente
         b-it-doc.nat-operacao   = b-doc.nat-operacao
         b-it-doc.serie-docto    = b-doc.serie-docto
         b-it-doc.nro-docto      = b-doc.nro-docto
         b-it-doc.preco-total[1] = b-doc.valor-mercad.
  assign de-aliq-icm     = 0
          de-icm-base    = 0
          de-icm-deb-cre = 0.
  run rep/re9991.p (input rowid(b-doc), output de-aliq-icm).
  assign b-it-doc.aliquota-icm = de-aliq-icm
         b-it-doc.cd-trib-icm = natur-oper.cd-trib-icm.
  run rep/re9994.p (input rowid(b-it-doc)).
  delete b-doc.

  assign de-ICM-deb-cre = round(de-ICM-deb-cre,2)
         de-ICM-base    = round(de-ICM-base   ,2)
         de-ICM-complem = round(de-ICM-complem,2)
         de-ICM-ntrib   = round(de-ICM-ntrib  ,2)
         de-ICM-outras  = round(de-ICM-outras ,2)
         de-IPI-base    = round(de-IPI-base   ,2)
         de-IPI-deb-cre = round(de-IPI-deb-cre,2)
         de-IPI-outras  = round(de-IPI-outras ,2)
         de-IPI-ntrib   = round(de-IPI-ntrib  ,2)
         de-ISS-deb-cre = round(de-ISS-deb-cre,2)
         de-ISS-base    = round(de-ISS-base   ,2)
         de-ISS-ntrib   = round(de-ISS-ntrib  ,2)
         de-ISS-outras  = round(de-ISS-outras ,2)
         cb-cd-trib-icm = {ininc/i07in122.i 04 natur-oper.cd-trib-icm}.
  if l-inclui then 
  display de-aliq-icm    @ despesa-aces.aliquota-icm 
          cb-cd-trib-icm 
          de-icm-deb-cre @ despesa-aces.icm-deb-cre
          de-icm-base    @ despesa-aces.base-icm
          with frame {&frame-name}.
  if l-inclui then do  with frame {&frame-name}:
      assign despesa-aces.base-subs:sensitive    = natur-oper.subs-trib
             despesa-aces.vl-subs:sensitive      = natur-oper.subs-trib
             despesa-aces.base-subs:screen-value = string( de-icm-base *
                                                           int(natur-oper.subs-trib) )
             despesa-aces.vl-subs:screen-value   = string( de-icm-deb-cre *
                                                           int(natur-oper.subs-trib) ).
  end.
             
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seta-natureza V-table-Win 
PROCEDURE pi-seta-natureza :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  def input param rw-natur-oper-recebida as rowid no-undo.
  def input param i-cod-emitente like emitente.cod-emitente no-undo.
  
  assign rw-natur-oper-ac = rw-natur-oper-recebida
         i-cod-emit       = i-cod-emitente.         
  
  find first natur-oper where
       rowid(natur-oper) = rw-natur-oper-recebida no-lock no-error.
  
  run pi-calcula-impostos in this-procedure (input rw-natur-oper-recebida,
                                             input i-cod-emit).

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
  {src/adm/template/snd-list.i "despesa-aces"}

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


