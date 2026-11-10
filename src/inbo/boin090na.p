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
{include/i-prgvrs.i BOIN090NA 2.00.00.037 } /*** "010037" 06/04/2026 16:30:35 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin090na MUT}
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
&GLOBAL-DEFINE DBOName BOIN090
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName docum-est
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

/******************************************************************************************
** TECNICA SEGURANCA ESTABELECIMENTO
******************************************************************************************/ 
{include/i-estab-security.i}
/******************************************************************************************
** TECNICA SEGURANCA ESTABELECIMENTO
******************************************************************************************/


/*--- Include com defini‡Æo da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com 
      extensÆo .i ---*/
{inbo/boin090na.i RowObject}


/*--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/



/*--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/* Miniflexibiliza‡Æo Cƒmbio */
{cdp/cdcfgfin.i}
{cdp/cdcfgdis.i}

/* local variable definitions */

DEF VAR cIniNroDocto   AS CHAR NO-UNDO.
DEF VAR cEndNroDocto   AS CHAR NO-UNDO.
DEF VAR cIniSerieDocto AS CHAR NO-UNDO.
DEF VAR cEndSerieDocto AS CHAR NO-UNDO.
DEF VAR iIniEmitente   AS INT  NO-UNDO.
DEF VAR iEndEmitente   AS INT  NO-UNDO.
DEF VAR cIniCodEstabel AS CHAR NO-UNDO.
DEF VAR cEndCodEstabel AS CHAR NO-UNDO.
DEF VAR cIniUsuario    AS CHAR NO-UNDO.
DEF VAR cEndUsuario    AS CHAR NO-UNDO.
DEF VAR cIniNatureza   AS CHAR NO-UNDO.
DEF VAR cEndNatureza   AS CHAR NO-UNDO.
DEF VAR cCodEstabel    AS CHAR NO-UNDO.
DEF VAR dIniDtTrans    AS DATE NO-UNDO.
DEF VAR dEndDtTrans    AS DATE NO-UNDO.
DEF VAR lCeAtual       AS LOG  NO-UNDO.
DEF VAR iemitente      AS INT  NO-UNDO.
DEF VAR iCodEmitente   AS INT  NO-UNDO.
DEF VAR daDataIni      AS DATE NO-UNDO.
DEF VAR daDataFim      AS DATE NO-UNDO.

def temp-table tt-documentos NO-UNDO
    field nr-documento  as character
    field tipo          as integer
    field dt-trans      as date.

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
         HEIGHT             = 25.63
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
        WHEN "cod-chave-aces-nf-eletro":U THEN ASSIGN pFieldValue = RowObject.cod-chave-aces-nf-eletro.
        WHEN "ct-transit":U THEN ASSIGN pFieldValue = RowObject.ct-transit.
        WHEN "embalagem":U THEN ASSIGN pFieldValue = RowObject.embalagem.
/*        WHEN "esp-fiscal":U THEN ASSIGN pFieldValue = RowObject.esp-fiscal.*/
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
        WHEN "cod-finalidade":U THEN ASSIGN pFieldValue = RowObject.cod-finalidade.
        WHEN "cod-modalid-frete":U THEN ASSIGN pFieldValue = &IF '{&BF_DIS_VERSAO_EMS}' >= '2.09'
                                                             &THEN RowObject.cod-modalid-frete.
                                                             &ELSE SUBSTRING(RowObject.char-2,143,8).
                                                             &ENDIF
        WHEN "tipo-dfe-docto":U THEN ASSIGN pFieldValue = RowObject.tipo-dfe-docto.
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
        WHEN "base-icm":U THEN ASSIGN pFieldValue = RowObject.base-icm.
        WHEN "base-icm-fas[1]":U THEN ASSIGN pFieldValue = RowObject.base-icm-fas[1].
        WHEN "base-icm-fas[2]":U THEN ASSIGN pFieldValue = RowObject.base-icm-fas[2].
        WHEN "base-ipi":U THEN ASSIGN pFieldValue = RowObject.base-ipi.
        WHEN "base-ipi-fas[1]":U THEN ASSIGN pFieldValue = RowObject.base-ipi-fas[1].
        WHEN "base-ipi-fas[2]":U THEN ASSIGN pFieldValue = RowObject.base-ipi-fas[2].
        WHEN "base-iss":U THEN ASSIGN pFieldValue = RowObject.base-iss.
        WHEN "base-iss-fas[1]":U THEN ASSIGN pFieldValue = RowObject.base-iss-fas[1].
        WHEN "base-iss-fas[2]":U THEN ASSIGN pFieldValue = RowObject.base-iss-fas[2].
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
/*        WHEN "perc-tax-div":U THEN ASSIGN pFieldValue = RowObject.perc-tax-div.*/
/*        WHEN "perc-tax-fre":U THEN ASSIGN pFieldValue = RowObject.perc-tax-fre.*/
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
        WHEN "vl-emb-fasb[1]":U THEN ASSIGN pFieldValue = RowObject.vl-emb-fasb[1].
        WHEN "vl-emb-fasb[2]":U THEN ASSIGN pFieldValue = RowObject.vl-emb-fasb[2].
        WHEN "vl-fre-fasb[1]":U THEN ASSIGN pFieldValue = RowObject.vl-fre-fasb[1].
        WHEN "vl-fre-fasb[2]":U THEN ASSIGN pFieldValue = RowObject.vl-fre-fasb[2].
        WHEN "vl-imp-impor[1]":U THEN ASSIGN pFieldValue = RowObject.vl-imp-impor[1].
        WHEN "vl-imp-impor[2]":U THEN ASSIGN pFieldValue = RowObject.vl-imp-impor[2].
        WHEN "vl-merc-fasb[1]":U THEN ASSIGN pFieldValue = RowObject.vl-merc-fasb[1].
        WHEN "vl-merc-fasb[2]":U THEN ASSIGN pFieldValue = RowObject.vl-merc-fasb[2].
        WHEN "vl-out-fasb[1]":U THEN ASSIGN pFieldValue = RowObject.vl-out-fasb[1].
        WHEN "vl-out-fasb[2]":U THEN ASSIGN pFieldValue = RowObject.vl-out-fasb[2].
        WHEN "vl-seg-fasb[1]":U THEN ASSIGN pFieldValue = RowObject.vl-seg-fasb[1].
        WHEN "vl-seg-fasb[2]":U THEN ASSIGN pFieldValue = RowObject.vl-seg-fasb[2].
        WHEN "vl-subs":U THEN ASSIGN pFieldValue = RowObject.vl-subs.
        WHEN "vl-subs-fasb[1]":U THEN ASSIGN pFieldValue = RowObject.vl-subs-fasb[1].
        WHEN "vl-subs-fasb[2]":U THEN ASSIGN pFieldValue = RowObject.vl-subs-fasb[2].
/*        WHEN "vl-tax-diversos":U THEN ASSIGN pFieldValue = RowObject.vl-tax-diversos.*/
/*        WHEN "vl-tax-frete":U THEN ASSIGN pFieldValue = RowObject.vl-tax-frete.*/
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
        WHEN "cod-observa":U THEN ASSIGN pFieldValue = RowObject.cod-observa.
        WHEN "cod-ret-irf":U THEN ASSIGN pFieldValue = RowObject.cod-ret-irf.
/*        WHEN "cod-tax-div":U THEN ASSIGN pFieldValue = RowObject.cod-tax-div.*/
/*        WHEN "cod-tax-fre":U THEN ASSIGN pFieldValue = RowObject.cod-tax-fre.*/
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
/*        WHEN "tipo-nota":U THEN ASSIGN pFieldValue = RowObject.tipo-nota.*/
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
/*        WHEN "atualiza-cr":U THEN ASSIGN pFieldValue = RowObject.atualiza-cr.*/
        WHEN "CE-atual":U THEN ASSIGN pFieldValue = RowObject.CE-atual.
        WHEN "cr-atual":U THEN ASSIGN pFieldValue = RowObject.cr-atual.
        WHEN "estorn-comis":U THEN ASSIGN pFieldValue = RowObject.estorn-comis.
        WHEN "ind-extrac":U THEN ASSIGN pFieldValue = RowObject.ind-extrac.
        WHEN "ind-rateio":U THEN ASSIGN pFieldValue = RowObject.ind-rateio.
        WHEN "ind-tipo-rateio":U THEN ASSIGN pFieldValue = RowObject.ind-tipo-rateio.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQuerybySerie DBOProgram 
PROCEDURE OpenQuerybySerie :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Devido a nova t‚cnica de Seguran‡a por Estabelecimento, a constante
         '&scoped-define KEY-PHRASE' substitui a clusula 'WHERE' e 'OPEN-QUERY'
         est  defindo dentro da include 'i-estab-openquery.i'.       
------------------------------------------------------------------------------*/

    /* Seguran‡a por Estabelecimento */
    &scoped-define KEY-PHRASE {&tableName}.ce-atual      =  NO           ~
                          AND {&tableName}.cod-emitente  =  iCodEmitente ~
                          AND {&tableName}.nat-operacao  <> "" NO-LOCK
                          
    &Scoped-define BY-ESTAB-IN                 
    &Scoped-define BY-ESTAB-AT                      
                          
    {include/i-estab-openquery.i}

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCeAtual DBOProgram 
PROCEDURE openQueryCeAtual :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Devido a nova t‚cnica de Seguran‡a por Estabelecimento, a constante
         '&scoped-define KEY-PHRASE' substitui a clusula 'WHERE' e 'OPEN-QUERY'
         est  defindo dentro da include 'i-estab-openquery.i'.     
------------------------------------------------------------------------------*/

    /* Seguran‡a por Estabelecimento */
    &scoped-define KEY-PHRASE {&tableName}.nro-docto   >= cIniNroDocto   ~
                          AND {&tableName}.nro-docto   <= cEndNroDocto   ~
                          AND {&tableName}.serie-docto >= cIniSerieDocto ~
                          AND {&tableName}.serie-docto <= cEndSerieDocto ~
                          AND {&tableName}.ce-atual    = lCeAtual NO-LOCK
                           
    &Scoped-define BY-ESTAB-IN                 
    &Scoped-define BY-ESTAB-AT                       
                           
    {include/i-estab-openquery.i}

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCeAtual2 DBOProgram 
PROCEDURE openQueryCeAtual2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Devido a nova t‚cnica de Seguran‡a por Estabelecimento, a constante
         '&scoped-define KEY-PHRASE' substitui a clusula 'WHERE' e 'OPEN-QUERY'
         est  defindo dentro da include 'i-estab-openquery.i'.      
------------------------------------------------------------------------------*/
     
    /* Seguran‡a por Estabelecimento */  
    &scoped-define KEY-PHRASE {&tableName}.cod-emitente >= iIniEmitente   ~
                          AND {&tableName}.cod-emitente <= iEndEmitente   ~
                          AND {&tableName}.cod-estabel  >= cIniCodEstabel ~
                          AND {&tableName}.cod-estabel  <= cEndCodEstabel ~
                          AND {&tableName}.ce-atual     = lCeAtual NO-LOCK 
                             
    &Scoped-define BY-ESTAB-IN                 
    &Scoped-define BY-ESTAB-AT
                                 
    {include/i-estab-openquery.i}
             
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCeAtual3 DBOProgram 
PROCEDURE openQueryCeAtual3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Devido a nova t‚cnica de Seguran‡a por Estabelecimento, a constante
         '&scoped-define KEY-PHRASE' substitui a clusula 'WHERE' e 'OPEN-QUERY'
         est  defindo dentro da include 'i-estab-openquery.i'.       
------------------------------------------------------------------------------*/

    /* Seguran‡a por Estabelecimento */  
    &scoped-define KEY-PHRASE {&tableName}.dt-trans     >= dIniDtTrans    ~
                          AND {&tableName}.dt-trans     <= dEndDtTrans    ~
                          AND {&tableName}.cod-estabel  >= cIniCodEstabel ~
                          AND {&tableName}.cod-estabel  <= cEndCodEstabel ~
                          AND {&tableName}.ce-atual      = lCeAtual NO-LOCK 
                             
    &Scoped-define BY-ESTAB-IN                 
    &Scoped-define BY-ESTAB-AT
                             
    {include/i-estab-openquery.i}
                 
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDevolucao DBOProgram 
PROCEDURE openQueryDevolucao :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes: Devido a nova t‚cnica de Seguran‡a por Estabelecimento, a constante
         '&scoped-define KEY-PHRASE' substitui a clusula 'WHERE' e 'OPEN-QUERY'
         est  defindo dentro da include 'i-estab-openquery.i'.      
------------------------------------------------------------------------------*/

    /* Seguran‡a por Estabelecimento */  
   &scoped-define KEY-PHRASE docum-est.cod-emitente  = iCodEmitente  ~
                         AND (docum-est.nat-operacao = "199iii"  OR  ~
                              docum-est.nat-operacao = "199tbt"  OR  ~
                              docum-est.nat-operacao = "199tct"  OR  ~
                              docum-est.nat-operacao = "199tat"  OR  ~
                              docum-est.nat-operacao = "199iit"  OR  ~
                              docum-est.nat-operacao = "199tai"  OR  ~
                              docum-est.nat-operacao = "199tbi"  OR  ~
                              docum-est.nat-operacao = "199tci"  OR  ~
                              docum-est.nat-operacao = "199tcf"  OR  ~
                              docum-est.nat-operacao = "199tbs"  OR  ~
                              docum-est.nat-operacao = "199tas"  OR  ~
                              docum-est.nat-operacao = "199tcs"  OR  ~
                              docum-est.nat-operacao = "199iis"  OR  ~
                              docum-est.nat-operacao = "299iii"  OR  ~
                              docum-est.nat-operacao = "299tbt"  OR  ~
                              docum-est.nat-operacao = "299tct"  OR  ~
                              docum-est.nat-operacao = "299tat"  OR  ~
                              docum-est.nat-operacao = "299iit"  OR  ~
                              docum-est.nat-operacao = "299tai"  OR  ~
                              docum-est.nat-operacao = "299tbi"  OR  ~
                              docum-est.nat-operacao = "299tci"  OR  ~
                              docum-est.nat-operacao = "299tbs"  OR  ~
                              docum-est.nat-operacao = "299tas"  OR  ~
                              docum-est.nat-operacao = "299tcs"  OR  ~
                              docum-est.nat-operacao = "299iis"  OR  ~
                              docum-est.nat-operacao = "299tcf")     ~
                          AND docum-est.dt-emissao >= daDataIni      ~
                          AND docum-est.dt-emissao <= daDataFim      ~
                          AND ce-atual = yes  NO-LOCK
                             
    &Scoped-define BY-ESTAB-IN                 
    &Scoped-define BY-ESTAB-AT                         
                             
    {include/i-estab-openquery.i}
                 
    RETURN "OK":U.  
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDocumEstAtual DBOProgram 
PROCEDURE openQueryDocumEstAtual :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &scoped-define KEY-PHRASE {&tableName}.ce-atual no-lock
       
    &Scoped-define BY-ESTAB-IN                 
    &Scoped-define BY-ESTAB-AT                      
                          
    {include/i-estab-openquery.i}
              
  return "OK":U.
                        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDocumPendentes DBOProgram 
PROCEDURE openQueryDocumPendentes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Devido a nova t‚cnica de Seguran‡a por Estabelecimento, a constante
         '&scoped-define KEY-PHRASE' substitui a clusula 'WHERE' e 'OPEN-QUERY'
         est  defindo dentro da include 'i-estab-openquery.i'.      
------------------------------------------------------------------------------*/

    /* Seguran‡a por Estabelecimento */  
    &scoped-define KEY-PHRASE {&tableName}.nro-docto   >= cIniNroDocto   ~
                          AND {&tableName}.nro-docto   <= cEndNroDocto   ~
                          AND {&tableName}.serie-docto >= cIniSerieDocto ~
                          AND {&tableName}.serie-docto <= cEndSerieDocto ~
                          AND {&tableName}.ce-atual     = NO NO-LOCK 
                             
    &Scoped-define BY-ESTAB-IN                 
    &Scoped-define BY-ESTAB-AT
                             
    {include/i-estab-openquery.i}  
       
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDTTransPendentes DBOProgram 
PROCEDURE openQueryDTTransPendentes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Devido a nova t‚cnica de Seguran‡a por Estabelecimento, a constante
         '&scoped-define KEY-PHRASE' substitui a clusula 'WHERE' e 'OPEN-QUERY'
         est  defindo dentro da include 'i-estab-openquery.i'.     
------------------------------------------------------------------------------*/

    /* Seguran‡a por Estabelecimento */
    &scoped-define KEY-PHRASE {&tableName}.dt-trans     >= dIniDtTrans    ~
                          AND {&tableName}.dt-trans     <= dEndDtTrans    ~
                          AND {&tableName}.cod-estabel  >= cIniCodEstabel ~
                          AND {&tableName}.cod-estabel  <= cEndCodEstabel ~
                          AND {&tableName}.ce-atual      = NO NO-LOCK  
                          
    &Scoped-define BY-ESTAB-IN by {&tableName}.dt-trans  ~
                               by {&tableName}.nro-docto ~
                               by {&tableName}.cod-estabel
                 
    &Scoped-define BY-ESTAB-AT by {&tableName}.cod-estabel ~
                               by {&tableName}.dt-trans    ~
                               by {&tableName}.nro-docto                          
                          
                             
    {include/i-estab-openquery.i}  
       
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryEmitPendentes DBOProgram 
PROCEDURE openQueryEmitPendentes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Devido a nova t‚cnica de Seguran‡a por Estabelecimento, a constante
         '&scoped-define KEY-PHRASE' substitui a clusula 'WHERE' e 'OPEN-QUERY'
         est  defindo dentro da include 'i-estab-openquery.i'.        
------------------------------------------------------------------------------*/

    /* Seguran‡a por Estabelecimento */
    &scoped-define KEY-PHRASE {&tableName}.cod-emitente >= iIniEmitente   ~
                          AND {&tableName}.cod-emitente <= iEndEmitente   ~
                          AND {&tableName}.cod-estabel  >= cIniCodEstabel ~
                          AND {&tableName}.cod-estabel  <= cEndCodEstabel ~
                          AND {&tableName}.ce-atual      = NO NO-LOCK
                          
    &Scoped-define BY-ESTAB-IN by {&tableName}.cod-emitente ~
                               by {&tableName}.nro-docto ~
                               by {&tableName}.cod-estabel
                 
    &Scoped-define BY-ESTAB-AT by {&tableName}.cod-estabel ~
                               by {&tableName}.cod-emitente ~
                               by {&tableName}.nro-docto   

    {include/i-estab-openquery.i}
             
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryFaixa DBOProgram 
PROCEDURE OpenQueryFaixa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Devido a nova t‚cnica de Seguran‡a por Estabelecimento, a constante
         '&scoped-define KEY-PHRASE' substitui a clusula 'WHERE' e 'OPEN-QUERY'
         est  defindo dentro da include 'i-estab-openquery.i'.       
------------------------------------------------------------------------------*/

    /* Seguran‡a por Estabelecimento */
    &scoped-define KEY-PHRASE {&tableName}.ce-atual      = no             ~
                          AND {&tableName}.serie-docto  >= cIniSerieDocto ~
                          AND {&tableName}.serie-docto  <= cEndSerieDocto ~
                          AND {&tableName}.nro-docto    >= cIniNroDocto   ~
                          AND {&tableName}.nro-docto    <= cEndNroDocto   ~
                          AND {&tableName}.cod-emitente >= iIniEmitente   ~
                          AND {&tableName}.cod-emitente <= iEndEmitente   ~
                          AND {&tableName}.nat-operacao >= cIniNatureza   ~
                          AND {&tableName}.nat-operacao <= cEndNatureza   ~
                          AND {&tableName}.dt-trans     >= dIniDtTrans    ~
                          AND {&tableName}.dt-trans     <= dEndDtTrans    ~
                          AND {&tableName}.cod-estabel  >= cIniCodEstabel ~
                          AND {&tableName}.cod-estabel  <= cEndCodEstabel ~
                          AND {&tableName}.usuario      >= cIniUsuario    ~
                          AND {&tableName}.usuario      <= cEndUsuario NO-LOCK

    &Scoped-define BY-ESTAB-IN                 
    &Scoped-define BY-ESTAB-AT
    
    {include/i-estab-openquery.i}
 
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none> 
  Notes: Devido a nova t‚cnica de Seguran‡a por Estabelecimento, a constante
         '&scoped-define KEY-PHRASE' substitui a clusula 'WHERE' e 'OPEN-QUERY'
         est  defindo dentro da include 'i-estab-openquery.i'.     
------------------------------------------------------------------------------*/
    /* Seguran‡a por Estabelecimento */
    &scoped-define KEY-PHRASE TRUE NO-LOCK
  
    &Scoped-define BY-ESTAB-IN                 
    &Scoped-define BY-ESTAB-AT
     
    {include/i-estab-openquery.i}
       
   RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryRangePage1 DBOProgram 
PROCEDURE openQueryRangePage1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Devido a nova t‚cnica de Seguran‡a por Estabelecimento, a constante
         '&scoped-define KEY-PHRASE' substitui a clusula 'WHERE' e 'OPEN-QUERY'
         est  defindo dentro da include 'i-estab-openquery.i'.     
------------------------------------------------------------------------------*/

    IF lCeAtual <> ? THEN DO:
        IF  cIniNroDocto   = cEndNroDocto   AND 
            cIniSerieDocto = cEndSerieDocto THEN DO:
            /* Seguran‡a por Estabelecimento */
            &scoped-define KEY-PHRASE {&tableName}.ce-atual    = lCeAtual     ~
                                  AND {&tableName}.nro-docto   = cIniNroDocto ~
                                  AND {&tableName}.serie-docto = cIniSerieDocto NO-LOCK

            &Scoped-define BY-ESTAB-IN by {&tableName}.nro-docto    ~
                                       by {&tableName}.serie-docto  ~
                                       by {&tableName}.nat-operacao ~
                                       by {&tableName}.cod-emitente ~
                                       by {&tableName}.cod-estabel

            &Scoped-define BY-ESTAB-AT by {&tableName}.cod-estabel  ~
                                       by {&tableName}.nro-docto    ~
                                       by {&tableName}.serie-docto  ~
                                       by {&tableName}.nat-operacao ~
                                       by {&tableName}.cod-emitente  

            {include/i-estab-openquery.i}
        END.
        ELSE IF cIniNroDocto = cEndNroDocto THEN DO:
            /* Seguran‡a por Estabelecimento */
            &scoped-define KEY-PHRASE {&tableName}.ce-atual     = lCeAtual       ~
                                  AND {&tableName}.nro-docto    = cIniNroDocto   ~
                                  AND {&tableName}.serie-docto >= cIniSerieDocto ~
                                  AND {&tableName}.serie-docto <= cEndSerieDocto NO-LOCK      

           &Scoped-define BY-ESTAB-IN by {&tableName}.nro-docto    ~
                                      by {&tableName}.serie-docto  ~
                                      by {&tableName}.nat-operacao ~
                                      by {&tableName}.cod-emitente ~
                                      by {&tableName}.cod-estabel

            &Scoped-define BY-ESTAB-AT by {&tableName}.cod-estabel  ~
                                       by {&tableName}.nro-docto    ~
                                       by {&tableName}.serie-docto  ~
                                       by {&tableName}.nat-operacao ~
                                       by {&tableName}.cod-emitente  

            {include/i-estab-openquery.i}
        END.
        ELSE IF cIniSerieDocto = cEndSerieDocto THEN DO:
            /* Seguran‡a por Estabelecimento */
            &scoped-define KEY-PHRASE {&tableName}.ce-atual    = lCeAtual       ~
                                  AND {&tableName}.nro-docto  >= cIniNroDocto   ~
                                  AND {&tableName}.nro-docto  <= cEndNroDocto   ~
                                  AND {&tableName}.serie-docto = cIniSerieDocto NO-LOCK      

           &Scoped-define BY-ESTAB-IN by {&tableName}.nro-docto    ~
                                      by {&tableName}.serie-docto  ~
                                      by {&tableName}.nat-operacao ~
                                      by {&tableName}.cod-emitente ~
                                      by {&tableName}.cod-estabel

            &Scoped-define BY-ESTAB-AT by {&tableName}.cod-estabel  ~
                                       by {&tableName}.nro-docto    ~
                                       by {&tableName}.serie-docto  ~
                                       by {&tableName}.nat-operacao ~
                                       by {&tableName}.cod-emitente  

            {include/i-estab-openquery.i}
        END.
        ELSE DO:
            /* Seguran‡a por Estabelecimento */
            &scoped-define KEY-PHRASE {&tableName}.ce-atual     = lCeAtual       ~
                                  AND {&tableName}.nro-docto   >= cIniNroDocto   ~
                                  AND {&tableName}.nro-docto   <= cEndNroDocto   ~
                                  AND {&tableName}.serie-docto >= cIniSerieDocto ~
                                  AND {&tableName}.serie-docto <= cEndSerieDocto NO-LOCK      
                                  
           &Scoped-define BY-ESTAB-IN by {&tableName}.nro-docto    ~
                                      by {&tableName}.serie-docto  ~
                                      by {&tableName}.nat-operacao ~
                                      by {&tableName}.cod-emitente ~
                                      by {&tableName}.cod-estabel
                     
            &Scoped-define BY-ESTAB-AT by {&tableName}.cod-estabel  ~
                                       by {&tableName}.nro-docto    ~
                                       by {&tableName}.serie-docto  ~
                                       by {&tableName}.nat-operacao ~
                                       by {&tableName}.cod-emitente  
                                       
            {include/i-estab-openquery.i}
        END.
    END. /*IF lCeAtual <> ? */
    ELSE DO: /* lCeAtual = ? */
        IF  cIniNroDocto   = cEndNroDocto   AND 
            cIniSerieDocto = cEndSerieDocto THEN DO:
            /* Seguran‡a por Estabelecimento */
            &scoped-define KEY-PHRASE {&tableName}.nro-docto   = cIniNroDocto ~
                                  AND {&tableName}.serie-docto = cIniSerieDocto NO-LOCK

            &Scoped-define BY-ESTAB-IN by {&tableName}.nro-docto    ~
                                       by {&tableName}.serie-docto  ~
                                       by {&tableName}.nat-operacao ~
                                       by {&tableName}.cod-emitente ~
                                       by {&tableName}.cod-estabel

            &Scoped-define BY-ESTAB-AT by {&tableName}.cod-estabel  ~
                                       by {&tableName}.nro-docto    ~
                                       by {&tableName}.serie-docto  ~
                                       by {&tableName}.nat-operacao ~
                                       by {&tableName}.cod-emitente  

            {include/i-estab-openquery.i}
        END.
        ELSE IF cIniNroDocto = cEndNroDocto THEN DO:
            /* Seguran‡a por Estabelecimento */
            &scoped-define KEY-PHRASE {&tableName}.nro-docto    = cIniNroDocto   ~
                                  AND {&tableName}.serie-docto >= cIniSerieDocto ~
                                  AND {&tableName}.serie-docto <= cEndSerieDocto NO-LOCK      

           &Scoped-define BY-ESTAB-IN by {&tableName}.nro-docto    ~
                                      by {&tableName}.serie-docto  ~
                                      by {&tableName}.nat-operacao ~
                                      by {&tableName}.cod-emitente ~
                                      by {&tableName}.cod-estabel

            &Scoped-define BY-ESTAB-AT by {&tableName}.cod-estabel  ~
                                       by {&tableName}.nro-docto    ~
                                       by {&tableName}.serie-docto  ~
                                       by {&tableName}.nat-operacao ~
                                       by {&tableName}.cod-emitente  

            {include/i-estab-openquery.i}
        END.
        ELSE IF cIniSerieDocto = cEndSerieDocto THEN DO:
            /* Seguran‡a por Estabelecimento */
            &scoped-define KEY-PHRASE {&tableName}.nro-docto   >= cIniNroDocto   ~
                                  AND {&tableName}.nro-docto   <= cEndNroDocto   ~
                                  AND {&tableName}.serie-docto  = cIniSerieDocto NO-LOCK

            &Scoped-define BY-ESTAB-IN by {&tableName}.nro-docto    ~
                                       by {&tableName}.serie-docto  ~
                                       by {&tableName}.nat-operacao ~
                                       by {&tableName}.cod-emitente ~
                                       by {&tableName}.cod-estabel

            &Scoped-define BY-ESTAB-AT by {&tableName}.cod-estabel  ~
                                       by {&tableName}.nro-docto    ~
                                       by {&tableName}.serie-docto  ~
                                       by {&tableName}.nat-operacao ~
                                       by {&tableName}.cod-emitente 

           {include/i-estab-openquery.i}   

        END.           
        ELSE DO:     
            /* Seguran‡a por Estabelecimento */
            &scoped-define KEY-PHRASE {&tableName}.nro-docto   >= cIniNroDocto   ~
                                  AND {&tableName}.nro-docto   <= cEndNroDocto   ~
                                  AND {&tableName}.serie-docto >= cIniSerieDocto ~
                                  AND {&tableName}.serie-docto <= cEndSerieDocto NO-LOCK      

           &Scoped-define BY-ESTAB-IN by {&tableName}.nro-docto    ~
                                      by {&tableName}.serie-docto  ~
                                      by {&tableName}.nat-operacao ~
                                      by {&tableName}.cod-emitente ~
                                      by {&tableName}.cod-estabel

            &Scoped-define BY-ESTAB-AT by {&tableName}.cod-estabel  ~
                                       by {&tableName}.nro-docto    ~
                                       by {&tableName}.serie-docto  ~
                                       by {&tableName}.nat-operacao ~
                                       by {&tableName}.cod-emitente  

            {include/i-estab-openquery.i}

        END.  
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryRangePage1Emit DBOProgram 
PROCEDURE openQueryRangePage1Emit :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Devido a nova t‚cnica de Seguran‡a por Estabelecimento, a constante
         '&scoped-define KEY-PHRASE' substitui a clusula 'WHERE' e 'OPEN-QUERY'
         est  defindo dentro da include 'i-estab-openquery.i'.      
------------------------------------------------------------------------------*/
    /* Seguran‡a por Estabelecimento */
    &scoped-define KEY-PHRASE {&tableName}.serie-docto  >= cIniSerieDocto ~
                          AND {&tableName}.serie-docto  <= cEndSerieDocto ~
                          AND {&tableName}.nro-docto    >= cIniNroDocto   ~
                          AND {&tableName}.nro-docto    <= cEndNroDocto   ~
                          AND {&tableName}.cod-emitente  = iemitente NO-LOCK

    &Scoped-define BY-ESTAB-IN by {&tableName}.nro-docto    ~
                               by {&tableName}.serie-docto  ~
                               by {&tableName}.nat-operacao ~
                               by {&tableName}.cod-emitente ~
                               by {&tableName}.cod-estabel
             
    &Scoped-define BY-ESTAB-AT by {&tableName}.cod-estabel  ~
                               by {&tableName}.nro-docto    ~
                               by {&tableName}.serie-docto  ~
                               by {&tableName}.nat-operacao ~
                               by {&tableName}.cod-emitente                              
  
    {include/i-estab-openquery.i} 
    
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryRangePage2 DBOProgram 
PROCEDURE openQueryRangePage2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Devido a nova t‚cnica de Seguran‡a por Estabelecimento, a constante
         '&scoped-define KEY-PHRASE' substitui a clusula 'WHERE' e 'OPEN-QUERY'
         est  defindo dentro da include 'i-estab-openquery.i'.    
------------------------------------------------------------------------------*/

    IF lCeAtual <> ? THEN DO:
        /* Seguran‡a por Estabelecimento */
        &scoped-define KEY-PHRASE {&tableName}.ce-atual      = lCeAtual       ~
                              AND {&tableName}.cod-emitente >= iIniEmitente   ~
                              AND {&tableName}.cod-emitente <= iEndEmitente   ~
                              AND {&tableName}.cod-estabel  >= cIniCodEstabel ~
                              AND {&tableName}.cod-estabel  <= cEndCodEstabel ~
                              NO-LOCK
    
        &Scoped-define BY-ESTAB-IN by {&tableName}.cod-emitente ~
                                   by {&tableName}.cod-estabel  ~
                                   by {&tableName}.serie-docto  ~
                                   by {&tableName}.nro-docto    ~
                                   by {&tableName}.nat-operacao
                 
        &Scoped-define BY-ESTAB-AT by {&tableName}.cod-estabel  ~
                                   by {&tableName}.cod-emitente ~
                                   by {&tableName}.serie-docto  ~
                                   by {&tableName}.nro-docto    ~
                                   by {&tableName}.nat-operacao 
      
        {include/i-estab-openquery.i} 

    END.
    ELSE DO:
        /* Seguran‡a por Estabelecimento */
        &scoped-define KEY-PHRASE {&tableName}.cod-emitente >= iIniEmitente   ~
                              AND {&tableName}.cod-emitente <= iEndEmitente   ~
                              AND {&tableName}.cod-estabel  >= cIniCodEstabel ~
                              AND {&tableName}.cod-estabel  <= cEndCodEstabel ~
                              NO-LOCK
    
        &Scoped-define BY-ESTAB-IN by {&tableName}.cod-emitente ~
                                   by {&tableName}.cod-estabel  ~
                                   by {&tableName}.serie-docto  ~
                                   by {&tableName}.nro-docto    ~
                                   by {&tableName}.nat-operacao
                 
        &Scoped-define BY-ESTAB-AT by {&tableName}.cod-estabel  ~
                                   by {&tableName}.cod-emitente ~
                                   by {&tableName}.serie-docto  ~
                                   by {&tableName}.nro-docto    ~
                                   by {&tableName}.nat-operacao 
      
        {include/i-estab-openquery.i} 
    END.
        
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryRangePage2Atualizados DBOProgram 
PROCEDURE openQueryRangePage2Atualizados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Devido a nova t‚cnica de Seguran‡a por Estabelecimento, a constante
         '&scoped-define KEY-PHRASE' substitui a clusula 'WHERE' e 'OPEN-QUERY'
         est  defindo dentro da include 'i-estab-openquery.i'.      
------------------------------------------------------------------------------*/

    /* Seguran‡a por Estabelecimento */
    &scoped-define KEY-PHRASE {&tableName}.cod-emitente >= iIniEmitente   ~
                          AND {&tableName}.cod-emitente <= iEndEmitente   ~
                          AND {&tableName}.cod-estabel  >= cIniCodEstabel ~
                          AND {&tableName}.cod-estabel  <= cEndCodEstabel ~
                          AND {&tableName}.ce-atual      = YES NO-LOCK

    &Scoped-define BY-ESTAB-IN by {&tableName}.cod-emitente ~
                               by {&tableName}.cod-estabel  ~
                               by {&tableName}.serie-docto  ~
                               by {&tableName}.nro-docto    ~
                               by {&tableName}.nat-operacao
             
    &Scoped-define BY-ESTAB-AT by {&tableName}.cod-estabel  ~
                               by {&tableName}.cod-emitente ~
                               by {&tableName}.serie-docto  ~
                               by {&tableName}.nro-docto    ~
                               by {&tableName}.nat-operacao                               
  
    {include/i-estab-openquery.i} 
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openqueryRangePage2Emit DBOProgram 
PROCEDURE openqueryRangePage2Emit :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Devido a nova t‚cnica de Seguran‡a por Estabelecimento, a constante
         '&scoped-define KEY-PHRASE' substitui a clusula 'WHERE' e 'OPEN-QUERY'
         est  defindo dentro da include 'i-estab-openquery.i'.     
------------------------------------------------------------------------------*/

    /* Seguran‡a por Estabelecimento */
    &scoped-define KEY-PHRASE {&tableName}.dt-trans     >= dIniDtTrans    ~
                          AND {&tableName}.dt-trans     <= dEndDtTrans    ~
                          AND {&tableName}.cod-estabel  >= cIniCodEstabel ~
                          AND {&tableName}.cod-estabel  <= cEndCodEstabel ~
                          AND {&tableName}.cod-emitente  = iemitente NO-LOCK

    &Scoped-define BY-ESTAB-IN by {&tableName}.dt-trans     ~
                               by {&tableName}.cod-estabel  ~
                               by {&tableName}.cod-emitente ~
                               by {&tableName}.serie-docto  ~
                               by {&tableName}.nro-docto    ~
                               by {&tableName}.nat-operacao                                   
                                  
    &Scoped-define BY-ESTAB-AT by {&tableName}.cod-estabel  ~
                               by {&tableName}.dt-trans     ~
                               by {&tableName}.cod-emitente ~
                               by {&tableName}.serie-docto  ~
                               by {&tableName}.nro-docto    ~
                               by {&tableName}.nat-operacao                                
  
    {include/i-estab-openquery.i} 

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryRangePage2Estab DBOProgram 
PROCEDURE openQueryRangePage2Estab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Defini‡Æo da query seguindo a nova t‚cnica se seguran‡a por 
         estabelecimento.
         Query foi Customizada devidou ao uso do 'USE-INDEX'.
         'OPEN-QUERY ' definido detro da include i-estab-openquery.i
------------------------------------------------------------------------------*/
      
      /* Neste open query est  sendo for‡ado o ¡ndice 'emitente' senÆo o Progress
         utilizaria o ¡ndice 'est-origem' porque pela regra de sele‡Æo de ¡ndices
         ‚ dada preferˆncia pelo 'equality matches', mas como o usu rio geralmente 
         nÆo ir  deixar a faixa de emitentes totalmente aberta fica mais vantajoso 
         utilizar o ¡ndice emitente, para pegar todos os registros dos emitentes da 
         faixa e depois ler novamente os registros para selecionar o estabelecimento,
         pois desta forma os registros da sele‡Æo serÆo serÆo em quantidade menor e
         j  virÆo ordenados pelo break by desejado.
         *** Favor nÆo retirar o 'USE-INDEX emitente' abaixo ***/  


    /* Seguran‡a por Estabelecimento */
     &SCOPED-DEFINE OPEN-QUERY-{&RangePage2Estab}-IN OPEN QUERY qrdocum-est~
        FOR EACH {&ESTAB-SEC-TT} NO-LOCK,~
        EACH {&tableName} USE-INDEX emitente ~
           WHERE {&tableName}.cod-emitente >= iIniEmitente ~
             AND {&tableName}.cod-emitente <= iEndEmitente ~
             AND {&tableName}.nro-docto    >= "" ~
             AND {&tableName}.nro-docto    <= "ZZZZZZZZZZZZZZZZ" ~
             AND {&tableName}.cod-estabel  = cCodEstabel no-lock.        
         
               
         
    &SCOPED-DEFINE OPEN-QUERY-{&RangePage2Estab}-AT OPEN QUERY qrdocum-est~
        FOR EACH {&ESTAB-SEC-TT} NO-LOCK,~
            EACH {&tableName} USE-INDEX emitente ~
           WHERE {&tableName}.cod-estabel = {&ESTAB-SEC-TT}.cod-estabel ~
             AND {&tableName}.cod-emitente >= iIniEmitente ~
             AND {&tableName}.cod-emitente <= iEndEmitente ~
             AND {&tableName}.nro-docto    >= "" ~
             AND {&tableName}.nro-docto    <= "ZZZZZZZZZZZZZZZZ" ~
             AND {&tableName}.cod-estabel  = cCodEstabel no-lock. 
               
    &Scoped-define BY-ESTAB-IN                 
    &Scoped-define BY-ESTAB-AT
               
    {include/i-estab-openquery.i} 

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryRangePage3 DBOProgram 
PROCEDURE openQueryRangePage3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF lCeAtual <> ? THEN DO:
        /* Seguran‡a por Estabelecimento */
        &scoped-define KEY-PHRASE {&tableName}.ce-atual      = lCeAtual       ~
                              AND {&tableName}.dt-trans     >= dIniDtTrans    ~
                              AND {&tableName}.dt-trans     <= dEndDtTrans    ~
                              AND {&tableName}.cod-estabel  >= cIniCodEstabel ~
                              AND {&tableName}.cod-estabel  <= cEndCodEstabel ~
                              NO-LOCK
    
        &Scoped-define BY-ESTAB-IN by {&tableName}.dt-trans     ~
                                   by {&tableName}.cod-estabel  ~
                                   by {&tableName}.cod-emitente ~
                                   by {&tableName}.serie-docto  ~
                                   by {&tableName}.nro-docto    ~
                                   by {&tableName}.nat-operacao                                   
                                      
        &Scoped-define BY-ESTAB-AT by {&tableName}.cod-estabel  ~
                                   by {&tableName}.dt-trans     ~
                                   by {&tableName}.cod-emitente ~
                                   by {&tableName}.serie-docto  ~
                                   by {&tableName}.nro-docto    ~
                                   by {&tableName}.nat-operacao 
                                   
        {include/i-estab-openquery.i}                         
    END.
    ELSE DO:
        /* Seguran‡a por Estabelecimento */
        &scoped-define KEY-PHRASE {&tableName}.dt-trans     >= dIniDtTrans    ~
                              AND {&tableName}.dt-trans     <= dEndDtTrans    ~
                              AND {&tableName}.cod-estabel  >= cIniCodEstabel ~
                              AND {&tableName}.cod-estabel  <= cEndCodEstabel ~
                              NO-LOCK
    
        &Scoped-define BY-ESTAB-IN by {&tableName}.dt-trans     ~
                                   by {&tableName}.cod-estabel  ~
                                   by {&tableName}.cod-emitente ~
                                   by {&tableName}.serie-docto  ~
                                   by {&tableName}.nro-docto    ~
                                   by {&tableName}.nat-operacao                                   
                                      
        &Scoped-define BY-ESTAB-AT by {&tableName}.cod-estabel  ~
                                   by {&tableName}.dt-trans     ~
                                   by {&tableName}.cod-emitente ~
                                   by {&tableName}.serie-docto  ~
                                   by {&tableName}.nro-docto    ~
                                   by {&tableName}.nat-operacao 
                                   
        {include/i-estab-openquery.i}                           
    END.
             
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryRangePage3Data DBOProgram 
PROCEDURE openQueryRangePage3Data :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Seguran‡a por Estabelecimento */
    &scoped-define KEY-PHRASE{&tableName}.dt-trans     >= dIniDtTrans    ~
                         AND {&tableName}.dt-trans     <= dEndDtTrans    ~
                         AND {&tableName}.cod-estabel  >= cIniCodEstabel ~
                         AND {&tableName}.cod-estabel  <= cEndCodEstabel ~

    &Scoped-define BY-ESTAB-IN by {&tableName}.dt-trans     ~
                               by {&tableName}.cod-estabel  ~                                                               
                                  
    &Scoped-define BY-ESTAB-AT by {&tableName}.cod-estabel  ~
                               by {&tableName}.dt-trans     
    {include/i-estab-openquery.i}                           
                              
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-documentos DBOProgram 
PROCEDURE pi-busca-documentos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  parameter p-serie-docto    as  character no-undo.
    def input  parameter p-nro-docto      as  character no-undo.
    def input  parameter p-cod-emitente   as  integer   no-undo.
    def input  parameter p-nat-operacao   as  character no-undo.
    def output parameter table            for tt-documentos.    

    def var h-bocx220 as handle no-undo.

    &if defined(BF_FIN_MODUL_CAMBIO) &then
        find first param-global no-lock no-error.
        if param-global.modulo-mec = yes then do:
            find first docum-est no-lock
                 where docum-est.serie-docto         = p-serie-docto
                 and   substr(docum-est.char-1,1,20) = p-nro-docto
                 and   docum-est.cod-emitente        = p-cod-emitente
                 and   docum-est.nat-operacao        = p-nat-operacao no-error.
            if avail docum-est then do:
                run cxbo/bocx220.p persistent set h-bocx220.
                run pi-cria-documentos in h-bocx220 (input  docum-est.cod-estabel,
                                                     input  substr(docum-est.char-1,1,20),
                                                     input  docum-est.dt-trans,
                                                     output table tt-documentos).
                delete procedure h-bocx220.
                                 h-bocx220 = ?.
            end.
        end.
    &endif

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-eSocial DBOProgram 
PROCEDURE pi-eSocial :
/*------------------------------------------------------------------------------
  Purpose: Verifica se a nota ‚ do eSocial     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER pserie-docto LIKE docum-est.serie-docto NO-UNDO.
    DEFINE INPUT  PARAMETER pnro-docto LIKE docum-est.nro-docto NO-UNDO.
    DEFINE INPUT  PARAMETER pcod-emitente LIKE docum-est.cod-emitente NO-UNDO.
    DEFINE INPUT  PARAMETER pnat-operacao LIKE docum-est.nat-operacao NO-UNDO.
    DEFINE OUTPUT PARAMETER p-esocial AS CHAR NO-UNDO.

    FIND FIRST bfdocum-est WHERE 
        bfdocum-est.serie-docto = pserie-docto AND 
        bfdocum-est.nro-docto = pnro-docto AND 
        bfdocum-est.cod-emitente = pcod-emitente AND 
        bfdocum-est.nat-operacao = pnat-operacao NO-LOCK NO-ERROR.

    IF AVAIL bfdocum-est THEN
        ASSIGN p-esocial = SUBSTRING(bfdocum-est.char-2,104,8).

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintbySerie DBOProgram 
PROCEDURE setConstraintbySerie :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF INPUT PARAMETER piEmitente AS INTEGER NO-UNDO.   
    
  ASSIGN iCodEmitente = piEmitente.
    
  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintDevolucao DBOProgram 
PROCEDURE setConstraintDevolucao :
/*------------------------------------------------------------------------------
  Purpose:    
  Parameters:  
  Notes:
------------------------------------------------------------------------------*/
    def input param piCodEmitente as int  no-undo.
    def input param pdaDataIni    as date no-undo.
    def input param pdaDataFim    as date no-undo.
    
    assign iCodEmitente = piCodEmitente
           daDataIni    = pdaDataIni
           daDataFim    = pdaDataFim.

    RETURN "OK":U.
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

  def input parameter pIniCodEstabel AS CHAR no-undo. 
  def input parameter pEndCodEstabel AS CHAR no-undo.
  def input parameter pIniEmitente   AS INT  no-undo. 
  def input parameter pEndEmitente   AS INT  no-undo.
  def input parameter pIniNroDocto   AS CHAR no-undo. 
  def input parameter pEndNroDocto   AS CHAR no-undo.
  def input parameter pIniSerieDocto AS CHAR no-undo. 
  def input parameter pEndSerieDocto AS CHAR no-undo.
  def input parameter pIniDtTrans    AS DATE no-undo. 
  def input parameter pEndDtTrans    AS DATE no-undo.
  def input parameter pIniNatureza   AS CHAR no-undo. 
  def input parameter pEndNatureza   AS CHAR no-undo.
  def input parameter pIniUsuario    AS CHAR no-undo. 
  def input parameter pEndUsuario    AS CHAR no-undo. 

    assign cIniNroDocto   = pIniNroDocto  
           cEndNroDocto   = pEndNroDocto  
           cIniSerieDocto = pIniSerieDocto
           cEndSerieDocto = pEndSerieDocto
           iIniEmitente   = pIniEmitente  
           iEndEmitente   = pEndEmitente  
           cIniCodEstabel = pIniCodEstabel
           cEndCodEstabel = pEndCodEstabel
           cIniUsuario    = pIniUsuario   
           cEndUsuario    = pEndUsuario   
           dIniDtTrans    = pIniDtTrans   
           dEndDtTrans    = pEndDtTrans   
           cIniNatureza   = pIniNatureza  
           cEndNatureza   = pEndNatureza.
    
  RETURN "OK":U.
      
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintRangePage1 DBOProgram 
PROCEDURE setConstraintRangePage1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param pcIniNroDocto   as char no-undo.
def input param pcEndNroDocto   as char no-undo.
def input param pcIniSerieDocto as char no-undo.
def input param pcEndSerieDocto as char no-undo.
def input param plCeAtual       as log  no-undo.

    assign cIniNroDocto   = pcIniNroDocto
           cEndNroDocto   = pcEndNroDocto
           cIniSerieDocto = pcIniSerieDocto
           cEndSerieDocto = pcEndSerieDocto
           lCeAtual       = plCeAtual.

   return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintRangePage1Emit DBOProgram 
PROCEDURE setConstraintRangePage1Emit :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param pcIniNroDocto   as char no-undo.
def input param pcEndNroDocto   as char no-undo.
def input param pcIniSerieDocto as char no-undo.
def input param pcEndSerieDocto as char no-undo.
def input param piEmitente      as int  no-undo.

    assign cIniNroDocto   = pcIniNroDocto
           cEndNroDocto   = pcEndNroDocto
           cIniSerieDocto = pcIniSerieDocto
           cEndSerieDocto = pcEndSerieDocto
           iemitente      = piEmitente.

   return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintRangePage2 DBOProgram 
PROCEDURE setConstraintRangePage2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param piIniEmitente   as int  no-undo.
def input param piEndEmitente   as int  no-undo.
def input param pcIniCodEstabel as char no-undo.
def input param pcEndCodEstabel as char no-undo.
def input param plCeAtual       as log  no-undo.

assign iIniEmitente   = piIniEmitente
       iEndEmitente   = piEndEmitente
       cIniCodEstabel = pcIniCodEstabel
       cEndCodEstabel = pcEndCodEstabel
       lCeAtual       = plCeAtual.
       
return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintRangePage2Emit DBOProgram 
PROCEDURE setConstraintRangePage2Emit :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param pdIniDtTrans as date no-undo.
def input param pdEndDtTrans as date no-undo.
def input param pcIniCodEstabel as char no-undo.
def input param pcEndCodEstabel as char no-undo.
def input param piEmitente      as int  no-undo.

assign dIniDtTrans    = pdIniDtTrans
       dEndDtTrans    = pdEndDtTrans
       cIniCodEstabel = pcIniCodEstabel
       cEndCodEstabel = pcEndCodEstabel
       iemitente      = piEmitente.
       
return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintRangePage2Estab DBOProgram 
PROCEDURE setConstraintRangePage2Estab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param piIniEmitente   as int  no-undo.
def input param piEndEmitente   as int  no-undo.
def input param pcCodEstabel    as char no-undo.

assign iIniEmitente   = piIniEmitente
       iEndEmitente   = piEndEmitente
       cCodEstabel    = pcCodEstabel.
       
return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintRangePage3 DBOProgram 
PROCEDURE setConstraintRangePage3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param pdIniDtTrans as date no-undo.
def input param pdEndDtTrans as date no-undo.
def input param pcIniCodEstabel as char no-undo.
def input param pcEndCodEstabel as char no-undo.
def input param plCeAtual       as log  no-undo.

assign dIniDtTrans    = pdIniDtTrans
       dEndDtTrans    = pdEndDtTrans
       cIniCodEstabel = pcIniCodEstabel
       cEndCodEstabel = pcEndCodEstabel
       lCeAtual       = plCeAtual.
       
return "OK":U.

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

