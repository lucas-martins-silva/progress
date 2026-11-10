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
{include/i-prgvrs.i BOIN245NA 2.00.00.009 } /*** "010009" 14/12/2023 16:32:19  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN245NA MUT}
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
&GLOBAL-DEFINE DBOName BOIN245
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName natur-oper
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 


/*--- Include com defini‡Æo da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com 
      extensÆo .i ---*/
{inbo/boin245.i RowObject}


/*--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}


/*--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/* local variable definitions */

def var cIniNatOperacao as char no-undo.
def var cEndNatOperacao as char no-undo.
def var cIniDenominacao as char no-undo.
def var cEndDenominacao as char no-undo.

{cdp/cdcfgdis.i}

define temp-table RowErrorsFrotas no-undo
    field ErrorSequence    as integer
    field ErrorNumber      as integer
    field ErrorDescription as character
    field ErrorParameters  as character
    field ErrorType        as character
    field ErrorHelp        as character
    field ErrorSubType     as character.

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
         HEIGHT             = 2
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
        WHEN "cd-registro":U THEN ASSIGN pFieldValue = RowObject.cd-registro.
        WHEN "cd-vinc-ipi":U THEN ASSIGN pFieldValue = RowObject.cd-vinc-ipi.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-esp":U THEN ASSIGN pFieldValue = RowObject.cod-esp.
        WHEN "cod-natur-oper-bonif":U THEN ASSIGN pFieldValue = RowObject.cod-natur-oper-bonif.
        WHEN "ct-cusven":U THEN ASSIGN pFieldValue = RowObject.ct-cusven.
        WHEN "ct-recven":U THEN ASSIGN pFieldValue = RowObject.ct-recven.
        WHEN "ct-transven":U THEN ASSIGN pFieldValue = RowObject.ct-transven.
        WHEN "denominacao":U THEN ASSIGN pFieldValue = RowObject.denominacao.
        WHEN "especie-doc":U THEN ASSIGN pFieldValue = RowObject.especie-doc.
        WHEN "modelo-docto":U THEN ASSIGN pFieldValue = RowObject.modelo-docto.
        WHEN "narrativa":U THEN ASSIGN pFieldValue = RowObject.narrativa.
        WHEN "nat-comp":U THEN ASSIGN pFieldValue = RowObject.nat-comp.
        WHEN "nat-operacao":U THEN ASSIGN pFieldValue = RowObject.nat-operacao.
        WHEN "nat-vinculada":U THEN ASSIGN pFieldValue = RowObject.nat-vinculada.
        WHEN "sc-cusven":U THEN ASSIGN pFieldValue = RowObject.sc-cusven.
        WHEN "sc-recven":U THEN ASSIGN pFieldValue = RowObject.sc-recven.
        WHEN "sc-transven":U THEN ASSIGN pFieldValue = RowObject.sc-transven.
        WHEN "tp-base-icm":U THEN ASSIGN pFieldValue = RowObject.tp-base-icm.
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
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
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
        WHEN "aliq-icm-com":U THEN ASSIGN pFieldValue = RowObject.aliq-icm-com.
        WHEN "aliquota-icm":U THEN ASSIGN pFieldValue = RowObject.aliquota-icm.
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "icms-subs-trib":U THEN ASSIGN pFieldValue = RowObject.icms-subs-trib.
        WHEN "per-des-icms":U THEN ASSIGN pFieldValue = RowObject.per-des-icms.
        WHEN "per-fin-soc[1]":U THEN ASSIGN pFieldValue = RowObject.per-fin-soc[1].
        WHEN "per-fin-soc[2]":U THEN ASSIGN pFieldValue = RowObject.per-fin-soc[2].
        WHEN "per-sub-tri":U THEN ASSIGN pFieldValue = RowObject.per-sub-tri.
        WHEN "perc-PIS[1]":U THEN ASSIGN pFieldValue = RowObject.perc-PIS[1].
        WHEN "perc-PIS[2]":U THEN ASSIGN pFieldValue = RowObject.perc-PIS[2].
        WHEN "perc-red-icm":U THEN ASSIGN pFieldValue = RowObject.perc-red-icm.
        WHEN "perc-red-ipi":U THEN ASSIGN pFieldValue = RowObject.perc-red-ipi.
        WHEN "perc-red-iss":U THEN ASSIGN pFieldValue = RowObject.perc-red-iss.
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
        WHEN "cd-situacao":U THEN ASSIGN pFieldValue = RowObject.cd-situacao.
        WHEN "cd-trib-icm":U THEN ASSIGN pFieldValue = RowObject.cd-trib-icm.
        WHEN "cd-trib-ipi":U THEN ASSIGN pFieldValue = RowObject.cd-trib-ipi.
        WHEN "cd-trib-iss":U THEN ASSIGN pFieldValue = RowObject.cd-trib-iss.
        WHEN "cod-canal-venda":U THEN ASSIGN pFieldValue = RowObject.cod-canal-venda.
        WHEN "cod-mensagem":U THEN ASSIGN pFieldValue = RowObject.cod-mensagem.
        WHEN "idi-tip-devol-consig":U THEN ASSIGN pFieldValue = RowObject.idi-tip-devol-consig.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "merc-base-icms":U THEN ASSIGN pFieldValue = RowObject.merc-base-icms.
        WHEN "mercado":U THEN ASSIGN pFieldValue = RowObject.mercado.
        WHEN "oper-terc":U THEN ASSIGN pFieldValue = RowObject.oper-terc.
        WHEN "preco-saida":U THEN ASSIGN pFieldValue = RowObject.preco-saida.
        WHEN "tipo":U THEN ASSIGN pFieldValue = RowObject.tipo.
        WHEN "tipo-compra":U THEN ASSIGN pFieldValue = RowObject.tipo-compra.
        WHEN "tipo-trib":U THEN ASSIGN pFieldValue = RowObject.tipo-trib.
        WHEN "tp-oper-terc":U THEN ASSIGN pFieldValue = RowObject.tp-oper-terc.
        WHEN "tp-rec-desp":U THEN ASSIGN pFieldValue = RowObject.tp-rec-desp.
        WHEN "uso":U THEN ASSIGN pFieldValue = RowObject.uso.		
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice natureza
  Parameters:  
               retorna valor do campo nat-operacao
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnat-operacao LIKE natur-oper.nat-operacao NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnat-operacao = RowObject.nat-operacao.

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
        WHEN "alt-vl-it-terc":U THEN ASSIGN pFieldValue = RowObject.alt-vl-it-terc.
        WHEN "atual-estat":U THEN ASSIGN pFieldValue = RowObject.atual-estat.
        WHEN "atualiza-of":U THEN ASSIGN pFieldValue = RowObject.atualiza-of.
        WHEN "auto-ce":U THEN ASSIGN pFieldValue = RowObject.auto-ce.
        WHEN "auto-cr":U THEN ASSIGN pFieldValue = RowObject.auto-cr.
        WHEN "auto-ct":U THEN ASSIGN pFieldValue = RowObject.auto-ct.
        WHEN "auto-est":U THEN ASSIGN pFieldValue = RowObject.auto-est.
        WHEN "baixa-estoq":U THEN ASSIGN pFieldValue = RowObject.baixa-estoq.
        WHEN "baixa-ship":U THEN ASSIGN pFieldValue = RowObject.baixa-ship.
        WHEN "calc-auto":U THEN ASSIGN pFieldValue = RowObject.calc-auto.
        WHEN "consum-final":U THEN ASSIGN pFieldValue = RowObject.consum-final.
        WHEN "credito-ciap":U THEN ASSIGN pFieldValue = RowObject.credito-ciap.
        WHEN "credito-subs":U THEN ASSIGN pFieldValue = RowObject.credito-subs.
        WHEN "emite-duplic":U THEN ASSIGN pFieldValue = RowObject.emite-duplic.
        WHEN "gera-prev-cr":U THEN ASSIGN pFieldValue = RowObject.gera-prev-cr.
        WHEN "imp-nota":U THEN ASSIGN pFieldValue = RowObject.imp-nota.
        WHEN "ind-contabilizacao":U THEN ASSIGN pFieldValue = RowObject.ind-contabilizacao.
        WHEN "ind-entfut":U THEN ASSIGN pFieldValue = RowObject.ind-entfut.
        WHEN "ind-est-crz":U THEN ASSIGN pFieldValue = RowObject.ind-est-crz.
        WHEN "ind-est-mof":U THEN ASSIGN pFieldValue = RowObject.ind-est-mof.
        WHEN "ind-est-qtd":U THEN ASSIGN pFieldValue = RowObject.ind-est-qtd.
        WHEN "ind-gera-of":U THEN ASSIGN pFieldValue = RowObject.ind-gera-of.
        WHEN "ind-imprenda":U THEN ASSIGN pFieldValue = RowObject.ind-imprenda.
        WHEN "ind-it-icms":U THEN ASSIGN pFieldValue = RowObject.ind-it-icms.
        WHEN "ind-it-sub-dif":U THEN ASSIGN pFieldValue = RowObject.ind-it-sub-dif.
        WHEN "ind-tipo-vat":U THEN ASSIGN pFieldValue = RowObject.ind-tipo-vat.
        WHEN "ipi-icm-out":U THEN ASSIGN pFieldValue = RowObject.ipi-icm-out.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "log-acum-ciap":U THEN ASSIGN pFieldValue = RowObject.log-acum-ciap.
        &IF "{&bf_dis_versao_ems}" >= "2.06" &THEN
            WHEN "log-natur-operac-draw":U THEN ASSIGN pFieldValue = RowObject.log-natur-operac-draw.
        &ENDIF
        &IF "{&bf_dis_versao_ems}" >= "2.062" &THEN
            WHEN "log-memorando":U THEN ASSIGN pFieldValue = RowObject.log-memorando.
        &ENDIF
        WHEN "log-natureza-bonif":U THEN ASSIGN pFieldValue = RowObject.log-natureza-bonif.
        WHEN "manut-icm":U THEN ASSIGN pFieldValue = RowObject.manut-icm.
        WHEN "manut-ipi":U THEN ASSIGN pFieldValue = RowObject.manut-ipi.
        WHEN "nat-ativa":U THEN ASSIGN pFieldValue = RowObject.nat-ativa.
        WHEN "nota-rateio":U THEN ASSIGN pFieldValue = RowObject.nota-rateio.
        WHEN "subs-trib":U THEN ASSIGN pFieldValue = RowObject.subs-trib.
        WHEN "terceiros":U THEN ASSIGN pFieldValue = RowObject.terceiros.
        WHEN "transf":U THEN ASSIGN pFieldValue = RowObject.transf.
        WHEN "usa-nota-ent":U THEN ASSIGN pFieldValue = RowObject.usa-nota-ent.
        WHEN "usa-pick":U THEN ASSIGN pFieldValue = RowObject.usa-pick.
        WHEN "venda-ativo":U THEN ASSIGN pFieldValue = RowObject.venda-ativo.
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
  Purpose:     Reposiciona registro com base no ¡ndice natureza
  Parameters:  
               recebe valor do campo nat-operacao
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnat-operacao LIKE natur-oper.nat-operacao NO-UNDO.

    FIND FIRST bfnatur-oper WHERE 
        bfnatur-oper.nat-operacao = pnat-operacao NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfnatur-oper THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfnatur-oper)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

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
  
  open query qr{&tableName} for each {&tableName}
       no-lock
       indexed-reposition.       
       
  return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryRangePage1 DBOProgram 
PROCEDURE openQueryRangePage1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    open query qr{&tableName} for each {&tableName}
         where {&tableName}.nat-operacao >= cIniNatOperacao
           and {&tableName}.nat-operacao <= cEndNatOperacao no-lock 
            by {&tableName}.nat-operacao.

   return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryRangePage2 DBOProgram 
PROCEDURE openQueryRangePage2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    open query qr{&tableName} for each {&tableName}
         where {&tableName}.denominacao >= cIniDenominacao
           and {&tableName}.denominacao <= cEndDenominacao no-lock 
            by {&tableName}.denominacao
            indexed-reposition.

   return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintMain DBOProgram 
PROCEDURE setConstraintMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintRangePage1 DBOProgram 
PROCEDURE setConstraintRangePage1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param pcIniNatOperacao as char no-undo.
def input param pcEndNatOperacao as char no-undo.

    assign cIniNatOperacao = pcIniNatOperacao
           cEndNatOperacao = pcEndNatOperacao.          

   return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintRangePage2 DBOProgram 
PROCEDURE setConstraintRangePage2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param pcIniDenominacao as char no-undo.
def input param pcEndDenominacao as char no-undo.

    assign cIniDenominacao = pcIniDenominacao
           cEndDenominacao = pcEndDenominacao.
           

   return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateDeleteFrotas DBOProgram 
PROCEDURE validateDeleteFrotas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define variable h-abapi008 as handle  no-undo.
define variable iErro      as integer no-undo.
define variable i-cont     as integer no-undo.

run cdp/cd9902.p (input 2).
if return-value = "OK":U then do:
    /** Passa o rowid para API de Frotas **/
    run abp/abapi008.p persistent set h-abapi008 (input RowObject.r-rowid).
    /** Valida‡äes de Frotas **/
    run validateNaturezaOperacao in h-abapi008 (input RowObject.nat-operacao).
    if return-value = "NOK":U then do:
        empty temp-table RowErrorsFrotas.
        /** Busca os erros ocorridos em frotas **/
        run getRowErrors in h-abapi008 (output table RowErrorsFrotas).
        assign iErro = 0.
        /** Se ocorreram erros noproduto padrÆo, busca a £ltima sequˆncia **/
        for last RowErrors no-lock:
            assign iErro = RowErrors.ErrorSequence.
        end.
        /** Percorre os erros ocorridos em frotas **/
        for each RowErrorsFrotas no-lock:
            /** Cria os erros no produto padrÆo **/
            create RowErrors.
            buffer-copy RowErrorsFrotas except ErrorSequence to RowErrors
                assign RowErrors.ErrorSequence = iErro + 1
                       iErro                   = RowErrors.ErrorSequence.
        end.
        empty temp-table RowErrorsFrotas.
    end.
    /** Elimina a API da mem¢ria **/
    if valid-handle(h-abapi008) then
        delete procedure h-abapi008.
end.

return "OK":U.
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

    if pType = "Delete":U then
        run validateDeleteFrotas in this-procedure.
    
    /*--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaNaturezaDrawback DBOProgram 
PROCEDURE verificaNaturezaDrawback :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  def input parameter pnat-operacao as char no-undo.
  
  find natur-oper no-lock where 
    natur-oper.nat-operacao = pnat-operacao no-error.
  
  if avail natur-oper then do:
    if natur-oper.terceiros and natur-oper.tp-oper-terc = 7 then 
      RETURN "OK".
    else RETURN "NOK".
  end.
  
  RETURN "NOK".
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

