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
&GLOBAL-DEFINE DBOName BOIN00956
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName param-integr-mes
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
{inbo/boin00956.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

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
        WHEN "cod-campo":U THEN ASSIGN pFieldValue = RowObject.cod-campo.
        WHEN "des-campo":U THEN ASSIGN pFieldValue = RowObject.des-campo.
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
        WHEN "idi-entidade":U THEN ASSIGN pFieldValue = RowObject.idi-entidade.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram  
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice prmntgrm_id2
  Parameters:  
               retorna valor do campo idi-entidade
               retorna valor do campo cod-campo
               retorna valor do campo des-campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pidi-entidade LIKE param-integr-mes.idi-entidade NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-campo LIKE param-integr-mes.cod-campo NO-UNDO.
    DEFINE OUTPUT PARAMETER pdes-campo LIKE param-integr-mes.des-campo NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    ASSIGN pidi-entidade = RowObject.idi-entidade
           pcod-campo = RowObject.cod-campo
           pdes-campo = RowObject.des-campo.

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
  Purpose:     Reposiciona registro com base no °ndice prmntgrm_id2
  Parameters:  
               recebe valor do campo idi-entidade
               recebe valor do campo cod-campo
               recebe valor do campo des-campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pidi-entidade LIKE param-integr-mes.idi-entidade NO-UNDO.
    DEFINE INPUT PARAMETER pcod-campo LIKE param-integr-mes.cod-campo NO-UNDO.
    DEFINE INPUT PARAMETER pdes-campo LIKE param-integr-mes.des-campo NO-UNDO.

    FIND FIRST bfparam-integr-mes WHERE 
        bfparam-integr-mes.idi-entidade = pidi-entidade AND 
        bfparam-integr-mes.cod-campo = pcod-campo AND 
        bfparam-integr-mes.des-campo = pdes-campo NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfparam-integr-mes THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfparam-integr-mes)).
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
 Notes:
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK INDEXED-REPOSITION.
    
    RETURN "OK":U. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintMain DBOProgram 
PROCEDURE setConstraintMain :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/

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
        /* Validacoes para a ordem de producao*/
        IF RowObject.idi-entidade = 1 THEN DO:
            IF TRIM(RowObject.des-campo) = "*":U THEN DO:
                IF CAN-FIND(FIRST bf{&TableName} WHERE bf{&TableName}.idi-entidade = 1 AND
                                                       bf{&TableName}.cod-campo = RowObject.cod-campo) THEN DO:
                    {utp/ut-liter.i "N∆o Ç poss°vel cadastrar o filtro '*' com outros filtros j† cadastrados." *}
                    {method/svc/errors/inserr.i
                        &ErrorNumber = "17006"
                        &ErrorType = "EMS"
                        &ErrorSubType = "ERROR"
                        &ErrorParameters="return-value"}
                END.
            END.
            ELSE DO:
                CASE RowObject.cod-campo:
                    WHEN "nr-linha":U or
                    when "reaproveitamento" THEN DO: /* Linha de producao */
                        IF NOT CAN-FIND(FIRST lin-prod WHERE lin-prod.nr-linha = INT(RowObject.des-campo)) THEN DO:
                            {utp/ut-liter.i linha_de_produá∆o *}
                            {method/svc/errors/inserr.i
                                &ErrorNumber = "2"
                                &ErrorType = "EMS"
                                &ErrorSubType = "ERROR"
                                &ErrorParameters="return-value"}
                        END.
                    END.
                    WHEN "cod-estabel":U THEN DO: /* Estabelecimento */
                        IF NOT CAN-FIND(FIRST estabelec WHERE estabelec.cod-estabel = RowObject.des-campo) THEN DO:
                            {utp/ut-liter.i estabelecimento *}
                            {method/svc/errors/inserr.i
                                &ErrorNumber = "2"
                                &ErrorType = "EMS"
                                &ErrorSubType = "ERROR"
                                &ErrorParameters="return-value"}
                        END.
                    END.
                    WHEN "cd-planejado":U THEN DO: /* Planejador */
                        IF NOT CAN-FIND(FIRST planejad WHERE planejad.cd-planejado = RowObject.des-campo) THEN DO:
                            {utp/ut-liter.i planejador *}
                            {method/svc/errors/inserr.i
                                &ErrorNumber = "2"
                                &ErrorType = "EMS"
                                &ErrorSubType = "ERROR"
                                &ErrorParameters="return-value"}
                        END.
                    END.
                END CASE.
                
                IF CAN-FIND(FIRST bf{&TableName} WHERE bf{&TableName}.idi-entidade = 1
                                                   AND bf{&TableName}.cod-campo = RowObject.cod-campo
                                                   AND (bf{&TableName}.des-campo = "*":U
                                                     OR bf{&TableName}.des-campo = RowObject.des-campo)) THEN DO:
                    {utp/ut-liter.i "Existe um filtro igual ou '*' cadastrado." *}
                    {method/svc/errors/inserr.i
                        &ErrorNumber = "17006"
                        &ErrorType = "EMS"
                        &ErrorSubType = "ERROR"
                        &ErrorParameters="return-value"}
                END.
            END.
        END.
        /* Validacoes para o item */
        IF RowObject.idi-entidade = 4 THEN DO:
            IF TRIM(RowObject.des-campo) = "*":U THEN DO:
                IF CAN-FIND(FIRST bf{&TableName} WHERE bf{&TableName}.idi-entidade = 4 AND
                                                       bf{&TableName}.cod-campo = RowObject.cod-campo) THEN DO:
                    {utp/ut-liter.i "N∆o Ç poss°vel cadastrar o filtro '*' com outros filtros j† cadastrados." *}
                    {method/svc/errors/inserr.i
                        &ErrorNumber = "17006"
                        &ErrorType = "EMS"
                        &ErrorSubType = "ERROR"
                        &ErrorParameters="return-value"}
                END.
            END.
            ELSE DO:
                CASE RowObject.cod-campo:
                    WHEN "it-codigo":U THEN DO: /* Codigo do Item */
                        IF NOT CAN-FIND(FIRST item WHERE item.it-codigo = RowObject.des-campo) THEN DO:
                            {utp/ut-liter.i item *}
                            {method/svc/errors/inserr.i
                                &ErrorNumber = "2"
                                &ErrorType = "EMS"
                                &ErrorSubType = "ERROR"
                                &ErrorParameters="return-value"}
                        END.
                    END.
                    WHEN "fm-codigo":U THEN DO: /* Familia Material */
                        IF NOT CAN-FIND(FIRST familia WHERE familia.fm-codigo = RowObject.des-campo) THEN DO:
                            {utp/ut-liter.i fam°lia *}
                            {method/svc/errors/inserr.i
                                &ErrorNumber = "2"
                                &ErrorType = "EMS"
                                &ErrorSubType = "ERROR"
                                &ErrorParameters="return-value"}
                        END.
                    END.
                    WHEN "ge-codigo":U THEN DO: /* Grupo Estoque */
                        IF NOT CAN-FIND(FIRST grup-estoque WHERE grup-estoque.ge-codigo = int(RowObject.des-campo)) THEN DO:
                            {utp/ut-liter.i grupo_estoque *}
                            {method/svc/errors/inserr.i
                                &ErrorNumber = "2"
                                &ErrorType = "EMS"
                                &ErrorSubType = "ERROR"
                                &ErrorParameters="return-value"}
                        END.
                    END.
                END CASE.
                
                IF CAN-FIND(FIRST bf{&TableName} WHERE bf{&TableName}.idi-entidade = 4
                                                   AND bf{&TableName}.cod-campo = RowObject.cod-campo
                                                   AND (bf{&TableName}.des-campo = "*":U
                                                     OR bf{&TableName}.des-campo = RowObject.des-campo)) THEN DO:
                    {utp/ut-liter.i "Existe um filtro igual ou '*' cadastrado." *}
                    {method/svc/errors/inserr.i
                        &ErrorNumber = "17006"
                        &ErrorType = "EMS"
                        &ErrorSubType = "ERROR"
                        &ErrorParameters="return-value"}
                END.
            END.
        END.
        /* Validacoes para o saldo do item */
        IF RowObject.idi-entidade = 3 THEN DO:
            IF TRIM(RowObject.des-campo) = "*":U THEN DO:
                IF CAN-FIND(FIRST bf{&TableName} WHERE bf{&TableName}.idi-entidade = 3 AND
                                                       bf{&TableName}.cod-campo = RowObject.cod-campo) THEN DO:
                    {utp/ut-liter.i "N∆o Ç poss°vel cadastrar o filtro '*' com outros filtros j† cadastrados." *}
                    {method/svc/errors/inserr.i
                        &ErrorNumber = "17006"
                        &ErrorType = "EMS"
                        &ErrorSubType = "ERROR"
                        &ErrorParameters="return-value"}
                END.
            END.
            ELSE DO:
                CASE RowObject.cod-campo:
                    WHEN "it-codigo":U THEN DO: /* Codigo do Item */
                        IF NOT CAN-FIND(FIRST item WHERE item.it-codigo = RowObject.des-campo) THEN DO:
                            {utp/ut-liter.i item *}
                            {method/svc/errors/inserr.i
                                &ErrorNumber = "2"
                                &ErrorType = "EMS"
                                &ErrorSubType = "ERROR"
                                &ErrorParameters="return-value"}
                        END.
                    END.
                    WHEN "fm-codigo":U THEN DO: /* Familia Material */
                        IF NOT CAN-FIND(FIRST familia WHERE familia.fm-codigo = RowObject.des-campo) THEN DO:
                            {utp/ut-liter.i fam°lia *}
                            {method/svc/errors/inserr.i
                                &ErrorNumber = "2"
                                &ErrorType = "EMS"
                                &ErrorSubType = "ERROR"
                                &ErrorParameters="return-value"}
                        END.
                    END.
                    WHEN "ge-codigo":U THEN DO: /* Grupo Estoque */
                        IF NOT CAN-FIND(FIRST grup-estoque WHERE grup-estoque.ge-codigo = int(RowObject.des-campo)) THEN DO:
                            {utp/ut-liter.i grupo_estoque *}
                            {method/svc/errors/inserr.i
                                &ErrorNumber = "2"
                                &ErrorType = "EMS"
                                &ErrorSubType = "ERROR"
                                &ErrorParameters="return-value"}
                        END.
                    END.
                    WHEN "cod-estabel":U THEN DO: /* Estabelecimento */
                        IF NOT CAN-FIND(FIRST estabelec WHERE estabelec.cod-estabel = RowObject.des-campo) THEN DO:
                            {utp/ut-liter.i estabelecimento *}
                            {method/svc/errors/inserr.i
                                &ErrorNumber = "2"
                                &ErrorType = "EMS"
                                &ErrorSubType = "ERROR"
                                &ErrorParameters="return-value"}
                        END.
                    END.
                    WHEN "cod-depos":U THEN DO: /* Deposito */
                        IF NOT CAN-FIND(FIRST deposito WHERE deposito.cod-depos = RowObject.des-campo) THEN DO:
                            {utp/ut-liter.i grupo_estoque *}
                            {method/svc/errors/inserr.i
                                &ErrorNumber = "2"
                                &ErrorType = "EMS"
                                &ErrorSubType = "ERROR"
                                &ErrorParameters="return-value"}
                        END.
                    END.
                    WHEN "cod-localiz":U THEN DO: /* Localizacao */
                        IF NOT CAN-FIND(FIRST localizacao WHERE localizacao.cod-localiz = RowObject.des-campo) THEN DO:
                            {utp/ut-liter.i grupo_estoque *}
                            {method/svc/errors/inserr.i
                                &ErrorNumber = "2"
                                &ErrorType = "EMS"
                                &ErrorSubType = "ERROR"
                                &ErrorParameters="return-value"}
                        END.
                    END.
                END CASE.
                
                IF CAN-FIND(FIRST bf{&TableName} WHERE bf{&TableName}.idi-entidade = 3
                                                   AND bf{&TableName}.cod-campo = RowObject.cod-campo
                                                   AND (bf{&TableName}.des-campo = "*":U
                                                     OR bf{&TableName}.des-campo = RowObject.des-campo)) THEN DO:
                    {utp/ut-liter.i "Existe um filtro igual ou '*' cadastrado." *}
                    {method/svc/errors/inserr.i
                        &ErrorNumber = "17006"
                        &ErrorType = "EMS"
                        &ErrorSubType = "ERROR"
                        &ErrorParameters="return-value"}
                END.
            END.
        END.
        /* Validacoes para o Estrutura/OperaÁıes */
        IF RowObject.idi-entidade = 2 THEN DO:
            IF TRIM(RowObject.des-campo) = "*":U THEN DO:
                IF CAN-FIND(FIRST bf{&TableName} WHERE bf{&TableName}.idi-entidade = 2 AND
                                                       bf{&TableName}.cod-campo = RowObject.cod-campo) THEN DO:
                    {utp/ut-liter.i "N∆o Ç poss°vel cadastrar o filtro '*' com outros filtros j† cadastrados." *}
                    {method/svc/errors/inserr.i
                        &ErrorNumber = "17006"
                        &ErrorType = "EMS"
                        &ErrorSubType = "ERROR"
                        &ErrorParameters="return-value"}
                END.
            END.
            ELSE DO:
                CASE RowObject.cod-campo:
                    WHEN "it-codigo":U THEN DO: /* Codigo do Item */
                        IF NOT CAN-FIND(FIRST item WHERE item.it-codigo = RowObject.des-campo) THEN DO:
                            {utp/ut-liter.i item *}
                            {method/svc/errors/inserr.i
                                &ErrorNumber = "2"
                                &ErrorType = "EMS"
                                &ErrorSubType = "ERROR"
                                &ErrorParameters="return-value"}
                        END.
                    END.
                    WHEN "fm-codigo":U THEN DO: /* Familia Material */
                        IF NOT CAN-FIND(FIRST familia WHERE familia.fm-codigo = RowObject.des-campo) THEN DO:
                            {utp/ut-liter.i fam°lia *}
                            {method/svc/errors/inserr.i
                                &ErrorNumber = "2"
                                &ErrorType = "EMS"
                                &ErrorSubType = "ERROR"
                                &ErrorParameters="return-value"}
                        END.
                    END.
                    WHEN "ge-codigo":U THEN DO: /* Grupo Estoque */
                        IF NOT CAN-FIND(FIRST grup-estoque WHERE grup-estoque.ge-codigo = int(RowObject.des-campo)) THEN DO:
                            {utp/ut-liter.i grupo_estoque *}
                            {method/svc/errors/inserr.i
                                &ErrorNumber = "2"
                                &ErrorType = "EMS"
                                &ErrorSubType = "ERROR"
                                &ErrorParameters="return-value"}
                        END.
                    END.
                END CASE.
                
                IF CAN-FIND(FIRST bf{&TableName} WHERE bf{&TableName}.idi-entidade = 2
                                                   AND bf{&TableName}.cod-campo = RowObject.cod-campo
                                                   AND (bf{&TableName}.des-campo = "*":U
                                                     OR bf{&TableName}.des-campo = RowObject.des-campo)) THEN DO:
                    {utp/ut-liter.i "Existe um filtro igual ou '*' cadastrado." *}
                    {method/svc/errors/inserr.i
                        &ErrorNumber = "17006"
                        &ErrorType = "EMS"
                        &ErrorSubType = "ERROR"
                        &ErrorParameters="return-value"}
                END.
            END.
        END.
    END.
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

