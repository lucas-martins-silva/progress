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
{include/i-prgvrs.i BOIN691 2.00.00.005 } /*** "010005" 24/11/2023 13:25:27  ***/
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
&GLOBAL-DEFINE DBOName matriz-rat-ordem
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName matriz-rat-ordem
&GLOBAL-DEFINE TableLabel matriz-rat-ordem
&GLOBAL-DEFINE QueryName qr{&TableName}

DEF VAR i-numero-ordem AS INTE NO-UNDO.
DEF VAR c-cod-comprado AS CHAR NO-UNDO.

/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com
      extens∆o .i ---*/
{inbo/boin691.i RowObject}

/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o
      manual da query ---*/
{method/dboqry.i}

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

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
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "conta-contabil":U THEN ASSIGN pFieldValue = RowObject.conta-contabil.
        WHEN "ct-codigo":U THEN ASSIGN pFieldValue = RowObject.ct-codigo.
        WHEN "sc-codigo":U THEN ASSIGN pFieldValue = RowObject.sc-codigo.
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
        WHEN "perc-rateio":U THEN ASSIGN pFieldValue = RowObject.perc-rateio.
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
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
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
  Purpose:     Retorna valores dos campos do °ndice ORDEM
  Parameters:
               retorna valor dos campos do °ndice ORDEM
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnumero-ordem LIKE matriz-rat-ordem.numero-ordem NO-UNDO.
    DEFINE OUTPUT PARAMETER pconta-contabil LIKE matriz-rat-ordem.conta-contabil NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pnumero-ordem = RowObject.numero-ordem.
    ASSIGN pconta-contabil = RowObject.conta-contabil.

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
  Purpose:     Reposiciona registro com base no °ndice ORDEM
  Parameters:
               recebe valor dos campos do °ndice ORDEM
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnumero-ordem LIKE matriz-rat-ordem.numero-ordem NO-UNDO.
    DEFINE INPUT PARAMETER pconta-contabil LIKE matriz-rat-ordem.conta-contabil NO-UNDO.

    FIND FIRST bfmatriz-rat-ordem WHERE
        bfmatriz-rat-ordem.numero-ordem = pnumero-ordem AND
        bfmatriz-rat-ordem.conta-contabil = pconta-contabil
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfmatriz-rat-ordem THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmatriz-rat-ordem)).
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
    OPEN QUERY {&QueryName} FOR EACH matriz-rat-ordem NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryNumeroOrdem DBOProgram 
PROCEDURE openQueryNumeroOrdem :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH matriz-rat-ordem 
                               WHERE matriz-rat-ordem.numero-ordem = i-numero-ordem NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piEliminaMatriz DBOProgram
PROCEDURE piEliminaMatriz :
/*------------------------------------------------------------------------------
  Purpose:     Elimina matriz de rateio
  Parameters:  recebe o rowid do registro.
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pRowid AS ROWID NO-UNDO.

    FIND matriz-rat-ordem WHERE
         ROWID(matriz-rat-ordem) = pRowid EXCLUSIVE-LOCK NO-ERROR.

    IF AVAIL matriz-rat-ordem THEN
        DELETE matriz-rat-ordem.

    IF ERROR-STATUS:ERROR THEN DO:

    END.
    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piHabilitaCampos DBOProgram 
PROCEDURE piHabilitaCampos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes: Esta procedure foi baseada na procedure enableFieldsMod do boin168.p
------------------------------------------------------------------------------*/
    def input  param prOrdem        as ROWID no-undo.
    def input  param pcUsuario      as CHAR  no-undo.
    def output param plCtCodigo     as log   no-undo.
    def output param plScCodigo     as log   no-undo.
    def output param plCodUtiliz    as log   no-undo.
    def output param plClassif      as log   no-undo.
    def output param piNatDesp      as int   no-undo.
    def output param pcCentroCusto  as CHAR  no-undo.
    
    def var l-classif  AS log no-undo.
    def var i-nat-desp AS int no-undo.

    ASSIGN plCtCodigo  = yes 
           plSCCodigo  = yes 
           plCodUtiliz = yes.
    
    FIND FIRST param-global no-lock no-error.
    
    FIND ordem-compra WHERE
         ROWID(ordem-compra) = prOrdem NO-LOCK NO-ERROR.

    FOR FIRST usuar-mater FIELDS (cod-usuario log-1 log-2 
                                  char-1      sc-codigo)
        WHERE usuar-mater.cod-usuario = pcUsuario NO-LOCK: END.

    IF AVAIL usuar-mater then
        assign plCtCodigo    = usuar-mater.log-1
               plScCodigo    = usuar-mater.log-2        
               plCodUtiliz   = IF substring(usuar-mater.char-1,1,1) = "y" THEN YES ELSE NO
               pcCentroCusto = usuar-mater.sc-codigo.

    IF AVAIL ordem-compra THEN DO:
        FOR FIRST item FIELDS (it-codigo   fm-codigo
                               nat-despesa tipo-contr
                               tipo-con-est)
            WHERE item.it-codigo = ordem-compra.it-codigo NO-LOCK: END.

        if  avail item THEN do:
            for first item-uni-estab fields (it-codigo cod-estabel nat-despesa altera-conta)
                where item-uni-estab.it-codigo   = item.it-codigo
                  and item-uni-estab.cod-estabel = ordem-compra.cod-estabel no-lock: end.
            if avail item-uni-estab THEN
                assign l-classif  = item-uni-estab.altera-conta   /*se NO ent∆o deve montar a conta*/
                       i-nat-desp = item-uni-estab.nat-despesa. /*nat-despesa*/
            else do:
                for first fam-mat-estab fields (fm-codigo cod-estabel nat-despesa altera-conta)
                    where fam-mat-estab.fm-codigo   = item.fm-codigo
                      and fam-mat-estab.cod-estabel = ordem-compra.cod-estabel 
                    no-lock: end.
                if avail fam-mat-estab then 
                    assign l-classif  = fam-mat-estab.altera-conta
                           i-nat-desp = fam-mat-estab.nat-despesa. /*nat-despesa*/
                else 
                    assign l-classif  = no
                           i-nat-desp = item.nat-despesa. /*nat-despesa*/
            end.
        end.
        /* Se utilizar classificaá∆o cont†bil, n∆o sugere a conta
           (mesmo que o usu†rio tenha permiss∆o para alterar a conta/sub-conta */

        IF NOT l-classif then 
           assign plCtCodigo = no /*disable*/ 
                  plScCodigo = no.

        assign plClassif = l-classif
               piNatDesp = i-nat-desp.

    END.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaPercRateio DBOProgram 
PROCEDURE piValidaPercRateio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes: Esta procedure foi baseada na procedure enableFieldsMod do boin168.p
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAM piNumeroOrdem AS INTEGER NO-UNDO.
    DEFINE INPUT  PARAM pcBotao       AS CHAR    NO-UNDO.
    DEFINE OUTPUT PARAM plIncluir     AS LOGICAL NO-UNDO.

    DEFINE VARIABLE de-percentual AS DEC NO-UNDO.

    ASSIGN plIncluir = YES.

    IF CAN-FIND(FIRST bfmatriz-rat-ordem
                WHERE bfmatriz-rat-ordem.numero-ordem = piNumeroOrdem NO-LOCK) THEN DO:
        FOR EACH bfmatriz-rat-ordem FIELDS (perc-rateio)
           WHERE bfmatriz-rat-ordem.numero-ordem = piNumeroOrdem NO-LOCK:
            assign de-percentual = de-percentual + bfmatriz-rat-ordem.perc-rateio.
        END.
    END.

    /* Se n∆o foi selecionado o bot∆o voltar e o percentual for igual a 100 da a mensagem abaixo */
    IF pcBotao = "" AND 
       de-percentual = 100 THEN DO:
        {method/svc/errors/inserr.i
                         &ErrorNumber="26998" /* Matriz de rateio igual a 100% */
                         &ErrorType="EMS"
                         &ErrorSubType="ERROR"}
        ASSIGN plIncluir = NO.
    END.
    ELSE DO:
        IF pcBotao <> "" AND 
           de-percentual > 0 AND
           de-percentual < 100 THEN DO:
            {method/svc/errors/inserr.i
                             &ErrorNumber="27005" /* Matriz de rateio menor que 100% */
                             &ErrorType="EMS"
                             &ErrorSubType="ERROR"}
            RETURN "NOK":U.
        END.
    END.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintNumeroOrdem DBOProgram 
PROCEDURE setConstraintNumeroOrdem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM pNumeroOrdem AS INTE NO-UNDO.

    ASSIGN i-numero-ordem = pNumeroOrdem.

    return "OK":U.
END PROCEDURE.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateMatrizRateio DBOProgram
PROCEDURE validateMatrizRateio :
/*------------------------------------------------------------------------------
  Purpose:     Valida temptable RowObject
  Parameters:  recebe o tipo de validaá∆o (Create,Update)
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcParam     AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pcCodUtiliz AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pcCodEstab  AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pcUsuario   AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER piNatDesp   AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER plClassif   AS LOGICAL NO-UNDO.
    DEFINE INPUT PARAMETER plScCodigo  AS LOGICAL NO-UNDO.

    DEF VAR i-empresa  LIKE param-global.empresa-prin NO-UNDO. 
    DEF VAR de-percentual AS DEC NO-UNDO. 

    FIND FIRST param-global NO-LOCK NO-ERROR.

    FOR EACH RowErrors:
        DELETE RowErrors.
    END.
    
    FIND FIRST Rowobject NO-ERROR.
    IF NOT AVAIL RowObject THEN DO:
        /* &1 indispon°vel */
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-matriz-de-rateio AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Matriz_de_Rateio" *}
        ASSIGN c-lbl-liter-matriz-de-rateio = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                             &ErrorNumber="16283"  
                             &ErrorType="EMS"
                             &ErrorSubType="ERROR"
                             &ErrorParameters="c-lbl-liter-matriz-de-rateio"}
        RETURN "NOK":U.
    END.
    
    FOR FIRST usuar-mater 
        WHERE usuar-mater.cod-usuario = pcUsuario NO-LOCK: END.

    IF pcParam = "add":U THEN DO:
        if not plClassif then do:
            IF pcCodUtiliz <> "" THEN DO:
                IF NOT CAN-FIND(FIRST utilizacao-mater 
                                WHERE utilizacao-mater.cod-utiliz = pcCodUtiliz NO-LOCK) THEN DO:
                    /* &1 inexistente */
                    /* Inicio -- Projeto Internacional */
                    {utp/ut-table.i mgind utilizacao-mater 1} /* Busca o label da tabela */
                    {method/svc/errors/inserr.i
                                       &ErrorNumber="56"  
                                       &ErrorType="EMS"
                                       &ErrorSubType="ERROR" 
                                       &ErrorParameters=TRIM(RETURN-VALUE)}
                END.

                IF NOT CAN-FIND(FIRST utiliz-natu-despes 
                                WHERE utiliz-natu-despes.cod-nat-despesa = piNatDesp 
                                  AND utiliz-natu-despes.cod-utiliz      = pcCodUtiliz NO-LOCK) THEN DO:
                    /* Utilizaá‰es da Natureza Despesa n∆o cadastrada */
                    {method/svc/errors/inserr.i
                                       &ErrorNumber="16848"
                                       &ErrorType="EMS"
                                       &ErrorSubType="ERROR" 
                                       &ErrorParameters="string(piNatDesp) + '~~~~' + pcCodUtiliz"}
                END.

                for first natureza-despesa fields (nat-despesa ct-codigo) 
                    where natureza-despesa.nat-despesa = piNatDesp no-lock: end.
                if avail natureza-despesa 
                     and pcParam = "add":U then do:

                    if AVAIL usuar-mater
                         AND substring(usuar-mater.char-1,1,1) = "y" then do:  /**** Utilizaá∆o de Material ******/
                        for first utiliz-natu-despes fields (cod-nat-despesa ct-codigo cod-utiliz) 
                            where utiliz-natu-despes.cod-nat-despesa = natureza-despesa.nat-despesa 
                              AND utiliz-natu-despes.cod-utiliz      = pcCodUtiliz no-lock: end.
                        if avail utiliz-natu-despes then do:
                            for first utilizacao-mater fields (cod-utiliz des-utiliz) 
                                where utilizacao-mater.cod-utiliz = utiliz-natu-despes.cod-utiliz no-lock: end.
                            IF AVAIL utilizacao-mater THEN
                                assign rowObject.ct-codigo = utiliz-natu-despes.ct-codigo.
                        end.
                    end. 
                    else 
                        assign rowObject.ct-codigo = natureza-despesa.ct-codigo.
                end.

                if not plScCodigo /* disable */ then do:
                   if avail usuar-mater then assign rowObject.sc-codigo = usuar-mater.sc-codigo.
                end.
                /* se o campo estava habilitado na tela, a rowObject permanecer† com o valor informado */
            END.
        END.

        assign RowObject.conta-contabil = rowObject.ct-codigo +
                                          rowObject.sc-codigo
               i-empresa = param-global.empresa-prin.

        &if defined (bf_dis_consiste_conta) &then
            find estabelec where
                 estabelec.cod-estabel = pcCodEstab no-lock no-error.
            if avail estabelec then     
            run cdp/cd9970.p (input  rowid(estabelec),
                              output i-empresa).
        &endif
        
        IF CAN-FIND (FIRST bfmatriz-rat-ordem where 
                     bfmatriz-rat-ordem.numero-ordem   = RowObject.numero-ordem AND 
                     bfmatriz-rat-ordem.conta-contabil = RowObject.conta-contabil NO-LOCK) THEN DO:
              /* &1 j† cadastrado(a) */
              /* Inicio -- Projeto Internacional */
              {utp/ut-table.i movind matriz-rat-ordem 1} /* Busca o label da tabela */
              {method/svc/errors/inserr.i
                               &ErrorNumber="8" 
                               &ErrorType="EMS"
                               &ErrorSubType="ERROR"
                               &ErrorParameters=TRIM(RETURN-VALUE)}
        END.

        IF NOT CAN-FIND (FIRST conta-contab 
                         WHERE conta-contab.ep-codigo = i-empresa 
                           AND conta-contab.ct-codigo = RowObject.ct-codigo 
                           AND conta-contab.sc-codigo = RowObject.sc-codigo no-lock) THEN DO:

            /* &1 n∆o cadastrado (a) */
            /* Inicio -- Projeto Internacional */
            {utp/ut-table.i mgadm conta-contab 1} /* Busca o label da tabela */
            {method/svc/errors/inserr.i
                             &ErrorNumber="47" 
                             &ErrorType="EMS"
                             &ErrorSubType="ERROR" 
                             &ErrorParameters=TRIM(RETURN-VALUE)}
        END.
    END.
    
    IF pcParam = "add":U OR
       pcParam = "mod":U THEN DO:
        IF RowObject.perc-rateio <= 0 THEN DO:
            /* Valor deve ser maior que zero */
            {method/svc/errors/inserr.i
                             &ErrorNumber="1470" 
                             &ErrorType="EMS"
                             &ErrorSubType="ERROR"}
        END.
        ELSE DO:
            FOR EACH bfmatriz-rat-ordem 
               WHERE bfmatriz-rat-ordem.numero-ordem    = RowObject.numero-ordem
                 AND bfmatriz-rat-ordem.conta-contabil <> RowObject.conta-contabil NO-LOCK:
               ASSIGN de-percentual = de-percentual + bfmatriz-rat-ordem.perc-rateio.
            END.
            ASSIGN de-percentual = de-percentual + RowObject.perc-rateio.

            IF de-percentual > 100 THEN DO:
                /* Soma do percentual de rateio excede a 100% */
                {method/svc/errors/inserr.i
                                 &ErrorNumber="26997" 
                                 &ErrorType="EMS"
                                 &ErrorSubType="ERROR"}
            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToOrdemCompra DBOProgram 
PROCEDURE linkToOrdemCompra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM ph-ordem-compra AS HANDLE NO-UNDO.

    RUN getKey IN ph-ordem-compra (OUTPUT c-cod-comprado, OUTPUT i-numero-ordem).

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

