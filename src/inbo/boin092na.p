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
{include/i-prgvrs.i BOIN092NA 2.00.00.010} /*** "010010" 13/11/2023 11:45:48 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin092na MUT}
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
&GLOBAL-DEFINE DBOName BOIN092
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName dupli-apagar
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 


/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin092.i RowObject}


/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/* Miniflexibilizaá∆o CÉmbio */
{cdp/cdcfgfin.i}

/* local variable definitions */
def var c-serie-docto  as char no-undo.
def var c-nro-docto    as char no-undo.
def var i-cod-emitente as int  no-undo.
def var c-nat-operacao as char no-undo.     

def temp-table tt-documentos
    field nr-documento  as character
    field tipo          as integer
    field dt-trans      as date.

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
        WHEN "cod-esp":U THEN ASSIGN pFieldValue = RowObject.cod-esp.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        &IF "{&mguni_version}" >= "2.071" &THEN
        WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
        &ENDIF
        WHEN "cod-imp-irf":U THEN ASSIGN pFieldValue = RowObject.cod-imp-irf.
        WHEN "esp-irf":U THEN ASSIGN pFieldValue = RowObject.esp-irf.
        WHEN "historico":U THEN ASSIGN pFieldValue = RowObject.historico.
        WHEN "nat-operacao":U THEN ASSIGN pFieldValue = RowObject.nat-operacao.
        WHEN "nr-duplic":U THEN ASSIGN pFieldValue = RowObject.nr-duplic.
        WHEN "nro-docto":U THEN ASSIGN pFieldValue = RowObject.nro-docto.
        WHEN "observacao":U THEN ASSIGN pFieldValue = RowObject.observacao.
        WHEN "parcela":U THEN ASSIGN pFieldValue = RowObject.parcela.
        WHEN "serie-docto":U THEN ASSIGN pFieldValue = RowObject.serie-docto.
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
        WHEN "dt-emissao":U THEN ASSIGN pFieldValue = RowObject.dt-emissao.
        WHEN "dt-trans":U THEN ASSIGN pFieldValue = RowObject.dt-trans.
        WHEN "dt-venc-desc":U THEN ASSIGN pFieldValue = RowObject.dt-venc-desc.
        WHEN "dt-vencim":U THEN ASSIGN pFieldValue = RowObject.dt-vencim.
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
        WHEN "aliq-irf":U THEN ASSIGN pFieldValue = RowObject.aliq-irf.
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "desconto":U THEN ASSIGN pFieldValue = RowObject.desconto.
        WHEN "imposto-inss":U THEN ASSIGN pFieldValue = RowObject.imposto-inss.
        WHEN "imposto-ir":U THEN ASSIGN pFieldValue = RowObject.imposto-ir.
        WHEN "imposto-iss":U THEN ASSIGN pFieldValue = RowObject.imposto-iss.
        WHEN "perc-juros":U THEN ASSIGN pFieldValue = RowObject.perc-juros.
        WHEN "perc-mora":U THEN ASSIGN pFieldValue = RowObject.perc-mora.
        WHEN "Valor-a-pagar-me":U THEN ASSIGN pFieldValue = RowObject.Valor-a-pagar-me.
        WHEN "vl-a-pagar":U THEN ASSIGN pFieldValue = RowObject.vl-a-pagar.
        WHEN "vl-a-pagar-mo":U THEN ASSIGN pFieldValue = RowObject.vl-a-pagar-mo.
        WHEN "vl-ap-fasb[1]":U THEN ASSIGN pFieldValue = RowObject.vl-ap-fasb[1].
        WHEN "vl-ap-fasb[2]":U THEN ASSIGN pFieldValue = RowObject.vl-ap-fasb[2].
        WHEN "vl-desconto":U THEN ASSIGN pFieldValue = RowObject.vl-desconto.
        WHEN "vl-descto-mo":U THEN ASSIGN pFieldValue = RowObject.vl-descto-mo.
        WHEN "vl-frete":U THEN ASSIGN pFieldValue = RowObject.vl-frete.
        WHEN "vl-outros":U THEN ASSIGN pFieldValue = RowObject.vl-outros.
        WHEN "vl-taxa":U THEN ASSIGN pFieldValue = RowObject.vl-taxa.
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
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "cod-ret-irf":U THEN ASSIGN pFieldValue = RowObject.cod-ret-irf.
        WHEN "dia-util-irf":U THEN ASSIGN pFieldValue = RowObject.dia-util-irf.
        WHEN "dias-atraso":U THEN ASSIGN pFieldValue = RowObject.dias-atraso.
        &IF "{&mguni_version}" < "2.071" &THEN
        WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
        &ENDIF
        WHEN "esp-movto":U THEN ASSIGN pFieldValue = RowObject.esp-movto.
        WHEN "estado-cq":U THEN ASSIGN pFieldValue = RowObject.estado-cq.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "mo-codigo":U THEN ASSIGN pFieldValue = RowObject.mo-codigo.
        WHEN "tp-despesa":U THEN ASSIGN pFieldValue = RowObject.tp-despesa.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice documento
  Parameters:  
               retorna valor do campo serie-docto
               retorna valor do campo nro-docto
               retorna valor do campo cod-emitente
               retorna valor do campo nat-operacao
               retorna valor do campo parcela
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pserie-docto LIKE dupli-apagar.serie-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pnro-docto LIKE dupli-apagar.nro-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE dupli-apagar.cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pnat-operacao LIKE dupli-apagar.nat-operacao NO-UNDO.
    DEFINE OUTPUT PARAMETER pparcela LIKE dupli-apagar.parcela NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pserie-docto = RowObject.serie-docto
           pnro-docto = RowObject.nro-docto
           pcod-emitente = RowObject.cod-emitente
           pnat-operacao = RowObject.nat-operacao
           pparcela = RowObject.parcela.

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
  Purpose:     Reposiciona registro com base no °ndice documento
  Parameters:  
               recebe valor do campo serie-docto
               recebe valor do campo nro-docto
               recebe valor do campo cod-emitente
               recebe valor do campo nat-operacao
               recebe valor do campo parcela
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pserie-docto LIKE dupli-apagar.serie-docto NO-UNDO.
    DEFINE INPUT PARAMETER pnro-docto LIKE dupli-apagar.nro-docto NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente LIKE dupli-apagar.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pnat-operacao LIKE dupli-apagar.nat-operacao NO-UNDO.
    DEFINE INPUT PARAMETER pparcela LIKE dupli-apagar.parcela NO-UNDO.

    FIND FIRST bfdupli-apagar WHERE 
        bfdupli-apagar.serie-docto = pserie-docto AND 
        bfdupli-apagar.nro-docto = pnro-docto AND 
        bfdupli-apagar.cod-emitente = pcod-emitente AND 
        bfdupli-apagar.nat-operacao = pnat-operacao AND 
        bfdupli-apagar.parcela = pparcela NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfdupli-apagar THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfdupli-apagar)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  open query qr{&tableName} for each {&tableName}
       no-lock
       indexed-reposition.
       
       
  return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOfDocumEst DBOProgram 
PROCEDURE openQueryOfDocumEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
   open query qr{&tableName} for each {&tableName} where 
                                      {&tableName}.serie-docto  = c-serie-docto  and
                                      {&tableName}.nro-docto    = c-nro-docto    and
                                      {&tableName}.cod-emitente = i-cod-emitente and
                                      {&tableName}.nat-operacao = c-nat-operacao      
                                      no-lock indexed-reposition.        

   return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-documentos DBOProgram 
PROCEDURE pi-busca-documentos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  parameter p-serie-docto    as  character no-undo.
    def input  parameter p-nro-docto      as  character no-undo.
    def input  parameter p-cod-emitente   as  integer   no-undo.
    def input  parameter p-nat-operacao   as  character no-undo.
    def input  parameter p-parcela        as  character no-undo.
    def output parameter table            for tt-documentos.    

    def var h-boin090na as handle no-undo.

    &if defined(BF_FIN_MODUL_CAMBIO) &then
        find first param-global no-lock no-error.
        if param-global.modulo-mec = yes then do:
            find first dupli-apagar no-lock
                 where dupli-apagar.serie-docto  = p-serie-docto
                 and   dupli-apagar.nro-docto    = p-nro-docto
                 and   dupli-apagar.cod-emitente = p-cod-emitente
                 and   dupli-apagar.nat-operacao = p-nat-operacao
                 and   dupli-apagar.parcela      = p-parcela      no-error.
            if avail dupli-apagar then do:
                run inbo/boin090na.p persistent set h-boin090na.
                run pi-busca-documentos in h-boin090na (input  dupli-apagar.serie-docto,
                                                        input  dupli-apagar.nro-docto,
                                                        input  dupli-apagar.cod-emitente,
                                                        input  dupli-apagar.nat-operacao,
                                                        output table tt-documentos).
                delete procedure h-boin090na.
                assign h-boin090na = ?.        
            end.
        end.
    &endif

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintOfDocumEst DBOProgram 
PROCEDURE setConstraintOfDocumEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   def input param prDocumEst as rowid no-undo.

   find first docum-est where rowid(docum-est) = prDocumEst no-lock no-error. 

   assign c-serie-docto  = docum-est.serie-docto 
          c-nro-docto    = docum-est.nro-docto
          i-cod-emitente = docum-est.cod-emitente
          c-nat-operacao = docum-est.nat-operacao.     

   return "OK":U.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintOfDocumEst1 DBOProgram 
PROCEDURE setConstraintOfDocumEst1 :
/*------------------------------------------------------------------------------
  Purpose: Esta setconstraint foi criada para correá∆o da setConstraintOfDocumEst
           pois verificou-se que a mesma esta com erro: deveria ter  passado   os 
           campos da tabela e n∆o o rowid.                
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input param pc-serie-docto  as char no-undo.
def input param pc-nro-docto    as char no-undo.
def input param pi-cod-emitente as int  no-undo.
def input param pc-nat-operacao as char no-undo.

   assign c-serie-docto  = pc-serie-docto 
          c-nro-docto    = pc-nro-docto
          i-cod-emitente = pi-cod-emitente
          c-nat-operacao = pc-nat-operacao.     
   
   return "OK":U.
 
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


