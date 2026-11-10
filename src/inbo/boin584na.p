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
{include/i-prgvrs.i BOIN584NA 2.00.00.003} /*** "010003" 27/07/2026 14:40:45 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN584NA MUT}
&ENDIF

/*:T--------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) Ç um programa PROGRESS
                 que contÇm a l¢gica de neg¢cio e acesso a dados para uma
                 tabela do banco de dados.

    Parameters :

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN584
&GLOBAL-DEFINE DBOVersion
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName matriz-rat-item
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

&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (mÇtodo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /*:T Nome da Query que d† acessos a todos os registros, exceto os exclu°dos pela constraint de seguranáa. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /*:T Informar os campos da chave quando o Progress n∆o conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

/*:T--- Include com definiá∆o da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com
      extens∆o .i ---*/
{inbo/boin584na.i RowObject}
{include/i_dbvers.i}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

{cdp/cd9590.i}   /*Include verificaá∆o Unidade Neg¢cio*/
{cdp/cdcfgmat.i}
{cdp/cdcfgdis.i}
{utp/ut-glob.i}
{cdp/cdunif001.i}

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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "conta-contabil":U THEN ASSIGN pFieldValue = RowObject.conta-contabil.
        WHEN "ct-codigo":U THEN ASSIGN pFieldValue = RowObject.ct-codigo.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "sc-codigo":U THEN ASSIGN pFieldValue = RowObject.sc-codigo.
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "perc-rateio":U THEN ASSIGN pFieldValue = RowObject.perc-rateio.
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "nr-contrato":U THEN ASSIGN pFieldValue = RowObject.nr-contrato.
        WHEN "num-seq-item":U THEN ASSIGN pFieldValue = RowObject.num-seq-item.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice matriz-item
  Parameters:
               retorna valor do campo nr-contrato
               retorna valor do campo num-seq-item
               retorna valor do campo conta-contabil
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnr-contrato LIKE matriz-rat-item.nr-contrato NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-seq-item LIKE matriz-rat-item.num-seq-item NO-UNDO.
    DEFINE OUTPUT PARAMETER pconta-contabil LIKE matriz-rat-item.conta-contabil NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pnr-contrato = RowObject.nr-contrato
           pnum-seq-item = RowObject.num-seq-item
           pconta-contabil = RowObject.conta-contabil.

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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
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
  Purpose:     Reposiciona registro com base no °ndice matriz-item
  Parameters:
               recebe valor do campo nr-contrato
               recebe valor do campo num-seq-item
               recebe valor do campo ct-codigo
               recebe valor do campo sc-codigo
               recebe valor do campo cod-unid-negoc
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-contrato LIKE matriz-rat-item.nr-contrato NO-UNDO.
    DEFINE INPUT PARAMETER pnum-seq-item LIKE matriz-rat-item.num-seq-item NO-UNDO.
    DEFINE INPUT PARAMETER pct-codigo LIKE matriz-rat-item.ct-codigo NO-UNDO.
    DEFINE INPUT PARAMETER psc-codigo LIKE matriz-rat-item.sc-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-unid-negoc LIKE matriz-rat-item.cod-unid-negoc NO-UNDO.

    FIND FIRST bfmatriz-rat-item WHERE
        bfmatriz-rat-item.nr-contrato = pnr-contrato AND
        bfmatriz-rat-item.num-seq-item = pnum-seq-item AND
        bfmatriz-rat-item.ct-codigo = pct-codigo AND
        bfmatriz-rat-item.sc-codigo = psc-codigo AND
        bfmatriz-rat-item.cod-unid-negoc = pcod-unid-negoc NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfmatriz-rat-item THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmatriz-rat-item)).
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
    open query {&queryName}
        for each {&tableName} no-lock indexed-reposition.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    /* Variˇveis conta ctbl */
    DEFINE VARIABLE iempresa LIKE empresa.ep-codigo NO-UNDO.

    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/

    IF pType = "Create" THEN DO:
        IF CAN-FIND(FIRST bf{&TableName} NO-LOCK
                    WHERE bf{&TableName}.nr-contrato    = RowObject.nr-contrato
                    AND   bf{&TableName}.num-seq-item   = RowObject.num-seq-item
                    AND   bf{&TableName}.ct-codigo      = RowObject.ct-codigo
                    AND   bf{&TableName}.sc-codigo      = RowObject.sc-codigo
                    AND   bf{&TableName}.cod-unid-negoc = RowObject.cod-unid-negoc) THEN DO:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-matriz AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Matriz_Rateio_Item" *}
                ASSIGN c-lbl-liter-matriz = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i &ErrorNumber="1"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="c-lbl-liter-matriz"}
        END.
    END.

    IF RowObject.perc-rateio = 0 THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="8462"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="''"}
    END.

    IF NOT VALID-HANDLE(h_api_cta_ctbl) THEN
        RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.

    FIND FIRST param-global NO-LOCK NO-ERROR.
    ASSIGN iEmpresa = param-global.empresa-prin.
    FIND FIRST contrato-for
        WHERE contrato-for.nr-contrato = RowObject.nr-contrato NO-LOCK NO-ERROR.
    FIND FIRST estabelec
        WHERE estabelec.cod-estabel = contrato-for.cod-estabel NO-LOCK NO-ERROR.
    ASSIGN iempresa = estabelec.ep-codigo.

    run pi_valida_conta_contabil in h_api_cta_ctbl (input  iEmpresa,                    /* EMPRESA EMS2 */
                                                    input  contrato-for.cod-estabel,    /* ESTABELECIMENTO EMS2 */
                                                    input  RowObject.cod-unid-negoc,    /* UNIDADE NEGÖCIO */
                                                    input  "",                          /* PLANO CONTAS */
                                                    input  RowObject.ct-codigo,         /* CONTA */
                                                    input  "",                          /* PLANO CCUSTO */
                                                    input  RowObject.sc-codigo,         /* CCUSTO */
                                                    input  TODAY,                       /* DATA TRANSACAO */
                                                    output table tt_log_erro).          /* ERROS */
    for first tt_log_erro:
        {method/svc/errors/inserr.i &ErrorNumber="17006"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="STRING(tt_log_erro.ttv_des_msg_erro)"}
    end.

    EMPTY TEMP-TABLE tt_log_erro.
    ASSIGN v_cod_cta_ctbl = RowObject.ct-codigo.
    run pi_busca_dados_cta_ctbl in h_api_cta_ctbl(INPUT        iEmpresa,            /* EMPRESA EMS2 */
                                                  input        "",                  /* PLANO DE CONTAS */
                                                  input-output v_cod_cta_ctbl,           /* CONTA */
                                                  input        today,               /* DATA TRANSACAO */
                                                  output       p_des_titulo,        /* DESCRICAO CONTA */
                                                  output       v_num_tip_cta_ctbl,       /* TIPO DA CONTA */
                                                  output       v_num_sit_cta_ctbl,       /* SITUAõ¯O DA CONTA */
                                                  output       v_ind_finalid_cta,   /* FINALIDADES DA CONTA */
                                                  output table tt_log_erro).
    IF VALID-HANDLE(h_api_cta_ctbl) THEN DELETE OBJECT h_api_cta_ctbl.

    for first tt_log_erro:
        {method/svc/errors/inserr.i &ErrorNumber="17006"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="STRING(tt_log_erro.ttv_des_msg_erro)"}
    end.

    IF NOT CAN-DO("1,2,4,5",STRING(v_num_tip_cta_ctbl))
    OR v_num_sit_cta_ctbl <> 3 THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="3297"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="''"}
    END.

    IF param-global.modulo-ce THEN DO:

        if not (lookup({adinc/i05ad049.i 4 1}, v_ind_finalid_cta) <> 0
        or lookup({adinc/i05ad049.i 4 2}, v_ind_finalid_cta) <> 0
        or lookup({adinc/i05ad049.i 4 3}, v_ind_finalid_cta) <> 0
        or lookup({adinc/i05ad049.i 4 5}, v_ind_finalid_cta) <> 0
        or lookup({adinc/i05ad049.i 4 6}, v_ind_finalid_cta) <> 0) then do:
            {method/svc/errors/inserr.i &ErrorNumber="3298"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="''"}
        end.
    END.

    &if '{&bf_mat_versao_ems}' >= '2.062' &THEN
        IF  l-unidade-negocio AND l-mat-unid-negoc THEN DO:
            IF NOT CAN-FIND(FIRST unid-negoc NO-LOCK
                            WHERE unid-negoc.cod-unid-negoc = RowObject.cod-unid-negoc) THEN DO:
                DEFINE VARIABLE c-lbl-liter-unid-negoc AS CHARACTER NO-UNDO.
                {utp/ut-field.i mgind unid-negoc cod-unid-negoc 1}
                ASSIGN c-lbl-liter-unid-negoc = RETURN-VALUE.
                {method/svc/errors/inserr.i &ErrorNumber="2"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="c-lbl-liter-unid-negoc"}
            END.
        END.
    &endif

    IF NOT VALID-HANDLE(h_api_ccusto) THEN
        RUN prgint/utb/utb742za.py PERSISTENT SET h_api_ccusto.
    EMPTY TEMP-TABLE tt_log_erro.
    run pi_verifica_utilizacao_ccusto in h_api_ccusto (INPUT iEmpresa,
                                                       INPUT estabelec.cod-estabel,
                                                       INPUT "",
                                                       INPUT v_cod_cta_ctbl,
                                                       INPUT today,
                                                       OUTPUT p_log_ccusto,
                                                       OUTPUT TABLE tt_log_erro).
    for first tt_log_erro:
        {method/svc/errors/inserr.i &ErrorNumber="17006"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="STRING(tt_log_erro.ttv_des_msg_erro)"}
    end.

    if not p_log_ccusto and RowObject.sc-codigo <> "" then do:
        DEFINE VARIABLE c-erro-sc-codigo AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Conta_Cont†bil_n∆o_utiliza_centro_de_custo" *}
        ASSIGN c-erro-sc-codigo = RETURN-VALUE.
        {method/svc/errors/inserr.i &ErrorNumber="17006"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="c-erro-sc-codigo"}
    end.

    IF VALID-HANDLE(h_api_ccusto) THEN DELETE OBJECT h_api_ccusto.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

