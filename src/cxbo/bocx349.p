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
{include/i-prgvrs.i BOCX349 2.00.00.043 } /*** "010043" 11/12/2023 10:13:26 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bocx349 MUT}
&ENDIF


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
&GLOBAL-DEFINE DBOName BOCX349
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName reg-export-anexo
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
{cxbo/bocx349.i RowObject}
{include/i-epc200.i BOCX349}

{cdp/cdcfgdis.i}
{cdp/cdcfgcex.i}
{exp/exapi014.i}

{cxbo/bocx350.i tt-reg-export-fabrican}


DEFINE TEMP-TABLE tt-reg-export-anexo NO-UNDO LIKE rowobject.

DEFINE TEMP-TABLE tt-anexos NO-UNDO
     FIELD cdn-anexo              LIKE reg-export-item.cdn-anexo
     FIELD class-fiscal           LIKE ITEM.class-fiscal
     FIELD des-unid-medid-comerc  LIKE reg-export-item.cod-unid-medid-comerc
     FIELD num-ocor-item          LIKE reg-export-item.num-ocor-item
     FIELD qt-itens               AS INTEGER
     FIELD l-preco-maior          AS LOGICAL
     FIELD cod-cfop               LIKE natur-oper.cod-cfop
     INDEX ch-class  class-fiscal
                     des-unid-medid-comerc
                     qt-itens     
                     l-preco-maior ASCENDING.

DEFINE TEMP-TABLE tt-item-anexo NO-UNDO 
     FIELD class-fiscal  LIKE reg-export-anexo.class-fiscal
     FIELD preco-maior   AS   LOGICAL
     FIELD num-ocor-item LIKE reg-export-item.num-ocor-item
     FIELD cdn-anexo     LIKE reg-export-anexo.cdn-anexo
     FIELD it-codigo     LIKE ITEM.it-codigo
     FIELD des-unid-medid-comerc LIKE reg-export-anexo.des-unid-medid-comerc
     FIELD cod-cfop               LIKE natur-oper.cod-cfop
     FIELD r-rowid       AS ROWID.

DEFINE TEMP-TABLE tt-tot-anexo NO-UNDO
     FIELD nr-re-ems LIKE reg-export-anexo.nr-re-ems
     FIELD cdn-anexo LIKE reg-export-anexo.cdn-anexo
     FIELD de-qtd-unid LIKE reg-export-item.qtd-unid-comerc.

DEFINE TEMP-TABLE tt-reg-export-item-aux  NO-UNDO LIKE reg-export-item
     FIELD r-rowid AS ROWID. 

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

DEFINE TEMP-TABLE RowErrorsAux NO-UNDO
    FIELD ErrorSequence    AS INTEGER
    FIELD ErrorNumber      AS INTEGER
    FIELD ErrorDescription AS CHARACTER
    FIELD ErrorParameters  AS CHARACTER
    FIELD ErrorType        AS CHARACTER
    FIELD ErrorHelp        AS CHARACTER
    FIELD ErrorSubType     AS CHARACTER.

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
DEFINE BUFFER bfreg-export  FOR reg-export.
DEFINE BUFFER bfReg-export-item FOR reg-export-item.
DEFINE BUFFER bftt-item-anexo  FOR tt-item-anexo.

DEFINE VARIABLE i-nr-re-ems LIKE reg-export.nr-re-ems NO-UNDO.
DEFINE VARIABLE i-qt-reg-anexos AS INTEGER NO-UNDO.
DEFINE VARIABLE i-qt-max-itens-anexo AS INTEGER       NO-UNDO.

DEFINE VARIABLE de-preco-conv LIKE proc-ped-ent.vl-preuni    NO-UNDO.
DEFINE VARIABLE i-ult-anexo   LIKE reg-export-anexo.cdn-anexo NO-UNDO.
DEFINE VARIABLE de-perc-comis-com LIKE reg-export-anexo.val-perc-comis NO-UNDO.
DEFINE VARIABLE de-perc-comis-ncm LIKE reg-export-anexo.val-perc-comis NO-UNDO.
DEFINE VARIABLE de-qtd-unid-medid-comerc LIKE reg-export-item.qtd-unid-comerc NO-UNDO.
DEFINE VARIABLE de-vl-desp    AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999" EXTENT 5 NO-UNDO.


DEFINE VARIABLE c-class-fiscal AS CHAR NO-UNDO.
DEFINE VARIABLE l-preco-maior  AS LOG  NO-UNDO.
DEFINE VARIABLE l-ocorrencia   AS LOG  NO-UNDO.

DEFINE VARIABLE c-it-codigo          AS CHAR NO-UNDO.
DEFINE VARIABLE c-item               AS CHAR NO-UNDO.
DEFINE VARIABLE c-cod-refer          AS CHAR NO-UNDO.
DEFINE VARIABLE i-qt-itens           AS INTE NO-UNDO.

DEFINE VARIABLE c-lista-class-fiscal AS CHAR NO-UNDO.
DEFINE VARIABLE c-lista-unidade      AS CHAR NO-UNDO.
DEFINE VARIABLE c-lista-preco        AS CHAR NO-UNDO.
DEFINE VARIABLE c-lista-ocorrencia   AS CHAR NO-UNDO.
DEFINE VARIABLE c-lista-qt-itens     AS CHAR NO-UNDO.
DEFINE VARIABLE c-lista-cfop         AS CHAR NO-UNDO.

DEFINE VARIABLE h-exapi014 AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx347  AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx350  AS HANDLE NO-UNDO.
DEFINE VARIABLE h-cdapi040 AS HANDLE NO-UNDO.

DEFINE VARIABLE c-desc-aux   as char format "x(75)" no-undo.
DEFINE VARIABLE c-descricao  AS CHAR FORMAT "x(37)" NO-UNDO.
DEFINE VARIABLE c-espaco     as char format "x(01)" no-undo.
DEFINE VARIABLE c-dif-espaco as INTEGER NO-UNDO.
DEFINE VARIABLE i-cont       AS INTEGER NO-UNDO.
DEFINE VARIABLE i-cont2      AS INTEGER NO-UNDO.
DEFINE VARIABLE l-mesmo      AS LOGICAL NO-UNDO.
DEFINE VARIABLE l-idi-consid-cfop AS LOGICAL NO-UNDO.
DEFINE VARIABLE iErro        AS INTEGER     NO-UNDO.

DEFINE VARIABLE i-nr-re-ems-ini LIKE reg-export.nr-re-ems NO-UNDO.
DEFINE VARIABLE i-nr-re-ems-fin LIKE reg-export.nr-re-ems NO-UNDO.

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
         HEIGHT             = 23.67
         WIDTH              = 57.72.
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

  IF NOT VALID-HANDLE (h-bocx347) THEN
     RUN cxbo/bocx347.p PERSISTENT SET h-bocx347.

  IF AVAIL {&TableName} THEN DO:

     IF VALID-HANDLE (h-bocx347) THEN
        RUN atualizaUltAlteracao IN h-bocx347 (INPUT {&TableName}.nr-re-ems).

     RUN pi-grava-siscoserv.
    
  end. 
              
  IF VALID-HANDLE (h-bocx347) THEN
     DELETE PROCEDURE h-bocx347.

  ASSIGN h-bocx347 = ?.
               
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

  IF AVAIL rowobject THEN DO:

      FOR EACH reg-export-item EXCLUSIVE-LOCK 
          WHERE reg-export-item.nr-re-ems = rowobject.nr-re-ems
            AND reg-export-item.cdn-anexo = rowobject.cdn-anexo :
          ASSIGN reg-export-item.cdn-anexo = 0.
      END.
  
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

     RUN pi-grava-siscoserv.
  end. 
              
  IF VALID-HANDLE (h-bocx347) THEN
     DELETE PROCEDURE h-bocx347.

  ASSIGN h-bocx347 = ?.
               
  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaParam DBOProgram 
PROCEDURE atualizaParam :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p-idi-desc-anex  AS INTEGER NO-UNDO.
  DEFINE INPUT PARAMETER p-idi-quant-col  AS INTEGER NO-UNDO.


  /* OBS:
     Quando o usu†rio optar por 1 item por adiá∆o (item £nico) com tamanho de 730 posiá‰es
  para a descriá∆o do item, dever† usar o elemento de dados <item-mercadoria-£nico>.
     Nesta opá∆o poder† ser agrupado e totalizado atÇ 5 itens em um elemento de dados
  apenas, concatenando na descriá∆o do item a descriá∆o dos mesmos e suas quantidades
  (como Ç feito atualmente) desde que n∆o ultrapasse a 730 caracteres.
  
  */

  ASSIGN i-qt-max-itens-anexo = 0.

  IF /*p-idi-desc-anex = 1 AND */
     p-idi-quant-col = 1 THEN DO:
     ASSIGN i-qt-max-itens-anexo = 5. /*OBS: Acima*/
  END.
  IF /*p-idi-desc-anex = 1 AND */
     p-idi-quant-col = 2 THEN DO:
     ASSIGN i-qt-max-itens-anexo = 5.
  END.
  /*IF p-idi-desc-anex = 2 THEN DO:
     ASSIGN i-qt-max-itens-anexo = 5.
  END.
  IF p-idi-desc-anex = 3 AND 
     p-idi-quant-col = 1 THEN DO:
     ASSIGN i-qt-max-itens-anexo = 8.
  END.
  IF p-idi-desc-anex = 3 AND 
     p-idi-quant-col = 2 THEN DO:
     ASSIGN i-qt-max-itens-anexo = 16.
  END.*/                                

  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizarAnexos DBOProgram 
PROCEDURE atualizarAnexos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Criar† os registros e atualizar† os dados na tabela reg-export-anexo      
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pNrReEms         LIKE reg-export-anexo.nr-re-ems NO-UNDO.
  DEFINE INPUT PARAMETER p-idi-desc-anex  AS   INTEGER                    NO-UNDO.
  DEFINE INPUT PARAMETER p-idi-quant-col  AS   INTEGER                    NO-UNDO.

  DEF VAR c-uf-produt LIKE reg-export-anexo.uf-produt NO-UNDO.

  DEF VAR de-peso-liq-fabric AS DEC NO-UNDO.
  
  FOR EACH bf{&TableName} EXCLUSIVE-LOCK 
      WHERE bf{&TableName}.nr-re-ems = pNrReEms:
      DELETE bf{&TableName}.
  END.
  FOR EACH reg-export-fabrican EXCLUSIVE-LOCK 
      WHERE reg-export-fabrican.nr-re-ems = pNrReEms:
      DELETE reg-export-fabrican.
  END.
  FIND FIRST bfreg-export NO-LOCK 
       WHERE bfreg-export.nr-re-ems = pNrReEms NO-ERROR.

  RUN exp/exapi014.p PERSISTENT SET h-exapi014.


  EMPTY TEMP-TABLE tt-desp-item.
  EMPTY TEMP-TABLE tt-desp-item-aux.
  
  IF VALID-HANDLE (h-exapi014) THEN DO:
     RUN calculaDespProcExp IN h-exapi014 ( INPUT bfreg-export.cod-estabel,
                                            INPUT bfreg-export.nr-proc-exp,
                                            INPUT NO,
                                            OUTPUT TABLE tt-desp-item).
     
     RUN calculaDespProcExp IN h-exapi014 ( INPUT bfreg-export.cod-estabel,
                                            INPUT bfreg-export.nr-proc-exp,
                                            INPUT YES,
                                            OUTPUT TABLE tt-desp-item-aux).
  END.

  FIND FIRST processo-exp 
       WHERE processo-exp.cod-estabel = bfreg-export.cod-estabel 
         AND processo-exp.nr-proc-exp  = bfreg-export.nr-proc-exp NO-LOCK NO-ERROR.
  IF AVAIL processo-exp THEN DO:
      IF processo-exp.estado-estab <> "" THEN
          ASSIGN c-uf-produt = processo-exp.estado-estab.
      ELSE DO:
          FIND estabelec WHERE
               estabelec.cod-estabel = bfreg-export.cod-estabel NO-LOCK NO-ERROR.
          IF AVAIL estabelec THEN
              ASSIGN c-uf-produt = estabelec.estado.
      END.
  END.
       

  RUN atualizaParam (INPUT p-idi-desc-anex, INPUT p-idi-quant-col ).

  FOR EACH reg-export-item EXCLUSIVE-LOCK 
     WHERE reg-export-item.nr-re-ems = pNrReEms:

      IF reg-export-item.cdn-anexo = 0 THEN NEXT.

      FIND FIRST proc-ped-ent NO-LOCK 
           WHERE proc-ped-ent.cod-estabel  = reg-export-item.cod-estabel
             AND proc-ped-ent.nr-proc-exp  = reg-export-item.nr-proc-exp 
             AND proc-ped-ent.nome-abrev   = reg-export-item.nome-abrev 
             AND proc-ped-ent.nr-pedcli    = reg-export-item.nr-pedcli
             AND proc-ped-ent.nr-sequencia = reg-export-item.num-seq
             AND proc-ped-ent.it-codigo    = reg-export-item.it-codigo
             AND proc-ped-ent.cod-refer    = reg-export-item.cod-refer
             AND proc-ped-ent.nr-entrega   = reg-export-item.nr-entrega NO-ERROR.

      IF NOT AVAIL proc-ped-ent THEN NEXT.

      FIND FIRST ped-item NO-LOCK 
           WHERE ped-item.nome-abrev   = reg-export-item.nome-abrev
             AND ped-item.nr-pedcli    = reg-export-item.nr-pedcli
             AND ped-item.nr-sequencia = reg-export-item.num-seq
             AND ped-item.it-codigo    = reg-export-item.it-codigo
             AND ped-item.cod-refer    = reg-export-item.cod-refer NO-ERROR.

      IF NOT AVAIL ped-item THEN NEXT.

      FIND FIRST ITEM NO-LOCK 
           WHERE ITEM.it-codigo = reg-export-item.it-codigo NO-ERROR.

      IF NOT AVAIL ITEM  THEN NEXT.

      FIND FIRST tab-unidade NO-LOCK 
           WHERE tab-unidade.un = reg-export-item.cod-unid-medid-comerc NO-ERROR.

      IF NOT AVAIL tab-unidade THEN NEXT.

      FIND FIRST ped-venda NO-LOCK 
           WHERE ped-venda.nome-abrev = reg-export-item.nome-abrev
             AND ped-venda.nr-pedcli  = reg-export-item.nr-pedcli NO-ERROR.

      IF NOT AVAIL ped-venda THEN NEXT.

      FIND FIRST ped-repre NO-LOCK
           WHERE ped-repre.nr-pedido   = ped-venda.nr-pedido 
             AND ped-repre.nome-ab-rep = ped-venda.no-ab-reppri NO-ERROR.

      IF NOT AVAIL ped-repre THEN NEXT.

      FIND FIRST tt-reg-export-anexo NO-LOCK
           WHERE tt-reg-export-anexo.nr-re-ems = reg-export-item.nr-re-ems
             AND tt-reg-export-anexo.cdn-anexo = reg-export-item.cdn-anexo NO-ERROR.

      IF NOT AVAIL tt-reg-export-anexo THEN DO:
         CREATE tt-reg-export-anexo.
         ASSIGN tt-reg-export-anexo.nr-re-ems   = reg-export-item.nr-re-ems
                tt-reg-export-anexo.cdn-anexo   = reg-export-item.cdn-anexo
                tt-reg-export-anexo.uf-produt   = c-uf-produt
                tt-reg-export-anexo.log-livre-1 = l-idi-consid-cfop.

         IF SUBSTRING(ped-item.char-2,01,08) <> "" THEN 
            ASSIGN tt-reg-export-anexo.class-fiscal = SUBSTRING(ped-item.char-2,01,08).
         ELSE
            ASSIGN tt-reg-export-anexo.class-fiscal = ITEM.class-fiscal.

            /* --------------------   FO: 1706.151 - UPC p/ VICUNHA-CE    -------------------- */
            FOR EACH tt-epc 
               WHERE tt-epc.cod-event     = 'UpdateClassFiscal':U 
                 AND tt-epc.cod-parameter = 'class-fiscal':U:
                DELETE tt-epc.
            END.

            FOR EACH tt-epc 
               WHERE tt-epc.cod-event     = 'UpdateClassFiscal':U
                 AND tt-epc.cod-parameter = 'retorno-class-fiscal':U:
                DELETE tt-epc.
            END.

            /* Include i-epc200.i2: Criacao de registro para temp-table tt-epc */
            CREATE tt-epc.
            ASSIGN tt-epc.cod-event     = 'UpdateClassFiscal':U
                   tt-epc.cod-parameter = 'class-fiscal':U
                   tt-epc.val-parameter = reg-export-item.it-codigo + ';':U +
                                          reg-export-item.cod-refer + ';':U +
                                          ITEM.class-fiscal.
                                          
            /* Include i-epc201.i: Chamada do programa de EPC */
            {include/i-epc201.i "UpdateClassFiscal"}.

            FOR FIRST tt-epc NO-LOCK 
                WHERE tt-epc.cod-event     = 'UpdateClassFiscal':U 
                  AND tt-epc.cod-parameter = 'Retorno-class-fiscal':U :
                ASSIGN tt-reg-export-anexo.class-fiscal = tt-epc.val-parameter.
            END.
            /* -------------------------------------------------------------------------------- */

         FIND FIRST classif-fisc NO-LOCK 
              WHERE classif-fisc.class-fiscal = tt-reg-export-anexo.class-fiscal NO-ERROR.
         IF AVAIL classif-fisc THEN DO:

             ASSIGN tt-reg-export-anexo.cdn-naladi            = DEC(SUBSTRING(STRING(classif-fisc.cod-naladi-sh),1,8))
                    tt-reg-export-anexo.cdn-finalid           = classif-fisc.finalidade
                    tt-reg-export-anexo.des-unid-medid-comerc = tab-unidade.descricao NO-ERROR.

             IF AVAIL ped-repre THEN
                ASSIGN de-perc-comis-com = ped-repre.perc-comis.
    
             &IF '{&bf_dis_versao_ems}' <= '2.04' &THEN
                 ASSIGN de-perc-comis-ncm = DECIMAL(SUBSTRING(classif-fisc.char-1,50,6)).
             &ENDIF
             
             &IF '{&bf_dis_versao_ems}' >= '2.062' &THEN
                 ASSIGN de-perc-comis-ncm = classif-fisc.val-repas-max-comis.
             &ENDIF
                    
                    
             IF de-perc-comis-ncm <= de-perc-comis-com THEN
                ASSIGN tt-reg-export-anexo.val-perc-comis = de-perc-comis-ncm.
             ELSE
                ASSIGN tt-reg-export-anexo.val-perc-comis = de-perc-comis-com.
    
             &IF '{&bf_dis_versao_ems}' <= '2.04' &THEN
                 ASSIGN tt-reg-export-anexo.idi-tip-comis-agent = INTEGER(SUBSTRING(ped-repre.char-2,01,01)).
             &ENDIF
             
             &IF '{&bf_dis_versao_ems}' >= '2.062' &THEN
                 ASSIGN tt-reg-export-anexo.idi-tip-comis-agent = ped-repre.idi-tip-base-comis-agent.
             &ENDIF
         END.
      END.

      IF reg-export-item.qtd-unid-item = proc-ped-ent.quantidade[1] THEN DO:
         ASSIGN tt-reg-export-anexo.val-peso-liq  = tt-reg-export-anexo.val-peso-liq  
                                                  + proc-ped-ent.peso-liquido.
      END.
      ELSE DO: 
         ASSIGN tt-reg-export-anexo.val-peso-liq  = tt-reg-export-anexo.val-peso-liq  
                                                  + ( (reg-export-item.qtd-unid-item / proc-ped-ent.quantidade[1]) * proc-ped-ent.peso-liquido ).
      END.
      ASSIGN tt-reg-export-anexo.qtd-unid-ncm  = tt-reg-export-anexo.qtd-unid-ncm     
                                              + reg-export-item.qtd-unid-ncm
         tt-reg-export-anexo.qtd-unid-comerc  = tt-reg-export-anexo.qtd-unid-comerc  
                                              + reg-export-item.qtd-unid-comerc.
       
      /* Grava os valores salvos nos itens do RE */
      ASSIGN tt-reg-export-anexo.val-preco-tot[1] = tt-reg-export-anexo.val-preco-tot[1] + DEC(SUBSTRING(reg-export-item.cod-livre-2,21,20))
             tt-reg-export-anexo.val-preco-tot[2] = tt-reg-export-anexo.val-preco-tot[2] + DEC(SUBSTRING(reg-export-item.cod-livre-2,41,20)).

      ASSIGN tt-reg-export-anexo.val-preco-unit-comerc[1] = (tt-reg-export-anexo.val-preco-tot[1] / tt-reg-export-anexo.qtd-unid-comerc)
             tt-reg-export-anexo.val-preco-unit-comerc[2] = (tt-reg-export-anexo.val-preco-tot[2] / tt-reg-export-anexo.qtd-unid-comerc)
             tt-reg-export-anexo.val-preco-unit-ncm[1]    = (tt-reg-export-anexo.val-preco-tot[1] / tt-reg-export-anexo.qtd-unid-ncm)
             tt-reg-export-anexo.val-preco-unit-ncm[2]    = (tt-reg-export-anexo.val-preco-tot[2] / tt-reg-export-anexo.qtd-unid-ncm)
             tt-reg-export-anexo.val-comissao             = (tt-reg-export-anexo.val-preco-tot[2] * tt-reg-export-anexo.val-perc-comis) / 100.

  END.

  ASSIGN iErro = 0.
  FOR EACH tt-reg-export-anexo 
     WHERE tt-reg-export-anexo.nr-re-ems = pNrReEms:  

      ASSIGN i-cont         = 0 
             i-cont2        = 0 
             i-qt-itens     = 0.

      FOR EACH reg-export-item EXCLUSIVE-LOCK
         WHERE reg-export-item.nr-re-ems = tt-reg-export-anexo.nr-re-ems
           AND reg-export-item.cdn-anexo = tt-reg-export-anexo.cdn-anexo
         BREAK BY reg-export-item.it-codigo:

         ASSIGN de-qtd-unid-medid-comerc = de-qtd-unid-medid-comerc 
                                         + reg-export-item.qtd-unid-comerc.
            FIND FIRST ITEM NO-LOCK 
                 WHERE ITEM.it-codigo = reg-export-item.it-codigo NO-ERROR.
            RUN gravaDescMercad ( INPUT pNrReEms,
                                  INPUT p-idi-desc-anex, 
                                  INPUT p-idi-quant-col).
            ASSIGN de-qtd-unid-medid-comerc = 0.
      END.

      ASSIGN de-qtd-unid-medid-comerc = 0.
      RUN valida-preco-anexo (OUTPUT TABLE RowErrorsAux). 
  END.

  FOR EACH tt-reg-export-anexo NO-LOCK:
      RUN setRecord   (INPUT TABLE tt-reg-export-anexo).
      RUN createRecord IN THIS-PROCEDURE.

      /* Gerando o fabricante automaticamente */
      ASSIGN de-peso-liq-fabric = 0.
  
      FOR EACH reg-export-item NO-LOCK
         WHERE reg-export-item.nr-re-ems = tt-reg-export-anexo.nr-re-ems
           AND reg-export-item.cdn-anexo = tt-reg-export-anexo.cdn-anexo
      BREAK BY reg-export-item.it-codigo:
          ASSIGN de-peso-liq-fabric = de-peso-liq-fabric + DEC(SUBSTRING(reg-export-item.cod-livre-2,1,20)).
      END.
  
      FIND FIRST estabelec NO-LOCK
           WHERE estabelec.cod-estabel = bfreg-export.cod-estabel NO-ERROR.
  
      CREATE tt-reg-export-fabrican.
      ASSIGN tt-reg-export-fabrican.nr-re-ems    = tt-reg-export-anexo.nr-re-ems
             tt-reg-export-fabrican.cdn-anexo    = tt-reg-export-anexo.cdn-anexo
             tt-reg-export-fabrican.cod-emitente = estabelec.cod-emitente
             tt-reg-export-fabrican.class-fiscal = tt-reg-export-anexo.class-fiscal
             tt-reg-export-fabrican.cod-uf-fab   = c-uf-produt
             tt-reg-export-fabrican.qtd-unid-ncm = tt-reg-export-anexo.qtd-unid-ncm
             tt-reg-export-fabrican.val-mercad   = (tt-reg-export-anexo.val-preco-unit-ncm[2] * tt-reg-export-anexo.qtd-unid-ncm)
             OVERLAY(tt-reg-export-fabrican.cod-livre-1,1,20) = STRING(de-peso-liq-fabric).
  
      RUN cxbo/bocx350.p PERSISTENT SET h-bocx350.
  
      IF VALID-HANDLE (h-bocx350) THEN DO:
  
          RUN openQueryStatic IN h-bocx350 (INPUT "main").
          RUN EMPTYrowerrors IN h-bocx350.
          RUN setRecord    IN h-bocx350 (INPUT TABLE tt-reg-export-fabrican).
          RUN createRecord IN h-bocx350.
          RUN getRowErrors IN h-bocx350 (OUTPUT TABLE RowErrors APPEND).
  
          DELETE PROCEDURE h-bocx350.
          ASSIGN h-bocx350 = ?.
      END.
      /* Fim da geraá∆o fabricante */

      DELETE tt-reg-export-anexo.
      DELETE tt-reg-export-fabrican.
  
  END.
  /*tratamento de erros realizados no momento da geraá∆o dos anexos:
    Valor do Local de Venda Maior que Valor do Local de Embarque*/
  FOR EACH RowErrorsAux:
      IF NOT CAN-FIND(FIRST RowErrors
                      WHERE RowErrors.ErrorNumber   = RowErrorsAux.ErrorNumber
                        AND RowErrors.ErrorSequence = RowErrorsAux.ErrorSequence) THEN DO:
          CREATE RowErrors.
          BUFFER-COPY RowErrorsAux TO RowErrors.
      END.
      DELETE RowErrorsAux.
  END.
  
  RUN cxbo/bocx347.p PERSISTENT SET h-bocx347.
  
  IF VALID-HANDLE (h-bocx347) THEN DO:
     RUN openQueryStatic    IN h-bocx347 (INPUT "main").
     RUN atualizarValoresRE IN h-bocx347 (INPUT pNrReEms, INPUT l-idi-consid-cfop).
  
     DELETE PROCEDURE h-bocx347.
     ASSIGN h-bocx347 = ?.
  END.
  

  IF VALID-HANDLE (h-exapi014) THEN DO:
     DELETE PROCEDURE h-exapi014.
     ASSIGN h-exapi014 = ?.
  END.

  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaValores DBOProgram 
PROCEDURE atualizaValores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Atualizar† valores na tabela reg-export-anexo      
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER pNrReEms               LIKE reg-export-anexo.nr-re-ems NO-UNDO.
  DEFINE INPUT  PARAMETER pCdnAnexo              LIKE reg-export-anexo.cdn-anexo NO-UNDO.
  DEFINE OUTPUT PARAMETER de-peso-liq            LIKE reg-export-anexo.val-peso-liq NO-UNDO.           
  DEFINE OUTPUT PARAMETER de-preco-1             LIKE reg-export-anexo.val-preco-tot[1] NO-UNDO.        
  DEFINE OUTPUT PARAMETER de-preco-2             LIKE reg-export-anexo.val-preco-tot[2] NO-UNDO.       
  DEFINE OUTPUT PARAMETER de-qtd-unid-ncm        LIKE reg-export-item.qtd-unid-ncm    NO-UNDO.
  DEFINE OUTPUT PARAMETER de-qtd-unid-comerc     LIKE reg-export-item.qtd-unid-comerc NO-UNDO.                                                     
                                                      
  FIND FIRST bf{&TableName} NO-LOCK
       WHERE bf{&TableName}.nr-re-ems = pNrReEms 
         AND bf{&TableName}.cdn-anexo = pCdnAnexo NO-ERROR.
  
  IF AVAIL bf{&TableName} THEN DO:

      FOR EACH reg-export-item NO-LOCK
         WHERE reg-export-item.nr-re-ems = bf{&TableName}.nr-re-ems
           AND reg-export-item.cdn-anexo = bf{&TableName}.cdn-anexo
         BREAK BY reg-export-item.it-codigo:                                                                                                                 
                                                                                                                  
          ASSIGN de-peso-liq            = de-peso-liq        + DEC(SUBSTRING(reg-export-item.cod-livre-2,1,20))
                 de-preco-1             = de-preco-1         + DEC(SUBSTRING(reg-export-item.cod-livre-2,21,20))
                 de-preco-2             = de-preco-2         + DEC(SUBSTRING(reg-export-item.cod-livre-2,41,20))
                 de-qtd-unid-ncm        = de-qtd-unid-ncm    + reg-export-item.qtd-unid-ncm
                 de-qtd-unid-comerc     = de-qtd-unid-comerc + reg-export-item.qtd-unid-comerc.

      END.
  END.

  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaValoresAnexo DBOProgram 
PROCEDURE atualizaValoresAnexo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pNrReEms               LIKE reg-export-anexo.nr-re-ems NO-UNDO.

  FIND FIRST bf{&TableName} EXCLUSIVE-LOCK
       WHERE bf{&TableName}.nr-re-ems = pNrReEms NO-ERROR.
  
  IF AVAIL bf{&TableName} THEN DO:

      ASSIGN bf{&TableName}.val-peso-liq     = 0
             bf{&TableName}.val-preco-tot[1] = 0
             bf{&TableName}.val-preco-tot[2] = 0.

      FOR EACH reg-export-item NO-LOCK
         WHERE reg-export-item.nr-re-ems = bf{&TableName}.nr-re-ems
           AND reg-export-item.cdn-anexo = bf{&TableName}.cdn-anexo
         BREAK BY reg-export-item.it-codigo:                                                                                                                 

          ASSIGN bf{&TableName}.val-peso-liq      = bf{&TableName}.val-peso-liq     + DEC(SUBSTRING(reg-export-item.cod-livre-2,1,20))
                 bf{&TableName}.val-preco-tot[1]  = bf{&TableName}.val-preco-tot[1] + DEC(SUBSTRING(reg-export-item.cod-livre-2,21,20))
                 bf{&TableName}.val-preco-tot[2]  = bf{&TableName}.val-preco-tot[2] + DEC(SUBSTRING(reg-export-item.cod-livre-2,41,20)).

      END.
  END.

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

  IF AVAIL rowobject THEN DO:

      FOR EACH reg-export-item EXCLUSIVE-LOCK 
          WHERE reg-export-item.nr-re-ems = rowobject.nr-re-ems
            AND reg-export-item.cdn-anexo = rowobject.cdn-anexo :
          ASSIGN reg-export-item.cdn-anexo = 0.
      END.
  
      IF NOT VALID-HANDLE (h-bocx347) THEN
         RUN cxbo/bocx347.p PERSISTENT SET h-bocx347.      

      IF VALID-HANDLE (h-bocx347) THEN
         RUN atualizaUltAlteracao IN h-bocx347 (INPUT rowobject.nr-re-ems).

      IF VALID-HANDLE (h-bocx347) THEN
         DELETE PROCEDURE h-bocx347.

      ASSIGN h-bocx347 = ?.

      IF NOT VALID-HANDLE(h-cdapi040) THEN DO:
          RUN cdp/cdapi040.p PERSISTENT SET h-cdapi040.
      END.
      RUN pi-siscoserv-ativo IN h-cdapi040.
      IF RETURN-VALUE = "OK":U THEN DO:
          FOR FIRST reg-export FIELDS (cod-estabel nr-proc-exp nr-re-siscomex dat-reg-export) NO-LOCK
              WHERE reg-export.nr-re-ems = {&TableName}.nr-re-ems:
      
              RUN pi-apaga-re-export-sis IN h-cdapi040 (INPUT reg-export.cod-estabel,
                                                        INPUT reg-export.nr-proc-exp,
                                                        INPUT reg-export.nr-re-siscomex,
                                                        INPUT {&TableName}.nr-re-ems,
                                                        INPUT rowobject.cdn-anexo,
                                                        INPUT reg-export.dat-reg-export).
      
          END.        
      END.
      
      IF VALID-HANDLE(h-cdapi040) THEN DO:
          DELETE PROCEDURE h-cdapi040.
          ASSIGN h-cdapi040 = ?.
      END.
  END.

  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE convertePrecoUnitario DBOProgram 
PROCEDURE convertePrecoUnitario :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

 DEFINE  INPUT PARAMETER pcod-estabel LIKE reg-export-item.cod-estabel NO-UNDO.
 DEFINE  INPUT PARAMETER pnome-abrev  LIKE ped-venda.nome-abrev        NO-UNDO.
 DEFINE  INPUT PARAMETER pnr-pedcli   LIKE ped-venda.nr-pedcli         NO-UNDO.
 DEFINE  INPUT PARAMETER pvl-preuni-1 LIKE proc-ped-ent.vl-preuni      NO-UNDO.
 DEFINE OUTPUT PARAMETER l-preco-m AS LOGICAL NO-UNDO.
 DEFINE OUTPUT PARAMETER de-preco-dolar LIKE proc-ped-ent.vl-preuni    NO-UNDO.
 
 FIND FIRST param-exp NO-LOCK 
      WHERE param-exp.cod-estabel = pcod-estabel NO-ERROR.
 IF NOT AVAIL param-exp THEN RETURN "NOK":U.

 IF param-exp.cdn-moed-reg-export <> 0 THEN DO:

    FIND FIRST ped-venda NO-LOCK 
         WHERE ped-venda.nome-abrev = pnome-abrev 
           AND ped-venda.nr-pedcli  = pnr-pedcli NO-ERROR.
    IF NOT AVAIL ped-venda THEN RETURN "NOK":U.

    ASSIGN de-preco-dolar = 0.
    IF ped-venda.mo-codigo <>              
       param-exp.cdn-moed-reg-export THEN DO:
       RUN cdp/cd0812.p (INPUT ped-venda.mo-codigo,
                         INPUT param-exp.cdn-moed-reg-export,
                         INPUT proc-ped-ent.vl-preuni,
                         INPUT TODAY,
                         OUTPUT de-preco-dolar).
    END.
    ELSE 
       ASSIGN de-preco-dolar = pvl-preuni-1.
    
    &IF '{&bf_dis_versao_ems}' >= '2.07' &THEN
     IF param-exp.val-control-item-anexo <> 0 AND de-preco-dolar > param-exp.val-control-item-anexo THEN
        ASSIGN l-preco-m = YES.
     ELSE 
        ASSIGN l-preco-m = NO.
    &else
     IF  param-exp.dec-1  <> 0 AND de-preco-dolar > param-exp.dec-1 THEN 
        ASSIGN l-preco-m = YES.
     ELSE 
        ASSIGN l-preco-m = NO.
    &endif
 END.
 ELSE
    ASSIGN l-preco-m = NO.

 
 RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gerarAnexos DBOProgram 
PROCEDURE gerarAnexos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:  Efetur† a geraá∆o autom†tica dos grupos de itens, ap¢s a geraá∆o dos grupos
          este mÇtodo executar† o mÇtodo atualizarAnexos.     
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pnr-re-ems LIKE reg-export-anexo.nr-re-ems NO-UNDO.
  DEFINE INPUT PARAMETER p-idi-desc-anex  AS INTEGER NO-UNDO.
  DEFINE INPUT PARAMETER p-idi-quant-col  AS INTEGER NO-UNDO.
  DEFINE INPUT PARAMETER p-idi-consid-cfop AS LOGICAL NO-UNDO.
 
  &IF DEFINED(bf_comex206b-1) &THEN
      RUN validaCriacaoAnexos (INPUT pnr-re-ems).

      IF  RETURN-VALUE = "NOK":U THEN 
          RETURN "NOK":U.
  &ENDIF

  FOR EACH reg-export-item EXCLUSIVE-LOCK 
     WHERE reg-export-item.nr-re-ems = pnr-re-ems:
    ASSIGN reg-export-item.cdn-anexo = 0.
  END.

  ASSIGN i-ult-anexo = 0.

  RUN atualizaParam (INPUT p-idi-desc-anex, INPUT p-idi-quant-col ).

  FOR EACH tt-anexos:
      DELETE tt-anexos.
  END.

  ASSIGN c-class-fiscal = "".

  FOR EACH reg-export-item EXCLUSIVE-LOCK
      WHERE reg-export-item.nr-re-ems = pnr-re-ems:

      FIND FIRST ped-item NO-LOCK
           WHERE ped-item.nome-abrev = reg-export-item.nome-abrev
             AND ped-item.nr-pedcli  = reg-export-item.nr-pedcli
             AND ped-item.nr-sequencia = reg-export-item.num-seq
             AND ped-item.it-codigo  = reg-export-item.it-codigo
             AND ped-item.cod-refer  = reg-export-item.cod-refer NO-ERROR.
      IF NOT AVAIL ped-item THEN NEXT.

      FIND FIRST natur-oper NO-LOCK
          WHERE natur-oper.nat-operacao = ped-item.nat-operacao NO-ERROR.

      FIND FIRST proc-ped-ent NO-LOCK 
           WHERE proc-ped-ent.cod-estabel = reg-export-item.cod-estabel
             AND proc-ped-ent.nr-proc-exp = reg-export-item.nr-proc-exp
             AND proc-ped-ent.nome-abrev  = reg-export-item.nome-abrev
             AND proc-ped-ent.nr-pedcli   = reg-export-item.nr-pedcli
             AND proc-ped-ent.nr-sequencia = reg-export-item.num-seq
             AND proc-ped-ent.it-codigo   = reg-export-item.it-codigo
             AND proc-ped-ent.cod-refer   = reg-export-item.cod-refer
             AND proc-ped-ent.nr-entrega  = reg-export-item.nr-entrega NO-ERROR.
      IF NOT AVAIL proc-ped-ent THEN NEXT.

      FIND FIRST ITEM NO-LOCK 
           WHERE ITEM.it-codigo = reg-export-item.it-codigo NO-ERROR.
      IF NOT AVAIL ITEM THEN NEXT.

      IF SUBSTRING(ped-item.char-2,1,8) <> "" THEN
         ASSIGN c-class-fiscal = SUBSTRING(ped-item.char-2,1,8).
      ELSE 
         ASSIGN c-class-fiscal = ITEM.class-fiscal.

   
      /* --------------------   FO: 1706.151 - UPC p/ VICUNHA-CE    -------------------- */
      FOR EACH  tt-epc WHERE tt-epc.cod-event     = 'UpdateClassFiscal':U
                         AND tt-epc.cod-parameter = 'class-fiscal':U:
          DELETE tt-epc.
      END.

      FOR EACH  tt-epc WHERE tt-epc.cod-event     = 'UpdateClassFiscal':U
                         AND tt-epc.cod-parameter = 'retorno-class-fiscal':U:
          DELETE tt-epc.
      END.

      /* Include i-epc200.i2: Criacao de registro para temp-table tt-epc */
      CREATE tt-epc.
      ASSIGN tt-epc.cod-event     = 'UpdateClassFiscal':U
             tt-epc.cod-parameter = 'class-fiscal':U
             tt-epc.val-parameter = reg-export-item.it-codigo + ';':U +
                                    reg-export-item.cod-refer + ';':U +
                                    c-class-fiscal.

      /* Include i-epc201.i: Chamada do programa de EPC */
      {include/i-epc201.i "UpdateClassFiscal"}.

      FOR FIRST tt-epc NO-LOCK 
          WHERE tt-epc.cod-event     = 'UpdateClassFiscal':U 
            AND tt-epc.cod-parameter = 'Retorno-class-fiscal':U :
          ASSIGN c-class-fiscal = tt-epc.val-parameter.
      END.
      /* -------------------------------------------------------------------------------- */

      RUN convertePrecoUnitario ( INPUT reg-export-item.cod-estabel, 
                                  INPUT reg-export-item.nome-abrev,
                                  INPUT reg-export-item.nr-pedcli,
                                  INPUT proc-ped-ent.vl-preuni,
                                 OUTPUT l-preco-maior,
                                 OUTPUT de-preco-conv).
          
      FIND FIRST bfReg-export-item NO-LOCK 
           WHERE bfReg-export-item.nr-re-ems   = reg-export-item.nr-re-ems 
             AND bfreg-export-item.cod-estabel = reg-export-item.cod-estabel
             AND bfreg-export-item.nr-proc-exp = reg-export-item.nr-proc-exp
             AND bfreg-export-item.nome-abrev  = reg-export-item.nome-abrev
             AND bfreg-export-item.nr-pedcli   = reg-export-item.nr-pedcli
             AND bfreg-export-item.num-seq     = reg-export-item.num-seq
             AND bfreg-export-item.it-codigo   = reg-export-item.it-codigo
             AND bfreg-export-item.cod-refer   = reg-export-item.cod-refer
             AND bfreg-export-item.nr-entrega  = reg-export-item.nr-entrega 
             AND ROWID (bfreg-export-item)    <> ROWID (reg-export-item) NO-ERROR.

      IF AVAIL bfreg-export-item THEN 
         ASSIGN l-ocorrencia = YES.
      ELSE 
         ASSIGN l-ocorrencia = NO.
      
      IF NOT l-preco-maior THEN DO:
         IF NOT p-idi-consid-cfop THEN DO:
             FIND LAST  tt-anexos NO-LOCK
                  WHERE tt-anexos.class-fiscal = c-class-fiscal 
                    AND tt-anexos.des-unid-medid-comerc = reg-export-item.cod-unid-medid-comerc
                    AND tt-anexos.qt-itens < i-qt-max-itens-anexo 
                    AND tt-anexos.l-preco-maior = NO NO-ERROR.
         END.
         ELSE DO:
             FIND LAST  tt-anexos NO-LOCK
                  WHERE tt-anexos.class-fiscal = c-class-fiscal 
                    AND tt-anexos.des-unid-medid-comerc = reg-export-item.cod-unid-medid-comerc
                    AND tt-anexos.qt-itens < i-qt-max-itens-anexo 
                    AND tt-anexos.l-preco-maior = NO
                    AND (p-idi-consid-cfop AND tt-anexos.cod-cfop = natur-oper.cod-cfop) NO-ERROR.
         END.

      END.
      
      IF NOT AVAIL tt-anexos OR l-preco-maior = YES               
                             OR reg-export-item.num-ocor-item > 1
                             OR l-ocorrencia  = YES 
                             OR i-qt-max-itens-anexo = 1 THEN DO:   

         ASSIGN i-ult-anexo = i-ult-anexo + 1.
         CREATE tt-anexos.
         ASSIGN tt-anexos.cdn-anexo             = i-ult-anexo
                tt-anexos.class-fiscal          = c-class-fiscal
                tt-anexos.des-unid-medid-comerc = reg-export-item.cod-unid-medid-comerc
                tt-anexos.num-ocor-item         = reg-export-item.num-ocor-item
                tt-anexos.qt-itens              = 0
                tt-anexos.l-preco-maior         = l-preco-maior
                tt-anexos.cod-cfop              = natur-oper.cod-cfop WHEN AVAIL natur-oper.
      END.

      ASSIGN reg-export-item.cdn-anexo = tt-anexos.cdn-anexo.

      /*FIND FIRST bfReg-export-item NO-LOCK 
           WHERE bfReg-export-item.nr-re-ems = reg-export-item.nr-re-ems 
             AND bfreg-export-item.cdn-anexo = reg-export-item.cdn-anexo
             AND bfreg-export-item.it-codigo = reg-export-item.it-codigo
             AND ROWID (bfreg-export-item)  <>  ROWID (reg-export-item) NO-ERROR.
      IF AVAIL bfreg-export-item THEN*/
         IF i-qt-max-itens-anexo <> 1 THEN
            ASSIGN tt-anexos.qt-itens = tt-anexos.qt-itens + 1.




  END.

  ASSIGN l-idi-consid-cfop =  p-idi-consid-cfop.
  RUN atualizarAnexos (INPUT pnr-re-ems ,
                       INPUT p-idi-desc-anex,
                       INPUT p-idi-quant-col).
  
  
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
        WHEN "class-fiscal":U THEN ASSIGN pFieldValue = RowObject.class-fiscal.
        WHEN "cod-categ-textil":U THEN ASSIGN pFieldValue = RowObject.cod-categ-textil.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "des-mercad[1]":U THEN ASSIGN pFieldValue = RowObject.des-mercad[1].
        WHEN "des-mercad[2]":U THEN ASSIGN pFieldValue = RowObject.des-mercad[2].
        WHEN "des-mercad[3]":U THEN ASSIGN pFieldValue = RowObject.des-mercad[3].
        WHEN "des-mercad[4]":U THEN ASSIGN pFieldValue = RowObject.des-mercad[4].
        WHEN "des-mercad[5]":U THEN ASSIGN pFieldValue = RowObject.des-mercad[5].
        WHEN "des-mercad[6]":U THEN ASSIGN pFieldValue = RowObject.des-mercad[6].
        WHEN "des-mercad[7]":U THEN ASSIGN pFieldValue = RowObject.des-mercad[7].
        WHEN "des-mercad[8]":U THEN ASSIGN pFieldValue = RowObject.des-mercad[8].
        WHEN "des-mercad[9]":U THEN ASSIGN pFieldValue = RowObject.des-mercad[9].
        WHEN "des-obs[1]":U THEN ASSIGN pFieldValue = RowObject.des-obs[1].
        WHEN "des-obs[2]":U THEN ASSIGN pFieldValue = RowObject.des-obs[2].
        WHEN "des-obs[3]":U THEN ASSIGN pFieldValue = RowObject.des-obs[3].
        WHEN "des-obs[4]":U THEN ASSIGN pFieldValue = RowObject.des-obs[4].
        WHEN "des-obs[5]":U THEN ASSIGN pFieldValue = RowObject.des-obs[5].
        WHEN "des-obs[6]":U THEN ASSIGN pFieldValue = RowObject.des-obs[6].
        WHEN "des-obs[7]":U THEN ASSIGN pFieldValue = RowObject.des-obs[7].
        WHEN "des-obs[8]":U THEN ASSIGN pFieldValue = RowObject.des-obs[8].
        WHEN "des-obs[9]":U THEN ASSIGN pFieldValue = RowObject.des-obs[9].
        WHEN "des-unid-medid-comerc":U THEN ASSIGN pFieldValue = RowObject.des-unid-medid-comerc.
        WHEN "uf-produt":U THEN ASSIGN pFieldValue = RowObject.uf-produt.
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
        WHEN "dat-valid-embarq":U THEN ASSIGN pFieldValue = RowObject.dat-valid-embarq.
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
        WHEN "qtd-unid-ncm":U THEN ASSIGN pFieldValue = RowObject.qtd-unid-ncm.
        WHEN "val-comissao":U THEN ASSIGN pFieldValue = RowObject.val-comissao.
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
        WHEN "val-perc-comis":U THEN ASSIGN pFieldValue = RowObject.val-perc-comis.
        WHEN "val-peso-liq":U THEN ASSIGN pFieldValue = RowObject.val-peso-liq.
        WHEN "val-preco-tot[1]":U THEN ASSIGN pFieldValue = RowObject.val-preco-tot[1].
        WHEN "val-preco-tot[2]":U THEN ASSIGN pFieldValue = RowObject.val-preco-tot[2].
        WHEN "val-preco-unit-comerc[1]":U THEN ASSIGN pFieldValue = RowObject.val-preco-unit-comerc[1].
        WHEN "val-preco-unit-comerc[2]":U THEN ASSIGN pFieldValue = RowObject.val-preco-unit-comerc[2].
        WHEN "val-preco-unit-ncm[1]":U THEN ASSIGN pFieldValue = RowObject.val-preco-unit-ncm[1].
        WHEN "val-preco-unit-ncm[2]":U THEN ASSIGN pFieldValue = RowObject.val-preco-unit-ncm[2].
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getFirstLastAnexo DBOProgram 
PROCEDURE getFirstLastAnexo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

     DEFINE INPUT PARAMETER prParent AS ROWID NO-UNDO.
     DEFINE OUTPUT PARAMETER p-firstAnexo AS INTEGER NO-UNDO.
     DEFINE OUTPUT PARAMETER p-lastAnexo AS INTEGER NO-UNDO.


     FIND FIRST bf{&TableName} NO-LOCK 
          WHERE ROWID(bf{&TableName}) = prParent NO-ERROR.

     FIND FIRST reg-export NO-LOCK 
          WHERE reg-export.nr-re-ems = bfreg-export-anexo.nr-re-ems NO-ERROR.

     IF AVAIL reg-export THEN DO:

        ASSIGN p-firstAnexo = bf{&TableName}.cdn-anexo.

        FIND LAST bf{&TableName} NO-LOCK 
             WHERE bf{&TableName}.nr-re-ems = reg-export.nr-re-ems NO-ERROR.

        IF AVAIL bf{&TableName} THEN
           ASSIGN p-LastAnexo = bf{&TableName}.cdn-anexo. 

     END.

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
        WHEN "cdn-finalid":U THEN ASSIGN pFieldValue = RowObject.cdn-finalid.
        WHEN "cdn-naladi":U THEN ASSIGN pFieldValue = RowObject.cdn-naladi.
        WHEN "idi-tip-comis-agent":U THEN ASSIGN pFieldValue = RowObject.idi-tip-comis-agent.
        WHEN "nr-re-ems":U THEN ASSIGN pFieldValue = RowObject.nr-re-ems.
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
  Purpose:     Retorna valores dos campos do °ndice rgxprtnx-id
  Parameters:  
               retorna valor do campo nr-re-ems
               retorna valor do campo cdn-anexo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnr-re-ems LIKE reg-export-anexo.nr-re-ems NO-UNDO.
    DEFINE OUTPUT PARAMETER pcdn-anexo LIKE reg-export-anexo.cdn-anexo NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnr-re-ems = RowObject.nr-re-ems
           pcdn-anexo = RowObject.cdn-anexo.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice rgxprtnx-id
  Parameters:  
               recebe valor do campo nr-re-ems
               recebe valor do campo cdn-anexo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-re-ems LIKE reg-export-anexo.nr-re-ems NO-UNDO.
    DEFINE INPUT PARAMETER pcdn-anexo LIKE reg-export-anexo.cdn-anexo NO-UNDO.

    FIND FIRST bfreg-export-anexo WHERE 
        bfreg-export-anexo.nr-re-ems = pnr-re-ems AND 
        bfreg-export-anexo.cdn-anexo = pcdn-anexo NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfreg-export-anexo THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfreg-export-anexo)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gravaDescMercad DBOProgram 
PROCEDURE gravaDescMercad :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-nr-re-ems LIKE reg-export-anexo.nr-re-ems NO-UNDO.
    DEFINE INPUT PARAMETER p-idi-desc-anex  AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER p-idi-quant-col  AS INTEGER NO-UNDO.
    
    /* gravar nos campos extent(s) */
    IF p-idi-quant-col = 1 THEN 
       ASSIGN OVERLAY(reg-export-item.cod-livre-1,1,1) = "1":U.
    ELSE 
       ASSIGN OVERLAY(reg-export-item.cod-livre-1,1,1) = "5":U.
    ASSIGN i-qt-itens = i-qt-itens + 1.

    IF /*(p-idi-quant-col   = 1  or         /* uma coluna */
        p-idi-quant-col   = 2) AND */       /* duas colunas */
        p-idi-desc-anex <> 3   THEN DO:   /* forma descricao item ou  ncm*/

        assign i-cont = i-cont + 1.

        IF  p-idi-quant-col = 2  AND       /* duas colunas */
            p-idi-desc-anex = 1  THEN DO:  /* item */

            IF i-qt-itens <= i-qt-max-itens-anexo THEN DO:

               if i-cont mod 2  = 1 then 
                  assign i-cont2 = i-cont2 + 1.                                                               
               if i-cont2 = 0 then assign i-cont2 = 1. 
               assign c-desc-aux = substring(string(de-qtd-unid-medid-comerc)  + " "  + 
                                   reg-export-item.cod-unid-medid-comerc       + " "  +
                                   ITEM.desc-item,1,37).
             
               if tt-reg-export-anexo.des-mercad[i-cont2] = "" then do:
                  assign c-espaco = " "
                         c-dif-espaco = 37 - length(c-desc-aux) 
                         tt-reg-export-anexo.des-mercad[i-cont2] = substring(c-desc-aux,1,37) + string(FILL(c-espaco,c-dif-espaco)) + " - ".
               end.
               else 
                  assign tt-reg-export-anexo.des-mercad[i-cont2] = tt-reg-export-anexo.des-mercad[i-cont2] + substring(c-desc-aux,1,37).

                  ASSIGN OVERLAY(reg-export-item.cod-livre-1,2) = c-desc-aux.

            END.
               
        end.
        else do: /* uma coluna e forma descriá∆o item ou ncm / duas colunas e forma descricao ncm*/
               
            if p-idi-desc-anex = 2 then do:

               IF i-qt-itens <= i-qt-max-itens-anexo THEN DO:
                  FIND classif-fisc NO-LOCK WHERE 
                       classif-fisc.class-fiscal = tt-reg-export-anexo.class-fiscal NO-ERROR.
                  IF AVAIL classif-fisc THEN
                     ASSIGN c-descricao = classif-fisc.descricao.
                  assign c-desc-aux = string(tt-reg-export-anexo.qtd-unid-comerc) + " " + 
                                             reg-export-item.cod-unid-medid-comerc   + " " + c-descricao
                         tt-reg-export-anexo.des-mercad[1] = c-desc-aux
                         OVERLAY(reg-export-item.cod-livre-1,2) = c-desc-aux.
                    
               END.

            end. 
            else do: 

               IF i-qt-itens <= i-qt-max-itens-anexo THEN DO:
                  assign c-descricao = ITEM.desc-item.     
                  assign c-desc-aux = string(de-qtd-unid-medid-comerc)        + " " + 
                                             reg-export-item.cod-unid-medid-comerc   + " " + c-descricao
                         tt-reg-export-anexo.des-mercad[i-cont] = c-desc-aux
                         OVERLAY(reg-export-item.cod-livre-1,2) = c-desc-aux.
                  
               END.

            END.

        end. 
        
    end.
       
    IF /*(p-idi-quant-col   = 1  or      /* uma coluna */
        p-idi-quant-col   = 2) AND   */  /* duas colunas */
        p-idi-desc-anex = 3 THEN DO: /* ambos */
        
        IF i-cont = 0 THEN
           assign i-cont = 1.     

        IF i-cont = 1 THEN DO:

            FIND classif-fisc NO-LOCK WHERE 
                 classif-fisc.class-fiscal = tt-reg-export-anexo.class-fiscal NO-ERROR.
            IF AVAIL classif-fisc THEN
               ASSIGN c-descricao = classif-fisc.descricao
                      tt-reg-export-anexo.des-mercad[i-cont] = string(tt-reg-export-anexo.qtd-unid-comerc)  + " " +
                                                               reg-export-item.cod-unid-medid-comerc + " " + c-descricao.
            
        END.

        if p-idi-quant-col = 1 then do:
           IF i-qt-itens <= i-qt-max-itens-anexo THEN 
              assign i-cont = i-cont + 1
                     tt-reg-export-anexo.des-mercad[i-cont] = string(de-qtd-unid-medid-comerc)    + " " + 
                                                                  reg-export-item.cod-unid-medid-comerc  + " " + ITEM.desc-item
                     OVERLAY(reg-export-item.cod-livre-1,2) = string(de-qtd-unid-medid-comerc)    + " " + 
                                                              reg-export-item.cod-unid-medid-comerc  + " " + ITEM.desc-item.
        end.
        else do:

           IF i-cont2 = 0 THEN
              assign i-cont2 = 1.        

           IF i-qt-itens <= i-qt-max-itens-anexo THEN DO:
              ASSIGN i-cont = i-cont + 1.

              if i-cont mod 2  = 0 then 
                 assign i-cont2 = i-cont2 + 1.
           
              assign c-desc-aux = substring(string(de-qtd-unid-medid-comerc,">>>>>,>>>,>>9.99999")  + " "  + 
                                           reg-export-item.cod-unid-medid-comerc     + " "  + ITEM.desc-item,1,37).

              IF tt-reg-export-anexo.des-mercad[i-cont2] = "" then 
                 assign c-espaco = " "
                        c-dif-espaco = 37 - length(c-desc-aux) 
                        tt-reg-export-anexo.des-mercad[i-cont2] = substring(c-desc-aux,1,37) + string(FILL(c-espaco,c-dif-espaco)) + " - ".
              else 
                 assign tt-reg-export-anexo.des-mercad[i-cont2] = tt-reg-export-anexo.des-mercad[i-cont2] + substring(c-desc-aux,1,37).
    

              ASSIGN OVERLAY(reg-export-item.cod-livre-1,2) = c-desc-aux.

           END.

        END.
       
    end.
    
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryAnexo DBOProgram 
PROCEDURE openQueryAnexo :
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByRE DBOProgram 
PROCEDURE openQueryByRE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QUERYNAME} for each {&TableName} NO-LOCK
                               WHERE {&TableName}.nr-re-ems >= i-nr-re-ems-ini 
                                 AND {&TableName}.nr-re-ems <= i-nr-re-ems-fin 
                                 INDEXED-REPOSITION.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-grava-siscoserv DBOProgram 
PROCEDURE pi-grava-siscoserv :
/*------------------------------------------------------------------------------
  Purpose:     Procedure para gravar os dados da tabela de Extens∆o do siscoserv
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF NOT VALID-HANDLE(h-cdapi040) THEN DO:
        RUN cdp/cdapi040.p PERSISTENT SET h-cdapi040.
    END.
    RUN pi-siscoserv-ativo IN h-cdapi040.
    IF RETURN-VALUE = "OK":U THEN DO:
        FOR FIRST reg-export FIELDS (cod-estabel nr-proc-exp nr-re-siscomex dat-reg-export) NO-LOCK
            WHERE reg-export.nr-re-ems = {&TableName}.nr-re-ems:

            /*Busca a tabela de itens do registro de exportaáao*/
            FOR EACH reg-export-item FIELDS(nome-abrev nr-pedcli num-seq cod-refer it-codigo)
                WHERE  reg-export-item.cod-estabel = reg-export.cod-estabel
                AND    reg-export-item.nr-proc-exp = reg-export.nr-proc-exp NO-LOCK:

                 /*Verifica se existe pelo menos um item para o anexo*/
                IF CAN-FIND (FIRST ped-item-siscoserv
                             WHERE   ped-item-siscoserv.cod-estabel  =  reg-export.cod-estabel
                             AND     ped-item-siscoserv.nome-abrev   =  reg-export-item.nome-abrev
                             AND     ped-item-siscoserv.nr-pedcli    =  reg-export-item.nr-pedcli
                             AND     ped-item-siscoserv.nr-sequencia =  reg-export-item.num-seq
                             AND     ped-item-siscoserv.it-codigo    =  reg-export-item.it-codigo
                             AND     ped-item-siscoserv.cod-refer    =  reg-export-item.cod-refer) THEN DO:

                    RUN pi-grava-re-export-sis IN h-cdapi040 (INPUT reg-export.cod-estabel,
                                                              INPUT reg-export.nr-proc-exp,
                                                              INPUT reg-export.nr-re-siscomex,
                                                              INPUT {&TableName}.nr-re-ems,
                                                              INPUT {&TableName}.cdn-anexo,
                                                              INPUT reg-export.dat-reg-export).
                    LEAVE.
                END.
            END.
        END.        
    END.

    IF VALID-HANDLE(h-cdapi040) THEN DO:
        DELETE PROCEDURE h-cdapi040.
        ASSIGN h-cdapi040 = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByRE DBOProgram 
PROCEDURE setConstraintByRE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pnr-re-ems-ini LIKE reg-export.nr-re-ems NO-UNDO.
  DEFINE INPUT PARAMETER pnr-re-ems-fin LIKE reg-export.nr-re-ems NO-UNDO.

  ASSIGN i-nr-re-ems-ini = pnr-re-ems-ini
         i-nr-re-ems-fin = pnr-re-ems-fin.

  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaCriacaoAnexos DBOProgram 
PROCEDURE validaCriacaoAnexos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-re-ems LIKE reg-export-anexo.nr-re-ems NO-UNDO.

    &IF DEFINED(bf_comex206b-1) &THEN

        FIND reg-export WHERE reg-export.nr-re-ems = pnr-re-ems NO-LOCK NO-ERROR.
    
        IF  NOT AVAIL reg-export THEN 
            RETURN "NOK":U.
    
        FIND FIRST param-exp NO-LOCK
             WHERE param-exp.cod-estabel = reg-export.cod-estabel NO-ERROR.
        IF  NOT AVAIL param-exp THEN
            RETURN "NOK":U.
    
        IF  param-exp.idi-busca-despes-export = 2 THEN
            FOR FIRST processo-exp FIELDS(cod-estabel nr-proc-exp log-1)
                WHERE processo-exp.cod-estabel = reg-export.cod-estabel
                  AND processo-exp.nr-proc-exp = reg-export.nr-proc-exp NO-LOCK:
        
                IF  CAN-FIND(FIRST proc-desp-itiner
                             WHERE proc-desp-itiner.cod-estabel = processo-exp.cod-estabel
                               AND proc-desp-itiner.nr-proc-exp = processo-exp.nr-proc-exp) 
                    AND NOT processo-exp.log-1 THEN DO:
                    {method/svc/errors/inserr.i
                            &ErrorNumber="31927"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"}
                    RETURN "NOK":U.
                END.
            END.
    &ENDIF

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validarAnexos DBOProgram 
PROCEDURE validarAnexos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:  Efetuar† a validaá∆o dos grupos de itens do RE (geraá∆o manual)     
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pNrReEms LIKE reg-export-anexo.nr-re-ems NO-UNDO.
  DEFINE INPUT PARAMETER p-idi-desc-anex  AS INTEGER NO-UNDO.
  DEFINE INPUT PARAMETER p-idi-quant-col  AS INTEGER NO-UNDO.
  DEFINE INPUT PARAMETER p-idi-consid-cfop AS LOGICAL NO-UNDO.
  DEFINE INPUT PARAMETER TABLE FOR tt-reg-export-item-aux .


  &IF DEFINED(bf_comex206b-1) &THEN
      RUN validaCriacaoAnexos (INPUT pNrReEms).

      IF  RETURN-VALUE = "NOK":U THEN 
          RETURN "NOK":U.
  &ENDIF

  FOR EACH tt-item-anexo:
      DELETE tt-item-anexo.
  END.

  FOR EACH tt-reg-export-item-aux NO-LOCK 
      WHERE tt-reg-export-item-aux.nr-re-ems = pNrReEms:

      IF tt-reg-export-item-aux.cdn-anexo = 0 THEN NEXT.

      FIND FIRST ped-item NO-LOCK 
           WHERE ped-item.nome-abrev = tt-reg-export-item-aux.nome-abrev
             AND ped-item.nr-pedcli  = tt-reg-export-item-aux.nr-pedcli
             AND ped-item.nr-sequencia = tt-reg-export-item-aux.num-seq
             AND ped-item.it-codigo = tt-reg-export-item-aux.it-codigo
             AND ped-item.cod-refer = tt-reg-export-item-aux.cod-refer NO-ERROR.

      IF NOT AVAIL ped-item THEN NEXT.

      FIND FIRST natur-oper NO-LOCK
          WHERE natur-oper.nat-operacao = ped-item.nat-operacao NO-ERROR.

      FIND FIRST proc-ped-ent NO-LOCK 
           WHERE proc-ped-ent.cod-estabel = tt-reg-export-item-aux.cod-estabel
             AND proc-ped-ent.nr-proc-exp = tt-reg-export-item-aux.nr-proc-exp
             AND proc-ped-ent.nome-abrev  = tt-reg-export-item-aux.nome-abrev
             AND proc-ped-ent.nr-pedcli   = tt-reg-export-item-aux.nr-pedcli
             AND proc-ped-ent.nr-sequencia = tt-reg-export-item-aux.num-seq
             AND proc-ped-ent.it-codigo   = tt-reg-export-item-aux.it-codigo
             AND proc-ped-ent.cod-refer   = tt-reg-export-item-aux.cod-refer
             AND proc-ped-ent.nr-entrega  = tt-reg-export-item-aux.nr-entrega NO-ERROR.
      IF NOT AVAIL proc-ped-ent THEN NEXT.

      FIND FIRST ITEM NO-LOCK 
           WHERE ITEM.it-codigo = tt-reg-export-item-aux.it-codigo NO-ERROR.

      IF NOT AVAIL ITEM THEN NEXT.

      CREATE tt-item-anexo.

      IF SUBSTRING(ped-item.char-2,01,08) <> "" THEN
         ASSIGN tt-item-anexo.class-fiscal = SUBSTRING(ped-item.char-2,01,08).
      ELSE 
         ASSIGN tt-item-anexo.class-fiscal = ITEM.class-fiscal.


      RUN convertePrecoUnitario ( INPUT tt-reg-export-item-aux.cod-estabel, 
                                 INPUT tt-reg-export-item-aux.nome-abrev,
                                 INPUT tt-reg-export-item-aux.nr-pedcli,
                                 INPUT proc-ped-ent.vl-preuni,
                                OUTPUT l-preco-maior,
                                OUTPUT de-preco-conv).

      ASSIGN tt-item-anexo.preco-maior = l-preco-maior
             tt-item-anexo.num-ocor-item = tt-reg-export-item-aux.num-ocor-item
             tt-item-anexo.cdn-anexo = tt-reg-export-item-aux.cdn-anexo
             tt-item-anexo.it-codigo = tt-reg-export-item-aux.it-codigo
             tt-item-anexo.des-unid-medid-comerc = tt-reg-export-item-aux.cod-unid-medid-comerc
             tt-item-anexo.r-rowid   = tt-reg-export-item-aux.r-rowid
             tt-item-anexo.cod-cfop  = natur-oper.cod-cfop WHEN AVAIL natur-oper.


  END.
  
  ASSIGN c-lista-class-fiscal = ""
         c-lista-unidade      = ""
         c-lista-preco        = ""
         c-lista-ocorrencia   = ""
         c-lista-qt-itens     = ""
         c-lista-cfop         = "".

  FOR EACH tt-item-anexo:

    IF NOT p-idi-consid-cfop THEN 
        FIND FIRST bftt-item-anexo NO-LOCK 
            WHERE bftt-item-anexo.cdn-anexo     = tt-item-anexo.cdn-anexo
            AND bftt-item-anexo.class-fiscal <> tt-item-anexo.class-fiscal
            /*AND bftt-item-anexo.cod-cfop     <> tt-item-anexo.cod-cfop*/  /*marcelo*/
            /*AND bftt-item-anexo.r-rowid      <> tt-item-anexo.r-rowid*/ NO-ERROR.
    ELSE
        FIND FIRST bftt-item-anexo NO-LOCK 
            WHERE bftt-item-anexo.cdn-anexo     = tt-item-anexo.cdn-anexo
            AND   (bftt-item-anexo.class-fiscal <> tt-item-anexo.class-fiscal
            OR   bftt-item-anexo.cod-cfop     <> tt-item-anexo.cod-cfop) /*marcelo*/
            /*AND   bftt-item-anexo.r-rowid      <> tt-item-anexo.r-rowid*/ NO-ERROR.

    IF AVAIL bftt-item-anexo THEN DO:

        IF p-idi-consid-cfop THEN DO:
            IF bftt-item-anexo.cod-cfop <> tt-item-anexo.cod-cfop THEN DO:
                IF INDEX (c-lista-cfop, STRING(bftt-item-anexo.cdn-anexo)) = 0 THEN DO:
                    IF c-lista-cfop = "" THEN DO:
                        ASSIGN c-lista-cfop = c-lista-cfop + STRING(bftt-item-anexo.cdn-anexo).
                    END. ELSE DO:
                        ASSIGN c-lista-cfop = c-lista-cfop + ", " + STRING(bftt-item-anexo.cdn-anexo).
                    END.
                END.
            END.
        END.


        IF INDEX (c-lista-class-fiscal,string(bftt-item-anexo.cdn-anexo)) = 0 THEN DO:
            IF c-lista-class-fiscal = "" THEN
                ASSIGN c-lista-class-fiscal = c-lista-class-fiscal + string(bftt-item-anexo.cdn-anexo).
            ELSE 
                ASSIGN c-lista-class-fiscal = c-lista-class-fiscal + ", " + string(bftt-item-anexo.cdn-anexo).
        END.
    END.
    ELSE
          FIND FIRST bftt-item-anexo NO-LOCK 
               WHERE bftt-item-anexo.cdn-anexo              = tt-item-anexo.cdn-anexo
                 AND bftt-item-anexo.class-fiscal           = tt-item-anexo.class-fiscal
                 AND bftt-item-anexo.des-unid-medid-comerc <> tt-item-anexo.des-unid-medid-comerc 
                 AND bftt-item-anexo.r-rowid <> tt-item-anexo.r-rowid NO-ERROR.
          IF AVAIL bftt-item-anexo THEN DO:
             IF INDEX (c-lista-unidade,string(bftt-item-anexo.cdn-anexo)) = 0 THEN DO:
                IF c-lista-unidade = "" THEN
                   ASSIGN c-lista-unidade = c-lista-unidade + string(bftt-item-anexo.cdn-anexo).
                ELSE 
                   ASSIGN c-lista-unidade = c-lista-unidade + ", " + string(bftt-item-anexo.cdn-anexo).
             END.
          END.

      IF  tt-item-anexo.preco-maior THEN DO:
          FIND FIRST bftt-item-anexo NO-LOCK 
               WHERE bftt-item-anexo.cdn-anexo = tt-item-anexo.cdn-anexo
                 AND bftt-item-anexo.r-rowid <> tt-item-anexo.r-rowid NO-ERROR.
          IF AVAIL bftt-item-anexo THEN DO:
             IF INDEX (c-lista-preco,string(bftt-item-anexo.cdn-anexo)) = 0 THEN DO:
                IF c-lista-preco = "" THEN
                   ASSIGN c-lista-preco = c-lista-preco + string(bftt-item-anexo.cdn-anexo).
                ELSE
                   ASSIGN c-lista-preco = c-lista-preco + ", " + string(bftt-item-anexo.cdn-anexo).
             END.
          END.
      END.

      IF tt-item-anexo.num-ocor-item <> 1 THEN DO:
          FIND FIRST bftt-item-anexo NO-LOCK 
               WHERE bftt-item-anexo.cdn-anexo = tt-item-anexo.cdn-anexo
                 AND bftt-item-anexo.r-rowid <> tt-item-anexo.r-rowid NO-ERROR.
          IF AVAIL bftt-item-anexo THEN DO:
             IF INDEX (c-lista-ocorrencia,string(bftt-item-anexo.cdn-anexo)) = 0 THEN DO:
                IF c-lista-ocorrencia = "" THEN
                   ASSIGN c-lista-ocorrencia = c-lista-ocorrencia + string(bftt-item-anexo.cdn-anexo).
                ELSE
                   ASSIGN c-lista-ocorrencia = c-lista-ocorrencia + ", " + string(bftt-item-anexo.cdn-anexo).
             END.
          END.
      END.


  END.


  ASSIGN c-it-codigo = ""
         i-qt-reg-anexos = 0
         i-qt-max-itens-anexo = 0.

  IF p-idi-quant-col = 1 THEN DO:
     ASSIGN i-qt-max-itens-anexo = 1.
  END.
  ELSE 
     ASSIGN i-qt-max-itens-anexo = 5.

  FOR EACH tt-item-anexo
      BREAK BY tt-item-anexo.cdn-anexo
            BY tt-item-anexo.it-codigo:

      IF i-qt-max-itens-anexo <> 1 THEN
         IF LAST-OF (tt-item-anexo.it-codigo) THEN
            ASSIGN i-qt-reg-anexos = i-qt-reg-anexos + 1.
                
      IF LAST-OF (tt-item-anexo.cdn-anexo) THEN DO:
         IF i-qt-reg-anexos > i-qt-max-itens-anexo THEN DO:
            IF INDEX (c-lista-qt-itens,string(tt-item-anexo.cdn-anexo)) = 0 THEN DO:
               IF c-lista-qt-itens = "" THEN
                  ASSIGN c-lista-qt-itens = c-lista-qt-itens + string(tt-item-anexo.cdn-anexo).
               ELSE 
                  ASSIGN c-lista-qt-itens = c-lista-qt-itens + ", " + string(tt-item-anexo.cdn-anexo).
            END.
         END.
         ASSIGN i-qt-reg-anexos = 0.
      END.

  END.

  IF c-lista-cfop <> "" THEN DO:
      /* Inicio -- Projeto Internacional */
      DEFINE VARIABLE c-lbl-liter-pelo-codigo-do-cfop AS CHARACTER NO-UNDO.
      {utp/ut-liter.i "pelo_c¢digo_do_CFOP" *}
      ASSIGN c-lbl-liter-pelo-codigo-do-cfop = TRIM(RETURN-VALUE).
      DEFINE VARIABLE c-lbl-liter-cfops AS CHARACTER NO-UNDO.
      {utp/ut-liter.i "CFOPs" *}
      ASSIGN c-lbl-liter-cfops = TRIM(RETURN-VALUE).
      {method/svc/errors/inserr.i
              &ErrorNumber="30551"
              &ErrorType="EMS"
              &ErrorSubType="ERROR"
              &ErrorParameters="c-lbl-liter-pelo-codigo-do-cfop + '~~~~' + c-lista-cfop + '~~~~' + c-lbl-liter-cfops "}
       RETURN "NOK":U.                    
  END.

  IF c-lista-class-fiscal <> "" THEN DO:
      /* Inicio -- Projeto Internacional */
      DEFINE VARIABLE c-lbl-liter-pelo-codigo-da-ncm AS CHARACTER NO-UNDO.
      {utp/ut-liter.i "pelo_c¢digo_da_NCM" *}
      ASSIGN c-lbl-liter-pelo-codigo-da-ncm = TRIM(RETURN-VALUE).
      DEFINE VARIABLE c-lbl-liter-classificacoes-fiscais AS CHARACTER NO-UNDO.
      {utp/ut-liter.i "classificaá‰es_fiscais" *}
      ASSIGN c-lbl-liter-classificacoes-fiscais = TRIM(RETURN-VALUE).
      {method/svc/errors/inserr.i
              &ErrorNumber="30551"
              &ErrorType="EMS"
              &ErrorSubType="ERROR"
              &ErrorParameters="c-lbl-liter-pelo-codigo-da-ncm + '~~~~' + c-lista-class-fiscal + '~~~~' + c-lbl-liter-classificacoes-fiscais "}
       RETURN "NOK":U.                    
  END.

  IF c-lista-unidade <> "" THEN DO:
      /* Inicio -- Projeto Internacional */
      DEFINE VARIABLE c-lbl-liter-pelo-codigo-da-unid-medida-com AS CHARACTER NO-UNDO.
      {utp/ut-liter.i "pelo_c¢digo_da_Unid_Medida_Comerc" *}
      ASSIGN c-lbl-liter-pelo-codigo-da-unid-medida-com = TRIM(RETURN-VALUE).
      DEFINE VARIABLE c-lbl-liter-unidades-de-medida-de-comercia AS CHARACTER NO-UNDO.
      {utp/ut-liter.i "unidades_de_medida_de_comercializaá∆o" *}
      ASSIGN c-lbl-liter-unidades-de-medida-de-comercia = TRIM(RETURN-VALUE).
      {method/svc/errors/inserr.i
              &ErrorNumber="30551"
              &ErrorType="EMS"
              &ErrorSubType="ERROR"
              &ErrorParameters="c-lbl-liter-pelo-codigo-da-unid-medida-com + '~~~~' + c-lista-unidade + '~~~~' + c-lbl-liter-unidades-de-medida-de-comercia "}
       RETURN "NOK":U.                    
  END.

  IF c-lista-preco <> "" THEN DO:
      {method/svc/errors/inserr.i
              &ErrorNumber="30552"
              &ErrorType="EMS"
              &ErrorSubType="ERROR"
              &ErrorParameters="c-lista-preco"}
       RETURN "NOK":U.                    
  END.

  IF c-lista-ocorrencia <> "" THEN DO:
      {method/svc/errors/inserr.i
              &ErrorNumber="30553"
              &ErrorType="EMS"
              &ErrorSubType="ERROR"
              &ErrorParameters="c-lista-ocorrencia"}
       RETURN "NOK":U.                    
  END.

  IF c-lista-qt-itens <> "" THEN DO:
      {method/svc/errors/inserr.i
              &ErrorNumber="30554"
              &ErrorType="EMS"
              &ErrorSubType="ERROR"
              &ErrorParameters="c-lista-qt-itens"}
       RETURN "NOK":U.                    
  END.

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
    
    IF pType = "Update":U THEN DO:

        FIND FIRST unid-feder NO-LOCK 
              WHERE unid-feder.pais = "Brasil" 
               AND unid-feder.estado = rowobject.uf-produt NO-ERROR.
        IF NOT AVAIL unid-feder THEN DO:
          /* Inicio -- Projeto Internacional */
          DEFINE VARIABLE c-lbl-liter-estado-produtor AS CHARACTER NO-UNDO.
          {utp/ut-liter.i "Estado_Produtor" *}
          ASSIGN c-lbl-liter-estado-produtor = TRIM(RETURN-VALUE).
          DEFINE VARIABLE c-lbl-liter-brasil AS CHARACTER NO-UNDO.
          {utp/ut-liter.i "Brasil" *}
          ASSIGN c-lbl-liter-brasil = TRIM(RETURN-VALUE).
          {method/svc/errors/inserr.i
                  &ErrorNumber="2"
                  &ErrorType="EMS"
                  &ErrorSubType="ERROR"
                  &ErrorParameters="c-lbl-liter-estado-produtor + '~~~~' + c-lbl-liter-brasil"}
        END.
        

        IF rowobject.val-peso-liq <= 0 THEN DO:
            {method/svc/errors/inserr.i
                   &ErrorNumber="8150"
                   &ErrorType="EMS"
                   &ErrorSubType="ERROR"
                   &ErrorParameters="''"}
        END.
    
        
        IF rowobject.qtd-unid-comerc <= 0 THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-quantidade-unid-medida-comerc AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Quantidade_Unid_Medida_Comerc" *}
            ASSIGN c-lbl-liter-quantidade-unid-medida-comerc = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                   &ErrorNumber="30555"
                   &ErrorType="EMS"
                   &ErrorSubType="ERROR"
                   &ErrorParameters="c-lbl-liter-quantidade-unid-medida-comerc"}
        END.

        IF rowobject.qtd-unid-ncm <= 0 THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-quantidade-unid-medida-mercad AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Quantidade_Unid_Medida_Mercad" *}
            ASSIGN c-lbl-liter-quantidade-unid-medida-mercad = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                   &ErrorNumber="30555"
                   &ErrorType="EMS"
                   &ErrorSubType="ERROR"
                   &ErrorParameters="c-lbl-liter-quantidade-unid-medida-mercad"}
        END.

        IF rowobject.des-unid-medid-comerc = "" or
           rowobject.des-unid-medid-comerc = "?" OR 
           rowobject.des-unid-medid-comerc = ? THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-unid-medida-comerc AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Unid_Medida_Comerc" *}
            ASSIGN c-lbl-liter-unid-medida-comerc = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                   &ErrorNumber="5793"
                   &ErrorType="EMS"
                   &ErrorSubType="ERROR"
                   &ErrorParameters="c-lbl-liter-unid-medida-comerc"}
        END.
    
        IF rowobject.val-preco-tot[1] <= 0 THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-preco-total-condicao-venda AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Preáo_Total_Condiá∆o_Venda" *}
            ASSIGN c-lbl-liter-preco-total-condicao-venda = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                   &ErrorNumber="30555"
                   &ErrorType="EMS"
                   &ErrorSubType="ERROR"
                   &ErrorParameters="c-lbl-liter-preco-total-condicao-venda"}
        END.
        

        IF rowobject.val-preco-tot[2] <= 0 THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-preco-total-local-embarque AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Preáo_Total_Local_Embarque" *}
            ASSIGN c-lbl-liter-preco-total-local-embarque = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                   &ErrorNumber="30555"
                   &ErrorType="EMS"
                   &ErrorSubType="ERROR"
                   &ErrorParameters="c-lbl-liter-preco-total-local-embarque"}
        END.


        IF rowobject.val-preco-unit-comerc[1] <= 0 THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-preco-unit-na-unid-comerc-cond AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Preáo_Unit_na_Unid_Comerc_(Cond_Venda)" *}
            ASSIGN c-lbl-liter-preco-unit-na-unid-comerc-cond = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                   &ErrorNumber="30555"
                   &ErrorType="EMS"
                   &ErrorSubType="ERROR"
                   &ErrorParameters="c-lbl-liter-preco-unit-na-unid-comerc-cond"}
        END.

        IF rowobject.val-preco-unit-ncm[1] <= 0 THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-preco-unit-na-unid-mercad-cond AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Preáo_Unit_na_Unid_Mercad_(Cond_Venda)" *}
            ASSIGN c-lbl-liter-preco-unit-na-unid-mercad-cond = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                   &ErrorNumber="30555"
                   &ErrorType="EMS"
                   &ErrorSubType="ERROR"
                   &ErrorParameters="c-lbl-liter-preco-unit-na-unid-mercad-cond"}
        END.


        IF rowobject.val-preco-unit-comerc[2] <= 0 THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-preco-unit-na-unid-comerc-loca AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Preáo_Unit_na_Unid_Comerc_(Local_Embarque)" *}
            ASSIGN c-lbl-liter-preco-unit-na-unid-comerc-loca = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                   &ErrorNumber="30555"
                   &ErrorType="EMS"
                   &ErrorSubType="ERROR"
                   &ErrorParameters="c-lbl-liter-preco-unit-na-unid-comerc-loca"}
        END.

        IF rowobject.val-preco-unit-ncm[2] <= 0 THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-preco-unit-na-unid-mercad-loca AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Preáo_Unit_na_Unid_Mercad_(Local_Embarque)" *}
            ASSIGN c-lbl-liter-preco-unit-na-unid-mercad-loca = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                   &ErrorNumber="30555"
                   &ErrorType="EMS"
                   &ErrorSubType="ERROR"
                   &ErrorParameters="c-lbl-liter-preco-unit-na-unid-mercad-loca"}
        END.        
    END.
    
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
       RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-preco-anexo DBOProgram 
PROCEDURE valida-preco-anexo :
/*------------------------------------------------------------------------------
  Purpose: Valida se o preáo total do anexo na condiá∆o de venda ficou menor que
           o total do anexo no local de embarque.     
  Parameters:  Sa°da: RowErrors
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.
    
    IF AVAIL tt-reg-export-anexo THEN DO:
       /* Inicio -- Projeto Internacional */
       DEFINE VARIABLE c-cond-vend AS CHARACTER NO-UNDO.
       {utp/ut-liter.i "Preáo_Total_na_Condiá∆o_de_Venda" *}
       ASSIGN c-cond-vend = TRIM(RETURN-VALUE).
       DEFINE VARIABLE c-loc-embarq AS CHARACTER NO-UNDO.
       {utp/ut-liter.i "Preáo_Total_no_Local_de_Embarque" *}              
       ASSIGN c-loc-embarq = TRIM(RETURN-VALUE).   
       IF tt-reg-export-anexo.val-preco-tot[1] < tt-reg-export-anexo.val-preco-tot[2] THEN DO:
           ASSIGN iErro = iErro + 1.
          {method/svc/errors/inserr.i
                  &ErrorNumber="55417"
                  &ErrorType="EMS":U
                  &ErrorSubType="WARNING":U
                  &ErrorSequence=iErro
                  &ErrorParameters="c-cond-vend + '~~~~' + c-loc-embarq + '~~~~' + string(tt-reg-export-anexo.cdn-anexo) + '~~~~' + string(tt-reg-export-anexo.val-preco-tot[1])+ '~~~~' + string(tt-reg-export-anexo.val-preco-tot[2])"}
       END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setContAnexo DBOProgram 
PROCEDURE setContAnexo :
/*:T------------------------------------------------------------------------------
  Purpose:     Verifica se existe mais de um anexo criado para o RE
  Parameters:  Recebe o numero do RE EMS e retorna valor 0, 1 ou 2.
  Notes: 0 = n∆o tem anexo gerado
         1 = anexo £nico
         2 = existe mais de um anexo      
------------------------------------------------------------------------------*/
    
    DEFINE INPUT  PARAMETER pNrReEms    LIKE reg-export-anexo.nr-re-ems NO-UNDO.
    DEFINE OUTPUT PARAMETER pContAnexo  AS INTEGER NO-UNDO.

    ASSIGN pContAnexo = 0.
    FOR EACH bf{&TableName} NO-LOCK 
      WHERE bf{&TableName}.nr-re-ems = pNrReEms:
      ASSIGN pContAnexo = pContAnexo + 1.
        IF pContAnexo > 1 THEN LEAVE.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
