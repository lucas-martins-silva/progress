&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/*:T--------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) Ç um programa PROGRESS 
                 que contÇm a l¢gica de neg¢cio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.                */
/*------------------------------------------------------------------------*/
{include/i-prgvrs.i BOCX404 2.00.00.044 } /*** "010044" 15/07/2026 13:37:33 ***/
/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOCX404
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName decla-import-ord
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

/* DBO-XML-BEGIN */
/*:T Pre-processadores para ativar XML no DBO */
/*:T Retirar o comentario para ativar 
&GLOBAL-DEFINE XMLProducer YES    /*:T DBO atua como producer de mensagens para o Message Broker */
&GLOBAL-DEFINE XMLTopic           /*:T Topico da Mensagem enviada ao Message Broker, geralmente o nome da tabela */
&GLOBAL-DEFINE XMLTableName       /*:T Nome da tabela que deve ser usado como TAG no XML */ 
&GLOBAL-DEFINE XMLTableNameMult   /*:T Nome da tabela no plural. Usado para multiplos registros */ 
&GLOBAL-DEFINE XMLPublicFields    /*:T Lista dos campos (c1,c2) que podem ser enviados via XML. Ficam fora da listas os campos de especializacao da tabela */ 
&GLOBAL-DEFINE XMLKeyFields       /*:T Lista dos campos chave da tabela (c1,c2) */
&GLOBAL-DEFINE XMLExcludeFields   /*:T Lista de campos a serem excluidos do XML quando PublicFields = "" */

&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (mÇtodo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /*:T Nome da Query que d† acessos a todos os registros, exceto os exclu°dos pela constraint de seguranáa. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /*:T Informar os campos da chave quando o Progress n∆o conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

/*:T--- Include com definiá∆o da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{cxbo/bocx404.i RowObject}
{cxbo/bocx351.i tt-licenciam-import-oc}
{cxbo/bocx351.i tt-licenciam-import-oc-aux}
{cxbo/bocx225.i tt-ordens-embarque}
{cxbo/bocx402.i tt-decla-import-adic-itens}
{cxbo/bocx404.i tt-decla-import-ord}
{cxbo/bocx404.i tt-decla-import-ord-aux}
{cxbo/bocx00507.i tt-decla-import-ord-trib}
{cdp/cdcfgmat.i}                        /* Include Pre-processadores */
{utp/ut-glob.i}
/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}

{utils/itemVendorConversionFactor.i}

/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
DEFINE BUFFER b-prazo-compra FOR prazo-compra.

def var i-num-di-ems like decla-import.num-di-ems     no-undo.
def VAR de-cdd-siscomex-dts like decla-import.cdd-siscomex-dts no-undo.
def var i-cod-embarq like decla-import-ord.cod-embarq no-undo.
def var h-bocx351    as handle                        no-undo.
DEFINE VARIABLE h-bocx250   AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx225   AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx225e  AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-boin356aa AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-im0410aa  AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx383   AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx383a  AS HANDLE      NO-UNDO.
DEFINE VARIABLE r-rowid-embarque AS ROWID  NO-UNDO.
DEF VAR de-quant-disp   LIKE    prazo-compra.quantidade no-undo.
DEF VAR i-numero-ordem  LIKE ordem-compra.numero-ordem  NO-UNDO.
DEF VAR de-quant-embarq like prazo-compra.quantidade    no-undo.
def var d-entrega       as   date                       no-undo.
def var dt-entrega      as   date                       no-undo.
def var de-quant-parc   like prazo-compra.quantidade    no-undo.
def var de-quant-orig   like prazo-compra.quantidade    no-undo.
def var c-cod-un        like ITEM.un                    no-undo.
def var c-cod-un-fornec like cotacao-item.un            no-undo.
def var v-cod-estabel   LIKE ordem-compra.cod-estabel   no-undo.
def var v-qtde-n-emb    LIKE prazo-compra.quantidade    no-undo.
def var v-qtde-emb      LIKE prazo-compra.quantidade    no-undo.    
def var v-nova-entrega  as      date                    no-undo.
def var c-return        as      char                    no-undo.
def var v-retorno       as      char                    no-undo.    
DEF VAR l-relaciona     AS LOGICAL NO-UNDO.
def var v-nova-parcela  like    prazo-compra.parcela    NO-UNDO.
def var iRowsReturned   as integer                      NO-UNDO.
DEF VAR h-bocx402       AS HANDLE                       NO-UNDO.

DEF VAR d-val-peso-liq-tot-di       LIKE decla-import-adic.val-peso-liq NO-UNDO.
DEF VAR d-val-peso-brut-merc-tot-di LIKE decla-import-adic.val-peso-liq NO-UNDO.
DEF VAR d-peso-liq-tot-adic         LIKE decla-import-adic.val-peso-liq NO-UNDO.

DEF VAR l-utz-taxa-siscomex         AS LOGICAL NO-UNDO.
DEF VAR i-cod-desp                  AS INTEGER NO-UNDO.

def var i-num-ordem   like {&TableName}.num-ordem   no-undo.
def var i-num-parcela like {&TableName}.num-parcela no-undo.

DEF VAR l-quebra-alterada AS LOGICAL NO-UNDO.

DEF VAR de-indice-conversao-fornec  AS DECIMAL  INITIAL 1 NO-UNDO.

DEFINE VARIABLE l-nt2024002   AS LOGICAL     NO-UNDO.
ASSIGN l-nt2024002 = CAN-FIND(FIRST funcao NO-LOCK
                              WHERE funcao.cd-funcao = "spp-nt2024002":U AND funcao.ativo).

{include/boerrtab.i} /* tt-bo-erro */
{cxbo/bocx225e.i1}   /* variˇveis atributo livre ordens-embarque */
{imp/im0410a.i}      /* Definiá‰es necess†rias para o folder Impostos */
{imp/im0410a.i2}     /* define a temp-table tt-campos-quebra */
{imp/im0400j.i} /* tt-saldo-di */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DBOProgram
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 19.67
         WIDTH              = 39.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "DBO 2.0 Wizard" DBOProgram _INLINE
/* Actions: wizard/dbowizard.w ? ? ? ? */
/* DBO 2.0 Wizard (DELETE)*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB DBOProgram 
/* ************************* Included-Libraries *********************** */

{method/dbo.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOProgram 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDeleteRecord DBOProgram 
PROCEDURE afterDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    
    IF NOT VALID-HANDLE(h-bocx402) THEN RUN cxbo/bocx402.p PERSISTENT SET h-bocx402.

    IF  CAN-FIND(FIRST decla-import-adic-itens
                 WHERE decla-import-adic-itens.num-di-ems  = RowObject.num-di-ems 
                 AND   decla-import-adic-itens.num-adic    = RowObject.num-adic   
                 AND   decla-import-adic-itens.num-ordem   = RowObject.num-ordem  
                 AND   decla-import-adic-itens.num-parcela = RowObject.num-parcela
                 AND   decla-import-adic-itens.cdd-siscomex-dts = RowObject.cdd-siscomex-dts) THEN DO:
                 
        FOR FIRST decla-import-adic-itens EXCLUSIVE-LOCK
            WHERE decla-import-adic-itens.num-di-ems  = RowObject.num-di-ems 
            AND   decla-import-adic-itens.num-adic    = RowObject.num-adic   
            AND   decla-import-adic-itens.num-ordem   = RowObject.num-ordem  
            AND   decla-import-adic-itens.num-parcela = RowObject.num-parcela 
            AND   decla-import-adic-itens.cdd-siscomex-dts = RowObject.cdd-siscomex-dts:

            EMPTY TEMP-TABLE tt-decla-import-adic-itens.
            CREATE tt-decla-import-adic-itens.
            BUFFER-COPY decla-import-adic-itens TO tt-decla-import-adic-itens.

            IF VALID-HANDLE(h-bocx402) THEN DO:
                RUN openQueryStatic IN h-bocx402 (INPUT 'Main':U).
                RUN emptyRowErrors  IN h-bocx402.
                RUN goToKey         IN h-bocx402(INPUT tt-decla-import-adic-itens.num-di-ems,
                                                 INPUT tt-decla-import-adic-itens.num-adic,
                                                 INPUT tt-decla-import-adic-itens.num-seq,
                                                 INPUT tt-decla-import-adic-itens.cdd-siscomex-dts).
                                                  
                IF RETURN-VALUE = "OK" THEN DO:
                    RUN deleteRecord IN h-bocx402.
                    RUN getRowErrors IN h-bocx402(OUTPUT TABLE RowErrors).
                END.
                
            END.
        END. /* FOR EACH  decla-import-adic-itens */
        RELEASE decla-import-adic-itens.
    END. /* IF  CAN-FIND(FIRST decla-import-adic-itens */

    DELETE PROCEDURE h-bocx402.
    ASSIGN h-bocx402 = ?.
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterUpdateRecord DBOProgram 
PROCEDURE afterUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    RUN pi-AtualizaOrdem.

    /* atualiza o peso liquido e peso bruto do item da ordem em questao */
    FOR FIRST decla-import-adic-itens EXCLUSIVE-LOCK
            WHERE decla-import-adic-itens.num-di-ems      = RowObject.num-di-ems
            AND   decla-import-adic-itens.num-adic        = RowObject.num-adic
            AND   decla-import-adic-itens.num-ordem       = RowObject.num-ordem
            AND   decla-import-adic-itens.num-parcela     = RowObject.num-parcela
            and   decla-import-adic-itens.cdd-siscomex-dts = RowObject.cdd-siscomex-dts:
        ASSIGN decla-import-adic-itens.val-peso-liq       = RowObject.val-peso-liq
               decla-import-adic-itens.val-peso-brut-merc = RowObject.val-peso-brut-merc.
    END.

    /* atualiza os pesos das adicoes e da di */
    ASSIGN d-peso-liq-tot-adic = 0.
    /* soma o peso liquido total das ordens da adiá∆o em questao */
    FOR EACH bfdecla-import-ord NO-LOCK
            WHERE bfdecla-import-ord.num-di-ems = RowObject.num-di-ems
            AND   bfdecla-import-ord.num-adic   = RowObject.num-adic
            and   bfdecla-import-ord.cdd-siscomex-dts = RowObject.cdd-siscomex-dts:
        ASSIGN d-peso-liq-tot-adic = d-peso-liq-tot-adic + bfdecla-import-ord.val-peso-liq.
    END.

    IF d-peso-liq-tot-adic > 0 THEN DO:
        /* altera o valor do peso liquido da adiá∆o em questao */
        FOR EACH decla-import-adic EXCLUSIVE-LOCK
                WHERE decla-import-adic.num-di-ems = RowObject.num-di-ems
                AND   decla-import-adic.num-adic   = RowObject.num-adic
                and   decla-import-adic.cdd-siscomex-dts = RowObject.cdd-siscomex-dts:
            ASSIGN decla-import-adic.val-peso-liq       = d-peso-liq-tot-adic.
        END.
    
        /* soma o peso liquido e o peso bruto de todas as adicoes para levar para a DI */
        ASSIGN d-val-peso-liq-tot-di       = 0
               d-val-peso-brut-merc-tot-di = 0.
        FOR EACH bfdecla-import-ord NO-LOCK
            WHERE bfdecla-import-ord.num-di-ems = RowObject.num-di-ems
              and bfdecla-import-ord.cdd-siscomex-dts = RowObject.cdd-siscomex-dts:

            ASSIGN d-val-peso-brut-merc-tot-di = d-val-peso-brut-merc-tot-di + bfdecla-import-ord.val-peso-brut-merc.

        END.
        FOR EACH decla-import-adic NO-LOCK
                WHERE decla-import-adic.num-di-ems = RowObject.num-di-ems
                and   decla-import-adic.cdd-siscomex-dts = RowObject.cdd-siscomex-dts:
            ASSIGN d-val-peso-liq-tot-di       = d-val-peso-liq-tot-di + decla-import-adic.val-peso-liq.
                   /*d-val-peso-brut-merc-tot-di = d-val-peso-brut-merc-tot-di + (decla-import-adic.val-peso-liq * decla-import-adic.qtd-ncm)*/
        END.
    
        /* atualiza o peso liquido total e o peso bruto total da DI */
        FOR FIRST decla-import EXCLUSIVE-LOCK
                WHERE decla-import.num-di-ems = RowObject.num-di-ems
                and   decla-import.cdd-siscomex-dts = RowObject.cdd-siscomex-dts:
            ASSIGN decla-import.val-peso-liq-di      = d-val-peso-liq-tot-di
                   decla-import.val-peso-brut-merc   = d-val-peso-brut-merc-tot-di
                   decla-import.val-peso-brut-tot-di = decla-import.val-peso-brut-merc + decla-import.val-peso-embal-di.
        END.
        /* fim - atualiza os pesos das adicoes e da di */
    END.

        /* atualiza as ordens que tiveram um ou mais campos da quebra alterados */
        IF NOT VALID-HANDLE(h-bocx383) THEN
            RUN cxbo/bocx383.p PERSISTENT SET h-bocx383.

        IF l-quebra-alterada THEN DO:
            RUN gerarAdicoes IN h-bocx383 (INPUT RowObject.num-di-ems,
                                           input RowObject.cdd-siscomex-dts).
            ASSIGN l-quebra-alterada = NO.
        END.

        DELETE PROCEDURE h-bocx383.
        ASSIGN h-bocx383 = ?.
        /* fim - atualiza as ordens que tiveram um ou mais campos da quebra alterados */
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeUpdateRecord DBOProgram 
PROCEDURE beforeUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    FOR FIRST bf{&TABLENAME} NO-LOCK
        WHERE bf{&TABLENAME}.num-di-ems  = RowObject.num-di-ems  
        AND   bf{&TABLENAME}.num-ordem   = RowObject.num-ordem   
        AND   bf{&TABLENAME}.num-parcela = RowObject.num-parcela 
        AND   bf{&TABLENAME}.cdd-siscomex-dts = RowObject.cdd-siscomex-dts :
        /*se a quantidade for menor que a anterior deve quebrar em uma nova parcela a ordem*/
        IF RowObject.qtd-item < bf{&TABLENAME}.qtd-item THEN
            RUN pi-quebra-ordens-embarque.
    END.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaValoresUnitImpostos DBOProgram 
PROCEDURE buscaValoresUnitImpostos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT  PARAM p-it-codigo       LIKE ITEM.it-codigo                   NO-UNDO.
DEF OUTPUT PARAM p-val-unit-ipi    LIKE decla-import-ord.val-unit-ipi    NO-UNDO.
DEF OUTPUT PARAM p-val-unit-pis    LIKE decla-import-ord.val-unit-pis    NO-UNDO.
DEF OUTPUT PARAM p-val-unit-cofins LIKE decla-import-ord.val-unit-cofins NO-UNDO.

FOR FIRST ITEM NO-LOCK
    WHERE ITEM.it-codigo = p-it-codigo,
    FIRST item-mat NO-LOCK
    WHERE item-mat.it-codigo = ITEM.it-codigo:

    ASSIGN p-val-unit-ipi    = ITEM.valor-ipi-beb
           p-val-unit-pis    = item-mat.val-unit-pis
           p-val-unit-cofins = item-mat.val-unit-cofins.
END.


RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE desvinculaOrdem DBOProgram 
PROCEDURE desvinculaOrdem :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    
    def input parameter pnumero-ordem like ordens-embarque.numero-ordem no-undo.
    def input parameter pparcela      like ordens-embarque.parcela      no-undo.

    DEF VAR c-num-di-ems        LIKE decla-import.num-di-ems NO-UNDO.
    DEF VAR c-cod-estab         LIKE decla-import-ord.cod-estab  NO-UNDO.
    DEF VAR c-cod-embarq        LIKE decla-import-ord.cod-embarq NO-UNDO.
    DEF VAR de-cdd-siscomex-dts-aux LIKE decla-import-ord.cdd-siscomex-dts NO-UNDO.

    IF NOT VALID-HANDLE(h-bocx383)  THEN RUN cxbo/bocx383.p  PERSISTENT SET h-bocx383.
    IF NOT VALID-HANDLE(h-bocx383a) THEN RUN cxbo/bocx383a.p PERSISTENT SET h-bocx383a.

    /*--- Elimina a decla-import-ord selecionada ---*/
    FOR FIRST {&TableName} EXCLUSIVE-LOCK
        WHERE {&TableName}.num-ordem   = pnumero-ordem
        AND   {&TableName}.num-parcela = pparcela:

        ASSIGN c-num-di-ems        = {&TableName}.num-di-ems
               c-cod-estab         = {&TableName}.cod-estab 
               c-cod-embarq        = {&TableName}.cod-embarq
               de-cdd-siscomex-dts-aux = {&TableName}.cdd-siscomex-dts.

        DELETE {&TableName}. /* Eliminou a Decla-import-ord relacionado a ordem do im0045a */
        
        FOR EACH decla-import-ord-trib EXCLUSIVE-LOCK
           WHERE decla-import-ord-trib.num-di-ems       = c-num-di-ems
             AND decla-import-ord-trib.num-ordem        = pnumero-ordem
             AND decla-import-ord-trib.num-parcela      = pparcela
             AND decla-import-ord-trib.cdd-siscomex-dts = de-cdd-siscomex-dts-aux:
            DELETE decla-import-ord-trib.
        END.
        
        FOR FIRST decla-import-embarq EXCLUSIVE-LOCK
            WHERE decla-import-embarq.cod-estab  = c-cod-estab 
            AND   decla-import-embarq.cod-embarq = c-cod-embarq: END.

        IF  NOT CAN-FIND(FIRST {&TableName}
                         WHERE {&TableName}.cod-estab  = decla-import-embarq.cod-estab
                         AND   {&TableName}.cod-embarq = decla-import-embarq.cod-embarq) THEN DO:

            FOR FIRST embarque-imp EXCLUSIVE-LOCK
                WHERE embarque-imp.cod-estabel = decla-import-embarq.cod-estab
                AND   embarque-imp.embarque    = decla-import-embarq.cod-embarq:

                ASSIGN embarque-imp.declaracao-import = ""
                       embarque-imp.data-di           = ?.

                &if '{&bf_mat_versao_ems}' >= '2.09' &then
                    ASSIGN embarque-imp.num-di-ems = 0.
                &else
                    ASSIGN embarque-imp.int-2 = 0.
                &endif
            END. /* FOR FIRST tt-embarque-imp-aux: */
            
            DELETE decla-import-embarq.
        END.

    END. /* FOR FIRST {&TableName} EXCLUSIVE-LOCK */
    RELEASE {&TableName}.

    /*--- Elimina os relacionamentos da DI ---*/
    RUN pi-deleta-relacs IN h-bocx383 (INPUT c-num-di-ems,
                                       input de-cdd-siscomex-dts-aux).
    IF  RETURN-VALUE = "NOK":U THEN DO:
        RUN getRowErrors     IN h-bocx383 (OUTPUT TABLE RowErrors).
        IF  CAN-FIND(FIRST RowErrors
                     WHERE RowErrors.ErrorsubType  = "Error":U
                     AND   RowErrors.ErrorType    <> "INTERNAL":U) THEN 
            RETURN "NOK":U.
    END. /* IF  RETURN-VALUE = "NOK":U THEN */

    IF  CAN-FIND(FIRST decla-import-embarq
                 WHERE decla-import-embarq.num-di-ems = c-num-di-ems
                   and decla-import-embarq.cdd-siscomex-dts = de-cdd-siscomex-dts) THEN DO:
        /*--- Gerando Adiá‰es e Itens da Adiá∆o, efetuando a quebra ... */
        RUN gerarAdicoes IN h-bocx383 (INPUT c-num-di-ems,
                                       input de-cdd-siscomex-dts).
        IF  RETURN-VALUE = "NOK":U THEN DO:
            RUN getRowErrors IN h-bocx383 (OUTPUT TABLE RowErrors).
            IF  CAN-FIND(FIRST RowErrors
                         WHERE RowErrors.ErrorsubType  = "Error":U
                         AND   RowErrors.ErrorType    <> "INTERNAL":U) THEN 
                RETURN "NOK":U.
        END. /* IF  RETURN-VALUE = "NOK":U THEN */
    
        /*--- Atualiza Logs da DI ---*/
        FIND FIRST decla-import EXCLUSIVE-LOCK 
            WHERE  decla-import.num-di-ems = c-num-di-ems 
              and  decla-import.cdd-siscomex-dts = de-cdd-siscomex-dts NO-ERROR.
        IF  AVAIL  decla-import THEN 
            ASSIGN decla-import.log-pend-rat          = NO  /*reabrindo rateio desp. Nacionalizaá∆o*/
                   decla-import.log-livre-2           = NO  /*reabrindo c†lculo dos impostos*/
            &if "{&bf_mat_versao_ems}" < "2.09" &then
                OVERLAY(decla-import.cod-livre-1,1,1) = "N" /*reabrindo rateio desp. Compl.*/
            &ELSE
                decla-import.log-pend-despes-compltar = NO /*reabrindo rateio desp. Compl.*/
            &ENDIF .
    END. /* IF  CAN-FIND(FIRST decla-import-embarq */
    
    RELEASE decla-import.

    DELETE PROCEDURE h-bocx383.
    ASSIGN h-bocx383 = ?.
    DELETE PROCEDURE h-bocx383a.
    ASSIGN h-bocx383a = ?.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findNatureza DBOProgram 
PROCEDURE findNatureza :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    def input parameter c-nat-operacao as char no-undo.
    
    if  c-nat-operacao = "" 
    then return 'NOK':U.
    else do:
        if can-find (first natur-oper where natur-oper.nat-operacao = c-nat-operacao) 
        then return 'OK':U.
        else return 'NOK':U.
    end. /* else do: */

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCharField DBOProgram 
PROCEDURE getCharField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo caracter
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-aladi":U THEN ASSIGN pFieldValue = RowObject.cod-aladi.
        WHEN "cod-embarq":U THEN ASSIGN pFieldValue = RowObject.cod-embarq.
        WHEN "cod-especif":U THEN ASSIGN pFieldValue = RowObject.cod-especif.
        WHEN "cod-estab":U THEN ASSIGN pFieldValue = RowObject.cod-estab.
        WHEN "cod-item":U THEN ASSIGN pFieldValue = RowObject.cod-item.
        WHEN "cod-licenc-import":U THEN ASSIGN pFieldValue = RowObject.cod-licenc-import.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-naladi-ncca":U THEN ASSIGN pFieldValue = RowObject.cod-naladi-ncca.
        WHEN "cod-natur-operac":U THEN ASSIGN pFieldValue = RowObject.cod-natur-operac.
        WHEN "cod-nbm":U THEN ASSIGN pFieldValue = RowObject.cod-nbm.
        WHEN "cod-tip-recip":U THEN ASSIGN pFieldValue = RowObject.cod-tip-recip.
        WHEN "cod-unid-med-fornec":U THEN ASSIGN pFieldValue = RowObject.cod-unid-med-fornec.
        WHEN "cod-unid-medid-item":U THEN ASSIGN pFieldValue = RowObject.cod-unid-medid-item.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDateField DBOProgram 
PROCEDURE getDateField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo data
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dat-livre-1":U THEN ASSIGN pFieldValue = RowObject.dat-livre-1.
        WHEN "dat-livre-2":U THEN ASSIGN pFieldValue = RowObject.dat-livre-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDecField DBOProgram 
PROCEDURE getDecField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo decimal
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "qtd-capac-recip":U THEN ASSIGN pFieldValue = RowObject.qtd-capac-recip.
        WHEN "qtd-fornec":U THEN ASSIGN pFieldValue = RowObject.qtd-fornec.
        WHEN "qtd-item":U THEN ASSIGN pFieldValue = RowObject.qtd-item.
        WHEN "val-aliq-cofins":U THEN ASSIGN pFieldValue = RowObject.val-aliq-cofins.
        WHEN "val-aliq-icms":U THEN ASSIGN pFieldValue = RowObject.val-aliq-icms.
        WHEN "val-aliq-ii":U THEN ASSIGN pFieldValue = RowObject.val-aliq-ii.
        WHEN "val-aliq-ipi":U THEN ASSIGN pFieldValue = RowObject.val-aliq-ipi.
        WHEN "val-aliq-pis":U THEN ASSIGN pFieldValue = RowObject.val-aliq-pis.
        WHEN "val-cub-tot":U THEN ASSIGN pFieldValue = RowObject.val-cub-tot.
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
        WHEN "val-perc-reduc-cofins":U THEN ASSIGN pFieldValue = RowObject.val-perc-reduc-cofins.
        WHEN "val-perc-reduc-icms":U THEN ASSIGN pFieldValue = RowObject.val-perc-reduc-icms.
        WHEN "val-perc-reduc-impto-import":U THEN ASSIGN pFieldValue = RowObject.val-perc-reduc-impto-import.
        WHEN "val-perc-reduc-ipi":U THEN ASSIGN pFieldValue = RowObject.val-perc-reduc-ipi.
        WHEN "val-perc-reduc-pis":U THEN ASSIGN pFieldValue = RowObject.val-perc-reduc-pis.
        WHEN "val-peso-brut-merc":U THEN ASSIGN pFieldValue = RowObject.val-peso-brut-merc.
        WHEN "val-peso-embal":U THEN ASSIGN pFieldValue = RowObject.val-peso-embal.
        WHEN "val-peso-liq":U THEN ASSIGN pFieldValue = RowObject.val-peso-liq.
        WHEN "val-unit-cofins":U THEN ASSIGN pFieldValue = RowObject.val-unit-cofins.
        WHEN "val-unit-icms":U THEN ASSIGN pFieldValue = RowObject.val-unit-icms.
        WHEN "val-unit-ii":U THEN ASSIGN pFieldValue = RowObject.val-unit-ii.
        WHEN "val-unit-ipi":U THEN ASSIGN pFieldValue = RowObject.val-unit-ipi.
        WHEN "val-unit-pis":U THEN ASSIGN pFieldValue = RowObject.val-unit-pis.
        WHEN "cdd-siscomex-dts":U THEN ASSIGN pFieldValue = RowObject.cdd-siscomex-dts.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getIntField DBOProgram 
PROCEDURE getIntField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo inteiro
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cdn-fabrican":U THEN ASSIGN pFieldValue = RowObject.cdn-fabrican.
        WHEN "cdn-fornec":U THEN ASSIGN pFieldValue = RowObject.cdn-fornec.
        WHEN "cdn-naladi-sist-harmon":U THEN ASSIGN pFieldValue = RowObject.cdn-naladi-sist-harmon.
        WHEN "cdn-pais-proceden":U THEN ASSIGN pFieldValue = RowObject.cdn-pais-proceden.
        WHEN "idi-ind-pagto":U THEN ASSIGN pFieldValue = RowObject.idi-ind-pagto.
        WHEN "idi-metod-val":U THEN ASSIGN pFieldValue = RowObject.idi-metod-val.
        WHEN "idi-tributac-cofins":U THEN ASSIGN pFieldValue = RowObject.idi-tributac-cofins.
        WHEN "idi-tributac-icms":U THEN ASSIGN pFieldValue = RowObject.idi-tributac-icms.
        WHEN "idi-tributac-impto-import":U THEN ASSIGN pFieldValue = RowObject.idi-tributac-impto-import.
        WHEN "idi-tributac-ipi":U THEN ASSIGN pFieldValue = RowObject.idi-tributac-ipi.
        WHEN "idi-tributac-pis":U THEN ASSIGN pFieldValue = RowObject.idi-tributac-pis.
        WHEN "num-adic":U THEN ASSIGN pFieldValue = RowObject.num-adic.
        WHEN "num-di-ems":U THEN ASSIGN pFieldValue = RowObject.num-di-ems.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "num-ordem":U THEN ASSIGN pFieldValue = RowObject.num-ordem.
        WHEN "num-parcela":U THEN ASSIGN pFieldValue = RowObject.num-parcela.
        WHEN "num-seq":U THEN ASSIGN pFieldValue = RowObject.num-seq.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice dclmprtr-id
  Parameters:  
               retorna valor do campo num-di-ems
               retorna valor do campo num-ordem
               retorna valor do campo num-parcela
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnum-di-ems LIKE decla-import-ord.num-di-ems NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-ordem LIKE decla-import-ord.num-ordem NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-parcela LIKE decla-import-ord.num-parcela NO-UNDO.
    DEFINE OUTPUT PARAMETER pcdd-siscomex-dts LIKE decla-import-ord.cdd-siscomex-dts NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnum-di-ems = RowObject.num-di-ems
           pnum-ordem = RowObject.num-ordem
           pnum-parcela = RowObject.num-parcela
           pcdd-siscomex-dts = RowObject.cdd-siscomex-dts.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogField DBOProgram 
PROCEDURE getLogField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo l¢gico
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "log-cofins-unid":U THEN ASSIGN pFieldValue = RowObject.log-cofins-unid.
        WHEN "log-emite-fabrican":U THEN ASSIGN pFieldValue = RowObject.log-emite-fabrican.
        WHEN "log-ipi-unid":U THEN ASSIGN pFieldValue = RowObject.log-ipi-unid.
        WHEN "log-livre-1":U THEN ASSIGN pFieldValue = RowObject.log-livre-1.
        WHEN "log-livre-2":U THEN ASSIGN pFieldValue = RowObject.log-livre-2.
        WHEN "log-pis-unid":U THEN ASSIGN pFieldValue = RowObject.log-pis-unid.
        WHEN "log-suspens-impto-import":U THEN ASSIGN pFieldValue = RowObject.log-suspens-impto-import.
        WHEN "log-suspens-ipi-import":U THEN ASSIGN pFieldValue = RowObject.log-suspens-ipi-import.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRawField DBOProgram 
PROCEDURE getRawField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo raw
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RAW NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice dclmprtr-id
  Parameters:  
               recebe valor do campo num-di-ems
               recebe valor do campo num-ordem
               recebe valor do campo num-parcela
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnum-di-ems  LIKE decla-import-ord.num-di-ems  NO-UNDO.
    DEFINE INPUT PARAMETER pnum-ordem   LIKE decla-import-ord.num-ordem   NO-UNDO.
    DEFINE INPUT PARAMETER pnum-parcela LIKE decla-import-ord.num-parcela NO-UNDO.
    DEFINE INPUT PARAMETER pcdd-siscomex-dts LIKE decla-import-ord.cdd-siscomex-dts NO-UNDO.

    FIND FIRST bfdecla-import-ord WHERE 
        bfdecla-import-ord.num-di-ems = pnum-di-ems AND 
        bfdecla-import-ord.num-ordem = pnum-ordem AND 
        bfdecla-import-ord.num-parcela = pnum-parcela AND
        bfdecla-import-ord.cdd-siscomex-dts = pcdd-siscomex-dts NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfdecla-import-ord THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfdecla-import-ord)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByDI DBOProgram 
PROCEDURE openQueryByDI :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
OPEN QUERY {&QUERYNAME} FOR EACH  {&TABLENAME} NO-LOCK
                            WHERE {&TABLENAME}.num-di-ems = i-num-di-ems 
                            AND   {&TABLENAME}.cdd-siscomex-dts = de-cdd-siscomex-dts
                            BY {&TABLENAME}.num-adic 
                            BY {&TABLENAME}.num-seq INDEXED-REPOSITION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByEmbarque DBOProgram 
PROCEDURE openQueryByEmbarque :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
OPEN QUERY {&QUERYNAME} FOR EACH  {&TABLENAME} 
                            WHERE {&TABLENAME}.cod-embarq = i-cod-embarq NO-LOCK INDEXED-REPOSITION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} NO-LOCK INDEXED-REPOSITION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-altera-natureza-ordens DBOProgram 
PROCEDURE pi-altera-natureza-ordens :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM pNumDiEms LIKE {&TABLENAME}.num-di-ems       NO-UNDO.
DEF INPUT PARAM pNatureza LIKE {&TABLENAME}.cod-natur-operac NO-UNDO.
DEF INPUT PARAM pCddSiscomexDts LIKE {&TABLENAME}.cdd-siscomex-dts NO-UNDO.
DEF INPUT PARAM pTipo     AS INTEGER                         NO-UNDO.

CASE pTipo:
    WHEN 2 THEN DO:
        FOR EACH bf{&TABLENAME} EXCLUSIVE-LOCK
            WHERE bf{&TABLENAME}.num-di-ems     = pNumDiEms
            AND   bf{&TABLENAME}.cod-natur-operac = pNatureza
            AND   bf{&TABLENAME}.cdd-siscomex-dts = pCddSiscomexDts,
            FIRST decla-import NO-LOCK
            WHERE decla-import.num-di-ems = bf{&TABLENAME}.num-di-ems
              AND decla-import.cdd-siscomex-dts = bf{&TABLENAME}.cdd-siscomex-dts:

            ASSIGN bf{&TABLENAME}.cod-natur-operac = decla-import.cod-natur-operac.

        END.       
    END.           
    WHEN 3 THEN DO:
        FOR EACH bf{&TABLENAME} EXCLUSIVE-LOCK
            WHERE bf{&TABLENAME}.num-di-ems     = pNumDiEms
              AND bf{&TABLENAME}.cdd-siscomex-dts = pCddSiscomexDts,
            FIRST decla-import NO-LOCK
            WHERE decla-import.num-di-ems = bf{&TABLENAME}.num-di-ems
              AND decla-import.cdd-siscomex-dts = bf{&TABLENAME}.cdd-siscomex-dts:

            ASSIGN bf{&TABLENAME}.cod-natur-operac = decla-import.cod-natur-operac.

        END.
    END.


END CASE.

RELEASE bf{&TABLENAME}.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-pagto-embarq DBOProgram 
PROCEDURE pi-atualiza-pagto-embarq :
/*------------------------------------------------------------------------------
  Purpose: Atualiza o embarque com a natureza cambial (pagamento) alterado na ordem da declaraá∆o de importaá∆o.     
  Parameters:  Recebe embarque, estabelecimento e c¢digo do pagamento da ordem da declaraá∆o de importaá∆o
  Notes:  O campo da tabela embarque tem apenas dois tipos de natureza cambial (1=Com Cobertura e 2=Sem Cobertura).
          Na ordem o campo indicativo de pagamento tem 4 tipos (1=AtÇ 180 dias, 2=De 181 atÇ 360, 3=Acima de 360 dias e 4=Sem Cobertura Cambial).     
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM pCodEmbarq   LIKE decla-import-ord.cod-embarq    NO-UNDO.
    DEF INPUT  PARAM pCodEstab    LIKE decla-import-ord.cod-estab     NO-UNDO.
    DEF INPUT  PARAM pidiIndPagto LIKE decla-import-ord.idi-ind-pagto NO-UNDO.

    /*Atualizar embarque*/
    FIND FIRST embarque-imp EXCLUSIVE-LOCK
         WHERE embarque-imp.cod-estabel = pCodEstab
           AND embarque-imp.embarque    = pCodEmbarq NO-ERROR.

    IF AVAIL embarque-imp THEN DO:
        IF pidiIndPagto = 4 /* Sem Cobertura Cambial */ THEN
             ASSIGN &IF '{&bf_mat_versao_ems}' >= '2.09' &THEN 
                        embarque-imp.idi-natur-cambial  = 2.
                    &ELSE 
                        embarque-imp.int-1 = 2.
                    &ENDIF
        ELSE
            ASSIGN  &IF '{&bf_mat_versao_ems}' >= '2.09' &THEN 
                        embarque-imp.idi-natur-cambial  = 1.
                    &ELSE 
                        embarque-imp.int-1 = 1.
                    &ENDIF.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-pagto-ordens DBOProgram 
PROCEDURE pi-atualiza-pagto-ordens :
/*------------------------------------------------------------------------------
  Purpose: Atualiza as ordens da declaraá∆o de importaá∆o com a natureza cambial do embarque     
  Parameters: pCodEmbarq        : INPUT : Embarque         do embarque de importaá∆o; 
              pCodEstab         : INPUT : Estabelecimento  do embarque de importaá∆o; 
              pidiNaturCambial  : INPUT : Natureza cambial do embarque de importaá∆o; 
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM pCodEmbarq       LIKE decla-import-ord.cod-embarq        NO-UNDO.
    DEF INPUT  PARAM pCodEstab        LIKE decla-import-ord.cod-estab         NO-UNDO.
    DEF INPUT  PARAM pidiNaturCambial LIKE decla-import-ord.idi-ind-pagto     NO-UNDO.
    
    FOR EACH decla-import-ord EXCLUSIVE-LOCK
       WHERE decla-import-ord.cod-embarq = pCodEmbarq
        AND  decla-import-ord.cod-estab  = pCodEstab:
        ASSIGN decla-import-ord.idi-ind-pagto = pidiNaturCambial.                     
    END.    

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-AtualizaOrdem DBOProgram 
PROCEDURE pi-AtualizaOrdem :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    for first ordens-embarque exclusive-lock
        where ordens-embarque.cod-estabel  = RowObject.cod-estab 
        and   ordens-embarque.embarque     = RowObject.cod-embarq
        and   ordens-embarque.numero-ordem = RowObject.num-ordem
        and   ordens-embarque.parcela      = RowObject.num-parcela:
        
        assign /*ordens-embarque.quantidade               = RowObject.qtd-item*/     /*ROGER (16/08/2011)- AS QUANTIDADES N«O DEVEM SER ATUALIZADAS POIS AS MESMAS DEVEM SER FEITAS NA PROCEDURE DE QUEBRA DAS ORDENS (pi-quebra-ordens-embarque)*/
               /*ordens-embarque.qt-do-forn               = RowObject.qtd-fornec*/
               ordens-embarque.val-cub-tot              = RowObject.val-cub-tot
               ordens-embarque.peso-liquido             = RowObject.val-peso-liq
               ordens-embarque.peso-bruto               = RowObject.val-peso-brut-merc
               ordens-embarque.idi-tributac-pis         = RowObject.idi-tributac-pis
               ordens-embarque.cd-trib-ipi              = RowObject.idi-tributac-ipi
               ordens-embarque.cd-trib-ii               = RowObject.idi-tributac-impto-import
               ordens-embarque.cd-trib-icms             = RowObject.idi-tributac-icms
               ordens-embarque.idi-tributac-cofins      = RowObject.idi-tributac-cofins
               ordens-embarque.log-suspens-impto-import = RowObject.log-suspens-impto-import
               ordens-embarque.log-suspens-ipi-import   = RowObject.log-suspens-ipi-import
               ordens-embarque.val-aliq-ext-pis         = RowObject.val-aliq-pis
               ordens-embarque.dec-1                    = RowObject.val-aliq-pis
               ordens-embarque.aliquota-ipi             = RowObject.val-aliq-ipi
               ordens-embarque.aliquota-ii              = RowObject.val-aliq-ii
               ordens-embarque.aliquota-icms            = RowObject.val-aliq-icms
               ordens-embarque.val-aliq-ext-cofins      = RowObject.val-aliq-cofins
               ordens-embarque.dec-2                    = RowObject.val-aliq-cofins
               OVERLAY(ordens-embarque.char-1,80,4)     = STRING(RowObject.num-seq) /*SEQ ITEM ADIC*/
               OVERLAY(ordens-embarque.char-1,105,8)    = STRING(RowObject.val-aliq-ii, ">>9.9999":U)
               &if '{&BF_MAT_VERSAO_EMS}'  >= "2.07" &then
                   ordens-embarque.num-adic                = RowObject.num-adic
               &else
                   OVERLAY(ordens-embarque.char-1,60,4)    = STRING(RowObject.num-adic) /*NUM-ADIC*/
               &endif
               
               .
    end. /* for each  ordens-embarque exclusive-lock */ 
    
    RELEASE ordens-embarque.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-calcula-qtd-fornec DBOProgram 
PROCEDURE pi-calcula-qtd-fornec :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-num-ordem     LIKE ordens-embarque.numero-ordem NO-UNDO.
    DEF INPUT PARAM p-it-codigo     LIKE item.it-codigo               NO-UNDO.
    DEF INPUT PARAM p-cod-emitente  LIKE emitente.cod-emitente        NO-UNDO.
    DEF INPUT PARAM p-qtd-item      LIKE ordens-embarque.quantidade   NO-UNDO.
    DEF OUTPUT PARAM p-qt-fornec    LIKE ordens-embarque.qt-do-forn   NO-UNDO.

    FOR FIRST cotacao-item
        WHERE cotacao-item.numero-ordem    = p-num-ordem
        AND cotacao-item.it-codigo         = p-it-codigo
        AND cotacao-item.cod-emitente      = p-cod-emitente
        AND cotacao-item.cot-aprovada NO-LOCK: 
        ASSIGN de-indice-conversao-fornec = fnGetItemVendorConversionFactor(p-it-codigo,p-cod-emitente, cotacao-item.un).
    END.
    
    IF de-indice-conversao-fornec = 1 THEN DO: /* N∆o encontrou fator de convers∆o */
       FIND CURRENT ordens-embarque EXCLUSIVE-LOCK NO-ERROR.  
       ASSIGN ordens-embarque.qt-do-forn = p-qtd-item
              p-qt-fornec                = p-qtd-item.        
    END.
    ELSE 
       ASSIGN p-qt-fornec = p-qtd-item * de-indice-conversao-fornec.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-deleta-relacs DBOProgram 
PROCEDURE pi-deleta-relacs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAM pnum-di-ems LIKE {&TableName}.num-di-ems NO-UNDO.
DEF INPUT PARAM pcdd-siscomex-dts LIKE {&TableName}.cdd-siscomex-dts NO-UNDO.

/*---[ Zera Sequencia da ordem ]-------------------------------------------------------------------------*/
FOR EACH bfdecla-import-ord EXCLUSIVE-LOCK WHERE bfdecla-import-ord.num-di-ems = pnum-di-ems
                                             and bfdecla-import-ord.cdd-siscomex-dts = pcdd-siscomex-dts:
    ASSIGN bfdecla-import-ord.num-adic = 0
           bfdecla-import-ord.num-seq  = 0.
END. /* FOR EACH   decla-import-adic-itens */

/*---[ Itens das Adiá‰es ]-------------------------------------------------------------------------*/
FOR EACH   decla-import-adic-itens EXCLUSIVE-LOCK WHERE decla-import-adic-itens.num-di-ems = pnum-di-ems
                                                    and decla-import-adic-itens.cdd-siscomex-dts = pcdd-siscomex-dts:
    DELETE decla-import-adic-itens validate(true, "").
END. /* FOR EACH   decla-import-adic-itens */

/* Reforma Tributaria */
FOR EACH   decla-imp-adic-it-trib EXCLUSIVE-LOCK WHERE decla-imp-adic-it-trib.num-di-ems = pnum-di-ems
                                                   and decla-imp-adic-it-trib.cdd-siscomex-dts = pcdd-siscomex-dts:
    DELETE decla-imp-adic-it-trib validate(true, "").
END.

/*---[ Documentos Vinculados ]---------------------------------------------------------------------*/
FOR EACH   decla-import-adic-docto EXCLUSIVE-LOCK WHERE decla-import-adic-docto.num-di-ems = pnum-di-ems
                                                    and decla-import-adic-docto.cdd-siscomex-dts = pcdd-siscomex-dts:
    DELETE decla-import-adic-docto validate(true, "").
END. /* FOR EACH   decla-import-adic-docto */

/*---[ NVE ]---------------------------------------------------------------------------------------*/
FOR EACH   decla-import-adic-nve EXCLUSIVE-LOCK WHERE decla-import-adic-nve.num-di-ems = pnum-di-ems
                                                  and decla-import-adic-nve.cdd-siscomex-dts = pcdd-siscomex-dts:
    DELETE decla-import-adic-nve validate(true, "").
END. /* FOR EACH   decla-import-adic-nve */

/*---[ Adiá‰es ]-----------------------------------------------------------------------------------*/
FOR EACH   decla-import-adic EXCLUSIVE-LOCK WHERE decla-import-adic.num-di-ems = pnum-di-ems
                                              and decla-import-adic.cdd-siscomex-dts = pcdd-siscomex-dts:
    DELETE decla-import-adic validate(true, "").
END. /* FOR EACH   decla-import-adic */

/* Reforma Tributaria */
FOR EACH   decla-import-adic-trib EXCLUSIVE-LOCK WHERE decla-import-adic-trib.num-di-ems = pnum-di-ems  
                                                   and decla-import-adic-trib.cdd-siscomex-dts = pcdd-siscomex-dts:
    DELETE decla-import-adic-trib validate(true, "").
END. 

/*---[ Despesas das Adiá‰es ]-----------------------------------------------------------------------------------*/
FOR EACH   despes-adic EXCLUSIVE-LOCK WHERE despes-adic.num-di-ems = pnum-di-ems
                                        and despes-adic.cdd-siscomex-dts = pcdd-siscomex-dts:
    DELETE despes-adic validate(true, "").
END. /* FOR EACH   decla-import-adic */

/*---[ Despesas dos Itens Adiá‰es ]-----------------------------------------------------------------------------------*/
FOR EACH   despes-adic-itens EXCLUSIVE-LOCK WHERE despes-adic-itens.num-di-ems = pnum-di-ems
                                              and despes-adic-itens.cdd-siscomex-dts = pcdd-siscomex-dts:
    DELETE despes-adic-itens validate(true, "").
END. /* FOR EACH   decla-import-adic */


/* verificar param */
FIND FIRST decla-import NO-LOCK
        WHERE decla-import.num-di-ems = pnum-di-ems 
          and decla-import.cdd-siscomex-dts = pcdd-siscomex-dts NO-ERROR.
FIND FIRST param-imp NO-LOCK
        WHERE param-imp.cod-estabel = decla-import.cod-estab NO-ERROR.

&if '{&bf_mat_versao_ems}' >= '2.07' &then
    ASSIGN l-utz-taxa-siscomex = param-imp.log-tax-siscomex
           i-cod-desp          = param-imp.cdn-despes-siscomex.
&else
    IF SUBSTRING(param-imp.char-1,105,1) = string(1) THEN
        ASSIGN l-utz-taxa-siscomex = YES.
    ELSE
        ASSIGN l-utz-taxa-siscomex = NO.
    ASSIGN i-cod-desp          = INTEGER(SUBSTRING(param-imp.char-1,91,5)).
&endif
 
IF l-utz-taxa-siscomex THEN DO:
    FIND FIRST despes-decla-import EXCLUSIVE-LOCK
            WHERE despes-decla-import.num-di-ems = pnum-di-ems
            AND   despes-decla-import.cdn-despes = i-cod-desp 
            and   despes-decla-import.cdd-siscomex-dts = pcdd-siscomex-dts NO-ERROR.
    IF AVAIL despes-decla-import THEN
        DELETE despes-decla-import.
END.


release bfdecla-import-ord.
release decla-import-adic-itens.
release decla-import-adic-docto.
release decla-import-adic-nve.
release decla-import-adic.
release despes-adic.
release despes-adic-itens.
RELEASE despes-decla-import.
RELEASE decla-import-adic-trib.
RELEASE decla-imp-adic-it-trib.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-quebra-ordens-embarque DBOProgram 
PROCEDURE pi-quebra-ordens-embarque :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /* Parametro de importaá∆o: relaciona ordens ou parcelas */ 
    RUN cxbo/bocx250.p  persistent set h-bocx250.
    RUN findCodigo IN h-bocx250 (input  RowObject.cod-estab,
                                 output c-return).
    IF c-return = "" THEN
       RUN retornarelaciona IN h-bocx250 (OUTPUT l-relaciona).           
    DELETE PROCEDURE h-bocx250.
    ASSIGN h-bocx250 = ?.

    IF NOT VALID-HANDLE(h-bocx225) THEN DO:
       RUN cxbo/bocx225.p persistent set h-bocx225.
    END.

    IF NOT VALID-HANDLE(h-boin356aa) THEN DO:
       RUN inbo/boin356aa.p persistent set h-boin356aa.
    END. 
    
    FOR FIRST embarque-imp NO-LOCK
        WHERE embarque-imp.embarque    = RowObject.cod-embarq
        AND   embarque-imp.cod-estabel = RowObject.cod-estab :   END.

    FOR FIRST ordens-embarque NO-LOCK
        WHERE ordens-embarque.numero-ordem = RowObject.num-ordem
        AND   ordens-embarque.parcela      = RowObject.num-parcela
        AND   ordens-embarque.cod-estabel  = RowObject.cod-estab
        AND   ordens-embarque.embarque     = RowObject.cod-embarq :

        EMPTY TEMP-TABLE tt-ordens-embarque.
        CREATE tt-ordens-embarque.
        BUFFER-COPY ordens-embarque TO tt-ordens-embarque.
        ASSIGN tt-ordens-embarque.quantidade = RowObject.qtd-item
               tt-ordens-embarque.qt-do-forn = RowObject.qtd-fornec.

               ASSIGN de-quant-orig    = ordens-embarque.quantidade
                      r-rowid-embarque = ROWID(ordens-embarque).

        RUN validateUpdate    IN h-bocx225 (INPUT TABLE tt-ordens-embarque,
                                            INPUT  r-rowid-embarque,
                                            OUTPUT TABLE RowErrors).

    END.
   
    ASSIGN de-quant-disp = de-quant-orig - RowObject.qtd-item.
    
    IF l-relaciona = NO THEN DO:

        RUN validavinculacaoordens IN h-bocx225 (INPUT RowObject.cod-embarq,
                                                 INPUT RowObject.cod-estab,
                                                 INPUT RowObject.num-ordem,
                                                 INPUT 0, /*quando o tratamento est† por ordem-compra pois nao tem a parcela na tt-ordem-compra*/
                                                 OUTPUT TABLE RowErrors APPEND).

        IF NOT CAN-FIND(FIRST RowErrors) THEN DO:
            RUN imp/im0410aa.w PERSISTENT SET h-im0410aa(input RowObject.num-ordem,
                                                         input RowObject.cod-item,
                                                         input de-quant-disp /*RowObject.qtd-item*/ ,
                                                         input RowObject.cod-unid-medid-item,
                                                         input RowObject.qtd-fornec,
                                                         input RowObject.cod-unid-med-fornec,
                                                         input this-procedure).

            IF  VALID-HANDLE (h-im0410aa) THEN DO:
                RUN initializeInterface IN h-im0410aa.
                WAIT-FOR CLOSE OF h-im0410aa FOCUS CURRENT-WINDOW.                
            END. 

            IF de-quant-embarq <= de-quant-disp AND
               de-quant-embarq > 0 THEN DO:

                ASSIGN  v-cod-estabel   = RowObject.cod-estab
                        v-qtde-emb      = de-quant-embarq
                        v-qtde-n-emb    = (de-quant-orig - RowObject.qtd-item).
                  
                RUN RetornaDataParcelaNaoEmbarcada IN h-bocx225 (input  RowObject.cod-estab  ,
                                                                 input  RowObject.cod-embarq ,
                                                                 input  RowObject.num-ordem  ,
                                                                 output dt-entrega).        
                  
                RUN imp/im9997.p(INPUT  v-cod-estabel ,
                                 INPUT  de-quant-orig, 
                                 INPUT  v-qtde-n-emb  ,
                                 INPUT  dt-entrega,
                                 OUTPUT v-nova-entrega,
                                 OUTPUT v-retorno).

                IF v-retorno = "NOK" or v-nova-entrega = ? THEN DO:
                    ASSIGN de-quant-embarq = 0.
                    FOR FIRST ordens-embarque NO-LOCK
                        WHERE ordens-embarque.numero-ordem = RowObject.num-ordem
                        AND   ordens-embarque.parcela      = RowObject.num-parcela
                        AND   ordens-embarque.cod-estabel  = RowObject.cod-estab
                        AND   ordens-embarque.embarque     = RowObject.cod-embarq :
                
                        EMPTY TEMP-TABLE tt-ordens-embarque.
                        CREATE tt-ordens-embarque.
                        BUFFER-COPY ordens-embarque TO tt-ordens-embarque.
                        ASSIGN tt-ordens-embarque.quantidade = de-quant-orig
                               tt-ordens-embarque.qt-do-forn = de-quant-orig.
                               ASSIGN r-rowid-embarque = ROWID(ordens-embarque).
                
                        RUN validateUpdate    IN h-bocx225 (INPUT TABLE tt-ordens-embarque,
                                                            INPUT  r-rowid-embarque,
                                                            OUTPUT TABLE RowErrors).
                
                    END.   
                    ASSIGN RowObject.qtd-item = de-quant-orig.
                END.
                ELSE DO:
                    RUN RetornaDataEntregaNovaParcela in h-boin356aa (input  v-cod-estabel,
                                                                      input  RowObject.num-ordem,
                                                                      input  v-nova-entrega,
                                                                      output d-entrega).
                    if d-entrega = ? then.
                    else assign v-nova-entrega = d-entrega.  

                    run setCreatehist in h-bocx225.                
                    
                    ASSIGN i-numero-ordem = RowObject.num-ordem.
                    RUN ValidaNovaDataEntrega.
                                        
                    IF NOT CAN-FIND(FIRST RowErrors)  THEN DO:
                       RUN setQuebraOrdensDi IN h-bocx225(INPUT YES).
                       RUN createOrdensEmbarqueNovaParcela IN h-bocx225 (input ROWID(embarque-imp),
                                                                         input RowObject.num-ordem,
                                                                         input de-quant-embarq,
                                                                         input v-qtde-emb,
                                                                         input v-nova-entrega,
                                                                         output table RowErrors APPEND).
                    END.   


                    IF CAN-FIND(FIRST RowErrors) THEN DO:
                       RETURN "NOK":U.
                    END.
                    ELSE DO:      
                        RUN cria-nova-parcela-by-ordem-2 in h-boin356aa (input embarque-imp.cod-estabel,
                                                                         input RowObject.num-ordem   ,
                                                                         input de-quant-embarq    ,
                                                                         input embarque-imp.embarque ,
                                                                         input v-qtde-emb            ,
                                                                         input v-qtde-n-emb          ,
                                                                         input v-nova-entrega        ,
                                                                         output v-nova-parcela       ).


                        /* Inicio -- Projeto Internacional */
                        DEFINE VARIABLE c-lbl-liter-foi-gerado-nova-parcela-para-a AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "Foi_gerado_nova_parcela_para_a_ordem_de_compra_com_o_saldo_da_quantidade,_esta_nova_parcela_n∆o_ser†_vinculada_automaticamente_a_Declaraá∆o_de_Importaá∆o" *}
                        ASSIGN c-lbl-liter-foi-gerado-nova-parcela-para-a = TRIM(RETURN-VALUE).
                        {method/svc/errors/inserr.i &ErrorNumber="19085"
                                                    &ErrorType="EMS":U
                                                    &ErrorParameters="c-lbl-liter-foi-gerado-nova-parcela-para-a + '.'"}
                                                    
                        DELETE PROCEDURE h-boin356aa.
                        ASSIGN h-boin356aa = ?.
                    END.
                END.
            END.
            ELSE DO:
                /*{method/svc/errors/inserr.i &ErrorNumber="17006"
                                            &ErrorType="EMS":U
                                            &ErrorParameters="'Quebra da quantidade cancelada!' + '~~~~' + 'A quebra da quantidade para uma nova parcela n∆o foi efetivada!'"}*/
                FOR FIRST ordens-embarque NO-LOCK
                    WHERE ordens-embarque.numero-ordem = RowObject.num-ordem
                    AND   ordens-embarque.parcela      = RowObject.num-parcela
                    AND   ordens-embarque.cod-estabel  = RowObject.cod-estab
                    AND   ordens-embarque.embarque     = RowObject.cod-embarq :
            
                    EMPTY TEMP-TABLE tt-ordens-embarque.
                    CREATE tt-ordens-embarque.
                    BUFFER-COPY ordens-embarque TO tt-ordens-embarque.
                    ASSIGN tt-ordens-embarque.quantidade = de-quant-orig
                           tt-ordens-embarque.qt-do-forn = de-quant-orig.
                           ASSIGN r-rowid-embarque = ROWID(ordens-embarque).
            
                    RUN validateUpdate    IN h-bocx225 (INPUT TABLE tt-ordens-embarque,
                                                        INPUT  r-rowid-embarque,
                                                        OUTPUT TABLE RowErrors).
            
                END.   

                ASSIGN RowObject.qtd-item = de-quant-orig.
            END.
        END.
    END.

    DELETE PROCEDURE h-bocx225.
    ASSIGN h-bocx225 =?.

    IF VALID-HANDLE(h-im0410aa) THEN DO:
        DELETE PROCEDURE h-im0410aa.
        ASSIGN h-im0410aa = ?.
    END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-saldos-di DBOProgram 
PROCEDURE pi-saldos-di :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnum-di-ems       LIKE {&tableName}.num-di-ems       NO-UNDO.
    DEFINE INPUT PARAMETER pcdd-siscomex-dts LIKE {&tableName}.cdd-siscomex-dts NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-saldo-di.

    EMPTY TEMP-TABLE tt-saldo-di.

    FOR EACH {&tableName} NO-LOCK
       WHERE {&tableName}.num-di-ems       = pnum-di-ems
         AND {&tableName}.cdd-siscomex-dts = pcdd-siscomex-dts,
       FIRST prazo-compra
       WHERE prazo-compra.numero-ordem = {&tableName}.num-ordem
         AND prazo-compra.parcela = {&tableName}.num-parcela:

        CREATE tt-saldo-di.
        BUFFER-COPY {&tableName} TO tt-saldo-di.
        BUFFER-COPY prazo-compra TO tt-saldo-di.

        ASSIGN tt-saldo-di.quant-alocada = prazo-compra.dec-1
               tt-saldo-di.quant-saldo = 0
               tt-saldo-di.r-rowid = ROWID({&tableName}).

        FOR EACH b-prazo-compra FIELDS(numero-ordem situacao quant-saldo) NO-LOCK
           WHERE b-prazo-compra.numero-ordem = {&tableName}.num-ordem
             AND b-prazo-compra.parcela = {&tableName}.num-parcela
             AND b-prazo-compra.situacao <> 4:
            ASSIGN tt-saldo-di.quant-saldo = tt-saldo-di.quant-saldo + b-prazo-compra.quant-saldo.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seta-l-quebra-alterada DBOProgram 
PROCEDURE pi-seta-l-quebra-alterada :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
     DEF INPUT PARAM pAlterada AS LOGICAL NO-UNDO.

     ASSIGN l-quebra-alterada = pAlterada.

     RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-saldo-positivo DBOProgram 
PROCEDURE pi-verifica-saldo-positivo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER  pnum-di-ems     LIKE {&tableName}.num-di-ems NO-UNDO.
    define input parameter  pcdd-siscomex-dts LIKE {&tableName}.cdd-siscomex-dts NO-UNDO.
    DEFINE OUTPUT PARAMETER psaldo-positivo AS LOGICAL                   NO-UNDO.    

    check_block:
    FOR EACH {&tableName} FIELDS(num-di-ems num-ordem num-parcela cdd-siscomex-dts) NO-LOCK
       WHERE {&tableName}.num-di-ems = pnum-di-ems
         and {&tableName}.cdd-siscomex-dts = pcdd-siscomex-dts,
       EACH prazo-compra FIELDS(numero-ordem situacao quant-saldo parcela) NO-LOCK
       WHERE prazo-compra.numero-ordem = {&tableName}.num-ordem
         AND prazo-compra.parcela = {&tableName}.num-parcela
         AND prazo-compra.situacao <> 4:
        IF prazo-compra.quant-saldo > 0 THEN DO:
            ASSIGN psaldo-positivo = YES.
            LEAVE check_block.
        END.
    END.
                  
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piContaRegistro DBOProgram 
PROCEDURE piContaRegistro :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    
    def  input param pnum-di-ems    like decla-import-ord.num-di-ems no-undo.
    def  input param pcdd-siscomex-dts like decla-import-ord.cdd-siscomex-dts no-undo.
    def output param pnum-registros as   integer no-undo.

    def var i-conta as integer no-undo.

    assign i-conta = 0.

    for each  bf{&TABLENAME} no-lock 
        where bf{&TABLENAME}.num-di-ems = pnum-di-ems
          AND bf{&TABLENAME}.cdd-siscomex-dts = pcdd-siscomex-dts:
        assign i-conta = i-conta + 1.
    end. /* for each  decla-import-ord */

    assign pnum-registros = i-conta.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retorna-ordens-embarq DBOProgram 
PROCEDURE retorna-ordens-embarq :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT  PARAM pCodEmbarq LIKE decla-import-adic-itens.cod-embarq NO-UNDO.
DEF INPUT  PARAM pCodEstab  LIKE decla-import-adic-itens.cod-estab  NO-UNDO.
DEF INPUT  PARAM pNumDiEms  LIKE decla-import-adic-itens.num-di-ems NO-UNDO.
DEF INPUT  PARAM pCddSiscomexDts  LIKE decla-import-adic-itens.cdd-siscomex-dts NO-UNDO.
DEF OUTPUT PARAM TABLE FOR RowObjectAux.

EMPTY TEMP-TABLE RowObjectAux.

FOR EACH  decla-import-ord NO-LOCK
    WHERE decla-import-ord.num-di-ems = pNumDiEms
    AND   decla-import-ord.cod-embarq = pCodEmbarq                                     
    AND   decla-import-ord.cod-estab  = pCodEstab
    AND   decla-import-ord.cdd-siscomex-dts  = pCddSiscomexDts:
    IF NOT CAN-FIND(FIRST RowObjectAux 
                    WHERE RowObjectAux.num-di-ems    = decla-import-ord.num-di-ems    
                    AND   RowObjectAux.num-ordem     = decla-import-ord.num-ordem     
                    AND   RowObjectAux.num-parcela   = decla-import-ord.num-parcela
                    and   RowObjectAux.cdd-siscomex-dts = decla-import-ord.cdd-siscomex-dts) THEN DO:
        CREATE RowObjectAux.
        BUFFER-COPY decla-import-ord TO RowObjectAux.
    END.                    
END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaClassFisc DBOProgram 
PROCEDURE retornaClassFisc :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    
    def input  param p-num-ordem  like ordem-compra.numero-ordem.
    def output param p-class-fisc like item.class-fiscal.

    for first ordem-compra where
              ordem-compra.numero-ordem = p-num-ordem no-lock:
    
        find first item no-lock
             where item.it-codigo = ordem-compra.it-codigo no-error.

        if avail item and item.tipo-contr = 4 then do:
            
            find first cotacao-item   
                 where cotacao-item.numero-ordem = ordem-compra.numero-ordem
                   and cotacao-item.cot-aprovada = yes no-lock no-error.  
            if avail cotacao-item then 
                assign p-class-fisc = substring(cotacao-item.char-1,81,20).
            else 
                assign p-class-fisc = item.class-fiscal.
        end.
        else if avail item then
            assign p-class-fisc = item.class-fiscal.
        else
            assign p-class-fisc = "".        
    end.
    
    return "OK":U .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaDados-incoterm DBOProgram 
PROCEDURE retornaDados-incoterm :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    def  input param pcod-estab    like decla-import-ord.cod-estab   no-undo.
    def  input param pcod-embarq   like decla-import-ord.cod-embarq  no-undo.
    def  input param pnum-ordem    like decla-import-ord.num-ordem   no-undo.
    def  input param pnum-parcela  like decla-import-ord.num-parcela no-undo.
    def output param pincoterm-aux like embarque-imp.cod-incoterm    no-undo.
    def output param pdesc-incoterm-aux as character format 'x(40)'  no-undo.

    find first embarque-imp no-lock
        where  embarque-imp.cod-estabel = pcod-estab
        and    embarque-imp.embarque    = pcod-embarq no-error.
    if  avail  embarque-imp then do:
        assign pincoterm-aux = embarque-imp.cod-incoterm.

        find first inco-cx no-lock
            where  inco-cx.cod-incoterm = embarque-imp.cod-incoterm no-error.
        if  avail  inco-cx 
        then assign pdesc-incoterm-aux = inco-cx.descricao.
        else assign pdesc-incoterm-aux = "".
    end. /* for first embarque-imp */
    else assign pincoterm-aux      = ""
                pdesc-incoterm-aux = "".

    RETURN 'OK':U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaDados-tela DBOProgram 
PROCEDURE retornaDados-tela :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    def  input param pcod-estab                 like {&TableName}.cod-estab        no-undo.
    def  input param pcod-embarq                like {&TableName}.cod-embarq       no-undo.
    def  input param pnum-ordem                 like {&TableName}.num-ordem        no-undo.
    def  input param pnum-parcela               like {&TableName}.num-parcela      no-undo.
    def  input param pnat-operacao              like {&TableName}.cod-natur-operac no-undo.
    def output param ptrib-ii-i1                AS   INTEGER NO-UNDO.                 
    def output param ptrib-ipi-i1               AS   INTEGER NO-UNDO.                 
    def output param ptrib-icms-i1              AS   INTEGER NO-UNDO.                 
    def output param ptrib-pis-i1               AS   INTEGER NO-UNDO.                 
    def output param ptrib-cofins-i1            AS   INTEGER NO-UNDO.                 
    def output param pde-aliq-ii-i1             AS   DECIMAL FORMAT ">>9.99" NO-UNDO. 
    def output param pde-aliq-ipi-i1            AS   DECIMAL FORMAT ">>9.99" NO-UNDO. 
    def output param pde-aliq-icms-i1           AS   DECIMAL FORMAT ">>9.99" NO-UNDO. 
    def output param pde-aliq-pis-i1            AS   DECIMAL FORMAT ">>9.9999" NO-UNDO. 
    def output param pde-aliq-cofins-i1         AS   DECIMAL FORMAT ">>9.9999" NO-UNDO. 
    def output param psuspensoII                AS logical NO-UNDO. 
    def output param psuspensoIPI               AS logical NO-UNDO. 
    DEF OUTPUT PARAM psuspensoICMS              AS LOGICAL NO-UNDO.
    DEF OUTPUT PARAM psuspensoPIS               AS LOGICAL NO-UNDO.
    DEF OUTPUT PARAM psuspensoCOFINS            AS LOGICAL NO-UNDO.
    DEF OUTPUT PARAM ptrib-cbs                  AS CHARACTER NO-UNDO.
    DEF OUTPUT PARAM ptrib-ibs-uf               AS CHARACTER NO-UNDO.
    DEF OUTPUT PARAM ptrib-ibs-mun              AS CHARACTER NO-UNDO.
    DEF OUTPUT param pde-aliq-cbs               AS DECIMAL FORMAT ">>9.99" NO-UNDO. 
    DEF OUTPUT param pde-aliq-ibs-uf            AS DECIMAL FORMAT ">>9.99" NO-UNDO. 
    DEF OUTPUT param pde-aliq-ibs-mun           AS DECIMAL FORMAT ">>9.99" NO-UNDO. 
    DEF OUTPUT param pde-aliq-red-cbs           AS DECIMAL FORMAT ">>9.99" NO-UNDO. 
    DEF OUTPUT param pde-aliq-red-ibs-uf        AS DECIMAL FORMAT ">>9.99" NO-UNDO.     
    DEF OUTPUT param pde-aliq-red-ibs-mun       AS DECIMAL FORMAT ">>9.99" NO-UNDO.     
    DEF OUTPUT PARAM pcClassTribCBS             AS CHAR    NO-UNDO.
    DEF OUTPUT PARAM pcClassTribIBS-UF          AS CHAR    NO-UNDO.
    DEF OUTPUT PARAM pcClassTribIBS-Mun         AS CHAR    NO-UNDO.
    DEF OUTPUT PARAM pcCST-CBS                  AS CHAR    NO-UNDO.
    DEF OUTPUT PARAM pcCST-IBS-UF               AS CHAR    NO-UNDO.
    DEF OUTPUT PARAM pcCST-IBS-Mun              AS CHAR    NO-UNDO.
    DEF OUTPUT PARAM pcCalssTribREG-CBS         AS CHAR    NO-UNDO.
    DEF OUTPUT PARAM pcCST-REG-CBS              AS CHAR    NO-UNDO.
    DEF OUTPUT PARAM pdeAliqEfetivaREG-CBS      AS DECIMAL FORMAT ">>9.99" NO-UNDO.    
    DEF OUTPUT PARAM pcCalssTribREG-IBS-UF      AS CHAR    NO-UNDO.
    DEF OUTPUT PARAM pcCST-REG-IBS-UF           AS CHAR    NO-UNDO.
    DEF OUTPUT PARAM pdeAliqEfetivaREG-IBS-UF   AS DECIMAL FORMAT ">>9.99" NO-UNDO.
    DEF OUTPUT PARAM pcCalssTribREG-IBS-Mun     AS CHAR    NO-UNDO.
    DEF OUTPUT PARAM pcCST-REG-IBS-Mun          AS CHAR    NO-UNDO.
    DEF OUTPUT PARAM pdeAliqEfetivaREG-IBS-Mun  AS DECIMAL FORMAT ">>9.99" NO-UNDO.
    DEF OUTPUT PARAM pcClassTribIS              AS CHAR NO-UNDO.   //IS
    DEF OUTPUT PARAM pcCST-IS                   AS CHAR NO-UNDO.
    DEF OUTPUT PARAM ptrib-is                   AS CHAR NO-UNDO.
    DEF OUTPUT PARAM pde-aliq-is                AS DECIMAL FORMAT ">>>9.9999" NO-UNDO.
    DEF OUTPUT PARAM pde-aliq-un-is             AS DECIMAL FORMAT ">>>9.9999" NO-UNDO.
    DEF OUTPUT PARAM pde-qtde-trib-is           AS DECIMAL FORMAT ">>>>>,>>9.9999" NO-UNDO.
    DEF OUTPUT PARAM pc-un-trib-is              AS CHAR NO-UNDO.

    IF NOT VALID-HANDLE(h-bocx225)  THEN RUN cxbo/bocx225.p  PERSISTENT SET h-bocx225.
    IF NOT VALID-HANDLE(h-bocx225e) THEN RUN cxbo/bocx225e.p PERSISTENT SET h-bocx225e.
    
    /*run setConstraint4 in h-bocx225 (input pcod-embarq, input pcod-estab).
    run OpenQuery      in h-bocx225 (input 4).
    run findFirst      in h-bocx225.
    run serverSendRows in h-bocx225 (input ?, input ?, input no, input ?, output iRowsReturned, output table tt-ordens-embarque).*/

    FOR FIRST ordens-embarque NO-LOCK
        WHERE ordens-embarque.cod-estabel  = pcod-estab      
        AND   ordens-embarque.embarque     = pcod-embarq     
        AND   ordens-embarque.numero-ordem = pnum-ordem      
        AND   ordens-embarque.parcela      = pnum-parcela   :
        EMPTY TEMP-TABLE tt-ordens-embarque. 
        CREATE tt-ordens-embarque.
        BUFFER-COPY ordens-embarque TO tt-ordens-embarque.
    END.                                                     
    
    if  can-find(first tt-ordens-embarque) then
        RUN loadOrdensDesemb IN h-bocx225e (INPUT TABLE tt-ordens-embarque,         /* tt-ordens-embarque */
                                            INPUT pnat-operacao,                    /* nat-operacao       */
                                            INPUT c-seg-usuario,                    /* usuario            */ 
                                            INPUT NO,                               /* recarrega          */
                                            INPUT NO,                               /* icms-diferido      */
                                            INPUT NO,                               /* total              */
                                            INPUT NO,                               /* recarrega-II       */
                                            INPUT NO,                               /* recarrega-ipi      */
                                            INPUT NO,                               /* recarrega-icms     */
                                            INPUT NO,                               /* recarrega-pis      */
                                            INPUT NO,                               /* recarrega-cof      */
                                            INPUT NO,                               /* recarrega IBS UF   */
                                            INPUT NO,                               /* recarrega IBS Mun  */
                                            INPUT NO,                               /* recarrega CBS      */
                                            INPUT NO,                               /* recarrega IS       */
                                            INPUT NO,   /* peso-bruto   */          /* recarrega-p-bruto  */
                                            INPUT NO,   /* peso-liquido */          /* recarrega-p-liqui  */
                                            INPUT NO,   /* cubagem      */          /* recarrega-cubagem  */
                                            OUTPUT TABLE tt-ordens-desemb,          /* tt-ordens-desemb   */
                                            OUTPUT TABLE tt-bo-erro).               /* tt-bo-erro         */
    
    FOR FIRST tt-ordens-desemb 
        WHERE tt-ordens-desemb.cod-estabel  = pcod-estab
        AND   tt-ordens-desemb.embarque     = pcod-embarq
        AND   tt-ordens-desemb.numero-ordem = pnum-ordem
        AND   tt-ordens-desemb.parcela      = pnum-parcela:

        ASSIGN ptrib-ii-i1        = tt-ordens-desemb.i-trib-ii
               ptrib-ipi-i1       = tt-ordens-desemb.i-trib-ipi
               ptrib-icms-i1      = tt-ordens-desemb.i-trib-icms
               ptrib-pis-i1       = tt-ordens-desemb.i-trib-pis
               ptrib-cofins-i1    = tt-ordens-desemb.i-trib-cofins
               pde-aliq-ii-i1     = tt-ordens-desemb.de-aliq-ii
               pde-aliq-ipi-i1    = tt-ordens-desemb.de-aliq-ipi
               pde-aliq-icms-i1   = tt-ordens-desemb.de-aliq-icms
               pde-aliq-pis-i1    = tt-ordens-desemb.de-aliq-pis
               pde-aliq-cofins-i1 = tt-ordens-desemb.de-aliq-cofins.
    
        
        FIND FIRST natur-oper NO-LOCK
                WHERE natur-oper.nat-operacao = pnat-operacao NO-ERROR.
        assign psuspensoII     = tt-ordens-desemb.l-suspensao-II
               psuspensoIPI    = tt-ordens-desemb.l-suspensao-IPI.
               

        &if '{&bf_mat_versao_ems}' >= '2.09' &then
        ASSIGN psuspensoICMS   = IF SUBSTRING(natur-oper.char-1,156,1) = '1' THEN YES ELSE NO
               psuspensoPIS    = NO
               psuspensoCOFINS = NO.
    &else
        ASSIGN psuspensoICMS   = IF SUBSTRING(natur-oper.char-1,156,1) = '1' THEN YES ELSE NO
               psuspensoPIS    = NO 
               psuspensoCOFINS = NO.
    &endif
    
        IF l-nt2024002 THEN DO:
            ASSIGN ptrib-cbs                 = tt-ordens-desemb.c-trib-CBS
                   ptrib-ibs-uf              = tt-ordens-desemb.c-trib-IBSUF
                   ptrib-ibs-mun             = tt-ordens-desemb.c-trib-IBSMun
                   pde-aliq-cbs              = tt-ordens-desemb.de-aliq-CBS
                   pde-aliq-ibs-uf           = tt-ordens-desemb.de-aliq-IBSUF
                   pde-aliq-ibs-mun          = tt-ordens-desemb.de-aliq-IBSMun
                   pde-aliq-red-cbs          = tt-ordens-desemb.de-aliq-red-CBS
                   pde-aliq-red-ibs-uf       = tt-ordens-desemb.de-aliq-red-IBSUF
                   pde-aliq-red-ibs-mun      = tt-ordens-desemb.de-aliq-red-IBSMun
                   pcClassTribCBS            = tt-ordens-desemb.cClassTrib-CBS
                   pcClassTribIBS-UF         = tt-ordens-desemb.cClassTrib-IBSUF
                   pcClassTribIBS-Mun        = tt-ordens-desemb.cClassTrib-IBSMun
                   pcCST-CBS                 = tt-ordens-desemb.cCST-CBS
                   pcCST-IBS-UF              = tt-ordens-desemb.cCST-IBSUF
                   pcCST-IBS-Mun             = tt-ordens-desemb.cCST-IBSMun
                   pcCalssTribREG-CBS        = tt-ordens-desemb.cClassTribReg-CBS
                   pcCST-REG-CBS             = tt-ordens-desemb.cCSTReg-CBS
                   pdeAliqEfetivaREG-CBS     = tt-ordens-desemb.de-aliq-Reg-CBS
                   pcCalssTribREG-IBS-UF     = tt-ordens-desemb.cClassTribReg-IBSUF
                   pcCST-REG-IBS-UF          = tt-ordens-desemb.cCSTReg-IBSUF
                   pdeAliqEfetivaREG-IBS-UF  = tt-ordens-desemb.de-aliq-Reg-IBSUF
                   pcCalssTribREG-IBS-Mun    = tt-ordens-desemb.cClassTribReg-IBSMun
                   pcCST-REG-IBS-Mun         = tt-ordens-desemb.cCSTReg-IBSMun
                   pdeAliqEfetivaREG-IBS-Mun = tt-ordens-desemb.de-aliq-Reg-IBSMun
                   pcClassTribIS             = tt-ordens-desemb.cClassTrib-IS 
                   pcCST-IS                  = tt-ordens-desemb.cCST-IS
                   ptrib-is                  = tt-ordens-desemb.c-trib-IS
                   pde-aliq-is               = tt-ordens-desemb.de-aliq-IS
                   pde-aliq-un-is            = tt-ordens-desemb.de-aliq-espec-IS
                   pde-qtde-trib-is          = tt-ordens-desemb.de-qtde-trib-IS
                   pc-un-trib-is             = tt-ordens-desemb.c-un-trib-IS.
        END.
    END. /* FOR FIRST tt-ordens-desemb */

    DELETE PROCEDURE h-bocx225.
    ASSIGN h-bocx225 = ?.
    DELETE PROCEDURE h-bocx225e.
    ASSIGN h-bocx225e = ?.

    RETURN 'OK':U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaDadosItem DBOProgram 
PROCEDURE retornaDadosItem :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    def  input param pcod-estabel like ordens-embarque.cod-estabel  no-undo.
    def  input param pcod-embarq  like ordens-embarque.embarque no-undo.
    def  input param pnum-ordem   like ordens-embarque.numero-ordem no-undo.
    def  input param pparcela     like ordens-embarque.parcela no-undo.
    def  input param pcod-item    like item.it-codigo no-undo.
    def output param pqtde-item   like ordens-embarque.quantidade no-undo.
    def output param pun-item     like item.un no-undo.
    def output param pclass-fisc  like classif-fisc.class-fiscal no-undo.
    def output param pcod-ncm     as integer no-undo.
    def output param pdesc-class  like classif-fisc.descricao no-undo.
    def output param pvucv-forn   like ordem-compra.pre-unit-for no-undo.
    def output param pmo-codigo   like ordem-compra.mo-codigo no-undo.
    def output param ppeso-bruto  like item.peso-bruto no-undo.
    def output param ppeso-liquido like item.peso-liquido no-undo.
    def output param plog-necessita-li like item.log-necessita-li no-undo.
    
    for first ordens-embarque no-lock
        where ordens-embarque.cod-estabel  = pcod-estabel
        and   ordens-embarque.embarque     = pcod-embarq
        and   ordens-embarque.numero-ordem = pnum-ordem
        and   ordens-embarque.parcela      = pparcela,
        first ordem-compra no-lock
        where ordem-compra.numero-ordem = ordens-embarque.numero-ordem,
        first item no-lock
        where item.it-codigo = ordem-compra.it-codigo:

        assign pqtde-item = ordens-embarque.quantidade
               pun-item   = item.un
               pvucv-forn = ordem-compra.pre-unit-for
               pmo-codigo = ordem-compra.mo-codigo.
    
    end. /* for first ordens-embarque */
    
    for first param-imp 
        where param-imp.cod-estabel = pcod-estabel no-lock: end.

    for first item no-lock where item.it-codigo = pcod-item:
        
        if item.tipo-contr = 4 then do:

            find first cotacao-item   
                 where cotacao-item.numero-ordem = pnum-ordem
                   and cotacao-item.cot-aprovada = yes no-lock no-error.  
            if avail cotacao-item then 
                assign pclass-fisc = substring(cotacao-item.char-1,81,20).
            else 
                assign pclass-fisc = item.class-fiscal.
        end.
        else assign pclass-fisc = item.class-fiscal.

        for first classif-fisc no-lock
            where classif-fisc.class-fiscal = pclass-fisc:
            assign pdesc-class = classif-fisc.descricao.
        end.

        assign pcod-ncm          = item.dec-1
               ppeso-bruto       = item.peso-bruto
               ppeso-liquido     = item.peso-liquido
               plog-necessita-li = item.log-necessita-li.
    end. /* for first item */

    ASSIGN plog-necessita-li = IF AVAIL param-imp AND SUBSTRING(param-imp.char-1,167,1) = "S":U THEN YES ELSE IF AVAIL item THEN item.log-necessita-li ELSE NO.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaDescItem DBOProgram 
PROCEDURE retornaDescItem :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    
    def input  param p-cod-item like decla-import-adic-itens.cod-item.
    def output param p-descricao as character format 'x(40)'.

    find first item no-lock
        where item.it-codigo = p-cod-item no-error.
    if  avail item 
    then assign p-descricao = (item.descricao-1 + item.descricao-2).
    else assign p-descricao = "".
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaProcesso DBOProgram 
PROCEDURE retornaProcesso :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    DEF  INPUT PARAM pnum-di     LIKE decla-import.num-di-ems     NO-UNDO.
    DEF  INPUT PARAM pCod-Embarq LIKE decla-import-ord.cod-embarq NO-UNDO.
    DEF  INPUT PARAM pCdd-Siscomex-Dts LIKE decla-import-ord.cdd-siscomex-dts NO-UNDO.
    DEF OUTPUT PARAM pProcess    LIKE processo-imp.nr-proc-imp    NO-UNDO.

    ASSIGN pProcess = "".

    FOR FIRST decla-import-embarq NO-LOCK
        WHERE decla-import-embarq.num-di-ems = pnum-di
        AND   decla-import-embarq.cod-embarq = pCod-Embarq
        AND   decla-import-embarq.cdd-siscomex-dts = pCdd-Siscomex-Dts,
        FIRST ordens-embarque 
        WHERE ordens-embarque.cod-estabel = decla-import-embarq.cod-estab
        AND   ordens-embarque.embarque    = decla-import-embarq.cod-embarq,
        FIRST ordem-compra NO-LOCK 
        WHERE ordem-compra.numero-ordem = ordens-embarque.numero-ordem,
        FIRST processo-imp NO-LOCK 
        WHERE processo-imp.num-pedido = ordem-compra.num-pedido:

        ASSIGN pProcess = processo-imp.nr-proc-imp.
    END. /* for first decla-import-embarq */
    
    RETURN 'ok'.

    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaUnidMed DBOProgram 
PROCEDURE retornaUnidMed :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    
    def input  param p-cod-item like decla-import-adic-itens.cod-item.
    def output param p-un       like item.un.

    find first item no-lock
        where  item.it-codigo = p-cod-item no-error.
    if  avail  item 
    then assign p-un = item.un.
    else assign p-un = "".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setaQuantidadeEmbarque DBOProgram 
PROCEDURE setaQuantidadeEmbarque :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM p-quant-embarq like prazo-compra.quantidade    no-undo.

ASSIGN de-quant-embarq = p-quant-embarq.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByDI DBOProgram 
PROCEDURE setConstraintByDI :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM pNumDiEms LIKE {&TABLENAME}.num-di-ems NO-UNDO.
DEF INPUT PARAM pCddSiscomexDts LIKE {&TABLENAME}.cdd-siscomex-dts NO-UNDO.

ASSIGN i-num-di-ems = pNumDiEms
       de-cdd-siscomex-dts = pCddSiscomexDts.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByEmbarque DBOProgram 
PROCEDURE setConstraintByEmbarque :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM pEmbarque LIKE {&TABLENAME}.cod-embarq NO-UNDO.

ASSIGN i-cod-embarq = pEmbarque.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaAltPesos DBOProgram 
PROCEDURE validaAltPesos :
/*------------------------------------------------------------------------------
  Purpose: Verificar se os campos de Pesos foram alterados
    Notes: Caso eles tenham sido alterados sera necessario reabir a DI para que os
           impostos sejam rateados e calculados      
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER TABLE FOR tt-campos-quebra.
    DEFINE INPUT PARAMETER TABLE FOR tt-decla-import-ord.
     
    
    DEFINE OUTPUT parameter l-peso-alterado AS LOGICAL NO-UNDO.

    FIND FIRST tt-decla-import-ord NO-LOCK NO-ERROR.

    FIND FIRST tt-campos-quebra 
        WHERE tt-campos-quebra.num-di-ems  = tt-decla-import-ord.num-di-ems 
          AND tt-campos-quebra.num-ordem   = tt-decla-import-ord.num-ordem  
          AND tt-campos-quebra.num-parcela = tt-decla-import-ord.num-parcela 
          and tt-campos-quebra.cdd-siscomex-dts = tt-decla-import-ord.cdd-siscomex-dts NO-LOCK NO-ERROR.
    
    IF  tt-campos-quebra.val-peso-liq       <> tt-decla-import-ord.val-peso-liq       OR
        tt-campos-quebra.val-peso-brut-merc <> tt-decla-import-ord.val-peso-brut-merc THEN
       ASSIGN l-peso-alterado = YES.
    ELSE
       ASSIGN l-peso-alterado = NO.
    
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ValidaNovaDataEntrega DBOProgram 
PROCEDURE ValidaNovaDataEntrega :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
     IF NOT VALID-HANDLE(h-bocx225) THEN 
         RUN cxbo/bocx225.p  PERSISTENT SET h-bocx225.

     RUN validaNovaDataEntrega IN h-bocx225 (INPUT i-numero-ordem,
                                             INPUT v-nova-entrega,
                                             OUTPUT TABLE RowErrors APPEND).

     RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    DEFINE VARIABLE d-qtd-aux LIKE RowObject.qtd-item NO-UNDO.
    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/

    IF pType = "CREATE" OR
        pType = "COPY" THEN DO:

        IF CAN-FIND (FIRST bf{&TABLENAME} WHERE 
                           bf{&TABLENAME}.num-di-ems  = RowObject.num-di-ems  AND 
                           bf{&TABLENAME}.num-ordem   = RowObject.num-ordem   AND 
                           bf{&TABLENAME}.num-parcela = RowObject.num-parcela and 
                           bf{&TABLENAME}.cdd-siscomex-dts = RowObject.cdd-siscomex-dts) THEN DO:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-ordem-declaracao-importacao AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Ordem_Declaraá∆o_Importaá∆o" *}
                ASSIGN c-lbl-liter-ordem-declaracao-importacao = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i &ErrorNumber="1"
                                            &ErrorType="EMS":U
                                            &ErrorParameters="c-lbl-liter-ordem-declaracao-importacao"}
        END.
    END.

    if  not RowObject.log-emite-fabrican then do:
        if  RowObject.cdn-fabrican = 0 then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-fabricante AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Fabricante" *}
            ASSIGN c-lbl-liter-fabricante = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="17394"
                                        &ErrorType="EMS":U
                                        &ErrorParameters="c-lbl-liter-fabricante"}
        end. /* if  RowObject.cdn-fabrican = 0 */
    end. /* if  not RowObject.log-emite-fabrican */

    if  RowObject.qtd-item <> 0 then 
        for first ordens-embarque no-lock
            where ordens-embarque.cod-estabel  = RowObject.cod-estab    
            and   ordens-embarque.embarque     = RowObject.cod-embarq   
            and   ordens-embarque.numero-ordem = RowObject.num-ordem    
            and   ordens-embarque.parcela      = RowObject.num-parcela: 
        
            /* aplica o fator de convers∆o na quantidade do item */
            RUN pi-calcula-qtd-fornec (INPUT RowObject.num-ordem,
                                       INPUT RowObject.cod-item,
                                       INPUT RowObject.cdn-fornec,
                                       INPUT RowObject.qtd-item,
                                       OUTPUT d-qtd-aux).
            
            if  d-qtd-aux > ordens-embarque.qt-do-forn then do:
                {method/svc/errors/inserr.i &ErrorNumber="30549"
                                            &ErrorType="EMS":U
                                            &ErrorParameters=string(ordens-embarque.qt-do-forn)}
            end. /* if  RowObject.qtd-item > ordens-embarque.qt-do-forn */
        
        end. /* for first ordens-embarque */
    else do:
        {method/svc/errors/inserr.i &ErrorNumber="1368"
                                    &ErrorType="EMS"
                                    &ErrorParameters="''"}        
    end. /* else do: */

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaUpdateQuebra DBOProgram 
PROCEDURE validaUpdateQuebra :
/*:T------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO - update
  Parameters:  recebe o numero da di e o numero da adiá∆o.
  Notes:       Os campos val-peso-liq e val-peso-brut-merc n∆o fazem parte da quebra das adiá‰es, porÇm, sempre que eles forem alterados nas ordens, Ç preciso regerar as adiá‰es.
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER TABLE FOR tt-campos-quebra.
    DEFINE INPUT PARAMETER TABLE FOR tt-decla-import-ord.
    DEFINE INPUT PARAMETER TABLE FOR tt-decla-import-ord-trib.

    DEFINE OUTPUT parameter pQuebra-alterada AS LOGICAL                        NO-UNDO.
    
    DEFINE VARIABLE i-trib-ibs-uf            AS INTEGER                        NO-UNDO.
    DEFINE VARIABLE i-trib-cbs               AS INTEGER                        NO-UNDO.

    FIND FIRST tt-decla-import-ord NO-LOCK NO-ERROR.
    /* verifica se os campos da quebra foram atualizados. Se forem alterados, as adiá‰es devem ser removidas. */
    FIND FIRST tt-campos-quebra NO-LOCK
        WHERE tt-campos-quebra.num-di-ems  = tt-decla-import-ord.num-di-ems AND
              tt-campos-quebra.num-ordem   = tt-decla-import-ord.num-ordem  AND
              tt-campos-quebra.num-parcela = tt-decla-import-ord.num-parcela and 
              tt-campos-quebra.cdd-siscomex-dts = tt-decla-import-ord.cdd-siscomex-dts NO-ERROR.

    IF tt-campos-quebra.cdn-naladi-sist-harmon         <> tt-decla-import-ord.cdn-naladi-sist-harmon      OR
       tt-campos-quebra.cod-naladi-ncca                <> tt-decla-import-ord.cod-naladi-ncca             OR
       tt-campos-quebra.cod-nbm                        <> tt-decla-import-ord.cod-nbm                     OR
       tt-campos-quebra.cod-licenc-import              <> tt-decla-import-ord.cod-licenc-import           OR
       tt-campos-quebra.cdn-fabrican                   <> tt-decla-import-ord.cdn-fabrican                OR
       tt-campos-quebra.cdn-pais-proceden              <> tt-decla-import-ord.cdn-pais-proceden           OR
       tt-campos-quebra.cod-aladi                      <> tt-decla-import-ord.cod-aladi                   OR
       tt-campos-quebra.qtd-capac-recip                <> tt-decla-import-ord.qtd-capac-recip             OR
       
       tt-campos-quebra.log-suspens-impto-import       <> tt-decla-import-ord.log-suspens-impto-import    OR    
       tt-campos-quebra.log-suspens-ipi-import         <> tt-decla-import-ord.log-suspens-ipi-import      OR
       &IF '{&bf_mat_versao_ems}' >= '2.09' &THEN
           tt-campos-quebra.log-suspens-icms           <> tt-decla-import-ord.log-suspens-icms            OR 
           tt-campos-quebra.log-suspens-pis            <> tt-decla-import-ord.log-suspens-pis             OR 
           tt-campos-quebra.log-suspens-cofins         <> tt-decla-import-ord.log-suspens-cofins          OR 
       &ELSE
           SUBSTRING(tt-campos-quebra.cod-livre-1,1,1) <> SUBSTRING(tt-decla-import-ord.cod-livre-1,1,1)  OR 
           SUBSTRING(tt-campos-quebra.cod-livre-1,2,1) <> SUBSTRING(tt-decla-import-ord.cod-livre-1,2,1)  OR 
           SUBSTRING(tt-campos-quebra.cod-livre-1,3,1) <> SUBSTRING(tt-decla-import-ord.cod-livre-1,3,1)  OR 
       &ENDIF
                                                                                            
       tt-campos-quebra.idi-tributac-icms              <> tt-decla-import-ord.idi-tributac-icms           OR
       tt-campos-quebra.idi-tributac-ipi               <> tt-decla-import-ord.idi-tributac-ipi            OR
       tt-campos-quebra.idi-tributac-pis               <> tt-decla-import-ord.idi-tributac-pis            OR
       tt-campos-quebra.idi-tributac-cofins            <> tt-decla-import-ord.idi-tributac-cofins         OR
       tt-campos-quebra.idi-tributac-impto-import      <> tt-decla-import-ord.idi-tributac-impto-import   OR
                                                      
       tt-campos-quebra.val-aliq-cofins                <> tt-decla-import-ord.val-aliq-cofins             OR
       tt-campos-quebra.val-aliq-icms                  <> tt-decla-import-ord.val-aliq-icms               OR
       tt-campos-quebra.val-aliq-ii                    <> tt-decla-import-ord.val-aliq-ii                 OR
       tt-campos-quebra.val-aliq-ipi                   <> tt-decla-import-ord.val-aliq-ipi                OR
       tt-campos-quebra.val-aliq-pis                   <> tt-decla-import-ord.val-aliq-pis                OR
                                                      
       tt-campos-quebra.val-perc-reduc-cofins          <> tt-decla-import-ord.val-perc-reduc-cofins       OR
       tt-campos-quebra.val-perc-reduc-icms            <> tt-decla-import-ord.val-perc-reduc-icms         OR
       tt-campos-quebra.val-perc-reduc-impto-import    <> tt-decla-import-ord.val-perc-reduc-impto-import OR
       tt-campos-quebra.val-perc-reduc-ipi             <> tt-decla-import-ord.val-perc-reduc-ipi          OR
       tt-campos-quebra.val-perc-reduc-pis             <> tt-decla-import-ord.val-perc-reduc-pis          OR

       tt-campos-quebra.val-unit-pis                   <> tt-decla-import-ord.val-unit-pis                OR
       tt-campos-quebra.val-unit-cofins                <> tt-decla-import-ord.val-unit-cofins             OR
       tt-campos-quebra.val-unit-ipi                   <> tt-decla-import-ord.val-unit-ipi                OR /*
       tt-campos-quebra.val-peso-liq                   <> tt-decla-import-ord.val-peso-liq                OR
       tt-campos-quebra.val-peso-brut-merc             <> tt-decla-import-ord.val-peso-brut-merc            */
       tt-campos-quebra.idi-ind-pagto                  <> tt-decla-import-ord.idi-ind-pagto 
    THEN
       ASSIGN pQuebra-alterada = YES.
    ELSE
       ASSIGN pQuebra-alterada = NO.
    /* fim - verifica se os campos da quebra foram atualizados. Se forem alterados, as adiá‰es devem ser removidas. */
    
    IF NOT pQuebra-alterada AND 
       l-nt2024002 THEN DO:        
        FOR EACH tt-decla-import-ord-trib WHERE tt-decla-import-ord-trib.num-di-ems       = tt-decla-import-ord.num-di-ems
                                          AND   tt-decla-import-ord-trib.cdd-siscomex-dts = tt-decla-import-ord.cdd-siscomex-dts
                                          AND   tt-decla-import-ord-trib.num-ordem        = tt-decla-import-ord.num-ordem
                                          AND   tt-decla-import-ord-trib.num-parcela      = tt-decla-import-ord.num-parcela
                                          NO-LOCK:
            CASE tt-decla-import-ord-trib.nom-trib:
                WHEN "IBSUF" THEN DO:
                    CASE tt-decla-import-ord-trib.cod-campo:
                        WHEN "C-CLASS-TRIB" THEN DO:
                            IF tt-decla-import-ord-trib.cod-conteudo <> tt-campos-quebra.c-class-trib-ibs-uf THEN
                                ASSIGN pQuebra-alterada = YES.
                        END.
                        WHEN "CST":U THEN DO:
                            IF tt-decla-import-ord-trib.cod-conteudo <> tt-campos-quebra.c-cst-ibs-uf THEN
                                ASSIGN pQuebra-alterada = YES.
                        END.
                        WHEN "COD-TRIB":U THEN DO:
                            IF {diinc/i01di628.i 04 INT(tt-decla-import-ord-trib.cod-conteudo)} <> tt-campos-quebra.cb-idi-tributac-ibs-uf THEN
                                ASSIGN pQuebra-alterada = YES.                            
                        END.
                        WHEN "ALIQUOTA":U THEN DO:
                            IF DEC(tt-decla-import-ord-trib.cod-conteudo) <> DEC(tt-campos-quebra.de-aliq-ibs-uf) THEN
                                ASSIGN pQuebra-alterada = YES.                            
                        END.
                        WHEN "ALIQ-RED":U THEN DO:
                            IF DEC(tt-decla-import-ord-trib.cod-conteudo) <> DEC(tt-campos-quebra.de-aliq-red-ibs-uf) THEN
                                ASSIGN pQuebra-alterada = YES.                            
                        END.
                        WHEN "C-CLASS-TRIB-REG":U THEN DO:
                            IF tt-decla-import-ord-trib.cod-conteudo <> tt-campos-quebra.c-class-trib-ibs-uf-reg THEN
                                ASSIGN pQuebra-alterada = YES.
                        END.
                        WHEN "CST-REG":U THEN DO:
                            IF tt-decla-import-ord-trib.cod-conteudo <> tt-campos-quebra.c-cst-ibs-uf-reg THEN
                                ASSIGN pQuebra-alterada = YES.
                        END.
                        WHEN "ALIQ-EFETIVA-REG":U THEN DO:
                            IF DEC(tt-decla-import-ord-trib.cod-conteudo) <> DEC(tt-campos-quebra.de-aliq-ibs-uf-reg) THEN
                                ASSIGN pQuebra-alterada = YES.
                        END.
                    END CASE.
                END.
                WHEN "IBSMUN" THEN DO:
                    CASE tt-decla-import-ord-trib.cod-campo:
                        WHEN "C-CLASS-TRIB":U THEN DO:
                            IF tt-decla-import-ord-trib.cod-conteudo <> tt-campos-quebra.c-class-trib-ibs-mun THEN
                                ASSIGN pQuebra-alterada = YES.
                        END.
                        WHEN "CST":U THEN DO:
                            IF tt-decla-import-ord-trib.cod-conteudo <> tt-campos-quebra.c-cst-ibs-mun THEN
                                ASSIGN pQuebra-alterada = YES.
                        END.
                        WHEN "COD-TRIB":U THEN DO:
                            IF {diinc/i01di628.i 04 INT(tt-decla-import-ord-trib.cod-conteudo)} <> tt-campos-quebra.cb-idi-tributac-ibs-mun THEN
                                ASSIGN pQuebra-alterada = YES.                            
                        END.
                        WHEN "ALIQUOTA":U THEN DO:
                            IF DEC(tt-decla-import-ord-trib.cod-conteudo) <> DEC(tt-campos-quebra.de-aliq-ibs-mun) THEN
                                ASSIGN pQuebra-alterada = YES.                            
                        END.
                        WHEN "ALIQ-RED":U THEN DO:
                            IF DEC(tt-decla-import-ord-trib.cod-conteudo) <> DEC(tt-campos-quebra.de-aliq-red-ibs-mun) THEN
                                ASSIGN pQuebra-alterada = YES.                            
                        END.
                        WHEN "C-CLASS-TRIB-REG":U THEN DO:
                            IF tt-decla-import-ord-trib.cod-conteudo <> tt-campos-quebra.c-class-trib-ibs-mun-reg THEN
                                ASSIGN pQuebra-alterada = YES.
                        END.
                        WHEN "CST-REG":U THEN DO:
                            IF tt-decla-import-ord-trib.cod-conteudo <> tt-campos-quebra.c-cst-ibs-mun-reg THEN
                                ASSIGN pQuebra-alterada = YES.
                        END.
                        WHEN "ALIQ-EFETIVA-REG":U THEN DO:
                            IF DEC(tt-decla-import-ord-trib.cod-conteudo) <> DEC(tt-campos-quebra.de-aliq-ibs-mun-reg) THEN
                                ASSIGN pQuebra-alterada = YES.
                        END.
                    END CASE.
                END.
                WHEN "CBS" THEN DO:
                    CASE tt-decla-import-ord-trib.cod-campo:
                        WHEN "C-CLASS-TRIB":U THEN DO:
                            IF tt-decla-import-ord-trib.cod-conteudo <> tt-campos-quebra.c-class-trib-cbs THEN
                                ASSIGN pQuebra-alterada = YES.
                        END.
                        WHEN "CST":U THEN DO:
                            IF tt-decla-import-ord-trib.cod-conteudo <> tt-campos-quebra.c-cst-cbs THEN
                                ASSIGN pQuebra-alterada = YES.
                        END.
                        WHEN "COD-TRIB":U THEN DO:
                            IF {diinc/i01di628.i 04 INT(tt-decla-import-ord-trib.cod-conteudo)} <> tt-campos-quebra.cb-idi-tributac-cbs THEN
                                ASSIGN pQuebra-alterada = YES.
                        END.
                        WHEN "ALIQUOTA":U THEN DO:
                            IF DEC(tt-decla-import-ord-trib.cod-conteudo) <> DEC(tt-campos-quebra.de-aliq-cbs) THEN
                                ASSIGN pQuebra-alterada = YES.
                        END.
                        WHEN "ALIQ-RED":U THEN DO:
                            IF DEC(tt-decla-import-ord-trib.cod-conteudo) <> DEC(tt-campos-quebra.de-aliq-red-cbs) THEN
                                ASSIGN pQuebra-alterada = YES.
                        END.
                        WHEN "C-CLASS-TRIB-REG":U THEN DO:
                            IF tt-decla-import-ord-trib.cod-conteudo <> tt-campos-quebra.c-class-trib-cbs-reg THEN
                                ASSIGN pQuebra-alterada = YES.
                        END.
                        WHEN "CST-REG":U THEN DO:
                            IF tt-decla-import-ord-trib.cod-conteudo <> tt-campos-quebra.c-cst-cbs-reg THEN
                                ASSIGN pQuebra-alterada = YES.
                        END.
                        WHEN "ALIQ-EFETIVA-REG":U THEN DO:
                            IF DEC(tt-decla-import-ord-trib.cod-conteudo) <> DEC(tt-campos-quebra.de-aliq-cbs-reg) THEN
                                ASSIGN pQuebra-alterada = YES.
                        END.
                    END CASE.
                END.
            END CASE.        
        END.        
    END.
    
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaIntegraDI DBOProgram 
PROCEDURE verificaIntegraDI :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    
    def input  parameter pnumero-ordem like ordens-embarque.numero-ordem no-undo.
    def input  parameter pparcela      like ordens-embarque.parcela      no-undo.
    def output parameter pl-integra-di as   logical no-undo.

    ASSIGN pl-integra-di = CAN-FIND(FIRST {&TableName}
                                    WHERE {&TableName}.num-ordem   = pnumero-ordem 
                                    AND   {&TableName}.num-parcela = pparcela).
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

