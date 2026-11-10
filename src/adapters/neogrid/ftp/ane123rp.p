/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANE123RP 2.00.01.007}  /*** 010107 ***/



&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ane123rp MAN}
&ENDIF

{cdp/cdcfgdis.i}
{include/i-epc200.i "ane123rp"}

DEF TEMP-TABLE tt-param NO-UNDO
    FIELD l-preco-padrao    AS LOG
    FIELD l-estrut-comerc   AS LOG
    FIELD l-item-estab      AS LOG
    FIELD l-referencia      AS LOG
    FIELD l-item-refer      AS LOG
    FIELD l-portador        AS LOG
    FIELD l-item-cliente    AS LOG
    FIELD l-parametros      AS LOG
    FIELD l-un-neg          AS LOG
    FIELD l-un-neg-fam      AS LOG
    FIELD l-un-neg-item     AS LOG
    FIELD destino           AS INTEGER
    FIELD arquivo           AS CHAR    FORMAT "x(35)"
    FIELD usuario           AS CHAR    FORMAT "x(12)"
    FIELD data-exec         AS DATE
    FIELD hora-exec         AS INTEGER
    FIELD l-motivo-cancel   AS LOGICAL
    FIELD l-empresa         AS LOGICAL
    FIELD l-estab           AS LOGICAL
    FIELD l-serie           AS LOGICAL
    FIELD l-natur-oper      AS LOGICAL
    FIELD l-cond-pagto      AS LOGICAL
    FIELD l-moeda           AS LOGICAL
    FIELD l-item            AS LOGICAL
    FIELD l-unid-med        AS LOGICAL
    FIELD l-item-fornec     AS LOGICAL
    FIELD l-grupo-cliente   AS LOGICAL
    FIELD l-cliente         AS LOGICAL
    FIELD l-fornecedor      AS LOGICAL
    FIELD l-transportador   AS LOGICAL
    FIELD l-via-transporte  AS LOGICAL
    FIELD l-repres          AS LOGICAL
    FIELD l-regiao          AS LOGICAL
    FIELD l-usuario         AS LOGICAL
    FIELD l-tab-preco       AS LOGICAL
    FIELD l-ped-venda       AS LOGICAL
    FIELD l-info-cred       AS LOGICAL
    FIELD f-data-pedv-ini   AS DATE
    FIELD f-data-pedv-fim   AS DATE
    FIELD l-nota-fiscal     AS LOGICAL
    FIELD f-data-nf-ini     AS DATE
    FIELD f-data-nf-fim     AS DATE
    FIELD f-cod-emit-ini    AS INTEGER
    FIELD f-cod-emit-fim    AS INTEGER
    FIELD f-item-ini        AS CHAR
    FIELD f-item-fim        AS CHAR
    FIELD f-refer-ini        AS CHAR
    FIELD f-refer-fim        AS CHAR
    FIELD f-nome-abrev-ini  AS CHAR 
    FIELD f-nome-abrev-fim  AS CHAR 
    FIELD l-canal-venda     AS LOGICAL
    FIELD l-tp-rec-desp     AS LOGICAL
    FIELD i-selecao-cli     AS INTEGER
    FIELD l-cotacoes-moedas AS LOGICAL
    FIELD f-periodo-cotacao-ini AS CHAR
    FIELD f-periodo-cotacao-fim AS CHAR
    FIELD l-unid-feder      AS LOGICAL
    FIELD f-pais-ini        AS CHAR
    FIELD f-pais-fim        AS CHAR
    FIELD f-estado-ini      AS CHAR
    FIELD f-estado-fim      AS CHAR
    FIELD i-destino-dados   AS INTEGER FORMAT '9'
    FIELD c-itens-export    AS CHAR
    FIELD c-tab-pre-ini     AS CHAR
    FIELD c-tab-pre-fim     AS CHAR
    FIELD l-cidades-zfm     AS LOGICAL
    FIELD char-1            AS CHAR
    FIELD char-2            AS CHAR.

def temp-table tt-b2b
    field cod-estabel        like nota-fiscal.cod-estabel
    field serie              like nota-fiscal.serie
    field nr-nota-fis        like nota-fiscal.nr-nota-fis
    field cod-emitente       like nota-fiscal.cod-emitente
    field nome-abrev         like nota-fiscal.nome-ab-cli
    index estabel-serie-nota is primary unique
          cod-estabel
          serie
          nr-nota-fis.

DEF TEMP-TABLE tt-raw-digita NO-UNDO
    FIELD raw-digita AS RAW.

/* recebimento de parƒmetros */
DEF INPUT PARAM raw-param AS RAW NO-UNDO.
DEF INPUT PARAM TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

{utp/ut-glob.i}

/* include padrÆo para vari veis de relat¢rio */
{include/i-rpvar.i}

/* defini‡Æo de vari veis  */
DEF VAR h-acomp         AS HANDLE              NO-UNDO.
DEF VAR c-traduz        AS CHAR FORMAT "x(20)" NO-UNDO.
DEF VAR c-texto         AS CHAR FORMAT "x(20)" NO-UNDO.
DEF VAR c-repres        AS CHAR FORMAT "x(35)" NO-UNDO.
DEF VAR c-periodo       AS CHAR FORMAT "x(35)" NO-UNDO.
DEF VAR c-destino-dados AS CHAR FORMAT "x(10)" NO-UNDO.
DEF VAR l-export-fatur  AS LOG                 NO-UNDO.
DEF VAR l-export-ambos  AS LOG  INIT NO        NO-UNDO.
DEF VAR l-transpxml     AS LOGICAL             NO-UNDO. 

DEF VAR c-adapter AS CHAR NO-UNDO.

ASSIGN c-destino-dados = IF  tt-param.i-destino-dados = 1
                         THEN "Neogrid"
                         ELSE "CRM".

/* Itens a Exportar: Fatur veis | NÆo Fatur veis | Ambos */
IF c-itens-export = "Faturáveis" THEN 
       ASSIGN l-export-fatur = YES.

 ELSE IF c-itens-export = "Não Faturáveis" THEN 
       ASSIGN l-export-fatur = NO. 

  ELSE
       ASSIGN l-export-ambos = YES.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

{utp/ut-liter.i Gerando_dados... *}
RUN pi-inicializar IN h-acomp (INPUT return-value).

/* include padrÆo para output de relat¢rios */
{include/i-rpout.i}

/* include com a defini‡Æo da frame de cabe‡alho e rodap‚ */
{include/i-rpcab.i}

{utp/ut-liter.i Gerador_de_Dados *}
ASSIGN c-programa 	  = "ANE123RP"
       c-versao	      = "2.00"
       c-revisao	  = ".00.000"
       c-titulo-relat = return-value.

VIEW FRAME f-cabec.
VIEW FRAME f-rodape.

/* bloco principal do programa */
FOR FIRST empresa FIELDS (ep-codigo razao-social)
    WHERE empresa.ep-codigo = i-ep-codigo-usuario NO-LOCK:
    ASSIGN c-empresa = empresa.razao-social.
END.

RUN pi-GeraDados.
PAGE.
RUN pi-impressao-parametros.

/* fechamento do output do relat¢rio */
{include/i-rpclo.i}

RUN pi-finalizar IN h-acomp.
RETURN "OK":U.

/******************************** PROCEDIMENTOS INTERNOS ********************************/
PROCEDURE pi-GeraDados:
    FIND FIRST tt-param NO-ERROR.

    /* Motivo de Cancelamento/Reprovação  */
    IF  tt-param.l-motivo-cancel THEN DO:
        IF  c-destino-dados = "CRM" THEN
            RUN adapters/neogrid/ftp/aneft007.p (INPUT ?,
                                                 INPUT tt-param.i-destino-dados,
                                                 INPUT "adapters/neogrid/pdp/anepd055.p").
    END.
    
    /* Empresa */
    IF  tt-param.l-empresa THEN DO:
        IF  c-destino-dados = "CRM" THEN
            RUN adapters/neogrid/ftp/aneft007.p (INPUT ?,
                                                 INPUT tt-param.i-destino-dados,
                                                 INPUT "adapters/neogrid/pdp/anepd037.p").
    END.
    /* Estabelecimento */
    IF  tt-param.l-estab THEN DO:
        IF  c-destino-dados = "CRM" THEN
            RUN adapters/neogrid/ftp/aneft007.p (INPUT ?,
                                                 INPUT tt-param.i-destino-dados,
                                                 INPUT "adapters/neogrid/pdp/anepd058.p").
        ELSE
            RUN adapters/neogrid/ftp/aneft007.p (INPUT ?,
                                                 INPUT tt-param.i-destino-dados,
                                                 INPUT "adapters/neogrid/pdp/anepd008.p").
    END.
    /* Serie */
    IF  tt-param.l-serie THEN DO:
        IF  c-destino-dados = "CRM" THEN
            RUN adapters/neogrid/ftp/aneft007.p (INPUT ?,
                                                 INPUT tt-param.i-destino-dados,
                                                 INPUT "adapters/neogrid/ftp/aneft054.p").
        ELSE
            RUN adapters/neogrid/ftp/aneft007.p (INPUT ?,
                                                 INPUT tt-param.i-destino-dados,
                                                 INPUT "adapters/neogrid/ftp/aneft004.p").
    END.

    /* Natureza de Operacao */
    IF  tt-param.l-natur-oper THEN
        FOR EACH natur-oper FIELDS (nat-operacao) NO-LOCK:
            RUN pi-acompanhar IN h-acomp (natur-oper.nat-operacao).
            IF  c-destino-dados = "CRM" THEN
                RUN adapters/neogrid/ftp/aneft007.p (INPUT ROWID(natur-oper),
                                                     INPUT tt-param.i-destino-dados,
                                                     INPUT "adapters/neogrid/ftp/aneft053.p").
            ELSE
                RUN adapters/neogrid/ftp/aneft007.p (INPUT ROWID(natur-oper),
                                                     INPUT tt-param.i-destino-dados,
                                                     INPUT "adapters/neogrid/ftp/aneft003.p").
        END.

    /* Condicao de Pagamento */
    IF  tt-param.l-cond-pagto THEN
        FOR EACH cond-pagto FIELDS (cod-cond-pag) NO-LOCK:
            RUN pi-acompanhar IN h-acomp (STRING(cond-pagto.cod-cond-pag)).
            IF  c-destino-dados = "CRM" THEN
                RUN adapters/neogrid/ftp/aneft007.p (INPUT ROWID(cond-pagto),
                                                     INPUT tt-param.i-destino-dados,
                                                     INPUT "adapters/neogrid/ccp/anecc060.p").
            ELSE
                RUN adapters/neogrid/ftp/aneft007.p (INPUT ROWID(cond-pagto),
                                                     INPUT tt-param.i-destino-dados,
                                                     INPUT "adapters/neogrid/ccp/anecc010.p").
        END.

    /* Moeda */    
    IF  tt-param.l-moeda THEN DO:
        IF  c-destino-dados = "CRM" THEN
            RUN adapters/neogrid/ftp/aneft007.p (INPUT ?,
                                                 INPUT tt-param.i-destino-dados,
                                                 INPUT "adapters/neogrid/ccp/anecc061.p").
        ELSE
            RUN adapters/neogrid/ftp/aneft007.p (INPUT ?,
                                                 INPUT tt-param.i-destino-dados,
                                                 INPUT "adapters/neogrid/ccp/anecc011.p").
    END.

    /* Item */    
    IF  tt-param.l-item THEN
     IF l-export-ambos  THEN
         FOR EACH ITEM FIELDS (it-codigo) NO-LOCK
             WHERE ITEM.it-codigo >= f-item-ini 
             AND   ITEM.it-codigo <= f-item-fim 
             OR   (c-destino-dados   = "Neogrid"
                   AND  item.compr-fabric = 1
                   AND ITEM.it-codigo >= f-item-ini
                   AND ITEM.it-codigo <= f-item-fim):
             RUN pi-acompanhar IN h-acomp (ITEM.it-codigo).
             IF  c-destino-dados = "CRM" THEN
                 RUN adapters/neogrid/ftp/aneft007.p (INPUT ROWID(ITEM),
                                                      INPUT tt-param.i-destino-dados,
                                                      INPUT "adapters/neogrid/enp/aneen055.p").
             ELSE
                 RUN adapters/neogrid/ftp/aneft007.p (INPUT ROWID(ITEM),
                                                      INPUT tt-param.i-destino-dados,
                                                      INPUT "adapters/neogrid/enp/aneen005.p").
         END.
     ELSE
         FOR EACH ITEM FIELDS (it-codigo) NO-LOCK
            WHERE item.ind-item-fat = l-export-fatur      
            AND   ITEM.it-codigo >= f-item-ini 
            AND   ITEM.it-codigo <= f-item-fim 
            OR   (c-destino-dados   = "Neogrid"
                   AND item.compr-fabric = 1
                   AND item.ind-item-fat = l-export-fatur 
                   AND ITEM.it-codigo >= f-item-ini 
                   AND ITEM.it-codigo <= f-item-fim ):
            RUN pi-acompanhar IN h-acomp (ITEM.it-codigo).
            IF  c-destino-dados = "CRM" THEN
                RUN adapters/neogrid/ftp/aneft007.p (INPUT ROWID(ITEM),
                                                     INPUT tt-param.i-destino-dados,
                                                     INPUT "adapters/neogrid/enp/aneen055.p").
            ELSE
                RUN adapters/neogrid/ftp/aneft007.p (INPUT ROWID(ITEM),
                                                     INPUT tt-param.i-destino-dados,
                                                     INPUT "adapters/neogrid/enp/aneen005.p").
         END.


    /* Unidade de Medida */
    IF  tt-param.l-unid-med THEN DO:
        IF  c-destino-dados = "CRM" THEN
            RUN adapters/neogrid/ftp/aneft007.p (INPUT ?,
                                                 INPUT tt-param.i-destino-dados,
                                                 INPUT "adapters/neogrid/enp/aneen056.p").
        ELSE
            RUN adapters/neogrid/ftp/aneft007.p (INPUT ?,
                                                 INPUT tt-param.i-destino-dados,
                                                 INPUT "adapters/neogrid/enp/aneen006.p").
    END.

    /* Item Fornecedor */    
    IF  tt-param.l-item-fornec THEN
        FOR EACH  item-fornec FIELDS (cod-emitente) NO-LOCK:
            RUN pi-acompanhar IN h-acomp (STRING(item-fornec.cod-emitente)).
            RUN adapters/neogrid/ftp/aneft007.p (INPUT ROWID(item-fornec),
                                                 INPUT tt-param.i-destino-dados,
                                                 INPUT "adapters/neogrid/ccp/anecc013.p").
        END.

    /* Tabela de Pre‡o */                                                            
    IF tt-param.l-tab-preco THEN                                                     
        FOR EACH tb-preco FIELDS (nr-tabpre) NO-LOCK
            WHERE tb-preco.nr-tabpre >= tt-param.c-tab-pre-ini
            AND   tb-preco.nr-tabpre <= tt-param.c-tab-pre-fim:
            RUN pi-acompanhar IN h-acomp (tb-preco.nr-tabpre).
            IF  c-destino-dados = "CRM" THEN
                RUN adapters/neogrid/ftp/aneft007.p (INPUT ROWID(tb-preco),
                                                     INPUT tt-param.i-destino-dados,
                                                     INPUT "adapters/neogrid/pdp/anepd062.p").
            ELSE
                RUN adapters/neogrid/ftp/aneft007.p (INPUT ROWID(tb-preco),
                                                     INPUT tt-param.i-destino-dados,
                                                     INPUT "adapters/neogrid/pdp/anepd012.p").
        END.

    /* Grupo de Clientes */
    IF  tt-param.l-grupo-cliente THEN
        FOR EACH gr-cli FIELDS (cod-gr-cli) NO-LOCK:
            RUN pi-acompanhar IN h-acomp (STRING(gr-cli.cod-gr-cli)).
            IF  c-destino-dados = "CRM" THEN
                RUN adapters/neogrid/ftp/aneft007.p (INPUT ROWID(gr-cli),
                                                     INPUT tt-param.i-destino-dados,
                                                     INPUT "adapters/neogrid/pdp/anepd061.p").
            ELSE
                RUN adapters/neogrid/ftp/aneft007.p (INPUT ROWID(gr-cli),
                                                     INPUT tt-param.i-destino-dados,
                                                     INPUT "adapters/neogrid/pdp/anepd011.p").
        END.

    /* Cliente / Fornecedor CRM */    
    IF  tt-param.l-cliente OR (tt-param.l-fornecedor AND tt-param.i-destino-dados = 2) THEN
        IF  i-selecao-cli = 1 THEN  /* classifica‡Æo por c¢digo */
            FOR EACH  emitente FIELDS (nome-abrev) NO-LOCK USE-INDEX codigo 
                WHERE emitente.cod-emitente >= f-cod-emit-ini
                AND   emitente.cod-emitente <= f-cod-emit-fim
                AND   IF l-cliente AND l-fornecedor THEN YES
                      ELSE IF l-cliente THEN emitente.identific <> 2
                      ELSE IF l-fornecedor THEN emitente.identific <> 1
                      ELSE NO :
                RUN pi-acompanhar IN h-acomp (emitente.nome-abrev).
                IF  c-destino-dados = "CRM" THEN
                    RUN adapters/neogrid/ftp/aneft007.p (INPUT ROWID(emitente),
                                                         INPUT tt-param.i-destino-dados,
                                                         INPUT "adapters/neogrid/ftp/aneft055.p").
                ELSE
                    RUN adapters/neogrid/ftp/aneft007.p (INPUT ROWID(emitente),
                                                         INPUT tt-param.i-destino-dados,
                                                         INPUT "adapters/neogrid/ftp/aneft005.p").
            END.
        ELSE  /* classifica‡Æo por nome abreviado */
            FOR EACH  emitente FIELDS (nome-abrev) NO-LOCK USE-INDEX nome
                WHERE emitente.nome-abrev >= f-nome-abrev-ini
                AND   emitente.nome-abrev <= f-nome-abrev-fim
                AND   IF l-cliente AND l-fornecedor THEN YES
                      ELSE IF l-cliente THEN emitente.identific <> 2
                      ELSE IF l-fornecedor THEN emitente.identific <> 1
                      ELSE NO :
                RUN pi-acompanhar IN h-acomp (emitente.nome-abrev).
                IF  c-destino-dados = "CRM" THEN
                    RUN adapters/neogrid/ftp/aneft007.p (INPUT ROWID(emitente),
                                                         INPUT tt-param.i-destino-dados,
                                                         INPUT "adapters/neogrid/ftp/aneft055.p").
                ELSE
                    RUN adapters/neogrid/ftp/aneft007.p (INPUT ROWID(emitente),
                                                         INPUT tt-param.i-destino-dados,
                                                         INPUT "adapters/neogrid/ftp/aneft005.p").
            END.


    /* Fornecedor */
    IF  tt-param.l-fornecedor AND tt-param.i-destino-dados = 1 THEN
        IF  i-selecao-cli = 1 THEN  /* classifica‡Æo por c¢digo */
            FOR EACH  emitente FIELDS (nome-abrev) NO-LOCK USE-INDEX codigo 
                WHERE emitente.cod-emitente >= f-cod-emit-ini
                AND   emitente.cod-emitente <= f-cod-emit-fim
                AND   emitente.identific    <> 1:
                RUN pi-acompanhar IN h-acomp (emitente.nome-abrev).
                RUN adapters/neogrid/ftp/aneft007.p (INPUT ROWID(emitente),
                                                     INPUT tt-param.i-destino-dados,
                                                     INPUT "adapters/neogrid/ccp/anecc012.p").
            END.
        ELSE  /* classifica‡Æo por nome abreviado */
            FOR EACH  emitente FIELDS (nome-abrev) NO-LOCK USE-INDEX nome
                WHERE emitente.nome-abrev >= f-nome-abrev-ini
                AND   emitente.nome-abrev <= f-nome-abrev-fim
                AND   emitente.identific  <> 1:
                RUN pi-acompanhar IN h-acomp (emitente.nome-abrev).
                RUN adapters/neogrid/ftp/aneft007.p (INPUT ROWID(emitente),
                                                     INPUT tt-param.i-destino-dados,
                                                     INPUT "adapters/neogrid/ccp/anecc012.p").
            END.

    /* Transportador */
    IF  tt-param.l-transportador THEN DO:

        ASSIGN l-transpxml = CAN-FIND( FIRST funcao
                                       WHERE funcao.cd-funcao = "spp-transpxml":U
                                         AND funcao.ativo).

        IF l-transpxml THEN  DO:
            
            FOR EACH transporte FIELDS (cod-transp) NO-LOCK:
                
                RUN pi-acompanhar IN h-acomp ("Transportador " + STRING(transporte.cod-transp)).

                IF  c-destino-dados = "CRM" THEN
                    RUN adapters/neogrid/ftp/aneft007.p (INPUT ROWID(transporte),
                                                         INPUT tt-param.i-destino-dados,
                                                         INPUT "adapters/neogrid/pdp/anepd057.p").
                ELSE
                    RUN adapters/neogrid/ftp/aneft007.p (INPUT ROWID(transporte),
                                                         INPUT tt-param.i-destino-dados,
                                                         INPUT "adapters/neogrid/pdp/anepd007.p").
            END.
          
        END.
        ELSE DO:
        
            IF  c-destino-dados = "CRM" THEN
                RUN adapters/neogrid/ftp/aneft007.p (INPUT ?,
                                                     INPUT tt-param.i-destino-dados,
                                                     INPUT "adapters/neogrid/pdp/anepd057.p").
            ELSE
                RUN adapters/neogrid/ftp/aneft007.p (INPUT ?,
                                                     INPUT tt-param.i-destino-dados,
                                                     INPUT "adapters/neogrid/pdp/anepd007.p").
        END.
    END.

    /* Via Transporte */
    IF  tt-param.l-via-transporte THEN
        RUN adapters/neogrid/ftp/aneft007.p (INPUT ?,
                                             INPUT tt-param.i-destino-dados,
                                             INPUT "adapters/neogrid/ftp/aneft006.p").

    /* Representante */    
    IF  tt-param.l-repres THEN
        FOR EACH repres FIELDS (cod-rep) NO-LOCK:
            RUN pi-acompanhar IN h-acomp (STRING(repres.cod-rep)).
            IF  c-destino-dados = "CRM" THEN
                RUN adapters/neogrid/ftp/aneft007.p (INPUT ROWID(repres),
                                                     INPUT tt-param.i-destino-dados,
                                                     INPUT "adapters/neogrid/pdp/anepd059.p").
            ELSE
                RUN adapters/neogrid/ftp/aneft007.p (INPUT ROWID(repres),
                                                     INPUT tt-param.i-destino-dados,
                                                     INPUT "adapters/neogrid/pdp/anepd009.p").
        END.

    /* Regiao */    
    IF  tt-param.l-regiao THEN
        FOR EACH regiao FIELDS (nome-ab-reg) NO-LOCK:
            RUN pi-acompanhar IN h-acomp (regiao.nome-ab-reg).
            IF  c-destino-dados = "CRM" THEN
                RUN adapters/neogrid/ftp/aneft007.p (INPUT ROWID(regiao),
                                                     INPUT tt-param.i-destino-dados,
                                                     INPUT "adapters/neogrid/pdp/anepd060.p").
            ELSE
                RUN adapters/neogrid/ftp/aneft007.p (INPUT ROWID(regiao),
                                                     INPUT tt-param.i-destino-dados,
                                                     INPUT "adapters/neogrid/pdp/anepd010.p").
        END.

    /* Usuario */    
    IF  tt-param.l-usuario THEN DO:
        IF  c-destino-dados = "CRM" THEN
            RUN adapters/neogrid/ftp/aneft007.p (INPUT ?,
                                                 INPUT tt-param.i-destino-dados,
                                                 INPUT "adapters/neogrid/ftp/aneft058.p").
        ELSE
            RUN adapters/neogrid/ftp/aneft007.p (INPUT ?,
                                                 INPUT tt-param.i-destino-dados,
                                                 INPUT "adapters/neogrid/ftp/aneft008.p").
    END.


    /* Nota Fiscal*/    
    IF  tt-param.l-nota-fiscal THEN
        FOR EACH nota-fiscal FIELDS(dt-emis-nota esp-doc) NO-LOCK
            WHERE nota-fiscal.dt-emis-nota >= f-data-nf-ini
            AND   nota-fiscal.dt-emis-nota <= f-data-nf-fim:

            IF  c-destino-dados = "CRM" THEN
                ASSIGN c-adapter = "1,0".
            ELSE 
                ASSIGN c-adapter = "0,1".


            RUN ftp/ft2100d.p (INPUT ROWID(nota-fiscal),
                               INPUT-OUTPUT TABLE tt-b2b,
                               INPUT c-adapter).
        END.

    /* Pedido Venda */    
    IF  tt-param.l-ped-venda THEN
        FOR EACH  ped-venda FIELDS (nr-pedido) NO-LOCK
            WHERE ped-venda.dt-implant >= f-data-pedv-ini
            AND   ped-venda.dt-implant <= f-data-pedv-fim
            AND   ped-venda.completo    = YES:
            RUN pi-acompanhar IN h-acomp (STRING(ped-venda.nr-pedido)).
            IF  c-destino-dados   = "Neogrid" THEN
                RUN adapters/neogrid/pdp/anepd004.p (INPUT ROWID(ped-venda),
                                                     INPUT "CHANGE").
            ELSE
                RUN adapters/neogrid/pdp/anepd016.p (INPUT ROWID(ped-venda),
                                                     INPUT "CHANGE").
        END.


    /* Canal Venda */
    IF  tt-param.l-canal-venda THEN
        FOR EACH canal-venda FIELDS (cod-canal-venda) NO-LOCK:
            RUN pi-acompanhar IN h-acomp (STRING(canal-venda.cod-canal-venda)).
            IF  c-destino-dados = "CRM" THEN
                RUN adapters/neogrid/ftp/aneft007.p (INPUT ROWID(canal-venda),
                                                     INPUT tt-param.i-destino-dados,
                                                     INPUT "adapters/neogrid/pdp/anepd064.p").
            ELSE
                RUN adapters/neogrid/ftp/aneft007.p (INPUT ROWID(canal-venda),
                                                     INPUT tt-param.i-destino-dados,
                                                     INPUT "adapters/neogrid/pdp/anepd014.p").
        END.

    /* Tipo Receita/Despesa */
    IF  tt-param.l-tp-rec-desp THEN DO:
        IF  c-destino-dados = "CRM" THEN
            RUN adapters/neogrid/ftp/aneft007.p (INPUT ?,
                                                 INPUT tt-param.i-destino-dados,
                                                 INPUT "adapters/neogrid/ftp/aneft059.p").
        ELSE
            RUN adapters/neogrid/ftp/aneft007.p (INPUT ?,
                                                 INPUT tt-param.i-destino-dados,
                                                 INPUT "adapters/neogrid/ftp/aneft009.p").
    END.


    /* Informa‡äes Cr‚dito */
    IF  tt-param.l-info-cred THEN
        IF  i-selecao-cli = 1 THEN  /* classifica‡Æo por c¢digo */
            FOR EACH  emitente FIELDS (nome-abrev) NO-LOCK USE-INDEX codigo 
                WHERE emitente.cod-emitente >= f-cod-emit-ini
                AND   emitente.cod-emitente <= f-cod-emit-fim
                AND   emitente.identific    <> 2:

                    RUN pi-acompanhar IN h-acomp (emitente.nome-abrev).
                    IF  c-destino-dados = "CRM" THEN
                        RUN adapters/neogrid/ftp/aneft060.p (INPUT ROWID(emitente)).
                    ELSE
                        RUN adapters/neogrid/ftp/aneft010.p (INPUT ROWID(emitente)).
            END.
        ELSE  /* classifica‡Æo por nome abreviado */
            FOR EACH  emitente FIELDS (nome-abrev) NO-LOCK USE-INDEX nome
                WHERE emitente.nome-abrev >= f-nome-abrev-ini
                AND   emitente.nome-abrev <= f-nome-abrev-fim
                AND   emitente.identific  <> 2:

                    RUN pi-acompanhar IN h-acomp (emitente.nome-abrev).
                    IF  c-destino-dados = "CRM" THEN
                        RUN adapters/neogrid/ftp/aneft060.p (INPUT ROWID(emitente)).
                    ELSE
                        RUN adapters/neogrid/ftp/aneft010.p (INPUT ROWID(emitente)).
            END.

    /* Item Cliente */
    IF tt-param.l-item-cliente THEN
        IF i-selecao-cli = 1 THEN /* Classifica‡Æo Por C¢digo */
            FOR EACH item-cli NO-LOCK
                WHERE item-cli.cod-emitente >= f-cod-emit-ini
                AND item-cli.cod-emitente <= f-cod-emit-fim
                AND item-cli.it-codigo >= f-item-ini
                AND item-cli.it-codigo <= f-item-fim:
                    
                    RUN pi-acompanhar IN h-acomp (item-cli.it-codigo).
                    IF c-destino-dados = "CRM" THEN
                        RUN adapters/neogrid/pdp/anepd032.p (INPUT ROWID(item-cli), INPUT "CHANGE").
            END.
        ELSE /* Classifica‡Æo Por Nome Abreviado */
            FOR EACH item-cli NO-LOCK
                WHERE item-cli.nome-abrev >= f-nome-abrev-ini
                AND item-cli.nome-abrev <= f-nome-abrev-fim
                AND item-cli.it-codigo >= f-item-ini
                AND item-cli.it-codigo <= f-item-fim:
                    
                    RUN pi-acompanhar IN h-acomp (item-cli.it-codigo).
                    IF c-destino-dados = "CRM" THEN
                        RUN adapters/neogrid/pdp/anepd032.p (INPUT ROWID(item-cli), INPUT "CHANGE").
            END.
    /* Cota‡äes Moedas */
    /* XML Cota‡äes de Moedas - Somente dispon¡vel a partir da release 2.04 */
    &if '{&BF_DIS_VERSAO_EMS}' >= '2.04' &then
        IF  tt-param.l-cotacoes-moedas THEN
            FOR EACH  cotacao FIELDS(ano-periodo) NO-LOCK
                WHERE cotacao.ano-periodo >= tt-param.f-periodo-cotacao-ini
                AND   cotacao.ano-periodo <= tt-param.f-periodo-cotacao-fim:
                RUN pi-acompanhar IN h-acomp (STRING(cotacao.ano-periodo)).
                IF  c-destino-dados = "CRM" THEN
                    RUN adapters/neogrid/ftp/aneft061.p (INPUT ROWID(cotacao),
                                                         INPUT "Modifica‡Æo").
                ELSE
                    RUN adapters/neogrid/ftp/aneft011.p (INPUT ROWID(cotacao),
                                                         INPUT "Modifica‡Æo").
            END.
    &endif


    /* Unidade Federação */
    /* XML Unidades de Federa‡Æo - Somente dispon¡vel a partir da release 2.04 */
    &if '{&BF_DIS_VERSAO_EMS}' >= '2.04' &then
        IF  tt-param.l-unid-feder THEN
            FOR EACH  unid-feder FIELDS(estado) NO-LOCK
                WHERE unid-feder.pais   >= tt-param.f-pais-ini
                AND   unid-feder.pais   <= tt-param.f-pais-fim 
                AND   unid-feder.estado >= tt-param.f-estado-ini
                AND   unid-feder.estado <= tt-param.f-estado-fim:
                RUN pi-acompanhar IN h-acomp (unid-feder.estado).
                IF  c-destino-dados = "CRM" THEN
                    RUN adapters/neogrid/ftp/aneft062.p (INPUT ROWID(unid-feder)).
                ELSE
                    RUN adapters/neogrid/ftp/aneft012.p (INPUT ROWID(unid-feder)).
            END.
    &endif
    
    /*  Cidades Zona Franca Manaus */
    &if '{&BF_DIS_VERSAO_EMS}' >= '2.04':U &then
        IF  tt-param.i-destino-dados = 2 AND
            tt-param.l-cidades-zfm       THEN 
            IF  c-destino-dados = "CRM" THEN
                RUN adapters/neogrid/ftp/aneft063.p.
            ELSE
                RUN adapters/neogrid/ftp/aneft013.p.
    &endif
    
    /*referencia*/

    IF  tt-param.l-referencia THEN DO:
        FOR EACH referencia 
            WHERE referencia.descricao >= tt-param.f-refer-ini 
            AND referencia.descricao   <= tt-param.f-refer-fim NO-LOCK:

            RUN pi-acompanhar IN h-acomp (referencia.descricao).
            RUN adapters/neogrid/pdp/anepd017.p (INPUT ROWID(referencia),
                                                 INPUT "change").
        END.
    END.

    /* Portador */
    IF tt-param.l-portador THEN DO:
        FIND FIRST param-global NO-LOCK NO-ERROR.
        FOR EACH portador WHERE portador.ep-codigo = param-global.empresa-prin NO-LOCK:

            RUN pi-acompanhar IN h-acomp (portador.cod-portador).
            RUN adapters/neogrid/pdp/anepd030.p (INPUT ROWID(portador)).

        END.
    END.

    /* Parƒmetros */
    IF tt-param.l-parametros THEN DO:
        /* Param Global */
        FOR EACH param-global NO-LOCK:
            RUN pi-acompanhar IN h-acomp (param-global.modulo-05).
            RUN adapters/neogrid/pdp/anepd031.p (INPUT ROWID(param-global), INPUT "change").
        END.
        /* Param Distribuicao */
        FOR EACH para-dis NO-LOCK:
            RUN adapters/neogrid/ftp/aneft007.p (INPUT ROWID(para-dis), 
                                                 INPUT tt-param.i-destino-dados,
                                                 INPUT "adapters/neogrid/pdp/anepd035.p").
        END.
    END.
    
    /* XML Unidade Neg¢cio - Somente dispon¡vel a partir da release 2.04 */
    &if '{&BF_DIS_VERSAO_EMS}' >= '2.04' &then
    
        FIND FIRST para-dis NO-LOCK NO-ERROR.

        IF AVAIL para-dis AND para-dis.log-unid-neg = YES THEN DO:
        
            /* Unidade Negocio (FO1703730) */
            IF tt-param.l-un-neg THEN DO:
                RUN adapters/neogrid/ftp/aneft007.p (INPUT ?,
                                                     INPUT tt-param.i-destino-dados,
                                                     INPUT "adapters/neogrid/pdp/anepd036.p").
            END.
    
            /* Un Neg x Fam Com (FO1703730) */
            IF tt-param.l-un-neg-fam THEN DO:
                RUN adapters/neogrid/ftp/aneft007.p (INPUT ?,
                                                     INPUT tt-param.i-destino-dados,
                                                     INPUT "adapters/neogrid/pdp/anepd033.p").
            END.
    
            /* Un Neg x Item (FO1703730) */
            IF  tt-param.l-un-neg-item THEN DO:
                
                IF  f-item-ini = "":U
                AND f-item-fim = "ZZZZZZZZZZZZZZZZ":U THEN
                    /* Todos os itens */
                    RUN adapters/neogrid/ftp/aneft007.p (INPUT ?,
                                                         INPUT tt-param.i-destino-dados,
                                                         INPUT "adapters/neogrid/pdp/anepd034.p").
                ELSE DO:
                    /* Apenas itens selecionados em tela */
                    FOR EACH  unid-neg-item FIELDS (it-codigo) NO-LOCK
                        WHERE unid-neg-item.it-codigo >= f-item-ini 
                        AND   unid-neg-item.it-codigo <= f-item-fim
                        BREAK BY unid-neg-item.it-codigo:

                        RUN pi-acompanhar IN h-acomp (unid-neg-item.it-codigo).
                        
                        IF FIRST-OF(unid-neg-item.it-codigo) THEN DO:
                           FIND FIRST ITEM WHERE ITEM.it-codigo = unid-neg-item.it-codigo NO-LOCK NO-ERROR.
                           IF AVAIL ITEM THEN
                              RUN adapters/neogrid/ftp/aneft007.p (INPUT ROWID(ITEM),
                                                                   INPUT tt-param.i-destino-dados,
                                                                   INPUT "adapters/neogrid/pdp/anepd034.p").                           

                        END.
                    END.
                END.
            END.
        END.
    &endif

    /*ITEM x referencia*/
    IF  tt-param.l-item-refer THEN DO:
        FOR EACH REF-ITEM 
            WHERE REF-ITEM.IT-CODIGO >= tt-param.f-item-ini 
            AND REF-ITEM.IT-CODIGO   <= tt-param.f-item-fim NO-LOCK:
             
            RUN pi-acompanhar IN h-acomp (REF-ITEM.IT-CODIGO).
            
            RUN adapters/neogrid/pdp/anepd018.p (INPUT ROWID(REF-ITEM),
                                                 INPUT "change").
        END.
    END.

    /*Pre‡o PadrÆo*/
    &if '{&BF_DIS_VERSAO_EMS}' >= '2.04':U &then
        IF  tt-param.i-destino-dados = 2 AND
            tt-param.l-preco-padrao THEN 
            RUN adapters/neogrid/ftp/aneft007.p (INPUT ?,
                                                 INPUT tt-param.i-destino-dados,
                                                 INPUT "adapters/neogrid/pdp/anepd065.p").
    
    /*Estrutura Comercial*/
        IF  tt-param.i-destino-dados = 2 AND
            tt-param.l-estrut-comerc THEN 
            RUN adapters/neogrid/ftp/aneft007.p (INPUT ?,
                                                 INPUT tt-param.i-destino-dados,
                                                 INPUT "adapters/neogrid/pdp/anepd066.p").
    
    /*ITEM Estabelecimento*/
        IF  tt-param.l-item-estab THEN DO:
            FOR EACH item-estab 
                WHERE item-estab.IT-CODIGO >= tt-param.f-item-ini 
                  AND item-estab.IT-CODIGO <= tt-param.f-item-fim NO-LOCK:

                RUN pi-acompanhar IN h-acomp (item-estab.IT-CODIGO).

                RUN adapters/neogrid/ftp/aneft007.p (INPUT ROWID(item-estab),
                                                     INPUT tt-param.i-destino-dados,
                                                     INPUT "adapters/neogrid/pdp/anepd067.p").
            END.
        END.
    &endif

    /**  Chamada EPC **/
    for each tt-epc 
        WHERE tt-epc.cod-event = "AfterB2BIntegration":U: 
        delete tt-epc.                               
    end.                                             
    
    create tt-epc.
    assign tt-epc.cod-event     = "AfterB2BIntegration":U  
           tt-epc.cod-parameter = "h-comerc-devol":U.

    create tt-epc.
    assign tt-epc.cod-event     = "AfterB2BIntegration":U  
           tt-epc.cod-parameter = "tt-param":U
           tt-epc.val-parameter = STRING(TEMP-TABLE tt-param:HANDLE).

    {include/i-epc201.i "AfterB2BIntegration"}
    
    /** Fim chamanda EPC **/


END PROCEDURE.

PROCEDURE pi-impressao-parametros:
    def var c-label-arq-gerados   as char no-undo.
    def var c-label-motivo	      as char no-undo.
    def var c-label-emp           as char no-undo.
    def var c-label-est           as char no-undo.
    def var c-label-ser-nota      as char no-undo.
    def var c-label-nat-oper      as char no-undo.
    def var c-label-cond-pgto     as char no-undo.
    def var c-label-moeda         as char no-undo.  
    def var c-label-item          as char no-undo.  
    def var c-label-refer         as char no-undo.  
    def var c-label-item-refer    as char no-undo.  
    def var c-label-preco-padrao  as char no-undo.  
    def var c-label-estrut-comerc as char no-undo.  
    def var c-label-item-estab    as char no-undo.  
    def var c-label-unid-med      as char no-undo.
    def var c-label-item-forn     as char no-undo.
    def var c-label-tab-preco     as char no-undo.
    def var c-label-grupo-cli     as char no-undo.
    def var c-label-cliente       as char no-undo.  
    def var c-label-fornecedor    as char no-undo.
    def var c-label-transp        as char no-undo.
    def var c-label-via-transp    as char no-undo.
    def var c-label-repres        as char no-undo.
    def var c-label-regiao        as char no-undo.
    def var c-label-usuario       as char no-undo.
    def var c-label-nota-fiscal   as char no-undo.
    def var c-label-ped-venda     as char no-undo.
    def var c-label-canal-venda   as char no-undo.
    def var c-label-tipo-rec_desp as char no-undo.
    def var c-label-inf-cred      as char no-undo.
    def var c-label-cot-moedas    as char no-undo.
    def var c-label-cidades-zfm   as char no-undo.
    def var c-label-uf            as char no-undo.
    def var c-formato-log         as char no-undo.
    DEF VAR c-label-portador      AS CHAR NO-UNDO.
    DEF VAR c-label-parametros    AS CHAR NO-UNDO.
    DEF VAR c-label-un-neg-fam    AS CHAR NO-UNDO.
    DEF VAR c-label-un-neg-item   AS CHAR NO-UNDO.
    DEF VAR c-label-item-cliente  AS CHAR NO-UNDO.

    HIDE FRAME f-dados .
    HIDE FRAME f-detalhe.

    /* FOLDER PARÂMETROS */
    {utp/ut-liter.i "PAR¶METROS" * r}.
    ASSIGN c-traduz = RETURN-VALUE.
    PUT c-traduz AT 46 FORMAT "x(23)" SKIP(1).

    {utp/ut-liter.i Gera‡Æo_de_carga_para:_ *}
    PUT unformatted return-value AT 31 c-destino-dados AT 054 SKIP(2).

    IF tt-param.l-item THEN DO:
     {utp/ut-liter.i Itens_a_Exportar:_ *}
     PUT unformatted return-value AT 31 tt-param.c-itens-export AT 049 SKIP(2).
    END.

    /* FOLDER SELE€ÇO */
    {utp/ut-liter.i "SELE€ÇO" * r}.
    ASSIGN c-traduz = RETURN-VALUE.
    PUT c-traduz AT 46 FORMAT "x(23)" SKIP(1).

    {utp/ut-liter.i Arquivos_Gerados_ *}
    assign c-label-arq-gerados = return-value.
    
    {utp/ut-liter.i Motivo:_ *}
    assign c-label-motivo = return-value.

    {utp/ut-liter.i Empresa:_ *}
    assign c-label-emp = return-value.

    {utp/ut-liter.i Estabelecimento:_ *}
    assign c-label-est = return-value.

    {utp/ut-liter.i S‚rie_Nota:_ *}
    assign c-label-ser-nota = return-value.

    {utp/ut-liter.i Natureza_Opera‡Æo:_ *}
    assign c-label-nat-oper = return-value.

    {utp/ut-liter.i Condi‡Æo_Pagamento:_ *}
    assign c-label-cond-pgto = return-value.

    {utp/ut-liter.i Moeda:_ *}
    assign c-label-moeda = return-value.

    {utp/ut-liter.i Item:_ *}
    assign c-label-item = return-value.

    {utp/ut-liter.i Referˆncia:_ *}
    assign c-label-refer = return-value.

    {utp/ut-liter.i Portador:_ *}
    assign c-label-portador = return-value.

    {utp/ut-liter.i Parƒmetros:_ *}
    assign c-label-parametros = return-value.

    {utp/ut-liter.i Item_Cliente:_ *}
    assign c-label-item-cliente = return-value.


    {utp/ut-liter.i Un_Neg_x_Fam_Com:_ *}
    assign c-label-un-neg-fam = return-value.
    
    {utp/ut-liter.i Un_Neg_x_Fam_Item:_ *}
    assign c-label-un-neg-item = return-value.
    
    {utp/ut-liter.i Item_x_Referˆcia:_ *}
    assign c-label-item-refer = return-value.
      
    {utp/ut-liter.i Pre‡o_PadrÆo:_ *}
    assign c-label-preco-padrao = return-value.
      
    {utp/ut-liter.i Produto_Comercial:_ *}
    assign c-label-estrut-comerc = return-value.
      
    {utp/ut-liter.i Item_Estabelecimento:_ *}
    assign c-label-item-estab = return-value.
      
    {utp/ut-liter.i Unidade_Medida:_ *}
    assign c-label-unid-med = return-value.

    {utp/ut-liter.i Item_x_Fornecedor: *}
    assign c-label-item-forn = return-value.

    {utp/ut-liter.i Tabela_Pre‡o:_ *}
    assign c-label-tab-preco = return-value.

    {utp/ut-liter.i Grupo_Cliente:_ *}
    assign c-label-grupo-cli = return-value.

    {utp/ut-liter.i Cliente:_ *}
    assign c-label-cliente = return-value.

    {utp/ut-liter.i Fornecedor:_ *}
    assign c-label-fornecedor = return-value.

    {utp/ut-liter.i Transportador:_ *}
    assign c-label-transp = return-value.

    {utp/ut-liter.i Via_Transporte:_ *}
    assign c-label-via-transp = return-value.

    {utp/ut-liter.i Representante:_ *}
    assign c-label-repres = return-value.

    {utp/ut-liter.i RegiÆo:_ *}
    assign c-label-regiao = return-value.

    {utp/ut-liter.i Usu rio:_ *}
    assign c-label-usuario = return-value.

    {utp/ut-liter.i Nota_Fiscal:_ *}
    assign c-label-nota-fiscal = return-value.

    {utp/ut-liter.i Pedido_Venda:_ *}
    assign c-label-ped-venda = return-value.

    {utp/ut-liter.i Canal_Venda:_ *}
    assign c-label-canal-venda = return-value.

    {utp/ut-liter.i Tipo_Receita/Despesa:_ *}
    assign c-label-tipo-rec_desp = return-value.

    {utp/ut-liter.i Informa‡äes_Cr‚dito:_ *}
    assign c-label-inf-cred = return-value.

    {utp/ut-liter.i Cota‡äes_Moedas:_ *}
    assign c-label-cot-moedas = return-value.

    {utp/ut-liter.i Unidade_Federa‡Æo:_ *}
    assign c-label-uf = return-value.

    {utp/ut-liter.i Cidades_Zona_Franca:_ *}
    assign c-label-cidades-zfm = return-value.

    {utp/ut-liter.i Sim/NÆo *}
    assign c-formato-log = return-value.

    PUT unformatted c-label-arq-gerados   AT 50                                                        SKIP
    		        c-label-motivo        AT 47 tt-param.l-motivo-cancel   AT 054 FORMAT c-formato-log SKIP
                    c-label-emp           AT 45 tt-param.l-empresa         AT 054 FORMAT c-formato-log SKIP
                    c-label-est           AT 37 tt-param.l-estab           AT 054 FORMAT c-formato-log SKIP
                    c-label-ser-nota      AT 42 tt-param.l-serie           AT 054 FORMAT c-formato-log SKIP
                    c-label-nat-oper      AT 35 tt-param.l-natur-oper      AT 054 FORMAT c-formato-log SKIP
                    c-label-cond-pgto     AT 34 tt-param.l-cond-pagto      AT 054 FORMAT c-formato-log SKIP
                    c-label-moeda         AT 47 tt-param.l-moeda           AT 054 FORMAT c-formato-log SKIP
                    c-label-item          AT 48 tt-param.l-item            AT 054 FORMAT c-formato-log SKIP
                    c-label-unid-med      AT 38 tt-param.l-unid-med        AT 054 FORMAT c-formato-log SKIP
                    c-label-item-forn     AT 35 tt-param.l-item-fornec     AT 054 FORMAT c-formato-log SKIP
                    c-label-tab-preco     AT 40 tt-param.l-tab-preco       AT 054 FORMAT c-formato-log SKIP
                    c-label-grupo-cli     AT 39 tt-param.l-grupo-cliente   AT 054 FORMAT c-formato-log SKIP
                    c-label-cliente       AT 45 tt-param.l-cliente         AT 054 FORMAT c-formato-log SKIP
                    c-label-fornecedor    AT 42 tt-param.l-fornecedor      AT 054 FORMAT c-formato-log SKIP
                    c-label-transp        AT 39 tt-param.l-transportador   AT 054 FORMAT c-formato-log SKIP
                    c-label-via-transp    AT 38 tt-param.l-via-transporte  AT 054 FORMAT c-formato-log SKIP
                    c-label-repres        AT 39 tt-param.l-repres          AT 054 FORMAT c-formato-log SKIP
                    c-label-regiao        AT 46 tt-param.l-regiao          AT 054 FORMAT c-formato-log SKIP
                    c-label-usuario       AT 45 tt-param.l-usuario         AT 054 FORMAT c-formato-log SKIP
                    c-label-nota-fiscal   AT 41 tt-param.l-nota-fiscal     AT 054 FORMAT c-formato-log SKIP
                    c-label-ped-venda     AT 40 tt-param.l-ped-venda       AT 054 FORMAT c-formato-log SKIP
                    c-label-canal-venda   AT 41 tt-param.l-canal-venda     AT 054 FORMAT c-formato-log SKIP
                    c-label-tipo-rec_desp AT 32 tt-param.l-tp-rec-desp     AT 054 FORMAT c-formato-log SKIP
                    c-label-inf-cred      AT 33 tt-param.l-info-cred       AT 054 FORMAT c-formato-log SKIP
  

        &if '{&BF_DIS_VERSAO_EMS}' >= '2.04' &then
        /* XML Cota‡äes de Moedas - Somente dispon¡vel a partir da release 2.04 */
                    c-label-cot-moedas    AT 37 tt-param.l-cotacoes-moedas AT 054 FORMAT c-formato-log SKIP
        /* XML Unidades Federa‡Æo - Somente dispon¡vel a partir da release 2.04 */
                    c-label-uf            AT 35 tt-param.l-unid-feder      AT 054 FORMAT c-formato-log SKIP
        /* XML Cidades ZFM */
                    c-label-cidades-zfm   AT 33 tt-param.l-cidades-zfm     AT 054 FORMAT c-formato-log SKIP
        &endif
        
        c-label-refer         AT 42 tt-param.l-referencia      AT 054 FORMAT c-formato-log SKIP
        c-label-item-refer    AT 36 tt-param.l-item-refer      AT 054 FORMAT c-formato-log SKIP
        c-label-portador      AT 44 tt-param.l-portador        AT 054 FORMAT c-formato-log SKIP
        c-label-parametros    AT 42 tt-param.l-parametros      AT 054 FORMAT c-formato-log SKIP
        c-label-item-cliente  AT 40 tt-param.l-item-cliente    AT 054 FORMAT c-formato-log SKIP

        &if '{&BF_DIS_VERSAO_EMS}' >= '2.04' &then
                    c-label-preco-padrao  AT 40 tt-param.l-preco-padrao    AT 054 FORMAT c-formato-log SKIP
                    c-label-estrut-comerc AT 35 tt-param.l-estrut-comerc   AT 054 FORMAT c-formato-log SKIP
                    c-label-item-estab    AT 32 tt-param.l-item-estab      AT 054 FORMAT c-formato-log SKIP
                    c-label-un-neg-fam    AT 36 tt-param.l-un-neg-fam      AT 054 FORMAT c-formato-log SKIP
                    c-label-un-neg-item   AT 35 tt-param.l-un-neg-item     AT 054 FORMAT c-formato-log SKIP
        &endif
        SKIP(2).

    /* FOLDER FAIXAS */
    IF  tt-param.l-ped-venda
    OR  tt-param.l-nota-fiscal 
    OR  tt-param.l-info-cred 
    OR  tt-param.l-cotacoes-moedas
    OR  tt-param.l-unid-feder  
    OR  tt-param.l-item THEN DO:
        {utp/ut-liter.i "FAIXAS" * r}.
        ASSIGN c-traduz = RETURN-VALUE.
        PUT c-traduz AT 46 FORMAT "x(23)" SKIP(1).
    END.

    IF  tt-param.l-ped-venda THEN do:
        {utp/ut-liter.i Data_do_Pedido:_ *}
        PUT unformatted return-value AT 38 tt-param.f-data-pedv-ini AT 054 FORMAT "99/99/9999" "   |< >| " AT 64 tt-param.f-data-pedv-fim   AT 073 FORMAT "99/99/9999"   SKIP.
    end.
    IF  tt-param.l-nota-fiscal THEN do:
        {utp/ut-liter.i Data_da_Nota:_ *}
        PUT unformatted return-value AT 40 tt-param.f-data-nf-ini   AT 054 FORMAT "99/99/9999" "   |< >| " AT 64 tt-param.f-data-nf-fim   AT 073 FORMAT "99/99/9999" SKIP.
    end.
    IF l-info-cred THEN 
        IF i-selecao-cli = 1 THEN do:
          {utp/ut-liter.i C¢digo_Cliente:_ *}
          PUT unformatted return-value AT 38 tt-param.f-cod-emit-ini  AT 055 FORMAT ">>>>>>>>9" " |< >| " AT 66 tt-param.f-cod-emit-fim   AT 074 FORMAT ">>>>>>>>9" SKIP.
        end.
        ELSE do:
          {utp/ut-liter.i Nome_Abreviado:_ *}
          PUT unformatted return-value AT 38 tt-param.f-nome-abrev-ini  AT 054 FORMAT "x(12)" " |< >| " AT 66 tt-param.f-nome-abrev-fim   AT 073 FORMAT "x(12)" SKIP.
        end.
    IF tt-param.l-item THEN do:
       {utp/ut-liter.i Item:_ *}
       PUT unformatted return-value AT 38 tt-param.f-item-ini AT 044 FORMAT "x(16)" "  |< >| " AT 60 tt-param.f-item-fim AT 076 FORMAT "x(16)" SKIP.
    end.

    /* XML Cota‡äes de Moedas - Somente dispon¡vel a partir da release 2.04 */
    &if '{&BF_DIS_VERSAO_EMS}' >= '2.04' &then
    IF  tt-param.l-cotacoes-moedas then do:
        {utp/ut-liter.i Per¡odo_Cota‡äes:_ *}
        PUT unformatted return-value   AT 36 
        tt-param.f-periodo-cotacao-ini AT 057 FORMAT "9999/99" 
        " |< >| "                      AT 66 
        tt-param.f-periodo-cotacao-fim AT 075 FORMAT "9999/99" SKIP.
    end.
    &endif

    /* XML Unidades de Federa‡Æo - Somente dispon¡vel a partir da release 2.04 */
    &if '{&BF_DIS_VERSAO_EMS}' >= '2.04' &then
    IF  tt-param.l-unid-feder THEN DO:
        {utp/ut-liter.i Pa¡s:_ *}
        PUT unformatted return-value   AT 40 
        tt-param.f-pais-ini            AT 046 FORMAT "x(20)" 
        " |< >| "                      AT 67 
        tt-param.f-pais-fim            AT 075 FORMAT "x(20)" SKIP.

        {utp/ut-liter.i Estado:_ *}
        PUT unformatted return-value   AT 38 
        tt-param.f-estado-ini          AT 062 FORMAT "x(04)" 
        " |< >| "                      AT 67 
        tt-param.f-estado-fim          AT 075 FORMAT "x(04)" SKIP.
    END.
    &endif

    PUT UNFORMATTED SKIP(2).

    /* FOLDER IMPRESSÇO */
    {utp/ut-liter.i "IMPRESSÇO" * r}.
    ASSIGN c-traduz = RETURN-VALUE.
    PUT c-traduz AT 46 FORMAT "x(23)" SKIP(1).
    PUT UNFORMATTED SKIP.

    {utp/ut-liter.i "Usu rio:" * r}.
    ASSIGN c-traduz = RETURN-VALUE.

    PUT c-traduz         AT 45 FORMAT "x(08)"
        tt-param.usuario AT 54 FORMAT "x(20)".

    {utp/ut-liter.i "Destino:" * r}
    ASSIGN c-traduz = RETURN-VALUE.

    PUT c-traduz         AT 45 FORMAT "x(08)"
        tt-param.arquivo AT 54 FORMAT "x(40)".
END.

