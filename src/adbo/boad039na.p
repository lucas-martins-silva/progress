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
{include/i-prgvrs.i BOAD039NA 2.00.00.010 } /*** "010010" 16/09/2024 16:50:55 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOAD039NA MUT}
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
&GLOBAL-DEFINE DBOName BOAD039
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName cond-pagto
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

&GLOBAL-DEFINE KeyField1 cod-cond-pag /*:T Informar os campos da chave quando o Progress nío conseguir resolver find {&TableName} OF RowObject. */
&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (m≤todo Receive Message) */
&GLOBAL-DEFINE XMLProducer YES    /*:T DBO atua como producer de mensagens para o Message Broker */
&GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES

{cdp/cdcfgdis.i}

/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{adbo/boad039na.i RowObject}


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

/* Definiá∆o das vari†veis para a setConstraintFaixaCondPagto */

def var i-cod-cond-pag-ini  as integer no-undo.
def var i-cod-cond-pag-fim  as integer no-undo.

/* Definiá∆o das vari†veis para a setConstraintFaixaDescricao */

def var c-descricao-ini    as char    no-undo.
def var c-descricao-fim    as char    no-undo.

DEF VAR c-traduz   AS CHARACTER NO-UNDO. 

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
        WHEN "descricao":U THEN ASSIGN pFieldValue = RowObject.descricao.
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
        WHEN "per-des-pgan" THEN ASSIGN pFieldValue = RowObject.per-des-pgan.
        WHEN "per-pg-dup[1]" THEN ASSIGN pFieldValue = RowObject.per-pg-dup[1].
        WHEN "per-pg-dup[2]" THEN ASSIGN pFieldValue = RowObject.per-pg-dup[2].
        WHEN "per-pg-dup[3]" THEN ASSIGN pFieldValue = RowObject.per-pg-dup[3].
        WHEN "per-pg-dup[4]" THEN ASSIGN pFieldValue = RowObject.per-pg-dup[4].
        WHEN "per-pg-dup[5]" THEN ASSIGN pFieldValue = RowObject.per-pg-dup[5].
        WHEN "per-pg-dup[6]" THEN ASSIGN pFieldValue = RowObject.per-pg-dup[6].
        WHEN "per-pg-dup[7]" THEN ASSIGN pFieldValue = RowObject.per-pg-dup[7].
        WHEN "per-pg-dup[8]" THEN ASSIGN pFieldValue = RowObject.per-pg-dup[8].
        WHEN "per-pg-dup[9]" THEN ASSIGN pFieldValue = RowObject.per-pg-dup[9].
        WHEN "per-pg-dup[10]" THEN ASSIGN pFieldValue = RowObject.per-pg-dup[10].
        WHEN "per-pg-dup[11]" THEN ASSIGN pFieldValue = RowObject.per-pg-dup[11].
        WHEN "per-pg-dup[12]" THEN ASSIGN pFieldValue = RowObject.per-pg-dup[12].

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
        WHEN "ano-base" THEN ASSIGN pFieldValue = RowObject.ano-base.
        WHEN "cod-cond-pag" THEN ASSIGN pFieldValue = RowObject.cod-cond-pag.
        WHEN "cod-ven-par[1]" THEN ASSIGN pFieldValue = RowObject.cod-ven-par[1].
        WHEN "cod-ven-par[2]" THEN ASSIGN pFieldValue = RowObject.cod-ven-par[2].
        WHEN "cod-ven-par[3]" THEN ASSIGN pFieldValue = RowObject.cod-ven-par[3].
        WHEN "cod-ven-par[4]" THEN ASSIGN pFieldValue = RowObject.cod-ven-par[4].
        WHEN "cod-ven-par[5]" THEN ASSIGN pFieldValue = RowObject.cod-ven-par[5].
        WHEN "cod-ven-par[6]" THEN ASSIGN pFieldValue = RowObject.cod-ven-par[6].
        WHEN "cod-ven-par[7]" THEN ASSIGN pFieldValue = RowObject.cod-ven-par[7].
        WHEN "cod-ven-par[8]" THEN ASSIGN pFieldValue = RowObject.cod-ven-par[8].
        WHEN "cod-ven-par[9]" THEN ASSIGN pFieldValue = RowObject.cod-ven-par[9].
        WHEN "cod-ven-par[10]" THEN ASSIGN pFieldValue = RowObject.cod-ven-par[10].
        WHEN "cod-ven-par[11]" THEN ASSIGN pFieldValue = RowObject.cod-ven-par[11].
        WHEN "cod-ven-par[12]" THEN ASSIGN pFieldValue = RowObject.cod-ven-par[12].
        WHEN "cod-vencto" THEN ASSIGN pFieldValue = RowObject.cod-vencto.
        WHEN "dia-mes-base" THEN ASSIGN pFieldValue = RowObject.dia-mes-base.
        WHEN "dia-mes-venc" THEN ASSIGN pFieldValue = RowObject.dia-mes-venc.
        WHEN "dia-sem-base" THEN ASSIGN pFieldValue = RowObject.dia-sem-base.
        WHEN "dia-sem-venc" THEN ASSIGN pFieldValue = RowObject.dia-sem-venc.
        WHEN "int-1" THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2" THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "mes-base" THEN ASSIGN pFieldValue = RowObject.mes-base.
        WHEN "nr-dias-ante" THEN ASSIGN pFieldValue = RowObject.nr-dias-ante.
        WHEN "nr-dupdes" THEN ASSIGN pFieldValue = RowObject.nr-dupdes.
        WHEN "nr-ind-finan" THEN ASSIGN pFieldValue = RowObject.nr-ind-finan.
        WHEN "nr-tab-finan" THEN ASSIGN pFieldValue = RowObject.nr-tab-finan.
        WHEN "num-parcelas" THEN ASSIGN pFieldValue = RowObject.num-parcelas.
        WHEN "prazos[1]" THEN ASSIGN pFieldValue = RowObject.prazos[1].
        WHEN "prazos[2]" THEN ASSIGN pFieldValue = RowObject.prazos[2].
        WHEN "prazos[3]" THEN ASSIGN pFieldValue = RowObject.prazos[3].
        WHEN "prazos[4]" THEN ASSIGN pFieldValue = RowObject.prazos[4].
        WHEN "prazos[5]" THEN ASSIGN pFieldValue = RowObject.prazos[5].
        WHEN "prazos[6]" THEN ASSIGN pFieldValue = RowObject.prazos[6].
        WHEN "prazos[7]" THEN ASSIGN pFieldValue = RowObject.prazos[7].
        WHEN "prazos[8]" THEN ASSIGN pFieldValue = RowObject.prazos[8].
        WHEN "prazos[9]" THEN ASSIGN pFieldValue = RowObject.prazos[9].
        WHEN "prazos[10]" THEN ASSIGN pFieldValue = RowObject.prazos[10].
        WHEN "prazos[11]" THEN ASSIGN pFieldValue = RowObject.prazos[11].
        WHEN "prazos[12]" THEN ASSIGN pFieldValue = RowObject.prazos[12].
        &IF DEFINED(bf_dis_gradiente) &THEN
        WHEN "qtd-dias-prazo-medio" THEN ASSIGN pFieldValue = RowObject.qtd-dias-prazo-medio.
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
               retorna valor do campo un
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-cond-pag LIKE cond-pagto.cod-cond-pag NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-cond-pag = RowObject.cod-cond-pag.

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
  Purpose:     Reposiciona registro com base no °ndice codigo
  Parameters:  
               recebe valor do campo un
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-cond-pag LIKE cond-pagto.cod-cond-pag NO-UNDO.

    FIND FIRST bfcond-pagto WHERE 
        bfcond-pagto.cod-cond-pag = pcod-cond-pag NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfcond-pagto THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfcond-pagto)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFaixaCondPagto DBOProgram 
PROCEDURE openQueryFaixaCondPagto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
   if i-cod-cond-pag-ini = i-cod-cond-pag-fim then
      open query qr{&tableName} 
        for each {&tableName} no-lock 
           where {&tableName}.cod-cond-pag = i-cod-cond-pag-ini INDEXED-REPOSITION.
   else 
      open query qr{&tableName} 
        for each {&tableName} no-lock 
           where {&tableName}.cod-cond-pag >= i-cod-cond-pag-ini
             and {&tableName}.cod-cond-pag <= i-cod-cond-pag-fim INDEXED-REPOSITION.

   RETURN "OK":U.

END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFaixaDescricao DBOProgram 
PROCEDURE openQueryFaixaDescricao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   if c-descricao-ini = c-descricao-fim then
      open query qr{&tableName} 
        for each {&tableName} no-lock 
           where {&tableName}.descricao = c-descricao-ini 
              by {&tableName}.descricao INDEXED-REPOSITION.
   else 
      open query qr{&tableName} 
        for each {&tableName} no-lock 
           where {&tableName}.descricao >= c-descricao-ini
             and {&tableName}.descricao <= c-descricao-fim 
              by {&tableName}.descricao INDEXED-REPOSITION.

   RETURN "OK":U.

END PROCEDURE.

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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFaixaCondPagto DBOProgram 
PROCEDURE setConstraintFaixaCondPagto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   def input param pi-cod-cond-pag-ini   as int no-undo.
   def input param pi-cod-cond-pag-fim   as int no-undo.
   
   assign i-cod-cond-pag-ini = pi-cod-cond-pag-ini
          i-cod-cond-pag-fim = pi-cod-cond-pag-fim.
          
END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFaixaDescricao DBOProgram 
PROCEDURE setConstraintFaixaDescricao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   def input param pc-descricao-ini   as char no-undo.
   def input param pc-descricao-fim   as char no-undo.
   
   assign c-descricao-ini = pc-descricao-ini
          c-descricao-fim = pc-descricao-fim.

END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintMain DBOProgram 
PROCEDURE setConstraintMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeCreateRecord DBOProgram 
PROCEDURE beforeCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF RowObject.cod-vencto = 2  // A Vista
    OR RowObject.cod-vencto = 3  // Antecipado   
    OR RowObject.cod-vencto = 4  // Contra Entrega
    THEN DO:
       ASSIGN RowObject.num-parcelas  = 1
              RowObject.per-pg-dup[1] = 100
              RowObject.prazos[1]     = 0.
    END.
            
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
    
    IF NOT AVAIL param-global THEN
       FIND FIRST param-global NO-LOCK NO-ERROR.
    
    IF pType = "create":U THEN DO:   
    
       IF RowObject.cod-cond-pag = 0 OR RowObject.cod-cond-pag = ? THEN DO:                
          {method/svc/errors/inserr.i &ErrorNumber="3642"
                                      &ErrorType="EMS"
                                      &ErrorSubType="Error"
                                      &ErrorParameters="''"}                             
       END.
        
       FIND FIRST bf{&TableName} 
            WHERE bf{&TableName}.cod-cond-pag = RowObject.cod-cond-pag NO-LOCK NO-ERROR.
       IF AVAIL bf{&TableName} THEN DO: 
          {utp/ut-field.i mgadm cond-pagto cod-cond-pag 1}
          {method/svc/errors/inserr.i &ErrorNumber="7"
                                      &ErrorType="EMS"
                                      &ErrorSubType="Error"
                                      &ErrorParameters="return-value"}    
    
       END.
       
       IF length(trim(RowObject.descricao)) <= 0 THEN DO:
          {method/svc/errors/inserr.i &ErrorNumber="2838"
                                      &ErrorType="EMS"
                                      &ErrorSubType="Error"
                                      &ErrorParameters="return-value"}    
       END.
     
       IF param-global.modulo-pd OR RowObject.nr-tab-finan <> 0 THEN DO:
          FIND FIRST tab-finan 
               WHERE tab-finan.nr-tab-finan = RowObject.nr-tab-finan NO-LOCK NO-ERROR.
          IF AVAIL tab-finan THEN DO:
             IF tab-finan.dt-ini-val <= TODAY AND
                tab-finan.dt-fim-val >= TODAY THEN
                /* OK */.
             ELSE DO:
                {method/svc/errors/inserr.i &ErrorNumber="3952"
                                            &ErrorType="EMS"
                                            &ErrorSubType="Error"
                                            &ErrorParameters="''"} 
             END.
          END.
       END.
     
       FIND FIRST tab-finan 
            WHERE tab-finan.nr-tab-finan = RowObject.nr-tab-finan NO-LOCK NO-ERROR.
       IF NOT AVAIL tab-finan THEN DO:     
          {utp/ut-table.i  mgdis tab-finan 1}
          {method/svc/errors/inserr.i &ErrorNumber="158"
                                      &ErrorType="EMS"
                                      &ErrorSubType="Error"
                                      &ErrorParameters="return-value"} 
       END.
         

       IF RowObject.nr-ind-finan <> 0 THEN
          IF NOT CAN-FIND(FIRST tab-finan-indice NO-LOCK
                          WHERE tab-finan-indice.nr-tab-finan = RowObject.nr-tab-finan
                            AND tab-finan-indice.num-seq      = RowObject.nr-ind-finan) THEN DO:              
             {utp/ut-liter.i Sequància_Tabela_Financiamento}
             {method/svc/errors/inserr.i &ErrorNumber="158"
                                         &ErrorType="EMS"
                                         &ErrorSubType="Error"
                                         &ErrorParameters="return-value"} 
       END.

         
       IF  RowObject.log-cond-pagto-mais-negoc = YES
       AND (RowObject.cod-vencto = 2
        OR  RowObject.cod-vencto = 3
        OR  RowObject.cod-vencto = 4) THEN DO:
            {utp/ut-liter.i ∑_Vista,_Antecipado_e_Contra_Entrega * R}
            ASSIGN c-traduz = RETURN-VALUE.               
            {method/svc/errors/inserr.i &ErrorNumber="57274"
                                        &ErrorType="EMS"
                                        &ErrorSubType="Error"
                                        &ErrorParameters="c-traduz"}     
       END.
                
    END.
     
    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END. 

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME






