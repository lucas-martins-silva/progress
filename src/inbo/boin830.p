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
{include/i-prgvrs.i BOIN830 2.00.10.006 } /*** "010006" 25/10/2023 14:45:49  ***/

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN830
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName fda-param-inspec
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

/*:T Pre-processadores necess†rios para utilizar o DBO no MetaDados*/                                        
&GLOBAL-DEFINE KeyField1             cdn-grp-emit  /*:T Informar os campos da chave da tabela, quando o Progress n∆o conseguir resolver find {&TableName} OF RowObject.*/
&GLOBAL-DEFINE XMLReceiver           YES           /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (mÇtodo Receive Message)*/
&GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES          

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
{inbo/boin830.i RowObject}


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
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
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
        WHEN "dat-livre-1":U THEN ASSIGN pFieldValue = RowObject.dat-livre-1.
        WHEN "dat-livre-2":U THEN ASSIGN pFieldValue = RowObject.dat-livre-2.
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cdn-comut-aten-lote":U THEN ASSIGN pFieldValue = RowObject.cdn-comut-aten-lote.
        WHEN "cdn-comut-aten-rejtdo":U THEN ASSIGN pFieldValue = RowObject.cdn-comut-aten-rejtdo.
        WHEN "cdn-comut-inspec-lote":U THEN ASSIGN pFieldValue = RowObject.cdn-comut-inspec-lote.
        WHEN "cdn-comut-inspec-rej":U THEN ASSIGN pFieldValue = RowObject.cdn-comut-inspec-rej.
        WHEN "cdn-comut-normal-aten-lote":U THEN ASSIGN pFieldValue = RowObject.cdn-comut-normal-aten-lote.
        WHEN "cdn-comut-normal-aten-rej":U THEN ASSIGN pFieldValue = RowObject.cdn-comut-normal-aten-rej.
        WHEN "cdn-comut-sev-normal-lote":U THEN ASSIGN pFieldValue = RowObject.cdn-comut-sev-normal-lote.
        WHEN "cdn-comut-sev-normal-rejtdo":U THEN ASSIGN pFieldValue = RowObject.cdn-comut-sev-normal-rejtdo.
        WHEN "cdn-grp-emit":U THEN ASSIGN pFieldValue = RowObject.cdn-grp-emit.
        WHEN "cdn-inspec-preferen-x-1":U THEN ASSIGN pFieldValue = RowObject.cdn-inspec-preferen-x-1.
        WHEN "cdn-inspec-preferen-x-2":U THEN ASSIGN pFieldValue = RowObject.cdn-inspec-preferen-x-2.
        WHEN "cdn-inspec-preferen-x-3":U THEN ASSIGN pFieldValue = RowObject.cdn-inspec-preferen-x-3.
        WHEN "cdn-inspec-preferen-y-1":U THEN ASSIGN pFieldValue = RowObject.cdn-inspec-preferen-y-1.
        WHEN "cdn-inspec-preferen-y-2":U THEN ASSIGN pFieldValue = RowObject.cdn-inspec-preferen-y-2.
        WHEN "cdn-inspec-preferen-y-3":U THEN ASSIGN pFieldValue = RowObject.cdn-inspec-preferen-y-3.
        WHEN "cdn-inspec-preferen-z-1":U THEN ASSIGN pFieldValue = RowObject.cdn-inspec-preferen-z-1.
        WHEN "cdn-inspec-preferen-z-2":U THEN ASSIGN pFieldValue = RowObject.cdn-inspec-preferen-z-2.
        WHEN "cdn-inspec-preferen-z-3":U THEN ASSIGN pFieldValue = RowObject.cdn-inspec-preferen-z-3.
        WHEN "idi-tip-skip-lote":U THEN ASSIGN pFieldValue = RowObject.idi-tip-skip-lote.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram  
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice fdprmnsp-id
  Parameters:  
               retorna valor do campo cdn-grp-emit
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcdn-grp-emit LIKE fda-param-inspec.cdn-grp-emit NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcdn-grp-emit = RowObject.cdn-grp-emit.

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
  Purpose:     Reposiciona registro com base no °ndice fdprmnsp-id
  Parameters:  
               recebe valor do campo cdn-grp-emit
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcdn-grp-emit LIKE fda-param-inspec.cdn-grp-emit NO-UNDO.

    FIND FIRST bffda-param-inspec WHERE 
        bffda-param-inspec.cdn-grp-emit = pcdn-grp-emit NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bffda-param-inspec THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bffda-param-inspec)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDefault DBOProgram 
PROCEDURE openQueryDefault :
/*:T------------------------------------------------------------------------------
  Purpose: Procedure obrigat¢ria para execuá∆o via MetaDados
  Parameters:  <none>
  Notes: Para execuá∆o do DBO via Metadados Ç necess†rio que o DBO utilize a Procedure openQueryDefault para abrir a query principal do DBO.
         Esta Procedure pode ser customizada conforme necessidade do usu†rio.
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK.

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
    DEF VAR c-trad-param AS CHAR.
	DEF VAR c-trad-param-aux AS CHAR.

	if pType = "Create" then do:
        IF CAN-FIND(fda-param-inspec WHERE fda-param-inspec.cdn-grp-emit = RowObject.cdn-grp-emit) THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-parametro-inspecao-x-grupo-for AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "ParÉmetro_Inspeá∆o_X_Grupo_Fornecedor" *}
            ASSIGN c-lbl-liter-parametro-inspecao-x-grupo-for = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                               &ErrorNumber="7"
                               &ErrorType="EMS"
                               &ErrorParameters="c-lbl-liter-parametro-inspecao-x-grupo-for"}
            RETURN "NOK".
        END.
	end.
	
	if pType = "Create" OR pType = "Update" then do:
		
		if RowObject.cdn-comut-aten-lote < RowObject.cdn-comut-aten-rejtdo then do:
			{method/svc/errors/inserr.i &ErrorNumber="505"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="string(RowObject.cdn-comut-aten-rejtdo) + '~~~~' +  string(RowObject.cdn-comut-aten-lote)"} 
			return "NOK".
			
		end.
		
		if RowObject.cdn-comut-inspec-lote < RowObject.cdn-comut-inspec-rej then do:
			{method/svc/errors/inserr.i &ErrorNumber="505"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="string(RowObject.cdn-comut-inspec-rej) + '~~~~' + string(RowObject.cdn-comut-inspec-lote)"} 
			return "NOK".
			
		end.

		if RowObject.cdn-comut-sev-normal-lote >= RowObject.cdn-comut-normal-aten-lote then do:
			{utp/ut-liter.i Lotes_Normal/Atenuada_deve_ser_maior_que_lotes_Severa/Normal.}
			   {method/svc/errors/inserr.i
			   &ErrorNumber="17006"
			   &ErrorType="EMS"
			   &ErrorSubType="ERROR"
			   &ErrorParameters=RETURN-VALUE}
			return "NOK".
			
		end.

		if RowObject.cdn-comut-normal-aten-lote < RowObject.cdn-comut-normal-aten-rej then do:
			{method/svc/errors/inserr.i &ErrorNumber="505"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="string(RowObject.cdn-comut-normal-aten-rej) + '~~~~' + string(RowObject.cdn-comut-normal-aten-lote)"} 
			return "NOK".
			
		end.
		
		if RowObject.cdn-comut-sev-normal-lote < RowObject.cdn-comut-sev-normal-rejtdo then do:
			{method/svc/errors/inserr.i &ErrorNumber="505"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="string(RowObject.cdn-comut-sev-normal-rejtdo) + '~~~~' + string(RowObject.cdn-comut-sev-normal-lote)"} 
			return "NOK".
			
		end.
		
		 IF RowObject.idi-tip-skip-lote < 1 THEN DO:
		  {utp/ut-liter.i Skip_Lot_deve_ser_diferente_de_branco}
		  {method/svc/errors/inserr.i
		   &ErrorNumber="17006"
		   &ErrorType="EMS"
		   &ErrorSubType="ERROR"
		   &ErrorParameters=RETURN-VALUE}
		END.
		
		if RowObject.idi-tip-skip-lote = 1 then do:
			if RowObject.cdn-inspec-preferen-y-1 > RowObject.cdn-inspec-preferen-x-1 then do:
				{utp/ut-liter.i Bom_X}
				ASSIGN c-trad-param     = RETURN-VALUE.
				{utp/ut-liter.i Bom_Y}
				ASSIGN c-trad-param-aux = RETURN-VALUE.
				{method/svc/errors/inserr.i &ErrorNumber="508"
											&ErrorType="EMS"
											&ErrorSubType="ERROR"
											&ErrorParameters="c-trad-param-aux + '~~~~' + c-trad-param"} 
				return "NOK".
			end.
			
			if RowObject.cdn-inspec-preferen-z-1 > RowObject.cdn-inspec-preferen-y-1 then do:
				{utp/ut-liter.i Bom_Y}
				ASSIGN c-trad-param     = RETURN-VALUE.
				{utp/ut-liter.i Bom_Z}
				ASSIGN c-trad-param-aux = RETURN-VALUE.
				{method/svc/errors/inserr.i &ErrorNumber="508"
											&ErrorType="EMS"
											&ErrorSubType="ERROR"
											&ErrorParameters="c-trad-param-aux + '~~~~' + c-trad-param"} 
				return "NOK".
			end.
			
			if RowObject.cdn-inspec-preferen-x-2 > RowObject.cdn-inspec-preferen-x-1 then do:
				{utp/ut-liter.i Bom_X}
				ASSIGN c-trad-param     = RETURN-VALUE.
				{utp/ut-liter.i Otimo_X}
				ASSIGN c-trad-param-aux = RETURN-VALUE.
				{method/svc/errors/inserr.i &ErrorNumber="508"
											&ErrorType="EMS"
											&ErrorSubType="ERROR"
											&ErrorParameters="c-trad-param-aux + '~~~~' + c-trad-param"} 
				return "NOK".
			end.
			
			if RowObject.cdn-inspec-preferen-y-2 > RowObject.cdn-inspec-preferen-y-1 then do:
				{utp/ut-liter.i Bom_Y}
				ASSIGN c-trad-param     = RETURN-VALUE.
				{utp/ut-liter.i ‡timo_Y}
				ASSIGN c-trad-param-aux = RETURN-VALUE.
				{method/svc/errors/inserr.i &ErrorNumber="508"
											&ErrorType="EMS"
											&ErrorSubType="ERROR"
											&ErrorParameters="c-trad-param-aux + '~~~~' + c-trad-param"} 
				return "NOK".
			end.
			
			if RowObject.cdn-inspec-preferen-z-2 > RowObject.cdn-inspec-preferen-z-1 then do:
				{utp/ut-liter.i Bom_Z}		
				ASSIGN c-trad-param     = RETURN-VALUE.
				{utp/ut-liter.i ‡timo_Z}
				ASSIGN c-trad-param-aux = RETURN-VALUE.
				{method/svc/errors/inserr.i &ErrorNumber="508"
											&ErrorType="EMS"
											&ErrorSubType="ERROR"
											&ErrorParameters="c-trad-param-aux + '~~~~' + c-trad-param"} 
				return "NOK".
			end.
			
			if RowObject.cdn-inspec-preferen-x-3 > RowObject.cdn-inspec-preferen-x-2 then do:
				{utp/ut-liter.i ‡timo_X}
				ASSIGN c-trad-param     = RETURN-VALUE.
				{utp/ut-liter.i Excelente_X}
				ASSIGN c-trad-param-aux = RETURN-VALUE.
				{method/svc/errors/inserr.i &ErrorNumber="508"
											&ErrorType="EMS"
											&ErrorSubType="ERROR"
											&ErrorParameters="c-trad-param-aux + '~~~~' + c-trad-param"} 
				return "NOK".
			end.
					
			if RowObject.cdn-inspec-preferen-y-3 > RowObject.cdn-inspec-preferen-y-2 then do:
				{utp/ut-liter.i ‡timo_Y}
				ASSIGN c-trad-param     = RETURN-VALUE.
				{utp/ut-liter.i Excelente_Y}
				ASSIGN c-trad-param-aux = RETURN-VALUE.
				{method/svc/errors/inserr.i &ErrorNumber="508"
											&ErrorType="EMS"
											&ErrorSubType="ERROR"
											&ErrorParameters="c-trad-param-aux + '~~~~' + c-trad-param"} 
				return "NOK".
			end.

			if RowObject.cdn-inspec-preferen-z-3 > RowObject.cdn-inspec-preferen-z-2 then do:
				{utp/ut-liter.i ‡timo_Z}
				ASSIGN c-trad-param     = RETURN-VALUE.
				{utp/ut-liter.i Excelente_Z}
				ASSIGN c-trad-param-aux = RETURN-VALUE.
				{method/svc/errors/inserr.i &ErrorNumber="508"
											&ErrorType="EMS"
											&ErrorSubType="ERROR"
											&ErrorParameters="c-trad-param-aux + '~~~~' + c-trad-param"} 
				return "NOK".
			end.
		end.

	end.
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

