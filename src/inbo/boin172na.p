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
{include/i-prgvrs.i BOIN172NA 2.00.00.038 } /*** "010038" 27/10/2023 17:03:43  ***/

/* procedure para gerar a versÆo para o log do appserver ou client log, o metodo apenas precisa receber parametros nao precisa fazer nada */
PROCEDURE geraLogApp:
    DEFINE INPUT  PARAMETER cPrgObj AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER cPrgVrs AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER fineNameProcessor AS CHARACTER   NO-UNDO.	
END PROCEDURE.
RUN geraLogApp (c-prg-obj, c-prg-vrs, "{&FILE-NAME}").
/* fim - procedure para gerar a versÆo para o log do appserver ou client log, o metodo apenas precisa receber parametros nao precisa fazer nada */
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin172na MUT}
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
&GLOBAL-DEFINE DBOName BOIN172
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName item
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

&GLOBAL-DEFINE CHANGE-QUERY-TO-FIND TRUE
&GLOBAL-DEFINE CHANGE-QUERY-TO-FIND-PROCS Main

/*--- Include com defini‡Æo da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com 
      extensÆo .i ---*/
{inbo/boin172na.i RowObject}


/*--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}


/*--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

def var c-fm-codigo-ini as char no-undo.
def var c-fm-codigo-fim as char no-undo.
def var c-fm-cod-com-ini as char no-undo.
def var c-fm-cod-com-fim as char no-undo.
def var c-it-codigo-ini as char no-undo.
def var c-it-codigo-fim as char no-undo.


def var cFamilIni     as char no-undo.
def var cFamilFim     as char no-undo.
def var iGeCodIni     as int  no-undo.
def var iGeCodFim     as int  no-undo.
def var cClassFiscIni as char no-undo.
def var cClassFiscFim as char no-undo.
def var cItCodigoIni  as char no-undo.
def var cItCodigoFim  as char no-undo.
def var cDescItemIni  as char no-undo.
def var cDescItemFim  as char no-undo.
def var lItemObsolete as log init true no-undo.
DEF VAR cCriteria AS CHAR NO-UNDO.
DEF VAR cEstabel AS CHAR NO-UNDO.
DEFINE VARIABLE iMaxTime   AS INT64 INIT 0    NO-UNDO.
DEFINE VARIABLE hCaller AS HANDLE      NO-UNDO.

def temp-table tt-dados NO-UNDO
    field r-rowid as rowid
    field it-codigo like item.it-codigo
    field descricao like item.desc-item
    field cod-refer like item.cod-refer
    field fm-cod-com like item.fm-cod-com
    field fm-codigo like item.fm-codigo
    field un like item.un.
DEFINE TEMP-TABLE ttListaRowid NO-UNDO FIELD uid as ROWID.

&IF '{&mgscm_version}' >= '2.06B' &THEN
DEFINE VARIABLE hDBOproxy AS HANDLE NO-UNDO.

DEF TEMP-TABLE ttItemReplica NO-UNDO
    FIELD it-codigo             LIKE wm-item.cod-item
    FIELD desc-item             LIKE wm-item.des-item
    FIELD unid-med              LIKE wm-item.cod-unid-med
    FIELD peso-bruto            LIKE wm-item.qtd-peso
    FIELD largura               LIKE wm-item.qtd-largura
    FIELD comprimento           LIKE wm-item.qtd-comprimento
    FIELD altura                LIKE wm-item.qtd-altura
    FIELD tipo-con-est          LIKE wm-item.ind-tipo-contr-est
    FIELD fm-cod-com            LIKE wm-item.cod-familia
    FIELD fm-codigo             LIKE wm-item.cod-familia
    INDEX ch-codigo AS PRIMARY UNIQUE it-codigo.
&ENDIF


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
         HEIGHT             = 1.67
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaTt-dados DBOProgram 
PROCEDURE carregaTt-dados :
/*------------------------------------------------------------------------------
  Purpose: Cria uma temp table com todos os item de uma faixa. Essa temp table ‚
           usada no cd1508f.w.    
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    def output param table for tt-dados .
    def input  param p-fm-codigo-ini as char.
    def input  param p-fm-codigo-fim as char.
    def input  param p-fm-cod-com-ini as char.
    def input  param p-fm-cod-com-fim as char.
   
    for each tt-dados fields():
        delete tt-dados.
    end.
    
    for each {&tableName} fields(it-codigo desc-item
                                 cod-refer fm-cod-com
                                 fm-codigo un) where
             {&tablename}.ind-item-fat = yes and /* item faturavel */                   
             {&tableName}.fm-codigo  >= p-fm-codigo-ini  and
             {&tableName}.fm-codigo  <= p-fm-codigo-fim  and
             {&tableName}.fm-cod-com >= p-fm-cod-com-ini and
             {&tableName}.fm-cod-com <= p-fm-cod-com-fim no-lock.
        create tt-dados.
        assign tt-dados.it-codigo = {&tablename}.it-codigo
               tt-dados.descricao = {&tableName}.desc-item
               tt-dados.cod-refer = {&tableName}.cod-refer
               tt-dados.fm-cod-com = {&tableName}.fm-cod-com
               tt-dados.fm-codigo = {&tableName}.fm-codigo
               tt-dados.un = {&tableName}.un
               tt-dados.r-rowid = rowid({&tableName}).
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram 
PROCEDURE afterCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF CONNECTED('mgscm') THEN DO: 
        IF RowObject.cod-obsoleto = 1 THEN DO:
            IF NOT VALID-HANDLE(hDBOproxy) THEN
                RUN wmp/wmprx044.p PERSISTENT SET hDBOproxy.
            EMPTY TEMP-TABLE ttItemReplica.
            CREATE ttItemReplica.
            ASSIGN ttItemReplica.it-codigo    = RowObject.it-codigo  
                   ttItemReplica.desc-item    = RowObject.desc-item
                   ttItemReplica.unid-med     = RowObject.un
                   ttItemReplica.peso-bruto   = RowObject.peso-bruto
                   ttItemReplica.largura      = RowObject.largura
                   ttItemReplica.comprimento  = RowObject.comprim
                   ttItemReplica.altura       = RowObject.altura
                   ttItemReplica.tipo-con-est = RowObject.tipo-con-est
                   ttItemReplica.fm-cod-com   = RowObject.fm-cod-com
                   ttItemReplica.fm-codigo    = RowObject.fm-codigo.
            RUN ReplicaItem IN hDBOproxy(INPUT TABLE ttItemReplica,
                                         OUTPUT TABLE RowErrors).
            RUN destroy     IN hDBOproxy.
        END.
    END.
    
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterUpdateRecord DBOProgram 
PROCEDURE afterUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF CONNECTED('mgscm') THEN DO: 
        IF RowObject.cod-obsoleto = 1 THEN DO:
            IF NOT VALID-HANDLE(hDBOproxy) THEN
                RUN wmp/wmprx044.p PERSISTENT SET hDBOproxy.
            EMPTY TEMP-TABLE ttItemReplica.
            CREATE ttItemReplica.
            ASSIGN ttItemReplica.it-codigo    = RowObject.it-codigo  
                   ttItemReplica.desc-item    = RowObject.desc-item
                   ttItemReplica.unid-med     = RowObject.un
                   ttItemReplica.peso-bruto   = RowObject.peso-bruto
                   ttItemReplica.largura      = RowObject.largura
                   ttItemReplica.comprimento  = RowObject.comprim
                   ttItemReplica.altura       = RowObject.altura
                   ttItemReplica.tipo-con-est = RowObject.tipo-con-est
                   ttItemReplica.fm-cod-com   = RowObject.fm-cod-com
                   ttItemReplica.fm-codigo    = RowObject.fm-codigo.
            RUN ReplicaItem IN hDBOproxy(INPUT TABLE ttItemReplica,
                                         OUTPUT TABLE RowErrors).
            RUN destroy     IN hDBOproxy.
        END.
    END.
   
RETURN "OK":U.

END PROCEDURE.


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findCodigo DBOProgram 
PROCEDURE findCodigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter pcItCodigo as char no-undo.
    def output parameter pcReturn  as char no-undo.
    
    run openQueryStatic ("Main":U).
    
    run goToKey (pcItCodigo).
    if return-value = "OK" then assign pcreturn = "".  /* esse ‚ o valor esperado nas interfaces 1.1 */
    if return-value = "NOK" then do:
        {utp/ut-table.i mgind {&TABLENAME} 1}
        run utp/ut-msgs.p (input "msg":U,
                           input 2,
                           input return-value).
        assign pcreturn =  return-value.  
        /* essa ‚ a mensagem esperada nas interfaces 1.1  qdo nÆo acha o registro */
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
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cd-folh-item":U THEN ASSIGN pFieldValue = RowObject.cd-folh-item.
        WHEN "cd-folh-lote":U THEN ASSIGN pFieldValue = RowObject.cd-folh-lote.
        WHEN "cd-planejado":U THEN ASSIGN pFieldValue = RowObject.cd-planejado.
        WHEN "cd-referencia":U THEN ASSIGN pFieldValue = RowObject.cd-referencia.
        WHEN "cd-tag":U THEN ASSIGN pFieldValue = RowObject.cd-tag.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "class-fiscal":U THEN ASSIGN pFieldValue = RowObject.class-fiscal.
        WHEN "cod-auxiliar":U THEN ASSIGN pFieldValue = RowObject.cod-auxiliar.
        WHEN "cod-comprado":U THEN ASSIGN pFieldValue = RowObject.cod-comprado.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-imagem":U THEN ASSIGN pFieldValue = RowObject.cod-imagem.
        WHEN "cod-lista-destino":U THEN ASSIGN pFieldValue = RowObject.cod-lista-destino.
        WHEN "cod-localiz":U THEN ASSIGN pFieldValue = RowObject.cod-localiz.
        WHEN "cod-produto":U THEN ASSIGN pFieldValue = RowObject.cod-produto.
        WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
        WHEN "codigo-refer":U THEN ASSIGN pFieldValue = RowObject.codigo-refer.
        WHEN "conta-aplicacao":U THEN ASSIGN pFieldValue = RowObject.conta-aplicacao.
        WHEN "ct-codigo":U THEN ASSIGN pFieldValue = RowObject.ct-codigo.
        WHEN "de-codigo-prin":U THEN ASSIGN pFieldValue = RowObject.de-codigo-prin.
        WHEN "deposito-pad":U THEN ASSIGN pFieldValue = RowObject.deposito-pad.
        WHEN "desc-inter":U THEN ASSIGN pFieldValue = RowObject.desc-inter.
        WHEN "desc-item":U THEN ASSIGN pFieldValue = RowObject.desc-item.
        WHEN "desc-nacional":U THEN ASSIGN pFieldValue = RowObject.desc-nacional.
        WHEN "descricao-1":U THEN ASSIGN pFieldValue = RowObject.descricao-1.
        WHEN "descricao-2":U THEN ASSIGN pFieldValue = RowObject.descricao-2.
        WHEN "fm-cod-com":U THEN ASSIGN pFieldValue = RowObject.fm-cod-com.
        WHEN "fm-codigo":U THEN ASSIGN pFieldValue = RowObject.fm-codigo.
        WHEN "inform-compl":U THEN ASSIGN pFieldValue = RowObject.inform-compl.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "it-demanda":U THEN ASSIGN pFieldValue = RowObject.it-demanda.
        WHEN "narrativa":U THEN ASSIGN pFieldValue = RowObject.narrativa.
        WHEN "niv-rest-fora":U THEN ASSIGN pFieldValue = RowObject.niv-rest-fora.
        WHEN "niv-rest-icms":U THEN ASSIGN pFieldValue = RowObject.niv-rest-icms.
        WHEN "path":U THEN ASSIGN pFieldValue = RowObject.path.
        WHEN "prefixo-lote":U THEN ASSIGN pFieldValue = RowObject.prefixo-lote.
        WHEN "responsavel":U THEN ASSIGN pFieldValue = RowObject.responsavel.
        WHEN "sc-codigo":U THEN ASSIGN pFieldValue = RowObject.sc-codigo.
        WHEN "un":U THEN ASSIGN pFieldValue = RowObject.un.
        WHEN "usuario-alt":U THEN ASSIGN pFieldValue = RowObject.usuario-alt.
        WHEN "usuario-obsol":U THEN ASSIGN pFieldValue = RowObject.usuario-obsol.
        WHEN "cod-unid-negoc":U THEN ASSIGN pFieldValue = RowObject.cod-unid-negoc.
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
        WHEN "data-base":U THEN ASSIGN pFieldValue = RowObject.data-base.
        WHEN "data-implant":U THEN ASSIGN pFieldValue = RowObject.data-implant.
        WHEN "data-liberac":U THEN ASSIGN pFieldValue = RowObject.data-liberac.
        WHEN "data-obsol":U THEN ASSIGN pFieldValue = RowObject.data-obsol.
        WHEN "data-ult-con":U THEN ASSIGN pFieldValue = RowObject.data-ult-con.
        WHEN "data-ult-ent":U THEN ASSIGN pFieldValue = RowObject.data-ult-ent.
        WHEN "data-ult-rep":U THEN ASSIGN pFieldValue = RowObject.data-ult-rep.
        WHEN "data-ult-sai":U THEN ASSIGN pFieldValue = RowObject.data-ult-sai.
        WHEN "dt-pr-fisc":U THEN ASSIGN pFieldValue = RowObject.dt-pr-fisc.
        WHEN "dt-ult-ben":U THEN ASSIGN pFieldValue = RowObject.dt-ult-ben.
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
        WHEN "aliquota-ipi":U THEN ASSIGN pFieldValue = RowObject.aliquota-ipi.
        WHEN "aliquota-ISS":U THEN ASSIGN pFieldValue = RowObject.aliquota-ISS.
        WHEN "altura":U THEN ASSIGN pFieldValue = RowObject.altura.
        WHEN "cap-est-fabr":U THEN ASSIGN pFieldValue = RowObject.cap-est-fabr.
        WHEN "comprim":U THEN ASSIGN pFieldValue = RowObject.comprim.
        WHEN "concentracao":U THEN ASSIGN pFieldValue = RowObject.concentracao.
        WHEN "consumo-aad":U THEN ASSIGN pFieldValue = RowObject.consumo-aad.
        WHEN "consumo-prev":U THEN ASSIGN pFieldValue = RowObject.consumo-prev.
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "fator-conver":U THEN ASSIGN pFieldValue = RowObject.fator-conver.
        WHEN "fator-reaj-icms":U THEN ASSIGN pFieldValue = RowObject.fator-reaj-icms.
        WHEN "fator-refugo":U THEN ASSIGN pFieldValue = RowObject.fator-refugo.
        WHEN "ft-conv-fmcoml":U THEN ASSIGN pFieldValue = RowObject.ft-conv-fmcoml.
        WHEN "ft-conversao":U THEN ASSIGN pFieldValue = RowObject.ft-conversao.
        WHEN "largura":U THEN ASSIGN pFieldValue = RowObject.largura.
        WHEN "lote-economi":U THEN ASSIGN pFieldValue = RowObject.lote-economi.
        WHEN "lote-minimo":U THEN ASSIGN pFieldValue = RowObject.lote-minimo.
        WHEN "lote-multipl":U THEN ASSIGN pFieldValue = RowObject.lote-multipl.
        WHEN "lote-mulven":U THEN ASSIGN pFieldValue = RowObject.lote-mulven.
        WHEN "per-min-luc":U THEN ASSIGN pFieldValue = RowObject.per-min-luc.
        WHEN "per-rest-fora":U THEN ASSIGN pFieldValue = RowObject.per-rest-fora.
        WHEN "per-rest-icms":U THEN ASSIGN pFieldValue = RowObject.per-rest-icms.
        WHEN "perc-demanda":U THEN ASSIGN pFieldValue = RowObject.perc-demanda.
        WHEN "perc-nqa":U THEN ASSIGN pFieldValue = RowObject.perc-nqa.
        WHEN "peso-bruto":U THEN ASSIGN pFieldValue = RowObject.peso-bruto.
        WHEN "peso-liquido":U THEN ASSIGN pFieldValue = RowObject.peso-liquido.
        WHEN "pr-sem-tx":U THEN ASSIGN pFieldValue = RowObject.pr-sem-tx.
        WHEN "preco-base":U THEN ASSIGN pFieldValue = RowObject.preco-base.
        WHEN "preco-fiscal":U THEN ASSIGN pFieldValue = RowObject.preco-fiscal.
        WHEN "preco-repos":U THEN ASSIGN pFieldValue = RowObject.preco-repos.
        WHEN "preco-ul-ent":U THEN ASSIGN pFieldValue = RowObject.preco-ul-ent.
        WHEN "qt-max-ordem":U THEN ASSIGN pFieldValue = RowObject.qt-max-ordem.
        WHEN "qt-var-max":U THEN ASSIGN pFieldValue = RowObject.qt-var-max.
        WHEN "qt-var-min":U THEN ASSIGN pFieldValue = RowObject.qt-var-min.
        WHEN "qtd-batch-padrao":U THEN ASSIGN pFieldValue = RowObject.qtd-batch-padrao.
        WHEN "qtd-refer-custo-dis":U THEN ASSIGN pFieldValue = RowObject.qtd-refer-custo-dis.
        WHEN "quant-pacote":U THEN ASSIGN pFieldValue = RowObject.quant-pacote.
        WHEN "quant-perda":U THEN ASSIGN pFieldValue = RowObject.quant-perda.
        WHEN "quant-segur":U THEN ASSIGN pFieldValue = RowObject.quant-segur.
        WHEN "rendimento":U THEN ASSIGN pFieldValue = RowObject.rendimento.
        WHEN "tp-cons-prev":U THEN ASSIGN pFieldValue = RowObject.tp-cons-prev.
        WHEN "tx-importacao":U THEN ASSIGN pFieldValue = RowObject.tx-importacao.
        WHEN "val-fator-custo-dis":U THEN ASSIGN pFieldValue = RowObject.val-fator-custo-dis.
        WHEN "valor-ipi-beb":U THEN ASSIGN pFieldValue = RowObject.valor-ipi-beb.
        WHEN "var-mob-maior":U THEN ASSIGN pFieldValue = RowObject.var-mob-maior.
        WHEN "var-mob-menor":U THEN ASSIGN pFieldValue = RowObject.var-mob-menor.
        WHEN "var-rep":U THEN ASSIGN pFieldValue = RowObject.var-rep.
        WHEN "var-req-maior":U THEN ASSIGN pFieldValue = RowObject.var-req-maior.
        WHEN "var-req-menor":U THEN ASSIGN pFieldValue = RowObject.var-req-menor.
        WHEN "var-transf":U THEN ASSIGN pFieldValue = RowObject.var-transf.
        WHEN "variac-acum":U THEN ASSIGN pFieldValue = RowObject.variac-acum.
        WHEN "vl-mat-ant":U THEN ASSIGN pFieldValue = RowObject.vl-mat-ant.
        WHEN "vl-mob-ant":U THEN ASSIGN pFieldValue = RowObject.vl-mob-ant.
        WHEN "vl-var-max":U THEN ASSIGN pFieldValue = RowObject.vl-var-max.
        WHEN "vl-var-min":U THEN ASSIGN pFieldValue = RowObject.vl-var-min.
        WHEN "volume":U THEN ASSIGN pFieldValue = RowObject.volume.
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
        WHEN "calc-cons-prev":U THEN ASSIGN pFieldValue = RowObject.calc-cons-prev.
        WHEN "calc-lead-time":U THEN ASSIGN pFieldValue = RowObject.calc-lead-time.
        WHEN "capac-recip-beb":U THEN ASSIGN pFieldValue = RowObject.capac-recip-beb.
        WHEN "cd-formula":U THEN ASSIGN pFieldValue = RowObject.cd-formula.
        WHEN "cd-origem":U THEN ASSIGN pFieldValue = RowObject.cd-origem.
        WHEN "cd-trib-icm":U THEN ASSIGN pFieldValue = RowObject.cd-trib-icm.
        WHEN "cd-trib-ipi":U THEN ASSIGN pFieldValue = RowObject.cd-trib-ipi.
        WHEN "cd-trib-iss":U THEN ASSIGN pFieldValue = RowObject.cd-trib-iss.
        WHEN "ciclo-contag":U THEN ASSIGN pFieldValue = RowObject.ciclo-contag.
        WHEN "classe-repro":U THEN ASSIGN pFieldValue = RowObject.classe-repro.
        WHEN "classif-abc":U THEN ASSIGN pFieldValue = RowObject.classif-abc.
        WHEN "cod-obsoleto":U THEN ASSIGN pFieldValue = RowObject.cod-obsoleto.
        WHEN "cod-servico":U THEN ASSIGN pFieldValue = RowObject.cod-servico.
        WHEN "cod-tax":U THEN ASSIGN pFieldValue = RowObject.cod-tax.
        WHEN "cod-tax-serv":U THEN ASSIGN pFieldValue = RowObject.cod-tax-serv.
        WHEN "codigo-orig":U THEN ASSIGN pFieldValue = RowObject.codigo-orig.
        WHEN "compr-fabric":U THEN ASSIGN pFieldValue = RowObject.compr-fabric.
        WHEN "contr-plan":U THEN ASSIGN pFieldValue = RowObject.contr-plan.
        WHEN "criticidade":U THEN ASSIGN pFieldValue = RowObject.criticidade.
        WHEN "dec-conv-fmcoml":U THEN ASSIGN pFieldValue = RowObject.dec-conv-fmcoml.
        WHEN "dec-ftcon":U THEN ASSIGN pFieldValue = RowObject.dec-ftcon.
        WHEN "demanda":U THEN ASSIGN pFieldValue = RowObject.demanda.
        WHEN "div-ordem":U THEN ASSIGN pFieldValue = RowObject.div-ordem.
        WHEN "emissao-ord":U THEN ASSIGN pFieldValue = RowObject.emissao-ord.
        WHEN "enquad-beb":U THEN ASSIGN pFieldValue = RowObject.enquad-beb.
        WHEN "esp-beb":U THEN ASSIGN pFieldValue = RowObject.esp-beb.
        WHEN "fase-medio":U THEN ASSIGN pFieldValue = RowObject.fase-medio.
        WHEN "ge-codigo":U THEN ASSIGN pFieldValue = RowObject.ge-codigo.
        WHEN "horiz-fixo":U THEN ASSIGN pFieldValue = RowObject.horiz-fixo.
        WHEN "ind-calc-meta":U THEN ASSIGN pFieldValue = RowObject.ind-calc-meta.
        WHEN "ind-imp-desc":U THEN ASSIGN pFieldValue = RowObject.ind-imp-desc.
        WHEN "ind-prev-demanda":U THEN ASSIGN pFieldValue = RowObject.ind-prev-demanda.
      /*  WHEN "ind-refugo":U THEN ASSIGN pFieldValue = RowObject.ind-refugo.   ---> campo ems203 */
        WHEN "ind-serv-mat":U THEN ASSIGN pFieldValue = RowObject.ind-serv-mat.
        WHEN "INT-1":U THEN ASSIGN pFieldValue = RowObject.INT-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "isencao-import":U THEN ASSIGN pFieldValue = RowObject.isencao-import.
        WHEN "moeda-padrao":U THEN ASSIGN pFieldValue = RowObject.moeda-padrao.
        WHEN "nat-despesa":U THEN ASSIGN pFieldValue = RowObject.nat-despesa.
        WHEN "niv-mais-bai":U THEN ASSIGN pFieldValue = RowObject.niv-mais-bai.
        WHEN "niv-mps":U THEN ASSIGN pFieldValue = RowObject.niv-mps.
        WHEN "nivel":U THEN ASSIGN pFieldValue = RowObject.nivel.
        WHEN "nivel-apr-compra":U THEN ASSIGN pFieldValue = RowObject.nivel-apr-compra.
        WHEN "nivel-apr-manut":U THEN ASSIGN pFieldValue = RowObject.nivel-apr-manut.
        WHEN "nivel-apr-requis":U THEN ASSIGN pFieldValue = RowObject.nivel-apr-requis.
        WHEN "nivel-apr-solic":U THEN ASSIGN pFieldValue = RowObject.nivel-apr-solic.
        WHEN "nr-item-dcr":U THEN ASSIGN pFieldValue = RowObject.nr-item-dcr.
        WHEN "nr-linha":U THEN ASSIGN pFieldValue = RowObject.nr-linha.
        WHEN "nr-pontos-quotas":U THEN ASSIGN pFieldValue = RowObject.nr-pontos-quotas.
        WHEN "Nr-ult-peca":U THEN ASSIGN pFieldValue = RowObject.Nr-ult-peca.
        /*WHEN "num-id-item":U THEN ASSIGN pFieldValue = RowObject.num-id-item.---> campo ems203 */
        WHEN "periodo-fixo":U THEN ASSIGN pFieldValue = RowObject.periodo-fixo.
        WHEN "perm-saldo-neg":U THEN ASSIGN pFieldValue = RowObject.perm-saldo-neg.
        WHEN "politica":U THEN ASSIGN pFieldValue = RowObject.politica.
        WHEN "prioridade":U THEN ASSIGN pFieldValue = RowObject.prioridade.
        WHEN "rep-prod":U THEN ASSIGN pFieldValue = RowObject.rep-prod.
        WHEN "reporte-ggf":U THEN ASSIGN pFieldValue = RowObject.reporte-ggf.
        WHEN "reporte-mob":U THEN ASSIGN pFieldValue = RowObject.reporte-mob.
        WHEN "res-cq-comp":U THEN ASSIGN pFieldValue = RowObject.res-cq-comp.
        WHEN "res-cq-fabri":U THEN ASSIGN pFieldValue = RowObject.res-cq-fabri.
        WHEN "res-for-comp":U THEN ASSIGN pFieldValue = RowObject.res-for-comp.
        WHEN "res-int-comp":U THEN ASSIGN pFieldValue = RowObject.res-int-comp.
        WHEN "ressup-fabri":U THEN ASSIGN pFieldValue = RowObject.ressup-fabri.
        WHEN "resumo-mp":U THEN ASSIGN pFieldValue = RowObject.resumo-mp.
        WHEN "sit-aloc":U THEN ASSIGN pFieldValue = RowObject.sit-aloc.
        WHEN "tempo-segur":U THEN ASSIGN pFieldValue = RowObject.tempo-segur.
        WHEN "tipo-atp":U THEN ASSIGN pFieldValue = RowObject.tipo-atp.
        WHEN "tipo-con-est":U THEN ASSIGN pFieldValue = RowObject.tipo-con-est.
        WHEN "tipo-contr":U THEN ASSIGN pFieldValue = RowObject.tipo-contr.
        WHEN "tipo-desc-nt":U THEN ASSIGN pFieldValue = RowObject.tipo-desc-nt.
        WHEN "tipo-est-seg":U THEN ASSIGN pFieldValue = RowObject.tipo-est-seg.
        WHEN "tipo-insp":U THEN ASSIGN pFieldValue = RowObject.tipo-insp.
        WHEN "tipo-lote-ec":U THEN ASSIGN pFieldValue = RowObject.tipo-lote-ec.
        WHEN "tipo-recip-beb":U THEN ASSIGN pFieldValue = RowObject.tipo-recip-beb.
        WHEN "tipo-requis":U THEN ASSIGN pFieldValue = RowObject.tipo-requis.
        WHEN "tipo-sched":U THEN ASSIGN pFieldValue = RowObject.tipo-sched.
        WHEN "tp-adm-lote":U THEN ASSIGN pFieldValue = RowObject.tp-adm-lote.
        WHEN "tp-aloc-lote":U THEN ASSIGN pFieldValue = RowObject.tp-aloc-lote.
        WHEN "tp-desp-padrao":U THEN ASSIGN pFieldValue = RowObject.tp-desp-padrao.
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
               retorna valor do campo it-codigo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pit-codigo LIKE item.it-codigo NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pit-codigo = RowObject.it-codigo.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKeyItem DBOProgram 
PROCEDURE getKeyItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pit-codigo LIKE item.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-refer LIKE item.cod-refer NO-UNDO.
    
    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.
    
    ASSIGN pit-codigo = RowObject.it-codigo
           pcod-refer = RowObject.cod-refer.

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
        WHEN "alt-refer":U THEN ASSIGN pFieldValue = RowObject.alt-refer.
        WHEN "atu-conf":U THEN ASSIGN pFieldValue = RowObject.atu-conf.
        WHEN "baixa-estoq":U THEN ASSIGN pFieldValue = RowObject.baixa-estoq.
        WHEN "contr-qualid":U THEN ASSIGN pFieldValue = RowObject.contr-qualid.
        WHEN "conv-tempo-seg":U THEN ASSIGN pFieldValue = RowObject.conv-tempo-seg.
        WHEN "curva-abc":U THEN ASSIGN pFieldValue = RowObject.curva-abc.
        WHEN "fraciona":U THEN ASSIGN pFieldValue = RowObject.fraciona.
        WHEN "id-grade":U THEN ASSIGN pFieldValue = RowObject.id-grade.
        WHEN "incentivado":U THEN ASSIGN pFieldValue = RowObject.incentivado.
        WHEN "ind-backorder":U THEN ASSIGN pFieldValue = RowObject.ind-backorder.
        WHEN "ind-confprodcom":U THEN ASSIGN pFieldValue = RowObject.ind-confprodcom.
        WHEN "ind-especifico":U THEN ASSIGN pFieldValue = RowObject.ind-especifico.
        WHEN "ind-inf-qtf":U THEN ASSIGN pFieldValue = RowObject.ind-inf-qtf.
        WHEN "ind-ipi-dife":U THEN ASSIGN pFieldValue = RowObject.ind-ipi-dife.
        WHEN "ind-item-fat":U THEN ASSIGN pFieldValue = RowObject.ind-item-fat.
        WHEN "ind-quotas":U THEN ASSIGN pFieldValue = RowObject.ind-quotas.
        WHEN "loc-unica":U THEN ASSIGN pFieldValue = RowObject.loc-unica.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "log-atualiz-via-mmp":U THEN ASSIGN pFieldValue = RowObject.log-atualiz-via-mmp.
        WHEN "log-carac-tec":U THEN ASSIGN pFieldValue = RowObject.log-carac-tec.
        WHEN "log-utiliza-batch-padrao":U THEN ASSIGN pFieldValue = RowObject.log-utiliza-batch-padrao.
        WHEN "pm-ja-calc":U THEN ASSIGN pFieldValue = RowObject.pm-ja-calc.
        WHEN "rot-quant":U THEN ASSIGN pFieldValue = RowObject.rot-quant.
        WHEN "rot-refer":U THEN ASSIGN pFieldValue = RowObject.rot-refer.
        WHEN "rot-revis":U THEN ASSIGN pFieldValue = RowObject.rot-revis.
        WHEN "tp-lote-econom":U THEN ASSIGN pFieldValue = RowObject.tp-lote-econom.
        WHEN "tp-lote-minimo":U THEN ASSIGN pFieldValue = RowObject.tp-lote-minimo.
        WHEN "tp-lote-multiplo":U THEN ASSIGN pFieldValue = RowObject.tp-lote-multiplo.
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
               recebe valor do campo it-codigo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pit-codigo LIKE item.it-codigo NO-UNDO.

    FIND FIRST bfitem WHERE 
        bfitem.it-codigo = pit-codigo NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfitem THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfitem)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKeyItem DBOProgram 
PROCEDURE goToKeyItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pit-codigo LIKE item.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-refer LIKE item.cod-refer NO-UNDO.

    FIND FIRST bfitem
         WHERE bfitem.it-codigo = pit-codigo
           AND bfitem.cod-refer = pcod-refer NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfitem THEN 
       RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfitem)).

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
            run openQueryStatic ("Main":U).
    end case.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFaixaDescItem DBOProgram 
PROCEDURE openQueryFaixaDescItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    open query qr{&tableName} for each {&tableName}
     WHERE item.descricao-1 >= substring (cDescItemIni, 1,  18)
       AND item.descricao-1 <= substring (cDescItemFim, 1,  18)
       AND item.descricao-2 >= substring (cDescItemIni, 19, 18)
       AND item.descricao-2 <= substring (cDescItemFim, 19, 18) NO-LOCK
        BY item.descricao-1
        BY item.descricao-2.

   return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryItemUf DBOProgram 
PROCEDURE openQueryItemUf :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    IF NOT lItemObsolete THEN
      open query qr{&tableName} for each {&tableName} 
          where {&tablename}.it-codigo    >= cItCodigoIni
          and   {&tablename}.it-codigo    <= cItCodigoFim
          and   {&tableName}.class-fiscal >= cClassFiscIni
          and   {&tableName}.class-fiscal <= cClassFiscFim
          and   {&tableName}.fm-codigo    >= cFamilIni     
          and   {&tableName}.fm-codigo    <= cFamilFim  
          and   {&tableName}.ge-codigo    >= iGeCodIni    
          and   {&tableName}.ge-codigo    <= iGeCodFim
          and   {&tableName}.cod-obsoleto = 1
          no-lock indexed-reposition.
    ELSE 
      open query qr{&tableName} for each {&tableName} 
          where {&tablename}.it-codigo    >= cItCodigoIni
          and   {&tablename}.it-codigo    <= cItCodigoFim
          and   {&tableName}.class-fiscal >= cClassFiscIni
          and   {&tableName}.class-fiscal <= cClassFiscFim
          and   {&tableName}.fm-codigo    >= cFamilIni     
          and   {&tableName}.fm-codigo    <= cFamilFim  
          and   {&tableName}.ge-codigo    >= iGeCodIni    
          and   {&tableName}.ge-codigo    <= iGeCodFim
          no-lock indexed-reposition.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFaixaFamilia DBOProgram 
PROCEDURE openQueryFaixaFamilia :
/*------------------------------------------------------------------------------
  Purpose:      
  Parameters:  <none>
  Notes: Usado no programa cd1508f e wcd1508f.      
------------------------------------------------------------------------------*/
  open query qr{&tableName} for each {&tableName} where
       {&tableName}.fm-codigo  >= c-fm-codigo-ini  and
       {&tableName}.fm-codigo  <= c-fm-codigo-fim  and
       {&tableName}.fm-cod-com >= c-fm-cod-com-ini and
       {&tableName}.fm-cod-com <= c-fm-cod-com-fim and
       {&tablename}.ind-item-fat = yes  /* item faturavel */                   
       no-lock indexed-reposition.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFaixaItem DBOProgram 
PROCEDURE openQueryFaixaItem :
/*------------------------------------------------------------------------------
  Purpose:      
  Parameters:  <none>
  Notes: Usado no zoom de item do programa wcd1508.      
------------------------------------------------------------------------------*/
    open query qr{&tableName} for each {&tableName}
         where {&tablename}.it-codigo >= cItCodigoIni
           and {&tablename}.it-codigo <= cItCodigoFim use-index codigo NO-LOCK INDEXED-REPOSITION.

   return "OK":U.

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

  OPEN QUERY qr{&tableName} FOR EACH {&TABLENAME} NO-LOCK INDEXED-REPOSITION.

  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryAtivos DBOProgram 
PROCEDURE openQueryAtivos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  OPEN QUERY qr{&tableName} FOR EACH {&TABLENAME} 
      WHERE {&TABLENAME}.cod-obsoleto = 1 NO-LOCK INDEXED-REPOSITION.

  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findFirstMain DBOProgram 
PROCEDURE findFirstMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND FIRST {&TABLENAME} NO-LOCK NO-ERROR.
     
    RETURN "OK":U  .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findLastMain DBOProgram 
PROCEDURE findLastMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND LAST {&TABLENAME} NO-LOCK NO-ERROR.

    RETURN "OK":U  .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findNextMain DBOProgram 
PROCEDURE findNextMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND NEXT {&TABLENAME} NO-LOCK NO-ERROR.
     
    RETURN "OK":U  .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findPrevMain DBOProgram 
PROCEDURE findPrevMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND PREV {&TABLENAME} NO-LOCK NO-ERROR.

    RETURN "OK":U  .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintDescItem DBOProgram 
PROCEDURE setConstraintDescItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param pcDescItemIni as char no-undo.
def input param pcDescItemFim as char no-undo.

    assign cDescItemIni = pcDescItemIni
           cDescItemFim = pcDescItemFim.
           
   return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFlex DBOProgram 
PROCEDURE openQueryFlex :

  DEFINE VARIABLE cri AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE qry AS HANDLE      NO-UNDO.

  IF cCriteria <> "" THEN
    ASSIGN cri = " where ":U + cCriteria.

  qry = QUERY qr{&tableName}:HANDLE. 

  qry:QUERY-PREPARE("for each item ":U + cri).
  qry:QUERY-OPEN().

  return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFaixaFamilia DBOProgram 
PROCEDURE setConstraintFaixaFamilia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param p-fm-codigo-ini as char no-undo.
    def input param p-fm-codigo-fim as char no-undo.
    def input param p-fm-cod-com-ini as char no-undo.
    def input param p-fm-cod-com-fim as char no-undo.
    
    assign c-fm-codigo-ini = p-fm-codigo-ini
           c-fm-codigo-fim = p-fm-codigo-fim
           c-fm-cod-com-ini = p-fm-cod-com-ini
           c-fm-cod-com-fim = p-fm-cod-com-fim.
           
    RETURN "OK":U.
    
    
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFaixaItem DBOProgram 
PROCEDURE setConstraintFaixaItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param p-it-codigo-ini as char no-undo.
    def input param p-it-codigo-fim as char no-undo.
    
    assign c-it-codigo-ini = p-it-codigo-ini
           c-it-codigo-fim = p-it-codigo-fim.
           
    RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCriteria DBOProgram 
PROCEDURE setConstraintCriteria :

    def input param pCriteria as char no-undo.
    
    assign cCriteria = pCriteria.
           
    RETURN "OK":U.        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintEstabel DBOProgram 
PROCEDURE setConstraintEstabel :

    def input param pEstabel as char no-undo.
    
    assign cEstabel = pEstabel.
           
    RETURN "OK":U.        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintItem DBOProgram 
PROCEDURE setConstraintItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input param pcItCodigoIni as char no-undo.
def input param pcItCodigoFim as char no-undo.

    assign cItCodigoIni = pcItCodigoIni
           cItCodigoFim = pcItCodigoFim.
           
   return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintMain DBOProgram 
PROCEDURE setConstraintMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintItemUf DBOProgram 
PROCEDURE setConstraintItemUf :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param pcItCodigoIni  as char no-undo.
    def input param pcItCodigoFim  as char no-undo.
    def input param pcClassFiscIni as char no-undo.
    def input param pcClassFiscFim as char no-undo.
    def input param pcFamilIni     as char no-undo.
    def input param pcFamilFim     as char no-undo.
    def input param piGeCodIni     as int  no-undo.
    def input param piGeCodFim     as int  no-undo.

    
    assign cItCodigoIni  = pcItCodigoIni
           cItCodigoFim  = pcItCodigoFim
           cClassFiscIni = pcClassFiscIni
           cClassFiscFim = pcClassFiscFim
           cFamilIni     = pcFamilIni
           cFamilFim     = pcFamilFim
           iGeCodIni     = piGeCodIni
           iGeCodFim     = piGeCodFim.

    RETURN "OK":U. 
END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintItemUfObsolete DBOProgram 
PROCEDURE setConstraintItemUfObsolete :
  /*------------------------------------------------------------------------------
    Purpose:     
    Parameters:  <none>
    Notes:       
  ------------------------------------------------------------------------------*/
      def input param pcItCodigoIni  as char no-undo.
      def input param pcItCodigoFim  as char no-undo.
      def input param pcClassFiscIni as char no-undo.
      def input param pcClassFiscFim as char no-undo.
      def input param pcFamilIni     as char no-undo.
      def input param pcFamilFim     as char no-undo.
      def input param piGeCodIni     as int  no-undo.
      def input param piGeCodFim     as int  no-undo.
      def input param plItemObsolete as log  no-undo.
  
      
      assign cItCodigoIni  = pcItCodigoIni
             cItCodigoFim  = pcItCodigoFim
             cClassFiscIni = pcClassFiscIni
             cClassFiscFim = pcClassFiscFim
             cFamilIni     = pcFamilIni
             cFamilFim     = pcFamilFim
             iGeCodIni     = piGeCodIni
             iGeCodFim     = piGeCodFim
             lItemObsolete = plItemObsolete.
  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnRowids DBOProgram 
PROCEDURE returnRowids :
    DEFINE INPUT  PARAMETER lretornaTudo AS LOGICAL     NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR ttListaRowid.

    DEFINE VARIABLE cont AS INTEGER     NO-UNDO.

    GET FIRST {&QueryName} NO-LOCK.

    EMPTY TEMP-TABLE ttListaRowid.

    cont = 0.
    DO WHILE AVAILABLE(ITEM):

        IF item.cod-obsoleto <> 4 and 
           can-find(item-uni-estab where 
                        item-uni-estab.it-codigo = item.it-codigo 
                    and item-uni-estab.cod-estabel = cEstabel
                    and item-uni-estab.ind-item-fat = YES)
        THEN DO:
        CREATE ttListaRowid.
        ASSIGN ttListaRowid.uid = ROWID(ITEM).
        cont = cont + 1.
        
        IF lretornaTudo = NO AND 
           cont >= 100 THEN LEAVE.
       
        END.
        GET NEXT {&QueryName} NO-LOCK.
    END. 
    
    RETURN "OK":U.
END PROCEDURE.
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnItensByRowids DBOProgram 
PROCEDURE returnItensByRowids :
    
    DEFINE INPUT PARAMETER TABLE FOR ttListaRowid.
    DEFINE OUTPUT PARAMETER TABLE FOR RowObject.

    FOR EACH ttListaRowid:
        FIND ITEM WHERE ROWID(ITEM) = ttListaRowid.uid NO-LOCK NO-ERROR.
        IF AVAIL ITEM
        THEN DO:
            CREATE RowObject.
            BUFFER-COPY ITEM TO RowObject.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnCount DBOProgram 
PROCEDURE returnCount :
    DEFINE OUTPUT PARAMETER iCount AS INTEGER     NO-UNDO.

    GET FIRST {&QueryName} NO-LOCK.

    EMPTY TEMP-TABLE ttListaRowid.

    iCount = 0.
    DO WHILE AVAILABLE(ITEM):



        IF item.cod-obsoleto <> 4 and 
           can-find(item-uni-estab where 
                        item-uni-estab.it-codigo = item.it-codigo 
                    and item-uni-estab.cod-estabel = cEstabel
                    and item-uni-estab.ind-item-fat = YES)
        THEN DO:
            iCount = iCount + 1.

            IF hCaller <> ? THEN
                RUN addItemCountResultItem IN hCaller (ROWID (ITEM)).

            IF iMaxTime > 0 THEN
                IF ETIME > iMaxTime THEN RETURN "timeout".

        END.
        
        
        GET NEXT {&QueryName} NO-LOCK.
    END. 
    
    RETURN "OK":U.
END PROCEDURE.
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnRowids DBOProgram 
PROCEDURE getTtRowids :
    DEFINE OUTPUT PARAMETER TABLE FOR ttListaRowid.
END PROCEDURE.
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnRowids DBOProgram 
PROCEDURE setMaxResponseTime :
    DEFINE INPUT  PARAMETER piMaxTime AS INT64 NO-UNDO.
    DEFINE INPUT  PARAMETER phCaller  AS HANDLE      NO-UNDO.

    iMaxTime = piMaxTime.

    IF phCaller:GET-SIGNATURE("addItemCountResultItem") <> "" THEN
        hCaller = phCaller.


END PROCEDURE.
&ANALYZE-RESUME
