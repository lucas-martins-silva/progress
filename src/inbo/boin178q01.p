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
{include/i-prgvrs.i BOIN178Q01 2.00.00.008} /*** "010008" 23/11/2023 16:19:44  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN178Q01 MUT}
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
&GLOBAL-DEFINE DBOName item-fornec
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName tt-item-fornec
&GLOBAL-DEFINE TableLabel tt-item-fornec
&GLOBAL-DEFINE QueryName qr{&TableName}

/*********************************************************************************
**  S¢ a DBO principal (boin178.p) est† com as funá‰es de inclui (createRecord), 
**  modifica (updateRecord) e elimina (deleteRecord) habilitadas, 
**  porque S‡ nela foram implementadas as triggers do dicion†rio.
**  Para desabilitar as procedures foram usados os prÇ-processadores abaixo.
**  A procedure validateRecord dessa DBO n∆o deve ser usada.
*********************************************************************************/
&GLOBAL-DEFINE EXCLUDE-createRecord 0
&GLOBAL-DEFINE EXCLUDE-updateRecord 0
&GLOBAL-DEFINE EXCLUDE-deleteRecord 0
&GLOBAL-DEFINE EXCLUDE-getRowid 0

/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com
      extens∆o .i ---*/
      
{inbo/boin178q01.i tt-item-fornec}

{inbo/boin178q01.i RowObject}

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
         HEIGHT             = 18.95
         WIDTH              = 55.6.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaAquisiá‰esTTItemFornec DBOProgram 
PROCEDURE carregaAquisiá‰esTTItemFornec :
/*------------------------------------------------------------------------------
  Purpose:     Procedure carrega a temp-table TT-item-fornec de acordo com o tipo de controle, 
               com  as £ltimas aquisiá‰es do item
  Parameters:  
       ipar1 : p-chave            : rowid corrente da tabela de itens
       ipar2 : p-cod-emitente-ini : c¢digo do fornecedor inicial p/ perfil do usuario
       ipar3 : p-cod-emitente-fim : c¢digo do fornecedor final   p/ perfil do usuario
  Notes:       
------------------------------------------------------------------------------*/
        
    def input param p-chave            as rowid no-undo.
    def input param p-cod-emitente-ini as int no-undo.
    def input param p-cod-emitente-fim as int no-undo.
    
    find first item where rowid(item) = p-chave no-lock no-error.
    if  avail item then do:
      if  item.tipo-contr <> 4 then do:
         for each item-fornec where item-fornec.it-codigo    =  item.it-codigo     and
                                    item-fornec.cod-emitente >= p-cod-emitente-ini and 
                                    item-fornec.cod-emitente <= p-cod-emitente-fim 
                                    no-lock:
            find first emitente where emitente.cod-emitente = item-fornec.cod-emitente no-lock no-error.
            if avail emitente then do:            
               create tt-item-fornec.
               buffer-copy item-fornec to tt-item-fornec.
               assign tt-item-fornec.r-rowid     = rowid(emitente)
                      tt-item-fornec.perc-compra = item-fornec.perc-compra
                      tt-item-fornec.c-desc      = if avail emitente then emitente.nome-abrev else "".
            end.
        end.
     end.
     else do:
     for each recebimento where recebimento.it-codigo = item.it-codigo and
                                recebimento.cod-emitente >= p-cod-emitente-ini and 
                                recebimento.cod-emitente <= p-cod-emitente-fim 
                                no-lock:
       if not can-find (tt-item-fornec where
                        tt-item-fornec.it-codigo    = item.it-codigo and
                        tt-item-fornec.cod-emitente = recebimento.cod-emitente)  then do:
         find emitente where emitente.cod-emitente = recebimento.cod-emitente  no-lock no-error.
         if avail emitente then    
            create tt-item-fornec.
            assign tt-item-fornec.it-codigo    = item.it-codigo
                   tt-item-fornec.cod-emitente = recebimento.cod-emitente
                   tt-item-fornec.item-do-forn = item.it-codigo
                   tt-item-fornec.unid-med-for = ""
                   tt-item-fornec.c-desc       = if avail emitente then emitente.nome-abrev else ""
                   tt-item-fornec.r-rowid = rowid(emitente).
         end.
       end.
     end.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaTTItemfornec2 DBOProgram 
PROCEDURE carregaTTItemfornec2 :
/**
   Essa procedure e utilizada para carregar a temp-table da item-fornec,
   de acordo com os parametros que lhe e passado.
**/
    
    def input parameter p-fm-codigo as char no-undo.
    def input parameter p-emitente-ini as integer no-undo.
    def input parameter p-emitente-fim as integer no-undo.
    
    def var c-fm-codigo as char no-undo.
    def var i-cod-emitente-ini as integer no-undo.
    def var i-cod-emitente-fim as integer no-undo.
    def var c-nome-emit as char no-undo.
   
    assign c-fm-codigo        = p-fm-codigo
           i-cod-emitente-ini = p-emitente-ini
           i-cod-emitente-fim = p-emitente-fim.
   
    find familia where
         familia.fm-codigo = c-fm-codigo no-lock no-error.
         
    if avail familia then do:      
        for each  item where 
                  item.fm-codigo = familia.fm-codigo no-lock,
            each  item-fornec no-lock where
                  item-fornec.it-codigo = item.it-codigo         and
                  item-fornec.cod-emitente >= i-cod-emitente-ini and
                  item-fornec.cod-emitente <= i-cod-emitente-fim 
            break by item-fornec.cod-emitente:

            find emitente where
                 emitente.cod-emitente = item-fornec.cod-emitente no-lock no-error.
            if avail emitente then do:
                assign c-nome-emit = emitente.nome-emit.
            end.
            else 
                assign c-nome-emit = "".

            if  first-of(item-fornec.cod-emitente) then do:
                create tt-item-fornec.
                assign 
                       tt-item-fornec.cod-emitente = item-fornec.cod-emitente
                       tt-item-fornec.c-desc       = c-nome-emit.
                       
            end.          
        end. 
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
        WHEN "item-do-forn":U THEN ASSIGN pFieldValue = RowObject.item-do-forn.
        WHEN "unid-med-for":U THEN ASSIGN pFieldValue = RowObject.unid-med-for.
        WHEN "c-desc":U THEN ASSIGN pFieldValue = RowObject.c-desc.
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
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "perc-compra":U THEN ASSIGN pFieldValue = RowObject.perc-compra.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice ONDE-COMPRA
  Parameters:
               retorna valor dos campos do °ndice ONDE-COMPRA
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pit-codigo LIKE item-fornec.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE item-fornec.cod-emitente NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pit-codigo = RowObject.it-codigo.
    ASSIGN pcod-emitente = RowObject.cod-emitente.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice ONDE-COMPRA
  Parameters:
               recebe valor dos campos do °ndice ONDE-COMPRA
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pit-codigo LIKE item-fornec.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente LIKE item-fornec.cod-emitente NO-UNDO.

    FIND FIRST bftt-item-fornec WHERE
        bftt-item-fornec.it-codigo = pit-codigo AND
        bftt-item-fornec.cod-emitente = pcod-emitente
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bftt-item-fornec THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bftt-item-fornec)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

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
            run openQueryStatic("Main":U).
    end case.
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
    OPEN QUERY {&QueryName} FOR EACH tt-item-fornec NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRowid Method-Library 
PROCEDURE getRowid :
/*------------------------------------------------------------------------------
  Purpose:     Envia rowid do registro corrente da table {&Tablename}
  Parameters:  retorna rowid - FOI CUSTOMIZADO PORQUE ESSA BO TRABALHA COM TEMP-TABLE
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pRowid  AS ROWID NO-UNDO.

    IF NOT AVAILABLE {&TableName} THEN DO:
        /*--- Erro 3: Tabela {&TableLabel} n∆o dispon°vel ---*/
        {method/svc/errors/inserr.i &ErrorNumber="3"
                                    &ErrorType="INTERNAL"
                                    &ErrorSubType="ERROR"}
        RETURN "NOK":U.
    END.

    /*--- Executa m≤todos sobrepostos (before/after) ---*/
    {method/svc/override/override.i &Position="Before"
                                    &Procedure="getRowid"
                                    &Parameters="INPUT-OUTPUT pRowid"}
    IF lOverrideExecuted AND RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    ASSIGN pRowid = {&TableName}.r-rowid.

    /*--- Executa m≤todos sobrepostos (before/after) ---*/
    {method/svc/override/override.i &Position="After"
                                    &Procedure="getRowid"
                                    &Parameters="INPUT-OUTPUT pRowid"}
    IF lOverrideExecuted AND RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

