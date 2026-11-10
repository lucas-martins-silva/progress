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
{include/i-prgvrs.i V15IN218 2.00.00.004 } /*** 010004 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v15in218 MUT}
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

def buffer b-saldo for saldo-estoq.
/* global variable definitions */
define new global shared var c-it-codigo   like item.it-codigo          no-undo.
define new global shared var c-estab       like saldo-estoq.cod-estabel no-undo.

/* Parameters Definitions ---                                           */

def var l-criou          as l init no no-undo.
def var c-cod-estabel    like estabelec.cod-estabel no-undo.
def var de-aux-1    as decimal decimals 2 no-undo.
def var de-aux-2    as decimal decimals 2 no-undo.
def var l-entrada   as logical no-undo.
def var l-resposta  as logical no-undo.
def var i-saldo-neg as integer no-undo.
def var c-it-codigo like saldo-estoq.it-codigo no-undo.
def var c-cod-refer like saldo-estoq.cod-refer no-undo.
def var c-cod-depos   like saldo-estoq.cod-depos no-undo.
def var c-lote        like saldo-estoq.lote no-undo.
def var c-cod-localiz like saldo-estoq.cod-localiz no-undo.
def var c-data-valida as date format "99/99/9999" no-undo.
def var de-qtd        like movto-estoq.quantidade no-undo.
def var i-empresa like param-global.empresa-prin no-undo.
def var c-cod-estabel-usuar like estabelec.cod-estabel no-undo.

{cdp/cdcfgdis.i}
{cdp/cdcfgmat.i}

/*-- Investimento --*/
def new shared var i-emp-inv like empresa.ep-codigo no-undo.
def new shared var i-ord-inv as int format ">>>,>>9" no-undo.
def var r-item           as rowid no-undo.
def var h_window   as handle.

/*********************************************************
** Para a release 2.04A foi implementado um browser de  **
** saldos para os itens que possuirem metodo de custeio **
** FIFO/LIFO                                            **
*********************************************************/
def var h_b01in702 as handle no-undo.
def var h_boiv028  as handle no-undo.

def var c-handle     as char no-undo.
def var de-saldo-atual     like saldo-estoq.qtidade-atu no-undo.
def var de-saldo-calc      like saldo-estoq.qtidade-atu no-undo.
def var rw-conta           as rowid no-undo.
def var rw-conta-aplic     as rowid no-undo.
def var i-num-ord-inv-old  as integer no-undo.
def buffer b-saldo-estoq for saldo-estoq.
&IF "{&mguni_version}" >= "2.071" &THEN
def var i-ep-codigo   LIKE empresa.ep-codigo no-undo.
&ELSE
def var i-ep-codigo   as integer no-undo.
&ENDIF

{cep/ceapi001.i}    /* Definicao de temp-table do movto-estoq */
{cdp/cd0666.i}      /* Definicao da temp-table de erros */
{cdp/cd1234.i}  /* Validaá∆o Decimais */
{cdp/cd9731.i6} /* Verifica integraá∆o com Manutená∆o Industrial */

/* Local Variable Definitions ---                                       */
def var l-achou            as logical                       no-undo.
def var c-conta-inv        like conta-contab.conta-contabil no-undo.
def var c-centro-custo-inv as char                          no-undo.
def var c-par-inv          as char                          no-undo.
def var c-desc-ord-inv     as char                          no-undo.
def var l-zoom-inv         as logical                       no-undo.
def var i-num-ord-inv      like movto-estoq.num-ord-inv     no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-chave

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES movto-estoq
&Scoped-define FIRST-EXTERNAL-TABLE movto-estoq


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR movto-estoq.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS movto-estoq.it-codigo movto-estoq.cod-estabel ~
movto-estoq.serie-docto movto-estoq.nro-docto movto-estoq.cod-emitente ~
movto-estoq.numero-ordem movto-estoq.dt-trans movto-estoq.tipo-trans ~
movto-estoq.quantidade 
&Scoped-define ENABLED-TABLES movto-estoq
&Scoped-define FIRST-ENABLED-TABLE movto-estoq
&Scoped-define DISPLAYED-TABLES movto-estoq
&Scoped-define FIRST-DISPLAYED-TABLE movto-estoq
&Scoped-Define ENABLED-OBJECTS RECT-4 RECT-5 rt-mold rt-mold-2 
&Scoped-Define DISPLAYED-FIELDS movto-estoq.it-codigo ~
movto-estoq.cod-estabel movto-estoq.num-ord-inv movto-estoq.serie-docto ~
movto-estoq.nro-docto movto-estoq.cod-emitente movto-estoq.numero-ordem ~
movto-estoq.dt-trans movto-estoq.tipo-trans movto-estoq.quantidade 
&Scoped-Define DISPLAYED-OBJECTS c-desc-item c-desc-est c-desc-ord ~
c-desc-fornec de-val-mat1 de-val-mob1 de-val-ggf1 de-val-mat2 de-val-mob2 ~
de-val-ggf2 de-val-mat3 de-val-mob3 de-val-ggf3 c-tipo-trans c-moeda ~
c-moeda1 c-moeda2 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS de-val-mat1 de-val-mob1 de-val-ggf1 

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
DEFINE VARIABLE c-desc-est AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 45.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-fornec AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 55.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "x(60)" 
     VIEW-AS FILL-IN 
     SIZE 49.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-ord AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 44 BY .88 NO-UNDO.

DEFINE VARIABLE c-moeda AS CHARACTER FORMAT "X(10)":U 
      VIEW-AS TEXT 
     SIZE 10.43 BY .63 NO-UNDO.

DEFINE VARIABLE c-moeda1 AS CHARACTER FORMAT "x(20)":U 
      VIEW-AS TEXT 
     SIZE 16.29 BY .63 NO-UNDO.

DEFINE VARIABLE c-moeda2 AS CHARACTER FORMAT "X(10)":U 
      VIEW-AS TEXT 
     SIZE 8 BY .63 NO-UNDO.

DEFINE VARIABLE c-tipo-trans AS CHARACTER FORMAT "X(18)":U 
      VIEW-AS TEXT 
     SIZE 16 BY .63 NO-UNDO.

DEFINE VARIABLE de-val-ggf1 AS DECIMAL FORMAT ">>>>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20.86 BY .88 NO-UNDO.

DEFINE VARIABLE de-val-ggf2 AS DECIMAL FORMAT ">>>>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20.86 BY .88 NO-UNDO.

DEFINE VARIABLE de-val-ggf3 AS DECIMAL FORMAT ">>>>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20.86 BY .88 NO-UNDO.

DEFINE VARIABLE de-val-mat1 AS DECIMAL FORMAT ">>>>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 20.86 BY .88 NO-UNDO.

DEFINE VARIABLE de-val-mat2 AS DECIMAL FORMAT ">>>>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 20.86 BY .88 NO-UNDO.

DEFINE VARIABLE de-val-mat3 AS DECIMAL FORMAT ">>>>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 20.86 BY .88 NO-UNDO.

DEFINE VARIABLE de-val-mob1 AS DECIMAL FORMAT ">>>>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20.86 BY .88 NO-UNDO.

DEFINE VARIABLE de-val-mob2 AS DECIMAL FORMAT ">>>>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20.86 BY .88 NO-UNDO.

DEFINE VARIABLE de-val-mob3 AS DECIMAL FORMAT ">>>>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20.86 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 34 BY 1.5.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 83.72 BY 4.5.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88 BY 6.54.

DEFINE RECTANGLE rt-mold-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88 BY 7.08.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-chave
     movto-estoq.it-codigo AT ROW 1.29 COL 18.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     c-desc-item AT ROW 1.29 COL 36.29 COLON-ALIGNED NO-LABEL
     movto-estoq.cod-estabel AT ROW 2.29 COL 18.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.43 BY .88
     c-desc-est AT ROW 2.29 COL 26.29 COLON-ALIGNED NO-LABEL
     movto-estoq.num-ord-inv AT ROW 3.29 COL 18.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .88
     c-desc-ord AT ROW 3.29 COL 28 COLON-ALIGNED NO-LABEL
     movto-estoq.serie-docto AT ROW 4.29 COL 18.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .88
     movto-estoq.nro-docto AT ROW 4.29 COL 55 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     movto-estoq.cod-emitente AT ROW 5.29 COL 18.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .88
     c-desc-fornec AT ROW 5.29 COL 30.14 COLON-ALIGNED NO-LABEL
     movto-estoq.numero-ordem AT ROW 6.29 COL 18.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13.72 BY .88
     movto-estoq.dt-trans AT ROW 8.08 COL 18.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     movto-estoq.tipo-trans AT ROW 8.96 COL 60.86 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Entrada", 1,
"Sa°da", 2
          SIZE 23.72 BY .83
     movto-estoq.quantidade AT ROW 9.08 COL 18.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 21.72 BY .88
     de-val-mat1 AT ROW 11.38 COL 18.72 COLON-ALIGNED
     de-val-mob1 AT ROW 11.38 COL 40.72 COLON-ALIGNED NO-LABEL
     de-val-ggf1 AT ROW 11.38 COL 62.72 COLON-ALIGNED NO-LABEL
     de-val-mat2 AT ROW 12.38 COL 18.72 COLON-ALIGNED
     de-val-mob2 AT ROW 12.38 COL 40.72 COLON-ALIGNED NO-LABEL
     de-val-ggf2 AT ROW 12.38 COL 62.72 COLON-ALIGNED NO-LABEL
     de-val-mat3 AT ROW 13.38 COL 18.72 COLON-ALIGNED
     de-val-mob3 AT ROW 13.38 COL 40.72 COLON-ALIGNED NO-LABEL
     de-val-ggf3 AT ROW 13.38 COL 62.72 COLON-ALIGNED NO-LABEL
     c-tipo-trans AT ROW 8.08 COL 52.43 COLON-ALIGNED NO-LABEL
     c-moeda AT ROW 10.33 COL 24.29 COLON-ALIGNED NO-LABEL
     c-moeda1 AT ROW 10.33 COL 44.43 COLON-ALIGNED NO-LABEL
     c-moeda2 AT ROW 10.33 COL 69.72 COLON-ALIGNED NO-LABEL
     RECT-4 AT ROW 8.46 COL 53.14
     RECT-5 AT ROW 10.08 COL 3.57
     rt-mold AT ROW 1 COL 1
     rt-mold-2 AT ROW 7.75 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.movto-estoq
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
         HEIGHT             = 13.92
         WIDTH              = 88.29.
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
/* SETTINGS FOR FRAME f-chave
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME f-chave:SCROLLABLE       = FALSE
       FRAME f-chave:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-est IN FRAME f-chave
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-fornec IN FRAME f-chave
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-item IN FRAME f-chave
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-ord IN FRAME f-chave
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-moeda IN FRAME f-chave
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-moeda1 IN FRAME f-chave
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-moeda2 IN FRAME f-chave
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tipo-trans IN FRAME f-chave
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-val-ggf1 IN FRAME f-chave
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN de-val-ggf2 IN FRAME f-chave
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-val-ggf3 IN FRAME f-chave
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-val-mat1 IN FRAME f-chave
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN de-val-mat2 IN FRAME f-chave
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-val-mat3 IN FRAME f-chave
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-val-mob1 IN FRAME f-chave
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN de-val-mob2 IN FRAME f-chave
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-val-mob3 IN FRAME f-chave
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN movto-estoq.num-ord-inv IN FRAME f-chave
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-chave
/* Query rebuild information for FRAME f-chave
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME f-chave */
&ANALYZE-RESUME





/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME movto-estoq.cod-emitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-emitente V-table-Win
ON F5 OF movto-estoq.cod-emitente IN FRAME f-chave /* Fornecedor */
DO:
  {include/zoomvar.i &prog-zoom="adzoom/z01ad098.w"
                         &campo=movto-estoq.cod-emitente
                         &campozoom=cod-emitente}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-emitente V-table-Win
ON LEAVE OF movto-estoq.cod-emitente IN FRAME f-chave /* Fornecedor */
DO:
  {include/leave.i &tabela=emitente
                   &atributo-ref=nome-emit
                   &variavel-ref=c-desc-fornec
                   &where="emitente.cod-emitente = input frame {&frame-name} movto-estoq.cod-emitente"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-emitente V-table-Win
ON MOUSE-SELECT-DBLCLICK OF movto-estoq.cod-emitente IN FRAME f-chave /* Fornecedor */
DO:
  APPLY "f5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-estoq.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-estabel V-table-Win
ON F5 OF movto-estoq.cod-estabel IN FRAME f-chave /* Estabel */
DO:
  {include/zoomvar.i &prog-zoom="adzoom/z01ad107.w"
                       &campo=movto-estoq.cod-estabel
                       &campo2=c-desc-est
                       &campozoom=cod-estabel
                       &campozoom2=nome}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-estabel V-table-Win
ON LEAVE OF movto-estoq.cod-estabel IN FRAME f-chave /* Estabel */
DO:
  {include/leave.i &tabela=estabelec
                   &atributo-ref=nome
                   &variavel-ref=c-desc-est
                   &where="estabelec.cod-estabel = input frame {&frame-name}
                           movto-estoq.cod-estabel"}
  ASSIGN c-estab = INPUT FRAME {&FRAME-NAME} movto-estoq.cod-estabel.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-estabel V-table-Win
ON MOUSE-SELECT-DBLCLICK OF movto-estoq.cod-estabel IN FRAME f-chave /* Estabel */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME de-val-ggf1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-val-ggf1 V-table-Win
ON LEAVE OF de-val-ggf1 IN FRAME f-chave
DO:
    do  with frame {&frame-name}:
        if  input frame {&frame-name} de-val-ggf1 = 0 then do with frame {&FRAME-NAME}:
            display 0 @ de-val-ggf2
                    0 @ de-val-ggf3.

            disable de-val-ggf2
                    de-val-ggf3.
        end.
        else do:
            if  param-inv.tem-moeda1 then do:
                enable de-val-ggf2 with frame {&frame-name}.
                run cdp/cd0812.p (0,
                                  param-inv.moeda1,
                                  input frame {&frame-name} de-val-ggf1,
                                  input frame {&frame-name} movto-estoq.dt-trans, output de-aux-1).
            end.
            if  param-inv.tem-moeda2 then do:
                enable de-val-ggf3 with frame {&frame-name}.
                run cdp/cd0812.p (0,
                                  param-inv.moeda2,
                                  input frame {&frame-name} de-val-ggf1,
                                  input frame {&frame-name} movto-estoq.dt-trans, output de-aux-2).
                if  de-aux-2 <> ? then
                    assign de-val-ggf3:screen-value in frame {&frame-name} = string(de-aux-2).
            end.
            if  de-aux-1 <> ? and param-inv.tem-moeda1 then do:
                assign de-val-ggf2:screen-value in frame {&frame-name} = string(de-aux-1).
                if lookup(last-event:label, "TAB,SHIFT-TAB") <> 0 then do:
                    apply last-event:label to self.
                    return no-apply.
                end.
            end.
       end.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME de-val-ggf2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-val-ggf2 V-table-Win
ON LEAVE OF de-val-ggf2 IN FRAME f-chave
DO:
    if lookup(last-event:label, "TAB,SHIFT-TAB") <> 0 then do:
        apply last-event:label to self.
        return no-apply.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME de-val-mat1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-val-mat1 V-table-Win
ON LEAVE OF de-val-mat1 IN FRAME f-chave
DO:
    do  with frame {&frame-name}:
        if input frame {&frame-name} de-val-mat1 = 0 then do with frame {&FRAME-NAME}: 
            display 0 @ de-val-mat2
                    0 @ de-val-mat3.

            disable de-val-mat2
                    de-val-mat3.
        end.
        else do:
            if  param-inv.tem-moeda1 then do:
                enable de-val-mat2 with frame {&frame-name}.
                run cdp/cd0812.p (0,
                                  param-inv.moeda1,
                                  input frame {&frame-name} de-val-mat1,
                                  input frame {&frame-name} movto-estoq.dt-trans, output de-aux-1).
            end.
            if  param-inv.tem-moeda2 then do:
                enable de-val-mat3 with frame {&frame-name}.
                run cdp/cd0812.p (0,
                                  param-inv.moeda2,
                                  input frame {&frame-name} de-val-mat1,
                                  input frame {&frame-name} movto-estoq.dt-trans, output de-aux-2).
                if  de-aux-2 <> ? then
                    assign de-val-mat3:screen-value in frame {&frame-name} = string(de-aux-2).
            end.
            if  de-aux-1 <> ? and param-inv.tem-moeda1 then do:

                assign de-val-mat2:screen-value in frame {&frame-name} = string(de-aux-1).

                if lookup(last-event:label, "TAB,SHIFT-TAB") <> 0 then do:
                    apply last-event:label to self.
                    return no-apply.
                end.
            end.
        end. 
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME de-val-mat2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-val-mat2 V-table-Win
ON LEAVE OF de-val-mat2 IN FRAME f-chave
DO:
    if lookup(last-event:label, "TAB,SHIFT-TAB") <> 0 then do:
        apply last-event:label to self.
        return no-apply.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME de-val-mob1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-val-mob1 V-table-Win
ON LEAVE OF de-val-mob1 IN FRAME f-chave
DO:
    do  with frame {&frame-name}:
        if  input frame {&frame-name} de-val-mob1 = 0 then do with frame {&FRAME-NAME}:
              display 0 @ de-val-mob2
                      0 @ de-val-mob3.

              disable de-val-mob2
                      de-val-mob3.
        end.
        else do:
            if  param-inv.tem-moeda1 then do:
                enable de-val-mob2 with frame {&frame-name}.
                run cdp/cd0812.p (0,
                                  param-inv.moeda1,
                                  input frame {&frame-name} de-val-mob1,
                                  input frame {&frame-name} movto-estoq.dt-trans, output de-aux-1).
            end.
            if  param-inv.tem-moeda2 then do:
                enable de-val-mob3 with frame {&frame-name}.
                run cdp/cd0812.p (0,
                                  param-inv.moeda2,
                                  input frame {&frame-name} de-val-mob1,
                                  input frame {&frame-name} movto-estoq.dt-trans, output de-aux-2).
                if  de-aux-2 <> ? then
                    assign de-val-mob3:screen-value in frame {&frame-name} = string(de-aux-2).
            end.
            if  de-aux-1 <> ? and param-inv.tem-moeda1 then do:
                assign de-val-mob2:screen-value in frame {&frame-name} = string(de-aux-1).
                if lookup(last-event:label, "TAB,SHIFT-TAB") <> 0 then do:
                    apply last-event:label to self.
                    return no-apply.
                end.
            end.
        end.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME de-val-mob2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-val-mob2 V-table-Win
ON LEAVE OF de-val-mob2 IN FRAME f-chave
DO:
    if lookup(last-event:label, "TAB,SHIFT-TAB") <> 0 then do:
        apply last-event:label to self.
        return no-apply.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-estoq.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.it-codigo V-table-Win
ON ENTRY OF movto-estoq.it-codigo IN FRAME f-chave /* Item */
DO:
  if c-it-codigo <> ? then
      assign c-it-codigo = input frame {&frame-name} movto-estoq.it-codigo.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.it-codigo V-table-Win
ON F5 OF movto-estoq.it-codigo IN FRAME f-chave /* Item */
DO:
  {include/zoom.i &prog-zoom="inzoom/z02in172.w"
                   &tabela=movto-estoq
                   &atributo=it-codigo} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.it-codigo V-table-Win
ON LEAVE OF movto-estoq.it-codigo IN FRAME f-chave /* Item */
DO:
  FIND FIRST param-estoq NO-LOCK NO-ERROR.
  ASSIGN c-cod-estabel-usuar = param-estoq.estabel-pad.

  /* Funcao Super/Minas */
  &IF DEFINED(Bf_dis_usuario_estab) &THEN
      IF CAN-FIND(funcao WHERE funcao.cd-funcao = "Fn-estab-usuario"
                           AND funcao.ativo     = YES) THEN DO:
         RUN cdp/cd8702.p (INPUT c-seg-usuario,
                                INPUT-OUTPUT c-cod-estabel-usuar).
      END.
  &ENDIF

  {include/leave.i &tabela=item
                   &atributo-ref=desc-item
                   &variavel-ref=c-desc-item
                   &where="item.it-codigo = input frame {&frame-name}
                                                  movto-estoq.it-codigo"}

  FIND FIRST ITEM
     WHERE item.it-codigo = INPUT FRAME {&frame-name} movto-estoq.it-codigo 
     NO-LOCK NO-ERROR.
  IF AVAIL item AND c-it-codigo <> item.it-codigo THEN
      DO WITH FRAME {&FRAME-NAME}:

      ASSIGN c-it-codigo = item.it-codigo.
      IF param-estoq.estab-uni THEN DO:
         ASSIGN movto-estoq.cod-estabel:SCREEN-VALUE IN FRAME {&FRAME-NAME} = param-estoq.estabel-pad.
         DISABLE movto-estoq.cod-estabel WITH FRAME {&FRAME-NAME}.
      END.
      ELSE
         ASSIGN movto-estoq.cod-estabel:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-cod-estabel-usuar.

      ASSIGN c-cod-localiz = item.cod-localiz
             c-cod-depos = item.deposito-pad.

  END.

  APPLY "leave":U TO movto-estoq.cod-estabel IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.it-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF movto-estoq.it-codigo IN FRAME f-chave /* Item */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-estoq.num-ord-inv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.num-ord-inv V-table-Win
ON ENTRY OF movto-estoq.num-ord-inv IN FRAME f-chave /* Ordem Invest */
DO:
  assign i-num-ord-inv-old = input frame {&frame-name} movto-estoq.num-ord-inv.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.num-ord-inv V-table-Win
ON F5 OF movto-estoq.num-ord-inv IN FRAME f-chave /* Ordem Invest */
DO:
  FIND FIRST estabelec WHERE cod-estabel = INPUT FRAME {&FRAME-NAME} movto-estoq.cod-estabel NO-LOCK NO-ERROR.
  IF AVAIL estabelec THEN
        ASSIGN i-ep-codigo = estabelec.ep-codigo.
  ELSE
        ASSIGN i-ep-codigo = ?.

  {include/zoomvar.i &prog-zoom=ivzoom/z05iv043.w
                     &campo=movto-estoq.num-ord-inv
                     &campozoom=num-ord-magnus
                     &parametros="run pi-seta-inicial in wh-pesquisa
                                  (input i-ep-codigo)."}
  ASSIGN l-zoom-inv = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.num-ord-inv V-table-Win
ON LEAVE OF movto-estoq.num-ord-inv IN FRAME f-chave /* Ordem Invest */
DO:

    IF INPUT FRAME {&FRAME-NAME} movto-estoq.num-ord-inv <> i-num-ord-inv-old OR l-zoom-inv THEN DO:
            ASSIGN l-zoom-inv = NO.
            RUN pi-valida-ordem-investimento(INPUT YES).
            IF RETURN-VALUE = "NOK":U THEN
                RETURN NO-APPLY.
            ELSE IF INPUT FRAME {&FRAME-NAME} movto-estoq.num-ord-inv <> 0 THEN
               ASSIGN movto-estoq.numero-ordem:SENSITIVE IN FRAME {&FRAME-NAME} = FALSE.
            ELSE
               ASSIGN movto-estoq.numero-ordem:SENSITIVE IN FRAME {&FRAME-NAME} = TRUE.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.num-ord-inv V-table-Win
ON MOUSE-SELECT-DBLCLICK OF movto-estoq.num-ord-inv IN FRAME f-chave /* Ordem Invest */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-estoq.numero-ordem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.numero-ordem V-table-Win
ON F5 OF movto-estoq.numero-ordem IN FRAME f-chave /* Ordem */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z01in271.w"
                     &campo=movto-estoq.numero-ordem
                     &campozoom=nr-ord-produ}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.numero-ordem V-table-Win
ON LEAVE OF movto-estoq.numero-ordem IN FRAME f-chave /* Ordem */
DO:
    IF VALID-HANDLE(h_boiv028) THEN DO:
        RUN BuscaOrdemInvOrdProd IN h_boiv028(INPUT INTEGER( movto-estoq.numero-ordem:SCREEN-VALUE IN FRAME {&FRAME-NAME}),
                                           INPUT-OUTPUT i-num-ord-inv).
        ASSIGN movto-estoq.num-ord-inv:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(i-num-ord-inv).
        IF INPUT FRAME {&FRAME-NAME} movto-estoq.numero-ordem <> 0 THEN
           ASSIGN movto-estoq.num-ord-inv:SENSITIVE IN FRAME {&FRAME-NAME} = FALSE.
        ELSE
           ASSIGN movto-estoq.num-ord-inv:SENSITIVE IN FRAME {&FRAME-NAME} = TRUE.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.numero-ordem V-table-Win
ON MOUSE-SELECT-DBLCLICK OF movto-estoq.numero-ordem IN FRAME f-chave /* Ordem */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  if movto-estoq.it-codigo:load-mouse-pointer   ("image/lupa.cur") in frame {&frame-name} then.
  if movto-estoq.cod-estabel:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
  if movto-estoq.num-ord-inv:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
  IF movto-estoq.cod-emitente:LOAD-MOUSE-POINTER ("image/lupa.cur") IN FRAME {&FRAME-NAME} THEN.
  IF movto-estoq.numero-ordem:LOAD-MOUSE-POINTER ("image/lupa.cur") IN FRAME {&FRAME-NAME} THEN.

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).
  &ENDIF


 /************************ INTERNAL PROCEDURES ********************/

{utp/ut-field.i mgind saldo-estoq cod-estabel 1}
ASSIGN movto-estoq.cod-estabel:LABEL IN FRAME {&FRAME-NAME} = RETURN-VALUE.

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
  {src/adm/template/row-list.i "movto-estoq"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "movto-estoq"}

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
  HIDE FRAME f-chave.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initialize-dbos V-table-Win 
PROCEDURE initialize-dbos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF NOT VALID-HANDLE(h_boiv028) THEN
        RUN ivbo/boiv028.p PERSISTENT SET h_boiv028.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  {utp/ut-field.i mgind movto-estoq quantidade 1}
  assign movto-estoq.quantidade:label in frame {&frame-name} = return-value.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  assign movto-estoq.dt-trans:screen-value in frame {&frame-name} = string(today).

  {utp/ut-liter.i Tipo_Transaá∆o * L}
  assign c-tipo-trans = return-value.
  display c-tipo-trans with frame {&frame-name}.

  {utp/ut-liter.i Material * C}
  assign c-moeda = return-value.
  {utp/ut-liter.i M∆o-de-Obra * C}
  assign c-moeda1 = return-value.
  {utp/ut-liter.i GGF * C}
  assign c-moeda2 = return-value.
  display c-moeda
          c-moeda1
          c-moeda2 with frame {&frame-name}.
  DISABLE c-moeda
          c-moeda1
          c-moeda2 with frame {&frame-name}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  for each tt-erro:
      delete tt-erro.
  end.
  for each tt-movto:
      delete tt-movto.
  end.
  find first param-estoq no-lock no-error.       

  /* Code placed here will execute PRIOR to standard behavior. */
  {include/i-valid.i}

  /* Chamada EPC para a assign record */
  {include/i-epc003.i}

  find estabelec where
    estabelec.cod-estabel = input frame {&frame-name} movto-estoq.cod-estabel
    no-lock no-error.

  create tt-movto. 
  assign tt-movto.cod-versao-integracao = 1
         tt-movto.it-codigo       = input frame {&frame-name} movto-estoq.it-codigo
         tt-movto.cod-estabel     = input frame {&frame-name} movto-estoq.cod-estabel
         tt-movto.num-ord-inv     = input frame {&frame-name} movto-estoq.num-ord-inv
         tt-movto.esp-docto       = 6
         tt-movto.cod-prog-orig   = "v15in218"
         tt-movto.atualiza-ul-ent = l-entrada
         tt-movto.usuario         = c-seg-usuario
         tt-movto.quantidade      = input frame {&frame-name} movto-estoq.quantidade.

  ASSIGN tt-movto.cod-localiz = c-cod-localiz
         tt-movto.cod-depos   = c-cod-depos.

  RUN Get-Field-Screen-Value IN adm-broker-hdl
      (INPUT THIS-PROCEDURE,
       INPUT "numero-ordem").

  ASSIGN tt-movto.numero-ordem = INPUT FRAME {&FRAME-NAME} movto-estoq.numero-ordem
         tt-movto.cod-emitente = INPUT FRAME {&FRAME-NAME} movto-estoq.cod-emitente
         tt-movto.serie-docto  = INPUT FRAME {&FRAME-NAME} movto-estoq.serie-docto
         tt-movto.nro-docto    = INPUT FRAME {&FRAME-NAME} movto-estoq.nro-docto
         tt-movto.tipo-trans   = INPUT FRAME {&FRAME-NAME} movto-estoq.tipo-trans
         tt-movto.dt-trans     = INPUT FRAME {&FRAME-NAME} movto-estoq.dt-trans
         tt-movto.valor-mat-m[1] = INPUT FRAME {&FRAME-NAME} de-val-mat1
         tt-movto.valor-mat-m[2] = INPUT FRAME {&FRAME-NAME} de-val-mat2
         tt-movto.valor-mat-m[3] = INPUT FRAME {&FRAME-NAME} de-val-mat3
         tt-movto.valor-mob-m[1] = INPUT FRAME {&FRAME-NAME} de-val-mob1
         tt-movto.valor-mob-m[2] = INPUT FRAME {&FRAME-NAME} de-val-mob2
         tt-movto.valor-mob-m[3] = INPUT FRAME {&FRAME-NAME} de-val-mob3
         tt-movto.valor-ggf-m[1] = INPUT FRAME {&FRAME-NAME} de-val-ggf1
         tt-movto.valor-ggf-m[2] = INPUT FRAME {&FRAME-NAME} de-val-ggf2
         tt-movto.valor-ggf-m[3] = INPUT FRAME {&FRAME-NAME} de-val-ggf3.

  /*----------- Modulo de Investimento -----------*/
  if  param-global.modulo-in
  and input frame {&frame-name} movto-estoq.num-ord-inv <> 0 then do:
      find first estabelec where 
           estabelec.cod-estabel = input frame {&frame-name} movto-estoq.cod-estabel no-lock no-error.
      if avail estabelec then
          assign i-ep-codigo = estabelec.ep-codigo.
      else
          assign i-ep-codigo = ?.   

      assign i-emp-inv = i-ep-codigo
             i-ord-inv = input frame {&frame-name} movto-estoq.num-ord-inv.
      run inp/in2302a.p (INPUT TABLE tt-movto).
      if return-value = "NOK" then 
         undo, return "ADM-ERROR":U.
  end.

  RETURN "OK":U.
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
  &if defined(bf_mat_custeio_item) &then
      /*********************************************************
      ** Para a release 2.04A foi implementado um browser de  **
      ** saldos para os itens que possuirem metodo de custeio **
      ** FIFO/LIFO                                            **
      *********************************************************/
    if valid-handle (h_b01in702) then 
      run pi-passa-item-estab in h_b01in702(input " ", 
                                            input " ").
  &endif
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
  assign c-it-codigo = ?.
  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  assign movto-estoq.num-ord-inv:sensitive in frame {&frame-name} = no.
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

  DISABLE de-val-mat2
          de-val-mat3
          de-val-mob2
          de-val-mob3
          de-val-ggf2
          de-val-ggf3 WITH FRAME {&FRAME-NAME}.    

  IF AVAIL movto-estoq THEN DO:
     FIND item WHERE item.it-codigo = movto-estoq.it-codigo NO-LOCK NO-ERROR.
     IF AVAIL item THEN
        ASSIGN c-desc-item = item.desc-item.

     FIND estabelec
        WHERE estabelec.cod-estabel = movto-estoq.cod-estabel NO-LOCK NO-ERROR.
     IF AVAIL estabelec THEN
        ASSIGN c-desc-est = estabelec.nome.

  END.

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  {utp/ut-liter.i Tipo_Transaá∆o * L}
  assign c-tipo-trans:screen-value in frame {&frame-name} = return-value.

  {utp/ut-liter.i Material * C}
  assign c-moeda = return-value.
  {utp/ut-liter.i M∆o-de-Obra * C}
  assign c-moeda1 = return-value.
  {utp/ut-liter.i GGF * C}
  assign c-moeda2 = return-value.

  if available movto-estoq then  
      display movto-estoq.valor-mat-m[1] @ de-val-mat1
              movto-estoq.valor-mat-m[2] @ de-val-mat2
              movto-estoq.valor-mat-m[3] @ de-val-mat3
              movto-estoq.valor-mob-m[1] @ de-val-mob1
              movto-estoq.valor-mob-m[2] @ de-val-mob2
              movto-estoq.valor-mob-m[3] @ de-val-mob3
              movto-estoq.valor-ggf-m[1] @ de-val-ggf1
              movto-estoq.valor-ggf-m[2] @ de-val-ggf2
              movto-estoq.valor-ggf-m[3] @ de-val-ggf3 with frame {&frame-name}.

  if available movto-estoq then  
          display movto-estoq.valor-mat-m[1] @ de-val-mat1
                  movto-estoq.valor-mat-m[2] @ de-val-mat2
                  movto-estoq.valor-mat-m[3] @ de-val-mat3
                  movto-estoq.valor-mob-m[1] @ de-val-mob1
                  movto-estoq.valor-mob-m[2] @ de-val-mob2
                  movto-estoq.valor-mob-m[3] @ de-val-mob3
                  movto-estoq.valor-ggf-m[1] @ de-val-ggf1
                  movto-estoq.valor-ggf-m[2] @ de-val-ggf2
                  movto-estoq.valor-ggf-m[3] @ de-val-ggf3 with frame {&frame-name}.

  CLEAR FRAME {&FRAME-NAME}.

  DISPLAY c-tipo-trans
          c-moeda
          c-moeda1
          c-moeda2 WITH FRAME {&FRAME-NAME}.

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

  if param-global.modulo-in and
     connected("mginv") then do:
     assign movto-estoq.num-ord-inv:sensitive in frame {&frame-name} = yes.
  end.  
  else do: 
   assign movto-estoq.num-ord-inv:sensitive in frame {&frame-name} = no.
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

  FIND FIRST param-global NO-LOCK NO-ERROR.
  FIND FIRST param-inv NO-LOCK NO-ERROR.

  ASSIGN l-criou = NO.
  ASSIGN c-it-codigo = ?.

  find moeda where moeda.mo-codigo = 0 no-lock no-error.
  if avail moeda then do:
     assign de-val-mat1:label in frame {&frame-name} = moeda.descricao.
  end.

  if param-inv.tem-moeda1 then do:
     find moeda where moeda.mo-codigo = param-inv.moeda1 no-lock no-error.
     if avail moeda then do:
        assign de-val-mat2:label in frame {&frame-name} = moeda.descricao.
     end.
  end.
  else do:
      assign de-val-mat2:visible in frame {&frame-name} = no.
      assign de-val-mob2:visible in frame {&frame-name} = no.
      assign de-val-ggf2:visible in frame {&frame-name} = no.
  end.

  if param-inv.tem-moeda2 then do:
     find moeda where moeda.mo-codigo = param-inv.moeda2 no-lock no-error.
     if avail moeda then do:
        assign de-val-mat3:label in frame {&frame-name} = moeda.descricao.
     end.
  end.
  else do:
      assign de-val-mat3:visible in frame {&frame-name} = no.
      assign de-val-mob3:visible in frame {&frame-name} = no.
      assign de-val-ggf3:visible in frame {&frame-name} = no.
  end.

  RUN initialize-dbos.

  &IF "{&bf_mat_versao_ems}" < "2.062"  &THEN
  IF NOT l-min-mmi THEN DO:
      ASSIGN movto-estoq.numero-ordem:VISIBLE IN FRAME f-chave = NO.
  END.
  &ENDIF

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  {utp/ut-liter.i Tipo_Transaá∆o * L}
  assign c-tipo-trans = return-value.
  {utp/ut-liter.i Material * C}
  assign c-moeda = return-value.
  {utp/ut-liter.i M∆o-de-Obra * C}
  assign c-moeda1 = return-value.
  {utp/ut-liter.i GGF * C}
  assign c-moeda2 = return-value.
  display c-tipo-trans
          c-moeda
          c-moeda1
          c-moeda2  with frame {&frame-name}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-conta V-table-Win 
PROCEDURE pi-atualiza-conta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-passa-handle V-table-Win 
PROCEDURE pi-passa-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param p-handle as handle.

    assign h_window   = p-handle.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-ordem-investimento V-table-Win 
PROCEDURE pi-valida-ordem-investimento :
/*------------------------------------------------------------------------------
  Purpose: Validar ordem de investimento se a mesma for digitada.    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param p-altera-conta as logical.

find first estabelec where cod-estabel = input frame {&frame-name} movto-estoq.cod-estabel no-lock no-error.
if avail estabelec then
   assign i-ep-codigo = estabelec.ep-codigo.
else
   assign i-ep-codigo = ?. 

run inp/in2112b.p (input i-ep-codigo,
                   input "habilita-conta",
                   output c-par-inv).   

assign c-desc-ord:screen-value in frame {&frame-name} = "":U.

if input frame {&frame-name} movto-estoq.num-ord-inv <> 0 then do:
   run inp/in2112a.p (input estabelec.ep-codigo,
                      input frame {&frame-name} movto-estoq.num-ord-inv,
                      output c-desc-ord-inv,
                      output l-achou,
                      output c-conta-inv,
                      output c-centro-custo-inv).

   if not l-achou then do:
      {utp/ut-table.i mginv ordem-inv 1 }
      run utp/ut-msgs.p("show",56,return-value).
      apply 'entry' to  movto-estoq.num-ord-inv in frame {&frame-name}.
      return "nok":U.
   end.
   assign c-desc-ord:screen-value in frame {&frame-name} = c-desc-ord-inv. 
end.              

return "ok":U.

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

    DEFINE VARIABLE l-seleciona AS LOGICAL  INITIAL NO  NO-UNDO.
    DEFINE VARIABLE l-erro-fifo AS LOGICAL  INITIAL NO  NO-UNDO.

    {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */
    /* Chamada EPC para a assign record */

    /* Chamada EPC para a pi-validate */
    {include/i-epc002.i}

    IF NOT AVAIL item THEN DO:
        {include/i-vldprg.i}
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 166,
                           INPUT RETURN-VALUE).
        APPLY "ENTRY":U TO movto-estoq.it-codigo IN FRAME {&frame-name}.
        RETURN "ADM-ERROR":U.
    END.

    /* Ordem Investimento ou Produá∆o <> 0 */
    IF  INPUT FRAME {&FRAME-NAME} movto-estoq.num-ord-inv = 0 AND
        INPUT FRAME {&FRAME-NAME} movto-estoq.numero-ordem = 0 THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-atualizacao-invalida AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Atualizaá∆o_Inv†lida" *}
        ASSIGN c-lbl-liter-atualizacao-invalida = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-ordem-de-investimento-ou-ordem AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Ordem_de_Investimento_ou_Ordem_de_Manutená∆o_deve_ser_informado" *}
        ASSIGN c-lbl-liter-ordem-de-investimento-ou-ordem = TRIM(RETURN-VALUE).
        RUN utp/ut-msgs.p(INPUT "SHOW":U,
                          INPUT 17006,
                          INPUT c-lbl-liter-atualizacao-invalida + "~~" + c-lbl-liter-ordem-de-investimento-ou-ordem).
        APPLY "ENTRY":U to movto-estoq.num-ord-inv IN FRAME {&FRAME-NAME}.
        RETURN "ADM-ERROR":U.
    END.
    ELSE IF movto-estoq.num-ord-inv:SENSITIVE IN FRAME {&FRAME-NAME} = TRUE THEN DO:
        /* Encontrar Empresa */
        FIND FIRST estabelec NO-LOCK
             WHERE estabelec.cod-estabel = INPUT FRAME {&FRAME-NAME} movto-estoq.cod-estabel NO-ERROR.
        IF  AVAIL estabelec THEN
            ASSIGN i-ep-codigo = estabelec.ep-codigo.
        ELSE
            ASSIGN i-ep-codigo = ?. 

        /* Validar Ordem Investimento */
        FIND FIRST sub-div-ordem NO-LOCK
             WHERE sub-div-ordem.ep-codigo      = i-ep-codigo
               AND sub-div-ordem.num-ord-magnus = INPUT FRAME {&FRAME-NAME} movto-estoq.num-ord-inv NO-ERROR.

        IF  NOT AVAIL sub-div-ordem THEN DO:

                {utp/ut-table.i mginv ordem-inv 1}
                RUN utp/ut-msgs.p(INPUT "SHOW":U,
                                  INPUT 56,
                                  INPUT RETURN-VALUE).
                APPLY "ENTRY":U to movto-estoq.num-ord-inv IN FRAME {&FRAME-NAME}.
                RETURN "ADM-ERROR":U.
        END.
    END.
    ELSE DO:
        /*Validar Ordem Manutencao*/
        FIND FIRST ord-prod NO-LOCK
             WHERE ord-prod.nr-ord-produ = INPUT FRAME {&FRAME-NAME} movto-estoq.numero-ordem NO-ERROR.
        IF  NOT AVAIL ord-prod THEN DO:
            {utp/ut-table.i mgind ord-prod 1}
            RUN utp/ut-msgs.p(INPUT "SHOW":U,
                              INPUT 56,
                              INPUT RETURN-VALUE).
            APPLY "ENTRY":U to movto-estoq.numero-ordem IN FRAME {&FRAME-NAME}.
            RETURN "ADM-ERROR":U.
        END.
    END.

    IF AVAIL item AND item.cod-obsoleto = 3 THEN DO:
        {include/i-vldprg.i}
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 1779, 
                           INPUT RETURN-VALUE).
        IF RETURN-VALUE = "NOK":U THEN
            RETURN "ADM-ERROR":U.
    END.

    RUN Pi-validate-2. /* Valida os campos data transacao, quantidade, tipo transacao e moedas */

    /* Chamada EPC para a after validate */
    {include/i-epc019.i} 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate-2 V-table-Win 
PROCEDURE Pi-validate-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{include/i-vldfrm.i}

 /* Validaá∆o Casas Decimais */
 assign l-rejeita-dec = no
        de-val-mat1:screen-value in frame {&frame-name}  = string( fn_vld_ajust_dec( input frame {&frame-name} 
                                                                             de-val-mat1, 0 ) )
        de-val-mat2:screen-value in frame {&frame-name}  = string( fn_vld_ajust_dec( input frame {&frame-name} 
                                                                             de-val-mat2, param-inv.moeda1 ))
        de-val-mat3:screen-value in frame {&frame-name}  = string( fn_vld_ajust_dec( input frame {&frame-name} 
                                                                             de-val-mat3, param-inv.moeda2 ))

        de-val-mob1:screen-value in frame {&frame-name}  = string( fn_vld_ajust_dec( input frame {&frame-name} 
                                                                             de-val-mob1, 0 ))
        de-val-mob2:screen-value in frame {&frame-name}  = string( fn_vld_ajust_dec( input frame {&frame-name} 
                                                                             de-val-mob2, param-inv.moeda1 ))
        de-val-mob3:screen-value in frame {&frame-name}  = string( fn_vld_ajust_dec( input frame {&frame-name} 
                                                                             de-val-mob3, param-inv.moeda2 ))

        de-val-ggf1:screen-value in frame {&frame-name}  = string( fn_vld_ajust_dec( input frame {&frame-name} 
                                                                             de-val-ggf1, 0 ))
        de-val-ggf2:screen-value in frame {&frame-name}  = string( fn_vld_ajust_dec( input frame {&frame-name} 
                                                                             de-val-ggf2, param-inv.moeda1 ))
        de-val-ggf3:screen-value in frame {&frame-name}  = string( fn_vld_ajust_dec( input frame {&frame-name} 
                                                                             de-val-ggf3, param-inv.moeda2 )).


 if  l-rejeita-dec then do:
     run utp/ut-msgs.p (input "show":U, 
                        input 18100, 
                        input " ").
     return 'ADM-ERROR':U.        
 end.



 if  input frame {&frame-name} movto-estoq.quantidade > 0 and
     input frame {&frame-name} de-val-mat2 = 0 and 
     input frame {&frame-name} de-val-mat1 > 0 and 
     param-inv.tem-moeda1 then do:
    {include/i-vldprg.i}
     run utp/ut-msgs.p (input "show":U, 
                        input 1802,
                        input "2").
     apply "entry" to de-val-mat2 in frame {&frame-name}.
     return 'ADM-ERROR':U.      
 end.     
 if input frame {&frame-name} movto-estoq.quantidade > 0 and
     input frame {&frame-name} de-val-mat3 = 0 and 
     input frame {&frame-name} de-val-mat1 > 0 and 
     param-inv.tem-moeda2 then do:
    {include/i-vldprg.i}
    run utp/ut-msgs.p (input "show":U, 
                       input 1802, 
                       input "3").
    apply "entry" to de-val-mat3 in frame {&frame-name}.                       
    return 'ADM-ERROR':U.                            
 end. 

 if input frame {&frame-name} movto-estoq.quantidade > 0 and
    input frame {&frame-name} de-val-mob2 = 0 and 
    input frame {&frame-name} de-val-mob1 > 0 and 
     param-inv.tem-moeda1 then do:
    {include/i-vldprg.i}
    run utp/ut-msgs.p (input "show":U, 
                       input 1803, 
                       input "2").
    apply "entry" to de-val-mob2 in frame {&frame-name}.                       
    return 'ADM-ERROR':U.                            
 end.
 if input frame {&frame-name} movto-estoq.quantidade > 0 and
    input frame {&frame-name} de-val-mob3 = 0 and 
    input frame {&frame-name} de-val-mob1 > 0 and 
     param-inv.tem-moeda2 then do:
    {include/i-vldprg.i}
    run utp/ut-msgs.p (input "show":U, 
                       input 1803, 
                       input "3").
    apply "entry" to de-val-mob3 in frame {&frame-name}.                   
    return 'ADM-ERROR':U.                            
 end. 

 if  input frame {&frame-name} movto-estoq.quantidade > 0 and
     input frame {&frame-name} de-val-ggf2 = 0 and 
     input frame {&frame-name} de-val-ggf1 > 0 and 
     param-inv.tem-moeda1 then do:
    {include/i-vldprg.i}
     run utp/ut-msgs.p (input "show":U, 
                        input 6431,
                        input "2").
     apply "entry" to de-val-ggf2 in frame {&frame-name}.
     return 'ADM-ERROR':U.                            
 end.     
 if  input frame {&frame-name} movto-estoq.quantidade > 0 and
     input frame {&frame-name} de-val-ggf3 = 0 and 
     input frame {&frame-name} de-val-ggf1 > 0 and 
     param-inv.tem-moeda2 then do:
    {include/i-vldprg.i}
    run utp/ut-msgs.p (input "show":U, 
                       input 6431, 
                       input "3").
    apply "entry" to de-val-ggf3 in frame {&frame-name}.                       
    return 'ADM-ERROR':U.                            
 end. 


 if input frame {&frame-name} de-val-mat1 <= 0 and
    input frame {&frame-name} de-val-mob1 <= 0 and
    input frame {&frame-name} de-val-ggf1 <= 0 and
    input frame {&frame-name} movto-estoq.quantidade   <= 0  then do:
    {include/i-vldprg.i}
    run utp/ut-msgs.p (input "show":U, 
                       input 1811, 
                       input "3").
    return 'ADM-ERROR':U.
 end.

 if input frame {&frame-name} movto-estoq.dt-trans > today then do:
    {include/i-vldprg.i}
    run utp/ut-msgs.p (input "show":U, 
                       input 1788, 
                       input return-value).
    apply "entry" to movto-estoq.dt-trans in frame {&frame-name}.                       
    return 'ADM-ERROR':U.  
 end.    

 if input frame {&frame-name} movto-estoq.quantidade < 0 then do:
    {include/i-vldprg.i}
    run utp/ut-msgs.p (input "show":U, 
                       input 1790, 
                       input return-value).
    apply "entry" to movto-estoq.quantidade in frame {&frame-name}.                       
    return 'ADM-ERROR':U.  
 end.      
 assign de-qtd = input frame {&frame-name} movto-estoq.quantidade.
 if  not(item.fraciona) and 
    de-qtd <> int(de-qtd) then do:
    {include/i-vldprg.i}
    run utp/ut-msgs.p (input "show":U, 
                       input 847, 
                       input return-value).
    apply "entry" to movto-estoq.quantidade in frame {&frame-name}.                       
    return 'ADM-ERROR':U.  
 end.    

 if item.tipo-con-est = 2 then  do:
    if  input frame {&frame-name} movto-estoq.quantidade <> 0 and
        input frame {&frame-name} movto-estoq.quantidade <> 1 then do:
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show":U, 
                           input 1836, 
                           input return-value).
        apply "entry" to movto-estoq.quantidade in frame {&frame-name}.
        return 'ADM-ERROR':U.  
    end.
 end.    

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
  {src/adm/template/snd-list.i "movto-estoq"}

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

