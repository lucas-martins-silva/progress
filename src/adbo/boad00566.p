&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
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
&GLOBAL-DEFINE DBOName BOAD00566
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName proces-esocial-suspen
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
{adbo/boad00566.i RowObject}

DEFINE VARIABLE c-cod-process-judic LIKE {&TableName}.cod-process-judic       NO-UNDO.
DEFINE VARIABLE c-CodSeqSuspen      LIKE proces-esocial-suspen.cod-seq-suspen NO-UNDO.


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD isNumeric Procedure
function isNumeric returns logical (textValue as character) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
         HEIGHT             = 14.17
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
        WHEN "cod-process-judic":U THEN ASSIGN pFieldValue = RowObject.cod-process-judic.
        WHEN "cod-seq-suspen":U THEN ASSIGN pFieldValue = RowObject.cod-seq-suspen.
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
        WHEN "cdn-decis-proces":U THEN ASSIGN pFieldValue = RowObject.cdn-decis-proces.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram  
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice prcsscls_id2
  Parameters:  
               retorna valor do campo cdn-emitente
               retorna valor do campo cod-process-judic
               retorna valor do campo cod-imposto
               retorna valor do campo cod-seq-suspen
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE OUTPUT PARAMETER pcod-process-judic LIKE proces-esocial-suspen.cod-process-judic NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-seq-suspen LIKE proces-esocial-suspen.cod-seq-suspen NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-process-judic = RowObject.cod-process-judic
           pcod-seq-suspen = RowObject.cod-seq-suspen.

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
        WHEN "log-depos-mont":U THEN ASSIGN pFieldValue = RowObject.log-depos-mont.
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
  Purpose:     Reposiciona registro com base no °ndice prcsscls_id2
  Parameters:  
               recebe valor do campo cdn-emitente
               recebe valor do campo cod-process-judic
               recebe valor do campo cod-imposto
               recebe valor do campo cod-seq-suspen
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pcod-process-judic LIKE proces-esocial-suspen.cod-process-judic NO-UNDO.
    DEFINE INPUT PARAMETER pcod-seq-suspen LIKE proces-esocial-suspen.cod-seq-suspen NO-UNDO.

    FIND FIRST bfproces-esocial-suspen WHERE 
        bfproces-esocial-suspen.cod-process-judic = pcod-process-judic AND 
        bfproces-esocial-suspen.cod-seq-suspen = pcod-seq-suspen NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfproces-esocial-suspen THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfproces-esocial-suspen)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-codigo-suspensao DBOProgram 
PROCEDURE pi-retorna-codigo-suspensao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER  p-cod-process-judic LIKE proces-esocial-suspen.cod-process-judic NO-UNDO. 
    DEFINE INPUT PARAMETER  p-da-data-emis      LIKE docum-est.dt-emissao                    NO-UNDO.
    DEFINE OUTPUT PARAMETER p-cod-seq-suspen    LIKE proces-esocial-suspen.cod-seq-suspen    NO-UNDO.

    ASSIGN p-cod-seq-suspen = ''.
    FOR EACH  proces-esocial-suspen NO-LOCK
        WHERE proces-esocial-suspen.cod-process-judic   = p-cod-process-judic
        AND   proces-esocial-suspen.dat-resol-judic    <= p-da-data-emis
        BY    proces-esocial-suspen.dat-resol-judic DESC:

        ASSIGN p-cod-seq-suspen =  proces-esocial-suspen.cod-seq-suspen.
        LEAVE.
    END.
    

    RETURN 'OK':U.
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
    
    DEFINE VARIABLE t1             AS CHARACTER NO-UNDO.
    DEFINE VARIABLE t2             AS CHARACTER NO-UNDO.
    
    FIND FIRST proces-esocial-recebimento NO-LOCK
         WHERE proces-esocial-recebimento.cod-process-judic = RowObject.cod-process-judic NO-ERROR.
    
    IF pType = "DELETE" THEN DO:
    
        IF CAN-FIND (FIRST docum-est-esoc 
                     WHERE docum-est-esoc.cod-emitente    = proces-esocial-recebimento.cdn-emitente
                       AND docum-est-esoc.dt-trans       >= proces-esocial-recebimento.dat-inic-valid
                       AND docum-est-esoc.dt-trans       <= proces-esocial-recebimento.dat-fim-valid
                       AND docum-est-esoc.nr-proc-jud     = proces-esocial-recebimento.cod-process-judic
                       AND docum-est-esoc.cod-seq-suspen  = RowObject.cod-seq-suspen) THEN DO:
            
            {utp/ut-liter.i "Processo" *}
            ASSIGN t1 = return-value.
            
            {utp/ut-liter.i "Documento Fiscal" *}
            ASSIGN t2 = return-value.
            
            {method/svc/errors/inserr.i
                 &ErrorNumber="5" 
                 &ErrorType="EMS"
                 &ErrorParameters= "t1  + '~~~~' + t2"}

        END. /*IF CAN-FIND (FIRST docum-est-esoc */

        IF CAN-FIND (FIRST item-nf-adc 
                     WHERE (SUBSTRING(item-nf-adc.cod-livre-1,52,21) = RowObject.cod-process-judic   /* processo principal */
                         OR SUBSTRING(item-nf-adc.cod-livre-3,1,21)  = RowObject.cod-process-judic ) /* processo adicional */
                       AND (SUBSTRING(item-nf-adc.cod-livre-4,1,14)  = RowObject.cod-seq-suspen      /* suspensao principal */
                         OR SUBSTRING(item-nf-adc.cod-livre-4,15,14) = RowObject.cod-seq-suspen)     /* suspensao adicional */ ) THEN DO:

            {utp/ut-liter.i "Processo" *}
            ASSIGN t1 = return-value.
            
            {utp/ut-liter.i "Documento Fiscal" *}
            ASSIGN t2 = return-value.
            
            {method/svc/errors/inserr.i
                 &ErrorNumber="5" 
                 &ErrorType="EMS"
                 &ErrorParameters= "t1  + '~~~~' + t2"}

        END. /*IF CAN-FIND (FIRST item-nf-adc */
        
    END.
    ELSE DO: /*CREATE/UPDATE*/
    
        IF NOT isNumeric(RowObject.cod-seq-suspen) THEN DO:
            {utp/ut-liter.i "A suspens∆o" *}
            t1 = return-value.
            {utp/ut-liter.i "dever† ter somente caracteres numÇricos" *}
            t2 = return-value.

            {method/svc/errors/inserr.i
                    &ErrorNumber="25419"
                    &ErrorType="EMS"
                    &ErrorParameters="t1 + '~~~~' + t2"}
        END. 
    
        IF RowObject.cod-seq-suspen = "" THEN DO:
            {utp/ut-liter.i "suspens∆o" *}
            ASSIGN t1 = return-value.

            {method/svc/errors/inserr.i
                 &ErrorNumber="25144"
                 &ErrorType="EMS"
                 &ErrorParameters="t1"}
        END.

        /* ValidaÁao: Se {indSusp} = [90], preencher obrigatoriamente com [N]. */
        /* Se {indSusp} = [02, 03] preencher obrigatoriamente com [S].         */
        /* Valores V·lidos: S, N.                                              */
        IF RowObject.cdn-decis-proces = 90 AND
           RowObject.log-depos-mont THEN DO:
            {method/svc/errors/inserr.i
                     &ErrorNumber="56473"
                     &ErrorType="EMS"
                     &ErrorParameters=" "}
        END.
        
        IF (RowObject.cdn-decis-proces = 2 OR
            RowObject.cdn-decis-proces = 3) AND
            NOT RowObject.log-depos-mont THEN DO:
            {method/svc/errors/inserr.i
                     &ErrorNumber="56473"
                     &ErrorType="EMS"
                     &ErrorParameters=" "}
        END.
        /***********************************************************************/
        
        IF AVAILABLE proces-esocial-recebimento THEN DO: 
            
            IF proces-esocial-recebimento.idi-proces = 1 THEN DO:  /*Administrativo*/
                /*Se {idi-proces} = [1], deve ser preenchido com [03, 14, 90, 92].*/            
                IF NOT CAN-DO("3,14,90,92", STRING(RowObject.cdn-decis-proces)) THEN DO:
                    {method/svc/errors/inserr.i
                             &ErrorNumber="55566"
                             &ErrorType="EMS"
                             &ErrorParameters=" "}
                END.
            END. /*IF proces-esocial-recebimento.idi-proces = 1*/
            
            IF proces-esocial-recebimento.idi-proces = 2 THEN DO: /*Judici·rio*/
                /*Se {idi-proces} = [2], deve ser preenchido com [01, 02, 04, 05, 08, 09, 10, 11, 12, 13, 90, 92].*/            
                IF NOT CAN-DO("1,2,4,5,8,9,10,11,12,13,90,92", STRING(RowObject.cdn-decis-proces)) THEN DO: 
                    {method/svc/errors/inserr.i
                             &ErrorNumber="55566"
                             &ErrorType="EMS"
                             &ErrorParameters=" "}
                END.
            END. /*IF proces-esocial-recebimento.idi-proces = 2*/

            IF proces-esocial-recebimento.idi-proces = 3 THEN DO: /*N˙mero do benefÌcio (NB) do INSS*/

            END.


            IF proces-esocial-recebimento.idi-proces = 4 THEN DO: /*Processo FAP*/
                /*Se {idi-proces} = [4], deve ser preenchido com [14].*/                
                IF NOT CAN-DO("14", STRING(RowObject.cdn-decis-proces)) THEN DO:
                    {method/svc/errors/inserr.i
                             &ErrorNumber="55566"
                             &ErrorType="EMS"
                             &ErrorParameters=" "}
                END.
            END. /*IF proces-esocial-recebimento.idi-proces = 4*/           

        END. /*AVAILABLE bfproces-esocial-suspen*/

    END. /*CREATE/UPDATE*/

    IF pType = "CREATE":U THEN DO:

        IF CAN-FIND (FIRST proces-esocial-suspen
                     WHERE proces-esocial-suspen.cod-process-judic = RowObject.cod-process-judic 
                       AND proces-esocial-suspen.cod-seq-suspen    = RowObject.cod-seq-suspen) THEN DO:    
            {method/svc/errors/inserr.i
                 &ErrorNumber="1" 
                 &ErrorType="EMS"
                 &ErrorParameters= "'Suspens∆o'"}    
        END. /*IF CAN-FIND (FIRST proces-esocial-suspen*/
    
    END. /*IF pType = "CREATE":U*/
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintProcesso DBOProgram 
PROCEDURE setConstraintProcesso :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAM p-cod-process-judic LIKE {&TableName}.cod-process-judic NO-UNDO.
        
    ASSIGN c-cod-process-judic = p-cod-process-judic.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryProcesso DBOProgram 
PROCEDURE openQueryProcesso :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
       
   OPEN QUERY {&QueryName} FOR EACH {&TableName}
        WHERE {&TableName}.cod-process-judic = c-cod-process-judic NO-LOCK INDEXED-REPOSITION.

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

