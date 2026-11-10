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
***********************************************************************************/

{include/i-prgvrs.i BOIN218NA 2.00.00.010 } /*** "010010" 15/06/2026 14:31:49 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin218na MUT}
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
&GLOBAL-DEFINE DBOName movto-estoq
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName movto-estoq
&GLOBAL-DEFINE TableLabel movto-estoq
&GLOBAL-DEFINE QueryName qr{&TableName}

/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com
      extens∆o .i ---*/
{inbo/boin218na.i RowObject}

/*--- Include com pre-processadores 
      de release ---*/
{cdp/cdcfgmat.i}

/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o
      manual da query ---*/
{method/dboqry.i}

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/*--Definiá∆o de variavÇis utilizadas nas procedures--*/
def var l-param as log no-undo.
{rep/re0701.i}
&IF "{&mguni_version}" >= "2.071" &THEN
def var i-ep-codigo-usuario LIKE empresa.ep-codigo no-undo. /*perguntar amanha*/
&ELSE
def var i-ep-codigo-usuario as int no-undo. /*perguntar amanha*/
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK
&Scoped-define PROCEDURE-TYPE DBOProgram

    def var c-serie          as char    no-undo. 
    def var c-nat-oper       as char    no-undo. 
    def var c-cod-estab      as char    no-undo. 
    def var c-nro-docto      as char    no-undo. 
    def var i-cod-emit       as int     no-undo. 

/* ********************  Preprocessor Definitions  ******************** */


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
        WHEN "refer-contab":U THEN ASSIGN pFieldValue = RowObject.refer-contab.
        WHEN "referencia":U THEN ASSIGN pFieldValue = RowObject.referencia.
        WHEN "sc-codigo":U THEN ASSIGN pFieldValue = RowObject.sc-codigo.
        WHEN "sc-saldo":U THEN ASSIGN pFieldValue = RowObject.sc-saldo.
        WHEN "serie-docto":U THEN ASSIGN pFieldValue = RowObject.serie-docto.
        WHEN "un":U THEN ASSIGN pFieldValue = RowObject.un.
        WHEN "usuario":U THEN ASSIGN pFieldValue = RowObject.usuario.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-depos":U THEN ASSIGN pFieldValue = RowObject.cod-depos.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-estabel-des":U THEN ASSIGN pFieldValue = RowObject.cod-estabel-des.
        WHEN "cod-localiz":U THEN ASSIGN pFieldValue = RowObject.cod-localiz.
        WHEN "cod-orig-trans":U THEN ASSIGN pFieldValue = RowObject.cod-orig-trans.
        WHEN "cod-prog-orig":U THEN ASSIGN pFieldValue = RowObject.cod-prog-orig.
        WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
        WHEN "cod-roteiro":U THEN ASSIGN pFieldValue = RowObject.cod-roteiro.
        WHEN "cod-usu-ult-alter":U THEN ASSIGN pFieldValue = RowObject.cod-usu-ult-alter.
        WHEN "conta-contabil":U THEN ASSIGN pFieldValue = RowObject.conta-contabil.
        WHEN "conta-saldo":U THEN ASSIGN pFieldValue = RowObject.conta-saldo.
        WHEN "ct-codigo":U THEN ASSIGN pFieldValue = RowObject.ct-codigo.
        WHEN "ct-saldo":U THEN ASSIGN pFieldValue = RowObject.ct-saldo.
        WHEN "descricao-db":U THEN ASSIGN pFieldValue = RowObject.descricao-db.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "item-pai":U THEN ASSIGN pFieldValue = RowObject.item-pai.
        WHEN "lote":U THEN ASSIGN pFieldValue = RowObject.lote.
        WHEN "nat-operacao":U THEN ASSIGN pFieldValue = RowObject.nat-operacao.
        WHEN "nro-docto":U THEN ASSIGN pFieldValue = RowObject.nro-docto.
        WHEN "origem-valor":U THEN ASSIGN pFieldValue = RowObject.origem-valor.
        WHEN "hr-contab":U THEN ASSIGN pFieldValue = RowObject.hr-contab.
        WHEN "hr-trans":U THEN ASSIGN pFieldValue = RowObject.hr-trans.
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
        WHEN "dt-contab":U THEN ASSIGN pFieldValue = RowObject.dt-contab.
        WHEN "dt-criacao":U THEN ASSIGN pFieldValue = RowObject.dt-criacao.
        WHEN "dt-nf-saida":U THEN ASSIGN pFieldValue = RowObject.dt-nf-saida.
        WHEN "dt-trans":U THEN ASSIGN pFieldValue = RowObject.dt-trans.
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
        WHEN "valor-ggf-m[1]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-m[1].
        WHEN "valor-ggf-m[2]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-m[2].
        WHEN "valor-ggf-m[3]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-m[3].
        WHEN "valor-ggf-o[1]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-o[1].
        WHEN "valor-ggf-o[2]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-o[2].
        WHEN "valor-ggf-o[3]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-o[3].
        WHEN "valor-ggf-p[1]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-p[1].
        WHEN "valor-ggf-p[2]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-p[2].
        WHEN "valor-ggf-p[3]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-p[3].
        WHEN "valor-icm":U THEN ASSIGN pFieldValue = RowObject.valor-icm.
        WHEN "valor-ipi":U THEN ASSIGN pFieldValue = RowObject.valor-ipi.
        WHEN "valor-iss":U THEN ASSIGN pFieldValue = RowObject.valor-iss.
        WHEN "valor-mat-m[1]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-m[1].
        WHEN "valor-mat-m[2]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-m[2].
        WHEN "valor-mat-m[3]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-m[3].
        WHEN "valor-mat-o[1]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-o[1].
        WHEN "valor-mat-o[2]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-o[2].
        WHEN "valor-mat-o[3]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-o[3].
        WHEN "valor-mat-p[1]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-p[1].
        WHEN "valor-mat-p[2]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-p[2].
        WHEN "valor-mat-p[3]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-p[3].
        WHEN "valor-mob-m[1]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-m[1].
        WHEN "valor-mob-m[2]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-m[2].
        WHEN "valor-mob-m[3]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-m[3].
        WHEN "valor-mob-o[1]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-o[1].
        WHEN "valor-mob-o[2]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-o[2].
        WHEN "valor-mob-o[3]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-o[3].
        WHEN "valor-mob-p[1]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-p[1].
        WHEN "valor-mob-p[2]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-p[2].
        WHEN "valor-mob-p[3]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-p[3].
        WHEN "valor-nota":U THEN ASSIGN pFieldValue = RowObject.valor-nota.
        WHEN "vl-icm-fasb[1]":U THEN ASSIGN pFieldValue = RowObject.vl-icm-fasb[1].
        WHEN "vl-icm-fasb[2]":U THEN ASSIGN pFieldValue = RowObject.vl-icm-fasb[2].
        WHEN "vl-ipi-fasb[1]":U THEN ASSIGN pFieldValue = RowObject.vl-ipi-fasb[1].
        WHEN "vl-ipi-fasb[2]":U THEN ASSIGN pFieldValue = RowObject.vl-ipi-fasb[2].
        WHEN "vl-iss-fasb[1]":U THEN ASSIGN pFieldValue = RowObject.vl-iss-fasb[1].
        WHEN "vl-iss-fasb[2]":U THEN ASSIGN pFieldValue = RowObject.vl-iss-fasb[2].
        WHEN "vl-nota-fasb[1]":U THEN ASSIGN pFieldValue = RowObject.vl-nota-fasb[1].
        WHEN "vl-nota-fasb[2]":U THEN ASSIGN pFieldValue = RowObject.vl-nota-fasb[2].
        WHEN "vl-taxa":U THEN ASSIGN pFieldValue = RowObject.vl-taxa.
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "peso-liquido":U THEN ASSIGN pFieldValue = RowObject.peso-liquido.
        WHEN "quantidade":U THEN ASSIGN pFieldValue = RowObject.quantidade.
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
        WHEN "sequen-nf":U THEN ASSIGN pFieldValue = RowObject.sequen-nf.
        WHEN "tipo-preco[1]":U THEN ASSIGN pFieldValue = RowObject.tipo-preco[1].
        WHEN "tipo-preco[2]":U THEN ASSIGN pFieldValue = RowObject.tipo-preco[2].
        WHEN "tipo-preco[3]":U THEN ASSIGN pFieldValue = RowObject.tipo-preco[3].
        WHEN "tipo-trans":U THEN ASSIGN pFieldValue = RowObject.tipo-trans.
        WHEN "tipo-valor":U THEN ASSIGN pFieldValue = RowObject.tipo-valor.
        WHEN "base-calculo":U THEN ASSIGN pFieldValue = RowObject.base-calculo.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "nr-ord-produ":U THEN ASSIGN pFieldValue = RowObject.nr-ord-produ.
        WHEN "nr-ord-refer":U THEN ASSIGN pFieldValue = RowObject.nr-ord-refer.
        WHEN "nr-reporte":U THEN ASSIGN pFieldValue = RowObject.nr-reporte.
        WHEN "nr-req-sum":U THEN ASSIGN pFieldValue = RowObject.nr-req-sum.
        WHEN "nr-trans":U THEN ASSIGN pFieldValue = RowObject.nr-trans.
        WHEN "nr-trans-deb":U THEN ASSIGN pFieldValue = RowObject.nr-trans-deb.
        WHEN "num-ord-des":U THEN ASSIGN pFieldValue = RowObject.num-ord-des.
        WHEN "num-ord-inv":U THEN ASSIGN pFieldValue = RowObject.num-ord-inv.
        WHEN "num-seq-des":U THEN ASSIGN pFieldValue = RowObject.num-seq-des.
        WHEN "num-sequen":U THEN ASSIGN pFieldValue = RowObject.num-sequen.
        WHEN "numero-ordem":U THEN ASSIGN pFieldValue = RowObject.numero-ordem.
        WHEN "op-codigo":U THEN ASSIGN pFieldValue = RowObject.op-codigo.
        WHEN "op-seq":U THEN ASSIGN pFieldValue = RowObject.op-seq.
        WHEN "esp-docto":U THEN ASSIGN pFieldValue = RowObject.esp-docto.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice ITEM-DATA
  Parameters:
               retorna valor dos campos do °ndice ITEM-DATA
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pit-codigo LIKE movto-estoq.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE movto-estoq.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pdt-trans LIKE movto-estoq.dt-trans NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pit-codigo = RowObject.it-codigo.
    ASSIGN pcod-estabel = RowObject.cod-estabel.
    ASSIGN pdt-trans = RowObject.dt-trans.

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
        WHEN "contabilizado":U THEN ASSIGN pFieldValue = RowObject.contabilizado.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
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
  Purpose:     Reposiciona registro com base no °ndice ITEM-DATA
  Parameters:
               recebe valor dos campos do °ndice ITEM-DATA
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pit-codigo LIKE movto-estoq.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE movto-estoq.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pdt-trans LIKE movto-estoq.dt-trans NO-UNDO.

    FIND FIRST bfmovto-estoq WHERE
        bfmovto-estoq.it-codigo = pit-codigo AND
        bfmovto-estoq.cod-estabel = pcod-estabel AND
        bfmovto-estoq.dt-trans = pdt-trans
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfmovto-estoq THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmovto-estoq)).
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
    OPEN QUERY {&QueryName} FOR EACH movto-estoq NO-LOCK INDEXED-REPOSITION.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setconstraintToDocumEst DBOProgram 
PROCEDURE setconstraintToDocumEst :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter p-c-serie       as char       no-undo.
    def input parameter p-c-nat-oper    as char       no-undo.
    def input parameter p-c-cod-estab   as char       no-undo.
    def input parameter p-c-nro-docto   as char       no-undo.
    def input parameter p-i-cod-emit    as int        no-undo.
        
    assign c-serie     =  p-c-serie 
           c-nat-oper  =  p-c-nat-oper
           c-cod-estab =  p-c-cod-estab 
           c-nro-docto =  p-c-nro-docto
           i-cod-emit  =  p-i-cod-emit.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryToDocumEst DBOProgram 
PROCEDURE openQueryToDocumEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&tablename} where
                                     {&tablename}.cod-estabel      = c-cod-estab and
                                     {&tablename}.serie-docto      = c-serie     and
                                     {&tablename}.nro-docto        = c-nro-docto and
                                     {&tablename}.cod-emitente     = i-cod-emit  and
                                     (   {&tablename}.nat-operacao = c-nat-oper 
                                      or c-nat-oper = "")     
                            NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryToDocumEstFiscal DBOProgram 
PROCEDURE openQueryToDocumEstFiscal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH {&tablename} where
                                     {&tablename}.cod-estabel  = c-cod-estab and
                                     {&tablename}.serie-docto  = c-serie     and
                                     {&tablename}.nro-docto    = c-nro-docto and
                                     {&tablename}.cod-emitente = i-cod-emit  and
                                     {&tablename}.nat-operacao = c-nat-oper 
                            NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryToDocumEst DBOProgram 
PROCEDURE openQueryToDocumEstFisico :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH {&tablename} where
                                     {&tablename}.cod-estabel    = c-cod-estab and
                                     {&tablename}.serie-docto    = c-serie     and
                                     {&tablename}.nro-docto      = c-nro-docto and
                                     {&tablename}.cod-emitente   = i-cod-emit  and
                                     (   {&tablename}.nat-operacao = c-nat-oper 
                                      or {&tablename}.nat-operacao = "")
                            NO-LOCK INDEXED-REPOSITION.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaVlrNota DBOProgram 
PROCEDURE retornaVlrNota :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

def input  param pr-movto-estoq as rowid no-undo.
def input  param pi-tipo-custo  as int   no-undo.
def output param pde-vlr-nota   as dec   no-undo.

    find first movto-estoq where rowid(movto-estoq) = pr-movto-estoq no-lock no-error. 

    if avail movto-estoq then do:
        case pi-tipo-custo:
        when 1 or when 0 then  
            assign pde-vlr-nota =  movto-estoq.valor-mat-m[1]  
                                +  movto-estoq.valor-mob-m[1].
        when 2 then  
            assign pde-vlr-nota =  movto-estoq.valor-mat-o[1]  
                                +  movto-estoq.valor-mob-o[1].
        when 3 then  
            assign pde-vlr-nota =  movto-estoq.valor-mat-p[1]  
                                +  movto-estoq.valor-mob-p[1].
        end case.
    end.    

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



/*****************************************************************

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaBrowseGradeFiscal B-table-Win 
PROCEDURE carregaBrowseGradeFiscal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input parameter p-conta-contabil like movto-estoq.conta-contabil.

def var c-conta     as char no-undo.
def var c-it-codigo as char no-undo.
def var c-titulo    as char no-undo.
def var c-sc-codigo as char no-undo.
def var c-ct-codigo as char no-undo.
    
    if l-param and avail movto-estoq then do:                   
        assign c-conta = p-conta-contabil
               c-it-codigo   = if l-param then movto-estoq.it-codigo else "  ".
        
        find conta-contab 
            where conta-contab.ep-codigo = i-ep-codigo-usuario 
              and conta-contab.conta-contabil = p-conta-contabil
              no-lock no-error.
        
        if  not available conta-contab then
            assign c-titulo = "Conta n∆o cadastrada".
        else 
            assign c-ct-codigo = conta-contab.ct-codigo
                   c-sc-codigo = conta-contab.sc-codigo
                   c-titulo    = conta-contab.titulo.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaBrowseGradeFiscal B-table-Win 
PROCEDURE criaBrowseGradeFiscal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input parameter p-rowid       as rowid  no-undo. /*rowid da tabela docum-est*/
def input parameter pi-moeda      as int    no-undo. /*moeda*/
def input parameter pi-tipo-medio as int    no-undo. /*tipo medio*/
def input parameter pl-grade-cont as log    no-undo. /*apresenta grade contabil*/
def input parameter pl-cancela    as log    no-undo. /*Cancela tela de parÉmetros*/

def output parameter pc-conta      as char no-undo.
def output parameter pc-it-codigo  as char no-undo.
def output parameter pc-titulo     as char no-undo.
def output parameter pc-sc-codigo  as char no-undo.
def output parameter pc-ct-codigo  as char no-undo.
def output parameter pd-vl-credito as dec  no-undo.
def output parameter vl-debito     as dec  no-undo.

def var i-moeda as int no-undo.
def var i-tipo  as int no-undo.

   
    find docum-est where rowid(docum-est) = p-rowid no-lock no-error.
  
    if avail docum-est then   
       for first estabelec where
                 estabelec.cod-estabel = docum-est.cod-estabel no-lock: 

    if  not pl-cancela then
        assign i-moeda = pi-moeda + 1
               i-tipo  = pi-tipo-medio
               l-param = pl-grade-cont.
    else do:
        &if  defined(bf_mat_custeio_item) &then
            if  avail estabelec then
            for first estab-mat fields(custo-contab)
                where estab-mat.cod-estabel = estabelec.cod-estabel no-lock:
                assign i-tipo = estab-mat.custo-contab.
            end.
        &else
        if  avail estabelec then
            assign i-tipo = estabelec.custo-contab.
        &endif
    end.
               
    for each movto-estoq where
               movto-estoq.cod-estabel  = docum-est.cod-estabel  and
               movto-estoq.serie-docto  = docum-est.serie-docto  and
               movto-estoq.nro-docto    = docum-est.nro-docto    and              
               movto-estoq.cod-emitente = docum-est.cod-emitente and 
               movto-estoq.nat-operacao = docum-est.nat-operacao no-lock:
               
      if avail movto-estoq then do:    
          find first item 
              where item.it-codigo = movto-estoq.it-codigo no-lock no-error.
          
          find first estabelec 
              where estabelec.cod-estabel = movto-estoq.cod-estabel no-lock no-error.

          find contabiliza 
              where contabiliza.cod-estabel = movto-estoq.cod-estabel 
                and contabiliza.cod-depos   = movto-estoq.cod-depos   
                and contabiliza.ge-codigo   = item.ge-codigo  no-lock no-error.

          run carregaBrowseGradeFiscal (input contabiliza.conta-contabil).

          if  i-tipo = 1 then do: /* mensal */
              /*conteudo da include {rep/re0701.i1 "m"}*/
              if  movto-estoq.tipo-trans = 1 then 
                  assign pd-vl-debito  = pd-vl-debito  
                              + ( movto-estoq.valor-mat-{1}[i-mo] +
                                  movto-estoq.valor-mob-{1}[i-mo] +
                                  movto-estoq.valor-ggf-{1}[i-mo] ).
              else 
                  assign pd-vl-credito = pd-vl-credito +
                               (movto-estoq.valor-mat-{1}[i-mo] +
                                movto-estoq.valor-mob-{1}[i-mo] + 
                                movto-estoq.valor-ggf-{1}[i-mo]).              
          end.
          if  i-tipo = 2 then do: /* on-line */
              {rep/re0701.i1 "o"}
              
          end.
          if  i-tipo = 3 then do: /* padrao */
              {rep/re0701.i1 "p"}
          end.
                    
          run pi-cria-conta ( movto-estoq.conta-contabil ).
          if  movto-estoq.tipo-trans = 1 then  do:
              if  movto-estoq.valor-nota > 0 then
                  assign pd-vl-credito = pd-vl-credito 
                                            + if  i-mo = 1 then 
                                                  movto-estoq.valor-nota
                                              else 
                                                  if  i-mo = i-mo-fasb then
                                                      movto-estoq.vl-nota-fasb[1]
                                                  else
                                                      if  i-mo = i-mo-cmi then
                                                          movto-estoq.vl-nota-fasb[2]
                                                      else 0.
              else do:
                   if  i-tipo = 1 then /* mensal */
                       assign pd-vl-credito = pd-vl-credito 
                                                 + (  movto-estoq.valor-mat-m[i-mo] 
                                                    + movto-estoq.valor-mob-m[i-mo] 
                                                    + movto-estoq.valor-ggf-m[i-mo]).
  
                   if  i-tipo = 2 then /* on-line */
                       assign pd-vl-credito = pd-vl-credito 
                                                 + (  movto-estoq.valor-mat-o[i-mo] 
                                                    + movto-estoq.valor-mob-o[i-mo] 
                                                    + movto-estoq.valor-ggf-o[i-mo]).
        
                   if  i-tipo = 3 then /* padrao */
                       assign pd-vl-credito = pd-vl-credito 
                                                 + (  movto-estoq.valor-mat-p[i-mo] 
                                                    + movto-estoq.valor-mob-p[i-mo] 
                                                    + movto-estoq.valor-ggf-p[i-mo]).
              end.
          end.
          else do:
               if  movto-estoq.valor-nota > 0 then
                   assign pd-vl-debito = pd-vl-debito 
                                            + if  i-mo = 1 then 
                                                  movto-estoq.valor-nota
                                              else 
                                                  if  i-mo = i-mo-fasb then 
                                                      movto-estoq.vl-nota-fasb[1]
                                                  else
                                                      if  i-mo = i-mo-cmi then 
                                                          movto-estoq.vl-nota-fasb[2]
                                                      else 0.
               else do:
                    if  i-tipo = 1 then /* mensal */
                        assign pd-vl-debito = pd-vl-debito 
                                                 + (  movto-estoq.valor-mat-m[i-mo] 
                                                    + movto-estoq.valor-mob-m[i-mo] 
                                                    + movto-estoq.valor-ggf-m[i-mo]).

                    if  i-tipo = 2 then /* on-line */
                        assign pd-vl-debito = pd-vl-debito 
                                                 + (  movto-estoq.valor-mat-o[i-mo] 
                                                    + movto-estoq.valor-mob-o[i-mo] 
                                                    + movto-estoq.valor-ggf-o[i-mo]).

                    if  i-tipo = 3 then /* padrao */
                        assign pd-vl-debito = pd-vl-debito 
                                                 + (  movto-estoq.valor-mat-p[i-mo] 
                                                    + movto-estoq.valor-mob-p[i-mo] 
                                                    + movto-estoq.valor-ggf-p[i-mo]).
               end.
          end.
          
          if  movto-estoq.valor-icm <> 0 then do:
 
              run carregaBrowseGradeFiscal (input estabelec.conta-icms).

              if  movto-estoq.tipo-trans = 1 then
                  assign pd-vl-debito  = pd-vl-debito 
                                            + if  i-mo = 1 then 
                                                  movto-estoq.valor-icm
                                              else
                                                  if  i-mo = i-mo-fasb then 
                                                      movto-estoq.vl-icm-fasb[1]
                                                  else 
                                                      if  i-mo = i-mo-cmi then 
                                                          movto-estoq.vl-icm-fasb[2]
                                                      else 0.
              else
                  assign pd-vl-credito = pd-vl-credito 
                                            + if  i-mo = 1 then 
                                                  movto-estoq.valor-icm
                                              else 
                                                  if  i-mo = i-mo-fasb then 
                                                      movto-estoq.vl-icm-fasb[1]
                                                  else  
                                                      if  i-mo = i-mo-cmi then 
                                                          movto-estoq.vl-icm-fasb[2]
                                                      else 0.
          end.

          if  movto-estoq.valor-ipi <> 0 then do:

              run carregaBrowseGradeFiscal (input estabelec.conta-ipi).

              if  movto-estoq.tipo-trans = 1 then
                  assign pd-vl-debito = pd-vl-debito 
                                           + if  i-mo = 1 then 
                                                 movto-estoq.valor-ipi
                                             else 
                                                if  i-mo = i-mo-fasb then 
                                                    movto-estoq.vl-ipi-fasb[1]
                                                else
                                                    if  i-mo = i-mo-cmi then 
                                                        movto-estoq.vl-ipi-fasb[2]
                                                    else 0.
              else
                  assign pd-vl-credito = pd-vl-credito 
                                            + if  i-mo = 1 then 
                                                  movto-estoq.valor-ipi
                                              else 
                                                  if  i-mo = i-mo-fasb then 
                                                      movto-estoq.vl-ipi-fasb[1]
                                                  else 
                                                      if  i-mo = i-mo-cmi then 
                                                          movto-estoq.vl-ipi-fasb[2]
                                                      else 0.
          end.
      end.    
    end.

      assign pc-conta     = c-conta
             pc-it-codigo = c-it-codigo
             pc-titulo    = c-titulo
             pc-sc-codigo = c-sc-codigo
             pc-ct-codigo = c-ct-codigo.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



**************************************************************************/
