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
&GLOBAL-DEFINE DBOName BOIN879
&GLOBAL-DEFINE DBOVersion 1.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName estab-ctas-impto
&GLOBAL-DEFINE TableLabel Contas Impostos Estabelecimento
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
{inbo/boin879.i RowObject}
{inbo/boin879.i tt-estab-ctas-impto}
{adbo/boad107.i tt-estabelec-1}
{cep/ce0407b.i} /* tt-estabelec */

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

define variable c-cod-estab      like estab-ctas-impto.cod-estab  no-undo.
define variable i-num-impto      like estab-ctas-impto.num-impto  no-undo.
define variable dt-dat-inic-valid like estab-ctas-impto.dat-inic-valid no-undo.
define variable dt-dat-fim-valid  like estab-ctas-impto.dat-fim-valid no-undo.

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

 
&IF DEFINED(EXCLUDE-atualizaContaByEstab-ctas-impto) = 0 &THEN
		
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaContaByEstab-ctas-impto Procedure
PROCEDURE atualizaContaByEstab-ctas-impto:

/*------------------------------------------------------------------------------
Purpose: Atualiza conta Estabelec se a data atual estiver incluida no periodo																	  
Notes:  																	  
------------------------------------------------------------------------------*/
    DEF INPUT PARAM pcod-estab LIKE RowObject.cod-estab.
    DEF INPUT PARAM pnum-impto LIKE RowObject.num-impto.
    DEF INPUT PARAM pconta-imposto LIKE RowObject.conta-imposto.
    DEF INPUT PARAM pcod-ccusto-impto LIKE RowObject.cod-ccusto-impto.


    FIND FIRST estabelec WHERE estabelec.cod-estabel = pcod-estab EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL estabelec THEN DO:
        
        CASE pnum-impto :
            WHEN 1 THEN
                ASSIGN estabelec.ct-icm = pconta-imposto
                       estabelec.sc-icm = pcod-ccusto-impto. 
            
            WHEN 2 THEN 
                ASSIGN estabelec.ct-ipi = pconta-imposto
                       estabelec.sc-ipi = pcod-ccusto-impto. 
             
            WHEN 3 THEN
                ASSIGN estabelec.cod-cta-pis-recup    = pconta-imposto
                       estabelec.cod-ccusto-pis-recup = pcod-ccusto-impto. 
            
            WHEN 4 THEN 
                ASSIGN estabelec.cod-cta-cofins-recup = pconta-imposto
                       estabelec.cod-ccusto-cofins-recup = pcod-ccusto-impto.  
        END CASE.  
        RETURN "OK".  
        
    END.
    ELSE
        RETURN "NOK".   
        
END PROCEDURE.
	
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cria-primeiro-estab-ctas-impto DBOProgram 
PROCEDURE cria-primeiro-estab-ctas-impto :
/*------------------------------------------------------------------------------
  Purpose:     Cria os registros base para o estabelecimento caso n∆o exista ainda
  Parameters:  
               recebe rowid do estabelecimento
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER prowid as rowid NO-UNDO.

    find first estabelec where rowid(estabelec) = prowid exclusive-lock no-error.
 
    assign estabelec.log-livre-1 = yes.
    
    find first estab-ctas-impto where estab-ctas-impto.cod-estab = estabelec.cod-estabel no-lock no-error.

    if not avail estab-ctas-impto then do:
        create estab-ctas-impto.
        assign estab-ctas-impto.cod-estab = estabelec.cod-estabel
               estab-ctas-impto.num-impto = 01
               estab-ctas-impto.dat-inic-valid = 01/01/1800
               estab-ctas-impto.dat-fim-valid = 12/30/9999
               estab-ctas-impto.conta-imposto = estabelec.ct-icm
               estab-ctas-impto.cod-ccusto-impto = estabelec.sc-icm.
               
        create estab-ctas-impto.
        assign estab-ctas-impto.cod-estab = estabelec.cod-estabel
               estab-ctas-impto.num-impto = 02
               estab-ctas-impto.dat-inic-valid = 01/01/1800
               estab-ctas-impto.dat-fim-valid = 12/30/9999
               estab-ctas-impto.conta-imposto = estabelec.ct-ipi
               estab-ctas-impto.cod-ccusto-impto = estabelec.sc-ipi.
               
        create estab-ctas-impto.
        assign estab-ctas-impto.cod-estab = estabelec.cod-estabel
               estab-ctas-impto.num-impto = 03
               estab-ctas-impto.dat-inic-valid = 01/01/1800
               estab-ctas-impto.dat-fim-valid = 12/30/9999
               estab-ctas-impto.conta-imposto = estabelec.cod-cta-pis-recup
               estab-ctas-impto.cod-ccusto-impto = estabelec.cod-ccusto-pis-recup.
               
        create estab-ctas-impto.
        assign estab-ctas-impto.cod-estab = estabelec.cod-estabel
               estab-ctas-impto.num-impto = 04
               estab-ctas-impto.dat-inic-valid = 01/01/1800
               estab-ctas-impto.dat-fim-valid = 12/30/9999
               estab-ctas-impto.conta-imposto = estabelec.cod-cta-cofins-recup
               estab-ctas-impto.cod-ccusto-impto = estabelec.cod-ccusto-cofins-recup.
    end.
    
    return "OK":U.

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
        WHEN "cod-ccusto-impto":U THEN ASSIGN pFieldValue = RowObject.cod-ccusto-impto.
        WHEN "cod-estab":U THEN ASSIGN pFieldValue = RowObject.cod-estab.
        WHEN "conta-imposto":U THEN ASSIGN pFieldValue = RowObject.conta-imposto.
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
        WHEN "dat-fim-valid":U THEN ASSIGN pFieldValue = RowObject.dat-fim-valid.
        WHEN "dat-inic-valid":U THEN ASSIGN pFieldValue = RowObject.dat-inic-valid.
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
        WHEN "num-impto":U THEN ASSIGN pFieldValue = RowObject.num-impto.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice estab-ctas-id
  Parameters:  
               retorna valor do campo cod-estab
               retorna valor do campo num-impto
               retorna valor do campo dat-inic-valid
               retorna valor do campo dat-fim-valid
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estab LIKE estab-ctas-impto.cod-estab NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-impto LIKE estab-ctas-impto.num-impto NO-UNDO.
    DEFINE OUTPUT PARAMETER pdat-inic-valid LIKE estab-ctas-impto.dat-inic-valid NO-UNDO.
    DEFINE OUTPUT PARAMETER pdat-fim-valid LIKE estab-ctas-impto.dat-fim-valid NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-estab = RowObject.cod-estab
           pnum-impto = RowObject.num-impto
           pdat-inic-valid = RowObject.dat-inic-valid
           pdat-fim-valid = RowObject.dat-fim-valid.

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
  Purpose:     Reposiciona registro com base no °ndice estab-ctas-id
  Parameters:  
               recebe valor do campo cod-estab
               recebe valor do campo num-impto
               recebe valor do campo dat-inic-valid
               recebe valor do campo dat-fim-valid
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estab LIKE estab-ctas-impto.cod-estab NO-UNDO.
    DEFINE INPUT PARAMETER pnum-impto LIKE estab-ctas-impto.num-impto NO-UNDO.
    DEFINE INPUT PARAMETER pdat-inic-valid LIKE estab-ctas-impto.dat-inic-valid NO-UNDO.
    DEFINE INPUT PARAMETER pdat-fim-valid LIKE estab-ctas-impto.dat-fim-valid NO-UNDO.

    FIND FIRST bfestab-ctas-impto WHERE 
        bfestab-ctas-impto.cod-estab = pcod-estab AND 
        bfestab-ctas-impto.num-impto = pnum-impto AND 
        bfestab-ctas-impto.dat-inic-valid = pdat-inic-valid AND 
        bfestab-ctas-impto.dat-fim-valid = pdat-fim-valid NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfestab-ctas-impto THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfestab-ctas-impto)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKeyCustom DBOProgram 
PROCEDURE goToKeyCustom :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro valido para a data
  Parameters:  
               recebe valor do campo cod-estab
               recebe valor do campo num-impto
               recebe valor do campo dt-valid
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estab LIKE estab-ctas-impto.cod-estab NO-UNDO.
    DEFINE INPUT PARAMETER pnum-impto LIKE estab-ctas-impto.num-impto NO-UNDO.
    DEFINE INPUT PARAMETER pdt-valid as date NO-UNDO.
    
    FIND FIRST bfestab-ctas-impto WHERE 
        bfestab-ctas-impto.cod-estab = pcod-estab AND 
        bfestab-ctas-impto.num-impto = pnum-impto AND 
        bfestab-ctas-impto.dat-inic-valid <= pdt-valid AND 
        bfestab-ctas-impto.dat-fim-valid >= pdt-valid NO-LOCK NO-ERROR.
        
    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfestab-ctas-impto THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfestab-ctas-impto)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToEstabelec DBOProgram 
PROCEDURE linkToEstabelec :
/*---------------------------------------------------------------
  Purpose:     
  Parameters:  recebe handle de um DBO
  Notes:       
----------------------------------------------------------------*/
   DEFINE INPUT PARAMETER pHandle AS HANDLE NO-UNDO.
   
   define variable ccod-estab like estab-ctas-impto.cod-estab  no-undo.
   
   RUN getKey IN pHandle (OUTPUT ccod-estab).
   
   RUN setConstraintByEstab IN THIS-PROCEDURE (INPUT ccod-estab).

   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryByEstab DBOProgram 
PROCEDURE OpenQueryByEstab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
      WHERE {&TableName}.cod-estab   = c-cod-estab 
      AND   {&TableName}.num-impto   <= 7
        BY {&TableName}.dat-fim-valid
        BY {&TableName}.dat-inic-valid
        BY {&TableName}.num-impto INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintEstab DBOProgram 
PROCEDURE setConstraintByEstab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM pcod-estab   LIKE estab-ctas-impto.cod-estab.
   
    ASSIGN  c-cod-estab   = pcod-estab.
    
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
    DEFINE VARIABLE c-erro AS CHARACTER NO-UNDO.

        
    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/
    /* --- Validaá∆o da Data Inicial em relaá∆o a Final ---*/
    
    IF pType = "Create":U THEN DO:
        
      find first bfestab-ctas-impto no-lock
             where bfestab-ctas-impto.cod-estab        = RowObject.cod-estab
               and bfestab-ctas-impto.num-impto        = RowObject.num-impto
               and bfestab-ctas-impto.dat-inic-valid   = RowObject.dat-inic-valid 
               and bfestab-ctas-impto.dat-fim-valid    = RowObject.dat-fim-valid  no-error.  
               
      if avail  bfestab-ctas-impto then do:        
        {utp/ut-liter.i Faixa_de_datas_existente_para_o_estabelecimento_x_imposto_informado}
        assign c-erro = return-value.
        
        {method/svc/errors/inserr.i &ErrorNumber="17006"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters=c-erro}
       end.             
    end.   
    
    IF pType = "Create":U OR pType = "Update":U THEN DO:
        if RowObject.dat-inic-valid > RowObject.dat-fim-valid then do:
            
            {method/svc/errors/inserr.i &ErrorNumber="198"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"}
        end.

             
        for each bfestab-ctas-impto no-lock
             where bfestab-ctas-impto.cod-estab = RowObject.cod-estab
               and bfestab-ctas-impto.num-impto = RowObject.num-impto
               and rowid(bfestab-ctas-impto) <> RowObject.r-rowid:      
        
            
            if  bfestab-ctas-impto.dat-fim-valid  >= (RowObject.dat-inic-valid + 1)
            and bfestab-ctas-impto.dat-inic-valid <= (RowObject.dat-fim-valid - 1) then do:
                
              {utp/ut-liter.i Faixa_de_datas_inv†lida_para_o_estabelecimento_x_imposto_informado}
              assign c-erro = return-value.
        
              {method/svc/errors/inserr.i &ErrorNumber="17006"
                                          &ErrorType="EMS"
                                          &ErrorSubType="ERROR"
                                          &ErrorParameters=c-erro}  
                                          
              leave.                        
                                          
            end.    
        end.   
        
    end.        

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-lacuna-periodos DBOProgram 
PROCEDURE valida-lacuna-periodos :
/*:T------------------------------------------------------------------------------
  Purpose:     Validaá∆o de lacunas entre per°odos
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM pcod-estab LIKE RowObject.cod-estab.
    DEF INPUT PARAM pnum-impto LIKE RowObject.num-impto.
    DEF INPUT PARAM pdat-inic-valid LIKE RowObject.dat-inic-valid.
    DEF INPUT PARAM pdat-fim-valid LIKE RowObject.dat-fim-valid.
    DEF OUTPUT PARAM pc-msg AS CHARACTER NO-UNDO. 
    
    DEFINE VARIABLE c-e AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-lacuna AS CHARACTER NO-UNDO.
    
    {utp/ut-liter.i _e_ *}
    ASSIGN c-e = RETURN-VALUE.   
    {utp/ut-liter.i Existe_uma_lacuna_entre_os_per°odos_ *} 
    ASSIGN c-lacuna = RETURN-VALUE.  
    
    
    /* --- Validaá∆o de lacunas entre per°odos ---*/
    find last bfestab-ctas-impto no-lock
         where bfestab-ctas-impto.cod-estab  = pcod-estab 
           and bfestab-ctas-impto.num-impto  = pnum-impto 
           and bfestab-ctas-impto.dat-fim-valid < pdat-inic-valid
         no-error.
    if avail bfestab-ctas-impto and
       bfestab-ctas-impto.dat-fim-valid <> (pdat-inic-valid - 1) then do:          
       
        ASSIGN pc-msg = c-lacuna + STRING(bfestab-ctas-impto.dat-fim-valid)  + c-e + STRING(pdat-inic-valid).
        RETURN "NOK":U.
    end.

    find first bfestab-ctas-impto no-lock
         where bfestab-ctas-impto.cod-estab  = pcod-estab 
           and bfestab-ctas-impto.num-impto  = pnum-impto 
           and bfestab-ctas-impto.dat-inic-valid > pdat-fim-valid
         no-error.
    if avail bfestab-ctas-impto and
       bfestab-ctas-impto.dat-inic-valid <> (pdat-fim-valid + 1) then do:
        ASSIGN pc-msg = c-lacuna + STRING(pdat-fim-valid) + c-e + STRING(bfestab-ctas-impto.dat-inic-valid).
        RETURN "NOK":U.
    end.
 
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE busca-ctas-impto DBOProgram 
PROCEDURE busca-ctas-impto :
/*:T------------------------------------------------------------------------------
  Purpose:     busca as contas de impostos parametrizadas para o estabelecimento e data da transaá∆o
  Parameters:  recebe a data da transaá∆o e a tabela temporaria do estabelecimento
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM pdt-trans   LIKE movto-estoq.dt-trans NO-UNDO.
    DEF INPUT-OUTPUT PARAM TABLE FOR tt-estabelec-1.  

    FIND FIRST tt-estabelec-1 NO-ERROR.
       
    FOR EACH bfestab-ctas-impto
       WHERE bfestab-ctas-impto.cod-estab = tt-estabelec-1.cod-estabel
       AND   bfestab-ctas-impto.dat-inic-valid <= pdt-trans
       AND   bfestab-ctas-impto.dat-fim-valid  >= pdt-trans NO-LOCK:
    
       CASE bfestab-ctas-impto.num-impto:
            WHEN 1 THEN             
                ASSIGN tt-estabelec-1.ct-icm = bfestab-ctas-impto.conta-imposto
                       tt-estabelec-1.sc-icm = bfestab-ctas-impto.cod-ccusto-impto.
                
            WHEN 2 THEN
                ASSIGN tt-estabelec-1.ct-ipi = bfestab-ctas-impto.conta-imposto
                       tt-estabelec-1.sc-ipi = bfestab-ctas-impto.cod-ccusto-impto.
                     
                      
            WHEN 3 THEN 
                ASSIGN tt-estabelec-1.cod-cta-pis-recup    = bfestab-ctas-impto.conta-imposto
                       tt-estabelec-1.cod-ccusto-pis-recup = bfestab-ctas-impto.cod-ccusto-impto.                    
                       
            WHEN 4 THEN 
                ASSIGN tt-estabelec-1.cod-cta-cofins-recup    = bfestab-ctas-impto.conta-imposto
                       tt-estabelec-1.cod-ccusto-cofins-recup = bfestab-ctas-impto.cod-ccusto-impto.  
       END.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE busca-ctas-impto-simpl-nac DBOProgram 
PROCEDURE busca-ctas-impto-simpl-nac :
/*:T------------------------------------------------------------------------------
  Purpose:     busca as contas de simples nacional parametrizadas para o estabelecimento e 
  Parameters:  data da transaá∆o recebe a data da transaá∆o e o estabelecimento
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM pdt-trans           LIKE movto-estoq.dt-trans              NO-UNDO.
    DEF INPUT  PARAM pcod-estabel        LIKE estab-ctas-impto.cod-estab        NO-UNDO.  
    DEF OUTPUT PARAM pcta-simples-nac    LIKE estab-ctas-impto.conta-imposto    NO-UNDO.
    DEF OUTPUT PARAM pccusto-simples-nac LIKE estab-ctas-impto.cod-ccusto-impto NO-UNDO.

    FOR EACH bfestab-ctas-impto
       WHERE bfestab-ctas-impto.cod-estab       = pcod-estabel
         AND bfestab-ctas-impto.dat-inic-valid <= pdt-trans
         AND bfestab-ctas-impto.dat-fim-valid  >= pdt-trans
         AND bfestab-ctas-impto.num-impto       = 5   NO-LOCK:
        ASSIGN pcta-simples-nac    = bfestab-ctas-impto.conta-imposto
               pccusto-simples-nac = bfestab-ctas-impto.cod-ccusto-impto.  
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE busca-ctas-impto-sumario DBOProgram 
PROCEDURE busca-ctas-impto-sumario :
/*:T------------------------------------------------------------------------------
  Purpose:     busca as contas de impostos parametrizadas para o estabelecimento e data da transaá∆o
  Parameters:  recebe a data inicial do per°odo, data final do per°odo, 
               c¢digo do estabelecimento e retorna a tabela temporaria do estabelecimento
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM pdt-ini   LIKE movto-estoq.dt-trans NO-UNDO.
    DEF INPUT PARAM pdt-fim   LIKE movto-estoq.dt-trans NO-UNDO.
    DEF INPUT PARAM c-cod-estabel LIKE estab-ctas-impto.cod-estab NO-UNDO.
    DEF OUTPUT PARAM TABLE FOR tt-estabelec. 

    EMPTY TEMP-TABLE tt-estabelec NO-ERROR.   
	
	
	/*************************************************************************************************/
	/*	Exemplo de uso da lÛgica de busca das contas que compor„o a tt-estabelec                     */
	/*                                                                                               */
	/*	Registros na estab-ctas-impto:                                                               */
	/*	conta ICMS Antiga - dat-inic-valid(01/12)  -> dat-fim-valid(15/12)                           */
	/*	conta ICMS Nova   - dat-inic-valid(16/12) -> dat-fim-valid(30/12)                            */
	/*                                                                                               */
	/*	ex: pdt-ini = 05/12                                                                          */
	/*      pdt-fim = 20/12                                                                          */
	/*	                                                                                             */
	/*	Busca contas onde                                                                            */
	/* 	 dat-inic-valid <= pdt-fim (01/12 <=  20/12)                                                 */
    /*    e dat-fim-valid  >= pdt-ini (30/12 >= 05/12)                                               */
	/*                                                                                               */
	/*	Neste exemplo, ambas as contas de ICMS ir„o para a tt-estabelec. No momento de utilizaÁ„o    */
	/*	ser· usada uma ou outra, dependendo da data do movimento em quest„o                          */
	/* ********************************************************************************************* */
	
    FOR EACH bfestab-ctas-impto
       WHERE bfestab-ctas-impto.cod-estab = c-cod-estabel
         AND bfestab-ctas-impto.dat-inic-valid <= pdt-fim
         AND bfestab-ctas-impto.dat-fim-valid  >= pdt-ini NO-LOCK: 		 
             
        CREATE tt-estabelec.
        ASSIGN tt-estabelec.cod-estabel    = bfestab-ctas-impto.cod-estab
               tt-estabelec.dat-inic-valid = bfestab-ctas-impto.dat-inic-valid
               tt-estabelec.dat-fim-valid  = bfestab-ctas-impto.dat-fim-valid
               tt-estabelec.num-impto      = bfestab-ctas-impto.num-impto.
    
       CASE bfestab-ctas-impto.num-impto:
            WHEN 1 THEN             
                ASSIGN tt-estabelec.ct-icm = bfestab-ctas-impto.conta-imposto
                       tt-estabelec.sc-icm = bfestab-ctas-impto.cod-ccusto-impto.
                
            WHEN 2 THEN
                ASSIGN tt-estabelec.ct-ipi = bfestab-ctas-impto.conta-imposto
                       tt-estabelec.sc-ipi = bfestab-ctas-impto.cod-ccusto-impto.                     
                      
            WHEN 3 THEN 
                ASSIGN tt-estabelec.cod-cta-pis-recup    = bfestab-ctas-impto.conta-imposto
                       tt-estabelec.cod-ccusto-pis-recup = bfestab-ctas-impto.cod-ccusto-impto.                    
                       
            WHEN 4 THEN 
                ASSIGN tt-estabelec.cod-cta-cofins-recup    = bfestab-ctas-impto.conta-imposto
                       tt-estabelec.cod-ccusto-cofins-recup = bfestab-ctas-impto.cod-ccusto-impto.  
       END.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
/*
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE busca-ctas-impto-var DBOProgram 
PROCEDURE busca-ctas-impto-var :
/*:T------------------------------------------------------------------------------
  Purpose:     busca as contas de impostos parametrizadas para o estabelecimento e data da transaá∆o
  Parameters:  recebe a data da transaá∆o, codigo do estabelecimento e numero do imposto
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM pdt-trans    LIKE movto-estoq.dt-trans       NO-UNDO.
    DEF INPUT PARAM pcod-estab   LIKE estab-ctas-impto.cod-estab NO-UNDO.
    DEF INPUT PARAM pnum-impto   LIKE estab-ctas-impto.cod-estab NO-UNDO.
    DEF OUTPUT PARAM pct-codigo  AS CHAR                         NO-UNDO.
    DEF OUTPUT PARAM psc-codigo  AS CHAR                         NO-UNDO.

    FOR EACH bfestab-ctas-impto
       WHERE bfestab-ctas-impto.cod-estab = pcod-estab
       AND   bfestab-ctas-impto.dat-inic-valid <= pdt-trans
       AND   bfestab-ctas-impto.dat-fim-valid >= pdt-trans NO-LOCK:
        CASE bfestab-ctas-impto.num-impto:
            WHEN 1 THEN
                assign pct-codigo = bfestab-ctas-impto.conta-imposto
                       psc-codigo = bfestab-ctas-impto.cod-ccusto-impto.
            WHEN 2 THEN
                assign pct-codigo = bfestab-ctas-impto.conta-imposto
                       psc-codigo = bfestab-ctas-impto.cod-ccusto-impto.
            WHEN 3 THEN
                assign pct-codigo = bfestab-ctas-impto.conta-imposto
                       psc-codigo = bfestab-ctas-impto.cod-ccusto-impto.
            WHEN 4 THEN
                assign pct-codigo = bfestab-ctas-impto.conta-imposto
                       psc-codigo = bfestab-ctas-impto.cod-ccusto-impto.
        END.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME */
