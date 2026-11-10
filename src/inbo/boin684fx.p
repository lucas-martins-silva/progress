&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/*:T--------------------------------------------------------------------------
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

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN684
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName item-uni-estab
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

/* DBO-XML-BEGIN */
/*:T Pre-processadores para ativar XML no DBO */
/*:T Retirar o comentario para ativar 
&GLOBAL-DEFINE XMLProducer YES    /*:T DBO atua como producer de mensagens para o Message Broker */
&GLOBAL-DEFINE XMLTopic           /*:T Topico da Mensagem enviada ao Message Broker, geralmente o nome da tabela */
&GLOBAL-DEFINE XMLTableName       /*:T Nome da tabela que deve ser usado como TAG no XML */ 
&GLOBAL-DEFINE XMLTableNameMult   /*:T Nome da tabela no plural. Usado para multiplos registros */ 
&GLOBAL-DEFINE XMLPublicFields    /*:T Lista dos campos (c1,c2) que podem ser enviados via XML. Ficam fora da listas os campos de especializacao da tabela */ 
&GLOBAL-DEFINE XMLKeyFields       /*:T Lista dos campos chave da tabela (c1,c2) */
&GLOBAL-DEFINE XMLExcludeFields   /*:T Lista de campos a serem excluidos do XML quando PublicFields = "" */

&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (mÇtodo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /*:T Nome da Query que d† acessos a todos os registros, exceto os exclu°dos pela constraint de seguranáa. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /*:T Informar os campos da chave quando o Progress n∆o conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

/*:T--- Include com definiá∆o da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin684fx.i RowObject}

{fch/fchmat/fchmatkeeptrackcycleinventory.i1 ttCycleInventoryParam}
{fch/fchmat/fchmatkeeptrackcycleinventory.i ttCycleInventory}
{fch/fchmat/fchmatkeeptrackmaterialrequisition.i ttTotals} 


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

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
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 19.38
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

    CASE pFieldName:
        WHEN "cd-planejado":U THEN ASSIGN pFieldValue = RowObject.cd-planejado.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-comprado":U THEN ASSIGN pFieldValue = RowObject.cod-comprado.
        WHEN "cod-estab-gestor":U THEN ASSIGN pFieldValue = RowObject.cod-estab-gestor.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-grp-compra":U THEN ASSIGN pFieldValue = RowObject.cod-grp-compra.
        WHEN "cod-item-refugo":U THEN ASSIGN pFieldValue = RowObject.cod-item-refugo.
        WHEN "cod-localiz":U THEN ASSIGN pFieldValue = RowObject.cod-localiz.
        WHEN "cod-unid-negoc":U THEN ASSIGN pFieldValue = RowObject.cod-unid-negoc.
        /*WHEN "cod-cta-unif":U THEN ASSIGN pFieldValue = RowObject.cod-cta-unif.
        WHEN "cod-ccusto-unif":U THEN ASSIGN pFieldValue = RowObject.cod-ccusto-unif.*/
        WHEN "ct-codigo":U THEN ASSIGN pFieldValue = RowObject.ct-codigo.
        WHEN "dep-rej-cq":U THEN ASSIGN pFieldValue = RowObject.dep-rej-cq.
        WHEN "deposito-cq":U THEN ASSIGN pFieldValue = RowObject.deposito-cq.
        WHEN "deposito-pad":U THEN ASSIGN pFieldValue = RowObject.deposito-pad.
        WHEN "Ean-Code":U THEN ASSIGN pFieldValue = RowObject.Ean-Code.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "sc-codigo":U THEN ASSIGN pFieldValue = RowObject.sc-codigo.
        WHEN "dsl-formul-quant-cq":U THEN ASSIGN pFieldValue = RowObject.dsl-formul-quant-cq.
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dat-cust-padr-impltad":U THEN ASSIGN pFieldValue = RowObject.dat-cust-padr-impltad.
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "data-base":U THEN ASSIGN pFieldValue = RowObject.data-base.
        WHEN "data-pr-fisc":U THEN ASSIGN pFieldValue = RowObject.data-pr-fisc.
        WHEN "data-ult-con":U THEN ASSIGN pFieldValue = RowObject.data-ult-con.
        WHEN "data-ult-ent":U THEN ASSIGN pFieldValue = RowObject.data-ult-ent.
        WHEN "data-ult-rep":U THEN ASSIGN pFieldValue = RowObject.data-ult-rep.
        WHEN "data-ult-ressup":U THEN ASSIGN pFieldValue = RowObject.data-ult-ressup.
        WHEN "data-ult-sai":U THEN ASSIGN pFieldValue = RowObject.data-ult-sai.
        WHEN "dt-pr-fisc":U THEN ASSIGN pFieldValue = RowObject.dt-pr-fisc.
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cap-est-fabr":U THEN ASSIGN pFieldValue = RowObject.cap-est-fabr.
        WHEN "consumo-aad":U THEN ASSIGN pFieldValue = RowObject.consumo-aad.
        WHEN "consumo-prev":U THEN ASSIGN pFieldValue = RowObject.consumo-prev.
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "fator-ponder[1]":U THEN ASSIGN pFieldValue = RowObject.fator-ponder[1].
        WHEN "fator-ponder[2]":U THEN ASSIGN pFieldValue = RowObject.fator-ponder[2].
        WHEN "fator-ponder[3]":U THEN ASSIGN pFieldValue = RowObject.fator-ponder[3].
        WHEN "fator-ponder[4]":U THEN ASSIGN pFieldValue = RowObject.fator-ponder[4].
        WHEN "fator-ponder[5]":U THEN ASSIGN pFieldValue = RowObject.fator-ponder[5].
        WHEN "fator-ponder[6]":U THEN ASSIGN pFieldValue = RowObject.fator-ponder[6].
        WHEN "fator-ponder[7]":U THEN ASSIGN pFieldValue = RowObject.fator-ponder[7].
        WHEN "fator-ponder[8]":U THEN ASSIGN pFieldValue = RowObject.fator-ponder[8].
        WHEN "fator-ponder[9]":U THEN ASSIGN pFieldValue = RowObject.fator-ponder[9].
        WHEN "fator-ponder[10]":U THEN ASSIGN pFieldValue = RowObject.fator-ponder[10].
        WHEN "fator-ponder[11]":U THEN ASSIGN pFieldValue = RowObject.fator-ponder[11].
        WHEN "fator-ponder[12]":U THEN ASSIGN pFieldValue = RowObject.fator-ponder[12].
        WHEN "fator-refugo":U THEN ASSIGN pFieldValue = RowObject.fator-refugo.
        WHEN "ind-cons-prv":U THEN ASSIGN pFieldValue = RowObject.ind-cons-prv.
        WHEN "lim-var-qtd":U THEN ASSIGN pFieldValue = RowObject.lim-var-qtd.
        WHEN "lim-var-valor":U THEN ASSIGN pFieldValue = RowObject.lim-var-valor.
        WHEN "lote-economi":U THEN ASSIGN pFieldValue = RowObject.lote-economi.
        WHEN "lote-minimo":U THEN ASSIGN pFieldValue = RowObject.lote-minimo.
        WHEN "lote-multipl":U THEN ASSIGN pFieldValue = RowObject.lote-multipl.
        WHEN "lote-mulven":U THEN ASSIGN pFieldValue = RowObject.lote-mulven.
        WHEN "lote-per-max":U THEN ASSIGN pFieldValue = RowObject.lote-per-max.
        WHEN "ponto-encomenda":U THEN ASSIGN pFieldValue = RowObject.ponto-encomenda.
        WHEN "preco-base":U THEN ASSIGN pFieldValue = RowObject.preco-base.
        WHEN "preco-fiscal":U THEN ASSIGN pFieldValue = RowObject.preco-fiscal.
        WHEN "preco-repos":U THEN ASSIGN pFieldValue = RowObject.preco-repos.
        WHEN "preco-ul-ent":U THEN ASSIGN pFieldValue = RowObject.preco-ul-ent.
        WHEN "pto-repos":U THEN ASSIGN pFieldValue = RowObject.pto-repos.
        WHEN "qt-max-ordem":U THEN ASSIGN pFieldValue = RowObject.qt-max-ordem.
        WHEN "qt-min-res-fabr":U THEN ASSIGN pFieldValue = RowObject.qt-min-res-fabr.
        WHEN "qtd-batch-padrao":U THEN ASSIGN pFieldValue = RowObject.qtd-batch-padrao.
        WHEN "qtd-refer-custo-dis":U THEN ASSIGN pFieldValue = RowObject.qtd-refer-custo-dis.
        WHEN "quant-perda":U THEN ASSIGN pFieldValue = RowObject.quant-perda.
        WHEN "quant-segur":U THEN ASSIGN pFieldValue = RowObject.quant-segur.
        WHEN "val-fator-custo-dis":U THEN ASSIGN pFieldValue = RowObject.val-fator-custo-dis.
        WHEN "val-lim-absor":U THEN ASSIGN pFieldValue = RowObject.val-lim-absor.
        WHEN "val-overlap":U THEN ASSIGN pFieldValue = RowObject.val-overlap.
        WHEN "val-relac-refugo-item":U THEN ASSIGN pFieldValue = RowObject.val-relac-refugo-item.
        WHEN "var-mob-maior":U THEN ASSIGN pFieldValue = RowObject.var-mob-maior.
        WHEN "var-mob-menor":U THEN ASSIGN pFieldValue = RowObject.var-mob-menor.
        WHEN "var-qtd-re":U THEN ASSIGN pFieldValue = RowObject.var-qtd-re.
        WHEN "var-qtd-res-fabr":U THEN ASSIGN pFieldValue = RowObject.var-qtd-res-fabr.
        WHEN "var-rep":U THEN ASSIGN pFieldValue = RowObject.var-rep.
        WHEN "var-transf":U THEN ASSIGN pFieldValue = RowObject.var-transf.
        WHEN "var-val-re-maior":U THEN ASSIGN pFieldValue = RowObject.var-val-re-maior.
        WHEN "var-val-re-menor":U THEN ASSIGN pFieldValue = RowObject.var-val-re-menor.
        WHEN "variac-acum":U THEN ASSIGN pFieldValue = RowObject.variac-acum.
        WHEN "variacao-perm":U THEN ASSIGN pFieldValue = RowObject.variacao-perm.
        WHEN "vl-ggf-ant":U THEN ASSIGN pFieldValue = RowObject.vl-ggf-ant.
        WHEN "vl-mat-ant":U THEN ASSIGN pFieldValue = RowObject.vl-mat-ant.
        WHEN "vl-mob-ant":U THEN ASSIGN pFieldValue = RowObject.vl-mob-ant.
        WHEN "vl-var-max":U THEN ASSIGN pFieldValue = RowObject.vl-var-max.
        WHEN "vl-var-min":U THEN ASSIGN pFieldValue = RowObject.vl-var-min.
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cd-freq":U THEN ASSIGN pFieldValue = RowObject.cd-freq.
        WHEN "ciclo-contag":U THEN ASSIGN pFieldValue = RowObject.ciclo-contag.
        WHEN "classe-repro":U THEN ASSIGN pFieldValue = RowObject.classe-repro.
        WHEN "classif-abc":U THEN ASSIGN pFieldValue = RowObject.classif-abc.
        WHEN "cod-fat-ponder":U THEN ASSIGN pFieldValue = RowObject.cod-fat-ponder.
        WHEN "cod-obsoleto":U THEN ASSIGN pFieldValue = RowObject.cod-obsoleto.
        WHEN "contr-plan":U THEN ASSIGN pFieldValue = RowObject.contr-plan.
        WHEN "crit-cc":U THEN ASSIGN pFieldValue = RowObject.crit-cc.
        WHEN "crit-ce":U THEN ASSIGN pFieldValue = RowObject.crit-ce.
        WHEN "criticidade":U THEN ASSIGN pFieldValue = RowObject.criticidade.
        WHEN "demanda":U THEN ASSIGN pFieldValue = RowObject.demanda.
        WHEN "div-ordem":U THEN ASSIGN pFieldValue = RowObject.div-ordem.
        WHEN "emissao-ord":U THEN ASSIGN pFieldValue = RowObject.emissao-ord.
        WHEN "horiz-fixo":U THEN ASSIGN pFieldValue = RowObject.horiz-fixo.
        WHEN "ind-calc-meta":U THEN ASSIGN pFieldValue = RowObject.ind-calc-meta.
        WHEN "ind-lista-csp":U THEN ASSIGN pFieldValue = RowObject.ind-lista-csp.
        WHEN "ind-lista-mrp":U THEN ASSIGN pFieldValue = RowObject.ind-lista-mrp.
        WHEN "ind-prev-demanda":U THEN ASSIGN pFieldValue = RowObject.ind-prev-demanda.
        WHEN "ind-refugo":U THEN ASSIGN pFieldValue = RowObject.ind-refugo.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "metodo-custeio":U THEN ASSIGN pFieldValue = RowObject.metodo-custeio.
        WHEN "nat-despesa":U THEN ASSIGN pFieldValue = RowObject.nat-despesa.
        WHEN "nr-linha":U THEN ASSIGN pFieldValue = RowObject.nr-linha.
        WHEN "periodo-fixo":U THEN ASSIGN pFieldValue = RowObject.periodo-fixo.
        WHEN "perm-saldo-neg":U THEN ASSIGN pFieldValue = RowObject.perm-saldo-neg.
        WHEN "politica":U THEN ASSIGN pFieldValue = RowObject.politica.
        WHEN "prior-mrp":U THEN ASSIGN pFieldValue = RowObject.prior-mrp.
        WHEN "prioridade":U THEN ASSIGN pFieldValue = RowObject.prioridade.
        WHEN "prioridade-aprov":U THEN ASSIGN pFieldValue = RowObject.prioridade-aprov.
        WHEN "rep-prod":U THEN ASSIGN pFieldValue = RowObject.rep-prod.
        WHEN "reporte-ggf":U THEN ASSIGN pFieldValue = RowObject.reporte-ggf.
        WHEN "reporte-mob":U THEN ASSIGN pFieldValue = RowObject.reporte-mob.
        WHEN "res-cq-comp":U THEN ASSIGN pFieldValue = RowObject.res-cq-comp.
        WHEN "res-cq-fabri":U THEN ASSIGN pFieldValue = RowObject.res-cq-fabri.
        WHEN "res-for-comp":U THEN ASSIGN pFieldValue = RowObject.res-for-comp.
        WHEN "res-int-comp":U THEN ASSIGN pFieldValue = RowObject.res-int-comp.
        WHEN "res-min-fabri":U THEN ASSIGN pFieldValue = RowObject.res-min-fabri.
        WHEN "ressup-fabri":U THEN ASSIGN pFieldValue = RowObject.ressup-fabri.
        WHEN "sit-aloc":U THEN ASSIGN pFieldValue = RowObject.sit-aloc.
        WHEN "tempo-segur":U THEN ASSIGN pFieldValue = RowObject.tempo-segur.
        WHEN "tipo-est-seg":U THEN ASSIGN pFieldValue = RowObject.tipo-est-seg.
        WHEN "tipo-lote-ec":U THEN ASSIGN pFieldValue = RowObject.tipo-lote-ec.
        WHEN "tipo-requis":U THEN ASSIGN pFieldValue = RowObject.tipo-requis.
        WHEN "tipo-sched":U THEN ASSIGN pFieldValue = RowObject.tipo-sched.
        WHEN "tp-aloc-lote":U THEN ASSIGN pFieldValue = RowObject.tp-aloc-lote.
        WHEN "tp-codigo":U THEN ASSIGN pFieldValue = RowObject.tp-codigo.
        WHEN "tp-desp-padrao":U THEN ASSIGN pFieldValue = RowObject.tp-desp-padrao.
        WHEN "tp-ressup":U THEN ASSIGN pFieldValue = RowObject.tp-ressup.
        WHEN "var-tempo-res-fabr":U THEN ASSIGN pFieldValue = RowObject.var-tempo-res-fabr.
        OTHERWISE RETURN "NOK":U.
    END CASE.

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

    CASE pFieldName:
        WHEN "altera-conta":U THEN ASSIGN pFieldValue = RowObject.altera-conta.
        WHEN "contr-qualid":U THEN ASSIGN pFieldValue = RowObject.contr-qualid.
        WHEN "conv-tempo-seg":U THEN ASSIGN pFieldValue = RowObject.conv-tempo-seg.
        WHEN "curva-abc":U THEN ASSIGN pFieldValue = RowObject.curva-abc.
        WHEN "ind-item-fat":U THEN ASSIGN pFieldValue = RowObject.ind-item-fat.
        WHEN "loc-unica":U THEN ASSIGN pFieldValue = RowObject.loc-unica.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "log-ad-consumo":U THEN ASSIGN pFieldValue = RowObject.log-ad-consumo.
        WHEN "log-aloc-neg":U THEN ASSIGN pFieldValue = RowObject.log-aloc-neg.
        WHEN "log-consid-aloc-ativid":U THEN ASSIGN pFieldValue = RowObject.log-consid-aloc-ativid.
        WHEN "log-control-estoq-refugo":U THEN ASSIGN pFieldValue = RowObject.log-control-estoq-refugo.
        WHEN "log-cust-padr-impltad":U THEN ASSIGN pFieldValue = RowObject.log-cust-padr-impltad.
        WHEN "log-finaliz-op":U THEN ASSIGN pFieldValue = RowObject.log-finaliz-op.
        WHEN "log-multi-malha":U THEN ASSIGN pFieldValue = RowObject.log-multi-malha.
        WHEN "log-programac-sfc":U THEN ASSIGN pFieldValue = RowObject.log-programac-sfc.
        WHEN "log-refugo-preco-fisc":U THEN ASSIGN pFieldValue = RowObject.log-refugo-preco-fisc.
        WHEN "log-rotei-pend":U THEN ASSIGN pFieldValue = RowObject.log-rotei-pend.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE keepTrackCycleInventory DBOProgram 
PROCEDURE keepTrackCycleInventory :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT  PARAM TABLE FOR ttCycleInventoryParam.
DEF OUTPUT PARAM TABLE FOR ttTotals.
DEF OUTPUT PARAM TABLE FOR RowErrors.

DEF VAR dt-prox-contagem    AS DATE     NO-UNDO.
DEF VAR de-saldo            AS DECIMAL  NO-UNDO.

    {utp/ut-liter.i Vencido}
    create ttTotals.
    assign ttTotals.situationId = 1
           ttTotals.situation   = return-value.
           ttTotals.quantity    = 0.
    
    {utp/ut-liter.i A_Vencer}
    create ttTotals.
    assign ttTotals.situationId = 2
           ttTotals.situation   = return-value.
           ttTotals.quantity    = 0.
           
    FIND FIRST ttCycleInventoryParam NO-ERROR.
        IF NOT AVAIL ttCycleInventoryParam THEN
            RETURN "NOK":U.

    bloco:
    FOR EACH item-uni-estab
        WHERE item-uni-estab.it-codigo >= ttCycleInventoryParam.initialItem
          AND item-uni-estab.it-codigo <= ttCycleInventoryParam.finalItem
          AND item-uni-estab.cod-estabel  >= ttCycleInventoryParam.initialSite
          AND item-uni-estab.cod-estabel  <= ttCycleInventoryParam.finalSite
          AND item-uni-estab.ciclo-contag > 0,
          EACH ITEM FIELDS (it-codigo fm-codigo desc-item un tipo-contr)
              WHERE item.it-codigo  = item-uni-estab.it-codigo
                AND item.fm-codigo >= ttCycleInventoryParam.initialFamily
                AND item.fm-codigo <= ttCycleInventoryParam.finalFamily NO-LOCK:
        
    
        IF NOT ttCycleInventoryParam.noBalance THEN DO:
            IF NOT CAN-FIND(FIRST saldo-estoq 
                        WHERE saldo-estoq.it-codigo   = item-uni-estab.it-codigo
                          AND saldo-estoq.cod-estabel = item-uni-estab.cod-estabel
                          /*AND saldo-estoq.qtidade-atu = ?*/ ) THEN DO:
                NEXT.
            END.
        END.
    
        IF item.tipo-contr = 3 and ttCycleInventoryParam.consignated = NO THEN
            NEXT.
        
        IF ttCycleInventoryParam.situation <> item-uni-estab.cod-obsoleto AND
           ttCycleInventoryParam.situation <> 5 THEN
            NEXT.
    
        IF NOT ttCycleInventoryParam.zeroedBalance THEN DO:
            
            FOR EACH saldo-estoq 
                WHERE saldo-estoq.it-codigo   = item-uni-estab.it-codigo
                  AND saldo-estoq.cod-estabel = item-uni-estab.cod-estabel
                NO-LOCK :
                assign de-saldo = saldo-estoq.qtidade-atu.
                FOR EACH movto-estoq 
                    WHERE movto-estoq.it-codigo   = saldo-estoq.it-codigo   
                      AND movto-estoq.cod-estabel = saldo-estoq.cod-estabel 
                      AND movto-estoq.cod-depos   = saldo-estoq.cod-depos   
                      AND movto-estoq.cod-localiz = saldo-estoq.cod-localiz 
                      AND movto-estoq.lote        = saldo-estoq.lote        
                      AND movto-estoq.cod-refer   = saldo-estoq.cod-refer 
                      and movto-estoq.dt-trans    = today
                    NO-LOCK:
    
                    IF movto-estoq.tipo-trans = 1 THEN 
                        ASSIGN de-saldo = de-saldo - movto-estoq.quantidade.
                    ELSE 
                        ASSIGN de-saldo = de-saldo + movto-estoq.quantidade.
                END.
                IF (de-saldo = 0) THEN NEXT bloco.
            END.
           
        END.

      ASSIGN dt-prox-contagem = item-uni-estab.data-ult-con + item-uni-estab.ciclo-contag.

      IF  dt-prox-contagem >= TODAY - ttCycleInventoryParam.daysOfCycleExpired
          AND dt-prox-contagem <= TODAY THEN DO:
          for FIRST ttTotals WHERE ttTotals.situationId = 1 exclusive-lock:
              ASSIGN ttTotals.quantity = ttTotals.quantity + 1.
          end.
      END.
    
      IF dt-prox-contagem > TODAY
          AND dt-prox-contagem <= TODAY + ttCycleInventoryParam.daysToCycleExpiration THEN DO:
          for FIRST ttTotals WHERE ttTotals.situationId = 2 exclusive-lock:
              ASSIGN ttTotals.quantity = ttTotals.quantity + 1.
          end.
      END.
END.           

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCycleInventory DBOProgram 
PROCEDURE getCycleInventory :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT  PARAM lCycletoExpire           AS LOGICAL.
DEF INPUT  PARAM lExpiredCycle            AS LOGICAL.
DEF INPUT  PARAM TABLE FOR ttCycleInventoryParam.
DEF OUTPUT PARAM TABLE FOR ttCycleInventory.
DEF OUTPUT PARAM TABLE FOR RowErrors.
DEF VAR dt-prox-contagem                  AS DATE       NO-UNDO.
DEF VAR de-saldo                          AS DECIMAL    NO-UNDO.
 

    FIND FIRST ttCycleInventoryParam NO-ERROR.
        IF NOT AVAIL ttCycleInventoryParam THEN
            RETURN "NOK":U.
    bloco:
    FOR EACH item-uni-estab
        WHERE item-uni-estab.it-codigo >= ttCycleInventoryParam.initialItem
          AND item-uni-estab.it-codigo <= ttCycleInventoryParam.finalItem
          AND item-uni-estab.cod-estabel  >= ttCycleInventoryParam.initialSite
          AND item-uni-estab.cod-estabel  <= ttCycleInventoryParam.finalSite
          AND item-uni-estab.ciclo-contag > 0,
          EACH ITEM FIELDS (it-codigo fm-codigo desc-item un tipo-contr)
              WHERE item.it-codigo  = item-uni-estab.it-codigo
                AND item.fm-codigo >= ttCycleInventoryParam.initialFamily
                AND item.fm-codigo <= ttCycleInventoryParam.finalFamily NO-LOCK:
        
    
        IF NOT ttCycleInventoryParam.noBalance THEN DO:
            IF NOT CAN-FIND(FIRST saldo-estoq 
                        WHERE saldo-estoq.it-codigo   = item-uni-estab.it-codigo
                          AND saldo-estoq.cod-estabel = item-uni-estab.cod-estabel
                          /*AND saldo-estoq.qtidade-atu = ?*/ ) THEN DO:
                NEXT.
            END.
        END.
    
        IF item.tipo-contr = 3 and ttCycleInventoryParam.consignated = NO THEN
            NEXT.


        IF ttCycleInventoryParam.situation <> item-uni-estab.cod-obsoleto AND
           ttCycleInventoryParam.situation <> 5 then
            NEXT.
    
        IF NOT ttCycleInventoryParam.zeroedBalance THEN DO:
            
            FOR EACH saldo-estoq 
                WHERE saldo-estoq.it-codigo   = item-uni-estab.it-codigo
                  AND saldo-estoq.cod-estabel = item-uni-estab.cod-estabel
                NO-LOCK :
                assign de-saldo = saldo-estoq.qtidade-atu.
                FOR EACH movto-estoq 
                    WHERE movto-estoq.it-codigo   = saldo-estoq.it-codigo   
                      AND movto-estoq.cod-estabel = saldo-estoq.cod-estabel 
                      AND movto-estoq.cod-depos   = saldo-estoq.cod-depos   
                      AND movto-estoq.cod-localiz = saldo-estoq.cod-localiz 
                      AND movto-estoq.lote        = saldo-estoq.lote        
                      AND movto-estoq.cod-refer   = saldo-estoq.cod-refer 
                      and movto-estoq.dt-trans    = today
                    NO-LOCK:
    
                    IF movto-estoq.tipo-trans = 1 THEN 
                        ASSIGN de-saldo = de-saldo - movto-estoq.quantidade.
                    ELSE 
                        ASSIGN de-saldo = de-saldo + movto-estoq.quantidade.
                END.
                IF (de-saldo = 0) THEN NEXT bloco.
            END.
           
        END.

        ASSIGN dt-prox-contagem = item-uni-estab.data-ult-con + item-uni-estab.ciclo-contag.

        IF lExpiredCycle = YES AND lCycletoExpire = NO AND dt-prox-contagem > TODAY THEN
            NEXT.
        IF lExpiredCycle = NO AND lCycletoExpire = YES AND dt-prox-contagem <= TODAY THEN
            NEXT.
            
        IF  Dt-prox-contagem >= TODAY - ttCycleInventoryParam.daysOfCycleExpired
            AND Dt-prox-contagem <= TODAY THEN DO:
            CREATE ttCycleInventory.
            ASSIGN ttCycleInventory.item            = item-uni-estab.it-codigo
                ttCycleInventory.description        = item.desc-item
                ttCycleInventory.unitOfMeasure      = item.un
                ttCycleInventory.site               = item-uni-estab.cod-estabel
                ttCycleInventory.lastCountingDate   = item-uni-estab.data-ult-con
                ttCycleInventory.family             = item.fm-codigo
                ttCycleInventory.nextCountingDate   = Dt-prox-contagem
                ttCycleInventory.situation          = "Vencido"
                ttCycleInventory.situationCode      = 1.
        END.
            
        IF Dt-prox-contagem > TODAY
            AND Dt-prox-contagem <= TODAY + ttCycleInventoryParam.daysToCycleExpiration THEN DO:
            CREATE ttCycleInventory.
            ASSIGN ttCycleInventory.item            = item-uni-estab.it-codigo
                ttCycleInventory.description        = item.desc-item
                ttCycleInventory.unitOfMeasure      = item.un
                ttCycleInventory.site               = item-uni-estab.cod-estabel
                ttCycleInventory.lastCountingDate   = item-uni-estab.data-ult-con
                ttCycleInventory.family             = item.fm-codigo
                ttCycleInventory.nextCountingDate   = Dt-prox-contagem
                ttCycleInventory.situation             = "A Vencer"
                ttCycleInventory.situationCode         = 2.
        END.
    END.
        
    RETURN "OK":U.
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryMain DBOProgram 
PROCEDURE OpenQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   
   open query {&queryname} 
   for each {&tablename} no-lock indexed-reposition.
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getFormulQuantCQ DBOProgram 
PROCEDURE getFormulQuantCQ :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-it-codigo           LIKE {&TableName}.it-codigo           NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-estabel         LIKE {&TableName}.cod-estabel         NO-UNDO.
    DEFINE OUTPUT PARAMETER p-dsl-formul-quant-cq LIKE {&TableName}.dsl-formul-quant-cq NO-UNDO.
    
    FOR FIRST {&TableName} FIELDS (dsl-formul-quant-cq) NO-LOCK
        WHERE {&TableName}.it-codigo   = p-it-codigo
          AND {&TableName}.cod-estabel = p-cod-estabel:
    
        ASSIGN p-dsl-formul-quant-cq = {&TableName}.dsl-formul-quant-cq.

    END.
   
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getHabRotPend DBOProgram 
PROCEDURE getHabRotPend :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-it-codigo      LIKE {&TableName}.it-codigo      NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-estabel    LIKE {&TableName}.cod-estabel    NO-UNDO.
    DEFINE OUTPUT PARAMETER p-log-rotei-pend LIKE {&TableName}.log-rotei-pend NO-UNDO.
    
    FOR FIRST {&TableName} FIELDS (log-rotei-pend) NO-LOCK
        WHERE {&TableName}.it-codigo   = p-it-codigo
          AND {&TableName}.cod-estabel = p-cod-estabel:
    
        ASSIGN p-log-rotei-pend = {&TableName}.log-rotei-pend.

    END.
   
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
