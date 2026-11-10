&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
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
{include/i-prgvrs.i V28IN176 2.00.00.019 } /*** "010019" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v28in176 MUT}
&ENDIF

{cdp/cdcfgmat.i}
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
{rep/re9999.i1}    /* flags de observacao */
 
{cdp/cdapi100.i2}  /* defini‡Æo tt-erro */
 
def var i-niv-inspecao  as integer   no-undo.
def var de-preco-total  as decimal   no-undo.
def var de-preco-unit   as decimal   no-undo.
def var de-taxa         as decimal   no-undo.
def var de-desconto     as decimal   no-undo.
def var c-item          as character no-undo.
def var l-arredonda     as logical   init yes no-undo.
def var i-arredonda     as integer   init 2   no-undo.
def var l-baixa-ce      as char      init "no"  no-undo.
def var rw-item-doc-est as rowid no-undo.
def var de-aux-1        like docum-est.valor-mercad.
def var de-aux-2        like docum-est.tot-desconto.
DEF VAR h-bopy2005      AS HANDLE    NO-UNDO.
DEF VAR h-boin01017     AS HANDLE    NO-UNDO. 
 
def buffer b-item       for item-doc-est.
 
def temp-table tt-natur-oper  
    field nat-operacao  like natur-oper.nat-operacao.
 
def temp-table tt-param
    field r-ordem as rowid
    field da-data-nota   like docum-est.dt-emissao
    field de-preco-total like item-doc-est.preco-total extent 0
    field cod-versao-integracao as integer format "999".

def temp-table tt-ext-item-doc-est-deson no-undo like ext-item-doc-est
    field r-Rowid as rowid.

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
&Scoped-define EXTERNAL-TABLES item-doc-est
&Scoped-define FIRST-EXTERNAL-TABLE item-doc-est


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR item-doc-est.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS item-doc-est.qt-do-forn ~
item-doc-est.quantidade item-doc-est.un item-doc-est.peso-liquido ~
item-doc-est.pr-total-cmi item-doc-est.preco-total[1] ~
item-doc-est.despesas[1] item-doc-est.desconto[1] 
&Scoped-define ENABLED-TABLES item-doc-est
&Scoped-define FIRST-ENABLED-TABLE item-doc-est
&Scoped-Define ENABLED-OBJECTS RECT-2 rt-key-2 rt-key de-quant-conf ~
l-iva-incluso de-preco-unit-isento de-preco-unit-com-iva 
&Scoped-Define DISPLAYED-FIELDS item-doc-est.qt-do-forn ~
item-doc-est.quantidade item-doc-est.un item-doc-est.peso-liquido ~
item-doc-est.pr-total-cmi item-doc-est.preco-unit[1] ~
item-doc-est.preco-total[1] item-doc-est.despesas[1] ~
item-doc-est.desconto[1] 
&Scoped-define DISPLAYED-TABLES item-doc-est
&Scoped-define FIRST-DISPLAYED-TABLE item-doc-est
&Scoped-Define DISPLAYED-OBJECTS de-quant-conf de-valor-pedagio ~
c-val-unit-nao-grav l-iva-incluso de-preco-unit-isento ~
de-preco-unit-com-iva de-val-icms-deson de-perc-desc-icms ~
tg-aplica-desconto

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS item-doc-est.peso-liquido ~
item-doc-est.preco-unit[1] item-doc-est.preco-total[1] ~
item-doc-est.desconto[1] 
&Scoped-define ADM-MODIFY-FIELDS item-doc-est.preco-unit[1] 

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
DEFINE VARIABLE c-val-unit-nao-grav AS DECIMAL FORMAT ">>>>,>>>,>>9.99999":U INITIAL 0 
     LABEL "Pre‡o Un NÆo Grvdo" 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88 NO-UNDO.

DEFINE VARIABLE de-preco-unit-com-iva AS DECIMAL FORMAT ">>>>,>>>,>>9.99999":U INITIAL 0 
     LABEL "Pre‡o Unit c/ IVA" 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88 NO-UNDO.

DEFINE VARIABLE de-preco-unit-isento AS DECIMAL FORMAT ">>>>,>>>,>>9.99999":U INITIAL 0 
     LABEL "Pre‡o Unit Isento" 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88 NO-UNDO.

DEFINE VARIABLE de-quant-conf AS DECIMAL FORMAT ">>>>>,>>9.9999" INITIAL 0 
     LABEL "Qtde Contada":R17 
     VIEW-AS FILL-IN 
     SIZE 17.14 BY .88.

DEFINE VARIABLE de-valor-pedagio AS DECIMAL FORMAT ">>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Ped gio" 
     VIEW-AS FILL-IN 
     SIZE 18.29 BY .88 TOOLTIP "Valor Ped gio" NO-UNDO.

DEFINE VARIABLE de-val-icms-deson AS DECIMAL FORMAT ">>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Val Desc ICMS" 
     VIEW-AS FILL-IN 
     SIZE 18.57 BY .88 TOOLTIP "Val Desc ICMS" NO-UNDO.

DEFINE VARIABLE de-perc-desc-icms AS DECIMAL FORMAT ">>9.99999":U INITIAL 0 
     LABEL "% Desc ICMS" 
     VIEW-AS FILL-IN 
     SIZE 10.57 BY .88 TOOLTIP "% Desc ICMS" NO-UNDO.

DEFINE VARIABLE tg-aplica-desconto AS LOGICAL INITIAL no 
     LABEL "Aplicar como Desconto" 
     VIEW-AS TOGGLE-BOX
     SIZE 23.37 BY .83 TOOLTIP "Aplicar como Desconto" NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 44 BY 4.25.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 44 BY 4.5.

DEFINE RECTANGLE RECT-25
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 44 BY 3.25.

DEFINE RECTANGLE rt-key-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 41.72 BY 9.

DEFINE VARIABLE l-iva-incluso AS LOGICAL INITIAL no 
     LABEL "Iva Incluso" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     item-doc-est.qt-do-forn AT ROW 1.33 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20.57 BY .88
     item-doc-est.quantidade AT ROW 2.33 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     item-doc-est.un AT ROW 3.33 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.14 BY .88
     item-doc-est.peso-liquido AT ROW 4.17 COL 61.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     de-quant-conf AT ROW 4.33 COL 19 COLON-ALIGNED
     item-doc-est.pr-total-cmi AT ROW 5.17 COL 61.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     item-doc-est.preco-unit[1] AT ROW 5.88 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     de-valor-pedagio AT ROW 6.17 COL 61.14 COLON-ALIGNED HELP
          "Valor Ped gio" WIDGET-ID 2
     item-doc-est.preco-total[1] AT ROW 6.88 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     c-val-unit-nao-grav AT ROW 6.88 COL 19 COLON-ALIGNED WIDGET-ID 4
     item-doc-est.despesas[1] AT ROW 7.17 COL 61.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     item-doc-est.desconto[1] AT ROW 7.88 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     de-perc-desc-icms AT ROW 10.26 COL 19 COLON-ALIGNED HELP 
          "% Desc ICMS"
     de-val-icms-deson AT ROW 11.26 COL 19 COLON-ALIGNED HELP 
          "Valor ICMS Deson"
     tg-aplica-desconto AT ROW 12.26 COL 19 COLON-ALIGNED HELP 
          "Aplicar Valor de ICMS Desonerado como Desconto"
     l-iva-incluso AT ROW 8.88 COL 21.14 WIDGET-ID 10
     de-preco-unit-isento AT ROW 9.88 COL 19 COLON-ALIGNED WIDGET-ID 6
     de-preco-unit-com-iva AT ROW 10.88 COL 19 COLON-ALIGNED WIDGET-ID 8
     RECT-2 AT ROW 5.75 COL 1
     rt-key-2 AT ROW 1 COL 45.43
     rt-key AT ROW 1 COL 1
     RECT-25 AT ROW 10.1 COL 1
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
         HEIGHT             = 11.42
         WIDTH              = 87.
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

/* SETTINGS FOR FILL-IN c-val-unit-nao-grav IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-val-unit-nao-grav:HIDDEN IN FRAME f-main           = TRUE.

ASSIGN 
       de-preco-unit-com-iva:HIDDEN IN FRAME f-main           = TRUE.

ASSIGN 
       de-preco-unit-isento:HIDDEN IN FRAME f-main           = TRUE.

ASSIGN 
       de-quant-conf:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN de-valor-pedagio IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN item-doc-est.desconto[1] IN FRAME f-main
   2                                                                    */
ASSIGN 
       l-iva-incluso:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN item-doc-est.peso-liquido IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN item-doc-est.preco-total[1] IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN item-doc-est.preco-unit[1] IN FRAME f-main
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

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME item-doc-est.despesas[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.despesas[1] V-table-Win
ON ENTRY OF item-doc-est.despesas[1] IN FRAME f-main /* Despesas[1] */
DO:
  assign item-doc-est.despesas[1]:modified in frame {&FRAME-NAME} = no.
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
        {utp/ut-liter.i Pre‡o_Unit * L}
        assign item-doc-est.preco-unit[1]:label  = return-value.
        {utp/ut-liter.i Pre‡o_Total * L}
        assign item-doc-est.preco-total[1]:label  = return-value.
        {utp/ut-liter.i Desconto * L}
        assign item-doc-est.desconto[1]:label  = return-value.
        {utp/ut-liter.i Frete_Constante * L}
        assign item-doc-est.pr-total-cmi:label  = return-value.
        {utp/ut-liter.i Total_Despesas * L}
        assign item-doc-est.despesas[1]:label  = return-value.
    end.
 
 
  find first param-global no-lock no-error.
  find first param-estoq  no-lock no-error.
  find param-re where param-re.usuario = c-seg-usuario no-lock no-error.

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
  /* Ponha na pi-validate todas as valida‡äes */
  /* NÆo gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
 
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
 
  /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
  /* Code placed here will execute AFTER standard behavior.    */
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy V-table-Win 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF i-pais-impto-usuario = 9 /* Paraguai */ THEN DO:
      IF VALID-HANDLE(h-bopy2005) THEN
          RUN destroy IN h-bopy2005.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .


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
    IF AVAIL item-doc-est THEN
        ASSIGN de-quant-conf = item-doc-est.quant-conf
               de-valor-pedagio = dec(SUBSTRING(item-doc-est.char-2,819,13)). /*Ped gio*/
    ELSE ASSIGN de-quant-conf = 0
                de-valor-pedagio = 0.
    
    DISP de-quant-conf de-valor-pedagio WITH FRAME {&FRAME-NAME}.
    
    /*** ICMS Desonerado ***/
    IF i-pais-impto-usuario = 1 THEN DO: /*Brasil*/
        /*ASSIGN de-val-icms-deson:HIDDEN IN FRAME {&FRAME-NAME}  = NO
               de-perc-desc-icms:HIDDEN IN FRAME {&FRAME-NAME}  = NO
               tg-aplica-desconto:HIDDEN IN FRAME {&FRAME-NAME} = NO
               RECT-25:HIDDEN IN FRAME {&FRAME-NAME} = NO.*/

        IF  NOT VALID-HANDLE(h-boin01017) THEN
            RUN inbo/boin01017.p PERSISTENT SET h-boin01017.
        RUN openQueryStatic IN h-boin01017 (INPUT "Main":U) NO-ERROR.

        RUN goToKey IN h-boin01017 (INPUT item-doc-est.serie-docto, 
                                    INPUT item-doc-est.nro-docto,   
                                    INPUT item-doc-est.cod-emitente,
                                    INPUT item-doc-est.nat-operacao,
                                    INPUT item-doc-est.sequencia,   
                                    INPUT "icms-deson":U). 
        IF  RETURN-VALUE = "OK":U THEN DO:
            RUN getRecord IN h-boin01017 (OUTPUT TABLE tt-ext-item-doc-est-deson).
            FIND FIRST tt-ext-item-doc-est-deson NO-LOCK NO-ERROR.
            IF AVAIL tt-ext-item-doc-est-deson THEN
                ASSIGN de-val-icms-deson:SCREEN-VALUE IN frame {&FRAME-NAME}= STRING(tt-ext-item-doc-est-deson.val-livre-2)
                       de-perc-desc-icms:SCREEN-VALUE IN frame {&FRAME-NAME} = STRING(tt-ext-item-doc-est-deson.val-livre-1)
                       tg-aplica-desconto:CHECKED IN frame {&FRAME-NAME} = IF tt-ext-item-doc-est-deson.log-livre-1 THEN YES ELSE NO.
        END.
        ELSE 
            ASSIGN de-val-icms-deson:SCREEN-VALUE IN frame {&FRAME-NAME} = STRING(0)
                   de-perc-desc-icms:SCREEN-VALUE IN frame {&FRAME-NAME} = STRING(0)
                   tg-aplica-desconto:CHECKED IN frame {&FRAME-NAME} = NO.
    END.
    ELSE ASSIGN de-val-icms-deson:HIDDEN IN FRAME f-main  = TRUE
                de-perc-desc-icms:HIDDEN IN FRAME f-main  = TRUE
                tg-aplica-desconto:HIDDEN IN FRAME f-main = TRUE
                RECT-25:HIDDEN IN FRAME f-main = TRUE.
    /***********************/
    
    IF i-pais-impto-usuario = 2 /* Argentina */ THEN DO:

        {utp/ut-liter.i "Pre‡o_Unit_Gravado" *}
        ASSIGN c-val-unit-nao-grav:HIDDEN IN FRAME {&FRAME-NAME}  = NO
               de-preco-unit-isento:HIDDEN IN FRAME {&FRAME-NAME} = NO
               item-doc-est.preco-unit[1]:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE)
            
               rect-2:HEIGHT IN FRAME {&FRAME-NAME}                   = 5.2
               rt-key-2:HEIGHT IN FRAME {&FRAME-NAME}                 = 9.86
               de-preco-unit-isento:ROW IN FRAME {&FRAME-NAME}        = 7.88
               item-doc-est.preco-total[1]:ROW IN FRAME {&FRAME-NAME} = 8.88
               item-doc-est.desconto[1]:ROW IN FRAME {&FRAME-NAME}    = 9.88
            
               de-preco-unit-isento:SIDE-LABEL-HANDLE:ROW IN FRAME {&FRAME-NAME}        = 7.88
               item-doc-est.preco-total[1]:SIDE-LABEL-HANDLE:ROW IN FRAME {&FRAME-NAME} = 8.88
               item-doc-est.desconto[1]:SIDE-LABEL-HANDLE:ROW IN FRAME {&FRAME-NAME}    = 9.88.

        FIND FIRST ext-item-doc-est NO-LOCK
             WHERE ext-item-doc-est.serie-docto  = item-doc-est.serie-docto
               AND ext-item-doc-est.nro-docto    = item-doc-est.nro-docto
               AND ext-item-doc-est.cod-emitente = item-doc-est.cod-emitente
               AND ext-item-doc-est.nat-operacao = item-doc-est.nat-operacao
               AND ext-item-doc-est.sequencia    = item-doc-est.sequencia
               AND ext-item-doc-est.cod-param    = "internacPrecoUnitNaoGravado":U NO-ERROR.
        IF  AVAIL ext-item-doc-est THEN
            ASSIGN c-val-unit-nao-grav:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(ext-item-doc-est.val-livre-2). /* moeda mn */
        ELSE
            ASSIGN c-val-unit-nao-grav:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

        FIND FIRST ext-item-doc-est NO-LOCK
             WHERE ext-item-doc-est.serie-docto  = item-doc-est.serie-docto
               AND ext-item-doc-est.nro-docto    = item-doc-est.nro-docto
               AND ext-item-doc-est.cod-emitente = item-doc-est.cod-emitente
               AND ext-item-doc-est.nat-operacao = item-doc-est.nat-operacao
               AND ext-item-doc-est.sequencia    = item-doc-est.sequencia
               AND ext-item-doc-est.cod-param    = "internacPrecoUnitIsento":U NO-ERROR.
        IF  AVAIL ext-item-doc-est THEN
            ASSIGN de-preco-unit-isento:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(ext-item-doc-est.val-livre-2). /* moeda mn */
        ELSE
            ASSIGN de-preco-unit-isento:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
    END.

    IF i-pais-impto-usuario = 9 /* Paraguai */ THEN DO:        
        FIND FIRST docum-est 
             WHERE docum-est.serie-docto  = item-doc-est.serie-docto 
               AND docum-est.nro-docto    = item-doc-est.nro-docto 
               AND docum-est.cod-emitente = item-doc-est.cod-emitente
               AND docum-est.nat-operacao = item-doc-est.nat-operacao NO-LOCK NO-ERROR.
        IF AVAIL docum-est THEN DO:
            ASSIGN de-preco-unit-com-iva = 0
                   de-preco-unit-isento  = 0
                   l-iva-incluso         = NO.
            IF VALID-HANDLE(h-bopy2005) THEN DO:                    
                RUN goToKey IN h-bopy2005 (INPUT docum-est.serie-docto,
                                           INPUT docum-est.nro-docto,
                                           INPUT docum-est.cod-emitente,
                                           INPUT docum-est.nat-operacao,
                                           INPUT item-doc-est.sequencia,
                                           INPUT item-doc-est.it-codigo).
                       
                IF RETURN-VALUE = "OK":U THEN DO:  
                    RUN getLogField IN h-bopy2005 (INPUT "log-iva-inclui":U,
                                                   OUTPUT l-iva-incluso).

                    RUN getDecField IN h-bopy2005 (INPUT "val-preco-unit-com-iva":U,
                                                   OUTPUT de-preco-unit-com-iva).
        
                    RUN getDecField IN h-bopy2005 (INPUT "val-preco-unit-isento":U,
                                                   OUTPUT de-preco-unit-isento).        
                END.                     
            END.
            ASSIGN l-iva-incluso:CHECKED IN FRAME {&FRAME-NAME}              = l-iva-incluso 
                   de-preco-unit-com-iva:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(de-preco-unit-com-iva * docum-est.cotacao-dia)
                   de-preco-unit-isento:SCREEN-VALUE IN FRAME {&FRAME-NAME}  = STRING(de-preco-unit-isento * docum-est.cotacao-dia).
        END.
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
 
  /* Code placed here will execute PRIOR to standard behavior. */
  run get-attribute ('adm-new-record').
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
 
     do with frame {&frame-name}:
        {utp/ut-liter.i Pre‡o_Unit * L}
        assign item-doc-est.preco-unit[1]:label  = return-value.
        {utp/ut-liter.i Pre‡o_Total * L}
        assign item-doc-est.preco-total[1]:label  = return-value.
        {utp/ut-liter.i Desconto * L}
        assign item-doc-est.desconto[1]:label  = return-value.
        {utp/ut-liter.i Frete_Constante * L}
        assign item-doc-est.pr-total-cmi:label  = return-value.
        {utp/ut-liter.i Total_Despesas * L}
        assign item-doc-est.despesas[1]:label  = return-value.
    end.
 
  /* Code placed here will execute AFTER standard behavior.    */
    &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN 
        ASSIGN de-quant-conf:HIDDEN IN FRAME {&FRAME-NAME} = NO
               rect-2:COLUMN IN FRAME {&FRAME-NAME} = 1
               rect-2:ROW    IN FRAME {&FRAME-NAME} = 5.65
               rect-2:HEIGHT IN FRAME {&FRAME-NAME} = 4.32
               rt-key:HEIGHT IN FRAME {&FRAME-NAME} = 4.44.

        IF AVAIL item-doc-est THEN
            ASSIGN de-quant-conf = item-doc-est.quant-conf.
        ELSE ASSIGN de-quant-conf = 0.
        
        DISP de-quant-conf WITH FRAME {&FRAME-NAME}.
    &ENDIF

    IF i-pais-impto-usuario = 9 /* Paraguai */ THEN DO:
        ASSIGN de-preco-unit-com-iva:HIDDEN IN FRAME {&FRAME-NAME} = NO
               de-preco-unit-isento:HIDDEN IN FRAME {&FRAME-NAME}  = NO
               l-iva-incluso:HIDDEN IN FRAME {&FRAME-NAME}         = NO
               rect-2:HEIGHT IN FRAME {&FRAME-NAME}                = 6.2
               rt-key-2:HEIGHT IN FRAME {&FRAME-NAME}              = 10.86.

        RUN local/pry/bopy2005.p PERSISTENT SET h-bopy2005.
        RUN openQueryStatic IN h-bopy2005 (INPUT "Main":U) NO-ERROR.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-calcula-preco V-table-Win 
PROCEDURE pi-calcula-preco :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  def input param rw-item         as rowid     no-undo.
  def input param i-ordem         as integer   no-undo.
  def input param rw-componente   as rowid     no-undo.
 
  def var c-serie-comp    as character no-undo.
  def var c-nro-comp      as character no-undo.
  def var c-nat-comp      as character format "999XXX" no-undo.
  def var c-cod-refer     as character no-undo.
  def var i-seq-comp      as integer   no-undo.
 
  def var de-qtd-forn     as decimal   no-undo.
  def var de-quantidade   as decimal   no-undo.
  def var de-quant-item   as decimal   no-undo.
  def var de-tot-item     as decimal   no-undo.
  def var de-valor        as decimal   no-undo. 
 
  def buffer b-componente   for componente.
  def buffer b-item-doc-est for item-doc-est.
 
  assign l-arredonda = yes.
 
  find item where rowid(item) = rw-item no-lock no-error.
  find ordem-compra where ordem-compra.numero-ordem = i-ordem no-lock no-error.
  find docum-est where rowid(docum-est) = v-row-parent no-lock no-error.
  run pi-seta-flags-observacao in this-procedure  
      (input docum-est.cod-observa, docum-est.nat-operacao).
 
  if rw-componente <> ? then 
     find componente where rowid(componente) = rw-componente no-lock no-error.
  else do:
 
    RUN Get-Field-Screen-Value IN adm-broker-hdl
        (INPUT this-procedure, INPUT "serie-comp":U).
    assign c-serie-comp = return-value.
    RUN Get-Field-Screen-Value IN adm-broker-hdl
        (INPUT this-procedure, INPUT "nro-comp":U).
    assign c-nro-comp = return-value.
 
    RUN Get-Field-Screen-Value IN adm-broker-hdl
        (INPUT this-procedure, INPUT "nat-comp":U).
    assign c-nat-comp = return-value.
    assign c-nat-comp = replace(c-nat-comp,".","").
    assign c-nat-comp = replace(c-nat-comp,"-","").
 
    RUN Get-Field-Screen-Value IN adm-broker-hdl
        (INPUT this-procedure, INPUT "seq-comp":U).
    assign i-seq-comp = integer(return-value).
    RUN Get-Field-Screen-Value IN adm-broker-hdl
        (INPUT this-procedure, INPUT "cod-refer":U).
    assign c-cod-refer = return-value.
 
    find componente where
         componente.cod-emitente = docum-est.cod-emitente and
         componente.serie-docto  = c-serie-comp           and
         componente.nro-docto    = c-nro-comp             and
         componente.nat-operacao = c-nat-comp             and
         componente.it-codigo    = item.it-codigo         and
         componente.cod-refer    = c-cod-refer            and
         componente.sequencia    = i-seq-comp no-lock no-error.
    if  not avail componente then do:
        find componente where 
             componente.cod-emitente = docum-est.cod-emitente and
             componente.serie-docto  = c-serie-comp           and 
             componente.nro-docto    = c-nro-comp             and 
             componente.nat-operacao = c-nat-comp             and 
             componente.it-codigo    = item.it-codigo         and 
             componente.cod-refer    = c-cod-refer            and
             componente.sequencia    = 0 no-lock no-error.
    end.
  end.
 
  RUN Get-Field-Screen-Value IN adm-broker-hdl
      (INPUT this-procedure, INPUT "qt-do-forn":U).
  assign de-qtd-forn = decimal(return-value).     
 
  RUN Get-Field-Screen-Value IN adm-broker-hdl
      (INPUT this-procedure, INPUT "quantidade":U).
  assign de-quantidade = decimal(return-value).   
 
 
 
  assign de-preco-total = 0 
         de-preco-unit  = 0
         de-desconto    = 0.  
  if  l-entrada and not l-devolucao and not l-transf 
  and not l-retorno and available ordem-compra then do:
 
      run pi-calcula-valores-ordem (input rowid(ordem-compra)).
 
      assign de-preco-total = round(de-preco-total / 
                              (de-qtd-forn + integer(de-qtd-forn = 0) ),4)
             de-preco-total = de-preco-total * de-qtd-forn
             de-preco-unit  = de-preco-total /
                              (de-qtd-forn + integer(de-qtd-forn = 0) ).
  end.
  else 
      if  de-qtd-forn <> 0 and l-retorno = no and l-sai-cons = no then do:
          if  l-transf or l-remessa then do:
              find item-estab where
                   item-estab.cod-estabel = docum-est.cod-estabel and
                   item-estab.it-codigo = item-doc-est.it-codigo 
                   no-lock no-error.
          end.
/**************************
          if  avail it-nota-fisc then
              assign de-base-calc-ipi = it-nota-fisc.vl-ipiou-it +
                                        it-nota-fisc.vl-bipi-it  +
                                        it-nota-fisc.vl-ipint-it.
          else
              assign de-base-calc-ipi = 0.
          assign de-preco-unit = 
              if  l-transf or l-remessa then
                  if  param-re.preco-nft = 2 then /* Preco Medio */
                      if  avail item-estab 
                      then item-estab.val-unit-mat[1] + item-estab.val-unit-mob[1]
                      else item.val-unit-mat[1] + item.val-unit-mob[1])
                  else item.preco-ul-ent        /* Ultima Entrada */
              else 
                  if  avail it-nota-fisc then
                      if  it-nota-fisc.ind-fat-qtfam = no 
                      then it-nota-fisc.vl-preuni
                      else it-nota-fisc.vl-preuni * it-nota-fisc.qt-faturada[2] / 
                           it-nota-fisc.qt-faturada[1]
                  else 
                      if  avail ped-item then ped-item.vl-preuni * de-fator
                      else 
                          if  de-preco-dev > 0 then de-preco-dev
                          else 0.
 
*****************************/                          
      end.
      else 
          if  avail componente and (l-retorno or l-sai-cons) then do:
              assign de-preco-total = item-doc-est.quantidade *
                                     (componente.preco-total[1] / 
                                      componente.quantidade)
                     de-valor       = componente.preco-total[1].
              find saldo-terc
             where saldo-terc.cod-emitente = componente.cod-emitente
               and saldo-terc.serie-docto  = componente.serie-docto
               and saldo-terc.nro-docto    = componente.nro-docto
               and saldo-terc.nat-operacao = componente.nat-operacao
               and saldo-terc.it-codigo    = componente.it-codigo
               and saldo-terc.cod-refer    = componente.cod-refer
               and saldo-terc.sequencia    = componente.sequencia
                   no-lock no-error.
              for each b-componente 
                 where b-componente.cod-emitente = saldo-terc.cod-emitente 
                   and b-componente.serie-comp   = saldo-terc.serie-docto 
                   and b-componente.nro-comp     = saldo-terc.nro-docto
                   and b-componente.nat-comp     = saldo-terc.nat-operacao
                   and b-componente.it-codigo    = saldo-terc.it-codigo
                   and b-componente.cod-refer    = saldo-terc.cod-refer
                   and b-componente.seq-comp     = saldo-terc.sequencia no-lock: 
                  assign de-valor = de-valor + if b-componente.componente = 1
                      then b-componente.preco-total[1]
                      else b-componente.preco-total[1] * -1.
              end.
              assign de-quant-item = 0
                     de-tot-item = 0.
              for each b-item-doc-est where
                         b-item-doc-est.cod-emitente = docum-est.cod-emitente
                     and b-item-doc-est.serie-docto  = docum-est.serie-docto
                     and b-item-doc-est.nro-docto    = docum-est.nro-docto
                     and b-item-doc-est.nat-operacao = docum-est.nat-operacao
                     and b-item-doc-est.serie-comp   = saldo-terc.serie
                     and b-item-doc-est.nro-comp     = saldo-terc.nro-docto
                     and b-item-doc-est.nat-comp     = saldo-terc.nat-operacao
                     and b-item-doc-est.it-codigo    = saldo-terc.it-codigo
                     and b-item-doc-est.cod-refer    = saldo-terc.cod-refer
                     and b-item-doc-est.seq-comp     = saldo-terc.sequencia no-lock:
                  assign de-quant-item = de-quant-item + b-item-doc-est.quantidade
                         de-tot-item   = de-tot-item   + b-item-doc-est.preco-total[1].
              end.
              if  saldo-terc.quantidade = de-quant-item then
                  assign de-preco-total = de-valor - de-tot-item + de-preco-total
                  l-arredonda = no.
          end.
 
 
 
 
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-calcula-valores-ordem V-table-Win 
PROCEDURE pi-calcula-valores-ordem :
/*------------------------------------------------------------------------------
  Purpose:    CµLCULO DE VALORES DA ORDEM DE COMPRA  
  Parameters: rowid da tabela ordem-compra
  Notes:       
------------------------------------------------------------------------------*/
 
  def input param rw-ordem as rowid no-undo.
 
  def var de-qtd-forn as decimal no-undo.
 
  find ordem-compra where rowid(ordem-compra) = rw-ordem no-lock no-error.
 
  assign de-preco-total = ordem-compra.pre-unit-for.
  RUN Get-Field-Screen-Value IN adm-broker-hdl
      (INPUT this-procedure, INPUT "qt-do-forn":U).
  assign de-qtd-forn = decimal(return-value).
 
  if  ordem-compra.mo-codigo <> 0 then do:
      run cdp/cd0812.p (ordem-compra.mo-codigo, 0, de-preco-total,
                        docum-est.dt-emissao, output de-preco-total).
  end.
  if  de-preco-total = ? then /* sem cota‡Æo de moeda na data */
      assign de-preco-total = 0.
  find first param-compra no-lock no-error.
  if  param-compra.ipi-sobre-preco = 2 then do: /* IPI pelo Preco Liquido */
      assign de-preco-total = de-preco-total
                            / (ordem-compra.aliquota-ipi / 100 + 1)
             de-taxa        = de-preco-total.
      if  ordem-compra.taxa-financ = no then do:
          run ccp/cc9020.p (input no,
                            input ordem-compra.cod-cond-pag,
                            input ordem-compra.valor-taxa,
                            input ordem-compra.nr-dias-taxa,
                            input de-preco-total,
                            output de-preco-total).
      end.               
      assign de-taxa        = de-taxa - de-preco-total
             de-desconto    = de-preco-total
             de-preco-total = de-preco-total 
                            / (1 - (ordem-compra.perc-descto / 100))
             de-desconto    = de-preco-total - de-desconto
             de-preco-total = de-preco-total + de-taxa.
  end.
  else do:       /* IPI pelo preco bruto */
      assign de-desconto  = de-preco-total
             de-preco-total = de-preco-total 
                             / (1 - (ordem-compra.perc-descto / 100))
             de-desconto = de-preco-total - de-desconto
             de-preco-total = de-preco-total
                             / (ordem-compra.aliquota-ipi / 100 + 1)
             de-taxa = de-preco-total.
      if  ordem-compra.taxa-financ = no then do:
          run ccp/cc9020.p (input no,
                            input ordem-compra.cod-cond-pag,
                            input ordem-compra.valor-taxa,
                            input ordem-compra.nr-dias-taxa,
                            input de-preco-total,
                            output de-preco-total).
      end.
      assign de-taxa        = de-taxa - de-preco-total
             de-preco-total = de-preco-total + de-taxa.
  end.
  if  avail cotacao-item and cotacao-item.possui-reaj then do:
      for each tt-erro:
         delete tt-erro.
      end.
      for each tt-param:
         delete tt-param.
      end.
      create tt-param.
      assign tt-param.r-ordem = rw-ordem
             tt-param.da-data-nota = docum-est.dt-emissao
             tt-param.de-preco-total = de-preco-total
             tt-param.cod-versao-integracao = 001.
 
      run ccp/ccapi004.p (input-output table tt-param,
                          output table tt-erro).
 
      find first tt-erro no-error.
      if avail tt-erro then do:
         run utp/ut-msgs.p (input "show":U,
                            input tt-erro.cod-erro,
                            input "").
      end.
      find first tt-param.
      assign de-preco-total = tt-param.de-preco-total.
  end.
 
  assign de-preco-total = round(de-preco-total 
                        * (de-qtd-forn + int(de-qtd-forn = 0)),2).
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recebe-parametros V-table-Win 
PROCEDURE pi-recebe-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 def input   parameter p-rw-item-doc-est as rowid   no-undo. 
 def input   parameter p-c-incmod        as char    no-undo.
 
assign rw-item-doc-est = p-rw-item-doc-est.
 
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

