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
{include/i-prgvrs.i BOIN144 2.00.00.010} /*** "010010" 27/10/2023 17:03:42  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin144 MUT}
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
&GLOBAL-DEFINE DBOName grup-maquina
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName grup-maquina
&GLOBAL-DEFINE TableLabel grup-maquina
&GLOBAL-DEFINE QueryName qr{&TableName}

&GLOBAL-DEFINE KeyField1 gm-codigo /*:T Informar os campos da chave quando o Progress nÆo conseguir resolver find {&TableName} OF RowObject. */
&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (m‚todo Receive Message) */
/* &GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES */

/*--- Include com defini»’o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret½rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser id¼ntico ao nome do DBO mas com
      extens’o .i ---*/
{inbo/boin144.i RowObject}

/*--- Include com defini»’o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera»’o da defini»’o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini»’o
      manual da query ---*/
{method/dboqry.i}

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/* Variaveis necessarias aos setConstraint's */
   
  define var v_gm_codigo   like grup-maquina.gm-codigo no-undo.
  define var v_inicial     as char no-undo.
  define var v_ini-desc    as char no-undo.
  define var v_final       as char no-undo.
  define var v_class       as int no-undo.
  define var v_end-desc    as char no-undo.
  define var p-gm-codigo   as char no-undo.
  define var p-cod-estabel as char no-undo.
  define var lLogPrincipal as log initial ? no-undo.

  {cdp/cd0666.i}
  
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
         HEIGHT             = 8.67
         WIDTH              = 35.29.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterGetBatchRecords DBOProgram 
PROCEDURE afterGetBatchRecords :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
if cQueryUseded = "NotLogPrincipal":U then do:
/*Se a query usada for a notLogPrincipal, nÆo devem ser trazidos registros de 
grupo de m quina que j  sejam filhos de outro. Pois nÆo podem ser inclu¡dos
em outra estrutura */

for each rowObjectAux:
    if can-find(first gm-estrut 
                where gm-estrut.gm-filho = rowObjectAux.gm-codigo)
    then delete rowObjectAux.             
end.

end.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaRegistro DBOProgram 
PROCEDURE buscaRegistro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER g-gm-codigo LIKE grup-maquina.gm-codigo NO-UNDO.
DEF OUTPUT PARAMETER r-gm-codigo AS ROWID NO-UNDO.


FOR FIRST grup-maquina   FIELDS (gm-codigo) WHERE
    grup-maquina.gm-codigo = g-gm-codigo NO-LOCK:

    ASSIGN r-gm-codigo = ROWID(grup-maquina).

    
END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findCodigo DBOProgram 
PROCEDURE findCodigo :
/*------------------------------------------------------------------------------
  Purpose:     Procura pelo indice, caso nao ache,
               retorna mensagem de erro padrao do EMS.
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    
    def input parameter pgm-codigo as char no-undo.
    def output parameter pcreturn as char no-undo.
    
        
    RUN openQueryStatic (input "Main":U).
    
    run goToCodigo (input pgm-codigo).

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findCodigoPesquisa DBOProgram 
PROCEDURE findCodigoPesquisa :
/*------------------------------------------------------------------------------
  Purpose:     Procura pelo indice, caso nao ache,
               retorna mensagem de erro padrao do EMS.
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    def input parameter pgm-codigo-inicial as char no-undo.
    def input parameter pgm-codigo-final as char no-undo.
    def output parameter pcreturn as char no-undo.
    
        
    RUN openQueryStatic (input "Main":U).
    
    run goToCodigoPesquisa (input pgm-codigo-inicial,
                            input pgm-codigo-final).

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findC_custo DBOProgram 
PROCEDURE findC_custo :
/*------------------------------------------------------------------------------
  Purpose:    Procura pelo indice, caso nao ache,
              retorna mensagem de erro padrao do EMS.
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    def input parameter pcc-codigo as char no-undo.
    def input parameter pgm-codigo as char no-undo.
    def output parameter pcreturn as char no-undo.
    
        
    RUN openQueryStatic (input "Main":U).
    
    run goToKey (input pcc-codigo,
                 input pgm-codigo).

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
        WHEN "cc-codigo":U THEN ASSIGN pFieldValue = RowObject.cc-codigo.
        WHEN "cd-calen":U THEN ASSIGN pFieldValue = RowObject.cd-calen.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "descricao":U THEN ASSIGN pFieldValue = RowObject.descricao.
        WHEN "gm-codigo":U THEN ASSIGN pFieldValue = RowObject.gm-codigo.
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
        WHEN "nr-up-hora":U THEN ASSIGN pFieldValue = RowObject.nr-up-hora.
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getGmCodigo DBOProgram 
PROCEDURE getGmCodigo :
/*------------------------------------------------------------------------------
  Purpose:     Retorna c¢digo grupo de m quina para abrir query estabelecimento
  Parameters:  C¢digo Grupo M quina
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pgm-codigo LIKE grup-maquina.gm-codigo NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pgm-codigo = RowObject.gm-codigo.

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
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ­ndice C-CUSTO
  Parameters:
               retorna valor dos campos do ­ndice C-CUSTO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcc-codigo LIKE grup-maquina.cc-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pgm-codigo LIKE grup-maquina.gm-codigo NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pcc-codigo = RowObject.cc-codigo.
    ASSIGN pgm-codigo = RowObject.gm-codigo.

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
        WHEN "ind-utiliz":U THEN ASSIGN pFieldValue = RowObject.ind-utiliz.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToCodigo DBOProgram 
PROCEDURE goToCodigo :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ­ndice GM-CODIGO
  Parameters:  recebe valor do campo do ­ndice GM-CODIGO
  Notes:       retorna status do processo
    
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pgm-codigo LIKE grup-maquina.gm-codigo NO-UNDO.
    

    FIND bfgrup-maquina WHERE
         bfgrup-maquina.gm-codigo = pgm-codigo
         NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfgrup-maquina THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav²s de rowid e verifica a ocorr¼ncia de erros, caso
          existam erros serÿ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfgrup-maquina)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToCodigoPesquisa DBOProgram 
PROCEDURE goToCodigoPesquisa :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ­ndice GM-CODIGO
  Parameters:  recebe valor do campo do ­ndice GM-CODIGO INICIAL E FINAL
  Notes:       retorna status do processo
         
------------------------------------------------------------------------------*/
   DEFINE INPUT PARAMETER pgm-codigo-inicial as char NO-UNDO.
   DEFINE INPUT PARAMETER pgm-codigo-final as char NO-UNDO.
    
    
    FIND bfgrup-maquina WHERE
         bfgrup-maquina.gm-codigo >= pgm-codigo-inicial and
         bfgrup-maquina.gm-codigo <= pgm-codigo-final
         NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfgrup-maquina THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav²s de rowid e verifica a ocorr¼ncia de erros, caso
          existam erros serÿ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfgrup-maquina)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToGMPai DBOProgram 
PROCEDURE goToGMPai :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pgm-filho LIKE gm-estrut.gm-filho NO-UNDO.

    FIND FIRST gm-estrut WHERE 
        gm-estrut.gm-filho = pgm-filho NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE gm-estrut THEN 
        RETURN "NOK":U.
    
    FIND FIRST bfGrup-maquina WHERE 
        bfGrup-maquina.gm-codigo = gm-estrut.gm-pai NO-LOCK NO-ERROR.        

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfGrup-maquina)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ¡ndige gm-codigo
  Parameters:
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pgm-codigo LIKE grup-maquina.gm-codigo NO-UNDO.

    FIND FIRST bfgrup-maquina WHERE
        bfgrup-maquina.gm-codigo = pgm-codigo
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfgrup-maquina THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav²s de rowid e verifica a ocorr¼ncia de erros, caso
          existam erros serÿ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfgrup-maquina)).
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
              RUN openQueryStatic (input "GmCodigo":U).
           
           when 3 then
              RUN openQueryStatic (input "FiltroGmCodigo":U).
           
           when 4 then
              RUN openQueryStatic (input "FiltroDescricao":U).

    end case.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFiltroDescricao DBOProgram 
PROCEDURE openQueryFiltroDescricao :
/*------------------------------------------------------------------------------
  Purpose:    Busca conjunto de registros da tabela grup-maquina,
              dentro de uma faixa de descri‡Æo inicial e final.  
         
------------------------------------------------------------------------------*/
    open query {&QUERYNAME} 
         for each {&TABLENAME} 
            where {&TABLENAME}.descricao >= v_ini-desc AND
                  {&TABLENAME}.descricao <= v_end-desc AND
                  (lLogPrincipal = ? or
                  (lLogPrincipal <> ? and {&TABLENAME}.log-principal = lLogPrincipal))
            NO-LOCK  BY  {&TABLENAME}.descricao INDEXED-REPOSITION.
    
                                      
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFiltroGmCodigo DBOProgram 
PROCEDURE openQueryFiltroGmCodigo :
/*------------------------------------------------------------------------------
  Purpose:    Busca conjunto de registros da tabela grup-maquina, dentro 
              de uma faixa de grupo de m quina inicial e final.  
          
------------------------------------------------------------------------------*/

    open query {&QUERYNAME} 
         for each {&TABLENAME} 
            where {&TABLENAME}.gm-codigo >= v_inicial AND
                  {&TABLENAME}.gm-codigo <= v_final AND
                  (lLogPrincipal = ? or
                   (lLogPrincipal <> ? and {&TABLENAME}.log-principal = lLogPrincipal))
            NO-LOCK INDEXED-REPOSITION.
    
                                      
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryGmCodigo DBOProgram 
PROCEDURE openQueryGmCodigo :
/*------------------------------------------------------------------------------
  Purpose:     Busca conjunto de registros da tabela grup-maquina, 
               conforme o grupo de m quina.
  
------------------------------------------------------------------------------*/
    
    open query {&QUERYNAME} for each {&TABLENAME} where {&TABLENAME}.gm-codigo = v_gm_codigo 
                                                         NO-LOCK INDEXED-REPOSITION.
                                      
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryGrupPrincipal DBOProgram 
PROCEDURE openQueryGrupPrincipal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} 
         FOR EACH grup-maquina where grup-maquina.log-principal = yes
         NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.

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
    OPEN QUERY {&QueryName} FOR EACH grup-maquina NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryNotLogPrincipal DBOProgram 
PROCEDURE openQueryNotLogPrincipal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    if v_class = 2 then
        open query {&QUERYNAME} for each {&TABLENAME} 
                   where {&TABLENAME}.descricao >= v_inicial
                     and {&TABLENAME}.descricao <= v_final
                     and {&TABLENAME}.log-principal = no
                   NO-LOCK by {&TABLENAME}.descricao.
    else
        open query {&QUERYNAME} for each {&TABLENAME} 
             where {&TABLENAME}.gm-codigo >= v_inicial
               and {&TABLENAME}.gm-codigo <= v_final
               and {&TABLENAME}.log-principal = no
              NO-LOCK.
                                      
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint2 DBOProgram 
PROCEDURE setConstraint2 :
/*------------------------------------------------------------------------------
  Purpose:    Seta as vari veis de controle para queries contendo o grupo de m quina. 
  Parameters: ipar: p_gm_codigo
  Notes:       
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
     
    DEFINE INPUT PARAMETER p_gm_codigo LIKE grup-maquina.gm-codigo NO-UNDO.

        
    run setConstraintGmCodigo (p_gm_codigo).
    
    RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint3 DBOProgram 
PROCEDURE setConstraint3 :
/*------------------------------------------------------------------------------
  Purpose:    Seta as vari veis de controle para queries contendo o grupo
              de m quina inicial e final. 
  Parameters: ipar1:p_inicial:Grupo Maquina Inicial
              ipar2:p_final  :Grupo Maquina Final
  Notes:       
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    
    def input parameter p_inicial     as char no-undo.
    def input parameter p_final       as char no-undo.
    
    run setConstraintFiltroGmCodigo (p_inicial,
                                     p_final).
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFiltroDescricao DBOProgram 
PROCEDURE setConstraintFiltroDescricao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter p_inicial    as char no-undo.
    def input parameter p_final      as char no-undo.

    assign v_ini-desc = p_inicial
           v_end-desc = p_final.

                               
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFiltroGmCodigo DBOProgram 
PROCEDURE setConstraintFiltroGmCodigo :
/*------------------------------------------------------------------------------
  Purpose:    Seta as vari veis de controle para queries contendo o grupo
              de m quina inicial e final. 
  Parameters: ipar1:p_inicial:Grupo Maquina Inicial
              ipar2:p_final  :Grupo Maquina Final
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter p_inicial    as char no-undo.
    def input parameter p_final      as char no-undo.

    assign v_inicial = p_inicial
           v_final   = p_final.

                               
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintGmCodigo DBOProgram 
PROCEDURE setConstraintGmCodigo :
/*------------------------------------------------------------------------------
  Purpose:    Seta as vari veis de controle para queries contendo o grupo de m quina. 
  Parameters: ipar: p_gm_codigo
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER p_gm_codigo LIKE grup-maquina.gm-codigo NO-UNDO.
    
    assign v_gm_codigo = p_gm_codigo.

                                      
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintLogPrincipal DBOProgram 
PROCEDURE setConstraintLogPrincipal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pLogPrincipal AS LOGICAL NO-UNDO.
       
       assign lLogPrincipal = pLogPrincipal.
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintNotLogPrincipal DBOProgram 
PROCEDURE setConstraintNotLogPrincipal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*Criada esta procedure pq o template de forma‡Æo ( utilizado no CD0117), exige que 
o setConstraint tenha o mesmo nome da query para fazer o openQuerySource */

    def input parameter p_inicial    as char no-undo.
    def input parameter p_final      as char no-undo.
    def input parameter p_class      as int no-undo.

    assign v_inicial = p_inicial
           v_final   = p_final
           v_class   = p_class.

                               
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

	IF pType = "Create" OR pType = "Update" THEN DO:
		
		IF NOT AVAILABLE RowObject THEN
			FIND FIRST RowObject NO-LOCK NO-ERROR.
			
		IF AVAILABLE RowObject THEN DO:
		
			/*Grupo de maquina vazio*/
			IF RowObject.gm-codigo = "" THEN DO:
				{method/svc/errors/inserr.i
					&ErrorNumber="611"
					&ErrorType="EMS"
					&ErrorParameters="' '"} 
			END.
			
			/*Area de producao nao encontrada*/
			IF NOT CAN-FIND (FIRST area-produc WHERE area-produc.cod-area-produc = RowObject.cod-area-produc NO-LOCK)THEN DO:
				{method/svc/errors/inserr.i
					&ErrorNumber="37615"
					&ErrorType="EMS"
					&ErrorParameters="' '"} 
			END.
			
			/*Centro de custo nao encontrada*/
			IF NOT CAN-FIND (FIRST centro-custo WHERE centro-custo.cc-codigo = RowObject.cc-codigo NO-LOCK)THEN DO:
				{method/svc/errors/inserr.i
					&ErrorNumber="2536"
					&ErrorType="EMS"
					&ErrorParameters="RowObject.cc-codigo"} 
			END.
			
			/*Calendario nao encontrada*/
			IF NOT CAN-FIND (FIRST calen-gener WHERE calen-gener.cd-calen = RowObject.cd-calen NO-LOCK)THEN DO:
				{method/svc/errors/inserr.i
					&ErrorNumber="132"
					&ErrorType="EMS"
					&ErrorParameters="' '"} 
			END.
			
			/* Tipo processamento diferente de 1,2,3 ou 4*/
			IF RowObject.ind-tip-ctrab < 1 OR RowObject.ind-tip-ctrab > 4 THEN DO:
				{method/svc/errors/inserr.i
					&ErrorNumber="56109"
					&ErrorType="EMS"
					&ErrorParameters="' '"} 
			END.
			
			/* Tipo tratamento tempo diferente de 1,2,3 ou 4*/
			IF RowObject.ind-tempo-operac < 1 OR RowObject.ind-tempo-operac > 4 THEN DO:
				{method/svc/errors/inserr.i
					&ErrorNumber="56110"
					&ErrorType="EMS"
					&ErrorParameters="' '"} 
			END.
			
			/* Tipo reporte MOD diferente de 1,2 ou 3*/
			IF RowObject.ind-reporte-mod < 1 OR RowObject.ind-reporte-mod > 3 THEN DO:
				{method/svc/errors/inserr.i
					&ErrorNumber="56111"
					&ErrorType="EMS"
					&ErrorParameters="' '"}
			END.
		END.
		ELSE DO:
			RETURN "NOK":U.			
		END.
	END.	
	
	ELSE IF pType = "Delete" THEN DO:
		
		IF NOT AVAILABLE RowObject THEN
			FIND FIRST RowObject NO-LOCK NO-ERROR.
			
		IF AVAILABLE RowObject THEN DO:
			FIND FIRST grup-maquina WHERE grup-maquina.gm-codigo = RowObject.gm-codigo NO-LOCK NO-ERROR.
			IF AVAILABLE grup-maquina THEN DO:
				RUN pi-valida-eliminacao-grup-maquina.
				
				IF RETURN-VALUE <> "ok" THEN DO:
					{database/tgin/tdp/tdin144.i1}
					
					IF CAN-FIND(FIRST tt-erro) THEN DO:
						FOR EACH tt-erro NO-LOCK:
							CREATE RowErrors.
							ASSIGN RowErrors.ErrorSequence = tt-erro.i-sequen
								   RowErrors.ErrorNumber = tt-erro.cd-erro
								   RowErrors.ErrorDescription = tt-erro.mensagem.
						END.
					END.					
				END.
			END.
		END.
		ELSE DO:
			RETURN "NOK":U.			
		END.
	END.
		
    /*--- Verifica ocorr¼ncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
	
END PROCEDURE.

{database/tgin/tdp/tdin144.i} /*pi-valida-eliminacao-grup-maquina*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDefault DBOProgram  
PROCEDURE openQueryDefault :
    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} NO-LOCK INDEXED-REPOSITION.
                                      
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

