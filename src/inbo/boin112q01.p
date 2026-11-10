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
{include/i-prgvrs.i BOIN112Q01 2.00.00.008} /*** "010008" 23/11/2023 16:19:43  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin112q01 MUT}
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
&GLOBAL-DEFINE DBOName tt-evento-ped
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions
&scoped-define FIRST-TABLE-IN-QUERY tt-evento-ped
&GLOBAL-DEFINE TableName tt-evento-ped
&GLOBAL-DEFINE TableLabel tt-evento-ped
&GLOBAL-DEFINE QueryName qr{&TableName}

/*********************************************************************************
**  S¢ a DBO principal (boin274.p) est† com as funá‰es de inclui (createRecord), 
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
{include/boini.i}
{inbo/boin112q01.i tt-evento-ped}
{inbo/boin112q01.i RowObject}

/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o
      manual da query ---*/
{method/dboqry.i}


/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/* Include com prÇ-processadores que diferenciam releases */
{cdp/cdcfgmat.i}
/*Definiá∆o temp-table tt-erro*/
{cdp/cd0669.i}
DEFINE VARIABLE c-cod-comprado      AS CHAR NO-UNDO.
DEFINE VARIABLE i-nr-ordem-ini      AS INT NO-UNDO.
DEFINE VARIABLE i-nr-ordem-fim      AS INT NO-UNDO.
DEFINE VARIABLE c-cod-estabel-ini   AS CHAR NO-UNDO.
DEFINE VARIABLE c-cod-estabel-fim   AS CHAR NO-UNDO.
DEFINE VARIABLE d-dt-evento-ini     AS DATE NO-UNDO.
DEFINE VARIABLE d-dt-evento-fim     AS DATE NO-UNDO.
DEFINE VARIABLE c-it-codigo-ini     AS CHAR NO-UNDO.
DEFINE VARIABLE c-it-codigo-fim     AS CHAR NO-UNDO.
DEFINE VARIABLE c-familia-ini       AS CHAR NO-UNDO.
DEFINE VARIABLE c-familia-fim       AS CHAR NO-UNDO.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCopyBuffer2TT DBOProgram 
PROCEDURE afterCopyBuffer2TT :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN RowObject.r-rowid = {&TableName}.r-rowid.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterGetRowid DBOProgram 
PROCEDURE afterGetRowid :
/*------------------------------------------------------------------------------
  Purpose:     Envia rowid do registro corrente da table {&Tablename}
  Parameters:  retorna rowid
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE input-output PARAMETER pRowid  AS ROWID NO-UNDO.

    ASSIGN pRowid = {&TableName}.r-rowid.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeRepositionRecord DBOProgram 
PROCEDURE beforeRepositionRecord :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona query
  Parameters:  recebe rowid da tabela {&TableName}
  Notes:       Atualiza temptable RowObject (_copyBuffer2TT)
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pRowid  AS ROWID NO-UNDO.
    
    FIND {&TableName} WHERE {&TableName}.r-rowid = pRowid NO-LOCK NO-ERROR.
    
    ASSIGN pRowid = ROWID({&TableName}).
    
    /*--- Reposiciona query ---*/
    REPOSITION {&QueryName} TO ROWID pRowid NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        /*--- Erro 11: N∆o foi poss°vel reposicionar a query ---*/
        {method/svc/errors/inserr.i &ErrorNumber="11"
                                    &ErrorType="INTERNAL"
                                    &ErrorSubType="ERROR"}
        
        RETURN "NOK":U.
    END.
    
    /*--- ê necess†rio para o correto funcionamento do reposicionamento ---*/
    GET NEXT {&QueryName} NO-LOCK.
    
    /*--- Seta flag indicando que o registro atual foi reposicionado ---*/
    &if "{&DBType}" = "ORACLE":U &then
        ASSIGN lRepositioned = YES.
    &endif
    
    /*--- Atualiza temptable RowObject ---*/
    RUN _copyBuffer2TT IN THIS-PROCEDURE.
    
    
    RETURN "NOK":U.
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
        &if "{&movind_version}" = "2.01" &then do:
        &endif    
        &if defined(bf_mat_contratos) &then
        &else 
        &endif      
        WHEN "cod-comprado":U THEN ASSIGN pFieldValue = RowObject.cod-comprado.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "des-event":U THEN ASSIGN pFieldValue = RowObject.des-event.
        WHEN "desc-item":U THEN ASSIGN pFieldValue = RowObject.desc-item.
        WHEN "item-narrat":U THEN ASSIGN pFieldValue = RowObject.item-narrat.
        WHEN "narrat-ordem":U THEN ASSIGN pFieldValue = RowObject.narrat-ordem.
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
        &if "{&movind_version}" = "2.01" &then do:
        &endif           
        WHEN "dat-realiz":U THEN ASSIGN pFieldValue = RowObject.dat-realiz.
        WHEN "dt-evento":U THEN ASSIGN pFieldValue = RowObject.dt-evento.
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
        &if "{&movind_version}" = "2.01" &then do:
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
        &if "{&movind_version}" = "2.01" &then do:
        &endif          
        WHEN "numero-ordem":U THEN ASSIGN pFieldValue = RowObject.numero-ordem.
        WHEN "seq-evento":U THEN ASSIGN pFieldValue = RowObject.seq-evento.
        &if defined(bf_mat_contratos) &then
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
  Purpose:     Retorna valores dos campos do °ndice ORD-COMP
  Parameters:
               retorna valor dos campos do °ndice ORD-COMP
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnumero-ordem LIKE evento-ped.numero-ordem NO-UNDO.
    DEFINE OUTPUT PARAMETER pdt-evento LIKE evento-ped.dt-evento NO-UNDO.
    DEFINE OUTPUT PARAMETER pseq-evento LIKE evento-ped.seq-evento NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pnumero-ordem = RowObject.numero-ordem.
    ASSIGN pdt-evento = RowObject.dt-evento.
    ASSIGN pseq-evento = RowObject.seq-evento.

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
    DEFINE OUTPUT PARAMETER pFieldValue AS ROWID NO-UNDO.

    /*--- Verifica se temptable RowObject estˇ dispon≠vel, caso nío esteja serˇ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "r-rowid":U THEN ASSIGN pFieldValue = RowObject.r-rowid.
        WHEN "r-ordem":U THEN ASSIGN pFieldValue = RowObject.r-ordem.
        WHEN "r-evento":U THEN ASSIGN pFieldValue = RowObject.r-evento.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice ORD-COMP
  Parameters:
               recebe valor dos campos do °ndice ORD-COMP
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnumero-ordem LIKE evento-ped.numero-ordem NO-UNDO.
    DEFINE INPUT PARAMETER pdt-evento LIKE evento-ped.dt-evento NO-UNDO.
    DEFINE INPUT PARAMETER pseq-evento LIKE evento-ped.seq-evento NO-UNDO.

    FIND FIRST {&TableName} WHERE
        {&TableName}.numero-ordem = pnumero-ordem AND
        {&TableName}.dt-evento = pdt-evento AND
        {&TableName}.seq-evento = pseq-evento
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE {&TableName} THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID({&TableName})).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraEventosPendenciasComprador DBOProgram 
PROCEDURE geraEventosPendenciasComprador :
/*------------------------------------------------------------------------------
  Purpose:     Gera temp-table customizada para wcc05235.w
  Parameters:  <none>
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cod-comprado      AS CHAR NO-UNDO.
    DEFINE INPUT PARAMETER p-nr-ordem-ini      AS INT NO-UNDO.
    DEFINE INPUT PARAMETER p-nr-ordem-fim      AS INT NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-estabel-ini   AS CHAR NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-estabel-fim   AS CHAR NO-UNDO.
    DEFINE INPUT PARAMETER p-dt-evento-ini     AS DATE NO-UNDO.
    DEFINE INPUT PARAMETER p-dt-evento-fim     AS DATE NO-UNDO.
    DEFINE INPUT PARAMETER p-it-codigo-ini     AS CHAR NO-UNDO.
    DEFINE INPUT PARAMETER p-it-codigo-fim     AS CHAR NO-UNDO.
    DEFINE INPUT PARAMETER p-familia-ini       AS CHAR NO-UNDO.
    DEFINE INPUT PARAMETER p-familia-fim       AS CHAR NO-UNDO.

    DEF VAR i-cont      AS INTEGER NO-UNDO FORMAT "99999".
    DEF VAR c-desc-item AS CHAR    NO-UNDO FORMAT "X(60)".
    
    /* O prÇ-processador abaixa testa a vers∆o do PROGRESS */
    &IF INT (SUBSTRING (PROVERSION, 1, INDEX (PROVERSION, ".") - 1)) >= 9 &THEN          
        EMPTY TEMP-TABLE tt-evento-ped.
    &ELSE
        FOR EACH tt-evento-ped:
            DELETE tt-evento-ped.
        END.
    &ENDIF
    
    FOR EACH evento-ped WHERE
             evento-ped.cod-comprado  = p-cod-comprado    AND
             evento-ped.numero-ordem >= p-nr-ordem-ini    AND
             evento-ped.numero-ordem <= p-nr-ordem-fim    AND
             evento-ped.cod-estabel  >= p-cod-estabel-ini AND
             evento-ped.cod-estabel  <= p-cod-estabel-fim AND
             evento-ped.dt-evento    >= p-dt-evento-ini   AND
             evento-ped.dt-evento    <= p-dt-evento-fim   AND
             evento-ped.it-codigo    >= p-it-codigo-ini   AND
             evento-ped.it-codigo    <= p-it-codigo-fim   AND
             evento-ped.ind-sit-event = 1                 NO-LOCK,
       FIRST ordem-compra WHERE
             ordem-compra.numero-ordem = evento-ped.numero-ordem NO-LOCK,
       FIRST item WHERE
             item.it-codigo = evento-ped.it-codigo AND
             item.fm-codigo           >= p-familia-ini     AND
             item.fm-codigo           <= p-familia-fim     NO-LOCK
             BY evento-ped.numero-ordem
             BY evento-ped.dt-evento
             BY evento-ped.seq-evento.

        ASSIGN i-cont = i-cont + 1.

        CREATE tt-evento-ped.
        ASSIGN tt-evento-ped.numero-ordem = evento-ped.numero-ordem
               tt-evento-ped.seq-evento   = evento-ped.seq-evento
               tt-evento-ped.cod-estabel  = evento-ped.cod-estabel
               tt-evento-ped.des-event    = evento-ped.des-event
               tt-evento-ped.it-codigo    = evento-ped.it-codigo
               tt-evento-ped.dat-realiz   = evento-ped.dat-realiz
               tt-evento-ped.item-narrat  = item.narrativa
               tt-evento-ped.narrat-ordem = ordem-compra.narrativa
               tt-evento-ped.r-evento     = ROWID(evento-ped)
               tt-evento-ped.r-rowid      = TO-ROWID("0x0" + STRING(i-cont,"99999"))
               tt-evento-ped.r-ordem      = ROWID(ordem-compra).
                    
        IF item.it-codigo  = "" AND
           item.tipo-contr = 4 THEN DO:
            IF AVAIL ordem-compra THEN
                ASSIGN tt-evento-ped.desc-item = SUBSTR(ordem-compra.narrativa,1,60).
        END.
        ELSE
            ASSIGN tt-evento-ped.desc-item = item.desc-item.
    END.            
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraEventosPendenciasComprador1 DBOProgram 
PROCEDURE geraEventosPendenciasComprador1 :
/*------------------------------------------------------------------------------
  Purpose:     Gera temp-table customizada para wcc05235.w
  Parameters:  <none>
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cod-comprado      AS CHAR NO-UNDO.
    DEFINE INPUT PARAMETER p-nr-ordem-ini      AS INT  NO-UNDO.
    DEFINE INPUT PARAMETER p-nr-ordem-fim      AS INT  NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-estabel-ini   AS CHAR NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-estabel-fim   AS CHAR NO-UNDO.
    DEFINE INPUT PARAMETER p-dt-evento-ini     AS DATE NO-UNDO.
    DEFINE INPUT PARAMETER p-dt-evento-fim     AS DATE NO-UNDO.
    DEFINE INPUT PARAMETER p-it-codigo-ini     AS CHAR NO-UNDO.
    DEFINE INPUT PARAMETER p-it-codigo-fim     AS CHAR NO-UNDO.
    DEFINE INPUT PARAMETER p-familia-ini       AS CHAR NO-UNDO.
    DEFINE INPUT PARAMETER p-familia-fim       AS CHAR NO-UNDO.
    DEF INPUT PARAM p-navigation AS CHAR NO-UNDO.
    DEF INPUT PARAM p-max-return AS INT  NO-UNDO.
    DEF INPUT-OUTPUT PARAM p-first-displayed AS ROWID NO-UNDO.
    DEF INPUT-OUTPUT PARAM p-last-displayed  AS ROWID NO-UNDO.

    DEF VAR i-cont      AS INTEGER NO-UNDO FORMAT "99999".
    DEF VAR c-desc-item AS CHAR    NO-UNDO FORMAT "X(60)".
    
    /* O prÇ-processador abaixo testa a vers∆o do PROGRESS */
    &IF INT (SUBSTRING (PROVERSION, 1, INDEX (PROVERSION, ".") - 1)) >= 9 &THEN          
        EMPTY TEMP-TABLE tt-evento-ped.
    &ELSE
        FOR EACH tt-evento-ped:
            DELETE tt-evento-ped.
        END.
    &ENDIF

    DEF QUERY q-event FOR evento-ped, ordem-compra, ITEM SCROLLING.

    OPEN QUERY q-event 
        FOR EACH  evento-ped
            WHERE evento-ped.cod-comprado  = p-cod-comprado    
              AND evento-ped.numero-ordem >= p-nr-ordem-ini    
              AND evento-ped.numero-ordem <= p-nr-ordem-fim    
              AND evento-ped.cod-estabel  >= p-cod-estabel-ini 
              AND evento-ped.cod-estabel  <= p-cod-estabel-fim 
              AND evento-ped.dt-evento    >= p-dt-evento-ini   
              AND evento-ped.dt-evento    <= p-dt-evento-fim   
              AND evento-ped.it-codigo    >= p-it-codigo-ini   
              AND evento-ped.it-codigo    <= p-it-codigo-fim   
              AND evento-ped.ind-sit-event = 1 NO-LOCK,
        FIRST ordem-compra 
        WHERE ordem-compra.numero-ordem = evento-ped.numero-ordem NO-LOCK,
        FIRST item 
        WHERE item.it-codigo =  evento-ped.it-codigo 
          AND item.fm-codigo >= p-familia-ini     
          AND item.fm-codigo <= p-familia-fim NO-LOCK
        BY evento-ped.numero-ordem
        BY evento-ped.dt-evento
        BY evento-ped.seq-evento
        &IF int (substring (proversion, 1, index (proversion, ".") - 1)) >= 9 &THEN
        INDEXED-REPOSITION
        &ENDIF
        .

    /* Se o primeiro e o £ltimo registros do browse forem desconhecidos
       comeáa a criar a temp-table a partir do primeiro da query */
    IF  p-last-displayed = ? 
    AND p-first-displayed = ? THEN 
        GET FIRST q-event.
    ELSE DO:
        /* Sen∆o, comeáa a partir do pr¢ximo/anterior (cfme parÉm recebido) */
        IF  p-navigation = "Prev":U THEN DO:
            REPOSITION q-event TO ROWID p-first-displayed NO-ERROR.
            GET PREV q-event.
        END.
        ELSE DO:
            REPOSITION q-event TO ROWID p-last-displayed NO-ERROR.
            GET NEXT q-event.
        END.
    END.

    /* Entra no bloco de repetiá∆o atÇ que seja criado nr. m†ximo de
       registros a serem mostrados, ou atÇ que a tabela 'evento-ped' n∆o 
       esteja mais dispon°vel */
    IF  AVAIL evento-ped THEN
    DO  WHILE i-cont < p-max-return:

        ASSIGN i-cont = i-cont + 1.

        CREATE tt-evento-ped.
        ASSIGN tt-evento-ped.numero-ordem = evento-ped.numero-ordem
               tt-evento-ped.seq-evento   = evento-ped.seq-evento
               tt-evento-ped.cod-estabel  = evento-ped.cod-estabel
               tt-evento-ped.des-event    = evento-ped.des-event
               tt-evento-ped.it-codigo    = evento-ped.it-codigo
               tt-evento-ped.dat-realiz   = evento-ped.dat-realiz
               tt-evento-ped.item-narrat  = item.narrativa
               tt-evento-ped.narrat-ordem = ordem-compra.narrativa
               tt-evento-ped.r-evento     = ROWID(evento-ped)
               tt-evento-ped.r-rowid      = TO-ROWID("0x0" + STRING(i-cont,"99999"))
               tt-evento-ped.r-ordem      = ROWID(ordem-compra).

        IF  item.it-codigo  = "" 
        AND item.tipo-contr = 4
        AND AVAIL ordem-compra THEN
            ASSIGN tt-evento-ped.desc-item = SUBSTR(ordem-compra.narrativa,1,60).
        ELSE
            ASSIGN tt-evento-ped.desc-item = item.desc-item.

        IF  p-navigation = "Prev":U THEN
            GET PREV q-event.
        ELSE
            GET NEXT q-event.

        IF NOT AVAIL evento-ped THEN LEAVE.
    END.

    /* Carrega as vari†veis 'p-first-displayed' e 'p-last-displayed' que definir∆o
       se ser∆o mostrados os bot‰es de pr¢x e anterior, na navegaá∆o do browse */
    IF  CAN-FIND(FIRST tt-evento-ped) THEN DO:
        RUN openQueryStatic IN THIS-PROCEDURE ("Main":U).

        RUN getFirst IN THIS-PROCEDURE.
        IF  AVAIL {&tableName} THEN DO:
            GET FIRST q-event.
            /* Se o primeiro registro da temp-table for igual ao primeiro da base, 
               ent∆o n∆o deve ser mostrado o bot∆o de anterior na tela */
            IF  AVAIL evento-ped 
            AND {&tableName}.r-evento = ROWID(evento-ped) THEN
                ASSIGN p-first-displayed = ?.
            ELSE
                /* Sen∆o armazena o rowid do primeiro registro do browse */
                ASSIGN p-first-displayed = {&tableName}.r-evento.
        END.
        
        RUN getLast IN THIS-PROCEDURE.
        IF  AVAIL {&tableName} THEN DO:
            GET LAST q-event.
            /* Se o £ltimo registro da temp-table for igual ao £ltimo da base, 
               ent∆o n∆o deve ser mostrado o bot∆o de pr¢ximo na tela */
            IF  AVAIL evento-ped 
            AND {&tableName}.r-evento = ROWID(evento-ped) THEN
                ASSIGN p-last-displayed = ?.
            ELSE
                /* Sen∆o armazena o rowid do primeiro registro do browse */
                ASSIGN p-last-displayed = {&tableName}.r-evento.
        END.
    END.
    ELSE
        ASSIGN p-first-displayed = ?
               p-last-displayed  = ?.

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
    OPEN QUERY {&QueryName} FOR EACH tt-evento-ped 
         NO-LOCK 
         BY {&tableName}.numero-ordem
        &IF int (substring (proversion, 1, index (proversion, ".") - 1)) >= 9 &THEN
        INDEXED-REPOSITION
        &ENDIF
        .

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-status-fornec DBOProgram 
PROCEDURE pi-valida-status-fornec :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&IF defined(bf_mat_bloqueio_fornec) &THEN

   def input parameter p-r-rowid    as rowid no-undo.

   def var i-emitente  as int   no-undo.
   def var i-situacao  as int   no-undo.
   def var dt-vig-ini  as date  no-undo.
   def var dt-vig-fim  as date  no-undo.
   def var c-return    as char  no-undo. 

   find FIRST evento-ped 
        where rowid(evento-ped) = p-r-rowid no-lock no-error.
   find FIRST ordem-compra 
        where ordem-compra.numero-ordem = evento-ped.numero-ordem no-lock no-error.
   if avail ordem-compra then do:
       if ordem-compra.cod-emitente <> 0 then
          assign i-emitente = ordem-compra.cod-emitente.
       else do:
           find FIRST contrato-for 
                where contrato-for.nr-contrato = ordem-compra.nr-contrato no-lock no-error.
           if avail contrato-for then
               assign i-emitente = contrato-for.cod-emitente.
       end.

       IF i-emitente <> 0 THEN DO:
           run cdp/cdapi029.p (input ordem-compra.cod-comprado,
                               input 1,
                               input today,
                               input i-emitente,
                               output i-situacao,
                               output dt-vig-ini,
                               output dt-vig-fim,
                               output table tt-erro).
           assign c-return = return-value.

           if can-find(first tt-erro) then
              for each tt-erro:
                  assign i-seq-erro = i-seq-erro + 1.
                  create RowErrors.
                  assign RowErrors.ErrorSequence = i-seq-erro
                         RowErrors.ErrorNumber = tt-erro.cd-erro
                         RowErrors.ErrorParameters = ""
                         RowErrors.ErrorType = ""
                         RowErrors.ErrorSubType = if c-return = "NOK":u then "ERROR":u else "WARNING":u
                         RowErrors.ErrorDescription = tt-erro.mensagem
                         RowErrors.ErrorHelp = tt-erro.mensagem.
              end.       
           return c-return.

       END.
   end.
   else 
      return "NOK":u.
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

