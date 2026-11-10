/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0430RP 2.00.00.015 } /*** "010015" 22/01/2026 09:25:04 ***/
/********************************************************************************
***
*** IM0430 - Gerador de Arquivo Excel
***
********************************************************************************/

{utp/ut-glob.i}
{include/tt-edit.i}
{include/pi-edit.i}

{imp/im0430.i} /*Defini‡Æo da tt-param*/
{cxbo/bocx396.i tt-decla-import-proc}


DEFINE INPUT PARAMETER TABLE FOR tt-param.
DEFINE INPUT PARAMETER TABLE FOR tt-digita.

/* Defini‡Æo de vari veis locais */
DEF VAR h-acomp                        as handle                                                   NO-UNDO.
DEF VAR i-paginas                      AS INT                                                      NO-UNDO.
DEF VAR c-di-siscomex                  LIKE decla-import.cod-di-siscomex                           NO-UNDO.
DEF VAR d-data-reg                     LIKE decla-import.dat-di                                    NO-UNDO.
DEF VAR i-di-ems                       LIKE decla-import.num-di-ems                                NO-UNDO.
DEF VAR c-desc-uni-rf                  LIKE unid-rf.des-descr                                      NO-UNDO.
DEF VAR c-tip-decla                    AS CHAR                                                     NO-UNDO.
DEF VAR c-modal-desp                   AS CHAR                                                     NO-UNDO.
DEF VAR i-qtd-adic                     LIKE decla-import.num-adicoes                               NO-UNDO.
DEF VAR c-importador-cnpj              LIKE emitente.cgc                                           NO-UNDO.   
DEF VAR c-importador-nome              LIKE emitente.nome-emit                                     NO-UNDO.
DEF VAR c-adquire-cnpj                 LIKE emitente.cgc                                           NO-UNDO.
DEF VAR c-adquire-nome                 LIKE emitente.nome-emit                                     NO-UNDO.    
DEF VAR c-repres-legal-cpf             LIKE emitente.cgc                                           NO-UNDO.
DEF VAR c-repres-legal-nome            LIKE emitente.nome-emit                                     NO-UNDO.
                                       
DEF VAR c-tipo-processo-vinc           AS CHAR                                                     NO-UNDO.
DEF VAR c-identifica-proces            AS CHAR                                                     NO-UNDO.
                                       
DEF VAR c-tipo-manifesto               as char                                                     NO-UNDO.
DEF VAR c-numero-manifesto             as char                                                     NO-UNDO.
DEF VAR c-recinto-aduan                as char                                                     NO-UNDO.
DEF VAR c-embal                        as char                                                     NO-UNDO.
DEF VAR c-qtd-embal                    as char                                                     NO-UNDO.
                                       
DEF VAR d-peso-bruto                   AS DECIMAL                                                  NO-UNDO.
DEF VAR d-peso-liquido                 AS DECIMAL                                                  NO-UNDO.
                                       
DEF VAR c-frete-moeda                  LIKE moeda.descricao                                        NO-UNDO.
DEF VAR d-frete-valor                  LIKE decla-import.val-frete                                 NO-UNDO.
DEF VAR c-seguro-moeda                 LIKE moeda.descricao                                        NO-UNDO.
DEF VAR d-seguro-valor                 LIKE decla-import.val-seguro                                NO-UNDO.
DEF VAR c-vmle-moeda                   LIKE moeda.descricao                                        NO-UNDO.
DEF VAR d-vmle-valor                   LIKE decla-import.val-vmle                                  NO-UNDO.
DEF VAR c-vmld-moeda                   LIKE moeda.descricao                                        NO-UNDO.
DEF VAR d-vmld-valor                   LIKE decla-import.val-vmld                                  NO-UNDO.
                                       
DEF VAR d-ii-suspenso                  LIKE decla-import.val-ii-nao-tribut                         NO-UNDO.
DEF VAR d-ii-recolher                  LIKE decla-import.val-ii-db-cr                              NO-UNDO.
DEF VAR d-ipi-suspenso                 LIKE decla-import.val-ipi-nao-tributad                      NO-UNDO.
DEF VAR d-ipi-recolher                 LIKE decla-import.val-ipi-db-cr                             NO-UNDO.
DEF VAR d-pis-recolher                 LIKE decla-import.val-pis-db-cr                             NO-UNDO.
DEF VAR d-cofins-recolher              LIKE decla-import.val-cofins-db-cr                          NO-UNDO.
DEF VAR d-cbs-recolher                 LIKE decla-import.val-cofins-db-cr                          NO-UNDO.
DEF VAR d-ibsuf-recolher               LIKE decla-import.val-cofins-db-cr                          NO-UNDO.
DEF VAR d-ibsmun-recolher              LIKE decla-import.val-cofins-db-cr                          NO-UNDO.
DEF VAR d-val-ibsmun-reg               LIKE decla-import.val-cofins-db-cr                          NO-UNDO.
DEF VAR d-val-ibsuf-reg                LIKE decla-import.val-cofins-db-cr                          NO-UNDO.
DEF VAR d-val-cbs-reg                  LIKE decla-import.val-cofins-db-cr                          NO-UNDO.
                                       
DEF VAR c-info-comp                    LIKE decla-import.cod-inf-compltar                          NO-UNDO.
                                       
DEF VAR i-num-adic                     LIKE decla-import-adic.num-adic                             NO-UNDO.
DEF VAR c-cod-licenc-import            LIKE decla-import-adic.cod-licenc-import                    NO-UNDO.
DEF VAR c-tip-docto-vincul             AS CHAR                                                     NO-UNDO.
DEF VAR c-cod-num-docto                LIKE decla-import-adic-docto.cod-num-docto                  NO-UNDO.
                                       
DEF VAR c-nome-export                  LIKE emitente.nome-emit                                     NO-UNDO.
DEF VAR c-pais-export                  LIKE emitente.pais                                          NO-UNDO.
                                       
DEF VAR c-nome-fabrican                LIKE emitente.nome-emit                                     NO-UNDO.
DEF VAR c-pais-fabrican                LIKE emitente.pais                                          NO-UNDO.
                                       
DEF VAR c-classif-fisc                 LIKE decla-import-adic.cod-classif-fisc                     NO-UNDO.
DEF VAR c-desc-classif-fisc            LIKE classif-fisc.des-descr-detdo                           NO-UNDO.
DEF VAR c-cod-nbm                      LIKE decla-import-adic.cod-nbm                              NO-UNDO.
                                       
DEF VAR c-cod-incoterm                 LIKE decla-import-adic.cod-incoterm                         NO-UNDO.
DEF VAR c-desc-incoterm                LIKE inco-cx.descricao                                      NO-UNDO.
DEF VAR d-valor-vmcv                   LIKE decla-import-adic.val-vmcv                             NO-UNDO.
DEF VAR c-moeda-vmcv                   LIKE moeda.descricao                                        NO-UNDO.

DEF VAR d-peso-liq-adic                LIKE decla-import-adic.val-peso-liq                         NO-UNDO.
                                       
DEF VAR c-especif-itens                LIKE decla-import-adic-itens.dsl-especif                    NO-UNDO.
DEF VAR d-itens-qtd-adic               LIKE decla-import-adic-itens.qtd-adic[1]                    NO-UNDO.
DEF VAR c-tab-unid-desc                LIKE tab-unidade.descricao                                  NO-UNDO.
DEF VAR d-valor-vucv                   LIKE decla-import-adic-itens.val-vucv                       NO-UNDO.
DEF VAR c-moeda-vucv                   LIKE moeda.descricao                                        NO-UNDO.

DEF VAR c-idi-tributac-impto-import    AS CHAR                                                     NO-UNDO.
DEF VAR d-val-aliq-ii                  LIKE decla-import-adic.val-aliq-ii                          NO-UNDO.
DEF VAR d-val-unit-ii                  LIKE decla-import-adic.val-unit-ii                          NO-UNDO.
DEF VAR d-val-ii-db-cr                 LIKE decla-import-adic.val-ii-db-cr                         NO-UNDO.

DEF VAR c-idi-tributac-ipi             AS CHAR                                                     NO-UNDO.
DEF VAR d-val-aliq-ipi                 LIKE decla-import-adic.val-aliq-ipi                         NO-UNDO.
DEF VAR d-val-unit-ipi                 LIKE decla-import-adic.val-unit-ipi                         NO-UNDO.
DEF VAR d-val-ipi-db-cr                LIKE decla-import-adic.val-ipi-db-cr                        NO-UNDO.

DEF VAR d-val-base-pis                 LIKE decla-import-adic.val-base-pis                         NO-UNDO.
DEF VAR d-perc-reduc-pis               LIKE decla-import-adic.val-perc-reduc-pis                   NO-UNDO.
DEF VAR c-idi-tribut-pis               AS CHAR                                                     NO-UNDO.
DEF VAR d-val-base-cofins              LIKE decla-import-adic.val-base-cofins                      NO-UNDO.
DEF VAR d-perc-reduc-cofins            LIKE decla-import-adic.val-perc-reduc-cofins                NO-UNDO.
DEF VAR c-idi-tribut-cofins            AS CHAR                                                     NO-UNDO.
DEF VAR d-val-aliq-icms                LIKE decla-import-adic.val-aliq-icms                        NO-UNDO.


DEF VAR d-val-aliq-pis                 LIKE decla-import-adic.val-aliq-pis                         NO-UNDO.
DEF VAR d-val-unit-pis                 LIKE decla-import-adic.val-unit-pis                         NO-UNDO.
DEF VAR d-val-devido-pis               AS DECIMAL FORMAT ">>>,>>>,>>9.99"                          NO-UNDO.
DEF VAR d-val-pis-db-cr                LIKE decla-import-adic.val-pis-db-cr                        NO-UNDO.

DEF VAR d-val-aliq-cofins              LIKE decla-import-adic.val-aliq-cofins                      NO-UNDO.
DEF VAR d-val-unit-cofins              LIKE decla-import-adic.val-unit-cofins                      NO-UNDO.
DEF VAR d-val-devido-cofins            AS DECIMAL FORMAT ">>>,>>>,>>9.99"                          NO-UNDO.
DEF VAR d-val-cofins-db-cr             LIKE decla-import-adic.val-cofins-db-cr                     NO-UNDO.
DEF VAR d-val-devido-cbs               AS DECIMAL FORMAT ">>>,>>>,>>9.99"                          NO-UNDO.
DEF VAR d-val-devido-ibsuf             AS DECIMAL FORMAT ">>>,>>>,>>9.99"                          NO-UNDO.
DEF VAR d-val-devido-ibsmun            AS DECIMAL FORMAT ">>>,>>>,>>9.99"                          NO-UNDO.
DEF VAR d-val-recolher-cbs             AS DECIMAL FORMAT ">>>,>>>,>>9.99"                          NO-UNDO.
DEF VAR d-val-recolher-ibsuf           AS DECIMAL FORMAT ">>>,>>>,>>9.99"                          NO-UNDO.
DEF VAR d-val-recolher-ibsmun          AS DECIMAL FORMAT ">>>,>>>,>>9.99"                          NO-UNDO.
DEF VAR d-cbs-susp                     AS DECIMAL FORMAT ">>>,>>>,>>9.99"                          NO-UNDO.
DEF VAR d-ibsuf-susp                   AS DECIMAL FORMAT ">>>,>>>,>>9.99"                          NO-UNDO.
DEF VAR d-ibsmun-susp                  AS DECIMAL FORMAT ">>>,>>>,>>9.99"                          NO-UNDO.
DEF VAR d-val-aliq-cbs                 AS DECIMAL FORMAT ">>9.99"                                  NO-UNDO.
DEF VAR d-val-aliq-ibsuf               AS DECIMAL FORMAT ">>9.99"                                  NO-UNDO.
DEF VAR d-val-aliq-ibsmun              AS DECIMAL FORMAT ">>9.99"                                  NO-UNDO.
DEF VAR d-aliq-cbs-reg                 AS DECIMAL FORMAT ">>9.99"                                  NO-UNDO.
DEF VAR d-aliq-ibsuf-reg               AS DECIMAL FORMAT ">>9.99"                                  NO-UNDO.
DEF VAR d-aliq-ibsmun-reg              AS DECIMAL FORMAT ">>9.99"                                  NO-UNDO.

DEF VAR l-first-decla-import-embal     AS LOGICAL         INITIAL yes                              NO-UNDO.
DEF VAR l-first-decla-import           AS LOGICAL         INITIAL yes                              NO-UNDO.
DEF VAR l-nt2024002                    AS LOGICAL                                                  NO-UNDO.

/* definicÆo das vari veis de formato */
DEF VAR c-fmt-cpf         LIKE param-global.formato-id-pessoal NO-UNDO.
DEF VAR c-fmt-cnpj        LIKE param-global.formato-id-federal NO-UNDO.
DEF VAR c-fmt-di-siscomex AS CHAR INITIAL "99/9999999-9"       NO-UNDO.

FIND FIRST param-global NO-LOCK NO-ERROR.
IF AVAIL param-global THEN
    ASSIGN c-fmt-cpf  = param-global.formato-id-pessoal
           c-fmt-cnpj = param-global.formato-id-federal.
           
ASSIGN l-nt2024002 = CAN-FIND(FIRST funcao NO-LOCK
                              WHERE funcao.cd-funcao = "spp-NT2024002" AND funcao.ativo).

/* fim - definicÆo das vari veis de formato */


/* XML */
def var iLineCount               as int                     no-undo.
def var iColCount                as int                     no-undo.
def var iColumns                 as int                     no-undo.
                                                            
def var cStyle                   as char                    no-undo.
def var cStyleDtTrans            as char                    no-undo.
def var cStyleQuantidade         as char                    no-undo.
def var cStyleMatMobGgf          as char                    no-undo.
                                                            
def var cNumericFormat           as char                    no-undo.

function fnSkipCol  returns char (input pNumberColsToSkip as int)  forward.
function fnSkipLine returns char (input pNumberLinesToSkip as int) forward.
function fnSkipSheet returns char () forward.

DEF VAR iCountPage  AS INT NO-UNDO.

/* XML */


/* Defini‡Æo e Tradu‡Æo das Labels */
DEF VAR c-lbl-di-siscomex       AS CHAR NO-UNDO.
DEF VAR c-lbl-data-reg          AS CHAR NO-UNDO.
DEF VAR c-lbl-di-ems            AS CHAR NO-UNDO.
                                
DEF VAR c-lbl-modal-desp        AS CHAR NO-UNDO.
DEF VAR c-lbl-qtd-adic          AS CHAR NO-UNDO.
                                
DEF VAR c-lbl-importador        AS CHAR NO-UNDO.
DEF VAR c-lbl-importador-cnpj   AS CHAR NO-UNDO.
DEF VAR c-lbl-adquirente        AS CHAR NO-UNDO.
DEF VAR c-lbl-adquirente-cnpj   AS CHAR NO-UNDO.
DEF VAR c-lbl-repres-legal      AS CHAR NO-UNDO.
DEF VAR c-lbl-repres-legal-cpf  AS CHAR NO-UNDO.

DEF VAR c-lbl-processo          AS CHAR NO-UNDO.
DEF VAR c-lbl-ident             AS CHAR NO-UNDO.

DEF VAR c-lbl-carga             AS CHAR NO-UNDO.
DEF VAR c-lbl-tipo-manifesto    AS CHAR NO-UNDO.
DEF VAR c-lbl-numero-manifesto  AS CHAR NO-UNDO.
DEF VAR c-lbl-recinto-aduan     AS CHAR NO-UNDO.
DEF VAR c-lbl-embal             AS CHAR NO-UNDO.
DEF VAR c-lbl-qtd-embal         AS CHAR NO-UNDO.
DEF VAR c-lbl-peso-bruto        AS CHAR NO-UNDO.
DEF VAR c-lbl-peso-liquido      AS CHAR NO-UNDO.

DEF VAR c-lbl-valores           AS CHAR NO-UNDO.
DEF VAR c-lbl-moeda             AS CHAR NO-UNDO.
DEF VAR c-lbl-valor             AS CHAR NO-UNDO.
DEF VAR c-lbl-frete             AS CHAR NO-UNDO.
DEF VAR c-lbl-seguro            AS CHAR NO-UNDO.
DEF VAR c-lbl-vmle              AS CHAR NO-UNDO.
DEF VAR c-lbl-vmld              AS CHAR NO-UNDO.

DEF VAR c-lbl-tributos          AS CHAR NO-UNDO.
DEF VAR c-lbl-tributos-rt       AS CHAR NO-UNDO.
DEF VAR c-lbl-tributos-rt-reg   AS CHAR NO-UNDO.
DEF VAR c-lbl-suspenso          AS CHAR NO-UNDO.
DEF VAR c-lbl-recolher          AS CHAR NO-UNDO.
DEF VAR c-lbl-ii                AS CHAR NO-UNDO.
DEF VAR c-lbl-ipi               AS CHAR NO-UNDO.
DEF VAR c-lbl-pis               AS CHAR NO-UNDO.
DEF VAR c-lbl-cofins            AS CHAR NO-UNDO.
DEF VAR c-lbl-cbs               AS CHAR NO-UNDO.
DEF VAR c-lbl-ibsuf             AS CHAR NO-UNDO.
DEF VAR c-lbl-ibsmun            AS CHAR NO-UNDO.
DEF VAR c-lbl-cbs-reg           AS CHAR NO-UNDO.
DEF VAR c-lbl-ibsuf-reg         AS CHAR NO-UNDO.
DEF VAR c-lbl-ibsmun-reg        AS CHAR NO-UNDO.

DEF VAR c-lbl-data              AS CHAR NO-UNDO.
DEF VAR c-lbl-mascara           AS CHAR NO-UNDO.
DEF VAR c-lbl-assinatura        AS CHAR NO-UNDO.

DEF VAR c-lbl-info-comp         AS CHAR NO-UNDO.

DEF VAR c-lbl-adic              AS CHAR NO-UNDO.
DEF VAR c-lbl-num-li            AS CHAR NO-UNDO.
DEF VAR c-lbl-docto-vincul      AS CHAR NO-UNDO.
DEF VAR c-lbl-num-docto-vincul  AS CHAR NO-UNDO.

DEF VAR c-lbl-exportador        AS CHAR NO-UNDO.
DEF VAR c-lbl-nome-export       AS CHAR NO-UNDO.
DEF VAR c-lbl-pais-export       AS CHAR NO-UNDO.

DEF VAR c-lbl-fabri-prod        AS CHAR NO-UNDO.
DEF VAR c-lbl-nome-fabrican     AS CHAR NO-UNDO.
DEF VAR c-lbl-pais-fabrican     AS CHAR NO-UNDO.

DEF VAR c-lbl-class-tribut      AS CHAR NO-UNDO.
DEF VAR c-lbl-ncm               AS CHAR NO-UNDO.
DEF VAR c-lbl-nbm               AS CHAR NO-UNDO.

DEF VAR c-lbl-cond-venda        AS CHAR NO-UNDO.
DEF VAR c-lbl-incoterm          AS CHAR NO-UNDO.
DEF VAR c-lbl-vmcv              AS CHAR NO-UNDO.

DEF VAR c-lbl-peso-liq-adic     AS CHAR NO-UNDO.

DEF VAR c-lbl-desc-det-merc     AS CHAR NO-UNDO.
DEF VAR c-lbl-qtde              AS CHAR NO-UNDO.
DEF VAR c-lbl-vucv              AS CHAR NO-UNDO.

DEF VAR c-lbl-valor-recolher    AS CHAR NO-UNDO.
DEF VAR c-lbl-aliq-unit         AS CHAR NO-UNDO.
DEF VAR c-lbl-reg-tribut        AS CHAR NO-UNDO.
DEF VAR c-lbl-valor-devido      AS CHAR NO-UNDO.
DEF VAR c-lbl-aliq-especif      AS CHAR NO-UNDO.
DEF VAR c-lbl-aliq-ad-valorem   AS CHAR NO-UNDO.

DEF VAR c-lbl-imp-imp           AS CHAR NO-UNDO.
DEF VAR c-lbl-aliq-adval-tec    AS CHAR NO-UNDO.

DEF VAR c-lbl-imp-prod-ind      AS CHAR NO-UNDO.
DEF VAR c-lbl-aliq-adval-tipi   AS CHAR NO-UNDO.

DEF VAR c-lbl-dados-pis         AS CHAR NO-UNDO.
DEF VAR c-lbl-dados-cofins      AS CHAR NO-UNDO.
DEF VAR c-lbl-base-calc         AS CHAR NO-UNDO.
DEF VAR c-lbl-perc-reduc        AS CHAR NO-UNDO.

DEF VAR c-lbl-aliq-icms         AS CHAR NO-UNDO.

DEF VAR c-lbl-pis-pasep         AS CHAR NO-UNDO.
DEF VAR c-lbl-cofins2            AS CHAR NO-UNDO.

{utp/ut-liter.i Declara‡Æo: *}
assign c-lbl-di-siscomex = return-value.
{utp/ut-liter.i Data_do_Registro: *}
assign c-lbl-data-reg = return-value.
{utp/ut-liter.i DI-EMS: *}
assign c-lbl-di-ems = return-value.
{utp/ut-liter.i Modalidade_do_Despacho: *}
assign c-lbl-modal-desp = return-value.
{utp/ut-liter.i Quantidade_de_Adi‡äes: *}
assign c-lbl-qtd-adic = return-value.
{utp/ut-liter.i Importador: *}
assign c-lbl-importador = return-value.
{utp/ut-liter.i CNPJ: *}
assign c-lbl-importador-cnpj = return-value.
{utp/ut-liter.i Adquirente_da_Mercadoria: *}
assign c-lbl-adquirente = return-value.
{utp/ut-liter.i CNPJ: *}
assign c-lbl-adquirente-cnpj = return-value.
{utp/ut-liter.i Representante_Legal: *}
assign c-lbl-repres-legal = return-value.
{utp/ut-liter.i CPF: *}
assign c-lbl-repres-legal-cpf = return-value.

{utp/ut-liter.i Processos *}
assign c-lbl-processo = return-value.
{utp/ut-liter.i Ident.: *}
assign c-lbl-ident = return-value.

{utp/ut-liter.i Carga *}
assign c-lbl-carga = return-value.
{utp/ut-liter.i Tipo_do_Manifesto *}
assign c-lbl-tipo-manifesto = return-value.
{utp/ut-liter.i N£mero_do_Manifesto *}
assign c-lbl-numero-manifesto = return-value.
{utp/ut-liter.i Recinto_Aduaneiro *}
assign c-lbl-recinto-aduan = return-value.
{utp/ut-liter.i Embalagem *}
assign c-lbl-embal = return-value.
{utp/ut-liter.i Quantidade *}
assign c-lbl-qtd-embal = return-value.
{utp/ut-liter.i Peso_Bruto *}
assign c-lbl-peso-bruto = return-value.
{utp/ut-liter.i Peso_L¡quido *}
assign c-lbl-peso-liquido = return-value.

{utp/ut-liter.i Valores *}
assign c-lbl-valores = return-value.
{utp/ut-liter.i Moeda *}
assign c-lbl-moeda = return-value.
{utp/ut-liter.i Valor *}
assign c-lbl-valor = return-value.
{utp/ut-liter.i Frete *}
assign c-lbl-frete = return-value.
{utp/ut-liter.i Seguro *}
assign c-lbl-seguro = return-value.
{utp/ut-liter.i VMLE *}
assign c-lbl-vmle = return-value.
{utp/ut-liter.i VMLD *}
assign c-lbl-vmld = return-value.

{utp/ut-liter.i Tributos *}
assign c-lbl-tributos = return-value.
{utp/ut-liter.i Tributos_RT *}
assign c-lbl-tributos-rt = return-value.
{utp/ut-liter.i Tributos_RT_Regular *}
assign c-lbl-tributos-rt-reg = return-value.
{utp/ut-liter.i Suspenso *}
assign c-lbl-suspenso = return-value.
{utp/ut-liter.i A_Recolher *}
assign c-lbl-recolher = return-value.
{utp/ut-liter.i I.I.: *}
assign c-lbl-ii = return-value.
{utp/ut-liter.i I.P.I: *}
assign c-lbl-ipi = return-value.
{utp/ut-liter.i Pis/Paesp: *}
assign c-lbl-pis = return-value.
{utp/ut-liter.i Cofins: *}
assign c-lbl-cofins = return-value.
{utp/ut-liter.i CBS: *}
assign c-lbl-cbs = return-value.
{utp/ut-liter.i IBS_UF: *}
assign c-lbl-ibsuf = return-value.
{utp/ut-liter.i IBS_Municipal: *}
assign c-lbl-ibsmun = return-value.
{utp/ut-liter.i CBS_Regular: *}
assign c-lbl-cbs-reg = return-value.
{utp/ut-liter.i IBS_UF_Regular: *}
assign c-lbl-ibsuf-reg = return-value.
{utp/ut-liter.i IBS_Municipal_Regular: *}
assign c-lbl-ibsmun-reg = return-value.

{utp/ut-liter.i Data_emissÆo: *}
assign c-lbl-data = return-value.
assign c-lbl-mascara = "____/____/____".
{utp/ut-liter.i Assinatura_do_Representante_Legal *}
assign c-lbl-assinatura = return-value.

{utp/ut-liter.i Dados_Complementares *}
assign c-lbl-info-comp = return-value.

{utp/ut-liter.i Adi‡Æo: *}
assign c-lbl-adic = return-value.
{utp/ut-liter.i Nr_da_L.I.: *}
assign c-lbl-num-li = return-value.
{utp/ut-liter.i Documento_Vinculado *}
assign c-lbl-docto-vincul = return-value.
{utp/ut-liter.i Nr. *}
assign c-lbl-num-docto-vincul = return-value.

{utp/ut-liter.i Exportador: *}
assign c-lbl-exportador = return-value.
{utp/ut-liter.i Nome: *}
assign c-lbl-nome-export = return-value.
{utp/ut-liter.i Pa¡s: *}
assign c-lbl-pais-export = return-value.

{utp/ut-liter.i Fabricante/Produtor *}
assign c-lbl-fabri-prod = return-value.
{utp/ut-liter.i Nome: *}
assign c-lbl-nome-fabrican = return-value.
{utp/ut-liter.i Pa¡s: *}
assign c-lbl-pais-fabrican = return-value.

{utp/ut-liter.i Classifica‡Æo_Tarif ria: *}
assign c-lbl-class-tribut = return-value.
{utp/ut-liter.i NCM *}
assign c-lbl-ncm = return-value.
{utp/ut-liter.i NBM *}
assign c-lbl-nbm = return-value.

{utp/ut-liter.i Condi‡Æo_de_Venda *}
assign c-lbl-cond-venda = return-value.
{utp/ut-liter.i INCOTERM: *}
assign c-lbl-incoterm = return-value.
{utp/ut-liter.i VMCV: *}
assign c-lbl-vmcv = return-value.

{utp/ut-liter.i Peso_L¡quido_da_Adi‡Æo: *}
assign c-lbl-peso-liq-adic = return-value.

{utp/ut-liter.i Descri‡Æo_Detalhada_da_Mercadoria: *}
assign c-lbl-desc-det-merc = return-value.
{utp/ut-liter.i Qtde: *}
assign c-lbl-qtde = return-value.
{utp/ut-liter.i VUCV: *}
assign c-lbl-vucv = return-value.

{utp/ut-liter.i Valor_a_Recolher: *}
assign c-lbl-valor-recolher = return-value.
{utp/ut-liter.i Al¡quota_Unit ria: *}
assign c-lbl-aliq-unit = return-value.
{utp/ut-liter.i Regime_de_Tributa‡Æo: *}
assign c-lbl-reg-tribut = return-value.
{utp/ut-liter.i Valor_Devido: *}
assign c-lbl-valor-devido = return-value.
{utp/ut-liter.i Al¡quota_Espec¡fica: *}
assign c-lbl-aliq-especif = return-value.
{utp/ut-liter.i Al¡quota_Ad_Valorem: *}
assign c-lbl-aliq-ad-valorem = return-value.

{utp/ut-liter.i Imposto_de_Importa‡Æo: *}
assign c-lbl-imp-imp = return-value.
{utp/ut-liter.i Al¡quota_Ad_Valorem_(TEC): *}
assign c-lbl-aliq-adval-tec = return-value.

{utp/ut-liter.i Imposto_sobre_Produtos_Industrializados *}
ASSIGN c-lbl-imp-prod-ind = RETURN-VALUE.
{utp/ut-liter.i Al¡quota_Ad_Valorem_(TIPI): *}
assign c-lbl-aliq-adval-tipi = return-value.

{utp/ut-liter.i Dados_Gerais_Pis *}
ASSIGN c-lbl-dados-pis = RETURN-VALUE.
{utp/ut-liter.i Dados_Gerais_Cofins *}
ASSIGN c-lbl-dados-cofins = RETURN-VALUE.
{utp/ut-liter.i Base_de_C lculo: *}
assign c-lbl-base-calc = return-value.
{utp/ut-liter.i Perc._Redu‡Æo_da_Base_de_C lculo: *}
assign c-lbl-perc-reduc = return-value.
{utp/ut-liter.i Al¡quota_ICMS: *}
ASSIGN c-lbl-aliq-icms = RETURN-VALUE.

{utp/ut-liter.i Pis/Pasep *}
ASSIGN c-lbl-pis-pasep = RETURN-VALUE.

{utp/ut-liter.i Cofins *}
ASSIGN c-lbl-cofins2 = RETURN-VALUE.

/* Fim Tradu‡Æo Labels */


RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
{utp/ut-liter.i Exportando... *}       
RUN pi-inicializar IN h-acomp (INPUT return-value).

FIND FIRST tt-param NO-LOCK NO-ERROR.
IF  NOT AVAIL tt-param THEN DO:
    RUN pi-finalizar IN h-acomp.
    RETURN "NOK":U.
END.

/* altera‡Æo da extensÆo do arquivo */
assign tt-param.arquivo = replace(tt-param.arquivo, ".tmp", ".xml").

/* altera parƒmetro da sessÆo para impressÆo de dados decimais */
assign cNumericFormat = session:numeric-format
       session:numeric-format = "AMERICAN".

/* abertura do arquivo para impressÆo do XML */
output to value(tt-param.arquivo) convert target "utf-8":U.


/*RUN pi-dados-solicit-devol.
RUN pi-geraRelat. */
RUN pi-gera-relatorio.
output close. 

/*=================================
  ConversÆo do arquivo XML para XLS
  =================================*/

run piConvertXMLToXLS.

/* retorna os parƒmetros da sessÆo */
assign session:numeric-format = cNumericFormat.

RUN pi-finalizar IN h-acomp.

RETURN "OK":U.

PROCEDURE pi-gera-relatorio:
    assign iColumns = 8.
    
    run OpenWorkBook.
    run OpenExcelWorkBook.
    run CloseExcelWorkBook .
    run OpenStyles.
    run CloseStyles.
    run OpenWorkSheet(input "IM0430").
    run OpenTable(input iColumns).

    /* defini‡Æo da largura das colunas */
    run setColumnWidth(input "65.00").
    run setColumnWidth(input "95.00"). 
    run setColumnWidth(input "80.00").
    run setColumnWidth(input "45.00").
    run setColumnWidth(input "65.00").
    run setColumnWidth(input "55.00").
    run setColumnWidth(INPUT "17.00"). 
    run setColumnWidth(input "12.00").
    

    
    FOR EACH decla-import NO-LOCK
                WHERE decla-import.num-di-ems       >=  tt-param.c-num-di-ems-ini
                AND   decla-import.num-di-ems       <=  tt-param.c-num-di-ems-fim
                AND   decla-import.cod-di-siscomex  >=  tt-param.c-num-di-siscomex-ini
                AND   decla-import.cod-di-siscomex  <=  tt-param.c-num-di-siscomex-fim
                AND 
                (     (decla-import.dat-di           >=  tt-param.c-data-di-ini
                AND   decla-import.dat-di           <=  tt-param.c-data-di-fim
                AND   decla-import.dat-di           <>  ? )
                      OR    decla-import.dat-di = ? )
                AND   decla-import.cod-estab        >=  tt-param.c-estab-ini
                AND   decla-import.cod-estab        <=  tt-param.c-estab-fim
                AND   decla-import.cdd-siscomex-dts  = 0:

        /* zerar as variaveis */
        ASSIGN  c-importador-cnpj           = ""
                c-importador-nome           = ""
                c-adquire-cnpj              = ""
                c-adquire-nome              = ""
                c-repres-legal-nome         = ""
                c-repres-legal-cpf          = ""
                c-di-siscomex               = ""
                d-data-reg                  = ?
                i-di-ems                    = 0
                c-desc-uni-rf               = ""
                c-tip-decla                 = ""
                c-modal-desp                = ""
                i-qtd-adic                  = 0
                c-tipo-processo-vinc        = ""
                c-identifica-proces         = ""
                c-frete-moeda               = ""
                c-seguro-moeda              = ""
                c-vmle-moeda                = ""
                c-vmld-moeda                = ""
                c-moeda-vmcv                = ""
                c-tipo-manifesto            = ""
                c-numero-manifesto          = ""
                c-recinto-aduan             = ""
                d-peso-bruto                = 0
                d-peso-liquido              = 0
                d-frete-valor               = 0
                d-seguro-valor              = 0
                d-vmle-valor                = 0
                d-vmld-valor                = 0
                d-ii-suspenso               = 0
                d-ii-recolher               = 0
                d-ipi-suspenso              = 0
                d-ipi-recolher              = 0
                d-pis-recolher              = 0
                d-cofins-recolher           = 0
                d-cbs-recolher              = 0
                d-ibsuf-recolher            = 0
                d-ibsmun-recolher           = 0
                d-ibsuf-susp                = 0
                d-ibsmun-susp               = 0
                d-cbs-susp                  = 0
                c-embal                     = ""
                c-qtd-embal                 = ""
                i-num-adic                  = 0
                c-cod-licenc-import         = ""
                c-tip-docto-vincul          = ""
                c-cod-num-docto             = ""
                c-classif-fisc              = ""
                c-desc-classif-fisc         = ""
                c-cod-nbm                   = ""
                c-cod-incoterm              = ""
                c-desc-incoterm             = ""
                d-valor-vmcv                = 0
                d-peso-liq-adic             = 0
                c-moeda-vucv                = ""
                c-especif-itens             = ""
                d-itens-qtd-adic            = 0
                c-tab-unid-desc             = ""
                d-valor-vucv                = 0
                c-idi-tributac-impto-import = ""
                d-val-aliq-ii               = 0
                d-val-unit-ii               = 0
                d-val-ii-db-cr              = 0
                c-idi-tributac-ipi          = ""
                d-val-aliq-ipi              = 0
                d-val-unit-ipi              = 0
                d-val-ipi-db-cr             = 0
                d-val-base-pis              = 0
                d-perc-reduc-pis            = 0
                c-idi-tribut-pis            = ""
                d-val-aliq-icms             = 0
                d-val-base-cofins           = 0
                d-perc-reduc-cofins         = 0
                c-idi-tribut-cofins         = ""
                d-val-aliq-pis              = 0
                d-val-unit-pis              = 0
                d-val-devido-pis            = 0
                d-val-pis-db-cr             = 0
                d-val-aliq-cofins           = 0
                d-val-unit-cofins           = 0
                d-val-devido-cofins         = 0
                d-val-cofins-db-cr          = 0
                .
        /* fim - zerar as variaveis */
         
         FIND FIRST unid-rf 
                WHERE unid-rf.cdn-unid-recta-feder = decla-import.cdn-urf-despch NO-LOCK NO-ERROR.

         FIND FIRST estabelec
                        WHERE estabelec.cod-estabel = decla-import.cod-estab NO-LOCK NO-ERROR.
             ASSIGN c-importador-cnpj = string(estabelec.cgc,c-fmt-cnpj)
                    c-importador-nome = estabelec.nome.

         IF decla-import.idi-caract-operac = 1 THEN DO:
             ASSIGN c-adquire-cnpj    = string(estabelec.cgc,c-fmt-cnpj)
                    c-adquire-nome    = estabelec.nome.
         END.
         ELSE DO:
             FIND FIRST emitente
                        WHERE emitente.cod-emitente = decla-import.cdn-consign NO-LOCK NO-ERROR.
             ASSIGN c-adquire-cnpj    = emitente.cgc        WHEN AVAIL emitente
                    c-adquire-nome    = emitente.nome-abrev WHEN AVAIL emitente.
                    
         END.
         
         FIND FIRST param-imp 
                    WHERE param-imp.cod-estabel = decla-import.cod-estab NO-LOCK NO-ERROR.
         IF AVAIL param-imp THEN DO:
             ASSIGN  c-repres-legal-cpf          = string(param-imp.cod-cpf-repres,c-fmt-cpf).
             &if '{&bf_mat_versao_ems}' >= '2.07' &then
                 ASSIGN c-repres-legal-nome = param-imp.des-respons-legal.
             &else
                 ASSIGN c-repres-legal-nome = SUBSTRING(param-imp.char-1,106,60).
             &endif
         END.         

        /*carregar as variaveis */
        ASSIGN c-di-siscomex               = string(decla-import.cod-di-siscomex,c-fmt-di-siscomex)
               d-data-reg                  = decla-import.dat-di
               i-di-ems                    = decla-import.num-di-ems
                                          
               c-desc-uni-rf               = unid-rf.des-descr WHEN AVAIL unid-rf
               c-tip-decla                 = {cxinc/i02cx383.i 04 decla-import.idi-tip-decla-import}
               c-modal-desp                = {cxinc/i04cx383.i 04 decla-import.idi-modalid-despch}
               i-qtd-adic                  = decla-import.num-adicoes.
        
        /* rotina para quebrar a pagina a cada nova DI */
        IF NOT l-first-decla-import THEN DO:
            fnSkipSheet().
        END.
        ASSIGN l-first-decla-import = NO.

        ASSIGN i-paginas = iCountPage + 1.

        /* cabecalho */
        ASSIGN d-data-reg = DATE(STRING(d-data-reg,"99/99/9999")).
        run OpenLine.
            run PrintDataString(input c-lbl-di-siscomex                , "Default").
            run PrintDataString(input c-di-siscomex                    , "Default").
            run PrintDataString(input c-lbl-data-reg                   , "Default").
            run PrintDataString(input d-data-reg                       , "Default").
            run PrintDataString(input c-lbl-di-ems                     , "Default").
            run PrintDataString(input i-di-ems                         , "Default").
            run MergeColumns   (input 1, "" /*i-paginas*/              , "pagina"). /**/
        run CloseLine.
    
        run OpenLine.
            run MergeColumns (input 7, ""                              , "Default").
        run CloseLine.
        RUN OpenLine.
            RUN MergeColumns(INPUT 7, "SECRETARIA DA RECEITA FEDERAL DO BRASIL - RFB","n01").
        RUN CloseLine.
        RUN OpenLine.
            RUN MergeColumns(INPUT 7, c-desc-uni-rf,"subtitulo").
        RUN CloseLine.
        RUN OpenLine.
            RUN MergeColumns(INPUT 7, "EXTRATO DA DECLARA€ÇO DE IMPORTA€ÇO","n01").
        RUN CloseLine.
        RUN OpenLine.
            RUN MergeColumns(INPUT 7, c-tip-decla,"subtitulo").
        RUN CloseLine.
    
        run OpenLine.
            run MergeColumns (input 7, ""                           , "Default").
        run CloseLine.
    
        RUN OpenLine.
            RUN MergeColumns(INPUT 1, c-lbl-modal-desp              , "Default").
            ASSIGN iColCount = iColCount + 1.
            RUN MergeColumns(INPUT 5, c-modal-desp                  , "Default").
        RUN CloseLine.
        run OpenLine.
            run MergeColumns(input 1, c-lbl-qtd-adic                , "Default").
            assign iColCount = iColCount + 1.
            run MergeColumns(input 5, i-qtd-adic                    , "Default").
        run CloseLine.
        run OpenLine.
            run MergeColumns (input 7, ""                           , "Default").
        run CloseLine.
        run OpenLine.
            run MergeColumns(INPUT 1, c-lbl-importador              , "titulo").
            ASSIGN iColCount = iColCount + 1.
            run MergeColumns(input 5, ""                            , "Default").
        run CloseLine.
        run OpenLine.
            run PrintDataString(input c-lbl-importador-cnpj         , "Default").
            run PrintDataString(input c-importador-cnpj             , "Default").
            run MergeColumns   (input 5, c-importador-nome          , "Default").
        run CloseLine.
        run OpenLine.
            run MergeColumns (input 7, ""                           , "Default").
        run CloseLine.
        run OpenLine.
            run MergeColumns(INPUT 1, c-lbl-adquirente              , "titulo").
            ASSIGN iColCount = iColCount + 1.
            run MergeColumns(input 5, ""                            , "Default").
        run CloseLine.
        run OpenLine.
            run PrintDataString(input c-lbl-adquirente-cnpj         , "Default").
            run PrintDataString(input c-adquire-cnpj                , "Default").
            run MergeColumns   (input 5, c-adquire-nome             , "Default").
        run CloseLine.
        run OpenLine.
            run MergeColumns (input 7, ""                           , "Default").
        run CloseLine.
        run OpenLine.
            run MergeColumns(input 1, c-lbl-repres-legal            , "titulo").
            ASSIGN iColCount = iColCount + 1.
            run MergeColumns(input 5, ""                            , "Default").
        run CloseLine.
        run OpenLine.
            run PrintDataString(input c-lbl-repres-legal-cpf        , "Default").
            run PrintDataString(input c-repres-legal-cpf            , "Default").
            run MergeColumns   (INPUT 5, c-repres-legal-nome        , "Default").
        run CloseLine.

        /* processos vinculados */
        IF CAN-FIND(FIRST decla-import-proc WHERE decla-import-proc.num-di-ems       = decla-import.num-di-ems
                                            AND   decla-import-proc.cdd-siscomex-dts = decla-import.cdd-siscomex-dts NO-LOCK ) THEN DO:
            run OpenLine.
                run MergeColumns (input 7, ""                           , "Default").
            run CloseLine.
            run OpenLine.
                run MergeColumns(input 1,c-lbl-processo                , "titulo").
                ASSIGN iColCount = iColCount + 1.
                run MergeColumns(input 5, ""                            , "Default").
            run CloseLine.
            FOR EACH decla-import-proc WHERE decla-import-proc.num-di-ems       = decla-import.num-di-ems
                                       AND   decla-import-proc.cdd-siscomex-dts = decla-import.cdd-siscomex-dts
                                       NO-LOCK:
                 ASSIGN c-tipo-processo-vinc        = {cxinc/i01cx396.i 04 decla-import-proc.idi-tip-proces-vincul}
                        c-identifica-proces         = decla-import-proc.cod-proces-vincul.
                run OpenLine.
                    run MergeColumns   (input 1,c-tipo-processo-vinc          , "Default").
                    ASSIGN iColCount = iColCount + 1.
                    run PrintDataString(input c-lbl-ident                     , "Default").
                    run MergeColumns   (input 4, c-identifica-proces          , "Default").
                run CloseLine.
            END.
        END.
        /* fim - processos vinculados */

        FIND FIRST decla-import-adic WHERE decla-import-adic.num-di-ems       = decla-import.num-di-ems
                                     AND   decla-import-adic.cdd-siscomex-dts = decla-import.cdd-siscomex-dts
                                     NO-LOCK NO-ERROR.
        IF AVAIL decla-import-adic THEN DO:

            IF decla-import-adic.cdn-moeda = 0 THEN 
                ASSIGN d-vmle-valor  = decla-import.val-vmle
                       d-vmld-valor  = decla-import.val-vmld.
            ELSE DO:
                IF decla-import-adic.cdn-moeda <> param-imp.int-2 THEN
                    ASSIGN d-vmle-valor   = decla-import.val-vmle-me[1]
                           d-vmld-valor   = decla-import.val-vmld-me[1].
                ELSE
                    ASSIGN d-vmle-valor   = decla-import.val-vmle-me[2]
                           d-vmld-valor   = decla-import.val-vmld-me[2].
            END.

            IF decla-import-adic.cdn-moed-frete = 0 THEN
                ASSIGN d-frete-valor = decla-import.val-frete.
            ELSE DO:
                IF decla-import-adic.cdn-moed-frete <> param-imp.int-2  THEN
                    ASSIGN d-frete-valor = decla-import.val-frete-me[1].
                ELSE
                    ASSIGN d-frete-valor = decla-import.val-frete-me[2].
            END.

            IF decla-import-adic.cdn-moed-seguro = 0 THEN
                ASSIGN d-seguro-valor = decla-import.val-seguro.
            ELSE DO:
                IF decla-import-adic.cdn-moed-seguro <> param-imp.int-2 THEN
                    ASSIGN d-seguro-valor = decla-import.val-seguro-me[1].
                ELSE
                    ASSIGN d-seguro-valor = decla-import.val-seguro-me[2].
            END.


            FOR FIRST moeda
                WHERE moeda.mo-codigo = decla-import-adic.cdn-moeda NO-LOCK:
                ASSIGN c-vmle-moeda    = moeda.descricao
                       c-vmld-moeda    = moeda.descricao
                       c-moeda-vmcv    = moeda.descricao.
            END.

            IF decla-import-adic.cdn-moed-frete <> decla-import-adic.cdn-moeda THEN 
                FOR FIRST moeda
                    WHERE moeda.mo-codigo = decla-import-adic.cdn-moed-frete NO-LOCK:
                    ASSIGN c-frete-moeda = moeda.descricao.
                END.
            ELSE
                ASSIGN c-frete-moeda = moeda.descricao WHEN AVAIL moeda.

            IF decla-import-adic.cdn-moed-seguro <> decla-import-adic.cdn-moed-frete THEN
                FOR FIRST moeda
                    WHERE moeda.mo-codigo = decla-import-adic.cdn-moed-seguro NO-LOCK:
                    ASSIGN c-seguro-moeda  = moeda.descricao.
                END.
            ELSE
                ASSIGN c-seguro-moeda  = moeda.descricao WHEN AVAIL moeda.

        END.

        ASSIGN c-tipo-manifesto            = {cxinc/i06cx383.i 04 decla-import.idi-docto-carg}
               c-numero-manifesto          = decla-import.cod-identif
               c-recinto-aduan             = string(decla-import.cdn-recinto-alfand)
               d-peso-bruto                = decla-import.val-peso-brut-tot-di
               d-peso-liquido              = decla-import.val-peso-liq-di
               d-ii-suspenso               = decla-import.val-ii-nao-tribut 
               d-ii-recolher               = decla-import.val-ii-db-cr
               d-ipi-suspenso              = decla-import.val-ipi-nao-tributad 
               d-ipi-recolher              = decla-import.val-ipi-db-cr
               d-pis-recolher              = decla-import.val-pis-db-cr
               d-cofins-recolher           = decla-import.val-cofins-db-cr.
        
        IF l-nt2024002 THEN DO:
            FOR EACH decla-import-trib NO-LOCK
               WHERE decla-import-trib.num-di-ems       = decla-import.num-di-ems
                 AND decla-import-trib.num-seq-retif    = decla-import.num-seq-retif
                 AND decla-import-trib.cdd-siscomex-dts = decla-import.cdd-siscomex-dts:
                
                CASE decla-import-trib.nom-trib:
                    WHEN "IBSUF":U THEN DO:
                        CASE decla-import-trib.cod-campo:                            
                            WHEN "VALOR":U then ASSIGN d-ibsuf-recolher = DEC(replace(decla-import-trib.cod-conteudo,',','.')).
                            WHEN "SUSPENSO":U THEN assign d-ibsuf-susp = DECIMAL(replace(decla-import-trib.cod-conteudo,',','.')).
                        END CASE.
                    END.
                    WHEN "IBSMUN":U THEN DO:
                        CASE decla-import-trib.cod-campo:                            
                            WHEN "VALOR":U THEN ASSIGN d-ibsmun-recolher = DEC(REPLACE(decla-import-trib.cod-conteudo,',','.')).
                            WHEN "SUSPENSO":U THEN ASSIGN d-ibsmun-susp = DEC(REPLACE(decla-import-trib.cod-conteudo,',','.')).
                        END CASE.
                    END.
                    WHEN "CBS":U THEN DO:
                        CASE decla-import-trib.cod-campo:                            
                            WHEN "VALOR":U then ASSIGN d-cbs-recolher = decimal(replace(decla-import-trib.cod-conteudo,',','.')).
                            WHEN "SUSPENSO":U THEN assign d-cbs-susp = DECIMAL(replace(decla-import-trib.cod-conteudo,',','.')).
                        END CASE.
                    END.
                END CASE.
            END.
            /* Soma o valor da tributa‡Æo regular das adi‡äes para listar no cabe‡alho */
            ASSIGN d-val-ibsuf-reg  = 0
                   d-val-ibsmun-reg = 0
                   d-val-cbs-reg    = 0.
            FOR EACH decla-import-adic-trib NO-LOCK
               WHERE decla-import-adic-trib.num-di-ems       = decla-import.num-di-ems
                 AND decla-import-adic-trib.cdd-siscomex-dts = decla-import.cdd-siscomex-dts:
                CASE decla-import-adic-trib.nom-trib:
                    WHEN "IBSUF":U THEN
                        IF decla-import-adic-trib.cod-campo = "VALOR-REG":U THEN 
                            ASSIGN d-val-ibsuf-reg = d-val-ibsuf-reg + DEC(REPLACE(decla-import-adic-trib.cod-conteudo,',','.')).
                    WHEN "IBSMUN":U THEN
                        IF decla-import-adic-trib.cod-campo = "VALOR-REG":U THEN 
                            ASSIGN d-val-ibsmun-reg = d-val-ibsmun-reg + DEC(REPLACE(decla-import-adic-trib.cod-conteudo,',','.')).
                    WHEN "CBS":U THEN
                        IF decla-import-adic-trib.cod-campo = "VALOR-REG":U THEN 
                            ASSIGN d-val-cbs-reg = d-val-cbs-reg + DEC(REPLACE(decla-import-adic-trib.cod-conteudo,',','.')).
                END CASE.
            END.
        END.

        run OpenLine.
            run MergeColumns (input 7, ""                           , "Default").
        run CloseLine.
        run OpenLine.
            run MergeColumns(input 1,c-lbl-carga                   , "titulo").
            ASSIGN iColCount = iColCount + 1.
            run MergeColumns(input 5, ""                            , "Default").
        run CloseLine.
        run OpenLine.
            run MergeColumns(input 1,c-lbl-tipo-manifesto          , "Default").
            ASSIGN iColCount = iColCount + 1.
            run MergeColumns(input 5, c-tipo-manifesto             , "Default").
        run CloseLine.
        run OpenLine.
            run MergeColumns(input 1,c-lbl-numero-manifesto        , "Default").
            ASSIGN iColCount = iColCount + 1.
            run MergeColumns(input 5, c-numero-manifesto           , "Default").
        run CloseLine.
        run OpenLine.
            run MergeColumns(input 1,c-lbl-recinto-aduan           , "Default").
            ASSIGN iColCount = iColCount + 1.
            run MergeColumns(input 5, c-recinto-aduan              , "Default").
        run CloseLine.


        /* embalagem */
        ASSIGN l-first-decla-import-embal = YES.
        FOR EACH decla-import-embal WHERE decla-import-embal.num-di-ems       = decla-import.num-di-ems 
                                    AND   decla-import-embal.cdd-siscomex-dts = decla-import.cdd-siscomex-dts
                                    NO-LOCK:
             FIND FIRST embalag WHERE embalag.sigla-emb = decla-import-embal.cod-sig-embal 
                                NO-LOCK NO-ERROR.
             
             ASSIGN c-embal                     = embalag.descricao
                    c-qtd-embal                 = string(decla-import-embal.qtd-vol-embal) WHEN AVAIL decla-import-embal.

             IF l-first-decla-import-embal THEN DO:
                 run OpenLine.
                    run MergeColumns(input 1,c-lbl-embal                   , "Default").
                    ASSIGN iColCount = iColCount + 1.
                    RUN MergeColumns(INPUT 2,c-embal                       , "Default").
                    ASSIGN iColCount = iColCount + 1.
                    RUN PrintDataString(INPUT c-lbl-qtd-embal              , "Default").
                    run MergeColumns(input 1, c-qtd-embal                  , "Default").
                 run CloseLine.
                 ASSIGN l-first-decla-import-embal = NO.
             END.
             ELSE DO:
                 run OpenLine.
                    run MergeColumns(input 1,""                            , "titulo").
                    ASSIGN iColCount = iColCount + 1.
                    RUN MergeColumns(INPUT 2,c-embal                       , "Default").
                    ASSIGN iColCount = iColCount + 1.
                    RUN PrintDataString(INPUT c-lbl-qtd-embal              , "Default").
                    run MergeColumns(input 1, c-qtd-embal                  , "Default").
                 run CloseLine.
             END.
        END.
        /* fim - embalagem */
        
        /* peso di */
        RUN OpenLine.
            RUN MergeColumns(INPUT 1, c-lbl-peso-bruto             , "Default").
            ASSIGN iColCount = iColCount + 1.
            RUN MergeColumnsNumber(INPUT 1, d-peso-bruto           , "numeroFormato4").
            ASSIGN iColCount = iColCount + 1.
            RUN PrintDataString(INPUT c-lbl-peso-liquido           , "Default").
            RUN MergeColumnsNumber(INPUT 2, d-peso-liquido         , "numeroFormato4").
        RUN CloseLine.
        /* fim - peso di */
    
        /* valores */
        run OpenLine.
            run MergeColumns (input 7, ""                           , "Default").
        run CloseLine.
        RUN OpenLine.
            RUN MergeColumns(INPUT 1, c-lbl-valores                , "titulo").
            ASSIGN iColCount = iColCount + 1.
            RUN MergeColumns(INPUT 2, c-lbl-moeda                  , "titulo").
            ASSIGN iColCount = iColCount + 1.
            RUN MergeColumns(INPUT 2, c-lbl-valor                  , "titulo").
        RUN CloseLine.
        RUN OpenLine.
            RUN MergeColumns(INPUT 1, c-lbl-frete                  , "Default").
            ASSIGN iColCount = iColCount + 1.
            RUN MergeColumns(INPUT 2, c-frete-moeda                , "Default").
            ASSIGN iColCount = iColCount + 1.
            RUN MergeColumnsNumber(INPUT 2, d-frete-valor         , "numeroFormato2").
        RUN CloseLine.
        RUN OpenLine.
            RUN MergeColumns(INPUT 1, c-lbl-seguro                 , "Default").
            ASSIGN iColCount = iColCount + 1.
            RUN MergeColumns(INPUT 2, c-seguro-moeda               , "Default").
            ASSIGN iColCount = iColCount + 1.
            RUN MergeColumnsNumber(INPUT 2, d-seguro-valor         , "numeroFormato2").
        RUN CloseLine.
        RUN OpenLine.
            RUN MergeColumns(INPUT 1, c-lbl-vmle                  , "Default").
            ASSIGN iColCount = iColCount + 1.
            RUN MergeColumns(INPUT 2, c-vmle-moeda                , "Default").
            ASSIGN iColCount = iColCount + 1.
            RUN MergeColumnsNumber(INPUT 2, d-vmle-valor          , "numeroFormato2").
        RUN CloseLine.
        RUN OpenLine.
            RUN MergeColumns(INPUT 1, c-lbl-vmld                  , "Default").
            ASSIGN iColCount = iColCount + 1.
            RUN MergeColumns(INPUT 2, c-vmld-moeda                , "Default").
            ASSIGN iColCount = iColCount + 1.
            RUN MergeColumnsNumber(INPUT 2, d-vmld-valor          , "numeroFormato2").
        RUN CloseLine.
        /* fim - valores */
    
        /* Tributos */
        run OpenLine.
            run MergeColumns (input 7, ""                          , "Default").
        run CloseLine.
        RUN OpenLine.
            RUN MergeColumns(INPUT 1, c-lbl-tributos               , "titulo").
            ASSIGN iColCount = iColCount + 1.
            RUN MergeColumns(INPUT 2, c-lbl-suspenso               , "titulo").
            ASSIGN iColCount = iColCount + 1.
            RUN MergeColumns(INPUT 2, c-lbl-recolher               , "titulo").
        RUN CloseLine.
        RUN OpenLine.
            RUN MergeColumns(INPUT 1, c-lbl-ii                     , "Default").
            ASSIGN iColCount = iColCount + 1.
            RUN MergeColumnsNumber(INPUT 2, d-ii-suspenso          , "numeroFormato2").
            ASSIGN iColCount = iColCount + 1.
            RUN MergeColumnsNumber(INPUT 2, d-ii-recolher          , "numeroFormato2").
        RUN CloseLine.
        RUN OpenLine.
            RUN MergeColumns(INPUT 1, c-lbl-ipi                    , "Default").
            ASSIGN iColCount = iColCount + 1.
            RUN MergeColumnsNumber(INPUT 2, d-ipi-suspenso         , "numeroFormato2").
            ASSIGN iColCount = iColCount + 1.
            RUN MergeColumnsNumber(INPUT 2, d-ipi-recolher         , "numeroFormato2").
        RUN CloseLine.
        RUN OpenLine.
            RUN MergeColumns(INPUT 4, c-lbl-pis                    , "Default").
            ASSIGN iColCount = iColCount + 1.
            RUN MergeColumnsNumber(INPUT 2, d-pis-recolher         , "numeroFormato2").
        RUN CloseLine.
        RUN OpenLine.
            RUN MergeColumns(INPUT 4, c-lbl-cofins                 , "Default").
            ASSIGN iColCount = iColCount + 1.
            RUN MergeColumnsNumber(INPUT 2, d-cofins-recolher      , "numeroFormato2").
        RUN CloseLine.        
        /* fim - tributos */
        
        IF l-nt2024002 THEN DO:
            /* Tributos RT */
            run OpenLine.
                run MergeColumns (input 7, ""                          , "Default").
            run CloseLine.
            RUN OpenLine.
                RUN MergeColumns(INPUT 1, c-lbl-tributos-rt            , "titulo").
                ASSIGN iColCount = iColCount + 1.
                RUN MergeColumns(INPUT 2, c-lbl-suspenso               , "titulo").
                ASSIGN iColCount = iColCount + 1.
                RUN MergeColumns(INPUT 2, c-lbl-recolher               , "titulo").
            RUN CloseLine.
            RUN OpenLine.
                RUN MergeColumns(input 1, c-lbl-cbs                    , "Default").
                ASSIGN iColCount = iColCount + 1.
                RUN MergeColumnsNumber(INPUT 2, d-cbs-susp             , "numeroFormato2").
                ASSIGN iColCount = iColCount + 1.
                RUN MergeColumnsNumber(INPUT 2, d-cbs-recolher         , "numeroFormato2").
            RUN CloseLine.
            RUN OpenLine.
                RUN MergeColumns(input 1, c-lbl-ibsuf                  , "Default").                
                ASSIGN iColCount = iColCount + 1.
                RUN MergeColumnsNumber(INPUT 2, d-ibsuf-susp           , "numeroFormato2").
                ASSIGN iColCount = iColCount + 1.
                RUN MergeColumnsNumber(INPUT 2, d-ibsuf-recolher       , "numeroFormato2").
            RUN CloseLine.
            RUN OpenLine.
                RUN MergeColumns(input 1, c-lbl-ibsmun                 , "Default").                
                ASSIGN iColCount = iColCount + 1.
                RUN MergeColumnsNumber(INPUT 2, d-ibsmun-susp          , "numeroFormato2").
                ASSIGN iColCount = iColCount + 1.
                RUN MergeColumnsNumber(INPUT 2, d-ibsmun-recolher      , "numeroFormato2").
            RUN CloseLine.
            /* fim - tributos RT */

            /* Tributos RT Regular */
            run OpenLine.
                run MergeColumns (input 7, ""                          , "Default").
            run CloseLine.
            RUN OpenLine.
                RUN MergeColumns(INPUT 1, c-lbl-tributos-rt-reg        , "titulo").
                ASSIGN iColCount = iColCount + 4.
                RUN MergeColumns(INPUT 2, c-lbl-valor                  , "titulo").
            RUN CloseLine.
            RUN OpenLine.
                RUN MergeColumns(input 1, c-lbl-cbs                    , "Default").
                ASSIGN iColCount = iColCount + 4.
                RUN MergeColumnsNumber(INPUT 2, d-val-cbs-reg          , "numeroFormato2").
            RUN CloseLine.
            RUN OpenLine.
                RUN MergeColumns(input 1, c-lbl-ibsuf                  , "Default").                
                ASSIGN iColCount = iColCount + 4.
                RUN MergeColumnsNumber(INPUT 2, d-val-ibsuf-reg        , "numeroFormato2").
            RUN CloseLine.
            RUN OpenLine.
                RUN MergeColumns(input 1, c-lbl-ibsmun                 , "Default").                
                ASSIGN iColCount = iColCount + 4.
                RUN MergeColumnsNumber(INPUT 2, d-val-ibsmun-reg       , "numeroFormato2").
            RUN CloseLine.
            /* fim - tributos RT Regular */
        end.    
    
        run OpenLine.
            run MergeColumns (input 7, ""                           , "Default").
        run CloseLine.
        RUN OpenLine.
            RUN PrintDataString(INPUT c-lbl-data                    ,"Default").
            RUN PrintDataString(INPUT c-lbl-mascara                 ,"Default").
            RUN MergeColumns   (INPUT 4, ""                         ,"Default").
            ASSIGN iColCount = iColCount + 1.
            RUN PrintDataString(INPUT ""                            ,"Default").
        RUN CloseLine.
    
        run OpenLine.
            RUN MergeColumns(INPUT 1, ""                            , "Default").
            ASSIGN iColCount = iColCount + 1.
            RUN MergeColumns (input 4, c-lbl-assinatura             , "assinatura").
            ASSIGN iColCount = iColCount + 1.
            RUN PrintDataString(INPUT ""                            , "Default").
        run CloseLine.
                                           
        /* dados complementares */
        run OpenLine.
            run MergeColumns(input 7, ""                            , "Default").
        run CloseLine.
        run OpenLine.
            run MergeColumns(input 7, ""                            , "Default").
        run CloseLine.
        RUN OpenLine.
            RUN MergeColumns(INPUT 7, c-lbl-info-comp               , "titulo").
        RUN CloseLine.
        run OpenLine.
            run MergeColumns(input 7, ""                            , "Default").
        run CloseLine.
        ASSIGN c-info-comp = TRIM(decla-import.cod-inf-compltar).
        RUN pi-print-editor(c-info-comp, 70).
        FOR EACH tt-editor:
            RUN OpenLine.
                RUN MergeColumns(INPUT 7, tt-editor.conteudo        , "Default").
            RUN CloseLine.
        END.
        /* fim - dados complementares */

        
        /* adicoes */
        FOR EACH decla-import-adic WHERE decla-import-adic.num-di-ems       = decla-import.num-di-ems 
                                   AND   decla-import-adic.cdd-siscomex-dts = decla-import.cdd-siscomex-dts
                                   NO-LOCK:            

            RUN OpenLine.
                RUN MergeColumns(INPUT 7,""                             , "divisoria").
            RUN CloseLine.

           
            ASSIGN                                   
                   i-num-adic                  = decla-import-adic.num-adic 
                   c-cod-licenc-import         = decla-import-adic.cod-licenc-import.
            
             RUN OpenLine.
                RUN PrintDataString(INPUT c-lbl-adic                    , "Default").
                RUN PrintDataString(INPUT c-di-siscomex                 , "Default").
                RUN MergeColumns   (INPUT 5, i-num-adic                 , "Default").
            RUN CloseLine.
        
            RUN OpenLine.
                RUN PrintDataString(INPUT c-lbl-num-li                  , "Default").
                RUN MergeColumns   (INPUT 6, c-cod-licenc-import        , "Default").
            RUN CloseLine.

            /* documentos vinculados */
            IF CAN-FIND(FIRST decla-import-adic-docto
                            WHERE decla-import-adic-docto.num-di-ems       = decla-import-adic.num-di-ems
                            AND   decla-import-adic-docto.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts
                            AND   decla-import-adic-docto.num-adic         = decla-import-adic.num-adic) THEN DO:
                RUN OpenLine.
                    RUN MergeColumns(INPUT 7, ""                            , "Default").
                RUN CloseLine.
                RUN OpenLine.
                    RUN MergeColumns(INPUT 7, c-lbl-docto-vincul            , "titulo").
                RUN CloseLine.
                FOR EACH decla-import-adic-docto WHERE decla-import-adic-docto.num-di-ems       = decla-import-adic.num-di-ems
                                                 AND   decla-import-adic-docto.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts
                                                 AND   decla-import-adic-docto.num-adic         = decla-import-adic.num-adic 
                                                 NO-LOCK:
                    ASSIGN
                           c-tip-docto-vincul          = {cxinc/i01cx394.i 04 decla-import-adic-docto.idi-tip-docto-vincul}
                           c-cod-num-docto             = decla-import-adic-docto.cod-num-docto.
                    RUN OpenLine.
                        RUN MergeColumns(INPUT 2, c-tip-docto-vincul            , "Default").
                        ASSIGN iColCount = iColCount + 1.
                        RUN PrintDataString(INPUT c-lbl-num-docto-vincul        , "Default").
                        RUN MergeColumns(INPUT 3, c-cod-num-docto               , "Default").
                    RUN CloseLine. 
                END.            
            END.
            /* fim - documentos vinculados */


            /* fornecedor / fabricante */
            RUN OpenLine.
                RUN MergeColumns(INPUT 7, ""                            , "Default").
            RUN CloseLine.
            IF decla-import-adic.log-emite-fabrican = YES THEN DO:
                {utp/ut-liter.i Exportador/Fabricante/Produtor *}
                assign c-lbl-exportador = return-value.

                FIND FIRST emitente
                            WHERE emitente.cod-emitente = decla-import-adic.cdn-fornec NO-LOCK NO-ERROR.
                ASSIGN c-nome-export = emitente.nome-emit
                       c-pais-export = emitente.pais.

                RUN OpenLine.
                    RUN MergeColumns(INPUT 7, c-lbl-exportador              , "titulo").
                RUN CloseLine.
                RUN OpenLine.
                    RUN PrintDataString(INPUT c-lbl-nome-export             , "Default").
                    RUN MergeColumns   (INPUT 6, c-nome-export              , "Default").
                RUN CloseLine.
                RUN OpenLine.
                    RUN PrintDataString(INPUT c-lbl-pais-export             , "Default").
                    RUN MergeColumns   (INPUT 6, c-pais-export              , "Default").
                RUN CloseLine.
                /* exportador ‚ o mesmo que o fabricante, s¢ aparece o primeiro grupo de informa‡äes (-export) */
            END.
            ELSE DO:
                {utp/ut-liter.i Fabricante/Produtor *}
                assign c-lbl-fabri-prod = return-value.
                {utp/ut-liter.i Exportador *}
                assign c-lbl-exportador = return-value.

                FIND FIRST emitente
                            WHERE emitente.cod-emitente = decla-import-adic.cdn-fornec NO-LOCK NO-ERROR.
                ASSIGN c-nome-export = emitente.nome-emit
                       c-pais-export = emitente.pais.
                FIND FIRST emitente
                            WHERE emitente.cod-emitente = decla-import-adic.cdn-fabrican NO-LOCK NO-ERROR.
                ASSIGN c-nome-fabrican = emitente.nome-emit
                       c-pais-fabrican = emitente.pais.

                RUN OpenLine.
                    RUN MergeColumns(INPUT 7, c-lbl-exportador              , "titulo").
                RUN CloseLine.
                RUN OpenLine.
                    RUN PrintDataString(INPUT c-lbl-nome-export             , "Default").
                    RUN MergeColumns   (INPUT 6, c-nome-export              , "Default").
                RUN CloseLine.
                RUN OpenLine.
                    RUN PrintDataString(INPUT c-lbl-pais-export             , "Default").
                    RUN MergeColumns   (INPUT 6, c-pais-export              , "Default").
                RUN CloseLine.

                RUN OpenLine.
                    RUN MergeColumns(INPUT 7, ""                            , "Default").
                RUN CloseLine.

                RUN OpenLine.
                    RUN MergeColumns(INPUT 7, c-lbl-fabri-prod              , "titulo").
                RUN CloseLine.
                RUN OpenLine.
                    RUN PrintDataString(INPUT c-lbl-nome-fabrican           , "Default").
                    RUN MergeColumns   (INPUT 6, c-nome-fabrican            , "Default").
                RUN CloseLine.
                RUN OpenLine.
                    RUN PrintDataString(INPUT c-lbl-pais-fabrican           , "Default").
                    RUN MergeColumns   (INPUT 6, c-pais-fabrican            , "Default").
                RUN CloseLine.
            END.
            /* fim - fornecedor / fabricante */
            

            /* classificacao tarifaria */
            FIND FIRST classif-fisc
                        WHERE classif-fisc.class-fiscal = decla-import-adic.cod-classif-fisc NO-LOCK NO-ERROR.

            FIND FIRST inco-cx
                        WHERE inco-cx.cod-incoterm = decla-import-adic.cod-incoterm NO-LOCK NO-ERROR.
            
            ASSIGN                                   
                   c-classif-fisc              = decla-import-adic.cod-classif-fisc
                   c-desc-classif-fisc         = " - " + classif-fisc.descricao WHEN AVAIL classif-fisc
                   c-cod-nbm                   = decla-import-adic.cod-nbm
                                                                                                        
                   c-cod-incoterm              = decla-import-adic.cod-incoterm
                   c-desc-incoterm             = inco-cx.descricao WHEN AVAIL inco-cx
                   d-valor-vmcv                = decla-import-adic.val-vmcv-me[1]
                   
                   d-peso-liq-adic             = decla-import-adic.val-peso-liq.


            RUN OpenLine.
                RUN MergeColumns(INPUT 7, ""                            , "Default").
            RUN CloseLine.
            RUN OpenLine.
                RUN MergeColumns(INPUT 7, c-lbl-class-tribut            , "titulo").
            RUN CloseLine.
            RUN OpenLine.
                RUN PrintDataString(INPUT c-lbl-ncm                     , "n02").
                RUN PrintDataString(INPUT c-classif-fisc                , "Default").
                RUN MergeColumns   (INPUT 5, c-desc-classif-fisc        , "Default"). 
            RUN CloseLine.
            RUN OpenLine.
                RUN PrintDataString(INPUT c-lbl-nbm                     , "n02").
                RUN MergeColumns   (INPUT 6, c-cod-nbm                  , "Default"). 
            RUN CloseLine.
            /* fim - classificacao tarifaria */

            /* condi‡Æo de venda */
            RUN OpenLine.
                RUN MergeColumns(INPUT 7, ""                            , "Default").
            RUN CloseLine.
            RUN OpenLine.
                RUN MergeColumns(INPUT 7, c-lbl-cond-venda              , "titulo").
            RUN CloseLine.
            RUN OpenLine.
                RUN PrintDataString(INPUT c-lbl-incoterm                , "Default").
                RUN PrintDataString(INPUT c-cod-incoterm                , "Default").
                RUN MergeColumns   (INPUT 5, c-desc-incoterm            , "Default"). 
            RUN CloseLine.
            RUN OpenLine.
                RUN PrintDataString(INPUT c-lbl-vmcv                    , "Default").
                RUN PrintDataNumber(INPUT d-valor-vmcv                  , "numeroFormato2").
                RUN MergeColumns   (INPUT 5, c-moeda-vmcv               , "Default"). 
            RUN CloseLine.
            /* fim - condi‡Æo de venda */
        
            /* peso adic */
            RUN OpenLine.
                RUN MergeColumns(INPUT 7, ""                            , "Default").
            RUN CloseLine.
            RUN OpenLine.
                RUN MergeColumns(INPUT 1, c-lbl-peso-liq-adic           , "titulo").
                ASSIGN iColCount = iColCount + 1.
                RUN MergeColumnsNumber(INPUT 5, d-peso-liq-adic         , "numeroFormato4").
            RUN CloseLine.
            /* fim - peso adic */


            /* descricao detalhada da mercadoria */
            RUN OpenLine.
                RUN MergeColumns(INPUT 7, ""                            , "Default").
            RUN CloseLine.
            RUN OpenLine.
                RUN MergeColumns(INPUT 7, c-lbl-desc-det-merc           , "titulo").
            RUN CloseLine.
            FOR EACH decla-import-adic-itens
                        WHERE decla-import-adic-itens.num-di-ems = decla-import-adic.num-di-ems
                        AND   decla-import-adic-itens.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts
                        AND   decla-import-adic-itens.num-adic   = decla-import-adic.num-adic NO-LOCK:
                FIND FIRST moeda
                            WHERE moeda.mo-codigo = decla-import-adic-itens.cdn-moed-vucv NO-LOCK NO-ERROR.
                
                FIND FIRST decla-import-ord
                            WHERE decla-import-ord.num-di-ems  = decla-import-adic-itens.num-di-ems
                            AND   decla-import-ord.cdd-siscomex-dts = decla-import-adic-itens.cdd-siscomex-dts
                            AND   decla-import-ord.num-ordem   = decla-import-adic-itens.num-ordem
                            AND   decla-import-ord.num-parcela = decla-import-adic-itens.num-parcela NO-LOCK NO-ERROR.

                ASSIGN c-moeda-vucv = moeda.descricao WHEN AVAIL moeda.
                ASSIGN                                   
                   c-especif-itens             = TRIM(REPLACE(REPLACE(decla-import-adic-itens.dsl-especif,"<",""),">",""))
                   d-itens-qtd-adic            = decla-import-adic-itens.qtd-adic[1]
                   c-tab-unid-desc             = decla-import-ord.cod-unid-medid-item WHEN AVAIL decla-import-ord
                   d-valor-vucv                = decla-import-adic-itens.val-vucv.
                   
                
                RUN OpenLine.
                    RUN MergeColumns(INPUT 7, c-especif-itens               , "Default").
                RUN CloseLine.
                RUN OpenLine.
                    RUN PrintDataString(INPUT c-lbl-qtde                    , "Default").
                    RUN PrintDataNumber(INPUT d-itens-qtd-adic              , "Default").
                    RUN PrintDataString(INPUT c-tab-unid-desc               , "Default").
                    RUN PrintDataString(INPUT ""                            , "Default").
                    RUN PrintDataString(INPUT c-lbl-vucv                    , "Default").
                    RUN PrintDataNumber(INPUT d-valor-vucv                  , "numeroFormato2").
                    RUN MergeColumns   (INPUT 1, c-moeda-vucv               , "Default").
                RUN CloseLine.
            END.
            /* fim - descricao detalhada da mercadoria */
            
            ASSIGN
                   c-idi-tributac-impto-import = {cxinc/i01cx402.i 04 decla-import-adic.idi-tributac-impto-import}
                   d-val-aliq-ii               = decla-import-adic.val-aliq-ii
                   d-val-unit-ii               = decla-import-adic.val-unit-ii
                   d-val-ii-db-cr              = decla-import-adic.val-ii-db-cr

                   c-idi-tributac-ipi          = {cxinc/i01cx402.i 04 decla-import-adic.idi-tributac-ipi}
                   d-val-aliq-ipi              = decla-import-adic.val-aliq-ipi
                   d-val-unit-ipi              = decla-import-adic.val-unit-ipi
                   d-val-ipi-db-cr             = decla-import-adic.val-ipi-db-cr

                   d-val-base-pis              = decla-import-adic.val-base-pis
                   d-perc-reduc-pis            = decla-import-adic.val-perc-reduc-pis
                   c-idi-tribut-pis            = {cxinc/i01cx402.i 04 decla-import-adic.idi-tributac-pis}
                   d-val-aliq-icms             = decla-import-adic.val-aliq-icms

                   d-val-base-cofins           = decla-import-adic.val-base-cofins
                   d-perc-reduc-cofins         = decla-import-adic.val-perc-reduc-cofins
                   c-idi-tribut-cofins         = {cxinc/i01cx402.i 04 decla-import-adic.idi-tributac-cofins}

                   d-val-aliq-pis              = decla-import-adic.val-aliq-pis
                   d-val-unit-pis              = decla-import-adic.val-unit-pis
                   d-val-devido-pis            = decla-import-adic.val-pis-nao-tributad + decla-import-adic.val-pis-db-cr                                                              
                   d-val-pis-db-cr             = decla-import-adic.val-pis-db-cr

                   d-val-aliq-cofins           = decla-import-adic.val-aliq-cofins
                   d-val-unit-cofins           = decla-import-adic.val-unit-cofins
                   d-val-devido-cofins         = decla-import-adic.val-cofins-nao-tributad + decla-import-adic.val-cofins-db-cr
                   d-val-cofins-db-cr          = decla-import-adic.val-cofins-db-cr.

            
            /* imposto de importacao */
            RUN OpenLine.
                RUN MergeColumns(INPUT 7, ""                             , "Default").
            RUN CloseLine.
            RUN OpenLine.
                RUN MergeColumns(INPUT 7, c-lbl-imp-imp                  , "titulo").
            RUN CloseLine.
            RUN OpenLine.
                RUN MergeColumns(INPUT 1,c-lbl-reg-tribut                , "Default").
                ASSIGN iColCount = iColCount + 1.
                RUN MergeColumns(INPUT 5, c-idi-tributac-impto-import    , "Default").
            RUN CloseLine.

            IF d-val-unit-ii <= 0 THEN DO:
                RUN OpenLine.
                    RUN MergeColumns(INPUT 1,c-lbl-aliq-adval-tec        , "Default").
                    ASSIGN iColCount = iColCount + 1.
                    RUN MergeColumnsNumber(INPUT 5, d-val-aliq-ii        , "numeroFormato2").
                RUN CloseLine.
            END.
            ELSE DO:
                RUN OpenLine.
                    RUN MergeColumns(INPUT 1,c-lbl-aliq-unit             , "Default").
                    ASSIGN iColCount = iColCount + 1.
                    RUN MergeColumnsNumber(INPUT 5, d-val-unit-ii        , "numeroFormato2").
                RUN CloseLine.
            END.

            RUN OpenLine.
                RUN MergeColumns(INPUT 1,c-lbl-valor-recolher            , "Default").
                ASSIGN iColCount = iColCount + 1.
                RUN MergeColumnsNumber(INPUT 5, d-val-ii-db-cr           , "numeroFormato2").
            RUN CloseLine.
            /* fim - imposto de importacao */
   
            /* imposto sobre produto industrializado */
            RUN OpenLine.
                RUN MergeColumns(INPUT 7, ""                             , "Default").
            RUN CloseLine.
            RUN OpenLine.
                RUN MergeColumns(INPUT 7, c-lbl-imp-prod-ind             , "titulo").
            RUN CloseLine.
            RUN OpenLine.
                RUN MergeColumns(INPUT 1, c-lbl-reg-tribut               , "Default").
                ASSIGN iColCount = iColCount + 1.
                RUN MergeColumns(INPUT 5, c-idi-tributac-ipi             , "Default").
            RUN CloseLine.

            IF d-val-unit-ipi <= 0 THEN DO:
                RUN OpenLine.
                    RUN MergeColumns(INPUT 1, c-lbl-aliq-adval-tipi      , "Default").
                    ASSIGN iColCount = iColCount + 1.
                    RUN MergeColumnsNumber(INPUT 5, d-val-aliq-ipi       , "numeroFormato2").
                RUN CloseLine.
            END.
            ELSE DO:
                RUN OpenLine.
                    RUN MergeColumns(INPUT 1, c-lbl-aliq-unit            , "Default").
                    ASSIGN iColCount = iColCount + 1.
                    RUN MergeColumnsNumber(INPUT 5, d-val-unit-ipi       , "numeroFormato2").
                RUN CloseLine.
            END.

            RUN OpenLine.
                RUN MergeColumns(INPUT 1, c-lbl-valor-recolher           , "Default").
                ASSIGN iColCount = iColCount + 1.
                RUN MergeColumnsNumber(INPUT 5, d-val-ipi-db-cr          , "numeroFormato2").
            RUN CloseLine.
            /* fim - imposto sobre produto industrializado */
        
            /* dados gerais pis */
            RUN OpenLine.
                RUN MergeColumns(INPUT 7, ""                            , "Default").
            RUN CloseLine.
            RUN OpenLine.
                RUN MergeColumns(INPUT 7, c-lbl-dados-pis               , "titulo").
            RUN CloseLine.
            RUN OpenLine.
                RUN MergeColumns(INPUT 1, c-lbl-base-calc               , "Default").
                ASSIGN iColCount = iColCount + 1.
                RUN MergeColumnsNumber(INPUT 5, d-val-base-pis          , "numeroFormato2").
            RUN CloseLine.
            RUN OpenLine.
                RUN MergeColumns(INPUT 1, c-lbl-perc-reduc              , "Default").
                ASSIGN iColCount = iColCount + 1.
                RUN MergeColumnsNumber(INPUT 5, d-perc-reduc-pis        , "numeroFormato2").
            RUN CloseLine.
            RUN OpenLine.
                RUN MergeColumns(INPUT 1, c-lbl-reg-tribut              , "Default").
                ASSIGN iColCount = iColCount + 1.
                RUN MergeColumns(INPUT 5, c-idi-tribut-pis              , "Default").
            RUN CloseLine.
            RUN OpenLine.
                RUN MergeColumns(INPUT 1, c-lbl-aliq-icms               , "Default").
                ASSIGN iColCount = iColCount + 1.
                RUN MergeColumnsNumber(INPUT 5, d-val-aliq-icms         , "numeroFormato2").
            RUN CloseLine.
            /* fim - dados gerais pis */

            /* dados gerais cofins */
            RUN OpenLine.
                RUN MergeColumns(INPUT 7, ""                            , "Default").
            RUN CloseLine.
            RUN OpenLine.
                RUN MergeColumns(INPUT 7, c-lbl-dados-cofins            , "titulo").
            RUN CloseLine.
            RUN OpenLine.
                RUN MergeColumns(INPUT 1, c-lbl-base-calc               , "Default").
                ASSIGN iColCount = iColCount + 1.
                RUN MergeColumnsNumber(INPUT 5, d-val-base-cofins       , "numeroFormato2").
            RUN CloseLine.
            RUN OpenLine.
                RUN MergeColumns(INPUT 1, c-lbl-perc-reduc              , "Default").
                ASSIGN iColCount = iColCount + 1.
                RUN MergeColumnsNumber(INPUT 5, d-perc-reduc-cofins     , "numeroFormato2").
            RUN CloseLine.
            RUN OpenLine.
                RUN MergeColumns(INPUT 1, c-lbl-reg-tribut              , "Default").
                ASSIGN iColCount = iColCount + 1.
                RUN MergeColumns(INPUT 5, c-idi-tribut-cofins           , "Default").
            RUN CloseLine.
            RUN OpenLine.
                RUN MergeColumns(INPUT 1, c-lbl-aliq-icms               , "Default").
                ASSIGN iColCount = iColCount + 1.
                RUN MergeColumnsNumber(INPUT 5, d-val-aliq-icms         , "numeroFormato2").
            RUN CloseLine.
            /* fim - dados gerais cofins */

            /* Pis/Pasep */
            RUN OpenLine.
                RUN MergeColumns(INPUT 7, ""                            , "Default").
            RUN CloseLine.
            RUN OpenLine.
                RUN MergeColumns(INPUT 7, c-lbl-pis-pasep               , "titulo").
            RUN CloseLine.
            RUN OpenLine.
                RUN MergeColumns(INPUT 1, c-lbl-aliq-ad-valorem         , "Default").
                ASSIGN iColCount = iColCount + 1.
                RUN MergeColumnsNumber(INPUT 5, d-val-aliq-pis          , "numeroFormato2").
            RUN CloseLine.
            RUN OpenLine.
                RUN MergeColumns(INPUT 1, c-lbl-aliq-especif            , "Default").
                ASSIGN iColCount = iColCount + 1.
                RUN MergeColumnsNumber(INPUT 5, d-val-unit-pis          , "numeroFormato2").
            RUN CloseLine.
            RUN OpenLine.
                RUN MergeColumns(INPUT 1, c-lbl-valor-devido            , "Default").
                ASSIGN iColCount = iColCount + 1.
                RUN MergeColumnsNumber(INPUT 5, d-val-devido-pis        , "numeroFormato2").
            RUN CloseLine.
            RUN OpenLine.
                RUN MergeColumns(INPUT 1, c-lbl-valor-recolher          , "Default").
                ASSIGN iColCount = iColCount + 1.
                RUN MergeColumnsNumber(INPUT 5, d-val-pis-db-cr         , "numeroFormato2").
            RUN CloseLine.
            /* fim - Pis/Pasep */
        
            /* cofins */
            RUN OpenLine.
                RUN MergeColumns(INPUT 7, ""                            , "Default").
            RUN CloseLine.
            RUN OpenLine.
                RUN MergeColumns(INPUT 7, c-lbl-cofins2                 , "titulo").
            RUN CloseLine.
            RUN OpenLine.
                RUN MergeColumns(INPUT 1, c-lbl-aliq-ad-valorem         , "Default").
                ASSIGN iColCount = iColCount + 1.
                RUN MergeColumnsNumber(INPUT 5, d-val-aliq-cofins       , "numeroFormato2").
            RUN CloseLine.
            RUN OpenLine.
                RUN MergeColumns(INPUT 1, c-lbl-aliq-especif            , "Default").
                ASSIGN iColCount = iColCount + 1.
                RUN MergeColumnsNumber(INPUT 5, d-val-unit-cofins       , "numeroFormato2").
            RUN CloseLine.
            RUN OpenLine.
                RUN MergeColumns(INPUT 1, c-lbl-valor-devido            , "Default").
                ASSIGN iColCount = iColCount + 1.
                RUN MergeColumnsNumber(INPUT 5, d-val-devido-cofins     , "numeroFormato2").
            RUN CloseLine.
            RUN OpenLine.
                RUN MergeColumns(INPUT 1, c-lbl-valor-recolher          , "Default").
                ASSIGN iColCount = iColCount + 1.
                RUN MergeColumnsNumber(INPUT 5, d-val-cofins-db-cr      , "numeroFormato2").
            RUN CloseLine.
            /* fim - cofins */
            
            IF l-nt2024002 THEN DO:            
                ASSIGN d-val-aliq-cbs        = 0
                       d-val-aliq-ibsuf      = 0
                       d-val-aliq-ibsmun     = 0
                       d-val-devido-cbs      = 0
                       d-val-recolher-cbs    = 0
                       d-val-devido-ibsuf    = 0
                       d-val-recolher-ibsuf  = 0
                       d-val-devido-ibsmun   = 0
                       d-val-recolher-ibsmun = 0
                       d-aliq-cbs-reg        = 0
                       d-val-cbs-reg         = 0
                       d-aliq-ibsuf-reg      = 0
                       d-val-ibsuf-reg       = 0
                       d-aliq-ibsmun-reg     = 0
                       d-val-ibsmun-reg      = 0.
                       
                FOR EACH decla-import-adic-trib NO-LOCK
                   WHERE decla-import-adic-trib.num-di-ems       = decla-import-adic.num-di-ems
                     AND decla-import-adic-trib.num-adic         = decla-import-adic.num-adic
                     AND decla-import-adic-trib.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts:
                    CASE decla-import-adic-trib.nom-trib:
                        WHEN "IBSUF":U THEN
                            CASE decla-import-adic-trib.cod-campo:
                                WHEN "ALIQUOTA":U THEN ASSIGN d-val-aliq-ibsuf = DECIMAL(replace(decla-import-adic-trib.cod-conteudo,',','.')).                                
                                WHEN "VALOR":U THEN    ASSIGN d-val-recolher-ibsuf = DECIMAL(replace(decla-import-adic-trib.cod-conteudo,',','.')).
                                WHEN "ALIQ-EFETIVA-REG":U THEN ASSIGN d-aliq-ibsuf-reg = DEC(REPLACE(decla-import-adic-trib.cod-conteudo,',','.')).                                
                                WHEN "VALOR-REG":U THEN        ASSIGN d-val-ibsuf-reg = DEC(REPLACE(decla-import-adic-trib.cod-conteudo,',','.')).
                            END CASE.
                        WHEN "IBSMUN":U THEN
                            CASE decla-import-adic-trib.cod-campo:
                                WHEN "ALIQUOTA":U THEN ASSIGN d-val-aliq-ibsmun = DEC(REPLACE(decla-import-adic-trib.cod-conteudo,',','.')).                                
                                WHEN "VALOR":U THEN    ASSIGN d-val-recolher-ibsmun = DEC(REPLACE(decla-import-adic-trib.cod-conteudo,',','.')).
                                WHEN "ALIQ-EFETIVA-REG":U THEN ASSIGN d-aliq-ibsmun-reg = DEC(REPLACE(decla-import-adic-trib.cod-conteudo,',','.')).                                
                                WHEN "VALOR-REG":U THEN        ASSIGN d-val-ibsmun-reg = DEC(REPLACE(decla-import-adic-trib.cod-conteudo,',','.')).
                            END CASE.
                        WHEN "CBS":U THEN
                            CASE decla-import-adic-trib.cod-campo:
                                WHEN "ALIQUOTA":U THEN ASSIGN d-val-aliq-cbs = DECIMAL(replace(decla-import-adic-trib.cod-conteudo,',','.')).
                                WHEN "VALOR":U THEN    ASSIGN d-val-recolher-cbs = DECIMAL(replace(decla-import-adic-trib.cod-conteudo,',','.')).
                                WHEN "ALIQ-EFETIVA-REG":U THEN ASSIGN d-aliq-cbs-reg = DEC(REPLACE(decla-import-adic-trib.cod-conteudo,',','.')).                                
                                WHEN "VALOR-REG":U THEN        ASSIGN d-val-cbs-reg = DEC(REPLACE(decla-import-adic-trib.cod-conteudo,',','.')).
                            END CASE.
                    END CASE.
                END.
            
                /* cbs */
                RUN OpenLine.
                    RUN MergeColumns(INPUT 7, ""                            , "Default").
                RUN CloseLine.
                RUN OpenLine.
                    RUN MergeColumns(INPUT 7, c-lbl-cbs                     , "titulo").
                RUN CloseLine.
                RUN OpenLine.
                    RUN MergeColumns(INPUT 1, c-lbl-aliq-ad-valorem         , "Default").
                    ASSIGN iColCount = iColCount + 1.
                    RUN MergeColumnsNumber(INPUT 5, d-val-aliq-cbs          , "numeroFormato2").
                RUN CloseLine.
                RUN OpenLine.
                    RUN MergeColumns(INPUT 1, c-lbl-aliq-especif            , "Default").
                    ASSIGN iColCount = iColCount + 1.
                    RUN MergeColumnsNumber(INPUT 5, d-val-aliq-cbs          , "numeroFormato2").
                RUN CloseLine.
                RUN OpenLine.
                    RUN MergeColumns(INPUT 1, c-lbl-valor-devido            , "Default").
                    ASSIGN iColCount = iColCount + 1.
                    RUN MergeColumnsNumber(INPUT 5, d-val-devido-cbs        , "numeroFormato2").
                RUN CloseLine.
                RUN OpenLine.
                    RUN MergeColumns(INPUT 1, c-lbl-valor-recolher          , "Default").
                    ASSIGN iColCount = iColCount + 1.
                    RUN MergeColumnsNumber(INPUT 5, d-val-recolher-cbs      , "numeroFormato2").
                RUN CloseLine.
                /* fim - cbs */
                
                /* cbs regular */
                RUN OpenLine.
                    RUN MergeColumns(INPUT 7, ""                            , "Default").
                RUN CloseLine.
                RUN OpenLine.
                    RUN MergeColumns(INPUT 7, c-lbl-cbs-reg                 , "titulo").
                RUN CloseLine.
                RUN OpenLine.
                    RUN MergeColumns(INPUT 1, c-lbl-aliq-especif            , "Default").
                    ASSIGN iColCount = iColCount + 1.
                    RUN MergeColumnsNumber(INPUT 5, d-aliq-cbs-reg          , "numeroFormato2").
                RUN CloseLine.
                RUN OpenLine.
                    RUN MergeColumns(INPUT 1, c-lbl-valor                   , "Default").
                    ASSIGN iColCount = iColCount + 1.
                    RUN MergeColumnsNumber(INPUT 5, d-val-cbs-reg           , "numeroFormato2").
                RUN CloseLine.
                /* fim - cbs regular */

                /* ibs-uf */
                RUN OpenLine.
                    RUN MergeColumns(INPUT 7, ""                            , "Default").
                RUN CloseLine.
                RUN OpenLine.
                    RUN MergeColumns(INPUT 7, c-lbl-ibsuf                     , "titulo").
                RUN CloseLine.
                RUN OpenLine.
                    RUN MergeColumns(INPUT 1, c-lbl-aliq-ad-valorem         , "Default").
                    ASSIGN iColCount = iColCount + 1.
                    RUN MergeColumnsNumber(INPUT 5, d-val-aliq-ibsuf        , "numeroFormato2").
                RUN CloseLine.
                RUN OpenLine.
                    RUN MergeColumns(INPUT 1, c-lbl-aliq-especif            , "Default").
                    ASSIGN iColCount = iColCount + 1.
                    RUN MergeColumnsNumber(INPUT 5, d-val-aliq-ibsuf        , "numeroFormato2").
                RUN CloseLine.
                RUN OpenLine.
                    RUN MergeColumns(INPUT 1, c-lbl-valor-devido            , "Default").
                    ASSIGN iColCount = iColCount + 1.
                    RUN MergeColumnsNumber(INPUT 5, d-val-devido-ibsuf        , "numeroFormato2").
                RUN CloseLine.
                RUN OpenLine.
                    RUN MergeColumns(INPUT 1, c-lbl-valor-recolher          , "Default").
                    ASSIGN iColCount = iColCount + 1.
                    RUN MergeColumnsNumber(INPUT 5, d-val-recolher-ibsuf    , "numeroFormato2").
                RUN CloseLine.
                /* fim - ibs-uf */
                
                /* ibs uf regular */
                RUN OpenLine.
                    RUN MergeColumns(INPUT 7, ""                            , "Default").
                RUN CloseLine.
                RUN OpenLine.
                    RUN MergeColumns(INPUT 7, c-lbl-ibsuf-reg               , "titulo").
                RUN CloseLine.
                RUN OpenLine.
                    RUN MergeColumns(INPUT 1, c-lbl-aliq-especif            , "Default").
                    ASSIGN iColCount = iColCount + 1.
                    RUN MergeColumnsNumber(INPUT 5, d-aliq-ibsuf-reg        , "numeroFormato2").
                RUN CloseLine.
                RUN OpenLine.
                    RUN MergeColumns(INPUT 1, c-lbl-valor                   , "Default").
                    ASSIGN iColCount = iColCount + 1.
                    RUN MergeColumnsNumber(INPUT 5, d-val-ibsuf-reg         , "numeroFormato2").
                RUN CloseLine.
                /* fim - ibs uf regular */

                /* ibs-mun */
                RUN OpenLine.
                    RUN MergeColumns(INPUT 7, ""                            , "Default").
                RUN CloseLine.
                RUN OpenLine.
                    RUN MergeColumns(INPUT 7, c-lbl-ibsmun                  , "titulo").
                RUN CloseLine.
                RUN OpenLine.
                    RUN MergeColumns(INPUT 1, c-lbl-aliq-ad-valorem         , "Default").
                    ASSIGN iColCount = iColCount + 1.
                    RUN MergeColumnsNumber(INPUT 5, d-val-aliq-ibsmun       , "numeroFormato2").
                RUN CloseLine.
                RUN OpenLine.
                    RUN MergeColumns(INPUT 1, c-lbl-aliq-especif            , "Default").
                    ASSIGN iColCount = iColCount + 1.
                    RUN MergeColumnsNumber(INPUT 5, d-val-aliq-ibsmun       , "numeroFormato2").
                RUN CloseLine.
                RUN OpenLine.
                    RUN MergeColumns(INPUT 1, c-lbl-valor-devido            , "Default").
                    ASSIGN iColCount = iColCount + 1.
                    RUN MergeColumnsNumber(INPUT 5, d-val-devido-ibsmun     , "numeroFormato2").
                RUN CloseLine.
                RUN OpenLine.
                    RUN MergeColumns(INPUT 1, c-lbl-valor-recolher          , "Default").
                    ASSIGN iColCount = iColCount + 1.
                    RUN MergeColumnsNumber(INPUT 5, d-val-recolher-ibsmun   , "numeroFormato2").
                RUN CloseLine.
                /* fim - ibs-mun */
                
                /* ibs mun regular */
                RUN OpenLine.
                    RUN MergeColumns(INPUT 7, ""                            , "Default").
                RUN CloseLine.
                RUN OpenLine.
                    RUN MergeColumns(INPUT 7, c-lbl-ibsmun-reg              , "titulo").
                RUN CloseLine.
                RUN OpenLine.
                    RUN MergeColumns(INPUT 1, c-lbl-aliq-especif            , "Default").
                    ASSIGN iColCount = iColCount + 1.
                    RUN MergeColumnsNumber(INPUT 5, d-aliq-ibsmun-reg       , "numeroFormato2").
                RUN CloseLine.
                RUN OpenLine.
                    RUN MergeColumns(INPUT 1, c-lbl-valor                   , "Default").
                    ASSIGN iColCount = iColCount + 1.
                    RUN MergeColumnsNumber(INPUT 5, d-val-ibsmun-reg        , "numeroFormato2").
                RUN CloseLine.
                /* fim - ibs mun regular */
            end.            
        END. /*for each decla-import-adic */
    END. /* for each decla-import*/      
  

    /*=======================
      Fim ImpressÆo dos Dados
      =======================*/

    run CloseTable.
	run OpenWorksheetOptions.
	run CloseWorksheetOptions.
	run CloseWorkSheet.
	run CloseWorkBook.

END PROCEDURE.

/*===================
  Internal Procedures
  ===================*/

/*==============
  XML Procedures
  ==============*/

procedure OpenWorkBook:

    put unformatted
        '<?xml version="1.0"?>'                                                       skip
        '<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"'              skip
        '          xmlns:o="urn:schemas-microsoft-com:office:office"'                 skip
        '          xmlns:x="urn:schemas-microsoft-com:office:excel"'                  skip
        '          xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"'           skip
        '          xmlns:html="http://www.w3.org/TR/REC-html40">'                     skip
        '   <DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">'     skip
        '       <Author>' c-seg-usuario '</Author>'                                   skip
        '       <LastAuthor>' c-seg-usuario '</LastAuthor>'                           skip
        '       <LastPrinted>' '2005-10-18T09:43:42Z' '</LastPrinted>'                skip
        '       <Created>' '2005-10-18T09:41:43Z' '</Created>'                        skip
        '       <Company>' 'Datasul' '</Company>'                                     skip
        '       <Version>10.2625</Version>'                                           skip
        '   </DocumentProperties>'                                                    skip
        '   <OfficeDocumentSettings xmlns="urn:schemas-microsoft-com:office:office">' skip
        '      <DownloadComponents/>'                                                 skip
        '      <LocationOfComponents HRef="file:///~\~\"/>'                           skip
        '   </OfficeDocumentSettings>'                                                skip.

end procedure.

procedure CloseWorkBook:

    put unformatted
        '</Workbook>'.

end procedure.

procedure OpenExcelWorkBook:

    put unformatted
        '<ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">' skip
        '   <WindowHeight>2970</WindowHeight>'                           skip
        '   <WindowWidth>11340</WindowWidth>'                            skip
        '   <WindowTopX>360</WindowTopX>'                                skip
        '   <WindowTopY>105</WindowTopY>'                                skip
        '   <ProtectStructure>False</ProtectStructure>'                  skip
        '   <ProtectWindows>False</ProtectWindows>'                      skip.

end procedure.

procedure CloseExcelWorkBook:

    put unformatted
        '</ExcelWorkbook>' skip.
end procedure.

procedure OpenStyles:

    put unformatted
        '<Styles>'                                    skip
        '   <Style ss:ID="Default" ss:Name="Normal">' skip
        '      <Alignment ss:Vertical="Bottom"/>'     skip
        '      <Borders/>'                            skip
        '      <Font/>'                               skip
        '      <Interior/>'                           skip
        '      <NumberFormat/>'                       skip
        '      <Protection/>'                         skip
        '   </Style>'                                 skip.

    put unformatted
        '   <Style ss:ID="m21">'                                                          skip
        '      <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'                  SKIP
        '      <Borders>'                                                                 skip
        '         <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>' skip
        '         <Border ss:Position="Left"   ss:LineStyle="Continuous" ss:Weight="2"/>' skip
        '         <Border ss:Position="Right"  ss:LineStyle="Continuous" ss:Weight="2"/>' skip
        '         <Border ss:Position="Top"    ss:LineStyle="Continuous" ss:Weight="2"/>' skip
        '      </Borders>'                                                                SKIP
        '      <Protection/>'                                                             SKIP
        '      <Font x:Family="Swiss" ss:Bold="1"/>'                                      SKIP
        '   </Style>'                                                                     skip.

    put unformatted
        '   <Style ss:ID="n01">'                                                          skip
        '      <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'                  SKIP
        '      <Font x:Family="Swiss" ss:Bold="1"/>'                                      SKIP
        '      <Protection/>'                                                             SKIP
        '   </Style>'                                                                     SKIP.

    put unformatted
        '   <Style ss:ID="n02">'                                                          skip
        '      <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'                    SKIP
        '      <Font x:Family="Swiss" ss:Bold="1"/>'                                      SKIP
        '      <Protection/>'                                                             SKIP
        '   </Style>'                                                                     SKIP.

    put unformatted
        '   <Style ss:ID="titulo">'                                                       skip
        '      <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'                    SKIP
        '      <Font x:Family="Swiss" ss:Bold="1" ss:Italic="1"/>'                        SKIP
        '      <Protection/>'                                                             SKIP
        '   </Style>'                                                                     SKIP.

    put unformatted
        '   <Style ss:ID="divisoria">'                                                    skip
        '      <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'                    SKIP
        '      <Borders>'                                                                 SKIP
        '         <Border ss:Position="Bottom"   ss:LineStyle="Continuous" ss:Weight="2"/>' SKIP
        '      </Borders>'                                                                SKIP
        '      <Font x:Family="Swiss" ss:Bold="1" ss:Italic="1"/>'                        SKIP
        '      <Protection/>'                                                             SKIP
        '   </Style>'                                                                     SKIP.

    put unformatted
        '   <Style ss:ID="divisoria_di">'                                                 skip
        '      <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'                    SKIP
        '      <Borders>'                                                                 SKIP
        '         <Border ss:Position="Top"   ss:LineStyle="Continuous" ss:Weight="2"/>' SKIP
        '         <Border ss:Position="Bottom"   ss:LineStyle="Continuous" ss:Weight="2"/>' SKIP
        '      </Borders>'                                                                SKIP
        '      <Font x:Family="Swiss" ss:Bold="1" ss:Italic="1"/>'                        SKIP
        '      <Protection/>'                                                             SKIP
        '   </Style>'                                                                     SKIP.

    put unformatted
        '   <Style ss:ID="subtitulo">'                                                    skip
        '      <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'                  SKIP
        '   </Style>'                                                                     SKIP.

    put unformatted
        '   <Style ss:ID="mascara">'                                                      SKIP
        '      <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'                  SKIP
        '      <Borders>'                                                                 SKIP
        '         <Border ss:Position="Bottom"   ss:LineStyle="Continuous" ss:Weight="1"/>' SKIP
        '      </Borders>'                                                                SKIP
        '      <Protection/>'                                                             SKIP
        '   </Style>'                                                                     SKIP.

    put unformatted
        '   <Style ss:ID="assinatura">'                                                   SKIP
        '      <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'                  SKIP
        '      <Borders>'                                                                 SKIP
        '         <Border ss:Position="Top"   ss:LineStyle="Continuous" ss:Weight="1"/>'  SKIP
        '      </Borders>'                                                                SKIP
        '      <Protection/>'                                                             SKIP
        '   </Style>'                                                                     SKIP.

    put unformatted
        '   <Style ss:ID="pagina">'                                                       SKIP
        '      <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'                   SKIP
        '      <Font x:Family="Swiss"/>'                                                  SKIP
        '      <Protection/>'                                                             SKIP
        '   </Style>'                                                                     SKIP.
        
    put unformatted
        '   <Style ss:ID="s50">'                                                          skip
        '      <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'                    SKIP
        '      <Borders>'                                                                 skip
        '         <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>' skip
        '         <Border ss:Position="Left"   ss:LineStyle="Continuous" ss:Weight="2"/>' skip
        '         <Border ss:Position="Right"  ss:LineStyle="Continuous" ss:Weight="2"/>' skip
        '         <Border ss:Position="Top"    ss:LineStyle="Continuous" ss:Weight="2"/>' skip
        '      </Borders>'                                                                SKIP
        '      <Font x:Family="Swiss" ss:Bold="1"/>'                                      SKIP
        '      <Protection/>'                                                             SKIP
        '   </Style>'                                                                     skip.

    put unformatted
        '   <Style ss:ID="numeroFormato2">'                                               skip
        '      <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'                   SKIP
        '      <Protection/>'                                                             SKIP
        '      <NumberFormat ss:Format="###,###,###,##0.00"/>'                            SKIP
        '      <Font x:Family="Swiss"/>'                                                  SKIP
        '   </Style>'                                                                     SKIP.

    put unformatted
        '   <Style ss:ID="numeroFormato4">'                                               skip
        '      <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'                   SKIP
        '      <Protection/>'                                                             SKIP
        '      <NumberFormat ss:Format="###,###,###,##0.0000"/>'                          SKIP
        '      <Font x:Family="Swiss"/>'                                                  SKIP
        '   </Style>'                                                                     SKIP.

end procedure.
            
procedure CloseStyles:

    put unformatted
        '</Styles>' skip.
end procedure.

procedure OpenWorkSheet:
    
    def input param c-program-name as char no-undo.

    put unformatted
        '<Worksheet ss:Name="' c-program-name '" ss:Protected="1">' skip.

end procedure.

procedure CloseWorkSheet:

    put unformatted
        '</Worksheet>' skip.

end procedure.

procedure OpenWorksheetOptions:
    put unformatted
        '<WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel" ss:Protected="1">'   skip
        '   <PageSetup>'                                                                       skip
        '      <Header x:Margin="0.4" x:Data="&amp;LCabecalho"/>'                              skip
        '      <Footer x:Margin="0.4"/>'                                                       skip
        '      <PageMargins x:Bottom="0.984251969" x:Left="0.78740157499999996"'               skip
        '                   x:Right="0.78740157499999996" x:Top="0.984251969"/>'               skip
        '   </PageSetup>'                                                                      SKIP            
        '   <Print>     '                                                                      SKIP     
        '      <Scale>75</Scale>'                                                              SKIP
        '   </Print>'                                                                          SKIP
        ' <PageBreakZoom>100</PageBreakZoom>'                                                  skip
        ' <ProtectObjects>True</ProtectObjects>'                                               SKIP
        ' <ProtectScenarios>True</ProtectScenarios>'                                           SKIP
        ' <EnableSelection>UnlockedCells</EnableSelection>'                                    SKIP
        ' <Selected/>'                                                                         skip.

end procedure.

procedure CloseWorksheetOptions:

    put unformatted
        '</WorksheetOptions>' skip.

end procedure.
	
procedure OpenTable:

    def input param pColumns as int no-undo.

    put unformatted
        '   <Table ss:ExpandedColumnCount="' pColumns '" ss:ExpandedRowCount="65500" x:FullColumns="1" x:FullRows="1">' skip.

end procedure.

procedure CloseTable:

    put unformatted
        '   </Table>' skip.

end procedure.

procedure setColumnWidth:

    def input param cWidth as char no-undo.

    put unformatted
        '       <Column ss:AutoFitWidth="0" ss:Width="' trim(cWidth) '"/>' skip.

end procedure.

procedure OpenLine:

    assign iLineCount = iLineCount + 1.

    put unformatted
        '      <Row ss:Index="' iLineCount '">' skip.

end procedure.
	
procedure CloseLine:

    /* reinicia a contagem das colunas sempre que a TAG da linha ‚ fechada */
    assign iColCount = 0.

    put unformatted
        '      </Row>' skip.

end procedure.
	
procedure PrintDataString:

    def input param pData  as char no-undo.
    def input param pStyle as char no-undo.

    assign iColCount = iColCount + 1.

    if  pStyle <> "" then
        put unformatted
            '         <Cell ss:Index="' iColCount '" ss:StyleID="' pStyle '"><Data ss:Type="String">' pData '</Data></Cell>' skip.
    else
        put unformatted
            '         <Cell ss:Index="' iColCount '"><Data ss:Type="String">' pData '</Data></Cell>' skip.

end procedure.
	
procedure PrintDataNumber:

    def input param pData  as char no-undo.
    def input param pStyle as char no-undo.

    assign iColCount = iColCount + 1.

    if  pStyle <> "" then
        put unformatted
            '         <Cell ss:Index="' iColCount '" ss:StyleID="' pStyle '"><Data ss:Type="Number">' pData '</Data></Cell>' skip.
    else
        put unformatted
            '         <Cell ss:Index="' iColCount '"><Data ss:Type="Number">' pData '</Data></Cell>' skip.

end procedure.

procedure PrintDataDate:

    def input param pData  as date no-undo.
    def input param pStyle as char no-undo.


    def var cYear          as char no-undo.
    def var cMonth         as char no-undo.
    def var cDay           as char no-undo.

    /* conversÆo das datas para padrÆo XML */
    assign cYear  = string(year(pData))
           cMonth = string(month(pData),"99")
           cDay   = string(day(pData),"99").

    assign iColCount = iColCount + 1.

    if  pStyle <> "" then
        put unformatted
            '         <Cell ss:Index="' iColCount '" ss:StyleID="' pStyle '"><Data ss:Type="DateTime">' cYear '-' cMonth '-' cDay 'T00:00:00.000</Data></Cell>' skip.
    else
        put unformatted
            '         <Cell ss:Index="' iColCount '"><Data ss:Type="DateTime">' cYear '-' cMonth '-' cDay 'T00:00:00.000</Data></Cell>' skip.

end procedure.


procedure MergeColumns:

    def input param iNumberCols as int  no-undo. /* n£mero de c‚lulas da coluna a serem mescladas a partir da c‚lula corrente */
    def input param cData       as char no-undo.
    def input param cStyle      as char no-undo.

    

    assign iColCount = iColCount + 1. /* pr¢xima c‚lula da coluna */

    put unformatted
        '         <Cell ss:Index="' iColCount '" ss:MergeAcross="' iNumberCols '" ss:StyleID="' cStyle '"><Data ss:Type="String">' cData '</Data></Cell>' skip.

    /* ap¢s mesclar as c‚lulas atualiza a coluna corrente, retirando a c‚lula (coluna) acrescenta acima */
    assign iColCount = iColCount + iNumberCols - 1.

end procedure.

procedure MergeColumnsNumber:

    def input param iNumberCols as int  no-undo. /* n£mero de c‚lulas da coluna a serem mescladas a partir da c‚lula corrente */
    def input param cData       as char no-undo.
    def input param cStyle      as char no-undo.

    assign iColCount = iColCount + 1. /* pr¢xima c‚lula da coluna */

    put unformatted
        '         <Cell ss:Index="' iColCount '" ss:MergeAcross="' iNumberCols '" ss:StyleID="' cStyle '"><Data ss:Type="Number">' cData '</Data></Cell>' skip.

    /* ap¢s mesclar as c‚lulas atualiza a coluna corrente, retirando a c‚lula (coluna) acrescenta acima */
    assign iColCount = iColCount + iNumberCols - 1.

end procedure. /* procedure MergeColumnsNumber: */
              
function fnSkipCol returns char (input pNumberColsToSkip as int).
    
    def var iCol as int no-undo.

    do iCol = 1 to pNumberColsToSkip:
        assign iColCount = iColCount + 1.
    end.
    
    return "OK".

end function.

function fnSkipSheet returns char ().
    
    def var iLine       as int no-undo.
    def var iLineStop   as int no-undo.
    DEF VAR i           AS INT NO-UNDO.
    DEF VAR i-control   AS INT NO-UNDO.
    DEF VAR iSkipLines  AS INT NO-UNDO.

    ASSIGN i-control   = iLineCount MODULO 56
           iSkipLines = 56 - i-control.

    ASSIGN i = 0.
    IF i-control < 56 THEN DO:
        REPEAT:
            ASSIGN i = i + 1.
            IF i > (iSkipLines) THEN
                LEAVE. /*RETURN "END-ERROR".*/
            RUN OpenLine.
                RUN MergeColumns(INPUT 7, "" , "Default").
            RUN CloseLine.
        END.
    END.

    ASSIGN iCountPage = iLineCount / 56.

    IF i-control > 0 THEN DO:
        ASSIGN iLine = iLineCount
               iLineStop = iLineCount + 56.
        DO iLine = iLineCount TO (iLineStop):
            ASSIGN iLine = iLine + 1.
            IF iLine MODULO 56 = 0 THEN DO:
                ASSIGN iLineCount = iLine.
                LEAVE.
            END.      
        END.
    END.


    return "OK".

end function.

function fnSkipLine returns char (input pNumberLinesToSkip as int).
    
    def var iLine as int no-undo.

    do iLine = 1 to pNumberLinesToSkip:
        assign iLineCount = iLineCount + 1.
    end.

    return "OK".

end function.

procedure piConvertXMLToXLS:

    /*=================================
      ConversÆo do arquivo XML para XLS
      =================================*/

    def var v-arquivo as char       no-undo.
    def var ch-excel  as office.iface.excel.ExcelWrapper no-undo.   

    if  iLineCount > 65500 then do: /* o Excel ‚ limitado a 65536 linhas */
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-o-relatorio-excel-atingiu-o-li AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "O_relat¢rio_Excel_atingiu_o_limite_de_65.500_linhas" *}
        ASSIGN c-lbl-liter-o-relatorio-excel-atingiu-o-li = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-por-limitacoes-do-microsoft-ex AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Por_limita‡äes_do_Microsoft_Excel_o_relat¢rio_‚_limitado_a" *}
        ASSIGN c-lbl-liter-por-limitacoes-do-microsoft-ex = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-65500-linhas-deste-modo-devera AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "65.500_linhas._Deste_modo,_dever _ser_informada" *}
        ASSIGN c-lbl-liter-65500-linhas-deste-modo-devera = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-uma-faixa-de-selecao-que-limit AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "uma_faixa_de_sele‡Æo_que_limite_a_impressÆo_dos_dados" *}
        ASSIGN c-lbl-liter-uma-faixa-de-selecao-que-limit = TRIM(RETURN-VALUE).
        run utp/ut-msgs.p(input "show",
                          input 17006,
                          input c-lbl-liter-o-relatorio-excel-atingiu-o-li + "~~" +
                                c-lbl-liter-por-limitacoes-do-microsoft-ex + " " +
                                c-lbl-liter-65500-linhas-deste-modo-devera + " " +
                                c-lbl-liter-uma-faixa-de-selecao-que-limit + ".").

        /* elimina arquivo XML */
        os-delete value(tt-param.arquivo).
    end.
    else do:

        /* elimina arquivo XLS */
        assign v-arquivo = replace(tt-param.arquivo, ".xml", ".xls").
        os-delete value(v-arquivo).


        {office/office.i Excel ch-excel}
        assign file-info:file-name = tt-param.arquivo. 

        ch-excel:WorkBooks:open(file-info:file-name,true). 
        ch-excel:sheets:item(1).

        assign file-info:file-name = v-arquivo.

        /* ConversÆo do arquivo .XML para .XLS */
        /* -4143: constante de conversÆo de arquivo .XML para .XLS */
        ch-excel:ActiveWorkbook:SaveAs(file-info:file-name,-4143,"","",no,no,no). 

        ch-excel:ActiveWorkbook:close().

        ch-excel:Workbooks:open(v-arquivo).
        ch-excel:visible = yes.

        DELETE object ch-excel.

        /* elimina arquivo XML */
        os-delete value(tt-param.arquivo).
    end.
   
end procedure.



