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
{include/i-prgvrs.i BOIN186 2.00.00.005} /*** "010005" 27/10/2023 17:03:43  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin186 MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : 
    Purpose    : O DBO (Datasul Business Objects) ² um programa PROGRESS
                 que cont²m a l½gica de neg½cio e acesso a dados para uma
                 tabela do banco de dados.

    Parameters :

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de defini»’o ---*/
&GLOBAL-DEFINE DBOName lin-prod
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName lin-prod
&GLOBAL-DEFINE TableLabel lin-prod
&GLOBAL-DEFINE QueryName qr{&TableName}

&GLOBAL-DEFINE KeyField1 nr-linha /*:T Informar os campos da chave quando o Progress nÆo conseguir resolver find {&TableName} OF RowObject. */
&GLOBAL-DEFINE KeyField2 cod-estabel /*:T Informar os campos da chave quando o Progress nÆo conseguir resolver find {&TableName} OF RowObject. */
&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (m‚todo Receive Message) */
/* &GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES */

/*--- Include com defini»’o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret½rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser id¼ntico ao nome do DBO mas com
      extens’o .i ---*/
    
{inbo/boin186.i RowObject}

/*--- Include com defini»’o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera»’o da defini»’o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini»’o
      manual da query ---*/
      
   
      
{method/dboqry.i}


/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/* Variaveis necessarias aos setConstraint's */

   def var c-inicial         as char no-undo.
   def var c-final           as char no-undo.
   def var c-cod-estabel     as char no-undo.

{cdp/cdcfgman.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram



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
         HEIGHT             = 5.21
         WIDTH              = 51.
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



/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findCodigo DBOProgram 
PROCEDURE findCodigo :
/*------------------------------------------------------------------------------
  Purpose:    Procura pelo indice, caso nao ache,
              retorna mensagem de erro padrao do EMS. 
  Parameters: ipar:pnr-linha: Linha Produ‡Æo       
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    
    def input parameter pnr-linha as inte no-undo.
    def output parameter pcreturn as char no-undo.
        
        
    RUN openQueryStatic (input "Main":U).
    
    run goToKey (input pnr-linha).

    if return-value = "OK" then assign pcreturn = "".  /* esse e o valor esperado nas interfaces 1.1 */
    if return-value = "NOK" then do:
        {utp/ut-table.i mgind {&TABLENAME} 1}
        run utp/ut-msgs.p (input "msg":U,
                           input 2,
                           input return-value).
        assign pcreturn =  return-value.  
        /* essa e a mensagem esperada nas interfaces 1.1  qdo n’o acha o registro */
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findPlanejador DBOProgram 
PROCEDURE findPlanejador :
/*------------------------------------------------------------------------------
  Purpose:     Procura pelo indice, caso nao ache,
               retorna mensagem de erro padrao do EMS.
  Parameters:  ipar1: pcd-planejado: Planejador
               ipar2: pnr-linha: Linha Produ‡Æo
      
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    
    def input parameter pcd-planejado as char no-undo.
    def input parameter pnr-linha as inte no-undo.
    def output parameter pcreturn as char no-undo.
        
        
    RUN openQueryStatic (input "Main":U).
    
    run goToPlanejador (input pcd-planejado,
                        input pnr-linha).

    if return-value = "OK" then assign pcreturn = "".  /* esse e o valor esperado nas interfaces 1.1 */
    if return-value = "NOK" then do:
        {utp/ut-table.i mgind {&TABLENAME} 1}
        run utp/ut-msgs.p (input "msg":U,
                           input 2,
                           input return-value).
        assign pcreturn =  return-value.  
        /* essa e a mensagem esperada nas interfaces 1.1  qdo n’o acha o registro */
    end.

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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "ct-ordem":U THEN ASSIGN pFieldValue = RowObject.ct-ordem.
        WHEN "ct-refugo":U THEN ASSIGN pFieldValue = RowObject.ct-refugo.
        WHEN "deposito-pad":U THEN ASSIGN pFieldValue = RowObject.deposito-pad.
        WHEN "descricao":U THEN ASSIGN pFieldValue = RowObject.descricao.
        WHEN "loc-padrao":U THEN ASSIGN pFieldValue = RowObject.loc-padrao.
        WHEN "sc-ordem":U THEN ASSIGN pFieldValue = RowObject.sc-ordem.
        WHEN "sc-refugo":U THEN ASSIGN pFieldValue = RowObject.sc-refugo.
        WHEN "cd-planejado":U THEN ASSIGN pFieldValue = RowObject.cd-planejado.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "nr-linha":U THEN ASSIGN pFieldValue = RowObject.nr-linha.
        WHEN "sum-requis":U THEN ASSIGN pFieldValue = RowObject.sum-requis.
        WHEN "tp-planej":U THEN ASSIGN pFieldValue = RowObject.tp-planej.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ­ndice CODIGO
  Parameters:
               retorna valor dos campos do ­ndice CODIGO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnr-linha LIKE lin-prod.nr-linha NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pnr-linha = RowObject.nr-linha.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogField DBOProgram 
PROCEDURE getLogField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo l½gico
  Parameters:
               recebe nome do campo
               retorna valor do campo
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "aloca-ord":U THEN ASSIGN pFieldValue = RowObject.aloca-ord.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RAW NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
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




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToId DBOProgram 
PROCEDURE goToId :
/*------------------------------------------------------------------------------
  Purpose:     Procura pelo indice (EMS 203), caso nao ache,
               retorna mensagem de erro padrao do EMS.
  Parameters:  ipar1: pcod-estabel: Estabelecimento
               ipar2: pnr-linha: Linha Produ‡Æo
  -----------------------------------------------------------------------------*/
&IF DEFINED (bf_man_203) &THEN
   DEFINE INPUT PARAMETER pcod-estabel LIKE lin-prod.cod-estabel NO-UNDO.
   DEFINE INPUT PARAMETER pnr-linha    LIKE lin-prod.nr-linha NO-UNDO.

    FIND bflin-prod WHERE
         bflin-prod.cod-estabel = pcod-estabel AND
         bflin-prod.nr-linha = pnr-linha
         NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bflin-prod THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav²s de rowid e verifica a ocorr¼ncia de erros, caso
          existam erros serÿ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bflin-prod)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.

&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ­ndice CODIGO
  Parameters:  recebe valor dos campos do ­ndice CODIGO
  Notes:       retorna status do processo
  
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-linha LIKE lin-prod.nr-linha NO-UNDO.

    FIND FIRST bflin-prod WHERE
        bflin-prod.nr-linha = pnr-linha
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bflin-prod THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav²s de rowid e verifica a ocorr¼ncia de erros, caso
          existam erros serÿ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bflin-prod)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToPlanejador DBOProgram 
PROCEDURE goToPlanejador :
/*------------------------------------------------------------------------------
  Purpose:     Procura pelo indice, caso nao ache,
               retorna mensagem de erro padrao do EMS.
  Parameters:  ipar1: pcd-planejado: Planejador
               ipar2: pnr-linha: Linha Produ‡Æo
  -----------------------------------------------------------------------------*/
   DEFINE INPUT PARAMETER pcd-planejado LIKE lin-prod.cd-planejado NO-UNDO.
   DEFINE INPUT PARAMETER pnr-linha     LIKE lin-prod.nr-linha NO-UNDO.
    

    FIND bflin-prod WHERE
         bflin-prod.cd-planejado = pcd-planejado AND
         bflin-prod.nr-linha = pnr-linha
         NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bflin-prod THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav²s de rowid e verifica a ocorr¼ncia de erros, caso
          existam erros serÿ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bflin-prod)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuery DBOProgram 
PROCEDURE openQuery :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */

    define input parameter i-abertura as integer no-undo.
       case i-abertura:
           when 1 then
              RUN openQueryStatic (input "Main":U). 
              
           when 2 then
              RUN openQueryStatic (input "ByFiltroNrLinha":U).
           
           when 3 then
              RUN openQueryStatic (input "ByFiltroDescricao":U).
           
       end case.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByFiltroDescEstabel DBOProgram 
PROCEDURE openQueryByFiltroDescEstabel :
/*------------------------------------------------------------------------------
  Purpose:    Busca conjunto de registros da tabela lin-prod, dentro de
              uma faixa de descri»’o inicial e final e estabelecimento. Ordena por descri»’o.  
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
 &IF DEFINED (bf_man_203) &THEN
    open query {&QUERYNAME} for each {&TABLENAME} where {&TABLENAME}.descricao >= c-inicial AND
                                                        {&TABLENAME}.descricao <= c-final AND
                                                        {&TABLENAME}.cod-estabel = c-cod-estabel
                                                        NO-LOCK by {&TABLENAME}.descricao INDEXED-REPOSITION.
                                          
    RETURN "OK":U.
 &ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByFiltroDescricao DBOProgram 
PROCEDURE openQueryByFiltroDescricao :
/*------------------------------------------------------------------------------
  Purpose:    Busca conjunto de registros da tabela lin-prod, dentro de
              uma faixa de descri‡Æo inicial e final. Ordena por descri‡Æo.  
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    open query {&QUERYNAME} for each {&TABLENAME} where {&TABLENAME}.descricao >= c-inicial AND
                                                        {&TABLENAME}.descricao <= c-final
                                                        NO-LOCK by {&TABLENAME}.descricao INDEXED-REPOSITION.
                                          
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByFiltroNrLinha DBOProgram 
PROCEDURE openQueryByFiltroNrLinha :
/*------------------------------------------------------------------------------
  Purpose:    Busca conjunto de registros da tabela lin-prod, dentro de uma faixa
              de linha de produ‡Æo inicial e final. Ordena por linha de produ‡Æo.
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    open query {&QUERYNAME} for each {&TABLENAME} where {&TABLENAME}.nr-linha >= integer(c-inicial) AND
                                                        {&TABLENAME}.nr-linha <= integer(c-final) 
                                                        NO-LOCK by {&TABLENAME}.nr-linha INDEXED-REPOSITION.
                                          
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByLinhaEstabel DBOProgram 
PROCEDURE openQueryByLinhaEstabel :
/*------------------------------------------------------------------------------
  Purpose:    Busca conjunto de registros da tabela lin-prod, dentro de uma faixa
              de linha de produ‡Æo inicial e final dentro do estabelecimento
              informado na tela. Ordena por linha de produ‡Æo.
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
 &IF DEFINED (bf_man_203) &THEN
     open query {&QUERYNAME} for each {&TABLENAME} where {&TABLENAME}.nr-linha >= integer(c-inicial) AND
                                                         {&TABLENAME}.nr-linha <= integer(c-final)   AND
                                                         {&TABLENAME}.cod-estabel = c-cod-estabel
                                                         NO-LOCK by {&TABLENAME}.nr-linha INDEXED-REPOSITION.
     RETURN "OK":U.
 &ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH lin-prod NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint2 DBOProgram 
PROCEDURE setConstraint2 :
/*------------------------------------------------------------------------------
  Purpose:    Seta as vari veis de controle para queries contendo 
               o c¢digo da linha produ‡Æo inicial e final.
  Parameters:  ipar1:p-inicial: Linha Produ‡Æo Inicial
               ipar2:p-final:   Linha Produ‡Æo Final
      
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    
    def input parameter p-inicial     as char no-undo.
    def input parameter p-final       as char no-undo.
    
    run setConstraintFiltroNrlinha (p-inicial,
                                    p-final).
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFiltroNrLinha DBOProgram 
PROCEDURE setConstraintFiltroNrLinha :
/*------------------------------------------------------------------------------
  Purpose:     Seta as vari veis de controle para queries contendo 
               o c¢digo da linha produ‡Æo inicial e final.
  Parameters:  ipar1:p-inicial: Linha Produ‡Æo Inicial
               ipar2:p-final:   Linha Produ‡Æo Final
------------------------------------------------------------------------------*/
    def input parameter p-inicial    as char no-undo.
    def input parameter p-final      as char no-undo.

    assign c-inicial = p-inicial
           c-final   = p-final.

                               
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintLinhaEstabel DBOProgram 
PROCEDURE setConstraintLinhaEstabel :
/*------------------------------------------------------------------------------
  Purpose:     Seta as vari veis de controle para queries contendo 
               o c¢digo da linha produ‡Æo inicial e final e estabelecimento.
  Parameters:  ipar1:p-inicial: Linha Produ‡Æo Inicial
               ipar2:p-final:   Linha Produ‡Æo Final
               ipar3:p-estabel: Codigo Estabelecimento
------------------------------------------------------------------------------*/
    def input parameter p-inicial    as char no-undo.
    def input parameter p-final      as char no-undo.
    def input parameter p-estabel    as char no-undo.

    assign c-inicial     = p-inicial
           c-final       = p-final
           c-cod-estabel = p-estabel.
                               
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Valida temptable RowObject
  Parameters:  recebe o tipo de valida»’o (Create, Delete, Update)
  Notes:
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    /*--- Utilize o par³metro pType para identificar quais as valida»„es a serem
          executadas ---*/
    /*--- Os valores poss­veis para o par³metro s’o: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atrav²s do
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as valida»„es ---*/

    /*--- Verifica ocorr¼ncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDefault DBOProgram  
PROCEDURE openQueryDefault :
    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} NO-LOCK INDEXED-REPOSITION.
                                      
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
