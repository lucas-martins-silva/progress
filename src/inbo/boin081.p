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
{include/i-prgvrs.i BOIN081 2.00.00.007 } /*** "010007" 23/11/2023 16:19:41  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN081 MUT}
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
&GLOBAL-DEFINE DBOName cota-item-reaj
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName cota-item-reaj
&GLOBAL-DEFINE TableLabel Reajuste da Cotaá∆o
&GLOBAL-DEFINE QueryName qr{&TableName}

/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com
      extens∆o .i ---*/

{inbo/boin081.i RowObject}

/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o
      manual da query ---*/
{method/dboqry.i}

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/*----------- VARIµVEIS DA PROCEDURE validaPercentReajuste ---------------*/
def var i-cont     as int    no-undo.
def var d-tot-perc as dec    no-undo.
def var h-boun005  as handle no-undo.
def var c-return   as char   no-undo.
/*------------------------------------------------------------------------*/

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
         HEIGHT             = 20
         WIDTH              = 51.4.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findCodigo DBOProgram 
PROCEDURE findCodigo :
/*------------------------------------------------------------------------------
  Purpose: Procura pelo indice, caso nao ache,
           retorna mensagem de erro padrao do EMS.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter i-numero-ordem as inte no-undo.
    def input parameter i-cod-emitente as inte no-undo.
    def input parameter i-seq-cotac as inte no-undo.
    def output parameter c-return as char no-undo.
    
    run openQueryStatic ("Main":U).
    
    run goToKey (i-numero-ordem, i-cod-emitente, i-seq-cotac).
    
    if return-value = "NOK":U then do:
        {method/svc/errors/inserr.i &ErrorNumber="2"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U
                                    &ErrorParameters="'{&TableName}'":U}   
    end.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findCodigo2 DBOProgram 
PROCEDURE findCodigo2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  parameter i-numero-ordem as inte no-undo.
    def input  parameter i-cod-emitente as inte no-undo.
    def output parameter c-return       as char no-undo.
    
    run openQueryStatic ("Main":U).
    
    run goToReajuste (i-numero-ordem, i-cod-emitente).
    
    if return-value = "NOK":U then do:
        {method/svc/errors/inserr.i &ErrorNumber="2"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U
                                    &ErrorParameters="'{&TableName}'":U}   
    end.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findItem DBOProgram 
PROCEDURE findItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter c-it-codigo     as char no-undo.
    def input parameter i-cod-emitente  as inte no-undo.
    def input parameter da-data-cotacao as date no-undo.
    def input parameter i-numero-ordem  as inte no-undo.
    def input parameter i-seq-cotac     as inte no-undo.
    def output parameter c-return       as char no-undo.
    
    run openQueryStatic ("Main":U).
    
    run goToItem (c-it-codigo, i-cod-emitente, da-data-cotacao, i-numero-ordem, i-seq-cotac).
    
    if return-value = "NOK":U then do:
        {method/svc/errors/inserr.i &ErrorNumber="2"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U
                                    &ErrorParameters="'{&TableName}'":U}         
    end.
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
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
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
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "data-cotacao":U THEN ASSIGN pFieldValue = RowObject.data-cotacao.
        WHEN "data-indice[1]":U THEN ASSIGN pFieldValue = RowObject.data-indice[1].
        WHEN "data-indice[2]":U THEN ASSIGN pFieldValue = RowObject.data-indice[2].
        WHEN "data-indice[3]":U THEN ASSIGN pFieldValue = RowObject.data-indice[3].
        WHEN "data-indice[4]":U THEN ASSIGN pFieldValue = RowObject.data-indice[4].
        WHEN "data-indice[5]":U THEN ASSIGN pFieldValue = RowObject.data-indice[5].
        WHEN "dt-preco-base":U THEN ASSIGN pFieldValue = RowObject.dt-preco-base.
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
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
        WHEN "perc-reaj[1]":U THEN ASSIGN pFieldValue = RowObject.perc-reaj[1].
        WHEN "perc-reaj[2]":U THEN ASSIGN pFieldValue = RowObject.perc-reaj[2].
        WHEN "perc-reaj[3]":U THEN ASSIGN pFieldValue = RowObject.perc-reaj[3].
        WHEN "perc-reaj[4]":U THEN ASSIGN pFieldValue = RowObject.perc-reaj[4].
        WHEN "perc-reaj[5]":U THEN ASSIGN pFieldValue = RowObject.perc-reaj[5].
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
        WHEN "mo-codigo[1]":U THEN ASSIGN pFieldValue = RowObject.mo-codigo[1].
        WHEN "mo-codigo[2]":U THEN ASSIGN pFieldValue = RowObject.mo-codigo[2].
        WHEN "mo-codigo[3]":U THEN ASSIGN pFieldValue = RowObject.mo-codigo[3].
        WHEN "mo-codigo[4]":U THEN ASSIGN pFieldValue = RowObject.mo-codigo[4].
        WHEN "mo-codigo[5]":U THEN ASSIGN pFieldValue = RowObject.mo-codigo[5].
        WHEN "numero-ordem":U THEN ASSIGN pFieldValue = RowObject.numero-ordem.
        WHEN "seq-cotac":U THEN ASSIGN pFieldValue = RowObject.seq-cotac.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice CODIGO
  Parameters:
               retorna valor dos campos do °ndice CODIGO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnumero-ordem LIKE cota-item-reaj.numero-ordem NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE cota-item-reaj.cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pseq-cotac LIKE cota-item-reaj.seq-cotac NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pnumero-ordem = RowObject.numero-ordem.
    ASSIGN pcod-emitente = RowObject.cod-emitente.
    ASSIGN pseq-cotac = RowObject.seq-cotac.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToItem DBOProgram 
PROCEDURE goToItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter c-it-codigo as char no-undo.
    def input parameter i-cod-emitente as inte no-undo.
    def input parameter da-data-cotacao as date no-undo.
    def input parameter i-numero-ordem as inte no-undo.
    def input parameter i-seq-cotac as inte no-undo.

    find bfcota-item-reaj where
         bfcota-item-reaj.it-codigo = c-it-codigo        and
         bfcota-item-reaj.cod-emitente = i-cod-emitente  and
         bfcota-item-reaj.data-cotacao = da-data-cotacao and
         bfcota-item-reaj.numero-ordem = i-numero-ordem  and
         bfcota-item-reaj.seq-cotac = i-seq-cotac        no-lock no-error.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfcota-item-reaj THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfcota-item-reaj)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice CODIGO
  Parameters:
               recebe valor dos campos do °ndice CODIGO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnumero-ordem LIKE cota-item-reaj.numero-ordem NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente LIKE cota-item-reaj.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pseq-cotac LIKE cota-item-reaj.seq-cotac NO-UNDO.

    FIND FIRST bfcota-item-reaj WHERE
        bfcota-item-reaj.numero-ordem = pnumero-ordem AND
        bfcota-item-reaj.cod-emitente = pcod-emitente AND
        bfcota-item-reaj.seq-cotac = pseq-cotac
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfcota-item-reaj THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfcota-item-reaj)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToReajuste DBOProgram 
PROCEDURE goToReajuste :
/*------------------------------------------------------------------------------
  Purpose:    Procura pelo indice, caso nao ache,
              retorna mensagem de erro padrao do EMS.
  Parameters: <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter i-numero-ordem as inte no-undo.
    def input parameter i-cod-emitente as inte no-undo.
 
    FIND FIRST bfcota-item-reaj WHERE
        bfcota-item-reaj.numero-ordem = i-numero-ordem AND
        bfcota-item-reaj.cod-emitente = i-cod-emitente 
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfcota-item-reaj THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfcota-item-reaj)).
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
    OPEN QUERY {&QueryName} FOR EACH cota-item-reaj NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaPercentReajuste DBOProgram 
PROCEDURE validaPercentReajuste :
/*------------------------------------------------------------------------------
  Purpose: Valida Percentural Reajuste da Cotaá∆o.
           O Percentual de Reajuste total tem que ser igual a 100%,
           caso seja menos ou mais, retorna temp-table de erro.  
  Parameters:   ipar1:  RowObject : Temp-table cota-item-reaj com os dados.
                opar2:  tt-bo-erro: temp-table com erros que venham a acontecer
  Notes:       
------------------------------------------------------------------------------*/
    def input-output  param table for RowObject.
    def output param table for RowErrors.
    
    find first RowObject no-error.
    run unbo/boun005.p persistent set h-boun005.
    do i-cont = 1 to 5:
        run findCodigo in h-boun005 (Rowobject.mo-codigo[i-cont], output c-return).
        if c-return <> "" then do:
            /* Inicio -- Projeto Internacional */
            {utp/ut-table.i mguni moeda 1} /* Busca o label da tabela */
            {method/svc/errors/inserr.i 
                            &ErrorNumber="2"
                            &ErrorType="EMS":U
                            &ErrorSubType="ERROR":U
                            &ErrorParameter=TRIM(RETURN-VALUE)}
        end.
    end.
    delete procedure h-boun005.
    /* caso o percentual tenha sido informado, verifica se a data do reajuste
       tambÇm foi informada */
    do i-cont = 1 to 5:
        if RowObject.perc-reaj[i-cont] <> 0 then do: 
            if RowObject.data-indice[i-cont] = ? then do:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-indice AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "'÷ndice'" *}
                ASSIGN c-lbl-liter-indice = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i 
                                &ErrorNumber="1385"
                                &ErrorType="EMS":U
                                &ErrorSubType="ERROR":U
                                &ErrorParameter=c-lbl-liter-indice}        
            end.
        end.
    end.
    
    assign d-tot-perc = RowObject.perc-reaj[1] + RowObject.perc-reaj[2] + RowObject.perc-reaj[3] + RowObject.perc-reaj[4] + RowObject.perc-reaj[5].
    
    if d-tot-perc > 100 then do: /* percentual total n∆o pode ser superior a 100% */
                {method/svc/errors/inserr.i 
                                &ErrorNumber="2337"
                                &ErrorType="EMS":U
                                &ErrorSubType="ERROR":U}        
    end.
    if d-tot-perc < 100 then do: /* percentual total n∆o pode ser inferior a 100% */
                {method/svc/errors/inserr.i 
                                &ErrorNumber="7657"
                                &ErrorType="EMS":U
                                &ErrorSubType="ERROR":U}
    end.                
    IF NOT CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN DO:
          do i-cont = 1 to 5:
            if RowObject.perc-reaj[i-cont] <= 0 then do: /* s¢ grava aqueles em q o percentual for informado*/
                assign RowObject.perc-reaj[i-cont] = 0
                       RowObject.data-indice[i-cont] = ?
                       RowObject.mo-codigo[i-cont] = 0.
            end.
         end.
    END.

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

