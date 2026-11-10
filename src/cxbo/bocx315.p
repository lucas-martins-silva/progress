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
{include/i-prgvrs.i BOCX315 2.00.00.067 } /*** "010067" 07/10/2024 16:59:56 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOCX315 MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : 
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
&GLOBAL-DEFINE DBOName pedido-drb-item
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName pedido-drb-item
&GLOBAL-DEFINE TableLabel pedido-drb-item
&GLOBAL-DEFINE QueryName qr{&TableName}

/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com
      extens∆o .i ---*/
{cxbo/bocx315.i RowObject}
/*{cxbo/bocx315.i tt-pedido-drb-item}*/
{inbo/boin111a.i tt-item-estrut}
{exp/ex4330.i} /* Definiá∆o da Temp-Table tt-ex4330-retorno */
{cxbo/bocx315.i tt-pedido-temp}  /*Definiá∆o da temp-table para a procedure copyRecordItem */

DEFINE TEMP-TABLE tt-item-doc-est NO-UNDO LIKE item-doc-est
    FIELD r-Rowid AS ROWID.

DEFINE TEMP-TABLE tt-it-nota-fisc NO-UNDO LIKE it-nota-fisc
    FIELD r-Rowid AS ROWID.

DEFINE TEMP-TABLE tt-pedido-drb-item-target NO-UNDO LIKE pedido-drb-item
       FIELD it-codigo-pai  LIKE item.it-codigo
       FIELD nr-seq-ped-pai LIKE wt-it-docto.nr-seq-ped
       FIELD r-pai-rowid    AS ROWID
       FIELD r-rowid        AS ROWID
       FIELD idi-tipo-saldo AS INTEGER /* 1 - nacional ; 2 - internacional */ 
       INDEX codigo IS PRIMARY UNIQUE
       cod-estabel nr-pedido-drb it-codigo it-codigo-pai nr-seq-ped-pai idi-tipo-saldo.

DEFINE TEMP-TABLE tt-pedido-drb-item NO-UNDO LIKE pedido-drb-item
       FIELD l-cons-estr AS LOGICAL 
       FIELD idi-tipo-saldo AS INTEGER /* 1 - nacional ; 2 - internacional */
       FIELD r-rowid     AS ROWID
    INDEX codigo IS PRIMARY UNIQUE cod-estabel nr-pedido-drb it-codigo idi-tipo-saldo.

DEFINE TEMP-TABLE tt-pedido-drb-item-separada NO-UNDO LIKE tt-pedido-drb-item.

DEFINE TEMP-TABLE tt-ex4330-retorno-aux NO-UNDO LIKE pedido-drb-item
    FIELD it-codigo-pai LIKE item.it-codigo
    FIELD nr-seq-ped-pai LIKE wt-it-docto.nr-seq-ped
    FIELD r-pai-rowid AS ROWID
    FIELD r-rowid AS ROWID
    FIELD idi-tipo-saldo AS INTEGER /* 1 - nacional ; 2 - internacional */
    INDEX codigo IS PRIMARY UNIQUE 
    cod-estabel nr-pedido-drb it-codigo it-codigo-pai nr-seq-ped-pai idi-tipo-saldo.
       

DEFINE TEMP-TABLE tt-tab-ocor NO-UNDO LIKE tab-ocor
    FIELD r-Rowid AS ROWID.

DEFINE VARIABLE iNrProcessoIni       AS INTEGER                    NO-UNDO.
DEFINE VARIABLE i-tipo-saldo         AS INTEGER                    NO-UNDO.
DEFINE VARIABLE i-nivel              AS INTEGER                    NO-UNDO.
DEFINE VARIABLE i-tipo-natureza      AS INTEGER                    NO-UNDO.
                                                                   
DEFINE VARIABLE c-pedido             AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE c-estabel            AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE i-item               AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE c-item-ini           AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE c-item-fim           AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE c-cod-estabel        AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE c-pedido-drb         AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE c-it-codigo          AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE c-programa           AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE c-ultimo-programa    AS CHARACTER                  NO-UNDO.
                                                                   
DEFINE VARIABLE l-saldo-insuficiente AS LOGICAL                    NO-UNDO.
DEFINE VARIABLE l-tipo-item          AS LOGICAL                    NO-UNDO.
DEFINE VARIABLE l-drawback-integrado AS LOGICAL                    NO-UNDO.
DEFINE VARIABLE l-itens-nacionais    AS LOGICAL                    NO-UNDO.
                                                                   
DEFINE VARIABLE h-exapi025           AS HANDLE                     NO-UNDO.
DEFINE VARIABLE h-boin111a           AS HANDLE                     NO-UNDO.
DEFINE VARIABLE r-rowidAux           AS ROWID                      NO-UNDO.

DEFINE VARIABLE de-qtde-movto      LIKE pedido-drb-item.quantidade NO-UNDO.
DEFINE VARIABLE de-qtde-movto-nac  LIKE pedido-drb-item.quantidade NO-UNDO.
DEFINE VARIABLE c-cod-serie        LIKE nota-fiscal.serie          NO-UNDO.
DEFINE VARIABLE c-nro-docto        LIKE nota-fiscal.nr-nota-fis    NO-UNDO.
DEFINE VARIABLE c-natur-oper       LIKE docum-est.nat-operacao     NO-UNDO.
DEFINE VARIABLE c-cod-emitente     LIKE docum-est.cod-emitente     NO-UNDO.
DEFINE VARIABLE i-nr-sequencia     LIKE item-doc-est.sequencia     NO-UNDO.
DEFINE VARIABLE c-cod-estab        LIKE nota-fiscal.cod-estabel    NO-UNDO.
DEFINE VARIABLE d-quantidade-item  LIKE item-doc-est.quantidade    NO-UNDO.
DEFINE VARIABLE i-idi-tip-movto    LIKE movto-ato.idi-tip-movto    INITIAL 1 NO-UNDO.


/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o
      manual da query ---*/
{method/dboqry.i}

{cdp/cdcfgdis.i}

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName}     FOR {&TableName}.
DEFINE BUFFER bf-pedido-drb-item FOR pedido-drb-item.
DEFINE BUFFER bf-pedido-drb      FOR pedido-drb.

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
         HEIGHT             = 13
         WIDTH              = 50.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram 
PROCEDURE afterCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FOR FIRST param-imp fields(char-1)
         WHERE param-imp.cod-estabel = RowObject.cod-estabel NO-LOCK:
    END.

    IF AVAIL param-imp AND 
        TRIM(SUBSTRING(param-imp.char-1,228,1)) = "1":U THEN DO: /* "	Tabela Itens do Ato ConcessÛrio - M0000 Folder Drawback*/
        {utp/ut-liter.i "Criaá∆o"}
        RUN pi-cria-historico-criacao-alteracao(INPUT RETURN-VALUE).
    END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterUpdateRecord DBOProgram 
PROCEDURE afterUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FOR FIRST param-imp fields(char-1)
        WHERE param-imp.cod-estabel = rowObject.cod-estabel NO-LOCK:
    END.

    IF AVAIL param-imp AND 
        TRIM(SUBSTRING(param-imp.char-1,228,1)) = "1":U THEN DO: /* "	Tabela Itens do Ato ConcessÛrio - M0000 Folder Drawback*/
            {utp/ut-liter.i "Alteraá∆o"}
            RUN pi-cria-historico-criacao-alteracao(INPUT RETURN-VALUE).
    END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BeforeDeleteRecord DBOProgram 
PROCEDURE BeforeDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     Excluir os registros dos filhos do registro pai corrente
  Parameters:
               
  Notes:
------------------------------------------------------------------------------*/
    FOR EACH movto-ato WHERE
             movto-ato.cod-estabel   = RowObject.cod-estabel AND
             movto-ato.nr-pedido-drb = RowObject.nr-pedido-drb AND
             movto-ato.it-codigo     = RowObject.it-codigo EXCLUSIVE-LOCK:
        DELETE movto-ato.
    END.
        
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE copyRecordItem DBOProgram 
PROCEDURE copyRecordItem :
/*------------------------------------------------------------------------------
  Purpose: Copiar registros existentes na pedido-drb-item alterando apenas
                      o numero pedido drawback e codigo do estabelecimento    
  Parameters: codigo estabelecimento c-estabe(novo/original) c-estabe e numero de pedido
              drawback (novo/Original) c-pedido
  Notes:       
------------------------------------------------------------------------------*/
    def input param c-estabe      as char no-undo.
    def input param c-pedido      as char no-undo.
    def input param c-estabe-novo as char no-undo.
    def input param c-pedido-novo as char no-undo.    

    for each pedido-drb-item no-lock
        where pedido-drb-item.cod-estabel   = c-estabe 
          and pedido-drb-item.nr-pedido-drb = c-pedido use-index ch-item: 
        if avail pedido-drb-item then do:      
            create tt-pedido-temp.
            ASSIGN tt-pedido-temp.cod-estabel               = c-estabe-novo
                   tt-pedido-temp.it-codigo                 = pedido-drb-item.it-codigo
                   tt-pedido-temp.moeda                     = pedido-drb-item.moeda
                   tt-pedido-temp.nr-pedido-drb             = c-pedido-novo
                   tt-pedido-temp.peso-liquido              = pedido-drb-item.peso-liquido
                   tt-pedido-temp.preco-fob                 = pedido-drb-item.preco-fob
                   tt-pedido-temp.quantidade                = pedido-drb-item.quantidade
                   tt-pedido-temp.idi-reg                   = pedido-drb-item.idi-reg
                   tt-pedido-temp.log-import-cobert-cambial = YES
                   tt-pedido-temp.dec-1                     = pedido-drb-item.dec-1
                   tt-pedido-temp.num-seq-item-import       = pedido-drb-item.num-seq-item-import
                   tt-pedido-temp.val-preco-fob-sem-cobert  = pedido-drb-item.val-preco-fob-sem-cobert
                   tt-pedido-temp.val-perc-comis-agent      = pedido-drb-item.val-perc-comis-agent.

            IF l-drawback-integrado THEN
                ASSIGN tt-pedido-temp.num-seq-item-nac          = pedido-drb-item.num-seq-item-nac       
                       tt-pedido-temp.cdn-moed-nac              = pedido-drb-item.cdn-moed-nac
                       tt-pedido-temp.qtd-item-nac              = pedido-drb-item.qtd-item-nac
                       tt-pedido-temp.val-fob-nac               = pedido-drb-item.val-fob-nac
                       tt-pedido-temp.val-unit-nac              = pedido-drb-item.val-unit-nac
                       tt-pedido-temp.log-import-cobert-cambial = pedido-drb-item.log-import-cobert-cambial.

            ASSIGN l-itens-nacionais = pedido-drb-item.num-seq-item-nac > 0 AND pedido-drb-item.qtd-item-nac > 0.
        end.
    end.
    
    FOR EACH tt-pedido-temp:
        RUN openqueryStatic IN THIS-PROCEDURE (INPUT "Main":U).
        RUN goToKey IN THIS-PROCEDURE (INPUT tt-pedido-temp.cod-estabel,
                                       INPUT tt-pedido-temp.nr-pedido-drb,
                                       INPUT tt-pedido-temp.it-codigo).                            
        
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN setRecord      IN THIS-PROCEDURE (INPUT TABLE tt-pedido-temp).
            RUN validateRecord IN THIS-PROCEDURE (INPUT "Create":U).

            IF RETURN-VALUE <> "NOK":U THEN DO:
                RUN createRecord IN THIS-PROCEDURE.
                RUN getRowErrors IN THIS-PROCEDURE (OUTPUT TABLE RowErrors).
            END.

            IF CAN-FIND(FIRST RowErrors 
                        WHERE RowErrors.ErrorType <> "INTERNAL":U
                         AND rowErrors.ErrorSubType = "ERROR":U) THEN
                RETURN "NOK":U.
            
            DELETE tt-pedido-temp.
        END.
    END.

    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE countNumPedidoDrbItem DBOProgram 
PROCEDURE countNumPedidoDrbItem :
/*------------------------------------------------------------------------------
  Purpose:     Retornar a quantidade de registros de Itens de Entrada do Ato Concess¢rio
  Parameters:  pc-cod-estabel (entrada): c¢digo do estabelecimento (character)
               p-nr-pedido-drb(entrada): pedido de drawback (character)
               pi-num-reg      (sa°da): quantidade de registros de item de entrada (integer)
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pc-cod-estabel  LIKE pedido-drb-item.cod-estabel   NO-UNDO.
    DEFINE INPUT  PARAMETER p-nr-pedido-drb LIKE pedido-drb-item.nr-pedido-drb NO-UNDO.
    DEFINE OUTPUT PARAMETER pi-num-reg      AS   INTEGER                       NO-UNDO.

    ASSIGN pi-num-reg = 0.
    FOR EACH pedido-drb-item NO-LOCK
        WHERE pedido-drb-item.cod-estabel = pc-cod-estabel
          AND pedido-drb-item.nr-pedido-drb = p-nr-pedido-drb
          AND pedido-drb-item.idi-reg = 1:
        ASSIGN pi-num-reg = pi-num-reg + 1.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE countNumPedidoDrbItemExp DBOProgram 
PROCEDURE countNumPedidoDrbItemExp :
/*------------------------------------------------------------------------------
  Purpose:     Retornar a quantidade de registros de Itens de Sa°da do Ato Concess¢rio
  Parameters:  pc-cod-estabel (entrada): c¢digo do estabelecimento (character)
               p-nr-pedido-drb(entrada): pedido de drawback (character)
               pi-num-reg      (sa°da): quantidade de registros de item de entrada (integer)
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pc-cod-estabel  LIKE pedido-drb-item.cod-estabel   NO-UNDO.
    DEFINE INPUT  PARAMETER p-nr-pedido-drb LIKE pedido-drb-item.nr-pedido-drb NO-UNDO.
    DEFINE OUTPUT PARAMETER pi-num-reg      AS   INTEGER                       NO-UNDO. 

    ASSIGN pi-num-reg = 0.
    FOR EACH pedido-drb-item NO-LOCK 
       WHERE pedido-drb-item.cod-estabel   = pc-cod-estabel 
         AND pedido-drb-item.nr-pedido-drb = p-nr-pedido-drb 
         AND pedido-drb-item.idi-reg = 2:
        ASSIGN pi-num-reg = pi-num-reg + 1.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createRecordItem DBOProgram 
PROCEDURE createRecordItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param c-estabe as char no-undo.
    def input param c-pedido as char no-undo.
    def input param table for tt-pedido-drb-item.
    
    for each tt-pedido-drb-item 
        where tt-pedido-drb-item.cod-estabel   = c-estabe 
          and tt-pedido-drb-item.nr-pedido-drb = c-pedido:
          
        create pedido-drb-item.
        assign pedido-drb-item.cod-estabel   = c-estabe
               pedido-drb-item.it-codigo     = tt-pedido-drb-item.it-codigo
               pedido-drb-item.moeda         = tt-pedido-drb-item.moeda
               pedido-drb-item.nr-pedido-drb = c-pedido
               pedido-drb-item.peso-liquido  = tt-pedido-drb-item.peso-liquido
               pedido-drb-item.preco-fob     = tt-pedido-drb-item.preco-fob
               pedido-drb-item.quantidade    = tt-pedido-drb-item.quantidade.
    end.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE eliminaItem DBOProgram 
PROCEDURE eliminaItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param p-estabel like pedido-drb.cod-estabel   no-undo.
    def input param p-pedido  like pedido-drb.nr-pedido-drb no-undo.
    
    for each bf{&TableName} 
        where bf{&TableName}.cod-estabel   = p-estabel 
          and bf{&TableName}.nr-pedido-drb = p-pedido exclusive-lock:
        delete bf{&TableName}.
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
               retorna status do processo
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
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "nr-pedido-drb":U THEN ASSIGN pFieldValue = RowObject.nr-pedido-drb.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.


    CASE pFieldName:
        WHEN "quantidade":U THEN ASSIGN pFieldValue = RowObject.quantidade.
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "peso-liquido":U THEN ASSIGN pFieldValue = RowObject.peso-liquido.
        WHEN "preco-fob":U THEN ASSIGN pFieldValue = RowObject.preco-fob.
        WHEN "val-fob-nac":U THEN ASSIGN pFieldValue = RowObject.val-fob-nac.
        WHEN "val-unit-nac":U THEN ASSIGN pFieldValue = RowObject.val-unit-nac.
        WHEN "qtd-sdo-item":U THEN ASSIGN pFieldValue = RowObject.qtd-sdo-item.
        WHEN "qtd-sdo-item-nac":U THEN ASSIGN pFieldValue = RowObject.qtd-sdo-item-nac.
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "moeda":U THEN ASSIGN pFieldValue = RowObject.moeda.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice CH-ITEM
  Parameters:
               retorna valor dos campos do °ndice CH-ITEM
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE pedido-drb-item.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-pedido-drb LIKE pedido-drb-item.nr-pedido-drb NO-UNDO.
    DEFINE OUTPUT PARAMETER pit-codigo LIKE pedido-drb-item.it-codigo NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pcod-estabel = RowObject.cod-estabel.
    ASSIGN pnr-pedido-drb = RowObject.nr-pedido-drb.
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
               retorna status do processo
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
               retorna status do processo
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToItem DBOProgram 
PROCEDURE goToItem :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro 

  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE pedido-drb-item.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pnr-pedido-drb LIKE pedido-drb-item.nr-pedido-drb NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo LIKE pedido-drb-item.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-reg AS INTEGER NO-UNDO.

    FOR FIRST bfpedido-drb-item NO-LOCK WHERE
              bfpedido-drb-item.cod-estabel   = pcod-estabel   AND
              bfpedido-drb-item.nr-pedido-drb = pnr-pedido-drb AND
              bfpedido-drb-item.it-codigo     = pit-codigo     AND       
              bfpedido-drb-item.idi-reg       = pcod-reg:
    END.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfpedido-drb-item THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfpedido-drb-item)).

    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice CH-ITEM
  Parameters:
               recebe valor dos campos do °ndice CH-ITEM
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE pedido-drb-item.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pnr-pedido-drb LIKE pedido-drb-item.nr-pedido-drb NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo LIKE pedido-drb-item.it-codigo NO-UNDO.

    FOR FIRST bfpedido-drb-item NO-LOCK WHERE
              bfpedido-drb-item.cod-estabel   = pcod-estabel   AND
              bfpedido-drb-item.nr-pedido-drb = pnr-pedido-drb AND
              bfpedido-drb-item.it-codigo     = pit-codigo
              use-index ch-item:
    END.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfpedido-drb-item THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfpedido-drb-item)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToPedido DBOProgram 
PROCEDURE linkToPedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param h-proc as handle no-undo.
    
    RUN GetKey in h-proc (output c-estabel,
                          output c-pedido).
   
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkTott-pedido-drb DBOProgram 
PROCEDURE linkTott-pedido-drb :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM ph-ordem AS HANDLE NO-UNDO.
    
    RUN getKey IN ph-ordem (OUTPUT c-estabel,
                            OUTPUT c-pedido).
                            
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE maintenanceItemDrb DBOProgram 
PROCEDURE maintenanceItemDrb :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pTipo         AS   CHARACTER                     NO-UNDO.
    DEFINE INPUT PARAMETER pCodEstabel   LIKE pedido-drb-item.cod-estabel   NO-UNDO.
    DEFINE INPUT PARAMETER pNrPedidoDRB  LIKE pedido-drb-item.nr-pedido-drb NO-UNDO.
    DEFINE INPUT PARAMETER pItCodigo     LIKE pedido-drb-item.it-codigo     NO-UNDO.
    DEFINE INPUT PARAMETER pValPeso      LIKE pedido-drb-item.peso-liquido  NO-UNDO.
    DEFINE INPUT PARAMETER pQuantidade   LIKE pedido-drb-item.quantidade    NO-UNDO.
    DEFINE INPUT PARAMETER pMoeda        LIKE pedido-drb-item.moeda         NO-UNDO.
    DEFINE INPUT PARAMETER pValor        LIKE pedido-drb-item.preco-fob     NO-UNDO.
    DEFINE INPUT PARAMETER pValUnit      AS DECIMAL                         NO-UNDO.
    DEFINE INPUT PARAMETER pNrRe         AS INTEGER                         NO-UNDO.
    DEFINE INPUT PARAMETER pCodReg       AS INTEGER                         NO-UNDO.
    DEFINE INPUT PARAMETER pNacImp       AS INTEGER                         NO-UNDO.
    
  /*             
    DEFINE INPUT PARAMETER pVlrScobCamb  AS DECIMAL                         NO-UNDO.
    DEFINE INPUT PARAMETER pVlrPercAgent AS DECIMAL                         NO-UNDO.  */
 
    DEFINE VARIABLE i-seq AS INTEGER NO-UNDO.    
        DEFINE VARIABLE d-quantidade AS DECIMAL NO-UNDO.
        
    RUN emptyRowObject IN THIS-PROCEDURE.
    RUN emptyRowErrors IN THIS-PROCEDURE.
    
    IF pTipo = "CREATE":U THEN DO: 

        RUN goToItem IN THIS-PROCEDURE (INPUT pCodEstabel,
                                        INPUT pNrPedidoDRB,
                                        INPUT pItCodigo,
                                        INPUT pCodReg).
                                        
        IF RETURN-VALUE = "OK":U THEN DO:
            
           RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfpedido-drb-item)).
           IF RETURN-VALUE = "NOK":U THEN
              RETURN "NOK":U. 
           
           ASSIGN RowObject.peso-liquido = RowObject.peso-liquido + pValPeso.
            
           IF pNacImp = 1 THEN DO:
              ASSIGN RowObject.quantidade   = RowObject.quantidade   + pQuantidade
                     RowObject.preco-fob    = RowObject.preco-fob    + pValor.       
           END.          
           ELSE DO:
              ASSIGN RowObject.qtd-item-nac      = pQuantidade
                     RowObject.val-fob-nac       = pValor. 
           END.               
            
            RUN updateRecord IN THIS-PROCEDURE.
        END.
        
        ELSE DO:
                                
            CREATE RowObject.
            ASSIGN RowObject.cod-estabel     = pCodEstabel                
                   RowObject.nr-pedido-drb   = pNrPedidoDRB                
                   RowObject.it-codigo       = pItCodigo                
                   RowObject.peso-liquido    = pValPeso
                   RowObject.moeda           = pMoeda.                    
                   
            IF pNacImp = 1 THEN                       
               ASSIGN RowObject.quantidade      = pQuantidade                
                      RowObject.preco-fob       = pValor.
                      
            ELSE 
               ASSIGN RowObject.qtd-item-nac      = pQuantidade
                      RowObject.val-fob-nac       = pValor  
                      RowObject.val-unit-nac      = pValUnit.

            RUN pi-seq-item IN THIS-PROCEDURE (INPUT pCodEstabel,
                                               INPUT pNrPedidoDRB,
                                               INPUT pCodReg,
                                               INPUT pNacImp,
                                               OUTPUT i-seq).   
                   
            ASSIGN RowObject.num-seq-item-import = i-seq          
                   /* RowObject.val-perc-comis-agent    = d-val-perc-comis-agent */ 
                   RowObject.idi-reg = pCodReg.
                                    
            FIND FIRST reg-export 
                 WHERE reg-export.nr-re-ems = pNrRe NO-LOCK NO-ERROR.
    
            IF AVAILABLE reg-export THEN
            DO:                              
               ASSIGN RowObject.val-preco-fob-sem-cobert = reg-export.val-sem-cobert-cambio.
            END.             
                   
            RUN setRecord      IN THIS-PROCEDURE (INPUT TABLE RowObject).
            RUN validateRecord IN THIS-PROCEDURE (INPUT "Create":U).

            IF RETURN-VALUE <> "NOK":U THEN DO:
                RUN createRecord IN THIS-PROCEDURE.
                RUN getRowErrors IN THIS-PROCEDURE (OUTPUT TABLE RowErrors).
            END.
        END.
    END.

    IF pTipo = "DELETE":U THEN DO:
        
        RUN goToKey IN THIS-PROCEDURE (INPUT pCodEstabel,
                                       INPUT pNrPedidoDRB,
                                       INPUT pItCodigo).                            
        
                IF RETURN-VALUE = "OK":U THEN DO:
                        ASSIGN d-quantidade = RowObject.qtd-item-nac.
                        
                        IF pNacImp = 1 THEN DO:
                                IF d-quantidade = 0 THEN
                                        RUN deleteRecord IN THIS-PROCEDURE.
                                ELSE DO:
                                        ASSIGN RowObject.quantidade = 0
                                                   RowObject.preco-fob  = 0.
                                        RUN UpdateRecord IN THIS-PROCEDURE.
                                END.
                        END.
                        ELSE IF pNacImp = 2 THEN DO:
                                IF RowObject.quantidade = 0 THEN
                                        RUN deleteRecord IN THIS-PROCEDURE.
                                ELSE DO:
                                        ASSIGN RowObject.qtd-item-nac = 0
                                               RowObject.val-fob-nac  = 0.
                                        RUN UpdateRecord IN THIS-PROCEDURE.
                                END.
                        END.
                END.
    END.
    
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN
        RETURN "NOK":U.
        
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryItem DBOProgram 
PROCEDURE openQueryItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH Pedido-drb-item NO-LOCK where 
                                     Pedido-drb-item.cod-estabel   = c-estabel  and
                                     Pedido-drb-item.nr-pedido-drb = c-pedido   AND
                                     Pedido-drb-item.it-codigo    >= c-item-ini AND
                                     Pedido-drb-item.it-codigo    <= c-item-fim
                                     use-index ch-item
                                     INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryItembyPedidoDrb DBOProgram 
PROCEDURE openQueryItembyPedidoDrb :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH Pedido-drb-item NO-LOCK WHERE 
                                     Pedido-drb-item.cod-estabel   = c-estabel AND
                                     Pedido-drb-item.nr-pedido-drb = c-pedido AND
                                     Pedido-drb-item.quantidade > 0 AND
                                     Pedido-drb-item.idi-reg = 1
                                     INDEXED-REPOSITION.    

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryItembyPedidoDrb2 DBOProgram 
PROCEDURE openQueryItembyPedidoDrb2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    OPEN QUERY {&QueryName} FOR EACH Pedido-drb-item NO-LOCK WHERE 
                                     Pedido-drb-item.cod-estabel   = c-estabel AND
                                     Pedido-drb-item.nr-pedido-drb = c-pedido AND                                     
                                     Pedido-drb-item.idi-reg = 1
                                     INDEXED-REPOSITION.    

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryItembyRowidPedidoDrb DBOProgram 
PROCEDURE openQueryItembyRowidPedidoDrb :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    OPEN QUERY {&QueryName} FOR EACH pedido-drb-item NO-LOCK
                                WHERE pedido-drb-item.cod-estabel = c-estabel
                                AND   pedido-drb-item.nr-pedido-drb = c-pedido
                                AND   pedido-drb-item.idi-reg = 1
                              BY pedido-drb-item.it-codigo
                                INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryItemExpbyRowidPedidoDrb DBOProgram 
PROCEDURE openQueryItemExpbyRowidPedidoDrb :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH Pedido-drb-item NO-LOCK where 
                                     Pedido-drb-item.cod-estabel   = c-estabel and
                                     Pedido-drb-item.nr-pedido-drb = c-pedido AND
                                     Pedido-drb-item.idi-reg = 2
                                     INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryItemNfebyPedidoDrb DBOProgram 
PROCEDURE openQueryItemNfebyPedidoDrb :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH Pedido-drb-item NO-LOCK where 
                                     Pedido-drb-item.cod-estabel   = c-estabel and
                                     Pedido-drb-item.nr-pedido-drb = c-pedido AND
                                     Pedido-drb-item.idi-reg = 1 AND
                                     Pedido-drb-item.qtd-item-nac > 0
                                     INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryItemNfebyPedidoDrb2 DBOProgram 
PROCEDURE openQueryItemNfebyPedidoDrb2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH Pedido-drb-item NO-LOCK where 
                                     Pedido-drb-item.cod-estabel   = c-estabel and
                                     Pedido-drb-item.nr-pedido-drb = c-pedido AND
                                     Pedido-drb-item.idi-reg = 1 AND
                                     pedido-drb-item.quantidade > 0
                                     INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryItemNfsbyPedidoDrb DBOProgram 
PROCEDURE openQueryItemNfsbyPedidoDrb :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH Pedido-drb-item NO-LOCK where 
                                     Pedido-drb-item.cod-estabel   = c-estabel and
                                     Pedido-drb-item.nr-pedido-drb = c-pedido AND
                                     Pedido-drb-item.idi-reg = 2 AND
                                     Pedido-drb-item.qtd-item-nac > 0
                                     INDEXED-REPOSITION.

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
    OPEN QUERY {&QueryName} FOR EACH pedido-drb-item NO-LOCK use-index ch-item INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-CalculateQuantity DBOProgram 
PROCEDURE pi-CalculateQuantity :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT        PARAMETER TABLE FOR tt-pedido-drb-item-target.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-pedido-drb-item.

DEFINE VARIABLE de-quantidade-aux LIKE wt-it-docto.quantidade[1] NO-UNDO.

  FOR EACH tt-pedido-drb-item EXCLUSIVE-LOCK:

        ASSIGN tt-pedido-drb-item.l-cons-estr = IF CAN-FIND(FIRST tt-item-estrut
                                                             WHERE tt-item-estrut.it-codigo = tt-pedido-drb-item.it-codigo)
                                                       THEN YES
                                                       ELSE NO.
        FIND FIRST tt-pedido-drb-item-target OF tt-pedido-drb-item NO-LOCK NO-ERROR.
        IF AVAIL tt-pedido-drb-item-target THEN DO:

            ASSIGN de-quantidade-aux = 0.
            FOR EACH tt-pedido-drb-item-target
               WHERE tt-pedido-drb-item-target.cod-estabel   = tt-pedido-drb-item.cod-estabel
                 AND tt-pedido-drb-item-target.nr-pedido-drb = tt-pedido-drb-item.nr-pedido-drb
                 AND tt-pedido-drb-item-target.it-codigo     = tt-pedido-drb-item.it-codigo NO-LOCK
                BY tt-pedido-drb-item-target.it-codigo
                BY tt-pedido-drb-item-target.nr-seq-ped-pai
                BY tt-pedido-drb-item-target.quantidade:

                ASSIGN de-quantidade-aux = de-quantidade-aux + tt-pedido-drb-item-target.quantidade.

            END.
            
            FIND FIRST tt-pedido-drb-item-target OF tt-pedido-drb-item NO-LOCK NO-ERROR.
            IF AVAIL tt-pedido-drb-item-target THEN DO:
                FIND FIRST pedido-drb-item OF tt-pedido-drb-item NO-LOCK NO-ERROR.
                
                
                
                
                IF i-tipo-natureza = 1 OR i-tipo-natureza = 2 THEN DO: /* Nacional */
                    IF AVAIL pedido-drb-item AND pedido-drb-item.qtd-sdo-item-nac = tt-pedido-drb-item.qtd-sdo-item-nac THEN
                            ASSIGN tt-pedido-drb-item.qtd-sdo-item-nac = tt-pedido-drb-item.qtd-sdo-item-nac - de-quantidade-aux.
                END.
                ELSE DO: /* Internacional */
                    &if "{&bf_dis_versao_ems}" >= "2.06" &then
                        IF AVAIL pedido-drb-item AND pedido-drb-item.qtd-sdo-item = tt-pedido-drb-item.qtd-sdo-item THEN
                            ASSIGN tt-pedido-drb-item.qtd-sdo-item = tt-pedido-drb-item.qtd-sdo-item - 
                                                                     de-quantidade-aux.
                    &else
                        IF AVAIL pedido-drb-item AND dec(SUBSTR(pedido-drb-item.char-1,1,15)) = dec(SUBSTR(tt-pedido-drb-item.char-1,1,15)) THEN
                            ASSIGN OVERLAY(tt-pedido-drb-item.char-1,1,15) = STRING (dec(SUBSTR(tt-pedido-drb-item.char-1,1,15)) - 
                                                                             de-quantidade-aux).
                    &endif
                END.             
            END.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tab-ocor DBOProgram 
PROCEDURE pi-cria-tab-ocor :
/*------------------------------------------------------------------------------
  Purpose: Criaá∆o da Tab-ocor relacionada ao item de Drawback.
  Parameters:  <none>
  Notes: Parametros a serem considerados.
  
  Campos Tab-Ocor
  
  int-2 = (Item de Entrada ou Item de Sa°da)
  1 - Item Entrada
  2 - Item Sa°da
  
  log-1 = (Item Nacional ou Item Internacional)
  YES - Item Internacional
  NO  - Item Nacional
  
------------------------------------------------------------------------------*/
DEFINE VARIABLE i-contaregistro LIKE tab-ocor.cod-ocor NO-UNDO.

IF AVAIL RowObject THEN DO:

    ASSIGN i-contaregistro = 0.
    
    IF RowObject.idi-reg = 1 THEN DO:

        FIND LAST tab-ocor NO-LOCK
            WHERE tab-ocor.cod-tab = 720 NO-ERROR.
        IF  AVAIL tab-ocor
        THEN ASSIGN i-contaregistro = tab-ocor.cod-ocor + 1.
        ELSE ASSIGN i-contaregistro = 1.
       
        /*Criaá∆o item entrada*/
        IF NOT CAN-FIND(FIRST tab-ocor
                        WHERE tab-ocor.cod-tab = 720
                        AND   TRIM(SUBSTRING(tab-ocor.char-1,1,5))   = c-cod-serie
                        AND   TRIM(SUBSTRING(tab-ocor.char-1,6,16))  = c-nro-docto
                        AND   TRIM(SUBSTRING(tab-ocor.char-1,22,6))  = c-natur-oper
                        AND   TRIM(SUBSTRING(tab-ocor.char-1,28,12)) = STRING(c-cod-emitente)
                        AND   tab-ocor.int-1                         = i-nr-sequencia) THEN DO:
            CREATE tab-ocor.
            ASSIGN tab-ocor.cod-tab  = 720
                   tab-ocor.cod-ocor = i-contaregistro
                   tab-ocor.dec-1    = d-quantidade-item.
               
        END.
        ELSE DO:
            FOR FIRST tab-ocor EXCLUSIVE-LOCK
                WHERE tab-ocor.cod-tab = 720
                AND   TRIM(SUBSTRING(tab-ocor.char-1,1,5))   = c-cod-serie
                AND   TRIM(SUBSTRING(tab-ocor.char-1,6,16))  = c-nro-docto
                AND   TRIM(SUBSTRING(tab-ocor.char-1,22,6))  = c-natur-oper
                AND   TRIM(SUBSTRING(tab-ocor.char-1,28,12)) = STRING(c-cod-emitente)
                AND   tab-ocor.int-1                         = i-nr-sequencia : END.

                ASSIGN tab-ocor.dec-1 = tab-ocor.dec-1 + d-quantidade-item.
        END.
        
        ASSIGN OVERLAY(tab-ocor.char-1,1,5)   = c-cod-serie   
               OVERLAY(tab-ocor.char-1,6,16)  = c-nro-docto   
               OVERLAY(tab-ocor.char-1,22,6)  = c-natur-oper  
               OVERLAY(tab-ocor.char-1,28,12) = STRING(c-cod-emitente)
               tab-ocor.int-1                 = i-nr-sequencia
               tab-ocor.int-2                 = RowObject.idi-reg
               tab-ocor.log-1                 = l-tipo-item
               OVERLAY(tab-ocor.char-1,40,20) = RowObject.nr-pedido-drb
               OVERLAY(tab-ocor.char-1,60,16) = RowObject.it-codigo
               OVERLAY(tab-ocor.char-1,76,5)  = RowObject.cod-estabel.


    END.
    ELSE DO:
        FIND LAST tab-ocor NO-LOCK
            WHERE tab-ocor.cod-tab = 721 NO-ERROR.
        IF  AVAIL tab-ocor
        THEN ASSIGN i-contaregistro = tab-ocor.cod-ocor + 1.
        ELSE ASSIGN i-contaregistro = 1.

        /*Criaá∆o item Sa°da*/
        IF NOT CAN-FIND(FIRST tab-ocor
                            WHERE tab-ocor.cod-tab = 721
                            AND   TRIM(SUBSTRING(tab-ocor.char-1,1,5))   = c-cod-serie
                            AND   TRIM(SUBSTRING(tab-ocor.char-1,6,16))  = c-nro-docto
                            AND   TRIM(SUBSTRING(tab-ocor.char-1,22,5))  = c-cod-estab
                            AND   tab-ocor.int-1                         = i-nr-sequencia
                            AND   TRIM(SUBSTRING(tab-ocor.char-1,27,16)) = RowObject.it-codigo) THEN DO:
            CREATE tab-ocor.
            ASSIGN tab-ocor.cod-tab  = 721
                   tab-ocor.cod-ocor = i-contaregistro
                   tab-ocor.dec-1    = d-quantidade-item.
        END.
        ELSE DO:
            FOR FIRST tab-ocor EXCLUSIVE-LOCK
                WHERE tab-ocor.cod-tab = 721
                AND   TRIM(SUBSTRING(tab-ocor.char-1,1,5))   = c-cod-serie
                AND   TRIM(SUBSTRING(tab-ocor.char-1,6,16))  = c-nro-docto
                AND   TRIM(SUBSTRING(tab-ocor.char-1,22,5))  = c-cod-estab
                AND   tab-ocor.int-1                         = i-nr-sequencia 
                AND   TRIM(SUBSTRING(tab-ocor.char-1,27,16)) = RowObject.it-codigo: END.

                ASSIGN tab-ocor.dec-1 = tab-ocor.dec-1 + d-quantidade-item.
        END.

        ASSIGN OVERLAY(tab-ocor.char-1,1,5)   = c-cod-serie   
               OVERLAY(tab-ocor.char-1,6,16)  = c-nro-docto
               OVERLAY(tab-ocor.char-1,22,5)  = c-cod-estab
               tab-ocor.int-1                 = i-nr-sequencia
               OVERLAY(tab-ocor.char-1,27,16) = RowObject.it-codigo
               OVERLAY(tab-ocor.char-1,43,20) = RowObject.nr-pedido-drb
               tab-ocor.int-2                 = RowObject.idi-reg
               tab-ocor.log-1                 = l-tipo-item.


    END.
END.                   

RETURN "OK":U.      
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-elimina-tab-ocor DBOProgram 
PROCEDURE pi-elimina-tab-ocor :
/*------------------------------------------------------------------------------
  Purpose: Eliminaá∆o da Tab-ocor relacionada ao item de Drawback.
  Parameters:  <none>
  Notes: 
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pi-idi-reg       AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-estabel   AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pc-nr-pedido-drb AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pc-serie         AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pc-nro-docto     AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pc-nat-operacao  AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pi-cod-emitente  AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER pi-seq-docto     AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER pc-it-codigo     AS CHARACTER NO-UNDO.

    IF pi-idi-reg = 1 THEN
        FOR EACH tab-ocor EXCLUSIVE-LOCK
                WHERE tab-ocor.cod-tab = 720 
                AND   trim(SUBSTRING(tab-ocor.char-1,76,5))   = pc-cod-estabel                    
                AND   trim(SUBSTRING(tab-ocor.char-1,40,20))  = pc-nr-pedido-drb                  
                AND   trim(SUBSTRING(tab-ocor.char-1,1,5))    = pc-serie                          
                AND   trim(SUBSTRING(tab-ocor.char-1,6,16))   = pc-nro-docto                      
                AND   trim(SUBSTRING(tab-ocor.char-1,22,6))   = pc-nat-operacao                   
                AND   trim(SUBSTRING(tab-ocor.char-1,28,12))  = STRING(pi-cod-emitente)           
                AND   tab-ocor.int-1                          = pi-seq-docto:                     
                                                                                                
                DELETE tab-ocor.
        END.
    ELSE
        FOR FIRST tab-ocor EXCLUSIVE-LOCK
            WHERE tab-ocor.cod-tab = 721
              AND TRIM(SUBSTRING(tab-ocor.char-1,1,5))   = pc-serie
              AND TRIM(SUBSTRING(tab-ocor.char-1,6,16))  = pc-nro-docto
              AND TRIM(SUBSTRING(tab-ocor.char-1,22,5))  = pc-cod-estabel
              AND tab-ocor.int-1                         = pi-seq-docto 
              AND TRIM(SUBSTRING(tab-ocor.char-1,27,16)) = pc-it-codigo: 
           
           DELETE tab-ocor.
        END.

RETURN "OK":U.      
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-geraTTSaldoAto DBOProgram 
PROCEDURE pi-geraTTSaldoAto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pc-cod-refer  AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pd-quantidade AS DECIMAL NO-UNDO.
    DEFINE INPUT PARAMETER pc-it-codigo  AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER nr-seq-ped    AS INTEGER.
    DEFINE INPUT PARAMETER l-cons-estr   AS LOGICAL.
    DEFINE INPUT PARAMETER TABLE FOR tt-pedido-drb-item-target.
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-pedido-drb-item.
    

    IF NOT VALID-HANDLE(h-boin111a) THEN
        RUN inbo/boin111a.p PERSISTENT SET h-boin111a.

    FIND FIRST param-global NO-LOCK NO-ERROR.
    
    RUN setConstraint2 IN h-boin111a (INPUT STRING(pc-cod-refer),
                                      INPUT STRING(pd-quantidade),
                                      INPUT "19",
                                      INPUT STRING(TODAY),
                                      INPUT ">>>>>,>>9.9999", 
                                      INPUT STRING(pc-it-codigo)).
    
    RUN montaEstrutura IN h-boin111a.
    RUN openQuery      IN h-boin111a (INPUT 1).
    RUN getTTEstrutura IN h-boin111a (OUTPUT TABLE tt-item-estrut).
    
    IF l-cons-estr THEN DO:
    

            FOR EACH pedido-drb-item 
                WHERE (pedido-drb-item.qtd-sdo-item-nac > 0 
                       OR 
                       &if "{&bf_dis_versao_ems}" >= "2.06" &then
                           pedido-drb-item.qtd-sdo-item > 0
                       &else
                           dec(SUBSTR(pedido-drb-item.char-1,1,15)) > 0
                       &endif
                       )
                AND   CAN-FIND(FIRST tt-item-estrut WHERE tt-item-estrut.it-codigo = pedido-drb-item.it-codigo) NO-LOCK:

             FIND FIRST pedido-drb 
                 WHERE pedido-drb.cod-estabel        = pedido-drb-item.cod-estabel 
                   AND pedido-drb.nr-pedido-drb      = pedido-drb-item.nr-pedido-drb 
                   AND pedido-drb.data-validade-ato >= TODAY NO-LOCK NO-ERROR.
                
                /*Valida se existe o pedido de drawback de Suspens∆o e se o mesmo possui item
                cadastrado na aba de Itens Sa°da com o c¢digo do item pai enviado pelo programa
                de faturamento*/
                IF  AVAIL pedido-drb 
                AND pedido-drb.modalidade = 1 
                AND CAN-FIND(FIRST pedido-drb-item NO-LOCK
                             WHERE pedido-drb-item.it-codigo   = pc-it-codigo /* item pai */
                             AND   pedido-drb-item.idi-reg     = 2 /*item sa°da*/) THEN DO:
                    FIND tt-pedido-drb-item 
                        WHERE tt-pedido-drb-item.cod-estabel   = pedido-drb-item.cod-estabel 
                          AND tt-pedido-drb-item.nr-pedido-drb = pedido-drb-item.nr-pedido-drb 
                          AND tt-pedido-drb-item.it-codigo     = pedido-drb-item.it-codigo NO-ERROR. 
    
                    IF NOT AVAIL tt-pedido-drb-item THEN DO:
                        CREATE tt-pedido-drb-item.
                        BUFFER-COPY pedido-drb-item TO tt-pedido-drb-item.
                        ASSIGN tt-pedido-drb-item.r-rowid = ROWID(pedido-drb-item)
                               tt-pedido-drb-item.l-cons-estr = YES.
                               
                        /* verificar se j† n∆o tem este registro no target */
                        FOR FIRST tt-pedido-drb-item-target NO-LOCK
                            WHERE tt-pedido-drb-item-target.cod-estabel   = tt-pedido-drb-item.cod-estabel  
                            AND   tt-pedido-drb-item-target.it-codigo     = tt-pedido-drb-item.it-codigo    
                            AND   tt-pedido-drb-item-target.nr-pedido-drb = tt-pedido-drb-item.nr-pedido-drb:
                            ASSIGN tt-pedido-drb-item.qtd-sdo-item     = tt-pedido-drb-item.qtd-sdo-item     - tt-pedido-drb-item-target.qtd-sdo-item    
                                   tt-pedido-drb-item.val-sdo-item     = tt-pedido-drb-item.val-sdo-item     - tt-pedido-drb-item-target.val-sdo-item    
                                   tt-pedido-drb-item.qtd-sdo-item-nac = tt-pedido-drb-item.qtd-sdo-item-nac - tt-pedido-drb-item-target.qtd-sdo-item-nac
                                   tt-pedido-drb-item.val-sdo-item-nac = tt-pedido-drb-item.val-sdo-item-nac - tt-pedido-drb-item-target.val-sdo-item-nac.
                        END.
                        /* fim - verificar se j† n∆o tem este registro no target */
                        IF param-global.modulo-en THEN DO:                            
                            ASSIGN tt-pedido-drb-item.quantidade = 0.
                            /*
                                Soma todas as quantidades dos itens iguais dentros da tt-item-estrut.
                                O mesmo item pode fazer parte de mais de uma estrutura ou subestrutura e por isso suas quantidades devem ser somadas.                                
                            */
                            FOR EACH tt-item-estrut NO-LOCK
                                WHERE tt-item-estrut.it-codigo = tt-pedido-drb-item.it-codigo:
                                ASSIGN tt-pedido-drb-item.quantidade = tt-pedido-drb-item.quantidade + tt-item-estrut.quant-usada.
                            END.
                        END.
                        ELSE
                            ASSIGN tt-pedido-drb-item.quantidade = 0.
                    END.
                END.
            END.  
    END.
    ELSE DO:    
        FOR EACH pedido-drb-item NO-LOCK
            WHERE pedido-drb-item.it-codigo   = pc-it-codigo /* item pai */
            AND   pedido-drb-item.idi-reg     = 2 /*item sa°da*/,
            EACH bf-pedido-drb-item
                WHERE bf-pedido-drb-item.nr-pedido-drb = pedido-drb-item.nr-pedido-drb
                AND   bf-pedido-drb-item.cod-estabel   = pedido-drb-item.cod-estabel
                AND   bf-pedido-drb-item.idi-reg       = 1 /*item relacionado de entrada*/ 
            :
        
            FIND FIRST pedido-drb WHERE pedido-drb.cod-estabel        = bf-pedido-drb-item.cod-estabel   AND
                                        pedido-drb.nr-pedido-drb      = bf-pedido-drb-item.nr-pedido-drb AND
                                        pedido-drb.data-validade-ato >= TODAY                         NO-LOCK NO-ERROR.

            IF  AVAIL pedido-drb AND 
                pedido-drb.modalidade = 1 THEN DO:                


                FIND FIRST tt-pedido-drb-item WHERE tt-pedido-drb-item.cod-estabel   = bf-pedido-drb-item.cod-estabel
                                              AND   tt-pedido-drb-item.nr-pedido-drb = bf-pedido-drb-item.nr-pedido-drb
                                              AND   tt-pedido-drb-item.it-codigo     = bf-pedido-drb-item.it-codigo NO-LOCK NO-ERROR.  
                IF NOT AVAIL tt-pedido-drb-item THEN DO:


                    IF bf-pedido-drb-item.qtd-sdo-item-nac <= 0 AND bf-pedido-drb-item.qtd-sdo-item <= 0 THEN
                        ASSIGN l-saldo-insuficiente = TRUE.
                    ELSE
                        ASSIGN l-saldo-insuficiente = FALSE.


                    IF l-saldo-insuficiente = FALSE THEN DO:
                        CREATE tt-pedido-drb-item.
                        BUFFER-COPY bf-pedido-drb-item TO tt-pedido-drb-item.
                        ASSIGN tt-pedido-drb-item.r-rowid = ROWID(bf-pedido-drb-item).
                        
                        /* verificar se j† n∆o tem este registro no target */
                        FOR EACH tt-pedido-drb-item-target NO-LOCK
                            WHERE tt-pedido-drb-item-target.cod-estabel   = tt-pedido-drb-item.cod-estabel  
                            AND   tt-pedido-drb-item-target.it-codigo     = tt-pedido-drb-item.it-codigo    
                            AND   tt-pedido-drb-item-target.nr-pedido-drb = tt-pedido-drb-item.nr-pedido-drb
                            AND   tt-pedido-drb-item-target.idi-tipo-saldo = tt-pedido-drb-item.idi-tipo-saldo:

                            ASSIGN tt-pedido-drb-item.quantidade       = tt-pedido-drb-item.quantidade - tt-pedido-drb-item-target.quantidade
                                   tt-pedido-drb-item.qtd-sdo-item     = tt-pedido-drb-item.qtd-sdo-item     - tt-pedido-drb-item-target.quantidade    
                                   /*tt-pedido-drb-item.val-sdo-item     = tt-pedido-drb-item.val-sdo-item     - tt-pedido-drb-item-target.val-sdo-item    */
                                   tt-pedido-drb-item.qtd-sdo-item-nac = tt-pedido-drb-item.qtd-sdo-item-nac - tt-pedido-drb-item-target.quantidade
                                   /*tt-pedido-drb-item.val-sdo-item-nac = tt-pedido-drb-item.val-sdo-item-nac - tt-pedido-drb-item-target.val-sdo-item-nac*/ .
                        END.
                        /* fim - verificar se j† n∆o tem este registro no target */
                        IF param-global.modulo-en THEN DO:
                            ASSIGN tt-pedido-drb-item.quantidade = 0.
                             /*
                                Soma todas as quantidades dos itens iguais dentros da tt-item-estrut.
                                O mesmo item pode fazer parte de mais de uma estrutura ou subestrutura e por isso suas quantidades devem ser somadas.                                
                            */
                            FOR EACH tt-item-estrut NO-LOCK
                                WHERE tt-item-estrut.it-codigo = bf-pedido-drb-item.it-codigo:
                                ASSIGN tt-pedido-drb-item.quantidade = tt-pedido-drb-item.quantidade + tt-item-estrut.quant-usada.
                            END.
                        END.
                        ELSE
                            ASSIGN tt-pedido-drb-item.quantidade = 0.
                    END.    
                END.                
            END.              
        END.
    END.

    /*separar mercado nacional e internacional*/
    RUN pi-separaTTSaldoAto IN THIS-PROCEDURE(INPUT TABLE tt-pedido-drb-item,
                                              OUTPUT TABLE tt-pedido-drb-item). 

    IF VALID-HANDLE(h-boin111a) THEN DO:
        DELETE PROCEDURE h-boin111a.
        ASSIGN h-boin111a = ?.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-juntaTTSaldoAto DBOProgram 
PROCEDURE pi-juntaTTSaldoAto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM TABLE FOR tt-ex4330-retorno-aux.
    DEFINE OUTPUT PARAM TABLE FOR tt-ex4330-retorno.

    EMPTY TEMP-TABLE tt-ex4330-retorno.

    FOR EACH tt-ex4330-retorno-aux:
        
        FIND FIRST tt-ex4330-retorno NO-LOCK
            WHERE tt-ex4330-retorno.cod-estabel   = tt-ex4330-retorno-aux.cod-estabel
            AND   tt-ex4330-retorno.nr-pedido-drb = tt-ex4330-retorno-aux.nr-pedido-drb
            AND   tt-ex4330-retorno.it-codigo     = tt-ex4330-retorno-aux.it-codigo 
            AND   tt-ex4330-retorno.nr-seq-ped-pai= tt-ex4330-retorno-aux.nr-seq-ped-pai NO-ERROR.

        IF NOT AVAIL tt-ex4330-retorno THEN DO:
            CREATE tt-ex4330-retorno.
            BUFFER-COPY tt-ex4330-retorno-aux EXCEPT tt-ex4330-retorno-aux.idi-tipo-saldo tt-ex4330-retorno-aux.quantidade tt-ex4330-retorno-aux.qtd-item-nac
                TO tt-ex4330-retorno.

            IF tt-ex4330-retorno-aux.idi-tipo-saldo = 1 THEN
                ASSIGN tt-ex4330-retorno.qtd-item-nac = tt-ex4330-retorno-aux.quantidade.
                       
            ELSE
                ASSIGN tt-ex4330-retorno.quantidade = tt-ex4330-retorno-aux.quantidade.
        END.
        ELSE DO:
            /* assign */
            IF tt-ex4330-retorno-aux.idi-tipo-saldo = 1 THEN
                ASSIGN tt-ex4330-retorno.val-sdo-item-nac = tt-ex4330-retorno-aux.val-sdo-item-nac
                       tt-ex4330-retorno.qtd-sdo-item-nac = tt-ex4330-retorno-aux.qtd-sdo-item-nac
                       tt-ex4330-retorno.qtd-item-nac     = tt-ex4330-retorno-aux.quantidade.
                       
            ELSE
                ASSIGN tt-ex4330-retorno.val-sdo-item = tt-ex4330-retorno-aux.val-sdo-item
                       tt-ex4330-retorno.qtd-sdo-item = tt-ex4330-retorno-aux.qtd-sdo-item
                       tt-ex4330-retorno.quantidade   = tt-ex4330-retorno-aux.quantidade.
        END.

    END.

RETURN "OK":U.      
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-itens-vinculados DBOProgram 
PROCEDURE pi-retorna-itens-vinculados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM p-nr-pedido-drb LIKE pedido-drb.nr-pedido-drb NO-UNDO.
DEF INPUT PARAM p-cod-estab     LIKE pedido-drb.cod-estabel   NO-UNDO.
DEF INPUT PARAM p-l-tipo-item   AS LOGICAL                    NO-UNDO.
DEF INPUT PARAM p-idi-reg       AS INT                        NO-UNDO.
DEF OUTPUT PARAM TABLE FOR tt-item-doc-est.

EMPTY TEMP-TABLE tt-item-doc-est.

FOR EACH tab-ocor NO-LOCK
    WHERE tab-ocor.cod-tab = 720 
    AND   TRIM(SUBSTRING(tab-ocor.char-1,76,5))  = p-cod-estab
    AND   TRIM(SUBSTRING(tab-ocor.char-1,40,20)) = p-nr-pedido-drb
    AND   tab-ocor.log-1 = p-l-tipo-item
    AND   tab-ocor.int-2 = p-idi-reg:

    FOR FIRST item-doc-est NO-LOCK
        WHERE item-doc-est.serie-docto  = TRIM(SUBSTRING(tab-ocor.char-1,1,5))  
        AND   item-doc-est.nro-docto    = TRIM(SUBSTRING(tab-ocor.char-1,6,16)) 
        AND   item-doc-est.nat-operacao = TRIM(SUBSTRING(tab-ocor.char-1,22,6))
        AND   item-doc-est.cod-emitente = INT(TRIM(SUBSTRING(tab-ocor.char-1,28,12)))
        AND   item-doc-est.sequencia    = tab-ocor.int-1:

        IF NOT CAN-FIND(FIRST tt-item-doc-est
                        WHERE tt-item-doc-est.serie-docto  = TRIM(SUBSTRING(tab-ocor.char-1,1,5))  
                        AND   tt-item-doc-est.nro-docto    = TRIM(SUBSTRING(tab-ocor.char-1,6,16)) 
                        AND   tt-item-doc-est.nat-operacao = TRIM(SUBSTRING(tab-ocor.char-1,22,6))
                        AND   tt-item-doc-est.cod-emitente = INT(TRIM(SUBSTRING(tab-ocor.char-1,28,12)))
                        AND   tt-item-doc-est.sequencia    = tab-ocor.int-1) THEN DO:
            CREATE tt-item-doc-est.
            BUFFER-COPY item-doc-est EXCEPT item-doc-est.quantidade TO tt-item-doc-est.
            ASSIGN tt-item-doc-est.quantidade = tab-ocor.dec-1.    
        END.                
    END.
END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-itens-vinculados-nfs DBOProgram 
PROCEDURE pi-retorna-itens-vinculados-nfs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM p-nr-pedido-drb LIKE pedido-drb.nr-pedido-drb NO-UNDO.
DEF INPUT PARAM p-cod-estab     LIKE pedido-drb.cod-estabel   NO-UNDO.
DEF INPUT PARAM p-l-tipo-item   AS LOGICAL                    NO-UNDO.
DEF INPUT PARAM p-idi-reg       AS INT                        NO-UNDO.
DEF OUTPUT PARAM TABLE FOR tt-it-nota-fisc.

EMPTY TEMP-TABLE tt-it-nota-fisc.

FOR EACH tab-ocor NO-LOCK
    WHERE tab-ocor.cod-tab = 721
    AND   TRIM(SUBSTRING(tab-ocor.char-1,22,5))  = p-cod-estab
    AND   TRIM(SUBSTRING(tab-ocor.char-1,43,20)) = p-nr-pedido-drb
    AND   tab-ocor.log-1 = p-l-tipo-item
    AND   tab-ocor.int-2 = p-idi-reg:

    FOR FIRST it-nota-fisc NO-LOCK
        WHERE it-nota-fisc.serie          = TRIM(SUBSTRING(tab-ocor.char-1,1,5))  
        AND   it-nota-fisc.nr-nota-fis    = TRIM(SUBSTRING(tab-ocor.char-1,6,16)) 
        AND   it-nota-fisc.cod-estabel    = TRIM(SUBSTRING(tab-ocor.char-1,22,5)) 
        AND   it-nota-fisc.nr-seq-fat     = tab-ocor.int-1:

        IF NOT CAN-FIND(FIRST tt-it-nota-fisc
                        WHERE tt-it-nota-fisc.serie          = TRIM(SUBSTRING(tab-ocor.char-1,1,5))  
                        AND   tt-it-nota-fisc.nr-nota-fis    = TRIM(SUBSTRING(tab-ocor.char-1,6,16)) 
                        AND   tt-it-nota-fisc.cod-estabel    = TRIM(SUBSTRING(tab-ocor.char-1,22,5)) 
                        AND   tt-it-nota-fisc.nr-seq-fat     = tab-ocor.int-1) THEN DO:
            CREATE tt-it-nota-fisc.
            BUFFER-COPY it-nota-fisc TO tt-it-nota-fisc.
            ASSIGN tt-it-nota-fisc.qt-faturada[1] = tab-ocor.dec-1.    
        END.                
    END.
END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-separaTTSaldoAto DBOProgram 
PROCEDURE pi-separaTTSaldoAto:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Esta procedure faz a separaá∆o da temp-table recebida por parÉmetro. Ele cria novos registros na temp-table de retorno, separando a quantidade e saldo do mercado nacional e internacional      
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM TABLE FOR tt-pedido-drb-item.
    DEFINE OUTPUT PARAM TABLE FOR tt-pedido-drb-item-separada.


    EMPTY TEMP-TABLE tt-pedido-drb-item-separada.
    FOR EACH tt-pedido-drb-item NO-LOCK:
        /*
            Verifica se existe saldo internacional e nacional.
            Se existir ent∆o cria dois registros na tt-pedido-drb-item-separada
            Se existir apenas um ent∆o gera o registro conforme o saldo, Internacional e Nacional
        */
        IF tt-pedido-drb-item.qtd-sdo-item-nac > 0 AND
           tt-pedido-drb-item.qtd-sdo-item     > 0  THEN DO:

            /* internacional */
            CREATE tt-pedido-drb-item-separada.
            BUFFER-COPY tt-pedido-drb-item EXCEPT tt-pedido-drb-item.val-sdo-item-nac tt-pedido-drb-item.qtd-sdo-item-nac 
                TO tt-pedido-drb-item-separada.
            ASSIGN tt-pedido-drb-item-separada.idi-tipo-saldo   = 2
                   tt-pedido-drb-item-separada.val-sdo-item-nac = 0
                   tt-pedido-drb-item-separada.qtd-sdo-item-nac = 0.

            /* nacional */
            CREATE tt-pedido-drb-item-separada.
            BUFFER-COPY tt-pedido-drb-item EXCEPT tt-pedido-drb-item.val-sdo-item tt-pedido-drb-item.qtd-sdo-item
                TO tt-pedido-drb-item-separada.
            ASSIGN tt-pedido-drb-item-separada.idi-tipo-saldo = 1 
                   tt-pedido-drb-item-separada.val-sdo-item   = 0 
                   tt-pedido-drb-item-separada.qtd-sdo-item   = 0 .
        END.
        ELSE DO:
            CREATE tt-pedido-drb-item-separada.
            BUFFER-COPY tt-pedido-drb-item TO tt-pedido-drb-item-separada
            ASSIGN tt-pedido-drb-item-separada.idi-tipo-saldo = 1 WHEN tt-pedido-drb-item.qtd-sdo-item-nac > 0
                   tt-pedido-drb-item-separada.idi-tipo-saldo = 2 WHEN tt-pedido-drb-item.qtd-sdo-item > 0.
        END.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seq-item DBOProgram 
PROCEDURE pi-seq-item :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
     
   DEFINE INPUT  PARAMETER pcod-estabel AS CHARACTER NO-UNDO. 
   DEFINE INPUT  PARAMETER pnr-pedido-drb AS CHARACTER NO-UNDO. 
   DEFINE INPUT  PARAMETER pcod-reg AS INTEGER NO-UNDO. 
   DEFINE INPUT  PARAMETER pNacImp AS INTEGER NO-UNDO. 
   DEFINE OUTPUT PARAMETER pSequencia AS INTEGER NO-UNDO.
            
   ASSIGN pSequencia = 1.

   IF pNacImp = 1 THEN DO:
        FOR EACH bfpedido-drb-item NO-LOCK
          WHERE bfpedido-drb-item.cod-estabel   = pcod-estabel   AND
                bfpedido-drb-item.nr-pedido-drb = pnr-pedido-drb AND       
                bfpedido-drb-item.idi-reg       = pcod-reg       AND
                bfpedido-drb-item.num-seq-item-import > 0
                by bfpedido-drb-item.num-seq-item-import DESC: 
          ASSIGN pSequencia = bfpedido-drb-item.num-seq-item-import + 1.
          LEAVE.
        END.
   END.
   ELSE DO:
       FOR EACH bfpedido-drb-item NO-LOCK
          WHERE bfpedido-drb-item.cod-estabel   = pcod-estabel   AND
                bfpedido-drb-item.nr-pedido-drb = pnr-pedido-drb AND       
                bfpedido-drb-item.idi-reg       = pcod-reg       AND
                bfpedido-drb-item.num-seq-item-nac > 0
                by bfpedido-drb-item.num-seq-item-nac DESC: 
          ASSIGN pSequencia = bfpedido-drb-item.num-seq-item-nac + 1.
          LEAVE.
       END.

   END.
            

   RETURN "OK":U. 
     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seta-documento DBOProgram 
PROCEDURE pi-seta-documento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-cod-serie     LIKE nota-fiscal.serie         NO-UNDO.
DEFINE INPUT PARAMETER p-nro-docto     LIKE nota-fiscal.nr-nota-fis   NO-UNDO.
DEFINE INPUT PARAMETER p-natur-oper    LIKE docum-est.nat-operacao    NO-UNDO.
DEFINE INPUT PARAMETER p-cod-emitente  LIKE docum-est.cod-emitente    NO-UNDO.
DEFINE INPUT PARAMETER p-nr-sequencia  LIKE item-doc-est.sequencia    NO-UNDO.
DEFINE INPUT PARAMETER p-cod-estab     LIKE nota-fiscal.cod-estabel   NO-UNDO.
DEFINE INPUT PARAMETER p-quantidade    LIKE item-doc-est.quantidade   NO-UNDO.

ASSIGN c-cod-serie      = p-cod-serie   
       c-nro-docto      = p-nro-docto   
       c-natur-oper     = p-natur-oper  
       c-cod-emitente   = p-cod-emitente
       i-nr-sequencia   = p-nr-sequencia
       c-cod-estab      = p-cod-estab       
       d-quantidade-item = p-quantidade.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seta-tipo-item DBOProgram 
PROCEDURE pi-seta-tipo-item :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM p-tipo-item AS LOGICAL NO-UNDO.

ASSIGN l-tipo-item = p-tipo-item.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-tipo-natureza DBOProgram 
PROCEDURE pi-tipo-natureza :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pi-tipo-natureza AS INTEGER NO-UNDO.
    
    ASSIGN i-tipo-natureza = pi-tipo-natureza.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validateQuantity DBOProgram 
PROCEDURE pi-validateQuantity :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Valida quantidade a ser baixada no programa ex4331       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pde-qtde-usada   AS   DECIMAL  NO-UNDO.
DEFINE INPUT  PARAMETER TABLE FOR tt-pedido-drb-item.
DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

DEFINE VARIABLE c-nr-ato-concessorio AS CHARACTER  NO-UNDO.
DEFINE VARIABLE de-qtde-usada-aux    AS DECIMAL    NO-UNDO.

    RUN emptyRowErrors IN THIS-PROCEDURE.

    FIND FIRST tt-pedido-drb-item
        WHERE tt-pedido-drb-item.cod-estabel   = c-cod-estabel
          AND tt-pedido-drb-item.nr-pedido-drb = c-pedido-drb 
          AND tt-pedido-drb-item.it-codigo     = c-it-codigo 
          AND tt-pedido-drb-item.idi-tipo-saldo = i-tipo-saldo NO-LOCK NO-ERROR.

    IF AVAIL tt-pedido-drb-item THEN DO:
        FIND pedido-drb 
            WHERE pedido-drb.cod-estabel   = tt-pedido-drb-item.cod-estabel
              AND pedido-drb.nr-pedido-drb = tt-pedido-drb-item.nr-pedido-drb NO-LOCK NO-ERROR.

        IF AVAIL pedido-drb THEN
            ASSIGN c-nr-ato-concessorio = pedido-drb.nr-ato-concessorio.
        
        
        ASSIGN de-qtde-usada-aux = tt-pedido-drb-item.qtd-sdo-item-nac.
        &IF "{&bf_dis_versao_ems}" >= "2.06" &THEN
            ASSIGN de-qtde-usada-aux = de-qtde-usada-aux + tt-pedido-drb-item.qtd-sdo-item.
        &ELSE
            ASSIGN de-qtde-usada-aux = de-qtde-usada-aux + DEC(SUBSTRING(tt-pedido-drb-item.char-1,1,15)).
        &ENDIF

        IF pde-qtde-usada > de-qtde-usada-aux THEN DO:
            {method/svc/errors/inserr.i
                        &ErrorNumber="30716"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR" 
                        &ErrorParameters="c-nr-ato-concessorio + '~~~~' + String(tt-pedido-drb-item.it-codigo)"}
                            
        END.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validateQuantityTotal DBOProgram 
PROCEDURE pi-validateQuantityTotal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Valida quantidade a ser baixada total no programa ex4331       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pde-qtde-usada   AS   DECIMAL  NO-UNDO.
DEFINE INPUT  PARAMETER TABLE FOR tt-pedido-drb-item.
DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

DEFINE VARIABLE c-nr-ato-concessorio AS CHARACTER  NO-UNDO.
DEFINE VARIABLE de-qtde-usada-aux    AS DECIMAL    NO-UNDO.

    RUN emptyRowErrors IN THIS-PROCEDURE.

    FOR EACH tt-pedido-drb-item
        WHERE tt-pedido-drb-item.cod-estabel   = c-cod-estabel
          AND tt-pedido-drb-item.nr-pedido-drb = c-pedido-drb 
          AND tt-pedido-drb-item.it-codigo     = c-it-codigo NO-LOCK:        

        FIND pedido-drb 
              WHERE pedido-drb.cod-estabel   = tt-pedido-drb-item.cod-estabel
              AND pedido-drb.nr-pedido-drb = tt-pedido-drb-item.nr-pedido-drb NO-LOCK NO-ERROR.

        IF AVAIL pedido-drb THEN
            ASSIGN c-nr-ato-concessorio = pedido-drb.nr-ato-concessorio.
                   
        ASSIGN de-qtde-usada-aux = de-qtde-usada-aux + tt-pedido-drb-item.qtd-sdo-item-nac.
        &IF "{&bf_dis_versao_ems}" >= "2.06" &THEN
            ASSIGN de-qtde-usada-aux = de-qtde-usada-aux + tt-pedido-drb-item.qtd-sdo-item.
        &ELSE
            ASSIGN de-qtde-usada-aux = de-qtde-usada-aux + DEC(SUBSTRING(tt-pedido-drb-item.char-1,1,15)).
        &ENDIF     
    END.

    IF pde-qtde-usada > de-qtde-usada-aux THEN DO:
        {method/svc/errors/inserr.i
                    &ErrorNumber="30716"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR" 
                    &ErrorParameters="c-nr-ato-concessorio + '~~~~' + String(c-it-codigo)"}
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSetaTipodrawback DBOProgram 
PROCEDURE piSetaTipodrawback :
/*------------------------------------------------------------------------------
  Purpose:     Seta a informaá∆o se o Pedido de Drawback Ç Integrado 
               ou n∆o para realizar a c¢pia dos itens
  Parameters:
               Recebe a informaá∆o "Drawback Integrado" do Pedido de Drawback 
               que est† sendo feita c¢pia
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pl-drawback-integrado AS LOGICAL NO-UNDO.

    ASSIGN l-drawback-integrado = pl-drawback-integrado.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retorna-clafisc DBOProgram 
PROCEDURE retorna-clafisc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER p-it-codigo LIKE ITEM.it-codigo NO-UNDO.
DEF OUTPUT PARAMETER p-class-fisc AS CHAR NO-UNDO.

FIND FIRST ITEM WHERE item.it-codigo = p-it-codigo NO-LOCK NO-ERROR.

ASSIGN p-class-fisc = item.class-fiscal.


RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retorna-desc DBOProgram 
PROCEDURE retorna-desc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER p-it-codigo LIKE ITEM.it-codigo NO-UNDO.
DEF OUTPUT PARAMETER p-desc AS CHAR NO-UNDO.

FIND FIRST ITEM WHERE item.it-codigo = p-it-codigo NO-LOCK NO-ERROR.

ASSIGN p-desc = String((ITEM.descricao-1 + ITEM.descricao-2),"x(36)").

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retorna-movto-ato DBOProgram 
PROCEDURE retorna-movto-ato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT  PARAMETER p-cod-estabel     LIKE pedido-drb-item.cod-estabel      NO-UNDO.
DEF INPUT  PARAMETER p-it-codigo       LIKE pedido-drb-item.it-codigo        NO-UNDO. 
DEF INPUT  PARAMETER p-nr-pedido-drb   LIKE pedido-drb-item.nr-pedido-drb    NO-UNDO.
DEF INPUT  PARAMETER i-tip-item-movto  AS INTEGER                            NO-UNDO.
DEF INPUT  PARAMETER l-valor           AS LOGICAL                            NO-UNDO.
DEF OUTPUT PARAMETER d-resultado       AS DECIMAL                            NO-UNDO.

DEF VAR de-tot-valor-conv AS DECIMAL NO-UNDO.
DEF VAR de-tot-quant      AS DECIMAL NO-UNDO.
DEF VAR de-tot-valor      AS DECIMAL NO-UNDO.

FIND bf-pedido-drb-item WHERE bf-pedido-drb-item.cod-estabel   = p-cod-estabel 
                     AND   bf-pedido-drb-item.it-codigo     = p-it-codigo 
                     AND   bf-pedido-drb-item.nr-pedido-drb = p-nr-pedido-drb 
                     NO-LOCK NO-ERROR.

IF AVAIL bf-pedido-drb-item then do:
     For each movto-ato where
              movto-ato.cod-estabel    = p-cod-estabel and
              movto-ato.nr-pedido-drb  = p-nr-pedido-drb and
              movto-ato.it-codigo      = p-it-codigo and
              movto-ato.idi-tip-movto  = 1 /*entrada*/  
              and movto-ato.idi-tip-item-movto = i-tip-item-movto 
              no-lock:

        /*caso a moeda seja estrangeira chama o programa de convers∆o de valor*/
         IF movto-ato.mo-codigo <> 0 
            AND (movto-ato.mo-codigo <> bf-pedido-drb-item.moeda) THEN DO:
            
            IF movto-ato.dat-decla-import = ? THEN
                run cdp/cd0812.p (input movto-ato.mo-codigo,
                                  input bf-pedido-drb-item.moeda, 
                                  input movto-ato.val-movto-ato-me,
                                  input movto-ato.dat-movto,
                                  output de-tot-valor-conv).

            ELSE
                run cdp/cd0812.p (input movto-ato.mo-codigo,
                                  input bf-pedido-drb-item.moeda, 
                                  input movto-ato.val-movto-ato-me,
                                  input movto-ato.dat-decla-import,
                                  output de-tot-valor-conv).
         END.
         ELSE
            ASSIGN de-tot-valor-conv = movto-ato.val-movto-ato-orig.

            assign de-tot-quant = de-tot-quant + movto-ato.val-quant-movto-ato
                   de-tot-valor = de-tot-valor + de-tot-valor-conv.
     END.
     IF l-valor THEN
         IF i-tip-item-movto = 1 THEN
             ASSIGN d-resultado = bf-pedido-drb-item.preco-fob - de-tot-valor.
         ELSE
             ASSIGN d-resultado = bf-pedido-drb-item.val-fob-nac - de-tot-valor.
     ELSE 
         IF i-tip-item-movto = 1 THEN
             ASSIGN d-resultado = bf-pedido-drb-item.quantidade - de-tot-quant.
         ELSE
             ASSIGN d-resultado = bf-pedido-drb-item.qtd-item-nac - de-tot-quant.
End.
ELSE
    ASSIGN d-resultado = 0.   

IF d-resultado < 0 THEN ASSIGN d-resultado = 0.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retorna-movto-ato-exp DBOProgram 
PROCEDURE retorna-movto-ato-exp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT  PARAMETER p-cod-estabel     LIKE pedido-drb-item.cod-estabel      NO-UNDO.
DEF INPUT  PARAMETER p-it-codigo       LIKE pedido-drb-item.it-codigo        NO-UNDO. 
DEF INPUT  PARAMETER p-nr-pedido-drb   LIKE pedido-drb-item.nr-pedido-drb    NO-UNDO.
DEF INPUT  PARAMETER i-tip-item-movto  AS INTEGER                            NO-UNDO.
DEF INPUT  PARAMETER l-valor           AS LOGICAL                            NO-UNDO.
DEF OUTPUT PARAMETER d-resultado       AS DECIMAL                            NO-UNDO.

DEF VAR de-tot-valor-conv AS DECIMAL NO-UNDO.
DEF VAR de-tot-quant      AS DECIMAL NO-UNDO.
DEF VAR de-tot-valor      AS DECIMAL NO-UNDO.

FIND bf-pedido-drb-item WHERE bf-pedido-drb-item.cod-estabel   = p-cod-estabel 
                     AND   bf-pedido-drb-item.it-codigo     = p-it-codigo 
                     AND   bf-pedido-drb-item.nr-pedido-drb = p-nr-pedido-drb 
                     NO-LOCK NO-ERROR.

IF AVAIL bf-pedido-drb-item then do:
     For each movto-ato where
              movto-ato.cod-estabel    = p-cod-estabel and
              movto-ato.nr-pedido-drb  = p-nr-pedido-drb and
              movto-ato.it-codigo-re   = p-it-codigo and
              movto-ato.idi-tip-movto  = 2 /*baixa*/  
              and movto-ato.idi-tip-item-movto = i-tip-item-movto 
              no-lock:

        /*caso a moeda seja estrangeira chama o programa de convers∆o de valor*/
         IF movto-ato.mo-codigo <> 0 
            AND (movto-ato.mo-codigo <> bf-pedido-drb-item.moeda) THEN DO:
            
            IF movto-ato.dat-decla-import = ? THEN
                run cdp/cd0812.p (input movto-ato.mo-codigo,
                                  input bf-pedido-drb-item.moeda, 
                                  input movto-ato.val-movto-ato-me,
                                  input movto-ato.dat-movto,
                                  output de-tot-valor-conv).

            ELSE
                run cdp/cd0812.p (input movto-ato.mo-codigo,
                                  input bf-pedido-drb-item.moeda, 
                                  input movto-ato.val-movto-ato-me,
                                  input movto-ato.dat-decla-import,
                                  output de-tot-valor-conv).
         END.
         ELSE
            ASSIGN de-tot-valor-conv = movto-ato.val-movto-ato-orig.

            assign de-tot-quant = de-tot-quant + movto-ato.val-quant-movto-ato-re
                   de-tot-valor = de-tot-valor + de-tot-valor-conv.
     END.
     IF l-valor THEN
         IF i-tip-item-movto = 1 THEN
             ASSIGN d-resultado = bf-pedido-drb-item.preco-fob - de-tot-valor.
         ELSE
             ASSIGN d-resultado = bf-pedido-drb-item.val-fob-nac - de-tot-valor.
     ELSE 
         IF i-tip-item-movto = 1 THEN
             ASSIGN d-resultado = bf-pedido-drb-item.quantidade - de-tot-quant.
         ELSE
             ASSIGN d-resultado = bf-pedido-drb-item.qtd-item-nac - de-tot-quant.
End.
ELSE
    ASSIGN d-resultado = 0.   

IF d-resultado < 0 THEN ASSIGN d-resultado = 0.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retorna-movto-ato-isen-exp DBOProgram 
PROCEDURE retorna-movto-ato-isen-exp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT  PARAMETER p-cod-estabel    LIKE pedido-drb-item.cod-estabel   NO-UNDO.
DEF INPUT  PARAMETER p-it-codigo      LIKE pedido-drb-item.it-codigo     NO-UNDO. 
DEF INPUT  PARAMETER p-nr-pedido-drb  LIKE pedido-drb-item.nr-pedido-drb NO-UNDO.
DEF INPUT  PARAMETER i-tip-item-movto AS INTEGER                         NO-UNDO.
DEF INPUT  PARAMETER l-valor          AS LOGICAL                         NO-UNDO.
DEF OUTPUT PARAMETER d-resultado      AS DECIMAL                         NO-UNDO.

DEF VAR de-tot-valor-conv       AS DECIMAL NO-UNDO.
DEF VAR de-tot-quant            AS DECIMAL NO-UNDO.
DEF VAR de-tot-valor            AS DECIMAL NO-UNDO.
DEF VAR de-tot-valor-conv-baixa AS DECIMAL NO-UNDO.
DEF VAR de-tot-quant-baixa      AS DECIMAL NO-UNDO.
DEF VAR de-tot-valor-baixa      AS DECIMAL NO-UNDO.

FIND bf-pedido-drb-item WHERE
     bf-pedido-drb-item.cod-estabel   = p-cod-estabel and
     bf-pedido-drb-item.nr-pedido-drb = p-nr-pedido-drb and
     bf-pedido-drb-item.it-codigo     = p-it-codigo NO-LOCK NO-ERROR.

For each movto-ato where
         movto-ato.cod-estabel   = p-cod-estabel and
         movto-ato.nr-pedido-drb = p-nr-pedido-drb and
         movto-ato.it-codigo-re  = p-it-codigo and
         movto-ato.idi-tip-movto = 1 /*entrada*/ 
         and movto-ato.idi-tip-item-movto = i-tip-item-movto 
         no-lock:

         run cdp/cd0812.p (input movto-ato.mo-codigo,
                           input bf-pedido-drb-item.moeda, 
                           input movto-ato.val-movto-ato-me,
                           input movto-ato.dat-decla-import,
                           output de-tot-valor-conv).

         assign de-tot-quant = de-tot-quant + movto-ato.val-quant-movto-ato-re
                de-tot-valor = de-tot-valor + de-tot-valor-conv.
END.

FOR EACH movto-ato WHERE
         movto-ato.cod-estabel   = p-cod-estabel and
         movto-ato.nr-pedido-drb = p-nr-pedido-drb and
         movto-ato.it-codigo-re  = p-it-codigo and
         movto-ato.idi-tip-movto = 2 /*baixa*/ 
         and movto-ato.idi-tip-item-movto = i-tip-item-movto 
         no-lock:
         
         run cdp/cd0812.p (input movto-ato.mo-codigo,
                           input bf-pedido-drb-item.moeda, 
                           input movto-ato.val-movto-ato-me,
                           input movto-ato.dat-decla-import,
                           output de-tot-valor-conv-baixa).

         assign de-tot-quant-baixa = de-tot-quant-baixa + movto-ato.val-quant-movto-ato-re
                de-tot-valor-baixa = de-tot-valor-baixa + de-tot-valor-conv-baixa.

END. 

IF l-valor THEN
    ASSIGN d-resultado = de-tot-valor - de-tot-valor-baixa.
ELSE 
    ASSIGN d-resultado = de-tot-quant - de-tot-quant-baixa.

    IF d-resultado < 0 THEN ASSIGN d-resultado = 0.
         

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retorna-movto-ato-isen DBOProgram 
PROCEDURE retorna-movto-ato-isen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT  PARAMETER p-cod-estabel    LIKE pedido-drb-item.cod-estabel   NO-UNDO.
DEF INPUT  PARAMETER p-it-codigo      LIKE pedido-drb-item.it-codigo     NO-UNDO. 
DEF INPUT  PARAMETER p-nr-pedido-drb  LIKE pedido-drb-item.nr-pedido-drb NO-UNDO.
DEF INPUT  PARAMETER i-tip-item-movto AS INTEGER                         NO-UNDO.
DEF INPUT  PARAMETER l-valor          AS LOGICAL                         NO-UNDO.
DEF OUTPUT PARAMETER d-resultado      AS DECIMAL                         NO-UNDO.

DEF VAR de-tot-valor-conv       AS DECIMAL NO-UNDO.
DEF VAR de-tot-quant            AS DECIMAL NO-UNDO.
DEF VAR de-tot-valor            AS DECIMAL NO-UNDO.
DEF VAR de-tot-valor-conv-baixa AS DECIMAL NO-UNDO.
DEF VAR de-tot-quant-baixa      AS DECIMAL NO-UNDO.
DEF VAR de-tot-valor-baixa      AS DECIMAL NO-UNDO.

FIND bf-pedido-drb-item WHERE
     bf-pedido-drb-item.cod-estabel   = p-cod-estabel and
     bf-pedido-drb-item.nr-pedido-drb = p-nr-pedido-drb and
     bf-pedido-drb-item.it-codigo     = p-it-codigo NO-LOCK NO-ERROR.

For each movto-ato where
         movto-ato.cod-estabel   = p-cod-estabel and
         movto-ato.nr-pedido-drb = p-nr-pedido-drb and
         movto-ato.it-codigo     = p-it-codigo and
         movto-ato.idi-tip-movto  = 1 /*entrada*/ 
         and movto-ato.idi-tip-item-movto = i-tip-item-movto 
         no-lock:

         run cdp/cd0812.p (input movto-ato.mo-codigo,
                           input bf-pedido-drb-item.moeda, 
                           input movto-ato.val-movto-ato-me,
                           input movto-ato.dat-decla-import,
                           output de-tot-valor-conv).

         assign de-tot-quant = de-tot-quant + movto-ato.val-quant-movto-ato
                de-tot-valor = de-tot-valor + de-tot-valor-conv.
END.

FOR EACH movto-ato WHERE
         movto-ato.cod-estabel   = p-cod-estabel and
         movto-ato.nr-pedido-drb = p-nr-pedido-drb and
         movto-ato.it-codigo     = p-it-codigo and
         movto-ato.idi-tip-movto  = 2 /*baixa*/ 
         and movto-ato.idi-tip-item-movto = i-tip-item-movto 
         no-lock:
         
         run cdp/cd0812.p (input movto-ato.mo-codigo,
                           input bf-pedido-drb-item.moeda, 
                           input movto-ato.val-movto-ato-me,
                           input movto-ato.dat-decla-import,
                           output de-tot-valor-conv-baixa).

         assign de-tot-quant-baixa = de-tot-quant-baixa + movto-ato.val-quant-movto-ato
                de-tot-valor-baixa = de-tot-valor-baixa + de-tot-valor-conv-baixa.

END. 

IF l-valor THEN
    ASSIGN d-resultado = de-tot-valor - de-tot-valor-baixa.
ELSE 
    ASSIGN d-resultado = de-tot-quant - de-tot-quant-baixa.

    IF d-resultado < 0 THEN ASSIGN d-resultado = 0.
         

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retorna-spp-drawback-saldo-terc DBOProgram 
PROCEDURE retorna-spp-drawback-saldo-terc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF OUTPUT PARAMETER l-resultado    AS LOG NO-UNDO.
  
IF CAN-FIND (funcao 
            WHERE cd-funcao = 'spp-drb-sld-terc'
            AND   ativo     = YES) THEN
    ASSIGN l-resultado =TRUE.
ELSE
    ASSIGN l-resultado =FALSE.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retorna-un DBOProgram 
PROCEDURE retorna-un :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER p-it-codigo LIKE ITEM.it-codigo NO-UNDO.
DEF OUTPUT PARAMETER p-un LIKE ITEM.un NO-UNDO.

FIND ITEM WHERE item.it-codigo = p-it-codigo NO-LOCK NO-ERROR.

ASSIGN p-un = ITEM.un.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaQuantidadeSaldoDrb DBOProgram 
PROCEDURE retornaQuantidadeSaldoDrb :
/*------------------------------------------------------------------------------
  Purpose:     Retorna o saldo do pedido Drawback - Nacional ou Internacional
  Parameters:  pi-tipo          = 1 - Internacional, 2 - Nacional
                           pi-modalidade    = Modelidade do pedido drb
                           pc-estabel       = cÛdigo do estabelecimento
                           pc-item          = CÛdigo do item
                           pc-nr-pedido-drb = cÛdigo do pedido drb
                           pde-quant-sdo    = Quantidade de saldo
  Notes:
------------------------------------------------------------------------------*/
        DEFINE INPUT  PARAMETER pi-tipo as integer                                  NO-UNDO.
        DEFINE INPUT  PARAMETER pi-modalidade    like pedido-drb.modalidade         NO-UNDO.
        DEFINE INPUT  PARAMETER pc-estabel       like pedido-drb-item.cod-estabel   NO-UNDO.
        DEFINE INPUT  PARAMETER pc-item          like pedido-drb-item.it-codigo     NO-UNDO.
        DEFINE INPUT  PARAMETER pc-nr-pedido-drb like pedido-drb-item.nr-pedido-drb NO-UNDO.
        DEFINE OUTPUT PARAMETER pde-quant-sdo    as decimal                         NO-UNDO.
        
        define variable l-nao-utiliza-drawback as logical no-undo.
        
        RUN retorna-spp-drawback-saldo-terc (OUTPUT l-nao-utiliza-drawback).
        
        IF not l-nao-utiliza-drawback THEN DO:
                  IF pi-modalidade = 1 THEN DO:
                          RUN retorna-movto-ato (INPUT pc-estabel,
                                                                         INPUT pc-item,
                                                                         INPUT pc-nr-pedido-drb,
                                                                         INPUT pi-tipo,
                                                                         INPUT FALSE,
                                                                         OUTPUT pde-quant-sdo). 
                  END.
                  ELSE IF pi-modalidade = 2 THEN DO:
                          RUN retorna-movto-ato-isen (INPUT pc-estabel,
                                                                                  INPUT pc-item,
                                                                                  INPUT pc-nr-pedido-drb,
                                                                                  INPUT pi-tipo,
                                                                                  INPUT FALSE,
                                                                                  OUTPUT pde-quant-sdo). 
                  END.
                  ELSE
                          ASSIGN pde-quant-sdo = 0.
          END.
          ELSE
                  ASSIGN pde-quant-sdo = 0.

 RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaQuantidadeSaldoDrbSoma DBOProgram 
PROCEDURE retornaQuantidadeSaldoDrbSoma :
/*------------------------------------------------------------------------------
  Purpose:     Retorna o saldo do pedido Drawback - Nacional e Internacional
  Parameters:              pi-modalidade    = Modelidade do pedido drb
                           pc-estabel       = c¢digo do estabelecimento
                           pc-item          = C¢digo do item
                           pc-nr-pedido-drb = c¢digo do pedido drb
                           pde-quant-sdo    = Quantidade de saldo
  Notes:
------------------------------------------------------------------------------*/
        DEFINE INPUT  PARAMETER pi-modalidade    like pedido-drb.modalidade         NO-UNDO.
        DEFINE INPUT  PARAMETER pc-estabel       like pedido-drb-item.cod-estabel   NO-UNDO.
        DEFINE INPUT  PARAMETER pc-item          like pedido-drb-item.it-codigo     NO-UNDO.
        DEFINE INPUT  PARAMETER pc-nr-pedido-drb like pedido-drb-item.nr-pedido-drb NO-UNDO.
        DEFINE OUTPUT PARAMETER pde-quant-sdo    as decimal                         NO-UNDO.
        
        define variable l-nao-utiliza-drawback as logical no-undo.
        DEFINE VARIABLE dcInternacional AS DECIMAL     NO-UNDO.
        DEFINE VARIABLE dcNacional AS DECIMAL     NO-UNDO.
        
        RUN retorna-spp-drawback-saldo-terc (OUTPUT l-nao-utiliza-drawback).
        
        IF not l-nao-utiliza-drawback THEN DO:
                  IF pi-modalidade = 1 THEN DO:
                          RUN retorna-movto-ato (INPUT pc-estabel,
                                                 INPUT pc-item,
                                                 INPUT pc-nr-pedido-drb,
                                                 INPUT 1 /*Internacional*/,
                                                 INPUT FALSE,
                                                 OUTPUT dcInternacional). 
                          RUN retorna-movto-ato (INPUT pc-estabel,
                                                 INPUT pc-item,
                                                 INPUT pc-nr-pedido-drb,
                                                 INPUT 2 /*Nacional*/,
                                                 INPUT FALSE,
                                                 OUTPUT dcNacional).
                          ASSIGN pde-quant-sdo = dcInternacional + dcNacional.
                  END.
                  ELSE IF pi-modalidade = 2 THEN DO:
                          RUN retorna-movto-ato-isen (INPUT pc-estabel,
                                                      INPUT pc-item,
                                                      INPUT pc-nr-pedido-drb,
                                                      INPUT 1 /*Internacional*/,
                                                      INPUT FALSE,
                                                      OUTPUT dcInternacional). 
                           RUN retorna-movto-ato-isen (INPUT pc-estabel,
                                                      INPUT pc-item,
                                                      INPUT pc-nr-pedido-drb,
                                                      INPUT 2 /*Nacional*/,
                                                      INPUT FALSE,
                                                      OUTPUT dcNacional). 
                          ASSIGN pde-quant-sdo = dcInternacional + dcNacional.
                  END.
                  ELSE
                          ASSIGN pde-quant-sdo = 0.
        END.
        ELSE
            ASSIGN pde-quant-sdo = 0.

 RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintItem DBOProgram 
PROCEDURE setConstraintItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-estabel  AS CHARACTER NO-UNDO.    
    DEFINE INPUT PARAMETER pc-pedido   AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pc-item-ini AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pc-item-fim AS CHARACTER NO-UNDO.

    assign c-estabel  = pc-estabel
           c-pedido   = pc-pedido
           c-item-ini = pc-item-ini
           c-item-fim = pc-item-fim.

    RETURN "OK":U.           
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintItembyPedidoDrb DBOProgram 
PROCEDURE setConstraintItembyPedidoDrb :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER ppedido  AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pestabel AS CHARACTER NO-UNDO.    

    assign c-pedido  = ppedido
           c-estabel = pestabel.

    RETURN "OK":U.           
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintItembyRowidPedidoDrb DBOProgram 
PROCEDURE setConstraintItembyRowidPedidoDrb :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER rpedido  AS rowid NO-UNDO.
    
    for first pedido-drb fields(cod-estabel nr-pedido-drb) no-lock 
        where rowid(pedido-drb) = rpedido:
    end.    
    if avail pedido-drb then                 
        assign c-pedido  = pedido-drb.nr-pedido-drb
               c-estabel = pedido-drb.cod-estabel.
              
    RETURN "OK":U.           
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintItembyRowidPedidoDrbItem DBOProgram 
PROCEDURE setConstraintItembyRowidPedidoDrbItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER rpedido  AS rowid NO-UNDO.
    
    for first pedido-drb-item fields(cod-estabel nr-pedido-drb) no-lock 
        where rowid(pedido-drb-item) = rpedido:
    end.    
    if avail pedido-drb-item then                 
        assign c-pedido  = pedido-drb-item.nr-pedido-drb
               c-estabel = pedido-drb-item.cod-estabel.
              
    RETURN "OK":U.          

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetConstraintQuantity DBOProgram 
PROCEDURE SetConstraintQuantity :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pc-cod-estabel   LIKE pedido-drb-item.cod-estabel   NO-UNDO.
DEFINE INPUT PARAMETER pc-nr-pedido-drb LIKE pedido-drb-item.nr-pedido-drb NO-UNDO.
DEFINE INPUT PARAMETER pc-it-codigo     LIKE pedido-drb-item.it-codigo     NO-UNDO.
DEFINE INPUT PARAMETER pi-tipo-saldo    AS INTEGER                         NO-UNDO.


    ASSIGN c-cod-estabel = pc-cod-estabel
           c-pedido-drb  = pc-nr-pedido-drb
           c-it-codigo   = pc-it-codigo
           i-tipo-saldo  = pi-tipo-saldo.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-entrada-baixa DBOProgram 
PROCEDURE valida-entrada-baixa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT  PARAM p-cod-estabel   LIKE docum-est.cod-estabel    NO-UNDO.
DEF INPUT  PARAM p-nr-pedido-drb LIKE pedido-drb.nr-pedido-drb NO-UNDO.
DEF INPUT  PARAM p-serie         LIKE docum-est.serie-docto    NO-UNDO.
DEF INPUT  PARAM p-nro-docto     LIKE docum-est.nro-docto      NO-UNDO.
DEF INPUT  PARAM p-cod-emitente  LIKE docum-est.cod-emitente   NO-UNDO.
DEF INPUT  PARAM p-nat-operacao  LIKE docum-est.nat-operacao   NO-UNDO.
DEF OUTPUT PARAM p-erro         AS LOGICAL                     NO-UNDO.

DEF VAR de-tot-valor-conv       AS DECIMAL NO-UNDO.
DEF VAR de-tot-quant            AS DECIMAL NO-UNDO.
DEF VAR de-tot-valor            AS DECIMAL NO-UNDO.
DEF VAR de-tot-valor-conv-baixa AS DECIMAL NO-UNDO.
DEF VAR de-tot-quant-baixa      AS DECIMAL NO-UNDO.
DEF VAR de-tot-valor-baixa      AS DECIMAL NO-UNDO.

ASSIGN de-tot-quant       = 0
       de-tot-valor       = 0
       de-tot-quant-baixa = 0
       de-tot-valor-baixa = 0
       p-erro             = NO.

DO TRANS:

    FOR EACH  movto-ato 
        WHERE movto-ato.cod-estabel    = p-cod-estabel  
        AND   movto-ato.nr-pedido-drb  = p-nr-pedido-drb 
        AND   movto-ato.serie          = p-serie         
        AND   movto-ato.nro-docto      = p-nro-docto     
        AND   movto-ato.cod-emitente   = p-cod-emitente  
        AND   movto-ato.nat-operacao   = p-nat-operacao  
        AND   movto-ato.idi-tip-movto  = 1 /*entrada*/ EXCLUSIVE-LOCK:   
        DELETE movto-ato.                          
    END.

    FOR EACH item-doc-est NO-LOCK
        WHERE item-doc-est.serie-docto  = p-serie  
        AND   item-doc-est.nro-docto    = p-nro-docto
        AND   item-doc-est.nat-operacao = p-nat-operacao
        AND   item-doc-est.cod-emitente = p-cod-emitente:

        /*Movimentos Internacionais*/
        FOR EACH movto-ato WHERE
                 movto-ato.cod-estabel   = p-cod-estabel AND
                 movto-ato.nr-pedido-drb = p-nr-pedido-drb AND
                 movto-ato.it-codigo     = item-doc-est.it-codigo AND
                 movto-ato.idi-tip-movto  = 1 /*entrada*/ 
                 NO-LOCK:
					
				 FIND FIRST bf-pedido-drb-item 
					  WHERE bf-pedido-drb-item.nr-pedido-drb = movto-ato.nr-pedido-drb
					    AND bf-pedido-drb-item.it-codigo     = movto-ato.it-codigo
						AND bf-pedido-drb-item.cod-estabel   = movto-ato.cod-estabel NO-LOCK NO-ERROR.
				
				 IF AVAIL bf-pedido-drb-item THEN
					IF movto-ato.mo-codigo <> 0 THEN DO:
   				       run cdp/cd0812.p (input movto-ato.mo-codigo,
						 			     input bf-pedido-drb-item.moeda, 
										 input movto-ato.val-movto-ato-me,
										 input movto-ato.dat-decla-import,
										 output de-tot-valor-conv).
		
					END.   
					ELSE
						ASSIGN de-tot-valor-conv = movto-ato.val-movto-ato-me.
		
                 ASSIGN de-tot-quant = de-tot-quant + movto-ato.val-quant-movto-ato
                        de-tot-valor = de-tot-valor + de-tot-valor-conv.
    
        END.
        
        FOR EACH movto-ato WHERE
                 movto-ato.cod-estabel   = p-cod-estabel AND
                 movto-ato.nr-pedido-drb = p-nr-pedido-drb AND
                 movto-ato.it-codigo     = item-doc-est.it-codigo AND
                 movto-ato.idi-tip-movto  = 2 /*baixa*/ 
                 NO-LOCK:
    
				 FIND FIRST bf-pedido-drb-item 
					  WHERE bf-pedido-drb-item.nr-pedido-drb = movto-ato.nr-pedido-drb
					    AND bf-pedido-drb-item.it-codigo     = movto-ato.it-codigo
						AND bf-pedido-drb-item.cod-estabel   = movto-ato.cod-estabel NO-LOCK NO-ERROR.
						
				 IF AVAIL bf-pedido-drb-item THEN DO:
					 IF movto-ato.mo-codigo <> 0 THEN
						 run cdp/cd0812.p (input movto-ato.mo-codigo,
										   input bf-pedido-drb-item.moeda, 
										   input movto-ato.val-movto-ato-me,
										   input movto-ato.dat-decla-import,
										   output de-tot-valor-conv-baixa).
					 ELSE
						 ASSIGN de-tot-valor-conv-baixa = movto-ato.val-movto-ato-me.
				 END.
                 ASSIGN de-tot-quant-baixa = de-tot-quant-baixa + movto-ato.val-quant-movto-ato
                        de-tot-valor-baixa = de-tot-valor-baixa + de-tot-valor-conv-baixa.
        
        END.
    END.

    IF (de-tot-quant < de-tot-quant-baixa) OR 
        (de-tot-valor < de-tot-valor-baixa) THEN
        ASSIGN p-erro = YES.

    UNDO,LEAVE.
END.


RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Valida temptable RowObject
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:
------------------------------------------------------------------------------*/
     
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    DEFINE VARIABLE c-string AS CHARACTER NO-UNDO.

    /*--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as validaá‰es ---*/

    if pType = "create":U then do: 
    
        FIND FIRST pedido-drb-item 
             where pedido-drb-item.cod-estabel   = RowObject.cod-estabel 
               and pedido-drb-item.nr-pedido-drb = RowObject.nr-pedido-drb 
               and pedido-drb-item.it-codigo     = RowObject.it-codigo no-lock NO-ERROR.

        if avail pedido-drb-item then do:
            IF pedido-drb-item.idi-reg = 1 
                AND pedido-drb-item.idi-reg <> RowObject.idi-reg THEN DO:
                {utp/ut-liter.i  Pedido_Drawback_Item_ja_cadastrado(a)_como_compra * L}
                ASSIGN c-string = RETURN-VALUE. 

                {method/svc/errors/inserr.i
                                    &ErrorNumber="17006"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR" 
                                    &ErrorParameters="c-string"}
                                       
            END.
            ELSE DO:
                IF pedido-drb-item.idi-reg <> RowObject.idi-reg THEN DO:
                    {utp/ut-liter.i  Pedido_Drawback_Item_ja_cadastrado(a)_como_venda * L}
                    ASSIGN c-string = RETURN-VALUE. 
                                          
                    {method/svc/errors/inserr.i &ErrorNumber="17006"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR" 
                                        &ErrorParameters="c-string"} 
                END.
            END.
        END.
            
        find item where item.it-codigo = rowObject.it-codigo no-lock no-error.
        {utp/ut-liter.i "Item" *}
        if not avail item then do:
            {method/svc/errors/inserr.i
                                &ErrorNumber="2"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" 
                                &ErrorParameters=RETURN-VALUE}
        end.
        if rowObject.it-codigo = "" then do:
            {method/svc/errors/inserr.i
                                &ErrorNumber="265"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" 
                                &ErrorParameters=RETURN-VALUE}
        end.
        FOR FIRST bf-pedido-drb FIELDS(log-draw-integrad) NO-LOCK
            WHERE bf-pedido-drb.cod-estabel   = RowObject.cod-estabel 
              AND bf-pedido-drb.nr-pedido-drb = RowObject.nr-pedido-drb:

            IF NOT bf-pedido-drb.log-draw-integrad 
            AND l-itens-nacionais THEN DO:
                {utp/ut-liter.i Pedido_de_Drawback *}
                ASSIGN c-string = TRIM(RETURN-VALUE).
                {utp/ut-liter.i "'Drawback_Integrado'" * }
                {method/svc/errors/inserr.i &ErrorNumber="55821"
                                            &ErrorType="EMS"
                                            &ErrorSubType="WARNING" 
                                            &ErrorParameters="c-string + '~~~~' + trim(return-value)"} 
                                    
            END.
        END.
    END.

    IF pType = "Update":U THEN DO:
       ASSIGN de-qtde-movto = 0
              de-qtde-movto-nac = 0.
       FOR EACH movto-ato NO-LOCK
          WHERE movto-ato.cod-estabel         = RowObject.cod-estabel
            AND movto-ato.nr-pedido-drb       = RowObject.nr-pedido-drb
            AND movto-ato.it-codigo           = RowObject.it-codigo 
            AND movto-ato.idi-tip-movto       = 1 /*Entrada*/ 
            AND movto-ato.idi-tip-item-movto  = 1 /*internacional*/ :

          ASSIGN de-qtde-movto = de-qtde-movto + movto-ato.val-quant-movto-ato.
            
       END.

       FOR EACH movto-ato NO-LOCK
          WHERE movto-ato.cod-estabel         = RowObject.cod-estabel
            AND movto-ato.nr-pedido-drb       = RowObject.nr-pedido-drb
            AND movto-ato.it-codigo           = RowObject.it-codigo 
            AND movto-ato.idi-tip-movto       = 1 /*Entrada*/ 
            AND movto-ato.idi-tip-item-movto  = 2 /*nacional*/ :

          ASSIGN de-qtde-movto-nac = de-qtde-movto-nac + movto-ato.val-quant-movto-ato.
            
       END.
        
       IF  de-qtde-movto > RowObject.quantidade OR 
           de-qtde-movto-nac > RowObject.qtd-item-nac
       THEN DO:
           IF de-qtde-movto > RowObject.quantidade THEN
                {method/svc/errors/inserr.i
                               &ErrorNumber="32839"
                               &ErrorType="EMS"
                               &ErrorSubType="ERROR" 
                               &ErrorParameters="string(RowObject.quantidade) + '~~~~' + string(de-qtde-movto) + '~~~~' + RowObject.it-codigo"}
           ELSE
               {method/svc/errors/inserr.i
                               &ErrorNumber="32839"
                               &ErrorType="EMS"
                               &ErrorSubType="ERROR" 
                               &ErrorParameters="string(RowObject.qtd-item-nac) + '~~~~' + string(de-qtde-movto-nac) + '~~~~' + RowObject.it-codigo"}
       END.
    END.  

    
    IF pType = "UPDATE" OR pType = "CREATE" THEN DO:

        /*--[ Validar se o numero da sequencia est† entre 001 e 999 ]------------------------------------*/
        DEFINE VARIABLE ldrawIntegrad AS LOGICAL NO-UNDO.
        
        FOR FIRST pedido-drb NO-LOCK
            WHERE pedido-drb.cod-estabel   = RowObject.cod-estabel 
            AND   pedido-drb.nr-pedido-drb = RowObject.nr-pedido-drb:
            ASSIGN ldrawIntegrad = pedido-drb.log-draw-integrad.
        END.

        /* sequencia do mercado internacional */
        IF RowObject.num-seq-item-import = 0 and
           RowObject.quantidade > 0 THEN DO:
            {utp/ut-liter.i "N£mero_da_sequància_do_item_no_mercado_internacional" *}
            {method/svc/errors/inserr.i
                &ErrorNumber="7966"
                &ErrorType="EMS"
                &ErrorParameters=RETURN-VALUE}
        END.
        /* fim - sequencia do mercado internacional */


        /* sequencia do mercado nacional (s¢ deve validar a sequencia do item da mercadoria nacional caso o drawback esteja integrado e a quantidade do item na mercada nacional for maior que 0 */
        IF ldrawIntegrad AND 
           RowObject.qtd-item-nac > 0 AND 
           RowObject.num-seq-item-nac = 0 THEN DO:
                {utp/ut-liter.i "N£mero_da_sequància_do_item_no_mercado_nacional" *}
                {method/svc/errors/inserr.i
                    &ErrorNumber="7966"
                    &ErrorType="EMS"
                    &ErrorParameters=RETURN-VALUE}
        END.
        /* fim - sequencia do mercado nacional */
        /*--[ Fim - Validar se o numero da sequencia est† entre 001 e 999 ]------------------------------------*/


        /*--[ Validaá∆o das sequencias ]-----------------------------------------------------------------------*/
            IF rowObject.num-seq-item-import > 0 THEN DO:
               IF CAN-FIND(FIRST pedido-drb-item 
                               WHERE pedido-drb-item.cod-estabel         = rowObject.cod-estabel 
                                 AND pedido-drb-item.nr-pedido-drb       = rowObject.nr-pedido-drb 
                                 AND pedido-drb-item.idi-reg             = rowObject.idi-reg 
                                 AND pedido-drb-item.it-codigo          <> RowObject.it-codigo
                                 AND pedido-drb-item.num-seq-item-import = rowObject.num-seq-item-import) THEN DO:
               
                  {utp/ut-liter.i Sequencia_de_item_internacional_ja_cadastrada_para_outro_item * L}
                  ASSIGN c-string = RETURN-VALUE.
                  {method/svc/errors/inserr.i
                                     &ErrorNumber="17006"
                                     &ErrorType="EMS"
                                     &ErrorSubType="ERROR" 
                                     &ErrorParameters="c-string"}
               END.
            END.
            IF rowObject.num-seq-item-nac > 0 THEN DO:
               IF CAN-FIND(FIRST pedido-drb-item 
                               WHERE pedido-drb-item.cod-estabel = rowObject.cod-estabel 
                                 AND pedido-drb-item.nr-pedido-drb = rowObject.nr-pedido-drb 
                                 AND pedido-drb-item.idi-reg = rowObject.idi-reg 
                                 AND pedido-drb-item.it-codigo <> RowObject.it-codigo
                                 AND pedido-drb-item.num-seq-item-nac = rowObject.num-seq-item-nac) THEN DO:

                  {utp/ut-liter.i Sequencia_de_item_nacional_ja_cadastrada_para_outro_item * L}
                  ASSIGN c-string = RETURN-VALUE.
                  {method/svc/errors/inserr.i
                                     &ErrorNumber="17006"
                                     &ErrorType="EMS"
                                     &ErrorSubType="ERROR" 
                                     &ErrorParameters="c-string"}                   
               END.
            END.             
        /*--[ fim - Validaá∆o das sequencias ]-----------------------------------------------------------------*/
    END. /* IF pType = "UPDATE" OR pType = "CREATE" THEN DO: */
    

    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
 
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeUpdateRecord DBOProgram 
PROCEDURE beforeUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    FOR FIRST param-imp FIELDS(char-1)
        WHERE param-imp.cod-estabel = rowObject.cod-estabel NO-LOCK:
    END.

    IF AVAIL param-imp AND 
        TRIM(SUBSTRING(param-imp.char-1,228,1)) = "1":U THEN DO: /* "	Tabela Itens do Ato ConcessÛrio - M0000 Folder Drawback*/
            IF NOT VALID-HANDLE(h-exapi025) THEN
                RUN exp/exapi025.p PERSISTENT SET h-exapi025.
            
            RUN pi-salva-valor-antigo IN h-exapi025(INPUT "pedido-drb-item":U, INPUT rowObject.r-rowid). 
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeCreateRecord DBOProgram 
PROCEDURE beforeCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Notes:       
------------------------------------------------------------------------------*/
    FOR FIRST param-imp FIELDS(char-1)
         WHERE param-imp.cod-estabel = RowObject.cod-estabel NO-LOCK:
    END.

    IF AVAIL param-imp AND 
        TRIM(SUBSTRING(param-imp.char-1,228,1)) = "1":U THEN DO: /* "	Tabela Itens do Ato ConcessÛrio - M0000 Folder Drawback*/
        IF NOT VALID-HANDLE(h-exapi025) THEN
            RUN exp/exapi025.p PERSISTENT SET h-exapi025.

        RUN pi-salva-valor-antigo IN h-exapi025(INPUT "pedido-drb-item":U, INPUT ?).
    END.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-historico-criacao-alteracao DBOProgram 
PROCEDURE pi-cria-historico-criacao-alteracao:
/*------------------------------------------------------------------------------------------
Purpose:    Realiza a criaá∆o do hist¢rico de criaá∆o/alteraá∆o.
Parameters: c-metodo       : INPUT  : M≤todo(Criaá∆o, Alteraá∆o);
Notes: 
------------------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER c-metodo AS CHARACTER   NO-UNDO.

    /* Verifica qual o £ltimo programa .w que executou esta procedure */
    ASSIGN i-nivel = 1.
    nivel_block:
    REPEAT WHILE PROGRAM-NAME(i-nivel) <> ?.
        ASSIGN c-programa = REPLACE(PROGRAM-NAME(i-nivel),"~/","~\")
               i-nivel = i-nivel + 1.

        IF c-programa MATCHES "*men*":U THEN NEXT.
        IF c-programa MATCHES "*.w":U THEN
            ASSIGN c-ultimo-programa = c-programa
                   c-ultimo-programa = ENTRY(NUM-ENTRIES(c-programa,"~\"),c-programa,"~\").
            
    END.

    FOR FIRST pedido-drb-item 
        WHERE pedido-drb-item.cod-estabel   = RowObject.cod-estabel
        AND   pedido-drb-item.nr-pedido-drb = RowObject.nr-pedido-drb
        AND   pedido-drb-item.it-codigo     = RowObject.it-codigo NO-LOCK:
        ASSIGN r-rowidAux = rowid(pedido-drb-item).
    END.

    RUN pi-salva-alteracao IN h-exapi025 (INPUT c-metodo, INPUT "pedido-drb-item":U, INPUT r-rowidAux, INPUT c-ultimo-programa).


    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroy DBOProgram 
PROCEDURE afterDestroy :
/*------------------------------------------------------------------------------
  Purpose:     Eliminar o handle.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    IF VALID-HANDLE(h-exapi025) THEN DO:
        DELETE PROCEDURE h-exapi025.
        ASSIGN h-exapi025 = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
