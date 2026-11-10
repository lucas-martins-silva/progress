&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/*********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.  
** 
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante 
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN172VA 2.00.00.026 } /*** "010026" 12/09/2026 21:26:00 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin172va MUT}
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

{utp/ut-glob.i}

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
define variable i-seq-erros-api-ctb-cc as integer initial 1 no-undo.

/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

def var cProgramName  as char no-undo.

def var i-cod-empresa LIKE empresa.ep-codigo  no-undo.

def temp-table tt-item-mat no-undo like item-mat
    field r-rowid as rowid.

{cdp/cdcfgmat.i}
{cdp/cdcfgdis.i}

DEFINE VARIABLE h-cdapi024            AS HANDLE        NO-UNDO.

DEF TEMP-TABLE tt-erro-aux NO-UNDO
    FIELD i-sequenc AS INT
    FIELD cd-erro   AS INT
    FIELD mensagem  AS CHAR FORMAT "x(255)".

{cdp/cd9590.i} /*** Variaveis indicam que usa Unidade de Negocio ***/

DEFINE VARIABLE c-lbl-liter-nat-rend AS CHARACTER   NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-enable-cd-freq DBOProgram 
FUNCTION fn-enable-cd-freq RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-enable-ct-codigo DBOProgram 
FUNCTION fn-enable-ct-codigo RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-enable-sc-codigo DBOProgram 
FUNCTION fn-enable-sc-codigo RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-enable-ge-codigo DBOProgram 
FUNCTION fn-enable-ge-codigo RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-enable-quant-segur DBOProgram 
FUNCTION fn-enable-quant-segur RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-enable-tempo-segur DBOProgram 
FUNCTION fn-enable-tempo-segur RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-enable-tipo-con-est DBOProgram 
FUNCTION fn-enable-tipo-con-est RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-enable-tipo-contr DBOProgram 
FUNCTION fn-enable-tipo-contr RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-return-empresa DBOProgram 
FUNCTION fn-return-empresa RETURNS CHARACTER
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
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 1.96
         WIDTH              = 37.72.
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
/***
{method/svc/autentic/autentic.i 
         &vUserEnterprise="i-cod-empresa" }
***/

{method/svc/autentic/autentic.i 
             &vUserCountryTax="i-pais-impto-usuario"}
find first param-global no-lock no-error.
assign i-cod-empresa = param-global.empresa-prin.

find first param-estoq no-lock no-error.

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
        when "ge-codigo":U then
            assign l-enable = fn-enable-ge-codigo().
            
        when "tipo-con-est":U then
            assign l-enable = fn-enable-tipo-con-est().

        when "ct-codigo":U then
            assign l-enable = fn-enable-ct-codigo().
        
        when "sc-codigo":U then
            assign l-enable = fn-enable-sc-codigo().
        
        when "tipo-contr":U then
            assign l-enable = fn-enable-tipo-contr().
        
        when "quant-segur":U then
           assign l-enable = fn-enable-quant-segur().
           
        when "tempo-segur":U then
           assign l-enable = fn-enable-tempo-segur().
        
        when "cd-freq":U then
           assign l-enable = fn-enable-cd-freq().
           
        when "ind-serv-mat":U then
           assign l-enable = (RowObject.tipo-contr = 4).             
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

        CASE pFieldName:
            WHEN "dsl-destaq":U THEN ASSIGN pFieldValue = RowObject.dsl-destaq.
            OTHERWISE RETURN "NOK":U.
        END CASE.
/*    CASE pFieldName:
 *         WHEN "cd-folh-item":U THEN ASSIGN pFieldValue = RowObject.cd-folh-item.
 *         WHEN "cd-folh-lote":U THEN ASSIGN pFieldValue = RowObject.cd-folh-lote.
 *         WHEN "cd-planejado":U THEN ASSIGN pFieldValue = RowObject.cd-planejado.
 *         WHEN "cd-referencia":U THEN ASSIGN pFieldValue = RowObject.cd-referencia.
 *         WHEN "cd-tag":U THEN ASSIGN pFieldValue = RowObject.cd-tag.
&IF "{&mguni_version}" >= "2.071" &THEN
&IF "{&mguni_version}" >= "2.071" &THEN
 *         WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
&ELSE
 *         WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
&ENDIF
        WHEN "ep-codigo" THEN ASSIGN pFieldValue = RowObject.ep-codigo.
&ELSE
 *         WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
&ENDIF
 *         WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
 *         WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
 *         WHEN "class-fiscal":U THEN ASSIGN pFieldValue = RowObject.class-fiscal.
 *         WHEN "cod-auxiliar":U THEN ASSIGN pFieldValue = RowObject.cod-auxiliar.
 *         WHEN "cod-comprado":U THEN ASSIGN pFieldValue = RowObject.cod-comprado.
 *         WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
 *         WHEN "cod-imagem":U THEN ASSIGN pFieldValue = RowObject.cod-imagem.
 *         WHEN "cod-lista-destino":U THEN ASSIGN pFieldValue = RowObject.cod-lista-destino.
 *         WHEN "cod-localiz":U THEN ASSIGN pFieldValue = RowObject.cod-localiz.
 *         WHEN "cod-produto":U THEN ASSIGN pFieldValue = RowObject.cod-produto.
 *         WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
 *         WHEN "codigo-refer":U THEN ASSIGN pFieldValue = RowObject.codigo-refer.
 *         WHEN "ct-codigo":U THEN ASSIGN pFieldValue = RowObject.ct-codigo.
 *         WHEN "sc-codigo":U THEN ASSIGN pFieldValue = RowObject.sc-codigo.
 *         WHEN "ct-codigo":U THEN ASSIGN pFieldValue = RowObject.ct-codigo.
 *         WHEN "de-codigo-prin":U THEN ASSIGN pFieldValue = RowObject.de-codigo-prin.
 *         WHEN "deposito-pad":U THEN ASSIGN pFieldValue = RowObject.deposito-pad.
 *         WHEN "desc-inter":U THEN ASSIGN pFieldValue = RowObject.desc-inter.
 *         WHEN "desc-item":U THEN ASSIGN pFieldValue = RowObject.desc-item.
 *         WHEN "desc-nacional":U THEN ASSIGN pFieldValue = RowObject.desc-nacional.
 *         WHEN "descricao-1":U THEN ASSIGN pFieldValue = RowObject.descricao-1.
 *         WHEN "descricao-2":U THEN ASSIGN pFieldValue = RowObject.descricao-2.
 *         WHEN "fm-cod-com":U THEN ASSIGN pFieldValue = RowObject.fm-cod-com.
 *         WHEN "fm-codigo":U THEN ASSIGN pFieldValue = RowObject.fm-codigo.
 *         WHEN "inform-compl":U THEN ASSIGN pFieldValue = RowObject.inform-compl.
 *         WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
 *         WHEN "it-demanda":U THEN ASSIGN pFieldValue = RowObject.it-demanda.
 *         WHEN "narrativa":U THEN ASSIGN pFieldValue = RowObject.narrativa.
 *         WHEN "niv-rest-fora":U THEN ASSIGN pFieldValue = RowObject.niv-rest-fora.
 *         WHEN "niv-rest-icms":U THEN ASSIGN pFieldValue = RowObject.niv-rest-icms.
 *         WHEN "path":U THEN ASSIGN pFieldValue = RowObject.path.
 *         WHEN "prefixo-lote":U THEN ASSIGN pFieldValue = RowObject.prefixo-lote.
 *         WHEN "responsavel":U THEN ASSIGN pFieldValue = RowObject.responsavel.
 *         WHEN "revisao":U THEN ASSIGN pFieldValue = RowObject.revisao.
 *         WHEN "rv-codigo":U THEN ASSIGN pFieldValue = RowObject.rv-codigo.
 *         WHEN "sc-codigo":U THEN ASSIGN pFieldValue = RowObject.sc-codigo.
 *         WHEN "un":U THEN ASSIGN pFieldValue = RowObject.un.
 *         WHEN "usuario-alt":U THEN ASSIGN pFieldValue = RowObject.usuario-alt.
 *         WHEN "usuario-obsol":U THEN ASSIGN pFieldValue = RowObject.usuario-obsol.
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
 *         WHEN "data-implant":U THEN ASSIGN pFieldValue = RowObject.data-implant.
 *         WHEN "data-liberac":U THEN ASSIGN pFieldValue = RowObject.data-liberac.
 *         WHEN "data-obsol":U THEN ASSIGN pFieldValue = RowObject.data-obsol.
 *         WHEN "data-ult-con":U THEN ASSIGN pFieldValue = RowObject.data-ult-con.
 *         WHEN "data-ult-ent":U THEN ASSIGN pFieldValue = RowObject.data-ult-ent.
 *         WHEN "data-ult-rep":U THEN ASSIGN pFieldValue = RowObject.data-ult-rep.
 *         WHEN "data-ult-sai":U THEN ASSIGN pFieldValue = RowObject.data-ult-sai.
 *         WHEN "dt-pr-fisc":U THEN ASSIGN pFieldValue = RowObject.dt-pr-fisc.
 *         WHEN "dt-ult-ben":U THEN ASSIGN pFieldValue = RowObject.dt-ult-ben.
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
 *         WHEN "aliquota-ipi":U THEN ASSIGN pFieldValue = RowObject.aliquota-ipi.
 *         WHEN "aliquota-ISS":U THEN ASSIGN pFieldValue = RowObject.aliquota-ISS.
 *         WHEN "altura":U THEN ASSIGN pFieldValue = RowObject.altura.
 *         WHEN "cap-est-fabr":U THEN ASSIGN pFieldValue = RowObject.cap-est-fabr.
 *         WHEN "comprim":U THEN ASSIGN pFieldValue = RowObject.comprim.
 *         WHEN "concentracao":U THEN ASSIGN pFieldValue = RowObject.concentracao.
 *         WHEN "consumo-aad":U THEN ASSIGN pFieldValue = RowObject.consumo-aad.
 *         WHEN "consumo-prev":U THEN ASSIGN pFieldValue = RowObject.consumo-prev.
 *         WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
 *         WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
 *         WHEN "fator-conver":U THEN ASSIGN pFieldValue = RowObject.fator-conver.
 *         WHEN "fator-reaj-icms":U THEN ASSIGN pFieldValue = RowObject.fator-reaj-icms.
 *         WHEN "fator-refugo":U THEN ASSIGN pFieldValue = RowObject.fator-refugo.
 *         WHEN "ft-conv-fmcoml":U THEN ASSIGN pFieldValue = RowObject.ft-conv-fmcoml.
 *         WHEN "ft-conversao":U THEN ASSIGN pFieldValue = RowObject.ft-conversao.
 *         WHEN "largura":U THEN ASSIGN pFieldValue = RowObject.largura.
 *         WHEN "lote-economi":U THEN ASSIGN pFieldValue = RowObject.lote-economi.
 *         WHEN "lote-minimo":U THEN ASSIGN pFieldValue = RowObject.lote-minimo.
 *         WHEN "lote-multipl":U THEN ASSIGN pFieldValue = RowObject.lote-multipl.
 *         WHEN "lote-mulven":U THEN ASSIGN pFieldValue = RowObject.lote-mulven.
 *         WHEN "per-min-luc":U THEN ASSIGN pFieldValue = RowObject.per-min-luc.
 *         WHEN "per-rest-fora":U THEN ASSIGN pFieldValue = RowObject.per-rest-fora.
 *         WHEN "per-rest-icms":U THEN ASSIGN pFieldValue = RowObject.per-rest-icms.
 *         WHEN "perc-demanda":U THEN ASSIGN pFieldValue = RowObject.perc-demanda.
 *         WHEN "perc-nqa":U THEN ASSIGN pFieldValue = RowObject.perc-nqa.
 *         WHEN "peso-bruto":U THEN ASSIGN pFieldValue = RowObject.peso-bruto.
 *         WHEN "peso-liquido":U THEN ASSIGN pFieldValue = RowObject.peso-liquido.
 *         WHEN "pr-sem-tx":U THEN ASSIGN pFieldValue = RowObject.pr-sem-tx.
 *         WHEN "preco-base":U THEN ASSIGN pFieldValue = RowObject.preco-base.
 *         WHEN "preco-fiscal":U THEN ASSIGN pFieldValue = RowObject.preco-fiscal.
 *         WHEN "preco-repos":U THEN ASSIGN pFieldValue = RowObject.preco-repos.
 *         WHEN "preco-ul-ent":U THEN ASSIGN pFieldValue = RowObject.preco-ul-ent.
 *         WHEN "qt-max-ordem":U THEN ASSIGN pFieldValue = RowObject.qt-max-ordem.
 *         WHEN "qt-var-max":U THEN ASSIGN pFieldValue = RowObject.qt-var-max.
 *         WHEN "qt-var-min":U THEN ASSIGN pFieldValue = RowObject.qt-var-min.
 *         WHEN "qtd-batch-padrao":U THEN ASSIGN pFieldValue = RowObject.qtd-batch-padrao.
 *         WHEN "qtd-refer-custo-dis":U THEN ASSIGN pFieldValue = RowObject.qtd-refer-custo-dis.
 *         WHEN "quant-pacote":U THEN ASSIGN pFieldValue = RowObject.quant-pacote.
 *         WHEN "quant-perda":U THEN ASSIGN pFieldValue = RowObject.quant-perda.
 *         WHEN "quant-segur":U THEN ASSIGN pFieldValue = RowObject.quant-segur.
 *         WHEN "rendimento":U THEN ASSIGN pFieldValue = RowObject.rendimento.
 *         WHEN "tp-cons-prev":U THEN ASSIGN pFieldValue = RowObject.tp-cons-prev.
 *         WHEN "tx-importacao":U THEN ASSIGN pFieldValue = RowObject.tx-importacao.
 *         WHEN "val-fator-custo-dis":U THEN ASSIGN pFieldValue = RowObject.val-fator-custo-dis.
 *         WHEN "valor-ipi-beb":U THEN ASSIGN pFieldValue = RowObject.valor-ipi-beb.
 *         WHEN "var-mob-maior":U THEN ASSIGN pFieldValue = RowObject.var-mob-maior.
 *         WHEN "var-mob-menor":U THEN ASSIGN pFieldValue = RowObject.var-mob-menor.
 *         WHEN "var-rep":U THEN ASSIGN pFieldValue = RowObject.var-rep.
 *         WHEN "var-req-maior":U THEN ASSIGN pFieldValue = RowObject.var-req-maior.
 *         WHEN "var-req-menor":U THEN ASSIGN pFieldValue = RowObject.var-req-menor.
 *         WHEN "var-transf":U THEN ASSIGN pFieldValue = RowObject.var-transf.
 *         WHEN "variac-acum":U THEN ASSIGN pFieldValue = RowObject.variac-acum.
 *         WHEN "vl-mat-ant":U THEN ASSIGN pFieldValue = RowObject.vl-mat-ant.
 *         WHEN "vl-mob-ant":U THEN ASSIGN pFieldValue = RowObject.vl-mob-ant.
 *         WHEN "vl-var-max":U THEN ASSIGN pFieldValue = RowObject.vl-var-max.
 *         WHEN "vl-var-min":U THEN ASSIGN pFieldValue = RowObject.vl-var-min.
 *         WHEN "volume":U THEN ASSIGN pFieldValue = RowObject.volume.
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

       CASE pFieldName:
           WHEN "cod-destaq":U THEN ASSIGN pFieldValue = RowObject.cod-destaq.
           OTHERWISE RETURN "NOK":U.
       END CASE.
/*    CASE pFieldName:
 *         WHEN "calc-cons-prev":U THEN ASSIGN pFieldValue = RowObject.calc-cons-prev.
 *         WHEN "calc-lead-time":U THEN ASSIGN pFieldValue = RowObject.calc-lead-time.
 *         WHEN "capac-recip-beb":U THEN ASSIGN pFieldValue = RowObject.capac-recip-beb.
 *         WHEN "cd-formula":U THEN ASSIGN pFieldValue = RowObject.cd-formula.
 *         WHEN "cd-origem":U THEN ASSIGN pFieldValue = RowObject.cd-origem.
 *         WHEN "cd-trib-icm":U THEN ASSIGN pFieldValue = RowObject.cd-trib-icm.
 *         WHEN "cd-trib-ipi":U THEN ASSIGN pFieldValue = RowObject.cd-trib-ipi.
 *         WHEN "cd-trib-iss":U THEN ASSIGN pFieldValue = RowObject.cd-trib-iss.
 *         WHEN "ciclo-contag":U THEN ASSIGN pFieldValue = RowObject.ciclo-contag.
 *         WHEN "classe-repro":U THEN ASSIGN pFieldValue = RowObject.classe-repro.
 *         WHEN "classif-abc":U THEN ASSIGN pFieldValue = RowObject.classif-abc.
 *         WHEN "cod-obsoleto":U THEN ASSIGN pFieldValue = RowObject.cod-obsoleto.
 *         WHEN "cod-servico":U THEN ASSIGN pFieldValue = RowObject.cod-servico.
 *         WHEN "cod-tax":U THEN ASSIGN pFieldValue = RowObject.cod-tax.
 *         WHEN "cod-tax-serv":U THEN ASSIGN pFieldValue = RowObject.cod-tax-serv.
 *         WHEN "codigo-orig":U THEN ASSIGN pFieldValue = RowObject.codigo-orig.
 *         WHEN "compr-fabric":U THEN ASSIGN pFieldValue = RowObject.compr-fabric.
 *         WHEN "contr-plan":U THEN ASSIGN pFieldValue = RowObject.contr-plan.
 *         WHEN "criticidade":U THEN ASSIGN pFieldValue = RowObject.criticidade.
 *         WHEN "dec-conv-fmcoml":U THEN ASSIGN pFieldValue = RowObject.dec-conv-fmcoml.
 *         WHEN "dec-ftcon":U THEN ASSIGN pFieldValue = RowObject.dec-ftcon.
 *         WHEN "demanda":U THEN ASSIGN pFieldValue = RowObject.demanda.
 *         WHEN "div-ordem":U THEN ASSIGN pFieldValue = RowObject.div-ordem.
 *         WHEN "emissao-ord":U THEN ASSIGN pFieldValue = RowObject.emissao-ord.
 *         WHEN "enquad-beb":U THEN ASSIGN pFieldValue = RowObject.enquad-beb.
 *         WHEN "esp-beb":U THEN ASSIGN pFieldValue = RowObject.esp-beb.
 *         WHEN "fase-medio":U THEN ASSIGN pFieldValue = RowObject.fase-medio.
 *         WHEN "ge-codigo":U THEN ASSIGN pFieldValue = RowObject.ge-codigo.
 *         WHEN "horiz-fixo":U THEN ASSIGN pFieldValue = RowObject.horiz-fixo.
 *         WHEN "ind-calc-meta":U THEN ASSIGN pFieldValue = RowObject.ind-calc-meta.
 *         WHEN "ind-imp-desc":U THEN ASSIGN pFieldValue = RowObject.ind-imp-desc.
 *         WHEN "ind-prev-demanda":U THEN ASSIGN pFieldValue = RowObject.ind-prev-demanda.
 *         WHEN "ind-refugo":U THEN ASSIGN pFieldValue = RowObject.ind-refugo.
 *         WHEN "ind-serv-mat":U THEN ASSIGN pFieldValue = RowObject.ind-serv-mat.
 *         WHEN "INT-1":U THEN ASSIGN pFieldValue = RowObject.INT-1.
 *         WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
 *         WHEN "isencao-import":U THEN ASSIGN pFieldValue = RowObject.isencao-import.
 *         WHEN "moeda-padrao":U THEN ASSIGN pFieldValue = RowObject.moeda-padrao.
 *         WHEN "nat-despesa":U THEN ASSIGN pFieldValue = RowObject.nat-despesa.
 *         WHEN "niv-mais-bai":U THEN ASSIGN pFieldValue = RowObject.niv-mais-bai.
 *         WHEN "niv-mps":U THEN ASSIGN pFieldValue = RowObject.niv-mps.
 *         WHEN "nivel":U THEN ASSIGN pFieldValue = RowObject.nivel.
 *         WHEN "nivel-apr-compra":U THEN ASSIGN pFieldValue = RowObject.nivel-apr-compra.
 *         WHEN "nivel-apr-manut":U THEN ASSIGN pFieldValue = RowObject.nivel-apr-manut.
 *         WHEN "nivel-apr-requis":U THEN ASSIGN pFieldValue = RowObject.nivel-apr-requis.
 *         WHEN "nivel-apr-solic":U THEN ASSIGN pFieldValue = RowObject.nivel-apr-solic.
 *         WHEN "nr-item-dcr":U THEN ASSIGN pFieldValue = RowObject.nr-item-dcr.
 *         WHEN "nr-linha":U THEN ASSIGN pFieldValue = RowObject.nr-linha.
 *         WHEN "nr-pontos-quotas":U THEN ASSIGN pFieldValue = RowObject.nr-pontos-quotas.
 *         WHEN "Nr-ult-peca":U THEN ASSIGN pFieldValue = RowObject.Nr-ult-peca.
 *         WHEN "num-id-item":U THEN ASSIGN pFieldValue = RowObject.num-id-item.
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
 *         WHEN "resumo-mp":U THEN ASSIGN pFieldValue = RowObject.resumo-mp.
 *         WHEN "sit-aloc":U THEN ASSIGN pFieldValue = RowObject.sit-aloc.
 *         WHEN "tempo-segur":U THEN ASSIGN pFieldValue = RowObject.tempo-segur.
 *         WHEN "tipo-atp":U THEN ASSIGN pFieldValue = RowObject.tipo-atp.
 *         WHEN "tipo-con-est":U THEN ASSIGN pFieldValue = RowObject.tipo-con-est.
 *         WHEN "tipo-contr":U THEN ASSIGN pFieldValue = RowObject.tipo-contr.
 *         WHEN "tipo-desc-nt":U THEN ASSIGN pFieldValue = RowObject.tipo-desc-nt.
 *         WHEN "tipo-est-seg":U THEN ASSIGN pFieldValue = RowObject.tipo-est-seg.
 *         WHEN "tipo-insp":U THEN ASSIGN pFieldValue = RowObject.tipo-insp.
 *         WHEN "tipo-lote-ec":U THEN ASSIGN pFieldValue = RowObject.tipo-lote-ec.
 *         WHEN "tipo-recip-beb":U THEN ASSIGN pFieldValue = RowObject.tipo-recip-beb.
 *         WHEN "tipo-requis":U THEN ASSIGN pFieldValue = RowObject.tipo-requis.
 *         WHEN "tipo-sched":U THEN ASSIGN pFieldValue = RowObject.tipo-sched.
 *         WHEN "tp-adm-lote":U THEN ASSIGN pFieldValue = RowObject.tp-adm-lote.
 *         WHEN "tp-aloc-lote":U THEN ASSIGN pFieldValue = RowObject.tp-aloc-lote.
 *         WHEN "tp-desp-padrao":U THEN ASSIGN pFieldValue = RowObject.tp-desp-padrao.
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

/*    CASE pFieldName:
 *         WHEN "alt-refer":U THEN ASSIGN pFieldValue = RowObject.alt-refer.
 *         WHEN "atu-conf":U THEN ASSIGN pFieldValue = RowObject.atu-conf.
 *         WHEN "baixa-estoq":U THEN ASSIGN pFieldValue = RowObject.baixa-estoq.
 *         WHEN "contr-qualid":U THEN ASSIGN pFieldValue = RowObject.contr-qualid.
 *         WHEN "conv-tempo-seg":U THEN ASSIGN pFieldValue = RowObject.conv-tempo-seg.
 *         WHEN "curva-abc":U THEN ASSIGN pFieldValue = RowObject.curva-abc.
 *         WHEN "fraciona":U THEN ASSIGN pFieldValue = RowObject.fraciona.
 *         WHEN "id-grade":U THEN ASSIGN pFieldValue = RowObject.id-grade.
 *         WHEN "incentivado":U THEN ASSIGN pFieldValue = RowObject.incentivado.
 *         WHEN "ind-backorder":U THEN ASSIGN pFieldValue = RowObject.ind-backorder.
 *         WHEN "ind-confprodcom":U THEN ASSIGN pFieldValue = RowObject.ind-confprodcom.
 *         WHEN "ind-especifico":U THEN ASSIGN pFieldValue = RowObject.ind-especifico.
 *         WHEN "ind-inf-qtf":U THEN ASSIGN pFieldValue = RowObject.ind-inf-qtf.
 *         WHEN "ind-ipi-dife":U THEN ASSIGN pFieldValue = RowObject.ind-ipi-dife.
 *         WHEN "ind-item-fat":U THEN ASSIGN pFieldValue = RowObject.ind-item-fat.
 *         WHEN "ind-quotas":U THEN ASSIGN pFieldValue = RowObject.ind-quotas.
 *         WHEN "loc-unica":U THEN ASSIGN pFieldValue = RowObject.loc-unica.
 *         WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
 *         WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
 *         WHEN "log-atualiz-via-mmp":U THEN ASSIGN pFieldValue = RowObject.log-atualiz-via-mmp.
 *         WHEN "log-carac-tec":U THEN ASSIGN pFieldValue = RowObject.log-carac-tec.
 *         WHEN "log-utiliza-batch-padrao":U THEN ASSIGN pFieldValue = RowObject.log-utiliza-batch-padrao.
 *         WHEN "pm-ja-calc":U THEN ASSIGN pFieldValue = RowObject.pm-ja-calc.
 *         WHEN "rot-quant":U THEN ASSIGN pFieldValue = RowObject.rot-quant.
 *         WHEN "rot-refer":U THEN ASSIGN pFieldValue = RowObject.rot-refer.
 *         WHEN "rot-revis":U THEN ASSIGN pFieldValue = RowObject.rot-revis.
 *         WHEN "tp-lote-econom":U THEN ASSIGN pFieldValue = RowObject.tp-lote-econom.
 *         WHEN "tp-lote-minimo":U THEN ASSIGN pFieldValue = RowObject.tp-lote-minimo.
 *         WHEN "tp-lote-multiplo":U THEN ASSIGN pFieldValue = RowObject.tp-lote-multiplo.
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

    return "OK":U.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setTT-item-mat DBOProgram 
PROCEDURE setTT-item-mat :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param table for tt-item-mat.

    find first tt-item-mat no-error.
    
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
   
    def var i-empresa LIKE empresa.ep-codigo no-undo.

    /*--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as validaá‰es ---*/
    DEFINE VARIABLE h-bodi247   AS HANDLE      NO-UNDO.
    DEFINE VARIABLE iCodErro    AS INTEGER     NO-UNDO.
    DEFINE VARIABLE cRetorno1   AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cRetorno2   AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE c-lbl-liter-codigo-imposto AS CHARACTER NO-UNDO.

    find first param-estoq no-lock no-error.
    find first param-compra no-lock no-error.

    assign i-cod-empresa = param-global.empresa-prin
           i-empresa     = i-cod-empresa.

    &if  defined (bf_dis_consiste_conta) &then
         for first estabelec 
             where estabelec.cod-estabel = RowObject.cod-estabel no-lock: end.

         run cdp/cd9970.p (input rowid(estabelec),
                           output i-empresa).
    &endif

    case cProgramName:
        when "cd0138.w":U then do: 

           if RowObject.politica = 2 and RowObject.lote-economi = 0 then do:
               /* Inicio -- Projeto Internacional */
               DEFINE VARIABLE c-lbl-liter-lote-economico AS CHARACTER NO-UNDO.
               {utp/ut-liter.i "Lote_Econìmico" *}
               ASSIGN c-lbl-liter-lote-economico = TRIM(RETURN-VALUE).
               {method/svc/errors/inserr.i
                                &ErrorNumber="6179" /* Lote economico deve ser maior do que zero  */
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"
                                &ErrorParameters="c-lbl-liter-lote-economico" }
           end.
		   
		   if RowObject.politica <> 6 then do:
		     FIND FIRST prod-composto WHERE prod-composto.it-codigo-pai = RowObject.it-codigo NO-LOCK NO-ERROR.
			 IF AVAIL prod-composto THEN DO:
			    /* Inicio -- Projeto Internacional */
			    {utp/ut-liter.i "Composto" *}
			    run utp/ut-msgs.p (input "show",
								   input 52218,
								   input RETURN-VALUE).
				IF RETURN-VALUE = "no" THEN DO:
					/* Inicio -- Projeto Internacional */
					DEFINE VARIABLE c-lbl-liter-composto AS CHARACTER NO-UNDO.
					{utp/ut-liter.i "Composto" *}
					ASSIGN c-lbl-liter-composto = TRIM(RETURN-VALUE).
					{method/svc/errors/inserr.i
                                &ErrorNumber="52216" /* Pol°tica composto possui relacionamentos */
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"
                                &ErrorParameters="c-lbl-liter-composto" } 
				END.
				ELSE
					FOR EACH prod-composto WHERE prod-composto.it-codigo-pai = RowObject.it-codigo EXCLUSIVE-LOCK:
						DELETE prod-composto.
					END.
			 END.
		   end.

           if  RowObject.loc-unica 
           and RowObject.cod-localiz <> item.cod-localiz then do:
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
        
           if  not can-find(first natureza-despesa
                           where natureza-despesa.nat-despesa = RowObject.nat-despesa ) then do:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-natureza-despesa AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Natureza_Despesa" *}
                ASSIGN c-lbl-liter-natureza-despesa = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                                &ErrorNumber="2" /*Natureza Despesa n∆o cadastrado*/
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"
                                &ErrorParameters="c-lbl-liter-natureza-despesa" }
           end.
           find first tipo-rec-desp
                where tipo-rec-desp.tp-codigo = RowObject.tp-desp-padrao no-lock no-error.
           if  not avail tipo-rec-desp then do:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-tipo-despesa AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Tipo_Despesa" *}
                ASSIGN c-lbl-liter-tipo-despesa = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                                &ErrorNumber="2" /*Tipo Despesa n∆o cadastrado*/
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"
                                &ErrorParameters="c-lbl-liter-tipo-despesa" }
           end.
           else
           if  tipo-rec-desp.tipo = 1 then do:
                {method/svc/errors/inserr.i
                                &ErrorNumber="414" /*Tipo Deve ser Despesa */
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" }
           end.
           if  not can-find( first moeda
                            where moeda.mo-codigo = RowObject.moeda-padrao ) then do:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-moeda AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Moeda" *}
                ASSIGN c-lbl-liter-moeda = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                                &ErrorNumber="2" /*Moeda n∆o cadastrada*/
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"
                                &ErrorParameters="c-lbl-liter-moeda" }
           end.
           if  fn-enable-ge-codigo() 
           and not can-find ( first grup-estoque
                              where grup-estoque.ge-codigo = RowObject.ge-codigo ) then do:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-grupo-estoque AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Grupo_Estoque" *}
                ASSIGN c-lbl-liter-grupo-estoque = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                                &ErrorNumber="2" /*Grupo Estoque n∆o cadastrado*/
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"
                                &ErrorParameters="c-lbl-liter-grupo-estoque" }
           end.
           /****
           if  not can-find( first tab-unidade
                            where tab-unidade.un = RowObject.un ) then do:
                {method/svc/errors/inserr.i
                                &ErrorNumber="2" /*Unidade Medida n∆o cadastrada*/
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"
                                &ErrorParameters="'Unidade Medida'" }
           end.
           ****/
           if  not can-find( first estabelec
                             where estabelec.cod-estabel = RowObject.cod-estabel ) then do:
                  /* Inicio -- Projeto Internacional */
                  DEFINE VARIABLE c-lbl-liter-estabelecimento AS CHARACTER NO-UNDO.
                  {utp/ut-liter.i "Estabelecimento" *}
                  ASSIGN c-lbl-liter-estabelecimento = TRIM(RETURN-VALUE).
                  {method/svc/errors/inserr.i
                                  &ErrorNumber="2" /* Estabelecimento n∆o cadastrado */
                                  &ErrorType="EMS"
                                  &ErrorSubType="ERROR"
                                  &ErrorParameters="c-lbl-liter-estabelecimento" }            
           end. 
           if  not can-find( first deposito
                            where deposito.cod-depos = RowObject.deposito-pad ) then do:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-deposito AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Dep¢sito" *}
                ASSIGN c-lbl-liter-deposito = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                                &ErrorNumber="2" /*Deposito n∆o cadastrado*/
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"
                                &ErrorParameters="c-lbl-liter-deposito" }              
           end.

           if  param-estoq.estab-uni then do:
               if  not can-find (localizacao
                          where  localizacao.cod-estabel = param-estoq.estabel-pad
                            and  localizacao.cod-depos   = RowObject.deposito-pad
                            and  localizacao.cod-localiz = RowObject.cod-localiz) then do:
                   {method/svc/errors/inserr.i
                                &ErrorNumber="6662" /* Localizaá∆o n∆o cadastrada */
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" }
               end.
           end.
           else 
               if  not can-find (localizacao
                          where  localizacao.cod-estabel = RowObject.cod-estabel
                            and  localizacao.cod-depos   = RowObject.deposito-pad
                            and  localizacao.cod-localiz = RowObject.cod-localiz) then do:
                   {method/svc/errors/inserr.i
                                   &ErrorNumber="6662" /* Localizaá∆o n∆o cadastrada */
                                   &ErrorType="EMS"
                                   &ErrorSubType="ERROR" }
               end.

           if  rowObject.tipo-contr = 1 /* f°sico */ 
           or  rowObject.tipo-contr = 4 /* dÇbito direto */ 
           then do:

				if  RowObject.ct-codigo <> "" then do:
			   
					empty temp-table tt_log_erro.
					if not valid-handle(h_api_cta_ctbl) then 
						run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
					run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (INPUT i-empresa,
																   INPUT "",
																   input-output RowObject.ct-codigo,
																   INPUT TODAY,
																   output p_des_titulo,
																   output v_num_tip_cta_ctbl,
																   output v_num_sit_cta_ctbl,
																   output v_ind_finalid_cta,
																   OUTPUT TABLE tt_log_erro).
																   
					if can-find(first tt_log_erro) then do:
						/* Inicio -- Projeto Internacional */
						DEFINE VARIABLE c-lbl-liter-conta-aplicacao AS CHARACTER NO-UNDO.
						{utp/ut-liter.i "Conta_Aplicaá∆o" *}
						ASSIGN c-lbl-liter-conta-aplicacao = TRIM(RETURN-VALUE).
						{method/svc/errors/inserr.i
                                    &ErrorNumber="2" /* Conta Aplicaá∆o n∆o cadastrada */
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="c-lbl-liter-conta-aplicacao" }
					end.
				end.
				if  RowObject.ct-codigo = "" then do:
					/* Inicio -- Projeto Internacional */
					DEFINE VARIABLE c-lbl-liter-conta-aplicacao-2 AS CHARACTER NO-UNDO.
					{utp/ut-liter.i "Conta_Aplicaá∆o" *}
					ASSIGN c-lbl-liter-conta-aplicacao-2 = TRIM(RETURN-VALUE).
					{method/svc/errors/inserr.i
                                    &ErrorNumber="2738" /* Conta Aplicaá∆o nula */
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="c-lbl-liter-conta-aplicacao-2" }
				end.
				
				
				if not valid-handle(h_api_ccusto) then
					run prgint/utb/utb742za.py persistent set h_api_ccusto.
				run pi_verifica_utilizacao_ccusto in h_api_ccusto (INPUT i-empresa,
																   INPUT RowObject.cod-estabel,
																   INPUT "",
																   INPUT RowObject.ct-codigo,
																   INPUT TODAY,
																   OUTPUT p_log_ccusto,
																   OUTPUT TABLE tt_log_erro).
				
				if p_log_ccusto then do:
					/** CENTRO DE CUSTO APLICA«√O **/
					run pi_busca_dados_ccusto in h_api_ccusto (INPUT i-empresa,
															   INPUT "",
															   input RowObject.sc-codigo,
															   INPUT TODAY,
															   output p_des_titulo,
															   OUTPUT TABLE tt_log_erro).
															   
					if can-find (first tt_log_erro no-lock) then do:
						FOR EACH tt_log_erro:
							CREATE RowErrors.
							/* Inicio -- Projeto Internacional */
							{utp/ut-liter.i "Centro_de_Custo_Aplicaá∆o" *}
							ASSIGN RowErrors.errorNumber      = tt_log_erro.ttv_num_cod_erro
								   RowErrors.errorHelp        = tt_log_erro.ttv_des_msg_ajuda
								   RowErrors.errorDescription = RETURN-VALUE + ": " + tt_log_erro.ttv_des_msg_erro
								   RowErrors.errorsequence    = i-seq-erros-api-ctb-cc
								   i-seq-erros-api-ctb-cc     = i-seq-erros-api-ctb-cc + 1
								   RowErrors.ErrorSubType = "ERROR":U
								   RowErrors.ErrorType = "EMS":U.
						END.
					end.
				end.
				
           end.
           else do:
                assign RowObject.ct-codigo = ""
					   RowObject.sc-codigo = "".
           end.
           
           if not can-find( first familia
                            where familia.fm-codigo = RowObject.fm-codigo ) then do:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-familia AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Fam°lia" *}
                ASSIGN c-lbl-liter-familia = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                                &ErrorNumber="2" /* Fam°lia n∆o cadastrada */
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"
                                &ErrorParameters="c-lbl-liter-familia" }           
           end.
            
           IF  l-mat-unid-negoc THEN DO:
               IF  NOT CAN-FIND(FIRST unid-negoc 
                                WHERE unid-negoc.cod-unid-negoc = rowObject.cod-unid-negoc NO-LOCK) THEN DO:
                   /* Inicio -- Projeto Internacional */
                   DEFINE VARIABLE c-lbl-liter-unidade-de-negocio AS CHARACTER NO-UNDO.
                   {utp/ut-liter.i "Unidade_de_Neg¢cio" *}
                   ASSIGN c-lbl-liter-unidade-de-negocio = TRIM(RETURN-VALUE).
                   {method/svc/errors/inserr.i &ErrorNumber="2"
                                               &ErrorType="EMS"
                                               &ErrorSubType="ERROR"
                                               &ErrorParameters="c-lbl-liter-unidade-de-negocio"}
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
                
           /*NF-e - cEANTrib*/
           IF  TRIM(tt-item-mat.cod-ean) <> "":U THEN DO:
               RUN dibo/bodi247.p PERSISTENT SET h-bodi247.
            
               ASSIGN iCodErro = 0.
            
               RUN validaDigitoVerificadorGTIN IN h-bodi247 (INPUT TRIM(tt-item-mat.cod-ean),
                                                             OUTPUT iCodErro,
                                                             OUTPUT cRetorno1,
                                                             OUTPUT cRetorno2).
            
               IF  iCodErro <> 0 THEN DO:
                   {method/svc/errors/inserr.i &ErrorNumber="iCodErro"
                                               &ErrorType="EMS":U
                                               &ErrorSubType="ERROR"
                                               &ErrorParameters="cRetorno1 + '~~~~':U + cRetorno2"}
               END.
            
               DELETE PROCEDURE h-bodi247.
               ASSIGN h-bodi247 = ?.
           END.
           /*NF-e - cEANTrib*/

           IF i-pais-impto-usuario <> 1 THEN DO:
               /*Dep¢sito Externo*/
               IF SUBSTRING(RowObject.char-2,313,3) <> "" THEN DO:
                   IF NOT CAN-FIND( FIRST deposito
                                    WHERE deposito.cod-depos = TRIM(SUBSTRING(RowObject.char-2,313,3)) ) THEN DO:
                       {utp/ut-liter.i Dep¢sito_Externo *}                                                      
                       {method/svc/errors/inserr.i
                                       &ErrorNumber="2" /*Deposito nío cadastrado*/
                                       &ErrorType="EMS"
                                       &ErrorSubType="ERROR"
                                       &ErrorParameters="RETURN-VALUE" }              
                   END. 
                   ELSE DO:
                       IF NOT CAN-FIND( FIRST deposito
                                        WHERE deposito.cod-depos   = TRIM(SUBSTRING(RowObject.char-2,313,3))
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
               IF SUBSTRING(RowObject.char-2,316,3) <> "" THEN DO:
                   IF NOT CAN-FIND( FIRST deposito
                                    WHERE deposito.cod-depos = TRIM(SUBSTRING(RowObject.char-2,316,3)) ) THEN DO:
                       {utp/ut-liter.i Dep¢sito_Drawback *}                                                      
                       {method/svc/errors/inserr.i
                                       &ErrorNumber="2" /*Deposito nío cadastrado*/
                                       &ErrorType="EMS"
                                       &ErrorSubType="ERROR"
                                       &ErrorParameters="RETURN-VALUE" }              
                   END. 
               END.
               
           END.

        end.
        when "ce0106.w":U then do:

            /* Parametros do Agente IA no contexto CE0106. */
            IF NOT AVAILABLE tt-item-mat THEN DO:
                {method/svc/errors/inserr.i
                    &ErrorNumber="58335"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="''"}
                RETURN "NOK":U.
            END.

            IF pType = "CREATE":U OR pType = "UPDATE":U THEN DO:
                IF tt-item-mat.log-contr-ag-ia = ? THEN DO:
                    {method/svc/errors/inserr.i
                        &ErrorNumber="58347"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters="''"}
                END.

                IF tt-item-mat.dias-ocioso = ? OR tt-item-mat.dias-ocioso < 0 THEN DO:
                    {method/svc/errors/inserr.i
                        &ErrorNumber="58348"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters="''"}
                END.

                IF tt-item-mat.perc-excesso = ? OR tt-item-mat.perc-excesso < 0 THEN DO:
                    {method/svc/errors/inserr.i
                        &ErrorNumber="58349"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters="''"}
                END.

                IF tt-item-mat.log-contr-ag-ia = NO
                   AND tt-item-mat.dias-ocioso <> ?
                   AND tt-item-mat.perc-excesso <> ?
                   AND (tt-item-mat.dias-ocioso > 0 OR tt-item-mat.perc-excesso > 0) THEN DO:
                    {method/svc/errors/inserr.i
                        &ErrorNumber="58350"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters="''"}
                END.

            END.
 
 
            find first item where item.it-codigo = rowobject.it-codigo no-lock no-error.	
            if ITEM.tipo-con-est = 4 and RowObject.tipo-con-est <> 4 and 
	           can-find(first ref-item  
	         		    where ref-item.it-codigo = item.it-codigo) then do:
	         	              {utp/ut-table.i mgind item 1}
                               ASSIGN cRetorno1 = RETURN-VALUE.
	         	              {utp/ut-table.i mgind ref-item 1}
	         	
	         		    {method/svc/errors/inserr.i
                                         &ErrorNumber="17" 
                                         &ErrorType="EMS"
                                         &ErrorParameters="cRetorno1 + ' ' + item.it-codigo + '~~~~':U + return-value"}
			   
	        end.
			
		
			if RowObject.politica = 5  and RowObject.tipo-con-est <> 4 then do: 
			{method/svc/errors/inserr.i
							&ErrorNumber="16535" 
							&ErrorType="EMS"
							&ErrorParameters="cRetorno1 + ' ' + item.it-codigo + '~~~~':U + return-value"}
			
			end.
		
	
            if  RowObject.tipo-con-est = 1 /* Serial */
            and can-find(first item-uni-estab
                         where item-uni-estab.it-codigo      = RowObject.it-codigo
                           and item-uni-estab.metodo-custeio = 6) /* custo espec°fico */
            then do:
                {method/svc/errors/inserr.i
                                &ErrorNumber="26162" /*Tipo de controle de estoque inv†lido para custo espec°fico*/
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" }
            end.
            
            if  tt-item-mat.tp-ressup = 3 
            and not can-find(first frequencia 
                             where frequencia.cd-freq = tt-item-mat.cd-freq) 
            then do:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-frequencia AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Frequància" *}
                ASSIGN c-lbl-liter-frequencia = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                                &ErrorNumber="2" /*Frequància n∆o cadastrada*/
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"
                                &ErrorParameters="c-lbl-liter-frequencia" }   
            end.
            
            if  tt-item-mat.cod-fat-ponder <> 0
            and not can-find(first fat-ponder
                             where fat-ponder.cod-fat-ponder = tt-item-mat.cod-fat-ponder) 
            then do:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-formula AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "F¢rmula" *}
                ASSIGN c-lbl-liter-formula = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                                &ErrorNumber="2" /*F¢rmula n∆o cadastrada*/
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"
                                &ErrorParameters="c-lbl-liter-formula" }                
           end.
           
        end.
        when "cc0103.w":U then do:
           if tt-item-mat.cod-estab-gestor <> "" then do:
                if not can-find( first estabelec
                                 where estabelec.cod-estabel = tt-item-mat.cod-estab-gestor ) then do:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-estabelecimento-2 AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Estabelecimento" *}
                    ASSIGN c-lbl-liter-estabelecimento-2 = TRIM(RETURN-VALUE).
                    {method/svc/errors/inserr.i
                                    &ErrorNumber="2" /* Estabelecimento n∆o cadastrado */
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="c-lbl-liter-estabelecimento-2" }            
                end. 
           end.     
           if param-compra.int-2 = 1 or tt-item-mat.cod-grp-compra <> "" then do:
                if not can-find( first grupo-compra 
                                 where grupo-compra.cod-grp-compra = tt-item-mat.cod-grp-compra ) then do:
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
           end.     
           if param-compra.int-2 = 2 or RowObject.cod-comprado <> "" then do:
                if not can-find( first comprador
                                 where comprador.cod-comprado = RowObject.cod-comprado ) then do:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-comprador AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Comprador" *}
                    ASSIGN c-lbl-liter-comprador = TRIM(RETURN-VALUE).
                    {method/svc/errors/inserr.i
                                    &ErrorNumber="2" /* Comprador n∆o cadastrado */
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="c-lbl-liter-comprador" }
                end.
            end.
        end.
        when "re0106.w":U then do:
            
           if  i-pais-impto-usuario <> 1 THEN DO:
               IF  not can-find( first tipo-tax
                                 where tipo-tax.cod-tax = tt-item-mat.cod-tax ) then do:
                   /* Inicio -- Projeto Internacional */
                   {utp/ut-liter.i "C¢digo_Imposto" *}
                   ASSIGN c-lbl-liter-codigo-imposto = TRIM(RETURN-VALUE).
                   {method/svc/errors/inserr.i
                                   &ErrorNumber="2" /* C¢digo Imposto n∆o cadastrado */
                                   &ErrorType="EMS"
                                   &ErrorSubType="ERROR"
                                   &ErrorParameters="c-lbl-liter-codigo-imposto" }
               end.   

               IF  RowObject.cod-tax-serv <> 0 AND
                   not can-find( first tipo-tax
                                 where tipo-tax.cod-tax = RowObject.cod-tax-serv ) then do:
                   /* Inicio -- Projeto Internacional */
                   DEFINE VARIABLE c-lbl-liter-codigo-imposto-servico AS CHARACTER NO-UNDO.
                   {utp/ut-liter.i "C¢digo_Imposto_Serviáo" *}
                   ASSIGN c-lbl-liter-codigo-imposto-servico = TRIM(RETURN-VALUE).
                   {method/svc/errors/inserr.i
                                   &ErrorNumber="2" /* C¢digo Imposto n∆o cadastrado */
                                   &ErrorType="EMS"
                                   &ErrorSubType="ERROR"
                                   &ErrorParameters="c-lbl-liter-codigo-imposto-servico" }
               end. 
               
           end.        
           else do:
               IF pType = "Update" THEN DO:
              
                   IF int(SUBSTR(RowObject.char-2,51,1))   < 1 OR int(SUBSTR(RowObject.char-2,51,1)) > 2 THEN DO:  /* taxIpiSuspens */
                        {utp/ut-liter.i "1_-_N∆o_Suspenso_;_2_-_Suspenso" *}
                        ASSIGN cRetorno1 = RETURN-VALUE.
                        {utp/ut-liter.i "Suspens∆o_IPI" *}
                        {method/svc/errors/inserr.i &ErrorNumber="18733"  &ErrorType="EMS"  &ErrorSubType="ERROR"  &ErrorParameters="RETURN-VALUE + ' (taxIpiSuspens)~~~~' + cRetorno1"}
                   END.
                   IF Int(SUBSTR(RowObject.char-2,268,1))  < 1 OR Int(SUBSTR(RowObject.char-2,268,1)) > 2 THEN DO:  /* onlyOtherTaxes */
                        {utp/ut-liter.i "1_-_Para_todas_as_Tributaá∆o_;_2_-_Somente_para_Tributaá∆o_Outros" *}
                        ASSIGN cRetorno1 = RETURN-VALUE.
                        {utp/ut-liter.i "Somente_para_Trib_Outros" *}
                        {method/svc/errors/inserr.i &ErrorNumber="18733"  &ErrorType="EMS"  &ErrorSubType="ERROR"  &ErrorParameters="RETURN-VALUE + ' (onlyOtherTaxes)~~~~' + cRetorno1"}
                   END.
    
                   IF int(SUBSTR(RowObject.char-2,52,1))   < 1 OR int(SUBSTR(RowObject.char-2,52,1)) > 2 THEN DO:  /* pisOriginTrib */
                        {utp/ut-liter.i "1_-_Item_;_2_-_Natureza" *}
                        ASSIGN cRetorno1 = RETURN-VALUE.
                        {utp/ut-liter.i "Origem_tributaá∆o_PIS" *}
                        {method/svc/errors/inserr.i &ErrorNumber="18733"  &ErrorType="EMS"  &ErrorSubType="ERROR"  &ErrorParameters="RETURN-VALUE + ' (pisOriginTrib)~~~~' + cRetorno1"}
                   END.
    
                   IF int(SUBSTR(RowObject.char-2,53,1))   < 1 OR int(SUBSTR(RowObject.char-2,53,1)) > 2 THEN DO:  /* cofinsOriginTrib */
                        {utp/ut-liter.i "1_-_Item_;_2_-_Natureza" *}
                        ASSIGN cRetorno1 = RETURN-VALUE.
                        {utp/ut-liter.i "Origem_tributaá∆o_COFINS" *}
                        {method/svc/errors/inserr.i &ErrorNumber="18733"  &ErrorType="EMS"  &ErrorSubType="ERROR"  &ErrorParameters="RETURN-VALUE + ' (cofinsOriginTrib)~~~~' + cRetorno1"}
                   END.

                   IF RowObject.cd-trib-ipi < 1 OR RowObject.cd-trib-ipi > 4 THEN DO: /*ipiTaxation*/
                        {utp/ut-liter.i "1_-_Tributado_;_2_-_Isento_;_3_-_Outros_;_4_-_Reduzido" *}
                      
                        ASSIGN cRetorno1 = RETURN-VALUE.
                        {utp/ut-liter.i "Tributaá∆o_IPI" *}
                        {method/svc/errors/inserr.i &ErrorNumber="18733"  &ErrorType="EMS"  &ErrorSubType="ERROR"  &ErrorParameters="RETURN-VALUE + ' (ipiTaxation)~~~~' + cRetorno1"}

                   END.
                   IF RowObject.cd-trib-icm < 1 OR RowObject.cd-trib-icm > 5 THEN DO: /*icmsTaxation*/
                        {utp/ut-liter.i "1_-_Tributado_;_2_-_Isento_;_3_-_Outros_;_4_-_Reduzido;_5_-_Diferido" *}
                      
                        ASSIGN cRetorno1 = {ininc/i10in172.i 07}.
                        {utp/ut-liter.i "Tributaá∆o_ICMS" *}
                        {method/svc/errors/inserr.i &ErrorNumber="18733"  &ErrorType="EMS"  &ErrorSubType="ERROR"  &ErrorParameters="RETURN-VALUE + ' (icmsTaxation)~~~~' + cRetorno1"}

                   END.
                   IF RowObject.cd-trib-iss < 1 OR RowObject.cd-trib-iss > 4 THEN DO: /*issTaxation*/
                        {utp/ut-liter.i "1_-_Tributado_;_2_-_Isento_;_3_-_Outros_;_4_-_Reduzido" *}
                      
                        ASSIGN cRetorno1 = {ininc/i10in172.i 07}.
                        {utp/ut-liter.i "Tributaá∆o_ISS" *}
                        {method/svc/errors/inserr.i &ErrorNumber="18733"  &ErrorType="EMS"  &ErrorSubType="ERROR"  &ErrorParameters="RETURN-VALUE + ' (issTaxation)~~~~' + cRetorno1"}

                   END.

                   IF SUBSTRING(tt-item-mat.char-1,243,2) <> "" THEN DO: /*UN para calculo PIS*/
                       IF NOT CAN-FIND(FIRST tab-unidade 
                                       WHERE tab-unidade.un = SUBSTRING(tt-item-mat.char-1,243,2)) THEN DO:
                           {utp/ut-liter.i "Unidade_de_Medida_p/_c†lculo_PIS" *}
                           {method/svc/errors/inserr.i 
                                           &ErrorNumber="2" /* Unidade de medida n∆o cadastrado */
                                           &ErrorType="EMS"
                                           &ErrorSubType="ERROR"
                                           &ErrorParameters="RETURN-VALUE" }
                       END.
                   END.
                   IF SUBSTRING(tt-item-mat.char-1,245,2) <> "" THEN DO: /*UN para calculo COFINS*/
                       IF NOT CAN-FIND(FIRST tab-unidade 
                                       WHERE tab-unidade.un = SUBSTRING(tt-item-mat.char-1,245,2)) THEN DO:
                           {utp/ut-liter.i "Unidade_de_Medida_p/_c†lculo_COFINS" *}
                           {method/svc/errors/inserr.i 
                                           &ErrorNumber="2" /* Unidade de medida n∆o cadastrado */
                                           &ErrorType="EMS"
                                           &ErrorSubType="ERROR"
                                           &ErrorParameters="RETURN-VALUE" }
                       END.
                   END.
               END.

               if  not can-find( first classif-fisc
                                 where classif-fisc.class-fiscal = RowObject.class-fiscal ) then do:
                   /* Inicio -- Projeto Internacional */
                   DEFINE VARIABLE c-lbl-liter-classificacao-fiscal AS CHARACTER NO-UNDO.
                   {utp/ut-liter.i "Classificaá∆o_Fiscal" *}
                   ASSIGN c-lbl-liter-classificacao-fiscal = TRIM(RETURN-VALUE).
                   {method/svc/errors/inserr.i
                                   &ErrorNumber="2" /* Classificaá∆o Fiscal n∆o cadastrada */
                                   &ErrorType="EMS"
                                   &ErrorSubType="ERROR"
                                   &ErrorParameters="c-lbl-liter-classificacao-fiscal" }
               end.
               
               find first item where item.it-codigo = rowobject.it-codigo no-lock no-error.	
               IF  RowObject.class-fiscal <> item.class-fiscal THEN DO:
                   IF CAN-FIND(FIRST item-atrib-siscomex NO-LOCK
                               WHERE item-atrib-siscomex.cod-item = RowObject.it-codigo) THEN DO:
                       {method/svc/errors/inserr.i
                                       &ErrorNumber="57914" /* A classificaá∆o fiscal do item n∆o pode ser alterada */
                                       &ErrorType="EMS"
                                       &ErrorSubType="ERROR" }
                   END.
               END.
               
               if  RowObject.fator-reaj-icms <= 0 then do:
                   {method/svc/errors/inserr.i
                                   &ErrorNumber="5757" /* Fator de Reajuste Deve ser maior que Zero */
                                   &ErrorType="EMS"
                                   &ErrorSubType="ERROR" }           
               end.

               IF  tt-item-mat.cod-familia-impto <> ''
               AND NOT CAN-FIND(FIRST familia-impto NO-LOCK
                   WHERE familia-impto.cod-familia-impto = tt-item-mat.cod-familia-impto) THEN DO:
                   /* Inicio -- Projeto Internacional */
                   DEFINE VARIABLE c-lbl-liter-familia-imposto AS CHARACTER NO-UNDO.
                   {utp/ut-liter.i "Familia_Imposto" *}
                   ASSIGN c-lbl-liter-familia-imposto = TRIM(RETURN-VALUE).
                   {method/svc/errors/inserr.i
                               &ErrorNumber="47"
                               &ErrorType="EMS"
                               &ErrorSubType="ERROR"
                               &ErrorParameters="c-lbl-liter-familia-imposto" }
               END.
               
               IF  RowObject.cod-destaq > 0 THEN DO:
                   IF NOT CAN-FIND( FIRST classif-destaq
                                     WHERE classif-destaq.class-fiscal = RowObject.class-fiscal
                                     AND   classif-destaq.cod-destaq   = RowObject.cod-destaq ) THEN DO:
                        {method/svc/errors/inserr.i
                                   &ErrorNumber="28592" /* C¢digo Destaque n∆o relacionado a Classif Fiscal */
                                   &ErrorType="EMS"
                                   &ErrorSubType="ERROR" }
                   END.
               END. 
           
               IF  RowObject.cod-destaq = 0 AND 
                   RowObject.dsl-destaq <> '' THEN DO:
                   /* Inicio -- Projeto Internacional */
                   DEFINE VARIABLE c-lbl-liter-codigo-destaque AS CHARACTER NO-UNDO.
                   {utp/ut-liter.i "C¢digo_Destaque" *}
                   ASSIGN c-lbl-liter-codigo-destaque = TRIM(RETURN-VALUE).
                   {method/svc/errors/inserr.i
                               &ErrorNumber="2" /* Destaque n∆o cadastrado */
                               &ErrorType="EMS"
                               &ErrorSubType="ERROR"
                               &ErrorParameters="c-lbl-liter-codigo-destaque" }
               END.
               
               IF  INTEGER(substring(tt-item-mat.char-2,282,5)) > 0 AND 
                   not can-find(tab-codser WHERE tab-codser.cod-servico = int(substring(tt-item-mat.char-2,282,5))) THEN DO:
                   DEFINE VARIABLE c-lbl-liter-cod-servico AS CHARACTER NO-UNDO.
                   {utp/ut-liter.i "C¢digo_de_Serviáo" *}
                   ASSIGN c-lbl-liter-cod-servico = TRIM(RETURN-VALUE).
                   {method/svc/errors/inserr.i
                                   &ErrorNumber="2" /* Tabela Serviáo */
                                   &ErrorType="EMS"
                                   &ErrorSubType="ERROR"
                                   &ErrorParameters="c-lbl-liter-cod-servico" }

               END. 

               IF (pType = "Create" OR pType = "Update") THEN DO:
                   IF SUBSTRING(tt-item-mat.char-2,201,2) <> "" AND
                      NOT CAN-FIND(FIRST tab-serv-inss 
                                   WHERE tab-serv-inss.cdn-serv-inss = INT(SUBSTRING(tt-item-mat.char-2,201,2))) THEN DO:
                      {method/svc/errors/inserr.i
                              &ErrorNumber="34914"
                              &ErrorType="EMS"
                              &ErrorSubType="ERROR"}
                   END.
                   IF SUBSTRING(tt-item-mat.char-2,287,9) <> "" AND
                      NOT CAN-FIND(FIRST natur-rendto 
                                   WHERE natur-rendto.cod-natur-rendto = SUBSTRING(tt-item-mat.char-2,287,9)
                                     AND NOT natur-rendto.log-inativ) THEN DO:
                      {method/svc/errors/inserr.i
                                   &ErrorNumber="56730" /*Natureza de Rendimento n∆o Cadastrada ou inativa! &1*/
                                   &ErrorType="EMS"
                                   &ErrorSubType="ERROR"}
                   END.

                   IF  SUBSTRING(rowObject.char-1,289,1) = "S":U THEN DO:
                       IF  SUBSTRING(rowObject.char-1,290,2) <> "" THEN DO: /*UN para calculo IS*/
                           IF NOT CAN-FIND(FIRST tab-unidade 
                                           WHERE tab-unidade.un = SUBSTRING(rowObject.char-1,290,2)) THEN DO:
                               {utp/ut-liter.i "Unidade_de_Medida_p/_c†lculo_IS" *}
                               {method/svc/errors/inserr.i 
                                               &ErrorNumber="2" /* Unidade de medida n∆o cadastrado */
                                               &ErrorType="EMS"
                                               &ErrorSubType="ERROR"
                                               &ErrorParameters="RETURN-VALUE" }
                           END.
                       END.                  
                   END.

               END.
           end.
        end.
        WHEN "cd2594.w":U THEN DO:
            IF  RowObject.class-fiscal <> ""
            AND NOT CAN-FIND(FIRST classif-fisc
                             WHERE classif-fisc.class-fiscal = RowObject.class-fiscal ) THEN DO:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-classificacao-fiscal-2 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Classificaá∆o_Fiscal" *}
                ASSIGN c-lbl-liter-classificacao-fiscal-2 = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                                   &ErrorNumber="2" /* Classificaá∆o Fiscal n∆o cadastrada */
                                   &ErrorType="EMS"
                                   &ErrorSubType="ERROR"
                                   &ErrorParameters="c-lbl-liter-classificacao-fiscal-2" }
            END.
        END.
        WHEN "CD2510.w":U THEN DO:
            IF  i-pais-impto-usuario <> 1 /* Brasil */ THEN DO:
                IF  tt-item-mat.cod-tax <> 0 AND
                    NOT CAN-FIND(FIRST tipo-tax NO-LOCK
                                 WHERE tipo-tax.cod-tax = tt-item-mat.cod-tax ) THEN DO:
                    {utp/ut-liter.i "C¢digo_Imposto" *}
                    ASSIGN c-lbl-liter-codigo-imposto = TRIM(RETURN-VALUE).

                    {method/svc/errors/inserr.i &ErrorNumber="2" /* C¢digo Imposto n∆o cadastrado */
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="c-lbl-liter-codigo-imposto" }
                END.
                IF i-pais-impto-usuario = 2 THEN DO:
                    IF  INTEGER(SUBSTRING(RowObject.char-2,319,4)) <> 0 AND
                        NOT CAN-FIND(FIRST tipo-tax NO-LOCK
                                     WHERE tipo-tax.cod-tax = INTEGER(SUBSTRING(RowObject.char-2,319,4)) ) THEN DO:
                        {utp/ut-liter.i "Impostos_Ganancias" *}
                        ASSIGN c-lbl-liter-codigo-imposto = TRIM(RETURN-VALUE).
    
                        {method/svc/errors/inserr.i &ErrorNumber="2" /* C¢digo Imposto n∆o cadastrado */
                                                    &ErrorType="EMS"
                                                    &ErrorSubType="ERROR"
                                                    &ErrorParameters="c-lbl-liter-codigo-imposto" }
                    END.
                END.
            END.
        END.
    end case.

    IF VALID-HANDLE(h_api_ccusto) THEN 
                DELETE PROCEDURE h_api_ccusto. 
    IF VALID-HANDLE(h_api_cta_ctbl) THEN 
                DELETE PROCEDURE h_api_cta_ctbl.
                                    
    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-enable-cd-freq DBOProgram 
FUNCTION fn-enable-cd-freq RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN (can-find (first item-mat 
                    where item-mat.it-codigo = RowObject.it-codigo
                      and item-mat.tp-ressup = 3)).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-enable-ct-codigo DBOProgram 
FUNCTION fn-enable-ct-codigo RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN (RowObject.tipo-contr = 1 or RowObject.tipo-contr = 4).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-enable-sc-codigo DBOProgram 
FUNCTION fn-enable-sc-codigo RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN (RowObject.tipo-contr = 1 or RowObject.tipo-contr = 4).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-enable-ge-codigo DBOProgram 
FUNCTION fn-enable-ge-codigo RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

                                                    
  RETURN not (   can-find(first movto-estoq
                      where movto-estoq.it-codigo = RowObject.it-codigo)
          or can-find(first saldo-estoq
                      where saldo-estoq.it-codigo = RowObject.it-codigo)).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-enable-quant-segur DBOProgram 
FUNCTION fn-enable-quant-segur RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN RowObject.tipo-est-seg = 1.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-enable-tempo-segur DBOProgram 
FUNCTION fn-enable-tempo-segur RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN RowObject.tipo-est-seg = 2.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-enable-tipo-con-est DBOProgram 
FUNCTION fn-enable-tipo-con-est RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/


    RETURN (    RowObject.tipo-contr <> 4
            and not can-find(first saldo-estoq
                             where saldo-estoq.it-codigo  = RowObject.it-codigo)
            and not can-find(first ped-item
                             where ped-item.it-codigo     = RowObject.it-codigo)
            and not can-find(first preco-item
                             where preco-item.it-codigo   = RowObject.it-codigo
                               and preco-item.situacao    = 1)
            and not can-find(first item-estab
                             where item-estab.it-codigo   = RowObject.it-codigo)
            and not can-find(first item-doc-est
                             where item-doc-est.it-codigo = RowObject.it-codigo)
            and not can-find(first it-nota-fisc
                             where it-nota-fisc.it-codigo = RowObject.it-codigo)).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-enable-tipo-contr DBOProgram 
FUNCTION fn-enable-tipo-contr RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN not (   can-find (first movto-estoq
                       where movto-estoq.it-codigo = RowObject.it-codigo)
          or can-find (first saldo-estoq
                       where saldo-estoq.it-codigo = RowObject.it-codigo)).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-return-empresa DBOProgram 
FUNCTION fn-return-empresa RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    def var i-empresa LIKE empresa.ep-codigo no-undo.

    assign i-empresa = i-cod-empresa.
    
    &if  defined (bf_dis_consiste_conta) &then
         for first estabelec 
             where estabelec.cod-estabel = RowObject.cod-estabel no-lock: end.
             
         run cdp/cd9970.p (input rowid(estabelec),
                           output i-empresa).
    &endif
          
  RETURN i-empresa.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

