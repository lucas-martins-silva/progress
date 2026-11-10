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
{include/i-prgvrs.i BOCX348 2.00.00.013 } /*** "010013" 11/12/2023 10:13:26 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bocx348 MUT}
&ENDIF
{cdp/cdcfgcex.i}
/*:T--------------------------------------------------------------------------
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

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOCX348
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName reg-export-item
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

&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (mÇtodo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /*:T Nome da Query que d† acessos a todos os registros, exceto os exclu°dos pela constraint de seguranáa. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /*:T Informar os campos da chave quando o Progress n∆o conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

/*:T--- Include com definiá∆o da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{cxbo/bocx348.i RowObject}

{cxbo/bocx348.i tt-reg-export-item}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE i-nr-re-ems  LIKE {&TableName}.nr-re-ems NO-UNDO.

DEFINE TEMP-TABLE tt-item-proc-exp NO-UNDO
     FIELD cod-estabel          LIKE proc-ped-ent.cod-estabel 
     FIELD nr-proc-exp          LIKE proc-ped-ent.nr-proc-exp
     FIELD nr-re-ems            LIKE reg-export-item.nr-re-ems
     FIELD nr-pedcli            LIKE proc-ped-ent.nr-pedcli
     FIELD nome-abrev           LIKE proc-ped-ent.nome-abrev
     FIELD nr-sequencia         LIKE proc-ped-ent.nr-sequencia
     FIELD nr-entrega           LIKE proc-ped-ent.nr-entrega
     FIELD it-codigo            LIKE proc-ped-ent.it-codigo
     FIELD cod-refer            LIKE proc-ped-ent.cod-refer
     FIELD qtd-unid-item        LIKE reg-export-item.qtd-unid-item
     FIELD qtd-saldo            LIKE reg-export-item.qtd-unid-item
     FIELD un-fatur             LIKE ITEM.un
     FIELD cod-unid-medid-item  LIKE ITEM.un
     FIELD descricao            LIKE ITEM.desc-item
     FIELD r-rowid              AS   ROWID.

DEFINE TEMP-TABLE tt-reg-export-item-aux NO-UNDO LIKE tt-reg-export-item.

DEFINE TEMP-TABLE tt-item-re NO-UNDO LIKE reg-export-item
     FIELD qt-re                LIKE reg-export-item.qtd-unid-item
     FIELD descricao            LIKE ITEM.desc-item
     FIELD r-rowid              AS ROWID.

DEFINE VARIABLE d-qtd-saldo LIKE tt-item-proc-exp.qtd-saldo NO-UNDO.

DEFINE VARIABLE  de-qtd-unid-comerc LIKE tt-reg-export-item.qtd-unid-comerc NO-UNDO.
DEFINE VARIABLE  de-cod-unid-comerc LIKE tt-reg-export-item.cod-unid-medid-comerc NO-UNDO.
DEFINE VARIABLE  de-qtd-unid-ncm    LIKE tt-reg-export-item.qtd-unid-ncm NO-UNDO.
DEFINE VARIABLE  de-cod-unid-ncm    LIKE tt-reg-export-item.cod-unid-medid-ncm  NO-UNDO.

DEFINE VARIABLE  h-bocx347 AS HANDLE NO-UNDO.
DEFINE VARIABLE  h-exapi014 AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx349   AS HANDLE      NO-UNDO.
DEFINE VARIABLE de-vl-desp    AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999" EXTENT 5 NO-UNDO.
{exp/exapi014.i}
def temp-table tt-desp-item-aux no-undo
    field cod-estabel         LIKE reg-export.cod-estabel
    FIELD nr-proc-exp         LIKE reg-export.nr-proc-exp
    FIELD nome-abrev          LIKE reg-export-item.nome-abrev
    FIELD nr-pedcli           LIKE reg-export-item.nr-pedcli
    FIELD nr-sequencia        LIKE reg-export-item.num-seq
    FIELD it-codigo           LIKE reg-export-item.it-codigo
    FIELD cod-refer           LIKE reg-export-item.cod-refer
    FIELD nr-entrega          LIKE reg-export-item.nr-entrega
    FIELD cod-itiner          LIKE processo-exp.cod-itiner
    FIELD cod-pto-contr       LIKE pto-contr.cod-pto-contr
    FIELD cod-desp            LIKE desp-item.cod-desp
    FIELD vl-desp-mo-desp     AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999" EXTENT 5
    FIELD vl-desp-mo-proc-exp AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999" EXTENT 5
    FIELD de-val-desp-inc     AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999" EXTENT 5.

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
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 21.67
         WIDTH              = 36.86.
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

DEFINE TEMP-TABLE tt-erros NO-UNDO LIKE RowErrors.

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

  IF NOT VALID-HANDLE (h-bocx347) THEN
     RUN cxbo/bocx347.p PERSISTENT SET h-bocx347.
 
  IF AVAIL {&TableName} THEN DO:

     IF VALID-HANDLE (h-bocx347) THEN
        RUN atualizaUltAlteracao IN h-bocx347 (INPUT {&TableName}.nr-re-ems).

  end. 
              
  IF VALID-HANDLE (h-bocx347) THEN
     DELETE PROCEDURE h-bocx347.

  ASSIGN h-bocx347 = ?.
               
  IF NOT VALID-HANDLE(h-bocx349) THEN
      RUN cxbo/bocx349.p PERSISTENT SET h-bocx349.

  RUN atualizaValoresAnexo IN h-bocx349(INPUT RowObject.nr-re-ems).

  IF VALID-HANDLE (h-bocx349) THEN
     DELETE PROCEDURE h-bocx349.

  ASSIGN h-bocx349 = ?.
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

  DEFINE VARIABLE i-cont AS INTEGER NO-UNDO.
  
  IF AVAIL rowobject THEN DO:

     ASSIGN  i-cont = 0.

     FOR EACH bfreg-export-item EXCLUSIVE-LOCK
         WHERE bfreg-export-item.nr-re-ems   = rowobject.nr-re-ems
           AND bfreg-export-item.cod-estabel = rowobject.cod-estabel
           AND bfreg-export-item.nr-proc-exp = rowobject.nr-proc-exp
           AND bfreg-export-item.nome-abrev  = rowobject.nome-abrev
           AND bfreg-export-item.nr-pedcli   = rowobject.nr-pedcli
           AND bfreg-export-item.num-seq     = rowobject.num-seq
           AND bfreg-export-item.it-codigo   = rowobject.it-codigo
           AND bfreg-export-item.cod-refer   = rowobject.cod-refer
           AND bfreg-export-item.nr-entrega  = rowobject.nr-entrega:

         ASSIGN i-cont = i-cont + 1. 

         ASSIGN bfreg-export-item.num-ocor-item =  i-cont.


     END.

     IF NOT VALID-HANDLE(h-bocx349) THEN
         RUN cxbo/bocx349.p PERSISTENT SET h-bocx349.
    
     RUN atualizaValoresAnexo IN h-bocx349(INPUT RowObject.nr-re-ems).
    
      IF VALID-HANDLE (h-bocx349) THEN
         DELETE PROCEDURE h-bocx349.
    
      ASSIGN h-bocx349 = ?.

     IF NOT VALID-HANDLE (h-bocx347) THEN
        RUN cxbo/bocx347.p PERSISTENT SET h-bocx347.

     IF VALID-HANDLE (h-bocx347) THEN
        RUN atualizaUltAlteracao IN h-bocx347 (INPUT rowobject.nr-re-ems).

     IF VALID-HANDLE (h-bocx347) THEN
        DELETE PROCEDURE h-bocx347.

     ASSIGN h-bocx347 = ?.

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

  IF NOT VALID-HANDLE (h-bocx347) THEN
     RUN cxbo/bocx347.p PERSISTENT SET h-bocx347.
 
  IF AVAIL {&TableName} THEN DO:

     IF VALID-HANDLE (h-bocx347) THEN
        RUN atualizaUltAlteracao IN h-bocx347 (INPUT {&TableName}.nr-re-ems).

  end. 
  IF NOT VALID-HANDLE(h-bocx349) THEN
      RUN cxbo/bocx349.p PERSISTENT SET h-bocx349.

  RUN atualizaValoresAnexo IN h-bocx349(INPUT RowObject.nr-re-ems).
              
  IF VALID-HANDLE (h-bocx347) THEN
     DELETE PROCEDURE h-bocx347.

  ASSIGN h-bocx347 = ?.
  IF VALID-HANDLE (h-bocx349) THEN
     DELETE PROCEDURE h-bocx349.

  ASSIGN h-bocx349 = ?.
               
  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaItem DBOProgram 
PROCEDURE atualizaItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER TABLE FOR tt-reg-export-item.

  FIND FIRST tt-reg-export-item NO-LOCK NO-ERROR.

  FIND FIRST  bf{&TableName} EXCLUSIVE-LOCK 
       WHERE ROWID ( bf{&TableName}) = tt-reg-export-item.r-rowid NO-ERROR.

  IF AVAIL  bf{&TableName} THEN DO:

     ASSIGN  bf{&TableName}.cdn-anexo = tt-reg-export-item.cdn-anexo.

  END.

  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDeleteRecord DBOProgram 
PROCEDURE beforeDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  IF rowobject.cdn-anexo <> 0 THEN DO:
     FIND FIRST bf{&TableName} NO-LOCK 
          WHERE bf{&TableName}.nr-re-ems = rowobject.nr-re-ems
            AND bf{&TableName}.cdn-anexo = rowobject.cdn-anexo
            AND ROWID(bf{&TableName})   <> rowobject.r-rowid NO-ERROR.
     IF NOT AVAIL bf{&TableName} THEN DO:
        FIND FIRST reg-export-anexo EXCLUSIVE-LOCK 
             WHERE reg-export-anexo.nr-re-ems = rowobject.nr-re-ems
               AND reg-export-anexo.cdn-anexo = rowobject.cdn-anexo NO-ERROR.
        IF AVAIL reg-export-anexo THEN
           DELETE reg-export-anexo.
     END.


  END.

  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CarregaTTItemProcExp DBOProgram 
PROCEDURE CarregaTTItemProcExp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE  INPUT PARAMETER pEstabel LIKE reg-export.cod-estabel NO-UNDO.
  DEFINE  INPUT PARAMETER pNrProc  LIKE reg-export.nr-proc-exp NO-UNDO.
  DEFINE  INPUT PARAMETER pNrReEms LIKE reg-export.nr-re-ems   NO-UNDO.

  FOR EACH tt-item-proc-exp:
      DELETE tt-item-proc-exp.
  END.

  FOR EACH proc-ped-ent NO-LOCK 
      WHERE proc-ped-ent.cod-estabel = pEstabel
        AND proc-ped-ent.nr-proc-exp = pNrProc:

      FIND FIRST ITEM NO-LOCK 
           WHERE ITEM.it-codigo = proc-ped-ent.it-codigo NO-ERROR.

      FIND FIRST ped-item NO-LOCK 
           WHERE ped-item.nome-abrev = proc-ped-ent.nome-abrev 
             AND ped-item.nr-pedcli  = proc-ped-ent.nr-pedcli
             AND ped-item.nr-sequencia = proc-ped-ent.nr-sequencia
             AND ped-item.it-codigo = proc-ped-ent.it-codigo 
             AND ped-item.cod-refer = proc-ped-ent.cod-refer NO-ERROR.

      IF NOT AVAIL ped-item THEN NEXT.

      IF ped-item.ind-componen = 3 THEN NEXT.

      CREATE tt-item-proc-exp.
      ASSIGN tt-item-proc-exp.cod-estabel   = proc-ped-ent.cod-estabel
             tt-item-proc-exp.nr-proc-exp   = proc-ped-ent.nr-proc-exp
             tt-item-proc-exp.nr-re-ems     = pNrReEms
             tt-item-proc-exp.nome-abrev    = proc-ped-ent.nome-abrev
             tt-item-proc-exp.nr-pedcli     = proc-ped-ent.nr-pedcli
             tt-item-proc-exp.nr-sequencia  = proc-ped-ent.nr-sequencia
             tt-item-proc-exp.nr-entrega    = proc-ped-ent.nr-entrega
             tt-item-proc-exp.it-codigo     = proc-ped-ent.it-codigo
             tt-item-proc-exp.cod-refer     = proc-ped-ent.cod-refer
             tt-item-proc-exp.qtd-unid-item = proc-ped-ent.quantidade[1]
             tt-item-proc-exp.qtd-saldo     = proc-ped-ent.quantidade[1]
             tt-item-proc-exp.r-rowid       = ROWID (proc-ped-ent).


      ASSIGN tt-item-proc-exp.descricao = ITEM.desc-item
             tt-item-proc-exp.cod-unid-medid-item = ITEM.un.

      RUN converteQuantidade 
                      (  INPUT proc-ped-ent.idi-unid-fatur,   
                         INPUT proc-ped-ent.nome-abrev,       
                         INPUT proc-ped-ent.nr-pedcli,        
                         INPUT proc-ped-ent.nr-sequencia,     
                         INPUT proc-ped-ent.it-codigo,        
                         INPUT proc-ped-ent.cod-refer,        
                         INPUT proc-ped-ent.quantidade[1],   
                         INPUT proc-ped-ent.quantidade[2],   
                         INPUT tt-item-proc-exp.qtd-unid-item,    
                         INPUT tt-item-proc-exp.cod-unid-medid-item,  
                        OUTPUT de-qtd-unid-comerc,
                        OUTPUT de-cod-unid-comerc,
                        OUTPUT de-qtd-unid-ncm,   
                        OUTPUT de-cod-unid-ncm). 

      ASSIGN tt-item-proc-exp.un-fatur = de-cod-unid-comerc.

      FOR EACH bf{&TableName} NO-LOCK
          WHERE bf{&TableName}.cod-estabel = tt-item-proc-exp.cod-estabel
            AND bf{&TableName}.nr-proc-exp = tt-item-proc-exp.nr-proc-exp
            AND bf{&TableName}.nome-abrev  = tt-item-proc-exp.nome-abrev
            AND bf{&TableName}.nr-pedcli   = tt-item-proc-exp.nr-pedcli
            AND bf{&TableName}.num-seq     = tt-item-proc-exp.nr-sequencia
            AND bf{&tablename}.it-codigo   = tt-item-proc-exp.it-codigo
            AND bf{&TableName}.cod-refer   = tt-item-proc-exp.cod-refer
            AND bf{&TableName}.nr-entrega  = tt-item-proc-exp.nr-entrega:
            ASSIGN tt-item-proc-exp.qtd-saldo = tt-item-proc-exp.qtd-saldo - 
                                                bf{&TableName}.qtd-unid-item.
      END.

  END.


  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CarregaTTItemRE DBOProgram 
PROCEDURE CarregaTTItemRE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pNrReEms LIKE reg-export.nr-re-ems NO-UNDO.

  FOR EACH tt-item-re:
      DELETE tt-item-re.
  END.

  FOR EACH bf{&TableName} NO-LOCK 
      WHERE bf{&TableName}.nr-re-ems = pNrReEms :

      FIND FIRST proc-ped-ent NO-LOCK 
           WHERE proc-ped-ent.cod-estabel  = bf{&TableName}.cod-estabel
             AND proc-ped-ent.nr-proc-exp  = bf{&TableName}.nr-proc-exp
             AND proc-ped-ent.nome-abrev   = bf{&TableName}.nome-abrev
             AND proc-ped-ent.nr-pedcli    = bf{&TableName}.nr-pedcli
             AND proc-ped-ent.nr-sequencia = bf{&TableName}.num-seq
             AND proc-ped-ent.cod-refer    = bf{&TableName}.cod-refer
             AND proc-ped-ent.nr-entrega   = bf{&TableName}.nr-entrega NO-ERROR.

      IF NOT AVAIL proc-ped-ent THEN NEXT.

      FIND FIRST ITEM NO-LOCK 
           WHERE ITEM.it-codigo = proc-ped-ent.it-codigo NO-ERROR.

      IF NOT AVAIL ITEM THEN NEXT.


      CREATE tt-item-re.
      ASSIGN tt-item-re.nr-re-ems     = pNrReEms
             tt-item-re.cod-estabel   = bf{&TableName}.cod-estabel
             tt-item-re.nr-proc-exp   = bf{&TableName}.nr-proc-exp
             tt-item-re.nome-abrev    = bf{&TableName}.nome-abrev
             tt-item-re.nr-pedcli     = bf{&TableName}.nr-pedcli
             tt-item-re.num-seq       = bf{&TableName}.num-seq
             tt-item-re.nr-entrega    = bf{&TableName}.nr-entrega
             tt-item-re.it-codigo     = bf{&tablename}.it-codigo
             tt-item-re.cod-refer     = bf{&TableName}.cod-refer
             tt-item-re.num-ocor-item = bf{&TableName}.num-ocor-item
             tt-item-re.qtd-unid-item = IF AVAIL proc-ped-ent THEN proc-ped-ent.quantidade[1] ELSE 0
             tt-item-re.qt-re         = bf{&TableName}.qtd-unid-item
             tt-item-re.cod-unid-medid-item = bf{&TableName}.cod-unid-medid-item 
             tt-item-re.descricao     = ITEM.desc-item
             tt-item-re.r-rowid       = ROWID (bf{&TableName}).

  END.
  

  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE converteQuantidade DBOProgram 
PROCEDURE converteQuantidade :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE  INPUT PARAMETER pIdi-unid-fatur    AS INTEGER NO-UNDO.
  DEFINE  INPUT PARAMETER pnome-abrev        AS CHAR NO-UNDO.
  DEFINE  INPUT PARAMETER pnr-pedcli         AS CHAR NO-UNDO.
  DEFINE  INPUT PARAMETER pnr-sequencia      AS INTEGER NO-UNDO.
  DEFINE  INPUT PARAMETER pit-codigo         AS CHAR NO-UNDO.
  DEFINE  INPUT PARAMETER pcod-refer         AS CHAR NO-UNDO.
  DEFINE  INPUT PARAMETER de-quantidade-1    LIKE proc-ped-ent.quantidade[1] NO-UNDO.
  DEFINE  INPUT PARAMETER de-quantidade-2    LIKE proc-ped-ent.quantidade[2] NO-UNDO.
  DEFINE  INPUT PARAMETER pqtd-unid-item     LIKE tt-reg-export-item.qtd-unid-item   NO-UNDO.
  DEFINE  INPUT PARAMETER pcod-unid-item     LIKE tt-reg-export-item.cod-unid-medid-item NO-UNDO.
  DEFINE OUTPUT PARAMETER de-qtd-unid-comerc LIKE tt-reg-export-item.qtd-unid-comerc NO-UNDO.
  DEFINE OUTPUT PARAMETER de-cod-unid-comerc LIKE tt-reg-export-item.cod-unid-medid-comerc NO-UNDO.
  DEFINE OUTPUT PARAMETER de-qtd-unid-ncm    LIKE tt-reg-export-item.qtd-unid-ncm    NO-UNDO.
  DEFINE OUTPUT PARAMETER de-cod-unid-ncm    LIKE tt-reg-export-item.cod-unid-medid-ncm NO-UNDO.
  
  /* Campos tt-reg-export-item.qtd-unid-comerc e tt-reg-expor-item.cod-unid-medid-comerc */


  CASE pIdi-unid-fatur:
      WHEN 1 THEN DO: /* Unidade do item */
         ASSIGN de-qtd-unid-comerc = pqtd-unid-item
                de-cod-unid-comerc = pcod-unid-item.
      END.
      WHEN 2 THEN do: /* unidade da fam°lia de materiais */
         FIND FIRST ITEM NO-LOCK 
              WHERE ITEM.it-codigo = pit-codigo NO-ERROR.
         FIND FIRST familia NO-LOCK 
              WHERE familia.fm-codigo = ITEM.fm-codigo NO-ERROR.
         ASSIGN de-cod-unid-comerc = familia.un.
         IF pqtd-unid-item = de-quantidade-1 THEN
            ASSIGN de-qtd-unid-comerc = de-quantidade-2.
         ELSE DO:
             /* ASSIGN de-qtd-unid-comerc = pqtd-unid-item * ITEM.ft-conversao / EXP(10,ITEM.dec-ftcon). */
             FIND FIRST item-unid-venda NO-LOCK
                  WHERE item-unid-venda.it-codigo = pit-codigo
                    AND item-unid-venda.un        = familia.un NO-ERROR.
            
             IF AVAIL item-unid-venda THEN
                 ASSIGN de-qtd-unid-comerc = pqtd-unid-item / (item-unid-venda.fator-conversao / EXP(10,item-unid-venda.num-casa-dec)).
             ELSE
                 ASSIGN de-qtd-unid-comerc = pqtd-unid-item.
         END.
      END.
      WHEN 3 THEN DO:
         FIND FIRST item-cli NO-LOCK 
              WHERE item-cli.nome-abrev = pnome-abrev 
                AND item-cli.it-codigo  = pit-codigo
                AND item-cli.log-unid-prefer
                AND item-cli.ind-sit-relac = 1 NO-ERROR.
         if  not avail item-cli then do:
             FIND FIRST item-cli NO-LOCK
                  WHERE item-cli.nome-abrev    = pnome-abrev
                    AND item-cli.it-codigo     = pit-codigo
                    AND item-cli.ind-sit-relac = 1 NO-ERROR.
         end.
         ASSIGN de-cod-unid-comerc = IF AVAIL item-cli THEN item-cli.unid-med-cli ELSE "".
         IF pqtd-unid-item = de-quantidade-1 THEN
            ASSIGN de-qtd-unid-comerc = de-quantidade-2.
         ELSE DO:
             IF AVAIL item-cli THEN
                ASSIGN de-qtd-unid-comerc = pqtd-unid-item / (item-cli.fator-conversao / EXP(10,item-cli.num-casa-dec)).
         END.
      END.

  END CASE.

  /* Campos tt-reg-export-item.qtd-unid-ncm e tt-reg-expor-item.cod-unid-medid-ncm */

  FIND FIRST ITEM NO-LOCK 
       WHERE ITEM.it-codigo = pit-codigo NO-ERROR.

  FIND FIRST ped-item NO-LOCK 
       WHERE ped-item.nome-abrev   = pnome-abrev 
         AND ped-item.nr-pedcli    = pnr-pedcli
         AND ped-item.nr-sequencia = pnr-sequencia
         AND ped-item.it-codigo    = pit-codigo
         AND ped-item.cod-refer    = pcod-refer NO-ERROR.

  FIND FIRST classif-fisc NO-LOCK 
       WHERE classif-fisc.class-fiscal = SUBSTRING(ped-item.char-2,01,08) NO-ERROR.
  IF  NOT AVAIL classif-fisc THEN
      FIND FIRST classif-fisc NO-LOCK 
           WHERE classif-fisc.class-fiscal = item.class-fiscal NO-ERROR.

  IF AVAIL classif-fisc THEN
     ASSIGN de-cod-unid-ncm = classif-fisc.unidade.

  IF AVAIL classif-fisc THEN
     ASSIGN de-cod-unid-ncm = classif-fisc.unidade.

  ASSIGN de-qtd-unid-ncm = pqtd-unid-item * ITEM.fator-conver.
  
  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CreateRegExportItemPar DBOProgram 
PROCEDURE CreateRegExportItemPar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
     DEFINE INPUT PARAMETER pNr-re-ems           LIKE reg-export-item.nr-re-ems NO-UNDO.
     DEFINE INPUT PARAMETER pCod-estabel         LIKE reg-export-item.cod-estabel NO-UNDO.
     DEFINE INPUT PARAMETER pNr-proc-exp         LIKE reg-export-item.nr-proc-exp NO-UNDO.
     DEFINE INPUT PARAMETER pNome-abrev          LIKE reg-export-item.nome-abrev NO-UNDO.
     DEFINE INPUT PARAMETER pNr-pedcli           LIKE reg-export-item.nr-pedcli NO-UNDO.
     DEFINE INPUT PARAMETER pNum-seq             LIKE reg-export-item.num-seq NO-UNDO.
     DEFINE INPUT PARAMETER pIt-codigo           LIKE reg-export-item.it-codigo NO-UNDO.
     DEFINE INPUT PARAMETER pCod-refer           LIKE reg-export-item.cod-refer NO-UNDO.
     DEFINE INPUT PARAMETER pNr-entrega          LIKE reg-export-item.nr-entrega NO-UNDO.
     DEFINE INPUT PARAMETER pQtd-saldo           LIKE tt-item-proc-exp.qtd-saldo NO-UNDO.
     DEFINE INPUT PARAMETER pCod-unid-medid-item LIKE tt-item-proc-exp.cod-unid-medid-item NO-UNDO.
     DEFINE OUTPUT PARAMETER d-qtd-saldo         LIKE tt-item-proc-exp.qtd-saldo NO-UNDO.

     DEF VAR de-preco-1 AS DEC NO-UNDO.
     DEF VAR de-preco-2 AS DEC NO-UNDO.

     IF NOT VALID-HANDLE(h-exapi014) THEN
         RUN exp/exapi014.p PERSISTENT SET h-exapi014.

     EMPTY TEMP-TABLE tt-reg-export-item.
     EMPTY TEMP-TABLE tt-reg-export-item-aux.

     FIND LAST bf{&TableName} NO-LOCK 
          WHERE bf{&TableName}.nr-re-ems    = pNr-re-ems
            AND bf{&TableName}.cod-estabel  = pCod-estabel
            AND bf{&TableName}.nr-proc-exp  = pNr-proc-exp
            AND bf{&TableName}.nome-abrev   = pNome-abrev
            AND bf{&TableName}.nr-pedcli    = pNr-pedcli
            AND bf{&TableName}.num-seq      = pNum-seq
            AND bf{&tablename}.it-codigo    = pIt-codigo
            AND bf{&TableName}.cod-refer    = pCod-refer
            AND bf{&TableName}.nr-entrega   = pNr-entrega   NO-ERROR.

     FIND FIRST proc-ped-ent NO-LOCK 
          WHERE proc-ped-ent.cod-estabel    = pCod-estabel  
            AND proc-ped-ent.nr-proc-exp    = pNr-proc-exp 
            AND proc-ped-ent.nome-abrev     = pNome-abrev  
            AND proc-ped-ent.nr-pedcli      = pNr-pedcli   
            AND proc-ped-ent.nr-sequencia   = pNum-seq
            AND proc-ped-ent.it-codigo      = pIt-codigo   
            AND proc-ped-ent.cod-refer      = pCod-refer   
            AND proc-ped-ent.nr-entrega     = pNr-entrega     NO-ERROR.
    
     IF NOT AVAIL proc-ped-ent THEN RETURN "NOK".

     CREATE tt-reg-export-item.
     ASSIGN tt-reg-export-item.cdn-anexo             = 0
            tt-reg-export-item.cod-estabel           = proc-ped-ent.cod-estabel
            tt-reg-export-item.cod-refer             = proc-ped-ent.cod-refer
            tt-reg-export-item.it-codigo             = proc-ped-ent.it-codigo
            tt-reg-export-item.nome-abrev            = proc-ped-ent.nome-abrev
            tt-reg-export-item.nr-entrega            = proc-ped-ent.nr-entrega
            tt-reg-export-item.num-ocor-item         = IF AVAIL bf{&TableName} THEN bf{&TableName}.num-ocor-item + 1 ELSE 1
            tt-reg-export-item.nr-pedcli             = proc-ped-ent.nr-pedcli
            tt-reg-export-item.nr-proc-exp           = proc-ped-ent.nr-proc-exp
            tt-reg-export-item.nr-re-ems             = pNr-re-ems
            tt-reg-export-item.num-seq               = proc-ped-ent.nr-sequencia
            tt-reg-export-item.qtd-unid-item         = pQtd-saldo
            tt-reg-export-item.cod-unid-medid-item   = pCod-unid-medid-item.
    

     RUN converteQuantidade 
                     (  INPUT proc-ped-ent.idi-unid-fatur,   
                        INPUT proc-ped-ent.nome-abrev,       
                        INPUT proc-ped-ent.nr-pedcli,        
                        INPUT proc-ped-ent.nr-sequencia,     
                        INPUT proc-ped-ent.it-codigo,        
                        INPUT proc-ped-ent.cod-refer,        
                        INPUT proc-ped-ent.quantidade[1],   
                        INPUT proc-ped-ent.quantidade[2],   
                        INPUT tt-reg-export-item.qtd-unid-item,    
                        INPUT tt-reg-export-item.cod-unid-medid-item,  
                       OUTPUT de-qtd-unid-comerc,
                       OUTPUT de-cod-unid-comerc,
                       OUTPUT de-qtd-unid-ncm,   
                       OUTPUT de-cod-unid-ncm).   

     ASSIGN tt-reg-export-item.qtd-unid-ncm = trunc(de-qtd-unid-ncm,5)
            tt-reg-export-item.cod-unid-medid-ncm = de-cod-unid-ncm
            tt-reg-export-item.qtd-unid-comerc = trunc(de-qtd-unid-comerc,5)
            tt-reg-export-item.cod-unid-medid-comerc = de-cod-unid-comerc.

     EMPTY TEMP-TABLE tt-desp-item.
     EMPTY TEMP-TABLE tt-desp-item-aux.
     ASSIGN de-vl-desp = 0.

     RUN calculaDespProcExp IN h-exapi014 (INPUT pCod-estabel,
                                           INPUT pNr-proc-exp,
                                           INPUT NO,
                                           OUTPUT TABLE tt-desp-item).
     
     RUN calculaDespProcExp IN h-exapi014 (INPUT pCod-estabel,
                                           INPUT pNr-proc-exp,
                                           INPUT YES,
                                           OUTPUT TABLE tt-desp-item-aux).

     FOR EACH tt-desp-item NO-LOCK      
         WHERE tt-desp-item.cod-estabel  = tt-reg-export-item.cod-estabel 
           AND tt-desp-item.nr-proc-exp  = tt-reg-export-item.nr-proc-exp
           AND tt-desp-item.nome-abrev   = tt-reg-export-item.nome-abrev
           AND tt-desp-item.nr-pedcli    = tt-reg-export-item.nr-pedcli
           AND tt-desp-item.nr-sequencia = tt-reg-export-item.num-seq
           AND tt-desp-item.it-codigo    = tt-reg-export-item.it-codigo
           AND tt-desp-item.cod-refer    = tt-reg-export-item.cod-refer
           AND tt-desp-item.nr-entrega   = tt-reg-export-item.nr-entrega :

          IF tt-reg-export-item.qtd-unid-item = proc-ped-ent.quantidade[1] THEN
             ASSIGN de-vl-desp[1] = de-vl-desp[1] + tt-desp-item.vl-desp-mo-proc-exp[1].
          ELSE
             ASSIGN de-vl-desp[1] = de-vl-desp[1] + ROUND(((tt-reg-export-item.qtd-unid-item / proc-ped-ent.quantidade[1]) * tt-desp-item.vl-desp-mo-proc-exp[1] ),2).
      END.

      FOR EACH tt-desp-item-aux NO-LOCK      
         WHERE tt-desp-item-aux.cod-estabel  = tt-reg-export-item.cod-estabel 
           AND tt-desp-item-aux.nr-proc-exp  = tt-reg-export-item.nr-proc-exp
           AND tt-desp-item-aux.nome-abrev   = tt-reg-export-item.nome-abrev
           AND tt-desp-item-aux.nr-pedcli    = tt-reg-export-item.nr-pedcli
           AND tt-desp-item-aux.nr-sequencia = tt-reg-export-item.num-seq
           AND tt-desp-item-aux.it-codigo    = tt-reg-export-item.it-codigo
           AND tt-desp-item-aux.cod-refer    = tt-reg-export-item.cod-refer
           AND tt-desp-item-aux.nr-entrega   = tt-reg-export-item.nr-entrega :

          IF tt-reg-export-item.qtd-unid-item = proc-ped-ent.quantidade[1] THEN
             ASSIGN de-vl-desp[2] = de-vl-desp[2] + tt-desp-item-aux.vl-desp-mo-proc-exp[2]
                    de-vl-desp[3] = de-vl-desp[3] + tt-desp-item-aux.de-val-desp-inc[1].
          ELSE
             ASSIGN de-vl-desp[2] = de-vl-desp[2] + ROUND(((tt-reg-export-item.qtd-unid-item / proc-ped-ent.quantidade[1]) * tt-desp-item-aux.vl-desp-mo-proc-exp[2] ),2)
                    de-vl-desp[3] = de-vl-desp[3] + ROUND(((tt-reg-export-item.qtd-unid-item / proc-ped-ent.quantidade[1]) * tt-desp-item-aux.de-val-desp-inc[1] ),2).
      END.

      IF  proc-ped-ent.idi-unid-fatur = 3 THEN
          ASSIGN de-preco-1 = ROUND(( tt-reg-export-item.qtd-unid-comerc * proc-ped-ent.vl-preuni ),2) + de-vl-desp[1] - de-vl-desp[3]
                 de-preco-2 = ROUND(( tt-reg-export-item.qtd-unid-comerc * proc-ped-ent.vl-preuni ),2) + de-vl-desp[2] - de-vl-desp[3].
      ELSE
          ASSIGN de-preco-1 = ROUND(( tt-reg-export-item.qtd-unid-item * proc-ped-ent.vl-preuni ),2) + de-vl-desp[1] - de-vl-desp[3]
                 de-preco-2 = ROUND(( tt-reg-export-item.qtd-unid-item * proc-ped-ent.vl-preuni ),2) + de-vl-desp[2] - de-vl-desp[3].

      
      
      IF proc-ped-ent.peso-liquido <> 0 THEN DO:
          IF tt-reg-export-item.qtd-unid-item = proc-ped-ent.quantidade[1] THEN
              ASSIGN OVERLAY(tt-reg-export-item.cod-livre-2,1,20) = string(proc-ped-ent.peso-liquido).
          ELSE
              ASSIGN OVERLAY(tt-reg-export-item.cod-livre-2,1,20) = string((tt-reg-export-item.qtd-unid-item / proc-ped-ent.quantidade[1]) * proc-ped-ent.peso-liquido).

      END.
      ELSE DO:
          FIND FIRST ITEM NO-LOCK
               WHERE ITEM.it-codigo = tt-reg-export-item.it-codigo NO-ERROR.

          ASSIGN OVERLAY(tt-reg-export-item.cod-livre-2,1,20)  = IF AVAIL ITEM THEN STRING(tt-reg-export-item.qtd-unid-item * ITEM.peso-liquido) ELSE string(proc-ped-ent.peso-liquido).
      END.

      ASSIGN OVERLAY(tt-reg-export-item.cod-livre-2,21,20) = STRING(de-preco-1) 
             OVERLAY(tt-reg-export-item.cod-livre-2,41,20) = STRING(de-preco-2).

     run emptyRowObject.
     run emptyRowErrors.
     CREATE tt-reg-export-item-aux.
     BUFFER-COPY tt-reg-export-item TO tt-reg-export-item-aux NO-ERROR.
     run setRecord  (input table tt-reg-export-item-aux).      

     run createRecord.      
     run getRowErrors (output table RowErrors).

     FOR EACH RowErrors
        WHERE RowErrors.ErrorsubType  = "Error":U 
          AND RowErrors.ErrorType    <> "INTERNAL":U NO-LOCK:
         CREATE tt-erros.
         BUFFER-COPY RowErrors TO tt-erros.
     END.
     
     if  can-find(first RowErrors
                  where RowErrors.ErrorsubType  = "Error":U
                   and  RowErrors.ErrorType     = "INTERNAL":U) then do:
         for each RowErrors
             where RowErrors.ErrorsubType = "Error":U
               and RowErrors.ErrorType    =  "INTERNAL":U:
             DELETE rowerrors.
         end.
     end.
     &if ("{&bf_cex_versao_ems}" >= "2.062") &then
         IF NOT CAN-FIND(FIRST tt-erros NO-LOCK) THEN DO:
             FIND FIRST reg-export 
                 WHERE reg-export.nr-re-ems = reg-export-item.nr-re-ems NO-LOCK NO-ERROR.

             IF AVAIL reg-export THEN DO:
                 IF reg-export.nr-ato-consessorio = "" THEN DO:
                    FIND FIRST proc-it-nota-fisc
                        WHERE  proc-it-nota-fisc.nome-abrev   = proc-ped-ent.nome-abrev    AND
                               proc-it-nota-fisc.nr-pedcli    = proc-ped-ent.nr-pedcli     AND
                               proc-it-nota-fisc.nr-sequencia = proc-ped-ent.nr-Sequencia  AND
                               proc-it-nota-fisc.cod-refer    = proc-ped-ent.cod-refer     AND
                               proc-it-nota-fisc.nr-entrega   = proc-ped-ent.nr-entrega    AND
                               proc-it-nota-fisc.it-codigo    = proc-ped-ent.it-codigo     NO-LOCK NO-ERROR.
                    
                    IF AVAIL proc-it-nota-fisc THEN DO:
                        FIND FIRST item-re
                            WHERE  item-re.cod-estabel   = proc-it-nota-fisc.cod-estabel   AND
                                   item-re.cod-nota-fisc = proc-it-nota-fisc.nr-nota-fis   AND
                                   item-re.serie         = proc-it-nota-fisc.serie         AND
                                   item-re.nr-seq-fat    = proc-it-nota-fisc.nr-seq-fat    AND
                                   item-re.it-codigo     = proc-it-nota-fisc.it-codigo     NO-LOCK NO-ERROR.
                        
                        IF AVAIL item-re THEN DO:
                            FIND FIRST Pedido-drb
                                WHERE  pedido-drb.cod-estabel   = item-re.cod-estabel      AND
                                       pedido-drb.nr-pedido-drb = item-re.nr-pedido-drb    NO-LOCK NO-ERROR.
                            
                            IF AVAIL pedido-drb THEN
                                ASSIGN reg-export.nr-ato-consessorio = pedido-drb.nr-ato-concessorio.
                        
                        END.
                    END.
                 END.
             END.                        
         END.
     &endif
     DELETE tt-reg-export-item-aux.

     ASSIGN d-qtd-saldo = proc-ped-ent.quantidade[1].

     FOR EACH  bf{&TableName} NO-LOCK
         WHERE bf{&TableName}.nr-re-ems      = pNr-re-ems
           AND bf{&TableName}.cod-estabel    = tt-reg-export-item.cod-estabel
           AND bf{&TableName}.nr-proc-exp    = tt-reg-export-item.nr-proc-exp
           AND bf{&TableName}.nome-abrev     = tt-reg-export-item.nome-abrev
           AND bf{&TableName}.nr-pedcli      = tt-reg-export-item.nr-pedcli
           AND bf{&TableName}.num-seq        = tt-reg-export-item.num-seq
           AND bf{&tablename}.it-codigo      = tt-reg-export-item.it-codigo
           AND bf{&TableName}.cod-refer      = tt-reg-export-item.cod-refer
           AND bf{&TableName}.nr-entrega     = tt-reg-export-item.nr-entrega:
         ASSIGN d-qtd-saldo = d-qtd-saldo    - bf{&TableName}.qtd-unid-item.
     END.

     ASSIGN pQtd-saldo = d-qtd-saldo.
    
     RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GeraRegExportItemAutom DBOProgram 
PROCEDURE GeraRegExportItemAutom :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  EMPTY TEMP-TABLE tt-erros.
  FOR EACH tt-item-proc-exp
      WHERE tt-item-proc-exp.qtd-saldo > 0 :
      RUN CreateRegExportItemPar ( INPUT tt-item-proc-exp.nr-re-ems,          
                                   INPUT tt-item-proc-exp.cod-estabel,        
                                   INPUT tt-item-proc-exp.nr-proc-exp,     
                                   INPUT tt-item-proc-exp.nome-abrev,         
                                   INPUT tt-item-proc-exp.nr-pedcli,          
                                   INPUT tt-item-proc-exp.nr-sequencia,            
                                   INPUT tt-item-proc-exp.it-codigo,          
                                   INPUT tt-item-proc-exp.cod-refer,          
                                   INPUT tt-item-proc-exp.nr-entrega,         
                                   INPUT tt-item-proc-exp.qtd-saldo,          
                                   INPUT tt-item-proc-exp.cod-unid-medid-item,
                                   OUTPUT d-qtd-saldo).
  END.

  RUN emptyRowErrors.
  FOR EACH tt-erros:
      CREATE RowErrors.
      BUFFER-COPY tt-erros TO RowErrors.
  END.
                
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
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
        WHEN "cod-unid-medid-comerc":U THEN ASSIGN pFieldValue = RowObject.cod-unid-medid-comerc.
        WHEN "cod-unid-medid-item":U THEN ASSIGN pFieldValue = RowObject.cod-unid-medid-item.
        WHEN "cod-unid-medid-ncm":U THEN ASSIGN pFieldValue = RowObject.cod-unid-medid-ncm.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "nome-abrev":U THEN ASSIGN pFieldValue = RowObject.nome-abrev.
        WHEN "nr-pedcli":U THEN ASSIGN pFieldValue = RowObject.nr-pedcli.
        WHEN "nr-proc-exp":U THEN ASSIGN pFieldValue = RowObject.nr-proc-exp.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCurrentTableTTItemProcExp DBOProgram 
PROCEDURE getCurrentTableTTItemProcExp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

     DEFINE OUTPUT PARAMETER TABLE FOR tt-item-proc-exp.


     RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCurrentTableTTItemRE DBOProgram 
PROCEDURE getCurrentTableTTItemRE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

     DEFINE OUTPUT PARAMETER TABLE FOR tt-item-re.


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
        WHEN "qtd-unid-comerc":U THEN ASSIGN pFieldValue = RowObject.qtd-unid-comerc.
        WHEN "qtd-unid-item":U THEN ASSIGN pFieldValue = RowObject.qtd-unid-item.
        WHEN "qtd-unid-ncm":U THEN ASSIGN pFieldValue = RowObject.qtd-unid-ncm.
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getFirstNrReEms DBOProgram 
PROCEDURE getFirstNrReEms :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice rgxprttm-id
  Parameters:  
               recebe valor do campo nr-re-ems
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-re-ems LIKE reg-export-item.nr-re-ems NO-UNDO.

    FIND FIRST bfreg-export-item WHERE 
        bfreg-export-item.nr-re-ems = pnr-re-ems NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfreg-export-item THEN 
       RETURN "NOK":U.

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
        WHEN "cdn-anexo":U THEN ASSIGN pFieldValue = RowObject.cdn-anexo.
        WHEN "nr-entrega":U THEN ASSIGN pFieldValue = RowObject.nr-entrega.
        WHEN "nr-re-ems":U THEN ASSIGN pFieldValue = RowObject.nr-re-ems.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "num-ocor-item":U THEN ASSIGN pFieldValue = RowObject.num-ocor-item.
        WHEN "num-seq":U THEN ASSIGN pFieldValue = RowObject.num-seq.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice rgxprttm-id
  Parameters:  
               retorna valor do campo nr-re-ems
               retorna valor do campo cod-estabel
               retorna valor do campo nr-proc-exp
               retorna valor do campo nome-abrev
               retorna valor do campo nr-pedcli
               retorna valor do campo num-seq
               retorna valor do campo it-codigo
               retorna valor do campo cod-refer
               retorna valor do campo nr-entrega
               retorna valor do campo num-ocor-item
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnr-re-ems LIKE reg-export-item.nr-re-ems NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE reg-export-item.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-proc-exp LIKE reg-export-item.nr-proc-exp NO-UNDO.
    DEFINE OUTPUT PARAMETER pnome-abrev LIKE reg-export-item.nome-abrev NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-pedcli LIKE reg-export-item.nr-pedcli NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-seq LIKE reg-export-item.num-seq NO-UNDO.
    DEFINE OUTPUT PARAMETER pit-codigo LIKE reg-export-item.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-refer LIKE reg-export-item.cod-refer NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-entrega LIKE reg-export-item.nr-entrega NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-ocor-item LIKE reg-export-item.num-ocor-item NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnr-re-ems = RowObject.nr-re-ems
           pcod-estabel = RowObject.cod-estabel
           pnr-proc-exp = RowObject.nr-proc-exp
           pnome-abrev = RowObject.nome-abrev
           pnr-pedcli = RowObject.nr-pedcli
           pnum-seq = RowObject.num-seq
           pit-codigo = RowObject.it-codigo
           pcod-refer = RowObject.cod-refer
           pnr-entrega = RowObject.nr-entrega
           pnum-ocor-item = RowObject.num-ocor-item.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getQuantSaldo DBOProgram 
PROCEDURE getQuantSaldo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

      DEFINE  INPUT PARAMETER pnr-re-ems LIKE tt-reg-export-item.nr-re-ems   NO-UNDO.
      DEFINE  INPUT PARAMETER pEstabel   LIKE tt-reg-export-item.cod-estabel NO-UNDO.
      DEFINE  INPUT PARAMETER pNrProcExp LIKE tt-reg-export-item.nr-proc-exp NO-UNDO.
      DEFINE  INPUT PARAMETER pNomeAbrev LIKE tt-reg-export-item.nome-abrev  NO-UNDO.
      DEFINE  INPUT PARAMETER pNrPedCli  LIKE tt-reg-export-item.nr-pedcli   NO-UNDO.
      DEFINE  INPUT PARAMETER pNumSeq    LIKE tt-reg-export-item.num-seq     NO-UNDO.
      DEFINE  INPUT PARAMETER pItCodigo  LIKE tt-reg-export-item.it-codigo   NO-UNDO.
      DEFINE  INPUT PARAMETER pCodRefer  LIKE tt-reg-export-item.cod-refer   NO-UNDO.
      DEFINE  INPUT PARAMETER pNrEntrega LIKE tt-reg-export-item.nr-entrega  NO-UNDO.
      DEFINE OUTPUT PARAMETER de-quant-1 AS   DECIMAL                        NO-UNDO.
      DEFINE OUTPUT PARAMETER de-quant-2 AS   DECIMAL                        NO-UNDO.
      DEFINE OUTPUT PARAMETER de-saldo   AS   DECIMAL                        NO-UNDO.
      DEFINE OUTPUT PARAMETER i-unidade  AS   INTEGER                        NO-UNDO.
      DEFINE OUTPUT PARAMETER c-unid-med AS   CHARACTER                      NO-UNDO.
      
      
      ASSIGN i-unidade = 0
             c-unid-med = ""
             de-saldo = 0 
             de-quant-1 = 0
             de-quant-2 = 0.

      FIND FIRST proc-ped-ent NO-LOCK 
           WHERE proc-ped-ent.cod-estabel  = pEstabel 
             AND proc-ped-ent.nr-proc-exp  = pNrProcExp
             AND proc-ped-ent.nome-abrev   = pNomeAbrev
             AND proc-ped-ent.nr-pedcli    = pNrPedCli
             AND proc-ped-ent.nr-sequencia = pNumSeq
             AND proc-ped-ent.it-codigo    = pItCodigo
             AND proc-ped-ent.cod-refer    = pCodRefer
             AND proc-ped-ent.nr-entrega   = pNrEntrega NO-ERROR.

      IF AVAIL proc-ped-ent THEN DO:

         ASSIGN de-quant-1 = proc-ped-ent.quantidade[1]
                de-quant-2 = proc-ped-ent.quantidade[2]
                de-saldo = proc-ped-ent.quantidade[1]
                i-unidade = proc-ped-ent.idi-unid-fatur
                c-unid-med = {cxinc/i01cx195.i 04 proc-ped-ent.idi-unid-fatur}.

         FOR EACH bf{&TableName} NO-LOCK 
             WHERE bf{&TableName}.cod-estabel = proc-ped-ent.cod-estabel
               AND bf{&TableName}.nr-proc-exp = proc-ped-ent.nr-proc-exp
               AND bf{&TableName}.nome-abrev  = proc-ped-ent.nome-abrev
               AND bf{&TableName}.nr-pedcli   = proc-ped-ent.nr-pedcli
               AND bf{&TableName}.num-seq     = proc-ped-ent.nr-sequencia 
               AND bf{&tablename}.it-codigo   = proc-ped-ent.it-codigo
               AND bf{&TableName}.cod-refer   = proc-ped-ent.cod-refer
               AND bf{&TableName}.nr-entrega  = proc-ped-ent.nr-entrega :
             ASSIGN de-saldo = de-saldo - bf{&TableName}.qtd-unid-item.
         END.

      END.

      RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getQuantSaldo DBOProgram 
PROCEDURE getValorItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

      DEFINE  INPUT PARAMETER pnr-re-ems LIKE tt-reg-export-item.nr-re-ems   NO-UNDO.
      DEFINE  INPUT PARAMETER pEstabel   LIKE tt-reg-export-item.cod-estabel NO-UNDO.
      DEFINE  INPUT PARAMETER pNrProcExp LIKE tt-reg-export-item.nr-proc-exp NO-UNDO.
      DEFINE  INPUT PARAMETER pNomeAbrev LIKE tt-reg-export-item.nome-abrev  NO-UNDO.
      DEFINE  INPUT PARAMETER pNrPedCli  LIKE tt-reg-export-item.nr-pedcli   NO-UNDO.
      DEFINE  INPUT PARAMETER pNumSeq    LIKE tt-reg-export-item.num-seq     NO-UNDO.
      DEFINE  INPUT PARAMETER pItCodigo  LIKE tt-reg-export-item.it-codigo   NO-UNDO.
      DEFINE  INPUT PARAMETER pCodRefer  LIKE tt-reg-export-item.cod-refer   NO-UNDO.
      DEFINE  INPUT PARAMETER pNrEntrega LIKE tt-reg-export-item.nr-entrega  NO-UNDO.
      DEFINE OUTPUT PARAMETER de-valor-1 AS   DECIMAL                        NO-UNDO.
      DEFINE OUTPUT PARAMETER de-valor-2 AS   DECIMAL                        NO-UNDO.
      DEFINE OUTPUT PARAMETER de-peso    AS   DECIMAL                        NO-UNDO.
           
      ASSIGN de-valor-1 = 0
             de-valor-2 = 0
             de-peso    = 0.

      RUN exp/exapi014.p PERSISTENT SET h-exapi014.

      EMPTY TEMP-TABLE tt-desp-item.
      EMPTY TEMP-TABLE tt-desp-item-aux.

      IF VALID-HANDLE (h-exapi014) THEN DO:

         RUN calculaDespProcExp IN h-exapi014 ( INPUT pEstabel,
                                                INPUT pNrProcExp,
                                                INPUT NO,
                                                OUTPUT TABLE tt-desp-item).
         
         RUN calculaDespProcExp IN h-exapi014 ( INPUT pEstabel,
                                                INPUT pNrProcExp,
                                                INPUT YES,
                                                OUTPUT TABLE tt-desp-item-aux).
      END.

      FIND FIRST proc-ped-ent NO-LOCK 
           WHERE proc-ped-ent.cod-estabel  = pEstabel 
             AND proc-ped-ent.nr-proc-exp  = pNrProcExp
             AND proc-ped-ent.nome-abrev   = pNomeAbrev
             AND proc-ped-ent.nr-pedcli    = pNrPedCli
             AND proc-ped-ent.nr-sequencia = pNumSeq
             AND proc-ped-ent.it-codigo    = pItCodigo
             AND proc-ped-ent.cod-refer    = pCodRefer
             AND proc-ped-ent.nr-entrega   = pNrEntrega NO-ERROR.

      IF AVAIL proc-ped-ent THEN DO: 

         IF reg-export-item.qtd-unid-item = proc-ped-ent.quantidade[1] THEN
            ASSIGN de-peso  = proc-ped-ent.peso-liquido.
         ELSE 
            ASSIGN de-peso  = (reg-export-item.qtd-unid-item / proc-ped-ent.quantidade[1]) * proc-ped-ent.peso-liquido.

         IF  proc-ped-ent.idi-unid-fatur = 3 THEN
             ASSIGN de-valor-1 = ROUND(( reg-export-item.qtd-unid-comerc * proc-ped-ent.vl-preuni ),2).
         ELSE
             ASSIGN de-valor-1 = ROUND(( reg-export-item.qtd-unid-item * proc-ped-ent.vl-preuni ),2).
    
         IF  proc-ped-ent.idi-unid-fatur = 3 THEN
             ASSIGN de-valor-2 = ROUND(( reg-export-item.qtd-unid-comerc * proc-ped-ent.vl-preuni ),2).
         ELSE
             ASSIGN de-valor-2 = ROUND(( reg-export-item.qtd-unid-item * proc-ped-ent.vl-preuni ),2).
    
         ASSIGN de-vl-desp = 0.
    
         FOR EACH tt-desp-item NO-LOCK      
             WHERE tt-desp-item.cod-estabel  = reg-export-item.cod-estabel 
               AND tt-desp-item.nr-proc-exp  = reg-export-item.nr-proc-exp
               AND tt-desp-item.nome-abrev   = reg-export-item.nome-abrev
               AND tt-desp-item.nr-pedcli    = reg-export-item.nr-pedcli
               AND tt-desp-item.nr-sequencia = reg-export-item.num-seq
               AND tt-desp-item.it-codigo    = reg-export-item.it-codigo
               AND tt-desp-item.cod-refer    = reg-export-item.cod-refer
               AND tt-desp-item.nr-entrega   = reg-export-item.nr-entrega :
    
             IF reg-export-item.qtd-unid-item = proc-ped-ent.quantidade[1] THEN
                ASSIGN de-vl-desp[1] = de-vl-desp[1] + tt-desp-item.vl-desp-mo-proc-exp[1].
                       
             ELSE
                ASSIGN de-vl-desp[1] = de-vl-desp[1] + ROUND(((reg-export-item.qtd-unid-item / proc-ped-ent.quantidade[1]) * tt-desp-item.vl-desp-mo-proc-exp[1] ),2).
         END.
         FOR EACH tt-desp-item-aux NO-LOCK      
             WHERE tt-desp-item-aux.cod-estabel  = reg-export-item.cod-estabel 
               AND tt-desp-item-aux.nr-proc-exp  = reg-export-item.nr-proc-exp
               AND tt-desp-item-aux.nome-abrev   = reg-export-item.nome-abrev
               AND tt-desp-item-aux.nr-pedcli    = reg-export-item.nr-pedcli
               AND tt-desp-item-aux.nr-sequencia = reg-export-item.num-seq
               AND tt-desp-item-aux.it-codigo    = reg-export-item.it-codigo
               AND tt-desp-item-aux.cod-refer    = reg-export-item.cod-refer
               AND tt-desp-item-aux.nr-entrega   = reg-export-item.nr-entrega :
    
             IF reg-export-item.qtd-unid-item = proc-ped-ent.quantidade[1] THEN
                 ASSIGN de-vl-desp[2] = de-vl-desp[2] + tt-desp-item-aux.vl-desp-mo-proc-exp[2]
                        de-vl-desp[3] = de-vl-desp[3] + tt-desp-item-aux.de-val-desp-inc[1].
             ELSE
                 ASSIGN de-vl-desp[2] = de-vl-desp[2] + ROUND(((reg-export-item.qtd-unid-item / proc-ped-ent.quantidade[1]) * tt-desp-item-aux.vl-desp-mo-proc-exp[2] ),2)
                        de-vl-desp[3] = de-vl-desp[3] + ROUND(((reg-export-item.qtd-unid-item / proc-ped-ent.quantidade[1]) * tt-desp-item-aux.de-val-desp-inc[1] ),2).
         END.
    
         ASSIGN de-valor-1 = (de-valor-1  + de-vl-desp[1]) - de-vl-desp[3]
                de-valor-2 = (de-valor-2  + de-vl-desp[2]) - de-vl-desp[3].
                
    
      END.
      
      IF VALID-HANDLE (h-exapi014) THEN DO:
         DELETE PROCEDURE h-exapi014.
         ASSIGN h-exapi014 = ?.
      END.

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
  Purpose:     Reposiciona registro com base no °ndice rgxprttm-id
  Parameters:  
               recebe valor do campo nr-re-ems
               recebe valor do campo cod-estabel
               recebe valor do campo nr-proc-exp
               recebe valor do campo nome-abrev
               recebe valor do campo nr-pedcli
               recebe valor do campo num-seq
               recebe valor do campo it-codigo
               recebe valor do campo cod-refer
               recebe valor do campo nr-entrega
               recebe valor do campo num-ocor-item
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-re-ems LIKE reg-export-item.nr-re-ems NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE reg-export-item.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pnr-proc-exp LIKE reg-export-item.nr-proc-exp NO-UNDO.
    DEFINE INPUT PARAMETER pnome-abrev LIKE reg-export-item.nome-abrev NO-UNDO.
    DEFINE INPUT PARAMETER pnr-pedcli LIKE reg-export-item.nr-pedcli NO-UNDO.
    DEFINE INPUT PARAMETER pnum-seq LIKE reg-export-item.num-seq NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo LIKE reg-export-item.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-refer LIKE reg-export-item.cod-refer NO-UNDO.
    DEFINE INPUT PARAMETER pnr-entrega LIKE reg-export-item.nr-entrega NO-UNDO.
    DEFINE INPUT PARAMETER pnum-ocor-item LIKE reg-export-item.num-ocor-item NO-UNDO.

    FIND FIRST bfreg-export-item WHERE 
        bfreg-export-item.nr-re-ems = pnr-re-ems AND 
        bfreg-export-item.cod-estabel = pcod-estabel AND 
        bfreg-export-item.nr-proc-exp = pnr-proc-exp AND 
        bfreg-export-item.nome-abrev = pnome-abrev AND 
        bfreg-export-item.nr-pedcli = pnr-pedcli AND 
        bfreg-export-item.num-seq = pnum-seq AND 
        bfreg-export-item.it-codigo = pit-codigo AND 
        bfreg-export-item.cod-refer = pcod-refer AND 
        bfreg-export-item.nr-entrega = pnr-entrega AND 
        bfreg-export-item.num-ocor-item = pnum-ocor-item NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfreg-export-item THEN 
        RETURN "NOK":U.



    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfreg-export-item)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToRegExport DBOProgram 
PROCEDURE linkToRegExport :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


   DEFINE INPUT PARAMETER P-HANDLE AS HANDLE NO-UNDO.

   RUN getKey IN P-HANDLE (OUTPUT i-nr-re-ems).

   RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByItem DBOProgram 
PROCEDURE openQueryByItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QUERYNAME} for each {&TableName} NO-LOCK
               WHERE {&TableName}.nr-re-ems = i-nr-re-ems INDEXED-REPOSITION.

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
    OPEN QUERY {&QUERYNAME} for each {&TableName} NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    IF pType = "Create":U THEN DO: 

       FIND FIRST  bf{&TableName} NO-LOCK 
            WHERE  bf{&TableName}.nr-re-ems     = rowobject.nr-re-ems 
              AND  bf{&TableName}.cod-estabel   = rowobject.cod-estabel       
              AND  bf{&TableName}.nr-proc-exp   = rowobject.nr-proc-exp       
              AND  bf{&TableName}.nome-abrev    = rowobject.nome-abrev        
              AND  bf{&TableName}.nr-pedcli     = rowobject.nr-pedcli                              
              AND  bf{&TableName}.num-seq       = rowobject.num-seq           
              AND  bf{&tablename}.it-codigo     = rowobject.it-codigo                              
              AND  bf{&TableName}.cod-refer     = rowobject.cod-refer         
              AND  bf{&TableName}.nr-entrega    = rowobject.nr-entrega                           
              AND  bf{&TableName}.num-ocor-item = rowobject.num-ocor-item NO-ERROR.
       IF AVAIL  bf{&TableName} THEN DO:
           /* Inicio -- Projeto Internacional */
           DEFINE VARIABLE c-lbl-liter-item-registro-exportacao AS CHARACTER NO-UNDO.
           {utp/ut-liter.i "Item_Registro_Exportaá∆o" *}
           ASSIGN c-lbl-liter-item-registro-exportacao = TRIM(RETURN-VALUE).
           {method/svc/errors/inserr.i
                  &ErrorNumber="8"
                  &ErrorType="EMS"
                  &ErrorSubType="ERROR"
                  &ErrorParameters="c-lbl-liter-item-registro-exportacao"}
       END.

       FOR FIRST ITEM FIELDS(it-codigo fator-conver)
           WHERE ITEM.it-codigo = RowObject.it-codigo NO-LOCK:
           IF  ITEM.fator-conver = 0 THEN DO:
               {method/svc/errors/inserr.i
                      &ErrorNumber="31839"
                      &ErrorType="EMS"
                      &ErrorSubType="ERROR"
                      &ErrorParameters="ITEM.it-codigo"}
           END.
       END.
    END.

    IF pType = "Create":U OR 
       pType = "Update":U THEN 
       RUN valida-preco-item (INPUT 1).

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-preco-item DBOProgram 
PROCEDURE valida-preco-item :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-i-origem AS INTEGER NO-UNDO.

    DEFINE VARIABLE c-cond-vend AS CHARACTER NO-UNDO.
    {utp/ut-liter.i "Preáo_Total_na_Condiá∆o_de_Venda" *}
    ASSIGN c-cond-vend = TRIM(RETURN-VALUE).
    DEFINE VARIABLE c-loc-embarq AS CHARACTER NO-UNDO.
    {utp/ut-liter.i "Preáo_Total_no_Local_de_Embarque" *}              
    ASSIGN c-loc-embarq = TRIM(RETURN-VALUE).     

    IF AVAIL rowObject THEN DO:
       IF p-i-origem = 1 THEN DO:
              IF DEC(SUBSTRING(rowObject.cod-livre-2,21,20)) < DEC(SUBSTRING(rowObject.cod-livre-2,41,20)) THEN DO:                                     
                 {method/svc/errors/inserr.i
                        &ErrorNumber="55412"
                        &ErrorType="EMS"
                        &ErrorSubType="INFORMATION"
                        &ErrorParameters="c-cond-vend + '~~~~' + c-loc-embarq + '~~~~' + rowObject.it-codigo + '~~~~' + string(SUBSTRING(rowObject.cod-livre-2,21,20))+ '~~~~' + string(SUBSTRING(rowObject.cod-livre-2,41,20))"}   
              END.
       END.
       ELSE DO:
          FOR EACH reg-export-item NO-LOCK 
              WHERE reg-export-item.nr-re-ems = rowObject.nr-re-ems :
    
              IF DEC(SUBSTRING(reg-export-item.cod-livre-2,21,20)) < DEC(SUBSTRING(reg-export-item.cod-livre-2,41,20)) THEN DO:        
                 {method/svc/errors/inserr.i
                        &ErrorNumber="55412"
                        &ErrorType="EMS"
                        &ErrorSubType="INFORMATION"
                        &ErrorParameters="c-cond-vend + '~~~~' + c-loc-embarq + '~~~~' + reg-export-item.it-codigo + '~~~~' + string(SUBSTRING(reg-export-item.cod-livre-2,21,20))+ '~~~~' + string(SUBSTRING(reg-export-item.cod-livre-2,41,20))"}   
              END.
          END.
       END.
    END.

    RETURN "OK":U.

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

