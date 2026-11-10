/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0400RP 2.00.00.032 } /*** "010032" 14/07/2026 13:26:13 ***/
/******************************************************************************
***
***    IM0400RP - Gerador de Arquivo Excel
***
*******************************************************************************/

{utp/ut-glob.i}
{include/tt-edit.i}
{include/pi-edit.i}

DEFINE INPUT PARAMETER i-num-di-ems       LIKE decla-import.num-di-ems       NO-UNDO.
DEFINE INPUT PARAMETER d-cdd-siscomex-dts LIKE decla-import.cdd-siscomex-dts NO-UNDO.

/* Defini‡Æo de vari veis locais */
DEF VAR h-acomp     AS HANDLE NO-UNDO.
DEF VAR h-bocx383   AS HANDLE NO-UNDO.
IF NOT VALID-HANDLE(h-bocx383) THEN
    RUN cxbo/bocx383.p PERSISTENT SET h-bocx383.

/* definicÆo das vari veis de formato */

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
DEF VAR iTamFixo AS INTEGER NO-UNDO.

/* XML */


/* Defini‡Æo das Labels */
DEF VAR c-lbl-num-di-ems        AS CHARACTER NO-UNDO.
DEF VAR c-lbl-retif             AS CHARACTER NO-UNDO.
DEF VAR c-lbl-siscomex          AS CHARACTER NO-UNDO.
DEF VAR c-lbl-estab             AS CHARACTER NO-UNDO.
DEF VAR c-lbl-data-di           AS CHARACTER NO-UNDO.
DEF VAR c-lbl-moedas            AS CHARACTER NO-UNDO.
DEF VAR c-lbl-cotacao           AS CHARACTER NO-UNDO.

DEF VAR c-lbl-moeda-estrangeira AS CHARACTER NO-UNDO.
DEF VAR c-lbl-moeda-nacional    AS CHARACTER NO-UNDO.
DEF VAR c-lbl-moeda-param       AS CHARACTER NO-UNDO.

DEF VAR c-lbl-decla-import      AS CHARACTER NO-UNDO.

DEF VAR c-lbl-vmcv              AS CHARACTER NO-UNDO.
DEF VAR c-lbl-vmle              AS CHARACTER NO-UNDO.
DEF VAR c-lbl-vmld              AS CHARACTER NO-UNDO.
DEF VAR c-lbl-peso-liq          AS CHARACTER NO-UNDO.

DEF VAR c-lbl-desp-decla-imp    AS CHARACTER NO-UNDO.
DEF VAR c-lbl-incide-nf         AS CHARACTER NO-UNDO.
DEF VAR c-lbl-despesa           AS CHARACTER NO-UNDO.
DEF VAR c-lbl-valor             AS CHARACTER NO-UNDO.
DEF VAR c-lbl-incide-vmle       AS CHARACTER NO-UNDO.
DEF VAR c-lbl-fpc               AS CHARACTER NO-UNDO.
DEF VAR c-lbl-va                AS CHARACTER NO-UNDO.

DEF VAR c-lbl-adic              AS CHARACTER NO-UNDO.
DEF VAR c-lbl-desp-adic         AS CHARACTER NO-UNDO.
DEF VAR c-lbl-item              AS CHARACTER NO-UNDO.
DEF VAR c-lbl-desp-item         AS CHARACTER NO-UNDO.


/* Fim Defini‡Æo Labels */

DEF VAR c-moeda-negociada       AS CHARACTER NO-UNDO.
DEF VAR d-cotac-moeda-negociada AS DECIMAL   NO-UNDO.
DEF VAR c-moeda-nacional        AS CHARACTER NO-UNDO.
DEF VAR d-cotac-moeda-nacional  AS DECIMAL   NO-UNDO.
DEF VAR c-moeda-param           AS CHARACTER NO-UNDO.
DEF VAR d-cotac-moeda-param     AS DECIMAL   NO-UNDO.

DEF VAR c-incide-nf             AS CHARACTER NO-UNDO.
DEF VAR c-despesa               AS CHARACTER NO-UNDO.
DEF VAR c-va                    AS LOGICAL   NO-UNDO.

DEF VAR c-despesa-adic          AS CHARACTER NO-UNDO.
DEF VAR c-va-adic               AS LOGICAL   NO-UNDO.

DEF VAR c-despesa-adic-itens    AS CHARACTER NO-UNDO.
DEF VAR c-va-adic-itens         AS LOGICAL   NO-UNDO.

              
DEF VAR d-val-despes-moed-negoc      LIKE despes-decla-import.val-despes NO-UNDO.
DEF VAR d-val-despes-moed-nac        LIKE despes-decla-import.val-despes NO-UNDO.
DEF VAR d-val-despes-moed-param      LIKE despes-decla-import.val-despes NO-UNDO.   

DEF VAR d-val-despes-adic-moed-negoc LIKE despes-decla-import.val-despes NO-UNDO.
DEF VAR d-val-despes-adic-moed-nac   LIKE despes-decla-import.val-despes NO-UNDO.
DEF VAR d-val-despes-adic-moed-param LIKE despes-decla-import.val-despes NO-UNDO.   

DEF VAR d-val-despes-item-moed-negoc LIKE despes-decla-import.val-despes NO-UNDO.
DEF VAR d-val-despes-item-moed-nac   LIKE despes-decla-import.val-despes NO-UNDO.
DEF VAR d-val-despes-item-moed-param LIKE despes-decla-import.val-despes NO-UNDO.   
DEF VAR c-lbl-impostos-di    AS CHARACTER NO-UNDO.            
DEF VAR c-lbl-impostos-adic  AS CHARACTER NO-UNDO.
DEF VAR c-lbl-impostos-item  AS CHARACTER NO-UNDO.
DEF VAR c-lbl-II             AS CHARACTER NO-UNDO.
DEF VAR c-lbl-IPI            AS CHARACTER NO-UNDO.
DEF VAR c-lbl-PIS            AS CHARACTER NO-UNDO.
DEF VAR c-lbl-COFINS         AS CHARACTER NO-UNDO.
DEF VAR c-lbl-ICMS           AS CHARACTER NO-UNDO.
DEF VAR c-lbl-tribut         AS CHARACTER NO-UNDO.
DEF VAR c-lbl-aliq           AS CHARACTER NO-UNDO.
DEF VAR c-lbl-reduc          AS CHARACTER NO-UNDO.
DEF VAR c-lbl-susp           AS CHARACTER NO-UNDO.
DEF VAR c-lbl-valor-impostos AS CHARACTER NO-UNDO.
DEF VAR c-lbl-coluna         AS CHARACTER NO-UNDO.
DEF VAR c-lbl-trib-reduz-DI  AS CHARACTER NO-UNDO.
DEF VAR c-lbl-isento-DI      AS CHARACTER NO-UNDO.
DEF VAR c-lbl-outros-DI      AS CHARACTER NO-UNDO.
/* DI */
DEF VAR v-val-II-DI        LIKE decla-import.val-ii-db-cr     NO-UNDO.  
DEF VAR v-val-IPI-DI       LIKE decla-import.val-ipi-db-cr    NO-UNDO.  
DEF VAR v-val-PIS-DI       LIKE decla-import.val-pis-db-cr    NO-UNDO.  
DEF VAR v-val-COFINS-DI    LIKE decla-import.val-cofins-db-cr NO-UNDO.  
DEF VAR v-val-ICMS-DI      LIKE decla-import.val-icms-db-cr   NO-UNDO.
DEF VAR v-val-ibsuf-T-DI   LIKE decla-import.val-icms-db-cr   NO-UNDO.
DEF VAR v-val-ibsuf-I-DI   LIKE decla-import.val-icms-db-cr   NO-UNDO.
DEF VAR v-val-ibsuf-O-DI   LIKE decla-import.val-icms-db-cr   NO-UNDO.
DEF VAR v-val-cbs-T-DI     LIKE decla-import.val-icms-db-cr   NO-UNDO.
DEF VAR v-val-cbs-I-DI     LIKE decla-import.val-icms-db-cr   NO-UNDO.
DEF VAR v-val-cbs-O-DI     LIKE decla-import.val-icms-db-cr   NO-UNDO.
DEF VAR v-val-ibsmun-T-DI  LIKE decla-import.val-icms-db-cr   NO-UNDO.
DEF VAR v-val-ibsmun-I-DI  LIKE decla-import.val-icms-db-cr   NO-UNDO.
DEF VAR v-val-ibsmun-O-DI  LIKE decla-import.val-icms-db-cr   NO-UNDO.
DEF VAR v-val-is-T-DI      LIKE decla-import.val-icms-db-cr   NO-UNDO.
DEF VAR v-val-is-I-DI      LIKE decla-import.val-icms-db-cr   NO-UNDO.
DEF VAR v-val-is-O-DI      LIKE decla-import.val-icms-db-cr   NO-UNDO.
/* ADIC */
DEF VAR v-val-II-adic         LIKE decla-import-adic.val-ii-db-cr     NO-UNDO.  
DEF VAR v-val-IPI-adic        LIKE decla-import-adic.val-ipi-db-cr    NO-UNDO.  
DEF VAR v-val-PIS-adic        LIKE decla-import-adic.val-pis-db-cr    NO-UNDO.  
DEF VAR v-val-COFINS-adic     LIKE decla-import-adic.val-cofins-db-cr NO-UNDO.  
DEF VAR v-val-ICMS-adic       LIKE decla-import-adic.val-icms-db-cr   NO-UNDO.  
DEF VAR i-trib-ibsuf-adic     AS INTEGER                              NO-UNDO.
DEF VAR de-aliq-ibsuf-adic    LIKE decla-import-adic.val-aliq-icms    NO-UNDO.
DEF VAR de-reduc-ibsuf-adic   LIKE decla-import-adic.val-aliq-icms    NO-UNDO.
DEF VAR v-val-ibsuf-adic      LIKE decla-import-adic.val-icms-db-cr   NO-UNDO.
DEF VAR i-trib-cbs-adic       AS INTEGER                              NO-UNDO.
DEF VAR de-aliq-cbs-adic      LIKE decla-import-adic.val-aliq-icms    NO-UNDO.
DEF VAR de-reduc-cbs-adic     LIKE decla-import-adic.val-aliq-icms    NO-UNDO.
DEF VAR v-val-cbs-adic        LIKE decla-import-adic.val-icms-db-cr   NO-UNDO.
DEF VAR i-trib-ibsmun-adic    AS INTEGER                              NO-UNDO.
DEF VAR de-aliq-ibsmun-adic   LIKE decla-import-adic.val-aliq-icms    NO-UNDO.
DEF VAR de-reduc-ibsmun-adic  LIKE decla-import-adic.val-aliq-icms    NO-UNDO.
DEF VAR v-val-ibsmun-adic     LIKE decla-import-adic.val-icms-db-cr   NO-UNDO.
DEF VAR i-trib-is-adic        AS INTEGER                              NO-UNDO.
DEF VAR de-aliq-is-adic       LIKE decla-import-adic.val-aliq-icms    NO-UNDO.
DEF VAR v-val-is-adic         LIKE decla-import-adic.val-icms-db-cr   NO-UNDO.
/* ITENS */
DEF VAR v-val-II-itens        LIKE decla-import-adic-itens.val-ii-db-cr     NO-UNDO. 
DEF VAR v-val-IPI-itens       LIKE decla-import-adic-itens.val-ipi-db-cr    NO-UNDO. 
DEF VAR v-val-PIS-itens       LIKE decla-import-adic-itens.val-pis-db-cr    NO-UNDO. 
DEF VAR v-val-COFINS-itens    LIKE decla-import-adic-itens.val-cofins-db-cr NO-UNDO. 
DEF VAR v-val-ICMS-itens      LIKE decla-import-adic-itens.val-icms-db-cr   NO-UNDO. 
DEF VAR i-trib-ibsuf-itens    AS INTEGER                                    NO-UNDO.
DEF VAR de-aliq-ibsuf-itens   LIKE decla-import-adic-itens.val-aliq-icms    NO-UNDO.
DEF VAR de-reduc-ibsuf-itens  LIKE decla-import-adic-itens.val-aliq-icms    NO-UNDO.
DEF VAR v-val-ibsuf-itens     LIKE decla-import-adic-itens.val-icms-db-cr   NO-UNDO.
DEF VAR i-trib-cbs-itens      AS INTEGER                                    NO-UNDO.
DEF VAR de-aliq-cbs-itens     LIKE decla-import-adic-itens.val-aliq-icms    NO-UNDO.
DEF VAR de-reduc-cbs-itens    LIKE decla-import-adic-itens.val-aliq-icms    NO-UNDO.
DEF VAR v-val-cbs-itens       LIKE decla-import-adic-itens.val-icms-db-cr   NO-UNDO.
DEF VAR i-trib-ibsmun-itens   AS INTEGER                                    NO-UNDO.
DEF VAR de-aliq-ibsmun-itens  LIKE decla-import-adic-itens.val-aliq-icms    NO-UNDO.
DEF VAR de-reduc-ibsmun-itens LIKE decla-import-adic-itens.val-aliq-icms    NO-UNDO.
DEF VAR v-val-ibsmun-itens    LIKE decla-import-adic-itens.val-icms-db-cr   NO-UNDO.
DEF VAR i-trib-is-itens       AS INTEGER                                    NO-UNDO.
DEF VAR de-aliq-is-itens      LIKE decla-import-adic-itens.val-aliq-icms    NO-UNDO.
DEF VAR v-val-is-itens        LIKE decla-import-adic-itens.val-icms-db-cr   NO-UNDO.

DEF VAR c-hora-arquivo        AS CHARACTER                                  NO-UNDO.
DEF VAR c-di-arquivo          AS CHARACTER                                  NO-UNDO.

DEF VAR l-nt2024002  AS LOGICAL  NO-UNDO.

ASSIGN l-nt2024002 = CAN-FIND(FIRST funcao NO-LOCK
                              WHERE funcao.cd-funcao = "spp-NT2024002" AND funcao.ativo).

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
{utp/ut-liter.i Exportando... *}       
RUN pi-inicializar IN h-acomp (INPUT return-value).

IF i-num-di-ems <= 0 THEN DO:
    RUN pi-finalizar IN h-acomp.
    RETURN "NOK":U.
END.

/* altera‡Æo da extensÆo do anomeArquivo */
DEF VAR nomeArquivo AS CHARACTER NO-UNDO.

ASSIGN c-hora-arquivo = STRING(TODAY, "99999999") + "_" + REPLACE(STRING(TIME,"HH:MM:SS"), ":", "")
       c-di-arquivo   = REPLACE(REPLACE(REPLACE(STRING(i-num-di-ems),".",""),"/",""),"\","")
       nomeArquivo    = SESSION:TEMP-DIRECTORY + "IM0400_":U + c-di-arquivo
       nomeArquivo    = nomeArquivo + "_" + c-hora-arquivo + ".xml":U.

/* altera parƒmetro da sessÆo para impressÆo de dados decimais */
assign cNumericFormat = session:numeric-format
       session:numeric-format = "AMERICAN".

/* abertura do anomeArquivo para impressÆo do XML */
output to value(nomeArquivo) convert target "utf-8":U.



RUN pi-gera-relatorio.
output close. 

/*=================================
  ConversÆo do anomeArquivo XML para XLS
  =================================*/

run piConvertXMLToXLS.

/* retorna os parƒmetros da sessÆo */
assign session:numeric-format = cNumericFormat.

RUN pi-finalizar IN h-acomp.

RETURN "OK":U.

PROCEDURE pi-gera-relatorio:
    
    FOR FIRST decla-import NO-LOCK
            WHERE decla-import.num-di-ems       = i-num-di-ems 
            AND   decla-import.cdd-siscomex-dts = d-cdd-siscomex-dts
            AND   decla-import.log-ativo        = YES:
        
        assign iColumns = 20.
        
        run OpenWorkBook.
        run OpenExcelWorkBook.
        run CloseExcelWorkBook .
        run OpenStyles.
        run CloseStyles.
        run OpenWorkSheet(input "IM0400").
        run OpenTable(input iColumns).
    
        /* defini‡Æo da largura das colunas */
        run setColumnWidth(input "85.00").
        run setColumnWidth(input "95.00"). 
        run setColumnWidth(input "70.00").
        run setColumnWidth(input "70.00"). 
        run setColumnWidth(input "48.00"). 
        run setColumnWidth(input "70.00"). 
        run setColumnWidth(input "10.00").
    
        run setColumnWidth(INPUT "85.00"). 
        run setColumnWidth(input "95.00").
        run setColumnWidth(INPUT "70.00").
        run setColumnWidth(input "70.00"). 
        run setColumnWidth(input "48.00"). 
        run setColumnWidth(input "70.00"). 
        run setColumnWidth(INPUT "10.00").
    
        run setColumnWidth(INPUT "85.00").
        run setColumnWidth(INPUT "95.00").
        run setColumnWidth(INPUT "70.00").
        run setColumnWidth(input "70.00"). 
        run setColumnWidth(input "48.00"). 
        run setColumnWidth(input "70.00"). 
        
        ASSIGN c-lbl-decla-import = "Declara‡Æo de Importa‡Æo Nr. " + string(decla-import.num-di-ems).

        FIND FIRST param-imp NO-LOCK
            WHERE param-imp.cod-estabel = decla-import.cod-estab NO-ERROR.

        /* moeda negociada */
        FOR FIRST decla-import-adic NO-LOCK
                WHERE decla-import-adic.num-di-ems       = decla-import.num-di-ems
                AND   decla-import-adic.cdd-siscomex-dts = decla-import.cdd-siscomex-dts:
            FIND FIRST moeda NO-LOCK
                    WHERE moeda.mo-codigo = decla-import-adic.cdn-moeda NO-ERROR.
            ASSIGN c-moeda-negociada = STRING(moeda.mo-codigo) + " - " + moeda.descricao WHEN AVAIL moeda.
             
            RUN buscaCotacao (INPUT  decla-import.num-di-ems,
                              INPUT  decla-import.cdd-siscomex-dts,
                              INPUT  decla-import-adic.cdn-moeda,
                              INPUT  decla-import.dat-di,
                              OUTPUT d-cotac-moeda-negociada).
        END.
        /* fim - moeda negociada */
        
        /* moeda nacional */
        FIND FIRST moeda NO-LOCK
                WHERE moeda.mo-codigo = 0 NO-ERROR.
        ASSIGN c-moeda-nacional = STRING(moeda.mo-codigo) + " - " + moeda.descricao WHEN AVAIL moeda.
        /* fim - moeda nacional */

        /* moeda param */
        FIND FIRST moeda NO-LOCK
                WHERE moeda.mo-codigo = param-imp.int-2 NO-ERROR.
        ASSIGN c-moeda-param = STRING(moeda.mo-codigo) + " - " + moeda.descricao WHEN AVAIL moeda.
        RUN buscaCotacao (INPUT  decla-import.num-di-ems,
                          INPUT  decla-import.cdd-siscomex-dts,
                          INPUT  param-imp.int-2,
                          INPUT  decla-import.dat-di,
                          OUTPUT d-cotac-moeda-param).
        /* fim - moeda param */
        


        ASSIGN c-lbl-num-di-ems        = "N£mero da DI"
               c-lbl-retif             = "Retifica‡Æo"
               c-lbl-siscomex          = "Siscomex"
               c-lbl-estab             = "Estabelecimento"
               c-lbl-data-di           = "Data da DI"
               c-lbl-moedas            = "Moeda"
               c-lbl-cotacao           = "Cota‡Æo (" + string(decla-import.dat-di) + ")"
               c-lbl-moeda-estrangeira = "Moeda Estrangeira (" + c-moeda-negociada + ")"
               c-lbl-moeda-nacional    = "Moeda Nacional (" + c-moeda-nacional + ")"
               c-lbl-moeda-param       = "Moeda Param (" + c-moeda-param + ")"
        
               c-lbl-vmcv              = "VMCV"
               c-lbl-vmle              = "VMLE"
               c-lbl-vmld              = "VMLD"
               c-lbl-peso-liq          = "Peso L¡quido"
            
               c-lbl-desp-decla-imp    = "Despesas da Declara‡Æo de Importa‡Æo"
               c-lbl-incide-nf         = "Incide Nota Fiscal"
               c-lbl-despesa           = "Despesa"
               c-lbl-valor             = "Valor"
               c-lbl-incide-vmle       = "Inc VMLE"
               c-lbl-fpc               = "FPC"
               c-lbl-va                = "VA"

               c-lbl-impostos-di       = "Impostos da DI Nr. " + string(decla-import.num-di-ems)
               c-lbl-coluna            = ""
               c-lbl-II                = "II"
               c-lbl-IPI               = "IPI"
               c-lbl-PIS               = "PIS"
               c-lbl-COFINS            = "COFINS"
               c-lbl-ICMS              = "ICMS"
               c-lbl-tribut            = "Tributa‡Æo"
               c-lbl-aliq              = "Al¡quota"
               c-lbl-reduc             = "Redu‡Æo"
               c-lbl-susp              = "Suspenso"
               c-lbl-valor-impostos    = "Valor (R$)"
               
               c-lbl-trib-reduz-DI     = "Tributado (R$)"
               c-lbl-isento-DI         = "Isento (R$)"
               c-lbl-outros-DI         = "Outros (R$)"
               .  
        
        /* cabecalho */
        RUN OpenLine.
            RUN MergeColumns (INPUT 19, "Valores Rateados da DI", "titulo").
        RUN CloseLine.

        RUN OpenLine.
            RUN MergeColumns (INPUT 19, "", "Default").
        RUN CloseLine.
    
        RUN OpenLine.
            RUN PrintDataString(INPUT c-lbl-num-di-ems                              , "subtitulo").
            RUN PrintDataString(INPUT decla-import.num-di-ems                       , "padrao").
            RUN MergeColumns   (INPUT 13, ""                                        , "Default").
        RUN CloseLine.
    
        RUN OpenLine.
            RUN PrintDataString(INPUT c-lbl-retif                                   , "subtitulo").
            RUN PrintDataString(INPUT decla-import.num-seq-retif                    , "padrao").
            RUN MergeColumns   (INPUT 13, ""                                        , "Default").
        RUN CloseLine.
    
        RUN OpenLine.
            RUN PrintDataString(INPUT c-lbl-siscomex                                , "subtitulo").
            RUN PrintDataString(INPUT decla-import.cod-di-siscomex                  , "padrao").
            RUN MergeColumns   (INPUT 13, ""                                        , "Default").
        RUN CloseLine.
    
        RUN OpenLine.
            RUN PrintDataString(INPUT c-lbl-estab                                   , "subtitulo").
            RUN PrintDataString(INPUT decla-import.cod-estab                        , "padrao").
            RUN MergeColumns   (INPUT 13, ""                                        , "Default").
        RUN CloseLine.
    
        RUN OpenLine.
            RUN PrintDataString(INPUT c-lbl-data-di                                 , "subtitulo").
            RUN PrintDataString(INPUT decla-import.dat-di                           , "padrao").
            RUN MergeColumns   (INPUT 13, ""                                        , "Default").
        RUN CloseLine.
        
        RUN OpenLine.
            RUN MergeColumns   (INPUT 19, "", "Default").
        RUN CloseLine.
        
        RUN OpenLine.
            RUN PrintDataString(INPUT c-lbl-moedas                                  , "subtitulo").
            RUN PrintDataString(INPUT c-lbl-cotacao                                 , "subtitulo").
            RUN MergeColumns   (INPUT 13, ""                                        , "Default").
        RUN CloseLine.

        RUN OpenLine.
            RUN PrintDataString(INPUT c-moeda-negociada                             , "padrao").
            RUN PrintDataNumber(INPUT d-cotac-moeda-negociada                       , "numeroFormato4").
            RUN MergeColumns   (INPUT 13, ""                                        , "Default").
        RUN CloseLine.
        IF  c-moeda-param <> c-moeda-negociada THEN DO:
            RUN OpenLine.
                RUN PrintDataString(INPUT c-moeda-param, "padrao").
                RUN PrintDataNumber(INPUT d-cotac-moeda-param, "numeroFormato4").
                RUN MergeColumns   (INPUT 13, "", "Default").
            RUN CloseLine.
        END. /* IF  c-moeda-param <> c-moeda-negociada THEN DO: */
    
        /* fim - cabecalho */

        RUN OpenLine.
            RUN MergeColumns (INPUT 19, "", "Default").
        RUN CloseLine.
    
        RUN OpenLine.
            RUN MergeColumns   (INPUT 5, c-lbl-moeda-estrangeira, "titulo").
            ASSIGN iColCount = iColCount + 1.
            RUN PrintDataString(INPUT ""                                            , "Default").
            RUN MergeColumns   (INPUT 5, c-lbl-moeda-nacional, "titulo").
            ASSIGN iColCount = iColCount + 1.
            RUN PrintDataString(INPUT ""                                            , "Default").
            RUN MergeColumns   (INPUT 5, c-lbl-moeda-param, "titulo").
        RUN CloseLine.

        RUN OpenLine.
            RUN MergeColumns   (INPUT 19, "", "Default").
        RUN CloseLine.

        RUN OpenLine.
            RUN MergeColumns   (INPUT 2, c-lbl-decla-import, "subtitulo").
            ASSIGN iColCount = iColCount + 1.
            RUN MergeColumns   (INPUT 3, ""                                         , "Default").
            ASSIGN iColCount = iColCount + 1.
            RUN MergeColumns   (INPUT 2, c-lbl-decla-import, "subtitulo").
            ASSIGN iColCount = iColCount + 1.
            RUN MergeColumns   (INPUT 3, ""                                         , "Default").
            ASSIGN iColCount = iColCount + 1.
            RUN MergeColumns   (INPUT 2, c-lbl-decla-import                         , "subtitulo").
        RUN CloseLine.

        RUN OpenLine.
            RUN PrintDataString(INPUT c-lbl-vmcv,        "subtitulo_direito_cinza"). 
            RUN PrintDataString(INPUT c-lbl-vmle,        "subtitulo_direito_cinza"). 
            RUN PrintDataString(INPUT c-lbl-vmld,        "subtitulo_direito_cinza"). 
            RUN MergeColumns   (INPUT 2, c-lbl-peso-liq, "subtitulo_direito_cinza"). 
            ASSIGN iColCount = iColCount + 1.                              
            RUN PrintDataString(INPUT "", "Default").
        
            RUN PrintDataString(INPUT c-lbl-vmcv,        "subtitulo_direito_cinza").  
            RUN PrintDataString(INPUT c-lbl-vmle,        "subtitulo_direito_cinza").  
            RUN PrintDataString(INPUT c-lbl-vmld,        "subtitulo_direito_cinza").  
            RUN MergeColumns   (INPUT 2, c-lbl-peso-liq, "subtitulo_direito_cinza").  
            ASSIGN iColCount = iColCount + 1.                              
            RUN PrintDataString(INPUT "", "Default").
        
            RUN PrintDataString(INPUT c-lbl-vmcv,        "subtitulo_direito_cinza").  
            RUN PrintDataString(INPUT c-lbl-vmle,        "subtitulo_direito_cinza").  
            RUN PrintDataString(INPUT c-lbl-vmld,        "subtitulo_direito_cinza").  
            RUN MergeColumns   (INPUT 2, c-lbl-peso-liq, "subtitulo_direito_cinza").  
            ASSIGN iColCount = iColCount + 1.                              
        RUN CloseLine.

        RUN OpenLine.
            RUN PrintDataNumber   (INPUT decla-import.val-vmcv-me[1], "numeroFormato2").
            RUN PrintDataNumber   (INPUT decla-import.val-vmle-me[1], "numeroFormato2").
            RUN PrintDataNumber   (INPUT decla-import.val-vmld-me[1], "numeroFormato2").
            RUN MergeColumnsNumber(INPUT 2, decla-import.val-peso-liq-di, "numeroFormato4").
            ASSIGN iColCount = iColCount + 1.                              
            RUN PrintDataString   (INPUT "", "Default").
            
            RUN PrintDataNumber   (INPUT decla-import.val-vmcv, "numeroFormato2"). 
            RUN PrintDataNumber   (INPUT decla-import.val-vmle, "numeroFormato2"). 
            RUN PrintDataNumber   (INPUT decla-import.val-vmld, "numeroFormato2"). 
            RUN MergeColumnsNumber(INPUT 2, decla-import.val-peso-liq-di, "numeroFormato4").
            ASSIGN iColCount = iColCount + 1.                              
            RUN PrintDataString   (INPUT "", "Default").
            
            RUN PrintDataNumber   (INPUT decla-import.val-vmcv-me[2], "numeroFormato2").  
            RUN PrintDataNumber   (INPUT decla-import.val-vmle-me[2], "numeroFormato2").  
            RUN PrintDataNumber   (INPUT decla-import.val-vmld-me[2], "numeroFormato2").  
            RUN MergeColumnsNumber(INPUT 2, decla-import.val-peso-liq-di, "numeroFormato4").
            ASSIGN iColCount = iColCount + 1.                              
        RUN CloseLine.

        RUN OpenLine.
            RUN MergeColumns (INPUT 19, "", "Default").
        RUN CloseLine.
        
        RUN OpenLine.
            RUN MergeColumns(INPUT 2, c-lbl-desp-decla-imp, "subtitulo").  
            ASSIGN iColCount = iColCount + 1.                              
            RUN MergeColumns(INPUT 3, "", "Default").    
            ASSIGN iColCount = iColCount + 1.                              
            RUN MergeColumns(INPUT 2, c-lbl-desp-decla-imp, "subtitulo").  
            ASSIGN iColCount = iColCount + 1.                              
            RUN MergeColumns(INPUT 3, "", "Default").    
            ASSIGN iColCount = iColCount + 1.                              
            RUN MergeColumns(INPUT 2, c-lbl-desp-decla-imp, "subtitulo").  
            ASSIGN iColCount = iColCount + 1.                              
            RUN MergeColumns(INPUT 2, "", "Default").
        RUN CloseLine.

        RUN OpenLine.
            RUN PrintDataString(INPUT c-lbl-incide-nf, "cabecalho").
            RUN PrintDataString(INPUT c-lbl-despesa, "cabecalho").
            RUN PrintDataString(INPUT c-lbl-valor, "subtitulo_direito_cinza").
            RUN PrintDataString(INPUT c-lbl-incide-vmle, "subtitulo_centro_cinza").
            RUN PrintDataString(INPUT c-lbl-va, "subtitulo_centro_cinza").
            RUN PrintDataString(INPUT c-lbl-fpc, "subtitulo_centro_cinza").
            RUN PrintDataString(INPUT "", "Default").

            RUN PrintDataString(INPUT c-lbl-incide-nf, "cabecalho").
            RUN PrintDataString(INPUT c-lbl-despesa, "cabecalho").
            RUN PrintDataString(INPUT c-lbl-valor, "subtitulo_direito_cinza").
            RUN PrintDataString(INPUT c-lbl-incide-vmle, "subtitulo_centro_cinza").
            RUN PrintDataString(INPUT c-lbl-va, "subtitulo_centro_cinza").
            RUN PrintDataString(INPUT c-lbl-fpc, "subtitulo_centro_cinza").
            RUN PrintDataString(INPUT "", "Default").

            RUN PrintDataString(INPUT c-lbl-incide-nf, "cabecalho").
            RUN PrintDataString(INPUT c-lbl-despesa, "cabecalho").
            RUN PrintDataString(INPUT c-lbl-valor, "subtitulo_direito_cinza").
            RUN PrintDataString(INPUT c-lbl-incide-vmle, "subtitulo_centro_cinza").
            RUN PrintDataString(INPUT c-lbl-va, "subtitulo_centro_cinza").
            RUN PrintDataString(INPUT c-lbl-fpc, "subtitulo_centro_cinza").
        RUN CloseLine.

        FOR FIRST decla-import-embarq FIELDS(cod-estab cod-embarq) NO-LOCK
            WHERE decla-import-embarq.num-di-ems       = despes-decla-import.num-di-ems
            AND   decla-import-embarq.cdd-siscomex-dts = despes-decla-import.cdd-siscomex-dts:
        END.

        FOR EACH despes-decla-import NO-LOCK
           WHERE despes-decla-import.num-di-ems       = decla-import.num-di-ems
           AND   despes-decla-import.cdd-siscomex-dts = decla-import.cdd-siscomex-dts:

            /* tipo incide nota fiscal */
            IF despes-decla-import.idi-tip-incid-nf = 1 THEN
                ASSIGN c-incide-nf = "Nacionaliza‡Æo".
            ELSE DO:
                IF despes-decla-import.idi-tip-incid-nf = 2 THEN
                    ASSIGN c-incide-nf = "Complementar".
            END.
            /* fim - tipo incide nota fiscal */

            /* va */
            FOR FIRST desp-imp NO-LOCK
                WHERE desp-imp.cod-desp = despes-decla-import.cdn-despes:

                &IF '{&BF_MAT_VERSAO_EMS}' >= '2.09' &THEN
                    ASSIGN c-va = desp-imp.log-incid-val-aduana.
                &ELSE
                    ASSIGN c-va = IF SUBSTRING(desp-imp.char-1,24,1) = '1' THEN YES ELSE NO.
                &ENDIF
            END. 
            /* fim - va*/
            
            /* despesa */
            FOR FIRST desp-embarque FIELDS(descricao) NO-LOCK
                WHERE desp-embarque.cod-estabel = decla-import-embarq.cod-estab
                  AND desp-embarque.embarque = decla-import-embarq.cod-embarq
                  AND desp-embarque.cod-desp = despes-decla-import.cdn-despes:
            END.

            ASSIGN  c-despesa = STRING(despes-decla-import.cdn-despes) + " - "
                    c-despesa = c-despesa + IF AVAIL desp-embarque AND desp-embarque.descricao <> "":U THEN desp-embarque.descricao ELSE desp-imp.descricao.
            /* fim - despesa */
                                                                                                        
            /* converte o valor da despesa */                                                        
            /* moeda negociada */
            RUN converteValorMoeda IN h-bocx383 (INPUT  decla-import.num-di-ems, 
                                                 INPUT  decla-import.cdd-siscomex-dts, 
                                                 INPUT  despes-decla-import.cdn-moeda,   /* moeda de origem */
                                                 INPUT  decla-import-adic.cdn-moeda,     /* moeda de destino */
                                                 INPUT  despes-decla-import.val-despes,  /* valor da despesa */
                                                 INPUT  decla-import.dat-di,             /* data da di  */
                                                 OUTPUT d-val-despes-moed-negoc).
            /* moeda nacional */ 
            RUN converteValorMoeda IN h-bocx383 (INPUT  decla-import.num-di-ems, 
                                                 INPUT  decla-import.cdd-siscomex-dts,
                                                 INPUT  despes-decla-import.cdn-moeda,   /* moeda de origem */
                                                 INPUT  0,                               /* moeda de destino (0 - real)*/
                                                 INPUT  despes-decla-import.val-despes,  /* valor da despesa */
                                                 INPUT  decla-import.dat-di,             /* data da di  */
                                                 OUTPUT d-val-despes-moed-nac).
            /* moeda param */
            RUN converteValorMoeda IN h-bocx383 (INPUT  decla-import.num-di-ems, 
                                                 INPUT  decla-import.cdd-siscomex-dts,
                                                 INPUT  despes-decla-import.cdn-moeda,   /* moeda de origem */
                                                 INPUT  param-imp.int-2,                 /* moeda de destino */
                                                 INPUT  despes-decla-import.val-despes,  /* valor da despesa */
                                                 INPUT  decla-import.dat-di,             /* data da di  */
                                                 OUTPUT d-val-despes-moed-param).
            /* fim - converte o valor da despesa */

            RUN OpenLine.
                RUN PrintDataString(INPUT c-incide-nf                                              , "padrao").
                RUN PrintDataString(INPUT c-despesa                                                , "padrao").
                RUN PrintDataNumber(INPUT d-val-despes-moed-negoc                                  , "numeroFormato2").
                RUN PrintDataString(INPUT string(despes-decla-import.log-incid-vmle,"S/N")         , "logicos").
                RUN PrintDataString(INPUT string(c-va,"S/N")                                       , "logicos").
                RUN PrintDataString(INPUT string(despes-decla-import.log-forma-preco-compra,"S/N") , "logicos"). /* FPC */
                RUN PrintDataString(INPUT ""                                                       , "Default").
    
                RUN PrintDataString(INPUT c-incide-nf                                              , "padrao"). 
                RUN PrintDataString(INPUT c-despesa                                                , "padrao"). 
                RUN PrintDataNumber(INPUT d-val-despes-moed-nac                                    , "numeroFormato2"). 
                RUN PrintDataString(INPUT string(despes-decla-import.log-incid-vmle,"S/N")         , "logicos").
                RUN PrintDataString(INPUT string(c-va,"S/N")                                       , "logicos"). 
                RUN PrintDataString(INPUT string(despes-decla-import.log-forma-preco-compra,"S/N") , "logicos"). /* FPC */
                RUN PrintDataString(INPUT ""                                                       , "Default").
                                                                                                 
                RUN PrintDataString(INPUT c-incide-nf                                              , "padrao"). 
                RUN PrintDataString(INPUT c-despesa                                                , "padrao"). 
                RUN PrintDataNumber(INPUT d-val-despes-moed-param                                  , "numeroFormato2"). 
                RUN PrintDataString(INPUT string(despes-decla-import.log-incid-vmle,"S/N")         , "logicos").
                RUN PrintDataString(INPUT string(c-va,"S/N")                                       , "logicos"). 
                RUN PrintDataString(INPUT string(despes-decla-import.log-forma-preco-compra,"S/N") , "logicos"). /* FPC */
            RUN CloseLine.
        END.

        RUN OpenLine.
            RUN MergeColumns(INPUT 19, ""                                                          , "Default").
        RUN CloseLine.

        RUN OpenLine.
            RUN MergeColumns(INPUT 2, c-lbl-impostos-di, "subtitulo").  
            ASSIGN iColCount = iColCount + 1.                              
            RUN MergeColumns(INPUT 3, "", "Default").    
            ASSIGN iColCount = iColCount + 1.
            RUN MergeColumns(INPUT 2, c-lbl-impostos-di, "subtitulo").  
            ASSIGN iColCount = iColCount + 1.                              
            RUN MergeColumns(INPUT 3, "", "Default").    
            ASSIGN iColCount = iColCount + 1.                              
            RUN MergeColumns(INPUT 2, c-lbl-impostos-di, "subtitulo").  
            ASSIGN iColCount = iColCount + 1.                              
            RUN MergeColumns(INPUT 2, "", "Default").
        RUN CloseLine.

        RUN OpenLine.
            RUN PrintDataString(INPUT c-lbl-coluna,         "subtitulo_direito_cinza").
            RUN MergeColumns(INPUT 1, c-lbl-trib-reduz-DI,  "subtitulo_direito_cinza").
            ASSIGN iColCount = iColCount + 1.                              
            RUN MergeColumns(INPUT 1, c-lbl-isento-DI,      "subtitulo_direito_cinza").
            ASSIGN iColCount = iColCount + 1.                              
            RUN PrintDataString(INPUT c-lbl-outros-DI,      "subtitulo_direito_cinza").
            RUN PrintDataString(INPUT "",                   "Default").

            RUN PrintDataString(INPUT c-lbl-coluna,         "subtitulo_direito_cinza").
            RUN MergeColumns(INPUT 1, c-lbl-trib-reduz-DI,  "subtitulo_direito_cinza").
            ASSIGN iColCount = iColCount + 1.                              
            RUN MergeColumns(INPUT 1, c-lbl-isento-DI,      "subtitulo_direito_cinza").
            ASSIGN iColCount = iColCount + 1.                              
            RUN PrintDataString(INPUT c-lbl-outros-DI,      "subtitulo_direito_cinza").
            RUN PrintDataString(INPUT "",                   "Default").

            RUN PrintDataString(INPUT c-lbl-coluna,         "subtitulo_direito_cinza").
            RUN MergeColumns(INPUT 1, c-lbl-trib-reduz-DI,  "subtitulo_direito_cinza").
            ASSIGN iColCount = iColCount + 1.                              
            RUN MergeColumns(INPUT 1, c-lbl-isento-DI,      "subtitulo_direito_cinza").
            ASSIGN iColCount = iColCount + 1.                              
            RUN PrintDataString(INPUT c-lbl-outros-DI,      "subtitulo_direito_cinza").
        RUN CloseLine.

        /* II */
        RUN OpenLine.
            RUN PrintDataString(INPUT c-lbl-II, "subtitulo_direito").
            RUN MergeColumnsNumber(INPUT 1, decla-import.val-ii-db-cr, "numeroFormato2").
            ASSIGN iColCount = iColCount + 1.                              
            RUN MergeColumnsNumber(INPUT 1, decla-import.val-ii-nao-tribut, "numeroFormato2").
            ASSIGN iColCount = iColCount + 1.                              
            RUN PrintDataNumber(INPUT decla-import.val-ii-outras, "numeroFormato2").
            RUN PrintDataString(INPUT "", "Default").

            RUN PrintDataString(INPUT c-lbl-II, "subtitulo_direito").
            RUN MergeColumnsNumber(INPUT 1, decla-import.val-ii-db-cr, "numeroFormato2").
            ASSIGN iColCount = iColCount + 1.                              
            RUN MergeColumnsNumber(INPUT 1, decla-import.val-ii-nao-tribut, "numeroFormato2").
            ASSIGN iColCount = iColCount + 1.                              
            RUN PrintDataNumber(INPUT decla-import.val-ii-outras, "numeroFormato2").
            RUN PrintDataString(INPUT "", "Default").

            RUN PrintDataString(INPUT c-lbl-II, "subtitulo_direito").
            RUN MergeColumnsNumber(INPUT 1, decla-import.val-ii-db-cr, "numeroFormato2").
            ASSIGN iColCount = iColCount + 1.                              
            RUN MergeColumnsNumber(INPUT 1, decla-import.val-ii-nao-tribut, "numeroFormato2").
            ASSIGN iColCount = iColCount + 1.                              
            RUN PrintDataNumber(INPUT decla-import.val-ii-outras, "numeroFormato2").
        RUN CloseLine.

        /* IPI */
        RUN OpenLine.
            RUN PrintDataString(INPUT c-lbl-IPI, "subtitulo_direito"). /* imposto       */
            RUN MergeColumnsNumber(INPUT 1, decla-import.val-ipi-db-cr, "numeroFormato2").
            ASSIGN iColCount = iColCount + 1.                              
            RUN MergeColumnsNumber(INPUT 1, decla-import.val-ipi-nao-tribut, "numeroFormato2").
            ASSIGN iColCount = iColCount + 1.                              
            RUN PrintDataNumber(INPUT decla-import.val-ipi-outras, "numeroFormato2").
            RUN PrintDataString(INPUT ""       , "Default").                           

            RUN PrintDataString(INPUT c-lbl-IPI, "subtitulo_direito"). /* imposto       */
            RUN MergeColumnsNumber(INPUT 1, decla-import.val-ipi-db-cr, "numeroFormato2").
            ASSIGN iColCount = iColCount + 1.                              
            RUN MergeColumnsNumber(INPUT 1, decla-import.val-ipi-nao-tribut, "numeroFormato2").
            ASSIGN iColCount = iColCount + 1.                              
            RUN PrintDataNumber(INPUT decla-import.val-ipi-outras, "numeroFormato2").
            RUN PrintDataString(INPUT ""       , "Default").                           

            RUN PrintDataString(INPUT c-lbl-IPI, "subtitulo_direito"). /* imposto       */
            RUN MergeColumnsNumber(INPUT 1, decla-import.val-ipi-db-cr, "numeroFormato2").
            ASSIGN iColCount = iColCount + 1.                              
            RUN MergeColumnsNumber(INPUT 1, decla-import.val-ipi-nao-tribut, "numeroFormato2").
            ASSIGN iColCount = iColCount + 1.                              
            RUN PrintDataNumber(INPUT decla-import.val-ipi-outras, "numeroFormato2").
        RUN CloseLine.

        /* PIS */
        RUN OpenLine.
            RUN PrintDataString(INPUT c-lbl-PIS, "subtitulo_direito"). /* imposto       */
            RUN MergeColumnsNumber(INPUT 1, decla-import.val-pis-db-cr, "numeroFormato2").
            ASSIGN iColCount = iColCount + 1.                              
            RUN MergeColumnsNumber(INPUT 1, decla-import.val-pis-nao-tribut, "numeroFormato2").
            ASSIGN iColCount = iColCount + 1.                              
            RUN PrintDataNumber(INPUT decla-import.val-pis-outras, "numeroFormato2").
            RUN PrintDataString(INPUT ""       , "Default").                           

            RUN PrintDataString(INPUT c-lbl-PIS, "subtitulo_direito"). /* imposto       */
            RUN MergeColumnsNumber(INPUT 1, decla-import.val-pis-db-cr, "numeroFormato2").
            ASSIGN iColCount = iColCount + 1.                              
            RUN MergeColumnsNumber(INPUT 1, decla-import.val-pis-nao-tribut, "numeroFormato2").
            ASSIGN iColCount = iColCount + 1.                              
            RUN PrintDataNumber(INPUT decla-import.val-pis-outras, "numeroFormato2").
            RUN PrintDataString(INPUT ""       , "Default").                           

            RUN PrintDataString(INPUT c-lbl-PIS, "subtitulo_direito"). /* imposto       */
            RUN MergeColumnsNumber(INPUT 1, decla-import.val-pis-db-cr, "numeroFormato2").
            ASSIGN iColCount = iColCount + 1.                              
            RUN MergeColumnsNumber(INPUT 1, decla-import.val-pis-nao-tribut, "numeroFormato2").
            ASSIGN iColCount = iColCount + 1.                              
            RUN PrintDataNumber(INPUT decla-import.val-pis-outras, "numeroFormato2").
        RUN CloseLine.

        /* COFINS */
        RUN OpenLine.
            RUN PrintDataString(INPUT c-lbl-COFINS, "subtitulo_direito"). /* imposto       */
            RUN MergeColumnsNumber(INPUT 1, decla-import.val-cofins-db-cr, "numeroFormato2").
            ASSIGN iColCount = iColCount + 1.                              
            RUN MergeColumnsNumber(INPUT 1, decla-import.val-cofins-nao-tribut, "numeroFormato2").
            ASSIGN iColCount = iColCount + 1.                              
            RUN PrintDataNumber(INPUT decla-import.val-cofins-outras, "numeroFormato2").
            RUN PrintDataString(INPUT ""          , "Default").                           

            RUN PrintDataString(INPUT c-lbl-COFINS, "subtitulo_direito"). /* imposto       */
            RUN MergeColumnsNumber(INPUT 1, decla-import.val-cofins-db-cr, "numeroFormato2").
            ASSIGN iColCount = iColCount + 1.                              
            RUN MergeColumnsNumber(INPUT 1, decla-import.val-cofins-nao-tribut, "numeroFormato2").
            ASSIGN iColCount = iColCount + 1.                              
            RUN PrintDataNumber(INPUT decla-import.val-cofins-outras, "numeroFormato2").
            RUN PrintDataString(INPUT ""          , "Default").                           

            RUN PrintDataString(INPUT c-lbl-COFINS, "subtitulo_direito"). /* imposto       */
            RUN MergeColumnsNumber(INPUT 1, decla-import.val-cofins-db-cr, "numeroFormato2").
            ASSIGN iColCount = iColCount + 1.                              
            RUN MergeColumnsNumber(INPUT 1, decla-import.val-cofins-nao-tribut, "numeroFormato2").
            ASSIGN iColCount = iColCount + 1.                              
            RUN PrintDataNumber(INPUT decla-import.val-cofins-outras, "numeroFormato2").
        RUN CloseLine.

        /* ICMS */
        RUN OpenLine.
            RUN PrintDataString(INPUT c-lbl-ICMS, "subtitulo_direito").  /* imposto       */
            RUN MergeColumnsNumber(INPUT 1, decla-import.val-icms-db-cr, "numeroFormato2").
            ASSIGN iColCount = iColCount + 1.                              
            RUN MergeColumnsNumber(INPUT 1, decla-import.val-icms-nao-tribut, "numeroFormato2").
            ASSIGN iColCount = iColCount + 1.                              
            RUN PrintDataNumber(INPUT decla-import.val-icms-outras, "numeroFormato2").
            RUN PrintDataString(INPUT ""        , "Default").                           

            RUN PrintDataString(INPUT c-lbl-ICMS, "subtitulo_direito").  /* imposto       */
            RUN MergeColumnsNumber(INPUT 1, decla-import.val-icms-db-cr, "numeroFormato2").
            ASSIGN iColCount = iColCount + 1.                              
            RUN MergeColumnsNumber(INPUT 1, decla-import.val-icms-nao-tribut, "numeroFormato2").
            ASSIGN iColCount = iColCount + 1.                              
            RUN PrintDataNumber(INPUT decla-import.val-icms-outras, "numeroFormato2").
            RUN PrintDataString(INPUT ""        , "Default").                           

            RUN PrintDataString(INPUT c-lbl-ICMS, "subtitulo_direito").  /* imposto       */
            RUN MergeColumnsNumber(INPUT 1, decla-import.val-icms-db-cr, "numeroFormato2").
            ASSIGN iColCount = iColCount + 1.                              
            RUN MergeColumnsNumber(INPUT 1, decla-import.val-icms-nao-tribut, "numeroFormato2").
            ASSIGN iColCount = iColCount + 1.                              
            RUN PrintDataNumber(INPUT decla-import.val-icms-outras, "numeroFormato2").
        RUN CloseLine.
        
        IF l-nt2024002 THEN DO:
            ASSIGN v-val-ibsuf-T-DI  = 0
                   v-val-ibsuf-I-DI  = 0
                   v-val-ibsuf-O-DI  = 0
                   v-val-cbs-T-DI    = 0
                   v-val-cbs-I-DI    = 0
                   v-val-cbs-O-DI    = 0
                   v-val-ibsmun-T-DI = 0
                   v-val-ibsmun-I-DI = 0
                   v-val-ibsmun-O-DI = 0
                   v-val-is-T-DI     = 0
                   v-val-is-I-DI     = 0
                   v-val-is-O-DI     = 0.
            FOR EACH decla-import-trib NO-LOCK
               WHERE decla-import-trib.num-di-ems       = decla-import.num-di-ems
                 AND decla-import-trib.num-seq-retif    = decla-import.num-seq-retif
                 AND decla-import-trib.cdd-siscomex-dts = decla-import.cdd-siscomex-dts:
                CASE decla-import-trib.nom-trib:
                    WHEN "IBSUF":U THEN
                        CASE decla-import-trib.cod-campo:
                            WHEN "VALOR":U THEN ASSIGN v-val-ibsuf-T-DI = DECIMAL(REPLACE(decla-import-trib.cod-conteudo,',','.')).
                            //WHEN "SUSPENSO":U THEN ASSIGN v-val-ibsuf-I-DI = DECIMAL(REPLACE(decla-import-trib.cod-conteudo,',','.')).
                            WHEN "OUTROS":U THEN   ASSIGN v-val-ibsuf-O-DI = DECIMAL(REPLACE(decla-import-trib.cod-conteudo,',','.')).
                        END CASE.
                    WHEN "IBSMUN":U THEN
                        CASE decla-import-trib.cod-campo:
                            WHEN "VALOR":U THEN ASSIGN v-val-ibsmun-T-DI = DECIMAL(REPLACE(decla-import-trib.cod-conteudo,',','.')).
                            WHEN "OUTROS":U THEN   ASSIGN v-val-ibsmun-O-DI = DECIMAL(REPLACE(decla-import-trib.cod-conteudo,',','.')).
                        END CASE.
                    WHEN "CBS":U THEN
                        CASE decla-import-trib.cod-campo:
                            WHEN "VALOR":U THEN ASSIGN v-val-cbs-T-DI = DECIMAL(REPLACE(decla-import-trib.cod-conteudo,',','.')).
                            //WHEN "SUSPENSO":U THEN ASSIGN v-val-cbs-I-DI = DECIMAL(REPLACE(decla-import-trib.cod-conteudo,',','.')).
                            WHEN "OUTROS":U THEN   ASSIGN v-val-cbs-O-DI = DECIMAL(REPLACE(decla-import-trib.cod-conteudo,',','.')).
                        END CASE.
                    WHEN "IS":U THEN
                        CASE decla-import-trib.cod-campo:
                            WHEN "VALOR":U THEN  ASSIGN v-val-is-T-DI = DECIMAL(REPLACE(decla-import-trib.cod-conteudo,',','.')).
                            WHEN "OUTROS":U THEN ASSIGN v-val-is-O-DI = DECIMAL(REPLACE(decla-import-trib.cod-conteudo,',','.')).
                        END CASE.
                END CASE.                
            END.
            
            /* IBS UF */
            RUN OpenLine.
            RUN PrintDataString(INPUT "IBS UF":U, "subtitulo_direito").  /* imposto       */
            RUN MergeColumnsNumber(INPUT 1, v-val-ibsuf-T-DI, "numeroFormato2").
            ASSIGN iColCount = iColCount + 1.                              
            RUN MergeColumnsNumber(INPUT 1, v-val-ibsuf-I-DI, "numeroFormato2").
            ASSIGN iColCount = iColCount + 1.                              
            RUN PrintDataNumber(INPUT v-val-ibsuf-O-DI, "numeroFormato2").
            RUN PrintDataString(INPUT ""        , "Default").                           

            RUN PrintDataString(INPUT "IBS UF":U, "subtitulo_direito").  /* imposto       */
            RUN MergeColumnsNumber(INPUT 1, v-val-ibsuf-T-DI, "numeroFormato2").
            ASSIGN iColCount = iColCount + 1.                              
            RUN MergeColumnsNumber(INPUT 1, v-val-ibsuf-I-DI, "numeroFormato2").
            ASSIGN iColCount = iColCount + 1.                              
            RUN PrintDataNumber(INPUT v-val-ibsuf-O-DI, "numeroFormato2").
            RUN PrintDataString(INPUT ""        , "Default").                           

            RUN PrintDataString(INPUT "IBS UF":U, "subtitulo_direito").  /* imposto       */
            RUN MergeColumnsNumber(INPUT 1, v-val-ibsuf-T-DI, "numeroFormato2").
            ASSIGN iColCount = iColCount + 1.                              
            RUN MergeColumnsNumber(INPUT 1, v-val-ibsuf-I-DI, "numeroFormato2").
            ASSIGN iColCount = iColCount + 1.                              
            RUN PrintDataNumber(INPUT v-val-ibsuf-O-DI, "numeroFormato2").
            RUN CloseLine.

            /* IBS Mun */
            RUN OpenLine.
            RUN PrintDataString(INPUT "IBS Mun":U, "subtitulo_direito").  /* imposto       */
            RUN MergeColumnsNumber(INPUT 1, v-val-ibsmun-T-DI, "numeroFormato2").
            ASSIGN iColCount = iColCount + 1.                              
            RUN MergeColumnsNumber(INPUT 1, v-val-ibsmun-I-DI, "numeroFormato2").
            ASSIGN iColCount = iColCount + 1.                              
            RUN PrintDataNumber(INPUT v-val-ibsmun-O-DI, "numeroFormato2").
            RUN PrintDataString(INPUT ""        , "Default").                           

            RUN PrintDataString(INPUT "IBS Mun":U, "subtitulo_direito").  /* imposto       */
            RUN MergeColumnsNumber(INPUT 1, v-val-ibsmun-T-DI, "numeroFormato2").
            ASSIGN iColCount = iColCount + 1.                              
            RUN MergeColumnsNumber(INPUT 1, v-val-ibsmun-I-DI, "numeroFormato2").
            ASSIGN iColCount = iColCount + 1.                              
            RUN PrintDataNumber(INPUT v-val-ibsmun-O-DI, "numeroFormato2").
            RUN PrintDataString(INPUT ""        , "Default").                           

            RUN PrintDataString(INPUT "IBS Mun":U, "subtitulo_direito").  /* imposto       */
            RUN MergeColumnsNumber(INPUT 1, v-val-ibsmun-T-DI, "numeroFormato2").
            ASSIGN iColCount = iColCount + 1.                              
            RUN MergeColumnsNumber(INPUT 1, v-val-ibsmun-I-DI, "numeroFormato2").
            ASSIGN iColCount = iColCount + 1.                              
            RUN PrintDataNumber(INPUT v-val-ibsmun-O-DI, "numeroFormato2").
            RUN CloseLine.

            /* CBS */            
            RUN OpenLine.
            RUN PrintDataString(INPUT "CBS":U, "subtitulo_direito").  /* imposto       */
            RUN MergeColumnsNumber(INPUT 1, v-val-cbs-T-DI, "numeroFormato2").
            ASSIGN iColCount = iColCount + 1.                              
            RUN MergeColumnsNumber(INPUT 1, v-val-cbs-I-DI, "numeroFormato2").
            ASSIGN iColCount = iColCount + 1.                              
            RUN PrintDataNumber(INPUT v-val-cbs-O-DI, "numeroFormato2").
            RUN PrintDataString(INPUT ""        , "Default").                           

            RUN PrintDataString(INPUT "CBS":U, "subtitulo_direito").  /* imposto       */
            RUN MergeColumnsNumber(INPUT 1, v-val-cbs-T-DI, "numeroFormato2").
            ASSIGN iColCount = iColCount + 1.                              
            RUN MergeColumnsNumber(INPUT 1, v-val-cbs-I-DI, "numeroFormato2").
            ASSIGN iColCount = iColCount + 1.                              
            RUN PrintDataNumber(INPUT v-val-cbs-O-DI, "numeroFormato2").
            RUN PrintDataString(INPUT ""        , "Default").                           

            RUN PrintDataString(INPUT "CBS":U, "subtitulo_direito").  /* imposto       */
            RUN MergeColumnsNumber(INPUT 1, v-val-cbs-T-DI, "numeroFormato2").
            ASSIGN iColCount = iColCount + 1.                              
            RUN MergeColumnsNumber(INPUT 1, v-val-cbs-I-DI, "numeroFormato2").
            ASSIGN iColCount = iColCount + 1.                              
            RUN PrintDataNumber(INPUT v-val-cbs-O-DI, "numeroFormato2").
            RUN CloseLine.
            
            /* IS */            
            RUN OpenLine.
            RUN PrintDataString(INPUT "IS":U, "subtitulo_direito").  /* imposto       */
            RUN MergeColumnsNumber(INPUT 1, v-val-is-T-DI, "numeroFormato2").
            ASSIGN iColCount = iColCount + 1.                              
            RUN MergeColumnsNumber(INPUT 1, v-val-is-I-DI, "numeroFormato2").
            ASSIGN iColCount = iColCount + 1.                              
            RUN PrintDataNumber(INPUT v-val-is-O-DI, "numeroFormato2").
            RUN PrintDataString(INPUT ""        , "Default").                           

            RUN PrintDataString(INPUT "IS":U, "subtitulo_direito").  /* imposto       */
            RUN MergeColumnsNumber(INPUT 1, v-val-is-T-DI, "numeroFormato2").
            ASSIGN iColCount = iColCount + 1.                              
            RUN MergeColumnsNumber(INPUT 1, v-val-is-I-DI, "numeroFormato2").
            ASSIGN iColCount = iColCount + 1.                              
            RUN PrintDataNumber(INPUT v-val-is-O-DI, "numeroFormato2").
            RUN PrintDataString(INPUT ""        , "Default").                           

            RUN PrintDataString(INPUT "IS":U, "subtitulo_direito").  /* imposto       */
            RUN MergeColumnsNumber(INPUT 1, v-val-is-T-DI, "numeroFormato2").
            ASSIGN iColCount = iColCount + 1.                              
            RUN MergeColumnsNumber(INPUT 1, v-val-is-I-DI, "numeroFormato2").
            ASSIGN iColCount = iColCount + 1.                              
            RUN PrintDataNumber(INPUT v-val-is-O-DI, "numeroFormato2").
            RUN CloseLine.
        END.

        RUN OpenLine.
            RUN MergeColumns(INPUT 19, "" , "Default").
        RUN CloseLine.

        RUN OpenLine.
            RUN MergeColumns(INPUT 19, "Adi‡äes" , "divisoria").
        RUN CloseLine.
        
        FOR EACH decla-import-adic NO-LOCK
                WHERE decla-import-adic.num-di-ems       = decla-import.num-di-ems
                AND   decla-import-adic.cdd-siscomex-dts = decla-import.cdd-siscomex-dts:
        
            ASSIGN c-lbl-adic         = "Adi‡Æo Nr. "             + STRING(decla-import-adic.num-adic)
                   c-lbl-desp-adic     = "Despesas da Adi‡Æo Nr. " + STRING(decla-import-adic.num-adic)
                   c-lbl-impostos-adic = "Impostos da Adi‡Æo Nr. " + STRING(decla-import-adic.num-adic).

            RUN OpenLine.
                RUN MergeColumns(INPUT 19, ""                             , "Default").
            RUN CloseLine.
            /*
            RUN OpenLine.
                RUN MergeColumns(INPUT 16, "", "Default").
            RUN CloseLine.
            */

            /* adi‡Æo */
            RUN OpenLine.
                RUN MergeColumns   (INPUT 1, c-lbl-adic , "subtitulo_adicao").
                ASSIGN iColCount = iColCount + 1.       
                RUN MergeColumns   (INPUT 4, ""         , "Default").
                ASSIGN iColCount = iColCount + 1.       
                RUN MergeColumns   (INPUT 1, c-lbl-adic , "subtitulo_adicao").
                ASSIGN iColCount = iColCount + 1.       
                RUN MergeColumns   (INPUT 4, ""         , "Default").
                ASSIGN iColCount = iColCount + 1.       
                RUN MergeColumns   (INPUT 1, c-lbl-adic , "subtitulo_adicao").
            RUN CloseLine.
    
            RUN OpenLine.
                RUN PrintDataString(INPUT c-lbl-vmcv,        "subtitulo_direito_azul").   
                RUN PrintDataString(INPUT c-lbl-vmle,        "subtitulo_direito_azul").   
                RUN PrintDataString(INPUT c-lbl-vmld,        "subtitulo_direito_azul").   
                RUN MergeColumns   (INPUT 2, c-lbl-peso-liq, "subtitulo_direito_azul").   
                ASSIGN iColCount = iColCount + 1.                              
                RUN PrintDataString(INPUT "", "Default").
    
                RUN PrintDataString(INPUT c-lbl-vmcv,        "subtitulo_direito_azul").   
                RUN PrintDataString(INPUT c-lbl-vmle,        "subtitulo_direito_azul").   
                RUN PrintDataString(INPUT c-lbl-vmld,        "subtitulo_direito_azul").   
                RUN MergeColumns   (INPUT 2, c-lbl-peso-liq, "subtitulo_direito_azul").   
                ASSIGN iColCount = iColCount + 1.                              
                RUN PrintDataString(INPUT "", "Default").
    
                RUN PrintDataString(INPUT c-lbl-vmcv,        "subtitulo_direito_azul").   
                RUN PrintDataString(INPUT c-lbl-vmle,        "subtitulo_direito_azul").   
                RUN PrintDataString(INPUT c-lbl-vmld,        "subtitulo_direito_azul").   
                RUN MergeColumns   (INPUT 2, c-lbl-peso-liq, "subtitulo_direito_azul").   
                ASSIGN iColCount = iColCount + 1.                              
            RUN CloseLine.
    
            RUN OpenLine.
                RUN PrintDataNumber(INPUT decla-import-adic.val-vmcv-me[1]              , "numeroFormato2").
                RUN PrintDataNumber(INPUT decla-import-adic.val-vmle-me[1]              , "numeroFormato2").
                RUN PrintDataNumber(INPUT decla-import-adic.val-vmld-me[1]              , "numeroFormato2").
                RUN MergeColumnsNumber(INPUT 2, decla-import-adic.val-peso-liq, "numeroFormato4").
                ASSIGN iColCount = iColCount + 1.                              
                RUN PrintDataString   (INPUT "", "Default").
    
                RUN PrintDataNumber(INPUT decla-import-adic.val-vmcv                    , "numeroFormato2").
                RUN PrintDataNumber(INPUT decla-import-adic.val-vmle                    , "numeroFormato2").
                RUN PrintDataNumber(INPUT decla-import-adic.val-vmld                    , "numeroFormato2").
                RUN MergeColumnsNumber(INPUT 2, decla-import-adic.val-peso-liq, "numeroFormato4").
                ASSIGN iColCount = iColCount + 1.                              
                RUN PrintDataString   (INPUT "", "Default").
    
                RUN PrintDataNumber(INPUT decla-import-adic.val-vmcv-me[2]              , "numeroFormato2").
                RUN PrintDataNumber(INPUT decla-import-adic.val-vmle-me[2]              , "numeroFormato2").
                RUN PrintDataNumber(INPUT decla-import-adic.val-vmld-me[2]              , "numeroFormato2").
                RUN MergeColumnsNumber(INPUT 2, decla-import-adic.val-peso-liq, "numeroFormato4").
                ASSIGN iColCount = iColCount + 1.                              
            RUN CloseLine.
            /* fim - adi‡Æo */
    
            RUN OpenLine.
                RUN MergeColumns(INPUT 19, ""                             , "Default").
            RUN CloseLine.
    

            /* despesas da adicao */
            IF CAN-FIND(FIRST despes-adic
                            WHERE despes-adic.num-di-ems       = decla-import-adic.num-di-ems
                            AND   despes-adic.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts
                            AND   despes-adic.num-adic         = decla-import-adic.num-adic) THEN DO:
                RUN OpenLine.
                    RUN MergeColumns(INPUT 2, c-lbl-desp-adic  , "subtitulo_adicao").
                    ASSIGN iColCount = iColCount + 1.
                    RUN MergeColumns(INPUT 3, ""                                            , "Default").
                    ASSIGN iColCount = iColCount + 1.
                    RUN MergeColumns(INPUT 2, c-lbl-desp-adic  , "subtitulo_adicao").
                    ASSIGN iColCount = iColCount + 1.
                    RUN MergeColumns(INPUT 3, ""                                            , "Default").
                    ASSIGN iColCount = iColCount + 1.
                    RUN MergeColumns(INPUT 2, c-lbl-desp-adic  , "subtitulo_adicao").
                    ASSIGN iColCount = iColCount + 1.
                    RUN MergeColumns(INPUT 2, ""                                            , "Default").
                RUN CloseLine.
        
                RUN OpenLine.
                    RUN PrintDataString(INPUT c-lbl-incide-nf                               , "cabecalho_adicao").
                    RUN PrintDataString(INPUT c-lbl-despesa                                 , "cabecalho_adicao").
                    RUN PrintDataString(INPUT c-lbl-valor      , "subtitulo_direito_azul").
                    RUN PrintDataString(INPUT c-lbl-incide-vmle, "subtitulo_centro_azul").
                    RUN PrintDataString(INPUT c-lbl-va         , "subtitulo_centro_azul").
                    RUN PrintDataString(INPUT c-lbl-fpc        , "subtitulo_centro_azul").
                    RUN PrintDataString(INPUT ""               , "Default").
        
                    RUN PrintDataString(INPUT c-lbl-incide-nf                               , "cabecalho_adicao").
                    RUN PrintDataString(INPUT c-lbl-despesa                                 , "cabecalho_adicao").
                    RUN PrintDataString(INPUT c-lbl-valor      , "subtitulo_direito_azul").
                    RUN PrintDataString(INPUT c-lbl-incide-vmle, "subtitulo_centro_azul").
                    RUN PrintDataString(INPUT c-lbl-va         , "subtitulo_centro_azul").
                    RUN PrintDataString(INPUT c-lbl-fpc        , "subtitulo_centro_azul").
                    RUN PrintDataString(INPUT ""               , "Default").
        
                    RUN PrintDataString(INPUT c-lbl-incide-nf                               , "cabecalho_adicao").
                    RUN PrintDataString(INPUT c-lbl-despesa                                 , "cabecalho_adicao").
                    RUN PrintDataString(INPUT c-lbl-valor      , "subtitulo_direito_azul").
                    RUN PrintDataString(INPUT c-lbl-incide-vmle, "subtitulo_centro_azul").
                    RUN PrintDataString(INPUT c-lbl-va         , "subtitulo_centro_azul").
                    RUN PrintDataString(INPUT c-lbl-fpc        , "subtitulo_centro_azul").
                RUN CloseLine.
        
                FOR FIRST decla-import-embarq FIELDS(cod-estab cod-embarq) NO-LOCK
                    WHERE decla-import-embarq.num-di-ems       = decla-import-adic.num-di-ems
                    AND   decla-import-embarq.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts:
                END.   
    
                FOR EACH despes-adic NO-LOCK
                        WHERE despes-adic.num-di-ems       = decla-import-adic.num-di-ems
                        AND   despes-adic.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts
                        AND   despes-adic.num-adic         = decla-import-adic.num-adic:
    
                    /* va */
                    FOR FIRST desp-imp NO-LOCK
                        WHERE desp-imp.cod-desp = despes-adic.cdn-despes:
        
                        &IF '{&BF_MAT_VERSAO_EMS}' >= '2.09' &THEN
                            ASSIGN c-va-adic = desp-imp.log-incid-val-aduana.
                        &ELSE
                            ASSIGN c-va-adic = IF SUBSTRING(desp-imp.char-1,24,1) = '1' THEN YES ELSE NO.
                        &ENDIF
                    END. 
                    /* fim - va*/
    
                    /* despesa */
                    FOR FIRST desp-embarque FIELDS(descricao) NO-LOCK
                        WHERE desp-embarque.cod-estabel = decla-import-embarq.cod-estab
                          AND desp-embarque.embarque = decla-import-embarq.cod-embarq
                          AND desp-embarque.cod-desp = despes-decla-import.cdn-despes:
                    END.
                    ASSIGN  c-despesa-adic = STRING(despes-adic.cdn-despes) + " - " + IF AVAIL desp-embarque AND desp-embarque.descricao <> "":U THEN desp-embarque.descricao ELSE desp-imp.descricao.
                    /* fim - despesa */

                    /* converte o valor da despesa da adicao */                                                        
                    /* moeda negociada */
                    RUN converteValorMoeda IN h-bocx383 (INPUT decla-import.num-di-ems, 
                                                         INPUT decla-import.cdd-siscomex-dts, 
                                                         INPUT despes-adic.cdn-moeda,           /* moeda de origem */
                                                         INPUT decla-import-adic.cdn-moeda,     /* moeda de destino */
                                                         INPUT despes-adic.val-despes,          /* valor da despesa */
                                                         INPUT decla-import.dat-di,             /* data da di  */
                                                         OUTPUT d-val-despes-adic-moed-negoc).
        
                    /* moeda nacional */ 
                    RUN converteValorMoeda IN h-bocx383 (INPUT decla-import.num-di-ems, 
                                                         INPUT decla-import.cdd-siscomex-dts, 
                                                         INPUT despes-adic.cdn-moeda,           /* moeda de origem */
                                                         INPUT 0,                               /* moeda de destino (0 - real)*/
                                                         INPUT despes-adic.val-despes,          /* valor da despesa */
                                                         INPUT decla-import.dat-di,             /* data da di  */
                                                         OUTPUT d-val-despes-adic-moed-nac).
        
                    /* moeda param */
                    RUN converteValorMoeda IN h-bocx383 (INPUT decla-import.num-di-ems, 
                                                         INPUT decla-import.cdd-siscomex-dts, 
                                                         INPUT despes-adic.cdn-moeda,           /* moeda de origem */
                                                         INPUT param-imp.int-2,                 /* moeda de destino */
                                                         INPUT despes-adic.val-despes,          /* valor da despesa */
                                                         INPUT decla-import.dat-di,             /* data da di  */
                                                         OUTPUT d-val-despes-adic-moed-param).
        
                    /* fim - converte o valor da despesa da adicao */
    
                    RUN OpenLine.
                        RUN PrintDataString(INPUT c-incide-nf                                     , "padrao").
                        RUN PrintDataString(INPUT c-despesa-adic                                  , "padrao").
                        RUN PrintDataNumber(INPUT d-val-despes-adic-moed-negoc                    , "numeroFormato2").
                        RUN PrintDataString(INPUT string(despes-adic.log-incid-vmle,"S/N")        , "logicos").
                        RUN PrintDataString(INPUT string(c-va-adic,"S/N")                         , "logicos").
                        RUN PrintDataString(INPUT string(despes-adic.log-forma-preco-compra,"S/N"), "logicos"). /* FPC */
                        RUN PrintDataString(INPUT ""                                              , "Default").
            
                        RUN PrintDataString(INPUT c-incide-nf                                     , "padrao").
                        RUN PrintDataString(INPUT c-despesa-adic                                  , "padrao").
                        RUN PrintDataNumber(INPUT d-val-despes-adic-moed-nac                      , "numeroFormato2").
                        RUN PrintDataString(INPUT string(despes-adic.log-incid-vmle,"S/N")        , "logicos").
                        RUN PrintDataString(INPUT string(c-va-adic,"S/N")                         , "logicos").
                        RUN PrintDataString(INPUT string(despes-adic.log-forma-preco-compra,"S/N"), "logicos"). /* FPC */
                        RUN PrintDataString(INPUT ""                                              , "Default").
            
                        RUN PrintDataString(INPUT c-incide-nf                                     , "padrao").
                        RUN PrintDataString(INPUT c-despesa-adic                                  , "padrao").
                        RUN PrintDataNumber(INPUT d-val-despes-adic-moed-param                    , "numeroFormato2").
                        RUN PrintDataString(INPUT string(despes-adic.log-incid-vmle,"S/N")        , "logicos").
                        RUN PrintDataString(INPUT string(c-va-adic,"S/N")                         , "logicos").
                        RUN PrintDataString(INPUT string(despes-adic.log-forma-preco-compra,"S/N"), "logicos"). /* FPC */
                    RUN CloseLine.
                END. /*for each despes-adic*/
                
                RUN OpenLine.
                    RUN MergeColumns(INPUT 19, ""                                                          , "Default").
                RUN CloseLine.

                RUN OpenLine.
                    RUN MergeColumns(INPUT 2, c-lbl-impostos-adic, "subtitulo_adicao").  
                    ASSIGN iColCount = iColCount + 1.                          
                    RUN MergeColumns(INPUT 3, "", "Default").
                    ASSIGN iColCount = iColCount + 1.
                    RUN MergeColumns(INPUT 2, c-lbl-impostos-adic, "subtitulo_adicao").  
                    ASSIGN iColCount = iColCount + 1.                          
                    RUN MergeColumns(INPUT 3, "", "Default").
                    ASSIGN iColCount = iColCount + 1.                          
                    RUN MergeColumns(INPUT 2, c-lbl-impostos-adic, "subtitulo_adicao").  
                    ASSIGN iColCount = iColCount + 1.                              
                    RUN MergeColumns(INPUT 2, "", "Default").
                RUN CloseLine.
        
                RUN OpenLine.
                    RUN PrintDataString(INPUT c-lbl-coluna,         "subtitulo_direito_azul").       
                    RUN PrintDataString(INPUT c-lbl-tribut,         "subtitulo_centro_azul").                
                    RUN PrintDataString(INPUT c-lbl-aliq,           "subtitulo_direito_azul"). 
                    RUN PrintDataString(INPUT c-lbl-reduc,          "subtitulo_direito_azul"). 
                    RUN PrintDataString(INPUT c-lbl-susp,           "subtitulo_centro_azul").                
                    RUN PrintDataString(INPUT c-lbl-valor-impostos, "subtitulo_direito_azul"). 
                    RUN PrintDataString(INPUT "",                   "Default").

                    RUN PrintDataString(INPUT c-lbl-coluna,         "subtitulo_direito_azul").       
                    RUN PrintDataString(INPUT c-lbl-tribut,         "subtitulo_centro_azul").  
                    RUN PrintDataString(INPUT c-lbl-aliq,           "subtitulo_direito_azul"). 
                    RUN PrintDataString(INPUT c-lbl-reduc,          "subtitulo_direito_azul"). 
                    RUN PrintDataString(INPUT c-lbl-susp,           "subtitulo_centro_azul").  
                    RUN PrintDataString(INPUT c-lbl-valor-impostos, "subtitulo_direito_azul"). 
                    RUN PrintDataString(INPUT "",                   "Default").

                    RUN PrintDataString(INPUT c-lbl-coluna,         "subtitulo_direito_azul").       
                    RUN PrintDataString(INPUT c-lbl-tribut,         "subtitulo_centro_azul").  
                    RUN PrintDataString(INPUT c-lbl-aliq,           "subtitulo_direito_azul"). 
                    RUN PrintDataString(INPUT c-lbl-reduc,          "subtitulo_direito_azul"). 
                    RUN PrintDataString(INPUT c-lbl-susp,           "subtitulo_centro_azul").  
                    RUN PrintDataString(INPUT c-lbl-valor-impostos, "subtitulo_direito_azul"). 
                RUN CloseLine.

                /* II */
                IF decla-import-adic.log-suspens-impto-import THEN ASSIGN v-val-II-adic = decla-import-adic.val-ii-nao-tribut.
                CASE decla-import-adic.idi-tributac-impto-import:
                    WHEN 1 THEN ASSIGN v-val-II-adic = decla-import-adic.val-ii-db-cr.
                    WHEN 2 THEN ASSIGN v-val-II-adic = decla-import-adic.val-ii-db-cr.
                    WHEN 3 THEN ASSIGN v-val-II-adic = decla-import-adic.val-ii-outras.
                    WHEN 4 THEN ASSIGN v-val-II-adic = decla-import-adic.val-ii-db-cr.
                END CASE.

                RUN OpenLine.
                    RUN PrintDataString(INPUT c-lbl-II, "subtitulo_direito").       /* imposto       */
                    RUN PrintDataString(INPUT {cxinc/i01cx402.i 04 decla-import-adic.idi-tributac-impto-import} , "logicos"). /* tributa‡Æo    */
                    RUN PrintDataNumber(INPUT decla-import-adic.val-aliq-ii, "numeroFormato4"). /* aliquota      */
                    RUN PrintDataNumber(INPUT decla-import-adic.val-perc-reduc-impto-import, "numeroFormato2"). /* reducao       */
                    RUN PrintDataString(INPUT string(decla-import-adic.log-suspens-impto-import,"Sim/NÆo"),"logicos").
                    RUN PrintDataNumber(INPUT v-val-II-adic, "numeroFormato2"). /* valor imposto */
                    RUN PrintDataString(INPUT ""      , "Default").                           

                    RUN PrintDataString(INPUT c-lbl-II, "subtitulo_direito").       /* imposto       */
                    RUN PrintDataString(INPUT {cxinc/i01cx402.i 04 decla-import-adic.idi-tributac-impto-import} , "logicos"). /* tributa‡Æo    */
                    RUN PrintDataNumber(INPUT decla-import-adic.val-aliq-ii, "numeroFormato4"). /* aliquota      */
                    RUN PrintDataNumber(INPUT decla-import-adic.val-perc-reduc-impto-import, "numeroFormato2"). /* reducao       */
                    RUN PrintDataString(INPUT string(decla-import-adic.log-suspens-impto-import,"Sim/NÆo"),"logicos").
                    RUN PrintDataNumber(INPUT v-val-II-adic, "numeroFormato2"). /* valor imposto */
                    RUN PrintDataString(INPUT ""      , "Default").                           

                    RUN PrintDataString(INPUT c-lbl-II, "subtitulo_direito").       /* imposto       */
                    RUN PrintDataString(INPUT {cxinc/i01cx402.i 04 decla-import-adic.idi-tributac-impto-import} , "logicos"). /* tributa‡Æo    */
                    RUN PrintDataNumber(INPUT decla-import-adic.val-aliq-ii, "numeroFormato4"). /* aliquota      */
                    RUN PrintDataNumber(INPUT decla-import-adic.val-perc-reduc-impto-import, "numeroFormato2"). /* reducao       */
                    RUN PrintDataString(INPUT string(decla-import-adic.log-suspens-impto-import,"Sim/NÆo"),"logicos").
                    RUN PrintDataNumber(INPUT v-val-II-adic, "numeroFormato2"). /* valor imposto */
                RUN CloseLine.

                /* IPI */
                IF decla-import-adic.log-suspens-ipi-import THEN ASSIGN v-val-IPI-adic = decla-import-adic.val-ipi-nao-tributad.
                CASE decla-import-adic.idi-tributac-ipi:
                    WHEN 1 THEN ASSIGN v-val-IPI-adic = decla-import-adic.val-ipi-db-cr.
                    WHEN 2 THEN ASSIGN v-val-IPI-adic = decla-import-adic.val-ipi-db-cr.
                    WHEN 3 THEN ASSIGN v-val-IPI-adic = decla-import-adic.val-ipi-outras.
                    WHEN 4 THEN ASSIGN v-val-IPI-adic = decla-import-adic.val-ipi-db-cr.
                END CASE.

                RUN OpenLine.
                    RUN PrintDataString(INPUT c-lbl-IPI, "subtitulo_direito").       /* imposto       */
                    RUN PrintDataString(INPUT {cxinc/i01cx402.i 04 decla-import-adic.idi-tributac-ipi} , "logicos"). /* tributa‡Æo    */
                    RUN PrintDataNumber(INPUT decla-import-adic.val-aliq-ipi, "numeroFormato2"). /* aliquota      */
                    RUN PrintDataNumber(INPUT decla-import-adic.val-perc-reduc-ipi , "numeroFormato2"). /* reducao       */
                    RUN PrintDataString(INPUT string(decla-import-adic.log-suspens-ipi-import,"Sim/NÆo"),"logicos").
                    RUN PrintDataNumber(INPUT v-val-IPI-adic, "numeroFormato2"). /* valor imposto */
                    RUN PrintDataString(INPUT ""       , "Default").                           

                    RUN PrintDataString(INPUT c-lbl-IPI, "subtitulo_direito").       /* imposto       */
                    RUN PrintDataString(INPUT {cxinc/i01cx402.i 04 decla-import-adic.idi-tributac-ipi} , "logicos"). /* tributa‡Æo    */
                    RUN PrintDataNumber(INPUT decla-import-adic.val-aliq-ipi, "numeroFormato2"). /* aliquota      */
                    RUN PrintDataNumber(INPUT decla-import-adic.val-perc-reduc-ipi , "numeroFormato2"). /* reducao       */
                    RUN PrintDataString(INPUT string(decla-import-adic.log-suspens-ipi-import,"Sim/NÆo"),"logicos").
                    RUN PrintDataNumber(INPUT v-val-IPI-adic, "numeroFormato2"). /* valor imposto */
                    RUN PrintDataString(INPUT ""       , "Default").                           

                    RUN PrintDataString(INPUT c-lbl-IPI, "subtitulo_direito").       /* imposto       */
                    RUN PrintDataString(INPUT {cxinc/i01cx402.i 04 decla-import-adic.idi-tributac-ipi} , "logicos"). /* tributa‡Æo    */
                    RUN PrintDataNumber(INPUT decla-import-adic.val-aliq-ipi, "numeroFormato2"). /* aliquota      */
                    RUN PrintDataNumber(INPUT decla-import-adic.val-perc-reduc-ipi , "numeroFormato2"). /* reducao       */
                    RUN PrintDataString(INPUT string(decla-import-adic.log-suspens-ipi-import,"Sim/NÆo"),"logicos").
                    RUN PrintDataNumber(INPUT v-val-IPI-adic, "numeroFormato2"). /* valor imposto */
                RUN CloseLine.

                /* PIS */
                &if '{&bf_mat_versao_ems}' >= '2.09' &then
                    IF decla-import-adic.log-suspens-pis THEN
                &else
                    IF SUBSTRING(decla-import-adic.cod-livre-1,2,1) = '1' THEN
                &endif
                    ASSIGN v-val-PIS-adic = decla-import-adic.val-pis-nao-tribut.

                CASE decla-import-adic.idi-tributac-pis:
                    WHEN 1 THEN ASSIGN v-val-PIS-adic = decla-import-adic.val-pis-db-cr.
                    WHEN 2 THEN ASSIGN v-val-PIS-adic = decla-import-adic.val-pis-db-cr.
                    WHEN 3 THEN ASSIGN v-val-PIS-adic = decla-import-adic.val-pis-outras.
                    WHEN 4 THEN ASSIGN v-val-PIS-adic = decla-import-adic.val-pis-db-cr.
                END CASE.

                RUN OpenLine.
                    RUN PrintDataString(INPUT c-lbl-PIS, "subtitulo_direito").       /* imposto       */
                    RUN PrintDataString(INPUT {cxinc/i01cx402.i 04 decla-import-adic.idi-tributac-pis} , "logicos"). /* tributa‡Æo    */
                    RUN PrintDataNumber(INPUT decla-import-adic.val-aliq-pis, "numeroFormato4"). /* aliquota      */
                    RUN PrintDataNumber(INPUT decla-import-adic.val-perc-reduc-pis, "numeroFormato2"). /* reducao       */
                    RUN PrintDataString(INPUT ""       , "logicos").                 /* suspenso      */
                    RUN PrintDataNumber(INPUT v-val-PIS-adic, "numeroFormato2"). /* valor imposto */
                    RUN PrintDataString(INPUT ""       , "Default").                           

                    RUN PrintDataString(INPUT c-lbl-PIS, "subtitulo_direito").       /* imposto       */
                    RUN PrintDataString(INPUT {cxinc/i01cx402.i 04 decla-import-adic.idi-tributac-pis} , "logicos"). /* tributa‡Æo    */
                    RUN PrintDataNumber(INPUT decla-import-adic.val-aliq-pis, "numeroFormato4"). /* aliquota      */
                    RUN PrintDataNumber(INPUT decla-import-adic.val-perc-reduc-pis, "numeroFormato2"). /* reducao       */
                    RUN PrintDataString(INPUT ""       , "logicos").                 /* suspenso      */
                    RUN PrintDataNumber(INPUT v-val-PIS-adic, "numeroFormato2"). /* valor imposto */
                    RUN PrintDataString(INPUT ""       , "Default").                           

                    RUN PrintDataString(INPUT c-lbl-PIS, "subtitulo_direito").       /* imposto       */
                    RUN PrintDataString(INPUT {cxinc/i01cx402.i 04 decla-import-adic.idi-tributac-pis} , "logicos"). /* tributa‡Æo    */
                    RUN PrintDataNumber(INPUT decla-import-adic.val-aliq-pis, "numeroFormato4"). /* aliquota      */
                    RUN PrintDataNumber(INPUT decla-import-adic.val-perc-reduc-pis, "numeroFormato2"). /* reducao       */
                    RUN PrintDataString(INPUT ""       , "logicos").                 /* suspenso      */
                    RUN PrintDataNumber(INPUT v-val-PIS-adic, "numeroFormato2"). /* valor imposto */
                RUN CloseLine.

                /* COFINS */
                &if '{&bf_mat_versao_ems}' >= '2.09' &then
                    IF decla-import-adic.log-suspens-cofins THEN
                &else
                    IF SUBSTRING(decla-import-adic.cod-livre-1,3,1) = '1' THEN
                &endif
                    ASSIGN v-val-COFINS-adic = decla-import-adic.val-cofins-nao-tribut.

                CASE decla-import-adic.idi-tributac-cofins:
                    WHEN 1 THEN ASSIGN v-val-COFINS-adic = decla-import-adic.val-cofins-db-cr.
                    WHEN 2 THEN ASSIGN v-val-COFINS-adic = decla-import-adic.val-cofins-db-cr.
                    WHEN 3 THEN ASSIGN v-val-COFINS-adic = decla-import-adic.val-cofins-outras.
                    WHEN 4 THEN ASSIGN v-val-COFINS-adic = decla-import-adic.val-cofins-db-cr.
                END CASE.

                RUN OpenLine.
                    RUN PrintDataString(INPUT c-lbl-COFINS, "subtitulo_direito").       /* imposto       */
                    RUN PrintDataString(INPUT {cxinc/i01cx402.i 04 decla-import-adic.idi-tributac-cofins} , "logicos"). /* tributa‡Æo    */
                    RUN PrintDataNumber(INPUT decla-import-adic.val-aliq-cofins, "numeroFormato4"). /* aliquota      */
                    RUN PrintDataNumber(INPUT decla-import-adic.val-perc-reduc-cofins, "numeroFormato2"). /* reducao       */
                    RUN PrintDataString(INPUT ""          , "logicos").                 /* suspenso      */
                    RUN PrintDataNumber(INPUT v-val-COFINS-adic, "numeroFormato2"). /* valor imposto */
                    RUN PrintDataString(INPUT ""          , "Default").                           

                    RUN PrintDataString(INPUT c-lbl-COFINS, "subtitulo_direito").       /* imposto       */
                    RUN PrintDataString(INPUT {cxinc/i01cx402.i 04 decla-import-adic.idi-tributac-cofins} , "logicos"). /* tributa‡Æo    */
                    RUN PrintDataNumber(INPUT decla-import-adic.val-aliq-cofins, "numeroFormato4"). /* aliquota      */
                    RUN PrintDataNumber(INPUT decla-import-adic.val-perc-reduc-cofins, "numeroFormato2"). /* reducao       */
                    RUN PrintDataString(INPUT ""          , "logicos").                 /* suspenso      */
                    RUN PrintDataNumber(INPUT v-val-COFINS-adic, "numeroFormato2"). /* valor imposto */
                    RUN PrintDataString(INPUT ""          , "Default").                           

                    RUN PrintDataString(INPUT c-lbl-COFINS, "subtitulo_direito").       /* imposto       */
                    RUN PrintDataString(INPUT {cxinc/i01cx402.i 04 decla-import-adic.idi-tributac-cofins} , "logicos"). /* tributa‡Æo    */
                    RUN PrintDataNumber(INPUT decla-import-adic.val-aliq-cofins, "numeroFormato4"). /* aliquota      */
                    RUN PrintDataNumber(INPUT decla-import-adic.val-perc-reduc-cofins, "numeroFormato2"). /* reducao       */
                    RUN PrintDataString(INPUT ""          , "logicos").                 /* suspenso      */
                    RUN PrintDataNumber(INPUT v-val-COFINS-adic, "numeroFormato2"). /* valor imposto */
                RUN CloseLine.

                /* ICMS */
                &if '{&bf_mat_versao_ems}' >= '2.09' &then
                    IF decla-import-adic.log-suspens-icms THEN
                &else
                    IF SUBSTRING(decla-import-adic.cod-livre-1,1,1) = '1' THEN
                &endif
                    ASSIGN v-val-ICMS-adic = decla-import-adic.val-icms-nao-tribut.

                CASE decla-import-adic.idi-tributac-icms:
                    WHEN 1 THEN ASSIGN v-val-ICMS-adic = decla-import-adic.val-icms-db-cr.
                    WHEN 2 THEN ASSIGN v-val-ICMS-adic = decla-import-adic.val-icms-db-cr.
                    WHEN 3 THEN ASSIGN v-val-ICMS-adic = decla-import-adic.val-icms-outras.
                    WHEN 4 THEN ASSIGN v-val-ICMS-adic = decla-import-adic.val-icms-db-cr.
                END CASE.                

                RUN OpenLine.
                    RUN PrintDataString(INPUT c-lbl-ICMS, "subtitulo_direito").       /* imposto       */
                    RUN PrintDataString(INPUT {cxinc/i02cx402.i 04 decla-import-adic.idi-tributac-icms} , "logicos"). /* tributa‡Æo    */
                    RUN PrintDataNumber(INPUT decla-import-adic.val-aliq-icms, "numeroFormato2"). /* aliquota      */
                    RUN PrintDataNumber(INPUT decla-import-adic.val-perc-reduc-icms, "numeroFormato2"). /* reducao       */
                    RUN PrintDataString(INPUT ""        , "logicos").                 /* suspenso      */
                    RUN PrintDataNumber(INPUT v-val-ICMS-adic, "numeroFormato2"). /* valor imposto */
                    RUN PrintDataString(INPUT ""        , "Default").                           

                    RUN PrintDataString(INPUT c-lbl-ICMS, "subtitulo_direito").       /* imposto       */
                    RUN PrintDataString(INPUT {cxinc/i02cx402.i 04 decla-import-adic.idi-tributac-icms} , "logicos"). /* tributa‡Æo    */
                    RUN PrintDataNumber(INPUT decla-import-adic.val-aliq-icms, "numeroFormato2"). /* aliquota      */
                    RUN PrintDataNumber(INPUT decla-import-adic.val-perc-reduc-icms, "numeroFormato2"). /* reducao       */
                    RUN PrintDataString(INPUT ""        , "logicos").                 /* suspenso      */
                    RUN PrintDataNumber(INPUT v-val-ICMS-adic, "numeroFormato2"). /* valor imposto */
                    RUN PrintDataString(INPUT ""        , "Default").                           

                    RUN PrintDataString(INPUT c-lbl-ICMS, "subtitulo_direito").       /* imposto       */
                    RUN PrintDataString(INPUT {cxinc/i02cx402.i 04 decla-import-adic.idi-tributac-icms} , "logicos"). /* tributa‡Æo    */
                    RUN PrintDataNumber(INPUT decla-import-adic.val-aliq-icms, "numeroFormato2"). /* aliquota      */
                    RUN PrintDataNumber(INPUT decla-import-adic.val-perc-reduc-icms, "numeroFormato2"). /* reducao       */
                    RUN PrintDataString(INPUT ""        , "logicos").                 /* suspenso      */
                    RUN PrintDataNumber(INPUT v-val-ICMS-adic, "numeroFormato2"). /* valor imposto */
                RUN CloseLine.
                
                IF l-nt2024002 THEN DO:
                    ASSIGN i-trib-ibsuf-adic    = 1
                           de-aliq-ibsuf-adic   = 0
                           de-reduc-ibsuf-adic  = 0
                           v-val-ibsuf-adic     = 0
                           i-trib-cbs-adic      = 1
                           de-aliq-cbs-adic     = 0
                           de-reduc-cbs-adic    = 0
                           v-val-cbs-adic       = 0
                           i-trib-ibsmun-adic   = 1
                           de-aliq-ibsmun-adic  = 0
                           de-reduc-ibsmun-adic = 0
                           v-val-ibsmun-adic    = 0
                           i-trib-is-adic       = 1
                           de-aliq-is-adic      = 0
                           v-val-is-adic        = 0.
                    FOR EACH decla-import-adic-trib NO-LOCK
                       WHERE decla-import-adic-trib.num-di-ems       = decla-import-adic.num-di-ems
                         AND decla-import-adic-trib.num-adic         = decla-import-adic.num-adic
                         AND decla-import-adic-trib.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts:
                        CASE decla-import-adic-trib.nom-trib:
                            WHEN "IBSUF":U THEN
                                CASE decla-import-adic-trib.cod-campo:
                                    WHEN "COD-TRIB":U THEN ASSIGN i-trib-ibsuf-adic = INT(REPLACE(decla-import-adic-trib.cod-conteudo,',','.')).
                                    WHEN "ALIQUOTA":U THEN ASSIGN de-aliq-ibsuf-adic = DECIMAL(REPLACE(decla-import-adic-trib.cod-conteudo,',','.')).
                                    WHEN "ALIQ-RED":U THEN ASSIGN de-reduc-ibsuf-adic = DECIMAL(REPLACE(decla-import-adic-trib.cod-conteudo,',','.')).
                                    WHEN "VALOR":U OR 
                                    WHEN "OUTROS":U   THEN ASSIGN v-val-ibsuf-adic = DECIMAL(REPLACE(decla-import-adic-trib.cod-conteudo,',','.')).
                                END CASE.
                            WHEN "IBSMUN":U THEN
                                CASE decla-import-adic-trib.cod-campo:
                                    WHEN "COD-TRIB":U THEN ASSIGN i-trib-ibsmun-adic = INT(REPLACE(decla-import-adic-trib.cod-conteudo,',','.')).
                                    WHEN "ALIQUOTA":U THEN ASSIGN de-aliq-ibsmun-adic = DECIMAL(REPLACE(decla-import-adic-trib.cod-conteudo,',','.')).
                                    WHEN "ALIQ-RED":U THEN ASSIGN de-reduc-ibsmun-adic = DECIMAL(REPLACE(decla-import-adic-trib.cod-conteudo,',','.')).
                                    WHEN "VALOR":U OR
                                    WHEN "OUTROS":U   THEN ASSIGN v-val-ibsmun-adic = DECIMAL(REPLACE(decla-import-adic-trib.cod-conteudo,',','.')).
                                END CASE.
                            WHEN "CBS":U THEN
                                CASE decla-import-adic-trib.cod-campo:
                                    WHEN "COD-TRIB":U THEN ASSIGN i-trib-cbs-adic = INT(REPLACE(decla-import-adic-trib.cod-conteudo,',','.')).
                                    WHEN "ALIQUOTA":U THEN ASSIGN de-aliq-cbs-adic = DECIMAL(REPLACE(decla-import-adic-trib.cod-conteudo,',','.')).
                                    WHEN "ALIQ-RED":U THEN ASSIGN de-reduc-cbs-adic = DECIMAL(REPLACE(decla-import-adic-trib.cod-conteudo,',','.')).
                                    WHEN "VALOR":U OR
                                    WHEN "OUTROS":U   THEN ASSIGN v-val-cbs-adic = DECIMAL(REPLACE(decla-import-adic-trib.cod-conteudo,',','.')).
                                END CASE.
                            WHEN "IS":U THEN
                                CASE decla-import-adic-trib.cod-campo:
                                    WHEN "COD-TRIB":U THEN ASSIGN i-trib-is-adic = INT(REPLACE(decla-import-adic-trib.cod-conteudo,',','.')).
                                    WHEN "ALIQUOTA":U THEN ASSIGN de-aliq-is-adic = DECIMAL(REPLACE(decla-import-adic-trib.cod-conteudo,',','.')).
                                    WHEN "VALOR":U OR
                                    WHEN "OUTROS":U   THEN ASSIGN v-val-is-adic = DECIMAL(REPLACE(decla-import-adic-trib.cod-conteudo,',','.')).
                                END CASE.
                        END CASE.
                    END.
                    /* IBS UF */
                    RUN OpenLine.
                    RUN PrintDataString(INPUT "IBS UF":U, "subtitulo_direito").       /* imposto       */
                    RUN PrintDataString(INPUT {diinc/i01di628.i 04 i-trib-ibsuf-adic} , "logicos"). /* tributa‡Æo    */
                    RUN PrintDataNumber(INPUT de-aliq-ibsuf-adic, "numeroFormato2"). /* aliquota      */
                    RUN PrintDataNumber(INPUT de-reduc-ibsuf-adic, "numeroFormato2"). /* reducao       */
                    RUN PrintDataString(INPUT ""        , "logicos").                 /* suspenso      */
                    RUN PrintDataNumber(INPUT v-val-ibsuf-adic, "numeroFormato2"). /* valor imposto */
                    RUN PrintDataString(INPUT ""        , "Default").                           

                    RUN PrintDataString(INPUT "IBS UF":U, "subtitulo_direito").       /* imposto       */
                    RUN PrintDataString(INPUT {diinc/i01di628.i 04 i-trib-ibsuf-adic} , "logicos"). /* tributa‡Æo    */
                    RUN PrintDataNumber(INPUT de-aliq-ibsuf-adic, "numeroFormato2"). /* aliquota      */
                    RUN PrintDataNumber(INPUT de-reduc-ibsuf-adic, "numeroFormato2"). /* reducao       */
                    RUN PrintDataString(INPUT ""        , "logicos").                 /* suspenso      */
                    RUN PrintDataNumber(INPUT v-val-ibsuf-adic, "numeroFormato2"). /* valor imposto */
                    RUN PrintDataString(INPUT ""        , "Default").                           

                    RUN PrintDataString(INPUT "IBS UF":U, "subtitulo_direito").       /* imposto       */
                    RUN PrintDataString(INPUT {diinc/i01di628.i 04 i-trib-ibsuf-adic} , "logicos"). /* tributa‡Æo    */
                    RUN PrintDataNumber(INPUT de-aliq-ibsuf-adic, "numeroFormato2"). /* aliquota      */
                    RUN PrintDataNumber(INPUT de-reduc-ibsuf-adic, "numeroFormato2"). /* reducao       */
                    RUN PrintDataString(INPUT ""        , "logicos").                 /* suspenso      */
                    RUN PrintDataNumber(INPUT v-val-ibsuf-adic, "numeroFormato2"). /* valor imposto */
                    RUN CloseLine.

                    /* IBS Mun */
                    RUN OpenLine.
                    RUN PrintDataString(INPUT "IBS Mun":U, "subtitulo_direito").       /* imposto       */
                    RUN PrintDataString(INPUT {diinc/i01di628.i 04 i-trib-ibsmun-adic} , "logicos"). /* tributa‡Æo    */
                    RUN PrintDataNumber(INPUT de-aliq-ibsmun-adic, "numeroFormato2").  /* aliquota      */
                    RUN PrintDataNumber(INPUT de-reduc-ibsmun-adic, "numeroFormato2"). /* reducao       */
                    RUN PrintDataString(INPUT ""        , "logicos").                  /* suspenso      */
                    RUN PrintDataNumber(INPUT v-val-ibsmun-adic, "numeroFormato2").    /* valor imposto */
                    RUN PrintDataString(INPUT ""        , "Default").                           

                    RUN PrintDataString(INPUT "IBS Mun":U, "subtitulo_direito").       /* imposto       */
                    RUN PrintDataString(INPUT {diinc/i01di628.i 04 i-trib-ibsmun-adic} , "logicos"). /* tributa‡Æo    */
                    RUN PrintDataNumber(INPUT de-aliq-ibsmun-adic, "numeroFormato2").  /* aliquota      */
                    RUN PrintDataNumber(INPUT de-reduc-ibsmun-adic, "numeroFormato2"). /* reducao       */
                    RUN PrintDataString(INPUT ""        , "logicos").                  /* suspenso      */
                    RUN PrintDataNumber(INPUT v-val-ibsmun-adic, "numeroFormato2").    /* valor imposto */
                    RUN PrintDataString(INPUT ""        , "Default").                           

                    RUN PrintDataString(INPUT "IBS Mun":U, "subtitulo_direito").       /* imposto       */
                    RUN PrintDataString(INPUT {diinc/i01di628.i 04 i-trib-ibsmun-adic} , "logicos"). /* tributa‡Æo    */
                    RUN PrintDataNumber(INPUT de-aliq-ibsmun-adic, "numeroFormato2").  /* aliquota      */
                    RUN PrintDataNumber(INPUT de-reduc-ibsmun-adic, "numeroFormato2"). /* reducao       */
                    RUN PrintDataString(INPUT ""        , "logicos").                  /* suspenso      */
                    RUN PrintDataNumber(INPUT v-val-ibsmun-adic, "numeroFormato2").    /* valor imposto */
                    RUN CloseLine.

                    /* CBS */
                    RUN OpenLine.
                    RUN PrintDataString(INPUT "CBS":U, "subtitulo_direito").       /* imposto       */
                    RUN PrintDataString(INPUT {diinc/i01di628.i 04 i-trib-cbs-adic} , "logicos"). /* tributa‡Æo    */
                    RUN PrintDataNumber(INPUT de-aliq-cbs-adic, "numeroFormato2"). /* aliquota      */
                    RUN PrintDataNumber(INPUT de-reduc-cbs-adic, "numeroFormato2"). /* reducao       */
                    RUN PrintDataString(INPUT ""        , "logicos").                 /* suspenso      */
                    RUN PrintDataNumber(INPUT v-val-cbs-adic, "numeroFormato2"). /* valor imposto */
                    RUN PrintDataString(INPUT ""        , "Default").                           

                    RUN PrintDataString(INPUT "CBS":U, "subtitulo_direito").       /* imposto       */
                    RUN PrintDataString(INPUT {diinc/i01di628.i 04 i-trib-cbs-adic} , "logicos"). /* tributa‡Æo    */
                    RUN PrintDataNumber(INPUT de-aliq-cbs-adic, "numeroFormato2"). /* aliquota      */
                    RUN PrintDataNumber(INPUT de-reduc-cbs-adic, "numeroFormato2"). /* reducao       */
                    RUN PrintDataString(INPUT ""        , "logicos").                 /* suspenso      */
                    RUN PrintDataNumber(INPUT v-val-cbs-adic, "numeroFormato2"). /* valor imposto */
                    RUN PrintDataString(INPUT ""        , "Default").                           

                    RUN PrintDataString(INPUT "CBS":U, "subtitulo_direito").       /* imposto       */
                    RUN PrintDataString(INPUT {diinc/i01di628.i 04 i-trib-cbs-adic} , "logicos"). /* tributa‡Æo    */
                    RUN PrintDataNumber(INPUT de-aliq-cbs-adic, "numeroFormato2"). /* aliquota      */
                    RUN PrintDataNumber(INPUT de-reduc-cbs-adic, "numeroFormato2"). /* reducao       */
                    RUN PrintDataString(INPUT ""        , "logicos").                 /* suspenso      */
                    RUN PrintDataNumber(INPUT v-val-cbs-adic, "numeroFormato2"). /* valor imposto */
                    RUN CloseLine.
                    
                    /* IS */
                    RUN OpenLine.
                    RUN PrintDataString(INPUT "IS":U, "subtitulo_direito").       /* imposto       */
                    RUN PrintDataString(INPUT {diinc/i01di628.i 04 i-trib-is-adic} , "logicos"). /* tributa‡Æo    */
                    RUN PrintDataNumber(INPUT de-aliq-is-adic, "numeroFormato2"). /* aliquota      */
                    RUN PrintDataNumber(INPUT 0,               "numeroFormato2"). /* reducao       */
                    RUN PrintDataString(INPUT ""        , "logicos").                 /* suspenso      */
                    RUN PrintDataNumber(INPUT v-val-is-adic, "numeroFormato2"). /* valor imposto */
                    RUN PrintDataString(INPUT ""        , "Default").                           

                    RUN PrintDataString(INPUT "IS":U, "subtitulo_direito").       /* imposto       */
                    RUN PrintDataString(INPUT {diinc/i01di628.i 04 i-trib-is-adic} , "logicos"). /* tributa‡Æo    */
                    RUN PrintDataNumber(INPUT de-aliq-is-adic, "numeroFormato2"). /* aliquota      */
                    RUN PrintDataNumber(INPUT 0,               "numeroFormato2"). /* reducao       */
                    RUN PrintDataString(INPUT ""        , "logicos").                 /* suspenso      */
                    RUN PrintDataNumber(INPUT v-val-is-adic, "numeroFormato2"). /* valor imposto */
                    RUN PrintDataString(INPUT ""        , "Default").                           

                    RUN PrintDataString(INPUT "IS":U, "subtitulo_direito").       /* imposto       */
                    RUN PrintDataString(INPUT {diinc/i01di628.i 04 i-trib-is-adic} , "logicos"). /* tributa‡Æo    */
                    RUN PrintDataNumber(INPUT de-aliq-is-adic, "numeroFormato2"). /* aliquota      */
                    RUN PrintDataNumber(INPUT 0,               "numeroFormato2"). /* reducao       */
                    RUN PrintDataString(INPUT ""        , "logicos").                 /* suspenso      */
                    RUN PrintDataNumber(INPUT v-val-is-adic, "numeroFormato2"). /* valor imposto */
                    RUN CloseLine.
                END.
            END. /*if can-find despes-adic */
            /* fim - despesas da adicao */
            
            
            /* item */
            FOR EACH decla-import-adic-itens NO-LOCK
                    WHERE decla-import-adic-itens.num-di-ems       = decla-import-adic.num-di-ems
                    AND   decla-import-adic-itens.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts
                    AND   decla-import-adic-itens.num-adic         = decla-import-adic.num-adic:

                RUN OpenLine.
                    RUN MergeColumns(INPUT 19, ""                                           , "Default").
                RUN CloseLine.
            
                ASSIGN c-lbl-item         = "Item "                + " - " + string(decla-import-adic-itens.cod-item)
                       c-lbl-desp-item     = "Despesas do Item Nr." + " - " + string(decla-import-adic-itens.cod-item)
                       c-lbl-impostos-item = "Impostos do Item Nr." + " - " + string(decla-import-adic-itens.cod-item).

                RUN OpenLine.
                    RUN PrintDataString(INPUT c-lbl-item, "subtitulo_item").
                    RUN PrintDataString(INPUT c-lbl-adic, "subtitulo_item").
                    RUN MergeColumns   (INPUT 4, ""     , "Default").
                    ASSIGN iColCount = iColCount + 1.   
                    RUN PrintDataString(INPUT c-lbl-item, "subtitulo_item").
                    RUN PrintDataString(INPUT c-lbl-adic, "subtitulo_item").
                    RUN MergeColumns   (INPUT 4, ""     , "Default").
                    ASSIGN iColCount = iColCount + 1.   
                    RUN PrintDataString(INPUT c-lbl-item, "subtitulo_item").
                    RUN PrintDataString(INPUT c-lbl-adic, "subtitulo_item").
                    RUN MergeColumns   (INPUT 3, ""     , "Default").
                RUN CloseLine.
        
                RUN OpenLine.
                    RUN PrintDataString(INPUT c-lbl-vmcv,        "subtitulo_direito_verde").    
                    RUN PrintDataString(INPUT c-lbl-vmle,        "subtitulo_direito_verde").    
                    RUN PrintDataString(INPUT c-lbl-vmld,        "subtitulo_direito_verde").    
                    RUN MergeColumns   (INPUT 2, c-lbl-peso-liq, "subtitulo_direito_verde").    
                    ASSIGN iColCount = iColCount + 1.                              
                    RUN PrintDataString(INPUT "", "Default").
        
                    RUN PrintDataString(INPUT c-lbl-vmcv,        "subtitulo_direito_verde").    
                    RUN PrintDataString(INPUT c-lbl-vmle,        "subtitulo_direito_verde").    
                    RUN PrintDataString(INPUT c-lbl-vmld,        "subtitulo_direito_verde").    
                    RUN MergeColumns   (INPUT 2, c-lbl-peso-liq, "subtitulo_direito_verde").    
                    ASSIGN iColCount = iColCount + 1.                              
                    RUN PrintDataString(INPUT "", "Default").
        
                    RUN PrintDataString(INPUT c-lbl-vmcv,        "subtitulo_direito_verde").    
                    RUN PrintDataString(INPUT c-lbl-vmle,        "subtitulo_direito_verde").    
                    RUN PrintDataString(INPUT c-lbl-vmld,        "subtitulo_direito_verde").    
                    RUN MergeColumns   (INPUT 2, c-lbl-peso-liq, "subtitulo_direito_verde").    
                    ASSIGN iColCount = iColCount + 1.                              
                RUN CloseLine.

                
                RUN OpenLine.
                    RUN PrintDataNumber   (INPUT decla-import-adic-itens.val-vmcv-me[1], "numeroFormato2").
                    RUN PrintDataNumber   (INPUT decla-import-adic-itens.val-vmle-me[1], "numeroFormato2").
                    RUN PrintDataNumber   (INPUT decla-import-adic-itens.val-vmld-me[1], "numeroFormato2").
                    RUN MergeColumnsNumber(INPUT 2, decla-import-adic-itens.val-peso-liq, "numeroFormato4").
                    ASSIGN iColCount = iColCount + 1.                              
                    RUN PrintDataString   (INPUT "", "Default").
        
                    RUN PrintDataNumber   (INPUT decla-import-adic-itens.val-vmcv, "numeroFormato2").
                    RUN PrintDataNumber   (INPUT decla-import-adic-itens.val-vmle, "numeroFormato2").
                    RUN PrintDataNumber   (INPUT decla-import-adic-itens.val-vmld, "numeroFormato2").
                    RUN MergeColumnsNumber(INPUT 2, decla-import-adic-itens.val-peso-liq, "numeroFormato4").
                    ASSIGN iColCount = iColCount + 1.                              
                    RUN PrintDataString   (INPUT "", "Default").
        
                    RUN PrintDataNumber   (INPUT decla-import-adic-itens.val-vmcv-me[2], "numeroFormato2").
                    RUN PrintDataNumber   (INPUT decla-import-adic-itens.val-vmle-me[2], "numeroFormato2").
                    RUN PrintDataNumber   (INPUT decla-import-adic-itens.val-vmld-me[2], "numeroFormato2").
                    RUN MergeColumnsNumber(INPUT 2, decla-import-adic-itens.val-peso-liq, "numeroFormato4").
                    ASSIGN iColCount = iColCount + 1.                              
                RUN CloseLine.
            
                RUN OpenLine.
                    RUN MergeColumns(INPUT 19, ""                                           , "Default").
                RUN CloseLine.
        
                /* despesas do item */
                IF CAN-FIND(FIRST despes-adic-itens NO-LOCK
                                WHERE despes-adic-itens.num-di-ems       = decla-import-adic-itens.num-di-ems
                                AND   despes-adic-itens.cdd-siscomex-dts = decla-import-adic-itens.cdd-siscomex-dts
                                AND   despes-adic-itens.num-adic         = decla-import-adic-itens.num-adic
                                AND   despes-adic-itens.num-seq          = decla-import-adic-itens.num-seq) THEN DO:
                    RUN OpenLine.
                        RUN MergeColumns(INPUT 2, c-lbl-desp-item                               , "subtitulo_item").
                        ASSIGN iColCount = iColCount + 1.
                        RUN MergeColumns(INPUT 3, ""                                            , "Default").
                        ASSIGN iColCount = iColCount + 1.
                        RUN MergeColumns(INPUT 2, c-lbl-desp-item                               , "subtitulo_item").
                        ASSIGN iColCount = iColCount + 1.
                        RUN MergeColumns(INPUT 3, ""                                            , "Default").
                        ASSIGN iColCount = iColCount + 1.
                        RUN MergeColumns(INPUT 2, c-lbl-desp-item                               , "subtitulo_item").
                        ASSIGN iColCount = iColCount + 1.
                        RUN MergeColumns(INPUT 2, ""                                            , "Default").
                    RUN CloseLine.
            
                    RUN OpenLine.
                        RUN PrintDataString(INPUT c-lbl-incide-nf  , "cabecalho_item").
                        RUN PrintDataString(INPUT c-lbl-despesa    , "cabecalho_item").
                        RUN PrintDataString(INPUT c-lbl-valor      , "subtitulo_direito_verde").
                        RUN PrintDataString(INPUT c-lbl-incide-vmle, "subtitulo_centro_verde").
                        RUN PrintDataString(INPUT c-lbl-va         , "subtitulo_centro_verde").
                        RUN PrintDataString(INPUT c-lbl-fpc        , "subtitulo_centro_verde").
                        RUN PrintDataString(INPUT ""               , "Default").
            
                        RUN PrintDataString(INPUT c-lbl-incide-nf  , "cabecalho_item").
                        RUN PrintDataString(INPUT c-lbl-despesa    , "cabecalho_item").
                        RUN PrintDataString(INPUT c-lbl-valor      , "subtitulo_direito_verde").
                        RUN PrintDataString(INPUT c-lbl-incide-vmle, "subtitulo_centro_verde").
                        RUN PrintDataString(INPUT c-lbl-va         , "subtitulo_centro_verde").
                        RUN PrintDataString(INPUT c-lbl-fpc        , "subtitulo_centro_verde").
                        RUN PrintDataString(INPUT ""               , "Default").
            
                        RUN PrintDataString(INPUT c-lbl-incide-nf  , "cabecalho_item").
                        RUN PrintDataString(INPUT c-lbl-despesa    , "cabecalho_item").
                        RUN PrintDataString(INPUT c-lbl-valor      , "subtitulo_direito_verde").
                        RUN PrintDataString(INPUT c-lbl-incide-vmle, "subtitulo_centro_verde").
                        RUN PrintDataString(INPUT c-lbl-va         , "subtitulo_centro_verde").
                        RUN PrintDataString(INPUT c-lbl-fpc        , "subtitulo_centro_verde").
                    RUN CloseLine.

                    FOR FIRST decla-import-embarq FIELDS(cod-estab cod-embarq) NO-LOCK
                        WHERE decla-import-embarq.num-di-ems       = decla-import-adic-itens.num-di-ems
                        AND   decla-import-embarq.cdd-siscomex-dts = decla-import-adic-itens.cdd-siscomex-dts:
                    END.
                    
                    FOR EACH despes-adic-itens NO-LOCK
                       WHERE despes-adic-itens.num-di-ems       = decla-import-adic-itens.num-di-ems
                         AND despes-adic-itens.cdd-siscomex-dts = decla-import-adic-itens.cdd-siscomex-dts
                         AND despes-adic-itens.num-adic         = decla-import-adic-itens.num-adic
                         AND despes-adic-itens.num-seq          = decla-import-adic-itens.num-seq:
    
                        /* va */
                        FOR FIRST desp-imp NO-LOCK
                            WHERE desp-imp.cod-desp = despes-adic-itens.cdn-despes:
            
                            &IF '{&BF_MAT_VERSAO_EMS}' >= '2.09' &THEN
                                ASSIGN c-va-adic-tens = desp-imp.log-incid-val-aduana.
                            &ELSE
                                ASSIGN c-va-adic-itens = IF SUBSTRING(desp-imp.char-1,24,1) = '1' THEN YES ELSE NO.
                            &ENDIF
                        END.
                        /* fim - va*/
        
                        /* despesa */
                        FOR FIRST desp-embarque FIELDS(descricao) NO-LOCK
                            WHERE desp-embarque.cod-estabel = decla-import-embarq.cod-estab
                              AND desp-embarque.embarque = decla-import-embarq.cod-embarq
                              AND desp-embarque.cod-desp = despes-decla-import.cdn-despes:
                        END.
                        ASSIGN  c-despesa-adic-itens = STRING(despes-adic-itens.cdn-despes) + " - " + IF AVAIL desp-embarque AND desp-embarque.descricao <> "":U THEN desp-embarque.descricao ELSE desp-imp.descricao.
                        /* fim - despesa */

                        /* converte o valor da despesa da adicao */                                                        
                        /* moeda negociada */
                        RUN converteValorMoeda IN h-bocx383 (INPUT decla-import.num-di-ems, 
                                                             INPUT decla-import.cdd-siscomex-dts, 
                                                             INPUT despes-adic-itens.cdn-moeda,     /* moeda de origem */
                                                             INPUT decla-import-adic.cdn-moeda,     /* moeda de destino */
                                                             INPUT despes-adic-itens.val-despes,    /* valor da despesa */
                                                             INPUT decla-import.dat-di,             /* data da di  */
                                                             OUTPUT d-val-despes-item-moed-negoc).
            
                        /* moeda nacional */ 
                        RUN converteValorMoeda IN h-bocx383 (INPUT decla-import.num-di-ems, 
                                                             INPUT decla-import.cdd-siscomex-dts, 
                                                             INPUT despes-adic-itens.cdn-moeda,     /* moeda de origem */
                                                             INPUT 0,                               /* moeda de destino (0 - real)*/
                                                             INPUT despes-adic-itens.val-despes,    /* valor da despesa */
                                                             INPUT decla-import.dat-di,             /* data da di  */
                                                             OUTPUT d-val-despes-item-moed-nac).
            
                        /* moeda param */
                        RUN converteValorMoeda IN h-bocx383 (INPUT decla-import.num-di-ems,
                                                             INPUT decla-import.cdd-siscomex-dts, 
                                                             INPUT despes-adic-itens.cdn-moeda,     /* moeda de origem */
                                                             INPUT param-imp.int-2,                 /* moeda de destino */
                                                             INPUT despes-adic-itens.val-despes,    /* valor da despesa */
                                                             INPUT decla-import.dat-di,             /* data da di  */
                                                             OUTPUT d-val-despes-item-moed-param).
            
                        /* fim - converte o valor da despesa da adicao */
    
                        /*---[ Busca Incide VMLE da Adi‡Æo ]-----------------------------------------------------*/
                        IF  CAN-FIND(FIRST despes-adic
                                     WHERE despes-adic.num-di-ems       = decla-import-adic.num-di-ems
                                     AND   despes-adic.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts
                                     AND   despes-adic.num-adic         = decla-import-adic.num-adic) THEN
                            FOR FIRST despes-adic NO-LOCK
                                WHERE despes-adic.num-di-ems       = decla-import-adic.num-di-ems
                                AND   despes-adic.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts
                                AND   despes-adic.num-adic         = decla-import-adic.num-adic:
                            END.
                        /*-----------------------------------------------------[ Busca Incide VMLE da Adi‡Æo ]---*/
                        RUN OpenLine.
                            RUN PrintDataString(INPUT c-incide-nf                                           ,"padrao").
                            RUN PrintDataString(INPUT c-despesa-adic-itens                                  ,"padrao").
                            RUN PrintDataNumber(INPUT d-val-despes-item-moed-negoc                          ,"numeroFormato2").
                            RUN PrintDataString(INPUT string(despes-adic.log-incid-vmle,"S/N")              ,"logicos").
                            RUN PrintDataString(INPUT string(c-va-adic-itens,"S/N")                         ,"logicos").
                            RUN PrintDataString(INPUT string(despes-adic-itens.log-forma-preco-compra,"S/N"),"logicos").
                            RUN PrintDataString(INPUT ""                                                    ,"Default").
                            
                            RUN PrintDataString(INPUT c-incide-nf                                           ,"padrao").
                            RUN PrintDataString(INPUT c-despesa-adic-itens                                  ,"padrao").
                            RUN PrintDataNumber(INPUT d-val-despes-item-moed-nac                            ,"numeroFormato2").
                            RUN PrintDataString(INPUT string(despes-adic.log-incid-vmle,"S/N")              ,"logicos").
                            RUN PrintDataString(INPUT string(c-va-adic-itens,"S/N")                         ,"logicos").
                            RUN PrintDataString(INPUT string(despes-adic-itens.log-forma-preco-compra,"S/N"),"logicos").
                            RUN PrintDataString(INPUT ""                                                    ,"Default").
                            
                            RUN PrintDataString(INPUT c-incide-nf                                             ,"padrao").
                            RUN PrintDataString(INPUT c-despesa-adic-itens                                    ,"padrao").
                            RUN PrintDataNumber(INPUT d-val-despes-item-moed-param                            ,"numeroFormato2").
                            RUN PrintDataString(INPUT string(despes-adic.log-incid-vmle,"S/N")                ,"logicos").
                            RUN PrintDataString(INPUT string(c-va-adic-itens,"S/N")                           ,"logicos").
                            RUN PrintDataString(INPUT string(despes-adic-itens.log-forma-preco-compra,"S/N")  ,"logicos").
                        RUN CloseLine.
                    END. /*for each despes-adic-itens */
                END. /*if can find despes-adic-itens */
                /* fim - despesas do item */

                RUN OpenLine.
                    RUN MergeColumns(INPUT 19, "", "Default").
                RUN CloseLine.

                RUN OpenLine.
                    RUN MergeColumns(INPUT 2, c-lbl-impostos-item, "subtitulo_item").  
                    ASSIGN iColCount = iColCount + 1.                              
                    RUN MergeColumns(INPUT 3, "", "Default").    
                    ASSIGN iColCount = iColCount + 1.
                    RUN MergeColumns(INPUT 2, c-lbl-impostos-item, "subtitulo_item").  
                    ASSIGN iColCount = iColCount + 1.                              
                    RUN MergeColumns(INPUT 3, "", "Default").    
                    ASSIGN iColCount = iColCount + 1.                              
                    RUN MergeColumns(INPUT 2, c-lbl-impostos-item, "subtitulo_item").  
                    ASSIGN iColCount = iColCount + 1.                              
                    RUN MergeColumns(INPUT 2, "", "Default").
                RUN CloseLine.
        
                RUN OpenLine.
                    RUN PrintDataString(INPUT c-lbl-coluna,         "subtitulo_direito_verde").       
                    RUN PrintDataString(INPUT c-lbl-tribut,         "subtitulo_centro_verde").                
                    RUN PrintDataString(INPUT c-lbl-aliq,           "subtitulo_direito_verde"). 
                    RUN PrintDataString(INPUT c-lbl-reduc,          "subtitulo_direito_verde"). 
                    RUN PrintDataString(INPUT c-lbl-susp,           "subtitulo_centro_verde").                
                    RUN PrintDataString(INPUT c-lbl-valor-impostos, "subtitulo_direito_verde"). 
                    RUN PrintDataString(INPUT "",                   "Default").

                    RUN PrintDataString(INPUT c-lbl-coluna,         "subtitulo_direito_verde").       
                    RUN PrintDataString(INPUT c-lbl-tribut,         "subtitulo_centro_verde").  
                    RUN PrintDataString(INPUT c-lbl-aliq,           "subtitulo_direito_verde"). 
                    RUN PrintDataString(INPUT c-lbl-reduc,          "subtitulo_direito_verde"). 
                    RUN PrintDataString(INPUT c-lbl-susp,           "subtitulo_centro_verde").  
                    RUN PrintDataString(INPUT c-lbl-valor-impostos, "subtitulo_direito_verde"). 
                    RUN PrintDataString(INPUT "",                   "Default").

                    RUN PrintDataString(INPUT c-lbl-coluna,         "subtitulo_direito_verde").       
                    RUN PrintDataString(INPUT c-lbl-tribut,         "subtitulo_centro_verde").  
                    RUN PrintDataString(INPUT c-lbl-aliq,           "subtitulo_direito_verde"). 
                    RUN PrintDataString(INPUT c-lbl-reduc,          "subtitulo_direito_verde"). 
                    RUN PrintDataString(INPUT c-lbl-susp,           "subtitulo_centro_verde").  
                    RUN PrintDataString(INPUT c-lbl-valor-impostos, "subtitulo_direito_verde"). 
                RUN CloseLine.

                /* II */
                IF  decla-import-adic-itens.idi-tributac-impto-import = 1 /* Tributado*/
                OR  decla-import-adic-itens.idi-tributac-impto-import = 4 /* Reduzido */ 
                THEN ASSIGN v-val-II-itens = decla-import-adic-itens.val-ii-db-cr.
                ELSE IF  decla-import-adic-itens.idi-tributac-impto-import = 2 /* Isento */
                     THEN ASSIGN v-val-II-itens = decla-import-adic-itens.val-ii-nao-tribut.
                     ELSE IF  decla-import-adic-itens.idi-tributac-impto-import = 3 /* Outros */
                          THEN ASSIGN v-val-II-itens = decla-import-adic-itens.val-ii-outras.
                
                RUN OpenLine.
                    RUN PrintDataString(INPUT c-lbl-II, "subtitulo_direito").       /* imposto       */
                    RUN PrintDataString(INPUT {cxinc/i01cx402.i 04 decla-import-adic-itens.idi-tributac-impto-import} , "logicos"). /* tributa‡Æo    */
                    RUN PrintDataNumber(INPUT decla-import-adic-itens.val-aliq-ii, "numeroFormato4"). /* aliquota      */
                    RUN PrintDataNumber(INPUT decla-import-adic-itens.val-perc-reduc-impto-import, "numeroFormato2"). /* reducao       */
                    RUN PrintDataString(INPUT string(decla-import-adic-itens.log-suspens-impto-import,"Sim/NÆo"),"logicos").
                    RUN PrintDataNumber(INPUT v-val-II-itens, "numeroFormato2"). /* valor imposto */
                    RUN PrintDataString(INPUT ""      , "Default").                           

                    RUN PrintDataString(INPUT c-lbl-II, "subtitulo_direito").       /* imposto       */
                    RUN PrintDataString(INPUT {cxinc/i01cx402.i 04 decla-import-adic-itens.idi-tributac-impto-import} , "logicos"). /* tributa‡Æo    */
                    RUN PrintDataNumber(INPUT decla-import-adic-itens.val-aliq-ii, "numeroFormato4"). /* aliquota      */
                    RUN PrintDataNumber(INPUT decla-import-adic-itens.val-perc-reduc-impto-import, "numeroFormato2"). /* reducao       */
                    RUN PrintDataString(INPUT string(decla-import-adic-itens.log-suspens-impto-import,"Sim/NÆo"),"logicos").
                    RUN PrintDataNumber(INPUT v-val-II-itens, "numeroFormato2"). /* valor imposto */
                    RUN PrintDataString(INPUT ""      , "Default").                           

                    RUN PrintDataString(INPUT c-lbl-II, "subtitulo_direito").       /* imposto       */
                    RUN PrintDataString(INPUT {cxinc/i01cx402.i 04 decla-import-adic-itens.idi-tributac-impto-import} , "logicos"). /* tributa‡Æo    */
                    RUN PrintDataNumber(INPUT decla-import-adic-itens.val-aliq-ii, "numeroFormato4"). /* aliquota      */
                    RUN PrintDataNumber(INPUT decla-import-adic-itens.val-perc-reduc-impto-import, "numeroFormato2"). /* reducao       */
                    RUN PrintDataString(INPUT string(decla-import-adic-itens.log-suspens-impto-import,"Sim/NÆo"),"logicos").
                    RUN PrintDataNumber(INPUT v-val-II-itens, "numeroFormato2"). /* valor imposto */
                RUN CloseLine.

                /* IPI */
                IF  decla-import-adic-itens.idi-tributac-ipi = 1 /* Tributado*/ 
                OR  decla-import-adic-itens.idi-tributac-ipi = 4 /* Reduzido */ 
                THEN ASSIGN v-val-IPI-itens = decla-import-adic-itens.val-ipi-db-cr.
                ELSE IF  decla-import-adic-itens.idi-tributac-ipi = 2 /* Isento */
                     THEN ASSIGN v-val-IPI-itens = decla-import-adic-itens.val-ipi-nao-tribut.
                     ELSE IF  decla-import-adic-itens.idi-tributac-ipi = 3 /* Outros */
                          THEN ASSIGN v-val-IPI-itens = decla-import-adic-itens.val-ipi-outras.
                RUN OpenLine.
                    RUN PrintDataString(INPUT c-lbl-IPI, "subtitulo_direito").       /* imposto       */
                    RUN PrintDataString(INPUT {cxinc/i01cx402.i 04 decla-import-adic-itens.idi-tributac-ipi} , "logicos"). /* tributa‡Æo    */
                    RUN PrintDataNumber(INPUT decla-import-adic-itens.val-aliq-ipi, "numeroFormato2"). /* aliquota      */
                    RUN PrintDataNumber(INPUT decla-import-adic-itens.val-perc-reduc-ipi, "numeroFormato2"). /* reducao       */
                    RUN PrintDataString(INPUT string(decla-import-adic-itens.log-suspens-ipi-import,"Sim/NÆo"),"logicos").
                    RUN PrintDataNumber(INPUT v-val-IPI-itens, "numeroFormato2"). /* valor imposto */
                    RUN PrintDataString(INPUT ""       , "Default").                           

                    RUN PrintDataString(INPUT c-lbl-IPI, "subtitulo_direito").       /* imposto       */
                    RUN PrintDataString(INPUT {cxinc/i01cx402.i 04 decla-import-adic-itens.idi-tributac-ipi} , "logicos"). /* tributa‡Æo    */
                    RUN PrintDataNumber(INPUT decla-import-adic-itens.val-aliq-ipi, "numeroFormato2"). /* aliquota      */
                    RUN PrintDataNumber(INPUT decla-import-adic-itens.val-perc-reduc-ipi, "numeroFormato2"). /* reducao       */
                    RUN PrintDataString(INPUT string(decla-import-adic-itens.log-suspens-ipi-import,"Sim/NÆo"),"logicos").
                    RUN PrintDataNumber(INPUT v-val-IPI-itens, "numeroFormato2"). /* valor imposto */
                    RUN PrintDataString(INPUT ""       , "Default").                           

                    RUN PrintDataString(INPUT c-lbl-IPI, "subtitulo_direito").       /* imposto       */
                    RUN PrintDataString(INPUT {cxinc/i01cx402.i 04 decla-import-adic-itens.idi-tributac-ipi} , "logicos"). /* tributa‡Æo    */
                    RUN PrintDataNumber(INPUT decla-import-adic-itens.val-aliq-ipi, "numeroFormato2"). /* aliquota      */
                    RUN PrintDataNumber(INPUT decla-import-adic-itens.val-perc-reduc-ipi, "numeroFormato2"). /* reducao       */
                    RUN PrintDataString(INPUT string(decla-import-adic-itens.log-suspens-ipi-import,"Sim/NÆo"),"logicos").
                    RUN PrintDataNumber(INPUT v-val-IPI-itens, "numeroFormato2"). /* valor imposto */
                RUN CloseLine.

                /* PIS */
                IF  decla-import-adic-itens.idi-tributac-pis = 1 /* Tributado*/
                OR  decla-import-adic-itens.idi-tributac-pis = 4 /* Reduzido */ 
                THEN ASSIGN v-val-PIS-itens = decla-import-adic-itens.val-pis-db-cr.
                ELSE IF  decla-import-adic-itens.idi-tributac-pis = 2 /* Isento */
                     THEN ASSIGN v-val-PIS-itens = decla-import-adic-itens.val-pis-nao-tribut.
                     ELSE IF  decla-import-adic-itens.idi-tributac-pis = 3 /* Outros */
                          THEN ASSIGN v-val-PIS-itens = decla-import-adic-itens.val-pis-outras.

                RUN OpenLine.
                    RUN PrintDataString(INPUT c-lbl-PIS, "subtitulo_direito").       /* imposto       */
                    RUN PrintDataString(INPUT {cxinc/i01cx402.i 04 decla-import-adic-itens.idi-tributac-pis} , "logicos"). /* tributa‡Æo    */
                    RUN PrintDataNumber(INPUT decla-import-adic-itens.val-aliq-pis, "numeroFormato4"). /* aliquota      */
                    RUN PrintDataNumber(INPUT decla-import-adic-itens.val-perc-reduc-pis, "numeroFormato2"). /* reducao       */
                    RUN PrintDataString(INPUT ""       , "logicos").                 /* suspenso      */
                    RUN PrintDataNumber(INPUT v-val-PIS-itens, "numeroFormato2"). /* valor imposto */
                    RUN PrintDataString(INPUT ""       , "Default").                           

                    RUN PrintDataString(INPUT c-lbl-PIS, "subtitulo_direito").       /* imposto       */
                    RUN PrintDataString(INPUT {cxinc/i01cx402.i 04 decla-import-adic-itens.idi-tributac-pis} , "logicos"). /* tributa‡Æo    */
                    RUN PrintDataNumber(INPUT decla-import-adic-itens.val-aliq-pis, "numeroFormato4"). /* aliquota      */
                    RUN PrintDataNumber(INPUT decla-import-adic-itens.val-perc-reduc-pis, "numeroFormato2"). /* reducao       */
                    RUN PrintDataString(INPUT ""       , "logicos").                 /* suspenso      */
                    RUN PrintDataNumber(INPUT v-val-PIS-itens, "numeroFormato2"). /* valor imposto */
                    RUN PrintDataString(INPUT ""       , "Default").                           

                    RUN PrintDataString(INPUT c-lbl-PIS, "subtitulo_direito").       /* imposto       */
                    RUN PrintDataString(INPUT {cxinc/i01cx402.i 04 decla-import-adic-itens.idi-tributac-pis} , "logicos"). /* tributa‡Æo    */
                    RUN PrintDataNumber(INPUT decla-import-adic-itens.val-aliq-pis, "numeroFormato4"). /* aliquota      */
                    RUN PrintDataNumber(INPUT decla-import-adic-itens.val-perc-reduc-pis, "numeroFormato2"). /* reducao       */
                    RUN PrintDataString(INPUT ""       , "logicos").                 /* suspenso      */
                    RUN PrintDataNumber(INPUT v-val-PIS-itens, "numeroFormato2"). /* valor imposto */
                RUN CloseLine.

                /* COFINS */
                IF  decla-import-adic-itens.idi-tributac-cofins = 1 /* Tributado*/
                OR  decla-import-adic-itens.idi-tributac-cofins = 4  /* Reduzido */
                THEN ASSIGN v-val-COFINS-itens = decla-import-adic-itens.val-cofins-db-cr.
                ELSE IF  decla-import-adic-itens.idi-tributac-cofins = 2 /* Isento */ 
                     THEN ASSIGN v-val-COFINS-itens = decla-import-adic-itens.val-cofins-nao-tribut.
                     ELSE IF  decla-import-adic-itens.idi-tributac-cofins = 3 /* Outros */
                          THEN ASSIGN v-val-COFINS-itens = decla-import-adic-itens.val-cofins-outras.

                RUN OpenLine.
                    RUN PrintDataString(INPUT c-lbl-COFINS, "subtitulo_direito").       /* imposto       */
                    RUN PrintDataString(INPUT {cxinc/i01cx402.i 04 decla-import-adic-itens.idi-tributac-cofins} , "logicos"). /* tributa‡Æo    */
                    RUN PrintDataNumber(INPUT decla-import-adic-itens.val-aliq-cofins, "numeroFormato4"). /* aliquota      */
                    RUN PrintDataNumber(INPUT decla-import-adic-itens.val-perc-reduc-cofins, "numeroFormato2"). /* reducao       */
                    RUN PrintDataString(INPUT ""          , "logicos").                 /* suspenso      */
                    RUN PrintDataNumber(INPUT v-val-COFINS-itens, "numeroFormato2"). /* valor imposto */
                    RUN PrintDataString(INPUT ""          , "Default").                           

                    RUN PrintDataString(INPUT c-lbl-COFINS, "subtitulo_direito").       /* imposto       */
                    RUN PrintDataString(INPUT {cxinc/i01cx402.i 04 decla-import-adic-itens.idi-tributac-cofins} , "logicos"). /* tributa‡Æo    */
                    RUN PrintDataNumber(INPUT decla-import-adic-itens.val-aliq-cofins, "numeroFormato4"). /* aliquota      */
                    RUN PrintDataNumber(INPUT decla-import-adic-itens.val-perc-reduc-cofins, "numeroFormato2"). /* reducao       */
                    RUN PrintDataString(INPUT ""          , "logicos").                 /* suspenso      */
                    RUN PrintDataNumber(INPUT v-val-COFINS-itens, "numeroFormato2"). /* valor imposto */
                    RUN PrintDataString(INPUT ""          , "Default").                           

                    RUN PrintDataString(INPUT c-lbl-COFINS, "subtitulo_direito").       /* imposto       */
                    RUN PrintDataString(INPUT {cxinc/i01cx402.i 04 decla-import-adic-itens.idi-tributac-cofins} , "logicos"). /* tributa‡Æo    */
                    RUN PrintDataNumber(INPUT decla-import-adic-itens.val-aliq-cofins, "numeroFormato4"). /* aliquota      */
                    RUN PrintDataNumber(INPUT decla-import-adic-itens.val-perc-reduc-cofins, "numeroFormato2"). /* reducao       */
                    RUN PrintDataString(INPUT ""          , "logicos").                 /* suspenso      */
                    RUN PrintDataNumber(INPUT v-val-COFINS-itens, "numeroFormato2"). /* valor imposto */
                RUN CloseLine.

                /* ICMS */
                IF decla-import-adic-itens.idi-tributac-icms = 1 /* Tributado*/
                OR decla-import-adic-itens.idi-tributac-icms = 4 /* Reduzido */
                THEN ASSIGN v-val-ICMS-itens = decla-import-adic-itens.val-icms-db-cr.
                ELSE IF  decla-import-adic-itens.idi-tributac-icms = 2 /* Isento */
                     THEN ASSIGN v-val-ICMS-itens = decla-import-adic-itens.val-icms-nao-tribut.
                     ELSE IF  decla-import-adic-itens.idi-tributac-icms = 3 /* Outros */
                          THEN ASSIGN v-val-ICMS-itens = decla-import-adic-itens.val-icms-outras.
                RUN OpenLine.
                    RUN PrintDataString(INPUT c-lbl-ICMS, "subtitulo_direito").       /* imposto       */
                    RUN PrintDataString(INPUT {cxinc/i02cx402.i 04 decla-import-adic-itens.idi-tributac-icms} , "logicos"). /* tributa‡Æo    */
                    RUN PrintDataNumber(INPUT decla-import-adic-itens.val-aliq-icms, "numeroFormato2"). /* aliquota      */
                    RUN PrintDataNumber(INPUT decla-import-adic-itens.val-perc-reduc-icms, "numeroFormato2"). /* reducao       */
                    RUN PrintDataString(INPUT ""        , "logicos").                 /* suspenso      */
                    RUN PrintDataNumber(INPUT v-val-ICMS-itens, "numeroFormato2"). /* valor imposto */
                    RUN PrintDataString(INPUT ""        , "Default").                           

                    RUN PrintDataString(INPUT c-lbl-ICMS, "subtitulo_direito").       /* imposto       */
                    RUN PrintDataString(INPUT {cxinc/i02cx402.i 04 decla-import-adic-itens.idi-tributac-icms} , "logicos"). /* tributa‡Æo    */
                    RUN PrintDataNumber(INPUT decla-import-adic-itens.val-aliq-icms, "numeroFormato2"). /* aliquota      */
                    RUN PrintDataNumber(INPUT decla-import-adic-itens.val-perc-reduc-icms, "numeroFormato2"). /* reducao       */
                    RUN PrintDataString(INPUT ""        , "logicos").                 /* suspenso      */
                    RUN PrintDataNumber(INPUT v-val-ICMS-itens, "numeroFormato2"). /* valor imposto */
                    RUN PrintDataString(INPUT ""        , "Default").                           

                    RUN PrintDataString(INPUT c-lbl-ICMS, "subtitulo_direito").       /* imposto       */
                    RUN PrintDataString(INPUT {cxinc/i02cx402.i 04 decla-import-adic-itens.idi-tributac-icms} , "logicos"). /* tributa‡Æo    */
                    RUN PrintDataNumber(INPUT decla-import-adic-itens.val-aliq-icms, "numeroFormato2"). /* aliquota      */
                    RUN PrintDataNumber(INPUT decla-import-adic-itens.val-perc-reduc-icms, "numeroFormato2"). /* reducao       */
                    RUN PrintDataString(INPUT ""        , "logicos").                 /* suspenso      */
                    RUN PrintDataNumber(INPUT v-val-ICMS-itens, "numeroFormato2"). /* valor imposto */
                RUN CloseLine.
                
                IF l-nt2024002 THEN DO:
                    ASSIGN i-trib-ibsuf-itens   = 1
                           de-aliq-ibsuf-itens  = 0
                           de-reduc-ibsuf-itens = 0
                           v-val-ibsuf-itens    = 0
                           i-trib-cbs-itens     = 1
                           de-aliq-cbs-itens    = 0
                           de-reduc-cbs-itens   = 0
                           v-val-cbs-itens      = 0
                           i-trib-ibsmun-itens   = 1
                           de-aliq-ibsmun-itens  = 0
                           de-reduc-ibsmun-itens = 0
                           v-val-ibsmun-itens    = 0
                           i-trib-is-itens       = 1
                           de-aliq-is-itens      = 0
                           v-val-is-itens        = 0.
                    FOR EACH decla-imp-adic-it-trib NO-LOCK
                       WHERE decla-imp-adic-it-trib.num-di-ems       = decla-import-adic-itens.num-di-ems
                         AND decla-imp-adic-it-trib.num-adic         = decla-import-adic-itens.num-adic
                         AND decla-imp-adic-it-trib.num-seq          = decla-import-adic-itens.num-seq
                         AND decla-imp-adic-it-trib.cdd-siscomex-dts = decla-import-adic-itens.cdd-siscomex-dts:
                        CASE decla-imp-adic-it-trib.nom-trib:
                            WHEN "IBSUF":U THEN
                                CASE decla-imp-adic-it-trib.cod-campo:
                                    WHEN "COD-TRIB":U THEN ASSIGN i-trib-ibsuf-itens = INT(REPLACE(decla-imp-adic-it-trib.cod-conteudo,',','.')).
                                    WHEN "ALIQUOTA":U THEN ASSIGN de-aliq-ibsuf-itens = DECIMAL(REPLACE(decla-imp-adic-it-trib.cod-conteudo,',','.')).
                                    WHEN "ALIQ-RED":U THEN ASSIGN de-reduc-ibsuf-itens = DECIMAL(REPLACE(decla-imp-adic-it-trib.cod-conteudo,',','.')).
                                    WHEN "VALOR":U OR
                                    WHEN "OUTROS":U   THEN ASSIGN v-val-ibsuf-itens = DECIMAL(REPLACE(decla-imp-adic-it-trib.cod-conteudo,',','.')).
                                END CASE.
                            WHEN "IBSMUN":U THEN
                                CASE decla-imp-adic-it-trib.cod-campo:
                                    WHEN "COD-TRIB":U THEN ASSIGN i-trib-ibsmun-itens = INT(REPLACE(decla-imp-adic-it-trib.cod-conteudo,',','.')).
                                    WHEN "ALIQUOTA":U THEN ASSIGN de-aliq-ibsmun-itens = DECIMAL(REPLACE(decla-imp-adic-it-trib.cod-conteudo,',','.')).
                                    WHEN "ALIQ-RED":U THEN ASSIGN de-reduc-ibsmun-itens = DECIMAL(REPLACE(decla-imp-adic-it-trib.cod-conteudo,',','.')).
                                    WHEN "VALOR":U OR
                                    WHEN "OUTROS":U   THEN ASSIGN v-val-ibsmun-itens = DECIMAL(REPLACE(decla-imp-adic-it-trib.cod-conteudo,',','.')).
                                END CASE.
                            WHEN "CBS":U THEN
                                CASE decla-imp-adic-it-trib.cod-campo:
                                    WHEN "COD-TRIB":U THEN ASSIGN i-trib-cbs-itens = INT(REPLACE(decla-imp-adic-it-trib.cod-conteudo,',','.')).
                                    WHEN "ALIQUOTA":U THEN ASSIGN de-aliq-cbs-itens = DECIMAL(REPLACE(decla-imp-adic-it-trib.cod-conteudo,',','.')).
                                    WHEN "ALIQ-RED":U THEN ASSIGN de-reduc-cbs-itens = DECIMAL(REPLACE(decla-imp-adic-it-trib.cod-conteudo,',','.')).
                                    WHEN "VALOR":U OR
                                    WHEN "OUTROS":U   THEN ASSIGN v-val-cbs-itens = DECIMAL(REPLACE(decla-imp-adic-it-trib.cod-conteudo,',','.')).
                                END CASE.
                            WHEN "IS":U THEN
                                CASE decla-imp-adic-it-trib.cod-campo:
                                    WHEN "COD-TRIB":U THEN ASSIGN i-trib-is-itens = INT(REPLACE(decla-imp-adic-it-trib.cod-conteudo,',','.')).
                                    WHEN "ALIQUOTA":U THEN ASSIGN de-aliq-is-itens = DECIMAL(REPLACE(decla-imp-adic-it-trib.cod-conteudo,',','.')).
                                    WHEN "VALOR":U OR
                                    WHEN "OUTROS":U   THEN ASSIGN v-val-is-itens = DECIMAL(REPLACE(decla-imp-adic-it-trib.cod-conteudo,',','.')).
                                END CASE.
                        END CASE.
                    END.
                    /* IBS UF */
                    RUN OpenLine.
                    RUN PrintDataString(INPUT "IBS UF":U,                                "subtitulo_direito").       /* imposto       */
                    RUN PrintDataString(INPUT {diinc/i01di628.i 04 i-trib-ibsuf-itens} , "logicos").                 /* tributa‡Æo    */
                    RUN PrintDataNumber(INPUT de-aliq-ibsuf-itens,                       "numeroFormato2").          /* aliquota      */
                    RUN PrintDataNumber(INPUT de-reduc-ibsuf-itens,                      "numeroFormato2").          /* reducao       */
                    RUN PrintDataString(INPUT "",                                        "logicos").                 /* suspenso      */
                    RUN PrintDataNumber(INPUT v-val-ibsuf-itens,                         "numeroFormato2").          /* valor imposto */
                    RUN PrintDataString(INPUT "",                                        "Default").                           

                    RUN PrintDataString(INPUT "IBS UF":U,                                "subtitulo_direito").       /* imposto       */
                    RUN PrintDataString(INPUT {diinc/i01di628.i 04 i-trib-ibsuf-itens} , "logicos").                 /* tributa‡Æo    */
                    RUN PrintDataNumber(INPUT de-aliq-ibsuf-itens,                       "numeroFormato2").          /* aliquota      */
                    RUN PrintDataNumber(INPUT de-reduc-ibsuf-itens,                      "numeroFormato2").          /* reducao       */
                    RUN PrintDataString(INPUT "",                                        "logicos").                 /* suspenso      */
                    RUN PrintDataNumber(INPUT v-val-ibsuf-itens,                         "numeroFormato2").          /* valor imposto */
                    RUN PrintDataString(INPUT "",                                        "Default").                           

                    RUN PrintDataString(INPUT "IBS UF":U,                                "subtitulo_direito").       /* imposto       */
                    RUN PrintDataString(INPUT {diinc/i01di628.i 04 i-trib-ibsuf-itens},  "logicos").                 /* tributa‡Æo    */
                    RUN PrintDataNumber(INPUT de-aliq-ibsuf-itens,                       "numeroFormato2").          /* aliquota      */
                    RUN PrintDataNumber(INPUT de-reduc-ibsuf-itens,                      "numeroFormato2").          /* reducao       */
                    RUN PrintDataString(INPUT "",                                        "logicos").                 /* suspenso      */
                    RUN PrintDataNumber(INPUT v-val-ibsuf-itens,                         "numeroFormato2").          /* valor imposto */
                    RUN CloseLine.
                    /* IBS Mun */
                    RUN OpenLine.
                    RUN PrintDataString(INPUT "IBS Mun":U,                               "subtitulo_direito").       /* imposto       */
                    RUN PrintDataString(INPUT {diinc/i01di628.i 04 i-trib-ibsmun-itens}, "logicos").                 /* tributa‡Æo    */
                    RUN PrintDataNumber(INPUT de-aliq-ibsmun-itens,                      "numeroFormato2").          /* aliquota      */
                    RUN PrintDataNumber(INPUT de-reduc-ibsmun-itens,                     "numeroFormato2").          /* reducao       */
                    RUN PrintDataString(INPUT "",                                        "logicos").                 /* suspenso      */
                    RUN PrintDataNumber(INPUT v-val-ibsmun-itens,                        "numeroFormato2").          /* valor imposto */
                    RUN PrintDataString(INPUT "",                                        "Default").                           

                    RUN PrintDataString(INPUT "IBS Mun":U,                               "subtitulo_direito").       /* imposto       */
                    RUN PrintDataString(INPUT {diinc/i01di628.i 04 i-trib-ibsmun-itens}, "logicos").                 /* tributa‡Æo    */
                    RUN PrintDataNumber(INPUT de-aliq-ibsmun-itens,                      "numeroFormato2").          /* aliquota      */
                    RUN PrintDataNumber(INPUT de-reduc-ibsmun-itens,                     "numeroFormato2").          /* reducao       */
                    RUN PrintDataString(INPUT "",                                        "logicos").                 /* suspenso      */
                    RUN PrintDataNumber(INPUT v-val-ibsmun-itens,                        "numeroFormato2").          /* valor imposto */
                    RUN PrintDataString(INPUT "",                                        "Default").                           

                    RUN PrintDataString(INPUT "IBS Mun":U,                               "subtitulo_direito").       /* imposto       */
                    RUN PrintDataString(INPUT {diinc/i01di628.i 04 i-trib-ibsmun-itens}, "logicos").                 /* tributa‡Æo    */
                    RUN PrintDataNumber(INPUT de-aliq-ibsmun-itens,                      "numeroFormato2").          /* aliquota      */
                    RUN PrintDataNumber(INPUT de-reduc-ibsmun-itens,                     "numeroFormato2").          /* reducao       */
                    RUN PrintDataString(INPUT "",                                        "logicos").                 /* suspenso      */
                    RUN PrintDataNumber(INPUT v-val-ibsmun-itens,                        "numeroFormato2").          /* valor imposto */
                    RUN CloseLine.
                    /* CBS */
                    RUN OpenLine.
                    RUN PrintDataString(INPUT "CBS":U,                                   "subtitulo_direito").       /* imposto       */
                    RUN PrintDataString(INPUT {diinc/i01di628.i 04 i-trib-cbs-itens} ,   "logicos").                 /* tributa‡Æo    */
                    RUN PrintDataNumber(INPUT de-aliq-cbs-itens,                         "numeroFormato2").          /* aliquota      */
                    RUN PrintDataNumber(INPUT de-reduc-cbs-itens,                        "numeroFormato2").          /* reducao       */
                    RUN PrintDataString(INPUT "",                                        "logicos").                 /* suspenso      */
                    RUN PrintDataNumber(INPUT v-val-cbs-itens,                           "numeroFormato2").          /* valor imposto */
                    RUN PrintDataString(INPUT "",                                        "Default").                           

                    RUN PrintDataString(INPUT "CBS":U,                                   "subtitulo_direito").       /* imposto       */
                    RUN PrintDataString(INPUT {diinc/i01di628.i 04 i-trib-cbs-itens},    "logicos").                 /* tributa‡Æo    */
                    RUN PrintDataNumber(INPUT de-aliq-cbs-itens,                         "numeroFormato2").          /* aliquota      */
                    RUN PrintDataNumber(INPUT de-reduc-cbs-itens,                        "numeroFormato2").          /* reducao       */
                    RUN PrintDataString(INPUT "",                                        "logicos").                 /* suspenso      */
                    RUN PrintDataNumber(INPUT v-val-cbs-itens,                           "numeroFormato2").          /* valor imposto */
                    RUN PrintDataString(INPUT "",                                        "Default").                           

                    RUN PrintDataString(INPUT "CBS":U,                                   "subtitulo_direito").       /* imposto       */
                    RUN PrintDataString(INPUT {diinc/i01di628.i 04 i-trib-cbs-itens},    "logicos").                 /* tributa‡Æo    */
                    RUN PrintDataNumber(INPUT de-aliq-cbs-itens,                         "numeroFormato2").          /* aliquota      */
                    RUN PrintDataNumber(INPUT de-reduc-cbs-itens,                        "numeroFormato2").          /* reducao       */
                    RUN PrintDataString(INPUT "",                                        "logicos").                 /* suspenso      */
                    RUN PrintDataNumber(INPUT v-val-cbs-itens,                           "numeroFormato2").          /* valor imposto */
                    RUN CloseLine.
                    
                    /* IS */
                    RUN OpenLine.
                    RUN PrintDataString(INPUT "IS":U,                                    "subtitulo_direito").       /* imposto       */
                    RUN PrintDataString(INPUT {diinc/i01di628.i 04 i-trib-is-itens} ,    "logicos").                 /* tributa‡Æo    */
                    RUN PrintDataNumber(INPUT de-aliq-is-itens,                          "numeroFormato2").          /* aliquota      */
                    RUN PrintDataNumber(INPUT 0,                                         "numeroFormato2").          /* reducao       */
                    RUN PrintDataString(INPUT "",                                        "logicos").                 /* suspenso      */
                    RUN PrintDataNumber(INPUT v-val-is-itens,                            "numeroFormato2").          /* valor imposto */
                    RUN PrintDataString(INPUT "",                                        "Default").                           

                    RUN PrintDataString(INPUT "IS":U,                                    "subtitulo_direito").       /* imposto       */
                    RUN PrintDataString(INPUT {diinc/i01di628.i 04 i-trib-is-itens},     "logicos").                 /* tributa‡Æo    */
                    RUN PrintDataNumber(INPUT de-aliq-is-itens,                          "numeroFormato2").          /* aliquota      */
                    RUN PrintDataNumber(INPUT 0,                                         "numeroFormato2").          /* reducao       */
                    RUN PrintDataString(INPUT "",                                        "logicos").                 /* suspenso      */
                    RUN PrintDataNumber(INPUT v-val-is-itens,                            "numeroFormato2").          /* valor imposto */
                    RUN PrintDataString(INPUT "",                                        "Default").                           

                    RUN PrintDataString(INPUT "IS":U,                                    "subtitulo_direito").       /* imposto       */
                    RUN PrintDataString(INPUT {diinc/i01di628.i 04 i-trib-is-itens},     "logicos").                 /* tributa‡Æo    */
                    RUN PrintDataNumber(INPUT de-aliq-is-itens,                          "numeroFormato2").          /* aliquota      */
                    RUN PrintDataNumber(INPUT 0,                                         "numeroFormato2").          /* reducao       */
                    RUN PrintDataString(INPUT "",                                        "logicos").                 /* suspenso      */
                    RUN PrintDataNumber(INPUT v-val-is-itens,                            "numeroFormato2").          /* valor imposto */
                    RUN CloseLine.
                END.
             END. /* for each decla-import-adic-itens */
            /* fim - item */

        END. /* for each decla-import-adic */
        /*=======================
          Fim ImpressÆo dos Dados
          =======================*/
    
        run CloseTable.
    	run OpenWorksheetOptions.
    	run CloseWorksheetOptions.
    	run CloseWorkSheet.
    	run CloseWorkBook.

    END. /*for first decla-import*/

    IF VALID-HANDLE(h-bocx383) THEN DO:
        DELETE PROCEDURE h-bocx383.
        ASSIGN h-bocx383 = ?.
    END.

END PROCEDURE. /* PROCEDURE pi-gera-relatorio: */

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

end procedure. /* procedure OpenWorkBook: */

procedure CloseWorkBook:

    put unformatted
        '</Workbook>'.

end procedure. /* procedure CloseWorkBook: */

procedure OpenExcelWorkBook:

    put unformatted
        '<ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">' skip
        '   <WindowHeight>2970</WindowHeight>'                           skip
        '   <WindowWidth>11340</WindowWidth>'                            skip
        '   <WindowTopX>360</WindowTopX>'                                skip
        '   <WindowTopY>105</WindowTopY>'                                skip
        '   <ProtectStructure>False</ProtectStructure>'                  skip
        '   <ProtectWindows>False</ProtectWindows>'                      skip.

end procedure. /* procedure OpenExcelWorkBook: */

procedure CloseExcelWorkBook:

    put unformatted
        '</ExcelWorkbook>' skip.
end procedure. /* procedure CloseExcelWorkBook: */

procedure OpenStyles:

    put unformatted
        '<Styles>'                                    skip
        '   <Style ss:ID="Default" ss:Name="Normal">' skip
        '      <Alignment ss:Vertical="Bottom"/>'     skip
        '      <Borders/>'                            skip
        '      <Font/>'                               skip
        '      <Interior/>'                           skip
        '      <NumberFormat/>'                       skip
        '      <Protection/>'                         SKIP
        '   </Style>'                                 skip.

    put unformatted
        '   <Style ss:ID="padrao">'                                                       skip
        '      <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'                    SKIP
        '      <Borders>'                                                                 skip
        '         <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '         <Border ss:Position="Left"   ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '         <Border ss:Position="Right"  ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '         <Border ss:Position="Top"    ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '      </Borders>'                                                                SKIP
        '      <Protection/>'                                                             SKIP
        '      <Font x:Family="Swiss"/>'                                                  SKIP
        '   </Style>'                                                                     SKIP.

    put unformatted
        '   <Style ss:ID="logicos">'                                                      skip
        '      <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'                  SKIP
        '      <Borders>'                                                                 skip
        '         <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '         <Border ss:Position="Left"   ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '         <Border ss:Position="Right"  ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '         <Border ss:Position="Top"    ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '      </Borders>'                                                                SKIP
        '      <Protection/>'                                                             SKIP
        '      <Font x:Family="Swiss"/>'                                                  SKIP
        '   </Style>'                                                                     SKIP.

    put unformatted
        '   <Style ss:ID="numeroFormato2">'                                               skip
        '      <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'                   SKIP
        '      <Borders>'                                                                 skip
        '         <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '         <Border ss:Position="Left"   ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '         <Border ss:Position="Right"  ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '         <Border ss:Position="Top"    ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '      </Borders>'                                                                SKIP
        '      <Protection/>'                                                             SKIP
        '      <NumberFormat ss:Format="###,###,###,##0.00"/>'                            SKIP
        '      <Font x:Family="Swiss"/>'                                                  SKIP
        '   </Style>'                                                                     SKIP.

    put unformatted
        '   <Style ss:ID="numeroFormato4">'                                               skip
        '      <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'                   SKIP
        '      <Borders>'                                                                 skip
        '         <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '         <Border ss:Position="Left"   ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '         <Border ss:Position="Right"  ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '         <Border ss:Position="Top"    ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '      </Borders>'                                                                SKIP
        '      <Protection/>'                                                             SKIP
        '      <NumberFormat ss:Format="###,###,###,##0.0000"/>'                          SKIP
        '      <Font x:Family="Swiss"/>'                                                  SKIP
        '   </Style>'                                                                     SKIP.

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
        '      <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'                  SKIP
        '      <Borders>'                                                                 skip
        '         <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '         <Border ss:Position="Left"   ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '         <Border ss:Position="Right"  ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '         <Border ss:Position="Top"    ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '      </Borders>'                                                                SKIP
        '      <Protection/>'                                                             SKIP
        '      <Font x:Family="Swiss" ss:Bold="1" ss:Italic="1"/>'                        SKIP
        '      <Interior ss:Color="#CCCCCC" ss:Pattern="Solid"/>'                         SKIP
        '   </Style>'                                                                     SKIP.

    put unformatted
        '   <Style ss:ID="subtitulo">'                                                    skip
        '      <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'                    SKIP
        '      <Borders>'                                                                 skip
        '         <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '         <Border ss:Position="Left"   ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '         <Border ss:Position="Right"  ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '         <Border ss:Position="Top"    ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '      </Borders>'                                                                SKIP
        '      <Protection/>'                                                             SKIP
        '      <Font x:Family="Swiss" ss:Bold="1" />'                                     SKIP
        '      <Interior ss:Color="#CCCCCC" ss:Pattern="Solid"/>'                         SKIP
        '   </Style>'                                                                     SKIP.

    put unformatted
        '   <Style ss:ID="subtitulo_adicao">'                                             skip
        '      <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'                    SKIP
        '      <Borders>'                                                                 skip
        '         <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '         <Border ss:Position="Left"   ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '         <Border ss:Position="Right"  ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '         <Border ss:Position="Top"    ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '      </Borders>'                                                                SKIP
        '      <Protection/>'                                                             SKIP
        '      <Font x:Family="Swiss" ss:Bold="1" />'                                     SKIP
        '      <Interior ss:Color="#A4D3EE" ss:Pattern="Solid"/>'                         SKIP
        '   </Style>'                                                                     SKIP.

    put unformatted
    '   <Style ss:ID="subtitulo_item">'                                             skip
    '      <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'                    SKIP
    '      <Borders>'                                                                 skip
    '         <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' skip
    '         <Border ss:Position="Left"   ss:LineStyle="Continuous" ss:Weight="1"/>' skip
    '         <Border ss:Position="Right"  ss:LineStyle="Continuous" ss:Weight="1"/>' skip
    '         <Border ss:Position="Top"    ss:LineStyle="Continuous" ss:Weight="1"/>' skip
    '      </Borders>'                                                                SKIP
    '      <Protection/>'                                                             SKIP
    '      <Font x:Family="Swiss" ss:Bold="1" />'                                     SKIP
    '      <Interior ss:Color="#9BCD9B" ss:Pattern="Solid"/>'                         SKIP
    '   </Style>'                                                                     SKIP.

    put unformatted
        '   <Style ss:ID="subtitulo_direito">'                                            skip
        '      <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'                   SKIP
        '      <Borders>'                                                                 skip
        '         <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '         <Border ss:Position="Left"   ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '         <Border ss:Position="Right"  ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '         <Border ss:Position="Top"    ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '      </Borders>'                                                                SKIP
        '      <Protection/>'                                                             SKIP
        '      <Font x:Family="Swiss" ss:Bold="1" />'                                     SKIP
        '      <Interior ss:Pattern="Solid"/>'                                            SKIP
        '   </Style>'                                                                     SKIP.

    put unformatted
        '   <Style ss:ID="subtitulo_direito_cinza">'                                      skip
        '      <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'                   SKIP
        '      <Borders>'                                                                 skip
        '         <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '         <Border ss:Position="Left"   ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '         <Border ss:Position="Right"  ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '         <Border ss:Position="Top"    ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '      </Borders>'                                                                SKIP
        '      <Protection/>'                                                             SKIP
        '      <Font x:Family="Swiss" />'                                                 SKIP
        '      <Interior ss:Color="#CCCCCC" ss:Pattern="Solid"/>'                         SKIP
        '   </Style>'                                                                     SKIP.

    put unformatted
        '   <Style ss:ID="subtitulo_centro_cinza">'                                      skip
        '      <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'                   SKIP
        '      <Borders>'                                                                 skip
        '         <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '         <Border ss:Position="Left"   ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '         <Border ss:Position="Right"  ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '         <Border ss:Position="Top"    ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '      </Borders>'                                                                SKIP
        '      <Protection/>'                                                             SKIP
        '      <Font x:Family="Swiss" />'                                                 SKIP
        '      <Interior ss:Color="#CCCCCC" ss:Pattern="Solid"/>'                         SKIP
        '   </Style>'                                                                     SKIP.

    put unformatted
        '   <Style ss:ID="subtitulo_direito_azul">'                                      skip
        '      <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'                   SKIP
        '      <Borders>'                                                                 skip
        '         <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '         <Border ss:Position="Left"   ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '         <Border ss:Position="Right"  ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '         <Border ss:Position="Top"    ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '      </Borders>'                                                                SKIP
        '      <Protection/>'                                                             SKIP
        '      <Font x:Family="Swiss" />'                                                 SKIP
        '      <Interior ss:Color="#A4D3EE" ss:Pattern="Solid"/>'                         SKIP
        '   </Style>'                                                                     SKIP.

    put unformatted
        '   <Style ss:ID="subtitulo_centro_azul">'                                      skip
        '      <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'                   SKIP
        '      <Borders>'                                                                 skip
        '         <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '         <Border ss:Position="Left"   ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '         <Border ss:Position="Right"  ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '         <Border ss:Position="Top"    ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '      </Borders>'                                                                SKIP
        '      <Protection/>'                                                             SKIP
        '      <Font x:Family="Swiss" />'                                                 SKIP
        '      <Interior ss:Color="#A4D3EE" ss:Pattern="Solid"/>'                         SKIP
        '   </Style>'                                                                     SKIP.

    put unformatted
        '   <Style ss:ID="subtitulo_direito_verde">'                                      skip
        '      <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'                   SKIP
        '      <Borders>'                                                                 skip
        '         <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '         <Border ss:Position="Left"   ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '         <Border ss:Position="Right"  ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '         <Border ss:Position="Top"    ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '      </Borders>'                                                                SKIP
        '      <Protection/>'                                                             SKIP
        '      <Font x:Family="Swiss" />'                                                 SKIP
        '      <Interior ss:Color="#9BCD9B" ss:Pattern="Solid"/>'                         SKIP
        '   </Style>'                                                                     SKIP.

    put unformatted
        '   <Style ss:ID="subtitulo_centro_verde">'                                      skip
        '      <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'                   SKIP
        '      <Borders>'                                                                 skip
        '         <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '         <Border ss:Position="Left"   ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '         <Border ss:Position="Right"  ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '         <Border ss:Position="Top"    ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '      </Borders>'                                                                SKIP
        '      <Protection/>'                                                             SKIP
        '      <Font x:Family="Swiss" />'                                                 SKIP
        '      <Interior ss:Color="#9BCD9B" ss:Pattern="Solid"/>'                         SKIP
        '   </Style>'                                                                     SKIP.

    put unformatted
    '   <Style ss:ID="cabecalho">'                                                    skip
    '      <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'                    SKIP
    '      <Borders>'                                                                 skip
    '         <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' skip
    '         <Border ss:Position="Left"   ss:LineStyle="Continuous" ss:Weight="1"/>' skip
    '         <Border ss:Position="Right"  ss:LineStyle="Continuous" ss:Weight="1"/>' skip
    '         <Border ss:Position="Top"    ss:LineStyle="Continuous" ss:Weight="1"/>' skip
    '      </Borders>'                                                                SKIP
    '      <Protection/>'                                                             SKIP
    '      <Font x:Family="Swiss" />'                                                 SKIP
    '      <Interior ss:Color="#CCCCCC" ss:Pattern="Solid"/>'                         SKIP
    '   </Style>'                                                                     SKIP.

    put unformatted
    '   <Style ss:ID="cabecalho_adicao">'                                             skip
    '      <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'                    SKIP
    '      <Borders>'                                                                 skip
    '         <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' skip
    '         <Border ss:Position="Left"   ss:LineStyle="Continuous" ss:Weight="1"/>' skip
    '         <Border ss:Position="Right"  ss:LineStyle="Continuous" ss:Weight="1"/>' skip
    '         <Border ss:Position="Top"    ss:LineStyle="Continuous" ss:Weight="1"/>' skip
    '      </Borders>'                                                                SKIP
    '      <Protection/>'                                                             SKIP
    '      <Font x:Family="Swiss" />'                                                 SKIP
    '      <Interior ss:Color="#A4D3EE" ss:Pattern="Solid"/>'                         SKIP
    '   </Style>'                                                                     SKIP.

    put unformatted
    '   <Style ss:ID="cabecalho_item">'                                               skip
    '      <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'                    SKIP
    '      <Borders>'                                                                 skip
    '         <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' skip
    '         <Border ss:Position="Left"   ss:LineStyle="Continuous" ss:Weight="1"/>' skip
    '         <Border ss:Position="Right"  ss:LineStyle="Continuous" ss:Weight="1"/>' skip
    '         <Border ss:Position="Top"    ss:LineStyle="Continuous" ss:Weight="1"/>' skip
    '      </Borders>'                                                                SKIP
    '      <Protection/>'                                                             SKIP
    '      <Font x:Family="Swiss" />'                                                 SKIP
    '      <Interior ss:Color="#9BCD9B" ss:Pattern="Solid"/>'                         SKIP
    '   </Style>'                                                                     SKIP.

    put unformatted
        '   <Style ss:ID="divisoria">'                                                    skip
        '      <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'                    SKIP
        '      <Borders>'                                                                 skip
        '         <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '         <Border ss:Position="Left"   ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '         <Border ss:Position="Right"  ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '         <Border ss:Position="Top"    ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '      </Borders>'                                                                SKIP
        '      <Font x:Family="Swiss" ss:Bold="1" ss:Italic="1"/>'                        SKIP
        '      <Protection/>'                                                             SKIP
        '      <Interior ss:Color="#6CA6CD" ss:Pattern="Solid"/>'                         SKIP
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
        '   <Style ss:ID="mascara">'                                                      skip
        '      <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'                  SKIP
        '      <Borders>'                                                                 SKIP
        '         <Border ss:Position="Bottom"   ss:LineStyle="Continuous" ss:Weight="1"/>' SKIP
        '      </Borders>'                                                                SKIP
        '      <Protection/>'                                                             SKIP
        '   </Style>'                                                                     SKIP.

    put unformatted
        '   <Style ss:ID="assinatura">'                                                   skip
        '      <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'                  SKIP
        '      <Borders>'                                                                 SKIP
        '         <Border ss:Position="Top"   ss:LineStyle="Continuous" ss:Weight="1"/>'  SKIP
        '      </Borders>'                                                                SKIP
        '      <Protection/>'                                                             SKIP
        '   </Style>'                                                                     SKIP.

    put unformatted
        '   <Style ss:ID="pagina">'                                                       skip
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
        '   <Style ss:ID="m33">'                                                          skip
        '      <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'                  SKIP
        '      <Borders>'                                                                 SKIP
        '         <Border ss:Position="Right"  ss:LineStyle="Continuous" ss:Weight="2"/>' SKIP
        '      </Borders>'                                                                SKIP
        '      <Font x:Family="Swiss" ss:Bold="1"/>'                                      SKIP
        '      <Protection/>'                                                             SKIP
        '   </Style>'                                                                     skip.

    put unformatted
        '   <Style ss:ID="m22">'                                                          skip
        '      <Alignment ss:Vertical="Bottom"/>'                                         skip
        '      <Borders>'                                                                 skip
        '         <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>' skip
        '         <Border ss:Position="Left"   ss:LineStyle="Continuous" ss:Weight="2"/>' skip
        '         <Border ss:Position="Right"  ss:LineStyle="Continuous" ss:Weight="2"/>' skip
        '         <Border ss:Position="Top"    ss:LineStyle="Continuous" ss:Weight="2"/>' skip
        '      </Borders>'                                                                SKIP
        '      <Protection/>'                                                             SKIP
        '   </Style>'                                                                     skip.

    put unformatted
      '     <Style ss:ID="m23">'                                                          SKIP
      '        <Alignment ss:Vertical="Bottom"/>'                                         SKIP
      '        <Borders>'                                                                 SKIP
      '           <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'    SKIP
      '        </Borders>'                                                                SKIP
      '        <Protection/>'                                                             SKIP
      '     </Style>'                                                                     SKIP.

    put unformatted
      '     <Style ss:ID="m24">'                                                          SKIP
      '        <Alignment ss:Vertical="Bottom"/>'                                         SKIP
      '        <Borders>'                                                                 SKIP
      '           <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>' SKIP
      '           <Border ss:Position="Left"   ss:LineStyle="Continuous" ss:Weight="2"/>' SKIP
      '           <Border ss:Position="Right"  ss:LineStyle="Continuous" ss:Weight="2"/>' SKIP
      '        </Borders>'                                                                SKIP
      '        <Protection/>'                                                             SKIP
      '     </Style>'                                                                     SKIP.

    put unformatted
      '     <Style ss:ID="m27">'                                                          SKIP
      '        <Alignment ss:Vertical="Bottom"/>'                                         SKIP
      '        <Borders>'                                                                 SKIP
      '           <Border ss:Position="Left"   ss:LineStyle="Continuous" ss:Weight="2"/>' SKIP
      '        </Borders>'                                                                SKIP
      '        <Protection/>'                                                             SKIP
      '     </Style>'                                                                     SKIP.

    put unformatted
      '     <Style ss:ID="m31">'                                                          SKIP
      '        <Alignment ss:Vertical="Bottom"/>'                                         SKIP
      '        <Borders>'                                                                 SKIP
      '           <Border ss:Position="Left"   ss:LineStyle="Continuous" ss:Weight="2"/>' SKIP
      '           <Border ss:Position="Right"  ss:LineStyle="Continuous" ss:Weight="2"/>' SKIP
      '        </Borders>'                                                                SKIP
      '        <Protection/>'                                                             SKIP
      '     </Style>'                                                                     SKIP.

    put unformatted
      '     <Style ss:ID="m28">'                                                          SKIP
      '        <Alignment ss:Vertical="Bottom"/>'                                         SKIP
      '        <Borders>'                                                                 SKIP
      '           <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'  SKIP
      '        </Borders>'                                                                SKIP
      '        <Protection/>'                                                             SKIP
      '     </Style>'                                                                     SKIP.

    put unformatted
        '   <Style ss:ID="m25">'                                                          skip
        '      <Alignment ss:Vertical="Bottom"/>'                                         SKIP
        '      <Borders>'                                                                 skip
        '         <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '         <Border ss:Position="Left"   ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '         <Border ss:Position="Right"  ss:LineStyle="Continuous" ss:Weight="1"/>' SKIP
        '      </Borders>'                                                                SKIP
        '      <Font x:Family="Swiss" ss:Bold="1"/>'                                      SKIP
        '      <Protection/>'                                                             SKIP
        '   </Style>'                                                                     skip.

    put unformatted
      '     <Style ss:ID="m26">'                                                          SKIP
      '        <Alignment ss:Vertical="Center"/>'                                         SKIP
      '        <Borders>'                                                                 SKIP
      '           <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' skip
      '           <Border ss:Position="Left"   ss:LineStyle="Continuous" ss:Weight="1"/>' skip
      '           <Border ss:Position="Right"  ss:LineStyle="Continuous" ss:Weight="2"/>' SKIP
      '           <Border ss:Position="Top"    ss:LineStyle="Continuous" ss:Weight="1"/>' SKIP
      '        </Borders>'                                                                SKIP
      '        <Protection/>'                                                             SKIP
      '     </Style>'                                                                     SKIP.

    put unformatted
      '     <Style ss:ID="m30">'                                                          SKIP
      '        <Alignment ss:Vertical="Center"/>'                                         SKIP
      '        <Borders>'                                                                 SKIP
      '           <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' skip
      '           <Border ss:Position="Left"   ss:LineStyle="Continuous" ss:Weight="2"/>' skip
      '           <Border ss:Position="Right"  ss:LineStyle="Continuous" ss:Weight="1"/>' SKIP
      '           <Border ss:Position="Top"    ss:LineStyle="Continuous" ss:Weight="1"/>' SKIP
      '        </Borders>'                                                                SKIP
      '        <Protection/>'                                                             SKIP
      '     </Style>'                                                                     SKIP.

    put unformatted
      '     <Style ss:ID="m32">'                                                          SKIP
      '        <Alignment ss:Vertical="Center"/>'                                         SKIP
      '        <Borders>'                                                                 SKIP
      '           <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' skip
      '           <Border ss:Position="Left"   ss:LineStyle="Continuous" ss:Weight="2"/>' skip
      '           <Border ss:Position="Right"  ss:LineStyle="Continuous" ss:Weight="2"/>' SKIP
      '           <Border ss:Position="Top"    ss:LineStyle="Continuous" ss:Weight="2"/>' SKIP
      '        </Borders>'                                                                SKIP
      '        <Protection/>'                                                             SKIP
      '     </Style>'                                                                     SKIP.

    put unformatted
        '   <Style ss:ID="s21">'                                                          skip
        '      <Borders>'                                                                 skip
        '         <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>' skip
        '         <Border ss:Position="Left"   ss:LineStyle="Continuous" ss:Weight="2"/>' skip
        '         <Border ss:Position="Right"  ss:LineStyle="Continuous" ss:Weight="2"/>' skip
        '         <Border ss:Position="Top"    ss:LineStyle="Continuous" ss:Weight="2"/>' skip
        '      </Borders>'                                                                skip
        '      <Font x:Family="Swiss" ss:Bold="1"/>'                                      skip
        '      <Interior ss:Color="#FFCC00" ss:Pattern="Solid"/>'                         skip
        '      <Protection/>'                                                             SKIP
        '   </Style>'                                                                     skip.

    put unformatted
        '   <Style ss:ID="s22">'                                                         skip
        '      <Borders>'                                                                skip
        '         <Border ss:Position="Left"  ss:LineStyle="Continuous" ss:Weight="2"/>' skip
        '         <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>' skip
        '         <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'skip
        '      </Borders>'                                                               skip
        '      <Interior/>'                                                              skip
        '      <Protection/>'                                                            SKIP
        '   </Style>'                                                                    skip.

    put unformatted
        '   <Style ss:ID="s23">'                                                         skip
        '      <Borders>'                                                                skip
        '         <Border ss:Position="Left"  ss:LineStyle="Continuous" ss:Weight="2"/>' skip
        '         <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>' skip
        '         <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'skip
        '      </Borders>'                                                               skip
        '      <Interior ss:Color="#C0C0C0" ss:Pattern="Solid"/>'                        skip
        '      <Protection/>'                                                            SKIP
        '   </Style>'                                                                    skip.

    put unformatted

        '   <Style ss:ID="s24">'                                                         skip
        '      <Borders>'                                                                skip
        '         <Border ss:Position="Left"  ss:LineStyle="Continuous" ss:Weight="2"/>' skip
        '         <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>' skip
        '      </Borders>'                                                               skip
        '    <NumberFormat ss:Format="dd/mm/yy;@"/>'                                     skip
        '      <Protection/>'                                                            SKIP
        '   </Style>'                                                                    skip.

    put unformatted
        '   <Style ss:ID="s25">'                                                         skip
        '      <Borders>'                                                                skip
        '         <Border ss:Position="Left"  ss:LineStyle="Continuous" ss:Weight="2"/>' skip
        '         <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>' skip
        '         <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'skip
        '      </Borders>'                                                               skip
        '      <Interior ss:Color="#C0C0C0" ss:Pattern="Solid"/>'                        skip
        '      <Protection/>'                                                            SKIP
        '   </Style>'                                                                    skip.

    put unformatted
        '   <Style ss:ID="s26">'                                                         skip 
        '      <Borders>'                                                                skip
        '         <Border ss:Position="Left"  ss:LineStyle="Continuous" ss:Weight="2"/>' skip
        '         <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>' skip
        '      </Borders>'                                                               skip
        '      <NumberFormat ss:Format="0.0000"/>'                                       skip 
        '      <Protection/>'                                                            SKIP
        '   </Style>'                                                                    skip.
                                                                                         
    put unformatted                                                                      
        '   <Style ss:ID="s27">'                                                         skip
        '      <Borders>'                                                                skip
        '         <Border ss:Position="Left"  ss:LineStyle="Continuous" ss:Weight="2"/>' skip
        '         <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>' skip
        '      </Borders>'                                                               skip
        '      <Interior ss:Color="#C0C0C0" ss:Pattern="Solid"/>'                        skip 
        '      <NumberFormat ss:Format="0.0000"/>'                                       skip 
        '      <Protection/>'                                                            SKIP
        '   </Style>'                                                                    skip.
                                                                                         
    put unformatted                                                                      
        '   <Style ss:ID="s28">'                                                         skip 
        '      <Borders>'                                                                skip
        '         <Border ss:Position="Left"  ss:LineStyle="Continuous" ss:Weight="2"/>' skip
        '         <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>' skip
        '      </Borders>'                                                               skip
        '      <NumberFormat ss:Format="0.00"/>'                                         skip 
        '      <Protection/>'                                                            SKIP
        '   </Style>'                                                                    skip.
                                                                                         
    put unformatted                                                                      
        '   <Style ss:ID="s29">'                                                         skip
        '      <Borders>'                                                                skip
        '         <Border ss:Position="Left"  ss:LineStyle="Continuous" ss:Weight="2"/>' skip
        '         <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>' skip
        '      </Borders>'                                                               skip
        '      <Interior ss:Color="#C0C0C0" ss:Pattern="Solid"/>'                        skip 
        '      <NumberFormat ss:Format="0.00"/>'                                         skip 
        '      <Protection/>'                                                            SKIP
        '   </Style>'                                                                    skip.

    put unformatted                                                                      
        '   <Style ss:ID="s30">'                                                          skip 
        '      <Borders>'                                                                 skip
        '         <Border ss:Position="Top"    ss:LineStyle="Continuous" ss:Weight="2"/>' skip
        '      </Borders>'                                                                skip
        '      <Protection/>'                                                             SKIP
        '   </Style>'                                                                     skip.

    put unformatted                                                                      
        '   <Style ss:ID="m35">'                                                          skip 
        '      <Borders>'                                                                 skip
        '         <Border ss:Position="Right"  ss:LineStyle="Continuous" ss:Weight="2"/>' skip
        '      </Borders>'                                                                skip
        '      <Protection/>'                                                             SKIP
        '   </Style>'                                                                     skip.

end procedure. /* procedure OpenStyles: */
            
procedure CloseStyles:

    put unformatted
        '</Styles>' skip.
end procedure. /* procedure CloseStyles: */

procedure OpenWorkSheet:
    
    def input param c-program-name as char no-undo.

    put unformatted
        '<Worksheet ss:Name="' c-program-name '" ss:Protected="1">' skip. 

end procedure. /* procedure OpenWorkSheet: */

procedure CloseWorkSheet:

    put unformatted
        '</Worksheet>' skip.

end procedure. /* procedure CloseWorkSheet: */

procedure OpenWorksheetOptions:
    put unformatted
        '<WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel" ss:Protected="1">'   SKIP  
        '   <PageSetup>'                                                                       SKIP  
        '      <Header x:Margin="0.4" x:Data="&amp;LCabecalho"/>'                              SKIP  
        '      <Footer x:Margin="0.4"/>'                                                       SKIP  
        '      <PageMargins x:Bottom="0.984251969" x:Left="0.78740157499999996"'               SKIP  
        '                   x:Right="0.78740157499999996" x:Top="0.984251969"/>'               SKIP   
        '   </PageSetup>'                                                                      SKIP
        '   <Print>     '                                                                      SKIP     
        '      <Scale>75</Scale>'                                                              SKIP
        '   </Print>'                                                                          SKIP
        ' <PageBreakZoom>100</PageBreakZoom>'                                                  SKIP
        ' <ProtectObjects>True</ProtectObjects>'                                               SKIP
        ' <ProtectScenarios>True</ProtectScenarios>'                                           SKIP
        ' <EnableSelection>UnlockedCells</EnableSelection>'                                    SKIP
        ' <Selected/>'                                                                         SKIP
        ' <FreezePanes/>'                                                                      SKIP
        ' <FrozenNoSplit/>'                                                                    SKIP
        ' <Panes>'                                                                             SKIP
        '  <Pane>'                                                                             SKIP
        '   <Number>3</Number>'                                                                SKIP
        '  </Pane>'                                                                            SKIP
        '  <Pane>'                                                                             SKIP
        '   <Number>2</Number>'                                                                SKIP
        '  </Pane>'                                                                            SKIP
        ' </Panes>'                                                                            SKIP.

end procedure. /* procedure OpenWorksheetOptions: */

procedure CloseWorksheetOptions:

    put unformatted
        '</WorksheetOptions>' skip.

end procedure. /* procedure CloseWorksheetOptions: */
	
procedure OpenTable:

    def input param pColumns as int no-undo.

    put unformatted
        '   <Table ss:ExpandedColumnCount="' pColumns '" ss:ExpandedRowCount="65500" x:FullColumns="1" x:FullRows="1">' skip.

end procedure. /* procedure OpenTable: */

procedure CloseTable:

    put unformatted
        '   </Table>' skip.

end procedure. /* procedure CloseTable: */

procedure setColumnWidth:

    def input param cWidth as char no-undo.

    put unformatted
        '       <Column ss:AutoFitWidth="0" ss:Width="' trim(cWidth) '"/>' skip.

end procedure. /* procedure setColumnWidth: */

procedure OpenLine:

    assign iLineCount = iLineCount + 1.

    put unformatted
        '      <Row ss:Index="' iLineCount '">' skip.

end procedure. /* procedure OpenLine: */
	
procedure CloseLine:

    /* reinicia a contagem das colunas sempre que a TAG da linha ‚ fechada */
    assign iColCount = 0.

    put unformatted
        '      </Row>' skip.

end procedure. /* procedure CloseLine: */
	
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

end procedure. /* procedure PrintDataString: */
	
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

end procedure. /* procedure PrintDataNumber: */

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

end procedure. /* procedure PrintDataDate: */


procedure MergeColumns:

    def input param iNumberCols as int  no-undo. /* n£mero de c‚lulas da coluna a serem mescladas a partir da c‚lula corrente */
    def input param cData       as char no-undo.
    def input param cStyle      as char no-undo.

    

    assign iColCount = iColCount + 1. /* pr¢xima c‚lula da coluna */

    put unformatted
        '         <Cell ss:Index="' iColCount '" ss:MergeAcross="' iNumberCols '" ss:StyleID="' cStyle '"><Data ss:Type="String">' cData '</Data></Cell>' skip.

    /* ap¢s mesclar as c‚lulas atualiza a coluna corrente, retirando a c‚lula (coluna) acrescenta acima */
    assign iColCount = iColCount + iNumberCols - 1.

end procedure. /* procedure MergeColumns: */
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

end function. /* function fnSkipCol */

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

end function. /* function fnSkipSheet */

function fnSkipLine returns char (input pNumberLinesToSkip as int).
    
    def var iLine as int no-undo.

    do iLine = 1 to pNumberLinesToSkip:
        assign iLineCount = iLineCount + 1.
    end.

    return "OK".

end function. /* function fnSkipLine */

procedure piConvertXMLToXLS:

    /*=================================
      ConversÆo do anomeArquivo XML para XLS
      =================================*/

    def var v-anomeArquivo as char       no-undo.
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

        /* elimina anomeArquivo XML */
        os-delete value(nomeArquivo).
    end.
    else do:

        {office/office.i Excel ch-excel}
        assign file-info:file-name = nomeArquivo. 
        
        /* elimina anomeArquivo XLS */
        IF ch-Excel:VERSION < "12" THEN
            assign v-anomeArquivo = replace(nomeArquivo, ".xml", ".xls").
        ELSE
            assign v-anomeArquivo = replace(nomeArquivo, ".xml", ".xlsx").
            
        os-delete value(v-anomeArquivo).

        ch-excel:WorkBooks:open(file-info:file-name,true). 
        ch-excel:sheets:item(1).

        assign file-info:file-name = v-anomeArquivo.

        /* ConversÆo do anomeArquivo .XML para .XLS */
        /* -4143: constante de conversÆo de anomeArquivo .XML para .XLS */
        
        IF cOffice = "msoffice" THEN
            ch-Excel:ActiveWorkbook:SaveAs(file-info:file-name,IF ch-Excel:VERSION < "12" THEN -4143 ELSE 51,"", "", False, False, False). 
        ELSE  /*Se for Libre Office = libreoffice*/
            ch-Excel:ActiveWorkbook:SaveAs(file-info:file-name,56,"","",FALSE,FALSE,3,1,TRUE,?) NO-ERROR.
            
        ch-excel:ActiveWorkbook:close().
        
        ch-excel:Workbooks:open(v-anomeArquivo).
        ch-excel:visible = yes.

        DELETE object ch-excel.

        /* elimina anomeArquivo XML */
        os-delete value(nomeArquivo).
    end.
   
end procedure. /* procedure piConvertXMLToXLS: */

/*Procedure responsÿvel por buscar a cota»’o certa e fazer a convers’o das moedas.*/
PROCEDURE buscaCotacao:
   DEF INPUT  PARAM p-num-di-ems          LIKE decla-import.num-di-ems        NO-UNDO.
   DEF INPUT  PARAM p-cdd-siscomex-dts    LIKE decla-import.cdd-siscomex-dts  NO-UNDO.
   DEF INPUT  PARAM p-cdn-moeda           LIKE despes-decla-import.cdn-moeda  NO-UNDO.
   DEF INPUT  PARAM p-data-cotacao        LIKE decla-import.dat-di            NO-UNDO.
   DEF OUTPUT PARAM p-cotacao             LIKE despes-decla-import.val-despes NO-UNDO.
   
   /*calculo do valor*/
    /*se o cod. da moeda for diferente de 0, significa que ‚ uma moeda estrangeira. 
     * Ou seja, o campo Valor ME recebe o valor da despesa (tt-despes-decla-import.val-despes) e o campo Valor MN precisa ser calculado.
     * Calculo do Valor MN =  Valor ME * cotacao–.
     * –: o valor da cotacao deve ser buscado do im0400c
     *      se n’o achar pega do cd0103
     *      se n’o achar, atribui o valor da cotacao = 1.
    */
    IF p-cdn-moeda <> 0 THEN DO:
        /** FUN°€O QUE BUSCA COTA°€O (cxbo395.p - fnContacao **/
        IF NOT CAN-FIND(FIRST decla-import-cotac
                        WHERE decla-import-cotac.num-di-ems       = p-num-di-ems
                        AND   decla-import-cotac.cdd-siscomex-dts = p-cdd-siscomex-dts
                        AND   decla-import-cotac.cdn-moed         = p-cdn-moeda
                        AND   decla-import-cotac.val-cotac       <> 0) THEN DO:
            FIND cotacao
                WHERE cotacao.mo-codigo   = p-cdn-moeda
                AND   cotacao.ano-periodo = STRING(YEAR(p-data-cotacao)) 
                                          + STRING(MONTH(p-data-cotacao),"99")
                AND cotacao.cotacao[INT(DAY(p-data-cotacao))] <> 0 NO-LOCK NO-ERROR.
            IF  NOT AVAIL cotacao THEN DO:
                IF  p-cdn-moeda <> 0 THEN DO:
                    ASSIGN p-cotacao = 0.
                END.
                ELSE
                    ASSIGN p-cotacao = 1.
            END.
            ELSE
                ASSIGN p-cotacao = cotacao.cotacao[INT(DAY(p-data-cotacao))].
        END.
        ELSE DO:
            FOR FIRST decla-import-cotac NO-LOCK
                WHERE decla-import-cotac.num-di-ems       = p-num-di-ems
                AND   decla-import-cotac.cdd-siscomex-dts = p-cdd-siscomex-dts
                AND   decla-import-cotac.cdn-moed         = p-cdn-moeda:
                ASSIGN p-cotacao = decla-import-cotac.val-cotac.
            END.
        END.
        /* FIM FUN°€O QUE BUSCA COTA°€O*/
    END.
    ELSE DO:
        ASSIGN p-cotacao = 0.
    END.
    /*fim calculo do valor*/

    RETURN "OK":U.

END PROCEDURE. /* PROCEDURE buscaCotacao: */
/*FIM Procedure responsÿvel por buscar a cota»’o certa e fazer a convers’o das moedas.*/


