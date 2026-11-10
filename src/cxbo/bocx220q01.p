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
{include/i-prgvrs.i BOCX220Q01 2.00.00.010 } /*** "010010" 16/12/2025 12:07:50 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOCX220Q01 MUT}
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
&GLOBAL-DEFINE DBOName tt-embarque-imp
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName tt-embarque-imp
&GLOBAL-DEFINE TableLabel tt-embarque-imp
&GLOBAL-DEFINE QueryName qr{&TableName}

/*********************************************************************************
**  S¢ a DBO principal (bocx220.p) est† com as funá‰es de inclui (createRecord), 
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

{cxbo/bocx220q01.i tt-embarque-imp}
{cxbo/bocx220q01.i tt-embarque-imp-aux}
{cxbo/bocx220q01.i RowObject}

DEFINE TEMP-TABLE tt-ordem NO-UNDO 
    FIELD cod-estabel like embarque-imp.cod-estabel
    FIELD embarque like embarque-imp.embarque
    FIELD num-pedido LIKE ordem-compra.num-pedido
    FIELD it-codigo LIKE ordem-compra.it-codigo
    FIELD numero-ordem LIKE ordem-compra.numero-ordem
    FIELD r-Rowid AS ROWID.

/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o
      manual da query ---*/
{method/dboqry.i}

/* Local Buffer Definitions ---                                            */

/*---------- Include de PrÇ-Processadores -------------*/
{cdp/cdcfgmat.i}


def var r-first   as ROWID no-undo.
def var r-last    as ROWID no-undo.
def var r-aux-pri as ROWID no-undo.

def var linha-aux  as int no-undo.
def var i-nrlinhas as int no-undo.

/*--Definiá∆o variaveis usadas nas procedures--*/

def var c-est-ini as char  no-undo.
def var c-est-fim  as char no-undo.
def var c-emb-ini  as char no-undo.
def var c-emb-fim  as char no-undo.
def var c-proc-ini as char no-undo.
def var c-proc-fim as char no-undo.
def var c-item-ini as char no-undo.
def var c-item-fim as char no-undo.
def var c-fat-ini  as char no-undo.
def var c-fat-fim  as char no-undo.
def var i-pto-ini  as int  no-undo.
def var i-pto-fim  as int  no-undo.
def var d-dt-efetiva like historico-embarque.dt-efetiva.
def var c-fatura like invoice-emb-imp.nr-invoice.
def var d-dt-vencim like invoice-emb-imp.dt-vencim.
def var l-query1 as log no-undo initial no.
def var l-query2 as log no-undo initial no.
def var i-cont as int no-undo.

def var c-rowid as char format "x(10)" no-undo.

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
         HEIGHT             = 2.88
         WIDTH              = 32.14.
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


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCharField DBOProgram 
PROCEDURE getCharField:
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
        WHEN "cod-estabel"   THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "embarque"      THEN ASSIGN pFieldValue = RowObject.embarque.
        WHEN "fatura"        THEN ASSIGN pFieldValue = RowObject.fatura.
        WHEN "char-2"        THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum"     THEN ASSIGN pFieldValue = RowObject.check-sum.        
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

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
ASSIGN rowObject.r-rowid = tt-embarque-imp.r-rowid.

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
  
  ASSIGN pRowid = tt-embarque-imp.r-rowid.
  
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
   def var c-return as char initial "OK" no-undo.
   def var i-pto-eadi as int no-undo.

    for each tt-embarque-imp:
       delete tt-embarque-imp.
    end.    
        
/* carrega temptable espec°fica para zoom IM0099P */
    for each embarque-imp 
        fields(cod-estabel embarque char-1 cdn-pto-chegad)
        where embarque-imp.cod-estabel >= c-est-ini and
              embarque-imp.cod-estabel <= c-est-fim and
              embarque-imp.embarque >= c-emb-ini    and
              embarque-imp.embarque <= c-emb-fim 
              no-lock:
         assign c-return = "OK".               
         for each ordens-embarque 
            fields(numero-ordem)
            where ordens-embarque.cod-estabel = embarque-imp.cod-estabel and
                  ordens-embarque.embarque    = embarque-imp.embarque
                  no-lock:
                FOR FIRST ordem-compra 
                    WHERE ordem-compra.numero-ordem = ordens-embarque.numero-ordem NO-LOCK.
                END.
                IF AVAIL ordem-compra THEN DO:
                    FOR FIRST tt-ordem 
                        WHERE tt-ordem.numero-ordem = ordem-compra.numero-ordem.
                    END.
                    IF NOT AVAIL tt-ordem THEN DO:
                        CREATE tt-ordem.                                        
                        ASSIGN tt-ordem.cod-estabel = embarque-imp.cod-estabel     
                               tt-ordem.embarque    = embarque-imp.embarque
                               tt-ordem.num-pedido  = ordem-compra.num-pedido
                               tt-ordem.it-codigo   = ordem-compra.it-codigo
                               tt-ordem.numero-ordem = ordem-compra.numero-ordem.       
                    END.
                END.
         END.
         FOR FIRST tt-ordem
             WHERE tt-ordem.it-codigo >= c-item-ini AND
                   tt-ordem.it-codigo <= c-item-fim.
         END.
         IF NOT AVAIL tt-ordem THEN DO:
              ASSIGN c-return = "NOK".
              FOR EACH tt-ordem:
                  DELETE tt-ordem.
              END.
              NEXT.
         END.
         ELSE DO:
             FOR EACH tt-ordem:
                 for first processo-imp
                   fields(nr-proc-imp)
                   where processo-imp.num-pedido = tt-ordem.num-pedido and
                         processo-imp.nr-proc-imp >= c-proc-ini and
                         processo-imp.nr-proc-imp <= c-proc-fim
                         no-lock:
                 end.
                 IF NOT AVAIL processo-imp THEN DO:
                      ASSIGN c-return = "NOK".
                      NEXT.
                 END.
             END.
         END.

         FOR EACH tt-ordem:
             DELETE tt-ordem.
         END.
         
         IF c-return = "NOK" THEN NEXT.
                  
         if c-fat-ini <> " " or c-fat-fim <> "ZZZZZZZZZZZZ" then do:
            for first invoice-emb-imp
               fields(nr-invoice)
                  where invoice-emb-imp.cod-estabel = embarque-imp.cod-estabel and
                        invoice-emb-imp.embarque    = embarque-imp.embarque    and
                        invoice-emb-imp.nr-invoice >= c-fat-ini and
                        invoice-emb-imp.nr-invoice <= c-fat-fim 
                        no-lock:
            end.
            if not avail invoice-emb-imp then next.
         end.
         for first historico-embarque
           fields(cod-estabel embarque cod-itiner)
              where historico-embarque.cod-estabel = embarque-imp.cod-estabel and
                    historico-embarque.embarque    = embarque-imp.embarque
              no-lock:
         end.
         if not avail historico-embarque then next.
        
         /* ponto eadi */
         ASSIGN i-pto-eadi = INTEGER(TRIM(SUBSTRING(embarque-imp.char-1,81,5))).
         if i-pto-eadi = 0 OR (i-pto-eadi < i-pto-ini OR i-pto-eadi > i-pto-fim) then next.
         
         for first historico-embarque
           fields(dt-efetiva)
              where historico-embarque.cod-estabel = embarque-imp.cod-estabel and
                    historico-embarque.embarque    = embarque-imp.embarque    and                     
                    historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-chegad
                    no-lock:
         end.
         if not avail historico-embarque or historico-embarque.dt-efetiva <> ? then next.
                  
         for first historico-embarque
           fields(dt-efetiva)
              where historico-embarque.cod-estabel = embarque-imp.cod-estabel and
                    historico-embarque.embarque    = embarque-imp.embarque    and                     
                    historico-embarque.cod-pto-contr = i-pto-eadi 
                    no-lock:
         end.
         if avail historico-embarque then
            assign d-dt-efetiva = historico-embarque.dt-efetiva. 
         
         for first invoice-emb-imp
           fields(nr-invoice dt-vencim)
              where invoice-emb-imp.cod-estabel = embarque-imp.cod-estabel and
                    invoice-emb-imp.embarque    = embarque-imp.embarque 
                    no-lock:
         end.
         if avail invoice-emb-imp then 
            assign c-fatura = invoice-emb-imp.nr-invoice
                   d-dt-vencim = invoice-emb-imp.dt-vencim.
         
         for first tt-embarque-imp
              fields(cod-estabel embarque)
              where tt-embarque-imp.cod-estabel = embarque-imp.cod-estabel and
                    tt-embarque-imp.embarque  = embarque-imp.embarque:
         end.
         if not avail tt-embarque-imp then do:
             create tt-embarque-imp.
             assign tt-embarque-imp.cod-estabel = embarque-imp.cod-estabel
                    tt-embarque-imp.embarque    = embarque-imp.embarque
                    tt-embarque-imp.pto-eadi    = i-pto-eadi
                    tt-embarque-imp.dt-efetiva  = d-dt-efetiva
                    tt-embarque-imp.fatura      = c-fatura
                    tt-embarque-imp.dt-vencim   = d-dt-vencim
                    tt-embarque-imp.r-rowid     = rowid(embarque-imp)
                    d-dt-efetiva = ?
                    c-fatura = ""
                    d-dt-vencim = ?.
                ASSIGN i-cont = i-cont + 1. 
                
         end.         
    END.
    
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
        WHEN "dt-efetiva":U THEN ASSIGN pFieldValue = RowObject.dt-efetiva.
        WHEN "dt-vencim":U THEN ASSIGN pFieldValue = RowObject.dt-vencim.
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
        WHEN "pto-eadi":U      THEN ASSIGN pFieldValue = RowObject.pto-eadi.
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
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE {&TABLENAME}.cod-estabel   NO-UNDO.
    DEFINE OUTPUT PARAMETER pembarque LIKE {&TABLENAME}.embarque NO-UNDO.
    
    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pcod-estabel  = RowObject.cod-estabel.
    ASSIGN pembarque = RowObject.embarque.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByEfetiva DBOProgram 
PROCEDURE openQueryByEfetiva :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
            open query {&QUERYNAME} for each tt-embarque-imp 
                                   by tt-embarque-imp.dt-efetiva
                                   BY tt-embarque-imp.embarque INDEXED-REPOSITION.
    
                  
  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByVencto DBOProgram 
PROCEDURE openQueryByVencto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        
        open query {&QUERYNAME} for each tt-embarque-imp 
                                   by tt-embarque-imp.dt-vencim 
                                   BY tt-embarque-imp.embarque INDEXED-REPOSITION.
        
   
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
        FOR EACH tt-embarque-imp NO-LOCK 
        INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFaixa DBOProgram 
PROCEDURE setConstraintFaixa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

 def input parameter p-est-ini  as char.
 def input parameter p-est-fim  as char.
 def input parameter p-emb-ini  as char.
 def input parameter p-emb-fim  as char.
 def input parameter p-proc-ini as char.
 def input parameter p-proc-fim as char.
 def input parameter p-item-ini as char.
 def input parameter p-item-fim as char.
 def input parameter p-fat-ini  as char.
 def input parameter p-fat-fim  as char.
 def input parameter p-pto-ini  as int.
 def input parameter p-pto-fim  as int.
 
 assign c-est-ini  = p-est-ini
        c-est-fim  = p-est-fim
        c-emb-ini  = p-emb-ini
        c-emb-fim  = p-emb-fim
        c-proc-ini = p-proc-ini
        c-proc-fim = p-proc-fim
        c-item-ini = p-item-ini
        c-item-fim = p-item-fim
        c-fat-ini  = p-fat-ini
        c-fat-fim  = p-fat-fim
        i-pto-ini  = p-pto-ini
        i-pto-fim  = p-pto-fim.

 run carregatable.

      RETURN "OK":U.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintquery DBOProgram 
PROCEDURE setConstraintquery :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Quando o zoom Ç executado o browse abre sem registros, esta setconstraint
         atualiza as vari†veis l-query1 e l-query2 que servir∆o de paramentro para
         abertura das querys.      
------------------------------------------------------------------------------*/

 def input parameter p-query1 as log.
 def input parameter p-query2 as log.

 assign l-query1  = p-query1
        l-query2  = p-query2.

 
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
        
        for first tt-embarque-imp fields(cod-estabel embarque)
             WHERE tt-embarque-imp.r-rowid = pRowid.
        end.
        if avail tt-embarque-imp then 
            ASSIGN pRowid = rowid(tt-embarque-imp).
 
/*         for first tt-embarque-imp fields(cod-estabel embarque)
             WHERE tt-embarque-imp.r-rowid = pRowid.
               ASSIGN pRowid = tt-embarque-imp.r-rowid.
        end.*/
        
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
