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
{include/i-prgvrs.i BOAF010 2.00.00.003 } /*** "010003" 23/11/2023 16:19:38  ***/
/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOAF010
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName af-faixa-demerito
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
{afbo/boaf010.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE i-nr-controle     LIKE af-controle.nr-controle NO-UNDO.
DEFINE VARIABLE i-ind-tipo-valor  LIKE af-faixa-demerito.ind-tipo-valor NO-UNDO.
DEFINE VARIABLE i-nr-versao       LIKE af-faixa-demerito.nr-versao NO-UNDO.

DEFINE TEMP-TABLE tt-versao-data NO-UNDO
    FIELD nr-versao      LIKE af-versao-avaliacao.nr-versao
    FIELD desc-versao    LIKE af-versao-avaliacao.desc-versao
    FIELD ano-avaliacao  LIKE af-versao-avaliacao.ano-avaliacao
    FIELD nr-periodo     LIKE af-versao-avaliacao.nr-periodo
    FIELD data-ini       AS DATE
    FIELD data-fim       AS DATE
    INDEX data-inicial
          data-ini.

DEFINE TEMP-TABLE tt-item-data NO-UNDO
    FIELD nr-versao      LIKE af-versao-avaliacao.nr-versao
    FIELD desc-versao    LIKE af-versao-avaliacao.desc-versao
    FIELD ano-avaliacao  LIKE af-versao-avaliacao.ano-avaliacao
    FIELD nr-periodo     LIKE af-versao-avaliacao.nr-periodo
    FIELD data-ini       AS DATE
    FIELD data-fim       AS DATE
    INDEX data-inicial
          data-ini.

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
        WHEN "demerito":U THEN ASSIGN pFieldValue = RowObject.demerito.
        WHEN "lim-final":U THEN ASSIGN pFieldValue = RowObject.lim-final.
        WHEN "lim-inicial":U THEN ASSIGN pFieldValue = RowObject.lim-inicial.
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
        WHEN "nr-controle":U THEN ASSIGN pFieldValue = RowObject.nr-controle.
        WHEN "nr-versao":U THEN ASSIGN pFieldValue = RowObject.nr-versao.
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
               retorna valor do campo ep-codigo
               retorna valor do campo nr-controle
               retorna valor do campo lim-inicial
               retorna valor do campo nr-versao
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pep-codigo LIKE af-faixa-demerito.ep-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-controle LIKE af-faixa-demerito.nr-controle NO-UNDO.
    DEFINE OUTPUT PARAMETER plim-inicial LIKE af-faixa-demerito.lim-inicial NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-versao  LIKE af-faixa-demerito.nr-versao NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pep-codigo   = RowObject.ep-codigo
           pnr-controle = RowObject.nr-controle
           plim-inicial = RowObject.lim-inicial
           pnr-versao   = RowObject.nr-versao.

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
  Purpose:     Reposiciona registro com base no °ndice codigo
  Parameters:  
               recebe valor do campo ep-codigo
               recebe valor do campo nr-controle
               recebe valor do campo lim-inicial
               recebe valor do campo nr-versao
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo LIKE af-faixa-demerito.ep-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pnr-controle LIKE af-faixa-demerito.nr-controle NO-UNDO.
    DEFINE INPUT PARAMETER plim-inicial LIKE af-faixa-demerito.lim-inicial NO-UNDO.
    DEFINE INPUT PARAMETER pnr-versao   LIKE af-faixa-demerito.nr-versao NO-UNDO.

    FIND FIRST bfaf-faixa-demerito WHERE 
        bfaf-faixa-demerito.ep-codigo = pep-codigo AND 
        bfaf-faixa-demerito.nr-controle = pnr-controle AND 
        bfaf-faixa-demerito.nr-versao = pnr-versao AND
        bfaf-faixa-demerito.lim-inicial = plim-inicial NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfaf-faixa-demerito THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfaf-faixa-demerito)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryNrControleTipo DBOProgram 
PROCEDURE openQueryNrControleTipo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  OPEN QUERY {&QueryName} FOR EACH {&TableName} 
                             WHERE {&TableName}.ep-codigo   = i-ep-codigo-usuario
                               AND {&TableName}.nr-controle = i-nr-controle
                               AND {&TableName}.nr-versao   = i-nr-versao
                               AND {&TableName}.ind-tipo-valor = i-ind-tipo-valor NO-LOCK INDEXED-REPOSITION.

  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-versoes DBOProgram 
PROCEDURE pi-retorna-versoes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pnr-controle  LIKE af-controle.nr-controle NO-UNDO.
DEFINE OUTPUT PARAMETER pc-versoes  AS CHARACTER   NO-UNDO.

FOR EACH bf{&TableName} NO-LOCK
        WHERE bf{&TableName}.ep-codigo = i-ep-codigo-usuario
        AND     bf{&TableName}.nr-controle = pnr-controle,
    FIRST af-versao-avaliacao NO-LOCK
        WHERE af-versao-avaliacao.ep-codigo = i-ep-codigo-usuario
        AND   af-versao-avaliacao.nr-versao = bf{&TableName}.nr-versao
    BREAK BY af-versao-avaliacao.nr-versao:
    
    IF FIRST-OF (af-versao-avaliacao.nr-versao) THEN DO:
        IF pc-versoes = "" THEN
            ASSIGN pc-versoes = af-versao-avaliacao.desc-versao + "," + 
            STRING(af-versao-avaliacao.nr-versao).
        ELSE
            ASSIGN pc-versoes = pc-versoes + "," + af-versao-avaliacao.desc-versao + "," + 
                STRING(af-versao-avaliacao.nr-versao).
    END.

END.

IF pc-versoes = "" THEN
    ASSIGN pc-versoes = "Nova Vers∆o,-1".
ELSE
    ASSIGN pc-versoes = pc-versoes + "," + "Nova Vers∆o,-1".

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRetornaVersoesData DBOProgram 
PROCEDURE piRetornaVersoesData :
/*------------------------------------------------------------------------------
  Purpose: Recebe uma temp-table de vers‰es com as datas iniciais informadas. Retorna a mesma temp-table com as datas finais calculadas.    
  Parameters: pep-codigo - recebe o codigo da empresa
              pnr-controle - recebe o n£mero de controle
              pi-tipo-faixa - recebe o tipo de faixa (1 - Valor 2 - Percentual) 
              pd-valor-variacao - recebe o valor da variaá∆o (em valor ou percentual)
              tt-versao-data - recebe uma temp-table carregada com as vers‰es e datas iniciais 
              tt-item-data   - retorna a temp-table tt-versao-data com as datas finais preenchidas.
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo        LIKE af-faixa-demerito.ep-codigo      NO-UNDO.
    DEFINE INPUT PARAMETER pnr-controle      LIKE af-faixa-demerito.nr-controle    NO-UNDO.
    DEFINE INPUT PARAMETER pi-tipo-faixa     LIKE af-faixa-demerito.ind-tipo-valor NO-UNDO.
    DEFINE INPUT PARAMETER pd-valor-variacao AS DECIMAL                            NO-UNDO.

    DEFINE INPUT  PARAMETER TABLE FOR tt-versao-data.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-item-data. 
    EMPTY TEMP-TABLE tt-item-data.
    
    FOR EACH bfaf-faixa-demerito NO-LOCK
        WHERE bfaf-faixa-demerito.ep-codigo      = pep-codigo
        AND   bfaf-faixa-demerito.nr-controle    = pnr-controle
        AND   bfaf-faixa-demerito.ind-tipo-valor = pi-tipo-faixa
        AND   bfaf-faixa-demerito.lim-inicial   <= pd-valor-variacao
        AND   bfaf-faixa-demerito.lim-final     >= pd-valor-variacao:
    
        CREATE tt-item-data.
        FOR FIRST tt-versao-data NO-LOCK
            WHERE tt-versao-data.nr-versao = bfaf-faixa-demerito.nr-versao:
            BUFFER-COPY tt-versao-data TO tt-item-data.
        END.
    END.
    
    DEFINE BUFFER bftt-item-data FOR tt-item-data.
    FOR EACH tt-item-data EXCLUSIVE-LOCK:
    
        FIND FIRST bftt-item-data 
            WHERE bftt-item-data.nr-versao = tt-item-data.nr-versao NO-LOCK NO-ERROR.
        /* Buscar o per°odo seguinte, pois a data de in°cio dele determina a data de tÇrmino do per°odo anterior*/
        FIND NEXT bftt-item-data NO-LOCK NO-ERROR.
    
        IF AVAIL bftt-item-data THEN DO:
            ASSIGN tt-item-data.data-fim = bftt-item-data.data-ini - 1.
        END.
        ELSE DO:
            ASSIGN tt-item-data.data-fim = 12/31/9999.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ProximaFaixa DBOProgram 
PROCEDURE ProximaFaixa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param p-nr-controle    like af-controle.nr-controle          no-undo.
def input param p-nr-versao      like af-faixa-demerito.nr-versao      no-undo.
def input param p-ind-tipo-valor like af-faixa-demerito.ind-tipo-valor no-undo.
def output param p-seq-faixa     like af-faixa-demerito.seq-faixa      no-undo.
def output param p-lim-inicial   like af-faixa-demerito.lim-inicial    no-undo.

FIND LAST bf{&TableName}
    WHERE bf{&TableName}.ep-codigo = i-ep-codigo-usuario and
          bf{&TableName}.nr-controle = p-nr-controle and
          bf{&TableName}.nr-versao   = p-nr-versao   and
          bf{&TableName}.ind-tipo-valor = p-ind-tipo-valor NO-LOCK NO-ERROR.
if avail bf{&TableName} then
    assign p-seq-faixa = bf{&TableName}.seq-faixa + 10
           p-lim-inicial = bf{&TableName}.lim-final + 0.01.
else
    assign p-seq-faixa = 10.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setconstraintNrControleTipo DBOProgram 
PROCEDURE setconstraintNrControleTipo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-nr-controle    LIKE af-controle.nr-controle NO-UNDO.
    DEFINE INPUT PARAMETER p-ind-tipo-valor LIKE af-faixa-demerito.ind-tipo-valor NO-UNDO.
    DEFINE INPUT PARAMETER p-nr-versao      LIKE af-faixa-demerito.nr-versao NO-UNDO.

   
    ASSIGN i-nr-controle     = p-nr-controle
           i-ind-tipo-valor  = p-ind-tipo-valor
           i-nr-versao       = p-nr-versao.

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

    IF pType = "CREATE" THEN DO:
        FIND FIRST bf{&TableName}
             WHERE bf{&TableName}.ep-codigo = rowObject.ep-codigo and
                   bf{&TableName}.nr-controle = rowObject.nr-controle and
                   bf{&TableName}.nr-versao   = rowObject.nr-versao   and
                   bf{&TableName}.ind-tipo-valor = rowObject.ind-tipo-valor and
                   bf{&TableName}.seq-faixa = rowObject.seq-faixa NO-LOCK NO-ERROR.

        IF AVAIL bf{&TableName} THEN
            /* Inicio -- Projeto Internacional */
            DO:
            DEFINE VARIABLE c-lbl-liter-faixa-demerito AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Faixa_DemÇrito" *}
            ASSIGN c-lbl-liter-faixa-demerito = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                &ErrorNumber="1"
                &ErrorType="EMS"
                &ErrorSubType="Error"
                &ErrorParameters="c-lbl-liter-faixa-demerito"}
            END. 

    END.

    if rowObject.nr-controle = 4 and
       rowObject.ind-tipo-valor = 2 then do:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-faixa-em-percentual AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Faixa_em_percentual" *}
        ASSIGN c-lbl-liter-faixa-em-percentual = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-aplicada-para-prazo-de-entrega AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "aplicada_para_Prazo_de_Entrega" *}
        ASSIGN c-lbl-liter-aplicada-para-prazo-de-entrega = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                        &ErrorNumber="7972"
                        &ErrorType="EMS"
                        &ErrorSubType="Error"
                        &ErrorParameters="c-lbl-liter-faixa-em-percentual + '~~~~' + c-lbl-liter-aplicada-para-prazo-de-entrega"}
    end.

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

