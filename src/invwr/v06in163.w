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
{include/i-prgvrs.i V06IN163 2.00.00.072 } /*** "010072" 27/10/2023 09:45:06 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v06in163 MUT}
&ENDIF

    CREATE WIDGET-POOL.
    &Scop adm-attribute-dlg support/viewerd.w

    def var v-row-parent        as rowid    no-undo.
    def var l-pede-qtd          as logical  no-undo.
    def var l-pede-peso         as logical  no-undo.
    def var l-pede-valor        as logical  no-undo.

    def new global shared var gr-doc-fisico  as rowid   no-undo.

    def buffer b-it-doc-fisico for it-doc-fisico.

    {cdp/cdcfgmat.i}  /* pre-processadores */ 
    {rep/re1001.i07}
    {cdp/cd0666.i}
    {cdp/cd4329.i2}   /**  Aloca/Desaloca parcela de Compra    **/
    {bcp/bcapi011.i}  /**  temp-table tt-etq-item              **/ 
    {bcp/bcapi004.i}  /**  Definiá∆o da temp-table tt-prog-bc  **/



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
    def var de-dec-1           as decimal no-undo.
    def var de-vl-merc-liq-aux as decimal no-undo.
    def var de-var-min         as decimal no-undo.
    def var l-contrato         as logical no-undo.
    DEF VAR de-var-max         AS DECIMAL NO-UNDO.
    DEF VAR l-erro             AS LOGICAL NO-UNDO.
    def var l-erro-co          as logical no-undo.
    def var de-despesa         as decimal no-undo.    
    def var de-frete           as decimal no-undo.
    def var l-novo-reg         as logical no-undo.
    def var c-un-aux           as char    no-undo.
    def var h_b06in367         as handle  no-undo.
    def var h_v05in163         as handle  no-undo.
    def var hProgramZoom       as handle  no-undo.
    def var de-qt-aux          like  it-doc-fisico.quantidade  no-undo.
    def var i-sequencia        like  it-doc-fisico.sequencia   no-undo.
    def var l-erro-qtd         as logical no-undo.
    def var l-baixa-estoq      as logical no-undo.
    def var de-taxa            as decimal no-undo.
    def var de-vl-aux          as decimal no-undo.
    def var de-alocada         like saldo-terc.dec-1 no-undo.
    def var de-preco-t         as decimal no-undo.
    def var de-prop-fam        as decimal no-undo.
    def var i-ordem-aux        like item-doc-est.numero-ordem  no-undo.
    def var i-parc-aux         like item-doc-est.parcela       no-undo.
    def var i-ordem-desloca    like item-doc-est.numero-ordem  no-undo.
    def var i-parc-desloca     like item-doc-est.parcela       no-undo.
    def var l-multiplas-unidades  as log  no-undo.
    def var de-preco-tot-ant   as decimal no-undo.
    DEF VAR l-sem-pedido       AS LOGICAL NO-UNDO.

    DEF VAR l-desconto         AS LOG INITIAL YES   NO-UNDO.

    def new global shared var l-mudou-frete as logical  no-undo.
    def new global shared var l-mudou-frete1 as logical no-undo.
    def var vl-frete-aux like it-doc-fisico.vl-frete    no-undo.

    /*vari†vel l¢gica para testar se o bot‰es Inclui/Modifica/Elimina do programa B06IN367 devem ser habilitados*/
    def var l-habilita-botao   as logical no-undo.
    
    def temp-table tt-rat-lote no-undo like rat-lote.

    /* Def variaveis da variacao por familia ou item-uni estab */
    {rep/re1001.i09}
    
    DEF VAR h-bodi578  AS HANDLE NO-UNDO.
    
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
&Scoped-define EXTERNAL-TABLES it-doc-fisico
&Scoped-define FIRST-EXTERNAL-TABLE it-doc-fisico


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR it-doc-fisico.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS it-doc-fisico.qt-do-forn it-doc-fisico.un ~
it-doc-fisico.quantidade it-doc-fisico.preco-unit[1] ~
it-doc-fisico.preco-total[1] it-doc-fisico.desconto[1] ~
it-doc-fisico.peso-liquido it-doc-fisico.vl-frete it-doc-fisico.despesas[1] 
&Scoped-define ENABLED-TABLES it-doc-fisico
&Scoped-define FIRST-ENABLED-TABLE it-doc-fisico
&Scoped-Define ENABLED-OBJECTS rt-key rt-key-4 rt-key-5 
&Scoped-Define DISPLAYED-FIELDS it-doc-fisico.qt-do-forn it-doc-fisico.un ~
it-doc-fisico.quantidade it-doc-fisico.preco-unit[1] ~
it-doc-fisico.preco-total[1] it-doc-fisico.desconto[1] ~
it-doc-fisico.peso-liquido it-doc-fisico.vl-frete it-doc-fisico.despesas[1] 
&Scoped-define DISPLAYED-TABLES it-doc-fisico
&Scoped-define FIRST-DISPLAYED-TABLE it-doc-fisico
&Scoped-Define DISPLAYED-OBJECTS c-nossa-unid 

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

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-indice-conv V-table-Win 
FUNCTION fn-indice-conv RETURNS decimal
  ( input c-un-forn as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-nossa-unid AS CHARACTER FORMAT "x(3)":U 
     VIEW-AS FILL-IN 
     SIZE 5.14 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 34.14 BY 9.13.

DEFINE RECTANGLE rt-key-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 52 BY 4.

DEFINE RECTANGLE rt-key-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 52 BY 5.08.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     it-doc-fisico.qt-do-forn AT ROW 1.88 COL 15.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20.57 BY .88
     it-doc-fisico.un AT ROW 1.88 COL 38 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5.14 BY .88
     it-doc-fisico.quantidade AT ROW 2.88 COL 15.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20.57 BY .88
     c-nossa-unid AT ROW 2.88 COL 38 COLON-ALIGNED NO-LABEL
     it-doc-fisico.preco-unit[1] AT ROW 6.29 COL 15.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20.57 BY .88
     it-doc-fisico.preco-total[1] AT ROW 7.29 COL 15.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20.57 BY .88
     it-doc-fisico.desconto[1] AT ROW 8.29 COL 15.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20.57 BY .88
     it-doc-fisico.peso-liquido AT ROW 4 COL 65.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     it-doc-fisico.vl-frete AT ROW 5 COL 65.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     it-doc-fisico.despesas[1] AT ROW 6 COL 65.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     rt-key AT ROW 1.04 COL 53.57
     rt-key-4 AT ROW 1.04 COL 1
     rt-key-5 AT ROW 5.08 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.it-doc-fisico
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
         HEIGHT             = 9.17
         WIDTH              = 86.72.
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

/* SETTINGS FOR FILL-IN c-nossa-unid IN FRAME f-main
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

&Scoped-define SELF-NAME it-doc-fisico.desconto[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.desconto[1] V-table-Win
ON ENTRY OF it-doc-fisico.desconto[1] IN FRAME f-main /* Desconto[1] */
DO:

    assign it-doc-fisico.desconto[1]:modified in frame {&FRAME-NAME} = no.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.desconto[1] V-table-Win
ON LEAVE OF it-doc-fisico.desconto[1] IN FRAME f-main /* Desconto[1] */
DO:

    if it-doc-fisico.desconto[1]:modified in frame {&FRAME-NAME} then do:
        run pi-apos-preco.
    end.                                 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME it-doc-fisico.despesas[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.despesas[1] V-table-Win
ON LEAVE OF it-doc-fisico.despesas[1] IN FRAME f-main /* Despesas[1] */
DO:

    assign it-doc-fisico.despesas[1]:modified in frame {&FRAME-NAME} = no.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME it-doc-fisico.preco-total[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.preco-total[1] V-table-Win
ON ENTRY OF it-doc-fisico.preco-total[1] IN FRAME f-main /* Preáo Total[1] */
DO:
   assign it-doc-fisico.preco-total[1]:modified in frame {&FRAME-NAME} = no.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.preco-total[1] V-table-Win
ON LEAVE OF it-doc-fisico.preco-total[1] IN FRAME f-main /* Preáo Total[1] */
DO:
    if it-doc-fisico.preco-total[1]:modified in frame {&FRAME-NAME} then do:
        if  input frame {&frame-name} it-doc-fisico.qt-do-forn = 0 THEN DO:
            assign it-doc-fisico.preco-unit[1]:screen-value in frame {&frame-name} =
                string(input frame {&frame-name} it-doc-fisico.preco-total[1]).
        END.
        ELSE DO:
            assign it-doc-fisico.preco-unit[1]:screen-value in frame {&frame-name} =
                string(input frame {&frame-name} it-doc-fisico.preco-total[1] /
                       input frame {&frame-name} it-doc-fisico.qt-do-forn).
        END.

        if adm-new-record then do:

            IF  param-re.rateia-desc 
            AND l-desconto
            AND AVAILABLE doc-fisico THEN DO:

                run rep/re2001r.p (rowid(doc-fisico),
                                   input frame {&frame-name} it-doc-fisico.preco-total[1],
                                   1,
                                   output de-desconto).
                if  de-desconto <> 0 then 
                    assign it-doc-fisico.desconto[1]:screen-value in frame {&frame-name} =
                           string(de-desconto).

                ASSIGN l-desconto = NO.

            end.                
        end.
        run pi-apos-preco. 

    end.        

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME it-doc-fisico.preco-unit[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.preco-unit[1] V-table-Win
ON ENTRY OF it-doc-fisico.preco-unit[1] IN FRAME f-main /* Preáo Unit[1] */
DO:

    assign it-doc-fisico.preco-unit[1]:modified in frame {&FRAME-NAME} = no.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.preco-unit[1] V-table-Win
ON LEAVE OF it-doc-fisico.preco-unit[1] IN FRAME f-main /* Preáo Unit[1] */
DO:
    if it-doc-fisico.preco-unit[1]:modified in frame {&FRAME-NAME} 
    OR it-doc-fisico.qt-do-forn   :MODIFIED IN FRAME {&FRAME-NAME} then do:
        assign it-doc-fisico.preco-total[1]:screen-value in frame {&frame-name} =
            string(input frame {&frame-name} it-doc-fisico.preco-unit[1] *
                         (input frame {&frame-name} it-doc-fisico.qt-do-forn +
                         int(input frame {&frame-name} it-doc-fisico.qt-do-forn = 0))).
    
        if it-doc-fisico.preco-unit[1]:modified in frame {&FRAME-NAME} then do:
            assign it-doc-fisico.preco-total[1]:modified in frame {&FRAME-NAME} = yes.
            apply "leave" to it-doc-fisico.preco-total[1] in frame {&FRAME-NAME}.
        end.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME it-doc-fisico.qt-do-forn
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.qt-do-forn V-table-Win
ON ENTRY OF it-doc-fisico.qt-do-forn IN FRAME f-main /* Qtde Emitente */
DO:

    assign it-doc-fisico.qt-do-forn:modified in frame {&FRAME-NAME} = no.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.qt-do-forn V-table-Win
ON LEAVE OF it-doc-fisico.qt-do-forn IN FRAME f-main /* Qtde Emitente */
DO:
    DEFINE VARIABLE precoTotalAnterior AS DECIMAL  NO-UNDO.

    ASSIGN precoTotalAnterior = DECIMAL(INPUT FRAME {&FRAME-NAME} it-doc-fisico.preco-total[1]).

    if it-doc-fisico.qt-do-forn:modified in frame {&FRAME-NAME} then do:
        assign it-doc-fisico.quantidade:screen-value in frame {&frame-name} =
               string((input frame {&frame-name} it-doc-fisico.qt-do-forn / de-indice)).
        if item.fraciona = no then
            assign it-doc-fisico.quantidade:screen-value in frame {&frame-name} = 
                   string(truncate(input frame {&frame-name} it-doc-fisico.quantidade,0)).
        assign it-doc-fisico.preco-total[1]:screen-value in frame {&frame-name} =
            string(input frame {&frame-name} it-doc-fisico.preco-unit[1] *
                         (input frame {&frame-name} it-doc-fisico.qt-do-forn +
                         int(input frame {&frame-name} it-doc-fisico.qt-do-forn = 0))).
    end.                            


    if doc-fisico.tipo-nota = 2 then do:
        /**  Calcula quantidade maxima para devolucao cliente **/
        find it-nota-fisc where
            it-nota-fisc.cod-estabel = doc-fisico.cod-estabel and
            it-nota-fisc.serie       = c-serie-comp and
            it-nota-fisc.nr-nota-fis = doc-fisico.nro-docto and
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

    /**  Passa quantidade para o browse de estoque **/
    RUN pi-passa-qtd-estoque.

    RUN Get-Field-Screen-Value IN adm-broker-hdl(INPUT this-procedure, INPUT "numero-ordem").           
    IF INT(RETURN-VALUE) = 0 THEN DO: 
      IF it-doc-fisico.qt-do-forn:MODIFIED IN FRAME {&FRAME-NAME} THEN DO:
        APPLY "leave" TO it-doc-fisico.preco-unit[1] IN FRAME {&FRAME-NAME}.
        RUN pi-desconto (INPUT precoTotalAnterior).
      END.
    END.      
    ELSE DO:
      FIND ordem-compra WHERE
           ordem-compra.numero-ordem = INT(RETURN-VALUE) NO-LOCK NO-ERROR.
      IF AVAIL ordem-compra 
           AND ordem-compra.natureza <> 2 THEN DO:
        IF it-doc-fisico.qt-do-forn:MODIFIED IN FRAME {&FRAME-NAME} THEN DO:
          APPLY "leave" TO it-doc-fisico.preco-unit[1] IN FRAME {&FRAME-NAME}.
          RUN pi-desconto (INPUT precoTotalAnterior).
        END.
      END.
    END.
    
    IF doc-fisico.tipo-nota <> 3 AND item.peso-liquido <> 0  THEN
      ASSIGN it-doc-fisico.peso-liquido:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING( INPUT FRAME {&FRAME-NAME} it-doc-fisico.quantidade * item.peso-liquido ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME it-doc-fisico.quantidade
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.quantidade V-table-Win
ON LEAVE OF it-doc-fisico.quantidade IN FRAME f-main /* Nossa Qtde */
DO:
    
    if (doc-fisico.tipo-nota = 5 or doc-fisico.tipo-nota = 8) or
        (doc-fisico.tipo-nota = 2 and de-prop-fam = 1) or  
        (param-re.pede-quant and doc-fisico.tipo-nota <> 2) then
        assign it-doc-fisico.qt-do-forn:screen-value in frame {&frame-name} = string(input frame {&frame-name} it-doc-fisico.quantidade * de-indice).

    /**  Passa quantidade para o browse de estoque 
    **/        
    run pi-passa-qtd-estoque.

    /**  consistencia do coleta de dados 
    **/
    find first param-global 
        no-lock no-error.

    if avail param-global and 
        param-global.modulo-cl then do:

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
                   tt-etq-item.qt-item   = if avail it-doc-fisico 
                                           then dec(it-doc-fisico.quantidade:screen-value in frame {&frame-name})
                                           else 0
                   tt-etq-item.cd-trans  = if avail tt-prog-bc then tt-prog-bc.cd-trans else "".

            run bcp/bcapi011.p (input-output table tt-etq-item).

            find first tt-etq-item 
                no-error. 
            run pi-muda-qt-etiqueta in h_v05in163 ( input ( if  return-value = "OK" 
                                                            and avail tt-etq-item 
                                                            then tt-etq-item.qt-etiqueta 
                                                            else 0) ).
        end.    
    end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME it-doc-fisico.un
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.un V-table-Win
ON F5 OF it-doc-fisico.un IN FRAME f-main /* Un */
OR "MOUSE-SELECT-DBLCLICK":U OF it-doc-fisico.un IN FRAME f-main
DO:
  /*--- ZOOM SMART OBJECT ---*/ 
    if l-multiplas-unidades then do:
        {method/zoomfields.i &ProgramZoom="inzoom/z03in417.w"
                             &FieldZoom1="un"
                             &FieldScreen1="it-doc-fisico.un"
                             &Frame1="f-main"
                             &RunMethod="Run setParameters in hProgramZoom (INPUT doc-fisico.cod-emitente,
                                                                            INPUT c-it-codigo)."
                             &EnableImplant="NO"}
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.un V-table-Win
ON leave OF it-doc-fisico.un IN FRAME f-main /* Un */
DO: 
    IF  NOT AVAIL it-doc-fisico
    AND INPUT FRAME {&FRAME-NAME} it-doc-fisico.qt-do-forn <> DEC(it-doc-fisico.qt-do-forn:SCREEN-VALUE IN FRAME {&FRAME-NAME})
    OR  INPUT FRAME {&FRAME-NAME} it-doc-fisico.un         <> SELF:SCREEN-VALUE IN FRAME {&FRAME-NAME} THEN DO:
        assign de-indice = fn-indice-conv(input frame f-main it-doc-fisico.un)
               it-doc-fisico.quantidade:screen-value in frame {&frame-name} = string((input frame {&frame-name} it-doc-fisico.qt-do-forn / de-indice)).
        if item.fraciona = no then
            assign it-doc-fisico.quantidade:screen-value in frame {&frame-name} = string(truncate(input frame {&frame-name} it-doc-fisico.quantidade,0)).
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME it-doc-fisico.vl-frete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.vl-frete V-table-Win
ON ENTRY OF it-doc-fisico.vl-frete IN FRAME f-main /* Valor Frete */
DO:

    assign vl-frete-aux = input frame {&FRAME-NAME} it-doc-fisico.vl-frete
           it-doc-fisico.vl-frete:modified in frame {&FRAME-NAME} = no.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.vl-frete V-table-Win
ON LEAVE OF it-doc-fisico.vl-frete IN FRAME f-main /* Valor Frete */
DO:

    assign vl-frete-aux = input frame {&FRAME-NAME} it-doc-fisico.vl-frete.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF         

    {utp/ut-liter.i Preáo_Unit MRE L}  
    assign it-doc-fisico.preco-unit[1]:label in frame {&FRAME-NAME}  = return-value.

    {utp/ut-liter.i Preáo_Total MRE L}
        
    assign it-doc-fisico.preco-total[1]:label in frame {&FRAME-NAME}  = return-value.

    {utp/ut-liter.i Desconto MRE L}  
    assign it-doc-fisico.desconto[1]:label in frame {&FRAME-NAME}  = return-value.

    {utp/ut-liter.i Despesas MRE L}  
    assign it-doc-fisico.despesas[1]:label in frame {&FRAME-NAME}  = return-value.

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
  {src/adm/template/row-list.i "it-doc-fisico"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "it-doc-fisico"}

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

    {include/i-valid.i}

    if adm-new-record = no then
        assign de-qt-aux = it-doc-fisico.quantidade.
    else 
        assign de-qt-aux   = 0
               i-ordem-aux = 0
               i-parc-aux  = 0.

    if  avail it-doc-fisico then 
        assign vl-frete-aux = input frame {&frame-name} it-doc-fisico.vl-frete.

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.

    if  avail it-doc-fisico and
        vl-frete-aux <> it-doc-fisico.vl-frete then
        assign l-mudou-frete = yes.

    assign it-doc-fisico.cod-emitente = doc-fisico.cod-emitente
           it-doc-fisico.nro-docto    = doc-fisico.nro-docto
           it-doc-fisico.serie-docto  = doc-fisico.serie-docto.

    assign it-doc-fisico.dec-1 = de-dec-1
           l-novo-reg = no.

    IF doc-fisico.tipo-nota = 5   /*Retorno Benef*/ 
    OR doc-fisico.tipo-nota = 7   /*Fatura Consig*/
    OR doc-fisico.tipo-nota = 8   /*Devoluá∆o Consig*/
    OR doc-fisico.tipo-nota = 10  /* Remessa Entrega Futura*/
    OR doc-fisico.tipo-nota = 13  /*Retorno Dep Fechado*/
    OR doc-fisico.tipo-nota = 15 THEN DO:  /*Retorno Armaz Geral*/
        /**  Atualiza quantidade alocada no saldo terceiros - cd4326.i1 
        **/
        find saldo-terc where
             saldo-terc.cod-emitente = doc-fisico.cod-emitente  and
             saldo-terc.nro-docto    = it-doc-fisico.nro-comp   and
             saldo-terc.serie-docto  = it-doc-fisico.serie-comp and 
             saldo-terc.it-codigo    = it-doc-fisico.it-codigo  and 
             saldo-terc.nat-operacao = it-doc-fisico.nat-comp   and
             saldo-terc.cod-refer    = it-doc-fisico.cod-refer  and 
             saldo-terc.sequencia    = it-doc-fisico.seq-comp   
             exclusive-lock no-error.
                         
        if avail saldo-terc then 
            assign saldo-terc.dec-1 = saldo-terc.dec-1 + it-doc-fisico.quantidade - de-qt-aux
                   saldo-terc.dec-1 = if  saldo-terc.dec-1 < 0 then 0 
                                      else saldo-terc.dec-1.

        FOR EACH tt-rat-lote NO-LOCK 
           WHERE tt-rat-lote.serie-docto  = it-doc-fisico.serie-docto
             AND tt-rat-lote.nro-docto    = it-doc-fisico.nro-docto
             AND tt-rat-lote.cod-emitente = it-doc-fisico.cod-emitente                
             AND tt-rat-lote.nat-operacao = ""                                     
             AND tt-rat-lote.tipo-nota    = doc-fisico.tipo-nota 
             AND tt-rat-lote.sequencia    = it-doc-fisico.sequencia 
             AND tt-rat-lote.int-2       <> 3 :
            /*desalocando o saldo */
            FOR EACH rat-saldo-terc EXCLUSIVE-LOCK
               WHERE rat-saldo-terc.serie-docto  = it-doc-fisico.serie-comp    
                 AND rat-saldo-terc.nro-docto    = it-doc-fisico.nro-comp      
                 AND rat-saldo-terc.cod-emitente = it-doc-fisico.cod-emitente   
                 AND rat-saldo-terc.nat-operacao = it-doc-fisico.nat-comp  
                 AND rat-saldo-terc.it-codigo    = it-doc-fisico.it-codigo 
                 AND rat-saldo-terc.cod-refer    = it-doc-fisico.cod-refer  
                 AND rat-saldo-terc.sequencia    = it-doc-fisico.seq-comp
                 AND rat-saldo-terc.lote         = tt-rat-lote.lote 
                 AND rat-saldo-terc.cod-estabel  = doc-fisico.cod-estabel:
                     
                  ASSIGN rat-saldo-terc.qtd-aloc-trans = rat-saldo-terc.qtd-aloc-trans - tt-rat-lote.quantidade
                          rat-saldo-terc.qtd-aloc-trans = if rat-saldo-terc.qtd-aloc-trans < 0 then 0 
                                                         else rat-saldo-terc.qtd-aloc-trans.
                     
            END.   
        END.
        
        FOR EACH rat-lote  NO-LOCK
           WHERE rat-lote.cod-emitente = it-doc-fisico.cod-emitente
             AND rat-lote.serie-docto  = it-doc-fisico.serie-docto
             AND rat-lote.nro-docto    = it-doc-fisico.nro-docto
             AND rat-lote.sequencia    = it-doc-fisico.sequencia:

            FOR EACH rat-saldo-terc EXCLUSIVE-LOCK
               WHERE rat-saldo-terc.serie-docto  = it-doc-fisico.serie-comp    
                 AND rat-saldo-terc.nro-docto    = it-doc-fisico.nro-comp      
                 AND rat-saldo-terc.cod-emitente = it-doc-fisico.cod-emitente   
                 AND rat-saldo-terc.nat-operacao = it-doc-fisico.nat-comp  
                 AND rat-saldo-terc.it-codigo    = it-doc-fisico.it-codigo 
                 AND rat-saldo-terc.cod-refer    = it-doc-fisico.cod-refer  
                 AND rat-saldo-terc.sequencia    = it-doc-fisico.seq-comp
                 AND rat-saldo-terc.lote         = rat-lote.lote 
                 AND rat-saldo-terc.cod-estabel  = doc-fisico.cod-estabel:  
                 
                 /*alocando o saldo*/
                 ASSIGN  rat-saldo-terc.qtd-aloc-trans = rat-saldo-terc.qtd-aloc-trans + rat-lote.quantidade. 
            END.
        END.
    END.

    if it-doc-fisico.fifo-oc = yes and adm-new-record then 
        run rep/re2001p.p (input rowid(it-doc-fisico)).

    assign l-erro-qtd = no.

    RUN executarEngineRecSemPedido.

    if not l-sem-pedido and 
        it-doc-fisico.fifo-oc then do:

        assign de-qtd-aux = 0.

        for each rat-ordem 
            use-index documento where
            rat-ordem.serie-docto   = it-doc-fisico.serie-docto  and
            rat-ordem.nro-docto     = it-doc-fisico.nro-docto    and
            rat-ordem.cod-emitente  = it-doc-fisico.cod-emitente and
            rat-ordem.tipo-nota     = it-doc-fisico.tipo-nota and
            rat-ordem.nat-operacao  = "" and
            rat-ordem.sequencia = it-doc-fisico.sequencia no-lock:
            assign de-qtd-aux = de-qtd-aux + rat-ordem.quantidade.
        end.

        if de-qtd-aux < it-doc-fisico.quantidade then 
            assign l-erro-qtd = yes.


        run rep/re8885.p ( rowid(doc-fisico),
                           de-qtd-aux,
                           it-doc-fisico.quantidade,
                           15455,
                           de-qtd-aux = it-doc-fisico.quantidade,
                           it-doc-fisico.sequencia,
                           1 ).

    end.      

    for each tt-erro:
        delete tt-erro.
    end.

    def var de-qtd-atual like it-doc-fisico.quantidade no-undo.
    assign de-qtd-atual = input frame {&FRAME-NAME} it-doc-fisico.quantidade.
    
    /* Se for remessa de faturamento antecipado:
       Atualiza a quantidade do documento a qtd-receb-fisic da sdo-fatur-antecip (bodi578) */
    IF doc-fisico.tipo-nota = 11 THEN DO:
        IF NOT VALID-HANDLE(h-bodi578) THEN
            RUN dibo/bodi578.p PERSISTENT SET h-bodi578.
        
        RUN atualizaSaldoFisicoItem IN h-bodi578 (input it-doc-fisico.seq-comp, /* ID do sdo-fatur-antecip */
                                                  input "",
                                                  input "",
                                                  input "",
                                                  input 0,
                                                  input "",
                                                  input "",
                                                  input 0,
                                                  input (de-qtd-atual - de-qt-aux)). /* de-qt-aux - Quantidade antes da atualizaá∆o */                                                       
        DELETE PROCEDURE h-bodi578.          
    END. 


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-cancel-record V-table-Win 
PROCEDURE local-cancel-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

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

    /*teste para desabilitar bot‰es Inclui/Modifica/Elimina no browser B06IN367 (p†gina Estoque)*/
    assign l-habilita-botao = no.
    if  valid-handle(h_b06in367) then
        run pi-habilita-botao in h_b06in367 (input l-habilita-botao).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

    /***
    if valid-handle(h_b03in367) and 
        not l-novo-reg then
        run pi-monta-sal-re in h_b03in367. ***/

   /* Mostrar Nossa Unidade de Medida */
   find doc-fisico 
        where rowid(doc-fisico) = gr-doc-fisico no-lock no-error.

   find item where item.it-codigo = it-doc-fisico.it-codigo no-lock no-error.
   find item-fornec 
        where item-fornec.cod-emitente = doc-fisico.cod-emitente 
        and item-fornec.it-codigo    = it-doc-fisico.it-codigo  no-lock no-error.

   if  not adm-new-record then do:
       if avail item                
       and item.tipo-contr = 4      
       and not avail item-fornec THEN DO:

           for first prazo-compra fields (numero-ordem un)
               where prazo-compra.numero-ordem = it-doc-fisico.numero-ordem
               AND   prazo-compra.parcela      = it-doc-fisico.parcela NO-LOCK:
           END.

           assign c-nossa-unid:screen-value in frame {&frame-name} = if avail prazo-compra
                                                                     then prazo-compra.un
                                                                     else if avail item 
                                                                     then item.un
                                                                     else "".
       END.
       else assign c-nossa-unid:screen-value in frame {&frame-name} = if  avail item 
                                                                   then item.un
                                                                   else " ".
   end.                          
   /* Mostrar Nossa Unidade de Medida */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

    RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "numero-ordem").
    assign i-numero-ordem = int(return-value).

    RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "parcela").
    assign i-parcela = int(return-value).

    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
    if adm-new-record = yes then
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif

    disable all with frame {&frame-name}.

    assign l-novo-reg = yes
           de-prop-fam    = 1.

    if adm-new-record = yes then do:
        &if  defined(ADM-MODIFY-FIELDS) &then
             enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
        &endif
    end. 
    else do:
        if avail it-doc-fisico then do:
            find it-nota-fisc where 
                it-nota-fisc.cod-estabel = doc-fisico.cod-estabel   and 
                it-nota-fisc.serie       = it-doc-fisico.serie-comp and 
                it-nota-fisc.nr-nota-fis = it-doc-fisico.nro-comp   and 
                it-nota-fisc.nr-seq-fat  = it-doc-fisico.seq-comp   and 
                it-nota-fisc.it-codigo   = it-doc-fisico.it-codigo 
                no-lock no-error.

            if  avail it-nota-fisc 
            and it-nota-fisc.ind-fat-qtfam then 
                assign de-prop-fam = it-nota-fisc.qt-faturada[2] / it-nota-fisc.qt-faturada[1].
        end.         
    end.                

    if avail it-doc-fisico then do:
        assign i-ordem-aux    = i-numero-ordem
               i-parc-aux     = i-parcela.

        find saldo-terc where 
            saldo-terc.cod-emitente = it-doc-fisico.cod-emitente and 
            saldo-terc.serie-docto  = it-doc-fisico.serie-comp   and 
            saldo-terc.nro-docto    = it-doc-fisico.nro-comp     and 
            saldo-terc.it-codigo    = it-doc-fisico.it-codigo    and 
            saldo-terc.nat-operacao = it-doc-fisico.nat-comp     and
            saldo-terc.sequencia    = it-doc-fisico.seq-comp     and 
            saldo-terc.cod-refer    = it-doc-fisico.cod-refer
            no-lock no-error.
    end.

    find item-fornec 
        where item-fornec.cod-emitente = doc-fisico.cod-emitente and 
        item-fornec.it-codigo    = c-it-codigo  
        no-lock no-error.

    run pi-recebimento.

    if doc-fisico.tipo-nota <> 3 then do:
        if l-pede-qtd then do:
            if ( doc-fisico.tipo-nota <> 2 or de-prop-fam <> 1 ) and 
                doc-fisico.tipo-nota <> 5 and
                doc-fisico.tipo-nota <> 8 then
                enable it-doc-fisico.qt-do-forn with frame {&frame-name}.

            enable it-doc-fisico.quantidade with frame {&frame-name}.
        end.

        if  not available natur-oper 
        or  not natur-oper.terceiros 
        or  natur-oper.auto-ce
        or ( natur-oper.tp-oper-terc <> 2 AND natur-oper.tp-oper-terc <> 9 AND natur-oper.tp-oper-terc <> 11
        and  natur-oper.tp-oper-terc <> 4 
        and  natur-oper.tp-oper-terc <> 5) then do:
            if  param-re.preco-unit then
                enable it-doc-fisico.preco-unit[1]  with frame {&frame-name}.
             enable it-doc-fisico.preco-total[1] with frame {&frame-name}.

            if param-re.pede-desc-it then
                enable it-doc-fisico.desconto[1]    with frame {&frame-name}.
        end.

        if  l-pede-valor then
            enable it-doc-fisico.vl-frete
                   it-doc-fisico.despesas[1] with frame {&frame-name}.

    end.

    if  l-pede-peso then
        enable it-doc-fisico.peso-liquido with frame {&frame-name}.

    /*teste para habilitar bot‰es Inclui/Modifica/Elimina no browser B06IN367 (p†gina Estoque)*/
    assign l-habilita-botao = yes.
    if  valid-handle(h_b06in367) then
        run pi-habilita-botao in h_b06in367 (input l-habilita-botao).
        
    IF AVAIL it-doc-fisico THEN DO:    
        IF  it-doc-fisico.nro-comp  <> ""
        AND (   doc-fisico.tipo-nota = 5   /*Retorno Benef*/ 
             OR doc-fisico.tipo-nota = 7   /*Fatura Consig*/
             OR doc-fisico.tipo-nota = 8   /*Devoluá∆o Consig*/
             OR doc-fisico.tipo-nota = 10  /* Remessa Entrega Futura*/
             OR doc-fisico.tipo-nota = 13  /*Retorno Dep Fechado*/
             OR doc-fisico.tipo-nota = 15) THEN DO:  /*Retorno Armaz Geral*/ 
        
            EMPTY TEMP-TABLE tt-rat-lote.    
            FOR EACH rat-lote 
                WHERE rat-lote.cod-emitente = doc-fisico.cod-emitente    
                AND   rat-lote.serie-docto  = doc-fisico.serie-docto     
                AND   rat-lote.nro-docto    = doc-fisico.nro-docto       
                AND   rat-lote.nat-operacao = ""                         
                AND   rat-lote.tipo-nota    = doc-fisico.tipo-nota 
                AND   rat-lote.sequencia    = it-doc-fisico.sequencia                
                AND   rat-lote.int-2        <> 3 NO-LOCK:
                CREATE tt-rat-lote.
                BUFFER-COPY rat-lote TO tt-rat-lote.
            END.             
        END.
    END.    
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-end-update V-table-Win 
PROCEDURE local-end-update :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

     /**  Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'end-update':U ) .

    if l-erro-qtd then do:
        /**  {include/i-vldprg.i} 
        **/
        run utp/ut-msgs.p (input "show",input 15455,input " ").
        apply 'entry' to it-doc-fisico.quantidade in frame {&frame-name}.
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

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

    if  not can-find(first it-doc-fisico of doc-fisico) then
        assign l-mudou-frete1 = yes.

    find doc-fisico where
        rowid(doc-fisico) = gr-doc-fisico
        no-lock no-error.

    if avail doc-fisico then do:
        find emitente where
            emitente.cod-emitente = doc-fisico.cod-emitente
            no-lock no-error.
    end.
    find param-re where
        param-re.usuario = c-seg-usuario
        no-lock no-error.        

    find first param-global
        no-lock no-error.

    find first param-compra
        no-lock no-error.   
    assign l-multiplas-unidades = avail param-compra and param-compra.log-multi-unid-medid.

    if l-multiplas-unidades then
        it-doc-fisico.un:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME f-main.

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
    /**  Ordem de Compra de Serviáo 
    **/
    def var de-preco-cc          as decimal no-undo.
    def var de-desconto-cc       as decimal no-undo.
    def var de-qtd-aux           as decimal no-undo.

    RUN Get-Field-Screen-Value IN adm-broker-hdl(INPUT this-procedure, INPUT "numero-ordem").           
    if int(return-value) <> 0 and 
        input frame {&frame-name} it-doc-fisico.qt-do-forn = 0 and
        input frame {&frame-name} it-doc-fisico.quantidade = 0 then do:

        find ordem-compra where 
            ordem-compra.numero-ordem = int(return-value) 
            no-lock no-error.
        if avail ordem-compra and
            ordem-compra.natureza = 2 then do:

            RUN Get-Field-Screen-Value IN adm-broker-hdl(INPUT this-procedure, INPUT "parcela").           
            find prazo-compra where
                prazo-compra.numero-ordem = ordem-compra.numero-ordem and
                prazo-compra.parcela = int(return-value) 
                no-lock no-error.
            if avail prazo-compra then do:  
                run rep/re1908.p (rowid(ordem-compra),
                                  doc-fisico.dt-emissao,
                                  output de-preco-cc,  
                                  output de-desconto-cc,
                                  output de-taxa).

                if param-global.modulo-cn then do:
                    RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "num-seq-event":U).

                    run cnp/cn9060.p (&IF "{&bf_mat_versao_ems}":U >= "2.062":U &THEN
                                          INPUT INTEGER(RETURN-VALUE),
                                      &ENDIF
                                      ?,
                                      ordem-compra.numero-ordem,
                                      0,
                                      no,
                                      input frame {&frame-name} it-doc-fisico.quantidade,
                                      doc-fisico.dt-emissao,
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

                assign it-doc-fisico.qt-do-forn:screen-value in frame {&frame-name} =
                           string(((input frame {&frame-name} it-doc-fisico.preco-total[1] -
                                    input frame {&frame-name} it-doc-fisico.desconto[1]) *
                                    prazo-compra.quantidade) / de-preco-t)
                        it-doc-fisico.quantidade:screen-value in frame {&frame-name} = 
                                string(input frame {&frame-name} it-doc-fisico.qt-do-forn / de-indice)
                        it-doc-fisico.preco-unit[1]:screen-value in frame {&frame-name} = 
                                string( input frame {&frame-name} it-doc-fisico.preco-total[1] /
                                  ( input frame {&frame-name} it-doc-fisico.qt-do-forn +
                                        int( input frame {&frame-name} it-doc-fisico.qt-do-forn = 0))).

                apply 'leave' to input frame {&frame-name} it-doc-fisico.quantidade.           
            end.        
        end.
    end.

    if adm-new-record then do:

        if doc-fisico.tipo-nota <> 3 
        AND item.peso-liquido <> 0  THEN
            assign it-doc-fisico.peso-liquido:screen-value in frame {&frame-name} =
                           string( input frame {&frame-name} it-doc-fisico.quantidade * item.peso-liquido ).

        run rep/re2001r.p (rowid(doc-fisico),
                           input frame {&frame-name} it-doc-fisico.preco-total[1],
                           3,
                           output de-despesa).                

        assign it-doc-fisico.despesas[1]:screen-value in frame {&frame-name} =
                                                     string(de-despesa).

        run rep/re2001r.p (rowid(doc-fisico),
                           (if param-re.rateia-frete = 1 then
                           input frame {&frame-name} it-doc-fisico.peso-liquido
                           else
                           input frame {&frame-name} it-doc-fisico.preco-total[1]),
                           2,
                           output de-frete).

        assign it-doc-fisico.vl-frete:screen-value in frame {&frame-name} = 
            string(de-frete).                           
        assign it-doc-fisico.despesas[1]:screen-value in frame {&frame-name} = 
            string(de-despesa + de-frete).

        IF  param-re.rateia-desc 
        AND l-desconto
        AND AVAILABLE doc-fisico THEN DO:

            run rep/re2001r.p (rowid(doc-fisico),
                               input frame {&frame-name} it-doc-fisico.preco-total[1],
                               1,
                               output de-desconto).
            if  de-desconto <> 0 then 
                assign it-doc-fisico.desconto[1]:screen-value in frame {&frame-name} =
                       string(de-desconto).

            ASSIGN l-desconto = NO.

        end.                

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

    def input param i-ordem-cc   like it-doc-fisico.numero-ordem no-undo.
    def input param i-parcela-cc like it-doc-fisico.parcela      no-undo.

    def var de-preco-cc          as decimal no-undo.
    def var de-desconto-cc       as decimal no-undo.
    def var de-qtd-aux           as decimal no-undo.

    /*Logica colocada para desalocar o saldo da ordem quando havia uma ordem relacionada 
      ao item na nota, mas a mesma foi zerada. Quando Ç alterado de uma ordem para outra, 
      o sistema j† realiza a desalocaá∆o em outro ponto*/
    IF  NOT adm-new-record AND 
       (i-numero-ordem <> 0 AND i-ordem-cc = 0) THEN
        ASSIGN i-ordem-desloca = i-numero-ordem
               i-parc-desloca  = i-parcela.

    assign i-numero-ordem = i-ordem-cc
           i-parcela      = i-parcela-cc.

    find ordem-compra 
        where ordem-compra.numero-ordem = i-ordem-cc no-lock no-error.

    if avail ordem-compra
    AND adm-new-record then do:
        /**   C†lculo Preáo Unit†rio 
        **/
        run rep/re1908.p (rowid(ordem-compra),
                          doc-fisico.dt-emissao,
                          output de-preco-cc,  
                          output de-desconto-cc,
                          output de-taxa).
        
        ASSIGN de-preco-cc = ROUND(de-preco-cc,5). /*feito o arrendondamento pois havia divergencia no calculo do valor total da OC, com o recebimento*/
        
        FIND FIRST item 
             WHERE item.it-codigo = ordem-compra.it-codigo NO-LOCK NO-ERROR.

        IF  param-global.modulo-cn        AND
            ordem-compra.nr-contrato <> 0 AND
            ordem-compra.nr-contrato <> ? THEN DO:

            RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "num-seq-event":U).

            RUN cnp/cn9060.p (&IF "{&bf_mat_versao_ems}":U >= "2.062":U &THEN
                                  INPUT INTEGER(RETURN-VALUE),
                              &ENDIF
                              ?,
                              ordem-compra.numero-ordem,
                              0,
                              NO,
                              INPUT FRAME {&FRAME-NAME} it-doc-fisico.quantidade,
                              doc-fisico.dt-emissao,
                              OUTPUT de-val-contrato,
                              OUTPUT de-val-aux,
                              OUTPUT de-val-formula,
                              OUTPUT de-val-aux).
        
            IF  de-val-formula > 0 THEN
                ASSIGN de-preco-cc = de-val-formula
                       de-desconto = 0.
            ELSE
                IF  de-val-contrato > 0 THEN DO:
                    ASSIGN de-desconto = 0.
                    IF  AVAIL ordem-compra AND de-preco-cc <> 0 THEN
                        ASSIGN de-qtd-aux  = de-val-contrato / de-preco-cc.
                    ELSE
                        ASSIGN de-qtd-aux  = 0.

                    ASSIGN it-doc-fisico.qt-do-forn:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING( de-qtd-aux * de-indice )
                           de-qtd-aux                                                   = IF item.fraciona
                                                                                          THEN de-qtd-aux
                                                                                          ELSE TRUNCATE( de-qtd-aux, 0 )
                           it-doc-fisico.quantidade:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING( de-qtd-aux ).

                END.
                ELSE DO:
                    FIND FIRST prazo-compra
                         WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem AND
                               prazo-compra.parcela      = i-parcela-cc              NO-LOCK NO-ERROR.

                    IF  AVAIL prazo-compra           AND
                        prazo-compra.quant-saldo > 0 THEN DO:
                        ASSIGN de-qtd-aux                                                   = prazo-compra.quant-saldo
                                                                                            - prazo-compra.dec-1
                               de-qtd-aux                                                   = IF de-qtd-aux < 0
                                                                                              THEN 0
                                                                                              ELSE de-qtd-aux
                               it-doc-fisico.qt-do-forn:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING( de-qtd-aux * de-indice )
                               de-qtd-aux                                                   = IF item.fraciona
                                                                                              THEN de-qtd-aux
                                                                                              ELSE TRUNCATE( de-qtd-aux, 0 )
                               it-doc-fisico.quantidade:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING( de-qtd-aux ).
                    END.

                    ASSIGN de-qtd-aux = (INPUT FRAME {&FRAME-NAME} it-doc-fisico.qt-do-forn
                                      + INTEGER(INPUT FRAME {&FRAME-NAME} it-doc-fisico.qt-do-forn = 0)).
                END.
        END.
        ELSE DO:
            FIND FIRST prazo-compra
                 WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem AND
                       prazo-compra.parcela      = i-parcela-cc              NO-LOCK NO-ERROR.

            IF  AVAIL prazo-compra           AND
                prazo-compra.quant-saldo > 0 THEN DO:
                ASSIGN de-qtd-aux                                                   = prazo-compra.quant-saldo
                                                                                    - prazo-compra.dec-1
                       de-qtd-aux                                                   = IF de-qtd-aux < 0
                                                                                      THEN 0
                                                                                      ELSE de-qtd-aux
                       it-doc-fisico.qt-do-forn:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING( de-qtd-aux * de-indice )
                       de-qtd-aux                                                   = IF item.fraciona
                                                                                      THEN de-qtd-aux
                                                                                      ELSE TRUNCATE( de-qtd-aux, 0 )
                       it-doc-fisico.quantidade:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING( de-qtd-aux ).
            END.

            ASSIGN de-qtd-aux = (INPUT FRAME {&FRAME-NAME} it-doc-fisico.qt-do-forn
                              + INTEGER(INPUT FRAME {&FRAME-NAME} it-doc-fisico.qt-do-forn = 0)).
        END.
         
        assign it-doc-fisico.preco-unit[1]:screen-value in frame {&frame-name} = string(de-preco-cc)
               it-doc-fisico.desconto[1]:screen-value in frame {&frame-name} = 
                                       string(de-desconto-cc * de-qtd-aux)
               it-doc-fisico.preco-total[1]:screen-value in frame {&frame-name} = 
                                       string(de-preco-cc * de-qtd-aux )
               de-vl-merc-liq = de-preco-cc - de-desconto-cc.                                       

        
        /**  Atualiza Despesas Constantes do Item   **/                                       
        run pi-apos-preco.

        if  valid-handle(h_b06in367) then
            run pi-dados-complement in h_b06in367 (input frame {&frame-name} it-doc-fisico.quantidade).
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
    assign c-un = if  available item-fornec 
                  and doc-fisico.tipo-nota <> 2         /* Devolucao */
                  and doc-fisico.tipo-nota <> 5 then    /* Retorno beneficiamento */
                      item-fornec.unid-med-for
                  else if avail item then item.un else "".
    if not adm-new-record and avail it-doc-fisico then
            assign c-un = it-doc-fisico.un.

    if  adm-new-record or l-multiplas-unidades THEN DO:
        assign c-nossa-unid:screen-value in frame {&frame-name} = ITEM.un.    
        
        if  avail item then do:

            RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "numero-ordem").
            assign i-numero-ordem = int(return-value).

            RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "parcela").
            assign i-parcela = int(return-value).

            FIND ordem-compra WHERE
                 ordem-compra.numero-ordem = i-numero-ordem NO-LOCK NO-ERROR.

            IF AVAIL ordem-compra THEN DO:

                find first cotacao-item
                    where cotacao-item.cod-emitente = ordem-compra.cod-emitente
                      and cotacao-item.numero-ordem = ordem-compra.numero-ordem
                      and cotacao-item.data-cotacao = ordem-compra.data-cotacao
                      no-lock no-error.

                IF  AVAIL cotacao-item
                AND ((NOT adm-new-record
                      AND AVAIL it-doc-fisico
                      AND it-doc-fisico.numero-ordem <> i-numero-ordem)
                       OR adm-new-record) THEN
                    ASSIGN c-un = cotacao-item.un.

                for first prazo-compra fields (numero-ordem un)
                    where prazo-compra.numero-ordem = ordem-compra.numero-ordem
                    AND   prazo-compra.parcela      = i-parcela NO-LOCK:
                END.

                assign c-nossa-unid:screen-value in frame {&frame-name} = if avail prazo-compra
                                                                          then prazo-compra.un
                                                                          else if avail item 
                                                                          then item.un
                                                                          else "".
            END.
        end.
    end.  

    if  doc-fisico.tipo-nota <> 2 and 
        doc-fisico.tipo-nota <> 5 then do:
        assign de-indice = fn-indice-conv(c-un).
    end.                      
    if  de-indice = 0 or de-indice = ? then 
        assign de-indice = 1.                  

    assign it-doc-fisico.un:sensitive in frame {&frame-name} = (avail item and
                                                                item.tipo-contr = 4 and
                                                                not avail item-fornec) or 
                                                               (l-multiplas-unidades and i-numero-ordem = 0)
           it-doc-fisico.un:screen-value in frame {&frame-name} = c-un.
    apply 'leave' to it-doc-fisico.un in frame {&frame-name}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-desconto V-table-Win 
PROCEDURE pi-desconto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pr-totNotaAnt AS DECIMAL NO-UNDO.

  /* Possui valor de desconto j† informado */
  IF pr-totNotaAnt <> 0 THEN DO:

    DEFINE VARIABLE dec-totNotaAtual     AS DECIMAL NO-UNDO.
    DEFINE VARIABLE dec-valDescontoAtual AS DECIMAL NO-UNDO.
    DEFINE VARIABLE dec-valDescontoNovo  AS DECIMAL NO-UNDO.
    
    ASSIGN dec-totNotaAtual     = DECIMAL(INPUT FRAME {&FRAME-NAME} it-doc-fisico.preco-total[1])
           dec-valDescontoAtual = DECIMAL(INPUT FRAME {&FRAME-NAME} it-doc-fisico.desconto[1]).
    
    ASSIGN dec-valDescontoNovo = (dec-totNotaAtual * dec-valDescontoAtual) / pr-totNotaAnt.
    
    ASSIGN it-doc-fisico.desconto[1]:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(dec-valDescontoNovo).

  END.

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

    assign h_b06in367 = p-handle-1
           h_v05in163 = p-handle-2.

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

    def input parameter p-sequencia like it-doc-fisico.sequencia no-undo.
    def input parameter p-it-codigo like item.it-codigo         no-undo.

    assign c-it-codigo = p-it-codigo
           i-sequencia = p-sequencia.

    find item where 
        item.it-codigo = c-it-codigo 
        no-lock no-error.

    find item-fornec where 
        item-fornec.cod-emitente = doc-fisico.cod-emitente and 
        item-fornec.it-codigo    = c-it-codigo  
        no-lock no-error.

    IF doc-fisico.tipo-nota <> 3 THEN
        run pi-atualiza-un.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-passa-qtd-estoque V-table-Win 
PROCEDURE pi-passa-qtd-estoque :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /**  Passa nova quantidade para o browse de estoque.  
    **/
    if valid-handle(h_b06in367) then do:
        run pi-passa-baixa-estoq in h_v05in163 ( output l-baixa-estoq ).
        if l-baixa-estoq then
            run pi-dados-complement in h_b06in367 (IF AVAIL it-doc-fisico AND it-doc-fisico.quant-conf > 0 THEN it-doc-fisico.quant-conf ELSE input frame {&frame-name} it-doc-fisico.quantidade).
        else
            run pi-dados-complement in h_b06in367 ( 0 ).
    end.


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

    assign it-doc-fisico.quantidade:screen-value in frame {&frame-name} = string(de-quant).

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

    assign it-doc-fisico.quantidade:screen-value in frame {&frame-name} = string(p-quantidade).
    assign it-doc-fisico.qt-do-forn:screen-value in frame {&frame-name} = string(p-qt-do-forn).

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

    def var de-preco-cc          as decimal                     no-undo.
    def var de-desconto-cc       as decimal                     no-undo.

    find ordem-compra 
        where ordem-compra.numero-ordem = i-ordem-cc no-lock no-error.

    /*  C†lculo Preáo Unit†rio */
    run rep/re1908.p (rowid(ordem-compra),
                      doc-fisico.dt-emissao,
                      output de-preco-cc,  
                      output de-desconto-cc,
                      output de-taxa).

    if  param-global.modulo-cn then do:
        RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "num-seq-event":U).

        run cnp/cn9060.p (&IF "{&bf_mat_versao_ems}":U >= "2.062":U &THEN
                              INPUT INTEGER(RETURN-VALUE),
                          &ENDIF
                          ?,
                          ordem-compra.numero-ordem,
                          0,
                          no,
                          de-quantidade,
                          doc-fisico.dt-emissao,
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

    find prazo-compra where 
        prazo-compra.numero-ordem = i-numero-ordem and 
        prazo-compra.parcela      = i-parcela
        exclusive-lock no-error.

    find ordem-compra where 
        ordem-compra.numero-ordem = i-numero-ordem 
        no-lock no-error.

    if avail ordem-compra and 
        ordem-compra.nr-contrato <> 0 and 
        param-global.modulo-cn then do:
        run cnp/cn9074.p (i-numero-ordem,
                          2,
                          0,
                          input frame {&frame-name} it-doc-fisico.quantidade,
                          doc-fisico.dt-emissao,
                          output de-val-aux,
                          output l-erro-co,
                          output l-contrato,
                          input-output table tt-erro).

        if not l-erro-co then
            assign de-qtd-max = input frame {&frame-name} it-doc-fisico.quantidade.
    end.

    if not l-contrato then
        run pi-variacao-quant ( input prazo-compra.quant-saldo -
                                      prazo-compra.dec-1,
                                &IF defined(bf_mat_uni_estab) &THEN
                                    OUTPUT de-qtd-max-perc,
                                    OUTPUT de-qtd-max-lim
                                &ELSE
                                    output de-qtd-max
                                &ENDIF ).

    &IF defined(bf_mat_uni_estab) &THEN
        run rep/re8885.p (rowid(doc-fisico),
                          IF de-qtd-max-perc < de-qtd-max-lim THEN
                             de-qtd-max-perc
                          ELSE
                              de-var-max-lim,
                          input frame {&frame-name} it-doc-fisico.quantidade,                    
                          19,                                                                    
                          NOT l-erro,
                          i-sequencia,                                                           
                          2).

/*                           not ((input frame {&frame-name} it-doc-fisico.quantidade > de-qtd-max-lim )       */
/*                                 OR (input frame {&frame-name} it-doc-fisico.quantidade > de-qtd-max-perc)), */




    &ELSE
        run rep/re8885.p (rowid(doc-fisico),
                          de-qtd-max,
                          input frame {&frame-name} it-doc-fisico.quantidade,                    
                          19,                                                                    
                          not (input frame {&frame-name} it-doc-fisico.quantidade > de-qtd-max), 
                          i-sequencia,                                                           
                          2).                                                                    

    &ENDIF




    /**  run pi-aloca-ordem-compra(yes).  **/

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

    assign l-pede-qtd   = yes
           l-pede-peso  = yes
           l-pede-valor = param-re.pd-despesa.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-upc V-table-Win 
PROCEDURE pi-upc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM p-evento AS CHAR NO-UNDO.

    IF  c-nom-prog-dpc-mg97  <> ""    
    OR  c-nom-prog-appc-mg97 <> ""    
    OR  c-nom-prog-upc-mg97  <> "" THEN DO:
        /* UPC */                          
        IF  c-nom-prog-upc-mg97 <> "" THEN DO:
            RUN VALUE(c-nom-prog-upc-mg97) (INPUT p-evento,
                                            INPUT "CONTAINER":U,
                                            INPUT THIS-PROCEDURE:HANDLE,
                                            INPUT FRAME f-main:HANDLE,  
                                            INPUT ?,     
                                            INPUT ?).    
            IF  RETURN-VALUE = "NOK":U THEN              
                RETURN "NOK":U.   
        END.                      
        /* DPC */                 
        IF  c-nom-prog-dpc-mg97 <> "" THEN DO:
            RUN VALUE(c-nom-prog-dpc-mg97) (INPUT p-evento, 
                                            INPUT "CONTAINER":U,
                                            INPUT THIS-PROCEDURE:HANDLE,
                                            INPUT FRAME f-main:HANDLE,
                                            INPUT ?,                  
                                            INPUT ?).
            IF  RETURN-VALUE = "NOK":U THEN
                RETURN "NOK":U.
        END.
        /* APPC */
        IF  c-nom-prog-appc-mg97 <> "" THEN DO:
            RUN VALUE(c-nom-prog-appc-mg97) (INPUT p-evento,
                                             INPUT "CONTAINER":U,
                                             INPUT THIS-PROCEDURE:HANDLE,
                                             INPUT FRAME f-main:HANDLE,
                                             INPUT ?,
                                             INPUT ?).
            IF  RETURN-VALUE = "NOK":U THEN
                RETURN "NOK":U.
        END.
    END.

    RETURN "OK":U.

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

    DEFINE VARIABLE c-lb-unidade  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-lb-item     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-lb-emitente AS CHARACTER   NO-UNDO.

    {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */

    find item where item.it-codigo = c-it-codigo no-lock no-error.

    /* Buca a variacao por familia ou item-uni estab de acordo com ver EMS.*/
    {rep/re1001.i10 doc-fisico.cod-estabel}

    /*Na alteraá∆o do item, limpa consist-nota se existir para documento com a mensagem 5698*/
    IF i-numero-ordem  <> 0
    OR i-ordem-desloca <> 0
    OR NOT CAN-FIND(FIRST rat-ordem 
                    WHERE rat-ordem.serie-docto  = doc-fisico.serie-docto 
                      AND rat-ordem.nro-docto    = doc-fisico.nro-docto 
                      AND rat-ordem.cod-emitente = doc-fisico.cod-emitente 
                      AND rat-ordem.nat-operacao = "" 
                      AND rat-ordem.tipo-nota    = doc-fisico.tipo-nota) THEN
        run rep/re8885.p(INPUT rowid(doc-fisico),
                         INPUT 0,
                         INPUT 0,
                         INPUT 5698,
                         INPUT YES, 
                         INPUT i-sequencia,
                         INPUT 1).

    if l-pede-qtd then do:   

        if (    doc-fisico.tipo-nota = 5 
            or  doc-fisico.tipo-nota = 8) 
        and not adm-new-record then do:

            find saldo-terc 
                where saldo-terc.cod-emitente = doc-fisico.cod-emitente  
                and   saldo-terc.nro-docto    = it-doc-fisico.nro-comp   
                and   saldo-terc.serie-docto  = it-doc-fisico.serie-comp 
                and   saldo-terc.nat-operacao = it-doc-fisico.nat-comp   
                and   saldo-terc.it-codigo    = it-doc-fisico.it-codigo  
                and   saldo-terc.cod-refer    = it-doc-fisico.cod-refer  
                and   saldo-terc.sequencia    = it-doc-fisico.seq-comp   no-lock no-error.
            if  avail saldo-terc 
            and input frame {&frame-name} it-doc-fisico.quantidade > (saldo-terc.quantidade - saldo-terc.dec-1 + it-doc-fisico.quantidade) then do:
                {include/i-vldprg.i}
                run utp/ut-msgs.p (input "show",input 15192,input " ").
                apply 'entry' to it-doc-fisico.quantidade in frame {&frame-name}.
                return 'adm-error':U.
            end.
        end.

        if  item.fraciona = no 
        and integer( input frame {&frame-name} it-doc-fisico.quantidade) <> input frame {&frame-name} it-doc-fisico.quantidade then do:
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",input 1892,input " ").
            apply 'entry' to it-doc-fisico.quantidade in frame {&frame-name}.
            return 'adm-error':U.
        end.

        if (    (    doc-fisico.tipo-nota >= 4 
                and  doc-fisico.tipo-nota <= 8)  /* notas de terceiros */
            or  (i-numero-ordem <> 0))  /* ou se tiver pedido/ordem compra, qtd deve ser <> de 0 */
        and input frame {&frame-name} it-doc-fisico.quantidade  = 0  then do:
            {include/i-vldprg.i}
            {utp/ut-liter.i Quantidade * L}
            run utp/ut-msgs.p (input "show",input 1491,input return-value).
            apply 'entry' to it-doc-fisico.quantidade in frame {&frame-name}.
            return 'adm-error':U.
        end.

        if  not adm-new-record 
        and avail it-doc-fisico 
        and doc-fisico.tipo-nota = 2 then do:
            {rep/re1001.i04 doc-fisico.cod-estabel
                            it-doc-fisico.serie-comp
                            it-doc-fisico.nro-comp
                            it-doc-fisico.it-codigo
                            it-doc-fisico.seq-comp}

            if  de-qtd-max <> ? 
            and input frame {&frame-name} it-doc-fisico.quantidade > de-qtd-max then do:        
                {include/i-vldprg.i}
                run utp/ut-msgs.p (input "show",input 15024,input " ").
                apply 'entry' to it-doc-fisico.quantidade in frame {&frame-name}.
                return 'adm-error':U.
            end.
        end.            
    end.

    if  input frame {&frame-name} it-doc-fisico.un <> c-un 
    and (avail item-fornec 
        and item-fornec.unid-med-for <> input frame {&frame-name} it-doc-fisico.un)
    and item.tipo-contr <> 4
    AND doc-fisico.tipo-nota <> 2 /*Devoluá∆o*/
    AND doc-fisico.tipo-nota <> 3 /*Transferància*/
    AND doc-fisico.tipo-nota <> 5 /*Retorno de Beneficiamento*/ /*Nenhum desses tipos de nota Ç poss°vel alterar a unidade de medida no re2001*/ then do:            
        {include/i-vldprg.i}
        if l-multiplas-unidades then do:
            if not can-find (first item-fornec-umd
                             where item-fornec-umd.it-codigo    = item-fornec.it-codigo
                               and item-fornec-umd.cod-emitente = item-fornec.cod-emitente
                               and item-fornec-umd.unid-med-for = input frame {&frame-name} it-doc-fisico.un
                               and item-fornec-umd.log-ativo) then do:

                {utp/ut-table.i mgind tab-unidade 1}
                ASSIGN c-lb-unidade  = RETURN-VALUE.
    
                {utp/ut-table.i mgind ITEM 1}
                ASSIGN c-lb-item  = RETURN-VALUE.
    
                {utp/ut-liter.i "Fornecedor"}
                ASSIGN c-lb-emitente  = RETURN-VALUE.

                run utp/ut-msgs.p (input "show",
                                   input 17899, /*Unidade de medida n∆o est† relacionada ao Item X Fornecedor*/
                                   input c-lb-unidade + ': ' + input frame {&frame-name} it-doc-fisico.un + '~~' +  
                                         c-lb-item + ': ' + c-it-codigo + ', ' + 
                                         c-lb-emitente + ': ' + string(doc-fisico.cod-emitente)).

                apply 'entry' to it-doc-fisico.un in frame {&frame-name}.
                return 'adm-error':U.
            end.

        end.
        else do:
            run utp/ut-msgs.p (input "show",input 7346,input " ").
            apply 'entry' to it-doc-fisico.un in frame {&frame-name}.
            return 'adm-error':U.
        end.
    end.

    if  not avail natur-oper 
    or  (     doc-fisico.tipo-nota <> 5 
          and doc-fisico.tipo-nota <> 7 
          and doc-fisico.tipo-nota <> 8 ) then do:

        if  input frame {&frame-name} it-doc-fisico.preco-total[1] = 0 
        and input frame {&frame-name} it-doc-fisico.quantidade <> 0 then do:
            {include/i-vldprg.i}
            {utp/ut-liter.i Preco_Total * L}
            run utp/ut-msgs.p (input "show",input 1491,input return-value).
            apply 'entry' to it-doc-fisico.preco-total[1] in frame {&frame-name}.
            return 'adm-error':U.
        end.

        if input frame {&frame-name} it-doc-fisico.qt-do-forn <> 0 then do:
            assign de-val-aux = round(input frame {&frame-name} it-doc-fisico.preco-unit[1] *
                                      input frame {&frame-name} it-doc-fisico.qt-do-forn, 2).

            if  de-val-aux <> input frame {&frame-name} it-doc-fisico.preco-total[1] 
            and param-re.preco-unit then do:
                {include/i-vldprg.i}
                run utp/ut-msgs.p (input "show",input 15193,input " ").
                if return-value <> "yes" then do:                                   
                    apply 'entry' to it-doc-fisico.un in frame {&frame-name}.
                    return 'adm-error':U.
                end.

                assign it-doc-fisico.preco-unit[1]:screen-value in frame {&frame-name} =
                            string(input frame {&frame-name} it-doc-fisico.preco-total[1] /
                                   input frame {&frame-name} it-doc-fisico.qt-do-forn ).
            end.
        end.                
    end.        

    if i-numero-ordem <> 0 then do:

        /**** Variaá∆o Valor ****/
        assign de-vl-merc-liq-aux = input frame {&frame-name} it-doc-fisico.preco-total[1] 
                                  - input frame {&frame-name} it-doc-fisico.desconto[1].

        if  not adm-new-record then do:
             /* Atualiza Preáo da Ordem de Compra */
             run pi-preco-ordem ( input i-numero-ordem,
                                  input input frame {&frame-name} it-doc-fisico.quantidade).
        end.

        
        assign de-vl-merc-liq = round(de-vl-merc-liq,5) 
               de-vl-aux      = de-vl-merc-liq * ( input frame {&frame-name} it-doc-fisico.qt-do-forn
                                                 + int( input frame {&frame-name} it-doc-fisico.qt-do-forn = 0 )).

        run pi-variacao-valor ( input  de-vl-aux,
                                output de-var-max-perc,
                                output de-var-max-lim,
                                output de-var-min).

        assign l-erro = no.

        if  de-var-val-re-maior = 0
        and de-lim-var-valor    = 0  then do:
            if  de-vl-merc-liq-aux > de-var-max-perc
            or  de-vl-merc-liq-aux > de-var-max-lim then
                assign l-erro = yes.
        end.
        else do:
            if  de-vl-merc-liq-aux <= de-var-max-perc
            or  de-var-val-re-maior = 0 then 
                if  de-vl-merc-liq-aux > de-var-max-lim
                and de-lim-var-valor > 0 then
                    assign l-erro = yes.
                else
                    assign l-erro = no.
            else
                assign l-erro = yes.
        end.
        
        if  l-erro then do:
            if param-re.aceita-var = no then do:                               
                {include/i-vldprg.i}
                run utp/ut-msgs.p (input "show",input 15195,input " ").
                apply 'entry' to it-doc-fisico.preco-unit[1] in frame {&frame-name}.
                return 'adm-error':U.
            end.
            else do:
                /***************************  Inicio UPC  ************************************/
                find prog_dtsul where prog_dtsul.cod_prog_dtsul = "v06in163" no-lock no-error.
                    if  avail prog_dtsul then do:
                        assign c-nom-prog-dpc-mg97  = prog_dtsul.nom_prog_dpc
                               c-nom-prog-appc-mg97 = prog_dtsul.nom_prog_appc
                               c-nom-prog-upc-mg97  = prog_dtsul.nom_prog_upc.
                    end.  
                
                RUN pi-upc (INPUT "ValidaVariacaoVal":U).
                
                IF  RETURN-VALUE = "NOK":U THEN DO:
                    apply 'entry' to it-doc-fisico.preco-unit[1] in frame {&frame-name}.
                    return 'adm-error':U.
                END.
                /****************************  Fim UPC  *************************************/
                {include/i-vldprg.i}
                run utp/ut-msgs.p (input "show",input 15196,input " ").
                if return-value <> "yes" then do:                                
                    apply 'entry' to it-doc-fisico.preco-unit[1] in frame {&frame-name}.
                    return 'adm-error':U.
                end.
            end.
        end.

        run rep/re8885.p (rowid(doc-fisico),
                          IF de-var-max-perc < de-var-max-lim THEN
                              de-var-max-perc
                          ELSE
                              de-var-max-lim,
                          de-vl-merc-liq-aux,
                          15196,
                          NOT l-erro,
                          i-sequencia,
                          1).
        /************************/
        
        /**** Variaá∆o Quantidade ****/
        if l-pede-qtd then do:

            if  avail ordem-compra 
            and ordem-compra.nr-contrato <> 0 
            and param-global.modulo-cn then do:
                run cnp/cn9074.p (i-numero-ordem,
                                  2,
                                  0,
                                  input frame {&frame-name} it-doc-fisico.quantidade,
                                  doc-fisico.dt-emissao,
                                  output de-qtd-max,
                                  output l-erro-co,
                                  output l-contrato,
                                  input-output table tt-erro).

                assign de-qtd-max = de-qtd-max 
                                   + if  param-re.aceita-var then 
                                        round( de-qtd-max * de-var-qtd-re / 100, 4 )
                                     else 0.
            end.

            IF NOT adm-new-record THEN
                FOR FIRST prazo-compra 
                    WHERE prazo-compra.numero-ordem = it-doc-fisico.numero-ordem 
                      AND prazo-compra.parcela      = it-doc-fisico.parcela EXCLUSIVE-LOCK:
                    RUN pi-aloca-ordem-cc(INPUT NO,
                                          INPUT (IF it-doc-fisico.quant-conf <> 0 THEN it-doc-fisico.quant-conf 
                                                 ELSE it-doc-fisico.quantidade) ,
                                          INPUT ROWID(prazo-compra) ).
                END.
            
            find first prazo-compra exclusive-lock
                    where prazo-compra.numero-ordem = i-numero-ordem 
                      and prazo-compra.parcela      = i-parcela no-error.
            if avail prazo-compra then do:
                IF NOT adm-new-record THEN DO:
                    RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "numero-ordem").
                    assign i-numero-ordem = int(return-value).
                    RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "parcela").
                    assign i-parcela = int(return-value).
                    FIND FIRST prazo-compra EXCLUSIVE-LOCK
                         WHERE prazo-compra.numero-ordem = i-numero-ordem
                           AND prazo-compra.parcela      = i-parcela NO-ERROR.
                END.

                if not l-contrato AND AVAIL prazo-compra then 
                    run pi-variacao-quant ( input  (prazo-compra.quant-saldo - prazo-compra.dec-1),
                                            output de-qtd-max-perc,
                                            output de-qtd-max-lim).

                /*Aloca prazo-compra*/
                run pi-aloca-ordem-cc ( input yes,
                                        input (INPUT FRAME {&FRAME-NAME} it-doc-fisico.quantidade),
                                        input rowid(prazo-compra)).
                
            end.

            assign l-erro = no.

            if not l-contrato then do:
                if  de-var-qtd-re  = 0
                and de-lim-var-qtd = 0  then do:
                    if  input frame {&frame-name} it-doc-fisico.quantidade > de-qtd-max-perc
                    or  input frame {&frame-name} it-doc-fisico.quantidade > de-qtd-max-lim then
                        assign l-erro = yes.
                end.
                else do:
                    if input frame {&frame-name} it-doc-fisico.quantidade <= de-qtd-max-perc
                    or de-var-qtd-re = 0 then do:
                        if  input frame {&frame-name} it-doc-fisico.quantidade > de-qtd-max-lim
                        and de-lim-var-qtd > 0 then
                            assign l-erro = yes.
                        else
                            assign l-erro = no.
                    end.
                    else
                        assign l-erro = yes.
                end.
            end.
            else
                if input frame {&frame-name} it-doc-fisico.quantidade > de-qtd-max then
                    assign l-erro = yes.
            
            if l-erro then do:                                    
                if param-re.aceita-var = no then do:                               
                    {include/i-vldprg.i}
                    run utp/ut-msgs.p (input "show",input 5928,input " ").
                    apply 'entry' to it-doc-fisico.quantidade in frame {&frame-name}.
                    return 'adm-error':U.
                end.
                else do:
                    /***************************  Inicio UPC  ************************************/
                    find prog_dtsul where prog_dtsul.cod_prog_dtsul = "v06in163" no-lock no-error.
                        if  avail prog_dtsul then do:
                            assign c-nom-prog-dpc-mg97  = prog_dtsul.nom_prog_dpc
                                   c-nom-prog-appc-mg97 = prog_dtsul.nom_prog_appc
                                   c-nom-prog-upc-mg97  = prog_dtsul.nom_prog_upc.
                        end.  

                    RUN pi-upc (INPUT "ValidaVariacaoQtde":U).

                    IF  RETURN-VALUE = "NOK":U THEN DO:
                        apply 'entry' to it-doc-fisico.quantidade in frame {&frame-name}.
                        return 'adm-error':U.
                    END.
                    /****************************  Fim UPC  *************************************/

                    {include/i-vldprg.i}
                    run utp/ut-msgs.p (input "show",input 5698,input " ").
                    if return-value <> "yes" then do:                                
                        apply 'entry' to it-doc-fisico.quantidade in frame {&frame-name}.
                        return 'adm-error':U.
                    end.
                end.
            end.
            
            run rep/re8885.p (rowid(doc-fisico),
                              IF de-qtd-max-perc < de-qtd-max-lim THEN
                                 de-qtd-max-perc
                              ELSE
                                  de-qtd-max-lim,
                              input frame {&frame-name} it-doc-fisico.quantidade,
                              5698,
                              NOT l-erro, 
                              i-sequencia,
                              1).
        end.
        /************************/
    end.    
    ELSE IF i-ordem-desloca <> 0 AND
            i-parc-desloca  <> 0 THEN DO:

        /*Logica colocada para desalocar o saldo da ordem quando havia uma ordem relacionada 
          ao item na nota, mas a mesma foi zerada. Quando Ç alterado de uma ordem para outra, 
          o sistema j† realiza a desalocaá∆o em outro ponto*/
        FIND FIRST prazo-compra EXCLUSIVE-LOCK 
             WHERE prazo-compra.numero-ordem = i-ordem-desloca 
               AND prazo-compra.parcela      = i-parc-desloca NO-ERROR.
        IF AVAIL prazo-compra THEN DO:
            RUN pi-aloca-ordem-cc (INPUT NO,
                                   INPUT (IF it-doc-fisico.quant-conf <> 0 then it-doc-fisico.quant-conf 
                                          ELSE it-doc-fisico.quantidade) ,
                                   INPUT ROWID(prazo-compra) ).
        END.
        ASSIGN i-ordem-desloca = 0
               i-parc-desloca  = 0.
    END.


    if doc-fisico.tipo-nota = 5 then do:
        assign de-vl-merc-liq = input frame {&frame-name} it-doc-fisico.preco-total[1] 
                              - input frame {&frame-name} it-doc-fisico.desconto[1].

        if de-vl-merc-liq = 0 then do:            
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",input 15197,input " ").
            apply 'entry' to it-doc-fisico.preco-unit[1] in frame {&frame-name}.
            return 'adm-error':U.
        end.
    end.

    if param-re.pd-despesa then do:
        if input frame {&frame-name} it-doc-fisico.despesas[1] <
           input frame {&frame-name} it-doc-fisico.vl-frete then do:
            /**  Total despesas nao pode ser inferior ao frete 
            **/
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",input 15198,input " ").
            apply 'entry' to it-doc-fisico.despesas[1] in frame {&frame-name}.
            return 'adm-error':U.
        end.
    end.  

    find first tt-erro 
        no-lock no-error.
    if available tt-erro then do:
        /**  Erro da tt-erro 
        **/
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show",input tt-erro.cd-erro,input " ").
        for each tt-erro:
            delete tt-erro.
        end.
        apply 'entry' to it-doc-fisico.qt-do-forn in frame {&frame-name}.
        return 'adm-error':U.
    end. 

    if not adm-new-record and 
        i-numero-ordem = 0 and 
        avail it-doc-fisico and
        doc-fisico.tipo-nota = 1 then do:
        assign de-qtd-aux = 0.
        for each rat-ordem use-index documento where
            rat-ordem.serie-docto  = it-doc-fisico.serie-docto and
            rat-ordem.nro-docto    = it-doc-fisico.nro-docto and
            rat-ordem.cod-emitente = it-doc-fisico.cod-emitente and
            rat-ordem.tipo-nota    = it-doc-fisico.tipo-nota and
            rat-ordem.nat-operacao = "" and
            rat-ordem.sequencia = it-doc-fisico.sequencia no-lock:
            assign de-qtd-aux = de-qtd-aux + rat-ordem.quantidade.
        end.

        if de-qtd-aux > input frame {&frame-name} it-doc-fisico.quantidade then do:
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",input 15455,input " ").
            apply 'entry' to it-doc-fisico.quantidade in frame {&frame-name}.
            return 'adm-error':U.
        end.            
    end.

    find tab-unidade where tab-unidade.un = input frame {&frame-name} it-doc-fisico.un no-lock no-error.
    if not avail tab-unidade then do:      
        {include/i-vldprg.i}     
        run utp/ut-msgs.p (input "show",input 7860,input " ").
        apply "entry" to it-doc-fisico.un in frame {&frame-name}.        
        return "adm-error":U.   
    end.

    /* Chamada EPC para a pi-validate */
    {include/i-epc002.i}

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

def input  param de-valor-orig   like it-doc-fisico.preco-total[1] NO-UNDO.
def output param de-var-max-perc like it-doc-fisico.preco-total[1] NO-UNDO.
def output param de-var-max-lim  LIKE it-doc-fisico.preco-total[1] NO-UNDO.
def output param de-valor-min    like it-doc-fisico.preco-total[1] NO-UNDO.

if param-re.aceita-var then do:
    assign de-var-max-perc = round(de-valor-orig +
                                  (de-valor-orig * de-var-val-re-maior / 100), 2)
           de-valor-min    = round(de-valor-orig -
                                  (de-valor-orig * de-var-val-re-maior / 100), 2)
           de-var-max-lim  = de-valor-orig + de-lim-var-valor.
end.
else
    assign de-var-max-perc = de-valor-orig
           de-var-max-lim  = de-valor-orig
           de-valor-min    = de-valor-orig.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE executarEngineRecSemPedido V-table-Win 
PROCEDURE executarEngineRecSemPedido:
    
    DEFINE VARIABLE h-reapi427  AS HANDLE      NO-UNDO.
    DEFINE VARIABLE cChaveDocto AS CHARACTER   NO-UNDO.

    ASSIGN cChaveDocto = STRING(doc-fisico.cod-emitente) + "|" + doc-fisico.serie-docto + "|" + doc-fisico.nro-docto + "|" + string(doc-fisico.tipo-nota) + "|" + STRING(it-doc-fisico.sequencia).
    
    RUN rep/reapi427.p PERSISTENT SET h-reapi427.

    RUN setChaveDocto  IN h-reapi427 (INPUT cChaveDocto).
    RUN setCodEstabel  IN h-reapi427 (INPUT doc-fisico.cod-estabel).
    RUN setCodEmitente IN h-reapi427 (INPUT doc-fisico.cod-emitente).
    RUN setCodObserva  IN h-reapi427 (INPUT doc-fisico.tipo-nota).
    RUN setUsuario     IN h-reapi427 (INPUT c-seg-usuario).

    RUN setItCodigo    IN h-reapi427 (INPUT it-doc-fisico.it-codigo).
    RUN setSeqItem     IN h-reapi427 (INPUT it-doc-fisico.sequencia).

    RUN engineRegrasRecSemPedido IN h-reapi427 (OUTPUT l-sem-pedido).
    
    RETURN "OK":U.
    FINALLY:
        DELETE PROCEDURE h-reapi427 NO-ERROR.
        ASSIGN h-reapi427 = ?.
    END FINALLY.
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
  {src/adm/template/snd-list.i "it-doc-fisico"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnSetaIndice V-table-Win 
function fn-indice-conv return decimal
    (input c-un-forn as char):
/* -----------------------------------------------------------
  Purpose:     Funá∆o utilizada para setar o °ndice de convers∆o
               das quantidades.
  Parameters:  c-un-forn - unidade do fornecedor
  Notes:       
-------------------------------------------------------------*/
{cdp/cd9950.i c-nossa-unid
              c-un-forn
              doc-fisico.cod-emitente}
return de-indice.

end function.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
