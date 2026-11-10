/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0450RP 2.00.00.003 } /*** "010003" 07/11/2025 11:15:52 ***/
                            
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0450rp MIM}
&ENDIF                  

{include/i_fnctrad.i}
/*---------------------------------------------------------------------------
** PROGRAMA: IM0450RP.P
---------------------------------------------------------------------------*/

/********************** Defini‡Æo dos parƒmetros ***************************/
/*---[ Parameters Definitions ]--------------------------------------------*/

{utp/ut-glob.i}
{cdp/cdcfgdis.i} /* defini‡Æo de pr‚-processadores distribui‡Æo */
{cdp/cdcfgmat.i} /* defini‡Æo de pr‚-processadores materiais    */
{cdp/cdcfgcex.i}
/*--------------------------- Temp Tables ---------------------------------*/
{imp/im0450.i}  /* Defini‡Æo de temp-table tt-param */
{imp/im0450.i2} /* Defini‡äes das temp-tables do arquivo-textop */

def temp-table tt-raw-digita
   field raw-digita      as raw.

def input param raw-param as raw no-undo.
def input param table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

/*************************** Vari veis Locais ********************************/
DEF VAR c-parametro              AS   CHAR FORMAT "x(14)":U NO-UNDO.
DEF VAR c-impressao              AS   CHAR FORMAT "x(12)":U NO-UNDO.
DEF VAR c-destino                AS   CHAR FORMAT "x(60)":U NO-UNDO.
DEF VAR h-acomp                  AS   HANDLE NO-UNDO.
DEF VAR positions                AS   CHAR FORMAT "x(20)":U NO-UNDO.
DEF VAR cBarra                   AS   CHAR FORMAT "x":U NO-UNDO.
DEF VAR found                    AS   INT  NO-UNDO.
DEF VAR loop                     AS   INT  NO-UNDO.
DEF VAR start                    AS   INT  NO-UNDO.
DEF VAR i-position               AS   INT  NO-UNDO.
DEF VAR c-trib                   AS   CHAR NO-UNDO.
DEF VAR flag-include             AS   LOG INITIAL YES NO-UNDO.
DEF VAR c-arquivo-destino        LIKE tt-param.arq-entrada  NO-UNDO.
DEF VAR c-cnpj-estab-aux         AS   CHAR FORMAT "x(14)":U NO-UNDO.
DEF VAR c-cnpj-consig-aux        AS   CHAR FORMAT "x(14)":U NO-UNDO.
DEF VAR c-cnpj-agente-aux        AS   CHAR FORMAT "x(14)":U NO-UNDO.
DEF VAR i-conta-mercadoria       AS   INT NO-UNDO.
DEF VAR i-pto-control-nacionaliz LIKE histor-decla-import.cdn-pto-nacionaliz NO-UNDO.
DEF VAR v-parametro1 AS DATE NO-UNDO. /* data */
DEF VAR v-parametro2 AS CHAR NO-UNDO. /* descri‡Æo da unidade referencial */
DEF VAR v-descUN-class-fisc LIKE tab-unidade.descricao NO-UNDO.

DEF BUFFER bf_decla-import-adic       FOR decla-import-adic.
DEF BUFFER bf_decla-import-adic-parc  FOR decla-import-adic-parc.
DEF BUFFER bf_decla-import-adic-itens FOR decla-import-adic-itens.
DEF BUFFER bf_classif-destaq          FOR classif-destaq.
DEF BUFFER bf_ordem-compra            FOR ordem-compra.
DEF BUFFER bf_prazo-compra            FOR prazo-compra.
DEF BUFFER bf_ordens-embarque         FOR ordens-embarque.
DEF BUFFER bf_decla-import-embarq     FOR decla-import-embarq.
DEF BUFFER bf_histor-decla-import     FOR histor-decla-import.
DEF BUFFER bf_pais                    FOR pais.
DEF BUFFER bf_classif-fisc            FOR classif-fisc.
DEF BUFFER bf_tab-unidade             FOR tab-unidade.

DEF TEMP-TABLE tt-auxiliar NO-UNDO
    FIELD cod-estabel    LIKE historico-embarque.cod-estabel
    FIELD embarque       LIKE historico-embarque.embarque
    FIELD cod-itiner     LIKE historico-embarque.cod-itiner
    FIELD sequencia      LIKE historico-embarque.sequencia
    FIELD cod-pto-contr  LIKE historico-embarque.cod-pto-contr
    FIELD dt-efetiva     LIKE historico-embarque.dt-efetiva 
    FIELD dt-ult-prev    LIKE historico-embarque.dt-ult-prev
    FIELD num-registro   AS INTEGER
    FIELD log-data-maior AS LOGICAL
    FIELD dt-usada       AS DATE FORMAT '99/99/9999':U.

&if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
    DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cAuxTraducao002 AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cAuxTraducao003 AS CHARACTER NO-UNDO.
&endif

form skip(01)
     c-parametro           NO-LABEL    SKIP(1)
     tt-param.num-di-ems      COLON 30 LABEL 'Nr.DI EMS':U SKIP(1)
     tt-param.arq-entrada     COLON 30 LABEL 'Arquivo Siscomex':U SKIP(1)
     tt-param.usuario         COLON 30 LABEL 'Usu rio Recebimento':U
     "-":U                       AT 45
     tt-param.nome-usuario       AT 47 NO-LABEL SKIP(1)
     tt-param.banco-access    COLON 30 LABEL 'Banco Access':U SKIP(1)
     c-impressao           NO-LABEL    SKIP(1)
     c-destino                   AT 23 NO-LABEL SKIP(1)
     tt-param.arq-destino     COLON 30 LABEL 'Arquivo Destino':U
     with down no-box side-labels width 132 stream-io frame f-parametros.

{utp/ut-liter.i PAR¶METROS * R}
assign c-parametro = trim(return-value).
{utp/ut-liter.i IMPRESSÇO * R}
assign c-impressao = trim(return-value).

{utp/ut-glob.i}
{include/i-freeac.i} /* Define function para transformar string's acentuadas em nÆo-acentuadas. */

/*--------------------------------[ Fun‡äes do sistema ]---------------------------------------*/
run utp/ut-acomp.p persistent set h-acomp.
run pi-inicializar in h-acomp (input "Gerando arquivos...").

DEFINE TEMP-TABLE tt-erro NO-UNDO
    FIELD nr-sequencia AS INTE
    FIELD cd-erro      AS INTE
    FIELD descricao    AS CHAR FORMAT "x(60)".
/*--------------------------------[ Fun‡äes do sistema ]---------------------------------------*/

/*--------------------------------[ Gera‡Æo dos Dados ]----------------------------------------*/
FIND FIRST tt-param NO-LOCK NO-ERROR.
ASSIGN tt-param.arquivo = tt-param.arq-destino.

DO  loop = 1 TO 2:
    positions = "".
    cBarra = SUBSTRING("~\/",loop,1).
    start  = 1.
    found  = INDEX(tt-param.arq-entrada,cBarra,start).
    DO  WHILE found > 0:
        positions = positions + STRING(found).
        start     = found + 1.
        found     = INDEX(tt-param.arq-entrada,cBarra,start).
    END. /* DO  WHILE found > 0: */
END. /* DO  loop = 1 TO 2: */

ASSIGN c-arquivo-destino = substring(tt-param.arq-entrada,INT(SUBSTRING(positions,2,4)) + 1,20).

/*---[ Limpeza das tabelas tempor rias ]--------------------------------------------------------*/
EMPTY TEMP-TABLE tt-inform-arq   NO-ERROR.
EMPTY TEMP-TABLE tt-decla-import NO-ERROR.
EMPTY TEMP-TABLE tt-processos-di NO-ERROR.
EMPTY TEMP-TABLE tt-embal-di     NO-ERROR.
EMPTY TEMP-TABLE tt-adic-di      NO-ERROR.
EMPTY TEMP-TABLE tt-pagto-prev   NO-ERROR.
EMPTY TEMP-TABLE tt-pagto-vinc   NO-ERROR.
EMPTY TEMP-TABLE tt-det-merc     NO-ERROR.
EMPTY TEMP-TABLE tt-acres-val    NO-ERROR.
EMPTY TEMP-TABLE tt-docto-vinc   NO-ERROR.
EMPTY TEMP-TABLE tt-tributo      NO-ERROR.
EMPTY TEMP-TABLE tt-valor-ncm    NO-ERROR.
EMPTY TEMP-TABLE tt-dest-ncm     NO-ERROR.
EMPTY TEMP-TABLE tt-ato-vinc     NO-ERROR.
/*----------------------------------------------------------------------------------------------*/

/*---[ Registro tipo 00 - informa‡äes do arquivo ]--------------------------------------------------------------------*/
CREATE tt-inform-arq.
ASSIGN tt-inform-arq.cod-registro = 0
       tt-inform-arq.num-di-ems   = tt-param.num-di-ems
       tt-inform-arq.nome-arquivo = c-arquivo-destino
       tt-inform-arq.data-geracao = int(replace(STRING(tt-param.data-exec), "/", ""))
       tt-inform-arq.hora-geracao = int(replace(STRING(tt-param.hora-exec, 'HH:MM'), ":", "")).
/*--------------------------------------------------------------------------------------------------------------------*/

/*---[ Registro tipo 01 - declara‡Æo de importa‡Æo ]------------------------------------------------------------------*/
FOR FIRST decla-import NO-LOCK
    WHERE decla-import.num-di-ems = tt-param.num-di-ems:

    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "DI_nro" *}
    RUN pi-acompanhar IN h-acomp (INPUT RETURN-VALUE + ': ' + STRING(decla-import.num-di-ems)).

    CREATE tt-decla-import.
    ASSIGN tt-decla-import.cod-registro = 1
           tt-decla-import.num-di-ems   = decla-import.num-di-ems
           tt-decla-import.tipo         = decla-import.idi-tip-decla-import.

    FIND FIRST estabelec NO-LOCK
        WHERE  estabelec.cod-estabel = decla-import.cod-estab NO-ERROR.
    IF  AVAIL  estabelec 
    THEN DO:
        ASSIGN c-cnpj-estab-aux = REPLACE(estabelec.cgc, ".", "")
               c-cnpj-estab-aux = REPLACE(c-cnpj-estab-aux, "/", "")
               c-cnpj-estab-aux = REPLACE(c-cnpj-estab-aux, "-", "")
               tt-decla-import.cnpj-estab = c-cnpj-estab-aux.
    END. /* THEN DO: */
    ELSE ASSIGN tt-decla-import.cnpj-estab = "".

    ASSIGN tt-decla-import.modal-despacho = decla-import.idi-modalid-despch
           tt-decla-import.fundap = IF decla-import.log-fundap THEN "SIM":U ELSE "NAO":U
           tt-decla-import.un-receita-entrada = decla-import.cdn-urf-entr
           tt-decla-import.un-receita-despacho = decla-import.cdn-urf-despch
           tt-decla-import.carac-import = decla-import.idi-caract-operac.

    FIND FIRST emitente NO-LOCK
        WHERE  emitente.cgc = tt-decla-import.cnpj-consig NO-ERROR.
    IF  AVAIL  emitente 
    THEN DO:
        ASSIGN c-cnpj-consig-aux = REPLACE(emitente.cgc, ".", "")
               c-cnpj-consig-aux = REPLACE(c-cnpj-consig-aux, "/", "")
               c-cnpj-consig-aux = REPLACE(c-cnpj-consig-aux, "-", "")
               tt-decla-import.cnpj-consig = c-cnpj-consig-aux.
    END.
    ELSE ASSIGN tt-decla-import.cnpj-consig = "".

    FOR FIRST bf_pais NO-LOCK
        WHERE bf_pais.cod-pais = decla-import.cdn-pais-proceden:
        ASSIGN tt-decla-import.cod-pais-proced = bf_pais.cod-pais-siscomex.
    END. /* FOR FIRST bf_pais NO-LOCK */

    ASSIGN tt-decla-import.cod-via-transp = decla-import.cdn-via-transp-di
           tt-decla-import.ind-transp-multimodal = IF decla-import.log-multimod THEN "SIM":U ELSE "NAO":U.

    FIND FIRST transporte NO-LOCK
        WHERE  transporte.cod-transp = decla-import.cdn-transpdor NO-ERROR.
    IF  AVAIL  transporte 
    THEN DO: 
        ASSIGN tt-decla-import.nome-transp = transporte.nome
               tt-decla-import.nat-pessoa  = transporte.natureza.

        FIND FIRST pais NO-LOCK
            WHERE  pais.nome-pais = transporte.pais NO-ERROR.
        IF  AVAIL  pais
        THEN ASSIGN tt-decla-import.cod-pais-siscomex-transp = IF pais.cod-pais-siscomex <> "" THEN INT(pais.cod-pais-siscomex) ELSE 0.
        ELSE ASSIGN tt-decla-import.cod-pais-siscomex-transp = 0.
    END.
    ELSE ASSIGN tt-decla-import.nome-transp = ""
                tt-decla-import.cod-pais-siscomex-transp = 0
                tt-decla-import.nat-pessoa  = 0.
           
    FIND FIRST emitente NO-LOCK
        WHERE  emitente.cgc = tt-decla-import.cnpj-agente NO-ERROR.
    IF  AVAIL  emitente 
    THEN DO:
        ASSIGN c-cnpj-agente-aux = REPLACE(emitente.cgc, ".", "")
               c-cnpj-agente-aux = REPLACE(c-cnpj-agente-aux, "/", "")
               c-cnpj-agente-aux = REPLACE(c-cnpj-agente-aux, "-", "")
               tt-decla-import.cnpj-agente = c-cnpj-agente-aux.
    END.
    ELSE ASSIGN tt-decla-import.cnpj-agente = "".

    ASSIGN tt-decla-import.tipo-conhec = decla-import.idi-tip-conhecto
           tt-decla-import.num-docto-carga-house = decla-import.cod-conhecto-house
           tt-decla-import.num-dcoto-carga-master = decla-import.cod-conhecto-master.

    EMPTY TEMP-TABLE tt-auxiliar NO-ERROR.
    RUN pi-carrega-tt (INPUT decla-import.num-di-ems, OUTPUT v-parametro1, OUTPUT v-parametro2).
    
    ASSIGN tt-decla-import.dt-embarque    = v-parametro1
           tt-decla-import.nome-local-emb = v-parametro2.
           
    /*---[ Identificando qual o ponto de nacionaliza‡Æo ]-----------------------------------------*/
    FOR FIRST histor-decla-import NO-LOCK
        WHERE histor-decla-import.num-di-ems         = decla-import.num-di-ems
        AND   histor-decla-import.cdd-siscomex-dts   = decla-import.cdd-siscomex-dts
        AND   histor-decla-import.cdn-pto-nacionaliz = histor-decla-import.cdn-pto-control:
        ASSIGN tt-decla-import.dt-chegada-urf = histor-decla-import.dat-ult-prev.
    END. /* FOR FIRST histor-decla-import */
        
    ASSIGN tt-decla-import.ind-utiliza = decla-import.idi-ind-utiliz
           tt-decla-import.peso-bruto-total = decla-import.val-peso-brut-tot-di
           tt-decla-import.peso-liq-total = decla-import.val-peso-liq-di
           tt-decla-import.tipo-manifesto = decla-import.idi-docto-carg
           tt-decla-import.id-manifesto = decla-import.cod-identif
           tt-decla-import.recinto-alfandegado = decla-import.cdn-recinto-alfand
           tt-decla-import.setor-armazena = decla-import.cdn-setor-armaz
           tt-decla-import.vl-total-frete-me = decla-import.val-frete-me[1]
           tt-decla-import.vl-total-frete-mn = decla-import.val-frete
           tt-decla-import.vl-total-seguro-me = decla-import.val-seguro-me[1]
           tt-decla-import.vl-total-seguro-mn = decla-import.val-seguro
           tt-decla-import.vl-merc-local-emb-me = decla-import.val-vmle-me[1]
           tt-decla-import.vl-merc-local-emb-mn = decla-import.val-vmle
           tt-decla-import.inf-complemento = decla-import.cod-inf-compltar.

    FOR FIRST bf_decla-import-adic NO-LOCK
        WHERE bf_decla-import-adic.num-di-ems       = decla-import.num-di-ems
        AND   bf_decla-import-adic.cdd-siscomex-dts = decla-import.cdd-siscomex-dts:
        RUN pi-retorna-moeda (INPUT bf_decla-import-adic.cdn-moed-frete,  OUTPUT tt-decla-import.cod-moeda-frete).
        RUN pi-retorna-moeda (INPUT bf_decla-import-adic.cdn-moed-seguro, OUTPUT tt-decla-import.cod-moeda-seguro).
        RUN pi-retorna-moeda (INPUT bf_decla-import-adic.cdn-moeda,       OUTPUT tt-decla-import.cod-moeda-di).
    END. /* FOR FIRST bf_decla-import-adic */

    /*---[ Registro tipo 02 - processos da DI ]---------------------------------------------------------------------------*/
    FOR EACH  decla-import-proc NO-LOCK
        WHERE decla-import-proc.num-di-ems       = decla-import.num-di-ems
        AND   decla-import-proc.cdd-siscomex-dts = decla-import.cdd-siscomex-dts:

        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Processo" *}
        RUN pi-acompanhar IN h-acomp (INPUT RETURN-VALUE + ': ' + STRING(decla-import-proc.cod-proces-vincul)).

        CREATE tt-processos-di.
        ASSIGN tt-processos-di.cod-registro       = 2
               tt-processos-di.num-di-ems         = decla-import.num-di-ems
               tt-processos-di.tipo-processo-vinc = decla-import-proc.idi-tip-proces-vincul
               tt-processos-di.id-processo        = decla-import-proc.cod-proces-vincul.
    END. /* FOR EACH  decla-import-proc */
    /*--------------------------------------------------------------------------------------------------------------------*/

    /*---[ Registro tipo 03 - embalagens da DI ]--------------------------------------------------------------------------*/
    FOR EACH  decla-import-embal NO-LOCK
        WHERE decla-import-embal.num-di-ems       = decla-import.num-di-ems
        AND   decla-import-embal.cdd-siscomex-dts = decla-import.cdd-siscomex-dts:

        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Embalagem" *}
        RUN pi-acompanhar IN h-acomp (INPUT RETURN-VALUE + ' : ' + STRING(decla-import-embal.cod-sig-embal)).

        CREATE tt-embal-di.
        ASSIGN tt-embal-di.cod-registro       = 3
               tt-embal-di.num-di-ems         = decla-import.num-di-ems
               tt-embal-di.cod-embal-siscomex = decla-import-embal.cod-sig-embal
               tt-embal-di.qtde-volumes       = int(decla-import-embal.qtd-vol-embal).
    END. /* FOR EACH  decla-import-embal */
    /*--------------------------------------------------------------------------------------------------------------------*/

    /*---[ Registro tipo 04 - adi‡Æo da DI ]------------------------------------------------------------------------------*/
    FOR EACH  decla-import-adic NO-LOCK
        WHERE decla-import-adic.num-di-ems       = decla-import.num-di-ems
        AND   decla-import-adic.cdd-siscomex-dts = decla-import.cdd-siscomex-dts:

        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Adi‡Æo" *}
        RUN pi-acompanhar IN h-acomp (INPUT RETURN-VALUE + ' : ' + STRING(decla-import-adic.num-adic)).

        CREATE tt-adic-di.
        ASSIGN tt-adic-di.cod-registro = 4
               tt-adic-di.num-di-ems   = decla-import.num-di-ems
               tt-adic-di.num-adic     = decla-import-adic.num-adic.
    
        FIND FIRST emitente NO-LOCK
            WHERE  emitente.cod-emitente = decla-import-adic.cdn-fornec NO-ERROR.
        IF  AVAIL  emitente THEN DO:
            ASSIGN tt-adic-di.nome-export = emitente.nome-emit
                   tt-adic-di.end-export = emitente.endereco
                   tt-adic-di.cidade-export = emitente.cidade
                   tt-adic-di.nome-estado-export = emitente.estado.

            FOR FIRST pais NO-LOCK WHERE pais.nome-pais =  emitente.pais:
                ASSIGN tt-adic-di.pais-export = pais.cod-pais.
            END. /* FOR FIRST pais */
        END. /* IF  AVAIL  emitente */
        ELSE ASSIGN tt-adic-di.nome-export = ""
                    tt-adic-di.end-export = ""       
                    tt-adic-di.cidade-export = ""    
                    tt-adic-di.nome-estado-export = ""
                    tt-adic-di.pais-export = 0.
               
        ASSIGN tt-adic-di.ncm-merc = int(replace(decla-import-adic.cod-classif-fisc, ".", ""))
               tt-adic-di.log-forn-fabricante = IF decla-import-adic.log-emite-fabrican THEN 1 ELSE 2.

        FIND FIRST emitente NO-LOCK
            WHERE  emitente.cod-emitente = decla-import-adic.cdn-fabrican NO-ERROR.
        IF  AVAIL  emitente THEN DO:
            ASSIGN tt-adic-di.nome-fabricante = emitente.nome-emit
                   tt-adic-di.end-fabricante = emitente.endereco
                   tt-adic-di.cidade-fabricante = emitente.cidade
                   tt-adic-di.nome-estado-fabricante = emitente.estado.

            FOR FIRST pais NO-LOCK WHERE pais.nome-pais = emitente.pais:
                ASSIGN tt-adic-di.pais-fabricante = pais.cod-pais.
            END. /* FOR FIRST pais */
        END. /* IF  AVAIL  emitente */
        ELSE ASSIGN tt-adic-di.nome-fabricante = ""
                    tt-adic-di.end-fabricante = ""
                    tt-adic-di.cidade-fabricante = ""
                    tt-adic-di.nome-estado-fabricante = ""
                    tt-adic-di.pais-fabricante = 0. 

        ASSIGN tt-adic-di.cod-nbm = IF decla-import-adic.cod-nbm <> "" THEN int(decla-import-adic.cod-nbm) ELSE 0
               tt-adic-di.cod-naladi-ncc = IF decla-import-adic.cod-naladi-ncca <> "" THEN int(decla-import-adic.cod-naladi-ncca) ELSE 0
               tt-adic-di.cod-naladi-sh = decla-import-adic.cdn-naladi-sist-harmon
               tt-adic-di.peso-liq-adic = decla-import-adic.val-peso-liq
               tt-adic-di.qtde-medida-ncm = decla-import-adic.qtd-ncm.

        FOR FIRST bf_decla-import-adic-itens NO-LOCK
            WHERE bf_decla-import-adic-itens.num-di-ems       = decla-import-adic.num-di-ems
            AND   bf_decla-import-adic-itens.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts
            AND   bf_decla-import-adic-itens.num-adic         = decla-import-adic.num-adic:
            FOR FIRST item-uni-estab NO-LOCK
                WHERE item-uni-estab.it-codigo   = bf_decla-import-adic-itens.cod-item
                AND   item-uni-estab.cod-estabel = bf_decla-import-adic-itens.cod-estab:
                CASE item-uni-estab.tp-codigo:
                    WHEN 0 THEN ASSIGN tt-adic-di.cod-aplic-mercadoria = 2.
                    OTHERWISE ASSIGN tt-adic-di.cod-aplic-mercadoria = 1.
                END CASE. /* CASE item-uni-estab.tp-codigo: */
            END. /* FOR FIRST item-uni-estab */
        END. /* FOR FIRST bf_decla-import-adic-itens */
        
        ASSIGN tt-adic-di.cod-moeda-negoc = decla-import-adic.cdn-moeda
               tt-adic-di.cod-incoterm = decla-import-adic.cod-incoterm
               tt-adic-di.vl-merc-cond-venda-me = decla-import-adic.val-vmcv-me[1]
               tt-adic-di.vl-merc-cond-venda-mn = decla-import-adic.val-vmcv
               tt-adic-di.vl-frete-adic-mn = decla-import-adic.val-frete
               tt-adic-di.vl-seguro-adic-mn = decla-import-adic.val-seguro
               tt-adic-di.met-valora = decla-import-adic.idi-metod-val
               tt-adic-di.acordo-tarif = IF decla-import-adic.cod-aladi <> "" THEN "2" ELSE ""
               tt-adic-di.acordo-aladi = decla-import-adic.cod-aladi
               tt-adic-di.cobertura-cambial = decla-import-adic.idi-ind-pagto
               tt-adic-di.modalidade-pagto = decla-import-adic.cdn-modal-pagto
               tt-adic-di.cod-motito-sem-cobert = decla-import-adic.cdn-motivo.

        IF  decla-import-adic.log-suspens-impto-import 
        THEN ASSIGN tt-adic-di.cod-trib-ii = 5.
        ELSE DO:
            CASE decla-import-adic.idi-tributac-impto-import :
                WHEN 1 /* Tributado */ THEN ASSIGN tt-adic-di.cod-trib-ii = 1.
                WHEN 2 /* Isento    */ THEN ASSIGN tt-adic-di.cod-trib-ii = 3.
                WHEN 3 /* Outros    */ THEN ASSIGN tt-adic-di.cod-trib-ii = 6.
                WHEN 4 /* Reduzido  */ THEN ASSIGN tt-adic-di.cod-trib-ii = 4.
            END CASE.
        END. /* ELSE DO: */
        
        FOR FIRST bf_decla-import-adic-parc NO-LOCK
            WHERE bf_decla-import-adic-parc.num-di-ems       = decla-import-adic.num-di-ems
            AND   bf_decla-import-adic-parc.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts
            AND   bf_decla-import-adic-parc.num-adic         = decla-import-adic.num-adic: 

            IF  bf_decla-import-adic-parc.idi-tip-pagto = 3 /* Parcela */
            AND decla-import-adic.idi-ind-pagto = 3 /* Superior a 360 dias */ 
            THEN ASSIGN tt-adic-di.vl-financ-superior = bf_decla-import-adic-parc.val-parc.
            ELSE ASSIGN tt-adic-di.vl-financ-superior = 0.

        END. /* FOR FIRST bf_decla-import-adic-parc */

        ASSIGN tt-adic-di.id-rof = decla-import-adic.cod-rof
               tt-adic-di.ind-mat-encomenda = IF decla-import-adic.log-mater-encomen THEN "S":U ELSE "N":U
               tt-adic-di.ind-mat-usado = IF decla-import-adic.log-mater-usado THEN "S":U ELSE "N":U
               tt-adic-di.complemento-adic = decla-import-adic.dsl-compl-adic
               tt-adic-di.ind-ipi-ntribut = IF decla-import-adic.idi-tributac-ipi = 4 THEN "SIM" ELSE "NAO":U
               tt-adic-di.vl-merc-local-emb-mn = decla-import-adic.val-vmle
               tt-adic-di.vl-merc-local-desp-mn = decla-import-adic.val-vmld
               tt-adic-di.num-li-adic = IF decla-import-adic.cod-licenc-import <> "" THEN int(decla-import-adic.cod-licenc-import) ELSE 0
               tt-adic-di.aliq-icms = decla-import-adic.val-aliq-icms
               tt-adic-di.reduc-pis-cofins = IF decla-import-adic.val-perc-reduc-pis > 0  THEN "S":U ELSE "N":U.

        CASE decla-import-adic.idi-tributac-pis:
            WHEN 1 /* Tributado */ THEN ASSIGN tt-adic-di.cod-trib-pis-cofins = 1.
            WHEN 2 /* Isento    */ THEN ASSIGN tt-adic-di.cod-trib-pis-cofins = 3.
            WHEN 3 /* Outros    */ THEN ASSIGN tt-adic-di.cod-trib-pis-cofins = 6.
            WHEN 4 /* Reduzido  */ THEN ASSIGN tt-adic-di.cod-trib-pis-cofins = 4.
        END CASE.
        
        FOR EACH  decla-import-adic-parc NO-LOCK
            WHERE decla-import-adic-parc.num-di-ems       = decla-import-adic.num-di-ems
            AND   decla-import-adic-parc.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts
            AND   decla-import-adic-parc.num-adic         = decla-import-adic.num-adic: 

            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Parcelas_da_Adi‡Æo" *}
            RUN pi-acompanhar IN h-acomp (INPUT RETURN-VALUE + ' : ' + STRING(decla-import-adic-parc.num-seq-parc)).

            IF  decla-import-adic-parc.idi-tip-pagto = 3 /* Parcela */ THEN DO:
                /*---[ Registro tipo 05 - pagamento previsto ]------------------------------------------------------------------------*/
                CREATE tt-pagto-prev.
                ASSIGN tt-pagto-prev.cod-registro  = 5
                       tt-pagto-prev.num-di-ems    = decla-import-adic-parc.num-di-ems
                       tt-pagto-prev.num-adic      = decla-import-adic-parc.num-adic
                       tt-pagto-prev.seq-parcela   = decla-import-adic-parc.num-seq-parc
                       tt-pagto-prev.vl-parcela    = decla-import-adic-parc.val-parc
                       tt-pagto-prev.dt-prev-pagto = int(string(decla-import-adic-parc.num-mes-parc) + string(decla-import-adic-parc.num-ano-parc)).
                /*--------------------------------------------------------------------------------------------------------------------*/            
            END. /* IF  decla-import-adic-parc.idi-tip-pagto = 3 */
            ELSE 
                IF  decla-import-adic-parc.idi-tip-pagto = 1 /* · Vista */ 
                OR  decla-import-adic-parc.idi-tip-pagto = 2 /* Antecipado */ THEN DO:
                    /*---[ Registro tipo 06 - pagamento vinculado ]-----------------------------------------------------------------------*/            
                    CREATE tt-pagto-vinc.
                    ASSIGN tt-pagto-vinc.cod-registro        = 6
                           tt-pagto-vinc.num-di-ems          = decla-import-adic-parc.num-di-ems
                           tt-pagto-vinc.num-adic            = decla-import-adic-parc.num-adic
                           tt-pagto-vinc.seq-parcela         = decla-import-adic-parc.num-seq-parc
                           tt-pagto-vinc.tipo-parcela        = decla-import-adic-parc.idi-tip-pagto     
                           tt-pagto-vinc.cod-banco           = decla-import-adic.cdn-banco
                           tt-pagto-vinc.cod-praca           = decla-import-adic.cdn-praca
                           tt-pagto-vinc.num-contrato-cambio = IF decla-import-adic.cod-contrat-cambio <> "" THEN int(decla-import-adic.cod-contrat-cambio) ELSE 0
                           tt-pagto-vinc.vl-merc-cond-venda  = decla-import-adic.val-vmcv.
                END. /* IF  decla-import-adic-parc.idi-tip-pagto = 1 OR decla-import-adic-parc.idi-tip-pagto = 2 */
                /*--------------------------------------------------------------------------------------------------------------------*/
        END. /* FOR EACH decla-import-adic-parc */

        /*---[ Registro tipo 07 - detalhe mercadoria ]------------------------------------------------------------------------*/        
        ASSIGN i-conta-mercadoria = 0.
        FOR EACH  decla-import-adic-itens NO-LOCK
            WHERE decla-import-adic-itens.num-di-ems       = decla-import.num-di-ems
            AND   decla-import-adic-itens.cdd-siscomex-dts = decla-import.cdd-siscomex-dts
            AND   decla-import-adic-itens.num-adic         = decla-import-adic.num-adic:

            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Itens_da_Adi‡Æo" *}
            RUN pi-acompanhar IN h-acomp (INPUT RETURN-VALUE + ' : ' + STRING(decla-import-adic-itens.cod-item)).

            CREATE tt-det-merc.
            ASSIGN tt-det-merc.cod-registro         = 7
                   tt-det-merc.num-di-ems           = decla-import-adic-itens.num-di-ems
                   tt-det-merc.num-adic             = decla-import-adic-itens.num-adic
                   tt-det-merc.seq-det-mercadoria   = i-conta-mercadoria
                   tt-det-merc.dsl-espec-mercadoria = decla-import-adic-itens.dsl-especif
                   tt-det-merc.qtde-item-adic       = decla-import-adic-itens.qtd-adic[1]
                   tt-det-merc.vl-unit-cond-venda   = decla-import-adic-itens.val-vucv
                   i-conta-mercadoria               = i-conta-mercadoria + 1.

            FOR FIRST bf_ordens-embarque NO-LOCK 
                WHERE bf_ordens-embarque.cod-estabel  = decla-import-adic-itens.cod-estab
                AND   bf_ordens-embarque.embarque     = decla-import-adic-itens.cod-embarq
                AND   bf_ordens-embarque.numero-ordem = decla-import-adic-itens.num-ordem
                AND   bf_ordens-embarque.parcela      = decla-import-adic-itens.num-parcela,
                FIRST bf_ordem-compra NO-LOCK
                WHERE bf_ordem-compra.numero-ordem = bf_ordens-embarque.numero-ordem:

                FOR FIRST bf_prazo-compra NO-LOCK
                    WHERE bf_prazo-compra.numero-ordem = bf_ordem-compra.numero-ordem:

                    FOR FIRST bf_tab-unidade NO-LOCK
                        WHERE bf_tab-unidade.un = bf_prazo-compra.un:
                        ASSIGN tt-det-merc.desc-un-ordem = bf_tab-unidade.descricao.
                    END. /* FOR FIRST bf_tab-unidade NO-LOCK */
                END. /* FOR FIRST bf_prazo-compra NO-LOCK */
            END. /* FOR FIRST bf_ordem-compra NO-LOCK */
        END. /* FOR EACH  decla-import-adic-itens */
        /*--------------------------------------------------------------------------------------------------------------------*/

        /*---[ Registro tipo 08 - acr‚scimo valoriza‡Æo ]---------------------------------------------------------------------*/
        FOR EACH  despes-adic NO-LOCK
            WHERE despes-adic.num-di-ems       = decla-import-adic.num-di-ems
            AND   despes-adic.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts
            AND   despes-adic.num-adic         = decla-import-adic.num-adic:

            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Despesas_da_Adi‡Æo" *}
            RUN pi-acompanhar IN h-acomp (INPUT RETURN-VALUE + ' : ' + STRING(despes-adic.cdn-despes)).

            CREATE tt-acres-val.
            ASSIGN tt-acres-val.cod-registro      = 8
                   tt-acres-val.num-di-ems        = despes-adic.num-di-ems
                   tt-acres-val.num-adic          = despes-adic.num-adic
                   tt-acres-val.cod-desp-siscomex = despes-adic.cdn-despes.
                   
            RUN pi-retorna-moeda (INPUT despes-adic.cdn-moeda,  OUTPUT tt-acres-val.cod-moeda-siscomex).

            IF  despes-adic.cdn-moeda <> 0 THEN DO:
                RUN valor-cotado(INPUT  despes-adic.num-di-ems,
                                 INPUT  despes-adic.cdd-siscomex-dts,
                                 INPUT  despes-adic.cdn-moed,
                                 INPUT  decla-import.dat-di,
                                 INPUT  despes-adic.val-despes,
                                 OUTPUT d-valor-cotado,
                                 OUTPUT d-cotacao).
                ASSIGN tt-acres-val.vl-desp-me = despes-adic.val-despes
                       tt-acres-val.vl-desp-mn = d-valor-cotado.
            END. /* IF  despes-adic.cdn-moeda <> 0 */
            ELSE ASSIGN tt-acres-val.vl-desp-me = 0
                        tt-acres-val.vl-desp-mn = despes-adic.val-despes.
        END. /* FOR EACH  despes-adic */
        /*--------------------------------------------------------------------------------------------------------------------*/

        /*---[ Registro tipo 09 - documento vinculado ]-----------------------------------------------------------------------*/
        FOR EACH  decla-import-adic-docto NO-LOCK
            WHERE decla-import-adic-docto.num-di-ems       = decla-import-adic.num-di-ems
            AND   decla-import-adic-docto.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts
            AND   decla-import-adic-docto.num-adic         = decla-import-adic.num-adic:

            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Documentos_Vinculados_da_Adi‡Æo" *}
            RUN pi-acompanhar IN h-acomp (INPUT RETURN-VALUE + ' : ' + STRING(decla-import-adic-docto.cod-num-docto)).

            CREATE tt-docto-vinc.
            ASSIGN tt-docto-vinc.cod-registro = 9
                   tt-docto-vinc.num-di-ems   = decla-import-adic-docto.num-di-ems
                   tt-docto-vinc.num-adic     = decla-import-adic-docto.num-adic
                   tt-docto-vinc.id-docto     = IF decla-import-adic-docto.cod-num-docto <> "" THEN INT(decla-import-adic-docto.cod-num-docto) ELSE 0.

            CASE decla-import-adic-docto.idi-tip-docto-vincul:
                WHEN 1 THEN ASSIGN tt-docto-vinc.cod-docto-vinc = 2. /* DI */
                WHEN 2 THEN ASSIGN tt-docto-vinc.cod-docto-vinc = 3. /* RE */
            END CASE.
        END. /* FOR EACH  decla-import-adic-docto */
        /*--------------------------------------------------------------------------------------------------------------------*/

        /*---[ Registro tipo 10 - tributo ]-----------------------------------------------------------------------------------*/
        FIND FIRST bf_classif-fisc NO-LOCK
            WHERE  bf_classif-fisc.class-fiscal = decla-import-adic.cod-classif-fisc NO-ERROR.
        IF  AVAIL bf_classif-fisc THEN DO:
            FIND FIRST bf_tab-unidade NO-LOCK
                WHERE  bf_tab-unidade.un = bf_classif-fisc.unidade NO-ERROR.
            IF  AVAIL  bf_tab-unidade 
            THEN ASSIGN v-descUN-class-fisc = bf_tab-unidade.descricao.
            ELSE ASSIGN v-descUN-class-fisc = "".
        END.

        /*---[ Imposto de Importa‡Æo ] --------------------------------------------------*/
        IF  decla-import-adic.val-aliq-ii > 0 OR decla-import-adic.val-unit-ii > 0 THEN DO:
            CREATE tt-tributo.
            ASSIGN tt-tributo.cod-registro      = 10
                   tt-tributo.num-di-ems        = decla-import-adic.num-di-ems
                   tt-tributo.num-adic          = decla-import-adic.num-adic
                   tt-tributo.cod-trib-siscomex = 1.
            
            IF decla-import-adic.val-aliq-ii > 0 AND decla-import-adic.val-unit-ii = 0 THEN ASSIGN tt-tributo.tipo-aliq-imposto = 1. 
            IF decla-import-adic.val-aliq-ii = 0 AND decla-import-adic.val-unit-ii > 0 THEN ASSIGN tt-tributo.tipo-aliq-imposto = 2. 
            IF decla-import-adic.val-aliq-ii > 0 AND decla-import-adic.val-unit-ii > 0 THEN ASSIGN tt-tributo.tipo-aliq-imposto = 3. 

            ASSIGN tt-tributo.base-calc-ad-valorem = decla-import-adic.val-base-ii
                   tt-tributo.perc-aliq-imposto    = decla-import-adic.val-aliq-ii
                   tt-tributo.vl-calc-impostos     = decla-import-adic.val-ii-db-cr
                   tt-tributo.desc-un-class-fiscal = v-descUN-class-fisc
                   tt-tributo.tipo-recip-siscomex  = decla-import-adic.cod-tip-recip
                   tt-tributo.capac-recipiente     = decla-import-adic.qtd-capac-recip
                   tt-tributo.qtde-un-ncm          = decla-import-adic.qtd-ncm
                   tt-tributo.vl-imposto-unidade   = decla-import-adic.val-unit-ii
                   tt-tributo.cod-trib-ipi         = ""
                   tt-tributo.perc-aliq-reduzida   = decla-import-adic.val-perc-reduc-impto-import.
        
        END. /* IF  decla-import-adic.val-aliq-ii */

        /*---[ Imposto sobre Produtos Industrializados ] --------------------------------*/
        IF  decla-import-adic.val-aliq-ipi > 0 OR decla-import-adic.val-unit-ipi > 0 THEN DO:
            CREATE tt-tributo.
            ASSIGN tt-tributo.cod-registro      = 10
                   tt-tributo.num-di-ems        = decla-import-adic.num-di-ems
                   tt-tributo.num-adic          = decla-import-adic.num-adic
                   tt-tributo.cod-trib-siscomex = 2.
            
            IF decla-import-adic.val-aliq-ipi > 0 AND decla-import-adic.val-unit-ipi = 0 THEN ASSIGN tt-tributo.tipo-aliq-imposto = 1. 
            IF decla-import-adic.val-aliq-ipi = 0 AND decla-import-adic.val-unit-ipi > 0 THEN ASSIGN tt-tributo.tipo-aliq-imposto = 2. 
            IF decla-import-adic.val-aliq-ipi > 0 AND decla-import-adic.val-unit-ipi > 0 THEN ASSIGN tt-tributo.tipo-aliq-imposto = 3. 

            ASSIGN tt-tributo.base-calc-ad-valorem = decla-import-adic.val-base-ipi
                   tt-tributo.perc-aliq-imposto    = decla-import-adic.val-aliq-ipi
                   tt-tributo.vl-calc-impostos     = decla-import-adic.val-ipi-db-cr
                   tt-tributo.desc-un-class-fiscal = v-descUN-class-fisc
                   tt-tributo.tipo-recip-siscomex  = decla-import-adic.cod-tip-recip
                   tt-tributo.capac-recipiente     = decla-import-adic.qtd-capac-recip
                   tt-tributo.qtde-un-ncm          = decla-import-adic.qtd-ncm
                   tt-tributo.vl-imposto-unidade   = decla-import-adic.val-unit-ipi
                   tt-tributo.perc-aliq-reduzida   = decla-import-adic.val-perc-reduc-ipi.

            IF  decla-import-adic.log-suspens-ipi-import 
            THEN ASSIGN tt-tributo.cod-trib-ipi = "05":U.
            ELSE DO:
                CASE decla-import-adic.idi-tributac-ipi :
                    WHEN 1 /* Tributado */ THEN ASSIGN tt-tributo.cod-trib-ipi = "04":U.
                    WHEN 2 /* Isento    */ THEN ASSIGN tt-tributo.cod-trib-ipi = "01":U.
                    WHEN 3 /* Outros    */ THEN ASSIGN tt-tributo.cod-trib-ipi = "03":U.
                    WHEN 4 /* Reduzido  */ THEN ASSIGN tt-tributo.cod-trib-ipi = "02":U.
                END CASE.
            END. /* ELSE DO: */
        END. /* IF  decla-import-adic.val-aliq-ipi */

        /*---[ PIS/PASEP ] --------------------------------------------------------------*/
        IF  decla-import-adic.val-aliq-pis > 0 OR decla-import-adic.val-unit-pis > 0 THEN DO:
            CREATE tt-tributo.
            ASSIGN tt-tributo.cod-registro      = 10
                   tt-tributo.num-di-ems        = decla-import-adic.num-di-ems
                   tt-tributo.num-adic          = decla-import-adic.num-adic
                   tt-tributo.cod-trib-siscomex = 5.
            
            IF decla-import-adic.val-aliq-pis > 0 AND decla-import-adic.val-unit-pis = 0 THEN ASSIGN tt-tributo.tipo-aliq-imposto = 1. 
            IF decla-import-adic.val-aliq-pis = 0 AND decla-import-adic.val-unit-pis > 0 THEN ASSIGN tt-tributo.tipo-aliq-imposto = 2. 
            IF decla-import-adic.val-aliq-pis > 0 AND decla-import-adic.val-unit-pis > 0 THEN ASSIGN tt-tributo.tipo-aliq-imposto = 3. 

            ASSIGN tt-tributo.base-calc-ad-valorem = decla-import-adic.val-base-pis
                   tt-tributo.perc-aliq-imposto    = decla-import-adic.val-aliq-pis
                   tt-tributo.vl-calc-impostos     = decla-import-adic.val-pis-db-cr
                   tt-tributo.desc-un-class-fiscal = v-descUN-class-fisc
                   tt-tributo.tipo-recip-siscomex  = decla-import-adic.cod-tip-recip
                   tt-tributo.capac-recipiente     = decla-import-adic.qtd-capac-recip
                   tt-tributo.qtde-un-ncm          = decla-import-adic.qtd-ncm
                   tt-tributo.vl-imposto-unidade   = decla-import-adic.val-unit-pis
                   tt-tributo.cod-trib-ipi         = ""
                   tt-tributo.perc-aliq-reduzida   = decla-import-adic.val-perc-reduc-pis.
        END. /* IF  decla-import-adic.val-aliq-pis */

        /*---[ COFINS ] -----------------------------------------------------------------*/
        IF  decla-import-adic.val-aliq-cofins > 0 OR decla-import-adic.val-unit-cofins > 0 THEN DO:
            CREATE tt-tributo.
            ASSIGN tt-tributo.cod-registro      = 10
                   tt-tributo.num-di-ems        = decla-import-adic.num-di-ems
                   tt-tributo.num-adic          = decla-import-adic.num-adic
                   tt-tributo.cod-trib-siscomex = 6.
            
            IF decla-import-adic.val-aliq-cofins > 0 AND decla-import-adic.val-unit-cofins = 0 THEN ASSIGN tt-tributo.tipo-aliq-imposto = 1. 
            IF decla-import-adic.val-aliq-cofins = 0 AND decla-import-adic.val-unit-cofins > 0 THEN ASSIGN tt-tributo.tipo-aliq-imposto = 2. 
            IF decla-import-adic.val-aliq-cofins > 0 AND decla-import-adic.val-unit-cofins > 0 THEN ASSIGN tt-tributo.tipo-aliq-imposto = 3. 
            
            ASSIGN tt-tributo.base-calc-ad-valorem = decla-import-adic.val-base-cofins
                   tt-tributo.perc-aliq-imposto    = decla-import-adic.val-aliq-cofins
                   tt-tributo.vl-calc-impostos     = decla-import-adic.val-cofins-db-cr
                   tt-tributo.desc-un-class-fiscal = v-descUN-class-fisc
                   tt-tributo.tipo-recip-siscomex  = decla-import-adic.cod-tip-recip
                   tt-tributo.capac-recipiente     = decla-import-adic.qtd-capac-recip
                   tt-tributo.qtde-un-ncm          = decla-import-adic.qtd-ncm
                   tt-tributo.vl-imposto-unidade   = decla-import-adic.val-unit-cofins
                   tt-tributo.cod-trib-ipi         = ""
                   tt-tributo.perc-aliq-reduzida   = decla-import-adic.val-perc-reduc-cofins.
        END. /* IF  decla-import-adic.val-aliq-cofins */
        /*--------------------------------------------------------------------------------------------------------------------*/

        /*---[ Registro tipo 11 - valora‡Æo NCM ]-----------------------------------------------------------------------------*/
        FOR EACH  decla-import-adic-nve NO-LOCK
            WHERE decla-import-adic-nve.num-di-ems       = decla-import-adic.num-di-ems
            AND   decla-import-adic-nve.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts
            AND   decla-import-adic-nve.num-adic         = decla-import-adic.num-adic:

            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "NVEs_da_Adi‡Æo" *}
            RUN pi-acompanhar IN h-acomp (INPUT RETURN-VALUE + ' : ' + STRING(decla-import-adic-nve.cod-atributo)).

            CREATE tt-valor-ncm.
            ASSIGN tt-valor-ncm.cod-registro    = 11
                   tt-valor-ncm.num-di-ems      = decla-import-adic-nve.num-di-ems
                   tt-valor-ncm.num-adic        = decla-import-adic-nve.num-adic
                   tt-valor-ncm.cod-atrib-ncm   = decla-import-adic-nve.cod-atributo
                   tt-valor-ncm.cod-especif-ncm = decla-import-adic-nve.cdn-especif.
            
            CASE decla-import-adic-nve.idi-niv:
                WHEN 6 /* Sub-Item      */ THEN ASSIGN tt-valor-ncm.num-abrang-ncm = 3.
                WHEN 5 /* Item          */ THEN ASSIGN tt-valor-ncm.num-abrang-ncm = 6.
                WHEN 4 /* Sub-Posi‡Æo 2 */ THEN ASSIGN tt-valor-ncm.num-abrang-ncm = 5.
                WHEN 3 /* Sub-Posi‡Æo 1 */ THEN ASSIGN tt-valor-ncm.num-abrang-ncm = 4.
                WHEN 2 /* Posi‡Æo       */ THEN ASSIGN tt-valor-ncm.num-abrang-ncm = 2.
                WHEN 1 /* Cap¡tulo      */ THEN ASSIGN tt-valor-ncm.num-abrang-ncm = 1.
            END CASE.
        
        END. /* FOR EACH  decla-import-adic-nve */
        /*--------------------------------------------------------------------------------------------------------------------*/

        /*---[ Registro tipo 12 - destaques NCM ]-----------------------------------------------------------------------------*/        
        CREATE tt-dest-ncm.
        ASSIGN tt-dest-ncm.cod-registro = 12
               tt-dest-ncm.num-di-ems   = decla-import-adic.num-di-ems
               tt-dest-ncm.num-adic     = decla-import-adic.num-adic.

        FOR FIRST bf_classif-destaq NO-LOCK
            WHERE bf_classif-destaq.class-fiscal = decla-import-adic.cod-classif-fisc:
            ASSIGN tt-dest-ncm.num-destaque-ncm = bf_classif-destaq.cod-destaq.
        END. /* FOR FIRST bf_classif-destaq NO-LOCK */
        /*--------------------------------------------------------------------------------------------------------------------*/

        /*---[ Registro tipo 13 - ato vinculado ]-----------------------------------------------------------------------------*/
        CREATE tt-ato-vinc.
        ASSIGN tt-ato-vinc.cod-registro     = 13
               tt-ato-vinc.num-di-ems       = decla-import-adic.num-di-ems
               tt-ato-vinc.num-adic         = decla-import-adic.num-adic
               tt-ato-vinc.cod-assunto-vinc = 1
               tt-ato-vinc.num-ex-ncm       = decla-import-adic.cdn-classif-fisc-ex.

        /* tt-ato-vinc.cod-assunto-vinc: 1 - Ato de Cria‡Æo do EX da NCM
                             2 - Ato de Cria‡Æo do EX da NBM
                             3 - Ato de Cria‡Æo do EX da NALADI/SH ou NALADI/NCCA
                             4 - Ato que ampara o Benef¡cio Fiscal de IPI
                             5 - Ato de Promulga‡Æo do Acordo Tarif rio
                             6 - Ato para Direito Antidumping e compensat¢rio 
           Neste projeto (0079) estaremos contemplando apenas o c¢digo 1, conforme j  existente no EMS, 
           na tela CD0903 - Cadastro Itens Faturamento na pasta "Fiscal" */
        /*--------------------------------------------------------------------------------------------------------------------*/
    END. /* FOR EACH  decla-import-adic */
    /*--------------------------------------------------------------------------------------------------------------------*/
END. /* FOR FIRST decla-import NO-LOCK */
/*--------------------------------------------------------------------------------------------------------------------*/

/*---[ Gera‡Æo do arquivo texto ]-------------------------------------------------------------------------------------*/
OUTPUT TO VALUE(tt-param.arq-entrada).

FIND FIRST tt-decla-import NO-LOCK NO-ERROR.
IF  AVAIL tt-decla-import THEN DO:
    FOR FIRST tt-inform-arq NO-LOCK: 
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Registro_tipo" *}
        RUN pi-acompanhar IN h-acomp (INPUT RETURN-VALUE + ' : ' + STRING(tt-inform-arq.cod-registro) + " " + string(TIME, "hh:mm:ss")).
        RUN pi-geratxt-inform-arq. /* registro tipo 00 */
    END. /* FOR FIRST tt-inform-arq */

    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Registro_tipo" *}
    RUN pi-acompanhar IN h-acomp (INPUT RETURN-VALUE + ' : ' + STRING(tt-decla-import.cod-registro) + " " + string(TIME, "hh:mm:ss")).
    RUN pi-geratxt-di. /* registro tipo 01 */
        
    FOR EACH tt-processos-di NO-LOCK:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Registro_tipo" *}
        RUN pi-acompanhar IN h-acomp (INPUT RETURN-VALUE + ' : ' + STRING(tt-processos-di.cod-registro) + " " + string(TIME, "hh:mm:ss")).
        RUN pi-geratxt-processos-di. /* registro tipo 02 */
    END. /* FOR EACH tt-processos-di */

    FOR EACH tt-embal-di NO-LOCK:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Registro_tipo" *}
        RUN pi-acompanhar IN h-acomp (INPUT RETURN-VALUE + ' : ' + STRING(tt-embal-di.cod-registro) + " " + string(TIME, "hh:mm:ss")).
        RUN pi-geratxt-embal-di. /* registro tipo 03 */
    END. /* FOR EACH tt-embal-di */

    FOR EACH tt-adic-di NO-LOCK:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Registro_tipo" *}
        RUN pi-acompanhar IN h-acomp (INPUT RETURN-VALUE + ' : ' + STRING(tt-adic-di.cod-registro) + " " + string(TIME, "hh:mm:ss")).
        RUN pi-geratxt-adic. /* registro tipo 04 */

        FOR EACH  tt-pagto-prev NO-LOCK
            WHERE tt-pagto-prev.num-di-ems = tt-adic-di.num-di-ems
            AND   tt-pagto-prev.num-adic   = tt-adic-di.num-adic:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Registro_tipo" *}
            RUN pi-acompanhar IN h-acomp (INPUT RETURN-VALUE + ' : ' + STRING(tt-pagto-prev.cod-registro) + " " + string(TIME, "hh:mm:ss")).
            RUN pi-geratxt-pagto-prev. /* registro tipo 05 */
        END. /* FOR EACH  tt-pagto-prev */

        FOR EACH  tt-pagto-vinc NO-LOCK
            WHERE tt-pagto-vinc.num-di-ems = tt-adic-di.num-di-ems
            AND   tt-pagto-vinc.num-adic   = tt-adic-di.num-adic:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Registro_tipo" *}
            RUN pi-acompanhar IN h-acomp (INPUT RETURN-VALUE + ' : ' + STRING(tt-pagto-vinc.cod-registro) + " " + string(TIME, "hh:mm:ss")).
            RUN pi-geratxt-pagto-vinc. /* registro tipo 06 */
        END. /* FOR EACH  tt-pagto-vinc */
        
        FOR EACH  tt-det-merc NO-LOCK
            WHERE tt-det-merc.num-di-ems = tt-adic-di.num-di-ems
            AND   tt-det-merc.num-adic   = tt-adic-di.num-adic:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Registro_tipo" *}
            RUN pi-acompanhar IN h-acomp (INPUT RETURN-VALUE + ' : ' + STRING(tt-det-merc.cod-registro) + " " + string(TIME, "hh:mm:ss")).
            RUN pi-geratxt-det-merc. /* registro tipo 07 */
        END. /* FOR EACH  tt-det-merc */
                                          
        FOR EACH  tt-acres-val NO-LOCK
            WHERE tt-acres-val.num-di-ems = tt-adic-di.num-di-ems 
            AND   tt-acres-val.num-adic   = tt-adic-di.num-adic:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Registro_tipo" *}
            RUN pi-acompanhar IN h-acomp (INPUT RETURN-VALUE + ' : ' + STRING(tt-acres-val.cod-registro) + " " + string(TIME, "hh:mm:ss")).
            RUN pi-geratxt-acres-val. /* registro tipo 08 */
        END. /* FOR EACH  tt-acres-val */

        FOR EACH  tt-docto-vinc NO-LOCK
            WHERE tt-docto-vinc.num-di-ems = tt-adic-di.num-di-ems
            AND   tt-docto-vinc.num-adic   = tt-adic-di.num-adic:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Registro_tipo" *}
            RUN pi-acompanhar IN h-acomp (INPUT RETURN-VALUE + ' : ' + STRING(tt-docto-vinc.cod-registro) + " " + string(TIME, "hh:mm:ss")).
            RUN pi-geratxt-docto-vinc. /* registro tipo 09 */
        END. /* FOR EACH  tt-docto-vinc */

        FOR EACH  tt-tributo NO-LOCK
            WHERE tt-tributo.num-di-ems = tt-adic-di.num-di-ems
            AND   tt-tributo.num-adic   = tt-adic-di.num-adic:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Registro_tipo" *}
            RUN pi-acompanhar IN h-acomp (INPUT RETURN-VALUE + ' : ' + STRING(tt-tributo.cod-registro) + " " + string(TIME, "hh:mm:ss")).
            RUN pi-geratxt-tributo. /* registro tipo 10 */
        END. /* FOR EACH  tt-tributo */

        FOR EACH  tt-valor-ncm NO-LOCK
            WHERE tt-valor-ncm.num-di-ems = tt-adic-di.num-di-ems
            AND   tt-valor-ncm.num-adic   = tt-adic-di.num-adic:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Registro_tipo" *}
            RUN pi-acompanhar IN h-acomp (INPUT RETURN-VALUE + ' : ' + STRING(tt-valor-ncm.cod-registro) + " " + string(TIME, "hh:mm:ss")).
            RUN pi-geratxt-valor-ncm. /* registro tipo 11 */
        END. /* FOR EACH  tt-valor-ncm */

        FOR EACH  tt-dest-ncm NO-LOCK
            WHERE tt-dest-ncm.num-di-ems = tt-adic-di.num-di-ems
            AND   tt-dest-ncm.num-adic   = tt-adic-di.num-adic:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Registro_tipo" *}
            RUN pi-acompanhar IN h-acomp (INPUT RETURN-VALUE + ' : ' + STRING(tt-dest-ncm.cod-registro) + " " + string(TIME, "hh:mm:ss")).
            RUN pi-geratxt-dest-ncm. /* registro tipo 12 */
        END. /* FOR EACH  tt-dest-ncm */

        FOR EACH  tt-ato-vinc NO-LOCK
            WHERE tt-ato-vinc.num-di-ems = tt-adic-di.num-di-ems 
            AND   tt-ato-vinc.num-adic   = tt-adic-di.num-adic:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Registro_tipo" *}
            RUN pi-acompanhar IN h-acomp (INPUT RETURN-VALUE + ' : ' + STRING(tt-ato-vinc.cod-registro) + " " + string(TIME, "hh:mm:ss")).
            RUN pi-geratxt-ato-vinc. /* registro tipo 13 */
        END. /* FOR EACH  tt-ato-vinc */
    END. /* FOR EACH tt-adic-di */
END. /* IF  AVAIL tt-decla-import */

OUTPUT CLOSE.
/*---[ Fim da gera‡Æo ]-----------------------------------------------------------------------------------------------*/

/*--------------------------------[ EmissÆo do relat¢rio ]---------------------------------------*/
{include/i-rpvar.i}
run utp/ut-trfrrp.p (input frame f-parametros:handle).
{include/i-rpcab.i}

FIND FIRST empresa NO-LOCK WHERE empresa.ep-codigo = i-ep-codigo-usuario NO-ERROR.
ASSIGN c-programa 	  = "IM0450RP":U
       c-versao	      = "2.04":U
	   c-revisao	  = ".00.000":U
	   c-empresa 	  = empresa.razao-social
       c-sistema	  = ""
	   c-titulo-relat = "Gerador Dados DI Siscomex":U.

{include/i-rpout.i} 
VIEW FRAME f-cabec.
VIEW FRAME f-rodape.
PAGE.

CASE tt-param.destino:
    WHEN 1 /* Impressora */ THEN ASSIGN c-destino = "Destino: [X] Impressora     [ ] Arquivo     [ ] Terminal":U.
    WHEN 2 /* Arquivo    */ THEN ASSIGN c-destino = "Destino: [ ] Impressora     [X] Arquivo     [ ] Terminal":U.
    WHEN 3 /* Terminal   */ THEN ASSIGN c-destino = "Destino: [ ] Impressora     [ ] Arquivo     [X] Terminal":U.
END CASE.

DISP c-parametro          
     tt-param.num-di-ems  
     tt-param.arq-entrada 
     tt-param.usuario     
     tt-param.nome-usuario
     tt-param.banco-access
     c-impressao          
     c-destino 
     tt-param.arq-destino with frame f-parametros.

{include/i-rpclo.i} 
RUN pi-finalizar IN h-acomp.

RETURN "OK":U.
/*-----------------------------[ FIM da EmissÆo do relat¢rio ]-----------------------------------*/

/*-----------------------------------[ PROCEDURES ]----------------------------------------------*/
PROCEDURE pi-retorna-moeda:
    DEF  INPUT PARAM pmo-codigo LIKE moeda.mo-codigo NO-UNDO.
    DEF OUTPUT PARAM pcod-decex LIKE moeda.cod-decex NO-UNDO.

    FOR FIRST moeda NO-LOCK
        WHERE moeda.mo-codigo = pmo-codigo:
        ASSIGN pcod-decex = moeda.cod-decex.
    END. /* FOR FIRST moeda NO-LOCK */
END. /* PROCEDURE pi-retorna-moeda */

PROCEDURE pi-geratxt-inform-arq:
    PUT tt-inform-arq.cod-registro                 FORMAT "99":U
        tt-inform-arq.num-di-ems                   FORMAT "999999999":U
        FN-FREE-ACCENT(tt-inform-arq.nome-arquivo) FORMAT "x(30)":U
        tt-inform-arq.data-geracao                 FORMAT "99999999":U
        tt-inform-arq.hora-geracao                 FORMAT "9999":U SKIP.

    RETURN "OK":U.
END. /* PROCEDURE pi-geratxt-inform-arq: */

PROCEDURE pi-geratxt-di:
    PUT tt-decla-import.cod-registro                           FORMAT "99":U             
        tt-decla-import.num-di-ems                             FORMAT "999999999":U      
        tt-decla-import.tipo                                   FORMAT "99":U             
        FN-FREE-ACCENT(tt-decla-import.cnpj-estab)             FORMAT "x(14)":U          
        tt-decla-import.modal-despacho                         FORMAT "99":U             
        FN-FREE-ACCENT(tt-decla-import.fundap)                 FORMAT "x(3)":U           
        tt-decla-import.un-receita-entrada                     FORMAT ">>>>>>9":U        
        tt-decla-import.un-receita-despacho                    FORMAT ">>>>>>9":U        
        tt-decla-import.carac-import                           FORMAT "9":U              
        FN-FREE-ACCENT(tt-decla-import.cnpj-consig)            FORMAT "x(14)":U          
        FN-FREE-ACCENT(tt-decla-import.cod-pais-proced)        FORMAT "x(03)":U
        tt-decla-import.cod-via-transp                         FORMAT "99":U             
        FN-FREE-ACCENT(tt-decla-import.ind-transp-multimodal)  FORMAT "x(03)":U          
        FN-FREE-ACCENT(tt-decla-import.nome-transp)            FORMAT "x(60)":U          
        tt-decla-import.cod-pais-siscomex-transp               FORMAT "999":U            
        tt-decla-import.nat-pessoa                             FORMAT "9":U              
        FN-FREE-ACCENT(tt-decla-import.cnpj-agente)            FORMAT "x(14)":U          
        tt-decla-import.tipo-conhec                            FORMAT "99":U             
        FN-FREE-ACCENT(tt-decla-import.num-docto-carga-house)  FORMAT "x(18)":U          
        FN-FREE-ACCENT(tt-decla-import.num-dcoto-carga-master) FORMAT "x(18)":U          
        FN-FREE-ACCENT(tt-decla-import.nome-local-emb)         FORMAT "x(50)":U          
        tt-decla-import.dt-embarque                            FORMAT "99999999":U       
        tt-decla-import.ind-utiliza                            FORMAT "9":U              
        (tt-decla-import.peso-bruto-total * 100000)            FORMAT "99999999999999":U
        (tt-decla-import.peso-liq-total * 100000)              FORMAT "99999999999999":U
        tt-decla-import.dt-chegada-urf                         FORMAT "99999999":U       
        tt-decla-import.tipo-manifesto                         FORMAT "9":U              
        FN-FREE-ACCENT(tt-decla-import.id-manifesto)           FORMAT "x(15)":U          
        tt-decla-import.recinto-alfandegado                    FORMAT ">>>>>>9":U        
        tt-decla-import.setor-armazena                         FORMAT ">>9":U            
        tt-decla-import.cod-moeda-frete                        FORMAT "999":U            
        (tt-decla-import.vl-total-frete-me * 100)              FORMAT "9999999999999":U 
        (tt-decla-import.vl-total-frete-mn * 100)              FORMAT "9999999999999":U 
        tt-decla-import.cod-moeda-seguro                       FORMAT "999":U            
        (tt-decla-import.vl-total-seguro-me * 100)             FORMAT "9999999999999":U 
        (tt-decla-import.vl-total-seguro-mn * 100)             FORMAT "9999999999999":U 
        tt-decla-import.cod-moeda-di                           FORMAT "999":U            
        (tt-decla-import.vl-merc-local-emb-me * 100)           FORMAT "9999999999999":U 
        (tt-decla-import.vl-merc-local-emb-mn * 100)           FORMAT "9999999999999":U 
        FN-FREE-ACCENT(tt-decla-import.inf-complemento)        FORMAT "x(3900)":U SKIP.       

    RETURN "OK":U.
END. /* PROCEDURE pi-geratxt-di: */

PROCEDURE pi-geratxt-processos-di:
    PUT tt-processos-di.cod-registro                FORMAT "99":U       
        tt-processos-di.num-di-ems                  FORMAT "999999999":U
        tt-processos-di.tipo-processo-vinc          FORMAT "9":U        
        FN-FREE-ACCENT(tt-processos-di.id-processo) FORMAT "x(20)":U SKIP.   

    RETURN "OK":U.
END. /* PROCEDURE pi-geratxt-processos-di: */

PROCEDURE pi-geratxt-embal-di:
    PUT tt-embal-di.cod-registro       FORMAT "99":U       
        tt-embal-di.num-di-ems         FORMAT "999999999":U
        tt-embal-di.cod-embal-siscomex FORMAT "99":U       
        tt-embal-di.qtde-volumes       FORMAT "999999":U SKIP.

    RETURN "OK":U.
END. /* PROCEDURE pi-geratxt-embal-di: */

PROCEDURE pi-geratxt-adic:
    PUT tt-adic-di.cod-registro                           FORMAT "99":U              
        tt-adic-di.num-di-ems                             FORMAT "999999999":U       
        tt-adic-di.num-adic                               FORMAT "999":U             
        FN-FREE-ACCENT(tt-adic-di.nome-export)            FORMAT "x(60)":U           
        FN-FREE-ACCENT(tt-adic-di.end-export)             FORMAT "x(40)":U           
        FN-FREE-ACCENT(tt-adic-di.cidade-export)          FORMAT "x(25)":U           
        FN-FREE-ACCENT(tt-adic-di.nome-estado-export)     FORMAT "x(25)":U           
        tt-adic-di.pais-export                            FORMAT "999":U             
        tt-adic-di.ncm-merc                               FORMAT "99999999":U        
        tt-adic-di.log-forn-fabricante                    FORMAT "9":U               
        FN-FREE-ACCENT(tt-adic-di.nome-fabricante)        FORMAT "x(60)":U           
        FN-FREE-ACCENT(tt-adic-di.end-fabricante)         FORMAT "x(40)":U           
        FN-FREE-ACCENT(tt-adic-di.cidade-fabricante)      FORMAT "x(25)":U           
        FN-FREE-ACCENT(tt-adic-di.nome-estado-fabricante) FORMAT "x(25)":U           
        tt-adic-di.pais-fabricante                        FORMAT "999":U             
        tt-adic-di.cod-nbm                                FORMAT "99999999":U        
        tt-adic-di.cod-naladi-ncc                         FORMAT "99999999":U        
        tt-adic-di.cod-naladi-sh                          FORMAT "99999999":U        
        (tt-adic-di.peso-liq-adic * 100)                  FORMAT "999999999999999":U
        (tt-adic-di.qtde-medida-ncm * 100000)             FORMAT "99999999999999":U 
        tt-adic-di.cod-aplic-mercadoria                   FORMAT "9":U               
        tt-adic-di.cod-moeda-negoc                        FORMAT "999":U             
        FN-FREE-ACCENT(tt-adic-di.cod-incoterm)           FORMAT "x(03)":U           
        (tt-adic-di.vl-merc-cond-venda-me * 100)          FORMAT "999999999999999":U
        (tt-adic-di.vl-merc-cond-venda-mn * 100)          FORMAT "999999999999999":U
        (tt-adic-di.vl-frete-adic-mn * 100)               FORMAT "999999999999999":U
        (tt-adic-di.vl-seguro-adic-mn * 100)              FORMAT "999999999999999":U
        tt-adic-di.met-valora                             FORMAT "99":U              
        FN-FREE-ACCENT(tt-adic-di.acordo-tarif)           FORMAT "x(01)":U           
        FN-FREE-ACCENT(tt-adic-di.acordo-aladi)           FORMAT "x(03)":U           
        tt-adic-di.cod-trib-ii                            FORMAT "9":U               
        tt-adic-di.cobertura-cambial                      FORMAT "9":U               
        tt-adic-di.modalidade-pagto                       FORMAT "99":U              
        tt-adic-di.cod-motito-sem-cobert                  FORMAT "99":U              
        (tt-adic-di.vl-financ-superior * 100)             FORMAT "999999999999999":U
        FN-FREE-ACCENT(tt-adic-di.id-rof)                 FORMAT "x(20)":U           
        FN-FREE-ACCENT(tt-adic-di.ind-mat-encomenda)      FORMAT "x(01)":U           
        FN-FREE-ACCENT(tt-adic-di.ind-mat-usado)          FORMAT "x(01)":U           
        FN-FREE-ACCENT(tt-adic-di.complemento-adic)       FORMAT "x(250)":U          
        FN-FREE-ACCENT(tt-adic-di.ind-ipi-ntribut)        FORMAT "x(03)":U           
        (tt-adic-di.vl-merc-local-emb-mn * 100)           FORMAT "999999999999999":U
        (tt-adic-di.vl-merc-local-desp-mn * 100)          FORMAT "999999999999999":U
        tt-adic-di.num-li-adic                            FORMAT "9999999999":U      
        (tt-adic-di.aliq-icms * 100)                      FORMAT "99999":U
        FN-FREE-ACCENT(tt-adic-di.reduc-pis-cofins)       FORMAT "x(01)":U           
        tt-adic-di.cod-trib-pis-cofins                    FORMAT "9":U SKIP.              

    RETURN "OK":U.
END. /* PROCEDURE pi-geratxt-adic: */

PROCEDURE pi-geratxt-pagto-prev:
    PUT tt-pagto-prev.cod-registro       FORMAT "99":U              
        tt-pagto-prev.num-di-ems         FORMAT "999999999":U       
        tt-pagto-prev.num-adic           FORMAT "999":U             
        tt-pagto-prev.seq-parcela        FORMAT "99":U              
        (tt-pagto-prev.vl-parcela * 100) FORMAT "999999999999999":U
        tt-pagto-prev.dt-prev-pagto      FORMAT "999999":U SKIP.

    RETURN "OK":U.
END. /* PROCEDURE pi-geratxt-pagto-prev: */

PROCEDURE pi-geratxt-pagto-vinc:
    PUT tt-pagto-vinc.cod-registro               FORMAT "99":U               
        tt-pagto-vinc.num-di-ems                 FORMAT "999999999":U        
        tt-pagto-vinc.num-adic                   FORMAT "999":U              
        tt-pagto-vinc.seq-parcela                FORMAT "99":U               
        tt-pagto-vinc.tipo-parcela               FORMAT "9":U                
        tt-pagto-vinc.cod-banco                  FORMAT "99999":U            
        tt-pagto-vinc.cod-praca                  FORMAT "9999":U             
        tt-pagto-vinc.num-contrato-cambio        FORMAT "9999999999":U       
        (tt-pagto-vinc.vl-merc-cond-venda * 100) FORMAT "999999999999999":U SKIP.

    RETURN "OK":U.
END. /* PROCEDURE pi-geratxt-pagto-vinc: */

PROCEDURE pi-geratxt-det-merc:
    PUT tt-det-merc.cod-registro                         FORMAT "99":U                
        tt-det-merc.num-di-ems                           FORMAT "999999999":U         
        tt-det-merc.num-adic                             FORMAT "999":U               
        tt-det-merc.seq-det-mercadoria                   FORMAT "99":U                
        FN-FREE-ACCENT(tt-det-merc.dsl-espec-mercadoria) FORMAT "x(3900)":U           
        (tt-det-merc.qtde-item-adic * 100)               FORMAT "99999999999999":U   
        FN-FREE-ACCENT(tt-det-merc.desc-un-ordem)        FORMAT "x(20)":U             
        (tt-det-merc.vl-unit-cond-venda * 100)           FORMAT "999999999999999":U SKIP. 

    RETURN "OK":U.
END. /* PROCEDURE pi-geratxt-det-merc: */

PROCEDURE pi-geratxt-acres-val:
    PUT tt-acres-val.cod-registro       FORMAT "99":U               
        tt-acres-val.num-di-ems         FORMAT "999999999":U        
        tt-acres-val.num-adic           FORMAT "999":U              
        tt-acres-val.cod-desp-siscomex  FORMAT "999":U              
        (tt-acres-val.vl-desp-me * 100) FORMAT "999999999999999":U 
        tt-acres-val.cod-moeda-siscomex FORMAT "999":U              
        (tt-acres-val.vl-desp-mn * 100) FORMAT "999999999999999":U SKIP.

    RETURN "OK":U.
END. /* PROCEDURE pi-geratxt-acres-val: */

PROCEDURE pi-geratxt-docto-vinc:
    PUT tt-docto-vinc.cod-registro   FORMAT "99":U
        tt-docto-vinc.num-di-ems     FORMAT "999999999":U
        tt-docto-vinc.num-adic       FORMAT "999":U
        tt-docto-vinc.cod-docto-vinc FORMAT "9":U
        tt-docto-vinc.id-docto       FORMAT "999999999999999":U SKIP.

    RETURN "OK":U.
END. /* PROCEDURE pi-geratxt-docto-vinc: */

PROCEDURE pi-geratxt-tributo:
    PUT tt-tributo.cod-registro                         FORMAT "99":U
        tt-tributo.num-di-ems                           FORMAT "999999999":U
        tt-tributo.num-adic                             FORMAT "999":U
        tt-tributo.cod-trib-siscomex                    FORMAT "9999":U
        tt-tributo.tipo-aliq-imposto                    FORMAT "9":U
        tt-tributo.base-calc-ad-valorem                 FORMAT "999999999999999":U
        (tt-tributo.perc-aliq-imposto * 100)            FORMAT "99999":U          
        (tt-tributo.vl-calc-impostos * 100)             FORMAT "999999999999999":U
        FN-FREE-ACCENT(tt-tributo.desc-un-class-fiscal) FORMAT "x(15)":U           
        tt-tributo.tipo-recip-siscomex                  FORMAT "99":U              
        tt-tributo.capac-recipiente                     FORMAT "99999999":U        
        tt-tributo.qtde-un-ncm                          FORMAT "999999999":U       
        (tt-tributo.vl-imposto-unidade * 1000000)       FORMAT "99999999999":U
        FN-FREE-ACCENT(tt-tributo.cod-trib-ipi)         FORMAT "x(02)":U
        (tt-tributo.perc-aliq-reduzida * 100)           FORMAT "9999":U SKIP.

    RETURN "OK":U.
END. /* PROCEDURE pi-geratxt-tributo: */

PROCEDURE pi-geratxt-valor-ncm:
    PUT tt-valor-ncm.cod-registro                  FORMAT "99":U
        tt-valor-ncm.num-di-ems                    FORMAT "999999999":U
        tt-valor-ncm.num-adic                      FORMAT "999":U
        tt-valor-ncm.num-abrang-ncm                FORMAT "9":U
        FN-FREE-ACCENT(tt-valor-ncm.cod-atrib-ncm) FORMAT "x(02)":U
        tt-valor-ncm.cod-especif-ncm               FORMAT "9999":U SKIP.

    RETURN "OK":U.
END. /* PROCEDURE pi-geratxt-valor-ncm: */

PROCEDURE pi-geratxt-dest-ncm:
    PUT tt-dest-ncm.cod-registro     FORMAT "99":U
        tt-dest-ncm.num-di-ems       FORMAT "999999999":U
        tt-dest-ncm.num-adic         FORMAT "999":U
        tt-dest-ncm.num-destaque-ncm FORMAT "99999":U SKIP.
    
    RETURN "OK":U.
END. /* PROCEDURE pi-geratxt-dest-ncm: */

PROCEDURE pi-geratxt-ato-vinc:
    PUT tt-ato-vinc.cod-registro      FORMAT "99":U
        tt-ato-vinc.num-di-ems        FORMAT "999999999":U
        tt-ato-vinc.num-adic          FORMAT "999":U      
        tt-ato-vinc.cod-assunto-vinc  FORMAT "9":U        
        tt-ato-vinc.num-ex-ncm        FORMAT "99":U SKIP.

    RETURN "OK":U.
END. /* PROCEDURE pi-geratxt-ato-vinc: */

/*------------------------------------------------------------------------------*/
PROCEDURE pi-carrega-tt:
    DEF INPUT  PARAM pnum-di-ems    LIKE decla-import.num-di-ems NO-UNDO.
    DEF OUTPUT PARAM pparam-data    AS   DATE NO-UNDO.
    DEF OUTPUT PARAM pparam-desc    AS   CHAR NO-UNDO.
    
    DEF VAR i-conta AS INTEGER NO-UNDO.

    FOR FIRST bf_histor-decla-import NO-LOCK
        WHERE bf_histor-decla-import.num-di-ems = pnum-di-ems:
        
        ASSIGN i-conta = 0.
        FOR EACH  bf_decla-import-embarq NO-LOCK
            WHERE bf_decla-import-embarq.num-di-ems = bf_histor-decla-import.num-di-ems,
            EACH  historico-embarque NO-LOCK
            WHERE historico-embarque.cod-estabel = bf_decla-import-embarq.cod-estab
            AND   historico-embarque.embarque    = bf_decla-import-embarq.cod-embarq:
    
            ASSIGN i-conta = i-conta + 1.
    
            CREATE tt-auxiliar.
            ASSIGN tt-auxiliar.cod-estabel   = historico-embarque.cod-estabel  
                   tt-auxiliar.embarque      = historico-embarque.embarque     
                   tt-auxiliar.cod-itiner    = historico-embarque.cod-itiner   
                   tt-auxiliar.sequencia     = historico-embarque.sequencia    
                   tt-auxiliar.cod-pto-contr = historico-embarque.cod-pto-contr
                   tt-auxiliar.dt-efetiva    = historico-embarque.dt-efetiva 
                   tt-auxiliar.dt-ult-prev   = historico-embarque.dt-ult-prev
                   tt-auxiliar.num-registro  = i-conta.
        END.
    END.

    IF  CAN-FIND(FIRST tt-auxiliar
                 WHERE tt-auxiliar.dt-efetiva <> ?) THEN DO: 
        RUN pi-acha-a-data (INPUT 'efetiva':U, OUTPUT pparam-data, OUTPUT pparam-desc).
    END. /* IF  CAN-FIND(FIRST tt-auxiliar */
    ELSE IF  CAN-FIND(FIRST tt-auxiliar
                      WHERE tt-auxiliar.dt-ult-prev <> ?) THEN DO:
             RUN pi-acha-a-data (INPUT 'prevista':U, OUTPUT pparam-data, OUTPUT pparam-desc).
         END. /* IF  CAN-FIND(FIRST tt-auxiliar */
         ELSE DO:
             RUN pi-acha-a-data (INPUT 'embarque':U, OUTPUT pparam-data, OUTPUT pparam-desc).
         END. /* ELSE DO: */
END PROCEDURE.

PROCEDURE pi-acha-a-data:
    DEF INPUT  PARAM pparam      AS CHAR NO-UNDO.
    DEF OUTPUT PARAM pparam-data AS DATE NO-UNDO.
    DEF OUTPUT PARAM pparam-desc AS CHAR NO-UNDO.

    DEF VAR v-data-usada AS DATE NO-UNDO.

    IF  pparam = 'efetiva':U THEN DO:
        FOR EACH tt-auxiliar:
            IF  tt-auxiliar.num-registro = 1 
            THEN ASSIGN tt-auxiliar.dt-usada       = tt-auxiliar.dt-efetiva
                        v-data-usada               = tt-auxiliar.dt-usada
                        tt-auxiliar.log-data-maior = YES.
            ELSE IF  tt-auxiliar.dt-efetiva > v-data-usada 
                 THEN ASSIGN tt-auxiliar.log-data-maior = YES
                             tt-auxiliar.dt-usada       = tt-auxiliar.dt-efetiva 
                             v-data-usada               = tt-auxiliar.dt-usada.
        END. /* FOR EACH tt-auxiliar: */
        
        /*---[ limpando sujeiras ]---------------------*/
        FOR EACH tt-auxiliar
            WHERE tt-auxiliar.dt-usada <> v-data-usada:
            ASSIGN tt-auxiliar.log-data-maior = NO
                   tt-auxiliar.dt-usada = ?.
        END. /* FOR EACH  tt-auxiliar */
        /*---------------------------------------------*/
    
        FOR FIRST tt-auxiliar 
            WHERE tt-auxiliar.log-data-maior:
            ASSIGN pparam-data = tt-auxiliar.dt-usada.
            FOR FIRST pto-contr NO-LOCK
                WHERE pto-contr.cod-pto-contr = tt-auxiliar.cod-pto-contr:
                FIND FIRST unid-rf NO-LOCK
                    WHERE  unid-rf.cdn-unid-recta-feder = pto-contr.unid-referencial NO-ERROR.
                IF  AVAIL  unid-rf 
                THEN ASSIGN pparam-desc = unid-rf.des-descr.
                ELSE ASSIGN pparam-desc = "".
            END. /* FOR FIRST pto-contr */
        END. /* FOR FIRST tt-auxiliar */
    END. /* IF  pparam = 'efetiva':U THEN DO: */
    ELSE 
        IF  pparam = 'prevista':U THEN DO:
            FOR EACH tt-auxiliar:
                IF  tt-auxiliar.num-registro = 1 
                THEN ASSIGN tt-auxiliar.dt-usada       = tt-auxiliar.dt-ult-prev
                            v-data-usada               = tt-auxiliar.dt-usada
                            tt-auxiliar.log-data-maior = YES.
                ELSE IF  tt-auxiliar.dt-ult-prev > v-data-usada 
                     THEN ASSIGN tt-auxiliar.log-data-maior = YES
                                 tt-auxiliar.dt-usada       = tt-auxiliar.dt-ult-prev 
                                 v-data-usada               = tt-auxiliar.dt-usada.
            END. /* FOR EACH tt-auxiliar: */
            
            FOR EACH  tt-auxiliar
                WHERE tt-auxiliar.dt-usada <> v-data-usada:
                ASSIGN tt-auxiliar.log-data-maior = NO
                       tt-auxiliar.dt-usada = ?.
            END. /* FOR EACH  tt-auxiliar */
        
            FOR FIRST tt-auxiliar 
                WHERE tt-auxiliar.log-data-maior:
                ASSIGN pparam-data = tt-auxiliar.dt-usada.
                FOR FIRST pto-contr NO-LOCK
                    WHERE pto-contr.cod-pto-contr = tt-auxiliar.cod-pto-contr:
                    FIND FIRST unid-rf NO-LOCK
                        WHERE  unid-rf.cdn-unid-recta-feder = pto-contr.unid-referencial NO-ERROR.
                    IF  AVAIL  unid-rf 
                    THEN ASSIGN pparam-desc = unid-rf.des-descr.
                    ELSE ASSIGN pparam-desc = "".
                END. /* FOR FIRST pto-contr */
            END. /* FOR FIRST tt-auxiliar */
        END.
        ELSE 
            FOR EACH tt-auxiliar BREAK BY tt-auxiliar.embarque:
                IF  LAST-OF(tt-auxiliar.embarque) THEN DO:
                    ASSIGN pparam-data = tt-auxiliar.dt-usada.
                    FOR FIRST pto-contr NO-LOCK
                        WHERE pto-contr.cod-pto-contr = tt-auxiliar.cod-pto-contr:
                        FIND FIRST unid-rf NO-LOCK
                            WHERE  unid-rf.cdn-unid-recta-feder = pto-contr.unid-referencial NO-ERROR.
                        IF  AVAIL  unid-rf 
                        THEN ASSIGN pparam-desc = unid-rf.des-descr.
                        ELSE ASSIGN pparam-desc = "".
                    END. /* FOR FIRST pto-contr */
                END. /* IF  LAST-OF(tt-auxiliar.embarque) */
            END. /* FOR EACH tt-auxiliar */
END PROCEDURE.

/*-----------------------------------[ PROCEDURES ]----------------------------------------------*/
