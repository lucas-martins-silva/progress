/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN681 2.00.00.021 } /*** "010021" 24/11/2023 13:25:26  ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin681 MUT}
&ENDIF

/* ********************************* OBS ***************************************** 
   Os metodos desta bo sao usados tanto na Consulta Preco/Item, 
     quanto no Relatorio Evolucao Precos. Peco muito cuidado ao alterar as includes 
     chamadas pelos m‚todos.
   ***************************************************************************** */
     

&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram
/*--------------------------------------------------------------------------
    File       : BOIN681.P
    Purpose    : O DBO (Datasul Business Objects) ‚ um programa PROGRESS
                 que cont‚m a l¢gica de neg¢cio e acesso a dados para uma
                 tabela do banco de dados.
    Autor      : Cristina - log9646
  ----------------------------------------------------------------------- */
/*          This .W file was created with the Progress UIB.               */
/* ---------------------------------------------------------------------- */

/* Definitions  --------------------------------------------------------- */

/* Diretrizes de defini‡Æo ---------------------------------------------- */
&GLOBAL-DEFINE DBOName controle-preco
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName controle-preco
&GLOBAL-DEFINE TableLabel controle-preco
&GLOBAL-DEFINE QueryName qr{&TableName}

{cdp/cdcfgren.i} /* pre-processor indices grendene - nao remover */

/* Include com defini‡Æo da temptable RowObject -------------------------- */
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com
      extensÆo .i ---*/

{inbo/boin681.i RowObject}
{inbo/boin082.i tt-cotacao-item}
{include/i-epc200.i boin681}

DEFINE TEMP-TABLE tt-controle-preco NO-UNDO LIKE controle-preco
    FIELD r-Rowid AS ROWID.

/*--- Include com defini‡Æo da query para tabela {&TableName} ------------- */
/*--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo
      manual da query ---*/

  {method/dboqry.i}  

/* Local Buffer Definitions ----------------------------------------------- */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/* UTILIZADO NAS SETCONSTRAINTS E OPENQUERYS ------------------------------ */

/*  Variaveis Setconstraints ---------------------------------------------- */

def var cCodEstabel     as char no-undo.
def var cEstabelec-ini  like estabelec.cod-estabel no-undo.
def var cEstabelec-fim  like estabelec.cod-estabel no-undo.
def var iEmitente-ini   like emitente.cod-emitente no-undo.
def var iEmitente-fim   like emitente.cod-emitente no-undo.
def var iCodEmitente    like emitente.cod-emitente no-undo.
def var cItem-ini       like item.it-codigo no-undo.
def var cItem-fim       like item.it-codigo no-undo.
def var daData-ini      like controle-preco.data-cotacao no-undo.
def var daData-fim      like controle-preco.data-cotacao no-undo.

def var e-preco-moeda-1 as decimal format "->>>,>>9.9999" no-undo. 
def var e-preco-moeda-2 as decimal format "->>>,>>9.9999" no-undo.
def var e-preco-moeda-3 as decimal format "->>>,>>9.9999" no-undo.
def var e-perc-ant-1    as decimal format "->>9.99" no-undo.
def var e-perc-ant-2    as decimal format "->>9.99" no-undo.
def var e-perc-ant-3    as decimal format "->>9.99" no-undo.
def var e-perc-acum-1   as decimal format "->>9.99" no-undo.
def var e-perc-acum-2   as decimal format "->>9.99" no-undo.
def var e-perc-acum-3   as decimal format "->>9.99" no-undo.

/* Procedures Consulta_Preco_item e Converte_cotacao_moeda ---------------- */

/* Quando a procedure for utilizada pela consulta  (wcc0392.p),precisara da moeda 1;
   quando a procedure for utilizada pelo relatorio (wcc0393.w),precisara das moedas 1 e 2 */
   
/* def var p-moeda1 as decimal no-undo.
 * def var p-moeda2 as decimal no-undo.*/

def buffer b-controle-preco for controle-preco.            /* usado na procedure Inico_calculo_cotacao */

def var da-data-ant                         as date    no-undo format "99/99/9999".  /* variaveis carregadas na procedure */
def var da-data-acum                        as date    no-undo format "99/99/9999".  /* Inicio_calculo_cotacao            */ 
def var da-inicio-calculo                   as date    no-undo format "99/99/9999".  /* in¡cio c lculo variacao */
    
def var de-preco                            as decimal no-undo format "->>>,>>9.99".

def var de-cotacao-moeda                    as decimal no-undo format "->>>,>>9.9999".
def var de-cotacao-moeda1                   as decimal no-undo format "->>>,>>9.9999".
def var de-cotacao-moeda2                   as decimal no-undo format "->>>,>>9.9999".

def var de-preco-conv                       as decimal no-undo format "->>>,>>9.9999". /* preco convertido */
def var de-preco-conv1                      as decimal no-undo format "->>>,>>9.9999". /* de acordo c/ a moeda*/
def var de-preco-conv2                      as decimal no-undo format "->>>,>>9.9999".

def var de-preco-ant                        as decimal no-undo format "->>>,>>9.9999". 
def var de-preco-ant1                       as decimal no-undo format "->>>,>>9.9999". 
def var de-preco-ant2                       as decimal no-undo format "->>>,>>9.9999". 

def var de-preco-acum                       as decimal no-undo format "->>>,>>9.9999". 
def var de-preco-acum1                      as decimal no-undo format "->>>,>>9.9999". 
def var de-preco-acum2                      as decimal no-undo format "->>>,>>9.9999". 

def var c-data                              as char    no-undo format "999999".  /* ano + mes p/ pegar a cotacao */ 
def var i-dia                               as inte    no-undo.                   /* pega a cotacao da moeda no dia */

def var c-return                            as char    no-undo.
def var h-boad098                           as handle  no-undo.
def var h-boad098na                         as handle  no-undo.
def var c-nome-emit                         like emitente.nome-emit.

def var c-type                              as char    no-undo  initial "".
/*==========================================================================*/

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

/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaDadosControlePreco DBOProgram 
PROCEDURE atualizaDadosControlePreco :
/*------------------------------------------------------------------------------
  Purpose:    Atualiza Controle de Pre‡os.
 
  Parameters: 
              ipar1 : prOrdemCompra    : Rowid da tabela Ordem Compra que est  posicionada na interface.
              ipar2 : tt-cotacao-item  : Temp Table carregada com o registro da cotacao-item que ser  
                                         utilizado para criar um registro na tabela de controle de pre‡os.
  Notes:       
------------------------------------------------------------------------------*/
    def input  param prOrdemCompra as rowid no-undo.
    def input  param table for tt-cotacao-item.

    def var de-conv-vista  as decimal no-undo.
    def var de-conv-prazo  as decimal no-undo.
    def var de-preco-vista as decimal no-undo.

    find first tt-cotacao-item no-lock no-error.

    find ordem-compra where 
         rowid(ordem-compra) = prOrdemCompra 
         no-lock no-error.  

    if avail tt-cotacao-item and avail ordem-compra then do: 
        FIND controle-preco NO-LOCK WHERE
             controle-preco.cod-estabel  = ordem-compra.cod-estabel     AND
             controle-preco.cod-emitente = tt-cotacao-item.cod-emitente AND
             controle-preco.it-codigo    = tt-cotacao-item.it-codigo    AND
             controle-preco.data-cotacao = tt-cotacao-item.data-cotacao NO-ERROR.

        if tt-cotacao-item.log-2 then do:

            create tt-controle-preco.
            assign  tt-controle-preco.cod-estabel      = ordem-compra.cod-estabel
                    tt-controle-preco.cod-emitente     = tt-cotacao-item.cod-emitente
                    tt-controle-preco.it-codigo        = tt-cotacao-item.it-codigo
                    tt-controle-preco.data-cotacao     = tt-cotacao-item.data-cotacao 
                    tt-controle-preco.numero-ordem     = tt-cotacao-item.numero-ordem
                    tt-controle-preco.seq-cotac        = tt-cotacao-item.seq-cotac
                    tt-controle-preco.cod-cond-pag     = tt-cotacao-item.cod-cond-pag
                    tt-controle-preco.perc-descto      = tt-cotacao-item.perc-descto
                    tt-controle-preco.aliquota-ipi     = tt-cotacao-item.aliquota-ipi
                    tt-controle-preco.valor-taxa       = tt-cotacao-item.valor-taxa
                    tt-controle-preco.nr-dias-taxa     = tt-cotacao-item.nr-dias-taxa
                    tt-controle-preco.codigo-ipi       = tt-cotacao-item.codigo-ipi
                    tt-controle-preco.taxa-financ      = tt-cotacao-item.taxa-financ
                    tt-controle-preco.preco-unit-prazo = tt-cotacao-item.preco-unit
                    tt-controle-preco.preco-unit-vista = tt-cotacao-item.preco-unit.

            if tt-cotacao-item.mo-codigo <> 0 then do:
               /* Converte para moeda corrente - pre‡o a prazo */
                run cdp/cd0812.p (input  tt-cotacao-item.mo-codigo,
                                  input  0,
                                  input  tt-controle-preco.preco-unit-prazo,
                                  input  tt-controle-preco.data-cotacao,
                                  output tt-controle-preco.preco-unit-prazo).

                run cdp/cd0812.p (input  tt-cotacao-item.mo-codigo,
                                  input  0,
                                  input  tt-controle-preco.preco-unit-vista,
                                  input  tt-controle-preco.data-cotacao,
                                  output tt-controle-preco.preco-unit-vista).
            end.

            if tt-cotacao-item.cod-cond-pag <> 0 then do:
                /* Retorna preco a vista se taxa financeira nao estiver inclusa*/
                run ccp/cc9020.p (input  no,
                                  input  tt-cotacao-item.cod-cond-pag,
                                  input  tt-cotacao-item.valor-taxa,
                                  input  tt-cotacao-item.nr-dias-taxa,
                                  input  tt-controle-preco.preco-unit-prazo,
                                  output tt-controle-preco.preco-unit-vista).
            end.            

            if not avail controle-preco then do:
                run setRecord (input table tt-controle-preco).
                run createRecord. 
            end.
            else do:
                run repositionRecord IN THIS-PROCEDURE (INPUT rowid(controle-preco)).
                run setRecord (input table tt-controle-preco).
                run updateRecord.
            end.

            if return-value = "NOK":U then
                return "NOK":U.
        end.
    end.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CalculaPreco DBOProgram 
PROCEDURE CalculaPreco :
/*------------------------------------------------------------------------------
  Purpose:    Calcular pre‡o … vista e pre‡o   prazo
              Utilizada pelo programa wcc0391.w  
-------------------------------------------------------------------------------- */
    if rowObject.taxa-financ then do: /* Se taxa financ. est  inclusa retorna preco a vista */
        RUN ccp/cc9020.p (input  no,
                          input  rowobject.cod-cond-pag,
                          input  rowobject.valor-taxa,
                          input  rowobject.nr-dias-taxa,
                          input  rowobject.preco-unit-prazo,
                          output rowobject.preco-unit-vista).
    end.    
    else do:  /* Se taxa financ. "nÆo" est  inclusa retorna preco a prazo */
        RUN ccp/cc9020.p (input  yes,
                          input  rowobject.cod-cond-pag,
                          input  rowobject.valor-taxa,
                          input  rowobject.nr-dias-taxa,
                          input  rowobject.preco-unit-vista,
                          output rowobject.preco-unit-prazo).
    end.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Converte_cotacao_moeda DBOProgram 
PROCEDURE Converte_cotacao_moeda :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters: ipar1:  piMoeda         : codigo da moeda informada pelo usuario
              ipar2:  pdePreco        : preco informado pelo usuario (moeda corrente)
              ipar3:  pcData          : data "ano/mes" da cotacao
              ipar4:  piDia           : dia da data da cotacao da moeda
              ipar5:  pdeCotacaoMoeda : cotacao a moeda no respectivo dia
              ipar6:  pdePrecoConv    : preco da moeda convertido 
  Notes:       
------------------------------------------------------------------------------*/
    def input  param piMoeda         as integer no-undo.
    def input  param pdePreco        as decimal no-undo format "->>>,>>>,>>9.99".
    def input  param pcData          as char    no-undo format "999999".
    def input  param piDia           as integer no-undo format "99".
    def output param pdeCotacaoMoeda as decimal no-undo format "->>>,>>>,>>9.999999999".
    def output param pdePrecoConv    as decimal no-undo format "->>>,>>>,>>9.99".

    find first cotacao no-lock where 
               cotacao.mo-codigo   = piMoeda and
               cotacao.ano-periodo = pcData  no-error.
    if avail   cotacao then do:

       assign  pdeCotacaoMoeda = cotacao.cotacao[piDia].
       
       if pdeCotacaoMoeda <> 0 then do:
          assign pdePrecoConv = (pdePreco / pdeCotacaoMoeda).
       end.   
       else assign pdePrecoConv = 0.
    end.   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Relatorio_Preco_item DBOProgram 
PROCEDURE Relatorio_Preco_item :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters: ipar1:  
  Notes:       
------------------------------------------------------------------------------*/
    /* Esta procedure e usada no Relatorio de Evolucao de precos por item*/

    def input  param piTipoClassific           as inte    no-undo .
    def input  param pcItCodigo                like item.it-codigo        no-undo .
    def input  param pCcodEstabel              like estabelec.cod-estabel no-undo .
    def input  param pdeMoeda1                 like moeda.mo-codigo       no-undo .
    def input  param pdeMoeda2                 like moeda.mo-codigo       no-undo .
    def input  param piCodEmitente             like emitente.cod-emitente no-undo .
    def input  param piTipoPreco               as inte    no-undo .
    def input  param pdDataInicial             as date    no-undo format "99/99/9999" .
    def input  param pdDataFinal               as date    no-undo format "99/99/9999" .
    def input  param pdInicioCalculo           as date    no-undo format "99/99/9999" .
    def output param table for tt-precos.
    
    for each tt-precos:
        delete tt-precos.
    end.    
    
    assign c-type = "relatorio".
    
    run adbo/boad098na.p persistent set h-boad098na.
    
    if piTipoClassific = 1 then do:
        
        for each controle-preco no-lock where
                 controle-preco.it-codigo     = pcItCodigo        and
                 controle-preco.cod-estabel   = pcCodEstabel      and
                 controle-preco.cod-emitente  = piCodEmitente     and
                (controle-preco.data-cotacao  >= pdDataInicial    and
                 controle-preco.data-cotacao  <= pdDataFinal)       
                 break by controle-preco.cod-estabel
                       by controle-preco.it-codigo
                       by controle-preco.cod-emitente
                       by controle-preco.data-cotacao:
                if first-of(controle-preco.it-codigo) then do:
                   {inbo/boin681.i1}         /* Chama Inicio_Calculo_Variacao */
                end. 
                {inbo/boin681.i2}            /* Chama Converte_cotacao_moeda */
        end.
        
    end.
    else if piTipoClassific = 2 then do:

        for each controle-preco no-lock where
                 controle-preco.it-codigo     = pcItCodigo         and
                 controle-preco.cod-estabel   = pcCodEstabel       and
                 controle-preco.cod-emitente  = piCodEmitente      and
                (controle-preco.data-cotacao  >= pdDataInicial     and
                 controle-preco.data-cotacao  <= pdDataFinal)       
                 break by controle-preco.cod-estabel
                       by controle-preco.cod-emitente
                       by controle-preco.it-codigo
                       by controle-preco.data-cotacao:
                if first-of(controle-preco.cod-emitente) then do:
                   {inbo/boin681.i1}         /* Chama Inicio_Calculo_Variacao */
                end. 
                  {inbo/boin681.i2} /* Chama Converte_cotacao_moeda  */
        end.
    end.
    
    delete procedure h-boad098na no-error.
                   
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
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.
    
    CASE pFieldName:
        WHEN "it-codigo":U   THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "char-1":U      THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U      THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
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
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE      NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-1":U       THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U       THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "data-cotacao":U THEN ASSIGN pFieldValue = RowObject.data-cotacao.
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
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL   NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dec-1":U            THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U            THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "perc-descto":U      THEN ASSIGN pFieldValue = RowObject.perc-descto.
        WHEN "preco-unit-prazo":U THEN ASSIGN pFieldValue = RowObject.preco-unit-prazo.
        WHEN "preco-unit-vista":U THEN ASSIGN pFieldValue = RowObject.preco-unit-vista.
        WHEN "valor-taxa":U       THEN ASSIGN pFieldValue = RowObject.valor-taxa.
        WHEN "aliquota-ipi":U     THEN ASSIGN pFieldValue = RowObject.aliquota-ipi.
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
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER   NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "int-1":U        THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U        THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "nr-dias-taxa":U THEN ASSIGN pFieldValue = RowObject.nr-dias-taxa.
        WHEN "numero-ordem":U THEN ASSIGN pFieldValue = RowObject.numero-ordem.
        WHEN "seq-cotac":U    THEN ASSIGN pFieldValue = RowObject.seq-cotac.
        WHEN "cod-cond-pag":U THEN ASSIGN pFieldValue = RowObject.cod-cond-pag.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice CONTROLE
  Parameters:
               retorna valor dos campos do ¡ndice CONTROLE
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel  LIKE controle-preco.cod-estabel   NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE controle-preco.cod-emitente  NO-UNDO.
    DEFINE OUTPUT PARAMETER pit-codigo    LIKE controle-preco.it-codigo     NO-UNDO.
    DEFINE OUTPUT PARAMETER pdata-cotacao LIKE controle-preco.data-cotacao  NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pcod-estabel  = RowObject.cod-estabel.
    ASSIGN pcod-emitente = RowObject.cod-emitente.
    ASSIGN pit-codigo    = RowObject.it-codigo.
    ASSIGN pdata-cotacao = RowObject.data-cotacao.

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
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL   NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "log-1":U       THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U       THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "taxa-financ":U THEN ASSIGN pFieldValue = RowObject.taxa-financ.
        WHEN "codigo-ipi":U  THEN ASSIGN pFieldValue = RowObject.codigo-ipi.
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
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RAW       NO-UNDO.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKeyControle DBOProgram
PROCEDURE goToKeyControle :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ¡ndice CONTROLE
  Parameters:
               recebe valor dos campos do ¡ndice CONTROLE
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel  LIKE controle-preco.cod-estabel  NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente LIKE controle-preco.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo    LIKE controle-preco.it-codigo    NO-UNDO.
    DEFINE INPUT PARAMETER pdata-cotacao as char                          NO-UNDO.

    FIND FIRST bfcontrole-preco NO-LOCK WHERE
         bfcontrole-preco.cod-estabel  = pcod-estabel  AND
         bfcontrole-preco.cod-emitente = pcod-emitente AND
         bfcontrole-preco.it-codigo    = pit-codigo    AND
         bfcontrole-preco.data-cotacao = date(pdata-cotacao) NO-ERROR.
    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/

    IF NOT AVAILABLE bfcontrole-preco THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/

    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfcontrole-preco)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKeyEstab DBOProgram
PROCEDURE goToKeyEstab :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ¡ndice estab-item
  Parameters:
               recebe valor dos campos do ¡ndice estab-item
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel  LIKE controle-preco.cod-estabel  NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo    LIKE controle-preco.it-codigo    NO-UNDO.
    DEFINE INPUT PARAMETER pdata-cotacao LIKE controle-preco.data-cotacao NO-UNDO.

    FIND FIRST bfcontrole-preco NO-LOCK WHERE
         bfcontrole-preco.cod-estabel  = pcod-estabel  AND
         bfcontrole-preco.it-codigo    = pit-codigo    AND
         bfcontrole-preco.data-cotacao = pdata-cotacao NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/

    IF NOT AVAILABLE bfcontrole-preco THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/

    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfcontrole-preco)).
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
    define input parameter iAbertura as integer no-undo.
    case iAbertura:
        when 1 then
            run openQueryStatic ("Main").
        when 2 then     
            run openQueryStatic ("ByCodEstabel").
        when 3 then 
            run openQueryStatic ("FaixaZoom").
   end case.                  
END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint2 DBOProgram 
PROCEDURE setConstraint2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param pcEstabel      as char   no-undo.
    
    run setConstraintByCodEstabel (input pcEstabel).
                        
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByCodEstabel DBOProgram 
PROCEDURE setConstraintByItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
----------------------------------------------------------------------------------*/
    def input param pcEstabel     as char no-undo.  /* codigo do estabelecimento */

    assign   cCodEstabel = pcEstabel .
    
    return "OK":U.             
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintfaixaZoom DBOProgram 
PROCEDURE setConstraintfaixaZoom :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
----------------------------------------------------------------------------------*/
DEF INPUT PARAM pcEstabelec AS CHAR NO-UNDO.
DEF INPUT PARAM piEmitente  AS INT  NO-UNDO.
DEF INPUT PARAM pcItem-ini  AS CHAR NO-UNDO.
DEF INPUT PARAM pcItem-fim  AS CHAR NO-UNDO.
DEF INPUT PARAM pdaData-ini AS DATE NO-UNDO.
DEF INPUT PARAM pdaData-fim AS DATE NO-UNDO.

    ASSIGN  cCodEstabel  = pcEstabelec
            iCodEmitente = piEmitente
            cItem-ini    = pcItem-ini
            cItem-fim    = pcItem-fim
            daData-ini   = pdaData-ini
            daData-fim   = pdaData-fim.
    
    return "OK":U.             
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByCodEstabel DBOProgram 
PROCEDURE openQueryByCodEstabel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} WHERE 
                                     {&TableName}.cod-estabel >= cCodEstabel 
                                      NO-LOCK by cod-estabel indexed-reposition.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFaixaZoom DBOProgram 
PROCEDURE openQueryFaixaZoom :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Quando nÆo for informado emitente ser  ignorado o c¢digo */
    IF  iCodEmitente = 0 THEN
        OPEN QUERY {&QueryName} FOR EACH {&TableName} WHERE 
                                         {&TableName}.cod-estabel   = cCodEstabel  AND
                                         {&tablename}.it-codigo    >= cItem-ini    AND
                                         {&tablename}.it-codigo    <= cItem-fim    AND
                                         {&TableName}.cod-emitente >= 0            AND
                                         {&TableName}.cod-emitente <= 999999999    AND
                                         {&TableName}.data-cotacao >= daData-ini   AND
                                         {&TableName}.data-cotacao <= daData-fim   NO-LOCK
                                    &IF DEFINED(CUSTOM_GRENDENE) &THEN
                                         USE-INDEX estab-item
                                    &ELSE
                                         USE-INDEX controle
                                    &ENDIF
                                    INDEXED-REPOSITION.
    /* SenÆo abre a query somente de um emitente  */
    ELSE 
        OPEN QUERY {&QueryName} FOR EACH {&TableName} WHERE 
                                         {&TableName}.cod-estabel   = cCodEstabel  AND
                                         {&TableName}.cod-emitente  = iCodEmitente AND
                                         {&tablename}.it-codigo    >= cItem-ini    AND
                                         {&tablename}.it-codigo    <= cItem-fim    AND
                                         {&TableName}.data-cotacao >= daData-ini   AND
                                         {&TableName}.data-cotacao <= daData-fim   NO-LOCK 
                                         INDEXED-REPOSITION.
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
    OPEN QUERY {&QueryName} FOR EACH controle-preco NO-LOCK INDEXED-REPOSITION.
    
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
    /*--- Utilize o parƒmetro pType para identificar quais as valida‡äes a serem
          executadas ---*/
    /*--- Os valores poss¡veis para o parƒmetro sÆo: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as valida‡äes ---*/
    /*--- Verifica ocorrˆncia de erros ---*/

    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    FIND FIRST rowObject NO-ERROR.
    
    if ptype = "create" then do:
        If  can-find (first controle-preco where
                            controle-preco.cod-estabel  = rowObject.cod-estabel    and 
                            controle-preco.cod-emitente = rowObject.cod-emitente   and 
                            controle-preco.it-codigo    = rowObject.it-codigo      and 
                            controle-preco.data-cotacao = rowObject.data-cotacao   use-index controle ) then do:
            /* Inicio -- Projeto Internacional */
            {utp/ut-table.i movind controle-preco 1} /* Busca o label da tabela */
            {method/svc/errors/inserr.i
                      &ErrorNumber      = "8"
                      &ErrorType        = "EMS"
                      &ErrorParameters  = TRIM(RETURN-VALUE)}
    
        end. 
        if can-find(first rowerrors) then 
            return "NOK":U.
    end.

    if ptype = "create" or ptype = "update" then do:
              
        /* chave ------------------------------------------------------------- */

        /* Estabelec --------------------------------------------------------- */
        find estabelec no-lock where 
             estabelec.cod-estabel = rowobject.cod-estabel no-error.
        if not avail estabelec then do:
             /* Inicio -- Projeto Internacional */
             {utp/ut-table.i mgadm estabelec 1} /* Busca o label da tabela */
             {method/svc/errors/inserr.i
                       &ErrorNumber      = "2"
                       &ErrorType        = "EMS"
                       &ErrorParameters  = TRIM(RETURN-VALUE)}
        end.
    
        /* Emitente ---------------------------------------------------------- */ 
        find emitente no-lock where 
             emitente.cod-emitente = rowobject.cod-emitente no-error.
        if not avail emitente then do:
             /* Inicio -- Projeto Internacional */
             DEFINE VARIABLE c-lbl-liter-fornecedor AS CHARACTER NO-UNDO.
             {utp/ut-liter.i "Fornecedor" *}
             ASSIGN c-lbl-liter-fornecedor = TRIM(RETURN-VALUE).
             {method/svc/errors/inserr.i
                   &ErrorNumber      = "2"
                   &ErrorType        = "EMS"
                   &ErrorParameters  = "c-lbl-liter-fornecedor"}
        end.
    
        /* Item --------------------------------------------------------------- */ 
        find item no-lock where 
             item.it-codigo = rowobject.it-codigo no-error.
        if not avail item then do:     
             /* Inicio -- Projeto Internacional */
             {utp/ut-table.i mgind item 1} /* Busca o label da tabela */
             {method/svc/errors/inserr.i
                       &ErrorNumber      = "2"
                       &ErrorType        = "EMS"
                       &ErrorParameters  = TRIM(RETURN-VALUE)}
        end.
        
        /* Data cotacao ------------------------------------------------------- */
        if rowObject.data-cotacao = ? then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-data-cotacao AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Data_Cota‡Æo" *}
            ASSIGN c-lbl-liter-data-cotacao = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                      &ErrorNumber      = "265"
                      &ErrorType        = "EMS"
                      &ErrorParameters  = "c-lbl-liter-data-cotacao"}
        end.
        
        /* Fim Chave -------------------------------------------------------- */
        
        if rowObject.cod-cond-pag <> 0 then do:
            find cond-pagto no-lock where 
                 cond-pagto.cod-cond-pag = rowobject.cod-cond-pag no-error.
            if not avail cond-pagto then do:           
                 /* Inicio -- Projeto Internacional */
                 DEFINE VARIABLE c-lbl-liter-condicao-pagamento AS CHARACTER NO-UNDO.
                 {utp/ut-liter.i "Condi‡Æo_Pagamento" *}
                 ASSIGN c-lbl-liter-condicao-pagamento = TRIM(RETURN-VALUE).
                 {method/svc/errors/inserr.i
                           &ErrorNumber      = "2"
                           &ErrorType        = "EMS"
                           &ErrorParameters  = "c-lbl-liter-condicao-pagamento"}
            end.
        end.

        if rowObject.perc-descto = ? then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-percentual-de-desconto AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Percentual_de_desconto" *}
            ASSIGN c-lbl-liter-percentual-de-desconto = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                      &ErrorNumber      = "265"
                      &ErrorType        = "EMS"
                      &ErrorParameters  = "c-lbl-liter-percentual-de-desconto"}
        end.
        

        if rowObject.aliquota-ipi = ? then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-aliquota-ipi AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Aliquota_IPI" *}
            ASSIGN c-lbl-liter-aliquota-ipi = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                      &ErrorNumber      = "265"
                      &ErrorType        = "EMS"
                      &ErrorParameters  = "c-lbl-liter-aliquota-ipi"}
        end.
            

        if rowObject.valor-taxa = ? then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-valor-taxa-financeira AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Valor_Taxa_Financeira" *}
            ASSIGN c-lbl-liter-valor-taxa-financeira = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                      &ErrorNumber      = "265"
                      &ErrorType        = "EMS"
                      &ErrorParameters  = "c-lbl-liter-valor-taxa-financeira"}
        end.
        

        if rowObject.nr-dias-taxa = ? then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-dias-taxa-financeira AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Dias_Taxa_Financeira" *}
            ASSIGN c-lbl-liter-dias-taxa-financeira = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                      &ErrorNumber      = "265"
                      &ErrorType        = "EMS"
                      &ErrorParameters  = "c-lbl-liter-dias-taxa-financeira"}
        end.

        if  avail cond-pagto then do:
            if rowObject.taxa-financ then do: /* Se taxa financeira est  inclusa deve ser informado valor a prazo */
               if rowObject.preco-unit-prazo = 0 or
                  rowObject.preco-unit-prazo = ? then do:
                   /* Inicio -- Projeto Internacional */
                   DEFINE VARIABLE c-lbl-liter-preco-unitario-a-prazo AS CHARACTER NO-UNDO.
                   {utp/ut-liter.i "Pre‡o_unit rio_a_prazo" *}
                   ASSIGN c-lbl-liter-preco-unitario-a-prazo = TRIM(RETURN-VALUE).
                   {method/svc/errors/inserr.i
                             &ErrorNumber      = "265"
                             &ErrorType        = "EMS"
                             &ErrorParameters  = "c-lbl-liter-preco-unitario-a-prazo"}
               end.
            end.    
            else do: /* Se taxa financeira nÆo est  inclusa deve ser informado valor a vista */
                 if rowobject.preco-unit-vista = 0 or
                    rowobject.preco-unit-vista = ? then do:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-preco-unitario-a-vista AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Pre‡o_unit rio_a_vista" *}
                    ASSIGN c-lbl-liter-preco-unitario-a-vista = TRIM(RETURN-VALUE).
                    {method/svc/errors/inserr.i
                              &ErrorNumber      = "265"
                              &ErrorType        = "EMS"
                              &ErrorParameters  = "c-lbl-liter-preco-unitario-a-vista"}
                end.
            end.    
        end.    
        else do:
             if rowobject.numero-ordem = 0 or
                rowobject.numero-ordem = ? then do:
                {method/svc/errors/inserr.i
                        &ErrorNumber      = "19137"
                        &ErrorType        = "EMS"}
             end.
        end.
    end. /* end if create ou update */
    
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LastSequencia DBOProgram
PROCEDURE LastSequencia :
    def input  param pi-numero-ordem like controle-preco.numero-ordem.
    def input  param pi-cod-emitente like controle-preco.cod-emitente.
    def input  param pc-it-codigo    like controle-preco.it-codigo.
    def output param pi-sequencia    like controle-preco.seq-cotac.
        
    find last  controle-preco
         where controle-preco.numero-ordem = pi-numero-ordem
         and   controle-preco.cod-emitente = pi-cod-emitente
         and   controle-preco.it-codigo    = pc-it-codigo
         and   controle-preco.seq-cotac    > 0 no-lock no-error.
    
    assign pi-sequencia = if   avail controle-preco
                          then controle-preco.seq-cotac + 1
                          else 1.         
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

