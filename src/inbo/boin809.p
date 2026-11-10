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
{include/i-prgvrs.i BOIN809 2.00.00.017 } /*** "010017" 13/11/2023 11:45:50 ***/
{include/i-license-manager.i boin809 MUT}

/*:T--------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) Ç um programa PROGRESS 
                 que contÇm a l¢gica de neg¢cio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters : 

    Notes      : 
 -------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN809
&GLOBAL-DEFINE DBOVersion 2.04.00.001
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName config-var-operac-regra
&GLOBAL-DEFINE TableLabel config-var-operac-regra
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
{inbo/boin809.i RowObject}
{cdp/cdapi034a.i}
{inbo/boin810.i tt-config-var-operac-regra-cond}
{inbo/boin811.i tt-config-var-operac-regra-ret}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName}                  FOR {&TableName}.
DEFINE BUFFER bf-config-var-operac-regra      FOR config-var-operac-regra.
DEFINE BUFFER bf-config-var-operac            FOR config-var-operac.
DEFINE BUFFER bf-config-var-operac-regra-cond FOR config-var-operac-regra-cond.
DEFINE BUFFER bf-cond-variavel                FOR config-var-operac-regra-cond.
DEFINE BUFFER bf-config-var-operac-regra-ret  FOR config-var-operac-regra-ret.

DEFINE variable i-cod-empresa   LIKE config-operac.cdn-empresa NO-UNDO.
DEFINE variable c-cod-estabel   LIKE config-operac.cod-estab NO-UNDO.
DEFINE variable c-cod-tipo-oper LIKE config-operac.cod-tip-operac NO-UNDO.
DEFINE variable i-cod-regra-ini LIKE config-var-operac-regra.cdn-regra-operac NO-UNDO.
DEFINE variable i-cod-regra-fim LIKE config-var-operac-regra.cdn-regra-operac NO-UNDO.
DEFINE variable c-desc-ini      LIKE config-var-operac-regra.des-regra-operac NO-UNDO.
DEFINE variable c-desc-fim      LIKE config-var-operac-regra.des-regra-operac NO-UNDO.


DEFINE VARIABLE r-regra AS ROWID NO-UNDO.

def temp-table tt-lista-regra no-undo
    field cod-regra as int
    field des-regra as char    index seq-regra as primary unique
          cod-regra.

DEFINE TEMP-TABLE ttbf-config-var-operac-regra NO-UNDO LIKE {&TableName}
    FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-regra-origem NO-UNDO LIKE {&TableName}
    FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-regra-destino NO-UNDO LIKE {&TableName}
    FIELD r-rowid AS ROWID.

define temp-table tt-bkp NO-UNDO
    field r-tabela  as rowid
    field seq-ant   as integer.

define temp-table tt-conta-variaveis NO-UNDO
    field ep-codigo         like config-var-operac-regra-cond.cdn-empresa
    field cod-estabel       like config-var-operac-regra-cond.cod-estab
    field cod-tipo-oper     like config-var-operac-regra-cond.cod-tip-operac
    field cod-regra-oper    like config-var-operac-regra-cond.cdn-regra-operac
    field valor-retorno     like config-var-operac-regra-ret.cod-val-ret
    field seq-antiga        like config-var-operac-regra-cond.cdn-regra-operac
    field cod-tip-operac    like config-var-operac-regra-ret.cod-tip-operac
    field lista-variaveis   as character
    field contador          as integer  
    field rowid-regra       as rowid.

DEFINE TEMP-TABLE tt-config-var-operac-regra-seq NO-UNDO LIKE {&TableName}
    FIELD cod-regra-novo LIKE config-var-operac-regra.cdn-regra-operac.

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
         HEIGHT             = 5.71
         WIDTH              = 43.14.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraListaRegra DBOProgram 
PROCEDURE geraListaRegra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-rowid AS ROWID NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR tt-lista-regra.

    FIND FIRST config-operac WHERE ROWID(config-operac) = p-rowid NO-LOCK NO-ERROR.

    IF AVAIL config-operac THEN DO:

        EMPTY TEMP-TABLE tt-lista-regra.

        FOR EACH bfconfig-var-operac-regra NO-LOCK
           WHERE bfconfig-var-operac-regra.cdn-empresa = config-operac.cdn-empresa
             AND bfconfig-var-operac-regra.cod-estab   = config-operac.cod-estab
             AND bfconfig-var-operac-regra.cod-tip-operac = config-operac.cod-tip-operac:

            /* Correá∆o no carregamento do combo-box de regras: quando o cliente tinha muitas regras cadastradas 
               e tenta popular o combo-box todo de uma vez s¢, d† erro de string maior que 32000 bytes */

             create tt-lista-regra.
             assign tt-lista-regra.cod-regra = bfconfig-var-operac-regra.cdn-regra-operac
                    tt-lista-regra.des-regra = bfconfig-var-operac-regra.des-regra-operac.

        END.

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
        &IF "{&mguni_version}" >= "2.071" &THEN
            WHEN "cdn-empresa":U THEN ASSIGN pFieldValue = RowObject.cdn-empresa.
        &ENDIF
        WHEN "cod-estab":U THEN ASSIGN pFieldValue = RowObject.cod-estab.
        WHEN "cod-tip-operac":U THEN ASSIGN pFieldValue = RowObject.cod-tip-operac.
        WHEN "des-regra-operac":U THEN ASSIGN pFieldValue = RowObject.des-regra-operac.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescRegra DBOProgram 
PROCEDURE getDescRegra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pRowid AS ROWID NO-UNDO.
    DEFINE INPUT PARAMETER pRegra AS INT NO-UNDO.
    DEFINE OUTPUT PARAMETER pDesc AS CHAR NO-UNDO.

    ASSIGN pDesc = "".

    FIND FIRST config-operac WHERE ROWID(config-operac) = pRowid NO-LOCK NO-ERROR.
    IF AVAIL config-operac THEN DO:

        FIND FIRST config-var-operac-regra no-lock
             WHERE config-var-operac-regra.cdn-empresa = config-operac.cdn-empresa
               AND config-var-operac-regra.cod-estab = config-operac.cod-estab
               AND config-var-operac-regra.cod-tip-operac = config-operac.cod-tip-operac 
               AND config-var-operac-regra.cdn-regra-operac = pRegra NO-ERROR.
        IF AVAIL config-var-operac-regra THEN
            ASSIGN pDesc = config-var-operac-regra.des-regra-operac.

    END.

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
        WHEN "cdn-regra-operac":U THEN ASSIGN pFieldValue = RowObject.cdn-regra-operac.
        &IF "{&mguni_version}" < "2.071" &THEN
            WHEN "cdn-empresa":U THEN ASSIGN pFieldValue = RowObject.cdn-empresa.
        &ENDIF
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice ch-regra
  Parameters:  
               retorna valor do campo ep-codigo
               retorna valor do campo cod-estabel
               retorna valor do campo cod-tipo-oper
               retorna valor do campo cod-regra-oper
               retorna valor do campo seq-regra
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pep-codigo LIKE config-var-operac-regra.cdn-empresa NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE config-var-operac-regra.cod-estab NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-tipo-oper LIKE config-var-operac-regra.cod-tip-operac NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-regra-oper LIKE config-var-operac-regra.cdn-regra-operac NO-UNDO.
    
    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pep-codigo = RowObject.cdn-empresa
           pcod-estabel = RowObject.cod-estab
           pcod-tipo-oper = RowObject.cod-tip-operac
           pcod-regra-oper = RowObject.cdn-regra-operac.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLastSeq DBOProgram 
PROCEDURE getLastSeq :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pep-codigo LIKE config-var-operac-regra.cdn-empresa NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE config-var-operac-regra.cod-estab NO-UNDO.
    DEFINE INPUT PARAMETER pcod-tipo-oper LIKE config-var-operac-regra.cod-tip-operac NO-UNDO.
    DEFINE OUTPUT PARAMETER p-seq AS INT NO-UNDO.
    
    FIND LAST bfconfig-var-operac-regra WHERE 
        bfconfig-var-operac-regra.cdn-empresa = pep-codigo AND 
        bfconfig-var-operac-regra.cod-estab = pcod-estabel AND 
        bfconfig-var-operac-regra.cod-tip-operac = pcod-tipo-oper NO-LOCK NO-ERROR.
    IF AVAIL bfconfig-var-operac-regra THEN
        ASSIGN p-seq = bfconfig-var-operac-regra.cdn-regra-operac + 1.
    ELSE
        ASSIGN p-seq = 1.
    
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
  Purpose:     Reposiciona registro com base no °ndice ch-regra
  Parameters:  
               recebe valor do campo ep-codigo
               recebe valor do campo cod-estabel
               recebe valor do campo cod-tipo-oper
               recebe valor do campo cod-regra-oper
               recebe valor do campo seq-regra
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo LIKE config-var-operac-regra.cdn-empresa NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE config-var-operac-regra.cod-estab NO-UNDO.
    DEFINE INPUT PARAMETER pcod-tipo-oper LIKE config-var-operac-regra.cod-tip-operac NO-UNDO.
    DEFINE INPUT PARAMETER pcod-regra-oper LIKE config-var-operac-regra.cdn-regra-operac NO-UNDO.
    
    FIND FIRST bfconfig-var-operac-regra WHERE 
        bfconfig-var-operac-regra.cdn-empresa = pep-codigo AND 
        bfconfig-var-operac-regra.cod-estab = pcod-estabel AND 
        bfconfig-var-operac-regra.cod-tip-operac = pcod-tipo-oper AND 
        bfconfig-var-operac-regra.cdn-regra-operac = pcod-regra-oper NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfconfig-var-operac-regra THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfconfig-var-operac-regra)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToconfig-operac DBOProgram 
PROCEDURE linkToconfig-operac :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input param pHandle as handle no-undo.

run getKey in pHandle (output i-cod-empresa, 
                       output c-cod-estabel, 
                       OUTPUT c-cod-tipo-oper).

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE copiarMoverRegra DBOProgram 
PROCEDURE copiarMoverRegra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT  PARAM p-row-origem  AS ROWID NO-UNDO.
DEFINE INPUT  PARAM TABLE FOR tt-regra-destino.
DEFINE INPUT  PARAM l-transacao   AS LOG   NO-UNDO.

DEF VAR l-achou-variavel       AS LOG    NO-UNDO.
DEF VAR l-altera-campo-retorno AS LOG    NO-UNDO.
DEF VAR i-cod-regra-oper LIKE config-var-operac-regra.cdn-regra-operac.
DEF VAR i-cdn-empresa    LIKE tt-regra-destino.cdn-empresa.
DEF VAR c-cod-estab      LIKE tt-regra-destino.cod-estab.     
DEF VAR c-cod-tip-operac LIKE tt-regra-destino.cod-tip-operac.

cria-regra:
DO TRANS ON ERROR UNDO,LEAVE :    

    FIND FIRST config-operac NO-LOCK 
         WHERE rowid(config-operac) = p-row-origem NO-ERROR.

    IF AVAIL config-operac THEN DO:

        FOR EACH tt-regra-destino:

            /*grava chave destino*/
            ASSIGN i-cdn-empresa    = tt-regra-destino.cdn-empresa   
                   c-cod-estab      = tt-regra-destino.cod-estab     
                   c-cod-tip-operac = tt-regra-destino.cod-tip-operac.

            /*verifica se a regra j† existe no destino */
            ASSIGN i-cod-regra-oper = 0.
            FIND FIRST config-var-operac-regra NO-LOCK
                 WHERE config-var-operac-regra.cdn-empresa      = tt-regra-destino.cdn-empresa   
                  AND  config-var-operac-regra.cod-estab        = tt-regra-destino.cod-estab     
                  AND  config-var-operac-regra.cod-tip-operac   = tt-regra-destino.cod-tip-operac
                  AND  config-var-operac-regra.cdn-regra-operac = tt-regra-destino.cdn-regra-operac NO-ERROR.
            IF AVAIL config-var-operac-regra THEN DO:

                /*se achou, busca o ultimo registro e incrementa para gerar um novo codigo de regra*/
                FIND LAST bf-config-var-operac-regra NO-LOCK
                    WHERE bf-config-var-operac-regra.cdn-empresa      = tt-regra-destino.cdn-empresa   
                     AND  bf-config-var-operac-regra.cod-estab        = tt-regra-destino.cod-estab     
                     AND  bf-config-var-operac-regra.cod-tip-operac   = tt-regra-destino.cod-tip-operac NO-ERROR.
                IF AVAIL bf-config-var-operac-regra THEN
                    ASSIGN i-cod-regra-oper = bf-config-var-operac-regra.cdn-regra-operac + 1.
                
            END.
            ELSE DO:
                /*caso n∆o exista assume o codigo da regra original*/
                ASSIGN i-cod-regra-oper = tt-regra-destino.cdn-regra-operac.
            END.

            
            /*busca regra origem*/
            FIND FIRST bf-config-var-operac-regra NO-LOCK
                 WHERE bf-config-var-operac-regra.cdn-empresa      = config-operac.cdn-empresa   
                  AND  bf-config-var-operac-regra.cod-estab        = config-operac.cod-estab     
                  AND  bf-config-var-operac-regra.cod-tip-operac   = config-operac.cod-tip-operac
                  AND  bf-config-var-operac-regra.cdn-regra-operac = tt-regra-destino.cdn-regra-operac NO-ERROR.
            IF AVAIL bf-config-var-operac-regra THEN DO:

                /*cria regra*/
                CREATE config-var-operac-regra.
                BUFFER-COPY bf-config-var-operac-regra TO config-var-operac-regra
                ASSIGN config-var-operac-regra.cdn-empresa      = tt-regra-destino.cdn-empresa  
                       config-var-operac-regra.cod-estab        = tt-regra-destino.cod-estab    
                       config-var-operac-regra.cod-tip-operac   = tt-regra-destino.cod-tip-operac
                       config-var-operac-regra.cdn-regra-operac = i-cod-regra-oper.
    
                /*busca e cria condicoes e agrupamentos conforme origem*/
                FOR EACH config-var-operac-regra-cond EXCLUSIVE-LOCK
                   WHERE config-var-operac-regra-cond.cdn-empresa      = config-operac.cdn-empresa    
                     AND config-var-operac-regra-cond.cod-estab        = config-operac.cod-estab      
                     AND config-var-operac-regra-cond.cod-tip-operac   = config-operac.cod-tip-operac
                     AND config-var-operac-regra-cond.cdn-regra-operac = tt-regra-destino.cdn-regra-operac:
    
                    CREATE bf-config-var-operac-regra-cond.
                    BUFFER-COPY config-var-operac-regra-cond TO bf-config-var-operac-regra-cond
                    ASSIGN bf-config-var-operac-regra-cond.cdn-empresa      = tt-regra-destino.cdn-empresa  
                           bf-config-var-operac-regra-cond.cod-estab        = tt-regra-destino.cod-estab    
                           bf-config-var-operac-regra-cond.cod-tip-operac   = tt-regra-destino.cod-tip-operac
                           bf-config-var-operac-regra-cond.cdn-regra-operac = i-cod-regra-oper.
                    /*se n∆o achar a variavel no destino cria variavel*/
                    if not can-find(first config-var-operac where
                                          config-var-operac.cdn-empresa    = tt-regra-destino.cdn-empresa and
                                          config-var-operac.cod-estab      = tt-regra-destino.cod-estab   and
                                          config-var-operac.cod-tip-operac = tt-regra-destino.cod-tip-operac and
                                          config-var-operac.cod-variavel   = config-var-operac-regra-cond.cod-variavel) then do:
    
                       
                        /*busca variavel de origem*/
                        FIND FIRST config-var-operac NO-LOCK
                             WHERE config-var-operac.cdn-empresa    = config-operac.cdn-empresa       
                               AND config-var-operac.cod-estab      = config-operac.cod-estab         
                               AND config-var-operac.cod-tip-operac = config-operac.cod-tip-operac    
                               AND config-var-operac.cod-variavel   = config-var-operac-regra-cond.cod-variavel NO-ERROR.  
                            IF AVAIL config-var-operac THEN DO:
                            
                                CREATE bf-config-var-operac.
                                BUFFER-COPY config-var-operac EXCEPT config-var-operac.cod-tip-operac TO bf-config-var-operac
                                ASSIGN bf-config-var-operac.cdn-empresa      = tt-regra-destino.cdn-empresa       
                                       bf-config-var-operac.cod-estab        = tt-regra-destino.cod-estab         
                                       bf-config-var-operac.cod-tip-operac   = tt-regra-destino.cod-tip-operac    
                                       bf-config-var-operac.cod-variavel     = config-var-operac.cod-variavel .
                            END.
                    END.
                    
                    /*deleta condicoes caso a opá∆o escolhida for mover*/
                    IF NOT l-transacao THEN
                         DELETE config-var-operac-regra-cond.
    
                END.
    
                /*cria retornos*/
                FOR EACH config-var-operac-regra-ret EXCLUSIVE-LOCK 
                   WHERE config-var-operac-regra-ret.cdn-empresa      = config-operac.cdn-empresa    
                     AND config-var-operac-regra-ret.cod-estab        = config-operac.cod-estab      
                     AND config-var-operac-regra-ret.cod-tip-operac   = config-operac.cod-tip-operac
                     AND config-var-operac-regra-ret.cdn-regra-operac = tt-regra-destino.cdn-regra-operac:
                    
                    CREATE bf-config-var-operac-regra-ret.
                    BUFFER-COPY config-var-operac-regra-ret TO bf-config-var-operac-regra-ret
                    ASSIGN bf-config-var-operac-regra-ret.cdn-empresa      = tt-regra-destino.cdn-empresa  
                           bf-config-var-operac-regra-ret.cod-estab        = tt-regra-destino.cod-estab    
                           bf-config-var-operac-regra-ret.cod-tip-operac   = tt-regra-destino.cod-tip-operac
                           bf-config-var-operac-regra-ret.cdn-regra-operac = i-cod-regra-oper.
						                          
                    /*deleta retorno caso a opá∆o escolhida for mover*/
                    IF NOT l-transacao THEN
                         DELETE config-var-operac-regra-ret.
    
                END.
    
                /*deleta regra origem caso a opá∆o escolhida for mover*/
                IF NOT l-transacao THEN DO:
                    FIND CURRENT bf-config-var-operac-regra EXCLUSIVE-LOCK.
                    IF AVAIL bf-config-var-operac-regra THEN
                        DELETE bf-config-var-operac-regra.
                END.
                    
    
            END.

        END.
        
    END.
    
END.

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

    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK INDEXED-REPOSITION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOperacao DBOProgram 
PROCEDURE openQueryOperacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   OPEN QUERY {&QueryName} FOR EACH {&TableName} 
        WHERE {&TableName}.cdn-empresa = i-cod-empresa 
          AND {&TableName}.cod-estab = c-cod-estabel 
          AND {&TableName}.cod-tip-operac = c-cod-tipo-oper NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryRowid DBOProgram 
PROCEDURE openQueryRowid :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH {&TableName} 
         WHERE ROWID({&TableName}) = r-regra NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintRowid DBOProgram 
PROCEDURE setConstraintRowid :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-rowid AS ROWID NO-UNDO.

    ASSIGN r-regra = p-rowid.

    RETURN "OK":U.

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryRegra DBOProgram 
PROCEDURE openQueryRegra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

        OPEN QUERY {&QueryName} FOR EACH {&TableName}
        WHERE {&TableName}.cdn-empresa    = i-cod-empresa
          AND {&TableName}.cod-estab      = c-cod-estabel
          AND {&TableName}.cod-tip-operac = c-cod-tipo-oper 
          AND {&TableName}.cdn-regra-operac  >= i-cod-regra-ini
          AND {&TableName}.cdn-regra-operac  <= i-cod-regra-fim 
          AND {&TableName}.des-regra-operac  >= c-desc-ini
          AND {&TableName}.des-regra-operac  <= c-desc-fim    NO-LOCK INDEXED-REPOSITION.

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintRegra DBOProgram 
PROCEDURE setConstraintRegra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAM p-cod-regra-ini LIKE {&TableName}.cdn-regra-operac NO-UNDO.
    DEFINE INPUT PARAM p-cod-regra-fim LIKE {&TableName}.cdn-regra-operac NO-UNDO.
    DEFINE INPUT PARAM p-desc-ini      LIKE {&TableName}.des-regra-operac NO-UNDO.
    DEFINE INPUT PARAM p-desc-fim      LIKE {&TableName}.des-regra-operac NO-UNDO.
    DEFINE INPUT PARAM p-cod-empresa   LIKE {&TableName}.cdn-empresa      NO-UNDO.
    DEFINE INPUT PARAM p-cod-estabel   LIKE {&TableName}.cod-estab        NO-UNDO.
    DEFINE INPUT PARAM p-cod-tipo-oper LIKE {&TableName}.cod-tip-operac   NO-UNDO.

    ASSIGN i-cod-empresa   = p-cod-empresa 
           c-cod-estabel   = p-cod-estabel
           c-cod-tipo-oper = p-cod-tipo-oper
           i-cod-regra-ini = p-cod-regra-ini
           i-cod-regra-fim = p-cod-regra-fim
           c-desc-ini      = p-desc-ini
           c-desc-fim      = p-desc-fim.

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
    
    IF pType = "Create" THEN DO:
        FIND FIRST bfconfig-var-operac-regra NO-LOCK 
             WHERE bfconfig-var-operac-regra.cdn-empresa = RowObject.cdn-empresa
               AND bfconfig-var-operac-regra.cod-estab = RowObject.cod-estab
               AND bfconfig-var-operac-regra.cod-tip-operac = RowObject.cod-tip-operac
               AND bfconfig-var-operac-regra.cdn-regra-operac =  RowObject.cdn-regra-operac NO-ERROR.
        IF AVAIL bfconfig-var-operac-regra THEN DO:
              /* Inicio -- Projeto Internacional */
              DEFINE VARIABLE c-lbl-liter-regra AS CHARACTER NO-UNDO.
              {utp/ut-liter.i "Regra" *}
              ASSIGN c-lbl-liter-regra = TRIM(RETURN-VALUE).
              {method/svc/errors/inserr.i &ErrorNumber="1"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="c-lbl-liter-regra"}
                    
        END.

    END.

    IF pType = "Create" OR pType = "Update" THEN DO:
        IF RowObject.des-regra-operac = "" THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-descricao AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Descriá∆o" *}
            ASSIGN c-lbl-liter-descricao = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="17677"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="c-lbl-liter-descricao"}
        END.
    END.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-duplicidade DBOProgram 
PROCEDURE pi-verifica-duplicidade :
/*:T------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  verificar se j† existe regra com a mesma descriá∆o
  Notes:       

------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-cdn-empresa     LIKE config-var-operac-regra.cdn-empresa      NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-estabel     LIKE config-var-operac-regra.cod-estab        NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-tip-operac  LIKE config-var-operac-regra.cod-tip-operac   NO-UNDO.
    DEFINE INPUT PARAMETER pc-des-regra       LIKE config-var-operac-regra.des-regra-operac NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    FOR EACH config-var-operac-regra 
       WHERE config-var-operac-regra.cdn-empresa      = pc-cdn-empresa    
         AND config-var-operac-regra.cod-estab        = pc-cod-estabel    
         AND config-var-operac-regra.cod-tip-operac   = pc-cod-tip-operac NO-LOCK:

        IF config-var-operac-regra.des-regra-operac MATCHES('*' + pc-des-regra + '*')  THEN DO:
            {utp/ut-liter.i Regra_com_esta_Descriá∆o * r}
            {method/svc/errors/inserr.i &ErrorNumber="1"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters=TRIM(RETURN-VALUE)}
            LEAVE.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sequenciarRegras DBOProgram 
PROCEDURE sequenciarRegras :
/*:T------------------------------------------------------------------------------
  Purpose:     Sequenciar as regras deixando como primeiras as regras com mais condicoes
  Parameters:  Empresa, Estabelecimento e Operacao
  Notes:       Retorna OK se n„o houve problema na execucao.

------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-cdn-empresa     LIKE config-var-operac-regra.cdn-empresa      NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-estabel     LIKE config-var-operac-regra.cod-estab        NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-tip-operac  LIKE config-var-operac-regra.cod-tip-operac   NO-UNDO.
    DEFINE INPUT PARAMETER h-acompanhamento   AS HANDLE                                     NO-UNDO. /* Nao eh obrigatorio */
    
    DEFINE VARIABLE inc-seq                   AS INT  INITIAL 10   NO-UNDO.
    DEFINE VARIABLE c-ajust-regra             AS CHARACTER         NO-UNDO.
    DEFINE VARIABLE c-lbl-liter-seq           AS CHARACTER         NO-UNDO.
    DEFINE VARIABLE c-lbl-liter-num-variaveis AS CHARACTER         NO-UNDO.
    DEFINE VARIABLE i-seq-aux                 AS INT               NO-UNDO.
    DEFINE VARIABLE i-cont                    AS INT               NO-UNDO.

    empty temp-table tt-bkp.
    empty temp-table tt-conta-variaveis.

    DO ON ERROR UNDO, RETURN "NOK":U
       ON STOP  UNDO, RETURN "NOK":U
       ON QUIT  UNDO, RETURN "NOK":U:

        find last config-var-operac-regra no-lock
            where config-var-operac-regra.cdn-empresa    = pc-cdn-empresa   
              and config-var-operac-regra.cod-estab      = pc-cod-estabel   
              and config-var-operac-regra.cod-tip-operac = pc-cod-tip-operac no-error.

        /* Busca a ultima sequencia e incrementa. */
        if avail config-var-operac-regra then
            assign i-seq-aux = config-var-operac-regra.cdn-regra-operac + inc-seq.
        else do:
            /*Nao existem regras cadastradas*/
            RETURN "NOK":U.
        end.

        IF h-acompanhamento <> ? THEN DO:
            {utp/ut-liter.i "Ajustando_Seq_Regra" *}
            ASSIGN c-ajust-regra = return-value.
            {utp/ut-liter.i "Seq" *}
            ASSIGN c-lbl-liter-seq = TRIM(RETURN-VALUE).
            {utp/ut-liter.i "Num._Variaveis" *}
            ASSIGN c-lbl-liter-num-variaveis = TRIM(RETURN-VALUE).
        END.

        /* Para cada regra, cria uma tt que controla o resequenciamento. */
        for each config-var-operac-regra no-lock
           where config-var-operac-regra.cdn-empresa    = pc-cdn-empresa   
             and config-var-operac-regra.cod-estab      = pc-cod-estabel   
             and config-var-operac-regra.cod-tip-operac = pc-cod-tip-operac:
        
            create tt-bkp.
            assign tt-bkp.r-tabela = rowid(config-var-operac-regra)
                   tt-bkp.seq-ant  = config-var-operac-regra.cdn-regra-operac.
        end.

        /* Neste for each o programa ira atribuir a regra, condicoes e retorno sequencias acima da ultima sequencia informada, 
        ** para que depois possa atribuir novamente a sequencia de 10 em 10 para as regras que foram reordenadas.               */
        for each tt-bkp:
            
            /* Depois de repassar todos os registros para a tt, reposiciona as regras a partir dela. */
            find first config-var-operac-regra exclusive-lock 
                where rowid(config-var-operac-regra) = tt-bkp.r-tabela no-error.
            if avail config-var-operac-regra then do:
                
                if h-acompanhamento <> ? THEN
                    run pi-acompanhar in h-acompanhamento (input c-ajust-regra + ": " + string(config-var-operac-regra.cdn-regra-operac)).

                /* OBS: a sequencia da regra Ç utilizada para posicionar as **
                ** outras tabelas, portanto deve ser alterada por ultimo.   */

                /* Posiciona as condicoes da regra. */
                for each config-var-operac-regra-cond use-index cnfgvrpb-id exclusive-lock
                    where config-var-operac-regra-cond.cdn-empresa      = config-var-operac-regra.cdn-empresa
                    and   config-var-operac-regra-cond.cod-estab        = config-var-operac-regra.cod-estab
                    and   config-var-operac-regra-cond.cod-tip-operac   = config-var-operac-regra.cod-tip-operac
                    and   config-var-operac-regra-cond.cdn-regra-operac = config-var-operac-regra.cdn-regra-operac:
                    
                    /* Cria temp-table que conta as variaveis existentes naquela regra. */
                    find first tt-conta-variaveis
                        where tt-conta-variaveis.ep-codigo      = config-var-operac-regra-cond.cdn-empresa
                        and   tt-conta-variaveis.cod-estabel    = config-var-operac-regra-cond.cod-estab
                        and   tt-conta-variaveis.cod-tipo-oper  = config-var-operac-regra-cond.cod-tip-operac 
                        and   tt-conta-variaveis.cod-regra-oper = i-seq-aux no-error.

                    if not avail tt-conta-variaveis then do:
                        create tt-conta-variaveis.
                        assign tt-conta-variaveis.ep-codigo         = config-var-operac-regra-cond.cdn-empresa          
                               tt-conta-variaveis.cod-estabel       = config-var-operac-regra-cond.cod-estab          
                               tt-conta-variaveis.cod-tipo-oper     = config-var-operac-regra-cond.cod-tip-operac   
                               tt-conta-variaveis.cod-regra-oper    = i-seq-aux /* Sequencia nova. */
                               tt-conta-variaveis.contador          = 1
                               tt-conta-variaveis.lista-variaveis   = config-var-operac-regra-cond.cod-variavel + ";"
                               tt-conta-variaveis.seq-antiga        = tt-bkp.seq-ant.
                    end.
                    else do:
                        /* Apenas conta as vari†veis diferentes. */
                        if lookup (config-var-operac-regra-cond.cod-variavel, tt-conta-variaveis.lista-variaveis, ";") = 0 then
                            assign  tt-conta-variaveis.lista-variaveis  = tt-conta-variaveis.lista-variaveis + config-var-operac-regra-cond.cod-variavel + ";"
                                    tt-conta-variaveis.contador         = tt-conta-variaveis.contador + 1.
                    end.       
                    /* Atualiza sequencia das condicoes - a sequencia tem que ser a mesma para todas as condicoes da regra. */
                    assign config-var-operac-regra-cond.cdn-regra-operac = i-seq-aux.
                end.
                    
                /* Atualiza os valores dos retornos. */
                for each config-var-operac-regra-ret exclusive-lock
                    where config-var-operac-regra-ret.cdn-empresa      = config-var-operac-regra.cdn-empresa   
                    and   config-var-operac-regra-ret.cod-estab        = config-var-operac-regra.cod-estab     
                    and   config-var-operac-regra-ret.cod-tip-operac   = config-var-operac-regra.cod-tip-operac
                    and   config-var-operac-regra-ret.cdn-regra-operac = config-var-operac-regra.cdn-regra-operac:
            
                    assign config-var-operac-regra-ret.cdn-regra-operac = i-seq-aux.
                end.
            
                /* Altera sequencia da regra. */
                assign config-var-operac-regra.cdn-regra-operac = i-seq-aux
                       i-seq-aux                                = i-seq-aux + inc-seq.
            end.
        end.
        
        /* Reordena as regras. */
        assign i-cont = 1.
        for each tt-conta-variaveis 
            break by tt-conta-variaveis.contador descending:
        
            IF h-acompanhamento <> ? THEN 
                run pi-acompanhar in h-acompanhamento (input c-lbl-liter-seq + ": " + string(tt-conta-variaveis.seq-antiga) + " " + c-lbl-liter-num-variaveis + ": " + string(tt-conta-variaveis.contador)).

            /* Atualiza sequencia das regras. */
            find config-var-operac-regra exclusive-lock
                where config-var-operac-regra.cdn-empresa      = tt-conta-variaveis.ep-codigo    
                and   config-var-operac-regra.cod-estab        = tt-conta-variaveis.cod-estabel  
                and   config-var-operac-regra.cod-tip-operac   = tt-conta-variaveis.cod-tipo-oper
                and   config-var-operac-regra.cdn-regra-operac = tt-conta-variaveis.cod-regra-oper no-error.
            if avail config-var-operac-regra then do:

                assign config-var-operac-regra.cdn-regra-operac = i-cont * inc-seq
                       i-cont                                   = i-cont + 1.
               
                /* Atualiza sequencia das condicoes com a nova sequencia da regra. */
                for each config-var-operac-regra-cond use-index cnfgvrpb-id exclusive-lock 
                    where config-var-operac-regra-cond.cdn-empresa      = config-var-operac-regra.cdn-empresa
                    and   config-var-operac-regra-cond.cod-estab        = config-var-operac-regra.cod-estab
                    and   config-var-operac-regra-cond.cod-tip-operac   = config-var-operac-regra.cod-tip-operac
                    and   config-var-operac-regra-cond.cdn-regra-operac = tt-conta-variaveis.cod-regra-oper:
            
                    assign config-var-operac-regra-cond.cdn-regra-operac = config-var-operac-regra.cdn-regra-operac.
                end.
                
                /* Atualiza sequencia dos retornos com a nova sequencia da regra. */
                for each config-var-operac-regra-ret exclusive-lock
                    where config-var-operac-regra-ret.cdn-empresa      = config-var-operac-regra.cdn-empresa   
                    and   config-var-operac-regra-ret.cod-estab        = config-var-operac-regra.cod-estab     
                    and   config-var-operac-regra-ret.cod-tip-operac   = config-var-operac-regra.cod-tip-operac
                    and   config-var-operac-regra-ret.cdn-regra-operac = tt-conta-variaveis.cod-regra-oper:
            
                    assign config-var-operac-regra-ret.cdn-regra-operac = config-var-operac-regra.cdn-regra-operac.
                end.
            end.
        end.        
    end.
        
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDeleteRecord DBOProgram 
PROCEDURE afterDeleteRecord:
/*:T------------------------------------------------------------------------------
  Purpose:     Rotinas que ser∆o executadas ap¢s exclus∆o do registro principal
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    RUN deletaCondicoesERetornos.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deletaCondicoesERetornos DBOProgram 
PROCEDURE deletaCondicoesERetornos:
/*:T------------------------------------------------------------------------------
  Purpose:     Apaga as condiá‰es e retornos referentes a regra
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    IF NOT AVAIL RowObject THEN 
        RETURN "NOK":U.

    /* Apaga condiá‰es da regra */
    for each config-var-operac-regra-cond exclusive-lock 
       where config-var-operac-regra-cond.cdn-empresa      = RowObject.cdn-empresa
         and config-var-operac-regra-cond.cod-estab        = RowObject.cod-estab
         and config-var-operac-regra-cond.cod-tip-operac   = RowObject.cod-tip-operac
         and config-var-operac-regra-cond.cdn-regra-operac = RowObject.cdn-regra-operac:

        DELETE config-var-operac-regra-cond.
    end.
    
    /* Apaga retornos da regra */
    for each config-var-operac-regra-ret exclusive-lock
       where config-var-operac-regra-ret.cdn-empresa      = RowObject.cdn-empresa
         and config-var-operac-regra-ret.cod-estab        = RowObject.cod-estab
         and config-var-operac-regra-ret.cod-tip-operac   = RowObject.cod-tip-operac
         and config-var-operac-regra-ret.cdn-regra-operac = RowObject.cdn-regra-operac:

        DELETE config-var-operac-regra-ret.
    end.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeCreateRecord DBOProgram 
PROCEDURE beforeCreateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Setar dados antes de criar a regra
  Parameters:  
  Notes:       

------------------------------------------------------------------------------*/
    DEF VAR i-cod-regra AS INT NO-UNDO.

    IF NOT AVAIL RowObject THEN 
        RETURN "NOK":U.

    IF RowObject.cdn-regra-operac = 0 THEN DO:
        RUN getLastSeq (INPUT RowObject.cdn-empresa,
                        INPUT RowObject.cod-estab,
                        INPUT RowObject.cod-tip-operac,
                        OUTPUT i-cod-regra).
        ASSIGN RowObject.cdn-regra-operac = i-cod-regra.
    END.   

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sequenciarRegrasManual DBOProgram 
PROCEDURE sequenciarRegrasManual :
/*:T------------------------------------------------------------------------------
  Purpose:     Sequenciar as regras manualmente conforme TT enviada
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER TABLE FOR tt-config-var-operac-regra-seq.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DO ON ERROR UNDO, RETURN "NOK":U
       ON STOP  UNDO, RETURN "NOK":U
       ON QUIT  UNDO, RETURN "NOK":U:

        FOR EACH tt-config-var-operac-regra-seq:
            FOR FIRST config-var-operac-regra exclusive-lock
                WHERE config-var-operac-regra.cdn-empresa      = tt-config-var-operac-regra-seq.cdn-empresa
                  AND config-var-operac-regra.cod-estab        = tt-config-var-operac-regra-seq.cod-estab
                  AND config-var-operac-regra.cod-tip-operac   = tt-config-var-operac-regra-seq.cod-tip-operac
                  AND config-var-operac-regra.cdn-regra-operac = tt-config-var-operac-regra-seq.cdn-regra-operac:

                BUFFER-COPY config-var-operac-regra TO tt-config-var-operac-regra-seq.

                /* Apaga condiá‰es da regra e cria a TT para gravar com a sequància nova */
                for each config-var-operac-regra-cond exclusive-lock
                   where config-var-operac-regra-cond.cdn-empresa      = tt-config-var-operac-regra-seq.cdn-empresa
                     and config-var-operac-regra-cond.cod-estab        = tt-config-var-operac-regra-seq.cod-estab
                     and config-var-operac-regra-cond.cod-tip-operac   = tt-config-var-operac-regra-seq.cod-tip-operac
                     and config-var-operac-regra-cond.cdn-regra-operac = tt-config-var-operac-regra-seq.cdn-regra-operac:

                    CREATE tt-config-var-operac-regra-cond.
                    BUFFER-COPY config-var-operac-regra-cond except cdn-regra-operac TO tt-config-var-operac-regra-cond.
                    ASSIGN tt-config-var-operac-regra-cond.cdn-regra-operac = tt-config-var-operac-regra-seq.cod-regra-novo.

                    DELETE config-var-operac-regra-cond.
                end.
                
                /* Apaga retornos da regra e cria a TT para gravar com a sequància nova */
                for each config-var-operac-regra-ret exclusive-lock
                   where config-var-operac-regra-ret.cdn-empresa      = tt-config-var-operac-regra-seq.cdn-empresa
                     and config-var-operac-regra-ret.cod-estab        = tt-config-var-operac-regra-seq.cod-estab
                     and config-var-operac-regra-ret.cod-tip-operac   = tt-config-var-operac-regra-seq.cod-tip-operac
                     and config-var-operac-regra-ret.cdn-regra-operac = tt-config-var-operac-regra-seq.cdn-regra-operac:

                    CREATE tt-config-var-operac-regra-ret.
                    BUFFER-COPY config-var-operac-regra-ret except cdn-regra-operac TO tt-config-var-operac-regra-ret.
                    ASSIGN tt-config-var-operac-regra-ret.cdn-regra-operac = tt-config-var-operac-regra-seq.cod-regra-novo.

                    DELETE config-var-operac-regra-ret.
                end.

                DELETE config-var-operac-regra.
            END.
        END.
        
        FOR EACH tt-config-var-operac-regra-seq:
            CREATE config-var-operac-regra.
            BUFFER-COPY tt-config-var-operac-regra-seq except cdn-regra-operac TO config-var-operac-regra.
            ASSIGN config-var-operac-regra.cdn-regra-operac = tt-config-var-operac-regra-seq.cod-regra-novo.

            for each tt-config-var-operac-regra-cond
               where tt-config-var-operac-regra-cond.cdn-empresa      = tt-config-var-operac-regra-seq.cdn-empresa
                 and tt-config-var-operac-regra-cond.cod-estab        = tt-config-var-operac-regra-seq.cod-estab
                 and tt-config-var-operac-regra-cond.cod-tip-operac   = tt-config-var-operac-regra-seq.cod-tip-operac
                 and tt-config-var-operac-regra-cond.cdn-regra-operac = tt-config-var-operac-regra-seq.cod-regra-novo:

                CREATE config-var-operac-regra-cond.
                BUFFER-COPY tt-config-var-operac-regra-cond TO config-var-operac-regra-cond.
            end.

            for each tt-config-var-operac-regra-ret
               where tt-config-var-operac-regra-ret.cdn-empresa      = tt-config-var-operac-regra-seq.cdn-empresa
                 and tt-config-var-operac-regra-ret.cod-estab        = tt-config-var-operac-regra-seq.cod-estab
                 and tt-config-var-operac-regra-ret.cod-tip-operac   = tt-config-var-operac-regra-seq.cod-tip-operac
                 and tt-config-var-operac-regra-ret.cdn-regra-operac = tt-config-var-operac-regra-seq.cod-regra-novo:

                CREATE config-var-operac-regra-ret.
                BUFFER-COPY tt-config-var-operac-regra-ret TO config-var-operac-regra-ret.
            end.
        END.
    END.

    RELEASE config-var-operac-regra.
    RELEASE config-var-operac-regra-cond.
    RELEASE config-var-operac-regra-ret.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

