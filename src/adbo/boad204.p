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
{include/i-prgvrs.i BOAD204 2.00.00.008}  /*** 010008 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boad204 MUT}
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
&GLOBAL-DEFINE DBOName param-ge
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName param-ge
&GLOBAL-DEFINE TableLabel param-ge
&GLOBAL-DEFINE QueryName qr{&TableName}

&IF "{&mguni_version}" >= "2.07A" &THEN
Def Var v_ep_codigo_inicial LIKE empresa.ep-codigo NO-UNDO.
&ELSE
Def Var v_ep_codigo_inicial As Integer NO-UNDO.
&ENDIF
&IF "{&mguni_version}" >= "2.07A" &THEN
Def Var v_ep_codigo_final LIKE empresa.ep-codigo NO-UNDO.
&ELSE
Def Var v_ep_codigo_final As Integer NO-UNDO.
&ENDIF

/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com
      extens∆o .i ---*/
{adbo/boad204.i RowObject}

/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o
      manual da query ---*/
{method/dboqry.i}
{include/i_dbvers.i}

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/* Utilizada na procedure interna retornaDatInicialGE */
DEF TEMP-TABLE ttData 
    FIELD data AS DATE
    INDEX ch-data IS PRIMARY data.

{gep/ge9500.i}

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
         HEIGHT             = 3.58
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaParamGE DBOProgram 
PROCEDURE atualizaParamGE :
/*------------------------------------------------------------------------------
  Purpose   : Atualizacao Geracao Param-GE
  Parameters: 1 - Mensagem de Atualizacao
              2 - Tipo de Atualizacao (1-Total,2-Diaria)
              3 - indica se est† sendo atualizado ou n∆o
              4 - indica se atualiza saldo dispon°vel
              5 - valor do saldo dispon°vel (quando param4 = yes)
------------------------------------------------------------------------------*/
    /* Definicao dos parametros */
    DEF INPUT PARAM pMesg      AS CHAR NO-UNDO.
    DEF INPUT PARAM pAtualiza  AS LOG  NO-UNDO.
    DEF INPUT PARAM pTpGeracao AS INT  NO-UNDO.
    DEF INPUT PARAM pAtualDisp AS LOG  NO-UNDO.
    DEF INPUT PARAM pValDisp   AS DEC  NO-UNDO.  

    /* Definicao de Variaveis */
    DEF VAR cTpGeracao         AS CHAR NO-UNDO.   

    /* Traducao de Mensagens */
    IF pTpGeracao = 1 THEN DO: 
       {utp/ut-liter.i Total MGE L} 
    END.
    ELSE DO:                                                
       {utp/ut-liter.i Di†ria MGE L}
    END.
    ASSIGN cTpGeracao = RETURN-VALUE.

    RUN utp/ut-liter.p (pMesg, "MGE":U, "L":U). 

    /* Verifica se param-ge est† dispon°vel */    
    IF NOT AVAIL {&TableName} THEN RETURN "NOK":U.

    DO TRANS:
       /* verifica se registro esta em uso */ 
       FIND FIRST bf{&TableName} WHERE ROWID(bf{&TableName}) = ROWID({&TableName}) 
            EXCLUSIVE-LOCK NO-WAIT NO-ERROR.

       IF  LOCKED bf{&TableName} THEN RETURN "NOK":U.

       /* Atualiza informacoes param-ge */   
       IF  AVAIL bf{&TableName} THEN 
           ASSIGN 
                 &IF "{&FC_OBJETIVO_GE}" = "YES" &THEN
                     bf{&TableName}.dt-ult-at-dia   = TODAY
                     bf{&TableName}.hr-ult-at-dia   = STRING(TIME,"HH:MM:SS")
                     bf{&TableName}.ult-proc-efet   = (pMesg + " - " + cTpGeracao)
                     bf{&tablename}.ind-atualiza    = (IF pAtualiza 
                                                           THEN 1 /* sendo atualizado   */
                                                           ELSE 2 /* n∆o sendo utilzado */)
                     bf{&TableName}.dt-ult-at-total = (IF pTpGeracao = 2 
                                                           THEN bf{&TableName}.dt-ult-at-total
                                                           ELSE TODAY)
                     bf{&TableName}.hr-ult-at-total = (IF pTpGeracao = 2 
                                                           THEN bf{&TableName}.hr-ult-at-total
                                                           ELSE STRING(TIME,"HH:MM:SS"))
                 &ELSE
                     bf{&TableName}.data-1 = TODAY
                     bf{&TableName}.char-1 = STRING(TIME,"HH:MM:SS")
                     bf{&TableName}.char-2 = (pMesg + " - " + cTpGeracao)
                     bf{&TableName}.log-1  = pAtualiza
                     bf{&TableName}.data-2 = (IF pTpGeracao = 2 
                                                  THEN bf{&TableName}.data-2
                                                  ELSE TODAY)
                 &ENDIF     
                 bf{&TableName}.vl-disp-ini = IF PAtualDisp THEN PValDisp ELSE bf{&TableName}.vl-disp-ini.
    END. 
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calcHorizonteFluxoCaixa DBOProgram 
PROCEDURE calcHorizonteFluxoCaixa :
/*------------------------------------------------------------------------------
  Purpose   : Com base param-ge posicionado, calcula a Data Final do Horizonte 
              de Fluxo de Caixa, considerando a data de hoje e o n£mero de meses
              parametrizado.    
  Parameters: para release sem Objetivo GE, recebe o nr. de meses a considerar
              retorna a data de Horizonte Fluxo
------------------------------------------------------------------------------*/

    /* Definicao de Parametros */                                     
    DEF INPUT  PARAM pNrMesCB         AS INT                      NO-UNDO.                                   
    DEF OUTPUT PARAM pDatHorizFluxoCx AS DATE FORMAT "99/99/9999" NO-UNDO.

    /* Definicao de Variaveis Locias */                                    
    DEF VAR iCont   AS INT NO-UNDO.
    DEF VAR iMes    AS INT NO-UNDO.

&IF "{&FC_OBJETIVO_GE}" = "YES" &THEN
    IF NOT AVAILABLE {&TableName} THEN RETURN "NOK":U.

    /* Utiliza nr meses do ParamGE */
    ASSIGN pNrMesCB = {&TableName}.horiz-cb.
&ENDIF

    ASSIGN pNrMesCB = IF pNrMesCB = 0 THEN 1 ELSE pNrMesCB.

    /*** CALCULO DO HORIZONTO DE FLUXO DE CAIXA ***/
    ASSIGN iCont = 0.
    DO  pDatHorizFluxoCx = TODAY TO DATE(12,31,9999) BY 1:
        IF  iMes <> MONTH(pDatHorizFluxoCx) THEN DO:
            ASSIGN iMes  = MONTH(pDatHorizFluxoCx)               
                   iCont = iCont + 1.    
        END.
        IF  iCont = pNrMesCB THEN LEAVE.    
    END.

    ASSIGN iCont = 32.
    REPEAT:
        ASSIGN ERROR-STATUS:ERROR = NO
               iCont             = iCont - 1.

        ASSIGN pDatHorizFluxoCx = DATE(MONTH(pDatHorizFluxoCx),iCont,YEAR(pDatHorizFluxoCx)) NO-ERROR.
        IF  ERROR-STATUS:ERROR = NO THEN LEAVE. 
    END.
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calcPeriodoAMPM DBOProgram 
PROCEDURE calcPeriodoAMPM :
/*------------------------------------------------------------------------------
  Purpose   : Com base param-ge posicionado, Calcula Periodo do Prazo Medio e 
              Atraso Medio
  Parameters: para release sem Objetivo GE, recebe o nr. de meses a considerar
              retorna a data para PM e AM  
------------------------------------------------------------------------------*/
    /* Definicao de Parametros */                                     
    DEF INPUT  PARAM pNrMesAMPM       AS INT                      NO-UNDO.                                   
    DEF INPUT  PARAM pModulo          AS CHAR                     NO-UNDO.
    DEF OUTPUT PARAM pDatAtrasPrazMed AS DATE FORMAT "99/99/9999" NO-UNDO.

    DEF VAR iCont AS INT NO-UNDO.
    DEF VAR iMes  AS INT NO-UNDO.

&IF "{&FC_OBJETIVO_GE}" = "YES" &THEN
    IF NOT AVAILABLE {&TableName} THEN RETURN "NOK":U.

    /* Utiliza nr meses do ParamGE */
    IF pModulo = "AP":U THEN
        ASSIGN pNrMesAMPM = param-ge.horiz-ap.
    ELSE 
        ASSIGN pNrMesAMPM = param-ge.horiz-cr.
&ENDIF    

    /*** CALCULO DO PER÷ODO PARA PMP AMP ***/
    ASSIGN iCont = 0
           iMes  = 0.
    DO  pDatAtrasPrazMed = TODAY TO &IF "{&ems_dbtype}":U = "MSS":U &THEN date(01,01,1800) &ELSE date(01,01,0001) &ENDIF  BY -1:
        IF  iMes <> MONTH(pDatAtrasPrazMed) THEN DO:
            ASSIGN iMes  = MONTH(pDatAtrasPrazMed)               
                   iCont = iCont + 1.    
        END.
        IF  iCont = pNrMesAMPM THEN LEAVE.    
    END.
    ASSIGN pDatAtrasPrazMed = DATE(MONTH(pDatAtrasPrazMed),01,YEAR(pDatAtrasPrazMed)).

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
        &IF "{&mguni_version}" >= "2.07A" &THEN	
            WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
        &ENDIF
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "conta-contabil":U THEN ASSIGN pFieldValue = RowObject.conta-contabil.
        WHEN "ct-codigo":U THEN ASSIGN pFieldValue = RowObject.ct-codigo.
        WHEN "sc-codigo":U THEN ASSIGN pFieldValue = RowObject.sc-codigo.
        WHEN "usuario":U THEN ASSIGN pFieldValue = RowObject.usuario.
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
        WHEN "vl-disp-ini":U THEN ASSIGN pFieldValue = RowObject.vl-disp-ini.
        WHEN "vl-fat-ano":U THEN ASSIGN pFieldValue = RowObject.vl-fat-ano.
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
        &IF "{&mguni_version}" < "2.07A" &THEN	
            WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
        &ENDIF
        WHEN "fator-div":U THEN ASSIGN pFieldValue = RowObject.fator-div.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "segundo-atual":U THEN ASSIGN pFieldValue = RowObject.segundo-atual.
        WHEN "tp-atualizacao":U THEN ASSIGN pFieldValue = RowObject.tp-atualizacao.
        WHEN "vl-fat-mes":U THEN ASSIGN pFieldValue = RowObject.vl-fat-mes.
        WHEN "vl-ped-mes":U THEN ASSIGN pFieldValue = RowObject.vl-ped-mes.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice EMPRESA
  Parameters:
               retorna valor dos campos do °ndice EMPRESA
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pep-codigo LIKE param-ge.ep-codigo NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pep-codigo = RowObject.ep-codigo.

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
        WHEN "calc-disponivel":U THEN ASSIGN pFieldValue = RowObject.calc-disponivel.
        WHEN "informa-data":U THEN ASSIGN pFieldValue = RowObject.informa-data.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "video-colorido":U THEN ASSIGN pFieldValue = RowObject.video-colorido.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRecidField DBOProgram 
PROCEDURE getRecidField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo recid
  Parameters:
               recebe nome do campo
               retorna valor do campo
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RECID NO-UNDO.

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
  Purpose:     Reposiciona registro com base no °ndice EMPRESA
  Parameters:
               recebe valor dos campos do °ndice EMPRESA
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo LIKE param-ge.ep-codigo NO-UNDO.

    FIND FIRST bfparam-ge WHERE
        bfparam-ge.ep-codigo = pep-codigo
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfparam-ge THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfparam-ge)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryep-codigo DBOProgram 
PROCEDURE openQueryep-codigo :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH param-ge NO-LOCK
        Where param-ge.ep-codigo >= v_ep_codigo_inicial
        And   Param-ge.ep-codigo <= v_ep_codigo_final  INDEXED-REPOSITION.

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
    OPEN QUERY {&QueryName} FOR EACH param-ge NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaDatInicialGE DBOProgram 
PROCEDURE retornaDatInicialGE :
/*------------------------------------------------------------------------------
  Purpose   : Retorna data inicial de Geraá∆o e a ttData    
  Parameters: 1-Tipo de Geracao  (1-Total,2-Diaria)
              2-retorna Data Inicial de Geracao 
              3-retorna a ttData
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM pTpGeracao  AS INT  NO-UNDO.
    DEF OUTPUT PARAM pDatInicDia AS DATE NO-UNDO.
    DEF OUTPUT PARAM pDatInicGE  AS DATE NO-UNDO.
    DEF OUTPUT PARAM TABLE FOR ttData. 

    DEF VAR dtGerenc AS DATE NO-UNDO.

    IF NOT AVAIL {&TableName} THEN RETURN "NOK":U.

    IF  pTpGeracao = 2 THEN DO: /* Diaria */
        ASSIGN pDatInicDia = TODAY - &IF "{&FC_OBJETIVO_GE}" = "YES" &THEN
                                         {&TableName}.horiz-at-diaria
                                     &ELSE        
                                         {&TableName}.dec-1
                                     &ENDIF.

        DO dtGerenc = pDatInicDia TO TODAY:
           CREATE ttData.
           ASSIGN ttData.data = dtGerenc.
        END.    

        /* Calcula Data Inicial GE */        
        ASSIGN pDatInicGE = (&IF "{&mgadm_version}" >= "2.04" &THEN
                                 {&TableName}.dt-inicio-ge
                            &ELSE
                                 DATE({&TableName}.usuario)
                            &ENDIF) 
               pDatInicGE = (IF  pDatInicGE = ? THEN &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF  ELSE pDatInicGE) NO-ERROR. 
    END.    
    ELSE DO: /* Total */
        /* Calcula Data Inicial GE */        
        ASSIGN pDatInicGE = (&IF "{&mgadm_version}" >= "2.04" &THEN
                                 {&TableName}.dt-inicio-ge
                             &ELSE
                                 DATE({&TableName}.usuario)
                             &ENDIF) NO-ERROR. 

        /* mais de 2000 dias (5 anos) considerar todo o movimento */                                          
        IF  pDatInicGE = ? OR ((TODAY - pDatInicGE) > 2000) THEN DO:
             CREATE ttData.
             ASSIGN ttData.data  = ?
                    pDatInicGE = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF .                
        END.
        ELSE DO:         
            DO dtGerenc = pDatInicGE TO TODAY:
               CREATE ttData.
               ASSIGN ttData.data = dtGerenc.
            END.    
        END.
        ASSIGN pDatInicDia = pDatInicGE.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintep-codigo DBOProgram 
PROCEDURE setConstraintep-codigo :

&IF "{&mguni_version}" >= "2.07A" &THEN
def input Parameter p_ep_codigo_inicial LIKE empresa.ep-codigo NO-UNDO.
&ELSE
def input Parameter p_ep_codigo_inicial as integer no-undo.
&ENDIF
&IF "{&mguni_version}" >= "2.07A" &THEN
def input Parameter p_ep_codigo_final LIKE empresa.ep-codigo NO-UNDO.
&ELSE
def input parameter p_ep_codigo_final   as integer no-undo.
&ENDIF

    Assign v_ep_codigo_inicial = p_ep_codigo_inicial
           v_ep_codigo_final   = p_ep_codigo_final.

end procedure.

.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.

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

