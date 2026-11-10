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
{include/i-prgvrs.i BOIN810 2.00.00.007 } /*** "010007" 13/11/2023 11:45:50 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i boin810 MUT}
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
&GLOBAL-DEFINE DBOName BOIN810
&GLOBAL-DEFINE DBOVersion 2.04.00.001
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName config-var-operac-regra-cond
&GLOBAL-DEFINE TableLabel config-var-operac-regra-cond
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
{inbo/boin810.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
 
DEFINE TEMP-TABLE tt-oper-regra-condicao NO-UNDO LIKE config-var-operac-regra-cond
    FIELD r-rowid AS ROWID.

DEFINE variable i-cod-empresa LIKE config-operac.cdn-empresa NO-UNDO.
DEFINE variable c-cod-estabel LIKE config-operac.cod-estab NO-UNDO.
DEFINE variable c-cod-tipo-oper LIKE config-operac.cod-tip-operac NO-UNDO.
DEFINE VARIABLE i-cod-regra LIKE config-var-operac-regra.cdn-regra-operac NO-UNDO.

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
         HEIGHT             = 8.79
         WIDTH              = 55.57.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AddUpdCondicao DBOProgram 
PROCEDURE AddUpdCondicao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER TABLE FOR tt-oper-regra-condicao.
    DEFINE INPUT PARAMETER pcAction AS CHAR NO-UNDO.

    DEFINE VARIABLE l-erro AS LOGICAL NO-UNDO.
    
    FIND FIRST tt-oper-regra-condicao NO-LOCK NO-ERROR.
    IF AVAIL tt-oper-regra-condicao THEN DO:

        RUN pi-validacao IN THIS-PROCEDURE (INPUT TABLE tt-oper-regra-condicao,
                                            INPUT pcAction).

        IF RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.

        IF pcAction = "ADD" THEN DO:

            CREATE config-var-operac-regra-cond.
            BUFFER-COPY tt-oper-regra-condicao TO config-var-operac-regra-cond.
            
        END.
        
        IF pcAction = "UPDATE" THEN DO:
            
            FIND FIRST config-var-operac-regra-cond WHERE ROWID(config-var-operac-regra-cond) = tt-oper-regra-condicao.r-rowid EXCLUSIVE-LOCK NO-ERROR.
            IF AVAIL config-var-operac-regra-cond THEN DO:

                ASSIGN config-var-operac-regra-cond.cod-variavel      = tt-oper-regra-condicao.cod-variavel
                       config-var-operac-regra-cond.cdn-cond-regra     = tt-oper-regra-condicao.cdn-cond-regra
                       config-var-operac-regra-cond.cod-val-var     = tt-oper-regra-condicao.cod-val-var
                       config-var-operac-regra-cond.cdn-operador-regra = tt-oper-regra-condicao.cdn-operador-regra.

            END.
            
        END.

        RELEASE config-var-operac-regra-cond.

        ASSIGN l-erro = NO.

        FOR EACH bfconfig-var-operac-regra-cond NO-LOCK
           WHERE bfconfig-var-operac-regra-cond.cdn-empresa      = tt-oper-regra-condicao.cdn-empresa 
             AND bfconfig-var-operac-regra-cond.cod-estab        = tt-oper-regra-condicao.cod-estab
             AND bfconfig-var-operac-regra-cond.cod-tip-operac   = tt-oper-regra-condicao.cod-tip-operac
             AND bfconfig-var-operac-regra-cond.cdn-regra-operac = tt-oper-regra-condicao.cdn-regra-operac
           BREAK BY bfconfig-var-operac-regra-cond.cdn-empresa
                 BY bfconfig-var-operac-regra-cond.cod-estab
                 BY bfconfig-var-operac-regra-cond.cod-tip-operac
                 BY bfconfig-var-operac-regra-cond.cdn-regra-operac
                 BY bfconfig-var-operac-regra-cond.cdn-seq-regra:

            IF LAST-OF(bfconfig-var-operac-regra-cond.cdn-empresa) THEN DO:
                IF bfconfig-var-operac-regra-cond.cdn-operador-regra <> 0 THEN
                    ASSIGN l-erro = YES.
            END.
            ELSE DO:

                IF bfconfig-var-operac-regra-cond.cdn-operador-regra = 0 THEN
                    ASSIGN l-erro = YES.
            END.
            
        END.

        IF l-erro THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-erro-de-sintaxe AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Erro_de_Sintaxe" *}
            ASSIGN c-lbl-liter-erro-de-sintaxe = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-as-condicoes-cadastradas-irao AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "As_condiá‰es_cadastradas_ir∆o_gerar_erro_de_sintaxe,_favor_verificar_os_operadores" *}
            ASSIGN c-lbl-liter-as-condicoes-cadastradas-irao = TRIM(RETURN-VALUE).
            run utp/ut-msgs.p (input "show", 
                               input 17006, 
                               input c-lbl-liter-erro-de-sintaxe + "!" + "~~" + c-lbl-liter-as-condicoes-cadastradas-irao + ".").

        END.
        
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE agrupaRegra DBOProgram 
PROCEDURE agrupaRegra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-rowid AS ROWID NO-UNDO.
    DEFINE INPUT PARAMETER p-seq-regra-fim AS INT NO-UNDO.
   
    DEFINE VARIABLE i-seq-regra-ini AS INT NO-UNDO.
    DEFINE VARIABLE i-regra-oper AS INT NO-UNDO.
    
    FIND FIRST bfconfig-var-operac-regra-cond EXCLUSIVE-LOCK
         WHERE rowid(bfconfig-var-operac-regra-cond) = p-rowid NO-ERROR.
    IF AVAIL bfconfig-var-operac-regra-cond THEN
        ASSIGN i-seq-regra-ini = bfconfig-var-operac-regra-cond.cdn-seq-regra
               i-regra-oper    = bfconfig-var-operac-regra-cond.cdn-regra-operac.

    FOR EACH bfconfig-var-operac-regra-cond EXCLUSIVE-LOCK
       WHERE bfconfig-var-operac-regra-cond.cdn-empresa = i-cod-empresa
         AND bfconfig-var-operac-regra-cond.cod-estab = c-cod-estabel
         AND bfconfig-var-operac-regra-cond.cod-tip-operac = c-cod-tipo-oper
         AND bfconfig-var-operac-regra-cond.cdn-regra-operac = i-regra-oper
         AND bfconfig-var-operac-regra-cond.cdn-seq-regra >= i-seq-regra-ini
         AND bfconfig-var-operac-regra-cond.cdn-seq-regra <= p-seq-regra-fim:

        ASSIGN bfconfig-var-operac-regra-cond.num-livre-1 = i-seq-regra-ini
               bfconfig-var-operac-regra-cond.num-livre-2 = p-seq-regra-fim.
        
    END.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE desagrupaRegra DBOProgram 
PROCEDURE desagrupaRegra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-rowid AS ROWID NO-UNDO.
    
    DEFINE VARIABLE i-seq-regra-ini AS INT NO-UNDO.
    DEFINE VARIABLE i-seq-regra-fim AS INT NO-UNDO.
    DEFINE VARIABLE i-regra-oper AS INT NO-UNDO.
    
    FIND FIRST bfconfig-var-operac-regra-cond EXCLUSIVE-LOCK
         WHERE rowid(bfconfig-var-operac-regra-cond) = p-rowid NO-ERROR.
    IF AVAIL bfconfig-var-operac-regra-cond THEN
        ASSIGN i-seq-regra-ini = bfconfig-var-operac-regra-cond.num-livre-1
               i-seq-regra-fim = bfconfig-var-operac-regra-cond.num-livre-2
               i-regra-oper    = bfconfig-var-operac-regra-cond.cdn-regra-operac.

    FOR EACH bfconfig-var-operac-regra-cond EXCLUSIVE-LOCK
       WHERE bfconfig-var-operac-regra-cond.cdn-empresa = i-cod-empresa
         AND bfconfig-var-operac-regra-cond.cod-estab = c-cod-estabel
         AND bfconfig-var-operac-regra-cond.cod-tip-operac = c-cod-tipo-oper
         AND bfconfig-var-operac-regra-cond.cdn-regra-operac = i-regra-oper
         AND bfconfig-var-operac-regra-cond.cdn-seq-regra >= i-seq-regra-ini
         AND bfconfig-var-operac-regra-cond.cdn-seq-regra <= i-seq-regra-fim:

        ASSIGN bfconfig-var-operac-regra-cond.num-livre-1 = 0
               bfconfig-var-operac-regra-cond.num-livre-2 = 0.
        
    END.
    
    RETURN "NOK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraListaCondicao DBOProgram 
PROCEDURE geraListaCondicao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pep-codigo LIKE config-var-operac-regra-cond.cdn-empresa NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE config-var-operac-regra-cond.cod-estab NO-UNDO.
    DEFINE INPUT PARAMETER pcod-tipo-oper LIKE config-var-operac-regra-cond.cod-tip-operac NO-UNDO.
    DEFINE INPUT PARAMETER pcod-regra-oper LIKE config-var-operac-regra-cond.cdn-regra-operac NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-oper-regra-condicao.

    FOR EACH tt-oper-regra-condicao:
        DELETE tt-oper-regra-condicao.
    END.

    FOR EACH config-var-operac-regra-cond NO-LOCK
       WHERE config-var-operac-regra-cond.cdn-empresa = pep-codigo
         AND config-var-operac-regra-cond.cod-estab = pcod-estabel
         AND config-var-operac-regra-cond.cod-tip-operac = pcod-tipo-oper 
         AND config-var-operac-regra-cond.cdn-regra-operac = pcod-regra-oper:

        CREATE tt-oper-regra-condicao.
        BUFFER-COPY config-var-operac-regra-cond TO tt-oper-regra-condicao.

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
        WHEN "cod-variavel":U THEN ASSIGN pFieldValue = RowObject.cod-variavel.
        WHEN "cod-val-var":U THEN ASSIGN pFieldValue = RowObject.cod-val-var.
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
        WHEN "cdn-regra-operac":U THEN ASSIGN pFieldValue = RowObject.cdn-regra-operac.
        WHEN "cdn-cond-regra":U THEN ASSIGN pFieldValue = RowObject.cdn-cond-regra.
        WHEN "cdn-operador-regra":U THEN ASSIGN pFieldValue = RowObject.cdn-operador-regra.
        &IF "{&mguni_version}" < "2.071" &THEN
            WHEN "cdn-empresa":U THEN ASSIGN pFieldValue = RowObject.cdn-empresa.
        &ENDIF
        WHEN "cdn-seq-regra":U THEN ASSIGN pFieldValue = RowObject.cdn-seq-regra.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice ch-regra-cond
  Parameters:  
               retorna valor do campo ep-codigo
               retorna valor do campo cod-estabel
               retorna valor do campo cod-tipo-oper
               retorna valor do campo cod-regra-oper
               retorna valor do campo seq-regra
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pep-codigo LIKE config-var-operac-regra-cond.cdn-empresa NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE config-var-operac-regra-cond.cod-estab NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-tipo-oper LIKE config-var-operac-regra-cond.cod-tip-operac NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-regra-oper LIKE config-var-operac-regra-cond.cdn-regra-operac NO-UNDO.
    DEFINE OUTPUT PARAMETER pseq-regra LIKE config-var-operac-regra-cond.cdn-seq-regra NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pep-codigo = RowObject.cdn-empresa
           pcod-estabel = RowObject.cod-estab
           pcod-tipo-oper = RowObject.cod-tip-operac
           pcod-regra-oper = RowObject.cdn-regra-operac
           pseq-regra = RowObject.cdn-seq-regra.

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

    DEFINE INPUT PARAMETER pep-codigo LIKE config-var-operac-regra-cond.cdn-empresa NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE config-var-operac-regra-cond.cod-estab NO-UNDO.
    DEFINE INPUT PARAMETER pcod-tipo-oper LIKE config-var-operac-regra-cond.cod-tip-operac NO-UNDO.
    DEFINE INPUT PARAMETER pseq-regra LIKE config-var-operac-regra-cond.cdn-seq-regra NO-UNDO.
    DEFINE OUTPUT PARAMETER p-seq AS INT NO-UNDO.

    FIND LAST bfconfig-var-operac-regra-cond WHERE 
        bfconfig-var-operac-regra-cond.cdn-empresa = pep-codigo AND 
        bfconfig-var-operac-regra-cond.cod-estab = pcod-estabel AND 
        bfconfig-var-operac-regra-cond.cod-tip-operac = pcod-tipo-oper AND
        bfconfig-var-operac-regra-cond.cdn-regra-operac = pseq-regra NO-LOCK NO-ERROR.
    IF AVAIL bfconfig-var-operac-regra-cond THEN
        ASSIGN p-seq = bfconfig-var-operac-regra-cond.cdn-seq-regra + 1.
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
  Purpose:     Reposiciona registro com base no °ndice ch-regra-cond
  Parameters:  
               recebe valor do campo ep-codigo
               recebe valor do campo cod-estabel
               recebe valor do campo cod-tipo-oper
               recebe valor do campo cod-regra-oper
               recebe valor do campo seq-regra
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo LIKE config-var-operac-regra-cond.cdn-empresa NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE config-var-operac-regra-cond.cod-estab NO-UNDO.
    DEFINE INPUT PARAMETER pcod-tipo-oper LIKE config-var-operac-regra-cond.cod-tip-operac NO-UNDO.
    DEFINE INPUT PARAMETER pcod-regra-oper LIKE config-var-operac-regra-cond.cdn-regra-operac NO-UNDO.
    DEFINE INPUT PARAMETER pseq-regra LIKE config-var-operac-regra-cond.cdn-seq-regra NO-UNDO.

    FIND FIRST bfconfig-var-operac-regra-cond WHERE 
        bfconfig-var-operac-regra-cond.cdn-empresa = pep-codigo AND 
        bfconfig-var-operac-regra-cond.cod-estab = pcod-estabel AND 
        bfconfig-var-operac-regra-cond.cod-tip-operac = pcod-tipo-oper AND 
        bfconfig-var-operac-regra-cond.cdn-regra-operac = pcod-regra-oper AND 
        bfconfig-var-operac-regra-cond.cdn-seq-regra = pseq-regra NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfconfig-var-operac-regra-cond THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfconfig-var-operac-regra-cond)).
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
    
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         WHERE {&TableName}.cdn-empresa = i-cod-empresa 
           AND {&TableName}.cod-estab = c-cod-estabel 
           AND {&TableName}.cod-tip-operac = c-cod-tipo-oper
           AND {&TableName}.cdn-regra-operac = i-cod-regra 
        BY {&TableName}.cdn-seq-regra.

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

    DEFINE INPUT PARAMETER TABLE FOR tt-oper-regra-condicao.
    DEFINE INPUT PARAMETER pcAction AS CHAR NO-UNDO.

    DEFINE VARIABLE l-erro AS LOGICAL NO-UNDO.
    
    FIND FIRST tt-oper-regra-condicao NO-LOCK NO-ERROR.
    IF AVAIL tt-oper-regra-condicao THEN DO:
        
    /*Inicio Validaá‰es*/

        IF pcAction = "ADD" THEN DO:

            ASSIGN i-cod-regra = tt-oper-regra-condicao.cdn-regra-operac.

            FIND FIRST bfconfig-var-operac-regra-cond WHERE
                       bfconfig-var-operac-regra-cond.cdn-empresa = tt-oper-regra-condicao.cdn-empresa AND 
                       bfconfig-var-operac-regra-cond.cod-estab = tt-oper-regra-condicao.cod-estab AND 
                       bfconfig-var-operac-regra-cond.cod-tip-operac = tt-oper-regra-condicao.cod-tip-operac AND 
                       bfconfig-var-operac-regra-cond.cdn-regra-operac = tt-oper-regra-condicao.cdn-regra-operac AND 
                       bfconfig-var-operac-regra-cond.cdn-seq-regra = tt-oper-regra-condicao.cdn-seq-regra NO-LOCK NO-ERROR.
            IF AVAIL bfconfig-var-operac-regra-cond THEN DO:
                
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-sequencia AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "SeqÅància" *}
                ASSIGN c-lbl-liter-sequencia = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-ja-cadastrada-para-outra-situa AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "j†_cadastrada_para_outra_situaá∆o" *}
                ASSIGN c-lbl-liter-ja-cadastrada-para-outra-situa = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-a-sequencia-informada-ja-exist AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "A_seqÅància_informada_j†_existe_para_outra_condiá∆o_cadastrada_nesta_regra" *}
                ASSIGN c-lbl-liter-a-sequencia-informada-ja-exist = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-merge-ja-cadastrada-para-outra-situa AS CHARACTER NO-UNDO.
                ASSIGN c-lbl-merge-ja-cadastrada-para-outra-situa = ' ' + c-lbl-liter-ja-cadastrada-para-outra-situa + '.' + "~~" + c-lbl-liter-a-sequencia-informada-ja-exist + '.'.
                {method/svc/errors/inserr.i &ErrorNumber="17006"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"
                                &ErrorParameters="c-lbl-liter-sequencia + ' ' + string(tt-oper-regra-condicao.cdn-seq-regra) + c-lbl-merge-ja-cadastrada-para-outra-situa"}.
            
            END.

        END.

        FIND FIRST config-var-operac NO-LOCK
             WHERE config-var-operac.cdn-empresa = tt-oper-regra-condicao.cdn-empresa
               AND config-var-operac.cod-estab = tt-oper-regra-condicao.cod-estab
               AND config-var-operac.cod-tip-operac = tt-oper-regra-condicao.cod-tip-operac
               AND config-var-operac.cod-variavel = tt-oper-regra-condicao.cod-variavel NO-ERROR.
        IF NOT AVAIL config-var-operac THEN DO:

            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-variavel AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Vari†vel" *}
            ASSIGN c-lbl-liter-variavel = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"
                            &ErrorParameters="c-lbl-liter-variavel"}

        END.

        IF tt-oper-regra-condicao.cdn-cond-regra = 0 THEN DO:
            
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-condicao AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Condiá∆o" *}
            ASSIGN c-lbl-liter-condicao = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="17677"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="c-lbl-liter-condicao"}

        END.
            
        
        /*:T--- Verifica ocorrància de erros ---*/
        IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
            RETURN "NOK":U.

        /*Fim Validaá‰es*/

    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaTipoVar DBOProgram 
PROCEDURE piValidaTipoVar :
/*------------------------------------------------------------------------------
  Purpose:     Verifica se Ç possivel converter o valor da condiá∆o selecionada 
               para o tipo de vari†vel da vari†vel que est† sendo utilizada por
               esta condiá∆o.
               
  Parameters:  p-iCdnEmpresa   - c¢digo empresa
               p-cCodEstab     - c¢digo estabelecimento
               p-cTipoOper     - tipo da operaá∆o
               p-cCodVariavel  - codigo vari†vel
               p-iTipoVariavel - tipo da variavel
               p-iCondicao     - condiá∆o da regra
               p-lretorno      - retorna se a convers∆o dos valores ocorreu com sucesso
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER p-iCdnEmpresa         AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER p-cCodEstab           AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER p-cTipoOper           AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER p-cCodVariavel        AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER p-iCondicao           AS INTEGER   NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER p-iTipoVariavel AS INTEGER     NO-UNDO.
DEFINE OUTPUT PARAMETER p-lretorno            AS LOGICAL INITIAL YES     NO-UNDO.

DEFINE VARIABLE c-char AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-int  AS INTEGER     NO-UNDO.
DEFINE VARIABLE d-dec  AS DECIMAL     NO-UNDO.
DEFINE VARIABLE l-log  AS LOGICAL     NO-UNDO.
DEFINE VARIABLE d-date AS DATE        NO-UNDO.
DEFINE VARIABLE c-auxLiter AS CHARACTER   NO-UNDO.

FOR EACH config-var-operac-regra-cond
     WHERE config-var-operac-regra-cond.cdn-empresa = p-iCdnEmpresa
       AND config-var-operac-regra-cond.cod-estab = p-cCodEstab
       AND config-var-operac-regra-cond.cod-tip-operac = p-cTipoOper
       AND config-var-operac-regra-cond.cod-variavel = p-cCodVariavel NO-LOCK:
    
    FIND FIRST config-var-operac
         WHERE config-var-operac.cdn-empresa    = config-var-operac-regra-cond.cdn-empresa
           AND config-var-operac.cod-estab      = config-var-operac-regra-cond.cod-estab
           AND config-var-operac.cod-tip-operac = config-var-operac-regra-cond.cod-tip-operac
           AND config-var-operac.cod-variavel   = config-var-operac-regra-cond.cod-variavel NO-LOCK NO-ERROR.

    IF AVAIL config-var-operac AND p-iTipoVariavel = 0 THEN
       &IF  "{&bf_mat_versao_ems}":U >= "2.09":U &THEN
        ASSIGN p-iTipoVariavel = config-var-operac.cdn-tip-var.
       &ELSE
        ASSIGN p-iTipoVariavel = config-var-operac.num-livre-1.
       &ENDIF
        
    IF p-iCondicao = 0 OR p-iCondicao = config-var-operac-regra-cond.cdn-cond-regra THEN DO:
        CASE p-iTipoVariavel:
            WHEN 1 THEN DO:
                ASSIGN c-char = STRING(config-var-operac-regra-cond.cod-val-var) NO-ERROR.
                IF c-char = "" THEN
                    ASSIGN p-lretorno = NO.
            END.
            WHEN 2 THEN DO:
                ASSIGN i-int = INT(config-var-operac-regra-cond.cod-val-var) NO-ERROR.
                IF i-int = 0 AND config-var-operac-regra-cond.cod-val-var <> "0" THEN
                    ASSIGN p-lretorno = NO.
            END.
            WHEN 3 THEN DO:
                ASSIGN d-dec = DEC(config-var-operac-regra-cond.cod-val-var) NO-ERROR.
                IF d-dec = 0 AND config-var-operac-regra-cond.cod-val-var <> "0,0000" THEN
                    ASSIGN p-lretorno = NO.
            END.  
            WHEN 4 THEN DO:
                ASSIGN l-log = LOGICAL(config-var-operac-regra-cond.cod-val-var) NO-ERROR.
                IF l-log = ? THEN
                    ASSIGN p-lretorno = NO.
            END.  
            WHEN 5 THEN DO:
                ASSIGN d-date = DATE(config-var-operac-regra-cond.cod-val-var) NO-ERROR.
                IF d-date = ? THEN
                    ASSIGN p-lretorno = NO.
            END.  
        END CASE.
    END.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaNumCondicao DBOProgram 
PROCEDURE validaNumCondicao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE VARIABLE i-cont-condicao AS INT NO-UNDO.

    FOR EACH {&TableName} NO-LOCK
       WHERE {&TableName}.cdn-empresa = i-cod-empresa 
         AND {&TableName}.cod-estab = c-cod-estabel 
         AND {&TableName}.cod-tip-operac = c-cod-tipo-oper
         AND {&TableName}.cdn-regra-operac = i-cod-regra:

        ASSIGN i-cont-condicao = i-cont-condicao + 1.    

    END.
    
    IF i-cont-condicao > 350 THEN
        RETURN "NOK".
    ELSE
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

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

