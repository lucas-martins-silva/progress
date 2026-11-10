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
{include/i-prgvrs.i V47IN172 2.00.00.035 } /*** "010035" 17/06/2025 16:05:07 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v47in172 MUT}
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

{cdp/cdcfgdis.i}
{method/dbotterr.i} /* RowErrors */

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w
/* global variable definitions */
def new global shared var v-row-parent as rowid no-undo.                                
DEF NEW GLOBAL SHARED VAR v-codigo-anp AS CHARACTER NO-UNDO.
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE TEMP-TABLE tt-ct-clas-item NO-UNDO LIKE ct-clas-item
       field r-rowid as rowid.
       
DEF VAR hProgramZoom         AS HANDLE.
DEF VAR h-bodi00804          AS HANDLE NO-UNDO.
DEF VAR h-bodi618            AS HANDLE NO-UNDO.
DEF VAR hShowMsg             AS HANDLE NO-UNDO.
DEF VAR cod-clas-fisc-aux    AS CHAR   NO-UNDO.

{dibo/bodi135nfcom.i1} 

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
&Scoped-define EXTERNAL-TABLES item
&Scoped-define FIRST-EXTERNAL-TABLE item


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR item.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS item.desc-nacional item.desc-inter ~
item.valor-ipi-beb item.esp-beb item.enquad-beb 
&Scoped-define ENABLED-TABLES item
&Scoped-define FIRST-ENABLED-TABLE item
&Scoped-Define ENABLED-OBJECTS i-cod-produt-anp bt-detalhe-anp c-perc-glp ~
c-gas-natural c-gas-natural-imp d-vl-partida tg-gera-partilha ~
c-cod-clas-fisc RECT-1 RECT-2 RECT-bebidas RECT-5 RECT-3 RECT-cst-icms 
&Scoped-Define DISPLAYED-FIELDS item.desc-nacional item.desc-inter ~
item.valor-ipi-beb item.esp-beb item.enquad-beb 
&Scoped-define DISPLAYED-TABLES item
&Scoped-define FIRST-DISPLAYED-TABLE item
&Scoped-Define DISPLAYED-OBJECTS c-nfcom cb-class-bebida i-tipo-recip-beb ~
i-esp-prod i-vli-capac-vol cClass tg-sem-cst-icms i-cod-produt-anp ~
c-perc-glp c-gas-natural c-gas-natural-imp d-vl-partida tg-gera-partilha ~
c-cod-clas-fisc 

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
DEFINE BUTTON bt-detalhe-anp 
     IMAGE-UP FILE "image\im-zoo.bmp":U
     LABEL "Detalhe C¢digo ANP" 
     SIZE 3.57 BY .96 TOOLTIP "Detalhamento Codifica‡Æo de Produtos ANP".

DEFINE VARIABLE cb-class-bebida AS CHARACTER FORMAT "X(256)":U 
     LABEL "Classifica‡Æo para bebidas" 
     VIEW-AS COMBO-BOX INNER-LINES 3
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE c-bebidas AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 7.86 BY .67 NO-UNDO.

DEFINE VARIABLE c-cod-clas-fisc AS CHARACTER FORMAT "X(50)":U 
     LABEL "C¢d Classe Fiscal" 
     VIEW-AS FILL-IN 
     SIZE 50 BY .88 NO-UNDO.

DEFINE VARIABLE c-gas-natural AS DECIMAL FORMAT "999.9999":U INITIAL 0 
     LABEL "% GN" 
     VIEW-AS FILL-IN 
     SIZE 7.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-gas-natural-imp AS DECIMAL FORMAT "999.9999":U INITIAL 0 
     LABEL "% GN Importado" 
     VIEW-AS FILL-IN 
     SIZE 7.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-nfcom AS CHARACTER FORMAT "X(256)":U INITIAL "NFCom" 
      VIEW-AS TEXT 
     SIZE 8 BY .67 NO-UNDO.

DEFINE VARIABLE c-perc-glp AS DECIMAL FORMAT "999.9999":U INITIAL 0 
     LABEL "% GLP" 
     VIEW-AS FILL-IN 
     SIZE 7.57 BY .88 NO-UNDO.

DEFINE VARIABLE cClass AS CHARACTER FORMAT "X(7)":U 
     LABEL "cClass" 
     VIEW-AS FILL-IN 
     SIZE 14.29 BY .88 NO-UNDO.

DEFINE VARIABLE d-vl-partida AS DECIMAL FORMAT "->>>>>>>>>>>>9.99":U INITIAL 0 
     LABEL "Valor Partida" 
     VIEW-AS FILL-IN 
     SIZE 14.29 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-produt-anp AS CHARACTER FORMAT "X(9)":U INITIAL "0" 
     LABEL "C¢d Produto ANP" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 TOOLTIP "Codifica‡Æo de Produtos ANP (www.anp.gov.br) [SIMP Sist Inform Moviment Prod]" NO-UNDO.

DEFINE VARIABLE i-esp-prod AS INTEGER FORMAT "999":U INITIAL 0 
     LABEL "Esp‚cie do Produto" 
     VIEW-AS FILL-IN 
     SIZE 7.72 BY .88 NO-UNDO.

DEFINE VARIABLE i-tipo-recip-beb AS INTEGER FORMAT "99" INITIAL 1 
     LABEL "Tipo Recipiente":R18 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE i-vli-capac-vol AS INTEGER FORMAT ">>>>9":U INITIAL 0 
     LABEL "Capacidade Volum‚trica" 
     VIEW-AS FILL-IN 
     SIZE 7.72 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 36.72 BY 2.17.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78.86 BY 2.17.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78.86 BY 1.21.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 42 BY 4.13.

DEFINE RECTANGLE RECT-bebidas
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78.86 BY 3.29.

DEFINE RECTANGLE RECT-cst-icms
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 36.72 BY 1.83.

DEFINE VARIABLE tg-gera-partilha AS LOGICAL INITIAL no 
     LABEL "Gerar Grupo Partilha ICMS UF Destino (NF-e)" 
     VIEW-AS TOGGLE-BOX
     SIZE 33.57 BY .83 NO-UNDO.

DEFINE VARIABLE tg-sem-cst-icms AS LOGICAL INITIAL no 
     LABEL "Sem CST p/ ICMS" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .75.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     item.desc-nacional AT ROW 1.21 COL 19.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 37.43 BY .88
     c-nfcom AT ROW 9.08 COL 1 COLON-ALIGNED NO-LABEL WIDGET-ID 84
     item.desc-inter AT ROW 2.17 COL 19.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 37.43 BY .88
     item.valor-ipi-beb AT ROW 3.75 COL 9.57
          VIEW-AS FILL-IN 
          SIZE 20.86 BY .88
     item.esp-beb AT ROW 4.75 COL 9.86 HELP
          "Esp‚cie de Bebida"
          VIEW-AS FILL-IN 
          SIZE 4 BY .88
     cb-class-bebida AT ROW 5.75 COL 19.29 COLON-ALIGNED
     item.enquad-beb AT ROW 3.75 COL 62.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4 BY .88
     i-tipo-recip-beb AT ROW 4.75 COL 62.72 COLON-ALIGNED HELP
          "Tipo do Recipiente da Bebida"
     i-esp-prod AT ROW 7.04 COL 19.29 COLON-ALIGNED HELP
          "Esp‚cie do produto conforme classifica‡Æo fiscal"
     i-vli-capac-vol AT ROW 8.04 COL 19.29 COLON-ALIGNED HELP
          "Capacidade volum‚trica para itens do anexo I da IN 445/2004."
     cClass AT ROW 9.33 COL 19 COLON-ALIGNED HELP
          "C¢digo de Classifica‡Æo" WIDGET-ID 78
     tg-sem-cst-icms AT ROW 10.21 COL 21 HELP
          "Sem Situa‡Æo Tribut ria para o ICMS (IndSemCST)" WIDGET-ID 80
     i-cod-produt-anp AT ROW 7 COL 62.86 COLON-ALIGNED HELP
          "Codifica‡Æo de Produtos ANP [SIMP Sist Inform Moviment Prod]"
     bt-detalhe-anp AT ROW 6.96 COL 76
     c-perc-glp AT ROW 8.04 COL 42 COLON-ALIGNED HELP
          "Percentual do GLP derivado do petr¢leo no produto GLP"
     c-gas-natural AT ROW 9.04 COL 42 COLON-ALIGNED HELP
          "Percentual de G s Natural Nacional Î GLGNn para o produto GLP"
     c-gas-natural-imp AT ROW 8.04 COL 62.86 COLON-ALIGNED HELP
          "Percentual de G s Natural Importado Î GLGNi para o produto GLP"
     d-vl-partida AT ROW 9.04 COL 62.86 COLON-ALIGNED HELP
          "Valor de partida - valor por quilograma sem ICMS"
     c-bebidas AT ROW 3.25 COL 2.86 NO-LABEL
     tg-gera-partilha AT ROW 10 COL 44 HELP
          "Gera info ICMS p/ a UF destino (DIFAL) para o C¢d ANP informado"
     c-cod-clas-fisc AT ROW 11.42 COL 19.29 COLON-ALIGNED HELP
          "Classe fiscal configurador de tributos" WIDGET-ID 8
     RECT-1 AT ROW 6.92 COL 1.14
     RECT-2 AT ROW 1.08 COL 1.14
     RECT-bebidas AT ROW 3.54 COL 1.14
     RECT-5 AT ROW 6.92 COL 38 WIDGET-ID 4
     RECT-3 AT ROW 11.25 COL 1.14 WIDGET-ID 6
     RECT-cst-icms AT ROW 9.21 COL 1.14 WIDGET-ID 76
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.item
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
         HEIGHT             = 11.46
         WIDTH              = 79.14.
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

/* SETTINGS FOR FILL-IN c-bebidas IN FRAME f-main
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
/* SETTINGS FOR FILL-IN c-nfcom IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-class-bebida IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cClass IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN item.esp-beb IN FRAME f-main
   ALIGN-L EXP-HELP                                                     */
/* SETTINGS FOR FILL-IN i-esp-prod IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-tipo-recip-beb IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-vli-capac-vol IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tg-sem-cst-icms IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN item.valor-ipi-beb IN FRAME f-main
   ALIGN-L                                                              */
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

&Scoped-define SELF-NAME bt-detalhe-anp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-detalhe-anp V-table-Win
ON CHOOSE OF bt-detalhe-anp IN FRAME f-main /* Detalhe C¢digo ANP */
DO:

    ASSIGN v-codigo-anp = TRIM(i-cod-produt-anp:screen-value in frame {&frame-name}).

    RUN cdp/cd0618.w.

    ASSIGN v-codigo-anp = "".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-clas-fisc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-clas-fisc V-table-Win
ON F5 OF c-cod-clas-fisc IN FRAME f-main /* C¢d Classe Fiscal */
DO:
    
    {method/ZoomFields.i 
    &ProgramZoom="dizoom/z01di616.w"
    &FieldZoom1="cod-clas-fisc"
    &FieldScreen1="c-cod-clas-fisc"
    &Frame1="f-main"
    &RunMethod="run pi-desabilitaopcao in hProgramZoom(input 1)." 
    &EnableImplant="NO"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-clas-fisc V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-clas-fisc IN FRAME f-main /* C¢d Classe Fiscal */
DO:  
    APPLY "F5" TO c-cod-clas-fisc.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cod-produt-anp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-produt-anp V-table-Win
ON F5 OF i-cod-produt-anp IN FRAME f-main /* C¢d Produto ANP */
DO:
    {method/zoomfields.i 
           &ProgramZoom="dizoom/z01di804.w"
           &FieldZoom1="cod-chave-1"
           &FieldScreen1="i-cod-produt-anp"
           &Frame1="{&frame-name}"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-produt-anp V-table-Win
ON LEAVE OF i-cod-produt-anp IN FRAME f-main /* C¢d Produto ANP */
DO:
     IF INT(i-cod-produt-anp:SCREEN-VALUE IN FRAME {&FRAME-NAME}) = 0 THEN DO:
        DISABLE tg-gera-partilha WITH FRAME {&FRAME-NAME}.

        ASSIGN tg-gera-partilha:CHECKED IN FRAME {&FRAME-NAME} = NO.
     END.
     ELSE DO:
         ENABLE tg-gera-partilha WITH FRAME {&FRAME-NAME}.
     END.
         
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-produt-anp V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-cod-produt-anp IN FRAME f-main /* C¢d Produto ANP */
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-esp-prod
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-esp-prod V-table-Win
ON LEAVE OF i-esp-prod IN FRAME f-main /* Esp‚cie do Produto */
DO:
     assign i-tipo-recip-beb:screen-value in frame {&frame-name} = substr(i-esp-prod:screen-value in frame {&frame-name},2,2).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-tipo-recip-beb
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-tipo-recip-beb V-table-Win
ON LEAVE OF i-tipo-recip-beb IN FRAME f-main /* Tipo Recipiente */
DO:
   IF substr(i-esp-prod:screen-value in frame {&frame-name},2,2) 
      <> i-tipo-recip-beb:screen-value in frame {&frame-name} THEN 
   assign i-esp-prod:screen-value in frame {&frame-name} = i-tipo-recip-beb:screen-value in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF  

  {utp/ut-liter.i Bebidas * L}
  assign c-bebidas:screen-value in frame {&frame-name} = return-value. 

  if i-cod-produt-anp:load-mouse-pointer('image/lupa.cur') then.
  if c-cod-clas-fisc :load-mouse-pointer('image/lupa.cur') then.
    
/*/*/*{utp/ut-rdset.i rs-ind-tipo-item mft}
 *  *  * {utp/ut-field.i lcarg ext-item ind-tipo-item 1}
 *  *  * assign c-ind-tipo-item:screen-value in frame {&frame-name} = return-value.*/*/*/

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
  {src/adm/template/row-list.i "item"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "item"}

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

  {utp/ut-liter.i Bebidas * L}
  assign c-bebidas:screen-value in frame {&frame-name} = return-value.

  /*/*/*{utp/ut-field.i lcarg ext-item ind-tipo-item 1}
 *  *  *   assign c-ind-tipo-item:screen-value in frame {&frame-name} = return-value.*/*/*/

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
 /*   if  not frame {&frame-name}:validate() then */
 /*       return 'ADM-ERROR':U.                   */

  /* Ponha aqui a valida‡Æo de chave duplicada */

  /* Ponha aqui as demais valida‡äes */   
      
  IF cod-clas-fisc-aux <> "" AND cod-clas-fisc-aux <> c-cod-clas-fisc:SCREEN-VALUE IN FRAME f-main THEN DO:
               
      RUN emptyRowErrors IN h-bodi618.
      RUN gotokey        IN h-bodi618 (INPUT cod-clas-fisc-aux, INPUT item.it-codigo).
      RUN deleteRecord   IN h-bodi618.
      RUN getRowErrors   IN h-bodi618 (OUTPUT TABLE RowErrors).
          
      IF  CAN-FIND(FIRST RowErrors WHERE 
                         RowErrors.ErrorType   <> "INTERNAL":U AND
                         RowErrors.ErrorSubType = "ERROR":U)   THEN DO:             
          {method/showmessage.i1}
          {method/showmessage.i2 &Modal=YES}
          
          RETURN 'ADM-ERROR':U. 
      END.
  END.
  IF c-cod-clas-fisc:SCREEN-VALUE IN FRAME f-main <> "" THEN DO:
  
      RUN gotokey IN h-bodi618 (INPUT c-cod-clas-fisc:SCREEN-VALUE IN FRAME f-main,
                                INPUT item.it-codigo).
      IF RETURN-VALUE = "NOK" THEN DO:    
      
          EMPTY TEMP-TABLE tt-ct-clas-item.
          CREATE tt-ct-clas-item.
          ASSIGN tt-ct-clas-item.cod-clas-fisc = c-cod-clas-fisc:SCREEN-VALUE IN FRAME f-main
                 tt-ct-clas-item.cod-item      = item.it-codigo.
                      
          RUN emptyRowErrors IN h-bodi618.    
          RUN setRecord      IN h-bodi618 (INPUT TABLE tt-ct-clas-item).
          RUN createRecord   IN h-bodi618.
          RUN getRowErrors   IN h-bodi618 (OUTPUT TABLE RowErrors).
          
          IF  CAN-FIND(FIRST RowErrors WHERE 
                             RowErrors.ErrorType   <> "INTERNAL":U AND
                             RowErrors.ErrorSubType = "ERROR":U)   THEN DO:  
              {method/showmessage.i1}
              {method/showmessage.i2 &Modal=YES}
                     
              RETURN 'ADM-ERROR':U. 
          END.
          ELSE 
              ASSIGN cod-clas-fisc-aux = c-cod-clas-fisc.
      END. /* IF RETURN-VALUE = "NOK" */
      
      RUN piPrioridadeMaxima IN h-bodi618 (INPUT item.it-codigo,
                                           INPUT c-cod-clas-fisc:SCREEN-VALUE IN FRAME f-main).
  END. /* IF  c-cod-clas-fisc:SCREEN-VALUE */

  IF TRIM(INPUT FRAME {&FRAME-NAME} i-cod-produt-anp) <> "" THEN DO:
      RUN goToKey IN h-bodi00804 (INPUT TRIM(INPUT FRAME {&FRAME-NAME} i-cod-produt-anp),
                                  INPUT "0",
                                  INPUT "0",
                                  INPUT "0",
                                  INPUT "0",
                                  INPUT "infANP-CD0618").

      IF RETURN-VALUE = "NOK":U THEN DO:
          /* Inicio -- Projeto Internacional */
          {utp/ut-liter.i "C¢d_Produto_ANP" *}
          RUN utp/ut-msgs.p (INPUT "show",
                             INPUT 2,
                             INPUT RETURN-VALUE).
          APPLY 'ENTRY':U to i-cod-produt-anp IN FRAME {&FRAME-NAME}.
          RETURN 'ADM-ERROR':U.
      END.
  END.

  /* Obs.: CASO A VALIDA€ÇO FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  if RETURN-VALUE = 'ADM-ERROR':U then 
     RETURN 'ADM-ERROR':U.

    assign item.tipo-recip-beb = input frame {&frame-name} i-esp-prod.

    find item-dist where item-dist.it-codigo = item.it-codigo exclusive-lock no-error.
    if  not avail item-dist then do:
        create item-dist.
        assign item-dist.it-codigo = item.it-codigo.
    end.
    
    /* ----------- Atualiza o campo Classificacao para bebidas ---------- */
    /* Os valores deste campo sao 1 - Nenhum / 2 - Bebida / 3 - Embalagem */
    ASSIGN  item-dist.idi-classif-bebida = {diinc/i03di300.i 06 cb-class-bebida:SCREEN-VALUE IN FRAME {&FRAME-NAME}}
            item-dist.vli-capac-vol      = INPUT FRAME {&FRAME-NAME} i-vli-capac-vol.

    /* ----------- Atualiza os campos referente aos % de g s e valor de partida - NF-e 4.0 ---------- */
    ASSIGN OVERLAY(item-dist.char-1,31,8)  = c-perc-glp       :SCREEN-VALUE IN FRAME {&FRAME-NAME}
           OVERLAY(item-dist.char-1,39,8)  = c-gas-natural    :SCREEN-VALUE IN FRAME {&FRAME-NAME}
           OVERLAY(item-dist.char-1,47,8)  = c-gas-natural-imp:SCREEN-VALUE IN FRAME {&FRAME-NAME}
           OVERLAY(item-dist.char-1,55,16) = d-vl-partida     :SCREEN-VALUE IN FRAME {&FRAME-NAME}.
    
    /*--- NF-e - C¢digo Produto ANP [NT2012.003] ---*/
    ASSIGN OVERLAY(item.char-1,268,20) = TRIM(INPUT FRAME {&FRAME-NAME} i-cod-produt-anp).
    /*---*/

    /*--- NF-e - NT2015.003 ---*/
    ASSIGN INPUT FRAME {&FRAME-NAME} tg-gera-partilha.

    ASSIGN OVERLAY(item.char-1,320,1) = IF tg-gera-partilha THEN "2" ELSE "1".
    /*---*/
    
    /* Code placed here will execute AFTER standard behavior.    */
   // NFCOM
   IF l-integ-nfcom THEN
   DO:   
        FIND item-dist WHERE item-dist.it-codigo = item.it-codigo EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAIL item-dist THEN 
        DO:
            CREATE item-dist.
            ASSIGN item-dist.it-codigo = item.it-codigo.
        END.
   
        ASSIGN
            OVERLAY(item-dist.char-2,133,7) = cClass:SCREEN-VALUE IN FRAME f-main
            OVERLAY(item-dist.char-2,140,1) = (IF tg-sem-cst-icms:INPUT-VALUE IN FRAME f-main THEN "1" ELSE " ").
   END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy V-table-Win 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  ASSIGN v-codigo-anp  = "".
  
  IF  VALID-HANDLE(h-bodi618) THEN DO:
      DELETE PROCEDURE h-bodi618.
      ASSIGN h-bodi618 = ?.
  END.
  
  IF  VALID-HANDLE(h-bodi00804) THEN DO:
      DELETE PROCEDURE h-bodi00804.
      ASSIGN h-bodi00804 = ?.
  END.

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

/*/*/*  assign rs-ind-tipo-item:sensitive in frame {&frame-name} = no.*/*/*/

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
  
  DISABLE i-tipo-recip-beb 
          i-cod-produt-anp 
          i-esp-prod       
          i-vli-capac-vol  
          cb-class-bebida  
          d-vl-partida     
          tg-gera-partilha 
          c-perc-glp       
          c-gas-natural    
          c-gas-natural-imp
          c-cod-clas-fisc
      WITH FRAME {&FRAME-NAME}.

  /*--- NF-e - C¢digo Produto ANP [NT2012.003] ---*/
  ASSIGN bt-detalhe-anp  :HIDDEN    IN FRAME {&FRAME-NAME} = NO
         i-cod-produt-anp:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

   // NFCOM
   IF l-integ-nfcom THEN
   DO:
        ASSIGN
            cClass:SENSITIVE IN FRAME f-main = NO
            tg-sem-cst-icms:SENSITIVE IN FRAME f-main = NO.       
   END.
         
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

  if  avail item then do:
  
      /***Classe fiscal ***/
      IF i-pais-impto-usuario = 1 THEN DO:
          ASSIGN c-cod-clas-fisc = "".
                  
          RUN goToKey2     IN h-bodi618 (INPUT item.it-codigo).
          IF RETURN-VALUE  = "OK" THEN
              RUN getcharfield IN h-bodi618 (INPUT "cod-clas-fisc",
                                             OUTPUT c-cod-clas-fisc). 
                                             
          ASSIGN cod-clas-fisc-aux = c-cod-clas-fisc. 
          DISP   c-cod-clas-fisc WITH FRAME f-main.
      END.
    
      find item-dist where item-dist.it-codigo = item.it-codigo no-lock no-error.
      
      if  avail item-dist then do:
          /* ----------- Exibi o campo Classificacao para bebidas ------------  */
          /* Os valores deste campo sao 1 - Nenhum / 2 - Bebida / 3 - Embalagem */
          assign cb-class-bebida = {diinc/i03di300.i 04 item-dist.idi-classif-bebida} no-error.
          if  error-status:error then
              assign cb-class-bebida = {diinc/i03di300.i 04 1}.
          ASSIGN i-vli-capac-vol = item-dist.vli-capac-vol.

          /* ----------- Exibe os campos referente aos % de g s e valor de partida - NF-e 4.0 ---------- */
          ASSIGN c-perc-glp        = DEC(SUBSTRING(item-dist.char-1,31,8))
                 c-gas-natural     = DEC(SUBSTRING(item-dist.char-1,39,8))
                 c-gas-natural-imp = DEC(SUBSTRING(item-dist.char-1,47,8))
                 d-vl-partida      = DEC(SUBSTRING(item-dist.char-1,55,16)).
      end.
      else
          ASSIGN cb-class-bebida   = {diinc/i03di300.i 04 1}
                 i-vli-capac-vol   = 0
                 c-perc-glp        = 0
                 c-gas-natural     = 0
                 c-gas-natural-imp = 0
                 d-vl-partida      = 0.
  end.
  else
      assign cb-class-bebida   = {varinc/var00179.i 04 1}
             i-vli-capac-vol   = 0
             c-perc-glp        = 0
             c-gas-natural     = 0
             c-gas-natural-imp = 0
             d-vl-partida      = 0.

  /*--- NF-e - C¢digo Produto ANP [NT2012.003] ---*/
  DISABLE bt-detalhe-anp WITH FRAME {&FRAME-NAME}.

  IF  AVAIL item THEN DO:
      ASSIGN i-cod-produt-anp = IF TRIM(SUBSTRING(item.char-1,268,20)) <> "0" THEN TRIM(SUBSTRING(item.char-1,268,20)) ELSE "".
      
      DISPLAY i-cod-produt-anp WITH FRAME {&FRAME-NAME}.

      IF  i-cod-produt-anp:screen-value in frame {&frame-name} = "" THEN
          DISABLE bt-detalhe-anp WITH FRAME {&FRAME-NAME}.
      ELSE
          ENABLE bt-detalhe-anp WITH FRAME {&FRAME-NAME}. 
  END.
  ELSE
      ASSIGN i-cod-produt-anp:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
             c-perc-glp      :SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
  /*---*/

  /*--- NF-e - NT2015.003 ---*/
  IF AVAIL item THEN
      ASSIGN tg-gera-partilha = SUBSTR(item.char-1,320,1) = "2".
  /*---*/

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  IF AVAIL ITEM THEN
      assign i-esp-prod:screen-value in frame {&frame-name}  = string(item.tipo-recip-beb,"999")
             i-tipo-recip-beb:screen-value in frame {&frame-name}  = SUBSTR(STRING(item.tipo-recip-beb,"999"),2,2).

  /* Code placed here will execute AFTER standard behavior.    */

   // NFCOM
   IF l-integ-nfcom THEN
   DO:
      ASSIGN
          cClass:SCREEN-VALUE IN FRAME f-main = ""
          tg-sem-cst-icms:SCREEN-VALUE IN FRAME f-main = "NO".
      IF AVAIL item-dist THEN
        ASSIGN
            cClass:SCREEN-VALUE IN FRAME f-main = SUBSTRING(item-dist.char-2,133,7)
            tg-sem-cst-icms:SCREEN-VALUE IN FRAME f-main = STRING(SUBSTRING(item-dist.char-2,140,1) = "1").
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

  ENABLE i-tipo-recip-beb 
         i-esp-prod 
         i-vli-capac-vol 
         cb-class-bebida 
         c-perc-glp c-gas-natural 
         c-gas-natural-imp 
         d-vl-partida 
         tg-gera-partilha
         c-cod-clas-fisc
      WITH FRAME {&FRAME-NAME}.

  /*--- NF-e - C¢digo Produto ANP [NT2012.003] ---*/
  ASSIGN bt-detalhe-anp  :HIDDEN    IN FRAME {&FRAME-NAME} = YES
         i-cod-produt-anp:SENSITIVE IN FRAME {&FRAME-NAME} = YES.

  IF i-cod-produt-anp:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "" THEN DO:
      DISABLE tg-gera-partilha WITH FRAME {&FRAME-NAME}.

      ASSIGN tg-gera-partilha:CHECKED IN FRAME {&FRAME-NAME} = NO.
  END.
  ELSE DO:
      ENABLE tg-gera-partilha WITH FRAME {&FRAME-NAME}.
  END.

  /* Code placed here will execute PRIOR to standard behavior. */
  run get-attribute ('adm-new-record').
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

/*/*/*    assign rs-ind-tipo-item:sensitive in frame {&frame-name} = yes.*/*/*/
       /* Code placed here will execute AFTER standard behavior.    */
       &if  defined(ADM-MODIFY-FIELDS) &then
            enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
       &endif 
       
       
   // NFCOM
   IF l-integ-nfcom THEN
   DO:
        ASSIGN
            cClass:SENSITIVE IN FRAME f-main = YES
            tg-sem-cst-icms:SENSITIVE IN FRAME f-main = YES.       
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

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Os valores do campo "Classificacao para bebidas" sao 1 - Nenhum / 2 - Bebida / 3 - Embalagem */
  assign cb-class-bebida:list-items in frame {&frame-name} = {varinc/var00179.i 03}.

  IF NOT VALID-HANDLE(h-bodi618) THEN
        RUN dibo/bodi618.p PERSISTENT SET h-bodi618.
        
  RUN openQueryStatic IN h-bodi618 (INPUT "Main":U) NO-ERROR.
    
  IF NOT VALID-HANDLE(h-bodi00804) THEN
      RUN dibo/bodi00804.p PERSISTENT SET h-bodi00804.

  RUN setConstraintByParam IN h-bodi00804 (INPUT "infANP-CD0618":U) NO-ERROR.
  RUN OpenQueryStatic      IN h-bodi00804 (INPUT "byParam":U)       NO-ERROR.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DISABLE i-tipo-recip-beb 
          i-cod-produt-anp 
          i-esp-prod       
          i-vli-capac-vol  
          cb-class-bebida  
          d-vl-partida     
          tg-gera-partilha 
          c-perc-glp       
          c-gas-natural    
          c-gas-natural-imp
          c-cod-clas-fisc
      WITH FRAME {&FRAME-NAME}.

   // NFCOM
   IF l-integ-nfcom THEN
   DO:
        ASSIGN
            c-nfcom:HIDDEN IN FRAME f-main = NO
            cClass:HIDDEN IN FRAME f-main = NO
            tg-sem-cst-icms:HIDDEN IN FRAME f-main = NO
            rect-cst-icms:HIDDEN IN FRAME f-main = NO.       
   END.
   ELSE
   DO:
        DO WITH FRAME f-main:
            ASSIGN
                c-nfcom:HIDDEN = YES
                cClass:HIDDEN = YES
                tg-sem-cst-icms:HIDDEN = YES
                rect-cst-icms:HIDDEN = YES
                rect-1:HEIGHT = 4.13
                i-esp-prod:ROW = 8.04
                i-esp-prod:SIDE-LABEL-HANDLE:ROW = 8.04
                i-vli-capac-vol:ROW = 9.04
                i-vli-capac-vol:SIDE-LABEL-HANDLE:ROW = 9.04.
        END.     
            
   END.
            
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
  {src/adm/template/snd-list.i "item"}

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

