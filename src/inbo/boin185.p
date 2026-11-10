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
{include/i-prgvrs.i BOIN185 2.00.00.025 } /*** "010025" 23/11/2023 16:19:44  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN185 MUT}
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
&GLOBAL-DEFINE DBOName item-tab
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName item-tab
&GLOBAL-DEFINE TableLabel item-tab
&GLOBAL-DEFINE QueryName qr{&TableName}

/*--- Include com defini»’o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret½rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser id¼ntico ao nome do DBO mas com
      extens’o .i ---*/
{inbo/boin185.i RowObject}

/*--- Include com defini»’o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera»’o da defini»’o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini»’o
      manual da query ---*/
{method/dboqry.i}

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bfitem-tab FOR {&TableName}.
DEFINE BUFFER bftb-pr-cc FOR tb-pr-cc.

/*-------------Defini‡Æo para SetconstraintItCodigo------------*/
def var r-rowid-item   as rowid no-undo.

/*-------------Defini‡Æo para linkToItem------------*/
def var cit-codigo     as char no-undo.
def var i-moeda-g      as integer no-undo.
def var l-tab-ati      as logical no-undo.
def var l-tabela-g     as logical no-undo.
def var da-conv-g      as date no-undo.
def var c-item         as char no-undo.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculaPrecoConvItemTab DBOProgram 
PROCEDURE calculaPrecoConvItemTab :
/*------------------------------------------------------------------------------
  Purpose: 
    Calcula o preco do item-tab com base na tela de parƒmetros.
    No c lculo ‚ verificada a conversÆo pela cota‡Æo e data informada
  Parameters:  Parƒmetros recebidos para localizar a item-tab para entÆo localizar a respectiva tabela de pre‡o.
                    icod-emitente:  C¢digo do emitente da item-tab
                    cdn-fabrican:   C¢digo do fabricante da item-tab
                    des-referencia: Descrica‡Æo da refˆrencia da item-tab
                    icod-cond-pag:  Condi‡Æo de pagamento da item-tab.
                    cnr-tab:        C¢digo da tabela de pre‡o da item-tab.
                    ddt-inicio:     Data in¡cio da item-tab.
                    citem-codigo:   C¢digo do item da item-tab
                    dquant-min:     Quantidade m¡nima da item-tab.
                    l-conv          Indica qual data deve ser usuada na conversao, a informada ou a da tabela
                    d-conv          Data p/ convers’o da tela de parƒmetros
                    i-moeda-conv    Moeda selecionada da tela de parƒmetros     
                    ccod-estabel:   Estabelecimento da item-tab
                    imo-codigo:     Moeda da item-tab.
                    d-preco-conv    Pre‡o do item calculado.
  Notes:       
----------------------------------------------------------------------------*/
    define input  parameter icod-emitente   as int     no-undo.
    define input  parameter icdn-fabrican   as int     no-undo.
    define input  parameter cdes-referencia as char    no-undo.
    define input  parameter icod-cond-pag   as int     no-undo.
    define input  parameter cnr-tab         as char    no-undo.
    define input  parameter ddt-inicio      as date    no-undo.
    define input  parameter citem-codigo    as char    no-undo.
    define input  parameter dquant-min      as dec     no-undo.
    define input  parameter l-conv          as logical no-undo.
    define input  parameter d-conv          as date    no-undo.
    define input  parameter i-moeda-conv    as int     no-undo.
    DEFINE INPUT  PARAMETER ccod-estabel    LIKE estabelec.cod-estabel NO-UNDO.
    DEFINE INPUT  PARAMETER imo-codigo      LIKE moeda.mo-codigo       NO-UNDO.
    define output parameter d-preco-conv    LIKE item-tab.pr-item      NO-UNDO.

    def var da-data as date no-undo. /* data p/ conversÆo */
    
    find last item-tab use-index tab-item  
                  where item-tab.cod-emitente   = icod-emitente
                  and   item-tab.cdn-fabrican   = icdn-fabrican           
                  and   item-tab.des-referencia = cdes-referencia 
                  and   item-tab.cod-cond-pag   = icod-cond-pag
                  and   item-tab.nr-tab         = cnr-tab           
                  and   item-tab.dt-inicio      = ddt-inicio 
                  and   item-tab.it-codigo      = citem-codigo
                  AND   item-tab.cod-estabel    = ccod-estabel
                  AND   item-tab.mo-codigo      = imo-codigo
                  and   item-tab.quant-min     <= dquant-min
                  no-lock no-error.
         
    if available item-tab then do:

        find tb-pr-cc
            where tb-pr-cc.nr-tab       = item-tab.nr-tab
            and   tb-pr-cc.nome-abrev   = item-tab.nome-abrev
            and   tb-pr-cc.cod-cond-pag = item-tab.cod-cond-pag
            AND   tb-pr-cc.cod-estabel  = item-tab.cod-estabel
            AND   tb-pr-cc.mo-codigo    = item-tab.mo-codigo no-lock no-error. 
                
         if avail tb-pr-cc and tb-pr-cc.mo-codigo = i-moeda-conv then 
            assign d-preco-conv = item-tab.pr-item.

         else do:
            if avail tb-pr-cc then do:
            
                if l-conv then
                    da-data = tb-pr-cc.dt-inicio.                                                  
                else 
                    da-data = d-conv. 

                run "cdp/cd0812.p" (input tb-pr-cc.mo-codigo,
                                    input i-moeda-conv,
                                    input item-tab.pr-item,
                                    input da-data,
                                    output d-preco-conv).
                                    
                if d-preco-conv = ? then d-preco-conv = 0. 
            end.
            else assign d-preco-conv = 0. 
        end.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculaPrecoUnInterna DBOProgram 
PROCEDURE calculaPrecoUnInterna :
/*-------------------------------------------------------------------------------
  Purpose: 
    Calcula o preco da unidade interna com o fator de conversÆo.
    Retorna a un de medida do relacionamento item fornecedor
  Parameters: 
    ipar1 : i-it-codigo: Recebe o item da tabela item-tab.it-codigo
    ipar2 : i-cod-emitente: Recebe o codigo do emitente da tabela i-cod-emitente
    ipar3 : de-preco-un-int: Retorna o pre‡o na unidade interna
    ipar4 : c-unid-med-int: Retorna a unidade de medida do relacionamento item
    fornecedor se existir, senÆo a unidade que estiver no cadastro do item.
    
  Notes:       
-------------------------------------------------------------------------------*/
    define input  parameter i-it-codigo     like item-tab.it-codigo no-undo.
    define input  parameter i-cod-emitente  like item-tab.cod-emitente no-undo.
    define output parameter de-preco-un-int like item-tab.pr-item no-undo.
    define output parameter c-unid-med-int  as CHAR NO-UNDO.

    DEFINE VAR de-indice-int AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999" NO-UNDO.
    
    find item 
         where item.it-codigo = i-it-codigo no-lock no-error.
    if avail item then
        assign c-unid-med-int = item.un.

    find item-fornec 
         where item-fornec.it-codigo    = i-it-codigo
           AND item-fornec.cod-emitente = i-cod-emitente no-lock no-error.
    if avail item-fornec then
        assign c-unid-med-int = item-fornec.unid-med-for.
    
    if avail item-fornec and item-fornec.unid-med-for <> item.un then
        assign de-indice-int = item-fornec.fator-conver / exp(10, item-fornec.num-casa-dec).
    ELSE 
        ASSIGN de-indice-int = 1.

    ASSIGN de-preco-un-int = item-tab.pr-item * de-indice-int.     
    

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
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "nome-abrev":U THEN ASSIGN pFieldValue = RowObject.nome-abrev.
        WHEN "nr-tab":U THEN ASSIGN pFieldValue = RowObject.nr-tab.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
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
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "desco-quant":U THEN ASSIGN pFieldValue = RowObject.desco-quant.
        WHEN "pr-item":U THEN ASSIGN pFieldValue = RowObject.pr-item.
        WHEN "quant-min":U THEN ASSIGN pFieldValue = RowObject.quant-min.
        WHEN "valor-frete":U THEN ASSIGN pFieldValue = RowObject.valor-frete.
        WHEN "aliquota-icm":U THEN ASSIGN pFieldValue = RowObject.aliquota-icm.
        WHEN "aliquota-ipi":U THEN ASSIGN pFieldValue = RowObject.aliquota-ipi.
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
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
        WHEN "situacao":U THEN ASSIGN pFieldValue = RowObject.situacao.
        WHEN "cod-cond-pag":U THEN ASSIGN pFieldValue = RowObject.cod-cond-pag.
        WHEN "mo-codigo":U THEN ASSIGN pFieldValue = RowObject.mo-codigo.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ­ndice ITEM-TAB
  Parameters:
               retorna valor dos campos do ­ndice ITEM-TAB
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pit-codigo LIKE item-tab.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pnome-abrev LIKE item-tab.nome-abrev NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-cond-pag LIKE item-tab.cod-cond-pag NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-tab LIKE item-tab.nr-tab NO-UNDO.
    DEFINE OUTPUT PARAMETER pquant-min LIKE item-tab.quant-min NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE item-tab.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pmo-codigo LIKE item-tab.mo-codigo NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pit-codigo = RowObject.it-codigo
           pnome-abrev = RowObject.nome-abrev
           pcod-cond-pag = RowObject.cod-cond-pag
           pnr-tab = RowObject.nr-tab
           pquant-min = RowObject.quant-min
           pcod-estabel = RowObject.cod-estabel
           pmo-codigo = RowObject.mo-codigo.

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
        WHEN "frete":U THEN ASSIGN pFieldValue = RowObject.frete.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ­ndice ITEM-TAB
  Parameters:
               recebe valor dos campos do ­ndice ITEM-TAB
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pit-codigo LIKE item-tab.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pnome-abrev LIKE item-tab.nome-abrev NO-UNDO.
    DEFINE INPUT PARAMETER pcod-cond-pag LIKE item-tab.cod-cond-pag NO-UNDO.
    DEFINE INPUT PARAMETER pnr-tab LIKE item-tab.nr-tab NO-UNDO.
    DEFINE INPUT PARAMETER pquant-min LIKE item-tab.quant-min NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE item-tab.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pmo-codigo LIKE item-tab.mo-codigo NO-UNDO.

    FIND FIRST bfitem-tab WHERE
        bfitem-tab.it-codigo = pit-codigo AND
        bfitem-tab.nome-abrev = pnome-abrev AND
        bfitem-tab.cod-cond-pag = pcod-cond-pag AND
        bfitem-tab.nr-tab = pnr-tab AND
        bfitem-tab.quant-min = pquant-min AND
        bfitem-tab.cod-estabel = pcod-estabel AND
        bfitem-tab.mo-codigo = pmo-codigo NO-LOCK NO-ERROR.
    
    /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfitem-tab THEN
        RETURN "NOK":U.
    
    /*--- Reposiciona query atrav²s de rowid e verifica a ocorr¼ncia de erros, caso
          existam erros serÿ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfitem-tab)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToItem DBOProgram 
PROCEDURE linkToItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param ph-item as handle no-undo.
    
    RUN GetKey in ph-item (output cit-codigo).
    
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
        when 3 then
           RUN openQueryStatic (input "ByItCodigo":U).
    end case.       

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryByItCodigo DBOProgram 
PROCEDURE OpenQueryByItCodigo :
/*------------------------------------------------------------------------------
  Purpose: Abertura da query conforme item.it-codigo      
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH item-tab WHERE 
        item-tab.it-codigo = cit-codigo NO-LOCK INDEXED-REPOSITION.

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
    OPEN QUERY {&QueryName} FOR EACH item-tab NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint3 DBOProgram 
PROCEDURE setConstraint3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */

  define input parameter p-rowid-item as rowid no-undo.

  run setConstraintByItCodigo(p-rowid-item).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByItCodigo DBOProgram 
PROCEDURE setConstraintByItCodigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter p-rowid-item as rowid no-undo.
    
    assign r-rowid-item = p-rowid-item.
    
    find item where rowid(item) = r-rowid-item no-lock no-error.
    
    assign cit-codigo = item.it-codigo.

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
    
    FIND FIRST rowObject NO-ERROR. 
    
    if avail rowObject then do:
        IF pType = "Create":U OR pType = "Update":U THEN DO:
             /* Verifica se a tabela de preco existe */
            if not can-find(first bftb-pr-cc
                            where bftb-pr-cc.cod-emitente = RowObject.cod-emitente
                              and bftb-pr-cc.nr-tab       = RowObject.nr-tab      
                              and bftb-pr-cc.cod-cond-pag = RowObject.cod-cond-pag
                              and bftb-pr-cc.cod-estabel  = RowObject.cod-estabel 
                              and bftb-pr-cc.mo-codigo    = RowObject.mo-codigo) then do:
                 {utp/ut-liter.i "Tabela_De_Pre‡o_NÆo_Encontrada!" *}
                 {method/svc/errors/inserr.i &ErrorNumber="47"
                                             &ErrorType="EMS":U
                                             &ErrorSubType="ERROR":U
                                             &ErrorParameters=TRIM(RETURN-VALUE)}
            end.
        END.
        
        IF pType = "Create":U THEN DO:
            /* Verifica se item existe */
            if not can-find(first item where item.it-codigo  = RowObject.it-codigo) and
               not can-find(first item-fornec where item-fornec.it-codigo = RowObject.it-codigo) then do:
                {method/svc/errors/inserr.i &ErrorNumber="56"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U
                                            &ErrorParameters=TRIM(RETURN-VALUE)}
            end.
            
            /* Verifica se o item da tabela importado existe */
            if can-find(first bfitem-tab where
                              bfitem-tab.cod-cond-pag = RowObject.cod-cond-pag
                          and bfitem-tab.cod-emitente = RowObject.cod-emitente 
                          and bfitem-tab.nr-tab       = RowObject.nr-tab
                          and bfitem-tab.cod-estabel  = RowObject.cod-estabel
                          and bfitem-tab.mo-codigo    = RowObject.mo-codigo
                          and bfitem-tab.it-codigo    = RowObject.it-codigo
                          and bfitem-tab.quant-min    = RowObject.quant-min) then do:
                {method/svc/errors/inserr.i &ErrorNumber="1409"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U
                                            &ErrorParameters=TRIM(RETURN-VALUE)}
            end.
        end.
        
        IF pType = "Update":U OR pType = "Delete":U THEN DO:
           if not can-find(first bfitem-tab where
                                 bfitem-tab.cod-cond-pag = RowObject.cod-cond-pag
                             and bfitem-tab.cod-emitente = RowObject.cod-emitente 
                             and bfitem-tab.nr-tab       = RowObject.nr-tab
                             and bfitem-tab.cod-estabel  = RowObject.cod-estabel
                             and bfitem-tab.mo-codigo    = RowObject.mo-codigo
                             and bfitem-tab.it-codigo    = RowObject.it-codigo
                             and bfitem-tab.quant-min    = RowObject.quant-min) then do:
                {method/svc/errors/inserr.i &ErrorNumber="56083"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U
                                            &ErrorParameters=TRIM(RETURN-VALUE)}
            end.
        end.
    END.
    
    /*--- Verifica ocorr¼ncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

