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
{include/i-prgvrs.i BOAD107NA 2.00.00.042 } /*** "010042" 10/06/2025 09:30:37 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boad107na MUT}
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
&GLOBAL-DEFINE DBOName BOAD107
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName estabelec
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

&GLOBAL-DEFINE XMLReceiver YES
&GLOBAL-DEFINE XMLProducer YES  
&GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES

/*--- Include com defini‡Æo da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com 
      extensÆo .i ---*/
{adbo/boad107na.i RowObject}
{adbo/boad107na.i tt-estabelec-aux}

{java/boRest.i}

/*--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}

{cdp/cdcfgdis.i}

/*--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE c-cod-estabel-ini LIKE estabelec.cod-estabel NO-UNDO.
DEFINE VARIABLE c-cod-estabel-fim LIKE estabelec.cod-estabel NO-UNDO.
DEFINE VARIABLE i-cod-emitente-ini LIKE estabelec.cod-emitente NO-UNDO.
DEFINE VARIABLE i-cod-emitente-fim LIKE estabelec.cod-emitente NO-UNDO.
DEFINE VARIABLE c-nome-ini LIKE estabelec.nome NO-UNDO.
DEFINE VARIABLE c-nome-fim LIKE estabelec.nome NO-UNDO.
DEFINE VARIABLE c-cod-empresa LIKE estabelec.ep-codigo NO-UNDO.
DEFINE VARIABLE i-cod-emitente-cv AS INTEGER   NO-UNDO.
DEFINE VARIABLE c-it-codigo-cv    AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cod-refer-cv    AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-fm-codigo-cv    AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-fm-cod-com-cv   AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-nome-mic-reg-cv AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-nome-ab-reg-cv  AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cidade-cv       AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-estado-cv       AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-pais-cv         AS CHARACTER NO-UNDO.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getBatchRecordsCustom DBOProgram 
PROCEDURE getBatchRecordsCustom :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
---------------------------------------------------------------------- --------*/
	DEFINE OUTPUT PARAMETER TABLE FOR tt-estabelec-aux.
		
    FOR EACH tt-estabelec-aux:
		DELETE tt-estabelec-aux.
	END.

    FOR EACH estabelec WHERE {&TableName}.ep-codigo = c-cod-empresa NO-LOCK:
        CREATE tt-estabelec-aux.
		BUFFER-COPY estabelec TO tt-estabelec-aux.
	END.
	
    
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
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        &IF "{&mguni_version}" >= "2.071" &THEN
            WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
        &ENDIF
        WHEN "bairro":U THEN ASSIGN pFieldValue = RowObject.bairro.
        WHEN "cd-calen":U THEN ASSIGN pFieldValue = RowObject.cd-calen.
        WHEN "cgc":U THEN ASSIGN pFieldValue = RowObject.cgc.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        &if defined(bf-dis-comex) &then
        WHEN "ct-cofins-ft":U THEN ASSIGN pFieldValue = string(RowObject.ct-cofins-ft).
        WHEN "ct-credito":U THEN ASSIGN pFieldValue = string(RowObject.ct-credito).
        WHEN "ct-desp-iof":U THEN ASSIGN pFieldValue = string(RowObject.ct-desp-iof).
        WHEN "ct-desp-juros":U THEN ASSIGN pFieldValue = string(RowObject.ct-desp-juros).
        WHEN "ct-desp-juros-avc":U THEN ASSIGN pFieldValue = string(RowObject.ct-desp-juros-avc).
        WHEN "ct-despesa":U THEN ASSIGN pFieldValue = string(RowObject.ct-despesa).
        WHEN "ct-equaliz-desp":U THEN ASSIGN pFieldValue = string(RowObject.ct-equaliz-desp).
        WHEN "ct-equaliz-rec":U THEN ASSIGN pFieldValue = string(RowObject.ct-equaliz-rec).
        WHEN "ct-ext-icms":U THEN ASSIGN pFieldValue = string(RowObject.ct-ext-icms).
        WHEN "ct-ext-ipi":U THEN ASSIGN pFieldValue = string(RowObject.ct-ext-ipi).
        WHEN "ct-fins-pg":U THEN ASSIGN pFieldValue = string(RowObject.ct-fins-pg).
        WHEN "ct-finsoc":U THEN ASSIGN pFieldValue = string(RowObject.ct-finsoc).
        WHEN "ct-icm":U THEN ASSIGN pFieldValue = string(RowObject.ct-icm).
        WHEN "ct-icms-comp":U THEN ASSIGN pFieldValue = string(RowObject.ct-icms-comp).
        WHEN "ct-icms-dev":U THEN ASSIGN pFieldValue = string(RowObject.ct-icms-dev).
        WHEN "ct-icms-ft":U THEN ASSIGN pFieldValue = string(RowObject.ct-icms-ft).
        WHEN "ct-icmsub-ft":U THEN ASSIGN pFieldValue = string(RowObject.ct-icmsub-ft).
        WHEN "ct-ipi":U THEN ASSIGN pFieldValue = string(RowObject.ct-ipi).
        WHEN "ct-ipi-dev":U THEN ASSIGN pFieldValue = string(RowObject.ct-ipi-dev).
        WHEN "ct-ipi-ft":U THEN ASSIGN pFieldValue = string(RowObject.ct-ipi-ft).
        WHEN "ct-ir-ret":U THEN ASSIGN pFieldValue = string(RowObject.ct-ir-ret).
        WHEN "ct-iss":U THEN ASSIGN pFieldValue = string(RowObject.ct-iss).
        WHEN "ct-iss-ft":U THEN ASSIGN pFieldValue = string(RowObject.ct-iss-ft).
        WHEN "ct-pis":U THEN ASSIGN pFieldValue = string(RowObject.ct-pis).
        WHEN "ct-pis-pg":U THEN ASSIGN pFieldValue = string(RowObject.ct-pis-pg).
        WHEN "sc-cofins-ft":U THEN ASSIGN pFieldValue = string(RowObject.sc-cofins-ft).
        WHEN "sc-credito":U THEN ASSIGN pFieldValue = string(RowObject.sc-credito).
        WHEN "sc-desp-iof":U THEN ASSIGN pFieldValue = string(RowObject.sc-desp-iof).
        WHEN "sc-desp-juros":U THEN ASSIGN pFieldValue = string(RowObject.sc-desp-juros).
        WHEN "sc-desp-juros-avc":U THEN ASSIGN pFieldValue = string(RowObject.sc-desp-juros-avc).
        WHEN "sc-despesa":U THEN ASSIGN pFieldValue = string(RowObject.sc-despesa).
        WHEN "sc-equaliz-desp":U THEN ASSIGN pFieldValue = string(RowObject.sc-equaliz-desp).
        WHEN "sc-equaliz-rec":U THEN ASSIGN pFieldValue = string(RowObject.sc-equaliz-rec).
        WHEN "sc-ext-icms":U THEN ASSIGN pFieldValue = string(RowObject.sc-ext-icms).
        WHEN "sc-ext-ipi":U THEN ASSIGN pFieldValue = string(RowObject.sc-ext-ipi).
        WHEN "sc-fins-pg":U THEN ASSIGN pFieldValue = string(RowObject.sc-fins-pg).
        WHEN "sc-finsoc":U THEN ASSIGN pFieldValue = string(RowObject.sc-finsoc).
        WHEN "sc-icm":U THEN ASSIGN pFieldValue = string(RowObject.sc-icm).
        WHEN "sc-icms-comp":U THEN ASSIGN pFieldValue = string(RowObject.sc-icms-comp).
        WHEN "sc-icms-dev":U THEN ASSIGN pFieldValue = string(RowObject.sc-icms-dev).
        WHEN "sc-icms-ft":U THEN ASSIGN pFieldValue = string(RowObject.sc-icms-ft).
        WHEN "sc-icmsub-ft":U THEN ASSIGN pFieldValue = string(RowObject.sc-icmsub-ft).
        WHEN "sc-ipi":U THEN ASSIGN pFieldValue = string(RowObject.sc-ipi).
        WHEN "sc-ipi-dev":U THEN ASSIGN pFieldValue = string(RowObject.sc-ipi-dev).
        WHEN "sc-ipi-ft":U THEN ASSIGN pFieldValue = string(RowObject.sc-ipi-ft).
        WHEN "sc-ir-ret":U THEN ASSIGN pFieldValue = string(RowObject.sc-ir-ret).
        WHEN "sc-iss":U THEN ASSIGN pFieldValue = string(RowObject.sc-iss).
        WHEN "sc-iss-ft":U THEN ASSIGN pFieldValue = string(RowObject.sc-iss-ft).
        WHEN "sc-pis":U THEN ASSIGN pFieldValue = string(RowObject.sc-pis).
        WHEN "sc-pis-pg":U THEN ASSIGN pFieldValue = string(RowObject.sc-pis-pg).
        &else
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "conta-cofins":U THEN ASSIGN pFieldValue = RowObject.conta-cofins.
        WHEN "condado":U THEN ASSIGN pFieldValue = RowObject.condado.
        WHEN "conta-credito":U THEN ASSIGN pFieldValue = RowObject.conta-credito.
        WHEN "conta-cusprod":U THEN ASSIGN pFieldValue = RowObject.conta-cusprod.
        WHEN "conta-desconto":U THEN ASSIGN pFieldValue = RowObject.conta-desconto.
        WHEN "conta-desp-equaliz":U THEN ASSIGN pFieldValue = RowObject.conta-desp-equaliz.
        WHEN "conta-desp-fin":U THEN ASSIGN pFieldValue = RowObject.conta-desp-fin.
        WHEN "conta-desp-icms":U THEN ASSIGN pFieldValue = RowObject.conta-desp-icms.
        WHEN "conta-desp-iof":U THEN ASSIGN pFieldValue = RowObject.conta-desp-iof.
        WHEN "conta-desp-iss":U THEN ASSIGN pFieldValue = RowObject.conta-desp-iss.
        WHEN "conta-despesas":U THEN ASSIGN pFieldValue = RowObject.conta-despesas.
        WHEN "conta-dev-icms":U THEN ASSIGN pFieldValue = RowObject.conta-dev-icms.
        WHEN "conta-dev-ipi":U THEN ASSIGN pFieldValue = RowObject.conta-dev-ipi.
        WHEN "conta-devolucao":U THEN ASSIGN pFieldValue = RowObject.conta-devolucao.
        WHEN "conta-extorno-icms":U THEN ASSIGN pFieldValue = RowObject.conta-extorno-icms.
        WHEN "conta-extorno-ipi":U THEN ASSIGN pFieldValue = RowObject.conta-extorno-ipi.
        WHEN "conta-fin-pag":U THEN ASSIGN pFieldValue = RowObject.conta-fin-pag.
        WHEN "conta-icms":U THEN ASSIGN pFieldValue = RowObject.conta-icms.
        WHEN "conta-icms-comp":U THEN ASSIGN pFieldValue = RowObject.conta-icms-comp.
        WHEN "conta-icms-ft":U THEN ASSIGN pFieldValue = RowObject.conta-icms-ft.
        WHEN "conta-icms-ret":U THEN ASSIGN pFieldValue = RowObject.conta-icms-ret.
        WHEN "conta-icmsremes":U THEN ASSIGN pFieldValue = RowObject.conta-icmsremes.
        WHEN "conta-icmsub-ft":U THEN ASSIGN pFieldValue = RowObject.conta-icmsub-ft.
        WHEN "conta-ipi":U THEN ASSIGN pFieldValue = RowObject.conta-ipi.
        WHEN "conta-ipi-fat":U THEN ASSIGN pFieldValue = RowObject.conta-ipi-fat.
        WHEN "conta-ir-ret":U THEN ASSIGN pFieldValue = RowObject.conta-ir-ret.
        WHEN "conta-iss":U THEN ASSIGN pFieldValue = RowObject.conta-iss.
        WHEN "conta-juros-pagos":U THEN ASSIGN pFieldValue = RowObject.conta-juros-pagos.
        WHEN "conta-pis":U THEN ASSIGN pFieldValue = RowObject.conta-pis.
        WHEN "conta-pis-pag":U THEN ASSIGN pFieldValue = RowObject.conta-pis-pag.
        WHEN "conta-pis-rec":U THEN ASSIGN pFieldValue = RowObject.conta-pis-rec.
        WHEN "conta-rec-equaliz":U THEN ASSIGN pFieldValue = RowObject.conta-rec-equaliz.
        WHEN "conta-recven":U THEN ASSIGN pFieldValue = RowObject.conta-recven.
        WHEN "ct-cofins-ft":U THEN ASSIGN pFieldValue = RowObject.ct-cofins-ft.
        WHEN "ct-cusprod":U THEN ASSIGN pFieldValue = RowObject.ct-cusprod.
        WHEN "ct-desconto":U THEN ASSIGN pFieldValue = RowObject.ct-desconto.
        WHEN "ct-desp-iof":U THEN ASSIGN pFieldValue = RowObject.ct-desp-iof.
        WHEN "ct-desp-juros":U THEN ASSIGN pFieldValue = RowObject.ct-desp-juros.
        WHEN "ct-desp-juros-avc":U THEN ASSIGN pFieldValue = RowObject.ct-desp-juros-avc.
        WHEN "ct-despesa":U THEN ASSIGN pFieldValue = RowObject.ct-despesa.
        WHEN "ct-devolucao":U THEN ASSIGN pFieldValue = RowObject.ct-devolucao.
        WHEN "ct-equaliz-desp":U THEN ASSIGN pFieldValue = RowObject.ct-equaliz-desp.
        WHEN "ct-equaliz-rec":U THEN ASSIGN pFieldValue = RowObject.ct-equaliz-rec.
        WHEN "ct-ext-icms":U THEN ASSIGN pFieldValue = RowObject.ct-ext-icms.
        WHEN "ct-ext-ipi":U THEN ASSIGN pFieldValue = RowObject.ct-ext-ipi.
        WHEN "ct-fins-pg":U THEN ASSIGN pFieldValue = RowObject.ct-fins-pg.
        WHEN "ct-finsoc":U THEN ASSIGN pFieldValue = RowObject.ct-finsoc.
        WHEN "ct-icm":U THEN ASSIGN pFieldValue = RowObject.ct-icm.
        WHEN "ct-icms-comp":U THEN ASSIGN pFieldValue = RowObject.ct-icms-comp.
        WHEN "ct-icms-dev":U THEN ASSIGN pFieldValue = RowObject.ct-icms-dev.
        WHEN "ct-icms-ft":U THEN ASSIGN pFieldValue = RowObject.ct-icms-ft.
        WHEN "ct-icmsremes":U THEN ASSIGN pFieldValue = RowObject.ct-icmsremes.
        WHEN "ct-icmsub-ft":U THEN ASSIGN pFieldValue = RowObject.ct-icmsub-ft.
        WHEN "ct-ipi":U THEN ASSIGN pFieldValue = RowObject.ct-ipi.
        WHEN "ct-ipi-dev":U THEN ASSIGN pFieldValue = RowObject.ct-ipi-dev.
        WHEN "ct-ipi-ft":U THEN ASSIGN pFieldValue = RowObject.ct-ipi-ft.
        WHEN "ct-ir-ret":U THEN ASSIGN pFieldValue = RowObject.ct-ir-ret.
        WHEN "ct-iss":U THEN ASSIGN pFieldValue = RowObject.ct-iss.
        WHEN "ct-iss-ft":U THEN ASSIGN pFieldValue = RowObject.ct-iss-ft.
        WHEN "ct-pis":U THEN ASSIGN pFieldValue = RowObject.ct-pis.
        WHEN "ct-pis-pg":U THEN ASSIGN pFieldValue = RowObject.ct-pis-pg.
        WHEN "ct-recven":U THEN ASSIGN pFieldValue = RowObject.ct-recven.
        WHEN "grupo-aloca":U THEN ASSIGN pFieldValue = RowObject.grupo-aloca.
        WHEN "sc-cofins-ft":U THEN ASSIGN pFieldValue = RowObject.sc-cofins-ft.
        WHEN "sc-credito":U THEN ASSIGN pFieldValue = RowObject.sc-credito.
        WHEN "sc-cusprod":U THEN ASSIGN pFieldValue = RowObject.sc-cusprod.
        WHEN "sc-desconto":U THEN ASSIGN pFieldValue = RowObject.sc-desconto.
        WHEN "sc-desp-iof":U THEN ASSIGN pFieldValue = RowObject.sc-desp-iof.
        WHEN "sc-desp-juros":U THEN ASSIGN pFieldValue = RowObject.sc-desp-juros.
        WHEN "sc-desp-juros-avc":U THEN ASSIGN pFieldValue = RowObject.sc-desp-juros-avc.
        WHEN "sc-despesa":U THEN ASSIGN pFieldValue = RowObject.sc-despesa.
        WHEN "sc-devolucao":U THEN ASSIGN pFieldValue = RowObject.sc-devolucao.
        WHEN "sc-equaliz-desp":U THEN ASSIGN pFieldValue = RowObject.sc-equaliz-desp.
        WHEN "sc-equaliz-rec":U THEN ASSIGN pFieldValue = RowObject.sc-equaliz-rec.
        WHEN "sc-ext-icms":U THEN ASSIGN pFieldValue = RowObject.sc-ext-icms.
        WHEN "sc-ext-ipi":U THEN ASSIGN pFieldValue = RowObject.sc-ext-ipi.
        WHEN "sc-fins-pg":U THEN ASSIGN pFieldValue = RowObject.sc-fins-pg.
        WHEN "sc-finsoc":U THEN ASSIGN pFieldValue = RowObject.sc-finsoc.
        WHEN "sc-icm":U THEN ASSIGN pFieldValue = RowObject.sc-icm.
        WHEN "sc-icms-comp":U THEN ASSIGN pFieldValue = RowObject.sc-icms-comp.
        WHEN "sc-icms-dev":U THEN ASSIGN pFieldValue = RowObject.sc-icms-dev.
        WHEN "sc-icms-ft":U THEN ASSIGN pFieldValue = RowObject.sc-icms-ft.
        WHEN "sc-icmsremes":U THEN ASSIGN pFieldValue = RowObject.sc-icmsremes.
        WHEN "sc-icmsub-ft":U THEN ASSIGN pFieldValue = RowObject.sc-icmsub-ft.
        WHEN "sc-ipi":U THEN ASSIGN pFieldValue = RowObject.sc-ipi.
        WHEN "sc-ipi-dev":U THEN ASSIGN pFieldValue = RowObject.sc-ipi-dev.
        WHEN "sc-ipi-ft":U THEN ASSIGN pFieldValue = RowObject.sc-ipi-ft.
        WHEN "sc-ir-ret":U THEN ASSIGN pFieldValue = RowObject.sc-ir-ret.
        WHEN "sc-iss":U THEN ASSIGN pFieldValue = RowObject.sc-iss.
        WHEN "sc-iss-ft":U THEN ASSIGN pFieldValue = RowObject.sc-iss-ft.
        WHEN "sc-pis":U THEN ASSIGN pFieldValue = RowObject.sc-pis.
        WHEN "sc-pis-pg":U THEN ASSIGN pFieldValue = RowObject.sc-pis-pg.
        WHEN "sc-recven":U THEN ASSIGN pFieldValue = RowObject.sc-recven.
        &endif
        WHEN "cidade":U THEN ASSIGN pFieldValue = RowObject.cidade.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-suframa":U THEN ASSIGN pFieldValue = RowObject.cod-suframa.
/*        WHEN "conta-desp-cart-pagas":U THEN ASSIGN pFieldValue = RowObject.conta-desp-cart-pagas.*/
/*        WHEN "conta-desp-cart-receb":U THEN ASSIGN pFieldValue = RowObject.conta-desp-cart-receb.*/
/*        WHEN "ct-conta-desp-cart-pagas":U THEN ASSIGN pFieldValue = RowObject.ct-conta-desp-cart-pagas.*/
/*        WHEN "ct-desp-cart-receb":U THEN ASSIGN pFieldValue = RowObject.ct-desp-cart-receb.*/
        WHEN "dep-rej-cq":U THEN ASSIGN pFieldValue = RowObject.dep-rej-cq.
        WHEN "deposito-cq":U THEN ASSIGN pFieldValue = RowObject.deposito-cq.
        WHEN "endereco":U THEN ASSIGN pFieldValue = RowObject.endereco.
        WHEN "estado":U THEN ASSIGN pFieldValue = RowObject.estado.
        WHEN "ins-estadual":U THEN ASSIGN pFieldValue = RowObject.ins-estadual.
        WHEN "ins-municipal":U THEN ASSIGN pFieldValue = RowObject.ins-municipal.
        WHEN "nome":U THEN do:
            IF INDEX(RowObject.nome, ENTRY(1, ",", ";")) > 0 THEN
                ASSIGN pFieldValue = REPLACE(RowObject.nome, ENTRY(1, ",", ";"), ENTRY(1, " ", ";")).
            ELSE
                ASSIGN pFieldValue = RowObject.nome.
                
        END.
        WHEN "pais":U THEN ASSIGN pFieldValue = RowObject.pais.
        WHEN "permissao":U THEN ASSIGN pFieldValue = RowObject.permissao.
/*        WHEN "sc-conta-desp-cart-pagas":U THEN ASSIGN pFieldValue = RowObject.sc-conta-desp-cart-pagas.*/
/*        WHEN "sc-desp-cart-receb":U THEN ASSIGN pFieldValue = RowObject.sc-desp-cart-receb.*/
        WHEN "serie":U THEN ASSIGN pFieldValue = RowObject.serie.
        WHEN "serie-manual":U THEN ASSIGN pFieldValue = RowObject.serie-manual.
        WHEN "zip-cod":U THEN ASSIGN pFieldValue = RowObject.zip-cod.
        &IF '{&bf_dis_versao_ems}' >= '2.08' &THEN
        WHEN "cod-cta-icms-antecip" THEN ASSIGN pFieldValue = RowObject.cod-cta-icms-antecip. 
        WHEN "cod-cta-transit-icms-antecip" THEN ASSIGN pFieldValue = RowObject.cod-cta-transit-icms-antecip.
        &ENDIF
        WHEN "des-vers-layout" THEN ASSIGN pFieldValue = &IF "{&bf_dis_versao_ems}" >= "2.071" &THEN 
                                                             TRIM(RowObject.des-vers-layout) 
                                                         &ELSE 
                                                             TRIM(SUBSTRING(RowObject.char-1,173,10)) 
                                                         &ENDIF .
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
        WHEN "dt-vcto-cofins[1]":U THEN ASSIGN pFieldValue = RowObject.dt-vcto-cofins[1].
        WHEN "dt-vcto-cofins[2]":U THEN ASSIGN pFieldValue = RowObject.dt-vcto-cofins[2].
        WHEN "dt-vcto-cofins[3]":U THEN ASSIGN pFieldValue = RowObject.dt-vcto-cofins[3].
        WHEN "dt-vcto-icms[1]":U THEN ASSIGN pFieldValue = RowObject.dt-vcto-icms[1].
        WHEN "dt-vcto-icms[2]":U THEN ASSIGN pFieldValue = RowObject.dt-vcto-icms[2].
        WHEN "dt-vcto-icms[3]":U THEN ASSIGN pFieldValue = RowObject.dt-vcto-icms[3].
        WHEN "dt-vcto-ipi[1]":U THEN ASSIGN pFieldValue = RowObject.dt-vcto-ipi[1].
        WHEN "dt-vcto-ipi[2]":U THEN ASSIGN pFieldValue = RowObject.dt-vcto-ipi[2].
        WHEN "dt-vcto-ipi[3]":U THEN ASSIGN pFieldValue = RowObject.dt-vcto-ipi[3].
        WHEN "dt-vcto-irrf[1]":U THEN ASSIGN pFieldValue = RowObject.dt-vcto-irrf[1].
        WHEN "dt-vcto-irrf[2]":U THEN ASSIGN pFieldValue = RowObject.dt-vcto-irrf[2].
        WHEN "dt-vcto-irrf[3]":U THEN ASSIGN pFieldValue = RowObject.dt-vcto-irrf[3].
        WHEN "dt-vcto-iss[1]":U THEN ASSIGN pFieldValue = RowObject.dt-vcto-iss[1].
        WHEN "dt-vcto-iss[2]":U THEN ASSIGN pFieldValue = RowObject.dt-vcto-iss[2].
        WHEN "dt-vcto-iss[3]":U THEN ASSIGN pFieldValue = RowObject.dt-vcto-iss[3].
        WHEN "dt-vcto-pis[1]":U THEN ASSIGN pFieldValue = RowObject.dt-vcto-pis[1].
        WHEN "dt-vcto-pis[2]":U THEN ASSIGN pFieldValue = RowObject.dt-vcto-pis[2].
        WHEN "dt-vcto-pis[3]":U THEN ASSIGN pFieldValue = RowObject.dt-vcto-pis[3].
        WHEN "medio-ate":U THEN ASSIGN pFieldValue = RowObject.medio-ate.
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
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        &if defined(bf-dis-comex) &then
        &else
        WHEN "qtd-up-prod[1]":U THEN ASSIGN pFieldValue = RowObject.qtd-up-prod[1].
        WHEN "qtd-up-prod[2]":U THEN ASSIGN pFieldValue = RowObject.qtd-up-prod[2].
        WHEN "qtd-up-prod[3]":U THEN ASSIGN pFieldValue = RowObject.qtd-up-prod[3].
        WHEN "tax-cidade":U THEN ASSIGN pFieldValue = RowObject.tax-cidade.
        WHEN "tax-condado":U THEN ASSIGN pFieldValue = RowObject.tax-condado.
        WHEN "tax-estado":U THEN ASSIGN pFieldValue = RowObject.tax-estado.
        WHEN "val-desp-total[1]":U THEN ASSIGN pFieldValue = RowObject.val-desp-total[1].
        WHEN "val-desp-total[2]":U THEN ASSIGN pFieldValue = RowObject.val-desp-total[2].
        WHEN "val-desp-total[3]":U THEN ASSIGN pFieldValue = RowObject.val-desp-total[3].
        WHEN "val-unit-up[1]":U THEN ASSIGN pFieldValue = RowObject.val-unit-up[1].
        WHEN "val-unit-up[2]":U THEN ASSIGN pFieldValue = RowObject.val-unit-up[2].
        WHEN "val-unit-up[3]":U THEN ASSIGN pFieldValue = RowObject.val-unit-up[3].
        &endif
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
        WHEN "cep":U THEN ASSIGN pFieldValue = RowObject.cep.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        &if defined(bf-dis-comex) &then
        &else        
        WHEN "cod-isencao":U THEN ASSIGN pFieldValue = RowObject.cod-isencao.
        WHEN "cod-sit-aval":U THEN ASSIGN pFieldValue = RowObject.cod-sit-aval.
        WHEN "custo-contab":U THEN ASSIGN pFieldValue = RowObject.custo-contab.
        &endif
        &IF "{&mguni_version}" < "2.071" &THEN
            WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
        &ENDIF
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
/*        WHEN "integr-ncr-app":U THEN ASSIGN pFieldValue = RowObject.integr-ncr-app.*/
/*        WHEN "integr-ncr-crp":U THEN ASSIGN pFieldValue = RowObject.integr-ncr-crp.*/
        &if '{&bf_dis_versao_ems}' >= '2.071'  &then
            WHEN "idi-tip-layout":U THEN ASSIGN pFieldValue = RowObject.idi-tip-layout.
            WHEN "idi-tip-transm":U THEN ASSIGN pFieldValue = RowObject.idi-tip-transm.
        &else
            WHEN "idi-tip-layout":U THEN ASSIGN pFieldValue = int(substr(RowObject.char-1,171,1)).
            WHEN "idi-tip-transm":U THEN ASSIGN pFieldValue = int(substr(RowObject.char-1,172,1)).
        &endif
        &if "{&bf_dis_versao_ems}" >= "2.07" &then
            WHEN "idi-tip-emis-nf-eletro":U THEN ASSIGN pFieldValue = RowObject.idi-tip-emis-nf-eletro.
        &else
            WHEN "idi-tip-emis-nf-eletro":U THEN ASSIGN pFieldValue = INT(SUBSTRING(RowObject.char-1,168,1)).
        &endif
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
               retorna valor do campo cod-estabel
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE estabelec.cod-estabel NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-estabel = RowObject.cod-estabel.

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
        &if defined(bf-dis-comex) &then
        &else            
        WHEN "cons-ap":U THEN ASSIGN pFieldValue = RowObject.cons-ap.
        WHEN "cons-cent-vend":U THEN ASSIGN pFieldValue = RowObject.cons-cent-vend.
        WHEN "cons-comp-corp":U THEN ASSIGN pFieldValue = RowObject.cons-comp-corp.
        WHEN "cons-cpv":U THEN ASSIGN pFieldValue = RowObject.cons-cpv.
        WHEN "cons-cr":U THEN ASSIGN pFieldValue = RowObject.cons-cr.
        WHEN "cons-ft":U THEN ASSIGN pFieldValue = RowObject.cons-ft.
        WHEN "cons-pd":U THEN ASSIGN pFieldValue = RowObject.cons-pd.
        WHEN "cons-transf-mat":U THEN ASSIGN pFieldValue = RowObject.cons-transf-mat.
        WHEN "usa-mensal":U THEN ASSIGN pFieldValue = RowObject.usa-mensal.
        WHEN "usa-on-line":U THEN ASSIGN pFieldValue = RowObject.usa-on-line.
        WHEN "usa-padrao":U THEN ASSIGN pFieldValue = RowObject.usa-padrao.
        &endif
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        &if '{&bf_dis_versao_ems}' >= '2.071'  &then
            WHEN "log-emite-danfe":U THEN ASSIGN pFieldValue = RowObject.log-emite-danfe.
        &else
            WHEN "log-emite-danfe":U THEN ASSIGN pFieldValue = substr(RowObject.char-1,169,1) = "S".
        &endif
        WHEN "log-emite-carta-correc" THEN ASSIGN pFieldValue = &IF "{&bf_dis_versao_ems}" >= "2.09" &THEN 
                                                                RowObject.log-emit-carta-correc
                                                                &ELSE 
                                                                LOGICAL(SUBSTRING(RowObject.char-1,261,1) = "S") 
                                                                &ENDIF .
        WHEN "log-impto-consum":U THEN ASSIGN pFieldValue = RowObject.log-impto-consum.
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
               recebe valor do campo cod-estabel
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE estabelec.cod-estabel NO-UNDO.

    FIND FIRST bfestabelec WHERE 
        bfestabelec.cod-estabel = pcod-estabel NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfestabelec THEN 
        RETURN "NOK":U.
    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfestabelec)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFaixaEmitente DBOProgram 
PROCEDURE openQueryFaixaEmitente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} 
        FOR EACH {&TableName} 
           WHERE {&TableName}.cod-emitente  >=  i-cod-emitente-ini 
             AND {&TableName}.cod-emitente  <=  i-cod-emitente-fim 
             NO-LOCK.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFaixaEstabel DBOProgram 
PROCEDURE openQueryFaixaEstabel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH {&TableName} WHERE
         {&TableName}.cod-estabel  >=  c-cod-estabel-ini  and
         {&TableName}.cod-estabel  <=  c-cod-estabel-fim
         NO-LOCK.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFaixaNome DBOProgram 
PROCEDURE openQueryFaixaNome :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH {&TableName} WHERE
         {&TableName}.nome  >=  c-nome-ini  and
         {&TableName}.nome  <=  c-nome-fim  NO-LOCK
         BY {&TableName}.nome.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFaixaEstabel DBOProgram 
PROCEDURE openQueryFaixaEstabelAtendByCentralVendas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAM TABLE FOR rowObject.

    EMPTY TEMP-TABLE rowObject.

    FOR EACH relac-estab-atend NO-LOCK
        WHERE (relac-estab-atend.cd-emitente     = i-cod-emitente-cv OR relac-estab-atend.cd-emitente     = ?)
          AND (relac-estab-atend.it-codigo       = c-it-codigo-cv    OR relac-estab-atend.it-codigo       = ?)
          AND (relac-estab-atend.cod-refer       = c-cod-refer-cv    OR relac-estab-atend.cod-refer       = ?)
          AND (relac-estab-atend.fm-codigo       = c-fm-codigo-cv    OR relac-estab-atend.fm-codigo       = ?)
          AND (relac-estab-atend.fm-cod-com      = c-fm-cod-com-cv   OR relac-estab-atend.fm-cod-com      = ?)
          AND (relac-estab-atend.nom-micror-dest = c-nome-mic-reg-cv OR relac-estab-atend.nom-micror-dest = ?)
          AND (relac-estab-atend.nome-ab-reg     = c-nome-ab-reg-cv  OR relac-estab-atend.nome-ab-reg     = ?)
          AND (relac-estab-atend.cidade          = c-cidade-cv       OR relac-estab-atend.cidade          = ?)
          AND (relac-estab-atend.estado          = c-estado-cv       OR relac-estab-atend.estado          = ?)
          AND (relac-estab-atend.pais            = c-pais-cv         OR relac-estab-atend.pais            = ?),
        EACH estabelec NO-LOCK
        WHERE estabelec.cod-estabel = relac-estab-atend.estab-atend
          AND estabelec.cod-estabel >=  c-cod-estabel-ini
          AND estabelec.cod-estabel <=  c-cod-estabel-fim:

        IF NOT CAN-FIND (FIRST rowObject
                         WHERE rowObject.cod-estabel = estabelec.cod-estabel) THEN DO:
            CREATE rowObject.
            BUFFER-COPY estabelec TO rowObject.
        END.
    END.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFaixaNome DBOProgram 
PROCEDURE openQueryFaixaNomeAtendByCentralVendas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAM TABLE FOR rowObject.

    EMPTY TEMP-TABLE rowObject.

    FOR EACH relac-estab-atend NO-LOCK
        WHERE (relac-estab-atend.cd-emitente     = i-cod-emitente-cv OR relac-estab-atend.cd-emitente     = ?)
          AND (relac-estab-atend.it-codigo       = c-it-codigo-cv    OR relac-estab-atend.it-codigo       = ?)
          AND (relac-estab-atend.cod-refer       = c-cod-refer-cv    OR relac-estab-atend.cod-refer       = ?)
          AND (relac-estab-atend.fm-codigo       = c-fm-codigo-cv    OR relac-estab-atend.fm-codigo       = ?)
          AND (relac-estab-atend.fm-cod-com      = c-fm-cod-com-cv   OR relac-estab-atend.fm-cod-com      = ?)
          AND (relac-estab-atend.nom-micror-dest = c-nome-mic-reg-cv OR relac-estab-atend.nom-micror-dest = ?)
          AND (relac-estab-atend.nome-ab-reg     = c-nome-ab-reg-cv  OR relac-estab-atend.nome-ab-reg     = ?)
          AND (relac-estab-atend.cidade          = c-cidade-cv       OR relac-estab-atend.cidade          = ?)
          AND (relac-estab-atend.estado          = c-estado-cv       OR relac-estab-atend.estado          = ?)
          AND (relac-estab-atend.pais            = c-pais-cv         OR relac-estab-atend.pais            = ?),
        EACH estabelec NO-LOCK
        WHERE estabelec.cod-estabel = relac-estab-atend.estab-atend
          AND estabelec.nome       >=  c-nome-ini
          AND estabelec.nome       <=  c-nome-fim:

        IF NOT CAN-FIND (FIRST rowObject
                         WHERE rowObject.cod-estabel = estabelec.cod-estabel) THEN DO:
            CREATE rowObject.
            BUFFER-COPY estabelec TO rowObject.
        END.
    END.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByEmpresa DBOProgram 
PROCEDURE openQueryByEmpresa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
---------------------------------------------------------------------- --------*/

    OPEN QUERY {&QueryName} FOR EACH {&TableName} WHERE
               {&TableName}.ep-codigo = c-cod-empresa.
	
    
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

    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK.

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaTipoEmissaoNfe DBOProgram 
PROCEDURE retornaTipoEmissaoNfe :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE estabelec.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER ptipo    AS INT NO-UNDO.

    FIND FIRST bfestabelec 
         WHERE bfestabelec.cod-estabel = pcod-estabel NO-LOCK NO-ERROR.
    IF AVAIL bfestabelec THEN DO:
        &if "{&BF_DIS_VERSAO_EMS}" >= "2.07" &then
            ASSIGN ptipo = estabelec.idi-tip-emis-nf-eletro.
        &else
            ASSIGN ptipo = int(SUBST(estabelec.char-1,168,1)).
        &endif
    END.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFaixaEmitente DBOProgram 
PROCEDURE setConstraintFaixaEmitente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM p-cod-emitente-ini LIKE estabelec.cod-emitente NO-UNDO.
    DEF INPUT PARAM p-cod-emitente-fim LIKE estabelec.cod-emitente NO-UNDO.
    
    ASSIGN i-cod-emitente-ini = p-cod-emitente-ini
           i-cod-emitente-fim = p-cod-emitente-fim.
           
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFaixaEstabel DBOProgram 
PROCEDURE setConstraintFaixaEstabel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM p-cod-estabel-ini LIKE estabelec.cod-estabel NO-UNDO.
    DEF INPUT PARAM p-cod-estabel-fim LIKE estabelec.cod-estabel NO-UNDO.
    
    ASSIGN c-cod-estabel-ini = p-cod-estabel-ini
           c-cod-estabel-fim = p-cod-estabel-fim.
           
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFaixaNome DBOProgram 
PROCEDURE setConstraintFaixaNome :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM pc-nome-ini LIKE estabelec.nome NO-UNDO.
    DEF INPUT PARAM pc-nome-fim LIKE estabelec.nome NO-UNDO.
    
    ASSIGN c-nome-ini = pc-nome-ini
           c-nome-fim = pc-nome-fim.
           
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFaixaNome DBOProgram 
PROCEDURE setConstraintFaixaEstabelByCentralVendas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM p-cod-estabel-ini LIKE estabelec.cod-estabel NO-UNDO.
    DEF INPUT PARAM p-cod-estabel-fim LIKE estabelec.cod-estabel NO-UNDO.
    DEF INPUT PARAM pcod-emitente     AS INTEGER               NO-UNDO.
    DEF INPUT PARAM pit-codigo        AS CHARACTER             NO-UNDO.
    DEF INPUT PARAM pcod-refer        AS CHARACTER             NO-UNDO.
    DEF INPUT PARAM pfm-codigo        AS CHARACTER             NO-UNDO.
    DEF INPUT PARAM pfm-cod-com       AS CHARACTER             NO-UNDO.
    DEF INPUT PARAM pnome-mic-reg     AS CHARACTER             NO-UNDO.
    DEF INPUT PARAM pnome-ab-reg      AS CHARACTER             NO-UNDO.
    DEF INPUT PARAM pcidade           AS CHARACTER             NO-UNDO.
    DEF INPUT PARAM pestado           AS CHARACTER             NO-UNDO.
    DEF INPUT PARAM ppais             AS CHARACTER             NO-UNDO.
    
    ASSIGN c-cod-estabel-ini = p-cod-estabel-ini
           c-cod-estabel-fim = p-cod-estabel-fim
           i-cod-emitente-cv = pcod-emitente
           c-it-codigo-cv    = pit-codigo
           c-cod-refer-cv    = pcod-refer
           c-fm-codigo-cv    = pfm-codigo
           c-fm-cod-com-cv   = pfm-cod-com
           c-nome-mic-reg-cv = pnome-mic-reg
           c-nome-ab-reg-cv  = pnome-ab-reg
           c-cidade-cv       = pcidade
           c-estado-cv       = pestado
           c-pais-cv         = ppais.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFaixaNome DBOProgram 
PROCEDURE setConstraintFaixaNomeAtendByCentralVendas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM pc-nome-ini LIKE estabelec.nome NO-UNDO.
    DEF INPUT PARAM pc-nome-fim LIKE estabelec.nome NO-UNDO.
    DEF INPUT PARAM pcod-emitente     AS INTEGER               NO-UNDO.
    DEF INPUT PARAM pit-codigo        AS CHARACTER             NO-UNDO.
    DEF INPUT PARAM pcod-refer        AS CHARACTER             NO-UNDO.
    DEF INPUT PARAM pfm-codigo        AS CHARACTER             NO-UNDO.
    DEF INPUT PARAM pfm-cod-com       AS CHARACTER             NO-UNDO.
    DEF INPUT PARAM pnome-mic-reg     AS CHARACTER             NO-UNDO.
    DEF INPUT PARAM pnome-ab-reg      AS CHARACTER             NO-UNDO.
    DEF INPUT PARAM pcidade           AS CHARACTER             NO-UNDO.
    DEF INPUT PARAM pestado           AS CHARACTER             NO-UNDO.
    DEF INPUT PARAM ppais             AS CHARACTER             NO-UNDO.
    
   ASSIGN c-nome-ini        = pc-nome-ini
          c-nome-fim        = pc-nome-fim
          i-cod-emitente-cv = pcod-emitente
          c-it-codigo-cv    = pit-codigo
          c-cod-refer-cv    = pcod-refer
          c-fm-codigo-cv    = pfm-codigo
          c-fm-cod-com-cv   = pfm-cod-com
          c-nome-mic-reg-cv = pnome-mic-reg
          c-nome-ab-reg-cv  = pnome-ab-reg
          c-cidade-cv       = pcidade
          c-estado-cv       = pestado
          c-pais-cv         = ppais.
           
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByEmpresa DBOProgram 
PROCEDURE setConstraintByEmpresa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
   DEF INPUT PARAM p-cod-empresa LIKE estabelec.ep-codigo NO-UNDO.

   ASSIGN c-cod-empresa = p-cod-empresa. 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaUsaPadrao DBOProgram 
PROCEDURE validaUsaPadrao :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo caracter
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter daImplantCustoPadrao as date      no-undo.
    define input parameter cCodEstabel          as character no-undo.

    def var c-string1 as char no-undo.
    def var c-string2 as char no-undo.

    if  daImplantCustoPadrao < today then do:
        {utp/ut-liter.i In¡cio *}
        assign c-string1 = return-value.
        {utp/ut-liter.i Atual *}
        assign c-string2 = return-value.

        {method/svc/errors/inserr.i &ErrorNumber="29548"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR" 
                                    &ErrorParameters="c-string1 + '~~~~' + c-string2 + '~~~~'
                                                    + string(daImplantCustoPadrao) + '~~~~' + string(today)"}           
    end.

    if  can-find (first  movto-estoq 
                  &if defined(bf-dis-comex) &then
                  &else 
                  use-index contab-trans
                  &endif
                  where 
                  &if defined(bf-dis-comex) &then
                  &else            
                  movto-estoq.contabilizado = no
                  and   
                  &endif movto-estoq.cod-estabel = cCodEstabel
                  and   movto-estoq.dt-trans   >= daImplantCustoPadrao) 
    or  can-find (first  movto-estoq 
                  &if defined(bf-dis-comex) &then
                  &else
                  use-index contab-trans
                  &endif
                   where                   &if defined(bf-dis-comex) &then
                  &else            
                       movto-estoq.contabilizado = yes
                   and &endif movto-estoq.cod-estabel = cCodEstabel
                   and   movto-estoq.dt-trans   >= daImplantCustoPadrao) then do:
        {utp/ut-liter.i Movimento *}
        assign c-string1 = return-value.
        {utp/ut-liter.i superior_a_data_Informada *}
        assign c-string2 = return-value.

        {method/svc/errors/inserr.i &ErrorNumber="17516"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR" 
                                    &ErrorParameters="c-string1 + '~~~~' + c-string2"}           
    end.

    /*--- Verifica ocorrˆncia de erros ---*/
    if  can-find(first RowErrors where RowErrors.ErrorSubType = "ERROR":U) then
        return "NOK":U.
    
    return "OK":U.
END PROCEDURE.







/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
