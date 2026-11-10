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
{include/i-prgvrs.i V06IN372 2.00.00.026}  /*** "010026" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v06in372 MUT}
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

{cdp/cdcfgmat.i}

/* global variable definitions */
def new global shared var v-row-parent as rowid no-undo.                                
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def new global shared var i-cod-emitente as integer no-undo.

def var c-erro1 as char no-undo.
def var c-erro2 as char no-undo.

def var l-modulo-ge as logical no-undo.
def var de-pre-ncz as decimal no-undo.
def var de-indice as decimal no-undo init 1.
def var de-quant-receb as decimal no-undo.
def var de-maximo-rec as decimal no-undo.
def var de-qtd-maxima-rec as decimal no-undo.
def var de-saldo-forn as decimal no-undo.
def var de-qtd-tot as decimal no-undo.
def var de-preco-conv as decimal no-undo.
def var de-val-tot as decimal no-undo.

def buffer b-prazo for prazo-compra.
DEF BUFFER b-item  FOR ITEM.

def new shared var r-gerencial as rowid.
def new shared var c-gerencial as character.

def var c-verifica-cgc      as char format "x(20)"    no-undo.
def var i-dig-ver           as integer                no-undo.
def var l-alterado          as logical init no        no-undo.

def buffer b-emitente for emitente.

{cdp/cd9900.i1}

def var i-natureza like emitente.natureza no-undo.
def var l-f5 as logical init no no-undo.

{cep/ce1234.i}  /* Valida‡Æo Decimais */

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
&Scoped-define EXTERNAL-TABLES recebimento
&Scoped-define FIRST-EXTERNAL-TABLE recebimento


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR recebimento.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS da-data-movto da-data-nota c-serie-nota ~
c-numero-nota c-recebedor i-num-pedido i-numero-ordem i-parcela RECT-6 ~
RECT-7 rt-key rt-key-2 
&Scoped-Define DISPLAYED-OBJECTS cod-emitente c-nome-abrev c-aux-cgc ~
da-data-movto da-data-nota c-serie-nota c-numero-nota c-recebedor ~
i-num-pedido i-numero-ordem i-parcela c-it-codigo c-un de-qtd-sal-forn ~
de-aliquota-ipi de-pre-unit-for de-aliquota-icm i-mo-codigo c-nome-moeda ~
de-aliquota-iss de-preco-unit de-perc-descto de-pre-unit-for-novo ~
de-qtd-rec-forn c-un-nova de-valor-total 

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
DEFINE VARIABLE c-aux-cgc AS CHARACTER FORMAT "x(19)" 
     LABEL "CGC/CPF":R9 
     VIEW-AS FILL-IN 
     SIZE 20.43 BY .88.

DEFINE VARIABLE c-it-codigo AS CHARACTER FORMAT "X(16)" 
     LABEL "Item":R5 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88.

DEFINE VARIABLE c-nome-abrev AS CHARACTER FORMAT "X(12)" 
     VIEW-AS FILL-IN 
     SIZE 27 BY .88.

DEFINE VARIABLE c-nome-moeda AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 31 BY .88 NO-UNDO.

DEFINE VARIABLE c-numero-nota AS CHARACTER FORMAT "x(16)" 
     LABEL "Numero Documento":R20 
     VIEW-AS FILL-IN 
     SIZE 17.43 BY .88.

DEFINE VARIABLE c-recebedor AS CHARACTER FORMAT "X(12)" 
     LABEL "Responsavel":R14 
     VIEW-AS FILL-IN 
     SIZE 16.43 BY .88.

DEFINE VARIABLE c-serie-nota AS CHARACTER FORMAT "X(05)" 
     LABEL "Serie Documento":R18 
     VIEW-AS FILL-IN 
     SIZE 9.43 BY .88.

DEFINE VARIABLE c-un AS CHARACTER FORMAT "xx" 
     LABEL "Unidade de Medida":R21 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88.

DEFINE VARIABLE c-un-nova AS CHARACTER FORMAT "xx" 
     LABEL "Unidade de Medida":R21 
     VIEW-AS FILL-IN 
     SIZE 5.43 BY .88.

DEFINE VARIABLE cod-emitente AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "C¢digo":R8 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88.

DEFINE VARIABLE da-data-movto AS DATE FORMAT "99/99/9999" 
     LABEL "Data do Movimento":R21 
     VIEW-AS FILL-IN 
     SIZE 12.86 BY .88.

DEFINE VARIABLE da-data-nota AS DATE FORMAT "99/99/9999" 
     LABEL "Data do Documento":R21 
     VIEW-AS FILL-IN 
     SIZE 12.86 BY .88.

DEFINE VARIABLE de-aliquota-icm AS DECIMAL FORMAT "->>,>>9.99" INITIAL 17 
     LABEL "Aliquota ICMS":R16 
     VIEW-AS FILL-IN 
     SIZE 8.29 BY .88.

DEFINE VARIABLE de-aliquota-ipi AS DECIMAL FORMAT "->>,>>9.99" INITIAL 10 
     LABEL "Aliquota IPI":R15 
     VIEW-AS FILL-IN 
     SIZE 8.29 BY .88.

DEFINE VARIABLE de-aliquota-iss AS DECIMAL FORMAT "->>,>>9.99" INITIAL 6 
     LABEL "Aliquota ISS":R15 
     VIEW-AS FILL-IN 
     SIZE 8.29 BY .88.

DEFINE VARIABLE de-perc-descto AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "Percentual Desconto":R23 
     VIEW-AS FILL-IN 
     SIZE 10.57 BY .88.

DEFINE VARIABLE de-pre-unit-for AS DECIMAL FORMAT ">>>,>>>,>>9.99999" INITIAL 0 
     LABEL "Preco Unit Fornec":R21 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88.

DEFINE VARIABLE de-pre-unit-for-novo AS DECIMAL FORMAT ">>>,>>>,>>9.99999" INITIAL 0 
     LABEL "Preco Unit Fornec":R21 
     VIEW-AS FILL-IN 
     SIZE 19.72 BY .88.

DEFINE VARIABLE de-preco-unit AS DECIMAL FORMAT ">>>,>>>,>>9.99999" INITIAL 0 
     LABEL "Preco Unitario":R17 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88.

DEFINE VARIABLE de-qtd-rec-forn AS DECIMAL FORMAT ">>>>,>>9.9999" INITIAL 0 
     LABEL "Qt Recebida Fornec":R22 
     VIEW-AS FILL-IN 
     SIZE 16.29 BY .88.

DEFINE VARIABLE de-qtd-sal-forn AS DECIMAL FORMAT ">>>>,>>9.9999" INITIAL 0 
     LABEL "Qtd Saldo Fornec":R20 
     VIEW-AS FILL-IN 
     SIZE 16.29 BY .88.

DEFINE VARIABLE de-valor-total AS DECIMAL FORMAT ">>>,>>>,>>9.9999" INITIAL 0 
     LABEL "Valor Total":R14 
     VIEW-AS FILL-IN 
     SIZE 19.72 BY .88.

DEFINE VARIABLE i-mo-codigo AS INTEGER FORMAT "->,>>>,>>9" INITIAL 0 
     LABEL "Moeda":R7 
     VIEW-AS FILL-IN 
     SIZE 3.72 BY .88.

DEFINE VARIABLE i-num-pedido AS INTEGER FORMAT ">>>>>,>>9" INITIAL 0 
     LABEL "Pedido":R8 
     VIEW-AS FILL-IN 
     SIZE 9.43 BY .88.

DEFINE VARIABLE i-numero-ordem AS INTEGER FORMAT "zzzzz9,99" INITIAL 0 
     LABEL "Ordem Compra"
     VIEW-AS FILL-IN 
     SIZE 13 BY .88.

DEFINE VARIABLE i-parcela AS INTEGER FORMAT "->,>>>,>>9" INITIAL 1 
     LABEL "Parcela":R9 
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 4.58.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 2.5.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 5.5.

DEFINE RECTANGLE rt-key-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 1.33.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     cod-emitente AT ROW 1.25 COL 10 COLON-ALIGNED
     c-nome-abrev AT ROW 1.25 COL 23 COLON-ALIGNED NO-LABEL
     c-aux-cgc AT ROW 1.25 COL 65 COLON-ALIGNED HELP
          "CGC ou CIC do cliente/fornecedor"
     da-data-movto AT ROW 2.88 COL 22 COLON-ALIGNED
     da-data-nota AT ROW 3.88 COL 22 COLON-ALIGNED
     c-serie-nota AT ROW 4.88 COL 22 COLON-ALIGNED
     c-numero-nota AT ROW 5.88 COL 22 COLON-ALIGNED
     c-recebedor AT ROW 6.88 COL 22 COLON-ALIGNED
     i-num-pedido AT ROW 2.88 COL 65 COLON-ALIGNED
     i-numero-ordem AT ROW 3.88 COL 65 COLON-ALIGNED
     i-parcela AT ROW 4.88 COL 65 COLON-ALIGNED
     c-it-codigo AT ROW 5.88 COL 65 COLON-ALIGNED
     c-un AT ROW 6.88 COL 65 COLON-ALIGNED
     de-qtd-sal-forn AT ROW 8.54 COL 22 COLON-ALIGNED
     de-aliquota-ipi AT ROW 9.54 COL 75 COLON-ALIGNED
     de-pre-unit-for AT ROW 9.54 COL 22 COLON-ALIGNED
     de-aliquota-icm AT ROW 10.54 COL 75 COLON-ALIGNED
     i-mo-codigo AT ROW 10.54 COL 22 COLON-ALIGNED
     c-nome-moeda AT ROW 10.54 COL 26 COLON-ALIGNED NO-LABEL
     de-aliquota-iss AT ROW 11.54 COL 75 COLON-ALIGNED
     de-preco-unit AT ROW 11.54 COL 22 COLON-ALIGNED
     de-perc-descto AT ROW 8.54 COL 75 COLON-ALIGNED
     de-pre-unit-for-novo AT ROW 14.38 COL 65 COLON-ALIGNED
     de-qtd-rec-forn AT ROW 13.38 COL 22 COLON-ALIGNED
     c-un-nova AT ROW 14.38 COL 22 COLON-ALIGNED
     de-valor-total AT ROW 13.38 COL 65 COLON-ALIGNED
     RECT-6 AT ROW 8.25 COL 1
     RECT-7 AT ROW 13 COL 1
     rt-key AT ROW 2.5 COL 1
     rt-key-2 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.recebimento
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
         HEIGHT             = 14.5
         WIDTH              = 88.
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

/* SETTINGS FOR FILL-IN c-aux-cgc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-it-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nome-abrev IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nome-moeda IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-un IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-un-nova IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cod-emitente IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-aliquota-icm IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       de-aliquota-icm:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN de-aliquota-ipi IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-aliquota-iss IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       de-aliquota-iss:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN de-perc-descto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-pre-unit-for IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-pre-unit-for-novo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-preco-unit IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-qtd-rec-forn IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-qtd-sal-forn IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-valor-total IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-mo-codigo IN FRAME f-main
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

&Scoped-define SELF-NAME c-aux-cgc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-aux-cgc V-table-Win
ON LEAVE OF c-aux-cgc IN FRAME f-main /* CGC/CPF */
DO:
     assign c-cgc = input frame {&FRAME-NAME} c-aux-cgc no-error.
     if  ERROR-STATUS:ERROR then
         assign c-aux-cgc:format in frame {&FRAME-NAME} = "x(19)".
     else
         apply 'entry':U to c-aux-cgc in frame {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-un-nova
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-un-nova V-table-Win
ON LEAVE OF c-un-nova IN FRAME f-main /* Unidade de Medida */
DO:
    if item.tipo-contr = 4 then do:
        if avail cotacao-item then do:
            if cotacao-item.un <> input frame {&frame-name} c-un-nova then do:
                run utp/ut-msgs.p (input "show", 
                                   input 2391, 
                                   input "").
                apply "close" to this-procedure.
            end.
        end.
    end.
    else do:
        if avail item-fornec then do:
            if item-fornec.un <> input frame {&frame-name} c-un-nova then do:            
                run utp/ut-msgs.p (input "show", 
                                   input 2244, 
                                   input "").
                apply "close" to this-procedure.
            end.
        end.
    end.

    assign de-quant-receb = input frame {&frame-name} de-qtd-rec-forn / de-indice.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME da-data-nota
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL da-data-nota V-table-Win
ON LEAVE OF da-data-nota IN FRAME f-main /* Data do Documento */
DO:

    if input frame {&frame-name} da-data-nota > 
       input frame {&frame-name} da-data-movto then do:
       {utp/ut-field.i mgind recebimento data-nota 1}
       assign c-erro1 = return-value.
       {utp/ut-field.i mgind recebimento data-movto 1}
       assign c-erro2 = return-value.
       run utp/ut-msgs.p (input "show", 
                          input 508, 
                          input c-erro1 + "~~" + c-erro2).
       apply "entry" to da-data-nota in frame {&frame-name}.
       return no-apply.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME de-qtd-rec-forn
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-qtd-rec-forn V-table-Win
ON LEAVE OF de-qtd-rec-forn IN FRAME f-main /* Qt Recebida Fornec */
DO:

    display input frame {&frame-name} de-qtd-rec-forn * input frame {&frame-name} de-pre-unit-for-novo 
            @ de-valor-total with frame {&frame-name}.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME de-valor-total
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-valor-total V-table-Win
ON LEAVE OF de-valor-total IN FRAME f-main /* Valor Total */
DO: 

if input frame {&frame-name} de-qtd-rec-forn = 0 then 
    display 0 @ de-pre-unit-for-novo with frame {&frame-name}.
else             
    display input frame {&frame-name} de-valor-total / 
            input frame {&frame-name} de-qtd-rec-forn @ de-pre-unit-for-novo
            with frame {&frame-name}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-num-pedido
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-num-pedido V-table-Win
ON F5 OF i-num-pedido IN FRAME f-main /* Pedido */
DO:
assign l-f5 = yes.
    {include/zoomvar.i &prog-zoom= inzoom/z11in274.w
                       &campo=i-num-pedido
                       &campozoom=num-pedido
                       &campo2=i-numero-ordem
                       &campozoom2=numero-ordem
                       &campo3=i-parcela
                       &campozoom3=parcela
                       &parametros= "run pi-seta-inicial in  wh-pesquisa (input  i-cod-emitente)."} 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-num-pedido V-table-Win
ON LEAVE OF i-num-pedido IN FRAME f-main /* Pedido */
DO:

do with frame {&frame-name}:
    find first pedido-compr use-index emitente where pedido-compr.num-pedido   = input frame {&frame-name} i-num-pedido and
                                                     pedido-compr.cod-emitente = i-cod-emitente and
                                                     pedido-compr.situacao     <> 3 no-error.
    if not available pedido-compr then do:
            assign l-f5 = no.
        {utp/ut-field.i mgind pedido-compr num-pedido 1}
        assign c-erro1 = return-value.
        run utp/ut-msgs.p (input "show", 
                           input 47, 
                           input c-erro1).
        apply "entry" to i-num-pedido in frame {&frame-name}.
        return no-apply.
    end.
    else do:
        if pedido-compr.situacao <> 1 then do:
           assign l-f5 = no.
            run utp/ut-msgs.p (input "show", 
                               input 17251, 
                               input "").
            apply "entry" to i-num-pedido in frame {&frame-name}.
            return no-apply.
        end.
    end.

    if (l-f5 = no) then do:
        find first ordem-compra  
            where ordem-compra.num-pedido = input i-num-pedido
              and ordem-compra.situacao <> 4
              and ordem-compra.situacao <> 6
            no-error.
        if avail ordem-compra then do:
            assign i-numero-ordem:screen-value = string(ordem-compra.numero-ordem).
            find first prazo-compra NO-LOCK
                where prazo-compra.numero-ordem = ordem-compra.numero-ordem
                  and prazo-compra.situacao <> 4
                  and prazo-compra.situacao <> 6
            no-error.
            if avail prazo-compra then 
                assign i-parcela:screen-value = string(prazo-compra.parcela).
            else do:
                find first prazo-compra NO-LOCK
                    where prazo-compra.numero-ordem = ordem-compra.numero-ordem
                      and prazo-compra.situacao <> 4 
                no-error.
                if avail prazo-compra then
                    assign i-parcela:screen-value = string(prazo-compra.parcela).
            end. 
        end.
    end.
    else do:
        find ordem-compra 
            where ordem-compra.numero-ordem = input i-numero-ordem
              and ordem-compra.num-pedido = input i-num-pedido
        no-error.
    end.
    if avail ordem-compra then do:
        find first prazo-compra 
            where prazo-compra.numero-ordem = input i-numero-ordem
              and prazo-compra.parcela = input i-parcela
            no-error.
        if not avail prazo-compra then
            return no-apply.
        if  prazo-compra.situacao = 6 then do:
            run utp/ut-msgs.p (input "show", 
                               input 3819, 
                               input "").
        end.

        find item where item.it-codigo = ordem-compra.it-codigo NO-LOCK no-error.
        if item.tipo-contr <> 4 then 
            find item-fornec where item-fornec.cod-emitente = i-cod-emitente and
                                   item-fornec.it-codigo    = item.it-codigo no-lock no-error.
        display item.it-codigo @ c-it-codigo .
        display prazo-compra.un @ c-un .

        assign de-pre-ncz = ordem-compra.pre-unit-for.
        find moeda where moeda.mo-codigo = ordem-compra.mo-codigo no-lock no-error.
        if ordem-compra.mo-codigo <> 0 then do:
           run cdp/cd0812.p (input ordem-compra.mo-codigo,
                             input 0,
                             input ordem-compra.pre-unit-for,
                             input input frame {&frame-name} da-data-nota,
                             output de-pre-ncz).
        end.    

        display prazo-compra.qtd-sal-forn @ de-qtd-sal-forn with frame {&frame-name}.
        display ordem-compra.pre-unit-for @ de-pre-unit-for with frame {&frame-name}.
        display ordem-compra.mo-codigo @ i-mo-codigo with frame {&frame-name}.
        display moeda.descricao @ c-nome-moeda with frame {&frame-name}.
        display de-pre-ncz @ de-preco-unit with frame {&frame-name}.
        display de-pre-ncz @ de-pre-unit-for-novo with frame {&frame-name}.
        display prazo-compra.qtd-sal-forn @ de-qtd-rec-forn with frame {&frame-name}.
        display input frame {&frame-name} de-qtd-rec-forn * input frame {&frame-name} de-pre-unit-for-novo 
                @ de-valor-total with frame {&frame-name}.
        display ordem-compra.aliquota-ipi @ de-aliquota-ipi with frame {&frame-name}.                                    
        display ordem-compra.perc-descto @ de-perc-descto with frame {&frame-name}.

        assign  de-aliquota-icm:screen-value in frame {&frame-name} = string(ordem-compra.aliquota-icm) 
                de-aliquota-iss:screen-value in frame {&frame-name} = string(ordem-compra.aliquota-iss).                                                                                         

        assign de-indice = 1.
        if item.tipo-contr <> 4 then do:
            if avail item-fornec then do:
                assign de-indice = item-fornec.fator-conver / 
                                   if item-fornec.num-casa-dec = 0 then 1
                                       else exp(10,item-fornec.num-casa-dec).
                display item-fornec.un @ c-un-nova with frame {&frame-name}.
            end.
        end.
        else do:
            find cotacao-item use-index ordem-compra where cotacao-item.numero-ordem = ordem-compra.numero-ordem and
                                        cotacao-item.cod-emitente = ordem-compra.cod-emitente and
                                        cotacao-item.data-cotacao = ordem-compra.data-cotacao no-lock no-error.
            if available cotacao-item then do:
                display cotacao-item.un @ c-un-nova with frame {&frame-name}.
                if cotacao-item.un <> prazo-compra.un then do:
                    find tab-conv-un where tab-conv-un.un = prazo-compra.un and
                                           tab-conv-un.unid-med-for = cotacao-item.un no-lock no-error.
                    assign de-indice = if available tab-conv-un then
                                tab-conv-un.fator-conver / exp(10,tab-conv-un.num-casa-dec)
                                else 1.
                end.
            end.
        end.
        enable de-qtd-rec-forn with frame {&frame-name}.
        enable c-un-nova with frame {&frame-name}.
        enable de-valor-total with frame {&frame-name}.  
    end.
    else do:
        assign i-numero-ordem:screen-value = ""
               i-parcela:screen-value = ""
               de-qtd-rec-forn:screen-value = "0"
               c-un-nova:screen-value = ""
               de-valor-total:screen-value = "0".
        disable de-qtd-rec-forn with frame {&frame-name}.
        disable c-un-nova with frame {&frame-name}.
        disable de-valor-total with frame {&frame-name}.  
    end.
end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-num-pedido V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-num-pedido IN FRAME f-main /* Pedido */
DO:

    apply "F5" to self.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-parcela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-parcela V-table-Win
ON ENTRY OF i-parcela IN FRAME f-main /* Parcela */
DO:
  assign l-alterado = yes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-parcela V-table-Win
ON LEAVE OF i-parcela IN FRAME f-main /* Parcela */
DO:
    assign l-f5 = no.
    find first pedido-compr use-index emitente where pedido-compr.num-pedido   = input frame {&frame-name} i-num-pedido and
                                                     pedido-compr.cod-emitente = i-cod-emitente and
                                                     pedido-compr.situacao     = 1 no-error.
    if not available pedido-compr then do:
        {utp/ut-field.i mgind pedido-compr num-pedido 1}
        assign c-erro1 = return-value.
        run utp/ut-msgs.p (input "show", 
                           input 47, 
                           input c-erro1).
        apply "entry" to i-num-pedido in frame {&frame-name}.
        return no-apply.
    end.
    else do:
        find ordem-compra where ordem-compra.num-pedido   = input frame {&frame-name} i-num-pedido and
                                ordem-compra.numero-ordem = input frame {&frame-name} i-numero-ordem no-error.
        if not available ordem-compra then do:
            {utp/ut-field.i mgind ordem-compra numero-ordem 1}
            assign c-erro1 = return-value.
            run utp/ut-msgs.p (input "show", 
                               input 47, 
                               input c-erro1).
            apply "entry" to i-numero-ordem in frame {&frame-name}.
            return no-apply.
        end.
        else do:
            find prazo-compra where prazo-compra.numero-ordem = input frame {&frame-name} i-numero-ordem and
                                    prazo-compra.parcela      = input frame {&frame-name} i-parcela no-error.
            if not available prazo-compra then do:                                    
                {utp/ut-field.i mgind recebimento parcela 1}
                assign c-erro1 = return-value.
                run utp/ut-msgs.p (input "show", 
                                       input 47, 
                                       input c-erro1).
               apply "entry" to i-parcela in frame {&frame-name}.
               return no-apply.
            end.               
            if  prazo-compra.situacao = 6 then do:
                run utp/ut-msgs.p (input "show", 
                                       input 3819, 
                                       input "").
            end.
        end.
    end.                                    

    find item where item.it-codigo = ordem-compra.it-codigo NO-LOCK no-error.
    if item.tipo-contr <> 4 then 
        find item-fornec where item-fornec.cod-emitente = i-cod-emitente and
                               item-fornec.it-codigo    = item.it-codigo no-lock no-error.
    display item.it-codigo @ c-it-codigo with frame {&frame-name}.
    display prazo-compra.un @ c-un with frame {&frame-name}.

    assign de-pre-ncz = ordem-compra.pre-unit-for.
    find moeda where moeda.mo-codigo = ordem-compra.mo-codigo no-lock no-error.
    if ordem-compra.mo-codigo <> 0 then do:
       run cdp/cd0812.p (input ordem-compra.mo-codigo,
                         input 0,
                         input ordem-compra.pre-unit-for,
                         input input frame {&frame-name} da-data-nota,
                         output de-pre-ncz).
    end.

    display prazo-compra.qtd-sal-forn @ de-qtd-sal-forn with frame {&frame-name}.
    display ordem-compra.pre-unit-for @ de-pre-unit-for with frame {&frame-name}.
    display ordem-compra.mo-codigo @ i-mo-codigo with frame {&frame-name}.
    display moeda.descricao @ c-nome-moeda with frame {&frame-name}.
    display de-pre-ncz @ de-preco-unit with frame {&frame-name}.
    display de-pre-ncz @ de-pre-unit-for-novo with frame {&frame-name}.
    display prazo-compra.qtd-sal-forn @ de-qtd-rec-forn with frame {&frame-name}.
    display input frame {&frame-name} de-qtd-rec-forn * input frame {&frame-name} de-pre-unit-for-novo 
            @ de-valor-total with frame {&frame-name}.
    display ordem-compra.aliquota-ipi @ de-aliquota-ipi with frame {&frame-name}.                                    
    display ordem-compra.perc-descto @ de-perc-descto with frame {&frame-name}.

    assign  de-aliquota-icm:screen-value in frame {&frame-name} = string(ordem-compra.aliquota-icm) 
            de-aliquota-iss:screen-value in frame {&frame-name} = string(ordem-compra.aliquota-iss).                                                                                         

    assign de-indice = 1.
    if item.tipo-contr <> 4 then do:
        assign de-indice = item-fornec.fator-conver / 
                           if item-fornec.num-casa-dec = 0 then 1
                           else exp(10,item-fornec.num-casa-dec).
        display item-fornec.un @ c-un-nova with frame {&frame-name}.
    end.
    else do:
        find cotacao-item use-index ordem-compra where cotacao-item.numero-ordem = ordem-compra.numero-ordem and
                                        cotacao-item.cod-emitente = ordem-compra.cod-emitente and
                                        cotacao-item.data-cotacao = ordem-compra.data-cotacao no-lock no-error.
        if available cotacao-item then                                        
            display cotacao-item.un @ c-un-nova with frame {&frame-name}.
        if available cotacao-item then do:        
            if cotacao-item.un <> prazo-compra.un then do:
                find tab-conv-un where tab-conv-un.un = prazo-compra.un and
                                       tab-conv-un.unid-med-for = cotacao-item.un no-lock no-error.
                assign de-indice = if available tab-conv-un then
                    tab-conv-un.fator-conver / exp(10,tab-conv-un.num-casa-dec)
                    else 1.
            end.
        end.
    end.
    enable de-qtd-rec-forn with frame {&frame-name}.
    enable c-un-nova with frame {&frame-name}.
    enable de-valor-total with frame {&frame-name}.  
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

 if i-num-pedido:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.

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
  {src/adm/template/row-list.i "recebimento"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "recebimento"}

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
  /*RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .*/

  if  return-value = 'ADM-ERROR':U THEN
      return 'ADM-ERROR':U.

  /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
  /* Code placed here will execute AFTER standard behavior.    */

if  avail prazo-compra then
    assign prazo-compra.quant-saldo  = prazo-compra.quantidade - prazo-compra.quant-receb
           prazo-compra.qtd-sal-forn = prazo-compra.quant-saldo.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  if  param-global.bloqueio-cgc <> 1 then do:
      RUN pi-digito-verificador.
  end. 

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

  {utp/ut-field.i mgadm emitente cod-emitente 1}
  assign cod-emitente:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-field.i mgadm emitente cgc 1}
  assign c-aux-cgc:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-field.i mgind recebimento data-movto 1}
  assign da-data-movto:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-field.i mgind recebimento data-nota 1}
  assign da-data-nota:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-field.i mgind recebimento serie-nota 1}
  assign c-serie-nota:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-liter.i N£mero_Documento}
  assign c-numero-nota:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-field.i mgind recebimento recebedor 1}
  assign c-recebedor:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-field.i mgind recebimento num-pedido 1}
  assign i-num-pedido:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-field.i mgind recebimento it-codigo 1}
  assign c-it-codigo:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-field.i mgind recebimento parcela 1}
  assign i-parcela:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-liter.i Unidade_de_Medida} 
  assign c-un:label in frame {&FRAME-NAME} = trim(return-value)
         c-un-nova:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-liter.i Qtd_Saldo_Fornec}
  assign de-qtd-sal-forn:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-field.i mgind recebimento pre-unit-for 1}
  assign de-pre-unit-for:label in frame {&FRAME-NAME} = trim(return-value)
         de-pre-unit-for-novo:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-field.i mgind cotacao-item mo-codigo 1}
  assign i-mo-codigo:label in frame {&FRAME-NAME} = trim(return-value).  

  {utp/ut-field.i mgind recebimento preco-unit 2}
  assign de-preco-unit:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-liter.i Percentual_Desconto}
  assign de-perc-descto:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-field.i mgind recebimento aliquota-ipi 1}
  assign de-aliquota-ipi:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-field.i mgind recebimento aliquota-icm 1}
  assign de-aliquota-icm:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-field.i mgind recebimento aliquota-iss 1}
  assign de-aliquota-iss:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-liter.i Qt_Recebida_Fornec}
  assign de-qtd-rec-forn:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-field.i mgind recebimento valor-total 1}
  assign de-valor-total:label in frame {&FRAME-NAME} = trim(return-value).



  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

    display today @ da-data-movto with frame {&frame-name}.

    find first param-compra no-lock no-error.

    find first ordem-compra NO-LOCK no-error.
    find first prazo-compra NO-LOCK no-error.
    find first item NO-LOCK no-error.

    find first param-ge where param-ge.ep-codigo = param-global.empresa-prin no-lock no-error.

    find first param-global no-lock no-error.

    if param-global.modulo-ge then 
        assign l-modulo-ge = if avail param-ge 
                 then if param-ge.tp-atualizacao = 1
                         then (search("gep/ge0102a.p") <> ? or 
                               search("gep/ge0102a.r") <> ?)
                         else no
                 else no.
    else
        assign l-modulo-ge = no.

  /* Code placed here will execute AFTER standard behavior.    */

    if avail param-global then             
       assign c-aux-cgc:format in frame {&frame-name} = param-global.formato-id-federal.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-digito-verificador V-table-Win 
PROCEDURE pi-digito-verificador :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   define output parameter i-erro as integer initial 0 no-undo.
   define var c-cgc-aux as char no-undo.

   /*verifica se foi digitado algum caracter invalido no cgc/cpf*/
   if i-natureza = 2 then do:
      do i-cont = 1 to 14:
         if not can-do("0,1,2,3,4,5,6,7,8,9",substr(c-cgc,i-cont,1))
            or c-cgc = ?  then
            assign i-erro = 972.
      end.   
   end.
   if i-natureza = 1 then do:
      do i-cont = 1 to 11:
         if not can-do("0,1,2,3,4,5,6,7,8,9",substr(c-cgc,i-cont,1)) 
            or c-cgc = ? then
            assign i-erro = 972.
      end.   
   end.                 
   /*fim da verificacao de caracter invalido no cgc/cpf*/

   if i-natureza = 2 then do:   /*pessoa jurifica*/
      assign c-cgc-aux = fill("0",20 - length(c-cgc)) + c-cgc
             i-dig-ver = dec(substring(c-cgc-aux,19,2)).       
      {cdp/cd9900.i2} /*include de calculo do digito verificador do cgc*/
   end. 

   assign i-cont = 0 .

   if i-natureza = 1 then do:
      {cdp/cd9900.i3}  /*include de calculo do digito verificador do cpf*/
      assign i-dig-ver = dec(substring(c-cgc,10,2)).
   end.

   if i-digito <> i-dig-ver then do:
      if param-global.bloqueio-cgc = 2 then
         assign i-erro = 1008.
      if param-global.bloqueio-cgc = 3 then
         assign i-erro = 1007.
   end. 

   /*---- Verifica se o CGC j  existe para outro Cliente ------*/
   find first b-emitente no-lock
        where b-emitente.cgc = c-cgc
        and   rowid(b-emitente) <> rowid(emitente) no-error.
   if  avail b-emitente then 
       assign i-erro = 973.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-grava-recebimento V-table-Win 
PROCEDURE pi-grava-recebimento :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
def var c-usuario as char no-undo.
def var l-pendente as logical no-undo.

    assign de-quant-receb = input frame {&frame-name} de-qtd-rec-forn / de-indice.

    find first pedido-compr use-index emitente where pedido-compr.num-pedido   = input frame {&frame-name} i-num-pedido and
                                                     pedido-compr.cod-emitente = i-cod-emitente and
                                                     pedido-compr.situacao     <> 3 no-error.
    if not available pedido-compr then do:
        {utp/ut-field.i mgind pedido-compr num-pedido 1}
        assign c-erro1 = return-value.
        run utp/ut-msgs.p (input "show", 
                           input 47, 
                           input c-erro1).
        apply "entry" to i-num-pedido in frame {&frame-name}.
        return "adm-error".
    end.
    else do:
        if pedido-compr.situacao <> 1 then do:
            run utp/ut-msgs.p (input "show", 
                               input 17251, 
                               input "").
            apply "entry" to i-num-pedido in frame {&frame-name}.
            return "adm-error".
        end.
        find ordem-compra where ordem-compra.num-pedido   = input frame {&frame-name} i-num-pedido and
                                ordem-compra.numero-ordem = input frame {&frame-name} i-numero-ordem no-error.
        if not available ordem-compra then do:
            {utp/ut-field.i mgind ordem-compra numero-ordem 1}
            assign c-erro1 = return-value.
            run utp/ut-msgs.p (input "show", 
                               input 47, 
                               input c-erro1).
            apply "entry" to i-numero-ordem in frame {&frame-name}.
            return "adm-error".
        end.
        else do:
            find prazo-compra where prazo-compra.numero-ordem = input frame {&frame-name} i-numero-ordem and
                                    prazo-compra.parcela      = input frame {&frame-name} i-parcela no-error.
            if not available prazo-compra then do:                                    
                {utp/ut-field.i mgind recebimento parcela 1}
                assign c-erro1 = return-value.
                run utp/ut-msgs.p (input "show", 
                                       input 47, 
                                       input c-erro1).
               apply "entry" to i-parcela in frame {&frame-name}.
               return "adm-error".
            end.

            if avail param-compra and 
               param-compra.log-1 then do: /** Aprova‡Æo Eletr“nica **/
                if substring(param-compra.char-2,7,3) = "sim":U or
                   substring(param-compra.char-2,7,3) = "yes":U then 
                   assign c-usuario = pedido-compr.responsavel.
                else
                   assign c-usuario = ordem-compra.cod-comprado.
                assign l-pendente = no.
                run cdp/cdapi172.p (input 4,input rowid(ordem-compra),output l-pendente).
                if not l-pendente then
                    run cdp/cdapi172.p(input 6,input rowid(ordem-compra),output l-pendente).
                if l-pendente then do:
                    run utp/ut-msgs.p (input "show" , input 17022, input "").
                    apply "entry" to i-numero-ordem in frame {&frame-name}.
                    return "adm-error".
                end.
            end.
        end.
    end.

    assign l-rejeita-dec  = no.
    assign de-valor-total:screen-value in frame {&frame-name} = string(fn_vld_ajust_dec(input frame {&frame-name} de-valor-total,input frame {&frame-name} i-mo-codigo)).

    if  l-rejeita-dec then do:
        {utp/ut-field.i mgind recebimento valor-total 1}
        run utp/ut-msgs.p(input "show", 
                                   input 18130, 
                                   input trim(return-value)).
        apply 'entry':U to de-valor-total in frame {&frame-name}.
        return "ADM-ERROR":U.
    end.

    /* Consiste saldo da parcela */
    de-qtd-maxima-rec = prazo-compra.qtd-sal-forn * (param-compra.var-quantid / 100 + 1).
    if input frame {&frame-name} de-qtd-rec-forn > de-qtd-maxima-rec then do:
       run utp/ut-msgs.p ("show",5698,"").
       if not return-value = "yes" then 
          return "adm-error".
    end.

    if available param-compra then do:
        assign de-maximo-rec = (input frame {&frame-name} de-pre-unit-for * input frame {&frame-name} de-qtd-rec-forn) * 
                                   (param-compra.var-preco / 100 + 1).
        if input frame {&frame-name} de-valor-total > de-maximo-rec then do:
            run utp/ut-msgs.p (input "show", 
                               input 3718, 
                               input "").
            if return-value = "no" then do:
               apply "entry" to de-valor-total in frame {&frame-name}.
               return "adm-error".
            end.
        end.
    end.

    if can-find (first recebimento where recebimento.num-pedido = ordem-compra.num-pedido
                 and   recebimento.numero-nota = input frame {&frame-name} c-numero-nota
                 and   recebimento.numero-ordem = ordem-compra.numero-ordem
                 and   recebimento.parcela = prazo-compra.parcela) then 
    run utp/ut-msgs.p ('show',2628,'').    

    create recebimento.
    assign recebimento.data-movto   = input frame {&frame-name} da-data-movto
           recebimento.data-nota    = input frame {&frame-name} da-data-nota
           recebimento.serie-nota   = input frame {&frame-name} c-serie-nota
           recebimento.numero-nota  = input frame {&frame-name} c-numero-nota
           recebimento.recebedor    = input frame {&frame-name} c-recebedor
           recebimento.cod-movto    = 1
           recebimento.usuario      = c-seg-usuario
           recebimento.data-atualiz = today
           recebimento.hora-atualiz = string(time,"HH:MM:SS")
           recebimento.num-pedido   = ordem-compra.num-pedido
           recebimento.numero-ordem = ordem-compra.numero-ordem
           recebimento.parcela      = prazo-compra.parcela
           recebimento.preco-unit   = ordem-compra.preco-unit
           recebimento.aliquota-ipi = ordem-compra.aliquota-ipi
           recebimento.aliquota-icm = ordem-compra.aliquota-icm
           recebimento.aliquota-iss = ordem-compra.aliquota-iss
           recebimento.valor-ipi    = (ordem-compra.aliquota-ipi / 100) * input frame {&frame-name} de-valor-total
           recebimento.valor-icm    = (ordem-compra.aliquota-icm / 100) * input frame {&frame-name} de-valor-total
           recebimento.valor-iss    = (ordem-compra.aliquota-iss / 100) * input frame {&frame-name} de-valor-total
           recebimento.quant-receb  = de-quant-receb
           recebimento.qtd-rec-forn = input frame {&frame-name} de-qtd-rec-forn
           recebimento.qtd-rec      = de-quant-receb
           recebimento.valor-total  = input frame {&frame-name} de-valor-total.

    if input frame {&frame-name} de-pre-unit-for-novo  = ?
       or input frame {&frame-name} de-pre-unit-for-novo  = "" then do:
       assign de-pre-unit-for-novo = 0.
       disp de-pre-unit-for-novo with frame {&frame-name}.
    end.
    assign recebimento.pre-unit-for = input frame {&frame-name} de-pre-unit-for-novo
           recebimento.preco-unit   = input frame {&frame-name} de-pre-unit-for-novo * de-indice
           prazo-compra.quant-saldo = prazo-compra.quant-saldo - de-quant-receb
           de-saldo-forn = prazo-compra.qtd-sal-forn - input frame {&frame-name} de-qtd-rec-forn.

    if de-saldo-forn < 0 then de-saldo-forn = 0.
    assign de-qtd-tot = input frame {&frame-name} de-qtd-rec-forn
           prazo-compra.qtd-sal-forn = de-saldo-forn.
    if de-saldo-forn = 0 then
       assign prazo-compra.quant-saldo = 0
              prazo-compra.situacao    = 6.

    if prazo-compra.situacao <> 6 then
    run utp/ut-msgs.p (input "show", 
                       input 3719, 
                       input "").

    if return-value = "yes":U then 
       assign prazo-compra.situacao = 6.

    FIND FIRST b-item WHERE b-item.it-codigo = recebimento.it-codigo EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL b-item THEN
        assign b-item.preco-ul-ent = recebimento.preco-unit
               b-item.data-ult-ent = recebimento.data-movto.
    RELEASE b-item.

    ASSIGN recebimento.it-codigo = ordem-compra.it-codigo
           recebimento.cod-emitente = ordem-compra.cod-emitente.
    assign prazo-compra.qtd-rec-forn = prazo-compra.qtd-rec-forn + recebimento.qtd-rec-forn       
           prazo-compra.quant-receb  = prazo-compra.quant-receb + recebimento.quant-receb.

    &if defined(bf_mat_contratos) &then
    if ordem-compra.nr-contrato <> 0 then do:
    &else 
    if ordem-compra.nr-contrato <> "" then do:
    &endif
       assign ordem-compra.qt-acum-rec  = ordem-compra.qt-acum-rec + recebimento.quant-receb.
    end.   

       if ordem-compra.mo-codigo > 0 then do:
          run cdp/cd0812.p (input ordem-compra.mo-codigo,
                            input 0,
                            input ordem-compra.pre-unit-for,
                            input ordem-compra.data-pedido,
                            output de-preco-conv).
          if de-preco-conv = ? then
             assign de-preco-conv = ordem-compra.pre-unit-for.
       end.
       else
          assign de-preco-conv = ordem-compra.pre-unit-for.

    assign de-val-tot = de-qtd-tot * de-preco-conv.
    if l-modulo-ge = yes then do:
       {utp/ut-liter.i recebimento * R}.
       assign c-gerencial = return-value
              r-gerencial = rowid(ordem-compra).
       run gep/ge0102a.p (input r-gerencial,
                          input 6).
    end.
    find first prazo-compra where
        prazo-compra.numero-ordem = ordem-compra.numero-ordem and
        prazo-compra.situacao <> 6 and
        prazo-compra.situacao <> 4 no-lock no-error.
    if not available prazo-compra then do:
       &if defined(bf_mat_contratos) &then
       if ordem-compra.nr-contrato = 0 then do:
       &else
       if ordem-compra.nr-contrato = "" then do:
       &endif
          assign ordem-compra.situacao = 6.
       end.   
       else do:
            find last b-prazo where b-prazo.numero-ordem = ordem-compra.numero-ordem no-lock no-error.
            create prazo-compra.
            assign prazo-compra.parcela = if avail b-prazo
                        then b-prazo.parcela + 1
                        else 1
                   prazo-compra.quantidade = 0
                   prazo-compra.quant-saldo = 0
                   prazo-compra.qtd-do-forn = 0
                   prazo-compra.qtd-sal-for = 0
                   prazo-compra.it-codigo = ordem-compra.it-codigo
                   prazo-compra.un = if  avail b-prazo
                        then b-prazo.un
                        else item.un
                   prazo-compra.data-entrega = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF
                   prazo-compra.nome-abrev   = if avail b-prazo
                        then b-prazo.nome-abrev
                        else ""
                   prazo-compra.pedido-clien = if avail b-prazo
                        then b-prazo.pedido-clien
                        else ""
                   prazo-compra.nr-sequencia = if avail b-prazo
                        then b-prazo.nr-sequencia
                        else 0
                   prazo-compra.data-orig    = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF
                   prazo-compra.numero-ordem = ordem-compra.numero-ordem
                   prazo-compra.it-codigo    = ordem-compra.it-codigo
                   prazo-compra.situacao     = ordem-compra.situacao
                   prazo-compra.nr-contrato  = ordem-compra.nr-contrato
                   prazo-compra.cod-alter = no.
        end.
    end.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-passa-emitente V-table-Win 
PROCEDURE pi-passa-emitente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input parameter p-emitente as integer no-undo.

    assign i-cod-emitente = p-emitente.

    find emitente where emitente.cod-emitente = i-cod-emitente no-lock no-error.

    display emitente.cod-emitente @ cod-emitente with frame {&frame-name}.
    display emitente.nome-abrev @ c-nome-abrev with frame {&frame-name}.

    if emitente.natureza = 1 then
       assign c-aux-cgc:format in frame {&FRAME-NAME} = if avail param-global 
                                                             then param-global.formato-id-pessoal
                                                             else "x(19)":U.
    else if emitente.natureza = 2 then 
            assign c-aux-cgc:format in frame {&FRAME-NAME} = if avail param-global 
                                                             then param-global.formato-id-federal
                                                             else "x(19)":U.
         else
            assign c-aux-cgc:format in frame {&FRAME-NAME} = "x(19)":U.

    display emitente.cgc @ c-aux-cgc with frame {&frame-name}.



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

   /*Segue um exemplo de valida‡Æo de programa 
 *    find tabela where tabela.campo1 = c-variavel and
 *                      tabela.campo2 > i-variavel no-lock no-error.
 *    {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
 *    run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *    return 'ADM-ERROR':U.*/

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
  {src/adm/template/snd-list.i "recebimento"}

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

