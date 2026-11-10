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
{include/i-prgvrs.i BOAD358 2.00.00.013} /*** "010013" 10/06/2025 09:30:38 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boad358 MUT}
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
&GLOBAL-DEFINE DBOName            BOAD358
&GLOBAL-DEFINE DBOVersion         1.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName          crta-remessa-exp
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName          qr{&TableName} 


/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{adbo/boad358.i RowObject}

/**** Miniflexibilizacao ****/
{cdp/cdcfgfin.i}
{include/i_dbvers.i}

/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

def temp-table tt-crta-remessa-exp no-undo like crta-remessa-exp
   field r-rowid as rowid.

/*** dados para impressao da carta ***/
{ecp/ec0010.i}

def var c-cod-estabel-ini     like crta-remessa-exp.cod-estabel     no-undo.
def var c-cod-estabel-fim     like crta-remessa-exp.cod-estabel     no-undo.
def var c-nr-crta-remessa-ini like crta-remessa-exp.nr-crta-remessa no-undo.
def var c-nr-crta-remessa-fim like crta-remessa-exp.nr-crta-remessa no-undo.

&IF "{&mguni_version}" >= "2.07A" &THEN
def var i-ep-codigo LIKE empresa.ep-codigo no-undo.
&ELSE
def var i-ep-codigo as int no-undo.
&ENDIF
def var c-cod-estabel as char no-undo.
def var c-nr-crta-remessa as char no-undo.
DEF VAR l-func-alt-car-rem AS LOG NO-UNDO.

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


/* ***************************  Main Block  *************************** */
    {include/getdefinedfunction.i}
    /* Verificar se funØ o especial estò habilitada */
    assign l-func-alt-car-rem = &if defined(BF_FIN_ALTERA_CARTA_REM) &then yes &else GetDefinedFunction("SPP-ALT-CAR-REM") &endif.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BeforeDeleteRecord DBOProgram 
PROCEDURE BeforeDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   for each crta-remessa-titulo of RowObject:
      delete crta-remessa-titulo.
   end.
   
   for each crta-remessa-docto-exp of RowObject:
      delete crta-remessa-docto-exp.
   end.
   
   for each crta-remessa-docto-pend-exp of RowObject:
      delete crta-remessa-docto-pend-exp.
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
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        &IF "{&mguni_version}" >= "2.07A" &THEN
            WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
        &ENDIF
        WHEN "c-time":U THEN ASSIGN pFieldValue = RowObject.c-time.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "desc-destino":U THEN ASSIGN pFieldValue = RowObject.desc-destino.
        WHEN "nr-contrato":U THEN ASSIGN pFieldValue = RowObject.nr-contrato.
        WHEN "nr-crta-remessa":U THEN ASSIGN pFieldValue = RowObject.nr-crta-remessa.
        WHEN "nr-referencia-bco":U THEN ASSIGN pFieldValue = RowObject.nr-referencia-bco.
        WHEN "usuario":U THEN ASSIGN pFieldValue = RowObject.usuario.
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
        WHEN "dt-contrato":U THEN ASSIGN pFieldValue = RowObject.dt-contrato.
        WHEN "dt-emissao":U THEN ASSIGN pFieldValue = RowObject.dt-emissao.
        WHEN "dt-preparacao":U THEN ASSIGN pFieldValue = RowObject.dt-preparacao.
        WHEN "dt-protocolo-bco":U THEN ASSIGN pFieldValue = RowObject.dt-protocolo-bco.
        WHEN "dt-today":U THEN ASSIGN pFieldValue = RowObject.dt-today.
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
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetDescFK DBOProgram 
PROCEDURE GetDescFK :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   def input  param c-table       as char no-undo.
   def input  param c-param       as char no-undo.
   def output param c-description as char no-undo.

   case c-table:
      when "texto-padrao-mec":u then do:
         find texto-padrao-mec where texto-padrao-mec.codigo = int(c-param) no-lock no-error.
         if avail texto-padrao-mec then
            assign c-description = texto-padrao-mec.descricao.
         else
            assign c-description = "".
      end.
      when "banco":u then do:
         find banco where banco.cod-banco = int(c-param) no-lock no-error.
         if avail banco then
            assign c-description = banco.nome-banco.
         else
            assign c-description = "".
      end.
      when "estabelec":u then do:
         find estabelec where estabelec.cod-estabel = c-param no-lock no-error.
         if avail estabelec then
            assign c-description = estabelec.nome.
         else
            assign c-description = "".
      end.
      when "moeda":u then do:
         find moeda where moeda.mo-codigo = int(c-param) no-lock no-error.
         if avail moeda then
            assign c-description = moeda.descricao.
         else
            assign c-description = "".
      end.
      when "emitente":u then do:
         find emitente where emitente.cod-emitente = int(c-param) no-lock no-error.
         if avail emitente then
            assign c-description = emitente.nome-emit.
         else
            assign c-description = "".
      end.
      when "Agància":u then do:
         IF l-func-alt-car-rem THEN DO:
             find agencia NO-LOCK
                 where agencia.cod-banco = int(entry(2,c-param,";")) 
                 AND   agencia.agencia   = entry(1,c-param,";")  no-error.
             if avail agencia then
                assign c-description = agencia.nome.
             else
                assign c-description = "".
         END.
      end.
   end.

   return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetDescFK2 DBOProgram 
PROCEDURE GetDescFK2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   def input  param c-table       as char no-undo.
   def input  param c-param       as char no-undo.
   def output param c-description as char format "x(20000)" no-undo.

   case c-table:
      when "texto-padrao-mec":u then do:
         find texto-padrao-mec where texto-padrao-mec.codigo = int(c-param) no-lock no-error.
         if avail texto-padrao-mec then
            assign c-description = texto-padrao-mec.texto.
         else
            assign c-description = "".
      end.
   end.
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
        WHEN "cod-banco":U THEN ASSIGN pFieldValue = RowObject.cod-banco.
        WHEN "cod-banco-remeter":U THEN ASSIGN pFieldValue = RowObject.cod-banco-remeter.
        WHEN "cod-corretor":U THEN ASSIGN pFieldValue = RowObject.cod-corretor.
        WHEN "cod-sacado":U THEN ASSIGN pFieldValue = RowObject.cod-sacado.
        WHEN "cod-texto-banco":U THEN ASSIGN pFieldValue = RowObject.cod-texto-banco.
        WHEN "cod-texto-detalhe":U THEN ASSIGN pFieldValue = RowObject.cod-texto-detalhe.
        WHEN "cod-texto-remeter":U THEN ASSIGN pFieldValue = RowObject.cod-texto-remeter.
        WHEN "cod-texto-sacado":U THEN ASSIGN pFieldValue = RowObject.cod-texto-sacado.
        &IF "{&mguni_version}" < "2.07A" &THEN
            WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
        &ENDIF
        WHEN "ind-destino":U THEN ASSIGN pFieldValue = RowObject.ind-destino.
        WHEN "ind-entr-docto":U THEN ASSIGN pFieldValue = RowObject.ind-entr-docto.
        WHEN "mo-codigo":U THEN ASSIGN pFieldValue = RowObject.mo-codigo.
        WHEN "situacao":U THEN ASSIGN pFieldValue = RowObject.situacao.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice crta-remessa
  Parameters:  
               retorna valor do campo ep-codigo
               retorna valor do campo cod-estabel
               retorna valor do campo nr-crta-remessa
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pep-codigo LIKE crta-remessa-exp.ep-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE crta-remessa-exp.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-crta-remessa LIKE crta-remessa-exp.nr-crta-remessa NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pep-codigo = RowObject.ep-codigo
           pcod-estabel = RowObject.cod-estabel
           pnr-crta-remessa = RowObject.nr-crta-remessa.

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
        WHEN "aplicar-contr":U THEN ASSIGN pFieldValue = RowObject.aplicar-contr.
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
  Purpose:     Reposiciona registro com base no °ndice crta-remessa
  Parameters:  
               recebe valor do campo ep-codigo
               recebe valor do campo cod-estabel
               recebe valor do campo nr-crta-remessa
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo LIKE crta-remessa-exp.ep-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE crta-remessa-exp.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pnr-crta-remessa LIKE crta-remessa-exp.nr-crta-remessa NO-UNDO.

    FIND FIRST bfcrta-remessa-exp WHERE 
        bfcrta-remessa-exp.ep-codigo = pep-codigo AND 
        bfcrta-remessa-exp.cod-estabel = pcod-estabel AND 
        bfcrta-remessa-exp.nr-crta-remessa = pnr-crta-remessa NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfcrta-remessa-exp THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfcrta-remessa-exp)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCrtaRemessa DBOProgram 
PROCEDURE openQueryCrtaRemessa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK
        WHERE crta-remessa-exp.ep-codigo       = i-ep-codigo and
              crta-remessa-exp.cod-estabel     = c-cod-estabel and
              crta-remessa-exp.nr-crta-remessa = c-nr-crta-remessa.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryEstabel DBOProgram 
PROCEDURE openQueryEstabel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    if c-cod-estabel-ini = c-cod-estabel-fim then
        OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK 
             WHERE crta-remessa-exp.cod-estabel  = c-cod-estabel-ini 
                   BY crta-remessa-exp.cod-estabel.    
    else
        OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK 
             WHERE crta-remessa-exp.cod-estabel >= c-cod-estabel-ini and
                   crta-remessa-exp.cod-estabel <= c-cod-estabel-fim 
                   BY crta-remessa-exp.cod-estabel.
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
    OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK.
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryNumero DBOProgram 
PROCEDURE openQueryNumero :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    if c-nr-crta-remessa-ini = c-nr-crta-remessa-fim then
        OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK 
             WHERE crta-remessa-exp.nr-crta-remessa = c-nr-crta-remessa-ini 
                   BY crta-remessa-exp.nr-crta-remessa.    
    else
        OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK 
             WHERE crta-remessa-exp.nr-crta-remessa >= c-nr-crta-remessa-ini and
                   crta-remessa-exp.nr-crta-remessa <= c-nr-crta-remessa-fim 
                   BY crta-remessa-exp.nr-crta-remessa.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-alt-situacao DBOProgram 
PROCEDURE pi-alt-situacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param p-ep-codigo       like crta-remessa-exp.ep-codigo       no-undo.
    def input param p-cod-estabel     like crta-remessa-exp.cod-estabel     no-undo.
    def input param p-nr-crta-remessa like crta-remessa-exp.nr-crta-remessa no-undo.

    def buffer b-crta-remessa-exp for crta-remessa-exp.
   
   find b-crta-remessa-exp EXCLUSIVE-LOCK
      where b-crta-remessa-exp.ep-codigo       = p-ep-codigo and
            b-crta-remessa-exp.cod-estabel     = p-cod-estabel and
            b-crta-remessa-exp.nr-crta-remessa = p-nr-crta-remessa no-error.
   if avail b-crta-remessa-exp then
      assign b-crta-remessa-exp.situacao = 2.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-autenticacao DBOProgram 
PROCEDURE pi-autenticacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var i-ep-codigo like crta-remessa-exp.ep-codigo no-undo.
    def var c-usuario   like crta-remessa-exp.usuario   no-undo.
    
    {method/svc/autentic/autentic.i
            &vUserEnterprise="i-ep-codigo"
            &vUserName="c-usuario"}
    
    assign RowObject.ep-codigo = i-ep-codigo
           RowObject.usuario   = c-usuario
           RowObject.c-time    = string(TIME, "HH:MM")
           RowObject.dt-today  = today.
           
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-empresa DBOProgram 
PROCEDURE pi-busca-empresa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

&IF "{&mguni_version}" >= "2.07A" &THEN
   def output param i-ep-codigo LIKE empresa.ep-codigo no-undo.
&ELSE
   def output param i-ep-codigo as int no-undo.
&ENDIF
   
    {method/svc/autentic/autentic.i
            &vUserEnterprise="i-ep-codigo"}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tabela DBOProgram 
PROCEDURE pi-cria-tabela :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   def input param table for tt-crta-remessa-exp.

   assign cQueryUseded = "Main".
   for each RowObject:
      delete RowObject.
   end.

   find tt-crta-remessa-exp no-lock no-error.
   create RowObject.
   buffer-copy tt-crta-remessa-exp to RowObject.
   assign RowObject.situacao = 1.
   run createRecord in this-procedure.

   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-encontra-crta-remessa DBOProgram 
PROCEDURE pi-encontra-crta-remessa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   def input param p-ep-codigo       like crta-remessa-exp.ep-codigo       no-undo.
   def input param p-cod-estabel     like crta-remessa-exp.cod-estabel     no-undo.
   def input param p-nr-crta-remessa like crta-remessa-exp.nr-crta-remessa no-undo.
   def output param table for tt-dados-carta.
   def var c-texto as char format "x(20000)" no-undo.
   
   for each tt-dados-carta:
      delete tt-dados-carta.
   end.
   
   find crta-remessa-exp where 
        crta-remessa-exp.ep-codigo       = p-ep-codigo   and
        crta-remessa-exp.cod-estabel     = p-cod-estabel and
        crta-remessa-exp.nr-crta-remessa = p-nr-crta-remessa no-lock no-error.

   if avail crta-remessa-exp then do:
      create tt-dados-carta.
      assign tt-dados-carta.i-ep-codigo         = crta-remessa-exp.ep-codigo
             tt-dados-carta.c-cod-estabel       = crta-remessa-exp.cod-estabel
             tt-dados-carta.c-nr-crta-remessa   = crta-remessa-exp.nr-crta-remessa
             tt-dados-carta.dt-carta            = crta-remessa-exp.dt-emissao
             tt-dados-carta.l-aplicar-contr     = crta-remessa-exp.aplicar-contr
             tt-dados-carta.i-cod-banco         = crta-remessa-exp.cod-banco
             tt-dados-carta.i-cod-texto-banco   = crta-remessa-exp.cod-texto-banco
             tt-dados-carta.i-cod-banco-remeter = crta-remessa-exp.cod-banco-remeter
             tt-dados-carta.i-cod-texto-remeter = crta-remessa-exp.cod-texto-remeter
             tt-dados-carta.i-cod-sacado        = crta-remessa-exp.cod-sacado
             tt-dados-carta.i-cod-texto-sacado  = crta-remessa-exp.cod-texto-sacado
             tt-dados-carta.i-cod-texto-detalhe = crta-remessa-exp.cod-texto-detalhe
             tt-dados-carta.i-cod-corretor      = crta-remessa-exp.cod-corretor
      .
      &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
          DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
          ASSIGN cAuxTraducao001 = {adinc/i01ad358.i 04 crta-remessa-exp.ind-entr-docto}.
          run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                              INPUT "",
                              INPUT "").
          ASSIGN tt-dados-carta.c-entr-docto        = RETURN-VALUE.
      &else
          ASSIGN tt-dados-carta.c-entr-docto        = {adinc/i01ad358.i 04 crta-remessa-exp.ind-entr-docto}.
      &endif

      if l-func-alt-car-rem then do:
          &if "{&mgadm_version}":U < "2.06":U &then
              assign tt-dados-carta.c-cod-agencia = crta-remessa-exp.char-1.
          &else
              assign tt-dados-carta.c-cod-agencia = crta-remessa-exp.agencia.  
          &endif
      end.

      /*** faz a atribuicao dos textos ***/
      run pi-texto (input  crta-remessa-exp.cod-texto-banco,
                    output c-texto).
      assign tt-dados-carta.c-texto-para = c-texto.
      
      run pi-texto (input  crta-remessa-exp.cod-texto-remeter,
                    output c-texto).
      assign tt-dados-carta.c-texto-remeter = c-texto.
      
      run pi-texto (input  crta-remessa-exp.cod-texto-sacado,
                    output c-texto).
      assign tt-dados-carta.c-texto-sacado = c-texto.
      
      run pi-texto (input  crta-remessa-exp.cod-texto-detalhe,
                    output c-texto).
      assign tt-dados-carta.c-texto-detalhe = c-texto.

      /*** verifica a existencia de documentos vinculados ***/
      if can-find (first crta-remessa-docto-exp of crta-remessa-exp) then
         assign tt-dados-carta.l-documentos = yes.
      
      /*** verifica a existencia de titulos vinculados ***/
      if can-find (first crta-remessa-titulo of crta-remessa-exp) then
         assign tt-dados-carta.l-titulos = yes.
      RETURN "OK":U.
   end.
   else do:
      RETURN "NOK":U.
   end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-texto DBOProgram 
PROCEDURE pi-texto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   def input  param p-cod-texto as int                    no-undo.
   def output param p-texto     as char format "x(20000)" no-undo.
   
   find texto-padrao-mec no-lock
      where texto-padrao-mec.codigo = p-cod-texto no-error.
      if avail texto-padrao-mec then
         assign p-texto = texto-padrao-mec.texto.
      else
         assign p-texto = "".


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-situacao DBOProgram 
PROCEDURE pi-verifica-situacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  if RowObject.situacao = 2 then do:
     {method/svc/errors/inserr.i
                 &ErrorNumber="26032"
                 &ErrorType="EMS"
                 &ErrorParameters="''"}
     return "NOK":U.                 
  end.
  
  return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setconstraintCrtaRemessa DBOProgram 
PROCEDURE setconstraintCrtaRemessa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo       LIKE crta-remessa-exp.ep-codigo       NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel     LIKE crta-remessa-exp.cod-estabel     NO-UNDO.
    DEFINE INPUT PARAMETER pnr-crta-remessa LIKE crta-remessa-exp.nr-crta-remessa NO-UNDO.
    
    assign i-ep-codigo       = pep-codigo
           c-cod-estabel     = pcod-estabel
           c-nr-crta-remessa = pnr-crta-remessa.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintEstabel DBOProgram 
PROCEDURE setConstraintEstabel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel-ini LIKE crta-remessa-exp.cod-estabel.
    DEFINE INPUT PARAMETER pcod-estabel-fim LIKE crta-remessa-exp.cod-estabel.

    assign c-cod-estabel-ini = pcod-estabel-ini
           c-cod-estabel-fim = pcod-estabel-fim.

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

   RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintNumero DBOProgram 
PROCEDURE setConstraintNumero :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-crta-remessa-ini LIKE crta-remessa-exp.nr-crta-remessa.
    DEFINE INPUT PARAMETER pnr-crta-remessa-fim LIKE crta-remessa-exp.nr-crta-remessa.

    assign c-nr-crta-remessa-ini = pnr-crta-remessa-ini
           c-nr-crta-remessa-fim = pnr-crta-remessa-fim.

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
    def var c-string1 as char no-undo.

    if ptype = "Create":U then do:
       run pi-autenticacao.
       
       if can-find (crta-remessa-exp
                    where crta-remessa-exp.ep-codigo       = RowObject.ep-codigo
                      and crta-remessa-exp.cod-estabel     = RowObject.cod-estabel
                      and crta-remessa-exp.nr-crta-remessa = RowObject.nr-crta-remessa) then do:
          {utp/ut-liter.i N£mero_de_carta_remessa *}
          assign c-string1 = return-value.

          {method/svc/errors/inserr.i
                      &ErrorNumber="7"
                      &ErrorType="EMS"
                      &ErrorParameters="c-string1"}
       end.

&IF "{&mguni_version}" >= "2.07A" &THEN
       if RowObject.ep-codigo = "" then do:
&ELSE
       if RowObject.ep-codigo = 0 then do:
&ENDIF
          {utp/ut-liter.i COD_EMPRESA_NAO_PODE_SER_BRANCO *}
          assign c-string1 = return-value.

          {method/svc/errors/inserr.i
                      &ErrorNumber="7"
                      &ErrorType="EMS"
                      &ErrorParameters="c-string1"}
       end.
    
       if RowObject.cod-estabel = "" then do:
          {method/svc/errors/inserr.i
                       &ErrorNumber="3645"
                       &ErrorType="EMS"
                       &ErrorParameters="''"}
       end.
       
       if RowObject.cod-estabel <> "" then do:
           if can-find (first estabelec where estabelec.cod-estabel = RowObject.cod-estabel) = no then
               {method/svc/errors/inserr.i
                          &ErrorNumber="2061"
                          &ErrorType="EMS"
                          &ErrorParameters="''"}
       end.

       if RowObject.nr-crta-remessa = "" then do:
          {method/svc/errors/inserr.i
                      &ErrorNumber="25378"
                      &ErrorType="EMS"
                      &ErrorParameters="''"}
       end.
    end.

    if ptype = "Create":U or
       ptype = "Update":U then do:
       if RowObject.situacao = 2 then do:
          {method/svc/errors/inserr.i
                      &ErrorNumber="26070"
                      &ErrorType="EMS"
                      &ErrorParameters="''"}
       end.

       if RowObject.mo-codigo = 0 then do:
          {method/svc/errors/inserr.i
                      &ErrorNumber="4215"
                      &ErrorType="EMS"
                      &ErrorParameters="''"}
       end.

       if can-find (first moeda where moeda.mo-codigo = RowObject.mo-codigo) = no then do:
          {method/svc/errors/inserr.i
                      &ErrorNumber="930"
                      &ErrorType="EMS"
                      &ErrorParameters="''"}
       end.

       find first emitente where emitente.cod-emitente = RowObject.int-1 no-lock no-error.
       if not avail emitente then do:
          {method/svc/errors/inserr.i
                      &ErrorNumber="895"
                      &ErrorType="EMS"
                      &ErrorParameters="''"}
       end.
       else do:
           if emitente.natureza <> 3 then
              {method/svc/errors/inserr.i
                          &ErrorNumber="5615"
                          &ErrorType="EMS"
                          &ErrorParameters="''"}

           if emitente.identific = 2 then
              {method/svc/errors/inserr.i
                          &ErrorNumber="26241"
                          &ErrorType="EMS"
                          &ErrorParameters="''"}
       end.

       find first emitente where emitente.cod-emitente = RowObject.cod-corretor no-lock no-error.
       if not avail emitente then do:
          {method/svc/errors/inserr.i
                      &ErrorNumber="19332"
                      &ErrorType="EMS"
                      &ErrorParameters="''"}
       end.
       else do:
           if emitente.identific = 1 then
              {method/svc/errors/inserr.i
                          &ErrorNumber="27016"
                          &ErrorType="EMS"
                          &ErrorParameters="''"}
       end.

       find first emitente where emitente.cod-emitente = RowObject.cod-sacado no-lock no-error.
       if not avail emitente then do:
          {method/svc/errors/inserr.i
                      &ErrorNumber="26391"
                      &ErrorType="EMS"
                      &ErrorParameters="''"}
       end.
       else do:
           if emitente.natureza <> 3 then
              {method/svc/errors/inserr.i
                          &ErrorNumber="26396"
                          &ErrorType="EMS"
                          &ErrorParameters="''"}

           if emitente.identific = 2 then
              {method/svc/errors/inserr.i
                          &ErrorNumber="26397"
                          &ErrorType="EMS"
                          &ErrorParameters="''"}
       end.

       if RowObject.cod-banco <> 0 then do:
           {utp/ut-liter.i para *}
           assign c-string1 = return-value.

            if can-find (first banco where banco.cod-banco = RowObject.cod-banco) = no then
                {method/svc/errors/inserr.i
                           &ErrorNumber="26398"
                           &ErrorType="EMS"
                           &ErrorParameters="c-string1"}
       end.

       if RowObject.cod-banco-remeter <> 0 then do:
            {utp/ut-liter.i remeter *}
            assign c-string1 = return-value.

            if can-find (first banco where banco.cod-banco = RowObject.cod-banco-remeter) = no then
                {method/svc/errors/inserr.i
                           &ErrorNumber="26398"
                           &ErrorType="EMS"
                           &ErrorParameters="c-string1"}
       end.

       IF l-func-alt-car-rem THEN DO:
           &if "{&mgadm_version}":U < "2.06":U &then
               FIND FIRST agencia NO-LOCK
                   WHERE agencia.cod-banco = RowObject.cod-banco-remeter
                   AND   agencia.agencia   = RowObject.char-1
                   AND   agencia.log-1     = YES NO-ERROR.
           &else
               FIND FIRST agencia NO-LOCK
                   WHERE agencia.cod-banco       = RowObject.cod-banco-remeter
                   AND   agencia.agencia         = RowObject.agencia
                   AND   agencia.log-estrangeiro = YES NO-ERROR. 
           &endif
           IF NOT AVAIL agencia THEN DO:
               {utp/ut-liter.i Canal_Banc†rio *}
               assign c-string1 = return-value.

               {method/svc/errors/inserr.i
                           &ErrorNumber="18210"
                           &ErrorType="EMS"
                           &ErrorParameters="c-string1"}
           END.
       END.

    end.

    if ptype = "Delete":U then do:
       if RowObject.situacao = 2 then do:
          {method/svc/errors/inserr.i
                      &ErrorNumber="25377"
                      &ErrorType="EMS"
                      &ErrorParameters="''"}
       end.
    end.
    
    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

