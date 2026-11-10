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
&GLOBAL-DEFINE DBOName BOIN01035
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName usuar-depos
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
{inbo/boin01035.i RowObject}
{inbo/boin01035.i tt-usuar-depos}

DEFINE TEMP-TABLE tt-usuar-depos-sel NO-UNDO
    FIELD marcado     AS CHAR FORMAT "X(1)"
    FIELD cod-usuario LIKE usuar-mater.cod-usuario
    FIELD nome        LIKE usuar-mater.nome
    FIELD dat-val-fim LIKE usuar-depos.dat-val-fim.

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}
{cdp/cd0031.i} /* seguranca por estabelecimento */

/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEF VAR c-cod-depos LIKE deposito.cod-depos      NO-UNDO.
DEF VAR c-cod-estab LIKE estabelec.cod-estabel   NO-UNDO.
DEF VAR da-data-val LIKE usuar-depos.dat-val-fim NO-UNDO.

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
         HEIGHT             = 39.38
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
        WHEN "cod-depos":U THEN ASSIGN pFieldValue = RowObject.cod-depos.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-usuario":U THEN ASSIGN pFieldValue = RowObject.cod-usuario.
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
        WHEN "dat-val-fim":U THEN ASSIGN pFieldValue = RowObject.dat-val-fim.
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
  Purpose:     Retorna valores dos campos do °ndice dep-usuar-id
  Parameters:  
               retorna valor do campo cod-depos
               retorna valor do campo cod-estabel
               retorna valor do campo cod-usuario
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-depos LIKE usuar-depos.cod-depos NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE usuar-depos.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-usuario LIKE usuar-depos.cod-usuario NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-depos = RowObject.cod-depos
           pcod-estabel = RowObject.cod-estabel
           pcod-usuario = RowObject.cod-usuario.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTTUsuario DBOProgram 
PROCEDURE getTTUsuario :
/*------------------------------------------------------------------------------
  Purpose: Retorna usuarios para tela de cadastro de almoxarife (CD1760)    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER pDepos      LIKE usuar-depos.cod-depos   NO-UNDO.
    DEFINE INPUT  PARAMETER pEstab      LIKE usuar-depos.cod-estabel NO-UNDO.
    DEFINE INPUT  PARAMETER p-grupo     AS CHAR NO-UNDO.
    DEFINE INPUT  PARAMETER p-usuar-ini AS CHAR FORMAT "X(12)" NO-UNDO.
    DEFINE INPUT  PARAMETER p-usuar-fim AS CHAR FORMAT "X(12)" NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-usuar-depos-sel.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.
    
    EMPTY TEMP-TABLE RowErrors NO-ERROR.
    
    IF p-grupo <> "" THEN DO:
    
        FIND FIRST grp_usuar NO-LOCK
             WHERE grp_usuar.cod_grp_usuar = p-grupo NO-ERROR.
             
        IF NOT AVAILABLE grp_usuar THEN DO:
            {utp/ut-liter.i Grupo_Usu†rio *}
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="return-value"}
             RETURN "NOK":U.
        END.
    END.
    
    EMPTY TEMP-TABLE tt-usuar-depos-sel.
    
    FOR EACH usuar-mater FIELDS(cod-usuario nome-usuar) NO-LOCK 
       WHERE usuar-mater.cod-usuario >= p-usuar-ini
         AND usuar-mater.cod-usuario <= p-usuar-fim,
        FIRST usuar_grp_usuar FIELDS() NO-LOCK
       WHERE usuar_grp_usuar.cod_usuario     = usuar-mater.cod-usuario
         AND (usuar_grp_usuar.cod_grp_usuar = p-grupo
              OR p-grupo = ""):
              
        /*desconsidera registros j† relacionados*/
        IF CAN-FIND(FIRST bf{&TableName}
                    WHERE bf{&TableName}.cod-depos   = pDepos
                      AND bf{&TableName}.cod-estabel = pEstab
                      AND bf{&TableName}.cod-usuario = usuar-mater.cod-usuario) THEN
            NEXT.

        /*desconsidera o registro j† existente na temp-table*/
        IF NOT CAN-FIND(tt-usuar-depos-sel WHERE tt-usuar-depos-sel.cod-usuario = usuar-mater.cod-usuario) THEN DO:
            CREATE tt-usuar-depos-sel.
            ASSIGN tt-usuar-depos-sel.cod-usuario = usuar-mater.cod-usuario
                   tt-usuar-depos-sel.nome = usuar-mater.nome-usuar.
        END.
        
    END.

    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice dep-usuar-id
  Parameters:  
               recebe valor do campo cod-depos
               recebe valor do campo cod-estabel
               recebe valor do campo cod-usuario
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-depos LIKE usuar-depos.cod-depos NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE usuar-depos.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pcod-usuario LIKE usuar-depos.cod-usuario NO-UNDO.

    FIND FIRST bfusuar-depos WHERE 
        bfusuar-depos.cod-depos = pcod-depos AND 
        bfusuar-depos.cod-estabel = pcod-estabel AND 
        bfusuar-depos.cod-usuario = pcod-usuario NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfusuar-depos THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfusuar-depos)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToDeposito DBOProgram 
PROCEDURE linkToDeposito :
/*---------------------------------------------------------------
  Purpose:     Recebe handle do DBO Item e execute m?todo getKey
  Parameters:  recebe handle de um DBO
  Notes:       
----------------------------------------------------------------*/
    def input param pHandle as handle no-undo.
    
    run getKey in pHandle (output c-cod-depos).   
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByDepos DBOProgram 
PROCEDURE openQueryByDepos :
/*------------------------------------------------------------------------------
  Purpose:  Abre quuery com base no cod-tranp   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         WHERE {&TableName}.cod-depos = c-cod-depos.

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

    OPEN QUERY {&queryName} FOR EACH {&TableName} NO-LOCK.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveUsuarDepos DBOProgram 
PROCEDURE saveUsuarDepos :
/*------------------------------------------------------------------------------
  Purpose: Atualiza Relacionamente Usu†rio x Deposito (CD1706A)    
  Parameters:  Deposito, Estabelecimento, Data de Validade atÇ
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAM pDepos LIKE usuar-depos.cod-depos   NO-UNDO.
    DEFINE INPUT PARAM pEstab LIKE usuar-depos.cod-estabel NO-UNDO.
    DEFINE INPUT PARAM pData  LIKE usuar-depos.dat-val-fim NO-UNDO.
    DEFINE INPUT PARAM TABLE FOR tt-usuar-depos-sel.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    ASSIGN c-cod-estab = pEstab
           da-data-val = pData.

    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RUN emptyRowErrors IN THIS-PROCEDURE.

    FOR EACH tt-usuar-depos-sel:
        
        FIND FIRST usuar-depos EXCLUSIVE-LOCK
             WHERE usuar-depos.cod-depos   = pDepos
               AND usuar-depos.cod-estabel = pEstab
               AND usuar-depos.cod-usuario = tt-usuar-depos-sel.cod-usuario NO-ERROR.
        IF AVAIL usuar-depos AND tt-usuar-depos-sel.marcado = "":U THEN
            DELETE usuar-depos.
        ELSE DO:
            IF NOT AVAIL usuar-depos AND tt-usuar-depos-sel.marcado = "*":U THEN DO:
                
                EMPTY TEMP-TABLE tt-usuar-depos.

                CREATE tt-usuar-depos.
                ASSIGN tt-usuar-depos.cod-depos   = pDepos                        
                       tt-usuar-depos.cod-estabel = pEstab                        
                       tt-usuar-depos.cod-usuario = tt-usuar-depos-sel.cod-usuario
                       tt-usuar-depos.dat-val-fim = pData.
                
                RUN emptyRowObject IN THIS-PROCEDURE.
                RUN setRecord      IN THIS-PROCEDURE (INPUT TABLE tt-usuar-depos).
                RUN createRecord   IN THIS-PROCEDURE.

            END.
        END.

    END.

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

    DEF VAR c-lit-relac AS CHAR NO-UNDO.
    
    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/

    /*Se n∆o veio da procedure saveUsuarDepos grava o estabelecimento da rowobject*/
    IF pType = "CREATE":U THEN DO:
    
        /*seguranáa por estabelecimento implementada via include cd0031.i*/
        FOR FIRST estabelec fields() where estabelec.cod-estabel = rowObject.cod-estabel: END.
        IF NOT AVAIL estabelec THEN DO:
            {utp/ut-liter.i Estabelecimento *}
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="return-value"}
        END.
    
        IF CAN-FIND(first bf{&TableName} 
                    where bf{&TableName}.cod-depos   = RowObject.cod-depos
                      AND bf{&TableName}.cod-estabel = RowObject.cod-estabel
                      AND bf{&TableName}.cod-usuario = RowObject.cod-usuario)  THEN DO:
                {utp/ut-liter.i Usu†rio_do_Dep¢sito *}
                {method/svc/errors/inserr.i &ErrorNumber="1"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="return-value"}
        END.

    END.

    IF pType = "CREATE":U OR pType = "UPDATE":U THEN DO:
    
        IF NOT CAN-FIND(first usuar-mater where usuar-mater.cod-usuario = RowObject.cod-usuario) THEN DO:
            {utp/ut-liter.i Usu†rio *}
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="return-value"}                                 
            
        END.
    
        IF Rowobject.dat-val-fim < TODAY THEN DO:
            
            {utp/ut-liter.i Data_de_validade_do_relacionamento *}
            c-lit-relac = RETURN-VALUE.
            {utp/ut-liter.i data_de_hoje *}
            {method/svc/errors/inserr.i &ErrorNumber="8826"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="c-lit-relac + '~~~~' + return-value"}
    
        END.

    END.
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

