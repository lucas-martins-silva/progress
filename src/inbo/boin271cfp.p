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
{include/i-prgvrs.i BOIN271CFP 2.00.00.004 } /*** "010004" 17/06/2025 16:40:47 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin271cfp MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : dbo.p
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
&GLOBAL-DEFINE DBOName BOIN271CFP
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName ord-prod
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 


/*--- Include com defini‡Æo da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com 
      extensÆo .i ---*/
{inbo/boin271cfp.i RowObject}


/*--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}


/*--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

{vcp/vc0302.i} /* defini‡Æo das temp-tables */

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


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaTempTables DBOProgram 
PROCEDURE criaTempTables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input param pItCodigo   as char       no-undo.
def input param pCodEstabel as char       no-undo.
DEF INPUT PARAM pOrdemIni   AS INT        NO-UNDO.
DEF INPUT PARAM pOrdemFim   AS INT        NO-UNDO.
def input param pDataIni    as date       no-undo.
def input param pDataFim    as date       no-undo. 
def input param pTipoCusto  as int        no-undo.

def output param table for ttResumoMes.

def var cPeriodo   as char        no-undo.
def var iCont      as int         no-undo.

&IF integer(entry(1,proversion,".")) >= 9 &THEN
    EMPTY TEMP-TABLE ttResumoMes.
&ELSE
    for each ttResumoMes:
      delete ttResumoMes.
    end.
&ENDIF

for each ord-prod fields (nr-ord-produ it-codigo nr-estrut nome-abrev nr-pedido sequencia dt-inicio dt-termino) 
         no-lock use-index ori-val where
         ord-prod.it-codigo   = pItCodigo   and
         ord-prod.cod-estabel = pCodEstabel and
         ord-prod.origem      = "CF":         
    
    if   ord-prod.nr-ord-produ < pOrdemIni or 
         ord-prod.nr-ord-produ > pOrdemFim then next.
    
    /* Procura a vari vel para forma‡Æo de Pre‡o */
    for first  var-result fields (valor-dec) where
               var-result.nr-estrut    = ord-prod.nr-estrut and
               var-result.item-cotacao = ord-prod.it-codigo     and
               var-result.tipo-valor   = 6 no-lock: end.
    if not avail var-result then do:
       {method/svc/errors/inserr.i
                    &ErrorNumber="26833"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="ord-prod.it-codigo + '~~~~' + string(ord-prod.nr-estrut)"}
    end.

    for each movto-mat where 
             movto-mat.nr-ord-produ = ord-prod.nr-ord-produ and
             movto-mat.dt-trans     >= pDataIni           and
             movto-mat.dt-trans     <= pDataFim           and
             movto-mat.it-codigo     = ord-prod.it-codigo and
            (movto-mat.esp-docto     = 1 or movto-mat.esp-docto = 8) no-lock: /* acabado ou estorno */

            /* NÆo esta valorizado */
            if (pTipoCusto = 1 and movto-mat.valor-mat-m[1]  = 0 and movto-mat.valor-mob-m[1] = 0) or
               (pTipoCusto = 2 and movto-mat.valor-mat-o[1]  = 0 and movto-mat.valor-mob-o[1] = 0) then 
               next.

            assign cPeriodo = string(year(movto-mat.dt-trans)) + "/" +
                              string(month(movto-mat.dt-trans)).     
     
            find first ttResumoMes where
                       ttResumoMes.periodo     = cPeriodo and 
                       ttResumoMes.nr-ord-produ = ord-prod.nr-ord-produ no-lock no-error.
        
            if not avail ttResumoMes then do:
               create ttResumoMes.
               assign ttResumoMes.periodo      = cPeriodo
                      ttResumoMes.nr-ord-produ  = ord-prod.nr-ord-produ
                      ttResumoMes.vl-variavel  = if avail var-result then var-result.valor-dec
                                                                     else 0
                      ttResumoMes.nr-ord-produ = ord-prod.nr-ord-produ
                      ttResumoMes.nr-estrut    = ord-prod.nr-estrut
                      ttResumoMes.nome-abrev   = ord-prod.nome-abrev
                      ttResumoMes.nr-pedido    = ord-prod.nr-pedido
                      ttResumoMes.sequencia    = ord-prod.sequencia
                      ttResumoMes.dt-inicio    = ord-prod.dt-inicio
                      ttResumoMes.dt-termino   = ord-prod.dt-termino.                      
            end.                        
            
            if movto-mat.esp-docto = 1 then /* ACA */
               assign ttResumoMes.qt-produzida = ttResumoMes.qt-produzida + movto-mat.quantidade.
            else /* EAC */
               assign ttResumoMes.qt-produzida = ttResumoMes.qt-produzida - movto-mat.quantidade.                           

            /* Tipo de Custo: pTipoCusto (BATCH ou On-line) */            
            case pTipoCusto:
                when 1 then do:
                     if movto-mat.esp-docto = 1 then do: /* ACA */
                        {inbo/boin271cfp.i1 "m" "+"} 
                     end.
                     else do: 
                        {inbo/boin271cfp.i1 "m" "-"} 
                     end.
                end.
                when 2 then do:
                     if movto-mat.esp-docto = 1 then do: /* ACA */
                        {inbo/boin271cfp.i1 "o" "+"}
                     end.
                     else do: 
                        {inbo/boin271cfp.i1 "o" "-"}
                     end.
                end.
            end case.            

            assign ttResumoMes.desvio = (ttResumoMes.vl-variavel * 100) / ttResumoMes.custo-unitario.

    end. /* movto-mat */         
    
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
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cd-planejado":U THEN ASSIGN pFieldValue = RowObject.cd-planejado.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-depos":U THEN ASSIGN pFieldValue = RowObject.cod-depos.
        WHEN "cod-estab-ctr":U THEN ASSIGN pFieldValue = RowObject.cod-estab-ctr.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-lista-compon":U THEN ASSIGN pFieldValue = RowObject.cod-lista-compon.
        WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
        WHEN "cod-roteiro":U THEN ASSIGN pFieldValue = RowObject.cod-roteiro.
        WHEN "conta-despesa":U THEN ASSIGN pFieldValue = RowObject.conta-despesa.
        WHEN "conta-imob":U THEN ASSIGN pFieldValue = RowObject.conta-imob.
        WHEN "conta-ordem":U THEN ASSIGN pFieldValue = RowObject.conta-ordem.
        WHEN "ct-codigo":U THEN ASSIGN pFieldValue = RowObject.ct-codigo.
        WHEN "ct-desp":U THEN ASSIGN pFieldValue = RowObject.ct-desp.
        WHEN "ct-imob":U THEN ASSIGN pFieldValue = RowObject.ct-imob.
        WHEN "es-codigo":U THEN ASSIGN pFieldValue = RowObject.es-codigo.
        WHEN "hr-efetiv-term":U THEN ASSIGN pFieldValue = RowObject.hr-efetiv-term.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "it-inspec":U THEN ASSIGN pFieldValue = RowObject.it-inspec.
        WHEN "item-cotacao":U THEN ASSIGN pFieldValue = RowObject.item-cotacao.
        WHEN "lote-serie":U THEN ASSIGN pFieldValue = RowObject.lote-serie.
        WHEN "narrativa":U THEN ASSIGN pFieldValue = RowObject.narrativa.
        WHEN "nome-abrev":U THEN ASSIGN pFieldValue = RowObject.nome-abrev.
        WHEN "nr-pedido":U THEN ASSIGN pFieldValue = RowObject.nr-pedido.
        WHEN "origem":U THEN ASSIGN pFieldValue = RowObject.origem.
        WHEN "sc-codigo":U THEN ASSIGN pFieldValue = RowObject.sc-codigo.
        WHEN "sc-desp":U THEN ASSIGN pFieldValue = RowObject.sc-desp.
        WHEN "sc-imob":U THEN ASSIGN pFieldValue = RowObject.sc-imob.
        WHEN "un":U THEN ASSIGN pFieldValue = RowObject.un.
        WHEN "usuario-alt":U THEN ASSIGN pFieldValue = RowObject.usuario-alt.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "data-alt":U THEN ASSIGN pFieldValue = RowObject.data-alt.
        WHEN "dt-efetiv-term":U THEN ASSIGN pFieldValue = RowObject.dt-efetiv-term.
        WHEN "dt-emissao":U THEN ASSIGN pFieldValue = RowObject.dt-emissao.
        WHEN "dt-inicio":U THEN ASSIGN pFieldValue = RowObject.dt-inicio.
        WHEN "dt-orig":U THEN ASSIGN pFieldValue = RowObject.dt-orig.
        WHEN "dt-termino":U THEN ASSIGN pFieldValue = RowObject.dt-termino.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "qt-apr-cond":U THEN ASSIGN pFieldValue = RowObject.qt-apr-cond.
        WHEN "qt-inicial":U THEN ASSIGN pFieldValue = RowObject.qt-inicial.
        WHEN "qt-ordem":U THEN ASSIGN pFieldValue = RowObject.qt-ordem.
        WHEN "qt-perda":U THEN ASSIGN pFieldValue = RowObject.qt-perda.
        WHEN "qt-produzida":U THEN ASSIGN pFieldValue = RowObject.qt-produzida.
        WHEN "qt-refugada":U THEN ASSIGN pFieldValue = RowObject.qt-refugada.
        WHEN "qt-reportada":U THEN ASSIGN pFieldValue = RowObject.qt-reportada.
        WHEN "qt-requisita":U THEN ASSIGN pFieldValue = RowObject.qt-requisita.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "calc-cs-ggf":U THEN ASSIGN pFieldValue = RowObject.calc-cs-ggf.
        WHEN "calc-cs-mat":U THEN ASSIGN pFieldValue = RowObject.calc-cs-mat.
        WHEN "calc-cs-mob":U THEN ASSIGN pFieldValue = RowObject.calc-cs-mob.
        WHEN "cod-gr-cli":U THEN ASSIGN pFieldValue = RowObject.cod-gr-cli.
        WHEN "custeio-prop-ggf":U THEN ASSIGN pFieldValue = RowObject.custeio-prop-ggf.
        WHEN "custeio-prop-mat":U THEN ASSIGN pFieldValue = RowObject.custeio-prop-mat.
        WHEN "custeio-prop-mob":U THEN ASSIGN pFieldValue = RowObject.custeio-prop-mob.
        WHEN "dest-manut":U THEN ASSIGN pFieldValue = RowObject.dest-manut.
        WHEN "estado":U THEN ASSIGN pFieldValue = RowObject.estado.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "nr-contrato-venda":U THEN ASSIGN pFieldValue = RowObject.nr-contrato-venda.
        WHEN "nr-entrega":U THEN ASSIGN pFieldValue = RowObject.nr-entrega.
        WHEN "nr-estrut":U THEN ASSIGN pFieldValue = RowObject.nr-estrut.
        WHEN "nr-estrut-filha":U THEN ASSIGN pFieldValue = RowObject.nr-estrut-filha.
        WHEN "nr-ficha":U THEN ASSIGN pFieldValue = RowObject.nr-ficha.
        WHEN "nr-linha":U THEN ASSIGN pFieldValue = RowObject.nr-linha.
        WHEN "nr-ord-aber":U THEN ASSIGN pFieldValue = RowObject.nr-ord-aber.
        WHEN "nr-ord-produ":U THEN ASSIGN pFieldValue = RowObject.nr-ord-produ.
        WHEN "nr-ord-refer":U THEN ASSIGN pFieldValue = RowObject.nr-ord-refer.
        WHEN "nr-req-sum":U THEN ASSIGN pFieldValue = RowObject.nr-req-sum.
        WHEN "nr-seq-contr-it":U THEN ASSIGN pFieldValue = RowObject.nr-seq-contr-it.
        WHEN "nr-sequencia":U THEN ASSIGN pFieldValue = RowObject.nr-sequencia.
        WHEN "nr-ult-seq":U THEN ASSIGN pFieldValue = RowObject.nr-ult-seq.
        WHEN "num-ord-inv":U THEN ASSIGN pFieldValue = RowObject.num-ord-inv.
        WHEN "prioridade":U THEN ASSIGN pFieldValue = RowObject.prioridade.
        WHEN "rep-prod":U THEN ASSIGN pFieldValue = RowObject.rep-prod.
        WHEN "reporte-ggf":U THEN ASSIGN pFieldValue = RowObject.reporte-ggf.
        WHEN "reporte-mob":U THEN ASSIGN pFieldValue = RowObject.reporte-mob.
        WHEN "sequencia":U THEN ASSIGN pFieldValue = RowObject.sequencia.
        WHEN "sit-aloc":U THEN ASSIGN pFieldValue = RowObject.sit-aloc.
        WHEN "tipo":U THEN ASSIGN pFieldValue = RowObject.tipo.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice codigo
  Parameters:  
               retorna valor do campo nr-ord-produ
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
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cons-mrp":U THEN ASSIGN pFieldValue = RowObject.cons-mrp.
        WHEN "cons-pmp":U THEN ASSIGN pFieldValue = RowObject.cons-pmp.
        WHEN "emite-ordem":U THEN ASSIGN pFieldValue = RowObject.emite-ordem.
        WHEN "emite-requis":U THEN ASSIGN pFieldValue = RowObject.emite-requis.
        WHEN "enc-mensal":U THEN ASSIGN pFieldValue = RowObject.enc-mensal.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "prod-repet":U THEN ASSIGN pFieldValue = RowObject.prod-repet.
        WHEN "prototipo":U THEN ASSIGN pFieldValue = RowObject.prototipo.
        WHEN "req-emitida":U THEN ASSIGN pFieldValue = RowObject.req-emitida.
        WHEN "val-per":U THEN ASSIGN pFieldValue = RowObject.val-per.
        WHEN "valorizada":U THEN ASSIGN pFieldValue = RowObject.valorizada.
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




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ¡ndice codigo
  Parameters:  
               recebe valor do campo nr-ord-produ
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-ord-produ LIKE ord-prod.nr-ord-produ NO-UNDO.

    FIND FIRST bford-prod WHERE 
        bford-prod.nr-ord-produ = pnr-ord-produ NO-LOCK NO-ERROR.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

open query {&queryname} for each {&tablename} no-lock INDEXED-REPOSITION.
    
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaParametros DBOProgram 
PROCEDURE retornaParametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def output param pCodEstabel as char no-undo.
def output param pDataIni    as date no-undo.
def output param pDataFim    as date no-undo.
def output param pTipoCusto  as int  no-undo.

find first param-cp no-lock no-error.
if not avail param-cp then do:
    /* Inicio -- Projeto Internacional */
    DEFINE VARIABLE c-lbl-liter-producao AS CHARACTER NO-UNDO.
    {utp/ut-liter.i "Produ‡Æo" *}
    ASSIGN c-lbl-liter-producao = TRIM(RETURN-VALUE).
    {method/svc/errors/inserr.i
             &ErrorNumber="2082"
             &ErrorType="EMS"
             &ErrorSubType="ERROR"
             &ErrorParameters="c-lbl-liter-producao"}    
    RETURN "NOK":U.    
end.

assign pCodEstabel = param-cp.cod-estabel.

find first param-cs no-lock no-error.

find first param-estoq no-lock no-error.

find first estab-mat no-lock where
           estab-mat.cod-estabel = pCodEstabel no-error.

assign pDataIni   = date("01/01/" + string(year(estab-mat.mensal-ate)))
       pDataFim   = if avail param-estoq then param-estoq.mensal-ate
                                         else 12/31/9999
       pTipoCusto = estab-mat.custo-contab.
       
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Valida‡äes pertinentes ao DBO
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


