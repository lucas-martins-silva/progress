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
{include/i-prgvrs.i BOAD229O 2.00.00.010} /*** "010010" 21/11/2023 13:57:27 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOAD229O MUT}
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
&GLOBAL-DEFINE DBOName BOAD229
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName repres
&GLOBAL-DEFINE TableLabel Representante
&GLOBAL-DEFINE QueryName qr{&TableName} 


/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{adbo/boad229o.i RowObject}


/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}

/*miniflexibilizaá∆o*/
{cdp/cdcfgfin.i}

/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

define temp-table  tt-repres no-undo
    field cod_repres         as integer
    field nome               as char format "x(40)"
    field cod-imposto        as int  format ">>>9"
    field des-imposto        as char format "x(30)"
    field aliquota           as dec  format ">>>.99"
    field vl-minimo-ret      as dec  format ">>>,>>>,>>9.99"
    field cod-impto-indeniz  as int  format ">>>9"
    field des-impto-indeniz  as char format "x(30)"
    field aliquota-indeniz   as dec  format ">>>.99"
    field vl-min-ret-indeniz as dec  format ">>>,>>>,>>9.99".

DEFINE TEMP-TABLE tt-tipo-tax no-undo
    FIELD cod-tax            LIKE tipo-tax.cod-tax
    FIELD descricao          LIKE tipo-tax.descricao
    FIELD tax-perc           LIKE tipo-tax.tax-perc
    FIELD vl-minimo-retencao LIKE tipo-tax.vl-minimo-retencao.

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
   Other Settings: CODE-ONLY COMPILE
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BuscaTipoRepres DBOProgram 
PROCEDURE BuscaTipoRepres :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  def input param p-cod-repres as int no-undo.
  def output param p-tipo      as int no-undo.

  find repres where 
       repres.cod-rep = p-cod-repres no-lock no-error.
  if avail repres then
     &IF DEFINED(BF_FIN_RAC) &THEN
         assign p-tipo = repres.tipo-repres.
     &ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CustomGoToKey DBOProgram 
PROCEDURE CustomGoToKey :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define input        parameter i-representante as integer   format ">>>>9" no-undo.
define input-output parameter i-repres-ax     as integer   format ">>>>9" no-undo.
define input-output parameter c-nome-rep-ax   as character format "X(40)" no-undo.
    
    find first repres where 
               repres.cod-rep = i-representante no-lock no-error.
    if not avail repres then 
       return "NOK":U.
    
    assign i-repres-ax   = repres.cod-rep 
           c-nome-rep-ax = repres.nome.

    return "OK":U.
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
        WHEN "bairro":U THEN ASSIGN pFieldValue = RowObject.bairro.
        WHEN "caixa-postal":U THEN ASSIGN pFieldValue = RowObject.caixa-postal.
        WHEN "cep":U THEN ASSIGN pFieldValue = RowObject.cep.
        WHEN "cgc":U THEN ASSIGN pFieldValue = RowObject.cgc.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cidade":U THEN ASSIGN pFieldValue = RowObject.cidade.
        WHEN "Complemento":U THEN ASSIGN pFieldValue = RowObject.Complemento.
        WHEN "e-mail":U THEN ASSIGN pFieldValue = RowObject.e-mail.
        WHEN "endereco":U THEN ASSIGN pFieldValue = RowObject.endereco.
        WHEN "estado":U THEN ASSIGN pFieldValue = RowObject.estado.
        WHEN "home-page":U THEN ASSIGN pFieldValue = RowObject.home-page.
        WHEN "ins-municipal":U THEN ASSIGN pFieldValue = RowObject.ins-municipal.
        WHEN "inscr-est":U THEN ASSIGN pFieldValue = RowObject.inscr-est.
        WHEN "nome":U THEN ASSIGN pFieldValue = RowObject.nome.
        WHEN "nome-ab-reg":U THEN ASSIGN pFieldValue = RowObject.nome-ab-reg.
        WHEN "nome-abrev":U THEN ASSIGN pFieldValue = RowObject.nome-abrev.
        WHEN "pais":U THEN ASSIGN pFieldValue = RowObject.pais.
        WHEN "permissao":U THEN ASSIGN pFieldValue = RowObject.permissao.
        WHEN "telef-modem":U THEN ASSIGN pFieldValue = RowObject.telef-modem.
        WHEN "telefax":U THEN ASSIGN pFieldValue = RowObject.telefax.
        WHEN "telefone[1]":U THEN ASSIGN pFieldValue = RowObject.telefone[1].
        WHEN "telefone[2]":U THEN ASSIGN pFieldValue = RowObject.telefone[2].
        WHEN "telex":U THEN ASSIGN pFieldValue = RowObject.telex.
        WHEN "zip-code":U THEN ASSIGN pFieldValue = RowObject.zip-code.
        &IF DEFINED(BF_FIN_RAC) &THEN
            WHEN "calendario-pagto":U THEN ASSIGN pFieldValue = RowObject.calendario-pagto.
        &ENDIF

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
        &IF DEFINED(BF_FIN_RAC) &THEN
            WHEN "dt-deslig":U THEN ASSIGN pFieldValue = RowObject.dt-deslig.
        &ENDIF
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
        WHEN "comis-direta":U THEN ASSIGN pFieldValue = RowObject.comis-direta.
        WHEN "comis-indir":U THEN ASSIGN pFieldValue = RowObject.comis-indir.
        WHEN "comis-max":U THEN ASSIGN pFieldValue = RowObject.comis-max.
        WHEN "comis-min":U THEN ASSIGN pFieldValue = RowObject.comis-min.
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "perc-aire":U THEN ASSIGN pFieldValue = RowObject.perc-aire.
        &IF DEFINED(BF_FIN_RAC) &THEN
            WHEN "perc-abatimento":U THEN ASSIGN pFieldValue = RowObject.perc-abatimento.
            WHEN "perc-juros":U THEN ASSIGN pFieldValue = RowObject.perc-juros.
            WHEN "perc-multa":U THEN ASSIGN pFieldValue = RowObject.perc-multa.
            WHEN "perc-desconto":U THEN ASSIGN pFieldValue = RowObject.perc-desconto.
            WHEN "perc-ava":U THEN ASSIGN pFieldValue = RowObject.perc-ava.
        &ENDIF 
        
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
        WHEN "cod-rep":U THEN ASSIGN pFieldValue = RowObject.cod-rep.
        WHEN "comis-emis":U THEN ASSIGN pFieldValue = RowObject.comis-emis.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "natureza":U THEN ASSIGN pFieldValue = RowObject.natureza.
        WHEN "rep-indireto":U THEN ASSIGN pFieldValue = RowObject.rep-indireto.
        &IF DEFINED(BF_FIN_RAC) &THEN
            WHEN "fc-codigo":U THEN ASSIGN pFieldValue = RowObject.fc-codigo.
            WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
            WHEN "cod-tax":U THEN ASSIGN pFieldValue = RowObject.cod-tax.
            WHEN "tipo-repres":U THEN ASSIGN pFieldValue = RowObject.tipo-repres.
            WHEN "tipo-comis":U THEN ASSIGN pFieldValue = RowObject.tipo-comis.
        &ENDIF
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice codigo
  Parameters:  
               retorna valor do campo cod-rep
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-rep LIKE repres.cod-rep NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-rep = RowObject.cod-rep.

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
        &IF DEFINED(BF_FIN_RAC) &THEN
            WHEN "bloqueado-pagto":U THEN ASSIGN pFieldValue = RowObject.bloqueado-pagto.
            WHEN "comis-propor":U THEN ASSIGN pFieldValue = RowObject.comis-propor.
        &ENDIF
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
  Purpose:     Reposiciona registro com base no °ndice codigo
  Parameters:  
               recebe valor do campo cod-rep
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-rep LIKE repres.cod-rep NO-UNDO.

    FIND FIRST bfrepres WHERE 
        bfrepres.cod-rep = pcod-rep NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfrepres THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfrepres)).
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
  open query {&queryName}
        for each {&tableName} no-lock INDEXED-REPOSITION.
   
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaRepres DBOProgram 
PROCEDURE retornaRepres :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  def input        param c-registro    as character format "x10"   no-undo.
  def input-output param i-repres-ax   as integer   format ">>>>9" no-undo.
  def input-output param c-nome-rep-ax as character format "X(40)" no-undo.
  def input-output param i-cod-tax     as integer   format "9999"  no-undo.

  def var l-reg as log no-undo.

  assign l-reg = yes.
  case c-registro:
     when "first" then find first repres no-lock no-error.
     when "prev"  then find prev  repres no-lock no-error.
     when "next"  then find next  repres no-lock no-error.
     when "last"  then find last  repres no-lock no-error.
     otherwise    assign l-reg = no.
  end case.

  if l-reg and avail repres then 
     assign i-repres-ax   = repres.cod-rep 
            c-nome-rep-ax = repres.nome
            i-cod-tax     = repres.cod-tax.

  RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE seleciona_rep DBOProgram 
PROCEDURE seleciona_rep :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  def input  param i-repres_ini as int no-undo.
  def input  param i-repres_fim as int no-undo.
  def output param table for tt-repres.

  for each tt-repres.
     delete tt-repres.
  end.

  FOR EACH tt-tipo-tax NO-LOCK:
     DELETE tt-tipo-tax.
  END.

  for each repres fields (repres.cod-rep
                          repres.nome
                          repres.cod-tax
                          repres.cod-tax-indeniz) where 
           repres.cod-rep >= i-repres_ini and 
           repres.cod-rep <= i-repres_fim no-lock:

     create tt-repres.
     assign tt-repres.cod_repres = repres.cod-rep
            tt-repres.nome       = repres.nome.
            
     /* Ini Imposto de Retencao */
     find first tt-tipo-tax where 
                tt-tipo-tax.cod-tax = repres.cod-tax no-lock no-error.
     if not avail tt-tipo-tax then do:
    
        find first tipo-tax where 
                   tipo-tax.cod-tax = repres.cod-tax no-lock no-error.
        if avail tipo-tax then do:                     
           create tt-tipo-tax.
           assign tt-tipo-tax.cod-tax            = tipo-tax.cod-tax
                  tt-tipo-tax.descricao          = tipo-tax.descricao
                  tt-tipo-tax.tax-perc           = tipo-tax.tax-perc
                  tt-tipo-tax.vl-minimo-retencao = tipo-tax.vl-minimo-retencao.
        end.          
     end.    
            
     if avail tt-tipo-tax then        
        assign tt-repres.cod-imposto   = tt-tipo-tax.cod-tax   
               tt-repres.des-imposto   = tt-tipo-tax.descricao 
               tt-repres.aliquota      = tt-tipo-tax.tax-perc  
               tt-repres.vl-minimo-ret = tt-tipo-tax.vl-minimo-retencao.
     /* Fim Imposto de Retencao */

     /* Ini Imposto de Retencao Indeniz */
     find first tt-tipo-tax where 
                tt-tipo-tax.cod-tax = repres.cod-tax-indeniz no-lock no-error.
     if not avail tt-tipo-tax then do:
    
        find first tipo-tax where 
                   tipo-tax.cod-tax = repres.cod-tax-indeniz no-lock no-error.
        if avail tipo-tax then do:                     
           create tt-tipo-tax.
           assign tt-tipo-tax.cod-tax            = tipo-tax.cod-tax
                  tt-tipo-tax.descricao          = tipo-tax.descricao
                  tt-tipo-tax.tax-perc           = tipo-tax.tax-perc
                  tt-tipo-tax.vl-minimo-retencao = tipo-tax.vl-minimo-retencao.
        end.          
     end.

     if avail tt-tipo-tax then        
        assign tt-repres.cod-impto-indeniz  = tt-tipo-tax.cod-tax   
               tt-repres.des-impto-indeniz  = tt-tipo-tax.descricao 
               tt-repres.aliquota-indeniz   = tt-tipo-tax.tax-perc  
               tt-repres.vl-min-ret-indeniz = tt-tipo-tax.vl-minimo-retencao.
     /* Fim Imposto de Retencao Indeniz */
  end.   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setContrantMain DBOProgram 
PROCEDURE setContrantMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    return "OK":U.   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaEliminCalend DBOProgram 
PROCEDURE validaEliminCalend :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* MÇtodo utilizado pelo Calend†rio de Comiss‰es.
   Verificaá∆o de relacionamento entre o Calend†rio de Comiss‰es e Representante */
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    &IF DEFINED(BF_FIN_RAC) &THEN

        find first repres
            where repres.calendario-pagto = ptype no-lock no-error.
        if available repres then do:
            {method/svc/errors/inserr.i
            &ErrorNumber="19218"
            &ErrorType="mgrac"
            &ErrorSubType="Error"}
        end.
    &ENDIF
    
/*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
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


