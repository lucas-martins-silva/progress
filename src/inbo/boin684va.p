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
{include/i-prgvrs.i BOIN684VA 2.00.00.046 } /*** "010046" 12/09/2026 21:26:01 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i boin684va MUT}
&ENDIF

{cdp/cdcfgmat.i}
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

/*--- Diretrizes de definiÓ“o ---*/
&GLOBAL-DEFINE DBOName BOIN684
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName item-uni-estab
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 


/*--- Include com definiá∆o da temptable RowObject ---*/
{utp/ut-glob.i}
      /*
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin684.i RowObject}


/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

def var cProgramName                as char no-undo.
DEF VAR l-funcao-operacional-textil AS LOG  NO-UNDO.

DEFINE VARIABLE l-trata-dep-ext AS LOGICAL     NO-UNDO.
DEFINE VARIABLE h-bocx250na     AS HANDLE      NO-UNDO.

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
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-enable-cod-grp-compra DBOProgram 
FUNCTION fn-enable-cod-grp-compra RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
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
         HEIGHT             = 16.13
         WIDTH              = 37.43.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroy DBOProgram 
PROCEDURE afterDestroy :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF VALID-HANDLE(h-bocx250na) THEN DO:
    RUN destroy IN h-bocx250na.
    ASSIGN h-bocx250na = ?.
END.


RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeCreateRecord DBOProgram 
PROCEDURE beforeCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN l-funcao-operacional-textil = CAN-FIND (FIRST funcao WHERE funcao.cd-funcao = "SPP-SGT":U) /* EAI + Operacional Textil implantados */.
    /*--- Verifica se registro foi encontrado, em caso de erro serŸ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.
    IF l-funcao-operacional-textil THEN DO:
        FIND FIRST ITEM 
            WHERE ITEM.it-codigo = RowObject.it-codigo NO-LOCK NO-ERROR.
        IF AVAIL ITEM THEN DO:
           
          FIND FIRST bfitem-uni-estab 
               WHERE bfitem-uni-estab.it-codigo   = RowObject.it-codigo 
                 AND bfitem-uni-estab.cod-estabel = RowObject.cod-estabel EXCLUSIVE-LOCK NO-ERROR.
            FIND FIRST fam-uni-estab
                 WHERE fam-uni-estab.fm-codigo   = ITEM.fm-codigo
                 AND   fam-uni-estab.cod-estabel = bfitem-uni-estab.cod-estabel NO-LOCK NO-ERROR.
            
            IF AVAIL fam-uni-estab THEN  DO:
                ASSIGN  bfitem-uni-estab.altera-conta =  fam-uni-estab.altera-conta.
            END.
            ELSE DO:
                
                 FIND FIRST familia-mat
                      WHERE familia-mat.fm-codigo   = ITEM.fm-codigo NO-LOCK NO-ERROR.
                 IF AVAIL familia-mat THEN 
                    ASSIGN bfitem-uni-estab.altera-conta =  familia-mat.altera-conta.
        
            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableFields DBOProgram 
PROCEDURE enableFields :
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
        when "quant-segur":U then
           assign l-enable = Rowobject.tipo-est-seg = 1.
           
        when "tempo-segur":U then
           assign l-enable = RowObject.tipo-est-seg = 2.
        
        when "cd-freq":U then
           assign l-enable = (can-find (first item-uni-estab 
                                        where item-uni-estab.it-codigo   = RowObject.it-codigo
                                          AND item-uni-estab.cod-estabel = RowObject.cod-estabel
                                          and item-uni-estab.tp-ressup = 3)).

        when "cod-grp-compra":U then
           assign l-enable = fn-enable-cod-grp-compra(). 
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

/*    CASE pFieldName:
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
 *         WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
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
               retorna valor do campo it-codigo
               retorna valor do campo cod-estabel
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pit-codigo LIKE item-uni-estab.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE item-uni-estab.cod-estabel NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pit-codigo = RowObject.it-codigo
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
               recebe valor do campo it-codigo
               recebe valor do campo cod-estabel
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pit-codigo LIKE item-uni-estab.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE item-uni-estab.cod-estabel NO-UNDO.

    FIND FIRST bfitem-uni-estab WHERE 
        bfitem-uni-estab.it-codigo = pit-codigo AND 
        bfitem-uni-estab.cod-estabel = pcod-estabel NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfitem-uni-estab THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfitem-uni-estab)).
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

    open query {&queryName} for each {&tableName} no-lock indexed-reposition.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setProgramName DBOProgram 
PROCEDURE setProgramName :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
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

    IF cProgramName = "ce0330.w":U AND NOT AVAILABLE RowObject THEN DO:
        {method/svc/errors/inserr.i
            &ErrorNumber="58338"
            &ErrorType="EMS"
            &ErrorSubType="ERROR"
            &ErrorParameters="''"}
        RETURN "NOK":U.
    END.

    find first param-estoq no-lock no-error.
    find first param-compra no-lock no-error.

    find item-uni-estab where 
         item-uni-estab.it-codigo = rowObject.it-codigo and
         item-uni-estab.cod-estabel = rowObject.cod-estabel no-lock no-error.
         
    case cProgramName:
       when "cd0140.w":U then do:
           &if "{&bf_mat_versao_ems}" >= "2.062" &then
           IF  l-mat-unid-negoc THEN DO:
               IF  NOT CAN-FIND(FIRST unid-negoc 
                                WHERE unid-negoc.cod-unid-negoc = rowObject.cod-unid-negoc NO-LOCK) THEN DO:
                   /* Inicio -- Projeto Internacional */
                   {utp/ut-table.i mgind unid-negoc 1} /* Busca o label da tabela */
                   {method/svc/errors/inserr.i &ErrorNumber="2"
                                               &ErrorType="EMS"
                                               &ErrorSubType="ERROR"
                                               &ErrorParameters=TRIM(RETURN-VALUE)}
               END.
               ELSE DO:
                   IF  NOT VALID-HANDLE(h-cdapi024) THEN
                        RUN cdp/cdapi024.p PERSISTENT SET h-cdapi024.
                    
                    IF  VALID-HANDLE(h-cdapi024) THEN DO:
                        EMPTY TEMP-TABLE tt-erro-aux.
                        
                        /* UN x Estabel */
                        RUN ValidaUnidadeNegocioEstabel IN h-cdapi024 (INPUT RowObject.cod-estabel,
                                                                       INPUT TODAY,
                                                                       INPUT RowObject.cod-unid-negoc,
                                                                       OUTPUT TABLE tt-erro-aux).
                        IF  CAN-FIND(FIRST tt-erro-aux) THEN DO:
                            FOR EACH tt-erro-aux:
                                CREATE RowErrors.
                                ASSIGN RowErrors.ErrorNumber      = tt-erro-aux.cd-erro
                                       RowErrors.ErrorType        = "EMS":U
                                       RowErrors.ErrorSubType     = "ERROR":U
                                       RowErrors.ErrorDescription = tt-erro-aux.mensagem
                                       RowErrors.ErrorHelp        = tt-erro-aux.mensagem.
                            END.
                        END.
                        
                        RUN pi-finalizar IN h-cdapi024.
                        ASSIGN h-cdapi024 = ?.
                    END.
               END.
           END.
           &endif
                   
                   if RowObject.politica <> 6
                     and avail item-uni-estab
             and RowObject.politica <> item-uni-estab.politica then do:
                     FIND FIRST prod-composto WHERE prod-composto.it-codigo-pai = RowObject.it-codigo NO-LOCK NO-ERROR.
                         IF AVAIL prod-composto THEN DO:
                            /* Inicio -- Projeto Internacional */
                            DEFINE VARIABLE c-lbl-liter-composto AS CHARACTER NO-UNDO.
                            {utp/ut-liter.i "Composto" *}
                            ASSIGN c-lbl-liter-composto = TRIM(RETURN-VALUE).
                            {method/svc/errors/inserr.i
                                &ErrorNumber="52216" /* Pol°tica composto possui relacionamentos */
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"
                                &ErrorParameters="c-lbl-liter-composto" } 
                         end.
                   end.
           
           if  RowObject.loc-unica 
            and avail item-uni-estab
            and RowObject.cod-localiz <> item-uni-estab.cod-localiz then do:
                 /* Inicio -- Projeto Internacional */
                 DEFINE VARIABLE c-lbl-liter-item AS CHARACTER NO-UNDO.
                 {utp/ut-liter.i "Item" *}
                 ASSIGN c-lbl-liter-item = TRIM(RETURN-VALUE).
                 {method/svc/errors/inserr.i
                                 &ErrorNumber="26255" /* Localizacao nao pode ser alterada para itens com localizacao unica */
                                 &ErrorType="EMS"
                                 &ErrorSubType="ERROR"
                                 &ErrorParameters="c-lbl-liter-item" }
            end.
                    
           if not can-find( first deposito
                            where deposito.cod-depos = RowObject.deposito-pad ) then do:
                /* Inicio -- Projeto Internacional */
                {utp/ut-table.i mgind deposito 1} /* Busca o label da tabela */
                {method/svc/errors/inserr.i
                                &ErrorNumber="2" /*Deposito n∆o cadastrado*/
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"
                                &ErrorParameters=TRIM(RETURN-VALUE)}
           end. 

           find first localizacao
                 where localizacao.cod-estabel = RowObject.cod-estabel  and
                       localizacao.cod-depos   = RowObject.deposito-pad and
                       localizacao.cod-localiz = RowObject.cod-localiz  no-lock no-error.
            if  not avail localizacao then
                {method/svc/errors/inserr.i &ErrorNumber="55076"
                                     &ErrorType="EMS"
                                     &ErrorSubType="ERROR"
                                     &ErrorParameters="RowObject.cod-localiz + '~~~~' + RowObject.deposito-pad + '~~~~' + RowObject.cod-estabel"}
                                
           if not can-find(first natureza-despesa
                           where natureza-despesa.nat-despesa = RowObject.nat-despesa ) then do:
                /* Inicio -- Projeto Internacional */
                {utp/ut-table.i mgind natureza-despesa 1} /* Busca o label da tabela */
                {method/svc/errors/inserr.i
                                &ErrorNumber="2" /*Natureza Despesa n∆o cadastrada*/
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"
                                &ErrorParameters=TRIM(RETURN-VALUE)}
           end.           
           find first tipo-rec-desp
                where tipo-rec-desp.tp-codigo = RowObject.tp-desp-padrao no-lock no-error.
           if not avail tipo-rec-desp then do:     
              /* Inicio -- Projeto Internacional */
              DEFINE VARIABLE c-lbl-liter-tipo-despesa AS CHARACTER NO-UNDO.
              {utp/ut-liter.i "Tipo_Despesa" *}
              ASSIGN c-lbl-liter-tipo-despesa = TRIM(RETURN-VALUE).
              {method/svc/errors/inserr.i
                              &ErrorNumber="2" /* Tipo Despesa n∆o cadastrada */
                              &ErrorType="EMS"
                              &ErrorSubType="ERROR" 
                              &ErrorParameters="c-lbl-liter-tipo-despesa"}
           end.
           else
           if  tipo-rec-desp.tipo = 1 then do:
               {method/svc/errors/inserr.i
                               &ErrorNumber="414" /*Tipo Deve ser Despesa */
                               &ErrorType="EMS"
                               &ErrorSubType="ERROR" }
                               
           end.

           IF i-pais-impto-usuario <> 1 THEN DO:

               FOR FIRST param-imp NO-LOCK
                   WHERE param-imp.cod-estabel = RowObject.cod-estabel: END.

               IF NOT VALID-HANDLE(h-bocx250na) THEN
                   RUN cxbo/bocx250na.p PERSISTENT SET h-bocx250na.

               RUN getTrataDepExternos IN h-bocx250na (INPUT RowObject.cod-estabel,
                                                       OUTPUT l-trata-dep-ext).               

               IF l-trata-dep-ext 
                   AND SUBSTRING(RowObject.char-2,31,3) = "" THEN DO:
                   {utp/ut-liter.i Dep¢sito_Externo *}                                                      
                   {method/svc/errors/inserr.i
                                   &ErrorNumber="2" /*Deposito n∆o cadastrado*/
                                   &ErrorType="EMS"
                                   &ErrorSubType="ERROR"
                                   &ErrorParameters=TRIM(RETURN-VALUE)}                   
               END.

               IF param-imp.log-trata-depos-draw
                   AND SUBSTRING(RowObject.char-2,34,3) = "" THEN DO:
                   {utp/ut-liter.i Dep¢sito_Drawback *}                                 
                   {method/svc/errors/inserr.i
                                   &ErrorNumber="2" /*Deposito n∆o cadastrado*/
                                   &ErrorType="EMS"
                                   &ErrorSubType="ERROR"
                                   &ErrorParameters=TRIM(RETURN-VALUE)}                   
               END.

               /*Dep¢sito Externo*/
               IF SUBSTRING(RowObject.char-2,31,3) <> "" THEN DO:
                   IF NOT CAN-FIND( FIRST deposito
                                    WHERE deposito.cod-depos = TRIM(SUBSTRING(RowObject.char-2,31,3)) ) THEN DO:
                       {utp/ut-liter.i Dep¢sito_Externo *}                                                      
                       {method/svc/errors/inserr.i
                                       &ErrorNumber="2" /*Deposito nío cadastrado*/
                                       &ErrorType="EMS"
                                       &ErrorSubType="ERROR"
                                       &ErrorParameters="RETURN-VALUE" }              
                   END. 
                   ELSE DO:
                       IF NOT CAN-FIND( FIRST deposito
                                        WHERE deposito.cod-depos   = TRIM(SUBSTRING(RowObject.char-2,31,3))
                                        AND   deposito.ind-tipo-dep = 2) THEN DO:
                           {utp/ut-liter.i Dep¢sito_Externo *}                   
                           {method/svc/errors/inserr.i
                                           &ErrorNumber="18440" /*Deposito nío cadastrado*/
                                           &ErrorType="EMS"
                                           &ErrorSubType="ERROR"
                                           &ErrorParameters="RETURN-VALUE + '~~~~' + RETURN-VALUE"}   

                       END.
                   END.               
               END.

               /*Dep¢sito Drawback*/
               IF SUBSTRING(RowObject.char-2,34,3) <> "" THEN DO:
                   IF NOT CAN-FIND( FIRST deposito
                                    WHERE deposito.cod-depos = TRIM(SUBSTRING(RowObject.char-2,34,3)) ) THEN DO:
                       {utp/ut-liter.i Dep¢sito_Drawback *}                                 
                       {method/svc/errors/inserr.i
                                       &ErrorNumber="2" /*Deposito nío cadastrado*/
                                       &ErrorType="EMS"
                                       &ErrorSubType="ERROR"
                                       &ErrorParameters="RETURN-VALUE" }              
                   END. 
               END.
           END.
           if RowObject.politica = 2 and RowObject.lote-economi = 0 then do:
               /* Inicio -- Projeto Internacional */
               DEFINE VARIABLE c-lbl-liter-lote-economico AS CHARACTER NO-UNDO.
               {utp/ut-liter.i "Lote_EconÀmico" *}
               ASSIGN c-lbl-liter-lote-economico = TRIM(RETURN-VALUE).
               {method/svc/errors/inserr.i
                                &ErrorNumber="6179" /* Lote economico deve ser maior do que zero  */
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"
                                &ErrorParameters="c-lbl-liter-lote-economico" }
           end.
       end.       
       
       when "cc0120.w":U then do:
          if RowObject.cod-estab-gestor <> "" then do:
              if not can-find( first estabelec
                               where estabelec.cod-estabel = RowObject.cod-estab-gestor ) then do:
                  /* Inicio -- Projeto Internacional */
                  {utp/ut-table.i mgadm estabelec 1} /* Busca o label da tabela */
                  {method/svc/errors/inserr.i
                                  &ErrorNumber="2" /* Estabelecimento n∆o cadastrado */
                                  &ErrorType="EMS"
                                  &ErrorSubType="ERROR"
                                  &ErrorParameters=TRIM(RETURN-VALUE)}
              end.
          end. 
          
          if  (avail param-compra and param-compra.int-2 = 1) /* por grupo de compra */
          and not can-find( first grupo-compra where grupo-compra.cod-grp-compra = RowObject.cod-grp-compra ) then do:
              /* Inicio -- Projeto Internacional */
              DEFINE VARIABLE c-lbl-liter-compras AS CHARACTER NO-UNDO.
              {utp/ut-liter.i "Compras" *}
              ASSIGN c-lbl-liter-compras = TRIM(RETURN-VALUE).
              {method/svc/errors/inserr.i
                              &ErrorNumber="15262" /* Grupo de Compras n∆o encontrado */
                              &ErrorType="EMS"
                              &ErrorSubType="ERROR"
                              &ErrorParameters="c-lbl-liter-compras" }
          end. 

          if  (avail param-compra and param-compra.int-2 = 2) /* por comprador */
          and not can-find( first comprador where comprador.cod-comprado = RowObject.cod-comprado ) then do:
              /* Inicio -- Projeto Internacional */
              {utp/ut-table.i mgind comprador 1} /* Busca o label da tabela */
              {method/svc/errors/inserr.i
                              &ErrorNumber="2" /* Comprador n∆o cadastrado */
                              &ErrorType="EMS"
                              &ErrorSubType="ERROR"
                              &ErrorParameters=TRIM(RETURN-VALUE)}
          end.
        
       end.
       when "cd0147.w":U then do:

            for first deposito fields()
                where deposito.cod-depos = RowObject.deposito-pad no-lock: end.
            
                        if  not avail deposito then do:
                /* Inicio -- Projeto Internacional */
                {utp/ut-table.i mgind deposito 1} /* Busca o label da tabela */
                {method/svc/errors/inserr.i
                                &ErrorNumber="2" /*Deposito n∆o cadastrado*/
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"
                                &ErrorParameters=TRIM(RETURN-VALUE)}
            end. 

            find first localizacao
                 where localizacao.cod-estabel = RowObject.cod-estabel  and
                       localizacao.cod-depos   = RowObject.deposito-pad and
                       localizacao.cod-localiz = RowObject.cod-localiz  no-lock no-error.
                                           
            if  not avail localizacao then
                {method/svc/errors/inserr.i
                                &ErrorNumber="6662" /*Localizaá∆o n∆o cadastrada*/
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" }
                                
                        if trim(substring(RowObject.char-2,21,10)) <> "" then
                                if not can-find(first tab-codser
                                                                where tab-codser.cod-servico = int(trim(substring(RowObject.char-2,21,10)))) then do:
                                        {method/svc/errors/inserr.i &ErrorNumber="7494"
                                                                                                &ErrorType="EMS"
                                                                                                &ErrorSubType="ERROR" 
                                                                                                &ErrorParameters="trim(substring(RowObject.char-2,21,10))"}                                                     
                                end.

       
         
            &if "{&bf_mat_versao_ems}" >= "2.062" &then
            if  l-dis-unid-negoc  then do:
               if  not can-find(first unid-negoc 
                                where unid-negoc.cod-unid-negoc = rowobject.cod-unid-negoc no-lock) then do:
                   /* inicio -- projeto internacional */
                   {utp/ut-table.i mgind unid-negoc 1} /* busca o label da tabela */
                   {method/svc/errors/inserr.i &ErrorNumber="2"
                                               &ErrorType="EMS"
                                               &ErrorSubType="ERROR"
                                               &ErrorParameters=TRIM(RETURN-VALUE)}
               end.
               else do:
                   if  not valid-handle(h-cdapi024) then
                        run cdp/cdapi024.p persistent set h-cdapi024.
                    
                    if  valid-handle(h-cdapi024) then do:
                        empty temp-table tt-erro-aux.
                        
                        /* UN x Estabel */
                        RUN ValidaUnidadeNegocioEstabel IN h-cdapi024 (input RowObject.cod-estabel,
                                                                       input TODAY,
                                                                       input RowObject.cod-unid-negoc,
                                                                       output table tt-erro-aux).
                        if  can-find(first tt-erro-aux) then do:
                            for each tt-erro-aux:
                                create rowerrors.
                                assign rowerrors.errornumber      = tt-erro-aux.cd-erro
                                       rowerrors.errortype        = "ems":u
                                       rowerrors.errorsubtype     = "error":u
                                       rowerrors.errordescription = tt-erro-aux.mensagem
                                       rowerrors.errorhelp        = tt-erro-aux.mensagem.
                            end.
                        end.
                        
                        run pi-finalizar in h-cdapi024.
                        assign h-cdapi024 = ?.
                    end.
                end.
            end.
            &endif
       end.   
       when "ce0330.w":U then do:

            /* Parametros do Agente IA no contexto CE0330. */
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
           
            if  RowObject.metodo-custeio <> {&tablename}.metodo-custeio 
            and can-find(first item-estab 
                         where item-estab.it-codigo   = rowobject.it-codigo
                           and item-estab.cod-estabel = rowobject.cod-estabel) 
            AND CAN-FIND(FIRST movto-estoq
                         WHERE movto-estoq.it-codigo   = rowobject.it-codigo
                           AND movto-estoq.cod-estabel = rowobject.cod-estabel) 
            then do:

                {method/svc/errors/inserr.i
                                &ErrorNumber="26219" /* MÇtodo de Custeio n∆o pode ser alterado para itens com movimentaá∆o */
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" }                
                
            end.
                          
            if  RowObject.metodo-custeio = 6 /* custo espec°fico */
            and can-find(first item
                         where item.it-codigo    = RowObject.it-codigo
                           and item.tipo-con-est = 1) /* Serial */
            then do:
                {method/svc/errors/inserr.i
                                &ErrorNumber="26164" /*Custo Espec°fico Inv†lido Para Tipo de controle de Estoque!*/
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" }
            end.

            find first frequencia
                 where frequencia.cd-freq = rowObject.cd-freq no-lock no-error.
            if not avail frequencia and RowObject.tp-ressup = 3 then do:
                     /* Inicio -- Projeto Internacional */
                     DEFINE VARIABLE c-lbl-liter-frequencia AS CHARACTER NO-UNDO.
                     {utp/ut-liter.i "Frequància" *}
                     ASSIGN c-lbl-liter-frequencia = TRIM(RETURN-VALUE).
                     {method/svc/errors/inserr.i
                               &ErrorNumber="56" /* Frequància inexistente */
                               &ErrorType="EMS"
                               &ErrorSubType="ERROR"
                               &ErrorParameters="c-lbl-liter-frequencia" }
            end.
       end.
       WHEN  "cd0157" THEN DO:
           /* Validaá∆o campo emitente */
           IF RowObject.log-benef  = YES THEN
           FOR first emitente fields()
               where emitente.cod-emitente = RowObject.cdn-emit-benef no-lock: end.
               
           if not avail emitente then do:
               {utp/ut-liter.i "Emitente"}
               {method/svc/errors/inserr.i
                               &ErrorNumber="2" /*Emitente n∆o cadastrado*/
                               &ErrorType="EMS"
                               &ErrorSubType="ERROR"
                               &ErrorParameters=TRIM(RETURN-VALUE)}                                
           end.         

       END.

    end case.
    
    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-enable-cod-grp-compra DBOProgram 
FUNCTION fn-enable-cod-grp-compra RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
   find first param-compra no-lock no-error.
   /* se o parÉmetro "int-2" for 1, ent∆o usa grupo de compra */
   
   RETURN (param-compra.int-2 = 1).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

