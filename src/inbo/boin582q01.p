&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/*:T--------------------------------------------------------------------------
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

/*:T--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName BOIN582
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName item-contrat
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

/* DBO-XML-BEGIN */
/*:T Pre-processadores para ativar XML no DBO */
/*:T Retirar o comentario para ativar 
&GLOBAL-DEFINE XMLProducer YES    /*:T DBO atua como producer de mensagens para o Message Broker */
&GLOBAL-DEFINE XMLTopic           /*:T Topico da Mensagem enviada ao Message Broker, geralmente o nome da tabela */
&GLOBAL-DEFINE XMLTableName       /*:T Nome da tabela que deve ser usado como TAG no XML */ 
&GLOBAL-DEFINE XMLTableNameMult   /*:T Nome da tabela no plural. Usado para multiplos registros */ 
&GLOBAL-DEFINE XMLPublicFields    /*:T Lista dos campos (c1,c2) que podem ser enviados via XML. Ficam fora da listas os campos de especializacao da tabela */ 
&GLOBAL-DEFINE XMLKeyFields       /*:T Lista dos campos chave da tabela (c1,c2) */
&GLOBAL-DEFINE XMLExcludeFields   /*:T Lista de campos a serem excluidos do XML quando PublicFields = "" */

&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (m‚todo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /*:T Nome da Query que d  acessos a todos os registros, exceto os exclu¡dos pela constraint de seguran‡a. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /*:T Informar os campos da chave quando o Progress nÆo conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

/*:T--- Include com defini‡Æo da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com 
      extensÆo .i ---*/
{inbo/boin582q01.i RowObject}


/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/*TECNICA SEGURANCA ESTABELECIMENTO */
&scoped-define TTONLY YES
{include/i-estab-security.i}

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
   Other Settings: CODE-ONLY COMPILE
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
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-comprado":U THEN ASSIGN pFieldValue = RowObject.cod-comprado.
        WHEN "cod-depos":U THEN ASSIGN pFieldValue = RowObject.cod-depos.
        WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
        WHEN "contato":U THEN ASSIGN pFieldValue = RowObject.contato.
        WHEN "des-referencia":U THEN ASSIGN pFieldValue = RowObject.des-referencia.
        WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "narrat-compra":U THEN ASSIGN pFieldValue = RowObject.narrat-compra.
        WHEN "narrat-item":U THEN ASSIGN pFieldValue = RowObject.narrat-item.
        WHEN "nr-tab":U THEN ASSIGN pFieldValue = RowObject.nr-tab.
        WHEN "un":U THEN ASSIGN pFieldValue = RowObject.un.
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
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "acum-rec-qtd":U THEN ASSIGN pFieldValue = RowObject.acum-rec-qtd.
        WHEN "acum-rec-val":U THEN ASSIGN pFieldValue = RowObject.acum-rec-val.
        WHEN "aliquota-icm":U THEN ASSIGN pFieldValue = RowObject.aliquota-icm.
        WHEN "aliquota-ipi":U THEN ASSIGN pFieldValue = RowObject.aliquota-ipi.
        WHEN "aliquota-iss":U THEN ASSIGN pFieldValue = RowObject.aliquota-iss.
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "perc-desconto":U THEN ASSIGN pFieldValue = RowObject.perc-desconto.
        WHEN "perc-multa-dia":U THEN ASSIGN pFieldValue = RowObject.perc-multa-dia.
        WHEN "perc-multa-limite":U THEN ASSIGN pFieldValue = RowObject.perc-multa-limite.
        WHEN "pre-unit-for":U THEN ASSIGN pFieldValue = RowObject.pre-unit-for.
        WHEN "preco-base":U THEN ASSIGN pFieldValue = RowObject.preco-base.
        WHEN "preco-fornec":U THEN ASSIGN pFieldValue = RowObject.preco-fornec.
        WHEN "preco-unit":U THEN ASSIGN pFieldValue = RowObject.preco-unit.
        WHEN "qtd-minima":U THEN ASSIGN pFieldValue = RowObject.qtd-minima.
        WHEN "qtd-total":U THEN ASSIGN pFieldValue = RowObject.qtd-total.
        WHEN "sld-qtd":U THEN ASSIGN pFieldValue = RowObject.sld-qtd.
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
        WHEN "cdn-fabrican":U THEN ASSIGN pFieldValue = RowObject.cdn-fabrican.
        WHEN "cod-cond-pag":U THEN ASSIGN pFieldValue = RowObject.cod-cond-pag.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "codigo-icm":U THEN ASSIGN pFieldValue = RowObject.codigo-icm.
        WHEN "frequencia":U THEN ASSIGN pFieldValue = RowObject.frequencia.
        WHEN "ind-caract-item":U THEN ASSIGN pFieldValue = RowObject.ind-caract-item.
        WHEN "ind-sit-item":U THEN ASSIGN pFieldValue = RowObject.ind-sit-item.
        WHEN "ind-tipo-control":U THEN ASSIGN pFieldValue = RowObject.ind-tipo-control.
        WHEN "ind-tipo-control-val":U THEN ASSIGN pFieldValue = RowObject.ind-tipo-control-val.
        WHEN "ind-un-contrato":U THEN ASSIGN pFieldValue = RowObject.ind-un-contrato.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "mo-codigo":U THEN ASSIGN pFieldValue = RowObject.mo-codigo.
        WHEN "nr-contrato":U THEN ASSIGN pFieldValue = RowObject.nr-contrato.
        WHEN "nr-dias-taxa":U THEN ASSIGN pFieldValue = RowObject.nr-dias-taxa.
        WHEN "num-ord-inv":U THEN ASSIGN pFieldValue = RowObject.num-ord-inv.
        WHEN "num-ord-invest":U THEN ASSIGN pFieldValue = RowObject.num-ord-invest.
        WHEN "num-seq-item":U THEN ASSIGN pFieldValue = RowObject.num-seq-item.
        WHEN "ordem-base":U THEN ASSIGN pFieldValue = RowObject.ordem-base.
        WHEN "prazo-ent":U THEN ASSIGN pFieldValue = RowObject.prazo-ent.
        WHEN "tp-despesa":U THEN ASSIGN pFieldValue = RowObject.tp-despesa.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice item-contrat
  Parameters:  
               retorna valor do campo nr-contrato
               retorna valor do campo num-seq-item
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnr-contrato LIKE item-contrat.nr-contrato NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-seq-item LIKE item-contrat.num-seq-item NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnr-contrato = RowObject.nr-contrato
           pnum-seq-item = RowObject.num-seq-item.

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
        WHEN "codigo-ipi":U THEN ASSIGN pFieldValue = RowObject.codigo-ipi.
        WHEN "frete":U THEN ASSIGN pFieldValue = RowObject.frete.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "log-control-event":U THEN ASSIGN pFieldValue = RowObject.log-control-event.
        WHEN "log-ind-multa":U THEN ASSIGN pFieldValue = RowObject.log-ind-multa.
        WHEN "log-libera":U THEN ASSIGN pFieldValue = RowObject.log-libera.
        WHEN "log-obrig-item":U THEN ASSIGN pFieldValue = RowObject.log-obrig-item.
        WHEN "taxa-financ":U THEN ASSIGN pFieldValue = RowObject.taxa-financ.
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
  Purpose:     Reposiciona registro com base no ¡ndice item-contrat
  Parameters:  
               recebe valor do campo nr-contrato
               recebe valor do campo num-seq-item
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-contrato LIKE item-contrat.nr-contrato NO-UNDO.
    DEFINE INPUT PARAMETER pnum-seq-item LIKE item-contrat.num-seq-item NO-UNDO.

    FIND FIRST bfitem-contrat WHERE 
        bfitem-contrat.nr-contrato = pnr-contrato AND 
        bfitem-contrat.num-seq-item = pnum-seq-item NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfitem-contrat THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfitem-contrat)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Valida‡äes pertinentes ao DBO
  Parameters:  recebe o tipo de valida‡Æo (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    DEFINE VARIABLE i-empresa           LIKE empresa.ep-codigo NO-UNDO.
    DEFINE VARIABLE c-lbl-liter         AS character NO-UNDO.
    DEFINE VARIABLE c-limite-msg        AS CHARACTER NO-UNDO.
    DEFINE VARIABLE l-aprov-contr       AS LOGICAL NO-UNDO.
    DEFINE VARIABLE l-aprov-med         AS LOGICAL NO-UNDO.
    DEFINE VARIABLE l-erro              as logical no-undo.
    DEFINE VARIABLE h-mlaapi018         AS HANDLE NO-UNDO.
    DEFINE VARIABLE i-sld-qtd           AS DECIMAL NO-UNDO.  
    DEFINE VARIABLE i-sld-val           LIKE item-contrat.sld-val NO-UNDO.
    DEFINE VARIABLE de-qtd-tot          LIKE item-contrat.qtd-total NO-UNDO.
    DEFINE VARIABLE de-val-tot          LIKE item-contrat.val-total NO-UNDO.
    DEFINE VARIABLE de-qtd-movto        AS DECIMAL NO-UNDO.
    DEFINE VARIABLE l-nao-valida-limite AS LOGICAL NO-UNDO.
    DEFINE VARIABLE l-limite-valido     AS LOGICAL NO-UNDO.
    DEFINE VARIABLE c-lim-valor         AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-valor             AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-lim-qtd           AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-qtd               AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-lbl-deposito      AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-lbl-nao-cad-estab AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-estabel           AS CHARACTER NO-UNDO.
    
    define buffer b-contrato-for for contrato-for.
    define buffer b-item-contrat for item-contrat.
    define buffer b-pedido-compr for pedido-compr.
    
    /*:T--- Utilize o parƒmetro pType para identificar quais as valida‡äes a serem
          executadas ---*/
    /*:T--- Os valores poss¡veis para o parƒmetro sÆo: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as valida‡äes ---*/

    {utp/ut-liter.i Limite_Valor}
    ASSIGN c-lim-valor = TRIM(RETURN-VALUE).
    {utp/ut-liter.i Valor}
    ASSIGN c-valor = TRIM(RETURN-VALUE).
    {utp/ut-liter.i Limite_Quantidade}
    ASSIGN c-lim-qtd = TRIM(RETURN-VALUE).
    {utp/ut-liter.i Quantidade}
    ASSIGN c-qtd = TRIM(RETURN-VALUE).

    ASSIGN l-nao-valida-limite = CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-nao-valida-limite-it-cont":U AND funcao.ativo).
    
    FIND FIRST param-contrat NO-LOCK NO-ERROR.
    IF  AVAIL param-contrat THEN DO:
        IF  rowObject.it-codigo = param-contrat.it-codigo THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="8353"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U}
            RETURN "NOK":U.
        END.
    END.

    /* Validacao: Numero Contrato */
    find first contrato-for no-lock
        where contrato-for.nr-contrato = rowObject.nr-contrato no-error.
    if not avail contrato-for then do:
        {utp/ut-liter.i "Contrato" *}
        ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i &ErrorNumber="2"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U
                                    &ErrorParameters="c-lbl-liter"}
        RETURN "NOK":U.
    END.

    /* Validacao: Sequencia Item */
    IF rowObject.num-seq-item = ? OR rowObject.num-seq-item = 0 THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="25483"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U}
        RETURN "NOK":U.
    END.

    /* Validacao: Item */
   IF l-estab-security-active = TRUE THEN DO:

        FOR FIRST item NO-LOCK
            WHERE item.it-codigo = rowObject.it-codigo,
            FIRST {&ESTAB-SEC-TT} NO-LOCK
            WHERE {&ESTAB-SEC-TT-FIELD} = contrato-for.cod-estabel:
        END.

        IF NOT AVAIL {&ESTAB-SEC-TT} THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="166"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U}
            RETURN "NOK":U.
        END.
    END.
    ELSE     
        find first item no-lock
            where item.it-codigo = rowObject.it-codigo no-error.

    if  not avail item then do:
        {method/svc/errors/inserr.i &ErrorNumber="166"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U}
        RETURN "NOK":U.
    END.

    IF pType = "create":U THEN DO:

        IF  item.cod-obsoleto = 4 /* Totalmente Obsoleto */ THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="17472"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U}
        END.

        IF rowObject.it-codigo = "" 
        OR (item.tipo-contr = 4 AND
            NOT CAN-FIND (FIRST item-fornec 
                          WHERE item-fornec.it-codigo    = item.it-codigo
                          AND   item-fornec.cod-emitente = contrato-for.cod-emitente
                          AND   item-fornec.ativo) )
        then.
        ELSE DO:
            FIND FIRST b-item-contrat
                 WHERE b-item-contrat.it-codigo     = rowObject.it-codigo
                   AND b-item-contrat.nr-contrato   = rowObject.nr-contrato
                   AND b-item-contrat.ind-sit-item <> 3
                   AND b-item-contrat.ind-sit-item <> 4 NO-LOCK NO-ERROR.
            IF  AVAIL b-item-contrat THEN DO:
                {utp/ut-field.i mgind item-contrat it-codigo 1}
                assign c-lbl-liter = trim(return-value).
                {method/svc/errors/inserr.i &ErrorNumber="1"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U
                                            &ErrorParameters="c-lbl-liter"}
                RETURN "NOK":U.
            END.
            
            ASSIGN c-valor = "".
            FOR EACH b-item-contrat 
               WHERE b-item-contrat.it-codigo = rowObject.it-codigo
                 AND b-item-contrat.ind-tipo-control <> 1 
                 AND b-item-contrat.ind-sit-item     <> 3
                 AND b-item-contrat.ind-sit-item     <> 4 NO-LOCK:

                FIND FIRST b-contrato-for
                     WHERE b-contrato-for.nr-contrato      = b-item-contrat.nr-contrato
                       AND b-contrato-for.cod-emitente     = contrato-for.cod-emitente
                       AND b-contrato-for.dt-ini-validade <= contrato-for.dt-ter-validade
                       AND b-contrato-for.dt-ter-validade >= contrato-for.dt-ini-validade
                       AND b-contrato-for.log-libera NO-LOCK NO-ERROR.
                IF  AVAIL b-contrato-for THEN DO:
                    ASSIGN l-erro = NO.

                    FOR EACH b-pedido-compr FIELD (nr-contrat end-entrega)
                        WHERE b-pedido-compr.nr-contrat = contrato-for.nr-contrato NO-LOCK:

                        IF CAN-FIND (FIRST pedido-compr
                                     WHERE pedido-compr.end-entrega = b-pedido-compr.end-entrega
                                       AND pedido-compr.nr-contrato = b-contrato-for.nr-contrato) THEN DO:
                            
                            ASSIGN l-erro  = YES
                                   c-valor = string(b-contrato-for.nr-contrato).
                            LEAVE.
                        end.
                    END.
                    
                    IF  l-erro THEN DO:
                        RUN utp\ut-msgs(INPUT 'msg', INPUT 15548, INPUT "").
                        ASSIGN c-lbl-liter = RETURN-VALUE.
                        RUN utp\ut-msgs(INPUT 'help', INPUT 15548, INPUT "").
                        ASSIGN c-lbl-liter = TRIM(c-lbl-liter) + '~~' + TRIM(RETURN-VALUE) + ' (Contrato: ' + TRIM(c-valor) + ')'.
                        
                        {method/svc/errors/inserr.i &ErrorNumber="25997"
                                                    &ErrorType="EMS":U
                                                    &ErrorSubType="ERROR":U
                                                    &ErrorParameters="c-lbl-liter"}
                        RETURN "NOK":U.
                    END.
                END.
            END.
        END.
    end.
    
    /* Valida‡Æo: Pedido de Compra */
    FIND FIRST pedido-compr NO-LOCK 
        WHERE pedido-compr.nr-contrato = contrato-for.nr-contrato NO-ERROR.
    IF  NOT AVAIL pedido-compr THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="8350"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U}
    END.
    
    IF  item.tipo-contr = 2 /* Total */
    and contrato-for.ind-control-rec = 1 THEN DO: /* Total Nota */
        {method/svc/errors/inserr.i &ErrorNumber="8351"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U}
    END.

    if  item.it-codigo = "" then do:
        /* Contrato com Programacao de Entrega nao aceita item "" BRANCO. */
        if rowObject.ind-tipo-control = 3 then do:
            {method/svc/errors/inserr.i &ErrorNumber="16628"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U}
        end.
    end.
    if  item.tipo-contr <> 4 
    and rowObject.ind-tipo-control = 1 then do:
        {method/svc/errors/inserr.i &ErrorNumber="26834"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U}
    end.

    if  item.tipo-contr = 4 then do:
        if  contrato-for.ind-control-rec = 1
        and rowObject.ind-tipo-control-val = 1 then do:
            {method/svc/errors/inserr.i &ErrorNumber="8349"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U}
        end.
    end.

    if  contrato-for.ind-control-rec  = 1 /* total da nota */
    and rowObject.ind-tipo-control = 2 then do: /* por ordem */
        {method/svc/errors/inserr.i &ErrorNumber="28136"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U}
    end.

    if  contrato-for.ind-control-rec = 1
    and rowObject.ind-tipo-control = 3 then do:
        {method/svc/errors/inserr.i &ErrorNumber="15008"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U}
    end.
        
    /* Valida‡Æo: Frequˆncia */
    FIND FIRST frequencia
         WHERE frequencia.cd-freq = rowObject.frequencia NO-LOCK NO-ERROR.        
    IF  NOT AVAIL frequencia THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="6070"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U}
    END.

    /* Validacao: Narrativa Compra */
    IF rowObject.narrat-compra = ? OR TRIM(rowObject.narrat-compra) = "" THEN DO:
        {utp/ut-liter.i "Narrativa_Compra" *}
        ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i &ErrorNumber="265"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U
                                    &ErrorParameters="c-lbl-liter"}
    END.

    /* Validacao: Deposito */
    IF  rowObject.cod-depos = " " THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="8354"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U}
    END.
    else do:
        FIND FIRST deposito no-lock
            WHERE deposito.cod-depos = rowObject.cod-depos NO-ERROR.
        if  not avail deposito then do:
            {method/svc/errors/inserr.i &ErrorNumber="530"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U}
        END.
    end.

    ASSIGN c-estabel = "".
    FOR EACH pedido-compr 
        WHERE pedido-compr.nr-contrato = rowObject.nr-contrato NO-LOCK:

        IF NOT CAN-FIND(FIRST localizacao 
                        WHERE localizacao.cod-estabel = pedido-compr.cod-estabel
                        AND   localizacao.cod-depos = rowObject.cod-depos) THEN
            ASSIGN c-estabel = c-estabel + pedido-compr.cod-estabel + ",":U.
    END.
 
    IF TRIM(c-estabel) <> "" THEN DO:        
        {utp/ut-liter.i Dep¢sito  * L}
        ASSIGN c-lbl-deposito = RETURN-VALUE.
        
        {utp/ut-liter.i nÆo_cadastrado_para_o(s)_estabelecimento(s)  * L}
        ASSIGN c-lbl-nao-cad-estab = RETURN-VALUE.

        ASSIGN c-lbl-liter = TRIM(c-lbl-deposito + " " + c-lbl-nao-cad-estab + "." + "~~":U
                           + c-lbl-deposito + " " + STRING(rowObject.cod-depos)
                           + " " + c-lbl-nao-cad-estab + " " + TRIM(c-estabel)).
        {method/svc/errors/inserr.i &ErrorNumber="25997"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U
                                    &ErrorParameters="c-lbl-liter"}
    END.
    
    /* Validacao: UN */
    FIND FIRST tab-unidade no-lock
        WHERE tab-unidade.un = rowObject.un NO-ERROR.  
    if  not avail tab-unidade then do:
        {method/svc/errors/inserr.i &ErrorNumber="846"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U}
    END.

    /** Valida‡Æo relacionamento item/fornecedor **/
    FIND FIRST item-fornec USE-INDEX onde-compra
        WHERE item-fornec.it-codigo    = rowObject.it-codigo
          AND item-fornec.cod-emitente = contrato-for.cod-emitente NO-LOCK NO-ERROR.
    IF  NOT AVAIL item-fornec
    AND item.tipo-contr <> 4 /* Debito Direto */
    AND item.it-codigo  <> "" THEN DO:        
        {utp/ut-liter.i Relacionamento_Item/Fornecedor_nÆo_est _cadastrado!_(CC0105) *}
        ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).

        {method/svc/errors/inserr.i &ErrorNumber="25997"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U
                                    &ErrorParameters="c-lbl-liter"}
        RETURN "NOK":U.
    END.
    
    /* Unidade de medida difere da unidade do emitente */
    IF  AVAIL item
    AND AVAIL item-fornec
    AND item-fornec.ativo
    AND item.it-codigo <> ""
    and rowObject.un <> item-fornec.unid-med-for THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="2244"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U}
    END.
    
    /* Validacao: Data Base */
    IF  rowObject.dat-base = ? 
    or  rowObject.dat-base > today THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="8541"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U}
    END.
    
    IF  rowObject.mo-codigo <> 0 THEN DO:
        FIND FIRST cotacao
             WHERE cotacao.mo-codigo   = rowObject.mo-codigo
               AND cotacao.ano-periodo = STRING(YEAR(rowObject.dat-base),"9999":U) + 
                                         STRING(MONTH(rowObject.dat-base),"99":U) 
               AND cotacao.cotacao[DAY(rowObject.dat-base)] <> 0 NO-LOCK NO-ERROR.
        
        /* Cotacao da moeda &1 nao cadastrada para o dia &2 */
        IF  NOT AVAIL cotacao THEN DO:
            ASSIGN c-lbl-liter = TRIM(STRING(rowObject.mo-codigo) + "~~":U + STRING(rowObject.dat-base)).
            {method/svc/errors/inserr.i &ErrorNumber="1847"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="c-lbl-liter"}
        END.
    END.
    
    /* Validacao: Condi‡Æo Pagamento */
    IF  NOT (rowObject.cod-cond-pag = 0 
    OR  CAN-FIND(cond-pagto where cond-pagto.cod-cond-pag = rowObject.cod-cond-pag)) THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="1088"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U}
    END.
    
    /* Valida‡Æo: Preco Fornecedor deve ser diferente de 0 */
    IF  rowObject.preco-fornec = 0 THEN DO:
        {utp/ut-liter.i Pre‡o_fornecedor_deve_ser_diferente_de_zero *}
        ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i &ErrorNumber="25997"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U
                                    &ErrorParameters="c-lbl-liter"}
    END.

    /* Validacao: Tipo Despesa */
    FIND FIRST tipo-rec-desp
        WHERE tipo-rec-desp.tp-codigo = rowObject.tp-despesa NO-LOCK NO-ERROR.
    IF  NOT AVAIL tipo-rec-desp THEN DO:
        {utp/ut-liter.i Tipo_Despesa *}
        ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i &ErrorNumber="2"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U
                                    &ErrorParameters="c-lbl-liter"}
    END.

    IF  tipo-rec-desp.tipo = 1 THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="146"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U}
    END.

    /* Verifica quantidade/valor total contra o contrato */
    IF  AVAIL contrato-for
    AND (contrato-for.dec-1 > 0 OR contrato-for.dec-2 > 0)
    AND (rowObject.qtd-total > 0 OR rowObject.val-total > 0) THEN DO:

        ASSIGN de-qtd-tot = 0
               de-val-tot = 0.

        FOR EACH b-item-contrat FIELD (nr-contrato qtd-total val-total)
            WHERE b-item-contrat.nr-contrato = contrato-for.nr-contrato
              AND b-item-contrat.ind-sit-item <> 3 NO-LOCK:

              IF  pType = "update":U AND rowobject.num-seq-item = b-item-contrat.num-seq-item THEN
                  NEXT.

              ASSIGN de-qtd-tot = de-qtd-tot + b-item-contrat.qtd-total
                     de-val-tot = de-val-tot + b-item-contrat.val-total.
        END.

        IF contrato-for.dec-1 > 0 THEN DO:

            IF rowObject.qtd-total > 0 AND de-qtd-tot + rowObject.qtd-total > contrato-for.dec-1 THEN DO:
                {utp/ut-liter.i Limite_Quantidade}
                ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i &ErrorNumber="18380"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U
                                            &ErrorParameters="c-lbl-liter"}
                RETURN "NOK":U.
            END.
        END.

        IF contrato-for.dec-2 > 0 THEN DO:

            IF rowObject.val-total > 0 AND de-val-tot + rowObject.val-total > contrato-for.dec-2 THEN DO:
                {utp/ut-liter.i Limite_Valor}
                ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i &ErrorNumber="18380"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U
                                            &ErrorParameters="c-lbl-liter"}
                RETURN "NOK":U.
            END.
        END.
    END.

    /* Verifica se foi informado limite de qtde ou valor para o contrato ou item */
    IF  AVAIL contrato-for 
    AND contrato-for.dec-2 = 0 /* Limite de Valor do Contrato */
    AND rowObject.val-total = 0 THEN DO:

        FIND FIRST estabelec 
             WHERE estabelec.cod-estabel = contrato-for.cod-estabel NO-LOCK NO-ERROR.

        IF AVAIL estabelec THEN
           RUN cdp/cd9970.p (INPUT ROWID(estabelec), OUTPUT i-empresa).
        
        IF NOT VALID-HANDLE(h-mlaapi018) THEN
           RUN lap/mlaapi018.p PERSISTENT SET h-mlaapi018.
                                                
        RUN pi-verifica-doc-aprov IN h-mlaapi018 (INPUT  i-empresa,
                                                  INPUT  contrato-for.cod-estabel,
                                                  INPUT  13, /*Contrato*/
                                                  OUTPUT l-aprov-contr). 
        IF l-aprov-contr THEN DO:
            {utp/ut-liter.i Quando_os_limites_do_contrato_estÆo_zerados_e_contrato_configurado_para_aprova‡Æo,_deve_ser_informado_limite_nos_itens_do_contrato}
            ASSIGN c-limite-msg = TRIM(RETURN-VALUE).
        END.
        ELSE DO:
            IF rowObject.ind-tipo-control = 1 /*Medicao*/ OR 
               CAN-FIND (FIRST b-item-contrat 
                         WHERE b-item-contrat.nr-contrato      = contrato-for.nr-contrato
                           AND b-item-contrat.ind-sit-item    <> 3 /*Cancelado*/
                           AND b-item-contrat.ind-tipo-control = 1 /*Medicao*/ ) THEN DO:
                
                RUN pi-verifica-doc-aprov IN h-mlaapi018 (INPUT i-empresa,
                                                          INPUT contrato-for.cod-estabel,
                                                          INPUT 14, /*Medicao de Contrato*/
                                                          OUTPUT l-aprov-med).
                IF l-aprov-med THEN DO:
                    {utp/ut-liter.i Quando_os_limites_do_contrato_estÆo_zerados_e_medi‡Æo_configurada_para_aprova‡Æo,_deve_ser_informado_limite_nos_itens_do_contrato}
                    ASSIGN c-limite-msg = TRIM(RETURN-VALUE).
                END.
            END.
        END.
    
        IF VALID-HANDLE(h-mlaapi018) THEN DO:
            DELETE PROCEDURE h-mlaapi018.
            ASSIGN h-mlaapi018 = ?.
        END.
    
        IF l-aprov-contr OR l-aprov-med THEN DO:
            ASSIGN c-lbl-liter = STRING(c-lim-qtd) + '/':U + STRING(c-lim-valor) + '~~':U + c-limite-msg.
            {method/svc/errors/inserr.i &ErrorNumber="3147"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="c-lbl-liter"}
            RETURN "NOK":U.
        END.
    END.

    IF rowObject.qtd-total = ? THEN DO:
        {utp/ut-liter.i Limite_Quantidade}
        ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i &ErrorNumber="158"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U
                                    &ErrorParameters="c-lbl-liter"}
    END.

    IF rowObject.val-total = ? THEN DO:
        {utp/ut-liter.i Limite_Valor}
        ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i &ErrorNumber="158"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U
                                    &ErrorParameters="c-lbl-liter"}
    END.
    
    IF pType = "update":U THEN DO:

        FIND FIRST b-item-contrat
            WHERE b-item-contrat.nr-contrato  = rowObject.nr-contrato
              AND b-item-contrat.num-seq-item = rowObject.num-seq-item no-error.
    
        if  AVAIL b-item-contrat THEN DO:
            IF  b-item-contrat.ind-sit-item = 2 /* Emitido */ then do:
                if (b-item-contrat.ind-tipo-control <> rowObject.ind-tipo-control 
                or  b-item-contrat.ind-tipo-control-val <> rowObject.ind-tipo-control-val) then do:

                    case b-item-contrat.ind-tipo-control:
                        when 1 then do:
                            find first medicao-contrat
                                where medicao-contrat.nr-contrato  = b-item-contrat.nr-contrato
                                  and medicao-contrat.num-seq-item = b-item-contrat.num-seq-item
                                  no-lock no-error.
                            if avail medicao-contrat then do:
                                {method/svc/errors/inserr.i &ErrorNumber="15515"
                                                            &ErrorType="EMS":U
                                                            &ErrorSubType="ERROR":U}
                                RETURN "NOK":U.
                            end.
                        end.
                        when 2 then do:
                              find first ordem-compra
                                   where ordem-compra.nr-contrato  = b-item-contrat.nr-contrato
                                     and ordem-compra.num-seq-item = b-item-contrat.num-seq-item
                                     and (ordem-compra.situacao = 2 or
                                     ordem-compra.situacao = 6) no-lock no-error.
                            if avail ordem-compra then do:
                                {method/svc/errors/inserr.i &ErrorNumber="15515"
                                                            &ErrorType="EMS":U
                                                            &ErrorSubType="ERROR":U}
                                 RETURN "NOK":U.
                            end.
                        end.
                        when 3 then do:
                            find first prazo-compra 
                                where prazo-compra.nr-contrato = b-item-contrat.nr-contrato
                                  and prazo-compra.it-codigo   = b-item-contrat.it-codigo
                                  and prazo-compra.quantidade  > 0 no-lock no-error.
                            if avail prazo-compra then do:
                                {method/svc/errors/inserr.i &ErrorNumber="15515"
                                                            &ErrorType="EMS":U
                                                            &ErrorSubType="ERROR":U}
                                RETURN "NOK":U.
                            end.
                        end.
                    end case.
                end.
            end.
            
            IF  AVAIL contrato-for
            AND (   (rowObject.qtd-total > 0 AND b-item-contrat.qtd-total > 0 AND b-item-contrat.sld-qtd > 0) 
                 OR (b-item-contrat.qtd-total = 0 AND rowObject.qtd-total > 0) ) 
            AND b-item-contrat.sld-qtd > (rowObject.qtd-total + (rowObject.qtd-total * contrato-for.variacao-qtd) / 100) THEN DO:
                {utp/ut-liter.i "Item_do_Contrato" *}
                ASSIGN c-lbl-liter = STRING(c-lim-qtd) + '~~':U + STRING(c-qtd)+ '~~':U + TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i &ErrorNumber="29997"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U
                                            &ErrorParameters="c-lbl-liter"}
                RETURN "NOK":U.
            END.
        
            IF  AVAIL contrato-for
            AND (   (rowObject.val-total > 0 AND b-item-contrat.val-total > 0 AND b-item-contrat.sld-val > 0) 
                 OR (b-item-contrat.val-total = 0 AND rowObject.val-total > 0) ) 
            AND b-item-contrat.sld-val > (rowObject.val-total + (rowObject.val-total * contrato-for.variacao-preco) / 100)
            THEN DO:
                {utp/ut-liter.i "Item_do_Contrato" *}
                ASSIGN c-lbl-liter = STRING(c-lim-valor) + '~~':U + STRING(c-valor) + '~~':U + TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i &ErrorNumber="29997"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U
                                            &ErrorParameters="c-lbl-liter"}
                RETURN "NOK":U.
            END.
            
            IF b-item-contrat.val-total > 0 AND rowObject.val-total = 0 THEN DO:

               FIND FIRST item-contrat-estab
                    WHERE item-contrat-estab.nr-contrato  = b-item-contrat.nr-contrato
                      AND item-contrat-estab.num-seq-item = b-item-contrat.num-seq-item
                      AND item-contrat-estab.it-codigo    = b-item-contrat.it-codigo NO-LOCK NO-ERROR.

                IF  AVAIL item-contrat-estab AND item-contrat-estab.val-total > 0 THEN DO:
                    {utp/ut-liter.i valor * L}
                    ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).
                    {METHOD/svc/errors/inserr.i &ErrorNumber="17129"
                                                &ErrorType="EMS":U
                                                &ErrorSubType="ERROR":U
                                                &ErrorParameters="c-lbl-liter"}
                    RETURN "NOK":U.
                END.
            END.
        
            IF b-item-contrat.qtd-total > 0 AND rowObject.qtd-total = 0 THEN DO:
                
                FIND FIRST item-contrat-estab
                     WHERE item-contrat-estab.nr-contrato  = b-item-contrat.nr-contrato
                       AND item-contrat-estab.num-seq-item = b-item-contrat.num-seq-item
                       AND item-contrat-estab.it-codigo    = b-item-contrat.it-codigo NO-LOCK NO-ERROR.

                IF AVAIL item-contrat-estab AND item-contrat-estab.qtd-total > 0 THEN DO:
                    {utp/ut-liter.i quantidade * L}
                    ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).
                    {METHOD/svc/errors/inserr.i &ErrorNumber="17129"
                                                &ErrorType="EMS":U
                                                &ErrorSubType="ERROR":U
                                                &ErrorParameters="c-lbl-liter"}
                    RETURN "NOK":U.
                END.
            END.
        END.
    END.
    
    IF NOT l-nao-valida-limite
    AND(   (rowObject.qtd-total > 0 AND rowObject.val-total >= 0)
        OR (rowObject.val-total > 0 AND rowObject.qtd-total >= 0)) THEN DO:
        
        IF  pType = "create":U THEN 
            ASSIGN i-sld-qtd = 0 
                   i-sld-val = 0.
        ELSE DO:              
            IF AVAIL b-item-contrat THEN DO:
                IF  b-item-contrat.ind-tipo-control-val = 3 THEN DO:
                    IF  de-qtd-movto = 0 THEN
                        RUN cnp/cn0201c8.p(INPUT ROWID(b-item-contrat), OUTPUT de-qtd-movto, OUTPUT TABLE RowErrors).

                    ASSIGN i-sld-qtd = de-qtd-movto
                           i-sld-val = b-item-contrat.sld-val.
                END.
                ELSE
                    ASSIGN i-sld-qtd = b-item-contrat.sld-qtd
                           i-sld-val = b-item-contrat.sld-val.
            END.
        END.

        RUN pi-valida-limite (INPUT rowObject.pre-unit-for,
                              INPUT rowObject.qtd-total,
                              INPUT i-sld-qtd,
                              INPUT rowObject.val-total,
                              INPUT i-sld-val,
                              OUTPUT l-limite-valido).
        IF  NOT l-limite-valido THEN DO:
            ASSIGN c-valor = TRIM(STRING(rowObject.qtd-total, '->>>>>,>>>,>>9.9999':U))  + '~~':U +
                             TRIM(STRING(i-sld-qtd, '->>>>>,>>>,>>9.9999':U)) + '~~':U +
                             TRIM(STRING(rowObject.pre-unit-for, '->>>>>,>>>,>>9.99999':U)) + '~~':U +
                             TRIM(STRING(ROUND((rowObject.pre-unit-for *
                                               (rowObject.qtd-total - i-sld-qtd)),4), '->>>,>>>,>>>,>>9.9999':U)) + '~~':U +
                             TRIM(STRING(rowObject.val-total, '->>>>>,>>>,>>9.9999':U)) + '~~':U +
                             TRIM(STRING(i-sld-val, '>>>>>,>>>,>>9.9999':U)) + '~~':U + 
                             TRIM(STRING(ROUND((rowObject.val-total - i-sld-val),4), '->>>>>,>>>,>>9.9999':U)).
            {METHOD/svc/errors/inserr.i &ErrorNumber="56416"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="c-valor"}                                     
                                        
                                           
        END.
    END.
    
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-limite DBOProgram 
PROCEDURE pi-valida-limite:
/*------------------------------------------------------------------------------
  Purpose: Validar se os campos de valores e limites estao validos    
  Parameters: de-preco-fornecedor  (INPUT - decimal) - Preco do Fornecedor
              de-limite-quantidade (INPUT - decimal) - Limite de quantidade
              de-qtd-movimentada   (INPUT - decimal) - Quantidade ja movimentada
              de-limite-valor      (INPUT - decimal) - Limite de valor
              de-valor-movimentado (INPUT - decimal) - Valor ja movimentado
              l-limite-valido      (OUTPUT - logical) - Indica se o valores estao validos/coerentes
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER de-preco-fornecedor  AS DECIMAL NO-UNDO.
    DEFINE INPUT  PARAMETER de-limite-quantidade AS DECIMAL NO-UNDO.
    DEFINE INPUT  PARAMETER de-qtd-movimentada   AS DECIMAL NO-UNDO.
    DEFINE INPUT  PARAMETER de-limite-valor      AS DECIMAL NO-UNDO.
    DEFINE INPUT  PARAMETER de-valor-movimentado AS DECIMAL NO-UNDO.
    DEFINE OUTPUT PARAMETER l-limite-valido      AS LOGICAL NO-UNDO.
   
    IF ROUND((de-preco-fornecedor * (de-limite-quantidade - de-qtd-movimentada)),4) <> ROUND((de-limite-valor - de-valor-movimentado),4) THEN 
        ASSIGN l-limite-valido = NO.
    ELSE
        ASSIGN l-limite-valido = YES.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
