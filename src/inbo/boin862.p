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
{include/i-prgvrs.i BOIN862 2.00.00.019 } /*** "010019" 13/11/2023 11:45:51 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i boin862 MUT}
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
&GLOBAL-DEFINE DBOName BOin862
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName param-convrsr-nfe
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
{inbo/boin862.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

{cdp/cdcfgmat.i}

DEFINE VARIABLE h-dbo-classif-impto AS HANDLE   NO-UNDO.
DEFINE VARIABLE h-boin871           AS HANDLE   NO-UNDO.
DEFINE VARIABLE h-boin874           AS HANDLE   NO-UNDO.
DEFINE BUFFER bf-param-convrsr-nfe FOR param-convrsr-nfe.

{inbo/boin874.i tt-docto-orig-nfse-aux}

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
         HEIGHT             = 15.58
         WIDTH              = 35.72.
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
        WHEN "cod-servid-rpw":U THEN ASSIGN pFieldValue = RowObject.cod-servid-rpw.
        &if "{&bf_mat_versao_ems}" >= "2.09" &then
            WHEN "nom-dir-import":U THEN ASSIGN pFieldValue = RowObject.nom-dir-import.
        &ENDIF        
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
        WHEN "idi-gera-dupl-nfe":U THEN ASSIGN pFieldValue = RowObject.idi-gera-dupl-nfe.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "num-seq-param-convrsr":U THEN ASSIGN pFieldValue = RowObject.num-seq-param-convrsr.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice unico
  Parameters:  
               retorna valor do campo num-seq-param-convrsr

  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER p-num-seq-param-convrsr LIKE param-convrsr-nfe.num-seq-param-convrsr NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN p-num-seq-param-convrsr = RowObject.num-seq-param-convrsr.

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
        WHEN "log-gera-impto":U THEN ASSIGN pFieldValue = RowObject.log-gera-impto.
        WHEN "log-altera-dat-trans":U THEN ASSIGN pFieldValue = RowObject.log-altera-dat-trans.
        WHEN "log-bloq-item-branco":U THEN ASSIGN pFieldValue = RowObject.log-bloq-item-branco.
        WHEN "log-bloq-nfe-cancda":U THEN ASSIGN pFieldValue =   RowObject.log-bloq-nfe-cancda.
        WHEN "log-modalid-frete-ped-compra":U THEN ASSIGN pFieldValue = RowObject.log-modalid-frete-ped-compra.
        WHEN "log-suger-depos-localiz":U THEN ASSIGN pFieldValue = RowObject.log-suger-depos-localiz.
        WHEN "log-habilita-item":U THEN ASSIGN pFieldValue = RowObject.log-habilita-item.
        WHEN "log-suger-cfisc":U THEN ASSIGN pFieldValue = RowObject.log-suger-cfisc.
        WHEN "log-traduz-obs":U THEN ASSIGN pFieldValue = RowObject.log-traduz-obs.
        WHEN "log-relacdo-item-fornec":U THEN ASSIGN pFieldValue = RowObject.log-relacdo-item-fornec.               
        WHEN "log-valid-chave-aces-fisc":U THEN ASSIGN pFieldValue = RowObject.log-valid-chave-aces-fisc.
        WHEN "log-valid-chave-aces-fisic":U THEN ASSIGN pFieldValue = RowObject.log-valid-chave-aces-fisic. 
        WHEN "log-livre-1":U THEN ASSIGN pFieldValue = RowObject.log-livre-1.
        WHEN "log-livre-2":U THEN ASSIGN pFieldValue = RowObject.log-livre-2.                
        /*WHEN "log-habilita-cte" THEN ASSIGN pFieldValue = RowObject.log-habilita-cte.*/
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
  Purpose:     Reposiciona registro com base no °ndice unico
  Parameters:  
               recebe valor do campo num-seq-param-convrsr
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-num-seq-param-convrsr LIKE param-convrsr-nfe.num-seq-param-convrsr NO-UNDO.

    FIND FIRST bf{&TableName} WHERE 
        bf{&TableName}.num-seq-param-convrsr = p-num-seq-param-convrsr NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bf{&TableName} THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bf{&TableName})).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:  Abertura da query principal do DBO   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setError DBOProgram 
PROCEDURE setError :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM c-num-error AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAM c-tp-error AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAM c-des-error AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAM c-param-error AS CHARACTER NO-UNDO.

    {method/svc/errors/inserr.i
                        &ErrorNumber=c-num-error
                        &ErrorType=c-tp-error
                        &ErrorSubType=c-des-error
                        &ErrorParameters=c-param-error}.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaCodEspec DBOProgram 
PROCEDURE validaCodEspec :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DEF INPUT PARAMETER p-c-cod-espec LIKE espec-ap.cod-esp NO-UNDO.
    
    FIND FIRST espec-ap WHERE espec-ap.cod-esp = p-c-cod-espec NO-LOCK NO-ERROR.

    IF  NOT AVAIL(espec-ap) THEN DO:
        /* Inicio -- Projeto Internacional */
        {utp/ut-table.i mgadm espec-ap 1} /* Busca o label da tabela */
        {method/svc/errors/inserr.i
                        &ErrorNumber="2"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters=TRIM(RETURN-VALUE)}
        RETURN "NOK":U.
    END.
    ELSE 
        RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaNumImptoRetid DBOProgram 
PROCEDURE validaNumImptoRetid :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DEF INPUT PARAMETER p-i-num-impto-retid AS INTEGER NO-UNDO.

    IF p-i-num-impto-retid        < 1 OR p-i-num-impto-retid        > 2 THEN DO:  
        {utp/ut-liter.i "atributo_Sequencia_Primeiro_Item" *}
        {method/svc/errors/inserr.i &ErrorNumber="18733"  &ErrorType="EMS"  &ErrorSubType="ERROR"  &ErrorParameters="RETURN-VALUE + ' (firstItemSequence)~~~~' + '1 <-> 99999'"}
    END.
    
    FIND FIRST tipo-tax WHERE tipo-tax.cod-tax = p-i-num-impto-retid NO-LOCK NO-ERROR.

    IF  NOT AVAIL(tipo-tax) THEN DO:
        /* Inicio -- Projeto Internacional */
        {utp/ut-table.i mgdis tipo-tax 1} /* Busca o label da tabela */
        {method/svc/errors/inserr.i
                        &ErrorNumber="2"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters=TRIM(RETURN-VALUE)}
        RETURN "NOK":U.
    END.
    ELSE
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

    DEFINE VARIABLE lAlterarNFSe AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE lAlterarCTe  AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE l-colab-ativo AS LOGICAL     NO-UNDO.

    IF pType = "Update":U OR pType = "Create":U THEN DO:
        IF INT(SUBSTRING(RowObject.cod-livre-2,2,1)) = 1 THEN
            RUN validarImpostoClassificRetencao IN THIS-PROCEDURE.
    END.

    IF RowObject.idi-gera-dupl-nfe < 1 OR RowObject.idi-gera-dupl-nfe > 2 THEN DO:  /* consigReceiptValuation */
        {utp/ut-liter.i "atributo_Gera_Duplicada_NFe" *}
        {method/svc/errors/inserr.i &ErrorNumber="18733"  &ErrorType="EMS"  &ErrorSubType="ERROR"  &ErrorParameters="RETURN-VALUE + ' (duplicateGenerationAccordingTo)~~~~' + '1;2'"}
    END.

    IF RowObject.idi-recebe-tag-x-ped < 1 OR RowObject.idi-recebe-tag-x-ped > 2 THEN DO:  /* consigReceiptValuation */
        {utp/ut-liter.i "atributo_Recebe_Tag_xPed" *}
        {method/svc/errors/inserr.i &ErrorNumber="18733"  &ErrorType="EMS"  &ErrorSubType="ERROR"  &ErrorParameters="RETURN-VALUE + ' (receiveAtTAGxPedNFe)~~~~' + '1;2'"}
    END.

    RUN cdp/cd0029a.p (OUTPUT l-colab-ativo).
    IF l-colab-ativo AND (SUBSTRING(RowObject.cod-livre-2,2,1) < "1" OR SUBSTRING(RowObject.cod-livre-2,2,1) > "2") THEN DO:  /* consigReceiptValuation */
        {utp/ut-liter.i "atributo_Gera_Imposto_NFSe" *}
        {method/svc/errors/inserr.i &ErrorNumber="18733"  &ErrorType="EMS"  &ErrorSubType="ERROR"  &ErrorParameters="RETURN-VALUE + ' (generationOfTaxesAccordingTo)~~~~' + '1;2'"}
    END.

    IF  RowObject.cod-servid-rpw <> ""    /* cod-rpw */
    AND NOT CAN-FIND (FIRST servid_exec 
                      WHERE servid_exec.cod_servid_exec = RowObject.cod-servid-rpw) THEN DO:
        /* 41538 - Servidor de Execuá∆o "&1" inexistente.*/
        {method/svc/errors/inserr.i &ErrorNumber = "41538" &ErrorType="EMS"  &ErrorSubType="ERROR"  &ErrorParameters="RowObject.cod-servid-rpw"}
    END.

    IF pType = "Update":U THEN DO:
            
        IF NOT RowObject.log-livre-1 THEN DO:
            RUN podeAlterarCTe IN THIS-PROCEDURE (OUTPUT lAlterarCTe).
            IF lAlterarCTe = NO THEN DO:
                {method/svc/errors/inserr.i
                    &ErrorNumber="56905"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"}
            END.
        END.
    
        IF NOT RowObject.log-livre-2 AND l-colab-ativo THEN DO:
            RUN podeAlterarNFSe IN THIS-PROCEDURE (OUTPUT lAlterarNFSe).
            IF lAlterarNFSe = NO THEN DO:
                {method/svc/errors/inserr.i
                    &ErrorNumber="56906"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"}
            END.
        END.
    
    END.
    
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDirConversor DBOProgram 
PROCEDURE getDirConversor :
/*------------------------------------------------------------------------------
  Purpose: Retornar diretorio para importacao documentos conversor NF-e     
  Parameters:  <none>
  Notes: Colaboracao ativo, busca diretorio do CD0360A
         Colaboracao NAO ativo, busca diretorio do RE0119
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pDirConversor AS CHAR INIT "" NO-UNDO.

    DEFINE VARIABLE l-colab-ativo AS LOG NO-UNDO.
    RUN cdp/cd0029a.p (OUTPUT l-colab-ativo).

    IF l-colab-ativo THEN DO: /* Colaboracao ativo, busca diretorio do CD0360A */
        
        IF CAN-FIND (FIRST funcao                               
        	     WHERE funcao.cd-funcao = "SPP-XML-OPSYS-TC2" 
                       AND funcao.ativo) 
    	AND OPSYS <> "WIN32" THEN DO:  
            FOR FIRST param-gener 
                WHERE param-gener.cod-chave-1 = "param-geral-tc":U
                AND param-gener.cod-param   = "dir-recepcao-docto-outro-so":U NO-LOCK:
                ASSIGN pDirConversor = REPLACE(param-gener.cod-valor, "~\", "/").
                IF pDirConversor = "" OR pDirConversor = ? THEN
                    RETURN "NOK":U.
                ELSE
                    RETURN "OK":U.
            END.
        END.
        ELSE DO:
            FOR FIRST param-gener 
                WHERE param-gener.cod-chave-1 = "param-geral-tc":U
                AND param-gener.cod-param   = "dir-recepcao-docto":U NO-LOCK:
                ASSIGN pDirConversor = REPLACE(param-gener.cod-valor, "~\", "/").
                IF pDirConversor = "" OR pDirConversor = ? THEN
                    RETURN "NOK":U.
                ELSE
                    RETURN "OK":U.
            END.
        END.
       
    END.
    ELSE DO:  /* Colaboracao NAO ativo, busca diretorio do RE0119 */
        FOR FIRST param-convrsr-nfe NO-LOCK:
            ASSIGN pDirConversor = REPLACE(TRIM(SUBSTRING(param-convrsr-nfe.cod-livre-1,1, 100)), "~\", "/").
            IF pDirConversor = "" OR pDirConversor = ? THEN
                RETURN "NOK":U.
            ELSE
                RETURN "OK":U.
        END.
    END.

    RETURN "NOK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaNumImptoRetid DBOProgram 
PROCEDURE validaCodImptoClassificRetid :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DEF INPUT PARAMETER p-cod-imposto-impto-retid AS CHARACTER NO-UNDO.
    DEF INPUT PARAMETER p-cod-classif-impto-retid AS CHARACTER NO-UNDO.
    DEFINE VARIABLE h-dbo-classif-impto AS HANDLE NO-UNDO.

    DEFINE VARIABLE c-pais                  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-estado                AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-lbl-liter-Imposto     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-lbl-liter-Impostos    AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-lbl-liter-UF          AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-lbl-liter-e-Imposto   AS CHARACTER   NO-UNDO.


    ASSIGN c-pais   = "BRA":U
           c-estado = "".
    
    /*verifica se a classificaá∆o do imposto tela pertence a esta*/
    IF NOT VALID-HANDLE(h-dbo-classif-impto) THEN
      RUN prgint/utb/utb944wc.py PERSISTENT SET h-dbo-classif-impto NO-ERROR.
    
    IF  VALID-HANDLE(h-dbo-classif-impto) THEN DO:
      /*--- monta a query para pesquisar se o imposto informado em tela existe no EMS5 ---*/
      RUN setQueryWhere IN h-dbo-classif-impto ("classif_impto.cod_imposto = '":U            + p-cod-imposto-impto-retid   + "'":U +
                                                " and classif_impto.cod_classif_impto = '":U + p-cod-classif-impto-retid   + "'":U + 
                                                " and classif_impto.cod_pais = '":U          + STRING(c-pais)              + "'":U +        
                                                " and classif_impto.cod_unid_federac = '":U  + STRING(c-estado)            + "'":U ).  
      /*--- abre a query dinamica e posiciona no primeiro registro ---*/
      RUN openQueryDynamic IN h-dbo-classif-impto.
      RUN getFirst IN h-dbo-classif-impto.
      
      IF RETURN-VALUE = "NOK" THEN DO:
        
        {utp/ut-liter.i "Classificaá∆o_de_Imposto" *}
        ASSIGN c-lbl-liter-Imposto = TRIM(RETURN-VALUE).

        {utp/ut-liter.i "Unidade_da_Federaá∆o" *}
        ASSIGN c-lbl-liter-UF = TRIM(RETURN-VALUE).

        {utp/ut-liter.i "E_Imposto" *}
        ASSIGN c-lbl-liter-e-Imposto = TRIM(RETURN-VALUE).
      
        {utp/ut-liter.i "Classificaá∆o_de_Impostos_com_Pa°s: " *}
        ASSIGN c-lbl-liter-Impostos = TRIM(RETURN-VALUE)            + " "   + STRING(c-pais)
                                    + ", " + c-lbl-liter-UF         + " "   + STRING(c-estado)
                                    + " "  + c-lbl-liter-e-Imposto  + ": "  + p-cod-imposto-impto-retid.
        
        {method/svc/errors/inserr.i
             &ErrorNumber="4704"
             &ErrorType="EMS"
             &ErrorSubType="ERROR"
             &ErrorParameters="c-lbl-liter-Imposto + '~~~~' + c-lbl-liter-Impostos"}
      END.        
    END.

    DELETE PROCEDURE h-dbo-classif-impto NO-ERROR.
    ASSIGN h-dbo-classif-impto = ? NO-ERROR.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validarImpostoClassificRetencao DBOProgram 
PROCEDURE validarImpostoClassificRetencao:
    DEFINE VARIABLE c-cod-espec-pis             AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-cod-espec-cofins          AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-cod-espec-irrf            AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-cod-espec-csll            AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-cod-espec-inss            AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-cod-espec-iss             AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-cod-impto-retid-pis       AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-cod-impto-retid-cofins    AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-cod-impto-retid-irrf      AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-cod-impto-retid-csll      AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-cod-impto-retid-inss      AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-cod-impto-retid-iss       AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-cod-retenc-pis            AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-cod-retenc-cofins         AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-cod-retenc-irrf           AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-cod-retenc-csll           AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-cod-retenc-inss           AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-cod-retenc-iss            AS CHARACTER   NO-UNDO.

    ASSIGN c-cod-impto-retid-pis     = SUBSTRING(RowObject.cod-livre-2,3,8)     
           c-cod-impto-retid-cofins  = SUBSTRING(RowObject.cod-livre-2,11,8)    
           c-cod-impto-retid-irrf    = SUBSTRING(RowObject.cod-livre-2,19,8)    
           c-cod-impto-retid-csll    = SUBSTRING(RowObject.cod-livre-2,27,8)    
           c-cod-impto-retid-inss    = SUBSTRING(RowObject.cod-livre-2,35,8)    
           c-cod-impto-retid-iss     = SUBSTRING(RowObject.cod-livre-2,43,8)    
           c-cod-espec-pis           = SUBSTRING(RowObject.cod-livre-2,51,2)    
           c-cod-espec-cofins        = SUBSTRING(RowObject.cod-livre-2,53,2)    
           c-cod-espec-irrf          = SUBSTRING(RowObject.cod-livre-2,55,2)    
           c-cod-espec-csll          = SUBSTRING(RowObject.cod-livre-2,57,2)    
           c-cod-espec-inss          = SUBSTRING(RowObject.cod-livre-2,59,2)    
           c-cod-espec-iss           = SUBSTRING(RowObject.cod-livre-2,61,2)    
           c-cod-retenc-pis          = SUBSTRING(RowObject.cod-livre-2,64,8)    
           c-cod-retenc-cofins       = SUBSTRING(RowObject.cod-livre-2,72,8)    
           c-cod-retenc-irrf         = SUBSTRING(RowObject.cod-livre-2,80,8)    
           c-cod-retenc-csll         = SUBSTRING(RowObject.cod-livre-2,88,8)    
           c-cod-retenc-inss         = SUBSTRING(RowObject.cod-livre-2,96,8)    
           c-cod-retenc-iss          = SUBSTRING(RowObject.cod-livre-2,104,8).

    
    RUN validaCodEspec IN THIS-PROCEDURE (INPUT c-cod-espec-pis).    
    
    RUN validaCodEspec IN THIS-PROCEDURE (INPUT c-cod-espec-cofins).
    
    RUN validaCodEspec IN THIS-PROCEDURE (INPUT c-cod-espec-irrf).
    
    RUN validaCodEspec IN THIS-PROCEDURE (INPUT c-cod-espec-csll).
    
    RUN validaCodEspec IN THIS-PROCEDURE (INPUT c-cod-espec-inss).
    
    RUN validaCodEspec IN THIS-PROCEDURE (INPUT c-cod-espec-iss).

    RUN validaCodImptoClassificRetid IN THIS-PROCEDURE (INPUT c-cod-impto-retid-pis,
                                                        INPUT c-cod-retenc-pis).

    RUN validaCodImptoClassificRetid IN THIS-PROCEDURE (INPUT c-cod-impto-retid-cofins,
                                                        INPUT c-cod-retenc-cofins).

    RUN validaCodImptoClassificRetid IN THIS-PROCEDURE (INPUT c-cod-impto-retid-irrf,
                                                        INPUT c-cod-retenc-irrf).

    RUN validaCodImptoClassificRetid IN THIS-PROCEDURE (INPUT c-cod-impto-retid-csll,
                                                        INPUT c-cod-retenc-csll).

    RUN validaCodImptoClassificRetid IN THIS-PROCEDURE (INPUT c-cod-impto-retid-inss,
                                                        INPUT c-cod-retenc-inss).

    RUN validaCodImptoClassificRetid IN THIS-PROCEDURE (INPUT c-cod-impto-retid-iss,  
                                                        INPUT c-cod-retenc-iss).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE podeAlterarCTe DBOProgram 
PROCEDURE podeAlterarCTe:
    DEFINE OUTPUT PARAMETER lPode   AS LOGICAL NO-UNDO.
    
    ASSIGN lPode = YES.

    FOR FIRST bf-param-convrsr-nfe NO-LOCK:
    END.

    IF AVAIL bf-param-convrsr-nfe AND param-convrsr-nfe.log-livre-1 THEN DO:
        IF  NOT VALID-HANDLE(h-boin871) THEN DO:
            IF NOT VALID-HANDLE(h-boin871)
                OR h-boin871:TYPE      <> "PROCEDURE":U
                OR h-boin871:FILE-NAME <> "inbo/boin871.p":U THEN
                RUN inbo/boin871.p PERSISTENT SET h-boin871.
        END.
            
        IF VALID-HANDLE(h-boin871) THEN DO:
            RUN getParamCte IN h-boin871.
            IF  RETURN-VALUE = "NOK":U THEN DO:
    
                ASSIGN lPode = NO.
            END.
            
            DELETE PROCEDURE h-boin871.
            ASSIGN h-boin871 = ?.
        END.
    END.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE podeAlterarNFSe DBOProgram 
PROCEDURE podeAlterarNFSe:
    DEFINE OUTPUT PARAMETER lPode   AS LOGICAL NO-UNDO.

    DEFINE VARIABLE i-qtd-sit-pendent   AS INTEGER      NO-UNDO.
    
    FOR FIRST bf-param-convrsr-nfe NO-LOCK:
    END.
    ASSIGN lPode = yes.
    
    IF AVAIL bf-param-convrsr-nfe AND bf-param-convrsr-nfe.log-livre-2 THEN DO:
       
        IF  NOT VALID-HANDLE(h-boin874) /* BO da tabela docto-orig-nfse */
            OR h-boin874:TYPE      <> "PROCEDURE":U
            OR h-boin874:FILE-NAME <> "inbo/boin874.p":U THEN DO:
            RUN inbo/boin874.p PERSISTENT SET h-boin874.
            RUN openQueryStatic IN h-boin874 (INPUT "Main":U) NO-ERROR.
        END.
            
        IF VALID-HANDLE(h-boin874) THEN DO:
            RUN setConstraintSituacao IN h-boin874 (INPUT 2,  /* Verifica se existe NFS-e's com situaá∆o */
                                                    INPUT 2). /* igual a 2 - Nota com erro de neg¢cio. */
            RUN openQueryStatic IN h-boin874 (INPUT "Situacao":U) NO-ERROR.
            RUN getBatchRecords IN h-boin874 (INPUT ?,
                                              INPUT NO,
                                              INPUT 1, /* retorna somente 1 registro */
                                              OUTPUT i-qtd-sit-pendent,
                                              OUTPUT TABLE tt-docto-orig-nfse-aux).
            
            IF  i-qtd-sit-pendent > 0 THEN DO: /* se tem NFS-e "Com erro de neg¢cio" n∆o deixa alterar */
                ASSIGN lPode = NO.
            END.
            DELETE PROCEDURE h-boin874.
            ASSIGN h-boin874 = ?.
        END.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
