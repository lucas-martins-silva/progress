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
{include/i-prgvrs.i BOCX333 2.00.00.042 } /*** "010042" 07/10/2024 16:59:56 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bocx333 MUT}
&ENDIF

{cdp/cdcfgcex.i}


/*:T--------------------------------------------------------------------------
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

/*:T--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName BOCX333
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName item-re
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

/* DBO-XML-BEGIN */
/*:T Pre-processadores para ativar XML no DBO */
/*:T Retirar o comentario para ativar 
&GLOBAL-DEFINE XMLProducer YES    /*:T DBO atua como producer de mensagens para o Message Broker */
&GLOBAL-DEFINE XMLTopic           /*:T Topico da Mensagem enviada ao Message Broker, geralmente o nome da tabela */
&GLOBAL-DEFINE XMLTableName       /*:T Nome da tabela que deve ser usado como TAG no XML */ 
&GLOBAL-DEFINE XMLTableNameMult   /*:T Nome da tabela no plural. Usado para multiplos registros */ 
&GLOBAL-DEFINE XMLPublicFields    /*:T Lista dos campos (c1,c2) que podem ser enviados via XML. Ficam fora da listas os campos de especializacao da tabela */ 
&GLOBAL-DEFINE XMLKeyFields       /*:T Lista dos campos chave da tabela (c1,c2) */
&GLOBAL-DEFINE XMLExcludeFields   /*:T Lista de campos a serem excluidos do XML quando PublicFields = "" */

&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (m‚todo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /*:T Nome da Query que d  acessos a todos os registros, exceto os exclu¡dos pela constraint de seguran‡a. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /*:T Informar os campos da chave quando o Progress nÆo conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

/*:T--- Include com defini‡Æo da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com 
      extensÆo .i ---*/
{cxbo/bocx333.i RowObject}

DEFINE TEMP-TABLE tt-item-re NO-UNDO LIKE item-re
    FIELD r-rowid      AS ROWID
    FIELD mo-codigo    LIKE moeda.mo-codigo
    FIELD des-moeda    LIKE moeda.descricao
    FIELD class-fiscal LIKE item.class-fiscal
    FIELD vl-preori    LIKE it-nota-fisc.vl-preori.

/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName}    FOR {&TableName}.
DEFINE BUFFER b-item-re-origem  FOR {&TableName}.
DEFINE BUFFER b-item-re-destino FOR {&TableName}.

DEFINE VARIABLE c-cod-estabel        LIKE item-re.cod-estabel          NO-UNDO.
DEFINE VARIABLE c-nr-pedido-drb      LIKE item-re.nr-pedido-drb        NO-UNDO.
DEFINE VARIABLE c-num-re             LIKE item-re.num-re               NO-UNDO.
DEFINE VARIABLE l-drawback-integrado LIKE pedido-drb.log-draw-integrad NO-UNDO.
DEFINE VARIABLE h-bocx312            AS HANDLE                         NO-UNDO.

DEF VAR h-exapi025        AS HANDLE    NO-UNDO.
DEF VAR i-nivel           AS INTEGER   NO-UNDO.
DEF VAR c-programa        AS CHARACTER NO-UNDO.
DEF VAR c-ultimo-programa AS CHARACTER NO-UNDO.

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
         HEIGHT             = 2.67
         WIDTH              = 39.72.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram 
PROCEDURE afterCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF NOT CAN-FIND(FIRST Pedido-drb-RE
                        WHERE Pedido-drb-RE.cod-estabel   = RowObject.cod-estabel  
                        AND   Pedido-drb-RE.nr-pedido-drb = RowObject.nr-pedido-drb
                        AND   Pedido-drb-RE.nr-re         = RowObject.num-re) THEN DO:

        CREATE Pedido-drb-RE.
        ASSIGN Pedido-drb-RE.cod-estabel   = RowObject.cod-estabel  
               Pedido-drb-RE.nr-pedido-drb = RowObject.nr-pedido-drb
               Pedido-drb-RE.nr-re         = RowObject.num-re .
    END.

    /* Parƒmetro IM0000 - Tabela Documentos Relacionados - param-imp.char-1,229,1 */
    FOR FIRST param-imp FIELDS (char-1) NO-LOCK
        WHERE param-imp.cod-estabel = RowObject.cod-estabel:
        IF TRIM(SUBSTRING(param-imp.char-1,229,1)) = "1":U THEN DO:
            {utp/ut-liter.i "Cria‡Æo"}
            RUN pi-cria-historico-criacao-alteracao(INPUT RETURN-VALUE).
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroy DBOProgram 
PROCEDURE afterDestroy :
/*------------------------------------------------------------------------------
  Purpose:     
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterUpdateRecord DBOProgram 
PROCEDURE afterUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    /* Parƒmetro IM0000 - Tabela Documentos Relacionados - param-imp.char-1,229,1 */
    FOR FIRST param-imp FIELDS(char-1) NO-LOCK
        WHERE param-imp.cod-estabel = rowObject.cod-estabel:
        IF TRIM(SUBSTRING(param-imp.char-1,229,1)) = "1":U THEN DO:
            {utp/ut-liter.i "Altera‡Æo"}
            RUN pi-cria-historico-criacao-alteracao(INPUT RETURN-VALUE).
        END.    
    END.

RETURN "OK":U.
END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeUpdateRecord DBOProgram 
PROCEDURE beforeUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    
    /* Parƒmetro IM0000 - Tabela Documentos Relacionados - param-imp.char-1,229,1 */
    FOR FIRST param-imp FIELDS(char-1) NO-LOCK
        WHERE param-imp.cod-estabel = rowObject.cod-estabel:

        IF TRIM(SUBSTRING(param-imp.char-1,229,1)) = "1":U THEN DO:
            IF NOT VALID-HANDLE(h-exapi025) THEN
                RUN exp/exapi025.p PERSISTENT SET h-exapi025.
            
            RUN pi-salva-valor-antigo IN h-exapi025(INPUT "item-re":U, INPUT rowObject.r-rowid). 
        END.
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
    
    /* Parƒmetro IM0000 - Tabela Documentos Relacionados - param-imp.char-1,229,1 */
    FOR FIRST param-imp FIELDS(char-1) NO-LOCK
         WHERE param-imp.cod-estabel = RowObject.cod-estabel:
        
        IF TRIM(SUBSTRING(param-imp.char-1,229,1)) = "1":U THEN DO:
            IF NOT VALID-HANDLE(h-exapi025) THEN
                RUN exp/exapi025.p PERSISTENT SET h-exapi025.
    
            RUN pi-salva-valor-antigo IN h-exapi025(INPUT "item-re":U, INPUT ?).
        END.
    END.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteItemRe DBOProgram 
PROCEDURE deleteItemRe :
/*------------------------------------------------------------------------------
  Purpose:     Eliminar os registros de Item-RE
  Parameters:  c-cod-estabel   - C¢digo do estabelecimento 
               c-nr-pedido-drb - N£mero do pedido drawback
               c-it-codigo     - C¢digo do item
               c-cod-nota-fisc - C¢digo da nota
               i-nr-seq-fat    - Sequˆncia da nota
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER c-cod-estabel   LIKE item-re.cod-estabel   NO-UNDO.
    DEFINE INPUT PARAMETER c-nr-pedido-drb LIKE item-re.nr-pedido-drb NO-UNDO.
    DEFINE INPUT PARAMETER c-it-codigo     LIKE item-re.it-codigo     NO-UNDO.
    DEFINE INPUT PARAMETER c-cod-nota-fisc LIKE item-re.cod-nota-fisc NO-UNDO.
    DEFINE INPUT PARAMETER i-nr-seq-fat    LIKE item-re.nr-seq-fat NO-UNDO.
                                          
    FOR EACH item-re EXCLUSIVE-LOCK
        WHERE item-re.cod-estabel   = c-cod-estabel
        AND   item-re.nr-pedido-drb = c-nr-pedido-drb
        AND   item-re.it-codigo     = c-it-codigo
        AND   (IF c-cod-nota-fisc <> "" THEN item-re.cod-nota-fisc = c-cod-nota-fisc ELSE TRUE)
        AND   (IF i-nr-seq-fat <> 0 THEN item-re.nr-seq-fat = i-nr-seq-fat ELSE TRUE):

        FOR FIRST tab-ocor EXCLUSIVE-LOCK
           WHERE tab-ocor.cod-tab = 721
           AND   TRIM(SUBSTRING(tab-ocor.char-1,1,5))   = item-re.serie
           AND   TRIM(SUBSTRING(tab-ocor.char-1,6,16))  = item-re.cod-nota-fisc
           AND   TRIM(SUBSTRING(tab-ocor.char-1,22,5))  = item-re.cod-estabel
           AND   tab-ocor.int-1                         = item-re.nr-seq-fat 
           AND   TRIM(SUBSTRING(tab-ocor.char-1,27,16)) = item-re.it-codigo: 
           
           DELETE tab-ocor.
        END.
        DELETE item-re.
    END.

    RETURN RETURN-VALUE.
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
        WHEN "cdd-ncm":U THEN ASSIGN pFieldValue = RowObject.cdd-ncm.
        WHEN "cod-estab-docto":U THEN ASSIGN pFieldValue = RowObject.cod-estab-docto.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-nota-fisc":U THEN ASSIGN pFieldValue = RowObject.cod-nota-fisc.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "nat-operacao":U THEN ASSIGN pFieldValue = RowObject.nat-operacao.
        WHEN "nr-pedido-drb":U THEN ASSIGN pFieldValue = RowObject.nr-pedido-drb.
        WHEN "num-re":U THEN ASSIGN pFieldValue = RowObject.num-re.
        WHEN "serie":U THEN ASSIGN pFieldValue = RowObject.serie.
        WHEN "un":U THEN ASSIGN pFieldValue = RowObject.un.
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
        WHEN "dat-livre-1":U THEN ASSIGN pFieldValue = RowObject.dat-livre-1.
        WHEN "dat-livre-2":U THEN ASSIGN pFieldValue = RowObject.dat-livre-2.
        WHEN "dat-nf":U THEN ASSIGN pFieldValue = RowObject.dat-nf.
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
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
        WHEN "val-item-reg-export":U THEN ASSIGN pFieldValue = RowObject.val-item-reg-export.
        WHEN "val-peso":U THEN ASSIGN pFieldValue = RowObject.val-peso.
        WHEN "val-quant-item-reg-export":U THEN ASSIGN pFieldValue = RowObject.val-quant-item-reg-export.
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
        WHEN "nr-seq-fat":U THEN ASSIGN pFieldValue = RowObject.nr-seq-fat.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice itmrgxpr-id
  Parameters:  
               retorna valor do campo cod-estabel
               retorna valor do campo nr-pedido-drb
               retorna valor do campo num-re
               retorna valor do campo cod-estab-docto
               retorna valor do campo cod-nota-fisc
               retorna valor do campo serie
               retorna valor do campo nr-seq-fat
               retorna valor do campo it-codigo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE item-re.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-pedido-drb LIKE item-re.nr-pedido-drb NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-re LIKE item-re.num-re NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estab-docto LIKE item-re.cod-estab-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-nota-fisc LIKE item-re.cod-nota-fisc NO-UNDO.
    DEFINE OUTPUT PARAMETER pserie LIKE item-re.serie NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-seq-fat LIKE item-re.nr-seq-fat NO-UNDO.
    DEFINE OUTPUT PARAMETER pit-codigo LIKE item-re.it-codigo NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-estabel = RowObject.cod-estabel
           pnr-pedido-drb = RowObject.nr-pedido-drb
           pnum-re = RowObject.num-re
           pcod-estab-docto = RowObject.cod-estab-docto
           pcod-nota-fisc = RowObject.cod-nota-fisc
           pserie = RowObject.serie
           pnr-seq-fat = RowObject.nr-seq-fat
           pit-codigo = RowObject.it-codigo.

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
        WHEN "log-livre-1":U THEN ASSIGN pFieldValue = RowObject.log-livre-1.
        WHEN "log-livre-2":U THEN ASSIGN pFieldValue = RowObject.log-livre-2.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTableItensRE DBOProgram 
PROCEDURE getTableItensRE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER pCodEstabel LIKE pedido-drb.cod-estabel   NO-UNDO.
    DEFINE INPUT  PARAMETER pPedidoDRB  LIKE pedido-drb.nr-pedido-drb NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-item-re.

    &IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
        EMPTY TEMP-TABLE tt-item-re.
    &ELSE
        FOR EACH tt-item-re:
            DELETE tt-item-re.
        END.
    &ENDIF

&IF "{&bf_cex_versao_ems}" >= "2.062" &THEN

    FOR EACH  pedido-drb-re
        WHERE pedido-drb-re.cod-estabel   = pCodEstabel AND
              pedido-drb-re.nr-pedido-drb = pPedidoDRB  NO-LOCK,
        EACH  reg-export
        WHERE reg-export.nr-re-siscomex = pedido-drb-re.nr-re NO-LOCK:

        FIND FIRST reg-export-item
            WHERE  reg-export-item.nr-re-ems   = reg-export.nr-re-ems
            AND    reg-export-item.cod-estabel = reg-export.cod-estabel
            AND    reg-export-item.nr-proc-exp = reg-export.nr-proc-exp NO-LOCK NO-ERROR.

        FIND FIRST proc-it-nota-fisc
             WHERE proc-it-nota-fisc.nome-abrev   = reg-export-item.nome-abrev   AND
                   proc-it-nota-fisc.nr-pedcli    = reg-export-item.nr-pedcli    AND
                   proc-it-nota-fisc.nr-sequencia = reg-export-item.num-seq      AND
                   proc-it-nota-fisc.it-codigo    = reg-export-item.it-codigo    AND
                   proc-it-nota-fisc.cod-refer    = reg-export-item.cod-refer    AND
                   proc-it-nota-fisc.nr-entrega   = reg-export-item.nr-entrega   NO-LOCK NO-ERROR.

        IF  AVAIL proc-it-nota-fisc THEN DO:

            FIND FIRST it-nota-fisc
                 WHERE it-nota-fisc.cod-estabel = proc-it-nota-fisc.cod-estabel      AND
                       it-nota-fisc.serie       = proc-it-nota-fisc.serie            AND
                       it-nota-fisc.nr-nota-fis = proc-it-nota-fisc.nr-nota-fis      AND
                       it-nota-fisc.nr-seq-fat  = proc-it-nota-fisc.nr-seq-fat AND
                       it-nota-fisc.it-codigo   = proc-it-nota-fisc.it-codigo  NO-LOCK NO-ERROR.


            IF  AVAIL it-nota-fisc THEN DO:

                FIND FIRST nota-fiscal
                     WHERE nota-fiscal.cod-estabel = proc-it-nota-fisc.cod-estabel AND
                           nota-fiscal.serie       = proc-it-nota-fisc.serie       AND
                           nota-fiscal.nr-nota-fis = proc-it-nota-fisc.nr-nota-fis NO-LOCK NO-ERROR.

                IF  AVAIL nota-fiscal THEN DO:

                    CREATE tt-item-re.
                    ASSIGN tt-item-re.cod-estabel     = pedido-drb-re.cod-estabel
                           tt-item-re.nr-pedido-drb   = pedido-drb-re.nr-pedido-drb
                           tt-item-re.num-re          = pedido-drb-re.nr-re
                           tt-item-re.cod-estab-docto = nota-fiscal.cod-estabel
                           tt-item-re.cod-nota-fisc   = it-nota-fisc.nr-nota-fis
                           tt-item-re.serie           = it-nota-fisc.serie
                           tt-item-re.nr-seq-fat      = it-nota-fisc.nr-seq-fat
                           tt-item-re.it-codigo       = it-nota-fisc.it-codigo
                           tt-item-re.cod-emitente    = it-nota-fisc.cd-emitente
                           tt-item-re.nat-operacao    = it-nota-fisc.nat-operacao
                           tt-item-re.dat-nf          = nota-fiscal.dt-emis-nota
                           tt-item-re.cdd-ncm         = it-nota-fisc.class-fiscal
                           tt-item-re.vl-preori       = it-nota-fisc.vl-preori.

                
                    FIND FIRST item
                         WHERE item.it-codigo = it-nota-fisc.it-codigo NO-LOCK NO-ERROR.
                
                    IF AVAIL item THEN
                        ASSIGN tt-item-re.un           = item.un
                               tt-item-re.class-fiscal = item.class-fiscal.
                
                    FIND FIRST ped-venda
                         WHERE ped-venda.nr-pedido = it-nota-fisc.nr-pedido NO-LOCK NO-ERROR.
                
                    IF AVAIL ped-venda THEN DO:
                        ASSIGN tt-item-re.mo-codigo = ped-venda.mo-codigo.
                
                        FIND FIRST moeda
                             WHERE moeda.mo-codigo = ped-venda.mo-codigo NO-LOCK NO-ERROR.
                
                        IF AVAIL moeda THEN
                            ASSIGN tt-item-re.des-moeda = moeda.descricao.
                    END.
                
                    FIND FIRST bf{&TableName}
                         WHERE bf{&TableName}.cod-estabel     = pedido-drb-re.cod-estabel   AND
                               bf{&TableName}.nr-pedido-drb   = pedido-drb-re.nr-pedido-drb AND
                               bf{&TableName}.num-re          = pedido-drb-re.nr-re         AND
                               bf{&TableName}.cod-estab-docto = nota-fiscal.cod-estabel     AND
                               bf{&TableName}.cod-nota-fisc   = it-nota-fisc.nr-nota-fis    AND
                               bf{&TableName}.serie           = it-nota-fisc.serie          AND
                               bf{&TableName}.nr-seq-fat      = it-nota-fisc.nr-seq-fat     AND
                               bf{&tablename}.it-codigo       = it-nota-fisc.it-codigo      NO-LOCK NO-ERROR.
                
                    IF AVAIL bf{&TableName} THEN DO:
                        ASSIGN tt-item-re.val-peso                  = it-nota-fisc.peso-liq-fat - bf{&TableName}.val-peso
                               tt-item-re.val-quant-item-reg-export = it-nota-fisc.qt-faturada[1] - bf{&TableName}.val-quant-item-reg-export
                               tt-item-re.val-item-reg-export       = ((tt-item-re.val-quant-item-reg-export * it-nota-fisc.vl-preuni) / nota-fiscal.vl-taxa-exp).
                    END.
                    ELSE DO:
                        ASSIGN tt-item-re.val-peso                  = it-nota-fisc.peso-liq-fat
                               tt-item-re.val-quant-item-reg-export = it-nota-fisc.qt-faturada[1]
                               tt-item-re.val-item-reg-export       = ((it-nota-fisc.qt-faturada[1] * it-nota-fisc.vl-preuni) / nota-fiscal.vl-taxa-exp).
                    END.
                
                    IF tt-item-re.val-quant-item-reg-export <= 0 THEN
                        DELETE tt-item-re.

                END.
            END.
        END.
    END.
    
&ELSE

    FOR EACH  pedido-drb-re
        WHERE pedido-drb-re.cod-estabel   = pCodEstabel AND
              pedido-drb-re.nr-pedido-drb = pPedidoDRB  NO-LOCK,
        EACH  proc-ped-ent
        WHERE proc-ped-ent.nr-re = pedido-drb-re.nr-re NO-LOCK:

        FIND FIRST proc-it-nota-fisc
             WHERE proc-it-nota-fisc.nome-abrev   = proc-ped-ent.nome-abrev   AND
                   proc-it-nota-fisc.nr-pedcli    = proc-ped-ent.nr-pedcli    AND
                   proc-it-nota-fisc.nr-sequencia = proc-ped-ent.nr-sequencia AND
                   proc-it-nota-fisc.it-codigo    = proc-ped-ent.it-codigo    AND
                   proc-it-nota-fisc.cod-refer    = proc-ped-ent.cod-refer    AND
                   proc-it-nota-fisc.nr-entrega   = proc-ped-ent.nr-entrega   NO-LOCK NO-ERROR.

        IF AVAIL proc-it-nota-fisc THEN DO:

            FIND FIRST nota-fiscal
                 WHERE nota-fiscal.cod-estabel = proc-it-nota-fisc.cod-estabel AND
                       nota-fiscal.serie       = proc-it-nota-fisc.serie       AND
                       nota-fiscal.nr-nota-fis = proc-it-nota-fisc.nr-nota-fis NO-LOCK NO-ERROR.

            IF AVAIL nota-fiscal THEN DO:

                FIND FIRST it-nota-fisc
                     WHERE it-nota-fisc.cod-estabel = nota-fiscal.cod-estabel      AND
                           it-nota-fisc.serie       = nota-fiscal.serie            AND
                           it-nota-fisc.nr-nota-fis = nota-fiscal.nr-nota-fis      AND
                           it-nota-fisc.nr-seq-fat  = proc-it-nota-fisc.nr-seq-fat AND
                           it-nota-fisc.it-codigo   = proc-it-nota-fisc.it-codigo  NO-LOCK NO-ERROR.

                IF AVAIL it-nota-fisc THEN DO:

                    CREATE tt-item-re.
                    ASSIGN tt-item-re.cod-estabel     = pedido-drb-re.cod-estabel
                           tt-item-re.nr-pedido-drb   = pedido-drb-re.nr-pedido-drb
                           tt-item-re.num-re          = pedido-drb-re.nr-re
                           tt-item-re.cod-estab-docto = nota-fiscal.cod-estabel
                           tt-item-re.cod-nota-fisc   = it-nota-fisc.nr-nota-fis
                           tt-item-re.serie           = it-nota-fisc.serie
                           tt-item-re.nr-seq-fat      = it-nota-fisc.nr-seq-fat
                           tt-item-re.it-codigo       = it-nota-fisc.it-codigo
                           tt-item-re.cod-emitente    = it-nota-fisc.cd-emitente
                           tt-item-re.nat-operacao    = it-nota-fisc.nat-operacao
                           tt-item-re.dat-nf          = nota-fiscal.dt-emis-nota
                           tt-item-re.cdd-ncm         = it-nota-fisc.class-fiscal.

                    FIND FIRST item
                         WHERE item.it-codigo = it-nota-fisc.it-codigo NO-LOCK NO-ERROR.

                    IF AVAIL item THEN
                        ASSIGN tt-item-re.un           = item.un
                               tt-item-re.class-fiscal = item.class-fiscal.

                    FIND FIRST ped-venda
                         WHERE ped-venda.nr-pedido = it-nota-fisc.nr-pedido NO-LOCK NO-ERROR.

                    IF AVAIL ped-venda THEN DO:
                        ASSIGN tt-item-re.mo-codigo = ped-venda.mo-codigo.

                        FIND FIRST moeda
                             WHERE moeda.mo-codigo = ped-venda.mo-codigo NO-LOCK NO-ERROR.

                        IF AVAIL moeda THEN
                            ASSIGN tt-item-re.des-moeda = moeda.descricao.
                    END.

                    FIND FIRST bf{&TableName}
                         WHERE bf{&TableName}.cod-estabel     = pedido-drb-re.cod-estabel   AND
                               bf{&TableName}.nr-pedido-drb   = pedido-drb-re.nr-pedido-drb AND
                               bf{&TableName}.num-re          = pedido-drb-re.nr-re         AND
                               bf{&TableName}.cod-estab-docto = nota-fiscal.cod-estabel     AND
                               bf{&TableName}.cod-nota-fisc   = it-nota-fisc.nr-nota-fis    AND
                               bf{&TableName}.serie           = it-nota-fisc.serie          AND
                               bf{&TableName}.nr-seq-fat      = it-nota-fisc.nr-seq-fat     AND
                               bf{&tablename}.it-codigo       = it-nota-fisc.it-codigo      NO-LOCK NO-ERROR.

                    IF AVAIL bf{&TableName} THEN DO:
                        ASSIGN tt-item-re.val-peso                  = it-nota-fisc.peso-liq-fat - bf{&TableName}.val-peso
                               tt-item-re.val-quant-item-reg-export = it-nota-fisc.qt-faturada[1] - bf{&TableName}.val-quant-item-reg-export
                               tt-item-re.val-item-reg-export       = ((tt-item-re.val-quant-item-reg-export * it-nota-fisc.vl-preuni) / nota-fiscal.vl-taxa-exp).
                    END.
                    ELSE DO:
                        ASSIGN tt-item-re.val-peso                  = it-nota-fisc.peso-liq-fat
                               tt-item-re.val-quant-item-reg-export = it-nota-fisc.qt-faturada[1]
                               tt-item-re.val-item-reg-export       = ((it-nota-fisc.qt-faturada[1] * it-nota-fisc.vl-preuni) / nota-fiscal.vl-taxa-exp).
                    END.

                    IF  tt-item-re.val-quant-item-reg-export <= 0 THEN
                        DELETE tt-item-re.
                END.
            END.
        END.
    END.
    
&ENDIF

    RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ¡ndice itmrgxpr-id
  Parameters:  
               recebe valor do campo cod-estabel
               recebe valor do campo nr-pedido-drb
               recebe valor do campo num-re
               recebe valor do campo cod-estab-docto
               recebe valor do campo cod-nota-fisc
               recebe valor do campo serie
               recebe valor do campo nr-seq-fat
               recebe valor do campo it-codigo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE item-re.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pnr-pedido-drb LIKE item-re.nr-pedido-drb NO-UNDO.
    DEFINE INPUT PARAMETER pnum-re LIKE item-re.num-re NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estab-docto LIKE item-re.cod-estab-docto NO-UNDO.
    DEFINE INPUT PARAMETER pcod-nota-fisc LIKE item-re.cod-nota-fisc NO-UNDO.
    DEFINE INPUT PARAMETER pserie LIKE item-re.serie NO-UNDO.
    DEFINE INPUT PARAMETER pnr-seq-fat LIKE item-re.nr-seq-fat NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo LIKE item-re.it-codigo NO-UNDO.

    FIND FIRST bfitem-re WHERE 
        bfitem-re.cod-estabel = pcod-estabel AND 
        bfitem-re.nr-pedido-drb = pnr-pedido-drb AND 
        bfitem-re.num-re = pnum-re AND 
        bfitem-re.cod-estab-docto = pcod-estab-docto AND 
        bfitem-re.cod-nota-fisc = pcod-nota-fisc AND 
        bfitem-re.serie = pserie AND 
        bfitem-re.nr-seq-fat = pnr-seq-fat AND 
        bfitem-re.it-codigo = pit-codigo NO-LOCK NO-ERROR.        

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfitem-re THEN 
        RETURN "NOK":U.    

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfitem-re)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToPedidoDRB DBOProgram 
PROCEDURE linkToPedidoDRB :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pProgramaPai AS HANDLE NO-UNDO.

    RUN getKey IN pProgramaPai (OUTPUT c-cod-estabel,
                                OUTPUT c-nr-pedido-drb).

    RUN setConstraintPedidoDRB IN THIS-PROCEDURE (INPUT c-cod-estabel,
                                                  INPUT c-nr-pedido-drb).

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToPedidoDrbRe DBOProgram 
PROCEDURE linkToPedidoDrbRe :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAM pHandle AS HANDLE NO-UNDO.
    
    RUN getKey IN pHandle (OUTPUT c-cod-estabel,
                           OUTPUT c-nr-pedido-drb,
                           OUTPUT c-num-re).

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE maintenanceItemRE DBOProgram 
PROCEDURE maintenanceItemRE :
/*------------------------------------------------------------------------------
  Purpose   : Metodo utilizado pelo programa dkp/dp2000h, sendo responsavel pela
              manutencao da tabela ITEM-RE.
  Parameters:  <none>
  Notes     :       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pTipo          AS   CHARACTER                         NO-UNDO.
    DEFINE INPUT PARAMETER pCodEstabel    LIKE item-re.cod-estabel               NO-UNDO.
    DEFINE INPUT PARAMETER pNrPedidoDRB   LIKE item-re.nr-pedido-drb             NO-UNDO.
    DEFINE INPUT PARAMETER pNumRE         LIKE item-re.num-re                    NO-UNDO.
    DEFINE INPUT PARAMETER pCodEstabDocto LIKE item-re.cod-estab-docto           NO-UNDO.
    DEFINE INPUT PARAMETER pCodNotaFisc   LIKE item-re.cod-nota-fisc             NO-UNDO.
    DEFINE INPUT PARAMETER pSerie         LIKE item-re.serie                     NO-UNDO.
    DEFINE INPUT PARAMETER pNrSeqFat      LIKE item-re.nr-seq-fat                NO-UNDO.
    DEFINE INPUT PARAMETER pItCodigo      LIKE item-re.it-codigo                 NO-UNDO.
    DEFINE INPUT PARAMETER pCodEmitente   LIKE item-re.cod-emitente              NO-UNDO.
    DEFINE INPUT PARAMETER pNatOperacao   LIKE item-re.nat-operacao              NO-UNDO.
    DEFINE INPUT PARAMETER pDatNF         LIKE item-re.dat-nf                    NO-UNDO.
    DEFINE INPUT PARAMETER pCddNcm        LIKE item-re.cdd-ncm                   NO-UNDO.
    DEFINE INPUT PARAMETER pValPeso       LIKE item-re.val-peso                  NO-UNDO.
    DEFINE INPUT PARAMETER pUN            LIKE item-re.un                        NO-UNDO.
    DEFINE INPUT PARAMETER pQuantidade    LIKE item-re.val-quant-item-reg-export NO-UNDO.
    DEFINE INPUT PARAMETER pValor         LIKE item-re.val-item-reg-export       NO-UNDO.
    DEFINE INPUT PARAMETER pNacImp        AS   INTEGER                           NO-UNDO.
       
    RUN emptyRowObject IN THIS-PROCEDURE.
    RUN emptyRowErrors IN THIS-PROCEDURE.

    /********************************************************************
    ** Associacao de um ITEM-RE com a tabela PEDIDO-DRB. Se jah houver **
    ** algum relacionamento para o item (decorrente de uma associacao  **
    ** parcial), os valores de Peso, Quantidade e Valor sao atualiza-  **
    ** dos. Caso contrario, sera criado um novo registro.              **
    ********************************************************************/

    FOR FIRST nota-fiscal NO-LOCK
        WHERE nota-fiscal.serie       = pSerie
        AND   nota-fiscal.nr-nota-fis = pCodNotaFisc
        AND   nota-fiscal.cod-estabel = pCodEstabel: END.

    IF pTipo = "CREATE":U THEN DO:
        RUN goToKey IN THIS-PROCEDURE (INPUT pCodEstabel,
                                       INPUT pNrPedidoDRB,
                                       INPUT pNumRE,
                                       INPUT pCodEstabDocto,
                                       INPUT pCodNotaFisc,
                                       INPUT pSerie,
                                       INPUT pNrSeqFat,
                                       INPUT pItCodigo).

        IF RETURN-VALUE = "OK":U THEN DO:
            ASSIGN RowObject.val-peso                  = RowObject.val-peso                  + pValPeso
                   RowObject.val-quant-item-reg-export = RowObject.val-quant-item-reg-export + pQuantidade
                   RowObject.val-item-reg-export       = RowObject.val-item-reg-export       + pValor.

            RUN updateRecord IN THIS-PROCEDURE. 
        END.
        ELSE DO:
            /********************************************************************
            ** Criacao do ITEM-RE. Aplica-se somente em situacoes onde nao e-  **
            ** xiste um relacionamento parcial para este item.                 **
            ********************************************************************/           
            CREATE RowObject.
            ASSIGN RowObject.cod-estabel               = pCodEstabel
                   RowObject.nr-pedido-drb             = pNrPedidoDRB
                   RowObject.num-re                    = pNumRE
                   RowObject.cod-estab-docto           = pCodEstabDocto
                   RowObject.cod-nota-fisc             = pCodNotaFisc
                   RowObject.serie                     = pSerie
                   RowObject.nr-seq-fat                = pNrSeqFat
                   RowObject.it-codigo                 = pItCodigo
                   RowObject.cod-emitente              = nota-fiscal.cod-emitente
                   RowObject.nat-operacao              = pNatOperacao
                   RowObject.dat-nf                    = pDatNF
                   RowObject.cdd-ncm                   = pCddNcm
                   RowObject.val-peso                  = pValPeso
                   RowObject.un                        = pUN
                   RowObject.val-quant-item-reg-export = pQuantidade
                   RowObject.val-item-reg-export       = pValor
                   RowObject.idi-tip-item-movto        = pNacImp.

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
                                       INPUT pNumRE,
                                       INPUT pCodEstabDocto,
                                       INPUT pCodNotaFisc,
                                       INPUT pSerie,
                                       INPUT pNrSeqFat,
                                       INPUT pItCodigo).
        
        IF RETURN-VALUE = "OK":U THEN DO:
            RUN deleteRecord IN THIS-PROCEDURE.
        END.
    END.
    
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN
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

    OPEN QUERY {&QueryName} 
        FOR EACH {&TableName} NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryPedidoDRB DBOProgram 
PROCEDURE openQueryPedidoDRB :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName}
        FOR EACH  {&TableName}
            WHERE {&TableName}.cod-estabel   = c-cod-estabel   AND
                  {&TableName}.nr-pedido-drb = c-nr-pedido-drb NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryPedidoDrbRe DBOProgram 
PROCEDURE openQueryPedidoDrbRe :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName}
        FOR EACH  {&TableName}
            WHERE {&TableName}.cod-estabel   = c-cod-estabel   AND
                  {&TableName}.nr-pedido-drb = c-nr-pedido-drb AND
                  {&TableName}.num-re        = c-num-re        NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryPedidoDrbReImp DBOProgram 
PROCEDURE openQueryPedidoDrbReImp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    OPEN QUERY {&QueryName}
        FOR EACH  {&TableName}
            WHERE {&TableName}.cod-estabel        = c-cod-estabel   AND
                  {&TableName}.nr-pedido-drb      = c-nr-pedido-drb AND
                  {&TableName}.idi-tip-item-movto = 1 NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryPedidoDrbReNac DBOProgram 
PROCEDURE openQueryPedidoDrbReNac :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName}
        FOR EACH  {&TableName}
            WHERE {&TableName}.cod-estabel        = c-cod-estabel   AND
                  {&TableName}.nr-pedido-drb      = c-nr-pedido-drb AND
                  {&TableName}.idi-tip-item-movto = 2               NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-historico-criacao-alteracao DBOProgram 
PROCEDURE pi-cria-historico-criacao-alteracao :
/*------------------------------------------------------------------------------------------
Purpose:    Realiza a cria‡Æo do hist¢rico de cria‡Æo/altera‡Æo.
Parameters: c-metodo       : INPUT  : M²todo(Cria‡Æo, Altera‡Æo);
Notes: 
------------------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER c-metodo AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE r-rowidAux       AS ROWID       NO-UNDO.

    /* Verifica qual o £ltimo programa .w que executou esta procedure */
    ASSIGN i-nivel = 1.
    nivel_block:
    REPEAT WHILE PROGRAM-NAME(i-nivel) <> ?.
        ASSIGN c-programa = REPLACE(PROGRAM-NAME(i-nivel),"~/","~\")
               i-nivel = i-nivel + 1.

        IF c-programa MATCHES "*men*":U THEN NEXT.
        IF c-programa MATCHES "*.w":U THEN DO:
            ASSIGN c-ultimo-programa = ENTRY(NUM-ENTRIES(c-programa,"~\"),c-programa,"~\").
        END.    
    END.
    /****************************************************************/

    IF NOT VALID-HANDLE(h-exapi025) THEN
        RUN exp/exapi025.p PERSISTENT SET h-exapi025.
    
    FOR FIRST item-re FIELDS(cod-estabel)
        WHERE item-re.cod-estabel     = RowObject.cod-estabel    
        AND   item-re.nr-pedido-drb   = RowObject.nr-pedido-drb  
        AND   item-re.num-re          = RowObject.num-re         
        AND   item-re.cod-estab-docto = RowObject.cod-estab-docto
        AND   item-re.cod-nota-fisc   = RowObject.cod-nota-fisc  
        AND   item-re.serie           = RowObject.serie          
        AND   item-re.nr-seq-fat      = RowObject.nr-seq-fat     
        AND   item-re.it-codigo       = RowObject.it-codigo NO-LOCK:
        ASSIGN r-rowidAux = ROWID(item-re).
    END.
    RUN pi-salva-alteracao IN h-exapi025 (INPUT c-metodo, INPUT "item-re":U, INPUT r-rowidAux, INPUT c-ultimo-programa).

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retorna-desc-item DBOProgram 
PROCEDURE retorna-desc-item :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM c-item LIKE ITEM.it-codigo.
    DEF OUTPUT PARAM d-item LIKE ITEM.desc-item.

    FIND ITEM WHERE ITEM.it-codigo = c-item NO-LOCK NO-ERROR.
    IF AVAIL ITEM THEN
        ASSIGN d-item = ITEM.desc-item.
    ELSE
        ASSIGN d-item = ' '.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retorna-nom-emitente DBOProgram 
PROCEDURE retorna-nom-emitente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEF INPUT PARAM c-emitente LIKE emitente.cod-emitente.
    DEF OUTPUT PARAM c-nom-emitente LIKE emitente.nome-abrev.

    FIND emitente WHERE emitente.cod-emitente = c-emitente NO-LOCK NO-ERROR.
    IF AVAIL emitente THEN
        ASSIGN c-nom-emitente = emitente.nome-abrev.
    ELSE
        ASSIGN c-nom-emitente = ''.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retorna-nom-estabel DBOProgram 
PROCEDURE retorna-nom-estabel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM c-estabel LIKE estabelec.cod-estabel.
    DEF OUTPUT PARAM c-nom-estabel LIKE estabelec.nome.

    FIND estabelec WHERE estabelec.cod-estabel = c-estabel NO-LOCK NO-ERROR.
    IF AVAIL estabelec THEN
        ASSIGN c-nom-estabel = estabelec.nome.
    ELSE
        ASSIGN c-nom-estabel = ''.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retorna-nom-moeda DBOProgram 
PROCEDURE retorna-nom-moeda :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM c-moeda LIKE moeda.mo-codigo.
    DEF OUTPUT PARAM c-desc-moeda LIKE moeda.descricao.

    FIND moeda WHERE moeda.mo-codigo = c-moeda NO-LOCK NO-ERROR.
    IF AVAIL moeda THEN
        ASSIGN c-desc-moeda = moeda.descricao.
    ELSE
        ASSIGN c-desc-moeda = ''.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retorna-notafiscal DBOProgram 
PROCEDURE retorna-notafiscal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM c-estabel LIKE item-re.cod-estab-docto.
    DEF INPUT PARAM c-serie LIKE item-re.serie.
    DEF INPUT PARAM i-nota-fiscal LIKE item-re.cod-nota-fisc.
    DEF OUTPUT PARAM b-resposta AS LOG.

    IF CAN-FIND(nota-fiscal WHERE
                nota-fiscal.cod-estabel = c-estabel AND
                nota-fiscal.serie = c-serie AND
                nota-fiscal.nr-nota-fis = i-nota-fiscal) THEN
        ASSIGN b-resposta = YES.
    ELSE
        ASSIGN b-resposta = NO.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintPedidoDRB DBOProgram 
PROCEDURE setConstraintPedidoDRB :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pCodEstabel  LIKE item-re.cod-estabel   NO-UNDO.
    DEFINE INPUT PARAMETER pNrPedidoDRB LIKE item-re.nr-pedido-drb NO-UNDO.

    ASSIGN c-cod-estabel   = pCodEstabel
           c-nr-pedido-drb = pNrPedidoDRB.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Valida‡äes pertinentes ao DBO
  Parameters:  recebe o tipo de valida‡Æo (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    /*:T--- Utilize o parƒmetro pType para identificar quais as valida‡äes a serem
          executadas ---*/
    /*:T--- Os valores poss¡veis para o parƒmetro sÆo: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as valida‡äes ---*/
    if pType = "create" then do: 

    find item-re 
        where item-re.cod-estabel     = rowObject.cod-estabel 
          and item-re.nr-pedido-drb   = rowObject.nr-pedido-drb 
          and item-re.num-re          = rowObject.num-re 
          and item-re.cod-estab-docto = rowObject.cod-estab-docto 
          and item-re.cod-nota-fisc   = rowObject.cod-nota-fisc 
          and item-re.serie           = rowObject.serie 
          and item-re.nr-seq-fat      = rowObject.nr-seq-fat 
          and item-re.it-codigo       = rowObject.it-codigo no-lock no-error.
    if avail item-re then do:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-item-re AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Item_RE" *}
        ASSIGN c-lbl-liter-item-re = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                            &ErrorNumber="8"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lbl-liter-item-re"}
    end.

    find estabelec where estabelec.cod-estabel = rowObject.cod-estabel no-lock no-error.
    if not avail estabelec then do:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-estabelecimento AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Estabelecimento" *}
        ASSIGN c-lbl-liter-estabelecimento = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lbl-liter-estabelecimento"}
    end.
    if rowObject.cod-estabel = "" then do:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-estabelecimento-2 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Estabelecimento" *}
        ASSIGN c-lbl-liter-estabelecimento-2 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                            &ErrorNumber="265"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lbl-liter-estabelecimento-2"}
    end.

    find item where item.it-codigo = rowObject.it-codigo no-lock no-error.
    if not avail item then do:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-item AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Item" *}
        ASSIGN c-lbl-liter-item = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lbl-liter-item"}
    end.
    if rowObject.it-codigo = "" then do:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-item-2 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Item" *}
        ASSIGN c-lbl-liter-item-2 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                            &ErrorNumber="265"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lbl-liter-item-2"}
    end.
    find serie where serie.serie = rowObject.serie no-lock no-error.
    if not avail serie then do:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-serie AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "S‚rie" *}
        ASSIGN c-lbl-liter-serie = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lbl-liter-serie"}
    end.
    find emitente where emitente.cod-emitente = rowObject.cod-emitente no-lock no-error.
    if not avail emitente then do:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-emitente AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Emitente" *}
        ASSIGN c-lbl-liter-emitente = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lbl-liter-emitente"}
    end.
    find natur-oper where natur-oper.nat-operacao = rowObject.nat-operacao no-lock no-error.
    if not avail natur-oper then do:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-nat-operacao AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Nat_Opera‡Æo" *}
        ASSIGN c-lbl-liter-nat-operacao = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lbl-liter-nat-operacao"}
    end.
    if rowObject.nat-operacao = "" then do:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-nat-operacao-2 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Nat_Opera‡Æo" *}
        ASSIGN c-lbl-liter-nat-operacao-2 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                            &ErrorNumber="265"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lbl-liter-nat-operacao-2"}
    end.
    find tab-unidade where tab-unidade.un = rowObject.un no-lock no-error.
    if not avail tab-unidade then do:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-un AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Un" *}
        ASSIGN c-lbl-liter-un = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lbl-liter-un"}
    end.
    if rowObject.un = "" then do:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-un-2 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Un" *}
        ASSIGN c-lbl-liter-un-2 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                            &ErrorNumber="265"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lbl-liter-un-2"}
    end.
    find classif-fisc where classif-fisc.class-fiscal = String(rowObject.cdd-ncm) no-lock no-error.
    if not avail classif-fisc then do:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-classificacao-fiscal AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Classifica‡Æo_Fiscal" *}
        ASSIGN c-lbl-liter-classificacao-fiscal = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lbl-liter-classificacao-fiscal"}
    end.
    IF rowObject.val-quant-item-reg-export <= 0 THEN DO:
        {method/svc/errors/inserr.i
                            &ErrorNumber="4570"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="''"}

    END.
    IF rowObject.val-item-reg-export <= 0 THEN DO:
        {method/svc/errors/inserr.i
                            &ErrorNumber="28569"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="''"}
    END.
end.

/*---[ verificar se ‚ nacional ou internacional ]-------------------------------------------------- */
IF pType = "CREATE":U OR pType="UPDATE":U THEN DO:
    IF NOT VALID-HANDLE(h-bocx312) THEN DO:
        RUN cxbo/bocx312.p PERSISTENT SET h-bocx312.
    END.

    RUN pi-busca-log-draw-integrad IN h-bocx312(INPUT RowObject.cod-estabel,
                                                INPUT RowObject.nr-pedido-drb,
                                                OUTPUT l-drawback-integrado).
    
    FIND FIRST nota-fiscal NO-LOCK
         WHERE nota-fiscal.cod-estabel = RowObject.cod-estabel
           AND nota-fiscal.serie       = RowObject.serie
           AND nota-fiscal.nr-nota-fis  = RowObject.cod-nota-fisc NO-ERROR.

    IF AVAIL nota-fiscal THEN DO:
        FIND FIRST estabelec WHERE estabelec.cod-estabel = nota-fiscal.cod-estabel NO-LOCK NO-ERROR.
        FIND FIRST emitente  WHERE emitente.cod-emitente = nota-fiscal.cod-emitente NO-LOCK NO-ERROR.

        IF l-drawback-integrado THEN DO:
            /*O movimento deve ser gerado conforme o tipo de documento*/
            IF emitente.natureza > 2
               and emitente.pais <> estabelec.pais THEN
               ASSIGN RowObject.idi-tip-item-movto = 1.
            ELSE
               ASSIGN RowObject.idi-tip-item-movto = 2.
        END.
        ELSE
           ASSIGN RowObject.idi-tip-item-movto = 1.
    END.
    

    IF VALID-HANDLE(h-bocx312) THEN DO:
        DELETE PROCEDURE h-bocx312.
        ASSIGN h-bocx312 = ?.
    END.
END.
/*---[ fim - verificar se ‚ nacional ou internacional ]------------------------------------------ */

/*:T--- Verifica ocorrˆncia de erros ---*/
IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
    RETURN "NOK":U.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piVerificaNfItemRe DBOProgram 
PROCEDURE piVerificaNfItemRe :
/*------------------------------------------------------------------------------
  Purpose:   Verifica se j  existe movimento criado para o item da Nota Fiscal
  Parameters:  Entrada: pc-cod-estabel: Estabelecimento do item da nota fiscal
                        pc-serie      : S‚rie do item da nota fiscal
                        pc-nr-nota-fis: N£mero da nota fiscal
                        pc-it-codigo  : Item da nota fiscal
                        p-nr-seq-fat  : Sequencia do item da nota fiscal.
               Sa¡da: vari vel l¢gica que identifica a existˆncia do registro
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pc-cod-estabel    LIKE it-nota-fisc.cod-estabel  NO-UNDO.
    DEFINE INPUT  PARAMETER pc-serie          LIKE it-nota-fisc.serie        NO-UNDO.
    DEFINE INPUT  PARAMETER pc-nr-nota-fis    LIKE it-nota-fisc.nr-nota-fis  NO-UNDO.
    DEFINE INPUT  PARAMETER pc-it-codigo      LIKE it-nota-fisc.it-codigo    NO-UNDO.
    DEFINE INPUT  PARAMETER p-nr-seq-fat      LIKE it-nota-fisc.nr-seq-fat   NO-UNDO.
    DEFINE OUTPUT PARAMETER pl-existe-item-re AS   LOGICAL                   NO-UNDO.

    ASSIGN pl-existe-item-re = CAN-FIND(FIRST item-re 
                                        WHERE item-re.cod-estab-docto = pc-cod-estabel
                                          AND item-re.serie           = pc-serie      
                                          AND item-re.cod-nota-fisc   = pc-nr-nota-fis
                                          AND item-re.it-codigo       = pc-it-codigo  
                                          AND item-re.nr-seq-fat      = p-nr-seq-fat).
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
