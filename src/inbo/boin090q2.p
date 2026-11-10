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
{include/i-prgvrs.i BOIN090Q2 2.00.00.010 } /*** "010010" 13/11/2023 11:45:48 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i boin090q2 MUT}
&ENDIF


/*:T--------------------------------------------------------------------------
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

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN090
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName docum-est
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

/* DBO-XML-BEGIN */
/*:T Pre-processadores para ativar XML no DBO */
/*:T Retirar o comentario para ativar 
&GLOBAL-DEFINE XMLProducer YES    /*:T DBO atua como producer de mensagens para o Message Broker */
&GLOBAL-DEFINE XMLTopic           /*:T Topico da Mensagem enviada ao Message Broker, geralmente o nome da tabela */
&GLOBAL-DEFINE XMLTableName       /*:T Nome da tabela que deve ser usado como TAG no XML */ 
&GLOBAL-DEFINE XMLTableNameMult   /*:T Nome da tabela no plural. Usado para multiplos registros */ 
&GLOBAL-DEFINE XMLPublicFields    /*:T Lista dos campos (c1,c2) que podem ser enviados via XML. Ficam fora da listas os campos de especializacao da tabela */ 
&GLOBAL-DEFINE XMLKeyFields       /*:T Lista dos campos chave da tabela (c1,c2) */
&GLOBAL-DEFINE XMLExcludeFields   /*:T Lista de campos a serem excluidos do XML quando PublicFields = "" */

&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (mÇtodo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /*:T Nome da Query que d† acessos a todos os registros, exceto os exclu°dos pela constraint de seguranáa. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /*:T Informar os campos da chave quando o Progress n∆o conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

/*:T--- Include com definiá∆o da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin090.i RowObject}
{inbo/boin090.i tt-docum-est-aux}
{cdp/cdcfgdis.i}
{cdp/cdapi600.i &Docum-est="YES"}

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}

/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

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
    DEF VAR dIniDtTrans    AS DATE NO-UNDO.
    DEF VAR dEndDtTrans    AS DATE NO-UNDO.

DEFINE VARIABLE rRowid AS ROWID NO-UNDO.

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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
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
        WHEN "ct-transit":U THEN ASSIGN pFieldValue = RowObject.ct-transit.
        WHEN "embalagem":U THEN ASSIGN pFieldValue = RowObject.embalagem.
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "cod-ibge":U THEN ASSIGN pFieldValue = RowObject.cod-ibge.
        WHEN "cod-observa":U THEN ASSIGN pFieldValue = RowObject.cod-observa.
        WHEN "cod-ret-irf":U THEN ASSIGN pFieldValue = RowObject.cod-ret-irf.
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
  Purpose:     Retorna valores dos campos do °ndice documento
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "acresc-financ":U THEN ASSIGN pFieldValue = RowObject.acresc-financ.
        WHEN "ap-atual":U THEN ASSIGN pFieldValue = RowObject.ap-atual.
        WHEN "atual-ft":U THEN ASSIGN pFieldValue = RowObject.atual-ft.
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
        WHEN "#TemDespesaAcessoria":U THEN ASSIGN pFieldValue = CAN-FIND(FIRST despesa-aces OF RowObject).
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRecordTMS DBOProgram 
PROCEDURE getRecordTMS :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE OUTPUT PARAMETER TABLE FOR tt-docum-est.

FOR EACH tt-docum-est:
    DELETE tt-docum-est.
END.

CREATE tt-docum-est.
BUFFER-COPY RowObject TO tt-docum-est.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTTdocum-estTMS DBOProgram 
PROCEDURE getTTdocum-estTMS :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Criada para resolver problemas relacionados a erros de definiá∆o da TT por culpa do PROGRESS      
------------------------------------------------------------------------------*/

DEFINE OUTPUT PARAMETER TABLE FOR tt-docum-est.

DEFINE VARIABLE iCont AS INTEGER    NO-UNDO.

FOR EACH tt-docum-est:
    DELETE tt-docum-est.
END.

RUN getBatchRecords IN THIS-PROCEDURE (INPUT ?,
                                       INPUT NO,
                                       INPUT 999999,
                                       OUTPUT iCont,
                                       OUTPUT TABLE tt-docum-est-aux).

FOR EACH tt-docum-est-aux:
    CREATE tt-docum-est.
    BUFFER-COPY tt-docum-est-aux TO tt-docum-est.
end.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice documento
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

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfdocum-est THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfdocum-est)).
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

    OPEN QUERY {&QueryName}
        FOR EACH {&TableName} NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryRowid DBOProgram 
PROCEDURE openQueryRowid :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName}
        FOR EACH {&TableName} NO-LOCK
            WHERE ROWID({&TableName}) = rRowid.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryTMS DBOProgram 
PROCEDURE openQueryTMS :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    IF  dIniDtTrans = dEndDtTrans THEN
        OPEN QUERY qr{&tableName} FOR EACH {&TABLENAME} USE-INDEX dt-tp-estab                    
               WHERE {&TABLENAME}.dt-trans      = dIniDtTrans 
                 AND {&TABLENAME}.cod-estabel  >= cIniCodEstabel            
                 AND {&TABLENAME}.cod-estabel  <= cEndCodEstabel
                 AND {&TABLENAME}.serie-docto  >= cIniSerieDocto                 
                 AND {&TABLENAME}.serie-docto  <= cEndSerieDocto               
                 AND {&TABLENAME}.nro-docto    >= cIniNroDocto              
                 AND {&TABLENAME}.nro-docto    <= cEndNroDocto                
                 AND {&TABLENAME}.cod-emitente >= iIniEmitente                       
                 AND {&TABLENAME}.cod-emitente <= iEndEmitente              
                 AND {&TABLENAME}.nat-operacao >= cIniNatureza            
                 AND {&TABLENAME}.nat-operacao <= cEndNatureza               
                 AND {&TABLENAME}.usuario      >= cIniUsuario                
                 AND {&TABLENAME}.usuario      <= cEndUsuario
                 NO-LOCK INDEXED-REPOSITION.
   ELSE IF  MONTH(dIniDtTrans) = MONTH(dEndDtTrans) 
        AND YEAR(dIniDtTrans)  = YEAR(dEndDtTrans) THEN
            OPEN QUERY qr{&tableName} FOR EACH {&TABLENAME}   USE-INDEX dt-tp-estab                  
                   WHERE {&TABLENAME}.dt-trans     >= dIniDtTrans 
                     AND {&TABLENAME}.dt-trans     <= dEndDtTrans 
                     AND {&TABLENAME}.cod-estabel  >= cIniCodEstabel            
                     AND {&TABLENAME}.cod-estabel  <= cEndCodEstabel
                     AND {&TABLENAME}.serie-docto  >= cIniSerieDocto                 
                     AND {&TABLENAME}.serie-docto  <= cEndSerieDocto               
                     AND {&TABLENAME}.nro-docto    >= cIniNroDocto              
                     AND {&TABLENAME}.nro-docto    <= cEndNroDocto                
                     AND {&TABLENAME}.cod-emitente >= iIniEmitente                       
                     AND {&TABLENAME}.cod-emitente <= iEndEmitente              
                     AND {&TABLENAME}.nat-operacao >= cIniNatureza            
                     AND {&TABLENAME}.nat-operacao <= cEndNatureza               
                                
                     AND {&TABLENAME}.usuario      >= cIniUsuario                
                     AND {&TABLENAME}.usuario      <= cEndUsuario
                     NO-LOCK INDEXED-REPOSITION.
        ELSE IF cIniSerieDocto = cEndSerieDocto THEN
            OPEN QUERY qr{&tableName} FOR EACH {&TABLENAME}                     
                    WHERE {&TABLENAME}.serie-docto  = cIniSerieDocto                 
                      AND {&TABLENAME}.nro-docto    >= cIniNroDocto              
                      AND {&TABLENAME}.nro-docto    <= cEndNroDocto                
                      AND {&TABLENAME}.cod-emitente >= iIniEmitente                       
                      AND {&TABLENAME}.cod-emitente <= iEndEmitente              
                      AND {&TABLENAME}.nat-operacao >= cIniNatureza            
                      AND {&TABLENAME}.nat-operacao <= cEndNatureza               
                      AND {&TABLENAME}.dt-trans     >= dIniDtTrans               
                      AND {&TABLENAME}.dt-trans     <= dEndDtTrans               
                      AND {&TABLENAME}.cod-estabel  >= cIniCodEstabel            
                      AND {&TABLENAME}.cod-estabel  <= cEndCodEstabel           
                      AND {&TABLENAME}.usuario      >= cIniUsuario                
                      AND {&TABLENAME}.usuario      <= cEndUsuario
                      NO-LOCK INDEXED-REPOSITION.
            ELSE
                OPEN QUERY qr{&tableName} FOR EACH {&TABLENAME}                     
                         WHERE {&TABLENAME}.serie-docto  >= cIniSerieDocto                 
                           AND {&TABLENAME}.serie-docto  <= cEndSerieDocto               
                           AND {&TABLENAME}.nro-docto    >= cIniNroDocto              
                           AND {&TABLENAME}.nro-docto    <= cEndNroDocto                
                           AND {&TABLENAME}.cod-emitente >= iIniEmitente                       
                           AND {&TABLENAME}.cod-emitente <= iEndEmitente              
                           AND {&TABLENAME}.nat-operacao >= cIniNatureza            
                           AND {&TABLENAME}.nat-operacao <= cEndNatureza               
                           AND {&TABLENAME}.dt-trans     >= dIniDtTrans               
                           AND {&TABLENAME}.dt-trans     <= dEndDtTrans               
                           AND {&TABLENAME}.cod-estabel  >= cIniCodEstabel            
                           AND {&TABLENAME}.cod-estabel  <= cEndCodEstabel           
                           AND {&TABLENAME}.usuario      >= cIniUsuario                
                           AND {&TABLENAME}.usuario      <= cEndUsuario
                           NO-LOCK INDEXED-REPOSITION.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintRowid DBOProgram 
PROCEDURE setConstraintRowid :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pRowidTable AS ROWID NO-UNDO.

ASSIGN rRowid = pRowidTable.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintTMS DBOProgram 
PROCEDURE setConstraintTMS :
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setRecordTMS DBOProgram 
PROCEDURE setRecordTMS :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM TABLE FOR tt-docum-est.

        FOR EACH RowObject:
            DELETE ROwObject.
        END.

        FOR EACH tt-docum-est:
            CREATE RowObject.
            BUFFER-COPY tt-docum-est TO RowObject.
        END.
        
        RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

