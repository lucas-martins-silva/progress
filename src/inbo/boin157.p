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
{include/i-prgvrs.i BOIN157 2.00.00.034 } /*** "010034" 01/12/2023 10:51:00  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN157 MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : boin157.p
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
&GLOBAL-DEFINE DBOName inventario
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName inventario
&GLOBAL-DEFINE TableLabel inventario
&GLOBAL-DEFINE QueryName qr{&TableName}

/*--- Include com defini‡Æo da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com
      extensÆo .i ---*/
{inbo/boin157.i RowObject}
{inbo/boin157.i tt-invent-aux}
/******************************************************************************************
** TECNICA SEGURANCA ESTABELECIMENTO
******************************************************************************************/ 
{cdp/cd0031.i "MCE"} /* Seguranca por Estabelecimento */
/******************************************************************************************
** TECNICA SEGURANCA ESTABELECIMENTO
******************************************************************************************/

/*--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo
      manual da query ---*/
{method/dboqry.i}

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

define temp-table tt-ficha-controle no-undo
field nr-ficha  as integer
field sequencia as integer.

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

DEFINE VARIABLE da-dt-saldo       AS DATE      NO-UNDO.
DEFINE VARIABLE da-dt-saldo-ini   AS DATE      NO-UNDO.
DEFINE VARIABLE da-dt-saldo-fim   AS DATE      NO-UNDO.
DEFINE VARIABLE i-cdn-agrup-ini   AS INTEGER   NO-UNDO.
DEFINE VARIABLE i-cdn-agrup-fim   AS INTEGER   NO-UNDO.
DEFINE VARIABLE c-descricao-ini   AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-descricao-fim   AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-it-codigo-ini   AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-it-codigo-fim   AS CHARACTER NO-UNDO.
DEFINE VARIABLE rw-rowid          AS ROWID     NO-UNDO.

DEFINE VARIABLE l-achou           AS LOGICAL INIT NO  NO-UNDO.
DEFINE VARIABLE l-agrupou         AS LOGICAL INIT NO  NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getNextDtSaldo DBOProgram
PROCEDURE getNextDtSaldo :
/*------------------------------------------------------------------------------
  Purpose:    Utilizado pelo programa ce0712.w para navegacao por dt-saldo.
  Parameters:  
  Notes:      
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAM pr-rowid    AS ROWID.
    DEFINE OUTPUT PARAM p-ultimo    AS LOGICAL NO-UNDO.
    DEFINE VARIABLE rw-rowid AS ROWID NO-UNDO.        
                  
    /* Executa somente para procedure findRecords */
    IF AVAIL {&TableName} THEN DO:         
        /* Vai para proximo registro no buffer */
        FOR EACH bf{&TableName} fields (dt-saldo cdn-agrup nr-ficha) NO-LOCK
            where bf{&TableName}.dt-saldo >= {&TableName}.dt-saldo              
             break by bf{&TableName}.dt-saldo
             by bf{&TableName}.cdn-agrup
             by bf{&TableName}.nr-ficha:
                            
            IF l-agrupou THEN do:
                RUN repositionRecord IN THIS-PROCEDURE (INPUT (ROWID(bf{&TableName}))).
                ASSIGN pr-rowid   = ROWID(bf{&TableName})
                       l-agrupou  = no
                       l-achou    = no
                       p-ultimo = IF can-find (first inventario where inventario.dt-saldo  > (bf{&TableName}.dt-saldo)
                                                                  or  inventario.dt-saldo  = (bf{&TableName}.dt-saldo)
                                                                  and inventario.cdn-agrup > (bf{&TableName}.cdn-agrup)) THEN YES
                                  ELSE NO.      
                LEAVE.       
            end.
            
            IF  bf{&TableName}.dt-saldo  = {&TableName}.dt-saldo
            AND bf{&TableName}.cdn-agrup = {&TableName}.cdn-agrup
            AND bf{&TableName}.nr-ficha  = {&TableName}.nr-ficha THEN DO:
                ASSIGN l-achou = YES.
            END.
            IF LAST-OF (bf{&TableName}.cdn-agrup) AND l-achou THEN do:
                assign l-agrupou = yes.
            end.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getNextDtSaldo DBOProgram
PROCEDURE getFirstDtSaldo :
/*------------------------------------------------------------------------------
  Purpose:    Utilizado pelo programa ce0712.w para navegacao por dt-saldo.
  Parameters:  
  Notes:      
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAM pr-rowid    AS ROWID.
    DEFINE OUTPUT PARAM p-primeiro  AS LOGICAL NO-UNDO.
    DEFINE VARIABLE rw-rowid AS ROWID NO-UNDO.        
                  
    /* Executa somente para procedure findRecords */
    IF AVAIL {&TableName} THEN DO:         
        /* Vai para primeiro registro no buffer */
        FOR FIRST bf{&TableName} fields (dt-saldo cdn-agrup nr-ficha) NO-LOCK
            break by bf{&TableName}.dt-saldo
             by bf{&TableName}.cdn-agrup
             by bf{&TableName}.nr-ficha:
            
            RUN repositionRecord IN THIS-PROCEDURE (INPUT (ROWID(bf{&TableName}))).
            ASSIGN pr-rowid  = ROWID(bf{&TableName}).

        END.
    END. 
    ASSIGN p-primeiro = no.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getNextDtSaldo DBOProgram
PROCEDURE getLastDtSaldo :
/*------------------------------------------------------------------------------
  Purpose:    Utilizado pelo programa ce0712.w para navegacao por dt-saldo.
  Parameters:  
  Notes:      
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAM pr-rowid    AS ROWID.
    DEFINE OUTPUT PARAM p-ultimo    AS LOGICAL NO-UNDO.
    DEFINE VARIABLE rw-rowid AS ROWID NO-UNDO.        
                  
    /* Executa somente para procedure findRecords */
    IF AVAIL {&TableName} THEN DO:         
        /* Vai para ultimo registro no buffer */
        FOR LAST bf{&TableName} fields (dt-saldo cdn-agrup nr-ficha) NO-LOCK
             break by bf{&TableName}.dt-saldo
             by bf{&TableName}.cdn-agrup
             by bf{&TableName}.nr-ficha:
                            
                RUN repositionRecord IN THIS-PROCEDURE (INPUT (ROWID(bf{&TableName}))).
                ASSIGN pr-rowid  = ROWID(bf{&TableName}).

        END.
    END. 
    ASSIGN p-ultimo = no.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getPrevDtSaldo DBOProgram
PROCEDURE getPrevDtSaldo :
/*------------------------------------------------------------------------------
  Purpose:    Utilizado pelo programa ce0712.w para navegacao por dt-saldo.
  Parameters:  
  Notes:      
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAM pr-rowid AS ROWID.
    DEFINE OUTPUT PARAM p-primeiro  AS LOGICAL NO-UNDO.
    DEFINE VARIABLE rw-rowid AS ROWID NO-UNDO.        
                  
    /* Executa somente para procedure findRecords */
    IF AVAIL {&TableName} THEN DO: 
        FOR EACH bf{&TableName} fields (dt-saldo cdn-agrup nr-ficha) NO-LOCK
            where bf{&TableName}.dt-saldo <= {&TableName}.dt-saldo              
             break by bf{&TableName}.dt-saldo DESC
             by bf{&TableName}.cdn-agrup DESC
             by bf{&TableName}.nr-ficha DESC:
                            
            IF l-agrupou THEN do:
                RUN repositionRecord IN THIS-PROCEDURE (INPUT (ROWID(bf{&TableName}))).
                ASSIGN pr-rowid   = ROWID(bf{&TableName})
                       l-agrupou  = no
                       l-achou    = no
                       p-primeiro = IF can-find (first inventario where inventario.dt-saldo  < (bf{&TableName}.dt-saldo) 
                                                                  OR    inventario.dt-saldo  = (bf{&TableName}.dt-saldo)
                                                                  and   inventario.cdn-agrup < (bf{&TableName}.cdn-agrup)) THEN YES
                                    ELSE NO.  
                LEAVE.       
            end.
            
            IF  bf{&TableName}.dt-saldo  = {&TableName}.dt-saldo
            AND bf{&TableName}.cdn-agrup = {&TableName}.cdn-agrup
            AND bf{&TableName}.nr-ficha  = {&TableName}.nr-ficha THEN DO:
                ASSIGN l-achou = YES.
            END.
            IF LAST-OF (bf{&TableName}.cdn-agrup) AND l-achou THEN do:
                assign l-agrupou = yes.
            end.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterGetNext DBOProgram
PROCEDURE afterGetNext :
/*------------------------------------------------------------------------------
  Purpose:    Utilizado pelo programa wce0712.w (web) para navegacao por dt-saldo.
  Parameters:  
  Notes:      Posiciona sempre no primeiro registro da data (dt-saldo).
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-programa  AS CHARACTER FORMAT "X(40)" NO-UNDO.
    DEFINE VARIABLE rw-rowid    AS ROWID                    NO-UNDO.        

    /* Grava nome da procedure que chamou afterGetNext */
    ASSIGN c-programa = PROGRAM-NAME(3).

    /* Executa somente para procedure findRecords */
    IF ENTRY(1,c-programa,"") = "findRecords"     
    AND AVAIL {&TableName} THEN DO: 

        FIND LAST bf{&TableName} NO-LOCK NO-ERROR.
        ASSIGN rw-rowid    = ROWID(bf{&TableName})
               da-dt-saldo = bf{&TableName}.dt-saldo. /* Data do ultimo registro da tabela */
               
        /* Se da-dt-saldo do registro atual for igual … dt-saldo do £ltimo registro da tabela, return OK */
        IF {&TableName}.dt-saldo = da-dt-saldo THEN DO:
            RUN repositionRecord IN THIS-PROCEDURE (INPUT rw-rowid).
            RETURN "OK":U.
        END.
        ELSE DO:
            /* Posiciona no registro anterior na tabela */
            GET PREV qr{&TableName} NO-LOCK.
            ASSIGN rw-rowid = RowObject.r-rowid.        
        END.

        /* Se o registro anterior for igual ao registro atual (RowObject), entao deve executar next */
        IF {&TableName}.dt-saldo = RowObject.dt-saldo THEN DO:
        
            /* Reposiciona buffer no registro corrente */
            FIND bf{&TableName} WHERE
                 ROWID(bf{&TableName}) = rw-rowid NO-LOCK NO-ERROR.
    
            /* Vai para proximo registro no buffer */
            FIND NEXT bf{&TableName} WHERE 
                 bf{&TableName}.dt-saldo > RowObject.dt-saldo NO-LOCK NO-ERROR.

            /* Vai para o £ltimo registro no buffer se a data for igual */
            IF bf{&TableName}.dt-saldo = da-dt-saldo THEN
                FIND LAST bf{&TableName} NO-LOCK NO-ERROR.
                        
            IF AVAIL bf{&TableName} THEN
                RUN repositionRecord IN THIS-PROCEDURE (INPUT (ROWID(bf{&TableName}))).
        END.
    END.
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterGetPrev DBOProgram
PROCEDURE afterGetPrev :
/*------------------------------------------------------------------------------
  Purpose:    Utilizado pelo programa wce0712.w (web) para navegacao por dt-saldo.
  Parameters:  
  Notes:      Posiciona sempre no primeiro registro da data (dt-saldo).
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-programa  AS CHARACTER FORMAT "X(40)" NO-UNDO.
    DEFINE VARIABLE rw-rowid    AS ROWID                    NO-UNDO.        

    /* Grava nome da procedure que chamou afterGetNext */
    ASSIGN c-programa = PROGRAM-NAME(3).

    /* Executa somente para procedure findRecords */
    IF ENTRY(1,c-programa,"") = "findRecords"     
    AND AVAIL {&TableName} THEN DO: 

        /* Recupera rowid e dt-saldo do £ltimo registro no buffer */
        FIND FIRST bf{&TableName} NO-LOCK NO-ERROR.
        ASSIGN rw-rowid    = ROWID(bf{&TableName})
               da-dt-saldo = bf{&TableName}.dt-saldo. 
               
        /* Se dt-saldo do registro atual for igual … dt-saldo do £ltimo registro da tabela, return OK */
        IF {&TableName}.dt-saldo = da-dt-saldo THEN DO:
            RUN repositionRecord IN THIS-PROCEDURE (INPUT rw-rowid).
            RETURN "OK":U.
        END.
        ELSE DO:
            /* Posiciona no pr¢ximo registro na tabela, e grava rowid da temp-table */
            GET NEXT qr{&TableName} NO-LOCK.
            ASSIGN rw-rowid = RowObject.r-rowid.        
        END.

        /* Se o pr¢ximo registro da tabela for igual ao registro atual na temp-table (RowObject), */
        /* entao deve executar prev */
        IF {&TableName}.dt-saldo = RowObject.dt-saldo THEN DO:
        
            /* Reposiciona buffer no registro corrente atrav‚s do rowid recuperado da temp-table */
            FIND bf{&TableName} WHERE
                 ROWID(bf{&TableName}) = rw-rowid NO-LOCK NO-ERROR.
    
            /* Vai para o registro anterior no buffer com data menor que a data da temp-table */
            FIND PREV bf{&TableName} WHERE 
                 bf{&TableName}.dt-saldo < RowObject.dt-saldo NO-LOCK NO-ERROR.

            /* Se a data do buffer for igual a data do primeiro registro na base executa find first */
            IF bf{&TableName}.dt-saldo = da-dt-saldo THEN
                FIND FIRST bf{&TableName} NO-LOCK NO-ERROR.
                        
            IF AVAIL bf{&TableName} THEN
                RUN repositionRecord IN THIS-PROCEDURE (INPUT (ROWID(bf{&TableName}))).
        END.
    END.
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findDtSaldo DBOProgram
PROCEDURE findDtSaldoAgrup :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base na data dt-saldo.
               Retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pdt-saldo   LIKE inventario.dt-saldo  NO-UNDO.
    DEFINE INPUT PARAMETER p-cdn-agrup LIKE inventario.cdn-agrup NO-UNDO.

    FIND FIRST bf{&TableName}
         WHERE bf{&TableName}.dt-saldo  = pdt-saldo 
          AND  bf{&TableName}.cdn-agrup = p-cdn-agrup NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bf{&TableName} THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bf{&TableName})).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findDtSaldo DBOProgram
PROCEDURE findDtSaldo :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base na data dt-saldo.
               Retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pdt-saldo LIKE inventario.dt-saldo NO-UNDO.

    FIND FIRST bf{&TableName}
         WHERE bf{&TableName}.dt-saldo = pdt-saldo NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bf{&TableName} THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bf{&TableName})).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-depos":U THEN ASSIGN pFieldValue = RowObject.cod-depos.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-localiz":U THEN ASSIGN pFieldValue = RowObject.cod-localiz.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "lote":U THEN ASSIGN pFieldValue = RowObject.lote.
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
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "dt-atualiza":U THEN ASSIGN pFieldValue = RowObject.dt-atualiza.
        WHEN "dt-saldo":U THEN ASSIGN pFieldValue = RowObject.dt-saldo.
        WHEN "dt-ult-entra":U THEN ASSIGN pFieldValue = RowObject.dt-ult-entra.
        WHEN "dt-ult-saida":U THEN ASSIGN pFieldValue = RowObject.dt-ult-saida.
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
        WHEN "valor-ggf-o[2]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-o[2].
        WHEN "valor-ggf-o[3]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-o[3].
        WHEN "valor-ggf-p[1]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-p[1].
        WHEN "valor-ggf-p[2]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-p[2].
        WHEN "valor-ggf-p[3]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-p[3].
        WHEN "valor-mat-m[1]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-m[1].
        WHEN "valor-mat-m[2]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-m[2].
        WHEN "valor-mat-o[3]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-o[3].
        WHEN "valor-mat-p[1]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-p[1].
        WHEN "valor-mat-p[2]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-p[2].
        WHEN "valor-mat-p[3]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-p[3].
        WHEN "valor-mob-m[1]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-m[1].
        WHEN "valor-mob-m[2]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-m[2].
        WHEN "valor-mob-m[3]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-m[3].
        WHEN "valor-mob-o[1]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-o[1].
        WHEN "valor-mob-o[2]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-o[2].
        WHEN "valor-mob-o[3]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-o[3].
        WHEN "valor-mob-p[1]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-p[1].
        WHEN "valor-mob-p[2]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-p[2].
        WHEN "valor-mob-p[3]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-p[3].
        WHEN "valor-mat-m[3]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-m[3].
        WHEN "valor-mat-o[1]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-o[1].
        WHEN "valor-mat-o[2]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-o[2].
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "qtidade-atu":U THEN ASSIGN pFieldValue = RowObject.qtidade-atu.
        WHEN "val-apurado[1]":U THEN ASSIGN pFieldValue = RowObject.val-apurado[1].
        WHEN "val-apurado[2]":U THEN ASSIGN pFieldValue = RowObject.val-apurado[2].
        WHEN "val-apurado[3]":U THEN ASSIGN pFieldValue = RowObject.val-apurado[3].
        WHEN "valor-contab":U THEN ASSIGN pFieldValue = RowObject.valor-contab.
        WHEN "valor-final":U THEN ASSIGN pFieldValue = RowObject.valor-final.
        WHEN "valor-ggf-m[1]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-m[1].
        WHEN "valor-ggf-m[2]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-m[2].
        WHEN "valor-ggf-m[3]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-m[3].
        WHEN "valor-ggf-o[1]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-o[1].
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
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "nr-ficha":U THEN ASSIGN pFieldValue = RowObject.nr-ficha.
        WHEN "situacao":U THEN ASSIGN pFieldValue = RowObject.situacao.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice DATA-INVENT
  Parameters:
               retorna valor dos campos do ¡ndice DATA-INVENT
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pdt-saldo LIKE inventario.dt-saldo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE inventario.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-depos LIKE inventario.cod-depos NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-localiz LIKE inventario.cod-localiz NO-UNDO.
    DEFINE OUTPUT PARAMETER plote LIKE inventario.lote NO-UNDO.
    DEFINE OUTPUT PARAMETER pit-codigo LIKE inventario.it-codigo NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pdt-saldo = RowObject.dt-saldo.
    ASSIGN pcod-estabel = RowObject.cod-estabel.
    ASSIGN pcod-depos = RowObject.cod-depos.
    ASSIGN pcod-localiz = RowObject.cod-localiz.
    ASSIGN plote = RowObject.lote.
    ASSIGN pit-codigo = RowObject.it-codigo.

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
        WHEN "impressa":U THEN ASSIGN pFieldValue = RowObject.impressa.
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




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ¡ndice DATA-INVENT
  Parameters:
               recebe valor dos campos do ¡ndice DATA-INVENT
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pdt-saldo LIKE inventario.dt-saldo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE inventario.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pcod-depos LIKE inventario.cod-depos NO-UNDO.
    DEFINE INPUT PARAMETER pcod-localiz LIKE inventario.cod-localiz NO-UNDO.
    DEFINE INPUT PARAMETER plote LIKE inventario.lote NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo LIKE inventario.it-codigo NO-UNDO.

    FIND FIRST bfinventario WHERE
        bfinventario.dt-saldo = pdt-saldo AND
        bfinventario.cod-estabel = pcod-estabel AND
        bfinventario.cod-depos = pcod-depos AND
        bfinventario.cod-localiz = pcod-localiz AND
        bfinventario.lote = plote AND
        bfinventario.it-codigo = pit-codigo
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfinventario THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfinventario)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

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
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByDtSaldo DBOProgram 
PROCEDURE openQueryByDtSaldo :
/*------------------------------------------------------------------------------
  Purpose:     Abre query pela faixa selecionada (dt-saldo).
  Parameters:  
  Notes:       Utilizado pelo zoom de invent rio.
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName}
                               WHERE {&TableName}.dt-saldo >= da-dt-saldo-ini
                                 AND {&TableName}.dt-saldo <= da-dt-saldo-fim
                               USE-INDEX nr-ficha 
                               NO-LOCK INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByItem DBOProgram 
PROCEDURE openQueryByItem :
/*------------------------------------------------------------------------------
  Purpose:     Abre query pela faixa selecionada (it-codigo).
  Parameters:  
  Notes:       Utilizado pelo zoom de invent rio.
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName}
                               WHERE {&TableName}.it-codigo >= c-it-codigo-ini
                                 AND {&TableName}.it-codigo <= c-it-codigo-fim
                               NO-LOCK INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTTInventBytDtSaldo DBOProgram 
PROCEDURE getTTInventBytDtSaldo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

   DEF OUTPUT PARAM table FOR tt-invent-aux.
   EMPTY TEMP-TABLE tt-invent-aux NO-ERROR.
 
   FOR EACH {&TableName} WHERE {&TableName}.dt-saldo >= da-dt-saldo-ini
                           AND {&TableName}.dt-saldo <= da-dt-saldo-fim 
                           AND {&TableName}.cdn-agrup >= i-cdn-agrup-ini
                           AND {&TableName}.cdn-agrup <= i-cdn-agrup-fim NO-LOCK 
                            BY {&TableName}.dt-saldo:
       
       IF {&TableName}.cdn-agrup > 0 AND (c-descricao-ini <> "" OR c-descricao-ini <> "ZZZZZZZZZZZZZZZZZZZZZZZZZ~
                                                                                       ZZZZZZZZZZZZZZZZZZZZZZZZZ") THEN DO:
           FIND agrup-invent WHERE agrup-invent.cdn-agrup = {&TableName}.cdn-agrup   
                               AND agrup-invent.descricao >= c-descricao-ini 
                               AND agrup-invent.descricao <= c-descricao-fim NO-LOCK NO-ERROR.
           IF NOT AVAIL agrup-invent THEN NEXT.
       END.
        
       IF l-seg-ativa-modulo 
       AND NOT CAN-FIND(FIRST tt_estab_ems2 
                        WHERE tt_estab_ems2.tta_cod_estab = {&TableName}.cod-estabel) THEN
           NEXT.
                                          
       
       IF NOT CAN-FIND (FIRST tt-invent-aux WHERE tt-invent-aux.dt-saldo  = {&TableName}.dt-saldo
                                              AND tt-invent-aux.cdn-agrup = {&TableName}.cdn-agrup)  THEN DO:
          CREATE tt-invent-aux.
          BUFFER-COPY {&TableName} TO tt-invent-aux.
       END.
   END.
   
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDtSaldo DBOProgram 
PROCEDURE openQueryDtSaldo :
/*------------------------------------------------------------------------------
  Purpose:     Abre query pelo campo dt-saldo.
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName}
                               WHERE {&TableName}.dt-saldo = da-dt-saldo
                               USE-INDEX nr-ficha 
                               NO-LOCK INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryNrFicha DBOProgram 
PROCEDURE openQueryNrFicha :
/*------------------------------------------------------------------------------
  Purpose:     Abre a query em ordem de ficha.
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName}
                                     USE-INDEX nr-ficha
                                     NO-LOCK INDEXED-REPOSITION.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByDtSaldo DBOProgram 
PROCEDURE setConstraintByDtSaldo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Utilizado pelo zoom de inventario
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pDtSaldoIni LIKE inventario.dt-saldo NO-UNDO.
    DEFINE INPUT PARAMETER pDtSaldoFim LIKE inventario.dt-saldo NO-UNDO.
    DEFINE INPUT PARAMETER pCdnAgrupIni  LIKE agrup-invent.cdn-agrup NO-UNDO.
    DEFINE INPUT PARAMETER pCdnAgrupFim  LIKE agrup-invent.cdn-agrup NO-UNDO.
    DEFINE INPUT PARAMETER pDescricaoIni LIKE agrup-invent.descricao NO-UNDO.
    DEFINE INPUT PARAMETER pDescricaoFim LIKE agrup-invent.descricao NO-UNDO.
    
    ASSIGN da-dt-saldo-ini = pDtSaldoIni
           da-dt-saldo-fim = pDtSaldoFim
           i-cdn-agrup-ini = pCdnAgrupIni
           i-cdn-agrup-fim = pCdnAgrupFim
           c-descricao-ini = pDescricaoIni 
           c-descricao-fim = pDescricaoFim.
              
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaCdnAgrup DBOProgram 
PROCEDURE verificaCdnAgrup :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Utilizado pelo zoom de inventario
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pCdnAgrup LIKE inventario.cdn-agrup NO-UNDO.
    DEFINE OUTPUT PARAMETER pExiste   AS LOGICAL                NO-UNDO.
    
    FOR FIRST bf{&TableName} WHERE bf{&TableName}.cdn-agrup = pCdnAgrup NO-LOCK:

        ASSIGN pExiste = YES.    

    END.
              
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByItem DBOProgram 
PROCEDURE setConstraintByItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Utilizado pelo zoom de inventario
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pItCodigoIni LIKE inventario.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pItCodigoFim LIKE inventario.it-codigo NO-UNDO.
    
    ASSIGN c-it-codigo-ini = pItCodigoIni
           c-it-codigo-fim = pItCodigoFim.
              
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintDtSaldo DBOProgram 
PROCEDURE setConstraintDtSaldo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pDtSaldo LIKE inventario.dt-saldo NO-UNDO.
    
    ASSIGN da-dt-saldo = pDtSaldo.
              
    RETURN "OK":U.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deletaAgrupador DBOProgram 
PROCEDURE deletaAgrupador :
/*------------------------------------------------------------------------------
  Purpose:     Sugerir agrupador para ficha inventario
  Parameters:  pDtSaldo    - Data da ficha atual
               pAgrupador  - Agrupador sugerido
               
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER  pCdnAgrup   LIKE inventario.cdn-agrup  NO-UNDO.
    
    DEFINE VARIABLE i-cdn-agrup LIKE {&TableName}.cdn-agrup         NO-UNDO.
    
    for each {&TableName} where {&TableName}.cdn-agrup = pCdnAgrup EXCLUSIVE-LOCK:
        ASSIGN {&TableName}.cdn-agrup = 0.
    end.
      

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
