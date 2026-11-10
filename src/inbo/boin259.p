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
&GLOBAL-DEFINE DBOName BOIN259
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName oper-exam
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

&GLOBAL-DEFINE KeyField1 it-codigo /*:T Informar os campos da chave quando o Progress nío conseguir resolver find {&TableName} OF RowObject. */
&GLOBAL-DEFINE KeyField2 cod-roteiro /*:T Informar os campos da chave quando o Progress nío conseguir resolver find {&TableName} OF RowObject. */
&GLOBAL-DEFINE KeyField3 op-codigo /*:T Informar os campos da chave quando o Progress nío conseguir resolver find {&TableName} OF RowObject. */
&GLOBAL-DEFINE KeyField4 cod-exame /*:T Informar os campos da chave quando o Progress nío conseguir resolver find {&TableName} OF RowObject. */
&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (m≤todo Receive Message) */
&GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES



/*:T--- Include com definiá∆o da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin259.i RowObject}


/* *************DEFINIÄÂES METADADOS************************/
DEFINE TEMP-TABLE ttExamesTotal NO-UNDO
	FIELD codExame AS INTEGER
	FIELD responsavel as character.
	
DEFINE TEMP-TABLE ttOperacoesTotal NO-UNDO
	FIELD itCodigo AS CHARACTER
	FIELD codRoteiro AS CHARACTER
	FIELD opCodigo AS INTEGER.

DEFINE TEMP-TABLE ttOperacao NO-UNDO
    FIELD opCodigo AS INTEGER
	FIELD itCodigo AS CHARACTER
	FIELD codRoteiro AS CHARACTER.

DEFINE TEMP-TABLE ttExamesPaginado NO-UNDO LIKE ttExamesTotal.

DEFINE TEMP-TABLE ttExame NO-UNDO
    FIELD codExame AS INTEGER LABEL "Exame"
    FIELD descricao AS CHARACTER LABEL "Descriá∆o"
    FIELD codResp AS CHARACTER LABEL "C¢digo Respons†vel"
    FIELD nomeResp AS CHARACTER LABEL "Nome Respons†vel"
    FIELD cdnVersao AS INTEGER LABEL "Vers∆o"
    FIELD cdnSitVers AS CHARACTER LABEL "Situaá∆o Vers∆o".

DEFINE TEMP-TABLE ttFiltroAvancado NO-UNDO
    FIELD itemIni AS CHARACTER
    FIELD itemFim AS CHARACTER
    FIELD roteiroIni AS CHARACTER
    FIELD roteiroFim AS CHARACTER
    FIELD operacaoIni AS INTEGER
    FIELD operacaoFim AS INTEGER
    FIELD retorno AS INTEGER.

DEFINE TEMP-TABLE ttFiltroSimples NO-UNDO
    FIELD campo AS INTEGER
    FIELD valor AS CHARACTER
    FIELD aplicado AS LOGICAL.

DEFINE BUFFER bf-oper-exam FOR oper-exam.

DEFINE NEW GLOBAL SHARED VARIABLE hbTT       AS HANDLE NO-UNDO.
DEFINE VARIABLE hTable       AS HANDLE      NO-UNDO.

/* *************FIM - DEFINIÄÂES METADADOS******************/
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
         HEIGHT             = 14.42
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
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-roteiro":U THEN ASSIGN pFieldValue = RowObject.cod-roteiro.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "responsavel":U THEN ASSIGN pFieldValue = RowObject.responsavel.
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
        WHEN "dt-inclusao":U THEN ASSIGN pFieldValue = RowObject.dt-inclusao.
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
        WHEN "cod-exame":U THEN ASSIGN pFieldValue = RowObject.cod-exame.
        WHEN "frequencia":U THEN ASSIGN pFieldValue = RowObject.frequencia.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "nivel":U THEN ASSIGN pFieldValue = RowObject.nivel.
        WHEN "op-codigo":U THEN ASSIGN pFieldValue = RowObject.op-codigo.
        WHEN "situacao":U THEN ASSIGN pFieldValue = RowObject.situacao.
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
               retorna valor do campo it-codigo
               retorna valor do campo cod-roteiro
               retorna valor do campo op-codigo
               retorna valor do campo cod-exame
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pit-codigo LIKE oper-exam.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-roteiro LIKE oper-exam.cod-roteiro NO-UNDO.
    DEFINE OUTPUT PARAMETER pop-codigo LIKE oper-exam.op-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-exame LIKE oper-exam.cod-exame NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pit-codigo = RowObject.it-codigo
           pcod-roteiro = RowObject.cod-roteiro
           pop-codigo = RowObject.op-codigo
           pcod-exame = RowObject.cod-exame.

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
  Purpose:     Reposiciona registro com base no °ndice codigo
  Parameters:  
               recebe valor do campo it-codigo
               recebe valor do campo cod-roteiro
               recebe valor do campo op-codigo
               recebe valor do campo cod-exame
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pit-codigo LIKE oper-exam.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-roteiro LIKE oper-exam.cod-roteiro NO-UNDO.
    DEFINE INPUT PARAMETER pop-codigo LIKE oper-exam.op-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-exame LIKE oper-exam.cod-exame NO-UNDO.

    FIND FIRST bfoper-exam WHERE 
        bfoper-exam.it-codigo = pit-codigo AND 
        bfoper-exam.cod-roteiro = pcod-roteiro AND 
        bfoper-exam.op-codigo = pop-codigo AND 
        bfoper-exam.cod-exame = pcod-exame NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfoper-exam THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfoper-exam)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDefault DBOProgram 
PROCEDURE openQueryDefault :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH oper-exam NO-LOCK INDEXED-REPOSITION.

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
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/*============================== MêTODOS TELA C‡PIA EXAMES OPERAÄ«O - METADADOS =============================*/

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaExamesOperacao DBOProgram 
PROCEDURE buscaExamesOperacao :
/*:T------------------------------------------------------------------------------
  Purpose:     busca exames da operaÁ„o
  Parameters:   pc-item      - CÛdigo do item
				pc-roteiro   - cÛdigo do roteiro
				pi-operacao  - cÛdigo da operaÁ„o
				ttExamesTotal - Temp-table com os Exames
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT  PARAMETER pc-item  LIKE oper-exam.it-codigo.
	DEFINE INPUT  PARAMETER pc-roteiro  LIKE oper-exam.cod-roteiro.
	DEFINE INPUT  PARAMETER pi-operacao  LIKE oper-exam.op-codigo.
	DEFINE OUTPUT PARAMETER TABLE FOR ttExamesTotal.
	
	
	IF pc-item <> "" AND pc-roteiro = "" THEN DO:    
        FOR EACH oper-exam FIELD(cod-exame responsavel) 
    	   where oper-exam.it-codigo = pc-item    	     
    		 and oper-exam.op-codigo = pi-operacao no-lock:
    		CREATE ttExamesTotal.
    		ASSIGN ttExamesTotal.codExame = oper-exam.cod-exame
    		       ttExamesTotal.responsavel = oper-exam.responsavel.
    	END.
    END.
    else if pc-item = "" and pc-roteiro <> "" then do:
        FOR EACH oper-exam FIELD(cod-exame responsavel) 
           where oper-exam.cod-roteiro = pc-roteiro           
             and oper-exam.op-codigo = pi-operacao no-lock:
            CREATE ttExamesTotal.
            ASSIGN ttExamesTotal.codExame = oper-exam.cod-exame
                   ttExamesTotal.responsavel = oper-exam.responsavel.
        END.        
    END.    
        
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaExamesOperPaginado DBOProgram 
PROCEDURE buscaExamesOperPaginado :
/*:T------------------------------------------------------------------------------
  Purpose:     busca exames da operaá∆o
  Parameters:   pi-page-size    - Quantidade de registros por p†gina
				pi-current-page - P†gina corrente da paginaá∆o
				ttExamesTotal  - Todos os exames da operaá∆o origem
				pi-total-record - Total de registros
				ttExame - Temp-table com os Exames da p†gina
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT  PARAMETER pi-page-size  AS INTEGER.
	DEFINE INPUT  PARAMETER pi-current-page  AS INTEGER.
	DEFINE INPUT PARAMETER TABLE FOR ttExamesTotal.
    DEFINE OUTPUT PARAMETER pi-total-record AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR ttExame.
    
    EMPTY TEMP-TABLE ttExamesPaginado.

    ASSIGN hTable     = BUFFER ttExamesTotal:HANDLE.
    RUN populaTempTable(INPUT pi-page-size, INPUT "ttExamesTotal", OUTPUT pi-total-record).
    RUN retornaRegistrosExamesOperacao(INPUT pi-current-page, OUTPUT table ttExamesPaginado).

    FOR EACH ttExamesPaginado:
        FOR FIRST exame 
            WHERE exame.cod-exame = ttExamesPaginado.codExame no-lock:
            CREATE ttExame.
            ASSIGN ttExame.codExame = exame.cod-exame
                   ttExame.descricao = exame.descricao 
                   ttExame.codResp =  ttExamesPaginado.responsavel 
                   ttExame.cdnVersao = exame.cdn-versao 
                   ttExame.cdnSitVers = {ininc/i02in114.i 04 exame.cdn-sit-vers}.

            FOR FIRST responsavel WHERE responsavel.cod-resp =  ttExamesPaginado.responsavel no-lock:
                ASSIGN ttExame.nomeResp = responsavel.nome-resp.
            END.
        END.
    END.
        
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaOperacoes DBOProgram 
PROCEDURE buscaOperacoes :
/*:T------------------------------------------------------------------------------
  Purpose:     busca exames da operaá∆o
  Parameters:   ttFiltroSimples  - Filtro Simples
				ttFiltroAvancado - Filtro Avanáado
                ttExamesTotal - Temp-table com as operaá‰es
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER TABLE FOR ttFiltroSimples.
    DEFINE INPUT PARAMETER TABLE FOR ttFiltroAvancado.
	DEFINE OUTPUT PARAMETER TABLE FOR ttOperacoesTotal.

    DEFINE VARIABLE hTToperTotal  AS HANDLE NO-UNDO.
    DEFINE VARIABLE hTTretorno    AS HANDLE NO-UNDO.
    DEFINE VARIABLE qhOperacao    AS HANDLE NO-UNDO.
    DEFINE VARIABLE hOperacao     AS HANDLE NO-UNDO.
    DEFINE VARIABLE cQuery        AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cWhere        AS CHARACTER NO-UNDO.
    
    FIND FIRST ttFiltroSimples NO-LOCK NO-ERROR.
    FIND FIRST ttFiltroAvancado NO-LOCK NO-ERROR.

    ASSIGN hOperacao     = BUFFER operacao:HANDLE.
    ASSIGN hTToperTotal = TEMP-TABLE ttOperacoesTotal:HANDLE.
    ASSIGN hTTretorno = hTToperTotal:DEFAULT-BUFFER-HANDLE.

    ASSIGN cQuery = "PRESELECT EACH operacao fields(it-codigo cod-roteiro op-codigo) ".

    IF ttFiltroSimples.aplicado THEN DO:
     CASE ttFiltroSimples.campo:
         WHEN 1 THEN
             ASSIGN cWhere = "where operacao.it-codigo = '" + ttFiltroSimples.valor + "' ".
         WHEN 2 THEN
             ASSIGN cWhere = "where operacao.cod-roteiro = '" + ttFiltroSimples.valor + "' ".
         WHEN 3 THEN
             ASSIGN cWhere = "where operacao.op-codigo = " + ttFiltroSimples.valor + " ".
    END CASE.
    END.
 
    IF ttFiltroAvancado.retorno = 1 THEN DO:
        
        IF ttFiltroAvancado.roteiroIni = "" AND ttFiltroAvancado.roteiroFim ="" THEN DO:
           ASSIGN cWhere = IF cWhere = "" THEN "where " ELSE cWhere + "and "
                  cWhere = cWhere + "((operacao.it-codigo >= '" + ttFiltroAvancado.itemIni + "' and operacao.it-codigo <= '" + ttFiltroAvancado.itemFim + "') and " +                                  
                                    "(operacao.op-codigo >= " + string(ttFiltroAvancado.operacaoIni) + " and operacao.op-codigo <= " + string(ttFiltroAvancado.operacaoFim) + ")) ".  
           
        END.
        ELSE
        IF ttFiltroAvancado.itemIni = "" AND ttFiltroAvancado.itemFim = "" THEN DO:
           ASSIGN cWhere = IF cWhere = "" THEN "where " ELSE cWhere + "and "
                  cWhere = cWhere + "(operacao.cod-roteiro >= '" + ttFiltroAvancado.roteiroIni + "' and operacao.cod-roteiro <= '" + ttFiltroAvancado.roteiroFim + "') and " +
                                    "(operacao.op-codigo >= " + string(ttFiltroAvancado.operacaoIni) + " and operacao.op-codigo <= " + string(ttFiltroAvancado.operacaoFim) + ")) ". 
                                    
        END.         

    END.

    ASSIGN cQuery = cQuery + cWhere + "INDEXED-REPOSITION".

    CREATE QUERY qhOperacao.
    qhOperacao:SET-BUFFERS(hOperacao).
    qhOperacao:QUERY-PREPARE(cQuery).
    qhOperacao:QUERY-OPEN().

    IF qhOperacao:NUM-RESULTS > 0 THEN DO:
        REPEAT:
          qhOperacao:GET-NEXT().
          IF qhOperacao:QUERY-OFF-END THEN LEAVE.
    
          hTTretorno:BUFFER-CREATE().          
          hTTretorno:BUFFER-FIELD('itCodigo'):BUFFER-VALUE = hOperacao:BUFFER-FIELD('it-codigo'):BUFFER-VALUE.          
          hTTretorno:BUFFER-FIELD('codRoteiro'):BUFFER-VALUE = hOperacao:BUFFER-FIELD('cod-roteiro'):BUFFER-VALUE.             
          hTTretorno:BUFFER-FIELD('opCodigo'):BUFFER-VALUE = hOperacao:BUFFER-FIELD('op-codigo'):BUFFER-VALUE.
         
          hTTretorno:BUFFER-RELEASE().
        END.
    END.
    qhOperacao:QUERY-CLOSE().

    IF VALID-HANDLE(qhOperacao) THEN
        DELETE OBJECT qhOperacao.
    IF VALID-HANDLE(hOperacao) THEN
        DELETE OBJECT hOperacao.
    IF VALID-HANDLE(hTToperTotal) THEN
        DELETE OBJECT hTToperTotal.
    IF VALID-HANDLE(hTTretorno) THEN
        DELETE OBJECT hTTretorno.
        
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaOperacaoPaginado DBOProgram 
PROCEDURE buscaOperacaoPaginado :
/*:T------------------------------------------------------------------------------
  Purpose:     busca exames da operaá∆o
  Parameters:   pi-page-size    - Quantidade de registros por p†gina
				pi-current-page - P†gina corrente da paginaá∆o
				ttOperacoesTotal  - Todos as operaá‰es
				pi-total-record - Total de registros
				ttOperacao - Temp-table com as operaá‰es da p†gina
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT  PARAMETER pi-page-size  AS INTEGER.
	DEFINE INPUT  PARAMETER pi-current-page  AS INTEGER.
	DEFINE INPUT PARAMETER TABLE FOR ttOperacoesTotal.
    DEFINE OUTPUT PARAMETER pi-total-record AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR ttOperacao.
    
    EMPTY TEMP-TABLE ttOperacao.

    ASSIGN hTable     = BUFFER ttOperacoesTotal:HANDLE.
    RUN populaTempTable(INPUT pi-page-size, INPUT "ttOperacoesTotal", OUTPUT pi-total-record).
    RUN retornaRegistrosOperacao(INPUT pi-current-page, OUTPUT table ttOperacao).
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaRegistrosExamesOperacao DBOProgram 
PROCEDURE retornaRegistrosExamesOperacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM currentPage   AS INTEGER.
    DEFINE OUTPUT PARAM TABLE FOR ttExamesPaginado.
   
    DEFINE VARIABLE hTTReturn  AS HANDLE NO-UNDO. 
    DEFINE VARIABLE hbTTReturn AS HANDLE NO-UNDO. 

    ASSIGN hTTReturn = TEMP-TABLE ttExamesPaginado:HANDLE.
    hbTTReturn = hTTReturn:DEFAULT-BUFFER-HANDLE.

    RUN retornaRegistros(INPUT currentPage, INPUT hbTTReturn, INPUT hTTReturn ).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaRegistrosOperacao DBOProgram 
PROCEDURE retornaRegistrosOperacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/   
    DEFINE INPUT PARAM currentPage   AS INTEGER.
    DEFINE OUTPUT PARAM TABLE FOR ttOperacao.
   
    DEFINE VARIABLE hTTReturn  AS HANDLE NO-UNDO. 
    DEFINE VARIABLE hbTTReturn AS HANDLE NO-UNDO. 

    ASSIGN hTTReturn = TEMP-TABLE ttOperacao:HANDLE.
    hbTTReturn = hTTReturn:DEFAULT-BUFFER-HANDLE.

    RUN retornaRegistros(INPUT currentPage, INPUT hbTTReturn, INPUT hTTReturn ).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE populaTempTable DBOProgram 
PROCEDURE populaTempTable :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   /*Número de registros mostrados por p ginas no grid (Pagina?ío)*/
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
    
    /*Atualizar a temp-table rec?m criada com os dados do buffer de registros, atualizando a nova coluna com o número da p gina que conter  o registro.*/
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
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaRegistros DBOProgram 
PROCEDURE retornaRegistros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /*P gina atual do grid*/
    DEFINE INPUT PARAM currentPage   AS INTEGER.
    DEFINE INPUT PARAM phbTTReturn    AS HANDLE.
    DEFINE INPUT PARAM phTTReturn     AS HANDLE.
    
    
    /*Retorna a temp-table com os registros paginados*/
    /*DEFINE OUTPUT PARAM TABLE FOR ttReturn. -- passado para o metodo que faz a chamada*/
    
    DEFINE VARIABLE hTT        AS HANDLE NO-UNDO.
    DEFINE VARIABLE qhTemp     AS HANDLE NO-UNDO.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaFiltroSimples DBOProgram 
PROCEDURE buscaFiltroSimples :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE OUTPUT PARAM lista AS CHARACTER.

 {utp/ut-liter.i "Item"}
 ASSIGN lista = RETURN-VALUE + ",1,".
 {utp/ut-liter.i "Roteiro"}
 ASSIGN lista = lista + RETURN-VALUE + ",2,".
 {utp/ut-liter.i "Operaá∆o"}
 ASSIGN lista = lista + RETURN-VALUE + ",3".


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE copiaExamesOperacao DBOProgram 
PROCEDURE copiaExamesOperacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM cCombo AS CHARACTER. /* 1- item,  2- Roteiro */
    DEFINE INPUT PARAM itCodigoOrig AS CHARACTER.
    DEFINE INPUT PARAM codRoteiroOrig AS CHARACTER.
    DEFINE INPUT PARAM opCodigoOrig AS INTEGER.
    DEFINE INPUT PARAM TABLE FOR ttExamesTotal.
    DEFINE INPUT PARAM TABLE FOR ttOperacoesTotal.
    
    /*Operaá∆o x Item*/
    IF cCombo = "1" THEN DO:
        FOR EACH ttExamesTotal:
            FOR FIRST oper-exam 
                WHERE oper-exam.it-codigo = itCodigoOrig                  
                  AND oper-exam.op-codigo = opCodigoOrig
                  AND oper-exam.cod-exame = ttExamesTotal.codExame NO-LOCK:
                
                FOR EACH ttOperacoesTotal:
                    IF NOT CAN-FIND( FIRST bf-oper-exam 
                                     WHERE bf-oper-exam.it-codigo   = ttOperacoesTotal.itCodigo                                       
                                       AND bf-oper-exam.op-codigo   = ttOperacoesTotal.opCodigo
                                       AND bf-oper-exam.cod-exame   = oper-exam.cod-exame) THEN DO:
                        CREATE bf-oper-exam.
                        ASSIGN bf-oper-exam.it-codigo = ttOperacoesTotal.itCodigo                               
                               bf-oper-exam.op-codigo   = ttOperacoesTotal.opCodigo.
                        BUFFER-COPY oper-exam EXCEPT it-codigo op-codigo TO bf-oper-exam NO-ERROR.
                    END.
                END.
            END.
        END.  
    END.
    /*Operaá∆o x Roteiro  */
    ELSE DO:
         FOR EACH ttExamesTotal:
            FOR FIRST oper-exam
                WHERE oper-exam.cod-roteiro = codRoteiroOrig                  
                  AND oper-exam.op-codigo = opCodigoOrig
                  AND oper-exam.cod-exame = ttExamesTotal.codExame NO-LOCK:
                
                FOR EACH ttOperacoesTotal:
                    IF NOT CAN-FIND( FIRST bf-oper-exam 
                                     WHERE bf-oper-exam.cod-roteiro = ttOperacoesTotal.codRoteiro                                     
                                       AND bf-oper-exam.op-codigo   = ttOperacoesTotal.opCodigo
                                       AND bf-oper-exam.cod-exame   = oper-exam.cod-exame) THEN DO:
                        CREATE bf-oper-exam.
                        ASSIGN bf-oper-exam.cod-roteiro = ttOperacoesTotal.codRoteiro                              
                               bf-oper-exam.op-codigo   = ttOperacoesTotal.opCodigo.
                        BUFFER-COPY oper-exam EXCEPT cod-roteiro op-codigo TO bf-oper-exam NO-ERROR.
                    END.
                END.
            END.
        END.       
    END.       

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
