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
{include/i-prgvrs.i BOCX347 2.00.00.023 } /*** "010023" 07/10/2024 16:59:56 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bocx347 MUT}
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
&GLOBAL-DEFINE DBOName            BOCX347
&GLOBAL-DEFINE DBOVersion         
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName          reg-export
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName          qr{&TableName} 

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
{cxbo/bocx347.i RowObject}

{cdp/cdcfgdis.i}

DEFINE TEMP-TABLE tt-cond-pagto NO-UNDO
     FIELD nr-parcela   AS INTEGER FORMAT ">9" 
     FIELD cod-vencto   AS INTEGER FORMAT  "9"
     FIELD perc-parcela AS DECIMAL FORMAT ">>9.99"
     FIELD val-parcela  AS DECIMAL FORMAT ">>,>>>,>>>,>>9.9999".    

{cxbo/bocx347.i tt-reg-export}                                                    

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}
{utp/ut-glob.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName}     FOR {&TableName}.
DEFINE BUFFER bfreg-export-anexo FOR reg-export-anexo.

DEFINE VARIABLE c-nr-re-ems-ini  LIKE reg-export.nr-re-ems      NO-UNDO.
DEFINE VARIABLE c-nr-re-ems-fin  LIKE reg-export.nr-re-ems      NO-UNDO.
DEFINE VARIABLE c-nr-re-sisc-ini LIKE reg-export.nr-re-siscomex NO-UNDO.
DEFINE VARIABLE c-nr-re-sisc-fin LIKE reg-export.nr-re-siscomex NO-UNDO.
DEFINE VARIABLE c-estab-ini      LIKE reg-export.cod-estabel    NO-UNDO.
DEFINE VARIABLE c-estab-fin      LIKE reg-export.cod-estabel    NO-UNDO.
DEFINE VARIABLE c-proc-exp-ini   LIKE reg-export.nr-proc-exp    NO-UNDO.
DEFINE VARIABLE c-proc-exp-fin   LIKE reg-export.nr-proc-exp    NO-UNDO.
DEFINE VARIABLE c-nr-re-ems      AS   CHARACTER                 NO-UNDO.
DEFINE VARIABLE c-cod-sit-proc   AS CHAR                        NO-UNDO.
DEFINE VARIABLE i-cont           AS INTEGER NO-UNDO.
DEFINE VARIABLE de-perc-parcela  LIKE tt-cond-pagto.perc-parcela NO-UNDO.

DEFINE VARIABLE de-sobra    LIKE tt-cond-pagto.perc-parcela NO-UNDO.
DEFINE VARIABLE de-tot-valor-anexos AS DECIMAL FORMAT ">>>,>>>,>>>,>>9.99" NO-UNDO.
DEFINE VARIABLE de-tot-valor-re     AS DECIMAL FORMAT ">>>,>>>,>>>,>>9.99" NO-UNDO.
DEFINE VARIABLE de-tot-qtd-unid-comerc LIKE reg-export-item.qtd-unid-comerc NO-UNDO.
DEFINE VARIABLE de-tot-qtd-unid-ncm    LIKE reg-export-item.qtd-unid-ncm    NO-UNDO.


DEFINE VARIABLE de-vl-total LIKE tt-cond-pagto.val-parcela NO-UNDO.
DEFINE VARIABLE de-vl-total-acum LIKE de-vl-total NO-UNDO.
DEFINE VARIABLE de-vl-sem-cobertura LIKE tt-cond-pagto.val-parcela NO-UNDO.

DEFINE BUFFER bf-processo-exp-sub FOR processo-exp.

{utp/ut-glob.i}

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
         HEIGHT             = 22.38
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

 IF AVAIL {&TableName} THEN DO:

    RUN atualizaUltAlteracao (INPUT {&TableName}.nr-re-ems).

 end. 
 RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterProxSeq DBOProgram 
PROCEDURE afterProxSeq :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF OUTPUT PARAMETER p-retorn LIKE bf{&TableName}.nr-re-ems NO-UNDO.
                
    FIND LAST bf{&TableName} NO-LOCK NO-ERROR.
    IF NOT AVAIL bf{&TableName} THEN
       ASSIGN p-retorn = 1.
    ELSE ASSIGN p-retorn = bf{&TableName}.nr-re-ems + 1.

    IF p-retorn > 999999999 THEN
       ASSIGN p-retorn = 1.

    RETURN "OK".
         
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

 IF AVAIL {&TableName} THEN DO:

    RUN atualizaUltAlteracao (INPUT {&TableName}.nr-re-ems).

 end. 
 

 RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizarValoresRE DBOProgram 
PROCEDURE atualizarValoresRE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p-nr-re-ems LIKE reg-export.nr-re-ems NO-UNDO.
  DEFINE INPUT PARAMETER p-idi-consid-cfop AS LOGICAL NO-UNDO.

  DEF VAR de-vl-tot-anexos    AS DECIMAL FORMAT ">>>,>>>,>>>,>>9.99":U NO-UNDO.
  DEF VAR de-vl-tot-re        AS DECIMAL FORMAT ">>>,>>>,>>>,>>9.99":U NO-UNDO.
  DEF VAR de-maior-valor      AS DECIMAL FORMAT ">>>,>>>,>>>,>>9.99":U NO-UNDO.
  DEF VAR r-rowid-maior-valor AS ROWID                                 NO-UNDO.

  ASSIGN i-cont = 0.

  FIND FIRST bfreg-export EXCLUSIVE-LOCK 
       WHERE bfreg-export.nr-re-ems = p-nr-re-ems NO-ERROR.

  IF bfreg-export.idi-atualiz-val-pagto = 2 THEN
     RETURN "NOK":U.
              
  FIND FIRST processo-exp NO-LOCK 
       WHERE processo-exp.cod-estabel = bfreg-export.cod-estabel
         AND processo-exp.nr-proc-exp = bfreg-export.nr-proc-exp NO-ERROR.

  IF processo-exp.cod-cond-pagto <> 0 THEN DO:

     FIND FIRST cond-pagto NO-LOCK 
          WHERE cond-pagto.cod-cond-pag = processo-exp.cod-cond-pagto NO-ERROR.
     
     IF AVAIL cond-pagto THEN DO:

        /* condiá∆o de pagamento cadastrada */

        DO i-cont = 1 TO cond-pagto.num-parcelas:

           CREATE tt-cond-pagto.
           ASSIGN tt-cond-pagto.nr-parcela  = i-cont
                  tt-cond-pagto.cod-vencto   = cond-pagto.cod-ven-par[i-cont]
                  tt-cond-pagto.perc-parcela = cond-pagto.per-pg-dup[i-cont].
        END.


     END.

  END.
  ELSE DO:              

      /* condiá∆o de pagamento especial */

      FIND FIRST reg-export-item NO-LOCK 
           WHERE reg-export-item.nr-re-ems = bfreg-export.nr-re-ems NO-ERROR.

      FIND FIRST ped-venda NO-LOCK 
           WHERE ped-venda.nome-abrev = reg-export-item.nome-abrev 
             AND ped-venda.nr-pedcli  = reg-export-item.nr-pedcli NO-ERROR.

      IF NOT CAN-FIND(FIRST cond-ped 
             WHERE cond-ped.nr-pedido = ped-venda.nr-pedido) THEN DO:
          /* Sem cobertura cambial */
          CREATE tt-cond-pagto.
          ASSIGN tt-cond-pagto.nr-parcela = 1 
                 tt-cond-pagto.cod-vencto = 0.
      END.

      FOR EACH cond-ped NO-LOCK 
          WHERE cond-ped.nr-pedido = ped-venda.nr-pedido:

          ASSIGN i-cont = i-cont + 1.

          CREATE tt-cond-pagto.
          ASSIGN tt-cond-pagto.nr-parcela = i-cont 
                 tt-cond-pagto.cod-vencto  = cond-ped.cod-vencto.

          IF cond-ped.perc-pagto <> 0 THEN
             ASSIGN tt-cond-pagto.perc-parcela = cond-ped.perc-pagto.
          ELSE 
             ASSIGN tt-cond-pagto.perc-parcela = (cond-ped.vl-pagto / ped-venda.vl-tot-ped).
      END.

      ASSIGN de-sobra = 0
             de-perc-parcela = 0.

      FOR EACH tt-cond-pagto:
          ASSIGN de-perc-parcela = de-perc-parcela + tt-cond-pagto.perc-parcela.
      END.

      IF de-perc-parcela < 100 THEN
         ASSIGN de-sobra = 100 - de-perc-parcela.

      FOR EACH tt-cond-pagto
          BREAK BY tt-cond-pagto.nr-parcela:
          IF LAST (tt-cond-pagto.nr-parcela) THEN
             ASSIGN tt-cond-pagto.perc-parcela = tt-cond-pagto.perc-parcela + de-sobra.
      END.

  END.

  ASSIGN de-vl-total = 0
         de-vl-total-acum = 0
         de-vl-sem-cobertura = 0.

  FOR EACH reg-export-anexo NO-LOCK
      WHERE reg-export-anexo.nr-re-ems = p-nr-re-ems:
      ASSIGN de-vl-total      = de-vl-total + reg-export-anexo.val-preco-tot[1]
             de-vl-tot-anexos = round(de-vl-tot-anexos + reg-export-anexo.val-preco-tot[1],2).

      IF de-maior-valor = 0 
      OR de-maior-valor < reg-export-anexo.val-preco-tot[1] THEN DO:
          ASSIGN de-maior-valor      = reg-export-anexo.val-preco-tot[1]
                 r-rowid-maior-valor = ROWID(reg-export-anexo).
      END.


      /* Considera CFOP */
      IF p-idi-consid-cfop THEN DO: 
          FOR FIRST reg-export-item FIELDS(nome-abrev nr-pedcli num-seq it-codigo cod-refer) 
               WHERE reg-export-item.nr-re-ems = reg-export-anexo.nr-re-ems
                 AND reg-export-item.cdn-anexo = reg-export-anexo.cdn-anexo NO-LOCK:
          END.
          IF AVAIL reg-export-item THEN DO:
              FOR FIRST ped-item  FIELDS(nat-operacao)
                   WHERE ped-item.nome-abrev   = reg-export-item.nome-abrev
                     AND ped-item.nr-pedcli    = reg-export-item.nr-pedcli
                     AND ped-item.nr-sequencia = reg-export-item.num-seq
                     AND ped-item.it-codigo    = reg-export-item.it-codigo
                     AND ped-item.cod-refer    = reg-export-item.cod-refer NO-LOCK:
              END.
              IF AVAIL ped-item THEN DO:
                 FOR FIRST natur-oper FIELDS(emite-duplic)
                      WHERE natur-oper.nat-operacao = ped-item.nat-operacao NO-LOCK:
                 END.
                 IF AVAIL natur-oper AND 
                      NOT natur-oper.emite-duplic THEN
                    ASSIGN de-vl-sem-cobertura = de-vl-sem-cobertura + reg-export-anexo.val-preco-tot[1].                 
              END.
          END.
      END.
  END.
  IF de-vl-sem-cobertura > 0 THEN
     ASSIGN de-vl-total = de-vl-total - de-vl-sem-cobertura. 

  FOR EACH tt-cond-pagto
      BREAK BY tt-cond-pagto.nr-parcela:

      ASSIGN tt-cond-pagto.val-parcela = (de-vl-total * tt-cond-pagto.perc-parcela) / 100
             de-vl-total-acum = de-vl-total-acum + tt-cond-pagto.val-parcela.

      IF LAST (tt-cond-pagto.nr-parcela) THEN DO:
         IF de-vl-total-acum < de-vl-total THEN
            ASSIGN tt-cond-pagto.val-parcela = tt-cond-pagto.val-parcela + 
                                              (de-vl-total - de-vl-total-acum).
      END.

  END.

  /* Valor sem cobertura cambial */
  ASSIGN bfreg-export.val-sem-cobert-cambio = 0.
  FOR EACH tt-cond-pagto
      WHERE tt-cond-pagto.cod-vencto = 0:
      ASSIGN bfreg-export.val-sem-cobert-cambio = bfreg-export.val-sem-cobert-cambio + 
                                                  tt-cond-pagto.val-parcela.
  END.
  IF bfreg-export.val-sem-cobert-cambio = 0 THEN
     ASSIGN bfreg-export.val-sem-cobert-cambio = de-vl-sem-cobertura.

    /* Valor pagamento antecipado */
  ASSIGN bfreg-export.val-pagto-antec = 0.

  FOR EACH tt-cond-pagto
      WHERE tt-cond-pagto.cod-vencto = 3:
      ASSIGN bfreg-export.val-pagto-antec = bfreg-export.val-pagto-antec + 
                                            tt-cond-pagto.val-parcela.
  END.

  /* Valor pagamento a vista */
  ASSIGN bfreg-export.val-pagto-avista = 0.

  FOR EACH tt-cond-pagto
      WHERE tt-cond-pagto.cod-vencto = 2:
      ASSIGN bfreg-export.val-pagto-avista = bfreg-export.val-pagto-avista + 
                                             tt-cond-pagto.val-parcela.
  END.

  ASSIGN i-cont = 0.

  ASSIGN bfreg-export.val-parcdo = 0.

  FOR EACH tt-cond-pagto:
      IF tt-cond-pagto.cod-vencto = 0 OR
         tt-cond-pagto.cod-vencto = 2 OR
         tt-cond-pagto.cod-vencto = 3 THEN NEXT.

      ASSIGN i-cont = i-cont + 1.

      ASSIGN bfreg-export.val-parcdo = bfreg-export.val-parcdo + 
                                       tt-cond-pagto.val-parcela
             bfreg-export.num-parcelas = i-cont.
  END.
 
  /*Acerto de Res°duo*/
  ASSIGN de-vl-tot-re = round(bfreg-export.val-pagto-antec       + 
                              bfreg-export.val-pagto-avista      + 
                              bfreg-export.val-parcdo            + 
                              bfreg-export.val-margem-nao-sacad  + 
                              bfreg-export.val-consig            + 
                              bfreg-export.val-sem-cobert-cambio + 
                              bfreg-export.val-financto-reg-cr,2).

  IF de-vl-tot-anexos <> de-vl-tot-re THEN DO:
      FOR FIRST bfreg-export-anexo FIELDS(val-preco-tot[1])
          WHERE ROWID(bfreg-export-anexo) = r-rowid-maior-valor EXCLUSIVE-LOCK:
      END.

      IF AVAIL bfreg-export-anexo  THEN DO:
          ASSIGN bfreg-export-anexo.val-preco-tot[1] = bfreg-export-anexo.val-preco-tot[1] + (de-vl-tot-re - de-vl-tot-anexos).
      END.
  END.

  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaUltAlteracao DBOProgram 
PROCEDURE atualizaUltAlteracao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  DEFINE INPUT PARAMETER pNr-Re-Ems LIKE {&TableName}.nr-re-ems NO-UNDO.                       
                         
  def var c-usuario AS CHAR NO-UNDO.
  DEFINE VARIABLE c-hora AS CHAR NO-UNDO.

  ASSIGN c-hora = STRING(TIME,"HH:MM").

  {method/svc/autentic/autentic.i
          &vUserName="c-usuario"}

  FIND FIRST bf{&TableName} EXCLUSIVE-LOCK
       WHERE bf{&TableName}.nr-re-ems = pNr-Re-Ems NO-ERROR.
  IF AVAIL bf{&TableName} THEN DO:
      assign bf{&TableName}.cod-usuar-ult-alter = c-usuario
             bf{&TableName}.hra-ult-alter = substring(c-hora,1,2) + substring(c-hora,4,2)
             bf{&TableName}.dat-ult-alter = today.
  END.

  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BeforeDeleteRecord DBOProgram 
PROCEDURE BeforeDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 IF AVAIL rowObject THEN DO:
    FOR EACH reg-export-item EXCLUSIVE-LOCK 
        OF  rowObject:
        DELETE reg-export-item.
    END.
    FOR EACH reg-export-anexo EXCLUSIVE-LOCK 
        OF  rowObject:
        DELETE reg-export-anexo.
    END.
    FOR EACH reg-export-fabrican EXCLUSIVE-LOCK
        OF  rowObject:
        DELETE reg-export-fabrican.
    END.
 end. 
 
 RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCalculoPrecos DBOProgram 
PROCEDURE getCalculoPrecos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-nr-re-ems LIKE reg-export.nr-re-ems NO-UNDO.
    DEFINE OUTPUT PARAMETER de-preco-cond   LIKE reg-export-anexo.val-preco-tot[1] NO-UNDO.
    DEFINE OUTPUT PARAMETER de-preco-emb    LIKE reg-export-anexo.val-preco-tot[1] NO-UNDO.

    ASSIGN de-preco-cond = 0
           de-preco-emb  = 0.

    FOR EACH reg-export-anexo NO-LOCK
       WHERE reg-export-anexo.nr-re-ems = p-nr-re-ems:

        ASSIGN de-preco-cond = round(de-preco-cond + reg-export-anexo.val-preco-tot[1],2)
               de-preco-emb  = round(de-preco-emb  + reg-export-anexo.val-preco-tot[2],2).
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
        WHEN "cod-comprov-export":U THEN ASSIGN pFieldValue = RowObject.cod-comprov-export.
        WHEN "cod-docto-export-vincul":U THEN ASSIGN pFieldValue = RowObject.cod-docto-export-vincul.
        WHEN "cod-docto-import-vincul":U THEN ASSIGN pFieldValue = RowObject.cod-docto-import-vincul.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-incoterm":U THEN ASSIGN pFieldValue = RowObject.cod-incoterm.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-pais-dest-final":U THEN ASSIGN pFieldValue = RowObject.cod-pais-dest-final.
        WHEN "cod-pais-imptdor":U THEN ASSIGN pFieldValue = RowObject.cod-pais-imptdor.
        WHEN "cod-proces":U THEN ASSIGN pFieldValue = RowObject.cod-proces.
        WHEN "cod-reg-operac-cr":U THEN ASSIGN pFieldValue = RowObject.cod-reg-operac-cr.
        WHEN "cod-reg-vda":U THEN ASSIGN pFieldValue = RowObject.cod-reg-vda.
        WHEN "cod-solicit-despa":U THEN ASSIGN pFieldValue = RowObject.cod-solicit-despa.
        WHEN "cod-usuar-ult-alter":U THEN ASSIGN pFieldValue = RowObject.cod-usuar-ult-alter.
        WHEN "des-ender-imptdor":U THEN ASSIGN pFieldValue = RowObject.des-ender-imptdor.
        WHEN "des-narrat":U THEN ASSIGN pFieldValue = RowObject.des-narrat.
        WHEN "hra-ult-alter":U THEN ASSIGN pFieldValue = RowObject.hra-ult-alter.
        WHEN "nr-ato-consessorio":U THEN ASSIGN pFieldValue = RowObject.nr-ato-consessorio.
        WHEN "nr-proc-exp":U THEN ASSIGN pFieldValue = RowObject.nr-proc-exp.
        WHEN "nr-re-siscomex":U THEN ASSIGN pFieldValue = RowObject.nr-re-siscomex.
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
        WHEN "dat-comprov-export":U THEN ASSIGN pFieldValue = RowObject.dat-comprov-export.
        WHEN "dat-envio":U THEN ASSIGN pFieldValue = RowObject.dat-envio.
        WHEN "dat-lim-operac":U THEN ASSIGN pFieldValue = RowObject.dat-lim-operac.
        WHEN "dat-livre-1":U THEN ASSIGN pFieldValue = RowObject.dat-livre-1.
        WHEN "dat-livre-2":U THEN ASSIGN pFieldValue = RowObject.dat-livre-2.
        WHEN "dat-reg-export":U THEN ASSIGN pFieldValue = RowObject.dat-reg-export.
        WHEN "dat-reg-operac-cr":U THEN ASSIGN pFieldValue = RowObject.dat-reg-operac-cr.
        WHEN "dat-reg-vda":U THEN ASSIGN pFieldValue = RowObject.dat-reg-vda.
        WHEN "dat-solicit-despa":U THEN ASSIGN pFieldValue = RowObject.dat-solicit-despa.
        WHEN "dat-ult-alter":U THEN ASSIGN pFieldValue = RowObject.dat-ult-alter.
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
        WHEN "val-consig":U THEN ASSIGN pFieldValue = RowObject.val-consig.
        WHEN "val-financto-reg-cr":U THEN ASSIGN pFieldValue = RowObject.val-financto-reg-cr.
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
        WHEN "val-margem-nao-sacad":U THEN ASSIGN pFieldValue = RowObject.val-margem-nao-sacad.
        WHEN "val-pagto-avista":U THEN ASSIGN pFieldValue = RowObject.val-pagto-avista.
        WHEN "val-parcdo":U THEN ASSIGN pFieldValue = RowObject.val-parcdo.
        WHEN "val-perc-margem-nao-sacad":U THEN ASSIGN pFieldValue = RowObject.val-perc-margem-nao-sacad.
        WHEN "val-sem-cobert-cambio":U THEN ASSIGN pFieldValue = RowObject.val-sem-cobert-cambio.
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
        WHEN "cdn-instrum-negociac":U THEN ASSIGN pFieldValue = RowObject.cdn-instrum-negociac.
        WHEN "cdn-modalid-trans":U THEN ASSIGN pFieldValue = RowObject.cdn-modalid-trans.
        WHEN "cdn-unid-referenc-despch":U THEN ASSIGN pFieldValue = RowObject.cdn-unid-referenc-despch.
        WHEN "cdn-unid-referenc-embarq":U THEN ASSIGN pFieldValue = RowObject.cdn-unid-referenc-embarq.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "idi-atualiz-val-pagto":U THEN ASSIGN pFieldValue = RowObject.idi-atualiz-val-pagto.
        WHEN "idi-periodo":U THEN ASSIGN pFieldValue = RowObject.idi-periodo.
        WHEN "idi-sit-reg-export":U THEN ASSIGN pFieldValue = RowObject.idi-sit-reg-export.
        WHEN "mo-codigo":U THEN ASSIGN pFieldValue = RowObject.mo-codigo.
        WHEN "nr-re-ems":U THEN ASSIGN pFieldValue = RowObject.nr-re-ems.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "num-parcelas":U THEN ASSIGN pFieldValue = RowObject.num-parcelas.
        WHEN "num-periodic":U THEN ASSIGN pFieldValue = RowObject.num-periodic.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice rgxprt-id
  Parameters:  
               retorna valor do campo nr-re-ems
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnr-re-ems LIKE reg-export.nr-re-ems NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnr-re-ems = RowObject.nr-re-ems.

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
  Purpose:     Reposiciona registro com base no °ndice rgxprt-id
  Parameters:  
               recebe valor do campo nr-re-ems
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-re-ems LIKE reg-export.nr-re-ems NO-UNDO.

    FIND FIRST bfreg-export WHERE 
        bfreg-export.nr-re-ems = pnr-re-ems NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfreg-export THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfreg-export)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryByNrReEms DBOProgram 
PROCEDURE OpenQueryByNrReEms :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QUERYNAME} for each {&TableName} NO-LOCK
         WHERE {&TableName}.nr-re-ems >= c-nr-re-ems-ini 
           AND {&TableName}.nr-re-ems <= c-nr-re-ems-fin
            BY {&TableName}.nr-re-ems.

    RETURN "OK":U.        

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryByNrReSiscomex DBOProgram 
PROCEDURE OpenQueryByNrReSiscomex :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QUERYNAME} for each {&TableName} NO-LOCK
         WHERE {&TableName}.nr-re-siscomex >= c-nr-re-sisc-ini 
           AND {&TableName}.nr-re-siscomex <= c-nr-re-sisc-fin
            BY {&TableName}.nr-re-siscomex 
            BY {&TableName}.nr-re-ems.

    RETURN "OK":U.        

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryByProcesso DBOProgram 
PROCEDURE OpenQueryByProcesso :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QUERYNAME} for each {&TableName} NO-LOCK
         WHERE {&TableName}.cod-estabel >= c-estab-ini 
           AND {&TableName}.cod-estabel <= c-estab-fin
           AND {&TableName}.nr-proc-exp >= c-proc-exp-ini
           AND {&TableName}.nr-proc-exp <= c-proc-exp-fin
            BY {&TableName}.cod-estabel
            BY {&TableName}.nr-proc-exp
            BY {&TableName}.nr-re-ems.

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
    OPEN QUERY {&QUERYNAME} for each {&TableName} NO-LOCK.

    RETURN "OK":U.        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-moeda DBOProgram 
PROCEDURE pi-busca-moeda :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAM p-cod-estabel LIKE {&TableName}.cod-estabel.
DEFINE INPUT  PARAM p-nr-proc-exp LIKE {&TableName}.nr-proc-exp.
DEFINE OUTPUT PARAM p-mo-codigo   LIKE {&TableName}.mo-codigo.

FIND FIRST proc-ped-venda NO-LOCK
     WHERE proc-ped-venda.cod-estabel = p-cod-estabel
       AND proc-ped-venda.nr-proc-exp = p-nr-proc-exp NO-ERROR.
IF AVAIL proc-ped-venda THEN DO:
    FIND FIRST ped-venda NO-LOCK
         WHERE ped-venda.nr-pedido = proc-ped-venda.nr-pedido NO-ERROR.
    IF AVAIL ped-venda THEN
        ASSIGN p-mo-codigo = ped-venda.mo-codigo.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-buscaPeriodicidade DBOProgram 
PROCEDURE pi-buscaPeriodicidade :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER  pc-cod-estabel   LIKE processo-exp.cod-estabel  NO-UNDO.
    DEFINE INPUT PARAMETER  pc-nr-proc-exp   LIKE processo-exp.nr-proc-exp  NO-UNDO.
    DEFINE OUTPUT PARAMETER pi-periodicidade LIKE reg-export.num-periodic   NO-UNDO.

    DEFINE VARIABLE i-ind AS INTEGER    NO-UNDO.

    FIND FIRST processo-exp
         WHERE processo-exp.cod-estabel = pc-cod-estabel
           AND processo-exp.nr-proc-exp = pc-nr-proc-exp NO-LOCK NO-ERROR.

    IF AVAIL processo-exp THEN DO:
        FIND FIRST cond-pagto
             WHERE cond-pagto.cod-cond-pag = processo-exp.cod-cond-pagto NO-LOCK NO-ERROR.
        IF  AVAIL cond-pagto
        AND cond-pagto.cod-vencto <> 2 /* A vista */
        AND cond-pagto.cod-vencto <> 3 /* Antecipado */
        AND cond-pagto.cod-vencto <> 4 /*Contra Entrega*/ THEN DO:

            DO i-ind = 1 TO cond-pagto.num-parcelas:
                ASSIGN pi-periodicidade = cond-pagto.prazos[i-ind].
            END.
        END.
        ELSE
            ASSIGN pi-periodicidade = 0.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByNrReEms DBOProgram 
PROCEDURE setConstraintByNrReEms :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
      
      
      DEFINE INPUT PARAMETER p-nr-re-ems-ini LIKE reg-export.nr-re-ems NO-UNDO.
      DEFINE INPUT PARAMETER p-nr-re-ems-fin LIKE reg-export.nr-re-ems NO-UNDO.

      ASSIGN c-nr-re-ems-ini = p-nr-re-ems-ini
             c-nr-re-ems-fin = p-nr-re-ems-fin.

      RETURN "OK".


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByNrReSiscomex DBOProgram 
PROCEDURE setConstraintByNrReSiscomex :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


      DEFINE INPUT PARAMETER p-nr-re-sisc-ini LIKE reg-export.nr-re-siscomex NO-UNDO.
      DEFINE INPUT PARAMETER p-nr-re-sisc-fin LIKE reg-export.nr-re-siscomex NO-UNDO.

      ASSIGN c-nr-re-sisc-ini = p-nr-re-sisc-ini
             c-nr-re-sisc-fin = p-nr-re-sisc-fin.

      RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByProcesso DBOProgram 
PROCEDURE setConstraintByProcesso :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


      DEFINE INPUT PARAMETER p-cod-estab-ini LIKE reg-export.cod-estab NO-UNDO.
      DEFINE INPUT PARAMETER p-cod-estab-fin LIKE reg-export.cod-estab NO-UNDO.
      DEFINE INPUT PARAMETER p-nr-proc-ini   LIKE reg-export.nr-proc-exp NO-UNDO.
      DEFINE INPUT PARAMETER p-nr-proc-fin   LIKE reg-export.nr-proc-exp NO-UNDO.


      ASSIGN c-estab-ini = p-cod-estab-ini
             c-estab-fin = p-cod-estab-fin
             c-proc-exp-ini = p-nr-proc-ini
             c-proc-exp-fin = p-nr-proc-fin.

      RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validacaoNumeroRE DBOProgram 
PROCEDURE validacaoNumeroRE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pnr-re LIKE reg-export.nr-re-ems NO-UNDO.
  
  FIND FIRST bf{&TableName} NO-LOCK 
       WHERE bf{&TableName}.nr-re-ems = pnr-re NO-ERROR.
  IF AVAIL bf{&TableName} THEN DO:
     /* Inicio -- Projeto Internacional */
     DEFINE VARIABLE c-lbl-liter-outros AS CHARACTER NO-UNDO.
     {utp/ut-liter.i "OUTROS" *}
     ASSIGN c-lbl-liter-outros = TRIM(RETURN-VALUE).
     DEFINE VARIABLE c-lbl-liter-registro-exportacao AS CHARACTER NO-UNDO.
     {utp/ut-liter.i "Registro_Exportaá∆o" *}
     ASSIGN c-lbl-liter-registro-exportacao = TRIM(RETURN-VALUE).
     {method/svc/errors/inserr.i
                          &ErrorNumber="8"
                          &ErrorType=c-lbl-liter-outros
                          &ErrorSubType="ERROR"
                          &ErrorParameters="c-lbl-liter-registro-exportacao"}
                          
      RETURN "NOK":U.
  END.
  
  
  
  RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validacoesAdicionais DBOProgram 
PROCEDURE validacoesAdicionais :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-i-origem AS INTEGER NO-UNDO.

    IF AVAIL rowObject THEN DO:

       IF p-i-origem = 1 THEN DO:

          /* n£mero do processo de exportaá∆o */
          ASSIGN c-nr-re-ems = "".
          FOR EACH bf{&TableName} NO-LOCK 
             WHERE bf{&TableName}.cod-estabel = rowobject.cod-estabel 
               AND bf{&TableName}.nr-proc-exp = rowobject.nr-proc-exp
               AND bf{&TableName}.nr-re-ems  <> rowobject.nr-re-ems :

             IF c-nr-re-ems = ""  THEN
                ASSIGN c-nr-re-ems = string(bf{&TableName}.nr-re-ems) + ",".
             ELSE ASSIGN c-nr-re-ems = c-nr-re-ems + string(bf{&TableName}.nr-re-ems) + ",".

          END.
          IF c-nr-re-ems <> "" THEN DO:
              {method/svc/errors/inserr.i
                     &ErrorNumber="30498"
                     &ErrorType="EMS"
                     &ErrorSubType="INFORMATION"
                     &ErrorParameters="rowobject.cod-estabel + '~~~~' + rowobject.nr-proc-exp + '~~~~' + STRING(rowobject.nr-re-ems) + '~~~~' + c-nr-re-ems"}
          END.
          /* *************************************************************************  */

       END.
       ELSE DO:
           FIND FIRST reg-export-item NO-LOCK 
                WHERE reg-export-item.nr-re-ems = rowObject.nr-re-ems NO-ERROR.
           IF  NOT AVAIL reg-export-item THEN DO:
               {method/svc/errors/inserr.i
                      &ErrorNumber="31819"
                      &ErrorType="EMS"
                      &ErrorSubType="ERROR"
                      &ErrorParameters="''"}
           END.

           FIND FIRST reg-export-item NO-LOCK 
                WHERE reg-export-item.nr-re-ems = rowObject.nr-re-ems 
                  AND reg-export-item.cdn-anexo = 0 NO-ERROR.
           IF  AVAIL reg-export-item THEN DO:
               {method/svc/errors/inserr.i
                      &ErrorNumber="30504"
                      &ErrorType="EMS"
                      &ErrorSubType="ERROR"
                      &ErrorParameters="''"}
           END.
       END.

       FIND FIRST reg-export-anexo NO-LOCK 
            WHERE reg-export-anexo.nr-re-ems = rowobject.nr-re-ems NO-ERROR.
       IF AVAIL reg-export-anexo THEN DO:

           /* Valores do RE x Valores dos Anexos */
           ASSIGN de-tot-valor-anexos = 0 
                  de-tot-valor-re     = 0.

           FOR EACH reg-export-anexo NO-LOCK 
               WHERE reg-export-anexo.nr-re-ems = rowobject.nr-re-ems:
               ASSIGN de-tot-valor-anexos = round(de-tot-valor-anexos + reg-export-anexo.val-preco-tot[1],2).
           END.

           ASSIGN de-tot-valor-re = round(rowobject.val-pagto-antec + 
                                    rowobject.val-pagto-avista + 
                                    rowobject.val-parcdo + 
                                    rowobject.val-margem-nao-sacad + 
                                    rowobject.val-consig + 
                                    rowobject.val-sem-cobert-cambio + 
                                    rowobject.val-financto-reg-cr,2).

           IF de-tot-valor-anexos <> de-tot-valor-re THEN DO:
              IF p-i-origem = 1 THEN DO:
                  {method/svc/errors/inserr.i
                         &ErrorNumber="30499"
                         &ErrorType="EMS"
                         &ErrorSubType="INFORMATION"
                         &ErrorParameters="string(de-tot-valor-re) + '~~~~' + string(de-tot-valor-anexos)"}
              END.
              ELSE DO:
                  {method/svc/errors/inserr.i
                         &ErrorNumber="30500"
                         &ErrorType="EMS"
                         &ErrorSubType="ERROR"
                         &ErrorParameters="string(de-tot-valor-re) + '~~~~' + string(de-tot-valor-anexos)"}
              END.
           END.

           /* Quantidade do item do RE x Quantidade dos Anexos */
           FOR EACH reg-export-anexo NO-LOCK 
               WHERE reg-export-anexo.nr-re-ems = rowobject.nr-re-ems:
               ASSIGN de-tot-qtd-unid-comerc = 0 
                      de-tot-qtd-unid-ncm    = 0.
               FOR EACH reg-export-item NO-LOCK 
                   WHERE reg-export-item.nr-re-ems = reg-export-anexo.nr-re-ems 
                     AND reg-export-item.cdn-anexo = reg-export-anexo.cdn-anexo:
                   ASSIGN de-tot-qtd-unid-comerc = de-tot-qtd-unid-comerc + 
                                                   reg-export-item.qtd-unid-comerc
                          de-tot-qtd-unid-ncm    = de-tot-qtd-unid-ncm +
                                                   reg-export-item.qtd-unid-ncm.
               END.
               IF de-tot-qtd-unid-comerc <> reg-export-anexo.qtd-unid-comerc THEN DO:
                   IF p-i-origem = 1 THEN DO:
                       /* Inicio -- Projeto Internacional */
                       DEFINE VARIABLE c-lbl-liter-de-comercializacao AS CHARACTER NO-UNDO.
                       {utp/ut-liter.i "de_comercializaá∆o" *}
                       ASSIGN c-lbl-liter-de-comercializacao = TRIM(RETURN-VALUE).
                       {method/svc/errors/inserr.i
                              &ErrorNumber="30502"
                              &ErrorType="EMS"
                              &ErrorSubType="INFORMATION"
                              &ErrorParameters="c-lbl-liter-de-comercializacao + '~~~~' + string(reg-export-anexo.cdn-anexo) + '~~~~' + string(reg-export-anexo.qtd-unid-comerc) + '~~~~' + string(de-tot-qtd-unid-comerc)"}
                   END.
                   ELSE DO:
                       /* Inicio -- Projeto Internacional */
                       DEFINE VARIABLE c-lbl-liter-de-comercializacao-2 AS CHARACTER NO-UNDO.
                       {utp/ut-liter.i "de_comercializaá∆o" *}
                       ASSIGN c-lbl-liter-de-comercializacao-2 = TRIM(RETURN-VALUE).
                       {method/svc/errors/inserr.i
                              &ErrorNumber="30503"
                              &ErrorType="EMS"
                              &ErrorSubType="ERROR"
                              &ErrorParameters="c-lbl-liter-de-comercializacao-2 + '~~~~' + string(reg-export-anexo.cdn-anexo) + '~~~~' + string(reg-export-anexo.qtd-unid-comerc) + '~~~~' + string(de-tot-qtd-unid-comerc)"}
                   END.
               END.
               IF de-tot-qtd-unid-ncm <> reg-export-anexo.qtd-unid-ncm THEN DO:
                   IF p-i-origem = 1 THEN DO:
                       /* Inicio -- Projeto Internacional */
                       DEFINE VARIABLE c-lbl-liter-da-ncm AS CHARACTER NO-UNDO.
                       {utp/ut-liter.i "da_NCM" *}
                       ASSIGN c-lbl-liter-da-ncm = TRIM(RETURN-VALUE).
                       {method/svc/errors/inserr.i
                              &ErrorNumber="30502"
                              &ErrorType="EMS"
                              &ErrorSubType="INFORMATION"
                              &ErrorParameters="c-lbl-liter-da-ncm + '~~~~' + string(reg-export-anexo.cdn-anexo) + '~~~~' + string(reg-export-anexo.qtd-unid-ncm) + '~~~~' + string(de-tot-qtd-unid-ncm)"}
                   END.
                   ELSE DO:
                       /* Inicio -- Projeto Internacional */
                       DEFINE VARIABLE c-lbl-liter-da-ncm-2 AS CHARACTER NO-UNDO.
                       {utp/ut-liter.i "da_NCM" *}
                       ASSIGN c-lbl-liter-da-ncm-2 = TRIM(RETURN-VALUE).
                       {method/svc/errors/inserr.i
                              &ErrorNumber="30503"
                              &ErrorType="EMS"
                              &ErrorSubType="ERROR"
                              &ErrorParameters="c-lbl-liter-da-ncm-2 + '~~~~' + string(reg-export-anexo.cdn-anexo) + '~~~~' + string(reg-export-anexo.qtd-unid-ncm) + '~~~~' + string(de-tot-qtd-unid-ncm)"}
                   END.
               END.
           END.

       END.
    
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

    IF pType = "Create":U THEN DO: 

       FIND FIRST  bf{&TableName} NO-LOCK 
            WHERE  bf{&TableName}.nr-re-ems = rowobject.nr-re-ems NO-ERROR.

       IF AVAIL  bf{&TableName} THEN DO:
           /* Inicio -- Projeto Internacional */
           DEFINE VARIABLE c-lbl-liter-re-ems AS CHARACTER NO-UNDO.
           {utp/ut-liter.i "RE_EMS" *}
           ASSIGN c-lbl-liter-re-ems = TRIM(RETURN-VALUE).
           {method/svc/errors/inserr.i
                  &ErrorNumber="8"
                  &ErrorType="EMS"
                  &ErrorSubType="ERROR"
                  &ErrorParameters="c-lbl-liter-re-ems"}
       END.


    END.

    IF pType = "Create":U OR 
       pType = "Update":U THEN DO:

       IF rowobject.cod-estabel = "" THEN DO:
           /* Inicio -- Projeto Internacional */
           DEFINE VARIABLE c-lbl-liter-estabelecimento AS CHARACTER NO-UNDO.
           {utp/ut-liter.i "Estabelecimento" *}
           ASSIGN c-lbl-liter-estabelecimento = TRIM(RETURN-VALUE).
           {method/svc/errors/inserr.i
                  &ErrorNumber="688"
                  &ErrorType="EMS"
                  &ErrorSubType="ERROR"
                  &ErrorParameters="c-lbl-liter-estabelecimento"}
       END.

       IF NOT CAN-FIND (FIRST estabelec NO-LOCK 
                        WHERE estabelec.cod-estabel = rowobject.cod-estabel) THEN DO:
           /* Inicio -- Projeto Internacional */
           DEFINE VARIABLE c-lbl-liter-estabelecimento-2 AS CHARACTER NO-UNDO.
           {utp/ut-liter.i "Estabelecimento" *}
           ASSIGN c-lbl-liter-estabelecimento-2 = TRIM(RETURN-VALUE).
           {method/svc/errors/inserr.i
                  &ErrorNumber="2"
                  &ErrorType="EMS"
                  &ErrorSubType="ERROR"
                  &ErrorParameters="c-lbl-liter-estabelecimento-2"}
       END.

       IF rowobject.nr-proc-exp = "" THEN DO:
           /* Inicio -- Projeto Internacional */
           DEFINE VARIABLE c-lbl-liter-numero-processo-exportacao AS CHARACTER NO-UNDO.
           {utp/ut-liter.i "N£mero_Processo_Exportaá∆o" *}
           ASSIGN c-lbl-liter-numero-processo-exportacao = TRIM(RETURN-VALUE).
           {method/svc/errors/inserr.i
                  &ErrorNumber="688"
                  &ErrorType="EMS"
                  &ErrorSubType="ERROR"
                  &ErrorParameters="c-lbl-liter-numero-processo-exportacao"}
       END.

       FIND FIRST processo-exp NO-LOCK 
            WHERE processo-exp.cod-estabel = rowobject.cod-estabel 
              AND processo-exp.nr-proc-exp = rowobject.nr-proc-exp NO-ERROR.
       IF AVAIL processo-exp THEN DO:
          IF processo-exp.cod-sit-proc = 5 OR
             processo-exp.cod-sit-proc = 6 THEN DO:
              ASSIGN c-cod-sit-proc = {cxinc/i02cx185.i 04 processo-exp.cod-sit-proc}.
              {method/svc/errors/inserr.i
                     &ErrorNumber="30548"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="string(c-cod-sit-proc)"}
          END.
       END.
       ELSE DO:
           /* Inicio -- Projeto Internacional */
           DEFINE VARIABLE c-lbl-liter-processo-exportacao AS CHARACTER NO-UNDO.
           {utp/ut-liter.i "Processo_Exportaá∆o" *}
           ASSIGN c-lbl-liter-processo-exportacao = TRIM(RETURN-VALUE).
           {method/svc/errors/inserr.i
                  &ErrorNumber="2"
                  &ErrorType="EMS"
                  &ErrorSubType="ERROR"
                  &ErrorParameters="c-lbl-liter-processo-exportacao"}
       END.

       IF rowobject.nr-re-siscomex <> "" THEN DO:
          FIND FIRST bf{&TableName} NO-LOCK
               WHERE bf{&TableName}.nr-re-siscomex = rowobject.nr-re-siscomex
                 AND bf{&TableName}.nr-re-ems <> rowobject.nr-re-ems NO-ERROR.
          IF AVAIL bf{&TableName} THEN DO:
              {method/svc/errors/inserr.i
                     &ErrorNumber="30496"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="string(rowobject.nr-re-siscomex) + '~~~~' + string(bf{&TableName}.nr-re-ems)"}
          END.
          IF rowobject.dat-reg-export = ? THEN DO:
              {method/svc/errors/inserr.i
                     &ErrorNumber="30497"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="''"}
          END.
       END.
       
       IF rowobject.cod-enquad[1] <> 0 THEN DO:
          IF NOT CAN-FIND (FIRST enquad-oper
                           WHERE enquad-oper.cod-enquad = rowobject.cod-enquad[1]) THEN DO:
              /* Inicio -- Projeto Internacional */
              DEFINE VARIABLE c-lbl-liter-codigo-enquadramento-operacao AS CHARACTER NO-UNDO.
              {utp/ut-liter.i "C¢digo_Enquadramento_Operaá∆o" *}
              ASSIGN c-lbl-liter-codigo-enquadramento-operacao = TRIM(RETURN-VALUE).
              {method/svc/errors/inserr.i
                     &ErrorNumber="2"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="c-lbl-liter-codigo-enquadramento-operacao"}
          END.
       END.
       IF rowobject.cod-enquad[2] <> 0 THEN DO:
          IF NOT CAN-FIND (FIRST enquad-oper
                           WHERE enquad-oper.cod-enquad = rowobject.cod-enquad[2]) THEN DO:
              /* Inicio -- Projeto Internacional */
              DEFINE VARIABLE c-lbl-liter-codigo-enquadramento-operacao-2 AS CHARACTER NO-UNDO.
              {utp/ut-liter.i "C¢digo_Enquadramento_Operaá∆o" *}
              ASSIGN c-lbl-liter-codigo-enquadramento-operacao-2 = TRIM(RETURN-VALUE).
              {method/svc/errors/inserr.i
                     &ErrorNumber="2"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="c-lbl-liter-codigo-enquadramento-operacao-2"}
          END.
       END.
       IF rowobject.cod-enquad[3] <> 0 THEN DO:
          IF NOT CAN-FIND (FIRST enquad-oper
                           WHERE enquad-oper.cod-enquad = rowobject.cod-enquad[3]) THEN DO:
              /* Inicio -- Projeto Internacional */
              DEFINE VARIABLE c-lbl-liter-codigo-enquadramento-operacao-3 AS CHARACTER NO-UNDO.
              {utp/ut-liter.i "C¢digo_Enquadramento_Operaá∆o" *}
              ASSIGN c-lbl-liter-codigo-enquadramento-operacao-3 = TRIM(RETURN-VALUE).
              {method/svc/errors/inserr.i
                     &ErrorNumber="2"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="c-lbl-liter-codigo-enquadramento-operacao-3"}
          END.
       END.
       IF rowobject.cod-enquad[4] <> 0 THEN DO:
          IF NOT CAN-FIND (FIRST enquad-oper
                           WHERE enquad-oper.cod-enquad = rowobject.cod-enquad[4]) THEN DO:
              /* Inicio -- Projeto Internacional */
              DEFINE VARIABLE c-lbl-liter-codigo-enquadramento-operacao-4 AS CHARACTER NO-UNDO.
              {utp/ut-liter.i "C¢digo_Enquadramento_Operaá∆o" *}
              ASSIGN c-lbl-liter-codigo-enquadramento-operacao-4 = TRIM(RETURN-VALUE).
              {method/svc/errors/inserr.i
                     &ErrorNumber="2"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="c-lbl-liter-codigo-enquadramento-operacao-4"}
          END.
       END.
       IF rowobject.cod-enquad[5] <> 0 THEN DO:
          IF NOT CAN-FIND (FIRST enquad-oper
                           WHERE enquad-oper.cod-enquad = rowobject.cod-enquad[5]) THEN DO:
              /* Inicio -- Projeto Internacional */
              DEFINE VARIABLE c-lbl-liter-codigo-enquadramento-operacao-5 AS CHARACTER NO-UNDO.
              {utp/ut-liter.i "C¢digo_Enquadramento_Operaá∆o" *}
              ASSIGN c-lbl-liter-codigo-enquadramento-operacao-5 = TRIM(RETURN-VALUE).
              {method/svc/errors/inserr.i
                     &ErrorNumber="2"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="c-lbl-liter-codigo-enquadramento-operacao-5"}
          END.
       END.

       IF NOT CAN-FIND (FIRST INCO-CX NO-LOCK 
                        WHERE inco-cx.cod-incoterm = rowobject.cod-incoterm) THEN DO:
           /* Inicio -- Projeto Internacional */
           DEFINE VARIABLE c-lbl-liter-codigo-condicao-venda-incoterm AS CHARACTER NO-UNDO.
           {utp/ut-liter.i "C¢digo_Condiá∆o_Venda_(INCOTERM)" *}
           ASSIGN c-lbl-liter-codigo-condicao-venda-incoterm = TRIM(RETURN-VALUE).
           {method/svc/errors/inserr.i
                  &ErrorNumber="2"
                  &ErrorType="EMS"
                  &ErrorSubType="ERROR"
                  &ErrorParameters="c-lbl-liter-codigo-condicao-venda-incoterm"}
       END.


       IF NOT CAN-FIND (FIRST mod-transac NO-LOCK 
                        WHERE mod-transac.cod-transac = rowobject.cdn-modalid-trans) THEN DO:
           /* Inicio -- Projeto Internacional */
           DEFINE VARIABLE c-lbl-liter-modalidade-de-transacao AS CHARACTER NO-UNDO.
           {utp/ut-liter.i "Modalidade_de_Transaá∆o" *}
           ASSIGN c-lbl-liter-modalidade-de-transacao = TRIM(RETURN-VALUE).
           {method/svc/errors/inserr.i
                  &ErrorNumber="2"
                  &ErrorType="EMS"
                  &ErrorSubType="ERROR"
                  &ErrorParameters="c-lbl-liter-modalidade-de-transacao"}
       END.


       IF NOT CAN-FIND (FIRST pais NO-LOCK 
                        WHERE &IF "{&bf_dis_versao_ems}" >= "2.06" &THEN
                                  pais.cod-pais-siscomex
                              &ELSE
                                  SUBSTRING(pais.char-1,1,5)
                              &ENDIF = rowobject.cod-pais-imptdor) THEN DO:
           /* Inicio -- Projeto Internacional */
           DEFINE VARIABLE c-lbl-liter-pais AS CHARACTER NO-UNDO.
           {utp/ut-liter.i "Pa°s" *}
           ASSIGN c-lbl-liter-pais = TRIM(RETURN-VALUE).
           {method/svc/errors/inserr.i
                  &ErrorNumber="2"
                  &ErrorType="EMS"
                  &ErrorSubType="ERROR"
                  &ErrorParameters="c-lbl-liter-pais"}
       END.

       IF NOT CAN-FIND (FIRST pais NO-LOCK 
                        WHERE &IF "{&bf_dis_versao_ems}" >= "2.06" &THEN 
                                  pais.cod-pais-siscomex
                              &ELSE
                                  SUBSTRING(pais.char-1,1,5)
                              &ENDIF = rowobject.cod-pais-dest-final) THEN DO:
           /* Inicio -- Projeto Internacional */
           DEFINE VARIABLE c-lbl-liter-pais-destino-final AS CHARACTER NO-UNDO.
           {utp/ut-liter.i "Pa°s_Destino_Final" *}
           ASSIGN c-lbl-liter-pais-destino-final = TRIM(RETURN-VALUE).
           {method/svc/errors/inserr.i
                  &ErrorNumber="2"
                  &ErrorType="EMS"
                  &ErrorSubType="ERROR"
                  &ErrorParameters="c-lbl-liter-pais-destino-final"}
       END.

       IF rowobject.mo-codigo = 0 THEN DO:
           /* Inicio -- Projeto Internacional */
           DEFINE VARIABLE c-lbl-liter-moeda AS CHARACTER NO-UNDO.
           {utp/ut-liter.i "Moeda" *}
           ASSIGN c-lbl-liter-moeda = TRIM(RETURN-VALUE).
           {method/svc/errors/inserr.i
                  &ErrorNumber="25379"
                  &ErrorType="EMS"
                  &ErrorSubType="ERROR"
                  &ErrorParameters="c-lbl-liter-moeda"}
       END.

       RUN validacoesAdicionais (INPUT 1).

    END.

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaDespesasInclusas DBOProgram 
PROCEDURE verificaDespesasInclusas :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT        PARAMETER p-cod-estabel LIKE processo-exp.cod-estabel          NO-UNDO.
    DEFINE INPUT        PARAMETER p-nr-proc-exp LIKE processo-exp.nr-proc-exp          NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER de-preco-cond LIKE reg-export-anexo.val-preco-tot[1] NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER de-preco-emb  LIKE reg-export-anexo.val-preco-tot[1] NO-UNDO.
    
    define var v-despesas like proc-desp-itiner.val-desp no-undo.

    assign v-despesas = 0.

    find first processo-exp no-lock
        where  processo-exp.cod-estabel = p-cod-estabel
        and    processo-exp.nr-proc-exp = p-nr-proc-exp no-error.
    if  avail  processo-exp then do:
        for each  proc-desp-itiner no-lock
            where proc-desp-itiner.cod-estabel   = processo-exp.cod-estabel
            and   proc-desp-itiner.nr-proc-exp   = processo-exp.nr-proc-exp
            and   proc-desp-itiner.cod-itiner    = processo-exp.cod-itiner
            and   proc-desp-itiner.l-forma-preco = yes:

            assign v-despesas = v-despesas + proc-desp-itiner.val-desp.
        end. /* for each  proc-desp-itiner */
    
        &IF  "{&bf_cex_versao_ems}" >= "2.062" &THEN
             &IF  "{&bf_cex_versao_ems}" >= "2.09" &THEN
                  if  processo-exp.log-despes-inclus then do:
             &ELSE
                  if  processo-exp.log-2 then do:
             &ENDIF
                      assign de-preco-cond = de-preco-cond + v-despesas
                             de-preco-emb  = de-preco-emb  + v-despesas.
                  end.
                  else do:
                      assign de-preco-cond = de-preco-cond - v-despesas
                             de-preco-emb  = de-preco-emb  - v-despesas.
                  end.
        &ENDIF
    end. /* if  avail  processo-exp */

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCopiaRegistro DBOProgram 
PROCEDURE piCopiaRegistro :
/*------------------------------------------------------------------------------
     Purpose: Quando n∆o existir RE para o sub-processo, copia registro de 
              exportaá∆o do processo origem para sub-processo    
  Parameters: pr-rowid-proc-orig - Rowid do processo de origem
       Notes: pr-rowid-proc-sub  - Rowid do sub-processo      
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pr-rowid-proc-orig AS ROWID NO-UNDO.
    DEFINE INPUT PARAMETER pr-rowid-proc-sub  AS ROWID NO-UNDO.
   
    DEFINE VARIABLE i-nr-re-ems LIKE reg-export.nr-re-ems NO-UNDO.

    /*Processo Origem*/
    FIND FIRST processo-exp NO-LOCK
         WHERE rowid(processo-exp) = pr-rowid-proc-orig NO-ERROR.
    /*Sub-processo*/
    FIND FIRST bf-processo-exp-sub NO-LOCK
         WHERE ROWID(bf-processo-exp-sub) = pr-rowid-proc-sub NO-ERROR.

    IF AVAIL processo-exp AND AVAIL bf-processo-exp-sub THEN DO:
        IF NOT CAN-FIND( FIRST reg-export 
                         WHERE reg-export.cod-estabel = bf-processo-exp-sub.cod-estabel
                           AND reg-export.nr-proc-exp = bf-processo-exp-sub.nr-proc-exp) THEN DO:
            FOR EACH reg-export
                WHERE reg-export.cod-estabel = processo-exp.cod-estabel
                  AND reg-export.nr-proc-exp = processo-exp.nr-proc-exp NO-LOCK:
                CREATE tt-reg-export.
                BUFFER-COPY reg-export TO tt-reg-export NO-ERROR.
    
                RUN afterProxSeq IN THIS-PROCEDURE (OUTPUT i-nr-re-ems).
    
                ASSIGN tt-reg-export.nr-re-ems             = i-nr-re-ems
                       tt-reg-export.cod-estabel           = bf-processo-exp-sub.cod-estabel
                       tt-reg-export.nr-proc-exp           = bf-processo-exp-sub.nr-proc-exp
                       tt-reg-export.val-pagto-antec       = 0
                       tt-reg-export.val-pagto-avista      = 0
                       tt-reg-export.val-parcdo            = 0
                       tt-reg-export.val-margem-nao-sacad  = 0
                       tt-reg-export.val-consig            = 0
                       tt-reg-export.val-sem-cobert-cambio = 0
                       tt-reg-export.val-financto-reg-cr   = 0
                       tt-reg-export.num-parcelas          = 0
                       tt-reg-export.num-periodic          = 0
                       tt-reg-export.idi-sit-reg-export    = 1 
                       tt-reg-export.dat-envio             = ?         
                       tt-reg-export.nr-re-siscomex        = ""    
                       tt-reg-export.dat-reg-export        = ?.
    
                RUN openQueryStatic IN THIS-PROCEDURE (INPUT "Main":U).           
                RUN emptyRowErrors  IN THIS-PROCEDURE.
                RUN emptyRowObject  IN THIS-PROCEDURE.
                RUN setRecord       IN THIS-PROCEDURE (INPUT TABLE tt-reg-export).
                RUN createRecord    IN THIS-PROCEDURE.
                DELETE tt-reg-export.
            END.
        END.
    END.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piVerificaProcesso DBOProgram 
PROCEDURE piVerificaProcesso :
/*------------------------------------------------------------------------------
     Purpose: Verifica se processo possui RE e se j† foi enviada    
  Parameters: pcod-estabel - C¢digo do estabelecimento
              pnr-proc-exp - N£mero do processo
       Notes:     
------------------------------------------------------------------------------*/
   DEFINE INPUT  PARAM pcod-estabel     LIKE reg-export.cod-estabel NO-UNDO.
   DEFINE INPUT  PARAM pnr-proc-exp     LIKE reg-export.nr-proc-exp NO-UNDO.
  
   IF NOT CAN-FIND(FIRST reg-export
                   WHERE reg-export.cod-estabel = pcod-estabel
                     AND reg-export.nr-proc-exp = pnr-proc-exp) OR
          CAN-FIND(FIRST reg-export
                   WHERE reg-export.cod-estabel = pcod-estabel
                     AND reg-export.nr-proc-exp = pnr-proc-exp
                     AND reg-export.idi-sit-reg-export = 2 /*Enviado*/ ) THEN
      RETURN "NOK":U.

   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
