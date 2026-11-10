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
{include/i-prgvrs.i BOIN308 2.00.00.010 } /*** "010010" 17/06/2025 16:40:48 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN308 MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : 
    Purpose    : O DBO (Datasul Business Objects) ² um programa PROGRESS
                 que cont²m a l½gica de neg½cio e acesso a dados para uma
                 tabela do banco de dados.

    Parameters :

    Notes      : BO da tabela pl-it-calc
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de defini»’o ---*/
&GLOBAL-DEFINE DBOName pl-it-calc
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName pl-it-calc
&GLOBAL-DEFINE TableLabel pl-it-calc
&GLOBAL-DEFINE QueryName qr{&TableName}

/*--- Include com defini»’o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret½rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser id¼ntico ao nome do DBO mas com
      extens’o .i ---*/
{inbo/boin308.i RowObject}

/*--- Include com defini»’o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera»’o da defini»’o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini»’o
      manual da query ---*/
{method/dboqry.i}

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

{cdp/cdcfgman.i} /*Miniflexibiliza‡Æo. Utilizado no EMS 2.03 - NÇO ELIMINAR
                 * Vari vel preprocessador bf_man_203 */

def temp-table tt-quant1 NO-UNDO
    field de-quant         as decimal format " ->>>>,>>>,>>9.99" label "" extent 50
    field nr-linha         as integer
    field tipo             as char format "x(15)" 
    field it-codigo        as char format "x(16)" label "Item"
    field r-rowid          as rowid.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaItemCalcPlano DBOProgram 
PROCEDURE atualizaItemCalcPlano :
/*------------------------------------------------------------------------------
  Purpose:    Atualizar Pl-it-calc quando os Itens do Plano de Produ»’o forem alterados
  Parameters: Na release 2.03: input: C½digo do Plano e C½digo do Item
              Releases Anteriores: input: C½digo do Item
                       
 ------------------------------------------------------------------------------*/
    &IF DEFINED (bf_man_203) &THEN
    def input parameter i-cd-plano as int no-undo.
    &ENDIF
    def input parameter c-it-codigo as char no-undo.
              
    run cdp/cd7000.p(INPUT 3,
                     INPUT c-it-codigo,
                     INPUT "").              

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findFamilia DBOProgram 
PROCEDURE findFamilia :
/*------------------------------------------------------------------------------
  Purpose:    Procura pelo indice, caso nao ache,
              retorna mensagem de erro padrao do EMS.
  Parameters: ipar1:c-fm-codigo:Fam¡lia
              ipar2:c-it-codigo:Item
  ------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    
    def input parameter c-fm-codigo as char no-undo.
    def input parameter c-it-codigo as char no-undo.
    def output parameter pcreturn as char no-undo.
        
        
    RUN openQueryStatic (input "Main":U).
    
    run goToKey (input c-fm-codigo,
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findItem DBOProgram 
PROCEDURE findItem :
/*------------------------------------------------------------------------------
  Purpose:    Procura pelo indice, caso nao ache,
              retorna mensagem de erro padrao do EMS.
  Parameters: ipar1:c-it-codigo:Item
              ipar:i-cd-plano :Plano ( parƒmetro utilizado por bco 203)
 -----------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    
    &IF DEFINED (bf_man_203) &THEN
    def input parameter i-cd-plano as int no-undo.
    &ENDIF
    def input parameter c-it-codigo as char no-undo.
    def output parameter pcreturn as char no-undo.
        
    RUN openQueryStatic (input "Main":U).
    
    &IF DEFINED (bf_man_203) &THEN
    run goToItem (input i-cd-plano,
                  input c-it-codigo).
    &ELSE
    run goToItem (input c-it-codigo).
    &ENDIF
        
    
    if return-value = "OK" then assign pcreturn = "".  /* esse e o valor esperado nas interfaces 1.1 */
    if return-value = "NOK" then do:
        {utp/ut-table.i mgind {&TABLENAME} 1}
        run utp/ut-msgs.p (input "msg":U,
                           input 2,
                           input return-value).
        assign pcreturn =  return-value.  
        /* essa e a mensagem esperada nas interfaces 1.1  qdo n’o acha o registro */
    end.

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
        WHEN "tipo-plano":U THEN ASSIGN pFieldValue = RowObject.tipo-plano.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "fm-codigo":U THEN ASSIGN pFieldValue = RowObject.fm-codigo.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
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
        WHEN "valor-abc":U THEN ASSIGN pFieldValue = RowObject.valor-abc.
        WHEN "consumo-prev":U THEN ASSIGN pFieldValue = RowObject.consumo-prev.
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "fator-refugo":U THEN ASSIGN pFieldValue = RowObject.fator-refugo.
        WHEN "lote-economi":U THEN ASSIGN pFieldValue = RowObject.lote-economi.
        WHEN "lote-minimo":U THEN ASSIGN pFieldValue = RowObject.lote-minimo.
        WHEN "lote-multipl":U THEN ASSIGN pFieldValue = RowObject.lote-multipl.
        WHEN "quant-perda":U THEN ASSIGN pFieldValue = RowObject.quant-perda.
        WHEN "quant-segur":U THEN ASSIGN pFieldValue = RowObject.quant-segur.
        WHEN "saldo":U THEN ASSIGN pFieldValue = RowObject.saldo.
        WHEN "saldo-terc":U THEN ASSIGN pFieldValue = RowObject.saldo-terc.
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
        WHEN "tipo-est-seg":U THEN ASSIGN pFieldValue = RowObject.tipo-est-seg.
        WHEN "tipo-requis":U THEN ASSIGN pFieldValue = RowObject.tipo-requis.
        &IF DEFINED (bf_man_sfc_lc) &THEN
        &ELSE
        WHEN "calc-lead-time":U THEN ASSIGN pFieldValue = RowObject.calc-lead-time.
        &ENDIF
        WHEN "classe-repro":U THEN ASSIGN pFieldValue = RowObject.classe-repro.
        WHEN "cod-obsoleto":U THEN ASSIGN pFieldValue = RowObject.cod-obsoleto.
        WHEN "compr-fabric":U THEN ASSIGN pFieldValue = RowObject.compr-fabric.
        WHEN "demanda":U THEN ASSIGN pFieldValue = RowObject.demanda.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "niv-mais-bai":U THEN ASSIGN pFieldValue = RowObject.niv-mais-bai.
        WHEN "nr-dias-desl":U THEN ASSIGN pFieldValue = RowObject.nr-dias-desl.
        WHEN "periodo-fixo":U THEN ASSIGN pFieldValue = RowObject.periodo-fixo.
        WHEN "politica":U THEN ASSIGN pFieldValue = RowObject.politica.
        WHEN "res-cq-comp":U THEN ASSIGN pFieldValue = RowObject.res-cq-comp.
        WHEN "res-cq-fabri":U THEN ASSIGN pFieldValue = RowObject.res-cq-fabri.
        WHEN "res-for-comp":U THEN ASSIGN pFieldValue = RowObject.res-for-comp.
        WHEN "res-int-comp":U THEN ASSIGN pFieldValue = RowObject.res-int-comp.
        WHEN "ressup-fabri":U THEN ASSIGN pFieldValue = RowObject.ressup-fabri.
        WHEN "tempo-segur":U THEN ASSIGN pFieldValue = RowObject.tempo-segur.
        WHEN "tipo-con-est":U THEN ASSIGN pFieldValue = RowObject.tipo-con-est.
        &IF DEFINED (bf_man_203) &THEN
        WHEN "cd-plano":U THEN ASSIGN pFieldValue = RowObject.cd-plano.
        &ENDIF
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ­ndice FAMILIA
  Parameters:
               retorna valor dos campos do ­ndice FAMILIA
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pfm-codigo LIKE pl-it-calc.fm-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pit-codigo LIKE pl-it-calc.it-codigo NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pfm-codigo = RowObject.fm-codigo.
    ASSIGN pit-codigo = RowObject.it-codigo.

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
        WHEN "cons-tp-seg":U THEN ASSIGN pFieldValue = RowObject.cons-tp-seg.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "pl-estoque":U THEN ASSIGN pFieldValue = RowObject.pl-estoque.
        WHEN "pl-itens":U THEN ASSIGN pFieldValue = RowObject.pl-itens.
        WHEN "pl-ordens":U THEN ASSIGN pFieldValue = RowObject.pl-ordens.
        WHEN "pl-parametro":U THEN ASSIGN pFieldValue = RowObject.pl-parametro.
        WHEN "pl-pedidos":U THEN ASSIGN pFieldValue = RowObject.pl-pedidos.
        WHEN "pl-plano":U THEN ASSIGN pFieldValue = RowObject.pl-plano.
        WHEN "replaneja":U THEN ASSIGN pFieldValue = RowObject.replaneja.
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




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRowidCalc DBOProgram 
PROCEDURE getRowidCalc :
/*------------------------------------------------------------------------------
  Purpose:     Retorna o rowid do registro atual
  Parameters:  o - rowid do registro atual
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE OUTPUT PARAMETER p-rowid as rowid NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN p-rowid = RowObject.r-rowid.

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToItem DBOProgram 
PROCEDURE goToItem :
/*------------------------------------------------------------------------------
  Purpose:    Procura pelo indice, caso nao ache,
              retorna mensagem de erro padrao do EMS.
  Parameters: ipar1:c-it-codigo:Item
              ipar:i-cd-plano :Plano ( parƒmetro utilizado por bco 203)
  ------------------------------------------------------------------------------*/
    &IF DEFINED (bf_man_203) &THEN
    def input parameter i-cd-plano as int no-undo.
    &ENDIF
    def input parameter c-it-codigo as char no-undo.

    
    &IF DEFINED (bf_man_203) &THEN
    FIND FIRST bfpl-it-calc WHERE
        bfpl-it-calc.cd-plano  = i-cd-plano AND
        bfpl-it-calc.it-codigo = c-it-codigo
        NO-LOCK NO-ERROR.
    &ELSE
    FIND FIRST bfpl-it-calc WHERE
        bfpl-it-calc.it-codigo = c-it-codigo
        NO-LOCK NO-ERROR.
    &ENDIF

    /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfpl-it-calc THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav²s de rowid e verifica a ocorr¼ncia de erros, caso
          existam erros serÿ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfpl-it-calc)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ­ndice FAMILIA
  Parameters:
               recebe valor dos campos do ­ndice FAMILIA
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pfm-codigo LIKE pl-it-calc.fm-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo LIKE pl-it-calc.it-codigo NO-UNDO.

    FIND FIRST bfpl-it-calc WHERE
        bfpl-it-calc.fm-codigo = pfm-codigo AND
        bfpl-it-calc.it-codigo = pit-codigo
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfpl-it-calc THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav²s de rowid e verifica a ocorr¼ncia de erros, caso
          existam erros serÿ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfpl-it-calc)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKeyItem DBOProgram 
PROCEDURE goToKeyItem :
/*------------------------------------------------------------------------------
  Purpose:    Procura o primeiro registro de pl-it-calc utilizando o Item
  Parameters: ipar1:c-it-codigo:Item
------------------------------------------------------------------------------*/

    def input parameter c-it-codigo as char no-undo.
    
    FIND FIRST bfpl-it-calc WHERE
        bfpl-it-calc.it-codigo = c-it-codigo
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfpl-it-calc THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav²s de rowid e verifica a ocorr¼ncia de erros, caso
          existam erros serÿ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfpl-it-calc)).
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
    OPEN QUERY {&QueryName} FOR EACH pl-it-calc NO-LOCK INDEXED-REPOSITION.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaRoteiroBenef DBOProgram 
PROCEDURE verificaRoteiroBenef :
/*------------------------------------------------------------------------------
  Purpose:     Verifica se o item possui roteiro para beneficiamento - pl0704
  Parameters:  i - c½digo do item
               o - se possui beneficiamento
  Notes:       
------------------------------------------------------------------------------*/
  
  def input param pit-codigo as char no-undo.
  def output param p-benef   as log  no-undo.
  
  find first rot-item 
       where rot-item.it-codigo = pit-codigo no-lock no-error.
  if  avail rot-item then do:
      for each rot-item where rot-item.it-codigo = pit-codigo no-lock:
          find rot-fabric where rot-fabric.cod-roteiro = rot-item.cod-roteiro
               no-lock no-error.
          if  rot-fabric.situacao = 2 then next.
              find first operacao 
                   where operacao.it-codigo   = ""
                     and operacao.cod-roteiro = rot-item.cod-roteiro no-lock no-error.
          if avail operacao then do:
             assign p-benef = yes.
             leave.
          end.
      end.
  end.
  else do:
       find first operacao
            where operacao.it-codigo   = pit-codigo
              and operacao.cod-roteiro = " "
              and operacao.tipo-oper        = 2 no-lock no-error.
       if avail operacao then do:
          assign p-benef = yes.
       end.
  end.

  RETURN "OK":U.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
 
