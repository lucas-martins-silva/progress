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
{include/i-prgvrs.i BOIN356Q04 2.00.00.005} /*** "010005" 24/11/2023 13:25:22  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin356q04 MUT}
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
&GLOBAL-DEFINE DBOName prazo-compra
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName prazo-compra
&GLOBAL-DEFINE TableLabel prazo-compra
&GLOBAL-DEFINE QueryName qr{&TableName}

/*********************************************************************************
**  S¢ a DBO principal (boin356.p) est† com as funá‰es de inclui (createRecord), 
**  modifica (updateRecord) e elimina (deleteRecord) habilitadas, 
**  porque S‡ nela foram implementadas as triggers do dicion†rio.
**  Para desabilitar as procedures foram usados os prÇ-processadores abaixo.
**  A procedure validateRecord dessa DBO n∆o deve ser usada.
*********************************************************************************/
&GLOBAL-DEFINE EXCLUDE-createRecord 0
&GLOBAL-DEFINE EXCLUDE-updateRecord 0
&GLOBAL-DEFINE EXCLUDE-deleteRecord 0


/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com
      extens∆o .i ---*/
{inbo/boin356q01.i RowObject}

/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o
      manual da query ---*/
/*{method/dboqry.i}*/

DEFINE QUERY {&QueryName} for {&TableName}, ordem-compra scrolling.

/* Include com prÇ-processadores que diferenciam releases */
{cdp/cdcfgmat.i}

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/*---------------- SETCONSTRAINT1---------------------*/
DEF VAR dtEntregaIni     AS DATE NO-UNDO initial &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF.
DEF VAR dtEntregaFim     AS DATE NO-UNDO initial 12/31/9999.
DEF VAR dtEmissIni       AS DATE NO-UNDO initial &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF.
DEF VAR dtEmissFim       AS DATE NO-UNDO initial 12/31/9999.
DEF VAR iSituacao        AS INTE NO-UNDO initial 1.
DEF VAR iFornecIni       AS INTE NO-UNDO initial 0.
DEF VAR iFornecFim       AS INTE NO-UNDO initial 999999999.
DEF VAR cEstabelIni      AS CHAR NO-UNDO initial "".
&IF "{&mguni_version}" >= "2.071" &THEN
DEF VAR cEstabelFim      AS CHAR NO-UNDO initial "ZZZZZ".
&ELSE
DEF VAR cEstabelFim      AS CHAR NO-UNDO initial "ZZZ".
&ENDIF
DEF VAR cDepIni          AS CHAR NO-UNDO initial "".
DEF VAR cDepFim          AS CHAR NO-UNDO initial "ZZZ".
DEF VAR cItemIni         AS CHAR NO-UNDO initial "".
DEF VAR cItemFim         AS CHAR NO-UNDO initial "ZZZZZZZZZZZZZZZZ".
DEF VAR cCompradorIni    AS CHAR NO-UNDO initial "".
DEF VAR cCompradorFim    AS CHAR NO-UNDO initial "ZZZZZZZZZZZZ".
DEF VAR cRequisitanteIni AS CHAR NO-UNDO initial "".
DEF VAR cRequisitanteFim AS CHAR NO-UNDO initial "ZZZZZZZZZZZZ".

/*----------------------------------------------------*/

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
         HEIGHT             = 5.13
         WIDTH              = 50.14.
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


&IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
   &GLOBAL-DEFINE v9indrep  INDEXED-REPOSITION
&endif

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCopyBuffer2TT DBOProgram 
PROCEDURE afterCopyBuffer2TT :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*ASSIGN RowObject.r-RowidOrdem = rowid(ordem-compra).*/
    ASSIGN RowObject.r-RowidOrdem = rowid(ordem-compra).

    RETURN "OK":U.
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
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "item-cotacao":U THEN ASSIGN pFieldValue = RowObject.item-cotacao.
        WHEN "nome-abrev":U THEN ASSIGN pFieldValue = RowObject.nome-abrev.
        &if defined(bf_mat_contratos) &then
        &else WHEN "nr-contrato":U THEN ASSIGN pFieldValue = RowObject.nr-contrato.
        &endif
        WHEN "pedido-clien":U THEN ASSIGN pFieldValue = RowObject.pedido-clien.
        WHEN "un":U THEN ASSIGN pFieldValue = RowObject.un.
        WHEN "usuario-alt":U THEN ASSIGN pFieldValue = RowObject.usuario-alt.
        WHEN "cc-codigo":U THEN ASSIGN pFieldValue = RowObject.cc-codigo.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
        WHEN "es-codigo":U THEN ASSIGN pFieldValue = RowObject.es-codigo.
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
        WHEN "data-alter":U THEN ASSIGN pFieldValue = RowObject.data-alter.
        WHEN "data-entrega":U THEN ASSIGN pFieldValue = RowObject.data-entrega.
        WHEN "data-orig":U THEN ASSIGN pFieldValue = RowObject.data-orig.
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
        WHEN "qtd-a-ped-forn":U THEN ASSIGN pFieldValue = RowObject.qtd-a-ped-forn.
        WHEN "qtd-do-forn":U THEN ASSIGN pFieldValue = RowObject.qtd-do-forn.
        WHEN "qtd-rec-forn":U THEN ASSIGN pFieldValue = RowObject.qtd-rec-forn.
        WHEN "qtd-rej-forn":U THEN ASSIGN pFieldValue = RowObject.qtd-rej-forn.
        WHEN "qtd-sal-forn":U THEN ASSIGN pFieldValue = RowObject.qtd-sal-forn.
        WHEN "quant-a-ped":U THEN ASSIGN pFieldValue = RowObject.quant-a-ped.
        WHEN "quant-receb":U THEN ASSIGN pFieldValue = RowObject.quant-receb.
        WHEN "quant-rejeit":U THEN ASSIGN pFieldValue = RowObject.quant-rejeit.
        WHEN "quant-saldo":U THEN ASSIGN pFieldValue = RowObject.quant-saldo.
        WHEN "quantid-orig":U THEN ASSIGN pFieldValue = RowObject.quantid-orig.
        WHEN "quantidade":U THEN ASSIGN pFieldValue = RowObject.quantidade.
        WHEN "rendimento":U THEN ASSIGN pFieldValue = RowObject.rendimento.
        WHEN "concentracao":U THEN ASSIGN pFieldValue = RowObject.concentracao.
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
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
        WHEN "hora":U THEN ASSIGN pFieldValue = RowObject.hora.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "MRP":U THEN ASSIGN pFieldValue = RowObject.MRP.
        WHEN "natureza":U THEN ASSIGN pFieldValue = RowObject.natureza.
        WHEN "nr-alt-data":U THEN ASSIGN pFieldValue = RowObject.nr-alt-data.
        WHEN "nr-alt-quant":U THEN ASSIGN pFieldValue = RowObject.nr-alt-quant.
        WHEN "nr-entrega":U THEN ASSIGN pFieldValue = RowObject.nr-entrega.
        &if defined(bf_mat_contratos) &then
        when "nr-contrato" then ASSIGN pFieldValue = RowObject.nr-contrato.
        &endif        
        WHEN "nr-estrut":U THEN ASSIGN pFieldValue = RowObject.nr-estrut.
        WHEN "nr-estrut-filha":U THEN ASSIGN pFieldValue = RowObject.nr-estrut-filha.
        WHEN "nr-sequencia":U THEN ASSIGN pFieldValue = RowObject.nr-sequencia.
        WHEN "numero-ordem":U THEN ASSIGN pFieldValue = RowObject.numero-ordem.
        WHEN "parcela":U THEN ASSIGN pFieldValue = RowObject.parcela.
        WHEN "sequencia":U THEN ASSIGN pFieldValue = RowObject.sequencia.
        WHEN "situacao":U THEN ASSIGN pFieldValue = RowObject.situacao.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice CLIENTE-PEDIDO
  Parameters:
               retorna valor dos campos do °ndice CLIENTE-PEDIDO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnome-abrev LIKE prazo-compra.nome-abrev NO-UNDO.
    DEFINE OUTPUT PARAMETER ppedido-clien LIKE prazo-compra.pedido-clien NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-sequencia LIKE prazo-compra.nr-sequencia NO-UNDO.
    DEFINE OUTPUT PARAMETER pnumero-ordem LIKE prazo-compra.numero-ordem NO-UNDO.
    DEFINE OUTPUT PARAMETER pparcela LIKE prazo-compra.parcela NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pnome-abrev   = RowObject.nome-abrev
           ppedido-clien = RowObject.pedido-clien
           pnr-sequencia = RowObject.nr-sequencia
           pnumero-ordem = RowObject.numero-ordem
           pparcela      = RowObject.parcela.

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
        WHEN "expectativa":U THEN ASSIGN pFieldValue = RowObject.expectativa.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "ordem-emitida":U THEN ASSIGN pFieldValue = RowObject.ordem-emitida.
        WHEN "cod-alter":U THEN ASSIGN pFieldValue = RowObject.cod-alter.
        WHEN "cons-mrp":U THEN ASSIGN pFieldValue = RowObject.cons-mrp.
        WHEN "cons-pmp":U THEN ASSIGN pFieldValue = RowObject.cons-pmp.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRowidField DBOProgram 
PROCEDURE getRowidField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo ROWID
  Parameters:
               recebe nome do campo
               retorna valor do campo
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS Rowid NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        when "r-RowidOrdem" then assign pFieldValue = RowObject.r-RowidOrdem.
        when "r-Rowid"      then assign pFieldValue = RowObject.r-Rowid.
        OTHERWISE RETURN "NOK":U.
    END CASE.

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
    define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 2 then 
            run openQueryStatic ("ByNumOrdem":U).
    end case.
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByNumOrdem DBOProgram 
PROCEDURE openQueryByNumOrdem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    open query {&QUERYNAME} for each {&TABLENAME} USE-INDEX data where
                                     {&TABLENAME}.data-entrega >= dtEntregaIni       and
                                     {&TABLENAME}.data-entrega <= dtEntregaFim
                                     no-lock,
                             first ordem-compra where 
                                   ordem-compra.numero-ordem =  {&TABLENAME}.numero-ordem and
                                   ordem-compra.cod-emitente >= iFornecIni                and
                                   ordem-compra.cod-emitente <= iFornecFim                and
                                   ordem-compra.data-emissao >= dtEmissIni                and
                                   ordem-compra.data-emissao <= dtEmissFim                and
                                   ordem-compra.cod-estabel  >= cEstabelIni               and
                                   ordem-compra.cod-estabel  <= cEstabelFim               and
                                   ordem-compra.dep-almoxar  >= cDepIni                   and
                                   ordem-compra.dep-almoxar  <= cDepFim                   no-lock {&v9indrep}.
    return "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByNumOrdemSit DBOProgram 
PROCEDURE openQueryByNumOrdemSit :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    open query {&QUERYNAME} for each {&TABLENAME} USE-INDEX data where
                                     {&TABLENAME}.data-entrega >= dtEntregaIni       and
                                     {&TABLENAME}.data-entrega <= dtEntregaFim       and
                                     {&TABLENAME}.situacao      =  iSituacao         
                                     NO-LOCK,
                             first ordem-compra where 
                                   ordem-compra.numero-ordem =  {&TABLENAME}.numero-ordem and
                                   ordem-compra.cod-emitente >= iFornecIni                and
                                   ordem-compra.cod-emitente <= iFornecFim                and
                                   ordem-compra.data-emissao >= dtEmissIni                and
                                   ordem-compra.data-emissao <= dtEmissFim                and
                                   ordem-compra.cod-estabel  >= cEstabelIni               and
                                   ordem-compra.cod-estabel  <= cEstabelFim               and
                                   ordem-compra.dep-almoxar  >= cDepIni                   and
                                   ordem-compra.dep-almoxar  <= cDepFim                   no-lock {&v9indrep}.
    return "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByItem DBOProgram 
PROCEDURE setConstraintByItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   define input parameter pcItemIni          as char no-undo.
   define input parameter pcItemFim          as char no-undo.

   assign cItemIni         = pcItemIni
          cItemFim         = pcItemFim.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByNumOrdem DBOProgram 
PROCEDURE setConstraintByNumOrdem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   define input parameter pdtEntregaIni     as date no-undo.
   define input parameter pdtEntregaFim     as date no-undo.
   define input parameter pdtEmissIni       as date no-undo.
   define input parameter pdtEmissFim       as date no-undo.
   define input parameter piFornecIni       as int  no-undo.
   define input parameter piFornecFim       as int  no-undo.
   define input parameter pcEstabelIni      as char no-undo.
   define input parameter pcEstabelFim      as char no-undo.
   define input parameter pcDepIni          as char no-undo.
   define input parameter pcDepFim          as char no-undo.

   assign dtEntregaIni    = pdtEntregaIni
          dtEntregaFim    = pdtEntregaFim
          dtEmissIni      = pdtEmissIni
          dtEmissFim      = pdtEmissFim
          iFornecIni      = piFornecIni
          iFornecFim      = piFornecFim
          cEstabelIni     = pcEstabelIni
          cEstabelFim     = pcEstabelFim
          cDepIni         = pcDepIni
          cDepFim         = pcDepFim.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByNumOrdemSit DBOProgram 
PROCEDURE setConstraintByNumOrdemSit :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   define input parameter pdtEntregaIni     as date no-undo.
   define input parameter pdtEntregaFim     as date no-undo.
   define input parameter pdtEmissIni       as date no-undo.
   define input parameter pdtEmissFim       as date no-undo.
   define input parameter piSituacao        as int  no-undo.
   define input parameter piFornecIni       as int  no-undo.
   define input parameter piFornecFim       as int  no-undo.
   define input parameter pcEstabelIni      as char no-undo.
   define input parameter pcEstabelFim      as char no-undo.
   define input parameter pcDepIni          as char no-undo.
   define input parameter pcDepFim          as char no-undo.

   assign dtEntregaIni    = pdtEntregaIni
          dtEntregaFim    = pdtEntregaFim
          dtEmissIni      = pdtEmissIni
          dtEmissFim      = pdtEmissFim
          iSituacao       = piSituacao
          iFornecIni      = piFornecIni
          iFornecFim      = piFornecFim
          cEstabelIni     = pcEstabelIni
          cEstabelFim     = pcEstabelFim
          cDepIni         = pcDepIni
          cDepFim         = pcDepFim.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

