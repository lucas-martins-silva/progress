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
{include/i-prgvrs.i BOIN657FX 2.00.00.006} /*** "010006" 24/06/2025 16:40:02 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin657fx MUT}
&ENDIF
/*:T--------------------------------------------------------------------------
    File       : BOIN657FX.P
    Purpose    : Cont‚m a l¢gica de neg¢cio e acesso a dados para a tabela unid-neg-ordem
    Parameters : 
    Notes      : 
--------------------------------------------------------------------------*/


/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName BOIN657
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName unid-neg-ordem
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

/*:T--- Include com defini‡Æo da temptable RowObject ---*/
{inbo/boin657fx.i RowObject}


/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
{method/dboqry.i}


/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/* Valida‡äes Unidade de Neg¢cio */
def temp-table tt-erro-aux no-undo
    field i-sequen as int              
    field cd-erro  as int
    field mensagem as char format "x(255)".

def var i-NumeroOrdem  like ordem-compra.numero-ordem   no-undo.

def var hboMngr        as handle                        no-undo.
def var h-cdapi024     as handle                        no-undo. /* Unidade Neg¢cio */

{inbo/boin274.i tt-ordem-compra}

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
         HEIGHT             = 17.67
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram 
PROCEDURE afterCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND FIRST ordem-compra
         WHERE ordem-compra.numero-ordem = RowObject.numero-ordem EXCLUSIVE-LOCK NO-ERROR.
    
    IF AVAIL ordem-compra AND ordem-compra.cod-unid-negoc <> "" THEN
        ASSIGN ordem-compra.cod-unid-negoc = "".

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE emptyTtOrdemCompra DBOProgram 
PROCEDURE emptyTtOrdemCompra :
/*------------------------------------------------------------------------------
  Purpose:     Eliminar todos os registros da tt-ordem-compra utilizada na BO 
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    EMPTY TEMP-TABLE tt-ordem-compra.

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

    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "char-1":U         THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U         THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U      THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod_unid_negoc":U THEN ASSIGN pFieldValue = RowObject.cod_unid_negoc.
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
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.

    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dec-1":U           THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U           THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "perc-unid-neg":U   THEN ASSIGN pFieldValue = RowObject.perc-unid-neg.
        WHEN "qtd-unid-neg":U    THEN ASSIGN pFieldValue = RowObject.qtd-unid-neg.
        WHEN "val-unid-neg[1]":U THEN ASSIGN pFieldValue = RowObject.val-unid-neg[1].
        WHEN "val-unid-neg[2]":U THEN ASSIGN pFieldValue = RowObject.val-unid-neg[2].
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

    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "int-1":U        THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U        THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "numero-ordem":U THEN ASSIGN pFieldValue = RowObject.numero-ordem.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice ordem
  Parameters:  
               retorna valor do campo numero-ordem
               retorna valor do campo cod_unid_negoc
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnumero-ordem LIKE unid-neg-ordem.numero-ordem NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod_unid_negoc LIKE unid-neg-ordem.cod_unid_negoc NO-UNDO.

    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnumero-ordem   = RowObject.numero-ordem
           pcod_unid_negoc = RowObject.cod_unid_negoc.

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

    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
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
  Purpose:     Reposiciona registro com base no ¡ndice ordem
  Parameters:  
               recebe valor do campo numero-ordem
               recebe valor do campo cod_unid_negoc
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnumero-ordem LIKE unid-neg-ordem.numero-ordem NO-UNDO.
    DEFINE INPUT PARAMETER pcod_unid_negoc LIKE unid-neg-ordem.cod_unid_negoc NO-UNDO.

    FIND FIRST bfunid-neg-ordem 
         WHERE bfunid-neg-ordem.numero-ordem = pnumero-ordem
           AND bfunid-neg-ordem.cod_unid_negoc = pcod_unid_negoc NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfunid-neg-ordem THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfunid-neg-ordem)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryBusUnitOfRequisition DBOProgram 
PROCEDURE openQueryBusUnitOfRequisition :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName}
        FOR EACH unid-neg-ordem
           WHERE unid-neg-ordem.numero-ordem = i-NumeroOrdem NO-LOCK INDEXED-REPOSITION.

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

    OPEN QUERY {&QueryName} FOR EACH unid-neg-ordem NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetConstraintBusUnitOfRequisition DBOProgram 
PROCEDURE SetConstraintBusUnitOfRequisition :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pNumeroOrdem LIKE unid-neg-ordem.numero-ordem NO-UNDO.

    ASSIGN i-NumeroOrdem = pNumeroOrdem.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetPurchaseRequisition DBOProgram 
PROCEDURE SetPurchaseRequisition :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM TABLE FOR tt-ordem-compra.

    FIND FIRST tt-ordem-compra NO-ERROR.

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
    
    DEFINE VARIABLE l-ordem-requis          AS LOGICAL NO-UNDO.
    DEFINE VARIABLE l-permite-unid-negocio  AS LOGICAL NO-UNDO.
    DEFINE VARIABLE h-bofr134               AS HANDLE  NO-UNDO.

    FIND FIRST tt-ordem-compra NO-ERROR.

    IF NOT AVAIL tt-ordem-compra THEN DO:

        {cdp/findordemcompra.i RowObject.numero-ordem}

        IF NOT AVAIL ordem-compra THEN DO:
            {utp/ut-table.i movind ordem-compra 1}
            {method/svc/errors/inserr.i &ErrorNumber="56"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="return-value"}
            RETURN "NOK":U.
        END.

        /*-- necessario devido a validacao pedido emergencial, nao permite 
             incluir ordens sem unidade de negocio --*/
        CREATE tt-ordem-compra.
        BUFFER-COPY ordem-compra TO tt-ordem-compra.
    END.

    IF pType = "Create":U THEN DO:
        
        IF NOT CAN-FIND(FIRST unid-negoc
                        WHERE unid-negoc.cod-unid-negoc = RowObject.cod_unid_negoc) then do:
            {utp/ut-table.i mgind unid-negoc 1}
            {method/svc/errors/inserr.i &ErrorNumber="56"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="return-value"}
            RETURN "NOK":U.
        END.
        
        IF CAN-FIND(FIRST unid-neg-ordem
                    WHERE unid-neg-ordem.numero-ordem   = RowObject.numero-ordem
                      AND unid-neg-ordem.cod_unid_negoc = RowObject.cod_unid_negoc) THEN DO:
            {utp/ut-table.i movind unid-neg-ordem 1}
            {method/svc/errors/inserr.i &ErrorNumber="1"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="return-value"}
            RETURN "NOK":U.
        END.

        ASSIGN l-ordem-requis         = NO
               l-permite-unid-negocio = NO.

        IF tt-ordem-compra.ordem-servic <> 0 THEN DO:

            IF CAN-FIND(FIRST unid-negoc-om 
                        WHERE unid-negoc-om.num-ord-manut = tt-ordem-compra.ordem-servic) THEN
                ASSIGN l-ordem-requis = YES.
        
            IF l-ordem-requis = NO THEN DO:

                RUN cdp/cd9902.p (INPUT 3).

                IF RETURN-VALUE = "OK":U THEN DO:
    
                    IF NOT VALID-HANDLE(h-bofr134) THEN
                        RUN frbo/bofr134.p PERSISTENT SET h-bofr134.
        
                    RUN canFindMatrizMMV IN h-bofr134 (INPUT tt-ordem-compra.ordem-servic).
        
                    IF RETURN-VALUE = "OK":U THEN
                        ASSIGN l-ordem-requis = YES.
        
                    DELETE OBJECT h-bofr134.
                END.
            END.
                    
            FOR FIRST ord-prod NO-LOCK
                WHERE ord-prod.nr-ord-produ = tt-ordem-compra.ordem-servic:
            END.
        END.

        FOR FIRST item
            WHERE item.it-codigo = tt-ordem-compra.it-codigo NO-LOCK:

            /* Validacao realizada para habilitar o botao de unidade de negocio no cc0301 */
            IF (    (tt-ordem-compra.situacao = 1 OR tt-ordem-compra.situacao = 5)                                     /* 1 - NÆo Confirmada, 5 - Em Cota‡Æo */
                AND (   (tt-ordem-compra.ordem-servic  = 0 AND (item.tipo-contr = 4 OR  item.tipo-contr = 1))          /* 4 - Fisico, 1 - Debito Direto */
                     OR (tt-ordem-compra.ordem-servic  = 0 AND  item.tipo-contr = 2)                                   /* 2 - Total, tem que ter conta */
                     OR (tt-ordem-compra.ordem-servic <> 0 AND l-ordem-requis AND AVAIL ord-prod AND (ord-prod.origem = "MI":U OR ord-prod.origem = "MV":U))
                    )
               ) THEN 
                ASSIGN l-permite-unid-negocio = YES.
            ELSE DO:
                /* Validacao realizada para habilitar o botao de unidade de negocio no cc0300 */
                IF   tt-ordem-compra.ordem-servic = 0 
                AND (tt-ordem-compra.situacao = 2 OR tt-ordem-compra.situacao = 4 OR tt-ordem-compra.situacao = 6) /* 2 - Confirmada, 4 - Eliminada, 6 - Recebida */
                AND ((item.tipo-contr = 1 OR item.tipo-contr = 4) OR (item.tipo-contr = 2)) THEN
                    ASSIGN l-permite-unid-negocio = YES.
            END.

            //validacao html.cc0301
            IF NOT ((tt-ordem-compra.ordem-servic = 0  AND (item.tipo-contr = 4 or item.tipo-contr = 1)) OR 
                    (tt-ordem-compra.ct-codigo   <> "" AND       
                     item.tipo-contr              = 2  AND       
                     tt-ordem-compra.ordem-servic = 0)) THEN ASSIGN l-permite-unid-negocio = YES.

            IF NOT l-permite-unid-negocio THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber="57191"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="tt-ordem-compra.numero-ordem"}
                RETURN "NOK":U.
            END.
        END.
    END.

    IF pType = "Create":U
    OR pType = "Update":U THEN DO:

        IF RowObject.perc-unid-neg <= 0
        OR RowObject.perc-unid-neg > 100 THEN DO:
            {utp/ut-table.i mgind unid-negoc 1}
            {method/svc/errors/inserr.i &ErrorNumber="5376"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="return-value"}
            RETURN "NOK":U.
        END.

        IF NOT VALID-HANDLE(h-cdapi024) THEN
            RUN cdp/cdapi024.p PERSISTENT SET h-cdapi024.
    
        EMPTY TEMP-TABLE tt-erro-aux.
    
        RUN ValidaUnidadeNegocioEstabel IN h-cdapi024 (INPUT tt-ordem-compra.cod-estabel,
                                                       INPUT tt-ordem-compra.data-emissao,
                                                       INPUT RowObject.cod_unid_negoc, 
                                                       OUTPUT TABLE tt-erro-aux).
        
        RUN ValidaUnidadeNegocioUsuario IN h-cdapi024 (INPUT tt-ordem-compra.requisitante,
                                                       INPUT RowObject.cod_unid_negoc, 
                                                       OUTPUT TABLE tt-erro-aux APPEND).
    
        IF VALID-HANDLE(h-cdapi024) THEN DO:
            DELETE PROCEDURE h-cdapi024.
            ASSIGN h-cdapi024 = ?.
        END.
        
        FOR EACH tt-erro-aux:
            RUN _insertErrorManual (INPUT tt-erro-aux.cd-erro,
                                    INPUT "EMS":U,
                                    INPUT "ERROR":U,
                                    INPUT tt-erro-aux.mensagem,
                                    INPUT "",
                                    INPUT "").
        END.
    END.

    FOR EACH RowErrors WHERE RowErrors.ErrorNumber = 8 or RowErrors.ErrorNumber = 3: 
		DELETE RowErrors.
    END.

    /*:T--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

