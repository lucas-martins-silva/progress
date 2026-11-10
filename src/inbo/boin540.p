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
{include/i-prgvrs.i BOIN540 2.00.00.004 } /*** "010004" 17/06/2025 16:40:51 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN540 MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : dbo.p
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
&GLOBAL-DEFINE DBOName BOIN540
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName rep-ic-oper
&GLOBAL-DEFINE TableLabel Item Controle
&GLOBAL-DEFINE QueryName qr{&TableName} 


/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin540.i RowObject}


/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
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

{sfc/sf9002.i} /* pi-converte-data-segs-valor */
def temp-table tt-rep-ic-oper NO-UNDO like rep-ic-oper.
def temp-table tt-rep-ic-oper-tab NO-UNDO like rep-ic-oper-tab.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaRegistro DBOProgram 
PROCEDURE criaRegistro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter table for tt-rep-ic-oper.
def input parameter table for tt-rep-ic-oper-tab.

for each tt-rep-ic-oper ,
         first item-controle where item-controle.cod-ic = tt-rep-ic-oper.cod-ic no-lock :
    find rep-ic-oper where 
         rep-ic-oper.nr-ord-produ = tt-rep-ic-oper.nr-ord-produ and
         rep-ic-oper.num-seq-rep  = tt-rep-ic-oper.num-seq-rep and
         rep-ic-oper.cod-ic       = tt-rep-ic-oper.cod-ic no-lock no-error.
    
    if not avail rep-ic-oper then do:        
        create rep-ic-oper.
        assign rep-ic-oper.nr-ord-produ = tt-rep-ic-oper.nr-ord-produ
               rep-ic-oper.num-seq-rep  = tt-rep-ic-oper.num-seq-rep
               rep-ic-oper.dec-1        = tt-rep-ic-oper.dec-1
               rep-ic-oper.data-1       = tt-rep-ic-oper.data-1
               rep-ic-oper.int-1        = tt-rep-ic-oper.int-1
               rep-ic-oper.cod-ic       = tt-rep-ic-oper.cod-ic.
               
        case item-controle.tip-result:        
            when 1 then /* NumÇrico */
                assign rep-ic-oper.val-result  = tt-rep-ic-oper.val-result
                       rep-ic-oper.des-result = string(tt-rep-ic-oper.val-result, item-controle.formato) no-error.
                       
            when 2 then do: /* Tabela */ 
                assign rep-ic-oper.des-result = "". 
                for each rep-ic-oper-tab of rep-ic-oper EXCLUSIVE-LOCK:
                   delete rep-ic-oper-tab.
                end.   
                
                for each tt-rep-ic-oper-tab :
                    find first c-tab-res where 
                               c-tab-res.nr-tabela = item-controle.nr-tabela and 
                               c-tab-res.sequencia = tt-rep-ic-oper-tab.seq-result no-lock no-error.
                    if not available c-tab-res then next.           
                    create rep-ic-oper-tab.
                    buffer-copy tt-rep-ic-oper-tab to rep-ic-oper-tab
                    assign rep-ic-oper-tab.des-result  = c-tab-res.descricao. 
                    if rep-ic-oper.des-result = "" then
                        assign rep-ic-oper.des-result = c-tab-res.descricao.
                    else    
                        assign rep-ic-oper.des-result = rep-ic-oper.des-result + ", " + c-tab-res.descricao.
                end.    
            end.
            when 3 then /* Observaá∆o */
                assign rep-ic-oper.des-result = tt-rep-ic-oper.des-result.
            when 4 then /* Data */          
                assign rep-ic-oper.dat-result = tt-rep-ic-oper.dat-result
                       rep-ic-oper.des-result = string(tt-rep-ic-oper.dat-result, "99/99/9999").
        end case.       
               
    end.
end.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE eliminaRegistro DBOProgram 
PROCEDURE eliminaRegistro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter p-nr-ord-produ like rep-ic-oper.nr-ord-produ.
def input parameter p-num-seq-rep  like rep-ic-oper.num-seq-rep.

for each rep-ic-oper where rep-ic-oper.nr-ord-produ = p-nr-ord-produ
                       and rep-ic-oper.num-seq-rep  = p-num-seq-rep EXCLUSIVE-LOCK:
    for each rep-ic-oper-tab where 
             rep-ic-oper-tab.nr-ord-produ = rep-ic-oper.nr-ord-produ and
             rep-ic-oper-tab.num-seq-rep  = rep-ic-oper.num-seq-rep EXCLUSIVE-LOCK :                   
        delete rep-ic-oper-tab.
    end.
    delete rep-ic-oper.      
end.
                 
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "cod-ic":U THEN ASSIGN pFieldValue = RowObject.cod-ic.
        WHEN "des-result":U THEN ASSIGN pFieldValue = RowObject.des-result.
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
        WHEN "dat-result":U THEN ASSIGN pFieldValue = RowObject.dat-result.
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
        WHEN "val-result":U THEN ASSIGN pFieldValue = RowObject.val-result.
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
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "nr-ord-produ":U THEN ASSIGN pFieldValue = RowObject.nr-ord-produ.
        WHEN "num-seq-rep":U THEN ASSIGN pFieldValue = RowObject.num-seq-rep.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice id
  Parameters:  
               retorna valor do campo nr-ord-produ
               retorna valor do campo num-seq-rep
               retorna valor do campo cod-ic
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnr-ord-produ LIKE rep-ic-oper.nr-ord-produ NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-seq-rep LIKE rep-ic-oper.num-seq-rep NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-ic LIKE rep-ic-oper.cod-ic NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnr-ord-produ = RowObject.nr-ord-produ
           pnum-seq-rep = RowObject.num-seq-rep
           pcod-ic = RowObject.cod-ic.

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
  Purpose:     Reposiciona registro com base no °ndice id
  Parameters:  
               recebe valor do campo nr-ord-produ
               recebe valor do campo num-seq-rep
               recebe valor do campo cod-ic
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-ord-produ LIKE rep-ic-oper.nr-ord-produ NO-UNDO.
    DEFINE INPUT PARAMETER pnum-seq-rep LIKE rep-ic-oper.num-seq-rep NO-UNDO.
    DEFINE INPUT PARAMETER pcod-ic LIKE rep-ic-oper.cod-ic NO-UNDO.

    FIND FIRST bfrep-ic-oper WHERE 
        bfrep-ic-oper.nr-ord-produ = pnr-ord-produ AND 
        bfrep-ic-oper.num-seq-rep = pnum-seq-rep AND 
        bfrep-ic-oper.cod-ic = pcod-ic NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfrep-ic-oper THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfrep-ic-oper)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE modificaRegistro DBOProgram 
PROCEDURE modificaRegistro :
/*----------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter table for tt-rep-ic-oper.
def input parameter table for tt-rep-ic-oper-tab.

for each tt-rep-ic-oper no-lock:
    
    find rep-ic-oper where 
         rep-ic-oper.nr-ord-produ = tt-rep-ic-oper.nr-ord-produ and
         rep-ic-oper.num-seq-rep  = tt-rep-ic-oper.num-seq-rep and
         rep-ic-oper.cod-ic       = tt-rep-ic-oper.cod-ic exclusive-lock no-error.

    find first item-controle of rep-ic-oper no-lock no-error.
        
    if avail item-controle then do:
        case item-controle.tip-result:        
            when 1 then /* NumÇrico */
                assign rep-ic-oper.val-result  = tt-rep-ic-oper.val-result
                       rep-ic-oper.des-result = string(tt-rep-ic-oper.val-result, item-controle.formato) no-error.
                       
            when 2 then do: /* Tabela */ 
                assign rep-ic-oper.des-result = "".
                
                for each rep-ic-oper-tab of rep-ic-oper EXCLUSIVE-LOCK:
                   delete rep-ic-oper-tab.
                end.    
                 
                for each tt-rep-ic-oper-tab :
                    find first c-tab-res where 
                               c-tab-res.nr-tabela = item-controle.nr-tabela and 
                               c-tab-res.sequencia = tt-rep-ic-oper-tab.seq-result no-lock no-error.
                    if not available c-tab-res then next.           
                    create rep-ic-oper-tab.
                    buffer-copy tt-rep-ic-oper-tab to rep-ic-oper-tab
                    assign rep-ic-oper-tab.des-result  = c-tab-res.descricao. 
                    if rep-ic-oper.des-result = "" then
                        assign rep-ic-oper.des-result = c-tab-res.descricao.
                    else    
                        assign rep-ic-oper.des-result = rep-ic-oper.des-result + ", " + c-tab-res.descricao.
                end.
            end.
            when 3 then /* Observaá∆o */
                assign rep-ic-oper.des-result = tt-rep-ic-oper.des-result.
            when 4 then /* Data */          
                assign rep-ic-oper.dat-result = tt-rep-ic-oper.dat-result
                       rep-ic-oper.des-result = string(tt-rep-ic-oper.dat-result, "99/99/9999").
        end case.        
    end.
end.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
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


