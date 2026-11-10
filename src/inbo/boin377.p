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
{include/i-prgvrs.i BOIN377 2.00.00.012 } /*** "010012" 27/10/2023 17:03:46  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i boin377 MUT}
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
&GLOBAL-DEFINE DBOName referencia
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName referencia
&GLOBAL-DEFINE TableLabel referencia
&GLOBAL-DEFINE QueryName qr{&TableName}

&GLOBAL-DEFINE KeyField1 cod-refer /*:T Informar os campos da chave quando o Progress nÆo conseguir resolver find {&TableName} OF RowObject. */
&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (m²todo Receive Message) */
&GLOBAL-DEFINE XMLProducer YES    /*:T DBO atua como producer de mensagens para o Message Broker */
&GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES

/*--- Include com defini»’o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret½rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser id¼ntico ao nome do DBO mas com
      extens’o .i ---*/
{inbo/boin377.i RowObject}

/*--- Include com defini»’o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera»’o da defini»’o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini»’o
      manual da query ---*/
{method/dboqry.i}

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/* Variaveis necessarias aos SetConstraintïs */

   def var c-cod-refer-ini as char no-undo. 
   def var c-cod-refer-fim as char no-undo.
   def var c-descricao-ini as char no-undo. 
   def var c-descricao-fim as char no-undo.

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



/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findCodigo DBOProgram 
PROCEDURE findCodigo :
/*------------------------------------------------------------------------------
  Purpose:    Procura pelo ¡ndice, caso nÆo ache, retorna
        	mensagem de erro padrÆo do  EMS
  Parameters: ipar1:pcod-refer: Referˆncia
         
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    
    def input parameter pcod-refer as char no-undo.
    def output parameter pcreturn as char no-undo.
        
     
    RUN openQueryStatic (input "Main":U).
    
    run goToKey (input pcod-refer).

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
        WHEN "descricao":U THEN ASSIGN pFieldValue = RowObject.descricao.
        WHEN "texto":U THEN ASSIGN pFieldValue = RowObject.texto.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
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
    DEFINE OUTPUT PARAMETER pcod-refer LIKE referencia.cod-refer NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pcod-refer = RowObject.cod-refer.

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
        WHEN "subproduto":U THEN ASSIGN pFieldValue = RowObject.subproduto.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ­ndice CODIGO
  Parameters:
               recebe valor dos campos do ­ndice CODIGO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-refer LIKE referencia.cod-refer NO-UNDO.

    FIND FIRST bfreferencia WHERE
        bfreferencia.cod-refer = pcod-refer
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfreferencia THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav²s de rowid e verifica a ocorr¼ncia de erros, caso
          existam erros serÿ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfreferencia)).
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
              RUN openQueryStatic (input "CodRefer":U).
           
           when 3 then
              RUN openQueryStatic (input "CodReferIndexCod":U).
           
           when 4 then
              RUN openQueryStatic (input "CodReferIndexDes":U).

           when 5 then
              RUN openQueryStatic (input "ByFiltroCodRefer":U).

           when 6 then
              RUN openQueryStatic (input "ByFiltroDescricao":U).

       end case.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByFiltroCodRefer DBOProgram 
PROCEDURE openQueryByFiltroCodRefer :
/*------------------------------------------------------------------------------
  Purpose:     Busca conjunto de registros da tabela referencia, 
               dentro de uma faixa de referˆncia inicial e final,
               descri‡Æo inicial e final.Ordena por referˆncia. 

   -----------------------------------------------------------------------------*/
 
    open query {&QUERYNAME} for each {&TABLENAME} where {&TABLENAME}.cod-refer >= c-cod-refer-ini AND
                                                        {&TABLENAME}.cod-refer <= c-cod-refer-fim AND
                                                        {&TABLENAME}.descricao >= c-descricao-ini AND
                                                        {&TABLENAME}.descricao <= c-descricao-fim
                                                         NO-LOCK by {&TABLENAME}.cod-refer INDEXED-REPOSITION.
      
            
                                              
    RETURN "OK":U.

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByFiltroDescricao DBOProgram 
PROCEDURE openQueryByFiltroDescricao :
/*------------------------------------------------------------------------------
  Purpose:     Busca conjunto de registros da tabela referencia,
               dentro de uma faixa de referˆncia inicial e final,
               descri‡Æo inicial e final.Ordena por descri‡Æo. 
   
------------------------------------------------------------------------------*/
   open query {&QUERYNAME} for each {&TABLENAME} where {&TABLENAME}.cod-refer >= c-cod-refer-ini AND
                                                       {&TABLENAME}.cod-refer <= c-cod-refer-fim AND
                                                       {&TABLENAME}.descricao >= c-descricao-ini AND
                                                       {&TABLENAME}.descricao <= c-descricao-fim
                                                        NO-LOCK by {&TABLENAME}.descricao INDEXED-REPOSITION.
      
            
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCodRefer DBOProgram 
PROCEDURE openQueryCodRefer :
/*------------------------------------------------------------------------------
  Purpose:     Busca conjunto de registros da tabela referencia, 
               dentro de uma faixa de referˆncia inicial.
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    open query {&QUERYNAME} for each {&TABLENAME} where {&TABLENAME}.cod-refer >= c-cod-refer-ini 
                                                        NO-LOCK  INDEXED-REPOSITION.
      
                                              
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCodReferIndexCod DBOProgram 
PROCEDURE openQueryCodReferIndexCod :
/*------------------------------------------------------------------------------
  Purpose:    Busca conjunto de registros da tabela referencia, dentro de 
              uma faixa de referˆncia inicial e final.
              Usa o c¢digo como ¡ndice. 
  
  ------------------------------------------------------------------------------*/
  open query {&QUERYNAME} for each {&TABLENAME} where {&TABLENAME}.cod-refer >= c-cod-refer-ini AND
                                                      {&TABLENAME}.cod-refer <= c-cod-refer-fim 
                                                       USE-INDEX codigo
                                                       NO-LOCK  INDEXED-REPOSITION.
      
     
     
    RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCodReferIndexDes DBOProgram 
PROCEDURE openQueryCodReferIndexDes :
/*------------------------------------------------------------------------------
  Purpose:     Busca conjunto de registros da tabela referencia, dentro de
               uma faixa de referˆncia inicial e final.
               Usa a descri‡Æo como ¡ndice.
     
------------------------------------------------------------------------------*/
  open query {&QUERYNAME} for each {&TABLENAME} where {&TABLENAME}.cod-refer >= c-cod-refer-ini AND
                                                      {&TABLENAME}.cod-refer <= c-cod-refer-fim
                                                       USE-INDEX descricao
                                                       NO-LOCK  INDEXED-REPOSITION.
      
     
          
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
    OPEN QUERY {&QueryName} FOR EACH referencia NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint2 DBOProgram 
PROCEDURE setConstraint2 :
/*------------------------------------------------------------------------------
  Purpose:    Seta as vari veis de controle para queries contendo
              a referˆncia inicial. 
  Parameters: ipar: p-cod-refer-ini:Referˆncia Inicial         
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    def input parameter p-cod-refer-ini as char no-undo.
        
    run setConstraintCodReferIni (p-cod-refer-ini).
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint3 DBOProgram 
PROCEDURE setConstraint3 :
/*------------------------------------------------------------------------------
  Purpose:     Seta as vari veis de controle para queries contendo 
               a referˆncia inicial e final.
  Parameters:  ipar1:p-cod-refer-ini: Referˆncia Inicial 
               ipar2:p-cod-refer-fim: Referˆncia Final
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    def input param p-cod-refer-ini as char no-undo.
    def input param p-cod-refer-fim as char no-undo.
        
    run setConstraintFiltroCodRefer (p-cod-refer-ini,
                                     p-cod-refer-fim).
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint4 DBOProgram 
PROCEDURE setConstraint4 :
/*------------------------------------------------------------------------------
  Purpose:     Seta as vari veis de controle para queries contendo 
               a referˆncia inicial e final, descri‡Æo inicial e final.
  Parameters:  ipar1:p-cod-refer-ini: Referˆncia Inicial
               ipar2:p-cod-refer-fim: Referˆncia Final
               ipar3:p-descricao-ini: Descri‡Æo Inicial
               ipar4:p-descricao-fim: Descri‡Æo Final
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    def input param p-cod-refer-ini as char no-undo.
    def input param p-cod-refer-fim as char no-undo.
    def input param p-descricao-ini as char no-undo.
    def input param p-descricao-fim as char no-undo.
        
    run setConstraintFiltroReferDesc (p-cod-refer-ini,
                                      p-cod-refer-fim,
                                      p-descricao-ini,
                                      p-descricao-fim).
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCodReferIni DBOProgram 
PROCEDURE setConstraintCodReferIni :
/*------------------------------------------------------------------------------
  Purpose:    Seta as vari veis de controle para queries contendo
              a referˆncia inicial. 
  Parameters: ipar: p-cod-refer-ini:Referˆncia Inicial        
------------------------------------------------------------------------------*/
    def input parameter p-cod-refer-ini as char no-undo.

    assign c-cod-refer-ini = p-cod-refer-ini.
           
                  
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFiltroCodRefer DBOProgram 
PROCEDURE setConstraintFiltroCodRefer :
/*------------------------------------------------------------------------------
  Purpose:    Seta as vari veis de controle para queries contendo 
              a referˆncia inicial e final.
  Parameters: ipar1:p-cod-refer-ini: Referˆncia Inicial 
              ipar2:p-cod-refer-fim: Referˆncia Final
        
------------------------------------------------------------------------------*/
   def input param p-cod-refer-ini as char no-undo.
   def input param p-cod-refer-fim as char no-undo.

     assign c-cod-refer-ini = p-cod-refer-ini
            c-cod-refer-fim = p-cod-refer-fim.
             
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFiltroReferDesc DBOProgram 
PROCEDURE setConstraintFiltroReferDesc :
/*------------------------------------------------------------------------------
  Purpose:     Seta as vari veis de controle para queries contendo 
               a referˆncia inicial e final, descri‡Æo inicial e final.
  Parameters:  ipar1:p-cod-refer-ini: Referˆncia Inicial
               ipar2:p-cod-refer-fim: Referˆncia Final
               ipar3:p-descricao-ini: Descri‡Æo Inicial
               ipar4:p-descricao-fim: Descri‡Æo Final
     
------------------------------------------------------------------------------*/
   def input param p-cod-refer-ini as char no-undo.
   def input param p-cod-refer-fim as char no-undo.
   def input param p-descricao-ini as char no-undo.
   def input param p-descricao-fim as char no-undo.
   
   assign c-cod-refer-ini = p-cod-refer-ini
          c-cod-refer-fim = p-cod-refer-fim
          c-descricao-ini = p-descricao-ini
          c-descricao-fim = p-descricao-fim.

   RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByFiltroCodRefer DBOProgram 
PROCEDURE setConstraintByFiltroCodRefer:
/*------------------------------------------------------------------------------
  Purpose:     Seta as vari veis de controle para queries contendo 
               a referˆncia inicial e final, descri‡Æo inicial e final.
  Parameters:  ipar1:p-cod-refer-ini: Referˆncia Inicial
               ipar2:p-cod-refer-fim: Referˆncia Final
               ipar3:p-descricao-ini: Descri‡Æo Inicial
               ipar4:p-descricao-fim: Descri‡Æo Final
     
------------------------------------------------------------------------------*/
   def input param p-cod-refer-ini as char no-undo.
   def input param p-cod-refer-fim as char no-undo.
   def input param p-descricao-ini as char no-undo.
   def input param p-descricao-fim as char no-undo.
   
   assign c-cod-refer-ini = p-cod-refer-ini
          c-cod-refer-fim = p-cod-refer-fim
          c-descricao-ini = p-descricao-ini
          c-descricao-fim = p-descricao-fim.

   RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByFiltroDescricao DBOProgram 
PROCEDURE setConstraintByFiltroDescricao:
/*------------------------------------------------------------------------------
  Purpose:     Seta as vari veis de controle para queries contendo 
               a referˆncia inicial e final, descri‡Æo inicial e final.
  Parameters:  ipar1:p-cod-refer-ini: Referˆncia Inicial
               ipar2:p-cod-refer-fim: Referˆncia Final
               ipar3:p-descricao-ini: Descri‡Æo Inicial
               ipar4:p-descricao-fim: Descri‡Æo Final
     
------------------------------------------------------------------------------*/
   def input param p-cod-refer-ini as char no-undo.
   def input param p-cod-refer-fim as char no-undo.
   def input param p-descricao-ini as char no-undo.
   def input param p-descricao-fim as char no-undo.
   
   assign c-cod-refer-ini = p-cod-refer-ini
          c-cod-refer-fim = p-cod-refer-fim
          c-descricao-ini = p-descricao-ini
          c-descricao-fim = p-descricao-fim.

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
