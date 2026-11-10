{include/i_dbvers.i}
/* Definição da tt-param */
 
{cdp/cdcfgmnt.i}

.
DEFINE BUFFER bfeqpto FOR mab-eqpto.
DEFINE BUFFER bfmodel FOR mab-model.
DEFINE BUFFER bfmab-trajeto FOR mab-trajeto.

/****************** Defini‡ao de Vari veis de Sele‡Æo de parƒmetros do Relat¢rio *********************/ 
def  var c-yes             as char    no-undo.  
def  var c-no              as char    no-undo.  
 
def  var l-motorizados     as log view-as toggle-box.
def  var l-n-motorizados   as log view-as toggle-box.
def  var l-ativos          as log view-as toggle-box.
def  var l-Inativos        as log view-as toggle-box.
def  var l-proprios        as log view-as toggle-box.
def  var l-terceiros       as log view-as toggle-box.
def  var l-combust         as log view-as toggle-box.
def  var l-caract          as log view-as toggle-box.
def  var l-comptes         as log view-as toggle-box.
def  var l-hist            as log view-as toggle-box.
def  var l-eventos         as log view-as toggle-box.
def  var l-planos          as log view-as toggle-box.
def  var l-config          as log view-as toggle-box.
def  var l-param           as log view-as toggle-box.
def  var l-Insere          as log view-as toggle-box.
def  var l-matriz-un       as log view-as toggle-box.
def  var l-detalha-un      as log view-as toggle-box.
def  var i-cod-emp-ini     like mab-eqpto.ep-codigo                  no-undo.                   
def  var i-cod-emp-fim     like mab-eqpto.ep-codigo                  no-undo.      
def  var c-cod-eqpto-ini   like mab-eqpto.cod-eqpto                  no-undo.     
def  var c-cod-eqpto-fim   like mab-eqpto.cod-eqpto                  no-undo.      
def  var c-grupo-ini       like mab-eqpto.cod-grp-eqpto              no-undo.
def  var c-grupo-fim       like mab-eqpto.cod-grp-eqpto              no-undo.
def  var c-modelo-ini      like mab-eqpto.cod-model                  no-undo.
def  var c-modelo-fim      like mab-eqpto.cod-model                  no-undo.
def  var c-estab-ini       like mab-eqpto.cod-estabel                no-undo.
def  var c-estab-fim       like mab-eqpto.cod-estabel                no-undo.
def  var c-tag-ini         like mab-eqpto.cd-tag                     no-undo.
def  var c-tag-fim         like mab-eqpto.cd-tag                     no-undo.
DEF  VAR i-prop-ini        LIKE mab-eqpto.cod-emitente               NO-UNDO.
DEF  VAR i-prop-fim        LIKE mab-eqpto.cod-emitente               NO-UNDO.
def  var c-estr-mec-ini    like mab-eqpto.cod-estrut-mec             no-undo.
def  var c-estr-mec-fim    like mab-eqpto.cod-estrut-mec             no-undo.
def  var c-ccusto-ini      like mab-eqpto.cc-codigo                  no-undo.
def  var c-ccusto-fim      like mab-eqpto.cc-codigo                  no-undo.
def  var c-sit-ini         like mab-eqpto.cod-sit-eqpto              no-undo.
def  var c-sit-fim         like mab-eqpto.cod-sit-eqpto              no-undo.
def  var i-ano-fab-ini     like mab-eqpto.vli-ano-fabric             no-undo.
def  var i-ano-fab-fim     like mab-eqpto.vli-ano-fabric             no-undo.
DEF  VAR dat-cadastr-ini   LIKE mab-histor-ativid.dat-cadastro       NO-UNDO.
DEF  VAR dat-cadastr-fim   LIKE mab-histor-ativid.dat-cadastro       NO-UNDO.
def  var cSituacao           as char FORMAT "x(10)"                  no-undo.
def  var cAnoModel           as CHAR FORMAT "x(9)"                   no-undo.
def  var cAnoMod-1           as CHAR FORMAT "x(9)"                   no-undo.
DEF VAR cLinha               AS CHAR FORMAT "x(120)"                 NO-UNDO.
DEF VAR cLinha2              AS CHAR FORMAT "x(120)"                 NO-UNDO.
DEF VAR c-des-plano          LIKE mmv-plano-prevent.des-plano        NO-UNDO.
DEF VAR c-cod-unid-negoc-ini AS CHAR FORMAT "x(3)"                   NO-UNDO.
DEF VAR c-cod-unid-negoc-fim AS CHAR FORMAT "x(3)"                   NO-UNDO.
DEF VAR c-liter-un           AS CHAR FORMAT "x(16)"                  NO-UNDO.
DEF VAR cFaixa               AS CHAR FORMAT "x(05)" INITIAL "|< >|"  NO-UNDO.

/************************Defini‡Æo de Vari veis de Layout*************/
 
def  var c-e             as char    FORMAT "x(03)"  no-undo.
def  var c-eqpto         as char    FORMAT "x(16)"  no-undo.
def  var c-desc-model    as char    FORMAT "x(26)"  no-undo.
def  var cEs             as char    FORMAT "x(03)"  no-undo.
def  var c-chassi        as char    FORMAT "x(20)"  no-undo.
def  var c-renavan       as char    FORMAT "x(16)"  no-undo.
def  var c-cod-mod       as char                    no-undo.
def  var cSitEqpto       as char                    no-undo.
def  var c-placa         as char    FORMAT "x(12)"  no-undo.
def  var c-val-hod-hor   as char                    no-undo.
DEF VAR cEstrMec         AS CHAR                    NO-UNDO.
DEF VAR cUN              AS CHAR                    NO-UNDO.

def  var cCombust      as char    FORMAT "x(13)"    no-undo.
def  var cDescricao    as char                      no-undo.
def  var cDataIni      as char                      no-undo.
def  var cCapTaq       as char                      no-undo.
def  var cTpCons       as char    FORMAT "x(11)"    no-undo.
def  var cValCons      as char                      no-undo.         
DEF  VAR cTpConsSec    AS CHAR    FORMAT "x(12)"    NO-UNDO.
DEF  VAR cValConsSec   AS CHAR                      NO-UNDO.
def  var cDtDesativ    as char                      no-undo.
def  var cTipoComb     as char    FORMAT "x(12)"    no-undo.
DEF  VAR cTipoCombSec  AS CHAR    FORMAT "x(12)"    NO-UNDO.

def  var cCodCaract    as char    FORMAT "x(08)"    no-undo.
def  var cDesAbrev     as char                      no-undo.
def  var cDesCaract    as char                      no-undo.
def  var cDesArquivo   as char                      no-undo.

def  var cCompto      as char                       no-undo.
def  var cTpMatrl     as char                       no-undo.
def  var cCapcid      as char                       no-undo.
def  var cRemont      as char                       no-undo.
def  var cEvent       as char                       no-undo.
def  var cPeriodo     as char                       no-undo.

def  var cEstabel     as char    FORMAT "x(30)" no-undo.
def  var cGrupo       as char    FORMAT "x(30)" no-undo.
def  var cData        as char                   no-undo.
def  var cDescEstab   as char                   no-undo.
def  var cDescGrp     as char                   no-undo.
def  var cCusto       as char                   no-undo.
def  var cCtaCont     as char                   no-undo.
def  var cUdeNeg      as char                   no-undo.
def  var cTag         as char                   no-undo.
def  var cAtivid      as char    FORMAT "x(8)"  no-undo.
def  var cAgr         AS CHAR    FORMAT "x(3)"  no-undo.

def  var cEvento     as char    no-undo.
def  var cVencto     as char    no-undo.
def  var cAntecip    as char    no-undo.
def  var cNumParc    as char    no-undo.
def  var cPerValid   as char    no-undo.
def  var cDescEvent  as char    no-undo.
def  var cValidade   as char    no-undo.

def  var cDescPlano      as char FORMAT "x(16)" no-undo.
DEF VAR c-dat-inicial    AS CHAR                NO-UNDO.
DEF VAR c-dat-final      AS CHAR FORMAT "x(10)" NO-UNDO.
DEF VAR c-val-km-inicial AS CHAR                NO-UNDO. 
DEF VAR c-val-km-real    AS CHAR                NO-UNDO. 

def  var cEixo    as char    no-undo.
def  var cTempo   as char    no-undo.
def  var cTracao  as char    no-undo.
def  var cDuplo   as char    no-undo.

DEFINE VARIABLE cTitModelo    AS CHARACTER                 NO-UNDO.
DEFINE VARIABLE cTitGrupo     AS CHARACTER                 NO-UNDO.
DEFINE VARIABLE cTitEstrutMec AS CHARACTER FORMAT "x(20)"  NO-UNDO.
DEFINE VARIABLE cTitEstab     AS CHARACTER FORMAT "x(17)"  NO-UNDO.
DEFINE VARIABLE cTitTag       AS CHARACTER                 NO-UNDO.
DEFINE VARIABLE cTitProp      AS CHARACTER FORMAT "x(17)"  NO-UNDO.
DEFINE VARIABLE cTitCcusto    AS CHARACTER FORMAT "X(20)"  NO-UNDO.
DEFINE VARIABLE cTitUN        AS CHARACTER FORMAT "X(15)"  NO-UNDO.

DEFINE VARIABLE  l-tracao    AS LOGICAL                  NO-UNDO.
DEFINE VARIABLE  l-duplo     AS LOGICAL                  NO-UNDO.
DEFINE VARIABLE  cTipoEqpto  AS CHARACTER FORMAT "x(12)" NO-UNDO.
DEFINE VARIABLE  cTipoProp   AS CHARACTER FORMAT "x(12)" NO-UNDO.
DEFINE VARIABLE  cProp       AS CHARACTER FORMAT "x(9)"  NO-UNDO.
DEFINE VARIABLE  cCodMater   AS CHARACTER                NO-UNDO.
/****************** Defini‡ao de Vari veis p/ Campos Virtuais do Relat¢rio *******************/ 

def  var c-traco-1            as char    no-undo.
def  var h-acomp              as handle  no-undo.
def  var v-cod-destino-impres as char    no-undo.
def  var v-num-reg-lidos      as int     no-undo.
def  var v-num-point          as int     no-undo.
def  var v-num-set            as int     no-undo.
def  var v-num-linha          as int     no-undo.
&IF "{&mguni_version}" >= "2.071" &THEN
def  var i-ep-codigo-usuario  LIKE empresa.ep-codigo     no-undo.
&ELSE
def  var i-ep-codigo-usuario  as int     no-undo.
&ENDIF
def  var l-imprime              as log                       no-undo.
def  var c-traco                as char format "x(76)"       no-undo.
def  var l-primeira             as log                       no-undo.
DEF  VAR c-un-sec               AS CHAR FORMAT "x(02)"       NO-UNDO.
DEF  VAR c-un-sec2              AS CHAR FORMAT "x(02)"       NO-UNDO.
DEF  VAR c-un                   AS CHAR FORMAT "x(02)"       NO-UNDO.
DEF  VAR c-un2                  AS CHAR FORMAT "x(02)"       NO-UNDO.
DEF VAR c-liter-unid-negoc      AS CHAR FORMAT "x(10)":U     NO-UNDO.
DEF VAR c-liter-desc-unid-negoc AS CHAR FORMAT "x(20)":U     NO-UNDO.
DEF VAR c-liter-matriz          AS CHAR FORMAT "x(28)":U     NO-UNDO.
DEF VAR c-liter-desc            AS CHAR FORMAT "x(09)":U     NO-UNDO.
DEF VAR c-liter-perc            AS CHAR FORMAT "x(08)":U     NO-UNDO.
DEF VAR c-liter-matriz-un       AS CHAR FORMAT "x(46)"       NO-UNDO.
DEF VAR c-liter-detalha-un      AS CHAR FORMAT "x(36)"       NO-UNDO.
DEF VAR c-unid-negoc            AS CHAR FORMAT "x(03)":U     NO-UNDO.
DEF VAR c-des-unid-negoc        AS CHAR FORMAT "x(40)"       NO-UNDO.
DEF VAR d-rateio                AS DECIMAL FORMAT ">>9.9999" NO-UNDO.

def temp-table tt-raw-digita
    field raw-digita as raw.

IF l-usa-unid-negoc THEN DO:
    {utp/ut-liter.i "Descri Unid Negoc" r}
    c-liter-desc-unid-negoc = TRIM(RETURN-VALUE).
    {utp/ut-liter.i "Unid_Negoc" r}
    c-liter-unid-negoc = TRIM(RETURN-VALUE).
    {utp/ut-liter.i "Descri‡Æo" r}
    ASSIGN c-liter-desc   = RETURN-VALUE.
    {utp/ut-liter.i "Matriz_de_Unidade_de_Neg¢cio" r}
    ASSIGN c-liter-matriz = TRIM(RETURN-VALUE).
    {utp/ut-liter.i "% Rateio" r}
    ASSIGN c-liter-perc   = TRIM(RETURN-VALUE).
    {utp/ut-liter.i Considera_Matriz_na_Sele‡Æo_Unidade_de_Neg¢cio * r}
    assign c-liter-matriz-un = trim(return-value).
    {utp/ut-liter.i Detalha_Matriz_de_Unidade_de_Neg¢cio * r}
    assign c-liter-detalha-un = trim(return-value).
END.
ELSE 
    ASSIGN c-liter-unid-negoc = "".

FORM SKIP(1)
     "----------------"                     AT 30
     c-liter-matriz                         AT 47
     "----------------"                     AT 76
     c-liter-unid-negoc                     AT 30
     c-liter-desc                           AT 42
     c-liter-perc                           AT 84
     "--------------------------------------------------------------" AT 30
     with width 132 no-labels no-box stream-io frame f-cab-matriz.

form c-unid-negoc     no-label at 37
     c-des-unid-negoc no-label at 42
     d-rateio         no-label at 84
     with width 132 no-labels no-box stream-io frame f-matriz.

FORM cTitModelo
     mab-eqpto.cod-model
     " - "
     mab-model.des-model SKIP(1)
    with  no-box  width 132 NO-LABEL frame f-tit-model stream-io.
     
{utp/ut-liter.i "Modelo: " * R }
assign  cTitModelo = trim(return-value).     


FORM cTitGrupo
     mab-eqpto.cod-grp-eqpto
     " - "
     mab-grp-eqpto.des-grp-eqpto SKIP(1)
    with  no-box  width 132 NO-LABEL frame f-tit-grupo stream-io.
     
{utp/ut-liter.i "Grupo: " * R }
assign  cTitGrupo = trim(return-value). 


FORM cTitEstrutMec
     mab-eqpto.cod-estrut-mec
     " - "
     mab-estrut-mec.des-estrut-mec SKIP(1)
    with  no-box  width 132 NO-LABEL frame f-tit-estrut-mec stream-io.
     
{utp/ut-liter.i "Estrutura Mecƒnica: " * R }
assign  cTitEstrutMec = trim(return-value). 


FORM cTitEstab
     mab-eqpto.cod-estabel
     " - "
     estabelec.nome SKIP(1)
    with  no-box  width 132 NO-LABEL frame f-tit-estabel stream-io.
     
{utp/ut-liter.i "Estabelecimento: " * R }
assign  cTitEstab = trim(return-value). 



FORM cTitTag
     mab-eqpto.cd-tag
     " - "
     tag.descricao SKIP(1)
    with  no-box  width 132 NO-LABEL frame f-tit-tag stream-io.
     
{utp/ut-liter.i "Tag: " * R }
assign  cTitTag = trim(return-value). 

FORM cTitProp
     mab-eqpto.cod-emitente
     " - " 
     emitente.nome-emit SKIP(1)
    with  no-box  width 132 NO-LABEL frame f-tit-prop stream-io.

{utp/ut-liter.i "Propriet rio: " * R }
assign  cTitProp = trim(return-value). 

FORM cTitCcusto
     mab-eqpto.cc-codigo SKIP(1)
    with  no-box  width 200 NO-LABEL frame f-tit-ccusto stream-io.
     
{utp/ut-liter.i "Centro de Custo: " * R }
assign  cTitCcusto = trim(return-value).     

&IF DEFINED(bf_mnt_ems206b) &THEN
    FORM cTitUN
         mab-eqpto.cod-unid-negoc
         " - "
         unid-negoc.des-unid-negoc SKIP(1)
        with  no-box  width 200 NO-LABEL frame f-tit-un stream-io.
         
    {utp/ut-liter.i "Unidade_Neg¢cio " * R }
    assign  cTitUn = trim(return-value).

form mab-eqpto.ep-codigo               AT 14
     " - "                             AT 34
     empresa.nome                      AT 38 NO-LABEL SKIP
     mab-eqpto.cod-eqpto               AT 09
     cTipoEqpto                        AT 88 SKIP
     mab-eqpto.cod-model               AT 15
     " - "                             AT 34
     mab-model.des-model               AT 38 NO-LABEL
     cAnoModel                         AT 89 SKIP
     mab-eqpto.cd-tag                  AT 19
     " - "                             AT 42
     tag.descricao                     AT 53 NO-LABEL SKIP
     mab-eqpto.cc-codigo               at 08
     mab-eqpto.cod-grp-eqpto           AT 02
     " - "
     mab-grp-eqpto.des-grp-eqpto       AT 38 NO-LABEL
     mab-eqpto.dat-compra              AT 90 SKIP
     mab-eqpto.cod-estrut-mec          AT 01
     " - "                             AT 34
     mab-estrut-mec.des-estrut-mec     AT 38 NO-LABEL
     mab-eqpto.val-compra              AT 83 SKIP
     mab-eqpto.cod-sit-eqpto           AT 13            /* Situacao */
     " - "                             AT 34
     mab-sit-eqpto.des-sit-eqpto       AT 38 NO-LABEL
     mab-eqpto.dat-situacao            AT 93 SKIP       /* Data */
     mab-eqpto.cod-estabel             AT 05            /* Estabelecimento */
     " - "                             AT 34
     estabelec.nome                    AT 38 NO-LABEL SKIP
     mab-eqpto.cod-unid-negoc          AT 08 
     " - "                             AT 34
     unid-negoc.des-unid-negoc         AT 38 NO-LABEL SKIP
     mab-eqpto.dat-inicial             AT 80 SKIP
     cTipoProp                         AT 14
     mab-eqpto.val-hodom-horim-inicial AT 78 SKIP
     cProp                             AT 18 
     " - "                             AT 34
     emitente.nome-emit                AT 38 NO-LABEL
     mab-eqpto.cod-renavam             AT 89 SKIP
     mab-eqpto.cod-placa               AT 16
     mab-eqpto.cod-chassi              AT 90 SKIP
     mab-eqpto.bm-codigo               AT 19
     mab-eqpto.bm-indice               AT 37 NO-LABEL
     mab-eqpto.log-cont-sec            AT 75 SKIP
     mab-eqpto.dat-inicial             AT 05            /* Inicio Controle */
     mab-eqpto.val-hodom-horim-sec     AT 66
     c-un-sec                          AT 115 NO-LABEL SKIP
     mab-eqpto.val-hodom-horim-inicial AT 03            /* Contador Inicial */
     c-un                              AT 37 NO-LABEL 
     mab-eqpto.val-km-sec              AT 72 
     c-un-sec2                         AT 115 NO-LABEL SKIP
     mab-eqpto.val-km-inicial          AT 09
     c-un2                             AT 37 NO-LABEL
     with  no-box  width 132 side-labels frame f-eqpto-un stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-eqpto-un:HANDLE).


{utp/ut-liter.i "Chassi/S‚rie" * R }
assign  mab-eqpto.cod-chassi:label in frame f-eqpto-un = trim(return-value).
{utp/ut-liter.i Tipo * R }
assign  cTipoEqpto:label in frame f-eqpto-un = trim(return-value).
{utp/ut-liter.i Tipo_Propriet rio }
assign  cTipoProp:label in frame f-eqpto-un  = trim(return-value).
{utp/ut-liter.i Propriet rio }
assign  cProp:label in frame f-eqpto-un  = trim(return-value).
{utp/ut-liter.i Ano_Fabric./Modelo }
assign  cAnoModel:label in frame f-eqpto-un  = substring(trim(return-value),1,18).
{utp/ut-liter.i Utiliza_Contador_Secund rio }
assign   mab-eqpto.log-cont-sec:label in frame f-eqpto-un  = trim(return-value).
{utp/ut-liter.i Contador_Secund rio_Inicial }
assign   mab-eqpto.val-hodom-horim-sec:label in frame f-eqpto-un  = trim(return-value).
{utp/ut-liter.i Uso_Secund rio_Inicial }
assign   mab-eqpto.val-km-sec:label in frame f-eqpto-un  = trim(return-value).

&ENDIF

form mab-eqpto.ep-codigo               AT 14
     " - "                             AT 34
     empresa.nome                      AT 38 NO-LABEL SKIP
     mab-eqpto.cod-eqpto               AT 09
     cTipoEqpto                        AT 88 SKIP
     mab-eqpto.cod-model               AT 15
     " - "                             AT 34
     mab-model.des-model               AT 38 NO-LABEL
     cAnoModel                         AT 89 SKIP
     mab-eqpto.cd-tag                  AT 19
     " - "                             AT 42
     tag.descricao                     AT 53 NO-LABEL SKIP
     mab-eqpto.cc-codigo               at 08
     mab-eqpto.cod-grp-eqpto           AT 02
     " - "
     mab-grp-eqpto.des-grp-eqpto       AT 38 NO-LABEL
     mab-eqpto.dat-compra              AT 90 SKIP
     mab-eqpto.cod-estrut-mec          AT 01
     " - "                             AT 34
     mab-estrut-mec.des-estrut-mec     AT 38 NO-LABEL
     mab-eqpto.val-compra              AT 83 SKIP
     mab-eqpto.cod-sit-eqpto           AT 13            /* Situacao */
     " - "                             AT 34
     mab-sit-eqpto.des-sit-eqpto       AT 38 NO-LABEL
     mab-eqpto.dat-situacao            AT 93 SKIP       /* Data */
     mab-eqpto.cod-estabel             AT 05            /* Estabelecimento */
     " - "                             AT 34
     estabelec.nome                    AT 38 NO-LABEL
     mab-eqpto.dat-inicial             AT 80 SKIP
     cTipoProp                         AT 14
     mab-eqpto.val-hodom-horim-inicial AT 78 SKIP
     cProp                             AT 18 
     " - "                             AT 34
     emitente.nome-emit                AT 38 NO-LABEL
     mab-eqpto.cod-renavam             AT 89 SKIP
     mab-eqpto.cod-placa               AT 16
     mab-eqpto.cod-chassi              AT 90 SKIP
     mab-eqpto.bm-codigo               AT 19
     mab-eqpto.bm-indice               AT 37 NO-LABEL
     mab-eqpto.log-cont-sec            AT 75 SKIP
     mab-eqpto.dat-inicial             AT 05            /* Inicio Controle */
     mab-eqpto.val-hodom-horim-sec     AT 66
     c-un-sec                          AT 115 NO-LABEL SKIP
     mab-eqpto.val-hodom-horim-inicial AT 03            /* Contador Inicial */
     c-un                              AT 37 NO-LABEL 
     mab-eqpto.val-km-sec              AT 72 
     c-un-sec2                         AT 115 NO-LABEL SKIP
     mab-eqpto.val-km-inicial          AT 09
     c-un2                             AT 37 NO-LABEL
     with  no-box  width 132 side-labels frame f-eqpto stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-eqpto:HANDLE).


{utp/ut-liter.i "Chassi/S‚rie" * R }
assign  mab-eqpto.cod-chassi:label in frame f-eqpto = trim(return-value).
{utp/ut-liter.i Tipo * R }
assign  cTipoEqpto:label in frame f-eqpto = trim(return-value).
{utp/ut-liter.i Tipo_Propriet rio }
assign  cTipoProp:label in frame f-eqpto  = trim(return-value).
{utp/ut-liter.i Propriet rio }
assign  cProp:label in frame f-eqpto  = trim(return-value).
{utp/ut-liter.i Ano_Fabric./Modelo }
assign  cAnoModel:label in frame f-eqpto  = substring(trim(return-value),1,18).
{utp/ut-liter.i Utiliza_Contador_Secund rio }
assign   mab-eqpto.log-cont-sec:label in frame f-eqpto  = trim(return-value).
{utp/ut-liter.i Contador_Secund rio_Inicial }
assign   mab-eqpto.val-hodom-horim-sec:label in frame f-eqpto  = trim(return-value).
{utp/ut-liter.i Uso_Secund rio_Inicial }
assign   mab-eqpto.val-km-sec:label in frame f-eqpto  = trim(return-value).

form mab-eqpto.cod-model           AT 15 
     " - "                         AT 34
     mab-model.des-model           AT 38 NO-LABEL SKIP(2)
     mab-eqpto.ep-codigo           AT 14
     " - "                         AT 34
     empresa.nome                  AT 38 NO-LABEL SKIP
     mab-eqpto.cod-eqpto           AT 09
     cTipoEqpto                    AT 88 SKIP
     mab-eqpto.cd-tag              AT 19               
     " - "                                        
     tag.descricao                 NO-LABEL   
     cAnoModel                     AT 89 SKIP
     mab-eqpto.cod-grp-eqpto       AT 02
     " - "                         AT 34
     mab-grp-eqpto.des-grp-eqpto   AT 38
     mab-eqpto.dat-compra          AT 90 SKIP
     mab-eqpto.cod-estrut-mec      AT 01
     " - "                         AT 34
     mab-estrut-mec.des-estrut-mec AT 38
     mab-eqpto.val-compra          AT 83 SKIP
     mab-eqpto.cod-sit-eqpto       AT 13
     " - "                         AT 34
     mab-sit-eqpto.des-sit-eqpto   AT 38 NO-LABEL
     mab-eqpto.dat-situacao        AT 93 SKIP
     mab-eqpto.cod-estabel         AT 05
     " - "                         AT 34
     estabelec.nome                AT 38 NO-LABEL  
     mab-eqpto.dat-inicial         AT 80 SKIP
     cTipoProp                     AT 14
     mab-eqpto.val-hodom-horim-inicial AT 78 SKIP
     cProp                         AT 18          
     " - "                         AT 39          
     emitente.nome-emit            AT 43 NO-LABEL 
     mab-eqpto.cod-renavam         AT 89
     mab-eqpto.cod-placa           AT 16
     mab-eqpto.cod-chassi          AT 90
     mab-eqpto.bm-codigo           AT 19          
     mab-eqpto.bm-indice           AT 37 NO-LABEL 
     with  no-box  width 132 side-labels frame f-modelo stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-modelo:HANDLE).


{utp/ut-liter.i "Chassi/S‚rie" * R }
assign  mab-eqpto.cod-chassi:label in frame f-modelo = trim(return-value).
{utp/ut-liter.i Tipo * R }
assign  cTipoEqpto:label in frame f-modelo = trim(return-value).
{utp/ut-liter.i Ano_Fabric./Modelo }
assign  cAnoModel:label in frame f-modelo  = substring(trim(return-value),1,18).
{utp/ut-liter.i Tipo_Propriet rio }
assign  cTipoProp:label in frame f-modelo  = trim(return-value).
{utp/ut-liter.i Propriet rio }
assign  cProp:label in frame f-modelo  = trim(return-value).




form  mab-eqpto.cod-grp-eqpto      AT 02                 
     " - "                         AT 34                 
     mab-grp-eqpto.des-grp-eqpto   AT 38 NO-LABEL SKIP(2)
     mab-eqpto.ep-codigo           AT 14               
     " - "                         AT 34               
     empresa.nome                  AT 38 NO-LABEL SKIP 
     mab-eqpto.cod-eqpto           AT 09      
     cTipoEqpto                    AT 88 SKIP 
     mab-eqpto.cod-model           AT 15         
     " - "                         AT 34         
     mab-model.des-model           AT 38 NO-LABEL 
     cAnoModel                     AT 89 SKIP
     mab-eqpto.cd-tag              AT 19   
     " - "                                 
     tag.descricao                 NO-LABEL 
     mab-eqpto.dat-compra          AT 90 SKIP
     mab-eqpto.cod-estrut-mec      AT 01         
     " - "                         AT 34         
     mab-estrut-mec.des-estrut-mec AT 38         
     mab-eqpto.val-compra          AT 83 SKIP    
     mab-eqpto.cod-sit-eqpto       AT 13         
     " - "                         AT 34         
     mab-sit-eqpto.des-sit-eqpto   AT 38 NO-LABEL
     mab-eqpto.dat-situacao        AT 93 SKIP    
     mab-eqpto.cod-estabel         AT 05         
     " - "                         AT 34         
     estabelec.nome                AT 38 NO-LABEL
     mab-eqpto.dat-inicial         AT 80 SKIP    
     cTipoProp                     AT 14       
     mab-eqpto.val-hodom-horim-inicial AT 78 SKIP
     cProp                         AT 18          
     " - "                         AT 34          
     emitente.nome-emit            AT 40 NO-LABEL 
     mab-eqpto.cod-renavam         AT 89          
     mab-eqpto.cod-placa           AT 16          
     mab-eqpto.cod-chassi          AT 90  
     mab-eqpto.bm-codigo           AT 19          
     mab-eqpto.bm-indice           AT 37 NO-LABEL 
     with  no-box  width 132 side-labels frame f-grupo stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-grupo:HANDLE).


{utp/ut-liter.i "Chassi/S‚rie" * R }
assign  mab-eqpto.cod-chassi:label in frame f-grupo = trim(return-value).
{utp/ut-liter.i Tipo * R }
assign  cTipoEqpto:label in frame f-grupo = trim(return-value).
{utp/ut-liter.i Ano_Fabric./Modelo }
assign  cAnoModel:label in frame f-grupo  = substring(trim(return-value),1,18).
{utp/ut-liter.i Tipo_Propriet rio }
assign  cTipoProp:label in frame f-grupo  = trim(return-value).
{utp/ut-liter.i Propriet rio }
assign  cProp:label in frame f-grupo  = trim(return-value).


form  mab-eqpto.cod-estrut-mec     AT 01 
     " - "                         AT 34 
     mab-estrut-mec.des-estrut-mec AT 38 NO-LABEL SKIP(2)
     mab-eqpto.ep-codigo           AT 14              
     " - "                         AT 34              
     empresa.nome                  AT 38 NO-LABEL SKIP
     mab-eqpto.cod-eqpto           AT 09              
     cTipoEqpto                    AT 88 SKIP         
     mab-eqpto.cod-model           AT 15              
     " - "                         AT 34              
     mab-model.des-model           AT 38 NO-LABEL     
     cAnoModel                     AT 89 SKIP         
     mab-eqpto.cod-grp-eqpto       AT 02         
     " - "                         AT 34         
     mab-grp-eqpto.des-grp-eqpto   AT 38 NO-LABEL
     mab-eqpto.val-compra          AT 83 SKIP
     mab-eqpto.cd-tag              AT 19              
     " - "                                            
     tag.descricao                 NO-LABEL  
     mab-eqpto.dat-compra          AT 90 SKIP
     mab-eqpto.cod-sit-eqpto       AT 13              
     " - "                         AT 34              
     mab-sit-eqpto.des-sit-eqpto   AT 38 NO-LABEL     
     mab-eqpto.dat-situacao        AT 93 SKIP         
     mab-eqpto.cod-estabel         AT 05              
     " - "                         AT 34              
     estabelec.nome                AT 38 NO-LABEL     
     mab-eqpto.dat-inicial         AT 80 SKIP         
     cTipoProp                     AT 14             
     mab-eqpto.val-hodom-horim-inicial AT 78 SKIP
     cProp                         AT 18          
     " - "                         AT 39          
     emitente.nome-emit            AT 43 NO-LABEL 
     mab-eqpto.cod-renavam         AT 89         
     mab-eqpto.cod-placa           AT 16         
     mab-eqpto.cod-chassi          AT 90
     mab-eqpto.bm-codigo           AT 19          
     mab-eqpto.bm-indice           AT 37 NO-LABEL 
     with  no-box  width 132 side-labels frame f-estr-mec stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-estr-mec:HANDLE).


{utp/ut-liter.i "Chassi/S‚rie" * R }
assign  mab-eqpto.cod-chassi:label in frame f-estr-mec = trim(return-value).
{utp/ut-liter.i Tipo * R }
assign  cTipoEqpto:label in frame f-estr-mec = trim(return-value).
{utp/ut-liter.i Ano_Fabric./Modelo }
assign  cAnoModel:label in frame f-estr-mec  = substring(trim(return-value),1,18).
{utp/ut-liter.i Tipo_Propriet rio }
assign  cTipoProp:label in frame f-estr-mec  = trim(return-value).
{utp/ut-liter.i Propriet rio }
assign  cProp:label in frame f-estr-mec  = trim(return-value).


form mab-eqpto.cod-estabel         AT 05         
     " - "                         AT 34         
     estabelec.nome                AT 38 NO-LABEL SKIP(2)
     mab-eqpto.ep-codigo           AT 14               
     " - "                         AT 34               
     empresa.nome                  AT 38 NO-LABEL SKIP 
     mab-eqpto.cod-eqpto           AT 09               
     cTipoEqpto                    AT 88 SKIP          
     mab-eqpto.cod-model           AT 15               
     " - "                         AT 34               
     mab-model.des-model           AT 38 NO-LABEL      
     cAnoModel                     AT 89 SKIP          
     mab-eqpto.cd-tag              AT 19    
     " - "                                  
     tag.descricao                 NO-LABEL 
     mab-eqpto.dat-compra          AT 90 SKIP
     mab-eqpto.cod-grp-eqpto       AT 02         
     " - "                         AT 34         
     mab-grp-eqpto.des-grp-eqpto   AT 38 NO-LABEL
     mab-eqpto.dat-inicial         AT 80 SKIP
     mab-eqpto.cod-estrut-mec      AT 01         
     " - "                         AT 34         
     mab-estrut-mec.des-estrut-mec AT 38 NO-LABEL
     mab-eqpto.val-compra          AT 83 SKIP
     mab-eqpto.cod-sit-eqpto       AT 13          
     " - "                         AT 34          
     mab-sit-eqpto.des-sit-eqpto   AT 38 NO-LABEL 
     mab-eqpto.dat-situacao        AT 93 SKIP     
     cTipoProp                     AT 14
     mab-eqpto.val-hodom-horim-inicial AT 78 SKIP
     cProp                         AT 18          
     " - "                         AT 39          
     emitente.nome-emit            AT 43 NO-LABEL  
     mab-eqpto.cod-renavam         AT 89          
     mab-eqpto.cod-placa           AT 16          
     mab-eqpto.cod-chassi          AT 90
     mab-eqpto.bm-codigo           AT 19          
     mab-eqpto.bm-indice           AT 37 NO-LABEL 
     with  no-box  width 132 side-labels frame f-estabel stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-estabel:HANDLE).


{utp/ut-liter.i "Chassi/S‚rie" * R }
assign  mab-eqpto.cod-chassi:label in frame f-estabel = trim(return-value).
{utp/ut-liter.i Tipo * R }
assign  cTipoEqpto:label in frame f-estabel = trim(return-value).
{utp/ut-liter.i Ano_Fabric./Modelo }
assign  cAnoModel:label in frame f-estabel  = substring(trim(return-value),1,18).
{utp/ut-liter.i Tipo_Propriet rio }
assign  cTipoProp:label in frame f-estabel  = trim(return-value).
{utp/ut-liter.i Propriet rio }
assign  cProp:label in frame f-estabel  = trim(return-value).


form mab-eqpto.cd-tag              AT 19          
     " - "                                        
     tag.descricao                 NO-LABEL  SKIP(2)
     mab-eqpto.ep-codigo           AT 14               
     " - "                         AT 34               
     empresa.nome                  AT 38 NO-LABEL SKIP 
     mab-eqpto.cod-eqpto           AT 09               
     cTipoEqpto                    AT 88 SKIP          
     mab-eqpto.cod-model           AT 15               
     " - "                         AT 34               
     mab-model.des-model           AT 38 NO-LABEL      
     cAnoModel                     AT 89 SKIP          
     mab-eqpto.cod-grp-eqpto       AT 02               
     " - "                                             
     mab-grp-eqpto.des-grp-eqpto   AT 38 NO-LABEL      
     mab-eqpto.dat-compra          AT 90 SKIP          
     mab-eqpto.cod-estrut-mec      AT 01               
     " - "                         AT 34               
     mab-estrut-mec.des-estrut-mec AT 38 NO-LABEL      
     mab-eqpto.val-compra          AT 83 SKIP          
     mab-eqpto.cod-sit-eqpto       AT 13               
     " - "                         AT 34               
     mab-sit-eqpto.des-sit-eqpto   AT 38 NO-LABEL      
     mab-eqpto.dat-situacao        AT 93 SKIP          
     mab-eqpto.cod-estabel         AT 05               
     " - "                         AT 34               
     estabelec.nome                AT 38 NO-LABEL      
     mab-eqpto.dat-inicial         AT 80 SKIP          
     cTipoProp                     AT 14              
     mab-eqpto.val-hodom-horim-inicial AT 78 SKIP      
     cProp                         AT 18          
     " - "                         AT 39          
     emitente.nome-emit            AT 43 NO-LABEL      
     mab-eqpto.cod-renavam         AT 89               
     mab-eqpto.cod-placa           AT 16               
     mab-eqpto.cod-chassi          AT 90
     mab-eqpto.bm-codigo           AT 19          
     mab-eqpto.bm-indice           AT 37 NO-LABEL 
     with  no-box  width 132 side-labels frame f-tag stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-tag:HANDLE).


{utp/ut-liter.i "Chassi/S‚rie" * R }
assign  mab-eqpto.cod-chassi:label in frame f-tag = trim(return-value).
{utp/ut-liter.i Tipo * R }
assign  cTipoEqpto:label in frame f-tag = trim(return-value).
{utp/ut-liter.i Ano_Fabric./Modelo }
assign  cAnoModel:label in frame f-tag  = substring(trim(return-value),1,18).
{utp/ut-liter.i Tipo_Propriet rio }
assign  cTipoProp:label in frame f-tag  = trim(return-value).
{utp/ut-liter.i Propriet rio }
assign  cProp:label in frame f-tag  = trim(return-value).


form mab-eqpto.cc-codigo           AT 30
     " - "                         AT 34
     centro-custo.descricao        AT 35 NO-LABEL SKIP(2)
     mab-eqpto.cod-model           AT 15 
     " - "                         AT 34
     mab-model.des-model           AT 38 NO-LABEL SKIP
     mab-eqpto.ep-codigo           AT 14
     " - "                         AT 34
     empresa.nome                  AT 38 SKIP
     mab-eqpto.cod-eqpto           AT 09
     cTipoEqpto                    AT 88 SKIP
     mab-eqpto.cd-tag              AT 19               
     " - "                                        
     tag.descricao                 NO-LABEL   
     cAnoModel                     AT 89 SKIP
     mab-eqpto.cod-grp-eqpto       AT 02
     " - "                         AT 34
     mab-grp-eqpto.des-grp-eqpto   AT 38
     mab-eqpto.dat-compra          AT 90 SKIP
     mab-eqpto.cod-estrut-mec      AT 01
     " - "                         AT 34
     mab-estrut-mec.des-estrut-mec AT 38
     mab-eqpto.val-compra          AT 83 SKIP
     mab-eqpto.cod-sit-eqpto       AT 13
     " - "                         AT 34
     mab-sit-eqpto.des-sit-eqpto   AT 38 NO-LABEL
     mab-eqpto.dat-situacao        AT 93 SKIP
     mab-eqpto.cod-estabel         AT 05
     " - "                         AT 34
     estabelec.nome                AT 38 NO-LABEL  
     mab-eqpto.dat-inicial         AT 80 SKIP
     cTipoProp                     AT 14
     mab-eqpto.val-hodom-horim-inicial AT 78 SKIP
     cProp                         AT 18          
     " - "                         AT 39          
     emitente.nome-emit            AT 43 NO-LABEL 
     mab-eqpto.cod-renavam         AT 89
     mab-eqpto.cod-placa           AT 16
     mab-eqpto.cod-chassi          AT 90
     mab-eqpto.bm-codigo           AT 19          
     mab-eqpto.bm-indice           AT 37 NO-LABEL 
     with  no-box  width 132 side-labels frame f-modelo stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-modelo:HANDLE).


{utp/ut-liter.i "Chassi/S‚rie" * R }
assign  mab-eqpto.cod-chassi:label in frame f-modelo = trim(return-value).
{utp/ut-liter.i Tipo * R }
assign  cTipoEqpto:label in frame f-modelo = trim(return-value).
{utp/ut-liter.i Ano_Fabric./Modelo }
assign  cAnoModel:label in frame f-modelo  = substring(trim(return-value),1,18).
{utp/ut-liter.i Tipo_Propriet rio }
assign  cTipoProp:label in frame f-modelo  = trim(return-value).
{utp/ut-liter.i Propriet rio }
assign  cProp:label in frame f-modelo  = trim(return-value).

/** Frame By Equipamento **/
form  c-e              AT 01  FORMAT "x(03)"
      c-eqpto          AT 05
      c-cod-mod        AT 22
&IF "{&mguni_version}" >= "2.071" &THEN
      c-desc-model     AT 31  FORMAT "x(24)"
      cEs              AT 56  FORMAT "x(05)"
&else
      c-desc-model     AT 31  FORMAT "x(26)"
      cEs              AT 58  FORMAT "x(03)"
&endif
      c-chassi         AT 62  FORMAT "x(20)"  
      cAnoMod-1        AT 83  FORMAT "x(9)"
      cSitEqpto        AT 93  FORMAT "x(10)"
      c-placa          AT 104 FORMAT "x(12)" 
      c-Renavan        AT 117 FORMAT "x(16)" 
      with NO-BOX page-top  width 132 frame f-cab-resumido stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-cab-resumido:HANDLE).


form mab-eqpto.ep-codigo        
     mab-eqpto.cod-eqpto   AT 05 
     mab-eqpto.cod-model   AT 22 
&IF "{&mguni_version}" >= "2.071" &THEN
     mab-model.des-model   AT 31  FORMAT "x(24)"
&ELSE
     mab-model.des-model   AT 31  FORMAT "x(26)"
&ENDIF
&IF "{&mguni_version}" >= "2.071" &THEN
     mab-eqpto.cod-estabel AT 56  format "x(05)"
&ELSE
     mab-eqpto.cod-estabel AT 58  FORMAT "x(03)"
&ENDIF
     mab-eqpto.cod-chassi  AT 62  FORMAT "x(20)"
     cAnoModel             AT 83  FORMAT "x(9)"
     cSituacao             AT 93  FORMAT "x(10)"
     mab-eqpto.cod-placa   AT 104 FORMAT "x(12)"
     mab-eqpto.cod-renavam AT 117 FORMAT "x(16)"
     with  NO-LABEL down no-box width 132 frame f-resumido STREAM-IO.

/** Frame By Model **/

DO:
form  c-cod-mod                 FORMAT "x(08)" 
&IF "{&mguni_version}" >= "2.071" &THEN
      c-desc-model       AT 10  FORMAT "x(24)"
      c-e                AT 35  FORMAT "x(03)"
      c-eqpto            AT 39  FORMAT "x(16)"
      cEs                AT 56  FORMAT "x(05)"
&else
      c-desc-model       AT 10  FORMAT "x(26)"
      c-e                AT 37  FORMAT "x(03)"
      c-eqpto            AT 41  FORMAT "x(16)"
      cEs                AT 58  FORMAT "x(03)"
&endif
      c-chassi           AT 62  FORMAT "x(20)"  
      cAnoMod-1          AT 83  FORMAT "x(9)"
      cSitEqpto          AT 93  FORMAT "x(10)"
      c-placa            AT 104 FORMAT "x(12)" 
      c-Renavan          AT 117 FORMAT "x(16)"
      with NO-BOX TOP-ONLY  width 132 frame f-cab-resumido-model stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-cab-resumido-model:HANDLE).

END. 

form mab-eqpto.cod-model             FORMAT "x(08)"
&IF "{&mguni_version}" >= "2.071" &THEN
     mab-model.des-model     AT 10   FORMAT "x(24)"
&ELSE
     mab-model.des-model     AT 10   FORMAT "x(26)"
&ENDIF
&IF "{&mguni_version}" >= "2.071" &THEN
     mab-eqpto.ep-codigo     AT 35   format "x(03)"
&ELSE
     mab-eqpto.ep-codigo     AT 37   FORMAT ">>9"
&ENDIF
&IF "{&mguni_version}" >= "2.071" &THEN
     mab-eqpto.cod-eqpto     AT 39   
&ELSE
     mab-eqpto.cod-eqpto     AT 41   
&ENDIF     
&IF "{&mguni_version}" >= "2.071" &THEN
     mab-eqpto.cod-estabel   AT 56   format "x(05)"
&ELSE
     mab-eqpto.cod-estabel   AT 58   FORMAT "x(03)"
&ENDIF
     mab-eqpto.cod-chassi    AT 62   FORMAT "x(20)"
     cAnoModel               AT 83   FORMAT "x(9)"
     cSituacao               AT 93   FORMAT "x(10)"       
     mab-eqpto.cod-placa     AT 104  FORMAT "x(12)"
     mab-eqpto.cod-renavam   AT 117  FORMAT "x(16)"
     with  NO-LABEL down no-box width 132 frame f-resumido-model STREAM-IO.


/** Frame By Grupo Equipamento **/
DO:
form  cGrupo                    FORMAT "x(08)"
      c-e                AT 10 
      c-eqpto            AT 14 
&IF "{&mguni_version}" >= "2.071" &THEN
      c-desc-model       AT 31  FORMAT "x(24)"
      cEs                AT 56  FORMAT "x(05)"
&else
      c-desc-model       AT 31  FORMAT "x(26)"
      cEs                AT 58  FORMAT "x(03)"
&endif
      c-chassi           AT 62  FORMAT "x(20)"  
      cAnoMod-1          AT 83  FORMAT "x(9)"
      cSitEqpto          AT 93  FORMAT "x(10)"
      c-placa            AT 103 FORMAT "x(12)" 
      c-Renavan          AT 116 FORMAT "x(16)"
      with NO-BOX TOP-ONLY  width 132 frame f-cab-resumido-grupo stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-cab-resumido-grupo:HANDLE).

END. 

form mab-eqpto.cod-grp-eqpto 
&IF "{&mguni_version}" >= "2.071" &THEN
     mab-eqpto.ep-codigo   AT 10  format "x(03)"
&ELSE
     mab-eqpto.ep-codigo   AT 10  format ">>9"
&ENDIF
     mab-eqpto.cod-eqpto   AT 14 
&IF "{&mguni_version}" >= "2.071" &THEN
     mab-model.des-model   AT 31  FORMAT "x(24)"
&ELSE
     mab-model.des-model   AT 31  FORMAT "x(26)"
&ENDIF
&IF "{&mguni_version}" >= "2.071" &THEN
     mab-eqpto.cod-estabel AT 56  format "x(05)"
&ELSE
     mab-eqpto.cod-estabel AT 58  FORMAT "x(03)"
&ENDIF
     mab-eqpto.cod-chassi  AT 62  FORMAT "x(20)"
     cAnoModel             AT 83  FORMAT "x(9)"
     cSituacao             AT 93  FORMAT "x(10)"
     mab-eqpto.cod-placa   AT 103 FORMAT "x(12)"
     mab-eqpto.cod-renavam AT 116 FORMAT "x(16)"
     with  NO-LABEL down no-box width 132 frame f-resumido-grupo STREAM-IO.


/** Frame By Estrutura mecƒnica **/
DO:
form  cEstrMec                  FORMAT "x(08)"
      c-e                AT 10
      c-eqpto            AT 14
&IF "{&mguni_version}" >= "2.071" &THEN
      c-desc-model       AT 31  FORMAT "x(24)"
      cEs                AT 56  FORMAT "x(05)"
&else
      c-desc-model       AT 31  FORMAT "x(26)"
      cEs                AT 58  FORMAT "x(03)"
&endif
      c-chassi           AT 62  FORMAT "x(20)"  
      cAnoMod-1          AT 83  FORMAT "x(9)"
      cSitEqpto          AT 93  FORMAT "x(10)"
      c-placa            AT 103 FORMAT "x(12)" 
      c-Renavan          AT 116 FORMAT "x(16)"
      with NO-BOX TOP-ONLY  width 132 frame f-cab-resumido-estrutura stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-cab-resumido-estrutura:HANDLE).

END. 

FORM mab-eqpto.cod-estrut-mec      FORMAT "x(08)"
&IF "{&mguni_version}" >= "2.071" &THEN
     mab-eqpto.ep-codigo   AT 10   format "x(03)"
&ELSE
     mab-eqpto.ep-codigo   AT 10   FORMAT ">>9"
&ENDIF
     mab-eqpto.cod-eqpto   AT 14  
&IF "{&mguni_version}" >= "2.071" &THEN
     mab-model.des-model   AT 31   FORMAT "x(24)"
&ELSE
     mab-model.des-model   AT 31   FORMAT "x(26)"
&ENDIF
&IF "{&mguni_version}" >= "2.071" &THEN
     mab-eqpto.cod-estabel AT 56   format "x(05)"
&ELSE
     mab-eqpto.cod-estabel AT 58   FORMAT "x(03)"
&ENDIF
     mab-eqpto.cod-chassi  AT 62   FORMAT "x(20)"
     cAnoModel             AT 83   FORMAT "x(9)"
     cSituacao             AT 93   FORMAT "x(10)"
     mab-eqpto.cod-placa   AT 103  FORMAT "x(12)"
     mab-eqpto.cod-renavam AT 116  FORMAT "x(16)"
     with  NO-LABEL down no-box width 132 frame f-resumido-estrutura STREAM-IO.


/** Frame By Estabelecimento **/
DO:
form  
&IF "{&mguni_version}" >= "2.071" &THEN
      cEs                      FORMAT "x(05)"
      c-e                AT 07 
      c-eqpto            AT 11 
      c-desc-model       AT 28  FORMAT "x(31)"
&else
      cEs                      FORMAT "x(03)"
      c-e                AT 05 
      c-eqpto            AT 09 
      c-desc-model       AT 26  FORMAT "x(33)"
&endif
      c-chassi           AT 60  FORMAT "x(20)"  
      cAnoMod-1          AT 81  FORMAT "x(9)"
      cSitEqpto          AT 93  FORMAT "x(10)"
      c-placa            AT 104 FORMAT "x(12)"
      c-Renavan          AT 117 FORMAT "x(16)"
      with NO-BOX TOP-ONLY  width 132 frame f-cab-resumido-estabel stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-cab-resumido-estabel:HANDLE).

END. 

form
&IF "{&mguni_version}" >= "2.071" &THEN
     mab-eqpto.cod-estabel
     mab-eqpto.ep-codigo   AT 07  format "x(03)"
     mab-eqpto.cod-eqpto   AT 11  
     mab-model.des-model   AT 28  FORMAT "x(31)"
&ELSE
     mab-eqpto.cod-estabel
     mab-eqpto.ep-codigo   AT 05  FORMAT ">>9"
     mab-eqpto.cod-eqpto   AT 09  
     mab-model.des-model   AT 26  FORMAT "x(33)"
&ENDIF
     mab-eqpto.cod-chassi  AT 60  FORMAT "x(20)"
     cAnoModel             AT 81  FORMAT "x(9)"
     cSituacao             AT 93  FORMAT "x(10)"
     mab-eqpto.cod-placa   AT 104 FORMAT "x(12)"
     mab-eqpto.cod-renavam AT 117 FORMAT "x(16)"
     with  NO-LABEL down no-box width 132 frame f-resumido-estabel STREAM-IO.



/** Frame By Tag **/
DO:
form  cTag                      FORMAT "x(12)"
      c-e                AT 14  
      c-eqpto            AT 18  
&IF "{&mguni_version}" >= "2.071" &THEN
      c-desc-model       AT 35  FORMAT "x(21)"
      cEs                AT 57  FORMAT "x(05)"
&ELSE
      c-desc-model       AT 35  FORMAT "x(23)"
      cEs                AT 59  FORMAT "x(03)"
&ENDIF
      c-chassi           AT 63  FORMAT "x(20)"  
      cAnoMod-1          AT 84  FORMAT "x(9)"
      cSitEqpto          AT 94  FORMAT "x(10)"
      c-placa            AT 104 FORMAT "x(12)"
      c-Renavan          AT 117 FORMAT "x(16)"
      with NO-BOX TOP-ONLY  width 132 frame f-cab-resumido-tag stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-cab-resumido-tag:HANDLE).

END. 

form mab-eqpto.cd-tag             FORMAT "x(12)"
&IF "{&mguni_version}" >= "2.071" &THEN
     mab-eqpto.ep-codigo   AT 14  format "x(03)"
&ELSE
     mab-eqpto.ep-codigo   AT 14  FORMAT ">>9"
&ENDIF
     mab-eqpto.cod-eqpto   AT 18  
&IF "{&mguni_version}" >= "2.071" &THEN
     mab-model.des-model   AT 35  FORMAT "x(21)"
&ELSE
     mab-model.des-model   AT 35  FORMAT "x(23)"
&ENDIF
&IF "{&mguni_version}" >= "2.071" &THEN
     mab-eqpto.cod-estabel AT 57  format "x(05)"
&ELSE
     mab-eqpto.cod-estabel AT 59  FORMAT "x(03)"
&ENDIF
     mab-eqpto.cod-chassi  AT 63  FORMAT "x(20)"
     cAnoModel             AT 84  FORMAT "x(9)"
     cSituacao             AT 94  FORMAT "x(10)"
     mab-eqpto.cod-placa   AT 104 FORMAT "x(12)"
     mab-eqpto.cod-renavam AT 117 FORMAT "x(16)"
     with  NO-LABEL down no-box width 132 frame f-resumido-tag STREAM-IO.

/** Frame By Proprietÿrio **/
DO:
form  cProp                     FORMAT "x(12)"
      c-e                AT 14
      c-eqpto            AT 18
&IF "{&mguni_version}" >= "2.071" &THEN
      c-desc-model       AT 35  FORMAT "x(21)"
      cEs                AT 57  FORMAT "x(05)"
&ELSE
      c-desc-model       AT 35  FORMAT "x(23)"
      cEs                AT 59  FORMAT "x(03)"
&ENDIF
      c-chassi           AT 63  FORMAT "x(20)"
      cAnoMod-1          AT 84  FORMAT "x(9)"
      cSitEqpto          AT 94  FORMAT "x(10)"
      c-placa            AT 104 FORMAT "x(12)"
      c-Renavan          AT 117 FORMAT "x(16)"
      with NO-BOX TOP-ONLY  width 132 frame f-cab-resumido-prop stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-cab-resumido-prop:HANDLE).

END. 

form mab-eqpto.cod-emitente       FORMAT ">>>>>>>>9"
&IF "{&mguni_version}" >= "2.071" &THEN
     mab-eqpto.ep-codigo   AT 14  format "x(03)"
&ELSE
     mab-eqpto.ep-codigo   AT 14  FORMAT ">>9"
&ENDIF
     mab-eqpto.cod-eqpto   AT 18
&IF "{&mguni_version}" >= "2.071" &THEN
     mab-model.des-model   AT 35  FORMAT "x(21)"
&ELSE
     mab-model.des-model   AT 35  FORMAT "x(23)"
&ENDIF
&IF "{&mguni_version}" >= "2.071" &THEN
     mab-eqpto.cod-estabel AT 57  format "x(05)"
&ELSE
     mab-eqpto.cod-estabel AT 59  FORMAT "x(03)"
&ENDIF
     mab-eqpto.cod-chassi  AT 63  FORMAT "x(20)"
     cAnoModel             AT 84  FORMAT "x(9)"
     cSituacao             AT 94  FORMAT "x(10)"
     mab-eqpto.cod-placa   AT 104 FORMAT "x(12)"
     mab-eqpto.cod-renavam AT 117 FORMAT "x(16)"
     with  NO-LABEL down no-box width 132 frame f-resumido-prop STREAM-IO.

/***** Frame By Centro de Custo *****/

DO:
form  Ccusto                    FORMAT "x(20)"
      c-e                AT 14
      c-eqpto            AT 18
&IF "{&mguni_version}" >= "2.071" &THEN
      c-desc-model       AT 35  FORMAT "x(21)"
      cEs                AT 57  FORMAT "x(05)"
&ELSE
      c-desc-model       AT 35  FORMAT "x(23)"
      cEs                AT 59  FORMAT "x(03)"
&ENDIF
      c-chassi           AT 63  FORMAT "x(20)"
      cAnoMod-1          AT 84  FORMAT "x(9)"
      cSitEqpto          AT 94  FORMAT "x(10)"
      c-placa            AT 104 FORMAT "x(12)"
      c-Renavan          AT 117 FORMAT "x(16)"
      with NO-BOX TOP-ONLY  width 132 frame f-cab-resumido-ccusto stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-cab-resumido-ccusto:HANDLE).

END. 

form mab-eqpto.cc-codigo          FORMAT "x(20)"
&IF "{&mguni_version}" >= "2.071" &THEN
     mab-eqpto.ep-codigo   AT 14  format "x(03)"
&ELSE
     mab-eqpto.ep-codigo   AT 14  FORMAT ">>9"
&ENDIF
     mab-eqpto.cod-eqpto   AT 18
&IF "{&mguni_version}" >= "2.071" &THEN
     mab-model.des-model   AT 35  FORMAT "x(21)"
&ELSE
     mab-model.des-model   AT 35  FORMAT "x(23)"
&ENDIF
&IF "{&mguni_version}" >= "2.071" &THEN
     mab-eqpto.cod-estabel AT 57  format "x(05)"
&ELSE
     mab-eqpto.cod-estabel AT 59  FORMAT "x(03)"
&ENDIF
     mab-eqpto.cod-chassi  AT 63  FORMAT "x(20)"
     cAnoModel             AT 84  FORMAT "x(9)"
     cSituacao             AT 94  FORMAT "x(10)"
     mab-eqpto.cod-placa   AT 104 FORMAT "x(12)"
     mab-eqpto.cod-renavam AT 117 FORMAT "x(16)"
     with  NO-LABEL down no-box width 132 frame f-resumido-ccusto STREAM-IO.

/***** Frame By Unidade Neg¢cio *****/
DO:
form  cUdeNeg                    FORMAT "x(10)"
      c-e                AT 14
      c-eqpto            AT 18
&IF "{&mguni_version}" >= "2.071" &THEN
      c-desc-model       AT 35  FORMAT "x(21)"
      cEs                AT 57  FORMAT "x(05)"
&ELSE
      c-desc-model       AT 35  FORMAT "x(23)"
      cEs                AT 59  FORMAT "x(03)"
&ENDIF
      c-chassi           AT 63  FORMAT "x(20)"
      cAnoMod-1          AT 84  FORMAT "x(9)"
      cSitEqpto          AT 94  FORMAT "x(10)"
      c-placa            AT 104 FORMAT "x(12)"
      c-Renavan          AT 117 FORMAT "x(16)"
      with NO-BOX TOP-ONLY  width 132 frame f-cab-resumido-un stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-cab-resumido-un:HANDLE).

END. 

form 
&IF DEFINED(bf_mnt_ems206b) &THEN
    mab-eqpto.cod-unid-negoc          FORMAT "x(03)"
&ENDIF
&IF "{&mguni_version}" >= "2.071" &THEN
     mab-eqpto.ep-codigo   AT 14  format "x(03)"
&ELSE
     mab-eqpto.ep-codigo   AT 14  FORMAT ">>9"
&ENDIF
     mab-eqpto.cod-eqpto   AT 18
&IF "{&mguni_version}" >= "2.071" &THEN
     mab-model.des-model   AT 35  FORMAT "x(21)"
&ELSE
     mab-model.des-model   AT 35  FORMAT "x(23)"
&ENDIF
&IF "{&mguni_version}" >= "2.071" &THEN
     mab-eqpto.cod-estabel AT 57  format "x(05)"
&ELSE
     mab-eqpto.cod-estabel AT 59  FORMAT "x(03)"
&ENDIF
     mab-eqpto.cod-chassi  AT 63  FORMAT "x(20)"
     cAnoModel             AT 84  FORMAT "x(9)"
     cSituacao             AT 94  FORMAT "x(10)"
     mab-eqpto.cod-placa   AT 104 FORMAT "x(12)"
     mab-eqpto.cod-renavam AT 117 FORMAT "x(16)"
     with  NO-LABEL down no-box width 132 frame f-resumido-un STREAM-IO.

{utp/ut-liter.i Emp * R }
assign  c-e:label in frame f-cab-resumido           = trim(return-value).
assign  c-e:label in frame f-cab-resumido-model     = trim(return-value).
assign  c-e:label in frame f-cab-resumido-grupo     = trim(return-value).
assign  c-e:label in frame f-cab-resumido-estabel   = trim(return-value).
assign  c-e:label in frame f-cab-resumido-estrutura = trim(return-value).
assign  c-e:label in frame f-cab-resumido-tag       = trim(return-value).
assign  c-e:label in frame f-cab-resumido-prop      = trim(return-value).
assign  c-e:label in frame f-cab-resumido-un        = trim(return-value).

{utp/ut-liter.i Equipamento * R }
assign  c-eqpto:label in frame f-cab-resumido           = trim(return-value).
assign  c-eqpto:label in frame f-cab-resumido-model     = trim(return-value).
assign  c-eqpto:label in frame f-cab-resumido-grupo     = trim(return-value).
assign  c-eqpto:label in frame f-cab-resumido-estabel   = trim(return-value).
assign  c-eqpto:label in frame f-cab-resumido-estrutura = trim(return-value).
assign  c-eqpto:label in frame f-cab-resumido-tag       = trim(return-value).
assign  c-eqpto:label in frame f-cab-resumido-prop      = trim(return-value).
assign  c-eqpto:label in frame f-cab-resumido-un        = trim(return-value).

{utp/ut-liter.i Modelo * R }
assign  c-cod-mod:label IN FRAME f-cab-resumido           = trim(return-value).
assign  c-cod-mod:label IN FRAME f-cab-resumido-model     = trim(return-value).
/* assign  c-cod-mod:label IN FRAME f-cab-resumido-grupo     = trim(return-value). */
/* assign  c-cod-mod:label IN FRAME f-cab-resumido-estabel   = trim(return-value). */
/* assign  c-cod-mod:label IN FRAME f-cab-resumido-estrutura = trim(return-value). */
/* assign  c-cod-mod:label IN FRAME f-cab-resumido-tag       = trim(return-value). */

{utp/ut-liter.i Descri‡Æo * R }
assign  c-desc-model:label in frame f-cab-resumido           = trim(return-value).
assign  c-desc-model:label in frame f-cab-resumido-model     = trim(return-value).
assign  c-desc-model:label in frame f-cab-resumido-grupo     = trim(return-value).
assign  c-desc-model:label in frame f-cab-resumido-estabel   = trim(return-value).
assign  c-desc-model:label in frame f-cab-resumido-estrutura = trim(return-value).
assign  c-desc-model:label in frame f-cab-resumido-tag       = trim(return-value).
assign  c-desc-model:label in frame f-cab-resumido-prop      = trim(return-value).
assign  c-desc-model:label in frame f-cab-resumido-un        = trim(return-value).

{utp/ut-liter.i Est * R }
assign  cEs:label in frame f-cab-resumido           = trim(return-value).
assign  cEs:label in frame f-cab-resumido-model     = trim(return-value).
assign  cEs:label in frame f-cab-resumido-grupo     = trim(return-value).
assign  cEs:label in frame f-cab-resumido-estabel   = trim(return-value).
assign  cEs:label in frame f-cab-resumido-estrutura = trim(return-value).
assign  cEs:label in frame f-cab-resumido-tag       = trim(return-value).
assign  cEs:label in frame f-cab-resumido-prop      = trim(return-value).
assign  cEs:label in frame f-cab-resumido-un        = trim(return-value).

{utp/ut-liter.i "Chassi/S‚rie" * R }
assign  c-chassi:label in frame f-cab-resumido           = trim(return-value).
assign  c-chassi:label in frame f-cab-resumido-model     = trim(return-value).
assign  c-chassi:label in frame f-cab-resumido-grupo     = trim(return-value).
assign  c-chassi:label in frame f-cab-resumido-estabel   = trim(return-value).
assign  c-chassi:label in frame f-cab-resumido-estrutura = trim(return-value).
assign  c-chassi:label in frame f-cab-resumido-tag       = trim(return-value).
assign  c-chassi:label in frame f-cab-resumido-prop      = trim(return-value).
assign  c-chassi:label in frame f-cab-resumido-un        = trim(return-value).

{utp/ut-liter.i Fab./Mod. }
assign  cAnoMod-1:label in frame f-cab-resumido            = substring(trim(return-value),1,9).
assign  cAnoMod-1:label in frame f-cab-resumido-model      = substring(trim(return-value),1,9).
assign  cAnoMod-1:label in frame f-cab-resumido-grupo      = substring(trim(return-value),1,9).
assign  cAnoMod-1:label in frame f-cab-resumido-estabel    = substring(trim(return-value),1,9).
assign  cAnoMod-1:label in frame f-cab-resumido-estrutura  = substring(trim(return-value),1,9).
assign  cAnoMod-1:label in frame f-cab-resumido-tag        = substring(trim(return-value),1,9).
assign  cAnoMod-1:label in frame f-cab-resumido-prop       = substring(trim(return-value),1,9).
assign  cAnoMod-1:label in frame f-cab-resumido-un         = substring(trim(return-value),1,9).

{utp/ut-liter.i Situa‡Æo * R }
assign  cSitEqpto:label in frame f-cab-resumido           = trim(return-value).
assign  cSitEqpto:label in frame f-cab-resumido-model     = trim(return-value).
assign  cSitEqpto:label in frame f-cab-resumido-grupo     = trim(return-value).
assign  cSitEqpto:label in frame f-cab-resumido-estabel   = trim(return-value).
assign  cSitEqpto:label in frame f-cab-resumido-estrutura = trim(return-value).
assign  cSitEqpto:label in frame f-cab-resumido-tag       = trim(return-value).
assign  cSitEqpto:label in frame f-cab-resumido-prop      = trim(return-value).
assign  cSitEqpto:label in frame f-cab-resumido-un        = trim(return-value).

{utp/ut-liter.i Placa * R }
assign  c-placa:label in frame f-cab-resumido           = trim(return-value).
assign  c-placa:label in frame f-cab-resumido-model     = trim(return-value).
assign  c-placa:label in frame f-cab-resumido-grupo     = trim(return-value).
assign  c-placa:label in frame f-cab-resumido-estabel   = trim(return-value).
assign  c-placa:label in frame f-cab-resumido-estrutura = trim(return-value).
assign  c-placa:label in frame f-cab-resumido-tag       = trim(return-value).
assign  c-placa:label in frame f-cab-resumido-prop      = trim(return-value).
assign  c-placa:label in frame f-cab-resumido-un        = trim(return-value).

{utp/ut-liter.i Renavan * R }
assign  c-renavan:label in frame f-cab-resumido           = trim(return-value).
assign  c-renavan:label in frame f-cab-resumido-model     = trim(return-value).
assign  c-renavan:label in frame f-cab-resumido-grupo     = trim(return-value).
assign  c-renavan:label in frame f-cab-resumido-estabel   = trim(return-value).
assign  c-renavan:label in frame f-cab-resumido-estrutura = trim(return-value).
assign  c-renavan:label in frame f-cab-resumido-tag       = trim(return-value).
assign  c-renavan:label in frame f-cab-resumido-prop      = trim(return-value).
assign  c-renavan:label in frame f-cab-resumido-un        = trim(return-value).

{utp/ut-liter.i Grupo * R }
assign  cGrupo:label in frame f-cab-resumido-grupo      = trim(return-value).

{utp/ut-liter.i Estr_Mec * R }
ASSIGN cEstrMec:label in frame f-cab-resumido-estrutura = trim(return-value).

{utp/ut-liter.i Est * R }
ASSIGN cEs:label in frame f-cab-resumido-estabel        = trim(return-value).

{utp/ut-liter.i Tag * R }
ASSIGN cTag:label in frame f-cab-resumido-tag           = trim(return-value).

{utp/ut-liter.i Propriet rio * R }
ASSIGN cProp:label in frame f-cab-resumido-prop         = trim(return-value).

{utp/ut-liter.i Unid_Negoc * R }
ASSIGN cUdeNeg:label in frame f-cab-resumido-un         = trim(return-value).

FORM  mab-histor-combust.dat-inicial      AT 01
      cCodMater                           AT 14
      mab-tip-mater.des-tip-mater         AT 29  
      mab-histor-combust.val-capac-tanque AT 63  FORMAT "zzzz9.9"
      cTipoComb                           AT 71
      mab-histor-combust.val-consu-padr   AT 90  FORMAT "zzzzz9.99"
      cTipoCombSec                        at 95
      mab-histor-combust.val-livre-1      at 111 format "zzzzzz9.99"
      mab-histor-combust.dat-desativ      AT 115
     with NO-LABEL no-box  width 132 side-labels frame f-relatorio-combustivel stream-io.

form  cDataIni           AT 01  FORMAT "X(10)"
      cCombust           AT 14
      cDescricao         AT 29  FORMAT "X(30)"
      cCapTaq            AT 60  FORMAT "x(10)"
      cTpCons            AT 71  FORMAT "x(12)"
      cValCons           AT 86  FORMAT "x(13)"
      cTpConsSec         AT 95  FORMAT "x(12)"
      cValConsSec        AT 108 FORMAT "x(13)"
      cDtDesativ         AT 115 FORMAT "x(13)"
      with no-box  width 132 frame f-cab-combustivel stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-cab-combustivel:HANDLE).



{utp/ut-liter.i Combust¡vel * R }
assign  cCombust:label in frame f-cab-combustivel = trim(return-value).
{utp/ut-liter.i Descri‡Æo * R }
assign  cDescricao:label in frame f-cab-combustivel = trim(return-value).
{utp/ut-liter.i Inic_Contr * R }
assign  cDataIni:label in frame f-cab-combustivel = trim(return-value).
{utp/ut-liter.i Cap.Tanque * R }
assign  cCapTaq:label in frame f-cab-combustivel = trim(return-value).
{utp/ut-liter.i Tipo_Consumo * R }
assign  cTpCons:label in frame f-cab-combustivel = trim(return-value).
{utp/ut-liter.i Valor_Consumo * R }
assign  cValCons:label in frame f-cab-combustivel = trim(return-value).
{utp/ut-liter.i Tp_Cons_Sec. * R }
assign  cTpConsSec:label in frame f-cab-combustivel = trim(return-value).
{utp/ut-liter.i Vlr_Cons._Sec * R }
assign  cValConsSec:label in frame f-cab-combustivel = trim(return-value).
{utp/ut-liter.i Desativado_Em }
assign  cDtDesativ:label in frame f-cab-combustivel = trim(return-value).


FORM mab-caract.cod-caract         at 01
     mab-caract.des-abrev          AT 12
     mab-eqpto-caract.des-caract   at 23
     mab-eqpto-caract.des-arquivo FORMAT "x(48)"  at 54
    with NO-BOX NO-LABELS width 132 frame f-relatorio-caracteristica stream-io.

{utp/ut-liter.i Caracter * R }
assign  cCodCaract = trim(return-value).
{utp/ut-liter.i Abreviat * R }
assign  cDesAbrev = trim(return-value).
{utp/ut-liter.i Descri‡Æo * R }
assign  cDesCaract = trim(return-value).
{utp/ut-liter.i Arquivo * R }
assign cDesArquivo = trim(return-value).
ASSIGN cLinha2 = "---------- ---------- ------------------------------ --------------------------------------------------"
       cLinha  = cCodCaract + "   " + cDesAbrev + "   " + cDesCaract + "                      " + cDesArquivo. 


FORM   mab-comptmento-eqpto.cod-comptmento AT 01
       mab-comptmento.des-comptmento       AT 10
       mab-tip-mater.des-tip-mater         AT 42
       mab-comptmento-eqpto.qtd-capac      AT 75 FORMAT "zzzz9.99"
       mab-comptmento-eqpto.val-perc-remon AT 88 FORMAT "zz9.99"
       mab-event.des-evento                AT 95 FORMAT "X(25)"
       mab-period-manut.val-km-padr              FORMAT "ZZ,ZZZ,ZZ9.9"
       with NO-LABEL no-box  width 132 frame f-compartimento stream-io.


form  cCompto    AT 01 FORMAT "x(40)"     
      cTpMatrl   AT 42 FORMAT "x(30)"       
      cCapcid    AT 73 FORMAT "X(10)"      
      cRemont    AT 84 FORMAT "X(10)"       
      cEvent     AT 95 FORMAT "x(25)"     
      cPeriodo   FORMAT "x(12)"    
      with no-box  width 132 frame f-cab-compto stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-cab-compto:HANDLE).


{utp/ut-liter.i Compartimento/Filtro * R }
assign  cCompto:label in frame f-cab-compto = trim(return-value).
{utp/ut-liter.i Tipo_Material * R }
assign  cTpMatrl:label in frame f-cab-compto = trim(return-value).
{utp/ut-liter.i Capacidade * R }
assign  cCapcid:label in frame f-cab-compto = trim(return-value).
{utp/ut-liter.i %Rem_Motor * R }
assign  cRemont:label in frame f-cab-compto = trim(return-value).
{utp/ut-liter.i Evento * R }
assign  cEvent:label in frame f-cab-compto = trim(return-value).
{utp/ut-liter.i Per¡odo * L }
assign cPeriodo:label in frame f-cab-compto = trim(return-value).



FORM  mab-histor-ativid.dat-cadastro   AT 01
      cEstabel                         AT 12 FORMAT "X(30)"
      cGrupo                           AT 43 FORMAT "X(30)"
      mab-histor-ativid.cc-codigo      AT 74 
      mab-histor-ativid.ct-codigo      AT 83
    &IF DEFINED(bf_mnt_ems206b) &THEN
      mab-histor-ativid.cod-unid-negoc AT 92
    &ELSE
      mab-histor-ativid.cod_unid_negoc AT 92
    &ENDIF
      mab-histor-ativid.cd-tag         AT 101 FORMAT "x(16)"
      mab-histor-ativid.cod-ativid     AT 118
      mab-ativid.log-area-agro         AT 127 
      with NO-LABEL no-box  width 132 side-labels frame f-historico stream-io.

DO:
FORM  cData        AT 01  FORMAT "X(10)"       
      cDescEstab   AT 12 FORMAT "X(30)" 
      cDescGrp     AT 43 FORMAT "X(30)" 
      cCusto       AT 74         
      cCtaCont     AT 83
      cUdeNeg      AT 92
      cTag         AT 101 FORMAT "x(16)"
      cAtivid      AT 118 FORMAT "x(8)"
      cAgr         AT 127 
      with no-box  width 132 frame f-cab-histco stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-cab-histco:HANDLE).

END. 

{utp/ut-liter.i Data * R }
assign  cData:LABEL in frame f-cab-histco = trim(return-value).
{utp/ut-liter.i Estabelecimento * R }
assign  cDescEstab:label in frame f-cab-histco = trim(return-value).
{utp/ut-liter.i Grupo_Equipamento * R }
assign  cDescGrp:label in frame f-cab-histco = trim(return-value).
{utp/ut-liter.i C.Custo * R }
assign  cCusto:label in frame f-cab-histco = trim(return-value).
{utp/ut-liter.i C.Contab * R }
assign  cCtaCont:label in frame f-cab-histco = trim(return-value).
{utp/ut-liter.i U.Neg * R }
assign   cUdeNeg:label in frame f-cab-histco = trim(return-value).
{utp/ut-liter.i Tag }
assign  cTag:label in frame f-cab-histco = trim(return-value).
{utp/ut-liter.i Ativid }
assign  cAtivid:label in frame f-cab-histco = trim(return-value).
{utp/ut-liter.i Agr }
assign  cAgr:label in frame f-cab-histco = trim(return-value).

FORM cEvento                                AT 01 FORMAT "X(41)"
     mab-programac-event.cod-dia-mes-vencto AT 43
     mab-programac-event.num-dia            AT 51 FORMAT "zzzzz"
     mab-programac-event.num-parcela        AT 66 FORMAT "zz9"
     cPerValid                              AT 77 FORMAT "x(25)"
     with NO-LABEL no-box  width 132 side-labels frame f-evento stream-io.

FORM  cDescEvent        AT 01 FORMAT "X(41)"
      cVencto           AT 43 FORMAT "x(10)"     
      cAntecip          AT 54 FORMAT "x(11)"       
      cNumParc          AT 66 FORMAT "x(10)"       
      cValidade         AT 77 FORMAT "x(23)"
     with no-box  width 132 frame f-cab-evento stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-cab-evento:HANDLE).



{utp/ut-liter.i Evento * R }
assign  cDescEvent:label in frame f-cab-evento = trim(return-value).
{utp/ut-liter.i Vencimento * L }
assign  cVencto:label in frame f-cab-evento = trim(return-value).
{utp/ut-liter.i Antecipa‡Æo * R }
assign  cAntecip:label in frame f-cab-evento = trim(return-value).
{utp/ut-liter.i N.Parcelas * R }
assign  cNumParc:label in frame f-cab-evento = trim(return-value).
{utp/ut-liter.i Per¡odo_Validade * R }
assign  cValidade:label in frame f-cab-evento = trim(return-value).


FORM
    mmv-eqpto-plano.cod-plano                              AT 01
    " - "                                                  AT 10
    c-des-plano                                            AT 14
    mmv-eqpto-plano.dat-inicial                            AT 45
    mmv-eqpto-plano.dat-final                              AT 59
    mmv-eqpto-plano.val-km-inicial                         AT 71
    mmv-eqpto-plano.val-km-real                            AT 88
     with NO-LABEL no-box  width 132 side-labels frame f-plano stream-io.

FORM cDescPlano                     AT 01    FORMAT "x(43)" 
     c-dat-inicial                  AT 45    FORMAT "x(12)" 
     c-dat-final                    AT 59    FORMAT "x(10)" 
     c-val-km-inicial               AT 71    FORMAT "x(12)" 
     c-val-km-real                  AT 88    FORMAT "x(12)" 
     with no-box  width 132 frame f-cab-plano stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-cab-plano:HANDLE).


{utp/ut-liter.i Plano_Preventiva * }
assign  cDescPlano:LABEL in frame f-cab-plano = trim(return-value).
{utp/ut-liter.i Data_Inicial * }
assign  c-dat-inicial:LABEL in frame f-cab-plano = trim(return-value).
{utp/ut-liter.i Validade * }
assign  c-dat-final:LABEL in frame f-cab-plano = trim(return-value).
{utp/ut-liter.i Uso_Inicial * }
assign  c-val-km-inicial:LABEL in frame f-cab-plano = trim(return-value).
{utp/ut-liter.i Uso_Real * }
assign  c-val-km-real:LABEL in frame f-cab-plano = trim(return-value).


FORM mab-configur-eixo.num-eixo           AT 01
     mab-configur-eixo.val-percent-suspen AT 19 FORMAT "zz9.99"
     l-tracao                             AT 26
     l-duplo                              AT 35
     with NO-LABEL no-box  width 132 side-labels frame f-eixo stream-io.

FORM  cEixo    AT 01 FORMAT "x(4)"
      cTempo   AT 08 FORMAT "x(17)"     
      cTracao  AT 26 FORMAT "x(6)"     
      cDuplo   AT 35 FORMAT "x(5)"    
with no-box  width 132 frame f-cab-eixo stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-cab-eixo:HANDLE).


{utp/ut-liter.i Eixo * R }
assign  cEixo:label in frame f-cab-eixo = trim(return-value).
{utp/ut-liter.i %_Tempo_Suspenso * R }
assign  cTempo:label in frame f-cab-eixo = trim(return-value).
{utp/ut-liter.i Tra‡Æo * R }
assign  cTracao:label in frame f-cab-eixo = trim(return-value).
{utp/ut-liter.i Duplo * R }
assign  cDuplo:label in frame f-cab-eixo = trim(return-value).

{utp/ut-liter.i Sim/NÆo}
assign  l-tracao:FORMAT in frame f-eixo = return-value
        l-duplo:FORMAT in frame f-eixo = return-value.

def temp-table tt-comp-folh
    field seq-de-imp as int
    field cd-comp   as char
    field cd-folha  as char.

/* Parameters Definitions ---                                           */
      DEF temp-table tt-param
        field destino              as integer
        field arquivo              as char
        field usuario              as char
        field data-exec            as date
        field hora-exec            as integer
        field parametro            as logical
        FIELD formato              as integer
        field v_num_tip_aces_usuar as integer
&IF "{&mguni_version}" >= "2.071" &THEN
        field i-ep-codigo          LIKE empresa.ep-codigo
&ELSE
        field i-ep-codigo          as integer
&ENDIF
        field classifica           as integer
        field desc-classifica      as char format "x(40)"
        field rs-considera         as integer
        field desc-considera       as char format "x(40)"
        field l-motorizados        as logical  
        field l-n-motorizados      as logical
        field l-ativos             as logical
        field l-Inativos           as logical 
        field l-proprios           as logical  
        field l-terceiros          as logical
        field l-combust            as logical
        field l-caract             as logical
        field l-comptes            as logical
        field l-hist               as logical  
        field l-eventos            as logical
        field l-planos             as logical
        field l-config             as logical 
        field l-param              as logical
        field l-Insere             as logical
        field i-cod-emp-ini        like mab-eqpto.ep-codigo
        field i-cod-emp-fim        like mab-eqpto.ep-codigo
        field c-cod-eqpto-ini      like mab-eqpto.cod-eqpto
        field c-cod-eqpto-fim      like mab-eqpto.cod-eqpto
        field c-grupo-ini          like mab-eqpto.cod-grp-eqpto
        field c-grupo-fim          like mab-eqpto.cod-grp-eqpto
        field c-modelo-ini         like mab-eqpto.cod-model
        field c-modelo-fim         like mab-eqpto.cod-model
        field c-estab-ini          like mab-eqpto.cod-estabel
        field c-estab-fim          like mab-eqpto.cod-estabel
        field c-tag-ini            like mab-eqpto.cd-tag
        field c-tag-fim            like mab-eqpto.cd-tag
        FIELD i-prop-ini           LIKE mab-eqpto.cod-emitente
        FIELD i-prop-fim           LIKE mab-eqpto.cod-emitente
        field c-estr-mec-ini       like mab-eqpto.cod-estrut-mec
        field c-estr-mec-fim       like mab-eqpto.cod-estrut-mec
        field c-ccusto-ini         like mab-eqpto.cc-codigo
        field c-ccusto-fim         like mab-eqpto.cc-codigo
        field c-sit-ini            like mab-eqpto.cod-sit-eqpto
        field c-sit-fim            like mab-eqpto.cod-sit-eqpto
        field i-ano-fab-ini        like mab-eqpto.vli-ano-fabric
        field i-ano-fab-fim        like mab-eqpto.vli-ano-fabric
        field dat-cadastr-ini      like mab-histor-ativid.dat-cadastro
        field dat-cadastr-fim      like mab-histor-ativid.dat-cadastro
     &IF DEFINED(bf_mnt_ems206b) &THEN
        FIELD c-cod-unid-negoc-ini AS CHARACTER FORMAT "x(3)"
        FIELD c-cod-unid-negoc-fim AS CHARACTER FORMAT "x(3)"
        FIELD l-matriz-un          AS LOGICAL
        FIELD l-detalha-un         AS LOGICAL
      &ENDIF
        .

def temp-table tt-digita no-undo
    field linha      as int
    field conteudo   as character format "x(80)"
    index editor-id is primary unique linha.




/****Fim da Include********/
