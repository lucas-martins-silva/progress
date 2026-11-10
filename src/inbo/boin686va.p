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
{include/i-prgvrs.i BOIN686VA 2.00.00.021 } /*** "010021" 12/09/2026 21:26:01 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin686va MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) Ç um programa PROGRESS 
                 que contÇm a l¢gica de neg¢cio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */
{cdp/cdcfgdis.i}
{cdp/cdcfgmat.i}
/*--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN686
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName fam-uni-estab
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 


/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin686.i RowObject}


/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/

{method/dboqry.i}
{utp/ut-glob.i}               

def var cProgramName as char no-undo.

/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

&if '{&BF_MAT_VERSAO_EMS}' >= '2.062':U &then 
    DEFINE VARIABLE h-cdapi024            AS HANDLE        NO-UNDO.
    
    DEF TEMP-TABLE tt-erro-aux NO-UNDO
        FIELD i-sequenc AS INT
        FIELD cd-erro   AS INT
        FIELD mensagem  AS CHAR FORMAT "x(255)".

    {cdp/cd9590.i} /*** Variaveis indicam que usa Unidade de Negocio ***/
&endif

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

find first param-compra no-lock no-error.

FIND FIRST param-estoq NO-LOCK NO-ERROR.

&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableCdFreq DBOProgram 
PROCEDURE enableCdFreq :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  param i-tp-ressup as int no-undo.
    def output param l-enable    as log no-undo.

    assign l-enable = i-tp-ressup = 3.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE EnableFields DBOProgram 
PROCEDURE EnableFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  param l-add        as log  no-undo.
    def input  param c-field-name as char no-undo.
    def output param l-enable     as log  no-undo.
    
    if  not avail RowObject then
        return "NOK":U.
    
    case c-field-name:
        when "cod-grp-compra":U then
           assign l-enable = (avail param-compra and param-compra.int-2 = 1). 
    end case.
    
    return "OK":U.
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

 /*   CASE pFieldName:
 *         WHEN "cd-planejado":U THEN ASSIGN pFieldValue = RowObject.cd-planejado.
 *         WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
 *         WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
 *         WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
 *         WHEN "cod-comprado":U THEN ASSIGN pFieldValue = RowObject.cod-comprado.
 *         WHEN "cod-estab-gestor":U THEN ASSIGN pFieldValue = RowObject.cod-estab-gestor.
 *         WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
 *         WHEN "cod-grp-compra":U THEN ASSIGN pFieldValue = RowObject.cod-grp-compra.
 *         WHEN "cod-localiz":U THEN ASSIGN pFieldValue = RowObject.cod-localiz.
 *         WHEN "dep-rej-cq":U THEN ASSIGN pFieldValue = RowObject.dep-rej-cq.
 *         WHEN "deposito-cq":U THEN ASSIGN pFieldValue = RowObject.deposito-cq.
 *         WHEN "deposito-pad":U THEN ASSIGN pFieldValue = RowObject.deposito-pad.
 *         WHEN "fm-codigo":U THEN ASSIGN pFieldValue = RowObject.fm-codigo.
 *         OTHERWISE RETURN "NOK":U.
 *     END CASE.*/

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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

/*    CASE pFieldName:
 *         WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
 *         WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
 *         WHEN "data-base":U THEN ASSIGN pFieldValue = RowObject.data-base.
 *         WHEN "data-pr-fisc":U THEN ASSIGN pFieldValue = RowObject.data-pr-fisc.
 *         WHEN "data-ult-con":U THEN ASSIGN pFieldValue = RowObject.data-ult-con.
 *         WHEN "data-ult-ent":U THEN ASSIGN pFieldValue = RowObject.data-ult-ent.
 *         WHEN "data-ult-rep":U THEN ASSIGN pFieldValue = RowObject.data-ult-rep.
 *         WHEN "data-ult-ressup":U THEN ASSIGN pFieldValue = RowObject.data-ult-ressup.
 *         WHEN "data-ult-sai":U THEN ASSIGN pFieldValue = RowObject.data-ult-sai.
 *         OTHERWISE RETURN "NOK":U.
 *     END CASE.*/

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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

/*    CASE pFieldName:
 *         WHEN "cap-est-fabr":U THEN ASSIGN pFieldValue = RowObject.cap-est-fabr.
 *         WHEN "consumo-aad":U THEN ASSIGN pFieldValue = RowObject.consumo-aad.
 *         WHEN "consumo-prev":U THEN ASSIGN pFieldValue = RowObject.consumo-prev.
 *         WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
 *         WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
 *         WHEN "fator-ponder[1]":U THEN ASSIGN pFieldValue = RowObject.fator-ponder[1].
 *         WHEN "fator-ponder[2]":U THEN ASSIGN pFieldValue = RowObject.fator-ponder[2].
 *         WHEN "fator-ponder[3]":U THEN ASSIGN pFieldValue = RowObject.fator-ponder[3].
 *         WHEN "fator-ponder[4]":U THEN ASSIGN pFieldValue = RowObject.fator-ponder[4].
 *         WHEN "fator-ponder[5]":U THEN ASSIGN pFieldValue = RowObject.fator-ponder[5].
 *         WHEN "fator-ponder[6]":U THEN ASSIGN pFieldValue = RowObject.fator-ponder[6].
 *         WHEN "fator-ponder[7]":U THEN ASSIGN pFieldValue = RowObject.fator-ponder[7].
 *         WHEN "fator-ponder[8]":U THEN ASSIGN pFieldValue = RowObject.fator-ponder[8].
 *         WHEN "fator-ponder[9]":U THEN ASSIGN pFieldValue = RowObject.fator-ponder[9].
 *         WHEN "fator-ponder[10]":U THEN ASSIGN pFieldValue = RowObject.fator-ponder[10].
 *         WHEN "fator-ponder[11]":U THEN ASSIGN pFieldValue = RowObject.fator-ponder[11].
 *         WHEN "fator-ponder[12]":U THEN ASSIGN pFieldValue = RowObject.fator-ponder[12].
 *         WHEN "fator-refugo":U THEN ASSIGN pFieldValue = RowObject.fator-refugo.
 *         WHEN "ind-cons-prv":U THEN ASSIGN pFieldValue = RowObject.ind-cons-prv.
 *         WHEN "lim-var-qtd":U THEN ASSIGN pFieldValue = RowObject.lim-var-qtd.
 *         WHEN "lim-var-valor":U THEN ASSIGN pFieldValue = RowObject.lim-var-valor.
 *         WHEN "lote-economi":U THEN ASSIGN pFieldValue = RowObject.lote-economi.
 *         WHEN "lote-minimo":U THEN ASSIGN pFieldValue = RowObject.lote-minimo.
 *         WHEN "lote-multipl":U THEN ASSIGN pFieldValue = RowObject.lote-multipl.
 *         WHEN "lote-per-max":U THEN ASSIGN pFieldValue = RowObject.lote-per-max.
 *         WHEN "ponto-encomenda":U THEN ASSIGN pFieldValue = RowObject.ponto-encomenda.
 *         WHEN "preco-base":U THEN ASSIGN pFieldValue = RowObject.preco-base.
 *         WHEN "preco-fiscal":U THEN ASSIGN pFieldValue = RowObject.preco-fiscal.
 *         WHEN "preco-repos":U THEN ASSIGN pFieldValue = RowObject.preco-repos.
 *         WHEN "preco-ul-ent":U THEN ASSIGN pFieldValue = RowObject.preco-ul-ent.
 *         WHEN "qt-max-ordem":U THEN ASSIGN pFieldValue = RowObject.qt-max-ordem.
 *         WHEN "qt-min-res-fabr":U THEN ASSIGN pFieldValue = RowObject.qt-min-res-fabr.
 *         WHEN "qtd-batch-padrao":U THEN ASSIGN pFieldValue = RowObject.qtd-batch-padrao.
 *         WHEN "qtd-refer-custo-dis":U THEN ASSIGN pFieldValue = RowObject.qtd-refer-custo-dis.
 *         WHEN "quant-perda":U THEN ASSIGN pFieldValue = RowObject.quant-perda.
 *         WHEN "quant-segur":U THEN ASSIGN pFieldValue = RowObject.quant-segur.
 *         WHEN "val-fator-custo-dis":U THEN ASSIGN pFieldValue = RowObject.val-fator-custo-dis.
 *         WHEN "var-mob-maior":U THEN ASSIGN pFieldValue = RowObject.var-mob-maior.
 *         WHEN "var-mob-menor":U THEN ASSIGN pFieldValue = RowObject.var-mob-menor.
 *         WHEN "var-qtd-re":U THEN ASSIGN pFieldValue = RowObject.var-qtd-re.
 *         WHEN "var-qtd-res-fabr":U THEN ASSIGN pFieldValue = RowObject.var-qtd-res-fabr.
 *         WHEN "var-rep":U THEN ASSIGN pFieldValue = RowObject.var-rep.
 *         WHEN "var-transf":U THEN ASSIGN pFieldValue = RowObject.var-transf.
 *         WHEN "var-val-re-maior":U THEN ASSIGN pFieldValue = RowObject.var-val-re-maior.
 *         WHEN "var-val-re-menor":U THEN ASSIGN pFieldValue = RowObject.var-val-re-menor.
 *         WHEN "variac-acum":U THEN ASSIGN pFieldValue = RowObject.variac-acum.
 *         WHEN "variacao-perm":U THEN ASSIGN pFieldValue = RowObject.variacao-perm.
 *         WHEN "vl-ggf-ant":U THEN ASSIGN pFieldValue = RowObject.vl-ggf-ant.
 *         WHEN "vl-mat-ant":U THEN ASSIGN pFieldValue = RowObject.vl-mat-ant.
 *         WHEN "vl-mob-ant":U THEN ASSIGN pFieldValue = RowObject.vl-mob-ant.
 *         WHEN "vl-var-max":U THEN ASSIGN pFieldValue = RowObject.vl-var-max.
 *         WHEN "vl-var-min":U THEN ASSIGN pFieldValue = RowObject.vl-var-min.
 *         OTHERWISE RETURN "NOK":U.
 *     END CASE.*/

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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

/*    CASE pFieldName:
 *         WHEN "cd-freq":U THEN ASSIGN pFieldValue = RowObject.cd-freq.
 *         WHEN "ciclo-contag":U THEN ASSIGN pFieldValue = RowObject.ciclo-contag.
 *         WHEN "classe-repro":U THEN ASSIGN pFieldValue = RowObject.classe-repro.
 *         WHEN "classif-abc":U THEN ASSIGN pFieldValue = RowObject.classif-abc.
 *         WHEN "cod-fat-ponder":U THEN ASSIGN pFieldValue = RowObject.cod-fat-ponder.
 *         WHEN "cod-obsoleto":U THEN ASSIGN pFieldValue = RowObject.cod-obsoleto.
 *         WHEN "contr-plan":U THEN ASSIGN pFieldValue = RowObject.contr-plan.
 *         WHEN "crit-cc":U THEN ASSIGN pFieldValue = RowObject.crit-cc.
 *         WHEN "crit-ce":U THEN ASSIGN pFieldValue = RowObject.crit-ce.
 *         WHEN "criticidade":U THEN ASSIGN pFieldValue = RowObject.criticidade.
 *         WHEN "demanda":U THEN ASSIGN pFieldValue = RowObject.demanda.
 *         WHEN "div-ordem":U THEN ASSIGN pFieldValue = RowObject.div-ordem.
 *         WHEN "emissao-ord":U THEN ASSIGN pFieldValue = RowObject.emissao-ord.
 *         WHEN "horiz-fixo":U THEN ASSIGN pFieldValue = RowObject.horiz-fixo.
 *         WHEN "ind-calc-meta":U THEN ASSIGN pFieldValue = RowObject.ind-calc-meta.
 *         WHEN "ind-lista-csp":U THEN ASSIGN pFieldValue = RowObject.ind-lista-csp.
 *         WHEN "ind-lista-mrp":U THEN ASSIGN pFieldValue = RowObject.ind-lista-mrp.
 *         WHEN "ind-prev-demanda":U THEN ASSIGN pFieldValue = RowObject.ind-prev-demanda.
 *         WHEN "ind-refugo":U THEN ASSIGN pFieldValue = RowObject.ind-refugo.
 *         WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
 *         WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
 *         WHEN "nat-despesa":U THEN ASSIGN pFieldValue = RowObject.nat-despesa.
 *         WHEN "nr-linha":U THEN ASSIGN pFieldValue = RowObject.nr-linha.
 *         WHEN "periodo-fixo":U THEN ASSIGN pFieldValue = RowObject.periodo-fixo.
 *         WHEN "perm-saldo-neg":U THEN ASSIGN pFieldValue = RowObject.perm-saldo-neg.
 *         WHEN "politica":U THEN ASSIGN pFieldValue = RowObject.politica.
 *         WHEN "prioridade":U THEN ASSIGN pFieldValue = RowObject.prioridade.
 *         WHEN "prioridade-aprov":U THEN ASSIGN pFieldValue = RowObject.prioridade-aprov.
 *         WHEN "rep-prod":U THEN ASSIGN pFieldValue = RowObject.rep-prod.
 *         WHEN "reporte-ggf":U THEN ASSIGN pFieldValue = RowObject.reporte-ggf.
 *         WHEN "reporte-mob":U THEN ASSIGN pFieldValue = RowObject.reporte-mob.
 *         WHEN "res-cq-comp":U THEN ASSIGN pFieldValue = RowObject.res-cq-comp.
 *         WHEN "res-cq-fabri":U THEN ASSIGN pFieldValue = RowObject.res-cq-fabri.
 *         WHEN "res-for-comp":U THEN ASSIGN pFieldValue = RowObject.res-for-comp.
 *         WHEN "res-int-comp":U THEN ASSIGN pFieldValue = RowObject.res-int-comp.
 *         WHEN "res-min-fabri":U THEN ASSIGN pFieldValue = RowObject.res-min-fabri.
 *         WHEN "ressup-fabri":U THEN ASSIGN pFieldValue = RowObject.ressup-fabri.
 *         WHEN "sit-aloc":U THEN ASSIGN pFieldValue = RowObject.sit-aloc.
 *         WHEN "tempo-segur":U THEN ASSIGN pFieldValue = RowObject.tempo-segur.
 *         WHEN "tipo-est-seg":U THEN ASSIGN pFieldValue = RowObject.tipo-est-seg.
 *         WHEN "tipo-lote-ec":U THEN ASSIGN pFieldValue = RowObject.tipo-lote-ec.
 *         WHEN "tipo-requis":U THEN ASSIGN pFieldValue = RowObject.tipo-requis.
 *         WHEN "tipo-sched":U THEN ASSIGN pFieldValue = RowObject.tipo-sched.
 *         WHEN "tp-aloc-lote":U THEN ASSIGN pFieldValue = RowObject.tp-aloc-lote.
 *         WHEN "tp-codigo":U THEN ASSIGN pFieldValue = RowObject.tp-codigo.
 *         WHEN "tp-ressup":U THEN ASSIGN pFieldValue = RowObject.tp-ressup.
 *         WHEN "var-tempo-res-fabr":U THEN ASSIGN pFieldValue = RowObject.var-tempo-res-fabr.
 *         OTHERWISE RETURN "NOK":U.
 *     END CASE.*/

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice codigo
  Parameters:  
               retorna valor do campo fm-codigo
               retorna valor do campo cod-estabel
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pfm-codigo LIKE fam-uni-estab.fm-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE fam-uni-estab.cod-estabel NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pfm-codigo = RowObject.fm-codigo
           pcod-estabel = RowObject.cod-estabel.

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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

/*    CASE pFieldName:
 *         WHEN "altera-conta":U THEN ASSIGN pFieldValue = RowObject.altera-conta.
 *         WHEN "contr-qualid":U THEN ASSIGN pFieldValue = RowObject.contr-qualid.
 *         WHEN "conv-tempo-seg":U THEN ASSIGN pFieldValue = RowObject.conv-tempo-seg.
 *         WHEN "curva-abc":U THEN ASSIGN pFieldValue = RowObject.curva-abc.
 *         WHEN "loc-unica":U THEN ASSIGN pFieldValue = RowObject.loc-unica.
 *         WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
 *         WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
 *         WHEN "log-ad-consumo":U THEN ASSIGN pFieldValue = RowObject.log-ad-consumo.
 *         WHEN "log-finaliz-op":U THEN ASSIGN pFieldValue = RowObject.log-finaliz-op.
 *         OTHERWISE RETURN "NOK":U.
 *     END CASE.*/

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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
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
  Purpose:     Reposiciona registro com base no °ndice codigo
  Parameters:  
               recebe valor do campo fm-codigo
               recebe valor do campo cod-estabel
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pfm-codigo LIKE fam-uni-estab.fm-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE fam-uni-estab.cod-estabel NO-UNDO.

    FIND FIRST bffam-uni-estab WHERE 
        bffam-uni-estab.fm-codigo = pfm-codigo AND 
        bffam-uni-estab.cod-estabel = pcod-estabel NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bffam-uni-estab THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bffam-uni-estab)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setProgramName DBOProgram 
PROCEDURE setProgramName :
/*------------------------------------------------------------------------------
  Parameters: pProgram - Recebe o nome do programa que est† executando o mÇtodo
  Notes:       
------------------------------------------------------------------------------*/
    def input param pProgram as char no-undo.

    assign cProgramName = pProgram.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    /*--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as validaá‰es ---*/
    
    IF cProgramName = "ce0333.w":U AND NOT AVAILABLE RowObject THEN DO:
        {method/svc/errors/inserr.i
            &ErrorNumber="58340"
            &ErrorType="EMS"
            &ErrorSubType="ERROR"
            &ErrorParameters="''"}
        RETURN "NOK":U.
    END.

    find first param-estoq no-lock no-error.

    if  not avail fam-uni-estab then
        find fam-uni-estab where
             fam-uni-estab.fm-codigo = RowObject.fm-codigo and
             fam-uni-estab.cod-estabel = RowObject.cod-estabel no-lock no-error.

    /* Inicio -- Projeto Internacional */
    DEFINE VARIABLE c-familia AS CHARACTER FORMAT "X(8)" NO-UNDO.
    {utp/ut-liter.i "Fam°lia" *}
    ASSIGN c-familia = TRIM(RETURN-VALUE).

    DEFINE VARIABLE c-deposito AS CHARACTER FORMAT "X(9)" NO-UNDO.
    {utp/ut-liter.i "Dep¢sito" *}
    ASSIGN c-deposito = TRIM(RETURN-VALUE).

     DEFINE VARIABLE c-natureza_despesa AS CHARACTER FORMAT "X(16)" NO-UNDO.
    {utp/ut-liter.i "Natureza Despesa" *}
    ASSIGN c-natureza_despesa = TRIM(RETURN-VALUE).

     DEFINE VARIABLE c-unidade_negocio AS CHARACTER FORMAT "X(19)" NO-UNDO.
    {utp/ut-liter.i "Unidade de Neg¢cio" *}
    ASSIGN c-unidade_negocio = TRIM(RETURN-VALUE).

    DEFINE VARIABLE c-estabelecimento AS CHARACTER FORMAT "X(15)" NO-UNDO.
    {utp/ut-liter.i "Estabelecimento" *}
    ASSIGN c-estabelecimento = TRIM(RETURN-VALUE).

    DEFINE VARIABLE c-compras AS CHARACTER FORMAT "X(7)" NO-UNDO.
    {utp/ut-liter.i "Compras" *}
    ASSIGN c-compras = TRIM(RETURN-VALUE).

    DEFINE VARIABLE c-comprador AS CHARACTER FORMAT "X(9)" NO-UNDO.
    {utp/ut-liter.i "Comprador" *}
    ASSIGN c-comprador = TRIM(RETURN-VALUE).

    DEFINE VARIABLE c-frequencia AS CHARACTER FORMAT "X(11)" NO-UNDO.
    {utp/ut-liter.i "Frequància" *}
    ASSIGN c-frequencia = TRIM(RETURN-VALUE).

    DEFINE VARIABLE c-formula AS CHARACTER FORMAT "X(8)" NO-UNDO.
    {utp/ut-liter.i "F¢rmula" *}
    ASSIGN c-formula = TRIM(RETURN-VALUE).


    
    case cProgramName:
         when "cd0136.w":U then do:

            if  RowObject.loc-unica 
            and avail fam-uni-estab
            and RowObject.cod-localiz <> fam-uni-estab.cod-localiz then do:
                 {method/svc/errors/inserr.i
                                 &ErrorNumber="26255" /* Localizacao nao pode ser alterada para itens com localizacao unica */
                                 &ErrorType="EMS"
                                 &ErrorSubType="ERROR"
                                 &ErrorParameters="c-familia" }
            end.

            for first deposito fields()
               where deposito.cod-depos = RowObject.deposito-pad no-lock: end.
            if  not avail deposito then do:
                {method/svc/errors/inserr.i
                                &ErrorNumber="2" /*Deposito n∆o cadastrado*/
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"
                                &ErrorParameters="c-deposito" }              
            end. 

            find localizacao
                 where localizacao.cod-estabel = RowObject.cod-estabel
                 and   localizacao.cod-depos   = RowObject.deposito-pad
                 and   localizacao.cod-localiz = RowObject.cod-localiz
                 no-lock no-error.
            if not avail localizacao THEN                
                {method/svc/errors/inserr.i &ErrorNumber="55076"
                                     &ErrorType="EMS"
                                     &ErrorSubType="ERROR"
                                     &ErrorParameters="RowObject.cod-localiz + '~~~~' + RowObject.deposito-pad + '~~~~' + RowObject.cod-estabel"}

            for first natureza-despesa fields()
                where natureza-despesa.nat-despesa = RowObject.nat-despesa no-lock: end.
            if  not avail natureza-despesa then do:
                {method/svc/errors/inserr.i
                                &ErrorNumber="2" /* Natureza Despesa n∆o cadastrada */
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"
                                &ErrorParameters="c-natureza_despesa" }
            
            end. 

            find first tipo-rec-desp 
                 where tipo-rec-desp.tp-codigo = RowObject.tp-desp-padrao no-lock no-error.
            if not avail tipo-rec-desp then do:                                
                {method/svc/errors/inserr.i
                                &ErrorNumber="146" /* Tipo Despesa n∆o cadastrada */
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" }
            end.
            else
            if tipo-rec-desp.tipo = 1 then do:
                {method/svc/errors/inserr.i
                                &ErrorNumber="414" /* Tipo Deve ser Despesa */
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" }
            end.

            &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN
            IF  l-mat-unid-negoc THEN DO:
                FIND FIRST unid-negoc
                     WHERE unid-negoc.cod-unid-negoc = RowObject.cod-unid-negoc NO-LOCK NO-ERROR.
                IF NOT AVAIL unid-negoc THEN DO:
                    {method/svc/errors/inserr.i
                                    &ErrorNumber="2" /* Unidade de NegÛcio n„o cadastrada */
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="c-unidade_negocio"}
                END.
            END.
            &endif
               
         end.
         when "cc0118.w":U then do:
              if RowObject.cod-estab-gestor <> "" then do:
                    find first estabelec
                         where estabelec.cod-estabel = RowObject.cod-estab-gestor no-lock no-error. 
                    if  not avail estabelec then do:
                        {method/svc/errors/inserr.i
                                        &ErrorNumber="2" /* Estabelecimento n∆o cadastrado */
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="c-estabelecimento"}
                    end.
              end.

              if  (avail param-compra and param-compra.int-2 = 1) /* por grupo de compra */
              and not can-find( first grupo-compra where grupo-compra.cod-grp-compra = RowObject.cod-grp-compra ) then do:
                  {method/svc/errors/inserr.i
                  &ErrorNumber="15262" /* Grupo de Compras n∆o encontrado */
                  &ErrorType="EMS"
                  &ErrorSubType="ERROR"
                  &ErrorParameters="c-compras" }
                  
              end.
               
              if  (avail param-compra and param-compra.int-2 = 2) /* por comprador */
              and not can-find( first comprador where comprador.cod-comprado = RowObject.cod-comprado ) then do:
                  {method/svc/errors/inserr.i
                                  &ErrorNumber="2" /* Comprador n∆o cadastrado */
                                  &ErrorType="EMS"
                                  &ErrorSubType="ERROR"
                                  &ErrorParameters="c-comprador" }
              end.
         
         end.
         when "ce0333.w":U then do:

             /* Parametros do Agente IA no contexto CE0333. */
             IF pType = "CREATE":U OR pType = "UPDATE":U THEN DO:
                 IF RowObject.log-contr-ag-ia = ? THEN DO:
                     {method/svc/errors/inserr.i
                         &ErrorNumber="58347"
                         &ErrorType="EMS"
                         &ErrorSubType="ERROR"
                         &ErrorParameters="''"}
                 END.

                 IF RowObject.dias-ocioso = ? OR RowObject.dias-ocioso < 0 THEN DO:
                     {method/svc/errors/inserr.i
                         &ErrorNumber="58348"
                         &ErrorType="EMS"
                         &ErrorSubType="ERROR"
                         &ErrorParameters="''"}
                 END.

                 IF RowObject.perc-excesso = ? OR RowObject.perc-excesso < 0 THEN DO:
                     {method/svc/errors/inserr.i
                         &ErrorNumber="58349"
                         &ErrorType="EMS"
                         &ErrorSubType="ERROR"
                         &ErrorParameters="''"}
                 END.

                 IF RowObject.log-contr-ag-ia = NO
                    AND RowObject.dias-ocioso <> ?
                    AND RowObject.perc-excesso <> ?
                    AND (RowObject.dias-ocioso > 0 OR RowObject.perc-excesso > 0) THEN DO:
                     {method/svc/errors/inserr.i
                         &ErrorNumber="58350"
                         &ErrorType="EMS"
                         &ErrorSubType="ERROR"
                         &ErrorParameters="''"}
                 END.

             END.
              if  RowObject.tp-ressup = 3 
              and not can-find(first frequencia 
                               where frequencia.cd-freq = RowObject.cd-freq) 
              then do:
                  {method/svc/errors/inserr.i
                                  &ErrorNumber="2" /*Frequància n∆o cadastrada*/
                                  &ErrorType="EMS"
                                  &ErrorSubType="ERROR"
                                  &ErrorParameters="c-frequencia" }                             
              end.
              
              if  RowObject.cod-fat-ponder <> 0
              and not can-find(first fat-ponder
                               where fat-ponder.cod-fat-ponder = RowObject.cod-fat-ponder) 
              then do:
                  {method/svc/errors/inserr.i
                                  &ErrorNumber="2" /*F¢rmula n∆o cadastrada*/
                                  &ErrorType="EMS"
                                  &ErrorSubType="ERROR"
                                  &ErrorParameters="c-formula" }                             
             end. 
         end.         
         /*when "re0105.w":U then do:
 *               for first classif-fisc fields ()
 *                   where classif-fisc.class-fiscal = RowObject.class-fiscal no-lock: end.
 *               if  not avail classif-fisc then do:
 *                   {method/svc/errors/inserr.i
 *                                   &ErrorNumber="2" /* Classificaá∆o Fiscal n∆o cadastrada */
 *                                   &ErrorType="EMS"
 *                                   &ErrorSubType="ERROR"
 *                                   &ErrorParameters="'Classificaá∆o Fiscal'" }
 *               end.
 *          end.*/
         when "cd0145.w":U then do:
            for first deposito fields()
               where deposito.cod-depos = RowObject.deposito-pad no-lock: end.
            if  not avail deposito then do:
                {method/svc/errors/inserr.i
                                &ErrorNumber="2" /*Deposito n∆o cadastrado*/
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"
                                &ErrorParameters="c-deposito" }              
            end. 

            find localizacao
                 where localizacao.cod-estabel = RowObject.cod-estabel
                 and   localizacao.cod-depos   = RowObject.deposito-pad
                 and   localizacao.cod-localiz = RowObject.cod-localiz
                 no-lock no-error.
            if  not avail localizacao then
                {method/svc/errors/inserr.i
                                &ErrorNumber="6662" /* Localizaá∆o n∆o cadastrada */
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" }        

            &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN
            IF  l-unidade-negocio
            AND l-dis-unid-negoc THEN DO:
                FIND FIRST unid-negoc
                     WHERE unid-negoc.cod-unid-negoc = RowObject.cod-unid-negoc NO-LOCK NO-ERROR.
                IF NOT AVAIL unid-negoc THEN DO:
                    {method/svc/errors/inserr.i
                                    &ErrorNumber="2" /* Unidade de Neg¢cio n∆o cadastrada */
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="c-unidade_negocio"}
                END.
                ELSE DO:
                    IF NOT VALID-HANDLE(h-cdapi024) THEN
                        RUN cdp/cdapi024.p PERSISTENT SET h-cdapi024.
                    
                    IF  VALID-HANDLE(h-cdapi024) THEN DO:
                        EMPTY TEMP-TABLE tt-erro-aux.
                        
                        /* UN x Estabel */
                        RUN ValidaUnidadeNegocioEstabel IN h-cdapi024 (INPUT RowObject.cod-estabel,
                                                                       INPUT TODAY,
                                                                       INPUT RowObject.cod-unid-negoc,
                                                                       OUTPUT TABLE tt-erro-aux).
                        IF CAN-FIND(FIRST tt-erro-aux) THEN DO:
                            FOR EACH tt-erro-aux:
                                CREATE rowerrors.
                                ASSIGN rowerrors.errornumber      = tt-erro-aux.cd-erro
                                       rowerrors.errortype        = "EMS":u
                                       rowerrors.errorsubtype     = "ERROR":u
                                       rowerrors.errordescription = tt-erro-aux.mensagem
                                       rowerrors.errorhelp        = tt-erro-aux.mensagem.
                            END.
                        END.
                        
                        RUN pi-finalizar IN h-cdapi024.
                        ASSIGN h-cdapi024 = ?.
                    END.
                END.
            END.
            &endif
         END. 
    END CASE.    
    
    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


