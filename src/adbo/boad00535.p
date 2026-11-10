&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/*:T---------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) ‚ um programa PROGRESS 
                 que cont‚m a l¢gica de neg¢cio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ****************************  Definitions  **************************** */
{include/i-prgvrs.i BOAD00535 2.00.00.016 } /*** "010016" 13/11/2023 11:45:42 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boad00535 MUT}
&ENDIF


/*:T--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName BOAD00535
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName proces-esocial-recebimento
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
{adbo/boad00535.i RowObject}

DEFINE VARIABLE h-dbo-imposto       AS HANDLE NO-UNDO.
DEFINE VARIABLE h-reg-imposto       AS HANDLE NO-UNDO.
DEFINE VARIABLE hCampoDBO           AS HANDLE NO-UNDO.
DEFINE VARIABLE h-dbo-classif-impto AS HANDLE NO-UNDO.

DEFINE VARIABLE i-emitente-ini LIKE {&TableName}.cdn-emitente NO-UNDO.
DEFINE VARIABLE i-emitente-fim LIKE {&TableName}.cdn-emitente NO-UNDO.

DEFINE VARIABLE da-dat-inic-valid-ini LIKE {&TableName}.dat-inic-valid NO-UNDO.
DEFINE VARIABLE da-dat-inic-valid-fim LIKE {&TableName}.dat-inic-valid NO-UNDO.
DEFINE VARIABLE da-dat-fim-valid-ini  LIKE {&TableName}.dat-fim-valid NO-UNDO.
DEFINE VARIABLE da-dat-fim-valid-fim  LIKE {&TableName}.dat-fim-valid NO-UNDO.
DEFINE VARIABLE i-tp-processo         LIKE {&TableName}.idi-retenc    NO-UNDO.
DEFINE VARIABLE da-dat-emis           AS DATE        NO-UNDO.
DEFINE VARIABLE da-i-cd-emit          AS INTEGER     NO-UNDO.    

/*Defini‡Æo temp-table integra‡Æo EMS5*/
def temp-table tt_process
    field tta_cod_process_judic            as character format "x(20)"
    field ttv_cdn_emitente                 as Integer format ">>>>>>>>9"
    field tta_cod_imposto                  as character format "x(5)"
    field tta_val_aliq_iibb                as decimal format ">>9.99"
    .

/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.


function isNumeric returns logical (textValue as character):
    define variable i as integer no-undo.

    if textValue = ? then return false.

    do i = 1 to (length(textValue)):
        int(substring(textValue, i, (1))) no-error.
        if error-status:error then return false.
    end.

    return true.
end function.

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
        WHEN "cod-imposto":U THEN ASSIGN pFieldValue = RowObject.cod-imposto.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-process-judic":U THEN ASSIGN pFieldValue = RowObject.cod-process-judic.
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
        WHEN "dat-fim-valid":U THEN ASSIGN pFieldValue = RowObject.dat-fim-valid.
        WHEN "dat-inic-valid":U THEN ASSIGN pFieldValue = RowObject.dat-inic-valid.
        WHEN "dat-livre-1":U THEN ASSIGN pFieldValue = RowObject.dat-livre-1.
        WHEN "dat-livre-2":U THEN ASSIGN pFieldValue = RowObject.dat-livre-2.
        WHEN "dat-resol-judic":U THEN ASSIGN pFieldValue = RowObject.dat-resol-judic.
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
        WHEN "percentual":U THEN ASSIGN pFieldValue = RowObject.percentual.
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
        WHEN "cdn-emitente":U THEN ASSIGN pFieldValue = RowObject.cdn-emitente.
        WHEN "idi-proces":U THEN ASSIGN pFieldValue = RowObject.idi-proces.
        WHEN "cdn-seq-suspen":U THEN ASSIGN pFieldValue = RowObject.cdn-seq-suspen.
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
  Purpose:     Retorna valores dos campos do ¡ndice prcssclr_id2
  Parameters:  
               retorna valor do campo cdn-emitente
               retorna valor do campo cod-process-judic
               retorna valor do campo cod-imposto
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcdn-emitente LIKE proces-esocial-recebimento.cdn-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-process-judic LIKE proces-esocial-recebimento.cod-process-judic NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-imposto LIKE proces-esocial-recebimento.cod-imposto NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcdn-emitente = RowObject.cdn-emitente
           pcod-process-judic = RowObject.cod-process-judic
           pcod-imposto = RowObject.cod-imposto.

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
        WHEN "log-livre-1":U THEN ASSIGN pFieldValue = RowObject.log-livre-1.
        WHEN "log-livre-2":U THEN ASSIGN pFieldValue = RowObject.log-livre-2.
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
  Purpose:     Reposiciona registro com base no ¡ndice prcssclr_id2
  Parameters:  
               recebe valor do campo cdn-emitente
               recebe valor do campo cod-process-judic
               recebe valor do campo cod-imposto
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcdn-emitente LIKE proces-esocial-recebimento.cdn-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pcod-process-judic LIKE proces-esocial-recebimento.cod-process-judic NO-UNDO.
    DEFINE INPUT PARAMETER pcod-imposto LIKE proces-esocial-recebimento.cod-imposto NO-UNDO.

    FIND FIRST bfproces-esocial-recebimento WHERE 
        bfproces-esocial-recebimento.cdn-emitente = pcdn-emitente AND 
        bfproces-esocial-recebimento.cod-process-judic = pcod-process-judic AND 
        bfproces-esocial-recebimento.cod-imposto = pcod-imposto NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfproces-esocial-recebimento THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfproces-esocial-recebimento)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryData DBOProgram 
PROCEDURE openQueryData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
       
        OPEN QUERY {&QueryName} FOR EACH {&TableName}
        WHERE {&TableName}.dat-inic-valid >= da-dat-inic-valid-ini
          AND {&TableName}.dat-inic-valid <= da-dat-inic-valid-fim 
          AND {&TableName}.dat-fim-valid  >= da-dat-fim-valid-ini
          AND {&TableName}.dat-fim-valid  <= da-dat-fim-valid-fim 
          AND ({&TableName}.idi-retenc     = i-tp-processo OR i-tp-processo = 3 )    NO-LOCK INDEXED-REPOSITION.

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryData2 DBOProgram 
PROCEDURE openQueryData2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        OPEN QUERY {&QueryName} FOR EACH {&TableName}
        WHERE {&TableName}.dat-inic-valid >= da-dat-inic-valid-ini
          AND {&TableName}.dat-inic-valid <= da-dat-inic-valid-fim 
          AND {&TableName}.dat-fim-valid  >= da-dat-fim-valid-ini
          AND {&TableName}.dat-fim-valid  <= da-dat-fim-valid-fim 
          AND {&TableName}.dat-inic-valid <=  da-dat-emis
          AND {&TableName}.dat-fim-valid  >=  da-dat-emis
          AND {&TableName}.cdn-emitente    =  da-i-cd-emit 
          AND ({&TableName}.idi-retenc     = i-tp-processo OR i-tp-processo = 3 ) NO-LOCK INDEXED-REPOSITION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryEmitente DBOProgram 
PROCEDURE openQueryEmitente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH {&TableName}
        WHERE {&TableName}.cdn-emitente >= i-emitente-ini
          AND {&TableName}.cdn-emitente <= i-emitente-fim
          AND ({&TableName}.idi-retenc     = i-tp-processo OR i-tp-processo = 3 )    NO-LOCK INDEXED-REPOSITION.

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

    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK INDEXED-REPOSITION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintData DBOProgram 
PROCEDURE setConstraintData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAM p-da-dat-inic-valid-ini LIKE {&TableName}.dat-inic-valid NO-UNDO.
    DEFINE INPUT PARAM p-da-dat-inic-valid-fim LIKE {&TableName}.dat-inic-valid NO-UNDO.
    DEFINE INPUT PARAM p-da-dat-fim-valid-ini  LIKE {&TableName}.dat-fim-valid  NO-UNDO.
    DEFINE INPUT PARAM p-da-dat-fim-valid-fim  LIKE {&TableName}.dat-fim-valid  NO-UNDO.
    DEFINE INPUT PARAM p-i-tp-processo         LIKE {&TableName}.idi-retenc     NO-UNDO.
    
    ASSIGN da-dat-inic-valid-ini = p-da-dat-inic-valid-ini
           da-dat-inic-valid-fim = p-da-dat-inic-valid-fim
           da-dat-fim-valid-ini  = p-da-dat-fim-valid-ini 
           da-dat-fim-valid-fim  = p-da-dat-fim-valid-fim
           i-tp-processo         = p-i-tp-processo.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintData2 DBOProgram 
PROCEDURE setConstraintData2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAM p-da-dat-inic-valid-ini LIKE {&TableName}.dat-inic-valid NO-UNDO.
    DEFINE INPUT PARAM p-da-dat-inic-valid-fim LIKE {&TableName}.dat-inic-valid NO-UNDO.
    DEFINE INPUT PARAM p-da-dat-fim-valid-ini  LIKE {&TableName}.dat-fim-valid  NO-UNDO.
    DEFINE INPUT PARAM p-da-dat-fim-valid-fim  LIKE {&TableName}.dat-fim-valid  NO-UNDO.
    DEFINE INPUT PARAM p-i-tp-processo         LIKE {&TableName}.idi-retenc     NO-UNDO.
    DEFINE INPUT PARAM p-d-data-emis           AS DATE        NO-UNDO.
    DEFINE INPUT PARAM p-i-cd-emit             AS INTEGER     NO-UNDO.    
    
    ASSIGN da-dat-inic-valid-ini = p-da-dat-inic-valid-ini
           da-dat-inic-valid-fim = p-da-dat-inic-valid-fim
           da-dat-fim-valid-ini  = p-da-dat-fim-valid-ini 
           da-dat-fim-valid-fim  = p-da-dat-fim-valid-fim
           i-tp-processo         = p-i-tp-processo
           da-dat-emis           = p-d-data-emis
           da-i-cd-emit          = p-i-cd-emit.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintEmitente DBOProgram 
PROCEDURE setConstraintEmitente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAM p-emitente-ini  LIKE {&TableName}.cdn-emitente NO-UNDO.
    DEFINE INPUT PARAM p-emitente-fim  LIKE {&TableName}.cdn-emitente NO-UNDO.
    DEFINE INPUT PARAM p-i-tp-processo LIKE {&TableName}.idi-retenc   NO-UNDO.

    ASSIGN i-emitente-ini = p-emitente-ini 
           i-emitente-fim = p-emitente-fim
           i-tp-processo  = p-i-tp-processo.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
    
    DEFINE VARIABLE c-ind-tip-impto      AS CHARACTER FORMAT "X(35)":U  NO-UNDO.
    DEFINE VARIABLE c-pais               AS CHARACTER                   NO-UNDO.
    DEFINE VARIABLE c-estado             AS CHARACTER                   NO-UNDO.
    DEFINE VARIABLE c-lbl-liter-Imposto  AS CHARACTER                   NO-UNDO.
    DEFINE VARIABLE c-lbl-liter-Impostos AS CHARACTER                   NO-UNDO.
    DEFINE VARIABLE t1                   AS CHARACTER                   NO-UNDO.
    DEFINE VARIABLE t2                   AS CHARACTER                   NO-UNDO.

    /*:T--- Utilize o parƒmetro pType para identificar quais as valida‡äes a serem
          executadas ---*/
    /*:T--- Os valores poss¡veis para o parƒmetro sÆo: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as valida‡äes ---*/
    IF pType = "Delete":U THEN DO:

        IF CAN-FIND (FIRST docum-est-esoc 
                     WHERE docum-est-esoc.cod-emitente = RowObject.cdn-emitente
                       AND docum-est-esoc.dt-trans    >= RowObject.dat-inic-valid
                       AND docum-est-esoc.dt-trans    <= RowObject.dat-fim-valid
                       AND docum-est-esoc.nr-proc-jud  = RowObject.cod-process-judic) THEN DO:
            {method/svc/errors/inserr.i
                 &ErrorNumber="5" 
                 &ErrorType="EMS"
                 &ErrorParameters= "'Processo'  + '~~~~' + 'Documento Fiscal'"}

        END.

        IF CAN-FIND (FIRST item-nf-adc 
                     WHERE item-nf-adc.cdn-emitente = RowObject.cdn-emitente         /* emitente */
                       AND (SUBSTRING(item-nf-adc.cod-livre-1,52,21) = RowObject.cod-process-judic   /* processo principal */
                         OR SUBSTRING(item-nf-adc.cod-livre-3,1,21)  = RowObject.cod-process-judic ) /* processo adicional */ ) THEN DO:
            {method/svc/errors/inserr.i
                 &ErrorNumber="5" 
                 &ErrorType="EMS"
                 &ErrorParameters= "'Processo'  + '~~~~' + 'Documento Fiscal'"}

        END.

    END.

    IF pType = "Update":U THEN DO:

        IF RowObject.idi-retenc = 1 THEN DO:
            IF CAN-FIND (FIRST item-nf-adc 
                         WHERE item-nf-adc.cdn-emitente = RowObject.cdn-emitente         /* emitente */
                           AND SUBSTRING(item-nf-adc.cod-livre-3,1,21) = RowObject.cod-process-judic /* processo adicional */ ) THEN DO:
                {method/svc/errors/inserr.i
                     &ErrorNumber="781" 
                     &ErrorType="EMS"
                     &ErrorParameters= "'reten‡Æo'"}
            
            END.
        END.

        IF RowObject.idi-retenc = 2 THEN DO:
            IF CAN-FIND (FIRST item-nf-adc 
                         WHERE item-nf-adc.cdn-emitente = RowObject.cdn-emitente         /* emitente */
                           AND SUBSTRING(item-nf-adc.cod-livre-1,52,21) = RowObject.cod-process-judic /* processo principal */ ) THEN DO:
                {method/svc/errors/inserr.i
                     &ErrorNumber="781" 
                     &ErrorType="EMS"
                     &ErrorParameters= "'reten‡Æo'"}
            
            END.
        END.

    END.

    IF pType <> "Delete":U THEN DO: 
    
        /*Testar se foram digitados somente números*/
        IF NOT isNumeric(RowObject.cod-process-judic) THEN DO:

            {utp/ut-liter.i "O processo" *}
            t1 = return-value.
            {utp/ut-liter.i "dever  ter somente caracteres num‚ricos" *}
            t2 = return-value.

            {method/svc/errors/inserr.i
                    &ErrorNumber="25419"
                    &ErrorType="EMS"
                    &ErrorParameters="t1 + '~~~~' + t2"}

        END.
    
        IF RowObject.num-livre-1 = 1 THEN DO:  /*eSocial*/
            /* O número do processo deverá ter &1 algarismos!
               Se {tpProc} (tipo do processo) = [&2], {nrProc} deve possuir &1 algarismos.  */
            IF RowObject.idi-proces = 1 THEN DO:  /*Administrativo*/
                IF LENGTH(RowObject.cod-process-judic) <> 17 AND 
                   LENGTH(RowObject.cod-process-judic) <> 21 THEN DO: 
                   
                    {utp/ut-liter.i "17 ou 21" *}
                    t1 = return-value.
                    {utp/ut-liter.i "administrativo" *}
                    t2 = return-value.
                   
                    {method/svc/errors/inserr.i
                        &ErrorNumber="56470"
                        &ErrorType="EMS"
                        &ErrorParameters="t1 + '~~~~' + t2"}
                END.
            END.
            
            IF RowObject.idi-proces = 2 THEN DO: /*Judiciário*/
                IF LENGTH(RowObject.cod-process-judic) <> 20 THEN DO: 
                
                    {utp/ut-liter.i "20" *}
                    t1 = return-value.
                    {utp/ut-liter.i "judici rio" *}
                    t2 = return-value.
                
                    {method/svc/errors/inserr.i
                        &ErrorNumber="56470"
                        &ErrorType="EMS"
                        &ErrorParameters="t1 + '~~~~' + t2"}                   
                END.
            END.
            
            IF RowObject.idi-proces = 3 THEN DO: /*Número do benefício (NB) do INSS*/
                IF LENGTH(RowObject.cod-process-judic) <> 10 THEN DO: 
                
                    {utp/ut-liter.i "10" *}
                    t1 = return-value.
                    {utp/ut-liter.i "N£mero do benef¡cio (NB) do INSS" *}
                    t2 = return-value.
                
                    {method/svc/errors/inserr.i
                        &ErrorNumber="56470"
                        &ErrorType="EMS"
                        &ErrorParameters="t1 + '~~~~' + t2"}
                END.
            END.
            
            IF RowObject.idi-proces = 4 THEN DO: /*Processo FAP*/ 
                IF LENGTH(RowObject.cod-process-judic) <> 16 THEN DO: 
                
                    {utp/ut-liter.i "16" *}
                    t1 = return-value.
                    {utp/ut-liter.i "Processo FAP" *}
                    t2 = return-value.
                
                    {method/svc/errors/inserr.i
                        &ErrorNumber="56470"
                        &ErrorType="EMS"
                        &ErrorParameters="t1 + '~~~~' + t2"}
                END.
            END. 
        END.

        IF  NOT VALID-HANDLE(h-dbo-imposto) THEN
            RUN prgint/utb/utb944wb.py PERSISTENT SET h-dbo-imposto NO-ERROR.

        IF pType = "Create":U THEN
        IF CAN-FIND (FIRST {&TableName}
                     WHERE {&TableName}.cdn-emitente      = RowObject.cdn-emitente
                       AND {&TableName}.cod-process-judic = RowObject.cod-process-judic
                       AND {&TableName}.cod-imposto       = RowObject.cod-imposto
                       AND {&TableName}.dat-inic-valid    <= RowObject.dat-inic-valid
                       AND {&TableName}.dat-fim-valid     >= RowObject.dat-fim-valid) THEN DO:
        
            {method/svc/errors/inserr.i
                 &ErrorNumber="33823"
                 &ErrorType="EMS"
                 &ErrorParameters=" "}
        
        END.

        IF RowObject.dat-inic-valid > RowObject.dat-fim-valid THEN DO:
        
            {method/svc/errors/inserr.i
                 &ErrorNumber="198"
                 &ErrorType="EMS"
                 &ErrorParameters=" "}
        
        END.

        IF RowObject.percentual > 100 THEN DO:
        
            {method/svc/errors/inserr.i
                 &ErrorNumber="4328"
                 &ErrorType="EMS"
                 &ErrorParameters=" "}
        
        END.

        IF RowObject.percentual <= 0 THEN DO:
        
            {method/svc/errors/inserr.i
                 &ErrorNumber="1470"
                 &ErrorType="EMS"
                 &ErrorParameters=" "}
        
        END.

        IF NOT CAN-FIND (FIRST emitente
                         WHERE emitente.cod-emitente = RowObject.cdn-emitente) THEN DO:

            {method/svc/errors/inserr.i
                 &ErrorNumber="2804"
                 &ErrorType="EMS"
                 &ErrorParameters=" "}
        END.

        /* teste se tipo de imposto é válido para o eSocial */
        ASSIGN c-pais   = "BRA"
               c-estado = "".
        IF  VALID-HANDLE(h-dbo-imposto) THEN DO:
          
            RUN GetTipoImposto(INPUT RowObject.cod-imposto ,
                       INPUT "BRA"         ,
                       INPUT ""            ,
                       OUTPUT c-ind-tip-impto).

            IF (c-ind-tip-impto <> "Inst Nacional Seguro Social (INSS)":U AND /* INSS */        
                c-ind-tip-impto <> "SEST/SENAT":U                         AND /* SEST/SENAT */  
                c-ind-tip-impto = "GILRAT":U )                            AND  /* GILRAT */  
                c-ind-tip-impto <> "Imposto de Renda Retido na Fonte":U   AND  /*IR*/
                c-ind-tip-impto <> "Imposto COFINS  PIS  CSLL Retido":U     THEN DO: 

                {method/svc/errors/inserr.i
                     &ErrorNumber="6959"
                     &ErrorType="EMS"
                     &ErrorParameters=" "}

            END.
            
        END. /* IF  VALID-HANDLE(h-dbo-imposto) */        
        /****************************************************/

        /*verifica se a classifica‡Æo do imposto tela pertence a esta*/
        IF NOT VALID-HANDLE(h-dbo-classif-impto) THEN
          RUN prgint/utb/utb944wc.py PERSISTENT SET h-dbo-classif-impto NO-ERROR.
        
        IF  VALID-HANDLE(h-dbo-classif-impto) THEN DO:
          /*--- monta a query para pesquisar se o imposto informado em tela existe no EMS5 ---*/
          RUN setQueryWhere IN h-dbo-classif-impto ("classif_impto.cod_imposto = '":U            + RowObject.cod-imposto       + "'":U +
                                                    " and classif_impto.cod_classif_impto = '":U + RowObject.cod-classif-impto + "'":U + 
                                                    " and classif_impto.cod_pais = '":U          + STRING(c-pais)              + "'":U +        
                                                    " and classif_impto.cod_unid_federac = '":U  + STRING(c-estado)            + "'":U ).  
          /*--- abre a query dinamica e posiciona no primeiro registro ---*/
          RUN openQueryDynamic IN h-dbo-classif-impto.
          RUN getFirst IN h-dbo-classif-impto.
          
          IF RETURN-VALUE = "NOK" THEN DO:
            
            {utp/ut-liter.i "Classifica‡Æo_de_Imposto" *}
            ASSIGN c-lbl-liter-Imposto = TRIM(RETURN-VALUE).
          
            {utp/ut-liter.i "Classifica‡Æo_de_Impostos_com_Pa¡s: " *}
            ASSIGN c-lbl-liter-Impostos = TRIM(RETURN-VALUE)   + " " + STRING(c-pais)
                                        + ", Unidade da Federa‡Æo: " + STRING(c-estado)
                                        + " e Imposto: "             + RowObject.cod-imposto.
            
            {method/svc/errors/inserr.i
                 &ErrorNumber="4704"
                 &ErrorType="EMS"
                 &ErrorSubType="ERROR"
                 &ErrorParameters="c-lbl-liter-Imposto + '~~~~' + c-lbl-liter-Impostos"}
          END.        
        END.

        DELETE PROCEDURE h-dbo-classif-impto NO-ERROR.
        ASSIGN h-dbo-classif-impto = ? NO-ERROR.
        /* fim verifica se a classifica‡Æo do imposto tela pertence a esta*/

        IF RowObject.cod-vara = "" THEN DO:
    
            {method/svc/errors/inserr.i
                     &ErrorNumber="25144"
                     &ErrorType="EMS"
                     &ErrorParameters="'vara'"}

        END.

        IF RowObject.cdn-munpio-ibge = 0 THEN DO:
    
            {method/svc/errors/inserr.i
                     &ErrorNumber="25144"
                     &ErrorType="EMS"
                     &ErrorParameters="'municipio'"}

        END.

        IF VALID-HANDLE(h-dbo-imposto) THEN DO:
            DELETE PROCEDURE h-dbo-imposto.
            ASSIGN h-dbo-imposto = ?.
        END.    

    END.

    /*:T--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */

&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDeleteRecord DBOProgram 
PROCEDURE afterDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /*Somente eliminar a suspensÆo, quando nÆo houver mais nenhum processo relacionado a ela*/
    IF NOT CAN-FIND (FIRST bfproces-esocial-recebimento
                     WHERE bfproces-esocial-recebimento.cod-process-judic = RowObject.cod-process-judic) THEN DO:
        FOR EACH proces-esocial-suspen EXCLUSIVE-LOCK
            WHERE proces-esocial-suspen.cod-process-judic = RowObject.cod-process-judic:
            DELETE proces-esocial-suspen.
        END.
    END.
   
    RETURN "OK":U.

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE VldRetByTipoImposto DBOProgram 
PROCEDURE VldRetByTipoImposto :
/*--------------------------------------------------------------------------------
  Purpose: Valida a utiliza‡Æo do Radio Rente‡Æo de acordo com o tipo de imposto
  Parameters:  <none>
  Notes:       
--------------------------------------------------------------------------------*/
    
    DEFINE VARIABLE c-ind-tip-impto      AS CHARACTER FORMAT "X(35)":U  NO-UNDO.
    DEFINE VARIABLE c-pais               AS CHARACTER                   NO-UNDO.
    DEFINE VARIABLE c-estado             AS CHARACTER                   NO-UNDO.
    DEFINE INPUT   PARAM  p-cod-imposto  AS CHARACTER                   NO-UNDO.
    DEFINE OUTPUT  PARAM  p-retido         AS LOGICAL INITIAL YES         NO-UNDO.


    RUN GetTipoImposto(INPUT p-cod-imposto ,
                       INPUT "BRA"         ,
                       INPUT ""            ,
                       OUTPUT c-ind-tip-impto).
    IF  c-ind-tip-impto <> "Inst Nacional Seguro Social (INSS)":U 
    AND c-ind-tip-impto <> "Imposto de Renda Retido na Fonte":U 
    AND c-ind-tip-impto <> "Imposto COFINS  PIS  CSLL Retido":U  THEN DO: 
        ASSIGN p-retido = NO.
    END.
                            
END PROCEDURE.
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetTipoImposto DBOProgram 
PROCEDURE GetTipoImposto :
/*--------------------------------------------------------------------------------
  Purpose: Retorna o tipo de imposto
  Parameters:  <none>
  Notes:       
--------------------------------------------------------------------------------*/
    DEFINE INPUT   PARAM  p-cod-imposto  AS CHARACTER                   NO-UNDO.
    DEFINE INPUT   PARAM  p-pais         AS CHARACTER                   NO-UNDO.
    DEFINE INPUT   PARAM  p-estado       AS CHARACTER                   NO-UNDO.
    DEFINE OUTPUT  PARAM  p-ind-tip-impto  AS CHARACTER FORMAT "X(35)":U  NO-UNDO.

    IF  NOT VALID-HANDLE(h-dbo-imposto) THEN
        RUN prgint/utb/utb944wb.py PERSISTENT SET h-dbo-imposto NO-ERROR.
    
    IF  VALID-HANDLE(h-dbo-imposto) THEN DO:
            /*--- monta a query  ---*/
        RUN setQueryWhere IN h-dbo-imposto  (  "imposto.cod_pais         = '":U + STRING(p-pais)          + "'":U +
                                               " AND imposto.cod_unid_federac = '":U + STRING(p-estado)        + "'":U +
                                               " AND imposto.cod_imposto      = '":U + p-cod-imposto    + "'":U).
            
            /*--- abre a query dinamica e posiciona no primeiro registro ---*/
        RUN openQueryDynamic IN h-dbo-imposto.
        
            /*RUN pi_reposition_record IN h-dbo-imposto (INPUT v_rec_imposto).*/
        RUN getFirst IN h-dbo-imposto.
        
            /*--- busca handle do registro para ler os dados da tabela impostos (ems5) ---*/
        RUN getRecordInHandle IN h-dbo-imposto(OUTPUT h-reg-imposto).
            
            /*valores dos campos em tela*/
        ASSIGN hCampoDBO       = h-reg-imposto:BUFFER-FIELD("ind_tip_impto":U)
               p-ind-tip-impto = hCampoDBO:BUFFER-VALUE NO-ERROR.
    END. /* IF  VALID-HANDLE(h-dbo-imposto) */  
    
    IF VALID-HANDLE(h-dbo-imposto) THEN DO:
        DELETE PROCEDURE h-dbo-imposto.
        ASSIGN h-dbo-imposto = ?.
    END.
 END PROCEDURE.
&ANALYZE-RESUME

 &ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaProcessos DBOProgram 
PROCEDURE retornaProcessos :
/*--------------------------------------------------------------------------------
  Purpose: Retorna o tipo de imposto
  Parameters:  <none>
  Notes:       
--------------------------------------------------------------------------------*/

    define variable c-ind-tip-impto     as character format "X(35)":U  no-undo.

    define input  param p-cdn-emitente  as integer   no-undo.
    define input  param p-data          as date      no-undo.
    define input  param p-legislacao    as character no-undo.
    define input  param p-cod-impto     as character no-undo.
    define output parameter table for tt_process.

    for each tt_process exclusive-lock:
        delete tt_process.
    end.

    if p-cod-impto = "" then do:
        for each bf{&TableName} no-lock
            where bf{&TableName}.cdn-emitente      = p-cdn-emitente
              and bf{&TableName}.dat-inic-valid    <= p-data
              and bf{&TableName}.dat-fim-valid     >= p-data:
            if p-legislacao = "reinf" then do:
                run GetTipoImposto(input bf{&TableName}.cod-imposto,
                                   input "BRA",
                                   input "",
                                   output c-ind-tip-impto).

                if c-ind-tip-impto = "Inst Nacional Seguro Social (INSS)":U /* INSS */  
                OR c-ind-tip-impto = "Imposto de Renda Retido na Fonte":U 
                OR c-ind-tip-impto = "Imposto COFINS  PIS  CSLL Retido":U  THEN DO: 
                    create tt_process.
                    assign tt_process.tta_cod_process_judic = bf{&TableName}.cod-process-judic
                           tt_process.ttv_cdn_emitente      = bf{&TableName}.cdn-emitente
                           tt_process.tta_cod_imposto       = bf{&TableName}.cod-imposto
                           tt_process.tta_val_aliq_iibb     = bf{&TableName}.percentual.
                end.
            end.
        end.
    end.
    else do:
        for each bf{&TableName} no-lock
            where bf{&TableName}.cdn-emitente      = p-cdn-emitente
              and bf{&TableName}.cod-imposto       = p-cod-impto
              and bf{&TableName}.dat-inic-valid    <= p-data
              and bf{&TableName}.dat-fim-valid     >= p-data:
            if p-legislacao = "reinf" then do:
                run GetTipoImposto(input p-cod-impto,
                                   input "BRA",
                                   input "",
                                   output c-ind-tip-impto).

                if c-ind-tip-impto = "Inst Nacional Seguro Social (INSS)":U /* INSS */  
                OR c-ind-tip-impto = "Imposto de Renda Retido na Fonte":U 
                OR c-ind-tip-impto = "Imposto COFINS  PIS  CSLL Retido":U  THEN DO: 

                    create tt_process.
                    assign tt_process.tta_cod_process_judic = bf{&TableName}.cod-process-judic
                           tt_process.ttv_cdn_emitente      = bf{&TableName}.cdn-emitente
                           tt_process.tta_cod_imposto       = bf{&TableName}.cod-imposto
                           tt_process.tta_val_aliq_iibb     = bf{&TableName}.percentual.
                end.
            end.
        end.
    end.

    RETURN "OK":U.

    
 END PROCEDURE.
&ANALYZE-RESUME

 &ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaRegistroProcesso DBOProgram 
PROCEDURE validaRegistroProcesso :
/*--------------------------------------------------------------------------------
  Purpose: Retorna o tipo de imposto
  Parameters:  <none>
  Notes:       
--------------------------------------------------------------------------------*/

    define variable c-ind-tip-impto     as character format "X(35)":U  no-undo.
    define variable v_log_retido          as logical                     no-undo.

    define input  param p-cdn-emitente      as integer   no-undo.
    define input  param p-cod-process-judic as character no-undo.
    define input  param p-cod-impto         as character no-undo.
    define input  param p-data              as date      no-undo.
    define output parameter pLogRegValido   as logical   no-undo.

    assign pLogRegValido = no.

    if p-cod-impto = "" then do: /*acr*/
        assign v_log_retido = no.
        acr_blk:
        for each bf{&TableName} no-lock
            where bf{&TableName}.cdn-emitente      = p-cdn-emitente
              and bf{&TableName}.cod-process-judic = p-cod-process-judic
              and bf{&TableName}.dat-inic-valid   <= p-data
              and bf{&TableName}.dat-fim-valid    >= p-data:

            if v_log_retido = yes then leave acr_blk.

            run GetTipoImposto(input bf{&TableName}.cod-imposto,
                               input "BRA",
                               input "",
                               output c-ind-tip-impto).

            if c-ind-tip-impto = "Inst Nacional Seguro Social (INSS)":U /* INSS */ 
            OR c-ind-tip-impto = "Imposto de Renda Retido na Fonte":U 
            OR c-ind-tip-impto = "Imposto COFINS  PIS  CSLL Retido":U  THEN DO: 

                assign pLogRegValido = yes
                       v_log_retido    = yes.
            end.
        end.
    end.
    else do: /*apb*/
        find first bf{&TableName} no-lock
            where bf{&TableName}.cdn-emitente      = p-cdn-emitente
              and bf{&TableName}.cod-process-judic = p-cod-process-judic
              and bf{&TableName}.cod-imposto       = p-cod-impto
              and bf{&TableName}.dat-inic-valid   <= p-data
              and bf{&TableName}.dat-fim-valid    >= p-data no-error.
        if avail bf{&TableName} then do:
            assign pLogRegValido = yes.
        end.
    end.

    return "OK":U.

    
 END PROCEDURE.
&ANALYZE-RESUME
