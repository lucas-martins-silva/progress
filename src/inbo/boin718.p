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
{include/i-prgvrs.i BOIN718 2.00.00.007 } /*** "010007" 29/11/2023 09:07:15  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN718 MUT}
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
&GLOBAL-DEFINE DBOName BOIN718
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName rma-it-troca
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

&GLOBAL-DEFINE ignoredErrors "3,8,10"

/* PrÇ-processador de release */
{cdp/cdcfgdis.i} 

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

/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin718.i RowObject}

/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}

/*--- Definiá∆o das temp-tables ---*/
{inbo/boin714.i2 rowPermissions}.

/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/*--- Local variables definitions ---*/
DEF VAR cCodEstabel   LIKE rma-item.cod-estabel   NO-UNDO.
DEF VAR cCodRMA       LIKE rma-item.cod-rma       NO-UNDO.
DEF VAR iNumSequencia LIKE rma-item.num-sequencia NO-UNDO.
DEF VAR lValidate     AS LOGICAL INITIAL YES      NO-UNDO.

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
         HEIGHT             = 2.33
         WIDTH              = 31.86.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE clearIgnoredErrors DBOProgram 
PROCEDURE clearIgnoredErrors :
/*------------------------------------------------------------------------------
  Purpose:     
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
  Purpose: Localizar rma relacionado
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM pcCodEstabel   LIKE rma.cod-estabel NO-UNDO.
DEF INPUT PARAM pcCodRMA       LIKE rma.cod-rma     NO-UNDO.

  FOR FIRST rma WHERE
            rma.cod-estabel   = pcCodEstabel AND
            rma.cod-rma       = pcCodRMA       
            NO-LOCK: END.
            
  IF AVAIL rma THEN
    RETURN "OK":U.    
  ELSE
    RETURN "NOK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findRMAItem DBOProgram 
PROCEDURE findRMAItem :
/*------------------------------------------------------------------------------
  Purpose:     
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
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-item":U THEN ASSIGN pFieldValue = RowObject.cod-item.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-pedcli":U THEN ASSIGN pFieldValue = RowObject.cod-pedcli.
        WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
        WHEN "cod-rma":U THEN ASSIGN pFieldValue = RowObject.cod-rma.
        WHEN "cod-tabpre":U THEN ASSIGN pFieldValue = RowObject.cod-tabpre.
        WHEN "cod-un":U THEN ASSIGN pFieldValue = RowObject.cod-un.
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
        WHEN "qtd-pedida":U THEN ASSIGN pFieldValue = RowObject.qtd-pedida.
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
        WHEN "val-pretab":U THEN ASSIGN pFieldValue = RowObject.val-pretab.
        WHEN "val-preuni":U THEN ASSIGN pFieldValue = RowObject.val-preuni.
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
DEF INPUT  PARAM pcCodItem      LIKE rma-item.cod-item NO-UNDO.
DEF OUTPUT PARAM pcDescCodItem  LIKE item.desc-item    NO-UNDO.
DEF OUTPUT PARAM pdeFtConvUnEst LIKE item.ft-conversao NO-UNDO.
DEF OUTPUT PARAM pdeNumCasasDec AS   DEC               NO-UNDO.

  FOR FIRST item WHERE
            item.it-codigo = pcCodItem NO-LOCK: 
     ASSIGN pcDescCoditem  = item.desc-item.
  
      &IF  DEFINED(bf_dis_preco_un_med_mult) &THEN
         RUN getUNData (INPUT rowObject.cod-estabel,
                        INPUT rowObject.cod-rma,
                        INPUT rowObject.cod-item,
                        INPUT rowObject.cod-un,
                        OUTPUT pdeFtConvUnEst,
                        OUTPUT pdeNumCasasDec).        
      &ELSE
         ASSIGN pdeFtConvUnEst = item.ft-conversao
                pdeNumCasasDec = DEC(item.dec-conv-fmcoml).
      &ENDIF
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
  Purpose:     Retorna valores dos campos do °ndice rma-it-troca
  Parameters:  
               retorna valor do campo cod-estabel
               retorna valor do campo cod-rma
               retorna valor do campo num-sequencia
               retorna valor do campo cod-item
               retorna valor do campo cod-refer
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE rma-it-troca.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-rma LIKE rma-it-troca.cod-rma NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-sequencia LIKE rma-it-troca.num-sequencia NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-item LIKE rma-it-troca.cod-item NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-refer LIKE rma-it-troca.cod-refer NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-estabel = RowObject.cod-estabel
           pcod-rma = RowObject.cod-rma
           pnum-sequencia = RowObject.num-sequencia
           pcod-item = RowObject.cod-item
           pcod-refer = RowObject.cod-refer.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getReference DBOProgram 
PROCEDURE getReference :
/*------------------------------------------------------------------------------
  Purpose: Buscar a descriá∆o da referància do item de troca do RMA
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT  PARAM cCodRefer  LIKE rma-it-troca.cod-refer NO-UNDO.
DEF OUTPUT PARAM cDescRefer LIKE referencia.descricao   NO-UNDO.

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
    IF RETURN-VALUE <> "OK" THEN
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
               pNrCasasDecimais = item-cli.num-casa-dec
               .
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
    ELSE
       IF NOT AVAIL item-cli        AND
          NOT AVAIL item-unid-venda THEN
          RETURN "NOK":U.
    
 &ENDIF.
 
 RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice rma-it-troca
  Parameters:  
               recebe valor do campo cod-estabel
               recebe valor do campo cod-rma
               recebe valor do campo num-sequencia
               recebe valor do campo cod-item
               recebe valor do campo cod-refer
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE rma-it-troca.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pcod-rma LIKE rma-it-troca.cod-rma NO-UNDO.
    DEFINE INPUT PARAMETER pnum-sequencia LIKE rma-it-troca.num-sequencia NO-UNDO.
    DEFINE INPUT PARAMETER pcod-item LIKE rma-it-troca.cod-item NO-UNDO.
    DEFINE INPUT PARAMETER pcod-refer LIKE rma-it-troca.cod-refer NO-UNDO.

    FIND FIRST bfrma-it-troca WHERE 
        bfrma-it-troca.cod-estabel = pcod-estabel AND 
        bfrma-it-troca.cod-rma = pcod-rma AND 
        bfrma-it-troca.num-sequencia = pnum-sequencia AND 
        bfrma-it-troca.cod-item = pcod-item AND 
        bfrma-it-troca.cod-refer = pcod-refer NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfrma-it-troca THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfrma-it-troca)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
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

    OPEN QUERY {&queryName} FOR EACH {&tableName} NO-LOCK INDEXED-REPOSITION.

  RETURN "OK":U.
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
    
  FOR FIRST item WHERE
            item.it-codigo = rowObject.cod-item NO-LOCK:     
      ASSIGN rowObject.cod-un = item.un.       
  END.
     
  IF NOT AVAIL item THEN 
    RETURN "NOK":U.
  ELSE    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDefaultsPriceTable DBOProgram 
PROCEDURE setDefaultsPriceTable :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FIND FIRST rowObject NO-ERROR.
  IF NOT AVAIL rowObject THEN
    RETURN "NOK":U.      
  
  IF rowObject.cod-tabpre <> "" THEN 
    FOR FIRST preco-item where
              preco-item.nr-tabpre    = rowObject.cod-tabpre AND
              preco-item.it-codigo    = rowObject.cod-item   AND
              preco-item.cod-refer    = rowObject.cod-refer  AND
              preco-item.cod-unid-med = rowObject.cod-un     AND
              preco-item.quant-min   <= rowObject.qtd-pedida AND
              preco-item.dt-inival   <= TODAY NO-LOCK:
         ASSIGN rowObject.val-preuni = preco-item.preco-venda.     
    END. 
    
  IF NOT AVAIL preco-item THEN
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
    
  FOR FIRST param-estoq NO-LOCK: END.
  IF NOT AVAIL param-estoq THEN 
    RETURN "NOK":U.
    
  FOR FIRST rma-param WHERE 
            rma-param.cod-estabel = param-estoq.estabel-pad 
            NO-LOCK: END.
  IF NOT AVAIL rma-param THEN 
    RETURN "NOK":U.  
  
   CASE pEvent:   
   
     /*---- LEAVE-COD-ITEM ----*/
     WHEN "leave-cod-item":U THEN DO:
       FOR FIRST item WHERE
                 item.it-codigo = rowObject.cod-item NO-LOCK: END.
       IF NOT AVAIL item         OR
          item.tipo-con-est <> 4 THEN
          RUN createRowPermissions (INPUT "rma-it-troca":U, INPUT "cod-refer":U).
     END.     
     /*---- ENABLEfIELDS ----*/
     WHEN "enableFields":U THEN DO:
       IF pType = "UPDATE":U THEN DO:
         RUN createRowPermissions (INPUT "rma-it-troca":U, INPUT "cod-item":U).
         RUN createRowPermissions (INPUT "rma-it-troca":U, INPUT "cod-refer":U).
       END.
     END.     
     
   END CASE.
  
  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setRowObjectAux DBOProgram 
PROCEDURE setRowObjectAux :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM TABLE FOR rowObjectAux.

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
    
    &IF DEFINED(bf_dis_preco_un_med_mult) &THEN
        DEFINE VARIABLE deFatorConversao  AS DECIMAL NO-UNDO.
        DEFINE VARIABLE deNrCasasDecimais AS DECIMAL NO-UNDO.
    &ENDIF

    /*--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as validaá‰es ---*/
    
    IF NOT lValidate THEN
      RETURN "OK":U.
    
    FIND FIRST rowObject NO-ERROR.
    IF NOT AVAIL rowObject THEN
      RETURN "NOK":U.
    
    IF pType = "CREATE":U OR pType = "UPDATE":U THEN DO:
        
        /* Preáo deve ser maior que zero */
        IF rowObject.val-preuni <= 0 THEN DO:
                {method/svc/errors/inserr.i
                        &ErrorNumber="8630"
                        &ErrorType="EMS"
                        &ErrorSubType="Error"}        
        END.
        
        /* Quantidade deve ser maior que zero */        
        IF rowObject.qtd-pedida <= 0 THEN DO:
        {method/svc/errors/inserr.i
                &ErrorNumber="2608"
                &ErrorType="EMS"
                &ErrorSubType="Error"}
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
           /*
           /*Item n∆o pode ser de dÇbito direto */
           IF item.tipo-contr = 4 THEN DO:
                {method/svc/errors/inserr.i
                        &ErrorNumber="1673"
                        &ErrorType="EMS"
                        &ErrorSubType="Error"}   
           END.
           */                                  
           /* Item obsoleto */
           IF item.cod-obsoleto = 4 THEN DO:
                {method/svc/errors/inserr.i
                        &ErrorNumber="17472"
                        &ErrorType="EMS"
                        &ErrorSubType="Error"}
           END.
        END.
       /* Verifica se a quantidade Ç inteira ou fracionada */
       IF TRUNCATE (rowObject.qtd-pedida, 0) <> rowObject.qtd-pedida AND
          NOT item.fraciona THEN DO:
                {method/svc/errors/inserr.i
                               &ErrorNumber="1892"
                               &ErrorType="EMS"
                               &ErrorSubType="Error"}
       END.
        


        /* Unidade de medida do item */
        &IF  DEFINED(bf_dis_preco_un_med_mult) &THEN
        
          FOR FIRST rma WHERE
                    rma.cod-estabel = rowObject.cod-estabel AND
                    rma.cod-rma     = rowObject.cod-rma 
                    NO-LOCK:
             FOR FIRST emitente WHERE 
                       emitente.cod-emitente = rma.cdn-emitente
                       NO-LOCK: END.
          END.
      
          IF NOT AVAIL emitente THEN
            RETURN "NOK":U.        

          RUN getUNData (INPUT rowObject.cod-estabel,
                         INPUT rowObject.cod-rma,
                         INPUT rowObject.cod-item,
                         INPUT rowObject.cod-un,
                         OUTPUT deFatorConversao,
                         OUTPUT deNrCasasDecimais).        

          IF RETURN-VALUE <> "OK":U THEN
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
        

        /* Tabela de preáos */
        IF rowObject.cod-tabpre <> "" THEN
          IF NOT CAN-FIND (FIRST preco-item where
                                 preco-item.nr-tabpre    = rowObject.cod-tabpre AND
                                 preco-item.it-codigo    = rowObject.cod-item   AND
                                 preco-item.cod-refer    = rowObject.cod-refer  AND
                                 preco-item.cod-unid-med = rowObject.cod-un     AND
                                 preco-item.quant-min   <= rowObject.qtd-pedida AND
                                 preco-item.dt-inival   <= TODAY)                  THEN DO:
                {method/svc/errors/inserr.i
                        &ErrorNumber="27222"
                        &ErrorType="EMS"
                        &ErrorSubType="Error"}
          END.
          
        /* Unidade de medida */
        IF  NOT CAN-FIND (FIRST tab-unidade WHERE tab-unidade.un = rowObject.cod-un) THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-table.i mgind tab-unidade 1} /* Busca o label da tabela */
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateTTRecord DBOProgram 
PROCEDURE validateTTRecord :
/*------------------------------------------------------------------------------
  Purpose: Validaá∆o especial para verificar se o registro a ser criado j† n∆o
           est† duplicado em tela 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DEF INPUT PARAM pType AS CHAR NO-UNDO.

    IF  pType = "CREATE":U THEN DO:
        IF CAN-FIND (FIRST rowObjectAux WHERE
                           rowObjectAux.cod-estabel   = rowObject.cod-estabel   AND
                           rowObjectAux.cod-rma       = rowObject.cod-rma       AND
                           rowObjectAux.num-sequencia = rowObject.num-sequencia AND
                           rowObjectAux.cod-item      = rowObject.cod-item      AND
                           rowObjectAux.cod-refer     = rowObject.cod-refer) THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-item-troca AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Item_Troca" *}
            ASSIGN c-lbl-liter-item-troca = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                    &ErrorNumber="1"
                    &ErrorType="EMS"
                    &ErrorSubType="Error"
                    &ErrorParameters="c-lbl-liter-item-troca"}
            RETURN "NOK":U.
        END.
    END.    

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
