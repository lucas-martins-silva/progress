&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/**************************************************************************
** Copyright TOTVS S.A. (2025) 
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa. 
***************************************************************************/
{include/i-prgvrs.i BOIN306 2.00.00.014 } /*** "010014" 28/07/2026 18:01:50 ***/
{include/i-license-manager.i boin306 MUT}

/*:T--------------------------------------------------------------------------
    File       : boin306.p
    Purpose    : O DBO (Datasul Business Objects) Ç um programa PROGRESS 
                 que contÇm a l¢gica de neg¢cio e acesso a dados para uma 
                 tabela do banco de dados.

    Notes: Tabela de parÉmetros dos eventos dos tributos (Reforma tribut†ria)
           Podem ser parametrizados por estabelecimento ou genÇrico (todos estab)
           por evento.
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN306
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName param-evento-trib-dfe
&GLOBAL-DEFINE TableLabel ParÉmetros dos Eventos tributos
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
{inbo/boin306.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

def var hBOEspecifica as handle no-undo.

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
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-evento":U THEN ASSIGN pFieldValue = RowObject.cod-evento.
        WHEN "cod-versao-evento":U THEN ASSIGN pFieldValue = RowObject.cod-versao-evento.
        WHEN "modulo-orig-info":U THEN ASSIGN pFieldValue = RowObject.modulo-orig-info.
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
        WHEN "idi-tip-dfe":U THEN ASSIGN pFieldValue = RowObject.idi-tip-dfe.
        WHEN "ambiente":U THEN ASSIGN pFieldValue = RowObject.ambiente.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram  
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice primary-unique
  Parameters:  
               retorna valor do campo cod-estabel
               retorna valor do campo cod-evento
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE param-evento-trib-dfe.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-evento LIKE param-evento-trib-dfe.cod-evento NO-UNDO.
    DEFINE OUTPUT PARAMETER pidi-tip-dfe LIKE param-evento-trib-dfe.idi-tip-dfe NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-estabel = RowObject.cod-estabel
           pcod-evento = RowObject.cod-evento
           pidi-tip-dfe = RowObject.idi-tip-dfe.

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
        WHEN "log-gerac-auto":U THEN ASSIGN pFieldValue = RowObject.log-gerac-auto.
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
  Purpose:     Reposiciona registro com base no °ndice primary-unique
  Parameters:  
               recebe valor do campo cod-estabel
               recebe valor do campo cod-evento
               recebe valor do campo seq-evento
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE param-evento-trib-dfe.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pcod-evento LIKE param-evento-trib-dfe.cod-evento NO-UNDO.
    DEFINE INPUT PARAMETER pidi-tip-dfe LIKE param-evento-trib-dfe.idi-tip-dfe NO-UNDO.

    FIND FIRST bfparam-evento-trib-dfe WHERE 
        bfparam-evento-trib-dfe.cod-estabel = pcod-estabel AND 
        bfparam-evento-trib-dfe.cod-evento = pcod-evento AND
        bfparam-evento-trib-dfe.idi-tip-dfe = pidi-tip-dfe NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfparam-evento-trib-dfe THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfparam-evento-trib-dfe)).
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
   OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK INDEXED-REPOSITION.

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
    CASE pType:
        WHEN "Create":U OR WHEN "Update":U THEN DO:
            IF pType = "Create":U THEN DO:
                /*:T--- Validaá∆o espec°fica para Create ---*/
                /*:T--- Verifica se o registro j† existe, caso exista, retorna erro ---*/
                IF can-find(first bf{&TableName}
                            where bf{&TableName}.cod-estabel  = RowObject.cod-estabel
                              and bf{&TableName}.idi-tip-dfe  = RowObject.idi-tip-dfe
                              and bf{&TableName}.cod-evento   = RowObject.cod-evento) then do:
                    {utp/ut-liter.i "ParÉmetros_evento_tributos" * }
                    {method/svc/errors/inserr.i &ErrorNumber=7
                                                &ErrorType="EMS"
                                                &ErrorParameters="RETURN-VALUE"}
                end.
            END.

            IF RowObject.idi-tip-dfe = 0 OR
               RowObject.idi-tip-dfe = ? THEN DO:
                {utp/ut-liter.i Tipo_DFE * }
                {method/svc/errors/inserr.i &ErrorNumber="56274"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="RETURN-VALUE"}
            END.
            IF RowObject.cod-evento = "" OR
               RowObject.cod-evento = ? THEN DO:
                {utp/ut-liter.i Evento * }
                {method/svc/errors/inserr.i &ErrorNumber="56274"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="RETURN-VALUE"}
            END.
            IF RowObject.cod-estabel = "" OR
               RowObject.cod-estabel = ? THEN DO:
                {utp/ut-liter.i Estabelecimento * }
                {method/svc/errors/inserr.i &ErrorNumber="56274"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="RETURN-VALUE"}
            END.
            IF RowObject.cod-versao-evento = "" OR
               RowObject.cod-versao-evento = ? THEN DO:
                {utp/ut-liter.i Vers∆o_evento * }
                {method/svc/errors/inserr.i &ErrorNumber="56274"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="RETURN-VALUE"}
            END.
        END.
        WHEN "Delete":U THEN DO:
        END.
    END CASE.

    RUN carregaHandleEspecifico (INPUT RowObject.modulo-orig-info,
                                 INPUT "validateRecord").
    IF RETURN-VALUE = "OK":U THEN DO:
        //Vai rodar o validateRecord espec°fico por m¢dulo 
        RUN validateRecord IN hBOEspecifica (INPUT pType,
                                             INPUT TABLE RowObject,
                                             OUTPUT TABLE RowErrors APPEND).
    END.
    DELETE PROCEDURE hBOEspecifica NO-ERROR.

    RUN carregaHandleEspecifico (INPUT RowObject.cod-evento,
                                 INPUT "validateRecord").
    IF RETURN-VALUE = "OK":U THEN DO:
        //Vai rodar o validateRecord espec°fico por evento 
        RUN validateRecord IN hBOEspecifica (INPUT pType,
                                             INPUT TABLE RowObject,
                                             OUTPUT TABLE RowErrors APPEND).
    END.
    DELETE PROCEDURE hBOEspecifica NO-ERROR.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaHandleEspecifico DBOProgram
PROCEDURE carregaHandleEspecifico PRIVATE:
    DEFINE INPUT  PARAM cCodEventoOuModulo AS CHAR NO-UNDO.
    DEFINE INPUT  PARAM cProcedureInterna AS CHAR NO-UNDO.

    IF SEARCH ("inbo/boin306-" + cCodEventoOuModulo + ".r") <> ? THEN DO:
        RUN VALUE("inbo/boin306-" + cCodEventoOuModulo + ".r") PERSISTENT SET hBOEspecifica.
        IF LOOKUP(cProcedureInterna, hBOEspecifica:INTERNAL-ENTRIES) <> 0 THEN DO: /* Existe a procedure interna no programa! */
            RETURN "OK":U.
        END.
        DELETE PROCEDURE hBOEspecifica NO-ERROR.
    END.
    RETURN "NOK":U.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE posicionaRegistro DBOProgram  
PROCEDURE posicionaRegistro :
/*------------------------------------------------------------------------------
  Purpose:     Posiciona registro com base na key OU caso
               n∆o tenha a key espec°fica, posiciona com estab *
  Parameters:  
               recebe valor do campo cod-estabel
               recebe valor do campo cod-evento
               recebe valor do campo seq-evento
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE param-evento-trib-dfe.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pcod-evento LIKE param-evento-trib-dfe.cod-evento NO-UNDO.
    DEFINE INPUT PARAMETER pidi-tip-dfe LIKE param-evento-trib-dfe.idi-tip-dfe NO-UNDO.

    IF pcod-estabel = "" OR pcod-estabel = ? THEN DO:
        ASSIGN pcod-estabel = "*":U.    
    END.

    IF pidi-tip-dfe = 0 OR pidi-tip-dfe = ? THEN DO:
        ASSIGN pidi-tip-dfe = 1. /* NF-e */   
    END.

    RUN goToKey (INPUT pcod-estabel,
                 INPUT pcod-evento,
                 INPUT pidi-tip-dfe).
    IF RETURN-VALUE = "OK":U THEN
        RETURN RETURN-VALUE.

    IF pcod-estabel <> "*":U THEN DO:
        RUN goToKey (INPUT "*":U,
                     INPUT pcod-evento,
                     INPUT pidi-tip-dfe).
        RETURN RETURN-VALUE.
    END.

    RETURN "NOK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getModulosDefault DBOProgram  
PROCEDURE getModulosDefault :
/*------------------------------------------------------------------------------
  Purpose:     Com base na key, retorna o m¢dulo default e lista m¢dulos para o 
               evento, estab, tipo docto
  Parameters:  
               recebe valor do campo cod-estabel
               recebe valor do campo cod-evento
               recebe valor do campo seq-evento
  Notes:  
    // Relaá∆o M¢dulos x Eventos conforme planilha: 
    // https://docs.google.com/spreadsheets/d/1qFc6Ro96VAijDQDrJHYNy6eDv_WYvwVrs-uGFdApVng/edit?gid=0#gid=0     
    // Retirado o m¢dulo MOF do plist-modulos dos eventos: 112110/112120/112120/211120
    // 211124/211140/112130/112140, serao adicionados cforme forem desenvolvidos.
    // Foi retirado o m¢dulo MRE do plist-modulos do evento 112140, dever† ser adicionado quando for desenvolvido.
    // Foi retirado o m¢dulo APB do plist-modulos do evento 211150, dever† ser adicionado quando for desenvolvido. 
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE param-evento-trib-dfe.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pcod-evento LIKE param-evento-trib-dfe.cod-evento NO-UNDO.
    DEFINE INPUT PARAMETER pidi-tip-dfe LIKE param-evento-trib-dfe.idi-tip-dfe NO-UNDO.
    DEFINE OUTPUT PARAMETER plist-modulos           AS CHAR NO-UNDO.
    DEFINE OUTPUT PARAMETER pmodulo-orig-default    AS CHAR NO-UNDO.
        
    CASE pcod-evento:
        WHEN "110001" THEN DO:
            ASSIGN plist-modulos = "NINFO,ACR,APB,MOF,MFT,MRE,FAS":U
                   pmodulo-orig-default = "NINFO":U.
        END.
        WHEN "112110" THEN DO:
            ASSIGN plist-modulos = "NINFO,ACR":U
                   pmodulo-orig-default = "ACR":U.
        END.
        WHEN "211128" THEN DO:
            ASSIGN plist-modulos = "NINFO,MRE,MOF":U
                   pmodulo-orig-default = "MRE":U.
        END.
        WHEN "211110" THEN DO:
            ASSIGN plist-modulos = "NINFO,MRE,MFT":U
                   pmodulo-orig-default = "MRE":U.
        END.
        WHEN "112120" OR 
        WHEN "211120" OR 
        WHEN "211124" OR 
        WHEN "211140" THEN DO:
            ASSIGN plist-modulos = "NINFO,MRE":U
                   pmodulo-orig-default = "NINFO":U.
        END.
        WHEN "112130" THEN DO:
            ASSIGN plist-modulos = "NINFO,MFT":U
                   pmodulo-orig-default = "MFT":U.
        END.
        WHEN "112140" THEN DO:
            ASSIGN plist-modulos = "NINFO,MFT":U
                   pmodulo-orig-default = "MFT":U.
        END.
        WHEN "112150" THEN DO:
          ASSIGN plist-modulos = "NINFO,MFT,MRE":U
                 pmodulo-orig-default = "MFT":U.
        END.
        WHEN "211130" THEN DO:
            ASSIGN plist-modulos = "NINFO,FAS":U
                   pmodulo-orig-default = "FAS":U.
        END.
        WHEN "211150" THEN DO:
            ASSIGN plist-modulos = "NINFO,MRE":U
                   pmodulo-orig-default = "MRE":U.
        END.
        WHEN "212110" OR WHEN "212120" THEN DO:
            ASSIGN plist-modulos = "NINFO,MOF":U
                   pmodulo-orig-default = "MOF":U.
        END.
        WHEN "110750" THEN DO:
            ASSIGN plist-modulos = "ACR":U
                   pmodulo-orig-default = "ACR":U.
        END.                   
        WHEN "110751" THEN DO:
            ASSIGN plist-modulos = "ACR":U
                   pmodulo-orig-default = "ACR":U.
        END.                   
    END CASE.
    
    RETURN "NOK":U.
END PROCEDURE.
      
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

