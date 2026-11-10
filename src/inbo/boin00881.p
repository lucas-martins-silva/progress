&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram
/********************************************************************************
** Copyright TOTVS S.A. (2011)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN00881 2.00.00.010 } /*** "010010" 17/06/2025 16:40:41 ***/

{include/i_dbtype.i}

/* Em caso de bases Oracle e SQL Server, adicionar a lista de queries da BO no
   preprocessador CHANGE-QUERY-TO-FIND-PROCS, separadas por virgula (,),
   para ganho de performance */
/*&IF "{&emsfnd_dbtype}" <> "progress" &THEN
    &GLOBAL-DEFINE DBType {&emsfnd_dbtype}
    &GLOBAL-DEFINE CHANGE-QUERY-TO-FIND TRUE
    &GLOBAL-DEFINE CHANGE-QUERY-TO-FIND-PROCS Main
&ENDIF*/

/* ***************************  Definitions  **************************** */

/* --- Diretrizes de definicao --- */
&GLOBAL-DEFINE DBOName BOIN00881
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName bloq-movto-item-depos
&GLOBAL-DEFINE TableLabel bloqueio movimento item deposi
&GLOBAL-DEFINE QueryName qr{&TableName} 

&GLOBAL-DEFINE KeyField1         cod-estabel
&GLOBAL-DEFINE KeyField2         it-codigo  
&GLOBAL-DEFINE KeyField3         cod-depos
&GLOBAL-DEFINE KeyField4         dat-inic-bloq
&GLOBAL-DEFINE XMLReceiver       YES /* DBO atua como receiver de mensagens enviado pelo Message Broker (metodo Receive Message) */
&GLOBAL-DEFINE XMLProducer YES
&GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES

/******************************************************************************************
** TECNICA SEGURANCA ESTABELECIMENTO
******************************************************************************************/ 
{include/i-estab-security.i}
/******************************************************************************************
** TECNICA SEGURANCA ESTABELECIMENTO
******************************************************************************************/

DEFINE BUFFER bf-estabelec FOR estabelec.

/* DBO-XML-BEGIN */
/* Pre-processadores para ativar XML no DBO */
/* Retirar o comentario para ativar 
&GLOBAL-DEFINE XMLProducer       YES /* DBO atua como producer de mensagens para o Message Broker */
&GLOBAL-DEFINE XMLTopic          BLOQ-MOVTO-ITEM-DEPOS  /* Topico da Mensagem enviada ao Message Broker, geralmente o nome da tabela */
&GLOBAL-DEFINE XMLTableName      BLOQ-MOVTO-ITEM-DEPOS  /* Nome da tabela que deve ser usado como TAG no XML */ 
&GLOBAL-DEFINE XMLTableNameMult  BLOQ-MOVTO-ITEM-DEPOS  /* Nome da tabela no plural. Usado para multiplos registros */ 
&GLOBAL-DEFINE XMLPublicFields       /* Lista dos campos (c1,c2) que podem ser enviados via XML. Ficam fora da listas os campos de especializacao da tabela */ 
&GLOBAL-DEFINE XMLKeyFields      cod-estabel,it-codigo,cod-depos,dat-inic-bloq  /* Lista dos campos chave da tabela (c1,c2) */
&GLOBAL-DEFINE XMLExcludeFields      /* Lista de campos a serem excluidos do XML quando PublicFields = "" */

&GLOBAL-DEFINE QueryDefault          /* Nome da Query que da acessos a todos os registros, exceto os excluidos pela constraint de seguranca. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE NewRecordOffQuery YES /* Informar os campos da chave quando o Progress nao conseguir resolver find {&TableName} OF RowObject. */
*/




/* DBO-XML-END */

/* --- Include com definicao da query para tabela ~{&TableName~} --- */
/* --- Em caso de necessidade de alteracao da definicao da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definicao 
      manual da query ---*/
{inbo/boin00881.i RowObject}


DEFINE TEMP-TABLE RowObjectExtra NO-UNDO
    FIELD r-Rowid AS ROWID
	FIELD nomeEstabel  AS CHAR
	FIELD nomeDepos AS CHAR
    FIELD descItem  AS CHAR.
   


/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
/*{method/dboqry.i}*/

{utp/ut-glob.i}


/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE TEMP-TABLE ttParamMD NO-UNDO
    FIELD itCodigoIni         AS CHARACTER
    FIELD itCodigoFim         AS CHARACTER
    FIELD fmCodigoIni         AS CHARACTER
    FIELD fmCodigoFim         AS CHARACTER
    FIELD geCodigoIni         AS INTEGER
    FIELD geCodigoFim         AS INTEGER
    FIELD codLocalizIni       AS CHARACTER
    FIELD codLocalizFim       AS CHARACTER
    FIELD codDeposIni         AS CHARACTER
    FIELD codDeposFim         AS CHARACTER
    FIELD codEstabelIni       AS CHARACTER
    FIELD codEstabelFim       AS CHARACTER
    FIELD nrFichaIni          AS INTEGER
    FIELD nrFichaFim          AS INTEGER
    FIELD codConfteContagIni  AS CHARACTER
    FIELD codConfteContagFim  AS CHARACTER
    FIELD loteIni             AS CHARACTER
    FIELD loteFim             AS CHARACTER
    FIELD dtSaldo             AS DATE.

DEFINE TEMP-TABLE ttBloqMovtoItemDepos NO-UNDO
    FIELD codEstabel  AS CHAR
    FIELD itCodigo    AS CHAR
    FIELD codDepos    AS CHAR
    FIELD datInicBloq AS DATE
    FIELD hraInicBloq AS CHAR.

DEFINE TEMP-TABLE tt_log_erro NO-UNDO
     FIELD ttv_num_cod_erro AS integer INITIAL ?
     FIELD ttv_des_msg_ajuda AS character INITIAL ?
     FIELD ttv_des_msg_erro AS character INITIAL ?
.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE bloquearItemDeposito DBOProgram 
PROCEDURE bloquearItemDeposito :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER TABLE FOR ttParamMD.
    DEFINE INPUT PARAMETER TABLE FOR ttBloqMovtoItemDepos.

    DEFINE VARIABLE h-axsar013 AS HANDLE NO-UNDO.

    IF NOT VALID-HANDLE(h-axsar013) THEN 
        RUN adapters/xml/ar2/axsar013.p PERSISTENT SET h-axsar013 (OUTPUT TABLE tt_log_erro).

    find first ttParamMD no-error.
    FIND FIRST ttBloqMovtoItemDepos NO-ERROR.

    FOR EACH inventario 
        FIELDS ( it-codigo cod-estabel cod-depos cod-confte-contag-1 
				 cod-confte-contag-2 cod-confte-contag-3)
        WHERE inventario.dt-saldo     = ttParamMD.dtSaldo
        AND   inventario.nr-ficha    >= ttParamMD.nrFichaIni
        AND   inventario.nr-ficha    <= ttParamMD.nrFichaFim
        AND   inventario.cod-estabel   >= ttParamMD.codEstabelIni
        AND   inventario.cod-estabel   <= ttParamMD.codEstabelFim
        AND   inventario.cod-depos   >= ttParamMD.codDeposIni
        AND   inventario.cod-depos   <= ttParamMD.codDeposFim
        AND   inventario.cod-localiz >= ttParamMD.codLocalizIni
        AND   inventario.cod-localiz <= ttParamMD.codLocalizFim
        AND   inventario.it-codigo   >= ttParamMD.itCodigoIni
        AND   inventario.it-codigo   <= ttParamMD.itCodigoFim
        AND   inventario.lote        >= ttParamMD.loteIni
        AND   inventario.lote        <= ttParamMD.loteFim  NO-LOCK
            BREAK BY inventario.cod-estabel
                  BY inventario.cod-depos
                  BY inventario.it-codigo
                  ON STOP UNDO, LEAVE:
				  
		IF  (inventario.cod-confte-contag-1 < ttParamMD.codConfteContagIni
		  OR inventario.cod-confte-contag-1 > ttParamMD.codConfteContagFim)
        AND (inventario.cod-confte-contag-2 < ttParamMD.codConfteContagIni
          OR inventario.cod-confte-contag-2 > ttParamMD.codConfteContagFim)
        AND (inventario.cod-confte-contag-3 < ttParamMD.codConfteContagIni
          OR inventario.cod-confte-contag-3 > ttParamMD.codConfteContagFim) THEN NEXT.			
				  
		IF  NOT AVAIL ITEM
        OR (    AVAIL ITEM 
            AND ITEM.it-codigo <> inventario.it-codigo) THEN
            FOR FIRST ITEM
                FIELDS (fm-codigo ge-codigo it-codigo desc-item un)
                WHERE ITEM.it-codigo = inventario.it-codigo NO-LOCK:
            END.
        IF ITEM.fm-codigo < ttParamMD.fmCodigoIni
        OR ITEM.fm-codigo > ttParamMD.fmCodigoFim THEN NEXT.
        IF ITEM.ge-codigo < ttParamMD.geCodigoIni
        OR ITEM.ge-codigo > ttParamMD.geCodigoFim THEN NEXT.
        
		find first bloq-movto-item-depos 
			 where bloq-movto-item-depos.cod-estabel = inventario.cod-estabel
			   and bloq-movto-item-depos.it-codigo   = inventario.it-codigo
			   and bloq-movto-item-depos.cod-depos   = inventario.cod-depos EXCLUSIVE-LOCK NO-ERROR.

		IF AVAIL bloq-movto-item-depos THEN DO:
			ASSIGN bloq-movto-item-depos.dat-inic-bloq = ttBloqMovtoItemDepos.datInicBloq.
				   bloq-movto-item-depos.hra-inic-bloq = ttBloqMovtoItemDepos.hraInicBloq.
		END.
		ELSE DO:
			CREATE bloq-movto-item-depos.
			ASSIGN bloq-movto-item-depos.cod-estabel   = inventario.cod-estabel
				   bloq-movto-item-depos.it-codigo     = inventario.it-codigo
				   bloq-movto-item-depos.cod-depos     = inventario.cod-depos
				   bloq-movto-item-depos.dat-inic-bloq = ttBloqMovtoItemDepos.datInicBloq
				   bloq-movto-item-depos.hra-inic-bloq = ttBloqMovtoItemDepos.hraInicBloq.

            RUN PITransUpsert IN h-axsar013(INPUT bloq-movto-item-depos.dat-inic-bloq,
                                            INPUT bloq-movto-item-depos.hra-inic-bloq,
                                            INPUT bloq-movto-item-depos.it-codigo,
                                            INPUT bloq-movto-item-depos.cod-estabel,
                                            INPUT bloq-movto-item-depos.cod-depos,
                                            OUTPUT TABLE tt_log_erro).
            FOR EACH  tt_log_erro
                WHERE tt_log_erro.ttv_num_cod_erro <> 60: /*mensagem nÆo assinada*/
                {method/svc/errors/inserr.i
                                   &ErrorNumber="17006" 
                                   &ErrorType="EMS"
                                   &ErrorSubType="ERROR"
                                   &ErrorParameters= tt_log_erro.ttv_des_msg_erro}
            END.
		END.
    END.
    
    DELETE PROCEDURE h-axsar013.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE desbloquearItemDeposito DBOProgram 
PROCEDURE desbloquearItemDeposito :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER TABLE FOR ttParamMD.
    DEFINE INPUT PARAMETER TABLE FOR ttBloqMovtoItemDepos.

    DEFINE VARIABLE h-axsar013 AS HANDLE NO-UNDO.

    IF NOT VALID-HANDLE(h-axsar013) THEN 
        RUN adapters/xml/ar2/axsar013.p PERSISTENT SET h-axsar013 (OUTPUT TABLE tt_log_erro).
  
    find first ttParamMD no-error.
    FIND FIRST ttBloqMovtoItemDepos NO-ERROR.

    FOR EACH inventario 
        FIELDS ( it-codigo cod-estabel cod-depos cod-confte-contag-1 
				 cod-confte-contag-2 cod-confte-contag-3)
        WHERE inventario.dt-saldo     = ttParamMD.dtSaldo
        AND   inventario.nr-ficha    >= ttParamMD.nrFichaIni
        AND   inventario.nr-ficha    <= ttParamMD.nrFichaFim
        AND   inventario.cod-estabel   >= ttParamMD.codEstabelIni
        AND   inventario.cod-estabel   <= ttParamMD.codEstabelFim
        AND   inventario.cod-depos   >= ttParamMD.codDeposIni
        AND   inventario.cod-depos   <= ttParamMD.codDeposFim
        AND   inventario.cod-localiz >= ttParamMD.codLocalizIni
        AND   inventario.cod-localiz <= ttParamMD.codLocalizFim
        AND   inventario.it-codigo   >= ttParamMD.itCodigoIni
        AND   inventario.it-codigo   <= ttParamMD.itCodigoFim
        AND   inventario.lote        >= ttParamMD.loteIni
        AND   inventario.lote        <= ttParamMD.loteFim NO-LOCK
            BREAK BY inventario.cod-estabel
                  BY inventario.cod-depos
                  BY inventario.it-codigo
                  ON STOP UNDO, LEAVE:
				  
		IF  (inventario.cod-confte-contag-1 < ttParamMD.codConfteContagIni
		  OR inventario.cod-confte-contag-1 > ttParamMD.codConfteContagFim)
        AND (inventario.cod-confte-contag-2 < ttParamMD.codConfteContagIni
          OR inventario.cod-confte-contag-2 > ttParamMD.codConfteContagFim)
        AND (inventario.cod-confte-contag-3 < ttParamMD.codConfteContagIni
          OR inventario.cod-confte-contag-3 > ttParamMD.codConfteContagFim) THEN NEXT.			  
				  
        IF  NOT AVAIL ITEM
        OR (    AVAIL ITEM 
            AND ITEM.it-codigo <> inventario.it-codigo) THEN
            FOR FIRST ITEM
                FIELDS (fm-codigo ge-codigo it-codigo desc-item un)
                WHERE ITEM.it-codigo = inventario.it-codigo NO-LOCK:
            END.
        IF ITEM.fm-codigo < ttParamMD.fmCodigoIni
        OR ITEM.fm-codigo > ttParamMD.fmCodigoFim THEN NEXT.
        IF ITEM.ge-codigo < ttParamMD.geCodigoIni
        OR ITEM.ge-codigo > ttParamMD.geCodigoFim THEN NEXT.
        
            find first bloq-movto-item-depos 
                 where bloq-movto-item-depos.cod-estabel = inventario.cod-estabel
                   and bloq-movto-item-depos.it-codigo   = inventario.it-codigo
                   and bloq-movto-item-depos.cod-depos   = inventario.cod-depos EXCLUSIVE-LOCK NO-ERROR.

            IF AVAIL bloq-movto-item-depos THEN DO:

                RUN PITransDelete IN h-axsar013(INPUT bloq-movto-item-depos.dat-inic-bloq,
                                                INPUT bloq-movto-item-depos.hra-inic-bloq,
                                                INPUT bloq-movto-item-depos.it-codigo,
                                                INPUT bloq-movto-item-depos.cod-estabel,
                                                INPUT bloq-movto-item-depos.cod-depos,
                                                OUTPUT TABLE tt_log_erro).
                FOR EACH  tt_log_erro
                    WHERE tt_log_erro.ttv_num_cod_erro <> 60: /*mensagem nÆo assinada*/
                    {method/svc/errors/inserr.i
                                       &ErrorNumber="17006" 
                                       &ErrorType="EMS"
                                       &ErrorSubType="ERROR"
                                       &ErrorParameters= tt_log_erro.ttv_des_msg_erro}
                END.

                DELETE bloq-movto-item-depos.
            END.                
    END.
    DELETE PROCEDURE h-axsar013.
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
        WHEN "cod-depos":U THEN ASSIGN pFieldValue = RowObject.cod-depos.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "hra-inic-bloq":U THEN ASSIGN pFieldValue = RowObject.hra-inic-bloq.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setCharField DBOProgram 
PROCEDURE setCharField :
/*------------------------------------------------------------------------------
  Purpose:     Define um novo valor para campos do tipo CHARACTER
  Parameters:  
               recebe nome do campo
               recebe valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-depos":U THEN ASSIGN RowObject.cod-depos = pFieldValue.
        WHEN "cod-estabel":U THEN ASSIGN RowObject.cod-estabel = pFieldValue.
        WHEN "cod-livre-1":U THEN ASSIGN RowObject.cod-livre-1 = pFieldValue.
        WHEN "cod-livre-2":U THEN ASSIGN RowObject.cod-livre-2 = pFieldValue.
        WHEN "hra-inic-bloq":U THEN ASSIGN RowObject.hra-inic-bloq = pFieldValue.
        WHEN "it-codigo":U THEN ASSIGN RowObject.it-codigo = pFieldValue.
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
        WHEN "dat-inic-bloq":U THEN ASSIGN pFieldValue = RowObject.dat-inic-bloq.
        WHEN "dat-livre-1":U THEN ASSIGN pFieldValue = RowObject.dat-livre-1.
        WHEN "dat-livre-2":U THEN ASSIGN pFieldValue = RowObject.dat-livre-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDateField DBOProgram 
PROCEDURE setDateField :
/*------------------------------------------------------------------------------
  Purpose:     Define um novo valor para campos do tipo DATE
  Parameters:  
               recebe nome do campo
               recebe valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER pFieldValue AS DATE NO-UNDO.

    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dat-inic-bloq":U THEN ASSIGN RowObject.dat-inic-bloq = pFieldValue.
        WHEN "dat-livre-1":U THEN ASSIGN RowObject.dat-livre-1 = pFieldValue.
        WHEN "dat-livre-2":U THEN ASSIGN RowObject.dat-livre-2 = pFieldValue.
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
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDecField DBOProgram 
PROCEDURE setDecField :
/*------------------------------------------------------------------------------
  Purpose:     Define um novo valor para campos do tipo DECIMAL
  Parameters:  
               recebe nome do campo
               recebe valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER pFieldValue AS DECIMAL NO-UNDO.

    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "val-livre-1":U THEN ASSIGN RowObject.val-livre-1 = pFieldValue.
        WHEN "val-livre-2":U THEN ASSIGN RowObject.val-livre-2 = pFieldValue.
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
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setIntField DBOProgram 
PROCEDURE setIntField :
/*------------------------------------------------------------------------------
  Purpose:     Define um novo valor para campos do tipo INTEGER
  Parameters:  
               recebe nome do campo
               recebe valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER pFieldValue AS INTEGER NO-UNDO.

    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "num-livre-1":U THEN ASSIGN RowObject.num-livre-1 = pFieldValue.
        WHEN "num-livre-2":U THEN ASSIGN RowObject.num-livre-2 = pFieldValue.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram  
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice blqmvttm-id
  Parameters:  
               retorna valor do campo cod-estabel
               retorna valor do campo it-codigo
               retorna valor do campo cod-depos
               retorna valor do campo dat-inic-bloq
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE bloq-movto-item-depos.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pit-codigo LIKE bloq-movto-item-depos.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-depos LIKE bloq-movto-item-depos.cod-depos NO-UNDO.
    DEFINE OUTPUT PARAMETER pdat-inic-bloq LIKE bloq-movto-item-depos.dat-inic-bloq NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-estabel = RowObject.cod-estabel
           pit-codigo = RowObject.it-codigo
           pcod-depos = RowObject.cod-depos
           pdat-inic-bloq = RowObject.dat-inic-bloq.

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
        WHEN "log-livre-1":U THEN ASSIGN pFieldValue = RowObject.log-livre-1.
        WHEN "log-livre-2":U THEN ASSIGN pFieldValue = RowObject.log-livre-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setLogField DBOProgram 
PROCEDURE setLogField :
/*------------------------------------------------------------------------------
  Purpose:     Define um novo valor para campos do tipo LOGICAL
  Parameters:  
               recebe nome do campo
               recebe valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "log-livre-1":U THEN ASSIGN RowObject.log-livre-1 = pFieldValue.
        WHEN "log-livre-2":U THEN ASSIGN RowObject.log-livre-2 = pFieldValue.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setRawField DBOProgram 
PROCEDURE setRawField :
/*------------------------------------------------------------------------------
  Purpose:     Define um novo valor para campos do tipo RAW
  Parameters:  
               recebe nome do campo
               recebe valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER pFieldValue AS RAW NO-UNDO.

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
  Purpose:     Reposiciona registro com base no ¡ndice blqmvttm-id
  Parameters:  
               recebe valor do campo cod-estabel
               recebe valor do campo it-codigo
               recebe valor do campo cod-depos
               recebe valor do campo dat-inic-bloq
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE bloq-movto-item-depos.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo LIKE bloq-movto-item-depos.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-depos LIKE bloq-movto-item-depos.cod-depos NO-UNDO.
    DEFINE INPUT PARAMETER pdat-inic-bloq LIKE bloq-movto-item-depos.dat-inic-bloq NO-UNDO.

	

    FIND FIRST bfbloq-movto-item-depos
        WHERE bfbloq-movto-item-depos.cod-estabel = pcod-estabel
        AND   bfbloq-movto-item-depos.it-codigo = pit-codigo
        AND   bfbloq-movto-item-depos.cod-depos = pcod-depos
        AND   bfbloq-movto-item-depos.dat-inic-bloq = pdat-inic-bloq NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfbloq-movto-item-depos THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfbloq-movto-item-depos)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

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
    DEFINE VARIABLE cAux AS CHARACTER NO-UNDO.

    /*:T--- Utilize o parƒmetro pType para identificar quais as valida‡äes a serem
          executadas ---*/
    /*:T--- Os valores poss¡veis para o parƒmetro sÆo: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as valida‡äes ---*/


    IF pType = "CREATE" THEN DO:
       IF CAN-FIND(FIRST bloq-movto-item-depos
                   WHERE bloq-movto-item-depos.cod-estabel = RowObject.cod-estabel
                     AND bloq-movto-item-depos.it-codigo = RowObject.it-codigo
                     AND bloq-movto-item-depos.cod-depos = RowObject.cod-depos
                     AND bloq-movto-item-depos.dat-inic-bloq = RowObject.dat-inic-bloq) THEN DO:
          {utp/ut-liter.i "Bloqueio_Movimento_Item_Dep¢sito" *}
          {method/svc/errors/inserr.i
           &ErrorNumber="7" 
           &ErrorType="EMS"
           &ErrorSubType="ERROR"
           &ErrorParameters= RETURN-VALUE}
       END.
       ELSE DO:
           IF CAN-FIND(FIRST bloq-movto-item-depos
                   WHERE bloq-movto-item-depos.cod-estabel = RowObject.cod-estabel
                     AND bloq-movto-item-depos.it-codigo   = RowObject.it-codigo
                     AND bloq-movto-item-depos.cod-depos   = RowObject.cod-depos) THEN DO:
                FIND FIRST bloq-movto-item-depos
                    WHERE bloq-movto-item-depos.cod-estabel = RowObject.cod-estabel
                      AND bloq-movto-item-depos.it-codigo   = RowObject.it-codigo
                      AND bloq-movto-item-depos.cod-depos   = RowObject.cod-depos NO-LOCK NO-ERROR.

                ASSIGN cAux = STRING(bloq-movto-item-depos.dat-inic-bloq).
           
               /* Item #TODOS# => Dep¢sito e estabelecimento bloqueados*/
                IF RowObject.it-codigo = "#TODOS#" THEN DO:
                    {method/svc/errors/inserr.i
                              &ErrorNumber= "54582"
                              &ErrorType="EMS"
                              &ErrorSubType="INFORMATION":U
                              &ErrorParameters= "RowObject.cod-depos + '~~~~' + RowObject.cod-estabel + '~~~~' + cAux"} 
                END.
                ELSE DO:
                    {method/svc/errors/inserr.i
                              &ErrorNumber= "53630"
                              &ErrorType="EMS"
                              &ErrorSubType="INFORMATION":U
                              &ErrorParameters= "RowObject.it-codigo + '~~~~' + RowObject.cod-depos + '~~~~' + RowObject.cod-estabel + '~~~~' + cAux"} 
                END.
            END.
        END.
 
        IF l-estab-security-active THEN DO:
            FOR FIRST bf-estabelec FIELDS()
                WHERE bf-estabelec.cod-estabel = RowObject.cod-estabel
                  AND CAN-FIND(FIRST {&ESTAB-SEC-TT} WHERE {&ESTAB-SEC-TT-FIELD} = bf-estabelec.cod-estabel): END.
        END.
        ELSE DO:
            FOR FIRST bf-estabelec FIELDS()
                WHERE bf-estabelec.cod-estabel = RowObject.cod-estabel: END.        
        END.
        IF NOT AVAIL bf-estabelec THEN DO:
            {utp/ut-liter.i "Estabelecimento" *}
            {method/svc/errors/inserr.i
                       &ErrorNumber="2" 
                       &ErrorType="EMS"
                       &ErrorSubType="ERROR"
                       &ErrorParameters= RETURN-VALUE}
       END.

       IF RowObject.it-codigo <> "#TODOS#" THEN DO:
           IF NOT CAN-FIND(FIRST ITEM 
                           WHERE ITEM.it-codigo = RowObject.it-codigo) THEN DO:
               {utp/ut-liter.i "Item" *}
               {method/svc/errors/inserr.i
               &ErrorNumber="2" 
               &ErrorType="EMS"
               &ErrorSubType="ERROR"
               &ErrorParameters= RETURN-VALUE}
           END.
       END.

       IF NOT CAN-FIND(FIRST deposito 
                       WHERE deposito.cod-depos = RowObject.cod-depos) THEN DO:
           {utp/ut-liter.i "Dep¢sito" *}
           {method/svc/errors/inserr.i
           &ErrorNumber="2" 
           &ErrorType="EMS"
           &ErrorSubType="ERROR"
           &ErrorParameters= RETURN-VALUE}
       END.
    END.

    /*:T--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE isBlocked DBOProgram 
PROCEDURE isBlocked :
/*:T------------------------------------------------------------------------------
  Purpose:     Verifica se est  bloqueado o registro de item/dep«sito/estab.
  Parameters:  recebe o Estabelecimento, o Item e o Dep«sito
  Notes:       retorna se est  bloqueado naquela data e hora
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pCodEstabel  LIKE bloq-movto-item-depos.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pCodDeposito LIKE bloq-movto-item-depos.cod-depos   NO-UNDO.
    DEFINE INPUT PARAMETER pCodItem     LIKE bloq-movto-item-depos.it-codigo   NO-UNDO.
    DEFINE OUTPUT PARAMETER pBlocked    AS LOGICAL INITIAL NO NO-UNDO.

    /* Tem bloqueio para TODOS os itens do deposito/estab ? */
    FOR EACH bfbloq-movto-item-depos  NO-LOCK
       WHERE bfbloq-movto-item-depos.cod-estabel    = pCodEstabel
         AND bfbloq-movto-item-depos.cod-depos      = pCodDeposito
         AND bfbloq-movto-item-depos.it-codigo      = "#TODOS#":U 
         AND bfbloq-movto-item-depos.dat-inic-bloq <= TODAY:

        IF bfbloq-movto-item-depos.dat-inic-bloq < TODAY  OR  /* Data bloqueio menor que hoje */                  
          (bfbloq-movto-item-depos.dat-inic-bloq = TODAY  AND /* Se hoje valida a hora */
           bfbloq-movto-item-depos.hra-inic-bloq <= STRING(TIME,"HH:MM:SS":U)) THEN DO:
               
            ASSIGN pBlocked = YES.
            LEAVE.
        END.
    END.

    IF NOT pBlocked THEN
        /* Tem bloqueio para o item/deposito/estab ? */
        FOR EACH bfbloq-movto-item-depos  NO-LOCK
           WHERE bfbloq-movto-item-depos.cod-estabel    = pCodEstabel
             AND bfbloq-movto-item-depos.cod-depos      = pCodDeposito
             AND bfbloq-movto-item-depos.it-codigo      = pCodItem 
             AND bfbloq-movto-item-depos.dat-inic-bloq <= TODAY:
    
            IF bfbloq-movto-item-depos.dat-inic-bloq < TODAY  OR  /* Data bloqueio menor que hoje */                  
              (bfbloq-movto-item-depos.dat-inic-bloq = TODAY  AND /* Se hoje valida a hora */
               bfbloq-movto-item-depos.hra-inic-bloq <= STRING(TIME,"HH:MM:SS":U)) THEN DO:
                   
                ASSIGN pBlocked = YES.
                LEAVE.
            END.
        END.

    RETURN "OK":U.
END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDefault DBOProgram 
PROCEDURE openQueryDefault :
/*------------------------------------------------------------------------------
  Purpose: 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} NO-LOCK.*/
    {include/i-estab-openquery.i}
	
    RETURN "OK":U.

END PROCEDURE.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose: 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} NO-LOCK INDEXED-REPOSITION.*/
    {include/i-estab-openquery.i}
                                      
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE aftercreateRecord DBOProgram 
PROCEDURE aftercreateRecord  :
/*--------------------------------------------------------------
  Purpose:     Override do m‚todo createRecord (after)
  Parameters:  
  Notes:       
--------------------------------------------------------------*/
    DEFINE VARIABLE h-axsar013 AS HANDLE NO-UNDO.

    IF NOT VALID-HANDLE(h-axsar013) THEN 
        RUN adapters/xml/ar2/axsar013.p PERSISTENT SET h-axsar013 (OUTPUT TABLE tt_log_erro).

    RUN PITransUpsert IN h-axsar013(INPUT RowObject.dat-inic-bloq,
                                    INPUT RowObject.hra-inic-bloq,
                                    INPUT RowObject.it-codigo,
                                    INPUT RowObject.cod-estabel,
                                    INPUT RowObject.cod-depos,
                                    OUTPUT TABLE tt_log_erro).
    FOR EACH  tt_log_erro
        WHERE tt_log_erro.ttv_num_cod_erro <> 60: /*mensagem nÆo assinada*/
        {method/svc/errors/inserr.i
                           &ErrorNumber= "17006" 
                           &ErrorType="EMS"
                           &ErrorSubType="ERROR"
                           &ErrorParameters= tt_log_erro.ttv_des_msg_erro}
    END.

    
    DELETE PROCEDURE h-axsar013.

   RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 
PROCEDURE getRowObjectExtra:
    DEFINE OUTPUT PARAMETER TABLE FOR RowObjectExtra.
END PROCEDURE.

PROCEDURE afterCopyBuffer2TT:

	find first item where item.it-codigo = {&TableName}.it-codigo no-lock no-error.
	find first deposito where deposito.cod-depos = {&TableName}.cod-depos no-lock no-error.
	find first estabelec where estabelec.cod-estabel = {&TableName}.cod-estabel no-lock no-error.

    CREATE RowObjectExtra.
    ASSIGN RowObjectExtra.r-Rowid = ROWID({&TableName})
           RowObjectExtra.descItem = if avail item then item.desc-item else ""
		   RowObjectExtra.nomeDepos = if avail deposito then deposito.nome else ""
		   RowObjectExtra.nomeEstabel = if avail estabelec then estabelec.nome else "".
		   
END PROCEDURE.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDeleteRecord DBOProgram 
PROCEDURE afterDeleteRecord  :
/*--------------------------------------------------------------
  Purpose:     Override do m‚todo afterDeleteRecord (after)
  Parameters:  
  Notes:       
--------------------------------------------------------------*/
    DEFINE VARIABLE h-axsar013 AS HANDLE NO-UNDO.

    IF NOT VALID-HANDLE(h-axsar013) THEN 
        RUN adapters/xml/ar2/axsar013.p PERSISTENT SET h-axsar013 (OUTPUT TABLE tt_log_erro).

    RUN PITransDelete IN h-axsar013(INPUT RowObject.dat-inic-bloq,
                                    INPUT RowObject.hra-inic-bloq,
                                    INPUT RowObject.it-codigo,
                                    INPUT RowObject.cod-estabel,
                                    INPUT RowObject.cod-depos,
                                    OUTPUT TABLE tt_log_erro).
    FOR EACH  tt_log_erro
        WHERE tt_log_erro.ttv_num_cod_erro <> 60: 
        {method/svc/errors/inserr.i
                           &ErrorNumber="17006" 
                           &ErrorType="EMS"
                           &ErrorSubType="ERROR"
                           &ErrorParameters= tt_log_erro.ttv_des_msg_erro}
    END.

    
    DELETE PROCEDURE h-axsar013.

   RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
