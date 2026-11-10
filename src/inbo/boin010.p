&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/*:T--------------------------------------------------------------------------
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

/*:T--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName BOIN010
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName rat-componente
&GLOBAL-DEFINE TableLabel Comp Envolvidos em Opera‡äes
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
{inbo/boin010.i RowObject}
{inbo/boin010.i tt-filho-componente}


/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE c-it-codigo    LIKE RowObject.it-codigo    NO-UNDO.
DEFINE VARIABLE i-cod-emitente LIKE RowObject.cod-emitente NO-UNDO.
DEFINE VARIABLE c-serie-docto  LIKE RowObject.serie-docto  NO-UNDO.
DEFINE VARIABLE c-nro-docto    LIKE RowObject.nro-docto    NO-UNDO.
DEFINE VARIABLE c-nat-operacao LIKE RowObject.nat-operacao NO-UNDO.
DEFINE VARIABLE c-cod-refer    LIKE RowObject.cod-refer    NO-UNDO.
DEFINE VARIABLE i-sequencia    LIKE RowObject.sequencia    NO-UNDO.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaFilhosOfComponente DBOProgram 
PROCEDURE buscaFilhosOfComponente :
DEFINE INPUT PARAMETER p-c-it-codigo          LIKE rat-componente.it-codigo    NO-UNDO.
    DEFINE INPUT PARAMETER p-i-cod-emitente       LIKE rat-componente.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER p-c-serie-docto        LIKE rat-componente.serie-docto  NO-UNDO.
    DEFINE INPUT PARAMETER p-c-nro-docto          LIKE rat-componente.nro-docto    NO-UNDO.
    DEFINE INPUT PARAMETER p-c-nat-operacao       LIKE rat-componente.nat-operacao NO-UNDO.
    DEFINE INPUT PARAMETER p-c-cod-refer          LIKE rat-componente.cod-refer    NO-UNDO.
    DEFINE INPUT PARAMETER p-i-sequencia          LIKE rat-componente.sequencia    NO-UNDO.
    DEFINE INPUT PARAMETER p-c-cod-estabel        LIKE param-of.cod-estabel        NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-filho-componente.
    
    DEF VAR lDevSimbConsig      AS LOGICAL                    NO-UNDO.

    empty temp-table tt-filho-componente.
    
    find first natur-oper where natur-oper.nat-operacao = p-c-nat-operacao no-lock no-error.
    
    IF CAN-FIND(FIRST param-of NO-LOCK
                WHERE param-of.cod-estabel = p-c-cod-estabel
                  AND param-of.log-devol-consig)
      AND natur-oper.terceiros 
      AND natur-oper.tp-oper-terc = 5 
      AND natur-oper.idi-tip-devol-consig = 1 THEN
        assign lDevSimbConsig = YES.
    ELSE
        assign lDevSimbConsig = NO.
    
    IF  natur-oper.tp-oper-terc = 6 
     OR natur-oper.tp-oper-terc = 4
     OR (CAN-FIND(FIRST param-of NO-LOCK
                  WHERE param-of.cod-estabel = p-c-cod-estabel
                    AND param-of.log-devol-consig)
     AND lDevSimbConsig) THEN DO:

        for each rat-componente
           where rat-componente.serie-docto  = p-c-serie-docto
            AND  rat-componente.nro-docto    = p-c-nro-docto
            AND  rat-componente.cod-emitente = p-i-cod-emitente
            AND  rat-componente.nat-operacao = p-c-nat-operacao
            AND  rat-componente.it-codigo    = p-c-it-codigo
            AND  rat-componente.cod-refer    = p-c-cod-refer
            AND  rat-componente.sequencia    = p-i-sequencia no-lock:
            create tt-filho-componente.
            assign tt-filho-componente.sequencia   = rat-componente.sequencia
                   tt-filho-componente.it-codigo   = rat-componente.it-codigo
                   tt-filho-componente.cod-depos   = rat-componente.cod-depos
                   tt-filho-componente.cod-localiz = rat-componente.cod-localiz
                   tt-filho-componente.cod-refer   = rat-componente.cod-refer
                   tt-filho-componente.lote        = rat-componente.lote
                   tt-filho-componente.quantidade  = rat-componente.quantidade .
        end.
    END.
    ELSE IF natur-oper.tipo = 1 /* entrada */ THEN DO:
        for each rat-lote
           where rat-lote.serie-docto  = p-c-serie-docto
            AND  rat-lote.nro-docto    = p-c-nro-docto
            AND  rat-lote.cod-emitente = p-i-cod-emitente
            AND  rat-lote.nat-operacao = p-c-nat-operacao
            AND  rat-lote.sequencia    = p-i-sequencia
            AND  rat-lote.it-codigo    = p-c-it-codigo
            AND  rat-lote.cod-refer    = p-c-cod-refer no-lock:
            create tt-filho-componente.
            assign tt-filho-componente.sequencia   = rat-lote.sequencia
                   tt-filho-componente.it-codigo   = rat-lote.it-codigo
                   tt-filho-componente.cod-depos   = rat-lote.cod-depos
                   tt-filho-componente.cod-localiz = rat-lote.cod-localiz
                   tt-filho-componente.cod-refer   = rat-lote.cod-refer
                   tt-filho-componente.lote        = rat-lote.lote
                   tt-filho-componente.quantidade  = rat-lote.quantidade .
        end.
    END.
    ELSE IF natur-oper.tipo = 2 /* sa¡da */ THEN DO:
        FOR EACH fat-ser-lote
           WHERE fat-ser-lote.cod-estabel = p-c-cod-estabel
            AND  fat-ser-lote.serie       = p-c-serie-docto
            AND  fat-ser-lote.nr-nota-fis = p-c-nro-docto
            AND  fat-ser-lote.nr-seq-fat  = p-i-sequencia
            AND  fat-ser-lote.it-codigo   = p-c-it-codigo
            AND  fat-ser-lote.cod-refer   = p-c-cod-refer no-lock:
            create tt-filho-componente.
            assign tt-filho-componente.sequencia   = fat-ser-lote.nr-seq-fat
                   tt-filho-componente.it-codigo   = fat-ser-lote.it-codigo
                   tt-filho-componente.cod-depos   = fat-ser-lote.cod-depos
                   tt-filho-componente.cod-localiz = fat-ser-lote.cod-localiz
                   tt-filho-componente.cod-refer   = fat-ser-lote.cod-refer
                   tt-filho-componente.lote        = fat-ser-lote.nr-serlote
                   tt-filho-componente.quantidade  = fat-ser-lote.qt-baixada[1].
        end.
    END.

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

    /*--- Verifica se temptable RowObject está disponível, caso não esteja será
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-depos":U THEN ASSIGN pFieldValue = RowObject.cod-depos.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-localiz":U THEN ASSIGN pFieldValue = RowObject.cod-localiz.
        WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
        WHEN "des-checksum":U THEN ASSIGN pFieldValue = RowObject.des-checksum.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "lote":U THEN ASSIGN pFieldValue = RowObject.lote.
        WHEN "nat-comp":U THEN ASSIGN pFieldValue = RowObject.nat-comp.
        WHEN "nat-operacao":U THEN ASSIGN pFieldValue = RowObject.nat-operacao.
        WHEN "nro-comp":U THEN ASSIGN pFieldValue = RowObject.nro-comp.
        WHEN "nro-docto":U THEN ASSIGN pFieldValue = RowObject.nro-docto.
        WHEN "serie-comp":U THEN ASSIGN pFieldValue = RowObject.serie-comp.
        WHEN "serie-docto":U THEN ASSIGN pFieldValue = RowObject.serie-docto.
        WHEN "un":U THEN ASSIGN pFieldValue = RowObject.un.
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

    /*--- Verifica se temptable RowObject está disponível, caso não esteja será
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dat-livre-1":U THEN ASSIGN pFieldValue = RowObject.dat-livre-1.
        WHEN "dat-livre-2":U THEN ASSIGN pFieldValue = RowObject.dat-livre-2.
        WHEN "dt-retorno":U THEN ASSIGN pFieldValue = RowObject.dt-retorno.
        WHEN "dt-vali-lote":U THEN ASSIGN pFieldValue = RowObject.dt-vali-lote.
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

    /*--- Verifica se temptable RowObject está disponível, caso não esteja será
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "quantidade":U THEN ASSIGN pFieldValue = RowObject.quantidade.
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

    /*--- Verifica se temptable RowObject está disponível, caso não esteja será
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "componente":U THEN ASSIGN pFieldValue = RowObject.componente.
        WHEN "emite-comp":U THEN ASSIGN pFieldValue = RowObject.emite-comp.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "seq-comp":U THEN ASSIGN pFieldValue = RowObject.seq-comp.
        WHEN "sequencia":U THEN ASSIGN pFieldValue = RowObject.sequencia.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice rtcmpnnv-id
  Parameters:  
               retorna valor do campo serie-docto
               retorna valor do campo nro-docto
               retorna valor do campo cod-emitente
               retorna valor do campo nat-operacao
               retorna valor do campo it-codigo
               retorna valor do campo cod-refer
               retorna valor do campo sequencia
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pserie-docto LIKE rat-componente.serie-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pnro-docto LIKE rat-componente.nro-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE rat-componente.cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pnat-operacao LIKE rat-componente.nat-operacao NO-UNDO.
    DEFINE OUTPUT PARAMETER pit-codigo LIKE rat-componente.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-refer LIKE rat-componente.cod-refer NO-UNDO.
    DEFINE OUTPUT PARAMETER psequencia LIKE rat-componente.sequencia NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pserie-docto = RowObject.serie-docto
           pnro-docto = RowObject.nro-docto
           pcod-emitente = RowObject.cod-emitente
           pnat-operacao = RowObject.nat-operacao
           pit-codigo = RowObject.it-codigo
           pcod-refer = RowObject.cod-refer
           psequencia = RowObject.sequencia.

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
        WHEN "baixa-ce":U THEN ASSIGN pFieldValue = RowObject.baixa-ce.        
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
  Purpose:     Reposiciona registro com base no ¡ndice rtcmpnnv-id
  Parameters:  
               recebe valor do campo serie-docto
               recebe valor do campo nro-docto
               recebe valor do campo cod-emitente
               recebe valor do campo nat-operacao
               recebe valor do campo it-codigo
               recebe valor do campo cod-refer
               recebe valor do campo sequencia
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pserie-docto LIKE rat-componente.serie-docto NO-UNDO.
    DEFINE INPUT PARAMETER pnro-docto LIKE rat-componente.nro-docto NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente LIKE rat-componente.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pnat-operacao LIKE rat-componente.nat-operacao NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo LIKE rat-componente.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-refer LIKE rat-componente.cod-refer NO-UNDO.
    DEFINE INPUT PARAMETER psequencia LIKE rat-componente.sequencia NO-UNDO.

    FIND FIRST bfrat-componente WHERE 
        bfrat-componente.serie-docto = pserie-docto AND 
        bfrat-componente.nro-docto = pnro-docto AND 
        bfrat-componente.cod-emitente = pcod-emitente AND 
        bfrat-componente.nat-operacao = pnat-operacao AND 
        bfrat-componente.it-codigo = pit-codigo AND 
        bfrat-componente.cod-refer = pcod-refer AND 
        bfrat-componente.sequencia = psequencia NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfrat-componente THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfrat-componente)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToComponente DBOProgram 
PROCEDURE linkToComponente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param pHandle as handle no-undo.

run getKey in pHandle (output c-serie-docto,
                       output c-nro-docto,
                       output i-cod-emitente,
                       output c-nat-operacao,
                       output c-it-codigo,
                       output c-cod-refer,
                       output i-sequencia).
                       
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
    open query qr{&tableName} for each {&tableName} 
         no-lock
        indexed-reposition.
     
    return "OK":U  .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOfComponente DBOProgram 
PROCEDURE openQueryOfComponente :
/*------------------------------------------------------------------------------
  Purpose:     Abre query para retornar todas ocorrencias da rat-componente com
               item, emitente, s‚rie, documento e natureza de opera‡Æo 
               proveniente da componente.
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName}
        FOR EACH  {&TableName} NO-LOCK
            WHERE {&TableName}.serie-docto  = c-serie-docto
            AND   {&TableName}.nro-docto    = c-nro-docto
            AND   {&TableName}.cod-emitente = i-cod-emitente
            AND   {&TableName}.nat-operacao = c-nat-operacao
            AND   {&TableName}.it-codigo    = c-it-codigo
            AND   {&TableName}.cod-refer    = c-cod-refer
            AND   {&TableName}.sequencia    = i-sequencia
        INDEXED-REPOSITION.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintMain DBOProgram 
PROCEDURE setConstraintMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintOfComponente DBOProgram 
PROCEDURE setConstraintOfComponente :
/*------------------------------------------------------------------------------
  Purpose:     Seta restri‡Æo para pesquisa dos lotes/referˆncia por Componente.
  Parameters:  p-c-it-codigo -> C¢digo do item;
               p-i-cod-emitente -> C¢digo do emitente;
               p-c-serie-docto -> S‚rie do documento;
               p-c-nro-docto -> N£mero do documento;
               p-c-nat-operacao -> Natureza de opera‡Æo do documento;
               p-c-cod-refer -> C¢digo de referencia;
               p-i-sequencia -> Sequˆncia;
  Notes:       
------------------------------------------------------------------------------*/
    
   DEFINE INPUT PARAMETER p-c-it-codigo    LIKE rat-componente.it-codigo    NO-UNDO.
   DEFINE INPUT PARAMETER p-i-cod-emitente LIKE rat-componente.cod-emitente NO-UNDO.
   DEFINE INPUT PARAMETER p-c-serie-docto  LIKE rat-componente.serie-docto  NO-UNDO.
   DEFINE INPUT PARAMETER p-c-nro-docto    LIKE rat-componente.nro-docto    NO-UNDO.
   DEFINE INPUT PARAMETER p-c-nat-operacao LIKE rat-componente.nat-operacao NO-UNDO.
   DEFINE INPUT PARAMETER p-c-cod-refer    LIKE rat-componente.cod-refer    NO-UNDO.
   DEFINE INPUT PARAMETER p-i-sequencia    LIKE rat-componente.sequencia    NO-UNDO.

   ASSIGN c-it-codigo    = p-c-it-codigo
          i-cod-emitente = p-i-cod-emitente
          c-serie-docto  = p-c-serie-docto
          c-nro-docto    = p-c-nro-docto
          c-nat-operacao = p-c-nat-operacao
          c-cod-refer    = p-c-cod-refer
          i-sequencia    = p-i-sequencia.
          
   RETURN "OK":U.

END PROCEDURE.

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
    
    /*:T--- Utilize o parƒmetro pType para identificar quais as valida‡äes a serem
          executadas ---*/
    /*:T--- Os valores poss¡veis para o parƒmetro sÆo: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as valida‡äes ---*/
    
    /*:T--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

