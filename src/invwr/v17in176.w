&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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
{include/i-prgvrs.i V17IN176 2.00.00.056} /*** "010056" 14/02/2024 16:11:08 ***/



&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v17in176 MUT}
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
{cdp/cdcfgman.i}

/* global variable definitions */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

    def var v-row-parent        as rowid    no-undo.
    def var c-nat-operacao      as char     no-undo.
    def var l-pede-qtd          as logical  no-undo.
    def var l-pede-peso         as logical  no-undo.
    def var l-pede-valor        as logical  no-undo.

    def new global shared var gr-docum-est  as rowid   no-undo.
    def new global shared var i-programa-re as integer no-undo.
    /**
    ***  Recebimento    1 - Normal
    ***                 2 - F°sico
    ***                 3 - Internacional
    **/

    def buffer b-item-doc-est for item-doc-est.

    {rep/re9800.i}
    {rep/re1001.i07}
    {cdp/cd0666.i}
    {cdp/cd4329.i2} /* Aloca/Desaloca parcela de Compra */
    {bcp/bcapi011.i} /* temp-table tt-etq-item */ 
    {bcp/bcapi004.i} /* Definiá∆o da temp-table tt-prog-bc */

    def var c-it-codigo        as char    no-undo.
    def var c-cod-refer        as char    no-undo.
    def var i-num-pedido       as integer no-undo.
    def var i-numero-ordem     as integer no-undo.
    def var i-parcela          as integer no-undo.
    def var c-serie-comp       as char    no-undo.
    def var c-nro-comp         as char    no-undo.
    def var c-nat-comp         as char    no-undo.
    def var i-seq-comp         as integer no-undo.
    def var de-qtd-aux         as decimal no-undo.
    def var de-indice          as decimal no-undo.
    def var c-un               as char    no-undo.
    def var de-preco-unit      as decimal no-undo.
    def var de-desconto        as decimal no-undo.
    def var de-val-contrato    as decimal no-undo.
    def var de-val-aux         as decimal no-undo.
    def var de-val-formula     as decimal no-undo.
    def var de-vl-merc-liq     as decimal no-undo.
    def var de-vl-preuni       as decimal no-undo.
    def var i-round            as integer no-undo.
    def var de-preco-total     as decimal no-undo.
    def var de-qtd-max         as decimal no-undo.
    def var de-dec-1           as decimal no-undo.
    def var de-vl-merc-liq-aux as decimal no-undo.
    def var de-var-min         as decimal no-undo.
    def var l-contrato         as logical no-undo.
    def var de-var-max         as decimal no-undo.
    def var de-var-max-aux     as decimal no-undo.
    def var l-erro-co          as logical no-undo.
    def var de-despesa         as decimal no-undo.    
    def var de-frete           as decimal no-undo.
    def var l-novo-reg         as logical no-undo.
    def var i-evento           as integer no-undo.
    def var c-un-aux           as char    no-undo.
    def var h_b03in367         as handle  no-undo.
    def var h_v18in176         as handle  no-undo.
    def var h_v16in176         as handle  no-undo.
    def var de-qt-aux          like  item-doc-est.quantidade no-undo.
    def var i-sequencia        like  item-doc-est.sequencia  no-undo.
    def var l-erro-qtd         as logical no-undo.
    def var l-baixa-estoq      as logical no-undo.
    def var de-taxa            as decimal no-undo.
    def var de-vl-aux          as decimal no-undo.
    def var de-alocada         like saldo-terc.dec-1 no-undo.
    def var de-preco-t         as decimal no-undo.
    def var de-prop-fam        as decimal no-undo.
    def var l-mat-agregado     as log     no-undo.
    def var i-nr-ord-prod      as int     no-undo.
    def var c-item-pai         as char    no-undo.
    def var c-cod-roteiro      as char    no-undo.
    def var i-op-codigo        as int     no-undo.
    def var l-alter-itens      as logical no-undo init no.
    def var i-total            as int     no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES item-doc-est
&Scoped-define FIRST-EXTERNAL-TABLE item-doc-est


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR item-doc-est.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS item-doc-est.qt-do-forn ~
item-doc-est.quantidade item-doc-est.un item-doc-est.preco-unit[1] ~
item-doc-est.preco-total[1] item-doc-est.desconto[1] ~
item-doc-est.peso-liquido item-doc-est.pr-total-cmi ~
item-doc-est.despesas[1] 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}qt-do-forn ~{&FP2}qt-do-forn ~{&FP3}~
 ~{&FP1}quantidade ~{&FP2}quantidade ~{&FP3}~
 ~{&FP1}un ~{&FP2}un ~{&FP3}~
 ~{&FP1}preco-unit[1] ~{&FP2}preco-unit[1] ~{&FP3}~
 ~{&FP1}preco-total[1] ~{&FP2}preco-total[1] ~{&FP3}~
 ~{&FP1}desconto[1] ~{&FP2}desconto[1] ~{&FP3}~
 ~{&FP1}peso-liquido ~{&FP2}peso-liquido ~{&FP3}~
 ~{&FP1}pr-total-cmi ~{&FP2}pr-total-cmi ~{&FP3}~
 ~{&FP1}despesas[1] ~{&FP2}despesas[1] ~{&FP3}
&Scoped-define ENABLED-TABLES item-doc-est
&Scoped-define FIRST-ENABLED-TABLE item-doc-est
&Scoped-Define ENABLED-OBJECTS rt-key-2 rt-key-4 rt-key-5 
&Scoped-Define DISPLAYED-FIELDS item-doc-est.qt-do-forn ~
item-doc-est.quantidade item-doc-est.un item-doc-est.preco-unit[1] ~
item-doc-est.preco-total[1] item-doc-est.desconto[1] ~
item-doc-est.peso-liquido item-doc-est.pr-total-cmi ~
item-doc-est.despesas[1] 

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
DEFINE RECTANGLE rt-key-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 43.14 BY 9.17.

DEFINE RECTANGLE rt-key-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 42.86 BY 4.5.

DEFINE RECTANGLE rt-key-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 42.86 BY 4.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     item-doc-est.qt-do-forn AT ROW 1.83 COL 16.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20.57 BY .88
     item-doc-est.quantidade AT ROW 2.83 COL 16.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     item-doc-est.un AT ROW 3.83 COL 16.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.14 BY .88
     item-doc-est.preco-unit[1] AT ROW 6.5 COL 16.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20.57 BY .88
     item-doc-est.preco-total[1] AT ROW 7.5 COL 16.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     item-doc-est.desconto[1] AT ROW 8.5 COL 16.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     item-doc-est.peso-liquido AT ROW 4 COL 61.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     item-doc-est.pr-total-cmi AT ROW 5 COL 61.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     item-doc-est.despesas[1] AT ROW 6 COL 61.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     rt-key-2 AT ROW 1 COL 44.57
     rt-key-4 AT ROW 1 COL 1
     rt-key-5 AT ROW 5.67 COL 1
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
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 9.17
         WIDTH              = 86.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

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

&Scoped-define SELF-NAME item-doc-est.desconto[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.desconto[1] V-table-Win
ON ENTRY OF item-doc-est.desconto[1] IN FRAME f-main /* Desconto[1] */
DO:
  assign item-doc-est.desconto[1]:modified in frame {&FRAME-NAME} = no.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.desconto[1] V-table-Win
ON LEAVE OF item-doc-est.desconto[1] IN FRAME f-main /* Desconto[1] */
DO:
  if item-doc-est.desconto[1]:modified in frame {&FRAME-NAME} then do:
    run pi-apos-preco.
    run pi-calc-ipi in h_v18in176 (input input frame {&FRAME-NAME} item-doc-est.preco-total[1],
                                   input input frame {&FRAME-NAME} item-doc-est.desconto[1],
                                   input input frame {&FRAME-NAME} item-doc-est.despesas[1],
                                   input input frame {&FRAME-NAME} item-doc-est.pr-total-cmi).
  end.                                 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-doc-est.despesas[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.despesas[1] V-table-Win
ON ENTRY OF item-doc-est.despesas[1] IN FRAME f-main /* Despesas[1] */
DO:
  assign item-doc-est.despesas[1]:modified in frame {&FRAME-NAME} = no.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.despesas[1] V-table-Win
ON LEAVE OF item-doc-est.despesas[1] IN FRAME f-main /* Despesas[1] */
DO:
  if item-doc-est.despesas[1]:modified in frame {&FRAME-NAME} then 
    run pi-calc-ipi in h_v18in176 (input input frame {&FRAME-NAME} item-doc-est.preco-total[1],
                                   input input frame {&FRAME-NAME} item-doc-est.desconto[1],
                                   input input frame {&FRAME-NAME} item-doc-est.despesas[1],
                                   input input frame {&FRAME-NAME} item-doc-est.pr-total-cmi).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-doc-est.pr-total-cmi
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.pr-total-cmi V-table-Win
ON ENTRY OF item-doc-est.pr-total-cmi IN FRAME f-main /* Preáo Total */
DO:
  assign item-doc-est.pr-total-cmi:modified in frame {&FRAME-NAME} = no.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.pr-total-cmi V-table-Win
ON LEAVE OF item-doc-est.pr-total-cmi IN FRAME f-main /* Preáo Total */
DO:
  if item-doc-est.pr-total-cmi:modified in frame {&FRAME-NAME} then 
    run pi-calc-ipi in h_v18in176 (input input frame {&FRAME-NAME} item-doc-est.preco-total[1],
                                   input input frame {&FRAME-NAME} item-doc-est.desconto[1],
                                   input input frame {&FRAME-NAME} item-doc-est.despesas[1],
                                   input input frame {&FRAME-NAME} item-doc-est.pr-total-cmi).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-doc-est.preco-total[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.preco-total[1] V-table-Win
ON ENTRY OF item-doc-est.preco-total[1] IN FRAME f-main /* Preáo Total[1] */
DO:
  assign item-doc-est.preco-total[1]:modified in frame {&FRAME-NAME} = no.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.preco-total[1] V-table-Win
ON LEAVE OF item-doc-est.preco-total[1] IN FRAME f-main /* Preáo Total[1] */
DO:

    if  input frame {&frame-name} item-doc-est.qt-do-forn = 0 then
        assign item-doc-est.preco-unit[1]:screen-value in frame {&frame-name} =
            string(input frame {&frame-name} item-doc-est.preco-total[1]).
    else
        assign item-doc-est.preco-unit[1]:screen-value in frame {&frame-name} =
            string(input frame {&frame-name} item-doc-est.preco-total[1] /
                   input frame {&frame-name} item-doc-est.qt-do-forn).

    if item-doc-est.preco-total[1]:modified in frame {&FRAME-NAME} then do:

        if adm-new-record then do:
            if  param-re.rateia-desc 
            and available docum-est then do:
                run rep/re1001r.p (rowid(docum-est),
                                   input frame {&frame-name} item-doc-est.preco-total[1],
                                   1,
                                   output de-desconto).
                if  de-desconto <> 0 then do:                               
                    assign item-doc-est.desconto[1]:screen-value in frame {&frame-name} =
                           string(de-desconto).
                end.                       
            end.                
        end.            
        run pi-apos-preco. 

        if  adm-new-record then 
            run pi-calc-ipi in h_v18in176 (input input frame {&FRAME-NAME} item-doc-est.preco-total[1],
                                           input input frame {&FRAME-NAME} item-doc-est.desconto[1],
                                           input input frame {&FRAME-NAME} item-doc-est.despesas[1],
                                           input input frame {&FRAME-NAME} item-doc-est.pr-total-cmi).

    end.        


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-doc-est.preco-unit[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.preco-unit[1] V-table-Win
ON ENTRY OF item-doc-est.preco-unit[1] IN FRAME f-main /* Preáo Unit[1] */
DO:
    assign item-doc-est.preco-unit[1]:modified in frame {&FRAME-NAME} = no.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.preco-unit[1] V-table-Win
ON LEAVE OF item-doc-est.preco-unit[1] IN FRAME f-main /* Preáo Unit[1] */
DO:

    if i-total = 0 or i-total = 2 then 

       assign item-doc-est.preco-total[1]:screen-value in frame {&frame-name} =
           string(input frame {&frame-name} item-doc-est.preco-unit[1] *
                        (input frame {&frame-name} item-doc-est.qt-do-forn +
                        int(input frame {&frame-name} item-doc-est.qt-do-forn = 0))).

    if item-doc-est.preco-unit[1]:modified in frame {&FRAME-NAME} then do:
        assign item-doc-est.preco-total[1]:modified in frame {&FRAME-NAME} = yes.
        apply "leave" to item-doc-est.preco-total[1] in frame {&FRAME-NAME}.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-doc-est.qt-do-forn
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.qt-do-forn V-table-Win
ON ENTRY OF item-doc-est.qt-do-forn IN FRAME f-main /* Qtde Emitente */
DO:
  assign item-doc-est.qt-do-forn:modified in frame {&FRAME-NAME} = no.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.qt-do-forn V-table-Win
ON LEAVE OF item-doc-est.qt-do-forn IN FRAME f-main /* Qtde Emitente */
DO:
    if  adm-new-record then do:
        assign item-doc-est.quantidade:screen-value in frame {&frame-name} =
            string((input frame {&frame-name} item-doc-est.qt-do-forn / de-indice)).
        if item.fraciona = no then
            assign item-doc-est.quantidade:screen-value in frame {&frame-name} = 
                string(truncate(input frame {&frame-name} item-doc-est.quantidade,0)).
    end.                            


    if l-devolucao then do:
        /* Calcula quantidade m†xima para devoluá∆o cliente - re1001.i04 */
        find it-nota-fisc where
            it-nota-fisc.cod-estabel = docum-est.cod-estabel and
            it-nota-fisc.serie       = c-serie-comp and
            it-nota-fisc.nr-nota-fis = docum-est.nro-docto and
            it-nota-fisc.it-codigo   = c-it-codigo and
            it-nota-fisc.nr-seq-fat  = i-seq-comp
            no-lock no-error.
        if available it-nota-fisc then do:
            assign de-qtd-max = it-nota-fisc.qt-faturada[1].
            for each devol-cli where
                devol-cli.cod-estabel  = it-nota-fisc.cod-estabel and
                devol-cli.nr-nota-fis  = it-nota-fisc.nr-nota-fis and
                devol-cli.serie        = it-nota-fisc.serie and
                devol-cli.nr-sequencia = it-nota-fisc.nr-seq-fat and
                devol-cli.it-codigo    = it-nota-fisc.it-codigo
                no-lock:
                assign de-qtd-max = de-qtd-max - devol-cli.qt-devolvida.
            end.
        end.
        else
            assign de-qtd-max = ?.
    end.

    RUN Get-Field-Screen-Value IN adm-broker-hdl(INPUT this-procedure, INPUT "numero-ordem").           
    if int(return-value) <> 0 then 
       find ordem-compra
        where ordem-compra.numero-ordem = int(return-value) no-lock no-error.


    if int(return-value) = 0
    &if defined(bf_mat_contratos) &then
    or (avail ordem-compra and ordem-compra.nr-contrato = 0)
    &else
    or (avail ordem-compra and ordem-compra.nr-contrato = " ")
    &endif
    or not param-global.modulo-cn then
       assign i-total = 0.

    if int(return-value) = 0 then do: 
       if item-doc-est.qt-do-forn:modified in frame {&FRAME-NAME} then
          apply "leave" to item-doc-est.preco-unit[1] in frame {&FRAME-NAME}.
    end.      
    else do:
       find ordem-compra where ordem-compra.numero-ordem = int(return-value) no-lock no-error.
       if avail ordem-compra and
                ordem-compra.natureza <> 2 then do:
          if item-doc-est.qt-do-forn:modified in frame {&FRAME-NAME} then
             apply "leave" to item-doc-est.preco-unit[1] in frame {&FRAME-NAME}.
       end.
    end.      

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-doc-est.quantidade
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.quantidade V-table-Win
ON LEAVE OF item-doc-est.quantidade IN FRAME f-main /* Nossa Qtde */
DO:

/*A l¢gica de alocaá∆o do saldo-terc ir† ficar somente na assign-records*/
/*    if  l-retorno then do:
 *         /* Atualiza quantidade alocada no saldo terceiros - cd4326.i1 */
 *         find saldo-terc where 
 *             saldo-terc.cod-emitente = docum-est.cod-emitente and 
 *             saldo-terc.nro-docto    = c-nro-comp and 
 *             saldo-terc.serie-docto  = c-serie-comp and 
 *             saldo-terc.nat-operacao = c-nat-comp and 
 *             saldo-terc.it-codigo    = c-it-codigo and 
 *             saldo-terc.cod-refer    = c-cod-refer and 
 *             saldo-terc.sequencia    = i-seq-comp
 *             exclusive-lock no-error.
 *         if  avail saldo-terc then 
 *             assign saldo-terc.dec-1   = saldo-terc.dec-1 + input frame {&frame-name} item-doc-est.quantidade
 *                    item-doc-est.dec-2 = input frame {&frame-name} item-doc-est.quantidade.     
 *     end.        */

    if  not available natur-oper 
    or  l-retorno 
    or  ( l-devolucao and de-prop-fam = 1 ) 
    or  ( param-re.pede-quant and not l-devolucao ) then
        assign item-doc-est.qt-do-forn:screen-value in frame {&frame-name} =
                                    string(input frame {&frame-name} item-doc-est.quantidade * de-indice).


    /** Passa nova quantidade para o browse de estoque.  */
    if  valid-handle(h_b03in367) then do:

        run pi-passa-baixa-estoq in h_v16in176 ( output l-baixa-estoq ).

        if  l-baixa-estoq then
            run pi-dados-complement in h_b03in367 (input frame {&frame-name} item-doc-est.quantidade).
        else
            run pi-dados-complement in h_b03in367 ( 0 ).

    end.


    /**** consistencia do coleta de dados ****/

    find first param-global no-lock no-error.

    if  avail param-global
    and param-global.modulo-cl
    then do:

        for each tt-etq-item:
            delete tt-etq-item.
        end.

        for each tt-prog-bc:
            delete tt-prog-bc.
        end.

        create tt-prog-bc.
        assign tt-prog-bc.cod-prog-dtsul        = "re1001"
               tt-prog-bc.cod-versao-integracao = 1
               tt-prog-bc.usuario               = c-seg-usuario
               tt-prog-bc.opcao                 = 1.

        run bcp/bcapi004.p (input-output table tt-prog-bc,
                            input-output table tt-erro).

        if return-value = "OK" then do:

            find first tt-prog-bc no-error.

            create tt-etq-item.
            assign tt-etq-item.it-codigo = c-it-codigo
                   tt-etq-item.cod-versao-integracao = 1
                   tt-etq-item.qt-item   = if avail item-doc-est 
                                           then dec(item-doc-est.quantidade:screen-value in frame {&frame-name})
                                           else 0
                   tt-etq-item.cd-trans  = if avail tt-prog-bc then tt-prog-bc.cd-trans else "".

            run bcp/bcapi011.p (input-output table tt-etq-item).

            find first tt-etq-item no-error. 

            run pi-muda-qt-etiqueta in h_v16in176 ( input ( if  return-value = "OK" 
                                                            and avail tt-etq-item 
                                                            then tt-etq-item.qt-etiqueta 
                                                            else 0) ).
        end.    
    end.

    /**********************************************/    

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
        {utp/ut-liter.i Preáo_Unit * L}
        assign item-doc-est.preco-unit[1]:label  = return-value.
        {utp/ut-liter.i Preáo_Total * L}
        assign item-doc-est.preco-total[1]:label  = return-value.
        {utp/ut-liter.i Desconto * L}
        assign item-doc-est.desconto[1]:label  = return-value.
        {utp/ut-liter.i Frete_Constante * L}
        assign item-doc-est.pr-total-cmi:label  = return-value.
        {utp/ut-liter.i Total_Despesas * L}
        assign item-doc-est.despesas[1]:label  = return-value.
    end.

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

    for each tt-erro:
        delete tt-erro.
    end.

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
  if adm-new-record = no then
      assign de-qt-aux = item-doc-est.quantidade.
  else 
      assign de-qt-aux = 0.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  if RETURN-VALUE = 'ADM-ERROR':U then 
      return 'ADM-ERROR':U.

  assign item-doc-est.cod-emitente = docum-est.cod-emitente
         item-doc-est.nro-docto    = docum-est.nro-docto
         item-doc-est.serie-docto  = docum-est.serie-docto
         item-doc-est.nat-operacao = docum-est.nat-operacao.

  assign item-doc-est.dec-1 = de-dec-1
         l-novo-reg = no.

  if  l-retorno then do:
      /* Atualiza quantidade alocada no saldo terceiros - cd4326.i1 */
        find saldo-terc where
             saldo-terc.cod-emitente = docum-est.cod-emitente  and
             saldo-terc.nro-docto    = item-doc-est.nro-comp   and
             saldo-terc.serie-docto  = item-doc-est.serie-comp and 
             saldo-terc.nat-operacao = item-doc-est.nat-comp   and 
             saldo-terc.it-codigo    = item-doc-est.it-codigo  and 
             saldo-terc.cod-refer    = item-doc-est.cod-refer  and 
             saldo-terc.sequencia    = item-doc-est.seq-comp   
             exclusive-lock no-error.

       if avail saldo-terc then 
           assign saldo-terc.dec-1 = saldo-terc.dec-1 + item-doc-est.quantidade - de-qt-aux
                  saldo-terc.dec-1 = if  saldo-terc.dec-1 < 0 then 0 
                                     else saldo-terc.dec-1.
  end.        

  if  item-doc-est.log-1 = yes and adm-new-record then 
      run rep/re1001p.p (input rowid(item-doc-est)).

  assign l-erro-qtd = no.

  if  not param-re.sem-pedido
  and item-doc-est.log-1 then do:
      assign de-qtd-aux = 0.

      for each rat-ordem {cdp/cd8900.i rat-ordem item-doc-est}
           and rat-ordem.sequencia = item-doc-est.sequencia no-lock:
          assign de-qtd-aux = de-qtd-aux + rat-ordem.quantidade.
      end.
      if  de-qtd-aux < item-doc-est.quantidade then 
          assign l-erro-qtd = yes.

      run rep/re9995.p ( rowid(docum-est),
                         de-qtd-aux,
                         item-doc-est.quantidade,
                         15455,
                         de-qtd-aux = item-doc-est.quantidade,
                         item-doc-est.sequencia,
                         1 ).
  end.      

  for each tt-erro:
      delete tt-erro.
  end.


  find prazo-compra
       where prazo-compra.numero-ordem = i-numero-ordem
         and prazo-compra.parcela      = i-parcela
       exclusive-lock no-error.
  if avail prazo-compra then do:
      if adm-new-record then 
          run pi-aloca-ordem-cc (input yes,
                                 input item-doc-est.quantidade,
                                 input rowid(prazo-compra)).
      else 
          run pi-aloca-ordem-cc (input no,
                                 input de-qt-aux,
                                 input rowid(prazo-compra)).
  end.

  if  not adm-new-record then do:
      find prazo-compra
            where prazo-compra.numero-ordem = item-doc-est.numero-ordem 
              and prazo-compra.parcela      = item-doc-est.parcela exclusive-lock no-error.
      if  avail prazo-compra then                                  
          run pi-aloca-ordem-cc (input yes,
                                 input item-doc-est.quantidade,
                                 input rowid(prazo-compra)).
  end.

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

    for each tt-erro:
        delete tt-erro.
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

    assign l-novo-reg = no.

    for each tt-erro:
        delete tt-erro.
    end.

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
  /** Monta temp-table saldo estoque no browse de estoque.  

    if valid-handle(h_b03in367) and 
        not l-novo-reg then
        run pi-monta-sal-re in h_b03in367.*/

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

    disable all with frame {&frame-name}.

    assign l-novo-reg = yes
           i-numero-ordem = 0
           i-parcela      = 0
           de-prop-fam    = 1.

    if  adm-new-record = yes then do:
        &if  defined(ADM-MODIFY-FIELDS) &then
             enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
        &endif
    end. 
    else do:

        if  avail item-doc-est then do:
            find it-nota-fisc 
                where it-nota-fisc.cod-estabel = docum-est.cod-estabel 
                  and it-nota-fisc.serie       = item-doc-est.serie-comp 
                  and it-nota-fisc.nr-nota-fis = item-doc-est.nro-comp
                  and it-nota-fisc.nr-seq-fat  = item-doc-est.seq-comp 
                  and it-nota-fisc.it-codigo   = item-doc-est.it-codigo no-lock no-error.

            if  avail it-nota-fisc 
            and it-nota-fisc.ind-fat-qtfam then 
                assign de-prop-fam = it-nota-fisc.qt-faturada[2] / it-nota-fisc.qt-faturada[1].
        end.         
    end.                

    if  avail item-doc-est then do:
        assign i-numero-ordem = item-doc-est.numero-ordem
               i-parcela      = item-doc-est.parcela.
        find saldo-terc 
            where saldo-terc.cod-emitente = item-doc-est.cod-emitente 
              and saldo-terc.serie-docto  = item-doc-est.serie-comp 
              and saldo-terc.nat-operacao = item-doc-est.nat-comp 
              and saldo-terc.nro-docto    = item-doc-est.nro-comp 
              and saldo-terc.it-codigo    = item-doc-est.it-codigo 
              and saldo-terc.sequencia    = item-doc-est.seq-comp 
              and saldo-terc.cod-refer    = item-doc-est.cod-refer
            no-lock no-error.
    end.

    find item-fornec 
        where item-fornec.cod-emitente = docum-est.cod-emitente 
          and item-fornec.it-codigo    = c-it-codigo  no-lock no-error.

    if  available natur-oper then do:
        assign l-retorno = natur-oper.terceiros
                           and   natur-oper.tp-oper-terc = 2 or
                                 natur-oper.tp-oper-terc = 4 or
                                 natur-oper.tp-oper-terc = 5 OR
                                 natur-oper.tp-oper-terc = 9 OR
                                 natur-oper.tp-oper-terc = 11 .           
        /* Indica se Altera valor do itens em operacao com terceiros */
        assign l-alter-itens = int(substr(natur-oper.char-2,36,5)) = 1.
    end.                         

    if  i-programa-re = 1 then
        run pi-recebimento.
    else
    if  i-programa-re = 2 then
        run pi-fisico.
    else
        run pi-internacional.

    if  not l-transf then do:
        if  l-pede-qtd then do:
            if  avail natur-oper and ( not l-devolucao or de-prop-fam <> 1 ) 
            and not l-retorno then
                enable item-doc-est.qt-do-forn with frame {&frame-name}.

            enable item-doc-est.quantidade with frame {&frame-name}.
        end.

        if  not available natur-oper 
        or  not natur-oper.terceiros 
        or  l-alter-itens
        or ( natur-oper.tp-oper-terc <> 2 AND natur-oper.tp-oper-terc <> 9 AND natur-oper.tp-oper-terc <> 11 
        and  natur-oper.tp-oper-terc <> 4 
        and  natur-oper.tp-oper-terc <> 5) then do:
             if  param-re.preco-unit then
                 enable item-doc-est.preco-unit[1]  with frame {&frame-name}.

            enable item-doc-est.preco-total[1] with frame {&frame-name}.

            if param-re.pede-desc-it then
                enable item-doc-est.desconto[1]    with frame {&frame-name}.
        end.

        if  l-pede-peso then
            enable item-doc-est.peso-liquido with frame {&frame-name}.

        if  l-pede-valor then
            enable item-doc-est.pr-total-cmi 
                   item-doc-est.despesas[1] with frame {&frame-name}.

    end.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-end-update V-table-Win 
PROCEDURE local-end-update :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'end-update':U ) .

  if  l-erro-qtd then do:
      /* {include/i-vldprg.i} */
       run utp/ut-msgs.p (input "show",input 15455,input " ").
       apply 'entry' to item-doc-est.quantidade in frame {&frame-name}.
  end.      

  /* Code placed here will execute AFTER standard behavior.    */

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

  do  with frame {&frame-name}:
      {utp/ut-liter.i Preáo_Unit * L}
      assign item-doc-est.preco-unit[1]:label  = return-value.
      {utp/ut-liter.i Preáo_Total * L}
      assign item-doc-est.preco-total[1]:label  = return-value.
      {utp/ut-liter.i Desconto * L}
      assign item-doc-est.desconto[1]:label  = return-value.
      {utp/ut-liter.i Frete_Constante * L}
      assign item-doc-est.pr-total-cmi:label  = return-value.
      {utp/ut-liter.i Total_Despesas * L}
      assign item-doc-est.despesas[1]:label  = return-value.
  end.

  find first param-global no-lock no-error.
  find first param-compra no-lock no-error.        
  

  find param-re
      where param-re.usuario = c-seg-usuario no-lock no-error.

  find docum-est 
      where rowid(docum-est) = gr-docum-est no-lock no-error.

  if  avail docum-est then do:
      find emitente 
          where emitente.cod-emitente = docum-est.cod-emitente no-lock no-error.

      find natur-oper 
          where natur-oper.nat-operacao = docum-est.nat-operacao no-lock no-error.


/************ Aguardando a Implementaá∆o das Notas Fiscais de Sa°da ***********

      /* Remessa para Beneficiamento ou Saida de Transferencia */
      if  natur-oper.tp-oper-terc = 1         
      or ( natur-oper.tipo = 2 and natur-oper.transf ) then do:

          RUN Get-Field-Screen-Value IN adm-broker-hdl
              ( INPUT this-procedure,
                INPUT "it-codigo" ).

          find item
              where item.it-codigo = return-value no-lock no-error.

          find estab-mat where 
               estab-mat.cod-estabel = docum-est.cod-estabel no-lock no-error.

          find item-estab
              where item-estab.cod-estabel = estab-mat.cod-estabel
                and item-estab.it-codigo   = item.it-codigo   
              no-lock no-error.

          assign item-doc-est.preco-unit[1]:screen-value = 
                              if  param-re.preco-nft = 1
                              and avail item-estab   then
                                  /* Preco Medio */
                                  if  estab-mat.custo-contab = 1 /* mensal */ then
                                      string(  item-estab.val-unit-mat-m[1] 
                                             + item-estab.val-unit-mob-m[1]
                                             + item-estab.val-unit-ggf-m[1] )
                                  else
                                  if  estab-mat.usa-on-line then
                                      string(  item-estab.val-unit-mat-o[1]
                                             + item-estab.val-unit-mob-o[1] 
                                             + item-estab.val-unit-ggf-o[1] )
                                  else "0"
                              else 
                                  if  param-re.preco-nft = 2 then
                                      string(item.preco-ul-ent) /* Ultima Entrada */
                                  else 
                                      "0".        
      end.
****************************/      
  end.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-apos-preco V-table-Win 
PROCEDURE pi-apos-preco :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   /*  Ordem de Compra de Serviáo */
    def var de-preco-cc          as decimal no-undo.
    def var de-desconto-cc       as decimal no-undo.
    def var de-qtd-aux           as decimal no-undo.


    RUN Get-Field-Screen-Value IN adm-broker-hdl(INPUT this-procedure, INPUT "numero-ordem").           
    if int(return-value) <> 0 and 
       input frame {&frame-name} item-doc-est.qt-do-forn = 0 and
       input frame {&frame-name} item-doc-est.quantidade = 0 then do:
       find ordem-compra where ordem-compra.numero-ordem = int(return-value) no-lock no-error.
       if avail ordem-compra and
                ordem-compra.natureza = 2 then do:
          RUN Get-Field-Screen-Value IN adm-broker-hdl(INPUT this-procedure, INPUT "parcela").           
          find prazo-compra where
               prazo-compra.numero-ordem = ordem-compra.numero-ordem and
               prazo-compra.parcela = int(return-value) no-lock no-error.
          if avail prazo-compra then do:  
             run rep/re1908.p (rowid(ordem-compra),
                               docum-est.dt-emissao,
                               output de-preco-cc,  
                               output de-desconto-cc,
                               output de-taxa).

             if param-global.modulo-cn then do:
                run cnp/cn9060.p (&IF "{&bf_mat_versao_ems}":U >= "2.062":U &THEN
                                      INPUT 0,
                                  &ENDIF
                                  ?,
                                  ordem-compra.numero-ordem,
                                  0,
                                  no,
                                  input frame {&frame-name} item-doc-est.quantidade,
                                  docum-est.dt-emissao,
                                  output de-val-contrato,
                                  output de-val-aux,
                                  output de-val-formula,
                                  output de-val-aux).                          
                 if de-val-formula > 0 then
                      assign de-preco-cc = de-val-formula 
                             de-desconto   = 0.
                 else
                 if de-val-contrato > 0 then
                       assign de-preco-cc = de-val-contrato 
                              de-desconto   = 0.
             end.

             assign de-preco-t = de-preco-cc * prazo-compra.quantidade.


             assign item-doc-est.qt-do-forn:screen-value in frame {&frame-name} =
                       string(((input frame {&frame-name} item-doc-est.preco-total[1] -
                                input frame {&frame-name} item-doc-est.desconto[1]) *
                                prazo-compra.quantidade) / de-preco-t)

                    item-doc-est.quantidade:screen-value in frame {&frame-name} = 
                            string(input frame {&frame-name} item-doc-est.qt-do-forn / de-indice)
                    item-doc-est.preco-unit[1]:screen-value in frame {&frame-name} = 
                            string( input frame {&frame-name} item-doc-est.preco-total[1] /
                                  ( input frame {&frame-name} item-doc-est.qt-do-forn +
                                    int( input frame {&frame-name} item-doc-est.qt-do-forn = 0))).

             apply 'leave' to input frame {&frame-name} item-doc-est.quantidade.           
          end.        
       end.
    end.

    if  adm-new-record then do:

        if  natur-oper.transf = no then 
            assign item-doc-est.peso-liquido:screen-value in frame {&frame-name} =
                           string( if not l-servicos then
                                        input frame {&frame-name} item-doc-est.quantidade * item.peso-liquido
                                   else 0).

        run rep/re1001r.p (rowid(docum-est),
                           input frame {&frame-name} item-doc-est.preco-total[1],
                           3,
                           output de-despesa).                

        assign item-doc-est.despesas[1]:screen-value in frame {&frame-name} =
                                                     string(de-despesa).

        run rep/re1001r.p (rowid(docum-est),
                           (if param-re.rateia-frete = 1 then
                           input frame {&frame-name} item-doc-est.peso-liquido
                           else
                           input frame {&frame-name} item-doc-est.preco-total[1]),
                           2,
                           output de-frete).
        assign item-doc-est.pr-total-cmi:screen-value in frame {&frame-name} = 
            string(de-frete).
        assign item-doc-est.despesas[1]:screen-value in frame {&frame-name} = 
            string(de-despesa + de-frete).
    end.                           

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-ordem-cc V-table-Win 
PROCEDURE pi-atualiza-ordem-cc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param i-ordem-cc   like item-doc-est.numero-ordem no-undo.
    def input param i-parcela-cc like item-doc-est.parcela      no-undo.

    def var de-preco-cc          as decimal no-undo.
    def var de-desconto-cc       as decimal no-undo.
    def var de-qtd-aux           as decimal no-undo.

    assign i-numero-ordem = i-ordem-cc
           i-parcela      = i-parcela-cc.

    find ordem-compra 
        where ordem-compra.numero-ordem = i-ordem-cc no-lock no-error.

    if  avail ordem-compra then do:

        run pi-preco-ordem ( input ordem-compra.numero-ordem,
                             input frame {&frame-name} item-doc-est.quantidade,
                             output de-preco-cc,
                             output de-desconto-cc ).

        find item 
            where item.it-codigo = c-it-codigo no-lock no-error.

        if  item.tipo-contr = 4 then do:
            find cotacao-item
               where cotacao-item.cod-emitente = ordem-compra.cod-emitente
                 and cotacao-item.numero-ordem = ordem-compra.numero-ordem
                 and cotacao-item.data-cotacao = ordem-compra.data-cotacao
               no-lock no-error.

            if  adm-new-record
            and avail cotacao-item then
                assign item-doc-est.un:screen-value in frame {&frame-name} = cotacao-item.un.

        end.

        find item 
            where item.it-codigo = ordem-compra.it-codigo no-lock no-error.

        find prazo-compra 
            where prazo-compra.numero-ordem = ordem-compra.numero-ordem
              and prazo-compra.parcela      = i-parcela-cc no-lock no-error.

        if  avail prazo-compra then do: 

            /* Recalcula o indice para conversao da unidade de medida  */        
            /* quando a ordem de compra nao pertence ao item informado */
            /* ou o item da ordem for igual a branco.                  */

            if  docum-est.mod-atual = 1   /* Indica Nota de Material Agregado */
            and (   c-it-codigo <> ordem-compra.it-codigo
                 or ordem-compra.it-codigo = " " )
            then
                assign de-indice = prazo-compra.qtd-sal-forn
                                 / prazo-compra.quant-saldo.

            assign de-qtd-aux = prazo-compra.quant-saldo 
                              - prazo-compra.dec-1
                              + prazo-compra.quant-rejei  /*Descontando a quantidade devolvida*/
                   de-qtd-aux = if  de-qtd-aux < 0 then 0 
                                else de-qtd-aux
                   item-doc-est.qt-do-forn:screen-value in frame {&frame-name} =
                                       string( de-qtd-aux * de-indice )

                   de-qtd-aux = if  item.fraciona then de-qtd-aux
                                else truncate( de-qtd-aux, 0 )

                   item-doc-est.quantidade:screen-value in frame {&frame-name} =
                                        string( de-qtd-aux ).
        end.

        assign i-total = 0.

        /* Inicio validacao contrato - So para buscar a quantidade */         
        &if defined(bf_mat_contratos) &then
        if  avail ordem-compra and ordem-compra.nr-contrato <> 0
        &else
        if  avail ordem-compra and ordem-compra.nr-contrato <> " "
        &endif
        and param-global.modulo-cn then do:

            assign i-evento = 0.
            RUN Get-Field-Screen-Value IN adm-broker-hdl(INPUT this-procedure, INPUT "int-1").           
            assign i-evento = int(return-value).

            run cnp/cn9174.p ( ordem-compra.numero-ordem,
                               2,
                               i-evento,
                               0,
                               docum-est.dt-emissao,
                               output de-qtd-max,
                               output l-erro-co,
                               output l-contrato,
                               output i-total,
                               input-output table tt-erro).


            if  l-contrato = yes then do:
                if  de-qtd-max > 0 then
                    assign item-doc-est.qt-do-forn:screen-value in frame {&frame-name} =
                                string(de-qtd-max).
                else if  l-contrato then do:
                         assign item-doc-est.qt-do-forn:screen-value in frame {&frame-name} = string (0)
                                de-qtd-max = 0.
                      end.
            end.

        end.       

        assign de-qtd-aux =(input frame {&frame-name} item-doc-est.qt-do-forn +
                            int(input frame {&frame-name} item-doc-est.qt-do-forn = 0))

               item-doc-est.preco-unit[1]:screen-value in frame {&frame-name} = string(de-preco-cc)
               item-doc-est.desconto[1]:screen-value in frame {&frame-name} = 
                                       string(de-desconto-cc * de-qtd-aux).



        if i-total = 1 then  /*Quando ordem possui contrato e este Ç por total contratado*/
           assign item-doc-est.preco-total[1]:screen-value in frame {&frame-name} = 
                                     string(de-preco-cc).

        else
           assign item-doc-est.preco-total[1]:screen-value in frame {&frame-name} = 
                                     string(de-preco-cc * de-qtd-aux ).


        /* Atualiza Despesas Constantes do Item */                                       
        run pi-apos-preco.                                       


        if  valid-handle(h_b03in367) then
            run pi-dados-complement in h_b03in367 (input frame {&frame-name} item-doc-est.quantidade).
        if  valid-handle(h_v18in176) then
            run pi-calc-ipi in h_v18in176 (input input frame {&FRAME-NAME} item-doc-est.preco-total[1],
                                           input input frame {&FRAME-NAME} item-doc-est.desconto[1],
                                           input input frame {&FRAME-NAME} item-doc-est.despesas[1],
                                           input input frame {&FRAME-NAME} item-doc-est.pr-total-cmi).
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-un V-table-Win 
PROCEDURE pi-atualiza-un :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    assign c-un = if  avail item-fornec 
                  and not l-devolucao   then
                      item-fornec.unid-med-for
                  else 
                      if  avail item then 
                          item.un 
                      else 
                          " ".

    if  adm-new-record then 
        assign item-doc-est.un:screen-value in frame {&frame-name} = c-un.    

    assign c-un-aux = input frame {&frame-name} item-doc-est.un.

    if  not l-devolucao 
    and not l-retorno  then do:
        {cdp/cd9950.i c-un 
                      c-un-aux
                      docum-est.cod-emitente}
    end.
    else 
        assign de-indice = 1.

    if  de-indice = 0 or de-indice = ? then 
        assign de-indice = 1.                  

    assign item-doc-est.un:sensitive in frame {&frame-name} = (    avail item 
                                                               and item.tipo-contr = 4 
                                                               and not avail item-fornec ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-fisico V-table-Win 
PROCEDURE pi-fisico :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-internacional V-table-Win 
PROCEDURE pi-internacional :
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

    def input parameter p-handle-1   as handle no-undo.
    def input parameter p-handle-2   as handle no-undo.
    def input parameter p-handle-3   as handle no-undo.


    assign h_b03in367 = p-handle-1
           h_v18in176 = p-handle-2
           h_v16in176 = p-handle-3.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-passa-item V-table-Win 
PROCEDURE pi-passa-item :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter p-sequencia     like item-doc-est.sequencia no-undo.
    def input parameter p-it-codigo     like item.it-codigo         no-undo.

    assign c-it-codigo = p-it-codigo
           i-sequencia = p-sequencia.

    find item where item.it-codigo = c-it-codigo no-lock no-error.

    find item-fornec 
        where item-fornec.cod-emitente = docum-est.cod-emitente 
          and item-fornec.it-codigo    = c-it-codigo  no-lock no-error.

    run pi-atualiza-un.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-passa-quantidade V-table-Win 
PROCEDURE pi-passa-quantidade :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input parameter de-quant as decimal no-undo.
    assign item-doc-est.quantidade:screen-value in frame {&frame-name} =
        string(de-quant).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-passa-rateio V-table-Win 
PROCEDURE pi-passa-rateio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input parameter p-quantidade as decimal no-undo.
    def input parameter p-qt-do-forn as decimal no-undo.

    assign item-doc-est.quantidade:screen-value in frame {&frame-name} =
        string(p-quantidade).
    assign item-doc-est.qt-do-forn:screen-value in frame {&frame-name} = 
        string(p-qt-do-forn).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-preco-ordem V-table-Win 
PROCEDURE pi-preco-ordem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input  param i-ordem-cc           like ordem-compra.numero-ordem no-undo.
    def input  param de-quantidade        like item-doc-est.quantidade   no-undo.
    def output param de-preco-cc          as decimal                     no-undo.
    def output param de-desconto-cc       as decimal                     no-undo.


    find ordem-compra 
        where ordem-compra.numero-ordem = i-ordem-cc no-lock no-error.

    /*  C†lculo Preáo Unit†rio */
    run rep/re1908.p (rowid(ordem-compra),
                      docum-est.dt-emissao,
                      output de-preco-cc,  
                      output de-desconto-cc,
                      output de-taxa).

    if  param-global.modulo-cn then do:
        run cnp/cn9060.p (&IF "{&bf_mat_versao_ems}":U >= "2.062":U &THEN
                              INPUT 0,
                          &ENDIF
                          ?,
                          ordem-compra.numero-ordem,
                          0,
                          no,
                          de-quantidade,
                          docum-est.dt-emissao,
                          output de-val-contrato,
                          output de-val-aux,
                          output de-val-formula,
                          output de-val-aux).                          
        if  de-val-formula > 0 then
            assign de-preco-cc = de-val-formula 
                   de-desconto   = 0.
        else
           if  de-val-contrato > 0 then
               assign de-preco-cc = de-val-contrato 
                      de-desconto = 0.
    end.       

    assign de-vl-merc-liq = de-preco-cc - de-desconto-cc.                                       


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-quant-maxima V-table-Win 
PROCEDURE pi-quant-maxima :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    find prazo-compra
        where prazo-compra.numero-ordem = i-numero-ordem
          and prazo-compra.parcela      = i-parcela
        exclusive-lock no-error.

    find ordem-compra
        where ordem-compra.numero-ordem = i-numero-ordem no-lock no-error.

/*   if  avail ordem-compra and ordem-compra.nr-contrato <> " "
 *     and param-global.modulo-cn then do:
 *         run cnp/cn9074.p (i-numero-ordem,
 *                           2,
 *                           0,
 *                           input frame {&frame-name} item-doc-est.quantidade,
 *                           docum-est.dt-emissao,
 *                           output de-val-aux,
 *                           output l-erro-co,
 *                           output l-contrato,
 *                           input-output table tt-erro).
 *  
 *         if not l-erro-co then
 *             assign de-qtd-max = input frame {&frame-name} item-doc-est.quantidade.
 *     end.
 *  */ 
    if not l-contrato then
        assign de-qtd-max = prazo-compra.quant-saldo - prazo-compra.dec-1.

    run pi-variacao-quant (de-qtd-max,
                           output de-qtd-max).

    run rep/re9995.p (rowid(docum-est),
                      de-qtd-max,
                      input frame {&frame-name} item-doc-est.quantidade,
                      19,
                      not (input frame {&frame-name} item-doc-est.quantidade > de-qtd-max),
                      i-sequencia,
                      2).

    /*run pi-aloca-ordem-compra(yes).*/


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recebimento V-table-Win 
PROCEDURE pi-recebimento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    run pi-seta-flags-observacao (docum-est.cod-observa, 
                                  docum-est.nat-operacao).

    assign l-pede-qtd   = (not docum-est.rec-fisico and ( not natur-oper.terceiros or natur-oper.tp-oper-terc <> 6))
           l-pede-peso  = (not l-servicos)
           l-pede-valor = param-re.pd-despesa.

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

    def var i-ordem-aux     like ordem-compra.numero-ordem no-undo.
    def var i-parc-aux      like prazo-compra.parcela      no-undo.

    {cpp/cpapi029.i}

     RUN Get-Field-Screen-Value IN adm-broker-hdl
       ( INPUT this-procedure,
         INPUT "numero-ordem" ).
     assign i-ordem-aux = int(return-value).         

     RUN Get-Field-Screen-Value IN adm-broker-hdl
       ( INPUT this-procedure,
         INPUT "parcela" ).
     assign i-parc-aux = int(return-value).         

    find item where item.it-codigo = c-it-codigo no-lock no-error.

    find familia
        where familia.fm-codigo = item.fm-codigo no-lock no-error.

    if  available natur-oper then 
        /* Indica se Altera valor do itens em operacao com terceiros */
        assign l-alter-itens = int(substr(natur-oper.char-2,36,5)) = 1.



    if  l-pede-qtd then do:   
        if  l-retorno  and 
            not adm-new-record then do:
            find saldo-terc where
                 saldo-terc.cod-emitente = docum-est.cod-emitente  and
                 saldo-terc.nro-docto    = item-doc-est.nro-comp   and
                 saldo-terc.serie-docto  = item-doc-est.serie-comp and 
                 saldo-terc.nat-operacao = item-doc-est.nat-comp   and 
                 saldo-terc.it-codigo    = item-doc-est.it-codigo  and 
                 saldo-terc.cod-refer    = item-doc-est.cod-refer  and 
                 saldo-terc.sequencia    = item-doc-est.seq-comp   
                 no-lock no-error.
            if avail saldo-terc then do: 
                if input frame {&frame-name} item-doc-est.quantidade > (saldo-terc.quantidade - saldo-terc.dec-1 + item-doc-est.quantidade) then do:
                    /* mensagem: Quantidade superior ao saldo em poder de terceiros */
                    {include/i-vldprg.i}
                    run utp/ut-msgs.p (input "show",input 15192,input " ").
                    apply 'entry' to item-doc-est.quantidade in frame {&frame-name}.
                    return 'adm-error':U.
                end.
            end.
        end.
        if  item.fraciona = no 
        and integer( input frame {&frame-name} item-doc-est.quantidade) <>
                     input frame {&frame-name} item-doc-est.quantidade then do:
            /* mensagem: Quantidade n∆o pode ser fracionada */
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",input 1892,input " ").
            apply 'entry' to item-doc-est.quantidade in frame {&frame-name}.
            return 'adm-error':U.
        end.
        if  (not available natur-oper 
        or  (natur-oper.terceiros and natur-oper.tp-oper-terc <> 6)) 
        and  input frame {&frame-name} item-doc-est.quantidade = 0 then do:
            /* mensagem: Quantidade deve ser diferente de zero */
            {include/i-vldprg.i}
            {utp/ut-liter.i Quantidade * L}
            run utp/ut-msgs.p (input "show",input 1491,input return-value).
            apply 'entry' to item-doc-est.quantidade in frame {&frame-name}.
            return 'adm-error':U.
        end.

        if  not adm-new-record and avail item-doc-est and l-devolucao then do:
            {rep/re1001.i04 docum-est.cod-estabel
                            item-doc-est.serie-comp
                            item-doc-est.nro-comp
                            item-doc-est.it-codigo
                            item-doc-est.seq-comp}

            if  de-qtd-max <> ?                             
            and input frame {&frame-name} item-doc-est.quantidade > de-qtd-max then do:        
                /* mensagem: Quantidade devolvida maior que quantidade faturada */
                {include/i-vldprg.i}
                run utp/ut-msgs.p (input "show",input 15024,input " ").
                apply 'entry' to item-doc-est.quantidade in frame {&frame-name}.
                return 'adm-error':U.
            end.
        end.            
    end.

    if  input frame {&frame-name} item-doc-est.un <> c-un 
    and (available item-fornec or item.tipo-contr <> 4) then do:            
        /* mensagem: Unidade de medida n∆o confere */
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show",input 7346,input " ").
        apply 'entry' to item-doc-est.un in frame {&frame-name}.
        return 'adm-error':U.
    end.

    if  not available natur-oper 
    or  ( ( natur-oper.tp-oper-terc <> 2 AND natur-oper.tp-oper-terc <> 9 AND natur-oper.tp-oper-terc <> 11
    and     natur-oper.tp-oper-terc <> 4 
    and     natur-oper.tp-oper-terc <> 5) 
    or    l-alter-itens) then do:

        if  input frame {&frame-name} item-doc-est.preco-total[1] = 0 
        and input frame {&frame-name} item-doc-est.quantidade <> 0 then do:
            /* mensagem: Preco total deve ser diferente de zero */
            {include/i-vldprg.i}
            {utp/ut-liter.i Preco_Total * L}
            run utp/ut-msgs.p (input "show",input 1491,input return-value).
            apply 'entry' to item-doc-est.preco-total[1] in frame {&frame-name}.
            return 'adm-error':U.
        end.
        if  input frame {&frame-name} item-doc-est.qt-do-forn <> 0 then do:
            assign de-val-aux = round(input frame {&frame-name} item-doc-est.preco-unit[1] *
                                      input frame {&frame-name} item-doc-est.qt-do-forn, 2).
            if  de-val-aux <> input frame {&frame-name} item-doc-est.preco-total[1] 
            and param-re.preco-unit then do:
                /* mensagem: Preco total n∆o confere com calculado. Confirma? */
                {include/i-vldprg.i}
                run utp/ut-msgs.p (input "show",input 15193,input " ").
                if  return-value <> "yes" then do:                                   
                    apply 'entry' to item-doc-est.un in frame {&frame-name}.
                    return 'adm-error':U.
                end.
                assign item-doc-est.preco-unit[1]:screen-value in frame {&frame-name} =
                            string(input frame {&frame-name} item-doc-est.preco-total[1] /
                                   input frame {&frame-name} item-doc-est.qt-do-forn ).

            end.
        end.                
    end.        


    if  i-ordem-aux <> 0 then do:
        /* Valor digitado no Item */
        assign de-vl-merc-liq-aux = input frame {&frame-name} item-doc-est.preco-total[1] 
                                  - input frame {&frame-name} item-doc-est.desconto[1].
        /* Preáo Total de Acordo com a Ordem de Compra */                                  
        assign de-vl-aux = de-vl-merc-liq * ( input frame {&frame-name} item-doc-est.qt-do-forn
                                          + int( input frame {&frame-name} item-doc-est.qt-do-forn = 0 )).

        &if defined(bf_mat_contratos) &then
        if  avail ordem-compra and ordem-compra.nr-contrato <> 0
        &else
        if  avail ordem-compra and ordem-compra.nr-contrato <> " "
        &endif
        and param-global.modulo-cn then do:
            run cnp/cn9174.p (i-ordem-aux,
                              3,
                              0,
                              de-vl-merc-liq-aux,
                              docum-est.dt-emissao,
                              output de-var-max-aux,
                              output l-erro-co,
                              output l-contrato,
                              output i-total,
                              input-output table tt-erro).

/*            if l-erro-co then
 *                undo, retry.*/    

            if l-contrato and i-total = 0 then 
               assign de-vl-aux = de-var-max-aux.

            if i-total = 1 or i-total = 2 then
               assign de-vl-aux = input frame {&frame-name} item-doc-est.preco-total[1].

            assign de-var-min = 0.                               
        end.


        run pi-variacao-valor ( input de-vl-aux,
                                output de-var-max,
                                output de-var-min).

        /*Contrato por Total Contratado o valor m†ximo Ç o saldo mais 
        a variaá∆o da familia*/
        if i-total = 1 or i-total = 2 then do:
           if param-re.aceita-var then 
              assign de-var-max = round(de-var-max-aux +
                              (de-var-max-aux * familia.var-pre-perm / 100), 2).
        end.


        if  de-vl-merc-liq-aux > de-var-max 
        or  de-vl-merc-liq-aux < de-var-min then do:

            if  param-re.aceita-var = no then do:                               
                /* mensagem: Valor l°quido fora da variacao permitida */
                {include/i-vldprg.i}
                run utp/ut-msgs.p (input "show",input 15195,input " ").
                apply 'entry' to item-doc-est.preco-unit[1] in frame {&frame-name}.
                return 'adm-error':U.
            end.
            /* mensagem: Valor l°quido fora da variacao permitida. Confirma? */
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",input 15196,input " ").
            if return-value <> "yes" then do:                                
                apply 'entry' to item-doc-est.preco-unit[1] in frame {&frame-name}.
                return 'adm-error':U.
            end.
        end.
        run rep/re9995.p (rowid(docum-est),
                          de-var-max,
                          de-vl-merc-liq-aux,
                          15196,
                          ( not (de-vl-merc-liq-aux > de-var-max or de-vl-merc-liq-aux < de-var-min)),
                          i-sequencia,
                          1).
    end.                                            
    if  l-retorno 
    and available natur-oper 
    and l-alter-itens then do:
        assign de-vl-merc-liq = input frame {&frame-name} item-doc-est.preco-total[1] 
                              - input frame {&frame-name} item-doc-est.desconto[1]
               de-var-max     = de-vl-merc-liq 
                              + (de-vl-merc-liq * natur-oper.dec-1 / 100)
               de-var-min     = de-vl-merc-liq 
                              - (de-vl-merc-liq * natur-oper.dec-1 / 100).
        if  de-vl-merc-liq > de-var-max 
        or  de-vl-merc-liq < de-var-min then do:                                
            /* mensagem: Valor l°quido nota terceiros fora da variaá∆o permitida */
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",input 15197,input " ").
            apply 'entry' to item-doc-est.preco-unit[1] in frame {&frame-name}.
            return 'adm-error':U.
        end.
    end.

    if  l-pede-qtd then do:

        if  i-ordem-aux <> 0 then do:
            find first prazo-compra where
                       prazo-compra.numero-ordem = i-ordem-aux and
                       prazo-compra.parcela = i-parc-aux no-error.
/*            if  avail ordem-compra and ordem-compra.nr-contrato <> " " 
 *             and param-global.modulo-cn then do:
 *                 run cnp/cn9074.p (i-ordem-aux,
 *                                   2,
 *                                   0,
 *                                   input frame {&frame-name} item-doc-est.quantidade,
 *                                   docum-est.dt-emissao,
 *                                   output de-qtd-max,
 *                                   output l-erro-co,
 *                                   output l-contrato,
 *                                   input-output table tt-erro).
 *  
 *                 assign de-qtd-max = de-qtd-max 
 *                                   + if  param-re.aceita-var then 
 *                                         round( de-qtd-max * familia.var-qtd-perm / 100, 4 )
 *                                     else 0.
 *             end.*/

            if  not adm-new-record then 
                assign de-qtd-aux = if  i-numero-ordem = i-ordem-aux
                                    and i-parcela      = i-parc-aux then 
                                        item-doc-est.quantidade
                                    else 0.
            else 
                assign de-qtd-aux = 0.


            if  not l-contrato then 
                assign de-qtd-max = prazo-compra.quant-saldo - prazo-compra.dec-1.


            assign de-qtd-max = de-qtd-max + de-qtd-aux.

            run pi-variacao-quant (de-qtd-max,
                                   output de-qtd-max).


            if  input frame {&frame-name} item-doc-est.quantidade > de-qtd-max 
            or (de-qtd-max = 0 and l-contrato) then do:                                    
                if  param-re.aceita-var = no then do:                               
                    /* mensagem: Quantidade fora da variacao permitida */
                    {include/i-vldprg.i}
                    run utp/ut-msgs.p (input "show",input 5928,input " ").
                    apply 'entry' to item-doc-est.quantidade in frame {&frame-name}.
                    return 'adm-error':U.
                end.
                /* mensagem: Quantidade fora da variacao permitida. Confirma? */
                {include/i-vldprg.i}
                run utp/ut-msgs.p (input "show",input 5698,input " ").
                if  return-value <> "yes" then do:                                
                    apply 'entry' to item-doc-est.quantidade in frame {&frame-name}.
                    return 'adm-error':U.
                end.
            end.
            run rep/re9995.p (rowid(docum-est),
                              de-qtd-max,
                              input frame {&frame-name} item-doc-est.quantidade,
                              5698,
                              not (input frame {&frame-name} item-doc-est.quantidade > de-qtd-max),
                              i-sequencia,
                              1).
        end.
    end.

    if  param-re.pd-despesa then do:
        if input frame {&frame-name} item-doc-est.despesas[1] <
           input frame {&frame-name} item-doc-est.pr-total-cmi then do:
            /* mensagem: Total despesas nao pode ser inferior ao frete */
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",input 1598,input " ").
            apply 'entry' to item-doc-est.despesas[1] in frame {&frame-name}.
            return 'adm-error':U.
        end.
    end.            
    find first tt-erro 
        no-lock no-error.
    if available tt-erro then do:
        /* mensagem: Erro da tt-erro */
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show",input tt-erro.cd-erro,input " ").
        for each tt-erro:
            delete tt-erro.
        end.
        apply 'entry' to item-doc-est.qt-do-forn in frame {&frame-name}.
        return 'adm-error':U.
    end.     
    if  not adm-new-record 
    and i-ordem-aux = 0 
    and avail item-doc-est 
    and not natur-oper.terceiros 
    and not natur-oper.transf 
    and docum-est.cod-observa <> 3 then do:
        assign de-qtd-aux = 0.
        for each rat-ordem {cdp/cd8900.i rat-ordem item-doc-est} 
             and rat-ordem.sequencia = item-doc-est.sequencia no-lock:
            assign de-qtd-aux = de-qtd-aux + rat-ordem.quantidade.
        end.

        if  not docum-est.rec-fisico and
            de-qtd-aux > input frame {&frame-name} item-doc-est.quantidade then do:
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",input 15455,input " ").
            apply 'entry' to item-doc-est.quantidade in frame {&frame-name}.
            return 'adm-error':U.
        end.            
    end.

    RUN Get-Field-Screen-Value IN adm-broker-hdl
       ( INPUT this-procedure,
         INPUT "nr-ord-prod" ).
    assign i-nr-ord-prod = int(return-value).     

    if  i-nr-ord-prod <> 0 then do:
        find ord-prod
            where ord-prod.nr-ord-produ = i-nr-ord-prod no-lock no-error.

        find lin-prod 
            where lin-prod.cod-estabel = ord-prod.cod-estabel
              and lin-prod.nr-linha    = ord-prod.nr-linha no-lock no-error.
        


        if  avail lin-prod
        and lin-prod.sum-requis = 2          /* Processo Serviáo */
        and item.tipo-requis    = 1          /* Tipo Req Normal  */
        and input frame {&frame-name} item-doc-est.quantidade <> 0 then do:

            IF NOT VALID-HANDLE(h-cpapi029) THEN
                RUN cpp/cpapi029.p PERSISTENT SET h-cpapi029.

            RUN pi-execute IN h-cpapi029 (INPUT 2,
                                          INPUT lin-prod.cod-estabel,
                                          INPUT lin-prod.nr-linha,
                                          OUTPUT c-dep-fabrica,
                                          OUTPUT d-var-rep       ,
                                          OUTPUT d-var-req-menor ,
                                          OUTPUT d-var-requis    ,
                                          OUTPUT d-var-transf   ,
                                          OUTPUT TABLE tt-erro). 


            RUN Get-Field-Screen-Value IN adm-broker-hdl
               ( INPUT this-procedure,
                 INPUT "item-pai" ).
            assign c-item-pai = return-value.

             RUN Get-Field-Screen-Value IN adm-broker-hdl
               ( INPUT this-procedure,
                 INPUT "cod-roteiro" ).
            assign c-cod-roteiro = return-value.    

             RUN Get-Field-Screen-Value IN adm-broker-hdl
               ( INPUT this-procedure,
                 INPUT "op-codigo" ).
            assign i-op-codigo = int(return-value).    

             find reservas
                where reservas.nr-ord-prod = i-nr-ord-prod
                  and reservas.it-codigo   = item.it-codigo
                  and reservas.item-pai    = c-item-pai
                  and reservas.cod-roteiro = c-cod-roteiro
                  and reservas.op-codigo   = i-op-codigo
                no-lock no-error.    

            if  avail reservas
            and d-var-requis < 999 then do:

                assign de-qtd-max = reservas.quant-orig
                                  + ( reservas.quant-orig * d-var-requis / 100 ).

                if  not(item.fraciona) then
                    assign de-qtd-max = truncate(de-qtd-max, 0 ).

                if (  input frame {&frame-name} item-doc-est.quantidade
                    + reservas.quant-atend ) > de-qtd-max then
                do:
                   {include/i-vldprg.i}
                   run utp/ut-msgs.p (input "show", input 1237, input " ").
                   apply 'entry' to item-doc-est.quantidade in frame {&frame-name}.
                   return 'adm-error':U.
                end.
            end.
        end.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-variacao-valor V-table-Win 
PROCEDURE pi-variacao-valor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param de-valor-orig like item-doc-est.preco-total[1].
    def output param de-valor-max like item-doc-est.preco-total[1].
    def output param de-valor-min like item-doc-est.preco-total[1].

    if param-re.aceita-var then
        assign de-valor-max = round(de-valor-orig +
                              (de-valor-orig * familia.var-pre-perm / 100), 2)
               de-valor-min = round(de-valor-orig -
                              (de-valor-orig * familia.var-pre-perm / 100), 2).
    else
        assign de-valor-max = de-valor-orig
               de-valor-min = de-valor-orig.

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


