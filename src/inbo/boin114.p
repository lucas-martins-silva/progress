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
{include/i-prgvrs.i BOIN114 2.00.00.018 } /*** "010018" 17/06/2025 16:40:46 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN114 MUT}
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
&GLOBAL-DEFINE DBOName BOIN114
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName exame
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

&GLOBAL-DEFINE KeyField1 cod-exame /*:T Informar os campos da chave quando o Progress nío conseguir resolver find {&TableName} OF RowObject. */
&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (m≤todo Receive Message) */
/* &GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES */

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

&GLOBAL-DEFINE QueryDefault       /*:T Nome da Query que d† acessos a todos os registros, exceto os exclu°dos pela constraint de seguranáa. Usada para receber uma mensagem XML. */

*/
/* DBO-XML-END */

/*:T--- Include com definiá∆o da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin114.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}

{utp/ut-glob.i}

{cdp/cdcfgmat.i}

&GLOBAL-DEFINE KeyField2 cdn-versao /*:T Informar os campos da chave quando o Progress nío conseguir resolver find {&TableName} OF RowObject. */

/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
DEFINE BUFFER bf-exame FOR {&TableName}.
DEFINE BUFFER bf-comp-exame FOR comp-exame.

 /* Definiá∆o temp-table ttExames utilizada na procedure returnExames */
DEFINE TEMP-TABLE tt-todosExames NO-UNDO
   FIELD codExame AS INTEGER LABEL "C¢digo".

DEFINE TEMP-TABLE ttExamesPag NO-UNDO
   FIELD codExame AS INTEGER LABEL "C¢digo"
   FIELD descricao AS CHARACTER LABEL "Descriá∆o".

DEFINE TEMP-TABLE ttExamesReturn NO-UNDO
   FIELD codExame AS INTEGER LABEL "C¢digo".

{inbo/boin114.i tt-exames-copy}

DEFINE VARIABLE hTable       AS HANDLE      NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE hbTT       AS HANDLE NO-UNDO.
DEFINE VARIABLE l-lote-avancado AS LOGICAL  INITIAL FALSE   NO-UNDO.

/*Verifica se tem o lote avanáado ativo*/
IF CAN-FIND(FIRST funcao 
           WHERE funcao.cd-funcao = "lote-avancado" 
           AND   funcao.ativo     = TRUE NO-LOCK) THEN DO:
    ASSIGN l-lote-avancado = TRUE.
END.

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
         HEIGHT             = 16.75
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram 
PROCEDURE afterCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    IF RowObject.cdn-versao > 1 THEN DO:
        FOR FIRST bf{&TableName}
            WHERE bf{&TableName}.cod-exame    = RowObject.cod-exame
            AND   bf{&TableName}.cdn-sit-vers = 2 NO-LOCK:          

            FOR EACH  bf-comp-exame
                    WHERE bf-comp-exame.cod-exame  = RowObject.cod-exame
                    AND   bf-comp-exame.cdn-versao = bf{&TableName}.cdn-versao NO-LOCK:

                    CREATE comp-exame.
                    ASSIGN comp-exame.cdn-versao = RowObject.cdn-versao.
                    BUFFER-COPY bf-comp-exame EXCEPT bf-comp-exame.cdn-versao TO comp-exame.
            END.
        END.
    END.
                
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
    IF CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "lote-avancado":u AND
                                                       funcao.ativo) THEN DO:
        FOR EACH comp-exame
            WHERE comp-exame.cod-exame = RowObject.cod-exame
            AND   comp-exame.cdn-versao = RowObject.cdn-versao EXCLUSIVE-LOCK:
            DELETE comp-exame.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeCreateRecord DBOProgram 
PROCEDURE beforeCreateRecord :
/*------------------------------------------------------------------------------
  Purpose: 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN RowObject.dat-criac       = TODAY
               RowObject.hra-criac       = STRING(TIME,"HH:MM:SS")
               RowObject.cod-usuar-criac = c-seg-usuario
               RowObject.dat-termino     = ?
               RowObject.hra-term        = "".

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaNovaVersao DBOProgram 
PROCEDURE buscaNovaVersao :
/*------------------------------------------------------------------------------
  Purpose: 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pExame         AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER pIsNovaVersao  AS LOGICAL NO-UNDO.
    DEFINE OUTPUT PARAMETER pNumNovaVersao AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER PDescricao     AS CHARACTER NO-UNDO.
    
    FOR LAST exame
        WHERE exame.cod-exame = pExame NO-LOCK
        BREAK BY exame.cdn-versao:
        
        ASSIGN pIsNovaVersao = TRUE
               pNumNovaVersao = exame.cdn-versao + 1
               pDescricao  = exame.descricao.

    END.

    IF NOT AVAIL exame THEN DO:

        ASSIGN pIsNovaVersao = FALSE
               pNumNovaVersao = 1
               pDescricao = "".
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaVersaoLiberada DBOProgram 
PROCEDURE buscaVersaoLiberada :
/*------------------------------------------------------------------------------
  Purpose: Retornar a vers„o liberada do exame 
  Parameters:  pExame: Codigo do Exame (INPUT)
               pVersaoLiberada: CÛdigo da vers„o liberada do exame (OUTPUT)
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pExame          AS INTEGER NO-UNDO.   
    DEFINE OUTPUT PARAMETER pVersaoLiberada AS INTEGER NO-UNDO.
    
    FOR FIRST exame FIELDS(cdn-versao) NO-LOCK
        WHERE exame.cod-exame = pExame 
          AND exame.cdn-sit-vers = 2 /* Liberada */ :
        ASSIGN pVersaoLiberada = exame.cdn-versao.
    END.
    
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
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-resp":U THEN ASSIGN pFieldValue = RowObject.cod-resp.
        WHEN "cod-usuar-criac":U THEN ASSIGN pFieldValue = RowObject.cod-usuar-criac.
        WHEN "cod-usuar-liber":U THEN ASSIGN pFieldValue = RowObject.cod-usuar-liber.
        WHEN "descricao":U THEN ASSIGN pFieldValue = RowObject.descricao.
        WHEN "hra-criac":U THEN ASSIGN pFieldValue = RowObject.hra-criac.
        WHEN "hra-liber":U THEN ASSIGN pFieldValue = RowObject.hra-liber.
        WHEN "hra-term":U THEN ASSIGN pFieldValue = RowObject.hra-term.
        WHEN "metodo":U THEN ASSIGN pFieldValue = RowObject.metodo.
        WHEN "refer-tec":U THEN ASSIGN pFieldValue = RowObject.refer-tec.
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
        WHEN "dat-criac":U THEN ASSIGN pFieldValue = RowObject.dat-criac.
        WHEN "dat-liber":U THEN ASSIGN pFieldValue = RowObject.dat-liber.
        WHEN "dat-termino":U THEN ASSIGN pFieldValue = RowObject.dat-termino.
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
        WHEN "perc-nqa":U THEN ASSIGN pFieldValue = RowObject.perc-nqa.
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
        WHEN "cdn-sit-vers":U THEN ASSIGN pFieldValue = RowObject.cdn-sit-vers.
        WHEN "cdn-versao":U THEN ASSIGN pFieldValue = RowObject.cdn-versao.
        WHEN "cod-exame":U THEN ASSIGN pFieldValue = RowObject.cod-exame.
        WHEN "frequencia":U THEN ASSIGN pFieldValue = RowObject.frequencia.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "nivel":U THEN ASSIGN pFieldValue = RowObject.nivel.
        WHEN "situacao":U THEN ASSIGN pFieldValue = RowObject.situacao.
        WHEN "tam-fixo-amost":U THEN ASSIGN pFieldValue = RowObject.tam-fixo-amost.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram  
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice codigo
  Parameters:  
               retorna valor do campo cod-exame
               retorna valor do campo cdn-versao
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-exame LIKE exame.cod-exame NO-UNDO.
    DEFINE OUTPUT PARAMETER pcdn-versao LIKE exame.cdn-versao NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-exame = RowObject.cod-exame
           pcdn-versao = RowObject.cdn-versao.

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
        WHEN "amostragem":U THEN ASSIGN pFieldValue = RowObject.amostragem.
        WHEN "destrutivo":U THEN ASSIGN pFieldValue = RowObject.destrutivo.
        WHEN "homogeneo":U THEN ASSIGN pFieldValue = RowObject.homogeneo.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "log-exam-antes-nf":U THEN ASSIGN pFieldValue = RowObject.log-exam-antes-nf.
        WHEN "log-exter":U THEN ASSIGN pFieldValue = RowObject.log-exter.
        WHEN "rejeita-lote":U THEN ASSIGN pFieldValue = RowObject.rejeita-lote.
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
  Purpose:     Reposiciona registro com base no °ndice codigo
  Parameters:  
               recebe valor do campo cod-exame
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-exame LIKE exame.cod-exame NO-UNDO.
    DEFINE INPUT PARAMETER pcdn-versao LIKE exame.cdn-versao NO-UNDO.

    FIND FIRST bfexame 
        WHERE bfexame.cod-exame = pcod-exame
          AND bfexame.cdn-versao = pcdn-versao NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfexame THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfexame)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKeyByExame DBOProgram
PROCEDURE goToKeyByExame :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no n˙mero do exame
               buscando vers„o ativa.
  Parameters:
               recebe valor do campo cod-exame
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-exame LIKE exame.cod-exame NO-UNDO.

    FIND FIRST bfexame
        WHERE bfexame.cod-exame    = pcod-exame
          AND bfexame.cdn-sit-vers = 2 NO-LOCK NO-ERROR.
    IF NOT AVAILABLE bfexame THEN
        FIND FIRST bfexame
            WHERE bfexame.cod-exame    = pcod-exame
              AND bfexame.cdn-sit-vers = 0 NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfexame THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfexame)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKeySituacao DBOProgram 
PROCEDURE goToKeySituacao :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice codigo
  Parameters:  
               recebe valor do campo cod-exame
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-exame LIKE exame.cod-exame NO-UNDO.
    
    FIND FIRST bfexame NO-LOCK
         WHERE bfexame.cod-exame    = pcod-exame
           AND bfexame.cdn-sit-vers = 2 /* Liberado */
           AND bfexame.situacao     = 1 /* Ativo */  NO-ERROR.
           
    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfexame THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfexame)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE liberaVersao DBOProgram 
PROCEDURE liberaVersao :
/*------------------------------------------------------------------------------
  Purpose: 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pExame   AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER pVersao  AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER pErro    AS CHARACTER NO-UNDO.
    
    FOR FIRST bf-exame
        WHERE bf-exame.cod-exame  = pExame
        AND   bf-exame.cdn-versao = pVersao EXCLUSIVE-LOCK:

        IF bf-exame.cdn-sit-vers <> 1 THEN DO:
                {utp/ut-liter.i Somente_exames_Pendentes_poder∆o_ser_Liberados}
                ASSIGN pErro = RETURN-VALUE.
                RETURN "OK":U.
        END.
        ELSE DO:
            FOR FIRST exame
                WHERE exame.cod-exame  = bf-exame.cod-exame
                AND   exame.cdn-versao = 2 NO-LOCK:

                ASSIGN exame.cdn-versao  = 3
                       exame.dat-termino = TODAY
                       exame.hra-term    = STRING(TIME, "99:99:99").
            END.
            ASSIGN bf-exame.cdn-versao      = 2
                   bf-exame.dat-liber       = TODAY
                   bf-exame.hra-liber       = STRING(TIME, "99:99:99")
                   bf-exame.cod-usuar-liber = c-seg-usuario.
        END.
    END.

    IF NOT AVAIL bf-exame THEN DO:
            {utp/ut-liter.i Exame/vers∆o_n∆o_encontrada}
            ASSIGN pErro = RETURN-VALUE.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryAtivo DBOProgram 
PROCEDURE openQueryAtivo :
/*------------------------------------------------------------------------------
  Purpose: 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF l-lote-avancado THEN
       OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} 
            WHERE {&TABLENAME}.cdn-sit-vers = 2 /* Liberado */ NO-LOCK.
    ELSE
        OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} 
            WHERE {&TABLENAME}.situacao = 1 /* Ativo */ NO-LOCK .    
                                      
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDefault DBOProgram 
PROCEDURE openQueryDefault :
/*------------------------------------------------------------------------------
  Purpose: 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} NO-LOCK.

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
    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} NO-LOCK INDEXED-REPOSITION.
                                      
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-exame-sem-exam-sub-proc DBOProgram 
PROCEDURE pi-exame-sem-exam-sub-proc :
/*------------------------------------------------------------------------------
  Purpose:     Procedure para retornar os registros da tabela exames sem os 
                os registros da tabela exam-sub-proces-cq
  Parameters:  tt-exames-copy    - Temp-table que vai retornar os registros
               p-ep-codigo       - C¢digo da empresa
               p-cod-estabel     - C¢digo do Estabelecimento
               p-cod-area-produc - C¢digo da µrea de Produá∆o
               p-cod-proces      - C¢digo do Processo
               p-cod-subproces   - C¢digo do SubProcesso
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER TABLE FOR tt-exames-copy.
    DEFINE INPUT PARAMETER p-ep-codigo       LIKE exam-sub-proces-cq.ep-codigo       NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-estabel     LIKE exam-sub-proces-cq.cod-estabel     NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-area-produc LIKE exam-sub-proces-cq.cod-area-produc NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-proces      LIKE exam-sub-proces-cq.cod-proces      NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-subproces   LIKE exam-sub-proces-cq.cod-sub-proces  NO-UNDO.

    EMPTY TEMP-TABLE tt-exames-copy.

    FOR EACH bf{&TableName} NO-LOCK
        WHERE bf{&TableName}.cdn-sit-vers = 2 /* Liberado */
          AND bf{&TableName}.situacao = 1 : /* Ativo */
        /*Verifica se o registro j† existe na tabela de exam-sub-proces-cq*/
        IF NOT CAN-FIND(FIRST exam-sub-proces-cq
                        WHERE exam-sub-proces-cq.ep-codigo       = p-ep-codigo      
                        AND   exam-sub-proces-cq.cod-estabel     = p-cod-estabel    
                        AND   exam-sub-proces-cq.cod-area-produc = p-cod-area-produc
                        AND   exam-sub-proces-cq.cod-proces      = p-cod-proces     
                        AND   exam-sub-proces-cq.cod-sub-proces  = p-cod-subproces  
                        AND   exam-sub-proces-cq.cod-exame       = bf{&TableName}.cod-exame) THEN DO:
            /*Se n∆o existir cria um novo registro para ser copiado*/
            CREATE tt-exames-copy.
            BUFFER-COPY bf{&TableName} TO tt-exames-copy.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE populaTempTable DBOProgram 
PROCEDURE populaTempTable :
/*N£mero de registros mostrados por p ginas no grid (Pagina?∆o)*/
    DEFINE INPUT PARAM pageSize      AS INTEGER.
    DEFINE INPUT PARAM c-ttTableName AS CHARACTER.
    DEFINE OUTPUT PARAM totalRecords AS INTEGER.

    
    DEFINE VARIABLE hTT         AS HANDLE NO-UNDO.
    DEFINE VARIABLE qhTable     AS HANDLE NO-UNDO.
    DEFINE VARIABLE hField      AS HANDLE NO-UNDO.
    DEFINE VARIABLE cont        AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iCount      AS INTEGER     NO-UNDO.
    
    /*Criada Temp-table com a mesma estrutura do buffer de registros, adicionando uma nova coluna do tipo INTEIRO*/
    CREATE TEMP-TABLE hTT.
    hTT:CREATE-LIKE(hTable).
    hTT:ADD-NEW-FIELD("numPag", "INT").
    hTT:TEMP-TABLE-PREPARE("ttPag").
    hbTT = hTT:DEFAULT-BUFFER-HANDLE.
    
    /*Atualizar a temp-table rec?m criada com os dados do buffer de registros, atualizando a nova coluna com o n£mero da p gina que conter  o registro.*/
    CREATE QUERY qhTable.
    qhTable:SET-BUFFERS(hTable).
    qhTable:QUERY-PREPARE("PRESELECT EACH " + c-ttTableName + " INDEXED-REPOSITION").
    qhTable:QUERY-OPEN().

    /*Total de registros contido na tabela*/
    ASSIGN totalRecords = qhTable:NUM-RESULTS.
    
    ASSIGN cont = 0.
    IF qhTable:NUM-RESULTS > 0 THEN DO:
        ASSIGN cont = 1.
        REPEAT:
          qhTable:GET-NEXT().
          IF qhTable:QUERY-OFF-END THEN LEAVE.
    
          hbTT:BUFFER-CREATE().
          hbTT:BUFFER-COPY(hTable).
          IF iCount >= pageSize THEN DO:
            ASSIGN cont = cont + 1.
            ASSIGN iCount = 0.
          END.                
          ASSIGN hField = hbTT:BUFFER-FIELD('numPag')
                 hField:BUFFER-VALUE = cont.
          hbTT:BUFFER-RELEASE().
          ASSIGN iCount = iCount + 1.
        END.
    END.
    qhTable:QUERY-CLOSE().

    IF VALID-HANDLE(qhTable) THEN
        DELETE OBJECT qhTable.
    IF VALID-HANDLE(hTable) THEN
        DELETE OBJECT hTable.
    IF VALID-HANDLE(hField) THEN
        DELETE OBJECT hField.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaRegistros DBOProgram 
PROCEDURE retornaRegistros :
/*P gina atual do grid*/
    DEFINE INPUT PARAM currentPage   AS INTEGER.
    DEFINE INPUT PARAM phbTTReturn    AS HANDLE.
    DEFINE INPUT PARAM phTTReturn     AS HANDLE.
    
    DEFINE VARIABLE hTT    AS HANDLE NO-UNDO.
    DEFINE VARIABLE qhTemp AS HANDLE NO-UNDO.

    /* Mostrar resultado */
        CREATE QUERY qhTemp.
        qhTemp:SET-BUFFERS(hbTT).
        qhTemp:QUERY-PREPARE("PRESELECT EACH ttPag where numPag = " + STRING(currentPage) + " INDEXED-REPOSITION").
        qhTemp:QUERY-OPEN().
        IF VALID-HANDLE(qhTemp) AND valid-handle(hbTT) THEN DO:
            REPEAT:
                qhTemp:GET-NEXT(). 
                IF qhTemp:QUERY-OFF-END THEN LEAVE.
            
                phbTTReturn:BUFFER-CREATE().
                phbTTReturn:BUFFER-COPY(hbTT).
                phbTTReturn:BUFFER-RELEASE().
            END.
            qhTemp:QUERY-CLOSE().
        END.

 
    IF VALID-HANDLE(qhTemp) THEN
        DELETE OBJECT qhTemp.
    IF VALID-HANDLE(hTT) THEN
        DELETE OBJECT hTT.
    IF VALID-HANDLE(phTTReturn) THEN
        DELETE OBJECT phTTReturn.
    IF VALID-HANDLE(phbTTReturn) THEN
        DELETE OBJECT phbTTReturn.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaRegistrosExame DBOProgram 
PROCEDURE retornaRegistrosExame :
DEFINE INPUT PARAM currentPage   AS INTEGER.
    DEFINE OUTPUT PARAM TABLE FOR ttExamesReturn.
   
    DEFINE VARIABLE hTTReturn  AS HANDLE NO-UNDO. 
    DEFINE VARIABLE hbTTReturn AS HANDLE NO-UNDO. 

    ASSIGN hTTReturn = TEMP-TABLE ttExamesReturn:HANDLE.
    hbTTReturn = hTTReturn:DEFAULT-BUFFER-HANDLE.

    RUN retornaRegistros(INPUT currentPage, INPUT hbTTReturn, INPUT hTTReturn ).

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnExamesPag DBOProgram 
PROCEDURE returnExamesPag :
/*------------------------------------------------------------------------------
  Purpose:     Retorna temp-table com exames de situaá∆o 1(Pendente)
  Parameters:  
               recebe iCurrentPage - p†gina corrente
               recebe iPageSize - n£mero de registros por p†gina
               recebe temp-table com todos os exames
               retorna iTotalRecords - total de registros encontrados
               retorna ttExamesPag - temp-table 
             
  Notes:   Procedure utilizada para tela metadados (FF-CopiaComponentes Exame)    
------------------------------------------------------------------------------*/
   DEFINE INPUT  PARAMETER piCurrentPage AS INTEGER NO-UNDO.
   DEFINE INPUT  PARAMETER piPageSize AS INTEGER NO-UNDO.
   DEFINE INPUT PARAMETER TABLE FOR tt-todosExames. 
   DEFINE OUTPUT PARAMETER piTotalRecords AS INTEGER NO-UNDO.
   DEFINE OUTPUT PARAMETER TABLE FOR ttExamesPag.
    
   EMPTY TEMP-TABLE ttExamesPag NO-ERROR.
   ASSIGN hTable     = BUFFER tt-todosExames:HANDLE.
   RUN populaTempTable(INPUT piPageSize, INPUT "tt-todosExames", OUTPUT piTotalRecords).
   RUN retornaRegistrosExame(INPUT piCurrentPage, OUTPUT table tt-todosExames).

    FOR EACH tt-todosExames:
       FOR EACH exame FIELDS(cod-exame descricao) WHERE exame.cod-exame = tt-todosExames.codExame  NO-LOCK:
            CREATE ttExamesPag.
            ASSIGN ttExamesPag.codExame  = exame.cod-exame
                   ttExamesPag.descricao = exame.descricao.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnTodosExames DBOProgram 
PROCEDURE returnTodosExames :
/*------------------------------------------------------------------------------
  Purpose: retorna todos exames    
  Parameters:  <none>
  Notes:  Procedure criada pra a tela Metadados.     
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcIni AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pcFim AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-todosExames.
    DEFINE VARIABLE iIni AS INTEGER. 
    DEFINE VARIABLE iFim AS INTEGER.

    ASSIGN iIni = INTEGER(pcIni)
           iFim = INTEGER(pcFim).

    FOR EACH exame FIELDS(cod-exame)
        WHERE cod-exame >= iIni 
        AND cod-exame <= iFim
        AND (cdn-sit-vers = 2 or cdn-sit-vers = 0) NO-LOCK:
              CREATE tt-todosExames.
            ASSIGN tt-todosExames.codExame = exame.cod-exame.
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
        
    DEFINE VARIABLE l-lote-avancado AS LOGICAL INITIAL NO NO-UNDO.
    DEFINE VARIABLE c-aux-liter-1 AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-aux-liter-2 AS CHARACTER NO-UNDO.
    
    IF CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "lote-avancado":u AND funcao.ativo) THEN
       ASSIGN l-lote-avancado = YES.
    
    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/
        
    IF l-lote-avancado THEN DO:
        IF pType = "CREATE" THEN DO:
           IF CAN-FIND(exame
                       WHERE exame.cod-exame = RowObject.cod-exame AND exame.cdn-versao = RowObject.cdn-versao) THEN DO:
               {utp/ut-liter.i Exame/Vers∆o}
               {method/svc/errors/inserr.i
               &ErrorNumber="7" 
               &ErrorType="EMS"
               &ErrorSubType="ERROR"
               &ErrorParameters= RETURN-VALUE}
           END.
        END.
        IF pType = "UPDATE" THEN DO:
           IF RowObject.cdn-sit-vers > 1 THEN DO:
               {utp/ut-liter.i Somente_exames_pendentes_podem_sofrer_alteraá‰es}
               {method/svc/errors/inserr.i
               &ErrorNumber="17006"
               &ErrorType="EMS"
               &ErrorSubType="ERROR"
               &ErrorParameters=RETURN-VALUE}
           END.
        END.
        IF pType = "CREATE" OR pType = "UPDATE" THEN DO:
           IF RowObject.cod-exame < 1 THEN DO:
               {utp/ut-liter.i C¢digo_do_exame_dever†_ser_maior_que_zero}
               {method/svc/errors/inserr.i
               &ErrorNumber="17006"
               &ErrorType="EMS"
               &ErrorSubType="ERROR"
               &ErrorParameters=RETURN-VALUE}
           END.
           IF RowObject.descricao = "" THEN DO:
               {utp/ut-liter.i Descriá∆o_deve_ser_informada}
               {method/svc/errors/inserr.i
               &ErrorNumber="17006"
               &ErrorType="EMS"
               &ErrorSubType="ERROR"
               &ErrorParameters=RETURN-VALUE}
           END.
           IF RowObject.cod-resp = "" THEN DO:
               {utp/ut-liter.i Respons†vel_deve_ser_informado}
               {method/svc/errors/inserr.i
               &ErrorNumber="17006"
               &ErrorType="EMS"
               &ErrorSubType="ERROR"
               &ErrorParameters=RETURN-VALUE}
           END.
           IF RowObject.frequencia < 1 THEN DO:
               {utp/ut-liter.i Frequància_deve_ser_informado}
               {method/svc/errors/inserr.i
               &ErrorNumber="17006"
               &ErrorType="EMS"
               &ErrorSubType="ERROR"
               &ErrorParameters=RETURN-VALUE}
           END.
           IF RowObject.situacao < 1 THEN DO:
               {utp/ut-liter.i Situaá∆o_deve_ser_informada}
               {method/svc/errors/inserr.i
               &ErrorNumber="17006"
               &ErrorType="EMS"
               &ErrorSubType="ERROR"
               &ErrorParameters=RETURN-VALUE}
           END.
           IF NOT CAN-FIND(FIRST responsavel
                           WHERE responsavel.cod-resp = RowObject.cod-resp NO-LOCK) THEN DO:
               {utp/ut-liter.i Deve_ser_informado_um_Respons†vel_v†lido}
               {method/svc/errors/inserr.i
               &ErrorNumber="17006"
               &ErrorType="EMS"
               &ErrorSubType="ERROR"
               &ErrorParameters=RETURN-VALUE}
           END.
        END.
        IF pType = "DELETE" THEN DO:
            IF RowObject.cdn-sit-vers <> 1 THEN DO:
               {utp/ut-liter.i Exames_com_situaá∆o_Liberado/Terminado_n∆o_podem_ser_removidos}
               {method/svc/errors/inserr.i
               &ErrorNumber="17006"
               &ErrorType="EMS"
               &ErrorSubType="ERROR"
               &ErrorParameters=RETURN-VALUE}
            END.
            IF CAN-FIND(FIRST comp-exame WHERE
                    comp-exame.cod-exame = RowObject.cod-exame) THEN DO:
                {utp/ut-liter.i exame}
                ASSIGN c-aux-liter-1 = RETURN-VALUE.                    
                {utp/ut-liter.i comp-exame}
                ASSIGN c-aux-liter-2 = RETURN-VALUE.                                        
                
                {method/svc/errors/inserr.i
                   &ErrorNumber="5"
                   &ErrorType="EMS"
                   &ErrorSubType="ERROR"
                   &ErrorParameters= c-aux-liter-1 ~~ c-aux-liter-2}
            END. 
            IF CAN-FIND(FIRST it-exame WHERE
                    it-exame.cod-exame = RowObject.cod-exame) THEN DO:
                {utp/ut-liter.i exame}
                ASSIGN c-aux-liter-1 = RETURN-VALUE.                    
                {utp/ut-liter.i it-exame}
                ASSIGN c-aux-liter-2 = RETURN-VALUE.                            
                                
                {method/svc/errors/inserr.i
                   &ErrorNumber="5"
                   &ErrorType="EMS"
                   &ErrorSubType="ERROR"
                   &ErrorParameters= c-aux-liter-1 ~~ c-aux-liter-2}
            END.
            IF CAN-FIND(FIRST exam-ficha WHERE
                    exam-ficha.cod-exame = RowObject.cod-exame) THEN DO:                    
                {utp/ut-liter.i exame}
                ASSIGN c-aux-liter-1 = RETURN-VALUE.                    
                {utp/ut-liter.i exam-ficha}
                ASSIGN c-aux-liter-2 = RETURN-VALUE.
                 
                {method/svc/errors/inserr.i
                   &ErrorNumber="5"
                   &ErrorType="EMS"
                   &ErrorSubType="ERROR"
                   &ErrorParameters= c-aux-liter-1 ~~ c-aux-liter-2}
            END.
        END.
    END.
        /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN DO:
        RETURN "NOK":U.
        END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

