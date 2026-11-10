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
{include/i-prgvrs.i BOIN263 2.00.00.006} /*** "010006" 27/10/2023 17:03:44  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN263 MUT}
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
&GLOBAL-DEFINE DBOName operacao
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName operacao
&GLOBAL-DEFINE TableLabel operacao
&GLOBAL-DEFINE QueryName qr{&TableName}

/*--- Include com defini»’o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret½rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser id¼ntico ao nome do DBO mas com
      extens’o .i ---*/


&GLOBAL-DEFINE KeyField1 it-codigo /*:T Informar os campos da chave quando o Progress n’o conseguir resolver find {&TableName} OF RowObject. */
&GLOBAL-DEFINE KeyField2 cod-roteiro /*:T Informar os campos da chave quando o Progress n’o conseguir resolver find {&TableName} OF RowObject. */      
&GLOBAL-DEFINE KeyField3 op-codigo /*:T Informar os campos da chave quando o Progress n’o conseguir resolver find {&TableName} OF RowObject. */
&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (m²todo Receive Message) */
/* &GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES */      
      
      
{inbo/boin263.i RowObject}

/*--- Include com defini»’o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera»’o da defini»’o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini»’o
      manual da query ---*/
{method/dboqry.i}

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/* Vari veis necess rias aos setConstraint's */

   def var v_cod_roteiro            LIKE operacao.cod-roteiro NO-UNDO.
   def var i-num-id-operacao-sucess as int no-undo.
   def var i-num-id-operacao-predec as int no-undo.
   def var c-it-codigo              as char no-undo.
   def var c-i-codigo-ini           as char no-undo.
   def var c-it-codigo-fim          as char no-undo.
   def var c-cod-roteiro-ini        as char no-undo.
   def var c-cod-roteiro-fim        as char no-undo.
   def var i-op-codigo-ini          as int  no-undo.
   def var i-op-codigo-fim          as int  no-undo.
   def var c-descricao-ini          as char no-undo.
   def var c-descricao-fim          as char no-undo.
   def var i-ordena                 as int  no-undo.

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
         HEIGHT             = 2.01
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
  Parameters: ipar1:i-op-codigo:Opera‡Æo
              ipar2:c-it-codigo:Item
              ipar3:c-cod-roteiro:Roteiro   
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    
    def input parameter i-op-codigo   as inte no-undo.    
    def input parameter c-it-codigo   as char no-undo.
    def input parameter c-cod-roteiro as char no-undo.
    def output parameter pcreturn as char no-undo.
        
        
    RUN openQueryStatic (input "Main":U).
    
    run goToKey (input c-it-codigo,
                 input c-cod-roteiro,
                 input i-op-codigo).

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findNum_id_operacao DBOProgram 
PROCEDURE findNum_id_operacao :
/*------------------------------------------------------------------------------
  Purpose:    Procura pelo ¡ndice, caso nÆo ache, retorna
        mensagem de erro padrÆo do  EMS
  Parameters: ipar:i-num-id-operacao:ID Opera‡Æo
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    
    def input parameter i-num-id-operacao as inte no-undo.
    def output parameter pcreturn as char no-undo.
        
        
    RUN openQueryStatic (input "Main":U).
    
    run goToNumIdOperacao (input i-num-id-operacao).
 
                 
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findOpCodigo DBOProgram 
PROCEDURE findOpCodigo :
/*------------------------------------------------------------------------------
  Purpose:    Procura pelo ¡ndice, caso nÆo ache, retorna
        mensagem de erro padrÆo do  EMS
  Parameters: ipar1:i-op-codigo:Opera‡Æo
              ipar2:c-it-codigo:Item    
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    
    def input parameter i-op-codigo as inte no-undo.
    def input parameter c-it-codigo as char no-undo.
    def output parameter pcreturn as char no-undo.
        
        
    RUN openQueryStatic (input "Main":U).
    
    run goToOpCodigo (input i-op-codigo,
                      input c-it-codigo).

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
        WHEN "revisao":U THEN ASSIGN pFieldValue = RowObject.revisao.
        WHEN "cd-mob-dir":U THEN ASSIGN pFieldValue = RowObject.cd-mob-dir.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
        WHEN "cod-roteiro":U THEN ASSIGN pFieldValue = RowObject.cod-roteiro.
        WHEN "cod-video":U THEN ASSIGN pFieldValue = RowObject.cod-video.
        WHEN "descricao":U THEN ASSIGN pFieldValue = RowObject.descricao.
        WHEN "desenho-cad":U THEN ASSIGN pFieldValue = RowObject.desenho-cad.
        WHEN "gm-codigo":U THEN ASSIGN pFieldValue = RowObject.gm-codigo.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "narrativa":U THEN ASSIGN pFieldValue = RowObject.narrativa.
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
        WHEN "data-base":U THEN ASSIGN pFieldValue = RowObject.data-base.
        WHEN "data-inicio":U THEN ASSIGN pFieldValue = RowObject.data-inicio.
        WHEN "data-termino":U THEN ASSIGN pFieldValue = RowObject.data-termino.
        WHEN "data-ult-ent":U THEN ASSIGN pFieldValue = RowObject.data-ult-ent.
        WHEN "data-ult-rep":U THEN ASSIGN pFieldValue = RowObject.data-ult-rep.
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
        WHEN "preco-base":U THEN ASSIGN pFieldValue = RowObject.preco-base.
        WHEN "preco-medio[1]":U THEN ASSIGN pFieldValue = RowObject.preco-medio[1].
        WHEN "preco-medio[2]":U THEN ASSIGN pFieldValue = RowObject.preco-medio[2].
        WHEN "preco-medio[3]":U THEN ASSIGN pFieldValue = RowObject.preco-medio[3].
        WHEN "preco-padrao":U THEN ASSIGN pFieldValue = RowObject.preco-padrao.
        WHEN "preco-repos":U THEN ASSIGN pFieldValue = RowObject.preco-repos.
        WHEN "preco-ul-ent":U THEN ASSIGN pFieldValue = RowObject.preco-ul-ent.
        WHEN "proporcao":U THEN ASSIGN pFieldValue = RowObject.proporcao.
        WHEN "refugo-op":U THEN ASSIGN pFieldValue = RowObject.refugo-op.
        WHEN "tempo-homem":U THEN ASSIGN pFieldValue = RowObject.tempo-homem.
        WHEN "tempo-limp":U THEN ASSIGN pFieldValue = RowObject.tempo-limp.
        WHEN "tempo-maquin":U THEN ASSIGN pFieldValue = RowObject.tempo-maquin.
        WHEN "tempo-prepar":U THEN ASSIGN pFieldValue = RowObject.tempo-prepar.
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
        WHEN "pto-controle":U THEN ASSIGN pFieldValue = RowObject.pto-controle.
        WHEN "rev-ferramentas":U THEN ASSIGN pFieldValue = RowObject.rev-ferramentas.
        WHEN "rev-ficha-oper":U THEN ASSIGN pFieldValue = RowObject.rev-ficha-oper.
        WHEN "rev-item-consumo":U THEN ASSIGN pFieldValue = RowObject.rev-item-consumo.
        WHEN "tipo-oper":U THEN ASSIGN pFieldValue = RowObject.tipo-oper.
        WHEN "un-ciclo":U THEN ASSIGN pFieldValue = RowObject.un-ciclo.
        WHEN "un-med-tempo":U THEN ASSIGN pFieldValue = RowObject.un-med-tempo.
        WHEN "fator-sobrep":U THEN ASSIGN pFieldValue = RowObject.fator-sobrep.
        WHEN "fi-codigo":U THEN ASSIGN pFieldValue = RowObject.fi-codigo.
        WHEN "form-hom":U THEN ASSIGN pFieldValue = RowObject.form-hom.
        WHEN "form-maq":U THEN ASSIGN pFieldValue = RowObject.form-maq.
        WHEN "form-prep":U THEN ASSIGN pFieldValue = RowObject.form-prep.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "nr-op-simult":U THEN ASSIGN pFieldValue = RowObject.nr-op-simult.
        WHEN "nr-oper-pad":U THEN ASSIGN pFieldValue = RowObject.nr-oper-pad.
        WHEN "nr-unidades":U THEN ASSIGN pFieldValue = RowObject.nr-unidades.
        WHEN "num-id-operacao":U THEN ASSIGN pFieldValue = RowObject.num-id-operacao.
        WHEN "numero-homem":U THEN ASSIGN pFieldValue = RowObject.numero-homem.
        WHEN "op-codigo":U THEN ASSIGN pFieldValue = RowObject.op-codigo.
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
    DEFINE OUTPUT PARAMETER pit-codigo LIKE operacao.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-roteiro LIKE operacao.cod-roteiro NO-UNDO.
    DEFINE OUTPUT PARAMETER pop-codigo LIKE operacao.op-codigo NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pit-codigo = RowObject.it-codigo.
    ASSIGN pcod-roteiro = RowObject.cod-roteiro.
    ASSIGN pop-codigo = RowObject.op-codigo.

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
        WHEN "oper-cq":U THEN ASSIGN pFieldValue = RowObject.oper-cq.
        WHEN "ponto-contr":U THEN ASSIGN pFieldValue = RowObject.ponto-contr.
        WHEN "contr-qualidade":U THEN ASSIGN pFieldValue = RowObject.contr-qualidade.
        WHEN "emite-ficha":U THEN ASSIGN pFieldValue = RowObject.emite-ficha.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "log-operacao-final":U THEN ASSIGN pFieldValue = RowObject.log-operacao-final.
        WHEN "log-operacao-inicial":U THEN ASSIGN pFieldValue = RowObject.log-operacao-inicial.
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
    DEFINE INPUT PARAMETER pit-codigo LIKE operacao.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-roteiro LIKE operacao.cod-roteiro NO-UNDO.
    DEFINE INPUT PARAMETER pop-codigo LIKE operacao.op-codigo NO-UNDO.

    FIND FIRST bfoperacao WHERE
        bfoperacao.it-codigo = pit-codigo AND
        bfoperacao.cod-roteiro = pcod-roteiro AND
        bfoperacao.op-codigo = pop-codigo
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfoperacao THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav²s de rowid e verifica a ocorr¼ncia de erros, caso
          existam erros serÿ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfoperacao)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToNumIdOperacao DBOProgram 
PROCEDURE goToNumIdOperacao :
/*------------------------------------------------------------------------------
  Purpose:    Procura pelo ¡ndice, caso nÆo ache, retorna
        mensagem de erro padrÆo do  EMS
  Parameters: ipar:pnum-id-operacao:ID Opera‡Æo
------------------------------------------------------------------------------*/
    def input parameter pnum-id-operacao as inte no-undo.
            

    FIND FIRST bfoperacao WHERE
        bfoperacao.num-id-operacao = pnum-id-operacao 
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfoperacao THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav²s de rowid e verifica a ocorr¼ncia de erros, caso
          existam erros serÿ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfoperacao)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToOpCodigo DBOProgram 
PROCEDURE goToOpCodigo :
/*------------------------------------------------------------------------------
  Purpose:    Procura pelo ¡ndice, caso nÆo ache, retorna
        mensagem de erro padrÆo do  EMS
  Parameters: ipar1:pop-codigo:Opera‡Æo
              ipar2:pit-codigo:Item    
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pop-codigo as inte no-undo.
    DEFINE INPUT PARAMETER pit-codigo as char no-undo.
        

    FIND FIRST bfoperacao WHERE
        bfoperacao.op-codigo = pop-codigo AND
        bfoperacao.it-codigo = pit-codigo 
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfoperacao THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav²s de rowid e verifica a ocorr¼ncia de erros, caso
          existam erros serÿ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfoperacao)).
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
              RUN openQueryStatic (input "CodRoteiro":U).
           
           when 3 then
              RUN openQueryStatic (input "IdOperSucess":U).
              
           when 4 then
              RUN openQueryStatic (input "IdOperPredec":U).
              
           when 5 then
              RUN openQueryStatic (input "ItCodigo":U).

           when 6 then
              RUN openQueryStatic (input "ByFiltroItCodigo":U).
         
           when 7 then
              RUN openQueryStatic (input "ByFiltroCodRoteiro":U).
              
           when 8 then
              RUN openQueryStatic (input "ByFiltroOpCodigo":U).
   
             
       end case.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByFiltroCodRoteiro DBOProgram 
PROCEDURE openQueryByFiltroCodRoteiro :
/*------------------------------------------------------------------------------
  Purpose:    Busca conjunto de registros da tabela operacao, contendo 
              uma faixa de item inicial e final, roteiro inicial e final,
              opera‡Æo inicial e final. Ordena por roteiro.       
------------------------------------------------------------------------------*/
    open query {&QUERYNAME} for each {&TABLENAME} where
                                     {&TABLENAME}.it-codigo   >= c-i-codigo-ini    and 
                                     {&TABLENAME}.it-codigo   <= c-it-codigo-fim   and
                                     {&TABLENAME}.cod-roteiro >= c-cod-roteiro-ini and 
                                     {&TABLENAME}.cod-roteiro <= c-cod-roteiro-fim and
                                     {&TABLENAME}.op-codigo   >= i-op-codigo-ini   and 
                                     {&TABLENAME}.op-codigo   <= i-op-codigo-fim  
                                      NO-LOCK BY cod-roteiro INDEXED-REPOSITION.

    RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByFiltroItCodigo DBOProgram 
PROCEDURE openQueryByFiltroItCodigo :
/*------------------------------------------------------------------------------
  Purpose:    Busca conjunto de registros da tabela operacao, contendo
              uma faixa de item inicial e final, roteiro inicial e final,
              opera‡Æo inicial e final. Ordena por item.        
------------------------------------------------------------------------------*/
    open query {&QUERYNAME} for each {&TABLENAME} where
                                     {&TABLENAME}.it-codigo   >= c-i-codigo-ini    and 
                                     {&TABLENAME}.it-codigo   <= c-it-codigo-fim   and
                                     {&TABLENAME}.cod-roteiro >= c-cod-roteiro-ini and 
                                     {&TABLENAME}.cod-roteiro <= c-cod-roteiro-fim and
                                     {&TABLENAME}.op-codigo   >= i-op-codigo-ini   and 
                                     {&TABLENAME}.op-codigo   <= i-op-codigo-fim  
                                      NO-LOCK BY it-codigo INDEXED-REPOSITION.

    RETURN "OK":U.

                            
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByFiltroOpCodigo DBOProgram 
PROCEDURE openQueryByFiltroOpCodigo :
/*------------------------------------------------------------------------------
  Purpose:     Busca conjunto de registros da tabela operacao, contendo
              uma faixa de item inicial e final, roteiro inicial e final,
              opera‡Æo inicial e final. Ordena por opera‡Æo.           
------------------------------------------------------------------------------*/
    open query {&QUERYNAME} for each {&TABLENAME} where
                                     {&TABLENAME}.it-codigo   >= c-i-codigo-ini    and 
                                     {&TABLENAME}.it-codigo   <= c-it-codigo-fim   and
                                     {&TABLENAME}.cod-roteiro >= c-cod-roteiro-ini and 
                                     {&TABLENAME}.cod-roteiro <= c-cod-roteiro-fim and
                                     {&TABLENAME}.op-codigo   >= i-op-codigo-ini   and 
                                     {&TABLENAME}.op-codigo   <= i-op-codigo-fim  
                                      NO-LOCK BY op-codigo INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCodRoteiro DBOProgram 
PROCEDURE openQueryCodRoteiro :
/*------------------------------------------------------------------------------
  Purpose:     Busca conjunto de registros da tabela operacao 
               conforme o roteiro e que o item seja branco.
  ------------------------------------------------------------------------------*/
    open query {&QUERYNAME} for each {&TABLENAME} WHERE
                                     {&TABLENAME}.cod-roteiro = v_cod_roteiro AND 
                                     {&TABLENAME}.it-codigo   = ""            
                                      NO-LOCK INDEXED-REPOSITION.
                                 
    RETURN "OK":U.
                             

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFiltroZoom DBOProgram 
PROCEDURE openQueryFiltroZoom :
/*------------------------------------------------------------------------------
  Purpose:    Busca conjunto de registros da tabela operacao, contendo
              uma faixa de item inicial e final, roteiro inicial e final,
              opera‡Æo inicial e final,descri‡Æo inicial e final. Ordena 
              de acordo com op‡Æo selecionada.             
------------------------------------------------------------------------------*/
  if i-ordena = 1 then do :  
    open query {&QUERYNAME} for each {&TABLENAME} where 
                                     {&TABLENAME}.it-codigo   >= c-i-codigo-ini    and 
                                     {&TABLENAME}.it-codigo   <= c-it-codigo-fim   and
                                     {&TABLENAME}.cod-roteiro >= c-cod-roteiro-ini and 
                                     {&TABLENAME}.cod-roteiro <= c-cod-roteiro-fim and
                                     {&TABLENAME}.op-codigo   >= i-op-codigo-ini   and 
                                     {&TABLENAME}.op-codigo   <= i-op-codigo-fim   and
                                     {&TABLENAME}.descricao   >= c-descricao-ini   and 
                                     {&TABLENAME}.descricao   <= c-descricao-fim 
                                      NO-LOCK BY it-codigo INDEXED-REPOSITION.
                                         
  end.
  if i-ordena = 2 then do :  
    open query {&QUERYNAME} for each {&TABLENAME} where 
                                     {&TABLENAME}.it-codigo   >= c-i-codigo-ini    and 
                                     {&TABLENAME}.it-codigo   <= c-it-codigo-fim   and
                                     {&TABLENAME}.cod-roteiro >= c-cod-roteiro-ini and 
                                     {&TABLENAME}.cod-roteiro <= c-cod-roteiro-fim and
                                     {&TABLENAME}.op-codigo   >= i-op-codigo-ini   and 
                                     {&TABLENAME}.op-codigo   <= i-op-codigo-fim   and
                                     {&TABLENAME}.descricao   >= c-descricao-ini   and 
                                     {&TABLENAME}.descricao   <= c-descricao-fim 
                                      NO-LOCK BY cod-roteiro INDEXED-REPOSITION.
                                        
  end.
  if i-ordena = 3 then do :  
    open query {&QUERYNAME} for each {&TABLENAME} where 
                                     {&TABLENAME}.it-codigo   >= c-i-codigo-ini    and 
                                     {&TABLENAME}.it-codigo   <= c-it-codigo-fim   and
                                     {&TABLENAME}.cod-roteiro >= c-cod-roteiro-ini and 
                                     {&TABLENAME}.cod-roteiro <= c-cod-roteiro-fim and
                                     {&TABLENAME}.op-codigo   >= i-op-codigo-ini   and 
                                     {&TABLENAME}.op-codigo   <= i-op-codigo-fim   and
                                     {&TABLENAME}.descricao   >= c-descricao-ini   and 
                                     {&TABLENAME}.descricao   <= c-descricao-fim 
                                      NO-LOCK BY op-codigo INDEXED-REPOSITION.
                                        
  end.
  if i-ordena = 4 then do :  
    open query {&QUERYNAME} for each {&TABLENAME} where 
                                     {&TABLENAME}.it-codigo   >= c-i-codigo-ini    and 
                                     {&TABLENAME}.it-codigo   <= c-it-codigo-fim   and
                                     {&TABLENAME}.cod-roteiro >= c-cod-roteiro-ini and 
                                     {&TABLENAME}.cod-roteiro <= c-cod-roteiro-fim and
                                     {&TABLENAME}.op-codigo   >= i-op-codigo-ini   and 
                                     {&TABLENAME}.op-codigo   <= i-op-codigo-fim   and
                                     {&TABLENAME}.descricao   >= c-descricao-ini   and 
                                     {&TABLENAME}.descricao   <= c-descricao-fim 
                                      NO-LOCK BY descricao INDEXED-REPOSITION.
                                         
  end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryIdOperPredec DBOProgram 
PROCEDURE openQueryIdOperPredec :
/*------------------------------------------------------------------------------
  Purpose:     Busca conjunto de registros da tabela operacao, conforme o 
               N£mero Identificador Opera‡Æo Predecessora.      
------------------------------------------------------------------------------*/
  open query {&QUERYNAME} for each {&TABLENAME} WHERE
                                   {&TABLENAME}.num-id-operacao = i-num-id-operacao-predec
                                    NO-LOCK INDEXED-REPOSITION.
                                     
  RETURN "OK":U. 
     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryIdOperSucess DBOProgram 
PROCEDURE openQueryIdOperSucess :
/*------------------------------------------------------------------------------
  Purpose:    Busca conjunto de registros da tabela operacao, conforme 
              o N£mero Identificador Opera‡Æo Sucessora.       
------------------------------------------------------------------------------*/
  open query {&QUERYNAME} for each {&TABLENAME} WHERE
                                   {&TABLENAME}.num-id-operacao = i-num-id-operacao-sucess
                                    NO-LOCK INDEXED-REPOSITION.
                                     
  RETURN "OK":U.                                   

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryItCodigo DBOProgram 
PROCEDURE openQueryItCodigo :
/*------------------------------------------------------------------------------
  Purpose:     Busca conjunto de registros da tabela operacao, 
               conforme o item.         
------------------------------------------------------------------------------*/
   open query {&QUERYNAME} for each {&TABLENAME} WHERE
                                    {&TABLENAME}.it-codigo = c-it-codigo
                                     NO-LOCK INDEXED-REPOSITION.
 
                                         
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
    OPEN QUERY {&QueryName} FOR EACH operacao NO-LOCK INDEXED-REPOSITION.


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
    OPEN QUERY {&QueryName} FOR EACH operacao NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint2 DBOProgram 
PROCEDURE setConstraint2 :
/*------------------------------------------------------------------------------
  Purpose:    Seta as vari veis de controle para queries contendo o roteiro. 
  Parameters: ipar: p_cod_roteiro: Roteiro       
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    
    define input parameter p_cod_roteiro as char no-undo.   
        
            
    run setConstraintCodRoteiro (p_cod_roteiro).
    
    RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint3 DBOProgram 
PROCEDURE setConstraint3 :
/*------------------------------------------------------------------------------
  Purpose:     Seta as vari veis de controle para queries contendo o 
               n£mero identificador opera‡Æo sucessora.
  Parameters:  ipar:p-num-id-operacao-sucess: Nr ID Opera‡Æo Sucessora
         
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    
    define input parameter p-num-id-operacao-sucess as integer no-undo.   
        
            
    run setConstraintIdOperSucess (p-num-id-operacao-sucess).
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint4 DBOProgram 
PROCEDURE setConstraint4 :
/*------------------------------------------------------------------------------
  Purpose:    Seta as vari veis de controle para queries contendo o 
              n£mero identificador opera‡Æo predecessora. 
  Parameters: ipar:p-num-id-operacao-predec:Nr Id Opera‡Æo Predecessora      
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    
    define input parameter p-num-id-operacao-predec as integer no-undo.   
        
            
    run setConstraintIdOperPredec (p-num-id-operacao-predec).
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint5 DBOProgram 
PROCEDURE setConstraint5 :
/*------------------------------------------------------------------------------
  Purpose:   Seta as vari veis de controle para queries contendo o item.  
  Parameters:ipar:p-it-codigo: Item         
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    
   define input parameter p-it-codigo as char no-undo.   
        
            
    run setConstraintItCodigo(p-it-codigo).
    
    
    RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint6 DBOProgram 
PROCEDURE setConstraint6 :
/*------------------------------------------------------------------------------
  Purpose:     Seta as vari veis de controle para queries contendo o 
               item inicial e final, o roteiro inicial e final, 
               a opera‡Æo inicial e final.
  Parameters:  ipar1:p-i-codigo-ini:  Item Inicial
               ipar2:p-it-codigo-fim: Item Final
               ipar3:p-cod-roteiro-ini: Roteiro Inicial
               ipar4:p-cod-roteiro-fim: Roteiro Final
               ipar5:p-op-codigo-ini:   Opera‡Æo Inicial
               ipar6:p-op-codigo-fim:   Opera‡Æo Final              
------------------------------------------------------------------------------*/
  def input param p-i-codigo-ini    as char no-undo.
  def input param p-it-codigo-fim   as char no-undo.
  def input param p-cod-roteiro-ini as char no-undo.
  def input param p-cod-roteiro-fim as char no-undo.
  def input param p-op-codigo-ini   as char no-undo.
  def input param p-op-codigo-fim   as char no-undo.
  
    run setConstraintFiltro(p-i-codigo-ini,
                            p-it-codigo-fim,
                            p-cod-roteiro-ini,
                            p-cod-roteiro-fim,
                            p-op-codigo-ini,
                            p-op-codigo-fim).
    
    
    RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCodRoteiro DBOProgram 
PROCEDURE setConstraintCodRoteiro :
/*------------------------------------------------------------------------------
  Purpose:     Seta as vari veis de controle para queries contendo o roteiro. 
  Parameters: ipar: pcod-roteiro: Roteiro   
  ------------------------------------------------------------------------------*/
    define input parameter pcod-roteiro as char no-undo.
          
      assign v_cod_roteiro = pcod-roteiro.

                               
      RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFiltro DBOProgram 
PROCEDURE setConstraintFiltro :
/*------------------------------------------------------------------------------
  Purpose:     Seta as vari veis de controle para queries contendo o 
               item inicial e final, o roteiro inicial e final, 
               a opera‡Æo inicial e final.
  Parameters:  ipar1:pit-codigo-ini:   Item Inicial
               ipar2:pit-codigo-fim:   Item Final
               ipar3:pcod-roteiro-ini: Roteiro Inicial
               ipar4:pcod-roteiro-fim: Roteiro Final
               ipar5:pop-codigo-ini:   Opera‡Æo Inicial
               ipar6:pop-codigo-fim:   Opera‡Æo Final   
 ------------------------------------------------------------------------------*/
  def input param pit-codigo-ini    as char no-undo.
  def input param pit-codigo-fim    as char no-undo.
  def input param pcod-roteiro-ini  as char no-undo.
  def input param pcod-roteiro-fim  as char no-undo.
  def input param pop-codigo-ini    as char no-undo.
  def input param pop-codigo-fim    as char no-undo.

     assign c-i-codigo-ini    = pit-codigo-ini   
             c-it-codigo-fim   = pit-codigo-fim  
             c-cod-roteiro-ini = pcod-roteiro-ini
             c-cod-roteiro-fim = pcod-roteiro-fim
             i-op-codigo-ini   = int(pop-codigo-ini)
             i-op-codigo-fim   = int(pop-codigo-fim).
             
     RETURN "OK":U.
             
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFiltroZoom DBOProgram 
PROCEDURE setConstraintFiltroZoom :
/*------------------------------------------------------------------------------
  Purpose:     Seta as vari veis de controle para queries contendo o 
               item inicial e final, o roteiro inicial e final, 
               a opera‡Æo inicial e final, a descri‡Æo inicial e final,ordena‡Æo.
  Parameters:  ipar1:pit-codigo-ini:   Item Inicial
               ipar2:pit-codigo-fim:   Item Final
               ipar3:pcod-roteiro-ini: Roteiro Inicial
               ipar4:pcod-roteiro-fim: Roteiro Final
               ipar5:pop-codigo-ini:   Opera‡Æo Inicial
               ipar6:pop-codigo-fim:   Opera‡Æo Final   
               ipar7:pdescricao-ini:   Descri‡Æo Opera‡Æo Inicial
               ipar8:pdescricao-fim:   Descri‡Æo Opera‡Æo Final 
               ipar9:pordena:          Ordena‡Æo 
------------------------------------------------------------------------------*/
  def input param pit-codigo-ini    as char no-undo.
  def input param pit-codigo-fim    as char no-undo.
  def input param pcod-roteiro-ini  as char no-undo.
  def input param pcod-roteiro-fim  as char no-undo.
  def input param pop-codigo-ini    as char no-undo.
  def input param pop-codigo-fim    as char no-undo.
  def input param pdescricao-ini    as char no-undo.
  def input param pdescricao-fim    as char no-undo.
  def input param pordena           as int no-undo.
  
     assign  c-i-codigo-ini    = pit-codigo-ini   
             c-it-codigo-fim   = pit-codigo-fim  
             c-cod-roteiro-ini = pcod-roteiro-ini
             c-cod-roteiro-fim = pcod-roteiro-fim
             i-op-codigo-ini   = int(pop-codigo-ini)
             i-op-codigo-fim   = int(pop-codigo-fim)
             c-descricao-ini   = pdescricao-ini
             c-descricao-fim   = pdescricao-fim
             i-ordena          = pordena
             .
             
     RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintIdOperPredec DBOProgram 
PROCEDURE setConstraintIdOperPredec :
/*------------------------------------------------------------------------------
  Purpose:     Seta as vari veis de controle para queries contendo o 
              n£mero identificador opera‡Æo predecessora. 
  Parameters: ipar:p-num-id-operacao-predec:Nr Id Opera‡Æo Predecessora      
------------------------------------------------------------------------------*/
  define input parameter pnum-id-operacao-predec as integer no-undo.      

    assign i-num-id-operacao-predec = pnum-id-operacao-predec.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintIdOperSucess DBOProgram 
PROCEDURE setConstraintIdOperSucess :
/*------------------------------------------------------------------------------
  Purpose:     Seta as vari veis de controle para queries contendo o 
               n£mero identificador opera‡Æo sucessora.
  Parameters:  ipar:pnum-id-operacao-sucess: Nr ID Opera‡Æo Sucessora
      
------------------------------------------------------------------------------*/
  define input parameter pnum-id-operacao-sucess as integer no-undo.      

    assign i-num-id-operacao-sucess = pnum-id-operacao-sucess.
    
    RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintItCodigo DBOProgram 
PROCEDURE setConstraintItCodigo :
/*------------------------------------------------------------------------------
  Purpose:    Seta as vari veis de controle para queries contendo o item.  
  Parameters:ipar:pit-codigo: Item   
  ------------------------------------------------------------------------------*/
 define input parameter pit-codigo as char no-undo.
       
    assign c-it-codigo = pit-codigo.
    
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

    DEFINE VARIABLE c-table-label AS CHARACTER   NO-UNDO.
    
    {utp/ut-table.i mgind operacao 1}
    assign c-table-label = return-value.

    /*--- Utilize o par³metro pType para identificar quais as valida»„es a serem
          executadas ---*/
    /*--- Os valores poss­veis para o par³metro s’o: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atrav²s do
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as valida»„es ---*/


    IF RowObject.it-codigo <> "" THEN DO:

        {utp/ut-liter.i ITEM}

        FOR FIRST ITEM
            WHERE ITEM.it-codigo = RowObject.it-codigo NO-LOCK:
        END.

        IF NOT AVAIL ITEM THEN DO:
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="RETURN-VALUE"} 
        END.
    END.
    ELSE IF RowObject.cod-roteiro <> "" THEN DO:

        {utp/ut-liter.i Roteiro_Fabrica‡Æo} 

        FOR FIRST rot-fabric                                                                     
            WHERE rot-fabric.cod-roteiro = RowObject.cod-roteiro NO-LOCK:                                
        END.  

        IF NOT AVAIL rot-fabric THEN DO:

            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="RETURN-VALUE"} 
        END.
    END.

    IF pType = "DELETE":U THEN DO:
        
        if can-find (first rede-pert
                     where rede-pert.num-id-operacao-predec = RowObject.num-id-operacao) then do: 
            {method/svc/errors/inserr.i
                    &ErrorNumber="1004"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"} 
        end.
         
        /*** Verifica se opera»’o ² empregada em alguma estrutura ***/
        if RowObject.cod-roteiro = "" and
           can-find (first estrutura 
                     where estrutura.it-codigo   = RowObject.it-codigo and
                           estrutura.cod-roteiro = RowObject.cod-roteiro and
                           estrutura.op-codigo   = RowObject.op-codigo) then do:

            {utp/ut-table.i mgind estrutura 1}

            {method/svc/errors/inserr.i
                    &ErrorNumber="17"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="c-table-label + '~~~~' + return-value"}
        end.   
        
        if RowObject.cod-roteiro <> "" and
           can-find (first estrutura 
                     where estrutura.cod-roteiro = RowObject.cod-roteiro and
                           estrutura.op-codigo   = RowObject.op-codigo) then do:
            {utp/ut-table.i mgind estrutura 1}
            {method/svc/errors/inserr.i
                      &ErrorNumber="17"
                      &ErrorType="EMS"
                      &ErrorSubType="ERROR"
                      &ErrorParameters="c-table-label + '~~~~' + return-value"}
        end.
       
        /*** Verifica se opera»’o estÿ na tabela ctrab-operac-aloc ***/
        IF  CAN-FIND (FIRST ctrab-operac-aloc WHERE ctrab-operac-aloc.num-id-operacao = RowObject.num-id-operacao
                                                AND ctrab-operac-aloc.op-altern       = 0 ) THEN DO:
            {utp/ut-liter.i Centro_de_Trabalho_Vÿlido_da_Opera»’o_(EN0510) *}
            {method/svc/errors/inserr.i
                &ErrorNumber="5"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="c-table-label + '~~~~' + return-value"}
        END.
        
        IF  CAN-FIND (FIRST area-produc-prefer WHERE area-produc-prefer.num-id-operacao    = RowObject.num-id-operacao
                                                 AND area-produc-prefer.num-operac-alterna = 0) THEN DO:
            {utp/ut-liter.i ærea_de_Produ»’o_Preferencial_da_Opera»’o_(EN0510) *}

            {method/svc/errors/inserr.i
                &ErrorNumber="5"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="c-table-label + '~~~~' + return-value"}
        END.
        /*Verifica se a operacao tem relacionamento com a estruturao do modelo CF0101*/
        FIND FIRST modelo-cf 
             WHERE modelo-cf.item-criado = operacao.it-codigo NO-LOCK NO-ERROR.
        
        IF CAN-FIND(FIRST estr-mod-cf
                    WHERE estr-mod-cf.cod-roteiro = operacao.cod-roteiro
                      AND estr-mod-cf.op-codigo   = operacao.op-codigo
                      AND estr-mod-cf.mo-codigo   = modelo-cf.mo-codigo) THEN DO:
        
            {utp/ut-table.i mgmfg estr-mod-cf 1}
            {method/svc/errors/inserr.i
                &ErrorNumber="17"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="c-table-label + '~~~~' + return-value"}
        END.

        /*Verifica se a RowObject tem relacionamento com a estruturao do modelo CF0101*/
        FIND FIRST modelo-cf 
             WHERE modelo-cf.item-criado = RowObject.it-codigo NO-LOCK NO-ERROR.
        
        IF CAN-FIND(FIRST estr-mod-cf
                    WHERE estr-mod-cf.cod-roteiro = RowObject.cod-roteiro
                      AND estr-mod-cf.op-codigo   = RowObject.op-codigo
                      AND estr-mod-cf.mo-codigo   = modelo-cf.mo-codigo) THEN DO:
        
            {utp/ut-table.i mgmfg estr-mod-cf 1}
            {method/svc/errors/inserr.i
                &ErrorNumber="17"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="c-table-label + '~~~~' + return-value"}
        END.
    END.

    /*--- Verifica ocorr¼ncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


