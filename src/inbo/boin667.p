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
{include/i-prgvrs.i BOIN667 2.00.00.018 } /*** "010018" 12/09/2026 21:26:00 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin667 MUT}
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
&GLOBAL-DEFINE DBOName    BOIN667
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName  item-mat
&GLOBAL-DEFINE TableLabel Item Materiais
&GLOBAL-DEFINE QueryName qr{&TableName} 
&GLOBAL-DEFINE CHANGE-QUERY-TO-FIND TRUE
&GLOBAL-DEFINE CHANGE-QUERY-TO-FIND-PROCS DEFAULT

/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin667.i RowObject}
{cdp/cdcfgmat.i}

/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}
{utp/ut-glob.i}


/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterUpdateRecord DBOProgram 
PROCEDURE afterUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    if avail item-mat then do:
        find first item-man where item-man.it-codigo = item-mat.it-codigo exclusive-lock no-error.
        if avail item-man then 
           assign 
           item-man.tp-ressup       = item-mat.tp-ressup
           item-man.ponto-encomenda = item-mat.ponto-encomenda.
    end.
    release item-man.
    return "OK".
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
        WHEN "cod-estab-gestor":U THEN ASSIGN pFieldValue = RowObject.cod-estab-gestor.
        WHEN "cod-grp-compra":U THEN ASSIGN pFieldValue = RowObject.cod-grp-compra.
        WHEN "dep-rej-cq":U THEN ASSIGN pFieldValue = RowObject.dep-rej-cq.
        WHEN "deposito-cq":U THEN ASSIGN pFieldValue = RowObject.deposito-cq.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "dsl-formul-quant-cq":U THEN ASSIGN pFieldValue = RowObject.dsl-formul-quant-cq.
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
        WHEN "data-ult-ressup":U THEN ASSIGN pFieldValue = RowObject.data-ult-ressup.
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
        WHEN "fator-ponder[1]":U THEN ASSIGN pFieldValue = RowObject.fator-ponder[1].
        WHEN "fator-ponder[2]":U THEN ASSIGN pFieldValue = RowObject.fator-ponder[2].
        WHEN "fator-ponder[3]":U THEN ASSIGN pFieldValue = RowObject.fator-ponder[3].
        WHEN "fator-ponder[4]":U THEN ASSIGN pFieldValue = RowObject.fator-ponder[4].
        WHEN "fator-ponder[5]":U THEN ASSIGN pFieldValue = RowObject.fator-ponder[5].
        WHEN "fator-ponder[6]":U THEN ASSIGN pFieldValue = RowObject.fator-ponder[6].
        WHEN "fator-ponder[7]":U THEN ASSIGN pFieldValue = RowObject.fator-ponder[7].
        WHEN "fator-ponder[8]":U THEN ASSIGN pFieldValue = RowObject.fator-ponder[8].
        WHEN "fator-ponder[9]":U THEN ASSIGN pFieldValue = RowObject.fator-ponder[9].
        WHEN "fator-ponder[10]":U THEN ASSIGN pFieldValue = RowObject.fator-ponder[10].
        WHEN "fator-ponder[11]":U THEN ASSIGN pFieldValue = RowObject.fator-ponder[11].
        WHEN "fator-ponder[12]":U THEN ASSIGN pFieldValue = RowObject.fator-ponder[12].
        WHEN "ind-cons-prv":U THEN ASSIGN pFieldValue = RowObject.ind-cons-prv.
        WHEN "lote-per-max":U THEN ASSIGN pFieldValue = RowObject.lote-per-max.
        WHEN "ponto-encomenda":U THEN ASSIGN pFieldValue = RowObject.ponto-encomenda.
        WHEN "var-qtd-re":U THEN ASSIGN pFieldValue = RowObject.var-qtd-re.
        WHEN "var-val-re-maior":U THEN ASSIGN pFieldValue = RowObject.var-val-re-maior.
        WHEN "var-val-re-menor":U THEN ASSIGN pFieldValue = RowObject.var-val-re-menor.
        WHEN "variacao-perm":U THEN ASSIGN pFieldValue = RowObject.variacao-perm.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getEnableGrpCompra DBOProgram 
PROCEDURE getEnableGrpCompra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def output param l-enable-grp-compra as log no-undo.

find first param-compra no-lock no-error.
if avail param-compra then do:
   assign l-enable-grp-compra = if param-compra.int-2 = 1 then yes else no.
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
        WHEN "cd-freq":U THEN ASSIGN pFieldValue = RowObject.cd-freq.
        WHEN "cod-fat-ponder":U THEN ASSIGN pFieldValue = RowObject.cod-fat-ponder.
        WHEN "cod-tax":U THEN ASSIGN pFieldValue = RowObject.cod-tax.
        WHEN "crit-cc":U THEN ASSIGN pFieldValue = RowObject.crit-cc.
        WHEN "crit-ce":U THEN ASSIGN pFieldValue = RowObject.crit-ce.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "prioridade-aprov":U THEN ASSIGN pFieldValue = RowObject.prioridade-aprov.
        WHEN "ressup-min-f":U THEN ASSIGN pFieldValue = RowObject.ressup-min-f.
        WHEN "tp-ressup":U THEN ASSIGN pFieldValue = RowObject.tp-ressup.
        WHEN "dias-ocioso":U THEN ASSIGN pFieldValue = RowObject.dias-ocioso.
        WHEN "perc-excesso":U THEN ASSIGN pFieldValue = RowObject.perc-excesso.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice Item
  Parameters:  
               retorna valor do campo it-codigo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pit-codigo LIKE item-mat.it-codigo NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pit-codigo = RowObject.it-codigo.

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
        WHEN "altera-conta":U THEN ASSIGN pFieldValue = RowObject.altera-conta.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "log-contr-ag-ia":U THEN ASSIGN pFieldValue = RowObject.log-contr-ag-ia.
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
  Purpose:     Reposiciona registro com base no °ndice Item
  Parameters:  
               recebe valor do campo it-codigo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pit-codigo LIKE item-mat.it-codigo NO-UNDO.

    FIND FIRST bfitem-mat WHERE 
        bfitem-mat.it-codigo = pit-codigo NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfitem-mat THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfitem-mat)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDefault DBOProgram 
PROCEDURE openQueryDefault :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    open query {&QueryName} For each {&TableName} 
        &if '{&ems_dbtype}':U = 'MSS':U &then
            no-lock.
        &else 
            NO-LOCK indexed-reposition.
        &endif
  
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findFirstDefault DBOProgram 
PROCEDURE findFirstDefault :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
     FIND FIRST {&TableName}  NO-LOCK NO-ERROR.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findLastDefault DBOProgram 
PROCEDURE findLastDefault :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
     FIND LAST  {&TableName}  NO-LOCK NO-ERROR.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findNextDefault DBOProgram 
PROCEDURE findNextDefault :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
     FIND NEXT  {&TableName}  NO-LOCK NO-ERROR.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findPrevDefault DBOProgram 
PROCEDURE findPrevDefault :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
     FIND PREV  {&TableName}  NO-LOCK NO-ERROR.

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
   
   open query {&queryname} 
   for each {&tablename} no-lock indexed-reposition.
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintDefault DBOProgram 
PROCEDURE setConstraintDefault :
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

    /* Validacoes especificas do CE0106 centralizadas em boin172va.p. */

    /*--- Validaá‰es para Operacional Textil ---*/
    /*RUN piValidaItemMat(INPUT pType).*/

    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecordImp DBOProgram 
PROCEDURE validateRecordImp :
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
    
    IF (pType = "Create" OR pType = "Update") THEN DO:
    
        &if '{&BF_MAT_VERSAO_EMS}' >= '2.062' &then
        
            IF NOT CAN-FIND(FIRST emitente WHERE 
                                  emitente.cod-emitente = rowObject.cdn-fabrican) THEN DO:
               /* Inicio -- Projeto Internacional */
               DEFINE VARIABLE c-lbl-liter-fabricante AS CHARACTER NO-UNDO.
               {utp/ut-liter.i "Fabricante" *}
               ASSIGN c-lbl-liter-fabricante = TRIM(RETURN-VALUE).
               {method/svc/errors/inserr.i
                       &ErrorNumber="2"
                       &ErrorType="EMS"
                       &ErrorSubType="ERROR"
                       &ErrorParameters="c-lbl-liter-fabricante"}
            END.
        
            IF NOT CAN-FIND(FIRST emitente WHERE 
                                  emitente.cod-emitente = rowObject.cdn-fabrican AND 
                                  (emitente.identific = 2 /* Fornecedor */ 
                                   OR emitente.identific = 3 )) /* Ambos */  THEN DO:
               /* Inicio -- Projeto Internacional */
               DEFINE VARIABLE c-lbl-liter-fabricante-informado AS CHARACTER NO-UNDO.
               {utp/ut-liter.i "Fabricante_informado" *}
               ASSIGN c-lbl-liter-fabricante-informado = TRIM(RETURN-VALUE).
               DEFINE VARIABLE c-lbl-liter-fornecedor AS CHARACTER NO-UNDO.
               {utp/ut-liter.i "fornecedor" *}
               ASSIGN c-lbl-liter-fornecedor = TRIM(RETURN-VALUE).
               {method/svc/errors/inserr.i
                       &ErrorNumber="17195"
                       &ErrorType="EMS"
                       &ErrorSubType="ERROR"
                       &ErrorParameters="c-lbl-liter-fabricante-informado + '~~~~' + c-lbl-liter-fornecedor"}
                       
            END.
        
            
            
           IF NOT CAN-FIND(FIRST pais WHERE pais.cod-pais = rowObject.cdn-pais-orig) 
           AND rowObject.cdn-pais-orig <> 0 THEN DO:
               /* Inicio -- Projeto Internacional */
               DEFINE VARIABLE c-lbl-liter-pais-de-origem AS CHARACTER NO-UNDO.
               {utp/ut-liter.i "Pa°s_de_Origem" *}
               ASSIGN c-lbl-liter-pais-de-origem = TRIM(RETURN-VALUE).
               {method/svc/errors/inserr.i
                   &ErrorNumber="2"
                   &ErrorType="EMS"
                   &ErrorSubType="ERROR"
                   &ErrorParameters="c-lbl-liter-pais-de-origem"}
            END.
        &endif
    END.
    
    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaItemMat DBOProgram 
PROCEDURE piValidaItemMat :
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

    IF (pType = "Create" OR pType = "Update") THEN DO:

        find first param-estoq no-lock no-error.
        find first param-compra no-lock no-error.
                       
            if  RowObject.tp-ressup = 3 
            and not can-find(first frequencia 
                             where frequencia.cd-freq = RowObject.cd-freq) 
            then do:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-frequencia AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Frequància" *}
                ASSIGN c-lbl-liter-frequencia = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                                &ErrorNumber="2" /*Frequància n∆o cadastrada*/
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"
                                &ErrorParameters="c-lbl-liter-frequencia" }   
            end.
            
            if  RowObject.cod-fat-ponder <> 0
            and not can-find(first fat-ponder
                             where fat-ponder.cod-fat-ponder = RowObject.cod-fat-ponder) 
            then do:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-formula AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "F¢rmula" *}
                ASSIGN c-lbl-liter-formula = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                                &ErrorNumber="2" /*F¢rmula n∆o cadastrada*/
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"
                                &ErrorParameters="c-lbl-liter-formula" }                
           end.
           
           if RowObject.cod-estab-gestor <> "" then do:
                if not can-find( first estabelec
                                 where estabelec.cod-estabel = RowObject.cod-estab-gestor ) then do:
                    /* Inicio -- Projeto Internacional */
                    {utp/ut-table.i mgadm estabelec 1} /* Busca o label da tabela */
                    {method/svc/errors/inserr.i
                                    &ErrorNumber="2" /* Estabelecimento n∆o cadastrado */
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters=TRIM(RETURN-VALUE)}
                end. 
           end.     
           if param-compra.int-2 = 1 or RowObject.cod-grp-compra <> "" then do:
                if not can-find( first grupo-compra 
                                 where grupo-compra.cod-grp-compra = RowObject.cod-grp-compra ) then do:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-compras AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Compras" *}
                    ASSIGN c-lbl-liter-compras = TRIM(RETURN-VALUE).
                    {method/svc/errors/inserr.i
                                    &ErrorNumber="15262" /* Grupo de Compras n∆o encontrado */
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="c-lbl-liter-compras" }
                end. 
           end.     
           
           FOR FIRST item FIELDS(it-codigo cod-comprado) NO-LOCK 
               WHERE item.it-codigo = RowObject.it-codigo:
               if param-compra.int-2 = 2 or item.cod-comprado <> "" then do:
                    if not can-find( first comprador
                                     where comprador.cod-comprado = item.cod-comprado ) then do:
                        /* Inicio -- Projeto Internacional */
                        {utp/ut-table.i mgind comprador 1} /* Busca o label da tabela */
                        {method/svc/errors/inserr.i
                                        &ErrorNumber="2" /* Comprador n∆o cadastrado */
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters=TRIM(RETURN-VALUE)}
                    end.
                end.
           END.
        
           if i-pais-impto-usuario <> 1 and
              not can-find( first tipo-tax
                             where tipo-tax.cod-tax = RowObject.cod-tax ) then do:
               /* Inicio -- Projeto Internacional */
               DEFINE VARIABLE c-lbl-liter-codigo-imposto AS CHARACTER NO-UNDO.
               {utp/ut-liter.i "C¢digo_Imposto" *}
               ASSIGN c-lbl-liter-codigo-imposto = TRIM(RETURN-VALUE).
               {method/svc/errors/inserr.i
                               &ErrorNumber="2" /* C¢digo Imposto n∆o cadastrado */
                               &ErrorType="EMS"
                               &ErrorSubType="ERROR"
                               &ErrorParameters="c-lbl-liter-codigo-imposto" }
           end.        
    
            &if "{&bf_dis_versao_ems}" >= "2.062" &then
               IF  RowObject-mat.cod-familia-impto <> ''
               AND NOT CAN-FIND(FIRST familia-impto NO-LOCK
                   WHERE familia-impto.cod-familia-impto = RowObject.cod-familia-impto) THEN DO:
                   /* Inicio -- Projeto Internacional */
                   {utp/ut-table.i mgind familia-impto 1} /* Busca o label da tabela */
                   {method/svc/errors/inserr.i
                               &ErrorNumber="47"
                               &ErrorType="EMS"
                               &ErrorSubType="ERROR"
                               &ErrorParameters=TRIM(RETURN-VALUE)}
               END.
            &endif
    END.

                                           
    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
