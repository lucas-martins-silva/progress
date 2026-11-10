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
{include/i-prgvrs.i BOIN876 2.00.00.015 } /*** "010015" 17/06/2025 16:40:55 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i boin876 MRE}
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
&GLOBAL-DEFINE DBOName BOIN876
&GLOBAL-DEFINE DBOVersion 2.04.000.001
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName param-manif-destin
&GLOBAL-DEFINE TableLabel ParÉmetros
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
{inbo/boin876.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE c-estab              LIKE estabelec.cod-estab.
DEFINE VARIABLE c-ini-cod-estab    LIKE estabelec.cod-estab.
DEFINE VARIABLE c-fim-cod-estab    LIKE estabelec.cod-estab.
DEFINE VARIABLE c-desc-tudo AS CHARACTER   NO-UNDO.

DEFINE VARIABLE c-texto   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-texto-1 AS CHARACTER   NO-UNDO.
/*DEFINE VARIABLE h-adapter            AS HANDLE    NO-UNDO.
DEFINE VARIABLE cVersaoAxsep015      AS CHARACTER NO-UNDO.
DEFINE VARIABLE lExecutadoPeloFT0912 AS LOGICAL   NO-UNDO.
DEFINE VARIABLE i-cont-progs         AS INTEGER   NO-UNDO.*/

DEFINE TEMP-TABLE tt_log_erro NO-UNDO
     FIELD ttv_num_cod_erro  AS INTEGER   INITIAL ?
     FIELD ttv_des_msg_ajuda AS character INITIAL ?
     FIELD ttv_des_msg_erro  AS character INITIAL ?.

{utp/ut-glob.i}

{cdp/cdcfgmat.i}
{cdp/cdcfgdis.i}

DEFINE VARIABLE h-reapi329 AS HANDLE NO-UNDO.

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
         HEIGHT             = 22.21
         WIDTH              = 59.72.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram 
PROCEDURE afterCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF rowObject.log-realiz-md-manual = NO THEN DO:
    IF NOT VALID-HANDLE(h-reapi329) THEN
        RUN rep/reapi329.p PERSISTENT SET h-reapi329.

    RUN piConfiguraManifestacaoDestin IN h-reapi329 (INPUT TABLE rowObject).

    DELETE OBJECT h-reapi329.
END.

RETURN "OK":u.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterUpdateRecord DBOProgram 
PROCEDURE afterUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF rowObject.log-realiz-md-manual = NO THEN DO:
    IF NOT VALID-HANDLE(h-reapi329) THEN
        RUN rep/reapi329.p PERSISTENT SET h-reapi329.

    RUN piConfiguraManifestacaoDestin IN h-reapi329 (INPUT TABLE rowObject).

    DELETE OBJECT h-reapi329.
END.

RETURN "OK":u.



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
        WHEN "cod-estab":U    THEN ASSIGN pFieldValue = RowObject.cod-estab.
        WHEN "des-md-dir-xml":U     THEN ASSIGN pFieldValue = RowObject.des-md-dir-xml.
        WHEN "cod-md-vers":U      THEN ASSIGN pFieldValue = RowObject.cod-md-vers.
        WHEN "cod-ult-seqcial-unico":U THEN ASSIGN pFieldValue = RowObject.cod-ult-seqcial-unico.
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
        WHEN "idi-md-ambien":U THEN ASSIGN pFieldValue = RowObject.idi-md-ambien.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice Estabel
  Parameters:  
               retorna valor do campo cod-estab
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estab LIKE param-manif-destin.cod-estab NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-estab = RowObject.cod-estab.

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
        WHEN "log-realiz-md-manual":U THEN ASSIGN pFieldValue = RowObject.log-realiz-md-manual.
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
  Purpose:     Reposiciona registro com base no °ndice Estabel
  Parameters:  
               recebe valor do campo cod-estab
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estab LIKE param-manif-destin.cod-estab NO-UNDO.

    FIND FIRST bfparam-manif-destin WHERE 
        bfparam-manif-destin.cod-estab = pcod-estab NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfparam-manif-destin THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfparam-manif-destin)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByEstab DBOProgram 
PROCEDURE openQueryByEstab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME}
                            WHERE {&TABLENAME}.cod-estab = c-estab NO-LOCK.

    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCodEstab DBOProgram 
PROCEDURE openQueryCodEstab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} WHERE 
                                     {&TABLENAME}.cod-estab >= c-ini-cod-estab AND
                                     {&TABLENAME}.cod-estab <= c-fim-cod-estab NO-LOCK INDEXED-REPOSITION.

RETURN "OK":U.
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
    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} NO-LOCK INDEXED-REPOSITION.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByEstab DBOProgram 
PROCEDURE setConstraintByEstab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-estab LIKE estabelec.cod-estab.

    ASSIGN c-estab = p-estab.

    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCodEstab DBOProgram 
PROCEDURE setConstraintCodEstab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-ini-cod-estab LIKE estabelec.cod-estab.
    DEF INPUT PARAM p-fim-cod-estab LIKE estabelec.cod-estab.

    ASSIGN c-ini-cod-estab = p-ini-cod-estab
           c-fim-cod-estab = p-fim-cod-estab.

    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeUpdateRecord DBOProgram 
PROCEDURE beforeUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*Regra para quando o usu†rio zera o NSU*/
    IF  CAN-FIND (FIRST bf{&TABLEName} NO-LOCK 
                 WHERE bf{&TABLEName}.cod-estab  = rowObject.cod-estab
                 AND   ROWID(bf{&TABLEName})     = rowObject.r-rowid 
                 AND   bf{&TABLEName}.cod-ult-seqcial-unico <> RowObject.cod-ult-seqcial-unico) THEN DO:
        ASSIGN OVERLAY(RowObject.cod-livre-1,1,50) = (c-seg-usuario + " - " + STRING(TODAY) + " - " + STRING(TIME,"HH:MM:SS")). 
    END.
         
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
    
    DEFINE VARIABLE cTpTrans AS CHARACTER NO-UNDO.

    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/
    IF pType = "CREATE" OR
       pType = "UPDATE" THEN DO:
        /*:T--- Verifica ocorrància de erros ---*/

        /*ambiente : 1- produá∆o , 2 - homologaá∆o*/
        IF RowObject.idi-md-ambien < 1 OR RowObject.idi-md-ambien       > 2 THEN DO:  
            {utp/ut-liter.i "Ambiente" *}
            ASSIGN c-texto = RETURN-VALUE
                   c-texto-1 = "1;2":U.
            {method/svc/errors/inserr.i &ErrorNumber="18733"  &ErrorType="EMS"  &ErrorSubType="ERROR"  &ErrorParameters="c-texto + '~~~~' + c-texto-1"}
        END.

        /*Situaá∆o Manifestaá∆o Autom†tica: 1 - Operaá∆o confirmada , 2 - Ciància da Operaá∆o*/
        IF RowObject.num-livre-1  < 1  OR RowObject.num-livre-1  > 2 THEN DO:
            {utp/ut-liter.i "Situaá∆o_manifestaá∆o_automatica" *}
            ASSIGN c-texto = RETURN-VALUE
                   c-texto-1 = "1;2":U.
            {method/svc/errors/inserr.i &ErrorNumber="18733"  &ErrorType="EMS"  &ErrorSubType="ERROR"  &ErrorParameters="c-texto + '~~~~' + c-texto-1"}
        END.

        FIND FIRST bf{&TABLEName} NO-LOCK 
             WHERE bf{&TABLEName}.cod-estab  = rowObject.cod-estab
               AND ROWID(bf{&TABLEName}) <> rowObject.r-rowid NO-ERROR.
        IF  AVAIL bf{&TABLEName} THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-table.i mgind param-manif-destin 1} /* Busca o label da tabela */
            ASSIGN c-desc-tudo = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="7"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="c-desc-tudo"}
        END.

        FIND FIRST param-re NO-LOCK
             WHERE param-re.usuario = c-seg-usuario NO-ERROR.
        IF NOT AVAIL param-re OR 
        
        &IF '{&bf_dis_versao_ems}' >= '2.09' &THEN 
               param-re.log-manif-destin = NO
        &ELSE  SUBSTR(param-re.char-1,19,1) <> "1"
        
        &ENDIF THEN DO:
       
            {method/svc/errors/inserr.i &ErrorNumber="52758"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="c-seg-usuario"}
        
        END.
    
        FIND FIRST estabelec NO-LOCK WHERE estabelec.cod-estabel = rowObject.cod-estab NO-ERROR.
        IF  NOT AVAILABLE estabelec THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-table.i mgadm estabelec 1} /* Busca o label da tabela */
            ASSIGN c-desc-tudo = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="c-desc-tudo"}
        END.
        ELSE DO:

            RUN cdp/cd0360b.p (INPUT estabelec.cod-estabel,
                               INPUT "MD-e":U,
                               OUTPUT cTpTrans).

            ASSIGN FILE-INFO:FILE-NAME = rowObject.des-md-dir-xml. 
	    IF  cTpTrans = "TSS":U THEN DO: 
            
                /*Se n∆o existir o parÉmetro cadastrado ou se o campo ind-empresa estiver em branco 
                deve apresentar a mensagem 52731 Parametrizaá∆o do WebService da NF-e n∆o foi encontrada!"*/
                FIND FIRST param-nf-estab NO-LOCK WHERE param-nf-estab.cod-estabel = rowObject.cod-estab NO-ERROR.
                IF NOT AVAIL param-nf-estab OR param-nf-estab.ind-empresa = "" THEN DO:
                    /* Inicio -- Projeto Internacional */
                    {utp/ut-table.i mgdis param-nf-estab 1} /* Busca o label da tabela */
                    ASSIGN c-desc-tudo = TRIM(RETURN-VALUE).
                    {method/svc/errors/inserr.i &ErrorNumber="52731"
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="c-desc-tudo"}
                END.
		
	        RUN pi-testa-conexao-tss (INPUT "MANIFDESTIN").
            
                IF  FILE-INFO:FULL-PATHNAME = ? THEN DO:
                    /* Inicio -- Projeto Internacional */
                    {utp/ut-liter.i Param_NF_Estab *}
                    {method/svc/errors/inserr.i &ErrorNumber="28550"
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="TRIM(RETURN-VALUE)"}
                    
                END.
            END.
            ELSE DO:

                IF cTpTrans <> 'TC2':U AND cTpTrans <> 'TPF':U THEN DO:

                    {method/svc/errors/inserr.i &ErrorNumber="56889"
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"}

                END.

            END.
			
			
        END.
    END.


    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-testa-conexao-tss DBOProgram 
PROCEDURE pi-testa-conexao-tss :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER cWebServiceTSS AS CHARACTER NO-UNDO.

    DEFINE VARIABLE h-TSSAPI         AS HANDLE      NO-UNDO.    
    DEFINE VARIABLE lConexaoOK       AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE cParamMsgErro    AS CHARACTER   NO-UNDO.

    IF  NOT VALID-HANDLE(h-TSSAPI) THEN 
        RUN ftp/ftapi511.p PERSISTENT SET h-TSSAPI.
    
    FIND FIRST param-nf-estab NO-LOCK WHERE param-nf-estab.cod-estabel = rowObject.cod-estab NO-ERROR.
    IF NOT AVAIL param-nf-estab THEN DO:
        {utp/ut-liter.i "Verificar_o_cadastro_do_estabelecimento_no_programa_CD0403_e_CD0403b." *}

        ASSIGN c-desc-tudo = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i &ErrorNumber="17006"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="c-desc-tudo"}

        RETURN "nok":u.
    END.
    

    RUN setTSSURL IN h-TSSAPI (TRIM(param-nf-estab.cod-url-ws-tss)).
    /*15121 - Nova procedure - Token de autenticaá∆o do TSS*/
    RUN setTSSAuthParam IN h-TSSAPI (INPUT 1,
                                     INPUT "*",
                                     INPUT param-nf-estab.cod-estabel,
                                     INPUT param-nf-estab.cod-url-ws-tss).  
    RUN connectTSS  IN h-TSSAPI (INPUT cWebServiceTSS).
    RUN isConnected IN h-TSSAPI (INPUT cWebServiceTSS,
                                 OUTPUT lConexaoOK).
    RUN disconnectTss IN h-TSSAPI (INPUT cWebServiceTSS).
    
    IF  VALID-HANDLE(h-TSSAPI) THEN
        DELETE PROCEDURE h-TSSAPI.

    IF NOT lConexaoOK THEN do:
    
       
        ASSIGN cParamMsgErro = SESSION:TEMP-DIRECTORY + "logtssws.txt":U.

        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 36365,
                           INPUT "[TSS MANIFDESTIN]" + "~~":U + /*&1*/
                                 cParamMsgErro).               /*&2*/
        RETURN "nok":u.
    END.


END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

