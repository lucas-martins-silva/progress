/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN082I 2.00.00.039 } /*** "010039" 20/08/2026 16:06:09 ***/

&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i boin082i MUT}
&ENDIF


/*--------------------------------------------------------------------------
    File       :
    Purpose    : O DBO (Datasul Business Objects) ‚ um programa PROGRESS
                 que cont‚m a l¢gica de neg¢cio e acesso a dados para uma
                 tabela do banco de dados.

    Parameters :

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName BOIN082I
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName cotacao-item
&GLOBAL-DEFINE TableLabel
&GLOBAL-DEFINE QueryName qr{&TableName}

/*********************************************************************************
**  S¢ a DBO principal (boin082.p) est  com as fun‡äes de inclui (createRecord),
**  modifica (updateRecord) e elimina (deleteRecord) habilitadas,
**  porque Sà nela foram implementadas as triggers do dicion rio.
**  Para desabilitar as procedures foram usados os pr‚-processadores abaixo.
**  A procedure validateRecord dessa DBO nÆo deve ser usada.
*********************************************************************************/
&GLOBAL-DEFINE EXCLUDE-createRecord 0
&GLOBAL-DEFINE EXCLUDE-updateRecord 0
&GLOBAL-DEFINE EXCLUDE-deleteRecord 0

&IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
   &GLOBAL-DEFINE v9indrep  INDEXED-REPOSITION
&endif

/*--- Include com defini‡Æo da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com
      extensÆo .i ---*/
{inbo/boin082.i RowObject}
{include/i-epc200.i boin082i}

/*--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo
      manual da query ---*/
/*{method/dboqry.i}*/

DEFINE QUERY {&QUERYNAME} for {&TABLENAME},
    emitente fields(cod-emitente natureza) scrolling.

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName}  FOR {&TableName}.
DEFINE BUFFER bfOrdem-compra  FOR ordem-compra.
DEFINE BUFFER bfCotacao-item1 FOR cotacao-item.

/* Includes */
{include/boerrtab.i}              /* Defini‡Æo temp-table tt-bo-erro            */
{cdp/cdcfgmat.i}                  /* Include preprocessadores                   */
{inbo/boin082.i  tt-cotacao-item} /* Defini‡Æo temp-table auxiliar              */
{inbo/boin082i.i tt-cotacao-imp}  /* Defini‡Æo temp-table auxiliar (importa‡Æo) */
{cxbo/bocx085.i tt-cotacao-item-cex}
&if "{&bf_mat_versao_ems}":U >= "2.062":U &then
{imp/imapi006.i} /* tt-desp-ja-recalc */
&endif

{cdp/cd4300.i3} /* Tratamento Atributos Livres */


def var hDBOCotacao-item-cex   as handle  no-undo.
def var hDBOCotacao-item-cexna as handle  no-undo.
def var hDBOCotacao-itemvl     as handle  no-undo.
def var hDBOOrdem-compra       as handle  no-undo.
def var hDBOOrdem-compravl     as handle  no-undo.
def var hDBOOrdens-embarque    as handle  no-undo.
DEF VAR h-bocx085              AS HANDLE  NO-UNDO.

def var l-preco-bruto        as logical no-undo.
def var r-cotacao-item       as rowid   no-undo.
def var c-usuario            as char    no-undo.

def var i-numero-ordem-ini   like ordem-compra.numero-ordem no-undo.
def var i-numero-ordem-fim   like ordem-compra.numero-ordem no-undo.
def var i-cod-emitente-ini   like emitente.cod-emitente     no-undo.
def var i-cod-emitente-fim   like emitente.cod-emitente     no-undo.
def var c-it-codigo-ini      like item.it-codigo            no-undo.
def var c-it-codigo-fim      like item.it-codigo            no-undo.
DEF VAR c-cod-estab          LIKE pedido-compr.cod-estabel  NO-UNDO.

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
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB)
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 21.21
         WIDTH              = 38.72.
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


FIND FIRST param-global NO-LOCK NO-ERROR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculateII_IPI DBOProgram
PROCEDURE calculateII_IPI :
/*------------------------------------------------------------------------------
  Purpose: Retorna a aliquota do Imposto de Importacao e IPI 206B
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    &if "{&bf_mat_versao_ems}":U >= "2.062":U &then
    define input  parameter c-it-codigo      as character format "x(16)":U     no-undo.
    define input  parameter i-numero-ordem   as integer   format "zzzzz9,99":U no-undo.
    define input  parameter de-aliq-ipi-ant  as decimal   format ">>9.99":U    no-undo. /* cotacao-item.aliquota-ipi */
    define input  parameter c-class-fiscal   as character format "x(8)":U      no-undo.
    define input  parameter i-cdn-pais-orig  as integer   format ">>,>>9":U    no-undo.
    define input  parameter i-regime-import  as integer   format ">9":U        no-undo.
    define output parameter de-aliq-ii       as decimal   format ">>9.9999":U  no-undo.
    define output parameter de-aliq-ipi      as decimal   format ">>9.99":U    no-undo.

    for first item fields (char-2 aliquota-ipi tipo-contr)
        where item.it-codigo = c-it-codigo no-lock: end.
    if  not avail item then
        return "NOK":U.

    IF c-cod-estab = "" THEN DO:
        for first ordem-compra fields (cod-estabel)
            where ordem-compra.numero-ordem = i-numero-ordem no-lock: end.
        if  not avail ordem-compra then
            return "NOK":U.
        ELSE
            ASSIGN c-cod-estab = ordem-compra.cod-estabel.

    END.

    for first param-imp fields (log-cotac-autom-ipi)
        where param-imp.cod-estabel = c-cod-estab no-lock: end.
    if  not avail param-imp then
        return "NOK":U.

    for first pais-aliquota fields (log-impto-import-especial aliquota-ii aliquota-ipi cod-natur-operac-ipi
                                    val-perc-reduc-impto-import log-ipi-especial)
        where pais-aliquota.cod-pais      = i-cdn-pais-orig
        and   pais-aliquota.regime-import = i-regime-import
        and   pais-aliquota.class-fiscal  = c-class-fiscal no-lock: end.
    if  not avail pais-aliquota then do:

        /* II */
        assign de-aliq-ii = if substr(item.char-2,278,8) = "" then dec(substr(item.char-2,22,6))
                                                              else dec(substr(item.char-2,278,8)).

        /* IPI */
        if  not param-imp.log-cotac-autom-ipi then
            assign de-aliq-ipi = de-aliq-ipi-ant.
        else
            assign de-aliq-ipi = 0.

        return "OK":U.
    end.

    /* II */
    if  pais-aliquota.log-impto-import-especial then do:

        if  pais-aliquota.val-perc-reduc-impto-import > 0
        and pais-aliquota.aliquota-ii = 0 then
            /* Aliquota Reduzida */
            if substr(item.char-2,278,8) = "" then
                assign de-aliq-ii = dec(substr(item.char-2,22,6)) -
                                   (dec(substr(item.char-2,22,6)) * (pais-aliquota.val-perc-reduc-impto-import / 100)).
            else
                assign de-aliq-ii = dec(substr(item.char-2,278,8)) -
                                   (dec(substr(item.char-2,278,8)) * (pais-aliquota.val-perc-reduc-impto-import / 100)).
        else
            assign de-aliq-ii = pais-aliquota.aliquota-ii.
    end.
    else
        assign de-aliq-ii = if substr(item.char-2,278,8) = "" then dec(substr(item.char-2,22,6))
                                                              else dec(substr(item.char-2,278,8)).

    /* IPI */
    IF  NOT param-imp.log-cotac-autom-ipi THEN DO:
        IF  pais-aliquota.log-ipi-especial THEN DO:
            IF  pais-aliquota.cod-natur-operac-ipi <> "" AND
                pais-aliquota.aliquota-ipi          = 0  THEN DO:

                /* Item Debito Direto? */
                IF  item.tipo-contr = 4 THEN DO:
                    FOR FIRST  classif-fisc
                        FIELDS (aliquota-ipi)
                        WHERE  classif-fisc.class-fiscal = c-class-fiscal NO-LOCK:
                        ASSIGN de-aliq-ipi = classif-fisc.aliquota-ipi.
                    END.
                END.
                ELSE
                    ASSIGN de-aliq-ipi = item.aliquota-ipi.
            END.
            ELSE
                ASSIGN de-aliq-ipi = pais-aliquota.aliquota-ipi. /* aliquota IPI - CD2578 */
        END.
        ELSE
            ASSIGN de-aliq-ipi = de-aliq-ipi-ant.
    END.
    ELSE
        ASSIGN de-aliq-ipi = 0.

    &ENDIF

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraAliquota DBOProgram
PROCEDURE geraAliquota :
/*------------------------------------------------------------------------------
  Purpose: Retorna a al¡quota do Imposto de Importa‡Æo e IPI
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    def input  parameter p-numero-ordem   like ordem-compra.numero-ordem   no-undo.
    def input  parameter p-it-codigo      like item.it-codigo              no-undo.
    def input  parameter p-cod-fabricante like emitente.cod-emitente       no-undo.
    def input  parameter p-regime-import  like pais-aliquota.regime-import no-undo.
    def input  parameter p-class-fiscal   like classif-fisc.class-fiscal   no-undo.
    def output parameter p-de-aliq-ii     as   decimal format ">>9.9999"   no-undo.
    def output parameter p-de-aliq-ipi    as   decimal format ">>9.99"     no-undo.
    def output parameter p-regime         as   logical initial no          no-undo.
    def output parameter table for tt-bo-erro.




    FOR EACH TT-BO-ERRO:
        DELETE TT-BO-ERRO.
    END.

    run imp/im9036.p (input p-numero-ordem,
                      input p-it-codigo,
                      input p-cod-fabricante,
                      input p-regime-import,
                      input p-class-fiscal,
                      output p-de-aliq-ii,
                      output p-de-aliq-ipi,
                      output p-regime,
                      output table tt-bo-erro).

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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon¡vel, caso nÆo esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "motivo-apr":U THEN ASSIGN pFieldValue = RowObject.motivo-apr.
        WHEN "narrativa":U THEN ASSIGN pFieldValue = RowObject.narrativa.
        WHEN "nr-tab":U THEN ASSIGN pFieldValue = RowObject.nr-tab.
        WHEN "un":U THEN ASSIGN pFieldValue = RowObject.un.
        WHEN "usuario":U THEN ASSIGN pFieldValue = RowObject.usuario.
        WHEN "aprovador":U THEN ASSIGN pFieldValue = RowObject.aprovador.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-comprado":U THEN ASSIGN pFieldValue = RowObject.cod-comprado.
        WHEN "contato":U THEN ASSIGN pFieldValue = RowObject.contato.
        WHEN "hora-atualiz":U THEN ASSIGN pFieldValue = RowObject.hora-atualiz.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon¡vel, caso nÆo esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "data-atualiz":U THEN ASSIGN pFieldValue = RowObject.data-atualiz.
        WHEN "data-cotacao":U THEN ASSIGN pFieldValue = RowObject.data-cotacao.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon¡vel, caso nÆo esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "perc-descto":U THEN ASSIGN pFieldValue = RowObject.perc-descto.
        WHEN "pre-unit-for":U THEN ASSIGN pFieldValue = RowObject.pre-unit-for.
        WHEN "preco-fornec":U THEN ASSIGN pFieldValue = RowObject.preco-fornec.
        WHEN "preco-unit":U THEN ASSIGN pFieldValue = RowObject.preco-unit.
        WHEN "valor-descto":U THEN ASSIGN pFieldValue = RowObject.valor-descto.
        WHEN "valor-frete":U THEN ASSIGN pFieldValue = RowObject.valor-frete.
        WHEN "valor-taxa":U THEN ASSIGN pFieldValue = RowObject.valor-taxa.
        WHEN "aliquota-icm":U THEN ASSIGN pFieldValue = RowObject.aliquota-icm.
        WHEN "aliquota-ipi":U THEN ASSIGN pFieldValue = RowObject.aliquota-ipi.
        WHEN "aliquota-iss":U THEN ASSIGN pFieldValue = RowObject.aliquota-iss.
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "ind-reajuste":U THEN ASSIGN pFieldValue = RowObject.ind-reajuste.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon¡vel, caso nÆo esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "mo-codigo":U THEN ASSIGN pFieldValue = RowObject.mo-codigo.
        WHEN "nr-dias-taxa":U THEN ASSIGN pFieldValue = RowObject.nr-dias-taxa.
        WHEN "num-proc-entr-edi":U THEN ASSIGN pFieldValue = RowObject.num-proc-entr-edi.
        WHEN "num-proc-envio-edi":U THEN ASSIGN pFieldValue = RowObject.num-proc-envio-edi.
        WHEN "numero-ordem":U THEN ASSIGN pFieldValue = RowObject.numero-ordem.
        WHEN "prazo-entreg":U THEN ASSIGN pFieldValue = RowObject.prazo-entreg.
        WHEN "seq-cotac":U THEN ASSIGN pFieldValue = RowObject.seq-cotac.
        WHEN "cod-cond-pag":U THEN ASSIGN pFieldValue = RowObject.cod-cond-pag.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "cod-transp":U THEN ASSIGN pFieldValue = RowObject.cod-transp.
        WHEN "codigo-icm":U THEN ASSIGN pFieldValue = RowObject.codigo-icm.
        WHEN "dias-validade":U THEN ASSIGN pFieldValue = RowObject.dias-validade.
        WHEN "ind-via-envio":U THEN ASSIGN pFieldValue = RowObject.ind-via-envio.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "ind-orig-entrada":U THEN ASSIGN pFieldValue = RowObject.ind-orig-entrada.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice COTACAO
  Parameters:
               retorna valor dos campos do ¡ndice COTACAO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnumero-ordem LIKE cotacao-item.numero-ordem NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE cotacao-item.cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pit-codigo LIKE cotacao-item.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pseq-cotac LIKE cotacao-item.seq-cotac NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon¡vel, caso nÆo esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pnumero-ordem = RowObject.numero-ordem.
    ASSIGN pcod-emitente = RowObject.cod-emitente.
    ASSIGN pit-codigo = RowObject.it-codigo.
    ASSIGN pseq-cotac = RowObject.seq-cotac.

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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon¡vel, caso nÆo esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "possui-reaj":U THEN ASSIGN pFieldValue = RowObject.possui-reaj.
        WHEN "reaj-tabela":U THEN ASSIGN pFieldValue = RowObject.reaj-tabela.
        WHEN "reajusta-cotacao":U THEN ASSIGN pFieldValue = RowObject.reajusta-cotacao.
        WHEN "taxa-financ":U THEN ASSIGN pFieldValue = RowObject.taxa-financ.
        WHEN "codigo-ipi":U THEN ASSIGN pFieldValue = RowObject.codigo-ipi.
        WHEN "cot-aprovada":U THEN ASSIGN pFieldValue = RowObject.cot-aprovada.
        WHEN "frete":U THEN ASSIGN pFieldValue = RowObject.frete.
        WHEN "ind-ret-cotacao":U THEN ASSIGN pFieldValue = RowObject.ind-ret-cotacao.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RAW NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon¡vel, caso nÆo esteja serÿ
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTT-cotacao-item DBOProgram
PROCEDURE getTT-cotacao-item :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    def output parameter table for tt-cotacao-item.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ¡ndice COTACAO
  Parameters:
               recebe valor dos campos do ¡ndice COTACAO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnumero-ordem LIKE cotacao-item.numero-ordem NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente LIKE cotacao-item.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo LIKE cotacao-item.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pseq-cotac LIKE cotacao-item.seq-cotac NO-UNDO.

    FIND FIRST bfcotacao-item WHERE
        bfcotacao-item.numero-ordem = pnumero-ordem AND
        bfcotacao-item.cod-emitente = pcod-emitente AND
        bfcotacao-item.it-codigo = pit-codigo AND
        bfcotacao-item.seq-cotac = pseq-cotac
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfcotacao-item THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros serÿ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfcotacao-item)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCreate DBOProgram
PROCEDURE openQueryCreate :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    def output parameter table for rowObject.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose: Busca conjunto de registros da tabela cotacao-item de acordo com a
           situa‡Æo da ordem-compra relacionada dentro de uma faixa de data de
           cota‡Æo, numero da ordem e de c¢digo do emitente, junto com os
           parƒmetros indicadores cota‡Æo aprovada e ordem pendente ou normal .
           Os registros sÆo ordenados pelo c¢digo do emitente.

  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    OPEN QUERY {&QUERYNAME} for each {&TableName} NO-LOCK,
                                FIRST emitente WHERE
                                      emitente.cod-emitente = {&TableName}.cod-emitente AND
                                      (emitente.natureza = 3 or emitente.natureza = 4) NO-LOCK
                                      use-index codigo {&v9indrep}.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOrdemEmitItem DBOProgram
PROCEDURE openQueryOrdemEmitItem :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    OPEN QUERY {&QUERYNAME} for each {&TableName} NO-LOCK
                                WHERE {&TableName}.numero-ordem >= i-numero-ordem-ini
                                  AND {&TableName}.numero-ordem <= i-numero-ordem-fim
                                  AND {&TableName}.cod-emitente >= i-cod-emitente-ini
                                  AND {&TableName}.cod-emitente <= i-cod-emitente-fim
                                  AND {&tablename}.it-codigo    >= c-it-codigo-ini
                                  AND {&tablename}.it-codigo    <= c-it-codigo-fim,
                                FIRST emitente
                                    WHERE emitente.cod-emitente = {&TableName}.cod-emitente
                                      AND (emitente.natureza = 3 or emitente.natureza = 4) NO-LOCK.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryRowid DBOProgram
PROCEDURE openQueryRowid :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    OPEN QUERY {&QUERYNAME} for each {&TableName} NO-LOCK
                                WHERE ROWID({&TableName}) = r-cotacao-item,
                                FIRST emitente
                                    WHERE emitente.cod-emitente = {&TableName}.cod-emitente
                                      AND (emitente.natureza = 3 or emitente.natureza = 4) NO-LOCK.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRetiraIpi DBOProgram
PROCEDURE piRetiraIpi :
/*------------------------------------------------------------------------------
  Purpose: Validar a vinculacao de uma ordem de compra a um pedido de compra
  Entrada: 1 - p-numero-ordem - n£mero da ordem de compra;
           2 - i-identifica   - setar  qual informa‡Æo dever  ser retirado o IPI:
               1 - Valor Total Ordem Compra;
               2 - Valor Unit rio Ordem Compra;
               3 - Valor Unit rio da Cota‡Æo.

  Sa¡da:   1 - de-preco
           2 - de-preco-forn
  Notes:
------------------------------------------------------------------------------*/
    DEF INPUT  PARAMETER i-numero-ordem  LIKE ordem-compra.numero-ordem    NO-UNDO.
    DEF INPUT  PARAMETER i-identifica    AS   INTEGER FORMAT "9"           NO-UNDO.
    DEF OUTPUT PARAMETER de-preco        LIKE ordem-compra.preco-unit      no-undo.
    DEF OUTPUT PARAMETER de-preco-forn   LIKE ordem-compra.pre-unit-for    no-undo.

    DEF VAR de-quant                     LIKE prazo-compra.quantidade      NO-UNDO.
    DEF VAR de-quant-forn                LIKE prazo-compra.qtd-do-forn     NO-UNDO.
    DEF VAR de-preco-unit                LIKE ordem-compra.preco-unit      NO-UNDO.
    DEF VAR de-preco-unit-forn           LIKE ordem-compra.pre-unit-for    NO-UNDO.

    ASSIGN de-quant           = 0
           de-quant-forn      = 0
           de-preco-unit      = 0
           de-preco-unit-forn = 0
           de-preco           = 0
           de-preco-forn      = 0.

    FOR FIRST ordem-compra FIELDS (numero-ordem cod-emitente it-codigo preco-unit pre-unit-for)
           WHERE ordem-compra.numero-ordem = i-numero-ordem NO-LOCK:
    END.
    IF NOT AVAIL ordem-compra THEN
       RETURN "OK":U.

    FOR FIRST cotacao-item FIELDS (numero-ordem cod-emitente it-codigo cot-aprovada aliquota-ipi preco-unit
                                   pre-unit-for)
        WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
          AND cotacao-item.cod-emitente = ordem-compra.cod-emitente
          AND cotacao-item.it-codigo    = ordem-compra.it-codigo
          AND cotacao-item.cot-aprovada = YES NO-LOCK:
    END.
    IF NOT AVAIL cotacao-item THEN
       RETURN "OK":U.

    IF i-identifica = 1 THEN DO:
       FOR each prazo-compra FIELDS (numero-ordem situacao quantidade qtd-do-forn)
          WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem
            AND prazo-compra.situacao <> 4 NO-LOCK:
           ASSIGN de-quant = de-quant + prazo-compra.quantidade
                  de-quant-forn = de-quant-forn + prazo-compra.qtd-do-forn.
       END.

       ASSIGN de-preco-unit      = (ordem-compra.preco-unit * 100) / (100 + cotacao-item.aliquota-ipi)
              de-preco-unit-forn = (ordem-compra.pre-unit-for * 100) / (100 + cotacao-item.aliquota-ipi).

       ASSIGN de-preco      = de-preco-unit * de-quant
              de-preco-forn = de-preco-unit-forn * de-quant-forn.
    END.

    IF i-identifica = 2 THEN DO:
       ASSIGN de-preco      = (ordem-compra.preco-unit * 100) / (100 + cotacao-item.aliquota-ipi)
              de-preco-forn = (ordem-compra.pre-unit-for * 100) / (100 + cotacao-item.aliquota-ipi).
    END.

    IF i-identifica = 3 THEN DO:
       ASSIGN de-preco      = (cotacao-item.preco-unit * 100) / (100 + cotacao-item.aliquota-ipi)
              de-preco-forn = (cotacao-item.pre-unit-for * 100) / (100 + cotacao-item.aliquota-ipi).
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCreate DBOProgram
PROCEDURE setConstraintCreate :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    def input parameter p-numero-ordem like ordem-compra.numero-ordem no-undo.
    def input parameter p-cod-emitente like cotacao-item.cod-emitente no-undo.
    def input parameter p-it-codigo    like cotacao-item.it-codigo    no-undo.
    def input parameter p-seq-cotac    like cotacao-item.seq-cotac    no-undo.

    create rowObject.
    assign rowObject.numero-ordem = p-numero-ordem
           rowObject.cod-emitente = p-cod-emitente
           rowObject.it-codigo    = p-it-codigo
           rowObject.seq-cotac    = p-seq-cotac.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintMain DBOProgram
PROCEDURE setConstraintMain :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:
  Notes:
------------------------------------------------------------------------------*/

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintOrdemEmitItem DBOProgram
PROCEDURE setConstraintOrdemEmitItem :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    def input parameter p-numero-ordem-ini like ordem-compra.numero-ordem no-undo.
    def input parameter p-numero-ordem-fim like ordem-compra.numero-ordem no-undo.
    def input parameter p-cod-emitente-ini like emitente.cod-emitente     no-undo.
    def input parameter p-cod-emitente-fim like emitente.cod-emitente     no-undo.
    def input parameter p-it-codigo-ini    like item.it-codigo            no-undo.
    def input parameter p-it-codigo-fim    like item.it-codigo            no-undo.

    assign i-numero-ordem-ini = p-numero-ordem-ini
           i-numero-ordem-fim = p-numero-ordem-fim
           i-cod-emitente-ini = p-cod-emitente-ini
           i-cod-emitente-fim = p-cod-emitente-fim
           c-it-codigo-ini    = p-it-codigo-ini
           c-it-codigo-fim    = p-it-codigo-fim.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCodEstabel DBOProgram
PROCEDURE setConstraintCodEstabel :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    def input parameter cCodEstabel LIKE pedido-compr.cod-estabel no-undo.

    assign c-cod-estab = cCodEstabel.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintRowid DBOProgram
PROCEDURE setConstraintRowid :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    def input parameter p-cotacao-item as rowid no-undo.

    assign r-cotacao-item = p-cotacao-item.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintRowid DBOProgram
PROCEDURE setDefaultsHIS :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    def input  parameter p-cotacao-item as rowid no-undo.
    DEF OUTPUT parameter i-cod-emitente as integer   format ">>>>>>>>9":U no-undo.

    DEF VAR i-cdn-fab-medic AS INT NO-UNDO.

    ASSIGN i-cod-emitente = 0.

    FIND FIRST cotacao-item WHERE ROWID(cotacao-item) = p-cotacao-item NO-LOCK NO-ERROR.
    IF AVAIL cotacao-item THEN DO:

        IF CAN-FIND (FIRST funcao
                  WHERE funcao.cd-funcao = "spp-integra-ems-his"
                    AND funcao.ativo = YES) THEN DO:

            &IF "{&bf_mat_versao_ems}" >= "2.09" &THEN
                ASSIGN i-cdn-fab-medic = cotacao-item.cdn-fab-medic.
            &ELSE
                ASSIGN i-cdn-fab-medic = int(SUBSTR(cotacao-item.char-1,127,9)).
            &ENDIF

            &if "{&bf_mat_versao_ems}":U >= "2.062":U &then
                FIND FIRST fab-medic WHERE fab-medic.cdn-fabrican = i-cdn-fab-medic NO-LOCK NO-ERROR.
                IF AVAIL fab-medic THEN
                    ASSIGN i-cod-emitente = fab-medic.cdn-emitente.
            &endif

        END.

    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDefaultsIm0060 DBOProgram
PROCEDURE setDefaultsIm0060 :
/*------------------------------------------------------------------------------
  Purpose:     Sugerir valor de campos do im0060 - 2.06B
  Parameters:
  Notes:
------------------------------------------------------------------------------*/
    &if "{&bf_mat_versao_ems}":U >= "2.062":U &then
    define input  parameter c-it-codigo      as character format "x(16)":U     no-undo.
    define input  parameter i-cod-emitente   as integer   format ">>>>>>>>9":U no-undo.
    define input  parameter c-class-fiscal   as character format "x(8)":U      no-undo.
    define output parameter i-cdn-fabrican   as integer   format ">>>>>>>>9":U no-undo.
    define output parameter i-cdn-pais-orig  as integer   format ">>,>>9":U    no-undo.
    define output parameter i-regime-import  as integer   format ">9":U        no-undo.

    for first item-fornec fields (cdn-fabrican cdn-pais-orig)
        where item-fornec.it-codigo    = c-it-codigo
        and   item-fornec.cod-emitente = i-cod-emitente no-lock: end.
    if  avail item-fornec then do:

        if  item-fornec.cdn-fabrican > 0 then
            assign i-cdn-fabrican = item-fornec.cdn-fabrican.

        if  item-fornec.cdn-pais-orig > 0 then
            assign i-cdn-pais-orig = item-fornec.cdn-pais-orig.
    end.

    if  i-cdn-fabrican = 0
    or  i-cdn-pais-orig = 0 then do:

        for first item-mat fields (cdn-fabrican cdn-pais-orig)
            where item-mat.it-codigo = c-it-codigo no-lock: end.
        if  avail item-mat then do:

            if  item-mat.cdn-fabrican > 0
            and i-cdn-fabrican = 0 then
                assign i-cdn-fabrican = item-mat.cdn-fabrican.

            if  item-mat.cdn-pais-orig > 0
            and i-cdn-pais-orig = 0 then
                assign i-cdn-pais-orig = item-mat.cdn-pais-orig.

        end.
    end.

    if  i-cdn-fabrican = 0 then
        assign i-cdn-fabrican  = i-cod-emitente.

    if  i-cdn-pais-orig = 0 then do:

        for first emitente fields (pais)
            where emitente.cod-emitente = i-cod-emitente no-lock: end.
        if  avail emitente then do:

            for first pais fields (cod-pais)
                where pais.nome-pais = emitente.pais no-lock: end.
            if  avail pais then
                assign i-cdn-pais-orig = pais.cod-pais.
        end.
    end.

    for first pais-aliquota fields (regime-import)
        where pais-aliquota.cod-pais     = i-cdn-pais-orig
        and   pais-aliquota.class-fiscal = c-class-fiscal
        and   pais-aliquota.log-regim-import-padr no-lock: end.
    if  avail pais-aliquota then
        assign i-regime-import = pais-aliquota.regime-import.
    else
        assign i-regime-import = 0.
    &endif

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setUsuario DBOProgram
PROCEDURE setUsuario :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    def input parameter p-usuario as char no-undo.

    assign c-usuario = p-usuario.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateCreateImp DBOProgram
PROCEDURE validateCreateImp :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    def input parameter  table for tt-cotacao-item.
    def input parameter  table for tt-cotacao-imp.
    def output parameter table for tt-bo-erro.

    FOR EACH TT-BO-ERRO:
        DELETE TT-BO-ERRO.
    END.

    /*
    ** Valida‡Æo Informa‡äes de Importa‡Æo
    */
    run validateFieldsImp in THIS-PROCEDURE (input table tt-cotacao-imp,
                                             output table tt-bo-erro).

    if return-value = "OK":U then do:
        find first tt-cotacao-imp no-error.
        find first tt-cotacao-item no-error.
        if avail tt-cotacao-item then do:
            /*
            ** Grava‡Æo das informa‡äes nos campos livres
            */

            if tt-cotacao-imp.da-entrega-embarque = ? then
                assign tt-cotacao-imp.da-entrega-embarque = today.

            {inbo/boin082i.i1 tt-cotacao-imp tt-cotacao-item}
            &if "{&bf_mat_versao_ems}":U >= "2.062":U &then
            assign tt-cotacao-item.cdn-pais-orig = tt-cotacao-imp.cdn-pais-orig.
            &endif

            find first tt-cotacao-item no-lock no-error.

            /*
            ** Al¡quota do IPI quando utilizado Regime de Importa‡Æo / Atualiza‡Æo de Pre‡o
            */
            if tt-cotacao-imp.regime-import <> 0 then do:
                find first param-compra no-lock no-error.
                assign l-preco-bruto = (param-compra.ipi-sobre-preco = 1).
                assign tt-cotacao-item.aliquota-ipi = tt-cotacao-imp.aliq-ipi.
                {cdp/cd9300.i tt-cotacao-item}

    /*-----------------------------------------------------------------*/
    /* Include i-epc200.i2: Criacao de registro para temp-table tt-epc */
    for each tt-epc where tt-epc.cod-event = "AfterDesconto":
        delete tt-epc.
    end.
    {include/i-epc200.i2 &CodEvent='"AfterDesconto"'
                                     &CodParameter='"handle"'
                                     &ValueParameter="string(this-procedure)"}

    {include/i-epc200.i2 &CodEvent='"AfterDesconto"'
                                    &CodParameter='"table"'
                                    &ValueParameter='"tt-cotacao-item"'}

    {include/i-epc200.i2 &CodEvent='"AfterDesconto"'
                                   &CodParameter='"r-rowid"'
                       &ValueParameter='""'}

    /* Include i-epc201.i: Chamada do programa de EPC */
    {include/i-epc201.i "AfterDesconto"}
    if  return-value = "NOK":U then do:
        undo, return "NOK":U.
    end.
    /*-----------------------------------------------------------------*/
            end.
        end.
    end.
    else
        return "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateDeleteIntegrCotacao-item DBOProgram
PROCEDURE validateDeleteIntegrCotacao-item :
/*------------------------------------------------------------------------------
  Purpose:     Valida as integra‡äes da cota‡Æo do item com o m¢dulo de importa‡Æo para a elimina‡Æo
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    def input parameter pr-cotacao-item as rowid no-undo.
    def output parameter table for tt-bo-erro.

    FOR EACH TT-BO-ERRO:
        DELETE TT-BO-ERRO.
    END.

    def var r-cotacao-item-cex as rowid no-undo.
    def var c-return           as char  no-undo.

    find cotacao-item
        where rowid(cotacao-item) = pr-cotacao-item no-lock no-error.

    if avail cotacao-item then do:

        /*
        ** Tratamento atributo livre cotacao-item.char-1
        */
        {ccp/cc9019.i50}
        {cdp/cd4300.i4 "yes" cotacao-item.char-1}
        {ccp/cc9019.i51 "yes"}

        run cxbo/bocx085na.p persistent set hdbocotacao-item-cex.
        run openQueryStatic in hDBOCotacao-item-cex (input "Main":U).
        run findMapaCotacao in hDBOCotacao-item-cex (input cotacao-item.numero-ordem,
                                                     input cotacao-item.cod-emitente,
                                                     input cotacao-item.it-codigo,
                                                     input cotacao-item.seq-cotac,
                                                     input cotacao-item.data-cotacao,
                                                     input i-mapa-cotacao-i50).
        delete procedure hDBOCotacao-item-cex.

        if return-value = "OK":U or return-value = "" then do:
            {utp/ut-table.i movind cotacao-item 1}
            assign c-return = trim(return-value).
            {utp/ut-table.i mgcex cotacao-item-cex 1}
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen   = 1
                   tt-bo-erro.cd-erro    = 5
                   tt-bo-erro.mensagem   = c-return + "~~" + trim(return-value)
                   tt-bo-erro.parametros = c-return + "~~" + trim(return-value).
            RETURN "NOK":U.
        end.

    end.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateDespImp DBOProgram
PROCEDURE validateDespImp :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pnumero-ordem LIKE cotacao-item.numero-ordem NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente LIKE cotacao-item.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo    LIKE cotacao-item.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pseq-cotac    LIKE cotacao-item.seq-cotac NO-UNDO.
    DEF OUTPUT PARAM TABLE FOR tt-bo-erro.

    FIND FIRST bfcotacao-item
         WHERE bfcotacao-item.numero-ordem = pnumero-ordem
         AND   bfcotacao-item.cod-emitente = pcod-emitente
         AND   bfcotacao-item.it-codigo = pit-codigo
         AND   bfcotacao-item.seq-cotac = pseq-cotac
               NO-LOCK NO-ERROR.

    IF  AVAIL bfcotacao-item
    AND bfcotacao-item.cot-aprovada THEN DO:

        run utp/ut-msgs.p (input "msg":u,
                           input 30079,
                           input "":U).

        create tt-bo-erro.
        assign tt-bo-erro.i-sequen   = 1
               tt-bo-erro.cd-erro    = 30079
               tt-bo-erro.mensagem   = RETURN-VALUE.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateFieldsImp DBOProgram
PROCEDURE validateFieldsImp :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    def input parameter  table for tt-cotacao-imp.
    def output parameter table for tt-bo-erro.

    def var i-seq-erro   as integer no-undo.

    run cxbo/bocx085.p persistent set hdbocotacao-item-cex.

    find first tt-cotacao-imp no-error.

    /* Include i-epc200.i2: Criacao de registro para temp-table tt-epc */
    for each tt-epc where tt-epc.cod-event = "BeforeValidateMapa":
        delete tt-epc.
    end.
    {include/i-epc200.i2 &CodEvent='"BeforeValidateMapa"'
                                    &CodParameter='"table"'
                                    &ValueParameter='"tt-cotacao-imp"'}
    /* Include i-epc201.i: Chamada do programa de EPC */
    {include/i-epc201.i "BeforeValidateMapa"}

    FIND FIRST tt-epc NO-LOCK
         WHERE tt-epc.cod-event     = "BeforeValidateMapa"
         AND   tt-epc.cod-parameter = "NOT-VALIDATE" NO-ERROR.
    IF NOT AVAILABLE tt-epc THEN DO:

        /*
        ** Verifica Mapa de Cota‡Æo Informado
        */
        if tt-cotacao-imp.mapa-cotacao <> 0 then do:
            run validaMapacotacao in hDBOCotacao-item-cex (input tt-cotacao-imp.numero-ordem,
                                                           input tt-cotacao-imp.cod-emitente,
                                                           input tt-cotacao-imp.it-codigo,
                                                           input tt-cotacao-imp.seq-cotac,
                                                           input tt-cotacao-imp.mapa-cotacao,
                                                           output table tt-bo-erro).
            find first tt-bo-erro no-error.
            if avail tt-bo-erro then do:
                delete procedure hDBOCotacao-item-cex.
                RETURN "NOK":U.
            end.
        end.
    END.

    /*
    ** Valida informa‡äes de Importa‡Æo
    */
    run validaCotacaoitem in hDBOCotacao-item-cex (input tt-cotacao-imp.cod-emitente,
                                                   input tt-cotacao-imp.cod-incoterm,
                                                   input tt-cotacao-imp.cod-pto-contr,
                                                   input tt-cotacao-imp.cod-fabricante,
                                                   input tt-cotacao-imp.regime-import,
                                                   input tt-cotacao-imp.it-codigo,
                                                   input tt-cotacao-imp.class-fiscal,
                                                   INPUT tt-cotacao-imp.nbs,
                                                   &if "{&bf_mat_versao_ems}":U >= "2.062":U &then
                                                   input tt-cotacao-imp.cdn-pais-orig,
                                                   &endif
                                                   output table tt-bo-erro).

    delete procedure hDBOCotacao-item-cex.

    find first tt-bo-erro no-error.
    if avail tt-bo-erro then
        RETURN "NOK":U.

    /*
    ** Valida Itiner rio
    */
    IF tt-cotacao-imp.i-informa = 0 THEN DO:
        FOR FIRST ordem-compra FIELDS(num-pedido numero-ordem cod-estabel)
            WHERE ordem-compra.numero-ordem = tt-cotacao-imp.numero-ordem NO-LOCK:
        END.
        FOR FIRST param-imp FIELDS(int-1)
            WHERE param-imp.cod-estabel = ordem-compra.cod-estabel NO-LOCK:
        END.
        IF AVAIL param-imp THEN
            assign tt-cotacao-imp.i-informa = param-imp.int-1.
        ELSE DO:

            assign i-seq-erro = i-seq-erro + 1.
            create tt-bo-erro.

            RUN utp/ut-msgs.p (input "help":U,
                               input 33558,
                               input "~~" + "IM0000":U).
            assign tt-bo-erro.i-sequen = i-seq-erro
                   tt-bo-erro.cd-erro = 33558
                   tt-bo-erro.errorHelp = RETURN-VALUE.
            {utp/ut-liter.i "Importa‡Æo" *}
            run utp/ut-msgs.p (input "msg":U,
                               input 33558,
                               input return-value).
            ASSIGN tt-bo-erro.mensagem = RETURN-VALUE.
        END.
    end.

    if i-informa = 2 /* 2 - Data de Embarque 3 - Data de Entrega*/
    OR i-informa = 3 THEN DO:
        IF tt-cotacao-imp.cod-itiner = 0 THEN DO:
            ASSIGN i-seq-erro = i-seq-erro + 1.
            {utp/ut-table.i mgcex itinerario 1}
            CREATE tt-bo-erro.
            ASSIGN tt-bo-erro.parametros = trim(RETURN-VALUE).
            RUN utp/ut-msgs.p (input "msg":u,
                               INPUT 265,
                               INPUT tt-bo-erro.parametros).
            ASSIGN tt-bo-erro.i-sequen = i-seq-erro
                   tt-bo-erro.cd-erro  = 265
                   tt-bo-erro.mensagem = RETURN-VALUE.
        END.
        ELSE DO:
            IF NOT CAN-FIND(FIRST itinerario
                            WHERE itinerario.cod-itiner = tt-cotacao-imp.cod-itiner) THEN DO:
                ASSIGN i-seq-erro = i-seq-erro + 1.
                {utp/ut-table.i mgcex itinerario 1}
                CREATE tt-bo-erro.
                ASSIGN tt-bo-erro.parametros = trim(RETURN-VALUE).
                RUN utp/ut-msgs.p (input "msg":u,
                                   INPUT 2,
                                   INPUT tt-bo-erro.parametros).
                ASSIGN tt-bo-erro.i-sequen = i-seq-erro
                       tt-bo-erro.cd-erro  = 2
                       tt-bo-erro.mensagem = RETURN-VALUE.
            END.
        END.
    END.

    &if "{&bf_mat_versao_ems}":U >= "2.062":U &then
    if  not can-find(first pais
                        where pais.cod-pais = tt-cotacao-imp.cdn-pais-orig) then do:

        assign i-seq-erro = i-seq-erro + 1.
        create tt-bo-erro.
        {utp/ut-liter.i Pa¡s_de_Origem}
        assign tt-bo-erro.parametros = trim(return-value).
        run utp/ut-msgs.p (input "msg":u,
                           input 2,
                           input tt-bo-erro.parametros).
        assign tt-bo-erro.i-sequen = i-seq-erro
               tt-bo-erro.cd-erro  = 2
               tt-bo-erro.mensagem = return-value.
    end.
    &endif

    find first tt-bo-erro no-error.
    if  avail tt-bo-erro then
        return "NOK":U.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateIncotermPedido DBOProgram
PROCEDURE validateIncotermPedido :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    def input parameter p-num-pedido   like pedido-compr.num-pedido   no-undo.
    def input parameter p-numero-ordem like ordem-compra.numero-ordem no-undo.
    def input parameter p-cod-incoterm like inco-cx.cod-incoterm      no-undo.
    def output parameter table for tt-bo-erro.



    {ccp/cc9019.i50}

    find first bfOrdem-compra
        where bfOrdem-compra.num-pedido   =  p-num-pedido
          and bfOrdem-compra.numero-ordem <> p-numero-ordem
          and bfOrdem-compra.situacao     <> 4 no-lock no-error.
    if avail bfOrdem-compra then do:
        find bfCotacao-item1
            where bfCotacao-item1.numero-ordem = bfOrdem-compra.numero-ordem
              and bfCotacao-item1.cot-aprovada no-lock no-error.
        if avail bfCotacao-item1 then do:
            {cdp/cd4300.i4  "yes" bfCotacao-item1.char-1}
            {ccp/cc9019.i51 "yes"}
            if p-cod-incoterm     <> c-cod-incoterm-i50 AND
               c-cod-incoterm-i50 <> "":U then do:
                create tt-bo-erro.
                run utp/ut-msgs.p (input "msg":u,
                                   input 17478,
                                   input tt-bo-erro.parametros).
                assign tt-bo-erro.i-sequen      = 1
                       tt-bo-erro.cd-erro       = 17478
                       tt-bo-erro.mensagem      = return-value.
                RETURN "NOK":U.
            end.
        end.
    end.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateUpdateImp DBOProgram
PROCEDURE validateUpdateImp :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    def input parameter  table   for tt-cotacao-imp.
    def input parameter  r-chave as  rowid no-undo.
    def output parameter table   for tt-bo-erro.

    def var c-return       as char    no-undo.
    def var i-situacao     as integer no-undo.
    def var c-cod-incoterm as char    no-undo.
    def var c-return-value as char    no-undo.
    def var i-mapa-cotacao as integer no-undo.

    DEF VAR de-aliq-ii-antiga  AS DEC NO-UNDO.
    DEF VAR de-aliq-ipi-antiga AS DEC NO-UNDO.

    DEF VAR l-alterou-classif  AS LOG  NO-UNDO.
    DEF VAR l-alterou-pais     AS LOG  NO-UNDO.
    DEF VAR l-alterou-regime   AS LOG  NO-UNDO.

    {ccp/cc9019.i50}
    find first tt-cotacao-imp no-error.


    /*
    ** Verifica situa‡Æo da Ordem de Compra
    */

    run inbo/boin274.p persistent set hdboordem-compra.
    run openQueryStatic in hDBOOrdem-compra (input "Main":U).
    run goTokey         in hDBOOrdem-compra (input tt-cotacao-imp.numero-ordem).
    run getIntfield     in hDBOOrdem-compra (input "situacao":U,output i-situacao).
    if i-situacao = 4 or i-situacao = 6 then do:
        run utp/ut-msgs.p (input "msg":u,
                           input 7439,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = 1
               tt-bo-erro.cd-erro      = 7439
               tt-bo-erro.mensagem     = return-value.

        UNDO, RETURN "NOK":U.
    end.
    delete procedure hDBOOrdem-compra.

    /*
    ** Verifica se a ordem de compra est  vinculada a um embarque
    */
    run cxbo/bocx225na.p persistent set hdboordens-embarque.
    run openQueryStatic in hDBOOrdens-embarque (input "Main":U).
    run goToOrdemcompra in hDBOOrdens-embarque (input tt-cotacao-imp.numero-ordem).
    delete procedure hDBOordens-embarque.

    IF RETURN-VALUE = "" OR RETURN-VALUE = "OK":U THEN DO:

        if not avail ordem-compra then
            find first ordem-compra
                 where ordem-compra.numero-ordem = tt-cotacao-imp.numero-ordem no-lock no-error.

        if avail ordem-compra then do:
            if ordem-compra.nr-contrato <> 0 then do:

                if index(proversion,"webspeed") = 0 THEN DO:

                    /* Inicio -- Projeto Internacional */
                    {utp/ut-liter.i "Ordem_de_Contrato_j _est _vinculado_ao_Embarque" *}
                    run utp/ut-msgs.p (input "show":u,
                                       input 29662,
                                       input RETURN-VALUE + "!").
                END.
                ELSE DO:

                    create tt-bo-erro.
                    /*{utp/ut-liter.i Ordem_de_compra_j _est _vinculada_a_um_Embarque. * L}*/
                    /*assign tt-bo-erro.parametros    = c-return + "~~" + trim(return-value).*/
                    /* Inicio -- Projeto Internacional */
                    {utp/ut-liter.i "Ordem_de_Contrato_j _est _vinculado_ao_Embarque" *}
                    run utp/ut-msgs.p (input "msg":u,
                                       input 29662,
                                       input RETURN-VALUE + "!").

                    /* Inicio -- Projeto Internacional */
                    {utp/ut-liter.i "Ordem_de_Contrato_j _est _vinculado_ao_Embarque" *}
                    assign tt-bo-erro.i-sequen      = 1
                           tt-bo-erro.cd-erro       = 29662
                           tt-bo-erro.mensagem      = RETURN-VALUE + "!"
                           tt-bo-erro.ErrorSubType  = "WARNING".
                END.
            END.
            ELSE DO:
                if return-value = "OK":U or return-value = "" then do:
                FIND FIRST param-imp
                     WHERE param-imp.cod-estabel = ordem-compra.cod-estabel NO-LOCK NO-ERROR.
                     IF AVAIL PARAM-imp AND param-imp.log-1 = NO THEN DO:

                        create tt-bo-erro.
                        {utp/ut-table.i movind ordem-compra 1}
                        assign c-return = trim(return-value) + " " + STRING(tt-cotacao-imp.numero-ordem).
                        {utp/ut-liter.i Ordem_de_compra_j _est _vinculada_a_um_Embarque. * L}
                        assign tt-bo-erro.parametros    = c-return + "~~" + trim(return-value).
                        run utp/ut-msgs.p (input "msg":u,
                                           input 26802,
                                           input tt-bo-erro.parametros).
                        assign tt-bo-erro.i-sequen      = 1
                               tt-bo-erro.cd-erro       = 26802
                               tt-bo-erro.mensagem      = return-value.
                        UNDO, RETURN "NOK":U.
                     END.
                end.
            END.
        END.
    END.

    /*
    ** Valida‡Æo Informa‡äes de Importa‡Æo
    */
    run validateFieldsImp in THIS-PROCEDURE (input table tt-cotacao-imp,
                                             output table tt-bo-erro).
    if return-value = "OK":U then do:

        if not avail ordem-compra then
            find first ordem-compra
                 where ordem-compra.numero-ordem = tt-cotacao-imp.numero-ordem no-lock no-error.
        /*
        ** Tratamento incoterm das ordens do pedido
        */

        if ordem-compra.num-pedido <> 0 then do:
            find first bfOrdem-compra
                where bfOrdem-compra.num-pedido   =  ordem-compra.num-pedido
                  and bfOrdem-compra.numero-ordem <> ordem-compra.numero-ordem
                  and bfOrdem-compra.situacao     <> 4 no-lock no-error.


            if avail bfOrdem-compra then do:

                find bfCotacao-item1
                    where bfCotacao-item1.numero-ordem = bfOrdem-compra.numero-ordem
                      and bfCotacao-item1.cot-aprovada no-lock no-error.
                if avail bfCotacao-item1 then do:

                    {cdp/cd4300.i4  "yes" bfCotacao-item1.char-1}
                    {ccp/cc9019.i51 "yes"}
                    if tt-cotacao-imp.cod-incoterm <> c-cod-incoterm-i50 then do:
                        run cxbo/bocx225na.p persistent set hdboordens-embarque.
                        run openQueryStatic in hDBOOrdens-embarque (input "Main":U).


                        FOR EACH bfOrdem-compra FIELDS(num-pedido numero-ordem situacao nr-contrato)
                            WHERE bfOrdem-compra.num-pedido   =  ordem-compra.num-pedido
                              AND bfOrdem-compra.numero-ordem <> ordem-compra.numero-ordem NO-LOCK:

                            IF bfOrdem-compra.situacao        =  4 THEN NEXT.

                            run goToOrdemcompra in hDBOOrdens-embarque (input bfOrdem-compra.numero-ordem).

                            if return-value = "OK":U or return-value = "" then do:
                                IF bfOrdem-compra.nr-contrato <> 0 THEN DO:
                                    if index(proversion,"webspeed") = 0 THEN DO:

                                        /* Inicio -- Projeto Internacional */
                                        {utp/ut-liter.i "Ordem_de_Contrato_j _est _vinculado_ao_Embarque" *}
                                        run utp/ut-msgs.p (input "show":u,
                                                           input 29662,
                                                           input RETURN-VALUE + "!").
                                        LEAVE.
                                    END.
                                    ELSE DO:

                                        create tt-bo-erro.
                                        /*{utp/ut-liter.i Ordem_de_compra_j _est _vinculada_a_um_Embarque. * L}*/
                                        /*assign tt-bo-erro.parametros    = c-return + "~~" + trim(return-value).*/
                                        /* Inicio -- Projeto Internacional */
                                        {utp/ut-liter.i "Ordem_de_Contrato_j _est _vinculado_ao_Embarque" *}
                                        run utp/ut-msgs.p (input "msg":u,
                                                           input 29662,
                                                           input RETURN-VALUE + "!").

                                        /* Inicio -- Projeto Internacional */
                                        {utp/ut-liter.i "Ordem_de_Contrato_j _est _vinculado_ao_Embarque" *}
                                        assign tt-bo-erro.i-sequen      = 1
                                               tt-bo-erro.cd-erro       = 29662
                                               tt-bo-erro.mensagem      = RETURN-VALUE + "!"
                                               tt-bo-erro.ErrorSubType  = "WARNING".
                                    END.
                                END.
                            end.
                        END.
                        delete procedure hDBOordens-embarque.

                        FOR EACH bfOrdem-compra FIELDS(num-pedido numero-ordem situacao nr-contrato)
                            WHERE bfOrdem-compra.num-pedido   =  ordem-compra.num-pedido
                              AND bfOrdem-compra.numero-ordem <> ordem-compra.numero-ordem NO-LOCK:

                            IF bfOrdem-compra.situacao        =  4 THEN
                                NEXT.

                            FIND bfCotacao-item1
                                WHERE bfCotacao-item1.numero-ordem = bfOrdem-compra.numero-ordem
                                  AND bfCotacao-item1.cot-aprovada EXCLUSIVE-LOCK NO-ERROR.
                            IF AVAIL bfCotacao-item1 THEN DO:
                                {cdp/cd4300.i4  "yes" bfcotacao-item1.char-1}
                                {ccp/cc9019.i51 "yes"}
                                assign c-cod-incoterm-i50  = tt-cotacao-imp.cod-incoterm.
                                {ccp/cc9019.i51 "no"}
                                {cdp/cd4300.i4 "no" bfCotacao-item1.char-1}
                                for each cotacao-item-cex
                                    where cotacao-item-cex.numero-ordem = bfcotacao-item1.numero-ordem
                                      and cotacao-item-cex.cod-emitente = bfcotacao-item1.cod-emitente
                                      and cotacao-item-cex.it-codigo    = bfcotacao-item1.it-codigo
                                      and cotacao-item-cex.seq-cotac    = bfcotacao-item1.seq-cotac
                                      and cotacao-item-cex.data-cotacao = bfcotacao-item1.data-cotacao exclusive-lock:
                                    assign cotacao-item-cex.cod-incoterm = tt-cotacao-imp.cod-incoterm.
                                end.
                                FOR EACH cot-ordem
                                    WHERE cot-ordem.numero-ordem = bfcotacao-item1.numero-ordem
                                      AND cot-ordem.cod-emitente = bfcotacao-item1.cod-emitente
                                      AND cot-ordem.seq-cotac    = bfcotacao-item1.seq-cotac EXCLUSIVE-LOCK:
                                    ASSIGN cot-ordem.cod-incoterm = tt-cotacao-imp.cod-incoterm.
                                END.
                            END.
                        END.

                    end.
                end.
            end.
        end.

        find cotacao-item
            where rowid(cotacao-item) = r-chave exclusive-lock no-error.
        if avail cotacao-item then do:

            ASSIGN de-aliq-ii-antiga  = dec(substr(cotacao-item.char-1,61,20))
                   de-aliq-ipi-antiga = cotacao-item.aliquota-ipi.

            /*
            ** Verifica se existia mapa aprovado para a cota‡Æo
            */
            {cdp/cd4300.i4  "yes" cotacao-item.char-1}
            {ccp/cc9019.i51 "yes"}
            assign i-mapa-cotacao      = i-mapa-cotacao-i50.
            /*
            ** Grava‡Æo das informa‡äes nos campos livres
            */
            assign i-mapa-cotacao-i50  = tt-cotacao-imp.mapa-cotacao
                   c-cod-incoterm-i50  = tt-cotacao-imp.cod-incoterm
                   i-cod-pto-contr-i50 = tt-cotacao-imp.cod-pto-contr
                   de-aliq-ii-i50      = tt-cotacao-imp.aliq-ii
                   c-class-fiscal-i50  = tt-cotacao-imp.class-fiscal
                   l-alterou-classif   = (SUBSTR(cotacao-item.char-1,81,20) <> tt-cotacao-imp.class-fiscal)
                   &if "{&bf_mat_versao_ems}":U >= "2.062":U &then
                   l-alterou-pais      = (cotacao-item.cdn-pais-orig <> tt-cotacao-imp.cdn-pais-orig)
                   &else
                   l-alterou-pais = NO
                   &endif
                   l-alterou-regime    = (tt-cotacao-imp.regime-import <> INT(SUBSTR(cotacao-item.char-2,61,20)))
                   c-nbs-i50           = tt-cotacao-imp.nbs.

            {ccp/cc9019.i51 "no"}
            {cdp/cd4300.i4 "no" cotacao-item.char-1}

            if tt-cotacao-imp.da-entrega-embarque = ? then
                assign tt-cotacao-imp.da-entrega-embarque = today.

            {ocp/oc0201.i50}
            {cdp/cd4300.i4  "yes" cotacao-item.char-2}
            {ocp/oc0201.i51 "yes"}

            assign i-cod-fabricante-i50 = tt-cotacao-imp.cod-fabricante
                   i-regime-import-i50  = tt-cotacao-imp.regime-import.

            IF tt-cotacao-imp.i-informa = 2 THEN /*Data Embarque*/
                ASSIGN c-data-base-i50 = STRING(tt-cotacao-imp.da-entrega-embarque).

            {ocp/oc0201.i51 "no"}
            {cdp/cd4300.i4 "no" cotacao-item.char-2} /*yes*/

            assign cotacao-item.int-1         = tt-cotacao-imp.cod-itiner
                   &if "{&bf_mat_versao_ems}":U >= "2.062":U &then
                   cotacao-item.cdn-pais-orig = tt-cotacao-imp.cdn-pais-orig
                   &endif.

            IF tt-cotacao-imp.l-ex-tarifario THEN
                ASSIGN OVERLAY(cotacao-item.char-1,148,1) = "1":U.
            ELSE
                ASSIGN OVERLAY(cotacao-item.char-1,148,1) = "":U.

            /*
            ** Al¡quota do IPI quando atualizada Regime de Importa‡Æo / Atualiza‡Æo de Pre‡o
            */

            if tt-cotacao-imp.regime-import <> 0 then do:
                find first param-compra no-lock no-error.
                assign l-preco-bruto = (param-compra.ipi-sobre-preco = 1).

                assign cotacao-item.aliquota-ipi = tt-cotacao-imp.aliq-ipi.
                {cdp/cd9300.i cotacao-item}
                /*-----------------------------------------------------------------*/
                /* Include i-epc200.i2: Criacao de registro para temp-table tt-epc */

                IF c-nom-prog-dpc-mg97  <> "":U
                OR c-nom-prog-appc-mg97 <> "":U
                OR c-nom-prog-upc-mg97  <> "":U THEN DO:

                    for each tt-epc where tt-epc.cod-event = "AfterDesconto":
                        delete tt-epc.
                    end.
                    {include/i-epc200.i2 &CodEvent='"AfterDesconto"'
                                         &CodParameter='"handle"'
                                         &ValueParameter="string(this-procedure)"}

                    {include/i-epc200.i2 &CodEvent='"AfterDesconto"'
                                        &CodParameter='"table"'
                                        &ValueParameter='"cotacao-item"'}

                    {include/i-epc200.i2 &CodEvent='"AfterDesconto"'
                                       &CodParameter='"r-rowid"'
                                       &ValueParameter="STRING(rowid(cotacao-item))"}

                    /* Include i-epc201.i: Chamada do programa de EPC */
                    {include/i-epc201.i "AfterDesconto"}
                    if  return-value = "NOK":U then do:
                        undo, return "NOK":U.
                    end.
                END.
                /*-----------------------------------------------------------------*/
                assign cotacao-item.preco-unit   = cotacao-item.pre-unit-for.

                find ordem-compra
                    where ordem-compra.numero-ordem = cotacao-item.numero-ordem exclusive-lock no-error.
                assign ordem-compra.aliquota-ipi = tt-cotacao-imp.aliq-ipi.
                {cdp/cd9300.i ordem-compra}
                /*-----------------------------------------------------------------*/
                /* Include i-epc200.i2: Criacao de registro para temp-table tt-epc */
                IF c-nom-prog-dpc-mg97  <> "":U
                OR c-nom-prog-appc-mg97 <> "":U
                OR c-nom-prog-upc-mg97  <> "":U THEN DO:

                    for each tt-epc where tt-epc.cod-event = "AfterDesconto":
                        delete tt-epc.
                    end.
                    {include/i-epc200.i2 &CodEvent='"AfterDesconto"'
                                         &CodParameter='"handle"'
                                         &ValueParameter="string(this-procedure)"}

                    {include/i-epc200.i2 &CodEvent='"AfterDesconto"'
                                        &CodParameter='"table"'
                                        &ValueParameter='"ordem-compra"'}

                    {include/i-epc200.i2 &CodEvent='"AfterDesconto"'
                                       &CodParameter='"r-rowid"'
                                       &ValueParameter="STRING(rowid(ordem-compra))"}

                    /* Include i-epc201.i: Chamada do programa de EPC */
                    {include/i-epc201.i "AfterDesconto"}
                    if  return-value = "NOK":U then do:
                        undo, return "NOK":U.
                    end.
                END.
                /*-----------------------------------------------------------------*/
                assign ordem-compra.preco-unit   = ordem-compra.pre-unit-for.

                /*
                ** Calculo do preco de reposicao do item
                */
                run ccp/ccapi001.p (input rowid(ordem-compra)).
            end.

            &if "{&bf_mat_versao_ems}":U >= "2.062":U &then

            if  de-aliq-ii-antiga <> tt-cotacao-imp.aliq-ii then do:

                 for first bfOrdem-compra fields (cod-estabel)
                     where bfOrdem-compra.numero-ordem = cotacao-item.numero-ordem no-lock: end.
                 if  avail bfOrdem-compra then

                     for first param-imp fields (char-1 cdn-despes-impto-pis cdn-despes-impto-cofins)
                         where param-imp.cod-estabel = bfOrdem-compra.cod-estabel no-lock: end.
                     if  avail param-imp then do:

                         for each cotacao-item-cex fields (cod-desp)
                              where cotacao-item-cex.numero-ordem = cotacao-item.numero-ordem
                              and   cotacao-item-cex.cod-emitente = cotacao-item.cod-emitente
                              and   cotacao-item-cex.it-codigo    = cotacao-item.it-codigo
                              and   cotacao-item-cex.seq-cotac    = cotacao-item.seq-cotac
                              and   (  cotacao-item-cex.cod-desp  = int(substr(param-imp.char-1,21,20))         /* Despesa p/ o II */
                                    or cotacao-item-cex.cod-desp  = param-imp.cdn-despes-impto-pis              /* Despesa p/ o PIS */
                                    or cotacao-item-cex.cod-desp  = param-imp.cdn-despes-impto-cofins) no-lock: /* Despesa p/ o COFINS */

                             /* Recalcula o valor da despesa caso o mapa e a cotacao caso    **
                             ** estiverem aprovados, do contrario marca para ser recalculada */
                             run imp/imapi006.p(input "cotacao-item-cex-boin082i":u,
                                                input rowid(cotacao-item-cex),
                                                input cotacao-item-cex.cod-desp,
                                                input 0,
                                                input table tt-cotacao-item-cex,
                                                input-output table tt-desp-ja-recalc).

                         end.
                     end.
            end.

            IF  de-aliq-ipi-antiga <> tt-cotacao-imp.aliq-ipi
            OR  l-alterou-classif
            OR  l-alterou-pais
            OR  l-alterou-regime THEN DO:

                for first bfOrdem-compra fields (cod-estabel)
                    where bfOrdem-compra.numero-ordem = cotacao-item.numero-ordem no-lock: end.
                if  avail bfOrdem-compra then

                    for first param-imp fields (char-1 cdn-despes-impto-pis cdn-despes-impto-cofins)
                        where param-imp.cod-estabel = bfOrdem-compra.cod-estabel no-lock: end.
                    if  avail param-imp then do:

                        for each cotacao-item-cex fields (cod-desp)
                            where cotacao-item-cex.numero-ordem = cotacao-item.numero-ordem
                            and   cotacao-item-cex.cod-emitente = cotacao-item.cod-emitente
                            and   cotacao-item-cex.it-codigo    = cotacao-item.it-codigo
                            and   cotacao-item-cex.seq-cotac    = cotacao-item.seq-cotac no-lock:

                            for first desp-imp fields (tipo cod-desp)
                                where desp-imp.cod-desp = cotacao-item-cex.cod-desp no-lock: end.
                            if  not avail desp-imp then
                                next.

                            if  desp-imp.tipo = 7 /* Adicional sobre valor */
                            or  (   desp-imp.cod-desp = int(trim(substr(param-imp.char-1,21,20)))   /* Despesa p/ o II */
                                or  desp-imp.cod-desp = param-imp.cdn-despes-impto-pis        /* Despesa p/ o PIS */
                                or  desp-imp.cod-desp = param-imp.cdn-despes-impto-cofins     /* Despesa p/ o COFINS */
                                or  desp-imp.cod-desp = param-imp.cdn-despes-impto-ipi        /* Despesa p/ o IPI */
                                or  desp-imp.cod-desp = param-imp.cdn-despes-impto-icms) then do: /* Despesa p/ o ICMS */

                                /* Recalcula o valor da despesa caso o mapa e a cotacao         **
                                ** estiverem aprovados, do contrario marca para ser recalculada */
                                run imp/imapi006.p(input "cotacao-item-cex-boin082i":u,
                                                   input rowid(cotacao-item-cex),
                                                   input cotacao-item-cex.cod-desp,
                                                   input 0,
                                                   input table tt-cotacao-item-cex,
                                                   input-output table tt-desp-ja-recalc).
                            END.
                        end.
                    end.
            end.
            &endif

            /*
            ** Tratamento Mapa de Cota‡Æo de Despesas de Importa‡Æo
            */
            if i-mapa-cotacao <> 0 or tt-cotacao-imp.mapa-cotacao <> 0 then do:

                /*
                ** Tratamento altera‡Æo da incoterm
                */

                run cxbo/bocx085na.p persistent set hdbocotacao-item-cexna.
                run openQueryStatic in hDBOCotacao-item-cexna (input "Main":U).
                run findMapaCotacao in hDBOCotacao-item-cexna (input cotacao-item.numero-ordem,
                                                               input cotacao-item.cod-emitente,
                                                               input cotacao-item.it-codigo,
                                                               input cotacao-item.seq-cotac,
                                                               input cotacao-item.data-cotacao,
                                                               input tt-cotacao-imp.mapa-cotacao).
                if return-value = "" or return-value = "OK":U then
                    run getCharfield in hDBOCotacao-item-cexna (input "cod-incoterm",output c-cod-incoterm).
                delete procedure hDBOCotacao-item-cexna.

                if c-cod-incoterm <> "" and c-cod-incoterm <> tt-cotacao-imp.cod-incoterm then do:
                    for each cotacao-item-cex
                        where cotacao-item-cex.numero-ordem = cotacao-item.numero-ordem
                          and cotacao-item-cex.cod-emitente = cotacao-item.cod-emitente
                          and cotacao-item-cex.it-codigo    = cotacao-item.it-codigo
                          and cotacao-item-cex.seq-cotac    = cotacao-item.seq-cotac
                          and cotacao-item-cex.data-cotacao = cotacao-item.data-cotacao exclusive-lock:
                        assign cotacao-item-cex.cod-incoterm = tt-cotacao-imp.cod-incoterm.
                    end.
                end.

                &if "{&bf_mat_versao_ems}":U >= "2.062":U &then
                IF  NOT VALID-HANDLE(h-bocx085) THEN
                    RUN cxbo/bocx085.p persistent set h-bocx085.

                IF  VALID-HANDLE(h-bocx085) THEN DO:
                    RUN atualizaMapaDespesasPedido IN h-bocx085(INPUT ROWID(cotacao-item),
                                                                INPUT i-mapa-cotacao,
                                                                INPUT tt-cotacao-imp.mapa-cotacao).

                    RUN getTtBoErro IN h-bocx085(OUTPUT TABLE tt-bo-erro).

                    IF  CAN-FIND(FIRST tt-bo-erro
                                 WHERE tt-bo-erro.errorSubType <> "INFORMATION":U
                                   AND tt-bo-erro.errorSubType <> "WARNING":U) THEN
                        UNDO, RETURN "NOK":U.

                    DELETE PROCEDURE h-bocx085 NO-ERROR.
                    ASSIGN h-bocx085 = ?.
                END.
                &endif

                /*
                ** Tratamento cota‡Æo j  aprovada
                ** Refaz processo de aprova‡Æo se a ordem estiver cotada
                */
                if &if defined(bf_mat_contratos) &then ordem-compra.nr-contrato = 0 and &endif
                   (cotacao-item.cot-aprovada or cotacao-item.log-1) then do:

                    if ordem-compra.num-pedido = 0 then do:

                        /*
                        ** Instƒnciar BO campo de tabela estrangeira (cotacao-item)
                        */
                        run inbo/boin082vl.p persistent set hdbocotacao-itemvl.

                        /*
                        ** Aprova‡Æo Cota‡Æo do Material
                        */
                        RUN aprovaCotacaoitem IN hDBOCotacao-itemvl (INPUT ROWID(ordem-compra),
                                                                     INPUT ROWID(cotacao-item),
                                                                     INPUT cotacao-item.narrativa,
                                                                     INPUT c-usuario,
                                                                     INPUT 0,
                                                                     INPUT cotacao-item.cod-emitente).
                        assign c-return-value = return-value.
                        RUN getRowErrors IN hDBOCotacao-itemvl (OUTPUT TABLE tt-bo-erro).
                        delete procedure hDBOCotacao-itemvl.
                        IF c-return-value = "NOK":U and CAN-FIND(FIRST tt-bo-erro) THEN
                            UNDO, RETURN "NOK":U.

                    end.

                    if ordem-compra.num-pedido <> 0 then do:

                        /*
                        ** Instƒnciar BO campo de tabela estrangeira (cotacao-item)
                        */
                        run inbo/boin274vl.p persistent set hdboordem-compravl.

                        /*
                        ** Aprova‡Æo Ordem de compra do Material
                        */
                        run aprovaAddOrdemCompraPedidos in hDBOOrdem-compravl (input rowid(ordem-compra),
                                                                                        output table tt-bo-erro).
                        delete procedure hDBOOrdem-compravl.
                        if return-value = "NOK":U and CAN-FIND(FIRST tt-bo-erro) THEN
                            UNDO, RETURN "NOK":U.

                    end.
                end.
            end.
        end.
    end.
    else
        UNDO, RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateVinculacaoOrdemPedido DBOProgram
PROCEDURE validateVinculacaoOrdemPedido :
/*------------------------------------------------------------------------------
  Purpose:     Validar a vinculacao de uma ordem de compra a um pedido de compra
  Parameters:  p-cod-emitente - codigo do emitente do pedido;
               p-numero-ordem - ordem que ser  inclu¡da ao pedido de compra;
  Notes:
------------------------------------------------------------------------------*/
    DEF INPUT  PARAMETER p-cod-emitente LIKE emitente.cod-emitente     NO-UNDO.
    DEF INPUT  PARAMETER p-num-pedido   LIKE ordem-compra.num-pedido   NO-UNDO.
    DEF INPUT  PARAMETER p-numero-ordem LIKE ordem-compra.numero-ordem NO-UNDO.
    DEF OUTPUT PARAMETER TABLE FOR tt-bo-erro.

    FOR EACH TT-BO-ERRO:
        DELETE TT-BO-ERRO.
    END.

    {ccp/cc9019.i50}

    DEF VAR c-cod-incoterm1 LIKE inco-cx.cod-incoterm NO-UNDO.

    FIND FIRST param-global NO-LOCK NO-ERROR.
    IF AVAIL param-global THEN
        IF NOT param-global.modulo-07 THEN
            RETURN "OK":U.

    FOR FIRST emitente FIELDS (natureza)
        WHERE emitente.cod-emitente = p-cod-emitente NO-LOCK:
    END.

    IF emitente.natureza = 1 OR
       emitente.natureza = 2 THEN
        RETURN "OK":U.

    FOR FIRST ordem-compra FIELDS (num-pedido numero-ordem)
        WHERE ordem-compra.numero-ordem = p-numero-ordem NO-LOCK:
    END.
    IF NOT AVAIL ordem-compra THEN
        RETURN "OK":U.

    FOR FIRST cotacao-item FIELDS (char-1)
        WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
          AND cotacao-item.cot-aprovada NO-LOCK:
    END.
    IF NOT AVAIL cotacao-item THEN
        RETURN "OK":U.

    {cdp/cd4300.i4  "yes" cotacao-item.char-1}
    {ccp/cc9019.i51 "yes"}

    ASSIGN c-cod-incoterm1 = c-cod-incoterm-i50.

    RUN validateIncotermPedido (INPUT p-num-pedido,
                                INPUT ordem-compra.numero-ordem,
                                INPUT c-cod-incoterm1,
                                OUTPUT TABLE tt-bo-erro).
    IF CAN-FIND(FIRST tt-bo-erro) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



