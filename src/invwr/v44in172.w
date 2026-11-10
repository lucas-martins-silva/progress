&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
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
{include/i-prgvrs.i V44IN172 2.00.00.049 } /*** "010049" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v44in172 MUT}
&ENDIF


{cdp/cdcfgdis.i} /*definiá∆o dos preprocessors da distribuiá∆o*/
{cdp/cd9999.i4} /* seta funá∆o embalagem */
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

/* Parameters Definitions ---                          */

def var c-handle          as character no-undo.
def var wh-cd0903         as handle    no-undo.

def var de-ft-conv-fmcoml as decimal no-undo.
def var de-ft-conversao   as decimal no-undo.
def var de-ft-conver      as decimal no-undo.
def var h-bosc063 as handle no-undo.

DEFINE VARIABLE c-lista-unid  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-cont        AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-aux         AS CHARACTER   NO-UNDO.

&IF '{&mgscm_version}' >= '2.06B' &THEN
{method/dbotterr.i}
DEFINE VARIABLE hDBOproxy AS HANDLE NO-UNDO.

DEF TEMP-TABLE ttItemReplica    NO-UNDO
    FIELD it-codigo             LIKE wm-item.cod-item
    FIELD desc-item             LIKE wm-item.des-item
    FIELD unid-med              LIKE wm-item.cod-unid-med
    FIELD peso-bruto            LIKE wm-item.qtd-peso
    FIELD largura               LIKE wm-item.qtd-largura
    FIELD comprimento           LIKE wm-item.qtd-comprimento
    FIELD altura                LIKE wm-item.qtd-altura
    FIELD tipo-con-est          LIKE wm-item.ind-tipo-contr-est
    FIELD fm-cod-com            LIKE wm-item.cod-familia
    FIELD fm-codigo             LIKE wm-item.cod-familia
    INDEX ch-codigo AS PRIMARY UNIQUE it-codigo.
&ENDIF

/* Local Variable Definitions ---                                       */

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
&Scoped-define EXTERNAL-TABLES item item-dist
&Scoped-define FIRST-EXTERNAL-TABLE item


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR item, item-dist.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS item.peso-bruto item.peso-liquido ~
item.tipo-contr item.deposito-pad item.cod-localiz item.codigo-orig ~
item.altura item.tipo-con-est item.largura item.comprim item.ind-item-fat ~
item.ind-inf-qtf item.baixa-estoq item.loc-unica item-dist.log-1 
&Scoped-define ENABLED-TABLES item item-dist
&Scoped-define FIRST-ENABLED-TABLE item
&Scoped-define SECOND-ENABLED-TABLE item-dist
&Scoped-Define ENABLED-OBJECTS cb-unid-fatur RECT-20 RECT-21 
&Scoped-Define DISPLAYED-FIELDS item.peso-bruto item.peso-liquido ~
item.tipo-contr item.deposito-pad item.cod-localiz item.codigo-orig ~
item.altura item.tipo-con-est item.largura item.comprim item.ind-item-fat ~
item.ind-inf-qtf item.baixa-estoq item.loc-unica item-dist.log-1 
&Scoped-define DISPLAYED-TABLES item item-dist
&Scoped-define FIRST-DISPLAYED-TABLE item
&Scoped-define SECOND-DISPLAYED-TABLE item-dist
&Scoped-Define DISPLAYED-OBJECTS cb-unid-fatur 

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
DEFINE VARIABLE cb-unid-fatur AS CHARACTER FORMAT "X(30)":U 
     LABEL "Emiss∆o NF" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 25 BY 1 NO-UNDO.

DEFINE VARIABLE c-cod-un-padrao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-un-padrao-2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-un-padrao-3 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE text-1 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 25.14 BY .88 NO-UNDO.

DEFINE VARIABLE text-2 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 25.14 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-20
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 29.14 BY 3.58.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 29.14 BY 4.08.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     item.peso-bruto AT ROW 1.08 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.29 BY .88
     item.peso-liquido AT ROW 2.08 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.29 BY .88
     item.tipo-contr AT ROW 1.88 COL 49.86 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "F°sico", 1,
"Total", 2,
"Consignado", 3,
"DÇbito Direto", 4,
"N∆o Definido", 5
          SIZE 18.86 BY 3.58
     item.deposito-pad AT ROW 3.08 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.43 BY .88
     item.cod-localiz AT ROW 4.08 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .88
     item.codigo-orig AT ROW 5.08 COL 20 COLON-ALIGNED FORMAT "9"
          VIEW-AS FILL-IN 
          SIZE 2.57 BY .88
          HELP "Tabela A - Origem da Mercadoria ou Serviáo"
     item.altura AT ROW 6.08 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     c-cod-un-padrao AT ROW 6.08 COL 34.72 COLON-ALIGNED NO-LABEL
     item.tipo-con-est AT ROW 6.58 COL 50 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Serial", 1,
"N£mero SÇrie", 2,
"Lote", 3,
"Referància", 4
          SIZE 18.86 BY 2.83
     item.largura AT ROW 7.08 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     c-cod-un-padrao-2 AT ROW 7.08 COL 34.72 COLON-ALIGNED NO-LABEL
     item.comprim AT ROW 8.08 COL 20.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     c-cod-un-padrao-3 AT ROW 8.08 COL 34.72 COLON-ALIGNED NO-LABEL
     cb-unid-fatur AT ROW 9.08 COL 20 COLON-ALIGNED
     item.ind-item-fat AT ROW 8.83 COL 22
          VIEW-AS TOGGLE-BOX
          SIZE 18.29 BY .75
     item.ind-inf-qtf AT ROW 9.63 COL 22
          VIEW-AS TOGGLE-BOX
          SIZE 21 BY .75
     item.baixa-estoq AT ROW 10.33 COL 22
          VIEW-AS TOGGLE-BOX
          SIZE 20.29 BY .75
     item.loc-unica AT ROW 11.08 COL 22
          VIEW-AS TOGGLE-BOX
          SIZE 23 BY .75
     item-dist.log-1 AT ROW 10.83 COL 50
          LABEL "Controla Seriais"
          VIEW-AS TOGGLE-BOX
          SIZE 18 BY .83 TOOLTIP "Controla Seriais"
     text-2 AT ROW 1.04 COL 49 COLON-ALIGNED NO-LABEL
     text-1 AT ROW 5.58 COL 49 COLON-ALIGNED NO-LABEL
     RECT-20 AT ROW 6 COL 49
     RECT-21 AT ROW 1.5 COL 49
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.item,mgdis.item-dist
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
         HEIGHT             = 11.08
         WIDTH              = 78.57.
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

/* SETTINGS FOR FILL-IN c-cod-un-padrao IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN c-cod-un-padrao-2 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN c-cod-un-padrao-3 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       cb-unid-fatur:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN item.codigo-orig IN FRAME f-main
   EXP-FORMAT                                                           */
/* SETTINGS FOR TOGGLE-BOX item-dist.log-1 IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN text-1 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN text-2 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
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

&Scoped-define SELF-NAME item.cod-localiz
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.cod-localiz V-table-Win
ON F5 OF item.cod-localiz IN FRAME f-main /* Localizaá∆o */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="inzoom\z01in189.w"
                     &campo=item.cod-localiz
                     &campozoom=cod-localiz}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.cod-localiz V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item.cod-localiz IN FRAME f-main /* Localizaá∆o */
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item.deposito-pad
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.deposito-pad V-table-Win
ON F5 OF item.deposito-pad IN FRAME f-main /* Dep¢sito Padr∆o */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="inzoom\z01in084.w"
                     &campo=item.deposito-pad
                     &campozoom=cod-depos}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.deposito-pad V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item.deposito-pad IN FRAME f-main /* Dep¢sito Padr∆o */
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

  {utp/ut-rtlbl.i mgind item tipo-contr text-2}
  {utp/ut-rtlbl.i mgind item tipo-con-est text-1}

  if item.deposito-pad:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name} then.
  if item.cod-localiz:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name} then.

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
  {src/adm/template/row-list.i "item-dist"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "item"}
  {src/adm/template/row-find.i "item-dist"}

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

  {utp/ut-rtlbl.i mgind item tipo-contr text-2}
  {utp/ut-rtlbl.i mgind item tipo-con-est text-1}

  &IF '{&bf_dis_versao_ems}' >= '2.062' &THEN
      ASSIGN cb-unid-fatur:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ENTRY(1,c-lista-unid).
  &ENDIF

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
  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.

  /* Ponha aqui a validaá∆o de chave duplicada */

  /* Ponha aqui as demais validaá‰es */

  /* Obs.: CASO A VALIDAÄ«O FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  if RETURN-VALUE = 'ADM-ERROR':U then 
     RETURN 'ADM-ERROR':U.

  /* Variaveis utilizadas na integraá∆o EMS2/NEOLOG */
  {cdp/cdapi090def.i}

  IF adm-new-record THEN DO:
     /* Include respons†vel pela envio de dados do EMS2 ao NEOLOG */
     {cdp/cdapi090.i CREATE item}
  END.
  ELSE DO:
     {cdp/cdapi090.i UPSERT item}
  END.

  /* Code placed here will execute AFTER standard behavior.    */

     &IF "{&bf_dis_versao_ems}" >= "2.062" &THEN
       CASE cb-unid-fatur:SCREEN-VALUE IN FRAME {&FRAME-NAME}:
           WHEN ENTRY(1,c-lista-unid) THEN
               ASSIGN item.ind-inf-qtf = NO. 
           WHEN ENTRY(2,c-lista-unid) THEN
               ASSIGN item.ind-inf-qtf = YES.  
           WHEN ENTRY(3,c-lista-unid) THEN
               ASSIGN item.ind-inf-qtf = ?. 
       END CASE.
    &ENDIF

    IF CONNECTED('mgscm') THEN DO:
        IF item.cod-obsoleto = 1 THEN DO:
            IF NOT VALID-HANDLE(hDBOproxy) THEN
                RUN wmp/wmprx044.p PERSISTENT SET hDBOproxy.
            EMPTY TEMP-TABLE ttItemReplica.
            CREATE ttItemReplica.
            ASSIGN ttItemReplica.it-codigo    = ITEM.it-codigo  
                   ttItemReplica.desc-item    = ITEM.desc-item
                   ttItemReplica.unid-med     = ITEM.un
                   ttItemReplica.peso-bruto   = ITEM.peso-bruto
                   ttItemReplica.largura      = ITEM.largura
                   ttItemReplica.comprimento  = ITEM.comprim
                   ttItemReplica.altura       = ITEM.altura
                   ttItemReplica.tipo-con-est = ITEM.tipo-con-est
                   ttItemReplica.fm-cod-com   = ITEM.fm-cod-com
                   ttItemReplica.fm-codigo    = ITEM.fm-codigo.
            RUN ReplicaItem IN hDBOproxy(INPUT TABLE ttItemReplica,
                                         OUTPUT TABLE RowErrors).
            IF RETURN-VALUE = 'NOK':U THEN DO:
                FOR EACH RowErrors:
                    RUN utp/ut-msgs.p (INPUT "show":U,
                                       INPUT RowErrors.ErrorNumber,
                                       INPUT RowErrors.ErrorParameters).
                END.
                RUN destroy IN hDBOproxy.
                RETURN "ADM-ERROR":U.
            END.
            RUN destroy IN hDBOproxy.
        END.
    END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

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
  
  &IF '{&bf_dis_versao_ems}' >= '2.062' &THEN
      ASSIGN cb-unid-fatur:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
  &ENDIF

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

  IF AVAIL item  THEN DO:
    &IF '{&bf_dis_versao_ems}' >= '2.062' &THEN
        ASSIGN item.ind-inf-qtf:HIDDEN IN FRAME {&frame-name} = YES.
        CASE ITEM.ind-inf-qtf:
            WHEN NO THEN DO:
                ASSIGN cb-unid-fatur:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ENTRY(1,c-lista-unid).
            END.
            WHEN YES THEN DO:
                ASSIGN cb-unid-fatur:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ENTRY(2,c-lista-unid).
            END.
            OTHERWISE DO:
                ASSIGN cb-unid-fatur:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ENTRY(3,c-lista-unid).
            END.
        END CASE.
    &ELSE
        ASSIGN item.ind-inf-qtf:HIDDEN IN FRAME {&frame-name} = NO.
    &ENDIF
  END.

  find first para-fat no-lock no-error.
  if avail para-fat then 
      assign c-cod-un-padrao:screen-value in frame {&frame-name} = para-fat.cod-un-padrao
             c-cod-un-padrao-2:screen-value in frame {&frame-name} = para-fat.cod-un-padrao
             c-cod-un-padrao-3:screen-value in frame {&frame-name} = para-fat.cod-un-padrao.

  ASSIGN item-dist.log-1:HIDDEN IN FRAME {&FRAME-NAME} = TRUE.

  FIND FIRST funcao
       WHERE funcao.cd-funcao = "spp-seriais-nf":U AND
             funcao.ativo     = YES                NO-LOCK NO-ERROR.

  IF AVAIL funcao THEN DO:
      &IF DEFINED (bf_dis_versao_ems) &THEN
          &IF '{&bf_dis_versao_ems}' >= '2.05' &THEN
              ASSIGN item-dist.log-1:HIDDEN IN FRAME {&FRAME-NAME} = NO.
          &ENDIF
      &ENDIF
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

  &IF '{&bf_dis_versao_ems}' >= '2.062' &THEN
      ASSIGN cb-unid-fatur:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
  &ENDIF
  
  /* Code placed here will execute PRIOR to standard behavior. */
  run get-attribute ('adm-new-record').

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ).

  ASSIGN item-dist.log-1:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

  FIND FIRST funcao
       WHERE funcao.cd-funcao = "spp-seriais-nf":U AND
             funcao.ativo     = YES                NO-LOCK NO-ERROR.

  IF AVAIL funcao THEN DO:
      &IF DEFINED (bf_dis_versao_ems) &THEN
          &IF '{&bf_dis_versao_ems}' >= '2.05' &THEN
              ASSIGN item-dist.log-1:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
          &ENDIF
      &ENDIF
  END.

  find first param-global no-lock no-error.
  find first it-nota-fisc
       where it-nota-fisc.it-codigo = item.it-codigo no-lock no-error.
  if  not param-global.modulo-ce
      and not avail it-nota-fisc then
      enable item.tipo-con-est
             item.tipo-contr with frame {&frame-name}.
  else
      disable item.tipo-con-est
              item.tipo-contr with frame {&frame-name}.               


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

  &IF '{&bf_dis_versao_ems}' >= '2.062' &THEN
      DO WITH FRAME {&FRAME-NAME}:
          ASSIGN c-lista-unid = "Unidade do Item,Unidade da Fam°lia,Unidade do Faturamento".
          DO i-cont = 1 TO NUM-ENTRIES(c-lista-unid):
              ASSIGN c-aux = ENTRY(i-cont,c-lista-unid,",").
              RUN utp/ut-liter.p (INPUT replace(c-aux," ","_"), "", "").
              ASSIGN ENTRY(i-cont,c-lista-unid,",") = TRIM(RETURN-VALUE).
          END.
          ASSIGN cb-unid-fatur:LIST-ITEMS = c-lista-unid.
      END.
  &ENDIF
  
  &IF '{&bf_dis_versao_ems}' >= '2.062' &THEN
      DO WITH FRAME {&FRAME-NAME}:
          ASSIGN item.ind-inf-qtf:HIDDEN = YES
                 cb-unid-fatur:HIDDEN    = NO
                 ITEM.ind-item-fat:COL   = 22
                 ITEM.ind-item-fat:ROW   = 10
                 ITEM.loc-unica:COL      = 50
                 ITEM.loc-unica:ROW      = 10
                 ITEM.baixa-estoq:COL    = 22
                 ITEM.baixa-estoq:ROW    = 10.75.
          IF  i-pais-impto-usuario = 1 THEN
              ASSIGN c-cod-un-padrao-2:HIDDEN = YES
                     c-cod-un-padrao-3:HIDDEN = YES
                     c-cod-un-padrao:HIDDEN   = YES.
      END.
  &ELSE
      ASSIGN item.ind-inf-qtf:HIDDEN IN FRAME {&frame-name} = NO.
  &ENDIF

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

/*  assign item.codigo-orig:screen-value in frame {&frame-name} = string(0).*/

  /* Code placed here will execute AFTER standard behavior.    */

  ASSIGN item-dist.log-1:HIDDEN  IN FRAME {&FRAME-NAME} = TRUE
         cb-unid-fatur:SENSITIVE IN FRAME {&FRAME-NAME} = NO.  

  FIND FIRST funcao
       WHERE funcao.cd-funcao = "spp-seriais-nf":U AND
             funcao.ativo     = YES                NO-LOCK NO-ERROR.

  IF AVAIL funcao THEN DO:
      &IF DEFINED (bf_dis_versao_ems) &THEN
        &IF '{&bf_dis_versao_ems}' >= '2.05' &THEN
            ASSIGN item-dist.log-1:HIDDEN IN FRAME {&FRAME-NAME} = FALSE.        
        &ENDIF
        &IF '{&bf_dis_versao_ems}' >= '2.062' &THEN
            ASSIGN item-dist.log-1:COL IN FRAME {&FRAME-NAME} = 50
                   item-dist.log-1:ROW IN FRAME {&FRAME-NAME} = 10.75.
        &ENDIF
    &ENDIF
  END.

  {include/i-epcgeneric.i END-LOCAL-INITIALIZE VIEWER this-procedure {&FRAME-NAME} ITEM ROWID(ITEM)}

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

def var c-item like item.it-codigo no-undo.
def var h-boeb102 as handle no-undo.
def var l-erro as log no-undo.

RUN Who-Is-The-Container IN adm-broker-hdl
    (INPUT this-procedure, OUTPUT c-handle).
assign wh-cd0903 = widget-handle(c-handle).


if input frame {&frame-name} item.peso-liquido >
   input frame {&frame-name} item.peso-bruto then do:
   run utp/ut-msgs.p (input "show",
                      input 3912,
                      input return-value).
   run select-page in wh-cd0903 (2).
   apply "entry" to item.peso-liquido.
   return "adm-error":U.
end.

/*** Validaá∆o da Origem do Item************/
/*if input frame {&frame-name} item.codigo-orig > 8 then do:
   run utp/ut-msgs.p (input "show",
                      input 158,
                      input "Origem" + "~~" + "Conforme Tabela A - Origem da Mercadoria ou Serviáo.").
   run select-page in wh-cd0903 (2).
   apply "entry" to item.codigo-orig.
   return "adm-error":U.
end.*/


if not can-find (deposito where 
                 deposito.cod-depos = item.deposito-pad:screen-value in frame {&frame-name}) then do:
   {utp/ut-field.i mgind item deposito-pad 1}
   run utp/ut-msgs.p (input "show",
                      input 47,
                      input return-value).
   run select-page in wh-cd0903 (2).
   apply "entry" to item.deposito-pad. 
   return "adm-error":U.
end.

if item.cod-localiz:screen-value in frame {&frame-name} <> "" then do:
  if not can-find(first localizacao where 
                        localizacao.cod-localiz = item.cod-localiz:screen-value in frame {&frame-name}) then do:
     {utp/ut-field.i mgind item cod-localiz 1}
     run utp/ut-msgs.p (input "show",
                        input 47,
                        input return-value).
     run select-page in wh-cd0903 (2).
     apply "entry" to item.cod-localiz. 
     return "adm-error".
  end.                   
end.

/* if integer(item.codigo-orig:screen-value) > 7 then do: */
/*    {utp/ut-field.i mgind item deposito-pad 1}          */
/*    run utp/ut-msgs.p (input "show",                    */
/*                       input 26703,                     */
/*                       input return-value).             */
/*    run select-page in wh-cd0903 (2).                   */
/*    apply "entry" to item.codigo-orig.                  */
/*    return "adm-error":U.                               */
/* end.                                                   */


/*************************************************************************
***** chamado do programa ebcd0903 para validar os atributos do item *****
***** (peso, altura, comprimento, largura) n∆o podem estar zerados   *****
*****                                                                ***** 
*************************************************************************/

    find param-global no-lock no-error.
     if avail param-global and param-global.dec-2 = 1 and l-embalagem then do:
        RUN Get-Field-Screen-Value IN adm-broker-hdl(this-procedure, "it-codigo").
        assign c-item = return-value.
        run scbo/bosc063.p persistent set h-bosc063.
        run goToItem in h-bosc063 (input c-item).
        if return-value = "nok" then do:
           {utp/ut-liter.i Embalagem *}
           RUN utp/ut-msgs.p (INPUT "SHOW":U,
                              INPUT 25990,
                              INPUT  Return-value ).
           run select-page in wh-cd0903 (2).
           apply "entry" to item.peso-liquido.
           return "adm-error":U.
        end.
        else do:
          if input frame {&frame-name} item.peso-liquido = 0 or
             input frame {&frame-name} item.largura = 0 or
             input frame {&frame-name} item.comprim = 0 or
             input frame {&frame-name} item.altura = 0 then do:
                {utp/ut-liter.i Embalagem *}
                RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                   INPUT 25458,
                                   INPUT  Return-value ).
                run select-page in wh-cd0903 (2).
                apply "entry" to item.peso-liquido.
                return "adm-error":U.
          end.      
          else do:
             run atualizaEmbalagem in h-bosc063 (input c-item,
                                                 input input frame {&frame-name} item.peso-liquido,
                                                 input input frame {&frame-name} item.altura,
                                                 input input frame {&frame-name} item.comprim,
                                                 input input frame {&frame-name} item.largura,
                                                 input input frame {&frame-name} item.peso-bruto).   
          end.                     
        end.
        delete procedure h-bosc063.
     end.
           

&IF '{&bf_dis_versao_ems}' >= '2.062' &THEN
    if not avail para-ped then
      find first para-ped no-lock no-error.

    if input frame {&frame-name} item.baixa-estoq <> item.baixa-estoq and 
       para-ped.tp-aloca-ped = 3 /*** Alocaá∆o F°sica ***/  and
    &IF '{&BF_DIS_VERSAO_EMS}' >= '2.09' &THEN  
       para-ped.aloca-prog-entreg THEN DO:
     &ELSE
       substr(para-ped.char-1,20,1) = "1" THEN DO:
    &ENDIF
    
           if can-find (first saldo-estoq where
                              saldo-estoq.it-codigo   = item.it-codigo and
                              saldo-estoq.cod-refer   = item.cod-refer and
                              saldo-estoq.qt-aloc-ped > 0) and
              can-find(first ped-item 
                       where ped-item.it-codigo = item.it-codigo
                         and ped-item.cod-sit-item = 1 /** Aberto **/
                         or  ped-item.cod-sit-item = 2 /** Parcial **/ ) then do:

                     run utp/ut-msgs.p (input "show", input 34484, input ""). /* alerta */
           end.
    end.
&ENDIF


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
  {src/adm/template/snd-list.i "item-dist"}

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

