&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOAD180O 2.00.00.011} /*** "010011" 18/10/2023 12:27:10  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boad180o MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : dbo.p
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
&GLOBAL-DEFINE DBOName BOAD180
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName mov-ap
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

/*--- Include com defini‡Æo da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com 
      extensÆo .i ---*/
{adbo/boad180.i RowObject}
{cdp/cdcfgfin.i}
{include/i_dbvers.i}

/*--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}


/*--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/* Defini‡äes para SetConstraints */
&IF "{&mguni_version}" >= "2.07A" &THEN
define variable i-empresa    LIKE empresa.ep-codigo   no-undo.
&ELSE
define variable i-empresa    as integer   no-undo.
&ENDIF
define variable i-forn-ini   as integer   no-undo.
define variable i-forn-fim   as integer   no-undo.
define variable c-estab-ini  as character no-undo.
define variable c-estab-fim  as character no-undo.
define variable c-esp-ini    as character no-undo.
define variable c-esp-fim    as character no-undo.
define variable c-serie-ini  as character no-undo.
define variable c-serie-fim  as character no-undo.
define variable c-docto-ini  as character no-undo.
define variable c-docto-fim  as character no-undo.
define variable c-parc-ini   as character no-undo.
define variable c-parc-fim   as character no-undo.
define variable da-trans-ini as date      no-undo.
define variable da-trans-fim as date      no-undo.
define variable c-referencia as char      no-undo.
define variable i-seq-enc-contas as inte  no-undo.
define variable r-mov-ap     as rowid     no-undo.
&IF "{&mguni_version}" >= "2.07A" &THEN
define variable i-ep-codigo  LIKE empresa.ep-codigo   no-undo.
&ELSE
define variable i-ep-codigo  as integer   no-undo.
&ENDIF
define variable c-especie    as character no-undo.
define variable c-serie      as character no-undo.
define variable c-estabel    as character no-undo.
define variable i-fornec     as integer   no-undo.
define variable c-nr-docto   as character no-undo.
define variable c-parcela    as character no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram



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
         HEIGHT             = 2.92
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FindFirstTransacao DBOProgram 
PROCEDURE FindFirstTransacao :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona no primeiro registro com base nas informa‡äes
               do titulo e a transacao
  Parameters:  recebe valor do campo ep-codigo
               recebe valor do campo cod-fornec
               recebe valor do campo cod-estabel
               recebe valor do campo cod-esp
               recebe valor do campo serie
               recebe valor do campo nr-docto
               recebe valor do campo parcela
               recebe valor do campo dt-transacao
               recebe valor do campo transacao
  Notes:       Este M‚todo facilita a busca de valores de um registro 
               onde se tem dispon¡vel a chave, sem ter de abrir uma query.
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo    LIKE mov-ap.ep-codigo    NO-UNDO.
    DEFINE INPUT PARAMETER pcod-fornec   LIKE mov-ap.cod-fornec   NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel  LIKE mov-ap.cod-estabel  NO-UNDO.
    DEFINE INPUT PARAMETER pcod-esp      LIKE mov-ap.cod-esp      NO-UNDO.
    DEFINE INPUT PARAMETER pserie        LIKE mov-ap.serie        NO-UNDO.
    DEFINE INPUT PARAMETER pnr-docto     LIKE mov-ap.nr-docto     NO-UNDO.
    DEFINE INPUT PARAMETER pparcela      LIKE mov-ap.parcela      NO-UNDO.
    DEFINE INPUT PARAMETER pdt-transacao LIKE mov-ap.dt-transacao NO-UNDO.
    DEFINE INPUT PARAMETER ptransacao    LIKE mov-ap.transacao    NO-UNDO.

    FIND FIRST
         bfmov-ap use-index codigo WHERE 
         bfmov-ap.ep-codigo    = pep-codigo AND 
         bfmov-ap.cod-fornec   = pcod-fornec AND 
         bfmov-ap.cod-estabel  = pcod-estabel AND 
         bfmov-ap.cod-esp      = pcod-esp AND 
         bfmov-ap.serie        = pserie AND 
         bfmov-ap.nr-docto     = pnr-docto AND 
         bfmov-ap.parcela      = pparcela AND 
         bfmov-ap.dt-transacao = pdt-transacao AND
         bfmov-ap.transacao    = ptransacao 
         NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF  NOT AVAILABLE bfmov-ap THEN 
        RETURN "NOK":U.

    buffer-copy bfmov-ap to RowObject.

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FindLastMovAp DBOProgram 
PROCEDURE FindLastMovAp :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona no œltimo registro com base nas informa»„es
               do titulo e a transacao
  Parameters:  recebe  valor do campo ep-codigo
               recebe  valor do campo cod-fornec
               recebe  valor do campo cod-estabel
               recebe  valor do campo cod-esp
               recebe  valor do campo serie
               recebe  valor do campo nr-docto
               recebe  valor do campo parcela
               recebe  valor do campo dt-transacao
               retorna valor do campo num-id-mov-ap
  Notes:       Este M²todo facilita a busca de valores de um registro 
               onde se tem dispon­vel a chave, sem ter de abrir uma query.
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pep-codigo     LIKE mov-ap.ep-codigo     NO-UNDO.
    DEFINE INPUT  PARAMETER pcod-fornec    LIKE mov-ap.cod-fornec    NO-UNDO.
    DEFINE INPUT  PARAMETER pcod-estabel   LIKE mov-ap.cod-estabel   NO-UNDO.
    DEFINE INPUT  PARAMETER pcod-esp       LIKE mov-ap.cod-esp       NO-UNDO.
    DEFINE INPUT  PARAMETER pserie         LIKE mov-ap.serie         NO-UNDO.
    DEFINE INPUT  PARAMETER pnr-docto      LIKE mov-ap.nr-docto      NO-UNDO.
    DEFINE INPUT  PARAMETER pparcela       LIKE mov-ap.parcela       NO-UNDO.
    DEFINE INPUT  PARAMETER pdt-transacao  LIKE mov-ap.dt-transacao  NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-id-mov-ap LIKE mov-ap.num-id-mov-ap NO-UNDO.

    FIND LAST
         bfmov-ap use-index num-id WHERE
         bfmov-ap.ep-codigo    = pep-codigo    AND
         bfmov-ap.cod-fornec   = pcod-fornec   AND
         bfmov-ap.cod-estabel  = pcod-estabel  AND
         bfmov-ap.cod-esp      = pcod-esp      AND
         bfmov-ap.serie        = pserie        AND
         bfmov-ap.nr-docto     = pnr-docto     AND
         bfmov-ap.parcela      = pparcela      AND
         bfmov-ap.dt-transacao = pdt-transacao AND
         bfmov-ap.transacao    = 5
         NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
    IF  NOT AVAILABLE bfmov-ap THEN
        RETURN "NOK":U.

    buffer-copy bfmov-ap to RowObject.
    assign pnum-id-mov-ap = bfmov-ap.num-id-mov-ap.

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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        &IF "{&mguni_version}" >= "2.07A" &THEN
            WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
        &ENDIF
        WHEN "agencia":U THEN ASSIGN pFieldValue = RowObject.agencia.
        &if "{&mgadm_version}" >= "2.02" &then
        WHEN "agencia-forn":U THEN ASSIGN pFieldValue = RowObject.agencia-forn.
        &endif
        WHEN "c-time":U THEN ASSIGN pFieldValue = RowObject.c-time.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-controle":U THEN ASSIGN pFieldValue = RowObject.cod-controle.
        WHEN "cod-docto":U THEN ASSIGN pFieldValue = RowObject.cod-docto.
        WHEN "cod-esp":U THEN ASSIGN pFieldValue = RowObject.cod-esp.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "conta-contabil":U THEN ASSIGN pFieldValue = RowObject.conta-contabil.
        &if "{&mgadm_version}" >= "2.02" &then
        WHEN "conta-corrente-forn":U THEN ASSIGN pFieldValue = RowObject.conta-corrente-forn.
        &endif
        WHEN "conta-cre-antec":U THEN ASSIGN pFieldValue = RowObject.conta-cre-antec.
        WHEN "conta-diversos":U THEN ASSIGN pFieldValue = RowObject.conta-diversos.
        WHEN "conta-frete":U THEN ASSIGN pFieldValue = RowObject.conta-frete.
        WHEN "conta-var-cambial":U THEN ASSIGN pFieldValue = RowObject.conta-var-cambial.
        WHEN "conta-var-monetaria":U THEN ASSIGN pFieldValue = RowObject.conta-var-monetaria.
        WHEN "ct-conta":U THEN ASSIGN pFieldValue = RowObject.ct-conta.
        WHEN "ct-conta-cam":U THEN ASSIGN pFieldValue = RowObject.ct-conta-cam.
        WHEN "ct-conta-var":U THEN ASSIGN pFieldValue = RowObject.ct-conta-var.
        WHEN "ct-cre-antec":U THEN ASSIGN pFieldValue = RowObject.ct-cre-antec.
        WHEN "ct-diversos":U THEN ASSIGN pFieldValue = RowObject.ct-diversos.
        WHEN "ct-frete":U THEN ASSIGN pFieldValue = RowObject.ct-frete.
        WHEN "cta-corrente":U THEN ASSIGN pFieldValue = RowObject.cta-corrente.
        WHEN "docto-ant":U THEN ASSIGN pFieldValue = RowObject.docto-ant.
        WHEN "esp-ant":U THEN ASSIGN pFieldValue = RowObject.esp-ant.
        WHEN "historico":U THEN ASSIGN pFieldValue = RowObject.historico.
        WHEN "literal":U THEN ASSIGN pFieldValue = RowObject.literal.
        &if defined(BF_FIN_RET_SALDO_PREV) &then
        WHEN "mov-relac-prev":U THEN ASSIGN pFieldValue = RowObject.mov-relac-prev.
        &endif
        WHEN "nome-abrev":U THEN ASSIGN pFieldValue = RowObject.nome-abrev.
        WHEN "nr-docto":U THEN ASSIGN pFieldValue = RowObject.nr-docto.
        WHEN "nr-docto-banco":U THEN ASSIGN pFieldValue = RowObject.nr-docto-banco.
        WHEN "nr-docto-emp":U THEN ASSIGN pFieldValue = RowObject.nr-docto-emp.
        WHEN "parc-ant":U THEN ASSIGN pFieldValue = RowObject.parc-ant.
        WHEN "parcela":U THEN ASSIGN pFieldValue = RowObject.parcela.
        WHEN "pedido":U THEN ASSIGN pFieldValue = RowObject.pedido.
        WHEN "referencia":U THEN ASSIGN pFieldValue = RowObject.referencia.
        WHEN "referencia-ct":U THEN ASSIGN pFieldValue = RowObject.referencia-ct.
        WHEN "sc-conta":U THEN ASSIGN pFieldValue = RowObject.sc-conta.
        WHEN "sc-conta-cam":U THEN ASSIGN pFieldValue = RowObject.sc-conta-cam.
        WHEN "sc-conta-var":U THEN ASSIGN pFieldValue = RowObject.sc-conta-var.
        WHEN "sc-cre-antec":U THEN ASSIGN pFieldValue = RowObject.sc-cre-antec.
        WHEN "sc-diversos":U THEN ASSIGN pFieldValue = RowObject.sc-diversos.
        WHEN "sc-frete":U THEN ASSIGN pFieldValue = RowObject.sc-frete.
        WHEN "serie":U THEN ASSIGN pFieldValue = RowObject.serie.
        WHEN "serie-ant":U THEN ASSIGN pFieldValue = RowObject.serie-ant.
        &if "{&mgadm_version}" >= "2.02" &then
        WHEN "titulo-banco":U THEN ASSIGN pFieldValue = RowObject.titulo-banco.
        &endif
        WHEN "usuario":U THEN ASSIGN pFieldValue = RowObject.usuario.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "da-data-1":U THEN ASSIGN pFieldValue = RowObject.da-data-1.
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "dt-desconto":U THEN ASSIGN pFieldValue = RowObject.dt-desconto.
        WHEN "dt-emis-ap":U THEN ASSIGN pFieldValue = RowObject.dt-emis-ap.
        WHEN "dt-emis-ch":U THEN ASSIGN pFieldValue = RowObject.dt-emis-ch.
        WHEN "dt-emissao":U THEN ASSIGN pFieldValue = RowObject.dt-emissao.
        WHEN "dt-pagamento":U THEN ASSIGN pFieldValue = RowObject.dt-pagamento.
        WHEN "dt-today":U THEN ASSIGN pFieldValue = RowObject.dt-today.
        WHEN "dt-transacao":U THEN ASSIGN pFieldValue = RowObject.dt-transacao.
        WHEN "dt-vencimen":U THEN ASSIGN pFieldValue = RowObject.dt-vencimen.
        WHEN "u-data-1":U THEN ASSIGN pFieldValue = RowObject.u-data-1.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "acerto-cmi":U THEN ASSIGN pFieldValue = RowObject.acerto-cmi.
        WHEN "cotacao-dia":U THEN ASSIGN pFieldValue = RowObject.cotacao-dia.
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "diversos":U THEN ASSIGN pFieldValue = RowObject.diversos.
        WHEN "diversos-me":U THEN ASSIGN pFieldValue = RowObject.diversos-me.
        WHEN "efeito-maxi":U THEN ASSIGN pFieldValue = RowObject.efeito-maxi.
        WHEN "fator-f":U THEN ASSIGN pFieldValue = RowObject.fator-f.
        WHEN "fator-x":U THEN ASSIGN pFieldValue = RowObject.fator-x.
        WHEN "fator-y":U THEN ASSIGN pFieldValue = RowObject.fator-y.
        WHEN "frete":U THEN ASSIGN pFieldValue = RowObject.frete.
        WHEN "frete-me":U THEN ASSIGN pFieldValue = RowObject.frete-me.
        WHEN "ganho-perda":U THEN ASSIGN pFieldValue = RowObject.ganho-perda.
        WHEN "nr-cheque":U THEN ASSIGN pFieldValue = RowObject.nr-cheque.
        WHEN "valor-ap":U THEN ASSIGN pFieldValue = RowObject.valor-ap.
        WHEN "valor-ir":U THEN ASSIGN pFieldValue = RowObject.valor-ir.
        WHEN "valor-ir-cmi":U THEN ASSIGN pFieldValue = RowObject.valor-ir-cmi.
        WHEN "valor-ir-fasb":U THEN ASSIGN pFieldValue = RowObject.valor-ir-fasb.
        WHEN "valor-juros":U THEN ASSIGN pFieldValue = RowObject.valor-juros.
        WHEN "valor-juros-me":U THEN ASSIGN pFieldValue = RowObject.valor-juros-me.
        WHEN "valor-mov":U THEN ASSIGN pFieldValue = RowObject.valor-mov.
        WHEN "valor-mov-me":U THEN ASSIGN pFieldValue = RowObject.valor-mov-me.
        WHEN "valor-presente":U THEN ASSIGN pFieldValue = RowObject.valor-presente.
        &if defined(BF_FIN_MULTA_ABATIMENTO) &then
        WHEN "vl-abatimento":U THEN ASSIGN pFieldValue = RowObject.vl-abatimento.
        WHEN "vl-abatimento-cmi":U THEN ASSIGN pFieldValue = RowObject.vl-abatimento-cmi.
        WHEN "vl-abatimento-fasb":U THEN ASSIGN pFieldValue = RowObject.vl-abatimento-fasb.
        WHEN "vl-abatimento-me":U THEN ASSIGN pFieldValue = RowObject.vl-abatimento-me.
        &endif
        WHEN "vl-ant-cmi":U THEN ASSIGN pFieldValue = RowObject.vl-ant-cmi.
        WHEN "vl-ant-fasb":U THEN ASSIGN pFieldValue = RowObject.vl-ant-fasb.
        WHEN "vl-antecip":U THEN ASSIGN pFieldValue = RowObject.vl-antecip.
        WHEN "vl-antecip-me":U THEN ASSIGN pFieldValue = RowObject.vl-antecip-me.
        WHEN "vl-correcao":U THEN ASSIGN pFieldValue = RowObject.vl-correcao.
        WHEN "vl-desc-cmi":U THEN ASSIGN pFieldValue = RowObject.vl-desc-cmi.
        WHEN "vl-desc-fasb":U THEN ASSIGN pFieldValue = RowObject.vl-desc-fasb.
        WHEN "vl-desconto":U THEN ASSIGN pFieldValue = RowObject.vl-desconto.
        WHEN "vl-desconto-me":U THEN ASSIGN pFieldValue = RowObject.vl-desconto-me.
        WHEN "vl-dif-camb":U THEN ASSIGN pFieldValue = RowObject.vl-dif-camb.
        WHEN "vl-diferenca":U THEN ASSIGN pFieldValue = RowObject.vl-diferenca.
        WHEN "vl-docto-ch":U THEN ASSIGN pFieldValue = RowObject.vl-docto-ch.
        WHEN "vl-isr":U THEN ASSIGN pFieldValue = RowObject.vl-isr.
        WHEN "vl-juro-fasb":U THEN ASSIGN pFieldValue = RowObject.vl-juro-fasb.
        WHEN "vl-juros-cmi":U THEN ASSIGN pFieldValue = RowObject.vl-juros-cmi.
        WHEN "vl-mov-cmi":U THEN ASSIGN pFieldValue = RowObject.vl-mov-cmi.
        WHEN "vl-mov-fasb":U THEN ASSIGN pFieldValue = RowObject.vl-mov-fasb.
        &if defined(BF_FIN_MULTA_ABATIMENTO) &then
        WHEN "vl-multa":U THEN ASSIGN pFieldValue = RowObject.vl-multa.
        WHEN "vl-multa-cmi":U THEN ASSIGN pFieldValue = RowObject.vl-multa-cmi.
        WHEN "vl-multa-fasb":U THEN ASSIGN pFieldValue = RowObject.vl-multa-fasb.
        WHEN "vl-multa-me":U THEN ASSIGN pFieldValue = RowObject.vl-multa-me.
        &endif
        WHEN "vl-orig-me":U THEN ASSIGN pFieldValue = RowObject.vl-orig-me.
        WHEN "vl-original":U THEN ASSIGN pFieldValue = RowObject.vl-original.
        WHEN "vl-taxa":U THEN ASSIGN pFieldValue = RowObject.vl-taxa.
        WHEN "vl-var-camb":U THEN ASSIGN pFieldValue = RowObject.vl-var-camb.
        WHEN "vl-var-monet":U THEN ASSIGN pFieldValue = RowObject.vl-var-monet.
        WHEN "vl-var-monet-antecip":U THEN ASSIGN pFieldValue = RowObject.vl-var-monet-antecip.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "banco":U THEN ASSIGN pFieldValue = RowObject.banco.
        &if "{&mgadm_version}" >= "2.02" &then
        WHEN "cod-banco-forn":U THEN ASSIGN pFieldValue = RowObject.cod-banco-forn.
        &endif
        WHEN "cod-fornec":U THEN ASSIGN pFieldValue = RowObject.cod-fornec.
        WHEN "cod-projeto":U THEN ASSIGN pFieldValue = RowObject.cod-projeto.
        WHEN "cod-retencao":U THEN ASSIGN pFieldValue = RowObject.cod-retencao.
        WHEN "cod-tax":U THEN ASSIGN pFieldValue = RowObject.cod-tax.
        &IF "{&mguni_version}" < "2.07A" &THEN
            WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
        &ENDIF
        WHEN "fornec-ant":U THEN ASSIGN pFieldValue = RowObject.fornec-ant.
        WHEN "hp-codigo":U THEN ASSIGN pFieldValue = RowObject.hp-codigo.
        WHEN "ind-tp-alter":U THEN ASSIGN pFieldValue = RowObject.ind-tp-alter.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "lancamento":U THEN ASSIGN pFieldValue = RowObject.lancamento.
        WHEN "modalidade":U THEN ASSIGN pFieldValue = RowObject.modalidade.
        WHEN "moeda":U THEN ASSIGN pFieldValue = RowObject.moeda.
        WHEN "nominal":U THEN ASSIGN pFieldValue = RowObject.nominal.
        WHEN "nr-bordero":U THEN ASSIGN pFieldValue = RowObject.nr-bordero.
        WHEN "num-id-mov-ap":U THEN ASSIGN pFieldValue = RowObject.num-id-mov-ap.
        WHEN "num-ord-inv":U THEN ASSIGN pFieldValue = RowObject.num-ord-inv.
        WHEN "origem":U THEN ASSIGN pFieldValue = RowObject.origem.
        WHEN "port-transf":U THEN ASSIGN pFieldValue = RowObject.port-transf.
        WHEN "portador":U THEN ASSIGN pFieldValue = RowObject.portador.
        WHEN "sequencia":U THEN ASSIGN pFieldValue = RowObject.sequencia.
        WHEN "tipo":U THEN ASSIGN pFieldValue = RowObject.tipo.
        WHEN "tp-codigo":U THEN ASSIGN pFieldValue = RowObject.tp-codigo.
        WHEN "tp-pagto":U THEN ASSIGN pFieldValue = RowObject.tp-pagto.
        WHEN "tp-recta-transf":U THEN ASSIGN pFieldValue = RowObject.tp-recta-transf.
        WHEN "transacao":U THEN ASSIGN pFieldValue = RowObject.transacao.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice codigo
  Parameters:  
               retorna valor do campo ep-codigo
               retorna valor do campo cod-fornec
               retorna valor do campo cod-estabel
               retorna valor do campo cod-esp
               retorna valor do campo serie
               retorna valor do campo nr-docto
               retorna valor do campo parcela
               retorna valor do campo dt-transacao
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pep-codigo LIKE mov-ap.ep-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-fornec LIKE mov-ap.cod-fornec NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE mov-ap.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-esp LIKE mov-ap.cod-esp NO-UNDO.
    DEFINE OUTPUT PARAMETER pserie LIKE mov-ap.serie NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-docto LIKE mov-ap.nr-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pparcela LIKE mov-ap.parcela NO-UNDO.
    DEFINE OUTPUT PARAMETER pdt-transacao LIKE mov-ap.dt-transacao NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pep-codigo = RowObject.ep-codigo
           pcod-fornec = RowObject.cod-fornec
           pcod-estabel = RowObject.cod-estabel
           pcod-esp = RowObject.cod-esp
           pserie = RowObject.serie
           pnr-docto = RowObject.nr-docto
           pparcela = RowObject.parcela
           pdt-transacao = RowObject.dt-transacao.

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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "baixa-subs":U THEN ASSIGN pFieldValue = RowObject.baixa-subs.
        WHEN "baixa-transf":U THEN ASSIGN pFieldValue = RowObject.baixa-transf.
        WHEN "cancela-ch":U THEN ASSIGN pFieldValue = RowObject.cancela-ch.
        WHEN "contabiliza":U THEN ASSIGN pFieldValue = RowObject.contabiliza.
        WHEN "contabilizou":U THEN ASSIGN pFieldValue = RowObject.contabilizou.
        WHEN "emit-fita":U THEN ASSIGN pFieldValue = RowObject.emit-fita.
        WHEN "emitiu-ap":U THEN ASSIGN pFieldValue = RowObject.emitiu-ap.
        WHEN "emitiu-ch":U THEN ASSIGN pFieldValue = RowObject.emitiu-ch.
        &if defined(BF_FIN_203) &then
        WHEN "flag-cent":U THEN ASSIGN pFieldValue = RowObject.flag-cent.
        &endif
        WHEN "flag-contab":U THEN ASSIGN pFieldValue = RowObject.flag-contab.
        WHEN "impostos":U THEN ASSIGN pFieldValue = RowObject.impostos.
        WHEN "ind-ir":U THEN ASSIGN pFieldValue = RowObject.ind-ir.
        &if defined(BF_FIN_203) &then
        WHEN "integra-cb":U THEN ASSIGN pFieldValue = RowObject.integra-cb.
        &endif
        &if "{&mgadm_version}" >= "2.02" &then
        WHEN "leitora":U THEN ASSIGN pFieldValue = RowObject.leitora.
        &endif
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "selecionado":U THEN ASSIGN pFieldValue = RowObject.selecionado.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
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
  Purpose:     Reposiciona registro com base no ¡ndice codigo
  Parameters:  recebe valor do campo ep-codigo
               recebe valor do campo cod-fornec
               recebe valor do campo cod-estabel
               recebe valor do campo cod-esp
               recebe valor do campo serie
               recebe valor do campo nr-docto
               recebe valor do campo parcela
               recebe valor do campo dt-transacao
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo    LIKE mov-ap.ep-codigo    NO-UNDO.
    DEFINE INPUT PARAMETER pcod-fornec   LIKE mov-ap.cod-fornec   NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel  LIKE mov-ap.cod-estabel  NO-UNDO.
    DEFINE INPUT PARAMETER pcod-esp      LIKE mov-ap.cod-esp      NO-UNDO.
    DEFINE INPUT PARAMETER pserie        LIKE mov-ap.serie        NO-UNDO.
    DEFINE INPUT PARAMETER pnr-docto     LIKE mov-ap.nr-docto     NO-UNDO.
    DEFINE INPUT PARAMETER pparcela      LIKE mov-ap.parcela      NO-UNDO.
    DEFINE INPUT PARAMETER pdt-transacao LIKE mov-ap.dt-transacao NO-UNDO.

    FIND FIRST
         bfmov-ap use-index codigo WHERE 
         bfmov-ap.ep-codigo    = pep-codigo AND 
         bfmov-ap.cod-fornec   = pcod-fornec AND 
         bfmov-ap.cod-estabel  = pcod-estabel AND 
         bfmov-ap.cod-esp      = pcod-esp AND 
         bfmov-ap.serie        = pserie AND 
         bfmov-ap.nr-docto     = pnr-docto AND 
         bfmov-ap.parcela      = pparcela AND 
         bfmov-ap.dt-transacao = pdt-transacao NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF  NOT AVAILABLE bfmov-ap THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmov-ap)).
    IF  RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey2 DBOProgram 
PROCEDURE goToKey2 :
/*------------------------------------------------------------------------------
  Purpose:     Posiciona o registro do Buffer e Carrega a RowOject apenas
               com o registro posicionado pela chave
  Parameters:  recebe valor do campo ep-codigo
               recebe valor do campo cod-fornec
               recebe valor do campo cod-estabel
               recebe valor do campo cod-esp
               recebe valor do campo serie
               recebe valor do campo nr-docto
               recebe valor do campo parcela
               recebe valor do campo dt-transacao

  Notes:       Este M‚todo facilita a busca de valores pelos m‚todos get,
               de um registro onde se tem dispon¡vel a chave, 
               sem ter de abrir um query.
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo    LIKE mov-ap.ep-codigo    NO-UNDO.
    DEFINE INPUT PARAMETER pcod-fornec   LIKE mov-ap.cod-fornec   NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel  LIKE mov-ap.cod-estabel  NO-UNDO.
    DEFINE INPUT PARAMETER pcod-esp      LIKE mov-ap.cod-esp      NO-UNDO.
    DEFINE INPUT PARAMETER pserie        LIKE mov-ap.serie        NO-UNDO.
    DEFINE INPUT PARAMETER pnr-docto     LIKE mov-ap.nr-docto     NO-UNDO.
    DEFINE INPUT PARAMETER pparcela      LIKE mov-ap.parcela      NO-UNDO.
    DEFINE INPUT PARAMETER pdt-transacao LIKE mov-ap.dt-transacao NO-UNDO.

    FIND FIRST
         bfmov-ap use-index codigo WHERE 
         bfmov-ap.ep-codigo    = pep-codigo AND 
         bfmov-ap.cod-fornec   = pcod-fornec AND 
         bfmov-ap.cod-estabel  = pcod-estabel AND 
         bfmov-ap.cod-esp      = pcod-esp AND 
         bfmov-ap.serie        = pserie AND 
         bfmov-ap.nr-docto     = pnr-docto AND 
         bfmov-ap.parcela      = pparcela AND 
         bfmov-ap.dt-transacao = pdt-transacao NO-LOCK NO-ERROR.
    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF  NOT AVAILABLE bfmov-ap THEN 
        RETURN "NOK":U.

    buffer-copy bfmov-ap to RowObject.
    
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKeyNumID DBOProgram 
PROCEDURE goToKeyNumID :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ¡ndice codigo
  Parameters:  recebe valor do campo num-id-mov-ap
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnum-id-mov-ap LIKE mov-ap.num-id-mov-ap    NO-UNDO.

    FIND bfmov-ap use-index num-id WHERE 
         bfmov-ap.num-id-mov-ap = pnum-id-mov-ap
         NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF  NOT AVAILABLE bfmov-ap THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmov-ap)).
    IF  RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKeyNumID2 DBOProgram 
PROCEDURE goToKeyNumID2 :
/*------------------------------------------------------------------------------
  Purpose:     Posiciona o registro do Buffer e Carrega a RowOject apenas
               com o registro posicionado pela chave
  Parameters:  recebe valor do campo num-id-mov-ap
  Notes:       Este M‚todo facilita a busca de valores pelos m‚todos get,
               de um registro onde se tem dispon¡vel a chave, 
               sem ter de abrir um query.
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnum-id-mov-ap LIKE mov-ap.num-id-mov-ap    NO-UNDO.

    FIND bfmov-ap use-index num-id WHERE 
         bfmov-ap.num-id-mov-ap = pnum-id-mov-ap
         NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF  NOT AVAILABLE bfmov-ap THEN 
        RETURN "NOK":U.

    buffer-copy bfmov-ap to RowObject.

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LinkToEncContas DBOProgram 
PROCEDURE LinkToEncContas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM phandle AS HANDLE NO-UNDO.

    RUN GetKey IN phandle (output i-empresa, 
                           output c-referencia,
                           output i-seq-enc-contas). 

    RUN SetConstraintEnccontas IN THIS-PROCEDURE (INPUT i-empresa,
                                                  INPUT c-referencia,
                                                  INPUT i-seq-enc-contas).

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryCodigo DBOProgram 
PROCEDURE OpenQueryCodigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  if i-forn-ini = i-forn-fim then
        OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK WHERE
                                         {&TableName}.ep-codigo     = i-empresa and
                                         {&TableName}.cod-fornec    = i-forn-ini and
                                         {&TableName}.cod-estabel  >= c-estab-ini and
                                         {&TableName}.cod-estabel  <= c-estab-fim and
                                         {&TableName}.cod-esp      >= c-esp-ini and
                                         {&TableName}.cod-esp      <= c-esp-fim and
                                         {&TableName}.serie        >= c-serie-ini and
                                         {&TableName}.serie        <= c-serie-fim and
                                         {&TableName}.nr-docto     >= c-docto-ini and
                                         {&TableName}.nr-docto     <= c-docto-fim and
                                         {&TableName}.parcela      >= c-parc-ini and
                                         {&TableName}.parcela      <= c-parc-fim and
                                         {&TableName}.dt-transacao >= da-trans-ini and
                                         {&TableName}.dt-transacao <= da-trans-fim
                                         INDEXED-REPOSITION.
  
  else do:
     if da-trans-ini = da-trans-fim then
        OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK WHERE
                                         {&TableName}.ep-codigo     = i-empresa and
                                         {&TableName}.dt-transacao  = da-trans-ini and
                                         {&TableName}.cod-fornec   >= i-forn-ini and
                                         {&TableName}.cod-fornec   <= i-forn-fim and
                                         {&TableName}.cod-estabel  >= c-estab-ini and
                                         {&TableName}.cod-estabel  <= c-estab-fim and
                                         {&TableName}.cod-esp      >= c-esp-ini and
                                         {&TableName}.cod-esp      <= c-esp-fim and
                                         {&TableName}.serie        >= c-serie-ini and
                                         {&TableName}.serie        <= c-serie-fim and
                                         {&TableName}.nr-docto     >= c-docto-ini and
                                         {&TableName}.nr-docto     <= c-docto-fim and
                                         {&TableName}.parcela      >= c-parc-ini and
                                         {&TableName}.parcela      <= c-parc-fim
                                         INDEXED-REPOSITION.     
     else
        OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK WHERE
                                         {&TableName}.ep-codigo     = i-empresa and
                                         {&TableName}.cod-fornec   >= i-forn-ini and
                                         {&TableName}.cod-fornec   <= i-forn-fim and
                                         {&TableName}.cod-estabel  >= c-estab-ini and
                                         {&TableName}.cod-estabel  <= c-estab-fim and
                                         {&TableName}.cod-esp      >= c-esp-ini and
                                         {&TableName}.cod-esp      <= c-esp-fim and
                                         {&TableName}.serie        >= c-serie-ini and
                                         {&TableName}.serie        <= c-serie-fim and
                                         {&TableName}.nr-docto     >= c-docto-ini and
                                         {&TableName}.nr-docto     <= c-docto-fim and
                                         {&TableName}.parcela      >= c-parc-ini and
                                         {&TableName}.parcela      <= c-parc-fim and
                                         {&TableName}.dt-transacao >= da-trans-ini and
                                         {&TableName}.dt-transacao <= da-trans-fim
                                         INDEXED-REPOSITION.
  
  end. 
  return "OK":U.   
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryEncContas DBOProgram 
PROCEDURE OpenQueryEncContas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &IF defined(BF_FIN_ENCCONTAS) &THEN
        OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
          WHERE {&TableName}.ep-codigo      = i-empresa AND
                {&TableName}.referencia     = c-referencia AND
                {&TableName}.seq-enc-contas = i-seq-enc-contas.
    
        RETURN "OK":U.
    &ENDIF
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryMain DBOProgram 
PROCEDURE OpenQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK WHERE
                                     {&TableName}.ep-codigo = i-empresa
                                     INDEXED-REPOSITION.

    return "OK":U.                                     
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryRowid DBOProgram 
PROCEDURE OpenQueryRowid :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK 
                               WHERE rowid({&TableName}) = r-mov-ap
                               INDEXED-REPOSITION.

/*    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK 
 *                                WHERE {&TableName}.ep-codigo   = i-ep-codigo
 *                                AND   {&TableName}.cod-esp     = c-especie
 *                                AND   {&TableName}.serie       = c-serie
 *                                AND   {&TableName}.cod-estabel = c-estabel
 *                                AND   {&TableName}.cod-fornec  = i-fornec
 *                                AND   {&TableName}.nr-docto    = c-nr-docto
 *                                AND   {&TableName}.parcela     = c-parcela
 *                                INDEXED-REPOSITION.*/

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-baixa DBOProgram 
PROCEDURE pi-verifica-baixa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*** Procedure utilizada pelo m½dulo de c³mbio ***/

    DEFINE INPUT PARAMETER p-ep-codigo   LIKE mov-ap.ep-codigo   NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-fornec  LIKE mov-ap.cod-fornec  NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-estabel LIKE mov-ap.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-esp     LIKE mov-ap.cod-esp     NO-UNDO.
    DEFINE INPUT PARAMETER p-serie       LIKE mov-ap.serie       NO-UNDO.
    DEFINE INPUT PARAMETER p-nr-docto    LIKE mov-ap.nr-docto    NO-UNDO.
    DEFINE INPUT PARAMETER p-parcela     LIKE mov-ap.parcela     NO-UNDO.
    DEFINE INPUT PARAMETER p-nr-contrato as   char               NO-UNDO.
    DEFINE INPUT PARAMETER p-dt-contrato as   date               NO-UNDO.

    &if defined(BF_FIN_MODUL_CAMBIO) &then
        find param-global no-lock no-error.
        if param-global.modulo-mec = yes then do:
            if can-find (first mov-ap 
                           where mov-ap.ep-codigo = p-ep-codigo
                           and mov-ap.cod-fornec  = p-cod-fornec
                           and mov-ap.cod-estabel = p-cod-estabel
                           and mov-ap.cod-esp     = p-cod-esp
                           and mov-ap.serie       = p-serie
                           and mov-ap.nr-docto    = p-nr-docto
                           and mov-ap.parcela     = p-parcela
                           and mov-ap.nr-contrato = p-nr-contrato
                           and mov-ap.dt-contrato = p-dt-contrato
                           and mov-ap.transacao   = 2) then
                           RETURN "NOK":U.
            else
                RETURN "OK":U.
        end.
    &endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRowidTitulo DBOProgram 
PROCEDURE piRowidTitulo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo LIKE mov-ap.ep-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-fornec LIKE mov-ap.cod-fornec NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE mov-ap.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pcod-esp LIKE mov-ap.cod-esp NO-UNDO.
    DEFINE INPUT PARAMETER pserie LIKE mov-ap.serie NO-UNDO.
    DEFINE INPUT PARAMETER pnr-docto LIKE mov-ap.nr-docto NO-UNDO.
    DEFINE INPUT PARAMETER pparcela LIKE mov-ap.parcela NO-UNDO.
    DEF OUTPUT PARAM p-rowid-tit AS ROWID NO-UNDO.
    
    find tit-ap where
        tit-ap.ep-codigo    = pep-codigo and
        tit-ap.cod-fornec   = pcod-fornec and
        tit-ap.cod-estabel  = pcod-estabel and
        tit-ap.cod-esp      = pcod-esp and
        tit-ap.serie        = pserie and
        tit-ap.nr-docto     = pnr-docto and
        tit-ap.parcela      = pparcela no-lock no-error.

    if  not avail tit-ap then 
        RETURN "NOK":U.

    assign p-rowid-tit = rowid(tit-ap).
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetConstraintCodigo DBOProgram 
PROCEDURE SetConstraintCodigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

&IF "{&mguni_version}" >= "2.07A" &THEN
    define input parameter p-empresa    LIKE empresa.ep-codigo   no-undo.
&ELSE
    define input parameter p-empresa    as integer   no-undo.
&ENDIF
    define input parameter p-forn-ini   as integer   no-undo.
    define input parameter p-forn-fim   as integer   no-undo.
    define input parameter p-estab-ini  as character no-undo.
    define input parameter p-estab-fim  as character no-undo.
    define input parameter p-esp-ini    as character no-undo.
    define input parameter p-esp-fim    as character no-undo.
    define input parameter p-serie-ini  as character no-undo.
    define input parameter p-serie-fim  as character no-undo.
    define input parameter p-docto-ini  as character no-undo.
    define input parameter p-docto-fim  as character no-undo.
    define input parameter p-parc-ini   as character no-undo.
    define input parameter p-parc-fim   as character no-undo.
    define input parameter p-trans-ini  as date      no-undo.
    define input parameter p-trans-fim  as date      no-undo.

    assign i-empresa    = p-empresa
           i-forn-ini   = p-forn-ini
           i-forn-fim   = p-forn-fim
           c-estab-ini  = p-estab-ini
           c-estab-fim  = p-estab-fim
           c-esp-ini    = p-esp-ini
           c-esp-fim    = p-esp-fim
           c-serie-ini  = p-serie-ini
           c-serie-fim  = p-serie-fim
           c-docto-ini  = p-docto-ini
           c-docto-fim  = p-docto-fim
           c-parc-ini   = p-parc-ini
           c-parc-fim   = p-parc-fim
           da-trans-ini = p-trans-ini
           da-trans-fim = p-trans-fim.

    return "OK":U.           
               
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetConstraintEncContas DBOProgram 
PROCEDURE SetConstraintEncContas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&IF "{&mguni_version}" >= "2.07A" &THEN
    DEF INPUT PARAM p-empresa        LIKE empresa.ep-codigo NO-UNDO.
&ELSE
    DEF INPUT PARAM p-empresa        AS INTEGER NO-UNDO.
&ENDIF
    DEF INPUT PARAM p-referencia     AS CHAR    NO-UNDO.
    DEF INPUT PARAM p-seq-enc-contas AS INTEGER NO-UNDO.

    ASSIGN i-empresa        = p-empresa
           c-referencia     = p-referencia
           i-seq-enc-contas = p-seq-enc-contas.
 
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetConstraintMain DBOProgram 
PROCEDURE SetConstraintMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

&IF "{&mguni_version}" >= "2.07A" &THEN
    define input parameter p-empresa LIKE empresa.ep-codigo no-undo.
&ELSE
    define input parameter p-empresa as integer no-undo.
&ENDIF
    
    assign i-empresa = p-empresa.
    
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetConstraintRowid DBOProgram 
PROCEDURE SetConstraintRowid :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-rowid AS ROWID NO-UNDO.

    ASSIGN r-mov-ap = p-rowid.
/*    find mov-ap where rowid(mov-ap) = r-titulo.
 *     assign i-ep-codigo = mov-ap.ep-codigo
 *            c-especie   = mov-ap.cod-esp
 *            c-serie     = mov-ap.serie
 *            c-estabel   = mov-ap.cod-estabel
 *            i-fornec    = mov-ap.cod-fornec
 *            c-nr-docto  = mov-ap.nr-docto
 *            c-parcela   = mov-ap.parcela.*/
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Valida‡äes pertinentes ao DBO
  Parameters:  recebe o tipo de valida‡Æo (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    /*--- Utilize o parƒmetro pType para identificar quais as valida‡äes a serem
          executadas ---*/
    /*--- Os valores poss¡veis para o parƒmetro sÆo: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do 
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as valida‡äes ---*/
    
    /*--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


