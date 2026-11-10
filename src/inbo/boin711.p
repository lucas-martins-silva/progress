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
{include/i-prgvrs.i BOIN711 2.00.00.007 } /*** "010007" 29/11/2023 09:07:15  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN711 MUT}
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
&GLOBAL-DEFINE DBOName BOIN711
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName rma-param
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 


/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin711.i RowObject}


/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

def var c-cod-estabel-ini as char no-undo.
def var c-cod-estabel-fim as char no-undo.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterNewRecord DBOProgram 
PROCEDURE afterNewRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

 ASSIGN rowObject.num-ult-rma = "0000001":U.

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
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-livre-3":U THEN ASSIGN pFieldValue = RowObject.cod-livre-3.
        WHEN "cod-livre-4":U THEN ASSIGN pFieldValue = RowObject.cod-livre-4.
        WHEN "cod-livre-5":U THEN ASSIGN pFieldValue = RowObject.cod-livre-5.
        WHEN "cod-nat-operacao-nc":U THEN ASSIGN pFieldValue = RowObject.cod-nat-operacao-nc.
        WHEN "cod-nat-operacao-nd":U THEN ASSIGN pFieldValue = RowObject.cod-nat-operacao-nd.
        WHEN "cod-nat-operacao-rd":U THEN ASSIGN pFieldValue = RowObject.cod-nat-operacao-rd.
        WHEN "num-ult-rma":U THEN ASSIGN pFieldValue = RowObject.num-ult-rma.
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
        WHEN "dat-livre-1":U THEN ASSIGN pFieldValue = RowObject.dat-livre-1.
        WHEN "dat-livre-2":U THEN ASSIGN pFieldValue = RowObject.dat-livre-2.
        WHEN "dat-livre-3":U THEN ASSIGN pFieldValue = RowObject.dat-livre-3.
        WHEN "dat-livre-4":U THEN ASSIGN pFieldValue = RowObject.dat-livre-4.
        WHEN "dat-livre-5":U THEN ASSIGN pFieldValue = RowObject.dat-livre-5.
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
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
        WHEN "val-livre-3":U THEN ASSIGN pFieldValue = RowObject.val-livre-3.
        WHEN "val-livre-4":U THEN ASSIGN pFieldValue = RowObject.val-livre-4.
        WHEN "val-livre-5":U THEN ASSIGN pFieldValue = RowObject.val-livre-5.
        WHEN "val-perc-restocagem":U THEN ASSIGN pFieldValue = RowObject.val-perc-restocagem.
        WHEN "val-restocagem":U THEN ASSIGN pFieldValue = RowObject.val-restocagem.
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
        WHEN "num-dias-max-cred":U THEN ASSIGN pFieldValue = RowObject.num-dias-max-cred.
        WHEN "num-dias-max-troca":U THEN ASSIGN pFieldValue = RowObject.num-dias-max-troca.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "num-livre-3":U THEN ASSIGN pFieldValue = RowObject.num-livre-3.
        WHEN "num-livre-4":U THEN ASSIGN pFieldValue = RowObject.num-livre-4.
        WHEN "num-livre-5":U THEN ASSIGN pFieldValue = RowObject.num-livre-5.
        WHEN "vli-incremento-seq":U THEN ASSIGN pFieldValue = RowObject.vli-incremento-seq.
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
               retorna valor do campo cod-estabel
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE rma-param.cod-estabel NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-estabel = RowObject.cod-estabel.

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
        WHEN "log-livre-1":U THEN ASSIGN pFieldValue = RowObject.log-livre-1.
        WHEN "log-livre-2":U THEN ASSIGN pFieldValue = RowObject.log-livre-2.
        WHEN "log-livre-3":U THEN ASSIGN pFieldValue = RowObject.log-livre-3.
        WHEN "log-livre-4":U THEN ASSIGN pFieldValue = RowObject.log-livre-4.
        WHEN "log-livre-5":U THEN ASSIGN pFieldValue = RowObject.log-livre-5.
        WHEN "log-numeracao-rma-auto":U THEN ASSIGN pFieldValue = RowObject.log-numeracao-rma-auto.
        WHEN "log-obriga-doc-sai":U THEN ASSIGN pFieldValue = RowObject.log-obriga-doc-sai.
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
               recebe valor do campo cod-estabel
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE rma-param.cod-estabel NO-UNDO.

    FIND FIRST bfrma-param WHERE 
        bfrma-param.cod-estabel = pcod-estabel NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfrma-param THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfrma-param)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryEstabelec DBOProgram 
PROCEDURE openQueryEstabelec :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
OPEN QUERY {&QueryName} FOR EACH rma-param where
                                 rma-param.cod-estabel   >= c-cod-estabel-ini and 
                                 rma-param.cod-estabel   <= c-cod-estabel-fim NO-LOCK.

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
    OPEN QUERY {&QueryName} FOR EACH rma-param NO-LOCK INDEXED-REPOSITION.
    return "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnDadosRMA DBOProgram 
PROCEDURE returnDadosRMA :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input  parameter p-c-cod-estabel like rma-param.cod-estabel no-undo.
def output parameter p-l-possui-RMA  as   log                   no-undo.

   find first rma where rma.cod-estabel = p-c-cod-estabel no-lock no-error.
   if avail rma then
      assign p-l-possui-RMA = yes.      

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnSerie DBOProgram 
PROCEDURE returnSerie :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  parameter p-c-cod-estabel like rma-param.cod-estabel          no-undo.
    def output parameter p-c-serie       like rma-param.cod-serie-pad-remito no-undo.

   find first estabelec where estabelec.cod-estabel = p-c-cod-estabel no-lock no-error.
   if avail estabelec then do:
      assign p-c-serie = estabelec.serie.
      return "OK":U.
   end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintEstabelec DBOProgram 
PROCEDURE setConstraintEstabelec :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input  param p-c-cod-estabel-ini as char    no-undo.
def input  param p-c-cod-estabel-fim as char    no-undo.

assign c-cod-estabel-ini = p-c-cod-estabel-ini
       c-cod-estabel-fim = p-c-cod-estabel-fim.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaEstabel DBOProgram 
PROCEDURE validaEstabel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input  parameter p-c-cod-estabel like rma-param.cod-estabel no-undo.
def output parameter p-c-nome        as   char                  no-undo.

   find first estabelec where estabelec.cod-estabel = p-c-cod-estabel no-lock no-error.
   if avail estabelec then
      assign p-c-nome = estabelec.nome.      
      
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
    
    def var i-nr-ult-rma as int format ">>>>>>>>>>>>>>>9" no-undo.
    
    IF pType = "Create":U then do:
       if RowObject.cod-estabel = "" THEN DO:
          /* Inicio -- Projeto Internacional */
          DEFINE VARIABLE c-lbl-liter-estabelecimento AS CHARACTER NO-UNDO.
          {utp/ut-liter.i "Estabelecimento" *}
          ASSIGN c-lbl-liter-estabelecimento = TRIM(RETURN-VALUE).
          {method/svc/errors/inserr.i &ErrorNumber="6216"
                                      &ErrorType="EMS"
                                      &ErrorSubType="ERROR"
                                      &ErrorParameters="c-lbl-liter-estabelecimento"}
          END. 
       else do:
           find first bfrma-param where
                      bfrma-param.cod-estabel = RowObject.cod-estabel no-lock no-error.
           if avail bfrma-param THEN DO:
             /* Inicio -- Projeto Internacional */
             DEFINE VARIABLE c-lbl-liter-estabelecimento-2 AS CHARACTER NO-UNDO.
             {utp/ut-liter.i "Estabelecimento" *}
             ASSIGN c-lbl-liter-estabelecimento-2 = TRIM(RETURN-VALUE).
             {method/svc/errors/inserr.i &ErrorNumber="8"
                                         &ErrorType="EMS"
                                         &ErrorSubType="ERROR"
                                         &ErrorParameters="c-lbl-liter-estabelecimento-2"}
             END.
           else do:
               find first estabelec where 
                          estabelec.cod-estabel = RowObject.cod-estabel no-lock no-error.
               if not avail estabelec THEN DO:
                  /* Inicio -- Projeto Internacional */
                  {utp/ut-table.i mgadm estabelec 1} /* Busca o label da tabela */
                  {method/svc/errors/inserr.i &ErrorNumber="56"
                                              &ErrorType="EMS"
                                              &ErrorSubType="ERROR"
                                              &ErrorParameters=TRIM(RETURN-VALUE)}
               END.
           end.
       end.
    END.
    
    IF pType = "Create":U or pType = "Update":U then do:
       
       /*********** Valida Nr Èltima RMA *************/

       if RowObject.num-ult-rma <> "" then do:
           assign i-nr-ult-rma = int(RowObject.num-ult-rma) no-error.
           if  error-status:get-message(1) <> '' then do:
              /* Inicio -- Projeto Internacional */
              DEFINE VARIABLE c-lbl-liter-nr-ultima-rma AS CHARACTER NO-UNDO.
              {utp/ut-liter.i "Nr_Èltima_RMA" *}
              ASSIGN c-lbl-liter-nr-ultima-rma = TRIM(RETURN-VALUE).
              {method/svc/errors/inserr.i &ErrorNumber="27390"
                                          &ErrorType="EMS"
                                          &ErrorSubType="ERROR"
                                          &ErrorParameters="c-lbl-liter-nr-ultima-rma"}

           end.
           else do:
            if int(RowObject.num-ult-rma) < 0 THEN DO:
               /* Inicio -- Projeto Internacional */
               DEFINE VARIABLE c-lbl-liter-nr-ultima-rma-2 AS CHARACTER NO-UNDO.
               {utp/ut-liter.i "Nr_Èltima_RMA" *}
               ASSIGN c-lbl-liter-nr-ultima-rma-2 = TRIM(RETURN-VALUE).
               {method/svc/errors/inserr.i &ErrorNumber="36"
                                           &ErrorType="EMS"
                                           &ErrorSubType="ERROR"
                                           &ErrorParameters="c-lbl-liter-nr-ultima-rma-2"}
               END. 
           end.
       end.
       

       /*********** Valida Incremento Sequencia RMA *************/

       IF RowObject.vli-incremento-seq < 1 THEN DO:
          /* Inicio -- Projeto Internacional */
          DEFINE VARIABLE c-lbl-liter-incremento-sequencia-rma AS CHARACTER NO-UNDO.
          {utp/ut-liter.i "Incremento_Sequància_RMA" *}
          ASSIGN c-lbl-liter-incremento-sequencia-rma = TRIM(RETURN-VALUE).
          {method/svc/errors/inserr.i &ErrorNumber="36"
                                      &ErrorType="EMS"
                                      &ErrorSubType="ERROR"
                                      &ErrorParameters="c-lbl-liter-incremento-sequencia-rma"}
       END.

       /*********** Valida SÇrie *************/

       IF RowObject.cod-serie-pad-remito = "" THEN DO:
          /* Inicio -- Projeto Internacional */
          DEFINE VARIABLE c-lbl-liter-serie AS CHARACTER NO-UNDO.
          {utp/ut-liter.i "SÇrie" *}
          ASSIGN c-lbl-liter-serie = TRIM(RETURN-VALUE).
          {method/svc/errors/inserr.i &ErrorNumber="25938"
                                      &ErrorType="EMS"
                                      &ErrorSubType="ERROR"
                                      &ErrorParameters="c-lbl-liter-serie"}
       END.
       else do:
           find first serie where
                      serie.serie = RowObject.cod-serie-pad-remito no-lock no-error.
           if not avail serie THEN DO:
             /* Inicio -- Projeto Internacional */
             {utp/ut-table.i mgind serie 1} /* Busca o label da tabela */
             {method/svc/errors/inserr.i &ErrorNumber="56"
                                         &ErrorType="EMS"
                                         &ErrorSubType="ERROR"
                                         &ErrorParameters=TRIM(RETURN-VALUE)}
           END.             
           else
             if serie.int-1 <> 2 then
                {method/svc/errors/inserr.i &ErrorNumber="17572"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="''"}.
       end.
       
       
       /****** Valida Natureza Operaá∆o *****/
       
       if Rowobject.cod-nat-operacao-nc = "" THEN DO:
          /* Inicio -- Projeto Internacional */
          DEFINE VARIABLE c-lbl-liter-natureza-nota-credito AS CHARACTER NO-UNDO.
          {utp/ut-liter.i "Natureza_Nota_CrÇdito" *}
          ASSIGN c-lbl-liter-natureza-nota-credito = TRIM(RETURN-VALUE).
          {method/svc/errors/inserr.i &ErrorNumber="25938"
                                      &ErrorType="EMS"
                                      &ErrorSubType="ERROR"
                                      &ErrorParameters="c-lbl-liter-natureza-nota-credito"}
          END. 
       else do:
          find first natur-oper where
                      natur-oper.nat-operacao = RowObject.cod-nat-operacao-nc no-lock no-error.
          if not avail natur-oper then
             /* Inicio -- Projeto Internacional */
             DO:
             DEFINE VARIABLE c-lbl-liter-natureza-nota-credito-2 AS CHARACTER NO-UNDO.
             {utp/ut-liter.i "Natureza_Nota_CrÇdito" *}
             ASSIGN c-lbl-liter-natureza-nota-credito-2 = TRIM(RETURN-VALUE).
             {method/svc/errors/inserr.i &ErrorNumber="56"
                                         &ErrorType="EMS"
                                         &ErrorSubType="ERROR"
                                         &ErrorParameters="c-lbl-liter-natureza-nota-credito-2"}
             END. 
          else
            if natur-oper.tipo <> 1 and
               natur-oper.tipo <> 2 then
                /* Inicio -- Projeto Internacional */
                DO:
                DEFINE VARIABLE c-lbl-liter-natureza-nota-credito-3 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Natureza_Nota_CrÇdito" *}
                ASSIGN c-lbl-liter-natureza-nota-credito-3 = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i &ErrorNumber="27021"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="c-lbl-liter-natureza-nota-credito-3"}
                END. .       
       end.
       
       if Rowobject.cod-nat-operacao-nd = "" then
          /* Inicio -- Projeto Internacional */
          DO:
          DEFINE VARIABLE c-lbl-liter-natureza-nota-debito AS CHARACTER NO-UNDO.
          {utp/ut-liter.i "Natureza_Nota_DÇbito" *}
          ASSIGN c-lbl-liter-natureza-nota-debito = TRIM(RETURN-VALUE).
          {method/svc/errors/inserr.i &ErrorNumber="25938"
                                      &ErrorType="EMS"
                                      &ErrorSubType="ERROR"
                                      &ErrorParameters="c-lbl-liter-natureza-nota-debito"}
          END. 
       else do:
          find first natur-oper where
                      natur-oper.nat-operacao = RowObject.cod-nat-operacao-nd no-lock no-error.
          if not avail natur-oper then
             /* Inicio -- Projeto Internacional */
             DO:
             DEFINE VARIABLE c-lbl-liter-natureza-nota-debito-2 AS CHARACTER NO-UNDO.
             {utp/ut-liter.i "Natureza_Nota_DÇbito" *}
             ASSIGN c-lbl-liter-natureza-nota-debito-2 = TRIM(RETURN-VALUE).
             {method/svc/errors/inserr.i &ErrorNumber="56"
                                         &ErrorType="EMS"
                                         &ErrorSubType="ERROR"
                                         &ErrorParameters="c-lbl-liter-natureza-nota-debito-2"}
             END. 
          else
            if natur-oper.tipo <> 2 then
               /* Inicio -- Projeto Internacional */
               DO:
               DEFINE VARIABLE c-lbl-liter-natureza-nota-debito-3 AS CHARACTER NO-UNDO.
               {utp/ut-liter.i "Natureza_Nota_DÇbito" *}
               ASSIGN c-lbl-liter-natureza-nota-debito-3 = TRIM(RETURN-VALUE).
               {method/svc/errors/inserr.i &ErrorNumber="27021"
                                           &ErrorType="EMS"
                                           &ErrorSubType="ERROR"
                                           &ErrorParameters="c-lbl-liter-natureza-nota-debito-3"}
               END. .    
       end.
       
       if Rowobject.cod-nat-operacao-rd = "" then
          /* Inicio -- Projeto Internacional */
          DO:
          DEFINE VARIABLE c-lbl-liter-natureza-remito-devolucao AS CHARACTER NO-UNDO.
          {utp/ut-liter.i "Natureza_Remito_Devoluá∆o" *}
          ASSIGN c-lbl-liter-natureza-remito-devolucao = TRIM(RETURN-VALUE).
          {method/svc/errors/inserr.i &ErrorNumber="25938"
                                      &ErrorType="EMS"
                                      &ErrorSubType="ERROR"
                                      &ErrorParameters="c-lbl-liter-natureza-remito-devolucao"}
          END. 
       else do:
          find first natur-oper where
                      natur-oper.nat-operacao = RowObject.cod-nat-operacao-rd no-lock no-error.
          if not avail natur-oper then
             /* Inicio -- Projeto Internacional */
             DO:
             DEFINE VARIABLE c-lbl-liter-natureza-remito-devolucao-2 AS CHARACTER NO-UNDO.
             {utp/ut-liter.i "Natureza_Remito_Devoluá∆o" *}
             ASSIGN c-lbl-liter-natureza-remito-devolucao-2 = TRIM(RETURN-VALUE).
             {method/svc/errors/inserr.i &ErrorNumber="56"
                                         &ErrorType="EMS"
                                         &ErrorSubType="ERROR"
                                         &ErrorParameters="c-lbl-liter-natureza-remito-devolucao-2"}
             END. 
          else
            if natur-oper.tipo <> 2 then
               /* Inicio -- Projeto Internacional */
               DO:
               DEFINE VARIABLE c-lbl-liter-natureza-remito-devolucao-3 AS CHARACTER NO-UNDO.
               {utp/ut-liter.i "Natureza_Remito_Devoluá∆o" *}
               ASSIGN c-lbl-liter-natureza-remito-devolucao-3 = TRIM(RETURN-VALUE).
               {method/svc/errors/inserr.i &ErrorNumber="27021"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="c-lbl-liter-natureza-remito-devolucao-3"}
               END. .    
       end.       
       
    END.
    
    IF pType = "Delete":U then do:
       
       Find first rma where rma.cod-estabel = bfrma-param.cod-estabel no-lock no-error.
       if avail rma then
         {method/svc/errors/inserr.i &ErrorNumber="27024"
                                     &ErrorType="EMS"
                                     &ErrorSubType="ERROR"
                                     &ErrorParameters="bfrma-param.cod-estabel"}.  
    END.
        
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
