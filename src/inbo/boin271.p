&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
** 
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN271 2.00.01.044 } /*** "010144" 17/06/2025 16:40:47 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i boin271 MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : 
    Purpose    : O DBO (Datasul Business Objects) ‚ um programa PROGRESS
                 que cont‚m a l¢gica de neg¢cio e acesso a dados para uma
                 tabela do banco de dados.

    Parameters :

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName ord-prod
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName ord-prod
&GLOBAL-DEFINE TableLabel ord-prod
&GLOBAL-DEFINE QueryName qr{&TableName}

{cdp/cdcfgman.i}

&GLOBAL-DEFINE KeyField1 nr-ord-produ /*:T Informar os campos da chave quando o Progress nÆo conseguir resolver find {&TableName} OF RowObject. */
&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (m‚todo Receive Message) */
&GLOBAL-DEFINE XMLProducer YES
&GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES

/******************************************************************************************
** TECNICA SEGURANCA ESTABELECIMENTO
******************************************************************************************/ 
{include/i-estab-security.i}
/******************************************************************************************
** TECNICA SEGURANCA ESTABELECIMENTO
******************************************************************************************/

/*--- Include com defini‡Æo da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com
      extensÆo .i ---*/
{inbo/boin271.i RowObject}

{java/boRest.i}

{include/i-epc200.i boin271} /* Definicao tt-epc            */

/** Unificação de Conceitos **/
{cdp/cdunif001.i}

/*--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo
      manual da query ---*/
/*{method/dboqry.i}*/

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/* Variáveis necessárias aos setConstraint's */

def var  l-nao-iniciadas   as log no-undo.
def var  l-liberadas       as log no-undo.
def var  l-alocadas        as log no-undo.
def var  l-separadas       as log no-undo.
def var  l-requisitadas    as log no-undo.
def var  l-iniciadas       as log no-undo.
def var  l-finalizadas     as log no-undo.
def var  l-terminadas      as log no-undo.
def var  l-canceladas      as log no-undo.
def var  l-origem-mi       as log INITIAL YES no-undo.
def var  l-origem-mv       as log INITIAL YES no-undo.
def var  i-nr-ord-produ-ini  as int    no-undo.
def var  i-nr-ord-produ-fim  as int    no-undo.




def var  c-inicial           as char    no-undo.
def var  c-final             as char    no-undo.
def var  c-nr-ord-produ-ini  as char    no-undo.
def var  c-nr-ord-produ-fim  as char    no-undo.
def var  c-nr-ord-produ      as char    no-undo.
def var  c-cod-estab         as char    no-undo.

def var c-it-codigo          like item.it-codigo        no-undo.
def var i-ord-ini            like ord-prod.nr-ord-produ no-undo.
def var i-ord-fim            like ord-prod.nr-ord-produ no-undo.

DEFINE VARIABLE da-inicio-ini  AS DATE FORMAT "99/99/9999"       NO-UNDO.
DEFINE VARIABLE da-inicio-fim  AS DATE FORMAT "99/99/9999"       NO-UNDO.
DEFINE VARIABLE da-termino-ini AS DATE FORMAT "99/99/9999"       NO-UNDO.
DEFINE VARIABLE da-termino-fim AS DATE FORMAT "99/99/9999"       NO-UNDO.


def var  h-cpapi001 as HANDLE NO-UNDO.

{cdp/cdcfgman.i} /*Miniflexibilização. Utilizado no EMS 2.02 - NÃO ELIMINAR
                 * Variável preprocessador bf_man_sfc_lc */
{cdp/cdcfgdis.i}  /* Defini‡Æo dos pr‚-processadores que diferenciam releases*/

def temp-table tt-proces-item no-undo like proces-item.
{cpp/cpapi301.i7} /* GerarListaProcesItem */

/* API - Cria‡Æo ORD-PROD */
/*
{cpp/cpapi301.i}   /* Defini‡Æo das temp-tables */
{cpp/cpapi301.i20} /* f-gera-numero-op */
{cpp/cpapi301.i23} /* f-adiciona-lista */
{cpp/cpapi301.i21} /*pi-valida-ord-prod */ 
{cdp/cd0666.i}     /* Defini‡Æo temp-table de erros */
*/
def var h-boin417   as handle.
def var h-boad049   as handle.
def var h-boad107   as handle.
def var h-boin186   as handle.
def var h-boin084   as handle.
def var h-boin375   as handle.
def var h-boin321   as handle.
def var h-boin481   as handle.
def var h-boin299   as handle.
def var h-boin682   as handle.
def var h-boin281   as handle.
def var h-boin287   as handle.
def var c-pedido    as char no-undo.
def var c-cliente   as char no-undo.
DEF NEW GLOBAL SHARED VAR gr-ord-prod AS rowid NO-UNDO. /* variavel utilizada para posicionar o registro
                                                            ordem de produ‡Æo */


{inbo/boin417.i tt-tab-unidade}
{adbo/boad107.i tt-estabelec}
{inbo/boin186.i tt-lin-prod}
{inbo/boin084.i tt-deposito}
{inbo/boin375.i tt-ref-item}
{inbo/boin321.i tt-planejad}
{inbo/boin299.i tt-periodo}
{inbo/boin281.i tt-param-cp}
{inbo/boin682.i tt-param-global}
{inbo/boin481.i tt-process-prod}

{cep/ceapi030.i}
{cdp/cd0666.i}

FUNCTION f-consiste-datas RETURNS INTEGER  (INPUT dt-trans      AS DATE   ,
                                            INPUT l-testa-medio AS LOGICAL,
                                            INPUT c-it-codigo   AS CHAR   ,
                                            INPUT c-cod-estabel AS CHAR   ,
                                            INPUT i-nr-ord-prod AS INTEGER) in h-cpapi001.

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
         HEIGHT             = 17.08
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE alteraEstadoOrdem DBOProgram 
PROCEDURE alteraEstadoOrdem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define buffer bf-ord-prod for ord-prod.

    def input parameter i-nr-ord-produ as integer no-undo.
    def input parameter i-estado       as integer no-undo.    
    def input parameter c-lote-serie   as char    no-undo.
    def input parameter l-liberada     as logical no-undo. /* Ordem liberada ou nÆo */
    
    find first bf-ord-prod
        where bf-ord-prod.nr-ord-produ = i-nr-ord-produ exclusive-lock no-error.
    if  avail bf-ord-prod then do:
        assign bf-ord-prod.estado     = i-estado 
               bf-ord-prod.lote-serie = c-lote-serie
               bf-ord-prod.log-1      = l-liberada. /* Ordem liberada ou nÆo */
        release bf-ord-prod.
        /*UPC Sayerlack*/
        EMPTY TEMP-TABLE tt-epc.
        {include/i-epc200.i2 &CodEvent='"libera-ordem"'
                             &CodParameter='"nr-ord-prod"'
                             &ValueParameter="string(i-nr-ord-produ)"}
        {include/i-epc201.i "libera-ordem"}
    end.           
               
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizarEstadoOrdem DBOProgram 
PROCEDURE atualizarEstadoOrdem :
/*------------------------------------------------------------------------------
  Purpose:   Atualizar o estado da RowObject conforme o estado da ordem de produ‡Æo.
             Isto ‚ necess rio para que o programa de aloca‡Æo funcione corretamente.
  Parameters: i-nr-ord-produ - n£mero da ordem para ser posicionada. 
------------------------------------------------------------------------------*/
    
    def input parameter i-nr-ord-produ as integer no-undo.

    def buffer b-ord-prod for ord-prod.

    IF  NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    find b-ord-prod
        where b-ord-prod.nr-ord-produ = i-nr-ord-produ no-lock no-error.
    
    assign RowObject.estado = b-ord-prod.estado
           RowObject.sit-aloc = b-ord-prod.sit-aloc.

    return "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE desabilitaCampo DBOProgram 
PROCEDURE desabilitaCampo :
/*------------------------------------------------------------------------------
  Purpose:   Conforme o tipo de custo (mensal,on-line,padrao) este campo será 
             desabilitado.  
  Parameters: opar:c-return:Retorna campo a ser desabilitado        
------------------------------------------------------------------------------*/
   define output parameter c-return as char no-undo.
   define var c-medio as char init "no" no-undo.

   find first param-cp no-lock no-error.
     find estabelec where estabelec.cod-estabel = param-cp.cod-estabel no-lock no-error.
        if avail estabelec then do:
          if estabelec.usa-mensal = yes then
             assign c-medio= "1" .
          if estabelec.usa-on-line = yes then
             assign c-medio= "2".
          if estabelec.usa-padrao = yes then
             assign c-medio="3" .
         end.
      c-return = c-medio.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE estadoOrdem DBOProgram 
PROCEDURE estadoOrdem :
/*------------------------------------------------------------------------------
  Purpose:    Procedimento para retornar o estado da Ordem de Produção
              de acordo com os parâmetros recebidos .
  Parameters: ipar1:p-nr-ordem:Número ordem
              ipar2:p-nao-iniciadas:Não iniciadas
              ipar3:p-liberadas:Liberadas
              ipar4:p-alocadas:Alocadas
              ipar5:p-separadas:Separadas
              ipar6:p-requisitadas:Requisitadas
              ipar7:p-iniciadas:Iniciadas
              ipar8:p-finalizadas:Fianlizadas
              ipar9:p-terminadas:Terminadas
              opar: c-return:Retorna estado da ordem 
  
------------------------------------------------------------------------------*/
    define input  parameter p-nr-ordem     as integer no-undo.
    define input parameter p-nao-iniciadas as char no-undo.
    define input parameter p-liberadas     as char no-undo.
    define input parameter p-alocadas      as char no-undo.
    define input parameter p-separadas     as char no-undo.
    define input parameter p-requisitadas  as char no-undo.
    define input parameter p-iniciadas     as char no-undo.
    define input parameter p-finalizadas   as char no-undo.
    define input parameter p-terminadas    as char no-undo.
    define output parameter c-return       as char    no-undo.
    
    for first {&TABLENAME} fields (nr-ord-produ estado) no-lock
        where {&TABLENAME}.nr-ord-produ = p-nr-ordem and
             (({&TABLENAME}.estado = 1 and p-nao-iniciadas = "yes")  or
              ({&TABLENAME}.estado = 2 and p-liberadas     = "yes")  or   
              ({&TABLENAME}.estado = 3 and p-alocadas      = "yes")  or
              ({&TABLENAME}.estado = 4 and p-separadas     = "yes")  or 
              ({&TABLENAME}.estado = 5 and p-requisitadas  = "yes")  or
              ({&TABLENAME}.estado = 6 and p-iniciadas     = "yes")  or
              ({&TABLENAME}.estado = 7 and p-finalizadas   = "yes")  or
              ({&TABLENAME}.estado = 8 and p-terminadas    = "yes")) :
        &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
            DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
            ASSIGN cAuxTraducao001 = {ininc/i01in271.i 04 {&TABLENAME}.
            run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                                INPUT "",
                                INPUT "").
            ASSIGN  c-return = RETURN-VALUE.estado}.
        &else
            ASSIGN c-return = {ininc/i01in271.i 04 {&TABLENAME}.estado}.
        &endif
    end. 
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findCodigo DBOProgram 
PROCEDURE findCodigo :
/*------------------------------------------------------------------------------
  Purpose:    Procura pelo índice, caso não ache, retorna
               mensagem de erro padrão do  EMS
  Parameters: ipar:i-nr-ord-produ: Número Ordem Produção 
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    
    def input parameter i-nr-ord-produ as integer no-undo.
    def output parameter pcreturn as char no-undo.
        
        
    RUN openQueryStatic (input "Main":U).
    
    run goToKey (input i-nr-ord-produ).

    if return-value = "OK" then assign pcreturn = "".  /* esse e o valor esperado nas interfaces 1.1 */
    if return-value = "NOK" then do:
        {utp/ut-table.i movind {&TABLENAME} 1}
        run utp/ut-msgs.p (input "msg":U,
                           input 2,
                           input return-value).
        assign pcreturn =  return-value.  
        /* essa e a mensagem esperada nas interfaces 1.1  qdo nÆo acha o registro */
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findEstabel DBOProgram 
PROCEDURE findEstabel :
/*------------------------------------------------------------------------------
  Purpose:    Procura pelo índice, caso não ache, retorna
               mensagem de erro padrão do  EMS
  Parameters:ipar1:c-cod-estabel:  Estabelecimento 
             ipar2:i-nr-ord-produ: Número Ordem Produção
             ipar3:c-it-codigo:    Item 
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    
    def input parameter c-cod-estabel as char no-undo.
    def input parameter i-nr-ord-produ as inte no-undo.
    def input parameter c-it-codigo as char no-undo.
    def output parameter pcreturn as char no-undo.
        
        
    RUN openQueryStatic (input "Main":U).
    
    run goToEstabel(input c-cod-estabel,
                    input i-nr-ord-produ,
                    input c-it-codigo).

    if return-value = "OK" then assign pcreturn = "".  /* esse e o valor esperado nas interfaces 1.1 */
    if return-value = "NOK" then do:
        {utp/ut-table.i movind {&TABLENAME} 1}
        run utp/ut-msgs.p (input "msg":U,
                           input 2,
                           input return-value).
        assign pcreturn =  return-value.  
        /* essa e a mensagem esperada nas interfaces 1.1  qdo nÆo acha o registro */
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findItem_emiss DBOProgram 
PROCEDURE findItem_emiss :
/*------------------------------------------------------------------------------
  Purpose:    Procura pelo índice, caso não ache, retorna
        mensagem de erro padrão do  EMS
  Parameters:ipar1:c-it-codigo:Item
             ipar2:da-dt-emissao:Data Emissão
             ipar3:i-nr-ord-produ:Número Ordem Produção   
 ------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    
    def input parameter c-it-codigo as char no-undo.
    def input parameter da-dt-emissao as date no-undo.
    def input parameter i-nr-ord-produ as inte no-undo.
    def output parameter pcreturn as char no-undo.
        
        
    RUN openQueryStatic (input "Main":U).
    
    run goToItemEmiss(input c-it-codigo,
                      input da-dt-emissao,
                      input i-nr-ord-produ).

    if return-value = "OK" then assign pcreturn = "".  /* esse e o valor esperado nas interfaces 1.1 */
    if return-value = "NOK" then do:
        {utp/ut-table.i movind {&TABLENAME} 1}
        run utp/ut-msgs.p (input "msg":U,
                           input 2,
                           input return-value).
        assign pcreturn =  return-value.  
        /* essa e a mensagem esperada nas interfaces 1.1  qdo nÆo acha o registro */
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findLinha DBOProgram 
PROCEDURE findLinha :
/*------------------------------------------------------------------------------
  Purpose:    Procura pelo índice, caso não ache, retorna
        mensagem de erro padrão do  EMS
  Parameters:ipar1:i-nr-linha:Linha Produção
             ipar2:i-nr-ord-produ:Número Ordem Produção
             ipar3:c-it-codigo:Item
  ------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    
    def input parameter i-nr-linha as inte no-undo.
    def input parameter i-nr-ord-produ as inte no-undo.
    def input parameter c-it-codigo as char no-undo.
    def output parameter pcreturn as char no-undo.
        
        
    RUN openQueryStatic (input "Main":U).
    
    run goToLinha (input i-nr-linha,
                   input i-nr-ord-produ,
                   input c-it-codigo).

    if return-value = "OK" then assign pcreturn = "".  /* esse e o valor esperado nas interfaces 1.1 */
    if return-value = "NOK" then do:
        {utp/ut-table.i movind {&TABLENAME} 1}
        run utp/ut-msgs.p (input "msg":U,
                           input 2,
                           input return-value).
        assign pcreturn =  return-value.  
        /* essa e a mensagem esperada nas interfaces 1.1  qdo nÆo acha o registro */
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findOrdProd DBOProgram 
PROCEDURE findOrdProd :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter i-nr-ord-produ as integer no-undo.
    def output parameter pcreturn      as char no-undo.
        
        
    RUN openQueryStatic (input "Main":U).

    run goToKey (input i-nr-ord-produ).

    if return-value = "OK" then assign pcreturn = "".  /* esse e o valor esperado nas interfaces 1.1 */
    if return-value = "NOK" then do:
        {utp/ut-table.i movind {&TABLENAME} 1}
        run utp/ut-msgs.p (input "msg":U,
                           input 2,
                           input return-value).
        assign pcreturn =  return-value.  
        /* essa e a mensagem esperada nas interfaces 1.1  qdo nÆo acha o registro */
    end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findReq_sum DBOProgram 
PROCEDURE findReq_sum :
/*------------------------------------------------------------------------------
  Purpose:    Procura pelo índice, caso não ache, retorna
        mensagem de erro padrão do  EMS
  Parameters:ipar1:i-nr-req-sum:Requisição Sum
             ipar2:i-nr-ord-produ:Número Ordem Produção
             ipar3:c-it-codigo:Item
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    
    def input parameter i-nr-req-sum as inte no-undo.
    def input parameter i-nr-ord-produ as inte no-undo.
    def input parameter c-it-codigo as char no-undo.
    def output parameter pcreturn as char no-undo.
        
        
    RUN openQueryStatic (input "Main":U).
    
    run goToReqSum (input i-nr-req-sum,
                    input i-nr-ord-produ,
                    input c-it-codigo).

    if return-value = "OK" then assign pcreturn = "".  /* esse e o valor esperado nas interfaces 1.1 */
    if return-value = "NOK" then do:
        {utp/ut-table.i movind {&TABLENAME} 1}
        run utp/ut-msgs.p (input "msg":U,
                           input 2,
                           input return-value).
        assign pcreturn =  return-value.  
        /* essa e a mensagem esperada nas interfaces 1.1  qdo nÆo acha o registro */
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "sc-codigo":U THEN ASSIGN pFieldValue = RowObject.sc-codigo.
        WHEN "sc-desp":U THEN ASSIGN pFieldValue = RowObject.sc-desp.
        WHEN "sc-imob":U THEN ASSIGN pFieldValue = RowObject.sc-imob.
        WHEN "un":U THEN ASSIGN pFieldValue = RowObject.un.
        WHEN "usuario-alt":U THEN ASSIGN pFieldValue = RowObject.usuario-alt.
        WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
        WHEN "ct-codigo":U THEN ASSIGN pFieldValue = RowObject.ct-codigo.
        WHEN "ct-desp":U THEN ASSIGN pFieldValue = RowObject.ct-desp.
        WHEN "ct-imob":U THEN ASSIGN pFieldValue = RowObject.ct-imob.
        WHEN "nr-pedido":U THEN ASSIGN pFieldValue = RowObject.nr-pedido.
        WHEN "origem":U THEN ASSIGN pFieldValue = RowObject.origem.
        WHEN "es-codigo":U THEN ASSIGN pFieldValue = RowObject.es-codigo.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "it-inspec":U THEN ASSIGN pFieldValue = RowObject.it-inspec.
        WHEN "item-cotacao":U THEN ASSIGN pFieldValue = RowObject.item-cotacao.
        WHEN "lote-serie":U THEN ASSIGN pFieldValue = RowObject.lote-serie.
        WHEN "narrativa":U THEN ASSIGN pFieldValue = RowObject.narrativa.
        WHEN "nome-abrev":U THEN ASSIGN pFieldValue = RowObject.nome-abrev.
        WHEN "cd-planejado":U THEN ASSIGN pFieldValue = RowObject.cd-planejado.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-depos":U THEN ASSIGN pFieldValue = RowObject.cod-depos.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        when "cod-lista-compon":U then ASSIGN pFieldValue = RowObject.cod-lista-compon.
        when "cod-roteiro":U then ASSIGN pFieldValue = RowObject.cod-roteiro.
        when "hr-efetiv-term":U then ASSIGN pFieldValue = RowObject.hr-efetiv-term.
        when "cod-unid-negoc" then assign pFieldValue = RowObject.cod-unid-negoc.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "data-alt":U THEN ASSIGN pFieldValue = RowObject.data-alt.
        WHEN "dt-emissao":U THEN ASSIGN pFieldValue = RowObject.dt-emissao.
        WHEN "dt-inicio":U THEN ASSIGN pFieldValue = RowObject.dt-inicio.
        WHEN "dt-orig":U THEN ASSIGN pFieldValue = RowObject.dt-orig.
        WHEN "dt-termino":U THEN ASSIGN pFieldValue = RowObject.dt-termino.
        when "dt-efetiv-term":U then ASSIGN pFieldValue = RowObject.dt-efetiv-term.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "qt-perda":U THEN ASSIGN pFieldValue = RowObject.qt-perda.
        WHEN "qt-produzida":U THEN ASSIGN pFieldValue = RowObject.qt-produzida.
        WHEN "qt-refugada":U THEN ASSIGN pFieldValue = RowObject.qt-refugada.
        WHEN "qt-reportada":U THEN ASSIGN pFieldValue = RowObject.qt-reportada.
        WHEN "qt-requisita":U THEN ASSIGN pFieldValue = RowObject.qt-requisita.
        WHEN "qt-apr-cond":U THEN ASSIGN pFieldValue = RowObject.qt-apr-cond.
        WHEN "qt-inicial":U THEN ASSIGN pFieldValue = RowObject.qt-inicial.
        WHEN "qt-ordem":U THEN ASSIGN pFieldValue = RowObject.qt-ordem.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "rep-prod":U THEN ASSIGN pFieldValue = RowObject.rep-prod.
        WHEN "reporte-ggf":U THEN ASSIGN pFieldValue = RowObject.reporte-ggf.
        WHEN "reporte-mob":U THEN ASSIGN pFieldValue = RowObject.reporte-mob.
        WHEN "sequencia":U THEN ASSIGN pFieldValue = RowObject.sequencia.
        WHEN "sit-aloc":U THEN ASSIGN pFieldValue = RowObject.sit-aloc.
        WHEN "tipo":U THEN ASSIGN pFieldValue = RowObject.tipo.
        WHEN "prioridade":U THEN ASSIGN pFieldValue = RowObject.prioridade.
        WHEN "custeio-prop-ggf":U THEN ASSIGN pFieldValue = RowObject.custeio-prop-ggf.
        WHEN "custeio-prop-mat":U THEN ASSIGN pFieldValue = RowObject.custeio-prop-mat.
        WHEN "custeio-prop-mob":U THEN ASSIGN pFieldValue = RowObject.custeio-prop-mob.
        WHEN "dest-manut":U THEN ASSIGN pFieldValue = RowObject.dest-manut.
        WHEN "nr-linha":U THEN ASSIGN pFieldValue = RowObject.nr-linha.
        WHEN "nr-ord-aber":U THEN ASSIGN pFieldValue = RowObject.nr-ord-aber.
        WHEN "nr-ord-produ":U THEN ASSIGN pFieldValue = RowObject.nr-ord-produ.
        WHEN "nr-ord-refer":U THEN ASSIGN pFieldValue = RowObject.nr-ord-refer.
        WHEN "nr-req-sum":U THEN ASSIGN pFieldValue = RowObject.nr-req-sum.
        WHEN "nr-sequencia":U THEN ASSIGN pFieldValue = RowObject.nr-sequencia.
        WHEN "nr-ult-seq":U THEN ASSIGN pFieldValue = RowObject.nr-ult-seq.
        WHEN "num-ord-inv":U THEN ASSIGN pFieldValue = RowObject.num-ord-inv.
        WHEN "estado":U THEN ASSIGN pFieldValue = RowObject.estado.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "nr-entrega":U THEN ASSIGN pFieldValue = RowObject.nr-entrega.
        WHEN "nr-estrut":U THEN ASSIGN pFieldValue = RowObject.nr-estrut.
        WHEN "nr-estrut-filha":U THEN ASSIGN pFieldValue = RowObject.nr-estrut-filha.
        WHEN "nr-ficha":U THEN ASSIGN pFieldValue = RowObject.nr-ficha.
        WHEN "calc-cs-ggf":U THEN ASSIGN pFieldValue = RowObject.calc-cs-ggf.
        WHEN "calc-cs-mat":U THEN ASSIGN pFieldValue = RowObject.calc-cs-mat.
        WHEN "calc-cs-mob":U THEN ASSIGN pFieldValue = RowObject.calc-cs-mob.
        WHEN "cod-gr-cli":U THEN ASSIGN pFieldValue = RowObject.cod-gr-cli.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice CODIGO
  Parameters:
               retorna valor dos campos do ¡ndice CODIGO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnr-ord-produ LIKE ord-prod.nr-ord-produ NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pnr-ord-produ = RowObject.nr-ord-produ.

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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "req-emitida":U THEN ASSIGN pFieldValue = RowObject.req-emitida.
        WHEN "val-per":U THEN ASSIGN pFieldValue = RowObject.val-per.
        WHEN "valorizada":U THEN ASSIGN pFieldValue = RowObject.valorizada.
        WHEN "prod-repet":U THEN ASSIGN pFieldValue = RowObject.prod-repet.
        WHEN "prototipo":U THEN ASSIGN pFieldValue = RowObject.prototipo.
        WHEN "cons-mrp":U THEN ASSIGN pFieldValue = RowObject.cons-mrp.
        WHEN "cons-pmp":U THEN ASSIGN pFieldValue = RowObject.cons-pmp.
        WHEN "emite-ordem":U THEN ASSIGN pFieldValue = RowObject.emite-ordem.
        WHEN "emite-requis":U THEN ASSIGN pFieldValue = RowObject.emite-requis.
        WHEN "enc-mensal":U THEN ASSIGN pFieldValue = RowObject.enc-mensal.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToEstabel DBOProgram 
PROCEDURE goToEstabel :
/*------------------------------------------------------------------------------
  Purpose:    Procura pelo índice, caso não ache, retorna
               mensagem de erro padrão do  EMS
  Parameters:ipar1:pcod-estabel:  Estabelecimento 
             ipar2:pnr-ord-produ: Número Ordem Produção
             ipar3:pit-codigo:    Item 
------------------------------------------------------------------------------*/
    def input parameter pcod-estabel as char no-undo.
    def input parameter pnr-ord-produ as inte no-undo.
    def input parameter pit-codigo as char no-undo.

    FIND FIRST bford-prod WHERE
        bford-prod.cod-estabel = pcod-estabel and
        bford-prod.nr-ord-produ = pnr-ord-produ and
        bford-prod.it-codigo = pit-codigo
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bford-prod THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bford-prod)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToItemEmiss DBOProgram 
PROCEDURE goToItemEmiss :
/*------------------------------------------------------------------------------
  Purpose:    Procura pelo índice, caso não ache, retorna
        mensagem de erro padrão do  EMS
  Parameters:ipar1:pit-codigo:Item
             ipar2:pdt-emissao:Data Emissão
             ipar3:pnr-ord-produ:Número Ordem Produção  
 ------------------------------------------------------------------------------*/
    def input parameter pit-codigo as char no-undo.
    def input parameter pdt-emissao as date no-undo.
    def input parameter pnr-ord-produ as inte no-undo.

    FIND FIRST bford-prod WHERE
        bford-prod.it-codigo = pit-codigo and
        bford-prod.dt-emissao = pdt-emissao and
        bford-prod.nr-ord-produ = pnr-ord-produ
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bford-prod THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bford-prod)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ¡ndice CODIGO
  Parameters:
               recebe valor dos campos do ¡ndice CODIGO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-ord-produ LIKE ord-prod.nr-ord-produ NO-UNDO.

    FIND FIRST bford-prod WHERE
        bford-prod.nr-ord-produ = pnr-ord-produ
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bford-prod THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bford-prod)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToLinha DBOProgram 
PROCEDURE goToLinha :
/*------------------------------------------------------------------------------
  Purpose:    Procura pelo índice, caso não ache, retorna
        mensagem de erro padrão do  EMS
  Parameters:ipar1:pnr-linha:Linha Produção
             ipar2:pnr-ord-produ:Número Ordem Produção
             ipar3:pit-codigo:Item
------------------------------------------------------------------------------*/
    def input parameter pnr-linha as inte no-undo.
    def input parameter pnr-ord-produ as inte no-undo.
    def input parameter pit-codigo as char no-undo.

    FIND FIRST bford-prod WHERE
               bford-prod.nr-linha = pnr-linha and
               bford-prod.nr-ord-produ = pnr-ord-produ and
               bford-prod.it-codigo = pit-codigo
               NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bford-prod THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bford-prod)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToReqSum DBOProgram 
PROCEDURE goToReqSum :
/*------------------------------------------------------------------------------
  Purpose:    Procura pelo índice, caso não ache, retorna
              mensagem de erro padrão do  EMS
  Parameters:ipar1:pnr-req-sum:Requisição Sum
             ipar2:pnr-ord-produ:Número Ordem Produção
             ipar3:pit-codigo:Item
------------------------------------------------------------------------------*/
    def input parameter pnr-req-sum as inte no-undo.
    def input parameter pnr-ord-produ as inte no-undo.
    def input parameter pit-codigo as char no-undo.


    FIND FIRST bford-prod WHERE
               bford-prod.nr-req-sum = pnr-req-sum and
               bford-prod.nr-ord-produ = pnr-ord-produ and
               bford-prod.it-codigo = pit-codigo
               NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bford-prod THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bford-prod)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToPedVenda DBOProgram 
PROCEDURE linkToPedVenda :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param pHandle as handle no-undo.

run getKey in pHandle (output c-cliente,
                       output c-pedido).   

return "OK":U.

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
              RUN openQueryStatic (input "Estado":U).
           
           when 3 then
              RUN openQueryStatic (input "EstFiltroOrdProdu":U).
              
           when 4 then
              RUN openQueryStatic (input "EstFiltroItCodigo":U).
              
           when 5 then
              RUN openQueryStatic (input "OrdProdu":U).

           WHEN 6 THEN
               RUN openQueryStatic (INPUT "AlocaOrdem":U).
   
         
       end case.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryAlocaOrdem DBOProgram 
PROCEDURE openQueryAlocaOrdem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    &Scoped-define KEY-PHRASE {&TABLENAME}.estado < 7  NO-LOCK
    
    &Scoped-define BY-ESTAB-IN BY {&TABLENAME}.nr-ord-produ ~
                               BY {&TABLENAME}.cod-estabel
    
	&Scoped-define BY-ESTAB-AT BY {&TABLENAME}.cod-estabel ~
                               BY {&TABLENAME}.nr-ord-produ

    {include/i-estab-openquery.i}
    
    RETURN "OK":U.

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
    &Scoped-define KEY-PHRASE ({&TABLENAME}.estado      <= 3          and ~
                              ({&TABLENAME}.estado      <> 2          and ~
                               {&TABLENAME}.cod-estabel = c-cod-estab and ~
                               {&TABLENAME}.log-1       = no)) use-index estado no-lock
    
    &Scoped-define BY-ESTAB-IN 
	&Scoped-define BY-ESTAB-AT 

    {include/i-estab-openquery.i}
    
    RETURN "OK":U.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDatas DBOProgram 
PROCEDURE openQueryDatas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &Scoped-define KEY-PHRASE {&TABLENAME}.dt-inicio >= da-inicio-ini   AND ~
                              {&TABLENAME}.dt-inicio <= da-inicio-fim   AND ~
                              {&TABLENAME}.dt-termino >= da-termino-ini AND ~
                              {&TABLENAME}.dt-termino <= da-termino-fim AND ~
                              (({&TABLENAME}.estado = 1 and l-nao-iniciadas ) or ~
                               ({&TABLENAME}.estado = 2 and l-liberadas    )  or ~
                               ({&TABLENAME}.estado = 3 and l-alocadas     )  or ~
                               ({&TABLENAME}.estado = 4 and l-separadas    )  or ~
                               ({&TABLENAME}.estado = 5 and l-requisitadas )  or ~
                               ({&TABLENAME}.estado = 6 and l-iniciadas    )  or ~
                               ({&TABLENAME}.estado = 7 and l-finalizadas  )  or ~
                               ({&TABLENAME}.estado = 8 and l-terminadas   )) no-lock
    
    &Scoped-define BY-ESTAB-IN BY {&TABLENAME}.nr-ord-produ ~
                               BY {&TABLENAME}.cod-estabel
    &Scoped-define BY-ESTAB-AT BY {&TABLENAME}.cod-estabel ~
                               BY {&TABLENAME}.nr-ord-produ
    
    {include/i-estab-openquery.i}
    
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
    
    IF l-estab-security-active THEN DO:
        &Scoped-define KEY-PHRASE TRUE USE-INDEX estabel NO-LOCK
	    &Scoped-define BY-ESTAB-AT 
        
        {include/i-estab-openquery.i}
    END.
    ELSE DO:
        &Scoped-define KEY-PHRASE TRUE NO-LOCK
        &Scoped-define BY-ESTAB-IN 
        
        {include/i-estab-openquery.i}
    END.
    
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryEstado DBOProgram 
PROCEDURE openQueryEstado :
/*------------------------------------------------------------------------------
  Purpose:    Busca conjunto de registros da tabela ord-prod, dentro de uma 
              faixa de estado da ordem. Ordena por número da ordem de produção. 
    
------------------------------------------------------------------------------*/
    &Scoped-define KEY-PHRASE (({&TABLENAME}.estado = 1 and l-nao-iniciadas ) or ~
                               ({&TABLENAME}.estado = 2 and l-liberadas    )  or ~
                               ({&TABLENAME}.estado = 3 and l-alocadas     )  or ~
                               ({&TABLENAME}.estado = 4 and l-separadas    )  or ~
                               ({&TABLENAME}.estado = 5 and l-requisitadas )  or ~
                               ({&TABLENAME}.estado = 6 and l-iniciadas    )  or ~
                               ({&TABLENAME}.estado = 7 and l-finalizadas  )  or ~
                               ({&TABLENAME}.estado = 8 and l-terminadas   )) no-lock
    
    &Scoped-define BY-ESTAB-IN by {&TABLENAME}.nr-ord-produ ~
                               by {&TABLENAME}.cod-estabel
    &Scoped-define BY-ESTAB-AT by {&TABLENAME}.cod-estabel ~
                               by {&TABLENAME}.nr-ord-produ
    
    {include/i-estab-openquery.i}
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryEstFiltroItCodigo DBOProgram 
PROCEDURE openQueryEstFiltroItCodigo :
/*------------------------------------------------------------------------------
  Purpose:    Busca conjunto de registros da tabela ord-prod, dentro de 
              uma faixa de número da ordem de produção inicial e final, 
              e estado da ordem. Ordena por item e data de emissão.  
         
------------------------------------------------------------------------------*/
    &Scoped-define KEY-PHRASE   {&tablename}.it-codigo >= c-inicial AND ~
                                {&tablename}.it-codigo <= c-final   AND ~
                              (({&TABLENAME}.estado = 1 and l-nao-iniciadas ) or ~
                               ({&TABLENAME}.estado = 2 and l-liberadas    )  or ~
                               ({&TABLENAME}.estado = 3 and l-alocadas     )  or ~
                               ({&TABLENAME}.estado = 4 and l-separadas    )  or ~
                               ({&TABLENAME}.estado = 5 and l-requisitadas )  or ~
                               ({&TABLENAME}.estado = 6 and l-iniciadas    )  or ~
                               ({&TABLENAME}.estado = 7 and l-finalizadas  )  or ~
                               ({&TABLENAME}.estado = 8 and l-terminadas   )) no-lock
    
    &Scoped-define BY-ESTAB-IN BY {&tablename}.it-codigo ~
                               BY {&TABLENAME}.dt-emissao ~
                               BY {&TABLENAME}.cod-estabel
    &Scoped-define BY-ESTAB-AT BY {&TABLENAME}.cod-estabel ~
                               BY {&tablename}.it-codigo ~
                               BY {&TABLENAME}.dt-emissao
    
    {include/i-estab-openquery.i}
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryEstFiltroOrdProdu DBOProgram 
PROCEDURE openQueryEstFiltroOrdProdu :
/*------------------------------------------------------------------------------
  Purpose:   Busca conjunto de registros da tabela ord-prod, dentro de uma
            faixa de número da ordem de produção inicial e final, e estado
            da ordem. Ordena por número da ordem de produção.   
         
------------------------------------------------------------------------------*/
    &Scoped-define KEY-PHRASE   {&TABLENAME}.nr-ord-produ >= integer(c-inicial) AND ~
                                {&TABLENAME}.nr-ord-produ <= integer(c-final) AND ~
                              (({&TABLENAME}.estado = 1 and l-nao-iniciadas ) or ~
                               ({&TABLENAME}.estado = 2 and l-liberadas    )  or ~
                               ({&TABLENAME}.estado = 3 and l-alocadas     )  or ~
                               ({&TABLENAME}.estado = 4 and l-separadas    )  or ~
                               ({&TABLENAME}.estado = 5 and l-requisitadas )  or ~
                               ({&TABLENAME}.estado = 6 and l-iniciadas    )  or ~
                               ({&TABLENAME}.estado = 7 and l-finalizadas  )  or ~
                               ({&TABLENAME}.estado = 8 and l-terminadas   )) no-lock 
    
    &Scoped-define BY-ESTAB-IN BY {&TABLENAME}.nr-ord-produ ~
                               BY {&TABLENAME}.cod-estabel
    &Scoped-define BY-ESTAB-AT BY {&TABLENAME}.cod-estabel ~
                               BY {&TABLENAME}.nr-ord-produ
    
    
    {include/i-estab-openquery.i}
    
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryEstOrdProdu DBOProgram 
PROCEDURE openQueryEstOrdProdu :
/*------------------------------------------------------------------------------
  Purpose:  Busca conjunto de registros da tabela ord-prod, dentro de uma
            faixa de numero da ordem de produção inicial e final, e estado
            da ordem. Ordena por numero da ordem de producao. 
 ------------------------------------------------------------------------------*/
    &Scoped-define KEY-PHRASE {&TABLENAME}.nr-ord-produ >= int(c-nr-ord-produ-ini) AND ~
                              {&TABLENAME}.nr-ord-produ <= int(c-nr-ord-produ-fim) AND ~
                              (({&TABLENAME}.estado = 1 and l-nao-iniciadas ) or ~
                              ({&TABLENAME}.estado = 2 and l-liberadas    )  or ~
                              ({&TABLENAME}.estado = 3 and l-alocadas     )  or ~
                              ({&TABLENAME}.estado = 4 and l-separadas    )  or ~
                              ({&TABLENAME}.estado = 5 and l-requisitadas )  or ~
                              ({&TABLENAME}.estado = 6 and l-iniciadas    )  or ~
                              ({&TABLENAME}.estado = 7 and l-finalizadas  )  or ~
                              ({&TABLENAME}.estado = 8 and l-terminadas   )) no-lock
    
    &Scoped-define BY-ESTAB-IN BY {&TABLENAME}.nr-ord-produ ~
                               BY {&TABLENAME}.cod-estabel
    &Scoped-define BY-ESTAB-AT BY {&TABLENAME}.cod-estabel ~
                               BY {&TABLENAME}.nr-ord-produ
    
    {include/i-estab-openquery.i}
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryItCodigo DBOProgram 
PROCEDURE openQueryItCodigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &Scoped-define KEY-PHRASE {&tablename}.it-codigo = c-it-codigo AND ~
                            (({&TABLENAME}.estado = 1 and l-nao-iniciadas ) or ~
                             ({&TABLENAME}.estado = 2 and l-liberadas    )  or ~
                             ({&TABLENAME}.estado = 3 and l-alocadas     )  or ~
                             ({&TABLENAME}.estado = 4 and l-separadas    )  or ~
                             ({&TABLENAME}.estado = 5 and l-requisitadas )  or ~
                             ({&TABLENAME}.estado = 6 and l-iniciadas    )  or ~
                             ({&TABLENAME}.estado = 7 and l-finalizadas  )  or ~
                             ({&TABLENAME}.estado = 8 and l-terminadas   )) no-lock
    
    &Scoped-define BY-ESTAB-IN BY {&TABLENAME}.nr-ord-produ ~
                               BY {&TABLENAME}.dt-emissao ~
                               BY {&TABLENAME}.cod-estabel
    &Scoped-define BY-ESTAB-AT BY {&TABLENAME}.cod-estabel ~
                               BY {&TABLENAME}.nr-ord-produ ~
                               BY {&TABLENAME}.dt-emissao
    
    {include/i-estab-openquery.i}
    
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


    IF l-estab-security-active THEN DO:
        &Scoped-define KEY-PHRASE TRUE USE-INDEX estabel NO-LOCK
        &Scoped-define BY-ESTAB-AT 
        
        {include/i-estab-openquery.i}
    END.
    ELSE DO:
        &Scoped-define KEY-PHRASE TRUE NO-LOCK
        &Scoped-define BY-ESTAB-IN 
        
        {include/i-estab-openquery.i}
    END.
    
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOrdCodigo DBOProgram 
PROCEDURE openQueryOrdCodigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &Scoped-define KEY-PHRASE {&TABLENAME}.it-codigo     = c-it-codigo AND ~
                              {&TABLENAME}.nr-ord-produ >= i-ord-ini   AND ~
                              {&TABLENAME}.nr-ord-produ <= i-ord-fim   AND ~
                            (({&TABLENAME}.estado = 1 and l-nao-iniciadas)  or ~
                             ({&TABLENAME}.estado = 2 and l-liberadas    )  or ~
                             ({&TABLENAME}.estado = 3 and l-alocadas     )  or ~
                             ({&TABLENAME}.estado = 4 and l-separadas    )  or ~
                             ({&TABLENAME}.estado = 5 and l-requisitadas )  or ~
                             ({&TABLENAME}.estado = 6 and l-iniciadas    )  or ~
                             ({&TABLENAME}.estado = 7 and l-finalizadas  )  or ~
                             ({&TABLENAME}.estado = 8 and l-terminadas   )) no-lock
    
    &Scoped-define BY-ESTAB-IN BY {&TABLENAME}.nr-ord-produ ~
                               BY {&TABLENAME}.dt-emissao ~
                               BY {&TABLENAME}.cod-estabel
    &Scoped-define BY-ESTAB-AT BY {&TABLENAME}.cod-estabel ~
                               BY {&TABLENAME}.nr-ord-produ ~
                               BY {&TABLENAME}.dt-emissao
    
    {include/i-estab-openquery.i}
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOrdProdu DBOProgram 
PROCEDURE openQueryOrdProdu :
/*------------------------------------------------------------------------------
  Purpose:   Busca conjunto de registros da tabela ord-prod conforme
             o número da ordem de produção.   
      
------------------------------------------------------------------------------*/
    &Scoped-define KEY-PHRASE {&TABLENAME}.nr-ord-produ = integer(c-nr-ord-produ) no-lock
    &Scoped-define BY-ESTAB-IN 
    &Scoped-define BY-ESTAB-AT
    
    {include/i-estab-openquery.i}
    
    RETURN "OK":U.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryPedVenda DBOProgram 
PROCEDURE openQueryPedVenda :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &Scoped-define KEY-PHRASE ord-prod.nome-abrev = c-cliente and ~
                              ord-prod.nr-pedido  = c-pedido USE-INDEX cliente-ped no-lock
    
    &Scoped-define BY-ESTAB-IN BY ord-prod.nr-ord-produ ~
                               BY ord-prod.cod-estabel
    &Scoped-define BY-ESTAB-AT BY ord-prod.cod-estabel ~
                               BY ord-prod.nr-ord-produ
    
    {include/i-estab-openquery.i}
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PosicionaOrdem DBOProgram 
PROCEDURE PosicionaOrdem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param p-nr-ord-produ like ord-prod.nr-ord-produ no-undo.

if p-nr-ord-produ <> 0 then
   find first ord-prod where
              ord-prod.nr-ord-produ = p-nr-ord-produ no-lock no-error.
else
   find first ord-prod no-lock no-error.                  
    
if avail ord-prod then 
   assign gr-ord-prod = rowid(ord-prod).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint1 DBOProgram 
PROCEDURE setConstraint1 :
/*------------------------------------------------------------------------------
  Purpose:   Seta as variáveis de controle para queries contendo o estado 
             da ordem(não-iniciadas, liberadas, alocadas, separadas, 
             requisitadas, iniciadas, finalizadas, terminadas).  
  Parameters:ipar:p-filtro:Filtro p/ estados da ordem
   
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    
    def input parameter p-filtro as char no-undo.
        
    run setConstraintEstado (p-filtro).
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint2 DBOProgram 
PROCEDURE setConstraint2 :
/*------------------------------------------------------------------------------
  Purpose:    Seta as variáveis de controle para queries contendo a faixa 
              inicial e final do número da ordem de produção, o estado da
              ordem(não-iniciadas, liberadas, alocadas, separadas, requisitadas,
              iniciadas, finalizadas, terminadas). 
  Parameters: ipar1:p-inicial:Inicial
              ipar2:p-final:Final
              ipar3:p-nao-iniciadas:Não iniciadas
              ipar4:p-liberadas:Liberadas
              ipar5:p-alocadas:Alocadas
              ipar6:p-separadas:Separadas
              ipar7:p-requisitadas:Requisitadas
              ipar8:p-iniciadas:Iniciadas
              ipar9:p-finalizadas:Finalizadas
              ipar10:p-terminadas:Terminadas      
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    
  def input parameter p-inicial       as char no-undo.
  def input parameter p-final         as char no-undo.
  def input parameter p-nao-iniciadas as char no-undo.
  def input parameter p-liberadas     as char no-undo.
  def input parameter p-alocadas      as char no-undo.
  def input parameter p-separadas     as char no-undo.
  def input parameter p-requisitadas  as char no-undo.
  def input parameter p-iniciadas     as char no-undo.
  def input parameter p-finalizadas   as char no-undo.
  def input parameter p-terminadas    as char no-undo.

        
    run setConstraintEstFiltro (p-inicial,
                                p-final,
                                p-nao-iniciadas,
                                p-liberadas,
                                p-alocadas,
                                p-separadas,
                                p-requisitadas,
                                p-iniciadas,
                                p-finalizadas,
                                p-terminadas).
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint3 DBOProgram 
PROCEDURE setConstraint3 :
/*------------------------------------------------------------------------------
  Purpose:   Seta as variáveis de controle para queries contendo o número 
             da ordem de produção.  
  Parameters:ipar:p-nr-ord-produ:Número Ordem Produção
        
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    
    def input parameter p-nr-ord-produ as char no-undo.
        
    run setConstraintOrdProdu (p-nr-ord-produ).
    
    RETURN "OK":U.

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
    define input parameter pCodEstab as char.
    
    assign c-cod-estab = pCodEstab.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintDatas DBOProgram 
PROCEDURE setConstraintDatas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters: 
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER inicio-ini        AS DATE FORMAT "99/99/9999" NO-UNDO.
DEF INPUT PARAMETER inicio-fim        AS DATE FORMAT "99/99/9999" NO-UNDO.
DEF INPUT PARAMETER termino-ini       AS DATE FORMAT "99/99/9999" NO-UNDO.
DEF INPUT PARAMETER termino-fim       AS DATE FORMAT "99/99/9999" NO-UNDO.
DEF INPUT PARAMETER log-nao-iniciada  AS LOGICAL                  NO-UNDO.
DEF INPUT PARAMETER log-liberada      AS LOGICAL                  NO-UNDO.
DEF INPUT PARAMETER log-alocada       AS LOGICAL                  NO-UNDO.
DEF INPUT PARAMETER log-separada      AS LOGICAL                  NO-UNDO.
DEF INPUT PARAMETER log-iniciada      AS LOGICAL                  NO-UNDO.
DEF INPUT PARAMETER log-finalizada    AS LOGICAL                  NO-UNDO.
DEF INPUT PARAMETER log-terminada     AS LOGICAL                  NO-UNDO.
DEF INPUT PARAMETER log-requisitada   AS LOGICAL                  NO-UNDO.

ASSIGN da-inicio-ini   = inicio-ini    
       da-inicio-fim   = inicio-fim    
       da-termino-ini  = termino-ini               
       da-termino-fim  = termino-fim               
       l-nao-iniciadas = log-nao-iniciada          
       l-liberadas     = log-liberada              
       l-alocadas      = log-alocada               
       l-separadas     = log-separada                   
       l-iniciadas     = log-iniciada                 
       l-finalizadas   = log-finalizada               
       l-terminadas    = log-terminada               
       l-requisitadas  = log-requisitada.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintEstado DBOProgram 
PROCEDURE setConstraintEstado :
/*------------------------------------------------------------------------------
  Purpose:   Seta as variáveis de controle para queries contendo o estado 
             da ordem(não-iniciadas, liberadas, alocadas, separadas, 
             requisitadas, iniciadas, finalizadas, terminadas).  
  Parameters:ipar:p-filtro:Filtro p/ estados da ordem
  
------------------------------------------------------------------------------*/
  def input parameter pfiltro as char no-undo.
 
  assign l-nao-iniciadas = if entry(1,pfiltro) = "yes" then YES  else NO 
         l-liberadas     = if entry(2,pfiltro) = "yes" then YES  else NO
         l-alocadas      = if entry(3,pfiltro) = "yes" then YES  else NO
         l-separadas     = if entry(4,pfiltro) = "yes" then YES  else NO
         l-requisitadas  = if entry(5,pfiltro) = "yes" then YES  else NO
         l-iniciadas     = if entry(6,pfiltro) = "yes" then YES  else NO
         l-finalizadas   = if entry(7,pfiltro) = "yes" then YES  else NO
         l-terminadas    = if entry(8,pfiltro) = "yes" then YES  else NO.


  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintEstFiltro DBOProgram 
PROCEDURE setConstraintEstFiltro :
/*------------------------------------------------------------------------------
  Purpose:    Seta as variáveis de controle para queries contendo a faixa 
              inicial e final do item, o estado da
              ordem(não-iniciadas, liberadas, alocadas, separadas, requisitadas,
              iniciadas, finalizadas, terminadas). 
  Parameters: ipar1:pinicial:Inicial
              ipar2:pfinal:Final
              ipar3:pnao-iniciadas:Não iniciadas
              ipar4:pliberadas:Liberadas
              ipar5:palocadas:Alocadas
              ipar6:pseparadas:Separadas
              ipar7:prequisitadas:Requisitadas
              ipar8:piniciadas:Iniciadas
              ipar9:pfinalizadas:Finalizadas
              ipar10:pterminadas:Terminadas      
------------------------------------------------------------------------------*/
  def input parameter pinicial       as char no-undo.
  def input parameter pfinal         as char no-undo.
  def input parameter pnao-iniciadas as char no-undo.
  def input parameter pliberadas     as char no-undo.
  def input parameter palocadas      as char no-undo.
  def input parameter pseparadas     as char no-undo.
  def input parameter prequisitadas  as char no-undo.
  def input parameter piniciadas     as char no-undo.
  def input parameter pfinalizadas   as char no-undo.
  def input parameter pterminadas    as char no-undo.

  assign c-inicial = pinicial
         c-final   = pfinal.

  assign l-nao-iniciadas = if pnao-iniciadas = "yes" then YES  else NO
         l-liberadas     = if pliberadas     = "yes" then YES  else NO
         l-alocadas      = if palocadas      = "yes" then YES  else NO
         l-separadas     = if pseparadas     = "yes" then YES  else NO
         l-requisitadas  = if prequisitadas  = "yes" then YES  else NO
         l-iniciadas     = if piniciadas     = "yes" then YES  else NO
         l-finalizadas   = if pfinalizadas   = "yes" then YES  else NO
         l-terminadas    = if pterminadas    = "yes" then YES  else NO.
         
  RETURN "OK":U.       

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintEstOrdProdu DBOProgram 
PROCEDURE setConstraintEstOrdProdu :
/*------------------------------------------------------------------------------
  Purpose:    Seta as variáveis de controle para queries contendo a faixa 
              inicial e final do numero da ordem producao, o estado da
              ordem(nao-iniciadas, liberadas, alocadas, separadas, requisitadas,
              iniciadas, finalizadas, terminadas). 
  Parameters: ipar1:pnr-ord-produ-ini:Ordem Producao Inicial
              ipar2:pnr-ord-produ-fim:Ordem Producao Final
              ipar3:pnao-iniciadas:Não iniciadas
              ipar4:pliberadas:Liberadas
              ipar5:palocadas:Alocadas
              ipar6:pseparadas:Separadas
              ipar7:prequisitadas:Requisitadas
              ipar8:piniciadas:Iniciadas
              ipar9:pfinalizadas:Finalizadas
              ipar10:pterminadas:Terminadas      
 ------------------------------------------------------------------------------*/
  def input parameter pnr-ord-produ-ini  as char no-undo.
  def input parameter pnr-ord-produ-fim  as char no-undo.
  def input parameter pnao-iniciadas as char no-undo.
  def input parameter pliberadas     as char no-undo.
  def input parameter palocadas      as char no-undo.
  def input parameter pseparadas     as char no-undo.
  def input parameter prequisitadas  as char no-undo.
  def input parameter piniciadas     as char no-undo.
  def input parameter pfinalizadas   as char no-undo.
  def input parameter pterminadas    as char no-undo.

  assign c-nr-ord-produ-ini = pnr-ord-produ-ini
         c-nr-ord-produ-fim = pnr-ord-produ-fim.

  assign l-nao-iniciadas = if pnao-iniciadas = "yes" then YES  else NO
         l-liberadas     = if pliberadas     = "yes" then YES  else NO
         l-alocadas      = if palocadas      = "yes" then YES  else NO
         l-separadas     = if pseparadas     = "yes" then YES  else NO
         l-requisitadas  = if prequisitadas  = "yes" then YES  else NO
         l-iniciadas     = if piniciadas     = "yes" then YES  else NO
         l-finalizadas   = if pfinalizadas   = "yes" then YES  else NO
         l-terminadas    = if pterminadas    = "yes" then YES  else NO.
         
  RETURN "OK":U.       

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintItCodigo DBOProgram 
PROCEDURE setConstraintItCodigo :
/*------------------------------------------------------------------------------
  Purpose:    Seta as variáveis de controle para queries contendo a faixa 
              inicial e final do item, o estado da
              ordem(não-iniciadas, liberadas, alocadas, separadas, requisitadas,
              iniciadas, finalizadas, terminadas). 
  Parameters: ipar1:pinicial:Inicial
              ipar2:pfinal:Final
              ipar3:pnao-iniciadas:Não iniciadas
              ipar4:pliberadas:Liberadas
              ipar5:palocadas:Alocadas
              ipar6:pseparadas:Separadas
              ipar7:prequisitadas:Requisitadas
              ipar8:piniciadas:Iniciadas
              ipar9:pfinalizadas:Finalizadas
              ipar10:pterminadas:Terminadas      
------------------------------------------------------------------------------*/
  def input parameter pItCodigo      as char no-undo.
  def input parameter pnao-iniciadas as char no-undo.
  def input parameter pliberadas     as char no-undo.
  def input parameter palocadas      as char no-undo.
  def input parameter pseparadas     as char no-undo.
  def input parameter prequisitadas  as char no-undo.
  def input parameter piniciadas     as char no-undo.
  def input parameter pfinalizadas   as char no-undo.
  def input parameter pterminadas    as char no-undo.

  assign c-it-codigo = pItCodigo.

  assign l-nao-iniciadas = if pnao-iniciadas = "yes" then YES  else NO
         l-liberadas     = if pliberadas     = "yes" then YES  else NO
         l-alocadas      = if palocadas      = "yes" then YES  else NO
         l-separadas     = if pseparadas     = "yes" then YES  else NO
         l-requisitadas  = if prequisitadas  = "yes" then YES  else NO
         l-iniciadas     = if piniciadas     = "yes" then YES  else NO
         l-finalizadas   = if pfinalizadas   = "yes" then YES  else NO
         l-terminadas    = if pterminadas    = "yes" then YES  else NO.
         
  RETURN "OK":U.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintOrdCodigo DBOProgram 
PROCEDURE setConstraintOrdCodigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  def input parameter pItCodigo      as char no-undo.
  def input parameter pOrdIni        as int  no-undo.
  def input parameter pOrdFim        as int  no-undo.
  def input parameter pnao-iniciadas as char no-undo.
  def input parameter pliberadas     as char no-undo.
  def input parameter palocadas      as char no-undo.
  def input parameter pseparadas     as char no-undo.
  def input parameter prequisitadas  as char no-undo.
  def input parameter piniciadas     as char no-undo.
  def input parameter pfinalizadas   as char no-undo.
  def input parameter pterminadas    as char no-undo.


  assign c-it-codigo = pItCodigo
         i-ord-ini   = pOrdIni
         i-ord-fim   = pOrdFim.

  assign l-nao-iniciadas = if pnao-iniciadas = "yes" then YES  else NO
         l-liberadas     = if pliberadas     = "yes" then YES  else NO
         l-alocadas      = if palocadas      = "yes" then YES  else NO
         l-separadas     = if pseparadas     = "yes" then YES  else NO
         l-requisitadas  = if prequisitadas  = "yes" then YES  else NO
         l-iniciadas     = if piniciadas     = "yes" then YES  else NO
         l-finalizadas   = if pfinalizadas   = "yes" then YES  else NO
         l-terminadas    = if pterminadas    = "yes" then YES  else NO.
         
  RETURN "OK":U.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintOrdemManut DBOProgram 
PROCEDURE setConstraintOrdemManut :
/*------------------------------------------------------------------------------
  Purpose:    Seta as variáveis de controle para queries contendo a faixa 
              inicial e final do numero da ordem producao, o estado da
              ordem(nao-iniciadas, liberadas, alocadas, separadas, requisitadas,
              iniciadas, finalizadas, terminadas) e a origem da Ordem (MI, MV, etc). 
  Parameters: ipar1:pnr-ord-produ-ini:Ordem Producao Inicial
              ipar2:pnr-ord-produ-fim:Ordem Producao Final
              ipar3:pnao-iniciadas:Não iniciadas
              ipar4:pliberadas:Liberadas
              ipar5:palocadas:Alocadas
              ipar6:pseparadas:Separadas
              ipar7:prequisitadas:Requisitadas
              ipar8:piniciadas:Iniciadas
              ipar9:pfinalizadas:Finalizadas
              ipar10:pterminadas:Terminadas   
              ipar11:porigemMI:Origem da ordem  do MI
              ipar12:porigemMV:Origem da ordem  do MV
 ------------------------------------------------------------------------------*/
  def input parameter pnr-ord-produ-ini  as int no-undo.
  def input parameter pnr-ord-produ-fim  as int no-undo.
  def input parameter pnao-iniciadas     as log no-undo.
  def input parameter pliberadas         as log no-undo.
  def input parameter palocadas          as log no-undo.
  def input parameter pseparadas         as log no-undo.
  def input parameter prequisitadas      as log no-undo.
  def input parameter piniciadas         as log no-undo.
  def input parameter pfinalizadas       as log no-undo.
  def input parameter pterminadas        as log no-undo.
  def input parameter porigemMI          as log no-undo.
  def input parameter porigemMV          as log no-undo.


  assign i-nr-ord-produ-ini  = pnr-ord-produ-ini              
         i-nr-ord-produ-fim  = pnr-ord-produ-fim              
         l-nao-iniciadas     = pnao-iniciadas                 
         l-liberadas         = pliberadas                     
         l-alocadas          = palocadas                      
         l-separadas         = pseparadas                     
         l-requisitadas      = prequisitadas                  
         l-iniciadas         = piniciadas                     
         l-finalizadas       = pfinalizadas                   
         l-terminadas        = pterminadas                    
         l-origem-mi         = porigemMI
         l-origem-mv         = porigemMV.


return "ok":u.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintOrdProdu DBOProgram 
PROCEDURE setConstraintOrdProdu :
/*------------------------------------------------------------------------------
  Purpose:   Seta as variáveis de controle para queries contendo o número 
             da ordem de produção.  
  Parameters:ipar:pnr-ord-produ:Número Ordem Produção
 
------------------------------------------------------------------------------*/
    def input parameter pnr-ord-produ as char no-undo.
    
    assign c-nr-ord-produ = pnr-ord-produ.
    
    RETURN "OK":U.   

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Valida temptable RowObject
  Parameters:  recebe o tipo de valida‡Æo (Create, Delete, Update)
  Notes:
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    /*--- Utilize o parƒmetro pType para identificar quais as valida‡äes a serem
          executadas ---*/
    /*--- Os valores poss¡veis para o parƒmetro sÆo: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as valida‡äes ---*/

    /*--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaCamposDesmontagem DBOProgram 
PROCEDURE verificaCamposDesmontagem :
/*------------------------------------------------------------------------------
  Purpose:    Este Procedimento Valida os campos do programa wcp0318.w 
              (Desmontagem de item)  
  Parameters:  
       
------------------------------------------------------------------------------*/
def var i-codigo-erro  as integer.    
def var c-ano-periodo  as char.
def var v-dia          as integer.
def var l-deleta-erros as logical.
def var iEmpresa       like param-global.empresa-prin no-undo.

def input  parameter fi_dt_trans                  as date no-undo.
def input  parameter fi_conta_contabil            as char no-undo.
def input  parameter fi_ccusto			          as char no-undo.
def input  parameter fi-reduzida                  as integer no-undo.
def input  parameter fi-it-codigo                 as char no-undo.
def input  parameter fi-cod-estabel               as char no-undo.
def input  parameter fi-cod-depos                 as char no-undo.
def input  parameter fi-cod-localiz               as char no-undo.
def input  parameter fi-un                        as char no-undo.
def input  parameter fi-quantidade                as decimal no-undo.
def input  parameter fi-lote                      as char no-undo. 
def input  parameter fi-nro-docto              as char no-undo. 
def input  parameter fi-serie-docto            as char no-undo. 
def input  parameter fi-conta-contabil-aplicacao  as char no-undo.
def input  parameter fi-ccusto-aplicacao  		  as char no-undo.
def input  parameter fi-reduzida-aplicacao        as integer no-undo.
def output parameter table for RowErrors.
DEFINE VARIABLE c-msg-aux AS CHARACTER   NO-UNDO.

def var l-lote-avancado as log    no-undo.
def var h-ceapi030      as handle no-undo.
def var l-retorno       as log    no-undo.

if can-find(funcao where funcao.cd-funcao = "lote-avancado":u and
                         funcao.ativo) then do:
    assign l-lote-avancado = yes.

    if not valid-handle(h-ceapi030) then
        run cep/ceapi030.p persistent set h-ceapi030 (input table tt-dados-fda,
                                                      output table tt-valores,
                                                      output table tt-erro).
end.

 find first param-global no-lock no-error.

 assign iEmpresa = param-global.empresa-prin.
 &if defined (bf_dis_consiste_conta) &then
     find estabelec where
          estabelec.cod-estabel = ord-prod.cod-estabel no-lock no-error.
     if avail estabelec then do:
        run cdp/cd9970.p (input  rowid(estabelec),
                          output iEmpresa).
     end.
 &endif

 
 find movto-estoq where
              movto-estoq.serie-docto = fi-serie-docto and
              movto-estoq.nro-docto   = fi-nro-docto
              no-lock no-error.
    /* "ATENCAO. Documento ja cadastrado!". */              
 if avail movto-estoq then do:
    {method/svc/errors/inserr.i
            &ErrorNumber="2628" 
            &ErrorType="EMS"
            &ErrorParameters="''"}  
 end.
                         
 assign c-ano-periodo = string((year(fi_dt_trans))) + substring(string(fi_dt_trans),4,2)
        v-dia         = day(fi_dt_trans).    
 
 find first param-estoq no-lock no-error.
   if  param-estoq.tem-moeda1 then do:
       find moeda where moeda.mo-codigo = param-estoq.moeda1 no-lock no-error.
       find cotacao where cotacao.mo-codigo   = param-estoq.moeda1 and
                          cotacao.ano-periodo = c-ano-periodo no-lock no-error.  
       if avail cotacao then do: 
          if cotacao.cotacao[v-dia] = 0  then do:

              ASSIGN c-msg-aux = moeda.descricao + '~~' + string(fi_dt_trans) .
             
             /* NÆo hÿ cota‡Æo para a moeda __ na data __*/
             {method/svc/errors/inserr.i
                     &ErrorNumber="316" 
                     &ErrorType="EMS"
                     &ErrorParameters= c-msg-aux}  
          end.          
  
       end.
   end.   
   if  param-estoq.tem-moeda2 then do:
       find moeda where moeda.mo-codigo = param-estoq.moeda2 no-lock no-error.
       find cotacao where cotacao.mo-codigo   = param-estoq.moeda2 and
                          cotacao.ano-periodo = c-ano-periodo no-lock no-error.
       if avail cotacao and cotacao.cotacao[v-dia] = 0  then do:

           ASSIGN c-msg-aux = moeda.descricao + '~~' + string(fi_dt_trans) .
           
          /* NÆo hÿ cota‡Æo para a moeda __ na data __*/
          {method/svc/errors/inserr.i
                     &ErrorNumber="316" 
                     &ErrorType="EMS"
                     &ErrorParameters=c-msg-aux}
       end.
   end.   
 
 	/* Retorna Dados da Conta. */
	if not valid-handle(h_api_cta_ctbl) then run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.  
	run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input  iEmpresa,          	/* EMPRESA EMS2 */
													input  "",     					/* PLANO CONTAS */ 
													input-output  fi_conta_contabil,     	/* CONTA */
													input  today,  					/* DATA TRANSACAO */
													output v_des_cta_ctbl, 			/* Descrição da Contas. */
													output v_num_tip_cta_ctbl, 		/* Tipo da Conta. 0 = Nenhum, 1 = Despesa, 2 = Receita, 3 = Vendas, 4 = Passivo, 5 = Ativo, 6 = Título. */
													output v_num_sit_cta_ctbl, 		/* Situação da Conta. 1 = Ativada, 2 = Desativada, 3 = Sistema. */
													output v_ind_finalid_cta, 	/* Finalidade da Conta. */
													output table tt_log_erro).      /* ERROS */
        
	if valid-handle(h_api_cta_ctbl) then
		delete object h_api_cta_ctbl.
			
   if not can-find(first tt_log_erro) then do:
		
      if v_num_sit_cta_ctbl <> 3 then do:

         /* "Conta nao e de Sistema". */
         
          {method/svc/errors/inserr.i
                 &ErrorNumber="443"
                 &ErrorType="EMS"
                 &ErrorParameters="''"}  
                       
      end.       

	  DEFINE VARIABLE v_cod_des_finalidades AS CHARACTER.
	  RUN cdp/cdunif004.p (INPUT "5,6,9,10", OUTPUT v_cod_des_finalidades).
      if can-do(v_cod_des_finalidades,string(v_ind_finalid_cta)) then do:
         /* "Conta Invalida". */
         {method/svc/errors/inserr.i
                 &ErrorNumber="288"
                 &ErrorType="EMS"
                 &ErrorParameters="''"}  
                               
      end.   
   end.            
   else do:
 
     /* "Conta  nao cadastrada !". */
      /* Inicio -- Projeto Internacional */
      DEFINE VARIABLE c-lbl-liter-conta AS CHARACTER NO-UNDO.
      {utp/ut-liter.i "Conta" *}
      ASSIGN c-lbl-liter-conta = TRIM(RETURN-VALUE).
      {method/svc/errors/inserr.i
                 &ErrorNumber="56"
                 &ErrorType="EMS"
                 &ErrorParameters="c-lbl-liter-conta"}  
                      
   end.         

   find item where item.it-codigo = fi-it-codigo no-lock no-error.
   if not avail item then do:
      /* "Item nao cadastrado" */
      /* Inicio -- Projeto Internacional */
      {utp/ut-table.i mgind item 1} /* Busca o label da tabela */
      {method/svc/errors/inserr.i
                 &ErrorNumber="56"
                 &ErrorType="EMS"
                 &ErrorParameters="TRIM(RETURN-VALUE)"}
   end.            
   
   if item.cod-obsoleto = 4 then do:
      /* "Item obsoleto". */
       {method/svc/errors/inserr.i
                 &ErrorNumber="563"
                 &ErrorType="EMS"
                 &ErrorParameters="''"}  
              
   end.    

   find estabelec where estabelec.cod-estabel = fi-cod-estabel no-lock no-error.
   if not avail estabelec then do:
      /* "Estabelecimento nao cadastrado". */
       /* Inicio -- Projeto Internacional */
       {utp/ut-table.i mgadm estabelec 1} /* Busca o label da tabela */
       {method/svc/errors/inserr.i
                 &ErrorNumber="56"
                 &ErrorType="EMS"
                 &ErrorParameters="TRIM(RETURN-VALUE)"}
    end.      
   
  find first deposito where
             deposito.cod-depos = fi-cod-depos no-lock no-error.
   if not available deposito then do:
       /* "Deposito nao Cadastrado.". */
       /* Inicio -- Projeto Internacional */
       {utp/ut-table.i mgind deposito 1} /* Busca o label da tabela */
       {method/svc/errors/inserr.i
                 &ErrorNumber="56"
                 &ErrorType="EMS"
                 &ErrorParameters="TRIM(RETURN-VALUE)"}
   end.      
   
   if fi-cod-localiz <> "" then do:
      find localizacao where 
           localizacao.cod-estabel = fi-cod-estabel  and
           localizacao.cod-depos   = fi-cod-depos    and
           localizacao.cod-localiz = fi-cod-localiz
           no-lock no-error.
      if not available localizacao then do:
          /* "Localizacao nao cadastrada !". */
          /* Inicio -- Projeto Internacional */
          {utp/ut-table.i mgind localizacao 1} /* Busca o label da tabela */
          {method/svc/errors/inserr.i
                 &ErrorNumber="56"
                 &ErrorType="EMS"
                 &ErrorParameters="TRIM(RETURN-VALUE)"}
                  
      end.   
   end.   
   
   if fi-un <> item.un then do:
      /* "Unidade de medida deve ser igual a do item !". */
       {method/svc/errors/inserr.i
                 &ErrorNumber="1225"
                 &ErrorType="EMS"
                 &ErrorParameters="''"}  
                       
   end.              
   
   if fi-quantidade <= 0 then do:
       /* "Quantidade deve ser maior que zero". */
       /* Inicio -- Projeto Internacional */
       DEFINE VARIABLE c-lbl-liter-quantidade AS CHARACTER NO-UNDO.
       {utp/ut-liter.i "Quantidade" *}
       ASSIGN c-lbl-liter-quantidade = TRIM(RETURN-VALUE).
       {method/svc/errors/inserr.i
                 &ErrorNumber="36"
                 &ErrorType="EMS"
                 &ErrorParameters="c-lbl-liter-quantidade"}  
   end.
      
   if not item.fraciona and fi-quantidade <> integer(fi-quantidade) then do:
      /* "Quantidade nao pode ser fracionada". */
       {method/svc/errors/inserr.i
                 &ErrorNumber="1222"
                 &ErrorType="EMS"
                 &ErrorParameters="''"}  
                         
   end.      
   
   if item.tipo-con-est = 2 and fi-quantidade <> 1 then do:
      /* Quantidade de item por serie deve ser 1 */
       {method/svc/errors/inserr.i
                 &ErrorNumber="1234"
                 &ErrorType="EMS"
                 &ErrorParameters="''"}  
   end.                          

   find saldo-estoq use-index estabel-dep where
        saldo-estoq.cod-estabel = fi-cod-estabel  and
        saldo-estoq.cod-depos   = fi-cod-depos    and
        saldo-estoq.cod-localiz = fi-cod-localiz  and
        saldo-estoq.lote        = fi-lote         and
        saldo-estoq.it-codigo   = fi-it-codigo  
        no-lock no-error.

   if not available saldo-estoq then do:
      if item.perm-saldo-neg = 1 then do:
         /* "Item sem saldo neste deposito" */      
          {method/svc/errors/inserr.i
                 &ErrorNumber="1793"
                 &ErrorType="EMS"
                 &ErrorParameters="''"}  
                     
      end.
      if item.perm-saldo-neg= 2 then do:
         /* "Item ficara com saldo negativo. Confirma?".*/
         /* assign i-seq-erro = i-seq-erro + 1.
           run utp/ut-msgs.p (input "msg",
                            input 1794  ,
                            input ""    ).                            
            if return-value eq "no" then do:
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 1794
                   tt-bo-erro.mensagem     = return-value.*/  /* Aguarda modifica‡Æo*/
                   
      end.
   end.      
   else do:

      assign l-retorno = yes.

      if l-lote-avancado and
         item.tipo-con-est > 2 then do:

          run pi-identifica-saldo in h-ceapi030 (input 1,
                                                 input saldo-estoq.it-codigo,
                                                 input saldo-estoq.cod-estabel,
                                                 input saldo-estoq.lote,
                                                 input 0,
                                                 output l-retorno,
                                                 output table tt-valores2,
                                                 output table tt-erro).
          if return-value = "nok":u then do:
              for each tt-erro:
                  {method/svc/errors/inserr.i &ErrorNumber="17006"
                                              &ErrorType="EMS"
                                              &ErrorParameters=tt-erro.mensagem}  
              end.
          end.

      end.

	  IF VALID-HANDLE(h-ceapi030) THEN
		  DELETE PROCEDURE h-ceapi030.

      if l-retorno THEN
       
          if fi-quantidade > (saldo-estoq.qtidade-atu  -
                                saldo-estoq.qt-alocada   -
                                saldo-estoq.qt-aloc-prod -
                                saldo-estoq.qt-aloc-ped  ) then do:
              if item.perm-saldo-neg = 1 then do:
                 /* "Item sem saldo neste deposito" */      
                  {method/svc/errors/inserr.i
                         &ErrorNumber="1793"
                         &ErrorType="EMS"
                         &ErrorParameters="''"}  
                                   
              end.
          end.
   end.                 
   
   if (item.tipo-contr = 1  or 
       item.tipo-contr = 3  or
       item.tipo-contr = 4) and
      (fi-conta-contabil-aplicacao = "") then do:
 
       /* "Conta nao cadastrada !". */
       /* Inicio -- Projeto Internacional */
       DEFINE VARIABLE c-lbl-liter-conta-aplicacao AS CHARACTER NO-UNDO.
       {utp/ut-liter.i "Conta_Aplicacao" *}
       ASSIGN c-lbl-liter-conta-aplicacao = TRIM(RETURN-VALUE).
       {method/svc/errors/inserr.i
                 &ErrorNumber="56"
                 &ErrorType="EMS"
                 &ErrorParameters="c-lbl-liter-conta-aplicacao"}  
                                   
   end.               
   
   if fi-conta-contabil-aplicacao <> "" then do: 
   
		/* Retorna Dados da Conta. */
		if not valid-handle(h_api_cta_ctbl) then run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.  
		run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input  iEmpresa,          	/* EMPRESA EMS2 */
														input  "",     					/* PLANO CONTAS */ 
														input-output  fi-conta-contabil-aplicacao, /* CONTA */
														input  today,  					/* DATA TRANSACAO */
														output v_des_cta_ctbl, 			/* Descrição da Contas. */
														output v_num_tip_cta_ctbl, 		/* Tipo da Conta. 0 = Nenhum, 1 = Despesa, 2 = Receita, 3 = Vendas, 4 = Passivo, 5 = Ativo, 6 = Título. */
														output v_num_sit_cta_ctbl, 		/* Situação da Conta. 1 = Ativada, 2 = Desativada, 3 = Sistema. */
														output v_ind_finalid_cta, 	/* Finalidade da Conta. */
														output table tt_log_erro).      /* ERROS */

		if valid-handle(h_api_cta_ctbl) then
			delete object h_api_cta_ctbl.
		
      if not can-find(first tt_log_erro) then do:
         if v_num_sit_cta_ctbl <> 3 then do:
             /* "Conta nao e de Sistema". */
             {method/svc/errors/inserr.i
                 &ErrorNumber="443"
                 &ErrorType="EMS"
                 &ErrorParameters="''"}  
                                  
         end.  

	  RUN cdp/cdunif004.p (INPUT "5,6,9,10", OUTPUT v_cod_des_finalidades).
      if can-do(v_cod_des_finalidades,string(v_ind_finalid_cta)) then do:
            /* "Conta Invalida". */
            {method/svc/errors/inserr.i
                 &ErrorNumber="288"
                 &ErrorType="EMS"
                 &ErrorParameters="''"}  
                                
         end.  
      end.              
      else do:

         /* "Conta Aplicacao nao cadastrada !". */
         /* Inicio -- Projeto Internacional */
         DEFINE VARIABLE c-lbl-liter-conta-aplicacao-2 AS CHARACTER NO-UNDO.
         {utp/ut-liter.i "Conta_Aplicacao" *}
         ASSIGN c-lbl-liter-conta-aplicacao-2 = TRIM(RETURN-VALUE).
         {method/svc/errors/inserr.i
                 &ErrorNumber="56"
                 &ErrorType="EMS"
                 &ErrorParameters="c-lbl-liter-conta-aplicacao-2"}  
                                
      end.         
   end.      

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/*******************************************************************
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOrdemManut DBOProgram 
PROCEDURE openQueryOrdemManut :
/*------------------------------------------------------------------------------
  Purpose:   Busca conjunto de registros da tabela ord-prod, dentro de uma
            faixa de número da ordem de produção inicial e final, e estado
            da ordem, e origem . Ordena por número da ordem de produção.   
         
------------------------------------------------------------------------------*/
    &Scoped-define KEY-PHRASE {&TABLENAME}.nr-ord-produ >= i-nr-ord-produ-ini AND ~
                              {&TABLENAME}.nr-ord-produ <= i-nr-ord-produ-fim AND ~
                            (({&TABLENAME}.estado = 1 and l-nao-iniciadas)  or ~
                             ({&TABLENAME}.estado = 2 and l-liberadas    )  or ~
                             ({&TABLENAME}.estado = 3 and l-alocadas     )  or ~
                             ({&TABLENAME}.estado = 4 and l-separadas    )  or ~
                             ({&TABLENAME}.estado = 5 and l-requisitadas )  or ~
                             ({&TABLENAME}.estado = 6 and l-iniciadas    )  or ~
                             ({&TABLENAME}.estado = 7 and l-finalizadas  )  or ~
                             ({&TABLENAME}.estado = 8 and l-terminadas   )) and ~
                            (({&TABLENAME}.origem = "MI":U and l-origem-mi) or ~
                             ({&TABLENAME}.origem = "MV":U and l-origem-mv)) no-lock
    
    &Scoped-define BY-ESTAB-IN BY {&TABLENAME}.nr-ord-produ ~
                               BY {&TABLENAME}.cod-estabel
    &Scoped-define BY-ESTAB-AT BY {&TABLENAME}.cod-estabel ~
                               BY {&TABLENAME}.nr-ord-produ
    
    {include/i-estab-openquery.i}
    
    if avail {&TABLENAME} then
        RETURN "OK":U.
    else 
        return "NOK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
*******************************************************************/

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOrdemManut DBOProgram 
PROCEDURE openQueryOrdemManut :
/*------------------------------------------------------------------------------
  Purpose:   Busca conjunto de registros da tabela ord-prod, dentro de uma
            faixa de número da ordem de produção inicial e final, e estado
            da ordem, e origem . Ordena por número da ordem de produção.   
         
------------------------------------------------------------------------------*/
IF (    l-nao-iniciadas = YES
    AND l-liberadas     = YES
    AND l-alocadas      = YES
    AND l-separadas     = YES
    AND l-requisitadas  = YES
    AND l-iniciadas     = YES
    AND l-finalizadas   = YES
    AND l-terminadas    = YES)
THEN DO:
    RUN openQueryOrdemManutEstado18.
END.
ELSE IF (l-nao-iniciadas = YES AND l-liberadas = NO    AND l-alocadas      = NO    AND l-separadas     = NO
    AND  l-requisitadas  = NO  AND l-iniciadas = NO    AND l-finalizadas   = NO    AND l-terminadas    = NO)
THEN DO:
    RUN openQueryOrdemManutEstado1.
END.
ELSE IF (l-nao-iniciadas = NO  AND l-liberadas = YES   AND l-alocadas      = NO    AND l-separadas     = NO
    AND  l-requisitadas  = NO  AND l-iniciadas = NO    AND l-finalizadas   = NO    AND l-terminadas    = NO)
    THEN DO:
    RUN openQueryOrdemManutEstado2.
END.
ELSE IF (l-nao-iniciadas = NO  AND l-liberadas = NO    AND l-alocadas      = YES   AND l-separadas     = NO
    AND  l-requisitadas  = NO  AND l-iniciadas = NO    AND l-finalizadas   = NO    AND l-terminadas    = NO)
    THEN DO:
    RUN openQueryOrdemManutEstado3.
END.
ELSE IF (l-nao-iniciadas = NO  AND l-liberadas = NO    AND l-alocadas      = NO    AND l-separadas     = YES
    AND  l-requisitadas  = NO  AND l-iniciadas = NO    AND l-finalizadas   = NO    AND l-terminadas    = NO)
    THEN DO:
    RUN openQueryOrdemManutEstado4.
END.
ELSE IF (l-nao-iniciadas = NO  AND l-liberadas = NO    AND l-alocadas      = NO    AND l-separadas     = NO
    AND  l-requisitadas  = YES AND l-iniciadas = NO    AND l-finalizadas   = NO    AND l-terminadas    = NO)
    THEN DO:
    RUN openQueryOrdemManutEstado5.
END.
ELSE IF (l-nao-iniciadas = NO  AND l-liberadas = NO    AND l-alocadas      = NO    AND l-separadas     = NO
    AND  l-requisitadas  = NO  AND l-iniciadas = YES   AND l-finalizadas   = NO    AND l-terminadas    = NO)
    THEN DO:
    RUN openQueryOrdemManutEstado6.
END.
ELSE IF (l-nao-iniciadas = NO  AND l-liberadas = NO    AND l-alocadas      = NO    AND l-separadas     = NO
    AND  l-requisitadas  = NO  AND l-iniciadas = NO    AND l-finalizadas   = YES   AND l-terminadas    = NO)
    THEN DO:
    RUN openQueryOrdemManutEstado7.
END.
ELSE IF (l-nao-iniciadas = NO  AND l-liberadas = NO    AND l-alocadas      = NO    AND l-separadas     = NO
    AND  l-requisitadas  = NO  AND l-iniciadas = NO    AND l-finalizadas   = NO    AND l-terminadas    = YES)
    THEN DO:
    RUN openQueryOrdemManutEstado8.
END.
ELSE DO:
    RUN openQueryOrdemManutEstadoALL.
END.

if avail {&TABLENAME} then
    RETURN "OK":U.
else 
    return "NOK":U.

END PROCEDURE.

PROCEDURE openQueryOrdemManutEstado18:
/*------------------------------------------------------------------------------
Purpose:     
Parameters:  <none>
Notes:       
------------------------------------------------------------------------------*/
&Scoped-define KEY-PHRASE (({&TABLENAME}.origem = "MI":U and l-origem-mi) or ~
                           ({&TABLENAME}.origem = "MV":U and l-origem-mv)) use-index origem no-lock

&Scoped-define BY-ESTAB-IN BY {&TABLENAME}.nr-ord-produ ~
                           BY {&TABLENAME}.cod-estabel
&Scoped-define BY-ESTAB-AT BY {&TABLENAME}.cod-estabel ~
                           BY {&TABLENAME}.nr-ord-produ

{include/i-estab-openquery.i}

END PROCEDURE.

PROCEDURE openQueryOrdemManutEstado1 :
/*------------------------------------------------------------------------------
Purpose:     
Parameters:  <none>
Notes:       
------------------------------------------------------------------------------*/
&Scoped-define KEY-PHRASE {&TABLENAME}.nr-ord-produ >= i-nr-ord-produ-ini AND ~
                          {&TABLENAME}.nr-ord-produ <= i-nr-ord-produ-fim AND ~
                          {&TABLENAME}.estado = 1  and ~
                        (({&TABLENAME}.origem = "MI":U and l-origem-mi) or ~
                         ({&TABLENAME}.origem = "MV":U and l-origem-mv)) USE-INDEX estado no-lock

&Scoped-define BY-ESTAB-IN BY {&TABLENAME}.nr-ord-produ ~
                           BY {&TABLENAME}.cod-estabel
&Scoped-define BY-ESTAB-AT BY {&TABLENAME}.cod-estabel ~
                           BY {&TABLENAME}.nr-ord-produ
    
{include/i-estab-openquery.i}

END PROCEDURE.
PROCEDURE openQueryOrdemManutEstado2 :
/*------------------------------------------------------------------------------
Purpose:     
Parameters:  <none>
Notes:       
------------------------------------------------------------------------------*/

&Scoped-define KEY-PHRASE {&TABLENAME}.nr-ord-produ >= i-nr-ord-produ-ini AND ~
                          {&TABLENAME}.nr-ord-produ <= i-nr-ord-produ-fim AND ~
                          {&TABLENAME}.estado = 2  and ~
                        (({&TABLENAME}.origem = "MI":U and l-origem-mi) or ~
                         ({&TABLENAME}.origem = "MV":U and l-origem-mv)) USE-INDEX estado no-lock

&Scoped-define BY-ESTAB-IN BY {&TABLENAME}.nr-ord-produ ~
                           BY {&TABLENAME}.cod-estabel
&Scoped-define BY-ESTAB-AT BY {&TABLENAME}.cod-estabel ~
                           BY {&TABLENAME}.nr-ord-produ
    
{include/i-estab-openquery.i}

END PROCEDURE.

PROCEDURE openQueryOrdemManutEstado3 :
/*------------------------------------------------------------------------------
Purpose:     
Parameters:  <none>
Notes:       
------------------------------------------------------------------------------*/

&Scoped-define KEY-PHRASE {&TABLENAME}.nr-ord-produ >= i-nr-ord-produ-ini AND ~
                          {&TABLENAME}.nr-ord-produ <= i-nr-ord-produ-fim AND ~
                          {&TABLENAME}.estado = 3  and ~
                        (({&TABLENAME}.origem = "MI":U and l-origem-mi) or ~
                         ({&TABLENAME}.origem = "MV":U and l-origem-mv)) USE-INDEX estado no-lock

&Scoped-define BY-ESTAB-IN BY {&TABLENAME}.nr-ord-produ ~
                           BY {&TABLENAME}.cod-estabel
&Scoped-define BY-ESTAB-AT BY {&TABLENAME}.cod-estabel ~
                           BY {&TABLENAME}.nr-ord-produ
    
{include/i-estab-openquery.i}

END PROCEDURE.
PROCEDURE openQueryOrdemManutEstado4 :
/*------------------------------------------------------------------------------
Purpose:     
Parameters:  <none>
Notes:       
------------------------------------------------------------------------------*/

&Scoped-define KEY-PHRASE {&TABLENAME}.nr-ord-produ >= i-nr-ord-produ-ini AND ~
                          {&TABLENAME}.nr-ord-produ <= i-nr-ord-produ-fim AND ~
                          {&TABLENAME}.estado = 4  and ~
                        (({&TABLENAME}.origem = "MI":U and l-origem-mi) or ~
                         ({&TABLENAME}.origem = "MV":U and l-origem-mv)) USE-INDEX estado no-lock

&Scoped-define BY-ESTAB-IN BY {&TABLENAME}.nr-ord-produ ~
                           BY {&TABLENAME}.cod-estabel
&Scoped-define BY-ESTAB-AT BY {&TABLENAME}.cod-estabel ~
                           BY {&TABLENAME}.nr-ord-produ
    
{include/i-estab-openquery.i}

END PROCEDURE.
PROCEDURE openQueryOrdemManutEstado5 :
/*------------------------------------------------------------------------------
Purpose:     
Parameters:  <none>
Notes:       
------------------------------------------------------------------------------*/

&Scoped-define KEY-PHRASE {&TABLENAME}.nr-ord-produ >= i-nr-ord-produ-ini AND ~
                          {&TABLENAME}.nr-ord-produ <= i-nr-ord-produ-fim AND ~
                          {&TABLENAME}.estado = 5  and ~
                        (({&TABLENAME}.origem = "MI":U and l-origem-mi) or ~
                         ({&TABLENAME}.origem = "MV":U and l-origem-mv)) USE-INDEX estado no-lock

&Scoped-define BY-ESTAB-IN BY {&TABLENAME}.nr-ord-produ ~
                           BY {&TABLENAME}.cod-estabel
&Scoped-define BY-ESTAB-AT BY {&TABLENAME}.cod-estabel ~
                           BY {&TABLENAME}.nr-ord-produ
    
{include/i-estab-openquery.i}

END PROCEDURE.
PROCEDURE openQueryOrdemManutEstado6 :
/*------------------------------------------------------------------------------
Purpose:     
Parameters:  <none>
Notes:       
------------------------------------------------------------------------------*/

&Scoped-define KEY-PHRASE {&TABLENAME}.nr-ord-produ >= i-nr-ord-produ-ini AND ~
                          {&TABLENAME}.nr-ord-produ <= i-nr-ord-produ-fim AND ~
                          {&TABLENAME}.estado = 6  and ~
                        (({&TABLENAME}.origem = "MI":U and l-origem-mi) or ~
                         ({&TABLENAME}.origem = "MV":U and l-origem-mv)) USE-INDEX estado no-lock

&Scoped-define BY-ESTAB-IN BY {&TABLENAME}.nr-ord-produ ~
                           BY {&TABLENAME}.cod-estabel
&Scoped-define BY-ESTAB-AT BY {&TABLENAME}.cod-estabel ~
                           BY {&TABLENAME}.nr-ord-produ
    
{include/i-estab-openquery.i}

END PROCEDURE.

PROCEDURE openQueryOrdemManutEstado7 :
/*------------------------------------------------------------------------------
Purpose:     
Parameters:  <none>
Notes:       
------------------------------------------------------------------------------*/

&Scoped-define KEY-PHRASE {&TABLENAME}.nr-ord-produ >= i-nr-ord-produ-ini AND ~
                          {&TABLENAME}.nr-ord-produ <= i-nr-ord-produ-fim AND ~
                          {&TABLENAME}.estado = 7  and ~
                        (({&TABLENAME}.origem = "MI":U and l-origem-mi) or ~
                         ({&TABLENAME}.origem = "MV":U and l-origem-mv)) USE-INDEX estado no-lock

&Scoped-define BY-ESTAB-IN BY {&TABLENAME}.nr-ord-produ ~
                           BY {&TABLENAME}.cod-estabel
&Scoped-define BY-ESTAB-AT BY {&TABLENAME}.cod-estabel ~
                           BY {&TABLENAME}.nr-ord-produ
    
{include/i-estab-openquery.i}

END PROCEDURE.

PROCEDURE openQueryOrdemManutEstado8 :
/*------------------------------------------------------------------------------
Purpose:     
Parameters:  <none>
Notes:       
------------------------------------------------------------------------------*/

&Scoped-define KEY-PHRASE {&TABLENAME}.nr-ord-produ >= i-nr-ord-produ-ini AND ~
                          {&TABLENAME}.nr-ord-produ <= i-nr-ord-produ-fim AND ~
                          {&TABLENAME}.estado = 8  and ~
                        (({&TABLENAME}.origem = "MI":U and l-origem-mi) or ~
                         ({&TABLENAME}.origem = "MV":U and l-origem-mv)) USE-INDEX estado no-lock

&Scoped-define BY-ESTAB-IN BY {&TABLENAME}.nr-ord-produ ~
                           BY {&TABLENAME}.cod-estabel
&Scoped-define BY-ESTAB-AT BY {&TABLENAME}.cod-estabel ~
                           BY {&TABLENAME}.nr-ord-produ
    
{include/i-estab-openquery.i}

END PROCEDURE.

PROCEDURE openQueryOrdemManutEstadoALL:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    &Scoped-define KEY-PHRASE {&TABLENAME}.nr-ord-produ >= i-nr-ord-produ-ini AND ~
                              {&TABLENAME}.nr-ord-produ <= i-nr-ord-produ-fim AND ~
                            (({&TABLENAME}.estado = 1 and l-nao-iniciadas)  or ~
                             ({&TABLENAME}.estado = 2 and l-liberadas    )  or ~
                             ({&TABLENAME}.estado = 3 and l-alocadas     )  or ~
                             ({&TABLENAME}.estado = 4 and l-separadas    )  or ~
                             ({&TABLENAME}.estado = 5 and l-requisitadas )  or ~
                             ({&TABLENAME}.estado = 6 and l-iniciadas    )  or ~
                             ({&TABLENAME}.estado = 7 and l-finalizadas  )  or ~
                             ({&TABLENAME}.estado = 8 and l-terminadas   )) and ~
                            (({&TABLENAME}.origem = "MI":U and l-origem-mi) or ~
                             ({&TABLENAME}.origem = "MV":U and l-origem-mv)) no-lock
    
    &Scoped-define BY-ESTAB-IN BY {&TABLENAME}.nr-ord-produ ~
                               BY {&TABLENAME}.cod-estabel
    &Scoped-define BY-ESTAB-AT BY {&TABLENAME}.cod-estabel ~
                               BY {&TABLENAME}.nr-ord-produ
    
    {include/i-estab-openquery.i}

END PROCEDURE.
