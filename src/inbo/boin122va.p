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
{include/i-prgvrs.i BOIN122VA 2.00.00.025 } /*** "010025" 12/09/2026 21:26:00 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin122va MUT}
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
&GLOBAL-DEFINE DBOName BOIN122
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName familia
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 


/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin122.i RowObject}
def temp-table tt-familia-mat no-undo like familia-mat
    field r-rowid as rowid.

/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}             
{utp/ut-glob.i}               

/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

&if '{&BF_MAT_VERSAO_EMS}' >= '2.062':U &then
    {cdp/cd9590.i} /*** Variaveis indicam que usa Unidade de Negocio ***/
&endif

DEFINE VARIABLE c-texto             AS CHARACTER                NO-UNDO.
DEFINE VARIABLE c-texto-1           AS CHARACTER                NO-UNDO.
DEFINE VARIABLE c-cod-estabel-usuar AS CHARACTER format "x(05)" NO-UNDO.


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
         HEIGHT             = 1.75
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
ASSIGN c-cod-estabel-usuar = param-estoq.estabel-pad.

&IF DEFINED(Bf_dis_usuario_estab) &THEN
    IF CAN-FIND(funcao WHERE funcao.cd-funcao = "Fn-estab-usuario"
                         AND funcao.ativo     = YES) THEN DO:
       RUN cdp/cd8702.p (INPUT c-seg-usuario,
                              INPUT-OUTPUT c-cod-estabel-usuar).
    END.
&ENDIF

/* _UIB-CODE-BLOCK-END */
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
/*
 *     /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
 *           retornada flag "NOK":U ---*/
 *     IF NOT AVAILABLE RowObject THEN 
 *         RETURN "NOK":U.
 * 
 *     CASE pFieldName:
 *         WHEN "cd-planejado":U THEN ASSIGN pFieldValue = RowObject.cd-planejado.
 *         WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
 *         WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
 *         WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
 *         WHEN "class-fiscal":U THEN ASSIGN pFieldValue = RowObject.class-fiscal.
 *         WHEN "cod-comprado":U THEN ASSIGN pFieldValue = RowObject.cod-comprado.
 *         WHEN "cod-lista-destino":U THEN ASSIGN pFieldValue = RowObject.cod-lista-destino.
 *         WHEN "cod-localiz":U THEN ASSIGN pFieldValue = RowObject.cod-localiz.
 *         WHEN "deposito-pad":U THEN ASSIGN pFieldValue = RowObject.deposito-pad.
 *         WHEN "descricao":U THEN ASSIGN pFieldValue = RowObject.descricao.
 *         WHEN "fm-codigo":U THEN ASSIGN pFieldValue = RowObject.fm-codigo.
 *         WHEN "niv-rest-icms":U THEN ASSIGN pFieldValue = RowObject.niv-rest-icms.
 *         WHEN "un":U THEN ASSIGN pFieldValue = RowObject.un.
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
/*
 * /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
 *         retornada flag "NOK":U ---*/
 *   IF NOT AVAILABLE RowObject THEN 
 *       RETURN "NOK":U.
 * 
 *   CASE pFieldName:
 *       WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
 *       WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
 *       OTHERWISE RETURN "NOK":U.
 *   END CASE.*/

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
 *         WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
 *         WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
 *         WHEN "fator-conver":U THEN ASSIGN pFieldValue = RowObject.fator-conver.
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
 *         WHEN "lote-economi":U THEN ASSIGN pFieldValue = RowObject.lote-economi.
 *         WHEN "lote-minimo":U THEN ASSIGN pFieldValue = RowObject.lote-minimo.
 *         WHEN "lote-multipl":U THEN ASSIGN pFieldValue = RowObject.lote-multipl.
 *         WHEN "per-rest-icms":U THEN ASSIGN pFieldValue = RowObject.per-rest-icms.
 *         WHEN "perc-nqa":U THEN ASSIGN pFieldValue = RowObject.perc-nqa.
 *         WHEN "qt-max-ordem":U THEN ASSIGN pFieldValue = RowObject.qt-max-ordem.
 *         WHEN "qtd-batch-padrao":U THEN ASSIGN pFieldValue = RowObject.qtd-batch-padrao.
 *         WHEN "quant-perda":U THEN ASSIGN pFieldValue = RowObject.quant-perda.
 *         WHEN "quant-segur":U THEN ASSIGN pFieldValue = RowObject.quant-segur.
 *         WHEN "sazonalidade[1]":U THEN ASSIGN pFieldValue = RowObject.sazonalidade[1].
 *         WHEN "sazonalidade[2]":U THEN ASSIGN pFieldValue = RowObject.sazonalidade[2].
 *         WHEN "sazonalidade[3]":U THEN ASSIGN pFieldValue = RowObject.sazonalidade[3].
 *         WHEN "sazonalidade[4]":U THEN ASSIGN pFieldValue = RowObject.sazonalidade[4].
 *         WHEN "sazonalidade[5]":U THEN ASSIGN pFieldValue = RowObject.sazonalidade[5].
 *         WHEN "sazonalidade[6]":U THEN ASSIGN pFieldValue = RowObject.sazonalidade[6].
 *         WHEN "sazonalidade[7]":U THEN ASSIGN pFieldValue = RowObject.sazonalidade[7].
 *         WHEN "sazonalidade[8]":U THEN ASSIGN pFieldValue = RowObject.sazonalidade[8].
 *         WHEN "sazonalidade[9]":U THEN ASSIGN pFieldValue = RowObject.sazonalidade[9].
 *         WHEN "sazonalidade[10]":U THEN ASSIGN pFieldValue = RowObject.sazonalidade[10].
 *         WHEN "sazonalidade[11]":U THEN ASSIGN pFieldValue = RowObject.sazonalidade[11].
 *         WHEN "sazonalidade[12]":U THEN ASSIGN pFieldValue = RowObject.sazonalidade[12].
 *         WHEN "tp-cons-prev":U THEN ASSIGN pFieldValue = RowObject.tp-cons-prev.
 *         WHEN "var-mob-maior":U THEN ASSIGN pFieldValue = RowObject.var-mob-maior.
 *         WHEN "var-mob-menor":U THEN ASSIGN pFieldValue = RowObject.var-mob-menor.
 *         WHEN "var-pre-perm":U THEN ASSIGN pFieldValue = RowObject.var-pre-perm.
 *         WHEN "var-qtd-perm":U THEN ASSIGN pFieldValue = RowObject.var-qtd-perm.
 *         WHEN "var-rep":U THEN ASSIGN pFieldValue = RowObject.var-rep.
 *         WHEN "var-req-maior":U THEN ASSIGN pFieldValue = RowObject.var-req-maior.
 *         WHEN "var-req-menor":U THEN ASSIGN pFieldValue = RowObject.var-req-menor.
 *         WHEN "var-transf":U THEN ASSIGN pFieldValue = RowObject.var-transf.
 *         WHEN "vl-max-inv":U THEN ASSIGN pFieldValue = RowObject.vl-max-inv.
 *         WHEN "vl-min-inv":U THEN ASSIGN pFieldValue = RowObject.vl-min-inv.
 *         OTHERWISE RETURN "NOK":U.
 *     END CASE.*/

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescTpDesp DBOProgram 
PROCEDURE getDescTpDesp :
/*------------------------------------------------------------------------------
  Parameters: pc-tp-desp      - recebe o c¢digo do tipo de despesa
              pc-desc-tp-desp - retorna a descriá∆o
  Notes:       
------------------------------------------------------------------------------*/
    def input  param pc-tp-desp      like fam-uni-estab.tp-desp-padrao no-undo.
    def output param pc-desc-tp-desp like tipo-rec-desp.descricao      no-undo.

    for first tipo-rec-desp  fields(descricao)
        where tipo-rec-desp.tp-codigo = pc-tp-desp no-lock: end.
        
    if avail tipo-rec-desp then
       assign pc-desc-tp-desp = tipo-rec-desp.descricao.    
    else do:
         assign pc-desc-tp-desp = "".
         return "NOK":U.
    end.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getEnableGrpCompra DBOProgram 
PROCEDURE getEnableGrpCompra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def output param l-enable-grp-compra as log no-undo.

if avail param-compra then do:
   assign l-enable-grp-compra = if param-compra.int-2 = 1 then yes else no.
end.

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
 *         WHEN "cd-formula":U THEN ASSIGN pFieldValue = RowObject.cd-formula.
 *         WHEN "cd-origem":U THEN ASSIGN pFieldValue = RowObject.cd-origem.
 *         WHEN "cd-trib-icm":U THEN ASSIGN pFieldValue = RowObject.cd-trib-icm.
 *         WHEN "cd-trib-ipi":U THEN ASSIGN pFieldValue = RowObject.cd-trib-ipi.
 *         WHEN "cd-trib-iss":U THEN ASSIGN pFieldValue = RowObject.cd-trib-iss.
 *         WHEN "ciclo-contag":U THEN ASSIGN pFieldValue = RowObject.ciclo-contag.
 *         WHEN "classe-repro":U THEN ASSIGN pFieldValue = RowObject.classe-repro.
 *         WHEN "cod-servico":U THEN ASSIGN pFieldValue = RowObject.cod-servico.
 *         WHEN "cod-taxa":U THEN ASSIGN pFieldValue = RowObject.cod-taxa.
 *         WHEN "codigo-orig":U THEN ASSIGN pFieldValue = RowObject.codigo-orig.
 *         WHEN "criticidade":U THEN ASSIGN pFieldValue = RowObject.criticidade.
 *         WHEN "demanda":U THEN ASSIGN pFieldValue = RowObject.demanda.
 *         WHEN "div-ordem":U THEN ASSIGN pFieldValue = RowObject.div-ordem.
 *         WHEN "emissao-ord":U THEN ASSIGN pFieldValue = RowObject.emissao-ord.
 *         WHEN "horiz-fixo":U THEN ASSIGN pFieldValue = RowObject.horiz-fixo.
 *         WHEN "ind-calc-meta":U THEN ASSIGN pFieldValue = RowObject.ind-calc-meta.
 *         WHEN "ind-imp-desc":U THEN ASSIGN pFieldValue = RowObject.ind-imp-desc.
 *         WHEN "ind-lista-mrp":U THEN ASSIGN pFieldValue = RowObject.ind-lista-mrp.
 *         WHEN "ind-prev-demanda":U THEN ASSIGN pFieldValue = RowObject.ind-prev-demanda.
 *         WHEN "ind-refugo":U THEN ASSIGN pFieldValue = RowObject.ind-refugo.
 *         WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
 *         WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
 *         WHEN "moeda-padrao":U THEN ASSIGN pFieldValue = RowObject.moeda-padrao.
 *         WHEN "nivel":U THEN ASSIGN pFieldValue = RowObject.nivel.
 *         WHEN "nivel-apr-compra":U THEN ASSIGN pFieldValue = RowObject.nivel-apr-compra.
 *         WHEN "nivel-apr-manut":U THEN ASSIGN pFieldValue = RowObject.nivel-apr-manut.
 *         WHEN "nivel-apr-requis":U THEN ASSIGN pFieldValue = RowObject.nivel-apr-requis.
 *         WHEN "nivel-apr-solic":U THEN ASSIGN pFieldValue = RowObject.nivel-apr-solic.
 *         WHEN "nr-linha":U THEN ASSIGN pFieldValue = RowObject.nr-linha.
 *         WHEN "num-id-familia":U THEN ASSIGN pFieldValue = RowObject.num-id-familia.
 *         WHEN "periodo-fixo":U THEN ASSIGN pFieldValue = RowObject.periodo-fixo.
 *         WHEN "perm-saldo-neg":U THEN ASSIGN pFieldValue = RowObject.perm-saldo-neg.
 *         WHEN "politica":U THEN ASSIGN pFieldValue = RowObject.politica.
 *         WHEN "prioridade":U THEN ASSIGN pFieldValue = RowObject.prioridade.
 *         WHEN "rep-prod":U THEN ASSIGN pFieldValue = RowObject.rep-prod.
 *         WHEN "reporte-ggf":U THEN ASSIGN pFieldValue = RowObject.reporte-ggf.
 *         WHEN "reporte-mob":U THEN ASSIGN pFieldValue = RowObject.reporte-mob.
 *         WHEN "res-cq-comp":U THEN ASSIGN pFieldValue = RowObject.res-cq-comp.
 *         WHEN "res-cq-fabri":U THEN ASSIGN pFieldValue = RowObject.res-cq-fabri.
 *         WHEN "res-for-comp":U THEN ASSIGN pFieldValue = RowObject.res-for-comp.
 *         WHEN "res-int-comp":U THEN ASSIGN pFieldValue = RowObject.res-int-comp.
 *         WHEN "ressup-fabri":U THEN ASSIGN pFieldValue = RowObject.ressup-fabri.
 *         WHEN "sit-aloc":U THEN ASSIGN pFieldValue = RowObject.sit-aloc.
 *         WHEN "tempo-segur":U THEN ASSIGN pFieldValue = RowObject.tempo-segur.
 *         WHEN "tipo-con-est":U THEN ASSIGN pFieldValue = RowObject.tipo-con-est.
 *         WHEN "tipo-contr":U THEN ASSIGN pFieldValue = RowObject.tipo-contr.
 *         WHEN "tipo-est-seg":U THEN ASSIGN pFieldValue = RowObject.tipo-est-seg.
 *         WHEN "tipo-insp":U THEN ASSIGN pFieldValue = RowObject.tipo-insp.
 *         WHEN "tipo-lote-ec":U THEN ASSIGN pFieldValue = RowObject.tipo-lote-ec.
 *         WHEN "tipo-requis":U THEN ASSIGN pFieldValue = RowObject.tipo-requis.
 *         WHEN "tipo-sched":U THEN ASSIGN pFieldValue = RowObject.tipo-sched.
 *         WHEN "tp-adm-lote":U THEN ASSIGN pFieldValue = RowObject.tp-adm-lote.
 *         WHEN "var-preco":U THEN ASSIGN pFieldValue = RowObject.var-preco.
 *         WHEN "var-quantid":U THEN ASSIGN pFieldValue = RowObject.var-quantid.
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
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pfm-codigo LIKE familia.fm-codigo NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pfm-codigo = RowObject.fm-codigo.

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
 *         WHEN "atu-conf":U THEN ASSIGN pFieldValue = RowObject.atu-conf.
 *         WHEN "baixa-estoq":U THEN ASSIGN pFieldValue = RowObject.baixa-estoq.
 *         WHEN "contr-qualid":U THEN ASSIGN pFieldValue = RowObject.contr-qualid.
 *         WHEN "conv-tempo-seg":U THEN ASSIGN pFieldValue = RowObject.conv-tempo-seg.
 *         WHEN "curva-abc":U THEN ASSIGN pFieldValue = RowObject.curva-abc.
 *         WHEN "fraciona":U THEN ASSIGN pFieldValue = RowObject.fraciona.
 *         WHEN "ind-inf-qtf":U THEN ASSIGN pFieldValue = RowObject.ind-inf-qtf.
 *         WHEN "invent-cla-a":U THEN ASSIGN pFieldValue = RowObject.invent-cla-a.
 *         WHEN "invent-cla-b":U THEN ASSIGN pFieldValue = RowObject.invent-cla-b.
 *         WHEN "invent-cla-c":U THEN ASSIGN pFieldValue = RowObject.invent-cla-c.
 *         WHEN "loc-unica":U THEN ASSIGN pFieldValue = RowObject.loc-unica.
 *         WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
 *         WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
 *         WHEN "log-atualiz-via-mmp":U THEN ASSIGN pFieldValue = RowObject.log-atualiz-via-mmp.
 *         WHEN "log-utiliza-batch-padrao":U THEN ASSIGN pFieldValue = RowObject.log-utiliza-batch-padrao.
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
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pfm-codigo LIKE familia.fm-codigo NO-UNDO.

    FIND FIRST bffamilia WHERE 
        bffamilia.fm-codigo = pfm-codigo NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bffamilia THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bffamilia)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnEnableUnidNeg DBOProgram 
PROCEDURE returnEnableUnidNeg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Retorna se o sistema foi parametrizado para utilizar Unidade de Negocio.      
------------------------------------------------------------------------------*/    
    def output param l-unid-neg as log no-undo.
    
    find first param-estoq no-lock no-error.
    
    /* Unidade Neg¢cio */
    assign l-unid-neg = no.
    
    find first param-mat no-lock no-error.
    if  avail param-mat 
    and param-mat.ind-unid-neg then 
        assign l-unid-neg = yes.
    
    if  substring(param-estoq.char-2,2,1) = "@":U
    and ( can-find(funcao where funcao.cd-funcao = "adm-apb-ems-5.00":U
                          and funcao.ativo = yes
                          and funcao.log-1 = yes) 
    or  can-find(funcao where funcao.cd-funcao = "adm-cfl-ems-5.00":U
                          and funcao.ativo = yes  
                          and funcao.log-1 = yes)  ) then 
        assign l-unid-neg = yes.
    
    
    return "OK":U.
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe - o tipo de alteraá∆o (create/update/delete);
                      - o nome do programa que est† alterando o registro;
                      - as temp-tables tt-familia e tt-familia-mat com os dados
                        a serem validados.
  Notes:       
------------------------------------------------------------------------------*/

    /*--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as validaá‰es ---*/
    
    DEFINE INPUT PARAMETER pType    AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pProgram AS CHARACTER NO-UNDO.
    
    DEFINE INPUT PARAM TABLE FOR RowObject. /* tt-familia */
    DEFINE INPUT PARAM TABLE FOR tt-familia-mat.
    
    find first rowObject no-error.
    find first tt-familia-mat no-error.
    find first param-estoq no-lock no-error.
    
    
    find familia where
         familia.fm-codigo = RowObject.fm-codigo no-lock no-error.
    
    case pProgram:
       when "cd0134.w":U then do:

           if  RowObject.loc-unica 
           and avail familia
           and RowObject.cod-localiz <> familia.cod-localiz then do:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-familia AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Fam°lia" *}
                ASSIGN c-lbl-liter-familia = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                                &ErrorNumber="26255" /* Localizacao nao pode ser alterada para itens com localizacao unica */
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"
                                &ErrorParameters="c-lbl-liter-familia" }
           end.
             
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
                 where localizacao.cod-estabel = c-cod-estabel-usuar  and
                       localizacao.cod-depos   = RowObject.deposito-pad and
                       localizacao.cod-localiz = RowObject.cod-localiz  no-lock no-error.
            if  not avail localizacao then
                {method/svc/errors/inserr.i &ErrorNumber="55076"
                                     &ErrorType="EMS"
                                     &ErrorSubType="ERROR"
                                     &ErrorParameters="RowObject.cod-localiz + '~~~~' + RowObject.deposito-pad + '~~~~' + c-cod-estabel-usuar"}

            for first natureza-despesa fields()
                where natureza-despesa.nat-despesa = tt-familia-mat.nat-despesa no-lock: end.
            if  not avail natureza-despesa then do:
                /* Inicio -- Projeto Internacional */
                {utp/ut-table.i mgind natureza-despesa 1} /* Busca o label da tabela */
                {method/svc/errors/inserr.i
                                &ErrorNumber="2" /* Natureza Despesa n∆o cadastrada */
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"
                                &ErrorParameters=TRIM(RETURN-VALUE)}
            
            end. 

            find first tipo-rec-desp 
                 where tipo-rec-desp.tp-codigo = RowObject.int-1 no-lock no-error.
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

            FIND FIRST tab-unidade 
                 WHERE tab-unidade.un = RowObject.un NO-LOCK NO-ERROR.
            IF NOT AVAIL tab-unidade THEN DO:
                {method/svc/errors/inserr.i
                                &ErrorNumber="7860" /* Unidade de Medida n∆o cadastrada */
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" }
            END.
            
            &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN
            IF  l-mat-unid-negoc THEN DO:
                FIND FIRST unid-negoc
                     WHERE unid-negoc.cod-unid-negoc = tt-familia-mat.cod-unid-negoc NO-LOCK NO-ERROR.
                IF NOT AVAIL unid-negoc THEN DO:
                    /* Inicio -- Projeto Internacional */
                    {utp/ut-table.i mgind unid-negoc 1} /* Busca o label da tabela */
                    {method/svc/errors/inserr.i
                                    &ErrorNumber="2" /* Unidade de NegÛcio n„o cadastrada */
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters=TRIM(RETURN-VALUE)}
                END.
            END.
            &endif
       end.
       when "cc0102.w":U then do:

            if tt-familia-mat.cod-estab-gestor <> "" then do:
                find first estabelec
                     where estabelec.cod-estabel = tt-familia-mat.cod-estab-gestor no-lock no-error. 
                if  not avail estabelec then do:
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
            and not can-find( first grupo-compra where grupo-compra.cod-grp-compra = tt-familia-mat.cod-grp-compra ) then do:
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
       when "re0105.w":U then do:
           IF i-pais-impto-usuario = 1 THEN DO:
               for first classif-fisc fields ()
                   where classif-fisc.class-fiscal = RowObject.class-fiscal no-lock: end.
               if  not avail classif-fisc then do:
                   if i-pais-impto-usuario = 1 then
                       /* Inicio -- Projeto Internacional */
                       DO:
                       {utp/ut-table.i mgind classif-fisc 1} /* Busca o label da tabela */
                       {method/svc/errors/inserr.i
                                    &ErrorNumber="2" /* Classificaá∆o Fiscal n∆o cadastrada */
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters=TRIM(RETURN-VALUE)}
                       END. 
               END.

               
               IF  tt-familia-mat.cod-familia-impto <> '' AND 
                   NOT CAN-FIND(FIRST familia-impto NO-LOCK
                                WHERE familia-impto.cod-familia-impto = tt-familia-mat.cod-familia-impto) THEN DO:
                   /* Inicio -- Projeto Internacional */
                   {utp/ut-table.i mgind familia-impto 1} /* Busca o label da tabela */
                   {method/svc/errors/inserr.i
                               &ErrorNumber="47"
                               &ErrorType="EMS"
                               &ErrorSubType="ERROR"
                               &ErrorParameters=TRIM(RETURN-VALUE)}
               END.
               
               
               /*C¢digo Tributaá∆o ICMS : 1 - Tributado, 2 - Isento, 3 - Outros, 4 - Reduzido, 5 - Diferido*/
               IF RowObject.cd-trib-icm < 1 OR RowObject.cd-trib-icm  > 5 THEN DO:  
                    {utp/ut-liter.i "C¢digo_Tributaá∆o_ICMS" *}
                    ASSIGN c-texto = RETURN-VALUE.
                    
                    {utp/ut-liter.i "a"o *}
                    ASSIGN c-texto-1 = "1 " + RETURN-VALUE + " 5 ".

                    {method/svc/errors/inserr.i &ErrorNumber="18733"
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="c-texto + '~~~~' + c-texto-1"}
               END.
               /*C¢digo Tributaá∆o IPI : 1 - Tributado, 2 - Isento, 3 - Outros, 4 - Reduzido, 5 - Diferido **/
               IF RowObject.cd-trib-ipi < 1 OR RowObject.cd-trib-ipi > 5 THEN DO:
                    {utp/ut-liter.i "C¢digo_Tributaá∆o_IPI" *}
                    ASSIGN c-texto = RETURN-VALUE.
                    
                    {utp/ut-liter.i "a"o *}
                    ASSIGN c-texto-1 = "1 " + RETURN-VALUE + " 5 ".

                    {method/svc/errors/inserr.i &ErrorNumber="18733"
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="c-texto + '~~~~' + c-texto-1"}
               END.

               /*C¢digo Tributaá∆o IPI : 1 - Tributado, 2 - Isento, 3 - Outros, 4 - Reduzido, 5 - Diferido */
               IF RowObject.cd-trib-iss < 1 OR RowObject.cd-trib-iss > 5 THEN DO:  
                    {utp/ut-liter.i "C¢digo_Tributaá∆o_ISS" *}
                    ASSIGN c-texto = RETURN-VALUE.

                    {utp/ut-liter.i "ao" *}
                    ASSIGN c-texto-1 = "1 " + RETURN-VALUE + " 5 ".

                    {method/svc/errors/inserr.i &ErrorNumber="18733"
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="c-texto + '~~~~' + c-texto-1"}
               END.
           END.
       end.
       when "ce0102.w":U then do:
            IF NOT AVAILABLE tt-familia-mat THEN DO:
                {method/svc/errors/inserr.i
                    &ErrorNumber="58333"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="''"}
                RETURN "NOK":U.
            END.

            IF pType = "CREATE":U OR pType = "UPDATE":U THEN DO:
                /* Zero representa parametro nao informado; desconhecidos sao invalidos. */
                IF tt-familia-mat.log-contr-ag-ia = ? THEN DO:
                    {method/svc/errors/inserr.i
                        &ErrorNumber="58343"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters="''"}
                END.

                IF tt-familia-mat.dias-ocioso = ?
                   OR tt-familia-mat.dias-ocioso < 0 THEN DO:
                    {method/svc/errors/inserr.i
                        &ErrorNumber="58344"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters="''"}
                END.

                IF tt-familia-mat.perc-excesso = ?
                   OR tt-familia-mat.perc-excesso < 0 THEN DO:
                    {method/svc/errors/inserr.i
                        &ErrorNumber="58345"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters="''"}
                END.

                IF tt-familia-mat.log-contr-ag-ia = NO
                   AND tt-familia-mat.dias-ocioso <> ?
                   AND tt-familia-mat.perc-excesso <> ?
                   AND (tt-familia-mat.dias-ocioso > 0
                        OR tt-familia-mat.perc-excesso > 0) THEN DO:
                    {method/svc/errors/inserr.i
                        &ErrorNumber="58346"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters="''"}
                END.
            END.

            if  tt-familia-mat.tp-ressup = 3 
            and not can-find(first frequencia 
                             where frequencia.cd-freq = tt-familia-mat.cd-freq) 
            then do:
                /* Inicio -- Projeto Internacional */
                {utp/ut-table.i mgadm frequencia 1} /* Busca o label da tabela */
                {method/svc/errors/inserr.i
                                &ErrorNumber="2" /*Frequància n∆o cadastrada*/
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"
                                &ErrorParameters=TRIM(RETURN-VALUE)}
            end.
            
            if  tt-familia-mat.cod-fat-ponder <> 0
            and not can-find(first fat-ponder
                             where fat-ponder.cod-fat-ponder = tt-familia-mat.cod-fat-ponder) 
            then do:
                /* Inicio -- Projeto Internacional */
                {utp/ut-table.i mgind fat-ponder 1} /* Busca o label da tabela */
                {method/svc/errors/inserr.i
                                &ErrorNumber="2" /*F¢rmula n∆o cadastrada*/
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"
                                &ErrorParameters=TRIM(RETURN-VALUE)}
           end.
       end.
    end case.
    
    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


