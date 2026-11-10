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
{include/i-prgvrs.i BOIN00914 2.00.00.006 } /*** "010006" 27/10/2023 17:03:40  ***/

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN00914
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName proces-cq
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
{inbo/boin00914.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
DEFINE VARIABLE c-ep-codigo-ini     LIKE proces-cq.ep-codigo        NO-UNDO.
DEFINE VARIABLE c-ep-codigo-fim     LIKE proces-cq.ep-codigo        NO-UNDO.
DEFINE VARIABLE c-estab-ini         LIKE proces-cq.cod-estabel      NO-UNDO.
DEFINE VARIABLE c-estab-fim         LIKE proces-cq.cod-estabel      NO-UNDO.
DEFINE VARIABLE c-area-ini          LIKE proces-cq.cod-area-produc  NO-UNDO.
DEFINE VARIABLE c-area-fim          LIKE proces-cq.cod-area-produc  NO-UNDO.    
DEFINE VARIABLE c-proces-ini        LIKE proces-cq.cod-proces       NO-UNDO.
DEFINE VARIABLE c-proces-fim        LIKE proces-cq.cod-proces       NO-UNDO.
DEFINE VARIABLE hShowMsg            AS HANDLE                       NO-UNDO.

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
         HEIGHT             = 13.67
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
        WHEN "cod-area-produc":U THEN ASSIGN pFieldValue = RowObject.cod-area-produc.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-grp-mapa":U THEN ASSIGN pFieldValue = RowObject.cod-grp-mapa.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-ord-mapa":U THEN ASSIGN pFieldValue = RowObject.cod-ord-mapa.
        WHEN "cod-proces":U THEN ASSIGN pFieldValue = RowObject.cod-proces.
        WHEN "des-proces":U THEN ASSIGN pFieldValue = RowObject.des-proces.
        WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
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
        WHEN "dat-fim-valid":U THEN ASSIGN pFieldValue = RowObject.dat-fim-valid.
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
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice procescq_id
  Parameters:  
               retorna valor do campo ep-codigo
               retorna valor do campo cod-estabel
               retorna valor do campo cod-area-produc
               retorna valor do campo cod-proces
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pep-codigo LIKE proces-cq.ep-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE proces-cq.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-area-produc LIKE proces-cq.cod-area-produc NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-proces LIKE proces-cq.cod-proces NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pep-codigo = RowObject.ep-codigo
           pcod-estabel = RowObject.cod-estabel
           pcod-area-produc = RowObject.cod-area-produc
           pcod-proces = RowObject.cod-proces.

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
  Purpose:     Reposiciona registro com base no °ndice procescq_id
  Parameters:  
               recebe valor do campo ep-codigo
               recebe valor do campo cod-estabel
               recebe valor do campo cod-area-produc
               recebe valor do campo cod-proces
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo LIKE proces-cq.ep-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE proces-cq.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pcod-area-produc LIKE proces-cq.cod-area-produc NO-UNDO.
    DEFINE INPUT PARAMETER pcod-proces LIKE proces-cq.cod-proces NO-UNDO.

    FIND FIRST bfproces-cq WHERE 
        bfproces-cq.ep-codigo = pep-codigo AND 
        bfproces-cq.cod-estabel = pcod-estabel AND 
        bfproces-cq.cod-area-produc = pcod-area-produc AND 
        bfproces-cq.cod-proces = pcod-proces NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfproces-cq THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfproces-cq)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
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
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryZoom DBOProgram 
PROCEDURE OpenQueryZoom :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} 
        WHERE {&TableName}.ep-codigo        >=  c-ep-codigo-ini
        AND   {&TableName}.ep-codigo        <=  c-ep-codigo-fim
        AND   {&TableName}.cod-estabel      >=  c-estab-ini    
        AND   {&TableName}.cod-estabel      <=  c-estab-fim    
        AND   {&TableName}.cod-area-produc  >=  c-area-ini     
        AND   {&TableName}.cod-area-produc  <=  c-area-fim     
        AND   {&TableName}.cod-proces       >=  c-proces-ini   
        AND   {&TableName}.cod-proces       <=  c-proces-fim  NO-LOCK.

        RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidateDateToday DBOProgram 
PROCEDURE piValidateDateToday :
/*------------------------------------------------------------------------------
  Purpose:     Procedure para verificar se a data de validade Ç menor que a de hoje
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    /*Se algum Subprocesso j† est† no processo destino deve mostrar ao final do processamento ao usu†rio*/
    IF rowObject.dat-fim-valid < TODAY THEN DO:

        RUN emptyRowErrors IN THIS-PROCEDURE.

        DEFINE VARIABLE c-proc-inativo AS CHARACTER   NO-UNDO.
        {utp/ut-liter.i "Processo_destino" *}
        ASSIGN c-proc-inativo = TRIM(RETURN-VALUE).
        {utp/ut-liter.i "a_data_atual" *}
        {method/svc/errors/inserr.i
                       &ErrorNumber="18721" 
                       &ErrorType="EMS"
                       &ErrorSubType="ERROR"
                       &ErrorParameters="c-proc-inativo + '~~~~' + trim(return-value)"}
                       
        run getRowErrors in THIS-PROCEDURE (OUTPUT TABLE RowErrors ).

        session:set-wait-state("":U).
    
        if  can-find(first RowErrors) then  do:
    
            {method/showmessage.i1}
    
            /*--- Seta cursor do mouse para normal ---*/
            SESSION:SET-WAIT-STATE("":U).
    
            /*--- Transfere temp-table RowErrors para a tela de mensagens de erros ---*/
            {method/showmessage.i2}
    
            wait-for close of hShowMsg.
    
        end.
    
        IF CAN-FIND(FIRST rowErrors 
                    WHERE RowErrors.errorSubType = "ERROR":U) THEN
            RETURN "NOK":U.
    END.

    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piVerificaDataValidade DBOProgram 
PROCEDURE piVerificaDataValidade :
/*------------------------------------------------------------------------------
  Purpose:     Na atualizaá∆o de um Processo verificar se a data est† menor 
                que hoje e questionar o usu†rio, se ele confirmar a alteraá∆o, 
                ent∆o salvar
  Parameters:  p-data - Data de validaá∆o
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-data LIKE proces-cq.dat-fim-valid NO-UNDO.

    IF p-data < TODAY THEN DO:
        {utp/ut-liter.i "data_de_validade_menor_que_data_atual" *}
        RUN utp/ut-msgs.p(INPUT "show":U,
                          INPUT 701,
                          INPUT TRIM(RETURN-VALUE)).

        IF RETURN-VALUE = "NO":U THEN
            RETURN "NOK":U.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintParamZoom DBOProgram 
PROCEDURE setConstraintParamZoom :
/*------------------------------------------------------------------------------
  Purpose:     ParÉmetros para filtro do zoom
  Parameters:  p-ep-codigo-ini  - Empresa Inicial
               p-ep-codigo-fim  - Empresa final
               p-estab-ini      - Estabelecimento Inicial
               p-estab-fim      - Estabelecimento final
               p-area-ini       - µrea Inicial
               p-area-fim       - µrea final
               p-proces-ini     - Processo Inicial
               p-proces-fim     - Processo final
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER  p-ep-codigo-ini     LIKE proces-cq.ep-codigo        NO-UNDO.
    DEFINE INPUT PARAMETER  p-ep-codigo-fim     LIKE proces-cq.ep-codigo        NO-UNDO.
    DEFINE INPUT PARAMETER  p-estab-ini         LIKE proces-cq.cod-estabel      NO-UNDO.
    DEFINE INPUT PARAMETER  p-estab-fim         LIKE proces-cq.cod-estabel      NO-UNDO.
    DEFINE INPUT PARAMETER  p-area-ini          LIKE proces-cq.cod-area-produc  NO-UNDO.
    DEFINE INPUT PARAMETER  p-area-fim          LIKE proces-cq.cod-area-produc  NO-UNDO.    
    DEFINE INPUT PARAMETER  p-proces-ini        LIKE proces-cq.cod-proces       NO-UNDO.
    DEFINE INPUT PARAMETER  p-proces-fim        LIKE proces-cq.cod-proces       NO-UNDO.

    ASSIGN  c-ep-codigo-ini =  p-ep-codigo-ini
            c-ep-codigo-fim =  p-ep-codigo-fim
            c-estab-ini     =  p-estab-ini    
            c-estab-fim     =  p-estab-fim    
            c-area-ini      =  p-area-ini     
            c-area-fim      =  p-area-fim     
            c-proces-ini    =  p-proces-ini   
            c-proces-fim    =  p-proces-fim.

    RETURN "OK":U.

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

    IF pType = "Create":U THEN DO:
        IF RowObject.cod-estabel = "" THEN DO:
            {method/svc/errors/inserr.i
                                   &ErrorNumber="13" 
                                   &ErrorType="EMS"
                                   &ErrorSubType="ERROR"
                                   &ErrorParameters="''"}
                       
        END.
    
        IF NOT CAN-FIND (FIRST area-produc
                        WHERE area-produc.cod-area-produc = RowObject.cod-area-produc) 
            OR RowObject.cod-area-produc = ""THEN DO:
            {utp/ut-liter.i "µrea_de_processo" *}
            {method/svc/errors/inserr.i
                                   &ErrorNumber="2" 
                                   &ErrorType="EMS"
                                   &ErrorSubType="ERROR"
                                   &ErrorParameters="TRIM(RETURN-VALUE)"}
        END.
    
        IF RowObject.cod-proces = "" THEN DO:
            {utp/ut-liter.i "Processo" *}
            {method/svc/errors/inserr.i
                                   &ErrorNumber="688" 
                                   &ErrorType="EMS"
                                   &ErrorSubType="ERROR"
                                   &ErrorParameters="TRIM(RETURN-VALUE)"}
        END.        
        IF RowObject.dat-fim-valid < TODAY THEN DO:
            DEFINE VARIABLE c-data-final AS CHARACTER   NO-UNDO.
            {utp/ut-liter.i "Data_final_de_validade" *}
            ASSIGN c-data-final = TRIM(RETURN-VALUE).
            {utp/ut-liter.i "que_data_atual" *}            
            {method/svc/errors/inserr.i
                                   &ErrorNumber="416" 
                                   &ErrorType="EMS"
                                   &ErrorSubType="ERROR"
                                   &ErrorParameters="c-data-final + '~~~~' + TRIM(RETURN-VALUE)"}
        END.

        IF CAN-FIND (FIRST proces-cq
                 WHERE proces-cq.ep-codigo                  = RowObject.ep-codigo      
                 AND   proces-cq.cod-estabel            = RowObject.cod-estabel    
                 AND   proces-cq.cod-area-produc        = RowObject.cod-area-produc
                 AND   proces-cq.cod-proces                 = RowObject.cod-proces ) THEN DO:
            DEFINE VARIABLE c-proces AS CHARACTER   NO-UNDO.
            {utp/ut-liter.i "Processo" *}
            ASSIGN c-proces = TRIM(RETURN-VALUE).
            {utp/ut-liter.i "Estabelecimento_e_µrea" *}
            {method/svc/errors/inserr.i
                                   &ErrorNumber="31724"
                                   &ErrorType="EMS"
                                   &ErrorSubType="ERROR"
                                   &ErrorParameters="c-proces + '~~~~' + TRIM(RETURN-VALUE) + '~~~~' + c-proces"}             
        END.
    END.
   
    IF pType = "Create":U OR pType = "Update":U THEN DO:    
        IF RowObject.des-proces = "" THEN DO:
            {utp/ut-liter.i "Descriá∆o_do_Processo" *}
            {method/svc/errors/inserr.i
                                   &ErrorNumber="688" 
                                   &ErrorType="EMS"
                                   &ErrorSubType="ERROR"
                                   &ErrorParameters="TRIM(RETURN-VALUE)"}
        END. 
    END.
    ELSE DO:
        IF CAN-FIND (FIRST sub-proces-cq
                 WHERE sub-proces-cq.ep-codigo              = RowObject.ep-codigo      
                 AND   sub-proces-cq.cod-estabel                = RowObject.cod-estabel    
                 AND   sub-proces-cq.cod-area-produc    = RowObject.cod-area-produc
                 AND   sub-proces-cq.cod-proces             = RowObject.cod-proces ) THEN DO:
            DEFINE VARIABLE c-proces-delete AS CHARACTER   NO-UNDO.
            {utp/ut-liter.i Processo *}
            ASSIGN c-proces-delete = TRIM(RETURN-VALUE).
            {utp/ut-liter.i Primeiro_elimine_os_subprocessos_vinculados_a_ele *}
            {method/svc/errors/inserr.i
                                   &ErrorNumber="25129" 
                                   &ErrorType="EMS"
                                   &ErrorSubType="ERROR"
                                   &ErrorParameters="c-proces-delete + '~~~~' + TRIM(RETURN-VALUE) + '.'"}
        END.
    END.
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

