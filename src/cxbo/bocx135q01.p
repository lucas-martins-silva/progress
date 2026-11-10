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
{include/i-prgvrs.i BOCX135Q01 2.00.00.001} /*** "010001" 11/12/2023 10:13:23 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOCX135Q01 MUT}
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
&GLOBAL-DEFINE DBOName tt-desp-item
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName tt-desp-item
&GLOBAL-DEFINE TableLabel tt-desp-item
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

{cxbo/bocx135q01.i tt-desp-item}
{cxbo/bocx135q01.i RowObject}

/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o
      manual da query ---*/
{method/dboqry.i}

/* Local Buffer Definitions ---                                            */
/*DEFINE BUFFER bf{&TableName} FOR tt-desp-item.*/

/*---------- Include de PrÇ-Processadores -------------*/
{cdp/cdcfgmat.i}


def var r-first   as ROWID no-undo.
def var r-last    as ROWID no-undo.
def var r-aux-pri as ROWID no-undo.

def var linha-aux  as int no-undo.
def var i-nrlinhas as int no-undo.

/*--Definiá∆o variaveis usadas nas procedures--*/

def var c-inicial as char   no-undo.
def var c-final   as char   no-undo.
def var i-inicial as int    no-undo.
def var i-final   as int    no-undo.
def var c-desc-item as char no-undo.


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
        WHEN "it-codigo"     THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "char-1"        THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2"        THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum"     THEN ASSIGN pFieldValue = RowObject.check-sum.        
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
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-itiner":U    THEN ASSIGN pFieldValue = RowObject.cod-itiner.
        WHEN "cod-desp":U      THEN ASSIGN pFieldValue = RowObject.cod-desp.
        WHEN "cod-pto-contr":U THEN ASSIGN pFieldValue = RowObject.cod-pto-contr.
        WHEN "int-1":U         THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U         THEN ASSIGN pFieldValue = RowObject.int-2.
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
    DEFINE OUTPUT PARAMETER pit-codigo LIKE {&TABLENAME}.it-codigo   NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-itiner LIKE {&TABLENAME}.cod-itiner NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-desp LIKE {&TABLENAME}.cod-desp   NO-UNDO.
    
    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pit-codigo  = RowObject.it-codigo.
    ASSIGN pcod-itiner = RowObject.cod-itiner.
    ASSIGN pcod-desp   = RowObject.cod-desp.

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




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByItem DBOProgram 
PROCEDURE setConstraintFaixaItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

 def input parameter p-inicial as char.
 def input parameter p-final   as char.

 assign c-inicial = p-inicial
        c-final   = p-final.

 run carregatable.
 
      RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFaixaItiner DBOProgram 
PROCEDURE setConstraintFaixaItiner :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

 def input parameter p-inicial as integer.
 def input parameter p-final   as integer.

 assign i-inicial = p-inicial
        i-final   = p-final.

 run carregatable.        

      RETURN "OK":U.
END PROCEDURE.


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFaixaDesc DBOProgram 
PROCEDURE setConstraintFaixaDesc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

 def input parameter p-inicial as char.
 def input parameter p-final   as char.
 
 assign c-inicial = p-inicial
        c-final   = p-final.

 run carregatable.        

      RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByItem DBOProgram 
PROCEDURE openQueryByItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   if c-inicial = c-final then
        open query {&QUERYNAME} for each tt-desp-item where 
                                         tt-desp-item.it-codigo  = c-inicial 
                                         by tt-desp-item.it-codigo
                                         by tt-desp-item.cod-itiner
                                         INDEXED-REPOSITION.   
   else
        open query {&QUERYNAME} for each tt-desp-item where 
                                         tt-desp-item.it-codigo >= c-inicial and
                                         tt-desp-item.it-codigo <= c-final
                                         by tt-desp-item.it-codigo
                                         by tt-desp-item.cod-itiner
                                         INDEXED-REPOSITION.

                 
  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByItiner DBOProgram 
PROCEDURE openQueryByItiner :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   if i-inicial = i-final then
        open query {&QUERYNAME} for each tt-desp-item where 
                                         tt-desp-item.cod-itiner  = i-inicial 
                                         by tt-desp-item.cod-itiner
                                         by tt-desp-item.it-codigo
                                         INDEXED-REPOSITION.   
   else
        open query {&QUERYNAME} for each tt-desp-item where 
                                         tt-desp-item.cod-itiner >= i-inicial and
                                         tt-desp-item.cod-itiner <= i-final
                                         by tt-desp-item.cod-itiner
                                         by tt-desp-item.it-codigo
                                         INDEXED-REPOSITION.
                  
  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByDesc DBOProgram 
PROCEDURE openQueryByDesc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   if c-inicial = c-final then
        open query {&QUERYNAME} for each tt-desp-item where 
                                         tt-desp-item.desc-item  = c-inicial 
                                         by tt-desp-item.desc-item
                                         by tt-desp-item.it-codigo
                                         by tt-desp-item.cod-itiner                                               
                                         by tt-desp-item.cod-desp
                                         INDEXED-REPOSITION.   
   else
        open query {&QUERYNAME} for each tt-desp-item where 
                                         tt-desp-item.desc-item >= c-inicial and
                                         tt-desp-item.desc-item <= c-final
                                         by tt-desp-item.desc-item
                                         by tt-desp-item.it-codigo
                                         by tt-desp-item.cod-itiner                                               
                                         by tt-desp-item.cod-desp
                                         INDEXED-REPOSITION.


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
    OPEN QUERY {&QueryName} 
        FOR EACH tt-desp-item NO-LOCK 
        INDEXED-REPOSITION.

    RETURN "OK":U.
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
 
    for each desp-item no-lock:
         &if defined(bf-mat-comex) &then  
           for first item 
                fields(descricao-1 descricao-2)
                no-lock where item.it-codigo = desp-item.it-codigo:
           end.
           if avail item then
             assign c-desc-item = item.descricao-1 + item.descricao-2.
           else assign c-desc-item = "".             
         &else
            for first item 
               fields(desc-item)
               no-lock where item.it-codigo = desp-item.it-codigo:
            end.
            if avail item then
               assign c-desc-item = item.desc-item .
            else assign c-desc-item = "".
         &endif
    
         for first tt-desp-item
               fields(it-codigo cod-itiner cod-desp desc-item)
               where tt-desp-item.cod-itiner = desp-item.cod-itiner and
                     tt-desp-item.it-codigo  = desp-item.it-codigo:
         end.
         if not avail tt-desp-item then do:
              create tt-desp-item.
              assign tt-desp-item.it-codigo  = desp-item.it-codigo
                     tt-desp-item.cod-itiner = desp-item.cod-itiner
                     tt-desp-item.cod-desp   = desp-item.cod-desp
                     tt-desp-item.desc-item  = c-desc-item
                     tt-desp-item.r-rowid    = rowid(desp-item).
                                   
         end.         
    end.        

      RETURN "OK":U.
END PROCEDURE.



/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforegetBatchRecords Method-Library 
PROCEDURE beforegetBatchRecords :
/*------------------------------------------------------------------------------
  Purpose:     Customizada para carregar o rowid da tabela na temptable para 
               poder ser feita a navegaá∆o no browse corretamente. 
  Parameters:  
  Notes: 
------------------------------------------------------------------------------*/

    for first tt-desp-item 
        fields(it-codigo) no-lock
        where tt-desp-item.it-codigo = rowObject.it-codigo 
         and tt-desp-item.cod-itiner = rowObject.cod-itiner.
       assign rowObject.r-rowid = tt-desp-item.r-rowid.
    end.
    
       
/*    for first desp-item 
        fields(it-codigo) no-lock
        where desp-item.it-codigo = rowObject.it-codigo 
         and desp-item.cod-itiner = rowObject.cod-itiner.
       assign rowObject.r-rowid = rowid(desp-item).
    end.
    */
   
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
/*        /*--- Reposiciona a query pelo rowid (repositionRecord) ---*/
 *         RUN repositionRecord IN THIS-PROCEDURE (INPUT pRowid).
 *         IF RETURN-VALUE = "NOK":U THEN
 *             RETURN "NOK":U.*/
        
        /* customizaá∆o */
    /*    for first desp-item fields(it-codigo cod-itiner cod-desp)
             WHERE ROWID(desp-item) = pRowid.
           FIND tt-desp-item WHERE 
                tt-desp-item.it-codigo  = desp-item.it-codigo AND
                tt-desp-item.cod-itiner = desp-item.cod-itiner AND
                tt-desp-item.cod-desp   = desp-item.cod-desp no-error.
           if avail tt-desp-item then 
               ASSIGN pRowid = ROWID(tt-desp-item).
        end.*/
        
        for first tt-desp-item fields(it-codigo)
             WHERE tt-desp-item.r-rowid = pRowid.
               ASSIGN pRowid = rowid(tt-desp-item).
        end.
        
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
/*        /*--- Posicina no prΩximo registro, conforme flag de par≥metro (getNext) ---*/
 *         RUN getNext IN THIS-PROCEDURE.
 *         IF RETURN-VALUE = "NOK":U THEN
 *             RETURN "NOK":U.*/
        
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
        
/*        /*--- Posicina no prΩximo registro (getNext) ---*/
 *         RUN getNext IN THIS-PROCEDURE.
 *         IF RETURN-VALUE = "NOK":U AND
 *            NOT CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorNumber = 10) THEN
 *             RETURN "NOK":U.*/
        
        GET NEXT {&QueryName}.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
