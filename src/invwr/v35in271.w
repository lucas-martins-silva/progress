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
{include/i-prgvrs.i V35IN271 2.00.00.058 } /*** "010058" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v35in271 MUT}
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
def new global shared var gr-ord-prod  as rowid no-undo.                              
def new global shared var gr-item      as rowid no-undo.
def new global shared var l-gera-ficha as log   no-undo.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions ---                                       */
def var i-baixa-reservas              as int    no-undo init 1.
def var l-informa-deposito            as log    no-undo init yes.
def var l-informa-localizacao         as log    no-undo.
def var l-requisicao-automatica       as log    no-undo.
def var l-busca-saldos                as log    no-undo.
def var l-acabado-on-line             as log    no-undo init yes.
def var l-requis-on-line              as log    no-undo init yes.
def var l-gera-pedido-rpw             as log    no-undo.
def var c-arquivo-saida               as char   no-undo.

define temp-table tt-param
    field destino          as integer
    field arquivo          as char
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field item-ini         as char
    field item-fim         as char
    field data-ini         as date
    field data-fim         as date
    field rep-ini          as integer
    field rep-fim          as integer
    field situacao         as integer.

/* Transfer Definitions */

def var raw-param        as raw no-undo.

def temp-table tt-raw-digita
   field raw-digita      as raw.

define var c-programa-mg97       as char format "x(08)" no-undo.
define var c-versao-mg97         as char format "x(08)" no-undo.   

def var c-it-codigo             as char format "x(16)"      no-undo.
def var c-lista-estados         as char format "x(100)"     no-undo.
def var r-registro              as rowid                    no-undo.
def var l-erro                  as logical                  no-undo.
def var r-ult-oper              as rowid                    no-undo.
def var l-problema              as logical format "Sim/Nao" no-undo.
def var i-mensagem              as int                      no-undo.
def var c-msg                   as char                     no-undo.
def var l-ultima                as logical                  no-undo.
def var rw-oper-ord             as rowid                    no-undo.
def var c-cod-depos             like ord-prod.cod-depos     no-undo.
def var c-lote-serie            like ord-prod.lote-serie    no-undo.
def var c-cod-refer             like ord-prod.cod-refer     no-undo.
def var rw-erro                 as rowid                    no-undo.
def var de-reporta              like ord-prod.qt-reportada  no-undo.
def var l-atu-pl                as logical                  no-undo.
def var de-quantidade-refugo    as dec                      no-undo.
def var da-dt-trans             as date                     no-undo.
def var l-encerra               as logical                  no-undo.
def var l-erro-ver              as logical                  no-undo.
def var l-reserva               as logical                  no-undo.
def var c-it-codigo-aux         as char                     no-undo.
def var c-retorno               as char                     no-undo.
def var i-retorno               as integer                  no-undo.
def var c-erro                  as char                     no-undo.
def var c-texto                 as char                     no-undo.
def var c-campo                 as char                     no-undo.
def var i-cont                  as integer                  no-undo.
def var l-cancelar              as logical                  no-undo.
DEFINE VARIABLE l-possui-ficha AS LOGICAL     NO-UNDO.

/* Handles utilizadas para habilitar ou desabilitar os objetos do programa 
   dependendo das informacoes desta viewer                              */
def var wh-handle-window      as handle                 no-undo.   
def var c-handle              as char                   no-undo.
def var h-handle              as handle                 no-undo.
def var wh-handle-viewer-1    as handle                 no-undo.
def var wh-handle-viewer-2    as handle                 no-undo.
def var wh-handle-browse-res  as handle                 no-undo.
def var wh-handle-browse-aloc as handle                 no-undo.
def var wh-fill-in-erro       as handle                 no-undo.

def var l-erro-valid          as logical                no-undo.
def var l-prim-exec           as logical init yes       no-undo.
def var l-zoom                as logical                no-undo.
def var c-lista-estados-operacao as char                no-undo.
def var de-menor-prod         as decimal                no-undo.
def var de-saldo-cq           as decimal                no-undo.
def var de-menor-cq           as decimal                no-undo.
def var r-b-oper-ord          as rowid                  no-undo.
def var da-data-ultimo-reporte as date                  no-undo.
def var l-message              as logical               no-undo.
def var l-repete               as logical               no-undo.
def var rw-saldo-estoq         as rowid                 no-undo.
def var de-saldo-ped           as decimal               no-undo.

DEFINE VARIABLE de-qt-estorno AS DECIMAL     NO-UNDO.


/* Variavel global utilizada na construcao do zoom z02in260.w */
def new global shared var i-ordem like oper-ord.nr-ord-produ no-undo.

/* Variavel global utilizada no cd0220.p */
def new global shared var r-ord-prod as rowid no-undo.

/* Variavel para reposicionamento de registros */
def new global shared var gr-ord-prod as rowid no-undo.
def new global shared var gr-item     as rowid no-undo.

def buffer b-oper-ord for oper-ord.
DEF BUFFER b2-oper-ord FOR oper-ord.

{cdp/cdcfgman.i} /* Include com preprocessador para release 2.02 */ 
{cpp/cpapi001.i}
{cpp/cpapi001.i28} /* f-retorna-ult-oper */
{cdp/cd0666.i}
{cpp/cp9060.i}
{cdp/cd9203.i}     /* Function f-item-uni-estab        */
&IF DEFINED (bf_man_204) &THEN
   {mnbo/bomn161.i1} /* tt-Utiliza */
   {method/dbotterr.i} /* rowerrors */
   DEFINE NEW global shared var h-bomn161 as handle    no-undo.
   DEFINE VARIABLE hShowMsg               AS HANDLE    NO-UNDO.
   DEFINE VARIABLE l-interf-util          AS LOGICAL INITIAL NO NO-UNDO.
&endif

def new global shared var h-acomp as handle no-undo.

def new global shared var gi-nr-ord-produ like ord-prod.nr-ord-produ  no-undo.
def new global shared var gr-parametro-reporte as rowid no-undo.

def temp-table tt-oper no-undo
    field rec-oper as rowid
    INDEX rw-oper IS UNIQUE PRIMARY rec-oper.

def var r-saida as rowid no-undo.    
def var da-dt-ult-reporte as date no-undo.
def var de-qt-reporte as decimal no-undo.
def var i-estado as integer no-undo.

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
&Scoped-define EXTERNAL-TABLES ord-prod
&Scoped-define FIRST-EXTERNAL-TABLE ord-prod


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR ord-prod.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ord-prod.nr-ord-produ 
&Scoped-define ENABLED-TABLES ord-prod
&Scoped-define FIRST-ENABLED-TABLE ord-prod
&Scoped-Define ENABLED-OBJECTS rt-key 
&Scoped-Define DISPLAYED-FIELDS ord-prod.nr-ord-produ ord-prod.it-codigo ~
ord-prod.cod-refer ord-prod.qt-ordem ord-prod.qt-produzida ~
ord-prod.qt-refugada 
&Scoped-define DISPLAYED-TABLES ord-prod
&Scoped-define FIRST-DISPLAYED-TABLE ord-prod
&Scoped-Define DISPLAYED-OBJECTS fi-estado fi-descricao-item fi-saldo ~
fi-pto-controle fi-descricao fi-estado-oper 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS ord-prod.it-codigo fi-pto-controle 
&Scoped-define ADM-MODIFY-FIELDS ord-prod.it-codigo fi-pto-controle 

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

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD f-retorna-campo V-table-Win 
FUNCTION f-retorna-campo RETURNS CHARACTER
  ( input c-campo as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD f-tem-upc V-table-Win 
FUNCTION f-tem-upc RETURNS LOGICAL
  ( /* no-parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE fi-descricao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 33 BY .88 NO-UNDO.

DEFINE VARIABLE fi-descricao-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-estado AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS FILL-IN 
     SIZE 43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-estado-oper AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE fi-pto-controle AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE fi-saldo AS DECIMAL FORMAT "->>>>>,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 6.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     ord-prod.nr-ord-produ AT ROW 1.17 COL 17.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     fi-estado AT ROW 1.17 COL 36 COLON-ALIGNED NO-LABEL
     ord-prod.it-codigo AT ROW 2.25 COL 17.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     fi-descricao-item AT ROW 2.25 COL 36 COLON-ALIGNED NO-LABEL
     ord-prod.cod-refer AT ROW 3.25 COL 17.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     ord-prod.qt-ordem AT ROW 4.25 COL 17.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     ord-prod.qt-produzida AT ROW 4.25 COL 65 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     ord-prod.qt-refugada AT ROW 5.25 COL 17.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     fi-saldo AT ROW 5.25 COL 65 COLON-ALIGNED
     fi-pto-controle AT ROW 6.25 COL 17.57 COLON-ALIGNED
     fi-descricao AT ROW 6.25 COL 26 COLON-ALIGNED NO-LABEL
     fi-estado-oper AT ROW 6.25 COL 65 COLON-ALIGNED NO-LABEL
     rt-key AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.ord-prod
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
         HEIGHT             = 6.63
         WIDTH              = 88.57.
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

/* SETTINGS FOR FILL-IN ord-prod.cod-refer IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-descricao-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-estado IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-estado-oper IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-pto-controle IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN fi-saldo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ord-prod.it-codigo IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN ord-prod.qt-ordem IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ord-prod.qt-produzida IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ord-prod.qt-refugada IN FRAME f-main
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

&Scoped-define SELF-NAME fi-pto-controle
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-pto-controle V-table-Win
ON F5 OF fi-pto-controle IN FRAME f-main
DO:
  assign gi-nr-ord-produ = ord-prod.nr-ord-produ.
  {include/zoomvar.i &prog-zoom="inzoom/z02in364.w"
                     &campo=fi-pto-controle
                     &campozoom=pto-controle
                     &campo2=fi-descricao
                     &campozoom2=descricao}. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-pto-controle V-table-Win
ON LEAVE OF fi-pto-controle IN FRAME f-main
DO:                                               
  if input frame {&frame-name} fi-pto-controle <> fi-pto-controle then do:                                                    
     assign fi-pto-controle.
     find first pto-controle where pto-controle.codigo = fi-pto-controle
          no-lock no-error.
     if avail pto-controle then do: 
        assign fi-descricao   = pto-controle.descricao.       

        find first oper-ord 
             where oper-ord.nr-ord-produ = ord-prod.nr-ord-produ
               and oper-ord.pto-controle = input frame {&frame-name} fi-pto-controle
               no-error. 
        if avail(oper-ord) then do:
           run set-attribute-list in this-procedure (input "RW-OPER=" + 
               string (rowid (oper-ord))).
           find first tt-oper no-lock no-error.
           if avail tt-oper then
              for each tt-oper:
                  delete tt-oper.
              end. 
           create tt-oper.
           assign tt-oper.rec-oper = rowid (oper-ord).
           run pi-pesquisa-rede-pert in h-handle (input-output table tt-oper,
                                                  rowid (oper-ord),
                                                  output r-saida).                                                                                                              
            
           /* FO1428898 */  /* N�o estava encotrando ultimo pto-controle reportado corretamente
                               desta maneira mesmo havendo reportes anteriores o r-saida era 
                               igual a ? */
           IF r-saida = ? THEN
               FOR LAST   b2-oper-ord
                    WHERE b2-oper-ord.nr-ord-produ = ord-prod.nr-ord-produ
                    AND   b2-oper-ord.pto-controle <> 0 
                    AND   b2-oper-ord.qt-produzida <> 0 NO-LOCK:
               END.

           find b-oper-ord
                where rowid (b-oper-ord) = r-saida no-lock no-error.

           if not avail b-oper-ord or b-oper-ord.qt-produzida > 0 then
              assign rw-oper-ord = rowid (oper-ord)
                     da-dt-ult-reporte = today.
           else
               assign rw-oper-ord = ?.     
           &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
           RUN utp/ut-liter.p (trim({ininc/i01in260.i 04 oper-ord.estado}), "*", "").
           assign fi-estado-oper = return-value
                  l-ultima       = (rowid(oper-ord) = r-ult-oper).
           &else
           assign fi-estado-oper = {ininc/i01in260.i 04 oper-ord.estado}
                  l-ultima       = (rowid(oper-ord) = r-ult-oper).
           &endif
        end.
        else
           assign fi-estado-oper = ""
                  l-ultima       = no
                  rw-oper-ord    = ? . 
     end.
     else
        assign fi-descricao   = ""
               fi-estado-oper = ""
               l-ultima       = no
               rw-oper-ord    = ? .

     display fi-descricao 
             fi-estado-oper
             with frame {&frame-name}.

     
    IF rw-oper-ord <> ? then do:                        
        assign de-qt-reporte = if avail b-oper-ord then
                                  b-oper-ord.qt-produzida - oper-ord.qt-produzida
                               else 
                                   IF AVAIL b2-oper-ord 
                                      AND (b2-oper-ord.qt-produzida - oper-ord.qt-produzida) > 0 THEN
                                       b2-oper-ord.qt-produzida - oper-ord.qt-produzida
                                   ELSE
                                       ord-prod.qt-ordem - oper-ord.qt-produzida.
        if de-qt-reporte < 0 then
           assign de-qt-reporte = 0.


        assign de-saldo-cq      = 0
               de-menor-cq      = 0
               l-possui-ficha   = NO.

        for each pert-ordem WHERE
            pert-ordem.nr-ord-produ = ord-prod.nr-ord-produ and
            pert-ordem.it-codigo    = oper-ord.it-codigo    and
            pert-ordem.cod-roteiro  = oper-ord.cod-roteiro  and
            pert-ordem.op-codigo    = oper-ord.op-codigo no-lock:
            find first b-oper-ord where 
                b-oper-ord.nr-ord-produ = pert-ordem.nr-ord-produ and
                b-oper-ord.it-codigo    = pert-ordem.it-predec    and
                b-oper-ord.cod-roteiro  = pert-ordem.rot-predec   and
                b-oper-ord.op-codigo    = pert-ordem.op-predec no-lock no-error.

            if b-oper-ord.qt-produzida < de-menor-prod then
                assign de-menor-prod = b-oper-ord.qt-produzida r-b-oper-ord  = rowid(b-oper-ord).

            FOR EACH ficha-cq FIELDS(nr-ficha nr-ord-produ origem op-seq qt-aprovada qt-apr-cond situacao)
                WHERE ficha-cq.nr-ord-produ = b-oper-ord.nr-ord-prod
                AND ficha-cq.op-seq       = b-oper-ord.sequencia
                AND ficha-cq.origem       = 3
                AND ficha-cq.situacao    <> 5 NO-LOCK:

                IF l-possui-ficha = NO THEN
                    ASSIGN l-possui-ficha = YES.

                FOR EACH ord-rep FIELDS(nr-ord-produ nr-ficha nr-reporte)
                    WHERE ord-rep.nr-ord-produ = ficha-cq.nr-ord-produ
                    AND ord-rep.nr-ficha     = ficha-cq.nr-ficha NO-LOCK:
                    FOR EACH rep-prod FIELDS(nr-reporte qt-estorno)
                        WHERE rep-prod.nr-reporte = ord-rep.nr-reporte
                        AND rep-prod.qt-estorno > 0 NO-LOCK:
                        ASSIGN de-qt-estorno = de-qt-estorno + rep-prod.qt-estorno.
                    END.
                END.

                ASSIGN de-saldo-cq   = de-saldo-cq + ficha-cq.qt-aprovada + ficha-cq.qt-apr-cond - de-qt-estorno
                       de-qt-estorno = 0.
            END.

            if de-saldo-cq < de-menor-cq or de-menor-cq = 0 then
                assign de-menor-cq = de-saldo-cq.
        end.

        assign de-saldo-cq = de-menor-cq.

        IF l-possui-ficha = YES AND
           de-qt-reporte  > de-saldo-cq THEN
            ASSIGN de-qt-reporte = de-saldo-cq * 10000.
        ELSE
            ASSIGN de-qt-reporte = de-qt-reporte * 10000.


        run set-attribute-list in this-procedure ('quant-reporte=' + string (de-qt-reporte)).   

        run notify ('pi-habilita-campos,record-target').

        /* So habilita o browse de MOB para operacoes internas */                                                 
        if param-global.modulo-cs      and 
           param-global.modulo-ce      and
          ((ord-prod.reporte-mob = 1  and oper-ord.cd-mob-dir <> "") or
            ord-prod.reporte-ggf = 1) and
            oper-ord.tipo = 1        
           then              
               run notify ('pi-habilita-browse-mob,record-target').                                                                                                  
           else                                                 
               run notify ('pi-desabilita-browse-mob,record-target').
        return no-apply.
     end.                                                            
     else do:
          run notify ('pi-desabilita-campos,record-target').
          run notify ('pi-desabilita-browse-mob,record-target').                                                              
     end.
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-pto-controle V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-pto-controle IN FRAME f-main
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-pto-controle V-table-Win
ON tab OF fi-pto-controle IN FRAME f-main
DO:
  apply 'leave' to fi-pto-controle in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ord-prod.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ord-prod.it-codigo V-table-Win
ON F5 OF ord-prod.it-codigo IN FRAME f-main /* Item */
DO:
  {include/zoomvar.i &prog-zoom="inzoom/z02in172.w"
                     &campo=ord-prod.it-codigo
                     &campozoom=it-codigo}.                       
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ord-prod.it-codigo V-table-Win
ON LEAVE OF ord-prod.it-codigo IN FRAME f-main /* Item */
DO:
   if input frame {&frame-name} ord-prod.it-codigo <> c-it-codigo-aux then do:
      assign c-it-codigo-aux = input frame {&frame-name} ord-prod.it-codigo.      
      find item where 
           item.it-codigo eq input frame {&frame-name} ord-prod.it-codigo
           no-lock no-error.        
      if avail(item) then do:
         run notify ('pi-habilita-campos,record-target').
         run notify ('pi-atualiza-item,record-target').
      end.
      else
          run notify ('pi-desabilita-campos,record-target').
   end. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ord-prod.it-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF ord-prod.it-codigo IN FRAME f-main /* Item */
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

{utp/ut-liter.i Saldo * L}
assign fi-saldo:label in frame {&frame-name} = return-value.

{utp/ut-field.i mgind oper-ord pto-controle 1}
assign fi-pto-controle:label in frame {&frame-name} = return-value.

if ord-prod.it-codigo:load-mouse-pointer ("image/lupa.cur") then.
if fi-pto-controle:load-mouse-pointer ("image/lupa.cur") then.

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
  {src/adm/template/row-list.i "ord-prod"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "ord-prod"}

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

  /* Retirado para nao executar a pi-validate automaticamente */ 
  /*  {include/i-valid.i} */

  reporte:
  /** Bloco principal da confirma��o do reporte **/
  do transaction on error undo on stop undo:  

      if not avail oper-ord then do:
         {utp/ut-table.i mgind oper-ord 1}
         run utp/ut-msgs.p (input "show",
                            input 47,
                            input return-value).
         apply 'entry' to fi-pto-controle in frame {&frame-name}.
         undo reporte, return "ADM-ERROR":U.
      end.

      RUN set-cursor in adm-broker-hdl ("WAIT").

      for each tt-rep-prod:
          delete tt-rep-prod.
      end.

      create tt-rep-prod.

      assign tt-rep-prod.nr-ord-prod       = ord-prod.nr-ord-prod.

      /* Assign anterior n�o pode esta junto com a function f-retorna-campo, 
         pois ocorre erro de compila��o no progress 9 */  

      assign tt-rep-prod.prog-seg          = "cp0321"
             tt-rep-prod.tipo              = 3
             tt-rep-prod.carrega-reservas  = l-busca-saldos
             tt-rep-prod.procura-saldos    = l-busca-saldos
             tt-rep-prod.requis-automatica = l-requisicao-automatica
             tt-rep-prod.data              = date (f-retorna-campo ("fi-dt-trans"))
             tt-rep-prod.un                = ord-prod.un
             tt-rep-prod.cod-depos-sai     = if l-informa-deposito and
                                                not param-cp.dep-fab-unico then
                                                f-retorna-campo ('fi-cod-depos')
                                             else ?
             tt-rep-prod.cod-local-sai     = if l-informa-localizacao then
                                                f-retorna-campo ('fi-cod-localiz')
                                             else ?         
             tt-rep-prod.pto-controle      = oper-ord.pto-controle
             tt-rep-prod.qt-reporte        = dec (f-retorna-campo ("fi-quantidade-reporte"))
             tt-rep-prod.qt-refugo         = dec (f-retorna-campo ("fi-quantidade-refugo"))
             tt-rep-prod.it-codigo         = input frame {&frame-name} ord-prod.it-codigo
             tt-rep-prod.qt-apr-cond       = dec (f-retorna-campo ("fi-quantidade-aprov-cond"))
             tt-rep-prod.nro-docto         = f-retorna-campo ("fi-nro-docto")
             tt-rep-prod.serie-docto       = f-retorna-campo ("fi-serie-docto")
             tt-rep-prod.cod-depos         = f-retorna-campo ("fi-cod-depos-acabado")
             tt-rep-prod.lote-serie        = f-retorna-campo ("fi-lote-serie-acabado")
             tt-rep-prod.cod-refer         = f-retorna-campo ("fi-cod-refer-acabado")
             tt-rep-prod.dt-vali-lote      = date (f-retorna-campo ("fi-dt-validade-lote-acabado"))
             tt-rep-prod.cod-localiz       = f-retorna-campo ("fi-cod-localiz-acabado")
             tt-rep-prod.ct-refugo         = f-retorna-campo ("fi-ct-refugo")
             tt-rep-prod.sc-refugo         = f-retorna-campo ("fi-sc-refugo")
             tt-rep-prod.cod-cta-unif      = f-retorna-campo ("fi-ct-db")
			 tt-rep-prod.cod-ccusto-unif   = f-retorna-campo ("fi-sc-db")
			 
           &IF DEFINED (bf_man_per_ppm) &THEN
             tt-rep-prod.per-ppm           = dec (f-retorna-campo ("fi-per-ppm-acabado"))
           &ENDIF
             .

      assign i-retorno = 1.  
      if tt-rep-prod.qt-refugo > 0  then do:    
         RUN set-cursor in adm-broker-hdl ("").   

         if param-global.modulo-cq = yes and
            param-cq.tipo-cq > 1 and
            f-item-uni-estab (input item.it-codigo,
                              input ord-prod.cod-estabel,
                              "contr-qualid") = "yes":U then    
        run cpp/cp9060.w (input-output table tt-ref-ordem,
                              input tt-rep-prod.qt-refugo,
                              input 1,
                              input 0,
                              output i-retorno).      
      end.  
      if i-retorno = 0 then
         undo reporte, return "ADM-ERROR":U.    

      assign i-retorno = 1.   
      if tt-rep-prod.qt-apr-cond > 0 then do:      
         RUN set-cursor in adm-broker-hdl ("").

         if param-global.modulo-cq = yes and
            param-cq.tipo-cq > 1 and
            f-item-uni-estab (input item.it-codigo,
                              input ord-prod.cod-estabel,
                              "contr-qualid") = "yes":U then    
            run cpp/cp9060.w (input-output table tt-ref-ordem,
                              input tt-rep-prod.qt-apr-cond,
                              input 2,
                              input 0,
                              output i-retorno).   
      end.  
      if i-retorno = 0 then
         undo reporte, return "ADM-ERROR":U.    

      for each tt-refugo:
          delete tt-refugo.
      end.   

      for each tt-ref-ordem:
          create tt-refugo.
          assign tt-refugo.nr-ord-produ = ord-prod.nr-ord-prod
                 tt-refugo.codigo-rejei = tt-ref-ordem.codigo-rejei
                 tt-refugo.qt-refugo    = tt-ref-ordem.qt-refugo
                 tt-refugo.observacao   = tt-ref-ordem.observacao.
      end.

      run pi-recebe-tt-refugo in h-handle (input table tt-refugo).

      run pi-recebe-tt-rep-prod in h-handle (input table tt-rep-prod).

      run pi-valida-rep-prod in h-handle (input  yes,
                                          input  ord-prod.nr-ord-prod,
                                          output c-erro,
                                          output c-texto).

      assign c-retorno = return-value.       

      RUN set-cursor in adm-broker-hdl ("").                               

      /****** Verifica se j� existe ficha de CQ para Item/Lote *****/
      run pi-valida-ficha-cq in h-handle (input yes).

      if tt-rep-prod.qt-reporte - tt-rep-prod.qt-refugo > 0 then do:

          if param-cp.log-ficha-ord then do:

              run pi-valida-ficha-cq in h-handle (input NO).

              if item.tipo-con-est = 3 or
                 item.tipo-con-est = 4 then do:

                  find first oper-ord 
                       where oper-ord.nr-ord-produ = ord-prod.nr-ord-produ
                       and oper-ord.pto-controle = input frame {&frame-name} fi-pto-controle
                       no-error. 

                  find first ficha-cq NO-LOCK
                       where ficha-cq.it-codigo   = tt-rep-prod.it-codigo
                       and   ficha-cq.cod-estabel = ord-prod.cod-estabel
                       and   ficha-cq.cod-depos   = tt-rep-prod.cod-depos
                       and   ficha-cq.cod-localiz = tt-rep-prod.cod-localiz
                       and   ficha-cq.lote        = tt-rep-prod.lote-serie 
                       AND   ficha-cq.situacao    < 4
                       AND   ficha-cq.op-seq      = oper-ord.sequencia no-error.
                  if avail ficha-cq then do: 
                      run utp/ut-msgs.p (input "show",
                                         input 19503,
                                         input "").

                      run pi-valida-ficha-cq in h-handle (input (RETURN-VALUE = "YES")).
                  end.
              end.
          end.
      end. /* Quantidade CQ > 0 */
      else
          run pi-valida-ficha-cq in h-handle (input  no).

      if c-retorno = "nok" then do:
         case int (entry (1, c-erro)):
              when 56 then do:
                   {utp/ut-table.i mgind localizacao 1}
                   if entry (1, c-texto) = return-value then
                      assign c-campo = "fi-cod-localiz-acabado".
                   {utp/ut-table.i mgadm conta-contab 1}
                   if entry (1, c-texto) = return-value then
                      assign c-campo = "fi-ct-db".
              end.

              when 166 or when 563 or when 693 or when 3454 then 
                   apply 'entry' to ord-prod.it-codigo in frame {&frame-name}.

              when 106 or when 6610 then assign c-campo = "fi-conta-debito-direto".

              when 530 or when 3412 then 
                   assign c-campo = "fi-cod-depos".

              when 847 or when 1234 or when 2372 or when 5808 then 
                   assign c-campo = "fi-quantidade-reporte".

              when 3428 then
                   assign c-campo = "fi-quantidade-refugo".

              when 2386 or when 2387 or when 2388 then
                   assign c-campo = "fi-ct-refugo".

              when 2389 or when 2390 then 
                   assign c-campo = "fi-quantidade-aproc-cond".

              when 2403 or when 7410 then
                   assign c-campo = "fi-cod-depos-acabado".

              when 2793 then
                   assign c-campo = "fi-dt-trans".

              when 1252 or when 2408 or when 2158 then
                   assign c-campo = "fi-lote-serie-acabado".

              when 529 or when 1235 or when 1236 then
                   assign c-campo = "fi-cod-refer-acabado".

              when 1247 or when 2409 or when 2410 then
                   assign c-campo = "fi-dt-validade-lote-acabado".

              otherwise assign c-campo = "".
         end case.

         run set-attribute-list ("campo=" + c-campo).

         if c-campo <> "" then     
            run notify ('pi-apply-entry,record-target').
      end.

      do i-cont = 1 to num-entries (c-erro):
         run utp/ut-msgs.p (input "show",
                            input int (entry (i-cont, c-erro)),
                            input entry (i-cont, c-texto)).
      end.

      if c-retorno = "nok" then undo reporte, return "ADM-ERROR":U.

      run pi-validate.
      if return-value eq "adm-error" then undo reporte, return "ADM-ERROR":U.

      run notify ('pi-validate,record-target').

      if return-value = "adm-error" then
         undo reporte, return "ADM-ERROR":U.

      assign c-retorno = "".

      /* Chamada EPC para a assign record */
         {include/i-epc003.i}

      run notify ('pi-grava-arquivos,record-target').     

      run utp/ut-acomp.p persistent set h-acomp.

      {utp/ut-liter.i Processando_Reporte *}
      run pi-inicializar in h-acomp ( Return-value ).

      run pi-desabilita-cancela in h-acomp.

      if l-acabado-on-line then do:
         run pi-processa-reportes in h-handle (input-output table tt-rep-prod,
                                               input        table tt-refugo,
                                               input        table tt-res-neg,
                                               input-output table tt-erro,
                                               input yes,
                                               input l-requis-on-line).                    
         assign c-retorno = return-value.  
      end.

      if valid-handle (h-acomp) then
         run pi-finalizar in h-acomp.

      find first tt-erro no-error.   
      if avail tt-erro then
         run cdp/cd0666.w (input table tt-erro).

      if c-retorno = "nok" then
         undo reporte, return "adm-error":U.

      RUN pi-valida-movto.

      if return-value = "adm-error" then
         undo reporte, return "adm-error":U.

  end. /** Bloco reporte **/

  /* Code placed here will execute AFTER standard behavior.    */   

  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

  find first tt-rep-prod.   

  if rowid (oper-ord) = f-retorna-ult-oper (input ord-prod.nr-ord-prod) then do:          
     /* Texto da ordem */
     if ord-prod.prototipo then do:
        find texto-ordem where 
             texto-ordem.nr-ord-prod = ord-prod.nr-ord-prod 
             no-lock no-error.
        if avail(texto-ordem) 
        then     
           assign gr-parametro-reporte = rowid(texto-ordem).
        else 
           assign gr-parametro-reporte = ? .   
        run cpp/cp0328.w.
     end.   

     if l-requisicao-automatica  and
        not can-find(first al-res-op where 
                           al-res-op.nr-ord-prod = ord-prod.nr-ord-prod) and
        item.tipo-requis = 1     then do:
        run cpp/cp0311f.w (input rowid(ord-prod)      ,
                           input tt-rep-prod.cod-depos,
                           input tt-rep-prod.lote-serie,
                           input tt-rep-prod.cod-localiz,
                           input tt-rep-prod.data,
                           input tt-rep-prod.qt-reporte).                 
        if return-value eq "adm-error" then return return-value.
     end.                             

     if tt-rep-prod.qt-reporte - tt-rep-prod.qt-refugo > 0 then do: 
        if can-find(first al-pr-op where al-pr-op.nr-ord-prod = ord-prod.nr-ord-prod) then do:
           find first saldo-estoq use-index dep-estabel where
                      saldo-estoq.cod-depos   = tt-rep-prod.cod-depos   and
                      saldo-estoq.cod-estabel = ord-prod.cod-estabel    and
                      saldo-estoq.cod-localiz = tt-rep-prod.cod-localiz and
                      saldo-estoq.lote        = tt-rep-prod.lote-serie  and
                      saldo-estoq.it-codigo   = ord-prod.it-codigo
                      no-lock no-error.
           assign rw-saldo-estoq = if avail(saldo-estoq) then rowid(saldo-estoq)
                                                         else ?.
           assign l-repete = yes.
           do while l-repete :                                                    
              run cpp/cp9042.w (input (tt-rep-prod.qt-reporte -
                                       tt-rep-prod.qt-refugo),
                                input  rw-saldo-estoq  ,
                                output de-saldo-ped    ).
              if de-saldo-ped > 0 then do:
                 /* Pedidos nao foram totalmente atendidos. retorna para alocacao?. */                                            
                 run utp/ut-msgs.p (input "show",
                                    input 6030  ,
                                    input ""    ).
                 if return-value eq "yes" then assign l-repete = yes.
                                          else assign l-repete = no .                
              end.                             
              else assign l-repete = no.
           end.              
        end.                                                             
     end.          
  end.           

  RUN pi-utilizacao.  /* a partir da 2.04 */

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

  assign l-cancelar = yes.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

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

  assign fi-pto-controle:screen-value = ""
         fi-pto-controle              = 0
         fi-descricao:screen-value    = ""
         fi-descricao                 = ""
         fi-estado-oper:screen-value  = ""
         fi-estado-oper               = "".       

  run notify ('pi-desabilita-campos,record-target').
  run notify ('pi-desabilita-browse-mob,record-target').                                                                       

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

  &IF DEFINED (bf_man_per_ppm) &THEN
    def var h-viewer  as handle no-undo.
    def var l-per-ppm as log    no-undo.
  &ENDIF

  if avail ord-prod then do:

     &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
     RUN utp/ut-liter.p (trim({ininc/i01in271.i 04 ord-prod.estado}), "*", "").
     assign fi-estado = return-value.
     &else
     assign fi-estado = {ininc/i01in271.i 04 ord-prod.estado}.
     &endif
     find item where item.it-codigo = ord-prod.it-codigo no-lock no-error.
     if avail item then do:
        assign fi-descricao-item = item.desc-item.
        &IF DEFINED (bf_man_per_ppm) &THEN
             assign l-per-ppm = (param-global.modulo-per-ppm and
                                 item.tipo-formula >= 2      and
                                 item.tipo-formula <= 3).
             run pi-retorna-handle (output h-viewer).
             if valid-handle (h-viewer) then
                 run pi-formata-tela in h-viewer (input if not l-per-ppm then 1
                                                                         else 2,
                                                  input if not l-per-ppm then 0
                                                                         else item.tipo-formula).
        &ENDIF
     end.
     else
         assign fi-descricao-item = "".
     assign fi-saldo  = if ord-prod.qt-ordem - ord-prod.qt-produzida > 0
                           then ord-prod.qt-ordem - ord-prod.qt-produzida
                           else 0.                          
  end.
  else
      assign fi-descricao-item = "".

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

  def var c-handle as char no-undo.
  /* Code placed here will execute PRIOR to standard behavior. */

  IF ord-prod.origem = "MV":U THEN DO:
     run utp/ut-msgs.p (input "show",
                        input 29505 ,
                        input ""    ).
     RUN Who-Is-The-Container IN adm-broker-hdl
                     (INPUT this-procedure,
                      OUTPUT c-handle).
     run pi-cancela in widget-handle(c-handle).
     return "adm-error":u.
  END.

  &IF defined(bf_man_sfc_lc) &THEN
     else DO:
         IF NOT AVAIL param-sfc THEN
             FIND FIRST param-sfc NO-LOCK NO-ERROR.
         IF CAN-FIND(FIRST rep-oper-ctrab WHERE rep-oper-ctrab.nr-ord-produ = oper-ord.nr-ord-produ NO-LOCK)
     &IF DEFINED (bf_man_sfc_magnus) &THEN 
       &IF DEFINED (bf_man_sfc_ref_oper) &THEN  
       &ELSE
            AND AVAIL param-sfc AND param-sfc.ind-integracao-mfg = 1 
       &ENDIF
     &ENDIF
         THEN do:
             /*Esta ordem j� possui reportes no Ch�o de F�brica. Por este motivo, 
             o reporte de todas as opera��es da ordem deve ser feito atrav�s do m�dulo Ch�o de F�brica.*/
            run utp/ut-msgs.p (input "show":u,
                               input 29377,
                               input "").
            RUN Who-Is-The-Container IN adm-broker-hdl
                            (INPUT this-procedure,
                             OUTPUT c-handle).
            run pi-cancela in widget-handle(c-handle).
            return "adm-error":u.
         end.
     END.
  &ENDIF

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  for each tt-ref-ordem:
      delete tt-ref-ordem.
  end.

  assign ord-prod.nr-ord-produ:sensitive in frame {&frame-name} = no     
         ord-prod.it-codigo:sensitive in frame {&frame-name} = 
         param-cp.pede-item and ord-prod.estado < 6
         c-it-codigo-aux = ord-prod.it-codigo.          

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-end-update V-table-Win 
PROCEDURE local-end-update :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE c-return AS CHARACTER  NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'end-update':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  if rowid (oper-ord) = f-retorna-ult-oper (input ord-prod.nr-ord-prod) then do:  
     /* Altera Estado da Ordem de Producao para Terminada/Finalizada ? */
     run utp/ut-msgs.p (input "show",
                        input (if not param-global.modulo-cs then
                                 5603
                               else 5604),
                        input trim(STRING(ord-prod.nr-ord-produ,">>>,>>>,>>9"))).
     assign c-return = return-value.

     if f-tem-upc() and ord-prod.rep-prod = 3 then do:
        run piCriaPontoUpc (input "FinalizaOrdem":U,
                            input c-return).
        assign c-return = return-value.
     end.

     if c-return = "yes" then do:
        &IF DEFINED (bf_man_linha_estab) &THEN
        find first lin-prod
             where lin-prod.cod-estabel = ord-prod.cod-estabel
               and lin-prod.nr-linha    = ord-prod.nr-linha no-lock no-error.        
        &ELSE
        find first lin-prod
             where lin-prod.nr-linha = ord-prod.nr-linha no-lock no-error.
        &ENDIF
        if avail lin-prod then do:           
           if param-cp.ver-req and lin-prod.sum-requis = 2 then do:
              run cpp/cp0311g.p (input rowid(ord-prod)      ,
                                 output l-erro-ver          ,
                                 input "2"                  ,
                                 input ord-prod.qt-reportada,
                                 input yes                  ,
                                 input i-baixa-reservas           ).
              if l-erro-ver then return "adm-error".
           end.
        end.
        for each  b-oper-ord
            where b-oper-ord.nr-ord-prod = ord-prod.nr-ord-prod
            no-lock by b-oper-ord.sequencia:
            leave.
        end.
        if can-find (first oper-ord 
                     where oper-ord.nr-ord-prod  = ord-prod.nr-ord-prod
                       and oper-ord.qt-produzida < b-oper-ord.qt-produzida) then do:
           run utp/ut-msgs.p (input "show",
                              input 16715,
                              input "").
           if return-value = "yes" then
              run pi-finaliza-ordem in h-handle (input ord-prod.nr-ord-prod).
           else do:           
                if oper-ord.estado <> 3 then do:
                   find current oper-ord exclusive-lock.
                   /* Funcao Bombas Leao */
                   IF not CAN-FIND(funcao WHERE funcao.cd-funcao = "spp-finaliza-operacao"
                                        AND funcao.ativo     = YES) THEN DO:
                      /* Finaliza Operacao da Ordem ? */
                      run utp/ut-msgs.p (input "show",
                                         input 3446  ,
                                         input ""    ).
                   
                      assign c-return = return-value.                             
                   END.
                   ELSE /* Se tiver a funcao da Bombas Leao n�o vai emitir a mensagem nunca */
                       assign c-return = "no".

                   if f-tem-upc() and ord-prod.rep-prod = 3 then do:
                      run piCriaPontoUpc (input "FinalizaOperacao":U,
                                          input c-return).
                      assign c-return = return-value.
                   end.

                   assign i-estado = if c-return = "yes" then 3 else 2.
                   for each tt-oper:
                       delete tt-oper.
                   end.
                   create tt-oper.
                   assign tt-oper.rec-oper = rowid (oper-ord).
                   run pi-pesquisa-rede-pert in h-handle (input-output table tt-oper,
                                                          rowid (oper-ord),
                                                          output r-saida).                   
                   for each tt-oper:
                       find oper-ord where
                            rowid (oper-ord) = tt-oper.rec-oper
                       exclusive-lock.
                       assign oper-ord.estado = i-estado.
                   end.
                end.           
           end.           
        end.
        else run pi-finaliza-ordem in h-handle (input ord-prod.nr-ord-prod).
     end.
     else do:     
          if oper-ord.estado <> 3 then do:

             find current oper-ord exclusive-lock.
             /* Funcao Bombas Leao */
             IF not CAN-FIND(funcao WHERE funcao.cd-funcao = "spp-finaliza-operacao"
                                  AND funcao.ativo     = YES) THEN DO:
                /* Finaliza Operacao da Ordem ? */
                run utp/ut-msgs.p (input "show",
                                   input 3446  ,
                                   input ""    ).
             
                assign c-return = return-value.                             
             END.
             ELSE /* Se tiver a funcao da Bombas Leao n�o vai emitir a mensagem nunca */
                 assign c-return = "no".

             if f-tem-upc() and ord-prod.rep-prod = 3 then do:
                run piCriaPontoUpc (input "FinalizaOperacao":U,
                                    input c-return).
                assign c-return = return-value.
             end.

             assign i-estado = if c-return = "yes" then 3 else 2.

             for each tt-oper:
                 delete tt-oper.
             end.
             create tt-oper.
             assign tt-oper.rec-oper = rowid (oper-ord).
             run pi-pesquisa-rede-pert in h-handle (input-output table tt-oper,
                                                    rowid (oper-ord),
                                                    output r-saida).                   
             for each tt-oper:
                 find oper-ord where
                      rowid (oper-ord) = tt-oper.rec-oper
                 exclusive-lock.
                 assign oper-ord.estado = i-estado.


             end.
          end.
     end. 
  end.
  else do:
       if oper-ord.estado <> 3 then do:
          find current oper-ord exclusive-lock.
          /* Funcao Bombas Leao */
          IF not CAN-FIND(funcao WHERE funcao.cd-funcao = "spp-finaliza-operacao"
                               AND funcao.ativo     = YES) THEN DO:
             /* Finaliza Operacao da Ordem ? */
             run utp/ut-msgs.p (input "show",
                                input 3446  ,
                                input ""    ).
          
             assign c-return = return-value.                             
          END.
          ELSE /* Se tiver a funcao da Bombas Leao n�o vai emitir a mensagem nunca */
              assign c-return = "no".

          if f-tem-upc() and ord-prod.rep-prod = 3 then do:
             run piCriaPontoUpc (input "FinalizaOperacao":U,
                                 input c-return).
             assign c-return = return-value.
          end.

          assign i-estado = if c-return = "yes" then 3 else 2.
          for each tt-oper:
              delete tt-oper.
          end.
          create tt-oper.
          assign tt-oper.rec-oper = rowid (oper-ord).
          run pi-pesquisa-rede-pert in h-handle (input-output table tt-oper,
                                                 rowid (oper-ord),
                                                 output r-saida).                   
          for each tt-oper:
              find oper-ord where
                   rowid (oper-ord) = tt-oper.rec-oper
              exclusive-lock.
              assign oper-ord.estado = i-estado.

          end.
       end.
  end.


  /*/* Dispatch standard ADM method.                             */    
 *   RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .  
 * if RETURN-VALUE = 'ADM-ERROR':U then 
 *    RETURN 'ADM-ERROR':U.*/

  if l-gera-pedido-rpw then do:
     for each tt-param:
         delete tt-param.
     end.
     create tt-param.
     assign tt-param.usuario   = c-seg-usuario
            tt-param.destino   = 2
            tt-param.data-exec = today
            tt-param.hora-exec = time
            tt-param.arquivo   = if c-arquivo-saida = "" then
                                    "op" + string (ord-prod.nr-ord-prod, "999999")
                                 else c-arquivo-saida
            tt-param.item-ini  = ord-prod.it-codigo
            tt-param.item-fim  = ord-prod.it-codigo
            tt-param.data-ini  = date (f-retorna-campo ("fi-dt-trans"))
            tt-param.data-fim  = date (f-retorna-campo ("fi-dt-trans"))
            tt-param.rep-ini   = 0
            tt-param.rep-fim   = 0
            tt-param.situacao  = 1.

     raw-transfer tt-param    to raw-param.
     RUN Who-Is-The-Container IN adm-broker-hdl
        (INPUT this-procedure,
         OUTPUT c-handle).
     run pi-retorna-nome-versao in widget-handle (c-handle) (output c-programa-mg97,
                                                             output c-versao-mg97)
                                                             no-error.
     run btb/btb911zb.p (input c-programa-mg97,
                         input "cpp/cp0332rp.p",
                         input c-versao-mg97,
                         input 97,
                         input tt-param.arquivo,
                         input tt-param.destino,
                         input raw-param,
                         input table tt-raw-digita,
                         output i-num-ped-exec-rpw).

     if i-num-ped-exec-rpw <> 0 then                     
        run utp/ut-msgs.p (input "show", 
                           input 4169, 
                           input string(i-num-ped-exec-rpw)).                      
  end.   

  run dispatch ('display-fields').                      

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

  /* Code placed here will execute AFTER standard behavior.    */
  find first param-global no-lock no-error.
  find first param-cp     no-lock no-error.     
  if param-global.modulo-ce then do:
     find first param-cq  no-lock no-error.  
  end.

  &IF DEFINED (bf_man_204) &THEN
      IF param-global.modulo-mi THEN DO:
         FIND FIRST param-mi NO-LOCK NO-ERROR.

         IF AVAIL (param-mi) THEN DO:
  &endif
         &IF DEFINED (bf_man_206) &THEN
             ASSIGN l-interf-util = param-mi.log-interf-util.
         &ELSEIF DEFINED(bf_man_204) &then
             ASSIGN l-interf-util = param-mi.log-1.
         &endif

  &IF DEFINED (bf_man_204) &THEN
         END.
      END.
  &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-reset-record V-table-Win 
PROCEDURE local-reset-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'reset-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  if not l-cancelar then do:
     assign fi-pto-controle   = 0.
     run dispatch ('display-fields').
     run dispatch ('enable-fields').
     run notify ('pi-desabilita-campos,record-target').
  end.

  assign l-cancelar = no.

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

  if avail ord-prod then  
     assign gr-ord-prod = rowid (ord-prod).
  if avail item then 
     assign gr-item = rowid (item).   

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-parametros V-table-Win 
PROCEDURE pi-atualiza-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter p-baixa-reservas        as int    no-undo.
    def input parameter p-informa-deposito      as log    no-undo.
    def input parameter p-informa-localizacao   as log    no-undo.
    def input parameter p-requisicao-automatica as log    no-undo.
    def input parameter p-busca-saldos          as log    no-undo.
    def input parameter p-acabado-on-line       as log    no-undo.
    def input parameter p-requis-on-line        as log    no-undo.
    def input parameter p-gera-pedido-rpw       as log    no-undo.
    def input parameter p-arquivo-saida         as char   no-undo.

    assign i-baixa-reservas        = p-baixa-reservas
           l-informa-deposito      = p-informa-deposito
           l-informa-localizacao   = p-informa-localizacao
           l-requisicao-automatica = p-requisicao-automatica
           l-busca-saldos          = p-busca-saldos
           l-acabado-on-line       = p-acabado-on-line
           l-requis-on-line        = p-requis-on-line
           l-gera-pedido-rpw       = p-gera-pedido-rpw
           c-arquivo-saida         = p-arquivo-saida.       

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recebe-handle V-table-Win 
PROCEDURE pi-recebe-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RUN Who-Is-The-Container IN adm-broker-hdl
    (INPUT  this-procedure,
     OUTPUT c-handle).

run get-attribute in widget-handle (c-handle) (input 'HANDLE').

assign h-handle = widget-handle (return-value).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-handle V-table-Win 
PROCEDURE pi-retorna-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def output param p-handle as handle.

def var c-handle as char   no-undo.
def var h-handle as handle no-undo.
def var h-frame  as handle no-undo.
def var i-cont   as int    no-undo.

    run who-is-the-container in adm-broker-hdl (input this-procedure, output c-handle).
    assign h-handle = widget-handle(c-handle).

    run get-link-handle in adm-broker-hdl (input  h-handle, 
                                           input  "container-target":U,
                                           output c-handle).
    do i-cont = 1 to num-entries(c-handle):
        assign h-handle = widget-handle(entry(i-cont,c-handle)).
        if h-handle:file-name = "invwr/v38in271.w":u then
            assign p-handle = h-handle.
    end.    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-utilizacao V-table-Win 
PROCEDURE pi-utilizacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR pic-cd-tecnico-ant AS CHAR INITIAL ""  NO-UNDO.
DEF VAR l-ok               AS LOGICAL INIT YES NO-UNDO.

&IF DEFINED (bf_man_204) &THEN        
  if  valid-handle (h-bomn161) THEN DO:

   RUN emptyRowErrors in h-bomn161.

   RUN getTTUtiliza IN h-bomn161(OUTPUT TABLE tt-utiliza).
   IF CAN-FIND(FIRST tt-utiliza) THEN DO:

      IF l-interf-util THEN DO: /* Caso interfira, permitira o usu�rio alterar as informa��es */
         DO WHILE l-ok:
            RUN cpp/cp0311mi.w (input-output table tt-utiliza,
                                input  1,
                                input  h-bomn161,
                                output l-ok).
            IF l-ok = NO THEN DO: /* pressionado bot�o cancela */
               run utp/ut-msgs.p (input "show":u,
                                  input 30133,
                                  input "").
               IF RETURN-VALUE = "YES":U THEN DO:
                  ASSIGN l-ok = YES.
               END.
            END.
            ELSE DO:
               ASSIGN l-ok = NO.
            END.
         END.
      END.
      ELSE DO: /* Caso n�o interfira, ser� gerada a utiliza��o automaticamente */
         FOR EACH tt-utiliza NO-LOCK:
             IF pic-cd-tecnico-ant <> tt-utiliza.cd-tecnico THEN DO:
                RUN verificaTecnicoMI in h-bomn161 (input tt-utiliza.cd-tecnico).
                ASSIGN pic-cd-tecnico-ant = tt-utiliza.cd-tecnico.
             END.
         END.

         RUN getRowErrors IN h-bomn161 (OUTPUT TABLE RowErrors).
         find first rowErrors no-error.
         IF AVAIL rowErrors then do:
               /*{method/showmessage.i1}
               {method/showmessage.i2 &modal=yes}*/
             run utp/ut-msgs.p (input "show":u,
                                input 30132,
                                input "").
         end.
         ELSE DO:
            RUN PropagaUtilizacaoEquipto IN h-bomn161 (INPUT TABLE tt-utiliza, INPUT 1).
         END.
      END.
   END.
 END.
&endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-movto V-table-Win 
PROCEDURE pi-valida-movto :
/*------------------------------------------------------------------------------
  Purpose:     Valida��o da exist�ncia de movimenta��es de MOB, GGF e materiais
               para a ordem que est� sendo reportada.
  Parameters: 
  Notes:       
------------------------------------------------------------------------------*/
define buffer b-movto-dir for movto-dir.
define buffer b-movto-ggf for movto-ggf.
define buffer b-movto-mat for movto-mat.

/** Verificado que no Magnus n�o utiliza esta valida��o **/
/* if ord-prod.reporte-mob = 1 and  */
/*    ord-prod.reporte-ggf = 1 then */

    IF NOT CAN-FIND(FIRST b-movto-dir WHERE   /** MOB **/
                          b-movto-dir.nr-ord-produ = ord-prod.nr-ord-prod NO-LOCK) AND
       NOT CAN-FIND(FIRST b-movto-ggf WHERE   /** GGF **/
                          b-movto-ggf.nr-ord-produ = ord-prod.nr-ord-prod NO-LOCK) AND 
       NOT CAN-FIND(FIRST b-movto-mat WHERE   /** Materiais **/
                          b-movto-mat.nr-ord-produ = ord-prod.nr-ord-prod and 
                          b-movto-mat.esp-doct    <> 1 NO-LOCK) THEN DO:
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 27731,
                           INPUT STRING(ord-prod.nr-ord-prod)).
        IF RETURN-VALUE = "no":U THEN
            RETURN "adm-error":U.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-ordem V-table-Win 
PROCEDURE pi-valida-ordem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN Who-Is-The-Container IN adm-broker-hdl
       (INPUT this-procedure,
        OUTPUT c-handle).
    run get-attribute in widget-handle (c-handle) (input "tipo-reporte").           

    run pi-valida-ordem in h-handle (input yes,
                                     input ord-prod.nr-ord-prod,
                                     input int (return-value),
                                     output c-erro,
                                     output c-texto).           
    assign c-retorno = return-value.

    do i-cont = 1 to num-entries (c-erro):
       run utp/ut-msgs.p (input "show",
                          input int (entry (i-cont, c-erro)),
                          input entry (i-cont, c-texto)).
    end.


/***************************
    &IF DEFINED (bf_man_sfc_lc) &THEN

        find first param-global no-lock no-error.
        if  param-global.modulo-ch = yes then do:

            find op-sfc
                where op-sfc.nr-ord-produ = ord-prod.nr-ord-produ no-lock no-error.
            if  avail op-sfc then do:
                assign c-retorno = "nok".
                run utp/ut-msgs.p (input "show",
                                   input 18932,
                                   input "").
            end.
        end.

    &ENDIF
***************************/


    return c-retorno.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: N�o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas valida��es, pois neste ponto do programa o registro 
  ainda n�o foi criado.       
------------------------------------------------------------------------------*/
  {include/i-vldfrm.i} /* Valida��o de dicion�rio */

  /* Chamada EPC para a pi-validate */
     {include/i-epc002.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCriaPontoUPC V-table-Win 
PROCEDURE piCriaPontoUPC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.

def var c-container  as char    no-undo.
DEFINE VARIABLE c-ret-ant AS CHARACTER  NO-UNDO.

    run Who-Is-The-Container in adm-broker-hdl
        (input this-procedure,
         output c-container).

     &IF DEFINED(OriginalName) <> 0 &THEN
     ASSIGN THIS-PROCEDURE:PRIVATE-DATA = "{&OriginalName}".
     &ELSE
     ASSIGN THIS-PROCEDURE:PRIVATE-DATA = THIS-PROCEDURE:file-name.
     &ENDIF

     if  valid-handle(widget-handle(c-container)) then do:
         /* UPC */
         run pi-retorna-upc in widget-handle(c-container).
         if  return-value <> ""
         and return-value <> ? then do:                  

             assign c-nom-prog-upc-mg97 = return-value
                    c-ret-ant = c-nom-prog-upc-mg97.
             run value(c-nom-prog-upc-mg97) (input p-ind-event, 
                                             input p-ind-object,
                                             input this-procedure,
                                             input frame {&FRAME-NAME}:handle,
                                             input "{&FIRST-EXTERNAL-TABLE}",
             &IF DEFINED(FIRST-EXTERNAL-TABLE) = 0 &THEN                                 
                                             input ?).
             &ELSE
                                             input (if  avail {&FIRST-EXTERNAL-TABLE} then rowid({&FIRST-EXTERNAL-TABLE}) else ?)).    
             &ENDIF

             IF RETURN-VALUE = "" OR RETURN-VALUE = ? OR 
                /*c-ret-ant = RETURN-VALUE OR*/ p-ind-object = "yes" THEN
                 RETURN "yes":U.

             return return-value.  
         end.                                       
         else
             assign c-nom-prog-upc-mg97 = "".             
     end.

    RETURN "yes":U.
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
  {src/adm/template/snd-list.i "ord-prod"}

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

 /* Include com os tratamentos necess�rios � valida��o antes que se 
     habilite os campos                                           */

 {cpp/cp9100.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION f-retorna-campo V-table-Win 
FUNCTION f-retorna-campo RETURNS CHARACTER
  ( input c-campo as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  RUN Get-Field-Screen-Value IN adm-broker-hdl
     (INPUT this-procedure,
      INPUT c-campo).

  RETURN return-value.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION f-tem-upc V-table-Win 
FUNCTION f-tem-upc RETURNS LOGICAL
  ( /* no-parameter-definitions */ ) :
  def var c-container as char no-undo.
  def var callUPC        as log  no-undo.

  run Who-Is-The-Container in adm-broker-hdl (input  this-procedure,
                                              output c-container).

  if  valid-handle(widget-handle(c-container)) then do:
      run pi-retorna-upc  in widget-handle(c-container).
      if return-value <> "" then
         assign callUPC = yes.
  end.

  if callUPC then
     return true.
  else
     return false.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

