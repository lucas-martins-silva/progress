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
{include/i-prgvrs.i BOIN292 2.00.00.024 } /*** "010024" 11/09/2026 16:46:10 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin292 MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : 
    Purpose    : O DBO (Datasul Business Objects) Ç um programa PROGRESS
                 que contÇm a l¢gica de neg¢cio e acesso a dados para uma
                 tabela do banco de dados.

    Parameters :

    Notes      :
 -------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName param-re
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName param-re
&GLOBAL-DEFINE TableLabel param-re
&GLOBAL-DEFINE QueryName qr{&TableName}
&GLOBAL-DEFINE XMLProducer YES
&GLOBAL-DEFINE XMLReceiver YES
&GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES


/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com
      extens∆o .i ---*/
{inbo/boin292.i RowObject}
{cdp/cdcfgmat.i}

/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o
      manual da query ---*/
{method/dboqry.i}

/* Local Buffer Definitions ---                                            */
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
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 16.54
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

DEFINE NEW GLOBAL SHARED VAR i-pais-impto-usuario AS INTEGER FORMAT ">>9" NO-UNDO.
DEFINE VAR execGZIPProgram AS CHAR INIT ? NO-UNDO.


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
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "esp-def-dac":U THEN ASSIGN pFieldValue = RowObject.esp-def-dac.
        WHEN "esp-def-dup":U THEN ASSIGN pFieldValue = RowObject.esp-def-dup.
        WHEN "esp-def-nff":U THEN ASSIGN pFieldValue = RowObject.esp-def-nff.
        WHEN "estab-usuario":U THEN ASSIGN pFieldValue = RowObject.estab-usuario.
        WHEN "usuario":U THEN ASSIGN pFieldValue = RowObject.usuario.
        WHEN "nome":U THEN ASSIGN pFieldValue = RowObject.nome.
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
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "perc-vat":U THEN ASSIGN pFieldValue = RowObject.perc-vat.
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
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "orig-aliq-ip":U THEN ASSIGN pFieldValue = RowObject.orig-aliq-ip.
        WHEN "cod-ent-item":U THEN ASSIGN pFieldValue = RowObject.cod-ent-item.
        WHEN "codigo-rejei":U THEN ASSIGN pFieldValue = RowObject.codigo-rejei.
        WHEN "dias-receb":U THEN ASSIGN pFieldValue = RowObject.dias-receb.
        WHEN "flag-atu":U THEN ASSIGN pFieldValue = RowObject.flag-atu.
        WHEN "gera-item-ret":U THEN ASSIGN pFieldValue = RowObject.gera-item-ret.
        WHEN "pede-aca-ord":U THEN ASSIGN pFieldValue = RowObject.pede-aca-ord.
        WHEN "preco-nft":U THEN ASSIGN pFieldValue = RowObject.preco-nft.
        WHEN "rateia-frete":U THEN ASSIGN pFieldValue = RowObject.rateia-frete.
        WHEN "seq-item-um":U THEN ASSIGN pFieldValue = RowObject.seq-item-um.
        WHEN "tipo-arredonda":U THEN ASSIGN pFieldValue = RowObject.tipo-arredonda.
        WHEN "tp-atual-cr":U THEN ASSIGN pFieldValue = RowObject.tp-atual-cr.
        WHEN "tp-doc-perm":U THEN ASSIGN pFieldValue = RowObject.tp-doc-perm.
        WHEN "var-atual":U THEN ASSIGN pFieldValue = RowObject.var-atual.
        WHEN "var-emis":U THEN ASSIGN pFieldValue = RowObject.var-emis.
        WHEN "variacao":U THEN ASSIGN pFieldValue = RowObject.variacao.
        WHEN "vl-base-icm":U THEN ASSIGN pFieldValue = RowObject.vl-base-icm.
        WHEN "vl-base-ipi":U THEN ASSIGN pFieldValue = RowObject.vl-base-ipi.
        WHEN "vl-base-iss":U THEN ASSIGN pFieldValue = RowObject.vl-base-iss.
        WHEN "inc-seq":U THEN ASSIGN pFieldValue = RowObject.inc-seq.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice IND-USU
  Parameters:
               retorna valor dos campos do °ndice IND-USU
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pusuario LIKE param-re.usuario NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pusuario = RowObject.usuario.

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
        WHEN "pd-aliq-icms":U THEN ASSIGN pFieldValue = RowObject.pd-aliq-icms.
        WHEN "pd-aliq-ipi":U THEN ASSIGN pFieldValue = RowObject.pd-aliq-ipi.
        WHEN "pd-cd-icms":U THEN ASSIGN pFieldValue = RowObject.pd-cd-icms.
        WHEN "pd-cd-ipi":U THEN ASSIGN pFieldValue = RowObject.pd-cd-ipi.
        WHEN "pd-cf-item":U THEN ASSIGN pFieldValue = RowObject.pd-cf-item.
        WHEN "pd-despesas":U THEN ASSIGN pFieldValue = RowObject.pd-despesas.
        WHEN "aceita-var":U THEN ASSIGN pFieldValue = RowObject.aceita-var.
        WHEN "ajusta-vl":U THEN ASSIGN pFieldValue = RowObject.ajusta-vl.
        WHEN "alt-uf":U THEN ASSIGN pFieldValue = RowObject.alt-uf.
        WHEN "ap-on-line":U THEN ASSIGN pFieldValue = RowObject.ap-on-line.
        WHEN "at-sem-ped":U THEN ASSIGN pFieldValue = RowObject.at-sem-ped.
        WHEN "atu-advert":U THEN ASSIGN pFieldValue = RowObject.atu-advert.
        WHEN "atu-erro":U THEN ASSIGN pFieldValue = RowObject.atu-erro.
        WHEN "atualiza-cr":U THEN ASSIGN pFieldValue = RowObject.atualiza-cr.
        WHEN "baixa-estoq":U THEN ASSIGN pFieldValue = RowObject.baixa-estoq.
        WHEN "baixa-pedido":U THEN ASSIGN pFieldValue = RowObject.baixa-pedido.
        WHEN "compara-item":U THEN ASSIGN pFieldValue = RowObject.compara-item.
        WHEN "controla-estab":U THEN ASSIGN pFieldValue = RowObject.controla-estab.
        WHEN "encerra-cc":U THEN ASSIGN pFieldValue = RowObject.encerra-cc.
        WHEN "erro-dupli":U THEN ASSIGN pFieldValue = RowObject.erro-dupli.
        WHEN "gera-adv":U THEN ASSIGN pFieldValue = RowObject.gera-adv.
        WHEN "gera-ce-fatura":U THEN ASSIGN pFieldValue = RowObject.gera-ce-fatura.
        WHEN "pd-esp-fiscal":U THEN ASSIGN pFieldValue = RowObject.pd-esp-fiscal.
        WHEN "pd-seq":U THEN ASSIGN pFieldValue = RowObject.pd-seq.
        WHEN "ped-imp-nota":U THEN ASSIGN pFieldValue = RowObject.ped-imp-nota.
        WHEN "pede-desc-it":U THEN ASSIGN pFieldValue = RowObject.pede-desc-it.
        WHEN "pede-it-agreg":U THEN ASSIGN pFieldValue = RowObject.pede-it-agreg.
        WHEN "pede-quant":U THEN ASSIGN pFieldValue = RowObject.pede-quant.
        WHEN "pedido-it":U THEN ASSIGN pFieldValue = RowObject.pedido-it.
        WHEN "preco-unit":U THEN ASSIGN pFieldValue = RowObject.preco-unit.
        WHEN "rateia-desc":U THEN ASSIGN pFieldValue = RowObject.rateia-desc.
        WHEN "reabre-cc":U THEN ASSIGN pFieldValue = RowObject.reabre-cc.
        WHEN "reabre-pd":U THEN ASSIGN pFieldValue = RowObject.reabre-pd.
        WHEN "rec-fatura":U THEN ASSIGN pFieldValue = RowObject.rec-fatura.
        WHEN "rec-nota-credito":U THEN ASSIGN pFieldValue = RowObject.rec-nota-credito.
        WHEN "rec-out-for":U THEN ASSIGN pFieldValue = RowObject.rec-out-for.
        WHEN "rec-remito":U THEN ASSIGN pFieldValue = RowObject.rec-remito.
        WHEN "sem-pedido":U THEN ASSIGN pFieldValue = RowObject.sem-pedido.
        WHEN "vl-rec-fis":U THEN ASSIGN pFieldValue = RowObject.vl-rec-fis.
        WHEN "gera-msg":U THEN ASSIGN pFieldValue = RowObject.gera-msg.
        WHEN "inclui-icms":U THEN ASSIGN pFieldValue = RowObject.inclui-icms.
        WHEN "informa-dp":U THEN ASSIGN pFieldValue = RowObject.informa-dp.
        WHEN "ipi-outras-tot-nota":U THEN ASSIGN pFieldValue = RowObject.ipi-outras-tot-nota.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "log-fifo-oc":U THEN ASSIGN pFieldValue = RowObject.log-fifo-oc.
        WHEN "of-on-line":U THEN ASSIGN pFieldValue = RowObject.of-on-line.
        WHEN "log-pedir-dupl-autom" THEN ASSIGN pFieldValue = RowObject.log-pedir-dupl-autom.
        WHEN "log-pedir-unid-negoc":U THEN ASSIGN pFieldValue = RowObject.log-pedir-unid-negoc.
        WHEN "log-atual-nfe-danfe-invldo":U THEN ASSIGN pFieldValue = RowObject.log-atual-nfe-danfe-invldo.
        WHEN "log-nf-geren":U THEN ASSIGN pFieldValue = RowObject.log-nf-geren.
        WHEN "log-nfe-alterar":U THEN ASSIGN pFieldValue = RowObject.log-nfe-alterar.
        WHEN "log-nfe-cancelar":U THEN ASSIGN pFieldValue = RowObject.log-nfe-cancelar.
        WHEN "log-nfe-excluir":U THEN ASSIGN pFieldValue = RowObject.log-nfe-excluir.
        WHEN "log-nfe-apl-regras":U THEN ASSIGN pFieldValue = RowObject.log-nfe-apl-regras.
        WHEN "log-nfe-ger-fisico":U THEN ASSIGN pFieldValue = RowObject.log-nfe-ger-fisico.
        WHEN "log-nfe-ger-fiscal":U THEN ASSIGN pFieldValue = RowObject.log-nfe-ger-fiscal.
        WHEN "log-cte-alterar":U THEN ASSIGN pFieldValue = RowObject.log-cte-alterar.
        WHEN "log-cte-cancelar":U THEN ASSIGN pFieldValue = RowObject.log-cte-cancelar.
        WHEN "log-cte-excluir":U THEN ASSIGN pFieldValue = RowObject.log-cte-excluir.
        WHEN "log-cte-apl-regras":U THEN ASSIGN pFieldValue = RowObject.log-cte-apl-regras.
        WHEN "log-cte-ger-fiscal":U THEN ASSIGN pFieldValue = RowObject.log-cte-ger-fiscal.
        WHEN "log-nfse-alterar":U THEN ASSIGN pFieldValue = RowObject.log-nfse-alterar.
        WHEN "log-nfse-cancelar":U THEN ASSIGN pFieldValue = RowObject.log-nfse-cancelar.
        WHEN "log-nfse-excluir":U THEN ASSIGN pFieldValue = RowObject.log-nfse-excluir.
        WHEN "log-nfse-apl-regras":U THEN ASSIGN pFieldValue = RowObject.log-nfse-apl-regras.
        WHEN "log-nfse-ger-fiscal":U THEN ASSIGN pFieldValue = RowObject.log-nfse-ger-fiscal.
        WHEN "log-comp-reproces":U THEN ASSIGN pFieldValue = RowObject.log-comp-reproces.
        WHEN "log-comp-liberar":U THEN ASSIGN pFieldValue = RowObject.log-comp-liberar.
        WHEN "log-comp-env-email":U THEN ASSIGN pFieldValue = RowObject.log-comp-env-email.
        WHEN "log-comp-observ":U THEN ASSIGN pFieldValue = RowObject.log-comp-observ.
        WHEN "sumar-on-line":U THEN ASSIGN pFieldValue = RowObject.sumar-on-line.
        WHEN "log-permite-desat-docto-ctbz":U THEN ASSIGN pFieldValue = RowObject.log-permite-desat-docto-ctbz.
        
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
  Purpose:     Reposiciona registro com base no °ndice IND-USU
  Parameters:
               recebe valor dos campos do °ndice IND-USU
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pusuario LIKE param-re.usuario NO-UNDO.

    FIND FIRST bfparam-re WHERE
        bfparam-re.usuario = pusuario
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfparam-re THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfparam-re)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

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
    OPEN QUERY {&QueryName} FOR EACH param-re NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
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

    def var c-texto-1 as char no-undo.
    def var c-texto-2 as char no-undo.

    find first param-estoq no-lock no-error.

    /*--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as validaá‰es ---*/

    IF pType = "Create":U OR pType = "Update":U THEN DO:
        IF pType = "Create":U THEN DO:
            IF CAN-FIND (FIRST param-re WHERE param-re.usuario = RowObject.usuario) THEN DO:
                /* Usuario recebimento ja cadastrado */
                {method/svc/errors/inserr.i &ErrorNumber="7896"  &ErrorType="EMS"  &ErrorSubType="ERROR"}
            END.
        END.

        IF NOT CAN-FIND (FIRST usuar_mestre WHERE usuar_mestre.cod_usuario = RowObject.usuario) THEN DO:
            /* Usuario nao cadastrado na tabela Usuario Mestre */
            {method/svc/errors/inserr.i &ErrorNumber="3211"  &ErrorType="EMS"  &ErrorSubType="ERROR"}
        END.

        IF RowObject.usuario = "" OR RowObject.usuario = ? THEN DO:
            /* Usuario em branco e eh chave da tabela */
            {method/svc/errors/inserr.i &ErrorNumber="6216"  &ErrorType="EMS"  &ErrorSubType="ERROR"  &ErrorParameters="'usuario~~~~{&TableName}'"}
        END.

        IF i-pais-impto-usuario = 1 AND /* Brasil */
           SUBSTRING(RowObject.char-1,25,1) = "Y":U AND /* Utiliza configurador tributos para impostos retidos (enableTaxConfiguratorForWithheldTaxes) */
           NOT CAN-FIND(FIRST funcao
                        WHERE funcao.cd-funcao = "SPP-AUT-IMPTO":U
                          AND funcao.ativo) THEN DO:

            {utp/ut-liter.i "Parametrizaá∆o_n∆o_permitida." *}
            Assign c-texto-1 = RETURN-VALUE.

            {utp/ut-liter.i "ê_necess†rio_ativar_a_func∆o_Sugere_Imposto_Retido_Duplicata_(RE0103)." *}
            Assign c-texto-2 = RETURN-VALUE.

            {method/svc/errors/inserr.i &ErrorNumber="29693"  &ErrorType="EMS"  &ErrorSubType="ERROR"  &ErrorParameters="c-texto-1 + '~~~~' + c-texto-2"}
        END.

        find espec-ap where espec-ap.cod-esp = RowObject.esp-def-nff no-lock no-error.
        if available espec-ap AND espec-ap.tipo = 2 then do:
            /* Especie default de nota fiscal fatura - defaultSpeciesDuplicNFF */
            {method/svc/errors/inserr.i &ErrorNumber="4641"  &ErrorType="EMS"  &ErrorSubType="ERROR"}
        end. 

        if not avail espec-ap then do:
            /* Nao foi informada especie duplicata de nota fiscal fatura */
            {method/svc/errors/inserr.i &ErrorNumber="778"  &ErrorType="EMS"  &ErrorSubType="ERROR" &ErrorParameters="RowObject.esp-def-nff"}
        end.

        find espec-ap where espec-ap.cod-esp = RowObject.esp-def-dac no-lock no-error.
        if not avail espec-ap then do:
            /* Nao foi informada especie documento acessorio */
            {method/svc/errors/inserr.i &ErrorNumber="778"  &ErrorType="EMS"  &ErrorSubType="ERROR" &ErrorParameters="RowObject.esp-def-dac"}
        end.

        find espec-ap where espec-ap.cod-esp = RowObject.esp-def-dup no-lock no-error.
        if not avail espec-ap then do:
            /* Nao foi informada especie duplicata */
            {method/svc/errors/inserr.i &ErrorNumber="778"  &ErrorType="EMS"  &ErrorSubType="ERROR" &ErrorParameters="RowObject.esp-def-dup"}
        end.

        if RowObject.dec-1 > 1.00 then do:
            /* Diferenca aceitavel de impostos - acceptableTaxDifference */
            {utp/ut-liter.i "Diferenáa_aceit†vel_impostos" *}
            {method/svc/errors/inserr.i &ErrorNumber="15322"  &ErrorType="EMS"  &ErrorSubType="ERROR" &ErrorParameters="RETURN-VALUE + ' (acceptableTaxDifference)'"}
        end.

        if RowObject.val-variacao > 9.99 then do:
            /* Variacao permitida - allowedVariation */
            {utp/ut-liter.i "atributo_Variaá∆o_permitida" *}
            {method/svc/errors/inserr.i &ErrorNumber="18733"  &ErrorType="EMS"  &ErrorSubType="ERROR"  &ErrorParameters="RETURN-VALUE + ' (allowedVariation)~~~~' + '0 <-> 9,99'"}
        end.

        IF RowObject.cod-ent-item       < 1 OR RowObject.cod-ent-item       > 2 THEN DO:  /* itemReceiptCode */
            {utp/ut-liter.i "atributo_C¢digo_entrada_item" *}
            {method/svc/errors/inserr.i &ErrorNumber="18733"  &ErrorType="EMS"  &ErrorSubType="ERROR"  &ErrorParameters="RETURN-VALUE + ' (itemReceiptCode)~~~~' + '1;2'"}
        END.
        IF RowObject.orig-aliq-ip       < 1 OR RowObject.orig-aliq-ip       > 2 THEN DO:  /* originIPIRate */
            {utp/ut-liter.i "atributo_Origem_al°quota_IPI" *}
            {method/svc/errors/inserr.i &ErrorNumber="18733"  &ErrorType="EMS"  &ErrorSubType="ERROR"  &ErrorParameters="RETURN-VALUE + ' (originIPIRate)~~~~' + '1;2'"}
        END.
        IF RowObject.rateia-frete       < 1 OR RowObject.rateia-frete       > 2 THEN DO:  /* distribFunctFreight */
            {utp/ut-liter.i "atributo_Rateia_frete_funá∆o" *}
            {method/svc/errors/inserr.i &ErrorNumber="18733"  &ErrorType="EMS"  &ErrorSubType="ERROR"  &ErrorParameters="RETURN-VALUE + ' (distribFunctFreight)~~~~' + '1;2'"}
        END.
        IF RowObject.tipo-arredonda     < 1 OR RowObject.tipo-arredonda     > 2 THEN DO:  /* roundUnitPrice */
            {utp/ut-liter.i "atributo_Arredonda_preco_unit" *}
            {method/svc/errors/inserr.i &ErrorNumber="18733"  &ErrorType="EMS"  &ErrorSubType="ERROR"  &ErrorParameters="RETURN-VALUE + ' (roundUnitPrice)~~~~' + '1;2'"}
        END. 
        IF RowObject.tp-doc-perm        < 1 OR RowObject.tp-doc-perm        > 3 THEN DO:  /* userDocsPermission */
            {utp/ut-liter.i "atributo_Permiss∆o_documentos" *}
            {method/svc/errors/inserr.i &ErrorNumber="18733"  &ErrorType="EMS"  &ErrorSubType="ERROR"  &ErrorParameters="RETURN-VALUE + ' (userDocsPermission)~~~~' + '1;2;3'"}
        END.
        IF RowObject.var-atual          < 0 OR RowObject.var-atual          > 999 THEN DO:  /* variationUpdated */
            {utp/ut-liter.i "atributo_Variaá∆o_atualizaá∆o" *}
            {method/svc/errors/inserr.i &ErrorNumber="18733"  &ErrorType="EMS"  &ErrorSubType="ERROR"  &ErrorParameters="RETURN-VALUE + ' (variationUpdated)~~~~' + '0 <-> 999'"}
        END.
        IF RowObject.var-emis           < 0 OR RowObject.var-emis           > 9999 THEN DO:  /* variationIssuing */
            {utp/ut-liter.i "atributo_Variaá∆o_emiss∆o" *}
            {method/svc/errors/inserr.i &ErrorNumber="18733"  &ErrorType="EMS"  &ErrorSubType="ERROR"  &ErrorParameters="RETURN-VALUE + ' (variationIssuing)~~~~' + '0 <-> 9999'"}
        END.
        IF RowObject.variacao           < 0 OR RowObject.variacao           > 999 THEN DO:  /* shipToDatePermissionVariation */
            {utp/ut-liter.i "atributo_Variaá∆o_data_entrega" *}
            {method/svc/errors/inserr.i &ErrorNumber="18733"  &ErrorType="EMS"  &ErrorSubType="ERROR"  &ErrorParameters="RETURN-VALUE + ' (shipToDatePermissionVariation)~~~~' + '0 <-> 999'"}
        END.
        IF RowObject.int-1              < 0 OR RowObject.int-1              > 1 THEN DO:  /* consigReceiptValuation */
            {utp/ut-liter.i "atributo_Valorizaá∆o_entrada_consignaá∆o" *}
            {method/svc/errors/inserr.i &ErrorNumber="18733"  &ErrorType="EMS"  &ErrorSubType="ERROR"  &ErrorParameters="RETURN-VALUE + ' (consigReceiptValuation)~~~~' + '0;1'"}
        END.

        IF RowObject.inc-seq            < 1 OR RowObject.inc-seq            > 999 THEN DO:  /* sequenceIncrease */
            {utp/ut-liter.i "atributo_incremento_sequància" *}
            {method/svc/errors/inserr.i &ErrorNumber="18733"  &ErrorType="EMS"  &ErrorSubType="ERROR"  &ErrorParameters="RETURN-VALUE + ' (sequenceIncrease)~~~~' + '1 <-> 999'"}
        END.
        IF RowObject.seq-item-um        < 1 OR RowObject.seq-item-um        > 99999 THEN DO:  /* firstItemSequence */
            {utp/ut-liter.i "atributo_Sequància_primeiro_item" *}
            {method/svc/errors/inserr.i &ErrorNumber="18733"  &ErrorType="EMS"  &ErrorSubType="ERROR"  &ErrorParameters="RETURN-VALUE + ' (firstItemSequence)~~~~' + '1 <-> 99999'"}
        END.
        
        IF RowObject.log-nf-geren AND avail param-estoq AND param-estoq.log-fechto-geren THEN DO: /* fechamento gerencial */
            /* Nao usa fechamento gerencial no ce0101 entao nao poderia setar para yes */
            {utp/ut-liter.i "Usa_fechamento_gerencial" *}
            {method/svc/errors/inserr.i &ErrorNumber="32678"  &ErrorType="EMS"  &ErrorSubType="ERROR"  &ErrorParameters="RETURN-VALUE + ' (CE0101)'"}
        END.
        
        IF RowObject.log-nf-geren AND 
           NOT CAN-FIND(FIRST funcao
                        WHERE funcao.cd-funcao = "SPP-FECH-GERENCIAL":U
                          AND funcao.ativo) THEN DO:
            /* Nao est· com a funcao de fechamento gerencial entao nao poderia setar para yes */
            {method/svc/errors/inserr.i &ErrorNumber="27372"  &ErrorType="EMS"  &ErrorSubType="ERROR"  &ErrorParameters="'SPP-FECH-GERENCIAL'"}
        END.

    END.

    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeCreateRecord DBOProgram 
PROCEDURE beforeCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Antes de criar o registro
  Parameters:
  Notes:
------------------------------------------------------------------------------*/

    IF NOT AVAIL RowObject THEN
        RETURN "NOK":U.

    find first usuar_mestre where usuar_mestre.cod_usuario = RowObject.usuario no-lock no-error.
    if avail usuar_mestre then
        assign RowObject.nome = usuar_mestre.nom_usuario.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setExecProgrGzip DBOProgram 
PROCEDURE setExecGZIPProgram :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pExecGZIPProgram AS CHARACTER NO-UNDO.

    ASSIGN execGZIPProgram = pExecGZIPProgram.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram 
PROCEDURE afterCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Depois de criar o registro
  Parameters:
  Notes:
------------------------------------------------------------------------------*/

    RUN updateExecGZIPProgram.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram 
PROCEDURE afterUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Depois de atualizar o registro
  Parameters:
  Notes:
------------------------------------------------------------------------------*/

    RUN updateExecGZIPProgram.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateExecGZIPProgram DBOProgram 
PROCEDURE updateExecGZIPProgram PRIVATE:
/*------------------------------------------------------------------------------
  Purpose:     Depois de criar o registro
  Parameters:
  Notes:
------------------------------------------------------------------------------*/

    IF NOT AVAIL RowObject OR execGZIPProgram = ? THEN
        RETURN "NOK":U.
        
    FIND FIRST param-gener EXCLUSIVE-LOCK
         WHERE param-gener.cod-chave-1 = "programas-tc":U
           AND param-gener.cod-chave-2 = RowObject.usuario  /* Codigo Usuario */
           AND param-gener.cod-chave-3 = "0":U
           AND param-gener.cod-chave-4 = "0":U
           AND param-gener.cod-chave-5 = "0":U
           AND param-gener.cod-param = "prog-gzip":U NO-ERROR.          
    IF AVAIL param-gener THEN DO:
        IF execGZIPProgram = "" THEN DO: /* quando vem em branco deve ser eliminado o registro */
            DELETE param-gener.
            RETURN "OK":U.
        END.
        ELSE    
            ASSIGN param-gener.cod-valor = execGZIPProgram.
    END.
    ELSE DO:
        IF execGZIPProgram = "" THEN /* quando vem em branco nao deve ser criado o registro */
            RETURN "OK":U.

        CREATE param-gener.
        ASSIGN param-gener.cod-chave-1 = "programas-tc":U
               param-gener.cod-chave-2 = RowObject.usuario  /* Codigo Usuario */
               param-gener.cod-chave-3 = "0":U
               param-gener.cod-chave-4 = "0":U
               param-gener.cod-chave-5 = "0":U
               param-gener.cod-param = "prog-gzip":U
               param-gener.cod-valor = execGZIPProgram.
    END.

    FIND FIRST param-gener NO-LOCK NO-ERROR.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
