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
{include/i-prgvrs.i BOIN358Q01 2.00.00.010} /*** "010010" 24/11/2023 13:25:22  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN358Q01 MUT}
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
&GLOBAL-DEFINE DBOName proc-compra
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName proc-compra
&GLOBAL-DEFINE TableLabel proc-compra
&GLOBAL-DEFINE QueryName qr{&TableName}

{cdp/cdcfgren.i} /* pre-processor indices grendene - nao remover */

&IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
   &SCOPED-DEFINE indrep INDEXED-REPOSITION
&ENDIF

/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com
      extens∆o .i ---*/
{inbo/boin358.i RowObject}

/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o
      manual da query ---*/
/*{method/dboqry.i}*/

DEFINE QUERY {&QueryName} for {&TableName}, ordem-compra scrolling.

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

    def var inr-proc-ini      as int no-undo.
    def var inr-proc-fim      as int initial "999,999".
    def var cdesc-proc-ini    as char format "x(40)":U no-undo.
    def var cdesc-proc-fim    as char format "x(40)":U no-undo initial "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ".
    def var ccod-comprado     as char format "x(12)":U no-undo.
    def var ccod-comprado-ini as char format "x(12)":U no-undo.
    def var ccod-comprado-fim as char format "x(12)":U no-undo initial "ZZZZZZZZZZZZ".
    def var dainicio-ini      as date no-undo.
    def var dainicio-fim      as date no-undo.

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
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-comprado":U THEN ASSIGN pFieldValue = RowObject.cod-comprado.
        WHEN "descricao":U THEN ASSIGN pFieldValue = RowObject.descricao.
        WHEN "narrativa":U THEN ASSIGN pFieldValue = RowObject.narrativa.
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
        WHEN "dt-inicio":U THEN ASSIGN pFieldValue = RowObject.dt-inicio.
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
        WHEN "nr-processo":U THEN ASSIGN pFieldValue = RowObject.nr-processo.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
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
    DEFINE OUTPUT PARAMETER pnr-processo LIKE proc-compra.nr-processo NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pnr-processo = RowObject.nr-processo.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuery DBOProgram 
PROCEDURE openQuery :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then do:
           run openQueryStatic (input "byNrProcesso":U).
        end.   
        when 2 then do:
           run openQueryStatic (input "byNrProcesso":U).
        end.
        when 3 then do:
           run openQueryStatic (input "byDescricao":U).
        end.
        when 4 then do:
           run openQueryStatic (input "byCodComprado":U).
        end.
    end. /*end case*/
   RETURN "OK":U.     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuerybyCodComprado DBOProgram 
PROCEDURE openQuerybyCodComprado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

        if ccod-comprado-ini <> ccod-comprado-fim then do:
            open query {&QueryName} for each {&TableName}  where
                                              {&TableName}.cod-comprado    >= ccod-comprado-ini and
                                              {&TableName}.cod-comprado    <= ccod-comprado-fim no-lock,
                                        first ordem-compra where 
                                              ordem-compra.nr-processo = {&TableName}.nr-processo and 
                                             (ordem-compra.situacao   = 1 or ordem-compra.situacao = 5)
                                              by  {&TableName}.cod-comprado {&indrep}.
        end.
        else do:                                   
            open query {&QueryName} for each {&TableName}  where
                                              {&TableName}.cod-comprado    = ccod-comprado-ini no-lock,
                                        first ordem-compra where 
                                              ordem-compra.nr-processo = {&TableName}.nr-processo and 
                                             (ordem-compra.situacao   = 1 or ordem-compra.situacao = 5) 
                                              no-lock
                                              by  {&TableName}.cod-comprado {&indrep}.                                            
        end.                                              

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuerybyDescricao DBOProgram 
PROCEDURE openQuerybyDescricao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        if cdesc-proc-ini <> cdesc-proc-fim then do:
            open query {&QueryName} for each {&TableName}  where
                                              {&TableName}.descricao    >= cdesc-proc-ini and
                                              {&TableName}.descricao    <= cdesc-proc-fim no-lock
                                              &IF DEFINED(CUSTOM_GRENDENE) &THEN
                                                  USE-INDEX desc-proc
                                              &ENDIF
                                              ,
                                        first ordem-compra where 
                                              ordem-compra.nr-processo = {&TableName}.nr-processo and 
                                             (ordem-compra.situacao   = 1 or ordem-compra.situacao = 5) 
                                              NO-LOCK 
                                            &IF DEFINED(CUSTOM_GRENDENE) = 0 &THEN
                                                by  {&TableName}.descricao 
                                            &ENDIF
                                            {&indrep}.
        end.
        else do:                                   
            open query {&QueryName} for each {&TableName} where
                                             {&TableName}.descricao    = cdesc-proc-ini NO-LOCK 
                                              &IF DEFINED(CUSTOM_GRENDENE) &THEN
                                                  USE-INDEX desc-proc
                                              &ENDIF                 
                                              ,
                                        first ordem-compra where 
                                              ordem-compra.nr-processo = {&TableName}.nr-processo and 
                                             (ordem-compra.situacao    = 1 or ordem-compra.situacao = 5)
                                              NO-LOCK 
                                            &IF DEFINED(CUSTOM_GRENDENE) = 0 &THEN
                                                by  {&TableName}.descricao 
                                            &ENDIF
                                            {&indrep}.
        end.                                
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuerybyNrProcesso DBOProgram 
PROCEDURE openQuerybyNrProcesso :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF inr-proc-ini = inr-proc-fim THEN DO:
            open query {&QueryName} for each {&TableName}  where
                                              {&TableName}.nr-processo  = inr-proc-ini no-lock, 
                                        first ordem-compra where 
                                              ordem-compra.nr-processo = {&TableName}.nr-processo and 
                                             (ordem-compra.situacao   = 1 or ordem-compra.situacao = 5)
                                              no-lock
                                              by  {&TableName}.nr-processo {&indrep}. 

   END.
   ELSE DO:
        IF ccod-comprado-ini = ccod-comprado-fim THEN DO:
                 open query {&QueryName} for each {&TableName}  where
                                                   {&TableName}.cod-comprado  = ccod-comprado-ini no-lock, 
                                             first ordem-compra where 
                                                   ordem-compra.nr-processo = {&TableName}.nr-processo and 
                                                   (ordem-compra.situacao   = 1 or ordem-compra.situacao = 5)
                                                   no-lock
                                                   by  {&TableName}.nr-processo {&indrep}.                
     
        END.
        ELSE DO:                                   
                 open query {&QueryName} for each {&TableName}  where
                                                   {&TableName}.nr-processo  >= inr-proc-ini   and
                                                   {&TableName}.nr-processo  <= inr-proc-fim   and
                                                   {&TableName}.cod-comprado >= ccod-comprado-ini and
                                                   {&TableName}.cod-comprado <= ccod-comprado-fim no-lock,
                                             first ordem-compra where 
                                                   ordem-compra.nr-processo = {&TableName}.nr-processo and 
                                                   (ordem-compra.situacao   = 1 or ordem-compra.situacao = 5)
                                                   no-lock
                                                   by  {&TableName}.nr-processo {&indrep}.                
        END. 
   END.                   

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryNrProcesso DBOProgram 
PROCEDURE openQueryNrProcesso :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
                 open query {&QueryName} for each {&TableName}  where
                                                   {&TableName}.nr-processo  >= inr-proc-ini   and
                                                   {&TableName}.nr-processo  <= inr-proc-fim   and
                                                   {&TableName}.descricao    >= cdesc-proc-ini and
                                                   {&TableName}.descricao    <= cdesc-proc-fim and
                                                   {&TableName}.cod-comprado >= ccod-comprado-ini and
                                                   {&TableName}.cod-comprado <= ccod-comprado-fim no-lock,
                                             first ordem-compra where 
                                                   ordem-compra.nr-processo = {&TableName}.nr-processo and 
                                                   (ordem-compra.situacao   = 1 or ordem-compra.situacao = 5)
                                                   no-lock
                                                   by  {&TableName}.nr-processo {&indrep}.                

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryComprador DBOProgram 
PROCEDURE openQueryComprador:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
                 open query {&QueryName} for each {&TableName}  where
                                                   {&TableName}.cod-comprado >= ccod-comprado-ini and
                                                   {&TableName}.cod-comprado <= ccod-comprado-fim and
                                                   {&TableName}.nr-processo  >= inr-proc-ini      and
                                                   {&TableName}.nr-processo  <= inr-proc-fim      and
                                                   {&TableName}.descricao    >= cdesc-proc-ini    and
                                                   {&TableName}.descricao    <= cdesc-proc-fim    no-lock,
                                             first ordem-compra where 
                                                   ordem-compra.nr-processo = {&TableName}.nr-processo and 
                                                   (ordem-compra.situacao   = 1 or ordem-compra.situacao = 5)
                                                   no-lock
                                                   by  {&TableName}.cod-comprado {&indrep}.               

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDescricao DBOProgram 
PROCEDURE openQueryDescricao:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
                 open query {&QueryName} for each {&TableName}  where
                                                   {&TableName}.descricao    >= cdesc-proc-ini    and
                                                   {&TableName}.descricao    <= cdesc-proc-fim    and
                                                   {&TableName}.cod-comprado >= ccod-comprado-ini and
                                                   {&TableName}.cod-comprado <= ccod-comprado-fim and
                                                   {&TableName}.nr-processo  >= inr-proc-ini      and
                                                   {&TableName}.nr-processo  <= inr-proc-fim  NO-LOCK 
                                                &IF DEFINED(CUSTOM_GRENDENE) &THEN
                                                    USE-INDEX desc-proc
                                                &ENDIF
                                                  ,
                                             first ordem-compra where 
                                                   ordem-compra.nr-processo = {&TableName}.nr-processo and 
                                                   (ordem-compra.situacao   = 1 or ordem-compra.situacao = 5)
                                                   no-lock
                                                   &IF DEFINED(CUSTOM_GRENDENE) = 0 &THEN
                                                       by  {&TableName}.descricao 
                                                   &ENDIF
                                                   {&indrep}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFiltroProcesso DBOProgram 
PROCEDURE openQueryFiltroProcesso:
/*------------------------------------------------------------------------------
  Purpose: Busca conjunto de registro da tabela proc-compra, de acordo com a faixa 
           de n£mero do processo e data de in°cio do processo.E ordens de compra
           com situaá∆o ou 5.
                
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    open query {&QueryName} for each {&TableName}  where
                                     {&TableName}.cod-comprado   = ccod-comprado and 
                                     {&TableName}.nr-processo   >= inr-proc-ini  and
                                     {&TableName}.nr-processo   <= inr-proc-fim  and
                                     {&TableName}.dt-inicio     >= dainicio-ini  and
                                     {&TableName}.dt-inicio     <= dainicio-fim  no-lock, 
                               first ordem-compra where 
                                     ordem-compra.nr-processo = {&TableName}.nr-processo and 
                                    (ordem-compra.situacao = 1 or 
                                     ordem-compra.situacao = 5) no-lock
                              &IF int (substring (proversion, 1, index (proversion, ".") - 1)) >= 9 &THEN
                                     indexed-reposition
                              &ENDIF
                              .

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
    def input param pcomprador-ini as char no-undo.
    def input param pcomprador-fim as char no-undo.
     
    run setconstraintbyCodComprado (input pcomprador-ini, 
                                          pcomprador-fim).
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint2 DBOProgram 
PROCEDURE setConstraint2:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param pnum-proc-ini as char no-undo.
    def input param pnum-proc-fim as char no-undo.
    def input param pdesc-ini as char no-undo.
    def input param pdesc-fim as char no-undo.
    def input param pcomprador-ini as char no-undo.
    def input param pcomprador-fim as char no-undo.
     
    run setconstraintbyNrProcesso (input string(pnum-proc-ini),
                                         string(pnum-proc-fim)).
    run setconstraintbyDescricao  (input pdesc-ini,
                                         pdesc-fim).
    run setconstraintbyCodComprado (input pcomprador-ini, 
                                          pcomprador-fim).
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintbyCodComprado DBOProgram 
PROCEDURE setConstraintbyCodComprado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param pcod-comprado-ini as char no-undo.
    def input param pcod-comprado-fim as char no-undo.
     
    assign ccod-comprado-ini = pcod-comprado-ini
           ccod-comprado-fim = pcod-comprado-fim.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintbyDescricao DBOProgram 
PROCEDURE setConstraintbyDescricao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param pdesc-proc-ini as char no-undo.
    def input param pdesc-proc-fim as char no-undo.
     
    assign cdesc-proc-ini = pdesc-proc-ini
           cdesc-proc-fim = pdesc-proc-fim.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintbyNrProcesso DBOProgram 
PROCEDURE setConstraintbyNrProcesso :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param pnr-proc-ini   as int no-undo.
    def input param pnr-proc-fim   as int no-undo.
     
    assign inr-proc-ini   = pnr-proc-ini
           inr-proc-fim   = pnr-proc-fim.
           
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFiltroProcesso DBOProgram 
PROCEDURE setConstraintFiltroProcesso :
/*------------------------------------------------------------------------------
  Purpose:   Seta as vari†veis de controle para queries contendo os n£meros dos
             processos de compras e datas do inicio do processo inicial e final.  
  Parameters: ipar1 : pcod-comprado  : C¢digo do comprador
              ipar2 : pnr-proc-ini   : N£mero do processo inicial  
              ipar3 : pnr-proc-fim   : N£mero do processo final  
              ipar4 : pdt-inicio-ini : Data do in°cio do processo inicial
              ipar5 : pdt-inicio-fim : Data do in°cio do processo final
  Notes:       
------------------------------------------------------------------------------*/
    def input param pcod-comprado  as char no-undo.
    def input param pnr-proc-ini   as int  no-undo.
    def input param pnr-proc-fim   as int  no-undo.
    def input param pdt-inicio-ini as date no-undo.
    def input param pdt-inicio-fim as date no-undo.
    
     
    assign inr-proc-ini  = pnr-proc-ini
           inr-proc-fim  = pnr-proc-fim
           dainicio-ini  = pdt-inicio-ini
           dainicio-fim  = pdt-inicio-fim
           ccod-comprado = pcod-comprado.
           
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

    IF pType = "Delete":U then do:
       run verificaRelacoesProcCompra.
    END.

    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaRelacoesProcCompra DBOProgram 
PROCEDURE verificaRelacoesProcCompra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
 Procedure criada para implementar a validaá∆o: na eliminaá∆o da tabela proc-compra, verificar se 
 esta possui relacionamento com a tabela proc-fornec .
 */

 def var c-msg  as char no-undo. 
 def var c-msg2  as char no-undo. 
 
 find first proc-fornec
      where proc-fornec.nr-processo = proc-compra.nr-processo no-lock no-error.
 if  avail proc-fornec then do:
     {method/svc/errors/inserr.i &ErrorNumber="8029"
                                &ErrorType="EMS":U
                                &ErrorSubType="ERROR":U
                                &ErrorParameters="'{&TableLabel}'"}
     return "NOK":U.
 end.
 
 find first ordem-compra use-index ordem 
      where ordem-compra.nr-processo = proc-compra.nr-processo no-lock no-error.
 if  avail ordem-compra then do:
 
     {utp/ut-field.i mgind proc-compra nr-processo 1}
     assign c-msg = return-value.
     {utp/ut-liter.i eliminado_com_ordem(s)_vinculada(s).} 
     assign c-msg2 = trim(return-value).
    {method/svc/errors/inserr.i &ErrorNumber="7972"
                                &ErrorType="EMS":U
                                &ErrorSubType="ERROR":U
                                &ErrorParameters="'c-msg + ~'~~~' + c-msg2'"}
    return "NOK":U.
 end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

