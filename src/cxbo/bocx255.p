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
{include/i-prgvrs.i BOCX255 2.00.00.023 } /*** "010023" 27/11/2023 16:32:29  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i bocx255 MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) ‚ um programa PROGRESS 
                 que cont‚m a l¢gica de neg¢cio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName BOCX255
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName dupli-apagar-cex
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 


/*--- Include com defini‡Æo da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com 
      extensÆo .i ---*/
{cxbo/bocx255.i RowObject}


/*--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}


/*--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

def var i-cod-emitente      as int                           no-undo.
def var c-serie-docto       as char                          no-undo.
def var c-nro-docto         as char                          no-undo.
def var c-nat-operacao      as char                          no-undo.
DEF VAR c-usuario           LIKE param-re.usuario            NO-UNDO.
{cdp/cd4300.i3} /* tratamento atributo livre */
{utp/ut-glob.i}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteRelacDocum-est DBOProgram 
PROCEDURE deleteRelacDocum-est :
/*------------------------------------------------------------------------------
  Purpose: Eliminar as despesas relativas ao Documento de Entrada que est  sendo eliminado    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter p-serie-docto  like docum-est.serie-docto   no-undo.
    def input parameter p-nro-docto    like docum-est.nro-docto    no-undo.
    def input parameter p-cod-emitente like docum-est.cod-emitente no-undo.
    def input parameter p-nat-operacao like docum-est.nat-operacao no-undo.
    
    for each bf{&TableName}
        where bf{&TableName}.serie-docto  = p-serie-docto 
          and bf{&TableName}.nro-docto    = p-nro-docto
          and bf{&TableName}.cod-emitente = p-cod-emitente
          and bf{&TableName}.nat-operacao = p-nat-operacao no-lock:
        find {&TableName} 
            where rowid({&TableName}) = rowid(bf{&TableName}) exclusive-lock no-error.
        delete {&TableName}.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        &IF "{&mguni_version}" >= "2.071" &THEN
        WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
        &ENDIF 
        WHEN "cod-esp":U THEN ASSIGN pFieldValue = RowObject.cod-esp.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
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
        WHEN "valor-a-pagar-me":U THEN ASSIGN pFieldValue = RowObject.valor-a-pagar-me.
        WHEN "vl-a-pagar":U THEN ASSIGN pFieldValue = RowObject.vl-a-pagar.
        WHEN "vl-a-pagar-mo":U THEN ASSIGN pFieldValue = RowObject.vl-a-pagar-mo.
        WHEN "vl-ap-fasb[1]":U THEN ASSIGN pFieldValue = RowObject.vl-ap-fasb[1].
        WHEN "vl-ap-fasb[2]":U THEN ASSIGN pFieldValue = RowObject.vl-ap-fasb[2].
        WHEN "vl-desconto":U THEN ASSIGN pFieldValue = RowObject.vl-desconto.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "cod-emitente-desp":U THEN ASSIGN pFieldValue = RowObject.cod-emitente-desp.
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
  Purpose:     Retorna valores dos campos do ¡ndice documento
  Parameters:  
               retorna valor do campo serie-docto
               retorna valor do campo nro-docto
               retorna valor do campo cod-emitente
               retorna valor do campo nat-operacao
               retorna valor do campo cod-emitente-desp
               retorna valor do campo parcela
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pserie-docto LIKE dupli-apagar-cex.serie-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pnro-docto LIKE dupli-apagar-cex.nro-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE dupli-apagar-cex.cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pnat-operacao LIKE dupli-apagar-cex.nat-operacao NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente-desp LIKE dupli-apagar-cex.cod-emitente-desp NO-UNDO.
    DEFINE OUTPUT PARAMETER pparcela LIKE dupli-apagar-cex.parcela NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pserie-docto = RowObject.serie-docto
           pnro-docto = RowObject.nro-docto
           pcod-emitente = RowObject.cod-emitente
           pnat-operacao = RowObject.nat-operacao
           pcod-emitente-desp = RowObject.cod-emitente-desp
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
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
  Purpose:     Reposiciona registro com base no ¡ndice documento
  Parameters:  
               recebe valor do campo serie-docto
               recebe valor do campo nro-docto
               recebe valor do campo cod-emitente
               recebe valor do campo nat-operacao
               recebe valor do campo cod-emitente-desp
               recebe valor do campo parcela
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pserie-docto LIKE dupli-apagar-cex.serie-docto NO-UNDO.
    DEFINE INPUT PARAMETER pnro-docto LIKE dupli-apagar-cex.nro-docto NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente LIKE dupli-apagar-cex.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pnat-operacao LIKE dupli-apagar-cex.nat-operacao NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente-desp LIKE dupli-apagar-cex.cod-emitente-desp NO-UNDO.
    DEFINE INPUT PARAMETER pparcela LIKE dupli-apagar-cex.parcela NO-UNDO.

    FIND FIRST bfdupli-apagar-cex WHERE 
        bfdupli-apagar-cex.serie-docto = pserie-docto AND 
        bfdupli-apagar-cex.nro-docto = pnro-docto AND 
        bfdupli-apagar-cex.cod-emitente = pcod-emitente AND 
        bfdupli-apagar-cex.nat-operacao = pnat-operacao AND 
        bfdupli-apagar-cex.cod-emitente-desp = pcod-emitente-desp AND 
        bfdupli-apagar-cex.parcela = pparcela NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfdupli-apagar-cex THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfdupli-apagar-cex)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linktoDocumEst DBOProgram 
PROCEDURE linktoDocumEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  def input parameter pHandle as handle no-undo.
    
    run getKey in pHandle ( output i-cod-emitente,
                            output c-serie-docto,
                            output c-nro-docto,
                            output c-nat-operacao ).
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
           run openQueryStatic ("Main":U).                
        when 2 then
           run openQueryStatic ("OfDocum":U). 
    end case.
    
    Return "OK":U.
    
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
       open query {&QUERYNAME} for each {&TABLENAME} no-lock.  
       
       Return "OK":U.
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOfDocum DBOProgram 
PROCEDURE openQueryOfDocum :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    open query {&QUERYNAME} for each {&TABLENAME} no-lock
        where dupli-apagar-cex.serie-docto   = c-serie-docto and
              dupli-apagar-cex.nro-docto     = c-nro-docto and                      
              dupli-apagar-cex.cod-emitente  = i-cod-emitente and
              dupli-apagar-cex.nat-operacao  = c-nat-operacao indexed-reposition.

   Return "OK":U.
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setRowidDocumEst DBOProgram 
PROCEDURE setRowidDocumEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param rwDocumEst  as rowid no-undo.

    for first docum-est
        fields ( cod-emitente    serie-docto     
                 nro-docto       nat-operacao
                 cod-estabel     usuario
                 dt-emissao      tot-valor  )
        where rowid(docum-est) = rwDocumEst no-lock:
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Valida‡äes pertinentes ao DBO
  Parameters:  recebe o tipo de valida‡Æo (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.    
    
    /*--- Utilize o parƒmetro pType para identificar quais as valida‡äes a serem
          executadas ---*/
    /*--- Os valores poss¡veis para o parƒmetro sÆo: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do 
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as valida‡äes ---*/
    
    {rep/re1001a.i50} /* include tratamento atributo livre */
    
    if pType = "Create" then do:

        for first docum-est fields(cod-estabel char-1)
            where docum-est.serie-docto  = rowObject.serie-docto 
              and docum-est.nro-docto    = rowObject.nro-docto
              and docum-est.cod-emitente = rowObject.cod-emitente
              and docum-est.nat-operacao = rowObject.nat-operacao no-lock:
            {cdp/cd4300.i4 "yes" docum-est.char-1}
            {rep/re1001a.i51 "yes"}              
        end.
        
        if not avail docum-est then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-documento AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Documento" *}
            ASSIGN c-lbl-liter-documento = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                             &ErrorNumber="2" 
                             &ErrorType="EMS"
                             &ErrorSubType="ERROR"
                             &ErrorParameters = "c-lbl-liter-documento" }
        end.
                    
        for first estabelec fields(pais)
            where estabelec.cod-estabel = docum-est.cod-estabel no-lock:
        end.

        for first natur-oper fields(nota-rateio)
            where natur-oper.nat-operacao = rowObject.nat-operacao no-lock:
        end.

        for first emitente fields(natureza pais)
            where emitente.cod-emitente = rowObject.cod-emitente no-lock:
            if c-embarque = "":U then do:
                if (emitente.natureza <> 3 and emitente.natureza <> 4) then do:
                    {method/svc/errors/inserr.i
                                     &ErrorNumber="19156" 
                                     &ErrorType="EMS"
                                     &ErrorSubType="ERROR"}  
                end.

                if avail natur-oper and 
                   natur-oper.nota-rateio then .
                else do:
                   if avail estabelec and
                      emitente.pais = estabelec.pais then do:
                      {method/svc/errors/inserr.i
                                        &ErrorNumber="27238"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"}
                   end.
                end.

            end.                
        end.
        
        if rowObject.cod-emitente-desp = 0 then do:
           /* Inicio -- Projeto Internacional */
           DEFINE VARIABLE c-lbl-liter-fornec-despesa AS CHARACTER NO-UNDO.
           {utp/ut-liter.i "Fornec_Despesa" *}
           ASSIGN c-lbl-liter-fornec-despesa = TRIM(RETURN-VALUE).
           {method/svc/errors/inserr.i
                            &ErrorNumber="265" 
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"
                            &ErrorParameters = "c-lbl-liter-fornec-despesa" }    
        end.
        else do:
            for first emitente fields(identific)
                where emitente.cod-emitente = rowObject.cod-emitente-desp no-lock:            
                if emitente.identific = 1 then do:                
                    {method/svc/errors/inserr.i
                                     &ErrorNumber="8738" 
                                     &ErrorType="EMS"
                                     &ErrorSubType="ERROR"}  
                end.                                     
            end.                    
            if not avail emitente then do:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-clientefornecedor AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Cliente/Fornecedor" *}
                ASSIGN c-lbl-liter-clientefornecedor = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                                &ErrorNumber="2" 
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"
                                &ErrorParameters = "c-lbl-liter-clientefornecedor" }                
            end.
        end.    
        
        if rowObject.parcela = "" or rowObject.parcela = "0" then do:
            {method/svc/errors/inserr.i
                                &ErrorNumber="3520" 
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" }                
        end.
            
        find first bfdupli-apagar-cex 
            where bfdupli-apagar-cex.serie-docto       = rowObject.serie-docto
              and bfdupli-apagar-cex.nro-docto         = rowObject.nro-docto    
              and bfdupli-apagar-cex.cod-emitente      = rowObject.cod-emitente 
              and bfdupli-apagar-cex.nat-operacao      = rowObject.nat-operacao         
              and bfdupli-apagar-cex.cod-emitente-desp = rowObject.cod-emitente-desp
              and bfdupli-apagar-cex.parcela           = rowObject.parcela no-lock no-error.
        
        if  avail bfdupli-apagar-cex then do:        
             /* Inicio -- Projeto Internacional */
             DEFINE VARIABLE c-lbl-liter-duplicata AS CHARACTER NO-UNDO.
             {utp/ut-liter.i "Duplicata" *}
             ASSIGN c-lbl-liter-duplicata = TRIM(RETURN-VALUE).
             {method/svc/errors/inserr.i
                            &ErrorNumber="8" 
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"
                            &ErrorParameters = "c-lbl-liter-duplicata" }    
        end.       
             
    end.  /* Valida‡Æo Create */
    

    /***** Valida Esp‚cie do Documento *****/
    for first espec-ap
       fields ( tipo ) 
        where espec-ap.cod-esp = RowObject.cod-esp no-lock:
    end.
    if  not avail espec-ap then do:        
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-especie-titulo AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Esp‚cie_T¡tulo" *}
        ASSIGN c-lbl-liter-especie-titulo = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lbl-liter-especie-titulo"}
    end.

    if ptype <> "Delete" then do:
        
         find tipo-rec-desp no-lock where
              tipo-rec-desp.tp-codigo = rowObject.tp-despesa no-error.
         if not avail tipo-rec-desp then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-tipo-de-despesa AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Tipo_de_Despesa" *}
            ASSIGN c-lbl-liter-tipo-de-despesa = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                            &ErrorNumber="2" 
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"
                            &ErrorParameters = "c-lbl-liter-tipo-de-despesa" }  
         end.
         else 
            if  tipo-rec-desp.tipo = 1 then do:
                {method/svc/errors/inserr.i
                                    &ErrorNumber="4995"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR" }
            end.


       if rowObject.vl-a-pagar = 0 then do:
           /* Inicio -- Projeto Internacional */
           DEFINE VARIABLE c-lbl-liter-valor-duplicata AS CHARACTER NO-UNDO.
           {utp/ut-liter.i "Valor_Duplicata" *}
           ASSIGN c-lbl-liter-valor-duplicata = TRIM(RETURN-VALUE).
           {method/svc/errors/inserr.i
                            &ErrorNumber="265" 
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"
                            &ErrorParameters = "c-lbl-liter-valor-duplicata" }    
       end.     
    
       if  not can-find(moeda where moeda.mo-codigo = rowObject.mo-codigo) then do:
           {method/svc/errors/inserr.i
                            &ErrorNumber="4929" 
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"
                            &ErrorParameters = "string(rowObject.mo-codigo)" }    
     
       end.    
    
       if  rowObject.vl-a-pagar-mo = 0 or 
          string(rowObject.vl-a-pagar-mo) = " " then do:
          {method/svc/errors/inserr.i
                           &ErrorNumber="17527" 
                           &ErrorType="EMS"
                           &ErrorSubType="ERROR"}    
       end.         
    
       if  rowObject.dt-emissao = ? then do:
           /* Inicio -- Projeto Internacional */
           DEFINE VARIABLE c-lbl-liter-data-de-emissao AS CHARACTER NO-UNDO.
           {utp/ut-liter.i "Data_de_EmissÆo" *}
           ASSIGN c-lbl-liter-data-de-emissao = TRIM(RETURN-VALUE).
           {method/svc/errors/inserr.i
                           &ErrorNumber="265" 
                           &ErrorType="EMS"
                           &ErrorSubType="ERROR"
                           &ErrorParameters = "c-lbl-liter-data-de-emissao" }      
       end.    
    
       if rowObject.desconto <> 0 and 
          rowObject.dt-venc-desc = ? then do:
           /* Inicio -- Projeto Internacional */
           DEFINE VARIABLE c-lbl-liter-vencimento-com-desconto AS CHARACTER NO-UNDO.
           {utp/ut-liter.i "Vencimento_com_Desconto" *}
           ASSIGN c-lbl-liter-vencimento-com-desconto = TRIM(RETURN-VALUE).
           {method/svc/errors/inserr.i
                            &ErrorNumber="265" 
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"
                            &ErrorParameters = "c-lbl-liter-vencimento-com-desconto" }    
       end.    

       if  rowObject.desconto = 0 then
           assign rowObject.dt-venc-desc = ?.

       if rowObject.desconto > 100 then do:
           /* Inicio -- Projeto Internacional */
           DEFINE VARIABLE c-lbl-liter-percentual-de-desconto AS CHARACTER NO-UNDO.
           {utp/ut-liter.i "Percentual_de_Desconto" *}
           ASSIGN c-lbl-liter-percentual-de-desconto = TRIM(RETURN-VALUE).
           {method/svc/errors/inserr.i
                            &ErrorNumber="6076" 
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"
                            &ErrorParameters = "c-lbl-liter-percentual-de-desconto" }   
       end.        

       if rowObject.dt-vencim = ? then do:
           /* Inicio -- Projeto Internacional */
           DEFINE VARIABLE c-lbl-liter-data-de-vencimento AS CHARACTER NO-UNDO.
           {utp/ut-liter.i "Data_de_Vencimento" *}
           ASSIGN c-lbl-liter-data-de-vencimento = TRIM(RETURN-VALUE).
           {method/svc/errors/inserr.i
                           &ErrorNumber="265"
                           &ErrorType="EMS"
                           &ErrorSubType="ERROR"
                           &ErrorParameters = "c-lbl-liter-data-de-vencimento" }
       end.
       
       FIND param-re
           WHERE param-re.usuario = c-seg-usuario NO-LOCK NO-ERROR.

       if  AVAIL param-re
       AND rowObject.dt-emissao < today - param-re.var-emis
       or  rowObject.dt-emissao > today then do:
           {method/svc/errors/inserr.i
                           &ErrorNumber="30050" /*antiga mensagem 614*/
                           &ErrorType="EMS"
                           &ErrorSubType="ERROR"}
       end.

       if rowObject.dt-trans > today or
          rowObject.dt-trans < rowObject.dt-emissao then do:
           /* Inicio -- Projeto Internacional */
           DEFINE VARIABLE c-lbl-liter-data-de-transacao AS CHARACTER NO-UNDO.
           {utp/ut-liter.i "Data_de_Transacao" *}
           ASSIGN c-lbl-liter-data-de-transacao = TRIM(RETURN-VALUE).
           {method/svc/errors/inserr.i
                           &ErrorNumber="29985"
                           &ErrorType="EMS"
                           &ErrorSubType="ERROR"
                           &ErrorParameters = "c-lbl-liter-data-de-transacao " }
       end.
       
       if rowObject.dt-vencim < rowObject.dt-emissao then do:
           {method/svc/errors/inserr.i
                           &ErrorNumber="1031"
                           &ErrorType="EMS"
                           &ErrorSubType="ERROR"}
       end.
       
    end. /* ptype <> DELETE */  
    
    /*--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findDupliApagarCex DBOProgram 
PROCEDURE findDupliApagarCex :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER pserie-docto        LIKE dupli-apagar-cex.serie-docto   NO-UNDO.
    DEFINE INPUT  PARAMETER pnro-docto          LIKE dupli-apagar-cex.nro-docto     NO-UNDO.
    DEFINE INPUT  PARAMETER pcod-emitente       LIKE dupli-apagar-cex.cod-emitente  NO-UNDO.
    DEFINE INPUT  PARAMETER pnat-operacao       LIKE dupli-apagar-cex.nat-operacao  NO-UNDO.
    DEFINE OUTPUT PARAMETER pl-dupli-apagar-cex AS   LOGICAL                        NO-UNDO.

    FIND FIRST dupli-apagar-cex 
         WHERE dupli-apagar-cex.serie-docto  = pserie-docto 
           AND dupli-apagar-cex.nro-docto    = pnro-docto 
           AND dupli-apagar-cex.cod-emitente = pcod-emitente 
           AND dupli-apagar-cex.nat-operacao = pnat-operacao NO-LOCK NO-ERROR.

    IF AVAIL dupli-apagar-cex THEN
        ASSIGN pl-dupli-apagar-cex = YES.
    ELSE
        ASSIGN pl-dupli-apagar-cex = NO.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
