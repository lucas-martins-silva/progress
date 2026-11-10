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
{include/i-prgvrs.i BOIN082Q04 2.00.00.003} /*** "010003" 23/11/2023 16:19:42  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN082Q04 MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : 
    Purpose    : O DBO (Datasul Business Objects) ≤ um programa PROGRESS
                 que cont≤m a lΩgica de negΩcio e acesso a dados para uma
                 tabela do banco de dados.

    Parameters :

    Notes      : BO utilizado apenas para navegaá∆o default e openQueries
                 com apenas uma tabela.
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de definiªío ---*/
&GLOBAL-DEFINE DBOName cotacao-item
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName cotacao-item
&GLOBAL-DEFINE TableLabel cotacao-item
&GLOBAL-DEFINE QueryName qr{&TableName}

/*********************************************************************************
**  S¢ a DBO principal (boin082.p) est† com as funá‰es de inclui (createRecord), 
**  modifica (updateRecord) e elimina (deleteRecord) habilitadas, 
**  porque S‡ nela foram implementadas as triggers do dicion†rio.
**  Para desabilitar as procedures foram usados os prÇ-processadores abaixo.
**  A procedure validateRecord dessa DBO n∆o deve ser usada.
*********************************************************************************/
&GLOBAL-DEFINE EXCLUDE-createRecord 0
&GLOBAL-DEFINE EXCLUDE-updateRecord 0
&GLOBAL-DEFINE EXCLUDE-deleteRecord 0


/*--- Include com definiªío da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diretΩrio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idºntico ao nome do DBO mas com
      extensío .i ---*/
{inbo/boin082.i RowObject}

/*--- Include com definiªío da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraªío da definiªío da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiªío
      manual da query ---*/
/** {method/dboqry.i} **/
DEFINE QUERY {&QueryName} for {&TableName},
    emitente FIELDS(emitente.cod-emitente emitente.natureza) scrolling.

/* Local Buffer Definitions ---  */

def buffer bf{&TableName} for cotacao-item.

def var c-numero-ordem-ini as int  no-undo.
def var c-numero-ordem-fim as int  no-undo.
def var c-cod-emitente-ini as int  no-undo.
def var c-cod-emitente-fim as int  no-undo.

/******************************ATENCAO*************************************
 Pre-processador abaixo responsavel por distinguir o produto que
 esta executando o componente ( Magnus ou EMS ). 
 Se estiver definida a variavel bf-mat-comex 
 ( &if defined(bf-mat-comex) &then ), significa que o produto
 chamador e o Magnus se n∆o, EMS. Utilizado pelo produto Comercio Exterior
**************************************************************************/ 
{cdp/cdcfgmat.i} /* Definicao de pre-processadores - Magnus ou EMS */

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
         HEIGHT             = 3.65
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject estˇ dispon≠vel, caso nío esteja serˇ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "motivo-apr":U THEN ASSIGN pFieldValue = RowObject.motivo-apr.
        WHEN "nr-tab":U THEN ASSIGN pFieldValue = RowObject.nr-tab.
        WHEN "un":U THEN ASSIGN pFieldValue = RowObject.un.
        WHEN "usuario":U THEN ASSIGN pFieldValue = RowObject.usuario.
        WHEN "aprovador":U THEN ASSIGN pFieldValue = RowObject.aprovador.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "cod-comprado":U THEN ASSIGN pFieldValue = RowObject.cod-comprado.
        WHEN "contato":U THEN ASSIGN pFieldValue = RowObject.contato.
        WHEN "hora-atualiz":U THEN ASSIGN pFieldValue = RowObject.hora-atualiz.        
        &if defined(bf-mat-comex) &then            
            WHEN "narrativa[1]":U THEN ASSIGN pFieldValue = RowObject.narrativa[1].
            WHEN "narrativa[2]":U THEN ASSIGN pFieldValue = RowObject.narrativa[2].
            WHEN "narrativa[3]":U THEN ASSIGN pFieldValue = RowObject.narrativa[3].
            WHEN "narrativa[4]":U THEN ASSIGN pFieldValue = RowObject.narrativa[4].
            WHEN "narrativa[5]":U THEN ASSIGN pFieldValue = RowObject.narrativa[5].                
            WHEN "u-char-1":U THEN ASSIGN pFieldValue = RowObject.u-char-1.                    
        &else         
            WHEN "narrativa":U THEN ASSIGN pFieldValue = RowObject.narrativa.        
            WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
            WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.            
        &endif
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

    /*--- Verifica se temptable RowObject estˇ dispon≠vel, caso nío esteja serˇ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-atualiz":U THEN ASSIGN pFieldValue = RowObject.data-atualiz.
        WHEN "data-cotacao":U THEN ASSIGN pFieldValue = RowObject.data-cotacao.
        &if defined(bf-mat-comex) &then   
        &else
            WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
            WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.        
        &endif        
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

    /*--- Verifica se temptable RowObject estˇ dispon≠vel, caso nío esteja serˇ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "perc-descto":U THEN ASSIGN pFieldValue = RowObject.perc-descto.
        WHEN "pre-unit-for":U THEN ASSIGN pFieldValue = RowObject.pre-unit-for.
        WHEN "preco-fornec":U THEN ASSIGN pFieldValue = RowObject.preco-fornec.
        WHEN "preco-unit":U THEN ASSIGN pFieldValue = RowObject.preco-unit.
        WHEN "valor-descto":U THEN ASSIGN pFieldValue = RowObject.valor-descto.
        WHEN "valor-frete":U THEN ASSIGN pFieldValue = RowObject.valor-frete.
        WHEN "valor-taxa":U THEN ASSIGN pFieldValue = RowObject.valor-taxa.
        WHEN "aliquota-icm":U THEN ASSIGN pFieldValue = RowObject.aliquota-icm.
        WHEN "aliquota-ipi":U THEN ASSIGN pFieldValue = RowObject.aliquota-ipi.
        WHEN "aliquota-iss":U THEN ASSIGN pFieldValue = RowObject.aliquota-iss.
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "ind-reajuste":U THEN ASSIGN pFieldValue = RowObject.ind-reajuste.
        &if defined(bf-mat-comex) &then     
            WHEN "u-dec-1":U THEN ASSIGN pFieldValue = RowObject.u-dec-1.                
        &else
            WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.                
        &endif        
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

    /*--- Verifica se temptable RowObject estˇ dispon≠vel, caso nío esteja serˇ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "mo-codigo":U THEN ASSIGN pFieldValue = RowObject.mo-codigo.
        WHEN "nr-dias-taxa":U THEN ASSIGN pFieldValue = RowObject.nr-dias-taxa.
        WHEN "numero-ordem":U THEN ASSIGN pFieldValue = RowObject.numero-ordem.
        WHEN "prazo-entreg":U THEN ASSIGN pFieldValue = RowObject.prazo-entreg.
        WHEN "cod-cond-pag":U THEN ASSIGN pFieldValue = RowObject.cod-cond-pag.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "dias-validade":U THEN ASSIGN pFieldValue = RowObject.dias-validade.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        &if defined(bf-mat-comex) &then     
        &else
            WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.        
            WHEN "num-proc-entr-edi":U THEN ASSIGN pFieldValue = RowObject.num-proc-entr-edi.
            WHEN "num-proc-envio-edi":U THEN ASSIGN pFieldValue = RowObject.num-proc-envio-edi.            
            WHEN "seq-cotac":U THEN ASSIGN pFieldValue = RowObject.seq-cotac.            
            WHEN "cod-transp":U THEN ASSIGN pFieldValue = RowObject.cod-transp.            
            WHEN "codigo-icm":U THEN ASSIGN pFieldValue = RowObject.codigo-icm.
            WHEN "ind-orig-entrada":U THEN ASSIGN pFieldValue = RowObject.ind-orig-entrada.            
            WHEN "ind-via-envio":U THEN ASSIGN pFieldValue = RowObject.ind-via-envio.            
        &endif                
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ≠ndice COTACAO
  Parameters:
               retorna valor dos campos do ≠ndice COTACAO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    &if defined(bf-mat-comex) &then     
    &else
        DEFINE OUTPUT PARAMETER pnumero-ordem LIKE cotacao-item.numero-ordem NO-UNDO.
        DEFINE OUTPUT PARAMETER pcod-emitente LIKE cotacao-item.cod-emitente NO-UNDO.
        DEFINE OUTPUT PARAMETER pit-codigo LIKE cotacao-item.it-codigo NO-UNDO.
        DEFINE OUTPUT PARAMETER pseq-cotac LIKE cotacao-item.seq-cotac NO-UNDO.
    
        /*--- Verifica se temptable RowObject estˇ dispon≠vel, caso nío esteja serˇ
              retornada flag "NOK":U ---*/
        IF NOT AVAILABLE RowObject THEN
           RETURN "NOK":U.
    
        ASSIGN pnumero-ordem = RowObject.numero-ordem.
        ASSIGN pcod-emitente = RowObject.cod-emitente.
        ASSIGN pit-codigo = RowObject.it-codigo.
        ASSIGN pseq-cotac = RowObject.seq-cotac.
        RETURN "OK":U.        
    &endif           
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogField DBOProgram 
PROCEDURE getLogField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo lΩgico
  Parameters:
               recebe nome do campo
               retorna valor do campo
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject estˇ dispon≠vel, caso nío esteja serˇ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "possui-reaj":U THEN ASSIGN pFieldValue = RowObject.possui-reaj.
        WHEN "reaj-tabela":U THEN ASSIGN pFieldValue = RowObject.reaj-tabela.
        WHEN "taxa-financ":U THEN ASSIGN pFieldValue = RowObject.taxa-financ.
        WHEN "codigo-ipi":U THEN ASSIGN pFieldValue = RowObject.codigo-ipi.
        WHEN "cot-aprovada":U THEN ASSIGN pFieldValue = RowObject.cot-aprovada.
        WHEN "frete":U THEN ASSIGN pFieldValue = RowObject.frete.
        &if defined(bf-mat-comex) &then     
            WHEN "codigo-icm":U THEN ASSIGN pFieldValue = RowObject.codigo-icm.                
        &else
            WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.        
            WHEN "reajusta-cotacao":U THEN ASSIGN pFieldValue = RowObject.reajusta-cotacao.            
            WHEN "ind-ret-cotacao":U THEN ASSIGN pFieldValue = RowObject.ind-ret-cotacao.            
        &endif        
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
    &if defined(bf-mat-comex) &then     
    &else
        DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
        DEFINE OUTPUT PARAMETER pFieldValue AS RAW NO-UNDO.
    
        /*--- Verifica se temptable RowObject estˇ dispon≠vel, caso nío esteja serˇ
              retornada flag "NOK":U ---*/
        IF NOT AVAILABLE RowObject THEN
            RETURN "NOK":U.
    
        CASE pFieldName:
            OTHERWISE RETURN "NOK":U.
        END CASE.
        RETURN "OK":U.        
    &endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ≠ndice COTACAO
  Parameters:
               recebe valor dos campos do ≠ndice COTACAO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/

    &if defined(bf-mat-comex) &then         
    
        DEFINE INPUT PARAMETER pnumero-ordem LIKE cotacao-item.numero-ordem NO-UNDO.
        DEFINE INPUT PARAMETER pcod-emitente LIKE cotacao-item.cod-emitente NO-UNDO.
        DEFINE INPUT PARAMETER pit-codigo    LIKE cotacao-item.it-codigo    NO-UNDO.
        DEFINE INPUT PARAMETER pdata-cotacao LIKE cotacao-item.data-cotacao NO-UNDO.
    
        FIND FIRST bfcotacao-item WHERE
            bfcotacao-item.numero-ordem = pnumero-ordem AND
            bfcotacao-item.cod-emitente = pcod-emitente AND
            bfcotacao-item.it-codigo    = pit-codigo AND
            bfcotacao-item.data-cotacao = pdata-cotacao
            NO-LOCK NO-ERROR.
    
        /*--- Verifica se registro foi encontrado, em caso de erro serò retornada flag "NOK":U ---*/
        IF NOT AVAILABLE bfcotacao-item THEN
            RETURN "NOK":U.
    
        /*--- Reposiciona query atrav˝s de rowid e verifica a ocorr¨ncia de erros, caso
              existam erros serò retornada flag "NOK":U ---*/
        RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfcotacao-item)).
        IF RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.
    
        RETURN "OK":U.
    
    &else    
        DEFINE INPUT PARAMETER pnumero-ordem LIKE cotacao-item.numero-ordem NO-UNDO.
        DEFINE INPUT PARAMETER pcod-emitente LIKE cotacao-item.cod-emitente NO-UNDO.
        DEFINE INPUT PARAMETER pit-codigo LIKE cotacao-item.it-codigo NO-UNDO.
        DEFINE INPUT PARAMETER pseq-cotac LIKE cotacao-item.seq-cotac NO-UNDO.
    
        FIND FIRST bfcotacao-item WHERE
            bfcotacao-item.numero-ordem = pnumero-ordem AND
            bfcotacao-item.cod-emitente = pcod-emitente AND
            bfcotacao-item.it-codigo = pit-codigo AND
            bfcotacao-item.seq-cotac = pseq-cotac
            NO-LOCK NO-ERROR.
    
        /*--- Verifica se registro foi encontrado, em caso de erro serˇ retornada flag "NOK":U ---*/
        IF NOT AVAILABLE bfcotacao-item THEN
            RETURN "NOK":U.
    
        /*--- Reposiciona query atrav≤s de rowid e verifica a ocorrºncia de erros, caso
              existam erros serˇ retornada flag "NOK":U ---*/
        RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfcotacao-item)).
        IF RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.
    
        RETURN "OK":U.
    &endif
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOrdEmitByOrdem DBOProgram 
PROCEDURE openQueryOrdEmitByOrdem :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       antigas openQueries 2 e 3
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH {&TableName} WHERE cotacao-item.numero-ordem >= c-numero-ordem-ini and
                                                        cotacao-item.numero-ordem <= c-numero-ordem-fim and
                                                        cotacao-item.cod-emitente <= c-cod-emitente-ini and
                                                        cotacao-item.cod-emitente <= c-cod-emitente-fim and
                                                        cotacao-item.cot-aprovada = no and
                                                        cotacao-item.char-1 <> "",
                               each emitente      where emitente.cod-emitente = cotacao-item.cod-emitente and
                                                       (emitente.natureza = 3 or emitente.natureza = 4) 
                                                       no-lock by cotacao-item.numero-ordem.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintOrdEmit DBOProgram 
PROCEDURE setConstraintOrdEmit :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       antigos setConstraints 2 e 3
------------------------------------------------------------------------------*/

   def input parameter p-numero-ordem-ini as char no-undo.
   def input parameter p-numero-ordem-fim as char no-undo.
   def input parameter p-cod-emitente-ini as integer no-undo.
   def input parameter p-cod-emitente-fim as integer no-undo.

/* se n∆o quiser limitar a faixa por emitente, basta parametrizar com os valores m†ximo e m°nimo */

   assign c-numero-ordem-ini = int(p-numero-ordem-ini)
          c-numero-ordem-fim = int(p-numero-ordem-fim)
          c-cod-emitente-ini = p-cod-emitente-ini
          c-cod-emitente-fim = p-cod-emitente-fim.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Valida temptable RowObject
  Parameters:  recebe o tipo de validaªío (Create, Delete, Update)
  Notes:
------------------------------------------------------------------------------*/

        DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

        /*--- Utilize o par≥metro pType para identificar quais as validaªÑes a serem
              executadas ---*/
        /*--- Os valores poss≠veis para o par≥metro sío: Create, Delete e Update ---*/
        /*--- Devem ser tratados erros PROGRESS e erros do Produto, atrav≤s do
              include: method/svc/errors/inserr.i ---*/
        /*--- Inclua aqui as validaªÑes ---*/
        FIND FIRST RowObject NO-LOCK NO-ERROR.

        /*--- Verifica ocorrºncia de erros ---*/
        IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
            RETURN "NOK":U.

        RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


