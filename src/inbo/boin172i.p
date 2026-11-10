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
{include/i-prgvrs.i BOIN172I 2.00.00.008 } /*** "010008" 17/06/2025 16:40:46 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin172i MUT}
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

/*--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN172
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName item
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

/* DBO-XML-BEGIN */
/* Pre-processadores para ativar XML no DBO */
/* Retirar o comentario para ativar 
&GLOBAL-DEFINE XMLProducer YES    /* DBO atua como producer de mensagens para o Message Broker */
&GLOBAL-DEFINE XMLTopic           /* Topico da Mensagem enviada ao Message Broker, geralmente o nome da tabela */
&GLOBAL-DEFINE XMLTableName       /* Nome da tabela que deve ser usado como TAG no XML */ 
&GLOBAL-DEFINE XMLTableNameMult   /* Nome da tabela no plural. Usado para multiplos registros */ 
&GLOBAL-DEFINE XMLPublicFields    /* Lista dos campos (c1,c2) que podem ser enviados via XML. Ficam fora da listas os campos de especializacao da tabela */ 
&GLOBAL-DEFINE XMLKeyFields       /* Lista dos campos chave da tabela (c1,c2) */
&GLOBAL-DEFINE XMLExcludeFields   /* Lista de campos a serem excluidos do XML quando PublicFields = "" */

&GLOBAL-DEFINE XMLReceiver YES    /* DBO atua como receiver de mensagens enviado pelo Message Broker (mÇtodo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /* Nome da Query que d† acessos a todos os registros, exceto os exclu°dos pela constraint de seguranáa. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /* Informar os campos da chave quando o Progress n∆o conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin172.i RowObject}


/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}

{include/i_dbtype.i}
/*--- Pre-processador openquery ---*/
&IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
   &GLOBAL-DEFINE v9indrep  INDEXED-REPOSITION
&endif

{cdp/cdcfgman.i}

/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/*--- Temp-Tables pi-criaTTItem ---*/
DEFINE TEMP-TABLE tt-item2 NO-UNDO
       field it-codigo like item.it-codigo
       field fm-codigo like item.fm-codigo
       field cd-folh-item like item.cd-folh-item
       field Descricao as char format "x(40)" 
       field r-rowid   as rowid
       field tt-val           as char format "x(16)"
       field tt-eq            as char format "x(80)"
       field l-display        as log
       index id is unique primary l-display it-codigo.

DEFINE TEMP-TABLE tt-comp-folh NO-UNDO
       field tt-row-comp-folh as rowid
       field tt-min           as char format "x(16)"
       field tt-max           as char format "x(16)"
       field tt-eq            as char format "x(80)"
       field comp-folh        like item.cd-folh-item
       FIELD marcado          AS LOG
       INDEX id  tt-row-comp-folh.

DEFINE TEMP-TABLE tt-tabela  NO-UNDO
       field cd-folh like comp-folh.cd-folh
       field cd-comp like comp-folh.cd-comp
       field nr-tabela like c-tab-res.nr-tabela
       field sequencia like c-tab-res.sequencia
       field l-confere as log
       FIELD c-result LIKE it-carac-tec.observacao
       INDEX folh-comp  AS PRIMARY nr-tabela cd-folh cd-comp /*c-result*/.

/*--- Vari†veis SetConstraintFltrZoom ---*/
def var l-ativo          as log no-undo.  
def var l-auto           as log no-undo. 
def var l-todas          as log no-undo. 
def var l-obsoleto       as log no-undo. 
def var i-op-radio       as int no-undo. 
def var i-compr-fabric   as int no-undo.  
def var i-ge-codigo-ini  as int no-undo. 
def var i-ge-codigo-fim  as int no-undo. 
def var c-it-codigo-ini  as char format "x(16)":U no-undo. 
def var c-it-codigo-fim  as char format "x(16)":U no-undo. 
def var c-desc-item-ini  as char format "x(60)":U no-undo. 
def var c-desc-item-fim  as char format "x(60)":U no-undo. 
def var c-fm-codigo-ini  as char format "x(8)":U  no-undo. 
def var c-fm-codigo-fim  as char format "x(8)":U  no-undo. 
def var c-fm-cod-com-ini as char format "x(8)":U  no-undo. 
def var c-fm-cod-com-fim as char format "x(8)":U  no-undo. 
def var c-cod-refer-ini  as char format "x(20)":U no-undo.
def var c-cod-refer-fim  as char format "x(20)":U no-undo. 
def var c-op-combo       as char format "x(30)":U no-undo. 

/*--- Vari†veis GetPalavra ---*/
def var c-palavra  as char format "x(60)":U no-undo.

/*Vari†veis SetConstraintLFltrNo*/
def var c-ini    as char format "x(60)":U no-undo.
def var c-fim    as char format "x(60)":U no-undo.
def var l-filtro as log no-undo.  

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
   Other Settings: CODE-ONLY COMPILE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterGetBatchRecords DBOProgram 
PROCEDURE afterGetBatchRecords :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  if item.compr-fabric = 1 then
     assign RowObjectAux.char-1 = "Comprado".
  else
     assign RowObjectAux.char-1 = "Fabricado".   

  if item.cod-obsoleto = 1 then 
        assign RowObjectAux.char-2 = "Ativo".
     else if item.cod-obsoleto = 2 then
          assign RowObjectAux.char-2 = "Obsoleto Ordens Autom†ticas".
       else if item.cod-obsoleto = 3 then
            assign RowObjectAux.char-2 = "Obsoleto Todas as Ordens".
          else 
              assign RowObjectAux.char-2 = "Totalmente Obsoleto".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterGetBatchRecordsPrev DBOProgram 
PROCEDURE afterGetBatchRecordsPrev :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  if item.compr-fabric = 1 then
     assign RowObjectAux.char-1 = "Comprado".
  else
     assign RowObjectAux.char-1 = "Fabricado".   

  if item.cod-obsoleto = 1 then 
        assign RowObjectAux.char-2 = "Ativo".
     else if item.cod-obsoleto = 2 then
          assign RowObjectAux.char-2 = "Obsoleto Ordens Autom†ticas".
       else if item.cod-obsoleto = 3 then
            assign RowObjectAux.char-2 = "Obsoleto Todas as Ordens".
          else 
              assign RowObjectAux.char-2 = "Totalmente Obsoleto".

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
      &IF DEFINED (bf_man_205) &THEN
      &ELSE
        WHEN "revisao":U THEN ASSIGN pFieldValue = RowObject.revisao.
        WHEN "rv-codigo":U THEN ASSIGN pFieldValue = RowObject.rv-codigo.
      &ENDIF
        WHEN "sc-codigo":U THEN ASSIGN pFieldValue = RowObject.sc-codigo.
        WHEN "un":U THEN ASSIGN pFieldValue = RowObject.un.
        WHEN "usuario-alt":U THEN ASSIGN pFieldValue = RowObject.usuario-alt.
        WHEN "usuario-obsol":U THEN ASSIGN pFieldValue = RowObject.usuario-obsol.
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescFolhEspec DBOProgram 
PROCEDURE getDescFolhEspec :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE INPUT PARAMETER pCodFolh   AS CHAR FORMAT "x(8)":U  NO-UNDO.
 DEFINE OUTPUT PARAMETER pDescFolh AS CHAR FORMAT "x(40)":U NO-UNDO.

    FIND folh-espec NO-LOCK
       WHERE folh-espec.cd-folha = pCodFolh NO-ERROR.
    IF AVAIL folh-espec THEN
        pDescFolh = folh-espec.descricao.
    ELSE
        pDescFolh = "".

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
        WHEN "ind-refugo":U THEN ASSIGN pFieldValue = RowObject.ind-refugo.
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
        WHEN "num-id-item":U THEN ASSIGN pFieldValue = RowObject.num-id-item.
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
  Purpose:     Retorna valores dos campos do °ndice codigo
  Parameters:  
               retorna valor do campo it-codigo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pit-codigo LIKE item.it-codigo NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pit-codigo = RowObject.it-codigo.

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
        WHEN "log-necessita-li":U THEN ASSIGN pFieldValue = RowObject.log-necessita-li.
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
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pit-codigo LIKE item.it-codigo NO-UNDO.

    FIND FIRST bfitem WHERE 
        bfitem.it-codigo = pit-codigo NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfitem THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfitem)).
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
open query {&QUERYNAME} for each {&TABLENAME} no-lock {&v9indrep}.


    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryZoom DBOProgram 
PROCEDURE openQueryZoom :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

if l-filtro then do:

  if i-op-radio = 1 then do :    
     if c-op-combo = "Item" then     
        case i-compr-fabric:

            when 1 then 
              open query {&QUERYNAME} for each {&TABLENAME} where 
                                               {&tablename}.it-codigo    >= c-ini              AND
                                               {&tablename}.it-codigo    <= c-fim              AND
                                               {&TABLENAME}.desc-item    >= c-desc-item-ini    AND
                                               {&TABLENAME}.desc-item    <= c-desc-item-fim    AND
                                               {&TABLENAME}.fm-codigo    >= c-fm-codigo-ini    AND
                                               {&TABLENAME}.fm-codigo    <= c-fm-codigo-fim    AND
                                               {&TABLENAME}.fm-cod-com   >= c-fm-cod-com-ini   AND
                                               {&TABLENAME}.fm-cod-com   <= c-fm-cod-com-fim   AND
                                               {&TABLENAME}.ge-codigo    >= i-ge-codigo-ini    AND
                                               {&TABLENAME}.ge-codigo    <= i-ge-codigo-fim    AND
                                               {&TABLENAME}.codigo-refer >= c-cod-refer-ini    AND
                                               {&TABLENAME}.codigo-refer <= c-cod-refer-fim    AND
                                               {&TABLENAME}.compr-fabric = 1                   AND 
                                              (({&TABLENAME}.cod-obsoleto = 1 and l-ativo)     OR
                                               ({&TABLENAME}.cod-obsoleto = 2 and l-auto )     OR
                                               ({&TABLENAME}.cod-obsoleto = 3 and l-todas)     OR
                                               ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                                no-lock by {&tablename}.it-codigo {&v9indrep}.
            when 2 then 
              open query {&QUERYNAME} for each {&TABLENAME} where 
                                               {&tablename}.it-codigo    >= c-ini              AND 
                                               {&tablename}.it-codigo    <= c-fim              AND 
                                               {&TABLENAME}.desc-item    >= c-desc-item-ini    AND
                                               {&TABLENAME}.desc-item    <= c-desc-item-fim    AND
                                               {&TABLENAME}.fm-codigo    >= c-fm-codigo-ini    AND
                                               {&TABLENAME}.fm-codigo    <= c-fm-codigo-fim    AND
                                               {&TABLENAME}.fm-cod-com   >= c-fm-cod-com-ini   AND
                                               {&TABLENAME}.fm-cod-com   <= c-fm-cod-com-fim   AND
                                               {&TABLENAME}.ge-codigo    >= i-ge-codigo-ini    AND
                                               {&TABLENAME}.ge-codigo    <= i-ge-codigo-fim    AND
                                               {&TABLENAME}.codigo-refer >= c-cod-refer-ini    AND
                                               {&TABLENAME}.codigo-refer <= c-cod-refer-fim    AND
                                               {&TABLENAME}.compr-fabric = 2                   AND 
                                              (({&TABLENAME}.cod-obsoleto = 1 and l-ativo)     OR
                                               ({&TABLENAME}.cod-obsoleto = 2 and l-auto )     OR
                                               ({&TABLENAME}.cod-obsoleto = 3 and l-todas)     OR
                                               ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                                no-lock by {&tablename}.it-codigo {&v9indrep}.
              when 3 then 
                open query {&QUERYNAME} for each {&TABLENAME} where 
                                                 {&tablename}.it-codigo    >= c-ini              AND 
                                                 {&tablename}.it-codigo    <= c-fim              AND 
                                                 {&TABLENAME}.desc-item    >= c-desc-item-ini    AND
                                                 {&TABLENAME}.desc-item    <= c-desc-item-fim    AND
                                                 {&TABLENAME}.fm-codigo    >= c-fm-codigo-ini    AND
                                                 {&TABLENAME}.fm-codigo    <= c-fm-codigo-fim    AND
                                                 {&TABLENAME}.fm-cod-com   >= c-fm-cod-com-ini   AND
                                                 {&TABLENAME}.fm-cod-com   <= c-fm-cod-com-fim   AND
                                                 {&TABLENAME}.ge-codigo    >= i-ge-codigo-ini    AND
                                                 {&TABLENAME}.ge-codigo    <= i-ge-codigo-fim    AND
                                                 {&TABLENAME}.codigo-refer >= c-cod-refer-ini    AND
                                                 {&TABLENAME}.codigo-refer <= c-cod-refer-fim    AND
                                                (({&TABLENAME}.cod-obsoleto = 1 and l-ativo)     OR
                                                 ({&TABLENAME}.cod-obsoleto = 2 and l-auto )     OR
                                                 ({&TABLENAME}.cod-obsoleto = 3 and l-todas)     OR
                                                 ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                                  no-lock by {&tablename}.it-codigo {&v9indrep}.
        end.
     if c-op-combo = "Descriá∆o" then 
       case i-compr-fabric:

         when 1 then
           open query {&QUERYNAME} for each {&TABLENAME} where
                                            {&tablename}.it-codigo    >= c-it-codigo-ini    AND
                                            {&tablename}.it-codigo    <= c-it-codigo-fim    AND
                                            {&TABLENAME}.desc-item    >= c-ini              AND
                                            {&TABLENAME}.desc-item    <= c-fim              AND
                                            {&TABLENAME}.fm-codigo    >= c-fm-codigo-ini    AND
                                            {&TABLENAME}.fm-codigo    <= c-fm-codigo-fim    AND
                                            {&TABLENAME}.fm-cod-com   >= c-fm-cod-com-ini   AND
                                            {&TABLENAME}.fm-cod-com   <= c-fm-cod-com-fim   AND
                                            {&TABLENAME}.ge-codigo    >= i-ge-codigo-ini    AND
                                            {&TABLENAME}.ge-codigo    <= i-ge-codigo-fim    AND
                                            {&TABLENAME}.codigo-refer >= c-cod-refer-ini    AND
                                            {&TABLENAME}.codigo-refer <= c-cod-refer-fim    AND
                                            {&TABLENAME}.compr-fabric = 1                   AND
                                           (({&TABLENAME}.cod-obsoleto = 1 and l-ativo)     OR
                                            ({&TABLENAME}.cod-obsoleto = 2 and l-auto )     OR
                                            ({&TABLENAME}.cod-obsoleto = 3 and l-todas)     OR
                                            ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                            no-lock by {&TABLENAME}.desc-item
                                                     by {&tablename}.it-codigo {&v9indrep}.

         when 2 then 
           open query {&QUERYNAME} for each {&TABLENAME} where
                                            {&tablename}.it-codigo    >= c-it-codigo-ini    AND
                                            {&tablename}.it-codigo    <= c-it-codigo-fim    AND
                                            {&TABLENAME}.desc-item    >= c-ini              AND 
                                            {&TABLENAME}.desc-item    <= c-fim              AND 
                                            {&TABLENAME}.fm-codigo    >= c-fm-codigo-ini    AND
                                            {&TABLENAME}.fm-codigo    <= c-fm-codigo-fim    AND
                                            {&TABLENAME}.fm-cod-com   >= c-fm-cod-com-ini   AND
                                            {&TABLENAME}.fm-cod-com   <= c-fm-cod-com-fim   AND
                                            {&TABLENAME}.ge-codigo    >= i-ge-codigo-ini    AND
                                            {&TABLENAME}.ge-codigo    <= i-ge-codigo-fim    AND
                                            {&TABLENAME}.codigo-refer >= c-cod-refer-ini    AND
                                            {&TABLENAME}.codigo-refer <= c-cod-refer-fim    AND
                                            {&TABLENAME}.compr-fabric = 2                   AND 
                                           (({&TABLENAME}.cod-obsoleto = 1 and l-ativo)     OR
                                            ({&TABLENAME}.cod-obsoleto = 2 and l-auto )     OR
                                            ({&TABLENAME}.cod-obsoleto = 3 and l-todas)     OR
                                            ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                            no-lock by {&TABLENAME}.desc-item
                                                     by {&tablename}.it-codigo {&v9indrep}.

         when 3 then 
             open query {&QUERYNAME} for each {&TABLENAME} where 
                                              {&tablename}.it-codigo    >= c-it-codigo-ini    AND
                                              {&tablename}.it-codigo    <= c-it-codigo-fim    AND
                                              {&TABLENAME}.desc-item    >= c-ini              AND 
                                              {&TABLENAME}.desc-item    <= c-fim              AND 
                                              {&TABLENAME}.fm-codigo    >= c-fm-codigo-ini    AND
                                              {&TABLENAME}.fm-codigo    <= c-fm-codigo-fim    AND
                                              {&TABLENAME}.fm-cod-com   >= c-fm-cod-com-ini   AND
                                              {&TABLENAME}.fm-cod-com   <= c-fm-cod-com-fim   AND
                                              {&TABLENAME}.ge-codigo    >= i-ge-codigo-ini    AND
                                              {&TABLENAME}.ge-codigo    <= i-ge-codigo-fim    AND
                                              {&TABLENAME}.codigo-refer >= c-cod-refer-ini    AND
                                              {&TABLENAME}.codigo-refer <= c-cod-refer-fim    AND
                                             (({&TABLENAME}.cod-obsoleto = 1 and l-ativo)     OR
                                              ({&TABLENAME}.cod-obsoleto = 2 and l-auto )     OR
                                              ({&TABLENAME}.cod-obsoleto = 3 and l-todas)     OR
                                              ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                              no-lock by {&TABLENAME}.desc-item
                                                       by {&tablename}.it-codigo {&v9indrep}.
       end.
     if c-op-combo = "Fam°lia" then  
        case i-compr-fabric:

           when 1 then 
              open query {&QUERYNAME} for each {&TABLENAME} where 
                                               {&tablename}.it-codigo    >= c-it-codigo-ini    AND
                                               {&tablename}.it-codigo    <= c-it-codigo-fim    AND
                                               {&TABLENAME}.desc-item    >= c-desc-item-ini    AND
                                               {&TABLENAME}.desc-item    <= c-desc-item-fim    AND
                                               {&TABLENAME}.fm-codigo    >= c-ini              AND 
                                               {&TABLENAME}.fm-codigo    <= c-fim              AND 
                                               {&TABLENAME}.fm-cod-com   >= c-fm-cod-com-ini   AND
                                               {&TABLENAME}.fm-cod-com   <= c-fm-cod-com-fim   AND
                                               {&TABLENAME}.ge-codigo    >= i-ge-codigo-ini    AND
                                               {&TABLENAME}.ge-codigo    <= i-ge-codigo-fim    AND
                                               {&TABLENAME}.codigo-refer >= c-cod-refer-ini    AND
                                               {&TABLENAME}.codigo-refer <= c-cod-refer-fim    AND
                                               {&TABLENAME}.compr-fabric = 1                   AND 
                                              (({&TABLENAME}.cod-obsoleto = 1 and l-ativo)     OR
                                               ({&TABLENAME}.cod-obsoleto = 2 and l-auto )     OR
                                               ({&TABLENAME}.cod-obsoleto = 3 and l-todas)     OR
                                               ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                               no-lock by {&TABLENAME}.fm-codigo 
                                                        by {&tablename}.it-codigo {&v9indrep}.  
           when 2 then 
              open query {&QUERYNAME} for each {&TABLENAME} where 
                                            {&tablename}.it-codigo    >= c-it-codigo-ini    AND
                                            {&tablename}.it-codigo    <= c-it-codigo-fim    AND
                                            {&TABLENAME}.desc-item    >= c-desc-item-ini    AND
                                            {&TABLENAME}.desc-item    <= c-desc-item-fim    AND
                                            {&TABLENAME}.fm-codigo    >= c-ini              AND 
                                            {&TABLENAME}.fm-codigo    <= c-fim              AND 
                                            {&TABLENAME}.fm-cod-com   >= c-fm-cod-com-ini   AND
                                            {&TABLENAME}.fm-cod-com   <= c-fm-cod-com-fim   AND
                                            {&TABLENAME}.ge-codigo    >= i-ge-codigo-ini    AND
                                            {&TABLENAME}.ge-codigo    <= i-ge-codigo-fim    AND
                                            {&TABLENAME}.codigo-refer >= c-cod-refer-ini    AND
                                            {&TABLENAME}.codigo-refer <= c-cod-refer-fim    AND
                                            {&TABLENAME}.compr-fabric = 2                   AND 
                                           (({&TABLENAME}.cod-obsoleto = 1 and l-ativo)     OR
                                            ({&TABLENAME}.cod-obsoleto = 2 and l-auto )     OR
                                            ({&TABLENAME}.cod-obsoleto = 3 and l-todas)     OR
                                            ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                            no-lock by {&TABLENAME}.fm-codigo 
                                                     by {&tablename}.it-codigo {&v9indrep}. 
           when 3 then 
               open query {&QUERYNAME} for each {&TABLENAME} where 
                                              {&tablename}.it-codigo    >= c-it-codigo-ini    AND
                                              {&tablename}.it-codigo    <= c-it-codigo-fim    AND
                                              {&TABLENAME}.desc-item    >= c-desc-item-ini    AND
                                              {&TABLENAME}.desc-item    <= c-desc-item-fim    AND
                                              {&TABLENAME}.fm-codigo    >= c-ini              AND 
                                              {&TABLENAME}.fm-codigo    <= c-fim              AND 
                                              {&TABLENAME}.fm-cod-com   >= c-fm-cod-com-ini   AND
                                              {&TABLENAME}.fm-cod-com   <= c-fm-cod-com-fim   AND
                                              {&TABLENAME}.ge-codigo    >= i-ge-codigo-ini    AND
                                              {&TABLENAME}.ge-codigo    <= i-ge-codigo-fim    AND
                                              {&TABLENAME}.codigo-refer >= c-cod-refer-ini    AND
                                              {&TABLENAME}.codigo-refer <= c-cod-refer-fim    AND
                                             (({&TABLENAME}.cod-obsoleto = 1 and l-ativo)     OR
                                              ({&TABLENAME}.cod-obsoleto = 2 and l-auto )     OR
                                              ({&TABLENAME}.cod-obsoleto = 3 and l-todas)     OR
                                              ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                              no-lock by {&TABLENAME}.fm-codigo 
                                                       by {&tablename}.it-codigo {&v9indrep}. 
        end.
     if c-op-combo = "Fam°lia Comercial" then   
        case i-compr-fabric :

           when 1 then 
              open query {&QUERYNAME} for each {&TABLENAME} where                              
                                               {&tablename}.it-codigo    >= c-it-codigo-ini    AND
                                               {&tablename}.it-codigo    <= c-it-codigo-fim    AND
                                               {&TABLENAME}.desc-item    >= c-desc-item-ini    AND
                                               {&TABLENAME}.desc-item    <= c-desc-item-fim    AND
                                               {&TABLENAME}.fm-codigo    >= c-fm-codigo-ini    AND
                                               {&TABLENAME}.fm-codigo    <= c-fm-codigo-fim    AND
                                               {&TABLENAME}.fm-cod-com   >= c-ini              AND 
                                               {&TABLENAME}.fm-cod-com   <= c-fim              AND 
                                               {&TABLENAME}.ge-codigo    >= i-ge-codigo-ini    AND
                                               {&TABLENAME}.ge-codigo    <= i-ge-codigo-fim    AND
                                               {&TABLENAME}.codigo-refer >= c-cod-refer-ini    AND
                                               {&TABLENAME}.codigo-refer <= c-cod-refer-fim    AND
                                               {&TABLENAME}.compr-fabric = 1                   AND 
                                              (({&TABLENAME}.cod-obsoleto = 1 and l-ativo)     OR
                                               ({&TABLENAME}.cod-obsoleto = 2 and l-auto )     OR
                                               ({&TABLENAME}.cod-obsoleto = 3 and l-todas)     OR
                                               ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                               no-lock by {&TABLENAME}.fm-cod-com 
                                                        by {&tablename}.it-codigo {&v9indrep}. 

           when 2 then 
              open query {&QUERYNAME} for each {&TABLENAME} where 
                                            {&tablename}.it-codigo    >= c-it-codigo-ini    AND
                                            {&tablename}.it-codigo    <= c-it-codigo-fim    AND
                                            {&TABLENAME}.desc-item    >= c-desc-item-ini    AND
                                            {&TABLENAME}.desc-item    <= c-desc-item-fim    AND
                                            {&TABLENAME}.fm-codigo    >= c-fm-codigo-ini    AND
                                            {&TABLENAME}.fm-codigo    <= c-fm-codigo-fim    AND
                                            {&TABLENAME}.fm-cod-com   >= c-ini              AND  
                                            {&TABLENAME}.fm-cod-com   <= c-fim              AND  
                                            {&TABLENAME}.ge-codigo    >= i-ge-codigo-ini    AND
                                            {&TABLENAME}.ge-codigo    <= i-ge-codigo-fim    AND
                                            {&TABLENAME}.codigo-refer >= c-cod-refer-ini    AND
                                            {&TABLENAME}.codigo-refer <= c-cod-refer-fim    AND
                                            {&TABLENAME}.compr-fabric = 2                   AND 
                                           (({&TABLENAME}.cod-obsoleto = 1 and l-ativo)     OR
                                            ({&TABLENAME}.cod-obsoleto = 2 and l-auto )     OR
                                            ({&TABLENAME}.cod-obsoleto = 3 and l-todas)     OR
                                            ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                             no-lock by {&TABLENAME}.fm-cod-com 
                                                      by {&tablename}.it-codigo {&v9indrep}. 
           when 3 then 
              open query {&QUERYNAME} for each {&TABLENAME} where 
                                              {&tablename}.it-codigo    >= c-it-codigo-ini    AND
                                              {&tablename}.it-codigo    <= c-it-codigo-fim    AND
                                              {&TABLENAME}.desc-item    >= c-desc-item-ini    AND
                                              {&TABLENAME}.desc-item    <= c-desc-item-fim    AND
                                              {&TABLENAME}.fm-codigo    >= c-fm-codigo-ini    AND
                                              {&TABLENAME}.fm-codigo    <= c-fm-codigo-fim    AND
                                              {&TABLENAME}.fm-cod-com   >= c-ini              AND 
                                              {&TABLENAME}.fm-cod-com   <= c-fim              AND 
                                              {&TABLENAME}.ge-codigo    >= i-ge-codigo-ini    AND
                                              {&TABLENAME}.ge-codigo    <= i-ge-codigo-fim    AND
                                              {&TABLENAME}.codigo-refer >= c-cod-refer-ini    AND
                                              {&TABLENAME}.codigo-refer <= c-cod-refer-fim    AND
                                             (({&TABLENAME}.cod-obsoleto = 1 and l-ativo)     OR
                                              ({&TABLENAME}.cod-obsoleto = 2 and l-auto )     OR
                                              ({&TABLENAME}.cod-obsoleto = 3 and l-todas)     OR
                                              ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                              no-lock by {&TABLENAME}.fm-cod-com 
                                                       by {&tablename}.it-codigo {&v9indrep}.                                               
        end.
     if c-op-combo = "Grupo Estoque" then 
        case i-compr-fabric:

           when 1 then 
              open query {&QUERYNAME} for each {&TABLENAME} where 
                                               {&tablename}.it-codigo    >= c-it-codigo-ini    AND
                                               {&tablename}.it-codigo    <= c-it-codigo-fim    AND
                                               {&TABLENAME}.desc-item    >= c-desc-item-ini    AND
                                               {&TABLENAME}.desc-item    <= c-desc-item-fim    AND
                                               {&TABLENAME}.fm-codigo    >= c-fm-codigo-ini    AND
                                               {&TABLENAME}.fm-codigo    <= c-fm-codigo-fim    AND
                                               {&TABLENAME}.fm-cod-com   >= c-fm-cod-com-ini   AND
                                               {&TABLENAME}.fm-cod-com   <= c-fm-cod-com-fim   AND
                                               {&TABLENAME}.ge-codigo    >= INT(c-ini)         AND  
                                               {&TABLENAME}.ge-codigo    <= INT(c-fim)         AND  
                                               {&TABLENAME}.codigo-refer >= c-cod-refer-ini    AND
                                               {&TABLENAME}.codigo-refer <= c-cod-refer-fim    AND
                                               {&TABLENAME}.compr-fabric = 1                   AND 
                                              (({&TABLENAME}.cod-obsoleto = 1 and l-ativo)     OR
                                               ({&TABLENAME}.cod-obsoleto = 2 and l-auto )     OR
                                               ({&TABLENAME}.cod-obsoleto = 3 and l-todas)     OR
                                               ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                               no-lock by {&TABLENAME}.ge-codigo 
                                                        by {&tablename}.it-codigo {&v9indrep}.  
              
           when 2 then 
              open query {&QUERYNAME} for each {&TABLENAME} where 
                                            {&tablename}.it-codigo    >= c-it-codigo-ini    AND
                                            {&tablename}.it-codigo    <= c-it-codigo-fim    AND
                                            {&TABLENAME}.desc-item    >= c-desc-item-ini    AND
                                            {&TABLENAME}.desc-item    <= c-desc-item-fim    AND
                                            {&TABLENAME}.fm-codigo    >= c-fm-codigo-ini    AND
                                            {&TABLENAME}.fm-codigo    <= c-fm-codigo-fim    AND
                                            {&TABLENAME}.fm-cod-com   >= c-fm-cod-com-ini   AND
                                            {&TABLENAME}.fm-cod-com   <= c-fm-cod-com-fim   AND
                                            {&TABLENAME}.ge-codigo    >= INT(c-ini)         AND  
                                            {&TABLENAME}.ge-codigo    <= INT(c-fim)         AND  
                                            {&TABLENAME}.codigo-refer >= c-cod-refer-ini    AND
                                            {&TABLENAME}.codigo-refer <= c-cod-refer-fim    AND
                                            {&TABLENAME}.compr-fabric = 2                   AND 
                                           (({&TABLENAME}.cod-obsoleto = 1 and l-ativo)     OR
                                            ({&TABLENAME}.cod-obsoleto = 2 and l-auto )     OR
                                            ({&TABLENAME}.cod-obsoleto = 3 and l-todas)     OR
                                            ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                              no-lock by {&TABLENAME}.ge-codigo 
                                                       by {&tablename}.it-codigo {&v9indrep}.  
           when 3 then 
              open query {&QUERYNAME} for each {&TABLENAME} where 
                                              {&tablename}.it-codigo    >= c-it-codigo-ini    AND
                                              {&tablename}.it-codigo    <= c-it-codigo-fim    AND
                                              {&TABLENAME}.desc-item    >= c-desc-item-ini    AND
                                              {&TABLENAME}.desc-item    <= c-desc-item-fim    AND
                                              {&TABLENAME}.fm-codigo    >= c-fm-codigo-ini    AND
                                              {&TABLENAME}.fm-codigo    <= c-fm-codigo-fim    AND
                                              {&TABLENAME}.fm-cod-com   >= c-fm-cod-com-ini   AND
                                              {&TABLENAME}.fm-cod-com   <= c-fm-cod-com-fim   AND
                                              {&TABLENAME}.ge-codigo    >= INT(c-ini)         AND  
                                              {&TABLENAME}.ge-codigo    <= INT(c-fim)         AND  
                                              {&TABLENAME}.codigo-refer >= c-cod-refer-ini    AND
                                              {&TABLENAME}.codigo-refer <= c-cod-refer-fim    AND
                                             (({&TABLENAME}.cod-obsoleto = 1 and l-ativo)     OR
                                              ({&TABLENAME}.cod-obsoleto = 2 and l-auto )     OR
                                              ({&TABLENAME}.cod-obsoleto = 3 and l-todas)     OR
                                              ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                               no-lock by {&TABLENAME}.ge-codigo 
                                                        by {&tablename}.it-codigo {&v9indrep}.  
        end.
     if c-op-combo = "C¢digo Complementar" then 
        case i-compr-fabric:

           when 1 then 
              open query {&QUERYNAME} for each {&TABLENAME} where
                                               {&tablename}.it-codigo    >= c-it-codigo-ini    AND
                                               {&tablename}.it-codigo    <= c-it-codigo-fim    AND
                                               {&TABLENAME}.desc-item    >= c-desc-item-ini    AND
                                               {&TABLENAME}.desc-item    <= c-desc-item-fim    AND
                                               {&TABLENAME}.fm-codigo    >= c-fm-codigo-ini    AND
                                               {&TABLENAME}.fm-codigo    <= c-fm-codigo-fim    AND
                                               {&TABLENAME}.fm-cod-com   >= c-fm-cod-com-ini   AND
                                               {&TABLENAME}.fm-cod-com   <= c-fm-cod-com-fim   AND
                                               {&TABLENAME}.ge-codigo    >= i-ge-codigo-ini    AND
                                               {&TABLENAME}.ge-codigo    <= i-ge-codigo-fim    AND
                                               {&TABLENAME}.codigo-refer >= c-ini              AND  
                                               {&TABLENAME}.codigo-refer <= c-fim              AND  
                                               {&TABLENAME}.compr-fabric = 1                   AND 
                                              (({&TABLENAME}.cod-obsoleto = 1 and l-ativo)     OR
                                               ({&TABLENAME}.cod-obsoleto = 2 and l-auto )     OR
                                               ({&TABLENAME}.cod-obsoleto = 3 and l-todas)     OR
                                               ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                               no-lock by {&TABLENAME}.codigo-refer
                                                        by {&tablename}.it-codigo {&v9indrep}.   
           when 2 then 
              open query {&QUERYNAME} for each {&TABLENAME} where
                                            {&tablename}.it-codigo    >= c-it-codigo-ini    AND
                                            {&tablename}.it-codigo    <= c-it-codigo-fim    AND
                                            {&TABLENAME}.desc-item    >= c-desc-item-ini    AND
                                            {&TABLENAME}.desc-item    <= c-desc-item-fim    AND
                                            {&TABLENAME}.fm-codigo    >= c-fm-codigo-ini    AND
                                            {&TABLENAME}.fm-codigo    <= c-fm-codigo-fim    AND
                                            {&TABLENAME}.fm-cod-com   >= c-fm-cod-com-ini   AND
                                            {&TABLENAME}.fm-cod-com   <= c-fm-cod-com-fim   AND
                                            {&TABLENAME}.ge-codigo    >= i-ge-codigo-ini    AND
                                            {&TABLENAME}.ge-codigo    <= i-ge-codigo-fim    AND
                                            {&TABLENAME}.codigo-refer >= c-ini              AND  
                                            {&TABLENAME}.codigo-refer <= c-fim              AND  
                                            {&TABLENAME}.compr-fabric = 2                   AND 
                                           (({&TABLENAME}.cod-obsoleto = 1 and l-ativo)     OR
                                            ({&TABLENAME}.cod-obsoleto = 2 and l-auto )     OR
                                            ({&TABLENAME}.cod-obsoleto = 3 and l-todas)     OR
                                            ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                             no-lock by {&TABLENAME}.codigo-refer
                                                      by {&tablename}.it-codigo {&v9indrep}.                 
           when 3 then 
              open query {&QUERYNAME} for each {&TABLENAME} where
                                               {&tablename}.it-codigo    >= c-it-codigo-ini    AND
                                               {&tablename}.it-codigo    <= c-it-codigo-fim    AND
                                               {&TABLENAME}.desc-item    >= c-desc-item-ini    AND
                                               {&TABLENAME}.desc-item    <= c-desc-item-fim    AND
                                               {&TABLENAME}.fm-codigo    >= c-fm-codigo-ini    AND
                                               {&TABLENAME}.fm-codigo    <= c-fm-codigo-fim    AND
                                               {&TABLENAME}.fm-cod-com   >= c-fm-cod-com-ini   AND
                                               {&TABLENAME}.fm-cod-com   <= c-fm-cod-com-fim   AND
                                               {&TABLENAME}.ge-codigo    >= i-ge-codigo-ini    AND
                                               {&TABLENAME}.ge-codigo    <= i-ge-codigo-fim    AND
                                               {&TABLENAME}.codigo-refer >= c-ini              AND  
                                               {&TABLENAME}.codigo-refer <= c-fim              AND  
                                              (({&TABLENAME}.cod-obsoleto = 1 and l-ativo)     OR
                                               ({&TABLENAME}.cod-obsoleto = 2 and l-auto )     OR
                                               ({&TABLENAME}.cod-obsoleto = 3 and l-todas)     OR
                                               ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                               no-lock by {&TABLENAME}.codigo-refer
                                                        by {&tablename}.it-codigo {&v9indrep}.                             
        end.
     if c-op-combo = "FiltroItem":U then do:

        &if '{&ems_dbtype}' = 'Progress' &then
        
            if i-compr-fabric = 1 then 
                    open query {&QUERYNAME} for each {&TABLENAME} where 
                                          {&tablename}.it-codigo    >= c-it-codigo-ini    AND
                                          {&tablename}.it-codigo    <= c-it-codigo-fim    AND
                                          {&TABLENAME}.desc-item    >= c-ini              AND  
                                          {&TABLENAME}.desc-item    <= c-fim              AND  
                                          {&TABLENAME}.fm-codigo    >= c-fm-codigo-ini    AND
                                          {&TABLENAME}.fm-codigo    <= c-fm-codigo-fim    AND
                                          {&TABLENAME}.fm-cod-com   >= c-fm-cod-com-ini   AND
                                          {&TABLENAME}.fm-cod-com   <= c-fm-cod-com-fim   AND
                                          {&TABLENAME}.ge-codigo    >= i-ge-codigo-ini    AND
                                          {&TABLENAME}.ge-codigo    <= i-ge-codigo-fim    AND
                                          {&TABLENAME}.codigo-refer >= c-cod-refer-ini	  AND
                                          {&TABLENAME}.codigo-refer <= c-cod-refer-fim	  AND
										  {&TABLENAME}.desc-item MATCHES ("*" + c-palavra + "*")    AND
                                          {&TABLENAME}.compr-fabric = 1                   AND 
                                        (({&TABLENAME}.cod-obsoleto = 1 and l-ativo)      OR
                                         ({&TABLENAME}.cod-obsoleto = 2 and l-auto )      OR
                                         ({&TABLENAME}.cod-obsoleto = 3 and l-todas)      OR
                                         ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                           no-lock by {&TABLENAME}.desc-item
                                                    by {&tablename}.it-codigo {&v9indrep}.
            else if i-compr-fabric = 2 then 
                open query {&QUERYNAME} for each {&TABLENAME} where 
                                              {&tablename}.it-codigo    >= c-it-codigo-ini    AND
                                              {&tablename}.it-codigo    <= c-it-codigo-fim    AND
                                              {&TABLENAME}.desc-item    >= c-ini              AND  
                                              {&TABLENAME}.desc-item    <= c-fim              AND  
                                              {&TABLENAME}.fm-codigo    >= c-fm-codigo-ini    AND
                                              {&TABLENAME}.fm-codigo    <= c-fm-codigo-fim    AND
                                              {&TABLENAME}.fm-cod-com   >= c-fm-cod-com-ini   AND
                                              {&TABLENAME}.fm-cod-com   <= c-fm-cod-com-fim   AND
                                              {&TABLENAME}.ge-codigo    >= i-ge-codigo-ini    AND
                                              {&TABLENAME}.ge-codigo    <= i-ge-codigo-fim    AND
                                              {&TABLENAME}.codigo-refer >= c-cod-refer-ini    AND
                                              {&TABLENAME}.codigo-refer <= c-cod-refer-fim    AND
											  {&TABLENAME}.desc-item MATCHES ("*" + c-palavra + "*")	AND
                                              {&TABLENAME}.compr-fabric = 2                   AND 
                                            (({&TABLENAME}.cod-obsoleto = 1 and l-ativo)      OR
                                             ({&TABLENAME}.cod-obsoleto = 2 and l-auto )      OR
                                             ({&TABLENAME}.cod-obsoleto = 3 and l-todas)      OR
                                             ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                               no-lock by {&TABLENAME}.desc-item
                                                        by {&tablename}.it-codigo {&v9indrep}.
    
            else
                open query {&QUERYNAME} for each {&TABLENAME} where 
                                              {&tablename}.it-codigo    >= c-it-codigo-ini    AND
                                              {&tablename}.it-codigo    <= c-it-codigo-fim    AND
                                              {&TABLENAME}.desc-item    >= c-ini              AND  
                                              {&TABLENAME}.desc-item    <= c-fim              AND  
                                              {&TABLENAME}.fm-codigo    >= c-fm-codigo-ini    AND
                                              {&TABLENAME}.fm-codigo    <= c-fm-codigo-fim    AND
                                              {&TABLENAME}.fm-cod-com   >= c-fm-cod-com-ini   AND
                                              {&TABLENAME}.fm-cod-com   <= c-fm-cod-com-fim   AND
                                              {&TABLENAME}.ge-codigo    >= i-ge-codigo-ini    AND
                                              {&TABLENAME}.ge-codigo    <= i-ge-codigo-fim    AND
                                              {&TABLENAME}.codigo-refer >= c-cod-refer-ini    AND
                                              {&TABLENAME}.codigo-refer <= c-cod-refer-fim    AND
											  {&TABLENAME}.desc-item MATCHES ("*" + c-palavra + "*")	AND
                                            (({&TABLENAME}.cod-obsoleto = 1 and l-ativo)      OR
                                             ({&TABLENAME}.cod-obsoleto = 2 and l-auto )      OR
                                             ({&TABLENAME}.cod-obsoleto = 3 and l-todas)      OR
                                             ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                               no-lock by {&TABLENAME}.desc-item
                                                        by {&tablename}.it-codigo {&v9indrep}.
        &else
        
            if i-compr-fabric = 1 then 
                    open query {&QUERYNAME} for each {&TABLENAME} where 
                                          {&tablename}.it-codigo    >= c-it-codigo-ini    AND
                                          {&tablename}.it-codigo    <= c-it-codigo-fim    AND
                                          {&TABLENAME}.desc-item    >= c-ini              AND  
                                          {&TABLENAME}.desc-item    <= c-fim              AND  
                                          {&TABLENAME}.fm-codigo    >= c-fm-codigo-ini    AND
                                          {&TABLENAME}.fm-codigo    <= c-fm-codigo-fim    AND
                                          {&TABLENAME}.fm-cod-com   >= c-fm-cod-com-ini   AND
                                          {&TABLENAME}.fm-cod-com   <= c-fm-cod-com-fim   AND
                                          {&TABLENAME}.ge-codigo    >= i-ge-codigo-ini    AND
                                          {&TABLENAME}.ge-codigo    <= i-ge-codigo-fim    AND
                                          {&TABLENAME}.codigo-refer >= c-cod-refer-ini    AND
                                          {&TABLENAME}.codigo-refer <= c-cod-refer-fim    AND
                                          {&TABLENAME}.desc-item matches ("*" + c-palavra + "*") AND
                                          {&TABLENAME}.compr-fabric = 1                   AND 
                                        (({&TABLENAME}.cod-obsoleto = 1 and l-ativo)      OR
                                         ({&TABLENAME}.cod-obsoleto = 2 and l-auto )      OR
                                         ({&TABLENAME}.cod-obsoleto = 3 and l-todas)      OR
                                         ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                           no-lock by {&TABLENAME}.desc-item
                                                    by {&tablename}.it-codigo {&v9indrep}.
            else if i-compr-fabric = 2 then 
                open query {&QUERYNAME} for each {&TABLENAME} where 
                                              {&tablename}.it-codigo    >= c-it-codigo-ini    AND
                                              {&tablename}.it-codigo    <= c-it-codigo-fim    AND
                                              {&TABLENAME}.desc-item    >= c-ini              AND  
                                              {&TABLENAME}.desc-item    <= c-fim              AND  
                                              {&TABLENAME}.fm-codigo    >= c-fm-codigo-ini    AND
                                              {&TABLENAME}.fm-codigo    <= c-fm-codigo-fim    AND
                                              {&TABLENAME}.fm-cod-com   >= c-fm-cod-com-ini   AND
                                              {&TABLENAME}.fm-cod-com   <= c-fm-cod-com-fim   AND
                                              {&TABLENAME}.ge-codigo    >= i-ge-codigo-ini    AND
                                              {&TABLENAME}.ge-codigo    <= i-ge-codigo-fim    AND
                                              {&TABLENAME}.codigo-refer >= c-cod-refer-ini    AND
                                              {&TABLENAME}.codigo-refer <= c-cod-refer-fim    AND 
                                              {&TABLENAME}.desc-item matches ("*" + c-palavra + "*") AND
                                              {&TABLENAME}.compr-fabric = 2                   AND 
                                            (({&TABLENAME}.cod-obsoleto = 1 and l-ativo)      OR
                                             ({&TABLENAME}.cod-obsoleto = 2 and l-auto )      OR
                                             ({&TABLENAME}.cod-obsoleto = 3 and l-todas)      OR
                                             ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                               no-lock by {&TABLENAME}.desc-item
                                                        by {&tablename}.it-codigo {&v9indrep}.
    
            else
                open query {&QUERYNAME} for each {&TABLENAME} where 
                                              {&tablename}.it-codigo    >= c-it-codigo-ini    AND
                                              {&tablename}.it-codigo    <= c-it-codigo-fim    AND
                                              {&TABLENAME}.desc-item    >= c-ini              AND  
                                              {&TABLENAME}.desc-item    <= c-fim              AND  
                                              {&TABLENAME}.fm-codigo    >= c-fm-codigo-ini    AND
                                              {&TABLENAME}.fm-codigo    <= c-fm-codigo-fim    AND
                                              {&TABLENAME}.fm-cod-com   >= c-fm-cod-com-ini   AND
                                              {&TABLENAME}.fm-cod-com   <= c-fm-cod-com-fim   AND
                                              {&TABLENAME}.ge-codigo    >= i-ge-codigo-ini    AND
                                              {&TABLENAME}.ge-codigo    <= i-ge-codigo-fim    AND
                                              {&TABLENAME}.codigo-refer >= c-cod-refer-ini    AND
                                              {&TABLENAME}.codigo-refer <= c-cod-refer-fim    AND
                                              {&TABLENAME}.desc-item matches ("*" + c-palavra + "*") AND
                                            (({&TABLENAME}.cod-obsoleto = 1 and l-ativo)      OR
                                             ({&TABLENAME}.cod-obsoleto = 2 and l-auto )      OR
                                             ({&TABLENAME}.cod-obsoleto = 3 and l-todas)      OR
                                             ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                               no-lock by {&TABLENAME}.desc-item
                                                        by {&tablename}.it-codigo {&v9indrep}.

        &endif.
     end.
  end.
  else do:
   
     if c-op-combo = "Fam°lia" then 
        case i-compr-fabric:

           when 1 then 
              open query {&QUERYNAME} for each {&TABLENAME} where 
                                               {&tablename}.it-codigo    >= c-it-codigo-ini    AND
                                               {&tablename}.it-codigo    <= c-it-codigo-fim    AND
                                               {&TABLENAME}.desc-item    >= c-desc-item-ini    AND
                                               {&TABLENAME}.desc-item    <= c-desc-item-fim    AND
                                               {&TABLENAME}.fm-codigo    >= c-ini              AND  
                                               {&TABLENAME}.fm-codigo    <= c-fim              AND  
                                               {&TABLENAME}.fm-cod-com   >= c-fm-cod-com-ini   AND
                                               {&TABLENAME}.fm-cod-com   <= c-fm-cod-com-fim   AND
                                               {&TABLENAME}.ge-codigo    >= i-ge-codigo-ini    AND
                                               {&TABLENAME}.ge-codigo    <= i-ge-codigo-fim    AND
                                               {&TABLENAME}.codigo-refer >= c-cod-refer-ini    AND
                                               {&TABLENAME}.codigo-refer <= c-cod-refer-fim    AND
                                               {&TABLENAME}.compr-fabric = 1                   AND 
                                              (({&TABLENAME}.cod-obsoleto = 1 and l-ativo)     OR
                                               ({&TABLENAME}.cod-obsoleto = 2 and l-auto )     OR
                                               ({&TABLENAME}.cod-obsoleto = 3 and l-todas)     OR
                                               ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                               no-lock by {&TABLENAME}.fm-codigo 
                                                        by {&TABLENAME}.desc-item
                                                         by {&tablename}.it-codigo {&v9indrep}.  
           when 2 then 
              open query {&QUERYNAME} for each {&TABLENAME} where 
                                            {&tablename}.it-codigo    >= c-it-codigo-ini    AND
                                            {&tablename}.it-codigo    <= c-it-codigo-fim    AND
                                            {&TABLENAME}.desc-item    >= c-desc-item-ini    AND
                                            {&TABLENAME}.desc-item    <= c-desc-item-fim    AND
                                            {&TABLENAME}.fm-codigo    >= c-ini              AND  
                                            {&TABLENAME}.fm-codigo    <= c-fim              AND  
                                            {&TABLENAME}.fm-cod-com   >= c-fm-cod-com-ini   AND
                                            {&TABLENAME}.fm-cod-com   <= c-fm-cod-com-fim   AND
                                            {&TABLENAME}.ge-codigo    >= i-ge-codigo-ini    AND
                                            {&TABLENAME}.ge-codigo    <= i-ge-codigo-fim    AND
                                            {&TABLENAME}.codigo-refer >= c-cod-refer-ini    AND
                                            {&TABLENAME}.codigo-refer <= c-cod-refer-fim    AND
                                            {&TABLENAME}.compr-fabric = 2                   AND 
                                           (({&TABLENAME}.cod-obsoleto = 1 and l-ativo)     OR
                                            ({&TABLENAME}.cod-obsoleto = 2 and l-auto )     OR
                                            ({&TABLENAME}.cod-obsoleto = 3 and l-todas)     OR
                                            ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                            no-lock by {&TABLENAME}.fm-codigo 
                                                     by {&TABLENAME}.desc-item
                                                       by {&tablename}.it-codigo {&v9indrep}.  
           when 3 then 
              open query {&QUERYNAME} for each {&TABLENAME} where 
                                              {&tablename}.it-codigo    >= c-it-codigo-ini    AND
                                              {&tablename}.it-codigo    <= c-it-codigo-fim    AND
                                              {&TABLENAME}.desc-item    >= c-desc-item-ini    AND
                                              {&TABLENAME}.desc-item    <= c-desc-item-fim    AND
                                              {&TABLENAME}.fm-codigo    >= c-ini              AND  
                                              {&TABLENAME}.fm-codigo    <= c-fim              AND  
                                              {&TABLENAME}.fm-cod-com   >= c-fm-cod-com-ini   AND
                                              {&TABLENAME}.fm-cod-com   <= c-fm-cod-com-fim   AND
                                              {&TABLENAME}.ge-codigo    >= i-ge-codigo-ini    AND
                                              {&TABLENAME}.ge-codigo    <= i-ge-codigo-fim    AND
                                              {&TABLENAME}.codigo-refer >= c-cod-refer-ini    AND
                                              {&TABLENAME}.codigo-refer <= c-cod-refer-fim    AND
                                             (({&TABLENAME}.cod-obsoleto = 1 and l-ativo)     OR
                                              ({&TABLENAME}.cod-obsoleto = 2 and l-auto )     OR
                                              ({&TABLENAME}.cod-obsoleto = 3 and l-todas)     OR
                                              ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                              no-lock by {&TABLENAME}.fm-codigo 
                                                       by {&TABLENAME}.desc-item
                                                        by {&tablename}.it-codigo {&v9indrep}.  
        end.
     if c-op-combo = "Fam°lia Comercial" then
        case i-compr-fabric:

           when 1 then 
              open query {&QUERYNAME} for each {&TABLENAME} where                              
                                               {&tablename}.it-codigo    >= c-it-codigo-ini    AND
                                               {&tablename}.it-codigo    <= c-it-codigo-fim    AND
                                               {&TABLENAME}.desc-item    >= c-desc-item-ini    AND
                                               {&TABLENAME}.desc-item    <= c-desc-item-fim    AND
                                               {&TABLENAME}.fm-codigo    >= c-fm-codigo-ini    AND
                                               {&TABLENAME}.fm-codigo    <= c-fm-codigo-fim    AND
                                               {&TABLENAME}.fm-cod-com   >= c-ini              AND  
                                               {&TABLENAME}.fm-cod-com   <= c-fim              AND  
                                               {&TABLENAME}.ge-codigo    >= i-ge-codigo-ini    AND
                                               {&TABLENAME}.ge-codigo    <= i-ge-codigo-fim    AND
                                               {&TABLENAME}.codigo-refer >= c-cod-refer-ini    AND
                                               {&TABLENAME}.codigo-refer <= c-cod-refer-fim    AND
                                               {&TABLENAME}.compr-fabric = 1                   AND 
                                              (({&TABLENAME}.cod-obsoleto = 1 and l-ativo)     OR
                                               ({&TABLENAME}.cod-obsoleto = 2 and l-auto )     OR
                                               ({&TABLENAME}.cod-obsoleto = 3 and l-todas)     OR
                                               ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                               no-lock by {&TABLENAME}.fm-cod-com 
                                                        by {&TABLENAME}.desc-item 
                                                         by {&tablename}.it-codigo {&v9indrep}. 

           when 2 then 
              open query {&QUERYNAME} for each {&TABLENAME} where 
                                            {&tablename}.it-codigo    >= c-it-codigo-ini    AND
                                            {&tablename}.it-codigo    <= c-it-codigo-fim    AND
                                            {&TABLENAME}.desc-item    >= c-desc-item-ini    AND
                                            {&TABLENAME}.desc-item    <= c-desc-item-fim    AND
                                            {&TABLENAME}.fm-codigo    >= c-fm-codigo-ini    AND
                                            {&TABLENAME}.fm-codigo    <= c-fm-codigo-fim    AND
                                            {&TABLENAME}.fm-cod-com   >= c-ini              AND  
                                            {&TABLENAME}.fm-cod-com   <= c-fim              AND  
                                            {&TABLENAME}.ge-codigo    >= i-ge-codigo-ini    AND
                                            {&TABLENAME}.ge-codigo    <= i-ge-codigo-fim    AND
                                            {&TABLENAME}.codigo-refer >= c-cod-refer-ini    AND
                                            {&TABLENAME}.codigo-refer <= c-cod-refer-fim    AND
                                            {&TABLENAME}.compr-fabric = 2                   AND 
                                           (({&TABLENAME}.cod-obsoleto = 1 and l-ativo)     OR
                                            ({&TABLENAME}.cod-obsoleto = 2 and l-auto )     OR
                                            ({&TABLENAME}.cod-obsoleto = 3 and l-todas)     OR
                                            ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                             no-lock by {&TABLENAME}.fm-cod-com 
                                                      by {&TABLENAME}.desc-item 
                                                       by {&tablename}.it-codigo {&v9indrep}. 
           when 3 then 
              open query {&QUERYNAME} for each {&TABLENAME} where 
                                              {&tablename}.it-codigo    >= c-it-codigo-ini    AND
                                              {&tablename}.it-codigo    <= c-it-codigo-fim    AND
                                              {&TABLENAME}.desc-item    >= c-desc-item-ini    AND
                                              {&TABLENAME}.desc-item    <= c-desc-item-fim    AND
                                              {&TABLENAME}.fm-codigo    >= c-fm-codigo-ini    AND
                                              {&TABLENAME}.fm-codigo    <= c-fm-codigo-fim    AND
                                              {&TABLENAME}.fm-cod-com   >= c-ini              AND  
                                              {&TABLENAME}.fm-cod-com   <= c-fim              AND  
                                              {&TABLENAME}.ge-codigo    >= i-ge-codigo-ini    AND
                                              {&TABLENAME}.ge-codigo    <= i-ge-codigo-fim    AND
                                              {&TABLENAME}.codigo-refer >= c-cod-refer-ini    AND
                                              {&TABLENAME}.codigo-refer <= c-cod-refer-fim    AND
                                             (({&TABLENAME}.cod-obsoleto = 1 and l-ativo)     OR
                                              ({&TABLENAME}.cod-obsoleto = 2 and l-auto )     OR
                                              ({&TABLENAME}.cod-obsoleto = 3 and l-todas)     OR
                                              ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                              no-lock by {&TABLENAME}.fm-cod-com 
                                                       by {&TABLENAME}.desc-item 
                                                        by {&tablename}.it-codigo {&v9indrep}. 
        end.
     if c-op-combo = "Grupo Estoque" then 
        case i-compr-fabric:

           when 1 then 
              open query {&QUERYNAME} for each {&TABLENAME} where 
                                               {&tablename}.it-codigo    >= c-it-codigo-ini    AND
                                               {&tablename}.it-codigo    <= c-it-codigo-fim    AND
                                               {&TABLENAME}.desc-item    >= c-desc-item-ini    AND
                                               {&TABLENAME}.desc-item    <= c-desc-item-fim    AND
                                               {&TABLENAME}.fm-codigo    >= c-fm-codigo-ini    AND
                                               {&TABLENAME}.fm-codigo    <= c-fm-codigo-fim    AND
                                               {&TABLENAME}.fm-cod-com   >= c-fm-cod-com-ini   AND
                                               {&TABLENAME}.fm-cod-com   <= c-fm-cod-com-fim   AND
                                               {&TABLENAME}.ge-codigo    >= INT(c-ini)         AND   
                                               {&TABLENAME}.ge-codigo    <= INT(c-fim)         AND   
                                               {&TABLENAME}.codigo-refer >= c-cod-refer-ini    AND
                                               {&TABLENAME}.codigo-refer <= c-cod-refer-fim    AND
                                               {&TABLENAME}.compr-fabric = 1                   AND 
                                              (({&TABLENAME}.cod-obsoleto = 1 and l-ativo)     OR
                                               ({&TABLENAME}.cod-obsoleto = 2 and l-auto )     OR
                                               ({&TABLENAME}.cod-obsoleto = 3 and l-todas)     OR
                                               ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                               no-lock by {&TABLENAME}.ge-codigo 
                                                        by {&TABLENAME}.desc-item 
                                                         by {&tablename}.it-codigo {&v9indrep}.  
              
           when 2 then 
              open query {&QUERYNAME} for each {&TABLENAME} where 
                                            {&tablename}.it-codigo    >= c-it-codigo-ini    AND
                                            {&tablename}.it-codigo    <= c-it-codigo-fim    AND
                                            {&TABLENAME}.desc-item    >= c-desc-item-ini    AND
                                            {&TABLENAME}.desc-item    <= c-desc-item-fim    AND
                                            {&TABLENAME}.fm-codigo    >= c-fm-codigo-ini    AND
                                            {&TABLENAME}.fm-codigo    <= c-fm-codigo-fim    AND
                                            {&TABLENAME}.fm-cod-com   >= c-fm-cod-com-ini   AND
                                            {&TABLENAME}.fm-cod-com   <= c-fm-cod-com-fim   AND
                                            {&TABLENAME}.ge-codigo    >= INT(c-ini)         AND   
                                            {&TABLENAME}.ge-codigo    <= INT(c-fim)         AND   
                                            {&TABLENAME}.codigo-refer >= c-cod-refer-ini    AND
                                            {&TABLENAME}.codigo-refer <= c-cod-refer-fim    AND
                                            {&TABLENAME}.compr-fabric = 2                   AND 
                                           (({&TABLENAME}.cod-obsoleto = 1 and l-ativo)     OR
                                            ({&TABLENAME}.cod-obsoleto = 2 and l-auto )     OR
                                            ({&TABLENAME}.cod-obsoleto = 3 and l-todas)     OR
                                            ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                              no-lock by {&TABLENAME}.ge-codigo 
                                                       by {&TABLENAME}.desc-item 
                                                        by {&tablename}.it-codigo {&v9indrep}.  
           when 3 then 
              open query {&QUERYNAME} for each {&TABLENAME} where 
                                              {&tablename}.it-codigo    >= c-it-codigo-ini    AND
                                              {&tablename}.it-codigo    <= c-it-codigo-fim    AND
                                              {&TABLENAME}.desc-item    >= c-desc-item-ini    AND
                                              {&TABLENAME}.desc-item    <= c-desc-item-fim    AND
                                              {&TABLENAME}.fm-codigo    >= c-fm-codigo-ini    AND
                                              {&TABLENAME}.fm-codigo    <= c-fm-codigo-fim    AND
                                              {&TABLENAME}.fm-cod-com   >= c-fm-cod-com-ini   AND
                                              {&TABLENAME}.fm-cod-com   <= c-fm-cod-com-fim   AND
                                              {&TABLENAME}.ge-codigo    >= INT(c-ini)         AND   
                                              {&TABLENAME}.ge-codigo    <= INT(c-fim)         AND   
                                              {&TABLENAME}.codigo-refer >= c-cod-refer-ini    AND
                                              {&TABLENAME}.codigo-refer <= c-cod-refer-fim    AND
                                             (({&TABLENAME}.cod-obsoleto = 1 and l-ativo)     OR
                                              ({&TABLENAME}.cod-obsoleto = 2 and l-auto )     OR
                                              ({&TABLENAME}.cod-obsoleto = 3 and l-todas)     OR
                                              ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                               no-lock by {&TABLENAME}.ge-codigo 
                                                        by {&TABLENAME}.desc-item 
                                                         by {&tablename}.it-codigo {&v9indrep}.  
        end.
     if c-op-combo = "C¢digo Complementar" then 
        case i-compr-fabric:

           when 1 then 
              open query {&QUERYNAME} for each {&TABLENAME} where 
                                               {&tablename}.it-codigo    >= c-it-codigo-ini    AND
                                               {&tablename}.it-codigo    <= c-it-codigo-fim    AND
                                               {&TABLENAME}.desc-item    >= c-desc-item-ini    AND
                                               {&TABLENAME}.desc-item    <= c-desc-item-fim    AND
                                               {&TABLENAME}.fm-codigo    >= c-fm-codigo-ini    AND
                                               {&TABLENAME}.fm-codigo    <= c-fm-codigo-fim    AND
                                               {&TABLENAME}.fm-cod-com   >= c-fm-cod-com-ini   AND
                                               {&TABLENAME}.fm-cod-com   <= c-fm-cod-com-fim   AND
                                               {&TABLENAME}.ge-codigo    >= i-ge-codigo-ini    AND
                                               {&TABLENAME}.ge-codigo    <= i-ge-codigo-fim    AND
                                               {&TABLENAME}.codigo-refer >= c-ini              AND    
                                               {&TABLENAME}.codigo-refer <= c-fim              AND    
                                               {&TABLENAME}.compr-fabric = 1                   AND 
                                              (({&TABLENAME}.cod-obsoleto = 1 and l-ativo)     OR
                                               ({&TABLENAME}.cod-obsoleto = 2 and l-auto )     OR
                                               ({&TABLENAME}.cod-obsoleto = 3 and l-todas)     OR
                                               ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                               no-lock by {&TABLENAME}.codigo-refer
                                                        by {&TABLENAME}.desc-item 
                                                         by {&tablename}.it-codigo {&v9indrep}.   
           when 2 then 
              open query {&QUERYNAME} for each {&TABLENAME} where 
                                            {&tablename}.it-codigo    >= c-it-codigo-ini    AND
                                            {&tablename}.it-codigo    <= c-it-codigo-fim    AND
                                            {&TABLENAME}.desc-item    >= c-desc-item-ini    AND
                                            {&TABLENAME}.desc-item    <= c-desc-item-fim    AND
                                            {&TABLENAME}.fm-codigo    >= c-fm-codigo-ini    AND
                                            {&TABLENAME}.fm-codigo    <= c-fm-codigo-fim    AND
                                            {&TABLENAME}.fm-cod-com   >= c-fm-cod-com-ini   AND
                                            {&TABLENAME}.fm-cod-com   <= c-fm-cod-com-fim   AND
                                            {&TABLENAME}.ge-codigo    >= i-ge-codigo-ini    AND
                                            {&TABLENAME}.ge-codigo    <= i-ge-codigo-fim    AND
                                            {&TABLENAME}.codigo-refer >= c-ini              AND    
                                            {&TABLENAME}.codigo-refer <= c-fim              AND    
                                            {&TABLENAME}.compr-fabric = 2                   AND 
                                           (({&TABLENAME}.cod-obsoleto = 1 and l-ativo)     OR
                                            ({&TABLENAME}.cod-obsoleto = 2 and l-auto )     OR
                                            ({&TABLENAME}.cod-obsoleto = 3 and l-todas)     OR
                                            ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                             no-lock by {&TABLENAME}.codigo-refer
                                                      by {&TABLENAME}.desc-item 
                                                       by {&tablename}.it-codigo {&v9indrep}.                 
           when 3 then 
              open query {&QUERYNAME} for each {&TABLENAME} where 
                                              {&tablename}.it-codigo    >= c-it-codigo-ini    AND
                                              {&tablename}.it-codigo    <= c-it-codigo-fim    AND
                                              {&TABLENAME}.desc-item    >= c-desc-item-ini    AND
                                              {&TABLENAME}.desc-item    <= c-desc-item-fim    AND
                                              {&TABLENAME}.fm-codigo    >= c-fm-codigo-ini    AND
                                              {&TABLENAME}.fm-codigo    <= c-fm-codigo-fim    AND
                                              {&TABLENAME}.fm-cod-com   >= c-fm-cod-com-ini   AND
                                              {&TABLENAME}.fm-cod-com   <= c-fm-cod-com-fim   AND
                                              {&TABLENAME}.ge-codigo    >= i-ge-codigo-ini    AND
                                              {&TABLENAME}.ge-codigo    <= i-ge-codigo-fim    AND
                                              {&TABLENAME}.codigo-refer >= c-ini              AND    
                                              {&TABLENAME}.codigo-refer <= c-fim              AND    
                                             (({&TABLENAME}.cod-obsoleto = 1 and l-ativo)     OR
                                              ({&TABLENAME}.cod-obsoleto = 2 and l-auto )     OR
                                              ({&TABLENAME}.cod-obsoleto = 3 and l-todas)     OR
                                              ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                              no-lock by {&TABLENAME}.codigo-refer
                                                       by {&TABLENAME}.desc-item  
                                                        by {&tablename}.it-codigo {&v9indrep}.                             
        end.
  end.
end.

else do:
    /* A procedure a seguir foi criada para solucionar o problema de estouro do limite de 63Kb da procedure original,
       acusado quando da compilaá∆o do programa no EMS 2.05*/
    RUN openQueryZoom-aux.
end.

   RETURN "OK":U.      
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryZoom-aux DBOProgram 
PROCEDURE openQueryZoom-aux :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  if i-op-radio = 1 then do :    
     if c-op-combo = "Item" then     
        case i-compr-fabric:

           when 1 then 
                  open query {&QUERYNAME} for each {&TABLENAME} where
                                                   {&tablename}.it-codigo    >= c-ini          AND
                                                   {&tablename}.it-codigo    <= c-fim          AND
                                                   {&TABLENAME}.compr-fabric = 1               AND 
                                                  (({&TABLENAME}.cod-obsoleto = 1 and l-ativo) OR
                                                   ({&TABLENAME}.cod-obsoleto = 2 and l-auto ) OR
                                                   ({&TABLENAME}.cod-obsoleto = 3 and l-todas) OR
                                                   ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                                    no-lock by {&tablename}.it-codigo {&v9indrep}. 
           when 2 then 
                  open query {&QUERYNAME} for each {&TABLENAME} where 
                                                   {&tablename}.it-codigo    >= c-ini          AND
                                                   {&tablename}.it-codigo    <= c-fim          AND       
                                                   {&TABLENAME}.compr-fabric = 2               AND       
                                                  (({&TABLENAME}.cod-obsoleto = 1 and l-ativo) OR        
                                                   ({&TABLENAME}.cod-obsoleto = 2 and l-auto ) OR        
                                                   ({&TABLENAME}.cod-obsoleto = 3 and l-todas) OR        
                                                   ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))           
                                                    no-lock by {&tablename}.it-codigo {&v9indrep}. 
           when 3 then 
                    open query {&QUERYNAME} for each {&TABLENAME} where 
                                                     {&tablename}.it-codigo    >= c-ini          AND
                                                     {&tablename}.it-codigo    <= c-fim          AND
                                                    (({&TABLENAME}.cod-obsoleto = 1 and l-ativo) OR
                                                     ({&TABLENAME}.cod-obsoleto = 2 and l-auto ) OR
                                                     ({&TABLENAME}.cod-obsoleto = 3 and l-todas) OR
                                                     ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                                      no-lock by {&tablename}.it-codigo {&v9indrep}. 
        end.
     if c-op-combo = "Descriá∆o" then 
        case i-compr-fabric:

           when 1 then 
                  open query {&QUERYNAME} for each {&TABLENAME} where
                                                   {&TABLENAME}.desc-item    >= c-ini         AND
                                                   {&TABLENAME}.desc-item    <= c-fim          AND
                                                   {&TABLENAME}.compr-fabric = 1               AND 
                                                  (({&TABLENAME}.cod-obsoleto = 1 and l-ativo) OR
                                                   ({&TABLENAME}.cod-obsoleto = 2 and l-auto ) OR
                                                   ({&TABLENAME}.cod-obsoleto = 3 and l-todas) OR
                                                   ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                                   no-lock by {&TABLENAME}.desc-item
                                                            by {&tablename}.it-codigo {&v9indrep}.

           when 2 then 
               open query {&QUERYNAME} for each {&TABLENAME} where
                                                {&TABLENAME}.desc-item    >= c-ini          AND
                                                {&TABLENAME}.desc-item    <= c-fim          AND
                                                {&TABLENAME}.compr-fabric = 2               AND 
                                               (({&TABLENAME}.cod-obsoleto = 1 and l-ativo) OR
                                                ({&TABLENAME}.cod-obsoleto = 2 and l-auto ) OR
                                                ({&TABLENAME}.cod-obsoleto = 3 and l-todas) OR
                                                ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                                no-lock by {&TABLENAME}.desc-item
                                                         by {&tablename}.it-codigo {&v9indrep}.

           when 3 then 
                 open query {&QUERYNAME} for each {&TABLENAME} where
                                                  {&TABLENAME}.desc-item    >= c-ini          AND
                                                  {&TABLENAME}.desc-item    <= c-fim          AND
                                                 (({&TABLENAME}.cod-obsoleto = 1 and l-ativo) OR
                                                  ({&TABLENAME}.cod-obsoleto = 2 and l-auto ) OR
                                                  ({&TABLENAME}.cod-obsoleto = 3 and l-todas) OR
                                                  ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                                  no-lock by {&TABLENAME}.desc-item
                                                           by {&tablename}.it-codigo {&v9indrep}.
        end.
     if c-op-combo = "Fam°lia" then  
        case i-compr-fabric:

           when 1 then 
                  open query {&QUERYNAME} for each {&TABLENAME} where 
                                                   {&TABLENAME}.fm-codigo    >= c-ini          AND
                                                   {&TABLENAME}.fm-codigo    <= c-fim          AND
                                                   {&TABLENAME}.compr-fabric = 1               AND 
                                                  (({&TABLENAME}.cod-obsoleto = 1 and l-ativo) OR
                                                   ({&TABLENAME}.cod-obsoleto = 2 and l-auto ) OR
                                                   ({&TABLENAME}.cod-obsoleto = 3 and l-todas) OR
                                                   ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                                   no-lock by {&TABLENAME}.fm-codigo 
                                                            by {&tablename}.it-codigo {&v9indrep}.  
           when 2 then 
                open query {&QUERYNAME} for each {&TABLENAME} where 
                                                {&TABLENAME}.fm-codigo    >= c-ini          AND
                                                {&TABLENAME}.fm-codigo    <= c-fim          AND
                                                {&TABLENAME}.compr-fabric = 2               AND 
                                               (({&TABLENAME}.cod-obsoleto = 1 and l-ativo) OR
                                                ({&TABLENAME}.cod-obsoleto = 2 and l-auto ) OR
                                                ({&TABLENAME}.cod-obsoleto = 3 and l-todas) OR
                                                ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                                no-lock by {&TABLENAME}.fm-codigo 
                                                          by {&tablename}.it-codigo {&v9indrep}. 
           when 3 then 
                 open query {&QUERYNAME} for each {&TABLENAME} where 
                                                  {&TABLENAME}.fm-codigo    >= c-ini          AND
                                                  {&TABLENAME}.fm-codigo    <= c-fim          AND
                                                 (({&TABLENAME}.cod-obsoleto = 1 and l-ativo) OR
                                                  ({&TABLENAME}.cod-obsoleto = 2 and l-auto ) OR
                                                  ({&TABLENAME}.cod-obsoleto = 3 and l-todas) OR
                                                  ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                                  no-lock by {&TABLENAME}.fm-codigo 
                                                           by {&tablename}.it-codigo {&v9indrep}. 
        end.
     if c-op-combo = "Fam°lia Comercial" then 
        case i-compr-fabric:

           when 1 then 
                  open query {&QUERYNAME} for each {&TABLENAME} where                              
                                                   {&TABLENAME}.fm-cod-com   >= c-ini          AND
                                                   {&TABLENAME}.fm-cod-com   <= c-fim          AND
                                                   {&TABLENAME}.compr-fabric = 1               AND 
                                                  (({&TABLENAME}.cod-obsoleto = 1 and l-ativo) OR
                                                   ({&TABLENAME}.cod-obsoleto = 2 and l-auto ) OR
                                                   ({&TABLENAME}.cod-obsoleto = 3 and l-todas) OR
                                                   ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                                   no-lock by {&TABLENAME}.fm-cod-com 
                                                            by {&tablename}.it-codigo {&v9indrep}. 

           when 2 then 
               open query {&QUERYNAME} for each {&TABLENAME} where 
                                                {&TABLENAME}.fm-cod-com   >= c-ini          AND
                                                {&TABLENAME}.fm-cod-com   <= c-fim          AND
                                                {&TABLENAME}.compr-fabric = 2               AND 
                                               (({&TABLENAME}.cod-obsoleto = 1 and l-ativo) OR
                                                ({&TABLENAME}.cod-obsoleto = 2 and l-auto ) OR
                                                ({&TABLENAME}.cod-obsoleto = 3 and l-todas) OR
                                                ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                                 no-lock by {&TABLENAME}.fm-cod-com 
                                                           by {&tablename}.it-codigo {&v9indrep}. 
           when 3 then 
                 open query {&QUERYNAME} for each {&TABLENAME} where 
                                                  {&TABLENAME}.fm-cod-com   >= c-ini          AND
                                                  {&TABLENAME}.fm-cod-com   <= c-fim          AND
                                                 (({&TABLENAME}.cod-obsoleto = 1 and l-ativo) OR
                                                  ({&TABLENAME}.cod-obsoleto = 2 and l-auto ) OR
                                                  ({&TABLENAME}.cod-obsoleto = 3 and l-todas) OR
                                                  ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                                  no-lock by {&TABLENAME}.fm-cod-com 
                                                           by {&tablename}.it-codigo {&v9indrep}.
        end.
     if c-op-combo = "Grupo Estoque" then  
        case i-compr-fabric:

           when 1 then 
                  open query {&QUERYNAME} for each {&TABLENAME} where 
                                                   {&TABLENAME}.ge-codigo    >= int(c-ini)     AND
                                                   {&TABLENAME}.ge-codigo    <= int(c-fim)     AND
                                                   {&TABLENAME}.compr-fabric = 1               AND 
                                                  (({&TABLENAME}.cod-obsoleto = 1 and l-ativo) OR
                                                   ({&TABLENAME}.cod-obsoleto = 2 and l-auto ) OR
                                                   ({&TABLENAME}.cod-obsoleto = 3 and l-todas) OR
                                                   ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                                   no-lock by {&TABLENAME}.ge-codigo 
                                                            by {&tablename}.it-codigo {&v9indrep}.  

           when 2 then 
                  open query {&QUERYNAME} for each {&TABLENAME} where 
                                                   {&TABLENAME}.ge-codigo    >= int(c-ini)     AND
                                                   {&TABLENAME}.ge-codigo    <= int(c-fim)     AND
                                                   {&TABLENAME}.compr-fabric = 2               AND 
                                                 (({&TABLENAME}.cod-obsoleto = 1 and l-ativo) OR
                                                  ({&TABLENAME}.cod-obsoleto = 2 and l-auto ) OR
                                                  ({&TABLENAME}.cod-obsoleto = 3 and l-todas) OR
                                                  ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                                   no-lock by {&TABLENAME}.ge-codigo 
                                                            by {&tablename}.it-codigo {&v9indrep}.  
           when 3 then 
                 open query {&QUERYNAME} for each {&TABLENAME} where 
                                                  {&TABLENAME}.ge-codigo    >= int(c-ini)     AND
                                                  {&TABLENAME}.ge-codigo    <= int(c-fim)     AND
                                                 (({&TABLENAME}.cod-obsoleto = 1 and l-ativo) OR
                                                  ({&TABLENAME}.cod-obsoleto = 2 and l-auto ) OR
                                                  ({&TABLENAME}.cod-obsoleto = 3 and l-todas) OR
                                                  ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                                   no-lock by {&TABLENAME}.ge-codigo 
                                                            by {&tablename}.it-codigo {&v9indrep}.  
        end.
     if c-op-combo = "C¢digo Complementar" then 
        case i-compr-fabric:

           when 1 then 
                 open query {&QUERYNAME} for each {&TABLENAME} use-index complementar
                                            where {&TABLENAME}.codigo-refer >= c-ini          AND
                                                  {&TABLENAME}.codigo-refer <= c-fim          AND
                                                  {&TABLENAME}.compr-fabric = 1               AND 
                                                 (({&TABLENAME}.cod-obsoleto = 1 and l-ativo) OR
                                                  ({&TABLENAME}.cod-obsoleto = 2 and l-auto ) OR
                                                  ({&TABLENAME}.cod-obsoleto = 3 and l-todas) OR
                                                  ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                                  no-lock by {&TABLENAME}.codigo-refer
                                                           by {&tablename}.it-codigo {&v9indrep}.   
           when 2 then 
                 open query {&QUERYNAME} for each {&TABLENAME} use-index complementar
                                            where {&TABLENAME}.codigo-refer >= c-ini          AND
                                                  {&TABLENAME}.codigo-refer <= c-fim          AND
                                                  {&TABLENAME}.compr-fabric = 2               AND 
                                                 (({&TABLENAME}.cod-obsoleto = 1 and l-ativo) OR
                                                  ({&TABLENAME}.cod-obsoleto = 2 and l-auto ) OR
                                                  ({&TABLENAME}.cod-obsoleto = 3 and l-todas) OR
                                                  ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                                   no-lock by {&TABLENAME}.codigo-refer
                                                             by {&tablename}.it-codigo {&v9indrep}.                 
                   
           when 3 then 
                 open query {&QUERYNAME} for each {&TABLENAME} use-index complementar
                                            where {&TABLENAME}.codigo-refer >= c-ini          AND
                                                  {&TABLENAME}.codigo-refer <= c-fim          AND
                                                 (({&TABLENAME}.cod-obsoleto = 1 and l-ativo) OR
                                                  ({&TABLENAME}.cod-obsoleto = 2 and l-auto ) OR
                                                  ({&TABLENAME}.cod-obsoleto = 3 and l-todas) OR
                                                  ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                                  no-lock by {&TABLENAME}.codigo-refer          
                                                           by {&tablename}.it-codigo {&v9indrep}.                             
        end.
     if c-op-combo = "FiltroItem":U then do:
        &if '{&ems_dbtype}' = 'Progress' &then
    
            if i-compr-fabric = 1 then 
                    open query {&QUERYNAME} for each {&TABLENAME} where 
                                                  {&TABLENAME}.desc-item >= c-ini            AND
                                                  {&TABLENAME}.desc-item <= c-fim            AND
												  {&TABLENAME}.desc-item MATCHES ("*" + c-palavra + "*")	AND
                                                  {&TABLENAME}.compr-fabric = 1              AND 
                                                (({&TABLENAME}.cod-obsoleto = 1 and l-ativo) OR
                                                 ({&TABLENAME}.cod-obsoleto = 2 and l-auto ) OR
                                                 ({&TABLENAME}.cod-obsoleto = 3 and l-todas) OR
                                                 ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                                   no-lock by {&TABLENAME}.desc-item
                                                            by {&tablename}.it-codigo {&v9indrep}.
            else if i-compr-fabric = 2 then 
                    open query {&QUERYNAME} for each {&TABLENAME} where 
                                                  {&TABLENAME}.desc-item >= c-ini            AND
                                                  {&TABLENAME}.desc-item <= c-fim            AND   
												  {&TABLENAME}.desc-item MATCHES ("*" + c-palavra + "*")	AND
                                                  {&TABLENAME}.compr-fabric = 2              AND 
                                                (({&TABLENAME}.cod-obsoleto = 1 and l-ativo) OR
                                                 ({&TABLENAME}.cod-obsoleto = 2 and l-auto ) OR
                                                 ({&TABLENAME}.cod-obsoleto = 3 and l-todas) OR
                                                 ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                                   no-lock by {&TABLENAME}.desc-item
                                                            by {&tablename}.it-codigo {&v9indrep}.
    
            else
                    open query {&QUERYNAME} for each {&TABLENAME} where 
                                                  {&TABLENAME}.desc-item >= c-ini            AND
                                                  {&TABLENAME}.desc-item <= c-fim            AND
												  {&TABLENAME}.desc-item MATCHES ("*" + c-palavra + "*")	AND
                                                (({&TABLENAME}.cod-obsoleto = 1 and l-ativo) OR
                                                 ({&TABLENAME}.cod-obsoleto = 2 and l-auto ) OR
                                                 ({&TABLENAME}.cod-obsoleto = 3 and l-todas) OR
                                                 ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                                   no-lock by {&TABLENAME}.desc-item
                                                            by {&tablename}.it-codigo {&v9indrep}.
        &else
            if i-compr-fabric = 1 then 
                        open query {&QUERYNAME} for each {&TABLENAME} where 
                                                      {&TABLENAME}.desc-item >= c-ini            AND
                                                      {&TABLENAME}.desc-item <= c-fim            AND   
                                                      {&TABLENAME}.desc-item matches ("*" + c-palavra + "*") AND
                                                      {&TABLENAME}.compr-fabric = 1              AND 
                                                    (({&TABLENAME}.cod-obsoleto = 1 and l-ativo) OR
                                                     ({&TABLENAME}.cod-obsoleto = 2 and l-auto ) OR
                                                     ({&TABLENAME}.cod-obsoleto = 3 and l-todas) OR
                                                     ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                                       no-lock by {&TABLENAME}.desc-item
                                                                by {&tablename}.it-codigo {&v9indrep}.
                else if i-compr-fabric = 2 then 
                        open query {&QUERYNAME} for each {&TABLENAME} where 
                                                      {&TABLENAME}.desc-item >= c-ini            AND
                                                      {&TABLENAME}.desc-item <= c-fim            AND   
                                                      {&TABLENAME}.desc-item matches ("*" + c-palavra + "*") AND
                                                      {&TABLENAME}.compr-fabric = 2              AND 
                                                    (({&TABLENAME}.cod-obsoleto = 1 and l-ativo) OR
                                                     ({&TABLENAME}.cod-obsoleto = 2 and l-auto ) OR
                                                     ({&TABLENAME}.cod-obsoleto = 3 and l-todas) OR
                                                     ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                                       no-lock by {&TABLENAME}.desc-item
                                                                by {&tablename}.it-codigo {&v9indrep}.
        
                else
                        open query {&QUERYNAME} for each {&TABLENAME} where 
                                                      {&TABLENAME}.desc-item >= c-ini            AND
                                                      {&TABLENAME}.desc-item <= c-fim            AND   
                                                      {&TABLENAME}.desc-item matches ("*" + c-palavra + "*") AND
                                                    (({&TABLENAME}.cod-obsoleto = 1 and l-ativo) OR
                                                     ({&TABLENAME}.cod-obsoleto = 2 and l-auto ) OR
                                                     ({&TABLENAME}.cod-obsoleto = 3 and l-todas) OR
                                                     ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                                       no-lock by {&TABLENAME}.desc-item
                                                                by {&tablename}.it-codigo {&v9indrep}.        
        &endif.
     end.
  end.
  else do:

     if c-op-combo = "Fam°lia" then 
        case i-compr-fabric:

           when 1 then 
                  open query {&QUERYNAME} for each {&TABLENAME} where 
                                                   {&TABLENAME}.fm-codigo    >= c-ini          AND
                                                   {&TABLENAME}.fm-codigo    <= c-fim          AND
                                                   {&TABLENAME}.compr-fabric = 1               AND 
                                                  (({&TABLENAME}.cod-obsoleto = 1 and l-ativo) OR
                                                   ({&TABLENAME}.cod-obsoleto = 2 and l-auto ) OR
                                                   ({&TABLENAME}.cod-obsoleto = 3 and l-todas) OR
                                                   ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                                   no-lock by {&TABLENAME}.fm-codigo 
                                                            by {&TABLENAME}.desc-item
                                                             by {&tablename}.it-codigo {&v9indrep}.  
           when 2 then 
                open query {&QUERYNAME} for each {&TABLENAME} where 
                                                {&TABLENAME}.fm-codigo    >= c-ini          AND
                                                {&TABLENAME}.fm-codigo    <= c-fim          AND
                                                {&TABLENAME}.compr-fabric = 2               AND 
                                               (({&TABLENAME}.cod-obsoleto = 1 and l-ativo) OR
                                                ({&TABLENAME}.cod-obsoleto = 2 and l-auto ) OR
                                                ({&TABLENAME}.cod-obsoleto = 3 and l-todas) OR
                                                ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                                no-lock by {&TABLENAME}.fm-codigo 
                                                         by {&TABLENAME}.desc-item
                                                           by {&tablename}.it-codigo {&v9indrep}.  
           when 3 then 
                 open query {&QUERYNAME} for each {&TABLENAME} where 
                                                  {&TABLENAME}.fm-codigo    >= c-ini          AND
                                                  {&TABLENAME}.fm-codigo    <= c-fim          AND
                                                 (({&TABLENAME}.cod-obsoleto = 1 and l-ativo) OR
                                                  ({&TABLENAME}.cod-obsoleto = 2 and l-auto ) OR
                                                  ({&TABLENAME}.cod-obsoleto = 3 and l-todas) OR
                                                  ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                                  no-lock by {&TABLENAME}.fm-codigo 
                                                           by {&TABLENAME}.desc-item
                                                            by {&tablename}.it-codigo {&v9indrep}.  
        end.
     if c-op-combo = "Fam°lia Comercial" then 
        case i-compr-fabric:

           when 1 then 
                  open query {&QUERYNAME} for each {&TABLENAME} where                              
                                                   {&TABLENAME}.fm-cod-com   >= c-ini          AND
                                                   {&TABLENAME}.fm-cod-com   <= c-fim          AND
                                                   {&TABLENAME}.compr-fabric = 1               AND 
                                                  (({&TABLENAME}.cod-obsoleto = 1 and l-ativo) OR
                                                   ({&TABLENAME}.cod-obsoleto = 2 and l-auto ) OR
                                                   ({&TABLENAME}.cod-obsoleto = 3 and l-todas) OR
                                                   ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                                   no-lock by {&TABLENAME}.fm-cod-com 
                                                            by {&TABLENAME}.desc-item 
                                                             by {&tablename}.it-codigo {&v9indrep}. 

           when 2 then 
               open query {&QUERYNAME} for each {&TABLENAME} where 
                                                {&TABLENAME}.fm-cod-com   >= c-ini          AND
                                                {&TABLENAME}.fm-cod-com   <= c-fim          AND
                                                {&TABLENAME}.compr-fabric = 2               AND 
                                               (({&TABLENAME}.cod-obsoleto = 1 and l-ativo) OR
                                                ({&TABLENAME}.cod-obsoleto = 2 and l-auto ) OR
                                                ({&TABLENAME}.cod-obsoleto = 3 and l-todas) OR
                                                ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                                 no-lock by {&TABLENAME}.fm-cod-com 
                                                          by {&TABLENAME}.desc-item 
                                                           by {&tablename}.it-codigo {&v9indrep}. 
           when 3 then 
                 open query {&QUERYNAME} for each {&TABLENAME} where 
                                                  {&TABLENAME}.fm-cod-com   >= c-ini          AND
                                                  {&TABLENAME}.fm-cod-com   <= c-fim          AND
                                                 (({&TABLENAME}.cod-obsoleto = 1 and l-ativo) OR
                                                  ({&TABLENAME}.cod-obsoleto = 2 and l-auto ) OR
                                                  ({&TABLENAME}.cod-obsoleto = 3 and l-todas) OR
                                                  ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                                  no-lock by {&TABLENAME}.fm-cod-com 
                                                           by {&TABLENAME}.desc-item 
                                                            by {&tablename}.it-codigo {&v9indrep}. 
        end.
     if c-op-combo = "Grupo Estoque" then 
        case i-compr-fabric:

           when 1 then 
                  open query {&QUERYNAME} for each {&TABLENAME} where 
                                                   {&TABLENAME}.ge-codigo    >= int(c-ini)     AND
                                                   {&TABLENAME}.ge-codigo    <= int(c-fim)     AND
                                                   {&TABLENAME}.compr-fabric = 1               AND 
                                                  (({&TABLENAME}.cod-obsoleto = 1 and l-ativo) OR
                                                   ({&TABLENAME}.cod-obsoleto = 2 and l-auto ) OR
                                                   ({&TABLENAME}.cod-obsoleto = 3 and l-todas) OR
                                                   ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                                   no-lock by {&TABLENAME}.ge-codigo 
                                                            by {&TABLENAME}.desc-item 
                                                             by {&tablename}.it-codigo {&v9indrep}.  

           when 2 then 
                  open query {&QUERYNAME} for each {&TABLENAME} where 
                                                   {&TABLENAME}.ge-codigo    >= int(c-ini)     AND
                                                   {&TABLENAME}.ge-codigo    <= int(c-fim)     AND
                                                   {&TABLENAME}.compr-fabric = 2               AND 
                                                 (({&TABLENAME}.cod-obsoleto = 1 and l-ativo) OR
                                                  ({&TABLENAME}.cod-obsoleto = 2 and l-auto ) OR
                                                  ({&TABLENAME}.cod-obsoleto = 3 and l-todas) OR
                                                  ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                                   no-lock by {&TABLENAME}.ge-codigo 
                                                            by {&TABLENAME}.desc-item 
                                                             by {&tablename}.it-codigo {&v9indrep}.  
           when 3 then 
                  open query {&QUERYNAME} for each {&TABLENAME} where 
                                                   {&TABLENAME}.ge-codigo    >= int(c-ini)     AND
                                                   {&TABLENAME}.ge-codigo    <= int(c-fim)     AND
                                                  (({&TABLENAME}.cod-obsoleto = 1 and l-ativo) OR
                                                   ({&TABLENAME}.cod-obsoleto = 2 and l-auto ) OR
                                                   ({&TABLENAME}.cod-obsoleto = 3 and l-todas) OR
                                                   ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                                    no-lock by {&TABLENAME}.ge-codigo 
                                                             by {&TABLENAME}.desc-item 
                                                              by {&tablename}.it-codigo {&v9indrep}.  
        end.
     if c-op-combo = "C¢digo Complementar" then
        case i-compr-fabric:

           when 1 then 
                  open query {&QUERYNAME} for each {&TABLENAME} where 
                                                   {&TABLENAME}.codigo-refer >= c-ini          AND
                                                   {&TABLENAME}.codigo-refer <= c-fim          AND
                                                   {&TABLENAME}.compr-fabric = 1               AND 
                                                  (({&TABLENAME}.cod-obsoleto = 1 and l-ativo) OR
                                                   ({&TABLENAME}.cod-obsoleto = 2 and l-auto ) OR
                                                   ({&TABLENAME}.cod-obsoleto = 3 and l-todas) OR
                                                   ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                                   no-lock by {&TABLENAME}.codigo-refer
                                                            by {&TABLENAME}.desc-item 
                                                             by {&tablename}.it-codigo {&v9indrep}.   
           when 2 then 
               open query {&QUERYNAME} for each {&TABLENAME} where 
                                                {&TABLENAME}.codigo-refer >= c-ini          AND
                                                {&TABLENAME}.codigo-refer <= c-fim          AND
                                                {&TABLENAME}.compr-fabric = 2               AND 
                                               (({&TABLENAME}.cod-obsoleto = 1 and l-ativo) OR
                                                ({&TABLENAME}.cod-obsoleto = 2 and l-auto ) OR
                                                ({&TABLENAME}.cod-obsoleto = 3 and l-todas) OR
                                                ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                                 no-lock by {&TABLENAME}.codigo-refer
                                                          by {&TABLENAME}.desc-item 
                                                           by {&tablename}.it-codigo {&v9indrep}.                 
           when 3 then 
                 open query {&QUERYNAME} for each {&TABLENAME} where 
                                                  {&TABLENAME}.codigo-refer >= c-ini          AND
                                                  {&TABLENAME}.codigo-refer <= c-fim          AND
                                                 (({&TABLENAME}.cod-obsoleto = 1 and l-ativo) OR
                                                  ({&TABLENAME}.cod-obsoleto = 2 and l-auto ) OR
                                                  ({&TABLENAME}.cod-obsoleto = 3 and l-todas) OR
                                                  ({&TABLENAME}.cod-obsoleto = 4 and l-obsoleto))
                                                  no-lock by {&TABLENAME}.codigo-refer
                                                           by {&TABLENAME}.desc-item  
                                                            by {&tablename}.it-codigo {&v9indrep}.                             
        end.
  end.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-criaTTItem DBOProgram 
PROCEDURE pi-criaTTItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define input-output parameter table for tt-item2.
define input-output parameter table for tt-comp-folh.
define input-output parameter table for tt-tabela.
define input  parameter c-cd-folha   AS CHAR NO-UNDO.
define output parameter r-folh-espec AS ROWID NO-UNDO.

  for each  tt-item2 no-lock:
      delete  tt-item2.
  end.
  for each tt-comp-folh no-lock:
      delete  tt-comp-folh.
  end.
  
  find first folh-espec where 
             folh-espec.cd-folha = c-cd-folha 
             no-lock no-error.
  if available folh-espec and c-cd-folha <> '' then do: 
      find folh-espec where 
           folh-espec.cd-folha  = c-cd-folha no-lock no-error.
      assign r-folh-espec = rowid(folh-espec). 
      if avail folh-espec then do:
      
            for each tt-item2:
               delete tt-item2.
            end.   
          
            for each tt-comp-folh:
                delete tt-comp-folh.
            end.
          
            for each tt-tabela:
                delete tt-tabela.
            end.    
          
            for each comp-folh no-lock where 
                     comp-folh.cd-folha >= folh-espec.cd-folha and
                     comp-folh.cd-folha <= folh-espec.cd-folha:
                    
               if not comp-folh.log-estado then next.
               
               if (comp-folh.tipo-result = 1 or 
                   comp-folh.tipo-result = 2 or
                   comp-folh.tipo-result = 6) and 
                   comp-folh.log-estado then do:       
                  
                  create tt-comp-folh.
                  assign tt-comp-folh.tt-row-comp-folh = rowid(comp-folh)
                         tt-comp-folh.comp-folh = comp-folh.cd-folha.
          
                  case comp-folh.tipo-result:
                      when 1 then do:
                          assign tt-comp-folh.tt-min   = string(mgind.comp-folh.vl-minimo, comp-folh.formato)
                                 tt-comp-folh.tt-max   = string(mgind.comp-folh.vl-maximo, comp-folh.formato) no-error.
                      end.          
                      when 6 then do:
                          assign tt-comp-folh.tt-min     = string(mgind.comp-folh.dt-minima, comp-folh.formato)
                                 tt-comp-folh.tt-max     = string(mgind.comp-folh.dt-maxima, comp-folh.formato).
                            
                      end.
                      when 2 then do:
                          if comp-folh.log-estado then
                              for each c-tab-res no-lock 
                                 where c-tab-res.nr-tabela = comp-folh.nr-tabela:
                                  create tt-tabela.
                                  assign tt-tabela.cd-folh   = comp-folh.cd-folha
                                         tt-tabela.cd-comp   = comp-folh.cd-comp
                                         tt-tabela.nr-tabela = c-tab-res.nr-tabela
                                         tt-tabela.sequencia = c-tab-res.sequencia.       
                          end.        
                      end.     
                  end. /* case */ 
               end. /* tipo result */
            end. /* for each comp-folh */
          
            for each item no-lock where item.cd-folh-item = folh-espec.cd-folha :
                create tt-item2.
                assign tt-item2.it-codigo = item.it-codigo               
                       tt-item2.fm-codigo = item.fm-codigo      
                       tt-item2.descricao = item.desc-item               
                       tt-item2.cd-folh-item = item.cd-folh-item         
                       tt-item2.l-display    = yes
                       tt-item2.r-rowid      = rowid(item).                  
                                                                         
                for each it-carac-tec                                    
                    where it-carac-tec.it-codigo = tt-item2.it-codigo
                      and it-carac-tec.cd-folha  = tt-item2.cd-folh-item no-lock:
          
                    find comp-folh
                        where comp-folh.cd-folha = it-carac-tec.cd-folha
                          and comp-folh.cd-comp  = it-carac-tec.cd-comp 
                          and comp-folh.log-estado = yes no-lock no-error.
          
                    case it-carac-tec.tipo-result:
                        when 1 then 
                          assign tt-item2.tt-val = string(it-carac-tec.vl-result,comp-folh.formato)  no-error.
                        when 6 then
                           assign tt-item2.tt-val = string(it-carac-tec.dt-result).
                    
                    end case.
                end.
            end.
      end.
  end.        
  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetConstraintLFltrNo DBOProgram 
PROCEDURE SetConstraintLFltrNo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  def input parameter pFiltro  as log  no-undo.
  def input parameter pInicial as char format "x(60)":U no-undo.
  def input parameter pFinal   as char format "x(60)":U no-undo.
  def input parameter pFabric       as int  no-undo.
  def input parameter pAtivo        as log  no-undo.
  def input parameter pAuto         as log  no-undo.
  def input parameter pTodas        as log  no-undo.
  def input parameter pObsoleto     as log  no-undo.
  def input parameter pOpRadio as int  no-undo.
  def input parameter pOpCombo as char format "x(30)":U no-undo.

      assign l-filtro       = pFiltro
             c-ini          = pInicial
             c-fim          = pFinal
             i-compr-fabric = pFabric   
             l-ativo        = pAtivo    
             l-auto         = pAuto     
             l-todas        = pTodas    
             l-obsoleto     = pObsoleto 
             i-op-radio     = pOpRadio  
             c-op-combo     = pOpCombo.

  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetConstraintFltrZoom DBOProgram 
PROCEDURE SetConstraintFltrZoom :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  def input parameter pIni               as char format "x(60)":U no-undo.
  def input parameter pFim               as char format "x(60)":U no-undo.
  def input parameter pFiltro            as log  no-undo.
  def input parameter i-par-fabric       as int  no-undo.
  def input parameter l-par-ativo        as log  no-undo.
  def input parameter l-par-auto         as log  no-undo.
  def input parameter l-par-todas        as log  no-undo.
  def input parameter l-par-obsoleto     as log  no-undo.
  def input parameter c-par-item-ini     as char format "x(16)":U no-undo.
  def input parameter c-par-item-fim     as char format "x(16)":U no-undo.
  def input parameter c-par-desc-ini     as char format "x(60)":U no-undo.
  def input parameter c-par-desc-fim     as char format "x(60)":U no-undo.
  def input parameter c-par-familia-ini  as char format "x(8)":U  no-undo.
  def input parameter c-par-familia-fim  as char format "x(8)":U  no-undo.
  def input parameter c-par-fam-coml-ini as char format "x(8)":U  no-undo.
  def input parameter c-par-fam-coml-fim as char format "x(8)":U  no-undo.
  def input parameter i-par-ge-cod-ini   as int  no-undo.
  def input parameter i-par-ge-cod-fim   as int  no-undo.
  def input parameter c-par-compl-ini    as char format "x(20)":U no-undo.
  def input parameter c-par-compl-fim    as char format "x(20)":U no-undo.
  def input parameter i-opradio          as int  no-undo.
  def input parameter c-opcombo          as char format "x(30)":U no-undo.
  
  
    assign c-ini             = pIni
           c-fim             = pFim
           l-filtro          = pFiltro
           i-compr-fabric    = i-par-fabric   
           l-ativo           = l-par-ativo    
           l-auto            = l-par-auto     
           l-todas           = l-par-todas    
           l-obsoleto        = l-par-obsoleto 
           c-it-codigo-ini   = c-par-item-ini
           c-it-codigo-fim   = c-par-item-fim
           c-desc-item-ini   = c-par-desc-ini
           c-desc-item-fim   = c-par-desc-fim
           c-fm-codigo-ini   = c-par-familia-ini
           c-fm-codigo-fim   = c-par-familia-fim
           c-fm-cod-com-ini  = c-par-fam-coml-ini
           c-fm-cod-com-fim  = c-par-fam-coml-fim
           i-ge-codigo-ini   = i-par-ge-cod-ini
           i-ge-codigo-fim   = i-par-ge-cod-fim
           c-cod-refer-ini   = c-par-compl-ini
           c-cod-refer-fim   = c-par-compl-fim
           i-op-radio        = i-opradio
           c-op-combo        = c-opcombo.
     

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetConstraintZoom DBOProgram 
PROCEDURE SetConstraintZoom :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE INPUT PARAMETER pCodigoIni  AS CHAR FORMAT "x(16)":U NO-UNDO.
 DEFINE INPUT PARAMETER pCodigoFim  AS CHAR FORMAT "x(16)":U NO-UNDO.
 DEFINE INPUT PARAMETER pRadio      AS INTEGER NO-UNDO.
 DEFINE INPUT PARAMETER pCombo      AS CHAR FORMAT "x(30)":U NO-UNDO.
 
 
 ASSIGN c-it-codigo-ini = pCodigoIni
        c-it-codigo-fim = pCodigoFim
        i-op-radio   = pRadio
        c-op-combo   = pCombo.
        
  RETURN "OK":U.      
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getPalavraBtDesc DBOProgram 
PROCEDURE getPalavraBtDesc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  def input parameter pPalavra as char format "x(60)":U no-undo.

      assign c-palavra  = pPalavra.

  RETURN "OK":U.

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
    
    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


