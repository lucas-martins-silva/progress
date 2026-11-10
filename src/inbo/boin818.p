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
{include/i-prgvrs.i BOIN818 2.00.00.009 } /*** "010009" 27/10/2023 17:03:50  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i boin818 MUT}
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
&GLOBAL-DEFINE DBOName BOIN818
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName cta-autom-cust-horar-ggf
&GLOBAL-DEFINE TableLabel cta-autom-cust-horar-ggf
&GLOBAL-DEFINE QueryName qr{&TableName} 

/** Unifica‡Æo de Conceito **/
{cdp/cdunif001.i}

{cdp/cdcfgman.i}
{cdp/cd0110.i}

/* DBO-XML-BEGIN */
/* Pre-processadores para ativar XML no DBO */
/* Retirar o comentario para ativar 
&GLOBAL-DEFINE XMLProducer YES    /* DBO atua como producer de mensagens para o Message Broker */
&GLOBAL-DEFINE XMLTopic           /* Topico da Mensagem enviada ao Message Broker, geralmente o nome da tabela */
&GLOBAL-DEFINE XMLTableName       /* Nome da tabela que deve ser usado como TAG no XML */ 
&GLOBAL-DEFINE XMLTableNameMult   /* Nome da tabela no plural. Usado para multiplos registros */ 
&GLOBAL-DEFINE XMLPublicFields    /* Lista dos campos (c1,c2) que podem ser enviados via XML. Ficam fora da listas os campos de especializacao da tabela */ 
&GLOBAL-DEFINE XMLKeyFields       /* Lista dos campos chave da tabela (c1,c2) */
&GLOBAL-DEFINE XMLExcludeFields   /* Lista de campos a serem excluidos do XML quando PublicFields = "" */

&GLOBAL-DEFINE XMLReceiver YES    /* DBO atua como receiver de mensagens enviado pelo Message Broker (m‚todo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /* Nome da Query que d  acessos a todos os registros, exceto os exclu¡dos pela constraint de seguran‡a. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /* Informar os campos da chave quando o Progress nÆo conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

/*--- Include com defini‡Æo da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com 
      extensÆo .i ---*/
{inbo~/boin818.i RowObject}


/*--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}


/*--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.


/*--- Defini‡Æo de vari veis locais ---*/
DEFINE VARIABLE c-cc-codigo AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cod-estabel AS CHARACTER NO-UNDO.
DEFINE VARIABLE i-especie   AS INTEGER   NO-UNDO.
DEFINE VARIABLE c-cc-codigo-ini AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cc-codigo-fim AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-ct-codigo AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-sc-codigo AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-up        AS LOGICAL     NO-UNDO.

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
         HEIGHT             = 27.71
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterGetBatchRecords DBOProgram 
PROCEDURE afterGetBatchRecords :
/*------------------------------------------------------------------------------
  Purpose: Clientes que desativam a op‡Æo de centro de custo por estabelecimento
           podem ficar com registros de cta-autom-cust-horar-ggf 'sujos'. EntÆo
           quando a fun‡Æo ccusto-produtivo-estab estiver desativada, os 
           estabelecimentos do campo cod-estab-cust devem ser branco.
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

if not l-funcao-ccusto-estab then
    assign RowObjectAux.cod-estab-cust = ''.

RETURN 'OK':U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeUpdateRecord DBOProgram 
PROCEDURE beforeUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose: Clientes que desativam a op‡Æo de centro de custo por estabelecimento
           podem ficar com registros de cta-autom-cust-horar-ggf 'sujos'. EntÆo
           quando a fun‡Æo ccusto-produtivo-estab estiver desativada, os 
           estabelecimentos do campo cod-estab-cust devem ser branco.
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

if not l-funcao-ccusto-estab then
    assign rowObject.cod-estab-cust = ''. 

RETURN 'OK':U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findPercent DBOProgram 
PROCEDURE findPercent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcConta    AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER pcSubConta AS CHARACTER NO-UNDO.

DEFINE INPUT  PARAMETER pEmpresa   like {&TableName}.ep-codigo NO-UNDO.
DEFINE INPUT  PARAMETER pcEstab    AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER pcUnNeg    AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pdPercent  AS DECIMAL   NO-UNDO.

DEFINE VARIABLE d-percent AS DECIMAL NO-UNDO.

DEFINE BUFFER bf{&TableName}-perc FOR {&TableName}.

FOR EACH bf{&TableName}-perc FIELDS(val-perc-ccusto) WHERE
         bf{&TableName}-perc.ct-codigo      = pcConta    AND
         bf{&TableName}-perc.sc-codigo      = pcSubConta AND
         bf{&TableName}-perc.ep-codigo      = pEmpresa   AND
         bf{&TableName}-perc.cod-estabel    = pcEstab    AND
         bf{&TableName}-perc.cod-unid-negoc = pcUnNeg    NO-LOCK:
    ASSIGN d-percent = d-percent + bf{&TableName}-perc.val-perc-ccusto.
END.

ASSIGN l-up = NO.

IF d-percent <= 0 THEN
    IF l-up THEN
        ASSIGN pdPercent = d-percent.
    ELSE
        ASSIGN pdPercent = 100.
ELSE
    IF l-up THEN
        ASSIGN pdPercent = d-percent.
    ELSE
        ASSIGN pdPercent = (100 - d-percent).
    

RETURN 'OK':U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findPercentUp DBOProgram 
PROCEDURE findPercentUp :
/*------------------------------------------------------------------------------
  Purpose:     Procura a porcentagem e verifica se est  modificando ou incluindo.
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER prTable    AS ROWID     NO-UNDO.
DEFINE INPUT  PARAMETER pcConta    AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER pcSubConta AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER pEmpresa   like {&TableName}.ep-codigo NO-UNDO.
DEFINE INPUT  PARAMETER pcEstab    AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER pcUnNeg    AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pdPercent  AS DECIMAL   NO-UNDO.

DEFINE VARIABLE d-percent AS DECIMAL NO-UNDO.
DEFINE VARIABLE d-inicial AS DECIMAL NO-UNDO.

DEFINE BUFFER bf{&TableName}-perc FOR {&TableName}.

ASSIGN d-percent = 0
       d-inicial = 0
       l-up      = YES.

IF NOT CAN-FIND(FIRST bf{&TableName}-perc WHERE 
                      ROWID(bf{&TableName}-perc)         = prTable    AND
                      bf{&TableName}-perc.ct-codigo      = pcConta    AND
                      bf{&TableName}-perc.sc-codigo      = pcSubConta AND
                      bf{&TableName}-perc.ep-codigo      = pEmpresa   AND
                      bf{&TableName}-perc.cod-estabel    = pcEstab    AND
                      bf{&TableName}-perc.cod-unid-negoc = pcUnNeg    NO-LOCK) THEN
    RUN findPercent IN THIS-PROCEDURE (INPUT  pcConta,
                                       INPUT  pcSubConta,
                                       INPUT  pEmpresa,
                                       INPUT  pcEstab,
                                       INPUT  pcUnNeg,
                                       OUTPUT d-percent).
ELSE DO:
    FOR FIRST bf{&TableName}-perc FIELDS(val-perc-ccusto) WHERE 
              ROWID(bf{&TableName}-perc) = prTable NO-LOCK:
        ASSIGN d-inicial = bf{&TableName}-perc.val-perc-ccusto.
    END.
    FOR EACH bf{&TableName}-perc FIELDS(val-perc-ccusto) WHERE
             bf{&TableName}-perc.ct-codigo      = pcConta    AND
             bf{&TableName}-perc.sc-codigo      = pcSubConta AND
             bf{&TableName}-perc.ep-codigo      = pEmpresa   AND
             bf{&TableName}-perc.cod-estabel    = pcEstab    AND
             bf{&TableName}-perc.cod-unid-negoc = pcUnNeg    NO-LOCK:
        ASSIGN d-percent = d-percent + bf{&TableName}-perc.val-perc-ccusto.
    END.
END.

IF d-percent <= 0 THEN
    ASSIGN pdPercent = 100.
ELSE
    ASSIGN pdPercent = 100 - (d-percent - d-inicial).

RETURN 'OK':U.

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
        
        &IF DEFINED (bf_man_207A) &THEN
        WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
        &ENDIF
        &if  "{&bf_man_versao_ems}" < "2.08":U &then
        WHEN "cc-codigo":U THEN ASSIGN pFieldValue = RowObject.cc-codigo.
        WHEN "ct-codigo":U THEN ASSIGN pFieldValue = RowObject.ct-codigo.
        WHEN "sc-codigo":U THEN ASSIGN pFieldValue = RowObject.sc-codigo.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        &ENDIF
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
        WHEN "dat-livre-1":U THEN ASSIGN pFieldValue = RowObject.dat-livre-1.
        WHEN "dat-livre-2":U THEN ASSIGN pFieldValue = RowObject.dat-livre-2.
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
        WHEN "val-perc-ccusto":U THEN ASSIGN pFieldValue = RowObject.val-perc-ccusto.
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
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
        &IF DEFINED (bf_man_207A) &THEN
        &ELSE
        WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
        &ENDIF
        WHEN "cod-especie":U THEN ASSIGN pFieldValue = RowObject.cod-especie.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice id-cta-autom-cust-horar-ggf
  Parameters:  
               retorna valor do campo ep-codigo
               retorna valor do campo ct-codigo
               retorna valor do campo sc-codigo
               retorna valor do campo cc-codigo
               retorna valor do campo especie
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pep-codigo LIKE cta-autom-cust-horar-ggf.ep-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE cta-autom-cust-horar-ggf.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-unid-negoc LIKE cta-autom-cust-horar-ggf.cod-unid-negoc NO-UNDO.
    DEFINE OUTPUT PARAMETER pct-codigo LIKE cta-autom-cust-horar-ggf.ct-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER psc-codigo LIKE cta-autom-cust-horar-ggf.sc-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcc-codigo LIKE cta-autom-cust-horar-ggf.cc-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-especie LIKE cta-autom-cust-horar-ggf.cod-especie NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pep-codigo = RowObject.ep-codigo
           pcod-estabel = RowObject.cod-estabel
           pcod-unid-negoc = RowObject.cod-unid-negoc
           pct-codigo = RowObject.ct-codigo
           psc-codigo = RowObject.sc-codigo
           pcc-codigo = RowObject.cc-codigo
           pcod-especie = RowObject.cod-especie.

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
  Purpose:     Reposiciona registro com base no ¡ndice id-cta-autom-cust-horar-ggf
  Parameters:  
               recebe valor do campo ep-codigo
               recebe valor do campo ct-codigo
               recebe valor do campo sc-codigo
               recebe valor do campo cc-codigo
               recebe valor do campo especie
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo LIKE cta-autom-cust-horar-ggf.ep-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE cta-autom-cust-horar-ggf.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pcod-unid-negoc LIKE cta-autom-cust-horar-ggf.cod-unid-negoc NO-UNDO.
    DEFINE INPUT PARAMETER pct-codigo LIKE cta-autom-cust-horar-ggf.ct-codigo NO-UNDO.
    DEFINE INPUT PARAMETER psc-codigo LIKE cta-autom-cust-horar-ggf.sc-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcc-codigo LIKE cta-autom-cust-horar-ggf.cc-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pespecie LIKE cta-autom-cust-horar-ggf.cod-especie NO-UNDO.

    FIND FIRST bfcta-autom-cust-horar-ggf WHERE 
        bfcta-autom-cust-horar-ggf.ep-codigo = pep-codigo AND 
        bfcta-autom-cust-horar-ggf.cod-estabel = pcod-estabel AND 
        bfcta-autom-cust-horar-ggf.cod-unid-negoc = pcod-unid-negoc AND 
        bfcta-autom-cust-horar-ggf.ct-codigo = pct-codigo AND 
        bfcta-autom-cust-horar-ggf.sc-codigo = psc-codigo AND 
        bfcta-autom-cust-horar-ggf.cc-codigo = pcc-codigo AND 
        bfcta-autom-cust-horar-ggf.cod-especie = pespecie NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfcta-autom-cust-horar-ggf THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfcta-autom-cust-horar-ggf)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToCentro-Custo DBOProgram 
PROCEDURE linkToCentro-Custo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pHandle AS HANDLE NO-UNDO.

RUN getKey IN pHandle (OUTPUT c-cc-codigo).

RUN setConstraintcta-autom-cust-horar-ggf IN THIS-PROCEDURE (INPUT c-cc-codigo).

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToCcusto-Estab DBOProgram 
PROCEDURE linkToCcusto-Estab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pHandle AS HANDLE NO-UNDO.

RUN getKey IN pHandle (OUTPUT c-cc-codigo, OUTPUT c-cod-estabel).

RUN setConstraintcta-autom-cust-horar-ggf-estab IN THIS-PROCEDURE (INPUT c-cc-codigo, INPUT c-cod-estabel).

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCentro-Custo DBOProgram 
PROCEDURE openQueryCentro-Custo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK WHERE 
                                 {&TableName}.cc-codigo = c-cc-codigo AND
                                 {&TableName}.cod-especie = i-especie 
                                     by {&TableName}.ep-codigo 
                                     by {&TableName}.cod-estabel 
                                     by {&TableName}.cod-unid-negoc 
                                     by {&TableName}.ct-codigo 
                                     by {&TableName}.sc-codigo 
                                     by {&TableName}.cc-codigo
                                     by {&TableName}.cod-especie.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCcusto-Estab DBOProgram 
PROCEDURE openQueryCcusto-Estab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK WHERE
                                 {&TableName}.cc-codigo = c-cc-codigo AND
                                 {&TableName}.cod-estab-cust = c-cod-estabel AND
                                 {&TableName}.cod-especie = i-especie
                                    by {&TableName}.ep-codigo 
                                    by {&TableName}.cod-estabel 
                                    by {&TableName}.cod-unid-negoc 
                                    by {&TableName}.ct-codigo 
                                    by {&TableName}.sc-codigo 
                                    by {&TableName}.cc-codigo
                                    by {&TableName}.cod-especie.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryConta-Contab DBOProgram 
PROCEDURE openQueryConta-Contab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK WHERE 
                                 {&TableName}.ct-codigo = c-ct-codigo AND
                                 {&TableName}.sc-codigo = c-sc-codigo indexed-reposition.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFaixaCC DBOProgram 
PROCEDURE openQueryFaixaCC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK WHERE 
                                     {&TableName}.cc-codigo >= c-cc-codigo-ini AND
                                     {&TableName}.cc-codigo <= c-cc-codigo-fim indexed-reposition.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
OPEN QUERY {&QueryName} FOR EACH {&TableName} no-lock indexed-reposition.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-SetConta DBOProgram 
PROCEDURE pi-SetConta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-ct-codigo AS CHARACTER NO-UNDO.

ASSIGN c-ct-codigo = p-ct-codigo.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-SetEspecie DBOProgram 
PROCEDURE pi-SetEspecie :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER piEspecie AS INTEGER NO-UNDO.

ASSIGN i-especie = piEspecie.

RETURN 'OK':U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-SetSubConta DBOProgram 
PROCEDURE pi-SetSubConta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-sc-codigo AS CHARACTER NO-UNDO.

ASSIGN c-sc-codigo = p-sc-codigo.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-ValidateEstabUnNeg DBOProgram 
PROCEDURE pi-ValidateEstabUnNeg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pcConta    AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcSubConta AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcEstab    AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcUnNeg    AS CHARACTER NO-UNDO.

FIND FIRST bf{&TableName}
    WHERE bf{&TableName}.ct-codigo = pcConta
    AND   bf{&TableName}.sc-codigo = pcSubConta NO-LOCK NO-ERROR.

IF AVAIL bf{&TableName} AND
    ((bf{&TableName}.cod-estabel <> "":U AND
      pcEstab = "":U) OR
     (bf{&TableName}.cod-estabel = "":U AND
      pcEstab <> "":U) OR
     (bf{&TableName}.cod-unid-negoc <> "":U AND
      pcUnNeg = "":U) OR
     (bf{&TableName}.cod-unid-negoc = "":U AND
      pcUnNeg <> "":U)) THEN
    RETURN "NOK":U.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintcta-autom-cust-horar-ggf DBOProgram 
PROCEDURE setConstraintcta-autom-cust-horar-ggf :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-cc-codigo AS CHARACTER NO-UNDO.

ASSIGN c-cc-codigo = p-cc-codigo.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintcta-autom-cust-horar-ggf DBOProgram 
PROCEDURE setConstraintcta-autom-cust-horar-ggf-estab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-cc-codigo AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER p-cod-estabel AS CHARACTER NO-UNDO.

ASSIGN c-cc-codigo = p-cc-codigo.
ASSIGN c-cod-estabel = p-cod-estabel.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFaixaCC DBOProgram 
PROCEDURE setConstraintFaixaCC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cc-codigo-ini AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-cc-codigo-fim AS CHARACTER NO-UNDO.
    
    ASSIGN c-cc-codigo-ini = p-cc-codigo-ini
           c-cc-codigo-fim = p-cc-codigo-fim.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Valida‡äes pertinentes ao DBO
  Parameters:  recebe o tipo de valida‡Æo (], Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    define variable d-percentual as decimal no-undo.

    DEFINE VARIABLE i-seq-erros-api-ctb-cc AS INTEGER INIT 1 NO-UNDO.

    /*--- Utilize o parƒmetro pType para identificar quais as valida‡äes a serem
          executadas ---*/
    /*--- Os valores poss¡veis para o parƒmetro sÆo: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do 
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as valida‡äes ---*/

              /*{method/svc/errors/inserr.i
               &ErrorNumber="7" 
               &ErrorType="EMS"
               &ErrorParameters="'Item'"}  */
               
    
    
  IF &if defined(bf_man_207A) &then 
    RowObject.ep-codigo <> "":U 
   &else
    RowObject.ep-codigo <> 0
   &endif                           THEN DO:
   
    if not can-find(empresa WHERE empresa.ep-codigo = rowObject.ep-codigo) then do:
        {method/svc/errors/inserr.i &ErrorNumber="34271" 
                                    &ErrorType="EMS"
                                    &ErrorParameters="RowObject.ep-codigo"}
    end.
        
  end.
  else do:
          {method/svc/errors/inserr.i &ErrorNumber="28325" 
                                      &ErrorType="EMS"
                                      &ErrorParameters="RowObject.ep-codigo"}
  end.
               
 
  if RowObject.cod-estabel <> "":U then do:
      if not can-find(estabelec where 
                      estabelec.cod-estabel = RowObject.cod-estabel) then do:
          {method/svc/errors/inserr.i &ErrorNumber="777" 
                                      &ErrorType="EMS"
                                      &ErrorParameters="RowObject.cod-estabel"}
      end.
  end.

  if rowObject.cod-unid-negoc <> "":U then do:
      if not can-find(unid-negoc where 
                      unid-negoc.cod-unid-negoc = rowObject.cod-unid-negoc) then do:
          {method/svc/errors/inserr.i &ErrorNumber="34577" 
                                      &ErrorType="EMS"
                                      &ErrorParameters="RowObject.cod-unid-negoc"}
      end.
  end.


  if pType <> "DELETE" then do:
      empty temp-table tt_log_erro.
      if not valid-handle(h_api_cta_ctbl) then 
      	run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.

      run pi_valida_conta_contabil in h_api_cta_ctbl (input  rowObject.ep-codigo,
                                                      input  RowObject.cod-estabel,
                                                      input  "",
                                                      input  "",   
                                                      input  RowObject.ct-codigo,
                                                      input  "",   
                                                      input  RowObject.sc-codigo,
                                                      input  TODAY,
                                                      output table tt_log_erro).

      IF can-find(first tt_log_erro) then do:
         
          FOR EACH tt_log_erro NO-LOCK:
              CREATE RowErrors.
              ASSIGN RowErrors.ErrorNumber = tt_log_erro.ttv_num_cod_erro
                     RowErrors.ErrorHelp   = tt_log_erro.ttv_des_msg_ajuda
                     RowErrors.ErrorDescription = tt_log_erro.ttv_des_msg_erro
                     RowErrors.ErrorSequence = i-seq-erros-api-ctb-cc
                     i-seq-erros-api-ctb-cc = i-seq-erros-api-ctb-cc + 1.
          END.
      END.
                      
      run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (INPUT rowObject.ep-codigo,
                                                     INPUT "",
                                                     input-output rowObject.ct-codigo,
                                                     INPUT TODAY,
                                                     output p_des_titulo,
                                                     output v_num_tip_cta_ctbl,
                                                     output v_num_sit_cta_ctbl,
                                                     output v_ind_finalid_cta,
                                                     OUTPUT TABLE tt_log_erro).
        
      if can-find(first tt_log_erro) then do:
        FOR EACH tt_log_erro NO-LOCK:
            CREATE RowErrors.
            ASSIGN RowErrors.ErrorNumber = tt_log_erro.ttv_num_cod_erro
                   RowErrors.ErrorHelp   = tt_log_erro.ttv_des_msg_ajuda
                   RowErrors.ErrorDescription = tt_log_erro.ttv_des_msg_erro
                   RowErrors.ErrorSequence = i-seq-erros-api-ctb-cc
                   i-seq-erros-api-ctb-cc = i-seq-erros-api-ctb-cc + 1.
        END.
    
      end.
      else do:
    	if v_num_tip_cta_ctbl <> 1 then do:
    		{method/svc/errors/inserr.i &ErrorNumber="27455" 
    									&ErrorType="EMS"
    									&ErrorParameters="RowObject.ct-codigo"}
    	end.
      end.
      
    	
    	
    	if not valid-handle(h_api_ccusto) then 
    		run prgint/utb/utb742za.py persistent set h_api_ccusto.
    	
    	run pi_verifica_utilizacao_ccusto in h_api_ccusto (INPUT RowObject.ep-codigo,   /* EMPRESA EMS 2 */        
    													   INPUT RowObject.cod-estabel, /* ESTABELECIMENTO EMS2 */ 
    													   INPUT "",                    /* PLANO CONTAS */         
    													   INPUT RowObject.ct-codigo,   /* CONTA */                
    													   INPUT TODAY,                 /* DT TRANSACAO */         
    													   OUTPUT p_log_ccusto,         /* UTILIZA CCUSTO ? */     
    													   OUTPUT TABLE tt_log_erro).   /* ERROS */                
    	
    	if p_log_ccusto then do:
    		/** CENTRO DE CUSTO **/
    		run pi_busca_dados_ccusto in h_api_ccusto (INPUT RowObject.ep-codigo,
    												   INPUT "",
    												   input RowObject.sc-codigo,
    												   INPUT TODAY,
    												   OUTPUT p_des_titulo,
    												   OUTPUT TABLE tt_log_erro).

    		
    		if can-find (first tt_log_erro) then do:
    			FOR EACH tt_log_erro:
    				CREATE RowErrors.
    				ASSIGN RowErrors.ErrorNumber = tt_log_erro.ttv_num_cod_erro
    					   RowErrors.ErrorHelp   = tt_log_erro.ttv_des_msg_ajuda
    					   RowErrors.ErrorDescription = tt_log_erro.ttv_des_msg_erro
    					   RowErrors.Errorsequence = i-seq-erros-api-ctb-cc
                           RowErrors.ErrorType = "EMS2"
                           RowErrors.ErrorSubType = "ERROR"
                           i-seq-erros-api-ctb-cc = i-seq-erros-api-ctb-cc + 1.
    			END.
    		end.
    	end. ELSE DO:
            ASSIGN RowObject.sc-codigo = "".
        END.
        
    
      run pi-ValidateEstabUnNeg (input RowObject.ct-codigo,
                                 input RowObject.sc-codigo,
                                 input RowObject.cod-estabel,
                                 input RowObject.cod-unid-negoc).
      if return-value = "NOK":U then do:

          /* Inicio -- Projeto Internacional */
          DEFINE VARIABLE c-rel_conta_contabil AS CHARACTER FORMAT "X(3)" NO-UNDO.
          {utp/ut-liter.i "relacionar Conta Contábil com Estabelecimento ou Unidade de Negócio informados" *}
          ASSIGN c-rel_conta_contabil = TRIM(RETURN-VALUE).

          {method/svc/errors/inserr.i &ErrorNumber="33073" 
                                      &ErrorType="EMS"
                                      &ErrorParameters="c-rel_conta_contabil"}
      end.
  END.

  /** Valida‡Æo do percentual ser maior que 100% **/
  if pType = 'UPDATE':U then
          RUN findPercentUp (INPUT  rowObject.r-rowid,
                             INPUT  rowObject.ct-codigo,
                             INPUT  rowObject.sc-codigo,
                             INPUT  rowObject.ep-codigo,
                             INPUT  rowObject.cod-estabel,
                             INPUT  rowObject.cod-unid-negoc,
                             OUTPUT d-percentual).
  
  ELSE
      RUN findPercent (INPUT  rowObject.ct-codigo,
                       INPUT  rowObject.sc-codigo,
                       INPUT  rowObject.ep-codigo,
                       INPUT  rowObject.cod-estabel,
                       INPUT  rowObject.cod-unid-negoc,
                       OUTPUT d-percentual).
  
  
    if pType <> "DELETE" then do:
        if d-percentual < rowObject.val-perc-ccusto or
            rowObject.val-perc-ccusto > 100  then do:
            {method/svc/errors/inserr.i &ErrorNumber="27454" 
                                        &ErrorType="EMS"
                                        &ErrorParameters="''"}

    end.
  end.
  
                       
/** Valida‡Æo do percentual ser menor ou igual a 0% **/
   IF rowObject.val-perc-ccusto = 0 then do:
      {method/svc/errors/inserr.i &ErrorNumber="27453" 
                                  &ErrorType="EMS"
                                  &ErrorParameters="''"}

   end.
   
   IF VALID-HANDLE(h_api_cta_ctbl) THEN
        DELETE PROCEDURE h_api_cta_ctbl. 
   IF VALID-HANDLE(h_api_ccusto) THEN
        DELETE PROCEDURE h_api_ccusto.


    /*--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorType <> "INTERNAL":U ) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

