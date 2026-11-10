&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/*:T------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) Ç um programa PROGRESS 
                 que contÇm a l¢gica de neg¢cio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters :   

    Notes      : 
  -------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.                */
/*-------------------------------------------------------------------------*/
USING rep.imp.*.

{include/i-prgvrs.i BOCX383A 2.00.00.172 } /* 25/09/2026 17:12:15 ***/


/* ****************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOCX383A
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName decla-import
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

{cxbo/bocx383.i RowObject} /*:T--- Include com definiá∆o da temptable RowObject ---*/  

{method/dboqry.i} /*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/

/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName}             FOR {&TableName}.
DEFINE BUFFER bf-decla-import-adic       FOR decla-import-adic.
DEFINE BUFFER bf-decla-import-adic-itens FOR decla-import-adic-itens.
DEFINE BUFFER bitem-doc-est-tribut       FOR item-doc-est-tribut.   

/*DEFINIÄ«O DOS PRE-PROCESSADORES DE VERS«O E PRODUTO IMPORTAÄ«O MEXICO*/
{utp/ut-glob.i}
{cdp/cdcfgdis.i}
{cdp/cdcfgmat.i}
{cdp/cdcfgcex.i}
{cdp/cd2508.i}

{cdp/cd0020.i}     /* pi-gerar-dados-extrato */
{inbo/boin176.i2}  /* Definiá∆o TT-TOTAL-ITEM */
{inbo/boin01017.i tt-ext-item-doc-est}
{inbo/boin01017.i tt-ext-item-doc-est-aux}
{cxbo/bocx00512.i tt-decla-imp-adic-it-trib}
{cxbo/bocx00506.i tt-decla-import-adic-trib}
{cxbo/bocx00507.i tt-decla-import-ord-trib}

DEFINE TEMP-TABLE tt-docum-est-tast    NO-UNDO LIKE docum-est
    FIELD nro-docto-orig         LIKE docum-est.nro-docto
    FIELD embarque-orig          LIKE docum-est.embarque
    FIELD declaracao-import-orig LIKE docum-est.declaracao-import.

DEFINE TEMP-TABLE tt-ct-trib-item NO-UNDO LIKE ct-trib-item-doc-est
    FIELD r-rowid AS ROWID.

DEFINE NEW GLOBAL SHARED VARIABLE i-totaliza AS INTEGER NO-UNDO.
{cxbo/bocx383a.i4}

DEF TEMP-TABLE tt-desp-cif NO-UNDO
    FIELD num-di-ems         AS INTEGER
    FIELD num-adic           AS INTEGER
    FIELD val-desp-mo        AS decimal
    field val-cif-mo         like tt-desp-rateio-item.val-desp.

DEF TEMP-TABLE tt-desp-cif-item NO-UNDO
    FIELD num-di-ems         AS INTEGER
    FIELD num-adic           AS INTEGER
    FIELD numero-ordem       AS INTEGER
    FIELD parcela            AS INTEGER
    FIELD val-desp-mo        like tt-desp-rateio-item.val-desp
    field val-cif-item       like tt-desp-rateio-item.val-desp.

DEFINE BUFFER b-tb-ct-trib-wt-item-docto FOR tb-ct-trib-wt-item-docto.
DEFINE BUFFER b-tb-wt-it-docto           FOR tb-wt-it-docto.
DEFINE BUFFER b-tb-wt-it-imposto         FOR tb-wt-it-imposto.
DEFINE BUFFER b-natur-oper               FOR natur-oper.
DEFINE BUFFER b-wt-docto                 FOR wt-docto.
DEFINE BUFFER b-wt-it-docto              FOR wt-it-docto.
DEFINE BUFFER bf-wt-docto                FOR wt-docto.
DEFINE BUFFER b-ct-trib-wt-item-docto    FOR ct-trib-wt-item-docto.
DEFINE BUFFER b-nota-fisc-adc            FOR nota-fisc-adc.
DEFINE BUFFER bf-despes-adic             FOR despes-adic.
DEFINE BUFFER bf-despes-adic-itens       FOR despes-adic-itens.
DEFINE BUFFER b-ct-trib-item-doc-est     FOR ct-trib-item-doc-est.

DEFINE VARIABLE i-seq-item AS INTEGER         NO-UNDO.
DEFINE VARIABLE i-seq-item-aux AS INTEGER     NO-UNDO.
{inbo/boin176.m98} /*pi-gravar-dados-cfg-trib*/

DEFINE TEMP-TABLE tt-embarques-gerados NO-UNDO
    FIELD cod-embarq LIKE decla-import-embarq.cod-embarq.

DEFINE TEMP-TABLE tt-acerto-despes NO-UNDO
    FIELD cdn-despes AS INTEGER 
    FIELD num-adic   AS INTEGER.

DEFINE TEMP-TABLE tt-acerto-icms-it-adic NO-UNDO
    FIELD de-valor AS DECIMAL
    FIELD num-seq  AS INTEGER.

define temp-table tt-despes-adic-acerto no-undo like tt-despes-adic.

/*Reforma Tribut†ria*/
{dibo/bodi613calc.i3}  //definiªío da tb-wt-it-impostoCBSIBS
    
DEFINE VARIABLE c-desc-geral                AS   CHARACTER EXTENT 5                          NO-UNDO.
DEFINE VARIABLE c-desc-help                 AS   CHARACTER EXTENT 5                          NO-UNDO.
DEFINE VARIABLE c-desc-msg                  AS   CHARACTER                                   NO-UNDO.
DEFINE VARIABLE cHelpAux                    AS   CHARACTER                                   NO-UNDO.
DEFINE VARIABLE c-help-cotac                AS   CHARACTER                                   NO-UNDO.
DEFINE VARIABLE c-cod-ajuste                AS   CHARACTER                                   NO-UNDO.
DEFINE VARIABLE d-valor-pis                 AS   DECIMAL                                     NO-UNDO.
DEFINE VARIABLE d-valor-confins             AS   DECIMAL                                     NO-UNDO.
DEFINE VARIABLE d-tot-desp-itens-aux        AS   DECIMAL                                     NO-UNDO.
DEFINE VARIABLE h-bocx00488                 AS   HANDLE                                      NO-UNDO.
DEFINE VARIABLE h-cdapi050                  AS   HANDLE                                      NO-UNDO.
DEFINE VARIABLE h-bodi613calc2              AS   HANDLE                                      NO-UNDO.
DEFINE VARIABLE h-boin01017                 AS   HANDLE                                      NO-UNDO.
DEFINE VARIABLE h-bocx00506                 AS   HANDLE                                      NO-UNDO.
DEFINE VARIABLE h-bocx00512                 AS   HANDLE                                      NO-UNDO.
DEFINE VARIABLE h-bocx00507                 AS   HANDLE                                      NO-UNDO.
DEFINE VARIABLE i-natureza-camb             AS   INTEGER                                     NO-UNDO.
DEFINE VARIABLE iErro                       AS   INTEGER                                     NO-UNDO.
DEFINE VARIABLE i-seq-wt-docto-ant          AS   INTEGER                                     NO-UNDO.
DEFINE VARIABLE i-seq-wt-docto              AS   INTEGER                                     NO-UNDO.
DEFINE VARIABLE l-regera-default-impostos   AS   LOGICAL                                     NO-UNDO.
DEFINE VARIABLE l-tast                      AS   LOGICAL                          INITIAL NO NO-UNDO.
DEFINE VARIABLE l-compara-icms              AS   LOGICAL                          INITIAL NO NO-UNDO.
DEFINE VARIABLE i-num-di-ems-pli            LIKE decla-import-adic.num-di-ems                NO-UNDO.
DEFINE VARIABLE i-num-adic-pli              LIKE decla-import-adic.num-adic                  NO-UNDO.
DEFINE VARIABLE dat-tipo-dia                LIKE calen-coml.tipo-dia                         NO-UNDO. /*CD9020.i7*/
DEFINE VARIABLE d-base-icms-adic-aux        LIKE decla-import-adic.val-base-icms             NO-UNDO. /* Base arredondada em duas casas */
DEFINE VARIABLE d-base-icms-itens-aux       LIKE decla-import-adic-itens.val-base-icms       NO-UNDO. /* Base arredondada em duas casas */
DEFINE VARIABLE d-val-desp-aux              LIKE desp-embarque.val-desp                      NO-UNDO.
DEFINE VARIABLE d-val-desp-adic-aux         LIKE despes-adic.val-despes                      NO-UNDO.
DEFINE VARIABLE c-embarque-aux              LIKE desp-embarque.embarque                      NO-UNDO.
DEFINE VARIABLE c-cod-estabel-aux           LIKE desp-embarque.cod-estabel                   NO-UNDO.
DEFINE VARIABLE d-total-desp                LIKE desp-embarque.val-desp                      NO-UNDO.
DEFINE VARIABLE i-num-adic-aux              LIKE tt-desp-rateio-item.num-adic                NO-UNDO.
DEFINE VARIABLE i-num-seq-aux               LIKE tt-desp-rateio-item.num-seq                 NO-UNDO.
DEFINE VARIABLE i-cdn-emit-despes-aux       LIKE tt-despesas.cdn-emit-despes                 NO-UNDO. 
DEFINE VARIABLE de-val-icms-db-cr           LIKE decla-import-adic.val-icms-db-cr            NO-UNDO.
DEFINE VARIABLE de-val-icms-nao-tribut      LIKE decla-import-adic-itens.val-icms-nao-tribut NO-UNDO.
DEFINE VARIABLE de-val-icms-outras          LIKE decla-import-adic-itens.val-icms-outras     NO-UNDO.
DEFINE VARIABLE de-val-base-icms            LIKE decla-import-adic-itens.val-base-icms       NO-UNDO.
DEFINE VARIABLE c-serie-docto               LIKE docum-est.serie-docto                       NO-UNDO.
DEFINE VARIABLE c-nro-documento             LIKE docum-est.nro-docto                         NO-UNDO.
DEFINE VARIABLE i-cod-emitente              LIKE docum-est.cod-emitente                      NO-UNDO.
DEFINE VARIABLE c-nat-operacao              LIKE docum-est.nat-operacao                      NO-UNDO.
DEFINE VARIABLE de-dif-frete                LIKE docum-est.valor-frete                       NO-UNDO.
DEFINE VARIABLE de-val-compara-icms         AS DECIMAL FORMAT ">>>>>,>>>,>>9.99"             NO-UNDO.
DEFINE VARIABLE i-num-seq-duimp-it          LIKE item-docto-estoq-nfe-imp.num-seq-import     NO-UNDO.
DEFINE VARIABLE i-num-adic                  LIKE item-docto-estoq-nfe-imp.num-adic           NO-UNDO.
DEFINE VARIABLE i-num-seq-retif             AS INTEGER NO-UNDO.
DEFINE VARIABLE c-embarque                  LIKE decla-import-ord.cod-embarq                 NO-UNDO.
DEFINE VARIABLE l-nt2024002                 AS LOGICAL                                       NO-UNDO.
DEFINE VARIABLE h-cdapi995                  AS HANDLE                                        NO-UNDO.

ASSIGN l-nt2024002 = CAN-FIND(FIRST funcao NO-LOCK
                              WHERE funcao.cd-funcao = "spp-nt2024002":U AND funcao.ativo).
/* PCREQ-9042 - Portador do Emitente */
{cdp/cdapi3009.i1}
DEFINE VARIABLE i-port-emit    AS INTEGER NO-UNDO.
DEFINE VARIABLE i-modalid-emit AS INTEGER NO-UNDO.

{utils/itemVendorConversionFactor.i}

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
         HEIGHT             = 2.21
         WIDTH              = 40.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE acertoValoresIcms DBOProgram 
PROCEDURE acertoValoresIcms :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR c-cod-item    LIKE decla-import-adic-itens.cod-item NO-UNDO.
    DEF VAR l-controle    AS LOGICAL INITIAL NO NO-UNDO.
    DEF VAR d-maior-valor LIKE desp-imp.val-desp NO-UNDO.
    DEF VAR d-valor-aux   LIKE desp-imp.val-desp NO-UNDO.
    DEF VAR i-num-seq-maior LIKE decla-import-adic-itens.num-seq NO-UNDO.
    DEF VAR de-tot-icms-it  LIKE decla-import-adic-itens.val-icms-db-cr NO-UNDO.


    EMPTY TEMP-TABLE tt-acerto-icms-it-adic.

    /*validar a diferenca do valor do ICMS calculado para a adiá∆o e o valor total do ICMS calculado para os itens */
    ASSIGN d-valor-icms-adicao = decla-import-adic.val-icms-nao-tributad + decla-import-adic.val-icms-db-cr + decla-import-adic.val-icms-outras
           d-diferenca-icms    = 0
           d-valor-aux         = 0
           d-maior-valor       = 0
           i-num-seq-maior     = 0
           l-controle          = NO
           de-tot-icms-it      = 0.

    /*Atualiza os valores com base no c†lculo realizado pelo configurador de tributos*/
    ASSIGN d-valor-icms-itens = d-valor-icms-itens-ct-trib WHEN d-valor-icms-itens-ct-trib > 0
           d-base-icms-itens  = d-base-icms-itens-ct-trib  WHEN d-base-icms-itens-ct-trib  > 0.

    /* Acertar o valor do icms */
    IF d-valor-icms-itens <> 0 AND d-valor-icms-adicao <> d-valor-icms-itens AND NOT l-valor-icms-manual THEN DO:

        ASSIGN d-diferenca-icms = d-valor-icms-adicao - d-valor-icms-itens.
        
        /* Cira temp-table ocm os valores de icms dos itens da adicao */
        FOR EACH bf-decla-import-adic-itens 
           WHERE bf-decla-import-adic-itens.num-di-ems = decla-import-adic.num-di-ems
             AND bf-decla-import-adic-itens.num-adic   = decla-import-adic.num-adic 
             AND bf-decla-import-adic-itens.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts NO-LOCK:

            &IF '{&bf_mat_versao_ems}' >= '2.09' &THEN
                IF  decla-import-adic.log-suspens-icms THEN
            &ELSE
                IF  SUBSTRING(decla-import-adic.cod-livre-1,1,1) = '1' THEN
            &ENDIF
                    ASSIGN d-valor-aux = bf-decla-import-adic-itens.val-icms-nao-tributad.
                ELSE DO:
                    CASE bf-decla-import-adic-itens.idi-tributac-icms:
                        WHEN 1 THEN
                            ASSIGN d-valor-aux = bf-decla-import-adic-itens.val-icms-db-cr.
                        WHEN 2 THEN
                            ASSIGN d-valor-aux = bf-decla-import-adic-itens.val-icms-db-cr.
                        WHEN 3 THEN
                            ASSIGN d-valor-aux = bf-decla-import-adic-itens.val-icms-outras.
                        WHEN 4 THEN
                            ASSIGN d-valor-aux = bf-decla-import-adic-itens.val-icms-db-cr.
                    END CASE. 
                END.


            CREATE tt-acerto-icms-it-adic.
            ASSIGN tt-acerto-icms-it-adic.de-valor = d-valor-aux
                   tt-acerto-icms-it-adic.num-seq  = bf-decla-import-adic-itens.num-seq.

            ASSIGN de-tot-icms-it = de-tot-icms-it + bf-decla-import-adic-itens.val-icms-db-cr.
        END.

        DO WHILE d-diferenca-icms <> 0:

            FOR EACH tt-acerto-icms-it-adic BY tt-acerto-icms-it-adic.de-valor DESCENDING:

                IF d-diferenca-icms = 0 THEN
                    NEXT.
                /* posiciona nos itens de maior valor de icms primeiro para efetuar o acerto 
                ** jogar 1 centavo para cada item, pois se a diferenca entre a base x aliquota for maior que 1 centavo
                ** acontece rejeicao na SEFAZ*/
                FIND FIRST bf-decla-import-adic-itens 
                     WHERE bf-decla-import-adic-itens.num-di-ems = decla-import-adic.num-di-ems
                       AND bf-decla-import-adic-itens.num-adic   = decla-import-adic.num-adic
                       AND bf-decla-import-adic-itens.num-seq    = tt-acerto-icms-it-adic.num-seq 
                       AND bf-decla-import-adic-itens.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts EXCLUSIVE-LOCK NO-ERROR.

                IF AVAIL bf-decla-import-adic-itens THEN DO:
                    
                    //Valida se o valor ja est† correto conforme aliquota icms informada
                    ASSIGN de-val-compara-icms = ROUND((bf-decla-import-adic-itens.val-base-icms * (bf-decla-import-adic-itens.val-aliq-icms / 100)),2).
                    IF de-val-compara-icms = bf-decla-import-adic-itens.val-icms-db-cr THEN DO:
                        IF d-diferenca-icms < 0 THEN
                            ASSIGN d-diferenca-icms = d-diferenca-icms + 0.01.
                        IF d-diferenca-icms > 0 THEN
                            ASSIGN d-diferenca-icms = d-diferenca-icms - 0.01.
                        NEXT.
                    END.
                    ELSE
                        ASSIGN l-compara-icms = YES.
                    
                    IF d-diferenca-icms = 0 THEN
                    NEXT.
                    
                    &if '{&bf_mat_versao_ems}' >= '2.09' &then
                        IF bf-decla-import-adic-itens.log-suspens-icms 
                    &else
                        IF  SUBSTRING(decla-import-adic.cod-livre-1,1,1) = '1' 
                    &endif
                        OR (    de-tot-icms-it = decla-import-adic.val-icms-db-cr
                            AND bf-decla-import-adic-itens.val-icms-nao-tributad > 0) THEN
                            ASSIGN bf-decla-import-adic-itens.val-icms-nao-tributad = bf-decla-import-adic-itens.val-icms-nao-tributad +
                                                                                  IF d-diferenca-icms < 0 THEN (-1 * 0.01) ELSE
                                                                                  IF d-diferenca-icms > 0 THEN       0.01  ELSE 0.
                        ELSE DO:
                            CASE bf-decla-import-adic-itens.idi-tributac-icms:
                                WHEN 1 THEN
                                    ASSIGN bf-decla-import-adic-itens.val-icms-db-cr  = bf-decla-import-adic-itens.val-icms-db-cr +
                                                                                      IF d-diferenca-icms < 0 THEN (-1 * 0.01) ELSE
                                                                                      IF d-diferenca-icms > 0 THEN       0.01  ELSE 0.
                                WHEN 2 THEN
                                    ASSIGN bf-decla-import-adic-itens.val-icms-db-cr  = 0.
                                WHEN 3 THEN
                                    ASSIGN bf-decla-import-adic-itens.val-icms-outras = bf-decla-import-adic-itens.val-icms-outras +
                                                                                      IF d-diferenca-icms < 0 THEN (-1 * 0.01) ELSE
                                                                                      IF d-diferenca-icms > 0 THEN       0.01  ELSE 0.
                                WHEN 4 THEN DO:
                                    ASSIGN bf-decla-import-adic-itens.val-icms-db-cr  = bf-decla-import-adic-itens.val-icms-db-cr + 
                                                                                        IF d-diferenca-icms < 0 THEN (-1 * 0.01) ELSE
                                                                                        IF d-diferenca-icms > 0 THEN       0.01  ELSE 0.
                                    ASSIGN de-tot-icms-it  = de-tot-icms-it + 
                                                             IF d-diferenca-icms < 0 THEN (-1 * 0.01) ELSE
                                                             IF d-diferenca-icms > 0 THEN       0.01  ELSE 0.
                                END.
                            END CASE.
                        END. 

                    IF d-diferenca-icms < 0 THEN
                        ASSIGN d-diferenca-icms = d-diferenca-icms + 0.01.
                    IF d-diferenca-icms > 0 THEN
                        ASSIGN d-diferenca-icms = d-diferenca-icms - 0.01.
                END.
            END.

        END.
    END. /*fim validar a diferenca do valor do IPI calculado para a adiá∆o e o valor total do IPI calculado para os itens */
    

    /*Acerto da base do ICMS*/
    
        /* Validar o valor de icms dos itens */
        
    IF  d-base-icms-itens <> 0 AND
        d-base-icms-itens <> decla-import-adic.val-base-icms AND 
        l-compara-icms THEN DO:
        ASSIGN d-diferenca-icms = decla-import-adic.val-base-icms - d-base-icms-itens
               d-maior-valor    = 0
               i-num-seq-maior  = 0.

        /*Busca o item com maior base de ICMS*/
        FOR EACH bf-decla-import-adic-itens NO-LOCK
            WHERE bf-decla-import-adic-itens.num-di-ems = decla-import-adic.num-di-ems
            AND   bf-decla-import-adic-itens.num-adic   = decla-import-adic.num-adic
            AND   bf-decla-import-adic-itens.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts:

            IF bf-decla-import-adic-itens.val-base-icms > d-maior-valor THEN 
                ASSIGN d-maior-valor   = bf-decla-import-adic-itens.val-base-icms
                       i-num-seq-maior = bf-decla-import-adic-itens.num-seq.
        END. 

        /* Posiciona no item de maior valor de icms da adicao para efetuar o acerto */
        FIND FIRST bf-decla-import-adic-itens 
             WHERE bf-decla-import-adic-itens.num-di-ems = decla-import-adic.num-di-ems
               AND bf-decla-import-adic-itens.num-adic   = decla-import-adic.num-adic
               AND bf-decla-import-adic-itens.num-seq    = i-num-seq-maior 
               AND bf-decla-import-adic-itens.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts EXCLUSIVE-LOCK NO-ERROR.

         IF AVAIL bf-decla-import-adic-itens THEN
             ASSIGN bf-decla-import-adic-itens.val-base-icms = bf-decla-import-adic-itens.val-base-icms + d-diferenca-icms.

    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE acertoValoresImpostos DBOProgram 
PROCEDURE acertoValoresImpostos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR c-cod-item    LIKE decla-import-adic-itens.cod-item NO-UNDO.
    DEF VAR l-controle    AS LOGICAL INITIAL NO NO-UNDO.
    DEF VAR d-maior-valor LIKE desp-imp.val-desp NO-UNDO.
    DEF VAR d-valor-aux   LIKE desp-imp.val-desp NO-UNDO.
    DEF VAR i-num-seq-maior LIKE decla-import-adic-itens.num-seq NO-UNDO.

    /*validar a diferenca do valor do II calculado para a adiá∆o e o valor total do II calculado para os itens */    
    ASSIGN d-valor-ii-adicao = decla-import-adic.val-ii-nao-tribut + decla-import-adic.val-ii-db-cr + decla-import-adic.val-ii-outras
           d-diferenca-ii    = 0
           d-valor-aux       = 0
           d-maior-valor     = 0
           i-num-seq-maior   = 0
           l-controle        = NO.

    /* acertar o valor do ii */
    IF d-valor-ii-adicao <> d-valor-ii-itens THEN DO:
        ASSIGN d-diferenca-ii = d-valor-ii-adicao - d-valor-ii-itens.

        FOR EACH bf-decla-import-adic-itens NO-LOCK
            WHERE bf-decla-import-adic-itens.num-di-ems = decla-import-adic.num-di-ems
            AND   bf-decla-import-adic-itens.num-adic   = decla-import-adic.num-adic    
            AND   bf-decla-import-adic-itens.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts:

            /* passa o valor do ii para uma variavel de comparacao */
            IF bf-decla-import-adic-itens.log-suspens-impto-import THEN
                ASSIGN d-valor-aux = bf-decla-import-adic-itens.val-ii-nao-tribut.
            ELSE DO:
                CASE bf-decla-import-adic-itens.idi-tributac-ipi:
                    WHEN 1 THEN
                        ASSIGN d-valor-aux = bf-decla-import-adic-itens.val-ii-db-cr.
                    WHEN 2 THEN
                        ASSIGN d-valor-aux = bf-decla-import-adic-itens.val-ii-db-cr.
                    WHEN 3 THEN
                        ASSIGN d-valor-aux = bf-decla-import-adic-itens.val-ii-outras.
                    WHEN 4 THEN
                        ASSIGN d-valor-aux = bf-decla-import-adic-itens.val-ii-db-cr.
                END CASE. /* case */
            END. /* else do */
            /* fim - passa o valor do ii para uma variavel de comparacao */

            /* se for a primeira vez que passa no loop, atribui o valor do ii na variavel de comparacao */
            IF NOT l-controle THEN
                ASSIGN l-controle = YES
                       d-maior-valor   = d-valor-aux
                       i-num-seq-maior = bf-decla-import-adic-itens.num-seq.
            ELSE DO:
                IF d-maior-valor < d-valor-aux THEN /* verifica se o valor do ii do item Ç maior que a variavel de comparacao */
                    ASSIGN d-maior-valor   = d-valor-aux
                           i-num-seq-maior = bf-decla-import-adic-itens.num-seq.
            END.
        END. /* FOR EACH decla-import-adic-itens*/


        /* posiciona no item de maior valor de ipi da adicao para efetuar o acerto */
        FIND FIRST bf-decla-import-adic-itens EXCLUSIVE-LOCK
            WHERE bf-decla-import-adic-itens.num-di-ems = decla-import-adic.num-di-ems
            AND   bf-decla-import-adic-itens.num-adic   = decla-import-adic.num-adic
            AND   bf-decla-import-adic-itens.num-seq    = i-num-seq-maior 
            AND   bf-decla-import-adic-itens.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts no-error.

        IF AVAIL bf-decla-import-adic-itens THEN DO:
            /* acertar o valor do ipi */
            IF NOT l-valor-ii-manual THEN DO:
                IF bf-decla-import-adic-itens.log-suspens-impto-import THEN
                    ASSIGN bf-decla-import-adic-itens.val-ii-nao-tribut = bf-decla-import-adic-itens.val-ii-nao-tribut + d-diferenca-ii.
                ELSE DO:
                    CASE bf-decla-import-adic-itens.idi-tributac-impto-import:
                        WHEN 1 THEN
                            ASSIGN bf-decla-import-adic-itens.val-ii-db-cr  = bf-decla-import-adic-itens.val-ii-db-cr + d-diferenca-ii.
                        WHEN 2 THEN
                            ASSIGN bf-decla-import-adic-itens.val-ii-db-cr  = 0.
                        WHEN 3 THEN
                            ASSIGN bf-decla-import-adic-itens.val-ii-outras = bf-decla-import-adic-itens.val-ii-outras + d-diferenca-ii.
                        WHEN 4 THEN
                            ASSIGN bf-decla-import-adic-itens.val-ii-db-cr  = bf-decla-import-adic-itens.val-ii-db-cr + d-diferenca-ii.
                    END CASE. /* case */
                END. /* else do */
            END. /* IF NOT l-valor-ii-manual THEN DO: */
        END. /* if avail decla-import-adic-itens */
    END. /*fim validar a diferenca do valor do II calculado para a adiá∆o e o valor total do II calculado para os itens */

    /*validar a diferenca do valor do IPI calculado para a adiá∆o e o valor total do IPI calculado para os itens */    
    ASSIGN d-valor-ipi-adicao = decla-import-adic.val-ipi-nao-tributad + decla-import-adic.val-ipi-db-cr + decla-import-adic.val-ipi-outras
           d-diferenca-ipi = 0
           d-valor-aux     = 0
           d-maior-valor   = 0
           i-num-seq-maior = 0
           l-controle      = NO.

    /* acertar o valor do ipi */
    IF d-valor-ipi-adicao <> d-valor-ipi-itens THEN DO:
        ASSIGN d-diferenca-ipi = d-valor-ipi-adicao - d-valor-ipi-itens.

        FOR EACH bf-decla-import-adic-itens NO-LOCK
            WHERE bf-decla-import-adic-itens.num-di-ems = decla-import-adic.num-di-ems
            AND   bf-decla-import-adic-itens.num-adic   = decla-import-adic.num-adic    
            AND   bf-decla-import-adic-itens.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts:

            /* passa o valor do ipi para uma variavel de comparacao */
            IF bf-decla-import-adic-itens.log-suspens-ipi-import THEN
                ASSIGN d-valor-aux = bf-decla-import-adic-itens.val-pis-nao-tributad.
            ELSE DO:
                CASE bf-decla-import-adic-itens.idi-tributac-ipi:
                    WHEN 1 THEN
                        ASSIGN d-valor-aux = bf-decla-import-adic-itens.val-ipi-db-cr.
                    WHEN 2 THEN
                        ASSIGN d-valor-aux = bf-decla-import-adic-itens.val-ipi-db-cr.
                    WHEN 3 THEN
                        ASSIGN d-valor-aux = bf-decla-import-adic-itens.val-ipi-outras.
                    WHEN 4 THEN
                        ASSIGN d-valor-aux = bf-decla-import-adic-itens.val-ipi-db-cr.
                END CASE. /* case */
            END. /* else do */
            /* fim - passa o valor do ipi para uma variavel de comparacao */

            /* se for a primeira vez que passa no loop, atribui o valor do pis na variavel de comparacao */
            IF NOT l-controle THEN
                ASSIGN l-controle = YES
                       d-maior-valor   = d-valor-aux
                       i-num-seq-maior = bf-decla-import-adic-itens.num-seq.
            ELSE DO:
                IF d-maior-valor < d-valor-aux THEN /* verifica se o valor do ipi do item Ç maior que a variavel de comparacao */
                    ASSIGN d-maior-valor   = d-valor-aux
                           i-num-seq-maior = bf-decla-import-adic-itens.num-seq.
            END.
        END. /* FOR EACH decla-import-adic-itens*/


        /* posiciona no item de maior valor de ipi da adicao para efetuar o acerto */
        FIND FIRST bf-decla-import-adic-itens EXCLUSIVE-LOCK
            WHERE bf-decla-import-adic-itens.num-di-ems = decla-import-adic.num-di-ems
            AND   bf-decla-import-adic-itens.num-adic   = decla-import-adic.num-adic
            AND   bf-decla-import-adic-itens.num-seq    = i-num-seq-maior 
            AND   bf-decla-import-adic-itens.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts no-error.

        IF AVAIL bf-decla-import-adic-itens THEN DO:
            /* acertar o valor do ipi */
            IF NOT l-valor-ipi-manual THEN DO:
                IF bf-decla-import-adic-itens.log-suspens-ipi-import THEN
                    ASSIGN bf-decla-import-adic-itens.val-ipi-nao-tributad = bf-decla-import-adic-itens.val-ipi-nao-tributad + d-diferenca-ipi WHEN NOT l-valor-ipi-manual.
                ELSE DO:
                    CASE bf-decla-import-adic-itens.idi-tributac-ipi:
                        WHEN 1 THEN
                            ASSIGN bf-decla-import-adic-itens.val-ipi-db-cr  = bf-decla-import-adic-itens.val-ipi-db-cr + d-diferenca-ipi WHEN NOT l-valor-ipi-manual.
                        WHEN 2 THEN
                            ASSIGN bf-decla-import-adic-itens.val-ipi-db-cr  = 0 WHEN NOT l-valor-ipi-manual.
                        WHEN 3 THEN
                            ASSIGN bf-decla-import-adic-itens.val-ipi-outras = bf-decla-import-adic-itens.val-ipi-outras + d-diferenca-ipi WHEN NOT l-valor-ipi-manual.
                        WHEN 4 THEN
                            ASSIGN bf-decla-import-adic-itens.val-ipi-db-cr  = bf-decla-import-adic-itens.val-ipi-db-cr + d-diferenca-ipi WHEN NOT l-valor-ipi-manual.
                    END CASE. /* case */
                END. /* else do */
            END. /* IF NOT l-valor-ipi-manual THEN DO: */
        END. /* if avail decla-import-adic-itens */
    END. /*fim validar a diferenca do valor do IPI calculado para a adiá∆o e o valor total do IPI calculado para os itens */

    /*  validar a diferenca do valor do pis calculado para a adiá∆o e o valor total do pis calculado para os itens 
        d-val-pis-adic -> somatorio dos valores de pis calculados para cada item individualmente pela imapi011
        d-val-pis-sist -> valor do pis calculado pela imapi010 com base nos valores da ADICAO
        d-val-cofins-adic -> somatorio dos valores de cofins calculados para cada item individualmente pela imapi011
        d-val-cofins-sist -> valor do cofins calculado pela imapi010 com base nos valores da ADICAO  */

    ASSIGN d-diferenca-pis = 0
           d-valor-aux     = 0
           d-maior-valor   = 0
           i-num-seq-maior = 0
           l-controle      = NO.

    /* acertar o valor do pis */
    IF d-val-pis-adic <> d-val-pis-sist THEN DO:
        ASSIGN d-diferenca-pis = d-val-pis-sist - d-val-pis-adic.

        FOR EACH bf-decla-import-adic-itens NO-LOCK
            WHERE bf-decla-import-adic-itens.num-di-ems = decla-import-adic.num-di-ems
            AND   bf-decla-import-adic-itens.num-adic   = decla-import-adic.num-adic    
            AND   bf-decla-import-adic-itens.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts:

            /* passa o valor do pis para uma variavel de comparacao */
            IF SUBSTRING(bf-decla-import-adic-itens.cod-livre-1,2,1) = '1' THEN /* log-suspens-pis */
               ASSIGN d-valor-aux = bf-decla-import-adic-itens.val-pis-nao-tributad.
            ELSE DO:
                CASE bf-decla-import-adic-itens.idi-tributac-pis:
                    WHEN 1 THEN
                        ASSIGN d-valor-aux = bf-decla-import-adic-itens.val-pis-db-cr.
                    WHEN 2 THEN
                        ASSIGN d-valor-aux = bf-decla-import-adic-itens.val-pis-db-cr.
                    WHEN 3 THEN
                        ASSIGN d-valor-aux = bf-decla-import-adic-itens.val-pis-outras.
                    WHEN 4 THEN
                        ASSIGN d-valor-aux = bf-decla-import-adic-itens.val-pis-db-cr.
                END CASE. /* case */
            END. /* else do */
            /* fim - passa o valor do pis para uma variavel de comparacao */

            /* se for a primeira vez que passa no loop, atribui o valor do pis na variavel de comparacao */
            IF NOT l-controle THEN
                ASSIGN l-controle = YES
                       d-maior-valor   = d-valor-aux
                       i-num-seq-maior = bf-decla-import-adic-itens.num-seq.
            ELSE DO:
                IF d-maior-valor < d-valor-aux THEN /* verifica se o valor do pis do item Ç maior que a variavel de comparacao */
                    ASSIGN d-maior-valor   = d-valor-aux
                           i-num-seq-maior = bf-decla-import-adic-itens.num-seq.
            END.

        END. /* FOR EACH decla-import-adic-itens*/

        /* posiciona no item de maior valor de pis da adicao para efetuar o acerto */
        FIND FIRST bf-decla-import-adic-itens EXCLUSIVE-LOCK
            WHERE bf-decla-import-adic-itens.num-di-ems = decla-import-adic.num-di-ems
            AND   bf-decla-import-adic-itens.num-adic   = decla-import-adic.num-adic
            AND   bf-decla-import-adic-itens.num-seq    = i-num-seq-maior 
            AND   bf-decla-import-adic-itens.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts no-error.

        IF AVAIL bf-decla-import-adic-itens THEN DO:
            /* acertar o valor do pis */
            IF NOT l-valor-pis-manual THEN DO:
               IF SUBSTRING(bf-decla-import-adic-itens.cod-livre-1,2,1) = '1' THEN /*log-suspens-pis*/
                  ASSIGN bf-decla-import-adic-itens.val-pis-nao-tributad = bf-decla-import-adic-itens.val-pis-nao-tributad + d-diferenca-pis.

               ELSE DO:
                   CASE bf-decla-import-adic-itens.idi-tributac-pis:
                       WHEN 1 THEN
                           ASSIGN bf-decla-import-adic-itens.val-pis-db-cr  = bf-decla-import-adic-itens.val-pis-db-cr + d-diferenca-pis.
                       WHEN 2 THEN
                           ASSIGN bf-decla-import-adic-itens.val-pis-db-cr  = 0.
                       WHEN 3 THEN
                           ASSIGN bf-decla-import-adic-itens.val-pis-outras = bf-decla-import-adic-itens.val-pis-outras + d-diferenca-pis.
                       WHEN 4 THEN
                           ASSIGN bf-decla-import-adic-itens.val-pis-db-cr  = bf-decla-import-adic-itens.val-pis-db-cr + d-diferenca-pis.
                   END CASE. /* case */
               END. /* else do */
            END. /* IF NOT l-valor-pis-manual THEN DO: */
        END. /* if avail decla-import-adic-itens */
    END. /* if */                                        

    ASSIGN d-diferenca-cofins = 0
           d-valor-aux        = 0
           d-maior-valor      = 0
           i-num-seq-maior    = 0
           l-controle         = NO.

    /* acertar o valor do cofins */
    IF d-val-cofins-adic <> d-val-cofins-sist THEN DO:
        ASSIGN d-diferenca-cofins = d-val-cofins-sist - d-val-cofins-adic.

        FOR EACH bf-decla-import-adic-itens NO-LOCK
            WHERE bf-decla-import-adic-itens.num-di-ems = decla-import-adic.num-di-ems
            AND   bf-decla-import-adic-itens.num-adic   = decla-import-adic.num-adic
            AND   bf-decla-import-adic-itens.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts:

            /* passa o valor do cofins para uma variavel de comparacao */
            IF SUBSTRING(bf-decla-import-adic-itens.cod-livre-1,3,1) = '1' THEN /* log-suspens-cofins */            
               ASSIGN d-valor-aux = bf-decla-import-adic-itens.val-cofins-nao-tributad.
            ELSE DO:
                CASE bf-decla-import-adic-itens.idi-tributac-cofins:
                    WHEN 1 THEN
                        ASSIGN d-valor-aux = bf-decla-import-adic-itens.val-cofins-db-cr.
                    WHEN 2 THEN
                        ASSIGN d-valor-aux = bf-decla-import-adic-itens.val-cofins-db-cr.
                    WHEN 3 THEN
                        ASSIGN d-valor-aux = bf-decla-import-adic-itens.val-cofins-outras.
                    WHEN 4 THEN
                        ASSIGN d-valor-aux = bf-decla-import-adic-itens.val-cofins-db-cr.
                END CASE. /* case */
            END. /* else do */
            /* fim - passa o valor do cofins para uma variavel de comparacao */

            /* se for a primeira vez que passa no loop, atribui o valor do cofins na variavel de comparacao */
            IF NOT l-controle THEN
                ASSIGN l-controle = YES
                       d-maior-valor   = d-valor-aux
                       i-num-seq-maior = bf-decla-import-adic-itens.num-seq.
            ELSE DO:
                IF d-maior-valor < d-valor-aux THEN /* verifica se o valor do cofins do item Ç maior que a variavel de comparacao */
                    ASSIGN d-maior-valor   = d-valor-aux
                           i-num-seq-maior = bf-decla-import-adic-itens.num-seq.
            END.

        END. /* FOR EACH decla-import-adic-itens*/

        /* posiciona no item de maior valor de cofins da adicao para efetuar o acerto */
        FIND FIRST bf-decla-import-adic-itens EXCLUSIVE-LOCK
            WHERE bf-decla-import-adic-itens.num-di-ems = decla-import-adic.num-di-ems
            AND   bf-decla-import-adic-itens.num-adic   = decla-import-adic.num-adic
            AND   bf-decla-import-adic-itens.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts
            AND   bf-decla-import-adic-itens.num-seq    = i-num-seq-maior no-error.

        IF AVAIL bf-decla-import-adic-itens THEN DO:
            IF NOT l-valor-cofins-manual THEN DO:
                IF SUBSTRING(bf-decla-import-adic-itens.cod-livre-1,3,1) = '1' THEN /* log-suspens-cofins */
                   ASSIGN bf-decla-import-adic-itens.val-cofins-nao-tributad = bf-decla-import-adic-itens.val-cofins-nao-tributad + d-diferenca-cofins.

                ELSE DO:
                    CASE bf-decla-import-adic-itens.idi-tributac-cofins:
                        WHEN 1 THEN
                            ASSIGN bf-decla-import-adic-itens.val-cofins-db-cr  = bf-decla-import-adic-itens.val-cofins-db-cr + d-diferenca-cofins.
                        WHEN 2 THEN
                            ASSIGN bf-decla-import-adic-itens.val-cofins-db-cr  = 0.
                        WHEN 3 THEN
                            ASSIGN bf-decla-import-adic-itens.val-cofins-outras = bf-decla-import-adic-itens.val-cofins-outras + d-diferenca-cofins.
                        WHEN 4 THEN
                            ASSIGN bf-decla-import-adic-itens.val-cofins-db-cr  = bf-decla-import-adic-itens.val-cofins-db-cr + d-diferenca-cofins.
                    END CASE. /* case */
                END. /* else do */
            END. /* IF NOT l-valor-cofins-manual THEN DO: */
        END. /* if avail decla-import-adic-itens */
    END. /* if */    
    /* fim - validar a diferenca do valor do cofins calculado para a adiá∆o e o valor total do pis calculado para os itens */


    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaValorAcresc DBOProgram 
PROCEDURE atualizaValorAcresc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM p-num-di-ems   LIKE decla-import-ord.num-di-ems  NO-UNDO.
    DEF INPUT  PARAM p-cdd-siscomex-dts LIKE decla-import-ord.cdd-siscomex-dts NO-UNDO.

    empty temp-table tt-despes-adic-acerto.
    FOR FIRST decla-import EXCLUSIVE-LOCK
        WHERE decla-import.num-di-ems = p-num-di-ems
          AND decla-import.cdd-siscomex-dts = p-cdd-siscomex-dts,
        FIRST tt-di-totais
        WHERE tt-di-totais.num-di-ems = decla-import.num-di-ems:

        FOR FIRST param-imp NO-LOCK
            WHERE param-imp.cod-estabel = decla-import.cod-estab: END.

        FOR EACH decla-import-adic EXCLUSIVE-LOCK
            WHERE decla-import-adic.num-di-ems = decla-import.num-di-ems 
              AND decla-import-adic.cdd-siscomex-dts = decla-import.cdd-siscomex-dts:

            FOR EACH tt-despesas
                WHERE tt-despesas.num-di-ems = decla-import.num-di-ems
                AND   NOT tt-despesas.log-frete
                AND   NOT tt-despesas.log-seguro:
                

                FOR FIRST despes-adic NO-LOCK
                    WHERE despes-adic.num-di-ems = decla-import-adic.num-di-ems
                    AND   despes-adic.num-adic   = decla-import-adic.num-adic
                    AND   despes-adic.cdn-despes = tt-despesas.cdn-despes
                    AND   despes-adic.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts:

                    ASSIGN de-valor-despesa = 0.
    
                    IF tt-despesas.cdn-moeda <> 0 THEN DO:

                        /*Edson - 13/11/2012 - Convertendo para Moeda Real*/
                        RUN converteValorMoeda (INPUT decla-import-adic.num-di-ems,
                                                INPUT decla-import-adic.cdd-siscomex-dts,
                                                INPUT tt-despesas.cdn-moeda,
                                                INPUT 0,
                                                INPUT despes-adic.val-despes,
                                                INPUT decla-import.dat-di,
                                                OUTPUT de-valor-despesa).

                        /*Convertendo para Moeda Real*/
                        /*RUN converteValorMoeda (INPUT decla-import-adic.num-di-ems,
                                                INPUT tt-despesas.cdn-moeda,
                                                INPUT 0,
                                                INPUT tt-desp-rateio.val-desp,
                                                INPUT decla-import.dat-di,
                                                OUTPUT de-valor-despesa).*/
    
                        ASSIGN decla-import-adic.val-acresc   = decla-import-adic.val-acresc + de-valor-despesa.

                        ASSIGN de-valor-despesa = 0.
                        
                        /*Edson - 13/11/2012 - Convertendo da moeda da despesa para d¢lar*/
                        RUN converteValorMoeda (INPUT decla-import-adic.num-di-ems,
                                                INPUT decla-import-adic.cdd-siscomex-dts,
                                                INPUT tt-despesas.cdn-moeda,
                                                INPUT param-imp.int-2,
                                                INPUT despes-adic.val-despes,
                                                INPUT decla-import.dat-di,
                                                OUTPUT de-valor-despesa).
    
                        /*Convertendo da moeda da despesa para d¢lar*/
                        /*RUN converteValorMoeda (INPUT decla-import-adic.num-di-ems,
                                                INPUT tt-despesas.cdn-moeda,
                                                INPUT param-imp.int-2,
                                                INPUT tt-desp-rateio.val-desp,
                                                INPUT decla-import.dat-di,
                                                OUTPUT de-valor-despesa).*/
    
                        ASSIGN decla-import-adic.val-acresc-me[1] = decla-import-adic.val-acresc-me[1] + de-valor-despesa
                               decla-import-adic.val-acresc-me[2] = decla-import-adic.val-acresc-me[2] + de-valor-despesa.
    
                    END.
                    ELSE DO:                    
                        /*Convertendo para d¢lar*/

                        RUN converteValorMoeda (INPUT decla-import-adic.num-di-ems,
                                                INPUT decla-import-adic.cdd-siscomex-dts,
                                                INPUT tt-despesas.cdn-moeda,
                                                INPUT param-imp.int-2,
                                                INPUT despes-adic.val-despes,
                                                INPUT decla-import.dat-di,
                                                OUTPUT de-valor-despesa).

                        ASSIGN decla-import-adic.val-acresc       = decla-import-adic.val-acresc       + despes-adic.val-despes
                               decla-import-adic.val-acresc-me[1] = decla-import-adic.val-acresc-me[1] + de-valor-despesa
                               decla-import-adic.val-acresc-me[2] = decla-import-adic.val-acresc-me[2] + de-valor-despesa.

                    END.
                END.                                                                            
            END.    
            /* taxa siscomex */
            /*A taxa siscomex n∆o Ç considerada no rateio mas deve ser considerada nas despesas complementares*/
            IF NOT VALID-HANDLE(h-bocx406) THEN
                RUN cxbo/bocx406.p PERSISTEN SET h-bocx406.
    
            RUN pi-busca-despes-siscomex IN h-bocx406 (INPUT p-num-di-ems,
                                                       INPUT p-cdd-siscomex-dts,
                                                       OUTPUT i-cdn-despes-siscomex,
                                                       OUTPUT i-cdn-emit-siscomex,
                                                       OUTPUT l-taxa-siscomex).
            IF l-taxa-siscomex THEN DO:
                FOR FIRST despes-adic NO-LOCK
                    WHERE despes-adic.num-di-ems = p-num-di-ems
                    AND   despes-adic.num-adic   = decla-import-adic.num-adic
                    AND   despes-adic.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts
                    AND   despes-adic.cdn-despes = i-cdn-despes-siscomex :

                    IF despes-adic.cdn-moeda <> 0 THEN DO:

                        ASSIGN de-valor-despesa = 0.
                        /*Convertendo para Moeda Real*/
                        RUN converteValorMoeda (INPUT decla-import-adic.num-di-ems,
                                                INPUT decla-import-adic.cdd-siscomex-dts,
                                                INPUT despes-adic.cdn-moeda,
                                                INPUT 0,
                                                INPUT despes-adic.val-despes,
                                                INPUT decla-import.dat-di,
                                                OUTPUT de-valor-despesa).

                        ASSIGN decla-import-adic.val-acresc   = decla-import-adic.val-acresc + de-valor-despesa.

                        ASSIGN de-valor-despesa = 0.

                        /*Convertendo da moeda da despesa para d¢lar*/
                        RUN converteValorMoeda (INPUT decla-import-adic.num-di-ems,
                                                INPUT decla-import-adic.cdd-siscomex-dts,
                                                INPUT despes-adic.cdn-moeda,
                                                INPUT param-imp.int-2,
                                                INPUT despes-adic.val-despes,
                                                INPUT decla-import.dat-di,
                                                OUTPUT de-valor-despesa).

                        ASSIGN decla-import-adic.val-acresc-me[1] = decla-import-adic.val-acresc-me[1] + de-valor-despesa
                               decla-import-adic.val-acresc-me[2] = decla-import-adic.val-acresc-me[2] + de-valor-despesa.

                    END.
                    ELSE DO:
                        /*Convertendo para d¢lar*/
                        RUN converteValorMoeda (INPUT decla-import-adic.num-di-ems,
                                                INPUT decla-import-adic.cdd-siscomex-dts,
                                                INPUT despes-adic.cdn-moeda,
                                                INPUT param-imp.int-2,
                                                INPUT despes-adic.val-despes,
                                                INPUT decla-import.dat-di,
                                                OUTPUT de-valor-despesa).

                        ASSIGN decla-import-adic.val-acresc       = decla-import-adic.val-acresc       + despes-adic.val-despes
                               decla-import-adic.val-acresc-me[1] = decla-import-adic.val-acresc-me[1] + de-valor-despesa
                               decla-import-adic.val-acresc-me[2] = decla-import-adic.val-acresc-me[2] + de-valor-despesa.
                    END.
                END.
            END.
            /* taxa siscomex */

            /*Atualizando valores DI*/
            ASSIGN decla-import.val-acresc       = decla-import.val-acresc       + decla-import-adic.val-acresc       
                   decla-import.val-acresc-me[1] = decla-import.val-acresc-me[1] + decla-import-adic.val-acresc-me[1] 
                   decla-import.val-acresc-me[2] = decla-import.val-acresc-me[2] + decla-import-adic.val-acresc-me[2].

            

        END.
    END.

    RELEASE decla-import.
    RELEASE decla-import-adic.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaValorAcrescItem DBOProgram 
PROCEDURE atualizaValorAcrescItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM p-num-di-ems   LIKE decla-import-ord.num-di-ems  NO-UNDO.
    DEF INPUT  PARAM p-cdd-siscomex-dts LIKE decla-import-ord.cdd-siscomex-dts NO-UNDO.

    FIND FIRST decla-import NO-LOCK 
        WHERE decla-import.num-di-ems = p-num-di-ems 
          AND decla-import.cdd-siscomex-dts = p-cdd-siscomex-dts NO-ERROR.
    FIND FIRST param-imp NO-LOCK
        WHERE param-imp.cod-estabel = decla-import.cod-estab NO-ERROR.

    FOR EACH decla-import-adic EXCLUSIVE-LOCK
        WHERE decla-import-adic.num-di-ems = p-num-di-ems
          AND decla-import-adic.cdd-siscomex-dts = p-cdd-siscomex-dts,
        FIRST decla-import NO-LOCK
        WHERE decla-import.num-di-ems = decla-import-adic.num-di-ems
          AND decla-import.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts,
        FIRST tt-adic-totais
        WHERE tt-adic-totais.num-di-ems = decla-import-adic.num-di-ems
        AND   tt-adic-totais.num-adic   = decla-import-adic.num-adic:
        

        FOR EACH decla-import-adic-itens EXCLUSIVE-LOCK
            WHERE decla-import-adic-itens.num-di-ems = decla-import-adic.num-di-ems 
            AND   decla-import-adic-itens.num-adic   = decla-import-adic.num-adic
            AND   decla-import-adic-itens.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts:

            ASSIGN decla-import-adic-itens.val-acresc       = 0
                   decla-import-adic-itens.val-acresc-me[1] = 0 
                   decla-import-adic-itens.val-acresc-me[2] = 0.

            FOR EACH tt-despesas
                WHERE tt-despesas.num-di-ems = decla-import-adic.num-di-ems
                AND   tt-despesas.num-adic   = decla-import-adic.num-adic
                AND   NOT tt-despesas.log-frete
                AND   NOT tt-despesas.log-seguro :

                FOR EACH tt-desp-rateio-item
                    WHERE tt-desp-rateio-item.num-di-ems   = decla-import-adic-itens.num-di-ems
                    AND   tt-desp-rateio-item.num-adic     = decla-import-adic-itens.num-adic
                    AND   tt-desp-rateio-item.numero-ordem = decla-import-adic-itens.num-ordem
                    AND   tt-desp-rateio-item.parcela      = decla-import-adic-itens.num-parcela
                    AND   tt-desp-rateio-item.cod-desp     = tt-despesas.cdn-despes:


                    ASSIGN de-valor-despesa = 0.
    
                    IF tt-despesas.cdn-moeda <> 0 THEN DO:
                        /*Convertendo para Moeda Real*/
                        RUN converteValorMoeda (INPUT decla-import-adic.num-di-ems,
                                                INPUT decla-import-adic.cdd-siscomex-dts,
                                                INPUT tt-despesas.cdn-moeda,
                                                INPUT 0,
                                                INPUT tt-desp-rateio-item.val-desp,
                                                INPUT decla-import.dat-di,
                                                OUTPUT de-valor-despesa).
    
                        ASSIGN decla-import-adic-itens.val-acresc   = decla-import-adic-itens.val-acresc + de-valor-despesa.
    
                        ASSIGN de-valor-despesa = 0.
    
                        /*Convertendo da moeda da despesa para d¢lar*/
                        RUN converteValorMoeda (INPUT decla-import-adic.num-di-ems,
                                                INPUT decla-import-adic.cdd-siscomex-dts,
                                                INPUT tt-despesas.cdn-moeda,
                                                INPUT param-imp.int-2,
                                                INPUT tt-desp-rateio-item.val-desp,
                                                INPUT decla-import.dat-di,
                                                OUTPUT de-valor-despesa).
    
                        ASSIGN decla-import-adic-itens.val-acresc-me[1] = decla-import-adic-itens.val-acresc-me[1] + de-valor-despesa
                               decla-import-adic-itens.val-acresc-me[2] = 0. 
    
                    END.
                    ELSE DO:                    
                        /*Convertendo para d¢lar*/
                        RUN converteValorMoeda (INPUT decla-import-adic.num-di-ems,
                                                INPUT decla-import-adic.cdd-siscomex-dts,
                                                INPUT tt-despesas.cdn-moeda,
                                                INPUT param-imp.int-2,
                                                INPUT tt-desp-rateio-item.val-desp,
                                                INPUT decla-import.dat-di,
                                                OUTPUT de-valor-despesa).
                        ASSIGN decla-import-adic-itens.val-acresc       = decla-import-adic-itens.val-acresc       + tt-desp-rateio-item.val-desp
                               decla-import-adic-itens.val-acresc-me[1] = decla-import-adic-itens.val-acresc-me[1] + de-valor-despesa
                               decla-import-adic-itens.val-acresc-me[2] = 0.

                    END.
                END.                                                                            
            END.    

            /* taxa siscomex */
            /*A taxa siscomex n∆o Ç considerada no rateio mas deve ser considerada nas despesas complementares*/
            IF NOT VALID-HANDLE(h-bocx406) THEN
                RUN cxbo/bocx406.p PERSISTEN SET h-bocx406.
    
            RUN pi-busca-despes-siscomex IN h-bocx406 (INPUT p-num-di-ems,
                                                       INPUT p-cdd-siscomex-dts,
                                                       OUTPUT i-cdn-despes-siscomex,
                                                       OUTPUT i-cdn-emit-siscomex,
                                                       OUTPUT l-taxa-siscomex).

            IF l-taxa-siscomex THEN DO:
                FOR FIRST despes-adic-itens NO-LOCK
                    WHERE despes-adic-itens.num-di-ems = p-num-di-ems
                    AND   despes-adic-itens.num-adic   = decla-import-adic.num-adic
                    AND   despes-adic-itens.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts
                    AND   despes-adic-itens.cdn-despes = i-cdn-despes-siscomex :

                    IF despes-adic-itens.cdn-moeda <> 0 THEN DO:

                        ASSIGN de-valor-despesa = 0.
                        /*Convertendo para Moeda Real*/
                        RUN converteValorMoeda (INPUT decla-import-adic.num-di-ems,
                                                INPUT decla-import-adic.cdd-siscomex-dts,
                                                INPUT despes-adic-itens.cdn-moeda,
                                                INPUT 0,
                                                INPUT despes-adic-itens.val-despes,
                                                INPUT decla-import.dat-di,
                                                OUTPUT de-valor-despesa).
    
                        ASSIGN decla-import-adic-itens.val-acresc   = decla-import-adic-itens.val-acresc + de-valor-despesa.
    
                        ASSIGN de-valor-despesa = 0.
    
                        /*Convertendo da moeda da despesa para d¢lar*/
                        RUN converteValorMoeda (INPUT decla-import-adic.num-di-ems,
                                                INPUT decla-import-adic.cdd-siscomex-dts,
                                                INPUT despes-adic-itens.cdn-moeda,
                                                INPUT param-imp.int-2,
                                                INPUT despes-adic-itens.val-despes,
                                                INPUT decla-import.dat-di,
                                                OUTPUT de-valor-despesa).
    
                        ASSIGN decla-import-adic-itens.val-acresc-me[1] = decla-import-adic-itens.val-acresc-me[1] + de-valor-despesa
                               decla-import-adic-itens.val-acresc-me[2] = decla-import-adic-itens.val-acresc-me[2] + de-valor-despesa.
    
                    END.
                    ELSE DO:        
                        /*Convertendo para d¢lar*/
                        RUN converteValorMoeda (INPUT decla-import-adic.num-di-ems,
                                                INPUT decla-import-adic.cdd-siscomex-dts,
                                                INPUT despes-adic-itens.cdn-moeda,
                                                INPUT param-imp.int-2,
                                                INPUT despes-adic-itens.val-despes,
                                                INPUT decla-import.dat-di,
                                                OUTPUT de-valor-despesa).
                        ASSIGN decla-import-adic-itens.val-acresc       = decla-import-adic-itens.val-acresc       + despes-adic-itens.val-despes
                               decla-import-adic-itens.val-acresc-me[1] = decla-import-adic-itens.val-acresc-me[1] + de-valor-despesa
                               decla-import-adic-itens.val-acresc-me[2] = decla-import-adic-itens.val-acresc-me[2] + de-valor-despesa.
                    END.
                END.
            END.
            /* taxa siscomex */
        END.
    END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaValores DBOProgram 
PROCEDURE atualizaValores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>

  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM p-num-di-ems   LIKE decla-import-ord.num-di-ems  NO-UNDO.
    DEF INPUT  PARAM p-cdd-siscomex-dts LIKE decla-import-ord.cdd-siscomex-dts NO-UNDO.

    FOR FIRST decla-import EXCLUSIVE-LOCK
        WHERE decla-import.num-di-ems = p-num-di-ems
          AND decla-import.cdd-siscomex-dts = p-cdd-siscomex-dts,
        FIRST tt-di-totais
        WHERE tt-di-totais.num-di-ems = decla-import.num-di-ems:          

        ASSIGN decla-import.val-vmle = tt-di-totais.val-merc-di
               decla-import.val-vmld = tt-di-totais.val-merc-di
               decla-import.val-vmcv = tt-di-totais.val-merc-di.

        IF CAN-FIND(FIRST tt-despesas
                    WHERE tt-despesas.num-di-ems = decla-import.num-di-ems
                    AND   tt-despesas.num-adic   = 0) THEN DO:

            FOR EACH tt-despesas
                WHERE tt-despesas.num-di-ems = p-num-di-ems
                AND   tt-despesas.num-adic   = 0:

                /*Determinar o VMLE*/
                IF tt-despesas.log-incid-vmle THEN DO:
                    ASSIGN de-valor-despesa = 0.
    
                    IF i-mo-codigo <> tt-despesas.cdn-moeda THEN DO:
                        RUN converteValorMoeda (INPUT decla-import.num-di-ems,
                                                INPUT decla-import.cdd-siscomex-dts,
                                                INPUT tt-despesas.cdn-moeda,
                                                INPUT i-mo-codigo,
                                                INPUT tt-despesas.val-despes,
                                                INPUT decla-import.dat-di,
                                                OUTPUT de-valor-despesa).
                    END.
                    ELSE 
                        ASSIGN de-valor-despesa = tt-despesas.val-despes.

                    ASSIGN decla-import.val-vmle = decla-import.val-vmle + de-valor-despesa.
                END.

                /*Determinar VMLD*/
                IF tt-despesas.log-incid-val-aduana THEN DO:
                    ASSIGN de-valor-despesa = 0.
                    IF i-mo-codigo <> tt-despesas.cdn-moeda THEN DO:
                        RUN converteValorMoeda (INPUT decla-import.num-di-ems,
                                                INPUT decla-import.cdd-siscomex-dts,
                                                INPUT tt-despesas.cdn-moeda,
                                                INPUT i-mo-codigo,
                                                INPUT tt-despesas.val-despes,
                                                INPUT decla-import.dat-di,
                                                OUTPUT de-valor-despesa).
                    END.
                    ELSE 
                        ASSIGN de-valor-despesa = tt-despesas.val-despes.

                    ASSIGN decla-import.val-vmld = decla-import.val-vmld + de-valor-despesa.
                END.

                /*Valor Frete*/
                IF tt-despesas.log-frete THEN
                    ASSIGN decla-import.val-frete = tt-despesas.val-despes.

                /*Valor Seguro*/
                IF tt-despesas.log-seguro THEN
                    ASSIGN decla-import.val-seguro = tt-despesas.val-despes.
            END.
        END.

        FOR FIRST decla-import-embarq NO-LOCK
            WHERE decla-import-embarq.num-di-ems = decla-import.num-di-ems
              AND decla-import-embarq.cdd-siscomex-dts = decla-import.cdd-siscomex-dts,
            FIRST embarque-imp NO-LOCK
            WHERE embarque-imp.cod-estabel = decla-import-embarq.cod-estab
            AND   embarque-imp.embarque    = decla-import-embarq.cod-embarq:
            
            FOR EACH decla-import-adic EXCLUSIVE-LOCK
                WHERE decla-import-adic.num-di-ems = decla-import-embarq.num-di-ems
                AND decla-import-adic.cdd-siscomex-dts = decla-import-embarq.cdd-siscomex-dts,
                FIRST tt-adic-totais
                WHERE tt-adic-totais.num-di-ems = decla-import-adic.num-di-ems 
                AND   tt-adic-totais.num-adic   = decla-import-adic.num-adic:
                ASSIGN decla-import-adic.val-vmcv = tt-adic-totais.val-merc-adic.
            END.

            /*Atualiza valor vmcv para acrescentar no valor liquido da mercadoria as despesas que fazem parte da incoterm*/
            FOR EACH  tt-despesas
                WHERE /*tt-despesas.cdn-despes     = desp-incoterm.cod-desp
                AND*/   tt-despesas.num-di-ems     = decla-import.num-di-ems
                AND   tt-despesas.num-adic       = 0
                AND   tt-despesas.i-tip-incid-nf = 1 //Incide na NF de Nacionalizaá∆o
                AND   tt-despesas.log-forma-preco-compra:

                ASSIGN de-valor-despesa = 0.

                IF i-mo-codigo <> tt-despesas.cdn-moeda THEN DO:
                    RUN converteValorMoeda (INPUT decla-import.num-di-ems,
                                            INPUT decla-import.cdd-siscomex-dts,
                                            INPUT tt-despesas.cdn-moeda,
                                            INPUT i-mo-codigo,
                                            INPUT tt-despesas.val-despes,
                                            INPUT decla-import.dat-di,
                                            OUTPUT de-valor-despesa).
                END.
                ELSE 
                    ASSIGN de-valor-despesa = tt-despesas.val-despes.

                ASSIGN decla-import.val-vmcv = decla-import.val-vmcv + de-valor-despesa.

                FOR EACH tt-adic-totais
                    WHERE tt-adic-totais.num-di-ems = decla-import.num-di-ems:
                    FOR FIRST tt-desp-rateio
                        WHERE tt-desp-rateio.num-di-ems = tt-adic-totais.num-di-ems
                        AND   tt-desp-rateio.num-adic   = tt-adic-totais.num-adic
                        AND   tt-desp-rateio.cod-desp   = tt-despesas.cdn-despes:
                        

                        /*Atualiza valor vmcv da adiá∆o para acrescentar no valor liquido da mercadoria as despesas que fazem parte da incoterm*/
                        FOR FIRST decla-import-adic EXCLUSIVE-LOCK
                            WHERE decla-import-adic.num-di-ems = tt-adic-totais.num-di-ems
                            AND   decla-import-adic.num-adic   = tt-adic-totais.num-adic:
                            ASSIGN decla-import-adic.val-vmcv = decla-import-adic.val-vmcv +  tt-desp-rateio.val-desp.
                        END.
                    END.
                END.
            END.
        END.    
    END.
    RELEASE decla-import.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
                                                                                                         
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaValoresMercAdicDI DBOProgram 
PROCEDURE atualizaValoresMercAdicDI :
/*-----------------------------------------------------------------------------------
  Purpose: 
  Notes:       
-------------------------------------------------------------------------------------*/

    DEF  INPUT PARAM pnum-di-ems    LIKE {&TableName}.num-di-ems NO-UNDO.
    DEF  INPUT PARAM p-cdd-siscomex-dts LIKE {&TableName}.cdd-siscomex-dts NO-UNDO.

    /*Voltando os valores da adiá∆o ao valor inicial*/
    FOR EACH tt-adic-totais:
        ASSIGN tt-adic-totais.val-merc-adic = tt-adic-totais.val-preco-adic.
    END.
    
    FOR EACH tt-desp-rateio
        WHERE tt-desp-rateio.num-di-ems = pnum-di-ems :
        /*Diminuir valor das despesas que formam preáo compra*/
        FOR FIRST despes-decla-import NO-LOCK
            WHERE despes-decla-import.num-di-ems = pnum-di-ems 
            AND   despes-decla-import.cdn-despes = tt-desp-rateio.cod-desp 
            AND   despes-decla-import.cdd-siscomex-dts = p-cdd-siscomex-dts:
            
            IF despes-decla-import.log-forma-preco-compra THEN DO:
                FOR EACH tt-adic-totais 
                    WHERE tt-adic-totais.num-di-ems = despes-decla-import.num-di-ems
                    AND   tt-adic-totais.num-adic   = tt-desp-rateio.num-adic:
                    ASSIGN tt-adic-totais.val-merc-adic = tt-adic-totais.val-merc-adic - tt-desp-rateio.val-desp.
                END.            
            END.     
        END.

        FOR FIRST despes-adic NO-LOCK
            WHERE despes-adic.num-di-ems = pnum-di-ems 
            AND   despes-adic.num-adic   = tt-desp-rateio.num-adic
            AND   despes-adic.cdn-despes = tt-desp-rateio.cod-desp 
            AND   despes-adic.cdd-siscomex-dts = p-cdd-siscomex-dts
            AND   despes-adic.idi-orig-despes = 1:
            IF despes-adic.log-forma-preco-compra THEN DO:
                FOR EACH tt-adic-totais 
                    WHERE tt-adic-totais.num-di-ems = despes-adic.num-di-ems
                    AND   tt-adic-totais.num-adic   = despes-adic.num-adic:
                    ASSIGN tt-adic-totais.val-merc-adic = tt-adic-totais.val-merc-adic - tt-desp-rateio.val-desp.    
                END.    
            END.                
        END.   
    END.

    /*Atualizando valor da mercadoria da tt-di-totais*/
    FOR EACH tt-di-totais
        WHERE tt-di-totais.num-di-ems  = pnum-di-ems:
        ASSIGN tt-di-totais.val-merc-di = 0.
        FOR EACH tt-adic-totais
            WHERE tt-adic-totais.num-di-ems = tt-di-totais.num-di-ems:
            ASSIGN tt-di-totais.val-merc-di = tt-di-totais.val-merc-di + tt-adic-totais.val-merc-adic.
        END.            
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaValoresMercOrdemAdic DBOProgram 
PROCEDURE atualizaValoresMercOrdemAdic :
/*-----------------------------------------------------------------------------------
  Purpose: 
  Notes:       
-------------------------------------------------------------------------------------*/

    DEF  INPUT PARAM pnum-di-ems    LIKE {&TableName}.num-di-ems NO-UNDO.
    DEF  INPUT PARAM p-cdd-siscomex-dts LIKE {&TableName}.cdd-siscomex-dts NO-UNDO.

    FOR EACH tt-ordens-totais
        WHERE tt-ordens-totais.num-di-ems = pnum-di-ems:
        ASSIGN tt-ordens-totais.val-merc = tt-ordens-totais.val-preco-merc.
    END.
    
    FOR EACH tt-desp-rateio-item
        WHERE tt-desp-rateio-item.num-di-ems = pnum-di-ems,
        /*Diminuir valor das despesas que formam preáo compra*/
        FIRST despes-adic NO-LOCK
        WHERE despes-adic.num-di-ems = pnum-di-ems 
        AND   despes-adic.num-adic   = tt-desp-rateio-item.num-adic
        AND   despes-adic.cdn-despes = tt-desp-rateio-item.cod-desp
        AND   despes-adic.cdd-siscomex-dts= p-cdd-siscomex-dts:
        IF despes-adic.log-forma-preco-compra THEN DO:
            FOR FIRST tt-ordens-totais
                WHERE tt-ordens-totais.num-di-ems   = tt-desp-rateio-item.num-di-ems
                AND   tt-ordens-totais.num-adic     = tt-desp-rateio-item.num-adic
                AND   tt-ordens-totais.numero-ordem = tt-desp-rateio-item.numero-ordem
                AND   tt-ordens-totais.parcela      = tt-desp-rateio-item.parcela:
                ASSIGN tt-ordens-totais.val-merc = tt-ordens-totais.val-merc - tt-desp-rateio-item.val-desp.
            END.            
        END.
    END.

    /*Atualizando valor da mercadoria da tt-adic-totais*/
    FOR EACH tt-adic-totais
        WHERE tt-adic-totais.num-di-ems = pnum-di-ems:
        ASSIGN tt-adic-totais.val-merc-adic = 0.
        FOR EACH tt-ordens-totais
            WHERE tt-ordens-totais.num-di-ems = tt-adic-totais.num-di-ems
            AND   tt-ordens-totais.num-adic   = tt-adic-totais.num-adic :
            ASSIGN tt-adic-totais.val-merc-adic = tt-adic-totais.val-merc-adic + tt-ordens-totais.val-merc.                                                                                     
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculaICMS DBOProgram 
PROCEDURE calculaICMS :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    {utp/ut-liter.i "Calculando_ICMS" *}
    RUN pi-acompanhar IN h-acomp (INPUT RETURN-VALUE). /* altera a mensagem do acompanhamentos */

    DEF VAR d-valor-merc-liq     LIKE decla-import-adic.val-vmle      NO-UNDO.
    
    DEF VAR i                    AS INTEGER INITIAL 0                 NO-UNDO.
    DEF VAR piItem               AS CHAR                              NO-UNDO.
    DEF VAR l-procedimento-ok    AS LOGICAL                           NO-UNDO.
    DEF VAR de-valor-incide-ipi  AS DECIMAL                           NO-UNDO.
    DEF VAR p-imp-manual         AS LOGICAL                           NO-UNDO.

    IF NOT VALID-HANDLE(h-bodi317im2bra) THEN
        RUN dibo/bodi317im2bra PERSISTEN SET h-bodi317im2bra.

    RUN limpaTbWt. /* limpar as temp-tables tb-wt-docto, tb-wt-it-docto, tb-wt-it-imposto e tb-ct-trib-wt-item-docto */
    
    ASSIGN i = i + 1.
    
    FIND FIRST estabelec NO-LOCK
         WHERE estabelec.cod-estabel = decla-import.cod-estab NO-ERROR.
    
    FOR FIRST decla-import-ord NO-LOCK
        WHERE decla-import-ord.num-di-ems  = decla-import-adic.num-di-ems
        AND   decla-import-ord.num-adic    = decla-import-adic.num-adic
        AND   decla-import-ord.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts:

        FIND FIRST natur-oper NO-LOCK
             WHERE natur-oper.nat-operacao = decla-import-ord.cod-natur-operac NO-ERROR.
    END.

    FIND FIRST emitente NO-LOCK
         WHERE emitente.cod-emitente = decla-import-adic.cdn-fornec NO-ERROR.
        
    ASSIGN piItem = STRING(decla-import.num-di-ems) + "/" + STRING(decla-import.cdd-siscomex-dts) + "/" + STRING(decla-import-adic.num-adic).

    /* calculo da base do icms */
    
    FIND FIRST desp-imp NO-LOCK
         WHERE desp-imp.cod-desp = i-cod-desp-ii NO-ERROR.

    IF AVAIL desp-imp AND desp-imp.inc-base-icms THEN DO: /* II incide na base de icms */

        ASSIGN decla-import-adic.val-base-icms = ROUND(decla-import-adic.val-base-icms 
                                                     + decla-import-adic.val-ii-db-cr
                                                     + decla-import-adic.val-ii-outras,8) WHEN NOT l-base-icms-manual
               
               d-base-icms-adic-aux            = ROUND(d-base-icms-adic-aux 
                                                     + decla-import-adic.val-ii-db-cr
                                                     + decla-import-adic.val-ii-outras,2) WHEN NOT l-base-icms-manual.
    END.

    /* IPI incide na base do icms - natur-oper */
    IF SUBSTRING(natur-oper.char-2,1,5) = "1    " THEN DO:

        ASSIGN decla-import-adic.val-base-icms = ROUND(decla-import-adic.val-base-icms 
                                                     + decla-import-adic.val-ipi-db-cr
                                                     + decla-import-adic.val-ipi-outras,8) WHEN NOT l-base-icms-manual
               
               d-base-icms-adic-aux            = ROUND(d-base-icms-adic-aux 
                                                     + decla-import-adic.val-ipi-db-cr
                                                     + decla-import-adic.val-ipi-outras,2) WHEN NOT l-base-icms-manual.
    END.
    
    FIND FIRST param-imp WHERE param-imp.cod-estabel = decla-import.cod-estab NO-LOCK NO-ERROR.
    /* PIS e COFINS incidem na base do icms -> item-mat - cd2510 */
    FOR FIRST item-mat NO-LOCK
        WHERE item-mat.it-codigo = decla-import-ord.cod-item:
        
        IF param-imp.log-incid-pis-base-icms THEN /* pis incide em icms */
            ASSIGN decla-import-adic.val-base-icms = ROUND(decla-import-adic.val-base-icms 
                                                         + decla-import-adic.val-pis-db-cr
                                                         + decla-import-adic.val-pis-outras, 8) WHEN NOT l-base-icms-manual
            
                   d-base-icms-adic-aux            = ROUND(d-base-icms-adic-aux 
                                                         + decla-import-adic.val-pis-db-cr
                                                         + decla-import-adic.val-pis-outras, 2) WHEN NOT l-base-icms-manual .
        
        IF  param-imp.log-incid-cofins-base-icms THEN
            ASSIGN decla-import-adic.val-base-icms = ROUND(decla-import-adic.val-base-icms 
                                                         + decla-import-adic.val-cofins-db-cr
                                                         + decla-import-adic.val-cofins-outras ,8) WHEN NOT l-base-icms-manual
                   
                   d-base-icms-adic-aux            = ROUND(d-base-icms-adic-aux 
                                                         + decla-import-adic.val-cofins-db-cr
                                                         + decla-import-adic.val-cofins-outras ,2) WHEN NOT l-base-icms-manual.
    END.                                                     
    
    /* fim - calculo da base do icms */

    FOR FIRST item 
        WHERE item.it-codigo = item-mat.it-codigo NO-LOCK: END.
   
    IF NOT CAN-FIND(FIRST tb-wt-docto 
                    WHERE tb-wt-docto.seq-wt-docto = 1) THEN DO:

        CREATE tb-wt-docto.
        ASSIGN tb-wt-docto.seq-wt-docto = 1
               tb-wt-docto.cod-emitente = decla-import-adic.cdn-fornec
               tb-wt-docto.nr-nota      = piItem
               tb-wt-docto.nat-operacao = decla-import-ord.cod-natur-operac WHEN AVAIL decla-import-ord
               tb-wt-docto.cod-des-merc = IF natur-oper.consum-final THEN 2 ELSE 1
               tb-wt-docto.cod-estabel  = decla-import.cod-estab
               tb-wt-docto.dt-emis-nota = TODAY
               tb-wt-docto.esp-docto    = 21
               tb-wt-docto.ind-tip-nota = 8
               tb-wt-docto.mo-codigo    = decla-import-adic.cdn-moeda
               tb-wt-docto.nome-abrev   = emitente.nome-abrev
               tb-wt-docto.vl-embalagem = 0
               tb-wt-docto.vl-frete     = 0
               tb-wt-docto.vl-mercad    = d-valor-merc-liq
               tb-wt-docto.nr-prog      = 176 /* para indicar no bodi317im1br.i1 que a boin176 que chamou */
               tb-wt-docto.vl-seguro    = 0
               tb-wt-docto.cidade       = estabelec.cidade
               tb-wt-docto.estado       = estabelec.estado
               tb-wt-docto.pais         = estabelec.pais.
    END.

        
    IF NOT CAN-FIND(FIRST tb-wt-it-docto 
                    WHERE tb-wt-it-docto.seq-wt-docto = 1
                      AND tb-wt-it-docto.seq-wt-it-docto = i) THEN DO:
        
        CREATE tb-wt-it-docto.
        ASSIGN tb-wt-it-docto.seq-wt-docto        = 1
               tb-wt-it-docto.seq-wt-it-docto     = i
               tb-wt-it-docto.calcula             = YES
               tb-wt-it-docto.it-codigo           = item.it-codigo when avail item
               tb-wt-it-docto.nat-operacao        = decla-import-ord.cod-natur-operac WHEN AVAIL decla-import-ord /*buscar da ordem da adicao */
               tb-wt-it-docto.nr-sequencia        = i
               tb-wt-it-docto.nr-seq-nota         = 1 
               tb-wt-it-docto.quantidade[1]       = decla-import-adic.qtd-ncm                                 
               tb-wt-it-docto.vl-merc-ori         = decla-import-adic.val-base-icms                           
               tb-wt-it-docto.vl-merc-liq         = decla-import-adic.val-base-icms
               tb-wt-it-docto.vl-despes-it        = 0                                                         
               tb-wt-it-docto.vl-frete            = 0                                                         
               tb-wt-it-docto.vl-seguro           = 0                                                         
               tb-wt-it-docto.vl-preori           = decla-import-adic.val-vmcv / tb-wt-it-docto.quantidade[1] 
               tb-wt-it-docto.vl-preuni           = d-valor-merc-liq / tb-wt-it-docto.quantidade[1]           
               tb-wt-it-docto.vl-merc-s-icms      = d-valor-merc-liq                                          
               tb-wt-it-docto.vl-merc-tab         = d-valor-merc-liq                                          
               tb-wt-it-docto.numero-ordem        = decla-import-ord.num-ordem
               tb-wt-it-docto.parcela             = decla-import-ord.num-parcela
               OVERLAY(tb-wt-it-docto.char-1,1,6) = "IM7777":U.                                               
    END.

    IF NOT CAN-FIND(FIRST tb-wt-it-imposto 
                    WHERE tb-wt-it-imposto.seq-wt-docto = 1
                      AND tb-wt-it-imposto.seq-wt-it-docto = i) THEN DO:

        CREATE tb-wt-it-imposto.
        ASSIGN tb-wt-it-imposto.seq-wt-docto    = 1
               tb-wt-it-imposto.seq-wt-it-docto = i
               tb-wt-it-imposto.perc-red-icm    = decla-import-adic.val-perc-reduc-icms /*gravar todas essas informaá‰es da adiá∆o */
               tb-wt-it-imposto.perc-red-ipi    = decla-import-adic.val-perc-reduc-ipi
               tb-wt-it-imposto.perc-red-iss    = 0
               tb-wt-it-imposto.aliquota-ipi    = decla-import-adic.val-aliq-ipi
               tb-wt-it-imposto.aliquota-icm    = decla-import-adic.val-aliq-icms
               tb-wt-it-imposto.aliquota-iss    = 0
               tb-wt-it-imposto.cd-trib-ipi     = decla-import-adic.idi-tributac-ipi
               tb-wt-it-imposto.cd-trib-icm     = decla-import-adic.idi-tributac-icms
               tb-wt-it-imposto.cd-trib-iss     = 0
               tb-wt-it-imposto.ind-icm-ret     = NO. /* marcelo - verificar */
    END.

    IF  VALID-HANDLE(h-bodi317im2bra) THEN DO:
        RUN enviaTbWtDocto     IN  h-bodi317im2bra (INPUT TABLE tb-wt-docto).
        RUN enviaTbWtItDocto   IN  h-bodi317im2bra (INPUT TABLE tb-wt-it-docto).
        RUN enviaTbWtItImposto IN  h-bodi317im2bra (INPUT TABLE tb-wt-it-imposto).
    END.

    RUN localizaWtDocto IN h-bodi317im2bra (INPUT 1, OUTPUT l-procedimento-ok).

    IF NOT l-procedimento-ok THEN 
        RETURN "NOK":U.

    RUN calculaICMS IN h-bodi317im2bra (INPUT 1, OUTPUT l-procedimento-ok) .                                      

    RUN retornaTbWtItImposto IN h-bodi317im2bra (OUTPUT TABLE tb-wt-it-imposto).
    
    FIND FIRST tb-wt-it-imposto
         WHERE tb-wt-it-imposto.seq-wt-docto    = 1
           AND tb-wt-it-imposto.seq-wt-it-docto = tb-wt-it-docto.seq-wt-it-docto EXCLUSIVE-LOCK NO-ERROR.

    /* Atualizar os dados calculados NO tb-wt-it-imposto para a decla-import-adic.  */
    ASSIGN decla-import-adic.val-base-icms = tb-wt-it-imposto.vl-bicms-it WHEN NOT l-base-icms-manual.

    IF  decla-import-adic.idi-tributac-icms = 2 /* Isento */ 
    THEN ASSIGN decla-import-adic.val-base-icms         = tb-wt-it-imposto.vl-icmsnt-it 
                decla-import-adic.val-icms-nao-tributad = 0
                decla-import-adic.val-icms-outras       = 0
                decla-import-adic.val-icms-db-cr        = 0.
    ELSE DO:
        IF  decla-import-adic.idi-tributac-icms = 3 /* Outros */ 
        THEN DO:
            ASSIGN decla-import-adic.val-base-icms = tb-wt-it-imposto.vl-icmsou-it WHEN NOT l-base-icms-manual. /* Quando opá∆o OUTROS, base vem no valor outros da wt-it-imposto */

            &if '{&bf_mat_versao_ems}' >= '2.09' &then
            IF  decla-import-adic.log-suspens-icms 
            &else
            IF  SUBSTRING(decla-import-adic.cod-livre-1,1,1) = '1' 
            &endif
            THEN IF decla-import-adic.val-aliq-icms > 0
                 THEN ASSIGN decla-import-adic.val-icms-nao-tributad = tb-wt-it-imposto.vl-icms-it WHEN NOT l-valor-icms-manual
                             decla-import-adic.val-icms-outras       = 0                         
                             decla-import-adic.val-icms-db-cr        = 0.                        
                 ELSE ASSIGN decla-import-adic.val-icms-nao-tributad = 0
                             decla-import-adic.val-icms-outras       = 0                         
                             decla-import-adic.val-icms-db-cr        = 0.                        
            ELSE IF decla-import-adic.val-aliq-icms > 0
                 THEN ASSIGN decla-import-adic.val-icms-nao-tributad = 0
                             decla-import-adic.val-icms-outras       = tb-wt-it-imposto.vl-icms-it WHEN NOT l-valor-icms-manual                         
                             decla-import-adic.val-icms-db-cr        = 0.                        
                 ELSE ASSIGN decla-import-adic.val-icms-nao-tributad = 0
                             decla-import-adic.val-icms-outras       = 0                         
                             decla-import-adic.val-icms-db-cr        = 0.                        
        END. /* THEN DO: */
        ELSE DO:
            IF  decla-import-adic.idi-tributac-icms = 5 /* Diferido */ 
            THEN DO:
                IF  tb-wt-it-imposto.vl-icms-it > 0 
                THEN ASSIGN decla-import-adic.val-icms-nao-tributad = 0                          
                            decla-import-adic.val-icms-outras       = tb-wt-it-imposto.vl-icms-it WHEN NOT l-valor-icms-manual                         
                            decla-import-adic.val-icms-db-cr        = 0.                         
                ELSE ASSIGN decla-import-adic.val-icms-nao-tributad = 0                          
                            decla-import-adic.val-icms-outras       = 0
                            decla-import-adic.val-icms-db-cr        = 0.                         
            END.
            ELSE DO:
                IF  decla-import-adic.idi-tributac-icms = 4 /* Reduzido */ THEN DO:
                    ASSIGN decla-import-adic.val-icms-nao-tributad = tb-wt-it-imposto.vl-icmsnt-it WHEN NOT l-valor-icms-manual
                           decla-import-adic.val-icms-outras       = tb-wt-it-imposto.vl-icmsou-it WHEN NOT l-valor-icms-manual
                           decla-import-adic.val-icms-db-cr        = tb-wt-it-imposto.vl-icms-it   WHEN NOT l-valor-icms-manual.

                END.
                ELSE DO:
                    IF  decla-import-adic.val-aliq-icms = 0 THEN 
                        ASSIGN decla-import-adic.val-base-icms    = tb-wt-it-imposto.vl-icmsou-it WHEN NOT l-base-icms-manual.
                    ELSE 
                        &if '{&bf_mat_versao_ems}' >= '2.09' &then
                        IF  decla-import-adic.log-suspens-icms THEN DO:
                        &else
                        IF  SUBSTRING(decla-import-adic.cod-livre-1,1,1) = '1' THEN DO:
                        &endif
                            IF  tb-wt-it-imposto.vl-icmsou-it > 0 THEN ASSIGN decla-import-adic.val-icms-nao-tributad = tb-wt-it-imposto.vl-icmsou-it WHEN NOT l-valor-icms-manual
                                                                              decla-import-adic.val-icms-outras       = 0
                                                                              decla-import-adic.val-icms-db-cr        = 0.
                            IF  tb-wt-it-imposto.vl-icms-it   > 0 THEN ASSIGN decla-import-adic.val-icms-nao-tributad = tb-wt-it-imposto.vl-icms-it WHEN NOT l-valor-icms-manual
                                                                              decla-import-adic.val-icms-outras       = 0                         
                                                                              decla-import-adic.val-icms-db-cr        = 0.                        
                            IF  tb-wt-it-imposto.vl-icmsnt-it > 0 THEN ASSIGN decla-import-adic.val-icms-nao-tributad = tb-wt-it-imposto.vl-icmsnt-it WHEN NOT l-valor-icms-manual
                                                                              decla-import-adic.val-icms-outras       = 0
                                                                              decla-import-adic.val-icms-db-cr        = 0.
                        END. /* IF  decla-import-adic.log-suspens-icms-import */
                        ELSE DO:
                            IF  tb-wt-it-imposto.vl-icmsou-it > 0 THEN ASSIGN decla-import-adic.val-icms-nao-tributad = 0
                                                                              decla-import-adic.val-icms-outras       = tb-wt-it-imposto.vl-icmsou-it WHEN NOT l-valor-icms-manual
                                                                              decla-import-adic.val-icms-db-cr        = 0.
    
                            IF  tb-wt-it-imposto.vl-icmsnt-it > 0 THEN ASSIGN decla-import-adic.val-icms-nao-tributad = tb-wt-it-imposto.vl-icmsnt-it WHEN NOT l-valor-icms-manual
                                                                              decla-import-adic.val-icms-outras       = 0
                                                                              decla-import-adic.val-icms-db-cr        = 0.
                            IF  tb-wt-it-imposto.vl-icms-it   > 0 THEN ASSIGN decla-import-adic.val-icms-nao-tributad = 0
                                                                              decla-import-adic.val-icms-outras       = 0
                                                                              decla-import-adic.val-icms-db-cr        = tb-wt-it-imposto.vl-icms-it WHEN NOT l-valor-icms-manual.
    
    
                            
                        END. /* ELSE DO: */
                END. /* ELSE DO: */
            END. /* ELSE DO: */
        END. /* ELSE DO: */
    END. /* ELSE DO: */

    /* 
    ** Acerto de residuos base do ICMS. 
    ** Incialmente realizado acerto APENAS para quando Total da Nota for igual a Base do ICMS. 
    ** Calculo realizado dessa maneira para que seja compativel com NFE, pois na docum-est 
    ** o valor total da nota È calculado apenas com duas casas decimais e seus valores sao somados ja arredondados (mercadoria + despesas). 
    ** boin090.m12 - calculaVlrTotalAux
    */
    IF AVAIL param-imp AND param-imp.inc-icms-tot-nf AND param-imp.log-2 THEN DO:

        IF  (d-base-icms-adic-aux + ROUND(decla-import-adic.val-icms-db-cr,2)) <> decla-import-adic.val-base-icms
        AND (d-base-icms-adic-aux + ROUND(decla-import-adic.val-icms-db-cr,2)) - decla-import-adic.val-base-icms <=  0.01  
        AND (d-base-icms-adic-aux + ROUND(decla-import-adic.val-icms-db-cr,2)) - decla-import-adic.val-base-icms >= -0.01 THEN

            ASSIGN decla-import-adic.val-base-icms = decla-import-adic.val-base-icms 
                                                   + ((d-base-icms-adic-aux + round(decla-import-adic.val-icms-db-cr,2)) - decla-import-adic.val-base-icms) WHEN NOT l-base-icms-manual.

    END.
    ASSIGN d-base-icms-adic-aux = 0.

    /* carrega tt de valores de conferencia dos impostos*/
    ASSIGN tt-verifica-impostos.val-base-icms-sist  = ROUND(tb-wt-it-imposto.vl-bicms-it,8)
           tt-verifica-impostos.val-valor-icms-sist = ROUND(tb-wt-it-imposto.vl-icms-it,8)   WHEN ROUND(tb-wt-it-imposto.vl-icms-it,8)   > 0
           tt-verifica-impostos.val-valor-icms-sist = ROUND(tb-wt-it-imposto.vl-icmsnt-it,8) WHEN ROUND(tb-wt-it-imposto.vl-icmsnt-it,8) > 0
           tt-verifica-impostos.val-valor-icms-sist = ROUND(tb-wt-it-imposto.vl-icmsou-it,8) WHEN ROUND(tb-wt-it-imposto.vl-icmsou-it,8) > 0
           tt-verifica-impostos.val-base-icms-inf   = decla-import-adic.val-base-icms
           tt-verifica-impostos.val-valor-icms-inf  = decla-import-adic.val-icms-db-cr        WHEN decla-import-adic.val-icms-db-cr        > 0
           tt-verifica-impostos.val-valor-icms-inf  = decla-import-adic.val-icms-outras       WHEN decla-import-adic.val-icms-outras       > 0
           tt-verifica-impostos.val-valor-icms-inf  = decla-import-adic.val-icms-nao-tributad WHEN decla-import-adic.val-icms-nao-tributad > 0.
    
    IF VALID-HANDLE(h-bodi317im2bra) THEN 
        DELETE PROCEDURE h-bodi317im2bra.
    ASSIGN h-bodi317im2bra = ?.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculaICMS-CBS-IBS-Item DBOProgram 
PROCEDURE calculaICMS-CBS-IBS-Item :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    {utp/ut-liter.i "Calculando_ICMS" *}
    RUN pi-acompanhar IN h-acomp (INPUT RETURN-VALUE). /* altera a mensagem do acompanhamentos */

    DEF VAR d-valor-merc-liq      LIKE decla-import-adic.val-vmle            NO-UNDO.
    DEF VAR i                     AS INTEGER INITIAL 0                       NO-UNDO.
    DEF VAR piItem                AS CHAR                                    NO-UNDO.
    DEF VAR l-procedimento-ok     AS LOGICAL                                 NO-UNDO.
    DEF VAR de-valor-incide-ipi   AS DECIMAL                                 NO-UNDO.
    DEF VAR p-imp-manual          AS LOGICAL                                 NO-UNDO.

    IF NOT VALID-HANDLE(h-bodi317im2bra) THEN
        RUN dibo/bodi317im2bra PERSISTEN SET h-bodi317im2bra.

    /*Configurador de Tributos*/
    IF NOT VALID-HANDLE(h-bodi613calc2) THEN
        RUN dibo/bodi613calc2.p PERSISTENT SET h-bodi613calc2.

    RUN limpaTbWt. /* limpar as temp-tables tb-wt-docto, tb-wt-it-docto, tb-wt-it-imposto e tb-ct-trib-wt-item-docto */
    
    ASSIGN i          = i + 1
           i-seq-item = i-seq-item + 1.

    IF decla-import-adic-itens.num-livre-1 = 0 THEN
        ASSIGN decla-import-adic-itens.num-livre-1 = i-seq-item. 

    FOR FIRST decla-import-ord NO-LOCK
        WHERE decla-import-ord.num-di-ems  = decla-import-adic-itens.num-di-ems
        AND   decla-import-ord.num-adic    = decla-import-adic-itens.num-adic
        AND   decla-import-ord.num-ordem   = decla-import-adic-itens.num-ordem
        AND   decla-import-ord.num-parcela = decla-import-adic-itens.num-parcela
        AND   decla-import-ord.cdd-siscomex-dts = decla-import-adic-itens.cdd-siscomex-dts:

        FIND FIRST natur-oper NO-LOCK
             WHERE natur-oper.nat-operacao = decla-import-ord.cod-natur-operac NO-ERROR.
    END.

    FIND FIRST emitente NO-LOCK
         WHERE emitente.cod-emitente = decla-import-adic.cdn-fornec NO-ERROR.

    ASSIGN piItem                = string(decla-import.num-di-ems) + "/" + STRING(decla-import.cdd-siscomex-dts) + "/" + string(decla-import-adic.num-adic).

    /* calculo da base do icms */
    /* II incide na base de icms */
    FIND FIRST desp-imp NO-LOCK
        WHERE desp-imp.cod-desp = i-cod-desp-ii no-error.
    IF AVAIL desp-imp AND
           desp-imp.inc-base-icms THEN DO:
        ASSIGN decla-import-adic-itens.val-base-icms = ROUND(decla-import-adic-itens.val-base-icms 
                                                           + decla-import-adic-itens.val-ii-db-cr
                                                           + decla-import-adic-itens.val-ii-outras,8) WHEN NOT l-base-icms-manual
               
               d-base-icms-itens-aux                 = ROUND(d-base-icms-itens-aux 
                                                           + decla-import-adic-itens.val-ii-db-cr
                                                           + decla-import-adic-itens.val-ii-outras,2) WHEN NOT l-base-icms-manual.
                                                                                                          
    END.
    
    /* IPI incide na base do icms - natur-oper */
    IF substring(natur-oper.char-2,1,5) = "1    " THEN DO:
        ASSIGN decla-import-adic-itens.val-base-icms = round(decla-import-adic-itens.val-base-icms 
                                                           + decla-import-adic-itens.val-ipi-db-cr
                                                           + decla-import-adic-itens.val-ipi-outras,8) WHEN NOT l-base-icms-manual
               
               d-base-icms-itens-aux                 = round(d-base-icms-itens-aux 
                                                           + decla-import-adic-itens.val-ipi-db-cr
                                                           + decla-import-adic-itens.val-ipi-outras,2) WHEN NOT l-base-icms-manual .
    END.
    
    /* pis e cofins incidem na base do icms -> item-mat - cd2510 */
    FIND FIRST param-imp WHERE param-imp.cod-estabel = decla-import.cod-estab NO-LOCK NO-ERROR.
    FOR FIRST item-mat NO-LOCK
        WHERE item-mat.it-codigo = decla-import-ord.cod-item:
        
        IF param-imp.log-incid-pis-base-icms THEN /* pis incide em icms */
            ASSIGN decla-import-adic-itens.val-base-icms = round(decla-import-adic-itens.val-base-icms 
                                                               + decla-import-adic-itens.val-pis-db-cr
                                                               + decla-import-adic-itens.val-pis-outras,8) WHEN NOT l-base-icms-manual

                   d-base-icms-itens-aux                 = round(d-base-icms-itens-aux 
                                                               + decla-import-adic-itens.val-pis-db-cr
                                                               + decla-import-adic-itens.val-pis-outras,2) WHEN NOT l-base-icms-manual.
        
        IF  param-imp.log-incid-cofins-base-icms THEN
            ASSIGN decla-import-adic-itens.val-base-icms = round(decla-import-adic-itens.val-base-icms 
                                                               + decla-import-adic-itens.val-cofins-db-cr
                                                               + decla-import-adic-itens.val-cofins-outras,8) WHEN NOT l-base-icms-manual

                   d-base-icms-itens-aux                 = round(d-base-icms-itens-aux
                                                               + decla-import-adic-itens.val-cofins-db-cr
                                                               + decla-import-adic-itens.val-cofins-outras,2) WHEN NOT l-base-icms-manual.
    END.

    FOR FIRST item NO-LOCK
          WHERE item.it-codigo = item-mat.it-codigo: END.
   
    IF NOT CAN-FIND(FIRST tb-wt-docto 
                    WHERE tb-wt-docto.seq-wt-docto = 1) THEN DO:

        CREATE tb-wt-docto.
        ASSIGN tb-wt-docto.seq-wt-docto = 1
               tb-wt-docto.cod-emitente = decla-import-adic.cdn-fornec
               tb-wt-docto.nr-nota      = decla-import-ord.cod-embarq
               tb-wt-docto.serie        = "":U
               tb-wt-docto.nat-operacao = decla-import-ord.cod-natur-operac WHEN AVAIL decla-import-ord
               tb-wt-docto.cod-des-merc = IF natur-oper.consum-final THEN 2 ELSE 1
               tb-wt-docto.cod-estabel  = decla-import.cod-estab
               tb-wt-docto.dt-emis-nota = TODAY
               tb-wt-docto.esp-docto    = 21
               tb-wt-docto.ind-tip-nota = 8
               tb-wt-docto.mo-codigo    = decla-import-adic.cdn-moeda
               tb-wt-docto.nome-abrev   = emitente.nome-abrev
               tb-wt-docto.vl-embalagem = 0
               tb-wt-docto.vl-frete     = 0
               tb-wt-docto.vl-mercad    = d-valor-merc-liq
               tb-wt-docto.nr-prog      = 176 /* para indicar no bodi317im1br.i1 que a boin176 que chamou */
               tb-wt-docto.vl-seguro    = 0
               tb-wt-docto.cidade       = estabelec.cidade
               tb-wt-docto.estado       = estabelec.estado
               tb-wt-docto.pais         = estabelec.pais
               c-embarque               = decla-import-ord.cod-embarq.
    END.
        
    IF NOT CAN-FIND(FIRST tb-wt-it-docto 
                    WHERE tb-wt-it-docto.seq-wt-docto    = 1
                      AND tb-wt-it-docto.seq-wt-it-docto = i-seq-item) THEN DO:
        
        CREATE tb-wt-it-docto.
        ASSIGN tb-wt-it-docto.seq-wt-docto        = 1
               tb-wt-it-docto.seq-wt-it-docto     = i-seq-item
               tb-wt-it-docto.calcula             = YES
               tb-wt-it-docto.it-codigo           = item.it-codigo when avail item
               tb-wt-it-docto.nat-operacao        = decla-import-ord.cod-natur-operac WHEN AVAIL decla-import-ord
               tb-wt-it-docto.nr-sequencia        = i-seq-item
               tb-wt-it-docto.nr-seq-nota         = 1
               tb-wt-it-docto.quantidade[1]       = decla-import-adic-itens.qtd-adic[1]                       /* quantidade na unidade do item */
               tb-wt-it-docto.vl-merc-ori         = decla-import-adic-itens.val-base-icms WHEN NOT l-base-icms-manual /* preco total da adicao */
               tb-wt-it-docto.vl-merc-liq         = decla-import-adic-itens.val-base-icms WHEN NOT l-base-icms-manual /* preco liquido da adicao */
               tb-wt-it-docto.vl-despes-it        = 0                                                         /* valor acrescimos da adicao */
               tb-wt-it-docto.vl-frete            = 0                                                         /* valor frete da adicao */
               tb-wt-it-docto.vl-seguro           = 0                                                         /* valor seguro da adicao */
               tb-wt-it-docto.vl-preori           = decla-import-adic-itens.val-vmcv / tb-wt-it-docto.quantidade[1] /* valor mercadoria / tb-wt-it-docto.quantidade[1] */
               tb-wt-it-docto.vl-preuni           = d-valor-merc-liq / tb-wt-it-docto.quantidade[1]           /* valor liquido da mercadoria / tb-wt-it-docto.quantidade[1] */
               tb-wt-it-docto.vl-merc-s-icms      = d-valor-merc-liq                                          /* valor liquido da mercadoria */
               tb-wt-it-docto.vl-merc-tab         = d-valor-merc-liq                                          /* valor liquido mercadoria */
               tb-wt-it-docto.numero-ordem        = decla-import-adic-itens.num-ordem
               tb-wt-it-docto.parcela             = decla-import-adic-itens.num-parcela
               OVERLAY(tb-wt-it-docto.char-1,1,6) = "IM7777":U.                                               /*integracao com o modulo de importaá∆o*/
    END.

    IF NOT CAN-FIND(FIRST tb-wt-it-imposto 
                        WHERE tb-wt-it-imposto.seq-wt-docto = 1
                        AND   tb-wt-it-imposto.seq-wt-it-docto = i-seq-item) THEN DO:
        CREATE tb-wt-it-imposto.
        ASSIGN tb-wt-it-imposto.seq-wt-docto    = 1
               tb-wt-it-imposto.seq-wt-it-docto = i-seq-item
               tb-wt-it-imposto.perc-red-icm    = decla-import-adic.val-perc-reduc-icms /*gravar todas essas informaá‰es da adiá∆o */
               tb-wt-it-imposto.perc-red-ipi    = decla-import-adic.val-perc-reduc-ipi
               tb-wt-it-imposto.perc-red-iss    = 0
               tb-wt-it-imposto.aliquota-ipi    = decla-import-adic.val-aliq-ipi
               tb-wt-it-imposto.aliquota-icm    = decla-import-adic.val-aliq-icms
               tb-wt-it-imposto.aliquota-iss    = 0
               tb-wt-it-imposto.cd-trib-ipi     = decla-import-adic.idi-tributac-ipi
               tb-wt-it-imposto.cd-trib-icm     = decla-import-adic.idi-tributac-icms
               tb-wt-it-imposto.cd-trib-iss     = 0
               tb-wt-it-imposto.ind-icm-ret     = NO.
    END.

    IF  VALID-HANDLE(h-bodi317im2bra) THEN DO:
        RUN enviaTbWtDocto     IN  h-bodi317im2bra (INPUT TABLE tb-wt-docto).
        RUN enviaTbWtItDocto   IN  h-bodi317im2bra (INPUT TABLE tb-wt-it-docto).
        RUN enviaTbWtItImposto IN  h-bodi317im2bra (INPUT TABLE tb-wt-it-imposto).
    END.

    RUN localizaWtDocto IN h-bodi317im2bra (INPUT 1, OUTPUT l-procedimento-ok).
    IF  NOT l-procedimento-ok THEN 
        RETURN "NOK":U.

    RUN calculaICMS IN h-bodi317im2bra (INPUT 1, OUTPUT l-procedimento-ok) .                                      

    RUN retornaTbWtItImposto IN h-bodi317im2bra (OUTPUT TABLE tb-wt-it-imposto).

    FIND FIRST tb-wt-it-imposto
         WHERE tb-wt-it-imposto.seq-wt-docto    = 1
           AND tb-wt-it-imposto.seq-wt-it-docto = tb-wt-it-docto.seq-wt-it-docto EXCLUSIVE-LOCK NO-ERROR.

    /* Atualizar os dados calculados NO tb-wt-it-imposto para a decla-import-adic.  */
    ASSIGN decla-import-adic-itens.val-base-icms = tb-wt-it-imposto.vl-bicms-it WHEN NOT l-base-icms-manual
           d-base-icms-itens                     = d-base-icms-itens  + decla-import-adic-itens.val-base-icms.

    IF decla-import-adic.idi-tributac-icms = 2 THEN DO: /* Isento */

        ASSIGN decla-import-adic-itens.val-base-icms         = tb-wt-it-imposto.vl-icmsnt-it
               d-base-icms-itens                             = d-base-icms-itens  + decla-import-adic-itens.val-base-icms
               decla-import-adic-itens.val-icms-nao-tributad = 0
               decla-import-adic-itens.val-icms-outras       = 0
               decla-import-adic-itens.val-icms-db-cr        = 0.
    END.
    ELSE DO:
        IF  decla-import-adic.idi-tributac-icms = 3 /* Outros */ 
        THEN DO:
            ASSIGN decla-import-adic-itens.val-base-icms = tb-wt-it-imposto.vl-icmsou-it WHEN NOT l-base-icms-manual /* Quando opá∆o OUTROS, base vem no valor outros da wt-it-imposto */
                   d-base-icms-itens                     = d-base-icms-itens  + decla-import-adic-itens.val-base-icms.

            &if '{&bf_mat_versao_ems}' >= '2.09' &then
            IF  decla-import-adic.log-suspens-icms 
            &else
            IF  SUBSTRING(decla-import-adic.cod-livre-1,1,1) = '1' 
            &endif
            THEN IF decla-import-adic.val-aliq-icms > 0
                 THEN ASSIGN decla-import-adic-itens.val-icms-nao-tributad = tb-wt-it-imposto.vl-icms-it WHEN NOT l-valor-icms-manual
                             d-valor-icms-itens                            = d-valor-icms-itens + tb-wt-it-imposto.vl-icms-it
                             decla-import-adic-itens.val-icms-outras       = 0                         
                             decla-import-adic-itens.val-icms-db-cr        = 0.                        
                 ELSE ASSIGN decla-import-adic-itens.val-icms-nao-tributad = 0
                             decla-import-adic-itens.val-icms-outras       = 0                         
                             decla-import-adic-itens.val-icms-db-cr        = 0.                        
            ELSE IF decla-import-adic.val-aliq-icms > 0
                 THEN ASSIGN decla-import-adic-itens.val-icms-nao-tributad = 0
                             decla-import-adic-itens.val-icms-outras       = tb-wt-it-imposto.vl-icms-it WHEN NOT l-valor-icms-manual  
                             d-valor-icms-itens                            = d-valor-icms-itens + tb-wt-it-imposto.vl-icms-it
                             decla-import-adic-itens.val-icms-db-cr        = 0.                        
                 ELSE ASSIGN decla-import-adic-itens.val-icms-nao-tributad = 0
                             decla-import-adic-itens.val-icms-outras       = 0                         
                             decla-import-adic-itens.val-icms-db-cr        = 0.                        
        END. /* THEN DO: */
        ELSE DO:
            IF  decla-import-adic.idi-tributac-icms = 5 /* Diferido */ 
            THEN DO:
                IF  tb-wt-it-imposto.vl-icms-it > 0 
                THEN ASSIGN decla-import-adic-itens.val-icms-nao-tributad = 0                          
                            decla-import-adic-itens.val-icms-outras       = tb-wt-it-imposto.vl-icms-it WHEN NOT l-valor-icms-manual  
                            d-valor-icms-itens                            = d-valor-icms-itens + tb-wt-it-imposto.vl-icms-it
                            decla-import-adic-itens.val-icms-db-cr        = 0.                         
                ELSE ASSIGN decla-import-adic-itens.val-icms-nao-tributad = 0                          
                            decla-import-adic-itens.val-icms-outras       = 0
                            decla-import-adic-itens.val-icms-db-cr        = 0.                         
            END.
            ELSE DO:                
                IF  decla-import-adic.val-aliq-icms = 0 
                THEN ASSIGN decla-import-adic-itens.val-base-icms = tb-wt-it-imposto.vl-icmsou-it.
                ELSE DO: 
                    IF  decla-import-adic.idi-tributac-icms = 4 THEN DO: /* Reduzido */ 
                        ASSIGN decla-import-adic-itens.val-icms-nao-tributad = tb-wt-it-imposto.vl-icmsnt-it WHEN NOT l-valor-icms-manual
                               decla-import-adic-itens.val-icms-outras       = tb-wt-it-imposto.vl-icmsou-it WHEN NOT l-valor-icms-manual
                               decla-import-adic-itens.val-icms-db-cr        = tb-wt-it-imposto.vl-icms-it   WHEN NOT l-valor-icms-manual
                               d-valor-icms-itens                            = d-valor-icms-itens + (tb-wt-it-imposto.vl-icmsnt-it
                                                                                                  +  tb-wt-it-imposto.vl-icmsou-it 
                                                                                                  +  tb-wt-it-imposto.vl-icms-it). 
                    END.
                    ELSE DO:
                        &if '{&bf_mat_versao_ems}' >= '2.09' &then
                        IF  decla-import-adic.log-suspens-icms THEN DO:
                        &else
                        IF  SUBSTRING(decla-import-adic.cod-livre-1,1,1) = '1' THEN DO:
                        &endif
                            IF  tb-wt-it-imposto.vl-icmsou-it > 0 THEN ASSIGN decla-import-adic-itens.val-icms-nao-tributad = tb-wt-it-imposto.vl-icmsou-it WHEN NOT l-valor-icms-manual
                                                                              d-valor-icms-itens                            = d-valor-icms-itens + tb-wt-it-imposto.vl-icmsou-it
                                                                              decla-import-adic-itens.val-icms-outras       = 0
                                                                              decla-import-adic-itens.val-icms-db-cr        = 0.
                            IF  tb-wt-it-imposto.vl-icms-it   > 0 THEN ASSIGN decla-import-adic-itens.val-icms-nao-tributad = tb-wt-it-imposto.vl-icms-it WHEN NOT l-valor-icms-manual
                                                                              d-valor-icms-itens                            = d-valor-icms-itens + tb-wt-it-imposto.vl-icms-it
                                                                              decla-import-adic-itens.val-icms-outras       = 0                         
                                                                              decla-import-adic-itens.val-icms-db-cr        = 0.                        
                            IF  tb-wt-it-imposto.vl-icmsnt-it > 0 THEN ASSIGN decla-import-adic-itens.val-icms-nao-tributad = tb-wt-it-imposto.vl-icmsnt-it WHEN NOT l-valor-icms-manual
                                                                              d-valor-icms-itens                            = d-valor-icms-itens + tb-wt-it-imposto.vl-icmsnt-it
                                                                              decla-import-adic-itens.val-icms-outras       = 0
                                                                              decla-import-adic-itens.val-icms-db-cr        = 0.
                        END. /* IF  decla-import-adic.log-suspens-icms-import */
                        ELSE DO:
                            IF  tb-wt-it-imposto.vl-icmsou-it > 0 THEN ASSIGN decla-import-adic-itens.val-icms-nao-tributad = 0
                                                                              decla-import-adic-itens.val-icms-outras       = tb-wt-it-imposto.vl-icmsou-it WHEN NOT l-valor-icms-manual
                                                                              d-valor-icms-itens                            = d-valor-icms-itens + tb-wt-it-imposto.vl-icmsou-it
                                                                              decla-import-adic-itens.val-icms-db-cr        = 0.
                            
                            IF  tb-wt-it-imposto.vl-icmsnt-it > 0 THEN ASSIGN decla-import-adic-itens.val-icms-nao-tributad = tb-wt-it-imposto.vl-icmsnt-it WHEN NOT l-valor-icms-manual
                                                                              d-valor-icms-itens                            = d-valor-icms-itens + tb-wt-it-imposto.vl-icmsnt-it
                                                                              decla-import-adic-itens.val-icms-outras       = 0
                                                                              decla-import-adic-itens.val-icms-db-cr        = 0.
                            IF  tb-wt-it-imposto.vl-icms-it   > 0 THEN ASSIGN decla-import-adic-itens.val-icms-nao-tributad = 0
                                                                              decla-import-adic-itens.val-icms-outras       = 0
                                                                              decla-import-adic-itens.val-icms-db-cr        = tb-wt-it-imposto.vl-icms-it WHEN NOT l-valor-icms-manual
                                                                              d-valor-icms-itens                            = d-valor-icms-itens + tb-wt-it-imposto.vl-icms-it.
                        END.
                    END.
                END. 
            END.
        END.
    END.


    /*Atualiza as informaá‰es na tb-wt-it-docto para c†lculo correto das informaá‰es do configurador de tributos*/
    ASSIGN tb-wt-it-docto.vl-merc-ori   = decla-import-adic-itens.val-vmcv
           tb-wt-it-docto.vl-merc-liq   = decla-import-adic-itens.val-vmcv
           tb-wt-it-imposto.vl-bicms-it = decla-import-adic-itens.val-base-icms WHEN l-base-icms-manual.

    /* N∆o executa para nota complementar*/
    IF NOT natur-oper.nota-rateio THEN DO:

        /******** Configurador de Tributos para ICMS e FCP ****************************/
        run enviaTbWtDocto          in h-bodi613calc2 (input table tb-wt-docto).            
        run enviaTbWtItDocto        in h-bodi613calc2 (input table tb-wt-it-docto).            
        run enviaTbWtItImposto      in h-bodi613calc2 (input table tb-wt-it-imposto).
    
        IF l-nt2024002 THEN DO:
            RUN createTempTableImpostosCBSIBS.
            RUN piEnviaNumDIEMS          IN h-bodi613calc2 (INPUT decla-import-adic-itens.num-di-ems,
                                                            INPUT decla-import-adic-itens.num-adic,
                                                            INPUT decla-import-adic-itens.num-seq,
                                                            INPUT decla-import-adic-itens.cdd-siscomex-dts).
            RUN enviaTbWtItImpostoCBSIBS IN h-bodi613calc2 (INPUT TABLE tb-wt-it-impostoCBSIBS).
        END.
        
        RUN localizaWtDocto in h-bodi613calc2 ( input 1,
                                                output l-procedimento-ok ).
    
        if  not l-procedimento-ok then do:
            delete procedure h-bodi613calc2.
            RETURN "NOK":U.
        end.
    
        RUN pi-recebe-handle in h-bodi317im2bra (input "h-bodi613calc2":U,
                                                 input h-bodi613calc2).
          
        RUN trataConfigTributos in h-bodi317im2bra.

        /* retornar temp-table */       
        
        run retornaTbCtTribWtItemDocto in h-bodi613calc2 ( output table tb-ct-trib-wt-item-docto ).
        run retornaTbWtItImposto       in h-bodi613calc2 ( output table tb-wt-it-imposto ). 

    END.

    IF CAN-FIND(FIRST tb-ct-trib-wt-item-docto
                WHERE tb-ct-trib-wt-item-docto.num-seq-wt-docto = tb-wt-it-docto.seq-wt-docto) THEN
        ASSIGN d-valor-icms-itens = 0
               d-base-icms-itens  = 0.
    ELSE
        ASSIGN decla-import-adic-itens.val-base-fcp           = 0
               decla-import-adic-itens.val-aliq-fcp           = 0
               decla-import-adic-itens.val-fcp                = 0
               decla-import-adic-itens.val-base-fcp-substto   = 0
               decla-import-adic-itens.val-aliq-fcp-substto   = 0
               decla-import-adic-itens.val-fcp-substto        = 0
               decla-import-adic-itens.val-perc-icms-diferim  = 0
               decla-import-adic-itens.val-diferim-icms-item  = 0
               decla-import-adic-itens.val-icms-compltar      = 0
               decla-import-adic-itens.val-base-icms-compltar = 0
               decla-import-adic-itens.val-base-icms-substto  = 0
               decla-import-adic-itens.val-icms-substto       = 0
               d-valor-icms-itens-ct-trib                     = 0
               d-base-icms-itens-ct-trib                      = 0.
    
    ASSIGN d-valor-cbs-itens-ct-trib       = 0
           d-base-cbs-itens-ct-trib        = 0
           d-outros-cbs-itens-ct-trib      = 0
           d-valor-ibs-itens-ct-trib       = 0
           d-base-ibs-itens-ct-trib        = 0
           d-outros-ibs-itens-ct-trib      = 0
           d-base-ibsreg-itens-ct-trib     = 0
           d-valor-ibsreg-itens-ct-trib    = 0
           d-base-cbsreg-itens-ct-trib     = 0
           d-valor-cbsreg-itens-ct-trib    = 0
           d-valor-ibsmun-itens-ct-trib    = 0
           d-base-ibsmun-itens-ct-trib     = 0
           d-outros-ibsmun-itens-ct-trib   = 0
           d-base-ibsmunreg-itens-ct-trib  = 0
           d-valor-ibsmunreg-itens-ct-trib = 0
           d-valor-is-itens-ct-trib        = 0
           d-base-is-itens-ct-trib         = 0
           d-outros-is-itens-ct-trib       = 0.

    FOR EACH tb-wt-it-imposto NO-LOCK
       WHERE tb-wt-it-imposto.seq-wt-docto    = 1
         AND tb-wt-it-imposto.seq-wt-it-docto = tb-wt-it-imposto.seq-wt-it-docto,
    
        EACH tb-ct-trib-wt-item-docto NO-LOCK
       WHERE tb-ct-trib-wt-item-docto.num-seq-wt-docto      = tb-wt-it-imposto.seq-wt-docto
         AND tb-ct-trib-wt-item-docto.num-seq-wt-item-docto = tb-wt-it-imposto.seq-wt-it-docto:
    
        FIND FIRST tb-wt-it-docto NO-LOCK
             WHERE tb-wt-it-docto.seq-wt-docto = tb-wt-it-imposto.seq-wt-docto NO-ERROR.
    
        CASE tb-ct-trib-wt-item-docto.cod-tip-trib:
            WHEN "FCP":U THEN DO:
                ASSIGN decla-import-adic-itens.val-base-fcp = tb-ct-trib-wt-item-docto.val-base-calc WHEN natur-oper.tipo-compra <> 3  /*Base FCP*/
                       decla-import-adic-itens.val-aliq-fcp = tb-ct-trib-wt-item-docto.val-aliq      WHEN natur-oper.tipo-compra <> 3  /*Aliq FCP*/
                       decla-import-adic-itens.val-fcp      = tb-ct-trib-wt-item-docto.val-trib      WHEN natur-oper.tipo-compra <> 3. /*Valor FCP*/
    
                /*Zera a aliquota quando nío tiver valor de FCP*/
                IF decla-import-adic-itens.val-fcp = 0 THEN
                    ASSIGN decla-import-adic-itens.val-aliq-fcp = 0.
            END.
    
            WHEN "FCP ST":U THEN DO:
                ASSIGN decla-import-adic-itens.val-base-fcp-substto = tb-ct-trib-wt-item-docto.val-base-calc WHEN natur-oper.tipo-compra <> 3  /*Base FCP ST*/
                       decla-import-adic-itens.val-aliq-fcp-substto = tb-ct-trib-wt-item-docto.val-aliq      WHEN natur-oper.tipo-compra <> 3  /*Aliq FCP ST*/
                       decla-import-adic-itens.val-fcp-substto      = tb-ct-trib-wt-item-docto.val-trib      WHEN natur-oper.tipo-compra <> 3. /*Valor FCP ST*/
                       
                /*Zera a aliquota quando nío tiver valor de FCP ST*/
                IF decla-import-adic-itens.val-fcp-substto = 0 THEN
                    ASSIGN decla-import-adic-itens.val-aliq-fcp-substto = 0.
            END.
    
            WHEN "ICMS":U THEN DO:

                IF decla-import-adic-itens.idi-tributac-icms  <> 5 THEN  /*Busca tributacao da formula se for diferente de "Diferido" - mesma regra recebimento boin176.m97*/
                   ASSIGN decla-import-adic-itens.idi-tributac-icms = tb-wt-it-imposto.cd-trib-icm.

                ASSIGN decla-import-adic-itens.val-aliq-icms          = tb-wt-it-imposto.aliquota-icm 
                       decla-import-adic-itens.val-base-icms          = tb-wt-it-imposto.vl-bicms-it
                       decla-import-adic-itens.val-perc-icms-diferim  = tb-wt-it-imposto.val-perc-icms-diferim
                       decla-import-adic-itens.val-diferim-icms-item  = tb-wt-it-imposto.val-diferim-icms-item
                       d-valor-icms-itens-ct-trib                     = d-valor-icms-itens-ct-trib + tb-wt-it-imposto.vl-icms-it
                       d-base-icms-itens-ct-trib                      = d-base-icms-itens-ct-trib  + tb-wt-it-imposto.vl-bicms-it.

                IF  decla-import-adic.idi-tributac-icms = 2 /* Isento */ THEN 
                    ASSIGN decla-import-adic-itens.val-icms-nao-tributad = 0
                           decla-import-adic-itens.val-icms-outras       = 0
                           decla-import-adic-itens.val-icms-db-cr        = 0.
                ELSE DO:
                    IF  decla-import-adic.idi-tributac-icms = 3 /* Outros */ THEN DO:
                        ASSIGN decla-import-adic-itens.val-base-icms = tb-wt-it-imposto.vl-icmsou-it WHEN NOT l-base-icms-manual. /* Quando opá∆o OUTROS, base vem no valor outros da wt-it-imposto */
            
                        &if '{&bf_mat_versao_ems}' >= '2.09' &then
                        IF  decla-import-adic.log-suspens-icms 
                        &else
                        IF  SUBSTRING(decla-import-adic.cod-livre-1,1,1) = '1' 
                        &ENDIF THEN IF decla-import-adic.val-aliq-icms > 0
                             THEN ASSIGN decla-import-adic-itens.val-icms-nao-tributad = tb-wt-it-imposto.vl-icms-it
                                         decla-import-adic-itens.val-icms-outras       = 0                         
                                         decla-import-adic-itens.val-icms-db-cr        = 0.                        
                             ELSE ASSIGN decla-import-adic-itens.val-icms-nao-tributad = 0
                                         decla-import-adic-itens.val-icms-outras       = 0                         
                                         decla-import-adic-itens.val-icms-db-cr        = 0.                        
                        ELSE IF decla-import-adic.val-aliq-icms > 0
                             THEN ASSIGN decla-import-adic-itens.val-icms-nao-tributad = 0
                                         decla-import-adic-itens.val-icms-outras       = tb-wt-it-imposto.vl-icms-it
                                         decla-import-adic-itens.val-icms-db-cr        = 0.                        
                             ELSE ASSIGN decla-import-adic-itens.val-icms-nao-tributad = 0
                                         decla-import-adic-itens.val-icms-outras       = 0                         
                                         decla-import-adic-itens.val-icms-db-cr        = 0.                        
                    END. /* THEN DO: */
                    ELSE DO:
                        IF  decla-import-adic.idi-tributac-icms = 5 /* Diferido */ THEN DO:
                            IF  tb-wt-it-imposto.vl-icms-it > 0 THEN 
                                ASSIGN decla-import-adic-itens.val-icms-nao-tributad = 0                          
                                       decla-import-adic-itens.val-icms-outras       = tb-wt-it-imposto.vl-icms-it
                                       decla-import-adic-itens.val-icms-db-cr        = 0.                         
                            ELSE 
                                ASSIGN decla-import-adic-itens.val-icms-nao-tributad = 0                          
                                       decla-import-adic-itens.val-icms-outras       = 0
                                       decla-import-adic-itens.val-icms-db-cr        = 0.                         
                        END.
                        ELSE DO:
                            IF  decla-import-adic.idi-tributac-icms = 4 THEN DO: /* Reduzido */     
                                ASSIGN decla-import-adic-itens.val-icms-nao-tributad = tb-wt-it-imposto.vl-icmsnt-it 
                                       decla-import-adic-itens.val-icms-outras       = tb-wt-it-imposto.vl-icmsou-it 
                                       decla-import-adic-itens.val-icms-db-cr        = tb-wt-it-imposto.vl-icms-it.
                            END.
                            ELSE DO:
                                IF  decla-import-adic.val-aliq-icms = 0 THEN 
                                    ASSIGN decla-import-adic-itens.val-base-icms = tb-wt-it-imposto.vl-icmsou-it WHEN NOT l-base-icms-manual.
                                ELSE DO:
                                    &if '{&bf_mat_versao_ems}' >= '2.09' &then
                                    IF  decla-import-adic.log-suspens-icms THEN DO:
                                    &else
                                    IF  SUBSTRING(decla-import-adic.cod-livre-1,1,1) = '1' THEN DO:
                                    &endif
                                        IF  tb-wt-it-imposto.vl-icmsou-it > 0 THEN ASSIGN decla-import-adic-itens.val-icms-nao-tributad = tb-wt-it-imposto.vl-icmsou-it
                                                                                          decla-import-adic-itens.val-icms-outras       = 0
                                                                                          decla-import-adic-itens.val-icms-db-cr        = 0.
                                        IF  tb-wt-it-imposto.vl-icms-it   > 0 THEN ASSIGN decla-import-adic-itens.val-icms-nao-tributad = tb-wt-it-imposto.vl-icms-it
                                                                                          decla-import-adic-itens.val-icms-outras       = 0                         
                                                                                          decla-import-adic-itens.val-icms-db-cr        = 0.                        
                                        IF  tb-wt-it-imposto.vl-icmsnt-it > 0 THEN ASSIGN decla-import-adic-itens.val-icms-nao-tributad = tb-wt-it-imposto.vl-icmsnt-it
                                                                                          decla-import-adic-itens.val-icms-outras       = 0
                                                                                          decla-import-adic-itens.val-icms-db-cr        = 0.
                                    END. /* IF  decla-import-adic.log-suspens-icms-import */
                                    ELSE DO:
                                        IF  tb-wt-it-imposto.vl-icmsou-it > 0 THEN ASSIGN decla-import-adic-itens.val-icms-nao-tributad = 0
                                                                                          decla-import-adic-itens.val-icms-outras       = tb-wt-it-imposto.vl-icmsou-it
                                                                                          decla-import-adic-itens.val-icms-db-cr        = 0.
                                        
                                        IF  tb-wt-it-imposto.vl-icmsnt-it > 0 THEN ASSIGN decla-import-adic-itens.val-icms-nao-tributad = tb-wt-it-imposto.vl-icmsnt-it
                                                                                          decla-import-adic-itens.val-icms-outras       = 0
                                                                                          decla-import-adic-itens.val-icms-db-cr        = 0.
                                        IF  tb-wt-it-imposto.vl-icms-it   > 0 THEN ASSIGN decla-import-adic-itens.val-icms-nao-tributad = 0
                                                                                          decla-import-adic-itens.val-icms-outras       = 0
                                                                                          decla-import-adic-itens.val-icms-db-cr        = tb-wt-it-imposto.vl-icms-it.
                                    END.
                                END.
                            END.
                        END.
                    END.
                END.
            END.
            

            WHEN "ICMS COMP":U THEN 
                ASSIGN decla-import-adic-itens.val-icms-compltar      = tb-wt-it-imposto.icm-complem
                       decla-import-adic-itens.val-base-icms-compltar = DEC(SUBSTRING(tb-wt-it-imposto.char-1,296,20)). /*base icms complementar*/
    
            WHEN "ICMS ST":U THEN 
                ASSIGN decla-import-adic-itens.val-base-icms-substto = tb-wt-it-imposto.vl-bsubs-it  WHEN tb-wt-it-docto.nro-comp = " ":U OR natur-oper.tipo-compra <> 3 /* Devol Cli */
                       decla-import-adic-itens.val-icms-substto      = tb-wt-it-imposto.vl-icmsub-it WHEN tb-wt-it-docto.nro-comp = " ":U OR natur-oper.tipo-compra <> 3. /* Devol Cli */
    
        END CASE.

        IF l-nt2024002 THEN DO:
            CASE tb-ct-trib-wt-item-docto.cod-tip-trib:
                WHEN "CBS":U THEN DO:
                    RUN criaTTdeclaItemTribut (INPUT tb-ct-trib-wt-item-docto.cod-tip-trib,
                                               INPUT "COD-TRIB",
                                               INPUT STRING(tb-ct-trib-wt-item-docto.idi-cod-tributac)).

                    RUN criaTTdeclaItemTribut (INPUT tb-ct-trib-wt-item-docto.cod-tip-trib,
                                               INPUT "ALIQUOTA",
                                               INPUT STRING(tb-ct-trib-wt-item-docto.val-aliq)). 
                    RUN criaTTdeclaAdicTribut (INPUT tb-ct-trib-wt-item-docto.cod-tip-trib,
                                               INPUT "ALIQUOTA",
                                               INPUT STRING(tb-ct-trib-wt-item-docto.val-aliq)).
                    RUN pi-GeraDeclaImportOrdTrib (INPUT tb-ct-trib-wt-item-docto.cod-tip-trib,
                                                   INPUT "ALIQUOTA",
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-aliq)).
                                               
                    RUN criaTTdeclaItemTribut (INPUT tb-ct-trib-wt-item-docto.cod-tip-trib,
                                               INPUT "ALIQ-RED",
                                               INPUT STRING(tb-ct-trib-wt-item-docto.val-perc-reduc)).
                    RUN criaTTdeclaAdicTribut (INPUT tb-ct-trib-wt-item-docto.cod-tip-trib,
                                               INPUT "ALIQ-RED",
                                               INPUT STRING(tb-ct-trib-wt-item-docto.val-perc-reduc)).
                    RUN pi-GeraDeclaImportOrdTrib (INPUT tb-ct-trib-wt-item-docto.cod-tip-trib,
                                                   INPUT "ALIQ-RED",
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-perc-reduc)).
                                               
                    RUN criaTTdeclaItemTribut (INPUT tb-ct-trib-wt-item-docto.cod-tip-trib,
                                               INPUT "ALIQ-EFETIVA",
                                               INPUT STRING(tb-ct-trib-wt-item-docto.val-livre-2)).
                    RUN criaTTdeclaAdicTribut (INPUT tb-ct-trib-wt-item-docto.cod-tip-trib,
                                               INPUT "ALIQ-EFETIVA",
                                               INPUT STRING(tb-ct-trib-wt-item-docto.val-livre-2)).
                    RUN pi-GeraDeclaImportOrdTrib (INPUT tb-ct-trib-wt-item-docto.cod-tip-trib,
                                                   INPUT "ALIQ-EFETIVA",
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-livre-2)).
                    
                    RUN criaTTdeclaItemTribut (INPUT tb-ct-trib-wt-item-docto.cod-tip-trib,
                                               INPUT "BASE",
                                               INPUT STRING(tb-ct-trib-wt-item-docto.val-base-calc)). 
                    run criaTTdeclaAdicTribut (INPUT tb-ct-trib-wt-item-docto.cod-tip-trib,
                                               INPUT "BASE",
                                               INPUT STRING(tb-ct-trib-wt-item-docto.val-base-calc)).
                                               
                    IF tb-ct-trib-wt-item-docto.idi-cod-tributac = 3 THEN DO: //Outros
                        RUN criaTTdeclaItemTribut (INPUT tb-ct-trib-wt-item-docto.cod-tip-trib,
                                                   INPUT "OUTROS",
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-trib)).
                                                   
                        run criaTTdeclaAdicTribut (INPUT tb-ct-trib-wt-item-docto.cod-tip-trib,
                                                   INPUT "OUTROS",
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-trib)).                                                   
                                               
                    END.
                    ELSE DO:
                        RUN criaTTdeclaItemTribut (INPUT tb-ct-trib-wt-item-docto.cod-tip-trib,
                                                   INPUT "VALOR",
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-trib)).
                        run criaTTdeclaAdicTribut (INPUT tb-ct-trib-wt-item-docto.cod-tip-trib,
                                                   INPUT "VALOR",
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-trib)).                                                   
                    
                    END.
                END.
                WHEN "CBS_reg":U THEN DO:
                    RUN criaTTdeclaItemTribut (INPUT "CBS":U,
                                               INPUT "ALIQ-EFETIVA-REG",
                                               INPUT STRING(tb-ct-trib-wt-item-docto.val-livre-2)).
                    RUN criaTTdeclaAdicTribut (INPUT "CBS":U,
                                               INPUT "ALIQ-EFETIVA-REG",
                                               INPUT STRING(tb-ct-trib-wt-item-docto.val-livre-2)).
                    RUN pi-GeraDeclaImportOrdTrib (INPUT "CBS":U,
                                                   INPUT "ALIQ-EFETIVA-REG",
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-livre-2)).

                    RUN criaTTdeclaItemTribut (INPUT "CBS":U,
                                               INPUT "BASE-REG",
                                               INPUT STRING(tb-ct-trib-wt-item-docto.val-base-calc)).
                    RUN criaTTdeclaAdicTribut (INPUT "CBS":U,
                                               INPUT "BASE-REG",
                                               INPUT STRING(tb-ct-trib-wt-item-docto.val-base-calc)).

                    RUN criaTTdeclaItemTribut (INPUT "CBS":U,
                                               INPUT "VALOR-REG",
                                               INPUT STRING(tb-ct-trib-wt-item-docto.val-trib)).
                    RUN criaTTdeclaAdicTribut (INPUT "CBS":U,
                                               INPUT "VALOR-REG",
                                               INPUT STRING(tb-ct-trib-wt-item-docto.val-trib)).
                END.
                WHEN "IBSUF":U THEN DO:
                    RUN criaTTdeclaItemTribut (INPUT tb-ct-trib-wt-item-docto.cod-tip-trib,
                                               INPUT "COD-TRIB",
                                               INPUT STRING(tb-ct-trib-wt-item-docto.idi-cod-tributac)). 
                    
                    RUN criaTTdeclaItemTribut (INPUT tb-ct-trib-wt-item-docto.cod-tip-trib,
                                               INPUT "BASE",
                                               INPUT STRING(tb-ct-trib-wt-item-docto.val-base-calc)). 
                    RUN criaTTdeclaAdicTribut (INPUT tb-ct-trib-wt-item-docto.cod-tip-trib,
                                               INPUT "BASE",
                                               INPUT STRING(tb-ct-trib-wt-item-docto.val-base-calc)). 
                                               
                    RUN criaTTdeclaItemTribut (INPUT tb-ct-trib-wt-item-docto.cod-tip-trib,
                                               INPUT "ALIQUOTA",
                                               INPUT STRING(tb-ct-trib-wt-item-docto.val-aliq)). 
                    RUN criaTTdeclaAdicTribut (INPUT tb-ct-trib-wt-item-docto.cod-tip-trib,
                                               INPUT "ALIQUOTA",
                                               INPUT STRING(tb-ct-trib-wt-item-docto.val-aliq)). 
                    RUN pi-GeraDeclaImportOrdTrib (INPUT tb-ct-trib-wt-item-docto.cod-tip-trib,
                                                   INPUT "ALIQUOTA",
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-aliq)).
                                               
                    RUN criaTTdeclaItemTribut (INPUT tb-ct-trib-wt-item-docto.cod-tip-trib,
                                               INPUT "ALIQ-RED",
                                               INPUT STRING(tb-ct-trib-wt-item-docto.val-perc-reduc)).
                    RUN criaTTdeclaAdicTribut (INPUT tb-ct-trib-wt-item-docto.cod-tip-trib,
                                               INPUT "ALIQ-RED",
                                               INPUT STRING(tb-ct-trib-wt-item-docto.val-perc-reduc)).
                    RUN pi-GeraDeclaImportOrdTrib (INPUT tb-ct-trib-wt-item-docto.cod-tip-trib,
                                                   INPUT "ALIQ-RED",
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-perc-reduc)).
                                               
                    RUN criaTTdeclaItemTribut (INPUT tb-ct-trib-wt-item-docto.cod-tip-trib,
                                               INPUT "ALIQ-EFETIVA",
                                               INPUT STRING(tb-ct-trib-wt-item-docto.val-livre-2)).
                    RUN criaTTdeclaAdicTribut (INPUT tb-ct-trib-wt-item-docto.cod-tip-trib,
                                               INPUT "ALIQ-EFETIVA",
                                               INPUT STRING(tb-ct-trib-wt-item-docto.val-livre-2)).
                    RUN pi-GeraDeclaImportOrdTrib (INPUT tb-ct-trib-wt-item-docto.cod-tip-trib,
                                                   INPUT "ALIQ-EFETIVA",
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-livre-2)).
                                               
                    IF tb-ct-trib-wt-item-docto.idi-cod-tributac = 3 THEN DO: //Outros
                        RUN criaTTdeclaItemTribut (INPUT tb-ct-trib-wt-item-docto.cod-tip-trib,
                                                   INPUT "OUTROS",
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-trib)).
                                                   
                        run criaTTdeclaAdicTribut (INPUT tb-ct-trib-wt-item-docto.cod-tip-trib,
                                                   INPUT "OUTROS",
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-trib)).                                                   
                                               
                    END.
                    ELSE DO:
                        RUN criaTTdeclaItemTribut (INPUT tb-ct-trib-wt-item-docto.cod-tip-trib,
                                                   INPUT "VALOR",
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-trib)).
                        run criaTTdeclaAdicTribut (INPUT tb-ct-trib-wt-item-docto.cod-tip-trib,
                                                   INPUT "VALOR",
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-trib)).                    
                    END.
                END.
                WHEN "IBSUF_reg":U THEN DO:
                    RUN criaTTdeclaItemTribut (INPUT "IBSUF":U,
                                               INPUT "ALIQ-EFETIVA-REG",
                                               INPUT STRING(tb-ct-trib-wt-item-docto.val-livre-2)).
                    RUN criaTTdeclaAdicTribut (INPUT "IBSUF":U,
                                               INPUT "ALIQ-EFETIVA-REG",
                                               INPUT STRING(tb-ct-trib-wt-item-docto.val-livre-2)).
                    RUN pi-GeraDeclaImportOrdTrib (INPUT "IBSUF":U,
                                                   INPUT "ALIQ-EFETIVA-REG",
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-livre-2)).

                    RUN criaTTdeclaItemTribut (INPUT "IBSUF":U,
                                               INPUT "BASE-REG",
                                               INPUT STRING(tb-ct-trib-wt-item-docto.val-base-calc)).
                    RUN criaTTdeclaAdicTribut (INPUT "IBSUF":U,
                                               INPUT "BASE-REG",
                                               INPUT STRING(tb-ct-trib-wt-item-docto.val-base-calc)).

                    RUN criaTTdeclaItemTribut (INPUT "IBSUF":U,
                                               INPUT "VALOR-REG",
                                               INPUT STRING(tb-ct-trib-wt-item-docto.val-trib)).
                    RUN criaTTdeclaAdicTribut (INPUT "IBSUF":U,
                                               INPUT "VALOR-REG",
                                               INPUT STRING(tb-ct-trib-wt-item-docto.val-trib)).
                END.  
                WHEN "IBSMUN":U THEN DO:
                    RUN criaTTdeclaItemTribut (INPUT tb-ct-trib-wt-item-docto.cod-tip-trib,
                                               INPUT "COD-TRIB",
                                               INPUT STRING(tb-ct-trib-wt-item-docto.idi-cod-tributac)). 
                    
                    RUN criaTTdeclaItemTribut (INPUT tb-ct-trib-wt-item-docto.cod-tip-trib,
                                               INPUT "BASE",
                                               INPUT STRING(tb-ct-trib-wt-item-docto.val-base-calc)). 
                    RUN criaTTdeclaAdicTribut (INPUT tb-ct-trib-wt-item-docto.cod-tip-trib,
                                               INPUT "BASE",
                                               INPUT STRING(tb-ct-trib-wt-item-docto.val-base-calc)). 
                                               
                    RUN criaTTdeclaItemTribut (INPUT tb-ct-trib-wt-item-docto.cod-tip-trib,
                                               INPUT "ALIQUOTA",
                                               INPUT STRING(tb-ct-trib-wt-item-docto.val-aliq)). 
                    RUN criaTTdeclaAdicTribut (INPUT tb-ct-trib-wt-item-docto.cod-tip-trib,
                                               INPUT "ALIQUOTA",
                                               INPUT STRING(tb-ct-trib-wt-item-docto.val-aliq)). 
                    RUN pi-GeraDeclaImportOrdTrib (INPUT tb-ct-trib-wt-item-docto.cod-tip-trib,
                                                   INPUT "ALIQUOTA",
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-aliq)). 
                                               
                    RUN criaTTdeclaItemTribut (INPUT tb-ct-trib-wt-item-docto.cod-tip-trib,
                                               INPUT "ALIQ-RED",
                                               INPUT STRING(tb-ct-trib-wt-item-docto.val-perc-reduc)).
                    RUN criaTTdeclaAdicTribut (INPUT tb-ct-trib-wt-item-docto.cod-tip-trib,
                                               INPUT "ALIQ-RED",
                                               INPUT STRING(tb-ct-trib-wt-item-docto.val-perc-reduc)).
                    RUN pi-GeraDeclaImportOrdTrib (INPUT tb-ct-trib-wt-item-docto.cod-tip-trib,
                                                   INPUT "ALIQ-RED",
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-perc-reduc)).
                                               
                    RUN criaTTdeclaItemTribut (INPUT tb-ct-trib-wt-item-docto.cod-tip-trib,
                                               INPUT "ALIQ-EFETIVA",
                                               INPUT STRING(tb-ct-trib-wt-item-docto.val-livre-2)).
                    RUN criaTTdeclaAdicTribut (INPUT tb-ct-trib-wt-item-docto.cod-tip-trib,
                                               INPUT "ALIQ-EFETIVA",
                                               INPUT STRING(tb-ct-trib-wt-item-docto.val-livre-2)).
                    RUN pi-GeraDeclaImportOrdTrib (INPUT tb-ct-trib-wt-item-docto.cod-tip-trib,
                                                   INPUT "ALIQ-EFETIVA",
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-livre-2)).
                                               
                    IF tb-ct-trib-wt-item-docto.idi-cod-tributac = 3 THEN DO: //Outros
                        RUN criaTTdeclaItemTribut (INPUT tb-ct-trib-wt-item-docto.cod-tip-trib,
                                                   INPUT "OUTROS",
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-trib)).
                                                   
                        run criaTTdeclaAdicTribut (INPUT tb-ct-trib-wt-item-docto.cod-tip-trib,
                                                   INPUT "OUTROS",
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-trib)).                                                   
                                               
                    END.
                    ELSE DO:
                        RUN criaTTdeclaItemTribut (INPUT tb-ct-trib-wt-item-docto.cod-tip-trib,
                                                   INPUT "VALOR",
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-trib)).
                        run criaTTdeclaAdicTribut (INPUT tb-ct-trib-wt-item-docto.cod-tip-trib,
                                                   INPUT "VALOR",
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-trib)).                    
                    END.
                END.
                WHEN "IBSMUN_reg":U THEN DO:
                    RUN criaTTdeclaItemTribut (INPUT "IBSMUN":U,
                                               INPUT "ALIQ-EFETIVA-REG",
                                               INPUT STRING(tb-ct-trib-wt-item-docto.val-livre-2)).
                    RUN criaTTdeclaAdicTribut (INPUT "IBSMUN":U,
                                               INPUT "ALIQ-EFETIVA-REG",
                                               INPUT STRING(tb-ct-trib-wt-item-docto.val-livre-2)).
                    RUN pi-GeraDeclaImportOrdTrib (INPUT "IBSMUN":U,
                                                   INPUT "ALIQ-EFETIVA-REG",
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-livre-2)).

                    RUN criaTTdeclaItemTribut (INPUT "IBSMUN":U,
                                               INPUT "BASE-REG",
                                               INPUT STRING(tb-ct-trib-wt-item-docto.val-base-calc)).
                    RUN criaTTdeclaAdicTribut (INPUT "IBSMUN":U,
                                               INPUT "BASE-REG",
                                               INPUT STRING(tb-ct-trib-wt-item-docto.val-base-calc)).

                    RUN criaTTdeclaItemTribut (INPUT "IBSMUN":U,
                                               INPUT "VALOR-REG",
                                               INPUT STRING(tb-ct-trib-wt-item-docto.val-trib)).
                    RUN criaTTdeclaAdicTribut (INPUT "IBSMUN":U,
                                               INPUT "VALOR-REG",
                                               INPUT STRING(tb-ct-trib-wt-item-docto.val-trib)).
                END.
                    
                WHEN "IS":U THEN DO:
                    IF CAN-FIND(FIRST ITEM WHERE ITEM.it-codigo = tb-wt-it-docto.it-codigo
                                             AND SUBSTRING(item.char-1,289,1) = "S" /* Incide IS */ ) THEN DO:
                                              
                        RUN criaTTdeclaItemTribut (INPUT tb-ct-trib-wt-item-docto.cod-tip-trib,
                                                   INPUT "COD-TRIB",
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.idi-cod-tributac)).

                        RUN criaTTdeclaItemTribut (INPUT tb-ct-trib-wt-item-docto.cod-tip-trib,
                                                   INPUT "ALIQUOTA",
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-aliq)). 
                        RUN criaTTdeclaAdicTribut (INPUT tb-ct-trib-wt-item-docto.cod-tip-trib,
                                                   INPUT "ALIQUOTA",
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-aliq)).
                        RUN pi-GeraDeclaImportOrdTrib (INPUT tb-ct-trib-wt-item-docto.cod-tip-trib,
                                                       INPUT "ALIQUOTA",
                                                       INPUT STRING(tb-ct-trib-wt-item-docto.val-aliq)).
                                                   
                        RUN criaTTdeclaItemTribut (INPUT tb-ct-trib-wt-item-docto.cod-tip-trib,
                                                   INPUT "ALIQ-ESPEC-UN",
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-livre-2)).
                        RUN criaTTdeclaAdicTribut (INPUT tb-ct-trib-wt-item-docto.cod-tip-trib,
                                                   INPUT "ALIQ-ESPEC-UN",
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-livre-2)).
                        RUN pi-GeraDeclaImportOrdTrib (INPUT tb-ct-trib-wt-item-docto.cod-tip-trib,
                                                       INPUT "ALIQ-ESPEC-UN",
                                                       INPUT STRING(tb-ct-trib-wt-item-docto.val-livre-2)).
                                                   
                        RUN criaTTdeclaItemTribut (INPUT tb-ct-trib-wt-item-docto.cod-tip-trib,
                                                   INPUT "QTDE-TRIBUT",
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-livre-3)).
                        RUN criaTTdeclaAdicTribut (INPUT tb-ct-trib-wt-item-docto.cod-tip-trib,
                                                   INPUT "QTDE-TRIBUT",
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-livre-3)).
                        RUN pi-GeraDeclaImportOrdTrib (INPUT tb-ct-trib-wt-item-docto.cod-tip-trib,
                                                       INPUT "QTDE-TRIBUT",
                                                       INPUT STRING(tb-ct-trib-wt-item-docto.val-livre-3)).
                        
                        RUN criaTTdeclaItemTribut (INPUT tb-ct-trib-wt-item-docto.cod-tip-trib,
                                                   INPUT "BASE",
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-base-calc)). 
                        run criaTTdeclaAdicTribut (INPUT tb-ct-trib-wt-item-docto.cod-tip-trib,
                                                   INPUT "BASE",
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-base-calc)).
                                                   
                        IF tb-ct-trib-wt-item-docto.idi-cod-tributac = 3 THEN DO: //Outros
                            RUN criaTTdeclaItemTribut (INPUT tb-ct-trib-wt-item-docto.cod-tip-trib,
                                                       INPUT "OUTROS",
                                                       INPUT STRING(tb-ct-trib-wt-item-docto.val-trib)).
                                                       
                            run criaTTdeclaAdicTribut (INPUT tb-ct-trib-wt-item-docto.cod-tip-trib,
                                                       INPUT "OUTROS",
                                                       INPUT STRING(tb-ct-trib-wt-item-docto.val-trib)).                                                   
                                                   
                        END.
                        ELSE DO:
                            RUN criaTTdeclaItemTribut (INPUT tb-ct-trib-wt-item-docto.cod-tip-trib,
                                                       INPUT "VALOR",
                                                       INPUT STRING(tb-ct-trib-wt-item-docto.val-trib)).
                            run criaTTdeclaAdicTribut (INPUT tb-ct-trib-wt-item-docto.cod-tip-trib,
                                                       INPUT "VALOR",
                                                       INPUT STRING(tb-ct-trib-wt-item-docto.val-trib)).                                                   
                        
                        END.
                    END.
                END.
            END CASE.
        END.
        
    END. /* for each tb-ct-trib-wt-item-docto */

    IF l-nt2024002 THEN DO:
        IF CAN-FIND(FIRST tb-ct-trib-wt-item-docto
                    WHERE tb-ct-trib-wt-item-docto.num-seq-wt-docto = tb-wt-it-docto.seq-wt-docto
                      AND (   tb-ct-trib-wt-item-docto.cod-tip-trib = "CBS"
                           OR tb-ct-trib-wt-item-docto.cod-tip-trib = "IBSUF"
                           OR tb-ct-trib-wt-item-docto.cod-tip-trib = "IBSMUN"
                           OR tb-ct-trib-wt-item-docto.cod-tip-trib = "CBS_reg"
                           OR tb-ct-trib-wt-item-docto.cod-tip-trib = "IBSUF_reg"
                           OR tb-ct-trib-wt-item-docto.cod-tip-trib = "IBSMUN_reg"
                           OR tb-ct-trib-wt-item-docto.cod-tip-trib = "IS")) THEN DO:
                    
            FOR EACH decla-imp-adic-it-trib
               WHERE decla-imp-adic-it-trib.num-di-ems       = decla-import-adic-itens.num-di-ems
                 AND decla-imp-adic-it-trib.num-adic         = decla-import-adic-itens.num-adic
                 AND decla-imp-adic-it-trib.cdd-siscomex-dts = decla-import-adic-itens.cdd-siscomex-dts no-lock:
                 
                 IF decla-imp-adic-it-trib.nom-trib         = "CBS":U THEN DO:
                     IF decla-imp-adic-it-trib.cod-campo = "VALOR":U THEN
                        ASSIGN d-valor-cbs-itens-ct-trib = d-valor-cbs-itens-ct-trib + dec(decla-imp-adic-it-trib.cod-conteudo).
                     IF decla-imp-adic-it-trib.cod-campo = "BASE":U THEN
                        ASSIGN d-base-cbs-itens-ct-trib  = d-base-cbs-itens-ct-trib  + dec(decla-imp-adic-it-trib.cod-conteudo).
                     IF decla-imp-adic-it-trib.cod-campo = "OUTROS":U THEN
                        ASSIGN d-outros-cbs-itens-ct-trib = d-outros-cbs-itens-ct-trib + dec(decla-imp-adic-it-trib.cod-conteudo).
                     IF decla-imp-adic-it-trib.cod-campo = "VALOR-REG":U THEN
                        ASSIGN d-valor-cbsreg-itens-ct-trib = d-valor-cbsreg-itens-ct-trib + dec(decla-imp-adic-it-trib.cod-conteudo).
                     IF decla-imp-adic-it-trib.cod-campo = "BASE-REG":U THEN
                        ASSIGN d-base-cbsreg-itens-ct-trib  = d-base-cbsreg-itens-ct-trib + dec(decla-imp-adic-it-trib.cod-conteudo).
                 end.
                 IF decla-imp-adic-it-trib.nom-trib         = "IBSUF":U THEN DO:
                     IF decla-imp-adic-it-trib.cod-campo = "VALOR":U THEN
                        ASSIGN d-valor-ibs-itens-ct-trib = d-valor-ibs-itens-ct-trib + dec(decla-imp-adic-it-trib.cod-conteudo).
                     IF decla-imp-adic-it-trib.cod-campo = "BASE":U THEN
                        ASSIGN d-base-ibs-itens-ct-trib  = d-base-ibs-itens-ct-trib  + dec(decla-imp-adic-it-trib.cod-conteudo).
                     IF decla-imp-adic-it-trib.cod-campo = "OUTROS":U THEN
                        ASSIGN d-outros-ibs-itens-ct-trib = d-outros-ibs-itens-ct-trib + dec(decla-imp-adic-it-trib.cod-conteudo).
                     IF decla-imp-adic-it-trib.cod-campo = "VALOR-REG":U THEN
                        ASSIGN d-valor-ibsreg-itens-ct-trib = d-valor-ibsreg-itens-ct-trib + dec(decla-imp-adic-it-trib.cod-conteudo).
                     IF decla-imp-adic-it-trib.cod-campo = "BASE-REG":U THEN
                        ASSIGN d-base-ibsreg-itens-ct-trib = d-base-ibsreg-itens-ct-trib + dec(decla-imp-adic-it-trib.cod-conteudo).
                 end.
                 IF decla-imp-adic-it-trib.nom-trib         = "IBSMUN":U THEN DO:
                     IF decla-imp-adic-it-trib.cod-campo = "VALOR":U THEN
                        ASSIGN d-valor-ibsmun-itens-ct-trib = d-valor-ibsmun-itens-ct-trib + dec(decla-imp-adic-it-trib.cod-conteudo).
                     IF decla-imp-adic-it-trib.cod-campo = "BASE":U THEN
                        ASSIGN d-base-ibsmun-itens-ct-trib  = d-base-ibsmun-itens-ct-trib  + dec(decla-imp-adic-it-trib.cod-conteudo).
                     IF decla-imp-adic-it-trib.cod-campo = "OUTROS":U THEN
                        ASSIGN d-outros-ibsmun-itens-ct-trib = d-outros-ibsmun-itens-ct-trib + dec(decla-imp-adic-it-trib.cod-conteudo).
                     IF decla-imp-adic-it-trib.cod-campo = "VALOR-REG":U THEN
                        ASSIGN d-valor-ibsmunreg-itens-ct-trib = d-valor-ibsmunreg-itens-ct-trib + dec(decla-imp-adic-it-trib.cod-conteudo).
                     IF decla-imp-adic-it-trib.cod-campo = "BASE-REG":U THEN
                        ASSIGN d-base-ibsmunreg-itens-ct-trib = d-base-ibsmunreg-itens-ct-trib + dec(decla-imp-adic-it-trib.cod-conteudo).
                 END.
                 IF decla-imp-adic-it-trib.nom-trib = "IS":U THEN DO:
                     IF decla-imp-adic-it-trib.cod-campo = "VALOR":U THEN
                        ASSIGN d-valor-is-itens-ct-trib = d-valor-is-itens-ct-trib + DEC(decla-imp-adic-it-trib.cod-conteudo).
                     IF decla-imp-adic-it-trib.cod-campo = "BASE":U THEN
                        ASSIGN d-base-is-itens-ct-trib = d-base-is-itens-ct-trib + DEC(decla-imp-adic-it-trib.cod-conteudo).
                     IF decla-imp-adic-it-trib.cod-campo = "OUTROS":U THEN
                        ASSIGN d-outros-is-itens-ct-trib = d-outros-is-itens-ct-trib + DEC(decla-imp-adic-it-trib.cod-conteudo).
                 END.
            end. 
            FOR EACH decla-import-adic-trib
               WHERE decla-import-adic-trib.num-di-ems       = decla-import-adic-itens.num-di-ems
                 AND decla-import-adic-trib.num-adic         = decla-import-adic-itens.num-adic
                 AND decla-import-adic-trib.cdd-siscomex-dts = decla-import-adic-itens.cdd-siscomex-dts EXCLUSIVE-LOCK:

                 IF decla-import-adic-trib.nom-trib         = "CBS":U THEN DO:
                     IF decla-import-adic-trib.cod-campo = "VALOR":U THEN
                        ASSIGN decla-import-adic-trib.cod-conteudo = STRING(d-valor-cbs-itens-ct-trib).
                     IF decla-import-adic-trib.cod-campo = "BASE":U THEN
                        ASSIGN decla-import-adic-trib.cod-conteudo = STRING(d-base-cbs-itens-ct-trib).
                     IF decla-import-adic-trib.cod-campo = "OUTROS":U THEN
                        ASSIGN decla-import-adic-trib.cod-conteudo = STRING(d-outros-cbs-itens-ct-trib).
                     IF decla-import-adic-trib.cod-campo = "VALOR-REG":U THEN
                        ASSIGN decla-import-adic-trib.cod-conteudo = STRING(d-valor-cbsreg-itens-ct-trib).
                     IF decla-import-adic-trib.cod-campo = "BASE-REG":U THEN
                        ASSIGN decla-import-adic-trib.cod-conteudo = STRING(d-base-cbsreg-itens-ct-trib).
                 END.
                 IF decla-import-adic-trib.nom-trib         = "IBSUF":U THEN DO:
                     IF decla-import-adic-trib.cod-campo = "VALOR":U THEN
                        decla-import-adic-trib.cod-conteudo = STRING(d-valor-ibs-itens-ct-trib).
                     IF decla-import-adic-trib.cod-campo = "BASE":U THEN
                        ASSIGN decla-import-adic-trib.cod-conteudo = STRING(d-base-ibs-itens-ct-trib).
                     IF decla-import-adic-trib.cod-campo = "OUTROS":U THEN
                        ASSIGN decla-import-adic-trib.cod-conteudo = STRING(d-outros-ibs-itens-ct-trib).
                     IF decla-import-adic-trib.cod-campo = "VALOR-REG":U THEN
                        ASSIGN decla-import-adic-trib.cod-conteudo = STRING(d-valor-ibsreg-itens-ct-trib).
                     IF decla-import-adic-trib.cod-campo = "BASE-REG":U THEN
                        ASSIGN decla-import-adic-trib.cod-conteudo = STRING(d-base-ibsreg-itens-ct-trib).                    
                 END.
                 IF decla-import-adic-trib.nom-trib         = "IBSMUN":U THEN DO:
                     IF decla-import-adic-trib.cod-campo = "VALOR":U THEN
                        decla-import-adic-trib.cod-conteudo = STRING(d-valor-ibsmun-itens-ct-trib).
                     IF decla-import-adic-trib.cod-campo = "BASE":U THEN
                        ASSIGN decla-import-adic-trib.cod-conteudo = STRING(d-base-ibsmun-itens-ct-trib).
                     IF decla-import-adic-trib.cod-campo = "OUTROS":U THEN
                        ASSIGN decla-import-adic-trib.cod-conteudo = STRING(d-outros-ibsmun-itens-ct-trib).
                     IF decla-import-adic-trib.cod-campo = "VALOR-REG":U THEN
                        ASSIGN decla-import-adic-trib.cod-conteudo = STRING(d-valor-ibsmunreg-itens-ct-trib).
                     IF decla-import-adic-trib.cod-campo = "BASE-REG":U THEN
                        ASSIGN decla-import-adic-trib.cod-conteudo = STRING(d-base-ibsmunreg-itens-ct-trib).                    
                 END.
                 IF decla-import-adic-trib.nom-trib = "IS":U THEN DO:
                     IF decla-import-adic-trib.cod-campo = "VALOR":U THEN
                        ASSIGN decla-import-adic-trib.cod-conteudo = STRING(d-valor-is-itens-ct-trib).
                     IF decla-import-adic-trib.cod-campo = "BASE":U THEN
                        ASSIGN decla-import-adic-trib.cod-conteudo = STRING(d-base-is-itens-ct-trib).
                     IF decla-import-adic-trib.cod-campo = "OUTROS":U THEN
                        ASSIGN decla-import-adic-trib.cod-conteudo = STRING(d-outros-is-itens-ct-trib).
                 END.
            END.
        END.
    END.
    
    IF CAN-FIND(FIRST tb-ct-trib-wt-item-docto
                WHERE tb-ct-trib-wt-item-docto.num-seq-wt-docto = tb-wt-it-docto.seq-wt-docto
                  AND (   tb-ct-trib-wt-item-docto.cod-tip-trib = "FCP"
                       OR tb-ct-trib-wt-item-docto.cod-tip-trib = "FCP ST"
                       OR tb-ct-trib-wt-item-docto.cod-tip-trib = "ICMS"
                       OR tb-ct-trib-wt-item-docto.cod-tip-trib = "ICMS COMP" 
                       OR tb-ct-trib-wt-item-docto.cod-tip-trib = "ICMS ST")) THEN DO:
        
        ASSIGN de-val-icms-nao-tribut                      = de-val-icms-nao-tribut    + decla-import-adic-itens.val-icms-nao-tributad
               de-val-icms-outras                          = de-val-icms-outras        + decla-import-adic-itens.val-icms-outras
               de-val-base-icms                            = de-val-base-icms          + decla-import-adic-itens.val-base-icms
               de-val-icms-db-cr                           = de-val-icms-db-cr         + decla-import-adic-itens.val-icms-db-cr
               /*sobrep‰e os valores do ICMS que foram calculados sem o Configurador de Tributos*/
               decla-import-adic.val-icms-db-cr            = de-val-icms-db-cr
               decla-import-adic.val-icms-nao-tributad     = de-val-icms-nao-tribut
               decla-import-adic.val-icms-outras           = de-val-icms-outras
               decla-import-adic.val-base-icms             = de-val-base-icms.
        
        /* Caso o configurador encontre outra tributacao ou aliquota no momento de calcular o item, jogar o valor para a adicao */
        IF decla-import-adic.idi-tributac-icms <> decla-import-adic-itens.idi-tributac-icms THEN
            ASSIGN decla-import-adic.idi-tributac-icms = decla-import-adic-itens.idi-tributac-icms.
        
        IF decla-import-adic.val-aliq-icms <> decla-import-adic-itens.val-aliq-icms THEN
            ASSIGN decla-import-adic.val-aliq-icms = decla-import-adic-itens.val-aliq-icms.
    END. 
    
    RUN pi-gravar-dados-cfg-trib (input "", input c-embarque ).

    IF VALID-HANDLE(h-bodi317im2bra) THEN DO:
        DELETE PROCEDURE h-bodi317im2bra.
        ASSIGN h-bodi317im2bra = ?.
    END.

    IF VALID-HANDLE(h-bodi613calc2) THEN DO:
        DELETE PROCEDURE h-bodi613calc2.
        ASSIGN h-bodi613calc2 = ?.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculaII DBOProgram 
PROCEDURE calculaII :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE VARIABLE p-valor-ii-manual   AS LOGICAL NO-UNDO.
   
   {utp/ut-liter.i "Calculando_Imposto_de_Importaá∆o" *}
   RUN pi-acompanhar IN h-acomp (INPUT RETURN-VALUE). 

   FOR EACH decla-import-adic-itens EXCLUSIVE-LOCK
      WHERE decla-import-adic-itens.num-di-ems = decla-import-adic.num-di-ems
        AND decla-import-adic-itens.num-adic   = decla-import-adic.num-adic
        AND decla-import-adic-itens.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts:

       FIND FIRST decla-import-ord NO-LOCK
           WHERE  decla-import-ord.cod-embarq  = decla-import-adic-itens.cod-embarq
           AND    decla-import-ord.num-ordem   = decla-import-adic-itens.num-ordem
           AND    decla-import-ord.num-parcela = decla-import-adic-itens.num-parcela
           AND    decla-import-ord.cod-estab   = decla-import-adic-itens.cod-estab 
           AND    decla-import-ord.num-di-ems  = decla-import-adic-itens.num-di-ems 
           AND    decla-import-ord.num-adic    = decla-import-adic-itens.num-adic 
           AND    decla-import-ord.cdd-siscomex-dts = decla-import-adic-itens.cdd-siscomex-dts NO-ERROR.
           
       ASSIGN d-val-ii         = decla-import-adic.val-base-ii  * (decla-import-adic.val-aliq-ii / 100)
              d-val-desp-unit  = (decla-import-adic.val-base-ii * (decla-import-adic.val-aliq-ii / 100)) / decla-import-ord.qtd-fornec.           

       /* Calcula o valor apenas se n∆o foi alterado manualmente*/
       IF NOT l-valor-ii-manual THEN DO:

           IF decla-import-adic.log-suspens-impto-import THEN
               ASSIGN decla-import-adic.val-ii-nao-tribut = ROUND(d-val-ii,8).
           ELSE DO: 
               CASE decla-import-adic.idi-tributac-impto-import:
                   WHEN 1 THEN
                       ASSIGN decla-import-adic.val-ii-db-cr  = ROUND(d-val-ii,8).
                   WHEN 2 THEN
                       ASSIGN decla-import-adic.val-ii-db-cr  = 0.
                   WHEN 3 THEN
                       ASSIGN decla-import-adic.val-ii-outras = ROUND(d-val-ii,8).
                   WHEN 4 THEN
                       ASSIGN decla-import-adic.val-ii-db-cr  = ROUND(d-val-ii,8).
               END CASE.
           END.
       END.
   END. 

   /* atualiza o valos da base do ii na tt de validacao */
   ASSIGN tt-verifica-impostos.val-valor-ii-sist = ROUND(d-val-ii,8)
          tt-verifica-impostos.val-valor-ii-inf  = decla-import-adic.val-ii-db-cr      WHEN decla-import-adic.val-ii-db-cr      > 0
          tt-verifica-impostos.val-valor-ii-inf  = decla-import-adic.val-ii-outras     WHEN decla-import-adic.val-ii-outras     > 0
          tt-verifica-impostos.val-valor-ii-inf  = decla-import-adic.val-ii-nao-tribut WHEN decla-import-adic.val-ii-nao-tribut > 0.
   
   
   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculaII-item DBOProgram 
PROCEDURE calculaII-item :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE p-valor-ii-manual AS LOGICAL NO-UNDO.
    
    {utp/ut-liter.i "Calculando_Imposto_de_Importaá∆o" *}
    RUN pi-acompanhar IN h-acomp (INPUT RETURN-VALUE). 
    
    ASSIGN d-val-ii           = decla-import-adic-itens.val-base-ii  * (decla-import-adic-itens.val-aliq-ii / 100)
           d-valor-ii-itens   = d-valor-ii-itens + d-val-ii.           

    /* Calcula o valor apenas se n∆o foi alterado manualmente*/
    IF NOT l-valor-ii-manual THEN DO:

        IF decla-import-adic-itens.log-suspens-impto-import THEN
            ASSIGN decla-import-adic-itens.val-ii-nao-tribut = ROUND(d-val-ii,8).
        ELSE DO:
            CASE decla-import-adic-itens.idi-tributac-impto-import:
                WHEN 1 THEN
                    ASSIGN decla-import-adic-itens.val-ii-db-cr  = ROUND(d-val-ii,8).
                WHEN 2 THEN
                    ASSIGN decla-import-adic-itens.val-ii-db-cr  = 0.
                WHEN 3 THEN
                    ASSIGN decla-import-adic-itens.val-ii-outras = ROUND(d-val-ii,8).
                WHEN 4 THEN
                    ASSIGN decla-import-adic-itens.val-ii-db-cr  = ROUND(d-val-ii,8).
            END CASE.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculaIPIItem DBOProgram 
PROCEDURE calculaIPIItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Calculando_IPI_Itens" *}
    RUN pi-acompanhar IN h-acomp (INPUT RETURN-VALUE). /* altera a mensagem do acompanhamentos */

    DEF VAR d-valor-merc-liq    LIKE decla-import-adic.val-vmle NO-UNDO.
    DEF VAR i                   AS INTEGER INITIAL 0            NO-UNDO.
    DEF VAR piItem              AS CHAR                         NO-UNDO.
    DEF VAR l-procedimento-ok   AS LOGICAL                      NO-UNDO.
    DEF VAR de-valor-incide-ipi AS DECIMAL                      NO-UNDO.
    DEF VAR d-val-manual-ipi    LIKE decla-import-adic.val-ipi-db-cr NO-UNDO.

    IF NOT VALID-HANDLE(h-bodi317im2bra) THEN
        RUN dibo/bodi317im2bra PERSISTEN SET h-bodi317im2bra.
    
    RUN limpaTbWt. /* limpar as temp-tables tb-wt-docto, tb-wt-it-docto, tb-wt-it-imposto e tb-ct-trib-wt-item-docto */

    ASSIGN i = i + 1.
        
    FIND FIRST estabelec NO-LOCK
            WHERE estabelec.cod-estabel = decla-import.cod-estab NO-ERROR.
    
    FOR FIRST decla-import-ord NO-LOCK
        WHERE decla-import-ord.num-di-ems  = decla-import-adic-itens.num-di-ems
        AND   decla-import-ord.num-adic    = decla-import-adic-itens.num-adic
        AND   decla-import-ord.num-ordem   = decla-import-adic-itens.num-ordem
        AND   decla-import-ord.num-parcela = decla-import-adic-itens.num-parcela
        AND   decla-import-ord.cdd-siscomex-dts = decla-import-adic-itens.cdd-siscomex-dts:

        FIND FIRST natur-oper NO-LOCK
            WHERE natur-oper.nat-operacao = decla-import-ord.cod-natur-operac NO-ERROR.
    END.

    FIND FIRST emitente NO-LOCK
        WHERE emitente.cod-emitente = decla-import-adic.cdn-fornec NO-ERROR.

    FOR FIRST ITEM NO-LOCK
         WHERE ITEM.it-codigo = decla-import-ord.cod-item: END.

    /* ASSIGN piItem = decla-import.num-di-ems + decla-import-adic.num-adic. Marcelo*/
    ASSIGN piItem = string(decla-import.num-di-ems) + "/" + STRING(decla-import.cdd-siscomex-dts) + "/" + string(decla-import-adic.num-adic).


    IF NOT CAN-FIND(FIRST tb-wt-docto 
                        WHERE tb-wt-docto.seq-wt-docto = 1) THEN DO:

        CREATE tb-wt-docto.
        ASSIGN tb-wt-docto.seq-wt-docto = 1
               tb-wt-docto.cod-emitente = decla-import-adic.cdn-fornec
               tb-wt-docto.nr-nota      = piItem
               tb-wt-docto.nat-operacao = decla-import-ord.cod-natur-operac WHEN AVAIL decla-import-ord
               tb-wt-docto.cod-des-merc = IF natur-oper.consum-final THEN 2 ELSE 1
               tb-wt-docto.cod-estabel  = decla-import.cod-estab
               tb-wt-docto.dt-emis-nota = TODAY
               tb-wt-docto.esp-docto    = 21
               tb-wt-docto.ind-tip-nota = 8
               tb-wt-docto.mo-codigo    = decla-import-adic.cdn-moeda
               tb-wt-docto.nome-abrev   = emitente.nome-abrev
               tb-wt-docto.vl-embalagem = 0
               tb-wt-docto.vl-frete     = 0
               tb-wt-docto.vl-mercad    = d-valor-merc-liq /*valor da mercadoria */
               tb-wt-docto.nr-prog      = 176 /* para indicar no bodi317im1br.i1 que a boin176 que chamou */
               tb-wt-docto.vl-seguro    = 0
               tb-wt-docto.cidade       = estabelec.cidade
               tb-wt-docto.estado       = estabelec.estado
               tb-wt-docto.pais         = estabelec.pais.
    END.

        
    IF NOT CAN-FIND(FIRST tb-wt-it-docto 
                        WHERE tb-wt-it-docto.seq-wt-docto = 1
                        AND   tb-wt-it-docto.seq-wt-it-docto = i) THEN DO:
        
        CREATE tb-wt-it-docto.
        ASSIGN tb-wt-it-docto.seq-wt-docto        = 1
               tb-wt-it-docto.seq-wt-it-docto     = i
               tb-wt-it-docto.calcula             = YES
               tb-wt-it-docto.it-codigo           = item.it-codigo when avail item
               tb-wt-it-docto.nat-operacao        = decla-import-ord.cod-natur-operac WHEN AVAIL decla-import-ord
               tb-wt-it-docto.nr-sequencia        = i
               tb-wt-it-docto.nr-seq-nota         = 1 
               tb-wt-it-docto.quantidade[1]       = decla-import-adic-itens.qtd-adic[1]
               tb-wt-it-docto.vl-merc-ori         = 0
               tb-wt-it-docto.vl-merc-liq         = 0
               tb-wt-it-docto.vl-despes-it        = 0
               tb-wt-it-docto.vl-frete            = 0
               tb-wt-it-docto.vl-seguro           = 0
               tb-wt-it-docto.vl-preori           = decla-import-adic-itens.val-vmcv / tb-wt-it-docto.quantidade[1]
               tb-wt-it-docto.vl-preuni           = d-valor-merc-liq / tb-wt-it-docto.quantidade[1]
               tb-wt-it-docto.vl-merc-s-icms      = d-valor-merc-liq
               tb-wt-it-docto.vl-merc-tab         = d-valor-merc-liq
               tb-wt-it-docto.numero-ordem        = decla-import-adic-itens.num-ordem
               tb-wt-it-docto.parcela             = decla-import-adic-itens.num-parcela
               OVERLAY(tb-wt-it-docto.char-1,1,6) = "IM7777":U. /*integracao com o modulo de importaá∆o*/
    END.

    IF NOT CAN-FIND(FIRST tb-wt-it-imposto 
                        WHERE tb-wt-it-imposto.seq-wt-docto = 1
                        AND   tb-wt-it-imposto.seq-wt-it-docto = i) THEN DO:
        CREATE tb-wt-it-imposto.
        ASSIGN tb-wt-it-imposto.seq-wt-docto    = 1
               tb-wt-it-imposto.seq-wt-it-docto = i
               tb-wt-it-imposto.perc-red-icm    = decla-import-adic.val-perc-reduc-icms    /*gravar todas essas informaá‰es da adiá∆o */
               tb-wt-it-imposto.perc-red-ipi    = decla-import-adic.val-perc-reduc-ipi
               tb-wt-it-imposto.perc-red-iss    = 0
               tb-wt-it-imposto.aliquota-ipi    = decla-import-adic.val-aliq-ipi
               tb-wt-it-imposto.aliquota-icm    = decla-import-adic.val-aliq-icms
               tb-wt-it-imposto.aliquota-iss    = 0
               tb-wt-it-imposto.cd-trib-ipi     = decla-import-adic.idi-tributac-ipi
               tb-wt-it-imposto.cd-trib-icm     = decla-import-adic.idi-tributac-icms
               tb-wt-it-imposto.cd-trib-iss     = 0
               tb-wt-it-imposto.ind-icm-ret     = NO.
        
        /* verificar se o ii incide em ipi e  somar na base do ipi */
        FOR FIRST desp-imp NO-LOCK
                WHERE desp-imp.cod-desp  = i-cod-desp-ii:
            ASSIGN de-valor-incide-ipi = 0.
            IF desp-imp.inc-base-ipi THEN
                ASSIGN de-valor-incide-ipi = decla-import-adic-itens.val-ii-db-cr.
            ELSE
                ASSIGN de-valor-incide-ipi = 0.
        END.
        /* fim - verificar se o ii incide em ipi e  somar na base do ipi */
        
        /* A base do IPI pelo valor bruto ou liquido j† foi testada na procedure "calculaValBasesItem",
           sendo assim o valor do campo "decla-import-adic-itens.val-base-ipi" j† vem correto neste ponto */
        ASSIGN tb-wt-it-imposto.vl-bipi-it = decla-import-adic-itens.val-base-ipi
               tb-wt-it-imposto.vl-bipi-it = (tb-wt-it-imposto.vl-bipi-it + de-valor-incide-ipi) WHEN NOT l-base-ipi-manual.  
        
    END.    
    
    RUN enviaTbWtDocto     IN  h-bodi317im2bra (INPUT TABLE tb-wt-docto).
    RUN enviaTbWtItDocto   IN  h-bodi317im2bra (INPUT TABLE tb-wt-it-docto).
    RUN enviaTbWtItImposto IN  h-bodi317im2bra (INPUT TABLE tb-wt-it-imposto).

    RUN localizaWtDocto IN h-bodi317im2bra (INPUT  1,
                                            OUTPUT l-procedimento-ok).
    IF  NOT l-procedimento-ok THEN 
        RETURN "NOK":U.            

    RUN localizaWtItDocto IN h-bodi317im2bra (INPUT  1,
                                              INPUT  tb-wt-it-docto.seq-wt-it-docto,
                                              OUTPUT l-procedimento-ok).
    IF  NOT l-procedimento-ok THEN 
        RETURN "NOK":U.

    RUN localizaWtItImposto IN h-bodi317im2bra (INPUT  1,
                                                INPUT  tb-wt-it-imposto.seq-wt-it-docto,
                                                OUTPUT l-procedimento-ok).
    IF  NOT l-procedimento-ok THEN 
        RETURN "NOK":U.

    
    RUN calculaIPI IN h-bodi317im2bra (INPUT  NO,    /* Nota Comercio    */ 
                                       OUTPUT l-procedimento-ok) .
    
    RUN retornaTbWtItImposto IN h-bodi317im2bra (OUTPUT TABLE tb-wt-it-imposto).
       
    FIND tb-wt-it-imposto
        WHERE tb-wt-it-imposto.seq-wt-docto    = 1
          AND tb-wt-it-imposto.seq-wt-it-docto = tb-wt-it-docto.seq-wt-it-docto 
        EXCLUSIVE-LOCK NO-ERROR.
        
    /* Atualizar os dados calculados NO tb-wt-it-imposto para a decla-import-adic.  */
    ASSIGN decla-import-adic-itens.val-base-ipi = tb-wt-it-imposto.vl-bipi-it WHEN NOT l-base-ipi-manual.
                                                
    IF  decla-import-adic-itens.idi-tributac-ipi = 2 /* Isento */ 
    THEN ASSIGN decla-import-adic-itens.val-base-ipi         = tb-wt-it-imposto.vl-ipint-it
                decla-import-adic-itens.val-ipi-nao-tributad = 0
                decla-import-adic-itens.val-ipi-outras       = 0
                decla-import-adic-itens.val-ipi-db-cr        = 0.
    ELSE DO:
        IF  decla-import-adic-itens.idi-tributac-ipi = 3 /* Outros */ 
        THEN DO:
            ASSIGN decla-import-adic-itens.val-base-ipi = tb-wt-it-imposto.vl-ipiou-it. /* Quando opá∆o OUTROS, base vem no valor outros da wt-it-imposto */

            IF  decla-import-adic-itens.log-suspens-ipi-import /* Suspenso */ 
            THEN IF decla-import-adic-itens.val-aliq-ipi > 0
                 THEN ASSIGN decla-import-adic-itens.val-ipi-nao-tributad = round(tb-wt-it-imposto.vl-ipi-it,8) WHEN NOT l-valor-ipi-manual
                             decla-import-adic-itens.val-ipi-outras       = 0                         
                             decla-import-adic-itens.val-ipi-db-cr        = 0.                        
                 ELSE ASSIGN decla-import-adic-itens.val-ipi-nao-tributad = 0
                             decla-import-adic-itens.val-ipi-outras       = 0                         
                             decla-import-adic-itens.val-ipi-db-cr        = 0.                        
            ELSE IF decla-import-adic-itens.val-aliq-ipi > 0
                 OR decla-import-adic-itens.val-unit-ipi > 0
                 THEN ASSIGN decla-import-adic-itens.val-ipi-nao-tributad = 0
                             decla-import-adic-itens.val-ipi-outras       = round(tb-wt-it-imposto.vl-ipi-it,8) WHEN NOT l-valor-ipi-manual
                             decla-import-adic-itens.val-ipi-db-cr        = 0.                        
                 ELSE ASSIGN decla-import-adic-itens.val-ipi-nao-tributad = 0
                             decla-import-adic-itens.val-ipi-outras       = 0                         
                             decla-import-adic-itens.val-ipi-db-cr        = 0.                        
        END. /* THEN DO: */
        ELSE DO:        
            IF  decla-import-adic-itens.val-aliq-ipi = 0 AND decla-import-adic-itens.val-unit-ipi = 0 THEN
                ASSIGN decla-import-adic-itens.val-base-ipi = tb-wt-it-imposto.vl-ipiou-it.
            ELSE 
            IF  decla-import-adic-itens.log-suspens-ipi-import /* Suspenso */ THEN DO:
                IF  tb-wt-it-imposto.vl-ipiou-it > 0 THEN ASSIGN decla-import-adic-itens.val-ipi-nao-tributad = round(tb-wt-it-imposto.vl-ipiou-it,8) WHEN NOT l-valor-ipi-manual
                                                                 decla-import-adic-itens.val-ipi-outras       = 0
                                                                 decla-import-adic-itens.val-ipi-db-cr        = 0.
                IF  tb-wt-it-imposto.vl-ipi-it   > 0 THEN ASSIGN decla-import-adic-itens.val-ipi-nao-tributad = round(tb-wt-it-imposto.vl-ipi-it,8) WHEN NOT l-valor-ipi-manual
                                                                 decla-import-adic-itens.val-ipi-outras       = 0                         
                                                                 decla-import-adic-itens.val-ipi-db-cr        = 0.                        
                IF  tb-wt-it-imposto.vl-ipint-it > 0 THEN ASSIGN decla-import-adic-itens.val-ipi-nao-tributad = round(tb-wt-it-imposto.vl-ipint-it,8) WHEN NOT l-valor-ipi-manual
                                                                 decla-import-adic-itens.val-ipi-outras       = 0
                                                                 decla-import-adic-itens.val-ipi-db-cr        = 0.
            END. /* IF  decla-import-adic.log-suspens-ipi-import */
            ELSE DO:
                IF  tb-wt-it-imposto.vl-ipiou-it > 0 THEN ASSIGN decla-import-adic-itens.val-ipi-nao-tributad = 0
                                                                 decla-import-adic-itens.val-ipi-outras       = round(tb-wt-it-imposto.vl-ipiou-it,8) WHEN NOT l-valor-ipi-manual
                                                                 decla-import-adic-itens.val-ipi-db-cr        = 0.
                IF  tb-wt-it-imposto.vl-ipi-it   > 0 THEN ASSIGN decla-import-adic-itens.val-ipi-nao-tributad = 0
                                                                 decla-import-adic-itens.val-ipi-outras       = 0
                                                                 decla-import-adic-itens.val-ipi-db-cr        = round(tb-wt-it-imposto.vl-ipi-it,8) WHEN NOT l-valor-ipi-manual.
                IF  tb-wt-it-imposto.vl-ipint-it > 0 THEN ASSIGN decla-import-adic-itens.val-ipi-nao-tributad = round(tb-wt-it-imposto.vl-ipint-it,8) WHEN NOT l-valor-ipi-manual
                                                                 decla-import-adic-itens.val-ipi-outras       = 0
                                                                 decla-import-adic-itens.val-ipi-db-cr        = IF decla-import-adic-itens.idi-tributac-ipi = 4 /* Reduzido */
                                                                                                                THEN decla-import-adic-itens.val-ipi-db-cr
                                                                                                                ELSE 0.
            END. /* ELSE DO: */
        END. /* ELSE DO: */
    END. /* ELSE DO: */

    ASSIGN d-valor-ipi-itens = d-valor-ipi-itens 
                             + decla-import-adic-itens.val-ipi-nao-tributad
                             + decla-import-adic-itens.val-ipi-outras
                             + decla-import-adic-itens.val-ipi-db-cr.
                             
    IF VALID-HANDLE(h-bodi317im2bra) THEN 
        DELETE PROCEDURE h-bodi317im2bra.
    ASSIGN h-bodi317im2bra = ?.
       
    EMPTY TEMP-TABLE tb-wt-docto.
    EMPTY TEMP-TABLE tb-wt-it-docto.
    EMPTY TEMP-TABLE tb-wt-it-imposto.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculaPisCofins DBOProgram 
PROCEDURE calculaPisCofins :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR p-imp-manual-pis    AS LOGICAL NO-UNDO.
    DEF VAR p-imp-manual-cofins AS LOGICAL NO-UNDO.

    {utp/ut-liter.i "Calculando_PIS_e_COFINS" *}
    RUN pi-acompanhar IN h-acomp (INPUT RETURN-VALUE). /* altera a mensagem do acompanhamentos */
                                                             
    RUN imp/imapi010.p(INPUT  decla-import.num-di-ems,
                       INPUT  decla-import.dat-di,
                       INPUT  decla-import-adic.num-adic,
                       INPUT  decla-import.cod-estab,
                       INPUT  decla-import.cdd-siscomex-dts,
                       OUTPUT d-val-pis-sist    ,
                       OUTPUT d-val-cofins-sist).
    IF d-val-pis-sist = ? THEN
        ASSIGN d-val-pis-sist = 0.
    IF d-val-cofins-sist = ? THEN
        ASSIGN d-val-cofins-sist = 0.

    ASSIGN d-valor-pis     = 0
           d-valor-confins = 0.

    IF SUBSTRING(decla-import-adic.cod-livre-1,2,1) = '1':U THEN /* log-suspens-pis */
       ASSIGN d-valor-pis = ROUND(decla-import-adic.val-pis-nao-tributad,8).
    ELSE DO:
        CASE decla-import-adic.idi-tributac-pis: 
            WHEN 1 THEN
                ASSIGN d-valor-pis = ROUND(decla-import-adic.val-pis-db-cr,8).
            WHEN 2 THEN
                ASSIGN d-valor-pis = ROUND(decla-import-adic.val-pis-nao-tributad,8)
                       decla-import-adic.val-pis-nao-tributad = 0 .
            WHEN 3 THEN
                ASSIGN d-valor-pis = ROUND(decla-import-adic.val-pis-outras,8).
            WHEN 4 THEN
                ASSIGN d-valor-pis = ROUND(decla-import-adic.val-pis-db-cr,8).
        END CASE.
    END.

    IF SUBSTRING(decla-import-adic.cod-livre-1,3,1) = '1':U THEN /* log-suspens-cofins */
       ASSIGN d-valor-confins = ROUND(decla-import-adic.val-cofins-nao-tributad,8).
    ELSE DO:
        CASE decla-import-adic.idi-tributac-cofins:
            WHEN 1 THEN
                ASSIGN d-valor-confins = ROUND(decla-import-adic.val-cofins-db-cr,8).
            WHEN 2 THEN
                ASSIGN d-valor-confins = ROUND(decla-import-adic.val-cofins-nao-tributad,8)
                       decla-import-adic.val-cofins-nao-tributad = 0.
            WHEN 3 THEN
                ASSIGN d-valor-confins = ROUND(decla-import-adic.val-cofins-outras,8).
            WHEN 4 THEN
                ASSIGN d-valor-confins = ROUND(decla-import-adic.val-cofins-db-cr,8).
        END CASE.   
    END.

    /* atualiza a base do pis e cofins */
    IF decla-import-adic.val-unit-pis > 0 OR decla-import-adic.val-unit-cofins > 0 THEN
        ASSIGN decla-import-adic.val-base-pis            = 0 WHEN NOT l-base-pis-manual
               decla-import-adic.val-base-cofins         = 0 WHEN NOT l-base-cofins-manual 
               tt-verifica-impostos.val-base-pis-sist    = 0
               tt-verifica-impostos.val-base-cofins-sist = 0
               tt-verifica-impostos.val-base-pis-inf     = decla-import-adic.val-base-pis
               tt-verifica-impostos.val-base-cofins-inf  = decla-import-adic.val-base-cofins.
    ELSE DO:
        ASSIGN decla-import-adic.val-base-pis            = round(d-valor-pis     / (decla-import-adic.val-aliq-pis / 100 ),8)   WHEN NOT l-base-pis-manual   
               decla-import-adic.val-base-cofins         = round(d-valor-confins / (decla-import-adic.val-aliq-cofins / 100),8) WHEN NOT l-base-cofins-manual
               tt-verifica-impostos.val-base-pis-sist    = round(d-valor-pis     / (decla-import-adic.val-aliq-pis / 100 ),8)
               tt-verifica-impostos.val-base-cofins-sist = round(d-valor-confins / (decla-import-adic.val-aliq-cofins / 100),8)
               tt-verifica-impostos.val-base-pis-inf     = decla-import-adic.val-base-pis
               tt-verifica-impostos.val-base-cofins-inf  = decla-import-adic.val-base-cofins.               
        
        /* Apresentar a base de calculo do PIS/COFINS quando tributado e al°quota = 0% */
        IF decla-import-adic.idi-tributac-cofins = 1 AND 
           decla-import-adic.val-aliq-cofins     = 0 AND 
           decla-import-adic.val-base-cofins     = ? THEN
            ASSIGN decla-import-adic.val-base-cofins = round((dec(SUBSTRING(decla-import-adic.cod-livre-2,1,22)) + dec(SUBSTRING(decla-import-adic.cod-livre-2,23,22))) / 100000,8) WHEN NOT l-base-cofins-manual.
        IF decla-import-adic.idi-tributac-pis = 1 AND 
           decla-import-adic.val-aliq-pis     = 0 AND 
           decla-import-adic.val-base-pis     = ? THEN
            ASSIGN decla-import-adic.val-base-pis = round((dec(SUBSTRING(decla-import-adic.cod-livre-2,45,22)) + dec(SUBSTRING(decla-import-adic.cod-livre-2,67,22))) / 100000,8) WHEN NOT l-base-pis-manual.            
    END.

     IF decla-import-adic.val-base-pis = ? THEN
        ASSIGN decla-import-adic.val-base-pis = 0.
    IF decla-import-adic.val-base-cofins = ? THEN
        ASSIGN decla-import-adic.val-base-cofins  = 0.


    /* carrega tt de verificaá∆o dos valores dos impostos */
    ASSIGN tt-verifica-impostos.val-valor-pis-sist    = d-val-pis-sist
           tt-verifica-impostos.val-valor-cofins-sist = d-val-cofins-sist
           tt-verifica-impostos.val-valor-pis-inf     = decla-import-adic.val-pis-db-cr           WHEN decla-import-adic.val-pis-db-cr           > 0
           tt-verifica-impostos.val-valor-pis-inf     = decla-import-adic.val-pis-outras          WHEN decla-import-adic.val-pis-outras          > 0
           tt-verifica-impostos.val-valor-pis-inf     = decla-import-adic.val-pis-nao-tributad    WHEN decla-import-adic.val-pis-nao-tributad    > 0
           tt-verifica-impostos.val-valor-cofins-inf  = decla-import-adic.val-cofins-db-cr        WHEN decla-import-adic.val-cofins-db-cr        > 0
           tt-verifica-impostos.val-valor-cofins-inf  = decla-import-adic.val-cofins-outras       WHEN decla-import-adic.val-cofins-outras       > 0
           tt-verifica-impostos.val-valor-cofins-inf  = decla-import-adic.val-cofins-nao-tributad WHEN decla-import-adic.val-cofins-nao-tributad > 0.
           
    

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculaPisCofinsItem DBOProgram 
PROCEDURE calculaPisCofinsItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN imp/imapi011.p (INPUT decla-import-adic-itens.num-di-ems,
                        INPUT decla-import.dat-di,
                        INPUT decla-import-adic-itens.num-adic,
                        INPUT decla-import-adic-itens.num-seq,
                        INPUT decla-import.cod-estab,
                        INPUT decla-import.cdd-siscomex-dts,
                        OUTPUT d-val-pis-item    ,
                        OUTPUT d-val-cofins-item ).

    IF d-val-pis-item = ? THEN
        ASSIGN d-val-pis-item = 0.
    IF d-val-cofins-item = ? THEN
        ASSIGN d-val-cofins-item = 0.

    ASSIGN d-valor-pis     = 0
           d-valor-confins = 0.

    CASE decla-import-adic-itens.idi-tributac-pis:
        WHEN 1 THEN
            ASSIGN d-valor-pis = round(decla-import-adic-itens.val-pis-db-cr,8).
        WHEN 2 THEN
            ASSIGN d-valor-pis                                  = round(decla-import-adic-itens.val-pis-nao-tributad,8)
                   decla-import-adic-itens.val-pis-nao-tributad = 0 .
        WHEN 3 THEN
            ASSIGN d-valor-pis = round(decla-import-adic-itens.val-pis-outras,8).
        WHEN 4 THEN
            ASSIGN d-valor-pis = round(decla-import-adic-itens.val-pis-db-cr,8).
    END CASE.

    CASE decla-import-adic-itens.idi-tributac-cofins:
        WHEN 1 THEN
            ASSIGN d-valor-confins = round(decla-import-adic-itens.val-cofins-db-cr,8).
        WHEN 2 THEN
            ASSIGN d-valor-confins                                 = round(decla-import-adic-itens.val-cofins-nao-tributad,8)
                   decla-import-adic-itens.val-cofins-nao-tributad = 0.
        WHEN 3 THEN
            ASSIGN d-valor-confins = round(decla-import-adic-itens.val-cofins-outras,8).
        WHEN 4 THEN
            ASSIGN d-valor-confins = round(decla-import-adic-itens.val-cofins-db-cr,8).
    END CASE.


    ASSIGN decla-import-adic-itens.val-base-pis      = round(d-valor-pis     / (decla-import-adic-itens.val-aliq-pis / 100 ),8)   WHEN NOT l-base-pis-manual   
           decla-import-adic-itens.val-base-cofins   = round(d-valor-confins / (decla-import-adic-itens.val-aliq-cofins / 100),8) WHEN NOT l-base-cofins-manual
           d-val-pis-adic    = d-val-pis-adic    + d-val-pis-item
           d-val-cofins-adic = d-val-cofins-adic + d-val-cofins-item.

    IF decla-import-adic-itens.val-base-pis = ? THEN
        ASSIGN decla-import-adic-itens.val-base-pis = 0.
    IF decla-import-adic-itens.val-base-cofins = ? THEN
        ASSIGN decla-import-adic-itens.val-base-cofins = 0.
        
    /* Apresentar a base de calculo do PIS/COFINS quando tributado e al°quota = 0% */        
    IF decla-import-adic-itens.idi-tributac-cofins = 1 AND 
       decla-import-adic-itens.val-aliq-cofins     = 0 AND 
       decla-import-adic-itens.val-base-cofins     = 0 THEN
        ASSIGN decla-import-adic-itens.val-base-cofins = round((dec(SUBSTRING(decla-import-adic-itens.cod-livre-2,1,22)) + dec(SUBSTRING(decla-import-adic-itens.cod-livre-2,23,22))) / 100000,8) WHEN NOT l-base-cofins-manual.
    IF decla-import-adic-itens.idi-tributac-pis = 1 AND 
       decla-import-adic-itens.val-aliq-pis     = 0 AND 
       decla-import-adic-itens.val-base-pis     = 0 THEN
        ASSIGN decla-import-adic-itens.val-base-pis    = round((dec(SUBSTRING(decla-import-adic-itens.cod-livre-2,45,22)) + dec(SUBSTRING(decla-import-adic-itens.cod-livre-2,67,22))) / 100000,8) WHEN NOT l-base-pis-manual.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculaValBases DBOProgram 
PROCEDURE calculaValBases :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR i-seq-erro             AS INTEGER NO-UNDO.
    DEF VAR l-primeiro-item        AS LOGICAL INITIAL YES NO-UNDO.
    DEF VAR de-valor-despesa-conv  LIKE despes-adic.val-despes NO-UNDO.
    DEF VAR p-base-ii-manual       AS LOGICAL NO-UNDO.
    DEF VAR p-base-ipi-manual      AS LOGICAL NO-UNDO.
    DEF VAR p-base-pis-manual      AS LOGICAL NO-UNDO.
    DEF VAR p-base-cofins-manual   AS LOGICAL NO-UNDO.
    DEF VAR p-base-icms-manual     AS LOGICAL NO-UNDO.

    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Calculando_as_bases" *}
    RUN pi-acompanhar IN h-acomp (INPUT RETURN-VALUE). /* altera a mensagem do acompanhamentos */
    
    ASSIGN d-val-liquido     = 0
           d-val-bruto       = 0
           d-val-base-ii     = 0 
           d-val-base-ipi    = 0 
           d-val-base-pis    = 0 
           d-val-base-cofins = 0 
           d-val-base-icms   = 0 
           d-val-embal       = 0.

    /* posiciona a natur-oper para ver se a despesa do frete incide na base do ipi */
    FOR FIRST decla-import-ord NO-LOCK
        WHERE decla-import-ord.num-di-ems  = decla-import-adic.num-di-ems
        AND   decla-import-ord.num-adic    = decla-import-adic.num-adic
        AND   decla-import-ord.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts:

        FIND FIRST natur-oper 
                WHERE natur-oper.nat-operacao = decla-import-ord.cod-natur-operac NO-LOCK NO-ERROR.
    END.
    /* fim - posiciona a natur-oper para ver se a despesa do frete incide na base do ipi */

    FOR EACH decla-import-adic-itens NO-LOCK
       WHERE decla-import-adic-itens.num-di-ems   = decla-import-adic.num-di-ems
       AND   decla-import-adic-itens.num-adic     = decla-import-adic.num-adic
       AND   decla-import-adic-itens.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts:
            
        find cotacao-item 
            where cotacao-item.numero-ordem = decla-import-adic-itens.num-ordem
              and cotacao-item.cod-emitente = decla-import-adic.cdn-fornec
              and cotacao-item.it-codigo    = decla-import-adic-itens.cod-item
              and cotacao-item.cot-aprovada NO-LOCK NO-ERROR.
        
        IF NOT AVAIL cotacao-item THEN DO:
            ASSIGN i-seq-erro = i-seq-erro + 1.
            {utp/ut-liter.i Cotaá∆o_Item * L}
            
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS"
                                        &ErrorParameters=return-value + '~~' + string(decla-import-adic-itens.num-ordem)}

            IF VALID-HANDLE(h-acomp) THEN
                RUN pi-finalizar IN h-acomp.

            RETURN "NOK":U.
        end.
        ELSE DO:       
            ASSIGN d-val-bruto-aux = ROUND((((cotacao-item.pre-unit-for * 100) / (100 + cotacao-item.aliquota-ipi)) + cotacao-item.valor-descto),5) * decla-import-adic-itens.qtd-adic[2].

            IF cotacao-item.mo-codigo <> 0 THEN
                    /*Convertendo da moeda negociada para Real*/
                    RUN converteValorMoeda (INPUT decla-import.num-di-ems,
                                            INPUT decla-import.cdd-siscomex-dts,
                                            INPUT cotacao-item.mo-codigo,
                                            INPUT 0,
                                            INPUT d-val-bruto-aux,
                                            INPUT decla-import.dat-di,
                                            OUTPUT d-val-bruto-cotac).
            ELSE 
                ASSIGN d-val-bruto-cotac = d-val-bruto-aux.

            ASSIGN d-val-liquido = d-val-liquido + decla-import-adic-itens.val-vmcv
                   d-val-bruto   = d-val-bruto   + d-val-bruto-cotac.


        END. /* else do */
    END. /* for each decla-import-adic-itens */
   
    FOR EACH despes-adic NO-LOCK
       WHERE despes-adic.num-di-ems = decla-import-adic.num-di-ems
         AND despes-adic.num-adic   = decla-import-adic.num-adic
         AND despes-adic.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts,
        FIRST desp-imp NO-LOCK
        WHERE desp-imp.cod-desp = despes-adic.cdn-despes
         AND   (desp-imp.inc-val-embal
                OR desp-imp.inc-val-frete
                OR desp-imp.inc-val-seguro
                OR desp-imp.inc-val-outras-desp):

        /* retira do valor liquido o valor da despesa que forma preco compra */
        IF despes-adic.log-forma-preco-compra THEN DO:
                ASSIGN de-valor-despesa-conv = 0.
        
                IF despes-adic.cdn-moeda <> 0 THEN
                    /*Convertendo da moeda negociada para Real*/
                    RUN converteValorMoeda (INPUT decla-import.num-di-ems,
                                            INPUT decla-import.cdd-siscomex-dts,
                                            INPUT despes-adic.cdn-moeda,
                                            INPUT 0,
                                            INPUT despes-adic.val-despes,
                                            INPUT decla-import.dat-di,
                                            OUTPUT de-valor-despesa-conv).
                ELSE 
                    ASSIGN de-valor-despesa-conv = despes-adic.val-despes.

                ASSIGN  d-val-liquido  = d-val-liquido  - de-valor-despesa-conv
                        d-val-bruto    = d-val-bruto    - de-valor-despesa-conv.
        END.
        /* retira do valor liquido o valor da despesa que forma preco compra */
         
        /* se for a despesa com codigo da despesa de imposto de importaá∆o, ignora e pula para o proximo */
        IF desp-imp.cod-desp = i-cod-desp-ii THEN
            NEXT.

        ASSIGN de-valor-despesa-conv = 0.

        IF despes-adic.cdn-moeda <> 0 THEN
            /*Convertendo da moeda negociada para Real*/
            RUN converteValorMoeda (INPUT decla-import.num-di-ems,
                                    INPUT decla-import.cdd-siscomex-dts,
                                    INPUT despes-adic.cdn-moeda,
                                    INPUT 0,
                                    INPUT despes-adic.val-despes,
                                    INPUT decla-import.dat-di,
                                    OUTPUT de-valor-despesa-conv).
        ELSE 
            ASSIGN de-valor-despesa-conv = despes-adic.val-despes.


       /* calcula base do II */
        IF desp-imp.log-2 THEN 
            ASSIGN d-val-base-ii = d-val-base-ii + de-valor-despesa-conv.
        /* fim - calcula base do II */

        /* calcula base do IPI */
        /* verifica se a despesa do frete incide na base do ipi */
        IF desp-imp.inc-val-frete THEN DO:
            IF SUBSTRING(natur-oper.char-2,6,5)='1' THEN DO:
                 ASSIGN d-val-base-ipi = d-val-base-ipi + de-valor-despesa-conv.
            END.
        END.
        ELSE DO:
            IF desp-imp.inc-base-ipi THEN
                ASSIGN d-val-base-ipi = d-val-base-ipi + de-valor-despesa-conv.
        END.
        /* fim - calcula base do IPI */

        /* calcula base do PIS */
        IF desp-imp.log-incid-base-pis-val OR desp-imp.log-incid-base-pis-despes THEN
            ASSIGN d-val-base-pis = d-val-base-pis + de-valor-despesa-conv.
        /* fim - calcula base do PIS */

        /* calcula base do COFINS */
        IF desp-imp.log-incid-base-cofins-val OR desp-imp.log-incid-base-cofins-despes THEN
            ASSIGN d-val-base-cofins = d-val-base-cofins + de-valor-despesa-conv.
        /* fim - calcula base do COFINS */

        /* calcula base do ICMS */
        IF desp-imp.inc-base-icms THEN
            ASSIGN d-val-base-icms      = d-val-base-icms      + de-valor-despesa-conv
                   d-base-icms-adic-aux = d-base-icms-adic-aux + round(de-valor-despesa-conv,2).
        /* fim - calcula base do ICMS */

        IF desp-imp.inc-val-embal THEN
            ASSIGN d-val-embal = d-val-embal + de-valor-despesa-conv.
    
    END. /* for each despes-adic */ 

    /* verificar se a base Ç gravada pelo valor liquido ou pelo valor bruto */
    ASSIGN  decla-import-adic.val-base-ii             = round(d-val-liquido + d-val-base-ii,8)     WHEN NOT l-base-ii-manual
            decla-import-adic.val-base-pis            = round(d-val-liquido + d-val-base-pis,8)    WHEN NOT l-base-pis-manual
            decla-import-adic.val-base-cofins         = round(d-val-liquido + d-val-base-cofins,8) WHEN NOT l-base-cofins-manual
            tt-verifica-impostos.val-base-ii-sist     = round(d-val-liquido + d-val-base-ii,8)    
            tt-verifica-impostos.val-base-pis-sist    = round(d-val-liquido + d-val-base-pis,8)   
            tt-verifica-impostos.val-base-cofins-sist = round(d-val-liquido + d-val-base-cofins,8).
    
    /* verifica se a base do ipi Ç pelo valor bruto (1) ou liquido (2) */
    IF SUBSTR(natur-oper.char-2,11,1) = "1" THEN
        ASSIGN decla-import-adic.val-base-ipi          = round(d-val-bruto   + d-val-base-ipi,8)  WHEN NOT l-base-ipi-manual
               tt-verifica-impostos.val-base-ipi-sist  = round(d-val-bruto   + d-val-base-ipi,8).
    ELSE
        ASSIGN decla-import-adic.val-base-ipi          = round(d-val-liquido + d-val-base-ipi,8)  WHEN NOT l-base-ipi-manual  
               tt-verifica-impostos.val-base-ipi-sist  = round(d-val-liquido + d-val-base-ipi,8) .


    /* verifica se a base do icms Ç pelo valor bruto (1) ou liquido (2) */
    IF natur-oper.merc-base-icms = 1 THEN
        ASSIGN decla-import-adic.val-base-icms         = round(d-val-bruto   + d-val-base-icms,8)      WHEN NOT l-base-icms-manual
               d-base-icms-adic-aux                    = round(d-val-bruto   + d-base-icms-adic-aux,2) WHEN NOT l-base-icms-manual
               tt-verifica-impostos.val-base-icms-sist = round(d-val-bruto   + d-val-base-icms,8).
    ELSE
        ASSIGN decla-import-adic.val-base-icms         = round(d-val-liquido + d-val-base-icms,8)      WHEN NOT l-base-icms-manual
               d-base-icms-adic-aux                    = round(d-val-liquido + d-base-icms-adic-aux,2) WHEN NOT l-base-icms-manual
               tt-verifica-impostos.val-base-icms-sist = round(d-val-liquido + d-val-base-icms,8).


    /* atualiza a base informada na adiá∆o na tt de conferencia */
    UPDATE tt-verifica-impostos.val-base-ii-inf      = decla-import-adic.val-base-ii    
           tt-verifica-impostos.val-base-ipi-inf     = decla-import-adic.val-base-ipi   
           tt-verifica-impostos.val-base-pis-inf     = decla-import-adic.val-base-pis   
           tt-verifica-impostos.val-base-cofins-inf  = decla-import-adic.val-base-cofins
           tt-verifica-impostos.val-base-icms-inf    = decla-import-adic.val-base-icms. 

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculaValBasesItem DBOProgram 
PROCEDURE calculaValBasesItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR i-seq-erro             AS INTEGER NO-UNDO.
    DEF VAR l-primeiro-item        AS LOGICAL INITIAL YES NO-UNDO.
    DEF VAR de-valor-despesa-conv  LIKE despes-adic.val-despes NO-UNDO.
    DEF VAR p-base-ii-manual       AS LOGICAL NO-UNDO.
    DEF VAR p-base-ipi-manual      AS LOGICAL NO-UNDO.
    DEF VAR p-base-pis-manual      AS LOGICAL NO-UNDO.
    DEF VAR p-base-cofins-manual   AS LOGICAL NO-UNDO.
    DEF VAR p-base-icms-manual     AS LOGICAL NO-UNDO.

    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Calculando_as_bases_Itens" *}
    RUN pi-acompanhar IN h-acomp (INPUT RETURN-VALUE). /* altera a mensagem do acompanhamentos */
    
    FOR FIRST decla-import NO-LOCK
        WHERE decla-import.num-di-ems      = decla-import-adic-itens.num-di-ems
          AND decla-import.cdd-siscomex-dts = decla-import-adic-itens.cdd-siscomex-dts,
        FIRST decla-import-adic NO-LOCK
        WHERE decla-import-adic.num-di-ems = decla-import-adic-itens.num-di-ems
        AND   decla-import-adic.num-adic   = decla-import-adic-itens.num-adic 
        AND   decla-import-adic.cdd-siscomex-dts = decla-import-adic-itens.cdd-siscomex-dts: END.

    ASSIGN d-val-liquido     = 0
           d-val-bruto       = 0
           d-val-base-ii     = 0 
           d-val-base-ipi    = 0 
           d-val-base-pis    = 0 
           d-val-base-cofins = 0 
           d-val-base-icms   = 0 
           d-val-embal       = 0.

    /* posiciona a natur-oper para ver se a despesa do frete incide na base do ipi */
    FOR FIRST decla-import-ord NO-LOCK
        WHERE decla-import-ord.num-di-ems  = decla-import-adic-itens.num-di-ems
        AND   decla-import-ord.num-adic    = decla-import-adic-itens.num-adic
        AND   decla-import-ord.num-ordem   = decla-import-adic-itens.num-ordem
        AND   decla-import-ord.num-parcela = decla-import-adic-itens.num-parcela
        AND   decla-import-ord.cdd-siscomex-dts = decla-import-adic-itens.cdd-siscomex-dts:

        FIND FIRST natur-oper NO-LOCK
                WHERE natur-oper.nat-operacao = decla-import-ord.cod-natur-operac NO-ERROR.
    END.
    /* fim - posiciona a natur-oper para ver se a despesa do frete incide na base do ipi */


    FIND FIRST cotacao-item 
         WHERE cotacao-item.numero-ordem = decla-import-adic-itens.num-ordem
           AND cotacao-item.cod-emitente = decla-import-adic.cdn-fornec
           AND cotacao-item.it-codigo    = decla-import-adic-itens.cod-item
           AND cotacao-item.cot-aprovada NO-LOCK NO-ERROR.
    
    IF NOT AVAIL cotacao-item THEN DO:
        ASSIGN i-seq-erro = i-seq-erro + 1.
        {utp/ut-liter.i Cotaá∆o_Item * L}
        
        {method/svc/errors/inserr.i
              &ErrorNumber="2"
              &ErrorType="EMS"
              &ErrorParameters=return-value + '~~' + string(decla-import-adic-itens.num-ordem)}

        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-finalizar IN h-acomp.

        RETURN "NOK":U.
    end.
    ELSE DO:       
        ASSIGN d-val-bruto-aux = ROUND((((cotacao-item.pre-unit-for * 100) / (100 + cotacao-item.aliquota-ipi)) + cotacao-item.valor-descto),5) * decla-import-adic-itens.qtd-adic[2].

        IF cotacao-item.mo-codigo <> 0 THEN
                /*Convertendo da moeda negociada para Real*/
                RUN converteValorMoeda (INPUT decla-import.num-di-ems,
                                        INPUT decla-import.cdd-siscomex-dts,
                                        INPUT cotacao-item.mo-codigo,
                                        INPUT 0,
                                        INPUT d-val-bruto-aux,
                                        INPUT decla-import.dat-di,
                                        OUTPUT d-val-bruto-cotac).
        ELSE 
            ASSIGN d-val-bruto-cotac = d-val-bruto-aux.

        ASSIGN d-val-liquido = d-val-liquido + decla-import-adic-itens.val-vmcv
               d-val-bruto   = d-val-bruto   + d-val-bruto-cotac.

    END. /* else do */
   
    FOR EACH despes-adic-itens NO-LOCK
              WHERE despes-adic-itens.num-di-ems = decla-import-adic-itens.num-di-ems
              AND   despes-adic-itens.num-adic   = decla-import-adic-itens.num-adic
              AND   despes-adic-itens.num-seq    = decla-import-adic-itens.num-seq
              AND   despes-adic-itens.cdd-siscomex-dts = decla-import-adic-itens.cdd-siscomex-dts,
                  FIRST desp-imp NO-LOCK
                        WHERE desp-imp.cod-desp = despes-adic-itens.cdn-despes
                        AND   (desp-imp.inc-val-embal
                               OR desp-imp.inc-val-frete
                               OR desp-imp.inc-val-seguro
                               OR desp-imp.inc-val-outras-desp):

        /* retira do valor liquido o valor da despesa que forma preco compra */
        IF despes-adic-itens.log-forma-preco-compra THEN DO:
                ASSIGN de-valor-despesa-conv = 0.
        
                IF despes-adic-itens.cdn-moeda <> 0 THEN
                    /*Convertendo da moeda negociada para Real*/
                    RUN converteValorMoeda (INPUT decla-import.num-di-ems,
                                            INPUT decla-import.cdd-siscomex-dts,
                                            INPUT despes-adic-itens.cdn-moeda,
                                            INPUT 0,
                                            INPUT despes-adic-itens.val-despes,
                                            INPUT decla-import.dat-di,
                                            OUTPUT de-valor-despesa-conv).
                ELSE 
                    ASSIGN de-valor-despesa-conv = despes-adic-itens.val-despes.

                ASSIGN  d-val-liquido  = d-val-liquido  - de-valor-despesa-conv
                        d-val-bruto    = d-val-bruto    - de-valor-despesa-conv.
        END.
        /* retira do valor liquido o valor da despesa que forma preco compra */
         
        /* se for a despesa com codigo 1 (imposto de importaá∆o, ignora e pula para o proximo */
        IF desp-imp.cod-desp = i-cod-desp-ii THEN
            NEXT.

        ASSIGN de-valor-despesa-conv = 0.

        IF despes-adic-itens.cdn-moeda <> 0 THEN
            /*Convertendo da moeda negociada para Real*/
            RUN converteValorMoeda (INPUT decla-import.num-di-ems,
                                    INPUT decla-import.cdd-siscomex-dts,
                                    INPUT despes-adic-itens.cdn-moeda,
                                    INPUT 0,
                                    INPUT despes-adic-itens.val-despes,
                                    INPUT decla-import.dat-di,
                                    OUTPUT de-valor-despesa-conv).
        ELSE 
            ASSIGN de-valor-despesa-conv = despes-adic-itens.val-despes.


       /* calcula base do II */
        IF desp-imp.log-2 THEN 
            ASSIGN d-val-base-ii = d-val-base-ii + de-valor-despesa-conv.
        /* fim - calcula base do II */

        /* calcula base do IPI */
        /* verifica se a despesa do frete incide na base do ipi */
        IF desp-imp.inc-val-frete THEN DO:
            IF SUBSTRING(natur-oper.char-2,6,5)='1' THEN DO:
                 ASSIGN d-val-base-ipi = d-val-base-ipi + de-valor-despesa-conv.
            END.
        END.
        ELSE DO:
            IF desp-imp.inc-base-ipi THEN
                ASSIGN d-val-base-ipi = d-val-base-ipi + de-valor-despesa-conv.
        END.
        /* fim - calcula base do IPI */

        /* calcula base do PIS */
        IF desp-imp.log-incid-base-pis-val OR desp-imp.log-incid-base-pis-despes THEN
            ASSIGN d-val-base-pis = d-val-base-pis + de-valor-despesa-conv.
        /* fim - calcula base do PIS */

        /* calcula base do COFINS */
        IF desp-imp.log-incid-base-cofins-val OR desp-imp.log-incid-base-cofins-despes THEN
            ASSIGN d-val-base-cofins = d-val-base-cofins + de-valor-despesa-conv.
        /* fim - calcula base do COFINS */

        /* calcula base do ICMS */
        IF desp-imp.inc-base-icms THEN
            ASSIGN d-val-base-icms       = d-val-base-icms       + de-valor-despesa-conv
                   d-base-icms-itens-aux = d-base-icms-itens-aux + round(de-valor-despesa-conv,2).
        /* fim - calcula base do ICMS */

        IF desp-imp.inc-val-embal THEN
            ASSIGN d-val-embal = d-val-embal + de-valor-despesa-conv.
    
    END. /* for each despes-adic */ 

    /* verificar se a base Ç gravada pelo valor liquido ou pelo valor bruto */
    ASSIGN  decla-import-adic-itens.val-base-ii             = round(d-val-liquido + d-val-base-ii,8)     WHEN NOT l-base-ii-manual
            decla-import-adic-itens.val-base-pis            = round(d-val-liquido + d-val-base-pis,8)    WHEN NOT l-base-pis-manual
            decla-import-adic-itens.val-base-cofins         = round(d-val-liquido + d-val-base-cofins,8) WHEN NOT l-base-cofins-manual.
    
    IF decla-import-adic-itens.val-base-pis = ? THEN
        ASSIGN decla-import-adic-itens.val-base-pis = 0.

    IF decla-import-adic-itens.val-base-cofins = ? THEN
        ASSIGN decla-import-adic-itens.val-base-cofins = 0.
    
    /* verifica se a base do ipi Ç pelo valor bruto (1) ou liquido (2) */
    IF SUBSTR(natur-oper.char-2,11,1) = "1" THEN
        ASSIGN decla-import-adic-itens.val-base-ipi          = round(d-val-bruto   + d-val-base-ipi,8)  WHEN NOT l-base-ipi-manual.
    ELSE
        ASSIGN decla-import-adic-itens.val-base-ipi          = round(d-val-liquido + d-val-base-ipi,8)  WHEN NOT l-base-ipi-manual  .

    /* verifica se a base do icms Ç pelo valor bruto (1) ou liquido (2) */
    IF natur-oper.merc-base-icms = 1 THEN
        ASSIGN decla-import-adic-itens.val-base-icms         = round(d-val-bruto   + d-val-base-icms,8)       WHEN NOT l-base-icms-manual
               d-base-icms-itens-aux                         = round(d-val-bruto   + d-base-icms-itens-aux,2) WHEN NOT l-base-icms-manual.
    ELSE
        ASSIGN decla-import-adic-itens.val-base-icms         = round(d-val-liquido + d-val-base-icms,8)       WHEN NOT l-base-icms-manual
               d-base-icms-itens-aux                         = round(d-val-liquido + d-base-icms-itens-aux,2) WHEN NOT l-base-icms-manual.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculaValorRateio DBOProgram 
PROCEDURE calculaValorRateio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM pCodDesp       LIKE desp-imp.cod-desp              NO-UNDO.
    DEF INPUT PARAM p-val-merc     LIKE decla-import.val-vmle          NO-UNDO.
    DEF INPUT PARAM p-peso         LIKE decla-import-adic.val-peso-liq NO-UNDO.
    DEF INPUT PARAM p-qtd          LIKE decla-import-ord.qtd-item      NO-UNDO.
    DEF INPUT PARAM p-val-desp     LIKE despes-decla-import.val-despes NO-UNDO.
    DEF INPUT PARAM p-val-merc-tot LIKE decla-import.val-vmle          NO-UNDO.
    DEF INPUT PARAM p-peso-total   LIKE decla-import-adic.val-peso-liq NO-UNDO.
    DEF INPUT PARAM p-qtd-total    LIKE decla-import-ord.qtd-item      NO-UNDO.
    DEF OUTPUT PARAM p-val-rateio  LIKE despes-decla-import.val-despes NO-UNDO.

    FOR FIRST desp-imp NO-LOCK
        WHERE desp-imp.cod-desp = pCodDesp : END.

    /* Rateio */
    CASE desp-imp.tipo:
        /* Valor Fixo */
        WHEN 1 THEN DO:
            ASSIGN p-val-rateio       = (p-val-merc * p-val-desp)
                                       / p-val-merc-tot.
        END.
        /* Peso */
        WHEN 3 THEN DO:
            ASSIGN p-val-rateio    = (p-peso * p-val-desp)
                                    / p-peso-total.
        END.
        /* Quantidade */
        WHEN 6 THEN DO:
            ASSIGN p-val-rateio    = (p-qtd * p-val-desp)
                                    / p-qtd-total.
        END.
        /* Cubagem */ 
        WHEN 9 THEN DO:
            ASSIGN p-val-rateio    = (p-peso * p-val-desp)
                                    / p-peso-total.
        END.
        /* Valor */
        OTHERWISE DO:
            ASSIGN p-val-rateio    = (p-val-merc * p-val-desp)
                                    / p-val-merc-tot.
        END.
    END CASE.
    IF p-val-rateio = ? THEN ASSIGN p-val-rateio = 0.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculaValorRateioImp DBOProgram 
PROCEDURE calculaValorRateioImp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM  p-val-imp        LIKE despes-adic.val-desp             NO-UNDO.
    DEF INPUT PARAM  p-val-merc-item  LIKE decla-import-adic-itens.val-vmle NO-UNDO.
    DEF INPUT PARAM  p-val-merc-adic  LIKE decla-import-adic.val-vmle       NO-UNDO.
    DEF OUTPUT PARAM p-val-rateio-imp LIKE decla-import.val-vmle            NO-UNDO.

    IF p-val-merc-adic = 0 THEN
        RETURN "OK":U.

    ASSIGN p-val-rateio-imp = (p-val-merc-item * p-val-imp) / p-val-merc-adic.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE converteValorMoeda DBOProgram 
PROCEDURE converteValorMoeda :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM p-num-di-ems    LIKE decla-import-ord.num-di-ems    NO-UNDO.
    DEF INPUT  PARAM p-cdd-siscomex-dts LIKE decla-import-ord.cdd-siscomex-dts NO-UNDO.
    DEF INPUT  PARAM p-moeda-origem  LIKE despes-decla-import.cdn-moeda  NO-UNDO.
    DEF INPUT  PARAM p-moeda-destino LIKE despes-decla-import.cdn-moeda  NO-UNDO.
    DEF INPUT  PARAM p-valorConverte LIKE despes-decla-import.val-despes NO-UNDO.
    DEF INPUT  PARAM p-data          LIKE decla-import.dat-di            NO-UNDO.
    DEF OUTPUT PARAM p-valor         LIKE despes-decla-import.val-despes NO-UNDO.

    IF p-valorConverte <> ? AND 
        p-valorConverte <> 0 THEN DO:
        IF CAN-FIND(FIRST decla-import-cotac
                    WHERE decla-import-cotac.num-di-ems = p-num-di-ems
                    AND   decla-import-cotac.cdd-siscomex-dts = p-cdd-siscomex-dts
                    AND   decla-import-cotac.val-cotac  > 0) THEN DO:    
            IF CAN-FIND(FIRST decla-import-cotac
                        WHERE decla-import-cotac.num-di-ems = p-num-di-ems
                        AND   decla-import-cotac.cdn-moeda  = p-moeda-origem
                        AND   decla-import-cotac.cdd-siscomex-dts  = p-cdd-siscomex-dts
                        AND   decla-import-cotac.val-cotac  > 0) THEN DO:

                IF CAN-FIND(FIRST decla-import-cotac
                            WHERE decla-import-cotac.num-di-ems = p-num-di-ems
                            AND   decla-import-cotac.cdn-moeda  = p-moeda-destino
                            AND   decla-import-cotac.cdd-siscomex-dts = p-cdd-siscomex-dts
                            AND   decla-import-cotac.val-cotac  > 0) THEN DO:
                    RUN imp/im0400h.p (INPUT p-num-di-ems,
                                       INPUT p-cdd-siscomex-dts, 
                                       INPUT p-moeda-origem,
                                       INPUT p-moeda-destino,
                                       INPUT p-valorConverte,
                                       INPUT p-data,
                                       OUTPUT p-valor).
                END.
                ELSE DO:
                    RUN cdp/cd0812.p (INPUT p-moeda-origem,
                                      INPUT p-moeda-destino,
                                      INPUT p-valorConverte,
                                      INPUT p-data,
                                      OUTPUT p-valor).
                END.
            END.                   
            ELSE DO:
                RUN cdp/cd0812.p (INPUT p-moeda-origem,
                                  INPUT p-moeda-destino,
                                  INPUT p-valorConverte,
                                  INPUT p-data,
                                  OUTPUT p-valor).
            END.
        END.
        ELSE DO:
            RUN cdp/cd0812.p (INPUT p-moeda-origem,
                              INPUT p-moeda-destino,
                              INPUT p-valorConverte,
                              INPUT p-data,
                              OUTPUT p-valor).
        END.                    
    
        IF p-valor = ? THEN DO:
            IF p-moeda-origem = 0 THEN
                {method/svc/errors/inserr.i
                      &ErrorNumber="1847"
                      &ErrorType="EMS"
                      &ErrorParameters="string(p-moeda-destino) + '~~~~' + STRING(p-data)"}            
            ELSE
                {method/svc/errors/inserr.i
                      &ErrorNumber="1847"
                      &ErrorType="EMS"
                      &ErrorParameters="string(p-moeda-origem) + '~~~~' + STRING(p-data)"}            

            ASSIGN p-valor = 0.
        END.
    END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createtbwtdocto DBOProgram 
PROCEDURE createtbwtdocto :

    DEF VAR d-valor-merc-liq    LIKE decla-import-adic.val-vmle NO-UNDO.

    IF NOT CAN-FIND(FIRST tb-wt-docto 
                    WHERE tb-wt-docto.seq-wt-docto = 1) THEN DO:

        CREATE tb-wt-docto.
        ASSIGN tb-wt-docto.seq-wt-docto = 1
               tb-wt-docto.cod-emitente = decla-import-adic.cdn-fornec
               tb-wt-docto.nr-nota      = decla-import-ord.cod-embarq
               tb-wt-docto.serie        = "":U
               tb-wt-docto.nat-operacao = decla-import-ord.cod-natur-operac WHEN AVAIL decla-import-ord
               tb-wt-docto.cod-des-merc = IF natur-oper.consum-final THEN 2 ELSE 1
               tb-wt-docto.cod-estabel  = decla-import.cod-estab
               tb-wt-docto.dt-emis-nota = TODAY
               tb-wt-docto.esp-docto    = 21
               tb-wt-docto.ind-tip-nota = 8
               tb-wt-docto.mo-codigo    = decla-import-adic.cdn-moeda
               tb-wt-docto.nome-abrev   = emitente.nome-abrev
               tb-wt-docto.vl-embalagem = 0
               tb-wt-docto.vl-frete     = 0
               tb-wt-docto.vl-mercad    = d-valor-merc-liq
               tb-wt-docto.nr-prog      = 176 /* para indicar no bodi317im1br.i1 que a boin176 que chamou */
               tb-wt-docto.vl-seguro    = 0
               tb-wt-docto.cidade       = estabelec.cidade
               tb-wt-docto.estado       = estabelec.estado
               tb-wt-docto.pais         = estabelec.pais
               c-embarque               = decla-import-ord.cod-embarq.
    END.
        
    IF NOT CAN-FIND(FIRST tb-wt-it-docto 
                    WHERE tb-wt-it-docto.seq-wt-docto    = 1
                      AND tb-wt-it-docto.seq-wt-it-docto = i-seq-item-aux) THEN DO:
        
        CREATE tb-wt-it-docto.
        ASSIGN tb-wt-it-docto.seq-wt-docto        = 1
               tb-wt-it-docto.seq-wt-it-docto     = i-seq-item-aux
               tb-wt-it-docto.calcula             = YES
               tb-wt-it-docto.it-codigo           = item.it-codigo when avail item
               tb-wt-it-docto.nat-operacao        = decla-import-ord.cod-natur-operac WHEN AVAIL decla-import-ord
               tb-wt-it-docto.nr-sequencia        = i-seq-item-aux
               tb-wt-it-docto.nr-seq-nota         = 1
               tb-wt-it-docto.quantidade[1]       = decla-import-adic-itens.qtd-adic[1]                       /* quantidade na unidade do item */
               tb-wt-it-docto.vl-merc-ori         = decla-import-adic-itens.val-vmcv                          /* preco total da adicao */
               tb-wt-it-docto.vl-merc-liq         = decla-import-adic-itens.val-vmcv                          /* preco liquido da adicao */
               tb-wt-it-docto.vl-despes-it        = 0                                                         /* valor acrescimos da adicao */
               tb-wt-it-docto.vl-frete            = 0                                                         /* valor frete da adicao */
               tb-wt-it-docto.vl-seguro           = 0                                                         /* valor seguro da adicao */
               tb-wt-it-docto.vl-preori           = decla-import-adic-itens.val-vmcv / tb-wt-it-docto.quantidade[1] /* valor mercadoria / tb-wt-it-docto.quantidade[1] */
               tb-wt-it-docto.vl-preuni           = d-valor-merc-liq / tb-wt-it-docto.quantidade[1]           /* valor liquido da mercadoria / tb-wt-it-docto.quantidade[1] */
               tb-wt-it-docto.vl-merc-s-icms      = d-valor-merc-liq                                          /* valor liquido da mercadoria */
               tb-wt-it-docto.vl-merc-tab         = d-valor-merc-liq                                          /* valor liquido mercadoria */
               tb-wt-it-docto.numero-ordem        = decla-import-adic-itens.num-ordem
               tb-wt-it-docto.parcela             = decla-import-adic-itens.num-parcela
               OVERLAY(tb-wt-it-docto.char-1,1,6) = "IM7777":U.                                               /*integracao com o modulo de importaá∆o*/
    END.

    IF NOT CAN-FIND(FIRST tb-wt-it-imposto 
                        WHERE tb-wt-it-imposto.seq-wt-docto = 1
                        AND   tb-wt-it-imposto.seq-wt-it-docto = i-seq-item-aux) THEN DO:
        CREATE tb-wt-it-imposto.
        ASSIGN tb-wt-it-imposto.seq-wt-docto    = 1
               tb-wt-it-imposto.seq-wt-it-docto = i-seq-item-aux
               tb-wt-it-imposto.perc-red-icm    = decla-import-adic.val-perc-reduc-icms /*gravar todas essas informaá‰es da adiá∆o */
               tb-wt-it-imposto.perc-red-ipi    = decla-import-adic.val-perc-reduc-ipi
               tb-wt-it-imposto.perc-red-iss    = 0
               tb-wt-it-imposto.aliquota-ipi    = decla-import-adic.val-aliq-ipi
               tb-wt-it-imposto.aliquota-icm    = decla-import-adic.val-aliq-icms
               tb-wt-it-imposto.aliquota-iss    = 0
               tb-wt-it-imposto.cd-trib-ipi     = decla-import-adic.idi-tributac-ipi
               tb-wt-it-imposto.cd-trib-icm     = decla-import-adic.idi-tributac-icms
               tb-wt-it-imposto.cd-trib-iss     = 0
               tb-wt-it-imposto.ind-icm-ret     = NO.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createTempTableImpostosCBSIBS DBOProgram 
PROCEDURE createTempTableImpostosCBSIBS:

    FIND tb-wt-it-impostoCBSIBS EXCLUSIVE-LOCK 
        WHERE tb-wt-it-impostoCBSIBS.seq-wt-docto    = 1
          AND tb-wt-it-impostoCBSIBS.seq-wt-it-docto = i-seq-item NO-ERROR.
    IF NOT AVAIL tb-wt-it-impostoCBSIBS THEN DO:
        CREATE tb-wt-it-impostoCBSIBS.
        ASSIGN tb-wt-it-impostoCBSIBS.seq-wt-docto    = 1
               tb-wt-it-impostoCBSIBS.seq-wt-it-docto = i-seq-item.
    END.
    
    RUN getValAtribImportTribut (INPUT "CBS":U, INPUT "ALIQUOTA",   OUTPUT tb-wt-it-impostoCBSIBS.aliquota-cbs).
    RUN getValAtribImportTribut (INPUT "CBS":U, INPUT "ALIQ-RED",   OUTPUT tb-wt-it-impostoCBSIBS.perc-red-cbs).
    RUN getValAtribImportTribut (INPUT "CBS":U, INPUT "PERC-DIFER", OUTPUT tb-wt-it-impostoCBSIBS.perc-difer-cbs).
    
    IF tb-wt-it-impostoCBSIBS.aliquota-cbs = 0 THEN DO:
        RUN getValAtribImportTribut (INPUT "CBS":U, INPUT "ALIQ-EFETIVA-REG", OUTPUT tb-wt-it-impostoCBSIBS.aliquota-cbs). 
    END.
    
    RUN getValAtribImportTribut (INPUT "IBSUF":U, INPUT "ALIQUOTA",   OUTPUT tb-wt-it-impostoCBSIBS.aliquota-ibsuf).     
    RUN getValAtribImportTribut (INPUT "IBSUF":U, INPUT "ALIQ-RED",   OUTPUT tb-wt-it-impostoCBSIBS.perc-red-ibsuf).
    RUN getValAtribImportTribut (INPUT "IBSUF":U, INPUT "PERC-DIFER", OUTPUT tb-wt-it-impostoCBSIBS.perc-difer-ibsuf).

    IF tb-wt-it-impostoCBSIBS.aliquota-ibsuf = 0 THEN DO:
        RUN getValAtribImportTribut (INPUT "IBSUF":U, INPUT "ALIQ-EFETIVA-REG", OUTPUT tb-wt-it-impostoCBSIBS.aliquota-ibsuf). 
    END.

    RUN getValAtribImportTribut (INPUT "IBSMUN":U, INPUT "ALIQUOTA",   OUTPUT tb-wt-it-impostoCBSIBS.aliquota-ibsmun).     
    RUN getValAtribImportTribut (INPUT "IBSMUN":U, INPUT "ALIQ-RED",   OUTPUT tb-wt-it-impostoCBSIBS.perc-red-ibsmun).
    RUN getValAtribImportTribut (INPUT "IBSMUN":U, INPUT "PERC-DIFER", OUTPUT tb-wt-it-impostoCBSIBS.perc-difer-ibsmun).

    IF tb-wt-it-impostoCBSIBS.aliquota-ibsmun = 0 THEN DO:
        RUN getValAtribImportTribut (INPUT "IBSMUN":U, INPUT "ALIQ-EFETIVA-REG", OUTPUT tb-wt-it-impostoCBSIBS.aliquota-ibsmun). 
    END.
    
    RUN getValAtribImportTribut (INPUT "IS":U, INPUT "ALIQUOTA",      OUTPUT tb-wt-it-impostoCBSIBS.aliquota-is).
    RUN getValAtribImportTribut (INPUT "IS":U, INPUT "ALIQ-ESPEC-UN", OUTPUT tb-wt-it-impostoCBSIBS.aliq-espec-is).
    RUN getValAtribImportTribut (INPUT "IS":U, INPUT "QTDE-TRIBUT",   OUTPUT tb-wt-it-impostoCBSIBS.qtde-tribut-is).
    
    RETURN "OK":U.        
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getValAtribImportTribut DBOProgram 
PROCEDURE getValAtribImportTribut :
/*------------------------------------------------------------------------------
  Purpose:   
  Parameters:
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAM pImposto    AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAM pAtributo   AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAM pValorAtrib AS DECIMAL   NO-UNDO.

    FIND FIRST tt-decla-imp-adic-it-trib NO-LOCK
         WHERE tt-decla-imp-adic-it-trib.num-di-ems        = decla-import-adic-itens.num-di-ems
           AND tt-decla-imp-adic-it-trib.num-adic          = decla-import-adic-itens.num-adic
           AND tt-decla-imp-adic-it-trib.num-seq           = decla-import-adic-itens.num-seq
           AND tt-decla-imp-adic-it-trib.cdd-siscomex-dts  = decla-import-adic-itens.cdd-siscomex-dts
           AND tt-decla-imp-adic-it-trib.nom-trib          = pImposto
           AND tt-decla-imp-adic-it-trib.cod-campo         = pAtributo NO-ERROR.   
    IF AVAIL tt-decla-imp-adic-it-trib THEN
       ASSIGN pValorAtrib = dec(tt-decla-imp-adic-it-trib.cod-conteudo). 
    ELSE DO:
        FIND FIRST decla-imp-adic-it-trib NO-LOCK
             WHERE decla-imp-adic-it-trib.num-di-ems        = decla-import-adic-itens.num-di-ems
               AND decla-imp-adic-it-trib.num-adic          = decla-import-adic-itens.num-adic
               AND decla-imp-adic-it-trib.num-seq           = decla-import-adic-itens.num-seq
               AND decla-imp-adic-it-trib.cdd-siscomex-dts  = decla-import-adic-itens.cdd-siscomex-dts
               AND decla-imp-adic-it-trib.nom-trib          = pImposto
               AND decla-imp-adic-it-trib.cod-campo         = pAtributo NO-ERROR.   
        IF AVAIL decla-imp-adic-it-trib THEN
           ASSIGN pValorAtrib = dec(decla-imp-adic-it-trib.cod-conteudo).
    END.
    

RETURN "OK":U.        
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaTotaisDespesasIncotermPorAdicao DBOProgram 
PROCEDURE criaTotaisDespesasIncotermPorAdicao :
/*------------------------------------------------------------------------------
  Purpose:   Cria os totais das despesas da incoterm por adiá∆o  
  Parameters:  pcod-incoterm - C¢digo da incoterm - caracter
               pnum-adic     - N£mero da Adiá∆o   - numÇrico
               pval-desp     - Valor da despesa   - Decimal
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pcod-incoterm LIKE tt-desp-totais-incoterm.cod-incoterm NO-UNDO.
    DEFINE INPUT PARAM pnum-adic     LIKE tt-desp-rateio.num-adic              NO-UNDO.
    DEFINE INPUT PARAM pval-desp     LIKE tt-desp-rateio.val-desp              NO-UNDO.
    
    FIND FIRST tt-desp-totais-incoterm-adic EXCLUSIVE-LOCK
         WHERE tt-desp-totais-incoterm-adic.cod-incoterm = pcod-incoterm
           AND tt-desp-totais-incoterm-adic.num-adic     = pnum-adic NO-ERROR.
    IF NOT AVAIL tt-desp-totais-incoterm-adic THEN DO:
       CREATE tt-desp-totais-incoterm-adic.
       ASSIGN tt-desp-totais-incoterm-adic.cod-incoterm = pcod-incoterm
              tt-desp-totais-incoterm-adic.num-adic     = pnum-adic.
    END.
    ASSIGN tt-desp-totais-incoterm-adic.val-incoterm = tt-desp-totais-incoterm-adic.val-incoterm + pval-desp.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaTTdeclaItemTribut DBOProgram 
PROCEDURE criaTTdeclaItemTribut :
/*------------------------------------------------------------------------------
  Purpose:     Realiza a criaá∆o/atualizaá∆o dos dados retornados pelo configurador na tt-decla-imp-adic-it-trib
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pNomTribut AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER pCodCampo  AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER pconteudo  AS CHARACTER   NO-UNDO.

    FIND FIRST tt-decla-imp-adic-it-trib
         WHERE tt-decla-imp-adic-it-trib.num-di-ems       = decla-import-adic-itens.num-di-ems
         AND   tt-decla-imp-adic-it-trib.num-adic         = decla-import-adic-itens.num-adic
         AND   tt-decla-imp-adic-it-trib.num-seq          = decla-import-adic-itens.num-seq
         AND   tt-decla-imp-adic-it-trib.cdd-siscomex-dts = decla-import-adic-itens.cdd-siscomex-dts
         AND   tt-decla-imp-adic-it-trib.nom-trib         = pNomTribut               
         AND   tt-decla-imp-adic-it-trib.cod-campo        = pCodCampo  NO-ERROR.
    IF NOT AVAIL tt-decla-imp-adic-it-trib THEN DO:
       CREATE tt-decla-imp-adic-it-trib.
       ASSIGN tt-decla-imp-adic-it-trib.num-di-ems       = decla-import-adic-itens.num-di-ems
              tt-decla-imp-adic-it-trib.num-adic         = decla-import-adic-itens.num-adic
              tt-decla-imp-adic-it-trib.num-seq          = decla-import-adic-itens.num-seq
              tt-decla-imp-adic-it-trib.cdd-siscomex-dts = decla-import-adic-itens.cdd-siscomex-dts
              tt-decla-imp-adic-it-trib.nom-trib         = pNomTribut
              tt-decla-imp-adic-it-trib.cod-campo        = pCodCampo.
    END.
    
    ASSIGN tt-decla-imp-adic-it-trib.cod-conteudo  = pconteudo.
    
    RUN openQueryStatic IN h-bocx00512 (INPUT 'Main':U).
    RUN emptyRowErrors  IN h-bocx00512.
    RUN emptyRowObject  IN h-bocx00512.
    RUN goToKey         IN h-bocx00512 (INPUT tt-decla-imp-adic-it-trib.num-di-ems,
                                        INPUT tt-decla-imp-adic-it-trib.num-adic,
                                        INPUT tt-decla-imp-adic-it-trib.num-seq,
                                        INPUT tt-decla-imp-adic-it-trib.cdd-siscomex-dts,
                                        input tt-decla-imp-adic-it-trib.nom-trib,
                                        input tt-decla-imp-adic-it-trib.cod-campo).
    IF RETURN-VALUE = "NOK":U THEN DO:
        RUN setRecord       IN h-bocx00512 (INPUT TABLE tt-decla-imp-adic-it-trib).
        RUN createRecord    IN h-bocx00512.
    END.
    ELSE DO:
        RUN setRecord       IN h-bocx00512 (INPUT TABLE tt-decla-imp-adic-it-trib).
        RUN updateRecord    IN h-bocx00512.
    END.    
    
    delete tt-decla-imp-adic-it-trib.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaTTdeclaAdicTribut  DBOProgram 
PROCEDURE criaTTdeclaAdicTribut :
/*------------------------------------------------------------------------------
  Purpose:     Realiza a criaá∆o/atualizaá∆o dos dados retornados pelo configurador na tt-decla-imp-adic-it-trib
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pNomTribut AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER pCodCampo  AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER pconteudo  AS CHARACTER   NO-UNDO.

    FIND FIRST tt-decla-import-adic-trib 
         WHERE tt-decla-import-adic-trib.num-di-ems       = decla-import-adic.num-di-ems
         AND   tt-decla-import-adic-trib.num-adic         = decla-import-adic.num-adic
         AND   tt-decla-import-adic-trib.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts
         AND   tt-decla-import-adic-trib.nom-trib         = pNomTribut
         AND   tt-decla-import-adic-trib.cod-campo        = pCodCampo NO-ERROR.
    IF NOT AVAIL tt-decla-import-adic-trib THEN DO:
        CREATE tt-decla-import-adic-trib.
        ASSIGN tt-decla-import-adic-trib.num-di-ems          = decla-import-adic.num-di-ems
               tt-decla-import-adic-trib.num-adic            = decla-import-adic.num-adic                   
               tt-decla-import-adic-trib.cdd-siscomex-dts    = decla-import-adic.cdd-siscomex-dts           
               tt-decla-import-adic-trib.nom-trib            = pNomTribut
               tt-decla-import-adic-trib.cod-campo           = pCodCampo.
               
    END.
    ASSIGN tt-decla-import-adic-trib.cod-conteudo  = pconteudo.
    
    RUN openQueryStatic IN h-bocx00506 (INPUT 'Main':U).
    RUN emptyRowErrors  IN h-bocx00506.
    RUN emptyRowObject  IN h-bocx00506.
    RUN goToKey         IN h-bocx00506 (INPUT tt-decla-import-adic-trib.num-di-ems,
                                        INPUT tt-decla-import-adic-trib.num-adic,
                                        INPUT tt-decla-import-adic-trib.cdd-siscomex-dts,
                                        input tt-decla-import-adic-trib.nom-trib,
                                        input tt-decla-import-adic-trib.cod-campo).
    IF RETURN-VALUE = "NOK":U THEN DO:
        RUN setRecord       IN h-bocx00506 (INPUT TABLE tt-decla-import-adic-trib).
        RUN createRecord    IN h-bocx00506.
    END.
    ELSE DO:
        RUN setRecord       IN h-bocx00506 (INPUT TABLE tt-decla-import-adic-trib).
        RUN updateRecord    IN h-bocx00506.
    END.    
    run getRowErrors in h-bocx00506 (output table RowErrors).
    
    delete tt-decla-import-adic-trib.
    
    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-GeraDeclaImportOrdTrib DBOProgram 
PROCEDURE pi-GeraDeclaImportOrdTrib :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-nom-trib      AS CHAR  NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-campo     AS CHAR  NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-conteudo  AS CHAR  NO-UNDO.
        
    FIND FIRST tt-decla-import-ord-trib
         WHERE tt-decla-import-ord-trib.num-di-ems          = decla-import-adic-itens.num-di-ems
           AND tt-decla-import-ord-trib.num-ordem           = decla-import-adic-itens.num-ordem
           AND tt-decla-import-ord-trib.num-parcela         = decla-import-adic-itens.num-parcela 
           AND tt-decla-import-ord-trib.cdd-siscomex-dts    = decla-import-adic-itens.cdd-siscomex-dts           
           AND tt-decla-import-ord-trib.nom-trib            = p-nom-trib 
           AND tt-decla-import-ord-trib.cod-campo           = p-cod-campo EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAIL tt-decla-import-ord-trib THEN DO:
        CREATE tt-decla-import-ord-trib.
        ASSIGN tt-decla-import-ord-trib.num-di-ems          = decla-import-adic-itens.num-di-ems
               tt-decla-import-ord-trib.num-ordem           = decla-import-adic-itens.num-ordem
               tt-decla-import-ord-trib.num-parcela         = decla-import-adic-itens.num-parcela 
               tt-decla-import-ord-trib.cdd-siscomex-dts    = decla-import-adic-itens.cdd-siscomex-dts           
               tt-decla-import-ord-trib.nom-trib            = p-nom-trib 
               tt-decla-import-ord-trib.cod-campo           = p-cod-campo.                   
    END.
    ASSIGN tt-decla-import-ord-trib.cod-conteudo = p-cod-conteudo.
    
    RUN openQueryStatic  IN h-bocx00507 (INPUT 'Main':U).
    RUN emptyRowErrors   IN h-bocx00507.
    RUN emptyRowObject   IN h-bocx00507.
    RUN goToKey          IN h-bocx00507 (INPUT tt-decla-import-ord-trib.num-di-ems,      
                                         INPUT tt-decla-import-ord-trib.num-ordem,       
                                         INPUT tt-decla-import-ord-trib.num-parcela,     
                                         INPUT tt-decla-import-ord-trib.cdd-siscomex-dts,
                                         INPUT tt-decla-import-ord-trib.nom-trib,  
                                         INPUT tt-decla-import-ord-trib.cod-campo).

    IF  RETURN-VALUE = "NOK":U THEN DO:
        RUN setRecord    IN h-bocx00507 (INPUT TABLE tt-decla-import-ord-trib).
        RUN createRecord IN h-bocx00507.
    END.
    ELSE DO:
        RUN setRecord    IN h-bocx00507 (INPUT TABLE tt-decla-import-ord-trib).
        RUN updateRecord IN h-bocx00507.   
    END.

    delete tt-decla-import-ord-trib.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaTtDespesas DBOProgram 
PROCEDURE criaTtDespesas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-num-di-ems       LIKE decla-import-ord.num-di-ems       NO-UNDO.
    DEFINE INPUT PARAMETER p-cdd-siscomex-dts LIKE decla-import-ord.cdd-siscomex-dts NO-UNDO.

    FOR EACH despes-decla-import NO-LOCK
        WHERE despes-decla-import.num-di-ems       = p-num-di-ems 
          AND despes-decla-import.cdd-siscomex-dts = p-cdd-siscomex-dts
          AND despes-decla-import.idi-tip-incid-nf = i-tipo-rateio:
        
        /*criando as despesas da Declaraá∆o de Importaá∆o*/
        IF NOT CAN-FIND(FIRST tt-despesas
                        WHERE tt-despesas.num-di-ems = despes-decla-import.num-di-ems
                        AND   tt-despesas.num-adic   = 0
                        AND   tt-despesas.cdn-despes = despes-decla-import.cdn-despes) THEN DO:
            CREATE tt-despesas.
            ASSIGN tt-despesas.num-di-ems             = despes-decla-import.num-di-ems            
                   tt-despesas.num-adic               = 0         
                   tt-despesas.cdn-moeda              = despes-decla-import.cdn-moeda
                   tt-despesas.cdn-despes             = despes-decla-import.cdn-despes            
                   tt-despesas.log-incid-vmle         = despes-decla-import.log-incid-vmle        
                   tt-despesas.log-forma-preco-compra = despes-decla-import.log-forma-preco-compra
                   tt-despesas.val-despes             = despes-decla-import.val-despes
                   tt-despesas.i-tip-incid-nf         = despes-decla-import.idi-tip-incid-nf
                   tt-despesas.cdn-emit-despes        = despes-decla-import.cdn-emit-despes
                   tt-despesas.cdn-cond-pagto         = despes-decla-import.cdn-cond-pagto    
                   tt-despesas.cod-incoterm-rat       = despes-decla-import.cod-incoterm-rat.  

            FOR FIRST desp-imp NO-LOCK
                WHERE desp-imp.cod-desp = despes-decla-import.cdn-despes:

                &IF '{&BF_MAT_VERSAO_EMS}' >= '2.09' &THEN
                    ASSIGN tt-despesas.log-incid-val-aduana = desp-imp.log-incid-val-aduana.
                &ELSE
                    ASSIGN tt-despesas.log-incid-val-aduana = IF SUBSTRING(desp-imp.char-1,24,1) = '1' THEN YES ELSE NO.
                &ENDIF

                IF desp-imp.inc-val-frete THEN                                     
                    ASSIGN tt-despesas.log-frete = YES.                         

                IF desp-imp.inc-val-seguro THEN
                    ASSIGN tt-despesas.log-seguro = YES.
            END.      
        END.
    
        /* taxa siscomex */
        IF NOT VALID-HANDLE(h-bocx406) THEN
            RUN cxbo/bocx406.p PERSISTEN SET h-bocx406.

        RUN pi-busca-despes-siscomex IN h-bocx406 (INPUT p-num-di-ems,
                                                   INPUT p-cdd-siscomex-dts,
                                                   OUTPUT i-cdn-despes-siscomex,
                                                   OUTPUT i-cdn-emit-siscomex,
                                                   OUTPUT l-taxa-siscomex).
        IF l-taxa-siscomex THEN DO:
            FIND FIRST tt-despesas
                WHERE tt-despesas.cdn-despes = i-cdn-despes-siscomex NO-LOCK NO-ERROR.
            IF AVAIL tt-despesas THEN
                DELETE tt-despesas.
        END.
        /* taxa siscomex */
    END.
    IF i-tipo-rateio = 1 THEN DO: /* Rateio Despesas Nacionalizacao */
        /*Criando as despesas que s∆o apenas da adiá∆o*/
        IF CAN-FIND(FIRST despes-adic
                    WHERE despes-adic.num-di-ems = p-num-di-ems
                      AND despes-adic.cdd-siscomex-dts = p-cdd-siscomex-dts
                      AND despes-adic.idi-orig-despes = 1) /* Despesa Adicionada Manualmente */  THEN DO:

            FOR EACH despes-adic NO-LOCK
                WHERE despes-adic.num-di-ems      = p-num-di-ems
                  AND despes-adic.cdd-siscomex-dts = p-cdd-siscomex-dts
                  AND despes-adic.idi-orig-despes = 1
                  AND NOT CAN-FIND(FIRST bf-despes-decla-import
                                   WHERE bf-despes-decla-import.num-di-ems = despes-decla-import.num-di-ems
                                     AND bf-despes-decla-import.cdn-despes = despes-adic.cdn-despes
                                     AND bf-despes-decla-import.cdd-siscomex-dts = despes-adic.cdd-siscomex-dts):
                
                IF NOT CAN-FIND(FIRST tt-despesas
                                WHERE tt-despesas.num-di-ems = despes-adic.num-di-ems
                                AND   tt-despesas.num-adic   = despes-adic.num-adic
                                AND   tt-despesas.cdn-despes = despes-adic.cdn-despes) THEN DO:
                    CREATE tt-despesas.
                    ASSIGN tt-despesas.num-di-ems             = despes-adic.num-di-ems            
                           tt-despesas.num-adic               = despes-adic.num-adic     
                           tt-despesas.cdn-moeda              = despes-adic.cdn-moeda
                           tt-despesas.cdn-despes             = despes-adic.cdn-despes            
                           tt-despesas.log-incid-vmle         = despes-adic.log-incid-vmle        
                           tt-despesas.log-forma-preco-compra = despes-adic.log-forma-preco-compra
                           tt-despesas.val-despes             = despes-adic.val-despes
                           tt-despesas.i-tip-incid-nf         = 1 //Incide na NF de Nacionalizaá∆o
                           tt-despesas.cdn-emit-despes        = despes-adic.cdn-emit-despes
                           tt-despesas.cdn-cond-pagto         = despes-adic.cdn-cond-pag
                           tt-despesas.cod-incoterm-rat       = despes-adic.cod-incoterm-rat.

                    FOR FIRST desp-imp NO-LOCK
                        WHERE desp-imp.cod-desp = despes-adic.cdn-despes:
                        &IF '{&BF_MAT_VERSAO_EMS}' >= '2.09' &THEN
                            ASSIGN tt-despesas.log-incid-val-aduana = desp-imp.log-incid-val-aduana.
                        &ELSE
                            ASSIGN tt-despesas.log-incid-val-aduana = IF SUBSTRING(desp-imp.char-1,24,1) = '1' THEN YES ELSE NO.
                        &ENDIF
                    END.
                END.
            END.
        END.
    END.
    
    

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaTtDespesasAdic DBOProgram 
PROCEDURE criaTtDespesasAdic :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-num-di-ems   LIKE decla-import-ord.num-di-ems  NO-UNDO.
    DEFINE INPUT PARAMETER p-cdd-siscomex-dts LIKE decla-import-ord.cdd-siscomex-dts NO-UNDO.

    EMPTY TEMP-TABLE tt-despesas.

    FOR EACH despes-adic NO-LOCK
        WHERE despes-adic.num-di-ems = p-num-di-ems
          AND despes-adic.cdd-siscomex-dts = p-cdd-siscomex-dts:

        FOR FIRST despes-decla-import NO-LOCK
            WHERE despes-decla-import.num-di-ems = p-num-di-ems
            AND   despes-decla-import.cdn-despes = despes-adic.cdn-despes
            AND   despes-decla-import.cdd-siscomex-dts = despes-adic.cdd-siscomex-dts: END.            

        /*criando as despesas que s∆o apenas da adiá∆o*/
        IF NOT CAN-FIND(FIRST tt-despesas
                        WHERE tt-despesas.num-di-ems = despes-adic.num-di-ems
                        AND   tt-despesas.num-adic   = despes-adic.num-adic
                        AND   tt-despesas.cdn-despes = despes-adic.cdn-despes) THEN DO:
            CREATE tt-despesas.
            ASSIGN tt-despesas.num-di-ems             = despes-adic.num-di-ems            
                   tt-despesas.num-adic               = despes-adic.num-adic     
                   tt-despesas.cdn-moeda              = despes-adic.cdn-moeda
                   tt-despesas.cdn-despes             = despes-adic.cdn-despes            
                   tt-despesas.log-incid-vmle         = despes-adic.log-incid-vmle        
                   tt-despesas.log-forma-preco-compra = despes-adic.log-forma-preco-compra
                   tt-despesas.val-despes             = despes-adic.val-despes
                   tt-despesas.i-tip-incid-nf         = IF AVAIL despes-decla-import THEN despes-decla-import.idi-tip-incid-nf ELSE 1 //Incide na NF de Nacionalizaá∆o
                   tt-despesas.cdn-emit-despes        = despes-adic.cdn-emit-despes
                   tt-despesas.cdn-cond-pagto         = despes-adic.cdn-cond-pag
                   tt-despesas.cod-incoterm-rat       = despes-adic.cod-incoterm-rat.

            FOR FIRST desp-imp NO-LOCK
                WHERE desp-imp.cod-desp = despes-adic.cdn-despes:

                &IF '{&BF_MAT_VERSAO_EMS}' >= '2.09' &THEN
                    ASSIGN tt-despesas.log-incid-val-aduana = desp-imp.log-incid-val-aduana.
                &ELSE
                    ASSIGN tt-despesas.log-incid-val-aduana = IF SUBSTRING(desp-imp.char-1,24,1) = '1' THEN YES ELSE NO.
                &ENDIF

                IF desp-imp.inc-val-frete THEN                                  
                    ASSIGN tt-despesas.log-frete = YES.                   

                IF desp-imp.inc-val-seguro THEN
                    ASSIGN tt-despesas.log-seguro = YES.
            END.                  
        END.         
    END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraAdicDespTotais DBOProgram 
PROCEDURE geraAdicDespTotais :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM p-num-di-ems LIKE {&TABLENAME}.num-di-ems NO-UNDO.
DEF INPUT PARAM p-cdd-siscomex-dts LIKE {&TABLENAME}.cdd-siscomex-dts NO-UNDO.

ASSIGN de-valor-despesa = 0.

FOR EACH tt-desp-totais-adic:
    DELETE tt-desp-totais-adic.
END.

/*gerando os totais da adiáao x despesas*/
FOR EACH despes-adic NO-LOCK
    WHERE despes-adic.num-di-ems = p-num-di-ems
      AND despes-adic.cdd-siscomex-dts = p-cdd-siscomex-dts,
    FIRST decla-import-adic NO-LOCK
    WHERE decla-import-adic.num-di-ems = despes-adic.num-di-ems
    AND   decla-import-adic.num-adic   = despes-adic.num-adic
    AND   decla-import-adic.cdd-siscomex-dts = despes-adic.cdd-siscomex-dts,
    FIRST decla-import NO-LOCK
    WHERE decla-import.num-di-ems = decla-import-adic.num-di-ems
      AND decla-import.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts,
    FIRST tt-adic-totais
    WHERE tt-adic-totais.num-di-ems = decla-import-adic.num-di-ems
    AND   tt-adic-totais.num-adic   = decla-import-adic.num-adic
    :

    FOR FIRST desp-imp NO-LOCK
        WHERE desp-imp.cod-desp = despes-adic.cdn-despes : END.

    
    IF NOT CAN-FIND(FIRST tt-desp-totais-adic
                    WHERE tt-desp-totais-adic.num-di-ems = despes-adic.num-di-ems
                    AND   tt-desp-totais-adic.num-adic   = despes-adic.num-adic
                    AND   tt-desp-totais-adic.cod-desp   = despes-adic.cdn-despes) THEN DO:

        CREATE tt-desp-totais-adic.
        ASSIGN tt-desp-totais-adic.num-di-ems  = despes-adic.num-di-ems
               tt-desp-totais-adic.num-adic    = despes-adic.num-adic
               tt-desp-totais-adic.cod-desp    = despes-adic.cdn-despes.
    END.
    ELSE DO:
        FOR FIRST tt-desp-totais-adic
            WHERE tt-desp-totais-adic.num-di-ems = decla-import-adic.num-di-ems
            AND   tt-desp-totais-adic.num-adic   = decla-import-adic.num-adic
            AND   tt-desp-totais-adic.cod-desp   = despes-adic.cdn-despes : END.
    END.

    ASSIGN  tt-desp-totais-adic.quantidade         = decla-import-adic.qtd-ncm        
            tt-desp-totais-adic.peso-total         = tt-desp-totais-adic.peso-total + tt-adic-totais.peso-total
            tt-desp-totais-adic.val-cub-tot        = tt-desp-totais-adic.val-cub-tot + tt-adic-totais.val-cub-tot                   
            tt-desp-totais-adic.cod-emitente-desp  = despes-adic.cdn-emit-despes
            tt-desp-totais-adic.cod-cond-pag       = despes-adic.cdn-cond-pag
            tt-desp-totais-adic.mo-codigo          = despes-adic.cdn-moeda                  
            tt-desp-totais-adic.cod-pto-contr      = despes-adic.cdn-pto-control
            tt-desp-totais-adic.tp-despesa         = desp-imp.tp-despesa.

    ASSIGN de-valor-despesa = 0.
    
    FOR FIRST tt-despesas
        WHERE tt-despesas.num-di-ems      = despes-adic.num-di-ems
          AND tt-despesas.cdn-despes      = despes-adic.cdn-despes
          AND tt-despesas.cdn-emit-despes = despes-adic.cdn-emit-despes NO-LOCK:
    END.

    IF i-mo-codigo <> despes-adic.cdn-moeda 
       AND tt-despesas.i-tip-incid-nf = 1 THEN DO:  //Incide na NF de Nacionalizaá∆o

        RUN converteValorMoeda (INPUT decla-import-adic.num-di-ems,
                                INPUT decla-import-adic.cdd-siscomex-dts,
                                INPUT despes-adic.cdn-moeda,
                                INPUT i-mo-codigo,
                                INPUT despes-adic.val-despes,
                                INPUT decla-import.dat-di,
                                OUTPUT de-valor-despesa).
        ASSIGN tt-desp-totais-adic.val-desp = tt-desp-totais-adic.val-desp + de-valor-despesa.
    END.
    ELSE ASSIGN tt-desp-totais-adic.val-desp = tt-desp-totais-adic.val-desp + despes-adic.val-despes.


END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraAdicTotais DBOProgram 
PROCEDURE geraAdicTotais :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM p-num-di-ems LIKE {&TABLENAME}.num-di-ems NO-UNDO.
DEF INPUT PARAM p-cdd-siscomex-dts LIKE {&TABLENAME}.cdd-siscomex-dts NO-UNDO.

ASSIGN de-valor-despesa = 0.

FOR EACH decla-import-adic NO-LOCK
    WHERE decla-import-adic.num-di-ems = p-num-di-ems
      AND decla-import-adic.cdd-siscomex-dts = p-cdd-siscomex-dts:
    
    /*gerando os totais da adiá∆o x odens*/
    FOR EACH decla-import-ord NO-LOCK
        WHERE decla-import-ord.num-di-ems = p-num-di-ems
        AND   decla-import-ord.num-adic   = decla-import-adic.num-adic
        AND   decla-import-ord.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts,
        FIRST tt-ordens-totais NO-LOCK
        WHERE tt-ordens-totais.num-di-ems   = decla-import-ord.num-di-ems
        AND   tt-ordens-totais.numero-ordem = decla-import-ord.num-ordem
        AND   tt-ordens-totais.parcela      = decla-import-ord.num-parcela
        AND   tt-ordens-totais.num-adic     = decla-import-ord.num-adic:
        
        IF NOT CAN-FIND(FIRST tt-adic-totais
                        WHERE tt-adic-totais.num-di-ems = p-num-di-ems
                        AND   tt-adic-totais.num-adic   = decla-import-adic.num-adic) THEN DO:
            CREATE tt-adic-totais.
            ASSIGN tt-adic-totais.num-adic   = decla-import-adic.num-adic
                   tt-adic-totais.num-di-ems = p-num-di-ems
                   .
    
        END.
        ELSE
            FOR FIRST tt-adic-totais
                WHERE tt-adic-totais.num-di-ems = p-num-di-ems
                AND   tt-adic-totais.num-adic   = decla-import-adic.num-adic: END. 
        
        
        {utp/ut-liter.i "Lendo_Dados" *}
        RUN pi-acompanhar in h-acomp (RETURN-VALUE + " " + STRING(decla-import-adic.num-adic)).
        

        ASSIGN tt-adic-totais.quantidade      = tt-adic-totais.quantidade    + tt-ordens-totais.quantidade      
               tt-adic-totais.preco-unit      = tt-adic-totais.preco-unit    + tt-ordens-totais.preco-unit      
               tt-adic-totais.peso-total      = tt-adic-totais.peso-total    + tt-ordens-totais.peso-total      
               tt-adic-totais.peso-unit       = tt-adic-totais.peso-unit     + tt-ordens-totais.peso-unit       
               tt-adic-totais.val-cub-tot     = tt-adic-totais.val-cub-tot   + tt-ordens-totais.val-cub-tot     
               tt-adic-totais.val-cub-uni     = tt-adic-totais.val-cub-uni   + tt-ordens-totais.val-cub-uni     
               tt-adic-totais.qtd-do-forn     = tt-adic-totais.qtd-do-forn   + tt-ordens-totais.qtd-do-forn
               tt-adic-totais.val-merc-adic   = tt-adic-totais.val-merc-adic  + tt-ordens-totais.val-merc
               tt-adic-totais.val-preco-adic  = tt-adic-totais.val-preco-adic + tt-ordens-totais.val-merc.
    END.    
END.

/*criando os totais da DECLARAÄ«O DE IMPORTAÄ«O*/
FOR EACH tt-adic-totais
    WHERE tt-adic-totais.num-di-ems = p-num-di-ems:
      
    IF NOT CAN-FIND(FIRST tt-di-totais
                    WHERE tt-di-totais.num-di-ems = tt-adic-totais.num-di-ems) THEN DO:
        CREATE tt-di-totais.
        ASSIGN tt-di-totais.num-di-ems  = p-num-di-ems
               .
    END.
    ELSE 
        FOR FIRST tt-di-totais
            WHERE tt-di-totais.num-di-ems = tt-adic-totais.num-di-ems : END.
               
    FOR FIRST decla-import-embarq NO-LOCK
        WHERE decla-import-embarq.num-di-ems = p-num-di-ems
          AND decla-import-embarq.cdd-siscomex-dts = p-cdd-siscomex-dts,
        FIRST embarque-imp NO-LOCK
        WHERE embarque-imp.cod-estabel = decla-import-embarq.cod-estab
        AND   embarque-imp.embarque    = decla-import-embarq.cod-embarq:
        ASSIGN tt-di-totais.cod-incoterm = embarque-imp.cod-incoterm.
    END.

    ASSIGN tt-di-totais.quantidade  = tt-di-totais.quantidade  + tt-adic-totais.quantidade     
           tt-di-totais.val-merc-di = tt-di-totais.val-merc-di + tt-adic-totais.val-merc-adic    
           tt-di-totais.peso-total  = tt-di-totais.peso-total  + tt-adic-totais.peso-total     
           tt-di-totais.val-cub-tot = tt-di-totais.val-cub-tot + tt-adic-totais.val-cub-tot.                                                                                       

END.

/*gerando os totais da DI x despesas*/
FOR EACH despes-decla-import NO-LOCK
    WHERE despes-decla-import.num-di-ems = p-num-di-ems
      AND despes-decla-import.cdd-siscomex-dts = p-cdd-siscomex-dts,
    FIRST decla-import NO-LOCK
    WHERE decla-import.num-di-ems = despes-decla-import.num-di-ems
      AND decla-import.cdd-siscomex-dts = despes-decla-import.cdd-siscomex-dts,
    FIRST tt-di-totais
    WHERE tt-di-totais.num-di-ems = p-num-di-ems      :

    FOR FIRST desp-imp NO-LOCK
        WHERE desp-imp.cod-desp = despes-decla-import.cdn-despes : 
    END.
    
    IF NOT CAN-FIND(FIRST tt-desp-totais-di
                    WHERE tt-desp-totais-di.num-di-ems = p-num-di-ems                             
                    AND   tt-desp-totais-di.cod-desp   = despes-decla-import.cdn-despes) THEN DO:

        CREATE tt-desp-totais-di.
        ASSIGN tt-desp-totais-di.num-di-ems         = p-num-di-ems
               tt-desp-totais-di.cod-desp           = despes-decla-import.cdn-despes.
    END.
    ELSE
        FOR FIRST tt-desp-totais-di
            WHERE tt-desp-totais-di.num-di-ems = p-num-di-ems
            AND   tt-desp-totais-di.cod-desp   = despes-decla-import.cdn-despes : 
        END.

    ASSIGN  tt-desp-totais-di.peso-total         = tt-desp-totais-di.peso-total + tt-di-totais.peso-total
            tt-desp-totais-di.val-cub-tot        = tt-desp-totais-di.val-cub-tot + tt-di-totais.val-cub-tot                   
            tt-desp-totais-di.cod-emitente-desp  = despes-decla-import.cdn-emit-despes
            tt-desp-totais-di.cod-cond-pag       = despes-decla-import.cdn-cond-pagto
            tt-desp-totais-di.mo-codigo          = despes-decla-import.cdn-moeda                  
            tt-desp-totais-di.cod-pto-contr      = despes-decla-import.cdn-pto-control
            tt-desp-totais-di.tp-despesa         = desp-imp.tp-despesa.

    IF i-mo-codigo <> despes-decla-import.cdn-moeda THEN DO:
        RUN converteValorMoeda (INPUT decla-import.num-di-ems,
                                INPUT decla-import.cdd-siscomex-dts,
                                INPUT despes-decla-import.cdn-moeda,
                                INPUT i-mo-codigo,
                                INPUT despes-decla-import.val-despes,
                                INPUT decla-import.dat-di,
                                OUTPUT de-valor-despesa).
        ASSIGN tt-desp-totais-di.val-desp = tt-desp-totais-di.val-desp + de-valor-despesa.
    END.
    ELSE 
        ASSIGN tt-desp-totais-di.val-desp = tt-desp-totais-di.val-desp + despes-decla-import.val-despes.

END.

/*gerando os totais da adiáao x despesas*/
FOR EACH despes-adic NO-LOCK
    WHERE despes-adic.num-di-ems = p-num-di-ems
    AND   despes-adic.cdd-siscomex-dts = p-cdd-siscomex-dts
    AND   despes-adic.idi-orig-despes = 1,
    FIRST decla-import-adic NO-LOCK
    WHERE decla-import-adic.num-di-ems = despes-adic.num-di-ems
    AND   decla-import-adic.num-adic   = despes-adic.num-adic
    AND   decla-import-adic.cdd-siscomex-dts = despes-adic.cdd-siscomex-dts,
    FIRST decla-import NO-LOCK
    WHERE decla-import.num-di-ems = decla-import-adic.num-di-ems
      AND decla-import.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts,
    FIRST tt-adic-totais
    WHERE tt-adic-totais.num-di-ems = decla-import-adic.num-di-ems
    AND   tt-adic-totais.num-adic   = decla-import-adic.num-adic:

    IF NOT CAN-FIND(FIRST tt-desp-totais-adic
                    WHERE tt-desp-totais-adic.num-di-ems = decla-import-adic.num-di-ems
                    AND   tt-desp-totais-adic.num-adic   = decla-import-adic.num-adic
                    AND   tt-desp-totais-adic.cod-desp   = despes-adic.cdn-despes) THEN DO:

        CREATE tt-desp-totais-adic.
        ASSIGN tt-desp-totais-adic.num-di-ems  = decla-import-adic.num-di-ems
               tt-desp-totais-adic.num-adic    = decla-import-adic.num-adic
               tt-desp-totais-adic.cod-desp    = despes-adic.cdn-despes.
    END.
    ELSE
    FOR FIRST tt-desp-totais-adic
        WHERE tt-desp-totais-adic.num-di-ems = decla-import-adic.num-di-ems
        AND   tt-desp-totais-adic.num-adic   = decla-import-adic.num-adic
        AND   tt-desp-totais-adic.cod-desp   = despes-adic.cdn-despes : END.

    FOR FIRST desp-imp NO-LOCK
        WHERE desp-imp.cod-desp = despes-adic.cdn-despes : END.

    ASSIGN  tt-desp-totais-adic.quantidade         = decla-import-adic.qtd-ncm        
            tt-desp-totais-adic.peso-total         = tt-desp-totais-adic.peso-total + tt-di-totais.peso-total
            tt-desp-totais-adic.val-cub-tot        = tt-desp-totais-adic.val-cub-tot + tt-di-totais.val-cub-tot                   
            tt-desp-totais-adic.cod-emitente-desp  = despes-adic.cdn-emit-despes
            tt-desp-totais-adic.cod-cond-pag       = despes-adic.cdn-cond-pag
            tt-desp-totais-adic.mo-codigo          = despes-adic.cdn-moeda                  
            tt-desp-totais-adic.cod-pto-contr      = despes-adic.cdn-pto-control
            tt-desp-totais-adic.tp-despesa         = desp-imp.tp-despesa.

    ASSIGN de-valor-despesa = 0.
    IF i-mo-codigo <> despes-adic.cdn-moeda THEN DO:
        RUN converteValorMoeda (INPUT decla-import-adic.num-di-ems,
                                INPUT decla-import-adic.cdd-siscomex-dts,
                                INPUT despes-adic.cdn-moeda,
                                INPUT i-mo-codigo,
                                INPUT despes-adic.val-despes,
                                INPUT decla-import.dat-di,
                                OUTPUT de-valor-despesa).
        ASSIGN tt-desp-totais-adic.val-desp = tt-desp-totais-adic.val-desp + de-valor-despesa.
    END.
    ELSE 
        ASSIGN tt-desp-totais-adic.val-desp = tt-desp-totais-adic.val-desp + despes-adic.val-despes.

END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraDespesasRateadasAdicao DBOProgram 
PROCEDURE geraDespesasRateadasAdicao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM p-num-di-ems    LIKE decla-import-ord.num-di-ems    NO-UNDO.
    DEF INPUT  PARAM p-cdd-siscomex-dts LIKE decla-import-ord.cdd-siscomex-dts NO-UNDO.

    EMPTY TEMP-TABLE tt-despes-adic.
    EMPTY TEMP-TABLE tt-despes-adic-aux.
    empty temp-table tt-despes-adic-acerto.
    EMPTY TEMP-TABLE tt-acerto-despes.

    IF NOT AVAIL decla-import THEN
        FOR FIRST decla-import NO-LOCK
            WHERE decla-import.num-di-ems = p-num-di-ems 
              AND decla-import.cdd-siscomex-dts = p-cdd-siscomex-dts: END.

    FOR EACH tt-desp-rateio,
        FIRST tt-despesas
        WHERE tt-despesas.num-di-ems = tt-desp-rateio.num-di-ems
        AND   tt-despesas.num-adic   = 0
        AND   tt-despesas.cdn-despes = tt-desp-rateio.cod-desp:

        IF NOT CAN-FIND(FIRST tt-despes-adic
                        WHERE tt-despes-adic.num-di-ems = p-num-di-ems
                        AND   tt-despes-adic.num-adic   = tt-desp-rateio.num-adic
                        AND   tt-despes-adic.cdn-emit-despes = tt-despesas.cdn-emit-despes
                        AND   tt-despes-adic.cdn-despes = tt-desp-rateio.cod-desp
                        and   tt-despes-adic.cdd-siscomex-dts = p-cdd-siscomex-dts) THEN DO:
            CREATE tt-despes-adic.
            ASSIGN tt-despes-adic.num-adic                  = tt-desp-rateio.num-adic
                   tt-despes-adic.num-di-ems                = p-num-di-ems
                   tt-despes-adic.cdd-siscomex-dts          = p-cdd-siscomex-dts
                   tt-despes-adic.cdn-despes                = tt-desp-rateio.cod-desp
                   tt-despes-adic.cdn-emit-despes           = tt-despesas.cdn-emit-despes
                   tt-despes-adic.cdn-cond-pag              = tt-despesas.cdn-cond-pagto
                   tt-despes-adic.cdn-moeda                 = tt-despesas.cdn-moeda
                   tt-despes-adic.cdn-pto-control           = 0
                   tt-despes-adic.cod-incoterm-rat          = tt-despesas.cod-incoterm-rat
                   tt-despes-adic.idi-orig-despes           = 2
                   tt-despes-adic.log-forma-preco-compra    = tt-despesas.log-forma-preco-compra
                   tt-despes-adic.log-incid-vmle            = tt-despesas.log-incid-vmle.

                ASSIGN de-valor-despesa = 0.
                /*Convertendo valor para a moeda da despesa original*/
                IF i-mo-codigo <> tt-despesas.cdn-moeda THEN DO:
                    RUN converteValorMoeda (INPUT decla-import.num-di-ems,
                                            INPUT decla-import.cdd-siscomex-dts,
                                            INPUT i-mo-codigo,
                                            INPUT tt-despesas.cdn-moeda,
                                            INPUT tt-desp-rateio.val-desp,
                                            INPUT decla-import.dat-di,
                                            OUTPUT de-valor-despesa).
                END.
                ELSE
                    ASSIGN de-valor-despesa = tt-desp-rateio.val-desp.

                ASSIGN tt-despes-adic.val-despes = de-valor-despesa.

                IF tt-despesas.log-frete OR tt-despesas.log-seguro THEN DO:

                    FOR FIRST decla-import-adic EXCLUSIVE-LOCK
                        WHERE decla-import-adic.num-di-ems = p-num-di-ems
                        AND   decla-import-adic.num-adic   = tt-desp-rateio.num-adic 
                        AND   decla-import-adic.cdd-siscomex-dts = p-cdd-siscomex-dts:

                        IF tt-despesas.log-frete THEN
                            ASSIGN decla-import-adic.val-frete      = de-valor-despesa
                                   decla-import-adic.cdn-moed-frete = tt-despesas.cdn-moeda.

                        IF tt-despesas.log-seguro THEN
                            ASSIGN decla-import-adic.val-seguro      = de-valor-despesa
                                   decla-import-adic.cdn-moed-seguro = tt-despesas.cdn-moeda.

                    END.
                END.
                create tt-despes-adic-acerto.
                buffer-copy tt-despes-adic to tt-despes-adic-acerto.
        END.
    END.

    /*Acerto de resÌduos*/
    FOR EACH tt-despes-adic-acerto BREAK BY tt-despes-adic-acerto.cdn-despes:
        ASSIGN d-val-desp-adic-aux  = 0
               i-num-adic-aux       = 0    
               i-num-seq-aux        = 0
               i-cdn-emit-despes-aux = 0 
               d-total-desp      = 0.

         FOR EACH tt-desp-rateio,
            FIRST tt-despesas
            WHERE tt-despesas.num-di-ems = tt-despes-adic-acerto.num-di-ems
              AND tt-despesas.num-adic   = 0
              AND tt-despesas.cdn-despes = tt-despes-adic-acerto.cdn-despes:

             IF tt-desp-rateio.val-desp > d-val-desp-adic-aux THEN
                 ASSIGN d-val-desp-adic-aux    = tt-desp-rateio.val-desp
                        i-num-adic-aux         = tt-desp-rateio.num-adic
                        /*i-num-seq-aux          = tt-desp-rateio.num-seq*/
                        i-cdn-emit-despes-aux  = tt-despesas.cdn-emit-despes.

         END.

         IF LAST-OF(tt-despes-adic-acerto.cdn-despes) THEN DO:

             ASSIGN d-val-desp-adic-aux = 0.
             FOR EACH tt-despes-adic
                WHERE tt-despes-adic.cdn-despes = tt-despes-adic-acerto.cdn-despes:
                  ASSIGN d-val-desp-adic-aux = d-val-desp-adic-aux + tt-despes-adic.val-despes.
             END.

             /**Total da DI**/
             FOR FIRST despes-decla-import
                 WHERE despes-decla-import.num-di-ems = p-num-di-ems
                   AND despes-decla-import.cdn-despes = tt-despes-adic-acerto.cdn-despes
                   AND despes-decla-import.cdd-siscomex-dts = p-cdd-siscomex-dts:
                 ASSIGN d-total-desp = despes-decla-import.val-despes.
             END.

             FOR first tt-despes-adic
                 WHERE tt-despes-adic.num-di-ems = p-num-di-ems
                   AND tt-despes-adic.num-adic   = i-num-adic-aux
                   /*AND tt-despes-adic.num-seq    = i-num-seq-aux*/
                   AND tt-despes-adic.cdn-emit-despes = i-cdn-emit-despes-aux
                   AND tt-despes-adic.cdd-siscomex-dts = p-cdd-siscomex-dts
                   AND tt-despes-adic.cdn-despes = tt-despes-adic-acerto.cdn-despes:

                 ASSIGN tt-despes-adic.val-despes = tt-despes-adic.val-despes + (d-total-desp - d-val-desp-adic-aux).

                 IF (d-total-desp - d-val-desp-adic-aux) <> 0 THEN DO:
                     CREATE tt-acerto-despes.
                     ASSIGN tt-acerto-despes.cdn-despes = tt-despes-adic.cdn-despes
                            tt-acerto-despes.num-adic   = i-num-adic-aux.
                 END.
             END.
         END.
    END.
    
    IF NOT VALID-HANDLE(h-bocx390) THEN
        RUN cxbo/bocx390.p PERSISTENT SET h-bocx390.

    FOR EACH tt-despes-adic:
        EMPTY TEMP-TABLE tt-despes-adic-aux.
        CREATE tt-despes-adic-aux.
        BUFFER-COPY tt-despes-adic TO tt-despes-adic-aux.

        RUN openQueryStatic IN h-bocx390 (INPUT 'Main':U).
        RUN emptyRowErrors  IN h-bocx390.
        RUN emptyRowObject  IN h-bocx390.
        RUN goToKey         IN h-bocx390 (INPUT tt-despes-adic-aux.num-di-ems,
                                          INPUT tt-despes-adic-aux.num-adic,
                                          INPUT tt-despes-adic-aux.cdn-despes,
                                          INPUT tt-despes-adic-aux.cdn-emit-despes,
                                          INPUT tt-despes-adic-aux.cdd-siscomex-dts).
        IF RETURN-VALUE = "NOK" THEN DO:
            RUN setRecord    IN h-bocx390 (INPUT TABLE tt-despes-adic-aux).
            RUN createRecord IN h-bocx390.            
        END.
        ELSE DO:
            RUN setRecord    IN h-bocx390 (INPUT TABLE tt-despes-adic-aux).
            RUN updateRecord IN h-bocx390.
        END.                              
        RUN getRowErrors IN h-bocx390 (OUTPUT TABLE RowErrors APPEND).
    END.

    IF VALID-HANDLE (h-bocx390)   THEN DO:
        DELETE PROCEDURE h-bocx390.   /* despes-adic */   
        ASSIGN h-bocx390 = ?.
    END.
        

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraDespesasRateadasItem DBOProgram 
PROCEDURE geraDespesasRateadasItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM p-num-di-ems    LIKE decla-import-ord.num-di-ems    NO-UNDO.
    DEF INPUT  PARAM p-cdd-siscomex-dts LIKE decla-import-ord.cdd-siscomex-dts NO-UNDO.

    EMPTY TEMP-TABLE tt-despes-adic-itens.
    EMPTY TEMP-TABLE tt-despes-adic-itens-aux.
    
    IF NOT AVAIL decla-import THEN
        FOR FIRST decla-import NO-LOCK
            WHERE decla-import.num-di-ems = p-num-di-ems
              AND decla-import.cdd-siscomex-dts = p-cdd-siscomex-dts: END.
    
    FOR EACH tt-desp-rateio-item,
        FIRST tt-despesas
        WHERE tt-despesas.num-di-ems = tt-desp-rateio-item.num-di-ems
        AND   tt-despesas.num-adic   = tt-desp-rateio-item.num-adic
        AND   tt-despesas.cdn-despes = tt-desp-rateio-item.cod-desp:

        IF NOT CAN-FIND(FIRST tt-despes-adic-itens
                        WHERE tt-despes-adic-itens.num-di-ems       = p-num-di-ems
                        AND   tt-despes-adic-itens.num-adic         = tt-desp-rateio-item.num-adic
                        AND   tt-despes-adic-itens.num-seq          = tt-desp-rateio-item.num-seq
                        AND   tt-despes-adic-itens.cdn-emit-despes  = tt-despesas.cdn-emit-despes
                        AND   tt-despes-adic-itens.cdn-despes       = tt-desp-rateio-item.cod-desp
                        AND   tt-despes-adic-itens.cdd-siscomex-dts = p-cdd-siscomex-dts) THEN DO:

            CREATE tt-despes-adic-itens.
            ASSIGN tt-despes-adic-itens.num-adic                  = tt-desp-rateio-item.num-adic
                   tt-despes-adic-itens.num-di-ems                = p-num-di-ems
                   tt-despes-adic-itens.num-seq                   = tt-desp-rateio-item.num-seq
                   tt-despes-adic-itens.cdn-despes                = tt-desp-rateio-item.cod-desp
                   tt-despes-adic-itens.cdn-emit-despes           = tt-despesas.cdn-emit-despes
                   tt-despes-adic-itens.cdd-siscomex-dts          = p-cdd-siscomex-dts
                   tt-despes-adic-itens.cdn-cond-pag              = tt-despesas.cdn-cond-pagto
                   tt-despes-adic-itens.cdn-moeda                 = tt-despesas.cdn-moeda
                   tt-despes-adic-itens.cod-incoterm-rat          = tt-despesas.cod-incoterm-rat
                   tt-despes-adic-itens.log-forma-preco-compra    = tt-despesas.log-forma-preco-compra.   
                
                ASSIGN de-valor-despesa = 0.
                /*Convertendo valor para a moeda da despesa original*/
                IF i-mo-codigo <> tt-despesas.cdn-moeda THEN DO:
                    RUN converteValorMoeda (INPUT decla-import.num-di-ems,
                                            INPUT decla-import.cdd-siscomex-dts,
                                            INPUT i-mo-codigo,
                                            INPUT tt-despesas.cdn-moeda,
                                            INPUT tt-desp-rateio-item.val-desp,
                                            INPUT decla-import.dat-di,
                                            OUTPUT de-valor-despesa).
                END.
                ELSE
                    ASSIGN de-valor-despesa = tt-desp-rateio-item.val-desp.

                ASSIGN tt-despes-adic-itens.val-despes = de-valor-despesa.
                
                IF tt-despesas.log-frete OR tt-despesas.log-seguro THEN DO:

                    FOR FIRST decla-import-adic-itens EXCLUSIVE-LOCK
                        WHERE decla-import-adic-itens.num-di-ems = p-num-di-ems
                        AND   decla-import-adic-itens.num-adic   = tt-desp-rateio-item.num-adic 
                        AND   decla-import-adic-itens.num-seq    = tt-desp-rateio-item.num-seq
                        AND   decla-import-adic-itens.cdd-siscomex-dts = p-cdd-siscomex-dts:

                        IF tt-despesas.log-frete THEN
                            ASSIGN decla-import-adic-itens.val-frete      = de-valor-despesa
                                   decla-import-adic-itens.cdn-moed-frete = tt-despesas.cdn-moeda.

                        IF tt-despesas.log-seguro THEN
                            ASSIGN decla-import-adic-itens.val-seguro      = de-valor-despesa
                                   decla-import-adic-itens.cdn-moed-seguro = tt-despesas.cdn-moeda.

                    END.
                END.

                //Criar tt-despes-adic-itens-aux para acerto
                CREATE tt-despes-adic-itens-aux.
                BUFFER-COPY tt-despes-adic-itens TO tt-despes-adic-itens-aux NO-ERROR.

        END.
    END.
    
    FOR EACH tt-despes-adic-itens-aux  BREAK BY tt-despes-adic-itens-aux.cdn-despes:
        ASSIGN d-val-desp-aux        = 0
               i-num-adic-aux        = 0    
               i-num-seq-aux         = 0
               i-cdn-emit-despes-aux = 0 
               d-total-desp          = 0.

        /* Temp-table guarda qual foi a adicao acertada, para acertar um item dessa adicao de maior valor */
        FIND FIRST tt-acerto-despes
             WHERE tt-acerto-despes.cdn-despes = tt-despes-adic-itens-aux.cdn-despes NO-LOCK NO-ERROR.

        IF AVAIL tt-acerto-despes THEN DO:
            FOR EACH tt-desp-rateio-item, 
               FIRST tt-despesas
               WHERE tt-despesas.num-di-ems = tt-despes-adic-itens-aux.num-di-ems
                 AND tt-despesas.num-adic   = tt-acerto-despes.num-adic
                 AND tt-despesas.cdn-despes = tt-acerto-despes.cdn-despes:
    
                if tt-desp-rateio-item.val-desp > d-val-desp-aux then 
                    assign d-val-desp-aux         = tt-desp-rateio-item.val-desp
                           i-num-adic-aux         = tt-desp-rateio-item.num-adic
                           i-num-seq-aux          = tt-desp-rateio-item.num-seq
                           i-cdn-emit-despes-aux  = tt-despesas.cdn-emit-despes.
            END.
        END.
        ELSE DO:
            FOR EACH tt-desp-rateio-item, 
               FIRST tt-despesas
               WHERE tt-despesas.num-di-ems = tt-despes-adic-itens-aux.num-di-ems
                 AND tt-despesas.num-adic   = tt-despes-adic-itens-aux.num-adic
                 AND tt-despesas.cdn-despes = tt-despes-adic-itens-aux.cdn-despes:
    
                if tt-desp-rateio-item.val-desp > d-val-desp-aux then 
                    assign d-val-desp-aux         = tt-desp-rateio-item.val-desp
                           i-num-adic-aux         = tt-desp-rateio-item.num-adic
                           i-num-seq-aux          = tt-desp-rateio-item.num-seq
                           i-cdn-emit-despes-aux  = tt-despesas.cdn-emit-despes.
            END.
        END.

        IF LAST-OF(tt-despes-adic-itens-aux.cdn-despes) THEN DO:
            assign d-val-desp-aux = 0.
            FOR EACH tt-despes-adic-itens 
               WHERE tt-despes-adic-itens.cdn-despes = tt-despes-adic-itens-aux.cdn-despes:
                ASSIGN d-val-desp-aux = d-val-desp-aux + tt-despes-adic-itens.val-despes.
            END.

            /**total despesa na DI***/
            FOR FIRST despes-decla-import NO-LOCK
                WHERE despes-decla-import.num-di-ems = p-num-di-ems 
                AND   despes-decla-import.cdn-despes = tt-despes-adic-itens-aux.cdn-despes:
                ASSIGN d-total-desp = despes-decla-import.val-despes.
            END.

            /* se a despesa est† somente na adiá∆o da DI */
            IF d-total-desp = 0 THEN DO:
               FOR EACH despes-adic NO-LOCK
                   WHERE despes-adic.num-di-ems = p-num-di-ems 
                   AND   despes-adic.cdn-despes = tt-despes-adic-itens-aux.cdn-despes:
                   ASSIGN d-total-desp = d-total-desp + despes-adic.val-despes.
               END.
            END.            

            FOR FIRST tt-despes-adic-itens 
                WHERE tt-despes-adic-itens.num-di-ems       = p-num-di-ems
                  and tt-despes-adic-itens.num-adic         = i-num-adic-aux    
                  and tt-despes-adic-itens.num-seq          = i-num-seq-aux     
                  and tt-despes-adic-itens.cdn-emit-despes  = i-cdn-emit-despes-aux
                  and tt-despes-adic-itens.cdn-despes       = tt-despes-adic-itens-aux.cdn-despes
                  AND tt-despes-adic-itens.cdd-siscomex-dts = p-cdd-siscomex-dts:
                
                ASSIGN tt-despes-adic-itens.val-despes = tt-despes-adic-itens.val-despes + (d-total-desp - d-val-desp-aux).
            END.
        END.
    END.
    
    IF NOT VALID-HANDLE(h-bocx389) THEN
        RUN cxbo/bocx389.p PERSISTENT SET h-bocx389.

    FOR EACH tt-despes-adic-itens:
        EMPTY TEMP-TABLE tt-despes-adic-itens-aux.
        CREATE tt-despes-adic-itens-aux.
        BUFFER-COPY tt-despes-adic-itens TO tt-despes-adic-itens-aux.

        RUN openQueryStatic IN h-bocx389 (INPUT 'Main':U).
        RUN emptyRowErrors  IN h-bocx389.
        RUN emptyRowObject  IN h-bocx389.
        RUN goToKey         IN h-bocx389 (INPUT tt-despes-adic-itens-aux.num-di-ems,
                                          INPUT tt-despes-adic-itens-aux.num-adic,
                                          INPUT tt-despes-adic-itens-aux.num-seq,
                                          INPUT tt-despes-adic-itens-aux.cdn-despes,
                                          INPUT tt-despes-adic-itens-aux.cdn-emit-despes,
                                          INPUT tt-despes-adic-itens-aux.cdd-siscomex-dts).
        IF RETURN-VALUE = "NOK" THEN DO:
            RUN setRecord    IN h-bocx389 (INPUT TABLE tt-despes-adic-itens-aux).
            RUN createRecord IN h-bocx389.            
        END.
        ELSE DO:
            RUN setRecord    IN h-bocx389 (INPUT TABLE tt-despes-adic-itens-aux).
            RUN updateRecord IN h-bocx389.
        END.                              
        RUN getRowErrors IN h-bocx389 (OUTPUT TABLE RowErrors APPEND).
    END.

    IF VALID-HANDLE (h-bocx389)   THEN DO:
        DELETE PROCEDURE h-bocx389.   /* despes-adic */   
        ASSIGN h-bocx389 = ?.
    END.
        

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraOrdenstotais DBOProgram 
PROCEDURE geraOrdenstotais :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /* Calcula os valores totais de peso/quantidade/valor das ordens informadas */
    def input parameter p-num-di-ems   like {&TABLENAME}.num-di-ems   no-undo.
    def input parameter p-num-adic     like {&TABLENAME}.num-adic     no-undo.
    def input parameter p-numero-ordem like ordem-compra.numero-ordem no-undo.
    def input parameter p-parcela      like prazo-compra.parcela      no-undo.
    DEF INPUT PARAMETER p-cdd-siscomex-dts LIKE {&TABLENAME}.cdd-siscomex-dts no-undo.
    def input parameter p-cod-emitente like emitente.cod-emitente     no-undo.
    def input parameter p-data-cotacao like cotacao-item.data-cotacao no-undo.
    def input parameter p-seq-cotac    as integer                     no-undo.
    def input parameter p-quantidade   like prazo-compra.quantidade   no-undo.
    def input parameter p-qtd-do-forn  like prazo-compra.qtd-do-forn  no-undo.
    
    def var de-pre-unit-for   like cotacao-item.pre-unit-for no-undo.
    def var de-preco-total    like cotacao-item.preco-unit   no-undo.
    def var de-preco-total-mo like cotacao-item.preco-unit   no-undo.
    
    DEF VAR de-peso-bruto     AS   DECIMAL FORMAT ">>>,>>>,>>9.99999":U NO-UNDO.
    DEF VAR de-peso-liquido   AS   DECIMAL FORMAT ">>>,>>>,>>9.99999":U NO-UNDO.
    def var de-cotacao-dia    as   decimal format ">>>,>9.99999999":U   no-undo.
    

    FIND FIRST ITEM 
        WHERE ITEM.it-codigo = cotacao-item.it-codigo NO-LOCK NO-ERROR.

    {cxbo/bocx225e.i1} /*definicao dos pesos*/
    {ccp/cc9019.i50}   /* include tratamento atributo livre */

    {cdp/cd4300.i4 "yes" cotacao-item.char-1}
    {ccp/cc9019.i51 "yes"}                
        
    ASSIGN i-mo-codigo       = cotacao-item.mo-codigo
           de-aliquota-ii    = de-aliq-ii-i50
           de-pre-unit-for   = ((cotacao-item.pre-unit-for * 100) / (100 + cotacao-item.aliquota-ipi)) /** preco sem ipi **/
           de-preco-total    = de-pre-unit-for * p-qtd-do-forn
           de-preco-total-mo = de-pre-unit-for * p-qtd-do-forn.

    FIND FIRST tt-ordens-totais 
         WHERE tt-ordens-totais.num-di-ems   = p-num-di-ems
           AND tt-ordens-totais.num-adic     = p-num-adic
           AND tt-ordens-totais.numero-ordem = p-numero-ordem 
           AND tt-ordens-totais.parcela      = p-parcela 
           NO-ERROR.
    
    IF NOT AVAIL tt-ordens-totais THEN DO:    
        
        CREATE tt-ordens-totais.
        ASSIGN tt-ordens-totais.num-di-ems   = p-num-di-ems
               tt-ordens-totais.num-adic     = p-num-adic
               tt-ordens-totais.numero-ordem = p-numero-ordem
               tt-ordens-totais.parcela      = p-parcela
               tt-ordens-totais.it-codigo    = decla-import-ord.cod-item WHEN AVAIL decla-import-ord
               tt-ordens-totais.preco-unit   = de-pre-unit-for /** preco unitario do fornecedor **/
               tt-ordens-totais.aliquota-ii  = decla-import-ord.val-aliq-ii WHEN AVAIL decla-import-ord
               tt-ordens-totais.mo-codigo    = i-mo-codigo
               tt-ordens-totais.i-trib-ii    = decla-import-ord.idi-tributac-impto-import WHEN AVAIL decla-import-ord
               tt-ordens-totais.seq-cotac    = cotacao-item.seq-cotac
               tt-ordens-totais.cod-emitente = cotacao-item.cod-emitente.
               
    END.

    IF CAN-FIND(FIRST decla-import-adic-itens
                WHERE decla-import-adic-itens.num-di-ems  = decla-import-ord.num-di-ems
                AND   decla-import-adic-itens.num-adic    = decla-import-ord.num-adic
                AND   decla-import-adic-itens.num-ordem   = decla-import-ord.num-ordem
                AND   decla-import-adic-itens.num-parcela = decla-import-ord.num-parcela
                AND   decla-import-adic-itens.cdd-siscomex-dts = decla-import-ord.cdd-siscomex-dts) THEN DO:

        FOR FIRST decla-import-adic-itens NO-LOCK
                WHERE decla-import-adic-itens.num-di-ems  = decla-import-ord.num-di-ems
                AND   decla-import-adic-itens.num-adic    = decla-import-ord.num-adic
                AND   decla-import-adic-itens.num-ordem   = decla-import-ord.num-ordem
                AND   decla-import-adic-itens.num-parcela = decla-import-ord.num-parcela
                AND   decla-import-adic-itens.cdd-siscomex-dts = decla-import-ord.cdd-siscomex-dts:

            ASSIGN tt-ordens-totais.num-seq = decla-import-adic-itens.num-seq.

        END.
    END.

    ASSIGN tt-ordens-totais.quantidade       = tt-ordens-totais.quantidade
                                             + p-quantidade
           tt-ordens-totais.qtd-do-forn      = tt-ordens-totais.qtd-do-forn 
                                             + p-qtd-do-forn
           tt-ordens-totais.val-merc         = tt-ordens-totais.val-merc
                                             + de-preco-total
           tt-ordens-totais.val-preco-merc   = tt-ordens-totais.val-preco-merc
                                             + de-preco-total
           tt-ordens-totais.preco-merc-tot   = tt-ordens-totais.preco-merc-tot
                                             + de-preco-total
           tt-ordens-totais.base-ii          = tt-ordens-totais.base-ii
                                             + de-preco-total
           tt-ordens-totais.base-ipi         = tt-ordens-totais.base-ipi
                                             + de-preco-total
           tt-ordens-totais.base-pis         = tt-ordens-totais.base-pis
                                             + de-preco-total
           tt-ordens-totais.base-cofins      = tt-ordens-totais.base-cofins
                                             + de-preco-total
           tt-ordens-totais.base-icms        = tt-ordens-totais.base-icms
                                             + de-preco-total
           tt-ordens-totais.base-ii-mo       = tt-ordens-totais.base-ii-mo
                                             + de-preco-total-mo
           tt-ordens-totais.base-ipi-mo      = tt-ordens-totais.base-ipi
                                             + de-preco-total-mo
           tt-ordens-totais.base-pis-mo      = tt-ordens-totais.base-pis
                                             + de-preco-total-mo
           tt-ordens-totais.base-cofins-mo   = tt-ordens-totais.base-cofins
                                             + de-preco-total-mo
           tt-ordens-totais.base-icms-mo     = tt-ordens-totais.base-icms
                                             + de-preco-total-mo
           tt-ordens-totais.peso-total       = tt-ordens-totais.peso-total
                                             + decla-import-ord.val-peso-liq
           tt-ordens-totais.val-cub-tot      = tt-ordens-totais.val-cub-tot
                                             + decla-import-ord.val-cub-tot .
                                                           
           &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN
                IF VALID-HANDLE(h-boin356) THEN DO:
                   DELETE PROCEDURE h-boin356.
                   ASSIGN h-boin356 = ?.
                END.
                IF VALID-HANDLE(h-bodi425) THEN DO:
                   DELETE PROCEDURE h-bodi425.
                   ASSIGN h-bodi425 = ?.
                END.
           &endif

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraRateioDespesasAdicao DBOProgram 
PROCEDURE geraRateioDespesasAdicao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-num-di-ems  LIKE {&TABLENAME}.num-di-ems NO-UNDO.
    DEF INPUT PARAM p-cdd-siscomex-dts LIKE {&TABLENAME}.cdd-siscomex-dts NO-UNDO.
    DEF INPUT PARAM p-tipo-rateio AS INTEGER                   NO-UNDO. /*ESSE PARAMETRO DEFINE EM QUAL ETAPA DO RATEIO SE ENCONTRA PARA */

    /* 
    ** Gera valores rateados para as despesas
    */
    DEF VAR l-create-desp-rateio AS LOG NO-UNDO.
    DEF VAR l-desp-valor-fixo    AS LOG NO-UNDO.
    DEF VAR de-valor-rateado     like cotacao-item-cex.val-desp NO-UNDO.
    DEF VAR de-valor-rateado-mo  like cotacao-item-cex.val-desp NO-UNDO.
    DEFINE VARIABLE i-num-adicao like decla-import-ord.num-adic    no-undo.
    DEFINE VARIABLE de-tot-siscomex-cif         AS   DECIMAL                        NO-UNDO.   
    DEFINE VARIABLE de-tot-siscomex-cif-mo      AS   DECIMAL                        NO-UNDO.   

    empty temp-table tt-desp-cif.

    FOR FIRST decla-import NO-LOCK
        WHERE decla-import.num-di-ems = p-num-di-ems 
          AND decla-import.cdd-siscomex-dts = p-cdd-siscomex-dts: END.

    FOR EACH tt-adic-desp
        BY tt-adic-desp.sequencia:

        assign de-val-desp          = 0
               l-create-desp-rateio = YES
               l-desp-valor-fixo    = NO.

        FIND param-imp
             WHERE param-imp.cod-estabel = tt-adic-desp.cod-estabel NO-LOCK NO-ERROR.

        IF NOT AVAIL param-imp THEN DO:
            
            
            {utp/ut-liter.i "ParÉmetros_de_Importaá∆o" *}
            {method/svc/errors/inserr.i
                  &ErrorNumber="2"
                  &ErrorType="EMS"
                  &ErrorParameters=TRIM(RETURN-VALUE)}
                  
            IF VALID-HANDLE(h-acomp) THEN
                RUN pi-finalizar IN h-acomp.
        
            RETURN "NOK":U.
        END.
        
        FIND tt-desp-totais-di
            WHERE tt-desp-totais-di.num-di-ems = p-num-di-ems
              AND tt-desp-totais-di.cod-desp   = tt-adic-desp.cod-desp NO-ERROR.
        
        IF NOT AVAIL tt-desp-totais-di THEN
            NEXT.

        /*POSICIONANDO NOS TOTAIS DA ADIÄ«O*/
        FOR FIRST tt-adic-totais
            WHERE tt-adic-totais.num-di-ems = p-num-di-ems
            AND   tt-adic-totais.num-adic   = tt-adic-desp.num-adic: END.

        /*POSICIONANDO NOS TOTAIS DA DI*/
        FOR FIRST tt-di-totais
            WHERE tt-di-totais.num-di-ems = p-num-di-ems NO-LOCK: END.
                
        ASSIGN de-val-desp        = 0
               de-valor-merc-di   = 0
               de-valor-merc-adic = 0.

        IF p-tipo-rateio = 1 THEN
            ASSIGN de-valor-merc-adic = tt-adic-totais.val-merc-adic
                   de-valor-merc-di   = tt-di-totais.val-merc-di.
        ELSE DO: 
            IF p-tipo-rateio = 2 THEN DO:  
                FOR FIRST tt-despesas
                    WHERE tt-despesas.cdn-despes = tt-adic-desp.cod-desp : END.

                IF AVAIL tt-despesas
                    AND  not tt-despesas.log-frete then do:

                    ASSIGN l-create-desp-rateio = NO.
        
                    FOR FIRST decla-import NO-LOCK
                        WHERE decla-import.num-di-ems = p-num-di-ems
                        AND   decla-import.cdd-siscomex-dts = p-cdd-siscomex-dts:
                         /*
                          Se a despesa de frete comp‰e a incoterm, ent∆o deve deduzir proporcionalmente o valor do frete rateado anteriormente 
                          para que n∆o sobrecarregue o custo.
                         */
                        IF l-frete-incid-incoterm THEN
                            ASSIGN de-valor-merc-di   = decla-import.val-vmcv - decla-import.val-frete.
                        ELSE
                            ASSIGN de-valor-merc-di   = decla-import.val-vmcv.
        
                        FOR FIRST decla-import-adic NO-LOCK
                            WHERE decla-import-adic.num-di-ems = decla-import.num-di-ems
                            AND   decla-import-adic.num-adic   = tt-adic-desp.num-adic
                            AND   decla-import-adic.cdd-siscomex-dts = p-cdd-siscomex-dts:
                            IF l-frete-incid-incoterm THEN
                                ASSIGN de-valor-merc-adic = decla-import-adic.val-vmcv - decla-import-adic.val-frete.
                            ELSE
                                ASSIGN de-valor-merc-adic = decla-import-adic.val-vmcv.
                        END.
                    END.
                end.
            END.    
        END.

        ASSIGN de-valor-despesa = 0.

        RUN calculaValorRateio (INPUT tt-adic-desp.cod-desp,
                                INPUT de-valor-merc-adic,
                                INPUT tt-adic-totais.peso-total,
                                INPUT tt-adic-totais.quantidade,
                                INPUT tt-desp-totais-di.val-desp,
                                INPUT de-valor-merc-di,
                                INPUT tt-di-totais.peso-total,
                                INPUT tt-di-totais.quantidade,
                                OUTPUT de-val-desp).

        FOR FIRST desp-imp NO-LOCK
            WHERE desp-imp.cod-desp = tt-adic-desp.cod-desp: END.
        
        FOR EACH tt-ordens-desp where tt-ordens-desp.num-di-ems = p-num-di-ems
                                  and tt-ordens-desp.num-adic   = tt-adic-desp.num-adic
                                  and tt-ordens-desp.cod-desp   = tt-adic-desp.cod-desp NO-LOCK:
                
                IF  tt-adic-totais.peso-total = 0 AND 
                   (desp-imp.tipo = 3 OR desp-imp.tipo = 9) THEN DO: /*peso ou cubagem*/
                    {utp/ut-liter.i "Peso_na_ordem" *}
                    run utp/ut-msgs.p (input "msg", input 265, input return-value).
                    ASSIGN c-desc-msg = TRIM(RETURN-VALUE).
                    {utp/ut-liter.i "Despesa_da_DI_configurada_como_Taxa_sobre_peso_ou_Taxa_sobre_cubagem. Despesa: " *}
        
                    CREATE RowErrors.
                    ASSIGN RowErrors.ErrorNumber      = 265
                           RowErrors.ErrorDescription = c-desc-msg
                           RowErrors.ErrorHelp        = TRIM(RETURN-VALUE) + STRING(desp-imp.cod-desp) + chr(10) + "Ordem: ":U + STRING(tt-ordens-desp.numero-ordem)
                           RowErrors.ErrorType        = "EMS":U
                           RowErrors.ErrorSubType     = "ERROR":U.
                END.
        END.

        IF de-val-desp = 0 OR de-val-desp = ? THEN DO:
            DELETE tt-adic-desp.
            NEXT.
        END.
                
        IF  l-create-desp-rateio 
            AND NOT CAN-FIND(FIRST tt-desp-rateio
                             WHERE tt-desp-rateio.num-di-ems = p-num-di-ems
                             AND   tt-desp-rateio.num-adic   = tt-adic-desp.num-adic
                             AND   tt-desp-rateio.cod-desp   = tt-adic-desp.cod-desp)THEN DO:
            create tt-desp-rateio.
            assign tt-desp-rateio.num-di-ems       = p-num-di-ems     
                   tt-desp-rateio.cod-desp         = tt-adic-desp.cod-desp
                   tt-desp-rateio.num-adic         = tt-adic-desp.num-adic
                   tt-desp-rateio.val-desp         = de-val-desp.
        END.
        ELSE
            FOR FIRST tt-desp-rateio
                WHERE tt-desp-rateio.num-di-ems    = p-num-di-ems
                AND   tt-desp-rateio.cod-desp      = tt-adic-desp.cod-desp        
                AND   tt-desp-rateio.num-adic      = tt-adic-desp.num-adic:
                ASSIGN tt-desp-rateio.val-desp     = de-val-desp.
            END.

        /*
        ** Despesa do tipo valor fixo
        */               
        if  desp-imp.tipo = 1 then
            assign tt-desp-rateio.val-desp-unit    = de-val-desp.

                       
        /*--- verifica se foi informada incoterm para alguma despesa ---*/
        IF  l-existe-incoterm THEN DO:
            /* Logica pra ratear as despesas que tem incoterm - CIF */
            IF CAN-FIND(FIRST desp-imp 
                        WHERE desp-imp.cod-desp       = tt-adic-desp.cod-desp
                          AND (   desp-imp.inc-val-frete  
                               OR desp-imp.inc-val-seguro 
                               OR desp-imp.inc-val-embal)) THEN DO:

                FIND FIRST tt-desp-cif
                     WHERE tt-desp-cif.num-di-ems = tt-adic-desp.num-di-ems
                       AND tt-desp-cif.num-adic   = tt-adic-desp.num-adic EXCLUSIVE-LOCK NO-ERROR.

                IF NOT AVAIL tt-desp-cif THEN DO:
                    CREATE tt-desp-cif.
                    ASSIGN tt-desp-cif.num-di-ems  = tt-adic-desp.num-di-ems 
                           tt-desp-cif.num-adic    = tt-adic-desp.num-adic 
                           tt-desp-cif.val-desp-mo = tt-desp-rateio.val-desp + tt-adic-totais.val-merc-adic
                           de-tot-siscomex-cif-mo  = de-tot-siscomex-cif-mo  + tt-desp-cif.val-desp-mo.
                           
                END.
                ELSE DO:
                    ASSIGN tt-desp-cif.val-desp-mo  = tt-desp-cif.val-desp-mo + tt-desp-rateio.val-desp
                           de-tot-siscomex-cif-mo   = de-tot-siscomex-cif-mo  + tt-desp-rateio.val-desp.

                END.
            END.

            FOR EACH tt-ordens-totais-incoterm:

                /*--- se a despesa que foi calculada fizer parte das despesas cadastradas para a incoterm,
                      encontra a taxa de rateio(tt-taxa-rateio.taxa-rateio) que ser† utilizada para calcular 
                      o novo valor da despesa que possui este incoterm. A taxa de rateio eh encontrada com base
                      na nova base de calculo, que eh o valor da mercadoria + despesa da incoterm ---*/
                IF  CAN-FIND(FIRST desp-incoterm
                             WHERE desp-incoterm.cod-incoterm = tt-ordens-totais-incoterm.cod-incoterm
                               AND desp-incoterm.cod-desp     = tt-adic-desp.cod-desp) THEN DO:

                       FIND FIRST tt-desp-totais-incoterm 
                            WHERE tt-desp-totais-incoterm.cod-incoterm = tt-ordens-totais-incoterm.cod-incoterm NO-ERROR.

                       IF  NOT AVAIL tt-desp-totais-incoterm THEN
                           NEXT.

                       FIND FIRST tt-taxa-rateio-adic
                            WHERE tt-taxa-rateio-adic.cod-incoterm = tt-ordens-totais-incoterm.cod-incoterm
                              AND tt-taxa-rateio-adic.num-adic = tt-desp-rateio.num-adic NO-ERROR.       

                       IF  NOT AVAIL tt-taxa-rateio-adic THEN
                           CREATE tt-taxa-rateio-adic.
                       else
                           assign tt-taxa-rateio-adic.val-desp-tot = 0.


                       ASSIGN tt-taxa-rateio-adic.cod-incoterm = tt-ordens-totais-incoterm.cod-incoterm
                              tt-taxa-rateio-adic.num-adic     = tt-desp-rateio.num-adic
                              tt-taxa-rateio-adic.val-desp-tot = tt-taxa-rateio-adic.val-desp-tot   + tt-desp-rateio.val-desp
                              tt-taxa-rateio-adic.taxa-rateio  = (tt-adic-totais.val-merc-adic + tt-taxa-rateio-adic.val-desp-tot) /
                                                                 (tt-di-totais.val-merc-di     + tt-desp-totais-incoterm.val-incoterm).
                       IF p-tipo-rateio = 1 THEN
                           RUN criaTotaisDespesasIncotermPorAdicao (INPUT tt-desp-totais-incoterm.cod-incoterm,
                                                                    INPUT tt-desp-rateio.num-adic,
                                                                    INPUT tt-desp-rateio.val-desp).

                END.
                /*--- verifica se na despesa calculada foi informado o mesmo incoterm de rateio que esta sendo
                      calculado. Despesas do tipo Valor Fixo nao serao rateadas, cfme orientacao da engenharia ---*/
                ELSE IF tt-adic-desp.cod-incoterm = tt-ordens-totais-incoterm.cod-incoterm
                     AND NOT l-desp-valor-fixo THEN DO:

                    FIND FIRST tt-taxa-rateio-adic
                         WHERE tt-taxa-rateio-adic.cod-incoterm = tt-ordens-totais-incoterm.cod-incoterm
                           AND tt-taxa-rateio-adic.num-adic     = tt-desp-rateio.num-adic NO-ERROR.

                    IF  AVAIL tt-taxa-rateio-adic THEN DO:
                        ASSIGN tt-desp-rateio.val-desp         = tt-desp-totais-di.val-desp * tt-taxa-rateio-adic.taxa-rateio
                               tt-desp-rateio.val-desp-unit    = tt-desp-rateio.val-desp / tt-adic-totais.qtd-do-forn.
                    END.
                END.
            END.
        END.
    END.

    /* Logica pra ratear as despesas que tem incoterm - CIF 
    ** (Valor CIF do item / Soma dos Valores CIF dos itens) * Valor da Despesa
    ** Valor CIF = valor da mercadoria + seguro + frete + embalagem
    **/
    IF l-existe-incoterm THEN DO:
        FOR EACH tt-desp-rateio EXCLUSIVE-LOCK:
            IF CAN-FIND(FIRST tt-adic-desp
                        WHERE tt-adic-desp.cod-desp      = tt-desp-rateio.cod-desp
                          AND tt-adic-desp.cod-incoterm  = "CIF":U)THEN DO:
                
                IF CAN-FIND(FIRST desp-imp
                            WHERE desp-imp.cod-desp = tt-desp-rateio.cod-desp
                              AND (    desp-imp.inc-val-frete 
                                   OR desp-imp.inc-val-seguro
                                   OR desp-imp.inc-val-embal
                                   OR desp-imp.tipo = 1 /*valor fixo*/)) THEN NEXT.

               FIND FIRST tt-desp-cif
                    WHERE tt-desp-cif.num-di-ems = tt-desp-rateio.num-di-ems
                      AND tt-desp-cif.num-adic   = tt-desp-rateio.num-adic NO-LOCK NO-ERROR.

               FIND FIRST tt-despesas
                    WHERE tt-despesas.cdn-despes = tt-desp-rateio.cod-desp NO-ERROR.

               IF  AVAIL tt-desp-cif 
               AND AVAIL tt-despesas THEN DO:

                   IF i-mo-codigo <> tt-despesas.cdn-moeda THEN DO:
    
                        RUN converteValorMoeda (INPUT decla-import.num-di-ems,
                                                INPUT decla-import.cdd-siscomex-dts,
                                                INPUT tt-despesas.cdn-moeda,
                                                INPUT i-mo-codigo,
                                                INPUT tt-despesas.val-despes,
                                                INPUT decla-import.dat-di,
                                                OUTPUT de-valor-despesa).
                    END.
                    ELSE 
                        ASSIGN de-valor-despesa = tt-despesas.val-despes.
                   
                   ASSIGN tt-desp-rateio.val-desp    = (tt-desp-cif.val-desp-mo / de-tot-siscomex-cif-mo) * de-valor-despesa.
               END.

            END.
            ELSE NEXT.
        END.
    END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraRateioDespesasItem DBOProgram 
PROCEDURE geraRateioDespesasItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-num-di-ems        LIKE {&TABLENAME}.num-di-ems        NO-UNDO.
    DEF INPUT PARAM p-cdd-siscomex-dts  LIKE {&TABLENAME}.cdd-siscomex-dts  NO-UNDO.
    DEF INPUT PARAM p-tipo-rateio       AS INTEGER                          NO-UNDO. /*ESSE PARAMETRO DEFINE EM QUAL ETAPA DO RATEIO SE ENCONTRA PARA */
    
    DEFINE VARIABLE c-desc-msg                  AS CHARACTER                     NO-UNDO.
    DEFINE VARIABLE l-create-desp-rateio-item   AS LOGICAL                       NO-UNDO.
    DEFINE VARIABLE l-desp-valor-fixo           AS LOGICAL                       NO-UNDO.
    DEFINE VARIABLE de-valor-rateado            like cotacao-item-cex.val-desp   NO-UNDO.
    DEFINE VARIABLE de-valor-rateado-mo         like cotacao-item-cex.val-desp   NO-UNDO.
    DEFINE VARIABLE i-num-adicao                like decla-import-ord.num-adic   no-undo.
    DEFINE VARIABLE de-tot-siscomex-cif         AS   DECIMAL                     NO-UNDO.   
    DEFINE VARIABLE de-tot-siscomex-cif-mo      AS   DECIMAL                     NO-UNDO.   
    
    empty temp-table tt-desp-cif-item.

    /* Gera valores rateados para as despesas */

    FOR FIRST decla-import NO-LOCK
        WHERE decla-import.num-di-ems = p-num-di-ems
          AND decla-import.cdd-siscomex-dts = p-cdd-siscomex-dts: END.

    FOR EACH tt-ordens-desp
        BY tt-ordens-desp.sequencia:

        assign de-val-desp          = 0
               l-create-desp-rateio-item = YES
               l-desp-valor-fixo    = NO.

        FIND param-imp
             WHERE param-imp.cod-estabel = tt-ordens-desp.cod-estabel NO-LOCK NO-ERROR.

        IF NOT AVAIL param-imp THEN DO:
            
            
            {utp/ut-liter.i "ParÉmetros_de_Importaá∆o" *}
            {method/svc/errors/inserr.i
                  &ErrorNumber="2"
                  &ErrorType="EMS"
                  &ErrorParameters=TRIM(RETURN-VALUE)}
                  
            IF VALID-HANDLE(h-acomp) THEN
                RUN pi-finalizar IN h-acomp.
        
            RETURN "NOK":U.
        END.
        
        FIND FIRST tt-desp-totais-adic
            WHERE tt-desp-totais-adic.num-di-ems = p-num-di-ems
              AND tt-desp-totais-adic.num-adic   = tt-ordens-desp.num-adic
              AND tt-desp-totais-adic.cod-desp   = tt-ordens-desp.cod-desp NO-ERROR.
        
        IF NOT AVAIL tt-desp-totais-adic THEN
            NEXT.

        /*POSICIONANDO NOS TOTAIS DA ADIÄ«O*/
        FOR FIRST tt-adic-totais
            WHERE tt-adic-totais.num-di-ems = p-num-di-ems
            AND   tt-adic-totais.num-adic   = tt-ordens-desp.num-adic: END.

        /*POSICIONANDO NOS TOTAIS DA ORDEM*/
        FOR FIRST tt-ordens-totais
            WHERE tt-ordens-totais.num-di-ems   = p-num-di-ems 
            AND   tt-ordens-totais.num-adic     = tt-ordens-desp.num-adic
            AND   tt-ordens-totais.numero-ordem = tt-ordens-desp.numero-ordem 
            AND   tt-ordens-totais.parcela      = tt-ordens-desp.parcela NO-LOCK: END.

        ASSIGN de-val-desp        = 0
               de-valor-merc-di   = 0
               de-valor-merc-adic = 0.

        IF p-tipo-rateio = 1 THEN
            ASSIGN de-valor-merc-adic = tt-adic-totais.val-merc-adic
                   de-valor-merc-item = tt-ordens-totais.val-merc.
        ELSE DO: 
            IF p-tipo-rateio = 2 THEN DO:  
                FOR FIRST tt-despesas
                    WHERE tt-despesas.cdn-despes = tt-ordens-desp.cod-desp 
                    AND   tt-despesas.num-adic   = tt-ordens-desp.num-adic
                    AND   tt-despesas.num-di-ems = tt-ordens-desp.num-di-ems: END.

                /*N∆o recalcular o frete*/
                IF AVAIL tt-despesas 
                AND  not tt-despesas.log-frete then do: 

                    ASSIGN l-create-desp-rateio-item = NO.
    
                    FOR FIRST decla-import-adic NO-LOCK
                        WHERE decla-import-adic.num-di-ems = p-num-di-ems 
                        AND   decla-import-adic.num-adic   = tt-ordens-desp.num-adic
                        AND   decla-import-adic.cdd-siscomex-dts = p-cdd-siscomex-dts:
                         /*
                          Se a despesa de frete comp‰e a incoterm, ent∆o deve deduzir proporcionalmente o valor do frete rateado anteriormente 
                          para que n∆o sobrecarregue o custo.
                         */
                        IF l-frete-incid-incoterm THEN
                            ASSIGN de-valor-merc-adic   = decla-import-adic.val-vmcv - decla-import-adic.val-frete.
                        ELSE
                            ASSIGN de-valor-merc-adic   = decla-import-adic.val-vmcv.
        
                        FOR FIRST decla-import-adic-itens NO-LOCK
                            WHERE decla-import-adic-itens.num-di-ems  = decla-import.num-di-ems
                            AND   decla-import-adic-itens.num-adic    = tt-ordens-desp.num-adic
                            AND   decla-import-adic-itens.num-ordem   = tt-ordens-desp.numero-ordem
                            AND   decla-import-adic-itens.num-parcela = tt-ordens-desp.parcela
                            AND   decla-import-adic-itens.cdd-siscomex-dts = decla-import.cdd-siscomex-dts:
                            IF l-frete-incid-incoterm THEN
                                ASSIGN de-valor-merc-item = decla-import-adic-itens.val-vmcv - decla-import-adic-itens.val-frete.
                            ELSE
                                ASSIGN de-valor-merc-item = decla-import-adic-itens.val-vmcv.
                        END.
                    END.
                end.
            END.    
        END.
        
        RUN calculaValorRateio (INPUT tt-ordens-desp.cod-desp,
                                INPUT de-valor-merc-item,
                                INPUT tt-ordens-totais.peso-total,
                                INPUT tt-ordens-totais.quantidade,
                                INPUT tt-desp-totais-adic.val-desp,
                                INPUT de-valor-merc-adic,
                                INPUT tt-adic-totais.peso-total,
                                INPUT tt-adic-totais.quantidade,
                                OUTPUT de-val-desp).

        FOR FIRST desp-imp NO-LOCK
            WHERE desp-imp.cod-desp = tt-ordens-desp.cod-desp: END.
        IF  tt-ordens-totais.peso-total = 0 AND 
           (desp-imp.tipo = 3 OR desp-imp.tipo = 9) THEN DO: /*peso ou cubagem*/
            {utp/ut-liter.i "Peso_na_ordem" *}
            run utp/ut-msgs.p (input "msg", input 265, input return-value).
            ASSIGN c-desc-msg = TRIM(RETURN-VALUE).
            {utp/ut-liter.i "Despesa_da_DI_configurada_como_Taxa_sobre_peso_ou_Taxa_sobre_cubagem. Despesa: " *}
            CREATE RowErrors.
            ASSIGN RowErrors.ErrorNumber      = 265
                   RowErrors.ErrorDescription = c-desc-msg
                   RowErrors.ErrorHelp        = TRIM(RETURN-VALUE) + STRING(desp-imp.cod-desp)+ chr(10) + "Ordem: ":U + string(tt-ordens-totais.numero-ordem)
                   RowErrors.ErrorType        = "EMS":U
                   RowErrors.ErrorSubType     = "ERROR":U.
        END.
        
        IF de-val-desp = 0 OR de-val-desp = ? THEN DO:
            DELETE tt-ordens-desp.
            NEXT.
        END.
                
        IF  l-create-desp-rateio-item 
            AND NOT CAN-FIND(FIRST tt-desp-rateio-item
                             WHERE tt-desp-rateio-item.num-di-ems   = p-num-di-ems
                             AND   tt-desp-rateio-item.num-adic     = tt-ordens-desp.num-adic
                             AND   tt-desp-rateio-item.numero-ordem = tt-ordens-desp.numero-ordem
                             AND   tt-desp-rateio-item.parcela      = tt-ordens-desp.parcela
                             AND   tt-desp-rateio-item.cod-desp     = tt-ordens-desp.cod-desp         ) THEN DO:
            create tt-desp-rateio-item.
            assign tt-desp-rateio-item.num-di-ems   = p-num-di-ems     
                   tt-desp-rateio-item.numero-ordem = tt-ordens-desp.numero-ordem
                   tt-desp-rateio-item.parcela      = tt-ordens-desp.parcela
                   tt-desp-rateio-item.cod-desp     = tt-ordens-desp.cod-desp
                   tt-desp-rateio-item.num-adic     = tt-ordens-desp.num-adic
                   tt-desp-rateio-item.val-desp     = de-val-desp
                   tt-desp-rateio-item.num-seq      = tt-ordens-totais.num-seq.
        END.
        ELSE
            FOR FIRST tt-desp-rateio-item
                WHERE tt-desp-rateio-item.num-di-ems    = p-num-di-ems
                AND   tt-desp-rateio-item.cod-desp      = tt-ordens-desp.cod-desp        
                AND   tt-desp-rateio-item.num-adic      = tt-ordens-desp.num-adic
                AND   tt-desp-rateio-item.numero-ordem  = tt-ordens-desp.numero-ordem
                AND   tt-desp-rateio-item.parcela       = tt-ordens-desp.parcela:
                ASSIGN tt-desp-rateio-item.val-desp     = de-val-desp.
            END.

        /*
        ** Despesa do tipo valor fixo
        */               
        if  desp-imp.tipo = 1 then
            assign tt-desp-rateio-item.val-desp-unit    = de-val-desp.

                       
        /*--- verifica se foi informada incoterm para 
              alguma despesa ---*/
        IF  l-existe-incoterm THEN DO:

            /***************************************************************************************************************/
            /* Logica pra ratear as despesas que tem incoterm - CIF */
            IF CAN-FIND(FIRST desp-imp 
                        WHERE desp-imp.cod-desp       = tt-ordens-desp.cod-desp
                          AND (   desp-imp.inc-val-frete  
                               OR desp-imp.inc-val-seguro 
                               OR desp-imp.inc-val-embal)) THEN DO:
                FIND FIRST tt-desp-cif-item
                     WHERE tt-desp-cif-item.num-di-ems   = tt-desp-rateio-item.num-di-ems
                       and tt-desp-cif-item.num-adic     = tt-desp-rateio-item.num-adic
                       and tt-desp-cif-item.numero-ordem = tt-ordens-desp.numero-ordem
                       AND tt-desp-cif-item.parcela      = tt-ordens-desp.parcela       EXCLUSIVE-LOCK NO-ERROR.

                IF NOT AVAIL tt-desp-cif-item THEN DO:
                    
                    CREATE tt-desp-cif-item.
                    ASSIGN tt-desp-cif-item.num-di-ems   = tt-desp-rateio-item.num-di-ems
                           tt-desp-cif-item.num-adic     = tt-desp-rateio-item.num-adic
                           tt-desp-cif-item.numero-ordem = tt-ordens-desp.numero-ordem
                           tt-desp-cif-item.parcela      = tt-ordens-desp.parcela     
                           tt-desp-cif-item.val-desp-mo  = tt-desp-rateio-item.val-desp    + tt-ordens-totais.val-merc 
                           tt-desp-cif-item.val-cif-item = tt-desp-cif-item.val-cif-item   + tt-desp-cif-item.val-desp-mo. 
                           
                END.
                ELSE DO:
                    ASSIGN tt-desp-cif-item.val-desp-mo  = tt-desp-cif-item.val-desp-mo  + tt-desp-rateio-item.val-desp
                           tt-desp-cif-item.val-cif-item = tt-desp-cif-item.val-cif-item + tt-desp-rateio-item.val-desp.
                END.
            END.

            FOR EACH tt-ordens-totais-incoterm:
                /*--- se a despesa que foi calculada fizer parte das despesas cadastradas para a incoterm,
                      encontra a taxa de rateio(tt-taxa-rateio.taxa-rateio) que ser† utilizada para calcular 
                      o novo valor da despesa que possui este incoterm. A taxa de rateio eh encontrada com base
                      na nova base de calculo, que eh o valor da mercadoria + despesa da incoterm ---*/
                IF  CAN-FIND(FIRST desp-incoterm
                             WHERE desp-incoterm.cod-incoterm = tt-ordens-totais-incoterm.cod-incoterm
                               AND desp-incoterm.cod-desp     = tt-ordens-desp.cod-desp) THEN DO:

                    FIND FIRST tt-desp-totais-incoterm-adic 
                         WHERE tt-desp-totais-incoterm-adic.cod-incoterm = tt-ordens-totais-incoterm.cod-incoterm
                           AND tt-desp-totais-incoterm-adic.num-adic     = tt-desp-rateio-item.num-adic NO-ERROR.

                   IF  NOT AVAIL tt-desp-totais-incoterm-adic THEN
                       NEXT.
    
                   FIND FIRST tt-taxa-rateio
                        WHERE tt-taxa-rateio.cod-incoterm = tt-ordens-totais-incoterm.cod-incoterm
                          AND tt-taxa-rateio.numero-ordem = tt-desp-rateio-item.numero-ordem NO-ERROR.       
    
                   IF  NOT AVAIL tt-taxa-rateio THEN
                       CREATE tt-taxa-rateio.
    
                   ASSIGN tt-taxa-rateio.cod-incoterm = tt-ordens-totais-incoterm.cod-incoterm
                          tt-taxa-rateio.numero-ordem = tt-desp-rateio-item.numero-ordem
                          tt-taxa-rateio.val-desp-tot = tt-taxa-rateio.val-desp-tot   + tt-desp-rateio-item.val-desp
                          tt-taxa-rateio.taxa-rateio  = (tt-ordens-totais.val-merc + tt-taxa-rateio.val-desp-tot) /
                                                        (tt-adic-totais.val-merc-adic  + tt-desp-totais-incoterm-adic.val-incoterm).

                END.
                /*--- verifica se na despesa calculada foi informado o mesmo incoterm de rateio que esta sendo
                      calculado. Despesas do tipo Valor Fixo nao serao rateadas, cfme orientacao da engenharia ---*/
                ELSE IF tt-ordens-desp.cod-incoterm = tt-ordens-totais-incoterm.cod-incoterm 
                     AND NOT l-desp-valor-fixo THEN DO:

                    FIND FIRST tt-taxa-rateio 
                         WHERE tt-taxa-rateio.cod-incoterm = tt-ordens-totais-incoterm.cod-incoterm
                           AND tt-taxa-rateio.numero-ordem = tt-desp-rateio-item.numero-ordem NO-ERROR.
                           
                    IF  AVAIL tt-taxa-rateio THEN
                        ASSIGN tt-desp-rateio-item.val-desp         = tt-desp-totais-adic.val-desp * tt-taxa-rateio.taxa-rateio
                               tt-desp-rateio-item.val-desp-unit    = tt-desp-rateio-item.val-desp / tt-ordens-totais.qtd-do-forn.
                END.
            END.    
        END.        
    END.            

     /* Logica pra ratear as despesas que tem incoterm - CIF 
    ** (Valor CIF do item / Soma dos Valores CIF dos itens) * Valor da Despesa
    ** Valor CIF = valor da mercadoria + seguro + frete + embalagem
    **/
    empty temp-table tt-desp-cif.

    for each tt-desp-cif-item:

        FIND FIRST tt-desp-cif
             WHERE tt-desp-cif.num-di-ems = tt-desp-cif-item.num-di-ems
               AND tt-desp-cif.num-adic   = tt-desp-cif-item.num-adic EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAIL tt-desp-cif THEN DO:
            CREATE tt-desp-cif.
            ASSIGN tt-desp-cif.num-di-ems  = tt-desp-cif-item.num-di-ems 
                   tt-desp-cif.num-adic    = tt-desp-cif-item.num-adic .
                   
                   
        END.
        assign tt-desp-cif.val-cif-mo = tt-desp-cif.val-cif-mo + tt-desp-cif-item.val-desp-mo.
    end.

    /* Logica pra ratear as despesas que tem incoterm - CIF 
    ** (Valor CIF do item / Soma dos Valores CIF dos itens) * Valor da Despesa
    ** Valor CIF = valor da mercadoria + seguro + frete + embalagem
    **/
    IF l-existe-incoterm THEN DO:
        FOR EACH tt-desp-rateio-item EXCLUSIVE-LOCK:
            IF CAN-FIND(FIRST tt-ordens-desp
                        WHERE tt-ordens-desp.cod-desp      = tt-desp-rateio-item.cod-desp
                          AND tt-ordens-desp.cod-incoterm  = "CIF":U)THEN DO:
                
                IF CAN-FIND(FIRST desp-imp
                            WHERE desp-imp.cod-desp = tt-desp-rateio-item.cod-desp
                              AND (    desp-imp.inc-val-frete 
                                   OR desp-imp.inc-val-seguro
                                   OR desp-imp.inc-val-embal
                                   OR desp-imp.tipo = 1 /*valor fixo*/)) THEN NEXT.

               FIND FIRST tt-desp-cif-item
                    WHERE tt-desp-cif-item.numero-ordem = tt-desp-rateio-item.numero-ordem
                      AND tt-desp-cif-item.parcela      = tt-desp-rateio-item.parcela NO-LOCK NO-ERROR.

               FIND FIRST tt-despesas
                    WHERE tt-despesas.cdn-despes = tt-desp-rateio-item.cod-desp
                      AND tt-despesas.num-adic = tt-desp-rateio-item.num-adic NO-ERROR.

               FIND FIRST tt-desp-cif
                    WHERE tt-desp-cif.num-di-ems = tt-desp-rateio-item.num-di-ems 
                      AND tt-desp-cif.num-adic   = tt-desp-rateio-item.num-adic   no-lock NO-ERROR.

                
               IF  avail tt-desp-cif 
               and AVAIL tt-desp-cif-item 
               AND AVAIL tt-despesas THEN DO:

                   IF i-mo-codigo <> tt-despesas.cdn-moeda THEN DO:
                        RUN converteValorMoeda (INPUT decla-import.num-di-ems,
                                                INPUT decla-import.cdd-siscomex-dts,
                                                INPUT tt-despesas.cdn-moeda,
                                                INPUT i-mo-codigo,
                                                INPUT tt-despesas.val-despes,
                                                INPUT decla-import.dat-di,
                                                OUTPUT de-valor-despesa).
                    END.
                    ELSE
                        ASSIGN de-valor-despesa = tt-despesas.val-despes.

                    ASSIGN tt-desp-rateio-item.val-desp = (tt-desp-cif-item.val-desp-mo / tt-desp-cif.val-cif-mo) * de-valor-despesa.

               END.
            END.
            ELSE NEXT.
        END.
    END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraRateioFrete DBOProgram 
PROCEDURE geraRateioFrete :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM p-num-di-ems   LIKE decla-import-ord.num-di-ems  NO-UNDO.
    DEF INPUT  PARAM p-cdd-siscomex-dts LIKE decla-import-ord.cdd-siscomex-dts NO-UNDO.

    FOR FIRST decla-import NO-LOCK
        WHERE decla-import.num-di-ems = p-num-di-ems
          AND decla-import.cdd-siscomex-dts = p-cdd-siscomex-dts,
        FIRST tt-di-totais
        WHERE tt-di-totais.num-di-ems = decla-import.num-di-ems:
        FOR EACH tt-adic-totais
            WHERE tt-adic-totais.num-di-ems = decla-import.num-di-ems :
            FOR FIRST tt-despesas
                WHERE tt-despesas.num-di-ems = decla-import.num-di-ems
                AND   tt-despesas.num-adic   = 0
                AND   tt-despesas.log-frete :
            
                ASSIGN de-val-desp      = 0
                       de-valor-despesa = 0.

                IF i-mo-codigo <> tt-despesas.cdn-moeda THEN DO:
    
                    RUN converteValorMoeda (INPUT decla-import.num-di-ems,
                                            INPUT decla-import.cdd-siscomex-dts,
                                            INPUT tt-despesas.cdn-moeda,
                                            INPUT i-mo-codigo,
                                            INPUT tt-despesas.val-despes,
                                            INPUT decla-import.dat-di,
                                            OUTPUT de-valor-despesa).
                END.
                ELSE 
                    ASSIGN de-valor-despesa = tt-despesas.val-despes.

                RUN calculaValorRateio (INPUT tt-despesas.cdn-despes,
                                        INPUT tt-adic-totais.val-merc-adic,
                                        INPUT tt-adic-totais.peso-total,
                                        INPUT tt-adic-totais.quantidade,
                                        INPUT de-valor-despesa,
                                        INPUT tt-di-totais.val-merc-di,
                                        INPUT tt-di-totais.peso-total,
                                        INPUT tt-di-totais.quantidade,
                                        OUTPUT de-val-desp).   
                IF de-val-desp <> 0 THEN DO:

                    FOR FIRST tt-desp-rateio
                        WHERE tt-desp-rateio.num-di-ems = decla-import.num-di-ems
                        AND   tt-desp-rateio.num-adic   = tt-adic-totais.num-adic
                        and   tt-desp-rateio.cod-desp   = tt-despesas.cdn-despes:
                        ASSIGN tt-desp-rateio.val-desp = de-val-desp.              
                    END.                                                           

                    FOR EACH decla-import-adic EXCLUSIVE-LOCK
                        WHERE decla-import-adic.num-di-ems = decla-import.num-di-ems
                        AND   decla-import-adic.num-adic   = tt-adic-totais.num-adic
                        AND   decla-import.cdd-siscomex-dts = decla-import.cdd-siscomex-dts:
                        ASSIGN decla-import-adic.val-frete = de-val-desp.             
                    END.
                END.
            END.
        END.
    END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraRateioFreteItem DBOProgram 
PROCEDURE geraRateioFreteItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM p-num-di-ems   LIKE decla-import-ord.num-di-ems  NO-UNDO.
    DEF INPUT  PARAM p-cdd-siscomex-dts LIKE decla-import-ord.cdd-siscomex-dts NO-UNDO.

    FOR EACH decla-import-adic NO-LOCK
        WHERE decla-import-adic.num-di-ems = p-num-di-ems
          AND decla-import-adic.cdd-siscomex-dts = p-cdd-siscomex-dts,
        FIRST tt-adic-totais
        WHERE tt-adic-totais.num-di-ems = decla-import-adic.num-di-ems
        AND   tt-adic-totais.num-adic   = decla-import-adic.num-adic,
        FIRST tt-di-totais
        WHERE tt-di-totais.num-di-ems = decla-import-adic.num-di-ems:

        FOR EACH tt-ordens-totais
            WHERE tt-ordens-totais.num-di-ems = decla-import-adic.num-di-ems 
            AND   tt-ordens-totais.num-adic   = decla-import-adic.num-adic:

            FOR FIRST tt-despesas
                WHERE tt-despesas.num-di-ems = decla-import-adic.num-di-ems
                AND   tt-despesas.num-adic   = decla-import-adic.num-adic
                AND   tt-despesas.log-frete:
            
                ASSIGN de-val-desp      = 0
                       de-valor-despesa = 0.
    
                IF i-mo-codigo <> tt-despesas.cdn-moeda 
                AND tt-despesas.i-tip-incid-nf = 1 THEN DO:
    
                    RUN converteValorMoeda (INPUT decla-import-adic.num-di-ems,
                                            INPUT decla-import-adic.cdd-siscomex-dts,
                                            INPUT tt-despesas.cdn-moeda,
                                            INPUT i-mo-codigo,
                                            INPUT decla-import-adic.val-frete,
                                            INPUT decla-import.dat-di,
                                            OUTPUT de-valor-despesa).
    
                    
                END.
                ELSE 
                    ASSIGN de-valor-despesa = decla-import-adic.val-frete.

                RUN calculaValorRateio (INPUT tt-despesas.cdn-despes,
                                        INPUT tt-ordens-totais.val-merc,
                                        INPUT tt-ordens-totais.peso-total,
                                        INPUT tt-ordens-totais.quantidade,
                                        INPUT de-valor-despesa,
                                        INPUT tt-adic-totais.val-merc-adic,
                                        INPUT tt-adic-totais.peso-total,
                                        INPUT tt-adic-totais.quantidade,
                                        OUTPUT de-val-desp).   

                IF de-val-desp <> 0 THEN DO:

                    FOR FIRST tt-desp-rateio-item
                        WHERE tt-desp-rateio-item.num-di-ems   = tt-ordens-totais.num-di-ems
                        AND   tt-desp-rateio-item.num-adic     = tt-ordens-totais.num-adic 
                        AND   tt-desp-rateio-item.numero-ordem = tt-ordens-totais.numero-ordem
                        AND   tt-desp-rateio-item.parcela      = tt-ordens-totais.parcela
                        AND   tt-desp-rateio-item.cod-desp     = tt-despesas.cdn-despes:
                        ASSIGN tt-desp-rateio-item.val-desp = de-val-desp.   
                    END.        

                    FOR FIRST decla-import-adic-itens EXCLUSIVE-LOCK
                        WHERE decla-import-adic-itens.num-di-ems   = tt-ordens-totais.num-di-ems
                        AND   decla-import-adic-itens.num-adic     = tt-ordens-totais.num-adic 
                        AND   decla-import-adic-itens.num-ordem    = tt-ordens-totais.numero-ordem
                        AND   decla-import-adic-itens.num-parcela  = tt-ordens-totais.parcela:

                        ASSIGN decla-import-adic-itens.val-frete      = de-val-desp
                               decla-import-adic-itens.cdn-moed-frete = tt-despesas.cdn-moeda.
                    END.
                END.
            END.
        END.
    END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraTtByIncoterm DBOProgram 
PROCEDURE geraTtByIncoterm :
/*------------------------------------------------------------------------------
  Purpose:     Gera as temp-tables relacionadas a incoterm de rateio
  Parameters:  p-num-di-ems - N£mero interno da DI - inteiro
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-num-di-ems LIKE {&TABLENAME}.num-di-ems NO-UNDO.
    DEF INPUT PARAM p-cdd-siscomex-dts LIKE {&TABLENAME}.cdd-siscomex-dts NO-UNDO.

    EMPTY TEMP-TABLE tt-desp-totais-incoterm.
    EMPTY TEMP-TABLE tt-ordens-totais-incoterm.
    
    FOR EACH inco-cx NO-LOCK:
        CREATE tt-desp-totais-incoterm.
        ASSIGN tt-desp-totais-incoterm.num-di-ems   = p-num-di-ems
               tt-desp-totais-incoterm.cod-incoterm = inco-cx.cod-incoterm.

        /*Busca todas as despesas vinculadas a incoterm para montar o valor da incoterm*/
        FOR EACH tt-desp-totais-di NO-LOCK
           WHERE tt-desp-totais-di.num-di-ems = p-num-di-ems:
            IF  CAN-FIND(FIRST desp-incoterm
                         WHERE desp-incoterm.cod-incoterm = tt-desp-totais-incoterm.cod-incoterm
                         AND   desp-incoterm.cod-desp     = tt-desp-totais-di.cod-desp) THEN DO:
                ASSIGN tt-desp-totais-incoterm.val-incoterm = tt-desp-totais-incoterm.val-incoterm + tt-desp-totais-di.val-desp.
            END.
        END.
    END.

    FOR EACH inco-cx NO-LOCK:
        CREATE tt-ordens-totais-incoterm.
        ASSIGN tt-ordens-totais-incoterm.num-di-ems   = p-num-di-ems
               tt-ordens-totais-incoterm.cod-incoterm = inco-cx.cod-incoterm.
    END.

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
        WHEN "cod-conhecto-house":U THEN ASSIGN pFieldValue = RowObject.cod-conhecto-house.
        WHEN "cod-conhecto-master":U THEN ASSIGN pFieldValue = RowObject.cod-conhecto-master.
        WHEN "cod-di-siscomex":U THEN ASSIGN pFieldValue = RowObject.cod-di-siscomex.
        WHEN "cod-estab":U THEN ASSIGN pFieldValue = RowObject.cod-estab.
        WHEN "cod-identif":U THEN ASSIGN pFieldValue = RowObject.cod-identif.
        WHEN "cod-inf-compltar":U THEN ASSIGN pFieldValue = RowObject.cod-inf-compltar.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-natur-operac":U THEN ASSIGN pFieldValue = RowObject.cod-natur-operac.
        WHEN "des-checksum":U THEN ASSIGN pFieldValue = RowObject.des-checksum.
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
        WHEN "dat-di":U THEN ASSIGN pFieldValue = RowObject.dat-di.
        WHEN "dat-livre-1":U THEN ASSIGN pFieldValue = RowObject.dat-livre-1.
        WHEN "dat-livre-2":U THEN ASSIGN pFieldValue = RowObject.dat-livre-2.
        WHEN "dat-retif":U THEN ASSIGN pFieldValue = RowObject.dat-retif.
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
        WHEN "val-acresc":U THEN ASSIGN pFieldValue = RowObject.val-acresc.
        WHEN "val-acresc-me[1]":U THEN ASSIGN pFieldValue = RowObject.val-acresc-me[1].
        WHEN "val-acresc-me[2]":U THEN ASSIGN pFieldValue = RowObject.val-acresc-me[2].
        WHEN "val-base-cofins":U THEN ASSIGN pFieldValue = RowObject.val-base-cofins.
        WHEN "val-base-icms":U THEN ASSIGN pFieldValue = RowObject.val-base-icms.
        WHEN "val-base-ii":U THEN ASSIGN pFieldValue = RowObject.val-base-ii.
        WHEN "val-base-ipi":U THEN ASSIGN pFieldValue = RowObject.val-base-ipi.
        WHEN "val-base-pis":U THEN ASSIGN pFieldValue = RowObject.val-base-pis.
        WHEN "val-cofins-db-cr":U THEN ASSIGN pFieldValue = RowObject.val-cofins-db-cr.
        WHEN "val-cofins-nao-tributad":U THEN ASSIGN pFieldValue = RowObject.val-cofins-nao-tributad.
        WHEN "val-cofins-outras":U THEN ASSIGN pFieldValue = RowObject.val-cofins-outras.
        WHEN "val-despes-compltar":U THEN ASSIGN pFieldValue = RowObject.val-despes-compltar.
        WHEN "val-despes-compltar-me[1]":U THEN ASSIGN pFieldValue = RowObject.val-despes-compltar-me[1].
        WHEN "val-despes-compltar-me[2]":U THEN ASSIGN pFieldValue = RowObject.val-despes-compltar-me[2].
        WHEN "val-despes-di":U THEN ASSIGN pFieldValue = RowObject.val-despes-di.
        WHEN "val-despes-di-me[1]":U THEN ASSIGN pFieldValue = RowObject.val-despes-di-me[1].
        WHEN "val-despes-di-me[2]":U THEN ASSIGN pFieldValue = RowObject.val-despes-di-me[2].
        WHEN "val-despes-nac":U THEN ASSIGN pFieldValue = RowObject.val-despes-nac.
        WHEN "val-despes-nac-me[1]":U THEN ASSIGN pFieldValue = RowObject.val-despes-nac-me[1].
        WHEN "val-despes-nac-me[2]":U THEN ASSIGN pFieldValue = RowObject.val-despes-nac-me[2].
        WHEN "val-frete":U THEN ASSIGN pFieldValue = RowObject.val-frete.
        WHEN "val-frete-me[1]":U THEN ASSIGN pFieldValue = RowObject.val-frete-me[1].
        WHEN "val-frete-me[2]":U THEN ASSIGN pFieldValue = RowObject.val-frete-me[2].
        WHEN "val-icms-db-cr":U THEN ASSIGN pFieldValue = RowObject.val-icms-db-cr.
        WHEN "val-icms-nao-tributad":U THEN ASSIGN pFieldValue = RowObject.val-icms-nao-tributad.
        WHEN "val-icms-outras":U THEN ASSIGN pFieldValue = RowObject.val-icms-outras.
        WHEN "val-ii-db-cr":U THEN ASSIGN pFieldValue = RowObject.val-ii-db-cr.
        WHEN "val-ii-nao-tribut":U THEN ASSIGN pFieldValue = RowObject.val-ii-nao-tribut.
        WHEN "val-ii-outras":U THEN ASSIGN pFieldValue = RowObject.val-ii-outras.
        WHEN "val-ipi-db-cr":U THEN ASSIGN pFieldValue = RowObject.val-ipi-db-cr.
        WHEN "val-ipi-nao-tributad":U THEN ASSIGN pFieldValue = RowObject.val-ipi-nao-tributad.
        WHEN "val-ipi-outras":U THEN ASSIGN pFieldValue = RowObject.val-ipi-outras.
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
        WHEN "val-peso-brut-merc":U THEN ASSIGN pFieldValue = RowObject.val-peso-brut-merc.
        WHEN "val-peso-brut-tot-di":U THEN ASSIGN pFieldValue = RowObject.val-peso-brut-tot-di.
        WHEN "val-peso-embal-di":U THEN ASSIGN pFieldValue = RowObject.val-peso-embal-di.
        WHEN "val-peso-liq-di":U THEN ASSIGN pFieldValue = RowObject.val-peso-liq-di.
        WHEN "val-pis-db-cr":U THEN ASSIGN pFieldValue = RowObject.val-pis-db-cr.
        WHEN "val-pis-nao-tributad":U THEN ASSIGN pFieldValue = RowObject.val-pis-nao-tributad.
        WHEN "val-pis-outras":U THEN ASSIGN pFieldValue = RowObject.val-pis-outras.
        WHEN "val-seguro":U THEN ASSIGN pFieldValue = RowObject.val-seguro.
        WHEN "val-seguro-me[1]":U THEN ASSIGN pFieldValue = RowObject.val-seguro-me[1].
        WHEN "val-seguro-me[2]":U THEN ASSIGN pFieldValue = RowObject.val-seguro-me[2].
        WHEN "val-vmcv":U THEN ASSIGN pFieldValue = RowObject.val-vmcv.
        WHEN "val-vmcv-me[1]":U THEN ASSIGN pFieldValue = RowObject.val-vmcv-me[1].
        WHEN "val-vmcv-me[2]":U THEN ASSIGN pFieldValue = RowObject.val-vmcv-me[2].
        WHEN "val-vmld":U THEN ASSIGN pFieldValue = RowObject.val-vmld.
        WHEN "val-vmld-me[1]":U THEN ASSIGN pFieldValue = RowObject.val-vmld-me[1].
        WHEN "val-vmld-me[2]":U THEN ASSIGN pFieldValue = RowObject.val-vmld-me[2].
        WHEN "val-vmle":U THEN ASSIGN pFieldValue = RowObject.val-vmle.
        WHEN "val-vmle-me[1]":U THEN ASSIGN pFieldValue = RowObject.val-vmle-me[1].
        WHEN "val-vmle-me[2]":U THEN ASSIGN pFieldValue = RowObject.val-vmle-me[2].
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getEmbarquesGerados DBOProgram 
PROCEDURE getEmbarquesGerados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF OUTPUT PARAM TABLE FOR tt-embarques-gerados.

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
        WHEN "cdn-agent-carg-import":U THEN ASSIGN pFieldValue = RowObject.cdn-agent-carg-import.
        WHEN "cdn-consign":U THEN ASSIGN pFieldValue = RowObject.cdn-consign.
        WHEN "cdn-itiner":U THEN ASSIGN pFieldValue = RowObject.cdn-itiner.
        WHEN "cdn-msg-di":U THEN ASSIGN pFieldValue = RowObject.cdn-msg-di.
        WHEN "cdn-pais-proceden":U THEN ASSIGN pFieldValue = RowObject.cdn-pais-proceden.
        WHEN "cdn-recinto-alfand":U THEN ASSIGN pFieldValue = RowObject.cdn-recinto-alfand.
        WHEN "cdn-setor-armaz":U THEN ASSIGN pFieldValue = RowObject.cdn-setor-armaz.
        WHEN "cdn-transpdor":U THEN ASSIGN pFieldValue = RowObject.cdn-transpdor.
        WHEN "cdn-urf-despch":U THEN ASSIGN pFieldValue = RowObject.cdn-urf-despch.
        WHEN "cdn-urf-entr":U THEN ASSIGN pFieldValue = RowObject.cdn-urf-entr.
        WHEN "cdn-via-transp-di":U THEN ASSIGN pFieldValue = RowObject.cdn-via-transp-di.
        WHEN "idi-caract-operac":U THEN ASSIGN pFieldValue = RowObject.idi-caract-operac.
        WHEN "idi-docto-carg":U THEN ASSIGN pFieldValue = RowObject.idi-docto-carg.
        WHEN "idi-ind-utiliz":U THEN ASSIGN pFieldValue = RowObject.idi-ind-utiliz.
        WHEN "idi-modalid-despch":U THEN ASSIGN pFieldValue = RowObject.idi-modalid-despch.
        WHEN "idi-motiv-retif":U THEN ASSIGN pFieldValue = RowObject.idi-motiv-retif.
        WHEN "idi-tip-conhecto":U THEN ASSIGN pFieldValue = RowObject.idi-tip-conhecto.
        WHEN "idi-tip-decla-import":U THEN ASSIGN pFieldValue = RowObject.idi-tip-decla-import.
        WHEN "idi-via-transp-di":U THEN ASSIGN pFieldValue = RowObject.idi-via-transp-di.
        WHEN "num-adicoes":U THEN ASSIGN pFieldValue = RowObject.num-adicoes.
        WHEN "num-di-ems":U THEN ASSIGN pFieldValue = RowObject.num-di-ems.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "num-seq-retif":U THEN ASSIGN pFieldValue = RowObject.num-seq-retif.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice dclmprt-id
  Parameters:  
               retorna valor do campo num-di-ems
               retorna valor do campo num-seq-retif
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnum-di-ems LIKE decla-import.num-di-ems NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-seq-retif LIKE decla-import.num-seq-retif NO-UNDO.
    DEFINE OUTPUT PARAMETER pcdd-siscomex-dts LIKE decla-import.cdd-siscomex-dts NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnum-di-ems = RowObject.num-di-ems
           pnum-seq-retif = RowObject.num-seq-retif
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
        WHEN "log-ativo":U THEN ASSIGN pFieldValue = RowObject.log-ativo.
        WHEN "log-fundap":U THEN ASSIGN pFieldValue = RowObject.log-fundap.
        WHEN "log-livre-1":U THEN ASSIGN pFieldValue = RowObject.log-livre-1.
        WHEN "log-livre-2":U THEN ASSIGN pFieldValue = RowObject.log-livre-2.
        WHEN "log-multimod":U THEN ASSIGN pFieldValue = RowObject.log-multimod.
        WHEN "log-pend-rat":U THEN ASSIGN pFieldValue = RowObject.log-pend-rat.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTTdesp-rateio-item DBOProgram 
PROCEDURE getTTdesp-rateio-item :
/*:T------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEF OUTPUT PARAM TABLE FOR tt-desp-rateio-item.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice dclmprt-id
  Parameters:  
               recebe valor do campo num-di-ems
               recebe valor do campo num-seq-retif
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnum-di-ems LIKE decla-import.num-di-ems NO-UNDO.
    DEFINE INPUT PARAMETER pnum-seq-retif LIKE decla-import.num-seq-retif NO-UNDO.
    DEFINE INPUT PARAMETER pcdd-siscomex-dts LIKE decla-import.cdd-siscomex-dts NO-UNDO.

    FIND FIRST bfdecla-import WHERE 
        bfdecla-import.num-di-ems = pnum-di-ems AND 
        bfdecla-import.num-seq-retif = pnum-seq-retif AND 
        bfdecla-import.cdd-siscomex-dts = pcdd-siscomex-dts NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfdecla-import THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfdecla-import)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gravaImpostosItens DBOProgram 
PROCEDURE gravaImpostosItens :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FOR EACH decla-import-adic-itens EXCLUSIVE-LOCK
            WHERE decla-import-adic-itens.num-di-ems =  decla-import-adic.num-di-ems
            AND   decla-import-adic-itens.num-adic   = decla-import-adic.num-adic
            AND   decla-import-adic-itens.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts:
    
        ASSIGN decla-import-adic-itens.idi-tributac-cofins         = decla-import-adic.idi-tributac-cofins
               decla-import-adic-itens.idi-tributac-icms           = decla-import-adic.idi-tributac-icms
               decla-import-adic-itens.idi-tributac-impto-import   = decla-import-adic.idi-tributac-impto-import
               decla-import-adic-itens.idi-tributac-ipi            = decla-import-adic.idi-tributac-ipi
               decla-import-adic-itens.idi-tributac-pis            = decla-import-adic.idi-tributac-pis
    
               decla-import-adic-itens.log-cofins-unid             = decla-import-adic.log-cofins-unid
               decla-import-adic-itens.log-ipi-unid                = decla-import-adic.log-ipi-unid
               decla-import-adic-itens.log-pis-unid                = decla-import-adic.log-pis-unid
               decla-import-adic-itens.log-suspens-impto-import    = decla-import-adic.log-suspens-impto-import
               decla-import-adic-itens.log-suspens-ipi-import      = decla-import-adic.log-suspens-ipi-import
    
               decla-import-adic-itens.val-aliq-cofins             = decla-import-adic.val-aliq-cofins
               decla-import-adic-itens.val-aliq-icms               = decla-import-adic.val-aliq-icms
               decla-import-adic-itens.val-aliq-ii                 = decla-import-adic.val-aliq-ii
               decla-import-adic-itens.val-aliq-pis                = decla-import-adic.val-aliq-pis
               decla-import-adic-itens.val-aliq-pis                = decla-import-adic.val-aliq-pis
    
               decla-import-adic-itens.val-perc-reduc-cofins       = decla-import-adic.val-perc-reduc-cofins
               decla-import-adic-itens.val-perc-reduc-icms         = decla-import-adic.val-perc-reduc-icms
               decla-import-adic-itens.val-perc-reduc-impto-import = decla-import-adic.val-perc-reduc-impto-import
               decla-import-adic-itens.val-perc-reduc-ipi          = decla-import-adic.val-perc-reduc-ipi
               decla-import-adic-itens.val-perc-reduc-pis          = decla-import-adic.val-perc-reduc-pis.
        
    END. /* for each decla-import-adic-itens */
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE limpaTbWt DBOProgram 
PROCEDURE limpaTbWt :
/*:T------------------------------------------------------------------------------
  Purpose:     eliminar os registros da tb-wt-docto, tb-wt-it-docto, tb-wt-it-imposto,
               tb-ct-trib-wt-item-docto e ct-trib-wt-item-docto
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE tb-wt-docto.
    EMPTY TEMP-TABLE tb-wt-it-docto.
    EMPTY TEMP-TABLE tb-wt-it-imposto.
    EMPTY TEMP-TABLE tb-wt-it-impostoCBSIBS.
    EMPTY TEMP-TABLE tb-ct-trib-wt-item-docto.
    
    RETURN "OK":U.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ordenaTtAdicDesp DBOProgram 
PROCEDURE ordenaTtAdicDesp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
*
* Objetivo: Ordernas as despesas das ordens de modo que fiquem 
*           da seguinte forma:
*           1.  As despesas rateadas por peso, quantidade, cubagem 
*               e as despesas rateadas por valor sem incoterm de rateio 
*               (com exceá∆o dos impostos) dever∆o possuir as primeiras 
*               seqùàncias.
*           2.  As pr¢ximas despesas a serem seqùenciadas, ser∆o as 
*               despesas rateadas por valor com incoterm de rateio.
*------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-num-di-ems LIKE {&TABLENAME}.num-di-ems NO-UNDO.
    DEF INPUT PARAM p-cdd-siscomex-dts LIKE {&TABLENAME}.cdd-siscomex-dts NO-UNDO.

    DEF VAR i-sequencia AS INT NO-UNDO.

    /* despesas que nao sao impostos e nao
       possuem incoterm */
    FOR EACH  tt-adic-desp
        WHERE tt-adic-desp.sequencia = 0
          AND tt-adic-desp.num-di-ems = p-num-di-ems
          AND tt-adic-desp.cod-incoterm = "":

          FOR FIRST param-imp FIELDS(char-1 cdn-despes-impto-ipi cdn-despes-impto-pis 
                                     cdn-despes-impto-cofins cdn-despes-impto-icms) NO-LOCK
              WHERE param-imp.cod-estabel = tt-adic-desp.cod-estabel: END.

          IF  AVAIL param-imp
          AND tt-adic-desp.cod-desp <> int(substr(param-imp.char-1,21,20))
          AND tt-adic-desp.cod-desp <> param-imp.cdn-despes-impto-ipi
          AND tt-adic-desp.cod-desp <> param-imp.cdn-despes-impto-pis
          AND tt-adic-desp.cod-desp <> param-imp.cdn-despes-impto-cofins
          AND tt-adic-desp.cod-desp <> param-imp.cdn-despes-impto-icms THEN
              ASSIGN i-sequencia = i-sequencia + 1
                     tt-adic-desp.sequencia = i-sequencia.
    END.

    /* despesas que nao sao impostos e 
       possuem incoterm */
    FOR EACH  tt-adic-desp
        WHERE tt-adic-desp.sequencia = 0
          AND tt-adic-desp.num-di-ems = p-num-di-ems
          AND tt-adic-desp.cod-incoterm <> "":

        FOR FIRST param-imp FIELDS(char-1 cdn-despes-impto-ipi cdn-despes-impto-pis 
                                   cdn-despes-impto-cofins cdn-despes-impto-icms) NO-LOCK
            WHERE param-imp.cod-estabel = tt-adic-desp.cod-estabel: END.

        IF  AVAIL param-imp
          AND tt-adic-desp.cod-desp <> int(substr(param-imp.char-1,21,20))
          AND tt-adic-desp.cod-desp <> param-imp.cdn-despes-impto-ipi
          AND tt-adic-desp.cod-desp <> param-imp.cdn-despes-impto-pis
          AND tt-adic-desp.cod-desp <> param-imp.cdn-despes-impto-cofins
          AND tt-adic-desp.cod-desp <> param-imp.cdn-despes-impto-icms THEN
            ASSIGN i-sequencia = i-sequencia + 1
                   tt-adic-desp.sequencia = i-sequencia.
    END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ordenaTtOrdensDesp DBOProgram 
PROCEDURE ordenaTtOrdensDesp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
*
* Objetivo: Ordernas as despesas das ordens de modo que fiquem 
*           da seguinte forma:
*           1.  As despesas rateadas por peso, quantidade, cubagem 
*               e as despesas rateadas por valor sem incoterm de rateio 
*               (com exceá∆o dos impostos) dever∆o possuir as primeiras 
*               seqùàncias.
*           2.  As pr¢ximas despesas a serem seqùenciadas, ser∆o as 
*               despesas rateadas por valor com incoterm de rateio.
*------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-num-di-ems        LIKE {&TABLENAME}.num-di-ems NO-UNDO.
    
    DEF VAR i-sequencia AS INT NO-UNDO.

    /* despesas que nao sao impostos e nao
       possuem incoterm */
    FOR EACH  tt-ordens-desp
        WHERE tt-ordens-desp.sequencia = 0
          AND tt-ordens-desp.num-di-ems = p-num-di-ems
          AND tt-ordens-desp.cod-incoterm = "":                                      

          FOR FIRST param-imp FIELDS(char-1 cdn-despes-impto-ipi cdn-despes-impto-pis 
                                     cdn-despes-impto-cofins cdn-despes-impto-icms) NO-LOCK
              WHERE param-imp.cod-estabel = tt-ordens-desp.cod-estabel: END.

          IF  AVAIL param-imp
          AND tt-ordens-desp.cod-desp <> int(substr(param-imp.char-1,21,20))
          AND tt-ordens-desp.cod-desp <> param-imp.cdn-despes-impto-ipi
          AND tt-ordens-desp.cod-desp <> param-imp.cdn-despes-impto-pis
          AND tt-ordens-desp.cod-desp <> param-imp.cdn-despes-impto-cofins
          AND tt-ordens-desp.cod-desp <> param-imp.cdn-despes-impto-icms THEN
              ASSIGN i-sequencia = i-sequencia + 1
                     tt-ordens-desp.sequencia = i-sequencia.
    END.

    /* despesas que nao sao impostos e 
       possuem incoterm */
    FOR EACH  tt-ordens-desp
        WHERE tt-ordens-desp.sequencia = 0
          AND tt-ordens-desp.num-di-ems = p-num-di-ems
          AND tt-ordens-desp.cod-incoterm <> "":

        FOR FIRST param-imp FIELDS(char-1 cdn-despes-impto-ipi cdn-despes-impto-pis 
                                   cdn-despes-impto-cofins cdn-despes-impto-icms) NO-LOCK
            WHERE param-imp.cod-estabel = tt-ordens-desp.cod-estabel: END.

        IF  AVAIL param-imp
          AND tt-ordens-desp.cod-desp <> int(substr(param-imp.char-1,21,20))
          AND tt-ordens-desp.cod-desp <> param-imp.cdn-despes-impto-ipi
          AND tt-ordens-desp.cod-desp <> param-imp.cdn-despes-impto-pis
          AND tt-ordens-desp.cod-desp <> param-imp.cdn-despes-impto-cofins
          AND tt-ordens-desp.cod-desp <> param-imp.cdn-despes-impto-icms THEN
            ASSIGN i-sequencia = i-sequencia + 1
                   tt-ordens-desp.sequencia = i-sequencia.
    END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piEnviaConfigurTribut DBOProgram 
PROCEDURE piEnviaConfigurTribut :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR l-procedimento-ok     AS LOGICAL                                 NO-UNDO.
    
    IF NOT VALID-HANDLE(h-bodi317im2bra) THEN
        RUN dibo/bodi317im2bra PERSISTEN SET h-bodi317im2bra.

    /*Configurador de Tributos*/
    IF NOT VALID-HANDLE(h-bodi613calc2) THEN
        RUN dibo/bodi613calc2.p PERSISTENT SET h-bodi613calc2.
    
    run piEnviaNumDIEMS          in h-bodi613calc2 (input decla-import-adic-itens.num-di-ems,
                                                    input decla-import-adic-itens.num-adic,
                                                    input decla-import-adic-itens.num-seq,
                                                    INPUT decla-import-adic-itens.cdd-siscomex-dts).
    
    run enviaTbWtDocto           in h-bodi613calc2 (input table tb-wt-docto).            
    run enviaTbWtItDocto         in h-bodi613calc2 (input table tb-wt-it-docto).            
    run enviaTbWtItImposto       in h-bodi613calc2 (input table tb-wt-it-imposto).
    run enviaTbWtItImpostoCBSIBS in h-bodi613calc2 (input table tb-wt-it-impostoCBSIBS).
    
    run enviaTbWtDocto           in h-bodi317im2bra (input table tb-wt-docto).
    run enviaTbWtItDocto         in h-bodi317im2bra (input table tb-wt-it-docto).            
    run enviaTbWtItImposto       in h-bodi317im2bra (input table tb-wt-it-imposto).            

    /* posicionar registros */
    RUN localizaWtDocto in h-bodi317im2bra ( input 1,
                                             output l-procedimento-ok ).

    RUN localizaWtDocto in h-bodi613calc2  ( input 1,
                                             output l-procedimento-ok ).

    if  not l-procedimento-ok then do:
        delete procedure h-bodi613calc2.
        RETURN "NOK":U.
    end.

    RUN pi-recebe-handle in h-bodi317im2bra (input "h-bodi613calc2":U,
                                             input h-bodi613calc2).
    
    RUN trataConfigTributos in h-bodi317im2bra.
    
    /* retornar temp-table */       
    run retornaTbCtTribWtItemDocto in h-bodi613calc2 ( output table tb-ct-trib-wt-item-docto ).
    run retornaTbWtItImposto       in h-bodi613calc2 ( output table tb-wt-it-imposto ). 
    
    
    IF VALID-HANDLE(h-bodi317im2bra) THEN DO:
        DELETE PROCEDURE h-bodi317im2bra.
        ASSIGN h-bodi317im2bra = ?.
    END.

    IF VALID-HANDLE(h-bodi613calc2) THEN DO:
        DELETE PROCEDURE h-bodi613calc2.
        ASSIGN h-bodi613calc2 = ?.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piEnviaTemp-tables DBOProgram 
PROCEDURE piEnviaTemp-tables :
/*------------------------------------------------------------------------------
  Purpose:     Recebe as temp-tables tt-desp-rateio-item e tt-despesas criadas na imapi017
  Parameters:  tt-desp-rateio-item: temp-table contendo os valores rateados das despesas a n°vel de item (tipo: entrada)
               tt-despesas: temp-table contendo os valores das despesas da DI (tipo: entrada)
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER TABLE FOR tt-desp-rateio.
    DEFINE INPUT PARAMETER TABLE FOR tt-desp-rateio-item.
    DEFINE INPUT PARAMETER TABLE FOR tt-despesas.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piLimpaValoresAcresc DBOProgram 
PROCEDURE piLimpaValoresAcresc :
/*------------------------------------------------------------------------------
  Purpose:     Recebe o n£mero da DI-EMS e limpa os valores de AcrÇscimo que ser∆o recalculados
  Parameters:  p-num-di-ems (entrada): n£mero da DI-EMS (integer)
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAMETER p-num-di-ems   LIKE decla-import-ord.num-di-ems  NO-UNDO.
    DEF INPUT PARAMETER p-cdd-siscomex-dts LIKE decla-import-ord.cdd-siscomex-dts NO-UNDO.

    
    FOR FIRST decla-import EXCLUSIVE-LOCK
        WHERE decla-import.num-di-ems = p-num-di-ems
          AND decla-import.cdd-siscomex-dts = p-cdd-siscomex-dts:
    
        ASSIGN decla-import.val-acresc = 0
               decla-import.val-acresc-me[1] = 0
               decla-import.val-acresc-me[2] = 0.
    
        FOR EACH decla-import-adic EXCLUSIVE-LOCK
            WHERE decla-import-adic.num-di-ems = decla-import.num-di-ems 
              AND decla-import-adic.cdd-siscomex-dts = decla-import.cdd-siscomex-dts:
    
            ASSIGN decla-import-adic.val-acresc       = 0
                   decla-import-adic.val-acresc-me[1] = 0
                   decla-import-adic.val-acresc-me[2] = 0.
    
            FOR EACH decla-import-adic-itens EXCLUSIVE-LOCK
                WHERE decla-import-adic-itens.num-di-ems = decla-import-adic.num-di-ems
                AND   decla-import-adic-itens.num-adic   = decla-import-adic.num-adic 
                AND   decla-import-adic-itens.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts:
    
                ASSIGN decla-import-adic-itens.val-acresc = 0
                       decla-import-adic-itens.val-acresc-me[1] = 0
                       decla-import-adic-itens.val-acresc-me[2] = 0.
    
            END.                                             
        END.    
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSetaRecalculoImpostos DBOProgram 
PROCEDURE piSetaRecalculoImpostos :
/*------------------------------------------------------------------------------
  Purpose:     Seta se os impostos dever∆o ser regerados conforme 
               parametrizaá∆o padr∆o do sistema
  Parameters:  pl-regera-default-impostos (logical): seta se regera valores default dos impostos
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pl-regera-default-impostos AS LOGICAL NO-UNDO.

    ASSIGN l-regera-default-impostos = pl-regera-default-impostos.

    RETURN "OK":U.        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atual-val-rat-compl-embarque DBOProgram 
PROCEDURE pi-atual-val-rat-compl-embarque :
/*------------------------------------------------------------------------------
  Purpose:     Atualiza Despesas Complementares no Embarque
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM p-num-di-ems LIKE decla-import.num-di-ems NO-UNDO.
    DEF INPUT  PARAM p-cdd-siscomex-dts LIKE decla-import.cdd-siscomex-dts NO-UNDO.
    
    DEFINE INPUT PARAM TABLE FOR tt-desp-rateio-item.
    
    DEFINE VARIABLE i-cdn-pto-nacionaliz-histor AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-seq-nacionaliz            AS INTEGER     NO-UNDO.

    IF NOT VALID-HANDLE(h-bocx407) THEN
        RUN cxbo/bocx407.p PERSISTENT SET h-bocx407.

    EMPTY TEMP-TABLE tt-desp-embarque.

    FOR EACH  decla-import-embarq NO-LOCK
        WHERE decla-import-embarq.num-di-ems = p-num-di-ems
          AND decla-import-embarq.cdd-siscomex-dts = p-cdd-siscomex-dts,
        EACH  decla-import-ord NO-LOCK
        WHERE decla-import-ord.num-di-ems  = decla-import-embarq.num-di-ems
        AND   decla-import-ord.cod-estab   = decla-import-embarq.cod-estab
        AND   decla-import-ord.cod-embarq  = decla-import-embarq.cod-embarq
        AND   decla-import-ord.cdd-siscomex-dts = decla-import-embarq.cdd-siscomex-dts,
        FIRST decla-import-adic-itens NO-LOCK
        WHERE decla-import-adic-itens.num-di-ems   = decla-import-ord.num-di-ems
        AND   decla-import-adic-itens.num-adic     = decla-import-ord.num-adic
        AND   decla-import-adic-itens.num-ordem    = decla-import-ord.num-ordem
        AND   decla-import-adic-itens.num-parcela  = decla-import-ord.num-parcela
        AND   decla-import-adic-itens.cdd-siscomex-dts = decla-import-ord.cdd-siscomex-dts,
        EACH  tt-desp-rateio-item 
        WHERE tt-desp-rateio-item.num-di-ems   = decla-import-adic-itens.num-di-ems 
          AND tt-desp-rateio-item.num-adic     = decla-import-adic-itens.num-adic   
          AND tt-desp-rateio-item.numero-ordem = decla-import-adic-itens.num-ordem  
          AND tt-desp-rateio-item.parcela      = decla-import-adic-itens.num-parcela
          AND tt-desp-rateio-item.num-seq      = decla-import-adic-itens.num-seq,
        FIRST despes-decla-import NO-LOCK
        WHERE despes-decla-import.num-di-ems = tt-desp-rateio-item.num-di-ems
        AND   despes-decla-import.cdn-despes = tt-desp-rateio-item.cod-desp
        AND   despes-decla-import.cdd-siscomex-dts = decla-import-adic-itens.cdd-siscomex-dts:

        IF NOT CAN-FIND(FIRST tt-desp-embarque
                        WHERE tt-desp-embarque.cod-estabel = decla-import-ord.cod-estab
                        AND   tt-desp-embarque.embarque    = decla-import-ord.cod-embarq
                        AND   tt-desp-embarque.cod-desp    = despes-decla-import.cdn-despes ) THEN DO:
            
            CREATE tt-desp-embarque.
            ASSIGN tt-desp-embarque.cod-desp                 = despes-decla-import.cdn-despes
                   tt-desp-embarque.cod-cond-pag             = despes-decla-import.cdn-cond-pagto
                   tt-desp-embarque.cod-emitente-desp        = despes-decla-import.cdn-emit-despes
                   tt-desp-embarque.cod-estabel              = decla-import-ord.cod-estab  
                   tt-desp-embarque.cod-incoterm-rat         = despes-decla-import.cod-incoterm-rat
                   tt-desp-embarque.embarque                 = decla-import-ord.cod-embarq
                   tt-desp-embarque.log-forma-preco-compra   = despes-decla-import.log-forma-preco-compra
                   tt-desp-embarque.mo-codigo                = despes-decla-import.cdn-moeda
                   tt-desp-embarque.val-desp                 = tt-desp-rateio-item.val-desp.


            FOR FIRST historico-embarque NO-LOCK
                WHERE historico-embarque.cod-estabel = decla-import-ord.cod-estab
                AND   historico-embarque.embarque    = decla-import-ord.cod-embarq:
            END.

            
            RUN retorna-seq-ponto-nacionaliz IN h-bocx407 (INPUT decla-import-ord.cod-embarq,
                                                           INPUT decla-import-ord.cod-estab ,
                                                           OUTPUT i-seq-nacionaliz).
            FOR FIRST historico-embarque NO-LOCK
                WHERE historico-embarque.cod-estabel = decla-import-ord.cod-estab
                AND   historico-embarque.embarque    = decla-import-ord.cod-embarq 
                AND   historico-embarque.sequencia   > i-seq-nacionaliz:
                ASSIGN i-cdn-pto-nacionaliz-histor = historico-embarque.cod-pto-contr.
            END.

            ASSIGN tt-desp-embarque.cod-pto-contr = i-cdn-pto-nacionaliz-histor
                   tt-desp-embarque.cod-itiner    = IF AVAIL historico-embarque THEN historico-embarque.cod-itiner ELSE 0.
    
        END.
        ELSE DO:
            FOR FIRST tt-desp-embarque
                WHERE tt-desp-embarque.cod-estabel = decla-import-ord.cod-estab
                AND   tt-desp-embarque.embarque    = decla-import-ord.cod-embarq
                AND   tt-desp-embarque.cod-desp    = despes-decla-import.cdn-despes :
                ASSIGN tt-desp-embarque.val-desp = tt-desp-embarque.val-desp + tt-desp-rateio-item.val-desp.
            END.                                                                                            
        END.
    END.

    /*Atualizando valores embarque*/
    FOR EACH tt-desp-embarque :
        IF CAN-FIND(FIRST desp-embarque
                    WHERE desp-embarque.cod-estabel = tt-desp-embarque.cod-estabel
                    AND   desp-embarque.embarque    = tt-desp-embarque.embarque   
                    AND   desp-embarque.cod-desp    = tt-desp-embarque.cod-desp   ) THEN DO:
            FOR FIRST desp-embarque EXCLUSIVE-LOCK
                WHERE desp-embarque.cod-estabel = tt-desp-embarque.cod-estabel
                AND   desp-embarque.embarque    = tt-desp-embarque.embarque   
                AND   desp-embarque.cod-desp    = tt-desp-embarque.cod-desp :
                ASSIGN desp-embarque.val-desp  = tt-desp-embarque.val-desp
                       desp-embarque.mo-codigo = tt-desp-embarque.mo-codigo.
            END.
        END.
        ELSE DO:
            CREATE desp-embarque.
            BUFFER-COPY tt-desp-embarque TO desp-embarque.
        END.
    END.

    /*Seta campo que indica que rateio j† foi realizado*/
    FIND FIRST decla-import 
         WHERE decla-import.num-di-ems = p-num-di-ems 
            AND decla-import.cdd-siscomex-dts = p-cdd-siscomex-dts EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL decla-import THEN
        &if "{&bf_mat_versao_ems}" < "2.09" &then
            ASSIGN OVERLAY(decla-import.cod-livre-1,1,1) = "S".
        &ELSE
            ASSIGN decla-import.log-pend-despes-compltar = YES.
        &ENDIF
        
    RELEASE decla-import.

    IF VALID-HANDLE (h-bocx407)   THEN DO:
        DELETE PROCEDURE h-bocx407.
        ASSIGN h-bocx407 = ?.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atual-val-rat-embarque DBOProgram 
PROCEDURE pi-atual-val-rat-embarque :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM p-num-di-ems             LIKE decla-import.num-di-ems        NO-UNDO.
    DEF INPUT  PARAM p-cdd-siscomex-dts       LIKE decla-import.cdd-siscomex-dts  NO-UNDO.

    DEFINE VARIABLE i-cdn-pto-nacionaliz-histor AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-seq-nacionaliz            AS INTEGER     NO-UNDO.   

    IF NOT VALID-HANDLE(h-bocx407) THEN
        RUN cxbo/bocx407.p PERSISTENT SET h-bocx407.

    IF NOT VALID-HANDLE(h-cdapi050) THEN
        RUN cdp/cdapi050.p PERSISTENT SET h-cdapi050.

    EMPTY TEMP-TABLE tt-desp-embarque.

    IF NOT VALID-HANDLE(h-bocx406) THEN
        RUN cxbo/bocx406.p PERSISTEN SET h-bocx406.
    /* busca c¢dido da taxa siscomex da param-imp */
    RUN pi-busca-despes-siscomex IN h-bocx406(INPUT  p-num-di-ems,
                                              INPUT  p-cdd-siscomex-dts,
                                              OUTPUT i-cdn-despes-siscomex,
                                              OUTPUT i-cdn-emit-siscomex,
                                              OUTPUT l-taxa-siscomex).
    FOR EACH  decla-import-embarq NO-LOCK
        WHERE decla-import-embarq.num-di-ems = p-num-di-ems
          AND decla-import-embarq.cdd-siscomex-dts = p-cdd-siscomex-dts,
        EACH  decla-import-ord NO-LOCK
        WHERE decla-import-ord.num-di-ems  = decla-import-embarq.num-di-ems
        AND   decla-import-ord.cod-estab   = decla-import-embarq.cod-estab
        AND   decla-import-ord.cod-embarq  = decla-import-embarq.cod-embarq
        AND   decla-import-ord.cdd-siscomex-dts = decla-import-embarq.cdd-siscomex-dts,
        FIRST decla-import-adic-itens NO-LOCK
        WHERE decla-import-adic-itens.num-di-ems   = decla-import-ord.num-di-ems
        AND   decla-import-adic-itens.num-adic     = decla-import-ord.num-adic
        AND   decla-import-adic-itens.num-ordem    = decla-import-ord.num-ordem
        AND   decla-import-adic-itens.num-parcela  = decla-import-ord.num-parcela
        AND   decla-import-adic-itens.cdd-siscomex-dts = decla-import-ord.cdd-siscomex-dts,
        EACH  despes-adic-itens NO-LOCK
        WHERE despes-adic-itens.num-di-ems = decla-import-adic-itens.num-di-ems
        AND   despes-adic-itens.num-adic   = decla-import-adic-itens.num-adic
        AND   despes-adic-itens.num-seq    = decla-import-adic-itens.num-seq
        AND   despes-adic-itens.cdd-siscomex-dts = decla-import-adic-itens.cdd-siscomex-dts,
        FIRST despes-decla-import
        WHERE despes-decla-import.num-di-ems = despes-adic-itens.num-di-ems
        AND   despes-decla-import.cdn-despes = despes-adic-itens.cdn-despes 
        AND   despes-decla-import.cdd-siscomex-dts = despes-adic-itens.cdd-siscomex-dts:

        IF NOT CAN-FIND(FIRST tt-desp-embarque
                        WHERE tt-desp-embarque.cod-estabel = decla-import-ord.cod-estab
                        AND   tt-desp-embarque.embarque    = decla-import-ord.cod-embarq
                        AND   tt-desp-embarque.cod-desp    = despes-adic-itens.cdn-despes ) THEN DO:

            CREATE tt-desp-embarque.
            ASSIGN tt-desp-embarque.cod-desp                 = despes-adic-itens.cdn-despes
                   tt-desp-embarque.cod-cond-pag             = despes-adic-itens.cdn-cond-pag
                   tt-desp-embarque.cod-emitente-desp        = despes-adic-itens.cdn-emit-despes
                   tt-desp-embarque.cod-estabel              = decla-import-ord.cod-estab  
                   tt-desp-embarque.cod-incoterm-rat         = despes-adic-itens.cod-incoterm-rat
                   tt-desp-embarque.embarque                 = decla-import-ord.cod-embarq
                   tt-desp-embarque.log-forma-preco-compra   = despes-decla-import.log-forma-preco-compra
                   tt-desp-embarque.mo-codigo                = despes-adic-itens.cdn-moeda
                   tt-desp-embarque.val-desp                 = despes-adic-itens.val-despes.


            FOR FIRST historico-embarque NO-LOCK
                WHERE historico-embarque.cod-estabel = decla-import-ord.cod-estab
                AND   historico-embarque.embarque    = decla-import-ord.cod-embarq:
            END.

            IF despes-decla-import.idi-tip-incid-nf = 1 THEN DO:
                RUN retorna-ponto-nacionalizacao IN h-bocx407 (INPUT decla-import-ord.cod-embarq,
                                                               INPUT decla-import-ord.cod-estab,
                                                               OUTPUT i-cdn-pto-nacionaliz-histor).
            END.
            ELSE DO:
                RUN retorna-seq-ponto-nacionaliz IN h-bocx407 (INPUT decla-import-ord.cod-embarq,
                                                               INPUT decla-import-ord.cod-estab ,
                                                               OUTPUT i-seq-nacionaliz).
                FOR FIRST historico-embarque NO-LOCK
                    WHERE historico-embarque.cod-estabel = decla-import-ord.cod-estab
                    AND   historico-embarque.embarque    = decla-import-ord.cod-embarq 
                    AND   historico-embarque.sequencia   > i-seq-nacionaliz:
                    ASSIGN i-cdn-pto-nacionaliz-histor = historico-embarque.cod-pto-contr.
                END.
            END.

            ASSIGN tt-desp-embarque.cod-pto-contr = i-cdn-pto-nacionaliz-histor
                   tt-desp-embarque.cod-itiner    = IF AVAIL historico-embarque THEN historico-embarque.cod-itiner ELSE 0.

    
        END.
        ELSE DO:
            FOR FIRST tt-desp-embarque
                WHERE tt-desp-embarque.cod-estabel = decla-import-ord.cod-estab
                AND   tt-desp-embarque.embarque    = decla-import-ord.cod-embarq
                AND   tt-desp-embarque.cod-desp    = despes-adic-itens.cdn-despes :
                ASSIGN tt-desp-embarque.val-desp = tt-desp-embarque.val-desp + despes-adic-itens.val-despes.
            END.                                                                                            
        END.
        
        /*Atualiza ordens embarque com o valor da taxa Siscomex*/
        IF l-taxa-siscomex AND i-cdn-despes-siscomex = despes-adic-itens.cdn-despes THEN DO:
            FOR FIRST ordens-embarque EXCLUSIVE-LOCK
                    WHERE ordens-embarque.cod-estabel  = decla-import-ord.cod-estab
                    AND   ordens-embarque.embarque     = decla-import-ord.cod-embarq
                    AND   ordens-embarque.numero-ordem = decla-import-ord.num-ordem
                    AND   ordens-embarque.parcela      = decla-import-ord.num-parcela:
                &IF '{&BF_MAT_VERSAO_EMS}' >= '2.07' &THEN
                    ASSIGN ordens-embarque.val-tax-siscomex = despes-adic-itens.val-despes.
                &ELSE
                    OVERLAY(ordens-embarque.char-1,64,16) = STRING(TRUNCATE(despes-adic-itens.val-despes,5) * 100000).
                &ENDIF
            END.
        END.
    END.

    FOR EACH tt-desp-embarque :
        IF CAN-FIND(FIRST desp-embarque
                    WHERE desp-embarque.cod-estabel = tt-desp-embarque.cod-estabel
                    AND   desp-embarque.embarque    = tt-desp-embarque.embarque   
                    AND   desp-embarque.cod-desp    = tt-desp-embarque.cod-desp   ) THEN DO:
            FOR FIRST desp-embarque EXCLUSIVE-LOCK
                WHERE desp-embarque.cod-estabel = tt-desp-embarque.cod-estabel
                AND   desp-embarque.embarque    = tt-desp-embarque.embarque   
                AND   desp-embarque.cod-desp    = tt-desp-embarque.cod-desp :

                IF TRUNCATE(tt-desp-embarque.val-desp,2) > 0 THEN 
                    ASSIGN desp-embarque.val-desp  = tt-desp-embarque.val-desp
                           desp-embarque.mo-codigo = tt-desp-embarque.mo-codigo.
                ELSE DO:
                    CREATE tt-desp-embarque-aux.
                    BUFFER-COPY tt-desp-embarque TO tt-desp-embarque-aux NO-ERROR.
                    DELETE desp-embarque.
                END.
            END.
        END.
        ELSE DO:
            IF TRUNCATE(tt-desp-embarque.val-desp,2) > 0 THEN DO:
                CREATE desp-embarque.
                BUFFER-COPY tt-desp-embarque TO desp-embarque NO-ERROR.
            END.
            ELSE DO:
                CREATE tt-desp-embarque-aux.
                BUFFER-COPY tt-desp-embarque TO tt-desp-embarque-aux NO-ERROR.
            END.
        END. /* ELSE DO: */

        /*** Siscoserv ***/
        IF CAN-FIND (FIRST emitente no-lock
                        WHERE emitente.cod-emitente = tt-desp-embarque.cod-emitente-desp
                        AND   UPPER(emitente.pais) <> "BRASIL":U) THEN DO:
            RUN pi-siscoserv-ativo IN h-cdapi050.
            IF RETURN-VALUE = "OK":U THEN DO:
                FOR FIRST historico-embarque FIELDS(dt-previsao)                         
                    WHERE historico-embarque.cod-estabel   = tt-desp-embarque.cod-estabel
                    AND   historico-embarque.embarque      = tt-desp-embarque.embarque  
                    AND   historico-embarque.cod-itiner    = tt-desp-embarque.cod-itiner   
                    AND   historico-embarque.cod-pto-contr = tt-desp-embarque.cod-pto-contr NO-LOCK:

                    RUN pi-grava-despes-import-sis IN h-cdapi050 (INPUT tt-desp-embarque.cod-estabel,
                                                                  INPUT tt-desp-embarque.embarque,
                                                                  INPUT tt-desp-embarque.cod-itiner,
                                                                  INPUT tt-desp-embarque.cod-pto-contr,
                                                                  INPUT tt-desp-embarque.cod-desp,
                                                                  INPUT tt-desp-embarque.cod-emitente-desp,
                                                                  INPUT historico-embarque.dt-previsao).
                END.
            END. /*FOR FIRST historico-embarque*/
        END. /*CAN-FIND emitente*/
        /*** Siscoserv ***/

    END. /* FOR EACH tt-desp-embarque : */
    
    /*procura a maior despesa entre os embarques da DI para atribuir o valor de saldo se houver*/
    FOR EACH tt-desp-embarque-aux:        

        ASSIGN d-val-desp-aux    = 0
               c-cod-estabel-aux = ""
               c-embarque-aux    = ""
               d-total-desp      = 0.
        FOR each decla-import-embarq NO-LOCK
                WHERE decla-import-embarq.num-di-ems = p-num-di-ems
                  AND decla-import-embarq.cdd-siscomex-dts = p-cdd-siscomex-dts,
                EACH desp-embarque NO-LOCK
                   WHERE desp-embarque.cod-estabel = decla-import-embarq.cod-estab
                   AND   desp-embarque.embarque    = decla-import-embarq.cod-embarq
                   AND   desp-embarque.cod-desp    = tt-desp-embarque-aux.cod-desp :
            ASSIGN d-total-desp = d-total-desp + desp-embarque.val-desp.

            if desp-embarque.val-desp > d-val-desp-aux then 
                assign d-val-desp-aux    = desp-embarque.val-desp
                       c-embarque-aux    = desp-embarque.embarque
                       c-cod-estabel-aux = desp-embarque.cod-estabel. 
            else
                next.   
        END.

        FOR FIRST despes-decla-import NO-LOCK
            WHERE despes-decla-import.num-di-ems = p-num-di-ems 
            AND   despes-decla-import.cdn-despes = tt-desp-embarque-aux.cod-desp
            AND   despes-decla-import.cdd-siscomex-dts = p-cdd-siscomex-dts:
            IF despes-decla-import.val-despes > d-total-desp THEN DO:
                FOR FIRST desp-embarque EXCLUSIVE-LOCK
                    WHERE desp-embarque.cod-estabel = c-cod-estabel-aux
                    AND   desp-embarque.embarque    = c-embarque-aux
                    AND   desp-embarque.cod-desp    = tt-desp-embarque-aux.cod-desp:
                    ASSIGN desp-embarque.val-desp = round(desp-embarque.val-desp,5) + (round(despes-decla-import.val-despes,5) - round(d-total-desp,5)).
                END.
            END.
            ELSE IF despes-decla-import.val-despes < d-total-desp THEN DO:
                FOR FIRST desp-embarque EXCLUSIVE-LOCK
                    WHERE desp-embarque.cod-estabel = c-cod-estabel-aux
                    AND   desp-embarque.embarque    = c-embarque-aux
                    AND   desp-embarque.cod-desp    = tt-desp-embarque-aux.cod-desp:
                    ASSIGN desp-embarque.val-desp = round(desp-embarque.val-desp,5) - (round(d-total-desp,5) - round(despes-decla-import.val-despes,5)).
                END.
            END.
        END.
        DELETE tt-desp-embarque-aux.
    END.

    IF VALID-HANDLE (h-bocx407)   THEN DO:
        DELETE PROCEDURE h-bocx407.
        ASSIGN h-bocx407 = ?.
    END.

    IF VALID-HANDLE(h-cdapi050) THEN DO:
        DELETE PROCEDURE h-cdapi050.
        ASSIGN h-cdapi050 = ?.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-dados-cfg-trib DBOProgram 
PROCEDURE pi-atualiza-dados-cfg-trib:
/*:T------------------------------------------------------------------------------
  Purpose:     Realizar a criaá∆o das worktables wt-docto, wt-it-docto e da tabela "nota-fisc-adc"
               referente aos dados carregados pelo configurador de tributos na Vis∆o DI
  Parameters:  <none>
  Notes:       Quando Ç realizado o c†lculo dos Impostos via IM0400, s∆o criadas as tabelas wt-docto, 
               wt-it-docto e ct-trib-wt-item-docto com "wt-docto.nr-nota" recebendo o Embarque de Importaá∆o vinculado na DI.
               Isso se faz necess†rio pois no momento da Nacionalizaá∆o, a geraá∆o das notas Ç por Embarque, logo j† existem
               os registros nas respectivas tabelas, bastando apenas realizar um buffer-copy para atualizar 
               o campo "wt-docto.nr-nota" com o n£mero da nota que est† sendo gerada no recebimento para que os dados sejam poss°veis
               de serem consultados tanto via IM0400 quanto RE0701/FT0904.
               
               Ou seja: - Quando acessado o bot∆o de Configurador de Tributos via IM0400, para cada embarque existe um registro correspondente nas tabelas acima;
                        - Quando acessado o bot∆o de Configurador de Tributos via RE0701 ou FT0904, para cada nota existe um registro correspondente nas tabelas acima.
                        
------------------------------------------------------------------------------*/

    FOR EACH tt-ct-trib-item NO-LOCK:
        CREATE ct-trib-item-doc-est.
        ASSIGN ct-trib-item-doc-est.cod-docto      = item-doc-est.nro-docto
               ct-trib-item-doc-est.cod-ser-docto  = item-doc-est.serie-docto
               ct-trib-item-doc-est.num-seq        = item-doc-est.sequencia.
        BUFFER-COPY tt-ct-trib-item EXCEPT cod-docto cod-ser-docto num-seq TO ct-trib-item-doc-est.
                
        /*Cria as informaá‰es referentes Ö taxa de FCP do documento que est† sendo gerado no recebimento*/
        CASE ct-trib-item-doc-est.cod-tip-trib:
            WHEN "FCP" THEN DO:
                FIND FIRST tt-ext-item-doc-est EXCLUSIVE-LOCK
                     WHERE tt-ext-item-doc-est.serie-docto  = item-doc-est.serie-docto
                       AND tt-ext-item-doc-est.nro-docto    = item-doc-est.nro-docto
                       AND tt-ext-item-doc-est.cod-emitente = item-doc-est.cod-emitente
                       AND tt-ext-item-doc-est.nat-operacao = item-doc-est.nat-operacao
                       AND tt-ext-item-doc-est.sequencia    = item-doc-est.sequencia
                       AND tt-ext-item-doc-est.cod-param    = "FCP":U NO-ERROR.
    
                IF NOT AVAIL tt-ext-item-doc-est THEN DO:
                    RUN openQueryStatic IN h-boin01017 (INPUT "Main":U) NO-ERROR.
    
                    RUN goToKey IN h-boin01017 (INPUT item-doc-est.serie-docto, 
                                                INPUT item-doc-est.nro-docto,   
                                                INPUT item-doc-est.cod-emitente,
                                                INPUT item-doc-est.nat-operacao,
                                                INPUT item-doc-est.sequencia,   
                                                INPUT "FCP":U).
    
                    IF  RETURN-VALUE = "OK":U THEN DO:
                        RUN emptyRowErrors IN h-boin01017.
                        RUN getRecord IN h-boin01017 (OUTPUT TABLE tt-ext-item-doc-est).
                        FIND FIRST tt-ext-item-doc-est EXCLUSIVE-LOCK NO-ERROR.
                    END.
                    ELSE DO:
                        CREATE tt-ext-item-doc-est.
                        ASSIGN tt-ext-item-doc-est.serie-docto  = item-doc-est.serie-docto
                               tt-ext-item-doc-est.nro-docto    = item-doc-est.nro-docto
                               tt-ext-item-doc-est.cod-emitente = item-doc-est.cod-emitente
                               tt-ext-item-doc-est.nat-operacao = item-doc-est.nat-operacao
                               tt-ext-item-doc-est.sequencia    = item-doc-est.sequencia
                               tt-ext-item-doc-est.cod-param    = "FCP":U.
                               
                        ASSIGN tt-ext-item-doc-est.val-livre-1 = ct-trib-item-doc-est.val-base  WHEN item-doc-est.nro-comp = " " OR natur-oper.tipo-compra <> 3  /*Base FCP*/
                               tt-ext-item-doc-est.val-livre-2 = ct-trib-item-doc-est.val-aliq  WHEN item-doc-est.nro-comp = " " OR natur-oper.tipo-compra <> 3  /*Aliq FCP*/
                               tt-ext-item-doc-est.val-livre-3 = ct-trib-item-doc-est.val-trib  WHEN item-doc-est.nro-comp = " " OR natur-oper.tipo-compra <> 3. /*Valor FCP*/                               
    
                    END.
                END.
    
                /*Zera a aliquota quando nío tiver valor de FCP*/
                IF tt-ext-item-doc-est.val-livre-3 = 0 THEN
                    ASSIGN tt-ext-item-doc-est.val-livre-2 = 0.
            END.
    
            WHEN "FCP ST" THEN DO:
                FIND FIRST tt-ext-item-doc-est EXCLUSIVE-LOCK
                     WHERE tt-ext-item-doc-est.serie-docto  = item-doc-est.serie-docto
                       AND tt-ext-item-doc-est.nro-docto    = item-doc-est.nro-docto
                       AND tt-ext-item-doc-est.cod-emitente = item-doc-est.cod-emitente
                       AND tt-ext-item-doc-est.nat-operacao = item-doc-est.nat-operacao
                       AND tt-ext-item-doc-est.sequencia    = item-doc-est.sequencia
                       AND tt-ext-item-doc-est.cod-param    = "FCP":U NO-ERROR.
                
                IF NOT AVAIL tt-ext-item-doc-est THEN DO:
                    RUN openQueryStatic IN h-boin01017 (INPUT "Main":U) NO-ERROR.
    
                    RUN goToKey IN h-boin01017 (INPUT item-doc-est.serie-docto, 
                                                INPUT item-doc-est.nro-docto,   
                                                INPUT item-doc-est.cod-emitente,
                                                INPUT item-doc-est.nat-operacao,
                                                INPUT item-doc-est.sequencia,   
                                                INPUT "FCP":U).
    
                    IF  RETURN-VALUE = "OK":U THEN DO:
                        RUN emptyRowErrors IN h-boin01017.
                        RUN getRecord IN h-boin01017 (OUTPUT TABLE tt-ext-item-doc-est).
                        FIND FIRST tt-ext-item-doc-est EXCLUSIVE-LOCK NO-ERROR.
                    END.
                    ELSE DO:
                        CREATE tt-ext-item-doc-est.
                        ASSIGN tt-ext-item-doc-est.serie-docto  = item-doc-est.serie-docto
                               tt-ext-item-doc-est.nro-docto    = item-doc-est.nro-docto
                               tt-ext-item-doc-est.cod-emitente = item-doc-est.cod-emitente
                               tt-ext-item-doc-est.nat-operacao = item-doc-est.nat-operacao
                               tt-ext-item-doc-est.sequencia    = item-doc-est.sequencia
                               tt-ext-item-doc-est.cod-param    = "FCP":U.
                    END.                                                  
                END.
    
                ASSIGN tt-ext-item-doc-est.val-livre-4 = ct-trib-item-doc-est.val-base  WHEN item-doc-est.nro-comp = " " OR natur-oper.tipo-compra <> 3  /*Base FCP ST*/ 
                       tt-ext-item-doc-est.val-livre-5 = ct-trib-item-doc-est.val-aliq  WHEN item-doc-est.nro-comp = " " OR natur-oper.tipo-compra <> 3  /*Aliq FCP ST*/ 
                       tt-ext-item-doc-est.val-livre-6 = ct-trib-item-doc-est.val-trib  WHEN item-doc-est.nro-comp = " " OR natur-oper.tipo-compra <> 3. /*Valor FCP ST*/
                       
                /*Zera a aliquota quando nío tiver valor de FCP ST*/
                IF tt-ext-item-doc-est.val-livre-6 = 0 THEN
                    ASSIGN tt-ext-item-doc-est.val-livre-5 = 0.
            END.

        END CASE.
    END. /*for each tt-ct-trib-item */

    /*Atualizaá∆o referente ao ICMS Diferido*/
    ASSIGN OVERLAY(item-doc-est.char-2,796,6)  = STRING(decla-import-adic-itens.val-perc-icms-diferim)
           OVERLAY(item-doc-est.char-2,802,17) = STRING(decla-import-adic-itens.val-diferim-icms-item)
    /*Atualizaá∆o ICMS Complementar*/
           item-doc-est.icm-complem            = decla-import-adic-itens.val-icms-compltar              /*Valor ICMS Complementar*/
           OVERLAY(item-doc-est.char-2,860,20) = STRING(decla-import-adic-itens.val-base-icms-compltar) /*Base icms complementar*/
    /*Atualizaá∆o ICMS ST*/ 
           item-doc-est.base-subs = decla-import-adic-itens.val-base-icms-substto
           item-doc-est.vl-subs   = decla-import-adic-itens.val-icms-substto.


    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-pend-imp DBOProgram 
PROCEDURE pi-atualiza-pend-imp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Reabre o calculo dos impostos      
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER i-num-di-ems LIKE decla-import.num-di-ems NO-UNDO.
    DEFINE INPUT PARAMETER de-cdd-siscomex-dts LIKE decla-import.cdd-siscomex-dts NO-UNDO.

    FOR FIRST decla-import EXCLUSIVE-LOCK
            WHERE decla-import.num-di-ems = i-num-di-ems
              AND decla-import.cdd-siscomex-dts = de-cdd-siscomex-dts:
        
        &IF '{&BF_MAT_VERSAO_EMS}' >= '2.09' &THEN
            ASSIGN decla-import.log-pend-impto = NO.
        &ELSE
            ASSIGN decla-import.log-livre-2 = NO.
        &ENDIF
    END.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-pend-rat DBOProgram 
PROCEDURE pi-atualiza-pend-rat :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER i-num-di-ems LIKE decla-import.num-di-ems NO-UNDO.
    DEFINE INPUT PARAMETER de-cdd-siscomex-dts LIKE decla-import.cdd-siscomex-dts NO-UNDO.

    FOR FIRST decla-import EXCLUSIVE-LOCK
        WHERE decla-import.num-di-ems = i-num-di-ems
         AND decla-import.cdd-siscomex-dts = de-cdd-siscomex-dts:
    END.
    IF AVAIL decla-import THEN DO:
        ASSIGN decla-import.log-pend-rat = NO.
        &IF '{&BF_MAT_VERSAO_EMS}' >= '2.09' &THEN
            ASSIGN decla-import.log-pend-impto = NO.
        &ELSE
            ASSIGN decla-import.log-livre-2 = NO.
        &ENDIF
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-valor-mercadoria-ordens DBOProgram 
PROCEDURE pi-atualiza-valor-mercadoria-ordens :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM p-num-di-ems    LIKE decla-import-ord.num-di-ems    NO-UNDO.
    DEF INPUT  PARAM p-cdd-siscomex-dts LIKE decla-import-ord.cdd-siscomex-dts NO-UNDO.

    FOR EACH decla-import-adic NO-LOCK
        WHERE decla-import-adic.num-di-ems = p-num-di-ems
          AND decla-import-adic.cdd-siscomex-dts = p-cdd-siscomex-dts,
        EACH decla-import-ord NO-LOCK
        WHERE decla-import-ord.num-di-ems = decla-import-adic.num-di-ems 
        AND   decla-import-ord.num-adic   = decla-import-adic.num-adic
        AND   decla-import-ord.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts,
        FIRST tt-ordens-totais
        WHERE tt-ordens-totais.num-di-ems   = decla-import-ord.num-di-ems
        AND   tt-ordens-totais.num-adic     = decla-import-ord.num-adic
        AND   tt-ordens-totais.numero-ordem = decla-import-ord.num-ordem
        AND   tt-ordens-totais.parcela      = decla-import-ord.num-parcela:

        IF CAN-FIND(FIRST despes-adic
                    WHERE despes-adic.num-di-ems = decla-import-ord.num-di-ems
                    AND   despes-adic.num-adic   = decla-import-ord.num-adic
                    AND   despes-adic.cdd-siscomex-dts = decla-import-ord.cdd-siscomex-dts
                    AND   despes-adic.log-forma-preco-compra) THEN DO:
            FOR EACH despes-adic NO-LOCK
                WHERE despes-adic.num-di-ems = decla-import-ord.num-di-ems
                AND   despes-adic.num-adic   = decla-import-ord.num-adic
                AND   despes-adic.cdd-siscomex-dts = decla-import-ord.cdd-siscomex-dts
                AND   despes-adic.log-forma-preco-compra :
                
                ASSIGN de-valor-despesa = 0.
                IF i-mo-codigo <> despes-adic.cdn-moeda THEN DO:
            
                    RUN converteValorMoeda (INPUT decla-import.num-di-ems,
                                            INPUT decla-import.cdd-siscomex-dts,
                                            INPUT despes-adic.cdn-moeda,
                                            INPUT i-mo-codigo,
                                            INPUT despes-adic.val-despes,
                                            INPUT decla-import.dat-di,
                                            OUTPUT de-valor-despesa).
                END.
                ELSE 
                    ASSIGN de-valor-despesa = despes-adic.val-despes.

                ASSIGN tt-ordens-totais.preco-merc-tot = tt-ordens-totais.val-merc - de-valor-despesa.
            END.
        END.
        ELSE DO:
            ASSIGN tt-ordens-totais.preco-merc-tot = tt-ordens-totais.val-merc.
        END.
    END.

    /*Atualizando valor da mercadoria da tt-adic-totais*/
    FOR EACH tt-adic-totais
        WHERE tt-adic-totais.num-di-ems = p-num-di-ems:
        ASSIGN tt-adic-totais.val-merc-adic = 0.
        FOR EACH tt-ordens-totais
            WHERE tt-ordens-totais.num-di-ems = tt-adic-totais.num-di-ems
            AND   tt-ordens-totais.num-adic   = tt-adic-totais.num-adic :
            ASSIGN tt-adic-totais.val-merc-adic = tt-adic-totais.val-merc-adic + tt-ordens-totais.val-merc.                                                                                     
        END.
    END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-valores-impostos-di DBOProgram 
PROCEDURE pi-atualiza-valores-impostos-di :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pnum-di-siscomex LIKE decla-import.cod-di-siscomex NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente    LIKE docum-est.cod-emitente       NO-UNDO.
    DEFINE INPUT PARAMETER pserie-docto     LIKE docum-est.serie-docto        NO-UNDO.
    DEFINE INPUT PARAMETER pnro-docto       LIKE docum-est.nro-docto          NO-UNDO.
    DEFINE INPUT PARAMETER pnat-operacao    LIKE docum-est.nat-operacao       NO-UNDO.

    DEFINE VARIABLE d-tot-icms-di       AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE d-tot-pis-di        AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE d-tot-cofins-di     AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE d-tot-icms          AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE d-tot-pis           AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE d-tot-cofins        AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-tot-val-fcp      AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-tot-base-fcp     AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-tot-val-fcp-st   AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-tot-base-fcp-st  AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE d-tot-frete         AS DECIMAL     NO-UNDO.    
    DEFINE VARIABLE d-tot-desp-frete    AS DECIMAL     NO-UNDO.

    FOR FIRST {&TableName} NO-LOCK
        WHERE {&TableName}.cod-di-siscomex = pnum-di-siscomex,
            EACH  decla-import-adic-itens NO-LOCK
            WHERE decla-import-adic-itens.num-di-ems = {&TableName}.num-di-ems
            AND   decla-import-adic-itens.cdd-siscomex-dts = {&TableName}.cdd-siscomex-dts,
            FIRST item-doc-est EXCLUSIVE-LOCK
            WHERE item-doc-est.cod-emitente    = pcod-emitente  
            AND   item-doc-est.serie-docto     = pserie-docto   
            AND   item-doc-est.nro-docto       = pnro-docto     
            AND   item-doc-est.nat-operacao    = pnat-operacao  
            AND   item-doc-est.numero-ordem    = decla-import-adic-itens.num-ordem
            AND   item-doc-est.parcela         = decla-import-adic-itens.num-parcela,
            FIRST docum-est OF item-doc-est EXCLUSIVE-LOCK
        BREAK BY item-doc-est.sequencia:

        IF l-nt2024002 THEN DO:
            FOR EACH item-doc-est-tribut
               WHERE  item-doc-est-tribut.cdn-emitente     = item-doc-est.cod-emitente
                AND   item-doc-est-tribut.cod-serie-docto  = item-doc-est.serie-docto   
                AND   item-doc-est-tribut.cod-num-docto    = item-doc-est.nro-docto     
                AND   item-doc-est-tribut.cod-natur-operac = item-doc-est.nat-operacao   
                AND   item-doc-est-tribut.num-seq          = item-doc-est.sequencia
                EXCLUSIVE-LOCK:
                
                DELETE item-doc-est-tribut.
            END.
            
            /*Atualiza dados tabela item-doc-est-tribut conforme calculado para a DI*/    
            RUN pi-cria-item-doc-est-tribut.
        END.                                         
        
        FOR FIRST natur-oper
            WHERE natur-oper.nat-operacao = docum-est.nat-operacao NO-LOCK:
        END.

        FOR FIRST b-natur-oper
            WHERE b-natur-oper.nat-operacao = item-doc-est.nat-operacao NO-LOCK:
        END.
            
        ASSIGN item-doc-est.aliquota-icm            = decla-import-adic-itens.val-aliq-icms
               item-doc-est.aliquota-ipi            = decla-import-adic-itens.val-aliq-ipi
               item-doc-est.aliquota-iss            = 0
               item-doc-est.base-cofins-subs        = 0
               item-doc-est.base-icm[1]             = IF decla-import-adic-itens.idi-tributac-icms <> 2 AND decla-import-adic-itens.idi-tributac-icms <> 3 THEN
                                                          decla-import-adic-itens.val-base-icms 
                                                      ELSE
                                                          IF decla-import-adic-itens.idi-tributac-icms = 2 THEN 0
                                                          ELSE item-doc-est.base-icm[1]
               item-doc-est.base-icm[2]             = 0
               item-doc-est.base-ipi[1]             = IF decla-import-adic-itens.idi-tributac-ipi <> 2 AND decla-import-adic-itens.idi-tributac-ipi <> 3 THEN
                                                        IF decla-import-adic-itens.val-aliq-ipi > 0 THEN
                                                            decla-import-adic-itens.val-base-ipi
                                                        ELSE 0
                                                      ELSE
                                                          IF decla-import-adic-itens.idi-tributac-ipi = 2 THEN 0
                                                          ELSE item-doc-est.base-ipi[1]
               item-doc-est.base-ipi[2]             = 0
               item-doc-est.base-iss-cmi            = 0
               item-doc-est.base-iss[1]             = 0
               item-doc-est.base-iss[2]             = 0
               item-doc-est.base-pis                = decla-import-adic-itens.val-base-pis
               item-doc-est.base-pis-subs           = 0
               item-doc-est.base-subs[1]            = 0
               item-doc-est.base-subs[2]            = 0
               item-doc-est.cd-trib-icm             = decla-import-adic-itens.idi-tributac-icms
               item-doc-est.cd-trib-ipi             = decla-import-adic-itens.idi-tributac-ipi
               item-doc-est.cd-trib-iss             = 2
               item-doc-est.icm-complem[1]          = 0
               item-doc-est.icm-complem[2]          = 0
               item-doc-est.icm-ntrib[1]            = IF decla-import-adic-itens.idi-tributac-icms = 2 THEN /* Isento grava base em "Base ICMS Isento" */
                                                          decla-import-adic-itens.val-base-icms 
                                                      ELSE
                                                          decla-import-adic-itens.val-icms-nao-tributad
               item-doc-est.icm-ntrib[2]            = 0
               item-doc-est.icm-outras[1]           = IF decla-import-adic-itens.idi-tributac-icms = 3 THEN 
                                                          decla-import-adic-itens.val-base-icms 
                                                      ELSE 
                                                          decla-import-adic-itens.val-icms-outras
               item-doc-est.icm-outras[2]           = 0 
               item-doc-est.idi-tributac-cofins     = decla-import-adic-itens.idi-tributac-cofins
               item-doc-est.idi-tributac-pis        = decla-import-adic-itens.idi-tributac-pis
               item-doc-est.ipi-ntrib[1]            = IF decla-import-adic-itens.idi-tributac-ipi = 2 THEN /*Isento*/ 
                                                          decla-import-adic-itens.val-base-ipi  
                                                      ELSE
                                                          decla-import-adic-itens.val-ipi-nao-tributad
               item-doc-est.ipi-ntrib[2]            = 0
               item-doc-est.ipi-outras[1]           = IF decla-import-adic-itens.idi-tributac-ipi = 3 OR (decla-import-adic-itens.idi-tributac-ipi = 1 AND decla-import-adic-itens.val-aliq-ipi = 0) 
                                                      THEN decla-import-adic-itens.val-base-ipi 
                                                      ELSE decla-import-adic-itens.val-ipi-outras 
               item-doc-est.ipi-outras[2]           = 0 
               item-doc-est.iss-ntr-cmi             = 0
               item-doc-est.iss-ntrib[1]            = 0
               item-doc-est.iss-ntrib[2]            = 0
               item-doc-est.iss-out-cmi             = 0
               item-doc-est.iss-outras[1]           = 0
               item-doc-est.iss-outras[2]           = 0
               item-doc-est.val-aliq-cofins         = decla-import-adic-itens.val-aliq-cofins
               item-doc-est.val-aliq-ext-cofins     = decla-import-adic-itens.val-aliq-cofins
               item-doc-est.val-aliq-ext-icms       = item-doc-est.val-aliq-ext-icms
               item-doc-est.val-aliq-ext-ipi        = decla-import-adic-itens.val-aliq-ipi
               item-doc-est.val-aliq-ext-pis        = decla-import-adic-itens.val-aliq-pis
               item-doc-est.val-aliq-impto-import   = decla-import-adic-itens.val-aliq-ii
               item-doc-est.val-aliq-pis            = decla-import-adic-itens.val-aliq-pis
               item-doc-est.val-base-calc-cofins    = decla-import-adic-itens.val-base-cofins
               item-doc-est.val-cofins              = IF item-doc-est.idi-tributac-cofins = 3 AND SUBSTRING(decla-import-adic-itens.cod-livre-1,3,1) = "1" THEN
                                                         decla-import-adic-itens.val-cofins-nao-tributad
                                                      ELSE IF item-doc-est.idi-tributac-cofins = 3 AND SUBSTRING(decla-import-adic-itens.cod-livre-1,3,1) <> "1" THEN
                                                         decla-import-adic-itens.val-cofins-outras
                                                      ELSE decla-import-adic-itens.val-cofins-db-cr
               item-doc-est.val-perc-red-icms       = decla-import-adic-itens.val-perc-reduc-icms
               item-doc-est.val-perc-rep-ipi        = decla-import-adic-itens.val-perc-reduc-ipi
               item-doc-est.val-reduc-cofins-import = decla-import-adic-itens.val-perc-reduc-cofins
               item-doc-est.val-reduc-pis-import    = decla-import-adic-itens.val-perc-reduc-pis
               item-doc-est.val-unit-cofins-import  = decla-import-adic-itens.val-unit-cofins
               item-doc-est.val-unit-pis-import     = decla-import-adic-itens.val-unit-pis
               item-doc-est.valor-icm[1]            = IF decla-import-adic-itens.idi-tributac-icms = 3 AND SUBSTRING(decla-import-adic-itens.cod-livre-1,1,1) = "1" /*Sim*/ THEN
                                                         decla-import-adic-itens.val-icms-nao-tributad
                                                      ELSE
                                                          IF decla-import-adic-itens.idi-tributac-icms = 3 AND SUBSTRING(decla-import-adic-itens.cod-livre-1,1,1) <> "1" /*N∆o*/ THEN
                                                              decla-import-adic-itens.val-icms-outras
                                                          ELSE
                                                              decla-import-adic-itens.val-icms-db-cr
               item-doc-est.valor-icm[2]            = 0
               item-doc-est.valor-ipi[1]            = IF decla-import-adic-itens.idi-tributac-ipi = 3 AND decla-import-adic-itens.log-suspens-ipi-import THEN 
                                                        decla-import-adic-itens.val-ipi-nao-tributad
                                                      ELSE 
                                                          IF decla-import-adic-itens.idi-tributac-ipi = 3 AND NOT(decla-import-adic-itens.log-suspens-ipi-import) THEN 
                                                              decla-import-adic-itens.val-ipi-outras
                                                           ELSE decla-import-adic-itens.val-ipi-db-cr 
               item-doc-est.valor-ipi[2]            = 0
               item-doc-est.valor-iss[1]            = 0
               item-doc-est.valor-iss[2]            = 0
               item-doc-est.valor-pis               = IF item-doc-est.idi-tributac-pis = 3 AND SUBSTRING(decla-import-adic-itens.cod-livre-1,2,1) = "1" /*Sim*/ THEN 
                                                         decla-import-adic-itens.val-pis-nao-tributad
                                                      ELSE IF item-doc-est.idi-tributac-pis = 3 AND SUBSTRING(decla-import-adic-itens.cod-livre-1,2,1) <> "1" /*N∆o*/ THEN
                                                         decla-import-adic-itens.val-pis-outras
                                                      ELSE decla-import-adic-itens.val-pis-db-cr
               item-doc-est.vl-cofins-subs          = 0
               item-doc-est.vl-imp-impor[1]         = decla-import-adic-itens.val-ii-db-cr
               item-doc-est.vl-imp-impor[2]         = decla-import-adic-itens.val-ii-db-cr
               item-doc-est.vl-iss-cmi              = 0
               item-doc-est.vl-pis-subs             = 0
               item-doc-est.vl-subs[1]              = 0
               item-doc-est.vl-subs[2]              = 0
               item-doc-est.val-aduana-pis           = DEC(TRIM(SUBSTRING(decla-import-adic-itens.cod-livre-2,45,22))) / 100000
               item-doc-est.val-despes-aduana-pis    = DEC(TRIM(SUBSTRING(decla-import-adic-itens.cod-livre-2,67,22))) / 100000
               item-doc-est.val-aduana-cofins        = DEC(TRIM(SUBSTRING(decla-import-adic-itens.cod-livre-2,1,22)))  / 100000
               item-doc-est.val-despes-aduana-cofins = DEC(TRIM(SUBSTRING(decla-import-adic-itens.cod-livre-2,23,22))) / 100000
               item-doc-est.pr-total-cmi             = decla-import-adic-itens.val-frete.

        RUN grava-aliquotas IN h-cdapi995 (INPUT "item-doc-est",
                                           INPUT item-doc-est.serie-docto + "/" + 
                                                 item-doc-est.nro-docto + "/" + 
                                                 string(item-doc-est.cod-emitente) + "/" + 
                                                 item-doc-est.nat-operacao + "/" + 
                                                 string(item-doc-est.sequencia), 
                                           INPUT decla-import-adic-itens.val-aliq-pis, 
                                           INPUT decla-import-adic-itens.val-aliq-cofins).
        
        /*Integraá∆o com Configurador de Tributos. Os dados via configurador s∆o 
          gerados no momento do C†lculo do Rateio dos Impostos na Vis∆o DI (IM0400)
          - Somente entra caso encontrado algum imposto calculado pelo configurador*/
        IF CAN-FIND(FIRST ct-trib-item-doc-est
                    WHERE ct-trib-item-doc-est.cod-embarq  = decla-import-adic-itens.cod-embarq
                    AND   ct-trib-item-doc-est.num-ordem   = decla-import-adic-itens.num-ordem  
                    AND   ct-trib-item-doc-est.num-parcela = decla-import-adic-itens.num-parcela
                    AND   ct-trib-item-doc-est.cod-estab   = decla-import-adic-itens.cod-estab) THEN DO:
           EMPTY TEMP-TABLE tt-ct-trib-item.
           FOR EACH ct-trib-item-doc-est 
               WHERE ct-trib-item-doc-est.cod-embarq  = decla-import-adic-itens.cod-embarq
               AND   ct-trib-item-doc-est.num-ordem   = decla-import-adic-itens.num-ordem  
               AND   ct-trib-item-doc-est.num-parcela = decla-import-adic-itens.num-parcela 
               AND   ct-trib-item-doc-est.cod-estab   = decla-import-adic-itens.cod-estab NO-LOCK:
               CREATE tt-ct-trib-item.
               BUFFER-COPY ct-trib-item-doc-est TO tt-ct-trib-item.
               ASSIGN tt-ct-trib-item.r-rowid   = ROWID(ct-trib-item-doc-est).
           END.
           /* Copia registros gerados no c†lculo da DI */
           RUN pi-atualiza-dados-cfg-trib. 
        END.

        IF AVAIL tt-nota AND tt-nota.l-icms-diferido THEN
           ASSIGN item-doc-est.aliquota-icm = 0
                  item-doc-est.valor-icm[1] = 0
                  item-doc-est.base-icm[1]  = 0
                  item-doc-est.base-icm[2]  = 0.

        ASSIGN  d-tot-desp-itens-aux                = d-tot-desp-itens-aux
                                                    + IF decla-import-adic-itens.idi-tributac-icms = 3 AND SUBSTRING(decla-import-adic-itens.cod-livre-1,1,1) = "1" /*Sim*/ THEN
                                                        decla-import-adic-itens.val-icms-nao-tributad
                                                     ELSE IF decla-import-adic-itens.idi-tributac-icms = 3 AND SUBSTRING(decla-import-adic-itens.cod-livre-1,1,1) <> "1" /*N∆o*/ THEN
                                                        decla-import-adic-itens.val-icms-outras
                                                     ELSE decla-import-adic-itens.val-icms-db-cr
                                                    + IF item-doc-est.idi-tributac-pis = 3 AND SUBSTRING(decla-import-adic-itens.cod-livre-1,2,1) = "1" /*Sim*/ THEN 
                                                        decla-import-adic-itens.val-pis-nao-tributad
                                                     ELSE IF item-doc-est.idi-tributac-pis = 3 AND SUBSTRING(decla-import-adic-itens.cod-livre-1,2,1) <> "1" /*N∆o*/ THEN
                                                        decla-import-adic-itens.val-pis-outras
                                                     ELSE decla-import-adic-itens.val-pis-db-cr
                                                    + IF item-doc-est.idi-tributac-cofins = 3 AND SUBSTRING(decla-import-adic-itens.cod-livre-1,3,1) = "1" THEN
                                                        decla-import-adic-itens.val-cofins-nao-tributad
                                                     ELSE IF item-doc-est.idi-tributac-cofins = 3 AND SUBSTRING(decla-import-adic-itens.cod-livre-1,3,1) <> "1" THEN
                                                        decla-import-adic-itens.val-cofins-outras
                                                     ELSE decla-import-adic-itens.val-cofins-db-cr

            
               item-doc-est.despesas[1]              = item-doc-est.despesas[1] + item-doc-est.valor-icm[1] 
                                                                                + item-doc-est.valor-pis 
                                                                                + item-doc-est.val-cofins
               docum-est.despesa-nota                = docum-est.despesa-nota + item-doc-est.valor-icm[1] 
                                                                              + item-doc-est.valor-pis 
                                                                              + item-doc-est.val-cofins /*ICMS, PIS E COFINS DEVEM SER INCLUSOS NO VALOR DAS DESPESAS*/

               d-tot-icms                            = d-tot-icms      + item-doc-est.valor-icm[1]
               d-tot-pis                             = d-tot-pis       + item-doc-est.valor-pis
               d-tot-cofins                          = d-tot-cofins    + item-doc-est.val-cofins
               d-tot-frete                           = d-tot-frete     + round(item-doc-est.pr-total-cmi,2)
               d-tot-desp-frete                      = d-tot-desp-frete + decla-import-adic-itens.val-frete
               d-tot-icms-di                         = d-tot-icms-di   + IF decla-import-adic-itens.idi-tributac-icms = 3 AND SUBSTRING(decla-import-adic-itens.cod-livre-1,1,1) = "1" /*Sim*/ THEN
                                                                            decla-import-adic-itens.val-icms-nao-tributad
                                                                         ELSE IF decla-import-adic-itens.idi-tributac-icms = 3 AND SUBSTRING(decla-import-adic-itens.cod-livre-1,1,1) <> "1" /*N∆o*/ THEN
                                                                            decla-import-adic-itens.val-icms-outras
                                                                         ELSE decla-import-adic-itens.val-icms-db-cr
               d-tot-pis-di                          = d-tot-pis-di    + IF item-doc-est.idi-tributac-pis = 3 AND SUBSTRING(decla-import-adic-itens.cod-livre-1,2,1) = "1" /*Sim*/ THEN 
                                                                            decla-import-adic-itens.val-pis-nao-tributad
                                                                         ELSE IF item-doc-est.idi-tributac-pis = 3 AND SUBSTRING(decla-import-adic-itens.cod-livre-1,2,1) <> "1" /*N∆o*/ THEN
                                                                            decla-import-adic-itens.val-pis-outras
                                                                         ELSE decla-import-adic-itens.val-pis-db-cr
               d-tot-cofins-di                       = d-tot-cofins-di + IF item-doc-est.idi-tributac-cofins = 3 AND SUBSTRING(decla-import-adic-itens.cod-livre-1,3,1) = "1" THEN
                                                                            decla-import-adic-itens.val-cofins-nao-tributad
                                                                         ELSE IF item-doc-est.idi-tributac-cofins = 3 AND SUBSTRING(decla-import-adic-itens.cod-livre-1,3,1) <> "1" THEN
                                                                            decla-import-adic-itens.val-cofins-outras
                                                                         ELSE decla-import-adic-itens.val-cofins-db-cr.

        /* FCP ********************************************************/
        FIND FIRST tt-ext-item-doc-est EXCLUSIVE-LOCK
             WHERE tt-ext-item-doc-est.serie-docto  = item-doc-est.serie-docto
               AND tt-ext-item-doc-est.nro-docto    = item-doc-est.nro-docto
               AND tt-ext-item-doc-est.cod-emitente = item-doc-est.cod-emitente
               AND tt-ext-item-doc-est.nat-operacao = item-doc-est.nat-operacao
               AND tt-ext-item-doc-est.sequencia    = item-doc-est.sequencia
               AND tt-ext-item-doc-est.cod-param    = "FCP":U NO-ERROR.

        IF AVAIL tt-ext-item-doc-est THEN DO:
            /*1-FCP Normal, 2-FCP Subst. Trib., 3-FCP Subst. Trib. Antecip*/
            ASSIGN tt-ext-item-doc-est.num-livre-2 = 1.
            IF  AVAIL b-natur-oper AND b-natur-oper.subs-trib THEN
                ASSIGN tt-ext-item-doc-est.num-livre-2 = 2.
            ELSE IF AVAIL b-natur-oper AND b-natur-oper.log-contrib-st-antec AND NOT b-natur-oper.terceiros THEN
                ASSIGN tt-ext-item-doc-est.num-livre-2 = 3.

            EMPTY TEMP-TABLE tt-ext-item-doc-est-aux.
            BUFFER-COPY tt-ext-item-doc-est TO tt-ext-item-doc-est-aux.
            RUN goToKey IN h-boin01017 (INPUT tt-ext-item-doc-est.serie-docto, 
                                        INPUT tt-ext-item-doc-est.nro-docto,   
                                        INPUT tt-ext-item-doc-est.cod-emitente,
                                        INPUT tt-ext-item-doc-est.nat-operacao,
                                        INPUT tt-ext-item-doc-est.sequencia,   
                                        INPUT "FCP":U). 
    
            IF  RETURN-VALUE = "OK":U THEN DO:
                RUN emptyRowErrors IN h-boin01017.
                RUN setRecord IN h-boin01017 (INPUT TABLE tt-ext-item-doc-est-aux).
                RUN updateRecord IN h-boin01017.  
            END.    
            ELSE DO:
                RUN emptyRowErrors IN h-boin01017.
                RUN setRecord      IN h-boin01017 (INPUT TABLE tt-ext-item-doc-est-aux).
                RUN createRecord   IN h-boin01017.
                RUN getRowErrors   IN h-boin01017 (OUTPUT TABLE RowErrors).
            END.
            DELETE tt-ext-item-doc-est.
        end.

        /*Cria registros na tabela de extens∆o da docum-est referente Ö somat¢ria do FCP*/
        ASSIGN de-tot-val-fcp     = 0
               de-tot-base-fcp    = 0
               de-tot-val-fcp-st  = 0
               de-tot-base-fcp-st = 0.
    
        FOR EACH ext-item-doc-est NO-LOCK
           WHERE ext-item-doc-est.serie-docto  = docum-est.serie-docto 
             AND ext-item-doc-est.nro-docto    = docum-est.nro-docto   
             AND ext-item-doc-est.cod-emitente = docum-est.cod-emitente
             AND ext-item-doc-est.nat-operacao = docum-est.nat-operacao
             AND ext-item-doc-est.cod-param    = "FCP":U:
            ASSIGN de-tot-base-fcp    = de-tot-base-fcp    + ext-item-doc-est.val-livre-1
                   de-tot-val-fcp     = de-tot-val-fcp     + ext-item-doc-est.val-livre-3
                   de-tot-base-fcp-st = de-tot-base-fcp-st + ext-item-doc-est.val-livre-4
                   de-tot-val-fcp-st  = de-tot-val-fcp-st  + ext-item-doc-est.val-livre-6.
        END.
        
        IF de-tot-base-fcp    <> 0 OR
           de-tot-val-fcp     <> 0 OR
           de-tot-base-fcp-st <> 0 OR
           de-tot-val-fcp-st  <> 0 THEN DO:
    
           FIND FIRST ext-docum-est EXCLUSIVE-LOCK
                WHERE ext-docum-est.serie-docto  = docum-est.serie-docto
                  AND ext-docum-est.nro-docto    = docum-est.nro-docto
                  AND ext-docum-est.cod-emitente = docum-est.cod-emitente
                  AND ext-docum-est.nat-operacao = docum-est.nat-operacao
                  AND ext-docum-est.cod-param    = "FCP":U NO-ERROR.
           IF NOT AVAIL ext-docum-est THEN DO:
               CREATE ext-docum-est.
               ASSIGN ext-docum-est.serie-docto  = docum-est.serie-docto
                      ext-docum-est.nro-docto    = docum-est.nro-docto
                      ext-docum-est.cod-emitente = docum-est.cod-emitente
                      ext-docum-est.nat-operacao = docum-est.nat-operacao
                      ext-docum-est.cod-param    = "FCP":U.
           END.
    
           ASSIGN ext-docum-est.val-livre-1  = de-tot-base-fcp    /*base fcp*/
                  ext-docum-est.val-livre-3  = de-tot-val-fcp     /*valor fcp*/
                  ext-docum-est.val-livre-4  = de-tot-base-fcp-st /*base fcp ST*/  
                  ext-docum-est.val-livre-6  = de-tot-val-fcp-st. /*valor fcp ST*/ 
        END.
        /* FCP ********************************************************/

        RELEASE item-doc-est-tribut.
        RELEASE item-doc-est.
        RELEASE docum-est.
    END. /* FOR EACH  decla-import-adic-itens NO-LOCK */
    
    
    /* Tratamento para acerto arredondamento PIS/COFINS e ICMS */
    IF  d-tot-pis <> round(d-tot-pis-di,2) 
    AND d-tot-pis  - round(d-tot-pis-di,2) >= -0.5
    AND d-tot-pis  - round(d-tot-pis-di,2) <=  0.5 THEN DO:

        FOR FIRST docum-est 
            WHERE docum-est.cod-emitente = pcod-emitente 
              AND docum-est.serie-docto  = pserie-docto  
              AND docum-est.nro-docto    = pnro-docto    
              AND docum-est.nat-operacao = pnat-operacao EXCLUSIVE-LOCK:
            
            FOR FIRST item-doc-est 
                WHERE item-doc-est.cod-emitente = pcod-emitente   
                  AND item-doc-est.serie-docto  = pserie-docto    
                  AND item-doc-est.nro-docto    = pnro-docto      
                  AND item-doc-est.nat-operacao = pnat-operacao EXCLUSIVE-LOCK:
                
                /* Diminui valor antigo do total | acerta valor | totaliza novamente com valor acertado */
                ASSIGN docum-est.despesa-nota   = docum-est.despesa-nota   - item-doc-est.valor-pis
                       item-doc-est.despesas[1] = item-doc-est.despesas[1] - item-doc-est.valor-pis
                       item-doc-est.valor-pis   = item-doc-est.valor-pis   + (round(d-tot-pis-di,2) - d-tot-pis)
                       docum-est.despesa-nota   = docum-est.despesa-nota   + item-doc-est.valor-pis
                       item-doc-est.despesas[1] = item-doc-est.despesas[1] + item-doc-est.valor-pis.
                
            END.
            RELEASE item-doc-est.
        END.
        RELEASE docum-est.
    END.

    IF  d-tot-cofins <> round(d-tot-cofins-di,2) 
    AND d-tot-cofins  - round(d-tot-cofins-di,2) >= -0.5
    AND d-tot-cofins  - round(d-tot-cofins-di,2) <=  0.5 THEN DO:

        FOR FIRST docum-est 
            WHERE docum-est.cod-emitente = pcod-emitente 
              AND docum-est.serie-docto  = pserie-docto  
              AND docum-est.nro-docto    = pnro-docto    
              AND docum-est.nat-operacao = pnat-operacao EXCLUSIVE-LOCK:
         
            FOR FIRST item-doc-est 
                WHERE item-doc-est.cod-emitente = pcod-emitente   
                  AND item-doc-est.serie-docto  = pserie-docto    
                  AND item-doc-est.nro-docto    = pnro-docto      
                  AND item-doc-est.nat-operacao = pnat-operacao EXCLUSIVE-LOCK:
                
                /* Diminui valor antigo do total | acerta valor | totaliza novamente com valor acertado */
                ASSIGN docum-est.despesa-nota   = docum-est.despesa-nota   - item-doc-est.val-cofins
                       item-doc-est.despesas[1] = item-doc-est.despesas[1] - item-doc-est.val-cofins
                       item-doc-est.val-cofins  = item-doc-est.val-cofins  + (round(d-tot-cofins-di,2) - d-tot-cofins)
                       docum-est.despesa-nota   = docum-est.despesa-nota   + item-doc-est.val-cofins
                       item-doc-est.despesas[1] = item-doc-est.despesas[1] + item-doc-est.val-cofins.
                
            END.
            RELEASE item-doc-est.
        END.
        RELEASE docum-est.
    END.

    IF  d-tot-icms <> round(d-tot-icms-di,2) 
    AND d-tot-icms  - round(d-tot-icms-di,2) >= -0.5
    AND d-tot-icms  - round(d-tot-icms-di,2) <=  0.5 THEN DO:

        FOR FIRST docum-est 
            WHERE docum-est.cod-emitente = pcod-emitente 
              AND docum-est.serie-docto  = pserie-docto  
              AND docum-est.nro-docto    = pnro-docto    
              AND docum-est.nat-operacao = pnat-operacao EXCLUSIVE-LOCK:
         
            FOR FIRST item-doc-est 
                WHERE item-doc-est.cod-emitente = pcod-emitente   
                  AND item-doc-est.serie-docto  = pserie-docto    
                  AND item-doc-est.nro-docto    = pnro-docto      
                  AND item-doc-est.nat-operacao = pnat-operacao EXCLUSIVE-LOCK:
                
                /* Diminui valor antigo do total | acerta valor | totaliza novamente com valor acertado */
                ASSIGN docum-est.despesa-nota    = docum-est.despesa-nota    - item-doc-est.valor-icm[1] 
                       item-doc-est.despesas[1]  = item-doc-est.despesas[1]  - item-doc-est.valor-icm[1]
                       item-doc-est.valor-icm[1] = item-doc-est.valor-icm[1] + (round(d-tot-icms-di,2) - d-tot-icms)
                       docum-est.despesa-nota    = docum-est.despesa-nota    + item-doc-est.valor-icm[1]
                       item-doc-est.despesas[1]  = item-doc-est.despesas[1]  + item-doc-est.valor-icm[1].
                
            END.
            RELEASE item-doc-est.
        END.
        RELEASE docum-est.
    END.

    IF  d-tot-frete <> d-tot-desp-frete 
        AND d-tot-frete  - round(d-tot-desp-frete,2) >= -0.5
        AND d-tot-frete  - round(d-tot-desp-frete,2) <=  0.5 THEN DO:

        FOR FIRST docum-est 
            WHERE docum-est.cod-emitente = pcod-emitente 
              AND docum-est.serie-docto  = pserie-docto  
              AND docum-est.nro-docto    = pnro-docto    
              AND docum-est.nat-operacao = pnat-operacao EXCLUSIVE-LOCK:
            FOR FIRST item-doc-est 
                WHERE item-doc-est.cod-emitente = pcod-emitente   
                  AND item-doc-est.serie-docto  = pserie-docto    
                  AND item-doc-est.nro-docto    = pnro-docto      
                  AND item-doc-est.nat-operacao = pnat-operacao 
                  AND item-doc-est.sequencia    = i-maior-sequencia EXCLUSIVE-LOCK:
                /* Acerta diferenáa do arredondamento */
                ASSIGN item-doc-est.pr-total-cmi = item-doc-est.pr-total-cmi + (d-tot-desp-frete - d-tot-frete)
                       item-doc-est.despesas[1]  = item-doc-est.despesas[1]  + (d-tot-desp-frete - d-tot-frete).
            END.
            RELEASE item-doc-est.
        END.
        RELEASE docum-est.        
    END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-vucv-itens-adicao DBOProgram 
PROCEDURE pi-atualiza-vucv-itens-adicao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM p-num-di-ems    LIKE decla-import-ord.num-di-ems    NO-UNDO.
    DEF INPUT  PARAM p-cdd-siscomex-dts LIKE decla-import-ord.cdd-siscomex-dts NO-UNDO.

    FOR EACH decla-import-adic NO-LOCK
        WHERE decla-import-adic.num-di-ems = p-num-di-ems
        AND   decla-import-adic.cdd-siscomex-dts = p-cdd-siscomex-dts,
        EACH decla-import-adic-itens EXCLUSIVE-LOCK
        WHERE decla-import-adic-itens.num-di-ems = decla-import-adic.num-di-ems
        AND   decla-import-adic-itens.num-adic   = decla-import-adic.num-adic
        AND   decla-import-adic-itens.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts,
        FIRST tt-ordens-totais
        WHERE tt-ordens-totais.num-di-ems   = decla-import-adic-itens.num-di-ems
        AND   tt-ordens-totais.num-adic     = decla-import-adic-itens.num-adic
        AND   tt-ordens-totais.numero-ordem = decla-import-adic-itens.num-ordem
        AND   tt-ordens-totais.parcela      = decla-import-adic-itens.num-parcela,
        FIRST tt-di-totais
        WHERE tt-di-totais.num-di-ems = tt-ordens-totais.num-di-ems:
        
        ASSIGN decla-import-adic-itens.val-vucv = tt-ordens-totais.preco-merc-tot / decla-import-adic-itens.qtd-adic[2]
               decla-import-adic-itens.val-vmcv = tt-ordens-totais.val-merc .

        /*Verifica se alguma despesa da adiá∆o pertence a incoterm da DI*/
        FOR EACH tt-despesas
            WHERE tt-despesas.num-di-ems = decla-import-adic-itens.num-di-ems
            AND   tt-despesas.num-adic   = decla-import-adic-itens.num-adic
            AND   tt-despesas.log-forma-preco-compra:            
            IF CAN-FIND(FIRST tt-desp-rateio-item
                        WHERE tt-desp-rateio-item.num-di-ems   = decla-import-adic-itens.num-di-ems
                        AND   tt-desp-rateio-item.num-adic     = decla-import-adic-itens.num-adic
                        AND   tt-desp-rateio-item.numero-ordem = decla-import-adic-itens.num-ordem
                        AND   tt-desp-rateio-item.parcela      = decla-import-adic-itens.num-parcela
                        AND   tt-desp-rateio-item.cod-desp     = tt-despesas.cdn-despes) THEN DO:    
                FOR FIRST tt-desp-rateio-item
                    WHERE tt-desp-rateio-item.num-di-ems   = decla-import-adic-itens.num-di-ems
                    AND   tt-desp-rateio-item.num-adic     = decla-import-adic-itens.num-adic
                    AND   tt-desp-rateio-item.numero-ordem = decla-import-adic-itens.num-ordem
                    AND   tt-desp-rateio-item.parcela      = decla-import-adic-itens.num-parcela
                    AND   tt-desp-rateio-item.cod-desp     = tt-despesas.cdn-despes :     
                    
                    /*Atualiza adiá‰es com valor rateado das despesas*/
                    ASSIGN decla-import-adic-itens.val-vmcv = decla-import-adic-itens.val-vmcv + tt-desp-rateio-item.val-desp.
                END.
            END.
        END.
            
        /* Calcula o VUCV do item */
        ASSIGN decla-import-adic-itens.val-vucv = decla-import-adic-itens.val-vmcv / decla-import-adic-itens.qtd-adic[2]
               overlay(decla-import-adic-itens.cod-livre-1,4,20) = STRING(decla-import-adic-itens.val-vucv * 100000000).
        /* fim - Calcula o VUCV do item*/
    END.
    RUN pi-atualiza-vucv-sem-despesas(INPUT p-num-di-ems,
                                      INPUT p-cdd-siscomex-dts).

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-vucv-sem-despesas DBOProgram 
PROCEDURE pi-atualiza-vucv-sem-despesas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM p-num-di-ems    LIKE decla-import-ord.num-di-ems    NO-UNDO.
    DEF INPUT  PARAM p-cdd-siscomex-dts LIKE decla-import-ord.cdd-siscomex-dts    NO-UNDO.

    DEF VAR d-val-vucv     LIKE decla-import-adic-itens.val-vucv NO-UNDO.
    DEF VAR d-val-vucv-aux LIKE decla-import-adic-itens.val-vucv NO-UNDO.

    FOR EACH decla-import-adic NO-LOCK
        WHERE decla-import-adic.num-di-ems = p-num-di-ems
          AND decla-import-adic.cdd-siscomex-dts = p-cdd-siscomex-dts,
        EACH decla-import-adic-itens EXCLUSIVE-LOCK
            WHERE decla-import-adic-itens.num-di-ems = decla-import-adic.num-di-ems
            AND   decla-import-adic-itens.num-adic   = decla-import-adic.num-adic
            AND   decla-import-adic-itens.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts,
            EACH despes-adic-itens 
                WHERE despes-adic-itens.num-di-ems  = decla-import-adic-itens.num-di-ems
                AND   despes-adic-itens.num-adic    = decla-import-adic-itens.num-adic
                AND   despes-adic-itens.num-seq     = decla-import-adic-itens.num-seq
                AND   despes-adic-itens.cdd-siscomex-dts = decla-import-adic-itens.cdd-siscomex-dts
                AND   despes-adic-itens.log-forma-preco-compra:
            
        ASSIGN d-val-vucv = DECIMAL(SUBSTRING(decla-import-adic-itens.cod-livre-1,4,20)) / 100000000
               d-val-vucv-aux = d-val-vucv - (despes-adic-itens.val-despes / decla-import-adic-itens.qtd-adic[2])
               overlay(decla-import-adic-itens.cod-livre-1,4,20) = STRING(d-val-vucv-aux * 100000000).
    END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-calcula-impostos DBOProgram 
PROCEDURE pi-calcula-impostos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER i-num-di-ems LIKE decla-import.num-di-ems NO-UNDO.
    DEFINE INPUT PARAMETER de-cdd-siscomex-dts LIKE decla-import.cdd-siscomex-dts NO-UNDO.
    
    DEFINE VARIABLE c-lbl-liter AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-desc-msg  AS CHARACTER NO-UNDO.

    if not valid-handle(h-bocx00512) then
        run cxbo/bocx00512.p persistent set h-bocx00512.

    if not valid-handle(h-bocx00506) then
        run cxbo/bocx00506.p persistent set h-bocx00506.
    
    if  not valid-handle(h-bocx00507) then
        run cxbo/bocx00507.p persistent set h-bocx00507.

    ASSIGN i-seq-item = 0.

    FIND FIRST decla-import EXCLUSIVE-LOCK
        WHERE decla-import.num-di-ems = i-num-di-ems 
          AND decla-import.cdd-siscomex-dts = de-cdd-siscomex-dts NO-ERROR.

    if can-find(first decla-import-ord 
                where decla-import-ord.num-di-ems  = i-num-di-ems
                  AND decla-import-ord.cdd-siscomex-dts = de-cdd-siscomex-dts
                  and decla-import-ord.cod-natur-operac = "":U) then do:

            FIND LAST RowErrors NO-LOCK NO-ERROR.
            IF AVAIL RowErrors THEN
                ASSIGN iErro = RowErrors.errorSequence + 1.
            ELSE 
                ASSIGN iErro = 1.
            
            CREATE RowErrors.
            
            {utp/ut-liter.i "Natureza_de_Operaá∆o_em branco" *}
            ASSIGN c-desc-msg = TRIM(RETURN-VALUE).

            {utp/ut-liter.i "Natureza_de_Operaá∆o_em branco,_n∆o_ser†_poss°vel_gerar_tributaá∆o_dos_impostos_e_valores_da_DI" *}
            
            ASSIGN RowErrors.ErrorNumber      = 55790
                   RowErrors.ErrorDescription = c-desc-msg
                   RowErrors.ErrorHelp        = TRIM(RETURN-VALUE) + "!"
                   RowErrors.ErrorType        = "EMS":U
                   RowErrors.ErrorSubType     = "ERROR":U
                   RowErrors.ErrorSequence    = iErro.
    end.
    ELSE DO:
        /* verifica se h† algum °tem com volume informado. Se tiver, emite mensagem que o valor do volume ser† desconsiderado. */
        FOR EACH decla-import-adic NO-LOCK
            WHERE decla-import-adic.num-di-ems = decla-import.num-di-ems
              AND decla-import-adic.cdd-siscomex-dts = decla-import.cdd-siscomex-dts,
              
            EACH decla-import-adic-itens
                WHERE decla-import-adic-itens.num-di-ems = decla-import-adic.num-di-ems
                AND   decla-import-adic-itens.num-adic   = decla-import-adic.num-adic
                AND   decla-import-adic-itens.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts:
    
            IF  CAN-FIND(FIRST item-mat 
                         WHERE item-mat.it-codigo = decla-import-adic-itens.cod-item
                         AND  (item-mat.val-unit-vol-pis > 0 
                         OR    item-mat.val-unit-vol-cofins > 0)) THEN DO:
                
                {utp/ut-liter.i "O_valor_por_volume_de_PIS_e_COFINS_ser†_desconsiderado" *}
                ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).
                {utp/ut-liter.i "O_valor_por_volume_de_PIS_e_COFINS_ser†_desconsiderado_no_c†lculo_dos_impostos" *}
                                                        
                RUN utp/ut-msgs.p (INPUT "msg":U,
                                INPUT 17006,
                                INPUT c-lbl-liter + '!' + '~~' + 
                                      TRIM(RETURN-VALUE) + '!').
    
                FIND LAST RowErrors NO-LOCK NO-ERROR.
                IF AVAIL RowErrors THEN
                    ASSIGN iErro = RowErrors.errorSequence + 1.
                ELSE 
                    ASSIGN iErro = 1.
                
                CREATE RowErrors.
                
                ASSIGN c-desc-msg = TRIM(RETURN-VALUE).
    
                {utp/ut-liter.i "O_valor_por_volume_de_PIS_e_COFINS_ser†_desconsiderado_no_c†lculo_dos_impostos" *}
                
                ASSIGN RowErrors.ErrorNumber      = 17006
                       RowErrors.ErrorDescription = c-desc-msg
                       RowErrors.ErrorHelp        = TRIM(RETURN-VALUE) + "!"
                       RowErrors.ErrorType        = "EMS":U
                       RowErrors.ErrorSubType     = "ERROR":U
                       RowErrors.ErrorSequence    = iErro.
            END. /* IF  CAN-FIND(FIRST item-mat */

            IF  NOT CAN-FIND(FIRST cotacao-item 
                             WHERE cotacao-item.numero-ordem = decla-import-adic-itens.num-ordem
                             AND   cotacao-item.cod-emitente = decla-import-adic.cdn-fornec
                             AND   cotacao-item.it-codigo    = decla-import-adic-itens.cod-item
                             AND   cotacao-item.cot-aprovada = YES) THEN DO:
                
                {utp/ut-liter.i "Cotaá∆o_Item" *}
                ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).
                                                        
                RUN utp/ut-msgs.p (INPUT "msg":U,
                                   INPUT 2,
                                   INPUT c-lbl-liter).

                ASSIGN c-desc-msg = TRIM(RETURN-VALUE).
    
                FIND LAST RowErrors NO-LOCK NO-ERROR.
                IF AVAIL RowErrors THEN
                    ASSIGN iErro = RowErrors.errorSequence + 1.
                ELSE 
                    ASSIGN iErro = 1.
                
                CREATE RowErrors.

                {utp/ut-liter.i "Ordem" *}
                ASSIGN c-help-cotac = c-desc-msg + CHR(10) + TRIM(RETURN-VALUE) + ": " + string(decla-import-adic-itens.num-ordem).

                {utp/ut-liter.i "Item" *}
                ASSIGN c-help-cotac = c-help-cotac + CHR(10) + TRIM(RETURN-VALUE) + ": " + string(decla-import-adic-itens.cod-item).
               
                ASSIGN RowErrors.ErrorNumber      = 2
                       RowErrors.ErrorDescription = c-desc-msg
                       RowErrors.ErrorType        = "EMS":U
                       RowErrors.ErrorSubType     = "ERROR":U
                       RowErrors.ErrorHelp        = c-help-cotac
                       RowErrors.ErrorSequence    = iErro.

            END. /* IF  NOT CAN-FIND(FIRST cotacao-item */
        END. /* FOR EACH  decla-import-adic NO-LOCK */
        /* fim - verifica se h† algum °tem com volume informado. Se tiver, emite mensagem que o valor do volume ser† desconsiderado. */

        IF CAN-FIND(FIRST RowErrors 
                    WHERE RowErrors.ErrorType     <> "INTERNAL":U
                    AND   RowErrors.ErrorSubType  = "ERROR":U) THEN DO:
            RETURN "NOK":U.
        END.
        ELSE DO:
  
            IF  AVAIL decla-import AND decla-import.log-pend-rat THEN DO:
            
               {cxbo/bocx250.i50} /* include tratamento atributo livre */
        
                FIND FIRST param-imp NO-LOCK
                     WHERE param-imp.cod-estabel = decla-import.cod-estab NO-ERROR.
        
                {cdp/cd4300.i4 "yes" param-imp.char-1}
                {cxbo/bocx250.i51 "yes"}
            
                IF NOT VALID-HANDLE(h-acomp) THEN
                    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
        
                RUN pi-inicializar        IN h-acomp (INPUT "C†lculo dos impostos.").
                RUN pi-desabilita-cancela IN h-acomp.
        
                EMPTY TEMP-TABLE tt-verifica-impostos. /* zera a temp-table de conferencia de valores*/

                RUN pi-elimina-conf-trib (INPUT decla-import.num-di-ems,
                                          INPUT decla-import.cdd-siscomex-dts).

                ASSIGN i-cod-desp-ii     = i-desp-ii-i50
                       i-cod-emitente-ii = i-emitente-ii-i50
                       i-seq-item        = 0
                       i-seq-item-aux    = 0.
        
                FOR EACH decla-import-adic EXCLUSIVE-LOCK
                   WHERE decla-import-adic.num-di-ems = decla-import.num-di-ems
                     AND decla-import-adic.cdd-siscomex-dts = decla-import.cdd-siscomex-dts:
        
                    RUN pi-log-alteracoes-manuais.
        
                    CREATE tt-verifica-impostos. /* cria um registro da tt de conferencia */
                
                    RUN pi-zera-valores-adic. /* zera os valores dos impostos da adiá∆o */
        
                    RUN calculaValBases. /* faz o calculo das bases */
                
                    RUN gravaImpostosItens.
                
                    RUN calculaII.
                
                    RUN pi-calculaIPI.
        
                    RUN calculaPisCofins.
        
                    RUN calculaICMS. 
        
                    RUN rateioImpostos. /* rateia os valores das adiá‰es para os itens */
        
                    ASSIGN d-val-pis-adic             = 0
                           d-val-cofins-adic          = 0
                           d-valor-ipi-itens          = 0
                           d-valor-icms-itens         = 0
                           d-base-icms-itens          = 0
                           d-valor-ii-itens           = 0
                           d-valor-icms-itens-ct-trib = 0
                           d-base-icms-itens-ct-trib  = 0.
        
                    /*Calculando Impostos para o item*/
                    FOR EACH decla-import-adic-itens EXCLUSIVE-LOCK
                        WHERE decla-import-adic-itens.num-di-ems = decla-import-adic.num-di-ems
                        AND   decla-import-adic-itens.num-adic   = decla-import-adic.num-adic 
                        AND   decla-import-adic-itens.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts
                        BREAK BY decla-import-adic-itens.num-di-ems
                              BY decla-import-adic-itens.num-adic:
        
                        
                        RUN pi-zera-valores-adic-itens. /* zera os valores dos impostos dos itens da adiá∆o */
        
                        RUN calculaValBasesItem.
        
                        RUN calculaII-item.
            
                        RUN calculaIPIItem.
        
                        RUN calculaPisCofinsItem.
                        
                        IF LAST-OF(decla-import-adic-itens.num-adic) THEN
                            RUN acertoValoresImpostos.
                            
                    END.

                    ASSIGN de-val-icms-nao-tribut = 0
                           de-val-icms-outras     = 0
                           de-val-base-icms       = 0
                           de-val-icms-db-cr      = 0.
        
                    FOR EACH decla-import-adic-itens EXCLUSIVE-LOCK
                        WHERE decla-import-adic-itens.num-di-ems = decla-import-adic.num-di-ems
                        AND   decla-import-adic-itens.num-adic   = decla-import-adic.num-adic  
                        AND   decla-import-adic-itens.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts
                        BREAK BY decla-import-adic-itens.num-di-ems
                              BY decla-import-adic-itens.num-adic:
        
                        RUN calculaICMS-CBS-IBS-Item.
        
                        IF LAST-OF(decla-import-adic-itens.num-adic) THEN
                            RUN acertoValoresIcms.
                    END.
                    
                END. /* for each decla-import-adic */
                
                RUN totalizaValores.  /* là os valores das adiá‰es e joga o total na DI */ 
        
                /* atualiza a variavel logica de controle do calculo dos impostos */
                FOR FIRST decla-import EXCLUSIVE-LOCK
                    WHERE decla-import.num-di-ems = i-num-di-ems
                    AND   decla-import.cdd-siscomex-dts = de-cdd-siscomex-dts
                    AND   decla-import.log-ativo: 
                        
                    &IF '{&BF_MAT_VERSAO_EMS}' >= '2.09' &THEN
                        ASSIGN decla-import.log-pend-impto = YES.
                    &ELSE
                        ASSIGN decla-import.log-livre-2 = YES.
                    &ENDIF
                END.
                
        
                IF VALID-HANDLE(h-acomp) THEN
                    RUN pi-finalizar IN h-acomp.
            END.
            ELSE DO:
                
                
                {utp/ut-liter.i "N∆o_Ç_poss°vel_efetuar_o_c†lculo_dos_impostos_pois_os_valores_ainda_n∆o_foram_rateados" *}
                
                RUN utp/ut-msgs.p (INPUT "msg":U,
                                INPUT 17006,
                                INPUT TRIM(RETURN-VALUE) + '!' + '~~' + 
                                      TRIM(RETURN-VALUE) + '!').
        
                
                FIND LAST RowErrors NO-LOCK NO-ERROR.
                IF AVAIL RowErrors THEN
                    ASSIGN iErro = RowErrors.errorSequence + 1.
                ELSE 
                    ASSIGN iErro = 1.
                
                CREATE RowErrors.
                
                
                ASSIGN c-desc-msg = TRIM(RETURN-VALUE).
                
                {utp/ut-liter.i "N∆o_Ç_poss°vel_efetuar_o_c†lculo_dos_impostos_pois_os_valores_ainda_n∆o_foram_rateados" *}
                
                ASSIGN RowErrors.errornumber      = 17006
                       RowErrors.errordescription = c-desc-msg
                       RowErrors.errorHelp        = TRIM(RETURN-VALUE) + "!"
                       RowErrors.ErrorType        = "EMS":U
                       RowErrors.ErrorSubType     = "ERROR":U
                       RowErrors.ErrorSequence    = 1. 
            END. /* ELSE DO: */
        END.
    
        RELEASE decla-import.
        RELEASE decla-import-adic.
        RELEASE decla-import-adic-itens.
    END.

    if valid-handle(h-bocx00512) then do:
        delete procedure h-bocx00512.
        assign h-bocx00512 = ?.
    end.

    if valid-handle(h-bocx00506) then do:
        delete procedure h-bocx00506.
        assign h-bocx00506 = ?.
    end.

    if valid-handle(h-bocx00507) then do:
        delete procedure h-bocx00507.
        assign h-bocx00507 = ?.
    end.    

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-calculaIPI DBOProgram 
PROCEDURE pi-calculaIPI :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Calculando_IPI" *}
    RUN pi-acompanhar IN h-acomp (INPUT RETURN-VALUE). /* altera a mensagem do acompanhamentos */

    DEF VAR d-valor-merc-liq    LIKE decla-import-adic.val-vmle NO-UNDO.
    DEF VAR i                   AS INTEGER INITIAL 0            NO-UNDO.
    DEF VAR piItem              AS CHAR                         NO-UNDO.
    DEF VAR l-procedimento-ok   AS LOGICAL                      NO-UNDO.
    DEF VAR de-valor-incide-ipi AS DECIMAL                      NO-UNDO.
    DEF VAR d-val-manual-ipi    LIKE decla-import-adic.val-ipi-db-cr NO-UNDO.

    IF NOT VALID-HANDLE(h-bodi317im2bra) THEN
        RUN dibo/bodi317im2bra PERSISTEN SET h-bodi317im2bra.
    
    RUN limpaTbWt. /* limpar as temp-tables tb-wt-docto, tb-wt-it-docto, tb-wt-it-imposto e tb-ct-trib-wt-item-docto */

    ASSIGN i = i + 1.
        
    FIND FIRST estabelec NO-LOCK
            WHERE estabelec.cod-estabel = decla-import.cod-estab NO-ERROR.
    
    FOR FIRST decla-import-ord NO-LOCK
        WHERE decla-import-ord.num-di-ems  = decla-import-adic.num-di-ems
        AND   decla-import-ord.num-adic    = decla-import-adic.num-adic
        AND   decla-import-ord.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts:

        FIND FIRST natur-oper NO-LOCK
                WHERE natur-oper.nat-operacao = decla-import-ord.cod-natur-operac NO-ERROR.
    END.

    FIND FIRST emitente NO-LOCK
        WHERE emitente.cod-emitente = decla-import-adic.cdn-fornec NO-ERROR.

    FOR FIRST ITEM NO-LOCK
         WHERE ITEM.it-codigo = decla-import-ord.cod-item: END.

    ASSIGN piItem = string(decla-import.num-di-ems) + "/" + string(decla-import.cdd-siscomex-dts) + "/" + string(decla-import-adic.num-adic).


    IF NOT CAN-FIND(FIRST tb-wt-docto 
                        WHERE tb-wt-docto.seq-wt-docto = 1) THEN DO:

        CREATE tb-wt-docto.
        ASSIGN tb-wt-docto.seq-wt-docto = 1
               tb-wt-docto.cod-emitente = decla-import-adic.cdn-fornec
               tb-wt-docto.nr-nota      = piItem
               tb-wt-docto.nat-operacao = decla-import-ord.cod-natur-operac WHEN AVAIL decla-import-ord
               tb-wt-docto.cod-des-merc = IF natur-oper.consum-final THEN 2 ELSE 1
               tb-wt-docto.cod-estabel  = decla-import.cod-estab
               tb-wt-docto.dt-emis-nota = TODAY
               tb-wt-docto.esp-docto    = 21
               tb-wt-docto.ind-tip-nota = 8
               tb-wt-docto.mo-codigo    = decla-import-adic.cdn-moeda
               tb-wt-docto.nome-abrev   = emitente.nome-abrev
               tb-wt-docto.vl-embalagem = 0
               tb-wt-docto.vl-frete     = 0
               tb-wt-docto.vl-mercad    = d-valor-merc-liq /*valor da mercadoria */
               tb-wt-docto.nr-prog      = 176 /* para indicar no bodi317im1br.i1 que a boin176 que chamou */
               tb-wt-docto.vl-seguro    = 0
               tb-wt-docto.cidade       = estabelec.cidade
               tb-wt-docto.estado       = estabelec.estado
               tb-wt-docto.pais         = estabelec.pais.
    END.

        
    IF NOT CAN-FIND(FIRST tb-wt-it-docto 
                        WHERE tb-wt-it-docto.seq-wt-docto = 1
                        AND   tb-wt-it-docto.seq-wt-it-docto = i) THEN DO:
        
        CREATE tb-wt-it-docto.
        ASSIGN tb-wt-it-docto.seq-wt-docto        = 1
               tb-wt-it-docto.seq-wt-it-docto     = i
               tb-wt-it-docto.calcula             = YES
               tb-wt-it-docto.it-codigo           = item.it-codigo when avail item
               tb-wt-it-docto.nat-operacao        = decla-import-ord.cod-natur-operac WHEN AVAIL decla-import-ord 
               tb-wt-it-docto.nr-sequencia        = i
               tb-wt-it-docto.nr-seq-nota         = 1 
               tb-wt-it-docto.quantidade[1]       = decla-import-adic.qtd-ncm                                 
               tb-wt-it-docto.vl-merc-ori         = 0                                                         
               tb-wt-it-docto.vl-merc-liq         = 0                                                         
               tb-wt-it-docto.vl-despes-it        = 0                                                         
               tb-wt-it-docto.vl-frete            = 0                                                         
               tb-wt-it-docto.vl-seguro           = 0                                                         
               tb-wt-it-docto.vl-preori           = decla-import-adic.val-vmcv / tb-wt-it-docto.quantidade[1] 
               tb-wt-it-docto.vl-preuni           = d-valor-merc-liq / tb-wt-it-docto.quantidade[1]           
               tb-wt-it-docto.vl-merc-s-icms      = d-valor-merc-liq                                          
               tb-wt-it-docto.vl-merc-tab         = d-valor-merc-liq                                          
               tb-wt-it-docto.numero-ordem        = decla-import-ord.num-ordem
               tb-wt-it-docto.parcela             = decla-import-ord.num-parcela
               OVERLAY(tb-wt-it-docto.char-1,1,6) = "IM7777":U.                                               
    END.

    IF NOT CAN-FIND(FIRST tb-wt-it-imposto 
                        WHERE tb-wt-it-imposto.seq-wt-docto = 1
                        AND   tb-wt-it-imposto.seq-wt-it-docto = i) THEN DO:
        CREATE tb-wt-it-imposto.
        ASSIGN tb-wt-it-imposto.seq-wt-docto    = 1
               tb-wt-it-imposto.seq-wt-it-docto = i
               tb-wt-it-imposto.perc-red-icm    = decla-import-adic.val-perc-reduc-icms
               tb-wt-it-imposto.perc-red-ipi    = decla-import-adic.val-perc-reduc-ipi
               tb-wt-it-imposto.perc-red-iss    = 0
               tb-wt-it-imposto.aliquota-ipi    = decla-import-adic.val-aliq-ipi
               tb-wt-it-imposto.aliquota-icm    = decla-import-adic.val-aliq-icms
               tb-wt-it-imposto.aliquota-iss    = 0
               tb-wt-it-imposto.cd-trib-ipi     = decla-import-adic.idi-tributac-ipi
               tb-wt-it-imposto.cd-trib-icm     = decla-import-adic.idi-tributac-icms
               tb-wt-it-imposto.cd-trib-iss     = 0
               tb-wt-it-imposto.ind-icm-ret     = NO.
        
        /* verificar se o ii incide em ipi e  somar na base do ipi */
        FOR FIRST desp-imp NO-LOCK
                WHERE desp-imp.cod-desp  = i-cod-desp-ii:
            ASSIGN de-valor-incide-ipi = 0.
            IF desp-imp.inc-base-ipi THEN
                ASSIGN de-valor-incide-ipi = decla-import-adic.val-ii-db-cr.
            ELSE
                ASSIGN de-valor-incide-ipi = 0.
        END.
        /* fim - verificar se o ii incide em ipi e  somar na base do ipi */

        /* A base do IPI pelo valor bruto ou liquido j† foi testada na procedure "calculaValBases",
           sendo assim o valor do campo "decla-import-adic.val-base-ipi" j† vem correto neste ponto */
        
        ASSIGN tb-wt-it-imposto.vl-bipi-it = decla-import-adic.val-base-ipi
               tb-wt-it-imposto.vl-bipi-it = (tb-wt-it-imposto.vl-bipi-it + de-valor-incide-ipi) WHEN NOT l-base-ipi-manual.
        
    END.

    
    RUN enviaTbWtDocto     IN  h-bodi317im2bra (INPUT TABLE tb-wt-docto).
    RUN enviaTbWtItDocto   IN  h-bodi317im2bra (INPUT TABLE tb-wt-it-docto).
    RUN enviaTbWtItImposto IN  h-bodi317im2bra (INPUT TABLE tb-wt-it-imposto).

    RUN localizaWtDocto IN h-bodi317im2bra (INPUT  1,
                                            OUTPUT l-procedimento-ok).
    IF  NOT l-procedimento-ok THEN 
        RETURN "NOK":U.            

    RUN localizaWtItDocto IN h-bodi317im2bra (INPUT  1,
                                              INPUT  tb-wt-it-docto.seq-wt-it-docto,
                                              OUTPUT l-procedimento-ok).
    IF  NOT l-procedimento-ok THEN 
        RETURN "NOK":U.

    RUN localizaWtItImposto IN h-bodi317im2bra (INPUT  1,
                                                INPUT  tb-wt-it-imposto.seq-wt-it-docto,
                                                OUTPUT l-procedimento-ok).
    IF  NOT l-procedimento-ok THEN 
        RETURN "NOK":U.

    
    RUN calculaIPI IN h-bodi317im2bra (INPUT  NO,    /* Nota Comercio    */ 
                                       OUTPUT l-procedimento-ok) .
    
    RUN retornaTbWtItImposto IN h-bodi317im2bra (OUTPUT TABLE tb-wt-it-imposto).
    

    FIND tb-wt-it-imposto
        WHERE tb-wt-it-imposto.seq-wt-docto    = 1
          AND tb-wt-it-imposto.seq-wt-it-docto = tb-wt-it-docto.seq-wt-it-docto 
        EXCLUSIVE-LOCK NO-ERROR.

    /* Atualizar os dados calculados NO tb-wt-it-imposto para a decla-import-adic.  */
    ASSIGN decla-import-adic.val-base-ipi = tb-wt-it-imposto.vl-bipi-it WHEN NOT l-base-ipi-manual.

    IF  decla-import-adic.idi-tributac-ipi = 2 /* Isento */ 
    THEN ASSIGN decla-import-adic.val-base-ipi         = tb-wt-it-imposto.vl-ipint-it WHEN NOT l-base-ipi-manual
                decla-import-adic.val-ipi-nao-tributad = 0
                decla-import-adic.val-ipi-outras       = 0
                decla-import-adic.val-ipi-db-cr        = 0.
    ELSE DO:
        IF  decla-import-adic.idi-tributac-ipi = 3 /* Outros */ 
        THEN DO:
            ASSIGN decla-import-adic.val-base-ipi = tb-wt-it-imposto.vl-ipiou-it WHEN NOT l-base-ipi-manual. /* Quando opá∆o OUTROS, base vem no valor outros da wt-it-imposto */

            IF  decla-import-adic.log-suspens-ipi-import /* Suspenso */ 
            THEN IF decla-import-adic.val-aliq-ipi > 0
                 THEN ASSIGN decla-import-adic.val-ipi-nao-tributad = round(tb-wt-it-imposto.vl-ipi-it,8) WHEN NOT l-valor-ipi-manual
                             decla-import-adic.val-ipi-outras       = 0                         
                             decla-import-adic.val-ipi-db-cr        = 0.                        
                 ELSE ASSIGN decla-import-adic.val-ipi-nao-tributad = 0
                             decla-import-adic.val-ipi-outras       = 0                         
                             decla-import-adic.val-ipi-db-cr        = 0.                        
            ELSE IF decla-import-adic.val-aliq-ipi > 0
                 OR decla-import-adic.val-unit-ipi > 0
                 THEN ASSIGN decla-import-adic.val-ipi-nao-tributad = 0
                             decla-import-adic.val-ipi-outras       = round(tb-wt-it-imposto.vl-ipi-it,8)WHEN NOT l-valor-ipi-manual
                             decla-import-adic.val-ipi-db-cr        = 0.                        
                 ELSE ASSIGN decla-import-adic.val-ipi-nao-tributad = 0
                             decla-import-adic.val-ipi-outras       = 0                         
                             decla-import-adic.val-ipi-db-cr        = 0.                        
        END. /* THEN DO: */
        ELSE DO:
            IF  decla-import-adic.val-aliq-ipi = 0 AND decla-import-adic.val-unit-ipi = 0 THEN 
                ASSIGN decla-import-adic.val-base-ipi = tb-wt-it-imposto.vl-ipiou-it WHEN NOT l-base-ipi-manual.
            ELSE 
                IF  decla-import-adic.log-suspens-ipi-import /* Suspenso */ THEN DO:
                    IF  tb-wt-it-imposto.vl-ipiou-it > 0 THEN ASSIGN decla-import-adic.val-ipi-nao-tributad = round(tb-wt-it-imposto.vl-ipiou-it,8) WHEN NOT l-valor-ipi-manual
                                                                     decla-import-adic.val-ipi-outras       = 0
                                                                     decla-import-adic.val-ipi-db-cr        = 0.
                    IF  tb-wt-it-imposto.vl-ipi-it   > 0 THEN ASSIGN decla-import-adic.val-ipi-nao-tributad = round(tb-wt-it-imposto.vl-ipi-it,8) WHEN NOT l-valor-ipi-manual
                                                                     decla-import-adic.val-ipi-outras       = 0                         
                                                                     decla-import-adic.val-ipi-db-cr        = 0.                        
                    IF  tb-wt-it-imposto.vl-ipint-it > 0 THEN ASSIGN decla-import-adic.val-ipi-nao-tributad = round(tb-wt-it-imposto.vl-ipint-it,8) WHEN NOT l-valor-ipi-manual
                                                                     decla-import-adic.val-ipi-outras       = 0
                                                                     decla-import-adic.val-ipi-db-cr        = 0.
                END. /* IF  decla-import-adic.log-suspens-ipi-import */
                ELSE DO:
                    IF  tb-wt-it-imposto.vl-ipiou-it > 0 THEN ASSIGN decla-import-adic.val-ipi-nao-tributad = 0
                                                                     decla-import-adic.val-ipi-outras       = round(tb-wt-it-imposto.vl-ipiou-it,8)WHEN NOT l-valor-ipi-manual
                                                                     decla-import-adic.val-ipi-db-cr        = 0.
                    IF  tb-wt-it-imposto.vl-ipi-it   > 0 THEN ASSIGN decla-import-adic.val-ipi-nao-tributad = 0
                                                                     decla-import-adic.val-ipi-outras       = 0
                                                                     decla-import-adic.val-ipi-db-cr        = round(tb-wt-it-imposto.vl-ipi-it,8) WHEN NOT l-valor-ipi-manual.
                    IF  tb-wt-it-imposto.vl-ipint-it > 0 THEN ASSIGN decla-import-adic.val-ipi-nao-tributad = round(tb-wt-it-imposto.vl-ipint-it,8) WHEN NOT l-valor-ipi-manual
                                                                     decla-import-adic.val-ipi-outras       = 0
                                                                     decla-import-adic.val-ipi-db-cr        = IF decla-import-adic.idi-tributac-ipi = 4 /* Reduzido */
                                                                                                              THEN decla-import-adic.val-ipi-db-cr
                                                                                                              ELSE 0.
                END. /* ELSE DO: */
        END. /* ELSE DO: */
    END. /* ELSE DO: */
    
   /* atualiza o valor da tt de valores para conferencia */
   ASSIGN tt-verifica-impostos.val-base-ipi-sist = round(tb-wt-it-imposto.vl-bipi-it,8)
          tt-verifica-impostos.val-base-ipi-inf   = decla-import-adic.val-base-ipi
          tt-verifica-impostos.val-valor-ipi-inf  = decla-import-adic.val-ipi-db-cr         WHEN decla-import-adic.val-ipi-db-cr        > 0
          tt-verifica-impostos.val-valor-ipi-inf  = decla-import-adic.val-ipi-outras        WHEN decla-import-adic.val-ipi-outras       > 0
          tt-verifica-impostos.val-valor-ipi-inf  = decla-import-adic.val-ipi-nao-tributad  WHEN decla-import-adic.val-ipi-nao-tributad > 0
          tt-verifica-impostos.val-valor-ipi-sist = round(tb-wt-it-imposto.vl-ipi-it,8)     WHEN round(tb-wt-it-imposto.vl-ipi-it,8)    > 0
          tt-verifica-impostos.val-valor-ipi-sist = round(tb-wt-it-imposto.vl-ipint-it,8)   WHEN round(tb-wt-it-imposto.vl-ipint-it,8)  > 0
          tt-verifica-impostos.val-valor-ipi-sist = round(tb-wt-it-imposto.vl-ipiou-it,8)   WHEN round(tb-wt-it-imposto.vl-ipiou-it,8)  > 0 .

       
    EMPTY TEMP-TABLE tb-wt-docto.
    EMPTY TEMP-TABLE tb-wt-it-docto.
    EMPTY TEMP-TABLE tb-wt-it-imposto.


    IF VALID-HANDLE(h-bodi317im2bra) THEN 
        DELETE PROCEDURE h-bodi317im2bra.
    ASSIGN h-bodi317im2bra = ?.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-conecta-ems5 DBOProgram 
PROCEDURE pi-conecta-ems5 :
&if defined(bf_mat_unidade_negocio) &then
        /* Conecta/Disconecta Bancos EMS 5 */
        def input param p-conexao as integer no-undo.
        def output param l-erro   as logical no-undo.    
        
        DEF VAR h-btb009za AS HANDLE NO-UNDO.
        
        if not avail param-global then find first param-global no-lock no-error.
        
        RUN btb/btb009za.p PERSISTENT SET h-btb009za.    
        RUN pi-conecta-bco IN h-btb009za (INPUT 1,
                                          INPUT p-conexao,
                                          INPUT param-global.empresa-prin,
                                          INPUT "all":U,
                                          OUTPUT TABLE tt_erros_conexao).    
        if  return-value <> "OK":U then do:
            FOR EACH tt_erros_conexao:
                if tt_erros_conexao.cd-erro = 25821 
                or tt_erros_conexao.cd-erro = 25822 then next.
                
                assign i-msg         = tt_erros_conexao.cd-erro
                       c-msg         = tt_erros_conexao.param-1
                       c-char        = ""
                       l-erro        = yes.
                run pi-gera-erro.
            END. /* FOR EACH tt_erros_conexao: */
        end. /* if  return-value <> "OK":U then do: */
        DELETE PROCEDURE h-btb009za.
    &endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-converte-valores-moeda DBOProgram 
PROCEDURE pi-converte-valores-moeda :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-num-di-ems LIKE {&TABLENAME}.num-di-ems NO-UNDO.
    DEF INPUT PARAM p-cdd-siscomex-dts LIKE {&TABLENAME}.cdd-siscomex-dts NO-UNDO.

    DEF VAR i-moeda-frete  LIKE decla-import-adic.cdn-moed-frete NO-UNDO.
    DEF VAR i-moeda-seguro LIKE decla-import-adic.cdn-moed-seguro NO-UNDO.

    {cxbo/bocx383a.i1}    

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-corrige-desp-itens-adic DBOProgram 
PROCEDURE pi-corrige-desp-itens-adic :
/*------------------------------------------------------------------------------
  Purpose:     Corrigir inconsistància eliminando despesas dos itens das adiá‰es 
               que n∆o constam nas adiá‰es
  Parameters:  p-num-di-ems - N£mero interno da DI
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-num-di-ems LIKE {&TABLENAME}.num-di-ems NO-UNDO.
    DEF INPUT PARAM p-cdd-siscomex-dts LIKE {&TABLENAME}.cdd-siscomex-dts NO-UNDO.

    //Se existir despesas nos itens das adiá‰es
    IF CAN-FIND (FIRST bf-despes-adic-itens 
                 WHERE bf-despes-adic-itens.num-di-ems = p-num-di-ems
                   AND bf-despes-adic-itens.cdd-siscomex-dts = p-cdd-siscomex-dts) THEN DO:

        IF NOT VALID-HANDLE(h-bocx389) THEN
            RUN cxbo/bocx389.p PERSISTENT SET h-bocx389.

        FOR EACH bf-despes-adic-itens FIELDS (num-di-ems num-adic num-seq cdn-despes cdn-emit-despes cdd-siscomex-dts)
           WHERE bf-despes-adic-itens.num-di-ems = p-num-di-ems
             AND bf-despes-adic-itens.cdd-siscomex-dts = p-cdd-siscomex-dts NO-LOCK:

            //Se a despesa n∆o estiver relacionada a adiá∆o
            IF NOT CAN-FIND(FIRST bf-despes-adic
                            WHERE bf-despes-adic.num-di-ems      = bf-despes-adic-itens.num-di-ems
                              AND bf-despes-adic.num-adic        = bf-despes-adic-itens.num-adic
                              AND bf-despes-adic.cdn-despes      = bf-despes-adic-itens.cdn-despes
                              AND bf-despes-adic.cdn-emit-despes = bf-despes-adic-itens.cdn-emit-despes
                              AND bf-despes-adic.cdd-siscomex-dts = bf-despes-adic-itens.cdd-siscomex-dts) THEN DO:

                RUN openQueryStatic IN h-bocx389 (INPUT 'Main':U) NO-ERROR.
                RUN emptyRowObject IN h-bocx389.
                RUN goToKey IN h-bocx389 (INPUT bf-despes-adic-itens.num-di-ems,
                                          INPUT bf-despes-adic-itens.num-adic,
                                          INPUT bf-despes-adic-itens.num-seq,
                                          INPUT bf-despes-adic-itens.cdn-despes,
                                          INPUT bf-despes-adic-itens.cdn-emit-despes,
                                          INPUT bf-despes-adic-itens.cdd-siscomex-dts).
                IF  RETURN-VALUE = "OK":U THEN do: 
                    RUN emptyRowErrors IN h-bocx389.
                    RUN deleteRecord IN h-bocx389.
                END.
            END. //IF NOT CAN-FIND(FIRST bf-despes-adic
        END. //FOR EACH bf-despes-adic-itens

        IF VALID-HANDLE (h-bocx389)   THEN DO:
            DELETE PROCEDURE h-bocx389.     
            ASSIGN h-bocx389 = ?.
        END.
    END. //IF CAN-FIND (FIRST bf-despes-adic-itens

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-nova DBOProgram 
PROCEDURE pi-cria-tt-nova :
    empty temp-table tt-docum-est-nova.

    find first tt-documEst-aux no-error.
    create tt-docum-est-nova.
    buffer-copy tt-documEst-aux to tt-docum-est-nova.
  
    empty temp-table tt-item-doc-est-nova.
  
    for each tt-itemDoc-est-aux:
        create tt-item-doc-est-nova.
        buffer-copy tt-itemDoc-est-aux to tt-item-doc-est-nova.
    end. /* for each tt-itemDoc-est-aux: */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-efetiva-docto DBOProgram 
PROCEDURE pi-efetiva-docto :
/*------------------------------------------------------------------------------
  Purpose:     Procedure respons†vel por efetivar o documento no recebimento atravÇs
               de uma Declaraá∆o de Importaá∆o
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VAR val-desp-aduaneira LIKE despes-adic.val-desp NO-UNDO.
    DEFINE VAR val-desp-adu-mo-real LIKE despes-adic.val-desp NO-UNDO.
    DEFINE VAR val-desp-ii          LIKE despes-adic.val-desp NO-UNDO.  

    DEFINE VAR c-list-val-doc       AS CHARACTER NO-UNDO.
    DEFINE VAR i-maior-despesa-nota AS INTEGER   NO-UNDO.
    DEFINE VAR d-vl-oturas-doc      AS DECIMAL   NO-UNDO.

    DEFINE VAR d-ii-di        AS DECIMAL  NO-UNDO.
    DEFINE VAR d-pis-di       AS DECIMAL  NO-UNDO.
    DEFINE VAR d-cofins-di    AS DECIMAL  NO-UNDO.
    DEFINE VAR d-icms-di      AS DECIMAL  NO-UNDO.
    DEFINE VAR d-frete-di     AS DECIMAL  NO-UNDO.
    DEFINE VAR d-seguro-di    AS DECIMAL  NO-UNDO.
    DEFINE VAR d-acrescimo-di AS DECIMAL  NO-UNDO.

    DEFINE VAR i-maior-seq-nfe-imp AS INTEGER NO-UNDO.
    DEFINE VAR d-val-nfe-imp-aux AS DECIMAL NO-UNDO.

    {cdp/cd4300.i4 "yes" param-imp.char-1}
    {cxbo/bocx250.i51 "yes"}

    IF NOT VALID-HANDLE(h-bocx090)   THEN RUN cxbo/bocx090.p   PERSISTENT SET h-bocx090.
    IF NOT VALID-HANDLE(h-bocx100)   THEN RUN cxbo/bocx100.p   PERSISTENT SET h-bocx100.
    IF NOT VALID-HANDLE(h-boin090)   THEN RUN inbo/boin090.p   PERSISTENT SET h-boin090.
    IF NOT VALID-HANDLE(h-boin092)   THEN RUN inbo/boin092.p   PERSISTENT SET h-boin092.
    IF NOT VALID-HANDLE(h-boin176)   THEN RUN inbo/boin176.p   PERSISTENT SET h-boin176.
    IF NOT VALID-HANDLE(h-boin0813)  THEN RUN inbo/boin0813.p  PERSISTENT SET h-boin0813.
    IF NOT VALID-HANDLE(h-boin0814)  THEN RUN inbo/boin0814.p  PERSISTENT SET h-boin0814. 
    IF NOT VALID-HANDLE(h-boin01017) THEN RUN inbo/boin01017.p PERSISTENT SET h-boin01017.
    IF NOT VALID-HANDLE(h-bocx00488) THEN RUN cxbo/bocx00488.p PERSISTENT SET h-bocx00488.
    IF NOT VALID-HANDLE(h-cdapi995)  THEN RUN cdp/cdapi995.p   PERSISTENT SET h-cdapi995.


    /*---[ Carregando as tt's para evitar erro na API ]---*/

    ASSIGN d-tot-desp-itens-aux = 0.

    IF l-tast THEN DO:
        FOR EACH tt-documEst-aux
           WHERE tt-documEst-aux.serie-docto  = c-serie-docto  
             AND tt-documEst-aux.nro-docto    = c-nro-documento
             AND tt-documEst-aux.cod-emitente = i-cod-emitente 
             AND tt-documEst-aux.nat-operacao = c-nat-operacao :

            FOR FIRST tt-docum-est-tast
                WHERE tt-docum-est-tast.serie-docto  = tt-documEst-aux.serie-docto 
                  AND tt-docum-est-tast.nro-docto    = tt-documEst-aux.nro-docto   
                  AND tt-docum-est-tast.cod-emitente = tt-documEst-aux.cod-emitente
                  AND tt-docum-est-tast.nat-operacao = tt-documEst-aux.nat-operacao:
            END.
    
            RUN pi-efetiva-docto-aux IN THIS-PROCEDURE.
    
        END.
    END.
    ELSE DO:
        FOR EACH tt-documEst-aux:
            RUN pi-efetiva-docto-aux IN THIS-PROCEDURE.
        END.
    END.


    IF l-tast THEN DO:
        FOR EACH tt-itemDoc-est-aux
           WHERE tt-itemDoc-est-aux.serie-docto  =  c-serie-docto  
             AND tt-itemDoc-est-aux.nro-docto    =  c-nro-documento
             AND tt-itemDoc-est-aux.cod-emitente =  i-cod-emitente 
             AND tt-itemDoc-est-aux.nat-operacao =  c-nat-operacao :

            RUN pi-efetiva-item-docto-aux.
        END.
    END.
    ELSE DO:
        FOR EACH tt-itemDoc-est-aux:
            RUN pi-efetiva-item-docto-aux.
        END.
    END.

    FOR EACH tt-dupli-apagar:               
        {rep/re1001c.i50}  /* variˇveis e informaªÑes utilizadas pelo re1001c.i51 */                    
        ASSIGN i-mo-codigo      = tt-dupli-apagar.mo-codigo  
               de-vl-a-pagar-mo = tt-dupli-apagar.vl-a-pagar-mo
               de-vl-descto-mo  = 0.

        {rep/re1001c.i51 "no"}                    
        {cdp/cd4300.i4  "no" tt-dupli-apagar.char-1}
    END.

    /* chamando a api */
    run rep/reapi316b.p(input "ADD",  /*cTranAction*/
                        input  table tt-docum-est,
                        input  table tt-rat-docum,
                        input  table tt-item-doc-est,
                        input  table tt-dupli-apagar,
                        input  table tt-dupli-imp,
                        output table tt-erro383a).

    IF l-tast THEN 
        FIND FIRST tt-docum-est
             WHERE tt-docum-est.serie-docto  = c-serie-docto
               AND tt-docum-est.nro-docto    = c-nro-documento
               AND tt-docum-est.cod-emitente = i-cod-emitente
               AND tt-docum-est.nat-operacao = c-nat-operacao NO-ERROR.
    ELSE
        FIND FIRST tt-docum-est NO-ERROR.


    IF  NOT CAN-FIND(FIRST tt-erro383a) THEN DO:
        RUN openQueryStatic IN h-bocx090 (INPUT "Main":U).
        FOR EACH tt-docum-est-cex:
            RUN setRecord       IN h-bocx090 (INPUT TABLE tt-docum-est-cex).
            RUN emptyRowErrors  IN h-bocx090.
            RUN createRecord    IN h-bocx090.
            IF  RETURN-VALUE = "NOK":U THEN DO:
                RUN getRowErrors IN h-bocx090 (OUTPUT TABLE RowErrors).
            END. 
            ELSE DELETE tt-docum-est-cex.
        END.
    
        RUN openQueryStatic in h-bocx100 (input "Main":U).
        FOR EACH tt-item-doc-est-cex:
            RUN setRecord      IN h-bocx100 (INPUT TABLE tt-item-doc-est-cex).
            RUN emptyRowErrors IN h-bocx100.
            RUN createRecord   IN h-bocx100.
            IF  RETURN-VALUE = "NOK":U THEN DO:
                RUN getRowErrors IN h-bocx100 (OUTPUT TABLE RowErrors).
            END.
            ELSE DELETE tt-item-doc-est-cex.
        END. /* FOR EACH tt-item-doc-est-cex: */

        /* ---[ NFE ] ------------------------------- */
        RUN openQueryStatic in h-boin0813 (input "Main":U).
        FOR EACH tt-docto-estoq-nfe-imp:
            RUN setRecord IN h-boin0813 (INPUT TABLE tt-docto-estoq-nfe-imp).
            RUN emptyRowErrors IN h-boin0813.
            RUN createRecord IN h-boin0813.
            IF RETURN-VALUE = "NOK":U THEN
                RUN getRowErrors IN h-boin0813 (OUTPUT TABLE RowErrors).
            ELSE
                DELETE tt-docto-estoq-nfe-imp.
        END.
        /* ---[ fim - NFE ] ------------------------------- */
        
        /* --- [ item NFE ] -----------------------------*/
        FOR EACH tt-item-doc-est:
            IF NOT CAN-FIND (FIRST tt-item-docto-estoq-nfe-imp 
                               WHERE tt-item-docto-estoq-nfe-imp.cod-ser-docto    = tt-item-doc-est.serie-docto
                               AND   tt-item-docto-estoq-nfe-imp.cod-docto        = tt-item-doc-est.nro-docto
                               AND   tt-item-docto-estoq-nfe-imp.cdn-emitente     = tt-item-doc-est.cod-emitente
                               AND   tt-item-docto-estoq-nfe-imp.cod-natur-operac = tt-item-doc-est.nat-operacao
                               AND   tt-item-docto-estoq-nfe-imp.num-seq          = tt-item-doc-est.sequencia    ) THEN DO:
    
                FIND FIRST processo-imp
                     WHERE processo-imp.cod-estabel = tt-nota.cod-estabel
                     AND   processo-imp.nr-proc-imp = tt-item-doc-est.nr-proc-imp  NO-LOCK NO-ERROR.

                FIND FIRST ordens-embarque 
                     WHERE ordens-embarque.cod-estabel   = tt-nota.cod-estabel
                       AND ordens-embarque.embarque      = tt-nota.embarque
                       AND ordens-embarque.numero-ordem  = tt-item-doc-est.numero-ordem
                       AND ordens-embarque.parcela       = tt-item-doc-est.parcela NO-LOCK NO-ERROR.
                     
                FOR FIRST embarque-imp FIELDS(cod-estabel embarque int-2)
                     WHERE embarque-imp.cod-estabel = tt-nota.cod-estabel
                       AND embarque-imp.embarque    = tt-nota.embarque NO-LOCK: END.

                FOR FIRST decla-import-adic-itens NO-LOCK                                        
                    WHERE decla-import-adic-itens.num-di-ems  = decla-import.num-di-ems
                    AND   decla-import-adic-itens.cdd-siscomex-dts = decla-import.cdd-siscomex-dts
                    AND   decla-import-adic-itens.num-ordem   = tt-item-doc-est.numero-ordem  
                    AND   decla-import-adic-itens.num-parcela = tt-item-doc-est.parcela:    
                END.
                     
                FOR EACH item-doc-est-cex
                     WHERE item-doc-est-cex.serie-docto       = tt-item-doc-est.serie-docto 
                       and item-doc-est-cex.nro-docto         = tt-item-doc-est.nro-docto   
                       and item-doc-est-cex.cod-emitente      = tt-item-doc-est.cod-emitente
                       and item-doc-est-cex.nat-operacao      = tt-item-doc-est.nat-operacao
                       and item-doc-est-cex.sequencia         = tt-item-doc-est.sequencia NO-LOCK:
                    IF item-doc-est-cex.cod-emitente-desp = i-emitente-ii-i50 AND
                       item-doc-est-cex.cod-desp          = i-desp-ii-i50 THEN
                       ASSIGN val-desp-ii = item-doc-est-cex.val-desp.
                    ELSE 
                       ASSIGN val-desp-aduaneira = val-desp-aduaneira + item-doc-est-cex.val-desp.
                END.

                CREATE tt-item-docto-estoq-nfe-imp.
                ASSIGN tt-item-docto-estoq-nfe-imp.cod-ser-docto     = tt-item-doc-est.serie-docto 
                       tt-item-docto-estoq-nfe-imp.cod-docto         = tt-item-doc-est.nro-docto   
                       tt-item-docto-estoq-nfe-imp.cdn-emitente      = tt-item-doc-est.cod-emitente
                       tt-item-docto-estoq-nfe-imp.cod-natur-operac  = tt-item-doc-est.nat-operacao
                       tt-item-docto-estoq-nfe-imp.num-seq           = tt-item-doc-est.sequencia   
                       tt-item-docto-estoq-nfe-imp.cdn-expdor        = IF AVAIL processo-imp THEN processo-imp.cod-fabricante ELSE 0
                       tt-item-docto-estoq-nfe-imp.cod-item          = tt-item-doc-est.it-codigo   
                       tt-item-docto-estoq-nfe-imp.val-base          = IF AVAIL decla-import-adic-itens THEN decla-import-adic-itens.val-base-ii ELSE tt-item-doc-est.preco-total[1] /*de-base-ii*/
                       tt-item-docto-estoq-nfe-imp.val-desc          = 0
                       tt-item-docto-estoq-nfe-imp.val-iof           = 0
                       tt-item-docto-estoq-nfe-imp.des-decla-import  = IF AVAIL embarque-imp THEN STRING(embarque-imp.declaracao-import) ELSE ""
                       tt-item-docto-estoq-nfe-imp.val-despesa       = IF val-desp-aduaneira <> ? THEN val-desp-aduaneira ELSE 0
                       val-desp-aduaneira                            = 0
                       tt-item-docto-estoq-nfe-imp.val-impto-import  = IF val-desp-ii <> ? THEN val-desp-ii ELSE 0
                       val-desp-ii                                   = 0.
               
            END.
        
            FIND FIRST natur-oper NO-LOCK
                 WHERE natur-oper.nat-operacao = tt-item-doc-est.nat-operacao NO-ERROR.

            IF AVAIL natur-oper AND NOT natur-oper.nota-rateio THEN DO:

                RUN piAtualizaDuimpItemNF IN h-bocx00488 (INPUT ?,
                                                          INPUT tt-nota.cod-estabel,
                                                          INPUT tt-nota.embarque,
                                                          INPUT tt-item-doc-est.numero-ordem).
                       
                IF AVAIL ordens-embarque THEN 
                    FOR FIRST duimp-item 
                        WHERE duimp-item.numero-ordem = ordens-embarque.numero-ordem no-lock:
                    END.
                    
                IF AVAIL duimp-item THEN
                    ASSIGN i-num-seq-duimp-it = duimp-item.seq-item
                           i-num-adic         = 1.
                ELSE   
                    ASSIGN i-num-seq-duimp-it = IF AVAIL ordens-embarque THEN INT(SUBSTR(ordens-embarque.char-1, 80, 4)) ELSE 0
                           i-num-adic         = &IF "{&bf_mat_versao_ems}" < "2.07" &THEN
                                                    IF AVAIL ordens-embarque THEN INT(SUBSTR(ordens-embarque.char-1, 60, 4)) ELSE 0
                                                &ELSE
                                                    IF AVAIL ordens-embarque THEN ordens-embarque.num-adic ELSE 0
                                                &ENDIF
                                                .
                                              
                ASSIGN tt-item-docto-estoq-nfe-imp.num-seq-import    = i-num-seq-duimp-it
                       tt-item-docto-estoq-nfe-imp.num-adic          = i-num-adic.
            END.

        END.

        RUN openQueryStatic in h-boin0814 (input "Main":U).
        FOR EACH tt-item-docto-estoq-nfe-imp:

            /*Guarda para caso necessite acertar o valor*/
            IF tt-item-docto-estoq-nfe-imp.val-impto-import > d-val-nfe-imp-aux THEN
                ASSIGN d-val-nfe-imp-aux   = tt-item-docto-estoq-nfe-imp.val-impto-import
                       i-maior-seq-nfe-imp =  tt-item-docto-estoq-nfe-imp.num-seq.

            RUN setRecord IN h-boin0814 (INPUT TABLE tt-item-docto-estoq-nfe-imp).
            RUN emptyRowErrors IN h-boin0814.
            RUN createRecord IN h-boin0814.
            IF RETURN-VALUE = "NOK":U THEN
                RUN getRowErrors IN h-boin0814 (OUTPUT TABLE RowErrors).
            ELSE
                DELETE tt-item-docto-estoq-nfe-imp.
        END.
        /* --- [ fim - item NFE ] -----------------------------*/



    END. /* IF  NOT CAN-FIND(FIRST tt-erro383a) */
    ELSE DO:
        
        FIND LAST RowErrors NO-LOCK NO-ERROR.
        IF AVAIL RowErrors THEN
            ASSIGN iErro = RowErrors.errorSequence + 1.
        ELSE 
            ASSIGN iErro = 1.
       

        FOR EACH tt-erro383a:
            RUN utp/ut-msgs.p (INPUT 'help',
                               INPUT tt-erro383a.cd-erro,
                               INPUT "").

            CREATE RowErrors.
            ASSIGN RowErrors.ErrorNumber      = tt-erro383a.cd-erro
                   RowErrors.ErrorDescription = tt-erro383a.desc-erro
                   RowErrors.ErrorHelp        = RETURN-VALUE
                   RowErrors.ErrorType        = "EMS":U
                   RowErrors.ErrorSubType     = "ERROR":U
                   RowErrors.ErrorSequence    = iErro      
                   iErro                      = iErro + 1. 
        END. /* FOR EACH tt-erro383a: */
        RETURN "NOK":U.
    END. /* ELSE DO: */


    IF NOT CAN-FIND(FIRST tt-embarques-gerados
                    WHERE tt-embarques-gerados.cod-embarq = SUBSTRING(tt-docum-est.char-1,1,20)) THEN DO:

        CREATE tt-embarques-gerados.
        ASSIGN tt-embarques-gerados.cod-embarq = SUBSTRING(tt-docum-est.char-1,1,20).

    END.
    
    RUN pi-atualiza-valores-impostos-di (INPUT tt-docum-est.declaracao-import,
                                         INPUT tt-docum-est.cod-emitente,     
                                         INPUT tt-docum-est.serie-docto,      
                                         INPUT tt-docum-est.nro-docto,        
                                         INPUT tt-docum-est.nat-operacao). 

    RUN pi-elimina-consist-nota (INPUT tt-docum-est.cod-emitente,     
                                 INPUT tt-docum-est.serie-docto,      
                                 INPUT tt-docum-est.nro-docto,        
                                 INPUT tt-docum-est.nat-operacao). 

    IF  VALID-HANDLE(h-boin176) AND 
        VALID-HANDLE(h-boin090)THEN DO:

        RUN openQueryStatic IN h-boin090 ("Main":U).
        RUN emptyRowObject  IN h-boin090.
        RUN goToKey2        IN h-boin090 (INPUT tt-docum-est.serie-docto,      
                                          INPUT tt-docum-est.nro-docto,        
                                          INPUT tt-docum-est.cod-emitente,
                                          INPUT tt-docum-est.nat-operacao). 

        RUN setHandleDocumEst       IN h-boin176 (INPUT h-boin090).
         
        
        RUN findEmitente  IN h-boin176 (INPUT tt-docum-est.cod-emitente).
        RUN findEstabelec IN h-boin176 (INPUT tt-docum-est.cod-estabel).
        RUN findDocumento IN h-boin176 (INPUT tt-docum-est.cod-emitente,
                                        INPUT tt-docum-est.serie-docto,
                                        INPUT tt-docum-est.nro-docto,
                                        INPUT tt-docum-est.nat-operacao).



        RUN calculateTotalItem IN h-boin176 ( input tt-docum-est.cod-emitente,
                                              input tt-docum-est.serie-docto,
                                              input tt-docum-est.nro-docto,
                                              input tt-docum-est.nat-operacao, 
                                              output table tt-total-item).
    
        FIND FIRST tt-total-item NO-LOCK NO-ERROR.

        /*Acerto das despesas com a DI*/
        IF  (round(d-tot-desp-itens-aux,2) - tt-total-item.despesa-nota) = 0.01 THEN DO:
             
            FOR FIRST docum-est                                                                                     
                WHERE docum-est.cod-emitente = tt-docum-est.cod-emitente                                                        
                  AND docum-est.serie-docto  = tt-docum-est.serie-docto                                                         
                  AND docum-est.nro-docto    = tt-docum-est.nro-docto                                                           
                  AND docum-est.nat-operacao = tt-docum-est.nat-operacao EXCLUSIVE-LOCK:

                FOR FIRST item-doc-est                                                                              
                    WHERE item-doc-est.cod-emitente = tt-docum-est.cod-emitente                                                 
                      AND item-doc-est.serie-docto  = tt-docum-est.serie-docto                                                  
                      AND item-doc-est.nro-docto    = tt-docum-est.nro-docto                                                    
                      AND item-doc-est.nat-operacao = tt-docum-est.nat-operacao 
                      AND item-doc-est.sequencia    = i-maior-sequencia EXCLUSIVE-LOCK:
                    
                    FIND FIRST decla-import
                         WHERE decla-import.cod-di-siscomex = docum-est.declaracao-import NO-LOCK NO-ERROR.

                    ASSIGN d-acrescimo-di = decla-import.val-acresc
                           d-frete-di     = decla-import.val-frete 
                           d-seguro-di    = decla-import.val-seguro
                           d-ii-di        = decla-import.val-ii-db-cr     + decla-import.val-ii-outras
                           d-pis-di       = decla-import.val-pis-db-cr    + decla-import.val-pis-outras
                           d-cofins-di    = decla-import.val-cofins-db-cr + decla-import.val-cofins-outras
                           d-icms-di      = decla-import.val-icms-db-cr   + decla-import.val-icms-outras.

                   /*Verifica qual despesa tem maior valor depois da terceira casa decimal*/
                   ASSIGN d-acrescimo-di = IF INDEX(STRING(d-acrescimo-di),",") = 0 THEN 0
                                           ELSE ROUND(DECIMAL("0,00" + SUBSTRING(string(d-acrescimo-di), INDEX(STRING(d-acrescimo-di),",") + 3)),3)
    
                          d-frete-di     = IF INDEX(STRING(d-frete-di),",") = 0 THEN 0
                                           ELSE ROUND(DECIMAL("0,00" + SUBSTRING(string(d-frete-di), INDEX(STRING(d-frete-di),",") + 3)),3)     
    
                          d-seguro-di    = IF INDEX(STRING(d-seguro-di),",") = 0 THEN 0
                                           ELSE ROUND(DECIMAL("0,00" + SUBSTRING(string(d-seguro-di), INDEX(STRING(d-seguro-di),",") + 3)),3)   
    
                          d-ii-di        = IF INDEX(STRING(d-ii-di),",") = 0 THEN 0
                                           ELSE ROUND(DECIMAL("0,00" + SUBSTRING(string(d-ii-di), INDEX(STRING(d-ii-di),",") + 3)),3)     
    
                          d-pis-di       = IF INDEX(STRING(d-pis-di),",") = 0 THEN 0
                                           ELSE ROUND(DECIMAL("0,00" + SUBSTRING(string(d-pis-di), INDEX(STRING(d-pis-di),",") + 3)),3)       
    
                          d-cofins-di    = IF INDEX(STRING(d-cofins-di),",") = 0 THEN 0
                                           ELSE ROUND(DECIMAL("0,00" + SUBSTRING(string(d-cofins-di), INDEX(STRING(d-cofins-di),",") + 3)),3)        
    
                          d-icms-di      = IF INDEX(STRING(d-icms-di),",") = 0 THEN 0
                                           ELSE ROUND(DECIMAL("0,00" + SUBSTRING(string(d-icms-di), INDEX(STRING(d-icms-di),",") + 3)),3).
                    
    
                    /*Logica par jogar a diferenca para a maior despesa do documento*/
                    ASSIGN c-list-val-doc = STRING(d-acrescimo-di)  /*1*/
                                  + "|":U + STRING(d-frete-di)      /*2*/ 
                                  + "|":U + STRING(d-seguro-di)     /*3*/
                                  + "|":U + STRING(d-ii-di)         /*4*/
                                  + "|":U + STRING(d-pis-di)        /*5*/
                                  + "|":U + STRING(d-cofins-di)     /*6*/
                                  + "|":U + STRING(d-icms-di).      /*7*/
                                                                    
    
                    ASSIGN i-maior-despesa-nota = LOOKUP(STRING(MAXIMUM(d-acrescimo-di, 
                                                                        d-frete-di,
                                                                        d-seguro-di,
                                                                        d-ii-di,
                                                                        d-pis-di,
                                                                        d-cofins-di,
                                                                        d-icms-di)), c-list-val-doc, "|":U).
    
                    CASE i-maior-despesa-nota:
                        WHEN 1 THEN /*Acrescimos*/
                            ASSIGN docum-est.valor-outras    = docum-est.valor-outras   + 0.01
                                   docum-est.despesa-nota    = docum-est.despesa-nota   + 0.01
                                   item-doc-est.despesas[1]  = item-doc-est.despesas[1] + 0.01.
                        WHEN 2 THEN /*Frete*/
                            ASSIGN docum-est.valor-frete     = docum-est.valor-frete     + 0.01
                                   docum-est.despesa-nota    = docum-est.despesa-nota    + 0.01
                                   item-doc-est.pr-total-cmi = item-doc-est.pr-total-cmi + 0.01
                                   item-doc-est.despesas[1]  = item-doc-est.despesas[1]  + 0.01.
                        WHEN 3 THEN /*Seguro*/
                            ASSIGN docum-est.valor-seguro    = docum-est.valor-seguro   + 0.01
                                   docum-est.despesa-nota    = docum-est.despesa-nota   + 0.01
                                   item-doc-est.despesas[1]  = item-doc-est.despesas[1] + 0.01.
                        WHEN 4 THEN DO: /* II */
                            ASSIGN docum-est.valor-outras   = docum-est.valor-outras   + 0.01
                                   docum-est.despesa-nota   = docum-est.despesa-nota   + 0.01
                                   item-doc-est.despesas[1] = item-doc-est.despesas[1] + 0.01.
    
                            FOR FIRST item-docto-estoq-nfe-imp                
                                WHERE item-docto-estoq-nfe-imp.cod-ser-docto    = docum-est.serie-docto 
                                  AND item-docto-estoq-nfe-imp.cod-docto        = docum-est.nro-docto   
                                  AND item-docto-estoq-nfe-imp.cdn-emitente     = docum-est.cod-emitente
                                  AND item-docto-estoq-nfe-imp.cod-natur-operac = docum-est.nat-operacao
                                  AND item-docto-estoq-nfe-imp.num-seq          = i-maior-seq-nfe-imp EXCLUSIVE-LOCK:
    
                                ASSIGN item-docto-estoq-nfe-imp.val-impto-import = item-docto-estoq-nfe-imp.val-impto-import + 0.01.
    
                            END.
    
                        END.
                        WHEN 5 THEN /*PIS*/
                            ASSIGN docum-est.vl-pis-subs    = docum-est.vl-pis-subs    + 0.01
                                   docum-est.valor-outras   = docum-est.valor-outras   + 0.01
                                   docum-est.despesa-nota   = docum-est.despesa-nota   + 0.01
                                   item-doc-est.despesas[1] = item-doc-est.despesas[1] + 0.01
                                   item-doc-est.valor-pis   = item-doc-est.valor-pis   + 0.01.
                        WHEN 6 THEN /*COFINS*/
                            ASSIGN docum-est.vl-cofins-subs  = docum-est.vl-cofins-subs  + 0.01
                                   docum-est.valor-outras    = docum-est.valor-outras    + 0.01
                                   docum-est.despesa-nota    = docum-est.despesa-nota    + 0.01
                                   item-doc-est.despesas[1]  = item-doc-est.despesas[1]  + 0.01
                                   item-doc-est.val-cofins = item-doc-est.val-cofins     + 0.01.
                        WHEN 7 THEN /*ICMS*/
                            ASSIGN  docum-est.icm-deb-cre     = docum-est.icm-deb-cre     + 0.01
                                    docum-est.valor-outras    = docum-est.valor-outras    + 0.01
                                    docum-est.despesa-nota    = docum-est.despesa-nota    + 0.01
                                    item-doc-est.despesas[1]  = item-doc-est.despesas[1]  + 0.01
                                    item-doc-est.valor-icm[1] = item-doc-est.valor-icm[1] + 0.01.
                    END CASE.
                    
    
    
                    RUN emptyRowObject  IN h-boin090.
                    RUN openQueryStatic IN h-boin090 ("Main":U).
                    RUN goToKey2        IN h-boin090 (INPUT tt-docum-est.serie-docto,      
                                                      INPUT tt-docum-est.nro-docto,        
                                                      INPUT tt-docum-est.cod-emitente,
                                                      INPUT tt-docum-est.nat-operacao). 

                    RUN calculateTotalItem IN h-boin176 ( input tt-docum-est.cod-emitente,
                                                          input tt-docum-est.serie-docto,
                                                          input tt-docum-est.nro-docto,
                                                          input tt-docum-est.nat-operacao, 
                                                          output table tt-total-item).
                    
                                                                                                                    
                END.                                                                                                
                RELEASE item-doc-est.
            END.
            RELEASE docum-est.
        END.
    
        run setTotaisNota in h-boin090 ( input table tt-total-item,
                                         input 0 ).
        
        RUN validateValues          IN h-boin090.

        /*Validando total das duplicatas*/
        IF CAN-FIND(FIRST tt-dupli-apagar) THEN DO:
            FOR FIRST tt-dupli-apagar:
                RUN goToKey  IN h-boin092 (INPUT tt-dupli-apagar.serie-docto  , 
                                           INPUT tt-dupli-apagar.nro-docto    ,
                                           INPUT tt-dupli-apagar.cod-emitente ,
                                           INPUT tt-dupli-apagar.nat-operacao ,
                                           INPUT tt-dupli-apagar.parcela).
                IF RETURN-VALUE = "OK":U THEN DO:
                    RUN getRecord IN h-boin092 (OUTPUT TABLE tt-dupli-apagar-aux).
                    RUN setRecord IN h-boin092 (INPUT TABLE tt-dupli-apagar-aux).
                    RUN findDocumEst IN h-boin092(INPUT tt-docum-est.cod-emitente, 
                                                  INPUT tt-docum-est.serie-docto,  
                                                  INPUT tt-docum-est.nro-docto,    
                                                  INPUT tt-docum-est.nat-operacao).
                    
                    RUN validateTotalDuplicata in h-boin092.
                END.                                                             
            END.
        END.
        /*fim Validando total das duplicatas*/


        FOR EACH tt-item-doc-est:
            RUN openQueryStatic IN h-boin176 ("Main":U).
            RUN emptyRowObject  IN h-boin176.
            RUN goToKey         IN h-boin176 (INPUT tt-item-doc-est.serie-docto,      
                                              INPUT tt-item-doc-est.nro-docto,        
                                              INPUT tt-item-doc-est.cod-emitente,
                                              INPUT tt-item-doc-est.nat-operacao,
                                              INPUT tt-item-doc-est.sequencia). 
            RUN validateValores IN h-boin176 (INPUT "Create":U).
        END.
    END. /* IF  VALID-HANDLE(h-boin176) THEN DO: */
    IF l-tast THEN
        DELETE tt-docum-est.

    IF  VALID-HANDLE(h-boin090) THEN DO:
        RUN destroy IN h-boin090.
        ASSIGN h-boin090 = ?.
    END.
    
    IF  VALID-HANDLE(h-boin176) THEN DO: 
        RUN destroy in h-boin176.
        ASSIGN h-boin176 = ?.
    END.
    
    IF  VALID-HANDLE(h-boin092) THEN DO: 
        RUN destroy IN h-boin092.
        ASSIGN h-boin092 = ?.
    END.

    IF  VALID-HANDLE(h-bocx090) THEN DO: 
        RUN destroy IN h-bocx090.
        ASSIGN h-bocx090 = ?.
    END.

    IF  VALID-HANDLE(h-bocx100) THEN DO: 
        RUN destroy IN h-bocx100.
        ASSIGN h-bocx100 = ?.
    END.

    IF  VALID-HANDLE(h-boin0814) THEN DO: 
        RUN destroy IN h-boin0814.
        ASSIGN h-boin0814 = ?.
    END.

    IF  VALID-HANDLE(h-boin0813) THEN DO: 
        RUN destroy IN h-boin0813.
        ASSIGN h-boin0813 = ?.
    END.

    IF VALID-HANDLE(h-boin01017) THEN DO:
        RUN destroy IN h-boin01017.
        ASSIGN h-boin01017 = ?.
    END.

    IF VALID-HANDLE(h-bocx00488) THEN DO:
        DELETE PROCEDURE h-bocx00488.
        ASSIGN h-bocx00488 = ?.
    END.

    IF VALID-HANDLE(h-cdapi995) THEN DO:
        DELETE PROCEDURE h-cdapi995.
        ASSIGN h-cdapi995 = ?.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-efetiva-docto-aux DBOProgram 
PROCEDURE pi-efetiva-docto-aux :
/*------------------------------------------------------------------------------
  Purpose:     Procedure respons†vel por criar a temp-table tt-docum-est 
               para efetivar o documento atravÇs da procedure "pi-efetiva-docto".
  Parameters:  <none>
  Notes:       Este trecho foi separado da procedure "pi-efetiva-docto" devido ao
               tast precisar passar os registros da "tt-documEst-aux" 
               um a um para criaá∆o do documento
------------------------------------------------------------------------------*/

    CREATE tt-docum-est.
    ASSIGN tt-docum-est.char-1            = tt-documEst-aux.char-1 /* neste campo fica o embarque */
           tt-docum-est.cod-emitente      = tt-documEst-aux.cod-emitente
           tt-docum-est.uf                = tt-documEst-aux.uf
           tt-docum-est.nat-operacao      = tt-documEst-aux.nat-operacao     
           tt-docum-est.nro-docto         = tt-documEst-aux.nro-docto        
           tt-docum-est.serie-docto       = tt-documEst-aux.serie-docto      
           tt-docum-est.cod-estabel       = tt-documEst-aux.cod-estabel      
           tt-docum-est.dt-emissao        = tt-documEst-aux.dt-emissao       
           tt-docum-est.dt-trans          = tt-documEst-aux.dt-trans         
           tt-docum-est.dt-venc-icm       = tt-documEst-aux.dt-venc-icm      
           tt-docum-est.dt-venc-ipi       = tt-documEst-aux.dt-venc-ipi      
           tt-docum-est.estab-fisc        = tt-documEst-aux.estab-fisc       
           tt-docum-est.observacao        = tt-documEst-aux.observacao       
           tt-docum-est.usuario           = tt-documEst-aux.usuario          
           /*tt-docum-est.conta-transit     = tt-documEst-aux.conta-transit    */
           tt-docum-est.ct-transit        = tt-documEst-aux.ct-transit
           tt-docum-est.sc-transit        = tt-documEst-aux.sc-transit
           tt-docum-est.cod-observa       = tt-documEst-aux.cod-observa      
           tt-docum-est.embarque          = tt-documEst-aux.embarque         
           tt-docum-est.nff               = tt-documEst-aux.nff              
           tt-docum-est.valor-embal       = tt-documEst-aux.valor-embal      
           tt-docum-est.pais-origem       = tt-documEst-aux.pais-origem      
           tt-docum-est.esp-docto         = tt-documEst-aux.esp-docto        
           tt-docum-est.rec-fisico        = tt-documEst-aux.rec-fisico       
           tt-docum-est.origem            = tt-documEst-aux.origem           
           tt-docum-est.via-transp        = tt-documEst-aux.via-transp       
           tt-docum-est.mod-frete         = tt-documEst-aux.mod-frete        
           tt-docum-est.cotacao-dia       = tt-documEst-aux.cotacao-dia      
           tt-docum-est.declaracao-import = tt-documEst-aux.declaracao-import
           tt-docum-est.tot-peso          = tt-documEst-aux.tot-peso         
           tt-docum-est.valor-frete       = tt-documEst-aux.valor-frete      
           tt-docum-est.valor-mercad      = tt-documEst-aux.valor-mercad
           tt-docum-est.valor-seguro      = tt-documEst-aux.valor-seguro     
           tt-docum-est.valor-embal       = tt-documEst-aux.valor-embal      
           tt-docum-est.valor-outras      = tt-documEst-aux.valor-outras
           tt-docum-est.peso-bruto-tot    = tt-documEst-aux.peso-bruto-tot   
           tt-docum-est.peso-liquido-tot  = tt-documEst-aux.peso-liquido-tot
           tt-docum-est.despesa-nota      = IF l-tast AND AVAIL tt-docum-est-tast THEN tt-docum-est-tast.despesa-nota
                                            ELSE
                                             tt-documEst-aux.valor-frete  + 
                                             tt-documEst-aux.valor-outras + 
                                             tt-documEst-aux.valor-seguro +
                                             tt-documEst-aux.valor-embal
           d-tot-desp-itens-aux           = d-tot-desp-itens-aux + 
                                             tt-documEst-aux.valor-frete  + 
                                             tt-documEst-aux.valor-outras + 
                                             tt-documEst-aux.valor-seguro +
                                             tt-documEst-aux.valor-embal.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-efetiva-item-docto-aux DBOProgram 
PROCEDURE pi-efetiva-item-docto-aux :
/*------------------------------------------------------------------------------
  Purpose:     Procedure respons†vel por criar a temp-table tt-item-doc-est 
               para efetivar o documento atravÇs da procedure "pi-efetiva-docto".
  Parameters:  <none>
  Notes:       Este trecho foi separado da procedure "pi-efetiva-docto" devido ao
               tast precisar passar os registros da "tt-itemDoc-est-aux" 
               um a um para criaá∆o do documento
------------------------------------------------------------------------------*/

    CREATE tt-item-doc-est.
    ASSIGN tt-item-doc-est.cod-emitente       = tt-itemDoc-est-aux.cod-emitente      
           tt-item-doc-est.nat-operacao       = tt-itemDoc-est-aux.nat-operacao      
           tt-item-doc-est.nat-of             = tt-itemDoc-est-aux.nat-operacao
           tt-item-doc-est.nro-docto          = tt-itemDoc-est-aux.nro-docto         
           tt-item-doc-est.serie-docto        = tt-itemDoc-est-aux.serie-docto       
           tt-item-doc-est.sequencia          = tt-itemDoc-est-aux.sequencia         
           tt-item-doc-est.quantidade         = tt-itemDoc-est-aux.quantidade        
           tt-item-doc-est.lote               = tt-itemDoc-est-aux.lote              
           tt-item-doc-est.dt-vali-lote       = tt-itemDoc-est-aux.dt-vali-lote      
           tt-item-doc-est.cod-refer          = tt-itemDoc-est-aux.cod-refer         
           tt-item-doc-est.encerra-pa         = tt-itemDoc-est-aux.encerra-pa        
           tt-item-doc-est.parcela            = tt-itemDoc-est-aux.parcela           
           tt-item-doc-est.cod-depos          = tt-itemDoc-est-aux.cod-depos         
           tt-item-doc-est.it-codigo          = tt-itemDoc-est-aux.it-codigo         
           tt-item-doc-est.numero-ordem       = tt-itemDoc-est-aux.numero-ordem      
           tt-item-doc-est.narrativa          = tt-itemDoc-est-aux.narrativa         
           tt-item-doc-est.nr-ord-produ       = tt-itemDoc-est-aux.nr-ord-prod
           /*tt-item-doc-est.conta-contabil     = tt-itemDoc-est-aux.conta-contabil    */
           tt-item-doc-est.ct-codigo          = tt-itemDoc-est-aux.ct-codigo
           tt-item-doc-est.sc-codigo          = tt-itemDoc-est-aux.sc-codigo
           tt-item-doc-est.cod-localiz        = tt-itemDoc-est-aux.cod-localiz       
           tt-item-doc-est.nro-comp           = tt-itemDoc-est-aux.nro-comp          
           tt-item-doc-est.class-fiscal       = tt-itemDoc-est-aux.class-fiscal      
           tt-item-doc-est.nr-proc-imp        = tt-itemDoc-est-aux.nr-proc-imp       
           tt-item-doc-est.desconto           = tt-itemDoc-est-aux.desconto          
           tt-item-doc-est.baixa-ce           = tt-itemDoc-est-aux.baixa-ce          
           tt-item-doc-est.valor-iss          = tt-itemDoc-est-aux.valor-iss         
           tt-item-doc-est.baixa-ce           = tt-itemDoc-est-aux.baixa-ce          
           tt-item-doc-est.despesas[1]        = tt-itemDoc-est-aux.despesas          
           tt-item-doc-est.preco-total        = tt-itemDoc-est-aux.preco-total       
           tt-item-doc-est.qt-do-forn         = tt-itemDoc-est-aux.qt-do-forn        
           tt-item-doc-est.item-pai           = tt-itemDoc-est-aux.item-pai          
           tt-item-doc-est.cod-roteiro        = tt-itemDoc-est-aux.cod-roteiro       
           tt-item-doc-est.op-codigo          = tt-itemDoc-est-aux.op-codigo         
           tt-item-doc-est.item-pai           = tt-itemDoc-est-aux.item-pai          
           tt-item-doc-est.cod-roteiro        = tt-itemDoc-est-aux.cod-roteiro       
           tt-item-doc-est.op-codigo          = tt-itemDoc-est-aux.op-codigo         
           tt-item-doc-est.nr-ato-concessorio = tt-itemDoc-est-aux.nr-ato-concessorio
           tt-item-doc-est.cd-trib-icm        = tt-itemDoc-est-aux.cd-trib-icm       
           tt-item-doc-est.aliquota-icm       = tt-itemDoc-est-aux.aliquota-icm      
           tt-item-doc-est.cd-trib-ipi        = tt-itemDoc-est-aux.cd-trib-ipi       
           tt-item-doc-est.aliquota-ipi       = tt-itemDoc-est-aux.aliquota-ipi      
           tt-item-doc-est.base-ipi           = tt-itemDoc-est-aux.base-ipi          
           tt-item-doc-est.valor-ipi          = tt-itemDoc-est-aux.valor-ipi         
           tt-item-doc-est.ipi-ntrib          = tt-itemDoc-est-aux.ipi-ntrib         
           tt-item-doc-est.ipi-outras         = tt-itemDoc-est-aux.ipi-outras     
           &IF '{&bf_lote_avancado_liberado}' = 'yes' &THEN /* Campos Projeto FDA */
               tt-item-doc-est.cod-lote-fabrican       = tt-itemDoc-est-aux.cod-lote-fabrican      
               tt-item-doc-est.dat-fabricc-lote        = tt-itemDoc-est-aux.dat-fabricc-lote       
               tt-item-doc-est.dat-valid-lote-fabrican = tt-itemDoc-est-aux.dat-valid-lote-fabrican
               tt-item-doc-est.nom-fabrican            = tt-itemDoc-est-aux.nom-fabrican           
           &ENDIF           
           tt-item-doc-est.peso-liquido       = tt-itemDoc-est-aux.peso-liquido-DI.

    run piAtualizaNBS.
           
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-item-doc-est-tribut DBOProgram 
PROCEDURE pi-cria-item-doc-est-tribut :
/*------------------------------------------------------------------------------
  Purpose:     Procedure respons†vel por criar a tabela item-doc-est-tribut 
               para efetivar o documento atravÇs da procedure "pi-efetiva-docto".
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   
    DEFINE VARIABLE c-nom-trib  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-cod-campo AS CHARACTER   NO-UNDO.
    
    FOR EACH decla-imp-adic-it-trib
       WHERE decla-imp-adic-it-trib.num-di-ems       = decla-import-adic-itens.num-di-ems
         AND decla-imp-adic-it-trib.num-adic         = decla-import-adic-itens.num-adic
         AND decla-imp-adic-it-trib.num-seq          = decla-import-adic-itens.num-seq
         AND decla-imp-adic-it-trib.cdd-siscomex-dts = decla-import-adic-itens.cdd-siscomex-dts NO-LOCK:
         
        CASE decla-imp-adic-it-trib.nom-trib:
            WHEN "IBSUF" THEN
                ASSIGN c-nom-trib = rep.imp.Imposto:IBS-UF.
            WHEN "CBS" THEN
                ASSIGN c-nom-trib = rep.imp.Imposto:CBS.
            WHEN "IBSMUN" THEN
                ASSIGN c-nom-trib = rep.imp.Imposto:IBS-MUN.
            WHEN "IS" THEN
                ASSIGN c-nom-trib = rep.imp.Imposto:IS.
            OTHERWISE
                ASSIGN c-nom-trib = decla-imp-adic-it-trib.nom-trib.
        END CASE. 
                
        IF decla-imp-adic-it-trib.cod-campo = "C-CLASS-TRIB" THEN 
            ASSIGN c-cod-campo = rep.imp.AtributoImposto:C-CLASS-TRIB.
        ELSE
        IF decla-imp-adic-it-trib.cod-campo = "COD-TRIB" THEN 
            ASSIGN c-cod-campo = rep.imp.AtributoImposto:COD-TRIB.
        ELSE
        IF decla-imp-adic-it-trib.cod-campo = "C-CLASS-TRIB-REG" THEN 
            ASSIGN c-cod-campo = rep.imp.AtributoImposto:C-CLASS-TRIB-REG.
        ELSE 
        IF decla-imp-adic-it-trib.cod-campo = "CST-REG" THEN 
            ASSIGN c-cod-campo = rep.imp.AtributoImposto:CST-REG.
        ELSE
        IF decla-imp-adic-it-trib.cod-campo = "VALOR-REG" THEN 
            ASSIGN c-cod-campo = rep.imp.AtributoImposto:VALOR-REG.
        ELSE
        IF decla-imp-adic-it-trib.cod-campo = "BASE-REG" THEN 
            ASSIGN c-cod-campo = rep.imp.AtributoImposto:BASE-REG.
        ELSE
        IF decla-imp-adic-it-trib.cod-campo = "ALIQ-EFETIVA-REG" THEN 
            ASSIGN c-cod-campo = rep.imp.AtributoImposto:ALIQ-EFETIVA-REG.
        ELSE
        IF decla-imp-adic-it-trib.cod-campo = "ALIQ-RED" THEN 
            ASSIGN c-cod-campo = rep.imp.AtributoImposto:ALIQ-RED.
        ELSE
        IF decla-imp-adic-it-trib.cod-campo = "ALIQ-EFETIVA" THEN 
            ASSIGN c-cod-campo = rep.imp.AtributoImposto:ALIQ-EFETIVA.
        ELSE
        IF decla-imp-adic-it-trib.cod-campo = "OUTROS" THEN 
            ASSIGN c-cod-campo = rep.imp.AtributoImposto:VALOR.
        ELSE
        IF decla-imp-adic-it-trib.cod-campo = "ALIQ-ESPEC-UN" THEN 
            ASSIGN c-cod-campo = rep.imp.AtributoImposto:ALIQ-ESPEC-UN.
        ELSE
        IF decla-imp-adic-it-trib.cod-campo = "QTDE-TRIBUT" THEN 
            ASSIGN c-cod-campo = rep.imp.AtributoImposto:QTDE-TRIBUT.
        ELSE
        IF decla-imp-adic-it-trib.cod-campo = "UN-TRIBUT" THEN 
            ASSIGN c-cod-campo = rep.imp.AtributoImposto:UN-TRIBUT.
        ELSE
            ASSIGN c-cod-campo = decla-imp-adic-it-trib.cod-campo.

        run pi-EfetivaItemDocEstTribut (input c-nom-trib,
                                        input c-cod-campo).

        IF  decla-imp-adic-it-trib.cod-campo = "ALIQ-EFETIVA-REG" then do:
            ASSIGN c-cod-campo = rep.imp.AtributoImposto:ALIQUOTA-REG.
            run pi-EfetivaItemDocEstTribut (input c-nom-trib,
                                            input c-cod-campo).
        end.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-EfetivaItemDocEstTribut DBOProgram 
PROCEDURE pi-EfetivaItemDocEstTribut :
/*------------------------------------------------------------------------------
  Purpose:     Procedure respons†vel por efetivar a criaá∆o da tabela 
               item-doc-est-tribut.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-nom-trib  AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-campo AS CHARACTER   NO-UNDO.

    FIND FIRST item-doc-est-tribut
         WHERE item-doc-est-tribut.cod-serie-docto  = item-doc-est.serie-docto    
         AND   item-doc-est-tribut.cod-num-docto    = item-doc-est.nro-docto      
         AND   item-doc-est-tribut.cdn-emitente     = item-doc-est.cod-emitente   
         AND   item-doc-est-tribut.cod-natur-operac = item-doc-est.nat-operacao   
         AND   item-doc-est-tribut.num-seq          = item-doc-est.sequencia      
         AND   item-doc-est-tribut.nom-trib         = p-nom-trib
         AND   item-doc-est-tribut.cod-campo        = p-cod-campo EXCLUSIVE-LOCK NO-ERROR.        
    IF NOT AVAIL item-doc-est-tribut THEN DO:    
       CREATE item-doc-est-tribut.
       ASSIGN item-doc-est-tribut.cod-serie-docto   = item-doc-est.serie-docto
              item-doc-est-tribut.cod-num-docto     = item-doc-est.nro-docto
              item-doc-est-tribut.cdn-emitente      = item-doc-est.cod-emitente
              item-doc-est-tribut.cod-natur-operac  = item-doc-est.nat-operacao
              item-doc-est-tribut.num-seq           = item-doc-est.sequencia
              item-doc-est-tribut.nom-trib          = p-nom-trib
              item-doc-est-tribut.cod-campo         = p-cod-campo.
    END.
    ASSIGN item-doc-est-tribut.cod-conteudo         = decla-imp-adic-it-trib.cod-conteudo.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-elimina-conf-trib DBOProgram 
PROCEDURE pi-elimina-conf-trib :
/*:T------------------------------------------------------------------------------
  Purpose:     Realiza eliminaá∆o das tabelas geradas para o configurador de tributos
  Parameters:  pi-num-di-ems (entrada): N£mero da DI do EMS (integer)
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pi-num-di-ems LIKE decla-import.num-di-ems NO-UNDO.
    DEFINE INPUT PARAMETER pd-cdd-siscomex-dts LIKE decla-import.cdd-siscomex-dts NO-UNDO.

    FOR EACH decla-import-embarq NO-LOCK
        WHERE decla-import-embarq.num-di-ems = pi-num-di-ems
          AND decla-import-embarq.cdd-siscomex-dts = pd-cdd-siscomex-dts:

        FOR EACH  ct-trib-item-doc-est EXCLUSIVE-LOCK
            WHERE ct-trib-item-doc-est.cod-embarq = decla-import-embarq.cod-embarq 
            AND   ct-trib-item-doc-est.cod-estab  = decla-import-embarq.cod-estab :

            IF INDEX(ct-trib-item-doc-est.cod-configur-trib,"-") > 0 THEN 
               ASSIGN c-cod-ajuste = SUBSTRING(ct-trib-item-doc-est.cod-configur-trib, INDEX(ct-trib-item-doc-est.cod-configur-trib,"-") + 1 , LENGTH(TRIM(ct-trib-item-doc-est.cod-configur-trib))).
            ELSE 
               ASSIGN c-cod-ajuste = ct-trib-item-doc-est.cod-configur-trib.

            FIND FIRST nota-fisc-adc EXCLUSIVE-LOCK
                 WHERE nota-fisc-adc.cod-estab        = ct-trib-item-doc-est.cod-estab
                 AND   nota-fisc-adc.cod-serie        = ct-trib-item-doc-est.cod-ser-docto
                 AND   nota-fisc-adc.cod-nota-fisc    = ct-trib-item-doc-est.cod-docto
                 AND   nota-fisc-adc.cdn-emitente     = ct-trib-item-doc-est.cdn-emitente
                 AND   nota-fisc-adc.cod-natur-operac = ct-trib-item-doc-est.cod-natur-operac
                 AND   nota-fisc-adc.idi-tip-dado     = 7 /* outras obrigaá‰es tribut†rias */
                 AND   nota-fisc-adc.cod-item         = ct-trib-item-doc-est.cod-item
                 AND   nota-fisc-adc.cod-ajust        = c-cod-ajuste
                 AND   nota-fisc-adc.num-livre-1      = ct-trib-item-doc-est.num-seq NO-ERROR.
            IF AVAIL nota-fisc-adc THEN
               DELETE nota-fisc-adc.
                 
            DELETE ct-trib-item-doc-est.
        END.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-elimina-consist-nota DBOProgram 
PROCEDURE pi-elimina-consist-nota :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    def input param pcod-emitente    like docum-est.cod-emitente       no-undo.
    def input param pserie-docto     like docum-est.serie-docto        no-undo.
    def input param pnro-docto       like docum-est.nro-docto          no-undo.
    def input param pnat-operacao    like docum-est.nat-operacao       no-undo.

    FOR EACH consist-nota EXCLUSIVE-LOCK
        WHERE consist-nota.cod-emitente  = pcod-emitente   
        AND   consist-nota.serie-docto   = pserie-docto    
        AND   consist-nota.nro-docto     = pnro-docto      
        AND   consist-nota.nat-operacao  = pnat-operacao  :
        DELETE consist-nota.
    END. /* FOR EACH  decla-import-adic-itens NO-LOCK */
RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-Errors-CalcImpostos DBOProgram 
PROCEDURE pi-Errors-CalcImpostos :
    DEFINE INPUT PARAMETER p-imposto      AS INTEGER          NO-UNDO.
    DEFINE INPUT PARAMETER p-controle     AS CHARACTER        NO-UNDO. /* variavel que vai dizer de onde esta sendo gerado o erro- item,adicao ou DI  */
    DEFINE INPUT PARAMETER p-di-ems       AS INTEGER          NO-UNDO.
    DEFINE INPUT PARAMETER p-num-adic     AS INTEGER          NO-UNDO.
    DEFINE INPUT PARAMETER p-num-seq      AS INTEGER          NO-UNDO.
    DEFINE INPUT PARAMETER p-ErrorSubType AS CHARACTER        NO-UNDO.
    DEFINE OUTPUT PARAMETER p-possui-erro AS LOGICAL EXTENT 2 NO-UNDO.
                                                               
    
    DEFINE VARIABLE c-desc-geral-comp AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-desc-help-comp  AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-help-warning    AS CHARACTER NO-UNDO.
    
    CREATE RowErrors.

    CASE p-imposto:
        WHEN  1 THEN DO: /* Imposto de Importacao - II */

            IF p-ErrorSubType = "ERROR":U THEN DO:

                IF c-desc-geral[1] = "" OR c-desc-help[1] = "" THEN DO:
                    {utp/ut-liter.i Os_valores_de_II_n∆o_foram_c†lculados_corretamente *}
                    ASSIGN c-desc-geral[1] = RETURN-VALUE.
                    {utp/ut-liter.i Efetuar_a_verificaá∆o_das_parametrizaá‰es_utilizadas_no_c†lculo_do_Imposto_de_Importaá∆o_para: *}
                    ASSIGN c-desc-help[1] = return-value + chr(10) + chr(10).
                END.

                CASE p-controle:
                    WHEN "Item-adic":U THEN DO: 
                        {utp/ut-liter.i _nos_itens_da_adiá∆o *} 
                        ASSIGN c-desc-geral-comp =  RETURN-VALUE. 

                       {utp/ut-liter.i Adiá∆o *}
                       ASSIGN c-desc-help-comp = return-value + ": " + string(p-num-adic) + chr(10).
                       {utp/ut-liter.i Sequencia *}
                       ASSIGN c-desc-help-comp = c-desc-help-comp + Return-value + ": " + string(p-num-seq) + chr(10) + "DI: ":U + string(p-di-ems).

                    END.
                    WHEN "adicao":U THEN DO: 
                        {utp/ut-liter.i nas_adiá‰es *} 
                        ASSIGN c-desc-geral-comp =  RETURN-VALUE. 

                       {utp/ut-liter.i Adiá∆o *}
                       ASSIGN c-desc-help-comp = return-value + ": " + string(p-num-adic) + chr(10) + "DI: ":U + string(p-di-ems).

                    END.
                    WHEN "decla-imp":U THEN DO: 
                        {utp/ut-liter.i na_declaraá∆o_de_importaá∆o *} 
                        ASSIGN c-desc-geral-comp =  RETURN-VALUE. 
                                                  
                        ASSIGN c-desc-help-comp = "DI: ":U + string(p-di-ems).

                    END.
                END CASE.
                     
                
                ASSIGN RowErrors.ErrorNumber      = 17006
                       RowErrors.ErrorDescription = c-desc-geral[1] + c-desc-geral-comp  
                       RowErrors.ErrorHelp        = c-desc-help[1] + c-desc-help-comp
                       RowErrors.ErrorType        = "EMS":U
                       RowErrors.ErrorSubType     = p-ErrorSubType
                       p-possui-erro[1]           = YES.
            END.
            ELSE DO:

                IF c-desc-msg = "" THEN DO:
                    {utp/ut-liter.i "Atená∆o! Al°quota_Zerada_e_Imposto_de_Importaá∆o_Tributado!" *}
                    ASSIGN c-desc-msg = return-value.
                END.
                
                CASE p-controle:
                    WHEN "Item-adic":U THEN DO:
                        
                       {utp/ut-liter.i "Verifique_se_essa_Ç_a_parametrizaá∆o_desejada_para_o_II_da:" *}
                       ASSIGN c-help-warning = return-value + chr(10) + chr(10).
                       {utp/ut-liter.i Adiá∆o *}
                       ASSIGN c-help-warning = c-help-warning + return-value + ": " + string(p-num-adic) + chr(10).
                       {utp/ut-liter.i Sequencia *}
                       ASSIGN c-help-warning = c-help-warning + Return-value + ": " + string(p-num-seq) + chr(10) + "DI: ":U + string(p-di-ems).

                    END.
                    WHEN "adicao":U THEN DO: 
                        
                       {utp/ut-liter.i "Verifique_se_essa_Ç_a_parametrizaá∆o_desejada_para_o_II_da:" *}
                       ASSIGN c-help-warning = return-value + chr(10) + chr(10).
                       {utp/ut-liter.i Adiá∆o *}
                       ASSIGN c-help-warning = c-help-warning + return-value + ": " + string(p-num-adic) + chr(10) + "DI: ":U + string(p-di-ems).

                    END.
                    WHEN "decla-imp":U THEN DO: 
                                                
                        {utp/ut-liter.i "Verifique_se_essa_Ç_a_parametrizaá∆o_desejada_para_o_II_da:" *}
                        ASSIGN c-help-warning = return-value + chr(10) + chr(10) + "DI: ":U + string(p-di-ems).

                    END.
                END CASE.

                ASSIGN RowErrors.ErrorNumber      = 17006
                       RowErrors.ErrorDescription = c-desc-msg
                       RowErrors.ErrorHelp        = c-help-warning 
                       RowErrors.ErrorType        = "EMS":U
                       RowErrors.ErrorSubType     = p-ErrorSubType
                       p-possui-erro[2]           = YES.
            END.
        END.

        WHEN 2 THEN DO: /* IPI */

            IF p-ErrorSubType = "ERROR":U THEN DO:

                IF c-desc-geral[2] = "" OR c-desc-help[2] = "" THEN DO:
                    {utp/ut-liter.i Os_valores_de_IPI_n∆o_foram_c†lculados_corretamente *}
                    ASSIGN c-desc-geral[2] = RETURN-VALUE.
                    {utp/ut-liter.i Efetuar_a_verificaá∆o_das_parametrizaá‰es_utilizadas_no_c†lculo_do_IPI_para: *}
                    ASSIGN c-desc-help[2] = return-value + chr(10) + chr(10).
                END.
    
    
                CASE p-controle:
                    WHEN "Item-adic":U THEN DO: 
                        {utp/ut-liter.i nos_itens_da_adiá∆o *} 
                        ASSIGN c-desc-geral-comp =  RETURN-VALUE. 
    
                       {utp/ut-liter.i Adiá∆o *}
                       ASSIGN c-desc-help-comp = return-value + ": " + string(p-num-adic) + chr(10).
                       {utp/ut-liter.i Sequencia *}
                       ASSIGN c-desc-help-comp = c-desc-help-comp + Return-value + ": " + string(p-num-seq) + chr(10) + "DI: ":U + string(p-di-ems).
    
                    END.
                    WHEN "adicao":U THEN DO: 
                        {utp/ut-liter.i nas_adiá‰es *} 
                        ASSIGN c-desc-geral-comp =  RETURN-VALUE. 
    
                       {utp/ut-liter.i Adiá∆o *}
                       ASSIGN c-desc-help-comp = return-value + ": " + string(p-num-adic) + chr(10) + "DI: ":U + string(p-di-ems).
    
                    END.
                    WHEN "decla-imp":U THEN DO: 
                        {utp/ut-liter.i na_declaraá∆o_de_importaá∆o *} 
                        ASSIGN c-desc-geral-comp =  RETURN-VALUE. 
                                               
                        ASSIGN c-desc-help-comp = "DI: ":U + string(p-di-ems).
    
                    END.
                END CASE.
                
                
                ASSIGN RowErrors.ErrorNumber      = 17006
                       RowErrors.ErrorDescription = c-desc-geral[2] + c-desc-geral-comp  
                       RowErrors.ErrorHelp        = c-desc-help[2] + c-desc-help-comp
                       RowErrors.ErrorType        = "EMS":U
                       RowErrors.ErrorSubType     = p-ErrorSubType
                       p-possui-erro[1]           = YES.
            END.
            ELSE DO:
                
                IF c-desc-geral-comp = "" THEN DO:
                    {utp/ut-liter.i "Atená∆o! Al°quota_Zerada_e_IPI_Tributado!" *}
                    ASSIGN c-desc-geral-comp = return-value.
                END.
                
                CASE p-controle:
                    WHEN "Item-adic":U THEN DO: 
                        
                       {utp/ut-liter.i "Verifique_se_essa_Ç_a_parametrizaá∆o_desejada_para_o_IPI_da:" *}
                       ASSIGN c-desc-help-comp = return-value + chr(10) + chr(10).
                       {utp/ut-liter.i Adiá∆o *}
                       ASSIGN c-desc-help-comp = c-desc-help-comp + return-value + ": " + string(p-num-adic) + chr(10).
                       {utp/ut-liter.i Sequencia *}
                       ASSIGN c-desc-help-comp = c-desc-help-comp + Return-value + ": " + string(p-num-seq) + chr(10) + "DI: ":U + string(p-di-ems).

                    END.
                    WHEN "adicao":U THEN DO: 
                        
                       {utp/ut-liter.i "Verifique_se_essa_Ç_a_parametrizaá∆o_desejada_para_o_IPI_da:" *}
                       ASSIGN c-desc-help-comp = return-value + chr(10) + chr(10).
                       {utp/ut-liter.i Adiá∆o *}
                       ASSIGN c-desc-help-comp =  c-desc-help-comp + return-value + ": " + string(p-num-adic) + chr(10) + "DI: ":U + string(p-di-ems).

                    END.
                    WHEN "decla-imp":U THEN DO: 
                                                
                        {utp/ut-liter.i "Verifique_se_essa_Ç_a_parametrizaá∆o_desejada_para_o_IPI_da:" *}
                        ASSIGN c-desc-help-comp = return-value + chr(10) + chr(10) + "DI: ":U + string(p-di-ems).

                    END.
                END CASE.

                ASSIGN RowErrors.ErrorNumber      = 17006
                       RowErrors.ErrorDescription = c-desc-geral-comp
                       RowErrors.ErrorHelp        = c-desc-help-comp 
                       RowErrors.ErrorType        = "EMS":U
                       RowErrors.ErrorSubType     = p-ErrorSubType
                       p-possui-erro[2]           = YES.
            END.
        END.

        WHEN 3 THEN DO: /* ICMS */

            IF c-desc-geral[3] = "" OR c-desc-help[3] = "" THEN DO:
                {utp/ut-liter.i Os_valores_de_ICMS_n∆o_foram_c†lculados_corretamente *}
                ASSIGN c-desc-geral[3] = RETURN-VALUE.
                {utp/ut-liter.i Efetuar_a_verificaá∆o_das_parametrizaá‰es_utilizadas_no_c†lculo_do_ICMS_para: *}
                 ASSIGN c-desc-help[3] = return-value + chr(10) + chr(10).
            END.

            
            CASE p-controle:
                WHEN "Item-adic":U THEN DO: 
                    {utp/ut-liter.i nos_itens_da_adiá∆o *} 
                    ASSIGN c-desc-geral-comp =  RETURN-VALUE. 

                   {utp/ut-liter.i Adiá∆o *}
                   ASSIGN c-desc-help-comp =  return-value + ": " + string(p-num-adic) + chr(10).
                   {utp/ut-liter.i Sequencia *}
                   ASSIGN c-desc-help-comp = c-desc-help-comp + Return-value + ": " + string(p-num-seq) + chr(10) + "DI: ":U + string(p-di-ems).

                END.
                WHEN "adicao":U THEN DO: 
                    {utp/ut-liter.i nas_adiá‰es *} 
                    ASSIGN c-desc-geral-comp =  RETURN-VALUE. 

                   {utp/ut-liter.i Adiá∆o *}
                   ASSIGN c-desc-help-comp = return-value + ": " + string(p-num-adic) + chr(10) + "DI: ":U + string(p-di-ems).

                END.
                WHEN "decla-imp":U THEN DO: 
                    {utp/ut-liter.i na_declaraá∆o_de_importaá∆o *} 
                    ASSIGN c-desc-geral-comp =  RETURN-VALUE. 
                    
                    ASSIGN c-desc-help-comp = "DI: ":U + string(p-di-ems).

                END.
            END CASE.
            
            
            ASSIGN RowErrors.ErrorNumber      = 17006
                   RowErrors.ErrorDescription = c-desc-geral[3] + c-desc-geral-comp  
                   RowErrors.ErrorHelp        = c-desc-help[3] + c-desc-help-comp 
                   RowErrors.ErrorType        = "EMS":U
                   RowErrors.ErrorSubType     = p-ErrorSubType
                   p-possui-erro[1]           = YES.

        END.

        WHEN 4 THEN DO: /* PIS */

            IF c-desc-geral[4] = "" OR c-desc-help[4] = "" THEN DO:
                {utp/ut-liter.i Os_valores_de_PIS_n∆o_foram_c†lculados_corretamente *}
                ASSIGN c-desc-geral[4] = RETURN-VALUE.
                {utp/ut-liter.i Efetuar_a_verificaá∆o_das_parametrizaá‰es_utilizadas_no_c†lculo_do_PIS_para: *}
                ASSIGN c-desc-help[4] = return-value + chr(10) + chr(10).
            END.

            
            CASE p-controle:
                WHEN "Item-adic":U THEN DO: 
                    {utp/ut-liter.i nos_itens_da_adiá∆o *} 
                    ASSIGN c-desc-geral-comp =  RETURN-VALUE.
                   
                   {utp/ut-liter.i Adiá∆o *}
                   ASSIGN c-desc-help-comp = return-value + ": " + string(p-num-adic) + chr(10).
                   {utp/ut-liter.i Sequencia *}
                   ASSIGN c-desc-help-comp = c-desc-help-comp + Return-value + ": " + string(p-num-seq) + chr(10) + "DI: ":U + string(p-di-ems).

                END.
                WHEN "adicao":U THEN DO: 
                    {utp/ut-liter.i nas_adiá‰es *} 
                    ASSIGN c-desc-geral-comp =  RETURN-VALUE. 

                   {utp/ut-liter.i Adiá∆o *}
                   ASSIGN c-desc-help-comp = return-value + ": " + string(p-num-adic) + chr(10) + "DI: ":U + string(p-di-ems).

                END.
                WHEN "decla-imp":U THEN DO: 
                    {utp/ut-liter.i na_declaraá∆o_de_importaá∆o *} 
                    ASSIGN c-desc-geral-comp =  RETURN-VALUE. 
                    
                    ASSIGN c-desc-help-comp = "DI: ":U + string(p-di-ems).

                END.
            END CASE.
            
            
            ASSIGN RowErrors.ErrorNumber      = 17006
                   RowErrors.ErrorDescription = c-desc-geral[4] + c-desc-geral-comp  
                   RowErrors.ErrorHelp        = c-desc-help[4] + c-desc-help-comp 
                   RowErrors.ErrorType        = "EMS":U
                   RowErrors.ErrorSubType     = p-ErrorSubType
                   p-possui-erro[1]           = YES.

        END.

        WHEN 5 THEN DO: /* COFINS */

            IF c-desc-geral[5] = "" OR c-desc-help[5] = "" THEN DO:
                {utp/ut-liter.i Os_valores_de_COFINS_n∆o_foram_c†lculados_corretamente *}
                ASSIGN c-desc-geral[5] = RETURN-VALUE.
                {utp/ut-liter.i Efetuar_a_verificaá∆o_das_parametrizaá‰es_utilizadas_no_c†lculo_do_COFINS_para: *}
                ASSIGN c-desc-help[5] = return-value + chr(10) + chr(10).
            END.

            
            CASE p-controle:
                WHEN "Item-adic":U THEN DO: 
                    {utp/ut-liter.i nos_itens_da_adiá∆o *} 
                    ASSIGN c-desc-geral-comp =  RETURN-VALUE. 

                   {utp/ut-liter.i Adiá∆o *}
                   ASSIGN c-desc-help-comp = return-value + ": " + string(p-num-adic) + chr(10).
                   {utp/ut-liter.i Sequencia *}
                   ASSIGN c-desc-help-comp = c-desc-help-comp + Return-value + ": " + string(p-num-seq) + chr(10) + "DI: ":U + string(p-di-ems).

                END.
                WHEN "adicao":U THEN DO: 
                    {utp/ut-liter.i nas_adiá‰es *} 
                    ASSIGN c-desc-geral-comp =  RETURN-VALUE. 

                   {utp/ut-liter.i Adiá∆o *}
                   ASSIGN c-desc-help-comp = return-value + ": " + string(p-num-adic) + chr(10) + "DI: ":U + string(p-di-ems).

                END.
                WHEN "decla-imp":U THEN DO: 
                    {utp/ut-liter.i na_declaraá∆o_de_importaá∆o *} 
                    ASSIGN c-desc-geral-comp =  RETURN-VALUE. 
                                             
                    ASSIGN c-desc-help-comp = "DI: ":U + string(p-di-ems).

                END.
            END CASE.
            
            
            ASSIGN RowErrors.ErrorNumber      = 17006
                   RowErrors.ErrorDescription = c-desc-geral[5] + c-desc-geral-comp  
                   RowErrors.ErrorHelp        = c-desc-help[5]  + c-desc-help-comp
                   RowErrors.ErrorType        = "EMS":U
                   RowErrors.ErrorSubType     = p-ErrorSubType
                   p-possui-erro[1]           = YES.


        END.


    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-despesa-item DBOProgram 
PROCEDURE pi-gera-despesa-item :
DEF VAR d-val-desp-convert LIKE despes-adic.val-despes NO-UNDO.

    ASSIGN  de-tot-despesa-aux = 0
            de-tot-frete-aux = 0.

    FOR FIRST decla-import NO-LOCK
        WHERE decla-import.cod-di-siscomex = tt-documEst-aux.declaracao-import: END.

    FOR FIRST param-imp NO-LOCK
        WHERE param-imp.cod-estabel = decla-import.cod-estab: END.

    {cdp/cd4300.i4 "yes" param-imp.char-1}
    {cxbo/bocx250.i51 "yes"}
    
    assign i-cod-desp-ii     = i-desp-ii-i50
           i-cod-emitente-ii = i-emitente-ii-i50.

    EMPTY TEMP-TABLE tt-despesAdic-itens.
    
    FOR FIRST decla-import-adic-itens NO-LOCK
        WHERE decla-import-adic-itens.num-di-ems  = decla-import.num-di-ems        
        AND   decla-import-adic-itens.cdd-siscomex-dts = decla-import.cdd-siscomex-dts
        AND   decla-import-adic-itens.num-ordem   = tt-itemDoc-est-aux.numero-ordem
        AND   decla-import-adic-itens.num-parcela = tt-itemDoc-est-aux.parcela:    

        FOR EACH  despes-adic-itens NO-LOCK
            WHERE despes-adic-itens.num-di-ems = decla-import-adic-itens.num-di-ems
            AND   despes-adic-itens.num-adic   = decla-import-adic-itens.num-adic
            AND   despes-adic-itens.num-seq    = decla-import-adic-itens.num-seq
            AND   despes-adic-itens.cdd-siscomex-dts = decla-import-adic-itens.cdd-siscomex-dts:
            CREATE tt-despesAdic-itens.
            BUFFER-COPY despes-adic-itens TO tt-despesAdic-itens.
        END. /* FOR EACH  despes-adic-itens */                   

        /*--- II ---*/
        IF  i-cod-desp-ii <> 0 
            AND decla-import-adic-itens.val-ii-db-cr > 0 THEN DO:
            FOR FIRST emitente NO-LOCK
                WHERE emitente.cod-emitente = i-cod-emitente-ii: END. /* FOR FIRST emitente NO-LOCK */
            IF NOT CAN-FIND(FIRST tt-despesAdic-itens
                            WHERE tt-despesAdic-itens.cdn-despes             = i-cod-desp-ii
                            AND   tt-despesAdic-itens.cdn-emit-despes        = i-cod-emitente-ii
                            AND   tt-despesAdic-itens.num-ordem              = decla-import-adic-itens.num-ordem
                            AND   tt-despesAdic-itens.num-parcela            = decla-import-adic-itens.num-parcela
                            AND   tt-despesAdic-itens.num-di-ems             = decla-import-adic-itens.num-di-ems
                            AND   tt-despesAdic-itens.num-adic               = decla-import-adic-itens.num-adic ) THEN DO:
                CREATE tt-despesAdic-itens.
                ASSIGN tt-despesAdic-itens.cdn-despes             = i-cod-desp-ii
                       tt-despesAdic-itens.cdn-emit-despes        = i-cod-emitente-ii
                       tt-despesAdic-itens.cdn-cond-pag           = emitente.cod-cond-pag
                       tt-despesAdic-itens.cdn-moeda              = 0
                       tt-despesAdic-itens.cod-item               = decla-import-adic-itens.cod-item
                       tt-despesAdic-itens.log-forma-preco-compra = NO
                       tt-despesAdic-itens.num-ordem              = decla-import-adic-itens.num-ordem
                       tt-despesAdic-itens.num-parcela            = decla-import-adic-itens.num-parcela
                       tt-despesAdic-itens.val-despes             = decla-import-adic-itens.val-ii-db-cr
                       tt-despesAdic-itens.num-di-ems             = decla-import-adic-itens.num-di-ems
                       tt-despesAdic-itens.num-adic               = decla-import-adic-itens.num-adic.
                
                FIND LAST bf-tt-despesAdic-itens NO-ERROR.
                IF  AVAIL bf-tt-despesAdic-itens 
                THEN ASSIGN i-conta-seq = bf-tt-despesAdic-itens.num-seq + 1.
                ELSE ASSIGN i-conta-seq = 1.
    
                ASSIGN tt-despesAdic-itens.num-seq  = i-conta-seq.
            END.
        END. /* IF  param-imp.cod-desp-ii <> 0 THEN DO: */
    END. /* FOR FIRST decla-import-adic-itens NO-LOCK */

    FOR EACH tt-despesAdic-itens:

        IF  NOT CAN-FIND(FIRST tt-item-doc-est-cex
                         WHERE tt-item-doc-est-cex.serie-docto       = tt-itemDoc-est-aux.serie-docto     
                         and   tt-item-doc-est-cex.nro-docto         = tt-itemDoc-est-aux.nro-docto       
                         and   tt-item-doc-est-cex.cod-emitente      = tt-itemDoc-est-aux.cod-emitente    
                         and   tt-item-doc-est-cex.nat-operacao      = tt-itemDoc-est-aux.nat-operacao    
                         and   tt-item-doc-est-cex.sequencia         = tt-itemDoc-est-aux.sequencia       
                         and   tt-item-doc-est-cex.cod-emitente-desp = tt-despesAdic-itens.cdn-emit-despes
                         and   tt-item-doc-est-cex.cod-desp          = tt-despesAdic-itens.cdn-despes) THEN DO:
            CREATE tt-item-doc-est-cex.
            ASSIGN tt-item-doc-est-cex.serie-docto       = tt-itemDoc-est-aux.serie-docto     
                   tt-item-doc-est-cex.nro-docto         = tt-itemDoc-est-aux.nro-docto       
                   tt-item-doc-est-cex.cod-emitente      = tt-itemDoc-est-aux.cod-emitente    
                   tt-item-doc-est-cex.nat-operacao      = tt-itemDoc-est-aux.nat-operacao    
                   tt-item-doc-est-cex.sequencia         = tt-itemDoc-est-aux.sequencia       
                   tt-item-doc-est-cex.cod-emitente-desp = tt-despesAdic-itens.cdn-emit-despes
                   tt-item-doc-est-cex.cod-desp          = tt-despesAdic-itens.cdn-despes     
                   tt-item-doc-est-cex.embarque          = tt-documEst-aux.embarque
                   tt-item-doc-est-cex.cod-estabel       = decla-import.cod-estab
                   tt-item-doc-est-cex.num-seq-orig      = tt-itemDoc-est-aux.sequencia
                   tt-item-doc-est-cex.mo-codigo         = 0
                   tt-item-doc-est-cex.dat-cotac         = decla-import.dat-di.
            
            ASSIGN d-val-desp-convert = 0.

            IF tt-despesAdic-itens.cdn-moeda <> 0 THEN
                RUN converteValorMoeda (INPUT decla-import.num-di-ems,
                                        INPUT decla-import.cdd-siscomex-dts,
                                        INPUT tt-despesAdic-itens.cdn-moeda,
                                        INPUT 0,
                                        INPUT tt-despesAdic-itens.val-despes,
                                        INPUT decla-import.dat-di,
                                        OUTPUT d-val-desp-convert).  
            ELSE
                ASSIGN d-val-desp-convert = tt-despesAdic-itens.val-despes.

            ASSIGN tt-item-doc-est-cex.val-desp = ROUND(d-val-desp-convert,2).

            FIND CURRENT param-imp NO-LOCK NO-ERROR.
            {cdp/cd4300.i4 "yes" param-imp.char-1}
            {cxbo/bocx250.i51 "yes"}

            IF tt-item-doc-est-cex.cod-desp = i-desp-ii-i50 THEN DO:
                FIND FIRST desp-imp
                     WHERE desp-imp.cod-desp = i-desp-ii-i50 NO-LOCK NO-ERROR.
                IF  AVAIL desp-imp 
                AND (desp-imp.inc-val-frete OR desp-imp.inc-val-seguro OR 
                     desp-imp.inc-val-embal OR desp-imp.inc-val-outras-desp) THEN
                    ASSIGN de-desp-II = d-val-desp-convert.
            END.

            RUN pi-rateio-item-desp (input tt-despesAdic-itens.cdn-despes,
                                     input tt-item-doc-est-cex.val-desp,
                                     output de-val-desp-inc,
                                     output de-val-desp-fre).
           
                 
            IF tt-item-doc-est-cex.cod-desp <> i-desp-ii-i50 THEN
               ASSIGN de-tot-desp-adu =  de-tot-desp-adu + tt-item-doc-est-cex.val-desp.
            ELSE 
               ASSIGN de-tot-II-aux  = de-tot-II-aux + tt-item-doc-est-cex.val-desp WHEN de-val-desp-inc <> 0.
            
            assign de-tot-despesa-aux = de-tot-despesa-aux + de-val-desp-inc
                   de-tot-frete-aux   = de-tot-frete-aux + de-val-desp-fre.   
                   /* tt-item-doc-est-cex.cotacao  ????? */ 
        END. /* IF  NOT CAN-FIND(FIRST tt-item-doc-est-cex */
        IF  NOT CAN-FIND(FIRST tt-docum-est-cex
                         WHERE tt-docum-est-cex.serie-docto       = tt-item-doc-est-cex.serie-docto              
                         AND   tt-docum-est-cex.nro-docto         = tt-item-doc-est-cex.nro-docto                
                         AND   tt-docum-est-cex.cod-emitente      = tt-item-doc-est-cex.cod-emitente             
                         AND   tt-docum-est-cex.nat-operacao      = tt-item-doc-est-cex.nat-operacao
                         AND   tt-docum-est-cex.cod-emitente-desp = tt-item-doc-est-cex.cod-emitente-desp
                         AND   tt-docum-est-cex.cod-desp          = tt-item-doc-est-cex.cod-desp) THEN DO: 
            CREATE tt-docum-est-cex.
            ASSIGN tt-docum-est-cex.serie-docto       = tt-item-doc-est-cex.serie-docto 
                   tt-docum-est-cex.nro-docto         = tt-item-doc-est-cex.nro-docto   
                   tt-docum-est-cex.cod-emitente      = tt-item-doc-est-cex.cod-emitente
                   tt-docum-est-cex.nat-operacao      = tt-item-doc-est-cex.nat-operacao
                   tt-docum-est-cex.cod-emitente-desp = tt-item-doc-est-cex.cod-emitente-desp
                   tt-docum-est-cex.cod-desp          = tt-item-doc-est-cex.cod-desp
                   tt-docum-est-cex.cod-cond-pag      = tt-despesAdic-itens.cdn-cond-pag
                   tt-docum-est-cex.val-desp          = tt-item-doc-est-cex.val-desp
                   tt-docum-est-cex.mo-codigo         = tt-despesAdic-itens.cdn-moeda.

                   /* tt-docum-est-cex.cotacao  ?????? */

        END. /* IF  NOT CAN-FIND(FIRST tt-docum-est-cex */
        ELSE DO:
            FIND FIRST tt-docum-est-cex
                WHERE  tt-docum-est-cex.serie-docto       = tt-item-doc-est-cex.serie-docto              
                AND    tt-docum-est-cex.nro-docto         = tt-item-doc-est-cex.nro-docto                
                AND    tt-docum-est-cex.cod-emitente      = tt-item-doc-est-cex.cod-emitente             
                AND    tt-docum-est-cex.nat-operacao      = tt-item-doc-est-cex.nat-operacao 
                AND    tt-docum-est-cex.cod-emitente-desp = tt-item-doc-est-cex.cod-emitente-desp 
                AND    tt-docum-est-cex.cod-desp          = tt-item-doc-est-cex.cod-desp NO-ERROR.
            IF  AVAIL tt-docum-est-cex 
            THEN ASSIGN tt-docum-est-cex.val-desp = tt-docum-est-cex.val-desp + tt-item-doc-est-cex.val-desp.
        END. /* ELSE DO: */
    END. /* FOR EACH tt-despesAdic-itens: */
   
    /*Problema de arredondamento - Logica j† realizada na bocx383a.i2
    ASSIGN de-tot-resto       = de-tot-resto       + (de-tot-despesa-aux - tt-itemDoc-est-aux.despesas)
           de-tot-resto-frete = de-tot-resto-frete + (de-tot-frete-aux   - tt-itemDoc-est-aux.vl-frete-cons).*/
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-duplicata DBOProgram 
PROCEDURE pi-gera-duplicata :
if  l-acomp then do:
       {utp/ut-liter.i Gerando_duplicatas... * L}
       assign c-acomp = trim(return-value).
       run pi-acompanhar in h-acomp (input c-acomp).
    end. /* if  l-acomp then do: */

    for each tt-dupli:        delete tt-dupli.        end.
    for each tt-dupli-apagar: delete tt-dupli-apagar. end.

    FIND CURRENT param-imp NO-LOCK NO-ERROR.

        {cdp/cd4300.i4 "yes" param-imp.char-1}
        {cxbo/bocx250.i51 "yes"}
        
    find historico-embarque no-lock
        where historico-embarque.cod-estabel   = tt-documEst-aux.cod-estabel
        and   historico-embarque.embarque      = tt-documEst-aux.embarque
        and   historico-embarque.cod-itiner    = tt-nota.cod-itiner
        and   historico-embarque.cod-pto-contr = tt-nota.cod-pto-contr-base no-error.

    find first embarque-imp 
         where embarque-imp.cod-estabel = historico-embarque.cod-estabel
           and embarque-imp.embarque    = historico-embarque.embarque no-lock no-error. 
    &IF '{&bf_mat_versao_ems}' >= '2.09' &THEN 
        assign i-natureza-camb = embarque-imp.idi-natur-cambial.
    &ELSE 
        assign i-natureza-camb = embarque-imp.int-1.
    &ENDIF
   
    IF i-natureza-camb <> 2 THEN DO:
        for each  tt-itemDoc-est-aux
            where tt-itemDoc-est-aux.serie-docto  = tt-documEst-aux.serie-docto
            and   tt-itemDoc-est-aux.nro-docto    = tt-documEst-aux.nro-docto
            and   tt-itemDoc-est-aux.cod-emitente = tt-documEst-aux.cod-emitente
            and   tt-itemDoc-est-aux.nat-operacao = tt-documEst-aux.nat-operacao: 
            
            find tt-itens
                where tt-itens.numero-ordem = tt-itemDoc-est-aux.numero-ordem
                and   tt-itens.parcela      = tt-itemDoc-est-aux.parcela
                and   tt-itens.sequencia    = tt-itemDoc-est-aux.sequencia no-error.
                  
            assign de-vl-docto        = tt-itens.preco-total - tt-itemDoc-est-aux.desconto
                   de-tot-vl-docto    = de-tot-vl-docto + de-vl-docto
                   de-vl-docto-mo     = 0
                   de-tot-vl-docto-mo = de-tot-vl-docto-mo + tt-itens.preco-total-mo.
                         
            find cond-pagto no-lock
                where cond-pagto.cod-cond-pag = tt-nota.cod-cond-pag no-error.
            if  not avail cond-pagto then do:      
                find cond-especif no-lock
                    where cond-especif.num-pedido = tt-itens.num-pedido no-error.
                
                if not avail cond-especif then next.
                else do:
                    do  i-ind = 1 to 6:
                        if  cond-especif.data-pagto[i-ind] <> ? then do:                                            
                            create tt-dupli.
                            assign tt-dupli.dt-vencim    = cond-especif.data-pagto[i-ind]
                                   tt-dupli.tp-despesa   = tt-itens.tp-despesa
                                   tt-dupli.vl-apagar    = de-vl-docto * cond-especif.perc-pagto[i-ind] / 100
                                   tt-dupli.mo-codigo    = tt-nota.mo-codigo
                                   tt-dupli.vl-apagar-mo = tt-itens.preco-total-mo * cond-especif.perc-pagto[i-ind] / 100.
                        end. /* if  cond-especif.data-pagto[i-ind] <> ? then do: */
                    end. /* do  i-ind = 1 to 6: */
                end. /* else do: */
            end. /* if  not avail cond-pagto then do: */
            else do:
                assign da-data = today.
    
                if  not avail historico-embarque 
                then assign da-partida = tt-documEst-aux.dt-emissao.
                else assign da-partida = if   historico-embarque.dt-efetiva <> ? 
                                         then historico-embarque.dt-efetiva
                                         else tt-documEst-aux.dt-emissao.
                                         
                {cdp/cd9020.i7 tt-documEst-aux.cod-estabel a} /* calculo data de vencimento */
    
                do  i-ind = 1 to cond-pagto.num-parcelas:
                    if  da-data[i-ind] < today then assign da-data[i-ind] = tt-documEst-aux.dt-emissao.
                    create tt-dupli.
                    assign tt-dupli.dt-vencim    = da-data[i-ind]
                           tt-dupli.tp-despesa   = tt-itens.tp-despesa
                           tt-dupli.vl-apagar    = de-vl-docto * cond-pagto.per-pg-dup[i-ind] / 100               
                           tt-dupli.mo-codigo    = tt-nota.mo-codigo
                           tt-dupli.vl-apagar-mo = tt-itens.preco-total-mo * cond-pagto.per-pg-dup[i-ind] / 100.
                end. /* do  i-ind = 1 to cond-pagto.num-parcelas: */
            end. /* else do: */
        
        end. /* for each  tt-itemDoc-est-aux */
           
        assign i-parcela = 0.
    
        for each tt-dupli 
            break by tt-dupli.mo-codigo 
                  by tt-dupli.dt-vencim:
    
            if  first-of(tt-dupli.dt-vencim) then do:
                assign de-total-dup    = 0
                       de-total-dup-mo = 0
                       i-parcela       = i-parcela + 1.
            end. /* if  first-of(tt-dupli.dt-vencim) then do: */
    
            assign de-total-dup    = de-total-dup    + tt-dupli.vl-apagar
                   de-total-dup-mo = de-total-dup-mo + tt-dupli.vl-apagar-mo.
                   
            if  last-of(tt-dupli.mo-codigo) or 
                last-of(tt-dupli.dt-vencim) then do:
                create tt-dupli-apagar.
                assign tt-dupli-apagar.cod-emitente  = tt-documEst-aux.cod-emitente
                       tt-dupli-apagar.dt-vencim     = tt-dupli.dt-vencim
                       tt-dupli-apagar.nat-operacao  = tt-documEst-aux.nat-operacao
                       tt-dupli-apagar.nro-docto     = tt-documEst-aux.nro-docto
                       tt-dupli-apagar.parcela       = string(i-parcela)
                       tt-dupli-apagar.serie-docto   = tt-documEst-aux.serie-docto
                       tt-dupli-apagar.nr-duplic     = tt-documEst-aux.nro-docto
                       tt-dupli-apagar.tp-despesa    = tt-dupli.tp-despesa
                       tt-dupli-apagar.cod-esp       = param-imp.esp-tit-rec
                       tt-dupli-apagar.vl-a-pagar    = de-total-dup
                       tt-dupli-apagar.vl-a-pagar-mo = de-total-dup-mo
                       tt-dupli-apagar.mo-codigo     = tt-nota.mo-codigo.
    
                assign i-moeda-material = tt-dupli-apagar.mo-codigo.
            end. /* if  &if '{&bf_mat_versao_ems}' >= '2.04' &then */
        end. /* for each tt-dupli */
        
        /* Ajuste das diferenáas do total das duplicatas com o valor do material */
        assign de-dup-tot    = 0
               de-dup-tot-mo = 0.
        for each tt-dupli-apagar:
            assign de-dup-tot    = de-dup-tot    + tt-dupli-apagar.vl-a-pagar 
                   de-dup-tot-mo = de-dup-tot-mo + tt-dupli-apagar.vl-a-pagar-mo.
            
        end. /* for each tt-dupli-apagar: */
        
        if  de-tot-vl-docto <> de-dup-tot then do:
            find last tt-dupli-apagar no-error.
            if  avail tt-dupli-apagar 
            then assign tt-dupli-apagar.vl-a-pagar = tt-dupli-apagar.vl-a-pagar + (de-tot-vl-docto - de-dup-tot).
        end. /* if  de-tot-vl-docto <> de-dup-tot then do: */
        
        if  de-tot-vl-docto-mo <> de-dup-tot-mo then do:
            find last tt-dupli-apagar no-error.
            if  avail tt-dupli-apagar 
            then assign tt-dupli-apagar.vl-a-pagar-mo = tt-dupli-apagar.vl-a-pagar-mo + ( de-tot-vl-docto-mo - de-dup-tot-mo ).
            
        end. /* if  de-tot-vl-docto-mo <> de-dup-tot-mo then do: */
    END. /* if i-natureza-camb <> 2 */

    {cxbo/bocx383a.i3 "tt-itemDoc-est-aux" "dupli-apagar-cex"} /* Duplicatas das despesas */
    
    for each tt-desp-totais:
        delete tt-desp-totais.
    end.    

    assign i-cont = 0.
    for last tt-dupli-apagar
        break by tt-dupli-apagar.parcela:
        
        assign i-cont = integer(tt-dupli-apagar.parcela).
    end. /* for each tt-dupli-apagar no-lock */    

    for each tt-dupli-apagar:
        assign i-cont = i-cont + 1
               tt-dupli-apagar.parcela = string(i-cont).
    end. /* for each tt-dupli-apagar no-lock */

    assign i-cont = 0.
    for each tt-dupli-apagar
        break by tt-dupli-apagar.dt-vencim:
        
        assign i-cont = i-cont + 1
               tt-dupli-apagar.parcela = string(i-cont).
    end. /* for each tt-dupli-apagar no-lock */
    
END PROCEDURE. /* fim pi-gera-duplicata*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-erro DBOProgram 
PROCEDURE pi-gera-erro :
assign i-seq-erro = i-seq-erro + 1.
    run utp/ut-msgs.p (input "msg":U, input i-msg, input c-msg).
    do  transaction:
        create tt-erro.
        assign tt-erro.i-sequen = i-seq-erro
               tt-erro.cd-erro  = i-msg
               tt-erro.mensagem = return-value + c-char.
    end. /* do  transaction: */
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-unid-negocio DBOProgram 
PROCEDURE pi-gera-unid-negocio : /* Gera Unidade de Neg¢cio */
    
    FIND FIRST param-mat NO-LOCK NO-ERROR.

    IF NOT AVAIL param-mat THEN 
        LEAVE.
    ELSE 
        IF NOT param-mat.ind-unid-neg THEN
            LEAVE.  

    ASSIGN tt-versao-integr.cod-versao-integracao = 004.
    
    IF AVAIL param-mat THEN 
        IF param-mat.ind-unid-neg THEN 
            ASSIGN tt-documEst-aux.gera-unid-neg = 1.
        ELSE 
            ASSIGN tt-documEst-aux.gera-unid-neg = 0.
            
    FOR EACH tt-itemDoc-est-aux:

        FOR EACH unid-neg-ordem NO-LOCK
           WHERE unid-neg-ordem.numero-ordem = tt-itemDoc-est-aux.numero-ordem:

            CREATE tt-unid-neg-nota.
            ASSIGN tt-unid-neg-nota.registro       = 5
                   tt-unid-neg-nota.cod-emitente   = tt-itemDoc-est-aux.cod-emitente
                   tt-unid-neg-nota.serie-docto    = tt-itemDoc-est-aux.serie-docto
                   tt-unid-neg-nota.nro-docto      = tt-itemDoc-est-aux.nro-docto
                   tt-unid-neg-nota.nat-operacao   = tt-itemDoc-est-aux.nat-operacao
                   tt-unid-neg-nota.sequencia      = tt-itemDoc-est-aux.sequencia
                   tt-unid-neg-nota.cod_unid_negoc = unid-neg-ordem.cod_unid_negoc
                   tt-unid-neg-nota.perc-unid-neg  = unid-neg-ordem.perc-unid-neg.
        END. 
    END. 
      
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-geraDocto DBOProgram 
PROCEDURE pi-geraDocto :

    {cxbo/bocx383a.i2}

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-limpa-tt DBOProgram 
PROCEDURE pi-limpa-tt :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    EMPTY TEMP-TABLE tt-ordens-totais.
    EMPTY TEMP-TABLE tt-adic-totais.
    EMPTY TEMP-TABLE tt-di-totais.
    EMPTY TEMP-TABLE tt-ordens-totais-incoterm.
    EMPTY TEMP-TABLE tt-desp-totais-incoterm.
    EMPTY TEMP-TABLE tt-ordens-desp.
    EMPTY TEMP-TABLE tt-adic-desp.
    EMPTY TEMP-TABLE tt-desp-totais-di.
    EMPTY TEMP-TABLE tt-desp-totais-adic.
    EMPTY TEMP-TABLE tt-desp-rateio.
    EMPTY TEMP-TABLE tt-desp-rateio-item.
    EMPTY TEMP-TABLE tt-taxa-rateio.
    EMPTY TEMP-TABLE tt-despesas.
    EMPTY TEMP-TABLE tt-despes-adic-itens-aux.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-log-alteracoes-manuais DBOProgram 
PROCEDURE pi-log-alteracoes-manuais :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Esta procedure verifica quais campos dos impostos foram alterados manualmente      
------------------------------------------------------------------------------*/
    
    &IF '{&BF_MAT_VERSAO_EMS}' < '2.09' &THEN
        /* base ii */
        IF SUBSTRING(decla-import-adic.cod-livre-1,4,1) = "" OR SUBSTRING(decla-import-adic.cod-livre-1,4,1) = "N" THEN
            ASSIGN l-base-ii-manual = NO.
        ELSE 
            ASSIGN l-base-ii-manual = YES.

        /* base ipi */
        IF SUBSTRING(decla-import-adic.cod-livre-1,5,1) = "" OR SUBSTRING(decla-import-adic.cod-livre-1,5,1) = "N" THEN
            ASSIGN l-base-ipi-manual = NO.
        ELSE 
            ASSIGN l-base-ipi-manual = YES.

        /* base pis */
        IF SUBSTRING(decla-import-adic.cod-livre-1,6,1) = "" OR SUBSTRING(decla-import-adic.cod-livre-1,6,1) = "N" THEN
            ASSIGN l-base-pis-manual = NO.
        ELSE 
            ASSIGN l-base-pis-manual = YES.

        /* base cofins */
        IF SUBSTRING(decla-import-adic.cod-livre-1,7,1) = "" OR SUBSTRING(decla-import-adic.cod-livre-1,7,1) = "N" THEN
            ASSIGN l-base-cofins-manual = NO.
        ELSE 
            ASSIGN l-base-cofins-manual = YES.

        /* base icms */
        IF SUBSTRING(decla-import-adic.cod-livre-1,8,1) = "" OR SUBSTRING(decla-import-adic.cod-livre-1,8,1) = "N" THEN
            ASSIGN l-base-icms-manual = NO.
        ELSE 
            ASSIGN l-base-icms-manual = YES.

        /* valor ii */
        IF SUBSTRING(decla-import-adic.cod-livre-1,9,1) = "" OR SUBSTRING(decla-import-adic.cod-livre-1,9,1) = "N" THEN
            ASSIGN l-valor-ii-manual = NO.
        ELSE 
            ASSIGN l-valor-ii-manual = YES.

       /* valor ipi */
        IF SUBSTRING(decla-import-adic.cod-livre-1,10,1) = "" OR SUBSTRING(decla-import-adic.cod-livre-1,10,1) = "N" THEN
            ASSIGN l-valor-ipi-manual = NO.
        ELSE 
            ASSIGN l-valor-ipi-manual = YES.

       /* valor pis */
        IF SUBSTRING(decla-import-adic.cod-livre-1,11,1) = "" OR SUBSTRING(decla-import-adic.cod-livre-1,11,1) = "N" THEN
            ASSIGN l-valor-pis-manual = NO.
        ELSE 
            ASSIGN l-valor-pis-manual = YES.

       /* valor cofins */
        IF SUBSTRING(decla-import-adic.cod-livre-1,12,1) = "" OR SUBSTRING(decla-import-adic.cod-livre-1,12,1) = "N" THEN
            ASSIGN l-valor-cofins-manual = NO.
        ELSE 
            ASSIGN l-valor-cofins-manual = YES.

       /* valor icms */
        IF SUBSTRING(decla-import-adic.cod-livre-1,13,1) = "" OR SUBSTRING(decla-import-adic.cod-livre-1,13,1) = "N" THEN
            ASSIGN l-valor-icms-manual = NO.
        ELSE 
            ASSIGN l-valor-icms-manual = YES.


    &ELSE
        /* base ii */
        IF NOT decla-import-adic.log-ava-base-ii THEN
            ASSIGN l-base-ii-manual = NO.
        ELSE 
            ASSIGN l-base-ii-manual = YES.

        /* base ipi */
        IF NOT decla-import-adic.log-ava-base-ipi THEN
            ASSIGN l-base-ipi-manual = NO.
        ELSE 
            ASSIGN l-base-ipi-manual = YES.

        /* base pis */
        IF NOT decla-import-adic.log-ava-base-pis THEN
            ASSIGN l-base-pis-manual = NO.
        ELSE 
            ASSIGN l-base-pis-manual = YES.

        /* base cofins */
        IF NOT decla-import-adic.log-ava-base-cofins THEN
            ASSIGN l-base-cofins-manual = NO.
        ELSE 
            ASSIGN l-base-cofins-manual = YES.

        /* base icms */
        IF NOT decla-import-adic.log-ava-base-icms THEN
            ASSIGN l-base-icms-manual = NO.
        ELSE 
            ASSIGN l-base-icms-manual = YES.

        /* valor ii */
        IF NOT decla-import-adic.log-ava-valor-ii THEN
            ASSIGN l-valor-ii-manual = NO.
        ELSE 
            ASSIGN l-valor-ii-manual = YES.

        /* valor ipi */
        IF NOT decla-import-adic.log-ava-valor-ipi THEN
            ASSIGN l-valor-ipi-manual = NO.
        ELSE                
            ASSIGN l-valor-ipi-manual = YES.

        /* valor pis */
        IF NOT decla-import-adic.log-ava-valor-pis THEN
            ASSIGN l-valor-pis-manual = NO.
        ELSE 
            ASSIGN l-valor-pis-manual = YES.

        /* valor cofins */
        IF NOT decla-import-adic.log-ava-valor-cofins THEN
            ASSIGN l-valor-cofins-manual = NO.
        ELSE 
            ASSIGN l-valor-cofins-manual = YES.

        /* valor icms */
        IF NOT decla-import-adic.log-ava-valor-icms THEN
            ASSIGN l-valor-icms-manual = NO.
        ELSE 
            ASSIGN l-valor-icms-manual = YES.

    &ENDIF
    
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-rateio-adicao DBOProgram 
PROCEDURE pi-rateio-adicao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM p-num-di-ems    LIKE decla-import-ord.num-di-ems    NO-UNDO.
    DEF INPUT  PARAM p-cdd-siscomex-dts LIKE decla-import-ord.cdd-siscomex-dts NO-UNDO.

    EMPTY TEMP-TABLE tt-desp-totais-incoterm-adic.

    /*Gera as TTÔs de relacionamento entre as ordens/adiá∆o x despesas*/
    RUN relacionaOrdensAdicDespesas (INPUT p-num-di-ems,
                                     INPUT p-cdd-siscomex-dts).
    
    /*Efetua o sequenciamento do rateio das despesas*/
    RUN ordenaTtAdicDesp (INPUT p-num-di-ems,
                          INPUT p-cdd-siscomex-dts).
    
    /*Efetua rateio das despesas pelo tipo*/
    RUN geraRateioDespesasAdicao (INPUT p-num-di-ems,
                                  INPUT p-cdd-siscomex-dts,
                                  INPUT 1). /*PRIMEIRO RATEIO*/
    
    
    /*Atualizando valores mercadoria nas temp-tables para os calculos*/
    RUN atualizaValoresMercAdicDI (INPUT p-num-di-ems,
                                   INPUT p-cdd-siscomex-dts).

    /*AtualizaDI*/
    RUN atualizaValores (INPUT p-num-di-ems,
                         INPUT p-cdd-siscomex-dts).

    /*Rateio da despesa de Frete para as adiá‰es*/
    RUN geraRateioFrete (INPUT p-num-di-ems,
                         INPUT p-cdd-siscomex-dts).

    /*Efetua rateio das despesas pelo tipo*/
    RUN geraRateioDespesasAdicao (INPUT p-num-di-ems,
                                  INPUT p-cdd-siscomex-dts,
                                  INPUT 2). /*SEGUNDO RATEIO UTILIZANDO OS VALORES VMCV Jµ ATUALIZADOS NA DI E NAS ADIÄÂES*/

    /*Atualizando valores mercadoria nas temp-tables para os calculos*/
    RUN atualizaValoresMercAdicDI (INPUT p-num-di-ems,
                                   INPUT p-cdd-siscomex-dts).

    /*Calculo do Rateio do Seguro e atualizaá‰es*/
    RUN rateiaSeguroAdicao(INPUT p-num-di-ems,
                           INPUT p-cdd-siscomex-dts).
    
    /*Gera as despesas rateadas para a adiá∆o*/
    RUN geraDespesasRateadasAdicao(INPUT p-num-di-ems,
                                   INPUT p-cdd-siscomex-dts).

    /*Atualiza valores de acrescimos na DI e Adiá∆o*/
    RUN atualizaValorAcresc(INPUT p-num-di-ems,
                            INPUT p-cdd-siscomex-dts).

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-rateio-di DBOProgram 
PROCEDURE pi-rateio-di :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM p-num-di-ems LIKE {&TABLENAME}.num-di-ems NO-UNDO.
DEF INPUT PARAM p-cdd-siscomex-dts LIKE {&TABLENAME}.cdd-siscomex-dts NO-UNDO.
DEF INPUT PARAM pi-tipo-rateio AS INTEGER NO-UNDO.

DEFINE VARIABLE c-liter-inf-dt AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-liter-inf-dt2 AS CHARACTER NO-UNDO.

ASSIGN i-tipo-rateio = pi-tipo-rateio. /* 1-Despesas Nacionalizaá∆o, 2-Despesas Complementares*/
EMPTY TEMP-TABLE RowErrors.

IF NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

RUN pi-inicializar IN h-acomp ("Iniciando Rateio" + STRING(p-num-di-ems)).
RUN pi-desabilita-cancela IN h-acomp.

IF CAN-FIND(FIRST decla-import
            WHERE decla-import.num-di-ems = p-num-di-ems
            AND   decla-import.cdd-siscomex-dts = p-cdd-siscomex-dts
            AND   decla-import.dat-di = ?) THEN DO:
    
    {utp/ut-liter.i "Data_da_Declaraá∆o_deve_ser_informada" *}
    ASSIGN c-liter-inf-dt = TRIM(RETURN-VALUE).
    {utp/ut-liter.i "Data_da_Declaraá∆o_Importaá∆o_deve_ser_informada_para_que_as_convers‰es_das_moedas_sejam_feitas" *}
    ASSIGN c-liter-inf-dt2 = TRIM(RETURN-VALUE).
    
    {method/svc/errors/inserr.i
          &ErrorNumber="17006"
          &ErrorType="EMS"
          &ErrorParameters="c-liter-inf-dt + '!' + '~~~~' + c-liter-inf-dt2 + '!'"}
          
    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.

    RETURN "NOK":U.
END.


/*LIMPANDO VALORES QUE SERµO CALCULADOS*/
FOR FIRST decla-import EXCLUSIVE-LOCK
    WHERE decla-import.num-di-ems = p-num-di-ems
      AND decla-import.cdd-siscomex-dts = p-cdd-siscomex-dts:

    ASSIGN decla-import.val-vmcv   = 0
           decla-import.val-vmle   = 0
           decla-import.val-vmld   = 0
           decla-import.val-acresc = 0
           decla-import.val-frete  = 0
           decla-import.val-seguro = 0
           decla-import.val-acresc-me[1] = 0
           decla-import.val-acresc-me[2] = 0
           decla-import.val-frete-me[1]  = 0 
           decla-import.val-frete-me[2]  = 0 
           decla-import.val-seguro-me[1] = 0
           decla-import.val-seguro-me[2] = 0.

    FOR EACH decla-import-adic EXCLUSIVE-LOCK
        WHERE decla-import-adic.num-di-ems = decla-import.num-di-ems 
          AND decla-import-adic.cdd-siscomex-dts = decla-import.cdd-siscomex-dts:

        ASSIGN decla-import-adic.val-vmcv   = 0
               decla-import-adic.val-vmle   = 0
               decla-import-adic.val-vmld   = 0
               decla-import-adic.val-acresc = 0
               decla-import-adic.val-acresc-me[1] = 0
               decla-import-adic.val-acresc-me[2] = 0.

        FOR EACH decla-import-adic-itens EXCLUSIVE-LOCK
            WHERE decla-import-adic-itens.num-di-ems = decla-import-adic.num-di-ems
            AND   decla-import-adic-itens.num-adic   = decla-import-adic.num-adic
            AND   decla-import-adic-itens.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts:

            ASSIGN decla-import-adic-itens.val-vmcv   = 0
                   decla-import-adic-itens.val-vmle   = 0
                   decla-import-adic-itens.val-vmld   = 0
                   decla-import-adic-itens.val-vucv   = 0
                   decla-import-adic-itens.val-acresc = 0
                   decla-import-adic-itens.val-acresc-me[1] = 0
                   decla-import-adic-itens.val-acresc-me[2] = 0.

        END.                                             
    END.    
END.
/**/

RUN pi-limpa-tt.

/* Elimina despesas dos itens que n∆o constam na adiá∆o */
RUN pi-corrige-desp-itens-adic (INPUT p-num-di-ems,
                                INPUT p-cdd-siscomex-dts).

{cxbo/bocx250.i50} /* include tratamento atributo livre */

FOR FIRST decla-import NO-LOCK
    WHERE decla-import.num-di-ems = p-num-di-ems 
    AND   decla-import.cdd-siscomex-dts = p-cdd-siscomex-dts
    AND   decla-import.log-ativo: END.

FOR FIRST param-imp NO-LOCK
    WHERE param-imp.cod-estabel = decla-import.cod-estab : END.

{cdp/cd4300.i4 "yes" param-imp.char-1}
{cxbo/bocx250.i51 "yes"}

assign i-cod-desp-ii     = i-desp-ii-i50
       i-cod-emitente-ii = i-emitente-ii-i50.
       
IF i-cod-desp-ii <> 0 THEN DO:
    IF NOT CAN-FIND(desp-imp 
                    WHERE desp-imp.cod-desp = i-cod-desp-ii) THEN DO:
        /*INSERIR ERRO PARA DESPESA N«O ENCONTRADA*/
    END.

    IF CAN-FIND(FIRST despes-decla-import
                WHERE despes-decla-import.num-di-ems = p-num-di-ems
                AND   despes-decla-import.cdn-despes = i-cod-desp-ii
                AND   despes-decla-import.cdd-siscomex-dts = p-cdd-siscomex-dts) THEN
        ASSIGN l-cod-desp-ii = YES.
    ELSE 
        ASSIGN l-cod-desp-ii = NO.
END.

/*GERANDO TOTAIS DE TODAS AS ORDENS DA DI (tt-ordens-totais)*/
FOR EACH decla-import-ord NO-LOCK
    WHERE decla-import-ord.num-di-ems = p-num-di-ems
      AND decla-import-ord.cdd-siscomex-dts = p-cdd-siscomex-dts,
    FIRST cotacao-item
    WHERE cotacao-item.numero-ordem = decla-import-ord.num-ordem
      AND cotacao-item.it-codigo    = decla-import-ord.cod-item
      AND cotacao-item.cod-emitente = decla-import-ord.cdn-fornec
      AND cotacao-item.cot-aprovada NO-LOCK:

    RUN geraOrdenstotais (INPUT decla-import-ord.num-di-ems,
                          INPUT decla-import-ord.num-adic,
                          INPUT decla-import-ord.num-ordem,
                          INPUT decla-import-ord.num-parcela,
                          INPUT decla-import-ord.cdd-siscomex-dts,
                          INPUT cotacao-item.cod-emitente,
                          INPUT cotacao-item.data-cotacao,
                          INPUT cotacao-item.seq-cotac,
                          INPUT decla-import-ord.qtd-item,
                          INPUT decla-import-ord.qtd-fornec).
END.



/*GERANDO OS TOTAIS POR ADIÄ«O*/
RUN geraAdicTotais (INPUT p-num-di-ems,
                    INPUT p-cdd-siscomex-dts).

/* Inicio -- Projeto Internacional */
{utp/ut-liter.i "Rateando_Valores" *}
RUN pi-acompanhar in h-acomp (RETURN-VALUE).

/*Busca as incoterms de rateio*/
IF CAN-FIND(FIRST despes-decla-import
            WHERE despes-decla-import.num-di-ems        = p-num-di-ems 
            AND   despes-decla-import.cdd-siscomex-dts  = p-cdd-siscomex-dts
            AND   despes-decla-import.cod-incoterm-rat <> "") THEN DO:
    ASSIGN l-existe-incoterm = YES.
    RUN geraTtByIncoterm (INPUT p-num-di-ems,
                          INPUT p-cdd-siscomex-dts).
END.
ELSE DO:
    ASSIGN l-existe-incoterm = NO.

    FOR EACH tt-desp-totais-incoterm:
        DELETE tt-desp-totais-incoterm.
    END.

    FOR EACH tt-ordens-totais-incoterm:
        DELETE tt-ordens-totais-incoterm.
    END.
END.
    
/*cria tt-despesas (essa tt foi criada para facilitar no calculo do rateio das despesas*/
RUN criaTtDespesas (INPUT p-num-di-ems,
                    INPUT p-cdd-siscomex-dts).

/*Rateio DI X ADIÄ«O*/
RUN pi-rateio-adicao (INPUT p-num-di-ems,
                      INPUT p-cdd-siscomex-dts).

/*cria tt-despesas (essa tt foi criada para facilitar no calculo do rateio das despesas*/
RUN criaTtDespesasAdic (INPUT p-num-di-ems,
                        INPUT p-cdd-siscomex-dts).

/*Rateio ADIÄ«O X ITENS*/
RUN pi-rateio-itens(INPUT p-num-di-ems,
                    INPUT p-cdd-siscomex-dts).

/*convers∆o dos valores da DI, ADIC e ITENS ADIC para as moedas da DI (moeda d¢lar do parametro de importaá∆o, moeda da negociaá∆o e real)*/
RUN pi-converte-valores-moeda(INPUT p-num-di-ems,
                              INPUT p-cdd-siscomex-dts).

IF NOT CAN-FIND(FIRST RowErrors 
                WHERE RowErrors.ErrorType     <> "INTERNAL":U
                AND   RowErrors.ErrorSubType  = "ERROR":U) THEN DO:
    RUN pi-atual-val-rat-embarque(INPUT p-num-di-ems,
                                  INPUT p-cdd-siscomex-dts).
    FOR FIRST decla-import EXCLUSIVE-LOCK
        WHERE decla-import.num-di-ems = p-num-di-ems 
        AND   decla-import.cdd-siscomex-dts = p-cdd-siscomex-dts
        AND   decla-import.log-ativo: 
        ASSIGN decla-import.log-pend-rat = YES
               OVERLAY(decla-import.cod-livre-1,2,1) = 'S'. /*variavel que mostra se foi rateado pelo menos 1 vez*/
    END.
END.
    

RELEASE decla-import.
RELEASE decla-import-adic.
RELEASE decla-import-ord.
RELEASE decla-import-adic-itens.
RELEASE despes-decla-import.
RELEASE despes-adic.
RELEASE decla-import-cotac.

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-finalizar IN h-acomp.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-rateio-item-desp DBOProgram 
PROCEDURE pi-rateio-item-desp :
/*
    ** Rateia o valor da despesa para o item do documento
    */
    def input  parameter p-cod-desp     like desp-imp.cod-desp      no-undo.
    def input  parameter p-val-desp     like desp-embarque.val-desp no-undo.
    def output parameter p-val-desp-inc like desp-embarque.val-desp no-undo.
    def output parameter p-val-desp-fre like desp-embarque.val-desp no-undo.
    
    find first desp-imp
         where desp-imp.cod-desp = p-cod-desp no-lock no-error.
    if avail desp-imp then do:

        if desp-imp.inc-val-frete  
        or desp-imp.inc-val-seguro 
        or desp-imp.inc-val-embal 
        or desp-imp.inc-val-outras-desp then do:

            assign tt-itemDoc-est-aux.despesas = tt-itemDoc-est-aux.despesas + p-val-desp
                   p-val-desp-inc              = p-val-desp.
                   
            if desp-imp.inc-val-frete and desp-imp.cod-desp <> i-desp-ii-i50 then
                assign tt-itemDoc-est-aux.vl-frete-cons = tt-itemDoc-est-aux.vl-frete-cons + p-val-desp
                       de-frete                         = de-frete                         + p-val-desp
                       p-val-desp-fre                   = p-val-desp.
                       
            if desp-imp.inc-val-seguro and desp-imp.cod-desp <> i-desp-ii-i50 then
                assign de-seguro         = de-seguro         + p-val-desp
                       de-tot-seguro-aux = de-tot-seguro-aux + p-val-desp.
            if desp-imp.inc-val-embal and desp-imp.cod-desp <> i-desp-ii-i50 then
                assign de-embal          = de-embal         + p-val-desp
                       de-tot-embal-aux  = de-tot-embal-aux + p-val-desp.
            if desp-imp.inc-val-outras-desp and desp-imp.cod-desp <> i-desp-ii-i50 then
                assign de-outras         = de-outras         + p-val-desp
                       de-tot-outras-aux = de-tot-outras-aux + p-val-desp.
        end.
     end.
     
END PROCEDURE. /* fim pi-rateio-item-desp*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-rateio-itens DBOProgram 
PROCEDURE pi-rateio-itens :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM p-num-di-ems    LIKE decla-import-ord.num-di-ems    NO-UNDO.
    DEF INPUT  PARAM p-cdd-siscomex-dts LIKE decla-import-ord.cdd-siscomex-dts NO-UNDO.

    /*GERANDO OS TOTAIS POR ADIÄ«O*/
    RUN geraAdicDespTotais (INPUT p-num-di-ems,
                            INPUT p-cdd-siscomex-dts).

    /*Efetua o sequenciamento do rateio das despesas*/
    RUN ordenaTtOrdensDesp (INPUT p-num-di-ems).

    /*Atualiza valor l°quido da mercadoria das ordens retirando as despesas que formam preáo compra da adiá∆o relacionada.*/
    RUN pi-atualiza-valor-mercadoria-ordens(INPUT p-num-di-ems,
                                            INPUT p-cdd-siscomex-dts).

    /*Busca as incoterms de rateio*/
    IF CAN-FIND(FIRST despes-adic
                WHERE despes-adic.num-di-ems       = p-num-di-ems 
                AND   despes-adic.cdd-siscomex-dts = p-cdd-siscomex-dts
                AND   despes-adic.cod-incoterm-rat <> "") THEN DO:
        ASSIGN l-existe-incoterm-item = YES.
        RUN geraTtByIncoterm (INPUT p-num-di-ems,
                              INPUT p-cdd-siscomex-dts).
    END.
    ELSE DO:
        ASSIGN l-existe-incoterm-item = NO.

        EMPTY TEMP-TABLE tt-desp-totais-incoterm.
        EMPTY TEMP-TABLE tt-ordens-totais-incoterm.
    END.

    /*Efetua rateio das despesas pelo tipo*/
    RUN geraRateioDespesasItem (INPUT p-num-di-ems,
                                INPUT p-cdd-siscomex-dts,
                                INPUT 1). /*PRIMEIRO RATEIO*/

    
    /*Atualizando valores mercadoria nas temp-tables para os calculos*/
    RUN atualizaValoresMercOrdemAdic(INPUT p-num-di-ems,
                                     INPUT p-cdd-siscomex-dts).

    /*Calcular o VUCV (Valor Unit†rio na Condiá∆o de Venda) de cada item da adiá∆o buscando o preáo
      unit†rio do pedido de compra que dever† estar com o preáo unit†rio conforme incoterm informado*/
    RUN pi-atualiza-vucv-itens-adicao(INPUT p-num-di-ems,
                                      INPUT p-cdd-siscomex-dts).    
    
    /*Rateio da despesa de Frete para as adiá‰es*/
    RUN geraRateioFreteItem (INPUT p-num-di-ems,
                             INPUT p-cdd-siscomex-dts).

    /*Efetua rateio das despesas pelo tipo*/
    RUN geraRateioDespesasItem (INPUT p-num-di-ems,
                                INPUT p-cdd-siscomex-dts,
                                INPUT 2). /*SEGUNDO RATEIO UTILIZANDO OS VALORES VMCV Jµ ATUALIZADOS NAS ADIÄÂES E NOS ITENS*/

    /*Atualizando valores mercadoria nas temp-tables para os calculos*/
    RUN atualizaValoresMercOrdemAdic(INPUT p-num-di-ems,
                                     INPUT p-cdd-siscomex-dts).

    /*Calculo do Rateio do Seguro e atualizaá‰es*/
    RUN rateiaSeguroAdicaoItem(INPUT p-num-di-ems,
                               INPUT p-cdd-siscomex-dts).

    /*Gera as despesas rateadas para os itens da adiá∆o*/
    RUN geraDespesasRateadasItem(INPUT p-num-di-ems,
                                 INPUT p-cdd-siscomex-dts).
    
    /*Calcular o VUCV (Valor Unit†rio na Condiá∆o de Venda) novamente ap¢s todos os rateios j† feitos*/
    RUN pi-atualiza-vucv-itens-adicao(INPUT p-num-di-ems,
                                      INPUT p-cdd-siscomex-dts).
    
    /*Atualiza valores de acrescimos na DI e Adiá∆o*/
    RUN atualizaValorAcrescItem (INPUT p-num-di-ems,
                                 INPUT p-cdd-siscomex-dts).

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recarrega-impostos DBOProgram 
PROCEDURE pi-recarrega-impostos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-num-di-ems LIKE decla-import.num-di-ems NO-UNDO.
    DEF INPUT PARAM p-cod-natur-oper LIKE decla-import.cod-natur-oper NO-UNDO.
    DEF INPUT PARAM p-cdd-siscomex-dts LIKE decla-import.cdd-siscomex-dts NO-UNDO.

    IF NOT VALID-HANDLE (h-bocx225) THEN 
        RUN cxbo/bocx225.p   PERSISTENT SET h-bocx225.   /* ordens-embarque */
    IF NOT VALID-HANDLE (h-bocx225e) THEN
         RUN cxbo/bocx225e.p  PERSISTENT SET h-bocx225e.  /* ordens-embarque */

    /* atualiza as variaveis de controle de alteracao manual dos impostos para NO */
    FOR EACH decla-import-adic EXCLUSIVE-LOCK
        WHERE decla-import-adic.num-di-ems = p-num-di-ems
          AND decla-import-adic.cdd-siscomex-dts = p-cdd-siscomex-dts:
        &IF '{&BF_MAT_VERSAO_EMS}' < '2.09' &THEN
            ASSIGN overlay(decla-import-adic.cod-livre-1,4,1) = "N"
                   overlay(decla-import-adic.cod-livre-1,5,1) = "N"
                   overlay(decla-import-adic.cod-livre-1,6,1) = "N"
                   overlay(decla-import-adic.cod-livre-1,7,1) = "N"
                   overlay(decla-import-adic.cod-livre-1,8,1) = "N".
        &ELSE
            ASSIGN decla-import-adic.log-ava-base-ii     = NO
                   decla-import-adic.log-ava-base-ipi    = NO
                   decla-import-adic.log-ava-base-pis    = NO
                   decla-import-adic.log-ava-base-cofins = NO
                   decla-import-adic.log-ava-base-icms   = NO.
        &ENDIF
    END.
    /* fim - atualiza as variaveis de controle de alteracao manual dos impostos para NO */

    FOR EACH decla-import-embarq NO-LOCK
        WHERE decla-import-embarq.num-di-ems = p-num-di-ems
          AND decla-import-embarq.cdd-siscomex-dts = p-cdd-siscomex-dts,
        FIRST decla-import-ord EXCLUSIVE-LOCK
            WHERE decla-import-ord.num-di-ems = decla-import-embarq.num-di-ems
            AND   decla-import-ord.cod-embarq = decla-import-embarq.cod-embarq
            AND   decla-import-ord.cod-estab  = decla-import-embarq.cod-estab
            AND   decla-import-ord.cdd-siscomex-dts = decla-import-embarq.cdd-siscomex-dts:

        

            EMPTY TEMP-TABLE tt-ordens-embarque.
            run setConstraint4 in h-bocx225 (input decla-import-embarq.cod-embarq, 
                                             input decla-import-embarq.cod-estab).
            run OpenQuery in h-bocx225 (input 4).
            run findFirst in h-bocx225.
            run serverSendRows in h-bocx225 (input ?, 
                                             input ?, 
                                             input no, 
                                             input ?, 
                                             output iRowsReturned, 
                                             output table tt-ordens-embarque).
            
            IF CAN-FIND(FIRST tt-ordens-embarque) THEN
                RUN loadOrdensDesemb IN h-bocx225e (INPUT TABLE tt-ordens-embarque,                              /* tt-ordens-embarque */
                                                    INPUT decla-import-ord.cod-natur-operac,                     /* nat-operacao       */
                                                    INPUT c-seg-usuario,                                         /* usuario            */ 
                                                    INPUT yes,                                                   /* recarrega          */
                                                    INPUT NO,                                                    /* icms-diferido      */                                       
                                                    INPUT NO,                                                    /* total              */
                                                    INPUT yes,                                                   /* recarrega-II       */
                                                    INPUT yes,                                                   /* recarrega-ipi      */
                                                    INPUT yes,                                                   /* recarrega-icms     */
                                                    INPUT yes,                                                   /* recarrega-pis      */
                                                    INPUT yes,                                                   /* recarrega-cof      */
                                                    INPUT YES,                                                   /* recarrega IBS UF   */
                                                    INPUT YES,                                                   /* recarrega IBS Mun  */
                                                    INPUT YES,                                                   /* recarrega CBS      */
                                                    INPUT YES,                                                   /* recarrega IS       */
                                                    INPUT yes,   /* peso-bruto   */                              /* recarrega-p-bruto  */
                                                    INPUT yes,   /* peso-liquido */                              /* recarrega-p-liqui  */
                                                    INPUT yes,   /* cubagem      */                              /* recarrega-cubagem  */                                                                                                           
                                                    OUTPUT TABLE tt-ordens-desemb,                               /* tt-ordens-desemb   */
                                                    OUTPUT TABLE tt-bo-erro).                                    /* tt-bo-erro         */                                   /* tt-bo-erro         */
        
            FOR FIRST tt-ordens-desemb 
                WHERE tt-ordens-desemb.cod-estabel  = decla-import-ord.cod-estab
                AND   tt-ordens-desemb.embarque     = decla-import-ord.cod-embarq
                AND   tt-ordens-desemb.numero-ordem = decla-import-ord.num-ordem
                AND   tt-ordens-desemb.parcela      = decla-import-ord.num-parcela:
        
                assign decla-import-ord.idi-tributac-impto-import = tt-ordens-desemb.i-trib-ii
                       decla-import-ord.idi-tributac-ipi          = tt-ordens-desemb.i-trib-ipi
                       decla-import-ord.idi-tributac-icms         = tt-ordens-desemb.i-trib-icms
                       decla-import-ord.idi-tributac-pis          = tt-ordens-desemb.i-trib-pis
                       decla-import-ord.idi-tributac-cofins       = tt-ordens-desemb.i-trib-cofins
                       decla-import-ord.val-aliq-ii               = tt-ordens-desemb.de-aliq-ii
                       decla-import-ord.val-aliq-ipi              = tt-ordens-desemb.de-aliq-ipi
                       decla-import-ord.val-aliq-icms             = tt-ordens-desemb.de-aliq-icms
                       decla-import-ord.val-aliq-pis              = tt-ordens-desemb.de-aliq-pis
                       decla-import-ord.val-aliq-cofins           = tt-ordens-desemb.de-aliq-cofins.
                
                &IF DEFINED(bf-mat-comex) &THEN
                &ELSE
                assign decla-import-ord.log-suspens-impto-import = tt-ordens-desemb.l-suspensao-II
                       decla-import-ord.log-suspens-ipi-import   = tt-ordens-desemb.l-suspensao-IPI.
                &ENDIF
            end. /* for first tt-ordens-desemb */
    end.

    IF VALID-HANDLE(h-bocx225) THEN 
        DELETE PROCEDURE h-bocx225.
    ASSIGN h-bocx225 = ?.
    IF VALID-HANDLE(h-bocx225e) THEN 
        DELETE PROCEDURE h-bocx225e.
    ASSIGN h-bocx225e = ?.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recebe-temp-table-tast DBOProgram 
PROCEDURE pi-recebe-temp-table-tast:
/*:T------------------------------------------------------------------------------
  Purpose:     Recebe as temp-tables criadas pelo TAST para realizar a Efetivaá∆o 
               do Documento atravÇs da Declaraá∆o de Importaá∆o
  Parameters:  tt-documEst-aux       : temp-table da tabela docum-est           (Entrada)
               tt-itemDoc-est-aux    : temp-table da tabela item-doc-est        (Entrada)
               tt-docum-est-cex      : temp-table da tabela docum-est-cex       (Entrada)
               tt-item-doc-est-cex   : temp-table da tabela item-doc-est-cex    (Entrada)
               tt-docto-estoq-nfe-imp: temp-table da tabela docto-estoq-nfe-imp (Entrada) 
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-serie-docto  LIKE docum-est.serie-docto  NO-UNDO.
    DEFINE INPUT PARAMETER pc-nro-docto    LIKE docum-est.nro-docto    NO-UNDO.
    DEFINE INPUT PARAMETER pi-cod-emitente LIKE docum-est.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pc-nat-operacao LIKE docum-est.nat-operacao NO-UNDO.
    DEFINE INPUT PARAMETER TABLE FOR tt-docum-est-tast.
    DEFINE INPUT PARAMETER TABLE FOR tt-documEst-aux.
    DEFINE INPUT PARAMETER TABLE FOR tt-itemDoc-est-aux.
    DEFINE INPUT PARAMETER TABLE FOR tt-docum-est-cex.
    DEFINE INPUT PARAMETER TABLE FOR tt-item-doc-est-cex.
    DEFINE INPUT PARAMETER TABLE FOR tt-docto-estoq-nfe-imp.

    ASSIGN l-tast = YES.

    FOR FIRST tt-documEst-aux:
        FOR FIRST param-imp NO-LOCK
            WHERE param-imp.cod-estabel = tt-documEst-aux.cod-estabel:
        END.
    END.

    ASSIGN c-serie-docto   = pc-serie-docto
           c-nro-documento = pc-nro-docto
           i-cod-emitente  = pi-cod-emitente
           c-nat-operacao  = pc-nat-operacao.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-ver-rateio-desp-comp DBOProgram 
PROCEDURE pi-ver-rateio-desp-comp :
/*:T------------------------------------------------------------------------------
  Purpose:     Retorna valor que indica se j† foi realizado rateio das despesas
               complementares na DI.
  Parameters:  pi-num-di-ems - N£mero DI EMS
               pl-rateado    - Indica se foi rateado as despesas para a DI.
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pi-num-di-ems LIKE decla-import.num-di-ems NO-UNDO.
    DEFINE INPUT PARAM pde-cdd-siscomex-dts LIKE decla-import.cdd-siscomex-dts NO-UNDO.
    DEFINE OUTPUT PARAM pl-rateado   AS LOGICAL                   NO-UNDO.

    FIND FIRST decla-import 
         WHERE decla-import.num-di-ems = pi-num-di-ems 
           AND decla-import.cdd-siscomex-dts = pde-cdd-siscomex-dts NO-LOCK NO-ERROR.
    IF AVAIL decla-import THEN
        &IF '{&BF_MAT_VERSAO_EMS}' < '2.09' &THEN
           ASSIGN pl-rateado = SUBSTRING(decla-import.cod-livre-1,1,1) = "S".
        &ELSE
           ASSIGN pl-rateado = decla-import.log-pend-despes-compltar.
        &ENDIF

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-zera-valores-adic DBOProgram 
PROCEDURE pi-zera-valores-adic :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /* limpa os impostos da adiá∆o */
    IF NOT l-valor-ii-manual THEN
        ASSIGN decla-import-adic.val-ii-db-cr               = 0 
               decla-import-adic.val-ii-nao-tribut          = 0
               decla-import-adic.val-ii-outras              = 0.

    IF NOT l-valor-ipi-manual THEN
        ASSIGN decla-import-adic.val-ipi-db-cr              = 0
               decla-import-adic.val-ipi-nao-tributad       = 0
               decla-import-adic.val-ii-outras              = 0.

    IF NOT l-valor-pis-manual THEN
        ASSIGN decla-import-adic.val-pis-db-cr              = 0
               decla-import-adic.val-pis-nao-tributad       = 0
               decla-import-adic.val-pis-outras             = 0.

    IF NOT l-valor-cofins-manual THEN
        ASSIGN decla-import-adic.val-cofins-db-cr           = 0
               decla-import-adic.val-cofins-nao-tributad    = 0
               decla-import-adic.val-cofins-outras          = 0.

    IF NOT l-valor-icms-manual THEN
        ASSIGN decla-import-adic.val-icms-db-cr             = 0
               decla-import-adic.val-icms-nao-tributad      = 0
               decla-import-adic.val-icms-outras            = 0.

     ASSIGN decla-import-adic.val-base-cofins            = 0 when not l-base-cofins-manual
            decla-import-adic.val-base-icms              = 0 when not l-base-icms-manual
            decla-import-adic.val-base-ii                = 0 when not l-base-ii-manual
            decla-import-adic.val-base-ipi               = 0 when not l-base-ipi-manual
            decla-import-adic.val-base-pis               = 0 when not l-base-pis-manual.        



    /* fim - limpa os impostos da adiá∆o */
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-zera-valores-adic-itens DBOProgram 
PROCEDURE pi-zera-valores-adic-itens :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /* limpa os impostos da adiá∆o */
    IF NOT l-valor-ii-manual THEN
        ASSIGN decla-import-adic-itens.val-ii-db-cr               = 0 
               decla-import-adic-itens.val-ii-nao-tribut          = 0
               decla-import-adic-itens.val-ii-outras              = 0.

    IF NOT l-valor-ipi-manual THEN
        ASSIGN decla-import-adic-itens.val-ipi-db-cr              = 0
               decla-import-adic-itens.val-ipi-nao-tributad       = 0
               decla-import-adic-itens.val-ii-outras              = 0.

    IF NOT l-valor-pis-manual THEN
        ASSIGN decla-import-adic-itens.val-pis-db-cr              = 0
               decla-import-adic-itens.val-pis-nao-tributad       = 0
               decla-import-adic-itens.val-pis-outras             = 0.

    IF NOT l-valor-cofins-manual THEN
        ASSIGN decla-import-adic-itens.val-cofins-db-cr           = 0
               decla-import-adic-itens.val-cofins-nao-tributad    = 0
               decla-import-adic-itens.val-cofins-outras          = 0.

    IF NOT l-valor-icms-manual THEN
        ASSIGN decla-import-adic-itens.val-icms-db-cr             = 0
               decla-import-adic-itens.val-icms-nao-tributad      = 0
               decla-import-adic-itens.val-icms-outras            = 0.

     ASSIGN decla-import-adic-itens.val-base-cofins            = 0 when not l-base-cofins-manual
            decla-import-adic-itens.val-base-icms              = 0 when not l-base-icms-manual
            decla-import-adic-itens.val-base-ii                = 0 when not l-base-ii-manual
            decla-import-adic-itens.val-base-ipi               = 0 when not l-base-ipi-manual
            decla-import-adic-itens.val-base-pis               = 0 when not l-base-pis-manual.        



    /* fim - limpa os impostos da adiá∆o */
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-zera-valores-di DBOProgram 
PROCEDURE pi-zera-valores-di :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-num-di-ems LIKE decla-import.num-di-ems NO-UNDO.
    DEF INPUT PARAM p-cdd-siscomex-dts LIKE decla-import.cdd-siscomex-dts NO-UNDO.

    /* limpa os impostos da DI */
    ASSIGN decla-import.val-ii-db-cr               = 0
           decla-import.val-ii-nao-tribut          = 0
           decla-import.val-ii-outras              = 0

           decla-import.val-ipi-db-cr              = 0
           decla-import.val-ipi-nao-tributad       = 0
           decla-import.val-ii-outras              = 0

           decla-import.val-pis-db-cr              = 0
           decla-import.val-pis-nao-tributad       = 0
           decla-import.val-pis-outras             = 0

           decla-import.val-cofins-db-cr           = 0
           decla-import.val-cofins-nao-tributad    = 0
           decla-import.val-cofins-outras          = 0

           decla-import.val-icms-db-cr             = 0
           decla-import.val-icms-nao-tributad      = 0
           decla-import.val-icms-outras            = 0
           
           decla-import.val-base-cofins            = 0 
           decla-import.val-base-icms              = 0 
           decla-import.val-base-ii                = 0 
           decla-import.val-base-ipi               = 0 
           decla-import.val-base-pis               = 0.
    /* fim - limpa os impostos da DI */  
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piDoctoRecebimento DBOProgram 
PROCEDURE piDoctoRecebimento :
/*-----------------------------------------------------------------------------------
  Purpose: Existe um campo na docum-est para a declaraá∆o de importaá∆o, sendo assim,
           deve ser feita a busca na tabela para verificar se j† tem n£mero da DI e
           se o estoque est† atualizado.
  Notes:       
-------------------------------------------------------------------------------------*/

    DEF  INPUT PARAM pcod-di-siscomex    LIKE {&TableName}.cod-di-siscomex NO-UNDO.
    DEF OUTPUT PARAM plog-encontrou AS   LOGICAL                 NO-UNDO.

    IF pcod-di-siscomex <> "" THEN DO:
        IF CAN-FIND(FIRST docum-est
                    WHERE docum-est.declaracao-import = pcod-di-siscomex) 
        THEN ASSIGN plog-encontrou = YES.
        ELSE ASSIGN plog-encontrou = NO.
    END.
    
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rateiaSeguroAdicao DBOProgram 
PROCEDURE rateiaSeguroAdicao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM p-num-di-ems   LIKE decla-import-ord.num-di-ems  NO-UNDO.
    DEF INPUT  PARAM p-cdd-siscomex-dts LIKE decla-import-ord.cdd-siscomex-dts NO-UNDO.

    FOR EACH decla-import-adic EXCLUSIVE-LOCK
        WHERE decla-import-adic.num-di-ems = p-num-di-ems
          AND decla-import-adic.cdd-siscomex-dts = p-cdd-siscomex-dts,
        FIRST tt-di-totais
        WHERE tt-di-totais.num-di-ems = decla-import.num-di-ems,
        FIRST tt-adic-totais
        WHERE tt-adic-totais.num-di-ems = decla-import-adic.num-di-ems
        AND   tt-adic-totais.num-adic   = decla-import-adic.num-adic,
        FIRST decla-import NO-LOCK
        WHERE decla-import.num-di-ems = p-num-di-ems
          AND decla-import.cdd-siscomex-dts = p-cdd-siscomex-dts:
        
        ASSIGN decla-import-adic.val-vmle = tt-adic-totais.val-merc-adic
               decla-import-adic.val-vmld = tt-adic-totais.val-merc-adic
               decla-import-adic.val-vmcv = tt-adic-totais.val-merc-adic.

        FOR EACH tt-despesas
            WHERE tt-despesas.num-di-ems = p-num-di-ems
            AND   tt-despesas.log-incid-vmle:          

            /*Calculando valor VMLE das adiá‰es. Esse valor ser† usado para rateio do valor do Seguro*/
            FOR EACH tt-desp-rateio
                WHERE tt-desp-rateio.num-di-ems = tt-despesas.num-di-ems
                AND   tt-desp-rateio.num-adic   = tt-adic-totais.num-adic
                AND   tt-desp-rateio.cod-desp   = tt-despesas.cdn-despes :
                ASSIGN decla-import-adic.val-vmle = decla-import-adic.val-vmle + tt-desp-rateio.val-desp.
            END.            
        END.

        FOR FIRST tt-despesas
            WHERE tt-despesas.num-di-ems = decla-import-adic.num-di-ems
            AND   tt-despesas.num-adic   = 0
            AND   tt-despesas.log-seguro :

            ASSIGN de-valor-despesa = 0.

            IF i-mo-codigo <> tt-despesas.cdn-moeda THEN DO:
                RUN converteValorMoeda (INPUT decla-import.num-di-ems,
                                        INPUT decla-import.cdd-siscomex-dts,
                                        INPUT tt-despesas.cdn-moeda,
                                        INPUT i-mo-codigo,
                                        INPUT decla-import.val-seguro,
                                        INPUT decla-import.dat-di,
                                        OUTPUT de-valor-despesa).

                
            END.
            ELSE 
                ASSIGN de-valor-despesa = decla-import.val-seguro.


            RUN calculaValorRateio (INPUT tt-despesas.cdn-despes,
                                    INPUT decla-import-adic.val-vmle,
                                    INPUT tt-adic-totais.peso-total,
                                    INPUT tt-adic-totais.quantidade,
                                    INPUT de-valor-despesa, /*Valor Seguro Total da DI*/
                                    INPUT decla-import.val-vmle,
                                    INPUT tt-di-totais.peso-total,
                                    INPUT tt-di-totais.quantidade,
                                    OUTPUT de-val-desp).
    
            IF de-val-desp = 0 OR de-val-desp = ? THEN
                NEXT.

            FOR FIRST tt-desp-rateio
                WHERE tt-desp-rateio.num-di-ems    = p-num-di-ems
                AND   tt-desp-rateio.cod-desp      = tt-despesas.cdn-despes        
                AND   tt-desp-rateio.num-adic      = decla-import-adic.num-adic:
                ASSIGN tt-desp-rateio.val-desp     = de-val-desp.
            END.
        END.       

        /*Atualizando valor vmcv com os valores do rateio*/
        FOR FIRST decla-import-embarq NO-LOCK
            WHERE decla-import-embarq.num-di-ems = decla-import-adic.num-di-ems
              AND decla-import-embarq.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts,
            FIRST embarque-imp NO-LOCK
            WHERE embarque-imp.cod-estabel = decla-import-embarq.cod-estab
            AND   embarque-imp.embarque    = decla-import-embarq.cod-embarq:

            FOR EACH tt-desp-rateio
                WHERE tt-desp-rateio.num-di-ems = tt-adic-totais.num-di-ems
                AND   tt-desp-rateio.num-adic   = tt-adic-totais.num-adic,
                FIRST tt-despesas
                WHERE tt-despesas.num-di-ems    = tt-adic-totais.num-di-ems
                AND   tt-despesas.cdn-despes    = tt-desp-rateio.cod-desp
                AND   tt-despesas.log-forma-preco-compra:

                /*Atualiza adiá‰es com valor rateado das despesas n∆o precisa converter de moedas pois a convers∆o Ç feita no momento do rateio*/
                ASSIGN decla-import-adic.val-vmcv = decla-import-adic.val-vmcv + tt-desp-rateio.val-desp.

                IF CAN-FIND(FIRST despes-adic NO-LOCK
                            WHERE despes-adic.num-di-ems = tt-desp-rateio.num-di-ems
                            AND   despes-adic.num-adic   = tt-desp-rateio.num-adic  
                            AND   despes-adic.cdn-despes = tt-despesas.cdn-despes
                            AND   despes-adic.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts
                            AND   despes-adic.idi-orig-despes = 1) THEN DO :

                    FOR FIRST despes-adic NO-LOCK
                        WHERE despes-adic.num-di-ems = tt-desp-rateio.num-di-ems
                        AND   despes-adic.num-adic   = tt-desp-rateio.num-adic  
                        AND   despes-adic.cdn-despes = tt-despesas.cdn-despes
                        AND   despes-adic.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts
                        AND   despes-adic.idi-orig-despes = 1 : 

                        /*Se existe despesa apenas na adiá∆o deve somar o valor dessa despesa ao rateio*/
                        ASSIGN de-valor-despesa = 0.
        
                        IF i-mo-codigo <> despes-adic.cdn-moeda THEN DO:
        
                            RUN converteValorMoeda (INPUT decla-import-adic.num-di-ems,
                                                    INPUT decla-import-adic.cdd-siscomex-dts,
                                                    INPUT despes-adic.cdn-moeda,
                                                    INPUT i-mo-codigo,
                                                    INPUT despes-adic.val-despes,
                                                    INPUT decla-import.dat-di,
                                                    OUTPUT de-valor-despesa).
        
                            
                        END.
                        ELSE 
                            ASSIGN de-valor-despesa = despes-adic.val-despes.

                        ASSIGN decla-import-adic.val-vmcv = decla-import-adic.val-vmcv + de-valor-despesa.
                    END.
                END.
            END.
        END.

        FOR EACH tt-despesas
            WHERE tt-despesas.num-di-ems = p-num-di-ems
            AND   tt-despesas.log-incid-val-aduana:
            
            FOR FIRST tt-desp-rateio
                WHERE tt-desp-rateio.num-di-ems = tt-despesas.num-di-ems
                AND   tt-desp-rateio.num-adic   = decla-import-adic.num-adic
                AND   tt-desp-rateio.cod-desp   = tt-despesas.cdn-despes :
                ASSIGN decla-import-adic.val-vmld = decla-import-adic.val-vmld + tt-desp-rateio.val-desp.
            END.            
        END.
    END.       

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rateiaSeguroAdicaoItem DBOProgram 
PROCEDURE rateiaSeguroAdicaoItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM p-num-di-ems   LIKE decla-import-ord.num-di-ems  NO-UNDO.
    DEF INPUT  PARAM p-cdd-siscomex-dts LIKE decla-import-ord.cdd-siscomex-dts NO-UNDO.

    FOR EACH decla-import-adic EXCLUSIVE-LOCK
        WHERE decla-import-adic.num-di-ems = p-num-di-ems
          AND decla-import-adic.cdd-siscomex-dts = p-cdd-siscomex-dts,
        FIRST tt-adic-totais
        WHERE tt-adic-totais.num-di-ems = decla-import-adic.num-di-ems
        AND   tt-adic-totais.num-adic   = decla-import-adic.num-adic,
        FIRST decla-import NO-LOCK
        WHERE decla-import.num-di-ems = p-num-di-ems
          AND decla-import.cdd-siscomex-dts = p-cdd-siscomex-dts:

        FOR EACH decla-import-adic-itens EXCLUSIVE-LOCK
            WHERE decla-import-adic-itens.num-di-ems = decla-import-adic.num-di-ems
            AND   decla-import-adic-itens.num-adic   = decla-import-adic.num-adic
            AND   decla-import-adic-itens.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts,
            FIRST tt-ordens-totais
            WHERE tt-ordens-totais.num-di-ems   = decla-import-adic-itens.num-di-ems
            AND   tt-ordens-totais.num-adic     = decla-import-adic-itens.num-adic  
            AND   tt-ordens-totais.numero-ordem = decla-import-adic-itens.num-ordem
            AND   tt-ordens-totais.parcela      = decla-import-adic-itens.num-parcela :

            ASSIGN decla-import-adic-itens.val-vmle = tt-ordens-totais.val-merc
                   decla-import-adic-itens.val-vmld = tt-ordens-totais.val-merc
                   decla-import-adic-itens.val-vmcv = tt-ordens-totais.val-merc.
            
            FOR EACH tt-despesas
                WHERE tt-despesas.num-di-ems = p-num-di-ems
                AND   tt-despesas.num-adic   = decla-import-adic-itens.num-adic:
        
                /*Calculando valor VMLE dos itens adiá‰es. Esse valor ser† usado para rateio do valor do Seguro*/
                FOR EACH  tt-desp-rateio-item
                    WHERE tt-desp-rateio-item.num-di-ems   = tt-ordens-totais.num-di-ems
                    AND   tt-desp-rateio-item.num-adic     = tt-ordens-totais.num-adic
                    AND   tt-desp-rateio-item.numero-ordem = tt-ordens-totais.numero-ordem
                    AND   tt-desp-rateio-item.parcela      = tt-ordens-totais.parcela
                    AND   tt-desp-rateio-item.cod-desp     = tt-despesas.cdn-despes :
        
                    IF tt-despesas.log-incid-vmle THEN DO:

                        ASSIGN de-valor-despesa = 0.

                        /* Convertendo o valor, pois para calcular o VMLE das adicoes est· sendo utilizado o valor convertido 
                        e isso pode gerar problema de arredondamento */
                        IF i-mo-codigo <> tt-despesas.cdn-moeda THEN DO:
                            RUN converteValorMoeda (INPUT decla-import-adic-itens.num-di-ems,
                                                    INPUT decla-import-adic-itens.cdd-siscomex-dts,
                                                    INPUT tt-despesas.cdn-moeda,
                                                    INPUT i-mo-codigo,
                                                    INPUT tt-desp-rateio-item.val-desp,
                                                    INPUT decla-import.dat-di,
                                                    OUTPUT de-valor-despesa).
            
                            
                        END.
                        ELSE 
                            ASSIGN de-valor-despesa = tt-desp-rateio-item.val-desp.


                        ASSIGN decla-import-adic-itens.val-vmle = decla-import-adic-itens.val-vmle + de-valor-despesa.
                    END.
        
                END.            
            END.

            FOR FIRST tt-despesas
                WHERE tt-despesas.num-di-ems = decla-import-adic-itens.num-di-ems
                AND   tt-despesas.num-adic   = decla-import-adic-itens.num-adic
                AND   tt-despesas.log-seguro :

                ASSIGN de-valor-despesa = 0.

                
                IF i-mo-codigo <> tt-despesas.cdn-moeda 
                AND tt-despesas.i-tip-incid-nf = 1 THEN DO:
                    RUN converteValorMoeda (INPUT decla-import-adic-itens.num-di-ems,
                                            INPUT decla-import-adic-itens.cdd-siscomex-dts,
                                            INPUT tt-despesas.cdn-moeda,
                                            INPUT i-mo-codigo,
                                            INPUT decla-import-adic.val-seguro,
                                            INPUT decla-import.dat-di,
                                            OUTPUT de-valor-despesa).
    
                    
                END.
                ELSE 
                    ASSIGN de-valor-despesa = decla-import-adic.val-seguro.

                RUN calculaValorRateio (INPUT tt-despesas.cdn-despes,
                                        INPUT decla-import-adic-itens.val-vmle,
                                        INPUT tt-ordens-totais.peso-total,
                                        INPUT tt-ordens-totais.quantidade,
                                        INPUT de-valor-despesa, /*Valor Seguro Total da Adiá∆o*/
                                        INPUT decla-import-adic.val-vmle,
                                        INPUT tt-adic-totais.peso-total,
                                        INPUT tt-adic-totais.quantidade,
                                        OUTPUT de-val-desp).
        
                IF de-val-desp <> 0 THEN DO:
                FOR FIRST tt-desp-rateio-item
                    WHERE tt-desp-rateio-item.num-di-ems    = p-num-di-ems
                    AND   tt-desp-rateio-item.cod-desp      = tt-despesas.cdn-despes        
                    AND   tt-desp-rateio-item.num-adic      = decla-import-adic-itens.num-adic
                    AND   tt-desp-rateio-item.numero-ordem  = decla-import-adic-itens.num-ordem
                    AND   tt-desp-rateio-item.parcela       = decla-import-adic-itens.num-parcela:

                    ASSIGN tt-desp-rateio-item.val-desp       = de-val-desp.

                    /*Verifica se a moeda da despesa de seguro Ç diferente da moeda da negociaá∆o e converte*/
                    ASSIGN de-valor-despesa = 0.
    
                    IF i-mo-codigo <> tt-despesas.cdn-moeda THEN DO:
                        RUN converteValorMoeda (INPUT decla-import-adic-itens.num-di-ems,
                                                INPUT decla-import-adic-itens.cdd-siscomex-dts,
                                                INPUT i-mo-codigo,
                                                INPUT tt-despesas.cdn-moeda,
                                                INPUT de-val-desp,
                                                INPUT decla-import.dat-di,
                                                OUTPUT de-valor-despesa).
        
                        
                    END.
                    ELSE 
                        ASSIGN de-valor-despesa = de-val-desp.

                        ASSIGN decla-import-adic-itens.val-seguro      = de-valor-despesa
                               decla-import-adic-itens.cdn-moed-seguro = tt-despesas.cdn-moeda.
    
                    END.
                END.
            END.       
        
            /*Atualizando valor vmcv com os valores do rateio*/
            FOR FIRST tt-di-totais:
        
                FOR EACH  tt-despesas
                    WHERE tt-despesas.num-di-ems = p-num-di-ems
                    AND   tt-despesas.num-adic   = tt-ordens-totais.num-adic
                    AND   tt-despesas.log-forma-preco-compra:

                    FOR FIRST tt-desp-rateio-item
                        WHERE tt-desp-rateio-item.num-di-ems   = tt-ordens-totais.num-di-ems
                        AND   tt-desp-rateio-item.num-adic     = tt-ordens-totais.num-adic
                        AND   tt-desp-rateio-item.numero-ordem = tt-ordens-totais.numero-ordem
                        AND   tt-desp-rateio-item.parcela      = tt-ordens-totais.parcela
                        AND   tt-desp-rateio-item.cod-desp     = tt-despesas.cdn-despes :
        
                        /*Atualiza itens adiá‰es com valor rateado das despesas n∆o precisa converter de moedas pois a convers∆o Ç feita no momento do rateio*/
                        ASSIGN decla-import-adic-itens.val-vmcv = decla-import-adic-itens.val-vmcv + tt-desp-rateio-item.val-desp.                               
                    END.
                END.
            END.
        
            /*Atualizando valor vmld com base em todas as despesas da adiá∆o que incidem valor aduaneiro*/
            FOR EACH tt-despesas
                WHERE tt-despesas.num-di-ems = p-num-di-ems
                AND   tt-despesas.num-adic   = decla-import-adic-itens.num-adic
                AND   tt-despesas.log-incid-val-aduana:
                
                FOR EACH tt-desp-rateio-item
                    WHERE tt-desp-rateio-item.num-di-ems   = p-num-di-ems                      
                    AND   tt-desp-rateio-item.num-adic     = tt-despesas.num-adic  
                    AND   tt-desp-rateio-item.numero-ordem = tt-ordens-totais.numero-ordem
                    AND   tt-desp-rateio-item.parcela      = tt-ordens-totais.parcela
                    AND   tt-desp-rateio-item.cod-desp     = tt-despesas.cdn-despes :
                    ASSIGN decla-import-adic-itens.val-vmld = decla-import-adic-itens.val-vmld + tt-desp-rateio-item.val-desp.
                END.            
            END.
        END.
    END.       

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rateioImpostos DBOProgram 
PROCEDURE rateioImpostos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Realizando_o_Rateio_os_impostos" *}
    RUN pi-acompanhar IN h-acomp (INPUT RETURN-VALUE). /* altera a mensagem do acompanhamentos */

    DEF VAR d-val-rateio-nao-tribut-ii     LIKE decla-import-adic.val-ii-nao-tribut     NO-UNDO.
    DEF VAR d-val-rateio-db-cr-ii          LIKE decla-import-adic.val-ii-db-cr          NO-UNDO.
    DEF VAR d-val-rateio-outras-ii         LIKE decla-import-adic.val-ii-outras         NO-UNDO.
    DEF VAR d-val-rateio-base-ii           LIKE decla-import-adic.val-base-ii           NO-UNDO.
                                                                                        
    DEF VAR d-val-rateio-nao-tribut-ipi    LIKE decla-import-adic.val-ipi-nao-tribut    NO-UNDO.
    DEF VAR d-val-rateio-db-cr-ipi         LIKE decla-import-adic.val-ipi-db-cr         NO-UNDO.
    DEF VAR d-val-rateio-outras-ipi        LIKE decla-import-adic.val-ipi-outras        NO-UNDO.
    DEF VAR d-val-rateio-base-ipi          LIKE decla-import-adic.val-base-ipi          NO-UNDO.
                                                                                        
    DEF VAR d-val-rateio-nao-tribut-pis    LIKE decla-import-adic.val-pis-nao-tributad  NO-UNDO.
    DEF VAR d-val-rateio-db-cr-pis         LIKE decla-import-adic.val-pis-db-cr         NO-UNDO.
    DEF VAR d-val-rateio-outras-pis        LIKE decla-import-adic.val-pis-outras        NO-UNDO.
    DEF VAR d-val-rateio-base-pis          LIKE decla-import-adic.val-base-pis          NO-UNDO.

    DEF VAR d-val-rateio-nao-tribut-cofins LIKE decla-import-adic.val-cofins-nao-tributad NO-UNDO.
    DEF VAR d-val-rateio-db-cr-cofins      LIKE decla-import-adic.val-cofins-db-cr        NO-UNDO.
    DEF VAR d-val-rateio-outras-cofins     LIKE decla-import-adic.val-cofins-outras       NO-UNDO.
    DEF VAR d-val-rateio-base-cofins       LIKE decla-import-adic.val-base-cofins         NO-UNDO.

    DEF VAR d-val-rateio-nao-tribut-icms    LIKE decla-import-adic.val-icms-nao-tribut    NO-UNDO.
    DEF VAR d-val-rateio-db-cr-icms         LIKE decla-import-adic.val-icms-db-cr         NO-UNDO.
    DEF VAR d-val-rateio-outras-icms        LIKE decla-import-adic.val-icms-outras        NO-UNDO.
    DEF VAR d-val-rateio-base-icms          LIKE decla-import-adic.val-base-icms          NO-UNDO.

    DEF VAR de-valor-aduaneiro-cofins      LIKE item-doc-est.val-aduana-pis                NO-UNDO.  
    DEF VAR de-val-acum-desp-cofins        LIKE item-doc-est.val-despes-aduana-pis         NO-UNDO.  
    DEF VAR de-valor-aduaneiro-pis         LIKE item-doc-est.val-aduana-cofins             NO-UNDO.  
    DEF VAR de-val-acum-desp-pis           LIKE item-doc-est.val-despes-aduana-cofins      NO-UNDO. 

    FOR FIRST bf-decla-import-adic NO-LOCK
        WHERE bf-decla-import-adic.num-di-ems = decla-import-adic.num-di-ems
          AND bf-decla-import-adic.num-adic   = decla-import-adic.num-adic
          AND bf-decla-import-adic.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts:
        
        FOR EACH decla-import-adic-itens EXCLUSIVE-LOCK
           WHERE decla-import-adic-itens.num-di-ems = bf-decla-import-adic.num-di-ems
             AND decla-import-adic-itens.num-adic   = bf-decla-import-adic.num-adic
             AND decla-import-adic-itens.cdd-siscomex-dts = bf-decla-import-adic.cdd-siscomex-dts:

            /* rateia os valores das adicoes para os itens */

            /* imposto: II */
            IF l-base-ii-manual THEN DO:
                RUN calculaValorRateioImp(INPUT decla-import-adic-itens.val-vmcv,
                                          INPUT bf-decla-import-adic.val-base-ii,
                                          INPUT bf-decla-import-adic.val-vmcv,
                                          OUTPUT d-val-rateio-base-ii).
                ASSIGN decla-import-adic-itens.val-base-ii = d-val-rateio-base-ii.

            END.
            IF l-valor-ii-manual THEN DO:
                RUN calculaValorRateioImp(INPUT bf-decla-import-adic.val-ii-nao-tribut,
                                          INPUT decla-import-adic-itens.val-vmcv,
                                          INPUT bf-decla-import-adic.val-vmcv,
                                          OUTPUT d-val-rateio-nao-tribut-ii).
                RUN calculaValorRateioImp(INPUT bf-decla-import-adic.val-ii-db-cr,
                                          INPUT decla-import-adic-itens.val-vmcv,
                                          INPUT bf-decla-import-adic.val-vmcv,
                                          OUTPUT d-val-rateio-db-cr-ii).
                RUN calculaValorRateioImp(INPUT bf-decla-import-adic.val-ii-outras,
                                          INPUT decla-import-adic-itens.val-vmcv,
                                          INPUT bf-decla-import-adic.val-vmcv,
                                          OUTPUT d-val-rateio-outras-ii).
                RUN calculaValorRateioImp(INPUT bf-decla-import-adic.val-base-ii,
                                          INPUT decla-import-adic-itens.val-vmcv,
                                          INPUT bf-decla-import-adic.val-vmcv,
                                          OUTPUT d-val-rateio-base-ii).
            END.
            /* fim - imposto: II */

            /* imposto: IPI */
            IF l-base-ipi-manual THEN DO:
                RUN calculaValorRateioImp(INPUT decla-import-adic-itens.val-vmcv,
                                          INPUT bf-decla-import-adic.val-base-ipi,
                                          INPUT bf-decla-import-adic.val-vmcv,
                                          OUTPUT d-val-rateio-base-ipi).

                ASSIGN decla-import-adic-itens.val-base-ipi = d-val-rateio-base-ipi.
            END.

            IF l-valor-ipi-manual THEN DO:
                RUN calculaValorRateioImp(INPUT  bf-decla-import-adic.val-base-ipi,
                                          input  bf-decla-import-adic.val-ipi-db-cr,
                                          INPUT  DEC(substring(bf-decla-import-adic.cod-livre-1,56,19)) / 100000000,
                                          OUTPUT d-val-rateio-base-ipi).

                RUN calculaValorRateioImp(INPUT  bf-decla-import-adic.val-ipi-nao-tributad,
                                          input  bf-decla-import-adic.val-ipi-db-cr,
                                          INPUT  DEC(substring(bf-decla-import-adic.cod-livre-1,56,19)) / 100000000,
                                          OUTPUT d-val-rateio-nao-tribut-ipi).

                RUN calculaValorRateioImp(INPUT  decla-import-adic-itens.val-ipi-db-cr,
                                          input  bf-decla-import-adic.val-ipi-db-cr,
                                          INPUT  DEC(substring(bf-decla-import-adic.cod-livre-1,56,19)) / 100000000,
                                          OUTPUT d-val-rateio-db-cr-ipi).

                RUN calculaValorRateioImp(INPUT  bf-decla-import-adic.val-ipi-outras,
                                          input  bf-decla-import-adic.val-ipi-db-cr,
                                          INPUT  DEC(substring(bf-decla-import-adic.cod-livre-1,56,19)) / 100000000,
                                          OUTPUT d-val-rateio-outras-ipi).
            END.
            /* fim - imposto: IPI */

            /* imposto: PIS (s¢ faz o rateio do PIS caso este valor tenha sido informado manualmente) */
            IF l-base-pis-manual THEN DO:
                RUN calculaValorRateioImp(INPUT  decla-import-adic-itens.val-vmcv,
                                          input  bf-decla-import-adic.val-base-pis,
                                          INPUT  bf-decla-import-adic.val-vmcv,
                                          OUTPUT d-val-rateio-base-pis).
                ASSIGN decla-import-adic-itens.val-base-pis = d-val-rateio-base-pis.
            END.

            IF l-valor-pis-manual THEN DO:
                RUN calculaValorRateioImp(INPUT  bf-decla-import-adic.val-base-pis,
                                          input  bf-decla-import-adic.val-pis-db-cr,
                                          INPUT  DEC(substring(bf-decla-import-adic.cod-livre-1,16,19)) / 100000000,
                                          OUTPUT d-val-rateio-base-pis).

                RUN calculaValorRateioImp(INPUT  bf-decla-import-adic.val-pis-nao-tributad,
                                          input  bf-decla-import-adic.val-pis-db-cr,
                                          INPUT  DEC(substring(bf-decla-import-adic.cod-livre-1,16,19)) / 100000000,
                                          OUTPUT d-val-rateio-nao-tribut-pis).

                RUN calculaValorRateioImp(INPUT  decla-import-adic-itens.val-pis-db-cr,
                                          input  bf-decla-import-adic.val-pis-db-cr,
                                          INPUT  DEC(substring(bf-decla-import-adic.cod-livre-1,16,19)) / 100000000,
                                          OUTPUT d-val-rateio-db-cr-pis).

                RUN calculaValorRateioImp(INPUT  bf-decla-import-adic.val-pis-outras,
                                          input  bf-decla-import-adic.val-pis-db-cr,
                                          INPUT  DEC(substring(bf-decla-import-adic.cod-livre-1,16,19)) / 100000000,
                                          OUTPUT d-val-rateio-outras-pis).
            END.
            /* fim - imposto: PIS */

            /* imposto: COFINS (s¢ faz o rateio do COFINS caso este valor tenha sido informado manualmente) */
            IF l-base-cofins-manual THEN DO:
                RUN calculaValorRateioImp(INPUT  decla-import-adic-itens.val-vmcv,
                                          input  bf-decla-import-adic.val-base-cofins,
                                          INPUT  bf-decla-import-adic.val-vmcv,
                                          OUTPUT d-val-rateio-base-cofins).
                ASSIGN decla-import-adic-itens.val-base-cofins = d-val-rateio-base-cofins.
            END.

            IF l-valor-cofins-manual THEN DO:
                RUN calculaValorRateioImp(INPUT bf-decla-import-adic.val-base-cofins,
                                          input bf-decla-import-adic.val-cofins-db-cr,
                                          INPUT  DEC(substring(bf-decla-import-adic.cod-livre-1,36,19)) / 100000000,
                                          OUTPUT d-val-rateio-base-cofins).
                RUN calculaValorRateioImp(INPUT bf-decla-import-adic.val-cofins-nao-tributad,
                                          input bf-decla-import-adic.val-cofins-db-cr,
                                          INPUT  DEC(substring(bf-decla-import-adic.cod-livre-1,36,19)) / 100000000,
                                          OUTPUT d-val-rateio-nao-tribut-cofins).
                RUN calculaValorRateioImp(INPUT decla-import-adic-itens.val-cofins-db-cr,
                                          input bf-decla-import-adic.val-cofins-db-cr,
                                          INPUT  DEC(substring(bf-decla-import-adic.cod-livre-1,36,19)) / 100000000,
                                          OUTPUT d-val-rateio-db-cr-cofins).
                RUN calculaValorRateioImp(INPUT bf-decla-import-adic.val-cofins-outras,
                                          input bf-decla-import-adic.val-cofins-db-cr,
                                          INPUT  DEC(substring(bf-decla-import-adic.cod-livre-1,36,19)) / 100000000,
                                          OUTPUT d-val-rateio-outras-cofins).
            END.
            /* fim - imposto: COFINS */

            /* imposto: ICMS */
            IF l-base-icms-manual THEN DO:
                RUN calculaValorRateioImp(INPUT decla-import-adic-itens.val-vmcv,
                                          INPUT bf-decla-import-adic.val-base-icms,
                                          INPUT bf-decla-import-adic.val-vmcv,
                                          OUTPUT d-val-rateio-base-icms).

                ASSIGN decla-import-adic-itens.val-base-icms = d-val-rateio-base-icms.
            END.

            IF l-valor-icms-manual THEN DO:
                RUN calculaValorRateioImp(INPUT  bf-decla-import-adic.val-base-icms,
                                          INPUT  bf-decla-import-adic.val-icms-db-cr,
                                          INPUT  DEC(substring(bf-decla-import-adic.cod-livre-1,76,19))/ 100000000,
                                          OUTPUT d-val-rateio-base-icms).

                RUN calculaValorRateioImp(INPUT  bf-decla-import-adic.val-icms-nao-tributad,
                                          input  bf-decla-import-adic.val-icms-db-cr,
                                          INPUT  DEC(substring(bf-decla-import-adic.cod-livre-1,76,19)) / 100000000,
                                          OUTPUT d-val-rateio-nao-tribut-icms).

                RUN calculaValorRateioImp(INPUT  decla-import-adic-itens.val-icms-db-cr,
                                          input  bf-decla-import-adic.val-icms-db-cr,
                                          INPUT  DEC(substring(bf-decla-import-adic.cod-livre-1,76,19)) / 100000000,
                                          OUTPUT d-val-rateio-db-cr-icms).

                RUN calculaValorRateioImp(INPUT  bf-decla-import-adic.val-icms-outras,
                                          input  bf-decla-import-adic.val-icms-db-cr,
                                          INPUT  DEC(substring(bf-decla-import-adic.cod-livre-1,76,19)) / 100000000,
                                          OUTPUT d-val-rateio-outras-icms).
            END.
            /* fim - imposto: ICMS */

            IF l-valor-ii-manual THEN DO:
                ASSIGN decla-import-adic-itens.val-ii-nao-tribut     = d-val-rateio-nao-tribut-ii
                       decla-import-adic-itens.val-ii-db-cr          = d-val-rateio-db-cr-ii
                       decla-import-adic-itens.val-ii-outras         = d-val-rateio-outras-ii
                       decla-import-adic-itens.val-base-ii           = d-val-rateio-base-ii.                                                                                                 
            END.
                                                                 
            /* s¢ faz rateio do pis e cofins quando o valor for alterado manualmente */
            IF l-valor-pis-manual THEN DO:
                ASSIGN decla-import-adic-itens.val-pis-nao-tributad  = d-val-rateio-nao-tribut-pis
                       decla-import-adic-itens.val-pis-db-cr         = d-val-rateio-db-cr-pis
                       decla-import-adic-itens.val-pis-outras        = d-val-rateio-outras-pis
                       decla-import-adic-itens.val-base-pis          = d-val-rateio-base-pis.
            END.
           
            IF l-valor-cofins-manual THEN DO:
                ASSIGN decla-import-adic-itens.val-cofins-nao-tributad = d-val-rateio-nao-tribut-cofins
                       decla-import-adic-itens.val-cofins-db-cr        = d-val-rateio-db-cr-cofins
                       decla-import-adic-itens.val-cofins-outras       = d-val-rateio-outras-cofins
                       decla-import-adic-itens.val-base-cofins         = d-val-rateio-base-cofins.
            END.

        END. /* for each decla-import-adic-itens */
    END. /* for each decla-import-adic */

    RELEASE decla-import-adic-itens.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE relacionaOrdensAdicDespesas DBOProgram 
PROCEDURE relacionaOrdensAdicDespesas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-num-di-ems LIKE {&TABLENAME}.num-di-ems NO-UNDO.
    DEF INPUT PARAM p-cdd-siscomex-dts LIKE {&TABLENAME}.cdd-siscomex-dts NO-UNDO.

    /*gerando relacionamento entre as ordens da DI e as despesas da DI*/
    FOR EACH tt-ordens-totais:
        
        FOR EACH despes-decla-import
            WHERE despes-decla-import.num-di-ems = p-num-di-ems
              AND despes-decla-import.cdd-siscomex-dts = p-cdd-siscomex-dts
              AND despes-decla-import.idi-tip-incid-nf = i-tipo-rateio no-lock:

            IF NOT CAN-FIND(FIRST tt-ordens-desp
                            WHERE tt-ordens-desp.num-di-ems   = p-num-di-ems
                            AND   tt-ordens-desp.numero-ordem = tt-ordens-totais.numero-ordem
                            AND   tt-ordens-desp.num-adic     = tt-ordens-totais.num-adic
                            AND   tt-ordens-desp.parcela      = tt-ordens-totais.parcela
                            AND   tt-ordens-desp.cod-desp     = despes-decla-import.cdn-despes) THEN DO:

                CREATE tt-ordens-desp.
                ASSIGN tt-ordens-desp.num-di-ems   = p-num-di-ems
                       tt-ordens-desp.num-adic     = tt-ordens-totais.num-adic
                       tt-ordens-desp.numero-ordem = tt-ordens-totais.numero-ordem         
                       tt-ordens-desp.parcela      = tt-ordens-totais.parcela             
                       tt-ordens-desp.cod-desp     = despes-decla-import.cdn-despes            
                       tt-ordens-desp.cod-incoterm = despes-decla-import.cod-incoterm-rat
                       tt-ordens-desp.cod-estabel  = decla-import.cod-estab.
            END.
        END.
        
        
        IF i-tipo-rateio = 1 /*despesas nacionalizacao*/ THEN 
            /* Verifica despesas inclusas manualmente nas adicoes */
            FOR EACH despes-adic
               WHERE despes-adic.num-di-ems      = p-num-di-ems
                 AND despes-adic.num-adic        = tt-ordens-totais.num-adic
                 AND despes-adic.cdd-siscomex-dts = p-cdd-siscomex-dts
                 AND despes-adic.idi-orig-despes = 1 NO-LOCK:
                
                IF NOT CAN-FIND(FIRST tt-ordens-desp
                            WHERE tt-ordens-desp.num-di-ems   = despes-adic.num-di-ems
                            AND   tt-ordens-desp.numero-ordem = tt-ordens-totais.numero-ordem
                            AND   tt-ordens-desp.num-adic     = despes-adic.num-adic
                            AND   tt-ordens-desp.parcela      = tt-ordens-totais.parcela
                            AND   tt-ordens-desp.cod-desp     = despes-adic.cdn-despes) THEN DO:
                
                    CREATE tt-ordens-desp.
                    ASSIGN tt-ordens-desp.num-di-ems   = p-num-di-ems
                           tt-ordens-desp.num-adic     = tt-ordens-totais.num-adic
                           tt-ordens-desp.numero-ordem = tt-ordens-totais.numero-ordem         
                           tt-ordens-desp.parcela      = tt-ordens-totais.parcela             
                           tt-ordens-desp.cod-desp     = despes-adic.cdn-despes            
                           tt-ordens-desp.cod-incoterm = despes-adic.cod-incoterm-rat
                           tt-ordens-desp.cod-estabel  = decla-import.cod-estab.
                END.
            END.
    END.

    /*gerando relacionamento entre as ordens da DI e as despesas da DI*/
    FOR EACH tt-adic-totais:
        FOR EACH despes-decla-import
            WHERE despes-decla-import.num-di-ems = p-num-di-ems
              AND despes-decla-import.cdd-siscomex-dts = p-cdd-siscomex-dts
              AND despes-decla-import.idi-tip-incid-nf = i-tipo-rateio no-lock:

            IF NOT CAN-FIND(FIRST tt-adic-desp
                            WHERE tt-adic-desp.num-di-ems   = p-num-di-ems
                            AND   tt-adic-desp.num-adic     = tt-adic-totais.num-adic
                            AND   tt-adic-desp.cod-desp     = despes-decla-import.cdn-despes) THEN DO:
                CREATE tt-adic-desp.
                ASSIGN tt-adic-desp.num-di-ems   = p-num-di-ems
                       tt-adic-desp.num-adic     = tt-adic-totais.num-adic
                       tt-adic-desp.cod-desp     = despes-decla-import.cdn-despes            
                       tt-adic-desp.cod-incoterm = despes-decla-import.cod-incoterm-rat
                       tt-adic-desp.cod-estabel  = decla-import.cod-estab.
            END.
        END.
    END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaCotacaoDia DBOProgram 
PROCEDURE retornaCotacaoDia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM p-cod-di-siscomex LIKE decla-import.cod-di-siscomex    NO-UNDO.
    DEF INPUT  PARAM p-moeda         LIKE despes-decla-import.cdn-moeda  NO-UNDO.
    DEF INPUT  PARAM p-data          LIKE decla-import.dat-di            NO-UNDO.
    DEF OUTPUT PARAM p-cotacao       LIKE decla-import-cotac.val-cotac   NO-UNDO.

    DEF VAR p-num-di-ems LIKE decla-import.num-di-ems NO-UNDO.
    DEF VAR p-cdd-siscomex-dts LIKE decla-import.cdd-siscomex-dts NO-UNDO.

    FOR FIRST decla-import NO-LOCK
        WHERE decla-import.cod-di-siscomex = p-cod-di-siscomex :
        ASSIGN p-num-di-ems = decla-import.num-di-ems
               p-cdd-siscomex-dts = decla-import.cdd-siscomex-dts.
    END.

    IF p-moeda <> 0 THEN DO:
        IF CAN-FIND(FIRST decla-import-cotac
                    WHERE decla-import-cotac.num-di-ems = p-num-di-ems
                    AND   decla-import-cotac.cdd-siscomex-dts = p-cdd-siscomex-dts
                    AND   decla-import-cotac.val-cotac  > 0) THEN DO: 
            IF CAN-FIND(FIRST decla-import-cotac
                        WHERE decla-import-cotac.num-di-ems = p-num-di-ems
                        AND   decla-import-cotac.cdn-moeda  = p-moeda
                        AND   decla-import-cotac.cdd-siscomex-dts = p-cdd-siscomex-dts
                        AND   decla-import-cotac.val-cotac  > 0) THEN DO:
                FOR FIRST decla-import-cotac NO-LOCK
                    WHERE decla-import-cotac.num-di-ems = p-num-di-ems
                    AND   decla-import-cotac.cdn-moeda  = p-moeda
                    AND   decla-import-cotac.cdd-siscomex-dts = p-cdd-siscomex-dts
                    AND   decla-import-cotac.val-cotac  > 0:
                    ASSIGN p-cotacao = decla-import-cotac.val-cotac.
                END.
            END.                   
            ELSE DO:
                FIND  cotacao
                WHERE cotacao.mo-codigo   = p-moeda
                AND   cotacao.ano-periodo = string(year(p-data)) + string(month(p-data),"99")
                AND   cotacao.cotacao[int(day(p-data))] <> 0 no-lock no-error.
                IF NOT AVAIL cotacao THEN DO:
                   IF p-moeda <> 0 THEN DO:
                        {method/svc/errors/inserr.i
                              &ErrorNumber="1847"
                              &ErrorType="EMS"
                              &ErrorParameters="string(p-moeda) + '~~~~' + STRING(p-data)"}     
                   END.
                   ELSE
                       ASSIGN p-cotacao = 1.  
                END.
                ELSE
                    ASSIGN p-cotacao = cotacao.cotacao[int(day(p-data))].
            END.
        END.
        ELSE DO:
            FIND  cotacao
            WHERE cotacao.mo-codigo   = p-moeda
            AND   cotacao.ano-periodo = string(year(p-data)) + string(month(p-data),"99")
            AND   cotacao.cotacao[int(day(p-data))] <> 0 no-lock no-error.
            IF NOT AVAIL cotacao THEN DO:
               IF p-moeda <> 0 THEN DO:
                    {method/svc/errors/inserr.i
                          &ErrorNumber="1847"
                          &ErrorType="EMS"
                          &ErrorParameters="string(p-moeda) + '~~~~' + STRING(p-data)"}     
               END.
               ELSE
                   ASSIGN p-cotacao = 1.
            END.
            ELSE
                ASSIGN p-cotacao = cotacao.cotacao[int(day(p-data))].

        END.                    
    END.
    ELSE
        ASSIGN p-cotacao = 1.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE totalizaValores DBOProgram 
PROCEDURE totalizaValores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR i-trib-cbs-adic           AS INT NO-UNDO.
    DEF VAR d-tot-di-valor-cbs-reg    AS DEC NO-UNDO.
    DEF VAR i-trib-ibsuf-adic         AS INT NO-UNDO.
    DEF VAR d-tot-di-valor-ibsuf-reg  AS DEC NO-UNDO.
    DEF VAR i-trib-ibsmun-adic        AS INT NO-UNDO.
    DEF VAR d-tot-di-valor-ibsmun-reg AS DEC NO-UNDO.
    
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Totalizando_os_valores_dos_impostos" *}
    RUN pi-acompanhar IN h-acomp (INPUT RETURN-VALUE + "."). /* altera a mensagem do acompanhamentos */
    ASSIGN d-tot-di-val-base-ii           = 0
           d-tot-di-val-base-ipi          = 0
           d-tot-di-val-base-pis          = 0
           d-tot-di-val-base-cofins       = 0
           d-tot-di-val-base-icms         = 0
           
           d-tot-di-valor-cbs-tribut      = 0
           d-tot-di-base-cbs-tribut       = 0
           d-tot-di-valor-cbs-outros      = 0
           
           d-tot-di-valor-ibsuf-tribut    = 0
           d-tot-di-base-ibsuf-tribut     = 0
           d-tot-di-valor-ibsuf-outros    = 0

           d-tot-di-valor-ibsmun-tribut   = 0
           d-tot-di-base-ibsmun-tribut    = 0
           d-tot-di-valor-ibsmun-outros   = 0
           
           d-tot-di-valor-is-tribut       = 0
           d-tot-di-base-is-tribut        = 0
           d-tot-di-valor-is-outros       = 0
           
           d-tot-di-val-ii-db-cr          = 0
           d-tot-di-val-ii-nao-tribut     = 0
           d-tot-di-val-ii-outras         = 0

           d-tot-di-val-ipi-db-cr         = 0
           d-tot-di-val-ipi-nao-tribut    = 0
           d-tot-di-val-ipi-outras        = 0

           d-tot-di-val-pis-db-cr         = 0
           d-tot-di-val-pis-nao-tribut    = 0
           d-tot-di-val-pis-outras        = 0

           d-tot-di-val-cofins-db-cr      = 0
           d-tot-di-val-cofins-nao-tribut = 0
           d-tot-di-val-cofins-outras     = 0
        
           d-tot-di-val-icms-db-cr      = 0
           d-tot-di-val-icms-nao-tribut = 0
           d-tot-di-val-icms-outras     = 0
           
           i-trib-cbs-adic              = 0
           d-tot-di-valor-cbs-reg       = 0
           i-trib-ibsuf-adic            = 0
           d-tot-di-valor-ibsuf-reg     = 0
           i-trib-ibsmun-adic           = 0
           d-tot-di-valor-ibsmun-reg    = 0.


    FOR EACH decla-import-adic EXCLUSIVE-LOCK
       WHERE decla-import-adic.num-di-ems = decla-import.num-di-ems
         AND decla-import-adic.cdd-siscomex-dts = decla-import.cdd-siscomex-dts:

        

        ASSIGN d-tot-di-val-base-ii                 = d-tot-di-val-base-ii           + decla-import-adic.val-base-ii    
               d-tot-di-val-base-ipi                = d-tot-di-val-base-ipi          + decla-import-adic.val-base-ipi   
               d-tot-di-val-base-pis                = d-tot-di-val-base-pis          + decla-import-adic.val-base-pis   
               d-tot-di-val-base-cofins             = d-tot-di-val-base-cofins       + decla-import-adic.val-base-cofins
               d-tot-di-val-base-icms               = d-tot-di-val-base-icms         + decla-import-adic.val-base-icms
                                                                                     
               d-tot-di-val-ii-db-cr                = d-tot-di-val-ii-db-cr          + decla-import-adic.val-ii-db-cr     
               d-tot-di-val-ii-nao-tribut           = d-tot-di-val-ii-nao-tribut     + decla-import-adic.val-ii-nao-tribut
               d-tot-di-val-ii-outras               = d-tot-di-val-ii-outras         + decla-import-adic.val-ii-outras    

               d-tot-di-val-ipi-db-cr               = d-tot-di-val-ipi-db-cr         + decla-import-adic.val-ipi-db-cr     
               d-tot-di-val-ipi-nao-tribut          = d-tot-di-val-ipi-nao-tribut    + decla-import-adic.val-ipi-nao-tributad
               d-tot-di-val-ipi-outras              = d-tot-di-val-ipi-outras        + decla-import-adic.val-ipi-outras
                                                                                     
               d-tot-di-val-pis-db-cr               = d-tot-di-val-pis-db-cr         + decla-import-adic.val-pis-db-cr
               d-tot-di-val-pis-nao-tribut          = d-tot-di-val-pis-nao-tribut    + decla-import-adic.val-pis-nao-tributad
               d-tot-di-val-pis-outras              = d-tot-di-val-pis-outras        + decla-import-adic.val-pis-outras

               d-tot-di-val-cofins-db-cr            = d-tot-di-val-cofins-db-cr      + decla-import-adic.val-cofins-db-cr
               d-tot-di-val-cofins-nao-tribut       = d-tot-di-val-cofins-nao-tribut + decla-import-adic.val-cofins-nao-tributad
               d-tot-di-val-cofins-outras           = d-tot-di-val-cofins-outras     + decla-import-adic.val-cofins-outras

               d-tot-di-val-icms-db-cr              = d-tot-di-val-icms-db-cr        + decla-import-adic.val-icms-db-cr
               d-tot-di-val-icms-nao-tribut         = d-tot-di-val-icms-nao-tribut   + decla-import-adic.val-icms-nao-tributad
               d-tot-di-val-icms-outras             = d-tot-di-val-icms-outras       + decla-import-adic.val-icms-outras.
    END. /* for each decla-import-adic */
    
     FOR EACH decla-import-trib
       where decla-import-trib.num-di-ems       = decla-import.num-di-ems
         and decla-import-trib.cdd-siscomex-dts = decla-import.cdd-siscomex-dts
         and (   decla-import-trib.cod-campo    = "BASE":U
              OR decla-import-trib.cod-campo    = "VALOR":U
              OR decla-import-trib.cod-campo    = "OUTROS":U
              OR decla-import-trib.cod-campo    = "VALOR-REG":U
              OR decla-import-trib.cod-campo    = "SUSPENSO":U) EXCLUSIVE-LOCK:
        ASSIGN decla-import-trib.cod-conteudo = "0".
    END.
    
    for each decla-import-adic-trib
       where decla-import-adic-trib.num-di-ems       = decla-import.num-di-ems
         and decla-import-adic-trib.cdd-siscomex-dts = decla-import.cdd-siscomex-dts NO-LOCK: 
         
       IF decla-import-adic-trib.cod-campo = "BASE":U
       OR decla-import-adic-trib.cod-campo = "VALOR":U 
       OR decla-import-adic-trib.cod-campo = "OUTROS":U
       OR decla-import-adic-trib.cod-campo = "VALOR-REG":U THEN DO:
           
            find first decla-import-trib
                where decla-import-trib.num-di-ems       = decla-import.num-di-ems
                  and decla-import-trib.cdd-siscomex-dts = decla-import.cdd-siscomex-dts
                  and decla-import-trib.nom-trib         = decla-import-adic-trib.nom-trib
                  and decla-import-trib.cod-campo        = decla-import-adic-trib.cod-campo exclusive-lock no-error.
           if not avail decla-import-trib then do:
               create decla-import-trib.
               assign decla-import-trib.num-di-ems       = decla-import.num-di-ems
                      decla-import-trib.cdd-siscomex-dts = decla-import.cdd-siscomex-dts
                      decla-import-trib.nom-trib         = decla-import-adic-trib.nom-trib
                      decla-import-trib.cod-campo        = decla-import-adic-trib.cod-campo.
           end.
       
           IF decla-import-trib.nom-trib = "CBS":U THEN DO:
              IF decla-import-trib.cod-campo = "VALOR" THEN 
                  ASSIGN d-tot-di-valor-cbs-tribut      = d-tot-di-valor-cbs-tribut + DEC(decla-import-adic-trib.cod-conteudo)
                         decla-import-trib.cod-conteudo = STRING(d-tot-di-valor-cbs-tribut).
              ELSE
              IF decla-import-trib.cod-campo = "BASE" THEN
                  ASSIGN d-tot-di-base-cbs-tribut       = d-tot-di-base-cbs-tribut  + DEC(decla-import-adic-trib.cod-conteudo)
                         decla-import-trib.cod-conteudo = STRING(d-tot-di-base-cbs-tribut).    
              ELSE 
              IF decla-import-trib.cod-campo = "OUTROS" THEN
                  ASSIGN d-tot-di-valor-cbs-outros      = d-tot-di-valor-cbs-outros  + DEC(decla-import-adic-trib.cod-conteudo)
                         decla-import-trib.cod-conteudo = STRING(d-tot-di-valor-cbs-outros).    
              ELSE 
              IF decla-import-trib.cod-campo = "VALOR-REG" THEN
                  ASSIGN d-tot-di-valor-cbs-reg      = d-tot-di-valor-cbs-reg  + DEC(decla-import-adic-trib.cod-conteudo)
                         decla-import-trib.cod-conteudo = STRING(d-tot-di-valor-cbs-reg).
           END.
           
           IF decla-import-trib.nom-trib = "IBSUF":U THEN DO:
              IF decla-import-trib.cod-campo = "VALOR" THEN 
                 ASSIGN d-tot-di-valor-ibsuf-tribut    = d-tot-di-valor-ibsuf-tribut + DEC(decla-import-adic-trib.cod-conteudo)
                        decla-import-trib.cod-conteudo = STRING(d-tot-di-valor-ibsuf-tribut).
              ELSE
              IF decla-import-trib.cod-campo = "BASE" THEN 
                  ASSIGN d-tot-di-base-ibsuf-tribut     = d-tot-di-base-ibsuf-tribut  + DEC(decla-import-adic-trib.cod-conteudo)
                         decla-import-trib.cod-conteudo = STRING(d-tot-di-base-ibsuf-tribut).       
              ELSE
              IF decla-import-trib.cod-campo = "OUTROS" THEN
                  ASSIGN d-tot-di-valor-ibsuf-outros     = d-tot-di-valor-ibsuf-outros + DEC(decla-import-adic-trib.cod-conteudo)
                         decla-import-trib.cod-conteudo  = STRING(d-tot-di-valor-ibsuf-outros).
              ELSE
              IF decla-import-trib.cod-campo = "VALOR-REG" THEN
                  ASSIGN d-tot-di-valor-ibsuf-reg       = d-tot-di-valor-ibsuf-reg    + DEC(decla-import-adic-trib.cod-conteudo)
                         decla-import-trib.cod-conteudo = STRING(d-tot-di-valor-ibsuf-reg).
           END.
           IF decla-import-trib.nom-trib = "IBSMUN":U THEN DO:
              IF decla-import-trib.cod-campo = "VALOR" THEN 
                 ASSIGN d-tot-di-valor-ibsmun-tribut    = d-tot-di-valor-ibsmun-tribut + DEC(decla-import-adic-trib.cod-conteudo)
                        decla-import-trib.cod-conteudo = STRING(d-tot-di-valor-ibsmun-tribut).
              ELSE
              IF decla-import-trib.cod-campo = "BASE" THEN 
                  ASSIGN d-tot-di-base-ibsmun-tribut     = d-tot-di-base-ibsmun-tribut  + DEC(decla-import-adic-trib.cod-conteudo)
                         decla-import-trib.cod-conteudo = STRING(d-tot-di-base-ibsmun-tribut).       
              ELSE
              IF decla-import-trib.cod-campo = "OUTROS" THEN
                  ASSIGN d-tot-di-valor-ibsmun-outros     = d-tot-di-valor-ibsmun-outros + DEC(decla-import-adic-trib.cod-conteudo)
                         decla-import-trib.cod-conteudo  = STRING(d-tot-di-valor-ibsmun-outros).
              ELSE
              IF decla-import-trib.cod-campo = "VALOR-REG" THEN
                  ASSIGN d-tot-di-valor-ibsmun-reg      = d-tot-di-valor-ibsmun-reg + DEC(decla-import-adic-trib.cod-conteudo)
                         decla-import-trib.cod-conteudo = STRING(d-tot-di-valor-ibsmun-reg).
           END.
           
           IF decla-import-trib.nom-trib = "IS":U THEN DO:
              IF decla-import-trib.cod-campo = "VALOR" THEN 
                  ASSIGN d-tot-di-valor-is-tribut       = d-tot-di-valor-is-tribut + DEC(decla-import-adic-trib.cod-conteudo)
                         decla-import-trib.cod-conteudo = STRING(d-tot-di-valor-is-tribut).
              ELSE
              IF decla-import-trib.cod-campo = "BASE" THEN
                  ASSIGN d-tot-di-base-is-tribut        = d-tot-di-base-is-tribut  + DEC(decla-import-adic-trib.cod-conteudo)
                         decla-import-trib.cod-conteudo = STRING(d-tot-di-base-is-tribut).    
              ELSE 
              IF decla-import-trib.cod-campo = "OUTROS" THEN
                  ASSIGN d-tot-di-valor-is-outros       = d-tot-di-valor-is-outros  + DEC(decla-import-adic-trib.cod-conteudo)
                         decla-import-trib.cod-conteudo = STRING(d-tot-di-valor-is-outros).    
           END.
       END.
       
       IF decla-import-adic-trib.cod-campo = "COD-TRIB":U
       AND INT(REPLACE(decla-import-adic-trib.cod-conteudo,',','.')) = 5 THEN DO:

           IF decla-import-adic-trib.nom-trib = "CBS":U THEN
              ASSIGN i-trib-cbs-adic = INT(REPLACE(decla-import-adic-trib.cod-conteudo,',','.')).

           IF decla-import-adic-trib.nom-trib = "IBSUF":U THEN
              ASSIGN i-trib-ibsuf-adic = INT(REPLACE(decla-import-adic-trib.cod-conteudo,',','.')).
              
           IF decla-import-adic-trib.nom-trib = "IBSMUN":U THEN
              ASSIGN i-trib-ibsmun-adic = INT(REPLACE(decla-import-adic-trib.cod-conteudo,',','.')).
        END.
    end.

    IF  i-trib-cbs-adic = 5 //Suspenso
    AND d-tot-di-valor-cbs-reg <> 0 THEN DO:
        find first decla-import-trib
            where decla-import-trib.num-di-ems       = decla-import.num-di-ems
              and decla-import-trib.cdd-siscomex-dts = decla-import.cdd-siscomex-dts
              and decla-import-trib.nom-trib         = "CBS":U
              and decla-import-trib.cod-campo        = "SUSPENSO":U exclusive-lock no-error.
        if not avail decla-import-trib then do:
            create decla-import-trib.
            assign decla-import-trib.num-di-ems       = decla-import.num-di-ems
                   decla-import-trib.cdd-siscomex-dts = decla-import.cdd-siscomex-dts
                   decla-import-trib.nom-trib         = "CBS":U
                   decla-import-trib.cod-campo        = "SUSPENSO":U.
        end.
        ASSIGN decla-import-trib.cod-conteudo = STRING(d-tot-di-valor-cbs-reg).
    END.
    
    IF  i-trib-ibsuf-adic = 5 //Suspenso
    AND d-tot-di-valor-ibsuf-reg <> 0 THEN DO:
        find first decla-import-trib
            where decla-import-trib.num-di-ems       = decla-import.num-di-ems
              and decla-import-trib.cdd-siscomex-dts = decla-import.cdd-siscomex-dts
              and decla-import-trib.nom-trib         = "IBSUF":U
              and decla-import-trib.cod-campo        = "SUSPENSO":U exclusive-lock no-error.
        if not avail decla-import-trib then do:
            create decla-import-trib.
            assign decla-import-trib.num-di-ems       = decla-import.num-di-ems
                   decla-import-trib.cdd-siscomex-dts = decla-import.cdd-siscomex-dts
                   decla-import-trib.nom-trib         = "IBSUF":U
                   decla-import-trib.cod-campo        = "SUSPENSO":U.
        end.
        ASSIGN decla-import-trib.cod-conteudo = STRING(d-tot-di-valor-ibsuf-reg).
    END.

    IF  i-trib-ibsmun-adic = 5 //Suspenso
    AND d-tot-di-valor-ibsmun-reg <> 0 THEN DO:
        find first decla-import-trib
            where decla-import-trib.num-di-ems       = decla-import.num-di-ems
              and decla-import-trib.cdd-siscomex-dts = decla-import.cdd-siscomex-dts
              and decla-import-trib.nom-trib         = "IBSMUN":U
              and decla-import-trib.cod-campo        = "SUSPENSO":U exclusive-lock no-error.
        if not avail decla-import-trib then do:
            create decla-import-trib.
            assign decla-import-trib.num-di-ems       = decla-import.num-di-ems
                   decla-import-trib.cdd-siscomex-dts = decla-import.cdd-siscomex-dts
                   decla-import-trib.nom-trib         = "IBSMUN":U
                   decla-import-trib.cod-campo        = "SUSPENSO":U.
        end.
        ASSIGN decla-import-trib.cod-conteudo = STRING(d-tot-di-valor-ibsmun-reg).
    END.
    
    ASSIGN decla-import.val-base-ii           = d-tot-di-val-base-ii    
           decla-import.val-base-ipi          = d-tot-di-val-base-ipi   
           decla-import.val-base-pis          = d-tot-di-val-base-pis   
           decla-import.val-base-cofins       = d-tot-di-val-base-cofins
           decla-import.val-base-icms         = d-tot-di-val-base-icms
                                              
           decla-import.val-ii-db-cr          = d-tot-di-val-ii-db-cr
           decla-import.val-ii-nao-tribut     = d-tot-di-val-ii-nao-tribut
           decla-import.val-ii-outras         = d-tot-di-val-ii-outras

           decla-import.val-ipi-db-cr          = d-tot-di-val-ipi-db-cr
           decla-import.val-ipi-nao-tributad   = d-tot-di-val-ipi-nao-tribut
           decla-import.val-ipi-outras         = d-tot-di-val-ipi-outras
        
           decla-import.val-pis-db-cr         = d-tot-di-val-pis-db-cr     
           decla-import.val-pis-nao-tributad  = d-tot-di-val-pis-nao-tribut
           decla-import.val-pis-outras        = d-tot-di-val-pis-outras    

           decla-import.val-cofins-db-cr        = d-tot-di-val-cofins-db-cr
           decla-import.val-cofins-nao-tributad = d-tot-di-val-cofins-nao-tribut
           decla-import.val-cofins-outras       = d-tot-di-val-cofins-outras

           decla-import.val-icms-db-cr        = d-tot-di-val-icms-db-cr
           decla-import.val-icms-nao-tributad = d-tot-di-val-icms-nao-tribut
           decla-import.val-icms-outras       = d-tot-di-val-icms-outras.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaCalculoImpostos DBOProgram 
PROCEDURE validaCalculoImpostos :
DEF INPUT PARAM p-num-di-ems         LIKE decla-import.num-di-ems NO-UNDO.
DEF INPUT PARAM p-cdd-siscomex-dts   LIKE decla-import.cdd-siscomex-dts NO-UNDO. 
    

    DEF VAR l-possui-errors AS LOGICAL INITIAL NO EXTENT 2 NO-UNDO.
    
    ASSIGN c-desc-msg = "".

    FOR FIRST decla-import NO-LOCK
        WHERE decla-import.num-di-ems = p-num-di-ems
          AND decla-import.cdd-siscomex-dts = p-cdd-siscomex-dts:

        FOR EACH decla-import-adic NO-LOCK
            WHERE decla-import-adic.num-di-ems = decla-import.num-di-ems
              AND decla-import-adic.cdd-siscomex-dts = decla-import.cdd-siscomex-dts:
    
            FOR EACH decla-import-adic-itens NO-LOCK
                WHERE decla-import-adic-itens.num-di-ems = decla-import-adic.num-di-ems
                AND   decla-import-adic-itens.num-adic   = decla-import-adic.num-adic
                AND   decla-import-adic-itens.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts:
    
                IF (decla-import-adic-itens.val-ii-nao-tribut            = ?   AND
                    decla-import-adic-itens.val-ii-db-cr                 = ?   AND
                    decla-import-adic-itens.val-ii-outras                = ?   AND     
                    decla-import-adic-itens.idi-tributac-impto-import    <> 2)  OR

                   (decla-import-adic-itens.val-ii-nao-tribut            <= 0   AND
                    decla-import-adic-itens.val-ii-db-cr                 <= 0   AND
                    decla-import-adic-itens.val-ii-outras                <= 0   AND 
                    decla-import-adic-itens.idi-tributac-impto-import    <> 2)  THEN

                    IF decla-import-adic-itens.idi-tributac-impto-import = 1 THEN
                        RUN pi-Errors-CalcImpostos(INPUT 1,
                                                   INPUT "Item-adic":U,
                                                   INPUT decla-import-adic-itens.num-di-ems,
                                                   INPUT decla-import-adic-itens.num-adic,
                                                   INPUT decla-import-adic-itens.num-seq,
                                                   INPUT "WARNING":U,
                                                   OUTPUT l-possui-errors).
                    ELSE
                        RUN pi-Errors-CalcImpostos(INPUT 1,
                                                   INPUT "Item-adic":U,
                                                   INPUT decla-import-adic-itens.num-di-ems,
                                                   INPUT decla-import-adic-itens.num-adic,
                                                   INPUT decla-import-adic-itens.num-seq,
                                                   INPUT "ERROR":U,
                                                   OUTPUT l-possui-errors).
                                                                        
                IF (decla-import-adic-itens.val-ipi-nao-tributad         = ?   AND
                    decla-import-adic-itens.val-ipi-db-cr                = ?   AND
                    decla-import-adic-itens.val-ipi-outras               = ?   AND
                    decla-import-adic-itens.idi-tributac-ipi             <> 2)  OR

                   (decla-import-adic-itens.val-ipi-nao-tributad         <= 0   AND
                    decla-import-adic-itens.val-ipi-db-cr                <= 0   AND
                    decla-import-adic-itens.val-ipi-outras               <= 0   AND
                    decla-import-adic-itens.log-suspens-ipi-import       =  NO  AND  
                    decla-import-adic-itens.idi-tributac-ipi             <> 2)  THEN 


                    IF decla-import-adic-itens.idi-tributac-ipi = 1 THEN
                        RUN pi-Errors-CalcImpostos(INPUT 2,
                                                   INPUT "Item-adic":U,
                                                   INPUT decla-import-adic-itens.num-di-ems,
                                                   INPUT decla-import-adic-itens.num-adic,
                                                   INPUT decla-import-adic-itens.num-seq,
                                                   INPUT "WARNING":U,
                                                   OUTPUT l-possui-errors).
                    ELSE
                        RUN pi-Errors-CalcImpostos(INPUT 2,
                                                   INPUT "Item-adic":U,
                                                   INPUT decla-import-adic-itens.num-di-ems,
                                                   INPUT decla-import-adic-itens.num-adic,
                                                   INPUT decla-import-adic-itens.num-seq,
                                                   INPUT "ERROR":U,
                                                   OUTPUT l-possui-errors).
                                                                        
                IF (decla-import-adic-itens.val-icms-nao-tributad        = ?   AND
                    decla-import-adic-itens.val-icms-db-cr               = ?   AND
                    decla-import-adic-itens.val-icms-outras              = ?   AND
                    decla-import-adic-itens.idi-tributac-icms            <> 2)  OR

                   (decla-import-adic-itens.val-icms-nao-tributad        <= 0   AND
                    decla-import-adic-itens.val-icms-db-cr               <= 0   AND
                    decla-import-adic-itens.val-icms-outras              <= 0   AND
                    decla-import-adic-itens.idi-tributac-icms            <> 2)  THEN

                    RUN pi-Errors-CalcImpostos(INPUT 3,
                                               INPUT "Item-adic":U,
                                               INPUT decla-import-adic-itens.num-di-ems,
                                               INPUT decla-import-adic-itens.num-adic,
                                               INPUT decla-import-adic-itens.num-seq,
                                               INPUT "ERROR":U,
                                               OUTPUT l-possui-errors).
                                      
                IF (decla-import-adic-itens.val-pis-nao-tributad         = ?   AND
                    decla-import-adic-itens.val-pis-db-cr                = ?   AND
                    decla-import-adic-itens.val-pis-outras               = ?   AND
                    decla-import-adic-itens.idi-tributac-pis            <> 2)  OR

                   (decla-import-adic-itens.val-pis-nao-tributad        <= 0   AND
                    decla-import-adic-itens.val-pis-db-cr               <= 0   AND
                    decla-import-adic-itens.val-pis-outras              <= 0   AND
                    decla-import-adic-itens.idi-tributac-pis            <> 2)  THEN

                    RUN pi-Errors-CalcImpostos(INPUT 4,
                                               INPUT "Item-adic":U,
                                               INPUT decla-import-adic-itens.num-di-ems,
                                               INPUT decla-import-adic-itens.num-adic,
                                               INPUT decla-import-adic-itens.num-seq,
                                               INPUT "ERROR":U,
                                               OUTPUT l-possui-errors).

                IF (decla-import-adic-itens.val-cofins-nao-tributad      = ?   AND
                    decla-import-adic-itens.val-cofins-db-cr             = ?   AND
                    decla-import-adic-itens.val-cofins-outras            = ?   AND
                    decla-import-adic-itens.idi-tributac-cofins          <> 2)  OR

                   (decla-import-adic-itens.val-cofins-nao-tributad      <= 0   AND
                    decla-import-adic-itens.val-cofins-db-cr             <= 0   AND
                    decla-import-adic-itens.val-cofins-outras            <= 0   AND
                    decla-import-adic-itens.idi-tributac-cofins          <> 2) THEN 

                    RUN pi-Errors-CalcImpostos(INPUT 5,
                                               INPUT "Item-adic":U,
                                               INPUT decla-import-adic-itens.num-di-ems,
                                               INPUT decla-import-adic-itens.num-adic,
                                               INPUT decla-import-adic-itens.num-seq,
                                               INPUT "ERROR":U,
                                               OUTPUT l-possui-errors).
                        
            END. /* for each decla-import-adic-itens */
    
            IF (decla-import-adic.val-ii-nao-tribut            = ?   AND
                decla-import-adic.val-ii-db-cr                 = ?   AND
                decla-import-adic.val-ii-outras                = ?   AND     
                decla-import-adic.idi-tributac-impto-import    <> 2)  OR

               (decla-import-adic.val-ii-nao-tribut            <= 0   AND
                decla-import-adic.val-ii-db-cr                 <= 0   AND
                decla-import-adic.val-ii-outras                <= 0   AND 
                decla-import-adic.idi-tributac-impto-import    <> 2)  THEN

                IF decla-import-adic.idi-tributac-impto-import = 1 THEN
                    RUN pi-Errors-CalcImpostos(INPUT 1,
                                               INPUT "adicao":U,
                                               INPUT decla-import-adic.num-di-ems,
                                               INPUT decla-import-adic.num-adic,
                                               INPUT 0,
                                               INPUT "WARNING":U,
                                               OUTPUT l-possui-errors).
                ELSE
                    RUN pi-Errors-CalcImpostos(INPUT 1,
                                               INPUT "adicao":U,
                                               INPUT decla-import-adic.num-di-ems,
                                               INPUT decla-import-adic.num-adic,
                                               INPUT 0,
                                               INPUT "ERROR":U,
                                               OUTPUT l-possui-errors).

            IF (decla-import-adic.val-ipi-nao-tributad         = ?   AND
                decla-import-adic.val-ipi-db-cr                = ?   AND
                decla-import-adic.val-ipi-outras               = ?   AND
                decla-import-adic.idi-tributac-ipi             <> 2)  OR

               (decla-import-adic.val-ipi-nao-tributad         <= 0   AND
                decla-import-adic.val-ipi-db-cr                <= 0   AND
                decla-import-adic.val-ipi-outras               <= 0   AND
                decla-import-adic.log-suspens-ipi-import       =  NO  AND 
                decla-import-adic.idi-tributac-ipi             <> 2)  THEN 

                IF decla-import-adic.idi-tributac-ipi = 1 THEN
                    RUN pi-Errors-CalcImpostos(INPUT 2,
                                               INPUT "adicao":U,
                                               INPUT decla-import-adic.num-di-ems,
                                               INPUT decla-import-adic.num-adic,
                                               INPUT 0,
                                               INPUT "WARNING":U,
                                               OUTPUT l-possui-errors).
                ELSE 
                    RUN pi-Errors-CalcImpostos(INPUT 2,
                                               INPUT "adicao":U,
                                               INPUT decla-import-adic.num-di-ems,
                                               INPUT decla-import-adic.num-adic,
                                               INPUT 0,
                                               INPUT "ERROR":U,
                                               OUTPUT l-possui-errors).


            IF (decla-import-adic.val-icms-nao-tributad        = ?   AND
                decla-import-adic.val-icms-db-cr               = ?   AND
                decla-import-adic.val-icms-outras              = ?   AND
                decla-import-adic.idi-tributac-icms            <> 2)  OR

               (decla-import-adic.val-icms-nao-tributad        <= 0   AND
                decla-import-adic.val-icms-db-cr               <= 0   AND
                decla-import-adic.val-icms-outras              <= 0   AND
                decla-import-adic.idi-tributac-icms            <> 2)  THEN

                RUN pi-Errors-CalcImpostos(INPUT 3,
                                           INPUT "adicao":U,
                                           INPUT decla-import-adic.num-di-ems,
                                           INPUT decla-import-adic.num-adic,
                                           INPUT 0,
                                           INPUT "ERROR":U,
                                           OUTPUT l-possui-errors).


            IF (decla-import-adic.val-pis-nao-tributad         = ?   AND
                decla-import-adic.val-pis-db-cr                = ?   AND
                decla-import-adic.val-pis-outras               = ?   AND
                decla-import-adic.idi-tributac-pis            <> 2)  OR

               (decla-import-adic.val-pis-nao-tributad        <= 0   AND
                decla-import-adic.val-pis-db-cr               <= 0   AND
                decla-import-adic.val-pis-outras              <= 0   AND
                decla-import-adic.idi-tributac-pis            <> 2)  THEN

                RUN pi-Errors-CalcImpostos(INPUT 4,
                                           INPUT "adicao":U,
                                           INPUT decla-import-adic.num-di-ems,
                                           INPUT decla-import-adic.num-adic,
                                           INPUT 0,
                                           INPUT "ERROR":U,
                                           OUTPUT l-possui-errors).

            IF (decla-import-adic.val-cofins-nao-tributad      = ?   AND
                decla-import-adic.val-cofins-db-cr             = ?   AND
                decla-import-adic.val-cofins-outras            = ?   AND
                decla-import-adic.idi-tributac-cofins          <> 2)  OR

               (decla-import-adic.val-cofins-nao-tributad      <= 0   AND
                decla-import-adic.val-cofins-db-cr             <= 0   AND
                decla-import-adic.val-cofins-outras            <= 0   AND
                decla-import-adic.idi-tributac-cofins          <> 2 ) THEN 

                RUN pi-Errors-CalcImpostos(INPUT 5,
                                           INPUT "adicao":U,
                                           INPUT decla-import-adic.num-di-ems,
                                           INPUT decla-import-adic.num-adic,
                                           INPUT 0,
                                           INPUT "ERROR":U,
                                           OUTPUT l-possui-errors).
                    
        END. /* for each decla-import-adic */

        IF (decla-import.val-ii-nao-tribut           = ?   AND
            decla-import.val-ii-db-cr                = ?   AND
            decla-import.val-ii-outras               = ?)  OR

           (decla-import.val-ii-nao-tribut          < 0   AND
            decla-import.val-ii-db-cr               < 0   AND
            decla-import.val-ii-outras              < 0)  THEN

            RUN pi-Errors-CalcImpostos(INPUT 1,
                                       INPUT "decla-imp":U,
                                       INPUT decla-import.num-di-ems,
                                       INPUT 0,
                                       INPUT 0, 
                                       INPUT "ERROR":U,
                                       OUTPUT l-possui-errors).

           /*decla-import.val-base-ii                  = ?   OR*/
                                                                
        IF (decla-import.val-ipi-nao-tributad        = ?   AND
            decla-import.val-ipi-db-cr               = ?   AND
            decla-import.val-ipi-outras              = ?)  OR

           (decla-import.val-ipi-nao-tributad       < 0   AND
            decla-import.val-ipi-db-cr              < 0   AND
            decla-import.val-ipi-outras             < 0)  THEN

            RUN pi-Errors-CalcImpostos(INPUT 2,
                                       INPUT "decla-imp":U,
                                       INPUT decla-import.num-di-ems,
                                       INPUT 0,
                                       INPUT 0,
                                       INPUT "ERROR":U,
                                       OUTPUT l-possui-errors).

           /*decla-import.val-base-ipi                 = ?   OR*/
                                                                
        IF (decla-import.val-icms-nao-tributad       = ?   AND
            decla-import.val-icms-db-cr              = ?   AND
            decla-import.val-icms-outras             = ?)  OR

           (decla-import.val-icms-nao-tributad      < 0   AND
            decla-import.val-icms-db-cr             < 0   AND
            decla-import.val-icms-outras            < 0)  THEN

            RUN pi-Errors-CalcImpostos(INPUT 3,
                                       INPUT "decla-imp":U,
                                       INPUT decla-import.num-di-ems,
                                       INPUT 0,
                                       INPUT 0, 
                                       INPUT "ERROR":U,
                                       OUTPUT l-possui-errors).

           /*decla-import.val-base-icms                = ?   OR*/

        IF (decla-import.val-pis-nao-tributad        = ?   AND
            decla-import.val-pis-db-cr               = ?   AND
            decla-import.val-pis-outras              = ?)  OR

           (decla-import.val-pis-nao-tributad       < 0   AND
            decla-import.val-pis-db-cr              < 0   AND
            decla-import.val-pis-outras             < 0)  THEN

            RUN pi-Errors-CalcImpostos(INPUT 4,
                                       INPUT "decla-imp":U,
                                       INPUT decla-import.num-di-ems,
                                       INPUT 0,
                                       INPUT 0,
                                       INPUT "ERROR":U,
                                       OUTPUT l-possui-errors).

           /*decla-import.val-base-pis                 = ?   OR*/
                                                                      
        IF (decla-import.val-cofins-nao-tributad     = ?   AND
            decla-import.val-cofins-db-cr            = ?   AND
            decla-import.val-cofins-outras           = ?)  OR

           (decla-import.val-cofins-nao-tributad    < 0   AND
            decla-import.val-cofins-db-cr           < 0   AND
            decla-import.val-cofins-outras          < 0)  THEN

            RUN pi-Errors-CalcImpostos(INPUT 5,
                                       INPUT "decla-imp":U,
                                       INPUT decla-import.num-di-ems,
                                       INPUT 0,
                                       INPUT 0, 
                                       INPUT "ERROR":U,
                                       OUTPUT l-possui-errors).

           /*decla-import.val-base-cofins              = ?*/     

    END. /* for first decla-import */

    
    /* utilizado posicao 1 para errors e 2 para warning */
    IF l-possui-errors[1] THEN DO:
        RUN pi-atualiza-pend-imp (INPUT p-num-di-ems,
                                  INPUT p-cdd-siscomex-dts).
        RETURN "NOK":U.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaCalculoRateio DBOProgram 
PROCEDURE validaCalculoRateio :
DEF INPUT PARAM p-num-di-ems         LIKE decla-import.num-di-ems       NO-UNDO.
DEF INPUT PARAM p-cdd-siscomex-dts   LIKE decla-import.cdd-siscomex-dts NO-UNDO.

    DEF VAR         l-valor-zerado-itens AS   LOGICAL INITIAL NO      NO-UNDO.
    DEF VAR         l-valor-zerado-adic  AS   LOGICAL INITIAL NO      NO-UNDO.
    DEF VAR         l-valor-zerado-di    AS   LOGICAL INITIAL NO      NO-UNDO.
    DEF VAR         l-utz-taxa-siscomex  AS   LOGICAL INITIAL NO      NO-UNDO.
    DEF VAR         i-cod-desp           LIKE despes-decla-import.cdn-despes      NO-UNDO.
    DEF VAR         i-cod-emitente-desp  LIKE despes-decla-import.cdn-emit-despes NO-UNDO.
    DEF VAR         c-desc-msg           AS   CHARACTER                           NO-UNDO.

    FOR FIRST decla-import NO-LOCK
        WHERE decla-import.num-di-ems = p-num-di-ems
          AND decla-import.cdd-siscomex-dts = p-cdd-siscomex-dts:
        
        /* Buscar codigo da despesa de siscomex, o codigo do emitente, valor logico se usa ou n∆o despesa de siscomex */
        FIND FIRST param-imp NO-LOCK
            WHERE param-imp.cod-estabel = decla-import.cod-estab no-error.
        
        /* verificar param */
        &if '{&bf_mat_versao_ems}' >= '2.07' &then
            ASSIGN l-utz-taxa-siscomex = param-imp.log-tax-siscomex
                   i-cod-desp          = param-imp.cdn-despes-siscomex
                   i-cod-emitente-desp = param-imp.cdn-emit-siscomex.
        &else
            IF SUBSTRING(param-imp.char-1,105,1) = string(1) THEN
                ASSIGN l-utz-taxa-siscomex = YES.
            ELSE
                ASSIGN l-utz-taxa-siscomex = NO.
            ASSIGN i-cod-desp          = INTEGER(TRIM(SUBSTRING(param-imp.char-1,91,5)))
                   i-cod-emitente-desp = INTEGER(TRIM(SUBSTRING(param-imp.char-1,96,9))).
        &endif
        /* fim - Buscar codigo da despesa de siscomex, o codigo do emitente, valor logico se usa ou n∆o despesa de siscomex */

        

        FOR EACH decla-import-adic NO-LOCK
            WHERE decla-import-adic.num-di-ems = decla-import.num-di-ems
               AND decla-import-adic.cdd-siscomex-dts = decla-import.cdd-siscomex-dts:

            FOR EACH decla-import-adic-itens NO-LOCK
                WHERE decla-import-adic-itens.num-di-ems = decla-import-adic.num-di-ems
                AND   decla-import-adic-itens.num-adic   = decla-import-adic.num-adic
                AND   decla-import-adic-itens.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts:

                /* se utiliza despesa de siscomex, posiciona o registro */
                IF l-utz-taxa-siscomex THEN
                    FIND FIRST despes-adic-itens NO-LOCK
                        WHERE despes-adic-itens.num-di-ems      = decla-import-adic-itens.num-di-ems
                        AND   despes-adic-itens.num-adic        = decla-import-adic-itens.num-adic
                        AND   despes-adic-itens.num-seq         = decla-import-adic-itens.num-seq
                        AND   despes-adic-itens.cdn-despes      = i-cod-desp 
                        AND   despes-adic-itens.cdn-emit-despes = i-cod-emitente-desp 
                        AND   despes-adic-itens.cdd-siscomex-dts = decla-import-adic-itens.cdd-siscomex-dts NO-ERROR.


                IF decla-import-adic-itens.val-vmcv = ?  OR
                   decla-import-adic-itens.val-vmcv <= 0 OR

                   decla-import-adic-itens.val-vmle = ?  OR
                   decla-import-adic-itens.val-vmle <= 0 OR

                   decla-import-adic-itens.val-vmld = ?  OR
                   decla-import-adic-itens.val-vmld <= 0 OR

                   decla-import-adic-itens.val-acresc = ? OR
                   decla-import-adic-itens.val-acresc < 0 OR
                   decla-import-adic-itens.val-acresc-me[1] = ? OR
                   decla-import-adic-itens.val-acresc-me[1] < 0 OR
                   decla-import-adic-itens.val-acresc-me[2] = ? OR
                   decla-import-adic-itens.val-acresc-me[2] < 0 OR
                    
                   decla-import-adic-itens.val-frete = ? OR
                   decla-import-adic-itens.val-frete < 0 OR
                   decla-import-adic-itens.val-frete-me[1] = ? OR
                   decla-import-adic-itens.val-frete-me[1] < 0 OR
                   decla-import-adic-itens.val-frete-me[2] = ? OR
                   decla-import-adic-itens.val-frete-me[2] < 0 OR
                    
                   decla-import-adic-itens.val-seguro = ? OR
                   decla-import-adic-itens.val-seguro < 0 OR
                   decla-import-adic-itens.val-seguro-me[1] = ? OR
                   decla-import-adic-itens.val-seguro-me[1] < 0 OR
                   decla-import-adic-itens.val-seguro-me[2] = ? OR
                   decla-import-adic-itens.val-seguro-me[2] < 0 OR
                    
                   (AVAIL despes-adic-itens
                    AND   l-utz-taxa-siscomex
                    AND   despes-adic-itens.val-despes < 0)
                THEN DO:
                    ASSIGN l-valor-zerado-itens = YES.
                END. /* if decla-import-adic-itens.val-vmcv = ? */
            END. /* FOR EACH decla-import-adic-itens */


            IF l-utz-taxa-siscomex THEN
                FIND FIRST despes-adic NO-LOCK
                    WHERE despes-adic.num-di-ems      = decla-import-adic.num-di-ems
                    AND   despes-adic.num-adic        = decla-import-adic.num-adic
                    AND   despes-adic.cdn-despes      = i-cod-desp 
                    AND   despes-adic.cdn-emit-despes = i-cod-emitente-desp 
                    AND   despes-adic.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts NO-ERROR.


            IF decla-import-adic.val-vmcv = ?  OR
               decla-import-adic.val-vmcv <= 0 OR

               decla-import-adic.val-vmle = ?  OR
               decla-import-adic.val-vmle <= 0 OR

               decla-import-adic.val-vmld = ?  OR
               decla-import-adic.val-vmld <= 0 OR

               decla-import-adic.val-acresc = ? OR
               decla-import-adic.val-acresc < 0 OR
               decla-import-adic.val-acresc-me[1] = ? OR
               decla-import-adic.val-acresc-me[1] < 0 OR
               decla-import-adic.val-acresc-me[2] = ? OR
               decla-import-adic.val-acresc-me[2] < 0 OR
                
               decla-import-adic.val-frete = ? OR
               decla-import-adic.val-frete < 0 OR
               decla-import-adic.val-frete-me[1] = ? OR
               decla-import-adic.val-frete-me[1] < 0 OR
               decla-import-adic.val-frete-me[2] = ? OR
               decla-import-adic.val-frete-me[2] < 0 OR
                 
               decla-import-adic.val-seguro = ? OR
               decla-import-adic.val-seguro < 0 OR
               decla-import-adic.val-seguro-me[1] = ? OR
               decla-import-adic.val-seguro-me[1] < 0 OR
               decla-import-adic.val-seguro-me[2] = ? OR
               decla-import-adic.val-seguro-me[2] < 0 OR

                (AVAIL despes-adic
                AND   l-utz-taxa-siscomex 
                AND   despes-adic.val-despes < 0)
            THEN DO:
                ASSIGN l-valor-zerado-adic = YES.
            END. /* if decla-import-adic-itens.val-vmcv = ? */
        END. /* FOR EACH decla-import-adic */

        IF l-utz-taxa-siscomex THEN
            FIND FIRST despes-decla-import NO-LOCK
                WHERE despes-decla-import.num-di-ems      = decla-import.num-di-ems
                AND   despes-decla-import.cdn-despes      = i-cod-desp 
                AND   despes-decla-import.cdn-emit-despes = i-cod-emitente-desp 
                AND   despes-decla-import.cdd-siscomex-dts = decla-import.cdd-siscomex-dts NO-ERROR.


        IF decla-import.val-vmcv = ?  OR
           decla-import.val-vmcv <= 0 OR

           decla-import.val-vmle = ?  OR
           decla-import.val-vmle <= 0 OR

           decla-import.val-vmld = ?  OR
           decla-import.val-vmld <= 0 OR

           decla-import.val-acresc = ? OR
           decla-import.val-acresc < 0 OR
           decla-import.val-acresc-me[1] = ? OR
           decla-import.val-acresc-me[1] < 0 OR
           decla-import.val-acresc-me[2] = ? OR
           decla-import.val-acresc-me[2] < 0 OR
           
           decla-import.val-frete = ? OR
           decla-import.val-frete < 0 OR
           decla-import.val-frete-me[1] = ? OR
           decla-import.val-frete-me[1] < 0 OR
           decla-import.val-frete-me[2] = ? OR
           decla-import.val-frete-me[2] < 0 OR
           
           decla-import.val-seguro = ? OR
           decla-import.val-seguro < 0 OR
           decla-import.val-seguro-me[1] = ? OR
           decla-import.val-seguro-me[1] < 0 OR
           decla-import.val-seguro-me[2] = ? OR
           decla-import.val-seguro-me[2] < 0 OR
            
           (AVAIL despes-decla-import
            AND l-utz-taxa-siscomex 
            AND despes-decla-import.val-despes < 0)
        THEN DO:
            ASSIGN l-valor-zerado-DI = YES.
        END. /* if */


    END. /* for first decla-import */


    IF l-valor-zerado-itens THEN DO:
        
        FIND LAST RowErrors NO-LOCK NO-ERROR.
        IF AVAIL RowErrors THEN
            ASSIGN iErro = RowErrors.errorSequence + 1.
        ELSE 
            ASSIGN iErro = 1.
        
        CREATE RowErrors.
        
        {utp/ut-liter.i "Existem_valores_que_n∆o_foram_calculados_corretamente_nos_itens_da_adiá∆o" *}
        ASSIGN c-desc-msg = TRIM(RETURN-VALUE).
        {utp/ut-liter.i "Existem_valores_que_n∆o_foram_calculados_corretamente_nos_itens_da_adiá∆o._Efetuar_a_verificaá∆o_das_parametrizaá‰es_utilizadas_para_c†lculo_do_rateio" *}
        
        ASSIGN RowErrors.ErrorNumber      = 17006
               RowErrors.ErrorDescription = c-desc-msg + "."
               RowErrors.ErrorHelp        = TRIM(RETURN-VALUE) + "."
               RowErrors.ErrorType        = "EMS":U
               RowErrors.ErrorSubType     = "ERROR":U
               RowErrors.ErrorSequence    = iErro. 
    END.

    IF l-valor-zerado-adic THEN DO:

        FIND LAST RowErrors NO-LOCK NO-ERROR.
        IF AVAIL RowErrors THEN
            ASSIGN iErro = RowErrors.errorSequence + 1.
        ELSE 
            ASSIGN iErro = 1.

        CREATE RowErrors.
        
        {utp/ut-liter.i "Existem_valores_que_n∆o_foram_calculados_corretamente_nas_adiá‰es" *}
        ASSIGN c-desc-msg = TRIM(RETURN-VALUE).
        {utp/ut-liter.i "Existem_valores_que_n∆o_foram_calculados_corretamente_nas_adiá‰es._Efetuar_a_verificaá∆o_das_parametrizaá‰es_utilizadas_para_c†lculo_do_rateio" *}
        
        ASSIGN RowErrors.ErrorNumber      = 17006
               RowErrors.ErrorDescription = c-desc-msg + "."
               RowErrors.ErrorHelp        = TRIM(RETURN-VALUE) + "."
               RowErrors.ErrorType        = "EMS":U
               RowErrors.ErrorSubType     = "ERROR":U
               RowErrors.ErrorSequence    = iErro. 
    END.

    IF l-valor-zerado-di THEN DO:

        FIND LAST RowErrors NO-LOCK NO-ERROR.
        IF AVAIL RowErrors THEN
            ASSIGN iErro = RowErrors.errorSequence + 1.
        ELSE 
            ASSIGN iErro = 1.
        
        CREATE RowErrors.
        
        {utp/ut-liter.i "Existem_valores_que_n∆o_foram_calculados_corretamente_na_declaraá∆o_de_importaá∆o" *}
        ASSIGN c-desc-msg = TRIM(RETURN-VALUE).
        {utp/ut-liter.i "Existem_valores_que_n∆o_foram_calculados_corretamente_na_declaraá∆o_de_importaá∆o._Efetuar_a_verificaá∆o_das_parametrizaá‰es_utilizadas_para_c†lculo_do_rateio" *}
        
        ASSIGN RowErrors.ErrorNumber      = 17006
               RowErrors.ErrorDescription = c-desc-msg + "."
               RowErrors.ErrorHelp        = TRIM(RETURN-VALUE) + "."
               RowErrors.ErrorType        = "EMS":U
               RowErrors.ErrorSubType     = "ERROR":U
               RowErrors.ErrorSequence    = iErro. 
    END.

    IF CAN-FIND(FIRST RowErrors 
                WHERE RowErrors.ErrorType     <> "INTERNAL":U
                AND   RowErrors.ErrorSubType  = "ERROR":U) OR
       l-valor-zerado-itens OR 
       l-valor-zerado-adic  OR 
       l-valor-zerado-di    THEN DO:
        RUN pi-atualiza-pend-rat (INPUT p-num-di-ems,
                                  INPUT p-cdd-siscomex-dts).
        RETURN "NOK":U.
    END.
    
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
    
    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAtualizaNBS DBOProgram 
PROCEDURE piAtualizaNBS :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var c-nbs as char no-undo.
    
    /* 
    ** Cotaá∆o Item - NBS
    */    
    IF CAN-FIND(FIRST natur-oper NO-LOCK
                WHERE natur-oper.nat-operacao = tt-item-doc-est.nat-operacao
                AND  (natur-oper.cod-model-nf-eletro = "56" OR natur-oper.log-nfse-nacional)) THEN DO:
        
        find first item no-lock
            where item.it-codigo = tt-item-doc-est.it-codigo no-error.
        assign c-nbs = SUBSTRING(item.char-1,342,20).

        for first cotacao-item no-lock
            where cotacao-item.numero-ordem = tt-item-doc-est.numero-ordem
              and cotacao-item.cod-emitente = tt-item-doc-est.cod-emitente
              and cotacao-item.it-codigo    = tt-item-doc-est.it-codigo
              and cotacao-item.cot-aprovada = yes:
              IF SUBSTRING(cotacao-item.char-1,100,20) <> "" THEN 
                  assign c-nbs = SUBSTRING(cotacao-item.char-1,100,20).
        end.

        if  c-nbs <> "" then do:
            ASSIGN OVERLAY(tt-item-doc-est.char-2,956,20) = trim(c-nbs).
        end.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

