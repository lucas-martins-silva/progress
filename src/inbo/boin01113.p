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
{include/i-prgvrs.i boin01113 2.00.00.048 } /*** "010048" 07/08/2026 21:18:17 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin01113 MUT}
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
&GLOBAL-DEFINE DBOName boin01113
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName ws-item-docto-transf-depos
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 
&GLOBAL-DEFINE CHANGE-QUERY-TO-FIND TRUE
&GLOBAL-DEFINE CHANGE-QUERY-TO-FIND-PROCS Main, ItemTransDepos

/* DBO-XML-BEGIN */
/* Pre-processadores para ativar XML no DBO */
/* Retirar o comentario para ativar 
&GLOBAL-DEFINE XMLProducer YES    /* DBO atua como producer de mensagens para o Message Broker */
&GLOBAL-DEFINE XMLTopic           /* Topico da Mensagem enviada ao Message Broker, geralmente o nome da tabela */
&GLOBAL-DEFINE XMLTableName       /* Nome da tabela que deve ser usado como TAG no XML */ 
&GLOBAL-DEFINE XMLTableNameMult   /* Nome da tabela no plural. Usado para multiplos registros */ 
&GLOBAL-DEFINE XMLPublicFields    /* Lista dos campos (c1,c2) que podem ser enviados via XML. Ficam fora da listas os campos de especializacao da tabela */ 
&GLOBAL-DEFINE XMLKeyFields       /* Lista dos campos chave da tabela (c1,c2) */
&GLOBAL-DEFINE XMLExcludeFields   /* Lista de campos a serem excluidos do XML quando PublicFields = "" */

&GLOBAL-DEFINE XMLReceiver YES    /* DBO atua como receiver de mensagens enviado pelo Message Broker (mÇtodo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /* Nome da Query que d† acessos a todos os registros, exceto os exclu°dos pela constraint de seguranáa. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /* Informar os campos da chave quando o Progress n∆o conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin01113.i RowObject}

/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}

{cdp/cdcfgmat.i}
{cdp/cd0666.i}
{utp/ut-glob.i}
{cep/ceapi001k.i}

/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/* Variables Definitions */
DEFINE VARIABLE pNumDocTransf LIKE ws-docto-transf-depos.num-docto-transf NO-UNDO.
DEFINE VARIABLE pCodEstab     LIKE ws-docto-transf-depos.cod-estab        NO-UNDO.

DEFINE NEW GLOBAL SHARED VAR gcod-programa AS CHARACTER                NO-UNDO.
DEFINE VARIABLE h-ceapi001k                AS HANDLE                   NO-UNDO.
DEFINE VARIABLE i-seq-erro                 AS INTEGER                  NO-UNDO.


DEF TEMP-TABLE ttws-docto-transf-depos-aux      NO-UNDO LIKE ws-docto-transf-depos.
DEF TEMP-TABLE ttws-item-docto-transf-depos-aux NO-UNDO LIKE ws-item-docto-transf-depos.

DEFINE TEMP-TABLE RowErrorsAux NO-UNDO
    FIELD ErrorSequence    AS INTEGER
    FIELD ErrorNumber      AS INTEGER
    FIELD ErrorDescription AS CHARACTER
    FIELD ErrorParameters  AS CHARACTER
    FIELD ErrorType        AS CHARACTER
    FIELD ErrorHelp        AS CHARACTER
    FIELD ErrorSubType     AS CHARACTER.

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
         HEIGHT             = 21.08
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDeleteRecord DBOProgram 
PROCEDURE afterDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF CAN-FIND (FIRST bf{&TableName} NO-LOCK 
                     WHERE bf{&TableName}.num-docto-transf = RowObject.num-docto-transf) THEN DO:

    
    IF NOT CAN-FIND (FIRST bf{&TableName} NO-LOCK 
                     WHERE bf{&TableName}.num-docto-transf = RowObject.num-docto-transf
                       AND bf{&tablename}.idi-sit-docto   <> 4
                       AND bf{&TableName}.num-seq         <> RowObject.num-seq) THEN DO:
    
        FIND FIRST ws-docto-transf-depos EXCLUSIVE-LOCK
             WHERE ws-docto-transf-depos.num-docto-transf = RowObject.num-docto-transf NO-ERROR.
    
        IF AVAIL ws-docto-transf-depos THEN
            ASSIGN ws-docto-transf-depos.idi-sit-docto = 4.
    
    END.
END.


    RETURN "OK":U. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findFirstItemTransDepos DBOProgram 
PROCEDURE findFirstItemTransDepos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND FIRST {&TableName} 
        WHERE {&TableName}.num-docto-transf = pNumDocTransf NO-LOCK NO-ERROR.
    
    RETURN "OK":U.          

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findFirstMain DBOProgram 
PROCEDURE findFirstMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FIND FIRST {&TableName} NO-LOCK NO-ERROR.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findLastItemTransDepos DBOProgram 
PROCEDURE findLastItemTransDepos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FIND LAST {&TableName} 
        WHERE {&TableName}.num-docto-transf = pNumDocTransf NO-LOCK NO-ERROR.
    
    RETURN "OK":U.          

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findLastMain DBOProgram 
PROCEDURE findLastMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FIND LAST {&TableName} NO-LOCK NO-ERROR.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findNextItemTransDepos DBOProgram 
PROCEDURE findNextItemTransDepos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FIND NEXT {&TableName} 
        WHERE {&TableName}.num-docto-transf = pNumDocTransf NO-LOCK NO-ERROR.
    
    RETURN "OK":U.          

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findNextMain DBOProgram 
PROCEDURE findNextMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FIND NEXT {&TableName} NO-LOCK NO-ERROR.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findPrevItemTransDepos DBOProgram 
PROCEDURE findPrevItemTransDepos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FIND PREV {&TableName} 
        WHERE {&TableName}.num-docto-transf = pNumDocTransf NO-LOCK NO-ERROR.
    
    RETURN "OK":U.          

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findPrevMain DBOProgram 
PROCEDURE findPrevMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FIND PREV {&TableName} NO-LOCK NO-ERROR.

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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-item":U THEN ASSIGN pFieldValue = RowObject.cod-item.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-localiz-saida":U THEN ASSIGN pFieldValue = RowObject.cod-localiz-saida.
        WHEN "cod-localiz-entr":U THEN ASSIGN pFieldValue = RowObject.cod-localiz-entr.        
        WHEN "cod-lote":U THEN ASSIGN pFieldValue = RowObject.cod-lote.
        WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
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
        WHEN "dat-livre-1":U THEN ASSIGN pFieldValue = RowObject.dat-livre-1.
        WHEN "dat-livre-2":U THEN ASSIGN pFieldValue = RowObject.dat-livre-2.
        WHEN "dat-livre-3":U THEN ASSIGN pFieldValue = RowObject.dat-livre-3.
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
        WHEN "qtd-item":U THEN ASSIGN pFieldValue = RowObject.qtd-item.
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
        WHEN "val-livre-3":U THEN ASSIGN pFieldValue = RowObject.val-livre-3.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDtValidLote DBOProgram 
PROCEDURE getDtValidLote :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT  PARAM pCodEstabel  like saldo-estoq.cod-estabel   no-undo.
    DEF INPUT  PARAM pCodDepos    like saldo-estoq.cod-depos     no-undo.
    DEF INPUT  PARAM pCodLocaliz  like saldo-estoq.cod-localiz   no-undo.
    DEF INPUT  PARAM pLote        like saldo-estoq.lote          no-undo.
    DEF INPUT  PARAM pItCodigo    like saldo-estoq.it-codigo     no-undo.
    DEF INPUT  PARAM pCodRefer    like saldo-estoq.cod-refer     no-undo.
    DEF OUTPUT PARAM pDtValiLote like saldo-estoq.dt-vali-lote   no-undo.

    FIND FIRST saldo-estoq
         WHERE saldo-estoq.cod-estabel = pCodEstabel
           AND saldo-estoq.cod-depos   = pCodDepos
           AND saldo-estoq.cod-localiz = pCodLocaliz
           AND saldo-estoq.lote        = pLote
           AND saldo-estoq.it-codigo   = pItCodigo 
           AND saldo-estoq.cod-refer   = pCodRefer NO-ERROR.
    IF AVAIL saldo-estoq THEN
        ASSIGN pDtValiLote = saldo-estoq.dt-vali-lote.
                
    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getHabilitaLote DBOProgram 
PROCEDURE getHabilitaLote :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAM c-it-codigo      AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAM l-habilita-lote  AS LOGICAL   NO-UNDO.
    DEFINE OUTPUT PARAM l-habilita-valid AS LOGICAL   NO-UNDO.

    FIND FIRST ITEM
         WHERE ITEM.it-codigo = c-it-codigo NO-LOCK NO-ERROR.

    IF AVAIL ITEM THEN
        ASSIGN l-habilita-lote  = (ITEM.tipo-con-est > 1)
               l-habilita-valid = (ITEM.tipo-con-est > 2).
    ELSE DO:
        ASSIGN l-habilita-lote  = NO
               l-habilita-valid = NO.
        RETURN "NOK":U.
    END.
        
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getHabilitaRef DBOProgram 
PROCEDURE getHabilitaRef :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAM c-it-codigo AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAM l-habilita AS LOGICAL NO-UNDO.

    FIND FIRST item 
         WHERE item.it-codigo = c-it-codigo NO-LOCK NO-ERROR.

    IF AVAIL item THEN
        ASSIGN l-habilita = (ITEM.tipo-con-est = 4).
        
    ELSE DO:
        ASSIGN l-habilita = no.
        RETURN "NOK":U.
    END.
        
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
        WHEN "idi-sit-docto":U    THEN ASSIGN pFieldValue = RowObject.idi-sit-docto.
        WHEN "num-docto-transf":U THEN ASSIGN pFieldValue = RowObject.num-docto-transf.
        WHEN "num-livre-1":U      THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U      THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "num-livre-3":U      THEN ASSIGN pFieldValue = RowObject.num-livre-3.
        WHEN "num-seq":U          THEN ASSIGN pFieldValue = RowObject.num-seq.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getItemDoctoTransfDepos DBOProgram 
PROCEDURE getItemDoctoTransfDepos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM c-cod-estabel       LIKE ws-docto-transf-depos.cod-estab         NO-UNDO.
    DEF INPUT  PARAM c-cod-depos         LIKE deposito.cod-depos        NO-UNDO.
    DEF INPUT  PARAM i-classificacao     AS INT                            NO-UNDO.
    DEF INPUT  PARAM c-nr-docto-ini      LIKE ws-docto-transf-depos.num-docto NO-UNDO.
    DEF INPUT  PARAM c-nr-docto-fim      LIKE ws-docto-transf-depos.num-docto NO-UNDO.
    DEF INPUT  PARAM dt-implan-ini       AS DATE FORMAT "99/99/9999"          NO-UNDO.
    DEF INPUT  PARAM dt-implan-fim       AS DATE FORMAT "99/99/9999"          NO-UNDO.
    DEF INPUT  PARAM c-item-ini          LIKE ITEM.it-codigo                  NO-UNDO.
    DEF INPUT  PARAM c-item-fim          LIKE ITEM.it-codigo                  NO-UNDO.
    DEF INPUT  PARAM c-usuario-ini       AS CHAR FORMAT "x(16)"               NO-UNDO.
    DEF INPUT  PARAM c-usuario-fim       AS CHAR FORMAT "x(16)"               NO-UNDO.
    DEF OUTPUT PARAM TABLE FOR ttws-docto-transf-depos-aux.    
    DEF OUTPUT PARAM TABLE FOR ttws-item-docto-transf-depos-aux.    

    FOR EACH ttws-docto-transf-depos-aux:
        DELETE ttws-docto-transf-depos-aux.
    END.

    FOR EACH ttws-item-docto-transf-depos-aux:
        DELETE ttws-item-docto-transf-depos-aux.
    END.

    IF i-classificacao = 1 THEN DO: /* Data Implantaá∆o */
        FOR EACH ws-docto-transf-depos WHERE
            ws-docto-transf-depos.cod-estab        =  c-cod-estabel  AND
            ws-docto-transf-depos.cod-depos-saida  =  c-cod-depos    AND
            ws-docto-transf-depos.idi-sit-docto    =  1              AND
            ws-docto-transf-depos.dat-docto        >= dt-implan-ini  AND
            ws-docto-transf-depos.dat-docto        <= dt-implan-fim  AND
            ws-docto-transf-depos.num-docto-transf >= c-nr-docto-ini AND
            ws-docto-transf-depos.num-docto-transf <= c-nr-docto-fim NO-LOCK:
            CREATE ttws-docto-transf-depos-aux.
            BUFFER-COPY ws-docto-transf-depos TO ttws-docto-transf-depos-aux.
            FOR EACH ws-item-docto-transf-depos OF ws-docto-transf-depos NO-LOCK:
                CREATE ttws-item-docto-transf-depos-aux.
                BUFFER-COPY ws-item-docto-transf-depos TO ttws-item-docto-transf-depos-aux.
            END.
        END.
        FOR EACH ws-docto-transf-depos WHERE
            ws-docto-transf-depos.cod-estab        =  c-cod-estabel  AND
            ws-docto-transf-depos.cod-depos-saida  =  c-cod-depos    AND
            ws-docto-transf-depos.idi-sit-docto    =  2              AND
            ws-docto-transf-depos.dat-docto        >= dt-implan-ini  AND
            ws-docto-transf-depos.dat-docto        <= dt-implan-fim  AND
            ws-docto-transf-depos.num-docto-transf >= c-nr-docto-ini AND
            ws-docto-transf-depos.num-docto-transf <= c-nr-docto-fim NO-LOCK:
            CREATE ttws-docto-transf-depos-aux.
            BUFFER-COPY ws-docto-transf-depos TO ttws-docto-transf-depos-aux.
            FOR EACH ws-item-docto-transf-depos OF ws-docto-transf-depos NO-LOCK:
                CREATE ttws-item-docto-transf-depos-aux.
                BUFFER-COPY ws-item-docto-transf-depos TO ttws-item-docto-transf-depos-aux.
            END.
        END.
        FOR EACH ws-docto-transf-depos WHERE
            ws-docto-transf-depos.cod-estab        =  c-cod-estabel  AND
            ws-docto-transf-depos.cod-depos-saida  =  c-cod-depos    AND
            ws-docto-transf-depos.idi-sit-docto    =  3              AND
            ws-docto-transf-depos.dat-docto        >= dt-implan-ini  AND
            ws-docto-transf-depos.dat-docto        <= dt-implan-fim  AND
            ws-docto-transf-depos.num-docto-transf >= c-nr-docto-ini AND
            ws-docto-transf-depos.num-docto-transf <= c-nr-docto-fim NO-LOCK:
            CREATE ttws-docto-transf-depos-aux.
            BUFFER-COPY ws-docto-transf-depos TO ttws-docto-transf-depos-aux.
            FOR EACH ws-item-docto-transf-depos OF ws-docto-transf-depos WHERE
                ws-item-docto-transf-depos.qtd-item > ws-item-docto-transf-depos.qtd-movto-item 
                NO-LOCK:
                CREATE ttws-item-docto-transf-depos-aux.
                BUFFER-COPY ws-item-docto-transf-depos TO ttws-item-docto-transf-depos-aux.
            END.
        END.        
    END.
    ELSE IF i-classificacao = 2 THEN DO: /* Item */
        FOR EACH ws-item-docto-transf-depos WHERE
            ws-item-docto-transf-depos.idi-sit-docto    =  1              AND
            ws-item-docto-transf-depos.cod-item         >= c-item-ini     AND
            ws-item-docto-transf-depos.cod-item         <= c-item-fim     AND
            ws-item-docto-transf-depos.num-docto-transf >= c-nr-docto-ini AND
            ws-item-docto-transf-depos.num-docto-transf <= c-nr-docto-fim NO-LOCK:
            FOR FIRST ws-docto-transf-depos OF ws-item-docto-transf-depos WHERE
                ws-docto-transf-depos.cod-estab        =  c-cod-estabel  AND
                ws-docto-transf-depos.cod-depos-saida  =  c-cod-depos    NO-LOCK:
                IF NOT CAN-FIND(FIRST ttws-docto-transf-depos-aux WHERE
                    ttws-docto-transf-depos-aux.num-docto-transf = ws-docto-transf-depos.num-docto-transf NO-LOCK) THEN DO:
                    CREATE ttws-docto-transf-depos-aux.
                    BUFFER-COPY ws-docto-transf-depos TO ttws-docto-transf-depos-aux.
                END.
                CREATE ttws-item-docto-transf-depos-aux.
                BUFFER-COPY ws-item-docto-transf-depos TO ttws-item-docto-transf-depos-aux.
            END.
        END.
        FOR EACH ws-item-docto-transf-depos WHERE
            ws-item-docto-transf-depos.idi-sit-docto    =  2              AND
            ws-item-docto-transf-depos.cod-item         >= c-item-ini     AND
            ws-item-docto-transf-depos.cod-item         <= c-item-fim     AND
            ws-item-docto-transf-depos.num-docto-transf >= c-nr-docto-ini AND
            ws-item-docto-transf-depos.num-docto-transf <= c-nr-docto-fim NO-LOCK:
            FOR FIRST ws-docto-transf-depos OF ws-item-docto-transf-depos WHERE
                ws-docto-transf-depos.cod-estab        =  c-cod-estabel  AND
                ws-docto-transf-depos.cod-depos-saida  =  c-cod-depos    NO-LOCK:
                IF NOT CAN-FIND(FIRST ttws-docto-transf-depos-aux WHERE
                    ttws-docto-transf-depos-aux.num-docto-transf = ws-docto-transf-depos.num-docto-transf NO-LOCK) THEN DO:
                    CREATE ttws-docto-transf-depos-aux.
                    BUFFER-COPY ws-docto-transf-depos TO ttws-docto-transf-depos-aux.
                END.
                CREATE ttws-item-docto-transf-depos-aux.
                BUFFER-COPY ws-item-docto-transf-depos TO ttws-item-docto-transf-depos-aux.
            END.
        END.
        FOR EACH ws-item-docto-transf-depos WHERE
            ws-item-docto-transf-depos.idi-sit-docto    =  3              AND
            ws-item-docto-transf-depos.cod-item         >= c-item-ini     AND
            ws-item-docto-transf-depos.cod-item         <= c-item-fim     AND
            ws-item-docto-transf-depos.num-docto-transf >= c-nr-docto-ini AND
            ws-item-docto-transf-depos.num-docto-transf <= c-nr-docto-fim AND
            ws-item-docto-transf-depos.qtd-item         >  ws-item-docto-transf-depos.qtd-movto-item 
            NO-LOCK:
            FOR FIRST ws-docto-transf-depos OF ws-item-docto-transf-depos WHERE
                ws-docto-transf-depos.cod-estab        =  c-cod-estabel  AND
                ws-docto-transf-depos.cod-depos-saida  =  c-cod-depos    NO-LOCK:
                IF NOT CAN-FIND(FIRST ttws-docto-transf-depos-aux WHERE
                    ttws-docto-transf-depos-aux.num-docto-transf = ws-docto-transf-depos.num-docto-transf NO-LOCK) THEN DO:
                    CREATE ttws-docto-transf-depos-aux.
                    BUFFER-COPY ws-docto-transf-depos TO ttws-docto-transf-depos-aux.
                END.                    
                CREATE ttws-item-docto-transf-depos-aux.
                BUFFER-COPY ws-item-docto-transf-depos TO ttws-item-docto-transf-depos-aux.
            END.
        END.        
    END.
    ELSE IF i-classificacao = 3 THEN DO: /* Documento */
        FOR EACH ws-docto-transf-depos WHERE
            ws-docto-transf-depos.cod-estab        =  c-cod-estabel  AND
            ws-docto-transf-depos.cod-depos-saida  =  c-cod-depos    AND
            ws-docto-transf-depos.idi-sit-docto    =  1              AND
            ws-docto-transf-depos.num-docto-transf >= c-nr-docto-ini AND
            ws-docto-transf-depos.num-docto-transf <= c-nr-docto-fim NO-LOCK:
            CREATE ttws-docto-transf-depos-aux.
            BUFFER-COPY ws-docto-transf-depos TO ttws-docto-transf-depos-aux.
            FOR EACH ws-item-docto-transf-depos OF ws-docto-transf-depos NO-LOCK:
                CREATE ttws-item-docto-transf-depos-aux.
                BUFFER-COPY ws-item-docto-transf-depos TO ttws-item-docto-transf-depos-aux.
            END.
        END.
        FOR EACH ws-docto-transf-depos WHERE
            ws-docto-transf-depos.cod-estab        =  c-cod-estabel  AND
            ws-docto-transf-depos.cod-depos-saida  =  c-cod-depos    AND
            ws-docto-transf-depos.idi-sit-docto    =  2              AND
            ws-docto-transf-depos.num-docto-transf >= c-nr-docto-ini AND
            ws-docto-transf-depos.num-docto-transf <= c-nr-docto-fim NO-LOCK:
            CREATE ttws-docto-transf-depos-aux.
            BUFFER-COPY ws-docto-transf-depos TO ttws-docto-transf-depos-aux.
            FOR EACH ws-item-docto-transf-depos OF ws-docto-transf-depos NO-LOCK:
                CREATE ttws-item-docto-transf-depos-aux.
                BUFFER-COPY ws-item-docto-transf-depos TO ttws-item-docto-transf-depos-aux.
            END.
        END.
        FOR EACH ws-docto-transf-depos WHERE
            ws-docto-transf-depos.cod-estab        =  c-cod-estabel  AND
            ws-docto-transf-depos.cod-depos-saida  =  c-cod-depos    AND
            ws-docto-transf-depos.idi-sit-docto    =  3              AND
            ws-docto-transf-depos.num-docto-transf >= c-nr-docto-ini AND
            ws-docto-transf-depos.num-docto-transf <= c-nr-docto-fim NO-LOCK:
            CREATE ttws-docto-transf-depos-aux.
            BUFFER-COPY ws-docto-transf-depos TO ttws-docto-transf-depos-aux.
            FOR EACH ws-item-docto-transf-depos OF ws-docto-transf-depos WHERE
                ws-item-docto-transf-depos.qtd-item > ws-item-docto-transf-depos.qtd-movto-item 
                NO-LOCK:
                CREATE ttws-item-docto-transf-depos-aux.
                BUFFER-COPY ws-item-docto-transf-depos TO ttws-item-docto-transf-depos-aux.
            END.
        END.        
    END.
    ELSE IF i-classificacao = 4 THEN DO: /* Usu†rio */
        FOR EACH ws-docto-transf-depos WHERE
            ws-docto-transf-depos.cod-estab        =  c-cod-estabel  AND
            ws-docto-transf-depos.cod-depos-saida  =  c-cod-depos    AND
            ws-docto-transf-depos.idi-sit-docto    =  1              AND
            ws-docto-transf-depos.cod-usuar        >= c-usuario-ini  AND
            ws-docto-transf-depos.cod-usuar        <= c-usuario-fim  AND
            ws-docto-transf-depos.num-docto-transf >= c-nr-docto-ini AND
            ws-docto-transf-depos.num-docto-transf <= c-nr-docto-fim NO-LOCK:
            CREATE ttws-docto-transf-depos-aux.
            BUFFER-COPY ws-docto-transf-depos TO ttws-docto-transf-depos-aux.
            FOR EACH ws-item-docto-transf-depos OF ws-docto-transf-depos NO-LOCK:
                CREATE ttws-item-docto-transf-depos-aux.
                BUFFER-COPY ws-item-docto-transf-depos TO ttws-item-docto-transf-depos-aux.
            END.
        END.
        FOR EACH ws-docto-transf-depos WHERE
            ws-docto-transf-depos.cod-estab        =  c-cod-estabel  AND
            ws-docto-transf-depos.cod-depos-saida  =  c-cod-depos    AND
            ws-docto-transf-depos.idi-sit-docto    =  2              AND
            ws-docto-transf-depos.cod-usuar        >= c-usuario-ini  AND
            ws-docto-transf-depos.cod-usuar        <= c-usuario-fim  AND
            ws-docto-transf-depos.num-docto-transf >= c-nr-docto-ini AND
            ws-docto-transf-depos.num-docto-transf <= c-nr-docto-fim NO-LOCK:
            CREATE ttws-docto-transf-depos-aux.
            BUFFER-COPY ws-docto-transf-depos TO ttws-docto-transf-depos-aux.
            FOR EACH ws-item-docto-transf-depos OF ws-docto-transf-depos NO-LOCK:
                CREATE ttws-item-docto-transf-depos-aux.
                BUFFER-COPY ws-item-docto-transf-depos TO ttws-item-docto-transf-depos-aux.
            END.
        END.
        FOR EACH ws-docto-transf-depos WHERE
            ws-docto-transf-depos.cod-estab        =  c-cod-estabel  AND
            ws-docto-transf-depos.cod-depos-saida  =  c-cod-depos    AND
            ws-docto-transf-depos.idi-sit-docto    =  3              AND
            ws-docto-transf-depos.cod-usuar        >= c-usuario-ini  AND
            ws-docto-transf-depos.cod-usuar        <= c-usuario-fim  AND
            ws-docto-transf-depos.num-docto-transf >= c-nr-docto-ini AND
            ws-docto-transf-depos.num-docto-transf <= c-nr-docto-fim NO-LOCK:
            CREATE ttws-docto-transf-depos-aux.
            BUFFER-COPY ws-docto-transf-depos TO ttws-docto-transf-depos-aux.
            FOR EACH ws-item-docto-transf-depos OF ws-docto-transf-depos WHERE
                ws-item-docto-transf-depos.qtd-item > ws-item-docto-transf-depos.qtd-movto-item NO-LOCK:
                CREATE ttws-item-docto-transf-depos-aux.
                BUFFER-COPY ws-item-docto-transf-depos TO ttws-item-docto-transf-depos-aux.
            END.
        END.
    END.
    ELSE IF i-classificacao = 5 THEN DO: /* Dep¢sito Destino */
        FOR EACH ws-docto-transf-depos WHERE
            ws-docto-transf-depos.cod-estab        =  c-cod-estabel  AND
            ws-docto-transf-depos.cod-depos-entr   =  c-cod-depos    AND
            ws-docto-transf-depos.idi-sit-docto    =  1              AND
            ws-docto-transf-depos.num-docto-transf >= c-nr-docto-ini AND
            ws-docto-transf-depos.num-docto-transf <= c-nr-docto-fim NO-LOCK:
            CREATE ttws-docto-transf-depos-aux.
            BUFFER-COPY ws-docto-transf-depos TO ttws-docto-transf-depos-aux.
            FOR EACH ws-item-docto-transf-depos OF ws-docto-transf-depos NO-LOCK:
                CREATE ttws-item-docto-transf-depos-aux.
                BUFFER-COPY ws-item-docto-transf-depos TO ttws-item-docto-transf-depos-aux.
            END.
        END.
        FOR EACH ws-docto-transf-depos WHERE
            ws-docto-transf-depos.cod-estab        =  c-cod-estabel  AND
            ws-docto-transf-depos.cod-depos-entr   =  c-cod-depos    AND
            ws-docto-transf-depos.idi-sit-docto    =  2              AND
            ws-docto-transf-depos.num-docto-transf >= c-nr-docto-ini AND
            ws-docto-transf-depos.num-docto-transf <= c-nr-docto-fim NO-LOCK:
            CREATE ttws-docto-transf-depos-aux.
            BUFFER-COPY ws-docto-transf-depos TO ttws-docto-transf-depos-aux.
            FOR EACH ws-item-docto-transf-depos OF ws-docto-transf-depos NO-LOCK:
                CREATE ttws-item-docto-transf-depos-aux.
                BUFFER-COPY ws-item-docto-transf-depos TO ttws-item-docto-transf-depos-aux.
            END.
        END.
        FOR EACH ws-docto-transf-depos WHERE
            ws-docto-transf-depos.cod-estab        =  c-cod-estabel  AND
            ws-docto-transf-depos.cod-depos-entr   =  c-cod-depos    AND
            ws-docto-transf-depos.idi-sit-docto    =  3              AND
            ws-docto-transf-depos.num-docto-transf >= c-nr-docto-ini AND
            ws-docto-transf-depos.num-docto-transf <= c-nr-docto-fim NO-LOCK:
            CREATE ttws-docto-transf-depos-aux.
            BUFFER-COPY ws-docto-transf-depos TO ttws-docto-transf-depos-aux.
            FOR EACH ws-item-docto-transf-depos OF ws-docto-transf-depos WHERE
                ws-item-docto-transf-depos.qtd-item > ws-item-docto-transf-depos.qtd-movto-item NO-LOCK:
                CREATE ttws-item-docto-transf-depos-aux.
                BUFFER-COPY ws-item-docto-transf-depos TO ttws-item-docto-transf-depos-aux.
            END.
        END.        
    END.
        
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice itmdcttr-item-docto-id
  Parameters:  
               retorna valor do campo num-docto-transf
               retorna valor do campo num-seq
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnum-docto-transf LIKE ws-item-docto-transf-depos.num-docto-transf NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-seq LIKE ws-item-docto-transf-depos.num-seq NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnum-docto-transf = RowObject.num-docto-transf
           pnum-seq = RowObject.num-seq.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLastSequence DBOProgram 
PROCEDURE getLastSequence :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER pNumDoctoTransf LIKE ws-docto-transf-depos.num-docto-transf NO-UNDO.
    DEFINE OUTPUT PARAMETER pNumSequence    AS INTEGER                               NO-UNDO.
    
    FIND LAST bf{&TableName}
        WHERE bf{&TableName}.num-docto-transf = pNumDoctoTransf NO-LOCK NO-ERROR.
    
    IF AVAIL bf{&TableName} THEN 
        ASSIGN pNumSequence = (bf{&TableName}.num-seq + 10).
    ELSE 
        ASSIGN pNumSequence = 10.    
    
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
        WHEN "log-livre-1":U THEN ASSIGN pFieldValue = RowObject.log-livre-1.
        WHEN "log-livre-2":U THEN ASSIGN pFieldValue = RowObject.log-livre-2.
        WHEN "log-livre-3":U THEN ASSIGN pFieldValue = RowObject.log-livre-3.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice itmdcttr-item-docto-id
  Parameters:  
               recebe valor do campo num-docto-transf
               recebe valor do campo num-seq
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnum-docto-transf LIKE ws-item-docto-transf-depos.num-docto-transf NO-UNDO.
    DEFINE INPUT PARAMETER pnum-seq LIKE ws-item-docto-transf-depos.num-seq NO-UNDO.

    FIND FIRST bfws-item-docto-transf-depos WHERE 
        bfws-item-docto-transf-depos.num-docto-transf = pnum-docto-transf AND 
        bfws-item-docto-transf-depos.num-seq = pnum-seq NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfws-item-docto-transf-depos THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfws-item-docto-transf-depos)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToDocTransDepos DBOProgram 
PROCEDURE linkToDocTransDepos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pHandle AS HANDLE NO-UNDO.

    RUN getKey IN pHandle (OUTPUT pNumDocTransf,
                           OUTPUT pCodEstab).    
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryItemTransDepos DBOProgram 
PROCEDURE openQueryItemTransDepos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} 
    FOR EACH  {&TableName} 
        WHERE {&TableName}.num-docto-transf = pNumDocTransf NO-LOCK 
        BY {&TableName}.num-seq
        BY {&TableName}.cod-item INDEXED-REPOSITION.
    
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

    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-create-error DBOProgram 
PROCEDURE pi-create-error :
/*------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER piErrorNumber       AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER piErrorParameters   AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER piErrorDescription  AS CHARACTER NO-UNDO.

    ASSIGN i-seq-erro = i-seq-erro + 1.

    IF piErrorDescription = ? THEN DO:

        RUN utp/ut-msgs.p (INPUT "msg",
                           INPUT piErrorNumber,
                           INPUT piErrorParameters).  

        FIND FIRST RowErrors 
             WHERE RowErrors.ErrorDescription = RETURN-VALUE NO-LOCK NO-ERROR.
        IF NOT AVAIL RowErrors THEN DO:
            CREATE RowErrors.
            ASSIGN RowErrors.ErrorSequence    = i-seq-erro
                   RowErrors.ErrorNumber      = piErrorNumber
                   RowErrors.ErrorParameters  = piErrorParameters
                   RowErrors.ErrorType        = "EMS"
                   RowErrors.ErrorSubType     = "ERROR"
                   RowErrors.ErrorDescription = RETURN-VALUE.

            RUN utp/ut-msgs.p (INPUT "help",
                               INPUT RowErrors.ErrorNumber,
                               INPUT RowErrors.ErrorParameters).  
            ASSIGN RowErrors.ErrorHelp = RETURN-VALUE.
        END.
    END.        
    ELSE DO:
            CREATE RowErrors.
            ASSIGN RowErrors.ErrorSequence    = i-seq-erro
                   RowErrors.ErrorNumber      = piErrorNumber
                   RowErrors.ErrorParameters  = ""
                   RowErrors.ErrorType        = "EMS"
                   RowErrors.ErrorSubType     = "ERROR"
                   RowErrors.ErrorDescription = piErrorDescription.

    END.

    RETURN "OK":U.                   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidateInformation DBOProgram 
PROCEDURE piValidateInformation :
/*------------------------------------------------------------------------------
  Purpose: Procedure desenvolvida objetivando realizar algumas validacoes, 
           especificamente ao programa CE9704A;    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pCodEstabel LIKE ws-docto-transf-depos.cod-estab       NO-UNDO.
    DEFINE INPUT PARAMETER pCodDepos   LIKE ws-docto-transf-depos.cod-depos-saida NO-UNDO.

    IF NOT CAN-FIND(FIRST estabelec
                    WHERE estabelec.cod-estabel = pCodEstabel NO-LOCK) THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-estabelecimento-no-wms AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Estabelecimento" *}
        ASSIGN c-lbl-liter-estabelecimento-no-wms = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
            &ErrorNumber="56"
            &ErrorType="EMS"
            &ErrorSubType="ERROR" 
            &ErrorParameters="c-lbl-liter-estabelecimento-no-wms"}      
        RETURN "NOK":U.
    END.

    IF NOT CAN-FIND(FIRST deposito
                    WHERE deposito.cod-depos = pCodDepos NO-LOCK) THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-deposito-no-wms AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Dep¢sito" *}
        ASSIGN c-lbl-liter-deposito-no-wms = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
            &ErrorNumber="56"
            &ErrorType="EMS"
            &ErrorSubType="ERROR" 
            &ErrorParameters="c-lbl-liter-deposito-no-wms"}      
        RETURN "NOK":U.        
    END.


    RETURN "OK":U.

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
    
    DEFINE VARIABLE l-erro      AS    LOGICAL           NO-UNDO.
    DEFINE VARIABLE c-lbl-erro  AS    CHARACTER         NO-UNDO.
            
    DEFINE BUFFER b-depos-entrada  FOR deposito.
    DEFINE BUFFER b-depos-saida    FOR deposito.

    /*--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
              executadas ---*/     
    /*--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/     
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
              include: method/svc/errors/inserr.i ---*/     
    /*--- Inclua aqui as validaá‰es ---*/     

    IF pType = "Create":U THEN DO:
        IF CAN-FIND(FIRST bf{&TableName}
        WHERE bf{&TableName}.num-docto-transf = RowObject.num-docto-transf AND
              bf{&TableName}.num-seq          = RowObject.num-seq NO-LOCK) THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-item-documento-transferencia AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Item_Documento_Transferencia" *}
            ASSIGN c-lbl-liter-item-documento-transferencia = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                  &ErrorNumber="1"
                  &ErrorType="EMS"
                  &ErrorParameters="c-lbl-liter-item-documento-transferencia"}    
        END.          
    END.    
    

    IF pType = "create":U OR pType = "update":U THEN DO:  

        /* Alteracao SOH EH PERMITIDA se a SITUACAO do DOCUMENTO estiver como NAO INICIADO  */         
        IF RowObject.idi-sit-docto = 1  THEN DO:   
                
            FIND FIRST ws-docto-transf-depos
                 WHERE ws-docto-transf-depos.num-docto-transf = RowObject.num-docto-transf NO-LOCK NO-ERROR.
            IF AVAIL ws-docto-transf-depos THEN DO:
                /* "ce0207-dev-sem-lote" ativada Deposito de Sa°da Interna e Deposito de Entrada Externo */
                if ws-docto-transf-depos.log-sem-lote THEN DO:
                   if RowObject.cod-lote <> "" THEN DO:
                      if NOT CAN-FIND(first saldo-estoq
                                      WHERE saldo-estoq.cod-depos   = ws-docto-transf-depos.cod-depos-saida
                                        and saldo-estoq.cod-estabel = ws-docto-transf-depos.cod-estab
                                        and saldo-estoq.cod-localiz = RowObject.cod-localiz-saida
                                        AND saldo-estoq.lote        = RowObject.cod-lote
                                        and saldo-estoq.it-codigo   = RowObject.cod-item 
                                        and saldo-estoq.cod-refer   = RowObject.cod-refer
                                      NO-LOCK) 
                         THEN DO:
                          {utp/ut-liter.i "O Lote informado n∆o existe para este item." *}
                          ASSIGN c-lbl-erro = TRIM(RETURN-VALUE).
                          {method/svc/errors/inserr.i
                              &ErrorNumber="17006"
                              &ErrorType="EMS"
                              &ErrorSubType="ERROR" 
                              &ErrorParameters="c-lbl-erro"}     
                      END.
                   END.
                END.
                FIND FIRST deposito
                     WHERE deposito.cod-depos = ws-docto-transf-depos.cod-depos-saida NO-LOCK NO-ERROR.
                IF AVAIL deposito THEN DO:                     
                    FIND FIRST item
                         WHERE item.it-codigo = RowObject.cod-item NO-LOCK NO-ERROR.
                    IF AVAIL item THEN DO:
                        IF  not deposito.log-wms-externo AND
                            item.tipo-con-est  = 3  AND
                            RowObject.cod-lote = "" and 
                            not ws-docto-transf-depos.log-sem-lote THEN DO:
                            /* Inicio -- Projeto Internacional */
                            DEFINE VARIABLE c-lbl-liter-lote AS CHARACTER NO-UNDO.
                            {utp/ut-liter.i "Lote" *}
                            ASSIGN c-lbl-liter-lote = TRIM(RETURN-VALUE).
                            {method/svc/errors/inserr.i
                                &ErrorNumber="3936"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" 
                                &ErrorParameters="c-lbl-liter-lote"}                        
                        END.                        
                    END.
                END.        
            END.
            
            IF RowObject.qtd-item = 0 THEN DO:
                {method/svc/errors/inserr.i
                    &ErrorNumber="7228"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR" 
                    &ErrorParameters="''"}
            END.
            
            FIND FIRST item
            WHERE item.it-codigo = RowObject.cod-item NO-LOCK NO-ERROR.
            IF NOT AVAIL item THEN DO:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-item AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Item" *}
                ASSIGN c-lbl-liter-item = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                    &ErrorNumber="56"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR" 
                    &ErrorParameters="c-lbl-liter-item"}
            END.
            ELSE DO:
                /* Se o CONTROLE DO ITEM for por NUMERO DE SERIE, a QUANTIDADE DEVE SER IGUAL 1 */                 
                IF  item.tipo-con-est   = 2 AND
                    RowObject.qtd-item <> 1 THEN DO:
                    {method/svc/errors/inserr.i
                        &ErrorNumber="1234"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR" 
                        &ErrorParameters="''"}
                END.            
                
                /* ITEM NAO pode ser do tipo DEBITO DIRETO */                 
                IF item.tipo-contr = 4 THEN DO:
                {method/svc/errors/inserr.i
                    &ErrorNumber="1673"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR" 
                    &ErrorParameters="''"}            
                END.
                /* Para tipo-con-est igual 4 NAO EH POSSIVEL cadastrar uma REFERENCIA */                 
                IF  item.tipo-con-est   <> 4  AND
                    RowObject.cod-refer <> "" THEN DO:
                        /* Inicio -- Projeto Internacional */
                        DEFINE VARIABLE c-lbl-liter-campo-referencia AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "Campo_Referància" *}
                        ASSIGN c-lbl-liter-campo-referencia = TRIM(RETURN-VALUE).
                        DEFINE VARIABLE c-lbl-liter-nulos AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "nulos" *}
                        ASSIGN c-lbl-liter-nulos = TRIM(RETURN-VALUE).
                        DEFINE VARIABLE c-lbl-merge-campo-referencianulos AS CHARACTER NO-UNDO.
                        ASSIGN c-lbl-merge-campo-referencianulos = c-lbl-liter-campo-referencia + "~~" + c-lbl-liter-nulos.
                        {method/svc/errors/inserr.i
                            &ErrorNumber="18769"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lbl-merge-campo-referencianulos"}                            
                END.
                /* Validacao Existencia de uma REFERENCIA */                 
                IF item.tipo-con-est = 4 THEN DO:
                    IF NOT CAN-FIND(FIRST referencia
                    WHERE referencia.cod-refer = RowObject.cod-refer NO-LOCK) THEN DO:
                        /* Inicio -- Projeto Internacional */
                        DEFINE VARIABLE c-lbl-liter-referencia AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "Referància" *}
                        ASSIGN c-lbl-liter-referencia = TRIM(RETURN-VALUE).
                        {method/svc/errors/inserr.i
                            &ErrorNumber="56"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lbl-liter-referencia"}                                
                    END.
                END.            
                /* Para tipo-con-est igual 1 NAO EH POSSIVEL cadastrar um LOTE */                 
                IF  item.tipo-con-est   = 1  AND
                    RowObject.cod-lote <> "" THEN DO:
                        /* Inicio -- Projeto Internacional */
                        DEFINE VARIABLE c-lbl-liter-campo-lote-2 AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "Campo_Lote" *}
                        ASSIGN c-lbl-liter-campo-lote-2 = TRIM(RETURN-VALUE).
                        DEFINE VARIABLE c-lbl-liter-nulos-3 AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "nulos" *}
                        ASSIGN c-lbl-liter-nulos-3 = TRIM(RETURN-VALUE).
                        DEFINE VARIABLE c-lbl-merge-campo-lotenulos-2 AS CHARACTER NO-UNDO.
                        ASSIGN c-lbl-merge-campo-lotenulos-2 = c-lbl-liter-campo-lote-2 + "~~" + c-lbl-liter-nulos-3.
                        {method/svc/errors/inserr.i
                            &ErrorNumber="18769"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lbl-merge-campo-lotenulos-2"}  
                END.

                /* Se a funá∆o estiver ativa o lote deve ser v†lido */
                IF  item.tipo-con-est   = 1  AND
                    RowObject.cod-lote  = "" THEN DO:
                    FIND FIRST funcao NO-LOCK
                         WHERE funcao.cd-funcao = "LOG_CONT_EST_ITEM_WMS"
                           AND funcao.ativo    = YES NO-ERROR.
                    IF AVAIL funcao THEN DO:
                        FIND FIRST b-depos-entrada
                             WHERE b-depos-entrada.cod-depos = ws-docto-transf-depos.cod-depos-entr NO-LOCK NO-ERROR.

                        FIND FIRST b-depos-saida
                            WHERE b-depos-saida.cod-depos = ws-docto-transf-depos.cod-depos-saida NO-LOCK NO-ERROR.
                        IF  AVAIL b-depos-saida
                        AND AVAIL b-depos-entrada THEN DO:
                    
                            IF  b-depos-entrada.log-gera-wms = YES
                            AND b-depos-saida.log-gera-wms   = NO THEN DO:

                                {method/svc/errors/inserr.i
                                    &ErrorNumber="7233"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR" 
                                    &ErrorParameters="''"}
                            END.
                        END.
                    END.
                END.

                IF TRUNCATE(RowObject.qtd-item,0) <> RowObject.qtd-item
                AND NOT ITEM.fraciona
                THEN do:
                    {method/svc/errors/inserr.i
                        &ErrorNumber="4559"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR" 
                        &ErrorParameters="''"}
                END.
                
                FIND FIRST ws-docto-transf-depos
                     WHERE ws-docto-transf-depos.num-docto-transf = RowObject.num-docto-transf NO-LOCK NO-ERROR.
                
                FIND FIRST item-uni-estab NO-LOCK
                     WHERE item-uni-estab.cod-estabel = ws-docto-transf-depos.cod-estab 
                       AND item-uni-estab.it-codigo   = RowObject.cod-item NO-ERROR.       
                      
                IF NOT AVAIL item-uni-estab THEN DO:
                    {method/svc/errors/inserr.i
                        &ErrorNumber="5101"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR" 
                        &ErrorParameters="''"}
                END.  
                ELSE DO:

                    IF item-uni-estab.loc-unica = YES THEN DO:
                        IF item-uni-estab.cod-localiz <> RowObject.cod-localiz-saida THEN DO:
                            {method/svc/errors/inserr.i
                                &ErrorNumber="4898"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" 
                                &ErrorParameters="''"}                                                            
                        END.

                        IF item-uni-estab.cod-localiz <> RowObject.cod-localiz-entr THEN DO:
                            {method/svc/errors/inserr.i
                                &ErrorNumber="4898"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" 
                                &ErrorParameters="''"}                                                            
                        END.
                    END.
                    ELSE DO:
                        FIND FIRST ws-docto-transf-depos
                             WHERE ws-docto-transf-depos.num-docto-transf = RowObject.num-docto-transf NO-LOCK NO-ERROR.
                        
                        IF AVAIL ws-docto-transf-depos THEN DO:
                        
                            IF NOT CAN-FIND(FIRST localizacao
                            WHERE localizacao.cod-estabel = ws-docto-transf-depos.cod-estab         AND
                                  localizacao.cod-depos   = ws-docto-transf-depos.cod-depos-saida   AND
                                  localizacao.cod-localiz = RowObject.cod-localiz-saida NO-LOCK) THEN DO:
                                {method/svc/errors/inserr.i
                                    &ErrorNumber="15811"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR" 
                                    &ErrorParameters="ws-docto-transf-depos.cod-depos-saida + '~~~~' + ws-docto-transf-depos.cod-estab + '~~~~' + RowObject.cod-localiz-saida"}                                                  
                            END.
                            
                            IF NOT CAN-FIND(FIRST localizacao
                            WHERE localizacao.cod-estabel = ws-docto-transf-depos.cod-estab        AND
                                  localizacao.cod-depos   = ws-docto-transf-depos.cod-depos-entr   AND
                                  localizacao.cod-localiz = RowObject.cod-localiz-entr NO-LOCK) THEN DO:
                                {method/svc/errors/inserr.i
                                    &ErrorNumber="15811"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR" 
                                    &ErrorParameters="ws-docto-transf-depos.cod-depos-entr + '~~~~' + ws-docto-transf-depos.cod-estab + '~~~~' + RowObject.cod-localiz-entr"}                                                  
                            END.
                        END.                 
                    END.                       
                END.
            END.
            FIND FIRST ws-docto-transf-depos
                 WHERE ws-docto-transf-depos.num-docto-transf = RowObject.num-docto-transf NO-LOCK NO-ERROR.
            
            IF AVAIL ws-docto-transf-depos THEN DO:
            
                FIND FIRST deposito WHERE 
                     deposito.cod-depos = ws-docto-transf-depos.cod-depos-saida 
                     NO-LOCK NO-ERROR.

                &IF "{&bf_mat_versao_ems}" >= "2.05" &THEN 
                    IF  deposito.log-gera-wms = YES AND
                &ELSE
                    IF  deposito.log-2        = YES AND
                &ENDIF
                    RowObject.cod-localiz-saida <> "" THEN DO:
                        /* Inicio -- Projeto Internacional */
                        DEFINE VARIABLE c-lbl-liter-campo-localizacao-saida AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "Campo_Localizaá∆o_Sa°da" *}
                        ASSIGN c-lbl-liter-campo-localizacao-saida = TRIM(RETURN-VALUE).
                        DEFINE VARIABLE c-lbl-liter-nulo AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "nulo" *}
                        ASSIGN c-lbl-liter-nulo = TRIM(RETURN-VALUE).
                        DEFINE VARIABLE c-lbl-merge-campo-localizacao-saidanulo AS CHARACTER NO-UNDO.
                        ASSIGN c-lbl-merge-campo-localizacao-saidanulo = c-lbl-liter-campo-localizacao-saida + "~~" + c-lbl-liter-nulo.
                        {method/svc/errors/inserr.i
                            &ErrorNumber="18769"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lbl-merge-campo-localizacao-saidanulo"}
                END.        
                
                FIND FIRST deposito WHERE 
                     deposito.cod-depos = ws-docto-transf-depos.cod-depos-entr  
                     NO-LOCK NO-ERROR.
                &IF "{&bf_mat_versao_ems}" >= "2.05" &THEN 
                    IF  deposito.log-gera-wms = YES AND
                &ELSE
                    IF  deposito.log-2        = YES AND
                &ENDIF
                    RowObject.cod-localiz-entr <> "" THEN DO:
                        /* Inicio -- Projeto Internacional */
                        DEFINE VARIABLE c-lbl-liter-campo-localizacao-entrada AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "Campo_Localizaá∆o_Entrada" *}
                        ASSIGN c-lbl-liter-campo-localizacao-entrada = TRIM(RETURN-VALUE).
                        DEFINE VARIABLE c-lbl-liter-null AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "null" *}
                        ASSIGN c-lbl-liter-null = TRIM(RETURN-VALUE).
                        DEFINE VARIABLE c-lbl-merge-campo-localizacao-entradanull AS CHARACTER NO-UNDO.
                        ASSIGN c-lbl-merge-campo-localizacao-entradanull = c-lbl-liter-campo-localizacao-entrada + "~~" + c-lbl-liter-null.
                        {method/svc/errors/inserr.i
                            &ErrorNumber="18769"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lbl-merge-campo-localizacao-entradanull"}
                END.
            END.        
            IF NOT ws-docto-transf-depos.log-sem-lote
            OR  RowObject.cod-lote <> "" THEN DO:
                IF NOT CAN-FIND(FIRST saldo-estoq NO-LOCK
                                WHERE saldo-estoq.cod-estabel   = ws-docto-transf-depos.cod-estab
                                  AND saldo-estoq.cod-depos     = ws-docto-transf-depos.cod-depos-saida
                                  AND saldo-estoq.cod-localiz   = RowObject.cod-localiz-saida
                                  AND (saldo-estoq.lote         = RowObject.cod-lote OR RowObject.cod-lote = "")      
                                  AND saldo-estoq.it-codigo     = RowObject.cod-item  
                                  AND saldo-estoq.cod-refer     = RowObject.cod-refer)
                THEN DO:
                    {method/svc/errors/inserr.i
                        &ErrorNumber="56"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR" 
                        &ErrorParameters="'Saldo Estoque'"}  
                END.
            END.
        END.
        ELSE DO:
            {method/svc/errors/inserr.i
                &ErrorNumber="6619"
                &ErrorType="EMS"
                &ErrorSubType="ERROR" 
                &ErrorParameters="''"}  
        END.            
    END.

    IF pType = "Delete":U THEN DO:

        EMPTY TEMP-TABLE RowErrors.
        EMPTY TEMP-TABLE RowErrorsAux.
        EMPTY TEMP-TABLE tt-movto.
        EMPTY TEMP-TABLE tt-erro.

        /* n∆o deve permitir excluir um movimento j† integrado com o WMS.
        IF RowObject.idi-sit-docto = 2 THEN DO:
            ASSIGN l-erro = NO.

            FIND FIRST ws-docto-transf-depos
                 WHERE ws-docto-transf-depos.num-docto-transf = RowObject.num-docto-transf NO-LOCK NO-ERROR.

            /* Atualiza o estoque */
            RUN cep/ceapi001k.p PERSISTENT SET h-ceapi001k.
            RUN pi-execute IN h-ceapi001k (INPUT-OUTPUT TABLE tt-movto,
                                           INPUT-OUTPUT TABLE tt-erro,
                                           INPUT YES).
    
            IF  CAN-FIND(FIRST tt-erro) THEN DO:
                FOR EACH tt-erro:
                    RUN pi-create-error (INPUT tt-erro.cd-erro,
                                         INPUT ?,
                                         INPUT tt-erro.mensagem ).
                END.
    
                IF VALID-HANDLE(h-ceapi001k) THEN
                    DELETE PROCEDURE h-ceapi001k.
    
                UNDO, RETURN "NOK":U.
            END.
        END.
        */    
        IF RowObject.idi-sit-docto <> 1
        AND RowObject.idi-sit-docto <> 5 THEN DO:
            IF NOT CAN-FIND (FIRST RowErrors 
                             WHERE RowErrors.ErrorNumber = 16668) THEN DO:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-item-do-documento-5 AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Item_do_Documento" *}
                    ASSIGN c-lbl-liter-item-do-documento-5 = TRIM(RETURN-VALUE).
                    {method/svc/errors/inserr.i
                        &ErrorNumber="16668"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR" 
                        &ErrorParameters="c-lbl-liter-item-do-documento-5"}
            END.
         END.

    END. /* IF pType = "Delete":U THEN DO: */

/*--- Verifica ocorrància de erros ---*/     
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-ref-producao DBOProgram 
PROCEDURE pi-retorna-ref-producao :

    DEFINE INPUT PARAMETER pcCodDeposSaida        AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pcCodDeposEntr         AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pcCodLocalizSai        AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pcDescLocalizSai       AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pcCodLocalizEnt        AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pcDescLocalizEnt       AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pcNomeDeposNaoExterno  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pcRefProducao         AS CHARACTER NO-UNDO.

    DEFINE VARIABLE cCodDeposAux    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cCodLocalizAux  AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cDescLocalizAux AS CHARACTER NO-UNDO.


    IF NOT CAN-FIND(FIRST deposito WHERE deposito.cod-depos = pcCodDeposSaida AND deposito.log-wms-externo = YES) THEN DO:
        ASSIGN cCodDeposAux    = pcCodDeposSaida
               cCodLocalizAux  = pcCodLocalizSai
               cDescLocalizAux = pcDescLocalizSai.
    END.
    ELSE IF NOT CAN-FIND(FIRST deposito WHERE deposito.cod-depos = pcCodDeposEntr AND deposito.log-wms-externo = YES) THEN DO:
        ASSIGN cCodDeposAux    = pcCodDeposEntr
               cCodLocalizAux  = pcCodLocalizEnt
               cDescLocalizAux = pcDescLocalizEnt.
    END.

    ASSIGN pcRefProducao = TRIM(STRING(cCodDeposAux + "-" + pcNomeDeposNaoExterno,"x(29)")) + "|" +
                           TRIM(STRING(cCodLocalizAux + "-" + cDescLocalizAux,"x(30)")).

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
