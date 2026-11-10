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
{include/i-prgvrs.i BOAF019 2.00.00.002 } /*** "010002" 23/11/2023 16:19:39  ***/
/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOAF019
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName af-grp-responsavel
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
{afbo/boaf019.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/*:T--- Definiá∆o de vari†veis ---*/
define variable c-des-grp-resp-ini as character format "x(40)":U no-undo.
define variable c-des-grp-resp-fim as character format "x(40)":U no-undo.
define variable c-cod-grp-resp-ini as character format "x(8)":U no-undo.
define variable c-cod-grp-resp-fim as character format "x(8)":U no-undo.
DEFINE VARIABLE h-boaf001          AS HANDLE NO-UNDO.

{utp/ut-glob.i}

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
         HEIGHT             = 13.83
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
  Purpose:     Retorna valor de campos do tipo caracter
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/

    for each  af-grp-resp-usuario
        where af-grp-resp-usuario.ep-codigo    = rowObject.ep-codigo   
        and   af-grp-resp-usuario.cod-grp-resp = rowObject.cod-grp-resp exclusive-lock:

        delete af-grp-resp-usuario.
    end.

    return "OK":U.
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
        WHEN "cod-grp-resp":U THEN ASSIGN pFieldValue = RowObject.cod-grp-resp.
        WHEN "des-grp-resp":U THEN ASSIGN pFieldValue = RowObject.des-grp-resp.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDesGrupoRespon DBOProgram 
PROCEDURE getDesGrupoRespon :
/*------------------------------------------------------------------------------
  Purpose:     Retorna Descricao  Grupo responsavel
  Parameters:  
               recebe codigo do Grupo
               retorna descricao do Grupo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pCodGrpRespon  LIKE af-grp-responsavel.cod-grp-resp NO-UNDO.
    DEFINE OUTPUT PARAMETER pDescGrpRespon LIKE af-grp-responsavel.des-grp-resp NO-UNDO.

    FOR FIRST af-grp-responsavel FIELDS (des-grp-resp)
        WHERE af-grp-responsavel.cod-grp-resp = pCodGrpRespon NO-LOCK: END.
    IF  AVAIL af-grp-responsavel THEN
        ASSIGN pDescGrpRespon = af-grp-responsavel.des-grp-resp.    
    ELSE DO:
        ASSIGN pDescGrpRespon = "".
        RETURN "NOK":U.
    END.

    RETURN "OK".

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
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice ep-grupo
  Parameters:  
               retorna valor do campo ep-codigo
               retorna valor do campo cod-grp-resp
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-grp-resp LIKE af-grp-responsavel.cod-grp-resp NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-grp-resp = RowObject.cod-grp-resp.

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
  Purpose:     Reposiciona registro com base no °ndice ep-grupo
  Parameters:  
               recebe valor do campo ep-codigo
               recebe valor do campo cod-grp-resp
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-grp-resp LIKE af-grp-responsavel.cod-grp-resp NO-UNDO.

    FIND FIRST bfaf-grp-responsavel WHERE 
        bfaf-grp-responsavel.ep-codigo = i-ep-codigo-usuario AND 
        bfaf-grp-responsavel.cod-grp-resp = pcod-grp-resp NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfaf-grp-responsavel THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfaf-grp-responsavel)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByCodResp DBOProgram 
PROCEDURE openQueryByCodResp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    open query {&QueryName}
        for each  {&TableName} 
            where {&TableName}.ep-codigo     = i-ep-codigo-usuario
            and   {&TableName}.cod-grp-resp >= c-cod-grp-resp-ini
            and   {&TableName}.cod-grp-resp <= c-cod-grp-resp-fim
            no-lock by {&TableName}.cod-grp-resp indexed-reposition.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByDescricao DBOProgram 
PROCEDURE openQueryByDescricao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    open query {&QueryName}
        for each  {&TableName} 
            where {&TableName}.ep-codigo     = i-ep-codigo-usuario
            and   {&TableName}.des-grp-resp >= c-des-grp-resp-ini
            and   {&TableName}.des-grp-resp <= c-des-grp-resp-fim
            no-lock by {&TableName}.des-grp-resp indexed-reposition.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByEmpresa DBOProgram 
PROCEDURE openQueryByEmpresa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    open query {&QueryName}
        for each  {&TableName} 
            where {&TableName}.ep-codigo = i-ep-codigo-usuario 
            no-lock indexed-reposition.

    return "OK":U.
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
    open query {&QueryName}
        for each {&TableName} no-lock indexed-reposition.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByCodResp DBOProgram 
PROCEDURE setConstraintByCodResp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter pc-cod-grp-resp-ini as character format "x(8)":U no-undo.
    define input parameter pc-cod-grp-resp-fim as character format "x(8)":U no-undo.
    
    assign c-cod-grp-resp-ini = pc-cod-grp-resp-ini
           c-cod-grp-resp-fim = pc-cod-grp-resp-fim.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByDescricao DBOProgram 
PROCEDURE setConstraintByDescricao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter pc-des-grp-resp-ini as character format "x(40)":U no-undo.
    define input parameter pc-des-grp-resp-fim as character format "x(40)":U no-undo.
    
    assign c-des-grp-resp-ini = pc-des-grp-resp-ini
           c-des-grp-resp-fim = pc-des-grp-resp-fim.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaGrupoResp DBOProgram 
PROCEDURE validaGrupoResp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-grp-resp LIKE af-grp-responsavel.cod-grp-resp NO-UNDO.
    DEFINE INPUT  PARAMETER pNrControle  LIKE af-controle.nr-controle NO-UNDO.

    DEFINE VARIABLE l-padrao AS LOGICAL     NO-UNDO.

    IF NOT VALID-HANDLE(h-boaf001) OR
       h-boaf001:TYPE <> "PROCEDURE":U OR
       h-boaf001:FILE-NAME <> "afbo/boaf001.p":U THEN DO:
       RUN afbo/boaf001.p persistent set  h-boaf001.
    END.
    
    RUN setConstraintNrControle IN h-boaf001 (INPUT pNrControle, INPUT pNrControle).
    RUN openQueryStatic IN h-boaf001 (INPUT "ByNrControle":U) NO-ERROR.
    RUN getLogField IN h-boaf001 (INPUT "padrao", OUTPUT l-padrao).

    IF VALID-HANDLE(h-boaf001) THEN DO:
        DELETE PROCEDURE h-boaf001.
        ASSIGN h-boaf001 = ?.
    END.

    IF l-padrao = YES THEN
        RETURN "OK":U.

    
    IF NOT CAN-FIND (FIRST af-grp-responsavel 
          WHERE af-grp-responsavel.ep-codigo    = i-ep-codigo-usuario 
          AND   af-grp-responsavel.cod-grp-resp = pcod-grp-resp) THEN DO:
         /* Grupo Responsavel n∆o cadastrado*/
        RETURN "NOK":U.
    END.

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
    
    if  pType = "Create" then do:

        if  can-find (first af-grp-responsavel 
                      where af-grp-responsavel.ep-codigo    = rowObject.ep-codigo 
                      and   af-grp-responsavel.cod-grp-resp = rowObject.cod-grp-resp) then do:
             /* Grupo Responsavel j† cadastrado*/
             /* Inicio -- Projeto Internacional */
             DEFINE VARIABLE c-lbl-liter-grupo-responsavel AS CHARACTER NO-UNDO.
             {utp/ut-liter.i "Grupo_Respons†vel" *}
             ASSIGN c-lbl-liter-grupo-responsavel = TRIM(RETURN-VALUE).
             {method/svc/errors/inserr.i
                            &ErrorNumber="7"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"
                            &ErrorParameters="c-lbl-liter-grupo-responsavel"}
                            
        end.

        if  rowObject.cod-grp-resp = "0"
        or  rowObject.cod-grp-resp = ""
        or  rowObject.cod-grp-resp = ? then do:
             /* Grupo Responsavel deve ser informado */
             /* Inicio -- Projeto Internacional */
             DEFINE VARIABLE c-lbl-liter-grupo-responsavel-2 AS CHARACTER NO-UNDO.
             {utp/ut-liter.i "Grupo_Respons†vel" *}
             ASSIGN c-lbl-liter-grupo-responsavel-2 = TRIM(RETURN-VALUE).
             {method/svc/errors/inserr.i
                            &ErrorNumber="265"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"
                            &ErrorParameters="c-lbl-liter-grupo-responsavel-2"}
        end.
    end.

    if  pType = "Update" 
    or   pType = "Create" then do:

        if  rowObject.des-grp-resp = "" then do:
            /* Descricao do Grupo Responsavel deve ser informado */
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-descricao-do-grupo-responsavel AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Descriá∆o_do_Grupo_Respons†vel" *}
            ASSIGN c-lbl-liter-descricao-do-grupo-responsavel = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                           &ErrorNumber="265"
                           &ErrorType="EMS"
                           &ErrorSubType="ERROR"
                           &ErrorParameters="c-lbl-liter-descricao-do-grupo-responsavel"}
        end.

    end.
    else do: /*Delete*/

        if  can-find (first af-controle
                      where af-controle.ep-codigo    = rowObject.ep-codigo
                      and   af-controle.cod-grp-resp = rowObject.cod-grp-resp) then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-grupo-responsavel-3 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Grupo_Respons†vel" *}
            ASSIGN c-lbl-liter-grupo-responsavel-3 = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-ponto-de-controle AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Ponto_de_Controle" *}
            ASSIGN c-lbl-liter-ponto-de-controle = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                           &ErrorNumber="8699"
                           &ErrorType="EMS"
                           &ErrorSubType="ERROR"
                           &ErrorParameters="c-lbl-liter-grupo-responsavel-3 + '~~~~'
                                           + c-lbl-liter-ponto-de-controle"}
        end.                      
                      
        if  can-find (first af-familia-contr-form
                      where af-familia-contr-form.ep-codigo    = rowObject.ep-codigo
                      and   af-familia-contr-form.cod-grp-resp = rowObject.cod-grp-resp) then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-grupo-responsavel-4 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Grupo_Respons†vel" *}
            ASSIGN c-lbl-liter-grupo-responsavel-4 = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-ponto-controle-x-familia AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Ponto_Controle_x_Fam°lia" *}
            ASSIGN c-lbl-liter-ponto-controle-x-familia = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                           &ErrorNumber="8699"
                           &ErrorType="EMS"
                           &ErrorSubType="ERROR"
                           &ErrorParameters="c-lbl-liter-grupo-responsavel-4 + '~~~~'
                                           + c-lbl-liter-ponto-controle-x-familia"}
        end.                      

        if  can-find (first af-item-contr-form
                      where af-item-contr-form.ep-codigo    = rowObject.ep-codigo
                      and   af-item-contr-form.cod-grp-resp = rowObject.cod-grp-resp) then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-grupo-responsavel-5 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Grupo_Respons†vel" *}
            ASSIGN c-lbl-liter-grupo-responsavel-5 = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-ponto-controle-x-item AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Ponto_Controle_x_Item" *}
            ASSIGN c-lbl-liter-ponto-controle-x-item = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                           &ErrorNumber="8699"
                           &ErrorType="EMS"
                           &ErrorSubType="ERROR"
                           &ErrorParameters="c-lbl-liter-grupo-responsavel-5 + '~~~~'
                                           + c-lbl-liter-ponto-controle-x-item"}
        end.                      

        if  can-find (first af-item-contr-estab-form
                      where af-item-contr-estab-form.ep-codigo    = rowObject.ep-codigo
                      and   af-item-contr-estab-form.cod-grp-resp = rowObject.cod-grp-resp) then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-grupo-responsavel-6 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Grupo_Respons†vel" *}
            ASSIGN c-lbl-liter-grupo-responsavel-6 = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-ponto-controle-x-item-x-estab AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Ponto_Controle_x_Item_x_Estab" *}
            ASSIGN c-lbl-liter-ponto-controle-x-item-x-estab = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                           &ErrorNumber="8699"
                           &ErrorType="EMS"
                           &ErrorSubType="ERROR"
                           &ErrorParameters="c-lbl-liter-grupo-responsavel-6 + '~~~~'
                                           + c-lbl-liter-ponto-controle-x-item-x-estab"}
        end.                   

        if  can-find (first af-grp-avaliacao-form
                      where af-grp-avaliacao-form.ep-codigo    = rowObject.ep-codigo
                      and   af-grp-avaliacao-form.cod-grp-resp = rowObject.cod-grp-resp) then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-grupo-responsavel-7 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Grupo_Respons†vel" *}
            ASSIGN c-lbl-liter-grupo-responsavel-7 = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-grupo-avaliacao AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Grupo_Avaliaá∆o" *}
            ASSIGN c-lbl-liter-grupo-avaliacao = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                           &ErrorNumber="8699"
                           &ErrorType="EMS"
                           &ErrorSubType="ERROR"
                           &ErrorParameters="c-lbl-liter-grupo-responsavel-7 + '~~~~'
                                           + c-lbl-liter-grupo-avaliacao"}
        end.                   
    end.

    /*:T--- Verifica ocorrància de erros ---*/
    IF  CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

