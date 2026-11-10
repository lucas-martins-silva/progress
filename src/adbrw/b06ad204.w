&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          rtb              PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS B-table-Win 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i B06AD204 2.00.00.008}  /*** 010008 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i b06ad204 MUT}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Preprocessor Definitions ---                                         */
{include/i_dbvers.i}
{include/i_fnctrad.i}

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE de-valor LIKE obj-cenario.vl-objetivo NO-UNDO.

DEFINE VARIABLE c-conteudo    AS CHARACTER NO-UNDO FORMAT "X(50)":U.
DEFINE VARIABLE c-moeda       AS CHARACTER NO-UNDO FORMAT "X(12)":U.
DEFINE VARIABLE c-operador    AS CHARACTER NO-UNDO FORMAT "X(15)":U.
DEFINE VARIABLE da-data       AS DATE      NO-UNDO.
DEFINE VARIABLE i-cod-cenario AS INTEGER   NO-UNDO.
DEFINE VARIABLE v-row-parent  AS ROWID     NO-UNDO.
define variable i-fator-div   as integer no-undo.
Define Variable i             As Integer No-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br-objetivos

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES obj-cenario

/* Definitions for BROWSE br-objetivos                                  */
&Scoped-define FIELDS-IN-QUERY-br-objetivos obj-cenario.dt-objetivo fn-conversao(obj-cenario.vl-objetivo, obj-cenario.mo-codigo, obj-cenario.dt-objetivo, obj-cenario.cod-conteudo) @ obj-cenario.vl-objetivo &IF "{&mgadm_version}":U >= "2.04":U &THEN fn-fator-div(obj-cenario.vl-realizado) @ obj-cenario.vl-realizado &ELSE fn-fator-div(obj-cenario.dec-1) @ obj-cenario.dec-1 &ENDIF &IF "{&mgadm_version}":U >= "2.04":U &THEN obj-cenario.dt-objetivo-ini &ELSE obj-cenario.data-1 &ENDIF ENTRY(obj-cenario.cod-conteudo, c-conteudo) @ c-conteudo ENTRY(obj-cenario.cod-operador, c-operador) @ c-operador &IF "{&mgadm_version}":U >= "2.04":U &THEN fn-trad(obj-cenario.log-atualizado) @ obj-cenario.log-atualizado &ELSE obj-cenario.log-1 &ENDIF fn-trad(obj-cenario.envia-email) @ obj-cenario.envia-email obj-cenario.email-objetivo fn-moeda(obj-cenario.mo-codigo, obj-cenario.cod-conteudo) @ c-moeda fn-fator-div(obj-cenario.vl-objetivo) @ de-valor   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-objetivos   
&Scoped-define SELF-NAME br-objetivos
&Scoped-define OPEN-QUERY-br-objetivos /******************* CONTAS A PAGAR ************************/  OPEN QUERY {&SELF-NAME} FOR EACH obj-cenario       WHERE obj-cenario.cod-cenario = i-cod-cenario AND             obj-cenario.area = 4 NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-objetivos obj-cenario
&Scoped-define FIRST-TABLE-IN-QUERY-br-objetivos obj-cenario


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-75 RECT-78 br-objetivos fi-objetivos 
&Scoped-Define DISPLAYED-OBJECTS fi-pago-mes fi-atraso-maior fi-pmp ~
fi-vencimento-mes fi-percentual-atraso fi-amp fi-carteira fi-objetivos 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" B-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<FOREIGN-KEYS>
</FOREIGN-KEYS
><EXECUTING-CODE>
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Advanced Query Options" B-table-Win _INLINE
/* Actions: ? adm/support/advqedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<SORTBY-OPTIONS>
</SORTBY-OPTIONS>
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = ""':U).
/************************
</SORTBY-RUN-CODE>
<FILTER-ATTRIBUTES>
</FILTER-ATTRIBUTES> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-conversao B-table-Win 
FUNCTION fn-conversao RETURNS DECIMAL
    (INPUT p-valor AS DECIMAL, INPUT p-moeda AS INTEGER, INPUT p-data AS DATE, INPUT p-conteudo AS INTEGER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-fator-div B-table-Win 
FUNCTION fn-fator-div RETURNS DECIMAL
    (INPUT p-valor AS DECIMAL) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-moeda B-table-Win 
FUNCTION fn-moeda RETURNS CHARACTER
    (INPUT p-moeda AS INTEGER, INPUT p-conteudo AS INTEGER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-trad B-table-Win 
FUNCTION fn-trad RETURNS CHARACTER
    (cLiter As Logical /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE fi-amp AS DECIMAL FORMAT "->>>>>>9.99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE fi-atraso-maior AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE fi-carteira AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE fi-objetivos AS CHARACTER FORMAT "X(30)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE fi-pago-mes AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE fi-percentual-atraso AS DECIMAL FORMAT "->>9.99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE fi-pmp AS DECIMAL FORMAT "->>>>>>9.99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE fi-vencimento-mes AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-75
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 86 BY 8.75.

DEFINE RECTANGLE RECT-78
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 84 BY 5.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-objetivos FOR 
      obj-cenario SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-objetivos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-objetivos B-table-Win _FREEFORM
  QUERY br-objetivos NO-LOCK DISPLAY
      obj-cenario.dt-objetivo
      fn-conversao(obj-cenario.vl-objetivo, obj-cenario.mo-codigo, obj-cenario.dt-objetivo, obj-cenario.cod-conteudo) @ obj-cenario.vl-objetivo

    &IF "{&mgadm_version}":U >= "2.04":U &THEN
      fn-fator-div(obj-cenario.vl-realizado) @ obj-cenario.vl-realizado
    &ELSE
      fn-fator-div(obj-cenario.dec-1) @ obj-cenario.dec-1 FORMAT "->>>,>>>,>>>,>>9.9999"
    &ENDIF
    
    &IF "{&mgadm_version}":U >= "2.04":U &THEN
      obj-cenario.dt-objetivo-ini
    &ELSE
      obj-cenario.data-1
    &ENDIF
    
      ENTRY(obj-cenario.cod-conteudo, c-conteudo) @ c-conteudo
      ENTRY(obj-cenario.cod-operador, c-operador) @ c-operador
    
    &IF "{&mgadm_version}":U >= "2.04":U &THEN
      fn-trad(obj-cenario.log-atualizado) @ obj-cenario.log-atualizado
    &ELSE
      obj-cenario.log-1
    &ENDIF
    
      fn-trad(obj-cenario.envia-email) @ obj-cenario.envia-email
      obj-cenario.email-objetivo
      fn-moeda(obj-cenario.mo-codigo, obj-cenario.cod-conteudo) @ c-moeda
      fn-fator-div(obj-cenario.vl-objetivo) @ de-valor
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-BOX SEPARATORS SIZE 82 BY 4.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     fi-pago-mes AT ROW 1.25 COL 13 COLON-ALIGNED
     fi-atraso-maior AT ROW 1.25 COL 42 COLON-ALIGNED
     fi-pmp AT ROW 1.25 COL 69 COLON-ALIGNED
     fi-vencimento-mes AT ROW 2.25 COL 13 COLON-ALIGNED
     fi-percentual-atraso AT ROW 2.25 COL 42 COLON-ALIGNED
     fi-amp AT ROW 2.25 COL 69 COLON-ALIGNED
     fi-carteira AT ROW 3.25 COL 13 COLON-ALIGNED
     br-objetivos AT ROW 5 COL 3
     fi-objetivos AT ROW 4.25 COL 1 COLON-ALIGNED NO-LABEL
     RECT-75 AT ROW 1 COL 1
     RECT-78 AT ROW 4.5 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         BGCOLOR 8 FGCOLOR 0 .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   Allow: Basic,Browse
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
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 8.75
         WIDTH              = 86.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/browser.i}
{include/c-browse.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit                                              */
/* BROWSE-TAB br-objetivos fi-carteira F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN fi-amp IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-atraso-maior IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-carteira IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-pago-mes IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-percentual-atraso IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-pmp IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-vencimento-mes IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-objetivos
/* Query rebuild information for BROWSE br-objetivos
     _START_FREEFORM
/******************* CONTAS A PAGAR ************************/

OPEN QUERY {&SELF-NAME} FOR EACH obj-cenario
      WHERE obj-cenario.cod-cenario = i-cod-cenario AND
            obj-cenario.area = 4 NO-LOCK INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "obj-cenario.cod-cenario = i-cod-cenario AND
obj-cenario.area = 4"
     _Query            is NOT OPENED
*/  /* BROWSE br-objetivos */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME br-objetivos
&Scoped-define SELF-NAME br-objetivos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-objetivos B-table-Win
ON ROW-DISPLAY OF br-objetivos IN FRAME F-Main
DO:
    DEFINE VARIABLE l-obj-alcancado AS LOGICAL NO-UNDO.

    IF AVAILABLE obj-cenario AND NOT(obj-cenario.dt-objetivo > da-data) THEN DO:
        CASE cod-operador:
            WHEN 1 THEN
                ASSIGN l-obj-alcancado = (fn-conversao(obj-cenario.vl-objetivo, obj-cenario.mo-codigo, obj-cenario.dt-objetivo, obj-cenario.cod-conteudo) = fn-fator-div(&If  "{&mgadm_version}" >= "2.04" &Then
                                                                                                                                                                         Obj-Cenario.vl-realizado
                                                                                                                                                                         &Else
                                                                                                                                                                         Obj-Cenario.dec-1
                                                                                                                                                                         &EndIF)).
            WHEN 2 THEN
                ASSIGN l-obj-alcancado = (fn-conversao(obj-cenario.vl-objetivo, obj-cenario.mo-codigo, obj-cenario.dt-objetivo, obj-cenario.cod-conteudo) < fn-fator-div(&If  "{&mgadm_version}" >= "2.04" &Then
                                                                                                                                                                         Obj-Cenario.vl-realizado
                                                                                                                                                                         &Else
                                                                                                                                                                         Obj-Cenario.dec-1
                                                                                                                                                                         &EndIF)).
            WHEN 3 THEN
                ASSIGN l-obj-alcancado = (fn-conversao(obj-cenario.vl-objetivo, obj-cenario.mo-codigo, obj-cenario.dt-objetivo, obj-cenario.cod-conteudo) <= fn-fator-div(&If  "{&mgadm_version}" >= "2.04" &Then
                                                                                                                                                                         Obj-Cenario.vl-realizado
                                                                                                                                                                         &Else
                                                                                                                                                                         Obj-Cenario.dec-1
                                                                                                                                                                         &EndIF)).
            WHEN 4 THEN
                ASSIGN l-obj-alcancado = (fn-conversao(obj-cenario.vl-objetivo, obj-cenario.mo-codigo, obj-cenario.dt-objetivo, obj-cenario.cod-conteudo) > fn-fator-div(&If  "{&mgadm_version}" >= "2.04" &Then
                                                                                                                                                                         Obj-Cenario.vl-realizado
                                                                                                                                                                         &Else
                                                                                                                                                                         Obj-Cenario.dec-1
                                                                                                                                                                         &EndIF)).
            WHEN 5 THEN
                ASSIGN l-obj-alcancado = (fn-conversao(obj-cenario.vl-objetivo, obj-cenario.mo-codigo, obj-cenario.dt-objetivo, obj-cenario.cod-conteudo) >= fn-fator-div(&If  "{&mgadm_version}" >= "2.04" &Then
                                                                                                                                                                         Obj-Cenario.vl-realizado
                                                                                                                                                                         &Else
                                                                                                                                                                         Obj-Cenario.dec-1
                                                                                                                                                                         &EndIF)).
            WHEN 6 THEN
                ASSIGN l-obj-alcancado = (fn-conversao(obj-cenario.vl-objetivo, obj-cenario.mo-codigo, obj-cenario.dt-objetivo, obj-cenario.cod-conteudo) <> fn-fator-div(&If  "{&mgadm_version}" >= "2.04" &Then
                                                                                                                                                                         Obj-Cenario.vl-realizado
                                                                                                                                                                         &Else
                                                                                                                                                                         Obj-Cenario.dec-1
                                                                                                                                                                         &EndIF)).
        END CASE.

        IF l-obj-alcancado THEN
            ASSIGN obj-cenario.dt-objetivo:BGCOLOR IN BROWSE {&BROWSE-NAME}     = 10

                &IF "{&mgadm_version}":U >= "2.04":U &THEN
                   obj-cenario.dt-objetivo-ini:BGCOLOR IN BROWSE {&BROWSE-NAME}   = 10
                &ELSE
                   obj-cenario.data-1:BGCOLOR IN BROWSE {&BROWSE-NAME}          = 10
                &ENDIF
                
                   c-conteudo:BGCOLOR IN BROWSE {&BROWSE-NAME}                  = 10
                   obj-cenario.vl-objetivo:BGCOLOR IN BROWSE {&BROWSE-NAME}     = 10
                
                &IF "{&mgadm_version}":U >= "2.04":U &THEN
                   obj-cenario.vl-realizado:BGCOLOR IN BROWSE {&BROWSE-NAME}    = 10
                &ELSE
                   obj-cenario.dec-1:BGCOLOR IN BROWSE {&BROWSE-NAME}           = 10
                &ENDIF
                
                   c-operador:BGCOLOR IN BROWSE {&BROWSE-NAME}                  = 10
                
                &IF "{&mgadm_version}":U >= "2.04":U &THEN
                   obj-cenario.log-atualizado:BGCOLOR IN BROWSE {&BROWSE-NAME} = 10
                &ELSE
                   obj-cenario.log-1:BGCOLOR IN BROWSE {&BROWSE-NAME}           = 10
                &ENDIF
                
                   obj-cenario.envia-email:BGCOLOR IN BROWSE {&BROWSE-NAME}     = 10
                   obj-cenario.email-objetivo:BGCOLOR IN BROWSE {&BROWSE-NAME}  = 10
                   c-moeda:BGCOLOR IN BROWSE {&BROWSE-NAME}                     = 10
                   de-valor:BGCOLOR IN BROWSE {&BROWSE-NAME}                    = 10.
        ELSE
            ASSIGN obj-cenario.dt-objetivo:BGCOLOR IN BROWSE {&BROWSE-NAME}     = 12

                &IF "{&mgadm_version}":U >= "2.04":U &THEN
                   obj-cenario.dt-objetivo-ini:BGCOLOR IN BROWSE {&BROWSE-NAME}   = 12
                &ELSE
                   obj-cenario.data-1:BGCOLOR IN BROWSE {&BROWSE-NAME}          = 12
                &ENDIF
                
                   c-conteudo:BGCOLOR IN BROWSE {&BROWSE-NAME}                  = 12
                   obj-cenario.vl-objetivo:BGCOLOR IN BROWSE {&BROWSE-NAME}     = 12
                
                &IF "{&mgadm_version}":U >= "2.04":U &THEN
                   obj-cenario.vl-realizado:BGCOLOR IN BROWSE {&BROWSE-NAME}    = 12
                &ELSE
                   obj-cenario.dec-1:BGCOLOR IN BROWSE {&BROWSE-NAME}           = 12
                &ENDIF
                
                   c-operador:BGCOLOR IN BROWSE {&BROWSE-NAME}                  = 12
                
                &IF "{&mgadm_version}":U >= "2.04":U &THEN
                   obj-cenario.log-atualizado:BGCOLOR IN BROWSE {&BROWSE-NAME} = 12
                &ELSE
                   obj-cenario.log-1:BGCOLOR IN BROWSE {&BROWSE-NAME}           = 12
                &ENDIF
                
                   obj-cenario.envia-email:BGCOLOR IN BROWSE {&BROWSE-NAME}     = 12
                   obj-cenario.email-objetivo:BGCOLOR IN BROWSE {&BROWSE-NAME}  = 12
                   c-moeda:BGCOLOR IN BROWSE {&BROWSE-NAME}                     = 12
                   de-valor:BGCOLOR IN BROWSE {&BROWSE-NAME}                    = 12.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-objetivos B-table-Win
ON ROW-ENTRY OF br-objetivos IN FRAME F-Main
DO:
    /* This code displays initial values for newly added or copied rows. */
    {src/adm/template/brsentry.i}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-objetivos B-table-Win
ON ROW-LEAVE OF br-objetivos IN FRAME F-Main
DO:
    /* Do not disable this code or no updates will take place except
       by pressing the Save button on an Update SmartPanel. */
    {src/adm/template/brsleave.i}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-objetivos B-table-Win
ON VALUE-CHANGED OF br-objetivos IN FRAME F-Main
DO:
    /* This ADM trigger code must be preserved in order to notify other
       objects when the browser's current row changes. */
    {src/adm/template/brschnge.i}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

ASSIGN c-conteudo = {adinc/i02ad337.i 03}
       c-operador = {adinc/i03ad337.i 03}.
&IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEN
    Repeat i = 1 To Num-entries(c-conteudo):
        Run utp/ut-liter.p (input Replace(Entry(i,c-conteudo)," ","_"),"*","").
        Assign Entry(i,c-conteudo) = Return-value.
    End.
    Repeat i = 1 To Num-entries(c-operador):
        Run utp/ut-liter.p (input Replace(Entry(i,c-operador)," ","_"),"*","").
        Assign Entry(i,c-operador) = Return-value.
    End.
&ENDIF

{utp/ut-liter.i Conte£do}
ASSIGN c-conteudo:LABEL IN BROWSE {&BROWSE-NAME} = TRIM(RETURN-VALUE).

{utp/ut-liter.i Operador}
ASSIGN c-operador:LABEL IN BROWSE {&BROWSE-NAME} = TRIM(RETURN-VALUE).

&IF "{&mgadm_version}":U < "2.04":U &THEN
    {utp/ut-liter.i Data_Ini_Obj}
    ASSIGN obj-cenario.data-1:LABEL IN BROWSE {&BROWSE-NAME} = TRIM(RETURN-VALUE).

    {utp/ut-liter.i Vl_Realizado}
    ASSIGN obj-cenario.dec-1:LABEL IN BROWSE {&BROWSE-NAME} = TRIM(RETURN-VALUE).

    {utp/ut-liter.i Obj_Processado}
    ASSIGN obj-cenario.log-1:LABEL IN BROWSE {&BROWSE-NAME} = TRIM(RETURN-VALUE).
&ENDIF

{utp/ut-liter.i "Verde(Obj Alcan‡ado) Vermelho(Obj nÆo Alcan‡ado)"}
ASSIGN {&BROWSE-NAME}:tooltip = TRIM(RETURN-VALUE).

{utp/ut-liter.i Moeda}
ASSIGN c-moeda:LABEL IN BROWSE {&BROWSE-NAME} = TRIM(RETURN-VALUE).

{utp/ut-liter.i "VL Orig Objetivo"}
ASSIGN de-valor:LABEL IN BROWSE {&BROWSE-NAME} = TRIM(RETURN-VALUE).

{utp/ut-liter.i Pago_Mˆs}
ASSIGN fi-pago-mes:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

{utp/ut-liter.i Vencimento_Mˆs}
ASSIGN fi-vencimento-mes:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

{utp/ut-liter.i Carteira}
ASSIGN fi-carteira:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

{utp/ut-liter.i Atraso_>_30_dias}
ASSIGN fi-atraso-maior:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

{utp/ut-liter.i Atraso/Carteira_(%)}
ASSIGN fi-percentual-atraso:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

{utp/ut-liter.i PMP}
ASSIGN fi-pmp:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

{utp/ut-liter.i AMP}
ASSIGN fi-amp:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

{utp/ut-liter.i Objetivos}
ASSIGN fi-objetivos                                     = TRIM(RETURN-VALUE)
       fi-objetivos:SCREEN-VALUE IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

ASSIGN fi-pago-mes:BGCOLOR IN FRAME {&FRAME-NAME}          = 15
       fi-pago-mes:FGCOLOR IN FRAME {&FRAME-NAME}          = 0
       fi-vencimento-mes:BGCOLOR IN FRAME {&FRAME-NAME}    = 15
       fi-vencimento-mes:FGCOLOR IN FRAME {&FRAME-NAME}    = 0
       fi-carteira:BGCOLOR IN FRAME {&FRAME-NAME}          = 15
       fi-carteira:FGCOLOR IN FRAME {&FRAME-NAME}          = 0
       fi-atraso-maior:BGCOLOR IN FRAME {&FRAME-NAME}      = 15
       fi-atraso-maior:FGCOLOR IN FRAME {&FRAME-NAME}      = 0
       fi-percentual-atraso:BGCOLOR IN FRAME {&FRAME-NAME} = 15
       fi-percentual-atraso:FGCOLOR IN FRAME {&FRAME-NAME} = 0
       fi-pmp:BGCOLOR IN FRAME {&FRAME-NAME}               = 15
       fi-pmp:FGCOLOR IN FRAME {&FRAME-NAME}               = 0
       fi-amp:BGCOLOR IN FRAME {&FRAME-NAME}               = 15
       fi-amp:FGCOLOR IN FRAME {&FRAME-NAME}               = 0.

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available B-table-Win  _ADM-ROW-AVAILABLE
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

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI B-table-Win  _DEFAULT-DISABLE
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
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualizacao B-table-Win 
PROCEDURE pi-atualizacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&IF "{&mguni_version}" >= "2.07A" &THEN
    DEFINE INPUT PARAMETER p-empresa              LIKE empresa.ep-codigo NO-UNDO.
&ELSE
    DEFINE INPUT PARAMETER p-empresa              AS INTEGER NO-UNDO.
&ENDIF
    DEFINE INPUT PARAMETER p-data                 AS DATE    NO-UNDO.
    DEFINE INPUT PARAMETER p-data-inicio-carteira AS DATE    NO-UNDO.
    DEFINE INPUT PARAMETER p-fator                AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-cenario          AS INTEGER NO-UNDO.

    DEFINE VARIABLE de-cr-recebido-mes      AS DECIMAL NO-UNDO.
    DEFINE VARIABLE de-cr-vencimento-mes    AS DECIMAL NO-UNDO.
    DEFINE VARIABLE de-cr-carteira          AS DECIMAL NO-UNDO.
    DEFINE VARIABLE de-cr-atraso-maior      AS DECIMAL NO-UNDO.
    DEFINE VARIABLE de-cr-percentual-atraso AS DECIMAL NO-UNDO.
    DEFINE VARIABLE de-cr-pmr               AS DECIMAL NO-UNDO.
    DEFINE VARIABLE de-cr-amr               AS DECIMAL NO-UNDO.

    ASSIGN da-data       = p-data
           i-cod-cenario = p-cod-cenario
           i-fator-div   = p-fator.

    RUN gep/gebo02013.p ( INPUT p-empresa,
                          INPUT p-data,
                          INPUT p-data-inicio-carteira,
                          INPUT p-fator,

                         OUTPUT de-cr-recebido-mes,
                         OUTPUT de-cr-vencimento-mes,
                         OUTPUT de-cr-carteira,
                         OUTPUT de-cr-atraso-maior,
                         OUTPUT de-cr-percentual-atraso,
                         OUTPUT de-cr-pmr,
                         OUTPUT de-cr-amr,
                         OUTPUT fi-pago-mes,
                         OUTPUT fi-vencimento-mes,
                         OUTPUT fi-carteira,
                         OUTPUT fi-atraso-maior,
                         OUTPUT fi-percentual-atraso,
                         OUTPUT fi-pmp,
                         OUTPUT fi-amp).

    DISPLAY fi-pago-mes     fi-vencimento-mes    fi-carteira
            fi-atraso-maior fi-percentual-atraso
            fi-pmp          fi-amp
        WITH FRAME {&FRAME-NAME}.

    {&OPEN-QUERY-{&BROWSE-NAME}}
    APPLY "VALUE-CHANGED":U TO BROWSE {&BROWSE-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records B-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "obj-cenario"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed B-table-Win 
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
      {src/adm/template/bstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-conversao B-table-Win 
FUNCTION fn-conversao RETURNS DECIMAL
    (INPUT p-valor AS DECIMAL, INPUT p-moeda AS INTEGER, INPUT p-data AS DATE, INPUT p-conteudo AS INTEGER):
    DEFINE VARIABLE de-cotacao AS DECIMAL NO-UNDO.

    IF p-conteudo >= 4 THEN do:
        if  i-fator-div <> ?
        and i-fator-div <> 0 then
            RETURN ((p-valor) / i-fator-div).
        else
            RETURN (p-valor).
    end.

    {cdp/cd9600.i p-moeda p-data de-cotacao " " msg}

    if  i-fator-div <> ?
    and i-fator-div <> 0 then
        RETURN ((p-valor * de-cotacao) / i-fator-div).
    else
        RETURN (p-valor * de-cotacao).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-fator-div B-table-Win 
FUNCTION fn-fator-div RETURNS DECIMAL
    (INPUT p-valor AS DECIMAL):

    if  i-fator-div <> ?
    and i-fator-div <> 0 then
        RETURN (p-valor / i-fator-div).
    else
        RETURN (p-valor).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-moeda B-table-Win 
FUNCTION fn-moeda RETURNS CHARACTER
    (INPUT p-moeda AS INTEGER, INPUT p-conteudo AS INTEGER):

    IF p-conteudo >= 4 THEN
        RETURN "     %":U.

    FIND moeda WHERE moeda.mo-codigo = p-moeda NO-LOCK NO-ERROR.

    IF AVAILABLE moeda THEN
        RETURN moeda.descricao.
    ELSE
        RETURN "":U.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-trad B-table-Win 
FUNCTION fn-trad RETURNS CHARACTER
    (cLiter As Logical /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  Run utp/ut-liter.p (input string(cLiter),"*","").
  RETURN Return-value.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

