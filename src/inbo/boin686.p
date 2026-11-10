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
{include/i-prgvrs.i BOIN686 2.00.00.010 } /*** "010010" 12/09/2026 21:26:01 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin686 MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : 
    Purpose    : O DBO (Datasul Business Objects) Ç um programa PROGRESS
                 que contÇm a l¢gica de neg¢cio e acesso a dados para uma
                 tabela do banco de dados.

    Parameters :

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName fam-uni-estab
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName fam-uni-estab
&GLOBAL-DEFINE TableLabel fam-uni-estab
&GLOBAL-DEFINE QueryName qr{&TableName}
&GLOBAL-DEFINE CHANGE-QUERY-TO-FIND TRUE
&GLOBAL-DEFINE CHANGE-QUERY-TO-FIND-PROCS Main, RangeFmEstab, FmCodigo

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

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/****** Vari†veis utilizadas pelas setconstraintÔs *****/

define variable c-fm-codigo as character format "x(8)" no-undo.

def var c-fm-codigo-ini like fam-uni-estab.fm-codigo no-undo.
def var c-fm-codigo-fim like fam-uni-estab.fm-codigo no-undo.
def var c-cod-estab-ini like fam-uni-estab.cod-estabel no-undo.
def var c-cod-estab-fim like fam-uni-estab.cod-estabel no-undo.

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
         WIDTH              = 40.14.
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
        WHEN "cod-localiz":U THEN ASSIGN pFieldValue = RowObject.cod-localiz.
        WHEN "dep-rej-cq":U THEN ASSIGN pFieldValue = RowObject.dep-rej-cq.
        WHEN "deposito-cq":U THEN ASSIGN pFieldValue = RowObject.deposito-cq.
        WHEN "deposito-pad":U THEN ASSIGN pFieldValue = RowObject.deposito-pad.
        WHEN "fm-codigo":U THEN ASSIGN pFieldValue = RowObject.fm-codigo.
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "data-base":U THEN ASSIGN pFieldValue = RowObject.data-base.
        WHEN "data-pr-fisc":U THEN ASSIGN pFieldValue = RowObject.data-pr-fisc.
        WHEN "data-ult-con":U THEN ASSIGN pFieldValue = RowObject.data-ult-con.
        WHEN "data-ult-ent":U THEN ASSIGN pFieldValue = RowObject.data-ult-ent.
        WHEN "data-ult-rep":U THEN ASSIGN pFieldValue = RowObject.data-ult-rep.
        WHEN "data-ult-ressup":U THEN ASSIGN pFieldValue = RowObject.data-ult-ressup.
        WHEN "data-ult-sai":U THEN ASSIGN pFieldValue = RowObject.data-ult-sai.
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "lote-economi":U THEN ASSIGN pFieldValue = RowObject.lote-economi.
        WHEN "lote-minimo":U THEN ASSIGN pFieldValue = RowObject.lote-minimo.
        WHEN "lote-multipl":U THEN ASSIGN pFieldValue = RowObject.lote-multipl.
        WHEN "lote-per-max":U THEN ASSIGN pFieldValue = RowObject.lote-per-max.
        WHEN "ponto-encomenda":U THEN ASSIGN pFieldValue = RowObject.ponto-encomenda.
        WHEN "preco-base":U THEN ASSIGN pFieldValue = RowObject.preco-base.
        WHEN "preco-fiscal":U THEN ASSIGN pFieldValue = RowObject.preco-fiscal.
        WHEN "preco-repos":U THEN ASSIGN pFieldValue = RowObject.preco-repos.
        WHEN "preco-ul-ent":U THEN ASSIGN pFieldValue = RowObject.preco-ul-ent.
        WHEN "qt-max-ordem":U THEN ASSIGN pFieldValue = RowObject.qt-max-ordem.
        WHEN "qt-min-res-fabr":U THEN ASSIGN pFieldValue = RowObject.qt-min-res-fabr.
        WHEN "qtd-batch-padrao":U THEN ASSIGN pFieldValue = RowObject.qtd-batch-padrao.
        WHEN "qtd-refer-custo-dis":U THEN ASSIGN pFieldValue = RowObject.qtd-refer-custo-dis.
        WHEN "quant-perda":U THEN ASSIGN pFieldValue = RowObject.quant-perda.
        WHEN "val-fator-custo-dis":U THEN ASSIGN pFieldValue = RowObject.val-fator-custo-dis.
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
        WHEN "cap-est-fabr":U THEN ASSIGN pFieldValue = RowObject.cap-est-fabr.
        WHEN "consumo-aad":U THEN ASSIGN pFieldValue = RowObject.consumo-aad.
        WHEN "consumo-prev":U THEN ASSIGN pFieldValue = RowObject.consumo-prev.
        WHEN "quant-segur":U THEN ASSIGN pFieldValue = RowObject.quant-segur.
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
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescComprador DBOProgram 
PROCEDURE getDescComprador :
/*------------------------------------------------------------------------------
  Parameters: pc-cod-comprador  - recebe o c¢digo do Comprador
              pc-desc-comprador - retorna a descriá∆o
  Notes:       
------------------------------------------------------------------------------*/
    def input  param pc-cod-comprador   like fam-uni-estab.cod-comprado no-undo.
    def output param pc-desc-comprador  like comprador.nome             no-undo.

    for first comprador fields (nome)
        where comprador.cod-comprado = pc-cod-comprador no-lock: end.
    
    if avail comprador then
       assign pc-desc-comprador = comprador.nome.    
    else do:
         assign pc-desc-comprador = "".
         return "NOK":U.
    end.

    return "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescDeposito DBOProgram 
PROCEDURE getDescDeposito :
/*------------------------------------------------------------------------------
  Parameters: pc-cod-depos  - recebe o c¢digo do Dep¢sito
              pc-desc-depos - retorna a descriá∆o
  Notes:       
------------------------------------------------------------------------------*/
    def input  param pc-cod-depos  like fam-uni-estab.deposito-pad no-undo.
    def output param pc-desc-depos like deposito.nome              no-undo.

    for first deposito fields (nome)
        where deposito.cod-depos = pc-cod-depos no-lock: end.
    
    if avail deposito then
       assign pc-desc-depos = deposito.nome.    
    else do:
         assign pc-desc-depos = "".
         return "NOK":U.
    end.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescEstabelec DBOProgram 
PROCEDURE getDescEstabelec :
/*------------------------------------------------------------------------------
  Parameters: pc-cod-estabel  - recebe o c¢digo do Estabelecimento
              pc-desc-estabel - retorna a descriá∆o
  Notes:       
------------------------------------------------------------------------------*/
    def input  param pc-cod-estabel  like fam-uni-estab.cod-estabel no-undo.
    def output param pc-desc-estabel like estabelec.nome            no-undo.

    for first estabelec fields (nome)
        where estabelec.cod-estabel = pc-cod-estabel no-lock: end.
    
    if avail estabelec then
       assign pc-desc-estabel = estabelec.nome.    
    else do:
         assign pc-desc-estabel = "".
         return "NOK":U.
    end.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescFamilia DBOProgram 
PROCEDURE getDescFamilia :
/*------------------------------------------------------------------------------
  Parameters: pc-fm-codigo - recebe o c¢digo da fam°lia
              pc-desc-fam  - retorna a descriá∆o
  Notes:       
------------------------------------------------------------------------------*/
    def input  param pc-fm-codigo like fam-uni-estab.fm-codigo no-undo.
    def output param pc-desc-fam  like familia.descricao       no-undo.

    for first familia fields (descricao)
        where familia.fm-codigo = pc-fm-codigo no-lock: end.
    
    if avail familia then
       assign pc-desc-fam = familia.descricao.    
    else do:
         assign pc-desc-fam = "".
         return "NOK":U.
    end.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescFormula DBOProgram 
PROCEDURE getDescFormula :
/*------------------------------------------------------------------------------
  Parameters: pc-cod-fat-ponder  - recebe o c¢digo do Fator de Ponderaá∆o
              pc-desc-fat-ponder - retorna a descriá∆o
  Notes:       
------------------------------------------------------------------------------*/
    def input  param pc-cod-fat-ponder   like fat-ponder.cod-fat-ponder no-undo.
    def output param pc-desc-fat-ponder  like fat-ponder.descricao      no-undo.

    for first fat-ponder fields (descricao)
        where fat-ponder.cod-fat-ponder = pc-cod-fat-ponder no-lock: end.
    
    if avail fat-ponder then
       assign pc-desc-fat-ponder = fat-ponder.descricao.    
    else do:
         assign pc-desc-fat-ponder = "".
         return "NOK":U.
    end.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescFrequencia DBOProgram 
PROCEDURE getDescFrequencia :
/*------------------------------------------------------------------------------
  Parameters: pc-cod-frequencia  - recebe o c¢digo da Frequencia
              pc-desc-frequencia - retorna a descriá∆o
  Notes:       
------------------------------------------------------------------------------*/
    def input  param pc-cod-frequencia   like frequencia.cd-freq   no-undo.
    def output param pc-desc-frequencia  like frequencia.descricao no-undo.

    for first frequencia fields (descricao)
        where frequencia.cd-freq = pc-cod-frequencia no-lock: end.
    
    if avail frequencia then
       assign pc-desc-frequencia = frequencia.descricao.    
    else do:
         assign pc-desc-frequencia = "".
         return "NOK":U.
    end.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescGrpCompra DBOProgram 
PROCEDURE getDescGrpCompra :
/*------------------------------------------------------------------------------
  Parameters: pc-cod-grp-compra  - recebe o c¢digo do Grupo de Compra
              pc-desc-grp-compra - retorna a descriá∆o
  Notes:       
------------------------------------------------------------------------------*/
    def input  param pc-cod-grp-compra   like fam-uni-estab.cod-grp-compra no-undo.
    def output param pc-desc-grp-compra  like grupo-compra.des-grp-compra  no-undo.

    for first grupo-compra fields (des-grp-compra)
        where grupo-compra.cod-grp-compra = pc-cod-grp-compra no-lock: end.
    
    if avail grupo-compra then
       assign pc-desc-grp-compra = grupo-compra.des-grp-compra.    
    else do:
         assign pc-desc-grp-compra = "".
         return "NOK":U.
    end.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescLocaliz DBOProgram 
PROCEDURE getDescLocaliz :
/*------------------------------------------------------------------------------
  Parameters: pc-cod-estabel  - recebe o c¢digo do Estabelecimento
              pc-cod-depos    - recebe o c¢digo do Dep¢sito
              pc-cod-localiz  - recebe o c¢digo da Localizaá∆o
              pc-desc-localiz - retorna a descriá∆o
  Notes:       
------------------------------------------------------------------------------*/
    def input  param pc-cod-estabel  like fam-uni-estab.cod-estabel  no-undo.
    def input  param pc-cod-depos    like fam-uni-estab.deposito-pad no-undo.
    def input  param pc-cod-localiz  like fam-uni-estab.cod-localiz  no-undo.        
    def output param pc-desc-localiz like localizacao.descricao      no-undo.

    for first localizacao fields (descricao)
        where localizacao.cod-estabel = pc-cod-estabel 
          and localizacao.cod-depos   = pc-cod-depos
          and localizacao.cod-localiz = pc-cod-localiz no-lock: end.
    
    if avail localizacao then
       assign pc-desc-localiz = localizacao.descricao.    
    else do:
         assign pc-desc-localiz = "".
         return "NOK":U.
    end.

    return "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescNatDespesa DBOProgram 
PROCEDURE getDescNatDespesa :
/*------------------------------------------------------------------------------
  Parameters: pc-nat-despesa      - recebe o c¢digo da Natureza
              pc-desc-nat-despesa - retorna a descriá∆o
  Notes:       
------------------------------------------------------------------------------*/
    def input  param pc-nat-despesa       like fam-uni-estab.nat-despesa  no-undo.
    def output param pc-desc-nat-despesa  like natureza-despesa.descricao no-undo.

    for first natureza-despesa fields (descricao)
        where natureza-despesa.nat-despesa = pc-nat-despesa no-lock: end.
    
    if avail natureza-despesa then
       assign pc-desc-nat-despesa = natureza-despesa.descricao.    
    else do:
         assign pc-desc-nat-despesa = "".
         return "NOK":U.
    end.

    return "OK":U.

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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "nat-despesa":U THEN ASSIGN pFieldValue = RowObject.nat-despesa.
        WHEN "nr-linha":U THEN ASSIGN pFieldValue = RowObject.nr-linha.
        WHEN "periodo-fixo":U THEN ASSIGN pFieldValue = RowObject.periodo-fixo.
        WHEN "perm-saldo-neg":U THEN ASSIGN pFieldValue = RowObject.perm-saldo-neg.
        WHEN "politica":U THEN ASSIGN pFieldValue = RowObject.politica.
        WHEN "prioridade":U THEN ASSIGN pFieldValue = RowObject.prioridade.
        WHEN "prioridade-aprov":U THEN ASSIGN pFieldValue = RowObject.prioridade-aprov.
        WHEN "var-tempo-res-fabr":U THEN ASSIGN pFieldValue = RowObject.var-tempo-res-fabr.
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
        WHEN "tp-ressup":U THEN ASSIGN pFieldValue = RowObject.tp-ressup.
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
        WHEN "dias-ocioso":U THEN ASSIGN pFieldValue = RowObject.dias-ocioso.
        WHEN "perc-excesso":U THEN ASSIGN pFieldValue = RowObject.perc-excesso.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice CODIGO
  Parameters:
               retorna valor dos campos do °ndice CODIGO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pfm-codigo LIKE fam-uni-estab.fm-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE fam-uni-estab.cod-estabel NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pfm-codigo = RowObject.fm-codigo.
    ASSIGN pcod-estabel = RowObject.cod-estabel.

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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "log-ad-consumo":U THEN ASSIGN pFieldValue = RowObject.log-ad-consumo.
        WHEN "log-finaliz-op":U THEN ASSIGN pFieldValue = RowObject.log-finaliz-op.
        WHEN "altera-conta":U THEN ASSIGN pFieldValue = RowObject.altera-conta.
        WHEN "contr-qualid":U THEN ASSIGN pFieldValue = RowObject.contr-qualid.
        WHEN "conv-tempo-seg":U THEN ASSIGN pFieldValue = RowObject.conv-tempo-seg.
        WHEN "curva-abc":U THEN ASSIGN pFieldValue = RowObject.curva-abc.
        WHEN "loc-unica":U THEN ASSIGN pFieldValue = RowObject.loc-unica.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-contr-ag-ia":U THEN ASSIGN pFieldValue = RowObject.log-contr-ag-ia.
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
  Purpose:     Reposiciona registro com base no °ndice CODIGO
  Parameters:
               recebe valor dos campos do °ndice CODIGO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pfm-codigo LIKE fam-uni-estab.fm-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE fam-uni-estab.cod-estabel NO-UNDO.

    FIND FIRST bffam-uni-estab WHERE
        bffam-uni-estab.fm-codigo = pfm-codigo AND
        bffam-uni-estab.cod-estabel = pcod-estabel
        NO-LOCK NO-ERROR.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFmCodigo DBOProgram 
PROCEDURE openQueryFmCodigo :
/*------------------------------------------------------------------------------
  Purpose:     Abre a query de acordo com a Fam°lia recebida na setConstraintFmCodigo
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH fam-uni-estab where
                                     fam-uni-estab.fm-codigo = c-fm-codigo NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FindFirstFmCodigo DBOProgram 
PROCEDURE FindFirstFmCodigo :
/*------------------------------------------------------------------------------
  Purpose:     Abre a query de acordo com a Fam°lia recebida na setConstraintFmCodigo
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    FIND FIRST  fam-uni-estab where
                fam-uni-estab.fm-codigo = c-fm-codigo NO-LOCK NO-ERROR.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FindPrevFmCodigo DBOProgram 
PROCEDURE FindPrevFmCodigo :
/*------------------------------------------------------------------------------
  Purpose:     Abre a query de acordo com a Fam°lia recebida na setConstraintFmCodigo
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    FIND PREV fam-uni-estab where
              fam-uni-estab.fm-codigo = c-fm-codigo NO-LOCK NO-ERROR.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FindNextFmCodigo DBOProgram 
PROCEDURE FindNextFmCodigo :
/*------------------------------------------------------------------------------
  Purpose:     Abre a query de acordo com a Fam°lia recebida na setConstraintFmCodigo
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    FIND NEXT fam-uni-estab where
              fam-uni-estab.fm-codigo = c-fm-codigo NO-LOCK NO-ERROR.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FindLastFmCodigo DBOProgram 
PROCEDURE FindLastFmCodigo :
/*------------------------------------------------------------------------------
  Purpose:     Abre a query de acordo com a Fam°lia recebida na setConstraintFmCodigo
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    FIND LAST fam-uni-estab where
              fam-uni-estab.fm-codigo = c-fm-codigo NO-LOCK NO-ERROR.

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
    OPEN QUERY {&QueryName} FOR EACH fam-uni-estab NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FindFirstMain DBOProgram 
PROCEDURE FindFirstMain :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    FIND FIRST fam-uni-estab NO-LOCK NO-ERROR.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FindPrevMain DBOProgram 
PROCEDURE FindPrevMain :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    FIND PREV fam-uni-estab NO-LOCK NO-ERROR.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FindNextMain DBOProgram 
PROCEDURE FindNextMain :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    FIND NEXT fam-uni-estab NO-LOCK NO-ERROR.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FindLastMain DBOProgram 
PROCEDURE FindLastMain :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    FIND LAST fam-uni-estab NO-LOCK NO-ERROR.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryRangeFmEstab DBOProgram 
PROCEDURE openQueryRangeFmEstab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/ 
    
    open query {&queryName} for each {&tableName}
         where {&tableName}.fm-codigo >= c-fm-codigo-ini
           and {&tableName}.fm-codigo <= c-fm-codigo-fim
           and {&tableName}.cod-estabel >= c-cod-estab-ini
           and {&tableName}.cod-estabel <= c-cod-estab-fim
           no-lock indexed-reposition.
    
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FindFirstRangeFmEstab DBOProgram 
PROCEDURE FindFirstRangeFmEstab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/ 
    
    FIND FIRST {&tableName}
         where {&tableName}.fm-codigo >= c-fm-codigo-ini
           and {&tableName}.fm-codigo <= c-fm-codigo-fim
           and {&tableName}.cod-estabel >= c-cod-estab-ini
           and {&tableName}.cod-estabel <= c-cod-estab-fim
           no-lock NO-ERROR.
    
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FindPrevRangeFmEstab DBOProgram 
PROCEDURE FindPrevRangeFmEstab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/ 
    
     FIND PREV {&tableName}
         where {&tableName}.fm-codigo >= c-fm-codigo-ini
           and {&tableName}.fm-codigo <= c-fm-codigo-fim
           and {&tableName}.cod-estabel >= c-cod-estab-ini
           and {&tableName}.cod-estabel <= c-cod-estab-fim
           no-lock NO-ERROR.
    
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FindNextRangeFmEstab DBOProgram 
PROCEDURE FindNextRangeFmEstab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/ 
    
     FIND NEXT {&tableName}
         where {&tableName}.fm-codigo >= c-fm-codigo-ini
           and {&tableName}.fm-codigo <= c-fm-codigo-fim
           and {&tableName}.cod-estabel >= c-cod-estab-ini
           and {&tableName}.cod-estabel <= c-cod-estab-fim
           no-lock NO-ERROR.
    
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FindLastRangeFmEstab DBOProgram 
PROCEDURE FindLastRangeFmEstab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/ 
    
     FIND LAST {&tableName}
         where {&tableName}.fm-codigo >= c-fm-codigo-ini
           and {&tableName}.fm-codigo <= c-fm-codigo-fim
           and {&tableName}.cod-estabel >= c-cod-estab-ini
           and {&tableName}.cod-estabel <= c-cod-estab-fim
           no-lock NO-ERROR.
    
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaEstabelec DBOProgram 
PROCEDURE retornaEstabelec :
/*------------------------------------------------------------------------------
  Purpose:    Este procedimento retorna todos os estabelecimentos da fam°lia. 
  Parameters: pfm-codigo: Fam°lia
              pestabelec: Estabelecimento
 ------------------------------------------------------------------------------*/
 define input  parameter pfm-codigo as char no-undo.
 define output parameter pestabelec as char no-undo.

    assign pestabelec = "".
    for each fam-uni-estab 
        where fam-uni-estab.fm-codigo = pfm-codigo NO-LOCK:
        find first estabelec where estabelec.cod-estabel = fam-uni-estab.cod-estabel no-lock no-error.
        if avail estabelec  = no then do:
            if pestabelec = "" then assign pestabelec = fam-uni-estab.cod-estabel + ",".
            else assign pestabelec = pestabelec + fam-uni-estab.cod-estabel + ",".
        end.
    end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFmCodigo DBOProgram 
PROCEDURE setConstraintFmCodigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define input parameter p-fm-codigo as character format "x(8)" no-undo.

assign c-fm-codigo = p-fm-codigo.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintRangeFmEstab DBOProgram 
PROCEDURE setConstraintRangeFmEstab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param pc-fm-codigo-ini like fam-uni-estab.fm-codigo no-undo.
    def input param pc-fm-codigo-fim like fam-uni-estab.fm-codigo no-undo.
    def input param pc-cod-estab-ini like fam-uni-estab.cod-estabel no-undo.
    def input param pc-cod-estab-fim like fam-uni-estab.cod-estabel no-undo.

    assign c-fm-codigo-ini = pc-fm-codigo-ini
           c-fm-codigo-fim = pc-fm-codigo-fim
           c-cod-estab-ini = pc-cod-estab-ini
           c-cod-estab-fim = pc-cod-estab-fim.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Valida temptable RowObject
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

    /* Validacoes especificas do CE0333 centralizadas em boin686va.p. */

    IF pType <> "DELETE":U THEN DO:
       find first param-compra no-lock no-error.
       if avail param-compra then do:
          if substring(param-compra.char-2,97,3) = "YES" then do:
            find first estabelec
                 where estabelec.cod-estabel = rowObject.cod-estab-gestor
                 no-lock no-error.        
            if not avail estabelec then do:     
               /* Inicio -- Projeto Internacional */
               DEFINE VARIABLE c-lbl-liter-estabelecimento-gestor AS CHARACTER NO-UNDO.
               {utp/ut-liter.i "Estabelecimento_Gestor" *}
               ASSIGN c-lbl-liter-estabelecimento-gestor = TRIM(RETURN-VALUE).
               {method/svc/errors/inserr.i &ErrorNumber="2"
                                           &ErrorType="EMS"
                                           &ErrorSubType="Error"
                                           &ErrorParameters="c-lbl-liter-estabelecimento-gestor"}
            end.
          end.
       end.   
    END.

    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


