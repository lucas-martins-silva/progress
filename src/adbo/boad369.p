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
{include/i-prgvrs.i BOAD369 2.00.00.015} /*** "010015" 10/06/2025 09:30:38 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boad369 MUT}
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
&GLOBAL-DEFINE DBOName            BOAD369
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName          crta-remessa-titulo
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName          qr{&TableName} 


/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{adbo/boad369.i RowObject}

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
DEFINE BUFFER bf-crta-remessa-docto-exp FOR crta-remessa-docto-exp.
DEFINE BUFFER bf-crta-remessa-exp FOR crta-remessa-exp.
DEFINE BUFFER bf-crta-remessa-titulo FOR crta-remessa-titulo.

def temp-table tt-crta-remessa-titulo like crta-remessa-titulo
    field r-rowid as rowid.

define temp-table tt-digita no-undo
&IF "{&mguni_version}" >= "2.07A" &THEN
   field cod-estabel as char format "x(05)"
&ELSE
   field cod-estabel as char format "x(3)"
&ENDIF
   field nr-crta-remessa as char format "x(10)"
   field cod-esp as char format "x(3)" label "Esp"
   field serie as char format "x(5)" label "SÇrie"
   field cod-emitente as int format ">>>>>>>>9" label "Cliente"
   field nr-docto as char format "x(16)" label "Documento"
   field parcela as char format "x(2)" label "/P"
   field dt-vencimen as date format "99/99/9999" label "Dt Vencto"
   field vl-saldo-me as decimal format ">>>>>>>,>>9.99" label "Vl Saldo"
   field sequencia as int.

/*--- Vari†veis ---*/
&IF "{&mguni_version}" >= "2.07A" &THEN
def var i-ep-codigo       LIKE empresa.ep-codigo    no-undo.
&ELSE
def var i-ep-codigo       as int    no-undo.
&ENDIF
def var c-cod-estabel     as char   no-undo.
def var c-nr-crta-remessa as char   no-undo.
def var c-nr-docto-ini    as char   no-undo.
def var c-nr-docto-fim    as CHAR   no-undo.
&IF "{&mguni_version}" >= "2.07A" &THEN
def var c-ep-codigo       LIKE empresa.ep-codigo    NO-UNDO.
&ELSE
def var c-ep-codigo       as int    NO-UNDO.
&ENDIF
def VAR i-seq-erro        as int    no-undo.
def VAR hshowmsg          as handle no-undo.
def var v-pagar           as CHAR   no-undo. /* "EMS 2" ; "EMS 5" */
def var v-receber         as CHAR   no-undo. /* "EMS 2" ; "EMS 5" */
def var h-boad355         as HANDLE no-undo.
DEF VAR l-func-alt-car-rem AS LOG   no-undo.

/* Definicoes para conexao EMS 5 */
{ecp/ec0005c.i}

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
         HEIGHT             = 5.67
         WIDTH              = 29.43.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE aftercreaterecord DBOProgram 
PROCEDURE aftercreaterecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def var h-boad366         as HANDLE no-undo.

IF l-func-alt-car-rem THEN DO:
    run adbo/boad366.p persistent set h-boad366.
    run pi-cria-docto-automatico in h-boad366 (input  RowObject.ep-codigo,
                                               input  RowObject.cod-estabel,
                                               input  RowObject.nr-crta-remessa,
                                               input  RowObject.cod-emitente,
                                               input  RowObject.cod-esp,
                                               input  RowObject.serie,
                                               input  RowObject.nr-docto,
                                               input  RowObject.parcela).
    DELETE PROCEDURE h-boad366.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforecreaterecord DBOProgram 
PROCEDURE beforecreaterecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  find last crta-remessa-titulo
       where crta-remessa-titulo.ep-codigo       = RowObject.ep-codigo
         and crta-remessa-titulo.cod-estabel     = RowObject.cod-estabel
         and crta-remessa-titulo.nr-crta-remessa = RowObject.nr-crta-remessa no-lock no-error.

  if avail crta-remessa-titulo then do:
     assign RowObject.sequencia = crta-remessa-titulo.sequencia + 10.
  end.
  else
     assign RowObject.sequencia = 10.

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
        WHEN "cod-esp":U THEN ASSIGN pFieldValue = RowObject.cod-esp.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "nr-crta-remessa":U THEN ASSIGN pFieldValue = RowObject.nr-crta-remessa.
        WHEN "nr-docto":U THEN ASSIGN pFieldValue = RowObject.nr-docto.
        WHEN "parcela":U THEN ASSIGN pFieldValue = RowObject.parcela.
        WHEN "serie":U THEN ASSIGN pFieldValue = RowObject.serie.
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
        WHEN "dt-today":U THEN ASSIGN pFieldValue = RowObject.dt-today.
        WHEN "dt-vinculado":U THEN ASSIGN pFieldValue = RowObject.dt-vinculado.
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
        WHEN "vl-vinculado-me":U THEN ASSIGN pFieldValue = RowObject.vl-vinculado-me.
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
      when "emitente":u then do:
         find emitente where emitente.cod-emitente = int(c-param) no-lock no-error.
         if avail emitente then
            assign c-description = emitente.nome-abrev.
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
        &IF "{&mguni_version}" < "2.07A" &THEN
            WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
        &ENDIF
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "sequencia":U THEN ASSIGN pFieldValue = RowObject.sequencia.
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
               retorna valor do campo sequencia
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pep-codigo LIKE crta-remessa-titulo.ep-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE crta-remessa-titulo.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-crta-remessa LIKE crta-remessa-titulo.nr-crta-remessa NO-UNDO.
    DEFINE OUTPUT PARAMETER psequencia LIKE crta-remessa-titulo.sequencia NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pep-codigo = RowObject.ep-codigo
           pcod-estabel = RowObject.cod-estabel
           pnr-crta-remessa = RowObject.nr-crta-remessa
           psequencia = RowObject.sequencia.

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
               recebe valor do campo sequencia
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo LIKE crta-remessa-titulo.ep-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE crta-remessa-titulo.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pnr-crta-remessa LIKE crta-remessa-titulo.nr-crta-remessa NO-UNDO.
    DEFINE INPUT PARAMETER psequencia LIKE crta-remessa-titulo.sequencia NO-UNDO.

    FIND FIRST bfcrta-remessa-titulo WHERE 
        bfcrta-remessa-titulo.ep-codigo = pep-codigo AND 
        bfcrta-remessa-titulo.cod-estabel = pcod-estabel AND 
        bfcrta-remessa-titulo.nr-crta-remessa = pnr-crta-remessa AND 
        bfcrta-remessa-titulo.sequencia = psequencia NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfcrta-remessa-titulo THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfcrta-remessa-titulo)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToCrtaRemessa DBOProgram 
PROCEDURE linkToCrtaRemessa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter phandle as handle no-undo.
    
    run getkey in phandle (output i-ep-codigo,
                           output c-cod-estabel,
                           output c-nr-crta-remessa).
                           
    run setConstraintCrtaRemessa in this-procedure (input i-ep-codigo,
                                                    input c-cod-estabel,
                                                    input c-nr-crta-remessa).
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
        WHERE crta-remessa-titulo.ep-codigo       = i-ep-codigo   and
              crta-remessa-titulo.cod-estabel     = c-cod-estabel and
              crta-remessa-titulo.nr-crta-remessa = c-nr-crta-remessa INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCrtaRemessa2 DBOProgram 
PROCEDURE openQueryCrtaRemessa2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    if c-nr-docto-ini = c-nr-docto-fim then
        OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK
            WHERE crta-remessa-titulo.ep-codigo       = i-ep-codigo       and
                  crta-remessa-titulo.cod-estabel     = c-cod-estabel     and
                  crta-remessa-titulo.nr-crta-remessa = c-nr-crta-remessa and
                  crta-remessa-titulo.nr-docto        = c-nr-docto-ini INDEXED-REPOSITION.    
    else
        OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK
            WHERE crta-remessa-titulo.ep-codigo       = i-ep-codigo       and
                  crta-remessa-titulo.cod-estabel     = c-cod-estabel     and
                  crta-remessa-titulo.nr-crta-remessa = c-nr-crta-remessa and
                  crta-remessa-titulo.nr-docto       >= c-nr-docto-ini    and
                  crta-remessa-titulo.nr-docto       <= c-nr-docto-fim INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openqueryMain DBOProgram 
PROCEDURE openqueryMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK INDEXED-REPOSITION.
    RETURN "OK":U.

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
    def var i-ep-codigo like crta-remessa-titulo.ep-codigo no-undo.
    def var c-usuario   like crta-remessa-titulo.usuario   no-undo.
    
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-saldo-orig DBOProgram 
PROCEDURE pi-busca-saldo-orig :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  param p-ep-codigo      like crta-remessa-titulo.ep-codigo    NO-UNDO.
    def input  param p-cod-estabel    like crta-remessa-titulo.cod-estabel  NO-UNDO.
    def input  param p-cod-emitente   like crta-remessa-titulo.cod-emitente NO-UNDO.
    def input  param p-cod-esp        like crta-remessa-titulo.cod-esp      NO-UNDO.
    def input  param p-serie          like crta-remessa-titulo.serie        NO-UNDO.
    def input  param p-nr-docto       like crta-remessa-titulo.nr-docto     NO-UNDO.
    def input  param p-parcela        like crta-remessa-titulo.parcela      NO-UNDO.
    def input  param p-receber        as char                               NO-UNDO.
    def output param p-moeda          as integer                            NO-UNDO.
    def output param p-vl-saldo-me    as decimal                            NO-UNDO.
    def output param p-dt-vencimen    as date                               NO-UNDO.
    def output param p-nr-proc        as char                               NO-UNDO.
    def output param p-situacao       as integer                            NO-UNDO.
    def output param p-val-comis      as decimal                            no-undo.
    
    define variable h-acr788za as HANDLE no-undo.

    case p-receber :
    when "EMS 5" then do: /* busca saldo orig EMS 5.0 */
        ASSIGN c-ep-codigo = p-ep-codigo.     
        
        /* Conecta Bases EMS 5 */
        {ecp/ec0005b.i 1}
        
        /*** Verifica Erro na Conex∆o das Bases ***/
        {ecp/ec0005k.i}
        
        IF i-seq-erro <> 0 THEN DO:
            {method/showmessage.i1}
            {method/showmessage.i2}
            
            for each RowErrors:
                delete RowErrors.
            end.
        END.
        ELSE DO:
            run prgfin/acr/acr788za.py persistent set h-acr788za.
            run pi_busca_saldo_titulo in h-acr788za (input p-ep-codigo,                           
                                                     input p-cod-estabel,                         
                                                     input p-cod-emitente, 
                                                     input p-cod-esp,      
                                                     input p-serie,        
                                                     input p-nr-docto,
                                                     input p-parcela,
                                                     output p-moeda,
                                                     output p-dt-vencimen,
                                                     output p-vl-saldo-me,
                                                     output p-nr-proc,
                                                     output p-situacao,
                                                     output p-val-comis).
            delete procedure h-acr788za.
        END.
        
        /* Desconecta Bases EMS 5 */
        {ecp/ec0005b.i 2}
    END.
    end case.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-saldo-titulo DBOProgram 
PROCEDURE pi-busca-saldo-titulo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  param p-ep-codigo      like crta-remessa-titulo.ep-codigo    no-undo.
    def input  param p-cod-estabel    like crta-remessa-titulo.cod-estabel  no-undo.
    def input  param p-cod-emitente   like crta-remessa-titulo.cod-emitente no-undo.
    def input  param p-cod-esp        like crta-remessa-titulo.cod-esp      no-undo.
    def input  param p-serie          like crta-remessa-titulo.serie        no-undo.
    def input  param p-nr-docto       like crta-remessa-titulo.nr-docto     no-undo.
    def input  param p-parcela        like crta-remessa-titulo.parcela      no-undo.
    def output param p-soma-vinculado as   decimal                          no-undo.

    def buffer bf-crta-remessa-titulo2 for crta-remessa-titulo.

    assign p-soma-vinculado = 0.
    for each bf-crta-remessa-titulo2
        where bf-crta-remessa-titulo2.ep-codigo    = p-ep-codigo
        and   bf-crta-remessa-titulo2.cod-estabel  = p-cod-estabel
        and   bf-crta-remessa-titulo2.cod-esp      = p-cod-esp
        and   bf-crta-remessa-titulo2.serie        = p-serie
        and   bf-crta-remessa-titulo2.nr-docto     = p-nr-docto
        and   bf-crta-remessa-titulo2.parcela      = p-parcela    /*ao invÇs do cod-emitente, deveria ser nr-conta-remessa*/
      /*and  bf-crta-remessa-titulo2.nr-crta-remessa = p-num-crta-remessa*/
        and   bf-crta-remessa-titulo2.cod-emitente = p-cod-emitente  no-lock:

        assign p-soma-vinculado = p-soma-vinculado + bf-crta-remessa-titulo2.vl-vinculado-me.
    end.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-crta-rems-tit DBOProgram 
PROCEDURE pi-carrega-crta-rems-tit :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def output param table for tt-crta-remessa-titulo.
    
    for each bf-crta-remessa-titulo no-lock:
        create tt-crta-remessa-titulo.
        buffer-copy bf-crta-remessa-titulo to tt-crta-remessa-titulo.
    end.
    
    RETURN "OK":U.
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
   def input param table for tt-digita.

   assign cQueryUseded = "Main".
   for each RowObject:
      delete RowObject.
   end.

   for each tt-digita.
      create RowObject.
      assign RowObject.cod-esp          = tt-digita.cod-esp
             RowObject.nr-crta-remessa  = tt-digita.nr-crta-remessa
             RowObject.serie            = tt-digita.serie
             RowObject.cod-emitente     = tt-digita.cod-emitente
             RowObject.nr-docto         = tt-digita.nr-docto
             RowObject.parcela          = tt-digita.parcela
             RowObject.cod-estabel      = tt-digita.cod-estabel
             RowObject.vl-vinculado-me  = tt-digita.vl-saldo-me.

      run createRecord in this-procedure.
   end.

   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-eliminar-titulos-vinculados DBOProgram 
PROCEDURE pi-eliminar-titulos-vinculados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param p-documento LIKE crta-remessa-docto-exp.documento NO-UNDO.

    FOR EACH contr-titulo-exp
        WHERE contr-titulo-exp.nr-contrato = p-documento NO-LOCK:
        FIND FIRST crta-remessa-titulo
            WHERE crta-remessa-titulo.ep-codigo   = contr-titulo-exp.ep-codigo
              AND crta-remessa-titulo.cod-estabel = contr-titulo-exp.cod-estabel
              AND crta-remessa-titulo.cod-esp     = contr-titulo-exp.cod-esp
              AND crta-remessa-titulo.serie       = contr-titulo-exp.serie
              AND crta-remessa-titulo.nr-docto    = contr-titulo-exp.nr-docto
              AND crta-remessa-titulo.parcela     = contr-titulo-exp.parcela exclusive-LOCK NO-ERROR.
        IF  AVAIL crta-remessa-titulo THEN
            DELETE crta-remessa-titulo.
    END.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-empresa DBOProgram 
PROCEDURE pi-empresa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def output param p-empresa like crta-remessa-titulo.ep-codigo no-undo.
    
    {method/svc/autentic/autentic.i
            &vUserEnterprise="p-empresa"}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-encontra-crta-remessa-titulo DBOProgram 
PROCEDURE pi-encontra-crta-remessa-titulo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   def input param p-ep-codigo    like crta-remessa-titulo.ep-codigo       no-undo.
   def input param p-cod-estabel  like crta-remessa-titulo.cod-estabel     no-undo.
   def input param p-nr-crta      like crta-remessa-titulo.nr-crta-remessa no-undo.
   def input param p-cod-esp      like crta-remessa-titulo.cod-esp         no-undo.
   def input param p-serie        like crta-remessa-titulo.serie           no-undo.
   def input param p-nr-docto     like crta-remessa-titulo.nr-docto        no-undo.
   def input param p-parcela      like crta-remessa-titulo.parcela         no-undo.
   
   find crta-remessa-titulo where 
        crta-remessa-titulo.ep-codigo       = p-ep-codigo    and
        crta-remessa-titulo.cod-estabel     = p-cod-estabel  and
        crta-remessa-titulo.nr-crta-remessa = p-nr-crta      and
        crta-remessa-titulo.cod-esp         = p-cod-esp      and
        crta-remessa-titulo.serie           = p-serie        and
        crta-remessa-titulo.nr-docto        = p-nr-docto     and
        crta-remessa-titulo.parcela         = p-parcela no-lock no-error.

   if avail crta-remessa-titulo then
      return "OK":U.

   return "NOK":U.
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
    DEFINE INPUT PARAMETER pep-codigo       LIKE crta-remessa-titulo.ep-codigo       NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel     LIKE crta-remessa-titulo.cod-estabel     NO-UNDO.
    DEFINE INPUT PARAMETER pnr-crta-remessa LIKE crta-remessa-titulo.nr-crta-remessa NO-UNDO.
    
    assign i-ep-codigo       = pep-codigo
           c-cod-estabel     = pcod-estabel
           c-nr-crta-remessa = pnr-crta-remessa.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setconstraintCrtaRemessa2 DBOProgram 
PROCEDURE setconstraintCrtaRemessa2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo       LIKE crta-remessa-titulo.ep-codigo       NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel     LIKE crta-remessa-titulo.cod-estabel     NO-UNDO.
    DEFINE INPUT PARAMETER pnr-crta-remessa LIKE crta-remessa-titulo.nr-crta-remessa NO-UNDO.
    DEFINE INPUT PARAMETER pnr-docto-ini    LIKE crta-remessa-titulo.nr-docto        NO-UNDO.
    DEFINE INPUT PARAMETER pnr-docto-fim    LIKE crta-remessa-titulo.nr-docto        NO-UNDO.
    
    assign i-ep-codigo       = pep-codigo
           c-cod-estabel     = pcod-estabel
           c-nr-crta-remessa = pnr-crta-remessa
           c-nr-docto-ini    = pnr-docto-ini
           c-nr-docto-fim    = pnr-docto-fim.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setconstraintMain DBOProgram 
PROCEDURE setconstraintMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

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
    
    if ptype = "Create":U then do:
       run pi-autenticacao.
                           
&IF "{&mguni_version}" >= "2.07A" &THEN
       if RowObject.ep-codigo = "" then do:
&ELSE
       if RowObject.ep-codigo = 0 then do:
&ENDIF
          {utp/ut-liter.i "COD EMPRESA NAO PODE SER BRANCO" * }
          {method/svc/errors/inserr.i
                      &ErrorNumber="7"
                      &ErrorType="EMS"
                      &ErrorParameters="return-value"}
       end.
    
       if RowObject.cod-estabel = "" then do:
          {utp/ut-liter.i "ESTABELECIMENTO NAO PODE SER BRANCO" * }
          {method/svc/errors/inserr.i
                      &ErrorNumber="7"
                      &ErrorType="EMS"
                      &ErrorParameters="return-value"}
       end.
       
       if RowObject.nr-crta-remessa = "" then do:
          {utp/ut-liter.i "NR CARTA REMESSA NAO PODE SER BRANCO" * }
          {method/svc/errors/inserr.i
                      &ErrorNumber="7"
                      &ErrorType="EMS"
                      &ErrorParameters="return-value"}
       end.
       
       if can-find (crta-remessa-titulo where 
                    crta-remessa-titulo.ep-codigo       = RowObject.ep-codigo       and
                    crta-remessa-titulo.cod-estabel     = RowObject.cod-estabel     and
                    crta-remessa-titulo.nr-crta-remessa = RowObject.nr-crta-remessa and
                    crta-remessa-titulo.cod-emitente    = RowObject.cod-emitente    and
                    crta-remessa-titulo.cod-esp         = RowObject.cod-esp         and
                    crta-remessa-titulo.serie           = RowObject.serie           and
                    crta-remessa-titulo.nr-docto        = RowObject.nr-docto        and
                    crta-remessa-titulo.parcela         = RowObject.parcela) then do:
          {method/svc/errors/inserr.i
                      &ErrorNumber="819"
                      &ErrorType="EMS"
                      &ErrorParameters="''"}                     
       end.
       
       run adbo/boad355.p persistent set h-boad355.
       run pi-verificar-produto in h-boad355 (output v-pagar,
                                              output v-receber).
       delete procedure h-boad355.
      
    end.   
    
    if ptype = "Update":U or 
       ptype = "Create":U then do:

       run pi-autenticacao.

       if RowObject.vl-vinculado-me = 0 then do:
          {method/svc/errors/inserr.i
                      &ErrorNumber="309"
                      &ErrorType="EMS"
                      &ErrorParameters="''"}
       end.
    end.
    
    if ptype = "Delete":U then do:
        find bf-crta-remessa-docto-exp no-lock
           where bf-crta-remessa-docto-exp.ep-codigo       = RowObject.ep-codigo       and
                 bf-crta-remessa-docto-exp.cod-estabel     = RowObject.cod-estabel     and
                 bf-crta-remessa-docto-exp.nr-crta-remessa = RowObject.nr-crta-remessa and
                 bf-crta-remessa-docto-exp.cod-emitente    = RowObject.cod-emitente    and
                 bf-crta-remessa-docto-exp.cod-esp         = RowObject.cod-esp         and
                 bf-crta-remessa-docto-exp.serie           = RowObject.serie           and
                 bf-crta-remessa-docto-exp.nr-docto        = RowObject.nr-docto        and
                 bf-crta-remessa-docto-exp.parcela         = RowObject.parcela no-error.
     
        if avail bf-crta-remessa-docto-exp then do:
           {method/svc/errors/inserr.i
                       &ErrorNumber="25373"
                       &ErrorType="EMS"
                       &ErrorParameters="''"}
        end.
    end.
    
    if ptype = "Delete":U or 
       ptype = "Create":U or    
       ptype = "Update":U then do:
        find first bf-crta-remessa-exp no-lock
             where bf-crta-remessa-exp.ep-codigo       = RowObject.ep-codigo
             and   bf-crta-remessa-exp.cod-estabel     = RowObject.cod-estabel
             and   bf-crta-remessa-exp.nr-crta-remessa = RowObject.nr-crta-remessa no-error.
        if bf-crta-remessa-exp.situacao = 2 then do:
           {method/svc/errors/inserr.i
                       &ErrorNumber="26032"
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

