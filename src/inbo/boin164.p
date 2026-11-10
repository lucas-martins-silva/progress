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
{include/i-prgvrs.i BOIN164 2.00.00.017 } /*** "010017" 25/10/2023 14:45:48  ***/
/*:T--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName BOIN164
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName it-exame
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

&GLOBAL-DEFINE KeyField1 it-codigo /*:T Informar os campos da chave quando o Progress n’o conseguir resolver find {&TableName} OF RowObject. */
&GLOBAL-DEFINE KeyField2 cod-exame /*:T Informar os campos da chave quando o Progress n’o conseguir resolver find {&TableName} OF RowObject. */
&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (m²todo Receive Message) */
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

&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (m‚todo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /*:T Nome da Query que d  acessos a todos os registros, exceto os exclu¡dos pela constraint de seguran‡a. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /*:T Informar os campos da chave quando o Progress nÆo conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

/*:T--- Include com defini‡Æo da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com 
      extensÆo .i ---*/
{inbo/boin164.i RowObject}


/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}
/****************************************************/
/*DEFINI€åES PARA TELA METADADOS FF_COPIAEXAMESITEM*/
/*****************************************************/

DEFINE NEW GLOBAL SHARED VARIABLE hbTT       AS HANDLE NO-UNDO.
DEFINE VARIABLE hTable       AS HANDLE      NO-UNDO.

DEFINE TEMP-TABLE tt-returnTodosExames NO-UNDO
    FIELD codExame AS INTEGER.

DEFINE TEMP-TABLE tt-returnExamPag NO-UNDO
    FIELD codExame  AS INTEGER LABEL "C¢digo"
    FIELD descricao AS CHARACTER LABEL "Descri‡Æo".

DEFINE TEMP-TABLE tt-todosExames NO-UNDO
    FIELD codExame AS INTEGER.

DEFINE TEMP-TABLE tt-examesItemReturn NO-UNDO
    FIELD codExame AS INTEGER.
    
DEFINE TEMP-TABLE tt-returnTodosItens NO-UNDO
    FIELD itCodigo AS CHARACTER.

DEFINE TEMP-TABLE tt-returnItem NO-UNDO
    FIELD itCodigo AS CHARACTER.

DEFINE TEMP-TABLE ttreturnItensPag NO-UNDO
  FIELD itCodigo  AS CHARACTER LABEL "C¢digo"
  FIELD descItem  AS CHARACTER label "Descri‡Æo". 

/****FIM DEFINI€åES METADADOS**************************/

/*temp-table para exames externos do item*/
DEFINE TEMP-TABLE tt-it-exame-externo NO-UNDO LIKE it-exame
       FIELD checkSum AS CHARACTER FORMAT 'x(1)'.

/** getBachRecordsCustom **/
DEFINE TEMP-TABLE tt-comp-ajust NO-UNDO
    FIELD cod-exame LIKE it-exame.cod-exame
    FIELD cod-comp  LIKE comp-exame.cod-comp
    FIELD descricao LIKE comp-exame.descricao
    FIELD comp-tipo-result like comp-exame.tipo-result
    FIELD nr-tabela like comp-exame.nr-tabela.


/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.


 DEFINE VARIABLE c-it-codigo-ini like {&TableName}.it-codigo NO-UNDO.
 DEFINE VARIABLE c-it-codigo-fim like {&TableName}.it-codigo NO-UNDO.
 DEFINE VARIABLE i-cod-exame-ini like {&TableName}.cod-exame NO-UNDO.
 DEFINE VARIABLE i-cod-exame-fim like {&TableName}.cod-exame NO-UNDO. 
 DEFINE VARIABLE c-desc-ini      like {&TableName}.descricao NO-UNDO. 
 DEFINE VARIABLE c-desc-fim      like {&TableName}.descricao NO-UNDO. 
 


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaInformacoes DBOProgram 
PROCEDURE buscaInformacoes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pExame         AS INTEGER NO-UNDO.
DEFINE OUTPUT PARAMETER pFrequencia    AS INTEGER NO-UNDO.
DEFINE OUTPUT PARAMETER pResponsavel   AS CHARACTER NO-UNDO.

FOR FIRST exame
    WHERE exame.cod-exame = pExame 
	  and exame.cdn-sit-vers = 2 NO-LOCK:

    ASSIGN pFrequencia = exame.frequencia
           pResponsavel = exame.cod-resp.

END.
IF NOT AVAIL exame THEN
	FOR FIRST exame
		WHERE exame.cod-exame = pExame NO-LOCK:

		ASSIGN pFrequencia = exame.frequencia
		       pResponsavel = exame.cod-resp.

END.

IF NOT AVAIL exame THEN DO:

   ASSIGN pFrequencia = 0
          pResponsavel = "".    

END.


RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getBatchRecordsCustom DBOProgram
PROCEDURE getBatchRecordsCustom:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pcItCodigo like {&TableName}.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAM table FOR tt-comp-ajust.

    EMPTY TEMP-TABLE tt-comp-ajust.

    FOR EACH {&TableName} NO-LOCK
       WHERE {&TableName}.it-codigo = pcItCodigo,
        EACH comp-exame NO-LOCK
       WHERE comp-exame.cod-exame = {&TableName}.cod-exame:
        IF comp-exame.tipo-result = 3 THEN /*texto*/
            NEXT.   
               
        CREATE tt-comp-ajust.                
        ASSIGN tt-comp-ajust.cod-exame        = comp-exame.cod-exame     
               tt-comp-ajust.cod-comp         = comp-exame.cod-comp      
               tt-comp-ajust.descricao        = comp-exame.descricao
               tt-comp-ajust.comp-tipo-result = comp-exame.tipo-result
               tt-comp-ajust.nr-tabela        = comp-exame.nr-tabela. 
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "descricao":U THEN ASSIGN pFieldValue = RowObject.descricao.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-exame":U THEN ASSIGN pFieldValue = RowObject.cod-exame.
        WHEN "frequencia":U THEN ASSIGN pFieldValue = RowObject.frequencia.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "nivel":U THEN ASSIGN pFieldValue = RowObject.nivel.
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
  Purpose:     Retorna valores dos campos do ¡ndice codigo
  Parameters:  
               retorna valor do campo it-codigo
               retorna valor do campo cod-exame
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pit-codigo LIKE it-exame.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-exame LIKE it-exame.cod-exame NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pit-codigo = RowObject.it-codigo
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
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
  Purpose:     Reposiciona registro com base no ¡ndice codigo
  Parameters:  
               recebe valor do campo it-codigo
               recebe valor do campo cod-exame
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pit-codigo LIKE it-exame.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-exame LIKE it-exame.cod-exame NO-UNDO.

    FIND FIRST bfit-exame WHERE 
        bfit-exame.it-codigo = pit-codigo AND 
        bfit-exame.cod-exame = pcod-exame NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfit-exame THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfit-exame)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByItemExame DBOProgram
PROCEDURE openQueryByItemExame:
/*------------------------------------------------------------------------------
 Purpose: OpenQuery chamado pelo Zoom Z04in164
 Notes:   page 1
------------------------------------------------------------------------------*/
    
    OPEN QUERY {&QueryName} 
      FOR EACH it-exame 
         WHERE it-exame.it-codigo >= c-it-codigo-ini
           AND it-exame.it-codigo <= c-it-codigo-fim 
           AND it-exame.cod-exame >= i-cod-exame-ini
           AND it-exame.cod-exame <= i-cod-exame-fim NO-LOCK.
           
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
OPEN QUERY {&QueryName} FOR EACH it-exame NO-LOCK.
                                                     /* INDEXED-REPOSITION*/
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByItemExame DBOProgram
PROCEDURE setConstraintByItemExame:
/*------------------------------------------------------------------------------
 Purpose: Contraint chamada pelo zoom z04in164.
 Notes:   PAGE 1 
------------------------------------------------------------------------------*/
     DEFINE INPUT PARAMETER pc-it-codigo-ini like {&TableName}.it-codigo NO-UNDO.
     DEFINE INPUT PARAMETER pc-it-codigo-fim like {&TableName}.it-codigo NO-UNDO.
     DEFINE INPUT PARAMETER pi-cod-exame-ini like {&TableName}.cod-exame NO-UNDO.
     DEFINE INPUT PARAMETER pi-cod-exame-fim like {&TableName}.cod-exame NO-UNDO.    

     ASSIGN c-it-codigo-ini = pc-it-codigo-ini
            c-it-codigo-fim = pc-it-codigo-fim
            i-cod-exame-ini = pi-cod-exame-ini
            i-cod-exame-fim = pi-cod-exame-fim.
            
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
    
    IF pType = "CREATE" THEN DO:
       IF CAN-FIND(it-exame
                   WHERE it-exame.cod-exame = RowObject.cod-exame and it-exame.it-codigo = RowObject.it-codigo ) THEN DO:
          {utp/ut-liter.i Item_Exame}            
          {method/svc/errors/inserr.i
           &ErrorNumber="7" 
           &ErrorType="EMS"
           &ErrorParameters= RETURN-VALUE}
       END.
    END.

    IF pType = "CREATE" OR pType = "UPDATE" THEN DO:
       
        IF RowObject.cod-exame < 1 THEN DO:
          {utp/ut-liter.i C½digo_do_exame_deverÿ_ser_maior_que_zero}
          {method/svc/errors/inserr.i
           &ErrorNumber="17006"
           &ErrorType="EMS"
           &ErrorParameters=RETURN-VALUE}
       END.

       IF RowObject.frequencia < 1 THEN DO:
          {utp/ut-liter.i Frequˆncia_deverÿ_ser_maior_que_zero}
          {method/svc/errors/inserr.i
           &ErrorNumber="17006"
           &ErrorType="EMS"
           &ErrorParameters=RETURN-VALUE}
       END.

       IF RowObject.nivel < 1 THEN DO:
          {utp/ut-liter.i N¡vel_deverÿ_ser_maior_que_zero}
          {method/svc/errors/inserr.i
           &ErrorNumber="17006"
           &ErrorType="EMS"
           &ErrorParameters=RETURN-VALUE}
       END.

       IF RowObject.responsavel = "" THEN DO:
          {utp/ut-liter.i Responsavel_deverÿ_ser_diferente_de_branco}
          {method/svc/errors/inserr.i
           &ErrorNumber="17006"
           &ErrorType="EMS"
           &ErrorParameters=RETURN-VALUE}
       END.

    END.
    
    /*:T--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaCampos DBOProgram 
PROCEDURE buscaCampos :
/*:T------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:   
------------------------------------------------------------------------------*/  
DEFINE INPUT  PARAMETER pExame         AS INTEGER NO-UNDO.
DEFINE OUTPUT PARAMETER pFrequencia    AS INTEGER NO-UNDO.
DEFINE OUTPUT PARAMETER pSituacao      AS INTEGER NO-UNDO.
DEFINE OUTPUT PARAMETER pResponsavel   AS CHARACTER NO-UNDO.

	for first exame 
		where exame.cod-exame = pExame 
		  and exame.cdn-sit-vers = 2 no-lock:
		
		assign pFrequencia  = exame.frequencia
			   pSituacao    = exame.situacao
			   pResponsavel = exame.cod-resp.
		
	end.



	RETURN "OK":U.
END PROCEDURE.
  /* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE salvaTpInspecao DBOProgram 
PROCEDURE salvaTpInspecao :
/*:T------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:   
------------------------------------------------------------------------------*/  
	DEFINE INPUT  PARAMETER pItem          AS CHARACTER NO-UNDO.
	DEFINE INPUT  PARAMETER pExame         AS CHARACTER   NO-UNDO.
	DEFINE INPUT  PARAMETER pL1            AS LOGICAL   NO-UNDO.
	DEFINE INPUT  PARAMETER pL2            AS LOGICAL   NO-UNDO.
	DEFINE INPUT  PARAMETER pL3            AS LOGICAL   NO-UNDO.
	DEFINE INPUT  PARAMETER pL4            AS LOGICAL   NO-UNDO.
	DEFINE INPUT  PARAMETER pL5            AS LOGICAL   NO-UNDO.
	DEFINE INPUT  PARAMETER pL6            AS LOGICAL   NO-UNDO.
	
	if pL1 = true then do:
		if not can-find (first exame-insp
						where exame-insp.it-codigo = pItem
						and   exame-insp.cod-exame = int(pExame)
						and   exame-insp.tp-inspecao = 1 no-lock) then do:
			create exame-insp.
			assign exame-insp.it-codigo = pItem
				   exame-insp.cod-exame = int(pExame)
				   exame-insp.tp-inspecao = 1.
		end.
	end.
	else do:
		for first exame-insp
			where exame-insp.it-codigo = pItem
			and   exame-insp.cod-exame = int(pExame)
			and   exame-insp.tp-inspecao = 1 exclusive-lock:
			delete exame-insp.
		end.
	end.

	if pL2 = true then do:
		if not can-find (first exame-insp
						where exame-insp.it-codigo = pItem
						and   exame-insp.cod-exame = int(pExame)
						and   exame-insp.tp-inspecao = 2 no-lock) then do:
			create exame-insp.
			assign exame-insp.it-codigo = pItem
				   exame-insp.cod-exame = int(pExame)
				   exame-insp.tp-inspecao = 2.
		end.
	end.
	else do:
		for first exame-insp
			where exame-insp.it-codigo = pItem
			and   exame-insp.cod-exame = int(pExame)
			and   exame-insp.tp-inspecao = 2 exclusive-lock:
			delete exame-insp.
		end.
	end.   
	
	if pL3 = true then do:
		if not can-find (first exame-insp
						where exame-insp.it-codigo = pItem
						and   exame-insp.cod-exame = int(pExame)
						and   exame-insp.tp-inspecao = 3 no-lock) then do:
			create exame-insp.
			assign exame-insp.it-codigo = pItem
				   exame-insp.cod-exame = int(pExame)
				   exame-insp.tp-inspecao = 3.
		end.
	end.
	else do:
		for first exame-insp
			where exame-insp.it-codigo = pItem
			and   exame-insp.cod-exame = int(pExame)
			and   exame-insp.tp-inspecao = 3 exclusive-lock:
			delete exame-insp.
		end.
	end.
	
	if pL4 = true then do:
		if not can-find (first exame-insp
						where exame-insp.it-codigo = pItem
						and   exame-insp.cod-exame = int(pExame)
						and   exame-insp.tp-inspecao = 4 no-lock) then do:
			create exame-insp.
			assign exame-insp.it-codigo = pItem
				   exame-insp.cod-exame = int(pExame)
				   exame-insp.tp-inspecao = 4.
		end.
	end.
	else do:
		for first exame-insp
			where exame-insp.it-codigo = pItem
			and   exame-insp.cod-exame = int(pExame)
			and   exame-insp.tp-inspecao = 4 exclusive-lock:
			delete exame-insp.
		end.
	end.
	
	if pL5 = true then do:
		if not can-find (first exame-insp
						where exame-insp.it-codigo = pItem
						and   exame-insp.cod-exame = int(pExame)
						and   exame-insp.tp-inspecao = 5 no-lock) then do:
			create exame-insp.
			assign exame-insp.it-codigo = pItem
				   exame-insp.cod-exame = int(pExame)
				   exame-insp.tp-inspecao = 5.
		end.
	end.
	else do:
		for first exame-insp
			where exame-insp.it-codigo = pItem
			and   exame-insp.cod-exame = int(pExame)
			and   exame-insp.tp-inspecao = 5 exclusive-lock:
			delete exame-insp.
		end.
	end.
		   
	if pL6 = true then do:
		if not can-find (first exame-insp
						where exame-insp.it-codigo = pItem
						and   exame-insp.cod-exame = int(pExame)
						and   exame-insp.tp-inspecao = 6 no-lock) then do:
			create exame-insp.
			assign exame-insp.it-codigo = pItem
				   exame-insp.cod-exame = int(pExame)
				   exame-insp.tp-inspecao = 6. 
		end.
	end.
	else do:
		for first exame-insp
			where exame-insp.it-codigo = pItem
			and   exame-insp.cod-exame = int(pExame)
			and   exame-insp.tp-inspecao = 6 exclusive-lock:
			delete exame-insp.
		end.
	end.		   
		   
		   
	RETURN "OK":U.
END PROCEDURE.
  /* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaTpInspecao DBOProgram 
PROCEDURE buscaTpInspecao :
/*:T------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:   
------------------------------------------------------------------------------*/  
	DEFINE INPUT  PARAMETER pItem          AS CHARACTER NO-UNDO.
	DEFINE INPUT  PARAMETER pExame         AS CHARACTER   NO-UNDO.
	DEFINE OUTPUT  PARAMETER pL1            AS LOGICAL   NO-UNDO.
	DEFINE OUTPUT  PARAMETER pL2            AS LOGICAL   NO-UNDO.
	DEFINE OUTPUT  PARAMETER pL3            AS LOGICAL   NO-UNDO.
	DEFINE OUTPUT  PARAMETER pL4            AS LOGICAL   NO-UNDO.
	DEFINE OUTPUT  PARAMETER pL5            AS LOGICAL   NO-UNDO.
	DEFINE OUTPUT  PARAMETER pL6            AS LOGICAL   NO-UNDO.
	
	if can-find (first exame-insp
			where exame-insp.it-codigo = pItem
			and   exame-insp.cod-exame = int(pExame)
			and   exame-insp.tp-inspecao = 1 no-lock) then do:
		assign pL1 = true.
	end.
	else do:
		assign pL1 = false.
	end.

	if can-find (first exame-insp
			where exame-insp.it-codigo = pItem
			and   exame-insp.cod-exame = int(pExame)
			and   exame-insp.tp-inspecao = 2 no-lock) then do:
		assign pL2 = true.
	end.
	else do:
		assign pL2 = false.
	end.
	
	if can-find (first exame-insp
			where exame-insp.it-codigo = pItem
			and   exame-insp.cod-exame = int(pExame)
			and   exame-insp.tp-inspecao = 3 no-lock) then do:
		assign pL3 = true.
	end.
	else do:
		assign pL3 = false.
	end.
	
	if can-find (first exame-insp
			where exame-insp.it-codigo = pItem
			and   exame-insp.cod-exame = int(pExame)
			and   exame-insp.tp-inspecao = 4 no-lock) then do:
		assign pL4 = true.
	end.
	else do:
		assign pL4 = false.
	end.
	
	if can-find (first exame-insp
			where exame-insp.it-codigo = pItem
			and   exame-insp.cod-exame = int(pExame)
			and   exame-insp.tp-inspecao = 5 no-lock) then do:
		assign pL5 = true.
	end.
	else do:
		assign pL5 = false.
	end.
	
	if can-find (first exame-insp
			where exame-insp.it-codigo = pItem
			and   exame-insp.cod-exame = int(pExame)
			and   exame-insp.tp-inspecao = 6 no-lock) then do:
		assign pL6 = true.
	end.
	else do:
		assign pL6 = false.
	end.
	RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
/**************************************************************/
/*PROCEDURES UTILIZADAS PELA TELA METADADOS FF_COPIAEXAMESITEM*/
/**************************************************************/

   

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnTodosExames DBOProgram 
PROCEDURE returnTodosExames :
/*:T------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:   
------------------------------------------------------------------------------*/  
DEFINE INPUT  PARAMETER pItCodigo    AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt-returnTodosExames.

	FOR EACH it-exame 
	   WHERE it-exame.it-codigo= pItCodigo NO-LOCK:
       CREATE tt-returnTodosExames.
       ASSIGN tt-returnTodosExames.codExame = it-exame.cod-Exame.
	END.

	RETURN "OK":U.
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
   /*N£mero de registros mostrados por p ginas no grid (Pagina?Æo)*/
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
        if valid-handle(qhTemp) and valid-handle(hbTT) then do:
            REPEAT:
                qhTemp:GET-NEXT().
                IF qhTemp:QUERY-OFF-END THEN LEAVE.

                phbTTReturn:BUFFER-CREATE().
                phbTTReturn:BUFFER-COPY(hbTT).
                phbTTReturn:BUFFER-RELEASE().
            END.
            qhTemp:QUERY-CLOSE().
        end.


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaRegistrosExamesItem DBOProgram 
PROCEDURE retornaRegistrosExamesItem:
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM currentPage   AS INTEGER.
    DEFINE OUTPUT PARAM TABLE FOR tt-examesItemReturn.

    DEFINE VARIABLE hTTReturn  AS HANDLE NO-UNDO.
    DEFINE VARIABLE hbTTReturn AS HANDLE NO-UNDO.

    ASSIGN hTTReturn = TEMP-TABLE tt-examesItemReturn:HANDLE.
    hbTTReturn = hTTReturn:DEFAULT-BUFFER-HANDLE.

    RUN retornaRegistros(INPUT currentPage, INPUT hbTTReturn, INPUT hTTReturn ).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnExamPag DBOProgram 
PROCEDURE returnExamPag:
/*------------------------------------------------------------------------------
  Purpose:  Retornar todos exames .
  Parameters:

  Notes: /* PROCEDURE CRIADA PARA TELA METADADOS */
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pi-current-page  AS INTEGER.
  DEFINE INPUT  PARAMETER pi-page-size     AS INTEGER.
  DEFINE INPUT  PARAMETER TABLE FOR tt-todosExames. 
  DEFINE INPUT  PARAMETER cItCodigo    AS CHARACTER.
  DEFINE OUTPUT PARAMETER pi-total-record  AS INTEGER.
  DEFINE OUTPUT PARAMETER TABLE FOR tt-returnExamPag.

  EMPTY TEMP-TABLE tt-returnExamPag NO-ERROR.
  ASSIGN hTable     = BUFFER tt-todosExames:HANDLE.
  RUN populaTempTable(INPUT pi-page-size, INPUT "tt-todosExames", OUTPUT pi-total-record).
  RUN retornaRegistrosExamesItem(input pi-current-page, output table tt-todosExames).

  FOR EACH tt-todosExames:
     FOR EACH it-exame FIELDS(cod-exame descricao) WHERE it-exame.it-codigo = cItCodigo AND it-exame.cod-exame = tt-todosExames.codExame NO-LOCK:
          CREATE tt-returnExamPag.
          ASSIGN tt-returnExamPag.codExame   = it-exame.cod-exame
                 tt-returnExamPag.descricao = it-exame.descricao.
      END.
  END.

  END PROCEDURE.

  /* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnTodosItens DBOProgram 
PROCEDURE returnTodosItens:
/*:T------------------------------------------------------------------------------
  Purpose:  retorna todos os itens entre a faixa especificada.   
  Parameters:  
  Notes:  Procedure criada para a tela metadados FF_CopiaExamesItem 
------------------------------------------------------------------------------*/  
DEFINE INPUT  PARAMETER ini    AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER fim    AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt-returnItem.

	FOR EACH ITEM FIELDS(it-codigo desc-item)
        WHERE ITEM.it-codigo >= ini
          AND ITEM.it-codigo <= fim NO-LOCK:

         CREATE tt-returnItem.
         ASSIGN tt-returnItem.itCodigo = ITEM.it-codigo.
	END.

	RETURN "OK":U.
END PROCEDURE.
  /* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnItensPag DBOProgram 
PROCEDURE returnItensPag:
/*------------------------------------------------------------------------------
  Purpose:  Retornar itens paginados .
  Parameters:

  Notes: /* PROCEDURE CRIADA PARA TELA METADADOS */
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pi-current-page  AS INTEGER.
  DEFINE INPUT  PARAMETER pi-page-size     AS INTEGER.
  DEFINE INPUT  PARAMETER TABLE FOR tt-returnTodosItens. 
/*   DEFINE INPUT  PARAMETER cItCodigo    AS CHARACTER. */
  DEFINE OUTPUT PARAMETER pi-total-record  AS INTEGER.
  DEFINE OUTPUT PARAMETER TABLE FOR ttreturnItensPag.

  EMPTY TEMP-TABLE ttreturnItensPag NO-ERROR.
  ASSIGN hTable     = BUFFER tt-returnTodosItens:HANDLE.
  RUN populaTempTable(INPUT pi-page-size, INPUT "tt-returnTodosItens", OUTPUT pi-total-record).
  RUN retornaRegistrosItem(input pi-current-page, output table tt-returnTodosItens).

  FOR EACH tt-returnTodosItens:
    FOR FIRST ITEM FIELDS(it-Codigo desc-item) WHERE ITEM.it-codigo = tt-returnTodosItens.itCodigo NO-LOCK: END.
     IF AVAIL ITEM THEN DO:
          CREATE ttreturnItensPag.
          ASSIGN ttreturnItensPag.itCodigo   = ITEM.it-codigo
                 ttreturnItensPag.descItem  = ITEM.desc-item.
      END.
  END.

 END PROCEDURE.
  /* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaRegistrosItem DBOProgram 
PROCEDURE retornaRegistrosItem:
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/   
    DEFINE INPUT PARAM currentPage   AS INTEGER.
    DEFINE OUTPUT PARAM TABLE FOR tt-returnItem.

    DEFINE VARIABLE hTTReturn  AS HANDLE NO-UNDO.
    DEFINE VARIABLE hbTTReturn AS HANDLE NO-UNDO.

    ASSIGN hTTReturn = TEMP-TABLE tt-returnItem:HANDLE.
    hbTTReturn = hTTReturn:DEFAULT-BUFFER-HANDLE.

    RUN retornaRegistros(INPUT currentPage, INPUT hbTTReturn, INPUT hTTReturn ).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE copiaExameItem DBOProgram 
PROCEDURE copiaExameItem:
/*------------------------------------------------------------------------------
  Purpose: REaliza a c¢pia de exames para itens
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-it-codigo AS CHARACTER.
    DEFINE INPUT PARAM TABLE FOR tt-todosExames.
    DEFINE INPUT PARAM TABLE FOR tt-returnTodosItens.
    DEFINE BUFFER bf-it-exame FOR it-exame.
    DEFINE BUFFER bf2-it-exame FOR it-exame.
    DEFINE BUFFER bf-exame-insp FOR exame-insp.
    DEFINE BUFFER bf-it-comp-exame FOR it-comp-exame.
    DEFINE BUFFER bf-item-compon-test FOR item-compon-test.

    FOR EACH tt-todosExames:
    
        FOR FIRST it-exame where it-exame.it-codigo = pc-it-codigo and it-exame.cod-exame = tt-todosExames.codExame no-lock:
        
            FOR EACH tt-returnTodosItens:
                IF NOT CAN-FIND(bf-it-exame 
                          WHERE bf-it-exame.it-codigo = tt-returnTodosItens.itCodigo
                            AND bf-it-exame.cod-exame = it-exame.cod-exame) THEN DO:
                    
                    CREATE bf-it-exame.
                    ASSIGN bf-it-exame.it-codigo   = tt-returnTodosItens.itCodigo
                           bf-it-exame.cod-exame   = tt-todosExames.codExame
                           bf-it-exame.dt-inclusao = TODAY.   
                           buffer-copy it-exame except it-codigo dt-inclusao cod-exame to bf-it-exame.

                    for each bf-exame-insp 
                       where bf-exame-insp.it-codigo = pc-it-codigo
                         and bf-exame-insp.cod-exame = tt-todosExames.codExame no-lock:

                        IF NOT CAN-FIND(exame-insp 
    						      WHERE exame-insp.it-codigo   = tt-returnTodosItens.itCodigo
    							    AND exame-insp.cod-exame   = bf-exame-insp.cod-exame
                                    AND exame-insp.tp-inspecao = bf-exame-insp.tp-inspecao) THEN DO:
                    
                           create exame-insp.
                           assign exame-insp.it-codigo   = tt-returnTodosItens.itCodigo
                                  exame-insp.cod-exame   = bf-exame-insp.cod-exame.
                        
                           CASE bf-exame-insp.tp-inspecao:
                               WHEN 1 THEN 
                                   ASSIGN exame-insp.tp-inspecao = 1.
                               WHEN 2 THEN 
                                   ASSIGN exame-insp.tp-inspecao = 2.
                               WHEN 3 THEN 
                                   ASSIGN exame-insp.tp-inspecao = 3.
                               WHEN 4 THEN 
                                   ASSIGN exame-insp.tp-inspecao = 4.
                               WHEN 5 THEN 
                                   ASSIGN exame-insp.tp-inspecao = 5.
                               WHEN 6 THEN 
                                   ASSIGN exame-insp.tp-inspecao = 6.
                           END CASE.
                        END.
                    end.
                END.

                
                FOR EACH it-comp-exame 
                  WHERE  it-comp-exame.cod-exame = it-exame.cod-exame 
                     AND it-comp-exame.it-codigo = it-exame.it-codigo no-lock:
                    IF NOT CAN-FIND (FIRST bf-it-comp-exame 
                                     WHERE bf-it-comp-exame.cod-exame = it-comp-exame.cod-exame
                                      AND bf-it-comp-exame.it-codigo = tt-returnTodosItens.itCodigo
                                      AND bf-it-comp-exame.cod-comp  = it-comp-exame.cod-comp) THEN DO:
                        CREATE bf-it-comp-exame.
                        ASSIGN bf-it-comp-exame.it-codigo = tt-returnTodosItens.itCodigo.
                        BUFFER-COPY it-comp-exame except it-codigo to bf-it-comp-exame NO-ERROR.
                        
                    END.
                    
                    // POSICIONA NA TABELA DE TESTES DO item/exame/componente ORIGEM
                    FIND FIRST item-compon-test NO-LOCK
                         WHERE item-compon-test.cod-item        = it-comp-exame.it-codigo
                           AND item-compon-test.cdn-exam        = it-comp-exame.cod-exame
                           AND item-compon-test.cdn-compon-exam = it-comp-exame.cod-comp NO-ERROR.
                    IF AVAILABLE item-compon-test THEN DO:
                        CREATE bf-item-compon-test.
                        ASSIGN bf-item-compon-test.cod-item = tt-returnTodosItens.itCodigo.
                        BUFFER-COPY item-compon-test except cod-item to bf-item-compon-test NO-ERROR.
                    END.
                   
                END.
            END.                                          
        END.

    END.

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaTTItExameExterno DBOProgram 
PROCEDURE criaTTItExameExterno:
/*-----------------------------------------------------------------------------------
  Purpose: Cria temp-table it-exame que sejam externos, filtrados pelo item em tela
  Parameters:  it-codigo
-----------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pc-it-codigo AS CHARACTER.
    DEFINE OUTPUT PARAM TABLE FOR tt-it-exame-externo.
    
    EMPTY TEMP-TABLE tt-it-exame-externo NO-ERROR.
    
    FOR EACH it-exame FIELDS(cod-exame descricao) WHERE it-exame.it-codigo = pc-it-codigo NO-LOCK:
        
        FOR EACH exame FIELDS(cod-exame cdn-sit-vers) WHERE exame.cod-exame = it-exame.cod-exame 
                                                        AND exame.log-exter  NO-LOCK:
            
            FOR FIRST comp-exame FIELDS(tipo-result) NO-LOCK WHERE comp-exame.cod-exame = exame.cod-exame  /*só cria para resultado numérico ou texto*/
                                                              AND (comp-exame.tipo-result = 1 OR comp-exame.tipo-result = 3):

                IF exame.cdn-sit-vers = 2 THEN DO:
                    CREATE tt-it-exame-externo.
                    ASSIGN tt-it-exame-externo.checkSum  = "" 
                           tt-it-exame-externo.cod-exame = it-exame.cod-exame
                           tt-it-exame-externo.descricao = it-exame.descricao.
                END.
                
                IF exame.cdn-sit-vers = 0 THEN DO:
                    CREATE tt-it-exame-externo.
                    ASSIGN tt-it-exame-externo.checkSum  = "" 
                           tt-it-exame-externo.cod-exame = it-exame.cod-exame
                           tt-it-exame-externo.descricao = it-exame.descricao.
                END.
    
            END.
    
        END.
        
    END.

    RETURN "OK":U.    
    
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
