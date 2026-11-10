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
{include/i-prgvrs.i BOIN714 2.00.00.024 } /*** "010024" 17/06/2025 16:40:52 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN714 MUT}
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
&GLOBAL-DEFINE DBOName BOIN714
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName rma
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

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

&GLOBAL-DEFINE XMLReceiver YES    /* DBO atua como receiver de mensagens enviado pelo Message Broker (m‚todo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /* Nome da Query que d  acessos a todos os registros, exceto os exclu¡dos pela constraint de seguran‡a. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /* Informar os campos da chave quando o Progress nÆo conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

/*--- Include com defini‡Æo da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com 
      extensÆo .i ---*/
{inbo/boin714.i RowObject}
{inbo/boin719.i tt-rma-item}

/*--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}


/*--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/*--- Defini‡Æo das temp-tables ---*/
{inbo/boin714.i2 rowPermissions}

/* Local variable definitions */
DEF VAR cCodRMAIni      LIKE rma.cod-rma              NO-UNDO.
DEF VAR cCodRMAFim      LIKE rma.cod-rma              NO-UNDO.
DEF VAR cCodEstabelIni  LIKE rma.cod-estabel          NO-UNDO.
DEF VAR cCodEstabelFim  LIKE rma.cod-estabel          NO-UNDO.
DEF VAR iCdnEmitenteIni LIKE rma.cdn-emitente         NO-UNDO.
DEF VAR iCdnEmitenteFim LIKE rma.cdn-emitente         NO-UNDO.
DEF VAR cUserName       LIKE usuar_mestre.cod_usuario NO-UNDO.
DEF VAR c-cod-rma       AS   CHARACTER                NO-UNDO.

{cdp/cdcfgmat.i}

define temp-table ttNotasCredit no-undo
    field serie        like nota-fiscal.serie
    field nr-nota-fis  like nota-fiscal.nr-nota-fis
    field dt-emis-nota like nota-fiscal.dt-emis-nota
    field vl-tot-nota  like nota-fiscal.vl-tot-nota
    field situacao     as char
    index ch-nota
          nr-nota-fis
          serie.

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
         HEIGHT             = 11.46
         WIDTH              = 40.43.
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
{method/svc/autentic/autentic.i &vUserName="cUserName"}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterUpdateRecord DBOProgram 
PROCEDURE afterUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose: Comportamento padrÆo ap¢s a modifica‡Æo do registro
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FIND FIRST rowObject NO-ERROR.
  IF NOT AVAIL rowObject THEN
    RETURN "NOK":U.
  
  IF NOT AVAIL {&tableName} THEN
    RETURN "NOK":U.

  ASSIGN {&tableName}.dat-modificacao     = TODAY
         {&tableName}.nom-usuar-ult-modif = cUserName /* Usu rio logado no sistema */
         .

  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDeleteRecord DBOProgram 
PROCEDURE beforeDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose: Comportamento padrÆo anterior … exclusÆo do registro
  Parameters:  <none>
  Notes: Remove tabelas relacionadas
------------------------------------------------------------------------------*/
  /*** rma-item ***/
  FOR EACH rma-item WHERE
           rma-item.cod-estabel = rowObject.cod-estabel AND
           rma-item.cod-rma     = rowObject.cod-rma 
           EXCLUSIVE-LOCK 
           ON ERROR UNDO, LEAVE:
     DELETE rma-item.     
  END.
  IF LOCKED (rma-item) THEN DO:
     {method/svc/errors/inserr.i &ErrorNumber="4"
                                  &ErrorType="INTERNAL"
                                  &ErrorSubType="ERROR"}
      RETURN "NOK":U.
  END.
  
  /*** rma-it-dep ***/
  FOR EACH rma-it-dep WHERE
           rma-it-dep.cod-estabel = rowObject.cod-estabel AND
           rma-it-dep.cod-rma     = rowObject.cod-rma
           EXCLUSIVE-LOCK
           ON ERROR UNDO, LEAVE:
     DELETE rma-it-dep.
  END.
  IF LOCKED (rma-it-dep) THEN DO:
     {method/svc/errors/inserr.i &ErrorNumber="4"
                                  &ErrorType="INTERNAL"
                                  &ErrorSubType="ERROR"}
      RETURN "NOK":U.
  END.

  /*** rma-it-troca ***/
  FOR EACH rma-it-troca WHERE
           rma-it-troca.cod-estabel = rowObject.cod-estabel AND
           rma-it-troca.cod-rma     = rowObject.cod-rma
           EXCLUSIVE-LOCK
           ON ERROR UNDO, LEAVE:
     DELETE rma-it-troca.
  END.
  IF LOCKED (rma-it-troca) THEN DO:
     {method/svc/errors/inserr.i &ErrorNumber="4"
                                  &ErrorType="INTERNAL"
                                  &ErrorSubType="ERROR"}
      RETURN "NOK":U.
  END.

  
  /*** rma-desp ***/
  FOR EACH rma-desp WHERE
           rma-desp.cod-estabel = rowObject.cod-estabel AND
           rma-desp.cod-rma     = rowObject.cod-rma
           EXCLUSIVE-LOCK
           ON ERROR UNDO, LEAVE:
     DELETE rma-desp.
  END.
  IF LOCKED (rma-desp) THEN DO:
     {method/svc/errors/inserr.i &ErrorNumber="4"
                                  &ErrorType="INTERNAL"
                                  &ErrorSubType="ERROR"}
      RETURN "NOK":U.
  END.

  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE blankRMAExpenses DBOProgram 
PROCEDURE blankRMAExpenses :
/*------------------------------------------------------------------------------
  Purpose: Zerar os valores das despesas dos itens do RMA
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  FOR EACH rma-item where
           rma-item.cod-estabel = rma.cod-estabel AND
           rma-item.cod-rma     = rma.cod-rma EXCLUSIVE-LOCK:
      ASSIGN rma-item.val-despes-it = 0.
  END.
  
  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calcRMAGoodsTot DBOProgram 
PROCEDURE calcRMAGoodsTot :
/*------------------------------------------------------------------------------
  Purpose: Calcular o total de mercadorias do RMA
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF OUTPUT PARAM pDeTotalRMA LIKE rma-item.vl-merc-liq NO-UNDO.

  FOR EACH rma-item WHERE
           rma-item.cod-estabel = rowObject.cod-estabel AND
           rma-item.cod-rma     = rowObject.cod-rma NO-LOCK:
       ACCUMULATE rma-item.vl-merc-liq (TOTAL).       
  END.
  
  ASSIGN pDeTotalRMA = ACCUM TOTAL rma-item.vl-merc-liq.
  
  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calcRMALinesNr DBOProgram 
PROCEDURE calcRMALinesNr :
/*------------------------------------------------------------------------------
  Purpose: Calcular o nro de linhas do RMA
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF OUTPUT PARAM piNrLinhasRMA AS INT NO-UNDO.

   FOR EACH rma-item WHERE
            rma-item.cod-estabel = rowObject.cod-estabel AND
            rma-item.cod-rma     = rowObject.cod-rma NO-LOCK:
       ACCUMULATE rma-item.num-sequencia (COUNT).
   END.
   
   ASSIGN piNrLinhasRMA = ACCUM COUNT rma-item.num-sequencia.
   
   RETURN "OK":U.   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calcRMAOpenQty DBOProgram 
PROCEDURE calcRMAOpenQty :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF OUTPUT PARAM pDeRMAOpenQty LIKE rma-item.qtd-a-receber NO-UNDO.

DEF VAR h-boin719     AS HANDLE                   NO-UNDO.
DEF VAR deItemOpenQty LIKE rma-item.qtd-a-receber NO-UNDO.
  
  FIND FIRST rowObject NO-ERROR.
  IF NOT AVAIL rowObject THEN
    RETURN "NOK":U.
    
    /* Totaliza Itens */
    IF NOT VALID-HANDLE(h-boin719) OR
       h-boin719:TYPE <> "PROCEDURE":U OR
       h-boin719:FILE-NAME <> "inbo/boin719.p":U THEN DO:      
        RUN inbo/boin719.p PERSISTENT SET h-boin719.
        RUN linkToRMA       IN h-boin719 (INPUT THIS-PROCEDURE).
        RUN openQueryStatic IN h-boin719 (INPUT "RMA":U).
    END.
    
    RUN getFirst IN h-boin719.
    DO WHILE RETURN-VALUE <> "NOK":U:  
       RUN calcOpenValue IN h-boin719 (OUTPUT deItemOpenQty).
       ASSIGN pDeRMAOpenQty = pDeRMAOpenQty + deItemOpenQty.
       RUN getNext IN h-boin719.
    END.
    
    RUN destroy IN h-boin719.
    /* Totaliza Itens */

  RETURN "OK":U. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calcRMAWeight DBOProgram 
PROCEDURE calcRMAWeight :
/*------------------------------------------------------------------------------
  Purpose: Calcular o peso total do RMA
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF OUTPUT PARAM pDePesoRMA LIKE item.peso-bruto NO-UNDO.

   FOR EACH rma-item WHERE
            rma-item.cod-estabel = rowObject.cod-estabel AND
            rma-item.cod-rma     = rowObject.cod-rma NO-LOCK,
      FIRST item WHERE
            item.it-codigo = rma-item.cod-item NO-LOCK:
       ACCUMULATE (rma-item.qtd-a-receber * item.peso-bruto) (TOTAL).
   END.
   
   ASSIGN pDePesoRMA = ACCUM TOTAL (rma-item.qtd-a-receber * item.peso-bruto).
  
  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calcTotalCredit DBOProgram 
PROCEDURE calcTotalCredit :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM pcCodEstabel  LIKE rma.cod-estabel       NO-UNDO.
    DEF INPUT  PARAM pcCodRMA      LIKE rma.cod-rma           NO-UNDO.

    def var de-qtd-recebida like rma-it-dep-mov.qtd-recebida.
                                            
    FOR  EACH rma-item WHERE 
              rma-item.cod-estabel = pcCodEstabel AND   
              rma-item.cod-rma     = pcCodRMA EXCLUSIVE-LOCK:

            FOR EACH rma-it-dep-mov WHERE
                     rma-it-dep-mov.cod-estabel   = rma-item.cod-estabel   AND
                     rma-it-dep-mov.cod-rma       = rma-item.cod-rma       AND
                     rma-it-dep-mov.num-sequencia = rma-item.num-sequencia NO-LOCK:
                 assign de-qtd-recebida = de-qtd-recebida + rma-it-dep-mov.qtd-recebida .
            END.  

        ASSIGN rma-item.qtd-creditada = de-qtd-recebida
               de-qtd-recebida        = 0.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculateRMAExchangeTotal DBOProgram 
PROCEDURE calculateRMAExchangeTotal :
/*------------------------------------------------------------------------------
  Purpose:  Calcular o total de itens de troca para o RMA
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT  PARAM pcCodEstabel  LIKE rma.cod-estabel       NO-UNDO.
DEF INPUT  PARAM pcCodRMA      LIKE rma.cod-rma           NO-UNDO.
DEF OUTPUT PARAM pdeTotTroca   LIKE rma-item.val-imposto  NO-UNDO.

  RUN gotoKey (INPUT pcCodEstabel,
               INPUT pcCodRMA).
               
  IF RETURN-VALUE = "NOK":U THEN 
    RETURN "NOK".
      
  FOR EACH rma-item WHERE
           rma-item.cod-estabel = rma.cod-estabel AND
           rma-item.cod-rma     = rma.cod-rma     AND
           rma-item.cdn-tipo    = 1               NO-LOCK,
      EACH rma-it-troca WHERE
           rma-it-troca.cod-estabel   = rma-item.cod-estabel   AND
           rma-it-troca.cod-rma       = rma-item.cod-rma       AND
           rma-it-troca.num-sequencia = rma-item.num-sequencia NO-LOCK:
           
     ACCUMULATE (rma-it-troca.qtd-pedida * rma-it-troca.val-preuni) (TOTAL).                 
  END.
  
  ASSIGN pdeTotTroca = ACCUM TOTAL (rma-it-troca.qtd-pedida * rma-it-troca.val-preuni).
  
  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculateRMARestockingTotal DBOProgram 
PROCEDURE calculateRMARestockingTotal :
/*------------------------------------------------------------------------------
  Purpose: Calcular o total de restocagem para o RMA
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT  PARAM pcCodEstabel  LIKE rma.cod-estabel         NO-UNDO.
DEF INPUT  PARAM pcCodRMA      LIKE rma.cod-rma             NO-UNDO.
DEF OUTPUT PARAM pdeRestocagem LIKE rma-item.val-restocagem NO-UNDO.

DEF VAR deRestocRMAItem AS DEC NO-UNDO.

  RUN gotoKey (INPUT pcCodEstabel,
               INPUT pcCodRMA).
               
  IF RETURN-VALUE = "NOK":U THEN 
    RETURN "NOK".
      
  FOR EACH rma-item WHERE
           rma-item.cod-estabel = rma.cod-estabel AND
           rma-item.cod-rma     = rma.cod-rma
           NO-LOCK:

         ASSIGN deRestocRMAItem  = (IF rma-item.val-perc-restocagem > 0 THEN
                                               ((rma-item.val-perc-restocagem / 100) * rma-item.vl-merc-liq)
                                            ELSE 0).
                                            
         assign deRestocRMAItem  = deRestocRMAItem + 
                                   (rma-item.val-restocagem * 
                                   (rma-item.qtd-a-receber - rma-item.qtd-cancelada)). /* Qtd efetiva a receber */

         ACCUMULATE deRestocRMAItem (TOTAL).
  END.
  
  ASSIGN pdeRestocagem = ACCUM TOTAL deRestocRMAItem.
  
  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cancelRMA DBOProgram 
PROCEDURE cancelRMA :
/*------------------------------------------------------------------------------
  Purpose: Calcelar o RMA
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR h-boin719    AS HANDLE NO-UNDO.
  DEF VAR cReturnValue AS CHAR   NO-UNDO.
  DEF VAR iLockAgain   AS INT    NO-UNDO.

  FIND FIRST rowObject NO-ERROR.
  IF NOT AVAIL rowObject THEN 
    RETURN "NOK":U.

  IF NOT AVAIL rma THEN 
    RETURN "NOK":U.

  TRANS_BLOCK:
  DO TRANSACTION:
      
        /*----------------------- Controle de registro --------------------------*/
        
        GET CURRENT {&QueryName} EXCLUSIVE-LOCK NO-WAIT.  /* Tenta travar registro */
        
        DO WHILE LOCKED {&TableName}:  /* Caso j  esteja travado por outro usu rio */
          IF LOCKED {&TableName} THEN  
            GET CURRENT {&QueryName} EXCLUSIVE-LOCK NO-WAIT.
                  
            IF (NOT LOCKED {&TableName} AND NOT AVAILABLE {&TableName}) OR
               (AVAILABLE {&TableName} AND NOT LOCKED {&TableName}) OR
               (iLockAgain >= 5) THEN
                LEAVE.
              
            ASSIGN iLockAgain = iLockAgain + 1.
        END.
          
        IF NOT AVAILABLE {&TableName} THEN DO:
            /*--- Erro 3: Tabela {&TableLabel} nÆo dispon¡vel ---*/
            {method/svc/errors/inserr.i &ErrorNumber="3"
                                        &ErrorType="INTERNAL"
                                        &ErrorSubType="ERROR"}
            ASSIGN cReturnValue = "NOK":U.
            UNDO TRANS_BLOCK, LEAVE TRANS_BLOCK.
        END.
        ELSE IF LOCKED {&TableName} THEN DO:
            /*--- Erro 4: Registro da tabela {&TableLabel} est  bloqueado 
                          por outro usu rio ---*/
            {method/svc/errors/inserr.i &ErrorNumber="4"
                                        &ErrorType="INTERNAL"
                                        &ErrorSubType="ERROR"}
            ASSIGN cReturnValue = "NOK":U.
            UNDO TRANS_BLOCK, LEAVE TRANS_BLOCK.            
        END.
        ELSE IF CURRENT-CHANGED {&TableName} THEN DO:
            /*--- Erro 12: Registro corrente j  foi alterado por outro usu rio ---*/
            {method/svc/errors/inserr.i &ErrorNumber="12"
                                        &ErrorType="INTERNAL"
                                        &ErrorSubType="ERROR"}
             ASSIGN cReturnValue = "NOK":U.
             UNDO TRANS_BLOCK, LEAVE TRANS_BLOCK.             
        END.           
              
        
        /*----------------------- Controle de registro --------------------------*/
          
        IF NOT VALID-HANDLE(h-boin719) OR 
           h-boin719:TYPE      <> "PROCEDURE":U OR
           h-boin719:FILE-NAME <> "inbo/boin719.p":U THEN DO:
           RUN inbo/boin719.p PERSISTENT SET h-boin719.
           RUN linkToRMA       IN h-boin719 (INPUT THIS-PROCEDURE:HANDLE).
           RUN openQueryStatic IN h-boin719 (INPUT "rma":U).
        END.                
        
        /*----------------------------- Atualiza‡Æo -----------------------------*/
        
        FOR EACH rma-item WHERE
                 rma-item.cod-estabel = rma.cod-estabel AND
                 rma-item.cod-rma     = rma.cod-rma EXCLUSIVE-LOCK:
           RUN repositionRecord    IN h-boin719 (INPUT ROWID(rma-item)).
           IF RETURN-VALUE <> "OK":U THEN DO:
             RUN getRowErrors IN h-boin719 (OUTPUT TABLE rowErrors APPEND).
             ASSIGN cReturnValue = "NOK":U.
             UNDO TRANS_BLOCK, LEAVE TRANS_BLOCK.             
           END.
             
           RUN cancelRMAItemOpenQty IN h-boin719.
           RUN changeRMAItemStatus  IN h-boin719 (INPUT 6).
           RUN updateRecord         IN h-boin719.
           IF RETURN-VALUE <> "OK":U THEN DO:
             RUN getRowErrors IN h-boin719 (OUTPUT TABLE rowErrors APPEND).
             ASSIGN cReturnValue = "NOK":U.
             UNDO TRANS_BLOCK, LEAVE TRANS_BLOCK.             
           END.
        END.
        
        ASSIGN rma.cdn-situacao = 6.

        /*----------------------------- Atualiza‡Æo -----------------------------*/        
        
        
        /*----------------------- Controle de registro --------------------------*/
        
        IF LOCKED rma-item THEN DO:   /* Se um dos itens estiver travado defaz tudo */
            /*--- Erro 4: Registro da tabela rma-item est  bloqueado 
                         por outro usu rio ---*/
           {method/svc/errors/inserr.i &ErrorNumber="4"
                                       &ErrorType="INTERNAL"
                                       &ErrorSubType="ERROR"}     
            ASSIGN cReturnValue = "NOK":U.
            UNDO TRANS_BLOCK, LEAVE TRANS_BLOCK.
        END.  
        /*----------------------- Controle de registro --------------------------*/
      
        IF VALID-HANDLE (h-boin719) THEN
          RUN destroy IN h-boin719.
  END.
  
  IF cReturnValue = "NOK":U THEN 
    RETURN "NOK":U.
    
  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkNumberingType DBOProgram 
PROCEDURE checkNumberingType :
/*------------------------------------------------------------------------------
  Purpose: Retorna o tipo de numeracao do estabelecimento do registro 
           de RMA corrente.
  Parameters:  <none>
  Notes: Necess rio posicionar a tabela rowObject antes de executar este 
         m‚todo
------------------------------------------------------------------------------*/

  FOR FIRST rma-param WHERE
            rma-param.cod-estabel = rowObject.cod-estabel NO-LOCK: END.
  IF NOT AVAIL rma-param THEN
     RETURN "NOK":U.   

  IF rma-param.log-numeracao-rma-auto THEN
    RETURN "AUTO":U.
  ELSE 
    RETURN "MANUAL":U.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE clearRowPermissions DBOProgram 
PROCEDURE clearRowPermissions :
/*------------------------------------------------------------------------------
  Purpose: Limpa a tabela de permissäes (rowPermissions).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createRowPermissions DBOProgram 
PROCEDURE createRowPermissions :
/*------------------------------------------------------------------------------
  Purpose: Criar registros na tabela rowPermissions   
  Parameters: pcTabela : Nome da tabela
              pcCampo  : Nome do campo
  Notes: "OK" : Registro criado!
         'NOK : Registro j  existe.
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
        WHEN "cod-caixa-postal":U THEN ASSIGN pFieldValue = RowObject.cod-caixa-postal.
        WHEN "cod-cep":U THEN ASSIGN pFieldValue = RowObject.cod-cep.
        WHEN "cod-e-mail":U THEN ASSIGN pFieldValue = RowObject.cod-e-mail.
        WHEN "cod-entrega":U THEN ASSIGN pFieldValue = RowObject.cod-entrega.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-jurisdicao-ent":U THEN ASSIGN pFieldValue = RowObject.cod-jurisdicao-ent.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-nat-operacao-nc":U THEN ASSIGN pFieldValue = RowObject.cod-nat-operacao-nc.
        WHEN "cod-nat-operacao-nd":U THEN ASSIGN pFieldValue = RowObject.cod-nat-operacao-nd.
        WHEN "cod-nat-operacao-rd":U THEN ASSIGN pFieldValue = RowObject.cod-nat-operacao-rd.
        WHEN "cod-rga":U THEN ASSIGN pFieldValue = RowObject.cod-rga.
        WHEN "cod-rma":U THEN ASSIGN pFieldValue = RowObject.cod-rma.
        WHEN "cod-transp":U THEN ASSIGN pFieldValue = RowObject.cod-transp.
        WHEN "des-endereco":U THEN ASSIGN pFieldValue = RowObject.des-endereco.
        WHEN "des-via-transporte":U THEN ASSIGN pFieldValue = RowObject.des-via-transporte.
        WHEN "ds1-endereco-text":U THEN ASSIGN pFieldValue = RowObject.ds1-endereco-text.
        WHEN "nom-bairro":U THEN ASSIGN pFieldValue = RowObject.nom-bairro.
        WHEN "nom-cidade":U THEN ASSIGN pFieldValue = RowObject.nom-cidade.
        WHEN "nom-estado":U THEN ASSIGN pFieldValue = RowObject.nom-estado.
        WHEN "nom-pais":U THEN ASSIGN pFieldValue = RowObject.nom-pais.
        WHEN "nom-usuar-implant":U THEN ASSIGN pFieldValue = RowObject.nom-usuar-implant.
        WHEN "nom-usuar-ult-modif":U THEN ASSIGN pFieldValue = RowObject.nom-usuar-ult-modif.
        WHEN "cod-nota-fisc-ncredito":U THEN ASSIGN pFieldValue = RowObject.cod-nota-fisc-ncredito.
        WHEN "cod-ser-ncredito":U THEN ASSIGN pFieldValue = RowObject.cod-ser-ncredito.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getContact DBOProgram 
PROCEDURE getContact :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT  PARAM piCodEmitente LIKE cont-emit.cod-emitente NO-UNDO.
DEF INPUT  PARAM piSequencia   LIKE cont-emit.sequencia    NO-UNDO.
DEF OUTPUT PARAM pcNome        LIKE cont-emit.nome         NO-UNDO.
DEF OUTPUT PARAM pcTelefone    LIKE cont-emit.telefone     NO-UNDO.

  FOR FIRST cont-emit FIELDS (cod-emitente
                              nome
                              telefone
                              sequencia
                              e-mail) WHERE
            cont-emit.cod-emitente = piCodEmitente AND
            cont-emit.sequencia    = piSequencia 
            NO-LOCK:
      ASSIGN pcNome     = cont-emit.nome
             pcTelefone = cont-emit.telefone
             .
  END.
  
  IF AVAIL cont-emit THEN
    RETURN "OK":U.
  ELSE
    RETURN "NOK":U.                 
                             
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCurrency DBOProgram 
PROCEDURE getCurrency :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT  PARAM piCodMoeda LIKE moeda.mo-codigo  NO-UNDO.
DEF OUTPUT PARAM pcDescricao LIKE moeda.descricao NO-UNDO.

  FOR FIRST moeda FIELDS (mo-codigo
                          descricao) WHERE
            moeda.mo-codigo = piCodMoeda
            NO-LOCK:
      ASSIGN pcDescricao = moeda.descricao.
  END.
  
  IF NOT AVAIL moeda THEN 
    RETURN "NOK":U.
  ELSE
    RETURN "OK":U.
                          
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCustomer DBOProgram 
PROCEDURE getCustomer :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT  PARAM piCodEmitente like emitente.cod-emitente NO-UNDO.
DEF OUTPUT PARAM pcNomeEmit    LIKE emitente.nome-emit    NO-UNDO.

  FOR FIRST emitente FIELDS (cod-emitente 
                             nome-emit
                             identific)
                      WHERE emitente.cod-emitente = piCodEmitente AND
                            emitente.identific <> 2 
                            USE-INDEX codigo NO-LOCK:
     ASSIGN pcNomeEmit = emitente.nome-emit.
  END.
  
  IF NOT AVAIL emitente THEN
    RETURN "NOK":U.
  ELSE                                  
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
        WHEN "dat-implantacao":U THEN ASSIGN pFieldValue = RowObject.dat-implantacao.
        WHEN "dat-livre-1":U THEN ASSIGN pFieldValue = RowObject.dat-livre-1.
        WHEN "dat-livre-2":U THEN ASSIGN pFieldValue = RowObject.dat-livre-2.
        WHEN "dat-modificacao":U THEN ASSIGN pFieldValue = RowObject.dat-modificacao.
        WHEN "dat-validade":U THEN ASSIGN pFieldValue = RowObject.dat-validade.
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
        WHEN "val-cotacao":U THEN ASSIGN pFieldValue = RowObject.val-cotacao.
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
        WHEN "val-perc-restocagem":U THEN ASSIGN pFieldValue = RowObject.val-perc-restocagem.
        WHEN "val-restocagem":U THEN ASSIGN pFieldValue = RowObject.val-restocagem.
        WHEN "val-tot-rma":U THEN ASSIGN pFieldValue = RowObject.val-tot-rma.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDelivery DBOProgram 
PROCEDURE getDelivery :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 FOR FIRST emitente WHERE
           emitente.cod-emitente = rowObject.cdn-emitente,
     FIRST loc-entr WHERE
           loc-entr.cod-entrega = rowObject.cod-entrega AND
           loc-entr.nome-abrev  = emitente.nome-abrev
           NO-LOCK: END.

 IF NOT AVAIL loc-entr THEN 
   RETURN "NOK".
           
      ASSIGN rowObject.des-endereco       = loc-entr.endereco
             rowObject.nom-bairro         = loc-entr.bairro
             rowObject.nom-cidade         = loc-entr.cidade
             rowObject.nom-estado         = loc-entr.estado
             rowObject.cod-cep            = loc-entr.cep
             rowObject.nom-pais           = loc-entr.pais
             rowObject.cod-jurisdicao-ent = loc-entr.cd-jurisdicao
             rowObject.ds1-endereco-text  = loc-entr.endereco_text.
   
   RETURN "OK".

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
        WHEN "cdn-emitente":U THEN ASSIGN pFieldValue = RowObject.cdn-emitente.
        WHEN "cdn-situacao":U THEN ASSIGN pFieldValue = RowObject.cdn-situacao.
        WHEN "cod-moeda":U THEN ASSIGN pFieldValue = RowObject.cod-moeda.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "num-seq-cont-emit":U THEN ASSIGN pFieldValue = RowObject.num-seq-cont-emit.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice codigo
  Parameters:  
               retorna valor do campo cod-estabel
               retorna valor do campo cod-rma
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE rma.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-rma LIKE rma.cod-rma NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-estabel = RowObject.cod-estabel
           pcod-rma = RowObject.cod-rma.

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
        WHEN "log-e-mail-analise":U THEN ASSIGN pFieldValue = RowObject.log-e-mail-analise.
        WHEN "log-e-mail-notas":U THEN ASSIGN pFieldValue = RowObject.log-e-mail-notas.
        WHEN "log-e-mail-receb":U THEN ASSIGN pFieldValue = RowObject.log-e-mail-receb.
        WHEN "log-e-mail-remito":U THEN ASSIGN pFieldValue = RowObject.log-e-mail-remito.
        WHEN "log-livre-1":U THEN ASSIGN pFieldValue = RowObject.log-livre-1.
        WHEN "log-livre-2":U THEN ASSIGN pFieldValue = RowObject.log-livre-2.
        WHEN "log-ped-rma":U THEN ASSIGN pFieldValue = RowObject.log-ped-rma.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getNotasCredit DBOProgram 
PROCEDURE getNotasCredit :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT  PARAM pcCodEstabel like rma.cod-estabel NO-UNDO.
DEF INPUT  PARAM pcCodRma     like rma.cod-rma     NO-UNDO.
DEF OUTPUT PARAM table for ttNotasCredit.

def var c-sim as char no-undo.
def var c-nao as char no-undo.

{utp/ut-liter.i S * R}
assign c-sim = return-value.
{utp/ut-liter.i N * R} 
assign c-nao = return-value.

for each ttNotasCredit:
    delete ttNotasCredit.
end.

for each  nota-fiscal no-lock
    where nota-fiscal.cod-estabel = pcCodEstabel
    &IF "{&bf_mat_versao_ems}" = "2.042" &THEN
    and   substr(nota-fiscal.nr-nota-ant,4,12) = pcCodRma
    &else
    and   nota-fiscal.num-rma-orig = pcCodRma
    &ENDIF
    and   nota-fiscal.ind-tip-nota = 10:

    create ttNotasCredit.
    assign ttNotasCredit.nr-nota-fis  = nota-fiscal.nr-nota-fis
           ttNotasCredit.serie        = nota-fiscal.serie
           ttNotasCredit.dt-emis-nota = nota-fiscal.dt-emis-nota
           ttNotasCredit.vl-tot-nota  = nota-fiscal.vl-tot-nota.
    
  
    assign ttNotasCredit.situacao = if nota-fiscal.ind-sit-nota > 1                          then c-sim else c-nao
           ttNotasCredit.situacao = ttNotasCredit.situacao + if nota-fiscal.dt-confirma <> ?  then c-sim else c-nao
           ttNotasCredit.situacao = ttNotasCredit.situacao + if nota-fiscal.dt-cancela <> ?  then c-sim else c-nao
           ttNotasCredit.situacao = ttNotasCredit.situacao + if nota-fiscal.dt-atual-cr <> ? then c-sim else c-nao 
           ttNotasCredit.situacao = ttNotasCredit.situacao + if nota-fiscal.dt-at-ofest <> ? then c-sim else c-nao
           ttNotasCredit.situacao = ttNotasCredit.situacao + if nota-fiscal.dt-at-est <> ?   then c-sim else c-nao
           ttNotasCredit.situacao = ttNotasCredit.situacao + if nota-fiscal.ind-contabil     then c-sim else c-nao. 

end.

return "OK":U.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ¡ndice codigo
  Parameters:  
               recebe valor do campo cod-estabel
               recebe valor do campo cod-rga
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE rma.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pcod-rma LIKE rma.cod-rma NO-UNDO.

    FIND FIRST bfrma WHERE 
        bfrma.cod-estabel = pcod-estabel AND 
        bfrma.cod-rma     = pcod-rma NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfrma THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfrma)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByCdnEmitente DBOProgram 
PROCEDURE openQueryByCdnEmitente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  OPEN QUERY {&queryName} FOR EACH {&tableName} 
                             WHERE {&tableName}.cdn-emitente >= iCdnEmitenteIni AND
                                   {&tableName}.cdn-emitente <= iCdnEmitenteFim 
                                   NO-LOCK INDEXED-REPOSITION.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByCdnEmitenteCodEstabel DBOProgram 
PROCEDURE openQueryByCdnEmitenteCodEstabel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  OPEN QUERY {&queryName} FOR EACH {&tableName} 
                             WHERE {&tableName}.cdn-emitente >= iCdnEmitenteIni AND
                                   {&tableName}.cdn-emitente <= iCdnEmitenteFim AND
                                   {&tableName}.cod-estabel  >= cCodEstabelIni  AND
                                   {&tableName}.cod-estabel  <= cCodEstabelFim 
                                   USE-INDEX codigo NO-LOCK 
                                   INDEXED-REPOSITION.                                    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByCdnEmitenteCodRMA DBOProgram 
PROCEDURE openQueryByCdnEmitenteCodRMA :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  OPEN QUERY {&queryName} FOR EACH {&tableName} 
                             WHERE {&tableName}.cdn-emitente >= iCdnEmitenteIni AND
                                   {&tableName}.cdn-emitente <= iCdnEmitenteFim AND
                                   {&tableName}.cod-rma      >= cCodRMAIni      AND
                                   {&tableName}.cod-rma      <= cCodRMAFim 
                                   USE-INDEX codigo NO-LOCK 
                                   INDEXED-REPOSITION.                                    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByCodEstabelCodRMA DBOProgram 
PROCEDURE openQueryByCodEstabelCodRMA :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  OPEN QUERY {&queryName} FOR EACH {&tableName} 
                             WHERE {&tableName}.cod-estabel >= cCodEstabelIni AND
                                   {&tableName}.cod-estabel <= cCodEstabelFim AND
                                   {&tableName}.cod-rma     >= cCodRMAIni     AND
                                   {&tableName}.cod-rma     <= cCodRMAFim 
                                   USE-INDEX codigo NO-LOCK 
                                   INDEXED-REPOSITION.                                    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByCodRMA DBOProgram 
PROCEDURE openQueryByCodRMA :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&queryName} FOR EACH {&tableName} 
                               WHERE {&tableName}.cod-rma >= cCodRMAIni AND
                                     {&tableName}.cod-rma <= cCodRMAFim 
                                     NO-LOCK INDEXED-REPOSITION.    
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE searchCustomer DBOProgram 
PROCEDURE searchCustomer :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT-OUTPUT PARAM pcValor AS CHAR NO-UNDO.
DEF VAR iTest AS INT NO-UNDO.

  ASSIGN iTest = int(pcValor) NO-ERROR.
  IF NOT ERROR-STATUS:ERROR THEN do:
     FOR FIRST emitente FIELDS (cod-emitente
                                nome-emit
                                identific) 
        WHERE emitente.cod-emitente = INT(pcValor) AND
              emitente.identific    <> 2 
              USE-INDEX codigo NO-LOCK: END.
  end.            
  ELSE DO:
      FOR FIRST emitente FIELDS (nome-abrev
                                 cod-emitente
                                 nome-emit
                                 identific) 
          WHERE emitente.nome-abrev = pcValor AND
                emitente.identific    <> 2 
                USE-INDEX nome NO-LOCK: END.
                
     IF NOT AVAIL emitente THEN do:
        FOR FIRST emitente FIELDS (cgc
                                   nome-emit
                                   cod-emitente
                                   identific)
            WHERE emitente.cgc = pcValor AND
                  emitente.identific    <> 2 
                  USE-INDEX cgc NO-LOCK: END.  
      END.
  END.              
  
  IF NOT AVAIL emitente THEN DO:
    ASSIGN pcValor = ?.
    RETURN "NOK":U.
  END.

  ASSIGN pcValor = STRING (emitente.cod-emitente).
  
  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByCdnEmitente DBOProgram 
PROCEDURE setConstraintByCdnEmitente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM piCdnEmitenteIni LIKE rma.cdn-emitente.
DEF INPUT PARAM piCdnEmitenteFim LIKE rma.cdn-emitente.

   ASSIGN iCdnEmitenteIni = piCdnEmitenteIni 
          iCdnEmitenteFim = piCdnEmitenteFim.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByCodEstabel DBOProgram 
PROCEDURE setConstraintByCodEstabel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM pcCodEstabelIni LIKE rma.cod-estabel.
DEF INPUT PARAM pcCodEstabelFim LIKE rma.cod-estabel.

   ASSIGN cCodEstabelIni = pcCodEstabelIni 
          cCodEstabelFim = pcCodEstabelFim.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByCodRMA DBOProgram 
PROCEDURE setConstraintByCodRMA :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM pcCodRMAIni LIKE rma.cod-rma.
DEF INPUT PARAM pcCodRMAFim LIKE rma.cod-rma.

   ASSIGN cCodRMAIni = pcCodRMAIni
          cCodRMAFim = pcCodRMAFim.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDefaultsContact DBOProgram 
PROCEDURE setDefaultsContact :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  FIND FIRST rowObject NO-ERROR.
  IF NOT AVAIL rowObject THEN
    RETURN "NOK":U.

  FOR FIRST cont-emit WHERE  
            cont-emit.cod-emitente = rowObject.cdn-emitente  AND
            cont-emit.sequencia    = rowObject.num-seq-cont-emit
            NO-LOCK:
      ASSIGN rowObject.cod-e-mail = cont-emit.e-mail.
  END.

  IF NOT AVAIL cont-emit THEN
    RETURN "NOK":U.

  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDefaultsCurrency DBOProgram 
PROCEDURE setDefaultsCurrency :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR cDate AS CHAR NO-UNDO FORMAT "9999/99".
ASSIGN cDate =  STRING(year(today), "9999") + STRING(MONTH(TODAY), "99").

  FIND FIRST rowObject NO-ERROR.
  IF NOT AVAIL rowObject THEN
    RETURN "NOK":u.
    
  FOR FIRST cotacao WHERE
            cotacao.ano-periodo = cDate  AND
            cotacao.mo-codigo   = rowObject.cod-moeda NO-LOCK:
     ASSIGN rowObject.val-cotacao = cotacao[day(today)].
  END.
  
  IF NOT AVAIL cotacao THEN
    RETURN "NOK":u.
  ELSE
    RETURN "OK":U.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDefaultsCustomer DBOProgram 
PROCEDURE setDefaultsCustomer :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

 FIND FIRST rowObject NO-ERROR.
 IF NOT AVAIL rowObject THEN
   RETURN "NOK":U.   
   
 FOR FIRST emitente USE-INDEX codigo 
     WHERE emitente.cod-emitente = rowObject.cdn-emitente NO-LOCK:
     
   ASSIGN rowObject.cod-entrega = emitente.cod-entrega.
   
   FOR FIRST cont-emit 
       WHERE cont-emit.cod-emitente = emitente.cod-emitente NO-LOCK:
      ASSIGN rowObject.num-seq-cont-emit = cont-emit.sequencia.          
   END.
   
   FOR FIRST tb-preco 
       WHERE tb-preco.nr-tabpre = emitente.nr-tabpre NO-LOCK: 
      ASSIGN rowObject.cod-moeda = tb-preco.mo-codigo.
   END.         
   
   FOR FIRST transporte where
             transporte.cod-transp = emitente.cod-transp NO-LOCK:
      ASSIGN RowObject.cod-transp = transporte.nome-abrev.
   END.  

   RUN setDefaultsShipToAddress. /* Defaults Localiza‡Æo de entrega */
   
 END.
 
 RETURN "OK":U.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDefaultsEnableButtons DBOProgram 
PROCEDURE setDefaultsEnableButtons :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param p-c-botao as char no-undo.

    case p-c-botao:
        when "btEncerra":U then do:
             FOR FIRST param-re WHERE
                       param-re.usuario = cUserName NO-LOCK:

                    IF param-re.log-atualiza-rma <> YES THEN
                       RETURN "NOK":U.   
                
             END.

             IF rowObject.cdn-situacao = 5 then
                RETURN "OK":U.

             RETURN "NOK":U.
        end.
        when "btReativar":U then
                            RETURN "OK":U.
        when "btSuspender":U then
                            RETURN "OK":U.
        when "btCancelar":U then do:
            if rowObject.cdn-situacao = 6 then
              RETURN "NOK":U.
            RETURN "OK":U.      
        end.  
        when "btGerarItens":U then
                            RETURN "OK":U.
        when "btAnalisar":U then
                            RETURN "OK":U.
        when "btAtualizar":U then DO:
            IF rowObject.cdn-situacao = 6 THEN
                 RETURN "NOK":U.
            RETURN "OK":U.
        END.
        when "btUpdate":U then do:
            if rowObject.cdn-situacao = 6 then
              RETURN "NOK":U.          
            RETURN "OK":U.
        end.
        when "btDelete":U then do:
            if rowObject.cdn-situacao = 6 then
              RETURN "NOK":U.
            RETURN "OK":U.
        end.
        when "addSon3":U then do:
          IF rowObject.cdn-situacao = 6 THEN
             RETURN "NOK":U.
          RETURN "OK":U.
        end.
        when "son3Panel":U then do:
          IF NOT CAN-FIND (FIRST rma-desp WHERE
                                 rma-desp.cod-estabel = rowObject.cod-estabel AND
                                 rma-desp.cod-rma     = rowObject.cod-rma) THEN  
              RETURN "NOK":U.
          IF rowObject.cdn-situacao = 6 THEN
              RETURN "NOK":U.             
          RETURN "OK":U.
        end.
        when "addSon4":U then do:
          IF rowObject.cdn-situacao = 6 THEN
             RETURN "NOK":U.
          ELSE
             RETURN "OK":U.
        end.                
        when "son4Panel":U then do:
          IF NOT CAN-FIND (FIRST rma-item WHERE
                                 rma-item.cod-estabel = rowObject.cod-estabel AND
                                 rma-item.cod-rma     = rowObject.cod-rma) THEN do:             
             RETURN "NOK":U.             
          end.
          IF rowObject.cdn-situacao = 6 THEN do:            
             RETURN "NOK":U.
          end.          
          RETURN "OK":U.
        end.
        when "btTotalCredit":U then do:
            /* RMA Autorizado */
            IF rowObject.cdn-situacao <> 5 then
               RETURN "NOK":U.

            /* Permissäes dos usu rios do recebimento */
            FOR FIRST param-re WHERE
                      param-re.usuario = cUserName NO-LOCK:

                    IF param-re.log-atualiza-quant-rma <> YES THEN
                       RETURN "NOK":U.   
            END.
            
            /* Caso algum item possua quantidades ainda entrada no recebimento */
            for each rma-item where
                     rma-item.cod-estabel = RowObject.cod-estabel and
                     rma-item.cod-rma     = RowObject.cod-rma no-lock:
                if not can-find(first rma-it-dep-mov WHERE
                                      rma-it-dep-mov.cod-estabel   = rma-item.cod-estabel   AND
                                      rma-it-dep-mov.cod-rma       = rma-item.cod-rma       AND
                                      rma-it-dep-mov.num-sequencia = rma-item.num-sequencia and 
                                      rma-it-dep-mov.qtd-recebida <> 0 NO-LOCK) then
                    return "NOK":U.
            end.                                                      
            RETURN "OK":U.                                            
        end.
        otherwise return.
    end case.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDefaultsRMA DBOProgram 
PROCEDURE setDefaultsRMA :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /* Estabelecimento */
  FOR FIRST param-estoq NO-LOCK: END.        
  IF NOT AVAIL param-estoq THEN 
    RETURN "NOK":U.
  
  IF rowObject.cod-estabel = "" THEN  
    ASSIGN rowObject.cod-estabel = param-estoq.estabel-pad.  
                        
  FOR FIRST rma-param WHERE
            rma-param.cod-estabel = rowObject.cod-estabel
            NO-LOCK: END.  
  IF NOT AVAIL rma-param THEN 
   RETURN "NOK".                  
  
  ASSIGN rowObject.cod-rma = IF rma-param.log-numeracao-rma-auto THEN  
                               STRING(INT(rma-param.num-ult-rma) + 1, "9999999")
                             ELSE ""
         rowObject.dat-validade        = TODAY
         rowObject.dat-implantacao     = TODAY         
         rowObject.nom-usuar-implant   = cUserName /* Usu rio logado no sistema */
         rowObject.cod-nat-operacao-nc = rma-param.cod-nat-operacao-nc
         rowObject.cod-nat-operacao-nd = rma-param.cod-nat-operacao-nd
         rowObject.cod-nat-operacao-rd = rma-param.cod-nat-operacao-rd
         rowObject.val-restocagem      = rma-param.val-restocagem
         rowObject.val-perc-restocagem = rma-param.val-perc-restocagem
         rowObject.cdn-situacao        = 1
         rowObject.log-e-mail-notas    = NO
         rowObject.log-e-mail-receb    = NO
         rowObject.log-e-mail-remito   = NO        
         .
  
  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDefaultsShipToAddress DBOProgram 
PROCEDURE setDefaultsShipToAddress :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  FIND FIRST rowObject NO-ERROR.
  IF NOT AVAIL rowObject THEN
    RETURN "NOK":u.
    
  FOR FIRST emitente WHERE
            emitente.cod-emitente = rowObject.cdn-emitente NO-LOCK: END.
  IF NOT AVAIL emitente THEN
    RETURN "NOK":U.
    
  FOR FIRST loc-entr WHERE 
            loc-entr.cod-entrega = rowObject.cod-entrega AND
            loc-entr.nome-abrev  = emitente.nome-abrev  NO-LOCK:
    IF substr(loc-entr.char-1,1,12) <> "" THEN 
       ASSIGN rowObject.cod-transp = substr(loc-entr.char-1,1,12).
  END.
  
  IF NOT AVAIL loc-entr THEN
    RETURN "NOK":U.
  ELSE 
    RETURN "OK":U.        

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDisabledFields DBOProgram 
PROCEDURE setDisabledFields :
/*------------------------------------------------------------------------------
  Purpose: De acordo com o evento informado, indica quais campos devem ser
           desbilitados em tela
  Parameters: pTYpe  : A‡Æo (ADD, UPDATE, COPY, DELETE)
              pEvent : Evento que dispara a verifica‡Æo.
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM pType  AS CHAR NO-UNDO.
DEF INPUT PARAM pEvent AS CHAR NO-UNDO.

  RUN clearRowPermissions.  /* Limpa tabela de permissäes */

  FIND FIRST rowObject NO-ERROR.
  IF NOT AVAIL rowObject THEN
    RETURN "NOK":U.

   CASE pEvent:

     /*---- LEAVE-COD-ENTREGA ----*/
     WHEN "leave-cod-entrega":U THEN DO:
        FOR FIRST emitente WHERE
                  emitente.cod-emitente = rowObject.cdn-emitente,
            FIRST loc-entr WHERE
                  loc-entr.cod-entrega = rowObject.cod-entrega AND
                  loc-entr.nome-abrev  = emitente.nome-abrev
                  NO-LOCK: END.     
        IF AVAIL loc-entr THEN DO:          
          RUN createRowPermissions (INPUT "rma":U, INPUT "des-endereco":U).
          RUN createRowPermissions (INPUT "rma":U, INPUT "nom-bairro":U).
          RUN createRowPermissions (INPUT "rma":U, INPUT "nom-cidade":U).
          RUN createRowPermissions (INPUT "rma":U, INPUT "nom-estado":U).
          RUN createRowPermissions (INPUT "rma":U, INPUT "cod-cep":U).
          RUN createRowPermissions (INPUT "rma":U, INPUT "nom-pais":U).
          RUN createRowPermissions (INPUT "rma":U, INPUT "cod-jurisdicao-ent":U).
          RUN createRowPermissions (INPUT "rma":U, INPUT "ds1-endereco-text":U).           
        END.
        FOR FIRST param-re WHERE
                  param-re.usuario = cUserName NO-LOCK:
            IF SUBSTRING(param-re.char-1,11,1) <> "1" THEN
              RUN createRowPermissions (INPUT "rma":U, INPUT "lEstornaComissao":U).      
        END.
     END.     
     
     /*---- LEAVE-COD-ESTABEL ----*/
     WHEN "leave-cod-estabel":U THEN DO:     
        RUN checkNumberingType.              /* Retorna o tipo de numera‡Æo */
        IF RETURN-VALUE = "AUTO":U THEN      /* Numera‡Æo Autom tica ? */
           RUN createRowPermissions (INPUT "rma":U, INPUT "cod-rma":U).      
     END.     
   END CASE.

  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE splitRMAExpenses DBOProgram 
PROCEDURE splitRMAExpenses :
/*------------------------------------------------------------------------------
  Purpose: Ratear despesas do RMA entre os itens
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR deSaldo        AS DEC NO-UNDO.
DEF VAR deLinhasTotal  AS DEC NO-UNDO.
DEF VAR dePesoRMA      AS DEC NO-UNDO.
DEF VAR deTotalMercRMA AS DEC NO-UNDO.
DEF VAR iLinhasRMA     AS INT NO-UNDO.
DEF VAR deValorDespesa AS DEC NO-UNDO.
DEF VAR dePesoItemRMA  AS DEC NO-UNDO.

  RUN blankRMAExpenses.  /* Zera as despesas */
  
  RUN calcRMAWeight   (OUTPUT dePesoRMA).      /* Total de Peso */
  RUN calcRMALinesNr  (OUTPUT iLinhasRMA).     /* Total de Linhas */
  RUN calcRMAGoodsTot (OUTPUT deTotalMercRMA). /* Total de Mercadorias (Valor) */

    FOR EACH rma-desp WHERE
             rma-desp.cod-estabel = rma.cod-estabel AND
             rma-desp.cod-rma     = rma.cod-rma 
             NO-LOCK,
       FIRST despesa WHERE
             despesa.cod-despesa = rma-desp.cod-despesa 
             NO-LOCK:                    
 
         
            /* Inicializa vari vel para totaliza‡Æo de linhas da nota */
            ASSIGN deLinhasTotal = 0
            /* Calcula o valor da despesa (caso seja por percentual) */
                   deValorDespesa = IF despesa.cdn-tp-calculo = 1 THEN          
                                         (TRUNC(rma-desp.val-per-desp / 100, 2) * rma.val-tot-rma)
                                    ELSE 
                                         rma-desp.val-despesa
                   deSaldo = deValorDespesa.
    
            /* Peso */
            IF despesa.cdn-tp-rateio = 3 AND
               dePesoRMA             > 0 THEN DO:               
                  FOR EACH rma-item WHERE
                           rma-item.cod-estabel = rma-desp.cod-estabel AND
                           rma-item.cod-rma     = rma-desp.cod-rma     
                           EXCLUSIVE-LOCK,
                     FIRST item WHERE
                           item.it-codigo = rma-item.cod-item 
                           NO-LOCK:
                          
                        ASSIGN dePesoItemRMA  = (rma-item.qtd-a-receber * item.peso-bruto).
         
                        ASSIGN rma-item.val-despes-it = rma-item.val-despes-it + TRUNC((dePesoItemRMA / dePesoRMA) * deValorDespesa, 2)
                               deSaldo                = deSaldo - TRUNC((dePesoItemRMA / dePesoRMA) * deValorDespesa, 2).
                END.                
            END.
    
            ELSE DO:
                /* Valor */
                IF despesa.cdn-tp-rateio = 1 THEN DO:              
                
                    FOR EACH rma-item WHERE
                             rma-item.cod-estabel = rma-desp.cod-estabel AND
                             rma-item.cod-rma     = rma-desp.cod-rma
                             EXCLUSIVE-LOCK:
                           
                          ASSIGN rma-item.val-despes-it = rma-item.val-despes-it + trunc((rma-item.vl-merc-liq / deTotalMercRMA) * deValorDespesa, 2)
                                 deSaldo                = deSaldo - trunc((rma-item.vl-merc-liq / deTotalMercRMA) * deValorDespesa, 2).
                    END.
                END.
                ELSE DO:
                    /* Linhas do RMA */  
                 
                    FOR EACH rma-item WHERE
                             rma-item.cod-estabel = rma-desp.cod-estabel AND
                             rma-item.cod-rma     = rma-desp.cod-rma
                             EXCLUSIVE-LOCK:                             
        
                        /* Quando o rateio for por linhas do rma, dividir o valor da despesa pelo n£mero de itens */    
                 
                        ASSIGN rma-item.val-despes-it = rma-item.val-despes-it + trunc(deValorDespesa / iLinhasRMA, 2)
                               deSaldo                = deSaldo - trunc(deValorDespesa / iLinhasRMA, 2).                               
                    END.
                END.
            END.
            
            IF deSaldo > 0 THEN DO:
                FIND LAST rma-item WHERE
                          rma-item.cod-estabel = rma.cod-estabel AND
                          rma-item.cod-rma     = rma.cod-rma
                          EXCLUSIVE-LOCK NO-ERROR.
                IF AVAIL rma-item THEN
                   ASSIGN rma-item.val-despes-it = rma-item.val-despes-it + deSaldo.    
            END.        
            
    END.
    
  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE storeLastRMANumber DBOProgram 
PROCEDURE storeLastRMANumber :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEF INPUT PARAM c-cod-estabel LIKE rma-param.cod-estabel NO-UNDO.

   FOR FIRST rma-param WHERE
             rma-param.cod-estabel = c-cod-estabel 
             EXCLUSIVE-LOCK: 
      IF rma-param.log-numeracao-rma-auto THEN
         ASSIGN rma-param.num-ult-rma = STRING(rowObject.cod-rma).
   END.
  
   IF NOT AVAIL rma-param THEN      
      RETURN "NOK":U.   
   ELSE DO:
       RELEASE rma-param.
       RETURN "OK":U.
   END.
      
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sumRMA DBOProgram 
PROCEDURE sumRMA :
/*------------------------------------------------------------------------------
  Purpose:  Totaliza todos os itens, rateia despesas e totaliza o RMA
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR h-boin719 AS HANDLE NO-UNDO.

  /* Totaliza Itens */
  IF NOT VALID-HANDLE(h-boin719) OR
     h-boin719:TYPE <> "PROCEDURE":U OR
     h-boin719:FILE-NAME <> "inbo/boin719.p":U THEN DO:      
      RUN inbo/boin719 PERSISTENT SET h-boin719.
      RUN linkToRMA       IN h-boin719 (INPUT THIS-PROCEDURE).
      RUN openQueryStatic IN h-boin719 (INPUT "RMA":U).
  END.

  /* Desliga as valida‡äes */
  RUN toggleValidation IN h-boin719 (INPUT NO).
  
  RUN getFirst IN h-boin719.

  DO WHILE RETURN-VALUE <> "NOK":U:
    RUN sumRMAItem   IN h-boin719.
    RUN updateRecord IN h-boin719.

    IF RETURN-VALUE = "OK":U THEN do:    
      RUN getNext      IN h-boin719. 
    END.
    ELSE DO:
      RUN getRowErrors IN h-boin719 (OUTPUT TABLE rowErrors).
      DELETE PROCEDURE h-boin719.
      RETURN "NOK":U.
    END.
  END.
  
  DELETE PROCEDURE h-boin719.  
  /* Totaliza Itens */
    
  FOR EACH rma-item WHERE
           rma-item.cod-estabel = rma.cod-estabel AND
           rma-item.cod-rma     = rma.cod-rma 
           NO-LOCK:
       ACCUMULATE rma-item.val-tot-item-rma (TOTAL).
  END.
  
  FIND CURRENT rma EXCLUSIVE-LOCK NO-ERROR.  /* Muda o LOCK do registro */
  ASSIGN rma.val-tot-rma = ACCUM TOTAL rma-item.val-tot-item-rma.  
  
  RUN splitRMAExpenses. 
  
  IF RETURN-VALUE <> "OK":U THEN
    RETURN "NOK":U.  
    
  RETURN "OK":U.
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
  
    /* C¢digo RMA */
    IF rowObject.cod-rma = "" OR
       rowObject.cod-rma = ? THEN DO:
              /* Inicio -- Projeto Internacional */
              DEFINE VARIABLE c-lbl-liter-codigo-rma AS CHARACTER NO-UNDO.
              {utp/ut-liter.i "C¢digo_RMA" *}
              ASSIGN c-lbl-liter-codigo-rma = TRIM(RETURN-VALUE).
              {method/svc/errors/inserr.i
                      &ErrorNumber="164"
                      &ErrorType="EMS"
                      &ErrorSubType="Error"
                      &ErrorParameters="c-lbl-liter-codigo-rma"}
                      RETURN "NOK":U.                      
    END.
    
    IF pType = "CREATE":U OR pType = "UPDATE":U THEN DO:    
        IF pType = "CREATE":U THEN DO:
          /* Parƒmetro RMA */  
          IF NOT CAN-FIND (FIRST rma-param WHERE
                                 rma-param.cod-estabel = rowObject.cod-estabel) THEN DO:
               /* Inicio -- Projeto Internacional */
               DEFINE VARIABLE c-lbl-liter-parametro-rma-para-o-estabelec AS CHARACTER NO-UNDO.
               {utp/ut-liter.i "Parƒmetro_RMA_para_o_Estabelecimento" *}
               ASSIGN c-lbl-liter-parametro-rma-para-o-estabelec = TRIM(RETURN-VALUE).
               {method/svc/errors/inserr.i
                       &ErrorNumber="2"
                       &ErrorType="EMS"
                       &ErrorSubType="Error"
                       &ErrorParameters="c-lbl-liter-parametro-rma-para-o-estabelec"}
                       RETURN "NOK":U.
          END.
        END.
        
        IF pType = "UPDATE":U THEN DO:
          /* Situa‡Æo RMA nÆo permite altera‡Æo */
          IF rowObject.cdn-situacao = 6 THEN DO:
               /* Inicio -- Projeto Internacional */
               DEFINE VARIABLE c-lbl-liter-do-rma AS CHARACTER NO-UNDO.
               {utp/ut-liter.i "do_RMA" *}
               ASSIGN c-lbl-liter-do-rma = TRIM(RETURN-VALUE).
               {method/svc/errors/inserr.i
                       &ErrorNumber="19247"
                       &ErrorType="EMS"
                       &ErrorSubType="Error"
                       &ErrorParameters="c-lbl-liter-do-rma"}          
                       RETURN "NOK":U.
          END.
        END.
        
        /* Cliente */
        IF NOT CAN-FIND (FIRST emitente WHERE
                               emitente.cod-emitente = rowObject.cdn-emitente AND
                               emitente.identific    <> 2) THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-cliente AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Cliente" *}
            ASSIGN c-lbl-liter-cliente = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorSubType="Error"
                    &ErrorParameters="c-lbl-liter-cliente"}
                    RETURN "NOK":U.
        END.

        /* Contato do Cliente */
        IF NOT CAN-FIND (FIRST cont-emit WHERE
                               cont-emit.cod-emitente = rowObject.cdn-emitente       AND
                               cont-emit.sequencia    = rowObject.num-seq-cont-emit) THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-contato-cliente AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Contato_Cliente" *}
            ASSIGN c-lbl-liter-contato-cliente = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorSubType="Error"
                    &ErrorParameters="c-lbl-liter-contato-cliente"}
                    RETURN "NOK":U.
        END.
        
        /* E-mail do contato do cliente */
        IF (rowObject.log-e-mail-notas OR
            rowObject.log-e-mail-receb OR
            rowObject.log-e-mail-remito) AND
            rowObject.cod-e-mail = "" THEN DO:
            /* Se envia e-mail, o contato deve ter seu e-mail preenchido */
            {method/svc/errors/inserr.i
                    &ErrorNumber="27678"
                    &ErrorType="EMS"
                    &ErrorSubType="Error"}
                    RETURN "NOK":U.
        END.
           
        /* Natureza de cr‚dito */
        FOR FIRST natur-oper WHERE 
                  natur-oper.nat-operacao = rowObject.cod-nat-operacao-nc NO-LOCK: END.
                  
        IF NOT AVAIL natur-oper THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-natureza-de-credito AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Natureza_de_Cr‚dito" *}
            ASSIGN c-lbl-liter-natureza-de-credito = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorSubType="Error"
                    &ErrorParameters="c-lbl-liter-natureza-de-credito"}                                   
        END.                           
        ELSE IF natur-oper.tipo = 3 THEN DO:                           
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-natureza-credito-rma AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "natureza_cr‚dito_RMA" *}
            ASSIGN c-lbl-liter-natureza-credito-rma = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-entrada-ou-saida AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Entrada_ou_Sa¡da" *}
            ASSIGN c-lbl-liter-entrada-ou-saida = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                    &ErrorNumber="18440"
                    &ErrorType="EMS"
                    &ErrorSubType="Error"
                    &ErrorParameters="c-lbl-liter-natureza-credito-rma + '~~~~' + c-lbl-liter-entrada-ou-saida"}
        END.                           
                               
        /* Natureza de d‚bito */
        FOR FIRST natur-oper WHERE 
                  natur-oper.nat-operacao = rowObject.cod-nat-operacao-nd NO-LOCK: END.
                  
        IF NOT AVAIL natur-oper THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-natureza-de-debito AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Natureza_de_D‚bito" *}
            ASSIGN c-lbl-liter-natureza-de-debito = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorSubType="Error"
                    &ErrorParameters="c-lbl-liter-natureza-de-debito"}                                   
        END.                           
        ELSE IF natur-oper.tipo <> 2 THEN DO:                           
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-natureza-debito-rma AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "natureza_d‚bito_RMA" *}
            ASSIGN c-lbl-liter-natureza-debito-rma = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                    &ErrorNumber="27021"
                    &ErrorType="EMS"
                    &ErrorSubType="Error"
                    &ErrorParameters="c-lbl-liter-natureza-debito-rma"}
        END.                           
        
        /* Natureza remito devolu‡Æo */
        FOR FIRST natur-oper WHERE 
                  natur-oper.nat-operacao = rowObject.cod-nat-operacao-rd NO-LOCK: END.
                  
        IF NOT AVAIL natur-oper THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-natureza-remito-devolucao AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Natureza_Remito_Devolu‡Æo" *}
            ASSIGN c-lbl-liter-natureza-remito-devolucao = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorSubType="Error"
                    &ErrorParameters="c-lbl-liter-natureza-remito-devolucao"}                                   
        END.                           
        ELSE IF natur-oper.tipo <> 2 THEN DO:                           
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-natureza-remito-devolucao-2 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "natureza_remito_devolu‡Æo" *}
            ASSIGN c-lbl-liter-natureza-remito-devolucao-2 = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                    &ErrorNumber="27021"
                    &ErrorType="EMS"
                    &ErrorSubType="Error"
                    &ErrorParameters="c-lbl-liter-natureza-remito-devolucao-2"}
        END.                                                   
        
        /* Contato */
        IF rowObject.num-seq-cont-emit = 0 THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-contato AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Contato" *}
            ASSIGN c-lbl-liter-contato = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                    &ErrorNumber="164"
                    &ErrorType="EMS"
                    &ErrorSubType="Error"
                    &ErrorParameters="c-lbl-liter-contato"}    
        END.
        
        /* Entrega */
        IF rowObject.cod-entrega <> "" THEN DO:
          IF NOT CAN-FIND (FIRST loc-entr WHERE loc-entr.cod-entrega = rowObject.cod-entrega) THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-table.i mgadm loc-entr 1} /* Busca o label da tabela */
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorSubType="Error"
                    &ErrorParameters=TRIM(RETURN-VALUE)}
          END.
        END.
        
        /* Moeda */  
        IF NOT CAN-FIND (FIRST moeda WHERE moeda.mo-codigo = rowObject.cod-moeda) THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-table.i mguni moeda 1} /* Busca o label da tabela */
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorSubType="Error"
                    &ErrorParameters=TRIM(RETURN-VALUE)}
     
        END.
        
        /* Transportadora */
        IF NOT CAN-FIND (FIRST transporte WHERE
                               transporte.nome-abrev = rowObject.cod-transp) THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-table.i mgadm transporte 1} /* Busca o label da tabela */
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorSubType="Error"
                    &ErrorParameters=TRIM(RETURN-VALUE)}
        END.
        

    END.
    ELSE 
      IF pType = "DELETE":U THEN DO:
        IF CAN-FIND (FIRST rma-it-dep-mov WHERE
                           rma-it-dep-mov.cod-estabel = rowObject.cod-estabel AND
                           rma-it-dep-mov.cod-rma     = rowObject.cod-rma) THEN DO:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-rma AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "RMA" *}
                ASSIGN c-lbl-liter-rma = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                        &ErrorNumber="3"
                        &ErrorType="EMS"
                        &ErrorSubType="Error"
                        &ErrorParameters="c-lbl-liter-rma"}
        END.
      END.      
    
    /*--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    ELSE DO:
        IF pType = "CREATE":U THEN DO:
            IF CAN-FIND (FIRST bf{&tableName} WHERE
                         bf{&tableName}.cod-estabel = rowObject.cod-estabel AND
                         bf{&tableName}.cod-rma     = rowObject.cod-rma)    THEN DO:
                FOR FIRST rma-param NO-LOCK
                    WHERE rma-param.cod-estabel = RowObject.cod-estabel:
                    IF rma-param.log-numeracao-rma-auto THEN DO:
                        ASSIGN rowObject.cod-rma = STRING(INT(rma-param.num-ult-rma) + 1, "9999999").

                        CREATE RowErrors.
                        ASSIGN RowErrors.ErrorSequence    = RowErrors.ErrorSequence + 1 
                               RowErrors.ErrorNumber      = 32663
                               RowErrors.ErrorSubType     = "warning"
                               RowErrors.ErrorParameters  = rowObject.cod-rma.
                         
                         RUN storeLastRMANumber (INPUT rowObject.cod-estabel).
                    END.
                END.
            END.
        END.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
