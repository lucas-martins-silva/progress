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
{include/i-prgvrs.i BOIN693 2.00.00.004 } /*** "010004" 25/10/2023 14:45:48  ***/
/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN693
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName fm-exame
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


&GLOBAL-DEFINE KeyField1 fm-codigo /*:T Informar os campos da chave quando o Progress n∆o conseguir resolver find {&TableName} OF RowObject. */
&GLOBAL-DEFINE KeyField2 cod-exame /*:T Informar os campos da chave quando o Progress n∆o conseguir resolver find {&TableName} OF RowObject. */
&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (mÇtodo Receive Message) */
/* &GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES */


/*:T--- Include com definiá∆o da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin693.i RowObject}
{cdp/cdcfgmat.i}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaInformacoes DBOProgram 
PROCEDURE buscaInformacoes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pExame         AS INTEGER NO-UNDO.
DEFINE OUTPUT PARAMETER PDescricao	   AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pFrequencia    AS INTEGER NO-UNDO.
DEFINE OUTPUT PARAMETER pResponsavel   AS CHARACTER NO-UNDO.

FOR FIRST exame
    WHERE exame.cod-exame = pExame 
	  and exame.cdn-sit-vers = 2 NO-LOCK:

    ASSIGN pDescricao  = exame.descricao
           pFrequencia = exame.frequencia
           pResponsavel = exame.cod-resp.

END.

IF NOT AVAIL exame THEN 
	FOR FIRST exame
		WHERE exame.cod-exame = pExame NO-LOCK:

		ASSIGN pDescricao  = exame.descricao
			pFrequencia = exame.frequencia
			pResponsavel = exame.cod-resp.

END.

IF NOT AVAIL exame THEN DO:

   ASSIGN pDescricao  = ""     
          pFrequencia = 0
          pResponsavel = "".    

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
        WHEN "descricao":U THEN ASSIGN pFieldValue = RowObject.descricao.
        WHEN "fm-codigo":U THEN ASSIGN pFieldValue = RowObject.fm-codigo.
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
               retorna valor do campo fm-codigo
               retorna valor do campo cod-exame
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pfm-codigo LIKE fm-exame.fm-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-exame LIKE fm-exame.cod-exame NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pfm-codigo = RowObject.fm-codigo
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
               recebe valor do campo fm-codigo
               recebe valor do campo cod-exame
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pfm-codigo LIKE fm-exame.fm-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-exame LIKE fm-exame.cod-exame NO-UNDO.

    FIND FIRST bffm-exame WHERE 
        bffm-exame.fm-codigo = pfm-codigo AND 
        bffm-exame.cod-exame = pcod-exame NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bffm-exame THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bffm-exame)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

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
    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} NO-LOCK INDEXED-REPOSITION.
                                      
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

	
    IF pType = "CREATE" THEN DO:
       IF NOT CAN-FIND(FIRST exame
					   WHERE exame.cod-exame = RowObject.cod-exame) THEN DO:
          /* Inicio -- Projeto Internacional */
          {utp/ut-table.i mgind exame 1} /* Busca o label da tabela */
          {method/svc/errors/inserr.i
           &ErrorNumber="7"
           &ErrorType="EMS"
           &ErrorParameters=TRIM(RETURN-VALUE)}
       END.
	   
	   IF CAN-FIND(FIRST fm-exame
				   WHERE fm-exame.fm-codigo = RowObject.fm-codigo 
				   AND fm-exame.cod-exame   = RowObject.cod-exame NO-LOCK) THEN DO:
		  {utp/ut-liter.i "Exame Fam°lia"}
		  {method/svc/errors/inserr.i
		   &ErrorNumber="7"
		   &ErrorType="EMS"
		   &ErrorParameters=RETURN-VALUE}
	   END.
    END.
	
    &IF '{&bf_lote_avancado_liberado}' = 'yes' &THEN
    	IF CAN-FIND(FIRST funcao 
    				WHERE funcao.cd-funcao = "lote-avancado" 
    				AND   funcao.ativo     = true NO-LOCK) THEN DO:

            IF pType = "CREATE" OR pType = "UPDATE" THEN DO:
               IF RowObject.cod-exame < 1 THEN DO:
                  {utp/ut-liter.i C¢digo_do_exame_dever_ser_maior_que_zero}
                  {method/svc/errors/inserr.i
                   &ErrorNumber="17006"
                   &ErrorType="EMS"
                   &ErrorParameters=RETURN-VALUE}
               END.
        
                IF RowObject.responsavel = "" THEN DO:
                  {utp/ut-liter.i Respons†vel_deve_ser_informado}
                  {method/svc/errors/inserr.i
                   &ErrorNumber="17006"
                   &ErrorType="EMS"
                   &ErrorParameters=RETURN-VALUE}
               END.
        
               IF RowObject.nivel < 0 THEN DO:
                  {utp/ut-liter.i N°vel_deve_ser_maior_que_zero}
                  {method/svc/errors/inserr.i
                   &ErrorNumber="17006"
                   &ErrorType="EMS"
                   &ErrorParameters=RETURN-VALUE}
               END.
            END.
    	END.
    &ENDIF

    IF NOT CAN-FIND(FIRST responsavel
                    WHERE responsavel.cod-resp = RowObject.responsavel NO-LOCK) THEN DO:
        {utp/ut-liter.i Deve_ser_informado_um_Responsˇvel_vˇlido}
        {method/svc/errors/inserr.i
         &ErrorNumber="17006"
         &ErrorType="EMS"
         &ErrorParameters=RETURN-VALUE}
    END.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
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
    DEFINE INPUT  PARAMETER pFamilia AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER pExame   AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pL1 AS LOGICAL initial no NO-UNDO.
    DEFINE OUTPUT PARAMETER pL2 AS LOGICAL initial no NO-UNDO.
    DEFINE OUTPUT PARAMETER pL3 AS LOGICAL initial no NO-UNDO.
    DEFINE OUTPUT PARAMETER pL4 AS LOGICAL initial no NO-UNDO.
    DEFINE OUTPUT PARAMETER pL5 AS LOGICAL initial no NO-UNDO.
    DEFINE OUTPUT PARAMETER pL6 AS LOGICAL initial no NO-UNDO.
	
	for each fm-insp-exame
        where fm-insp-exame.fm-codigo = pFamilia
        and   fm-insp-exame.cod-exame = INT(pExame) NO-LOCK:
        
        if  fm-insp-exame.tp-inspecao = 1 then do:
            assign pL1 = YES. 
		end.
        
		if  fm-insp-exame.tp-inspecao = 2 then do:
            assign pL2 = YES. 
		end.
		
		if  fm-insp-exame.tp-inspecao = 3 then do:
            assign pL3 = YES. 
		end.
        
		if  fm-insp-exame.tp-inspecao = 4 then do:
            assign pL4 = YES. 
		end.
        
		if  fm-insp-exame.tp-inspecao = 5 then do:
            assign pL5 = YES. 
		end.
        
		if  fm-insp-exame.tp-inspecao = 6 then do:
            assign pL6 = YES. 
		end.

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
    DEFINE INPUT PARAMETER pFamilia AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pExame AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pL1 AS LOGICAL NO-UNDO.
    DEFINE INPUT PARAMETER pL2 AS LOGICAL NO-UNDO.
    DEFINE INPUT PARAMETER pL3 AS LOGICAL NO-UNDO.
    DEFINE INPUT PARAMETER pL4 AS LOGICAL NO-UNDO.
    DEFINE INPUT PARAMETER pL5 AS LOGICAL NO-UNDO.
    DEFINE INPUT PARAMETER pL6 AS LOGICAL NO-UNDO.
    
    
    /* AtualizaÁao do exame-insp */
    RUN pi-atualiza-exame-insp (input pFamilia,
                                input INT(pExame),
                                input 1,
                                input pL1).
                                
    RUN pi-atualiza-exame-insp (input pFamilia,
                                input INT(pExame),
                                input 2,
                                input pL2).
                                
    RUN pi-atualiza-exame-insp (input pFamilia,
                                input INT(pExame),
                                input 3,
                                input pL3).
                                
    RUN pi-atualiza-exame-insp (input pFamilia,
                                input INT(pExame),
                                input 4,
                                input pL4).
                                
    RUN pi-atualiza-exame-insp (input pFamilia,
                                input INT(pExame),
                                input 5,
                                input pL5).
                                
    RUN pi-atualiza-exame-insp (input pFamilia,
                                input INT(pExame),
                                input 6,
                                input pL6).

    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


PROCEDURE pi-atualiza-exame-insp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  def input parameter c-fm-codigo   as character no-undo.
  def input parameter i-cod-exame   as integer   no-undo.
  def input parameter i-tp-inspecao as integer   no-undo.
  def input parameter l-checked     as logical   no-undo.
  
  find fm-insp-exame
      where fm-insp-exame.fm-codigo   = c-fm-codigo
      and   fm-insp-exame.cod-exame   = i-cod-exame
      and   fm-insp-exame.tp-inspecao = i-tp-inspecao EXCLUSIVE-LOCK NO-ERROR.
  if  avail fm-insp-exame then do:
      if  l-checked = no then delete fm-insp-exame.
  end.
  else do:
      if  l-checked = yes then do:
          create fm-insp-exame.
          assign fm-insp-exame.cod-exame   = i-cod-exame
                 fm-insp-exame.fm-codigo   = c-fm-codigo
                 fm-insp-exame.tp-inspecao = i-tp-inspecao.
      end.
  end.

END PROCEDURE.

