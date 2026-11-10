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
{include/i-prgvrs.i BOIN719 2.00.00.030 } /*** "010030" 29/11/2023 09:07:15  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin719 MUT}
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

/* PrÇ-processadores de release */
{cdp/cdcfgmat.i} 
{cdp/cdcfgdis.i} 

/*--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN719
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName rma-item
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

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

/* Campos livres */
&IF DEFINED(bf_mat_versao_ems) &THEN 
  &IF {&bf_mat_versao_ems} >= 2.05 &THEN
    &GLOBAL-DEFINE log-recebe-mercad log-recebe-mercad 
  &ELSE
    &GLOBAL-DEFINE log-recebe-mercad log-livre-2
&ENDIF
&ENDIF

/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin719.i RowObject}
{inbo/boin716.i tt-rma-it-dep}
{inbo/boin716.i tt-rma-it-dep-del}

/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}

/*--- Definiá∆o das temp-tables ---*/
{inbo/boin714.i2 rowPermissions}

DEF TEMP-TABLE tt-total NO-UNDO
  FIELD deTrocas      AS DEC
  FIELD deDespesas    AS DEC
  FIELD deRestocagem  AS DEC
  FIELD deCreditos    AS DEC
  FIELD deDebitos     AS DEC
  FIELD deCred-Deb    AS DEC
  .

/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/*--- Definiá‰es das vari†veis locais ---*/

{cdp/cd4300.i3}  /* Vari†veis para o cd4300.i4  */
{cdp/cd0101.i50} /* Vari†veis para o cd0101.i51 */

{cdp/cdunif001.i} /* Vari†veis da unificaá∆o de conceito Conta Cont†bil e Centro de Custo */

DEF VAR cCodEstabel       LIKE rma-item.cod-estabel      NO-UNDO.
DEF VAR cCodRma           LIKE rma-item.cod-rma          NO-UNDO.
DEF VAR deRMAItDepQty     LIKE rma-it-dep.qtd-a-receber  NO-UNDO.
DEF VAR lValidate         AS LOGICAL INITIAL YES         NO-UNDO.
DEF VAR lValidRMAItDepQty AS LOGICAL INITIAL NO          NO-UNDO.
DEF VAR hParentHandle     AS HANDLE                      NO-UNDO.
DEF VAR iEmpresa          LIKE param-global.empresa-prin NO-UNDO.
DEF VAR cUserName         AS CHAR                        NO-UNDO.

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
         HEIGHT             = 2.04
         WIDTH              = 33.57.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE activateRMAItDepQtyValid DBOProgram 
PROCEDURE activateRMAItDepQtyValid :
/*------------------------------------------------------------------------------
  Purpose: Ativa a validaá∆o de tela da Quantidade alocada a dep¢sitos
           no RE3205 - Implantaá∆o/Modificaá∆o Item RMA.
           
  Parameters: plValidRMAItDepQty : Ativa a validaá∆o?
              pdeRMAItDepQty     : Valor que a quantidade deve ter

  Notes: MÇtodo exclusivo para o RE3205
------------------------------------------------------------------------------*/
DEF INPUT PARAM plValidRMAItDepQty AS LOGICAL                    NO-UNDO.
DEF INPUT PARAM pdeRMAItDepQty     LIKE rma-it-dep.qtd-a-receber NO-UNDO.

  ASSIGN lValidRMAItDepQty = plValidRMAItDepQty
         deRMAItDepQty     = pdeRMAItDepQty.
  
  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram 
PROCEDURE afterCreateRecord :
/*------------------------------------------------------------------------------
  Purpose: 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   IF NOT AVAIL rma THEN 
      RETURN "NOK":U.  
      
  RUN updateRMAStatus.

  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDeleteRecord DBOProgram 
PROCEDURE afterDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose: 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  RUN updateRMAStatus.
   
  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterNewRecord DBOProgram 
PROCEDURE afterNewRecord :
/*------------------------------------------------------------------------------
  Purpose: Localiza o Çltimo item do RMA corrente e incrementa a sequencia 
           na criaá∆o do registro de acordo com os parÉmetros do RMA
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  FIND FIRST rowObject NO-ERROR.
  IF NOT AVAIL rowObject THEN
    RETURN "NOK":U.
    
  FOR FIRST rma-param WHERE 
            rma-param.cod-estabel = rma.cod-estabel 
            NO-LOCK: END.
  IF NOT AVAIL rma-param THEN 
    RETURN "NOK":U.

  /* £ltimo item do RMA corrente */    
  FOR LAST bf{&tableName} WHERE 
           bf{&tableName}.cod-estabel = cCodEstabel AND
           bf{&tableName}.cod-rma     = cCodRma  
           USE-INDEX rma-item NO-LOCK: END.
 
  ASSIGN rowObject.num-sequencia = (IF AVAIL bf{&tableName} THEN 
                                     bf{&tableName}.num-sequencia 
                                    ELSE 0)
                                   + 
                                   rma-param.vli-incremento-seq
         rowObject.val-restocagem      = rma.val-restocagem
         rowObject.val-perc-restocagem = rma.val-perc-restocagem.
         
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

  IF NOT AVAIL rma THEN
    RETURN "NOK":U.
    
 RUN updateRMAStatus.
  
 RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDeleteRecord DBOProgram 
PROCEDURE beforeDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose: Remove tabelas relacionadas.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  /*** rma-it-dep ***/
  FOR EACH rma-it-dep WHERE
           rma-it-dep.cod-estabel = rowObject.cod-estabel    AND
           rma-it-dep.cod-rma     = rowObject.cod-rma        AND
           rma-it-dep.num-sequencia = rowObject.num-sequencia
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
  
  /*** rma-it-dep-mov ***/
  /*---------------------------------------------------------**
  ** Nota: Quando o RMA for do tipo recebimento n∆o f°sico,  **
  **       o movimento de recebimento Ç fict°cio. Portanto,  **
  **       dever† ser removido na exclus∆o do registro       **
  **       rma-item                                          ** 
  **---------------------------------------------------------*/
           
  FOR EACH rma-it-dep-mov WHERE
           rma-it-dep-mov.cod-estabel   = rowObject.cod-estabel    AND
           rma-it-dep-mov.cod-rma       = rowObject.cod-rma        AND
           rma-it-dep-mov.num-sequencia = rowObject.num-sequencia
           EXCLUSIVE-LOCK
           ON ERROR UNDO, LEAVE:
     DELETE rma-it-dep-mov.
  END.
  IF LOCKED (rma-it-dep-mov) THEN DO:
     {method/svc/errors/inserr.i &ErrorNumber="4"
                                  &ErrorType="INTERNAL"
                                  &ErrorSubType="ERROR"}
      RETURN "NOK":U.
  END.
  

  /*** rma-it-troca ***/
  FOR EACH rma-it-troca WHERE
           rma-it-troca.cod-estabel = rowObject.cod-estabel   AND
           rma-it-troca.cod-rma     = rowObject.cod-rma       AND
           rma-it-troca.num-sequencia = rowObject.num-sequencia
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

  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calcOpenValue DBOProgram 
PROCEDURE calcOpenValue :
/*------------------------------------------------------------------------------
  Purpose: Calcular valor em aberto
  Parameters:  <none>
  Notes: Se o saldo for negativo, retorna "NOK" e saldo 0.
------------------------------------------------------------------------------*/
DEF OUTPUT PARAM pDeOpenQty LIKE rma-item.qtd-a-receber NO-UNDO.

DEF VAR deQtyRecvd LIKE rma-item.qtd-a-receber NO-UNDO.

  RUN calcRcvdQty (OUTPUT deQtyRecvd).
        
  ASSIGN pDeOpenQty = rowObject.qtd-a-receber - 
                      rowObject.qtd-cancelada - 
                      deQtyRecvd.
  
  IF pDeOpenQty < 0 THEN DO:
    ASSIGN pDeOpenQty = 0.
    RETURN "NOK":U.
  END.
    
  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calcRcvdQty DBOProgram 
PROCEDURE calcRcvdQty :
/*------------------------------------------------------------------------------
  Purpose: Calcular quantidade j† recebida
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF OUTPUT PARAM pDeRcvdQty LIKE rma-item.qtd-a-receber NO-UNDO.

    FOR EACH rma-it-dep-mov WHERE
             rma-it-dep-mov.cod-estabel   = rowObject.cod-estabel   AND
             rma-it-dep-mov.cod-rma       = rowObject.cod-rma       AND
             rma-it-dep-mov.num-sequencia = rowObject.num-sequencia NO-LOCK:
         ACCUMULATE rma-it-dep-mov.qtd-recebida (TOTAL).
    END.  
    ASSIGN pDeRcvdQty = (ACCUM TOTAL rma-it-dep-mov.qtd-recebida).  

  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calcTotals DBOProgram 
PROCEDURE calcTotals :
/*------------------------------------------------------------------------------
  Purpose: Calcular totais de estat°stica
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF OUTPUT PARAM TABLE FOR tt-total.

  FOR EACH tt-total:
    DELETE tt-total.
  END.

  FIND FIRST rowObject NO-ERROR.
  IF NOT AVAIL rowObject THEN 
    RETURN "NOK":U.
    
  /**** Total de trocas ****/
  IF rowObject.cdn-tipo = 1 THEN 
     FOR EACH rma-it-troca WHERE 
              rma-it-troca.cod-estabel   = rowObject.cod-estabel     AND
              rma-it-troca.cod-rma       = rowObject.cod-rma         AND
              rma-it-troca.num-sequencia = rowObject.num-sequencia NO-LOCK:
          ACCUMULATE (rma-it-troca.qtd-pedida * rma-it-troca.val-preuni) (TOTAL).
     END.
  
  CREATE tt-total.

  ASSIGN /**** Total de trocas ****/
         tt-total.deTrocas      = IF rowObject.cdn-tipo = 1 THEN 
                                    (ACCUM TOTAL rma-it-troca.qtd-pedida * rma-it-troca.val-preuni)
                                  ELSE 0
         
         /**** Total de restocagem ****/
         tt-total.deRestocagem  = (IF rowObject.val-perc-restocagem > 0 THEN
                                     ((rowObject.val-perc-restocagem / 100) * rowObject.vl-merc-liq)
                                   ELSE 0)
         tt-total.deRestocagem  = tt-total.deRestocagem + 
                                  (rowObject.val-restocagem * 
                                  (rowObject.qtd-a-receber - rowObject.qtd-cancelada))
         
         /**** CrÇditos e dÇbitos ****/
         tt-total.deCreditos    = (rowObject.qtd-creditada * rowObject.val-preuni)
         tt-total.deDebitos     = rowObject.val-despes-it +
                                  tt-total.deTrocas       +
                                  tt-total.deRestocagem
         tt-total.deCred-Deb    = tt-total.deCreditos - 
                                  tt-total.deDebitos.
    
  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cancelRMAItemOpenQty DBOProgram 
PROCEDURE cancelRMAItemOpenQty :
/*------------------------------------------------------------------------------
  Purpose: Cancelar a quantidade em aberto do item do RMA, abatendo das reservas
           de estoque a quantidade ainda n∆o recebida.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR deOpenQty         LIKE rma-item.qtd-a-receber NO-UNDO.
DEF VAR deQtyRvcdRMAItDep LIKE rma-item.qtd-a-receber NO-UNDO.
DEF VAR deRMAOpenQty      LIKE rma-item.qtd-a-receber NO-UNDO.
DEF VAR h-boin716         AS   HANDLE                 NO-UNDO.

  FIND FIRST rowObject NO-ERROR.
  IF NOT AVAIL rowObject THEN 
    RETURN "NOK":U.
  
  /* Valor em aberto */
  RUN calcOpenValue (OUTPUT deOpenQty).
  
  IF deOpenQty > 0 THEN DO:
    ASSIGN rowObject.qtd-cancelada    = rowObject.qtd-cancelada +
                                        deOpenQty
           rowObject.dat-cancelamento = today
           .  
    
    /*** Cancelamento de saldo destinado a dep¢sito ***/
    IF NOT VALID-HANDLE(h-boin716) OR
       h-boin716:TYPE <> "PROCEDURE":U OR
       h-boin716:FILE-NAME <> "inbo/boin716.p":U THEN DO:      
        RUN inbo/boin716.p PERSISTENT SET h-boin716.
        RUN linkToRMAItem   IN h-boin716 (INPUT THIS-PROCEDURE).
        RUN openQueryStatic IN h-boin716 (INPUT "RMAItem":U).
    END.
    
    /* Limpa as tabelas tempor†rias */
    RUN clearTTRMAItDep    IN h-boin716.
    RUN clearTTRMAItDepDel IN h-boin716.
    
    /* Para todas as reservas de estoque do item, 
       abater a quantidade em aberto da quantidade 
       a receber. */
       
    RUN getFirst IN h-boin716.
    DO WHILE RETURN-VALUE <> "NOK":U:  
       RUN cancelRMAItDepOpenQty IN h-boin716.       
       IF RETURN-VALUE = "OK":U THEN
          RUN getNext      IN h-boin716.    
       ELSE DO:
          RUN getRowErrors IN h-boin716 (OUTPUT TABLE rowErrors).
          DELETE PROCEDURE h-boin716.
          RETURN "NOK":U.
       END.               
    END.
    
    /* Retorna dados processados do DBO */
    RUN getTTRMAItDep    IN h-boin716 (OUTPUT TABLE tt-rma-it-dep).
    RUN getTTRMAItDepDel IN h-boin716 (OUTPUT TABLE tt-rma-it-dep-del).    

    DELETE PROCEDURE h-boin716.  
  END.
  
  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE changeRMAItemStatus DBOProgram 
PROCEDURE changeRMAItemStatus :
/*------------------------------------------------------------------------------
  Purpose: Mudar situaá∆o do rma-item
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM piStatus LIKE rma.cdn-situacao NO-UNDO.

  FIND FIRST rowObject NO-ERROR.
  IF NOT AVAIL rowObject THEN
    RETURN "NOK":U.
  
  ASSIGN rowObject.cdn-situacao = piStatus.

  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkIfCreditednReturnedQtyAreFilled DBOProgram 
PROCEDURE checkIfCreditednReturnedQtyAreFilled :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR deRMAItemRcvdQty LIKE rma-item.qtd-a-receber NO-UNDO.

  IF NOT AVAIL rowObject THEN 
    RETURN "NOK":U.
    
  RUN calcRcvdQty (OUTPUT deRMAItemRcvdQty).  
  
  /* Caso algum item possua quantidades ainda n∆o devidamente preenchidas */
  IF CAN-FIND (FIRST rma-item WHERE 
                     rma-item.cod-estabel = rowObject.cod-estabel and
                     rma-item.cod-rma     = rowObject.cod-rma     and
                     (rma-item.qtd-devolver + 
                      rma-item.qtd-cancelada) < deRMAItemRcvdQty) THEN
     RETURN "NOK":U.                       
    
  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findRMA DBOProgram 
PROCEDURE findRMA :
/*------------------------------------------------------------------------------
  Purpose: Localiza registro de RMA
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM pcCodEstabel LIKE rma.cod-estabel NO-UNDO.
DEF INPUT PARAM pcCodRMA     LIKE rma.cod-rma     NO-UNDO.

  FOR FIRST rma WHERE
            rma.cod-estabel = pcCodEstabel AND
            rma.cod-rma     = pcCodRMA NO-LOCK: END.
  
  IF NOT AVAIL rma THEN
    RETURN "NOK":U.

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
        WHEN "cod-avaliacao":U THEN ASSIGN pFieldValue = RowObject.cod-avaliacao.
        WHEN "cod-disposicao":U THEN ASSIGN pFieldValue = RowObject.cod-disposicao.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-item":U THEN ASSIGN pFieldValue = RowObject.cod-item.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-motivo":U THEN ASSIGN pFieldValue = RowObject.cod-motivo.
        WHEN "cod-nat-operacao":U THEN ASSIGN pFieldValue = RowObject.cod-nat-operacao.
        WHEN "cod-nota-fis-orig":U THEN ASSIGN pFieldValue = RowObject.cod-nota-fis-orig.
        WHEN "cod-pedcli":U THEN ASSIGN pFieldValue = RowObject.cod-pedcli.
        WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
        WHEN "cod-rma":U THEN ASSIGN pFieldValue = RowObject.cod-rma.
        WHEN "cod-serie-orig":U THEN ASSIGN pFieldValue = RowObject.cod-serie-orig.
        WHEN "cod-tabpre":U THEN ASSIGN pFieldValue = RowObject.cod-tabpre.
        WHEN "cod-un":U THEN ASSIGN pFieldValue = RowObject.cod-un.
        WHEN "ds1-item":U THEN ASSIGN pFieldValue = RowObject.ds1-item.
        WHEN "ct-codigo":U THEN ASSIGN pFieldValue = RowObject.ct-codigo.
        WHEN "sc-codigo":U THEN ASSIGN pFieldValue = RowObject.sc-codigo.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCustShortName DBOProgram 
PROCEDURE getCustShortName :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF OUTPUT PARAM pcNomeAbrevEmit LIKE emitente.nome-abrev NO-UNDO.

  FOR FIRST emitente WHERE
            emitente.cod-emitente = rma.cdn-emitente NO-LOCK: 
      ASSIGN pcNomeAbrevEmit = emitente.nome-abrev.            
      RETURN "OK":U.
  END.  
  
  IF NOT AVAIL emitente THEN   
    RETURN "NOK":U.
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
        WHEN "dat-cancelamento":U THEN ASSIGN pFieldValue = RowObject.dat-cancelamento.
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
        WHEN "qtd-cancelada":U THEN ASSIGN pFieldValue = RowObject.qtd-cancelada.
        WHEN "qtd-creditada":U THEN ASSIGN pFieldValue = RowObject.qtd-creditada.
        WHEN "qtd-devolver":U THEN ASSIGN pFieldValue = RowObject.qtd-devolver.
        WHEN "val-despes-it":U THEN ASSIGN pFieldValue = RowObject.val-despes-it.
        WHEN "val-imposto":U THEN ASSIGN pFieldValue = RowObject.val-imposto.
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
        WHEN "val-perc-restocagem":U THEN ASSIGN pFieldValue = RowObject.val-perc-restocagem.
        WHEN "val-pretab":U THEN ASSIGN pFieldValue = RowObject.val-pretab.
        WHEN "val-preuni":U THEN ASSIGN pFieldValue = RowObject.val-preuni.
        WHEN "val-restocagem":U THEN ASSIGN pFieldValue = RowObject.val-restocagem.
        WHEN "val-tot-item-rma":U THEN ASSIGN pFieldValue = RowObject.val-tot-item-rma.
        WHEN "vl-merc-liq":U THEN ASSIGN pFieldValue = RowObject.vl-merc-liq.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getExpense DBOProgram 
PROCEDURE getExpense :
/*------------------------------------------------------------------------------
  Purpose: Retorna para a interface a descriá∆o da despesa do RMA
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT  PARAM cCodDespesa LIKE despesa.cod-despesa NO-UNDO.
DEF OUTPUT PARAM cDesDespesa LIKE despesa.des-despesa NO-UNDO.

  FOR FIRST despesa FIELDS (cod-despesa
                            des-despesa) WHERE
            despesa.cod-despesa = cCodDespesa
            NO-LOCK:
      ASSIGN cDesDespesa = despesa.des-despesa.
  END.
  
  IF AVAIL despesa THEN 
    RETURN "OK":U.
  ELSE
    RETURN "NOK":U.
    
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
        WHEN "cdn-situacao":U THEN ASSIGN pFieldValue = RowObject.cdn-situacao.
        WHEN "cdn-tipo":U THEN ASSIGN pFieldValue = RowObject.cdn-tipo.
        WHEN "dec-ftconv-unest":U THEN ASSIGN pFieldValue = RowObject.dec-ftconv-unest.
        WHEN "num-casa-dec-unest":U THEN ASSIGN pFieldValue = RowObject.num-casa-dec-unest.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "num-seq-fat":U THEN ASSIGN pFieldValue = RowObject.num-seq-fat.
        WHEN "num-seq-ped":U THEN ASSIGN pFieldValue = RowObject.num-seq-ped.
        WHEN "num-sequencia":U THEN ASSIGN pFieldValue = RowObject.num-sequencia.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getItem DBOProgram 
PROCEDURE getItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT  PARAM pcCodItem     LIKE rma-item.cod-item  NO-UNDO.
DEF OUTPUT PARAM pcDescCodItem LIKE item.desc-item     NO-UNDO.

  FOR FIRST item WHERE
            item.it-codigo = pcCodItem NO-LOCK: 
     ASSIGN pcDescCoditem = item.desc-item.          
  END.
    
  IF NOT AVAIL item THEN 
    RETURN "NOK":U.
  ELSE
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice rma-item
  Parameters:  
               retorna valor do campo cod-estabel
               retorna valor do campo cod-rma
               retorna valor do campo num-sequencia
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE rma-item.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-rma LIKE rma-item.cod-rma NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-sequencia LIKE rma-item.num-sequencia NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-estabel = RowObject.cod-estabel
           pcod-rma = RowObject.cod-rma
           pnum-sequencia = RowObject.num-sequencia.

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
        WHEN "log-cq":U THEN ASSIGN pFieldValue = RowObject.log-cq.
        WHEN "log-livre-1":U THEN ASSIGN pFieldValue = RowObject.log-livre-1.
        WHEN "log-livre-2":U THEN ASSIGN pFieldValue = RowObject.log-livre-2.
        WHEN "{&log-recebe-mercad}":U THEN ASSIGN pFieldValue = RowObject.{&log-recebe-mercad}.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getOccurrence DBOProgram 
PROCEDURE getOccurrence :
/*------------------------------------------------------------------------------
  Purpose: Retorna para a interface a descriá∆o da ocorrància do RMA
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT  PARAM cCodOcorrencia LIKE rma-ocorrencia.cod-ocorrencia NO-UNDO.
DEF OUTPUT PARAM cDesOcorrencia LIKE rma-ocorrencia.des-ocorrencia NO-UNDO.
 
   FOR FIRST rma-ocorrencia WHERE
             rma-ocorrencia.cod-ocorrencia = cCodOcorrencia NO-LOCK:
       ASSIGN cDesOcorrencia = rma-ocorrencia.des-ocorrencia.
   END.
   
   
   IF NOT AVAIL rma-ocorrencia THEN
     RETURN "NOK":U.
   ELSE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getReference DBOProgram 
PROCEDURE getReference :
/*------------------------------------------------------------------------------
  Purpose: Buscar a descriá∆o da referància do item do RMA
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT  PARAM cCodRefer  LIKE rma-item.cod-refer   NO-UNDO.
DEF OUTPUT PARAM cDescRefer LIKE referencia.descricao NO-UNDO.
    
  FOR FIRST referencia FIELDS(descricao) WHERE 
            referencia.cod-refer = cCodRefer NO-LOCK:
     ASSIGN cDescRefer = referencia.descricao.            
  END.
  
  IF AVAIL referencia THEN
    RETURN "NOK":U.
    
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
  Purpose: Permitir a sa°da da temp-table que contÇm os registros exclu°dos pelo
           DBO e ser∆o removidos do banco de dados apenas na confirmaá∆o da 
           interface.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getUNData DBOProgram 
PROCEDURE getUNData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 &IF  DEFINED(bf_dis_preco_un_med_mult) &THEN
  
  DEF INPUT  PARAM pcCodEstabel     AS CHAR NO-UNDO.
  DEF INPUT  PARAM pcCodRMA         AS CHAR NO-UNDO.
  DEF INPUT  PARAM pItCodigo        AS CHAR NO-UNDO.
  DEF INPUT  PARAM pUnMedida        AS CHAR NO-UNDO.
  DEF OUTPUT PARAM pFatorConversao  AS DEC  NO-UNDO.
  DEF OUTPUT PARAM pNrCasasDecimais AS DEC  NO-UNDO.
    
    /* Localiza RMA */
    RUN findRMA (INPUT pcCodEstabel,
                 INPUT pcCodRMA).
    IF RETURN-VALUE <> "OK":U THEN
      RETURN "NOK":U.
    
    /* Localiza Emitente */
    FOR FIRST emitente WHERE
              emitente.cod-emitente = rma.cdn-emitente 
              NO-LOCK: END.
    IF NOT AVAIL emitente THEN
      RETURN "NOK":U.

    /* Localiza emitente distribuiá∆o */
    FOR FIRST dist-emitente WHERE 
              dist-emitente.cod-emitente = rma.cdn-emitente
              NO-LOCK: END.
    IF NOT AVAIL dist-emitente THEN
       RETURN "NOK".

    /* Relaá∆o item x cliente */
    FIND FIRST item-cli WHERE
               item-cli.nome-abrev    = emitente.nome-abrev AND  
               item-cli.it-codigo     = pItCodigo      AND 
               item-cli.unid-med-cli  = pUnMedida      AND 
               item-cli.ind-sit-relac = 1 /* Ativo */  AND  
               item-cli.log-unid-prefer 
               NO-LOCK NO-ERROR.
    IF NOT AVAIL item-cli THEN 
        FIND FIRST item-cli where 
                   item-cli.nome-abrev    = emitente.nome-abrev AND 
                   item-cli.it-codigo     = pItCodigo           AND 
                   item-cli.unid-med-cli  = pUnMedida           AND 
                   item-cli.ind-sit-relac = 1
                   NO-LOCK NO-ERROR.
    
    /* Existe item X cliente */
    IF AVAIL item-cli THEN
        ASSIGN pFatorConversao  = item-cli.fator-conversao
               pNrCasasDecimais = item-cli.num-casa-dec.
    /* N∆o existe item X cliente */
    ELSE DO:
        IF NOT dist-emitente.log-obriga-item-cli THEN DO:
            FIND item-unid-venda WHERE 
                 item-unid-venda.it-codigo = pItCodigo and
                 item-unid-venda.un        = pUnMedida 
                 NO-LOCK NO-ERROR.

            IF AVAIL item-unid-venda THEN
              ASSIGN pFatorConversao  = item-unid-venda.fator-conversao
                     pNrCasasDecimais = item-unid-venda.num-casa-dec
                     .
            ELSE
              ASSIGN pFatorConversao  = 0
                     pNrCasasDecimais = 0
                     .
        END.
        ELSE
            ASSIGN pFatorConversao  = 0
                   pNrCasasDecimais = 0
                   .
    END.
    
    /* Unidade do item */
    FIND ITEM WHERE
         item.it-codigo = pItCodigo 
         NO-LOCK NO-ERROR.
    IF AVAIL item AND
             item.un = pUnMedida THEN
      ASSIGN pFatorConversao  = 1
             pNrCasasDecimais = 0
             .
    
 &ENDIF.
 
 RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice rma-item
  Parameters:  
               recebe valor do campo cod-estabel
               recebe valor do campo cod-rma
               recebe valor do campo num-sequencia
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE rma-item.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pcod-rma LIKE rma-item.cod-rma NO-UNDO.
    DEFINE INPUT PARAMETER pnum-sequencia LIKE rma-item.num-sequencia NO-UNDO.

    FIND FIRST bfrma-item WHERE 
        bfrma-item.cod-estabel = pcod-estabel AND 
        bfrma-item.cod-rma = pcod-rma AND 
        bfrma-item.num-sequencia = pnum-sequencia NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfrma-item THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfrma-item)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToRMA DBOProgram 
PROCEDURE linkToRMA :
/*------------------------------------------------------------------------------
  Purpose: Conecta o RMA-item ao RMA
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM phParentHandle AS HANDLE NO-UNDO.

  RUN getKey IN phParentHandle (OUTPUT cCodEstabel,
                               OUTPUT cCodRMA).
  
  RUN setConstraintRMA (INPUT cCodEstabel,
                        INPUT cCodRMA).
                        
  RUN findRMA (INPUT cCodEstabel,
               INPUT cCodRMA).
               
  ASSIGN hParentHandle = phParentHandle.
               
  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose: Abre a query principal
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  OPEN QUERY {&queryName} FOR EACH {&tableName} NO-LOCK INDEXED-REPOSITION.

  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryRMA DBOProgram 
PROCEDURE openQueryRMA :
/*------------------------------------------------------------------------------
  Purpose:  Abre a query relacionando o RMA-item ao RMA
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  OPEN QUERY {&queryName} FOR EACH {&tableName} WHERE 
                                   {&tableName}.cod-estabel = cCodEstabel AND
                                   {&tableName}.cod-rma     = cCodRMA 
                                   NO-LOCK INDEXED-REPOSITION.
  RETURN "OK":U.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE searchForIssueDocData DBOProgram 
PROCEDURE searchForIssueDocData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FIND FIRST rowObject NO-ERROR.
  IF NOT AVAIL rowObject THEN 
    RETURN "NOK":U.
    
  FOR FIRST rma WHERE
            rma.cod-estabel = rowObject.cod-estabel AND
            rma.cod-rma     = rowObject.cod-rma NO-LOCK: END.

  IF NOT AVAIL rma THEN 
    RETURN "NOK":U.

  FOR FIRST emitente WHERE 
            emitente.cod-emitente = rma.cdn-emitente NO-LOCK: END.

  IF NOT AVAIL emitente THEN 
    RETURN "NOK":U.
    
  FOR FIRST nota-fiscal WHERE
            nota-fiscal.cod-estabel = rowObject.cod-estabel       AND
            nota-fiscal.nr-nota-fis = rowObject.cod-nota-fis-orig AND
            nota-fiscal.serie       = rowObject.cod-serie-orig NO-LOCK: 
    ASSIGN rowObject.cod-tabpre = nota-fiscal.nr-tabpre.
  END.

  IF NOT AVAIL nota-fiscal THEN
    FOR FIRST ped-venda WHERE 
              ped-venda.nome-abrev = emitente.nome-abrev AND
              ped-venda.nr-pedcli  = rowObject.cod-pedcli NO-LOCK: 
       ASSIGN rowObject.cod-tabpre = ped-venda.nr-tabpre.
    END.
  
  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE searchForIssueDocItemData DBOProgram 
PROCEDURE searchForIssueDocItemData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  FIND FIRST rowObject NO-ERROR.
  IF NOT AVAIL rowObject THEN 
    RETURN "NOK":U.
    
  IF NOT AVAIL rma THEN 
    RETURN "NOK":U.
        
  FOR FIRST emitente WHERE 
            emitente.cod-emitente = rma.cdn-emitente NO-LOCK: END.
  IF NOT AVAIL emitente THEN 
    RETURN "NOK":U.
        
  FOR FIRST it-nota-fisc WHERE
            it-nota-fisc.cod-estabel    = rowObject.cod-estabel       AND
            it-nota-fisc.nr-nota-fis    = rowObject.cod-nota-fis-orig AND
            it-nota-fisc.serie          = rowObject.cod-serie-orig    AND
            it-nota-fisc.nr-seq-fat     = rowObject.num-seq-fat       AND
            it-nota-fisc.it-codigo      = rowObject.cod-item          NO-LOCK: 
    ASSIGN rowObject.val-preuni         = it-nota-fisc.vl-preuni
           rowObject.val-pretab         = it-nota-fisc.vl-pretab
           rowObject.cod-un             = it-nota-fisc.un-fatur[2]
           rowObject.dec-ftconv-unest   = it-nota-fisc.dec-ftconv-unest
           rowObject.num-casa-dec-unest = it-nota-fisc.num-casa-dec-unest
           rowObject.qtd-a-receber      = it-nota-fisc.qt-faturada[1].
  END.  

  IF NOT AVAIL it-nota-fisc THEN
    FOR FIRST ped-item WHERE 
              ped-item.nome-abrev          = emitente.nome-abrev   AND
              ped-item.nr-pedcli           = rowObject.cod-pedcli  AND
              ped-item.nr-sequencia        = rowObject.num-seq-ped AND
              ped-item.it-codigo           = rowObject.cod-item    NO-LOCK: 
       ASSIGN rowObject.val-preuni         = ped-item.vl-preuni
              rowObject.val-pretab         = ped-item.vl-pretab
              rowObject.dec-ftconv-unest   = ped-item.dec-ftconv-unest
              rowObject.num-casa-dec-unest = ped-item.num-casa-dec-unest
              rowObject.qtd-a-receber      = ped-item.qt-pedida.
    END.
  
  RETURN "OK":U.  
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintRMA DBOProgram 
PROCEDURE setConstraintRMA :
/*------------------------------------------------------------------------------
  Purpose:  Preenche parÉmetros de ligaá∆o entre RMA-item e RMA
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM pcCodEstabel LIKE rma-item.cod-estabel NO-UNDO.
DEF INPUT PARAM pcCodRMA     LIKE rma-item.cod-rma     NO-UNDO.

  ASSIGN cCodEstabel = pcCodEstabel
         cCodRMA     = pcCodRMA.         


  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDefaultConta DBOProgram 
PROCEDURE setDefaultConta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF OUTPUT PARAM c-conta-contabil LIKE item.ct-codigo.
  DEF OUTPUT PARAM c-centro-custo   LIKE item.sc-codigo.

  FIND FIRST rowObject NO-ERROR.
  IF NOT AVAIL rowObject THEN
    RETURN "NOK":U.
    
  IF rowObject.cod-nota-fis-orig = "" THEN
     FOR FIRST item WHERE
               item.it-codigo = rowObject.cod-item NO-LOCK:
        ASSIGN c-conta-contabil = ITEM.ct-codigo
               c-centro-custo   = ITEM.sc-codigo.
     END.
     
  IF NOT AVAIL item THEN 
    RETURN "NOK":U.
  ELSE    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDefaultsInvSeqNum DBOProgram 
PROCEDURE setDefaultsInvSeqNum :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  RUN searchForIssueDocItemData.
  
  RETURN "OK":U.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDefaultsItem DBOProgram 
PROCEDURE setDefaultsItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  FIND FIRST rowObject NO-ERROR.
  IF NOT AVAIL rowObject THEN
    RETURN "NOK":U.
    
  IF rowObject.cod-nota-fis-orig = "" THEN
     FOR FIRST item WHERE
               item.it-codigo = rowObject.cod-item NO-LOCK:
        ASSIGN rowObject.cod-un               = item.un
               rowObject.{&log-recebe-mercad} = item.baixa-estoq
               rowObject.ct-codigo            = item.ct-codigo
               rowObject.sc-codigo            = item.sc-codigo
               .

        IF item.tipo-con-est < 3 THEN
            ASSIGN rowObject.cod-refer = "".
     END.
     
  IF NOT AVAIL item THEN 
    RETURN "NOK":U.
  ELSE    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDefaultsOrdSeqNum DBOProgram 
PROCEDURE setDefaultsOrdSeqNum :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  RUN searchForIssueDocItemData.
  
  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDefaultsOrigInvoice DBOProgram 
PROCEDURE setDefaultsOrigInvoice :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  RUN searchForIssueDocData.
  
  RETURN RETURN-VALUE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDefaultsOrigOrder DBOProgram 
PROCEDURE setDefaultsOrigOrder :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  RUN searchForIssueDocData.
  
  RETURN RETURN-VALUE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDefaultsOrigSerie DBOProgram 
PROCEDURE setDefaultsOrigSerie :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  RUN searchForIssueDocData.
  
  RETURN RETURN-VALUE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDefaultsUn DBOProgram 
PROCEDURE setDefaultsUn :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  FIND FIRST rowObject NO-ERROR.
  IF NOT AVAIL rowObject THEN
    RETURN "NOK":U.

  &IF DEFINED(bf_dis_preco_un_med_mult) &THEN
    
    RUN getUNData (INPUT  rowObject.cod-estabel,
                   INPUT  rowObject.cod-rma,
                   INPUT  rowObject.cod-item,
                   INPUT  rowObject.cod-un,
                   OUTPUT rowObject.dec-ftconv-unest,
                   OUTPUT rowObject.num-casa-dec-unest).
    RETURN RETURN-VALUE.
  &ELSE
    ASSIGN rowObject.dec-ftconv-unest   = item.ft-conversao
           rowObject.num-casa-dec-unest = item.dec-conv-fmcoml.

    RETURN "OK":U.
  &ENDIF

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

DEF VAR deQtyRecvd AS DEC NO-UNDO.

  RUN clearRowPermissions.  /* Limpa tabela de permiss‰es */

  FIND FIRST rowObject NO-ERROR.
  IF NOT AVAIL rowObject THEN
    RETURN "NOK":U.    
    
  FOR FIRST param-estoq NO-LOCK: END.
  IF NOT AVAIL param-estoq THEN 
    RETURN "NOK":U.
        

  FOR FIRST rma-param WHERE 
            rma-param.cod-estabel = param-estoq.estabel-pad 
            NO-LOCK: END.
  IF NOT AVAIL rma-param THEN 
    RETURN "NOK":U.  
  
   CASE pEvent:

     /*--- AFTEReNABLEfIELDS */
     WHEN "afterEnableFields":U THEN DO:

        /* Sempre desabilitados */
        RUN createRowPermissions (INPUT "rma-item":U, INPUT "qtd-cancelada":U).
        RUN createRowPermissions (INPUT "rma-item":U, INPUT "vl-merc-liq":U).
        RUN createRowPermissions (INPUT "rma-item":U, INPUT "val-despes-it":U).
        
        /* Desabilitado na manutená∆o */
        IF pType = "UPDATE":U THEN DO:
           FOR EACH  rma-it-dep-mov FIELDS(qtd-recebida)
               WHERE rma-it-dep-mov.cod-estabel   = RowObject.cod-estabel
               AND   rma-it-dep-mov.cod-rma       = RowObject.cod-rma
               AND   rma-it-dep-mov.num-sequencia = RowObject.num-sequencia NO-LOCK:

               ACCUMULATE rma-it-dep-mov.qtd-recebida (TOTAL).

           END.
           IF (ACCUM TOTAL rma-it-dep-mov.qtd-recebida) <> 0 THEN
               RUN createRowPermissions (INPUT "":U, INPUT "lTg-RecebeMercad":U).

           RUN createRowPermissions (INPUT "rma-item":U, INPUT "cod-un":U).
           RUN createRowPermissions (INPUT "rma-item":U, INPUT "dec-ftconv-unest":U).
           RUN createRowPermissions (INPUT "rma-item":U, INPUT "num-casa-dec-unest":U).

           FOR FIRST item WHERE
                     item.it-codigo = rowObject.cod-item NO-LOCK: END.
             IF  NOT AVAIL ITEM         OR
                 (ITEM.tipo-contr <> 1  AND
                  ITEM.tipo-contr <> 4) THEN
                 RUN createRowPermissions (INPUT "fPage1":U, INPUT "cFi-contaContabil":U).
        END.        
        ELSE DO:
           RUN createRowPermissions (INPUT "fPage2":U, INPUT "btCancSaldo":U).
           RUN createRowPermissions (INPUT "fPage1":U, INPUT "cFi-contaContabil":U).
        END.                                                                        
        
        /* Permiss‰es dos usu†rios do recebimento */
        FOR FIRST param-re WHERE param-re.usuario = cUserName NO-LOCK: 

            &IF "{&bf_mat_versao_ems}" >= "2.05" &THEN
               IF param-re.log-atualiza-quant-rma <> YES THEN DO:
                  RUN createRowPermissions (INPUT "rma-item":U, INPUT "qtd-devolver":U).
                  RUN createRowPermissions (INPUT "rma-item":U, INPUT "qtd-creditada":U).
               END.   
           &else 
               IF SUBSTRING(param-re.char-1,9,1) <> "1" THEN DO:
                  RUN createRowPermissions (INPUT "rma-item":U, INPUT "qtd-devolver":U).
                  RUN createRowPermissions (INPUT "rma-item":U, INPUT "qtd-creditada":U).
               END.
           &endif
            
        END.
       
        /* Uma vez iniciado o recebimento de mercadorias 
           n∆o ser† mais poss°vel modificar a quantidade a receber */
        IF CAN-FIND (FIRST rma-it-dep-mov WHERE 
                           rma-it-dep-mov.cod-rma       = rowObject.cod-rma        AND 
                           rma-it-dep-mov.cod-estabel   = rowObject.cod-estabel    AND  
                           rma-it-dep-mov.num-sequencia = rowObject.num-sequencia) THEN DO:
           RUN createRowPermissions (INPUT "rma-item":U, INPUT "qtd-a-receber":U).
        END.
               
        FOR FIRST param-global NO-LOCK: END.
        FOR FIRST param-estoq  NO-LOCK: END.

        /*Quando tem valor na param-estoq deve ser considerado o que est† nesse campo e n∆o na param-global*/
        IF SUBSTRING(param-estoq.char-2,68,1) <> "":U THEN
            ASSIGN l-ut-ser = (SUBSTRING(param-estoq.char-2,68,1) = "S":U).
        ELSE DO:
            {cdp/cd4300.i4  "yes" param-global.char-2}             
            {cdp/cd0101.i51 "yes"}
        END.
        
        IF NOT l-ut-ser THEN /* Usa sÇrie ? */
            RUN createRowPermissions (INPUT "rma-item":U, INPUT "cod-serie-orig":U).


     END.   

     /*---- LEAVE-COD-ITEM ----*/
     WHEN "leave-cod-item":U THEN DO:
       FOR FIRST item WHERE
                 item.it-codigo = rowObject.cod-item NO-LOCK: END.
       IF NOT AVAIL item         OR
          item.tipo-con-est <> 4 THEN /* Tipo de controle no estoque : Serie, Ref */
          RUN createRowPermissions (INPUT "rma-item":U, INPUT "cod-refer":U).
       IF  NOT AVAIL ITEM         OR
           (ITEM.tipo-contr <> 1  AND
            ITEM.tipo-contr <> 4) THEN
           RUN createRowPermissions (INPUT "fPage1":U, INPUT "cFi-contaContabil":U).
     END.     

     /*--- LEAVE-COD-NOTA-FIS-ORIG ---*/
     WHEN "leave-cod-nota-fis-orig":U THEN DO:     
       IF CAN-FIND (FIRST nota-fiscal WHERE
                          nota-fiscal.cod-estabel = rowObject.cod-estabel       AND
                          nota-fiscal.nr-nota-fis = rowObject.cod-nota-fis-orig AND
                          nota-fiscal.serie       = rowObject.cod-serie-orig)   THEN DO:
            /* Informada uma nota fiscal v†lida ? */
            RUN createRowPermissions (INPUT "rma-item":U, INPUT "cod-pedcli":U).
            RUN createRowPermissions (INPUT "rma-item":U, INPUT "num-seq-ped":U).
       END.                        
     END.
     
     /*--- VALUE-CHANGED-lTg-recebeMercad ---*/
     WHEN "value-changed-lTg-recebeMercad" THEN DO:            
       
       /* Se iniciado o recebimento, permitir atualizaá∆o 
          dos campos qtd-devolver e qtd-creditada */
       RUN calcRcvdQty (OUTPUT deQtyRecvd).
       
       IF rowObject.{&log-recebe-mercad} THEN DO:
          IF pType <> "UPDATE":U THEN DO:
            RUN createRowPermissions (INPUT "rma-item":U, INPUT "qtd-devolver":U).
            RUN createRowPermissions (INPUT "rma-item":U, INPUT "qtd-creditada":U).
          END.
          ELSE  
            IF deQtyRecvd <= 0 THEN DO:
              RUN createRowPermissions (INPUT "rma-item":U, INPUT "qtd-devolver":U).
              RUN createRowPermissions (INPUT "rma-item":U, INPUT "qtd-creditada":U).
            END.
       END.

       /* Permiss‰es dos usu†rios do recebimento */
       FOR FIRST param-re WHERE param-re.usuario = cUserName NO-LOCK: 
           &IF "{&bf_mat_versao_ems}" >= "2.05" &THEN
               IF param-re.log-atualiza-quant-rma <> YES THEN DO:
                  RUN createRowPermissions (INPUT "rma-item":U, INPUT "qtd-devolver":U).
                  RUN createRowPermissions (INPUT "rma-item":U, INPUT "qtd-creditada":U).
               END.   
           &else 
               IF SUBSTRING(param-re.char-1,9,1) <> "1" THEN DO:
                  RUN createRowPermissions (INPUT "rma-item":U, INPUT "qtd-devolver":U).
                  RUN createRowPermissions (INPUT "rma-item":U, INPUT "qtd-creditada":U).
               END.
           &endif
       END.
     END.

   END CASE.

  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sumRMAItem DBOProgram 
PROCEDURE sumRMAItem :
/*------------------------------------------------------------------------------
  Purpose: Totaliza o Item
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FIND FIRST rowObject NO-ERROR.
  IF NOT AVAIL rowObject THEN
    RETURN "NOK":U.
    
  ASSIGN rowObject.vl-merc-liq = (rowObject.qtd-a-receber  - 
                                  rowObject.qtd-cancelada) *
                                  rowObject.val-preuni
         rowObject.val-tot-item-rma = rowObject.vl-merc-liq.
                                  
  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE toggleValidation DBOProgram 
PROCEDURE toggleValidation :
/*------------------------------------------------------------------------------
  Purpose: Ligar/Desligar validaá‰es
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM plValidate AS LOG NO-UNDO.

  ASSIGN lValidate = plValidate.

 RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateRMAStatus DBOProgram 
PROCEDURE updateRMAStatus :
/*------------------------------------------------------------------------------
  Purpose: 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR deRMAOpenQty LIKE rma-item.qtd-a-receber NO-UNDO.

   /* Quando o £ltimo item do RMA for removido, retorna a situaá∆o para 
      1 - N∆o confirmado                                                 */
      
   IF NOT CAN-FIND (FIRST rma-item WHERE
                          rma-item.cod-estabel = rma.cod-estabel AND
                          rma-item.cod-rma     = rma.cod-rma) THEN DO:
      IF rma.cdn-situacao <> 1 THEN DO:
        FIND CURRENT rma EXCLUSIVE-LOCK NO-ERROR.
        IF AVAIL rma THEN
          ASSIGN rma.cdn-situacao = 1. /*** N∆o confirmado ***/
      END.
   END.
   ELSE DO:
     IF rma.cdn-situacao <> 3 AND
        rma.cdn-situacao <> 4 THEN DO:
        FIND CURRENT rma EXCLUSIVE-LOCK NO-ERROR.
        IF AVAIL rma THEN
          ASSIGN rma.cdn-situacao = 3. /*** Aprovado ***/
      END.
      RUN calcRMAOpenQty IN hParentHandle (OUTPUT deRMAOpenQty).   
      FIND CURRENT rma EXCLUSIVE-LOCK NO-ERROR.
      IF (rma.cdn-situacao = 3  OR
          rma.cdn-situacao = 4) AND
          deRMAOpenQty     = 0  THEN 
         ASSIGN rma.cdn-situacao = 5.  /*** Autorizado ***/      
   END.
  
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
   
   DEF VAR lInfNotaFiscal AS LOG NO-UNDO.
   DEF VAR lInfPedVenda   AS LOG NO-UNDO.
   DEF VAR lAlterado      AS LOG NO-UNDO.
   DEF VAR deRcvdQty      LIKE rma-it-dep-mov.qtd-recebida NO-UNDO.
   DEF VAR deVlAberto     LIKE rma-item.qtd-a-receber      NO-UNDO.

   DEFINE VARIABLE i-num-finalid-cta AS INTEGER                NO-UNDO.
   DEFINE VARIABLE v_log_utz_ccusto  AS LOGICAL                NO-UNDO.

   &IF DEFINED(bf_dis_preco_un_med_mult) &THEN
       DEFINE VARIABLE deFatorConversao  AS DECIMAL NO-UNDO.
       DEFINE VARIABLE deNrCasasDecimais AS DECIMAL NO-UNDO.
   &ENDIF
    
    /*--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/   
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as validaá‰es ---*/
    
    /* Caso a validaá∆o tenha sido desligada, returna OK */       
    IF NOT lValidate THEN
      RETURN "OK":U.
    
    FIND FIRST rowObject NO-ERROR.
    IF NOT AVAIL rowObject THEN
       RETURN "NOK":U.
       
    FOR FIRST rma-param WHERE 
              rma-param.cod-estabel = rowObject.cod-estabel NO-LOCK: END.
    IF NOT AVAIL rma-param THEN 
      RETURN "NOK":U.
       
    IF pType = "CREATE":U OR pType = "UPDATE":U THEN DO:    
        IF pType = "Create":U THEN DO:
          /* J† existe ocorrància para a chave informada */
          IF CAN-FIND (FIRST bf{&tableName} WHERE
                             bf{&tableName}.cod-estabel   = rowObject.cod-estabel    AND
                             bf{&tableName}.cod-rma       = rowObject.cod-rma        AND
                             bf{&tableName}.num-sequencia = rowObject.num-sequencia) THEN DO:
              /* Inicio -- Projeto Internacional */
              {utp/ut-table.i movind rma-item 1} /* Busca o label da tabela */
              {method/svc/errors/inserr.i
                      &ErrorNumber="1"
                      &ErrorType="EMS"
                      &ErrorSubType="Error"
                      &ErrorParameters=TRIM(RETURN-VALUE)}                      
              RETURN "NOK":U.
          END.
          
          /* Unidade de medida */
          IF NOT CAN-FIND (FIRST tab-unidade WHERE tab-unidade.un = rowObject.cod-un) THEN DO:
              /* Inicio -- Projeto Internacional */
              {utp/ut-table.i mgind tab-unidade 1} /* Busca o label da tabela */
              {method/svc/errors/inserr.i
                      &ErrorNumber="2"
                      &ErrorType="EMS"
                      &ErrorSubType="Error"
                      &ErrorParameters=TRIM(RETURN-VALUE)}
          END.
          
          /* RMA est† autorizado, n∆o permitindo novas inclus‰es de itens. */
          IF rma.cdn-situacao = 5 AND             
             CAN-FIND (FIRST rma-it-dep-mov WHERE
                             rma-it-dep-mov.cod-estabel   = rowObject.cod-estabel    AND
                             rma-it-dep-mov.cod-rma       = rowObject.cod-rma        AND
                             rma-it-dep-mov.num-sequencia = rowObject.num-sequencia) THEN DO:
              /* Inicio -- Projeto Internacional */
              DEFINE VARIABLE c-lbl-liter-autorizado AS CHARACTER NO-UNDO.
              {utp/ut-liter.i "Autorizado" *}
              ASSIGN c-lbl-liter-autorizado = TRIM(RETURN-VALUE).
              {method/svc/errors/inserr.i
                      &ErrorNumber="27412"
                      &ErrorType="EMS"
                      &ErrorSubType="Error"
                      &ErrorParameters="c-lbl-liter-autorizado"}
          END.
          
          IF lValidRMAItDepQty THEN 
             RUN validateRMAItDepQty.

        END.
        
        IF pType = "UPDATE":U THEN DO:
          IF rma-item.cdn-situacao = 6 THEN DO:
               /* Inicio -- Projeto Internacional */
               DEFINE VARIABLE c-lbl-liter-do-item-rma AS CHARACTER NO-UNDO.
               {utp/ut-liter.i "do_Item_RMA" *}
               ASSIGN c-lbl-liter-do-item-rma = TRIM(RETURN-VALUE).
               {method/svc/errors/inserr.i
                       &ErrorNumber="19247"
                       &ErrorType="EMS"
                       &ErrorSubType="Error"
                       &ErrorParameters="c-lbl-liter-do-item-rma"}          
          END.
          IF rowObject.{&log-recebe-mercad} THEN DO: /*** Recebimento F°sico ***/                  
            
            /* As quantidades a devolver e a creditar somadas 
               devem ser inferiores Ö quantidade j† recebida */           
            RUN calcRcvdQty (OUTPUT deRcvdQty).
        
            IF (rowObject.qtd-devolver + rowObject.qtd-creditada) > deRcvdQty THEN DO:
                  {method/svc/errors/inserr.i
                          &ErrorNumber="27466"
                          &ErrorType="EMS"
                          &ErrorSubType="Error"}
            END.
          END.              
        END.        
        
        /* Preáo deve ser maior que zero */
        IF rowObject.val-preuni <= 0 THEN DO:
                {method/svc/errors/inserr.i
                        &ErrorNumber="8630"
                        &ErrorType="EMS"
                        &ErrorSubType="Error"}        
        END.        
        
        /* Quantidade deve ser maior que zero */
        IF rowObject.qtd-a-receber <= 0 THEN DO:
                {method/svc/errors/inserr.i
                        &ErrorNumber="2608"
                        &ErrorType="EMS"
                        &ErrorSubType="Error"}
        END.           
        
        /* Quantidade em aberto */
        RUN calcOpenValue (OUTPUT deVlAberto).
        
        
        IF RETURN-VALUE <> "OK":U THEN DO:  /* saldo n∆o pode ser negativo */
              {method/svc/errors/inserr.i
                      &ErrorNumber="27233"
                      &ErrorType="EMS"
                      &ErrorSubType="Error"}        
        END.       
        
         IF NOT rowObject.{&log-recebe-mercad} THEN DO: /*** Recebimento n∆o f°sico ***/
            /* As quantidades a devolver e a creditar devem 
               ser inferiores Ö quantidade a receber        */
            IF (rowObject.qtd-devolver + rowObject.qtd-creditada) > rowObject.qtd-a-receber THEN DO:
                  {method/svc/errors/inserr.i
                          &ErrorNumber="27601"
                          &ErrorType="EMS"
                          &ErrorSubType="Error"}            
            END.                        
        END.        
        
        /* Item */
        FOR FIRST item WHERE
                  item.it-codigo = rowObject.cod-item NO-LOCK: END.
        IF NOT AVAIL item THEN DO:
            /* N∆o foi encontrada ocorrància de &1 para a chave informada */
            /* Inicio -- Projeto Internacional */
            {utp/ut-table.i mgind item 1} /* Busca o label da tabela */
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorSubType="Error"
                    &ErrorParameters=TRIM(RETURN-VALUE)}
            RETURN "NOK":U.
        END.
        ELSE DO:            
           /* Referància n∆o pertence ao item */
           IF item.tipo-con-est = 4 AND
              NOT CAN-FIND (FIRST ref-item WHERE 
                                  ref-item.it-codigo = RowObject.cod-item AND 
                                  ref-item.cod-refer = RowObject.cod-refer) THEN DO:            
                   {method/svc/errors/inserr.i
                           &ErrorNumber="1947"
                           &ErrorType="EMS"
                           &ErrorSubType="Error"
                           &ErrorParameters="''"}                                
           END.
           /* Item n∆o pode ser de dÇbito direto */
           IF item.tipo-contr = 4 THEN DO:
                {method/svc/errors/inserr.i
                        &ErrorNumber="1673"
                        &ErrorType="EMS"
                        &ErrorSubType="Error"}
           END.
           /* Item obsoleto */
           IF item.cod-obsoleto = 4 THEN DO:
                {method/svc/errors/inserr.i
                        &ErrorNumber="17472"
                        &ErrorType="EMS"
                        &ErrorSubType="Error"}
           END.

       /* Verifica se a quantidade Ç inteira ou fracionada */
       IF (TRUNCATE (rowObject.qtd-a-receber, 0) <> rowObject.qtd-a-receber  OR 
           TRUNCATE (rowObject.qtd-devolver,  0) <> rowObject.qtd-devolver   OR
           TRUNCATE (rowObject.qtd-creditada, 0) <> rowObject.qtd-creditada) AND
           NOT item.fraciona THEN DO:
                {method/svc/errors/inserr.i
                               &ErrorNumber="1892"
                               &ErrorType="EMS"
                               &ErrorSubType="Error"}
           END.
        END.  

        /*** Conta Cont†bil ***/
        IF AVAIL ITEM THEN do:
            IF (ITEM.tipo-contr = 1  OR
                ITEM.tipo-contr = 4) THEN DO:
            
                IF (rowObject.ct-codigo = "") THEN DO:
                     {method/svc/errors/inserr.i
                              &ErrorNumber="6726"
                              &ErrorType="EMS" 
                              &ErrorSubType="Error"}
                END.
                ELSE DO:

                    IF  NOT VALID-HANDLE(h_api_cta_ctbl) THEN
                        RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.
                    IF  NOT VALID-HANDLE(h_api_ccusto) THEN
                        RUN prgint/utb/utb742za.py PERSISTENT SET h_api_ccusto.

                    FIND FIRST estabelec WHERE
                               estabelec.cod-estabel = rowObject.cod-estabel 
                               NO-LOCK NO-ERROR.
                    
                    run cdp/cd9970.p (input rowid(estabelec),
                                      output iEmpresa).

                    EMPTY TEMP-TABLE tt_log_erro.
                    RUN pi_verifica_utilizacao_ccusto IN h_api_ccusto (INPUT  iEmpresa,              /* EMPRESA EMS 2 */
                                                                       INPUT  rowObject.cod-estabel, /* ESTABELECIMENTO EMS2 */
                                                                       INPUT  "",                    /* PLANO CONTAS */
                                                                       INPUT  rowObject.ct-codigo,   /* CONTA */
                                                                       INPUT  TODAY       ,          /* DT TRANSACAO */
                                                                       OUTPUT v_log_utz_ccusto,      /* UTILIZA CCUSTO ? */
                                                                       OUTPUT TABLE tt_log_erro).    /* ERROS */
                    IF  v_log_utz_ccusto THEN DO:
                        EMPTY TEMP-TABLE tt_log_erro.
                        RUN pi_busca_dados_ccusto IN h_api_ccusto (INPUT  iEmpresa,            /* EMPRESA EMS2 */
                                                                   INPUT  "",                  /* CODIGO DO PLANO CCUSTO */
                                                                   INPUT  rowObject.sc-codigo, /* CCUSTO */
                                                                   INPUT  TODAY,               /* DATA DE TRANSACAO */
                                                                   OUTPUT v_des_ccusto,        /* DESCRICAO DO CCUSTO */
                                                                   OUTPUT TABLE tt_log_erro).  /* ERROS */ 
                        FIND FIRST tt_log_erro NO-LOCK NO-ERROR.
                        IF  AVAIL tt_log_erro THEN DO:
                            
                            {utp/ut-liter.i "Centro Custo" *}

                            {method/svc/errors/inserr.i
                              &ErrorNumber="2"
                              &ErrorType="EMS" 
                              &ErrorSubType="Error"
                              &ErrorParameters="return-value"}

                        END.
                    END.

                    EMPTY TEMP-TABLE tt_log_erro.
                    ASSIGN v_cod_cta_ctbl = rowObject.ct-codigo.   
                
                    RUN pi_busca_dados_cta_ctbl IN h_api_cta_ctbl (INPUT        iEmpresa,           /* EMPRESA EMS2 */
                                                                   INPUT        "",                 /* PLANO DE CONTAS */
                                                                   INPUT-OUTPUT v_cod_cta_ctbl,     /* CONTA */
                                                                   INPUT        TODAY,              /* DATA TRANSACAO */   
                                                                   OUTPUT       v_des_cta_ctbl,     /* DESCRICAO CONTA */
                                                                   OUTPUT       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                                   OUTPUT       v_num_sit_cta_ctbl, /* SITUAÄ«O DA CONTA */
                                                                   OUTPUT       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                                   OUTPUT TABLE tt_log_erro).       /* ERROS */
                
                    RUN pi_busca_dados_cta_ctbl_integr IN h_api_cta_ctbl (INPUT        iEmpresa,          /* EMPRESA EMS2 */
                                                                          INPUT        "CEP":U,           /* M‡DULO */
                                                                          INPUT        "",                /* PLANO DE CONTAS */
                                                                          INPUT        v_cod_cta_ctbl,    /* CONTA */
                                                                          INPUT        TODAY       ,      /* DATA TRANSACAO */   
                                                                          OUTPUT       v_ind_finalid_cta, /* FINALIDADES DA CONTA */
                                                                          OUTPUT TABLE tt_log_erro).      /* ERROS */ 
                    FIND FIRST tt_log_erro NO-LOCK NO-ERROR.
                    IF  NOT AVAIL tt_log_erro THEN DO:
                        
                        ASSIGN i-num-finalid-cta = {adinc/i05ad049.i 6 v_ind_finalid_cta}.
                        
                        IF  v_num_sit_cta_ctbl <> 3 THEN DO: /* Sistema */
                            /* mensagem: Conta n∆o Ç de sistema */
                            {method/svc/errors/inserr.i
                                      &ErrorNumber="443"
                                      &ErrorType="EMS" 
                                      &ErrorSubType="Error"}
                        END.
                        if  not can-do("1,2,4,5",string(v_num_tip_cta_ctbl)) then do:        
                            /* mensagem: Conta deve ser de despesa, receita, ativo ou passivo */
                            {method/svc/errors/inserr.i
                                      &ErrorNumber="5543"
                                      &ErrorType="EMS" 
                                      &ErrorSubType="Error"}
                        end.
                        if  i-num-finalid-cta = 10 then do:
                            /* mensagem: Conta nío aceita lancamentos do estoque */
                            {method/svc/errors/inserr.i
                                      &ErrorNumber="15190"
                                      &ErrorType="EMS" 
                                      &ErrorSubType="Error"}
                        end.
                        if  not can-do("1,2,3,6",string(i-num-finalid-cta)) then do:
                            /* mensagem: Conta nío aceita lancamentos de requisiªÑes */
                            {method/svc/errors/inserr.i
                                      &ErrorNumber="107"
                                      &ErrorType="EMS" 
                                      &ErrorSubType="Error"}
                        end.           

                    END.

                    IF  VALID-HANDLE(h_api_cta_ctbl) THEN DO: /* API Finanáas -> handle Conta Cont†bil */
                        DELETE PROCEDURE h_api_cta_ctbl.
                        ASSIGN h_api_cta_ctbl = ?.
                    END.
                
                    IF  VALID-HANDLE(h_api_ccusto) THEN DO:   /* API Finanáas -> handle Centro de Custo */
                        DELETE PROCEDURE h_api_ccusto.
                        ASSIGN h_api_ccusto = ?.
                    END.
                
                END.
            END.
        END.
        
        /*** Cliente RMA ***/
        FOR FIRST emitente WHERE 
                  emitente.cod-emitente = rma.cdn-emitente NO-LOCK: END.
        
        IF NOT AVAIL emitente THEN
             RETURN "NOK":U.        

        /* Unidade de medida do item */
        &IF  DEFINED(bf_dis_preco_un_med_mult) &THEN
      
          RUN getUNData (INPUT rowObject.cod-estabel,
                         INPUT rowObject.cod-rma,
                         INPUT rowObject.cod-item,
                         INPUT rowObject.cod-un,
                         OUTPUT deFatorConversao,
                         OUTPUT deNrCasasDecimais).        

          IF RowObject.cod-un = "" THEN
              {method/svc/errors/inserr.i
                      &ErrorNumber="26922"
                      &ErrorType="EMS"
                      &ErrorSubType="Error"
                      &ErrorParameters="''"}
    
          IF  deFatorConversao = 0 OR
              deFatorConversao = ? THEN
              {method/svc/errors/inserr.i
                    &ErrorNumber="26019"
                    &ErrorType="EMS"
                    &ErrorSubType="Error"
                    &ErrorParameters="''"}
        &ENDIF

        /*** Nota fiscal origem ***/        
        IF rowObject.cod-nota-fis-orig <> "" OR
           rowObject.cod-serie-orig    <> "" OR
          (rowObject.num-seq-fat       <> ?  AND 
           rowObject.num-seq-fat       <> 0) THEN DO:
           
             FOR FIRST nota-fiscal WHERE
                       nota-fiscal.cod-estabel = rowObject.cod-estabel       AND
                       nota-fiscal.nr-nota-fis = rowObject.cod-nota-fis-orig AND
                       nota-fiscal.serie       = rowObject.cod-serie-orig NO-LOCK: END.
                       
             IF NOT AVAIL nota-fiscal THEN DO:
           
                     /* Nota fiscal n∆o encontrada */
                    {method/svc/errors/inserr.i
                            &ErrorNumber="3084"
                            &ErrorType="EMS"
                            &ErrorSubType="Error"}                
                    RETURN "NOK":U.
             END.
             ELSE DO:
                  IF  nota-fiscal.ind-tip-nota = 9 OR
                      nota-fiscal.ind-tip-nota = 10 THEN DO:
                      {method/svc/errors/inserr.i &ErrorNumber = "25988"
                                                  &ErrorType = "EMS"
                                                  &ErrorSubType = "ERROR"
                                                  &ErrorParameters = "''"}
                      RETURN "NOK":U.
                  END.
                  FOR FIRST it-nota-fisc WHERE
                            it-nota-fisc.cod-estabel = rowObject.cod-estabel       AND
                            it-nota-fisc.nr-nota-fis = rowObject.cod-nota-fis-orig AND
                            it-nota-fisc.serie       = rowObject.cod-serie-orig    AND
                            it-nota-fisc.nr-seq-fat  = rowObject.num-seq-fat       AND
                            it-nota-fisc.it-codigo   = rowObject.cod-item NO-LOCK: END.
                  IF NOT AVAIL it-nota-fisc THEN DO:
                      /* Item da nota fiscal n∆o encontrado */
                      {method/svc/errors/inserr.i
                              &ErrorNumber="27198"
                              &ErrorType="EMS"
                              &ErrorSubType="Error"}
                      RETURN "NOK":U.
                  END.            
             END.
        END.
        ELSE DO:
            /*** Pedido de venda origem ***/
            IF rowObject.cod-pedcli  <> "" OR
              (rowObject.num-seq-ped <> ?  AND 
               rowObject.num-seq-ped <> 0) THEN DO:
                        
                 FOR FIRST ped-venda WHERE 
                           ped-venda.nome-abrev = emitente.nome-abrev   AND
                           ped-venda.nr-pedcli  = rowObject.cod-pedcli NO-LOCK: END.
                 IF NOT AVAIL ped-venda THEN DO:
                        /* Pedido n∆o cadastrado */
                        {method/svc/errors/inserr.i
                                &ErrorNumber="6269"
                                &ErrorType="EMS"
                                &ErrorSubType="Error"}                            
                        RETURN "NOK":U.
                 END.
                 ELSE DO:
                      FOR FIRST ped-item WHERE 
                                ped-item.nome-abrev   = emitente.nome-abrev  AND
                                ped-item.nr-pedcli    = rowObject.cod-pedcli AND
                                ped-item.nr-sequencia = rowObject.num-seq-ped NO-LOCK: END.
                      IF NOT AVAIL ped-item THEN DO:
                         /* Item do pedido de venda n∆o cadastrado */
                           {method/svc/errors/inserr.i
                                  &ErrorNumber="27199"
                                  &ErrorType="EMS"
                                  &ErrorSubType="Error"}                             
                          RETURN "NOK":U.
                      END.
                 END.
            END.           
        END.        
        
        /*** Se o documento de sa°da Ç a nota ***/
        IF AVAIL it-nota-fisc THEN DO: 
           IF rma-param.log-obriga-doc-sai  AND
              (rowObject.qtd-a-receber - 
               rowObject.qtd-cancelada) > it-nota-fisc.qt-faturada[1] THEN DO:               
              /* Quantidade n∆o pode ser superior Ö do documento de sa°da */
               {method/svc/errors/inserr.i
                       &ErrorNumber="27471"
                       &ErrorType="EMS"
                       &ErrorSubType="Error"}            
           END.
           IF INT(SUBSTRING(nota-fiscal.mo-codigo, 1, 2)) <> rma.cod-moeda THEN DO:
                /* Nota fiscal n∆o pode ter moeda diferente do RMA */
                {method/svc/errors/inserr.i
                        &ErrorNumber="27467"
                        &ErrorType="EMS"
                        &ErrorSubType="Error"}
           END.           
           IF rma.cdn-emitente <> nota-fiscal.cod-emitente THEN DO:
               /* Cliente do documento de sa°da deve 
                  ser igual ao cliente do RMA */
                {method/svc/errors/inserr.i
                        &ErrorNumber="27472"
                        &ErrorType="EMS"
                        &ErrorSubType="Error"}
           END.
           IF nota-fiscal.dt-confirma = ? THEN DO:
                {method/svc/errors/inserr.i
                        &ErrorNumber="6328"
                        &ErrorType="EMS"
                        &ErrorSubType="Error"}                      
           END.
        END.        
        
        /*** Sen∆o, se o documento de sa°da Ç o pedido ***/
        ELSE IF AVAIL ped-item THEN DO:           
           IF rma-param.log-obriga-doc-sai AND
              (rowObject.qtd-a-receber - 
               rowObject.qtd-cancelada) > ped-item.qt-pedida THEN DO:
                /* Quantidade n∆o pode ser superior Ö do documento de sa°da */
                {method/svc/errors/inserr.i
                        &ErrorNumber="27471"
                        &ErrorType="EMS"
                        &ErrorSubType="Error"}         
           END.           
           IF ped-venda.mo-codigo <> rma.cod-moeda THEN DO:
               /* Pedido de venda n∆o pode ter moeda diferente do RMA */
                {method/svc/errors/inserr.i
                        &ErrorNumber="27467"
                        &ErrorType="EMS"
                        &ErrorSubType="Error"}
           END.           
        END.              
        
        /*** Obrigat¢rio informar o documento de sa°da ***/        
        ELSE IF rma-param.log-obriga-doc-sai THEN DO:
                /* Documento de sa°da obrigat¢rio */
                {method/svc/errors/inserr.i
                        &ErrorNumber="27201"
                        &ErrorType="EMS"
                        &ErrorSubType="Error"}
                RETURN "NOK":U.                        
        END.
        
        /* Ocorrància de avaliaá∆o */        
        
        FOR FIRST rma-ocorrencia WHERE
                  rma-ocorrencia.cod-ocorrencia = rowObject.cod-avaliacao NO-LOCK:
        END.          
        IF NOT AVAIL rma-ocorrencia THEN DO:
                /* Ocorrància n∆o cadastrada! */                           
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-codigo-avaliacao AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "C¢digo_Avaliaá∆o" *}
                ASSIGN c-lbl-liter-codigo-avaliacao = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                        &ErrorNumber="27200"
                        &ErrorType="EMS"
                        &ErrorSubType="Error"
                        &ErrorParameters="c-lbl-liter-codigo-avaliacao"}
        END.
        ELSE 
           IF rma-ocorrencia.cdn-tp-ocorrencia <> 1 THEN DO:
              /* Tipo de ocorrància incorreta! */
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-avaliacao AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "avaliaá∆o" *}
                ASSIGN c-lbl-liter-avaliacao = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                        &ErrorNumber="27413"
                        &ErrorType="EMS"
                        &ErrorSubType="Error"
                        &ErrorParameters="c-lbl-liter-avaliacao"}
           END.
           
        /* Ocorrància de disposiá∆o */                
        
        FOR FIRST rma-ocorrencia WHERE
                  rma-ocorrencia.cod-ocorrencia = rowObject.cod-disposicao NO-LOCK: 
        END.
        IF NOT AVAIL rma-ocorrencia THEN DO:
                /* Ocorrància n∆o cadastrada! */
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-codigo-disposicao AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "C¢digo_Disposiá∆o" *}
                ASSIGN c-lbl-liter-codigo-disposicao = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                        &ErrorNumber="27200"
                        &ErrorType="EMS"
                        &ErrorSubType="Error"
                        &ErrorParameters="c-lbl-liter-codigo-disposicao"}
        END.   
        ELSE 
           IF rma-ocorrencia.cdn-tp-ocorrencia <> 2 THEN DO:
              /* Tipo de ocorrància incorreta! */
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-disposicao AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "disposiá∆o" *}
                ASSIGN c-lbl-liter-disposicao = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                        &ErrorNumber="27413"
                        &ErrorType="EMS"
                        &ErrorSubType="Error"
                        &ErrorParameters="c-lbl-liter-disposicao"}           
           END.

        /* Ocorrància de motivo */
                
        FOR FIRST rma-ocorrencia WHERE
                  rma-ocorrencia.cod-ocorrencia = rowObject.cod-motivo NO-LOCK:
        END.
        IF NOT AVAIL rma-ocorrencia THEN DO:
                /* Ocorrància n∆o cadastrada! */                           
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-codigo-motivo AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "C¢digo_Motivo" *}
                ASSIGN c-lbl-liter-codigo-motivo = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                        &ErrorNumber="27200"
                        &ErrorType="EMS"
                        &ErrorSubType="Error"
                        &ErrorParameters="c-lbl-liter-codigo-motivo"}
        END.
        ELSE 
           IF rma-ocorrencia.cdn-tp-ocorrencia <> 3 THEN DO:
              /* Tipo de ocorrància incorreta! */
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-motivo AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "motivo" *}
                ASSIGN c-lbl-liter-motivo = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                        &ErrorNumber="27413"
                        &ErrorType="EMS"
                        &ErrorSubType="Error"
                        &ErrorParameters="c-lbl-liter-motivo"}           
           END.           

       /* Fator de convers∆o deve ser maior que zero */
       IF (INT(rowObject.dec-ftconv-unest) = 0) THEN DO:
          /* Inicio -- Projeto Internacional */
          DEFINE VARIABLE c-lbl-liter-fator-conversao AS CHARACTER NO-UNDO.
          {utp/ut-liter.i "Fator_Convers∆o" *}
          ASSIGN c-lbl-liter-fator-conversao = TRIM(RETURN-VALUE).
          {method/svc/errors/inserr.i
                  &ErrorNumber="36"
                  &ErrorType="EMS"
                  &ErrorSubType="Error"
                  &ErrorParameters="c-lbl-liter-fator-conversao"}
       END.

    END.
    ELSE
      IF pType = "DELETE":U THEN DO:
         IF CAN-FIND (FIRST rma-it-dep-mov WHERE
                            rma-it-dep-mov.cod-estabel   = rowObject.cod-estabel      AND
                            rma-it-dep-mov.cod-rma       = rowObject.cod-rma          AND
                            rma-it-dep-mov.num-sequencia = rowObject.num-sequencia    AND
                            rowObject.{&log-recebe-mercad})                          THEN DO:
                            /*----------------------------------------------------------
                               N∆o ser† poss°vel remover o rma-item somente quando seu 
                               recebimento for do tipo F÷SICO.
                               ê necess†rio permitir a exclus∆o de registros com rece_
                               bimento n∆o f°sico para que n∆o haja distorá‰es no valor
                               da nota de dÇbito
                             ----------------------------------------------------------*/
                /* Inicio -- Projeto Internacional */
                {utp/ut-table.i movind rma-item 1} /* Busca o label da tabela */
                {method/svc/errors/inserr.i
                        &ErrorNumber="3"
                        &ErrorType="EMS"
                        &ErrorSubType="Error"
                        &ErrorParameters=TRIM(RETURN-VALUE)}
         END. 
      END.
              
    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRMAItDepQty DBOProgram 
PROCEDURE validateRMAItDepQty :
/*------------------------------------------------------------------------------
  Purpose: Validar a quantidade alocada a dep¢sito informada na tela da
           inclus∆o/modificaá∆o de itens do RMA, verificando se a mesma
           est† de acordo com a quantidade a receber.
  Parameters:
  Notes: Validaá∆o especial de tela.
------------------------------------------------------------------------------*/

    IF deRMAItDepQty <> (rowObject.qtd-a-receber - rowObject.qtd-cancelada) THEN DO:
        {method/svc/errors/inserr.i
                &ErrorNumber="27411"
                &ErrorType="EMS"
                &ErrorSubType="Error"}
        RETURN "NOK":U.
    END.

  RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
