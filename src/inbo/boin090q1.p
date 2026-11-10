&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/***************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
***************************************************************************/
{include/i-prgvrs.i BOIN090Q1 2.00.00.011 } /*** "010011" 17/06/2025 16:40:45 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin090q1 MUT}
&ENDIF

/*:T------------------------------------------------------------------------
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

/*:T--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName BOIN090
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName docum-est
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

/*:T--- Include com defini‡Æo da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com 
      extensÆo .i ---*/
{inbo/boin090.i RowObject}
{cdp/cdcfgdis.i}



/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
/*{method/dboqry.i}*/

DEFINE QUERY {&QueryName} FOR docum-est, estabelec, emitente  SCROLLING.

/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE cCodEstIni     LIKE docum-est.cod-estabel  NO-UNDO.
DEFINE VARIABLE cCodEstFim     LIKE docum-est.cod-estabel  NO-UNDO.
DEFINE VARIABLE cNroDoctoIni   LIKE docum-est.nro-docto    NO-UNDO.
DEFINE VARIABLE cNroDoctoFim   LIKE docum-est.nro-docto    NO-UNDO.
DEFINE VARIABLE cSerieDoctoIni LIKE docum-est.serie-docto  NO-UNDO.
DEFINE VARIABLE cSerieDoctoFim LIKE docum-est.serie-docto  NO-UNDO.
DEFINE VARIABLE iCodEmitIni    LIKE docum-est.cod-emitente NO-UNDO.
DEFINE VARIABLE iCodEmitFim    LIKE docum-est.cod-emitente NO-UNDO.
DEFINE VARIABLE cNatOperIni    LIKE docum-est.nat-operacao NO-UNDO.
DEFINE VARIABLE cNatOperFim    LIKE docum-est.nat-operacao NO-UNDO.
DEFINE VARIABLE dDatEmisIni    LIKE docum-est.dt-emissao      NO-UNDO.
DEFINE VARIABLE dDatEmisFim    LIKE docum-est.dt-emissao      NO-UNDO.
DEFINE VARIABLE lFatura        LIKE docum-est.nff          NO-UNDO.

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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "c-nr-invoice":U THEN ASSIGN pFieldValue = RowObject.c-nr-invoice.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-imp-irf":U THEN ASSIGN pFieldValue = RowObject.cod-imp-irf.
        WHEN "conta-transit":U THEN ASSIGN pFieldValue = RowObject.conta-transit.
        WHEN "ct-transit":U THEN ASSIGN pFieldValue = RowObject.ct-transit.
        WHEN "declaracao-import":U THEN ASSIGN pFieldValue = RowObject.declaracao-import.
        WHEN "embalagem":U THEN ASSIGN pFieldValue = RowObject.embalagem.
        WHEN "embarque":U THEN ASSIGN pFieldValue = RowObject.embarque.
        WHEN "esp-fiscal":U THEN ASSIGN pFieldValue = RowObject.esp-fiscal.
        WHEN "esp-irf":U THEN ASSIGN pFieldValue = RowObject.esp-irf.
        WHEN "estab-de-or":U THEN ASSIGN pFieldValue = RowObject.estab-de-or.
        WHEN "estab-fisc":U THEN ASSIGN pFieldValue = RowObject.estab-fisc.
        WHEN "hr-atualiza":U THEN ASSIGN pFieldValue = RowObject.hr-atualiza.
        WHEN "nat-operacao":U THEN ASSIGN pFieldValue = RowObject.nat-operacao.
        WHEN "nro-docto":U THEN ASSIGN pFieldValue = RowObject.nro-docto.
        WHEN "observacao":U THEN ASSIGN pFieldValue = RowObject.observacao.
        WHEN "ok-observ":U THEN ASSIGN pFieldValue = RowObject.ok-observ.
        WHEN "ok-user":U THEN ASSIGN pFieldValue = RowObject.ok-user.
        WHEN "origem":U THEN ASSIGN pFieldValue = RowObject.origem.
        WHEN "pais-origem":U THEN ASSIGN pFieldValue = RowObject.pais-origem.
        WHEN "sc-transit":U THEN ASSIGN pFieldValue = RowObject.sc-transit.
        WHEN "serie-docto":U THEN ASSIGN pFieldValue = RowObject.serie-docto.
        WHEN "uf":U THEN ASSIGN pFieldValue = RowObject.uf.
        WHEN "usuario":U THEN ASSIGN pFieldValue = RowObject.usuario.
        WHEN "cod-modalid-frete":U THEN ASSIGN pFieldValue = &IF '{&BF_DIS_VERSAO_EMS}' >= '2.09'
                                                             &THEN RowObject.cod-modalid-frete.
                                                             &ELSE SUBSTRING(RowObject.char-2,143,8).
                                                             &ENDIF
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
        WHEN "dt-atualiza":U THEN ASSIGN pFieldValue = RowObject.dt-atualiza.
        WHEN "dt-emissao":U THEN ASSIGN pFieldValue = RowObject.dt-emissao.
        WHEN "dt-entr-merc":U THEN ASSIGN pFieldValue = RowObject.dt-entr-merc.
        WHEN "dt-trans":U THEN ASSIGN pFieldValue = RowObject.dt-trans.
        WHEN "dt-venc-icm":U THEN ASSIGN pFieldValue = RowObject.dt-venc-icm.
        WHEN "dt-venc-ipi":U THEN ASSIGN pFieldValue = RowObject.dt-venc-ipi.
        WHEN "dt-venc-iss":U THEN ASSIGN pFieldValue = RowObject.dt-venc-iss.
        WHEN "ok-data":U THEN ASSIGN pFieldValue = RowObject.ok-data.
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
        WHEN "aliq-irf":U THEN ASSIGN pFieldValue = RowObject.aliq-irf.
        WHEN "aliquota-icm":U THEN ASSIGN pFieldValue = RowObject.aliquota-icm.
        WHEN "aliquota-iss":U THEN ASSIGN pFieldValue = RowObject.aliquota-iss.
        WHEN "base-cofins-subs":U THEN ASSIGN pFieldValue = RowObject.base-cofins-subs.
        WHEN "base-icm":U THEN ASSIGN pFieldValue = RowObject.base-icm.
        WHEN "base-icm-fas[1]":U THEN ASSIGN pFieldValue = RowObject.base-icm-fas[1].
        WHEN "base-icm-fas[2]":U THEN ASSIGN pFieldValue = RowObject.base-icm-fas[2].
        WHEN "base-ipi":U THEN ASSIGN pFieldValue = RowObject.base-ipi.
        WHEN "base-ipi-fas[1]":U THEN ASSIGN pFieldValue = RowObject.base-ipi-fas[1].
        WHEN "base-ipi-fas[2]":U THEN ASSIGN pFieldValue = RowObject.base-ipi-fas[2].
        WHEN "base-iss":U THEN ASSIGN pFieldValue = RowObject.base-iss.
        WHEN "base-iss-fas[1]":U THEN ASSIGN pFieldValue = RowObject.base-iss-fas[1].
        WHEN "base-iss-fas[2]":U THEN ASSIGN pFieldValue = RowObject.base-iss-fas[2].
        WHEN "base-pis-subs":U THEN ASSIGN pFieldValue = RowObject.base-pis-subs.
        WHEN "base-subs":U THEN ASSIGN pFieldValue = RowObject.base-subs.
        WHEN "base-subs-fasb[1]":U THEN ASSIGN pFieldValue = RowObject.base-subs-fasb[1].
        WHEN "base-subs-fasb[2]":U THEN ASSIGN pFieldValue = RowObject.base-subs-fasb[2].
        WHEN "cotacao-dia":U THEN ASSIGN pFieldValue = RowObject.cotacao-dia.
        WHEN "cotacao-fasb":U THEN ASSIGN pFieldValue = RowObject.cotacao-fasb.
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "desp-fasb[1]":U THEN ASSIGN pFieldValue = RowObject.desp-fasb[1].
        WHEN "desp-fasb[2]":U THEN ASSIGN pFieldValue = RowObject.desp-fasb[2].
        WHEN "despesa-nota":U THEN ASSIGN pFieldValue = RowObject.despesa-nota.
        WHEN "despesa-nota-me":U THEN ASSIGN pFieldValue = RowObject.despesa-nota-me.
        WHEN "icm-complem":U THEN ASSIGN pFieldValue = RowObject.icm-complem.
        WHEN "icm-cpl-fasb[1]":U THEN ASSIGN pFieldValue = RowObject.icm-cpl-fasb[1].
        WHEN "icm-cpl-fasb[2]":U THEN ASSIGN pFieldValue = RowObject.icm-cpl-fasb[2].
        WHEN "icm-dc-fasb[1]":U THEN ASSIGN pFieldValue = RowObject.icm-dc-fasb[1].
        WHEN "icm-dc-fasb[2]":U THEN ASSIGN pFieldValue = RowObject.icm-dc-fasb[2].
        WHEN "icm-deb-cre":U THEN ASSIGN pFieldValue = RowObject.icm-deb-cre.
        WHEN "icm-fnt-fasb[1]":U THEN ASSIGN pFieldValue = RowObject.icm-fnt-fasb[1].
        WHEN "icm-fnt-fasb[2]":U THEN ASSIGN pFieldValue = RowObject.icm-fnt-fasb[2].
        WHEN "icm-fonte":U THEN ASSIGN pFieldValue = RowObject.icm-fonte.
        WHEN "icm-nao-trib":U THEN ASSIGN pFieldValue = RowObject.icm-nao-trib.
        WHEN "icm-ntr-fasb[1]":U THEN ASSIGN pFieldValue = RowObject.icm-ntr-fasb[1].
        WHEN "icm-ntr-fasb[2]":U THEN ASSIGN pFieldValue = RowObject.icm-ntr-fasb[2].
        WHEN "icm-out-fasb[1]":U THEN ASSIGN pFieldValue = RowObject.icm-out-fasb[1].
        WHEN "icm-out-fasb[2]":U THEN ASSIGN pFieldValue = RowObject.icm-out-fasb[2].
        WHEN "icm-outras":U THEN ASSIGN pFieldValue = RowObject.icm-outras.
        WHEN "imp-import":U THEN ASSIGN pFieldValue = RowObject.imp-import.
        WHEN "ipi-dc-fasb[1]":U THEN ASSIGN pFieldValue = RowObject.ipi-dc-fasb[1].
        WHEN "ipi-dc-fasb[2]":U THEN ASSIGN pFieldValue = RowObject.ipi-dc-fasb[2].
        WHEN "ipi-deb-cre":U THEN ASSIGN pFieldValue = RowObject.ipi-deb-cre.
        WHEN "ipi-despesa":U THEN ASSIGN pFieldValue = RowObject.ipi-despesa.
        WHEN "ipi-nao-trib":U THEN ASSIGN pFieldValue = RowObject.ipi-nao-trib.
        WHEN "ipi-ntr-fasb[1]":U THEN ASSIGN pFieldValue = RowObject.ipi-ntr-fasb[1].
        WHEN "ipi-ntr-fasb[2]":U THEN ASSIGN pFieldValue = RowObject.ipi-ntr-fasb[2].
        WHEN "ipi-out-fasb[1]":U THEN ASSIGN pFieldValue = RowObject.ipi-out-fasb[1].
        WHEN "ipi-out-fasb[2]":U THEN ASSIGN pFieldValue = RowObject.ipi-out-fasb[2].
        WHEN "ipi-outras":U THEN ASSIGN pFieldValue = RowObject.ipi-outras.
        WHEN "iss-dc-fasb[1]":U THEN ASSIGN pFieldValue = RowObject.iss-dc-fasb[1].
        WHEN "iss-dc-fasb[2]":U THEN ASSIGN pFieldValue = RowObject.iss-dc-fasb[2].
        WHEN "iss-deb-cre":U THEN ASSIGN pFieldValue = RowObject.iss-deb-cre.
        WHEN "iss-nao-trib":U THEN ASSIGN pFieldValue = RowObject.iss-nao-trib.
        WHEN "iss-ntr-fasb[1]":U THEN ASSIGN pFieldValue = RowObject.iss-ntr-fasb[1].
        WHEN "iss-ntr-fasb[2]":U THEN ASSIGN pFieldValue = RowObject.iss-ntr-fasb[2].
        WHEN "iss-out-fasb[1]":U THEN ASSIGN pFieldValue = RowObject.iss-out-fasb[1].
        WHEN "iss-out-fasb[2]":U THEN ASSIGN pFieldValue = RowObject.iss-out-fasb[2].
        WHEN "iss-outras":U THEN ASSIGN pFieldValue = RowObject.iss-outras.
        WHEN "perc-tax-div":U THEN ASSIGN pFieldValue = RowObject.perc-tax-div.
        WHEN "perc-tax-emb":U THEN ASSIGN pFieldValue = RowObject.perc-tax-emb.
        WHEN "perc-tax-fre":U THEN ASSIGN pFieldValue = RowObject.perc-tax-fre.
        WHEN "perc-tax-seg":U THEN ASSIGN pFieldValue = RowObject.perc-tax-seg.
        WHEN "qt-tot-imp":U THEN ASSIGN pFieldValue = RowObject.qt-tot-imp.
        WHEN "taxa-conv-imp":U THEN ASSIGN pFieldValue = RowObject.taxa-conv-imp.
        WHEN "tot-des-fasb[1]":U THEN ASSIGN pFieldValue = RowObject.tot-des-fasb[1].
        WHEN "tot-des-fasb[2]":U THEN ASSIGN pFieldValue = RowObject.tot-des-fasb[2].
        WHEN "tot-desconto":U THEN ASSIGN pFieldValue = RowObject.tot-desconto.
        WHEN "tot-desconto-me":U THEN ASSIGN pFieldValue = RowObject.tot-desconto-me.
        WHEN "tot-peso":U THEN ASSIGN pFieldValue = RowObject.tot-peso.
        WHEN "tot-taxa":U THEN ASSIGN pFieldValue = RowObject.tot-taxa.
        WHEN "tot-taxa-me":U THEN ASSIGN pFieldValue = RowObject.tot-taxa-me.
        WHEN "tot-valor":U THEN ASSIGN pFieldValue = RowObject.tot-valor.
        WHEN "tot-valor-me":U THEN ASSIGN pFieldValue = RowObject.tot-valor-me.
        WHEN "tot-vl-fasb[1]":U THEN ASSIGN pFieldValue = RowObject.tot-vl-fasb[1].
        WHEN "tot-vl-fasb[2]":U THEN ASSIGN pFieldValue = RowObject.tot-vl-fasb[2].
        WHEN "valor-embal":U THEN ASSIGN pFieldValue = RowObject.valor-embal.
        WHEN "valor-embal-me":U THEN ASSIGN pFieldValue = RowObject.valor-embal-me.
        WHEN "valor-frete":U THEN ASSIGN pFieldValue = RowObject.valor-frete.
        WHEN "valor-frete-me":U THEN ASSIGN pFieldValue = RowObject.valor-frete-me.
        WHEN "valor-irf":U THEN ASSIGN pFieldValue = RowObject.valor-irf.
        WHEN "valor-mercad":U THEN ASSIGN pFieldValue = RowObject.valor-mercad.
        WHEN "valor-mercad-me":U THEN ASSIGN pFieldValue = RowObject.valor-mercad-me.
        WHEN "valor-outras":U THEN ASSIGN pFieldValue = RowObject.valor-outras.
        WHEN "valor-outras-me":U THEN ASSIGN pFieldValue = RowObject.valor-outras-me.
        WHEN "valor-seguro":U THEN ASSIGN pFieldValue = RowObject.valor-seguro.
        WHEN "valor-seguro-me":U THEN ASSIGN pFieldValue = RowObject.valor-seguro-me.
        WHEN "vl-cofins-subs":U THEN ASSIGN pFieldValue = RowObject.vl-cofins-subs.
        WHEN "vl-emb-fasb[1]":U THEN ASSIGN pFieldValue = RowObject.vl-emb-fasb[1].
        WHEN "vl-emb-fasb[2]":U THEN ASSIGN pFieldValue = RowObject.vl-emb-fasb[2].
        WHEN "vl-fre-fasb[1]":U THEN ASSIGN pFieldValue = RowObject.vl-fre-fasb[1].
        WHEN "vl-fre-fasb[2]":U THEN ASSIGN pFieldValue = RowObject.vl-fre-fasb[2].
        WHEN "vl-imp-embalagem":U THEN ASSIGN pFieldValue = RowObject.vl-imp-embalagem.
        WHEN "vl-imp-embalagem-me":U THEN ASSIGN pFieldValue = RowObject.vl-imp-embalagem-me.
        WHEN "vl-imp-frete":U THEN ASSIGN pFieldValue = RowObject.vl-imp-frete.
        WHEN "vl-imp-frete-me":U THEN ASSIGN pFieldValue = RowObject.vl-imp-frete-me.
        WHEN "vl-imp-impor[1]":U THEN ASSIGN pFieldValue = RowObject.vl-imp-impor[1].
        WHEN "vl-imp-impor[2]":U THEN ASSIGN pFieldValue = RowObject.vl-imp-impor[2].
        WHEN "vl-imp-outras":U THEN ASSIGN pFieldValue = RowObject.vl-imp-outras.
        WHEN "vl-imp-outras-me":U THEN ASSIGN pFieldValue = RowObject.vl-imp-outras-me.
        WHEN "vl-imp-seguro":U THEN ASSIGN pFieldValue = RowObject.vl-imp-seguro.
        WHEN "vl-imp-seguro-me":U THEN ASSIGN pFieldValue = RowObject.vl-imp-seguro-me.
        WHEN "vl-merc-fasb[1]":U THEN ASSIGN pFieldValue = RowObject.vl-merc-fasb[1].
        WHEN "vl-merc-fasb[2]":U THEN ASSIGN pFieldValue = RowObject.vl-merc-fasb[2].
        WHEN "vl-out-fasb[1]":U THEN ASSIGN pFieldValue = RowObject.vl-out-fasb[1].
        WHEN "vl-out-fasb[2]":U THEN ASSIGN pFieldValue = RowObject.vl-out-fasb[2].
        WHEN "vl-pis-subs":U THEN ASSIGN pFieldValue = RowObject.vl-pis-subs.
        WHEN "vl-seg-fasb[1]":U THEN ASSIGN pFieldValue = RowObject.vl-seg-fasb[1].
        WHEN "vl-seg-fasb[2]":U THEN ASSIGN pFieldValue = RowObject.vl-seg-fasb[2].
        WHEN "vl-subs":U THEN ASSIGN pFieldValue = RowObject.vl-subs.
        WHEN "vl-subs-fasb[1]":U THEN ASSIGN pFieldValue = RowObject.vl-subs-fasb[1].
        WHEN "vl-subs-fasb[2]":U THEN ASSIGN pFieldValue = RowObject.vl-subs-fasb[2].
        WHEN "vl-tax-diversos":U THEN ASSIGN pFieldValue = RowObject.vl-tax-diversos.
        WHEN "vl-tax-frete":U THEN ASSIGN pFieldValue = RowObject.vl-tax-frete.
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
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "cod-ibge":U THEN ASSIGN pFieldValue = RowObject.cod-ibge.
        WHEN "cod-imp-embal":U THEN ASSIGN pFieldValue = RowObject.cod-imp-embal.
        WHEN "cod-imp-frete":U THEN ASSIGN pFieldValue = RowObject.cod-imp-frete.
        WHEN "cod-imp-outras":U THEN ASSIGN pFieldValue = RowObject.cod-imp-outras.
        WHEN "cod-imp-seguro":U THEN ASSIGN pFieldValue = RowObject.cod-imp-seguro.
        WHEN "cod-observa":U THEN ASSIGN pFieldValue = RowObject.cod-observa.
        WHEN "cod-ret-irf":U THEN ASSIGN pFieldValue = RowObject.cod-ret-irf.
        WHEN "cod-tax-div":U THEN ASSIGN pFieldValue = RowObject.cod-tax-div.
        WHEN "cod-tax-fre":U THEN ASSIGN pFieldValue = RowObject.cod-tax-fre.
        WHEN "dia-util-irf":U THEN ASSIGN pFieldValue = RowObject.dia-util-irf.
        WHEN "esp-docto":U THEN ASSIGN pFieldValue = RowObject.esp-docto.
        WHEN "estado":U THEN ASSIGN pFieldValue = RowObject.estado.
        WHEN "i-sequencia":U THEN ASSIGN pFieldValue = RowObject.i-sequencia.
        WHEN "ind-orig-entrada":U THEN ASSIGN pFieldValue = RowObject.ind-orig-entrada.
        WHEN "ind-via-envio":U THEN ASSIGN pFieldValue = RowObject.ind-via-envio.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "mo-codigo":U THEN ASSIGN pFieldValue = RowObject.mo-codigo.
        WHEN "mod-atual":U THEN ASSIGN pFieldValue = RowObject.mod-atual.
        WHEN "mod-frete":U THEN ASSIGN pFieldValue = RowObject.mod-frete.
        WHEN "nro-proc-entrada":U THEN ASSIGN pFieldValue = RowObject.nro-proc-entrada.
        WHEN "nro-proc-saida":U THEN ASSIGN pFieldValue = RowObject.nro-proc-saida.
        WHEN "ok-fornec":U THEN ASSIGN pFieldValue = RowObject.ok-fornec.
        WHEN "rateia-frete":U THEN ASSIGN pFieldValue = RowObject.rateia-frete.
        WHEN "sit-atual":U THEN ASSIGN pFieldValue = RowObject.sit-atual.
        WHEN "sit-docum":U THEN ASSIGN pFieldValue = RowObject.sit-docum.
        WHEN "sit-edi":U THEN ASSIGN pFieldValue = RowObject.sit-edi.
        WHEN "tipo-docto":U THEN ASSIGN pFieldValue = RowObject.tipo-docto.
        WHEN "tipo-nota":U THEN ASSIGN pFieldValue = RowObject.tipo-nota.
        WHEN "tp-rat-fret":U THEN ASSIGN pFieldValue = RowObject.tp-rat-fret.
        WHEN "via-transp":U THEN ASSIGN pFieldValue = RowObject.via-transp.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice documento
  Parameters:  
               retorna valor do campo serie-docto
               retorna valor do campo nro-docto
               retorna valor do campo cod-emitente
               retorna valor do campo nat-operacao
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pserie-docto LIKE docum-est.serie-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pnro-docto LIKE docum-est.nro-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE docum-est.cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pnat-operacao LIKE docum-est.nat-operacao NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pserie-docto = RowObject.serie-docto
           pnro-docto = RowObject.nro-docto
           pcod-emitente = RowObject.cod-emitente
           pnat-operacao = RowObject.nat-operacao.

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
        WHEN "acresc-financ":U THEN ASSIGN pFieldValue = RowObject.acresc-financ.
        WHEN "ap-atual":U THEN ASSIGN pFieldValue = RowObject.ap-atual.
        WHEN "atual-ft":U THEN ASSIGN pFieldValue = RowObject.atual-ft.
        WHEN "atualiza-cr":U THEN ASSIGN pFieldValue = RowObject.atualiza-cr.
        WHEN "CE-atual":U THEN ASSIGN pFieldValue = RowObject.CE-atual.
        WHEN "cp-atual":U THEN ASSIGN pFieldValue = RowObject.cp-atual.
        WHEN "cr-atual":U THEN ASSIGN pFieldValue = RowObject.cr-atual.
        WHEN "estorn-comis":U THEN ASSIGN pFieldValue = RowObject.estorn-comis.
        WHEN "ind-extrac":U THEN ASSIGN pFieldValue = RowObject.ind-extrac.
        WHEN "ind-rateio":U THEN ASSIGN pFieldValue = RowObject.ind-rateio.
        WHEN "ind-tipo-rateio":U THEN ASSIGN pFieldValue = RowObject.ind-tipo-rateio.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "log-cc-atual":U THEN ASSIGN pFieldValue = RowObject.log-cc-atual.
        WHEN "log-ft-atual":U THEN ASSIGN pFieldValue = RowObject.log-ft-atual.
        WHEN "log-pt-atual":U THEN ASSIGN pFieldValue = RowObject.log-pt-atual.
        &IF "{&bf_dis_versao_ems}" >= "2.062" &THEN
        WHEN "log-memorando":U THEN ASSIGN pFieldValue = RowObject.log-memorando.
        &ENDIF
        WHEN "nf-emitida-est":U THEN ASSIGN pFieldValue = RowObject.nf-emitida-est.
        WHEN "nff":U THEN ASSIGN pFieldValue = RowObject.nff.
        WHEN "of-atual":U THEN ASSIGN pFieldValue = RowObject.of-atual.
        WHEN "rec-fisico":U THEN ASSIGN pFieldValue = RowObject.rec-fisico.
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
  Purpose:     Reposiciona registro com base no ¡ndice documento
  Parameters:  
               recebe valor do campo serie-docto
               recebe valor do campo nro-docto
               recebe valor do campo cod-emitente
               recebe valor do campo nat-operacao
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pserie-docto LIKE docum-est.serie-docto NO-UNDO.
    DEFINE INPUT PARAMETER pnro-docto LIKE docum-est.nro-docto NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente LIKE docum-est.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pnat-operacao LIKE docum-est.nat-operacao NO-UNDO.

    FIND FIRST bfdocum-est WHERE 
        bfdocum-est.serie-docto = pserie-docto AND 
        bfdocum-est.nro-docto = pnro-docto AND 
        bfdocum-est.cod-emitente = pcod-emitente AND 
        bfdocum-est.nat-operacao = pnat-operacao NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfdocum-est THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfdocum-est)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFaixa DBOProgram 
PROCEDURE openQueryFaixa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    open query qr{&tableName} for each {&tableName} NO-LOCK
         where {&tableName}.ce-atual = YES
         AND   {&tableName}.cod-estabel  >= cCodEstIni    
         AND   {&tableName}.cod-estabel  <= cCodEstFim    
         AND   {&tableName}.nro-docto    >= cNroDoctoIni  
         AND   {&tableName}.nro-docto    <= cNroDoctoFim  
         AND   {&tableName}.serie-docto  >= cSerieDoctoIni
         AND   {&tableName}.serie-docto  <= cSerieDoctoFim
         AND   {&tableName}.cod-emitente >= iCodEmitIni   
         AND   {&tableName}.cod-emitente <= iCodEmitFim   
         AND   {&tableName}.nat-operacao >= cNatOperIni   
         AND   {&tableName}.nat-operacao <= cNatOperFim,
         FIRST estabelec no-lock
         WHERE estabelec.cod-estabel = {&tableName}.cod-estabel,
         FIRST  emitente no-lock
         WHERE emitente.cod-emitente = {&tableName}.cod-emitente
         AND   emitente.pais         = estabelec.pais  
        BY {&tableName}.cod-estabel
        BY {&tableName}.nro-docto
        BY {&tableName}.serie-docto
        BY {&tableName}.cod-emitente
        BY {&tableName}.nat-operacao INDEXED-REPOSITION.

   return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFaixaInternac DBOProgram 
PROCEDURE openQueryFaixaInternac :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    open query qr{&tableName} for each {&tableName} NO-LOCK
         where {&tableName}.ce-atual = YES
         AND   {&tableName}.cod-estabel  >= cCodEstIni    
         AND   {&tableName}.cod-estabel  <= cCodEstFim    
         AND   {&tableName}.nro-docto    >= cNroDoctoIni  
         AND   {&tableName}.nro-docto    <= cNroDoctoFim  
         AND   {&tableName}.serie-docto  >= cSerieDoctoIni
         AND   {&tableName}.serie-docto  <= cSerieDoctoFim
         AND   {&tableName}.cod-emitente >= iCodEmitIni   
         AND   {&tableName}.cod-emitente <= iCodEmitFim   
         AND   {&tableName}.nat-operacao >= cNatOperIni   
         AND   {&tableName}.nat-operacao <= cNatOperFim
         AND   {&tableName}.dt-emissao      >= dDatEmisIni   
         AND   {&tableName}.dt-emissao      <= dDatEmisFim 
         AND   {&tableName}.nff           = lFatura,
         FIRST estabelec no-lock
         WHERE estabelec.cod-estabel = {&tableName}.cod-estabel,
         FIRST  emitente no-lock
         WHERE emitente.cod-emitente = {&tableName}.cod-emitente
        BY {&tableName}.cod-estabel
        BY {&tableName}.nro-docto
        BY {&tableName}.serie-docto
        BY {&tableName}.cod-emitente
        BY {&tableName}.nat-operacao INDEXED-REPOSITION.

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

    open query qr{&tableName} for each {&tableName}
         where {&tableName}.ce-atual = YES NO-LOCK,
         FIRST estabelec no-lock
         WHERE estabelec.cod-estabel = {&tableName}.cod-estabel,
         FIRST  emitente no-lock
         WHERE emitente.cod-emitente = {&tableName}.cod-emitente
         AND   emitente.pais         = estabelec.pais
         INDEXED-REPOSITION.

   return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFaixa DBOProgram 
PROCEDURE setConstraintFaixa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcCodEstIni     LIKE docum-est.cod-estabel  NO-UNDO.
    DEFINE INPUT PARAMETER pcCodEstFim     LIKE docum-est.cod-estabel  NO-UNDO.
    DEFINE INPUT PARAMETER pcNroDoctoIni   LIKE docum-est.nro-docto    NO-UNDO.
    DEFINE INPUT PARAMETER pcNroDoctoFim   LIKE docum-est.nro-docto    NO-UNDO.
    DEFINE INPUT PARAMETER pcSerieDoctoIni LIKE docum-est.serie-docto  NO-UNDO.
    DEFINE INPUT PARAMETER pcSerieDoctoFim LIKE docum-est.serie-docto  NO-UNDO.
    DEFINE INPUT PARAMETER piCodEmitIni    LIKE docum-est.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER piCodEmitFim    LIKE docum-est.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pcNatOperIni    LIKE docum-est.nat-operacao NO-UNDO.
    DEFINE INPUT PARAMETER pcNatOperFim    LIKE docum-est.nat-operacao NO-UNDO.

    ASSIGN cCodEstIni     = pcCodEstIni    
           cCodEstFim     = pcCodEstFim    
           cNroDoctoIni   = pcNroDoctoIni  
           cNroDoctoFim   = pcNroDoctoFim  
           cSerieDoctoIni = pcSerieDoctoIni
           cSerieDoctoFim = pcSerieDoctoFim
           iCodEmitIni    = piCodEmitIni   
           iCodEmitFim    = piCodEmitFim   
           cNatOperIni    = pcNatOperIni   
           cNatOperFim    = pcNatOperFim.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFaixaInternac DBOProgram 
PROCEDURE setConstraintFaixaInternac :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcCodEstIni     LIKE docum-est.cod-estabel  NO-UNDO.
    DEFINE INPUT PARAMETER pcCodEstFim     LIKE docum-est.cod-estabel  NO-UNDO.
    DEFINE INPUT PARAMETER pcNroDoctoIni   LIKE docum-est.nro-docto    NO-UNDO.
    DEFINE INPUT PARAMETER pcNroDoctoFim   LIKE docum-est.nro-docto    NO-UNDO.
    DEFINE INPUT PARAMETER pcSerieDoctoIni LIKE docum-est.serie-docto  NO-UNDO.
    DEFINE INPUT PARAMETER pcSerieDoctoFim LIKE docum-est.serie-docto  NO-UNDO.
    DEFINE INPUT PARAMETER piCodEmitIni    LIKE docum-est.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER piCodEmitFim    LIKE docum-est.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pcNatOperIni    LIKE docum-est.nat-operacao NO-UNDO.
    DEFINE INPUT PARAMETER pcNatOperFim    LIKE docum-est.nat-operacao NO-UNDO.
    DEFINE INPUT PARAMETER pdDatEmisIni    LIKE docum-est.dt-emissao      NO-UNDO.
    DEFINE INPUT PARAMETER pdDatEmisFim    LIKE docum-est.dt-emissao      NO-UNDO.
    DEFINE INPUT PARAMETER plFatura        LIKE docum-est.nff          NO-UNDO.

    ASSIGN cCodEstIni     = pcCodEstIni    
           cCodEstFim     = pcCodEstFim    
           cNroDoctoIni   = pcNroDoctoIni  
           cNroDoctoFim   = pcNroDoctoFim  
           cSerieDoctoIni = pcSerieDoctoIni
           cSerieDoctoFim = pcSerieDoctoFim
           iCodEmitIni    = piCodEmitIni   
           iCodEmitFim    = piCodEmitFim   
           cNatOperIni    = pcNatOperIni   
           cNatOperFim    = pcNatOperFim
           dDatEmisIni    = pdDatEmisIni  
           dDatEmisFim    = pdDatEmisFim  
           lFatura        = plFatura.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Valida‡äes pertinentes ao DBO
  Parameters:  recebe o tipo de valida‡Æo (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    /*:T--- Utilize o parƒmetro pType para identificar quais as valida‡äes a serem
          executadas ---*/
    /*:T--- Os valores poss¡veis para o parƒmetro sÆo: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as valida‡äes ---*/
    
    /*:T--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

