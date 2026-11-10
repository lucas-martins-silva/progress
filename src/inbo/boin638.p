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
{include/i-prgvrs.i BOIN638 2.00.00.018 } /*** "010018" 17/06/2025 16:40:51 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin638 MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : 
    Purpose    : O DBO (Datasul Business Objects) ² um programa PROGRESS
                 que cont²m a l½gica de neg½cio e acesso a dados para uma
                 tabela do banco de dados.

    Parameters :

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de defini»’o ---*/
&GLOBAL-DEFINE DBOName texto-follow-up
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName texto-follow-up
&GLOBAL-DEFINE TableLabel texto-follow-up
&GLOBAL-DEFINE QueryName qr{&TableName}

/*--- Include com defini»’o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret½rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser id¼ntico ao nome do DBO mas com
      extens’o .i ---*/
{inbo/boin638.i RowObject}

/*--- Include com defini»’o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera»’o da defini»’o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini»’o
      manual da query ---*/
{method/dboqry.i}

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/* Defini‡Æo das vari veis necess rias a setConstraintByIndTipDoc */
DEFINE VARIABLE i-tipo-doc   AS INTEGER NO-UNDO INITIAL 0.
DEFINE VARIABLE i-fornec-ini AS INTEGER NO-UNDO INITIAL 0.
DEFINE VARIABLE i-fornec-fim AS INTEGER NO-UNDO INITIAL 999999999.

/* Defini‡Æo das vari veis necess rias a setConstraintFaixaIndTipDoc */
DEFINE VARIABLE i-tipo-doc-ini   AS INTEGER NO-UNDO INITIAL 0.
DEFINE VARIABLE i-tipo-doc-fim   AS INTEGER NO-UNDO INITIAL 99.
/* Defini‡Æo das vari veis necess rias a setConstraintFaixaNrRequisicao */
DEFINE VARIABLE i-nr-requis-ini   LIKE requisicao.nr-requisicao NO-UNDO INITIAL 0.
DEFINE VARIABLE i-nr-requis-fim   LIKE requisicao.nr-requisicao NO-UNDO INITIAL 999999999.
/* Defini‡Æo das vari veis necess rias a setConstraintFaixaNumeroOrdem */
DEFINE VARIABLE i-num-ordem-ini   AS INTEGER NO-UNDO INITIAL 0.
DEFINE VARIABLE i-num-ordem-fim   AS INTEGER NO-UNDO INITIAL 99999999.
/* Defini‡Æo das vari veis necess rias a setConstraintFaixaCodEmitente */
DEFINE VARIABLE i-cod-emit-ini   AS INTEGER NO-UNDO INITIAL 0.
DEFINE VARIABLE i-cod-emit-fim   AS INTEGER NO-UNDO INITIAL 999999999.
/* Defini‡Æo das vari veis necess rias a setConstraintFaixaItCodigo */
DEFINE VARIABLE c-it-codigo-ini   AS CHARACTER NO-UNDO INITIAL "".
DEFINE VARIABLE c-it-codigo-fim   AS CHARACTER NO-UNDO INITIAL "ZZZZZZZZZZZZZZZZ".
/* Defini‡Æo das vari veis necess rias a setConstraintFaixaNumPedido */
DEFINE VARIABLE i-num-pedido-ini   AS INTEGER NO-UNDO INITIAL 0.
DEFINE VARIABLE i-num-pedido-fim   AS INTEGER NO-UNDO INITIAL 99999999.
/* Defini‡Æo das vari veis necess rias a setConstraintFaixaSeqNarra */
DEFINE VARIABLE i-seq-narra-ini   AS INTEGER NO-UNDO INITIAL 0.
DEFINE VARIABLE i-seq-narra-fim   AS INTEGER NO-UNDO INITIAL 999.

DEF TEMP-TABLE ttRegistros 
    field origem  as character label "Origem"
    field numero as character label "Número"
    field responsavel as character label "Responsável"
    field data as character label "Data"
    field hora as character label "Hora"
	field fornecedor as character label "Fornecedor"
	field item as character label "Item".	
	
DEF TEMP-TABLE ttRegistroCompleto NO-UNDO
    FIELD origem      AS CHARACTER 
    FIELD numero      AS INTEGER FORMAT ">>>,>>>,>>>,>>9"  
    FIELD responsavel AS CHARACTER 
    FIELD data        AS DATE      
    FIELD hora        AS CHARACTER 
    FIELD fornecedor  AS INTEGER   
    FIELD item        AS CHARACTER 
    FIELD comentario  AS CHARACTER 
    FIELD sequencia   AS INTEGER
    FIELD epc-value   AS CHARACTER FORMAT "x(200)".

DEFINE TEMP-TABLE RowObjectAuxiliar LIKE RowObject.
DEF TEMP-TABLE ttComentarios
    field codigo as integer
    field comentario as character.	

{utp/ut-glob.i}
DEFINE VARIABLE c-lbl-requis-estoque AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-lbl-requis-compras AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-lbl-requis-cotacao AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-lbl-ordem          AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-lbl-cotacao        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-lbl-pedido         AS CHARACTER   NO-UNDO.
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
         HEIGHT             = 18.62
         WIDTH              = 57.4.
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


{utp/ut-liter.i "Requisi‡Æo Estoque"}
ASSIGN c-lbl-requis-estoque = RETURN-VALUE.
{utp/ut-liter.i "Requisi‡Æo Compras"}
ASSIGN c-lbl-requis-compras = RETURN-VALUE.
{utp/ut-liter.i "Requisi‡Æo Cota‡Æo"}
ASSIGN c-lbl-requis-cotacao = RETURN-VALUE.
{utp/ut-liter.i "Ordem"}
ASSIGN c-lbl-ordem = RETURN-VALUE.
{utp/ut-liter.i "Cota‡Æo"}
ASSIGN c-lbl-cotacao = RETURN-VALUE.
{utp/ut-liter.i "Pedido"}
ASSIGN c-lbl-pedido = RETURN-VALUE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeCreateRecord DBOProgram 
PROCEDURE beforeCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN RowObject.nr-trans          = next-value(seq-texto-follow-up,mgind).

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaRegistrosFollowUp DBOProgram 
PROCEDURE buscaRegistrosFollowUp :
/*------------------------------------------------------------------------------
  Purpose: Busca os registros de follow-up de determinado documento    
  Parameters: i-ind-tip-doc (INTEGER): Tipo do documento
  
  1 - Requisi‡Æo de Estoque
  2 - Solicita‡Æo de Compra
  3 - Solicita‡Æo de Cota‡Æo
  4 - Ordem de Compra
  5 - Cota‡Æo
  6 - Pedido de Compra
  
  i-numero-documento (INPUT)(INTEGER): N£mero do documento
  c-it-codigo      (INPUT)(CHARACTER): C¢digo do item
  i-sequencia        (INPUT)(INTEGER): Sequˆncia do item
  i-cod-emitente     (INPUT)(INTEGER): C¢digo do fornecedor
  i-seq-cotac        (INPUT)(INTEGER): Sequˆncia da cota‡Æo ou ordem de compra 
                                       no caso de pedido
  
  ttRegistroCompleto (OUTPUT)(TEMP-TABLE): Cont‚m os registro de follow-up para o documento
  RowErrors          (OUTPUT)(TEMP-TABLE): Erros ocorridos no processo.
 
  Notes:

------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER i-ind-tip-doc      AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER i-numero-documento AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER c-it-codigo        AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER i-sequencia        AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER i-cod-emitente     AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER i-seq-cotac        AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR ttRegistroCompleto.
    DEFINE OUTPUT PARAMETER TABLE FOR rowErrors.
        
    DEFINE VARIABLE piSeq                LIKE texto-follow-up.sequencia     NO-UNDO.      
    DEFINE VARIABLE i-nr-requisicao      LIKE texto-follow-up.nr-requisicao NO-UNDO.
    DEFINE VARIABLE i-num-pedido         LIKE texto-follow-up.num-pedido    NO-UNDO.
    DEFINE VARIABLE i-numero-ordem       LIKE texto-follow-up.numero-ordem  NO-UNDO.
    DEFINE VARIABLE i-emitente-followup  LIKE texto-follow-up.cod-emitente  NO-UNDO.
    DEFINE VARIABLE c-item-followup      LIKE texto-follow-up.it-codigo     NO-UNDO.

    EMPTY TEMP-TABLE ttRegistroCompleto.

    RUN indentificaDocumentoFollowUp (INPUT i-ind-tip-doc,     
                                      INPUT i-numero-documento,
                                      INPUT c-it-codigo,       
                                      INPUT i-sequencia,       
                                      INPUT i-cod-emitente,    
                                      INPUT i-seq-cotac,
                                      OUTPUT i-nr-requisicao,
                                      OUTPUT i-numero-ordem, 
                                      OUTPUT i-num-pedido,
                                      OUTPUT i-emitente-followup,
                                      OUTPUT piSeq,
                                      OUTPUT c-item-followup).

    IF i-nr-requisicao = 0 THEN DO:
        IF i-numero-ordem <> 0 THEN DO:
            FOR EACH texto-follow-up WHERE texto-follow-up.numero-ordem = i-numero-ordem NO-LOCK
                                  BREAK BY texto-follow-up.nr-trans DESCENDING:
               RUN criattRegistroCompleto. 
            
               IF LAST (texto-follow-up.nr-trans) THEN 
                   LEAVE.
            END.
        END.
        ELSE DO:                
            FOR EACH texto-follow-up WHERE texto-follow-up.num-pedido = i-num-pedido NO-LOCK
                                  BREAK BY texto-follow-up.nr-trans DESCENDING:
                RUN criattRegistroCompleto. 
                
                IF LAST (texto-follow-up.nr-trans) THEN 
                   LEAVE.
            END.
        END.
    END.
    ELSE IF piSeq = 0 THEN DO:
        FOR EACH texto-follow-up WHERE texto-follow-up.nr-requisicao = i-nr-requisicao NO-LOCK
                              BREAK BY texto-follow-up.nr-trans DESCENDING:
           RUN criattRegistroCompleto. 
        
           IF LAST (texto-follow-up.nr-trans) THEN 
               LEAVE.
        END.
    END.
    ELSE DO:
        FOR EACH texto-follow-up WHERE texto-follow-up.nr-requisicao = i-nr-requisicao AND
                                       (texto-follow-up.sequencia = piSeq OR texto-follow-up.sequencia = 0)NO-LOCK
                              BREAK BY texto-follow-up.nr-trans DESCENDING:
           RUN criattRegistroCompleto. 
        
           IF LAST (texto-follow-up.nr-trans) THEN 
               LEAVE.
        END.
    END. 
                           
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criattRegistroCompleto DBOProgram 
PROCEDURE criattRegistroCompleto :
/*------------------------------------------------------------------------------
  Purpose: Cria a temp-table ttRegistroCompleto com base o registro de tabela
  texto-follow-up que estiver posisionado.
    
  Parameters: 
  Notes:
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-numero        AS INTEGER                         NO-UNDO.
    DEFINE VARIABLE c-origem        AS CHARACTER                       NO-UNDO.

    IF NOT AVAIL texto-follow-up THEN 
        RETURN "NOK":U.
    
    CASE texto-follow-up.ind-tip-doc:
        WHEN 1 THEN DO:
            ASSIGN i-numero = texto-follow-up.nr-requisicao
                   c-origem = c-lbl-requis-estoque.
        END.
        WHEN 2 THEN DO:
            ASSIGN i-numero = texto-follow-up.nr-requisicao
                   c-origem = c-lbl-requis-compras.
        END.
        WHEN 3 THEN DO:
            ASSIGN i-numero = texto-follow-up.nr-requisicao
                   c-origem = c-lbl-requis-cotacao.
        END.
        WHEN 4 THEN DO:
            ASSIGN i-numero = texto-follow-up.numero-ordem
                   c-origem = c-lbl-ordem.
        END.
        WHEN 5 THEN DO:
            ASSIGN i-numero = texto-follow-up.numero-ordem
                   c-origem = c-lbl-cotacao.
        END.
        WHEN 6 THEN DO:
            ASSIGN i-numero = texto-follow-up.num-pedido
                   c-origem = c-lbl-pedido.
        END.
    END.

    CREATE ttRegistroCompleto.
    ASSIGN ttRegistroCompleto.origem      = c-origem
           ttRegistroCompleto.numero      = i-numero
           ttRegistroCompleto.responsavel = texto-follow-up.cod-usuar-alter
           ttRegistroCompleto.data        = texto-follow-up.dat-alter
           ttRegistroCompleto.hora        = texto-follow-up.hra-alter
           ttRegistroCompleto.fornecedor  = texto-follow-up.cod-emitente
           ttRegistroCompleto.item        = texto-follow-up.it-codigo
           ttRegistroCompleto.comentario  = texto-follow-up.des-narrativa
           ttRegistroCompleto.sequencia   = texto-follow-up.sequencia.                                     

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findTexto_follow_up_u DBOProgram 
PROCEDURE findTexto_follow_up_u :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* ----------------------------- PROXIES BO 1.1 ----------------------------- */

    DEFINE INPUT PARAMETER  pinr-trans AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER pcreturn   AS CHARACTER NO-UNDO.
 
    RUN goToKey (input pinr-trans).
    
    IF return-value = "OK" THEN ASSIGN pcreturn = "". 
    IF return-value = "NOK" THEN do:
        {utp/ut-table.i movind {&TABLENAME} 1}
        RUN utp/ut-msgs.p (input "msg":U,
                           input 2,
                           input return-value).
        ASSIGN pcreturn =  return-value.  
    END.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "des-narrativa":U THEN ASSIGN pFieldValue = RowObject.des-narrativa.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
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

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
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

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "ind-tip-doc":U THEN ASSIGN pFieldValue = RowObject.ind-tip-doc.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "nr-requisicao":U THEN ASSIGN pFieldValue = RowObject.nr-requisicao.
        WHEN "nr-trans":U THEN ASSIGN pFieldValue = RowObject.nr-trans.
        WHEN "num-pedido":U THEN ASSIGN pFieldValue = RowObject.num-pedido.
        WHEN "numero-ordem":U THEN ASSIGN pFieldValue = RowObject.numero-ordem.
        WHEN "parcela":U THEN ASSIGN pFieldValue = RowObject.parcela.
        WHEN "seq-narra":U THEN ASSIGN pFieldValue = RowObject.seq-narra.
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
  Purpose:     Retorna valores dos campos do ­ndice ADITIVO
  Parameters:
               retorna valor dos campos do ­ndice ADITIVO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pind-tip-doc   LIKE texto-follow-up.ind-tip-doc   NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-requisicao LIKE texto-follow-up.nr-requisicao NO-UNDO.
    DEFINE OUTPUT PARAMETER psequencia     LIKE texto-follow-up.sequencia     NO-UNDO.
    DEFINE OUTPUT PARAMETER pit-codigo     LIKE texto-follow-up.it-codigo     NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pind-tip-doc   = RowObject.ind-tip-doc.
    ASSIGN pnr-requisicao = RowObject.nr-requisicao.
    ASSIGN psequencia     = RowObject.sequencia.
    ASSIGN pit-codigo     = RowObject.it-codigo.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogField DBOProgram 
PROCEDURE getLogField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo l½gico
  Parameters:
               recebe nome do campo
               retorna valor do campo
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RAW NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
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
  Purpose:     Reposiciona registro com base no ­ndice TEXTO-FOLLOW-UP
  Parameters:
               recebe valor dos campos do ­ndice TEXTO-FOLLOW-UP
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pind-tip-doc   LIKE texto-follow-up.ind-tip-doc   NO-UNDO.
    DEFINE INPUT PARAMETER pnr-requisicao LIKE texto-follow-up.nr-requisicao NO-UNDO.
    DEFINE INPUT PARAMETER psequencia     LIKE texto-follow-up.sequencia     NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo     LIKE texto-follow-up.it-codigo     NO-UNDO.

    FIND FIRST bftexto-follow-up WHERE
        bftexto-follow-up.ind-tip-doc   = pind-tip-doc   AND
        bftexto-follow-up.nr-requisicao = pnr-requisicao AND
        bftexto-follow-up.sequencia     = psequencia     AND
        bftexto-follow-up.it-codigo     = pit-codigo
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bftexto-follow-up THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav²s de rowid e verifica a ocorr¼ncia de erros, caso
          existam erros serÿ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bftexto-follow-up)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gravaFollowUp DBOProgram 
PROCEDURE gravaFollowUp :
/*------------------------------------------------------------------------------
  Purpose: Grava um registro de follow-up
  
  Parameters: i-ind-tip-doc (INTEGER): Tipo do documento
  
  1 - Requisi‡Æo de Estoque
  2 - Solicita‡Æo de Compra
  3 - Solicita‡Æo de Cota‡Æo
  4 - Ordem de Compra
  5 - Cota‡Æo
  6 - Pedido de Compra
  
  i-numero-documento (INPUT)(INTEGER): N£mero do documento
  c-it-codigo      (INPUT)(CHARACTER): C¢digo do item
  i-sequencia        (INPUT)(INTEGER): Sequˆncia do item
  i-cod-emitente     (INPUT)(INTEGER): C¢digo do fornecedor
  i-seq-cotac        (INPUT)(INTEGER): Sequˆncia da cota‡Æo ou ordem de compra no caso de pedido
  c-narrativa      (INPUT)(CHARACTER): Coment rio informado para o follow-up
  
  RowErrors      (OUTPUT)(TEMP-TABLE): Erros ocorridos no processo.
 
  Notes:

------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER i-ind-tip-doc      AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER i-numero-documento AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER c-it-codigo        AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER i-sequencia        AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER i-cod-emitente     AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER i-seq-cotac        AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER c-narrativa        AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR rowErrors.
        
    DEFINE VARIABLE piSeq                LIKE texto-follow-up.sequencia     NO-UNDO.      
    DEFINE VARIABLE i-nr-requisicao      LIKE texto-follow-up.nr-requisicao NO-UNDO.
    DEFINE VARIABLE i-num-pedido         LIKE texto-follow-up.num-pedido    NO-UNDO.
    DEFINE VARIABLE i-numero-ordem       LIKE texto-follow-up.numero-ordem  NO-UNDO.
    DEFINE VARIABLE i-emitente-followup  LIKE texto-follow-up.cod-emitente  NO-UNDO.
    DEFINE VARIABLE c-item-followup      LIKE texto-follow-up.it-codigo     NO-UNDO.
    DEFINE VARIABLE i-parcela            LIKE texto-follow-up.parcela       NO-UNDO.
    DEFINE VARIABLE i-seq-narrativa      LIKE texto-follow-up.seq-narra     NO-UNDO.


    

    RUN indentificaDocumentoFollowUp  (INPUT i-ind-tip-doc,     
                                       INPUT i-numero-documento,
                                       INPUT c-it-codigo,       
                                       INPUT i-sequencia,       
                                       INPUT i-cod-emitente,    
                                       INPUT i-seq-cotac,
                                       OUTPUT i-nr-requisicao,
                                       OUTPUT i-numero-ordem, 
                                       OUTPUT i-num-pedido,
                                       OUTPUT i-emitente-followup,
                                       OUTPUT piSeq,
                                       OUTPUT c-item-followup).

    IF i-nr-requisicao = 0 THEN DO:
        IF i-numero-ordem <> 0 THEN DO:
            FOR FIRST texto-follow-up FIELDS (seq-narra) 
                WHERE texto-follow-up.numero-ordem = i-numero-ordem NO-LOCK 
                   BY texto-follow-up.nr-trans DESCENDING:
                ASSIGN i-seq-narrativa = texto-follow-up.seq-narra.       
            END.
        END.
        ELSE DO:                
            FOR FIRST texto-follow-up FIELDS (seq-narra) 
                WHERE texto-follow-up.num-pedido = i-num-pedido NO-LOCK
                   BY texto-follow-up.nr-trans DESCENDING:
               ASSIGN i-seq-narrativa = texto-follow-up.seq-narra.  
           end.
        END.
    END.
    ELSE IF piSeq = 0 then DO:
        FOR FIRST texto-follow-up FIELDS (seq-narra) 
            WHERE texto-follow-up.nr-requisicao = i-nr-requisicao NO-LOCK 
               BY texto-follow-up.nr-trans DESCENDING:
            ASSIGN i-seq-narrativa = texto-follow-up.seq-narra.   
        END.
    END.
    ELSE DO:
        FOR FIRST texto-follow-up FIELDS (seq-narra) 
            WHERE texto-follow-up.nr-requisicao = i-nr-requisicao AND
                  texto-follow-up.sequencia = piSeq NO-LOCK
               BY texto-follow-up.nr-trans DESCENDING:
            ASSIGN i-seq-narrativa = texto-follow-up.seq-narra.
        END.
    END.     
     
    IF AVAIL texto-follow-up THEN DO:
        ASSIGN i-seq-narrativa = i-seq-narrativa + 1.
    END.                
    ELSE DO:
        ASSIGN i-seq-narrativa = 1.
    END.
    
    EMPTY TEMP-TABLE RowObjectAuxiliar.
    CREATE RowObjectAuxiliar.
    ASSIGN RowObjectAuxiliar.cod-emitente      = i-emitente-followup
           RowObjectAuxiliar.des-narrativa     = c-narrativa
           RowObjectAuxiliar.ind-tip-doc       = i-ind-tip-doc
           RowObjectAuxiliar.it-codigo         = c-item-followup
           RowObjectAuxiliar.nr-requisicao     = i-nr-requisicao
           RowObjectAuxiliar.num-pedido        = i-num-pedido
           RowObjectAuxiliar.numero-ordem      = i-numero-ordem
           RowObjectAuxiliar.parcela           = i-parcela
           RowObjectAuxiliar.seq-narra         = i-seq-narrativa
           RowObjectAuxiliar.sequencia         = piSeq
           RowObjectAuxiliar.Dat-alter         = TODAY
           RowObjectAuxiliar.hra-alter         = STRING(TIME,"hh:mm:ss")
           RowObjectAuxiliar.cod-usuar-alter   = c-seg-usuario.

    RUN emptyRowErrors IN THIS-PROCEDURE.
    RUN openQueryStatic IN THIS-PROCEDURE (INPUT 'Main').
    RUN setRecord IN THIS-PROCEDURE (INPUT TABLE RowObjectAuxiliar).
    RUN createRecord IN THIS-PROCEDURE.
    RUN getRowErrors IN THIS-PROCEDURE (OUTPUT TABLE RowErrors).
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE indentificaDocumentoFollowUp DBOProgram 
PROCEDURE indentificaDocumentoFollowUp :
/*------------------------------------------------------------------------------
  Purpose: Faz a leitura de um Follow-up gen‚rico para preencher as vari veis de 
  cada tipo de documento 
  Parameters: i-ind-tip-doc (INTEGER): Tipo do documento
  
  1 - Requisi‡Æo de Estoque
  2 - Solicita‡Æo de Compra
  3 - Solicita‡Æo de Cota‡Æo
  4 - Ordem de Compra
  5 - Cota‡Æo
  6 - Pedido de Compra
  
  i-numero-documento (INPUT)(INTEGER): N£mero do documento
  c-it-codigo      (INPUT)(CHARACTER): C¢digo do item
  i-sequencia        (INPUT)(INTEGER): Sequˆncia do item
  i-cod-emitente     (INPUT)(INTEGER): C¢digo do fornecedor
  i-seq-cotac        (INPUT)(INTEGER): Sequˆncia da cota‡Æo ou ordem de compra no caso de pedido
  
  i-nr-requisicao       (OUTPUT)(INTEGER): N£mero da requisi‡Æo
  i-numero-ordem        (OUTPUT)(INTEGER): N£mero da ordem de compra
  i-num-pedido          (OUTPUT)(INTEGER): N£mero do pedido de compra
  i-emitente-followup   (OUTPUT)(INTEGER): C¢digo do fornecedor
  i-seq-followup        (OUTPUT)(INTEGER): Sequˆncia
  c-item-followup     (OUTPUT)(CHARACTER): C¢digo do item
 
  Notes:

------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER i-ind-tip-doc        AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER i-numero-documento   AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER c-it-codigo          AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER i-sequencia          AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER i-cod-emitente       AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER i-seq-cotac          AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER i-nr-requisicao     AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER i-numero-ordem      AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER i-num-pedido        AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER i-emitente-followup AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER i-seq-followup      AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER c-item-followup     AS CHARACTER NO-UNDO.

    DEFINE VARIABLE piSeq AS INTEGER     NO-UNDO.

    ASSIGN i-nr-requisicao = 0
           i-numero-ordem  = 0
           i-num-pedido    = 0
           piSeq           = i-sequencia.
                
    IF i-ind-tip-doc = 6 THEN 
        ASSIGN piSeq = 0.

    CASE i-ind-tip-doc:
        WHEN 1 OR WHEN 2 THEN DO:
            FOR FIRST requisicao FIELDS (nr-requisicao) WHERE requisicao.nr-requisicao = i-numero-documento NO-LOCK:
                IF piSeq > 0 THEN DO:
                    FOR FIRST it-requisicao FIELDS (numero-ordem sequencia) 
                        WHERE it-requisicao.nr-requisicao = requisicao.nr-requisicao 
                          AND it-requisicao.sequencia = piSeq NO-LOCK:
                        FOR FIRST ordem-compra FIELDS (numero-ordem num-pedido cod-emitente it-codigo) 
                            WHERE ordem-compra.numero-ordem = it-requisicao.numero-ordem NO-LOCK: END.
                    END.
                END.
                ELSE DO: 
                    FOR FIRST ordem-compra FIELDS (numero-ordem num-pedido cod-emitente) 
                        WHERE ordem-compra.nr-requisicao = requisicao.nr-requisicao NO-LOCK: END.
                END.
                        
                ASSIGN i-nr-requisicao     = requisicao.nr-requisicao
                       i-numero-ordem      = ordem-compra.numero-ordem WHEN AVAILABLE ordem-compra
                       i-num-pedido        = ordem-compra.num-pedido   WHEN AVAILABLE ordem-compra
                       i-emitente-followup = ordem-compra.cod-emitente WHEN AVAILABLE ordem-compra
                       i-seq-followup      = it-requisicao.sequencia   WHEN AVAILABLE it-requisicao
                       c-item-followup     = ordem-compra.it-codigo    WHEN AVAILABLE ordem-compra.
            END. 
        END.    
        WHEN 3 THEN DO:
            FOR FIRST requisicao FIELDS (nr-requisicao) WHERE requisicao.nr-requisicao = i-numero-documento NO-LOCK:
                FOR FIRST ordem-compra FIELDS (numero-ordem num-pedido cod-emitente it-codigo) 
                    WHERE ordem-compra.nr-requisicao = requisicao.nr-requisicao NO-LOCK: END.

                ASSIGN i-nr-requisicao      = requisicao.nr-requisicao
                       i-numero-ordem       = ordem-compra.numero-ordem WHEN AVAILABLE ordem-compra
                       i-num-pedido         = ordem-compra.num-pedido   WHEN AVAILABLE ordem-compra
                       i-emitente-followup  = ordem-compra.cod-emitente WHEN AVAILABLE ordem-compra
                       c-item-followup      = ordem-compra.it-codigo    WHEN AVAILABLE ordem-compra.
            END.        
        END.
        WHEN 4 THEN DO:
            FOR FIRST ordem-compra FIELDS (nr-requisicao numero-ordem num-pedido) 
                WHERE ordem-compra.numero-ordem = i-numero-documento NO-LOCK:
                ASSIGN i-nr-requisicao      = ordem-compra.nr-requisicao
                       i-numero-ordem       = ordem-compra.numero-ordem  
                       i-num-pedido         = ordem-compra.num-pedido
                       i-emitente-followup  = ordem-compra.cod-emitente
                       c-item-followup      = ordem-compra.it-codigo.
            END.
        END.
        WHEN 5 THEN DO:
            FOR FIRST cotacao-item FIELDS (numero-ordem seq-cotac)
                WHERE cotacao-item.it-codigo    = c-it-codigo        AND  
                      cotacao-item.cod-emitente = i-cod-emitente     AND 
                      cotacao-item.numero-ordem = i-numero-documento AND 
                      cotacao-item.seq-cotac    = i-seq-cotac NO-LOCK:

                FOR FIRST ordem-compra FIELDS (nr-requisicao num-pedido cod-emitente it-codigo) 
                    WHERE ordem-compra.numero-ordem = cotacao-item.numero-ordem NO-LOCK:
                END.
                
                ASSIGN i-nr-requisicao     = ordem-compra.nr-requisicao WHEN AVAILABLE ordem-compra
                       i-numero-ordem      = cotacao-item.numero-ordem
                       i-num-pedido        = ordem-compra.num-pedido    WHEN AVAILABLE ordem-compra
                       i-emitente-followup = ordem-compra.cod-emitente  WHEN AVAILABLE ordem-compra
                       c-item-followup     = ordem-compra.it-codigo     WHEN AVAILABLE ordem-compra
                       i-seq-followup      = cotacao-item.seq-cotac.
            END.        
        END.
        WHEN 6 THEN DO:
            FOR FIRST pedido-compr FIELDS(num-pedido) WHERE pedido-compr.num-pedido = i-numero-documento NO-LOCK:
                FOR FIRST ordem-compra FIELDS (cod-estabel nr-requisicao) 
                    WHERE ordem-compra.num-pedido = pedido-compr.num-pedido NO-LOCK: END.
            END.
            
            IF AVAIL ordem-compra AND i-seq-cotac = 0 THEN DO:
                
                DEFINE VARIABLE i-cont AS INTEGER INITIAL 0.
                FOR EACH ordem-compra FIELDS (numero-ordem) WHERE ordem-compra.num-pedido = pedido-compr.num-pedido NO-LOCK:
                    ASSIGN i-cont = i-cont + 1
                           i-seq-cotac = ordem-compra.numero-ordem.
                    
                END.
                
                IF i-cont > 1 THEN DO:
                    CREATE RowErrors. 
                    run utp/ut-msgs.p (input "msg",
                                       input 54533,
                                       input "").
                    ASSIGN ErrorNumber      = 54533 
                           ErrorDescription = RETURN-VALUE.
                    RETURN "NOK":U.
                END.
            END.
            ELSE DO: 
                FOR FIRST ordem-compra FIELDS (nr-requisicao numero-ordem cod-emitente it-codigo) 
                    WHERE ordem-compra.num-pedido = pedido-compr.num-pedido AND 
                          ordem-compra.numero-ordem = i-seq-cotac NO-LOCK:
                END.
            END.
            ASSIGN i-nr-requisicao     = ordem-compra.nr-requisicao WHEN AVAILABLE ordem-compra
                   i-numero-ordem      = ordem-compra.numero-ordem  WHEN AVAILABLE ordem-compra
                   i-num-pedido        = pedido-compr.num-pedido    WHEN AVAILABLE pedido-compr
                   i-emitente-followup = ordem-compra.cod-emitente  WHEN AVAILABLE ordem-compra
                   c-item-followup     = ordem-compra.it-codigo     WHEN AVAILABLE ordem-compra.                      
        END.
    END.

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

/* ----------------------------- PROXIES BO 1.1 ----------------------------- */
    define input parameter piabertura as integer no-undo.
    case piabertura:
        when 1 then do:
            run openQueryStatic (input "Main").
        end.
        when 2 then do:
            run openQueryStatic (input "ByIndTipDoc2").
        end.
        when 3 then do:
            run openQueryStatic (input "ByIndTipDoc").
        end.        
    end case.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByIndTipDoc DBOProgram 
PROCEDURE openQueryByIndTipDoc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF (i-fornec-ini = i-fornec-fim) THEN DO:
        OPEN QUERY {&QueryName} FOR EACH {&TABLENAME} WHERE
                                         {&TABLENAME}.cod-emitente = i-fornec-ini AND
                                         {&tablename}.ind-tip-doc  >= i-tipo-doc   NO-LOCK INDEXED-REPOSITION.                                                                                
    END.
    ELSE DO:
        OPEN QUERY {&QueryName} FOR EACH {&TABLENAME} WHERE
                                         {&TABLENAME}.cod-emitente >= i-fornec-ini AND
                                         {&TABLENAME}.cod-emitente <= i-fornec-fim AND
                                         {&tablename}.ind-tip-doc  >= i-tipo-doc  NO-LOCK INDEXED-REPOSITION.
    END.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME 

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByIndTipDoc2 DBOProgram 
PROCEDURE openQueryByIndTipDoc2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        OPEN QUERY {&QueryName} FOR EACH {&TABLENAME} WHERE
                                         {&tablename}.ind-tip-doc  >= i-tipo-doc   NO-LOCK INDEXED-REPOSITION.                                                                                
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFaixaIndTipDoc DBOProgram 
PROCEDURE openQueryFaixaIndTipDoc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TABLENAME} WHERE
                                     {&tablename}.ind-tip-doc  >= i-tipo-doc-ini AND
                                     {&tablename}.ind-tip-doc  <= i-tipo-doc-fim AND
                                     {&TABLENAME}.cod-emitente >= i-cod-emit-ini AND
                                     {&TABLENAME}.cod-emitente <= i-cod-emit-fim NO-LOCK use-index texto-follow-up INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME 

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFaixaNrRequisicao DBOProgram 
PROCEDURE openQueryFaixaNrRequisicao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TABLENAME} WHERE
                                     {&TABLENAME}.nr-requisicao >= i-nr-requis-ini AND
                                     {&TABLENAME}.nr-requisicao <= i-nr-requis-fim AND
                                     {&TABLENAME}.cod-emitente  >= i-cod-emit-ini  AND
                                     {&TABLENAME}.cod-emitente  <= i-cod-emit-fim  NO-LOCK by nr-requisicao INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME 

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFaixaNumeroOrdem DBOProgram 
PROCEDURE openQueryFaixaNumeroOrdem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TABLENAME} WHERE
                                     {&TABLENAME}.numero-ordem >= i-num-ordem-ini AND
                                     {&TABLENAME}.numero-ordem <= i-num-ordem-fim AND
                                     {&TABLENAME}.cod-emitente >= i-cod-emit-ini  AND
                                     {&TABLENAME}.cod-emitente <= i-cod-emit-fim  NO-LOCK by numero-ordem INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME 

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFaixaCodEmitente DBOProgram 
PROCEDURE openQueryFaixaCodEmitente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TABLENAME} WHERE
                                     {&TABLENAME}.cod-emitente >= i-cod-emit-ini AND
                                     {&TABLENAME}.cod-emitente <= i-cod-emit-fim NO-LOCK by cod-emitente by ind-tip-doc INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME 

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFaixaItCodigo DBOProgram 
PROCEDURE openQueryFaixaItCodigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TABLENAME} WHERE
                                     {&tablename}.it-codigo    >= c-it-codigo-ini AND
                                     {&tablename}.it-codigo    <= c-it-codigo-fim AND
                                     {&TABLENAME}.cod-emitente >= i-cod-emit-ini  AND
                                     {&TABLENAME}.cod-emitente <= i-cod-emit-fim  NO-LOCK by it-codigo INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME 

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFaixaNumPedido DBOProgram 
PROCEDURE openQueryFaixaNumPedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TABLENAME} WHERE
                                     {&TABLENAME}.num-pedido   >= i-num-pedido-ini AND
                                     {&TABLENAME}.num-pedido   <= i-num-pedido-fim AND
                                     {&TABLENAME}.cod-emitente >= i-cod-emit-ini   AND
                                     {&TABLENAME}.cod-emitente <= i-cod-emit-fim   NO-LOCK by num-pedido by ind-tip-doc INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME 

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFaixaSeqNarra DBOProgram 
PROCEDURE openQueryFaixaSeqNarra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TABLENAME} WHERE
                                     {&TABLENAME}.seq-narra    >= i-seq-narra-ini  AND
                                     {&TABLENAME}.seq-narra    <= i-seq-narra-fim  AND
                                     {&TABLENAME}.cod-emitente >= i-cod-emit-ini   AND
                                     {&TABLENAME}.cod-emitente <= i-cod-emit-fim   NO-LOCK by seq-narra by ind-tip-doc INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME 

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH texto-follow-up NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornatextoAcumulativoFollowUp DBOProgram 
PROCEDURE retornatextoAcumulativoFollowUp :
/*------------------------------------------------------------------------------
  Purpose:     Retorna os textos acumulativos referentes ao follow-up de compras 
               de acordo com o tipo de documento
  Parameters:  
               ipar1  : prRowid        : recebe r-rowid da tabela cotacao-item
               ipar2  : piIndTipDoc    : recebe tipo do documento
               ipar3  : piSeq          : recebe seqˆncia
               ipar4  : pcDesNarrativa : recebe texto digitado pelo usu rio
               ipar5  : pcSegUsuario   : recebe usu rio corrente
               opar6  : pcDocumento    : retorna tipo de documento
               opar7  : piOrdem        : retorna n£mero de ordem de compra
               opar8  : piPedido       : retorna n£mero de pedido de compra
               opar9  : pcUsuario      : retorna usuario
               opar10 : pdaData         : retorna data
               opar11 : pcHora         : retorna hora
               opar12 : pcNarrativa    : retorna texto acumulativo
  Notes:       
------------------------------------------------------------------------------*/

    def input  param prRowid        as   rowid no-undo.
    def input  param piIndTipDoc    like texto-follow-up.ind-tip-doc   no-undo.
    def input  param piSeq          like texto-follow-up.sequencia     no-undo.
    def input  param pcDesNarrativa like texto-follow-up.des-narrativa no-undo.
    def input  param pcSegUsuario   as char no-undo.
    def output param pcDocumento    as char no-undo.
    def output param piOrdem        like texto-follow-up.numero-ordem  no-undo.
    def output param piPedido       like texto-follow-up.num-pedido    no-undo.
    def output param pcUsuario      as char no-undo.
    def output param pdaData        as date no-undo.
    def output param pcHora         as char no-undo.
    def output param pcNarrativa    like texto-follow-up.des-narrativa no-undo.
    
    def var c-user   as char no-undo.
    def var c-data   as char no-undo.
    def var c-hora   as char no-undo.
    def var c-doc    as char no-undo.
    def var c-ord    as char no-undo.
    def var c-ped    as char no-undo. 
    def var c-cabec  as char no-undo. 
    def var c-header as char no-undo. 
    
     
    def var i-cod-emitente  like texto-follow-up.cod-emitente.
    def var c-it-codigo     like texto-follow-up.it-codigo.
    def var i-nr-requisicao like texto-follow-up.nr-requisicao.
    def var i-num-pedido    like texto-follow-up.num-pedido.
    def var i-numero-ordem  like texto-follow-up.numero-ordem.
    def var i-parcela       like texto-follow-up.parcela.
    def var piSeq-narra     like texto-follow-up.seq-narra.
    def var piSequencia     like texto-follow-up.sequencia.
    def var c-texto-narrat  like texto-follow-up.des-narrativa.
    
      assign i-nr-requisicao = 0
             i-numero-ordem  = 0
             i-cod-emitente  = 0
             c-it-codigo     = ""
             piSequencia     = 0
             i-num-pedido    = 0
             i-parcela       = 0.
             
  {utp/ut-liter.i Usu rio * L}
  assign c-user = trim(return-value).
  {utp/ut-liter.i Data * L}
  assign c-data = trim(return-value).
  {utp/ut-liter.i Hora * L}
  assign c-hora = trim(return-value).
 
  {utp/ut-liter.i Documento * L}
  assign c-doc = trim(return-value).
  {utp/ut-liter.i Ordem_Compra * L}
  assign c-ord = trim(return-value).
  {utp/ut-liter.i Pedido * L}
  assign c-ped = trim(return-value).
             

    if piIndTipDoc = 6 then assign piSeq = 0.
    
      case piIndTipDoc:
          when 1 or when 2 then do:
            find requisicao   where rowid(requisicao)   = prRowid no-lock no-error.
            if avail requisicao then do:
              if piSeq > 0 then do:
                 find it-requisicao where 
                    it-requisicao.nr-requisicao = requisicao.nr-requisicao and
                    it-requisicao.sequencia = piSeq no-lock no-error.
                 find ordem-compra where ordem-compra.numero-ordem = it-requisicao.numero-ordem no-lock no-error.
              end.
              else 
                 find first ordem-compra where ordem-compra.nr-requisicao = requisicao.nr-requisicao no-lock no-error.     
              
              assign i-nr-requisicao = requisicao.nr-requisicao
                     i-numero-ordem  = ordem-compra.numero-ordem when available ordem-compra
                     i-cod-emitente  = ordem-compra.cod-emitente when available ordem-compra
                     c-it-codigo     = ordem-compra.it-codigo    when available ordem-compra
                     i-num-pedido    = ordem-compra.num-pedido   when available ordem-compra
                     piSequencia     = it-requisicao.sequencia   when available it-requisicao.        
            end.         
          end.
          when 3 then do:
             find requisicao   where rowid(requisicao)   = prRowid no-lock no-error.
             if avail requisicao then do:
              find first ordem-compra where ordem-compra.nr-requisicao = requisicao.nr-requisicao no-lock no-error.
              assign i-nr-requisicao = requisicao.nr-requisicao
                     i-numero-ordem  = ordem-compra.numero-ordem when available ordem-compra
                     i-cod-emitente  = ordem-compra.cod-emitente when available ordem-compra
                     c-it-codigo     = ordem-compra.it-codigo    when available ordem-compra
                     i-num-pedido    = ordem-compra.num-pedido   when available ordem-compra.
             end.        
          end.
          when 4 then do:
              find ordem-compra where rowid(ordem-compra) = prRowid no-lock no-error.          
              find first requisicao where requisicao.cod-estabel   = ordem-compra.cod-estabel   and
                                          requisicao.nr-requisicao = ordem-compra.nr-requisicao no-lock no-error.
                                           
              assign i-nr-requisicao = ordem-compra.nr-requisicao
                     i-numero-ordem  = ordem-compra.numero-ordem
                     i-cod-emitente  = ordem-compra.cod-emitente
                     c-it-codigo     = ordem-compra.it-codigo
                     i-num-pedido    = ordem-compra.num-pedido.
          end.
          when 5 then do:
              find first cotacao-item where rowid(cotacao-item) = prRowid no-lock no-error.
              if avail cotacao-item then do:
              find first ordem-compra where ordem-compra.numero-ordem = cotacao-item.numero-ordem no-lock no-error.
              find first requisicao where requisicao.cod-estabel   = ordem-compra.cod-estabel   and
                                          requisicao.nr-requisicao = ordem-compra.nr-requisicao no-lock no-error.
    
              assign i-nr-requisicao = ordem-compra.nr-requisicao when available ordem-compra
                     i-numero-ordem  = cotacao-item.numero-ordem
                     i-cod-emitente  = ordem-compra.cod-emitente  when available ordem-compra
                     c-it-codigo     = ordem-compra.it-codigo     when available ordem-compra
                     piSequencia     = cotacao-item.seq-cotac
                     i-num-pedido    = ordem-compra.num-pedido    when available ordem-compra.
             end.        
          end.
          when 6 then do:
              find pedido-compr where rowid(pedido-compr) = prRowid no-lock no-error.
              find first ordem-compra where ordem-compra.num-pedido = pedido-compr.num-pedido no-lock no-error.
              find first requisicao where requisicao.cod-estabel   = ordem-compra.cod-estabel   and
                                          requisicao.nr-requisicao = ordem-compra.nr-requisicao no-lock no-error.
             
              assign i-nr-requisicao = ordem-compra.nr-requisicao when available ordem-compra
                     i-numero-ordem  = ordem-compra.numero-ordem  when available ordem-compra
                     i-cod-emitente  = ordem-compra.cod-emitente  when available ordem-compra
                     c-it-codigo     = ordem-compra.it-codigo     when available ordem-compra
                     i-num-pedido    = pedido-compr.num-pedido.
          end.
          when 7 or when 8 then do:
              find recebimento  where rowid(recebimento)  = prRowid no-lock no-error.
              find first ordem-compra where ordem-compra.numero-ordem = recebimento.numero-ordem no-lock no-error.
              find first requisicao where requisicao.cod-estabel   = ordem-compra.cod-estabel   and
                                          requisicao.nr-requisicao = ordem-compra.nr-requisicao no-lock no-error.
              assign i-nr-requisicao = ordem-compra.nr-requisicao when available ordem-compra
                     i-numero-ordem  = recebimento.numero-ordem
                     i-cod-emitente  = ordem-compra.cod-emitente  when available ordem-compra
                     c-it-codigo     = recebimento.it-codigo
                     i-num-pedido    = recebimento.num-pedido
                     i-parcela       = recebimento.parcela.
          end.
       end.
       assign c-texto-narrat = ""
              piSeq-narra    = 0.
           
       if i-nr-requisicao = 0 then
           for each texto-follow-up where texto-follow-up.numero-ordem = i-numero-ordem no-lock
                    break by texto-follow-up.nr-trans descending:
               if texto-follow-up.seq-narra > piSeq-narra
               then
                   assign piSeq-narra = texto-follow-up.seq-narra.
               if texto-follow-up.des-narrativa <> ?
               then
                   assign c-texto-narrat = c-texto-narrat + chr(10) + chr(10) + 
                                           "======== " + texto-follow-up.des-narrativa.
               if last(texto-follow-up.nr-trans)
               then
                   leave.
           end.
       else if piSeq = 0 then 
          for each texto-follow-up where texto-follow-up.nr-requisicao = i-nr-requisicao no-lock
                    break by texto-follow-up.nr-trans descending:
               if texto-follow-up.seq-narra > piSeq-narra
               then
                   assign piSeq-narra = texto-follow-up.seq-narra.
               if texto-follow-up.des-narrativa <> ?
                 then
                     assign c-texto-narrat = c-texto-narrat + chr(10) + chr(10) + 
                                             "========" + texto-follow-up.des-narrativa.   
               
               if last(texto-follow-up.nr-trans)
               then
                   leave.
          end.
       else 
          for each texto-follow-up where texto-follow-up.nr-requisicao = i-nr-requisicao and
               texto-follow-up.sequencia = piSeq no-lock
               break by texto-follow-up.nr-trans descending:
               if texto-follow-up.seq-narra > piSeq-narra
               then
                   assign piSeq-narra = texto-follow-up.seq-narra.
               if texto-follow-up.des-narrativa <> ?
               then
                   assign c-texto-narrat = string(c-texto-narrat +  chr(10) + chr(10) +
                                           "======== " + texto-follow-up.des-narrativa,"x(15000)"). 
    
               if last(texto-follow-up.nr-trans)
               then
                   leave.
          end.
           
     
       if availa texto-follow-up
       then
           assign pcNarrativa = string(c-texto-narrat,"x(15000)")
                  piSeq-narra = piSeq-narra + 1.
       else 
           assign piSeq-narra     = 1.
                                                                                                                      
      
       if prRowid = rowid(requisicao)   or 
          prRowid = rowid(ordem-compra) or
          prRowid = rowid(cotacao-item) or 
          prRowid = rowid(recebimento)  then 
          assign c-cabec = (if i-nr-requisicao > 0 then c-doc  + ": " + string(i-nr-requisicao) + "   " else "") + 
                            c-ord  + ": " + string(i-numero-ordem,">>>>>9,99").
    
       else assign c-cabec =  c-ped  + ": " + string(i-num-pedido,">>>>9,999").
                                                               
       assign c-header = c-user + ": " + pcSegUsuario + "   "
                       + c-data + ": " + string(today,"99/99/9999") + "   "
                       + c-hora + ": " + string(time,"hh:mm:ss").

    if pcDesNarrativa <> "" then do transaction:
          create texto-follow-up.
          assign texto-follow-up.cod-emitente  = i-cod-emitente
                 texto-follow-up.des-narrativa = trim(c-header + chr(10) + fill(" ",8) + 
                                                 c-cabec  + chr(10) + pcDesNarrativa)
                 texto-follow-up.ind-tip-doc   = piIndTipDoc
                 texto-follow-up.it-codigo     = c-it-codigo
                 texto-follow-up.nr-requisicao = i-nr-requisicao
                 texto-follow-up.num-pedido    = i-num-pedido
                 texto-follow-up.numero-ordem  = i-numero-ordem
                 texto-follow-up.parcela       = i-parcela
                 texto-follow-up.seq-narra     = piSeq-narra
                 texto-follow-up.sequencia     = piSequencia
				 texto-follow-up.Dat-alter         = today
				 texto-follow-up.hra-alter 		   = string(time,"hh:mm:ss")
	    	     texto-follow-up.cod-usuar-alter   = c-seg-usuario.             
      end.                       
      
      assign pcDocumento = string(i-nr-requisicao)
             piOrdem     = i-numero-ordem
             piPedido    = i-num-pedido
             pcUsuario   = pcSegUsuario
             pdaData     = today
             pcHora      = string(time,"hh:mm:ss").

    RETURN "OK":U.           
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint3 DBOProgram 
PROCEDURE setConstraint3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* ----------------------------- PROXIES BO 1.1 ----------------------------- */
     define input parameter p-i-fornec as int no-undo.

     run setConstraintByIndTipDoc (input "1",
                                   input p-i-fornec,
                                   input p-i-fornec).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByIndTipDoc DBOProgram 
PROCEDURE setConstraintByIndTipDoc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
     DEFINE INPUT PARAMETER ptipo-doc AS INTEGER NO-UNDO.
     DEFINE INPUT PARAMETER pifornec-ini AS INTEGER NO-UNDO.
     DEFINE INPUT PARAMETER pifornec-fim AS INTEGER NO-UNDO.

     ASSIGN i-tipo-doc   = ptipo-doc
            i-fornec-ini = pifornec-ini
            i-fornec-fim = pifornec-fim.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFaixaIndTipDoc DBOProgram 
PROCEDURE setConstraintFaixaIndTipDoc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
     DEFINE INPUT PARAMETER pcod-emitente-ini AS INTEGER NO-UNDO.
     DEFINE INPUT PARAMETER pcod-emitente-fim AS INTEGER NO-UNDO.
     DEFINE INPUT PARAMETER ptipo-doc-ini     AS INTEGER NO-UNDO.
     DEFINE INPUT PARAMETER ptipo-doc-fim     AS INTEGER NO-UNDO.

     ASSIGN i-tipo-doc-ini = ptipo-doc-ini
            i-tipo-doc-fim = ptipo-doc-fim
            i-cod-emit-ini = pcod-emitente-ini
            i-cod-emit-fim = pcod-emitente-fim.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFaixaNrRequisicao DBOProgram 
PROCEDURE setConstraintFaixaNrRequisicao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
     DEFINE INPUT PARAMETER pcod-emitente-ini  AS INTEGER NO-UNDO.
     DEFINE INPUT PARAMETER pcod-emitente-fim  AS INTEGER NO-UNDO.
     DEFINE INPUT PARAMETER pnr-requisicao-ini LIKE requisicao.nr-requisicao NO-UNDO.
     DEFINE INPUT PARAMETER pnr-requisicao-fim LIKE requisicao.nr-requisicao NO-UNDO.

     ASSIGN i-nr-requis-ini = pnr-requisicao-ini
            i-nr-requis-fim = pnr-requisicao-fim
            i-cod-emit-ini  = pcod-emitente-ini
            i-cod-emit-fim  = pcod-emitente-fim.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFaixaNumeroOrdem DBOProgram 
PROCEDURE setConstraintFaixaNumeroOrdem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
     DEFINE INPUT PARAMETER pcod-emitente-ini AS INTEGER NO-UNDO.
     DEFINE INPUT PARAMETER pcod-emitente-fim AS INTEGER NO-UNDO.
     DEFINE INPUT PARAMETER pNumero-ordem-ini AS INTEGER NO-UNDO.
     DEFINE INPUT PARAMETER pNumero-ordem-fim AS INTEGER NO-UNDO.

     ASSIGN i-Num-ordem-ini = pNumero-ordem-ini
            i-Num-ordem-fim = pNumero-ordem-fim
            i-cod-emit-ini  = pcod-emitente-ini
            i-cod-emit-fim  = pcod-emitente-fim.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFaixaCodEmitente DBOProgram 
PROCEDURE setConstraintFaixaCodEmitente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
     DEFINE INPUT PARAMETER pcod-emitente-ini AS INTEGER NO-UNDO.
     DEFINE INPUT PARAMETER pcod-emitente-fim AS INTEGER NO-UNDO.

     ASSIGN i-cod-emit-ini = pcod-emitente-ini
            i-cod-emit-fim = pcod-emitente-fim.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFaixaItCodigo DBOProgram 
PROCEDURE setConstraintFaixaItCodigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
     DEFINE INPUT PARAMETER pcod-emitente-ini AS INTEGER NO-UNDO.
     DEFINE INPUT PARAMETER pcod-emitente-fim AS INTEGER NO-UNDO.
     DEFINE INPUT PARAMETER pit-codigo-ini    AS CHARACTER NO-UNDO.
     DEFINE INPUT PARAMETER pit-codigo-fim    AS CHARACTER NO-UNDO.

     ASSIGN c-it-codigo-ini = pit-codigo-ini
            c-it-codigo-fim = pit-codigo-fim
            i-cod-emit-ini  = pcod-emitente-ini
            i-cod-emit-fim  = pcod-emitente-fim.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFaixaNumPedido DBOProgram 
PROCEDURE setConstraintFaixaNumPedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
     DEFINE INPUT PARAMETER pcod-emitente-ini AS INTEGER NO-UNDO.
     DEFINE INPUT PARAMETER pcod-emitente-fim AS INTEGER NO-UNDO.
     DEFINE INPUT PARAMETER pnum-pedido-ini   AS INTEGER NO-UNDO.
     DEFINE INPUT PARAMETER pnum-pedido-fim   AS INTEGER NO-UNDO.

     ASSIGN i-num-pedido-ini = pnum-pedido-ini
            i-num-pedido-fim = pnum-pedido-fim
            i-cod-emit-ini  = pcod-emitente-ini
            i-cod-emit-fim  = pcod-emitente-fim.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFaixaSeqNarra DBOProgram 
PROCEDURE setConstraintFaixaSeqNarra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
     DEFINE INPUT PARAMETER pcod-emitente-ini AS INTEGER NO-UNDO.
     DEFINE INPUT PARAMETER pcod-emitente-fim AS INTEGER NO-UNDO.
     DEFINE INPUT PARAMETER pseq-narra-ini    AS INTEGER NO-UNDO.
     DEFINE INPUT PARAMETER pseq-narra-fim    AS INTEGER NO-UNDO.

     ASSIGN i-seq-narra-ini = pseq-narra-ini
            i-seq-narra-fim = pseq-narra-fim
            i-cod-emit-ini  = pcod-emitente-ini
            i-cod-emit-fim  = pcod-emitente-fim.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Valida temptable RowObject
  Parameters:  recebe o tipo de valida»’o (Create, Delete, Update)
  Notes:
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    /*--- Utilize o par³metro pType para identificar quais as valida»„es a serem
          executadas ---*/
    /*--- Os valores poss­veis para o par³metro s’o: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atrav²s do
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as valida»„es ---*/

    /*--- Verifica ocorr¼ncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaTextoFollowUp DBOProgram 
PROCEDURE buscaTextoFollowUp:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters: 
  Notes:
------------------------------------------------------------------------------*/
	DEFINE INPUT PARAMETER FollowUP_indTipDoc     AS CHARACTER NO-UNDO.
	DEFINE INPUT PARAMETER FollowUP_numero        AS CHARACTER NO-UNDO.
	DEFINE INPUT PARAMETER FollowUP_itCodigo      AS CHARACTER NO-UNDO.
	DEFINE INPUT PARAMETER FollowUP_sequencia      AS CHARACTER NO-UNDO.
	DEFINE INPUT PARAMETER FollowUP_codEmitente   AS CHARACTER NO-UNDO.
	DEFINE INPUT PARAMETER FollowUP_seqCotac  	  AS CHARACTER NO-UNDO.
	DEFINE INPUT PARAMETER cNarrativa  	  AS CHARACTER NO-UNDO.
	DEFINE OUTPUT PARAMETER TABLE FOR ttRegistros.
	DEFINE OUTPUT PARAMETER TABLE FOR ttComentarios.
	DEFINE OUTPUT PARAMETER TABLE FOR rowErrors.
	
    def var   piSeq          like texto-follow-up.sequencia     no-undo.
       
    def var i-cod-emitente  like texto-follow-up.cod-emitente.
    def var c-it-codigo     like texto-follow-up.it-codigo.
    def var i-nr-requisicao like texto-follow-up.nr-requisicao.
    def var i-num-pedido    like texto-follow-up.num-pedido.
    def var i-numero-ordem  like texto-follow-up.numero-ordem.
    def var i-parcela       like texto-follow-up.parcela.
    def var piSeq-narra     like texto-follow-up.seq-narra.
    def var piSequencia     like texto-follow-up.sequencia.
	def var i-numero        as int.
    def var c-origem 		as char.
	assign i-nr-requisicao = 0
		 i-numero-ordem  = 0
		 i-cod-emitente  = 0
		 c-it-codigo     = ""
		 piSequencia     = 0
		 i-num-pedido    = 0
		 i-parcela       = 0.
	
	assign  piSeq = int(FollowUP_sequencia).
		
		
    if int(FollowUP_indTipDoc) = 6 then assign piSeq = 0.
    
      case int(FollowUP_indTipDoc):
          when 1 or when 2 then do:
            find requisicao   where requisicao.nr-requisicao = int(FollowUP_numero) no-lock no-error.
            if avail requisicao then do:
				for each it-requisicao
                   where it-requisicao.nr-requisicao = requisicao.nr-requisicao:
				    IF piSeq = 0 THEN DO:
                        CREATE RowErrors. 
    					ASSIGN ErrorNumber      = 17006
    						   ErrorDescription = "Selecione um item para esta requisi‡Æo".
					    RETURN "NOK".
                    END.
				end.
              if piSeq > 0 then do:
                 find it-requisicao where 
                    it-requisicao.nr-requisicao = requisicao.nr-requisicao and
                    it-requisicao.sequencia = piSeq no-lock no-error.
                 find ordem-compra where ordem-compra.numero-ordem = it-requisicao.numero-ordem no-lock no-error.
              end.
              else 
                 find first ordem-compra where ordem-compra.nr-requisicao = requisicao.nr-requisicao no-lock no-error.     
              
              assign i-nr-requisicao = requisicao.nr-requisicao
                     i-numero-ordem  = ordem-compra.numero-ordem when available ordem-compra
                     i-cod-emitente  = ordem-compra.cod-emitente when available ordem-compra
                     c-it-codigo     = ordem-compra.it-codigo    when available ordem-compra
                     i-num-pedido    = ordem-compra.num-pedido   when available ordem-compra
                     piSequencia     = it-requisicao.sequencia   when available it-requisicao.        
            end.         
          end.
          when 3 then do:
             find requisicao   where requisicao.nr-requisicao = int(FollowUP_numero) no-lock no-error.
             if avail requisicao then do:
              find first ordem-compra where ordem-compra.nr-requisicao = requisicao.nr-requisicao no-lock no-error.
              assign i-nr-requisicao = requisicao.nr-requisicao
                     i-numero-ordem  = ordem-compra.numero-ordem when available ordem-compra
                     i-cod-emitente  = ordem-compra.cod-emitente when available ordem-compra
                     c-it-codigo     = ordem-compra.it-codigo    when available ordem-compra
                     i-num-pedido    = ordem-compra.num-pedido   when available ordem-compra.
             end.        
          end.
          when 4 then do:
              find ordem-compra where ordem-compra.numero-ordem = int(FollowUP_numero) no-lock no-error.    	  
              find first requisicao where requisicao.cod-estabel   = ordem-compra.cod-estabel   and
                                          requisicao.nr-requisicao = ordem-compra.nr-requisicao no-lock no-error.                  
              assign i-nr-requisicao = ordem-compra.nr-requisicao
                     i-numero-ordem  = ordem-compra.numero-ordem when available ordem-compra
                     i-cod-emitente  = ordem-compra.cod-emitente when available ordem-compra
                     c-it-codigo     = ordem-compra.it-codigo    when available ordem-compra
                     i-num-pedido    = ordem-compra.num-pedido   when available ordem-compra.
          end.
          when 5 then do:
              find first cotacao-item where cotacao-item.it-codigo = FollowUP_itCodigo and 
											cotacao-item.cod-emitente = int(FollowUP_codEmitente) and
											cotacao-item.numero-ordem = int(FollowUP_numero) and
											cotacao-item.seq-cotac = int(FollowUP_seqCotac) no-lock no-error.
              if avail cotacao-item then do:
              find first ordem-compra where ordem-compra.numero-ordem = cotacao-item.numero-ordem no-lock no-error.
              find first requisicao where requisicao.cod-estabel   = ordem-compra.cod-estabel   and
                                          requisicao.nr-requisicao = ordem-compra.nr-requisicao no-lock no-error.
    
              assign i-nr-requisicao = ordem-compra.nr-requisicao when available ordem-compra
                     i-numero-ordem  = cotacao-item.numero-ordem
                     i-cod-emitente  = ordem-compra.cod-emitente  when available ordem-compra
                     c-it-codigo     = ordem-compra.it-codigo     when available ordem-compra
                     piSequencia     = cotacao-item.seq-cotac
                     i-num-pedido    = ordem-compra.num-pedido    when available ordem-compra.
             end.        
          end.
          when 6 then do:
              find pedido-compr where pedido-compr.num-pedido = int(FollowUP_numero) no-lock no-error.
              find first ordem-compra where ordem-compra.num-pedido = pedido-compr.num-pedido no-lock no-error.
              find first requisicao where requisicao.cod-estabel   = ordem-compra.cod-estabel   and
                                          requisicao.nr-requisicao = ordem-compra.nr-requisicao no-lock no-error.
              
			  IF AVAIL ordem-compra AND FollowUp_seqCotac = "" THEN DO:
                    
					def var i-cont as int initial 0.
					for each ordem-compra where ordem-compra.num-pedido = pedido-compr.num-pedido no-lock:
						assign i-cont = i-cont + 1.
						assign  FollowUp_seqCotac = String(ordem-compra.numero-ordem).
						
					end.
					
					if i-cont>1 then do:
						create RowErrors. 
						assign  ErrorNumber      = 17006
								ErrorDescription = "Selecione uma Ordem de Compra para este Pedido".
							Return "NOK".
					end.
					
					
              END.
			  else 
			  find first ordem-compra where ordem-compra.num-pedido = pedido-compr.num-pedido AND 
                                               ordem-compra.numero-ordem = INT(FollowUp_seqCotac) no-lock no-error.


              assign i-nr-requisicao = ordem-compra.nr-requisicao when available ordem-compra
                     i-numero-ordem  = ordem-compra.numero-ordem  when available ordem-compra
                     i-cod-emitente  = ordem-compra.cod-emitente  when available ordem-compra
                     c-it-codigo     = ordem-compra.it-codigo     when available ordem-compra
                     i-num-pedido    = pedido-compr.num-pedido    when available pedido-compr.
									 
          end.
       end.
       assign piSeq-narra    = 0.
           
       if i-nr-requisicao = 0 then
	   IF i-numero-ordem <> 0 THEN DO:
           for each texto-follow-up where texto-follow-up.numero-ordem = i-numero-ordem no-lock
                    break by texto-follow-up.nr-trans descending:
               if texto-follow-up.seq-narra > piSeq-narra
               then
                   assign piSeq-narra = texto-follow-up.seq-narra.
               if texto-follow-up.des-narrativa <> ?
               then do:
                   
					if texto-follow-up.ind-tip-doc = 1 or texto-follow-up.ind-tip-doc = 2 or texto-follow-up.ind-tip-doc = 3 then 
						assign i-numero = texto-follow-up.nr-requisicao.
					else if texto-follow-up.ind-tip-doc = 4 then
						assign i-numero = texto-follow-up.numero-ordem.
					else if texto-follow-up.ind-tip-doc = 5 then 
						assign i-numero = texto-follow-up.numero-ordem.
					else if texto-follow-up.ind-tip-doc = 6 then 
						assign i-numero = texto-follow-up.num-pedido.
					
					if texto-follow-up.ind-tip-doc = 1 then 
						assign c-origem = "Requisi‡Æo Estoque".
					else if texto-follow-up.ind-tip-doc = 2 then
						assign c-origem = "Requisi‡Æo Compras".
					else if texto-follow-up.ind-tip-doc = 3 then
						assign c-origem = "Requisi‡Æo Cota‡Æo".
					else if texto-follow-up.ind-tip-doc = 4 then
						assign c-origem = "Ordem".
					else if texto-follow-up.ind-tip-doc = 5 then 
						assign c-origem = "Cota‡Æo".
					else if texto-follow-up.ind-tip-doc = 6 then 
						assign c-origem = "Pedido".
							
					create ttRegistros.
					ASSIGN ttRegistros.origem      = c-origem
						   ttRegistros.numero      = String(i-numero)
						   ttRegistros.responsavel = texto-follow-up.cod-usuar-alter
						   ttRegistros.data        = string(texto-follow-up.dat-alter)
						   ttRegistros.hora        = string(texto-follow-up.hra-alter)
						   ttRegistros.fornecedor  = String(texto-follow-up.cod-emitente)
						   ttRegistros.item 	   = texto-follow-up.it-codigo.
					
					create ttComentarios.
					assign ttComentarios.codigo = texto-follow-up.sequencia
						   ttComentarios.comentario = texto-follow-up.des-narrativa.	 
					   
			   end.
               if last(texto-follow-up.nr-trans)
               then
                   leave.
           end.
	   END.
       ELSE DO:		
			for each texto-follow-up where texto-follow-up.num-pedido = i-num-pedido no-lock
                    break by texto-follow-up.nr-trans descending:
               if texto-follow-up.seq-narra > piSeq-narra
               then
                   assign piSeq-narra = texto-follow-up.seq-narra.
               if texto-follow-up.des-narrativa <> ?
               then do:
                   
					if texto-follow-up.ind-tip-doc = 1 or texto-follow-up.ind-tip-doc = 2 or texto-follow-up.ind-tip-doc = 3 then 
						assign i-numero = texto-follow-up.nr-requisicao.
					else if texto-follow-up.ind-tip-doc = 4 then
						assign i-numero = texto-follow-up.numero-ordem.
					else if texto-follow-up.ind-tip-doc = 5 then 
						assign i-numero = texto-follow-up.numero-ordem.
					else if texto-follow-up.ind-tip-doc = 6 then 
						assign i-numero = texto-follow-up.num-pedido.
					
					if texto-follow-up.ind-tip-doc = 1 then 
						assign c-origem = "Requisi‡Æo Estoque".
					else if texto-follow-up.ind-tip-doc = 2 then
						assign c-origem = "Requisi‡Æo Compras".
					else if texto-follow-up.ind-tip-doc = 3 then
						assign c-origem = "Requisi‡Æo Cota‡Æo".
					else if texto-follow-up.ind-tip-doc = 4 then
						assign c-origem = "Ordem".
					else if texto-follow-up.ind-tip-doc = 5 then 
						assign c-origem = "Cota‡Æo".
					else if texto-follow-up.ind-tip-doc = 6 then 
						assign c-origem = "Pedido".
							
					create ttRegistros.
					ASSIGN ttRegistros.origem      = c-origem
						   ttRegistros.numero      = String(i-numero)
						   ttRegistros.responsavel = texto-follow-up.cod-usuar-alter
						   ttRegistros.data        = string(texto-follow-up.dat-alter)
						   ttRegistros.hora        = string(texto-follow-up.hra-alter)
						   ttRegistros.fornecedor  = String(texto-follow-up.cod-emitente)
						   ttRegistros.item 	   = texto-follow-up.it-codigo.
					
					create ttComentarios.
					assign ttComentarios.codigo = texto-follow-up.sequencia
						   ttComentarios.comentario = texto-follow-up.des-narrativa.	 
					   
			   end.
               if last(texto-follow-up.nr-trans)
               then
                   leave.
           end.
	   END.
       else if piSeq = 0 then 
          for each texto-follow-up where texto-follow-up.nr-requisicao = i-nr-requisicao no-lock
                    break by texto-follow-up.nr-trans descending:
               if texto-follow-up.seq-narra > piSeq-narra
               then
                   assign piSeq-narra = texto-follow-up.seq-narra.
               if texto-follow-up.des-narrativa <> ?
                 then do:
                    
					if texto-follow-up.ind-tip-doc = 1 or texto-follow-up.ind-tip-doc = 2 or texto-follow-up.ind-tip-doc = 3 then 
						assign i-numero = texto-follow-up.nr-requisicao.
					else if texto-follow-up.ind-tip-doc = 4 then
						assign i-numero = texto-follow-up.numero-ordem.
					else if texto-follow-up.ind-tip-doc = 5 then 
						assign i-numero = texto-follow-up.numero-ordem.
					else if texto-follow-up.ind-tip-doc = 6 then 
						assign i-numero = texto-follow-up.num-pedido.
					
					if texto-follow-up.ind-tip-doc = 1 then 
						assign c-origem = "Requisi‡Æo Estoque".
					else if texto-follow-up.ind-tip-doc = 2 then
						assign c-origem = "Requisi‡Æo Compras".
					else if texto-follow-up.ind-tip-doc = 3 then
						assign c-origem = "Requisi‡Æo Cota‡Æo".
					else if texto-follow-up.ind-tip-doc = 4 then
						assign c-origem = "Ordem".
					else if texto-follow-up.ind-tip-doc = 5 then 
						assign c-origem = "Cota‡Æo".
					else if texto-follow-up.ind-tip-doc = 6 then 
						assign c-origem = "Pedido".
							
					create ttRegistros.
					ASSIGN ttRegistros.origem      = c-origem
						   ttRegistros.numero      = String(i-numero)
						   ttRegistros.responsavel = texto-follow-up.cod-usuar-alter
						   ttRegistros.data        = string(texto-follow-up.dat-alter)
						   ttRegistros.hora        = string(texto-follow-up.hra-alter)
						   ttRegistros.fornecedor  = String(texto-follow-up.cod-emitente)
						   ttRegistros.item 	   = texto-follow-up.it-codigo.	  
						   						   
					create ttComentarios.
					assign ttComentarios.codigo = texto-follow-up.sequencia
						   ttComentarios.comentario = texto-follow-up.des-narrativa.	 
						   
				end.
               if last(texto-follow-up.nr-trans)
               then
                   leave.
          end.
       else 
          for each texto-follow-up where texto-follow-up.nr-requisicao = i-nr-requisicao and
               texto-follow-up.sequencia = piSeq no-lock
               break by texto-follow-up.nr-trans descending:
               if texto-follow-up.seq-narra > piSeq-narra
               then
                   assign piSeq-narra = texto-follow-up.seq-narra.
               if texto-follow-up.des-narrativa <> ?
               then do:
                   					
					if texto-follow-up.ind-tip-doc = 1 or texto-follow-up.ind-tip-doc = 2 or texto-follow-up.ind-tip-doc = 3 then 
						assign i-numero = texto-follow-up.nr-requisicao.
					else if texto-follow-up.ind-tip-doc = 4 then
						assign i-numero = texto-follow-up.numero-ordem.
					else if texto-follow-up.ind-tip-doc = 5 then 
						assign i-numero = texto-follow-up.numero-ordem.
					else if texto-follow-up.ind-tip-doc = 6 then 
						assign i-numero = texto-follow-up.num-pedido.
					
					if texto-follow-up.ind-tip-doc = 1 then 
						assign c-origem = "Requisi‡Æo Estoque".
					else if texto-follow-up.ind-tip-doc = 2 then
						assign c-origem = "Requisi‡Æo Compras".
					else if texto-follow-up.ind-tip-doc = 3 then
						assign c-origem = "Requisi‡Æo Cota‡Æo".
					else if texto-follow-up.ind-tip-doc = 4 then
						assign c-origem = "Ordem".
					else if texto-follow-up.ind-tip-doc = 5 then 
						assign c-origem = "Cota‡Æo".
					else if texto-follow-up.ind-tip-doc = 6 then 
						assign c-origem = "Pedido".
							
					create ttRegistros.
					ASSIGN ttRegistros.origem      = c-origem
						   ttRegistros.numero      = String(i-numero)
						   ttRegistros.responsavel = texto-follow-up.cod-usuar-alter
						   ttRegistros.data        = string(texto-follow-up.dat-alter)
						   ttRegistros.hora        = string(texto-follow-up.hra-alter)
						   ttRegistros.fornecedor  = String(texto-follow-up.cod-emitente)
						   ttRegistros.item 	   = texto-follow-up.it-codigo.
					
					create ttComentarios.
					assign ttComentarios.codigo = texto-follow-up.sequencia
						   ttComentarios.comentario = texto-follow-up.des-narrativa.	   
				end.	
               if last(texto-follow-up.nr-trans)
               then
                   leave.
          end.
           
     
       if availa texto-follow-up
       then do:
           assign piSeq-narra = piSeq-narra + 1.
	   end.		
       else do:
           assign piSeq-narra     = 1.
        end.                                                                                                              
      
      if cNarrativa <> "" then do transaction:
          create texto-follow-up.
          assign texto-follow-up.cod-emitente  = i-cod-emitente
                 texto-follow-up.des-narrativa = cNarrativa
                 texto-follow-up.ind-tip-doc   = int(FollowUP_indTipDoc)
                 texto-follow-up.it-codigo     = c-it-codigo
                 texto-follow-up.nr-requisicao = i-nr-requisicao
                 texto-follow-up.num-pedido    = i-num-pedido
                 texto-follow-up.numero-ordem  = i-numero-ordem
                 texto-follow-up.parcela       = i-parcela
                 texto-follow-up.seq-narra     = piSeq-narra
                 texto-follow-up.sequencia     = piSequencia
				 texto-follow-up.Dat-alter         = today
				 texto-follow-up.hra-alter 		   = string(time,"hh:mm:ss")
	    	     texto-follow-up.cod-usuar-alter   = c-seg-usuario.
      end.                       

    RETURN "OK":U.
END PROCEDURE.
