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
{include/i-prgvrs.i BOIN582 2.00.00.018 } /*** "010018" 24/11/2023 13:25:24  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i boin582 MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : 
    Purpose    : O DBO (Datasul Business Objects) ≤ um programa PROGRESS
                 que cont≤m a lΩgica de negΩcio e acesso a dados para uma
                 tabela do banco de dados.

    Parameters :

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de definiªío ---*/
&GLOBAL-DEFINE DBOName item-contrat
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName item-contrat
&GLOBAL-DEFINE TableLabel item-contrat
&GLOBAL-DEFINE QueryName qr{&TableName}

&GLOBAL-DEFINE KeyField1 nr-contrato /*:T Informar os campos da chave quando o Progress n∆o conseguir resolver find {&TableName} OF RowObject. */
&GLOBAL-DEFINE KeyField2 num-seq-item /*:T Informar os campos da chave quando o Progress n∆o conseguir resolver find {&TableName} OF RowObject. */
&GLOBAL-DEFINE XMLProducer YES    /*:T DBO atua como producer de mensagens para o Message Broker */
&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (mÇtodo Receive Message) */
&GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES 

/*--- Include com definiªío da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diretΩrio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idºntico ao nome do DBO mas com
      extensío .i ---*/
{inbo/boin582.i RowObject}

/*--- Include com definiªío da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraªío da definiªío da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiªío
      manual da query ---*/
{method/dboqry.i}

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

{cdp/cdcfgmat.i} /* Include uso de pre-processadores */

/* Definiá‰es das vari†veis necess†rias ao setConstraint2 */
&if defined(bf_mat_contratos) &then
  def var inr-contrato-ini  as int no-undo.
  def var inr-contrato-fim  as int no-undo.
&else
  def var cnr-contrato-ini  as char no-undo.
  def var cnr-contrato-fim  as char no-undo.
&endif
def var inum-seq-item-ini as int no-undo.
def var inum-seq-item-fim as int no-undo.

DEFINE TEMP-TABLE RowObjectExtra 
    FIELD nome-abrev LIKE emitente.nome-abrev
    FIELD desc-item  LIKE item.desc-item
    FIELD r-Rowid AS ROWID.

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
         HEIGHT             = 5.52
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



/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCopyBuffer2TT DBOProgram 
PROCEDURE afterCopyBuffer2TT :
/*------------------------------------------------------------------------------
  Purpose:     Copia informaá‰es extras para a RowObjectExtra
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    CREATE RowObjectExtra.
    ASSIGN RowObjectExtra.r-Rowid = ROWID({&TableName}).

    FOR FIRST emitente FIELDS(cod-emitente nome-abrev) NO-LOCK
        WHERE emitente.cod-emitente = {&TableName}.cod-emitente:
        ASSIGN RowObjectExtra.nome-abrev = emitente.nome-abrev.
    END.

    FOR FIRST item FIELDS(it-codigo desc-item) NO-LOCK
        WHERE item.it-codigo = {&TableName}.it-codigo:
        ASSIGN RowObjectExtra.desc-item = item.desc-item.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findItem_codigo DBOProgram 
PROCEDURE findItem_codigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
   */
    def input parameter  pcit-codigo as char no-undo.
    def input parameter  pcnr-contrato as char no-undo.
    def input parameter  pinum-seq-item as inte no-undo.
    def input parameter  pcnarrat-compra as char no-undo.
    def output parameter pcreturn as char no-undo.
  
    RUN openQueryStatic (input "main":U).  

    run goToKey (pcnr-contrato, pinum-seq-item).
      
      if return-value = "OK" then assign pcreturn = "".  /* esse Ç o valor esperado nas interfaces 1.1 */
        if return-value = "NOK" then do:
          {utp/ut-table.i mgind {&TABLENAME} 1}
        run utp/ut-msgs.p (input "msg",
                           input 2,
                           input return-value).
        assign pcreturn = return-value.
    end.

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

    /*--- Verifica se temptable RowObject estˇ dispon≠vel, caso nío esteja serˇ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "un":U THEN ASSIGN pFieldValue = RowObject.un.
        WHEN "nr-tab":U THEN ASSIGN pFieldValue = RowObject.nr-tab.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-comprado":U THEN ASSIGN pFieldValue = RowObject.cod-comprado.
        WHEN "cod-depos":U THEN ASSIGN pFieldValue = RowObject.cod-depos.
        WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
        WHEN "contato":U THEN ASSIGN pFieldValue = RowObject.contato.
        &IF "{&mguni_version}" >= "2.071" &THEN
            WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
        &ENDIF
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "narrat-compra":U THEN ASSIGN pFieldValue = RowObject.narrat-compra.
        WHEN "narrat-item":U THEN ASSIGN pFieldValue = RowObject.narrat-item.
        &if defined(bf_mat_contratos) &then
        &else WHEN "nr-contrato":U THEN ASSIGN pFieldValue = RowObject.nr-contrato.
        &endif
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

    /*--- Verifica se temptable RowObject estˇ dispon≠vel, caso nío esteja serˇ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dat-base":U THEN ASSIGN pFieldValue = RowObject.dat-base.
        WHEN "dat-cotac":U THEN ASSIGN pFieldValue = RowObject.dat-cotac.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.

    /*--- Verifica se temptable RowObject estˇ dispon≠vel, caso nío esteja serˇ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "sld-qtd-liber":U THEN ASSIGN pFieldValue = RowObject.sld-qtd-liber.
        WHEN "sld-qtd-receb":U THEN ASSIGN pFieldValue = RowObject.sld-qtd-receb.
        WHEN "sld-val":U THEN ASSIGN pFieldValue = RowObject.sld-val.
        WHEN "sld-val-liber":U THEN ASSIGN pFieldValue = RowObject.sld-val-liber.
        WHEN "sld-val-receb":U THEN ASSIGN pFieldValue = RowObject.sld-val-receb.
        WHEN "val-fatur-minimo":U THEN ASSIGN pFieldValue = RowObject.val-fatur-minimo.
        WHEN "val-frete":U THEN ASSIGN pFieldValue = RowObject.val-frete.
        WHEN "val-taxa":U THEN ASSIGN pFieldValue = RowObject.val-taxa.
        WHEN "val-total":U THEN ASSIGN pFieldValue = RowObject.val-total.
        WHEN "valor-descto":U THEN ASSIGN pFieldValue = RowObject.valor-descto.
        WHEN "perc-desconto":U THEN ASSIGN pFieldValue = RowObject.perc-desconto.
        WHEN "perc-multa-dia":U THEN ASSIGN pFieldValue = RowObject.perc-multa-dia.
        WHEN "perc-multa-limite":U THEN ASSIGN pFieldValue = RowObject.perc-multa-limite.
        WHEN "acum-rec-qtd":U THEN ASSIGN pFieldValue = RowObject.acum-rec-qtd.
        WHEN "acum-rec-val":U THEN ASSIGN pFieldValue = RowObject.acum-rec-val.
        WHEN "aliquota-icm":U THEN ASSIGN pFieldValue = RowObject.aliquota-icm.
        WHEN "aliquota-ipi":U THEN ASSIGN pFieldValue = RowObject.aliquota-ipi.
        WHEN "aliquota-iss":U THEN ASSIGN pFieldValue = RowObject.aliquota-iss.
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "pre-unit-for":U THEN ASSIGN pFieldValue = RowObject.pre-unit-for.
        WHEN "preco-base":U THEN ASSIGN pFieldValue = RowObject.preco-base.
        WHEN "preco-fornec":U THEN ASSIGN pFieldValue = RowObject.preco-fornec.
        WHEN "preco-unit":U THEN ASSIGN pFieldValue = RowObject.preco-unit.
        WHEN "qtd-minima":U THEN ASSIGN pFieldValue = RowObject.qtd-minima.
        WHEN "qtd-total":U THEN ASSIGN pFieldValue = RowObject.qtd-total.
        WHEN "sld-qtd":U THEN ASSIGN pFieldValue = RowObject.sld-qtd.
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

    /*--- Verifica se temptable RowObject estˇ dispon≠vel, caso nío esteja serˇ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "tp-despesa":U THEN ASSIGN pFieldValue = RowObject.tp-despesa.
        WHEN "num-seq-item":U THEN ASSIGN pFieldValue = RowObject.num-seq-item.
        WHEN "ordem-base":U THEN ASSIGN pFieldValue = RowObject.ordem-base.
        WHEN "prazo-ent":U THEN ASSIGN pFieldValue = RowObject.prazo-ent.
        WHEN "cod-cond-pag":U THEN ASSIGN pFieldValue = RowObject.cod-cond-pag.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "codigo-icm":U THEN ASSIGN pFieldValue = RowObject.codigo-icm.
        &IF "{&mguni_version}" < "2.071" &THEN
            WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
        &ENDIF
        WHEN "frequencia":U THEN ASSIGN pFieldValue = RowObject.frequencia.
        WHEN "mo-codigo":U THEN ASSIGN pFieldValue = RowObject.mo-codigo.
        WHEN "nr-dias-taxa":U THEN ASSIGN pFieldValue = RowObject.nr-dias-taxa.
        WHEN "ind-caract-item":U THEN ASSIGN pFieldValue = RowObject.ind-caract-item.
        WHEN "ind-sit-item":U THEN ASSIGN pFieldValue = RowObject.ind-sit-item.
        WHEN "ind-tipo-control":U THEN ASSIGN pFieldValue = RowObject.ind-tipo-control.
        WHEN "ind-tipo-control-val":U THEN ASSIGN pFieldValue = RowObject.ind-tipo-control-val.
        WHEN "ind-un-contrato":U THEN ASSIGN pFieldValue = RowObject.ind-un-contrato.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        &if defined(bf_mat_contratos) &then
          WHEN "nr-contrato":U THEN ASSIGN pFieldValue = RowObject.nr-contrato.
        &endif
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ≠ndice ITEM-CONTRAT
  Parameters:
               retorna valor dos campos do ≠ndice ITEM-CONTRAT
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnr-contrato LIKE item-contrat.nr-contrato NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-seq-item LIKE item-contrat.num-seq-item NO-UNDO.

    /*--- Verifica se temptable RowObject estˇ dispon≠vel, caso nío esteja serˇ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pnr-contrato = RowObject.nr-contrato.
    ASSIGN pnum-seq-item = RowObject.num-seq-item.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogField DBOProgram 
PROCEDURE getLogField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo lΩgico
  Parameters:
               recebe nome do campo
               retorna valor do campo
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject estˇ dispon≠vel, caso nío esteja serˇ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "taxa-financ":U THEN ASSIGN pFieldValue = RowObject.taxa-financ.
        WHEN "codigo-ipi":U THEN ASSIGN pFieldValue = RowObject.codigo-ipi.
        WHEN "frete":U THEN ASSIGN pFieldValue = RowObject.frete.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "log-control-event":U THEN ASSIGN pFieldValue = RowObject.log-control-event.
        WHEN "log-ind-multa":U THEN ASSIGN pFieldValue = RowObject.log-ind-multa.
        WHEN "log-libera":U THEN ASSIGN pFieldValue = RowObject.log-libera.
        WHEN "log-obrig-item":U THEN ASSIGN pFieldValue = RowObject.log-obrig-item.
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

    /*--- Verifica se temptable RowObject estˇ dispon≠vel, caso nío esteja serˇ
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRowObjectExtra DBOProgram 
PROCEDURE getRowObjectExtra :
/*------------------------------------------------------------------------------
  Purpose:     Retorna a temp-table RowObjectExtra
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER TABLE FOR RowObjectExtra.
                  
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ≠ndice ITEM-CONTRAT
  Parameters:
               recebe valor dos campos do ≠ndice ITEM-CONTRAT
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-contrato LIKE item-contrat.nr-contrato NO-UNDO.
    DEFINE INPUT PARAMETER pnum-seq-item LIKE item-contrat.num-seq-item NO-UNDO.

    FIND FIRST bfitem-contrat WHERE
        bfitem-contrat.nr-contrato = pnr-contrato AND
        bfitem-contrat.num-seq-item = pnum-seq-item
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro serˇ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfitem-contrat THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav≤s de rowid e verifica a ocorrºncia de erros, caso
          existam erros serˇ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfitem-contrat)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKeyItem DBOProgram 
PROCEDURE goToKeyItem :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no contrato e item
  Parameters:  pnr-contrato: N£mero do contrato
               pit-codigo: C¢digo do item 
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pit-codigo LIKE item-contrat.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pnr-contrato LIKE item-contrat.nr-contrato NO-UNDO.

    FIND FIRST bfitem-contrat WHERE
        bfitem-contrat.nr-contrato = pnr-contrato AND
        bfitem-contrat.it-codigo = pit-codigo
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro serˇ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfitem-contrat THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav≤s de rowid e verifica a ocorrºncia de erros, caso
          existam erros serˇ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfitem-contrat)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKeyItem DBOProgram 
PROCEDURE goToKeyItemBranco :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no contrato e item branco
  Parameters:  pnr-contrato: N£mero do contrato
  Notes: ESTE MêTODO ê NECESSµRIO PARA O ZOOM HTML, POIS QUANDO O ITEM ê BRANCO O 
         ZOOM ENTENDE QUE O VALOR ê NULO E N«O ATRIBUI O ITEM NA REQUISIÄ«O REST 
         CAUSANDO ERRO AO UTILIZAR O GOTOKEYITEM. 
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-contrato LIKE item-contrat.nr-contrato NO-UNDO.

    FIND FIRST bfitem-contrat WHERE
        bfitem-contrat.nr-contrato = pnr-contrato AND
        bfitem-contrat.it-codigo = ""
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro serˇ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfitem-contrat THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav≤s de rowid e verifica a ocorrºncia de erros, caso
          existam erros serˇ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfitem-contrat)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuery DBOProgram 
PROCEDURE openQuery :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then 
           run openQueryStatic ("Main").
        when 2 then
           run openQueryStatic ("ByNrContrato").   
        when 3 then
           run openQueryStatic ("ByNumSeqItem").
        end. /*end case*/
   RETURN "OK":U.        

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByNrContrato DBOProgram 
PROCEDURE openQueryByNrContrato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  open query {&QUERYNAME} for each {&TABLENAME} where
         &if defined(bf_mat_contratos) &then
             {&TABLENAME}.nr-contrato >= inr-contrato-ini AND 
             {&TABLENAME}.nr-contrato <= inr-contrato-fim
         &else
             {&TABLENAME}.nr-contrato >= cnr-contrato-ini AND 
             {&TABLENAME}.nr-contrato <= cnr-contrato-fim
         &endif
         AND {&TABLENAME}.num-seq-item >= inum-seq-item-ini AND
             {&TABLENAME}.num-seq-item <= inum-seq-item-fim 
             NO-LOCK BY nr-contrato &if "{&dbtype}" <> "oracle" &THEN 
                                          INDEXED-REPOSITION 
                                    &ENDIF.
  return "OK":U.   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByNumSeqItem DBOProgram 
PROCEDURE openQueryByNumSeqItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
 open query {&QUERYNAME} for each {&TABLENAME} where
         &if defined(bf_mat_contratos) &then
             {&TABLENAME}.nr-contrato >= inr-contrato-ini AND 
             {&TABLENAME}.nr-contrato <= inr-contrato-fim
         &else
             {&TABLENAME}.nr-contrato >= cnr-contrato-ini AND 
             {&TABLENAME}.nr-contrato <= cnr-contrato-fim
         &endif
         AND {&TABLENAME}.num-seq-item >= inum-seq-item-ini AND
             {&TABLENAME}.num-seq-item <= inum-seq-item-fim 
             NO-LOCK BY num-seq-item &if "{&dbtype}" <> "oracle" &THEN 
                                        INDEXED-REPOSITION 
                                     &ENDIF.
 End Procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH item-contrat NO-LOCK &if "{&dbtype}" <> "oracle" &THEN 
                                                                INDEXED-REPOSITION 
                                                          &ENDIF.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaIndTipoControl DBOProgram 
PROCEDURE retornaIndTipoControl :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 /*
    **  Retorna ind-tipo-control(Tipo de Controle do Item do Contrato
    **    : 1 - por Mediá∆o 2 - por Ordem) do item-contrat
    */
    def input  parameter pcnr-contrato      as char.
    def input  parameter pcnum-seq-item     as int.
    def output parameter pcind-tipo-control as char.

    run gotokey (input pcnr-contrato, pcnum-seq-item).

    if return-value = "OK":U then
      assign pcind-tipo-control = entry(item-contrat.ind-tipo-control,{ininc/i04in582.i 03}).
    else  
      assign pcind-tipo-control = entry(1,{ininc/i04in582.i 03}).
   return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint2 DBOProgram 
PROCEDURE setConstraint2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param pcnr-contrato-ini  as char no-undo.
  def input param pcnr-contrato-fim  as char no-undo.
  def input param pcnum-seq-item-ini as char no-undo.
  def input param pcnum-seq-item-fim as char no-undo.

   
       run setConstraintNrContrato(input pcnr-contrato-ini,
                                          pcnr-contrato-fim, 
                                          pcnum-seq-item-ini,
                                          pcnum-seq-item-fim ).
   
 return "OK":U.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintNrContrato DBOProgram 
PROCEDURE setConstraintNrContrato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*Recebe valores iniciais e finais do n£mero de contrato e da 
 * sequància de itens do contrato.E atravÇs do prÇ-processor 
 * (bf_mat_contratos), buscando a relese do banco, atualizando os campos
 *
 *  ParÉmetros:
 *    ipar1  : pcnr-contrato-ini : N£mero do Contrato inicial
 *    ipar2  : pcnr-contrato-fim : N£mero do Contrato final
 *    ipar3  : pcnum-seq-item-ini: N£mero inicial da sequància de itens do cantrato
 *    ipar4  : pcnum-seq-item-fim: N£mero final da sequància de itens do cantrato
*/
     
def input param pcnr-contrato-ini  as char no-undo.
def input param pcnr-contrato-fim  as char no-undo.
def input param pcnum-seq-item-ini as char no-undo.
def input param pcnum-seq-item-fim as char no-undo.

  assign &if defined(bf_mat_contratos) &then
           inr-contrato-ini  = int(pcnr-contrato-ini)
            inr-contrato-fim  = int(pcnr-contrato-fim)
         &else
           cnr-contrato-ini  = pcnr-contrato-ini 
            cnr-contrato-fim  = pcnr-contrato-fim 
         &endif
         inum-seq-item-ini = int(pcnum-seq-item-ini)
         inum-seq-item-fim = int(pcnum-seq-item-fim). 
         
  return "OK":U.         
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Valida temptable RowObject
  Parameters:  recebe o tipo de validaªío (Create, Delete, Update)
  Notes:
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    /*--- Utilize o par≥metro pType para identificar quais as validaªÑes a serem
          executadas ---*/
    /*--- Os valores poss≠veis para o par≥metro sío: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atrav≤s do
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as validaªÑes ---*/

    /*--- Verifica ocorrºncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDefault DBOProgram  
PROCEDURE openQueryDefault :
    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} NO-LOCK INDEXED-REPOSITION.
                                      
    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
