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
{include/i-prgvrs.i BOIN811 2.00.00.002 } /*** "010002" 13/11/2023 11:45:51 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i boin811 MUT}
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
&GLOBAL-DEFINE DBOName BOIN811
&GLOBAL-DEFINE DBOVersion 2.04.000.001
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName config-var-operac-regra-ret
&GLOBAL-DEFINE TableLabel config-var-operac-regra-ret
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
{inbo/boin811.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE variable i-cod-empresa LIKE config-operac.cdn-empresa NO-UNDO.
DEFINE variable c-cod-estabel LIKE config-operac.cod-estab NO-UNDO.
DEFINE variable c-cod-tipo-oper LIKE config-operac.cod-tip-operac NO-UNDO.
DEFINE VARIABLE i-cod-regra LIKE config-var-operac-regra.cdn-regra-operac NO-UNDO.
DEFINE VARIABLE c-desc-tudo AS CHARACTER   NO-UNDO.

DEFINE TEMP-TABLE tt-oper-retorno NO-UNDO LIKE config-var-operac-regra-ret
    FIELD r-rowid AS ROWID.

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
         HEIGHT             = 7.54
         WIDTH              = 49.29.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addUpdRetorno DBOProgram 
PROCEDURE addUpdRetorno :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER TABLE FOR tt-oper-retorno.
    DEFINE INPUT PARAMETER pcAction AS CHAR NO-UNDO.
    
    FIND FIRST tt-oper-retorno NO-LOCK NO-ERROR.
    IF AVAIL tt-oper-retorno THEN DO:

        /*Inicio Validaá‰es*/

        RUN pi-validacao IN THIS-PROCEDURE (INPUT TABLE tt-oper-retorno,
                                            INPUT pcAction).

        IF RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.

        IF pcAction = "ADD" THEN DO:
            
            CREATE config-var-operac-regra-ret.
            BUFFER-COPY tt-oper-retorno TO config-var-operac-regra-ret.

        END.
        
        IF pcAction = "UPDATE" THEN DO:

            FIND FIRST config-var-operac-regra-ret WHERE ROWID(config-var-operac-regra-ret) = tt-oper-retorno.r-rowid EXCLUSIVE-LOCK NO-ERROR.
            IF AVAIL config-var-operac-regra-ret THEN DO:

                ASSIGN config-var-operac-regra-ret.cod-campo-ret = tt-oper-retorno.cod-campo-ret
                       config-var-operac-regra-ret.cod-val-ret = tt-oper-retorno.cod-val-ret
                       config-var-operac-regra-ret.cdd-perc-rat   = tt-oper-retorno.cdd-perc-rat
                       config-var-operac-regra-ret.num-livre-1 = tt-oper-retorno.num-livre-1.

            END.
            
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
        WHEN "cod-campo-ret":U THEN ASSIGN pFieldValue = RowObject.cod-campo-ret.
        WHEN "cod-estab":U THEN ASSIGN pFieldValue = RowObject.cod-estab.
        WHEN "cod-tip-operac":U THEN ASSIGN pFieldValue = RowObject.cod-tip-operac.
        WHEN "cod-val-ret":U THEN ASSIGN pFieldValue = RowObject.cod-val-ret.
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
        &IF "{&mguni_version}" < "2.071" &THEN
            WHEN "cdn-empresa":U THEN ASSIGN pFieldValue = RowObject.cdn-empresa.
        &ENDIF
        WHEN "cdn-regra-operac":U THEN ASSIGN pFieldValue = RowObject.cdn-regra-operac.
        WHEN "cdn-seq-ret":U THEN ASSIGN pFieldValue = RowObject.cdn-seq-ret.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice ch-retorno
  Parameters:  
               retorna valor do campo ep-codigo
               retorna valor do campo cod-estabel
               retorna valor do campo cod-tipo-oper
               retorna valor do campo cod-regra-oper
               retorna valor do campo seq-retorno
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pep-codigo LIKE config-var-operac-regra-ret.cdn-empresa NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE config-var-operac-regra-ret.cod-estab NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-tipo-oper LIKE config-var-operac-regra-ret.cod-tip-operac NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-regra-oper LIKE config-var-operac-regra-ret.cdn-regra-operac NO-UNDO.
    DEFINE OUTPUT PARAMETER pseq-retorno LIKE config-var-operac-regra-ret.cdn-seq-ret NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pep-codigo = RowObject.cdn-empresa
           pcod-estabel = RowObject.cod-estab
           pcod-tipo-oper = RowObject.cod-tip-operac
           pcod-regra-oper = RowObject.cdn-regra-operac
           pseq-retorno = RowObject.cdn-seq-ret.

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

    DEFINE INPUT PARAMETER pep-codigo LIKE bfconfig-var-operac-regra-ret.cdn-empresa NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE bfconfig-var-operac-regra-ret.cod-estab NO-UNDO.
    DEFINE INPUT PARAMETER pcod-tipo-oper LIKE bfconfig-var-operac-regra-ret.cod-tip-operac NO-UNDO.
    DEFINE INPUT PARAMETER pseq-regra LIKE bfconfig-var-operac-regra-ret.cdn-regra-operac NO-UNDO.
    DEFINE OUTPUT PARAMETER p-seq AS INT NO-UNDO.

    FIND LAST bfconfig-var-operac-regra-ret WHERE 
        bfconfig-var-operac-regra-ret.cdn-empresa = pep-codigo AND 
        bfconfig-var-operac-regra-ret.cod-estab = pcod-estabel AND 
        bfconfig-var-operac-regra-ret.cod-tip-operac = pcod-tipo-oper AND
        bfconfig-var-operac-regra-ret.cdn-regra-operac = pseq-regra NO-LOCK NO-ERROR.
    IF AVAIL bfconfig-var-operac-regra-ret THEN
        ASSIGN p-seq = bfconfig-var-operac-regra-ret.cdn-seq-ret + 1.
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
  Purpose:     Reposiciona registro com base no °ndice ch-retorno
  Parameters:  
               recebe valor do campo ep-codigo
               recebe valor do campo cod-estabel
               recebe valor do campo cod-tipo-oper
               recebe valor do campo cod-regra-oper
               recebe valor do campo seq-retorno
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo LIKE config-var-operac-regra-ret.cdn-empresa NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE config-var-operac-regra-ret.cod-estab NO-UNDO.
    DEFINE INPUT PARAMETER pcod-tipo-oper LIKE config-var-operac-regra-ret.cod-tip-operac NO-UNDO.
    DEFINE INPUT PARAMETER pcod-regra-oper LIKE config-var-operac-regra-ret.cdn-regra-operac NO-UNDO.
    DEFINE INPUT PARAMETER pseq-retorno LIKE config-var-operac-regra-ret.cdn-seq-ret NO-UNDO.

    FIND FIRST bfconfig-var-operac-regra-ret WHERE 
        bfconfig-var-operac-regra-ret.cdn-empresa = pep-codigo AND 
        bfconfig-var-operac-regra-ret.cod-estab = pcod-estabel AND 
        bfconfig-var-operac-regra-ret.cod-tip-operac = pcod-tipo-oper AND 
        bfconfig-var-operac-regra-ret.cdn-regra-operac = pcod-regra-oper AND 
        bfconfig-var-operac-regra-ret.cdn-seq-ret = pseq-retorno NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfconfig-var-operac-regra-ret THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfconfig-var-operac-regra-ret)).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryRegra DBOProgram 
PROCEDURE openQueryRegra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH {&TableName} 
         WHERE {&TableName}.cdn-empresa = i-cod-empresa 
           AND {&TableName}.cod-estab = c-cod-estabel 
           AND {&TableName}.cod-tip-operac = c-cod-tipo-oper
           AND {&TableName}.cdn-regra-operac = i-cod-regra NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validacao DBOProgram 
PROCEDURE pi-validacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER TABLE FOR tt-oper-retorno.
    DEFINE INPUT PARAMETER pcAction AS CHAR NO-UNDO.

    DEFINE VARIABLE de-soma AS DEC NO-UNDO.
    
    FIND FIRST tt-oper-retorno NO-LOCK NO-ERROR.
    IF AVAIL tt-oper-retorno THEN DO:

        /*Inicio Validaá‰es*/

        IF pcAction = "ADD" THEN DO:
            FIND FIRST bfconfig-var-operac-regra-ret WHERE 
                       bfconfig-var-operac-regra-ret.cdn-empresa = tt-oper-retorno.cdn-empresa AND 
                       bfconfig-var-operac-regra-ret.cod-estab = tt-oper-retorno.cod-estab AND 
                       bfconfig-var-operac-regra-ret.cod-tip-operac = tt-oper-retorno.cod-tip-operac AND 
                       bfconfig-var-operac-regra-ret.cdn-regra-operac = tt-oper-retorno.cdn-regra-operac AND 
                       bfconfig-var-operac-regra-ret.cdn-seq-ret = tt-oper-retorno.cdn-seq-ret NO-LOCK NO-ERROR.
            IF  AVAIL bfconfig-var-operac-regra-ret THEN DO:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-retorno AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Retorno" *}
                ASSIGN c-lbl-liter-retorno = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i &ErrorNumber="1"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"
                                &ErrorParameters="c-lbl-liter-retorno"}
            END.
        END.

        IF pcAction = "ADD" THEN
            ASSIGN de-soma = tt-oper-retorno.cdd-perc-rat.
        ELSE
            ASSIGN de-soma = 0.

        FOR EACH bfconfig-var-operac-regra-ret NO-LOCK
           WHERE bfconfig-var-operac-regra-ret.cdn-empresa = tt-oper-retorno.cdn-empresa 
             AND bfconfig-var-operac-regra-ret.cod-estab = tt-oper-retorno.cod-estab 
             AND bfconfig-var-operac-regra-ret.cod-tip-operac = tt-oper-retorno.cod-tip-operac 
             AND bfconfig-var-operac-regra-ret.cdn-regra-operac = tt-oper-retorno.cdn-regra-operac:

            IF pcAction = "UPDATE" THEN DO:

                IF tt-oper-retorno.r-rowid = rowid(bfconfig-var-operac-regra-ret) THEN
                    ASSIGN de-soma = de-soma + tt-oper-retorno.cdd-perc-rat.
                ELSE
                    ASSIGN de-soma = de-soma + bfconfig-var-operac-regra-ret.cdd-perc-rat.

            END.
            ELSE
                ASSIGN de-soma = de-soma + bfconfig-var-operac-regra-ret.cdd-perc-rat.
            
        END.

        IF pcAction = "ADD" THEN DO:
        
            FIND FIRST bfconfig-var-operac-regra-ret NO-LOCK 
                 WHERE bfconfig-var-operac-regra-ret.cdn-empresa = tt-oper-retorno.cdn-empresa 
                   AND bfconfig-var-operac-regra-ret.cod-estab = tt-oper-retorno.cod-estab 
                   AND bfconfig-var-operac-regra-ret.cod-tip-operac = tt-oper-retorno.cod-tip-operac 
                   AND bfconfig-var-operac-regra-ret.cdn-regra-operac = tt-oper-retorno.cdn-regra-operac 
                   AND bfconfig-var-operac-regra-ret.num-livre-1 = 2 NO-ERROR.
            IF AVAIL bfconfig-var-operac-regra-ret THEN DO:
                
                IF tt-oper-retorno.num-livre-1 = 2 THEN DO:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-inclusao-nao-permitida AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Inclus∆o_n∆o_permitida" *}
                    ASSIGN c-lbl-liter-inclusao-nao-permitida = TRIM(RETURN-VALUE).
                    DEFINE VARIABLE c-lbl-liter-nao-e-possivel-incluir-mais-de AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "N∆o_Ç_poss°vel_incluir_mais_de_um_retorno_do_tipo_Programa" *}
                    ASSIGN c-lbl-liter-nao-e-possivel-incluir-mais-de = TRIM(RETURN-VALUE).
                    ASSIGN c-desc-tudo = c-lbl-liter-inclusao-nao-permitida + '!' + '~~' + c-lbl-liter-nao-e-possivel-incluir-mais-de + '.'.
                    {method/svc/errors/inserr.i &ErrorNumber="17006"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="c-desc-tudo"}
                    END. 
                ELSE DO:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-inclusao-nao-permitida-2 AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Inclus∆o_n∆o_permitida" *}
                    ASSIGN c-lbl-liter-inclusao-nao-permitida-2 = TRIM(RETURN-VALUE).
                    DEFINE VARIABLE c-lbl-liter-nao-e-possivel-incluir-um-reto AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "N∆o_Ç_poss°vel_incluir_um_retorno_do_tipo_Valor_quando_j†_existir_um_retorno_do_tipo_Programa" *}
                    ASSIGN c-lbl-liter-nao-e-possivel-incluir-um-reto = TRIM(RETURN-VALUE).
                    ASSIGN c-desc-tudo = c-lbl-liter-inclusao-nao-permitida-2 + '!' + '~~' + c-lbl-liter-nao-e-possivel-incluir-um-reto + '.'.
                    {method/svc/errors/inserr.i &ErrorNumber="17006"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="c-desc-tudo"}
                    END. 
                
            END.
            
            IF  tt-oper-retorno.num-livre-1 = 2 THEN DO:
                FIND FIRST bfconfig-var-operac-regra-ret NO-LOCK 
                     WHERE bfconfig-var-operac-regra-ret.cdn-empresa = tt-oper-retorno.cdn-empresa 
                       AND bfconfig-var-operac-regra-ret.cod-estab = tt-oper-retorno.cod-estab 
                       AND bfconfig-var-operac-regra-ret.cod-tip-operac = tt-oper-retorno.cod-tip-operac 
                       AND bfconfig-var-operac-regra-ret.cdn-regra-operac = tt-oper-retorno.cdn-regra-operac 
                       AND bfconfig-var-operac-regra-ret.num-livre-1 = 1 NO-ERROR.
                IF  AVAIL bfconfig-var-operac-regra-ret THEN DO:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-inclusao-nao-permitida-3 AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Inclus∆o_n∆o_permitida" *}
                    ASSIGN c-lbl-liter-inclusao-nao-permitida-3 = TRIM(RETURN-VALUE).
                    DEFINE VARIABLE c-lbl-liter-nao-e-possivel-incluir-um-reto-2 AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "N∆o_Ç_poss°vel_incluir_um_retorno_do_tipo_Programa_quando_j†_existir_um_retorno_do_tipo_Valor" *}
                    ASSIGN c-lbl-liter-nao-e-possivel-incluir-um-reto-2 = TRIM(RETURN-VALUE).
                    ASSIGN c-desc-tudo = c-lbl-liter-inclusao-nao-permitida-3 + '!' + '~~' + c-lbl-liter-nao-e-possivel-incluir-um-reto-2 + '.'.
                    {method/svc/errors/inserr.i &ErrorNumber="17006"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="c-desc-tudo"} 
                END. 
            END.
        END.

        IF tt-oper-retorno.num-livre-1 = 2 THEN DO:
            
            IF SEARCH(tt-oper-retorno.cod-val-ret) = ? THEN DO:

                {method/svc/errors/inserr.i &ErrorNumber="7712"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="tt-oper-retorno.cod-val-ret"}

            END.

        END.
        
        IF de-soma > 100 THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-percentual-de-rateio-invalido AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Percentual_de_Rateio_Inv†lido" *}
            ASSIGN c-lbl-liter-percentual-de-rateio-invalido = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-o-somatorio-do-percentual-de-r AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "O_somat¢rio_do_percentual_de_rateio_n∆o_pode_ultrapassar_100%" *}
            ASSIGN c-lbl-liter-o-somatorio-do-percentual-de-r = TRIM(RETURN-VALUE).
            ASSIGN c-desc-tudo = c-lbl-liter-percentual-de-rateio-invalido + '~~' + c-lbl-liter-o-somatorio-do-percentual-de-r + '.'.
            {method/svc/errors/inserr.i &ErrorNumber="17006"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="c-desc-tudo"} 
        END.
        
        /*:T--- Verifica ocorrància de erros ---*/
        IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
            RETURN "NOK":U.

    END.

    RETURN "OK":U.

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

    DEFINE INPUT PARAMETER p-regra LIKE config-var-operac-regra.cdn-regra-operac NO-UNDO.

    ASSIGN i-cod-regra = p-regra.

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
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
