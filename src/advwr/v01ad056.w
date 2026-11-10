&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
          mguni            PROGRESS
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
{include/i-prgvrs.i V01AD056 2.00.00.046 } /*** "010046" 16/09/2026 14:00:06 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v01ad056 MUT}
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

{utp/ut-glob.i}
{include/i_prdvers.i}
def var de-cotacao   as dec        no-undo.
def var i-ind        as integer    no-undo.
def var i-dias       as integer    no-undo. 
def var c-mes        as character  format "999999" no-undo.
def var i-mes        as integer    no-undo.
def var c-periodo    as character  format "999999" no-undo.
def var c-formato    as char       no-undo.
def var d-cota-media-ant  as dec init 0 no-undo.
def var i-control-replica as int init 1 no-undo.
DEFINE VARIABLE h-cd0103-crm    AS HANDLE  NO-UNDO.
DEFINE VARIABLE lIntCRM11       AS LOGICAL NO-UNDO INITIAL FALSE.
DEFINE VARIABLE l-assignRecord  AS LOGICAL NO-UNDO.

RUN utp/ut-crm11.p ( OUTPUT lIntCRM11) .

/*--- possibilita utilizar o   Modulo Multiplanta Financeiro (MMF) ---*/
def var l-ok-mmf     as logical  initial yes   no-undo.
def var c-empr       as char                   no-undo.


/***************Multiplanta********************/

def var i-tipo-movto as integer            no-undo.
def var l-cria       as logical initial no no-undo.

{cdp/cd7300.i1}
{cdp/cdapi210.i}
{mcinc/mcapi283.i}
def temp-table tt-dados-env-SMC    no-undo like tt-dados-env.
def temp-table tt-replica-msg-SMC  no-undo like tt-replica-msg.
def temp-table tt-control-env-SMC  no-undo like tt-control-env.
def temp-table tt-integracao-SMC   no-undo like tt-integracao.
/*****************Fim*****************************/

/*** Vari veis para integra‡Æo EMS x SISDOC ***/
def var i-integracao-sisdoc as integer init ?  no-undo.
def var c-handle            as char            no-undo.
def var c-opcao-int         as char            no-undo.
def var i-retorno-erro      as integer init ?  no-undo.
    /* ** 5 => Quando parƒmetro "nao-integra" e o registro j  est  integrado **
       ** 6 => Erro de integra‡Æo no SISDOC                                  **
       ** 7 => Erro de integra‡Æo no EMS                                     ** */
/********* Fim vari veis para integra‡Æo ******/

def buffer b-cotacao for cotacao.
def var i as int no-undo.


/*  Integracao do EMS X Magnus                          */
{cdp/cdcfgfin.i}
{cdp/cd0001i1.i}
{btb/btb008za.i0}
{include/i-freeac.i} /* include para tirar acentua‡Æo */


{cdp/cdcfgdis.i}

/*fut36887 - XML Adapters*/
{include/i_dbvers.i}
&IF "{&mgadm_version}" >= "2.04" &THEN
    DEF VAR hShowMsg          AS HANDLE NO-UNDO.
    DEF NEW GLOBAL SHARED VAR v_log_eai_habilit AS LOG NO-UNDO.
    DEF VAR h-adapter AS HANDLE.

    DEFINE TEMP-TABLE RowErrors NO-UNDO
        FIELD ErrorSequence    AS INTEGER
        FIELD ErrorNumber      AS INTEGER
        FIELD ErrorDescription AS CHARACTER
        FIELD ErrorParameters  AS CHARACTER
        FIELD ErrorType        AS CHARACTER
        FIELD ErrorHelp        AS CHARACTER
        FIELD ErrorSubType     AS CHARACTER
        index seq ErrorSequence.

    DEFINE TEMP-TABLE tt_log_erro NO-UNDO
         FIELD ttv_num_cod_erro AS integer INITIAL ?
         FIELD ttv_des_msg_ajuda AS character INITIAL ?
         FIELD ttv_des_msg_erro AS character INITIAL ?.
&endif
/*fut36887 - XML Adapters*/


def var   i-ind-tipo-movto       as integer      no-undo.
def var   i-indice               as integer      no-undo.

def temp-table tt-cotacao-mg NO-UNDO
    field mo-codigo      as integer   format ">9"
    field ano-periodo    as character format "9999/99"
    field cotacao        as decimal   format ">>>,>>9.9999999" extent 31
    field cota-mensal    as decimal   format ">>>,>>9.9999999"
    field cota-media     as decimal   format ">>>,>>9.9999999"
    field usuario        as character format "x(12)"           extent 31
    field char-1         as character format "x(255)"
    field dec-1          as decimal   format "->>>>>>>>>>>9.9"
    field int-1          as integer   format "->>>>>>>>>9"
    field log-1          as logical   format "Sim/Nao"
    field dec-2          as decimal   format "-999999999999.9"
    field u-dec-1        as decimal   format "-999999999999.9"
    field u-dec-2        as decimal   format "-999999999999.9"
    field char-2         as character format "x(255)"
    field u-char-1       as character format "x(255)"
    field u-char-2       as character format "x(255)"
    field int-2          as integer   format "-9999999999"
    field u-int-1        as integer   format "-9999999999"
    field u-int-2        as integer   format "-9999999999"
    field ind-tipo-movto as integer   format "9"
    field l-atualiza     as logical   format "Sim/Nao".

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
&Scoped-define EXTERNAL-TABLES cotacao
&Scoped-define FIRST-EXTERNAL-TABLE cotacao


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR cotacao.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS cotacao.cota-media cotacao.cota-mensal ~
cotacao.cotacao[1] cotacao.cotacao[2] cotacao.cotacao[3] cotacao.cotacao[4] ~
cotacao.cotacao[5] cotacao.cotacao[6] cotacao.cotacao[7] cotacao.cotacao[8] ~
cotacao.cotacao[9] cotacao.cotacao[10] cotacao.cotacao[11] ~
cotacao.cotacao[12] cotacao.cotacao[13] cotacao.cotacao[14] ~
cotacao.cotacao[15] cotacao.cotacao[16] cotacao.cotacao[17] ~
cotacao.cotacao[18] cotacao.cotacao[19] cotacao.cotacao[20] ~
cotacao.cotacao[21] cotacao.cotacao[22] cotacao.cotacao[23] ~
cotacao.cotacao[24] cotacao.cotacao[25] cotacao.cotacao[26] ~
cotacao.cotacao[27] cotacao.cotacao[28] cotacao.cotacao[29] ~
cotacao.cotacao[30] cotacao.cotacao[31] 
&Scoped-define ENABLED-TABLES cotacao
&Scoped-define FIRST-ENABLED-TABLE cotacao
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS cotacao.mo-codigo cotacao.cota-media ~
cotacao.cota-mensal cotacao.cotacao[1] cotacao.cotacao[2] ~
cotacao.cotacao[3] cotacao.cotacao[4] cotacao.cotacao[5] cotacao.cotacao[6] ~
cotacao.cotacao[7] cotacao.cotacao[8] cotacao.cotacao[9] ~
cotacao.cotacao[10] cotacao.cotacao[11] cotacao.cotacao[12] ~
cotacao.cotacao[13] cotacao.cotacao[14] cotacao.cotacao[15] ~
cotacao.cotacao[16] cotacao.cotacao[17] cotacao.cotacao[18] ~
cotacao.cotacao[19] cotacao.cotacao[20] cotacao.cotacao[21] ~
cotacao.cotacao[22] cotacao.cotacao[23] cotacao.cotacao[24] ~
cotacao.cotacao[25] cotacao.cotacao[26] cotacao.cotacao[27] ~
cotacao.cotacao[28] cotacao.cotacao[29] cotacao.cotacao[30] ~
cotacao.cotacao[31] 
&Scoped-define DISPLAYED-TABLES cotacao
&Scoped-define FIRST-DISPLAYED-TABLE cotacao
&Scoped-Define DISPLAYED-OBJECTS c_descricao_moeda c-ano-per 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS cotacao.mo-codigo c-ano-per 
&Scoped-define ADM-MODIFY-FIELDS cotacao.cota-media cotacao.cota-mensal ~
cotacao.cotacao[1] cotacao.cotacao[2] cotacao.cotacao[3] cotacao.cotacao[4] ~
cotacao.cotacao[5] cotacao.cotacao[6] cotacao.cotacao[7] cotacao.cotacao[8] ~
cotacao.cotacao[9] cotacao.cotacao[10] cotacao.cotacao[11] ~
cotacao.cotacao[12] cotacao.cotacao[13] cotacao.cotacao[14] ~
cotacao.cotacao[15] cotacao.cotacao[16] cotacao.cotacao[17] ~
cotacao.cotacao[18] cotacao.cotacao[19] cotacao.cotacao[20] ~
cotacao.cotacao[21] cotacao.cotacao[22] cotacao.cotacao[23] ~
cotacao.cotacao[24] cotacao.cotacao[25] cotacao.cotacao[26] ~
cotacao.cotacao[27] cotacao.cotacao[28] cotacao.cotacao[29] ~
cotacao.cotacao[30] cotacao.cotacao[31] 

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
DEFINE VARIABLE c-ano-per AS CHARACTER FORMAT "999999" 
     LABEL "":R9 
     VIEW-AS FILL-IN 
     SIZE 10.57 BY .88.

DEFINE VARIABLE c_descricao_moeda AS CHARACTER FORMAT "x(12)" 
     VIEW-AS FILL-IN 
     SIZE 16.43 BY .88.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 2.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 12.67.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     cotacao.mo-codigo AT ROW 1.21 COL 16.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.86 BY .88
     c_descricao_moeda AT ROW 1.21 COL 20.43 COLON-ALIGNED NO-LABEL
     c-ano-per AT ROW 2.21 COL 16.43 COLON-ALIGNED
     cotacao.cota-media AT ROW 3.67 COL 19 COLON-ALIGNED FORMAT "->>>,>>9.99999999"
          VIEW-AS FILL-IN 
          SIZE 19.86 BY .88
     cotacao.cota-mensal AT ROW 3.67 COL 60.86 COLON-ALIGNED FORMAT "->>>,>>9.99999999"
          VIEW-AS FILL-IN 
          SIZE 19.86 BY .88
     cotacao.cotacao[1] AT ROW 4.92 COL 6.86 COLON-ALIGNED NO-LABEL FORMAT "->>>,>>9.99999999"
          VIEW-AS FILL-IN 
          SIZE 19.86 BY .88
     cotacao.cotacao[2] AT ROW 5.92 COL 6.86 COLON-ALIGNED NO-LABEL FORMAT "->>>,>>9.99999999"
          VIEW-AS FILL-IN 
          SIZE 19.86 BY .88
     cotacao.cotacao[3] AT ROW 6.92 COL 6.86 COLON-ALIGNED NO-LABEL FORMAT "->>>,>>9.99999999"
          VIEW-AS FILL-IN 
          SIZE 19.86 BY .88
     cotacao.cotacao[4] AT ROW 7.92 COL 6.86 COLON-ALIGNED NO-LABEL FORMAT "->>>,>>9.99999999"
          VIEW-AS FILL-IN 
          SIZE 19.86 BY .88
     cotacao.cotacao[5] AT ROW 8.92 COL 6.86 COLON-ALIGNED NO-LABEL FORMAT "->>>,>>9.99999999"
          VIEW-AS FILL-IN 
          SIZE 19.86 BY .88
     cotacao.cotacao[6] AT ROW 9.92 COL 6.86 COLON-ALIGNED NO-LABEL FORMAT "->>>,>>9.99999999"
          VIEW-AS FILL-IN 
          SIZE 19.86 BY .88
     cotacao.cotacao[7] AT ROW 10.92 COL 6.86 COLON-ALIGNED NO-LABEL FORMAT "->>>,>>9.99999999"
          VIEW-AS FILL-IN 
          SIZE 19.86 BY .88
     cotacao.cotacao[8] AT ROW 11.92 COL 6.86 COLON-ALIGNED NO-LABEL FORMAT "->>>,>>9.99999999"
          VIEW-AS FILL-IN 
          SIZE 19.86 BY .88
     cotacao.cotacao[9] AT ROW 12.92 COL 6.86 COLON-ALIGNED NO-LABEL FORMAT "->>>,>>9.99999999"
          VIEW-AS FILL-IN 
          SIZE 19.86 BY .88
     cotacao.cotacao[10] AT ROW 13.92 COL 6.86 COLON-ALIGNED NO-LABEL FORMAT "->>>,>>9.99999999"
          VIEW-AS FILL-IN 
          SIZE 19.86 BY .88
     cotacao.cotacao[11] AT ROW 14.92 COL 6.86 COLON-ALIGNED NO-LABEL FORMAT "->>>,>>9.99999999"
          VIEW-AS FILL-IN 
          SIZE 19.86 BY .88
     cotacao.cotacao[12] AT ROW 4.92 COL 36.14 COLON-ALIGNED NO-LABEL FORMAT "->>>,>>9.99999999"
          VIEW-AS FILL-IN 
          SIZE 19.86 BY .88
     cotacao.cotacao[13] AT ROW 5.92 COL 36.14 COLON-ALIGNED NO-LABEL FORMAT "->>>,>>9.99999999"
          VIEW-AS FILL-IN 
          SIZE 19.86 BY .88
     cotacao.cotacao[14] AT ROW 6.92 COL 36.14 COLON-ALIGNED NO-LABEL FORMAT "->>>,>>9.99999999"
          VIEW-AS FILL-IN 
          SIZE 19.86 BY .88
     cotacao.cotacao[15] AT ROW 7.92 COL 36.14 COLON-ALIGNED NO-LABEL FORMAT "->>>,>>9.99999999"
          VIEW-AS FILL-IN 
          SIZE 19.86 BY .88
     cotacao.cotacao[16] AT ROW 8.92 COL 36.14 COLON-ALIGNED NO-LABEL FORMAT "->>>,>>9.99999999"
          VIEW-AS FILL-IN 
          SIZE 19.86 BY .88
     cotacao.cotacao[17] AT ROW 9.92 COL 36.14 COLON-ALIGNED NO-LABEL FORMAT "->>>,>>9.99999999"
          VIEW-AS FILL-IN 
          SIZE 19.86 BY .88
     cotacao.cotacao[18] AT ROW 10.92 COL 36.14 COLON-ALIGNED NO-LABEL FORMAT "->>>,>>9.99999999"
          VIEW-AS FILL-IN 
          SIZE 19.86 BY .88
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME f-main
     cotacao.cotacao[19] AT ROW 11.92 COL 36.14 COLON-ALIGNED NO-LABEL FORMAT "->>>,>>9.99999999"
          VIEW-AS FILL-IN 
          SIZE 19.86 BY .88
     cotacao.cotacao[20] AT ROW 12.92 COL 36.14 COLON-ALIGNED NO-LABEL FORMAT "->>>,>>9.99999999"
          VIEW-AS FILL-IN 
          SIZE 19.86 BY .88
     cotacao.cotacao[21] AT ROW 13.92 COL 36.14 COLON-ALIGNED NO-LABEL FORMAT "->>>,>>9.99999999"
          VIEW-AS FILL-IN 
          SIZE 19.86 BY .88
     cotacao.cotacao[22] AT ROW 14.92 COL 36.14 COLON-ALIGNED NO-LABEL FORMAT "->>>,>>9.99999999"
          VIEW-AS FILL-IN 
          SIZE 19.86 BY .88
     cotacao.cotacao[23] AT ROW 4.92 COL 65.86 COLON-ALIGNED NO-LABEL FORMAT "->>>,>>9.99999999"
          VIEW-AS FILL-IN 
          SIZE 19.86 BY .88
     cotacao.cotacao[24] AT ROW 5.92 COL 65.86 COLON-ALIGNED NO-LABEL FORMAT "->>>,>>9.99999999"
          VIEW-AS FILL-IN 
          SIZE 19.86 BY .88
     cotacao.cotacao[25] AT ROW 6.92 COL 65.86 COLON-ALIGNED NO-LABEL FORMAT "->>>,>>9.99999999"
          VIEW-AS FILL-IN 
          SIZE 19.86 BY .88
     cotacao.cotacao[26] AT ROW 7.92 COL 65.86 COLON-ALIGNED NO-LABEL FORMAT "->>>,>>9.99999999"
          VIEW-AS FILL-IN 
          SIZE 19.86 BY .88
     cotacao.cotacao[27] AT ROW 8.92 COL 65.86 COLON-ALIGNED NO-LABEL FORMAT "->>>,>>9.99999999"
          VIEW-AS FILL-IN 
          SIZE 19.86 BY .88
     cotacao.cotacao[28] AT ROW 9.92 COL 65.86 COLON-ALIGNED NO-LABEL FORMAT "->>>,>>9.99999999"
          VIEW-AS FILL-IN 
          SIZE 19.86 BY .88
     cotacao.cotacao[29] AT ROW 10.92 COL 65.86 COLON-ALIGNED NO-LABEL FORMAT "->>>,>>9.99999999"
          VIEW-AS FILL-IN 
          SIZE 19.86 BY .88
     cotacao.cotacao[30] AT ROW 11.92 COL 65.86 COLON-ALIGNED NO-LABEL FORMAT "->>>,>>9.99999999"
          VIEW-AS FILL-IN 
          SIZE 19.86 BY .88
     cotacao.cotacao[31] AT ROW 12.92 COL 65.86 COLON-ALIGNED NO-LABEL FORMAT "->>>,>>9.99999999"
          VIEW-AS FILL-IN 
          SIZE 19.86 BY .88
     rt-key AT ROW 1 COL 1.29
     rt-mold AT ROW 3.42 COL 1
     "12 -" VIEW-AS TEXT
          SIZE 4 BY 1 AT ROW 4.79 COL 34.14
     "23 -" VIEW-AS TEXT
          SIZE 4 BY 1 AT ROW 4.92 COL 63.57
     "  6 -" VIEW-AS TEXT
          SIZE 4 BY 1 AT ROW 9.92 COL 4.43
     "17 -" VIEW-AS TEXT
          SIZE 4 BY 1 AT ROW 9.79 COL 34.14
     "  2 -" VIEW-AS TEXT
          SIZE 4 BY 1 AT ROW 5.92 COL 4.43
     "24 -" VIEW-AS TEXT
          SIZE 4 BY 1 AT ROW 5.92 COL 63.57
     "14 -" VIEW-AS TEXT
          SIZE 4 BY 1 AT ROW 6.79 COL 34.14
     "20 -" VIEW-AS TEXT
          SIZE 4 BY 1 AT ROW 12.79 COL 34.14
     "26 -" VIEW-AS TEXT
          SIZE 4 BY 1 AT ROW 7.92 COL 63.57
     "  4 -" VIEW-AS TEXT
          SIZE 4 BY 1 AT ROW 7.92 COL 4.43
     "30 -" VIEW-AS TEXT
          SIZE 4 BY 1 AT ROW 11.92 COL 63.57
     "  8 -" VIEW-AS TEXT
          SIZE 4 BY 1 AT ROW 11.92 COL 4.43
     "16 -" VIEW-AS TEXT
          SIZE 4 BY 1 AT ROW 8.79 COL 34.14
     "  5 -" VIEW-AS TEXT
          SIZE 4 BY 1 AT ROW 8.92 COL 4.43
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME f-main
     "27 -" VIEW-AS TEXT
          SIZE 4 BY 1 AT ROW 8.92 COL 63.57
     "11 -" VIEW-AS TEXT
          SIZE 4 BY 1 AT ROW 14.92 COL 4.43
     "  1 -" VIEW-AS TEXT
          SIZE 4 BY 1 AT ROW 4.92 COL 4.43
     "18 -" VIEW-AS TEXT
          SIZE 4 BY 1 AT ROW 10.79 COL 34.14
     "22 -" VIEW-AS TEXT
          SIZE 4 BY 1 AT ROW 14.79 COL 34.14
     "  7 -" VIEW-AS TEXT
          SIZE 4 BY 1 AT ROW 10.92 COL 4.43
     "29 -" VIEW-AS TEXT
          SIZE 4 BY 1 AT ROW 10.92 COL 63.57
     "19 -" VIEW-AS TEXT
          SIZE 4 BY 1 AT ROW 11.79 COL 34.14
     "25 -" VIEW-AS TEXT
          SIZE 4 BY 1 AT ROW 6.92 COL 63.57
     "15 -" VIEW-AS TEXT
          SIZE 4 BY 1 AT ROW 7.79 COL 34.14
     "  9 -" VIEW-AS TEXT
          SIZE 4 BY 1 AT ROW 12.92 COL 4.43
     "  3 -" VIEW-AS TEXT
          SIZE 4 BY 1 AT ROW 6.92 COL 4.43
     "31 -" VIEW-AS TEXT
          SIZE 4 BY 1 AT ROW 12.92 COL 63.57
     "21 -" VIEW-AS TEXT
          SIZE 4 BY 1 AT ROW 13.79 COL 34.14
     "10 -" VIEW-AS TEXT
          SIZE 4 BY 1 AT ROW 13.92 COL 4.43
     "28 -" VIEW-AS TEXT
          SIZE 4 BY 1 AT ROW 9.92 COL 63.57
     "13 -" VIEW-AS TEXT
          SIZE 4 BY 1 AT ROW 5.79 COL 34.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.cotacao
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
         HEIGHT             = 15.21
         WIDTH              = 88.86.
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
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-ano-per IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN cotacao.cota-media IN FRAME f-main
   3 EXP-FORMAT                                                         */
/* SETTINGS FOR FILL-IN cotacao.cota-mensal IN FRAME f-main
   3 EXP-FORMAT                                                         */
/* SETTINGS FOR FILL-IN cotacao.cotacao[10] IN FRAME f-main
   3 EXP-FORMAT                                                         */
/* SETTINGS FOR FILL-IN cotacao.cotacao[11] IN FRAME f-main
   3 EXP-FORMAT                                                         */
/* SETTINGS FOR FILL-IN cotacao.cotacao[12] IN FRAME f-main
   3 EXP-FORMAT                                                         */
/* SETTINGS FOR FILL-IN cotacao.cotacao[13] IN FRAME f-main
   3 EXP-FORMAT                                                         */
/* SETTINGS FOR FILL-IN cotacao.cotacao[14] IN FRAME f-main
   3 EXP-FORMAT                                                         */
/* SETTINGS FOR FILL-IN cotacao.cotacao[15] IN FRAME f-main
   3 EXP-FORMAT                                                         */
/* SETTINGS FOR FILL-IN cotacao.cotacao[16] IN FRAME f-main
   3 EXP-FORMAT                                                         */
/* SETTINGS FOR FILL-IN cotacao.cotacao[17] IN FRAME f-main
   3 EXP-FORMAT                                                         */
/* SETTINGS FOR FILL-IN cotacao.cotacao[18] IN FRAME f-main
   3 EXP-FORMAT                                                         */
/* SETTINGS FOR FILL-IN cotacao.cotacao[19] IN FRAME f-main
   3 EXP-FORMAT                                                         */
/* SETTINGS FOR FILL-IN cotacao.cotacao[1] IN FRAME f-main
   3 EXP-FORMAT                                                         */
/* SETTINGS FOR FILL-IN cotacao.cotacao[20] IN FRAME f-main
   3 EXP-FORMAT                                                         */
/* SETTINGS FOR FILL-IN cotacao.cotacao[21] IN FRAME f-main
   3 EXP-FORMAT                                                         */
/* SETTINGS FOR FILL-IN cotacao.cotacao[22] IN FRAME f-main
   3 EXP-FORMAT                                                         */
/* SETTINGS FOR FILL-IN cotacao.cotacao[23] IN FRAME f-main
   3 EXP-FORMAT                                                         */
/* SETTINGS FOR FILL-IN cotacao.cotacao[24] IN FRAME f-main
   3 EXP-FORMAT                                                         */
/* SETTINGS FOR FILL-IN cotacao.cotacao[25] IN FRAME f-main
   3 EXP-FORMAT                                                         */
/* SETTINGS FOR FILL-IN cotacao.cotacao[26] IN FRAME f-main
   3 EXP-FORMAT                                                         */
/* SETTINGS FOR FILL-IN cotacao.cotacao[27] IN FRAME f-main
   3 EXP-FORMAT                                                         */
/* SETTINGS FOR FILL-IN cotacao.cotacao[28] IN FRAME f-main
   3 EXP-FORMAT                                                         */
/* SETTINGS FOR FILL-IN cotacao.cotacao[29] IN FRAME f-main
   3 EXP-FORMAT                                                         */
/* SETTINGS FOR FILL-IN cotacao.cotacao[2] IN FRAME f-main
   3 EXP-FORMAT                                                         */
/* SETTINGS FOR FILL-IN cotacao.cotacao[30] IN FRAME f-main
   3 EXP-FORMAT                                                         */
/* SETTINGS FOR FILL-IN cotacao.cotacao[31] IN FRAME f-main
   3 EXP-FORMAT                                                         */
/* SETTINGS FOR FILL-IN cotacao.cotacao[3] IN FRAME f-main
   3 EXP-FORMAT                                                         */
/* SETTINGS FOR FILL-IN cotacao.cotacao[4] IN FRAME f-main
   3 EXP-FORMAT                                                         */
/* SETTINGS FOR FILL-IN cotacao.cotacao[5] IN FRAME f-main
   3 EXP-FORMAT                                                         */
/* SETTINGS FOR FILL-IN cotacao.cotacao[6] IN FRAME f-main
   3 EXP-FORMAT                                                         */
/* SETTINGS FOR FILL-IN cotacao.cotacao[7] IN FRAME f-main
   3 EXP-FORMAT                                                         */
/* SETTINGS FOR FILL-IN cotacao.cotacao[8] IN FRAME f-main
   3 EXP-FORMAT                                                         */
/* SETTINGS FOR FILL-IN cotacao.cotacao[9] IN FRAME f-main
   3 EXP-FORMAT                                                         */
/* SETTINGS FOR FILL-IN c_descricao_moeda IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cotacao.mo-codigo IN FRAME f-main
   NO-ENABLE 1                                                          */
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

&Scoped-define SELF-NAME c-ano-per
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ano-per V-table-Win
ON ENTRY OF c-ano-per IN FRAME f-main
DO:

     assign c-ano-per:format in frame {&FRAME-NAME} = "9999/99".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ano-per V-table-Win
ON LEAVE OF c-ano-per IN FRAME f-main
DO:

   assign c-formato = input frame {&FRAME-NAME} c-ano-per no-error.
   if  error-status:get-number(1) <> 0 then do:
       assign c-ano-per:format in frame {&FRAME-NAME} = "x(06)".
   end.
   else do:
       assign c-ano-per:format in frame {&FRAME-NAME} = "9999/99".
   end.             

   assign cotacao.cotacao[29]:sensitive in frame {&FRAME-NAME} = no
          cotacao.cotacao[30]:sensitive in frame {&FRAME-NAME} = no
          cotacao.cotacao[31]:sensitive in frame {&FRAME-NAME} = no.

   assign c-ano-per = string(input frame {&FRAME-NAME} c-ano-per, "999999")
          c-mes     = substring(string(input frame {&FRAME-NAME} c-ano-per, "999999"), 05,02).


assign i-mes = int(substring(c-ano-per,5,2)).
if i-mes < 1  or i-mes > 12  then do:
    run utp/ut-msgs.p (input "show",
                       input 333,
                       input "").
    apply "entry" to c-ano-per in frame {&frame-name}.  
    return no-apply.  
end.  




find moeda where moeda.mo-codigo = input frame {&frame-name} cotacao.mo-codigo 
    no-lock no-error.

if  avail moeda then do: 
    if  lookup(c-mes,"01,03,05,07,08,10,12") <> 0 then do:
        assign i-ind = 31
               cotacao.cotacao[29]:sensitive in frame {&frame-name} = moeda.ind-variacao = 1
               cotacao.cotacao[30]:sensitive in frame {&frame-name} = moeda.ind-variacao = 1
               cotacao.cotacao[31]:sensitive in frame {&frame-name} = moeda.ind-variacao = 1.
    end.
    else do:
        if  lookup(c-mes,"04,06,09,11") <> 0 then do:
            assign i-ind = 30
                   cotacao.cotacao[29]:sensitive    in frame {&frame-name} = moeda.ind-variacao = 1
                   cotacao.cotacao[30]:sensitive    in frame {&frame-name} = moeda.ind-variacao = 1
                   cotacao.cotacao[31]:screen-value in frame {&FRAME-NAME} = '0'.

        end.
        else do:
            if  integer(substring(string(input frame {&FRAME-NAME} c-ano-per, "999999"), 01, 04)) mod 4 = 0 then do:
                assign i-ind = 29
                       cotacao.cotacao[29]:sensitive    in frame {&frame-name} = moeda.ind-variacao = 1
                       cotacao.cotacao[30]:screen-value in frame {&FRAME-NAME} = '0'
                       cotacao.cotacao[31]:screen-value in frame {&FRAME-NAME} = '0'.
            end.
            else do:
                assign i-ind = 28
                       cotacao.cotacao[29]:screen-value in frame {&FRAME-NAME} = '0'
                       cotacao.cotacao[30]:screen-value in frame {&FRAME-NAME} = '0'
                       cotacao.cotacao[31]:screen-value in frame {&FRAME-NAME} = '0'.
            end.
        end.
    end.
end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cotacao.cota-media
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cotacao.cota-media V-table-Win
ON LEAVE OF cotacao.cota-media IN FRAME f-main /* Cotacao Media */
DO:
    if  input frame {&FRAME-NAME} cotacao.cota-media <> 0 and
        input frame {&FRAME-NAME} cotacao.cotacao[1]  = 0 then do:
        RUN get-attribute ('adm-new-record':U).
        if  return-value = 'yes':U then do:     
            if i-control-replica = 1 then
                run utp/ut-msgs.p ("show",8143,"").

            if return-value <> 'yes':U and i-control-replica = 1 then
                assign i-control-replica = 2.
            else if return-value = 'yes':U and i-control-replica = 1 then
                assign i-control-replica = 3.

            if i-control-replica = 3 then do:

                assign c-mes = substring(string(c-ano-per /*input frame {&FRAME-NAME} cotacao.ano-periodo*/, "9999/99"), 06,02).

                if  lookup(c-mes,"01,03,05,07,08,10,12") <> 0 then do:
                    assign i-ind = 31.
                end.
                else do:
                    if  lookup(c-mes,"04,06,09,11") <> 0 then do:
                        assign i-ind = 30
                               cotacao.cotacao[31]:screen-value in frame {&FRAME-NAME} = '0'.
                    end.
                    else do:
                        if  integer(substring(string(c-ano-per,"9999/99"), 01,04)) mod 4 = 0 then do:
                            assign i-ind = 29
                                   cotacao.cotacao[30]:screen-value in frame {&FRAME-NAME} = '0'
                                   cotacao.cotacao[31]:screen-value in frame {&FRAME-NAME} = '0'.
                        end.
                        else do:
                            assign i-ind = 28
                                   cotacao.cotacao[29]:screen-value in frame {&FRAME-NAME} = '0'
                                   cotacao.cotacao[30]:screen-value in frame {&FRAME-NAME} = '0'
                                   cotacao.cotacao[31]:screen-value in frame {&FRAME-NAME} = '0'.
                        end.
                    end.
                end.

                do i = 1 to i-ind with frame {&frame-name}:
                    disp input cotacao.cota-media @ cotacao.cotacao[i].
                end.
            end.
        end.
    end.

    assign d-cota-media-ant = input frame {&FRAME-NAME} cotacao.cota-media.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cotacao.mo-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cotacao.mo-codigo V-table-Win
ON ENTRY OF cotacao.mo-codigo IN FRAME f-main /* Moeda */
DO:
    assign c-ano-per:format in frame {&FRAME-NAME} = "9999/99".  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&Scoped-define SELF-NAME cotacao.cota-media
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cotacao.cota-media V-table-Win
ON ENTRY OF cotacao.cota-media IN FRAME f-main /* Moeda */
DO:

    if d-cota-media-ant <> input frame f-main cotacao.cota-media then
        assign i-control-replica = 1.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cotacao.mo-codigo V-table-Win
ON F5 OF cotacao.mo-codigo IN FRAME f-main /* Moeda */
DO:
    assign l-implanta = yes.
    {include/zoom.i &prog-zoom=adzoom/z01ad178.w
                    &tabela=cotacao
                    &atributo=mo-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cotacao.mo-codigo V-table-Win
ON LEAVE OF cotacao.mo-codigo IN FRAME f-main /* Moeda */
DO:
{include/leave.i &tabela=moeda 
                 &where="moeda.mo-codigo = input frame {&frame-name} cotacao.mo-codigo"  
                 &atributo-ref=descricao
                 &variavel-ref=c_descricao_moeda}

find moeda where moeda.mo-codigo = input frame {&frame-name} cotacao.mo-codigo 
    no-lock no-error.
if  avail moeda then 
    if  moeda.ind-variacao = 1 then do
        with frame {&frame-name}: /* Di rio */
        do i = 1 to 31:
            enable cotacao.cotacao[i].
        end.
        enable cotacao.cota-media
               cotacao.cota-mensal with frame {&frame-name}.
    end.

apply "leave" to c-ano-per in frame {&frame-name}. 

if  avail moeda then do with frame {&frame-name}:

    assign cotacao.cota-mensal:sensitive = (moeda.ind-reajuste = 1 and moeda.ind-variacao = 1).

    if  moeda.ind-variacao = 2 or moeda.ind-reajuste = 2 then 
        assign cotacao.cota-mensal:format in frame {&frame-name} = "->>>,>>9.99999999".
    else 
        assign cotacao.cota-mensal:format in frame {&frame-name} = "->>>,>>9.99999999".
end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cotacao.mo-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF cotacao.mo-codigo IN FRAME f-main /* Moeda */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  {utp/ut-liter.i Per¡odo * L}.  
  assign c-ano-per:label in frame {&frame-name} = return-value.

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF
  if cotacao.mo-codigo:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
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
  {src/adm/template/row-list.i "cotacao"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "cotacao"}

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

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .
  assign c-ano-per:screen-value in frame {&frame-name} = string(string(year(today),"9999") + string(month(today),"99"), "999999").

  apply 'entry' to cotacao.mo-codigo in frame {&frame-name}.
  
  IF lIntCRM11 AND l-assignRecord THEN DO:
    IF NOT VALID-HANDLE(h-cd0103-crm) THEN
        RUN integracoes/adapters/emstocrm/cd0103-crm.p PERSISTENT SET h-cd0103-crm.

    RUN sendToCRM IN h-cd0103-crm (INPUT STRING(cotacao.mo-codigo), INPUT STRING(cotacao.ano-periodo), OUTPUT TABLE RowErrors).
    ASSIGN l-assignRecord = NO.
    
    IF CAN-FIND (FIRST RowErrors WHERE 
                       RowErrors.ErrorSubType = "ERROR":U) THEN DO:
        {method/ShowMessage.i1}
        {method/ShowMessage.i2 &Modal="YES"}

        DELETE PROCEDURE h-cd0103-crm.
        UNDO, RETURN "ADM-ERROR":U.
    END.

    DELETE PROCEDURE h-cd0103-crm.
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
do transaction:
    define var i-cont as integer no-undo.
    DEFINE VARIABLE d-data-cotacao AS DATE    NO-UNDO.
    DEFINE VARIABLE i-ano-calc     AS INTEGER NO-UNDO.
    DEFINE VARIABLE i-mes-calc     AS INTEGER NO-UNDO.

    assign input frame {&FRAME-NAME} c-ano-per.
    if  cotacao.mo-codigo:screen-value in frame {&frame-name} = "0" and c-ano-per = " " then do:
        run utp/ut-msgs.p (input "show",
                           input 7761,
                           input "").
        apply "entry" to c-ano-per in frame {&frame-name}.
        return "adm-error".
    end.
    else do:
        find first b-cotacao no-lock
            where  b-cotacao.mo-codigo   = input frame {&frame-name} cotacao.mo-codigo
            and    b-cotacao.ano-periodo = c-ano-per no-error.

        if  cotacao.mo-codigo:sensitive then do:
            if  avail b-cotacao then do:
                {utp/ut-liter.i Cota‡Æo * R}
                run utp/ut-msgs.p (input "show",
                                   input 1,
                                   input trim(return-value)).
                apply "entry" to cotacao.mo-codigo in frame {&frame-name}.
                return "adm-error".
            end.
        end.
    end.

    find first moeda no-lock
         where moeda.mo-codigo = input frame {&frame-name} cotacao.mo-codigo no-error.

    {utp/ut-liter.i mgadm moeda mo-codigo 1}    
    if  not avail moeda then do:
        run utp/ut-msgs.p (input "show",
                           input 4929,
                           input input frame {&frame-name} cotacao.mo-codigo).
        apply "entry" to cotacao.mo-codigo in frame {&frame-name}.
        return "adm-error".
    end.

    assign c-periodo = c-ano-per.

    /*--- NÇO TIRAR ESTE CàDIGO ---*/
    apply 'leave' to c-ano-per in frame {&FRAME-NAME}.

    /*fut36887 - XML Adapter*/
    /* Gera cota‡Æo m‚dia ? */
    run utp/ut-msgs.p (input "show",
                       input 8463,
                       input "").

    if  return-value = 'yes':U then do:
        assign de-cotacao = 0
               i-dias     = 0
               i-ano-calc = INTEGER(SUBSTRING(c-ano-per, 1, 4))
               i-mes-calc = INTEGER(SUBSTRING(c-ano-per, 5, 2)).
               
        IF moeda.log-consid-dias-uteis = YES THEN DO:
            do  i-cont = 1 to i-ind:
                ASSIGN d-data-cotacao = DATE(i-mes-calc, i-cont, i-ano-calc).
                
                FIND FIRST calen-data NO-LOCK
                     WHERE calen-data.cd-calen = moeda.cod-calend
                       AND calen-data.data  = d-data-cotacao NO-ERROR.
                IF AVAILABLE calen-data AND calen-data.tipo-dia = 1 THEN DO:
                    ASSIGN de-cotacao = de-cotacao + INPUT FRAME {&FRAME-NAME} cotacao.cotacao[i-cont]
                           i-dias     = i-dias + 1.
                END.
            END.
        end.
        ELSE DO:
            do  i-cont = 1 to i-ind:
                if (INPUT FRAME {&FRAME-NAME} cotacao.cotacao[i-cont] <> 0) then 
                    assign de-cotacao = de-cotacao + INPUT FRAME {&FRAME-NAME} cotacao.cotacao[i-cont]
                           i-dias = i-dias + 1.
            END.
        end.

        if de-cotacao <> 0 then 
           assign cotacao.cota-media:SCREEN-VALUE = STRING(de-cotacao / i-dias). 

/*        disp cotacao.cota-media with frame {&FRAME-NAME}.*/
    end.
    if input frame {&FRAME-NAME} cotacao.cota-media <> 0 then
        apply "LEAVE" to cotacao.cota-media IN FRAME f-main.

    DEF VAR i-num AS INT NO-UNDO INITIAL 0.
    DEF VAR c-cotacoes AS CHAR NO-UNDO.
    DEF VAR i-count AS INT INITIAL 1 NO-UNDO.
      &IF "{&mgadm_version}" >= "2.04" &THEN
          IF v_log_eai_habilit THEN
          DO:
              FOR EACH tt_log_erro:
                  DELETE tt_log_erro.
              END.
              FOR EACH RowErrors:
                  DELETE RowErrors.
              END.
              DO i-count = 1 TO 31:
                  ASSIGN c-cotacoes = c-cotacoes + STRING(INPUT FRAME {&FRAME-NAME} cotacao.cotacao[i-count]) + ';'.
              END.

              RUN PITransUpsert IN h-adapter (INPUT (if adm-new-record THEN "add" ELSE "upd"),
                                              INPUT cotacao.mo-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                                              INPUT c-ano-per:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                                              INPUT cotacao.cota-mensal:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                                              INPUT cotacao.cota-media:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                                              INPUT c-cotacoes,
                                              OUTPUT TABLE tt_log_erro).
              {method/showmessage.i1}
              ASSIGN i-num = 0.
              FOR EACH tt_log_erro: 
                  CREATE RowErrors.
                  ASSIGN RowErrors.ErrorSequence    = i-num + 1
                         RowErrors.ErrorNumber      = tt_log_erro.ttv_num_cod_erro 
                         RowErrors.ErrorDescription = tt_log_erro.ttv_des_msg_erro
                         RowErrors.ErrorType        = tt_log_erro.ttv_des_msg_erro
                         RowErrors.ErrorHelp        = tt_log_erro.ttv_des_msg_erro.
              END.
              IF CAN-FIND(FIRST tt_log_erro WHERE tt_log_erro.ttv_num_cod_erro <> 60) THEN DO:
                  {method/showmessage.i2}
                  RETURN 'ADM-ERROR'.
              END.
          END.
      &endif
    /*fut36887 - XML Adapter*/

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

    assign c-ano-per:screen-value in frame {&frame-name} = string(c-periodo,"999999"). /*NÆo retirar*/
    apply 'entry' to cotacao.mo-codigo in frame {&frame-name}.                         /*essas duas linhas*/

    do  i-cont = 1 to i-ind:
        assign cotacao.usuario[i-cont] = c-seg-usuario.
    end.
    assign cotacao.ano-periodo = c-periodo. 

    /* Se moeda for indice grava valor absoluto da variacao do periodo. */

    find moeda where moeda.mo-codigo = cotacao.mo-codigo no-lock no-error.
    find first param-global no-lock no-error.

    /* Integra‡Æo do EMS  X  Magnus                              */
    {cdp/cd0002i1.i cotacao}    

    if  l-ok-mmf = yes then do:
        /********************Multiplanta***********************/
        assign c-transacao = "ADM013".
        {cdp/cd7300.i5 "001" c-transacao}
        assign i-tipo-movto = if  cotacao.mo-codigo:sensitive in frame {&frame-name} = yes and
                                  /*cotacao.ano-periodo*/ c-ano-per:sensitive in frame {&frame-name} = yes
                                  then 1 
                                  else 2.

        run pi-cria-tt-dados (input i-tipo-movto).

        {cdp/cd7300.i6 "001" c-transacao}
        /******************Fim-Multiplanta********************/  
    end.  

    /********************Multiplanta-SMC***********************/
    for each tt-smc-cotacao:
      delete tt-smc-cotacao.
    end.

    assign c-transacao = "SMC004".
    {cdp/cd7300.i5 "001" c-transacao "-SMC"}
    assign i-tipo-movto = if  cotacao.mo-codigo:sensitive in frame {&frame-name} = yes and
                              /*cotacao.ano-periodo*/ c-ano-per:sensitive in frame {&frame-name} = yes
                              then 1 
                              else 2.

    run pi-cria-tt-dados-smc (input i-tipo-movto).
    {cdp/cd7300.i6 "001" c-transacao "-SMC"}
    /******************Fim-Multiplanta-SMC********************/  
      
    IF lIntCRM11 AND NOT adm-new-record THEN DO: /* se for um registro novo, chama a integração no local-add-record */
        IF NOT VALID-HANDLE(h-cd0103-crm) THEN
            RUN integracoes/adapters/emstocrm/cd0103-crm.p PERSISTENT SET h-cd0103-crm.
            
        RUN sendToCRM IN h-cd0103-crm (INPUT STRING(cotacao.mo-codigo), INPUT STRING(cotacao.ano-periodo), OUTPUT TABLE RowErrors).
        IF CAN-FIND (FIRST RowErrors WHERE 
                     RowErrors.ErrorSubType = "ERROR":U) THEN DO:
            {method/ShowMessage.i1}
            {method/ShowMessage.i2 &Modal="YES"}
            
            DELETE PROCEDURE h-cd0103-crm.
            UNDO, RETURN "ADM-ERROR":U.
        END.
        DELETE PROCEDURE h-cd0103-crm.
    END.

    ASSIGN l-assignRecord = TRUE.
end.  /* do transaction: */

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
  
    IF lIntCRM11 THEN DO:
        IF NOT VALID-HANDLE(h-cd0103-crm) THEN
            RUN integracoes/adapters/emstocrm/cd0103-crm.p PERSISTENT SET h-cd0103-crm.
      
        RUN deleteFromCRM IN h-cd0103-crm (INPUT STRING(cotacao.mo-codigo), INPUT STRING(cotacao.ano-periodo), OUTPUT TABLE RowErrors).
        IF CAN-FIND (FIRST RowErrors WHERE 
                           RowErrors.ErrorSubType = "ERROR":U) THEN DO:
            {method/ShowMessage.i1}
            {method/ShowMessage.i2 &Modal="YES"}
            UNDO, RETURN "ADM-ERROR":U.
        END.
        DELETE PROCEDURE h-cd0103-crm.
    END.    
    

  /***************Multiplanta*************************************/
  if  l-ok-mmf = yes then do:
      assign c-transacao = "ADM013".
      {cdp/cd7300.i5 "001" c-transacao}


      if  param-global.modulo-mp and
          tt-replica-msg.log-replica-msg  = yes then do: 
          create tt-cotacao-aux.
          buffer-copy cotacao to tt-cotacao-aux.
          create tt-dados-env.                  
          assign tt-dados-env.num-sequencia  = i-seq 
                 tt-dados-env.cod-tipo-reg   = 37
                 tt-dados-env.ind-tipo-movto = 3
                 tt-dados-env.identif-msg    = string(cotacao.mo-codigo)  + "," + 
                                               string(cotacao.ano-periodo).                                          
          raw-transfer tt-cotacao-aux to tt-dados-env.conteudo-msg.                                     
          assign i-seq = i-seq + 1.                                                                      
      end.

      {cdp/cd7300.i6 "001" c-transacao}
  end. 
/**********Fim-Multiplanta**************************************/ 

/********************Multiplanta-SMC***********************/
    for each tt-smc-cotacao:
      delete tt-smc-cotacao.
    end.
    assign c-transacao = "SMC004".
    {cdp/cd7300.i5 "001" c-transacao "-SMC"}
    assign i-tipo-movto = 3. 
    run pi-cria-tt-dados-smc (input i-tipo-movto).
    {cdp/cd7300.i6 "001" c-transacao "-SMC"}
/******************Fim-Multiplanta-SMC********************/  


  /*  Integra‡Æo  EMS  X  Magnus                               */
  {cdp/cd0002i1.i1 cotacao "no"}

  /*fut36887 - XML Adapters*/
    DEF VAR i-num AS INT INITIAL 0 NO-UNDO.
    &IF "{&mgadm_version}" >= "2.04" &THEN
        IF v_log_eai_habilit = YES THEN DO:
            RUN PITransDelete IN h-adapter(INPUT cotacao.mo-codigo,
                                           INPUT cotacao.ano-periodo,
                                           OUTPUT TABLE tt_log_erro).


            {method/showmessage.i1}
            ASSIGN i-num = 0.
            FOR EACH tt_log_erro:                   
                CREATE RowErrors.
                ASSIGN RowErrors.ErrorSequence    = i-num + 1
                       RowErrors.ErrorNumber      = tt_log_erro.ttv_num_cod_erro 
                       RowErrors.ErrorDescription = tt_log_erro.ttv_des_msg_erro
                       RowErrors.ErrorType        = tt_log_erro.ttv_des_msg_erro
                       RowErrors.ErrorHelp        = tt_log_erro.ttv_des_msg_erro.
             END.
            IF CAN-FIND(FIRST tt_log_erro WHERE tt_log_erro.ttv_num_cod_erro <> 60) THEN DO:
               {method/showmessage.i2}
               RETURN 'ADM-ERROR'.
           END.
       END.
    &endif
  /*fut36887 - XML Adapters*/


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  /*  Integra‡Æo  EMS  X  Magnus                               */
  {cdp/cd0002i1.i1 cotacao "yes"}


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
  /*fut36887 - XML adapters*/
  &IF "{&mgadm_version}" >= "2.04" &THEN
      IF v_log_eai_habilit = YES THEN DO:
          if  valid-handle(h-adapter) then do:
              delete procedure h-adapter.
              ASSIGN h-adapter = ?.
          end.
          {method/showmessage.i3}
      END.
   &endif
  /*fut36887 - XML adapters*/
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

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

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
    if  avail cotacao then do:
        find moeda no-lock
            where moeda.mo-codigo = cotacao.mo-codigo no-error.

        if avail moeda then
            assign c_descricao_moeda = moeda.descricao no-error.
        else
            assign c_descricao_moeda = "":U no-error.
        assign c-ano-per = string(cotacao.ano-periodo).

    end.

    /* Se moeda for indice altera formato para aceitar valores negativos. */
    if  avail cotacao and
        not adm-new-record then do:
        find moeda where moeda.mo-codigo = input frame {&Frame-name} cotacao.mo-codigo no-lock no-error.
        if  avail moeda and
            (moeda.ind-variacao = 2 or moeda.ind-reajuste = 2) then do:
            assign cotacao.cota-mensal:format in frame {&frame-name} = "->>>,>>9.99999999" no-error.
        end.
        else 
            assign cotacao.cota-mensal:format in frame {&frame-name} = "->>>,>>9.99999999" no-error.
    end.


    RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

    assign c-formato = input frame {&FRAME-NAME} c-ano-per no-error.

    if  error-status:get-number(1) <> 0 then do:
        assign c-ano-per:format in frame {&FRAME-NAME} = "999999".
    end.
    else do:
        assign c-ano-per:format in frame {&FRAME-NAME} = "9999/99".
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

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

if  avail cotacao and
    not adm-new-record then do:  
    apply "leave" to c-ano-per in frame {&frame-name}.       
    if  avail moeda then do with frame {&frame-name}:
        assign cotacao.cota-mensal:sensitive = (moeda.ind-reajuste = 1 and moeda.ind-variacao = 1).        
        if  moeda.ind-variacao = 2 then do: /* Mensal */
            do i = 1 to 31:
                disable cotacao.cotacao[i].
            end.
            disable cotacao.cota-media with frame {&frame-name}.
        end.

        if  not adm-new-record and
            (moeda.ind-variacao = 2 or moeda.ind-reajuste = 2) then 
            assign cotacao.cota-mensal:format in frame {&frame-name} = "->>>,>>9.99999999".
        else 
            assign cotacao.cota-mensal:format in frame {&frame-name} = "->>>,>>9.99999999".
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

    assign c-ano-per:format in frame {&FRAME-NAME} = "9999/99".

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ).

    /*---  Modulo Multiplanta Financeiro (MMF) ---*/
    {cdp/cdapi531.i1 "ADM013" "NO"}

  /*fut36887 - XML adapters*/
    &IF "{&mgadm_version}" >= "2.04" &THEN
        IF v_log_eai_habilit THEN
            RUN adapters/xml/fi2/axsfi003.p PERSISTENT SET h-adapter (OUTPUT TABLE tt_log_erro).
    &endif
  /*fut36887 - XML adapters*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-rpc-mg V-table-Win 
PROCEDURE pi-atualiza-rpc-mg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{cdp/cd0003i1.i cotacao "cdp/cd0103i1.p"}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-cotacao-mg V-table-Win 
PROCEDURE pi-cria-tt-cotacao-mg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input param p-ind-tipo-movto as int no-undo.
def input param p-atualiza       as log no-undo.

for each tt-cotacao-mg:
    delete tt-cotacao-mg.
end.   

create tt-cotacao-mg.
assign tt-cotacao-mg.mo-codigo      = cotacao.mo-codigo
       tt-cotacao-mg.ano-periodo    = fn-free-accent(cotacao.ano-periodo)
       tt-cotacao-mg.cota-mensal    = cotacao.cota-mensal
       tt-cotacao-mg.cota-media     = cotacao.cota-media
       tt-cotacao-mg.char-1         = fn-free-accent(cotacao.char-1)
       tt-cotacao-mg.dec-1          = cotacao.dec-1
       tt-cotacao-mg.int-1          = cotacao.int-1
       tt-cotacao-mg.log-1          = cotacao.log-1
       tt-cotacao-mg.dec-2          = cotacao.dec-2
       tt-cotacao-mg.char-2         = fn-free-accent(cotacao.char-2)
       tt-cotacao-mg.int-2          = cotacao.int-2
       tt-cotacao-mg.ind-tipo-movto = p-ind-tipo-movto
       tt-cotacao-mg.l-atualiza     = p-atualiza.

do  i-indice = 1 to 31:
    assign tt-cotacao-mg.cotacao[i-indice]  = cotacao.cotacao[i-indice]
           tt-cotacao-mg.usuario[i-indice]  = fn-free-accent(cotacao.usuario[i-indice]).
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-dados V-table-Win 
PROCEDURE pi-cria-tt-dados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter i-tipo-movto as integer.

if  param-global.modulo-mp and
    tt-replica-msg.log-replica-msg  = yes then do: 
    create tt-cotacao-aux.
    buffer-copy cotacao to tt-cotacao-aux.
    create tt-dados-env.                  
    assign tt-dados-env.num-sequencia  = i-seq 
           tt-dados-env.cod-tipo-reg   = 37
           tt-dados-env.ind-tipo-movto = i-tipo-movto
           tt-dados-env.identif-msg    = string(cotacao.mo-codigo)  + "," + 
                                         string(cotacao.ano-periodo).
    raw-transfer tt-cotacao-aux to tt-dados-env.conteudo-msg.
    assign i-seq = i-seq + 1.
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-dados-smc V-table-Win 
PROCEDURE pi-cria-tt-dados-smc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter i-tipo-movto as integer.

if  param-global.modulo-mp and
    tt-replica-msg-SMC.log-replica-msg  = yes then do: 
        create tt-smc-cotacao.
        buffer-copy cotacao to tt-smc-cotacao.
        create tt-dados-env-SMC.
        assign tt-dados-env-SMC.num-sequencia  = i-seq 
               tt-dados-env-SMC.cod-tipo-reg   = 283
               tt-dados-env-SMC.ind-tipo-movto = i-tipo-movto
               tt-dados-env-SMC.identif-msg    = string(cotacao.mo-codigo)  + "," + 
                                                 string(cotacao.ano-periodo).
    raw-transfer tt-smc-cotacao to tt-dados-env-SMC.conteudo-msg.
    assign i-seq = i-seq + 1.
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-log-mg V-table-Win 
PROCEDURE pi-gera-log-mg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{cdp/cd0004i1.i "cd0103" cotacao cotacao.mo-codigo,cotacao.ano-periodo tt-cotacao-mg.ind-tipo-movto tt-erros-mg.help-msg}


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-cotacao-mg V-table-Win 
PROCEDURE pi-valida-cotacao-mg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input-output param i-ind-tipo-movto as int no-undo.

    Return "OK":U.


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
  {src/adm/template/snd-list.i "cotacao"}

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

