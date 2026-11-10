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
{include/i-prgvrs.i BOIN082Q10 2.00.00.014 } /*** "010014" 23/11/2023 16:19:42  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin082q10 MUT}
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
&GLOBAL-DEFINE DBOName tt-cotacao-item
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName tt-cotacao-item
&GLOBAL-DEFINE TableLabel tt-cotacao-item
&GLOBAL-DEFINE QueryName qr{&TableName}

/*********************************************************************************
**  S¢ a DBO principal (bocx135.p) est† com as funá‰es de inclui (createRecord), 
**  modifica (updateRecord) e elimina (deleteRecord) habilitadas, 
**  porque S‡ nela foram implementadas as triggers do dicion†rio.
**  Para desabilitar as procedures foram usados os prÇ-processadores abaixo.
**  A procedure validateRecord dessa DBO n∆o deve ser usada.
*********************************************************************************/
&GLOBAL-DEFINE EXCLUDE-createRecord 0
&GLOBAL-DEFINE EXCLUDE-updateRecord 0
&GLOBAL-DEFINE EXCLUDE-deleteRecord 0
&GLOBAL-DEFINE EXCLUDE-getBatchRecords 0
/*&GLOBAL-DEFINE EXCLUDE-getRowid*/

/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com
      extens∆o .i ---*/


{cdp/cdcfgmat.i}

{inbo/boin082q10.i tt-cotacao-item}
{inbo/boin082q10.i RowObject}

/************************************************************************
 * TECNICA DE SEGURAN∞A POR ESTABELECIMENTO
 ************************************************************************/
&Scoped-define FIRST-TABLE-IN-QUERY-{&QueryName} tt-cotacao-item 
&Scoped-define SECOND-TABLE-IN-QUERY-{&QueryName} ordem-compra


&Scoped-define TTONLY TRUE
&Scoped-define REPOSITION-PROCEDURE repositionQuerys
&Scoped-define REPOSITION-PROCEDURE-KEY-PHRASE tt-cotacao-item.numero-ordem = ordem-compra.numero-ordem NO-LOCK

{include/i-estab-security.i}
DEFINE QUERY {&QueryName} FOR {&TableName}, ordem-compra, {&ESTAB-SEC-TT} SCROLLING.
/************************************************************************
 * TECNICA DE SEGURAN∞A POR ESTABELECIMENTO
 ************************************************************************/


/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o
      manual da query ---*/

/* Local Buffer Definitions ---                                            */
/*DEFINE BUFFER bf{&TableName} FOR tt-embarque-imp.*/

/*---------- Include de PrÇ-Processadores -------------*/


{cdp/cd4300.i3}  /* Atributos livres */

def var r-first   as ROWID no-undo.
def var r-last    as ROWID no-undo.
def var r-aux-pri as ROWID no-undo.

def var linha-aux  as int no-undo.
def var i-nrlinhas as int no-undo.

/*--Definiá∆o variaveis usadas nas procedures--*/

DEF VAR i-numero-ordem-ini AS INT NO-UNDO.
DEF VAR i-numero-ordem-fim AS INT NO-UNDO.
DEF VAR i-cod-emitente-ini AS INT NO-UNDO.
DEF VAR i-cod-emitente-fim AS INT NO-UNDO.
DEF VAR c-it-codigo-ini    AS CHAR NO-UNDO.
DEF VAR c-it-codigo-fim    AS CHAR NO-UNDO.
DEF VAR dt-cotacao-ini     AS DATE NO-UNDO.
DEF VAR dt-cotacao-fim     AS DATE NO-UNDO.
DEF VAR c-cod-incoterm     AS CHAR FORMAT "x(03)" NO-UNDO.
DEF VAR i-pto-contr-base   AS INT  NO-UNDO.
DEF VAR l-aprovada         AS LOGICAL NO-UNDO.

def var i-cod-emitente   like emitente.cod-emitente   no-undo.
def var c-nome-abrev     like emitente.nome-abrev     no-undo.
                                                               
def var c-estab-fisc     like processo-imp.estab-fisc no-undo.

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
         HEIGHT             = 22.71
         WIDTH              = 71.86.
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
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-incoterm"       THEN ASSIGN pFieldValue = RowObject.cod-incoterm.
        WHEN "it-codigo"          THEN ASSIGN pFieldValue = RowObject.it-codigo. 
        WHEN "un"                 THEN ASSIGN pFieldValue = RowObject.un.
        WHEN "char-1"             THEN ASSIGN pFieldValue = RowObject.char-1.
        &if defined(bf-mat-comex) &then /* Integracao com o produto Magnus */
        &else      
            WHEN "char-2"             THEN ASSIGN pFieldValue = RowObject.char-2.
            WHEN "check-sum"          THEN ASSIGN pFieldValue = RowObject.check-sum.
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
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-cotacao":U THEN ASSIGN pFieldValue = RowObject.data-cotacao.
        &if defined(bf-mat-comex) &then /* Integracao com o produto Magnus */
        &else      
           WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
           WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        &endif
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
        &if defined(bf-mat-comex) &then /* Integracao com o produto Magnus */
        &else      
           WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
           WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
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
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-emitente":U      THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "numero-ordem":U      THEN ASSIGN pFieldValue = RowObject.numero-ordem.
        WHEN "int-1":U             THEN ASSIGN pFieldValue = RowObject.int-1.
        &if defined(bf-mat-comex) &then /* Integracao com o produto Magnus */
        &else      
           WHEN "int-2":U             THEN ASSIGN pFieldValue = RowObject.int-2.
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
  Purpose:     Retorna valores dos campos do °ndice COMPRADOR
  Parameters:
               retorna valor dos campos do °ndice COMPRADOR
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnumero-ordem LIKE {&TABLENAME}.numero-ordem NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE {&TABLENAME}.cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pit-codigo    LIKE {&tablename}.it-codigo    NO-UNDO.
    &if defined(bf-mat-comex) &then /* Integracao com o produto Magnus */
    &else      
      DEFINE OUTPUT PARAMETER pseq-cotac    LIKE {&TABLENAME}.seq-cotac    NO-UNDO.
    &endif      

    
    
    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pnumero-ordem  = RowObject.numero-ordem
           pcod-emitente  = RowObject.cod-emitente
           pit-codigo     = RowObject.it-codigo
           &if defined(bf-mat-comex) &then /* Integracao com o produto Magnus */
           &else      
             pseq-cotac   = RowObject.seq-cotac
           &ENDIF .

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




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByEmbarque DBOProgram 
PROCEDURE setConstraintFaixaOrdem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

 def input parameter p-numero-ordem-ini as INT NO-UNDO.
 DEF INPUT PARAMETER p-numero-ordem-fim AS INT NO-UNDO.
 DEF INPUT PARAMETER p-cod-emitente-ini AS INT NO-UNDO.
 DEF INPUT PARAMETER p-cod-emitente-fim AS INT NO-UNDO.
 DEF INPUT PARAMETER p-it-codigo-ini    AS CHAR NO-UNDO.
 DEF INPUT PARAMETER p-it-codigo-fim    AS CHAR NO-UNDO.
 DEF INPUT PARAMETER p-dt-cotacao-ini   AS DATE NO-UNDO.
 DEF INPUT PARAMETER p-dt-cotacao-fim   AS DATE NO-UNDO.
 DEF INPUT PARAMETER p-l-aprovada       AS CHAR NO-UNDO.

 assign i-numero-ordem-ini = p-numero-ordem-ini
        i-numero-ordem-fim = p-numero-ordem-fim
        i-cod-emitente-ini = p-cod-emitente-ini
        i-cod-emitente-fim = p-cod-emitente-fim
        c-it-codigo-ini    = p-it-codigo-ini   
        c-it-codigo-fim    = p-it-codigo-fim   
        dt-cotacao-ini     = p-dt-cotacao-ini  
        dt-cotacao-fim     = p-dt-cotacao-fim 
        l-aprovada         = IF p-l-aprovada = "NO" THEN NO ELSE YES.
 
 run carregatable.
 
      RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByOrdem DBOProgram 
PROCEDURE openQueryByOrdem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
    &Scoped-define OPEN-QUERY-{&MY-QUERY}-AT OPEN QUERY {&QueryName} FOR~
                                                   EACH {&TableName} NO-LOCK,~
                                                   EACH ordem-compra NO-LOCK~
                                                  WHERE ordem-compra.numero-ordem = {&TableName}.numero-ordem,~
                                                  EACH {&ESTAB-SEC-TT} WHERE {&ESTAB-SEC-TT-FIELD} = ordem-compra.cod-estabel NO-LOCK.
                                                        
    &Scoped-define OPEN-QUERY-{&MY-QUERY}-IN OPEN QUERY {&QueryName} FOR~
                                                   EACH {&TableName} NO-LOCK,~
                                                   EACH ordem-compra NO-LOCK~
                                                  WHERE ordem-compra.numero-ordem = {&TableName}.numero-ordem,~
                                                  EACH  {&ESTAB-SEC-TT} NO-LOCK.

                                                        
    {include/i-estab-openquery.i}

                 
  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByEmbarqueWeb DBOProgram 
PROCEDURE openQueryByOrdemWeb :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    &Scoped-define OPEN-QUERY-{&MY-QUERY}-AT OPEN QUERY {&QueryName} FOR~
                                                   EACH {&TableName} NO-LOCK,~
                                                   EACH ordem-compra NO-LOCK~
                                                  WHERE ordem-compra.numero-ordem = {&TableName}.numero-ordem,~
                                                  EACH {&ESTAB-SEC-TT} WHERE {&ESTAB-SEC-TT-FIELD} = ordem-compra.cod-estabel NO-LOCK.
                                                        
    &Scoped-define OPEN-QUERY-{&MY-QUERY}-IN OPEN QUERY {&QueryName} FOR~
                                                   EACH {&TableName} NO-LOCK,~
                                                   EACH ordem-compra NO-LOCK~
                                                  WHERE ordem-compra.numero-ordem = {&TableName}.numero-ordem,~
                                                  EACH  {&ESTAB-SEC-TT} NO-LOCK.

                                                        
    {include/i-estab-openquery.i}
                 
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
    &Scoped-define OPEN-QUERY-{&MY-QUERY}-AT OPEN QUERY {&QueryName} FOR~
                                                   EACH {&TableName} NO-LOCK,~
                                                   EACH ordem-compra NO-LOCK~
                                                  WHERE ordem-compra.numero-ordem = {&TableName}.numero-ordem,~
                                                  EACH {&ESTAB-SEC-TT} WHERE {&ESTAB-SEC-TT-FIELD} = ordem-compra.cod-estabel NO-LOCK.
                                                        
    &Scoped-define OPEN-QUERY-{&MY-QUERY}-IN OPEN QUERY {&QueryName} FOR~
                                                   EACH {&TableName} NO-LOCK,~
                                                   EACH ordem-compra NO-LOCK~
                                                  WHERE ordem-compra.numero-ordem = {&TableName}.numero-ordem,~
                                                  EACH  {&ESTAB-SEC-TT} NO-LOCK.

                                                        
    {include/i-estab-openquery.i}

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCopyBuffer2TT DBOProgram 
PROCEDURE afterCopyBuffer2TT :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
ASSIGN rowObject.r-rowid = tt-cotacao-item.r-rowid.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterGetRowid DBOProgram 
PROCEDURE afterGetRowid :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE input-output PARAMETER pRowid  AS ROWID NO-UNDO.
  
  ASSIGN pRowid = tt-cotacao-item.r-rowid.
  
  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforegetBatchRecords DBOProgram 
PROCEDURE beforegetBatchRecords :
/*------------------------------------------------------------------------------
  Purpose:     Customizada para carregar o rowid da tabela na temptable para 
               poder ser feita a navegaá∆o no browse corretamente. 
  Parameters:  
  Notes: 
------------------------------------------------------------------------------*/

    /*for first tt-embarque-imp 
        fields(cod-estabel embarque) no-lock
        where tt-embarque-imp.cod-estabel = rowObject.cod-estabel 
         and tt-embarque-imp.embarque = rowObject.embarque:
       assign rowObject.r-rowid = tt-embarque-imp.r-rowid.
           VIEW-AS ALERT-BOX INFO BUTTONS OK.
    end. */
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforerepositionrecord DBOProgram 
PROCEDURE beforerepositionrecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pRowid  AS ROWID NO-UNDO.

    find {&TableName} where {&TableName}.r-rowid = pRowid no-lock no-error.
    if avail {&TableName} then 
       assign pRowid = rowid({&TableName}).

    /*--- Reposiciona query ---*/
    REPOSITION {&QueryName} TO ROWID pRowid NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        /*--- Erro 11: Nío foi poss≠vel reposicionar a query ---*/
        {method/svc/errors/inserr.i &ErrorNumber="11"
                                    &ErrorType="INTERNAL"
                                    &ErrorSubType="ERROR"}

        RETURN "NOK":U.
    END.
    
    /*--- » necessˇrio para o correto funcionamento do reposicionamento ---*/
    GET NEXT {&QueryName} NO-LOCK.

    /*--- Seta flag indicando que o registro atual foi reposicionado ---*/
    &IF "{&DBType}" = "ORACLE":U &THEN
        ASSIGN lRepositioned = YES.
    &ENDIF
    
    /*--- Atualiza temptable RowObject ---*/
    RUN _copyBuffer2TT IN THIS-PROCEDURE.
    
    RETURN "NOK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaTable DBOProgram 
PROCEDURE carregaTable :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

        /* carrega temptable espec°fica para zoom z10cx135 */

        /* Somente embarques nao encerrados */

    FOR EACH tt-cotacao-item:
        DELETE tt-cotacao-item.
    END.

    FOR EACH cotacao-item WHERE
             cotacao-item.numero-ordem >= i-numero-ordem-ini AND
             cotacao-item.numero-ordem <= i-numero-ordem-fim AND
             cotacao-item.cod-emitente >= i-cod-emitente-ini AND
             cotacao-item.cod-emitente <= i-cod-emitente-fim AND
             cotacao-item.it-codigo    >= c-it-codigo-ini    AND
             cotacao-item.it-codigo    <= c-it-codigo-fim    AND
             cotacao-item.data-cotacao >= dt-cotacao-ini     AND
             cotacao-item.data-cotacao <= dt-cotacao-fim     NO-LOCK:

             IF l-aprovada <> cotacao-item.cot-aprovada THEN NEXT.
                
             FOR FIRST emitente FIELDS (natureza) WHERE 
                       emitente.cod-emitente = cotacao-item.cod-emitente NO-LOCK:
             END.
             
             IF NOT AVAIL emitente THEN NEXT.

             IF NOT AVAIL emitente OR
                 &if defined(bf-mat-comex) &then /* Integracao com o produto Magnus */
                     (emitente.natureza <> "E" AND
                      emitente.natureza <> "T") THEN NEXT.
                 &else      
                    (emitente.natureza <> 3 AND
                     emitente.natureza <> 4) THEN NEXT.
                  &endif
                  
             {ccp/cc9019.i50}

             &if defined(bf-mat-comex) &then /* Integracao com o produto Magnus */
                 assign i-mapa-cotacao-i50  = int(substring(cotacao-item.char-1,6,2))  
                 c-cod-incoterm-i50  = substring(cotacao-item.char-1,8,3)                    
                 i-cod-pto-contr-i50 = int(substring(cotacao-item.char-1,11,5)).
             &else
                 /*EMS*/
                                                       
                 {cdp/cd4300.i4 "yes" cotacao-item.char-1}
                 {ccp/cc9019.i51 "yes"}
             &endif 

             IF c-cod-incoterm-i50 = "" AND
                i-cod-pto-contr-i50 = 0 THEN NEXT.
             
             assign c-cod-incoterm   = c-cod-incoterm-i50
                    i-pto-contr-base = i-cod-pto-contr-i50.

             CREATE tt-cotacao-item.
             /*BUFFER COPY cotacao-item TO tt-cotacao-item.*/
             ASSIGN  tt-cotacao-item.numero-ordem = cotacao-item.numero-ordem
                     tt-cotacao-item.cod-emitente = cotacao-item.cod-emitente
                     tt-cotacao-item.it-codigo    = cotacao-item.it-codigo
                     &if defined(bf-mat-comex) &then /* Integracao com o produto Magnus */
                     &else      
                     tt-cotacao-item.seq-cotac    = cotacao-item.seq-cotac
                     &endif      
                     tt-cotacao-item.data-cotacao = cotacao-item.data-cotacao
                     tt-cotacao-item.cod-incoterm = c-cod-incoterm
                     tt-cotacao-item.un           = cotacao-item.un
                     tt-cotacao-item.r-rowid      = ROWID(cotacao-item).
    END.

    RETURN "OK":U.
END PROCEDURE.



/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getBatchRecords Method-Library 
PROCEDURE getBatchRecords :
/*------------------------------------------------------------------------------
  Purpose:     Retorna faixa de registros da query atrav≤s da 
               temptable RowObjectAux 
  Parameters:  recebe rowid inicial
               recebe flag indicando a execuªío de novo GET NEXT
               recebe número de linhas a serem retornadas
               retorna número de linhas retornadas
               retorna temptable RowObjectAux
  Notes: 
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pRowid        AS ROWID   NO-UNDO.
    DEFINE INPUT  PARAMETER pNext         AS LOGICAL NO-UNDO.
    DEFINE INPUT  PARAMETER pRowsToReturn AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER pRowsReturned AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowObjectAux.
    
&IF "{&ROW-NUM-DEFINED}" = "YES" &THEN
    DEFINE VARIABLE iNextSeq AS INTEGER NO-UNDO INIT 0.
&ENDIF
    
    /*--- Verifica permissío de execuªío ---*/
    {method/svc/security/permit.i &Method="Navigation"}
    
    /*--- Limpa temptable RowObjectAux ---*/
    RUN emptyRowObjectAux IN THIS-PROCEDURE.
    
    IF pRowid <> ? THEN DO:
        
        /* customizaá∆o */
        
        for first tt-cotacao-item WHERE 
                  tt-cotacao-item.r-rowid = pRowid.
        end.
        if avail tt-cotacao-item then 
            ASSIGN pRowid = rowid(tt-cotacao-item).
 
        REPOSITION {&QueryName} TO ROWID pRowid NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            &IF "{&NewRecordOffQuery}" = "YES" &THEN
                GET FIRST {&QueryName} NO-LOCK.
                ASSIGN pRowid = rowid({&TableName}).
                REPOSITION {&QueryName} TO ROWID pRowid NO-ERROR.
                IF ERROR-STATUS:ERROR THEN do:
                    RETURN "NOK":U.
                end.
            &ELSE
                RETURN "NOK":U.
            &ENDIF
        END.
        
        GET NEXT {&QueryName} NO-LOCK.
        
        /*--- Este teste torna-se necessˇrio devido ao fato de realizar-se um 
              reposicionamento de um registro rec≤m eliminado. Neste caso nío ≤ 
              retornado erro no comando REPOSITION, pois o reposicionamento da
              QUERY ≤ processado com base no RESULT-LIST ---*/
        IF NOT AVAILABLE {&TableName} THEN
            RETURN "NOK":U.
    END.
    
    IF pNext THEN DO:
        
        GET NEXT {&QueryName} NO-LOCK.
    END.
    
    /*--- Grava temptable RowObjectAux ---*/
    DO WHILE AVAILABLE({&TableName}):
        IF pRowsToReturn <> 0 AND pRowsReturned >= pRowsToReturn THEN
            LEAVE.
        
        /*--- Atualiza temptable RowObject ---*/
        RUN _copyBuffer2TT IN THIS-PROCEDURE.
    &IF "{&ROW-NUM-DEFINED}" = "YES" &THEN
        ASSIGN iNextSeq = iNextSeq + 1
               RowObject.RowNum = iNextSeq.
    &ENDIF
        
        /*--- Executa m≤todos sobrepostos (before/after) ---*/
        {method/svc/override/override.i &Position="before"
                                        &Procedure="getBatchRecords"}
        IF lOverrideExecuted AND RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.
        
        /*--- Copia o registro da temptable RowObject para a temptable RowObjectAux ---*/
        CREATE RowObjectAux.
        BUFFER-COPY RowObject TO RowObjectAux.
        
        ASSIGN pRowsReturned = pRowsReturned + 1.
        
        /*--- Executa m≤todos sobrepostos (before/after) ---*/
        {method/svc/override/override.i &Position="after"
                                        &Procedure="getBatchRecords"}
        IF lOverrideExecuted AND RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.
        
        
        GET NEXT {&QueryName}.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE repositionQuerys DBOProgram 
PROCEDURE repositionQuerys :
    DEFINE INPUT PARAM p-row-table AS ROWID NO-UNDO.    
    DEFINE OUTPUT PARAM rowid-array AS ROWID EXTENT 18 NO-UNDO.
    DEF VAR oldRowid AS ROWID NO-UNDO.

    IF AVAIL(tt-cotacao-item) THEN 
        ASSIGN oldRowid = tt-cotacao-item.r-rowid.
    ELSE 
        ASSIGN oldRowid = ?.


    
     FIND FIRST tt-cotacao-item NO-LOCK 
             WHERE tt-cotacao-item.r-rowid = p-row-table NO-ERROR.
     IF AVAIL tt-cotacao-item THEN
        FIND FIRST ordem-compra WHERE ordem-compra.numero-ordem = tt-cotacao-item.numero-ordem NO-LOCK NO-ERROR.
    

    IF l-estab-security-active AND AVAIL(ordem-compra) THEN DO:
        FIND FIRST {&ESTAB-SEC-TT} NO-LOCK 
             WHERE {&ESTAB-SEC-TT-FIELD} = ordem-compra.cod-estabel NO-ERROR.
    END.
    ELSE DO:
        FIND FIRST {&ESTAB-SEC-TT} NO-LOCK NO-ERROR.             
    END.
    IF AVAIL {&ESTAB-SEC-TT} AND AVAIL(ordem-compra)  THEN DO:
        ASSIGN 
            rowid-array[1] = p-row-table
            rowid-array[2] = ROWID(ordem-compra)
            rowid-array[3] = ROWID({&ESTAB-SEC-TT}).    
        
        RETURN "OK".
    END.
    ELSE DO:
        /*inicio logica para retornar ao registro anterior*/
        IF oldRowid <> ? THEN DO:
            FIND FIRST tt-cotacao-item NO-LOCK 
                 WHERE tt-cotacao-item.r-rowid = oldRowid NO-ERROR.
            IF AVAIL tt-cotacao-item THEN
                FIND FIRST ordem-compra WHERE ordem-compra.numero-ordem = tt-cotacao-item.numero-ordem NO-LOCK NO-ERROR.
            
            IF l-estab-security-active AND AVAIL(ordem-compra) THEN DO:
                FIND FIRST {&ESTAB-SEC-TT} NO-LOCK 
                     WHERE {&ESTAB-SEC-TT-FIELD} = ordem-compra.cod-estabel NO-ERROR.
            END.
            ELSE DO:
                FIND FIRST {&ESTAB-SEC-TT} NO-LOCK NO-ERROR.             
            END.
        END.
        /*fim logica para retornar ao registro anterior*/
        IF AVAIL {&ESTAB-SEC-TT} AND AVAIL(ordem-compra) THEN DO:   
                
            ASSIGN 
                rowid-array[1] = oldRowid
                rowid-array[2] = ROWID(ordem-compra)
                rowid-array[3] = ROWID({&ESTAB-SEC-TT}).                 
                    
                
            RETURN "OK".
        END.
        ELSE DO:        
            ASSIGN ERROR-STATUS:ERROR = NO. /*CORRIGE O ERRO DE STATUS PARA N∞O APRESENTAR A MSG 16690*/
            ASSIGN 
                rowid-array[1] = ?    
                rowid-array[2] = ?
                rowid-array[3] = ?
                rowid-array[4] = ?    
                rowid-array[5] = ?
                rowid-array[6] = ?.
            /*RETURN "ADM-ERROR".*/
            RETURN "NOK".
        END.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
