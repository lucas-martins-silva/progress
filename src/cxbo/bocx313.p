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
{include/i-prgvrs.i BOCX313 2.00.00.011 } /*** "010011" 11/12/2023 10:13:23 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOCX313 MUT}
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
&GLOBAL-DEFINE DBOName Pedido-drb-DI
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName Pedido-drb-DI
&GLOBAL-DEFINE TableLabel Pedido-drb-DI
&GLOBAL-DEFINE QueryName qr{&TableName}

/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com
      extens∆o .i ---*/
{cxbo/bocx313.i RowObject}
{cxbo/bocx313.i tt-pedido-drb-di}

/* Abaixo a definiá∆o da temp-table para a procedure copyRecordDI */
def temp-table tt-pedido-temp NO-UNDO like pedido-drb-DI.

def var c-pedido  as char no-undo.
def var c-estabel as char no-undo.
def var c-di      as char no-undo.
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
         HEIGHT             = 13.46
         WIDTH              = 41.43.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE copyRecordDI DBOProgram 
PROCEDURE copyRecordDI :
/*------------------------------------------------------------------------------
  Purpose: Copiar registros existentes na pedido-drb-DI alterando apenas
           o numero pedido drawback e codigo do estabelecimento    
  
  Parameters: codigo estabelecimento c-estabe(novo/original) c-estabe e numero de pedido
              drawback (novo/Original) c-pedido
  
  Notes:       
------------------------------------------------------------------------------*/
    def input param c-estabe as char no-undo.
    def input param c-pedido as char no-undo.
    def input param c-estabe-novo as char no-undo.
    def input param c-pedido-novo as char no-undo.
    
    for each pedido-drb-DI NO-LOCK
        where pedido-drb-DI.cod-estabel   = c-estabe 
          and pedido-drb-DI.nr-pedido-drb = c-pedido use-index ch-di:
        create tt-pedido-temp.
        buffer-copy pedido-drb-DI to tt-pedido-temp.
    end.
    
    for each tt-pedido-temp NO-LOCK:
        create pedido-drb-di.
        assign pedido-drb-di.cod-estabel       = c-estabe-novo
               pedido-drb-di.nr-pedido-drb     = c-pedido-novo
               pedido-drb-di.declaracao-import = tt-pedido-temp.declaracao-import
               pedido-drb-di.data-1            = tt-pedido-temp.data-1
               pedido-drb-di.data-2            = tt-pedido-temp.data-2
               pedido-drb-di.char-1            = tt-pedido-temp.char-1
               pedido-drb-di.char-2            = tt-pedido-temp.char-2
               pedido-drb-di.int-1             = tt-pedido-temp.int-1
               pedido-drb-di.int-2             = tt-pedido-temp.int-2
               pedido-drb-di.log-1             = tt-pedido-temp.log-1
               pedido-drb-di.log-2             = tt-pedido-temp.log-2.
        delete tt-pedido-temp.
    end.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createRecordDi DBOProgram 
PROCEDURE createRecordDi :
/*------------------------------------------------------------------------------
  Purpose: Criar registros na tabela pedido-drb-Di    
  Parameters: Estabelecimento, codigo do pedido e tt-pedido-drb-re
  Notes:       
------------------------------------------------------------------------------*/
    def input param c-estabe as char no-undo.
    def input param c-pedido as char no-undo.
    def input param table for tt-pedido-drb-di.
    
    for each tt-pedido-drb-di NO-LOCK
        where tt-pedido-drb-di.cod-estabel   = c-estabe 
          and tt-pedido-drb-di.nr-pedido-drb = c-pedido:
          
        if avail tt-pedido-drb-di then do:              
            create pedido-drb-di.
            assign pedido-drb-di.cod-estabel       = c-estabe
                   pedido-drb-di.nr-pedido-drb     = c-pedido
                   pedido-drb-di.declaracao-import = tt-pedido-drb-di.declaracao-import
                   pedido-drb-di.data-1            = tt-pedido-drb-di.data-1
                   pedido-drb-di.data-2            = tt-pedido-drb-di.data-2
                   pedido-drb-di.char-1            = tt-pedido-drb-di.char-1
                   pedido-drb-di.char-2            = tt-pedido-drb-di.char-2
                   pedido-drb-di.int-1             = tt-pedido-drb-di.int-1
                   pedido-drb-di.int-2             = tt-pedido-drb-di.int-2
                   pedido-drb-di.log-1             = tt-pedido-drb-di.log-1
                   pedido-drb-di.log-2             = tt-pedido-drb-di.log-2.
        end.  
    end.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE eliminaDI DBOProgram 
PROCEDURE eliminaDI :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param p-estabel like pedido-drb.cod-estabel   no-undo.
    def input param p-pedido  like pedido-drb.nr-pedido-drb no-undo.
    
    for each bf{&TableName} 
        where bf{&TableName}.cod-estabel   = p-estabel 
          and bf{&TableName}.nr-pedido-drb = p-pedido exclusive-lock:
        delete bf{&TableName}.
    end.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE eliminaDINfe DBOProgram 
PROCEDURE eliminaDINfe :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-nr-pedido-drb LIKE pedido-drb.nr-pedido-drb        NO-UNDO.
    DEF INPUT PARAM p-cod-estabel   LIKE pedido-drb.cod-estabel          NO-UNDO.
    DEF INPUT PARAM p-decla-import  LIKE pedido-drb-di.declaracao-import NO-UNDO.


    IF NOT CAN-FIND(FIRST ped-draw-nfe 
                        WHERE ped-draw-nfe.cod-estab    = p-cod-estabel
                        AND   ped-draw-nfe.cod-ped-draw = p-nr-pedido-drb
                        AND   TRIM(SUBSTRING(ped-draw-nfe.cod-livre-1,1,20)) = p-decla-import ) THEN DO:
    
        FIND FIRST pedido-drb-di EXCLUSIVE-LOCK
            WHERE pedido-drb-di.cod-estabel       = p-cod-estabel
            AND   pedido-drb-di.nr-pedido-drb     = p-nr-pedido-drb
            AND   pedido-drb-di.declaracao-import = p-decla-import NO-ERROR.
        DELETE pedido-drb-di.
    END.

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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "declaracao-import":U THEN ASSIGN pFieldValue = RowObject.declaracao-import.
        WHEN "nr-pedido-drb":U THEN ASSIGN pFieldValue = RowObject.nr-pedido-drb.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
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
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice CH-DI
  Parameters:
               retorna valor dos campos do °ndice CH-DI
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE Pedido-drb-DI.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-pedido-drb LIKE Pedido-drb-DI.nr-pedido-drb NO-UNDO.
    DEFINE OUTPUT PARAMETER pdeclaracao-import LIKE Pedido-drb-DI.declaracao-import NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pcod-estabel = RowObject.cod-estabel.
    ASSIGN pnr-pedido-drb = RowObject.nr-pedido-drb.
    ASSIGN pdeclaracao-import = RowObject.declaracao-import.

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
  Purpose:     Reposiciona registro com base no °ndice CH-DI
  Parameters:
               recebe valor dos campos do °ndice CH-DI
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE Pedido-drb-DI.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pnr-pedido-drb LIKE Pedido-drb-DI.nr-pedido-drb NO-UNDO.
    DEFINE INPUT PARAMETER pdeclaracao-import LIKE Pedido-drb-DI.declaracao-import NO-UNDO.

    FOR FIRST bfPedido-drb-DI NO-LOCK WHERE
              bfPedido-drb-DI.cod-estabel       = pcod-estabel     AND
              bfPedido-drb-DI.nr-pedido-drb     = pnr-pedido-drb   AND
              bfPedido-drb-DI.declaracao-import = pdeclaracao-import:
    END.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfPedido-drb-DI THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfPedido-drb-DI)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToPedidoDi DBOProgram 
PROCEDURE goToPedidoDi :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice CH-DI
  Parameters:
               recebe valor dos campos do °ndice CH-DI
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE Pedido-drb-DI.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pnr-pedido-drb LIKE Pedido-drb-DI.nr-pedido-drb NO-UNDO.
    
    FIND FIRST bfPedido-drb-DI WHERE
        bfPedido-drb-DI.cod-estabel = pcod-estabel AND
        bfPedido-drb-DI.nr-pedido-drb = pnr-pedido-drb
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfPedido-drb-DI THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfPedido-drb-DI)).
    
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkTott-Pedido-drb DBOProgram 
PROCEDURE linkTott-Pedido-drb :
def input param h-proc as handle no-undo.
    
    RUN GetKey in h-proc (output c-estabel,
                          output c-pedido).
   
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
        when 1 then 
           run openQueryStatic ("Main").
        when 2 then 
           run openQueryStatic ("DibyPedidoDrb").           
    end case. /*end case*/
   
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDibyPedidoDrb DBOProgram 
PROCEDURE openQueryDibyPedidoDrb :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH Pedido-drb-DI where 
                                     Pedido-drb-di.cod-estabel   = c-estabel and
                                     Pedido-drb-di.nr-pedido-drb = c-pedido 
                                     use-index ch-di
                                     NO-LOCK INDEXED-REPOSITION.
                                     
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDibyRowidPedidoDrb DBOProgram 
PROCEDURE openQueryDibyRowidPedidoDrb :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH Pedido-drb-DI where 
                                     Pedido-drb-di.cod-estabel   = c-estabel and
                                     Pedido-drb-di.nr-pedido-drb = c-pedido
                                     use-index ch-di
                                     NO-LOCK INDEXED-REPOSITION.
                                     
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
    OPEN QUERY {&QueryName} FOR EACH Pedido-drb-DI NO-LOCK INDEXED-REPOSITION.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintDibyPedidoDrb DBOProgram 
PROCEDURE setConstraintDibyPedidoDrb :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER ppedido  AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pestabel AS CHARACTER NO-UNDO.
    
    for first pedido-drb fields(cod-estabel nr-pedido-drb) no-lock
        where pedido-drb.cod-estabel   = pestabel 
          and pedido-drb.nr-pedido-drb = ppedido:
    end.
    
    if avail pedido-drb then
        assign c-pedido  = pedido-drb.nr-pedido-drb
               c-estabel = pedido-drb.cod-estabel.
               
    RETURN "OK":U.           
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintDibyRowidPedidoDrb DBOProgram 
PROCEDURE setConstraintDibyRowidPedidoDrb :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER rpedido  AS rowid NO-UNDO.
    
    for first pedido-drb fields(cod-estabel nr-pedido-drb) no-lock  
        where rowid(pedido-drb) = rpedido:
    end.
    
    if avail pedido-drb then                 
        assign c-pedido  = pedido-drb.nr-pedido-drb
               c-estabel = pedido-drb.cod-estabel.
               
    RETURN "OK":U.           
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
    
    if pType = "Create" then do:
        find first embarque-imp 
            where embarque-imp.declaracao-import = rowObject.declaracao-import no-lock no-error.
        if not avail embarque-imp then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-embarque-imp AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Embarque_Imp" *}
            ASSIGN c-lbl-liter-embarque-imp = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                                &ErrorNumber="2"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" 
                                &ErrorParameters="c-lbl-liter-embarque-imp"}
        end.
        else do:
            if embarque-imp.cod-estabel <> rowObject.cod-estabel then do:  
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-processo-importacao AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Processo_Importaá∆o" *}
                ASSIGN c-lbl-liter-processo-importacao = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                                &ErrorNumber="25043"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" 
                                &ErrorParameters="c-lbl-liter-processo-importacao"}
            end.
        end.
        
        if rowObject.declaracao-import = "" then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-declaracao-importacao AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Declaracao_Importaá∆o" *}
            ASSIGN c-lbl-liter-declaracao-importacao = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                                &ErrorNumber="265"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" 
                                &ErrorParameters="c-lbl-liter-declaracao-importacao"}
        end.
        
    end.
    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaPedidoDI DBOProgram 
PROCEDURE verificaPedidoDI :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT  PARAM pDeclaracaoImport LIKE pedido-drb-di.declaracao-import NO-UNDO.
    
    find first pedido-drb-di where 
         pedido-drb-di.declaracao-import = pDeclaracaoImport no-lock no-error.

    if avail pedido-drb-di THEN
        RETURN "NOK":U.

    RETURN "OK":U.        

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

