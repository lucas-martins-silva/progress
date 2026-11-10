/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0710RP 2.00.00.026 } /*** 010026 ***/
                            
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0710rp MIM}
&ENDIF                  

{include/i_fnctrad.i}
/******************************************************************************
**
**       PROGRAMA: IM0710RP.P
**
**       VERSAO..: 2.04.000 - Vander Sposito
**
******************************************************************************/
/************************ Definiá∆o dos parÉmetros ***************************/
/* Parameters Definitions ---                                           */

{utp/ut-glob.i}

{cdp/cd4300.i3}

{cdp/cdcfgdis.i} /*  definiá∆o de prÇ-processadores distribuiá∆o */
{cdp/cdcfgmat.i} /*  definiá∆o de prÇ-processadores materiais */
{cdp/cdcfgcex.i}

{imp/im0100.i1}

/****************************** Temp Tables **********************************/
DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino               AS   INTEGER
    FIELD arquivo               AS   CHAR FORMAT "x(35)"
    FIELD arq-entrada           AS   CHAR FORMAT "x(35)"
    FIELD arq-destino           AS   CHAR FORMAT "x(35)"
    FIELD usuario               AS   CHAR FORMAT "x(12)"
    FIELD data-exec             AS   DATE
    FIELD hora-exec             AS   INTEGER
    FIELD estab-ini             LIKE estabelec.cod-estabel 
    FIELD embarque              LIKE embarque-imp.embarque
    FIELD via-transporte        AS   INTEGER 
    FIELD tipo-decl             AS   INTEGER
    FIELD nat-operacao          LIKE natur-oper.nat-operacao
    FIELD tipo                  AS   INTEGER
    FIELD diretorio             AS   CHAR FORMAT "x(60)".

def temp-table tt-raw-digita
   field raw-digita      as raw.

def input param raw-param as raw no-undo.
def input param table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

DEFINE TEMP-TABLE tt-header NO-UNDO
    FIELD tp-registro           AS INT  FORMAT "9"
    FIELD arquivo               AS CHAR FORMAT "x(30)"
&IF "{&mguni_version}" >= "2.071" &THEN
    FIELD cod-estabel           AS CHAR format "x(05)"
&ELSE
    FIELD cod-estabel           AS CHAR FORMAT "x(03)"
&ENDIF
    FIELD nome                  AS CHAR FORMAT "x(40)"
    FIELD embarque              LIKE embarque-imp.embarque
    FIELD dt-geracao            AS DATE
    FIELD hora-geracao          AS CHAR FORMAT "x(06)".

DEFINE TEMP-TABLE tt-cabecalho NO-UNDO
    FIELD tp-registro           AS INT  FORMAT "9"
    FIELD nr-ident-usuario      AS CHAR FORMAT "x(16)"
    FIELD cd-tipo-declaracao    AS INT  FORMAT ">9"
    FIELD cd-tipo-importador    AS INT  FORMAT "9"
    FIELD tipo-importador       AS CHAR FORMAT "x(15)"
    FIELD nr-importador         AS CHAR FORMAT "x(14)"
    FIELD cd-pais-importador    AS INT  FORMAT ">>9"
    FIELD nr-cpf-repres-legal   AS CHAR FORMAT "x(19)"
    FIELD cd-via-transp-carg    AS INT  FORMAT ">9"
    FIELD nm-transportador      AS CHAR FORMAT "x(60)"
    FIELD nr-docto-carga        AS CHAR FORMAT "x(18)"
    FIELD nr-docto-carga-master AS CHAR FORMAT "x(18)"
    FIELD nm-local-embarque     AS CHAR FORMAT "x(50)"
    FIELD dt-embarque           AS DATE
    FIELD nr-veiculo-transp     AS CHAR FORMAT "x(15)"
    FIELD nm-veiculo-transp     AS CHAR FORMAT "x(30)"
    FIELD cd-tipo-ag-carga      AS INT  FORMAT "9"
    FIELD nr-agente-carga       AS CHAR FORMAT "x(14)"
    FIELD pb-carga              AS DEC  FORMAT ">>>>,>>9.9999999999" /*LIKE item.peso-bruto  */
    FIELD pl-carga              AS DEC  FORMAT ">>>>,>>9.9999999999" /*LIKE item.peso-liquido*/
    FIELD cd-tipo-consig        AS INT  FORMAT "9"
    FIELD nr-consignatario      AS CHAR FORMAT "x(14)"
    FIELD nm-consignatario      AS CHAR FORMAT "x(30)"
    FIELD cd-moeda-mle          AS INT  FORMAT ">>9"
    FIELD desc-moeda-mle        LIKE moeda.descricao
    FIELD vl-tot-mle-mn         AS DEC  FORMAT ">>>>>>>>>>>>9.99"
    FIELD cd-moeda-frete        AS INT  FORMAT ">>9"
    FIELD desc-mo-frete         LIKE moeda.descricao
    FIELD vl-tot-frt-prepaid    AS DEC  FORMAT ">>>>>>>>>>>>9.99"
    FIELD vl-tot-frt-collect    AS DEC  FORMAT ">>>>>>>>>>>>9.99"
    FIELD vl-frete-tnac-mneg    AS DEC  FORMAT ">>>>>>>>>>>>9.99"
    FIELD cd-moeda-seguro       AS INT  FORMAT ">>>9"
    FIELD desc-mo-seguro        LIKE moeda.descricao 
    FIELD vl-tot-seguro-mneg    AS DEC  FORMAT ">>>>>>>>>>>>9.99"
    FIELD fl-total-seg-mn       AS DEC  FORMAT ">>>>>>>>>>>>9.99".

DEFINE TEMP-TABLE tt-adicao NO-UNDO
    FIELD tp-registro           AS INT  FORMAT "9"
    FIELD nr-ident-usuario      AS CHAR FORMAT "x(16)"
    FIELD nr-adicao-usuario     AS INT  FORMAT ">>9"
    FIELD cd-ausencia-fabrica   AS INT  FORMAT "9"
    FIELD nm-forn-estr          AS CHAR FORMAT "x(60)"
    FIELD ed-logr-forn-estr     AS CHAR FORMAT "x(40)"
    FIELD ed-cidad-forn-estr    AS CHAR FORMAT "x(25)"
    FIELD ed-estad-forn-estr    AS CHAR FORMAT "x(25)"
    FIELD nm-fabricante-merc    AS CHAR FORMAT "x(60)"
    FIELD ed-logr-fabric        AS CHAR FORMAT "x(40)"
    FIELD ed-cidad-fabric       AS CHAR FORMAT "x(25)"
    FIELD ed-estado-fabric      AS CHAR FORMAT "x(25)"
    FIELD cd-mercadoria-ncm     AS CHAR FORMAT "x(10)"
    FIELD it-codigo             LIKE ITEM.it-codigo
    FIELD cd-merc-nbm-sh        AS CHAR FORMAT "x(10)"
    FIELD cd-merc-naladi-sh     AS DEC  FORMAT ">>>>>>>>>9"
    FIELD cd-merc-naladi-ncc    AS DEC  FORMAT ">>>>>>>>>9"
    FIELD qt-un-estatistica     AS DEC  FORMAT ">>>>>>>>9.99"
    FIELD pl-mercadoria         AS DEC  FORMAT ">>>>>>>>>9.99999"
    FIELD cd-moeda-negociada    AS INT  FORMAT ">>9"
    FIELD cd-incoterms-venda    AS CHAR FORMAT "x(03)"
    FIELD nm-loc-cond-venda     AS CHAR FORMAT "x(60)"
    FIELD cd-tipo-agente-imp    AS INT  FORMAT "9"
    FIELD nr-agente-imp         AS CHAR FORMAT "x(18)"
    FIELD desc-agente           AS CHAR FORMAT "x(15)"
    FIELD cd-banc-agente-imp    AS INT  FORMAT ">>>>9"
    FIELD cd-agenc-agente-imp   AS CHAR FORMAT "x(08)"
    FIELD qt-parc-financ-360    AS INT  FORMAT ">>9"
    FIELD qt-period-pgto-360    AS INT  FORMAT ">>9"
    FIELD vl-tot-financ-360     AS DEC  FORMAT ">>>>>>>>>>>>9.99"
    FIELD nr-rof                AS CHAR FORMAT "x(08)".

DEFINE TEMP-TABLE tt-parcelas NO-UNDO
    FIELD tp-registro           AS INT  FORMAT "9"
    FIELD nr-ident-usuario      AS CHAR FORMAT "x(16)"
    FIELD nr-adicao-usuario     AS INT  FORMAT ">>9"
    FIELD dt-prev-pgto-360      AS DATE
    FIELD vl-prev-pgto-360      AS DEC  FORMAT ">>>>>>>>>>>>9.99".

DEFINE TEMP-TABLE tt-tributos NO-UNDO
    FIELD tp-registro           AS INT  FORMAT "9"
    FIELD nr-ident-usuario      AS CHAR FORMAT "x(16)"
    FIELD nr-adicao-usuario     AS INT  FORMAT ">>9"
    FIELD cd-receita-imposto    AS INT  FORMAT ">>>9"
    FIELD cd-tipo-benef-ipi     AS INT  FORMAT "9"
    FIELD pc-aliq-norm-adval    AS DEC  FORMAT ">>9.99"
    FIELD pc-aliq-reduzida      AS DEC  FORMAT ">>9.99"
    FIELD trib                  AS CHAR FORMAT "x(04)".

DEFINE TEMP-TABLE tt-descricao NO-UNDO
    FIELD tp-registro           AS INT  FORMAT "9"
    FIELD nr-ident-usuario      AS CHAR FORMAT "x(16)"
    FIELD nr-adicao-usuario     AS INT  FORMAT ">>9"
    FIELD seq-item              AS INT  FORMAT ">>>9"
    FIELD qt-merc-un-comerc     AS DEC  FORMAT ">>>>>>>>9.99"
    FIELD vl-unid-cond-venda    AS DEC  FORMAT ">>>>>>>>>>>>9.99".

DEFINE TEMP-TABLE tt-mercadoria NO-UNDO
    FIELD tp-registro           AS INT  FORMAT "9"
    FIELD nr-ident-usuario      AS CHAR FORMAT "x(16)"
    FIELD nr-adicao-usuario     AS INT  FORMAT ">>9"
    FIELD cd-mercadoria         AS CHAR FORMAT "x(16)"
    FIELD qt-merc-un-comerc     AS DEC  FORMAT ">>>>>>>>9.99"
    FIELD nm-un-medid-comer     AS CHAR FORMAT "x(02)"
    FIELD vl-unid-cond-venda    AS DEC  FORMAT ">>>>>>>>>>>>9.99"
    FIELD vl-unid-loc-bem       AS DEC  FORMAT ">>>>>>>>>>9.99"
    FIELD nr-adicao             AS INT  FORMAT ">>>9"
    FIELD seq-item              AS INT  FORMAT ">>>9".

DEFINE TEMP-TABLE tt-acrescimos NO-UNDO
    FIELD nr-ident-usuario      AS CHAR FORMAT "x(16)"
    FIELD nr-adicao-usuario     AS INT  FORMAT ">>9"
    FIELD denominacao           AS CHAR FORMAT "x(20)"
    FIELD moeda                 AS INT  FORMAT ">>9"
    FIELD vl-moeda              AS DEC  FORMAT ">>>>,>>>,>>9.99"
    FIELD vl-real               AS DEC  FORMAT ">>>>,>>>,>>9.99".

DEFINE TEMP-TABLE tt-deducoes NO-UNDO
    FIELD nr-ident-usuario      AS CHAR FORMAT "x(16)"
    FIELD nr-adicao-usuario     AS INT  FORMAT ">>9"
    FIELD denominacao           AS CHAR FORMAT "x(20)"
    FIELD moeda                 AS INT  FORMAT ">>9"
    FIELD vl-moeda              AS DEC  FORMAT ">>>>,>>>,>>9.99"
    FIELD vl-real               AS DEC  FORMAT ">>>>,>>>,>>9.99".

/*************************** Vari†veis Locais ********************************/

def var c-parametro            as   char format "x(14)":U     no-undo.
def var c-impressao            as   char format "x(12)":U     no-undo.
def var c-destino              as   char format "x(10)":U     no-undo.

DEF VAR h-acomp                AS   HANDLE                    NO-UNDO.
DEF VAR i-reg-lido             as   INTEGER                   NO-UNDO.
DEF VAR i-agencia              AS   INTEGER FORMAT ">>>9":U   NO-UNDO.
DEF VAR c-param                AS   CHAR    FORMAT "x(02)":U  NO-UNDO.
DEF VAR i                      AS   INTEGER                   NO-UNDO.
DEF VAR l-preco-bruto          AS   LOGICAL                   NO-UNDO.
DEF VAR de-valor-ipi           LIKE cotacao-item.pre-unit-for NO-UNDO.
DEF VAR de-val-orig            LIKE cotacao-item.pre-unit-for NO-UNDO.
DEF VAR de-preco-unit          LIKE cotacao-item.pre-unit-for NO-UNDO.
DEF VAR de-preco-unit-conv     LIKE cotacao-item.pre-unit-for NO-UNDO.
DEF VAR de-preco-total         LIKE cotacao-item.pre-unit-for NO-UNDO.
DEF VAR de-tot-ger             LIKE cotacao-item.pre-unit-for NO-UNDO.
DEF VAR de-tot-desp            LIKE cotacao-item.pre-unit-for NO-UNDO.
DEF VAR de-tot-desp-frete-emb  LIKE cotacao-item.pre-unit-for NO-UNDO.
DEF VAR de-tot-desp-frete-nac  LIKE cotacao-item.pre-unit-for NO-UNDO.
DEF VAR de-tot-vl-moeda        LIKE cotacao-item.pre-unit-for NO-UNDO.
DEF VAR c-ordem                LIKE ordem-compra.numero-ordem NO-UNDO.
DEF VAR de-val-desp            LIKE desp-embarque.val-desp    NO-UNDO.
DEF VAR de-val-desp-conv       LIKE desp-embarque.val-desp    NO-UNDO.

DEF VAR c-nome                 LIKE estabelec.nome            NO-UNDO.
DEF VAR c-desc-via             AS   CHAR FORMAT "x(15)"       NO-UNDO.
DEF VAR c-descricao-moeda      AS   CHAR FORMAT "x(20)"       NO-UNDO.
DEF VAR c-desc-ag-carga        AS   CHAR FORMAT "x(15)"       NO-UNDO.
DEF VAR c-desc-cons            AS   CHAR FORMAT "x(15)"       NO-UNDO.
DEF VAR c-desc-moeda           AS   CHAR FORMAT "x(10)"       NO-UNDO.
DEF VAR c-desc-mo-frete        AS   CHAR FORMAT "x(10)"       NO-UNDO.
DEF VAR c-vl-moeda             AS   CHAR FORMAT "x(12)"       NO-UNDO.
DEF VAR c-desc-mo-seguro       AS   CHAR FORMAT "x(10)"       NO-UNDO.
                                                         
/* Vari†veis de cabecalho */                             
DEF VAR c-nome-importador      AS   CHAR FORMAT "x(30)"       NO-UNDO.
DEF VAR c-importador           AS   CHAR FORMAT "x(11)"       NO-UNDO.    
DEF VAR c-transporte           AS   CHAR FORMAT "x(11)"       NO-UNDO.    
DEF VAR c-conhec-transp        AS   CHAR FORMAT "x(20)"       NO-UNDO.
DEF VAR c-estabel              AS   CHAR FORMAT "x(15)"       NO-UNDO.       
DEF VAR c-via-transp           AS   CHAR FORMAT "x(14)"       NO-UNDO.    
DEF VAR c-identificacao        AS   CHAR FORMAT "x(14)"       NO-UNDO.
DEF VAR c-embarque             AS   CHAR FORMAT "x(09)"       NO-UNDO.      
DEF VAR c-nm-transp            AS   CHAR FORMAT "x(19)"       NO-UNDO.     
DEF VAR c-ident-master         AS   CHAR FORMAT "x(20)"       NO-UNDO.  
DEF VAR c-tipo-importador      AS   CHAR FORMAT "x(16)"       NO-UNDO.
DEF VAR c-placa                AS   CHAR FORMAT "x(06)"       NO-UNDO.         
DEF VAR c-local-embarque       AS   CHAR FORMAT "x(15)"       NO-UNDO.
DEF VAR c-cgc-importador       AS   CHAR FORMAT "x(15)"       NO-UNDO.
DEF VAR c-embarcacao           AS   CHAR FORMAT "x(11)"       NO-UNDO.    
DEF VAR c-dt-embarque          AS   CHAR FORMAT "x(13)"       NO-UNDO.   
DEF VAR c-pais                 AS   CHAR FORMAT "x(06)"       NO-UNDO.          
DEF VAR c-carga                AS   CHAR FORMAT "x(08)"       NO-UNDO.         
DEF VAR c-carga-2              AS   CHAR FORMAT "x(09)"       NO-UNDO.       
DEF VAR c-frete-total          AS   CHAR FORMAT "x(12)"       NO-UNDO.   
DEF VAR c-tipo-agente          AS   CHAR FORMAT "x(14)"       NO-UNDO.   
DEF VAR c-tipo-consig          AS   CHAR FORMAT "x(19)"       NO-UNDO.   
DEF VAR c-moeda-frete          AS   CHAR FORMAT "x(12)"       NO-UNDO.   
DEF VAR c-agente-transp        AS   CHAR FORMAT "x(20)"       NO-UNDO.  
DEF VAR c-id-consig            AS   CHAR FORMAT "x(17)"       NO-UNDO.     
DEF VAR c-prepaid              AS   CHAR FORMAT "x(08)"       NO-UNDO.       
DEF VAR c-peso-liq             AS   CHAR FORMAT "x(13)"       NO-UNDO.      
DEF VAR c-nm-consig            AS   CHAR FORMAT "x(19)"       NO-UNDO.     
DEF VAR c-collect              AS   CHAR FORMAT "x(08)"       NO-UNDO.       
DEF VAR c-peso-bruto           AS   CHAR FORMAT "x(11)"       NO-UNDO.    
DEF VAR c-moeda-1              AS   CHAR FORMAT "x(06)"       NO-UNDO.         
DEF VAR c-territorio           AS   CHAR FORMAT "x(20)"       NO-UNDO.    
DEF VAR c-cpf-repres           AS   CHAR FORMAT "x(17)"       NO-UNDO.    
DEF VAR c-vl-tot-merc          AS   CHAR FORMAT "x(20)"       NO-UNDO.   
DEF VAR c-seguro               AS   CHAR FORMAT "x(07)"       NO-UNDO.        
DEF VAR c-moeda-2              AS   CHAR FORMAT "x(06)"       NO-UNDO.         
DEF VAR c-valor-moeda          AS   CHAR FORMAT "x(12)"       NO-UNDO.
DEF VAR l-erro                 AS   LOGICAL                   NO-UNDO.
DEF VAR c-formato-cpf          AS   CHAR FORMAT "x(18)"       NO-UNDO.


DEF VAR c-cod-incoterm         LIKE processo-imp.cod-incoterm NO-UNDO.
DEF VAR i-cod-pto-contr        LIKE pto-contr.cod-pto-contr   NO-UNDO.
DEF VAR i-cod-fabricante       AS   INTEGER                   NO-UNDO.
DEF VAR c-class-fiscal         LIKE classif-fisc.class-fiscal NO-UNDO.

/* Vari†veis de Adicao */
DEF VAR c-cd-mercadoria-ncm    AS   CHAR FORMAT "x(12)"       NO-UNDO.
DEF VAR c-cd-merc-nbm-sh       AS   CHAR FORMAT "x(12)"       NO-UNDO.
DEF VAR c-cd-merc-naladi-sh    AS   CHAR FORMAT "x(10)"       NO-UNDO.
DEF VAR c-cd-merc-naladi-ncc   AS   CHAR FORMAT "x(13)"       NO-UNDO.
DEF VAR c-cd-moeda-negociada   AS   CHAR FORMAT "x(11)"       NO-UNDO.
DEF VAR c-cd-incoterms-venda   AS   CHAR FORMAT "x(10)"       NO-UNDO.
DEF VAR c-pl-mercadoria        AS   CHAR FORMAT "x(18)"       NO-UNDO.
DEF VAR c-qt-parc-financ-360   AS   CHAR FORMAT "x(09)"       NO-UNDO.
DEF VAR c-qt-period-pgto-360   AS   CHAR FORMAT "x(15)"       NO-UNDO.
DEF VAR c-nr-rof               AS   CHAR FORMAT "x(10)"       NO-UNDO.
DEF VAR c-vl-tot-financ-360    AS   CHAR FORMAT "x(15)"       NO-UNDO.
DEF VAR c-qt-un-estatistica    AS   CHAR FORMAT "x(20)"       NO-UNDO.
DEF VAR c-nm-loc-cond-venda    AS   CHAR FORMAT "x(60)"       NO-UNDO.

/* variavel total quantidade */
DEF VAR de-quantidade          LIKE ITEM.peso-liquido         NO-UNDO.

DEF VAR c-exportador           AS   CHAR FORMAT "x(10)"       NO-UNDO.
DEF VAR c-fabricante           AS   CHAR FORMAT "x(10)"       NO-UNDO.
DEF VAR c-agente               AS   CHAR FORMAT "x(06)"       NO-UNDO.
DEF VAR c-nm-forn-estr         AS   CHAR FORMAT "x(15)"       NO-UNDO.
DEF VAR c-nm-fabricante-merc   AS   CHAR FORMAT "x(15)"       NO-UNDO.
DEF VAR c-cd-tipo-agente-imp   AS   CHAR FORMAT "x(09)"       NO-UNDO.
DEF VAR c-ed-logr-forn-estr    AS   CHAR FORMAT "x(08)"       NO-UNDO.
DEF VAR c-ed-logr-fabric       AS   CHAR FORMAT "x(08)"       NO-UNDO.
DEF VAR c-nr-agente-imp        AS   CHAR FORMAT "x(09)"       NO-UNDO.
DEF VAR c-ed-cidad-forn-estr   AS   CHAR FORMAT "x(06)"       NO-UNDO.
DEF VAR c-ed-cidad-fabric      AS   CHAR FORMAT "x(06)"       NO-UNDO.
DEF VAR c-cd-banc-agente-imp   AS   CHAR FORMAT "x(05)"       NO-UNDO.
DEF VAR c-ed-estad-forn-estr   AS   CHAR FORMAT "x(06)"       NO-UNDO.
DEF VAR c-ed-estado-fabric     AS   CHAR FORMAT "x(06)"       NO-UNDO.
DEF VAR c-cd-agenc-agente-imp  AS   CHAR FORMAT "x(07)"       NO-UNDO.

/* Vari†veis de acrescimos */
DEF VAR c-acr-descricao        AS CHAR FORMAT "x(20)" NO-UNDO.
DEF VAR c-acr-denominacao      AS CHAR FORMAT "x(11)" NO-UNDO.
DEF VAR c-acr-moeda            AS CHAR FORMAT "x(05)" NO-UNDO.
DEF VAR c-acr-vl-moeda         AS CHAR FORMAT "x(14)" NO-UNDO.
DEF VAR c-acr-vl-real          AS CHAR FORMAT "x(13)" NO-UNDO.

/* Vari†veis de deduá‰es */
DEF VAR c-ded-descricao        AS CHAR FORMAT "x(20)" NO-UNDO.
DEF VAR c-ded-denominacao      AS CHAR FORMAT "x(11)" NO-UNDO.
DEF VAR c-ded-moeda            AS CHAR FORMAT "x(05)" NO-UNDO.
DEF VAR c-ded-vl-moeda         AS CHAR FORMAT "x(14)" NO-UNDO.
DEF VAR c-ded-vl-real          AS CHAR FORMAT "x(13)" NO-UNDO.

/* Vari†veis de tributos */
DEF VAR c-receita              AS CHAR FORMAT "x(07)" NO-UNDO.
DEF VAR c-tributos             AS CHAR FORMAT "x(10)" NO-UNDO.
DEF VAR c-cd-tipo-benef-ipi-1  AS CHAR FORMAT "x(09)" NO-UNDO.
DEF VAR c-pc-aliq-norm-adval-1 AS CHAR FORMAT "x(10)" NO-UNDO.
DEF VAR c-pc-aliq-reduzida     AS CHAR FORMAT "x(10)" NO-UNDO.


/* Vari†veis de parcelas */
DEF VAR c-dt-prev-pgto-360     AS CHAR FORMAT "x(09)" NO-UNDO.
DEF VAR c-vl-prev-pgto-360     AS CHAR FORMAT "x(14)" NO-UNDO.

/* Vari†veis de mercadorias */
DEF VAR c-cd-mercadoria        AS CHAR FORMAT "x(04)" NO-UNDO.
DEF VAR c-qt-merc-un-comerc    AS CHAR FORMAT "x(12)" NO-UNDO.
DEF VAR c-nm-un-medid-comer    AS CHAR FORMAT "x(02)" NO-UNDO.
DEF VAR c-vl-unid-cond-venda   AS CHAR FORMAT "x(11)" NO-UNDO.
DEF VAR c-mercadoria           AS CHAR FORMAT "x(10)" NO-UNDO.
DEF VAR c-nr-adicao            AS CHAR FORMAT "x(09)" NO-UNDO.
DEF VAR c-seq-item-merc        AS CHAR FORMAT "x(04)" NO-UNDO.
DEF VAR i-soma-total           LIKE tt-mercadoria.qt-merc-un-comerc.

/*Vari†veis de descriá∆o*/
DEF VAR c-seq-item             AS CHAR FORMAT "x(11)" NO-UNDO.

DEF VAR i-ident-fabricante  LIKE emitente.cod-emitente NO-UNDO.
DEF VAR flag-moeda          AS LOG INITIAL NO NO-UNDO.
DEF VAR sequencia           AS INT INITIAL 0 NO-UNDO.
DEF VAR i-sequencia         AS INT INITIAL 0 NO-UNDO.
DEF VAR i-parcelas          AS INT INITIAL 0 NO-UNDO.
DEF VAR i-tributo           AS INT INITIAL 0 NO-UNDO.
DEF VAR d-valor-pago        LIKE invoice-emb-imp.vl-invoice NO-UNDO.

DEF VAR positions           AS CHARACTER FORMAT "x(20)" NO-UNDO.
DEF VAR cBarra              AS CHARACTER FORMAT "x"     NO-UNDO.
DEF VAR found               AS INTEGER                  NO-UNDO.
DEF VAR loop                AS INTEGER                  NO-UNDO.
DEF VAR start               AS INTEGER                  NO-UNDO.

DEF VAR c-descricao-pais    LIKE pais.nome-pais         NO-UNDO.
DEF VAR i-position          AS INTEGER                  NO-UNDO.
DEF VAR i-num-adic          AS INTEGER                  NO-UNDO.
DEF VAR c-trib              AS   CHAR                   NO-UNDO.
DEF VAR flag-include        AS LOGICAL INITIAL YES.
DEF VAR c-char              AS CHAR INIT "abcdefghijklmnopqrstuvxywz0123456789"  NO-UNDO.

DEF VAR c-cgc-agente        AS CHAR FORMAT "x(19)"      NO-UNDO.
DEF VAR c-cgc-imp           AS CHAR FORMAT "x(19)"      NO-UNDO.
DEF VAR c-cgc-agente-imp    AS CHAR FORMAT "x(19)"      NO-UNDO.
DEF VAR c-cgc-consig        AS CHAR FORMAT "x(19)"      NO-UNDO.
DEF VAR c-nr-cpf-repres-legal  AS CHAR FORMAT "x(19)"   NO-UNDO.
DEF VAR c-tipo-decla        AS CHAR FORMAT "x(50)"      NO-UNDO.
DEF VAR c-via-transporte    AS CHAR FORMAT "x(40)"      NO-UNDO.

DEF VAR c-desc-tipo         AS CHAR FORMAT "x(20)"      NO-UNDO.

&if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
    DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cAuxTraducao002 AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cAuxTraducao003 AS CHARACTER NO-UNDO.
&endif

form skip(01)

     c-parametro                    no-label    skip(1)
     tt-param.embarque                 colon 20 SKIP(1)
     tt-param.estab-ini                colon 20  
     estabelec.nome                 NO-LABEL  COLON 23 SKIP(1)
     c-tipo-decla                      COLON 20 SKIP(1)
     c-via-transporte                  COLON 20 SKIP(1)
     tt-param.arq-entrada              COLON 20 SKIP(1)
     tt-param.usuario                  COLON 20 SKIP(1)
     tt-param.nat-operacao             COLON 20 SKIP(1)
     tt-param.diretorio                COLON 20 SKIP(1)
     c-desc-tipo                       COLON 20 SKIP(2)
     c-impressao                    no-label    skip(1)
     c-destino                         colon 20
     " - ":U
     tt-param.arquivo               no-label format "x(60)":U skip
     c-seg-usuario                     colon 20 skip(1)
     with down no-box side-labels width 132 stream-io frame f-parametros.

{utp/ut-liter.i PAR∂METROS * R}
assign c-parametro = trim(return-value).
{utp/ut-liter.i IMPRESS«O * R}
assign c-impressao = trim(return-value).
{utp/ut-liter.i Destino * L}
assign c-destino:label in frame f-parametros = trim(return-value).
{utp/ut-liter.i Tipo_Declaraá∆o * L}
assign c-tipo-decla:label in frame f-parametros = trim(return-value).
{utp/ut-liter.i Via_Transporte * L}
assign c-via-transporte:label in frame f-parametros = trim(return-value).
{utp/ut-liter.i Usu†rio * L}
assign tt-param.usuario:label in frame f-parametros = trim(return-value)
       c-seg-usuario:label in frame f-parametros = trim(return-value).
{utp/ut-liter.i Tipo * L}
assign c-desc-tipo:label in frame f-parametros = trim(return-value).
{utp/ut-liter.i Diret¢rio * L}
assign tt-param.diretorio:label in frame f-parametros = trim(return-value).
{utp/ut-liter.i Arquivo_Siscomex * L}
assign tt-param.arq-entrada:label in frame f-parametros = trim(return-value).

IF tt-param.tipo = 1 THEN DO:
    {utp/ut-liter.i Ordem_e_Item * L}
    assign c-desc-tipo = trim(return-value).
END.
IF tt-param.tipo = 2 THEN DO:
    {utp/ut-liter.i NCM * L}
    assign c-desc-tipo = trim(return-value).
END.
IF tt-param.tipo = 3 THEN DO:
    {utp/ut-liter.i Adicao * L}
    assign c-desc-tipo = trim(return-value).
END.
ASSIGN c-tipo-decla = {imp/im0710i2.i 04 tt-param.tipo-decl}.
ASSIGN c-via-transporte = {imp/im0710.i 04 tt-param.via-transporte}.


/*DEF STREAM str-rp.*/

{utp/ut-glob.i}

/************ Funá∆o que converte os caracteres acentuados para n∆o-acentuados ******************/

FUNCTION fnChar RETURNS CHARACTER 
  (INPUT pString AS CHAR ):

   DEF VAR Y AS INTEGER NO-UNDO.
   DEF VAR a AS CHAR NO-UNDO.
   DEF VAR c AS CHAR FORMAT "x(250)" NO-UNDO.

   DO Y = 1 TO LENGTH(pString):
      ASSIGN a = SUBSTRING(pString,Y,1).
      IF INDEX(c-char,a) <> 0 AND
         INDEX(c-char,a) <> ? THEN
         ASSIGN c = c + a.
      ELSE DO:   
         CASE a:
             WHEN "†" OR WHEN "a" OR WHEN "∆" OR WHEN "É" OR WHEN "Ñ" THEN ASSIGN c = c + "a".
             WHEN "Ç" OR WHEN "e" OR WHEN "à" OR WHEN "â"             THEN ASSIGN c = c + "e".
             WHEN "°" OR WHEN "i" OR WHEN "å" OR WHEN "ã"             THEN ASSIGN c = c + "i".
             WHEN "¢" OR WHEN "o" OR WHEN "‰" OR WHEN "ì" OR WHEN "î" THEN ASSIGN c = c + "o".
             WHEN "£" OR WHEN "U" OR WHEN "ñ" OR WHEN "Å"             THEN ASSIGN c = c + "u".
             WHEN "Ï" OR WHEN "ò"                                     THEN ASSIGN c = c + "y".
             WHEN "§"                                                 THEN ASSIGN c = c + "n".
             WHEN "á"                                                 THEN ASSIGN c = c + "c".
             OTHERWISE ASSIGN c = c + " ".
         END CASE.
      END.
   END.

   RETURN CAPS(c). 

END FUNCTION.   


FUNCTION fnIntDig RETURNS INTEGER 
  (INPUT pString AS CHAR ):

   DEF VAR Y AS INTEGER NO-UNDO.
   DEF VAR a AS INTEGER NO-UNDO.
   DEF VAR l-primeiro AS LOGICAL NO-UNDO.
   DEF VAR d-agencia AS CHAR FORMAT "X(04)" NO-UNDO.
   DEF VAR d-agencia-aux AS CHAR FORMAT "X(04)" NO-UNDO.
   DEF VAR i-cont AS INTEGER NO-UNDO.
   ASSIGN l-primeiro = NO.

   ASSIGN i-cont = 0.
   DO Y = LENGTH(pString) TO 1 BY -1:

      IF SUBSTRING(pString,Y,1) <> "" THEN DO:

         ASSIGN a = int(SUBSTRING(pString,Y,1)).
         IF a <> 0 THEN DO:
            ASSIGN d-agencia  = d-agencia + string(a)
                   l-primeiro = YES.
         END.
         ELSE DO:   
            IF l-primeiro THEN
               ASSIGN d-agencia = d-agencia + string(a).
         END.

         ASSIGN i-cont = i-cont + 1.

         IF i-cont = 4 THEN LEAVE.

      END.


   END.

   DO Y = 4 TO 1 BY -1:

      ASSIGN d-agencia-aux = d-agencia-aux + SUBSTRING(d-agencia,Y,1).

   END.

   RETURN INT(d-agencia-aux). 

END FUNCTION.   


/* **************************** Funá‰es do sistema *************************************/
ASSIGN l-erro = NO.

run utp/ut-acomp.p persistent set h-acomp.

run pi-inicializar in h-acomp (input "Gerando arquivos...").

DEFINE TEMP-TABLE tt-erro NO-UNDO
    FIELD nr-sequencia AS INTE
    FIELD cd-erro      AS INTE
    FIELD descricao    AS CHAR FORMAT "x(60)".

/************************** Geraá∆o dos dados ******************************/
FIND FIRST tt-param NO-LOCK NO-ERROR.

ASSIGN tt-param.arquivo = tt-param.arq-destino.

FIND FIRST estabelec WHERE estabelec.cod-estabel = tt-param.estab-ini NO-LOCK NO-ERROR.
IF NOT AVAILABLE estabelec THEN
DO:
    {utp/ut-liter.i Estabelecimento * R}
    RUN erro (INPUT RETURN-VALUE).
    IF RETURN-VALUE = "nok" THEN
        ASSIGN l-erro = YES.
END.
ASSIGN c-nome = estabelec.nome.

FIND FIRST emitente WHERE emitente.cod-emitente = estabelec.cod-emitente NO-LOCK NO-ERROR.
IF NOT AVAILABLE emitente THEN
DO:
    {utp/ut-liter.i Emitente * R}
    RUN erro (INPUT RETURN-VALUE).
    IF RETURN-VALUE = "nok" THEN
        ASSIGN l-erro = YES.

END.

FIND FIRST param-imp WHERE param-imp.cod-estabel = tt-param.estab-ini NO-LOCK NO-ERROR.
IF NOT AVAILABLE param-imp THEN
DO:
    {utp/ut-liter.i Param-imp * R}
    RUN erro (INPUT RETURN-VALUE).
    IF RETURN-VALUE = "nok" THEN
        ASSIGN l-erro = YES.
END.

FIND FIRST pais WHERE pais.nome-pais = emitente.pais NO-LOCK NO-ERROR.
IF NOT AVAILABLE pais THEN
DO:
    {utp/ut-liter.i Pais * R}
    RUN erro (INPUT RETURN-VALUE).
    IF RETURN-VALUE = "nok" THEN
        ASSIGN l-erro = YES.
END.

FIND FIRST param-compra NO-LOCK NO-ERROR.
IF NOT AVAILABLE param-compra THEN
    DO:
    {utp/ut-liter.i Param-compra * R}
    RUN erro (INPUT RETURN-VALUE).
    IF RETURN-VALUE = "nok" THEN
       ASSIGN l-erro = YES.
END.


if param-compra.ipi-sobre-preco = 1 then 
   assign l-preco-bruto = yes.
else 
   assign l-preco-bruto = no.

DO loop = 1 TO 2:
   positions = "".
   cBarra = SUBSTRING("~\/",loop,1).
   start  = 1.
   found  = INDEX(tt-param.arq-entrada,cBarra,start).
   DO WHILE found > 0:
      positions = positions + STRING(found).
      start = found + 1.
      found = INDEX(tt-param.arq-entrada,cBarra,start).
   END.
END.

DEF VAR c-arquivo-destino LIKE tt-param.arq-entrada NO-UNDO.

ASSIGN c-arquivo-destino = substring(tt-param.arq-entrada,INT(SUBSTRING(positions,2,4)) + 1,20).

FIND FIRST param-global NO-LOCK NO-ERROR.
FIND FIRST param-re NO-LOCK NO-ERROR.

IF NOT l-erro THEN DO:

   FIND FIRST embarque-imp 
        WHERE embarque-imp.cod-estabel  = tt-param.estab-ini
          AND embarque-imp.embarque     = tt-param.embarque NO-LOCK NO-ERROR.

        IF AVAILABLE embarque-imp THEN
        DO:
            /* Geraá∆o do Header */
            CREATE tt-header.
            ASSIGN tt-header.tp-registro           = 0
                   tt-header.arquivo               = c-arquivo-destino
                   tt-header.cod-estabel           = fnChar(embarque-imp.cod-estabel)
                   tt-header.nome                  = fnChar(estabelec.nome)
                   tt-header.embarque              = fnChar(embarque-imp.embarque)
                   tt-header.dt-geracao            = TODAY
                   tt-header.hora-geracao          = SUBSTRING(STRING(TIME,"HH:MM:SS"),1,2)
                                                   + SUBSTRING(STRING(TIME,"HH:MM:SS"),4,2)
                                                   + SUBSTRING(STRING(TIME,"HH:MM:SS"),7,2).
            /* Geraá∆o do cabeáalho */
            CREATE tt-cabecalho.
            ASSIGN tt-cabecalho.tp-registro         = 1
                   tt-cabecalho.nr-ident-usuario    = embarque-imp.embarque
                   tt-cabecalho.cd-tipo-declaracao  = tt-param.tipo-decl
                   tt-cabecalho.cd-tipo-importador  = IF emitente.natureza = 1 THEN 2 ELSE 1.

            &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                ASSIGN cAuxTraducao001 = {adinc/i03ad098.i 04 emitente.natureza}.
                run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"), INPUT "", INPUT "").
                ASSIGN tt-cabecalho.tipo-importador     = RETURN-VALUE .
            &else
                ASSIGN tt-cabecalho.tipo-importador     =  {adinc/i03ad098.i 04 emitente.natureza} .
            &endif
            
            ASSIGN tt-cabecalho.nr-importador       = emitente.cgc
                   tt-cabecalho.cd-pais-importador  = pais.cod-pais
                   c-descricao-pais                 = pais.nome-pais
                   c-nome-importador                = emitente.nome-emit.

            IF emitente.natureza = 2 THEN
               ASSIGN c-cgc-imp  = string(emitente.cgc,param-global.formato-id-federal).
            ELSE 
               ASSIGN c-cgc-imp = string(emitente.cgc,param-global.formato-id-pessoal).

            ASSIGN c-formato-cpf = param-global.formato-id-pessoal.
            &if '{&BF_DIS_VERSAO_EMS}' >= '2.05' &then
                ASSIGN tt-cabecalho.nr-cpf-repres-legal = STRING(param-imp.cod-cpf-repres).
            &else
                ASSIGN tt-cabecalho.nr-cpf-repres-legal = trim(substring(param-imp.char-1,41,20)).
            &endif

            ASSIGN c-nr-cpf-repres-legal = tt-cabecalho.nr-cpf-repres-legal.

            ASSIGN tt-cabecalho.cd-via-transp-carg  = tt-param.via-transporte.

            ASSIGN c-desc-via = {imp/im0710.i 04 tt-param.via-transporte}.

            /************************** FormÔs do relat¢rio ******************************/
            {imp/im0710rp.i}

            FIND FIRST historico-embarque WHERE historico-embarque.cod-estabel  = embarque-imp.cod-estabel
                                            AND historico-embarque.embarque     = embarque-imp.embarque NO-LOCK NO-ERROR.

            IF NOT AVAIL historico-embarque THEN DO:
                {utp/ut-liter.i Hist¢rico_Embarque * R}
                RUN erro (INPUT RETURN-VALUE).
            END.
            ELSE DO:

                FIND FIRST itinerario WHERE itinerario.cod-itiner = historico-embarque.cod-itiner NO-LOCK NO-ERROR.
                FIND FIRST pto-contr  WHERE pto-contr.cod-pto-contr = embarque-imp.cdn-pto-embarq NO-LOCK NO-ERROR.

                IF  tt-param.via-transporte = 1 OR 
                    tt-param.via-transporte = 2 OR
                    tt-param.via-transporte = 3 OR
                    tt-param.via-transporte = 4 OR
                    tt-param.via-transporte = 6 OR
                    tt-param.via-transporte = 7 THEN
                 DO:

                    &if "{&bf_cex_versao_ems}" >= "2.062" &then
                       &if "{&bf_dis_versao_ems}" >= "2.04" &then
                            FIND FIRST transporte WHERE transporte.cod-transp = embarque-imp.cod-transp NO-LOCK NO-ERROR.
                            ASSIGN  tt-cabecalho.nm-transportador    = IF AVAIL transporte THEN fnChar(transporte.nome) ELSE ""
                                    tt-cabecalho.nr-docto-carga      = fnChar(embarque-imp.cod-conhecto-house)
                                    tt-cabecalho.nr-docto-carga-mast = fnChar(embarque-imp.cod-conhecto-master).
                       &endif
                    &else   
                        &if "{&bf_mat_versao_ems}" >= "2.05" &then
                              FIND FIRST transporte WHERE transporte.cod-transp = embarque-imp.cod-transp NO-LOCK NO-ERROR.
                              ASSIGN  tt-cabecalho.nm-transportador    = IF AVAIL transporte THEN fnChar(transporte.nome) ELSE ""
                                      tt-cabecalho.nr-docto-carga      = fnChar(embarque-imp.cod-conhecto-house)
                                      tt-cabecalho.nr-docto-carga-mast = fnChar(embarque-imp.cod-conhecto-master).
                        &else
                               FIND FIRST transporte WHERE transporte.cod-transp = embarque-imp.cod-transp NO-LOCK NO-ERROR.
                               ASSIGN  tt-cabecalho.nm-transportador    = IF AVAIL transporte THEN fnChar(transporte.nome) ELSE ""
                                       tt-cabecalho.nr-docto-carga      = fnChar(embarque-imp.nr-conhecimento)
                                       tt-cabecalho.nr-docto-carga-mast = fnChar(embarque-imp.nr-conhecimento).
                        &endif
                    &endif

                    ASSIGN  tt-cabecalho.nm-local-embarque   = IF AVAIL mgcex.pto-contr THEN fnChar(pto-contr.descricao) ELSE "".
                    FIND FIRST historico-embarque WHERE historico-embarque.cod-estabel   = embarque-imp.cod-estabel
                                                    AND historico-embarque.embarque      = embarque-imp.embarque 
                                                    AND historico-embarque.cod-itiner    = itinerario.cod-itiner
                                                    AND historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-embarq NO-LOCK NO-ERROR.
                    IF NOT AVAIL historico-embarque THEN do:
                       {utp/ut-liter.i Hist¢rico_Embarque * R}
                       RUN erro (INPUT RETURN-VALUE).
                    END.
                    ELSE  ASSIGN  tt-cabecalho.dt-embarque = historico-embarque.dt-efetiva.
                END.

                IF AVAIL historico-embarque THEN DO:
                    IF tt-param.via-transporte = 7 THEN
                       ASSIGN tt-cabecalho.nr-veiculo-transp = fnChar(historico-embarque.id-meio-transp).

                    IF tt-param.via-transporte = 1  OR
                       tt-param.via-transporte = 2  OR
                       tt-param.via-transporte = 3  THEN DO:
                       ASSIGN tt-cabecalho.nm-veiculo-transp = fnChar(historico-embarque.id-meio-transp).
                    END.

                    &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                        ASSIGN cAuxTraducao002 = {adinc/i03ad098.i 04 emitente.natureza}.
                        run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao002)," ","_"), INPUT "", INPUT "").
                        ASSIGN   c-desc-ag-carga = RETURN-VALUE.
                    &else
                        ASSIGN c-desc-ag-carga = {adinc/i03ad098.i 04 emitente.natureza}.
                    &endif

                    FOR FIRST ordens-embarque 
                        WHERE ordens-embarque.cod-estabel = embarque-imp.cod-estabel
                          AND ordens-embarque.embarque    = embarque-imp.embarque NO-LOCK:

                        FIND FIRST ordem-compra WHERE 
                             ordem-compra.numero-ordem = ordens-embarque.numero-ordem NO-LOCK NO-ERROR.

                        IF AVAILABLE ordem-compra THEN 
                        DO:
                           IF ordem-compra.situacao = 4 OR ordem-compra.situacao = 6 THEN NEXT.
                           ASSIGN tt-cabecalho.cd-moeda-mle = ordem-compra.mo-codigo.
                           FIND moeda NO-LOCK WHERE moeda.mo-codigo = ordem-compra.mo-codigo NO-ERROR.
                           IF AVAIL moeda THEN
                              ASSIGN tt-cabecalho.desc-moeda-mle = moeda.descricao.
                        END.

                    END.

                    ASSIGN flag-moeda = NO.

                    FOR LAST ordens-embarque WHERE ordens-embarque.cod-estabel = embarque-imp.cod-estabel
                                               AND ordens-embarque.embarque    = embarque-imp.embarque NO-LOCK: 
                        FIND FIRST ordem-compra WHERE ordem-compra.numero-ordem = ordens-embarque.numero-ordem NO-LOCK NO-ERROR.
                        IF NOT AVAIL ordem-compra THEN NEXT.
                        IF ordem-compra.mo-codigo <> tt-cabecalho.cd-moeda-mle THEN
                        DO:
                           ASSIGN flag-moeda = YES.
                           LEAVE.
                        END.
                    END.

                    ASSIGN c-ordem           = 0
                           de-tot-ger        = 0
                           de-tot-desp       = 0
                           de-tot-desp-frete-emb = 0
                           de-tot-desp-frete-nac = 0
                           i-parcelas        = 0
                           d-valor-pago      = 0.

                    FOR EACH historico-embarque WHERE historico-embarque.cod-estabel  = embarque-imp.cod-estabel
                                                  AND historico-embarque.embarque     = embarque-imp.embarque 
                                                  AND historico-embarque.cod-itiner   = itinerario.cod-itiner NO-LOCK:
                        FOR EACH desp-embarque WHERE desp-embarque.cod-estabel        = historico-embarque.cod-estabel
                                                 AND desp-embarque.embarque           = historico-embarque.embarque 
                                                 AND desp-embarque.cod-itiner         = historico-embarque.cod-itiner 
                                                 AND desp-embarque.cod-pto-contr      = historico-embarque.cod-pto-contr NO-LOCK:

                            ASSIGN de-val-desp = desp-embarque.val-desp.


                            IF desp-embarque.mo-codigo <> 0 THEN 
                            DO:
                               IF flag-moeda THEN 
                                  RUN cdp/cd0812.p (INPUT  desp-embarque.mo-codigo,
                                                    INPUT  0, 
                                                    INPUT  de-val-desp, 
                                                    INPUT  TODAY,            
                                                    OUTPUT de-val-desp-conv).
                               ELSE 
                                   RUN cdp/cd0812.p (INPUT  desp-embarque.mo-codigo,
                                                     INPUT  tt-cabecalho.cd-moeda-mle, 
                                                     INPUT  de-val-desp, 
                                                     INPUT  TODAY,            
                                                     OUTPUT de-val-desp-conv).
                            END.

                            ASSIGN de-tot-desp = de-tot-desp + de-val-desp-conv.

                            FIND desp-imp WHERE desp-imp.cod-desp = desp-embarque.cod-desp
                                            AND desp-imp.inc-val-frete = YES NO-LOCK NO-ERROR.
                            IF AVAIL desp-imp THEN
                               ASSIGN de-tot-desp-frete-emb = de-tot-desp-frete-emb + de-val-desp.

                        END.
                        IF historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-embarq THEN LEAVE.
                    END.

                    FOR EACH historico-embarque WHERE historico-embarque.cod-estabel  = embarque-imp.cod-estabel
                                                  AND historico-embarque.embarque     = embarque-imp.embarque 
                                                  AND historico-embarque.cod-itiner   = itinerario.cod-itiner NO-LOCK:
                        FOR EACH desp-embarque WHERE desp-embarque.cod-estabel        = historico-embarque.cod-estabel
                                                 AND desp-embarque.embarque           = historico-embarque.embarque 
                                                 AND desp-embarque.cod-itiner         = historico-embarque.cod-itiner 
                                                 AND desp-embarque.cod-pto-contr      = historico-embarque.cod-pto-contr NO-LOCK:
                            FIND FIRST desp-imp WHERE desp-imp.cod-desp = desp-embarque.cod-desp NO-LOCK NO-ERROR.

                            IF AVAILABLE desp-imp THEN
                            DO:
                                IF desp-imp.inc-val-frete THEN DO:
                                    ASSIGN tt-cabecalho.cd-moeda-frete = desp-embarque.mo-codigo.
                                    FIND moeda WHERE moeda.mo-codigo = desp-embarque.mo-codigo NO-LOCK NO-ERROR.
                                    IF AVAIL moeda THEN 
                                       ASSIGN tt-cabecalho.desc-mo-frete = moeda.descricao.
                                END.
                                IF desp-imp.inc-val-seguro THEN DO:
                                    ASSIGN tt-cabecalho.cd-moeda-seguro = desp-embarque.mo-codigo.
                                    FIND moeda WHERE moeda.mo-codigo = desp-embarque.mo-codigo NO-LOCK NO-ERROR.
                                    IF AVAIL moeda THEN ASSIGN tt-cabecalho.desc-mo-seguro = moeda.descricao.
                                END.

                            END.

                        END.
                        IF historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-desembar THEN LEAVE.
                    END.

                    FOR EACH historico-embarque WHERE historico-embarque.cod-estabel    = embarque-imp.cod-estabel
                                                  AND historico-embarque.embarque       = embarque-imp.embarque 
                                                  AND historico-embarque.cod-pto-contr  > embarque-imp.cdn-pto-embarq
                                                  AND historico-embarque.cod-pto-contr <= embarque-imp.cdn-pto-desembar NO-LOCK:
                        FOR EACH desp-embarque WHERE desp-embarque.cod-estabel        = historico-embarque.cod-estabel
                                                 AND desp-embarque.embarque           = historico-embarque.embarque 
                                                 AND desp-embarque.cod-itiner         = historico-embarque.cod-itiner
                                                 AND desp-embarque.cod-pto-contr      = historico-embarque.cod-pto-contr NO-LOCK:
                            FIND FIRST desp-imp WHERE desp-imp.cod-desp = desp-embarque.cod-desp
                                                  AND desp-imp.inc-val-frete = YES NO-LOCK NO-ERROR.
                            IF AVAILABLE desp-imp THEN
                                ASSIGN de-tot-desp-frete-nac = de-tot-desp-frete-nac + desp-embarque.val-desp.
                        END.
                        IF historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-desembar THEN LEAVE.
                    END.

                    ASSIGN de-quantidade = 0.

                    FOR each ordens-embarque WHERE ordens-embarque.cod-estabel = embarque-imp.cod-estabel
                                               AND ordens-embarque.embarque    = embarque-imp.embarque NO-LOCK: 
                        FIND FIRST ordem-compra WHERE ordem-compra.numero-ordem = ordens-embarque.numero-ordem NO-LOCK NO-ERROR.
                        IF NOT AVAILABLE ordem-compra THEN NEXT.
                        FIND FIRST processo-imp NO-LOCK WHERE 
                             processo-imp.cod-estabel = ordens-embarque.cod-estabel AND 
                             processo-imp.nr-proc-imp = ordens-embarque.nr-proc-imp NO-ERROR.
                        IF NOT AVAIL processo-imp THEN NEXT.
                        IF ordem-compra.numero-ordem <> c-ordem THEN DO:

                            RUN pi-acompanhar IN h-acomp (INPUT ordem-compra.numero-ordem).

                            IF ordem-compra.situacao = 4 OR ordem-compra.situacao = 6 THEN NEXT.
                            FIND FIRST cotacao-item WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem 
                                                      AND cotacao-item.it-codigo    = ordem-compra.it-codigo 
                                                      AND cotacao-item.cot-aprovada = YES NO-LOCK NO-ERROR.
                            IF NOT AVAILABLE cotacao-item THEN NEXT.

                            {ccp/cc9019.i50}
                            {cdp/cd4300.i4  "yes" cotacao-item.char-1}
                            {ccp/cc9019.i51 "yes"}

                            &if '{&bf_mat_versao_ems}' >= '2.062' &then
                                {ocp/oc0201.i50}
                                {ocp/oc0201.i51 "yes"}
                            &else
                                {ccp/cc0303.i50}
                                {ccp/cc0303.i51 "yes"}
                            &endif
                            {cdp/cd4300.i4  "yes" cotacao-item.char-2}
                            
                            ASSIGN c-class-fiscal   = c-class-fiscal-i50
                                   c-cod-incoterm   = c-cod-incoterm-i50
                                   i-cod-pto-contr  = i-cod-pto-contr-i50
                                   i-cod-fabricante = i-cod-fabricante-i50.

                            IF l-preco-bruto = NO THEN 
                                ASSIGN de-valor-ipi = (cotacao-item.pre-unit-for * cotacao-item.aliquota-ipi) / (100 + cotacao-item.aliquota-ipi).
                            ELSE
                            DO:
                                IF cotacao-item.perc-descto > 0 THEN
                                    ASSIGN de-val-orig = (cotacao-item.pre-unit-for * 100) / (100 - cotacao-item.perc-descto).
                                ELSE
                                    ASSIGN de-val-orig = cotacao-item.pre-unit-for.
                                ASSIGN de-valor-ipi = (de-val-orig * cotacao-item.aliquota-ipi) / (100 + cotacao-item.aliquota-ipi).

                            END.

                            ASSIGN de-preco-unit = cotacao-item.pre-unit-for - de-valor-ipi.

                            IF flag-moeda THEN DO:
                               RUN cdp/cd0812.p (INPUT  ordem-compra.mo-codigo,
                                                 INPUT  0, 
                                                 INPUT  de-preco-unit, 
                                                 INPUT  TODAY,            
                                                 OUTPUT de-preco-unit-conv).
                            END.

                            FOR EACH prazo-compra 
                               WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem 
                                 AND prazo-compra.situacao     <> 4
                                 AND prazo-compra.situacao     <> 6 NO-LOCK:
                                IF flag-moeda THEN 
                                   ASSIGN de-preco-total = prazo-compra.qtd-sal-forn * de-preco-unit-conv.

                                ELSE ASSIGN de-preco-total = prazo-compra.qtd-sal-forn * de-preco-unit.
                                ASSIGN de-tot-ger = de-tot-ger + de-preco-total.
                            END.

                            ASSIGN c-ordem = ordem-compra.numero-ordem.

                            FIND FIRST ITEM WHERE ITEM.it-codigo = ordem-compra.it-codigo NO-LOCK NO-ERROR.

                            IF NOT AVAIL ITEM THEN do:
                               ASSIGN de-tot-ger  = 0.
                               NEXT.
                            END.

                            ASSIGN de-quantidade = de-quantidade + ordens-embarque.quantidade.

                            RUN pi-gera-adicao.
                            IF RETURN-VALUE = "nok" THEN DO:
                               ASSIGN de-tot-ger  = 0.
                               NEXT.
                            END.

                            FOR EACH historico-embarque 
                               WHERE historico-embarque.cod-estabel    = embarque-imp.cod-estabel
                                 AND historico-embarque.embarque       = embarque-imp.embarque 
                                 AND historico-embarque.cod-itiner     = itinerario.cod-itiner
                                 AND historico-embarque.cod-pto-contr <= embarque-imp.cdn-pto-desembar NO-LOCK:
                               FOR EACH desp-embarque 
                                  WHERE desp-embarque.cod-estabel        = historico-embarque.cod-estabel
                                    AND desp-embarque.embarque           = historico-embarque.embarque
                                    AND desp-embarque.cod-itiner         = historico-embarque.cod-itiner
                                    AND desp-embarque.cod-pto-contr      = historico-embarque.cod-pto-contr NO-LOCK:
                                    FIND FIRST desp-imp 
                                         WHERE desp-imp.cod-desp = desp-embarque.cod-desp NO-LOCK NO-ERROR.
                                    IF AVAILABLE desp-imp THEN DO:
                                       IF    NOT desp-imp.inc-val-seguro 
                                          OR NOT desp-imp.inc-val-frete
                                          OR NOT desp-imp.inc-valor-mercad THEN
                                             RUN pi-gera-acrescimos.
                                       IF desp-imp.inc-val-seguro THEN
                                          ASSIGN de-tot-vl-moeda = desp-embarque.val-desp.

                                    END.
                                END.
                                /*IF historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-desembar THEN LEAVE.*/
                            END.

                            &if '{&BF_DIS_VERSAO_EMS}' >= '2.05' &then
                                ASSIGN tt-cabecalho.pb-carga  = tt-cabecalho.pb-carga  + 
                                       &if '{&BF_DIS_VERSAO_EMS}' >= '2.062' &then (ordens-embarque.peso-bruto / ordens-embarque.qt-do-forn) &else ordens-embarque.peso-bruto &endif. 
                            &else
                                ASSIGN tt-cabecalho.pb-carga  = tt-cabecalho.pb-carga  + ( DECIMAL ( SUBSTR ( ordens-embarque.char-2,26,17 ) ) ).
                            &endif

                            &if '{&BF_DIS_VERSAO_EMS}' >= '2.05' &then
                                ASSIGN tt-cabecalho.pl-carga  = tt-cabecalho.pl-carga  +  
                                       &if '{&BF_DIS_VERSAO_EMS}' >= '2.062' &then ordens-embarque.peso-liquido  / ordens-embarque.qt-do-forn &else ordens-embarque.peso-liquido &endif.
                            &else
                                ASSIGN tt-cabecalho.pl-carga  = tt-cabecalho.pl-carga  + ( DECIMAL ( SUBSTR ( ordens-embarque.char-2,9,17 ) ) ). 
                            &endif

                            IF tt-cabecalho.pl-carga = 0 THEN 
                               ASSIGN tt-cabecalho.pl-carga  = tt-cabecalho.pl-carga  + ITEM.peso-liquido .

                            IF tt-cabecalho.pb-carga = 0 THEN 
                               ASSIGN tt-cabecalho.pb-carga  = tt-cabecalho.pb-carga  + ITEM.peso-bruto .


                        END.
                    END.

                    ASSIGN tt-cabecalho.vl-tot-mle-mn  = de-tot-ger + de-tot-desp.

                    ASSIGN tt-cabecalho.vl-tot-frt-prepaid  = de-tot-desp-frete-emb
                           tt-cabecalho.vl-tot-frt-collect  = de-tot-desp-frete-nac
                           tt-cabecalho.vl-tot-seguro-mneg  = de-tot-vl-moeda
                           tt-cabecalho.pl-carga            = (tt-cabecalho.pl-carga &if '{&BF_DIS_VERSAO_EMS}' >= '2.062' &then * de-quantidade &endif)
                           tt-cabecalho.pb-carga            = (tt-cabecalho.pb-carga &if '{&BF_DIS_VERSAO_EMS}' >= '2.062' &then * de-quantidade &endif).

                    FIND FIRST ordens-embarque WHERE ordens-embarque.cod-estabel = embarque-imp.cod-estabel
                                                 and ordens-embarque.embarque    = embarque-imp.embarque NO-LOCK NO-ERROR.
                    IF AVAILABLE ordens-embarque THEN DO:
                       FIND FIRST processo-imp NO-LOCK 
                            WHERE processo-imp.cod-estabel = ordens-embarque.cod-estabel
                              AND processo-imp.nr-proc-imp = ordens-embarque.nr-proc-imp NO-ERROR.
                       IF AVAIL processo-imp THEN DO:
                          FIND emitente NO-LOCK WHERE 
                               emitente.cod-emitente = processo-imp.cod-agente NO-ERROR.
                          IF AVAIL emitente THEN DO:
                             ASSIGN tt-cabecalho.cd-tipo-ag-carga = IF emitente.natureza = 1 THEN 2 ELSE 1
                                    tt-cabecalho.nr-agente-carga  = fnChar(emitente.cgc)
                                    c-cgc-agente                  = string(tt-cabecalho.nr-agente-carga,param-global.formato-id-federal).
                          END.
                       END.

                       FIND FIRST emitente WHERE emitente.cod-emitente = processo-imp.cod-consignatario NO-LOCK NO-ERROR.
                       IF NOT AVAILABLE emitente THEN DO:
                          ASSIGN tt-cabecalho.cd-tipo-consig      = 1
                                 tt-cabecalho.nr-consignatario    = fnChar(tt-cabecalho.nr-importador)
                                 tt-cabecalho.nm-consignatario    = c-nome-importador.
                          {utp/ut-liter.i Pr¢prio_Importador * R}
                          ASSIGN c-desc-cons = TRIM(RETURN-VALUE).
                       END.
                       ELSE DO:
                          ASSIGN tt-cabecalho.cd-tipo-consig      = 2
                                 tt-cabecalho.nr-consignatario    = IF AVAIL emitente THEN fnChar(emitente.cgc) ELSE ""
                                 c-cgc-consig                     = string(tt-cabecalho.nr-consignatario,param-global.formato-id-federal)
                                 tt-cabecalho.nm-consignatario    = IF AVAIL emitente THEN fnChar(emitente.nome-emit) ELSE "".
                          {utp/ut-liter.i Outro * R}
                          ASSIGN c-desc-cons = TRIM(RETURN-VALUE).
                       END.
                    END.
                END.
            END.
    END.

    /* Geraá∆o do arquivo texto */
    OUTPUT TO VALUE(tt-param.arq-entrada).

    FIND FIRST tt-adicao NO-LOCK NO-ERROR.
    IF  AVAIL tt-adicao THEN DO:

        FIND FIRST tt-header NO-LOCK NO-ERROR.
            RUN pi-geratxt-header.
        FIND FIRST tt-cabecalho NO-LOCK NO-ERROR.
            RUN pi-geratxt-cabecalho.

        FOR EACH tt-adicao EXCLUSIVE-LOCK:
            RUN pi-geratxt-adicao.
            FOR EACH tt-parcelas EXCLUSIVE-LOCK
               WHERE tt-parcelas.nr-ident-usuario  = tt-adicao.nr-ident-usuario
                 AND tt-parcelas.nr-adicao-usuario = tt-adicao.nr-adicao-usuario:
                RUN pi-geratxt-parcelas.
            END.
            FOR EACH tt-tributos EXCLUSIVE-LOCK
               WHERE tt-tributos.nr-ident-usuario  = tt-adicao.nr-ident-usuario
                 AND tt-tributos.nr-adicao-usuario = tt-adicao.nr-adicao-usuario:
                RUN pi-geratxt-tributos.
            END.
           
            ASSIGN i-soma-total = 0.
            FOR EACH tt-mercadoria EXCLUSIVE-LOCK
               WHERE tt-mercadoria.nr-ident-usuario  = tt-adicao.nr-ident-usuario
                 AND tt-mercadoria.nr-adicao-usuario = tt-adicao.nr-adicao-usuario:
                   ASSIGN i-soma-total = i-soma-total + tt-mercadoria.qt-merc-un-comerc.
            END.
            FIND FIRST tt-mercadoria 
               WHERE tt-mercadoria.nr-ident-usuario  = tt-adicao.nr-ident-usuario
                 AND tt-mercadoria.nr-adicao-usuario = tt-adicao.nr-adicao-usuario EXCLUSIVE-LOCK NO-ERROR.
                  IF AVAIL tt-mercadoria THEN
                    RUN pi-geratxt-mercadoria.

                  FOR EACH tt-descricao EXCLUSIVE-LOCK
                     WHERE tt-descricao.nr-ident-usuario  = tt-adicao.nr-ident-usuario
                       AND tt-descricao.nr-adicao-usuario = tt-adicao.nr-adicao-usuario:
                        RUN pi-geratxt-descricao.
                  END.
        END.
    END.

    OUTPUT CLOSE.
   /* Fim da geraá∆o */

END.

/* ******************************* Emiss∆o do relat¢rio ***************************** */

/* include padr∆o para vari†veis de relat¢rio  */
{include/i-rpvar.i}
/* include padr∆o para output de relat¢rios */

/* include com a definiá∆o da frame de cabeáalho e rodapÇ */
run utp/ut-trfrrp.p (input frame f-parametros:handle).
{include/i-rpcab.i}
/* bloco principal do programa */

FIND FIRST empresa NO-LOCK 
     WHERE empresa.ep-codigo = i-ep-codigo-usuario NO-ERROR.
ASSIGN c-programa 	  = "IM0710RP"
       c-versao	      = "2.04"
	   c-revisao	  = ".04.000"
	   c-empresa 	  = empresa.razao-social
	   c-sistema	  = ""
	   c-titulo-relat = "Emiss∆o Declaraá∆o Importaá∆o".

{include/i-rpout.i} 

VIEW FRAME f-cabec.
VIEW FRAME f-rodape.

FIND FIRST tt-header NO-LOCK NO-ERROR.

RUN pi-imprime.

FOR EACH tt-erro EXCLUSIVE-LOCK 
    BY   tt-erro.cd-erro:

    DISP tt-erro.cd-erro   COLUMN-LABEL "C¢digo"
         tt-erro.descricao COLUMN-LABEL "Descriá∆o"
         WITH WIDTH 132 DOWN STREAM-IO FRAME f-erro.

    /* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
    RUN utp/ut-trfrrp.p (INPUT FRAME f-erro:HANDLE).
    
    DOWN WITH FRAME f-erro.
END.

PAGE.

FIND estabelec NO-LOCK 
     WHERE estabelec.cod-estabel = tt-param.estab-ini NO-ERROR.
DISP c-parametro                
     tt-param.embarque          
     tt-param.estab-ini         
     estabelec.nome WHEN AVAIL estabelec
     c-tipo-decla               
     c-via-transporte           
     tt-param.arq-entrada       
     tt-param.usuario           
     tt-param.nat-operacao      
     tt-param.diretorio         
     c-desc-tipo                
     c-impressao                
     c-destino                  
     tt-param.arquivo           
     c-seg-usuario  WITH FRAME f-parametros.            

{include/i-rpclo.i} 

/* **********************************************************     ******************************** */

RUN pi-finalizar IN h-acomp.


RETURN "OK":U.

/* Fim da emiss∆o do relat¢rio */
PROCEDURE pi-imprime:

    IF CAN-FIND(FIRST tt-adicao) THEN DO:
        FIND FIRST tt-cabecalho NO-LOCK NO-ERROR.
        VIEW FRAME fr-cabecalho.
    END.

/*     FIND FIRST tt-adicao NO-LOCK NO-ERROR. */
/*     IF AVAIL tt-adicao THEN DO:            */
/*     END.                                   */


        FOR EACH tt-adicao EXCLUSIVE-LOCK 
           WHERE tt-adicao.nr-ident-usuario = tt-cabecalho.nr-ident-usuario:
    
            IF flag-include THEN DO:
                {imp/im0710rp.i1}
                ASSIGN flag-include = NO.
    
            END.
    
            VIEW FRAME fr-adicao.
    
            ASSIGN tt-adicao.cd-mercadoria-ncm = STRING(tt-adicao.cd-mercadoria-ncm,"9999.99.99")
                   tt-adicao.cd-merc-nbm-sh    = STRING(tt-adicao.cd-merc-nbm-sh,"9999.99.99").
    
            DISPLAY tt-adicao.cd-mercadoria-ncm         AT 1
                    tt-adicao.cd-merc-nbm-sh            AT 14
                    tt-adicao.cd-merc-naladi-sh         AT 28
                    tt-adicao.cd-merc-naladi-ncc        AT 42
                    tt-adicao.cd-moeda-negociada        AT 58
                    tt-adicao.cd-incoterms-venda        AT 64
                    tt-adicao.pl-mercadoria             AT 71
                    tt-adicao.qt-parc-financ-360        AT 97
                    tt-adicao.qt-period-pgto-360        AT 103
                    tt-adicao.nr-rof                    AT 120 SKIP
                    tt-adicao.vl-tot-financ-360         TO 16            
                    tt-adicao.qt-un-estatistica         TO 37
                    tt-adicao.nm-loc-cond-venda         AT 41
                    WITH WIDTH 132 STREAM-IO NO-BOX NO-LABEL FRAME fr-adicao-relat.
            VIEW FRAME fr-adicao-2.
    
            FIND FIRST tt-acrescimos NO-LOCK NO-ERROR.
            IF AVAIL tt-acrescimos THEN
               VIEW FRAME fr-acrescimos.
    
            FOR EACH tt-acrescimos EXCLUSIVE-LOCK
               WHERE tt-acrescimos.nr-ident-usuario  = tt-adicao.nr-ident-usuario
                 AND tt-acrescimos.nr-adicao-usuario = tt-adicao.nr-adicao-usuario:
                DISPLAY tt-acrescimos.denominacao  AT 1
                        tt-acrescimos.moeda        AT 26
                        tt-acrescimos.vl-moeda     AT 30
                        tt-acrescimos.vl-real      AT 49
                        WITH WIDTH 132 STREAM-IO NO-BOX NO-LABELS FRAME fr-acr.
            END.
    
            FIND FIRST tt-deducoes NO-LOCK NO-ERROR.
            IF AVAIL tt-deducoes THEN
               VIEW FRAME fr-deducoes.
            FOR EACH tt-deducoes EXCLUSIVE-LOCK
               WHERE tt-deducoes.nr-ident-usuario  = tt-adicao.nr-ident-usuario
                 AND tt-deducoes.nr-adicao-usuario = tt-adicao.nr-adicao-usuario:
                DISPLAY tt-deducoes.denominacao   AT 1 
                        tt-deducoes.moeda         AT 26
                        tt-deducoes.vl-moeda      AT 30
                        tt-deducoes.vl-real       AT 49
                        WITH WIDTH 132 STREAM-IO NO-LABELS FRAME fr-ded.
            END.
    
            FIND FIRST tt-tributos NO-LOCK NO-ERROR.
            IF AVAIL tt-tributos THEN
               VIEW FRAME fr-tributos.
            FOR EACH tt-tributos EXCLUSIVE-LOCK
               WHERE tt-tributos.nr-ident-usuario  = tt-adicao.nr-ident-usuario
                 AND tt-tributos.nr-adicao-usuario = tt-adicao.nr-adicao-usuario:
                DISPLAY tt-tributos.cd-receita-imposto  TO 07
                        tt-tributos.cd-tipo-benef-ipi   TO 20                
                        tt-tributos.pc-aliq-norm-adval  TO 34
                        tt-tributos.pc-aliq-reduzida    TO 47
                        tt-tributos.trib                AT 50
                        WITH WIDTH 132 NO-LABEL NO-BOX STREAM-IO FRAME fr-trib.
            END.
    
            FIND FIRST tt-parcelas NO-LOCK NO-ERROR.
            IF AVAIL tt-parcelas THEN
               VIEW FRAME fr-parcelas.
            FOR EACH tt-parcelas WHERE tt-parcelas.nr-ident-usuario  = tt-adicao.nr-ident-usuario
                                   AND tt-parcelas.nr-adicao-usuario = tt-adicao.nr-adicao-usuario EXCLUSIVE-LOCK:
                DISPLAY 
                        tt-parcelas.dt-prev-pgto-360    AT 1
                        tt-parcelas.vl-prev-pgto-360    AT 12
                    WITH WIDTH 132 NO-LABELS NO-BOX STREAM-IO FRAME fr-parcs.
            END.
                FIND FIRST tt-mercadoria NO-LOCK NO-ERROR.
            IF AVAIL tt-mercadoria THEN
               VIEW FRAME fr-mecadorias.

            
            FOR EACH tt-mercadoria EXCLUSIVE-LOCK
                WHERE tt-mercadoria.nr-ident-usuario  = tt-adicao.nr-ident-usuario
                  AND tt-mercadoria.nr-adicao-usuario = tt-adicao.nr-adicao-usuario:

                DISPLAY tt-mercadoria.cd-mercadoria      AT 1
                        tt-mercadoria.qt-merc-un-comerc  TO 31
                        tt-mercadoria.nm-un-medid-comer  TO 35
                        tt-mercadoria.vl-unid-cond-venda TO 59
                        tt-mercadoria.nr-adicao          TO 72
                        tt-mercadoria.seq-item           TO 85
                        WITH WIDTH 132 NO-LABELS STREAM-IO NO-BOX FRAME fr-mercs.
            END.

            PUT SKIP(02).
    
        END.
    
    
END PROCEDURE.

PROCEDURE erro:

    DEF INPUT PARAMETER c-texto AS CHAR FORMAT "x(20)" NO-UNDO.

    RUN utp/ut-msgs.p (INPUT "msg":U, 
                       INPUT 2,
                       INPUT c-texto).

    ASSIGN i-sequencia = i-sequencia + 1.
    CREATE tt-erro.
    ASSIGN tt-erro.nr-sequencia = i-sequencia
           tt-erro.cd-erro      = 2
           tt-erro.descricao    = RETURN-VALUE.

    RETURN "NOK":U.
END PROCEDURE.


/* Geraá∆o de adicao */
PROCEDURE pi-gera-adicao:

    IF ITEM.tipo-contr = 4 THEN
       FIND FIRST classif-fisc WHERE classif-fisc.class-fiscal = c-class-fiscal NO-LOCK NO-ERROR.
    ELSE 
       FIND FIRST classif-fisc WHERE classif-fisc.class-fiscal = ITEM.class-fiscal NO-LOCK NO-ERROR.

    IF NOT AVAIL classif-fisc THEN RETURN "NOK".
    
    &if '{&BF_DIS_VERSAO_EMS}' >= '2.07' &then
     ASSIGN i-num-adic = ordens-embarque.num-adic.
    &else
     ASSIGN i-num-adic = INT(SUBSTRING(ordens-embarque.char-1,60,4)).
    &endif
    
    IF  tt-param.tipo = 1 THEN /* Agrupa Ordem/Item */
        FIND FIRST tt-adicao NO-LOCK
             WHERE tt-adicao.it-codigo = ITEM.it-codigo 
               AND (i-num-adic = 0 OR tt-adicao.nr-adicao-usuario = i-num-adic) NO-ERROR.
    ELSE
        IF  tt-param.tipo = 2 THEN /* Agrupa NCM */
            FIND FIRST tt-adicao NO-LOCK
                 WHERE tt-adicao.cd-mercadoria-ncm = classif-fisc.class-fiscal
                   AND (i-num-adic = 0 OR tt-adicao.nr-adicao-usuario = i-num-adic) NO-ERROR.
        ELSE /* Agrupa Adiá∆o */
            FIND FIRST tt-adicao WHERE tt-adicao.nr-adicao-usuario = i-num-adic NO-LOCK NO-ERROR.
    
    IF  NOT AVAILABLE tt-adicao THEN DO:
        IF  i-num-adic <> 0 THEN
            ASSIGN sequencia = i-num-adic.
        ELSE
            ASSIGN sequencia = sequencia + 1.
        
        RUN pi-cria-grava-adicao.
        
        &if '{&BF_DIS_VERSAO_EMS}' >= '2.05' &then
            FIND FIRST pto-contr WHERE pto-contr.cod-pto-contr = cotacao-item.cod-pto-contr NO-LOCK NO-ERROR.
        &else 
            FIND FIRST pto-contr WHERE pto-contr.cod-pto-contr = i-cod-pto-contr NO-LOCK NO-ERROR.
        &endif
        
        IF AVAILABLE pto-contr THEN
           ASSIGN tt-adicao.nm-loc-cond-venda  = fnChar(pto-contr.descricao).
    END.
    ELSE DO:
        IF  i-num-adic <> 0 THEN
            ASSIGN sequencia = i-num-adic.
    END.
    /*******************************/
    IF l-fn-imp-adicao-un THEN DO:
        IF cotacao-item.un <> classif-fisc.unidade THEN DO:
            ASSIGN tt-adicao.qt-un-estatistica = tt-adicao.qt-un-estatistica + (ordens-embarque.quantidade / item.fator-conver ).
        END.
        ELSE
            ASSIGN tt-adicao.qt-un-estatistica = tt-adicao.qt-un-estatistica + ordens-embarque.quantidade.
    END.         
    ELSE
        ASSIGN tt-adicao.qt-un-estatistica = tt-adicao.qt-un-estatistica + ordens-embarque.qt-do-forn.
    /***********************************/
    
    &if '{&BF_DIS_VERSAO_EMS}' >= '2.05' &then
        ASSIGN tt-adicao.pl-mercadoria  = tt-adicao.pl-mercadoria + 
              &if '{&BF_DIS_VERSAO_EMS}' >= '2.062' &then
               ordens-embarque.peso-liquido
              &else
               (ordens-embarque.peso-liquido * ordens-embarque.quantidade)
              &endif.
    &else
        ASSIGN tt-adicao.pl-mercadoria  = tt-adicao.pl-mercadoria + (DEC(SUBSTR(ordens-embarque.char-2,9,17))).
    &endif
    
    &if '{&BF_DIS_VERSAO_EMS}' >= '2.05' &then
        IF ordens-embarque.peso-liquido = 0 THEN 
    &else
        IF SUBSTR ( ordens-embarque.char-2,9,17 )  = "" THEN
    &endif
           ASSIGN tt-adicao.pl-mercadoria  = tt-adicao.pl-mercadoria + ITEM.peso-liquido.
    
    RUN pi-gera-mercadoria.

    IF i-cod-fabricante <> 0 THEN
       ASSIGN i-ident-fabricante = i-cod-fabricante.
    ELSE
    DO:
       FIND FIRST emitente WHERE emitente.cod-emitente = processo-imp.cod-fabricante NO-LOCK NO-ERROR.
       IF AVAIL emitente THEN DO:
           ASSIGN i-ident-fabricante = emitente.cod-emitente.
       END.
    END.

    IF i-ident-fabricante = processo-imp.cod-exportador THEN DO:

       FIND emitente NO-LOCK WHERE 
            emitente.cod-emitente = processo-imp.cod-exportador NO-ERROR.

       ASSIGN tt-adicao.cd-ausencia-fabrica = 1
              tt-adicao.nm-forn-estr        = IF AVAIL emitente THEN emitente.nome-emit ELSE ""
              tt-adicao.ed-logr-forn-estr   = IF AVAIL emitente THEN fnChar(emitente.endereco) ELSE ""
              tt-adicao.ed-cidad-forn-estr  = IF AVAIL emitente THEN fnChar(emitente.cidade) ELSE ""
              tt-adicao.ed-estad-forn-estr  = IF AVAIL emitente THEN fnChar(emitente.estado) ELSE "".
    END.
    ELSE DO:

       FIND emitente NO-LOCK WHERE 
             emitente.cod-emitente = processo-imp.cod-exportador NO-ERROR.
       ASSIGN tt-adicao.cd-ausencia-fabrica = 2
              tt-adicao.nm-forn-estr        = IF AVAIL emitente THEN emitente.nome-emit ELSE ""
              tt-adicao.ed-logr-forn-estr   = IF AVAIL emitente THEN fnChar(emitente.endereco) ELSE ""
              tt-adicao.ed-cidad-forn-estr  = IF AVAIL emitente THEN fnChar(emitente.cidade) ELSE ""
              tt-adicao.ed-estad-forn-estr  = IF AVAIL emitente THEN fnChar(emitente.estado) ELSE "".

       FIND emitente NO-LOCK WHERE 
            emitente.cod-emitente = i-ident-fabricante NO-ERROR.

       ASSIGN tt-adicao.nm-fabricante-mer   = IF AVAIL emitente THEN fnChar(emitente.nome-emit) ELSE ""
              tt-adicao.ed-logr-fabric      = IF AVAIL emitente THEN fnChar(emitente.endereco) ELSE ""
              tt-adicao.ed-cidad-fabric     = IF AVAIL emitente THEN fnChar(emitente.cidade) ELSE ""
              tt-adicao.ed-estado-fabric    = IF AVAIL emitente THEN fnChar(emitente.estado) ELSE "".
    END.

    RETURN "OK":U.
END PROCEDURE.


/* Geraá∆o de acrescimos */
PROCEDURE pi-gera-acrescimos:

    FIND FIRST tt-acrescimos EXCLUSIVE-LOCK
         WHERE tt-acrescimos.nr-ident-usuario = embarque-imp.embarque 
           AND tt-acrescimos.nr-adicao-usuario = sequencia NO-ERROR.
    
    IF NOT AVAIL tt-acrescimos THEN DO:
       CREATE tt-acrescimos.
       ASSIGN tt-acrescimos.nr-ident-usuario    = embarque-imp.embarque
              tt-acrescimos.nr-adicao-usuario   = sequencia
              tt-acrescimos.denominacao         = fnChar(desp-imp.descricao)
              tt-acrescimos.moeda               = desp-embarque.mo-codigo
              tt-acrescimos.vl-moeda            = desp-embarque.val-desp.

       RUN cdp/cd0812.p (INPUT  desp-embarque.mo-codigo,
                         INPUT  0,
                         INPUT  desp-embarque.val-desp, 
                         INPUT  today,            
                         OUTPUT tt-acrescimos.vl-real).
    END.

    RETURN "OK":U.
END PROCEDURE.


/* Geraá∆o de deducoes */
PROCEDURE pi-gera-deducoes:

    CREATE tt-deducoes.
    ASSIGN tt-deducoes.nr-ident-usuario    = embarque-imp.embarque
           tt-deducoes.nr-adicao-usuario   = sequencia
           tt-deducoes.denominacao         = fnChar(desp-imp.descricao)
           tt-deducoes.moeda               = desp-embarque.mo-codigo
           tt-deducoes.vl-moeda            = desp-embarque.val-desp.

    RUN cdp/cd0812.p (INPUT  desp-embarque.mo-codigo,
                      INPUT  0,
                      INPUT  desp-embarque.val-desp, 
                      INPUT  today,            
                      OUTPUT tt-acrescimos.vl-real).

    RETURN "OK":U.
END PROCEDURE.


/* Geraá∆o de parcelas */
PROCEDURE pi-gera-parcelas:

    FIND FIRST tt-parcelas EXCLUSIVE-LOCK
         WHERE tt-parcelas.nr-ident-usuario  = embarque-imp.embarque
           AND tt-parcelas.nr-adicao-usuario = sequencia 
           AND tt-parcelas.dt-prev-pgto-360  = invoice-emb-imp.dt-vencim NO-ERROR.
    IF NOT AVAIL tt-parcelas THEN DO:
       CREATE tt-parcelas.
       ASSIGN tt-parcelas.tp-registro         = 3
              tt-parcelas.nr-ident-usuario    = embarque-imp.embarque
              tt-parcelas.nr-adicao-usuario   = sequencia
              tt-parcelas.dt-prev-pgto-360    = invoice-emb-imp.dt-vencim.
    END.
    ASSIGN tt-parcelas.vl-prev-pgto-360       = tt-parcelas.vl-prev-pgto-360 + invoice-emb-imp.vl-invoice.

    RETURN "OK":U.
END PROCEDURE.


/* Geraá∆o de tributos */
PROCEDURE pi-gera-tributos:

    DEFINE VARIABLE l-gravado      AS LOGICAL NO-UNDO.
    DEFINE VARIABLE i-trib-ii-item AS INTEGER NO-UNDO.
    DEFINE VARIABLE i-trib-ii-nat  AS INTEGER NO-UNDO.

    {cxbo/bocx225e.i1} /* vari†veis atributo livre ordens-embarque */
    {cxbo/bocx225e.i2 NO ordens-embarque} /* busca valores atributos livres */

    /*
    ** Verifica se j† foram informados valores para o item nas ordens de embarque
    */
    IF i-trib-ii-i1       <> 0 OR
       i-trib-ipi-i1      <> 0 OR
       i-trib-icms-i1     <> 0 OR
       de-peso-bruto-i1   <> 0 OR
       de-peso-liquido-i1 <> 0 OR
       de-aliq-ii-i1      <> 0 OR
       de-aliq-ipi-i1     <> 0 OR
       de-aliq-icms-i1    <> 0 THEN
        ASSIGN l-gravado = YES.                        
    ELSE
        ASSIGN l-gravado = NO.

    /*Se n∆o encontrar na ordens-embarque*/
    IF NOT l-gravado THEN DO:

        FIND natur-oper NO-LOCK WHERE 
             natur-oper.nat-operacao = tt-param.nat-operacao NO-ERROR.

        /*Tributaá∆o ICMS*/
        RUN cdp/cd4302.p (INPUT item.cd-trib-icm,
                          INPUT natur-oper.cd-trib-icm,
                          OUTPUT i-trib-icms-i1).

        /*Al°quota ICMS*/
        FIND FIRST estabelec NO-LOCK WHERE
                   estabelec.cod-estabel = tt-param.estab-ini NO-ERROR.

        IF AVAIL estabelec THEN DO:

            FIND FIRST emitente NO-LOCK WHERE
                       emitente.cod-emitente = estabelec.cod-emitente NO-ERROR.

            RUN cdp/cd4301.p (INPUT (IF AVAIL emitente THEN emitente.contrib-icms
                                     ELSE YES),
                              INPUT (IF AVAIL emitente THEN emitente.natureza
                                     ELSE 2 /*"J"*/),
                              INPUT estabelec.estado /*estabelec.estado*/,
                              INPUT estabelec.pais,
                              INPUT estabelec.estado,
                              INPUT item.it-codigo,
                              INPUT natur-oper.aliquota-icm,
                              OUTPUT de-aliq-icms-i1).
        END.

        /*Tributaá∆o II*/
        ASSIGN i-trib-ii-item = INTEGER(TRIM(SUBSTRING(item.char-2,20,2)))
               i-trib-ii-nat  = INTEGER(SUBSTRING(natur-oper.char-1,10,2)).

        RUN imp/im9041.p (INPUT i-trib-ii-item,
                          INPUT i-trib-ii-nat,
                          OUTPUT i-trib-ii-i1).

        /*Al°quota II*/
        RUN imp/im9042.p (INPUT ordens-embarque.numero-ordem,
                          OUTPUT de-aliq-ii-i1).

        /*Tributaá∆o IPI*/
        RUN cdp/cd4303.p (INPUT item.cd-trib-ipi, 
                          INPUT natur-oper.cd-trib-ipi, 
                          OUTPUT i-trib-ipi-i1).

        /*Al°quota IPI*/
        {cdp/cd4300.i4 "yes" cotacao-item.char-2}
        &if '{&bf_mat_versao_ems}' >= '2.062' &then
            {ocp/oc0201.i51 "yes"}
        &else
            {ccp/cc0303.i51 "yes"}
        &endif

        IF i-regime-import-i50 <> 0 AND
           i-regime-import-i50 <> ? THEN
            ASSIGN de-aliq-ipi-i1 = cotacao-item.aliquota-ipi.
        ELSE DO:

            FOR FIRST param-re FIELDS (orig-aliq-ip)
                WHERE param-re.usuario = tt-param.usuario NO-LOCK:
            END.

            IF param-re.orig-aliq-ip = 1 THEN DO:
                FIND classif-fisc NO-LOCK WHERE
                     classif-fisc.class-fiscal = item.class-fiscal NO-ERROR.

                IF AVAIL classif-fisc THEN
                    ASSIGN de-aliq-ipi-i1 = classif-fisc.aliquota-ipi.
            END.
            ELSE
                ASSIGN de-aliq-ipi-i1 = item.aliquota-ipi.
        END.
    END.

    /*II*/
    IF i-trib-ii-i1 <> 0 THEN DO:
       CREATE tt-tributos.
       ASSIGN tt-tributos.tp-registro         = 4
              tt-tributos.nr-ident-usuario    = embarque-imp.embarque
              tt-tributos.nr-adicao-usuario   = sequencia
              tt-tributos.cd-receita-imposto  = 0001.

       CASE i-trib-ii-i1:
            WHEN 1 THEN ASSIGN tt-tributos.cd-tipo-benef-ipi = 1.
            WHEN 2 THEN ASSIGN tt-tributos.cd-tipo-benef-ipi = 3.
            WHEN 3 THEN ASSIGN tt-tributos.cd-tipo-benef-ipi = 1.
            WHEN 4 THEN ASSIGN tt-tributos.cd-tipo-benef-ipi = 4.
       END CASE.

       ASSIGN tt-tributos.pc-aliq-norm-adval = de-aliq-ii-i1
              tt-tributos.trib               = "II".

    END.

    /*IPI*/
    IF i-trib-ipi-i1 <> 0 THEN DO:

        CREATE tt-tributos.
        ASSIGN tt-tributos.tp-registro        = 4
               tt-tributos.nr-ident-usuario   = embarque-imp.embarque
               tt-tributos.nr-adicao-usuario  = sequencia
               tt-tributos.cd-receita-imposto = 0002.

        CASE i-trib-ipi-i1:
            WHEN 1 THEN ASSIGN tt-tributos.cd-tipo-benef-ipi = 1.
            WHEN 2 THEN ASSIGN tt-tributos.cd-tipo-benef-ipi = 3.
            WHEN 3 THEN ASSIGN tt-tributos.cd-tipo-benef-ipi = 1.
            WHEN 4 THEN ASSIGN tt-tributos.cd-tipo-benef-ipi = 4.
        END CASE.

        FIND FIRST natur-oper 
             WHERE natur-oper.nat-operacao = tt-param.nat-operacao NO-LOCK NO-ERROR.

        ASSIGN tt-tributos.pc-aliq-norm-adval = de-aliq-ipi-i1
               tt-tributos.pc-aliq-reduzida   = IF AVAIL natur-oper
                                                THEN natur-oper.perc-red-ipi 
                                                ELSE 0
               tt-tributos.trib               = "IPI".
    END.

    /*ICMS*/
    IF i-trib-icms-i1 <> 0 THEN DO:

        CREATE tt-tributos.
        ASSIGN tt-tributos.tp-registro        = 4
               tt-tributos.nr-ident-usuario   = embarque-imp.embarque
               tt-tributos.nr-adicao-usuario  = sequencia
               tt-tributos.cd-receita-imposto = 0003.

        CASE i-trib-icms-i1:
            WHEN 1 THEN ASSIGN tt-tributos.cd-tipo-benef-ipi = 1.
            WHEN 2 THEN ASSIGN tt-tributos.cd-tipo-benef-ipi = 3.
            WHEN 3 THEN ASSIGN tt-tributos.cd-tipo-benef-ipi = 1.
            WHEN 4 THEN ASSIGN tt-tributos.cd-tipo-benef-ipi = 4.
        END CASE.

        ASSIGN tt-tributos.pc-aliq-norm-adval = de-aliq-icms-i1
               tt-tributos.trib = "ICMS".
    END.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-gera-mercadoria:
    FIND FIRST tt-mercadoria 
         WHERE tt-mercadoria.nr-adicao-usuario = sequencia
           AND tt-mercadoria.cd-mercadoria     = ordem-compra.it-codigo
           AND tt-mercadoria.seq-item          = INT(SUBSTRING(ordens-embarque.char-1,80,4)) EXCLUSIVE-LOCK NO-ERROR.

    IF NOT AVAIL tt-mercadoria THEN DO:
        CREATE tt-mercadoria.
        ASSIGN tt-mercadoria.tp-registro        = 5
               tt-mercadoria.nr-ident-usuario   = embarque-imp.embarque
               tt-mercadoria.nr-adicao-usuario  = sequencia
               tt-mercadoria.cd-mercadoria      = ordem-compra.it-codigo.
    END.

    /*************************************************/
    IF l-fn-imp-adicao-un THEN DO:
        IF cotacao-item.un <> classif-fisc.unidade THEN DO:
            ASSIGN tt-mercadoria.qt-merc-un-comerc  = tt-mercadoria.qt-merc-un-comerc + (ordens-embarque.quantidade / item.fator-conver).
        END.
        ELSE
            ASSIGN tt-mercadoria.qt-merc-un-comerc  = tt-mercadoria.qt-merc-un-comerc + ordens-embarque.quantidade.
    END.         
    ELSE 
        ASSIGN tt-mercadoria.qt-merc-un-comerc  = tt-mercadoria.qt-merc-un-comerc + ordens-embarque.qt-do-forn.
    /*************************************************/
    ASSIGN tt-mercadoria.vl-unid-cond-venda     = de-preco-unit.

    IF NOT l-fn-imp-adicao-un THEN DO:
        FIND FIRST tab-unidade 
             WHERE tab-unidade.un = cotacao-item.un NO-LOCK NO-ERROR.
        IF AVAILABLE tab-unidade THEN
           ASSIGN tt-mercadoria.nm-un-medid-comer = tab-unidade.un.
    END.
    ELSE ASSIGN tt-mercadoria.nm-un-medid-comer = classif-fisc.unidade.

    ASSIGN tt-mercadoria.seq-item  = INT(SUBSTRING(ordens-embarque.char-1,80,4)).

    &IF '{&BF_MAT_VERSAO_EMS}' >= '2.07' &THEN
        ASSIGN tt-mercadoria.nr-adicao = ordens-embarque.num-adic.
    &ELSE
        ASSIGN tt-mercadoria.nr-adicao = INT(SUBSTRING(ordens-embarque.char-1,60,4)).    
    &ENDIF
    
    /*DESCRICAO*/
    FIND FIRST tt-descricao EXCLUSIVE-LOCK
         WHERE tt-descricao.nr-ident-usuario   = embarque-imp.embarque
           AND tt-descricao.nr-adicao-usuario  = sequencia
           AND tt-descricao.seq-item           = INT(SUBSTRING(ordens-embarque.char-1,80,4))
           NO-ERROR.
        IF NOT AVAIL tt-descricao THEN DO:
            CREATE tt-descricao.
            ASSIGN tt-descricao.tp-registro         = 6
                   tt-descricao.nr-ident-usuario    = embarque-imp.embarque
                   tt-descricao.nr-adicao-usuario   = sequencia
                   tt-descricao.seq-item            = INT(SUBSTRING(ordens-embarque.char-1,80,4))
                   tt-descricao.qt-merc-un-comerc   = tt-mercadoria.qt-merc-un-comerc
                   tt-descricao.vl-unid-cond-venda  = tt-mercadoria.vl-unid-cond-venda.
        END.
    /***********/
        
    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-geratxt-header:

    PUT tt-header.tp-registro           FORMAT "9" 
        tt-header.arquivo               FORMAT "x(30)" 
&IF "{&mguni_version}" >= "2.071" &THEN
        tt-header.cod-estabel           format "x(05)" 
&ELSE
        tt-header.cod-estabel           FORMAT "x(03)" 
&ENDIF
        tt-header.nome                  FORMAT "x(40)" 
        tt-header.embarque              FORMAT "x(16)" 
        STRING(DAY(tt-header.dt-geracao),"99") + 
        STRING(MONTH(tt-header.dt-geracao),"99") + 
        STRING(YEAR(tt-header.dt-geracao),"9999")
        tt-header.hora-geracao          FORMAT "x(06)" SKIP.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-geratxt-cabecalho:

    PUT tt-cabecalho.tp-registro                            FORMAT "9"                
        tt-cabecalho.nr-ident-usuario                       FORMAT "x(16)"            
        tt-cabecalho.cd-tipo-declaracao                     FORMAT ">9"               
        tt-cabecalho.cd-tipo-importador                     FORMAT "9"                
        tt-cabecalho.nr-importador                          FORMAT "x(14)"            
        tt-cabecalho.cd-pais-importador                     FORMAT ">>9"              
        tt-cabecalho.nr-cpf-repres-legal                    FORMAT "x(11)"
        tt-cabecalho.cd-via-transp-carg                     FORMAT ">9"
        tt-cabecalho.nm-transportador                       FORMAT "x(60)"            
        tt-cabecalho.nr-docto-carga                         FORMAT "x(18)"            
        tt-cabecalho.nr-docto-carga-master                  FORMAT "x(18)"            
        tt-cabecalho.nm-local-embarque                      FORMAT "x(50)"            
        string(year(tt-cabecalho.dt-embarque),"9999") + string(MONTH(tt-cabecalho.dt-embarque),"99") + string(DAY(tt-cabecalho.dt-embarque),"99")
        tt-cabecalho.nr-veiculo-transp                      FORMAT "x(15)"            
        tt-cabecalho.nm-veiculo-transp                      FORMAT "x(30)"            
        tt-cabecalho.cd-tipo-ag-carga                       FORMAT "9"                
        tt-cabecalho.nr-agente-carga                        FORMAT "x(14)"            
        tt-cabecalho.pb-carga                     * 100000  FORMAT "99999999999999999999" 
        tt-cabecalho.pl-carga                     * 100000  FORMAT "99999999999999999999" 
        tt-cabecalho.cd-tipo-consig                         FORMAT "9"                
        tt-cabecalho.nr-consignatario                       FORMAT "x(14)"            
        tt-cabecalho.nm-consignatario                       FORMAT "x(60)"            
        tt-cabecalho.cd-moeda-mle                           FORMAT ">>9"              
        tt-cabecalho.vl-tot-mle-mn                * 100     FORMAT ">>>>>>>>>>>>>>9" 
        tt-cabecalho.cd-moeda-frete                         FORMAT ">>9"              
        tt-cabecalho.vl-tot-frt-prepaid           * 100     FORMAT ">>>>>>>>>>>>>>9" 
        tt-cabecalho.vl-tot-frt-collect           * 100     FORMAT ">>>>>>>>>>>>>>9" 
        tt-cabecalho.vl-frete-tnac-mneg           * 100     FORMAT ">>>>>>>>>>>>>>9" 
        tt-cabecalho.cd-moeda-seguro                        FORMAT ">>9"              
        tt-cabecalho.vl-tot-seguro-mneg           * 100     FORMAT ">>>>>>>>>>>>>>9" 
        tt-cabecalho.fl-total-seg-mn              * 100     FORMAT ">>>>>>>>>>>>>>9" SKIP.
    
    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-geratxt-adicao:

    ASSIGN i-agencia = fnIntDig(tt-adicao.cd-agenc-agente-imp).

    PUT tt-adicao.tp-registro                               FORMAT "9"                  
        tt-adicao.nr-ident-usuario                          FORMAT "x(16)"
        tt-adicao.nr-adicao-usuario                         FORMAT ">>9"                
        tt-adicao.cd-ausencia-fabrica                       FORMAT "9"                
        tt-adicao.nm-forn-estr                              FORMAT "x(60)"              
        tt-adicao.ed-logr-forn-estr                         FORMAT "x(40)"              
        tt-adicao.ed-cidad-forn-estr                        FORMAT "x(25)"              
        tt-adicao.ed-estad-forn-estr                        FORMAT "x(25)"              
        tt-adicao.nm-fabricante-merc                        FORMAT "x(60)"              
        tt-adicao.ed-logr-fabric                            FORMAT "x(40)"              
        tt-adicao.ed-cidad-fabric                           FORMAT "x(25)"              
        tt-adicao.ed-estado-fabric                          FORMAT "x(25)"              
        tt-adicao.cd-mercadoria-ncm                         FORMAT "x(08)"
        tt-adicao.cd-merc-nbm-sh                            FORMAT "x(10)"         
        tt-adicao.cd-merc-naladi-sh                         FORMAT ">>>>>>>>>9"           
        tt-adicao.cd-merc-naladi-ncc                        FORMAT ">>>>>>>>>9"            
        tt-adicao.qt-un-estatistica              * 100000   FORMAT ">>>>>>>>>>>>>9"     
        tt-adicao.pl-mercadoria                  * 100000   FORMAT "999999999999999"  
        tt-adicao.cd-moeda-negociada                        FORMAT ">>9"               
        tt-adicao.cd-incoterms-venda                        FORMAT "x(03)"               
        tt-adicao.nm-loc-cond-venda                         FORMAT "x(60)"               
        tt-adicao.cd-tipo-agente-imp                        FORMAT "9"                   
        tt-adicao.nr-agente-imp                             FORMAT "x(14)"               
        tt-adicao.cd-banc-agente-imp                        FORMAT ">>>>9"              
        i-agencia                                           FORMAT ">>>9"                
        tt-adicao.qt-parc-financ-360                        FORMAT ">>9"                
        tt-adicao.qt-period-pgto-360                        FORMAT ">>9"               
        tt-adicao.vl-tot-financ-360              * 100      FORMAT ">>>>>>>>>>>>>>9"   
        tt-adicao.nr-rof                                    FORMAT "x(08)" SKIP.                 

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-geratxt-parcelas:
    PUT tt-parcelas.tp-registro                             FORMAT "9"
        tt-parcelas.nr-ident-usuario                        FORMAT "x(16)"
        tt-parcelas.nr-adicao-usuario                       FORMAT ">>9"              
        YEAR(tt-parcelas.dt-prev-pgto-360)                  FORMAT ">>>9"
        MONTH(tt-parcelas.dt-prev-pgto-360)                 FORMAT ">9"
        tt-parcelas.vl-prev-pgto-360              * 100     FORMAT ">>>>>>>>>>>>>>9" SKIP.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-geratxt-tributos:
    PUT tt-tributos.tp-registro                             FORMAT "9"                    
        tt-tributos.nr-ident-usuario                        FORMAT "x(16)"                
        tt-tributos.nr-adicao-usuario                       FORMAT ">>9"                  
        tt-tributos.cd-receita-imposto                      FORMAT ">>>9"
        tt-tributos.cd-tipo-benef-ipi                       FORMAT "9"                    
        tt-tributos.pc-aliq-norm-adval           * 100      FORMAT ">>>>9"
        tt-tributos.pc-aliq-reduzida             * 100      FORMAT ">>>>9" SKIP.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-geratxt-descricao:
    PUT tt-descricao.tp-registro                            FORMAT "9"                    
        tt-descricao.nr-ident-usuario                       FORMAT "x(16)"                
        tt-descricao.nr-adicao-usuario                      FORMAT ">>9"                  
        tt-descricao.seq-item                               FORMAT ">>>9"
        tt-descricao.qt-merc-un-comerc          * 100000    FORMAT ">>>>>>>>>>>>>9"
        tt-descricao.vl-unid-cond-venda         * 10000000  FORMAT ">>>>>>>>>>>>>>>>>>>9" SKIP.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-geratxt-mercadoria:
    PUT tt-mercadoria.tp-registro                           FORMAT "9"                    
        tt-mercadoria.nr-ident-usuario                      FORMAT "x(16)"                
        tt-mercadoria.nr-adicao-usuario                     FORMAT ">>9"                  
        tt-mercadoria.cd-mercadoria                         FORMAT "x(16)"
        i-soma-total                             * 100000   FORMAT ">>>>>>>>>>>>>9"
        /*tt-mercadoria.qt-merc-un-comerc          * 100000   FORMAT ">>>>>>>>>>>>>9"      */
        tt-mercadoria.nm-un-medid-comer                     FORMAT "x(20)"                
        tt-mercadoria.vl-unid-cond-venda         * 10000000 FORMAT ">>>>>>>>>>>>>>>>>>>9"
        tt-mercadoria.vl-unid-loc-bem            * 100      FORMAT ">>>>>>>>>>>>9"
        /*tt-mercadoria.nr-adicao                             FORMAT ">>>9"*/ SKIP.

    RETURN "OK":U.                                  
END PROCEDURE.


PROCEDURE pi-cria-grava-adicao:
    CREATE tt-adicao.
    ASSIGN tt-adicao.tp-registro        = 2
           tt-adicao.nr-ident-usuario   = embarque-imp.embarque      
           tt-adicao.nr-adicao-usuario  = sequencia                  
           tt-adicao.cd-mercadoria-ncm  = string(classif-fisc.class-fiscal)
           tt-adicao.cd-merc-nbm-sh     = string(classif-fisc.class-fiscal)
           tt-adicao.cd-merc-naladi-sh  = classif-fisc.cod-naladi-sh
           tt-adicao.cd-merc-naladi-ncc = classif-fisc.cod-naladi
           tt-adicao.it-codigo          = ITEM.it-codigo
           tt-adicao.cd-moeda-negociada = ordem-compra.mo-codigo
           tt-adicao.cd-incoterms-venda = embarque-imp.cod-incoterm.

    IF i-parcelas = 0 AND d-valor-pago = 0 THEN
    DO:
        FOR EACH invoice-emb-imp WHERE invoice-emb-imp.cod-estabel  = embarque-imp.cod-estabel
                                   AND invoice-emb-imp.embarque     = embarque-imp.embarque NO-LOCK:
            ASSIGN i-parcelas   = i-parcelas    + 1
                   d-valor-pago = d-valor-pago  + invoice-emb-imp.vl-invoice.
            RUN pi-gera-parcelas.
        END.

    END.

    ASSIGN tt-adicao.qt-parc-financ-360 = i-parcelas
           tt-adicao.vl-tot-financ-360  = d-valor-pago
           tt-adicao.nr-rof             = embarque-imp.nr-rof.


    FIND FIRST emitente WHERE emitente.cod-emitente = processo-imp.cod-agente NO-LOCK NO-ERROR.

    IF AVAIL emitente THEN DO:
        ASSIGN tt-adicao.cd-tipo-agente-imp  = IF emitente.natureza = 1 THEN 2 ELSE 1 .
           &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
               ASSIGN cAuxTraducao003 = {adinc/i03ad098.i 04 emitente.natureza}.
               run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao003)," ","_"), INPUT "", INPUT "").
               ASSIGN tt-adicao.desc-agente         = RETURN-VALUE.
           &else
               ASSIGN tt-adicao.desc-agente         = {adinc/i03ad098.i 04 emitente.natureza}.
           &endif
           tt-adicao.nr-agente-imp       = emitente.cgc.
    END.
    ELSE
        ASSIGN tt-adicao.cd-tipo-agente-imp  = 0
               tt-adicao.desc-agente         = ""
               tt-adicao.nr-agente-imp       = ""
               tt-adicao.cd-banc-agente-imp  = 0
               tt-adicao.cd-agenc-agente-imp = "".

    FIND FIRST cond-pagto WHERE cond-pagto.cod-cond-pag = ordem-compra.cod-cond-pag NO-LOCK NO-ERROR.
    IF AVAILABLE cond-pagto THEN
    DO:
        IF cond-pagto.cod-vencto <> 2 AND 
           cond-pagto.cod-vencto <> 3 AND       
           cond-pagto.cod-vencto <> 4 THEN DO:

           DEF VAR i AS INTEGER NO-UNDO.

           DO i = 1 TO 12:
              IF cond-pagto.prazos[i] <> 0 THEN
                 ASSIGN tt-adicao.qt-period-pgto-360 = cond-pagto.prazos[i].
           END.

        END.
    END.

    RUN pi-gera-tributos.

END PROCEDURE.

