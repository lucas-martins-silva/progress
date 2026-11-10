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
{include/i-prgvrs.i BOIN716 2.00.00.009 } /*** "010009" 29/11/2023 09:07:15  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN716 MUT}
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

{cdp/cdcfgmat.i} /* PrÇ-processadores de release */

/*--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN716
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName rma-it-dep
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

&GLOBAL-DEFINE ignoredErrors "3,8,10"
&GLOBAL-DEFINE newRecordOffQuery NO

/* DBO-XML-BEGIN */
/* Pre-processadores para ativar XML no DBO */
/* Retirar o comentario para ativar 
&GLOBAL-DEFINE XMLProducer YES    /* DBO atua como producer de mensagens para o Message Broker */
&GLOBAL-DEFINE XMLTopic           /* Topico da Mensagem enviada ao Message Broker, geralmente o nome da tabela */
&GLOBAL-DEFINE XMLTableName       /* Nome da tabela que deve ser usado como TAG no XML */ 
&GLOBAL-DEFINE XMLTableNameMult   /* Nome da tabela no plural. Usado para multiplos registros */ 
&GLOBAL-DEFINE XMLPublicFields    /* Lista dos campos (c1,c2) que podem ser enviados via XML. Ficam fora da listas os campos de especializacao da tabela */ 
&GLOBAL-DEFINE XMLKeyFields       /* Lista dos campos chave da tabela (c1,c2) */
&GLOBAL-DEFINE XMLExcludeFields   /* Lista de campos a serem excluidos do XML quando PublicFields = "" */

&GLOBAL-DEFINE XMLReceiver YES    /* DBO atua como receiver de mensagens enviado pelo Message Broker (mÇtodo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /* Nome da Query que d† acessos a todos os registros, exceto os exclu°dos pela constraint de seguranáa. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /* Informar os campos da chave quando o Progress n∆o conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

/* Campos livres - RMA */
&IF DEFINED(bf_mat_versao_ems) &THEN 
  &IF {&bf_mat_versao_ems} >= 2.05 &THEN
    /* rma-item */ 
    &GLOBAL-DEFINE FALSE-log-recebe-mercad rma-item.log-recebe-mercad = NO
    &GLOBAL-DEFINE log-recebe-mercad       log-recebe-mercad 

    /* rma-it-dep */
    &GLOBAL-DEFINE dat-valid-lote dat-valid-lote
  &ELSE
    /* rma-item */
    &GLOBAL-DEFINE FALSE-log-recebe-mercad rma-item.log-livre-2 = NO
    &GLOBAL-DEFINE log-recebe-mercad       log-livre-2
    
    /* rma-it-dep */
    &GLOBAL-DEFINE dat-valid-lote dat-livre-1
  &ENDIF
&ENDIF

/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin716.i RowObject}
{inbo/boin716.i tt-rma-it-dep}
{inbo/boin716.i tt-rma-it-dep-del}
{inbo/boin719.i tt-rma-item}
{inbo/boin717.i tt-rma-it-dep-mov}
{inbo/boin714.i2 rowPermissions}

/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/* Temp-tables definitions */
DEF TEMP-TABLE tt-del NO-UNDO
     FIELD r-rowid AS ROWID.

/*--- Local variables definitions ---*/
DEF VAR cCodEstabel   LIKE rma-item.cod-estabel   NO-UNDO.
DEF VAR cCodRMA       LIKE rma-item.cod-rma       NO-UNDO.
DEF VAR iNumSequencia LIKE rma-item.num-sequencia NO-UNDO.
DEF VAR lValidate     AS LOGICAL INITIAL YES      NO-UNDO.
DEF VAR hParentHandle AS HANDLE                   NO-UNDO.

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
         WIDTH              = 33.86.
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
DEF VAR h-boin717 AS HANDLE NO-UNDO.
DEF VAR h-boin719 AS HANDLE NO-UNDO.

  FIND FIRST rowObject NO-ERROR.
  IF NOT AVAIL rowObject THEN 
     RETURN "NOK":U.
 
  FOR FIRST rma-item WHERE
            rma-item.cod-estabel   = rma-it-dep.cod-estabel   AND
            rma-item.cod-rma       = rma-it-dep.cod-rma       AND
            rma-item.num-sequencia = rma-it-dep.num-sequencia NO-LOCK: END.     
  
  IF NOT AVAIL rma-item THEN 
     RETURN "NOK":U.    
  
  /* -----------------------------------------------------------
     Item n∆o devolvido e recebido fisicamente.
     O RMA ser† gerado apenas para contabilizaá∆o do estoque e
     geraá∆o da nota de crÇdito.
     -----------------------------------------------------------*/
    
  IF {&FALSE-log-recebe-mercad} THEN DO:
    
    IF NOT VALID-HANDLE(h-boin717) OR
       h-boin717:TYPE <> "PROCEDURE":U OR
       h-boin717:FILE-NAME <> "inbo/boin717.p":U THEN DO:      
        RUN inbo/boin717 PERSISTENT SET h-boin717.
        RUN linkToRMAItDep   IN h-boin717 (INPUT THIS-PROCEDURE).        
        RUN openQueryStatic  IN h-boin717 (INPUT "RMAItDep":U).        
        RUN clearIgnoredErrors IN h-boin717.        
    END.
  
    RUN newRecord IN h-boin717.        
    RUN getRecord IN h-boin717 (OUTPUT TABLE tt-rma-it-dep-mov).    
    FIND FIRST tt-rma-it-dep-mov NO-ERROR.
        
    IF AVAIL tt-rma-it-dep-mov THEN DO:
   
        ASSIGN tt-rma-it-dep-mov.cod-estabel   = rma-it-dep.cod-estabel
               tt-rma-it-dep-mov.cod-rma       = rma-it-dep.cod-rma
               tt-rma-it-dep-mov.num-seq-dep   = rma-it-dep.num-seq-dep
               tt-rma-it-dep-mov.num-sequencia = rma-it-dep.num-sequencia
               tt-rma-it-dep-mov.qtd-recebida  = rma-it-dep.qtd-a-receber
               tt-rma-it-dep-mov.qtd-estocada  = rma-it-dep.qtd-a-receber
               &if "{&bf_mat_versao_ems}":U >= "2.06":U &then
                   tt-rma-it-dep-mov.log-recebe-mercad = no.
               &else
                   tt-rma-it-dep-mov.log-livre-2 = no.    
               &endif
               
        RUN setRecord    IN h-boin717 (INPUT TABLE tt-rma-it-dep-mov).
        RUN createRecord IN h-boin717.
        RUN clearIgnoredErrors IN h-boin717.

        IF RETURN-VALUE <> "OK":U THEN DO:
          RUN getRowErrors IN h-boin717 (OUTPUT TABLE rowErrors).
          IF VALID-HANDLE (h-boin717) THEN 
            RUN destroy IN h-boin717.
          RETURN "NOK":U.
        END.
    END.
    
    IF VALID-HANDLE (h-boin717) THEN 
      RUN destroy IN h-boin717.    
    
    RUN updateRMAStatus IN hParentHandle.

  END.
  
  RETURN "OK":U.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterNewTTRecord DBOProgram 
PROCEDURE afterNewTTRecord :
/*------------------------------------------------------------------------------
  Purpose: Geraá∆o do registro padr∆o para a inclus∆o de alocaá‰es a
           dep¢sito da inclus∆o de itens do RMA.
  Parameters:  <none>
  Notes: Utilizado no RE3205 (inclus∆o/modificaá∆o item RMA)
------------------------------------------------------------------------------*/

  FIND FIRST rowObject NO-ERROR.
  IF NOT AVAIL rowObject THEN
    RETURN "NOK":U.

  FIND LAST rowObjectAux NO-ERROR.    

  RUN incSeq (INPUT IF AVAIL rowObjectAux THEN 
                      rowObjectAux.num-seq-dep
                    ELSE 0).

  FOR FIRST item WHERE item.it-codigo = tt-rma-item.cod-item NO-LOCK: 
     ASSIGN rowObject.cod-depos     = IF AVAIL rowObjectAux THEN 
                                         rowObjectAux.cod-depos
                                      ELSE item.deposito-pad
            rowObject.cod-localiz   = item.cod-localiz
            rowObject.cod-item      = item.it-codigo
            rowObject.cod-refer     = tt-rma-item.cod-refer
            rowObject.cod-rma       = tt-rma-item.cod-rma
            rowObject.cod-estabel   = tt-rma-item.cod-estabel
            rowObject.num-sequencia = tt-rma-item.num-sequencia.
  END.

  IF NOT AVAIL ITEM THEN  /* Se o item n∆o for encontrado, remove o lanáamento de dep¢sito */
      DELETE rowObject.

  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignRecvblQty DBOProgram 
PROCEDURE assignRecvblQty :
/*------------------------------------------------------------------------------
  Purpose: Grava a quantidade efetiva a receber do item do RMA no registro 
           padr∆o gerado para a inclus∆o de alocaá‰es a dep¢sito do item do RMA.
  Parameters:  <none>
  Notes: Utilizado na tela do RE3205 (Inclus∆o/Modificaá∆o de itens RMA)
         Registro do item RMA passado pela interface.
------------------------------------------------------------------------------*/
  FIND FIRST rowObject NO-ERROR.
  IF NOT AVAIL rowObject THEN
    RETURN "NOK":U.

  FOR FIRST ITEM WHERE ITEM.it-codigo = rowObject.cod-item NO-LOCK:
      IF tt-rma-item.qtd-a-receber > 0 THEN DO:
         ASSIGN rowObject.qtd-a-receber = IF ITEM.tipo-con-est = 2 
                                          THEN 1 
                                          ELSE (tt-rma-item.qtd-a-receber - tt-rma-item.qtd-cancelada).
         IF rowObject.qtd-a-receber <= 0 THEN DO:
           DELETE rowObject.
           RETURN "NOK":U.
         END.
      END.
      ELSE DO:
         DELETE rowObject.
         RETURN "NOK":U.
      END.
  END.

  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cancelRMAItDepOpenQty DBOProgram 
PROCEDURE cancelRMAItDepOpenQty :
/*------------------------------------------------------------------------------
  Purpose: Calcula a quantidade j† recebida para cada reserva de estoque,
           criando a tabela de dados alterados (tt-rma-it-dep) e a tabela
           que contÇm os ROWIDs dos registros que devem ser exclu°dos
           (tt-rma-it-dep-del).
  Parameters:  <none>
  Notes: Esta estrutura Ç necess†ria pois o RE3205 n∆o altera os dados no banco
         de dados imediatamente, os dados s∆o alterados apenas quando a 
         operaá∆o Ç confirmada (bot∆o "OK" da interface). AtÇ l†, devem ser
         mantidos em tabelas tempor†rias.
------------------------------------------------------------------------------*/

  FIND FIRST rowObject NO-ERROR.
  IF NOT AVAIL rowObject THEN
    RETURN "NOK":U.    

  FOR EACH rma-it-dep-mov WHERE
           rma-it-dep-mov.cod-rma       = rowObject.cod-rma       AND
           rma-it-dep-mov.cod-estabel   = rowObject.cod-estabel   AND
           rma-it-dep-mov.num-sequencia = rowObject.num-sequencia AND
           rma-it-dep-mov.num-seq-dep   = rowObject.num-seq-dep   NO-LOCK:
     ACCUM rma-it-dep-mov.qtd-recebida (TOTAL).
  END.
  /* Grava o valor j† recebido como valor total a receber na tabela de reserva de estoque */
  ASSIGN rowObject.qtd-a-receber = ACCUM TOTAL rma-it-dep-mov.qtd-recebida.  
  
  IF rowObject.qtd-a-receber <= 0 THEN DO:  /* Se a quantidade n∆o for v†lida, destina o registro Ö exclus∆o */
    CREATE tt-rma-it-dep-del.
    BUFFER-COPY rowObject TO tt-rma-it-dep-del.
  END.
  ELSE DO:  /* Caso contr†rio, alimenta temp-table com os dados alterados */
    CREATE tt-rma-it-dep.
    BUFFER-COPY rowObject TO tt-rma-it-dep.
  END.
  
  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkForSaldoEstoq DBOProgram 
PROCEDURE checkForSaldoEstoq :
/*------------------------------------------------------------------------------
  Purpose: Determinar se existe ocorrància em saldo-estoq com os dados informados
           na separaá∆o por dep¢sitos do item do RMA
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  FIND FIRST rowObject NO-LOCK NO-ERROR.
  IF NOT AVAIL rowObject THEN
    RETURN "NOK":U.
  

  FOR FIRST saldo-estoq USE-INDEX lote WHERE
            saldo-estoq.lote        = rowObject.lote      AND
            saldo-estoq.it-codigo   = rowObject.cod-item NO-LOCK: 
       RETURN "OK":U.
  END.

  RETURN "NOK":U.
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE clearIgnoredErrors DBOProgram 
PROCEDURE clearIgnoredErrors :
/*------------------------------------------------------------------------------
  Purpose: Remove da tabela de erros, registros que representam erros 
           ignorados apresentados incorretamente pelos DBOs.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FOR EACH rowErrors WHERE
             lookup(STRING(rowErrors.errorNumber), {&ignoredErrors}) <> 0 :
       DELETE rowErrors.     
    END.         
    
  IF NOT CAN-FIND (FIRST rowErrors) THEN 
    RETURN "OK":U.
  ELSE
    RETURN "NOK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE clearRowObjectAux DBOProgram 
PROCEDURE clearRowObjectAux :
/*------------------------------------------------------------------------------
  Purpose: rowObjectAux Ç a tabela que representa os registros atualmente 
           existentes na tela do RE3205. 
           Caso seja uma geraá∆o da primeira reserva de dep¢sito (tt-rma-it-dep)
           esta tabela deve ser limpa para que a sequància retorne a 0 (zero).
  Parameters:
  Notes:
------------------------------------------------------------------------------*/
  FOR EACH rowObjectAux:
    DELETE rowObjectAux.
  END.

  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE clearRowPermissions DBOProgram 
PROCEDURE clearRowPermissions :
/*------------------------------------------------------------------------------
  Purpose: Limpa a tabela de permiss‰es (rowPermissions).
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  FOR EACH rowPermissions EXCLUSIVE-LOCK:
    DELETE rowPermissions.
  END.

  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE clearTTRMAItDep DBOProgram 
PROCEDURE clearTTRMAItDep :
/*------------------------------------------------------------------------------
  Purpose: Limpa a tabela que contÇm os dados alterados pelo DBO, que ser∆o 
           repassados Ö interface do RE3205 (Itens RMA) 
  Parameters:
  Notes: N∆o foi utilizada a temp-table (TT) de trabalho do DBO (rowObject) porque
         seu uso Ç restrito pela navegaá∆o ao longo da query. Ou seja,
         todo novo registro posicionado na query, elimina os demais registros
         presentes na TT de trabalho.
         Esta estrutura Ç necess†ria pois o RE3205 n∆o altera os dados no banco
         de dados imediatamente, os dados s∆o alterados apenas quando a 
         operaá∆o Ç confirmada (bot∆o "OK" da interface).         
------------------------------------------------------------------------------*/

   FOR EACH tt-rma-it-dep:
     DELETE tt-Rma-it-dep.
   END.
   
   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE clearTTRMAItDepDel DBOProgram 
PROCEDURE clearTTRMAItDepDel :
/*------------------------------------------------------------------------------
  Purpose: Limpa a tabela que contÇm os registros detinados Ö exclus∆o que ser∆o
           enviados Ö interface do RE3205 (Itens RMA).
  Parameters:  <none>
  Notes: Esta estrutura Ç necess†ria pois o RE3205 n∆o altera os dados no banco
         de dados imediatamente, os dados s∆o alterados apenas quando a 
         operaá∆o Ç confirmada (bot∆o "OK" da interface).
------------------------------------------------------------------------------*/
  FOR EACH tt-rma-it-dep-del:
    DELETE tt-rma-it-dep-del.
  END.
  
  RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createRowPermissions DBOProgram 
PROCEDURE createRowPermissions :
/*------------------------------------------------------------------------------
  Purpose: Criar registros na tabela rowPermissions   
  Parameters: pcTabela : Nome da tabela
              pcCampo  : Nome do campo
  Notes: "OK" : Registro criado!
         'NOK : Registro j† existe.
------------------------------------------------------------------------------*/
DEF INPUT PARAM pcTabela AS CHAR NO-UNDO.
DEF INPUT PARAM pcCampo  AS CHAR NO-UNDO.

  IF NOT CAN-FIND (FIRST rowPermissions WHERE
                         rowPermissions.tabela = pcTabela AND
                         rowPermissions.campo  = pcCampo) THEN DO: 
     CREATE rowPermissions.
     ASSIGN rowPermissions.tabela = pcTabela
            rowPermissions.campo  = pcCampo.
     RETURN "OK":U.
  END.
  ELSE 
    RETURN "NOK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findRMAItem DBOProgram 
PROCEDURE findRMAItem :
/*------------------------------------------------------------------------------
  Purpose: Localiza o item do RMA relacionado ao registro de alocaá∆o a 
           dep¢sito
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM pcCodEstabel   LIKE rma-item.cod-estabel    NO-UNDO.
DEF INPUT PARAM pcCodRMA       LIKE rma-item.cod-rma        NO-UNDO.
DEF INPUT PARAM piNumSequencia LIKE rma-item.num-sequencia  NO-UNDO.

  FOR FIRST rma-item WHERE
            rma-item.cod-estabel   = pcCodEstabel   AND
            rma-item.cod-rma       = pcCodRMA       AND
            rma-item.num-sequencia = piNumSequencia NO-LOCK: END.
            
  IF AVAIL rma-item THEN
    RETURN "OK":U.    
  ELSE
    RETURN "NOK":U.
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
        WHEN "cod-depos":U THEN ASSIGN pFieldValue = RowObject.cod-depos.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-item":U THEN ASSIGN pFieldValue = RowObject.cod-item.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-localiz":U THEN ASSIGN pFieldValue = RowObject.cod-localiz.
        WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
        WHEN "cod-rma":U THEN ASSIGN pFieldValue = RowObject.cod-rma.
        WHEN "lote":U THEN ASSIGN pFieldValue = RowObject.lote.
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
        WHEN "qtd-a-receber":U THEN ASSIGN pFieldValue = RowObject.qtd-a-receber.
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
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
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "num-seq-dep":U THEN ASSIGN pFieldValue = RowObject.num-seq-dep.
        WHEN "num-sequencia":U THEN ASSIGN pFieldValue = RowObject.num-sequencia.
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
               retorna valor do campo cod-rma
               retorna valor do campo num-sequencia
               retorna valor do campo num-seq-dep
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE rma-it-dep.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-rma LIKE rma-it-dep.cod-rma NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-sequencia LIKE rma-it-dep.num-sequencia NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-seq-dep LIKE rma-it-dep.num-seq-dep NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-estabel = RowObject.cod-estabel
           pcod-rma = RowObject.cod-rma
           pnum-sequencia = RowObject.num-sequencia
           pnum-seq-dep = RowObject.num-seq-dep.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRowPermissions DBOProgram 
PROCEDURE getRowPermissions :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF OUTPUT PARAM TABLE FOR rowPermissions.

  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTTRMAItDep DBOProgram 
PROCEDURE getTTRMAItDep :
/*------------------------------------------------------------------------------
  Purpose: Permitir a sa°da da temp-table que contÇm os registros alterados pelo
           DBO que ser∆o gravados no banco de dados apenas na confirmaá∆o da 
           interface.
  Parameters:  <none>
  Notes: Esta estrutura Ç necess†ria pois o RE3205 n∆o altera os dados no banco
         de dados imediatamente, os dados s∆o alterados apenas quando a 
         operaá∆o Ç confirmada (bot∆o "OK" da interface).       
------------------------------------------------------------------------------*/
DEF OUTPUT PARAM TABLE FOR tt-rma-it-dep.

  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTTRMAItDepDel DBOProgram 
PROCEDURE getTTRMAItDepDel :
/*------------------------------------------------------------------------------
  Purpose: Permitir a sa°da da temp-table que contÇm os rowids dos
           registros que ser∆o exclu°dos na confirmaá∆o da interface.
  Parameters:  <none>
  Notes: Esta estrutura Ç necess†ria pois o RE3205 n∆o altera os dados no banco
         de dados imediatamente, os dados s∆o alterados apenas quando a 
         operaá∆o Ç confirmada (bot∆o "OK" da interface).       
------------------------------------------------------------------------------*/
DEF OUTPUT PARAM TABLE FOR tt-rma-it-dep-del.

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
               recebe valor do campo cod-rma
               recebe valor do campo num-sequencia
               recebe valor do campo num-seq-dep
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE rma-it-dep.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pcod-rma LIKE rma-it-dep.cod-rma NO-UNDO.
    DEFINE INPUT PARAMETER pnum-sequencia LIKE rma-it-dep.num-sequencia NO-UNDO.
    DEFINE INPUT PARAMETER pnum-seq-dep LIKE rma-it-dep.num-seq-dep NO-UNDO.

    FIND FIRST bfrma-it-dep WHERE 
        bfrma-it-dep.cod-estabel = pcod-estabel AND 
        bfrma-it-dep.cod-rma = pcod-rma AND 
        bfrma-it-dep.num-sequencia = pnum-sequencia AND 
        bfrma-it-dep.num-seq-dep = pnum-seq-dep NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfrma-it-dep THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfrma-it-dep)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE incSeq DBOProgram 
PROCEDURE incSeq :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM piLastSeq LIKE rma-it-dep.num-seq-dep NO-UNDO.

  ASSIGN rowObject.num-seq-dep = piLastSeq + 1.
  
  RETURN "OK".   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToRMAItem DBOProgram 
PROCEDURE linkToRMAItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pHandle AS HANDLE NO-UNDO.

  RUN getKey IN pHandle (OUTPUT cCodEstabel,
                         OUTPUT cCodRma,
                         OUTPUT iNumSequencia).

  RUN setConstraintRMAItem IN THIS-PROCEDURE (INPUT cCodEstabel,
                                              INPUT cCodRma,
                                              INPUT iNumSequencia).

  RUN findRMAItem (INPUT cCodEstabel,
                   INPUT cCodRma,
                   INPUT iNumSequencia). 
                   
  ASSIGN hParentHandle = pHandle.                 
  
  RETURN RETURN-VALUE.

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

    OPEN QUERY {&queryName} FOR EACH {&tableName} NO-LOCK INDEXED-REPOSITION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryRMAItem DBOProgram 
PROCEDURE openQueryRMAItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   OPEN QUERY {&queryName} FOR EACH {&tableName} WHERE
                                    {&tableName}.cod-estabel   = cCodEstabel   AND
                                    {&tableName}.cod-rma       = cCodRma       AND
                                    {&tableName}.num-sequencia = iNumSequencia 
                                    NO-LOCK INDEXED-REPOSITION.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintRMAItem DBOProgram 
PROCEDURE setConstraintRMAItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM pcCodEstabel   LIKE rma-item.cod-estabel   NO-UNDO.
DEF INPUT PARAM pcCodRMa       LIKE rma-item.cod-rma       NO-UNDO.
DEF INPUT PARAM piNumSequencia LIKE rma-item.num-sequencia NO-UNDO.

  ASSIGN cCodEstabel   = pcCodEstabel
         cCodRMA       = pcCodRMA
         iNumSequencia = piNumSequencia .
        
        
  RETURN "OK":u.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDefaultsLote DBOProgram 
PROCEDURE setDefaultsLote :
/*------------------------------------------------------------------------------
  Purpose: Buscar a data de validade do lote de acordo com os dados informados
           em tela (re3205, tela estoque).
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FIND FIRST rowObject NO-ERROR.
IF NOT AVAIL rowObject THEN
  RETURN "NOK":U.

RUN checkForSaldoEstoq.

IF RETURN-VALUE = "OK":U THEN
    ASSIGN rowObject.{&dat-valid-lote} = saldo-estoq.dt-vali-lote.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDisabledFields DBOProgram 
PROCEDURE setDisabledFields :
/*------------------------------------------------------------------------------
  Purpose: De acordo com o evento informado, indica quais campos devem ser
           desbilitados em tela
  Parameters: pTYpe  : Aá∆o (ADD, UPDATE, COPY, DELETE)
              pEvent : Evento que dispara a verificaá∆o.
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM pType  AS CHAR NO-UNDO.
DEF INPUT PARAM pEvent AS CHAR NO-UNDO.

  RUN clearRowPermissions.  /* Limpa tabela de permiss‰es */
  
  FIND FIRST rowObject NO-ERROR.
  IF NOT AVAIL rowObject THEN
    RETURN "NOK":U.

   CASE pEvent:

     /*--- eNABLEfIELDS */
     WHEN "enableFields":U THEN DO: 
       
       IF pType = "CREATE":U THEN DO:
         IF CAN-FIND (FIRST rowObjectAux) THEN
           RUN createRowPermissions (INPUT "rma-it-dep":U, INPUT "cod-depos":U).
       END.  
       ELSE
         IF pType = "UPDATE":U THEN DO:                
            RUN createRowPermissions (INPUT "rma-it-dep":U, INPUT "num-seq-dep":U).
         END.

       FOR FIRST ITEM 
           FIELDS (it-codigo
                   tipo-con-est
                   loc-unica)
           WHERE ITEM.it-codigo = rowObject.cod-item NO-LOCK:
         /* N∆o precisa de lote/sÇrie/nr. sÇrie */       
         IF item.tipo-con-est < 2 THEN
           RUN createRowPermissions (INPUT "rma-it-dep":U, INPUT "lote":U).   
         /* N∆o precisa de data de validade lote */       
         IF item.tipo-con-est < 3 THEN
           RUN createRowPermissions (INPUT "rma-it-dep":U, INPUT "daFi-datValidLote":U).
         /* N∆o precisa do c¢digo de localizaá∆o - localizaá∆o £nica */
         IF ITEM.loc-unica THEN                   
           RUN createRowPermissions (INPUT "rma-it-dep":U, INPUT "cod-localiz":U).
       END.
     END.
     WHEN "leave-cod-depos-son3":U OR
     WHEN "leave-lote-son3":U      THEN DO:
       FOR FIRST ITEM 
           FIELDS (it-codigo
                   tipo-con-est
                   loc-unica) 
           WHERE ITEM.it-codigo = rowObject.cod-item NO-LOCK:
           RUN checkForSaldoEstoq.
           IF RETURN-VALUE = "OK":U AND item.tipo-con-est > 2 THEN
              RUN createRowPermissions (INPUT "rma-it-dep":U, INPUT "daFi-datValidLote":U).

           /* N∆o precisa de lote/sÇrie/nr. sÇrie */       
           IF item.tipo-con-est < 2 THEN
             RUN createRowPermissions (INPUT "rma-it-dep":U, INPUT "lote":U).   
           /* N∆o precisa de data de validade lote */       
           IF item.tipo-con-est < 3 THEN
             RUN createRowPermissions (INPUT "rma-it-dep":U, INPUT "daFi-datValidLote":U).
       END.
     END.
   END CASE.

  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setRMAItem DBOProgram 
PROCEDURE setRMAItem :
/*------------------------------------------------------------------------------
  Purpose: Permite a entrada de dados da tabela de item RMA relacionada
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM TABLE FOR tt-rma-item.

  FIND FIRST tt-rma-item NO-ERROR.
  
  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setRowObjectAux DBOProgram 
PROCEDURE setRowObjectAux :
/*------------------------------------------------------------------------------
  Purpose: Permite a entrada de dados da tabela de trabalho auxiliar.
           Esta tabela pode conter mais de um registro e funcionar como um 
           espelho da tabela que contÇm os registros no browser da tela 3
           do re3205 (implantaá∆o itens rma)
  Parameters: ipar1 : table for rowObjectAux
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM TABLE FOR rowObjectAux.

  FIND FIRST rowObjectAux NO-ERROR.

  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setSensitiveItem DBOProgram 
PROCEDURE setSensitiveItem :
/*------------------------------------------------------------------------------
  Purpose: Validaá∆o especial para verificar o registro em tela 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  DEF OUTPUT PARAM pl-item-serie AS LOG NO-UNDO.

  FIND FIRST rowObject NO-ERROR.
  IF NOT AVAIL rowObject THEN
      RETURN "NOK":U.
  
  FOR FIRST ITEM WHERE ITEM.it-codigo = rowObject.cod-item NO-LOCK: 
      IF ITEM.tipo-con-est <> 2 THEN
          ASSIGN pl-item-serie = YES.
  END.
  
  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE toggleValidation DBOProgram 
PROCEDURE toggleValidation :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM plValidate AS LOGICAL NO-UNDO.
  
    ASSIGN lValidate = plValidate.

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
      
    IF NOT lValidate THEN
      RETURN "OK":U.
    
    IF pType = "CREATE":U OR pType = "UPDATE":U THEN DO:        
        IF pType = "UPDATE":U THEN DO:
           IF CAN-FIND (FIRST rma-it-dep-mov WHERE
                              rma-it-dep-mov.cod-estabel   = rowObject.cod-estabel AND
                              rma-it-dep-mov.cod-rma       = rowObject.cod-rma     AND
                              rma-it-dep-mov.num-sequencia = rowObject.num-sequencia AND
                              rma-it-dep-mov.num-seq-dep   = rowObject.num-seq-dep) THEN DO:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-deposito-para-item-rma AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Dep¢sito_para_Item_RMA" *}
                ASSIGN c-lbl-liter-deposito-para-item-rma = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                        &ErrorNumber="19310"
                        &ErrorType="EMS"
                        &ErrorSubType="Error"
                        &ErrorParameters="c-lbl-liter-deposito-para-item-rma"}
           END.
        END.
        
        IF rowObject.qtd-a-receber <= 0 THEN DO:
                {method/svc/errors/inserr.i
                        &ErrorNumber="2608"
                        &ErrorType="EMS"
                        &ErrorSubType="Error"}
        END.        
        
        IF NOT CAN-FIND (FIRST deposito WHERE 
                               deposito.cod-depos   = rowObject.cod-depos) THEN DO:
                /* Inicio -- Projeto Internacional */
                {utp/ut-table.i mgind deposito 1} /* Busca o label da tabela */
                {method/svc/errors/inserr.i
                        &ErrorNumber="2"
                        &ErrorType="EMS"
                        &ErrorSubType="Error"
                        &ErrorParameters=TRIM(RETURN-VALUE)}
        END.        
        
        FOR FIRST item WHERE item.it-codigo = rowObject.cod-item NO-LOCK:
           IF item.tipo-con-est <> 1    AND
              rowObject.lote     = "":U THEN DO:
              /* Lote deve ser diferente de Branco */
              {method/svc/errors/inserr.i &ErrorNumber     = "1818"
                                          &ErrorType       = "EMS"
                                          &ErrorSubType    = "Error"}    
           END.
           IF item.tipo-con-est            > 2 AND           
              rowObject.{&dat-valid-lote} <> ? AND 
              rowObject.{&dat-valid-lote}  < TODAY THEN DO:
              /* Data de Validade vencida para o lote */
              {method/svc/errors/inserr.i &ErrorNumber = "27722"
                                          &ErrorType = "EMS"
                                          &ErrorSubType = "Warning"}    
           END.
           IF item.tipo-con-est            > 2 AND           
              rowObject.{&dat-valid-lote}  = ? THEN DO:
              /* Data de Validade deve ser informada */
              /* Inicio -- Projeto Internacional */
              DEFINE VARIABLE c-lbl-liter-data-de-validade AS CHARACTER NO-UNDO.
              {utp/ut-liter.i "Data_de_validade" *}
              ASSIGN c-lbl-liter-data-de-validade = TRIM(RETURN-VALUE).
              {method/svc/errors/inserr.i &ErrorNumber = "18732"
                                          &ErrorType = "EMS"
                                          &ErrorSubType = "Error"
                                          &ErrorParameters="c-lbl-liter-data-de-validade"}    
           END.
           IF ITEM.tipo-con-est = 2 AND
              rowObject.qtd-a-receber > 1 THEN DO:
               {method/svc/errors/inserr.i &ErrorNumber = "28102"
                                           &ErrorType = "EMS"
                                           &ErrorSubType = "Error"}    
           END.


           /* Verifica se a quantidade Ç inteira ou fracionada */
           IF TRUNCATE (rowObject.qtd-a-receber, 0) <> rowObject.qtd-a-receber AND
              NOT item.fraciona THEN DO:
                {method/svc/errors/inserr.i
                               &ErrorNumber="1892"
                               &ErrorType="EMS"
                               &ErrorSubType="Error"}
           END.

           /* Verificar se Ç permitido ter mais de uma referància por lote */
           RUN checkForSaldoEstoq.  /* Existe registro saldo-estoq para o item */

           FOR FIRST param-estoq NO-LOCK:
               IF ITEM.tipo-con-est = 4 THEN DO:  
                    IF SUBSTRING(param-estoq.char-2,1,1) <> "#" THEN DO:
                        IF AVAIL saldo-estoq and 
                           saldo-estoq.cod-refer <> rowObject.cod-refer THEN DO:
                               /* Referencia informada nao confere com a referendia do lote. */
                               {method/svc/errors/inserr.i
                                       &ErrorNumber="1785"
                                       &ErrorType="EMS"
                                       &ErrorSubType="Error"}
                        END.
                    END.
                END.
           END.

           /* Localizaá∆o */
           IF NOT CAN-FIND (FIRST localizacao WHERE 
                                  localizacao.cod-estabel = rowObject.cod-estabel  AND
                                  localizacao.cod-depos   = rowObject.cod-depos    AND
                                  localizacao.cod-localiz = rowObject.cod-localiz) AND
                                  NOT ITEM.loc-unica THEN DO:
                   /* Inicio -- Projeto Internacional */
                   {utp/ut-table.i mgind localizacao 1} /* Busca o label da tabela */
                   {method/svc/errors/inserr.i
                           &ErrorNumber="2"
                           &ErrorType="EMS"
                           &ErrorSubType="Error"
                           &ErrorParameters=TRIM(RETURN-VALUE)}
           END.
        END.     
    END.            
    ELSE
        IF pType = "DELETE":U THEN DO:
           IF CAN-FIND (FIRST rma-it-dep-mov WHERE
                              rma-it-dep-mov.cod-estabel   = rowObject.cod-estabel AND
                              rma-it-dep-mov.cod-rma       = rowObject.cod-rma     AND
                              rma-it-dep-mov.num-sequencia = rowObject.num-sequencia AND
                              rma-it-dep-mov.num-seq-dep   = rowObject.num-seq-dep) THEN DO:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-deposito-para-item-rma-2 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Dep¢sito_para_Item_RMA" *}
                ASSIGN c-lbl-liter-deposito-para-item-rma-2 = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                        &ErrorNumber="3"
                        &ErrorType="EMS"
                        &ErrorSubType="Error"
                        &ErrorParameters="c-lbl-liter-deposito-para-item-rma-2"}
           END.       
        END.
    
    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateTTRecord DBOProgram 
PROCEDURE validateTTRecord :
/*------------------------------------------------------------------------------
  Purpose: Validaá∆o especial para verificar o registro em tela 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM pType AS CHAR NO-UNDO.

DEF VAR deQtdAlocada  LIKE rma-item.qtd-a-receber NO-UNDO.
DEF VAR deQtdAberto   LIKE rma-item.qtd-a-receber NO-UNDO.
DEF VAR deQtdRecebida LIKE rma-item.qtd-a-receber NO-UNDO.
DEF VAR lUsaLote      AS LOGICAL                  NO-UNDO.
DEF VAR hHandle       AS HANDLE                   NO-UNDO.
   
  IF pType = "CREATE":U OR pType = "UPDATE":U THEN DO:     

        FOR FIRST ITEM FIELDS (it-codigo
                               tipo-con-est)
                       WHERE ITEM.it-codigo = rowObject.cod-item
                       NO-LOCK: 
            ASSIGN lUsaLote = ITEM.tipo-con-est > 1.
        END.

        FIND FIRST rowObjectAux WHERE /* Um mesmo dep¢sito/item/localizaá∆o n∆o pode aparecer mais
                                         de uma vez entre as alocaá‰es */
                   rowObjectAux.cod-estabel   = rowObject.cod-estabel   AND
                   rowObjectAux.cod-rma       = rowObject.cod-rma       AND
                   rowObjectAux.num-sequencia = rowObject.num-sequencia AND 
                   rowObjectAux.cod-item      = rowObject.cod-item      AND
                   rowObjectAux.cod-depos     = rowObject.cod-depos     AND
                   rowObjectAux.cod-localiz   = rowObject.cod-localiz   AND
                   (lUsaLote AND rowObjectAux.lote = rowObject.lote OR NOT lUsaLote)
                   NO-ERROR.
                   
        IF NOT AVAIL rowObjectAux THEN  
            FIND FIRST rowObjectAux WHERE
                       rowObjectAux.cod-estabel   = rowObject.cod-estabel   AND
                       rowObjectAux.cod-rma       = rowObject.cod-rma       AND
                       rowObjectAux.num-sequencia = rowObject.num-sequencia AND
                       rowObjectAux.num-seq-dep   = rowObject.num-seq-dep   NO-ERROR.
                       
        IF AVAIL rowObjectAux THEN      
            IF pType = "CREATE":U THEN DO:   /* Se estiver criando e o registro j† existir retorna erro */
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-deposito-para-item-rma-3 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Dep¢sito_para_Item_RMA" *}
                ASSIGN c-lbl-liter-deposito-para-item-rma-3 = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                      &ErrorNumber="1"
                      &ErrorType="EMS"
                      &ErrorSubType="Error"
                      &ErrorParameters="c-lbl-liter-deposito-para-item-rma-3"}
                RETURN "NOK":U.
            END.
            ELSE 
               DELETE rowObjectAux.   /* Se estiver modificando remove o registro da 
                                         temp-table principal para n∆o interferir no c†lculo
                                         da quantidade j† alocada */

    FOR EACH rowObjectAux:
      ACCUMULATE rowObjectAux.qtd-a-receber (TOTAL).
    END.
    ASSIGN deQtdAlocada = (ACCUM TOTAL rowObjectAux.qtd-a-receber) +  /* Total da tela */
                          rowObject.qtd-a-receber.                    /* Registro sendo alterado */
     
    IF deQtdAlocada > tt-rma-item.qtd-a-receber THEN DO:
          /* Inicio -- Projeto Internacional */
          DEFINE VARIABLE c-lbl-liter-deposito-para-item-rma-4 AS CHARACTER NO-UNDO.
          {utp/ut-liter.i "Dep¢sito_para_Item_RMA" *}
          ASSIGN c-lbl-liter-deposito-para-item-rma-4 = TRIM(RETURN-VALUE).
          {method/svc/errors/inserr.i
                  &ErrorNumber="27170"
                  &ErrorType="EMS"
                  &ErrorSubType="Error"
                  &ErrorParameters="c-lbl-liter-deposito-para-item-rma-4"}    
          RETURN "NOK":U.
    END.    

    RUN checkForSaldoEstoq.  /* Existe registro saldo-estoq para o item */

    /* Se houver lanáamento para o mesmo lote em outro item rma com data diferente, retorna erro 
       a busca deve ser feita tanto nos registros da base quanto nos registros ainda em tela, n∆o
       gravados */
    IF RETURN-VALUE <> "OK" AND
       (CAN-FIND (FIRST rma-it-dep WHERE
                        rma-it-dep.cod-estabel        = rowObject.cod-estabel        AND
                        rma-it-dep.cod-rma            = rowObject.cod-rma            AND
                        rma-it-dep.cod-item           = rowObject.cod-item           AND
                        rma-it-dep.cod-refer          = rowObject.cod-refer          AND
                        rma-it-dep.lote               = rowObject.lote               AND
                        rma-it-dep.{&dat-valid-lote} <> rowObject.{&dat-valid-lote}) OR 
        CAN-FIND (FIRST rowObject WHERE
                        rowObject.cod-estabel        = rowObject.cod-estabel        AND
                        rowObject.cod-rma            = rowObject.cod-rma            AND
                        rowObject.cod-item           = rowObject.cod-item           AND
                        rowObject.cod-refer          = rowObject.cod-refer          AND
                        rowObject.lote               = rowObject.lote               AND
                        rowObject.{&dat-valid-lote} <> rowObject.{&dat-valid-lote})) 

        THEN DO:
            {method/svc/errors/inserr.i
                    &ErrorNumber="26642"
                    &ErrorType="EMS"
                    &ErrorSubType="Error"}
        END.
    END.

  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

