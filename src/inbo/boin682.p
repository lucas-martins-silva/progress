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
{include/i-prgvrs.i BOIN682 2.00.00.019 } /*** "010019" 18/07/2024 10:42:50 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin682 MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : 
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
&GLOBAL-DEFINE DBOName param-global
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName param-global
&GLOBAL-DEFINE TableLabel param-global
&GLOBAL-DEFINE QueryName qr{&TableName}

/*--- Include com defini‡Æo da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com
      extensÆo .i ---*/
{inbo/boin682.i RowObject}

/*--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo
      manual da query ---*/
{method/dboqry.i}

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

{include/i_dbvers.i}

{cdp/cdcfgmat.i}
{cdp/cdcfgmnt.i}
{cdp/cdcfgman.i}

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



/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

{inbo/boin682.i1}

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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        &IF "{&mguni_version}" >= "2.071" &THEN
        WHEN "empresa-prin":U THEN ASSIGN pFieldValue = RowObject.empresa-prin.
        &ENDIF
        WHEN "ct-format":U THEN ASSIGN pFieldValue = RowObject.ct-format.
        WHEN "ctladm":U THEN ASSIGN pFieldValue = RowObject.ctladm.
        WHEN "formato-cep":U THEN ASSIGN pFieldValue = RowObject.formato-cep.
        WHEN "formato-conta-contabil":U THEN ASSIGN pFieldValue = RowObject.formato-conta-contabil.
        WHEN "formato-id-estadual":U THEN ASSIGN pFieldValue = RowObject.formato-id-estadual.
        WHEN "formato-id-federal":U THEN ASSIGN pFieldValue = RowObject.formato-id-federal.
        WHEN "formato-id-pessoal":U THEN ASSIGN pFieldValue = RowObject.formato-id-pessoal.
        WHEN "grupo":U THEN ASSIGN pFieldValue = RowObject.grupo.
        WHEN "label-cgc":U THEN ASSIGN pFieldValue = RowObject.label-cgc.
        WHEN "label-insc-est":U THEN ASSIGN pFieldValue = RowObject.label-insc-est.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-catal-docto-anexo":U THEN ASSIGN pFieldValue = RowObject.cod-catal-docto-anexo.
        WHEN "cod-catal-imag-emp":U THEN ASSIGN pFieldValue = RowObject.cod-catal-imag-emp.
        WHEN "cod-catal-img-banco":U THEN ASSIGN pFieldValue = RowObject.cod-catal-img-banco.
        WHEN "cod-catal-img-eq":U THEN ASSIGN pFieldValue = RowObject.cod-catal-img-eq.
        WHEN "cod-catal-img-it":U THEN ASSIGN pFieldValue = RowObject.cod-catal-img-it.
        WHEN "cod-catal-video-op":U THEN ASSIGN pFieldValue = RowObject.cod-catal-video-op.
        WHEN "ctlcom":U THEN ASSIGN pFieldValue = RowObject.ctlcom.
        WHEN "ctlext1":U THEN ASSIGN pFieldValue = RowObject.ctlext1.
        WHEN "ctlext2":U THEN ASSIGN pFieldValue = RowObject.ctlext2.
        WHEN "ctlext3":U THEN ASSIGN pFieldValue = RowObject.ctlext3.
        WHEN "ctlfol":U THEN ASSIGN pFieldValue = RowObject.ctlfol.
        WHEN "ctlind":U THEN ASSIGN pFieldValue = RowObject.ctlind.
        WHEN "sc-format":U THEN ASSIGN pFieldValue = RowObject.sc-format.
        WHEN "serv-mail":U THEN ASSIGN pFieldValue = RowObject.serv-mail.
        WHEN "tipo-texto":U THEN ASSIGN pFieldValue = RowObject.tipo-texto.
        &if "{&mgind_version}" >= "2.03" &then
           WHEN "cod-servid-exec-web":U THEN ASSIGN pFieldValue = RowObject.cod-servid-exec-web.
           WHEN "des-app-url":U THEN ASSIGN pFieldValue = RowObject.des-app-url.
           WHEN "nome-dominio-ext":U THEN ASSIGN pFieldValue = RowObject.nome-dominio-ext.
        &endif
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dt-ult-verif":U THEN ASSIGN pFieldValue = RowObject.dt-ult-verif.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "contab-estat[3]":U THEN ASSIGN pFieldValue = RowObject.contab-estat[3].
        WHEN "contab-estat[4]":U THEN ASSIGN pFieldValue = RowObject.contab-estat[4].
        WHEN "contab-estat[5]":U THEN ASSIGN pFieldValue = RowObject.contab-estat[5].
        WHEN "contab-estat[6]":U THEN ASSIGN pFieldValue = RowObject.contab-estat[6].
        WHEN "contab-estat[7]":U THEN ASSIGN pFieldValue = RowObject.contab-estat[7].
        WHEN "contab-estat[8]":U THEN ASSIGN pFieldValue = RowObject.contab-estat[8].
        WHEN "contab-estat[9]":U THEN ASSIGN pFieldValue = RowObject.contab-estat[9].
        WHEN "ind-venc-dom":U THEN ASSIGN pFieldValue = RowObject.ind-venc-dom.
        WHEN "ind-venc-fer":U THEN ASSIGN pFieldValue = RowObject.ind-venc-fer.
        WHEN "ind-venc-sab":U THEN ASSIGN pFieldValue = RowObject.ind-venc-sab.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "mod-conf":U THEN ASSIGN pFieldValue = RowObject.mod-conf.
    &IF "{&mguni_version}" >= "2.071" &THEN
    &ELSE
        WHEN "empresa-prin":U THEN ASSIGN pFieldValue = RowObject.empresa-prin.
    &ENDIF
        WHEN "bloqueio-cgc":U THEN ASSIGN pFieldValue = RowObject.bloqueio-cgc.
        WHEN "cod-decex[1]":U THEN ASSIGN pFieldValue = RowObject.cod-decex[1].
        WHEN "cod-decex[2]":U THEN ASSIGN pFieldValue = RowObject.cod-decex[2].
        WHEN "cod-decex[3]":U THEN ASSIGN pFieldValue = RowObject.cod-decex[3].
        WHEN "cod-decex[4]":U THEN ASSIGN pFieldValue = RowObject.cod-decex[4].
        WHEN "cod-decex[5]":U THEN ASSIGN pFieldValue = RowObject.cod-decex[5].
        WHEN "cod-decex[6]":U THEN ASSIGN pFieldValue = RowObject.cod-decex[6].
        WHEN "cod-decex[7]":U THEN ASSIGN pFieldValue = RowObject.cod-decex[7].
        WHEN "cod-decex[8]":U THEN ASSIGN pFieldValue = RowObject.cod-decex[8].
        WHEN "cod-decex[9]":U THEN ASSIGN pFieldValue = RowObject.cod-decex[9].
        WHEN "contab-estat[1]":U THEN ASSIGN pFieldValue = RowObject.contab-estat[1].
        WHEN "contab-estat[2]":U THEN ASSIGN pFieldValue = RowObject.contab-estat[2].
        WHEN "nivel-apr-manut":U THEN ASSIGN pFieldValue = RowObject.nivel-apr-manut.
        WHEN "Nivel-apr-requis":U THEN ASSIGN pFieldValue = RowObject.Nivel-apr-requis.
        WHEN "nivel-apr-solic":U THEN ASSIGN pFieldValue = RowObject.nivel-apr-solic.
        WHEN "periodo-veri":U THEN ASSIGN pFieldValue = RowObject.periodo-veri.
        WHEN "porta-mail":U THEN ASSIGN pFieldValue = RowObject.porta-mail.
        WHEN "tp-estr-banco":U THEN ASSIGN pFieldValue = RowObject.tp-estr-banco.
        &if "{&mgind_version}" >= "2.03" &then
            WHEN "ind-cons-conta":U THEN ASSIGN pFieldValue = RowObject.ind-cons-conta.
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
  Purpose:     Retorna valores dos campos do ¡ndice CODIGO
  Parameters:
               retorna valor dos campos do ¡ndice CODIGO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pgrupo LIKE param-global.grupo NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pgrupo = RowObject.grupo.

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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "gera-narrat":U THEN ASSIGN pFieldValue = RowObject.gera-narrat.
        WHEN "gera-texto":U THEN ASSIGN pFieldValue = RowObject.gera-texto.
        WHEN "id-estadual-obrigatorio":U THEN ASSIGN pFieldValue = RowObject.id-estadual-obrigatorio.
        WHEN "id-federal-obrigatorio":U THEN ASSIGN pFieldValue = RowObject.id-federal-obrigatorio.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "log-modul-draw":U THEN ASSIGN pFieldValue = RowObject.log-modul-draw.
        WHEN "modulo-01":U THEN ASSIGN pFieldValue = RowObject.modulo-01.
        WHEN "modulo-05":U THEN ASSIGN pFieldValue = RowObject.modulo-05.
        WHEN "modulo-06":U THEN ASSIGN pFieldValue = RowObject.modulo-06.
        WHEN "exp-cep":U THEN ASSIGN pFieldValue = RowObject.exp-cep.
        WHEN "exp-cliente":U THEN ASSIGN pFieldValue = RowObject.exp-cliente.
        WHEN "exp-cond-pag":U THEN ASSIGN pFieldValue = RowObject.exp-cond-pag.
        WHEN "exp-fornec":U THEN ASSIGN pFieldValue = RowObject.exp-fornec.
        WHEN "exp-item":U THEN ASSIGN pFieldValue = RowObject.exp-item.
        WHEN "exp-portador":U THEN ASSIGN pFieldValue = RowObject.exp-portador.
        WHEN "exp-rep":U THEN ASSIGN pFieldValue = RowObject.exp-rep.
        WHEN "aprov-elet-req":U THEN ASSIGN pFieldValue = RowObject.aprov-elet-req.
        WHEN "consiste-sim":U THEN ASSIGN pFieldValue = RowObject.consiste-sim.
        WHEN "modulo-07":U THEN ASSIGN pFieldValue = RowObject.modulo-07.
        WHEN "modulo-08":U THEN ASSIGN pFieldValue = RowObject.modulo-08.
        WHEN "modulo-09":U THEN ASSIGN pFieldValue = RowObject.modulo-09.
        WHEN "modulo-10":U THEN ASSIGN pFieldValue = RowObject.modulo-10.
        WHEN "modulo-ae":U THEN ASSIGN pFieldValue = RowObject.modulo-ae.
        WHEN "modulo-ap":U THEN ASSIGN pFieldValue = RowObject.modulo-ap.
        WHEN "modulo-at":U THEN ASSIGN pFieldValue = RowObject.modulo-at.
        WHEN "modulo-bh":U THEN ASSIGN pFieldValue = RowObject.modulo-bh.
        WHEN "modulo-bs":U THEN ASSIGN pFieldValue = RowObject.modulo-bs.
        WHEN "modulo-ca":U THEN ASSIGN pFieldValue = RowObject.modulo-ca.
        WHEN "modulo-cb":U THEN ASSIGN pFieldValue = RowObject.modulo-cb.
        WHEN "modulo-cc":U THEN ASSIGN pFieldValue = RowObject.modulo-cc.
        WHEN "modulo-ce":U THEN ASSIGN pFieldValue = RowObject.modulo-ce.
        &IF DEFINED (bf_man_205) &THEN
        &ELSE
            WHEN "modulo-cf":U THEN ASSIGN pFieldValue = RowObject.modulo-cf.
        &ENDIF    
        WHEN "modulo-cg":U THEN ASSIGN pFieldValue = RowObject.modulo-cg.
        WHEN "modulo-ch":U THEN ASSIGN pFieldValue = RowObject.modulo-ch.
        WHEN "modulo-cl":U THEN ASSIGN pFieldValue = RowObject.modulo-cl.
        WHEN "modulo-cn":U THEN ASSIGN pFieldValue = RowObject.modulo-cn.
        WHEN "modulo-co":U THEN ASSIGN pFieldValue = RowObject.modulo-co.
        WHEN "modulo-cp":U THEN ASSIGN pFieldValue = RowObject.modulo-cp.
        WHEN "modulo-cq":U THEN ASSIGN pFieldValue = RowObject.modulo-cq.
        WHEN "modulo-cr":U THEN ASSIGN pFieldValue = RowObject.modulo-cr.
        WHEN "modulo-crp":U THEN ASSIGN pFieldValue = RowObject.modulo-crp.
        WHEN "modulo-cs":U THEN ASSIGN pFieldValue = RowObject.modulo-cs.
        WHEN "modulo-ct":U THEN ASSIGN pFieldValue = RowObject.modulo-ct.
        WHEN "modulo-cv":U THEN ASSIGN pFieldValue = RowObject.modulo-cv.
        WHEN "modulo-dp":U THEN ASSIGN pFieldValue = RowObject.modulo-dp.
        WHEN "modulo-ds":U THEN ASSIGN pFieldValue = RowObject.modulo-ds.
        WHEN "modulo-ed":U THEN ASSIGN pFieldValue = RowObject.modulo-ed.
        WHEN "modulo-en":U THEN ASSIGN pFieldValue = RowObject.modulo-en.
        WHEN "modulo-ex":U THEN ASSIGN pFieldValue = RowObject.modulo-ex.
        WHEN "modulo-fc":U THEN ASSIGN pFieldValue = RowObject.modulo-fc.
        WHEN "modulo-fp":U THEN ASSIGN pFieldValue = RowObject.modulo-fp.
        WHEN "modulo-fr":U THEN ASSIGN pFieldValue = RowObject.modulo-fr.
        WHEN "modulo-ft":U THEN ASSIGN pFieldValue = RowObject.modulo-ft.
        WHEN "modulo-ge":U THEN ASSIGN pFieldValue = RowObject.modulo-ge.
        WHEN "modulo-in":U THEN ASSIGN pFieldValue = RowObject.modulo-in.
        &IF "{&bf_mat_versao_ems}" >= "2.04" &THEN
            WHEN "modulo-mec":U THEN ASSIGN pFieldValue = RowObject.modulo-mec.
        &ENDIF    
        WHEN "modulo-mi":U THEN ASSIGN pFieldValue = RowObject.modulo-mi.
        WHEN "modulo-mp":U THEN ASSIGN pFieldValue = RowObject.modulo-mp.
        WHEN "modulo-mt":U THEN ASSIGN pFieldValue = RowObject.modulo-mt.
        WHEN "modulo-of":U THEN ASSIGN pFieldValue = RowObject.modulo-of.
        WHEN "modulo-pc":U THEN ASSIGN pFieldValue = RowObject.modulo-pc.
        WHEN "modulo-pd":U THEN ASSIGN pFieldValue = RowObject.modulo-pd.
        WHEN "modulo-pe":U THEN ASSIGN pFieldValue = RowObject.modulo-pe.
        WHEN "modulo-pi":U THEN ASSIGN pFieldValue = RowObject.modulo-pi.
        WHEN "modulo-pl":U THEN ASSIGN pFieldValue = RowObject.modulo-pl.
        WHEN "modulo-pm":U THEN ASSIGN pFieldValue = RowObject.modulo-pm.
        WHEN "modulo-pt":U THEN ASSIGN pFieldValue = RowObject.modulo-pt.
        WHEN "modulo-pv":U THEN ASSIGN pFieldValue = RowObject.modulo-pv.
        WHEN "modulo-re":U THEN ASSIGN pFieldValue = RowObject.modulo-re.
        WHEN "modulo-rs":U THEN ASSIGN pFieldValue = RowObject.modulo-rs.
        WHEN "modulo-st":U THEN ASSIGN pFieldValue = RowObject.modulo-st.
        WHEN "modulo-sws":U THEN ASSIGN pFieldValue = RowObject.modulo-sws.
        WHEN "modulo-wi":U THEN ASSIGN pFieldValue = RowObject.modulo-wi.
        &if "{&mgind_version}" >= "2.03" &then
            WHEN "modulo-im":U THEN ASSIGN pFieldValue = RowObject.modulo-im.
        &ENDIF
        &if "{&mgind_version}" >= "2.03" AND '{&mguni_version}' < '2.07' &THEN
            WHEN "modulo-tf":U THEN ASSIGN pFieldValue = RowObject.modulo-tf.
        &endif
        &IF DEFINED (bf_mnt_plan_mob) &THEN
            WHEN "modulo-po":u then assign pFieldValue = RowObject.modulo-po.
        &ENDIF
        &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN
            WHEN "log-datasulnet":U THEN ASSIGN pFieldValue = RowObject.log-datasulnet.
        &ENDIF
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuery DBOProgram 
PROCEDURE openQuery :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then
            run openQueryStatic in this-procedure (input "Main":U).
    end case.

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
    OPEN QUERY {&QueryName} FOR EACH param-global NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint1 DBOProgram 
PROCEDURE setConstraint1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Valida temptable RowObject
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE integraAtividadeAgricola DBOProgram 
PROCEDURE integraAtividadeAgricola :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER integr AS LOGICAL INITIAL NO NO-UNDO.

    FIND FIRST param-global NO-LOCK NO-ERROR.
    &IF  DEFINED (bf_mnt_ems208) &THEN
         ASSIGN integr = param-global.ind-int-agro .
    &ELSE
         IF  SUBSTRING(param-global.char-2,21,1) = "1":U THEN
             ASSIGN integr = YES.
         ELSE
             ASSIGN integr = NO.
    &ENDIF
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE isModuloPO DBOProgram 
PROCEDURE isModuloPO :
/*------------------------------------------------------------------------------
  Purpose:     Validar se o m¢dulo PO est  implantado
  Parameters:  <none>
  Notes:       Essa valida‡Æo ‚ necess ria para o metadados, pois nÆo ‚ poss¡vel
               executar as fun‡äes padräes de BO a partir do cliente
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER l-modulo-po AS LOGICAL.

	DEFINE BUFFER bf-param-global FOR param-global.
	
    FOR FIRST bf-param-global FIELDS (modulo-po) NO-LOCK: END.
    ASSIGN l-modulo-po = bf-param-global.modulo-po.
	
	RETURN "OK":U.
END.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getEmpresaPrin DBOProgram 
PROCEDURE getEmpresaPrin :
/*------------------------------------------------------------------------------
  Purpose:     Retorna o código da empresa principal
  Parameters:  <none>
  Notes:       Essa validacao e necessaria para o metadados, pois nao e possivel
               executar as funcoes padroes de BO a partir do cliente
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER p-empresa-prin LIKE param-global.empresa-prin.

	DEFINE BUFFER bf-param-global FOR param-global.
	
    FOR FIRST bf-param-global FIELDS (empresa-prin) NO-LOCK: END.
    ASSIGN p-empresa-prin = bf-param-global.empresa-prin.
	
	RETURN "OK":U.
END.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

