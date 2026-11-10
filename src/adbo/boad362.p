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
{include/i-prgvrs.i BOAD362 2.00.00.009} /*** "010009" 20/10/2023 10:44:30  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boad362 MUT}
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
&GLOBAL-DEFINE DBOName              BOAD362
&GLOBAL-DEFINE DBOVersion           1.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName            contr-hist-exp
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName            qr{&TableName} 


/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{adbo/boad362.i RowObject}


/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

def var i-ep-codigo     like contr-hist-exp.ep-codigo     no-undo.
def var c-cod-estabel   like contr-hist-exp.cod-estabel   no-undo.
def var c-referencia    like contr-hist-exp.referencia    no-undo.
def var d-dt-referencia like contr-hist-exp.dt-referencia no-undo.

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
         HEIGHT             = 1.58
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BeforeCreateRecord DBOProgram 
PROCEDURE BeforeCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    find last contr-hist-exp where contr-hist-exp.ep-codigo   = RowObject.ep-codigo
                             and contr-hist-exp.cod-estabel   = RowObject.cod-estabel
                             and contr-hist-exp.referencia    = RowObject.referencia
                             and contr-hist-exp.dt-referencia = RowObject.dt-referencia no-lock no-error.
    if avail contr-hist-exp then do:
       assign RowObject.sequencia = contr-hist-exp.sequencia + 10.
    end.
    else
       assign RowObject.sequencia = 10.

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
        &IF "{&mguni_version}" >= "2.07A" &THEN
            WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
        &ENDIF
        WHEN "c-time":U THEN ASSIGN pFieldValue = RowObject.c-time.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "historico":U THEN ASSIGN pFieldValue = RowObject.historico.
        WHEN "referencia":U THEN ASSIGN pFieldValue = RowObject.referencia.
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
        WHEN "dt-movto":U THEN ASSIGN pFieldValue = RowObject.dt-movto.
        WHEN "dt-referencia":U THEN ASSIGN pFieldValue = RowObject.dt-referencia.
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
        WHEN "hp-codigo":U THEN ASSIGN pFieldValue = RowObject.hp-codigo.
        WHEN "sequencia":U THEN ASSIGN pFieldValue = RowObject.sequencia.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice historico
  Parameters:  
               retorna valor do campo ep-codigo
               retorna valor do campo cod-estabel
               retorna valor do campo referencia
               retorna valor do campo dt-referencia
               retorna valor do campo dt-movto
               retorna valor do campo sequencia
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pep-codigo LIKE contr-hist-exp.ep-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE contr-hist-exp.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER preferencia LIKE contr-hist-exp.referencia NO-UNDO.
    DEFINE OUTPUT PARAMETER pdt-referencia LIKE contr-hist-exp.dt-referencia NO-UNDO.
    DEFINE OUTPUT PARAMETER pdt-movto LIKE contr-hist-exp.dt-movto NO-UNDO.
    DEFINE OUTPUT PARAMETER psequencia LIKE contr-hist-exp.sequencia NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pep-codigo = RowObject.ep-codigo
           pcod-estabel = RowObject.cod-estabel
           preferencia = RowObject.referencia
           pdt-referencia = RowObject.dt-referencia
           pdt-movto = RowObject.dt-movto
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
  Purpose:     Reposiciona registro com base no °ndice historico
  Parameters:  
               recebe valor do campo ep-codigo
               recebe valor do campo cod-estabel
               recebe valor do campo referencia
               recebe valor do campo dt-referencia
               recebe valor do campo dt-movto
               recebe valor do campo sequencia
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo LIKE contr-hist-exp.ep-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE contr-hist-exp.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER preferencia LIKE contr-hist-exp.referencia NO-UNDO.
    DEFINE INPUT PARAMETER pdt-referencia LIKE contr-hist-exp.dt-referencia NO-UNDO.
    DEFINE INPUT PARAMETER pdt-movto LIKE contr-hist-exp.dt-movto NO-UNDO.
    DEFINE INPUT PARAMETER psequencia LIKE contr-hist-exp.sequencia NO-UNDO.

    FIND FIRST bfcontr-hist-exp WHERE 
        bfcontr-hist-exp.ep-codigo = pep-codigo AND 
        bfcontr-hist-exp.cod-estabel = pcod-estabel AND 
        bfcontr-hist-exp.referencia = preferencia AND 
        bfcontr-hist-exp.dt-referencia = pdt-referencia AND 
        bfcontr-hist-exp.dt-movto = pdt-movto AND 
        bfcontr-hist-exp.sequencia = psequencia NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfcontr-hist-exp THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfcontr-hist-exp)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LinkToContrato-Exp DBOProgram 
PROCEDURE LinkToContrato-Exp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter phandle as handle no-undo.
    
    run getkey in phandle (output i-ep-codigo,
                           output c-cod-estabel,
                           output c-referencia,
                           output d-dt-referencia).
                           
    run setConstraintContratoExp in this-procedure (input i-ep-codigo,
                                                    input c-cod-estabel,
                                                    input c-referencia,
                                                    input d-dt-referencia).
                                                    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryContratoExp DBOProgram 
PROCEDURE OpenQueryContratoExp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK
        WHERE contr-hist-exp.ep-codigo     = i-ep-codigo     and
              contr-hist-exp.cod-estabel   = c-cod-estabel   and 
              contr-hist-exp.referencia    = c-referencia    and 
              contr-hist-exp.dt-referencia = d-dt-referencia.
        
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryMain DBOProgram 
PROCEDURE OpenQueryMain :
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-historico DBOProgram 
PROCEDURE pi-atualiza-historico :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param p-ep-codigo     like contr-hist-exp.ep-codigo     no-undo.
    def input param p-cod-estabel   like contr-hist-exp.cod-estabel   no-undo.
    def input param p-referencia    like contr-hist-exp.referencia    no-undo.
    def input param p-dt-referencia like contr-hist-exp.dt-referencia no-undo.
    def input param p-campo         as   char                         no-undo.
    def input param p-vl-atual      as   char                         no-undo.
    def input param p-vl-novo       as   char                         no-undo.

    assign cQueryUseded = "Main".
    for each RowObject exclusive-lock:
        delete RowObject.
    end.

    create RowObject.
    assign RowObject.ep-codigo     = p-ep-codigo
           RowObject.cod-estabel   = p-cod-estabel
           RowObject.referencia    = p-referencia
           RowObject.dt-referencia = p-dt-referencia
           RowObject.dt-movto      = today
           RowObject.historico     = "Alterado " + p-campo + " de " + p-vl-atual + " para " + p-vl-novo.

    run CreateRecord in this-procedure.

    RETURN "OK":U.   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-historico2 DBOProgram 
PROCEDURE pi-atualiza-historico2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   def input param p-ep-codigo     like contr-hist-exp.ep-codigo      no-undo.
   def input param p-cod-estabel   like contr-hist-exp.cod-estabel    no-undo.
   def input param p-referencia    like contr-hist-exp.referencia     no-undo.
   def input param p-dt-referencia like contr-hist-exp.dt-referencia  no-undo.
   def input param p-campo         as   char                          no-undo.
   def input param p-vl-atual      as   char                          no-undo.
   def input param p-vl-novo       as   char                          no-undo.
   def input param p-nr-docto      like contr-titulo-exp.nr-docto     no-undo.
   def input param p-serie         like contr-titulo-exp.serie        no-undo.
   def input param p-cod-esp       like contr-titulo-exp.cod-esp      no-undo.
   def input param p-cod-emitente  like contr-titulo-exp.cod-emitente no-undo.

   assign cQueryUseded = "Main".
   for each RowObject exclusive-lock:
      delete RowObject.
   end.

   create RowObject.
   assign RowObject.ep-codigo     = p-ep-codigo
          RowObject.cod-estabel   = p-cod-estabel
          RowObject.referencia    = p-referencia
          RowObject.dt-referencia = p-dt-referencia
          RowObject.dt-movto      = today
          RowObject.historico     = "Alterado " 
                                    + p-campo 
                                    + " de " 
                                    + p-vl-atual 
                                    + " para " 
                                    + p-vl-novo 
                                    + ". Do titulo " 
                                    + p-nr-docto 
                                    + ", serie " 
                                    + p-serie  
                                    + ", especie " 
                                    + p-cod-esp 
                                    + ", emitente " 
                                    + string(p-cod-emitente).
   run createRecord in this-procedure.
   
   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-historico3 DBOProgram 
PROCEDURE pi-atualiza-historico3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   def input param p-ep-codigo     like contr-hist-exp.ep-codigo      no-undo.
   def input param p-cod-estabel   like contr-hist-exp.cod-estabel    no-undo.
   def input param p-referencia    like contr-hist-exp.referencia     no-undo.
   def input param p-dt-referencia like contr-hist-exp.dt-referencia  no-undo.
   def input param p-descricao     as   char                          no-undo.
   def input param p-nr-docto      like contr-titulo-exp.nr-docto     no-undo.
   def input param p-serie         like contr-titulo-exp.serie        no-undo.
   def input param p-cod-esp       like contr-titulo-exp.cod-esp      no-undo.
   def input param p-cod-emitente  like contr-titulo-exp.cod-emitente no-undo.
   def input param p-vl-alterado   as   char                          no-undo.

   assign cQueryUseded = "Main".
   for each RowObject exclusive-lock:
      delete RowObject.
   end.

   create RowObject.
   assign RowObject.ep-codigo     = p-ep-codigo
          RowObject.cod-estabel   = p-cod-estabel
          RowObject.referencia    = p-referencia
          RowObject.dt-referencia = p-dt-referencia
          RowObject.dt-movto      = today
          RowObject.historico     = p-descricao 
                                    + " " 
                                    + p-nr-docto 
                                    + ", serie " 
                                    + p-serie  
                                    + ", especie " 
                                    + p-cod-esp 
                                    + ", emitente " 
                                    + string(p-cod-emitente)
                                    + " no valor de " 
                                    + p-vl-alterado.
   run createRecord in this-procedure.
   
   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-historico4 DBOProgram 
PROCEDURE pi-atualiza-historico4 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   def input param p-ep-codigo     like contr-hist-exp.ep-codigo      no-undo.
   def input param p-cod-estabel   like contr-hist-exp.cod-estabel    no-undo.
   def input param p-referencia    like contr-hist-exp.referencia     no-undo.
   def input param p-dt-referencia like contr-hist-exp.dt-referencia  no-undo.
   def input param p-dat-pagto     as   date                          no-undo.
   def input param p-val-pagto     as   decimal                       no-undo.

   assign cQueryUseded = "Main".
   for each RowObject exclusive-lock:
      delete RowObject.
   end.
   
   create RowObject.
   assign RowObject.ep-codigo     = p-ep-codigo
          RowObject.cod-estabel   = p-cod-estabel
          RowObject.referencia    = p-referencia
          RowObject.dt-referencia = p-dt-referencia
          RowObject.dt-movto      = today
          RowObject.historico     = "Remessa Gerada no dia "
                                  + string(p-dat-pagto)
                                  + " ao valor de "
                                  + string(p-val-pagto).
   
   run createRecord in this-procedure.
   
   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-historico5 DBOProgram 
PROCEDURE pi-atualiza-historico5 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   def input param p-ep-codigo     like contr-hist-exp.ep-codigo      no-undo.
   def input param p-cod-estabel   like contr-hist-exp.cod-estabel    no-undo.
   def input param p-referencia    like contr-hist-exp.referencia     no-undo.
   def input param p-dt-referencia like contr-hist-exp.dt-referencia  no-undo.
   def input param p-cdn-fornec    as   int                           no-undo.
   def input param p-cod-especie   as   char                          no-undo.
   def input param p-serie         as   char                          no-undo.
   def input param v-referencia    as   char                          no-undo.
   def input param v-cod-estab-5   as   char                          no-undo.
   def input param p-data          as   date                          no-undo.
   def input param p-valor         as   decimal                       no-undo.
   
   assign cQueryUseded = "Main".
   for each RowObject exclusive-lock:
      delete RowObject.
   end.
   
   create RowObject.
   assign RowObject.ep-codigo     = p-ep-codigo
          RowObject.cod-estabel   = p-cod-estabel
          RowObject.referencia    = p-referencia
          RowObject.dt-referencia = p-dt-referencia
          RowObject.dt-movto      = today
          RowObject.historico     = "Titulo APB. Est. "
                                    + v-cod-estab-5
                                    + ", ser "    + p-serie
                                    + ", esp "    + p-cod-especie
                                    + ", fornec " + string(p-cdn-fornec)
                                    + ", tit "    + v-referencia
                                    + ", / 01 "   
                                    + ",Data "    + string(p-data)
                                    + ",Valor "   + string(p-valor).

   run createRecord in this-procedure.
   
   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-historico5 DBOProgram 
PROCEDURE pi-atualiza-historico6 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   def input param p-ep-codigo     like contr-hist-exp.ep-codigo      no-undo.
   def input param p-cod-estabel   like contr-hist-exp.cod-estabel    no-undo.
   def input param p-referencia    like contr-hist-exp.referencia     no-undo.
   def input param p-dt-referencia like contr-hist-exp.dt-referencia  no-undo.
   def input param p-historico    as   char                           no-undo.
   
   assign cQueryUseded = "Main".
   for each RowObject exclusive-lock:
      delete RowObject.
   end.
   
   create RowObject.
   assign RowObject.ep-codigo     = p-ep-codigo
          RowObject.cod-estabel   = p-cod-estabel
          RowObject.referencia    = p-referencia
          RowObject.dt-referencia = p-dt-referencia
          RowObject.dt-movto      = today
          RowObject.historico     = p-historico   .

   run createRecord in this-procedure.
   
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
    def var c-usuario like contr-hist-exp.usuario no-undo.
    
    {method/svc/autentic/autentic.i
            &vUserName="c-usuario"}
    
    assign RowObject.usuario   = c-usuario
           RowObject.c-time   = string(TIME, "HH:MM")
           RowObject.dt-today = today.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetConstraintContratoExp DBOProgram 
PROCEDURE SetConstraintContratoExp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo     LIKE contr-docto-exp.ep-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel   LIKE contr-docto-exp.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER preferencia    LIKE contr-docto-exp.referencia NO-UNDO.
    DEFINE INPUT PARAMETER pdt-referencia LIKE contr-docto-exp.dt-referencia NO-UNDO.
    
    assign i-ep-codigo     = pep-codigo
           c-cod-estabel   = pcod-estabel
           c-referencia    = preferencia
           d-dt-referencia = pdt-referencia.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetConstraintMain DBOProgram 
PROCEDURE SetConstraintMain :
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
&IF "{&mguni_version}" >= "2.07A" &THEN
       if RowObject.ep-codigo = "" then do:
&ELSE
       if RowObject.ep-codigo = 0 then do:
&ENDIF
          {method/svc/errors/inserr.i
                     &ErrorNumber="8741"
                     &ErrorType="EMS"
                     &ErrorParameters="''"} 
       end.

       if RowObject.cod-estabel = "" then do:
          {method/svc/errors/inserr.i
                     &ErrorNumber="16995"
                     &ErrorType="EMS"
                     &ErrorParameters="''"}
       end.

       if RowObject.referencia = "" then do:
          {utp/ut-liter.i "REFERENCIA NAO PODE TER COMO VALOR BRANCO" * }
          {method/svc/errors/inserr.i
                     &ErrorNumber="7"
                     &ErrorType="EMS"
                     &ErrorParameters="return-value"}
       end.

       if RowObject.dt-referencia = ? then do:
          {utp/ut-liter.i "DT-REFERENCIA NAO PODE TER COMO VALOR BRANCO" * }
          {method/svc/errors/inserr.i
                     &ErrorNumber="7"
                     &ErrorType="EMS"
                     &ErrorParameters="return-value"}
       end.

       if RowObject.dt-movto = ? then do:
          {method/svc/errors/inserr.i
                     &ErrorNumber="8846"
                     &ErrorType="EMS"
                     &ErrorParameters="''"}
       end.

       if can-find (first empresa where empresa.ep-codigo = RowObject.ep-codigo) = no then do:
           {utp/ut-liter.i "EMPRESA INEXISTENTE NO CADASTRO DE EMPRESAS" * }
          {method/svc/errors/inserr.i
                     &ErrorNumber="7"
                     &ErrorType="EMS"
                     &ErrorParameters="return-value"}
       end.

       if can-find (first estabelec where estabelec.cod-estabel = RowObject.cod-estabel) = no then do:
          {method/svc/errors/inserr.i
                     &ErrorNumber="2061"
                     &ErrorType="EMS"
                     &ErrorParameters="''"}
       end.
    end.

    if ptype = "Create":U or ptype = "Update":U then do:
       run pi-autenticacao.
    end.
    
    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

