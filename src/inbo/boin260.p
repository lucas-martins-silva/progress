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
{include/i-prgvrs.i BOIN260 2.00.00.004} /*** "010004" 27/10/2023 17:03:44  ***/
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
&GLOBAL-DEFINE DBOName oper-ord
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName oper-ord
&GLOBAL-DEFINE TableLabel oper-ord
&GLOBAL-DEFINE QueryName qr{&TableName}

&GLOBAL-DEFINE KeyField1 nr-ord-produ /*:T Informar os campos da chave quando o Progress nÆo conseguir resolver find {&TableName} OF RowObject. */
&GLOBAL-DEFINE KeyField2 it-codigo /*:T Informar os campos da chave quando o Progress nÆo conseguir resolver find {&TableName} OF RowObject. */
&GLOBAL-DEFINE KeyField3 cod-roteiro /*:T Informar os campos da chave quando o Progress nÆo conseguir resolver find {&TableName} OF RowObject. */
&GLOBAL-DEFINE KeyField4 op-codigo /*:T Informar os campos da chave quando o Progress nÆo conseguir resolver find {&TableName} OF RowObject. */
&GLOBAL-DEFINE XMLProducer YES    /*:T DBO atua como producer de mensagens para o Message Broker */
&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (m‚todo Receive Message) */
&GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES 

/*--- Include com defini»’o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret½rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser id¼ntico ao nome do DBO mas com
      extens’o .i ---*/
{inbo/boin260.i RowObject}

/*--- Include com defini»’o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera»’o da defini»’o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini»’o
      manual da query ---*/
{method/dboqry.i}

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/* Variaveis necessarias aos setConstraint's */

   def var c-nr-ord-produ-aux as char no-undo.
   define variable v-nr-ord-produ as character no-undo.
   define variable v-inicial      as character no-undo.
   define variable v-final        as character no-undo.

{cdp/cdcfgman.i} /*Miniflexibilização. Utilizado no EMS 2.02 - NÃO ELIMINAR
                 * Variável preprocessador bf_man_sfc_lc */
  

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
  Parameters: ipar1:pnr-ord-produ:Ordem Produ‡Æo
              ipar2:pit-codigo:   Item
              ipar3:pcod-roteiro: Roteiro
              ipar4:pop-codigo:   Opera‡Æo 
  Notes:       
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    
    def input parameter pnr-ord-produ as inte no-undo.
    def input parameter pit-codigo as char no-undo.
    def input parameter pcod-roteiro as char no-undo.
    def input parameter pop-codigo as inte no-undo.
    def output parameter pcreturn as char no-undo.
        
        
    RUN openQueryStatic (input "Main":U).
    
    run goToKey (input pnr-ord-produ,
                 input pit-codigo,
                 input pcod-roteiro,
                 input pop-codigo).

    if return-value = "OK" then assign pcreturn = "".  /* esse e o valor esperado nas interfaces 1.1 */
    if return-value = "NOK" then do:
        {utp/ut-table.i movind {&TABLENAME} 1}
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
        WHEN "cd-mob-dir":U THEN ASSIGN pFieldValue = RowObject.cd-mob-dir.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-roteiro":U THEN ASSIGN pFieldValue = RowObject.cod-roteiro.
        WHEN "revisao":U THEN ASSIGN pFieldValue = RowObject.revisao.
        WHEN "descricao":U THEN ASSIGN pFieldValue = RowObject.descricao.
        WHEN "ferramenta":U THEN ASSIGN pFieldValue = RowObject.ferramenta.
        WHEN "gm-codigo":U THEN ASSIGN pFieldValue = RowObject.gm-codigo.
        WHEN "h-fimreal":U THEN ASSIGN pFieldValue = RowObject.h-fimreal.
        WHEN "h-inireal":U THEN ASSIGN pFieldValue = RowObject.h-inireal.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "cod-item-refugo":U THEN ASSIGN pFieldValue = RowObject.cod-item-refugo.
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
        WHEN "data-ult-ent":U THEN ASSIGN pFieldValue = RowObject.data-ult-ent.
        WHEN "data-ult-rep":U THEN ASSIGN pFieldValue = RowObject.data-ult-rep.
        WHEN "dt-fimreal":U THEN ASSIGN pFieldValue = RowObject.dt-fimreal.
        WHEN "dt-inireal":U THEN ASSIGN pFieldValue = RowObject.dt-inireal.
        WHEN "dt-reporte":U THEN ASSIGN pFieldValue = RowObject.dt-reporte.
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
        WHEN "tempo-maq-rep":U THEN ASSIGN pFieldValue = RowObject.tempo-maq-rep.
        WHEN "tempo-maquin":U THEN ASSIGN pFieldValue = RowObject.tempo-maquin.
        WHEN "tempo-prep-rep":U THEN ASSIGN pFieldValue = RowObject.tempo-prep-rep.
        WHEN "tempo-prepar":U THEN ASSIGN pFieldValue = RowObject.tempo-prepar.
        WHEN "preco-ul-ent":U THEN ASSIGN pFieldValue = RowObject.preco-ul-ent.
        WHEN "proporcao":U THEN ASSIGN pFieldValue = RowObject.proporcao.
        WHEN "qt-apr-cond":U THEN ASSIGN pFieldValue = RowObject.qt-apr-cond.
        WHEN "qt-produzida":U THEN ASSIGN pFieldValue = RowObject.qt-produzida.
        WHEN "qt-refugada":U THEN ASSIGN pFieldValue = RowObject.qt-refugada.
        WHEN "refugo-op":U THEN ASSIGN pFieldValue = RowObject.refugo-op.
        WHEN "tempo-hom-rep":U THEN ASSIGN pFieldValue = RowObject.tempo-hom-rep.
        WHEN "tempo-homem":U THEN ASSIGN pFieldValue = RowObject.tempo-homem.
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "nr-up-rep":U THEN ASSIGN pFieldValue = RowObject.nr-up-rep.
        WHEN "nr-ups":U THEN ASSIGN pFieldValue = RowObject.nr-ups.
        WHEN "preco-base":U THEN ASSIGN pFieldValue = RowObject.preco-base.
        WHEN "preco-medio[1]":U THEN ASSIGN pFieldValue = RowObject.preco-medio[1].
        WHEN "preco-medio[2]":U THEN ASSIGN pFieldValue = RowObject.preco-medio[2].
        WHEN "preco-medio[3]":U THEN ASSIGN pFieldValue = RowObject.preco-medio[3].
        WHEN "preco-repos":U THEN ASSIGN pFieldValue = RowObject.preco-repos.
        &IF DEFINED (bf_man_sfc_lc) &THEN
        
        &else
        WHEN "temp-limp-rep":U THEN ASSIGN pFieldValue = RowObject.temp-limp-rep.
        WHEN "tempo-limp":U THEN ASSIGN pFieldValue = RowObject.tempo-limp.
        &endif
        WHEN "val-relac-refugo-item":U THEN ASSIGN pFieldValue = RowObject.val-relac-refugo-item.
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
        WHEN "tipo-oper":U THEN ASSIGN pFieldValue = RowObject.tipo-oper.
        WHEN "un-med-tempo":U THEN ASSIGN pFieldValue = RowObject.un-med-tempo.
        WHEN "pto-controle":U THEN ASSIGN pFieldValue = RowObject.pto-controle.
        WHEN "nr-estrut":U THEN ASSIGN pFieldValue = RowObject.nr-estrut.
        WHEN "sequencia":U THEN ASSIGN pFieldValue = RowObject.sequencia.
        WHEN "estado":U THEN ASSIGN pFieldValue = RowObject.estado.
        WHEN "fator-sobrep":U THEN ASSIGN pFieldValue = RowObject.fator-sobrep.
        WHEN "fi-codigo":U THEN ASSIGN pFieldValue = RowObject.fi-codigo.
        WHEN "form-hom":U THEN ASSIGN pFieldValue = RowObject.form-hom.
        WHEN "form-maq":U THEN ASSIGN pFieldValue = RowObject.form-maq.
        WHEN "form-prep":U THEN ASSIGN pFieldValue = RowObject.form-prep.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "nr-ord-produ":U THEN ASSIGN pFieldValue = RowObject.nr-ord-produ.
        WHEN "nr-ord-refer":U THEN ASSIGN pFieldValue = RowObject.nr-ord-refer.
        WHEN "nr-req-sum":U THEN ASSIGN pFieldValue = RowObject.nr-req-sum.
        WHEN "nr-unidades":U THEN ASSIGN pFieldValue = RowObject.nr-unidades.
        WHEN "num-id-operacao":U THEN ASSIGN pFieldValue = RowObject.num-id-operacao.
        WHEN "numero-homem":U THEN ASSIGN pFieldValue = RowObject.numero-homem.
        WHEN "op-altern":U THEN ASSIGN pFieldValue = RowObject.op-altern.
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
    DEFINE OUTPUT PARAMETER pnr-ord-produ LIKE oper-ord.nr-ord-produ NO-UNDO.
    DEFINE OUTPUT PARAMETER pit-codigo LIKE oper-ord.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-roteiro LIKE oper-ord.cod-roteiro NO-UNDO.
    DEFINE OUTPUT PARAMETER pop-codigo LIKE oper-ord.op-codigo NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pnr-ord-produ = RowObject.nr-ord-produ.
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
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "emite-ficha":U THEN ASSIGN pFieldValue = RowObject.emite-ficha.
        WHEN "oper-cq":U THEN ASSIGN pFieldValue = RowObject.oper-cq.
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
    DEFINE INPUT PARAMETER pnr-ord-produ LIKE oper-ord.nr-ord-produ NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo LIKE oper-ord.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-roteiro LIKE oper-ord.cod-roteiro NO-UNDO.
    DEFINE INPUT PARAMETER pop-codigo LIKE oper-ord.op-codigo NO-UNDO.

    FIND FIRST bfoper-ord WHERE
        bfoper-ord.nr-ord-produ = pnr-ord-produ AND
        bfoper-ord.it-codigo = pit-codigo AND
        bfoper-ord.cod-roteiro = pcod-roteiro AND
        bfoper-ord.op-codigo = pop-codigo
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfoper-ord THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav²s de rowid e verifica a ocorr¼ncia de erros, caso
          existam erros serÿ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfoper-ord)).
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
              RUN openQueryStatic (input "OrdProducao":U).
           
           when 3 then
              RUN openQueryStatic (input "FiltroSeq":U).
          
       end case.
    
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
    OPEN QUERY {&QueryName} FOR EACH oper-ord NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOrdProducao DBOProgram 
PROCEDURE openQueryOrdProducao :
/*------------------------------------------------------------------------------
  Purpose:    Busca conjunto de registros da tabela oper-ord 
              contendo n£mero da ordem de produ‡Æo. 
      
------------------------------------------------------------------------------*/
 open query {&QUERYNAME} for each {&TABLENAME} 
                        where {&TABLENAME}.nr-ord-produ = integer (c-nr-ord-produ-aux)
                        NO-LOCK INDEXED-REPOSITION.
                
   RETURN "OK":U.
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFiltroSeq DBOProgram 
PROCEDURE openQueryFiltroSeq :
/*------------------------------------------------------------------------------
  Purpose:    Busca conjunto de registros da tabela oper-ord 
              contendo n£mero da ordem de produ‡Æo e uma faixa de sequencia.
              Ordena por sequencia. 
      
------------------------------------------------------------------------------*/
                         
     open query {&QUERYNAME} for each {&TABLENAME}
                 where {&TABLENAME}.nr-ord-produ  = integer(v-nr-ord-produ)
                   and {&TABLENAME}.sequencia    >= integer(v-inicial)
                   and {&TABLENAME}.sequencia    <= integer(v-final) 
                   NO-LOCK by {&TABLENAME}.sequencia  INDEXED-REPOSITION.                            
                
   RETURN "OK":U.
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint1 DBOProgram 
PROCEDURE setConstraint1 :
/*------------------------------------------------------------------------------
  Purpose:    Seta as vari veis de controle para queries contendo 
              o n£mero da ordem de produ‡Æo e valores de faixa (inicial e final).  
  Parameters: ipar1:p-nr-ord-produ: Nr Ordem Produ‡Æo
              ipar2:p-inicial:Inicial
              ipar3:p-final:Final
         
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    
    define input parameter p-nr-ord-produ as character no-undo.
    define input parameter p-inicial      as character no-undo.
    define input parameter p-final        as character no-undo.

        
    run setConstraintFiltro (p-nr-ord-produ,
                             p-inicial,
                             p-final).
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint2 DBOProgram 
PROCEDURE setConstraint2 :
/*------------------------------------------------------------------------------
  Purpose:    Seta as vari veis de controle para queries contendo 
              o n£mero da ordem de produ‡Æo.  
  Parameters: ipar:c-nr-ord-produ: Nr Ordem Produ‡Æo
         
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    
    define input parameter c-nr-ord-produ as char no-undo.
        
    run setConstraintOrdProducao (c-nr-ord-produ).
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFiltro DBOProgram 
PROCEDURE setConstraintFiltro :
/*------------------------------------------------------------------------------
  Purpose:    Seta as vari veis de controle para queries contendo 
              o n£mero da ordem de produ‡Æo e valores de faixa (inicial e final).  
  Parameters: ipar1:p-nr-ord-produ: Nr Ordem Produ‡Æo
              ipar2:p-inicial:Inicial
              ipar3:p-final:Final
        
------------------------------------------------------------------------------*/
  
    define input parameter p-nr-ord-produ as character no-undo.
    define input parameter p-inicial      as character no-undo.
    define input parameter p-final        as character no-undo.

    assign v-nr-ord-produ = p-nr-ord-produ
           v-inicial      = p-inicial
           v-final        = p-final.
    
    RETURN "OK":U.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintOrdProducao DBOProgram 
PROCEDURE setConstraintOrdProducao :
/*------------------------------------------------------------------------------
  Purpose:    Seta as vari veis de controle para queries contendo 
              o n£mero da ordem de produ‡Æo.  
  Parameters: ipar:c-nr-ord-produ: Nr Ordem Produ‡Æo
        
------------------------------------------------------------------------------*/
  define input parameter c-nr-ord-produ as char no-undo.

    assign c-nr-ord-produ-aux = c-nr-ord-produ.
    
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
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK.
   RETURN "OK":U.
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
/* _UIB-CODE-BLOCK-END */
