&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
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
{include/i-prgvrs.i V02IN081 2.00.00.055 } /*** "010055" 18/12/2024 16:12:50 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v02in081 MUT}
&ENDIF



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
def var v-row-parent as rowid no-undo.

def var i-nr-proces as integer no-undo.
def var i-cod-emite as integer no-undo.
def var da-data-cot as date no-undo.

/* Local Variable Definitions ---                                       */
def var i-codigo as integer extent 5 NO-UNDO.
def var da-data-indice as date extent 5 NO-UNDO.
def var de-perc-reaj as decimal extent 5 NO-UNDO.

def var i-cont as integer no-undo.
def var d-tot-preco as decimal no-undo.
def var de-perc-tot as decimal no-undo.

def var i-preco-bruto     as integer no-undo.
def var l-preco-bruto     as logical initial NO NO-UNDO.

{cdp/cdcfgmat.i}
{ccp/ccapi346.i} /* tt-fornecedores-participantes; tt-fornecedores-convidados; tt-erro-clicbusiness */


def temp-table tt-cotacao-item NO-UNDO
 field marca            as   log format "*/ ":u init no
 field i-erro           as   int
 field numero-ordem     like ordem-compra.numero-ordem
 field it-codigo        like cotacao-item.it-codigo
 field cod-emitente     like cotacao-item.cod-emitente
 field seq-cotac        like cotacao-item.seq-cotac
 field un               as char format "x(2)"
 field qt-acum-nec      like ordem-compra.qt-acum-nec
 field entrega          as char format "x(10)"
 field preco-fornec     like cotacao-item.preco-fornec
 field aliquota-ipi     like cotacao-item.aliquota-ipi
 field aliquota-icm     like cotacao-item.aliquota-icm
 field preco-unit       like cotacao-item.preco-unit
 field pre-unit-for     like cotacao-item.pre-unit-for
 field ind-ret-cotac    like cotacao-item.ind-ret-cotac
 field ind-orig-entrada like cotacao-item.ind-orig-entrada
 field ind-via-envio    like cotacao-item.ind-via-envio
 field narrativa        like ordem-compra.narrativa.

def buffer b-tt-cotacao-item for tt-cotacao-item.

def var de-indice             as decimal init 1 NO-UNDO.
DEF VAR de-moeda-antiga       LIKE cotacao-item.mo-codigo NO-UNDO.
def var l-importacao          as logical no-undo.
def var l-emitente-importacao as logical no-undo.
def var de-preco-unit-ant     like cotacao-item.preco-unit no-undo.
DEF VAR l-integra-ems-his     AS LOG NO-UNDO.
DEF VAR l-valida-fabric-medic AS LOG NO-UNDO.
DEF VAR c-lista-fab           AS CHAR NO-UNDO.
DEFINE VARIABLE iProcesso AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-opcao AS CHARACTER NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-14 RECT-2 RECT-3 RECT-4 RECT-53 ~
i-mo-codigo d-valor-frete da-data-cotacao i-validade i-cod-cond-pag ~
i-prazo-entreg c-cod-comprado d-aliquota-iss c-contato d-perc-descto ~
i-cod-transp c-nome-fabric-medic l-codigo-ipi d-cotar-ate i-codigo-icm ~
l-frete tg-clicbusiness l-possui-reaj d-valor-taxa i-nr-dias-taxa ~
l-taxa-financ c-clicbusiness 
&Scoped-Define DISPLAYED-OBJECTS i-mo-codigo c-descricao de-cotacao ~
d-valor-frete da-data-cotacao i-validade i-cod-cond-pag c-desc-pagto ~
i-prazo-entreg c-cod-comprado d-aliquota-iss c-contato d-perc-descto ~
d-dt-preco-base i-cod-transp fi-transporte c-nome-fabric-medic l-codigo-ipi ~
d-cotar-ate i-codigo-icm l-frete tg-clicbusiness l-possui-reaj d-valor-taxa ~
i-nr-dias-taxa l-taxa-financ c-cotacao c-icms c-clicbusiness 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS da-data-cotacao 

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
DEFINE VARIABLE c-nome-fabric-medic AS CHARACTER FORMAT "X(256)":U 
     LABEL "Fabricante" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 56.57 BY 1 NO-UNDO.

DEFINE VARIABLE c-clicbusiness AS CHARACTER FORMAT "X(16)":U INITIAL "Clicbusiness" 
      VIEW-AS TEXT 
     SIZE 11 BY .67 TOOLTIP "Clicbusiness" NO-UNDO.

DEFINE VARIABLE c-cod-comprado AS CHARACTER FORMAT "X(12)" INITIAL "A" 
     LABEL "Comprador":R9 
     VIEW-AS FILL-IN 
     SIZE 16.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-contato AS CHARACTER FORMAT "X(40)" 
     LABEL "Contato":R9 
     VIEW-AS FILL-IN 
     SIZE 26 BY .88 NO-UNDO.

DEFINE VARIABLE c-cotacao AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 11.57 BY .63 NO-UNDO.

DEFINE VARIABLE c-desc-pagto AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE VARIABLE c-descricao AS CHARACTER FORMAT "x(12)" 
     VIEW-AS FILL-IN 
     SIZE 29 BY .88 NO-UNDO.

DEFINE VARIABLE c-icms AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 5.86 BY .67 NO-UNDO.

DEFINE VARIABLE d-aliquota-iss AS DECIMAL FORMAT ">>9.99" INITIAL 6 
     LABEL "Aliquota ISS":R15 
     VIEW-AS FILL-IN 
     SIZE 10.86 BY .88 NO-UNDO.

DEFINE VARIABLE d-cotar-ate AS DATE FORMAT "99/99/9999":U 
     LABEL "Cotar atÇ" 
     VIEW-AS FILL-IN 
     SIZE 12.43 BY .88 NO-UNDO.

DEFINE VARIABLE d-dt-preco-base AS DATE FORMAT "99/99/9999" 
     LABEL "Data Preáo Base":R18 
     VIEW-AS FILL-IN 
     SIZE 12.86 BY .88 NO-UNDO.

DEFINE VARIABLE d-perc-descto AS DECIMAL FORMAT ">9.99999" INITIAL 0 
     LABEL "Perc Descto":R23 
     VIEW-AS FILL-IN 
     SIZE 10.57 BY .88 NO-UNDO.

DEFINE VARIABLE d-valor-frete AS DECIMAL FORMAT ">>>,>>>,>>9.9999" INITIAL 0 
     LABEL "Valor Frete":R14 
     VIEW-AS FILL-IN 
     SIZE 14.86 BY .88 NO-UNDO.

DEFINE VARIABLE d-valor-taxa AS DECIMAL FORMAT ">>9.9999" INITIAL 0 
     LABEL "Taxa Financ":R18 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .88 NO-UNDO.

DEFINE VARIABLE da-data-cotacao AS DATE FORMAT "99/99/9999" INITIAL 10/29/99 
     LABEL "Data Cotaá∆o":R15 
     VIEW-AS FILL-IN 
     SIZE 12.86 BY .88 NO-UNDO.

DEFINE VARIABLE de-cotacao AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-transporte AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 45.14 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-cond-pag AS INTEGER FORMAT "->,>>>,>>9" INITIAL 0 
     LABEL "Cond Pagto":R25 
     VIEW-AS FILL-IN 
     SIZE 4.86 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-transp AS INTEGER FORMAT ">>,>>9" INITIAL 0 
     LABEL "Transportador":R16 
     VIEW-AS FILL-IN 
     SIZE 10.86 BY .88 NO-UNDO.

DEFINE VARIABLE i-mo-codigo AS INTEGER FORMAT "->,>>>,>>9" INITIAL 0 
     LABEL "Moeda":R7 
     VIEW-AS FILL-IN 
     SIZE 3.72 BY .88 NO-UNDO.

DEFINE VARIABLE i-nr-dias-taxa AS INTEGER FORMAT ">>9" INITIAL 30 
     LABEL "Dias Taxa Financeira":R24 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE i-prazo-entreg AS INTEGER FORMAT ">,>>9" INITIAL 0 
     LABEL "Prazo Entrega":R16 
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88 NO-UNDO.

DEFINE VARIABLE i-validade AS INTEGER FORMAT ">>9" INITIAL 1 
     LABEL "Dias Validade":R20 
     VIEW-AS FILL-IN 
     SIZE 6.29 BY .88 NO-UNDO.

DEFINE VARIABLE i-codigo-icm AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Consumo", 1,
"Industrializaá∆o", 2
     SIZE 17.72 BY 1.5 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86.86 BY 1.5.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 19.86 BY 2.5.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86.86 BY 1.29.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 38.29 BY 2.5.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86.86 BY 7.54.

DEFINE RECTANGLE RECT-53
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 27 BY 2.5.
DEFINE VARIABLE l-codigo-ipi AS LOGICAL INITIAL no 
     LABEL "IPI Incluso":L14 
     VIEW-AS TOGGLE-BOX
     SIZE 15.14 BY .75 NO-UNDO.

DEFINE VARIABLE l-frete AS LOGICAL INITIAL no 
     LABEL "Frete Incluso":L16 
     VIEW-AS TOGGLE-BOX
     SIZE 14.86 BY .75 NO-UNDO.

DEFINE VARIABLE l-possui-reaj AS LOGICAL INITIAL no 
     LABEL "Reajuste":L10 
     VIEW-AS TOGGLE-BOX
     SIZE 13.14 BY .75 NO-UNDO.

DEFINE VARIABLE l-taxa-financ AS LOGICAL INITIAL yes 
     LABEL "Encargos Financeiros":L24 
     VIEW-AS TOGGLE-BOX
     SIZE 26.14 BY .75 NO-UNDO.

DEFINE VARIABLE tg-clicbusiness AS LOGICAL INITIAL no 
     LABEL "Vis°vel no clicbusiness" 
     VIEW-AS TOGGLE-BOX
     SIZE 24 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     i-mo-codigo AT ROW 1.33 COL 18.43 COLON-ALIGNED
     c-descricao AT ROW 1.33 COL 22.43 COLON-ALIGNED NO-LABEL
     de-cotacao AT ROW 1.33 COL 70.43 COLON-ALIGNED NO-LABEL
     d-valor-frete AT ROW 3.17 COL 18.43 COLON-ALIGNED
     da-data-cotacao AT ROW 3.17 COL 58.43 COLON-ALIGNED
     i-validade AT ROW 4.17 COL 18.43 COLON-ALIGNED
     i-cod-cond-pag AT ROW 4.17 COL 58.43 COLON-ALIGNED
     c-desc-pagto AT ROW 4.17 COL 63.57 COLON-ALIGNED HELP
          "Informe a descriá∆o da condicao de pagamento" NO-LABEL
     i-prazo-entreg AT ROW 5.17 COL 18.43 COLON-ALIGNED
     c-cod-comprado AT ROW 5.17 COL 58.43 COLON-ALIGNED
     d-aliquota-iss AT ROW 6.17 COL 6.43
     c-contato AT ROW 6.17 COL 58.43 COLON-ALIGNED
     d-perc-descto AT ROW 7.17 COL 18.43 COLON-ALIGNED
     d-dt-preco-base AT ROW 7.17 COL 58.43 COLON-ALIGNED
     i-cod-transp AT ROW 8.17 COL 18.43 COLON-ALIGNED HELP
          "Informe o transportador para a cotaá∆o"
     fi-transporte AT ROW 8.17 COL 29.86 COLON-ALIGNED NO-LABEL
     c-nome-fabric-medic AT ROW 9.21 COL 18.43 COLON-ALIGNED
     l-codigo-ipi AT ROW 11.21 COL 3.29
     d-cotar-ate AT ROW 11.42 COL 69.43 COLON-ALIGNED
     i-codigo-icm AT ROW 11.75 COL 41 NO-LABEL
     l-frete AT ROW 11.92 COL 3.29
     tg-clicbusiness AT ROW 12.5 COL 63.72
     l-possui-reaj AT ROW 12.63 COL 3.29
     d-valor-taxa AT ROW 13.83 COL 44.14 COLON-ALIGNED
     i-nr-dias-taxa AT ROW 13.83 COL 79.57 COLON-ALIGNED HELP
          "Permite informar o nr de dias da taxa financeira"
     l-taxa-financ AT ROW 13.96 COL 3.29
     c-cotacao AT ROW 1.38 COL 58.43 COLON-ALIGNED NO-LABEL
     c-icms AT ROW 10.75 COL 41.29 NO-LABEL
     c-clicbusiness AT ROW 10.75 COL 59.86 COLON-ALIGNED NO-LABEL
     RECT-1 AT ROW 1 COL 1
     RECT-14 AT ROW 11 COL 40.14
     RECT-2 AT ROW 13.67 COL 1
     RECT-3 AT ROW 11 COL 1
     RECT-4 AT ROW 2.96 COL 1
     RECT-53 AT ROW 11 COL 60.86
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
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
         HEIGHT             = 14.13
         WIDTH              = 87.43.
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

/* SETTINGS FOR FILL-IN c-cotacao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-pagto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-icms IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
ASSIGN 
       c-icms:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN d-aliquota-iss IN FRAME f-main
   ALIGN-L                                                              */
ASSIGN 
       d-aliquota-iss:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN d-dt-preco-base IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN da-data-cotacao IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN de-cotacao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-transporte IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       i-codigo-icm:HIDDEN IN FRAME f-main           = TRUE.

ASSIGN 
       RECT-14:HIDDEN IN FRAME f-main           = TRUE.

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

&Scoped-define SELF-NAME c-cod-comprado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-comprado V-table-Win
ON F5 OF c-cod-comprado IN FRAME f-main /* Comprador */
DO:

    {include/zoomvar.i &prog-zoom=inzoom/z01in055.w
                       &campo=c-cod-comprado
                       &campozoom=cod-comprado}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-comprado V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-comprado IN FRAME f-main /* Comprador */
DO:
  apply 'f5' to self.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-contato
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-contato V-table-Win
ON F5 OF c-contato IN FRAME f-main /* Contato */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom=adzoom/z01ad043.w
                     &campo=c-contato
                     &campozoom=nome}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-contato V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-contato IN FRAME f-main /* Contato */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME d-perc-descto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL d-perc-descto V-table-Win
ON LEAVE OF d-perc-descto IN FRAME f-main /* Perc Descto */
DO:

 if input frame {&frame-name} d-perc-descto > 100 then do:
  run utp/ut-msgs.p (input "show",
                     input 374,
                     input "").
  apply "entry" to d-perc-descto in frame {&frame-name}.
  return no-apply.
 end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cod-cond-pag
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-cond-pag V-table-Win
ON F5 OF i-cod-cond-pag IN FRAME f-main /* Cond Pagto */
DO:

    {include/zoomvar.i &prog-zoom=adzoom/z01ad039.w
                       &campo=i-cod-cond-pag
                       &campozoom=cod-cond-pag}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-cond-pag V-table-Win
ON LEAVE OF i-cod-cond-pag IN FRAME f-main /* Cond Pagto */
DO:
   
  if input frame {&frame-name} i-cod-cond-pag <> 0 then do:
       
    find cond-pagto where cond-pagto.cod-cond-pag = input frame {&frame-name} i-cod-cond-pag no-lock no-error.
    if not available cond-pagto then do:
{utp/ut-liter.i Condiá∆o_de_Pagamento *}
            run utp/ut-msgs.p (input "show",
                               input 47,
                               input  Return-value ).
            apply "entry" to i-cod-cond-pag in frame {&frame-name}.
            return no-apply.
    end.      
  END.

    find cond-pagto where cond-pagto.cod-cond-pag = input frame {&frame-name} i-cod-cond-pag no-lock no-error.
         assign c-desc-pagto:screen-value in frame {&frame-name} = if avail cond-pagto then cond-pagto.descricao else "":U.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-cond-pag V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-cod-cond-pag IN FRAME f-main /* Cond Pagto */
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cod-transp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-transp V-table-Win
ON F5 OF i-cod-transp IN FRAME f-main /* Transportador */
DO:

    assign l-implanta = yes.
    {include/zoomvar.i &prog-zoom=adzoom/z01ad268.w
                       &campo=i-cod-transp
                       &campozoom=cod-transp}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-transp V-table-Win
ON LEAVE OF i-cod-transp IN FRAME f-main /* Transportador */
DO:

    {include/leave.i &tabela=transporte
                     &atributo-ref=nome
                     &variavel-ref=fi-transporte
                     &where="transporte.cod-transp = input frame {&frame-name}
                             i-cod-transp"}       
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-transp V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-cod-transp IN FRAME f-main /* Transportador */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-mo-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-mo-codigo V-table-Win
ON F5 OF i-mo-codigo IN FRAME f-main /* Moeda */
DO:
      assign l-implanta = yes.
    {include/zoomvar.i &prog-zoom=adzoom/z01ad178.w
                       &campo=i-mo-codigo
                       &campozoom=mo-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-mo-codigo V-table-Win
ON LEAVE OF i-mo-codigo IN FRAME f-main /* Moeda */
DO:
    {include/leave.i &tabela=moeda 
                     &where="moeda.mo-codigo = input frame {&frame-name} i-mo-codigo"  
                     &atributo-ref=descricao
                     &variavel-ref=c-descricao}    

    if input frame {&frame-name} i-mo-codigo = 0 then do:
               de-cotacao = 1.
        display de-cotacao with frame {&frame-name}.
    end.
    find moeda where moeda.mo-codigo = input frame {&frame-name} i-mo-codigo no-lock no-error.
     if not available moeda then do:
{utp/ut-liter.i moeda *}
       run utp/ut-msgs.p (input "show",
                          input 47,
                          input  Return-value ).
       apply "entry" to i-mo-codigo in frame {&frame-name}.
       return no-apply.
     end.      
     run cdp/cd0812.p (input input frame {&frame-name} i-mo-codigo,
                       input 0,
                       input 1,
                       input da-data-cot,
                       output de-cotacao).
     assign de-cotacao.
     if de-cotacao = 0 then do:
             run utp/ut-msgs.p (input "show",
                                input 2348,
                                input string(da-data-cot)).
             /* run cdp/cd0103.p. */
             if de-cotacao = 0 then do:
                   apply "entry" to i-mo-codigo in frame {&frame-name}.
                   return no-apply.
             end.        
             assign de-cotacao.
     end.            

     find moeda where moeda.mo-codigo = input frame {&frame-name} i-mo-codigo no-lock no-error.
          assign c-descricao:screen-value in frame {&frame-name} = if avail moeda then moeda.descricao else "":U.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-mo-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-mo-codigo IN FRAME f-main /* Moeda */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-possui-reaj
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-possui-reaj V-table-Win
ON VALUE-CHANGED OF l-possui-reaj IN FRAME f-main /* Reajuste */
DO:
    if  input frame {&frame-name} l-possui-reaj = yes then do:
        enable d-dt-preco-base with frame {&frame-name}.  
        disp today @ d-dt-preco-base with frame {&frame-name}.
        assign de-perc-tot = 0.
        run ccp/cc9027.w (input-output i-codigo[1],
                          input-output da-data-indice[1],
                          input-output de-perc-reaj[1],
                          input-output i-codigo[2],
                          input-output da-data-indice[2],
                          input-output de-perc-reaj[2],
                          input-output i-codigo[3],
                          input-output da-data-indice[3],
                          input-output de-perc-reaj[3],
                          input-output i-codigo[4],
                          input-output da-data-indice[4],
                          input-output de-perc-reaj[4],
                          input-output i-codigo[5],
                          input-output da-data-indice[5],
                          input-output de-perc-reaj[5],
                          output de-perc-tot).        
    end.
    if input frame {&frame-name} l-possui-reaj = no then do:
        disable d-dt-preco-base with frame {&frame-name}.
        assign d-dt-preco-base:screen-value in frame {&frame-name} = ?.  
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

find first param-compra no-lock no-error.
find first param-global no-lock no-error.

  do  with frame {&frame-name}:
      if i-mo-codigo:load-mouse-pointer("image/lupa.cur") then .
      if i-cod-cond-pag:load-mouse-pointer("image/lupa.cur") then .
      if c-cod-comprado:load-mouse-pointer("image/lupa.cur") then .
      if i-cod-transp:load-mouse-pointer("image/lupa.cur") then .
      if c-contato:load-mouse-pointer("image/lupa.cur") then .
  end.

ASSIGN l-integra-ems-his = CAN-FIND (FIRST funcao 
                                     WHERE funcao.cd-funcao = "spp-integra-ems-his":U
                                       AND funcao.ativo = YES).    

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

    /* Ponha na pi-validate todas as validaá‰es */
    /* N∆o gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.


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
    if adm-new-record = yes then
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

  /* Code placed here will execute AFTER standard behavior.    */

 {utp/ut-field.i mgind cotacao-item data-cotacao 1}
 assign da-data-cotacao = today
        da-data-cotacao:label in frame {&frame-name} = trim(return-value).
 disp da-data-cotacao with frame {&frame-name}.

 {utp/ut-rdset.i i-codigo-icm MCC}

  {utp/ut-field.i mgind cotacao-item codigo-icm 1}
  assign c-icms:screen-value in frame {&FRAME-NAME} = return-value.

  {utp/ut-liter.i Moeda  MCC R}
  assign i-mo-codigo:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-liter.i Contato  MCC R}
  assign c-contato:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-field.i mgind cotacao-item cod-comprado 1}
  assign c-cod-comprado:label in frame {&FRAME-NAME} = trim(trim(return-value)).

  {utp/ut-liter.i Dias_Validade  MCC R}
  assign i-validade:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-liter.i Prazo_Entrega  MCC R}
  assign i-prazo-entreg:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-liter.i Data_Preáo_Base  MCC R}
  assign d-dt-preco-base:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-liter.i Valor_Frete  MCC R}
  assign d-valor-frete:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-field.i mgind cotacao-item perc-descto 1}
  assign d-perc-descto:label in frame {&FRAME-NAME} = trim(trim(return-value)).

  {utp/ut-liter.i Aliquota_ISS MCC R}
  assign d-aliquota-iss:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-field.i mgind cotacao-item cod-cond-pag 2}
  assign i-cod-cond-pag:label in frame {&FRAME-NAME} = trim(trim(return-value)).

  {utp/ut-liter.i Taxa_Finaceira MCC R}
  assign d-valor-taxa:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-liter.i Dias_Taxa_Finaceira MCC R}
  assign i-nr-dias-taxa:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-liter.i Encargos_Finaceiros MCC R}
  assign l-taxa-financ:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-liter.i IPI_Incluso MCC R}
  assign l-codigo-ipi:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-liter.i Frete_Incluso MCC R}
  assign l-frete:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-liter.i Reajuste MCC R}
  assign l-possui-reaj:label in frame {&FRAME-NAME} = trim(return-value).

  /*
  ** Verifica se m¢dulo de Importaá∆o est† implantado
  */
  if not avail param-global then
    find first param-global no-lock no-error.
  assign l-importacao = param-global.modulo-07.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza V-table-Win 
PROCEDURE pi-atualiza :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    find first param-compra no-lock no-error.              

find comprador where comprador.cod-comprado = input frame {&frame-name} c-cod-comprado no-lock no-error.
if  not available comprador then do:
    {utp/ut-table.i mgind comprador 1}.
    run utp/ut-msgs.p (input "show":U, input 2, input return-value).
    apply "entry" to c-cod-comprado in frame {&frame-name}.
    return 'ADM-ERROR':U.
end. 

if  input frame {&frame-name} i-cod-cond-pag <> 0 then do:
    find cond-pagto where cond-pagto.cod-cond-pag = input frame {&frame-name} i-cod-cond-pag 
        no-lock no-error.
    if  not avail cond-pagto then do:
        {utp/ut-field.i mgind cotacao-item cod-cond-pag 1}
        run utp/ut-msgs.p (input "show", input 47, input return-value).
        apply "entry" to i-cod-cond-pag in frame {&frame-name}.
        return 'ADM-ERROR':U.
    end.
end.

find transporte where transporte.cod-transp = input frame {&frame-name} i-cod-transp 
    no-lock no-error.
if  not avail transporte then do:
    {utp/ut-liter.i Tranportador}
    run utp/ut-msgs.p (input "show", input 47, input return-value).
    apply "entry" to i-cod-transp in frame {&frame-name}.
    return 'ADM-ERROR':U.
end.

if  input frame {&frame-name} i-validade = 0 then do:
    run utp/ut-msgs.p (input "show":U,
                       input 6179,
                       input i-validade:label).
    apply 'entry':U to i-validade in frame {&frame-name}.
    return 'adm-error':U.
end.       

IF l-integra-ems-his AND l-valida-fabric-medic THEN DO:

   IF INPUT FRAME {&frame-name} c-nome-fabric-medic = "" THEN DO:

        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Fabricante_deve_ser_diferente_de_branco" *}
        run utp/ut-msgs.p(input "show",
                          input 17006,
                          input RETURN-VALUE).
        return 'ADM-ERROR':U.
            
   END.

   FIND FIRST fab-medic NO-LOCK WHERE fab-medic.cdn-fabrican = int(ENTRY(1, c-nome-fabric-medic:screen-value in frame {&FRAME-NAME}, "-")) NO-ERROR.
   IF AVAIL fab-medic AND NOT fab-medic.log-ativo THEN DO:
       /* Inicio -- Projeto Internacional */
       {utp/ut-liter.i "Fabricante" *}
       run utp/ut-msgs.p(input "show":U,
                         input 469,
                         input RETURN-VALUE).
       return 'ADM-ERROR':U.
   END.
END.

for each tt-cotacao-item:

   ASSIGN c-opcao = "M":U.

   find cotacao-item 
        where cotacao-item.it-codigo    = tt-cotacao-item.it-codigo
          and cotacao-item.numero-ordem = tt-cotacao-item.numero-ordem
          and cotacao-item.cod-emitente = tt-cotacao-item.cod-emitente
          and cotacao-item.seq-cotac    = tt-cotacao-item.seq-cotac
          exclusive-lock no-error.
   if  not avail cotacao-item then do:
       create cotacao-item.
       assign cotacao-item.it-codigo    = tt-cotacao-item.it-codigo
              cotacao-item.numero-ordem = tt-cotacao-item.numero-ordem
              cotacao-item.cod-emitente = tt-cotacao-item.cod-emitente
              cotacao-item.seq-cotac    = tt-cotacao-item.seq-cotac.

       ASSIGN c-opcao = "I":U.
   end. 
   if  avail cotacao-item then do: 

        ASSIGN de-moeda-antiga   = cotacao-item.mo-codigo
               de-preco-unit-ant = cotacao-item.preco-fornec.

        /* 
        ** Integraá∆o M¢dulo de Importaá∆o
        */
        assign l-emitente-importacao = no.
        if not avail emitente then 
            find FIRST emitente 
                 where emitente.cod-emitente = tt-cotacao-item.cod-emitente no-lock no-error.                  
        if avail emitente and
                (emitente.natureza = 3 or emitente.natureza = 4) THEN
            assign l-emitente-importacao = YES.

        IF  CONNECTED ("mgcex") 
                  AND l-importacao        
                  AND l-emitente-importacao
                  AND NOT adm-new-record 
                  AND ( tt-cotacao-item.preco-fornec <> de-preco-unit-ant
                   OR input frame {&frame-name} i-mo-codigo  <> de-moeda-antiga) THEN DO:
            
            IF cotacao-item.cot-aprovada THEN
                run utp/ut-msgs.p (input "show":U, input 30079, input "").

            RUN imp/im9052.p (INPUT "cotacao-item":U,
                              INPUT ROWID(cotacao-item)).
        END.

        assign cotacao-item.data-cotacao  = input frame {&frame-name} da-data-cotacao
               cotacao-item.mo-codigo     = input frame {&frame-name} i-mo-codigo
               cotacao-item.codigo-ipi    = input frame {&frame-name} l-codigo-ipi
               cotacao-item.dias-validade = input frame {&frame-name} i-validade
               cotacao-item.codigo-icm    = input frame {&frame-name} i-codigo-icm
               cotacao-item.perc-descto   = input frame {&frame-name} d-perc-descto
               cotacao-item.aliquota-iss  = input frame {&frame-name} d-aliquota-iss
               cotacao-item.possui-reaj   = input frame {&frame-name} l-possui-reaj
               cotacao-item.frete         = input frame {&frame-name} l-frete
               cotacao-item.cod-cond-pag  = input frame {&frame-name} i-cod-cond-pag
               cotacao-item.valor-frete   = input frame {&frame-name} d-valor-frete
               cotacao-item.prazo-entreg  = input frame {&frame-name} i-prazo-entreg
               cotacao-item.contato       = input frame {&frame-name} c-contato
               cotacao-item.valor-taxa    = input frame {&frame-name} d-valor-taxa
               cotacao-item.nr-dias-taxa  = input frame {&frame-name} i-nr-dias-taxa
               cotacao-item.data-atualiz  = today
               cotacao-item.hora-atualiz  = string(time,"hh:mm:ss")
               cotacao-item.un            = tt-cotacao-item.un
               cotacao-item.preco-fornec  = tt-cotacao-item.preco-fornec
               cotacao-item.valor-descto  = ((cotacao-item.perc-descto * cotacao-item.preco-fornec) / 100)
               cotacao-item.aliquota-ipi  = tt-cotacao-item.aliquota-ipi
               cotacao-item.aliquota-icm  = tt-cotacao-item.aliquota-icm
               cotacao-item.pre-unit-for  = tt-cotacao-item.pre-unit-for
               cotacao-item.cod-comprado  = input frame {&frame-name} c-cod-comprado
               cotacao-item.cod-transp    = input frame {&frame-name} i-cod-transp. 

        IF l-integra-ems-his THEN DO:
            &IF "{&bf_mat_versao_ems}" >= "2.09" &THEN
                ASSIGN cotacao-item.cdn-fab-medic = int(ENTRY(1, c-nome-fabric-medic:screen-value in frame {&FRAME-NAME}, "-")).
            &ELSE
                OVERLAY(cotacao-item.char-1,127,9) = ENTRY(1, c-nome-fabric-medic:screen-value in frame {&FRAME-NAME}, "-").
            &ENDIF
        END.

        if  l-taxa-financ:sensitive in frame {&frame-name} then 
            assign cotacao-item.taxa-financ   = input frame {&frame-name} l-taxa-financ.
        else 
            assign cotacao-item.taxa-financ   = no.                

        /* Aprovaá∆o Eletrìnica */
        if param-compra.log-1 THEN DO: 
            IF cotacao-item.numero-ordem <> 0 and cotacao-item.cot-aprovada = YES then 
                run cdp/cdapi171.p (7,2,rowid(cotacao-item) ).
            ELSE IF cotacao-item.numero-ordem <> 0 then 
                run cdp/cdapi171.p (7,3,rowid(cotacao-item) ). 

            IF RETURN-VALUE <> "OK":U THEN 
                RETURN "ADM-ERROR":U.
        END.

        find first ordem-compra where ordem-compra.numero-ordem = cotacao-item.numero-ordem exclusive-lock no-error.
           assign ordem-compra.situacao             = 5
                  overlay(ordem-compra.char-2,80,1) = "".
        for each prazo-compra where prazo-compra.numero-ordem = cotacao-item.numero-ordem exclusive-lock:
           assign prazo-compra.situacao = 5.
        end.

        find item-fornec 
             where item-fornec.cod-emitente = cotacao-item.cod-emitente
             and   item-fornec.it-codigo    = cotacao-item.it-codigo
             no-lock no-error.
        if avail item-fornec then do:
           assign de-indice = item-fornec.fator-conver / if item-fornec.num-casa-dec = 0 then 1
                                                         else exp(10,item-fornec.num-casa-dec).
        end.
        else do:
            find tab-conv-un 
                 where tab-conv-un.un           = prazo-compra.un
                 and   tab-conv-un.unid-med-for = cotacao-item.un
                 no-lock no-error.
            if avail tab-conv-un then do:
               assign de-indice = tab-conv-un.fator-conver /        
                                  if tab-conv-un.num-casa-dec = 0 then 1
                                  else exp(10,tab-conv-un.num-casa-dec).

            end.
            ELSE
                assign de-indice = 1.

        end.                 
        if de-indice = 0 then assign de-indice = 1.

        {cdp/cd9300.i "cotacao-item"}

        assign cotacao-item.preco-unit = cotacao-item.pre-unit-for * de-indice.

        if input frame {&frame-name} l-possui-reaj then do:

             find cota-item-reaj where cota-item-reaj.it-codigo = cotacao-item.it-codigo and
                                       cota-item-reaj.numero-ordem = cotacao-item.numero-ordem and
                                       cota-item-reaj.cod-emitente = cotacao-item.cod-emitente exclusive-lock no-error.
             if  not available cota-item-reaj then
                 create cota-item-reaj.          

             assign cota-item-reaj.it-codigo     = cotacao-item.it-codigo
                    cota-item-reaj.numero-ordem  = cotacao-item.numero-ordem
                    cota-item-reaj.cod-emitente  = cotacao-item.cod-emitente
                    cota-item-reaj.data-cotacao  = cotacao-item.data-cotacao
                    cota-item-reaj.dt-preco-base = input frame {&frame-name} d-dt-preco-base.

             assign cota-item-reaj.mo-codigo[1]   = i-codigo[1]
                    cota-item-reaj.data-indice[1] = da-data-indice[1]
                    cota-item-reaj.perc-reaj[1]   = de-perc-reaj[1].

             assign cota-item-reaj.mo-codigo[2]   = i-codigo[2]
                    cota-item-reaj.data-indice[2] = da-data-indice[2]
                    cota-item-reaj.perc-reaj[2]   = de-perc-reaj[2].

             assign cota-item-reaj.mo-codigo[3]   = i-codigo[3]
                    cota-item-reaj.data-indice[3] = da-data-indice[3]
                    cota-item-reaj.perc-reaj[3]   = de-perc-reaj[3].

             assign cota-item-reaj.mo-codigo[4]   = i-codigo[4]
                    cota-item-reaj.data-indice[4] = da-data-indice[4]
                    cota-item-reaj.perc-reaj[4]   = de-perc-reaj[4].

             assign cota-item-reaj.mo-codigo[5]   = i-codigo[5]
                    cota-item-reaj.data-indice[5] = da-data-indice[5]
                    cota-item-reaj.perc-reaj[5]   = de-perc-reaj[5].

        end.    

        /* In°cio Integraá∆o com Investimentos */
        IF NOT AVAIL param-global THEN
            FIND FIRST param-global NO-LOCK NO-ERROR.
    
        IF  AVAIL cotacao-item 
        AND param-global.modulo-in 
        AND ordem-compra.num-ord-inv <> 0 THEN DO:
            IF  c-opcao = "I":U THEN
                RUN inp/in2103.p (INPUT ROWID(cotacao-item), INPUT "I":U).
            
            IF  c-opcao = "M":U THEN
                RUN inp/in2103.p (INPUT ROWID(cotacao-item), INPUT "M":U).
        END.
        /* Fim Integraá∆o com Investimentos */

            IF NOT AVAIL param-compra THEN
                FIND FIRST param-compra NO-LOCK NO-ERROR.
            IF AVAIL param-compra THEN DO: /*Verifica se a integraá∆o com o clicbusiness est† ativa e o termo de aceite est† aceito respectivamente*/
                IF SUBSTRING(param-compra.char-2,104,1) <> "N":U AND SUBSTRING(param-compra.char-2,105,1) = "S":U THEN DO:
                    IF input frame {&frame-name} d-cotar-ate < TODAY OR input frame {&frame-name} d-cotar-ate = ? THEN DO:
                          {utp/ut-liter.i "Data_Cotar_atÇ" * L}
                          RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 31189,
                                             INPUT TRIM(RETURN-VALUE) ).
                         RETURN 'ADM-ERROR':U.
                    END.

                    
                    ASSIGN OVERLAY(ordem-compra.char-1,194) = IF tg-clicbusiness:CHECKED IN FRAME {&FRAME-NAME} THEN "S":U ELSE "N":U
                            ordem-compra.dat-fim-leilao-rfq = input frame {&frame-name} d-cotar-ate
                            iProcesso = ordem-compra.nr-processo.
                    /*Quando alterado os campos replicar as alteraá‰es para todos as Ordens do pacote*/
                    FOR EACH ordem-compra EXCLUSIVE-LOCK
                          WHERE ordem-compra.nr-processo = iProcesso:
                        ASSIGN OVERLAY(ordem-compra.char-1,194) = IF tg-clicbusiness:CHECKED IN FRAME {&FRAME-NAME} THEN "S":U ELSE "N":U
                                       ordem-compra.dat-fim-leilao-rfq = input frame {&frame-name} d-cotar-ate.
                    END.

                    CREATE tt-fornecedores-participantes.
                    ASSIGN tt-fornecedores-participantes.cod-fornec = tt-cotacao-item.cod-emitente.
                    EMPTY TEMP-TABLE tt-fornecedores-convidados.
                    
                    RUN ccp/ccapi346.p (INPUT tt-cotacao-item.numero-ordem,
                                        INPUT "", /* nr-processo*/
                                        INPUT TABLE tt-fornecedores-participantes,
                                        INPUT TABLE tt-fornecedores-convidados, /*enviar tt vazia */
                                        OUTPUT TABLE tt-erro-clicbusiness).
                END.
            END.
        /* Chamada UPC -  */ 
        IF  c-nom-prog-upc-mg97 <> "" THEN DO:    
            run value(c-nom-prog-upc-mg97) (input "After-Atualiza":U, ~            
                                            input "pi-atualiza":U, ~           
                                            input this-procedure, ~              
                                            input frame {&FRAME-NAME}:handle, ~  
                                            input STRING(BUFFER cotacao-item:HANDLE), ~           
                                            input ROWID(cotacao-item)) NO-ERROR.                          
        END. 
        /* fim chamada upc */
    end.

    /* Recalcula despesas da cotacao */
    run pi-recalcula-despesa(rowid(cotacao-item)).    

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recalcula-despesa V-table-Win 
PROCEDURE pi-recalcula-despesa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param row-cotacao-item as rowid no-undo.
    def var de-valor-desp like desp-cotacao-item.val-despesa no-undo.
    def var h-boin706 as handle no-undo.


     if  not valid-handle(h-boin706) then
         run inbo/boin706.p persistent set h-boin706.

    /* Recalcula o valor de cada despesa da cotaá∆o quando for alterado
       o preáo unit†rio da mesma */
    for first cotacao-item fields(preco-unit numero-ordem preco-unit) where
        rowid(cotacao-item) = row-cotacao-item no-lock: end.

    if  avail cotacao-item then do:
        for first ordem-compra fields(qt-solic)
            where ordem-compra.numero-ordem = cotacao-item.numero-ordem no-lock: end.
        if  not avail ordem-compra then 
            return "NOK":U.
        for each  desp-cotacao-item
            where desp-cotacao-item.numero-ordem  = cotacao-item.numero-ordem
              and desp-cotacao-item.cod-emitente  = cotacao-item.cod-emitente
              and desp-cotacao-item.it-codigo     = cotacao-item.it-codigo
              and desp-cotacao-item.seq-cotac     = cotacao-item.seq-cotac no-lock:

            find despesa where 
                 despesa.cod-despesa = desp-cotacao-item.cod-despesa no-lock no-error.
            if  not avail despesa then next.

            if  valid-handle(h-boin706)
            and despesa.cdn-tp-calculo = 1 /* Percentual */ then
                run recalculaDespesa in h-boin706(input rowid(cotacao-item),
                                                  input rowid(desp-cotacao-item),
                                                  output de-valor-desp).

        end.
    end.

    delete procedure h-boin706 no-error.
    assign h-boin706 = ?.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recebe-param V-table-Win 
PROCEDURE pi-recebe-param :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input  parameter p-i-nr-proces as integer no-undo.
def input  parameter table         for tt-cotacao-item.

DEF VAR c-it-codigo LIKE cotacao-item.it-codigo NO-UNDO.

find proc-compra where proc-compra.nr-processo = p-i-nr-proces
    no-lock no-error.
if  avail proc-compra then 
    disp proc-compra.cod-comprado @ c-cod-comprado with frame {&frame-name}.

if  not avail param-compra then
    find first param-compra no-lock no-error.

find first tt-cotacao-item no-lock no-error.
if  avail tt-cotacao-item then do:
    assign i-nr-proces = p-i-nr-proces
           i-cod-emite = tt-cotacao-item.cod-emitente.

    /***Moeda Padr∆o do Fornecedor***/    
    &IF DEFINED(bf_mat_custeio_item) &THEN

        find first dist-emitente where
                   dist-emitente.cod-emitente = i-cod-emite no-lock no-error.

    &ENDIF           

end.

 if  avail param-compra then DO: 
 assign i-codigo-icm:sensitive   in frame {&frame-name} = param-compra.utiliza-icm
        d-aliquota-iss:sensitive in frame {&frame-name} = param-compra.utiliza-iss
        d-valor-taxa:sensitive   in frame {&frame-name} = param-compra.utiliza-taxa
        i-nr-dias-taxa:sensitive in frame {&frame-name} = param-compra.utiliza-taxa
        l-taxa-financ:sensitive  in frame {&frame-name} = param-compra.utiliza-taxa.
    
     
     /* validaá∆o integraá∆o com o Clicbusiness */
     IF SUBSTRING(param-compra.char-2,104,1) = "N":U THEN DO:
        ASSIGN tg-clicbusiness:HIDDEN IN FRAME {&FRAME-NAME} = YES
               d-cotar-ate:HIDDEN IN FRAME {&FRAME-NAME} = YES
               rect-53:HIDDEN IN FRAME {&FRAME-NAME} = YES
               c-clicbusiness:HIDDEN IN FRAME {&FRAME-NAME} = YES.
     END.     
     ELSE DO:
         IF SUBSTRING(param-compra.char-2,105,1) <> "S":U THEN DO:
             ASSIGN tg-clicbusiness:SENSITIVE IN FRAME {&FRAME-NAME} = FALSE
                    d-cotar-ate:SENSITIVE IN FRAME {&FRAME-NAME} = FALSE
                    c-clicbusiness:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Clicbusiness":U.
         END.
         ELSE DO:
             ASSIGN tg-clicbusiness:CHECKED IN FRAME {&FRAME-NAME} = IF SUBSTRING(param-compra.char-2,106,1) = "N":U THEN FALSE ELSE TRUE
                c-clicbusiness:HIDDEN IN FRAME {&FRAME-NAME} = NO
                c-clicbusiness:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Clicbusiness":U.
             FIND FIRST ordem-compra WHERE 
                ordem-compra.numero-ordem = tt-cotacao-item.numero-ordem NO-LOCK  NO-ERROR.
             IF AVAIL ordem-compra THEN DO:
                 IF ordem-compra.dat-fim-leilao-rfq <> ? AND ordem-compra.dat-fim-leilao-rfq >= TODAY THEN
                     ASSIGN d-cotar-ate:SCREEN-VALUE IN FRAME {&FRAME-NAME} = string(ordem-compra.dat-fim-leilao-rfq)
                            d-cotar-ate = ordem-compra.dat-fim-leilao-rfq.
                 ELSE
                     ASSIGN d-cotar-ate:SCREEN-VALUE IN FRAME {&FRAME-NAME} = string(TODAY)
                            d-cotar-ate = TODAY.
             END.
         END.         
     END.
     /* fim - validaá∆o integraá∆o com o Clicbusiness */
 END.


if available param-compra then
    assign i-preco-bruto = param-compra.ipi-sobre-preco.
else
    assign i-preco-bruto = 2.

if  avail tt-cotacao-item then do:
    find first cotacao-item where cotacao-item.numero-ordem = tt-cotacao-item.numero-ordem and 
                                  cotacao-item.cod-emitente = tt-cotacao-item.cod-emitente and  
                                  cotacao-item.it-codigo    = tt-cotacao-item.it-codigo and
                                  cotacao-item.seq-cotac    = tt-cotacao-item.seq-cotac
                                  no-lock no-error.
    /** Localiza cotacao pendente **/
    if  not avail cotacao-item then
        find first cotacao-item 
             where cotacao-item.numero-ordem = tt-cotacao-item.numero-ordem 
             and   cotacao-item.cod-emitente = tt-cotacao-item.cod-emitente 
             and   cotacao-item.it-codigo    = tt-cotacao-item.it-codigo 
             no-lock no-error.
    find ordem-compra where ordem-compra.numero-ordem = tt-cotacao-item.numero-ordem no-lock no-error.
    if  avail ordem-compra then
        find first estabelec where estabelec.cod-estabel = ordem-compra.cod-estabel no-lock no-error.                                  
end.


assign l-codigo-ipi:checked        in frame {&frame-name} = cotacao-item.codigo-ipi when avail cotacao-item
       i-codigo-icm:screen-value   in frame {&frame-name} = string(cotacao-item.codigo-icm) when avail cotacao-item
       d-aliquota-iss:screen-value in frame {&frame-name} = string(param-compra.aliq-iss-pad)
       l-possui-reaj:checked       in frame {&frame-name} = no
       d-dt-preco-base:sensitive   in frame {&frame-name} = no
       l-frete:checked             in frame {&frame-name} = cotacao-item.frete when avail cotacao-item
       l-taxa-financ:checked       in frame {&frame-name} = cotacao-item.taxa-financ when avail cotacao-item.


if  avail cotacao-item THEN DO:
    find ordem-compra where ordem-compra.numero-ordem = cotacao-item.numero-ordem no-lock no-error.    
    
    IF AVAIL ordem-compra THEN
        display cotacao-item.dias-validade @ i-validade
                cotacao-item.perc-descto   @ d-perc-descto
                cotacao-item.cod-cond-pag  @ i-cod-cond-pag
                cotacao-item.valor-frete   @ d-valor-frete
                cotacao-item.prazo-entreg  @ i-prazo-entreg
                cotacao-item.valor-taxa    @ d-valor-taxa
                cotacao-item.nr-dias-taxa  @ i-nr-dias-taxa
                cotacao-item.cod-transp    @ i-cod-transp
                ordem-compra.cod-comprado  @ c-cod-comprado                
                cotacao-item.contato       @ c-contato
                today @ da-data-cotacao
                with frame {&frame-name}.
    ELSE
        display cotacao-item.dias-validade @ i-validade
                cotacao-item.perc-descto   @ d-perc-descto
                cotacao-item.cod-cond-pag  @ i-cod-cond-pag
                cotacao-item.valor-frete   @ d-valor-frete
                cotacao-item.prazo-entreg  @ i-prazo-entreg
                cotacao-item.valor-taxa    @ d-valor-taxa
                cotacao-item.nr-dias-taxa  @ i-nr-dias-taxa
                cotacao-item.cod-transp    @ i-cod-transp
                cotacao-item.cod-comprado  @ c-cod-comprado
                cotacao-item.contato       @ c-contato
                today @ da-data-cotacao
        with frame {&frame-name}.
END.
else
    display 1 @ i-validade
            0 @ d-perc-descto
            0 @ i-cod-cond-pag
            0 @ d-valor-frete
            0 @ i-prazo-entreg
            0 @ d-valor-taxa
            0 @ i-nr-dias-taxa 
            0 @ i-cod-transp
            with frame {&frame-name}.        

ASSIGN c-it-codigo = IF AVAIL cotacao-item THEN cotacao-item.it-codigo ELSE ?.

ASSIGN c-nome-fabric-medic:HIDDEN IN FRAME {&FRAME-NAME} = YES.
  
IF l-integra-ems-his THEN DO:

    ASSIGN c-nome-fabric-medic:HIDDEN IN FRAME {&FRAME-NAME} = NO
           c-lista-fab = ",".  

    FOR EACH fab-medic NO-LOCK:

        FIND FIRST fab-medic-item NO-LOCK
             WHERE fab-medic-item.cod-item = c-it-codigo
               AND fab-medic-item.cdn-fabrican = fab-medic.cdn-fabrican
               AND fab-medic-item.log-ativo = YES NO-ERROR.
        IF AVAIL fab-medic-item THEN
            ASSIGN c-lista-fab = c-lista-fab + "," + string(fab-medic.cdn-fabrican) + " - " + fab-medic.nom-fabrican + "," + string(fab-medic.cdn-fabrican).
    END.

    assign c-nome-fabric-medic:LIST-ITEM-PAIRS in frame {&FRAME-NAME} = c-lista-fab.
           l-valida-fabric-medic = NO. 

    if c-lista-fab <> "," then
         assign c-nome-fabric-medic:screen-value in frame {&FRAME-NAME} = entry(1, c-nome-fabric-medic:LIST-ITEM-PAIRS in frame {&FRAME-NAME})
         l-valida-fabric-medic = YES.
        
END.

IF input frame {&frame-name} i-cod-transp = 0 THEN
    /*Transportador Padr∆o do Fornecedor*/
    FOR FIRST emitente
        WHERE emitente.cod-emitente = i-cod-emite NO-LOCK:
        ASSIGN i-cod-transp = emitente.cod-transp.
        DISP i-cod-transp WITH FRAME {&FRAME-NAME}.
    END.

 APPLY "leave":U TO i-cod-transp.
 APPLY "leave":U TO i-cod-cond-pag.

/***Moeda Padr∆o do Fornecedor***/
ASSIGN i-mo-codigo = 0.
&IF DEFINED(bf_mat_custeio_item) &THEN
    IF AVAIL cotacao-item THEN DO:
       IF cotacao-item.data-cotacao = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 11/11/1111 &ENDIF THEN DO:
          ASSIGN i-mo-codigo = IF AVAIL dist-emitente THEN dist-emitente.mo-fatur ELSE 0.
       END.
       ELSE 
          ASSIGN i-mo-codigo = cotacao-item.mo-codigo.
       END.
    ELSE 
       ASSIGN i-mo-codigo = IF AVAIL dist-emitente THEN dist-emitente.mo-fatur ELSE 0.
&ENDIF    

disp i-mo-codigo with frame {&frame-name}.
apply "leave" to i-mo-codigo in frame {&frame-name}.

if  avail cotacao-item and
    cotacao-item.possui-reaj = yes then do:
    find first cota-item-reaj where cota-item-reaj.cod-emitente = cotacao-item.cod-emitente and
                                    cota-item-reaj.numero-ordem = cotacao-item.numero-ordem no-lock no-error.
    display cota-item-reaj.dt-preco-base @ d-dt-preco-base with frame {&frame-name}.
    do i-cont = 1 to 5:
        assign i-codigo[i-cont]       = cota-item-reaj.mo-codigo[i-cont]
               da-data-indice[i-cont] = cota-item-reaj.data-indice[i-cont]
               de-perc-reaj[i-cont]   = cota-item-reaj.perc-reaj[i-cont].
    end.
end.                                                

if  param-compra.utiliza-icm <> yes then
    disable i-codigo-icm with frame {&frame-name}.

if  param-compra.utiliza-taxa <> yes then 
    disable d-valor-taxa with frame {&frame-name}.

{utp/ut-liter.i Cot._Moeda_: * R}
assign c-cotacao = return-value.
display c-cotacao with frame {&frame-name}.

/* Code placed here will execute AFTER standard behavior.    */

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

/*/*    Segue um exemplo de validaá∆o de programa */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartViewer, and there are no
     tables specified in any contained Browse, Query, or Frame. */

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

