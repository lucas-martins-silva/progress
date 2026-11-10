/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN172DESC 2.00.00.011 } /*** "010011" 27/10/2023 17:03:42  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin172desc MUT}
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

/** UnificaÁ„o de Conceitos **/
{cdp/cdunif001.i}

/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

&IF "{&mguni_version}" >= "2.071" &THEN
def var i-cod-empresa LIKE empresa.ep-codigo no-undo.
&ELSE
def var i-cod-empresa as int no-undo.
&ENDIF

/*** Include com prÇ-processadores ***/
{cdp/cdcfgdis.i}

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

{method/svc/autentic/autentic.i 
        &vUserEnterprise="i-cod-empresa" }
        
find first param-compra no-lock no-error.        

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
        WHEN "ct-codigo":U THEN ASSIGN pFieldValue = RowObject.ct-codigo.
        WHEN "sc-codigo":U THEN ASSIGN pFieldValue = RowObject.sc-codigo.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescClassFiscal DBOProgram 
PROCEDURE getDescClassFiscal :
/*------------------------------------------------------------------------------
  Parameters: pc-class-fiscal  - recebe o c¢digo da class-fiscal
              pc-descricao     - retorna a descriá∆o
  Notes:       
------------------------------------------------------------------------------*/
    def input  param pc-class-fiscal  like classif-fisc.class-fiscal no-undo.
    def output param pc-descricao     like classif-fisc.descricao    no-undo.

    for first classif-fisc fields (descricao)
        where classif-fisc.class-fiscal = pc-class-fiscal no-lock: end.
   
    if avail classif-fisc then
       assign pc-descricao = classif-fisc.descricao.    
    else do:
         assign pc-descricao = "".
         return "NOK":U.
    end.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piTrataClassFiscItem DBOProgram 
PROCEDURE piTrataClassFiscItem :
/*------------------------------------------------------------------------------
  Parameters: pc-class-fiscal  - recebe o c¢digo da class-fiscal
              pc-descricao     - retorna a descriá∆o
  Notes:       
------------------------------------------------------------------------------*/
    def input  param pc-class-fiscal  AS CHAR no-undo.
    
    IF NOT CAN-FIND (FIRST classif-fisc
                     where classif-fisc.class-fiscal = pc-class-fiscal) THEN DO:
        ASSIGN RowObject.class-fiscal        = "".    
        RETURN "NOK":U.
    END.
    ELSE 
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
    
    if  not avail param-compra then
        find first param-compra no-lock no-error.

    if param-compra.int-2 = 2 or pc-cod-comprador <> "" then do:
        for first comprador fields (nome)
            where comprador.cod-comprado = pc-cod-comprador no-lock: end.
        
        if avail comprador then
           assign pc-desc-comprador = comprador.nome.    
        else do:
             assign pc-desc-comprador = "".
             return "NOK":U.
        end.
    end.
    else
        assign pc-desc-comprador = "".
    
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescContaContabil DBOProgram 
PROCEDURE getDescContaContabil :
/*------------------------------------------------------------------------------
  Parameters: pc-conta-contabil  - recebe o c¢digo da conta-contabil
              pc-titulo          - retorna a descriá∆o
  Notes:       
------------------------------------------------------------------------------*/
    def input  param pc-conta-contabil  as character no-undo.
    def output param pc-titulo          as character no-undo.


    &if defined (bf_dis_consiste_conta) &then
    
/*        for first estabelec fields(cod-estabel ep-codigo) where
 *              estabelec.cod-estabel = consumo-estab.cod-estabel-prin no-lock: end.
 *         assign i-cod-empresa = estabelec.ep-codigo.*/
    
        if avail estabelec then
        run cdp/cd9970.p (input rowid(estabelec),
                          output i-cod-empresa).
    &endif
                  
	empty temp-table tt_log_erro.
	if not valid-handle(h_api_cta_ctbl) then run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
	run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (INPUT i-cod-empresa,
												  INPUT "",
												  input-output pc-conta-contabil,
												  INPUT TODAY,
												  output pc-titulo,
												  output v_num_tip_cta_ctbl,
												  output v_num_sit_cta_ctbl,
												  output v_ind_finalid_cta,
												  OUTPUT TABLE tt_log_erro).

	IF VALID-HANDLE(h_api_cta_ctbl) THEN
		DELETE PROCEDURE h_api_cta_ctbl.
    
    if can-find(first tt_log_erro) then do:
         assign pc-titulo = "".
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

    if pc-cod-estabel <> "" then do:
        for first estabelec fields (nome)
            where estabelec.cod-estabel = pc-cod-estabel no-lock: end.
    
        if avail estabelec then
           assign pc-desc-estabel = estabelec.nome.    
        else do:
             assign pc-desc-estabel = "".
             return "NOK":U.
        end.
    end.
    else 
        assign pc-desc-estabel = "".
 
    return "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescFamilia DBOProgram 
PROCEDURE getDescFamilia :
/*------------------------------------------------------------------------------
  Parameters: pc-fm-codigo     - recebe o c¢digo da Fam°lia
              pc-desc-familia  - retorna a descriá∆o
  Notes:       
------------------------------------------------------------------------------*/
    def input  param pc-fm-codigo    like familia.fm-codigo no-undo.
    def output param pc-desc-familia like familia.descricao no-undo.

    for first familia fields (descricao)
        where familia.fm-codigo = pc-fm-codigo no-lock: end.
    
    if avail familia then
       assign pc-desc-familia = familia.descricao.    
    else do:
         assign pc-desc-familia = "".
         return "NOK":U.
    end.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescFatPonder DBOProgram 
PROCEDURE getDescFatPonder :
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

    if  not avail param-compra then
        find first param-compra no-lock no-error.

    if (param-compra.int-2 = 1 and pc-cod-grp-compra <> "") or pc-cod-grp-compra <> "" then do:
       for first grupo-compra fields (des-grp-compra)
           where grupo-compra.cod-grp-compra = pc-cod-grp-compra no-lock: end.
       if avail grupo-compra then
          assign pc-desc-grp-compra = grupo-compra.des-grp-compra.    
       else do:
          assign pc-desc-grp-compra = "".
          return "NOK":U.
       end.
    end.
    else 
       assign pc-desc-grp-compra = "".       

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescGrupEstoque DBOProgram 
PROCEDURE getDescGrupEstoque :
/*------------------------------------------------------------------------------
  Parameters: pc-ge-codigo - recebe o c¢digo da Grupo Estoque
              pc-descricao - retorna a descriá∆o
  Notes:       
------------------------------------------------------------------------------*/
    def input  param pc-ge-codigo  like grup-estoque.ge-codigo no-undo.
    def output param pc-descricao  like grup-estoque.descricao no-undo.

    for first grup-estoque fields (descricao)
        where grup-estoque.ge-codigo = pc-ge-codigo no-lock: end.
    
    if avail  grup-estoque then
       assign pc-descricao = grup-estoque.descricao.    
    else do:
         assign pc-descricao = "".
         return "NOK":U.
    end.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescItem DBOProgram 
PROCEDURE getDescItem :
/*------------------------------------------------------------------------------
  Parameters: pc-it-codigo  - recebe o c¢digo do Item
              pc-desc-item  - retorna a descriá∆o
  Notes:       
------------------------------------------------------------------------------*/
    def input  param pc-it-codigo like item.it-codigo no-undo.
    def output param pc-desc-item like item.desc-item no-undo.

    for first item fields (desc-item)
        where item.it-codigo = pc-it-codigo no-lock: end.
    
    if avail item then
       assign pc-desc-item = item.desc-item.    
    else do:
         assign pc-desc-item = "".
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescMoeda DBOProgram 
PROCEDURE getDescMoeda :
/*------------------------------------------------------------------------------
  Parameters: pc-mo-codigo - recebe o c¢digo da Moeda
              pc-descricao - retorna a descriá∆o
  Notes:       
------------------------------------------------------------------------------*/
    def input  param pc-mo-codigo  like moeda.mo-codigo no-undo.
    def output param pc-descricao  like moeda.descricao no-undo.

    for first moeda fields (descricao)
        where moeda.mo-codigo = pc-mo-codigo no-lock: end.
    
    if avail  moeda then
       assign pc-descricao = moeda.descricao.    
    else do:
         assign pc-descricao = "".
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
    def input  param pc-nat-despesa       like natureza-despesa.nat-despesa no-undo.
    def output param pc-desc-nat-despesa  like natureza-despesa.descricao   no-undo.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescTax DBOProgram 
PROCEDURE getDescTax :
/*------------------------------------------------------------------------------
  Parameters: pc-cod-tax    - recebe o c¢digo da Tipo Tax
              pc-descricao  - retorna a descriá∆o
  Notes:       
------------------------------------------------------------------------------*/
    def input  param pc-cod-tax   like tipo-tax.cod-tax   no-undo.
    def output param pc-descricao like tipo-tax.descricao no-undo.

    for first tipo-tax fields (descricao)
        where tipo-tax.cod-tax = pc-cod-tax no-lock: end.
    
    if avail tipo-tax then
       assign pc-descricao = tipo-tax.descricao.    
    else do:
         assign pc-descricao = "".
         return "NOK":U.
    end.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescTpDesp DBOProgram 
PROCEDURE getDescTpDesp :
/*------------------------------------------------------------------------------
  Parameters: pc-tp-codigo  - recebe o c¢digo da tp-codigo
              pc-descricao  - retorna a descriá∆o
  Notes:       
------------------------------------------------------------------------------*/
    def input  param pc-tp-codigo like tipo-rec-desp.tp-codigo no-undo.
    def output param pc-descricao like tipo-rec-desp.descricao no-undo.

    for first tipo-rec-desp fields (descricao)
        where tipo-rec-desp.tp-codigo = pc-tp-codigo no-lock: end.
    
    if avail tipo-rec-desp then
       assign pc-descricao = tipo-rec-desp.descricao.    
    else do:
         assign pc-descricao = "".
         return "NOK":U.
    end.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescUn DBOProgram 
PROCEDURE getDescUn :
/*------------------------------------------------------------------------------
  Parameters: pc-un         - recebe o c¢digo da UN
              pc-descricao  - retorna a descriá∆o
  Notes:       
------------------------------------------------------------------------------*/
    def input  param pc-un        like tab-unidade.un        no-undo.
    def output param pc-descricao like tab-unidade.descricao no-undo.

    for first tab-unidade fields (descricao)
        where tab-unidade.un = pc-un no-lock: end.
    
    if avail tab-unidade then
       assign pc-descricao = tab-unidade.descricao.    
    else do:
         assign pc-descricao = "".
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
   open query {&queryName} for each {&tableName} no-lock indexed-reposition.
   
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


