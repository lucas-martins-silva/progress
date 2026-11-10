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
{include/i-prgvrs.i BOCX356 2.00.00.002} /*** "010002" 11/12/2023 10:13:26 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOCX356 MUT}
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
&GLOBAL-DEFINE DBOName BOCX356
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName proces-acond-volum
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
{cxbo/bocx356.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE c-cod-estabel AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-nr-proc-exp AS CHARACTER  NO-UNDO.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDeleteRecord DBOProgram 
PROCEDURE beforeDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE h-bocx354 AS HANDLE     NO-UNDO.  /*---  proces-acond-item ---*/
    DEFINE VARIABLE h-bocx352 AS HANDLE     NO-UNDO.  /*---  proces-embal-resum ---*/
    DEFINE VARIABLE h-bocx353 AS HANDLE     NO-UNDO.  /*---  proces-embal-volum ---*/

    IF NOT VALID-HANDLE(h-bocx354) THEN RUN cxbo/bocx354.p PERSISTENT SET h-bocx354.
    IF NOT VALID-HANDLE(h-bocx352) THEN RUN cxbo/bocx352.p PERSISTENT SET h-bocx352.
    IF NOT VALID-HANDLE(h-bocx353) THEN RUN cxbo/bocx353.p PERSISTENT SET h-bocx353.

    /*--- Limpa RowErrors ---*/      
    RUN emptyRowErrors IN h-bocx354.
    RUN emptyRowErrors IN h-bocx352.
    RUN emptyRowErrors IN h-bocx353.

    DO TRANS ON ERROR UNDO:

        /*--- Elimina proces-embal-volum -----------------------------------------------*/
        RUN openQueryStatic IN h-bocx353 (INPUT "Main":U).
        FOR EACH proces-embal-volum
           WHERE proces-embal-volum.cod-estabel     = RowObject.cod-estabel
             AND proces-embal-volum.nr-proc-exp     = RowObject.nr-proc-exp
             AND proces-embal-volum.cod-acond       = RowObject.cod-acond
             AND proces-embal-volum.num-volum-acond = RowObject.num-volum-acond NO-LOCK:
    
             RUN repositionRecord IN h-bocx353 (ROWID(proces-embal-volum)).
             RUN deleteRecord     IN h-bocx353.
    
             IF RETURN-VALUE <> 'OK':U THEN DO:
                RUN getRowErrors IN h-bocx353 (OUTPUT TABLE rowErrors APPEND).
                /*--- Elimina da tabela de erros , os erros internos ---*/
                FOR EACH RowErrors 
                   WHERE RowErrors.ErrorType = "INTERNAL":U:
                   DELETE RowErrors.
                END.
             END.
        END.              
        IF VALID-HANDLE(h-bocx353) THEN RUN destroy IN h-bocx353.

        /*--- Elimina proces-embal-resum -----------------------------------------------*/
        RUN openQueryStatic IN h-bocx352 (INPUT "Main":U).
        FOR EACH proces-embal-resum
           WHERE proces-embal-resum.cod-estabel     = RowObject.cod-estabel
             AND proces-embal-resum.nr-proc-exp     = RowObject.nr-proc-exp
             AND proces-embal-resum.cod-acond       = RowObject.cod-acond
             AND proces-embal-resum.num-volum-acond = RowObject.num-volum-acond  NO-LOCK:
    
             RUN repositionRecord IN h-bocx352 (ROWID(proces-embal-resum)).
             RUN deleteRecord     IN h-bocx352.
    
             IF RETURN-VALUE <> 'OK':U THEN DO:
                RUN getRowErrors IN h-bocx352 (OUTPUT TABLE rowErrors APPEND).
                /*--- Elimina da tabela de erros , os erros internos ---*/
                FOR EACH RowErrors 
                   WHERE RowErrors.ErrorType = "INTERNAL":U:
                   DELETE RowErrors.
                END.
             END.
        END.              
        IF VALID-HANDLE(h-bocx352) THEN RUN destroy IN h-bocx352.

        /*--- Elimina proces-acond-item -----------------------------------------------*/
        RUN openQueryStatic IN h-bocx354 (INPUT "Main":U).
        FOR EACH proces-acond-item
           WHERE proces-acond-item.cod-estabel     = RowObject.cod-estabel
             AND proces-acond-item.nr-proc-exp     = RowObject.nr-proc-exp
             AND proces-acond-item.cod-acond       = RowObject.cod-acond
             AND proces-acond-item.num-volum-acond = RowObject.num-volum-acond  NO-LOCK:
    
             RUN repositionRecord IN h-bocx354 (ROWID(proces-acond-item)).
             RUN deleteRecord     IN h-bocx354.
    
             IF RETURN-VALUE <> 'OK':U THEN DO:
                RUN getRowErrors IN h-bocx354 (OUTPUT TABLE rowErrors APPEND).
                /*--- Elimina da tabela de erros , os erros internos ---*/
                FOR EACH RowErrors 
                   WHERE RowErrors.ErrorType = "INTERNAL":U:
                   DELETE RowErrors.
                END.
             END.
        END.              
        IF VALID-HANDLE(h-bocx354) THEN RUN destroy IN h-bocx354.

        IF CAN-FIND(FIRST RowErrors 
            WHERE RowErrors.ErrorSubType =  "ERROR":U
              AND RowErrors.ErrorType    <> "INTERNAL":U) THEN
            UNDO,LEAVE.
    END.
    /*---------------------------------------------------------------------------------*/

    IF CAN-FIND(FIRST RowErrors 
                WHERE RowErrors.ErrorSubType =  "ERROR":U
                  AND RowErrors.ErrorType    <> "INTERNAL":U) THEN
        RETURN "NOK":U.
    ELSE
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-acond":U THEN ASSIGN pFieldValue = RowObject.cod-acond.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "nr-proc-exp":U THEN ASSIGN pFieldValue = RowObject.nr-proc-exp.
        WHEN "sigla-emb-pai":U THEN ASSIGN pFieldValue = RowObject.sigla-emb-pai.
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "num-volum-acond":U THEN ASSIGN pFieldValue = RowObject.num-volum-acond.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice prcscndv-id
  Parameters:  
               retorna valor do campo cod-estabel
               retorna valor do campo nr-proc-exp
               retorna valor do campo cod-acond
               retorna valor do campo num-volum-acond
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE proces-acond-volum.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-proc-exp LIKE proces-acond-volum.nr-proc-exp NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-acond LIKE proces-acond-volum.cod-acond NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-volum-acond LIKE proces-acond-volum.num-volum-acond NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-estabel = RowObject.cod-estabel
           pnr-proc-exp = RowObject.nr-proc-exp
           pcod-acond = RowObject.cod-acond
           pnum-volum-acond = RowObject.num-volum-acond.

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
        WHEN "log-livre-1":U THEN ASSIGN pFieldValue = RowObject.log-livre-1.
        WHEN "log-livre-2":U THEN ASSIGN pFieldValue = RowObject.log-livre-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getNextVolum DBOProgram 
PROCEDURE getNextVolum :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de do ultimo volume do acondicionamento
  Parameters:  
               recebe o estabelecimento do processo de exportaá∆o
               recebe o nr do processo de exportaá∆o
               recebe o acondicionamento do processo de exportaá∆o
               retorna o £ltimo nr do volume informado
  Notes:       
------------------------------------------------------------------------------*/
    def input  param pcCodEstabel like estabelec.cod-estabel              no-undo.
    def input  param pcNrProcExp  like processo-exp.nr-proc-exp           no-undo.
    def input  param pcCodAcond   like proces-acond.cod-acond             no-undo.
    def output param piNrUltVol   like proces-acond-volum.num-volum-acond no-undo.

    FIND last  bfproces-acond-volum 
         WHERE bfproces-acond-volum.cod-estabel = pcCodEstabel 
           AND bfproces-acond-volum.nr-proc-exp = pcNrProcExp 
           AND bfproces-acond-volum.cod-acond   = pcCodAcond NO-LOCK NO-ERROR.

    if  avail bfproces-acond-volum then
        assign piNrUltVol = bfproces-acond-volum.num-volum-acond.
    else
        assign piNrUltVol = 0.

    return "OK":U.

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
  Purpose:     Reposiciona registro com base no °ndice prcscndv-id
  Parameters:  
               recebe valor do campo cod-estabel
               recebe valor do campo nr-proc-exp
               recebe valor do campo cod-acond
               recebe valor do campo num-volum-acond
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE proces-acond-volum.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pnr-proc-exp LIKE proces-acond-volum.nr-proc-exp NO-UNDO.
    DEFINE INPUT PARAMETER pcod-acond LIKE proces-acond-volum.cod-acond NO-UNDO.
    DEFINE INPUT PARAMETER pnum-volum-acond LIKE proces-acond-volum.num-volum-acond NO-UNDO.

    FIND FIRST bfproces-acond-volum WHERE 
        bfproces-acond-volum.cod-estabel = pcod-estabel AND 
        bfproces-acond-volum.nr-proc-exp = pnr-proc-exp AND 
        bfproces-acond-volum.cod-acond = pcod-acond AND 
        bfproces-acond-volum.num-volum-acond = pnum-volum-acond NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfproces-acond-volum THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfproces-acond-volum)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToProcesso-exp DBOProgram 
PROCEDURE linkToProcesso-exp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER hp_Parent AS HANDLE NO-UNDO.

ASSIGN c-cod-estabel = ""
       c-nr-proc-exp = "".

if  valid-handle(hp_Parent) then do:
    run getCharField in hp_Parent (input "cod-estabel":U, output c-cod-estabel).
    run getCharField in hp_Parent (input "nr-proc-exp":U, output c-nr-proc-exp).
end.

RETURN "OK".

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
 
 RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryProcessoExp DBOProgram 
PROCEDURE openQueryProcessoExp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK
     WHERE {&tablename}.cod-estabel = c-cod-estabel
       AND {&tablename}.nr-proc-exp = c-nr-proc-exp
       INDEXED-REPOSITION.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetConstraintProcessoExp DBOProgram 
PROCEDURE SetConstraintProcessoExp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param pcCodEstabel like processo-exp.cod-estabel no-undo.
    def input param pcNrProcExp  like processo-exp.nr-proc-exp no-undo.

    ASSIGN c-cod-estabel = pcCodEstabel
           c-nr-proc-exp = pcNrProcExp.

RETURN "OK".

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
    
    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/
    
    case pType:

        when "Create":U then do:

            if can-find(first bf{&TableName} no-lock
                        where bf{&TableName}.cod-estabel     = RowObject.cod-estabel
                          and bf{&TableName}.nr-proc-exp     = RowObject.nr-proc-exp
                          and bf{&TableName}.cod-acond       = RowObject.cod-acond
                          and bf{&TableName}.num-volum-acond = RowObject.num-volum-acond) then do:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-volumeacondicionamento AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Volume/Acondicionamento" *}
                ASSIGN c-lbl-liter-volumeacondicionamento = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i &ErrorNumber="1" 
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="c-lbl-liter-volumeacondicionamento"}
            end.

            if  RowObject.cod-acond = "" then do:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-acondicionamento AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Acondicionamento" *}
                ASSIGN c-lbl-liter-acondicionamento = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i 
                              &ErrorNumber="17394"
                              &ErrorType="EMS":U
                              &ErrorParameters="c-lbl-liter-acondicionamento"}  
            end.
            else
                if not can-find(first proces-acond no-lock
                                where proces-acond.cod-estabel = RowObject.cod-estabel
                                  and proces-acond.nr-proc-exp = RowObject.nr-proc-exp
                                  and proces-acond.cod-acond   = RowObject.cod-acond) then do:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-acondicionamento-2 AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Acondicionamento" *}
                    ASSIGN c-lbl-liter-acondicionamento-2 = TRIM(RETURN-VALUE).
                    {method/svc/errors/inserr.i &ErrorNumber="2" 
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="c-lbl-liter-acondicionamento-2"}
                end.

            if RowObject.sigla-emb-pai = "" then do:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-sigla-pai AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Sigla_Pai" *}
                ASSIGN c-lbl-liter-sigla-pai = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i 
                              &ErrorNumber="17394"
                              &ErrorType="EMS":U
                              &ErrorParameters="c-lbl-liter-sigla-pai"}  
            end.
            else
                if  not can-find (first embalag no-lock
                                  where embalag.sigla-emb = RowObject.sigla-emb-pai) then do:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-embalagem AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Embalagem" *}
                    ASSIGN c-lbl-liter-embalagem = TRIM(RETURN-VALUE).
                    {method/svc/errors/inserr.i &ErrorNumber="2" 
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="c-lbl-liter-embalagem"}
                end.

        end.

        when "Update":U then do:

            if RowObject.sigla-emb-pai = "" then do:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-sigla-pai-2 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Sigla_Pai" *}
                ASSIGN c-lbl-liter-sigla-pai-2 = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i 
                              &ErrorNumber="17394"
                              &ErrorType="EMS":U
                              &ErrorParameters="c-lbl-liter-sigla-pai-2"}  
            end.
            else
                if  not can-find (first embalag no-lock
                                  where embalag.sigla-emb = RowObject.sigla-emb-pai) then do:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-embalagem-2 AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Embalagem" *}
                    ASSIGN c-lbl-liter-embalagem-2 = TRIM(RETURN-VALUE).
                    {method/svc/errors/inserr.i &ErrorNumber="2" 
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="c-lbl-liter-embalagem-2"}
                end.

        end.

        when "Delete":U then do:

        end.

    end case.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U
                  AND RowErrors.ErrorType    <> "INTERNAL":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

PROCEDURE VerificaEmbalVolum:

    def input parameter p-cod-estabel    like proces-acond-volum.cod-estabel     no-undo.
    def input parameter p-nr-proc-exp    like proces-acond-volum.nr-proc-exp     no-undo.
    def input parameter p-cod-acond      like proces-acond-volum.cod-acond       no-undo.
    def input parameter p-num-volum      like proces-acond-volum.num-volum-acond no-undo.

    find first proces-embal-volum
       where proces-embal-volum.cod-estabel     = p-cod-estabel
         and proces-embal-volum.nr-proc-exp     = p-nr-proc-exp
         and proces-embal-volum.cod-acond       = p-cod-acond
         and proces-embal-volum.num-volum-acond = p-num-volum
         no-lock no-error.

    IF avail proces-embal-volum THEN
       return "OK":U.
    else
       return "NOK":U.

END procedure.
