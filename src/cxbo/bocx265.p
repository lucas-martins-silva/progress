/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOCX265 2.00.00.010}  /*** 010010 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i bocx265 MUT}
&ENDIF

{cdp/cdcfgdis.i} /* Definicao de pre-processadores */
{cdp/cdcfgmat.i}
{utp/ut-glob.i}

&scoped-DEFINE BOVERSION 1.1
&scoped-DEFINE PRVERSION 2.00.00.001
&scoped-DEFINE FIRST-TABLE-IN-QUERY proc-it-nota-fisc
&scoped-DEFINE QUERY-NAME qTable
&scoped-DEFINE TABLE-NAME proc-it-nota-fisc

{include/boini.i}
{cxbo/bocx265.i tt-proc-it-nota-fisc}
{cxbo/bocx265.i rowObject}

DEFINE VARIABLE c-cod-estabel    AS   CHARACTER               NO-UNDO.
DEFINE VARIABLE c-nr-proc-exp    AS   CHARACTER               NO-UNDO.
DEFINE VARIABLE c-serie          AS   CHARACTER               NO-UNDO.
DEFINE VARIABLE c-nr-nota        AS   CHARACTER               NO-UNDO.
DEFINE VARIABLE c-cod-est-proc   LIKE nota-fiscal.cod-estabel NO-UNDO.

DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.

PROCEDURE setConstraint1:

END PROCEDURE.

PROCEDURE setConstraint2:

  DEFINE INPUT PARAMETER p-cod-estabel LIKE proc-nota-fiscal.cod-estabel NO-UNDO. 
  DEFINE INPUT PARAMETER p-nr-proc-exp LIKE proc-nota-fiscal.nr-proc-exp NO-UNDO.
  DEFINE INPUT PARAMETER p-nr-nota-fis LIKE proc-nota-fiscal.nr-nota-fis NO-UNDO. 
  DEFINE INPUT PARAMETER p-serie       LIKE proc-nota-fiscal.serie       NO-UNDO.

  ASSIGN c-cod-estabel = p-cod-estabel
         c-nr-proc-exp = p-nr-proc-exp
         c-nr-nota     = p-nr-nota-fis
         c-serie       = p-serie.

END PROCEDURE.


PROCEDURE setConstraint3:
    DEFINE INPUT PARAMETER r-chave AS ROWID NO-UNDO.
    
    FIND FIRST processo-exp NO-LOCK
         WHERE ROWID(processo-exp) = r-chave NO-ERROR.

END PROCEDURE.


PROCEDURE openQuery:
    DEFINE INPUT PARAMETER i-abertura AS INTEGER NO-UNDO.

    CASE i-abertura:
        WHEN 1 THEN 
            OPEN QUERY {&QUERY-NAME} FOR EACH {&TABLE-NAME} NO-LOCK.
        WHEN 2 THEN 
            OPEN QUERY {&QUERY-NAME} FOR EACH {&TABLE-NAME} 
                                        WHERE {&TABLE-NAME}.cod-estabel = c-cod-estabel 
                                          AND {&TABLE-NAME}.nr-proc-exp = c-nr-proc-exp 
                                          AND {&TABLE-NAME}.nr-nota-fis = c-nr-nota 
                                          AND {&TABLE-NAME}.serie       = c-serie NO-LOCK.
        WHEN 3 THEN 
            OPEN QUERY {&QUERY-NAME} FOR EACH {&TABLE-NAME} OF processo-exp NO-LOCK.
    END CASE.

    ASSIGN l-query    = TRUE
           i-bo-query = i-abertura.

END PROCEDURE.

{include/bostrmet.i}
{include/boendmet.i}
{include/bocomver.i}
{include/bogetver.i}
{include/bonav.i}
{include/bofind.i}
{include/bosetcur.i}
{include/bogetcur.i}
{include/bosersen.i}
{include/boprebro.i}
{include/boexecre.i}
{include/boexeupt.i}
{include/boexedel.i}
{include/bovalupt.i}
{include/bovaldel.i}


PROCEDURE pedVendaSetGlobals:
   /*
   ** Seta as vari·veis globais c-seg-usuario e i-pais-impto-usuario
   ** Pedido de Venda
   */
   DEFINE INPUT PARAMETER c-usuario AS CHARACTER NO-UNDO.
   DEFINE INPUT PARAMETER c-pais    AS CHARACTER NO-UNDO.

   ASSIGN c-seg-usuario        = c-usuario
          i-pais-impto-usuario = INTEGER(c-pais).

END PROCEDURE.


PROCEDURE validateFields:
    /*
    **  Valida Fields
    */
    FIND FIRST rowObject NO-LOCK NO-ERROR.

    RUN startMethod ("validateFields").

    IF  rowObject.cod-estabel = ? THEN DO:
        ASSIGN i-seq-erro = i-seq-erro + 1.
        RUN utp/ut-msgs.p (INPUT "msg":U,
                           INPUT 190,
                           INPUT "").
        CREATE tt-bo-erro.
        ASSIGN tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = RETURN-VALUE.
    END.

    IF  rowObject.cod-refer = ? THEN DO:
        ASSIGN i-seq-erro = i-seq-erro + 1.
        RUN utp/ut-msgs.p (INPUT "msg":U,
                           INPUT 190,
                           INPUT "").
        CREATE tt-bo-erro.
        ASSIGN tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = RETURN-VALUE.
    END.

    IF  rowObject.it-codigo = ? THEN DO:
        ASSIGN i-seq-erro = i-seq-erro + 1.
        RUN utp/ut-msgs.p (INPUT "msg":U,
                           INPUT 190,
                           INPUT "").
        CREATE tt-bo-erro.
        ASSIGN tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = RETURN-VALUE.
    END.

    IF  rowObject.nome-abrev = ?THEN DO:
        ASSIGN i-seq-erro = i-seq-erro + 1.
        RUN utp/ut-msgs.p (INPUT "msg":U,
                           INPUT 190,
                           INPUT "").
        CREATE tt-bo-erro.
        ASSIGN tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = RETURN-VALUE.
    END.

    IF  rowObject.nr-entrega = ?THEN DO:
        ASSIGN i-seq-erro = i-seq-erro + 1.
        RUN utp/ut-msgs.p (INPUT "msg":U,
                           INPUT 190,
                           INPUT "").
        CREATE tt-bo-erro.
        ASSIGN tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = RETURN-VALUE.
    END.

    IF  rowObject.nr-pedcli = ?THEN DO:
        ASSIGN i-seq-erro = i-seq-erro + 1.
        RUN utp/ut-msgs.p (INPUT "msg":U,
                           INPUT 190,
                           INPUT "").
        CREATE tt-bo-erro.
        ASSIGN tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = RETURN-VALUE.
    END.

    IF  rowObject.nr-pedido = ?THEN DO:
        ASSIGN i-seq-erro = i-seq-erro + 1.
        RUN utp/ut-msgs.p (INPUT "msg":U,
                           INPUT 190,
                           INPUT "").
        CREATE tt-bo-erro.
        ASSIGN tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = RETURN-VALUE.
    END.

    IF  rowObject.nr-proc-exp = ?THEN DO:
        ASSIGN i-seq-erro = i-seq-erro + 1.
        RUN utp/ut-msgs.p (INPUT "msg":U,
                           INPUT 190,
                           INPUT "").
        CREATE tt-bo-erro.
        ASSIGN tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = RETURN-VALUE.
    END.

    IF  rowObject.nr-sequencia = ?THEN DO:
        ASSIGN i-seq-erro = i-seq-erro + 1.
        RUN utp/ut-msgs.p (INPUT "msg":U,
                           INPUT 190,
                           INPUT "").
        CREATE tt-bo-erro.
        ASSIGN tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = RETURN-VALUE.
    END.

    RUN endMethod ("validateFields").

END PROCEDURE.

PROCEDURE getCharField:
    DEFINE INPUT  PARAMETER c-field AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER c-value AS CHARACTER NO-UNDO.

    CASE c-field:
        WHEN "char-1"      THEN c-value = RowObject.char-1.
        WHEN "char-2"      THEN c-value = RowObject.char-2.
        WHEN "check-sum"   THEN c-value = RowObject.check-sum.
        WHEN "cod-estabel" THEN c-value = RowObject.cod-estabel.
        WHEN "cod-refer"   THEN c-value = RowObject.cod-refer.
        WHEN "it-codigo"   THEN c-value = RowObject.it-codigo.
        WHEN "nome-abrev"  THEN c-value = RowObject.nome-abrev.
        WHEN "nr-nota-fis" THEN c-value = RowObject.nr-nota-fis.
        WHEN "nr-pedcli"   THEN c-value = RowObject.nr-pedcli.
        WHEN "nr-proc-exp" THEN c-value = RowObject.nr-proc-exp.
        WHEN "serie"       THEN c-value = RowObject.serie.
        OTHERWISE RETURN ERROR.
    END CASE.
END PROCEDURE.

PROCEDURE getDecField:
    DEFINE INPUT  PARAMETER c-field AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER c-value AS DECIMAL   NO-UNDO.

    CASE c-field:
        WHEN "dec-1" THEN c-value = RowObject.dec-1.
        WHEN "dec-2" THEN c-value = RowObject.dec-2.
        OTHERWISE RETURN ERROR.
    END CASE.
END PROCEDURE.

PROCEDURE getIntField:
    DEFINE INPUT  PARAMETER c-field AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER c-value AS INTEGER   NO-UNDO.

    CASE c-field:
        WHEN "int-1"        THEN c-value = RowObject.int-1.
        WHEN "int-2"        THEN c-value = RowObject.int-2.
        WHEN "nr-entrega"   THEN c-value = RowObject.nr-entrega.
        WHEN "nr-pedido"    THEN c-value = RowObject.nr-pedido.
        WHEN "nr-seq-fat"   THEN c-value = RowObject.nr-seq-fat.
        WHEN "nr-sequencia" THEN c-value = RowObject.nr-sequencia.
        OTHERWISE RETURN ERROR.
    END CASE.
END PROCEDURE.

PROCEDURE getDateField:
    DEFINE INPUT  PARAMETER c-field AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER c-value AS DATE      NO-UNDO.

    CASE c-field:
        WHEN "data-1" THEN c-value = RowObject.data-1.
        WHEN "data-2" THEN c-value = RowObject.data-2.
        OTHERWISE RETURN ERROR.
    END CASE.
END PROCEDURE.

PROCEDURE getLogField:
    DEFINE INPUT  PARAMETER c-field AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER c-value AS LOGICAL   NO-UNDO.

    CASE c-field:
        WHEN "log-1" THEN c-value = RowObject.log-1.
        WHEN "log-2" THEN c-value = RowObject.log-2.
        OTHERWISE RETURN ERROR.
    END CASE.
END PROCEDURE.

PROCEDURE initializeValidate:
    /*
    **  Inicializa Validate
    */

    RUN startMethod ("initializeValidade").

    RUN endMethod   ("initializeValidade").
END PROCEDURE.

PROCEDURE criaProcItNota:

    DEFINE INPUT PARAMETER r-rowid AS ROWID NO-UNDO. 

    FIND FIRST it-nota-fisc 
         WHERE ROWID(it-nota-fisc) = r-rowid NO-LOCK NO-ERROR.

    FIND FIRST nota-fiscal OF it-nota-fisc NO-LOCK NO-ERROR.

    &if DEFINEd(bf_dis_proc_ent) &then
        FOR FIRST ped-ent fields (ped-ent.nr-proc-exp)
            WHERE ped-ent.nome-abrev   = it-nota-fisc.nome-ab-cli 
              AND ped-ent.nr-pedcli    = it-nota-fisc.nr-pedcli  
              AND ped-ent.nr-sequencia = it-nota-fisc.nr-seq-ped 
              AND ped-ent.it-codigo    = it-nota-fisc.it-codigo  
              AND ped-ent.cod-refer    = it-nota-fisc.cod-refer  
              AND ped-ent.nr-entrega   = it-nota-fisc.nr-entrega NO-LOCK:
      END. 
      IF AVAIL ped-ent THEN DO: /* se n∆o avail ped-ent n∆o cria proc-it-nota-fisc alteraá∆o feita para a grendene*/
    &endif  
    
        &IF "{&bf_mat_versao_ems}":U <= "2.07":U &THEN
            ASSIGN c-cod-est-proc = SUBSTRING(nota-fiscal.char-1,124,3).
        &ELSE
            ASSIGN c-cod-est-proc = nota-fiscal.cod-estab-proces-export.
        &ENDIF
        FIND FIRST proc-it-nota-fisc NO-LOCK
             WHERE proc-it-nota-fisc.cod-estabel       = c-cod-est-proc        
               AND proc-it-nota-fisc.nr-proc-exp       = nota-fiscal.nr-proc-exp       
               and proc-it-nota-fisc.cod-estab-faturam = nota-fiscal.cod-estabel
               AND proc-it-nota-fisc.serie             = nota-fiscal.serie               
               AND proc-it-nota-fisc.nr-nota-fis       = nota-fiscal.nr-nota-fis         
               AND proc-it-nota-fisc.nr-seq-fat        = it-nota-fisc.nr-seq-fat         
               AND proc-it-nota-fisc.it-codigo         = it-nota-fisc.it-codigo   NO-ERROR.

        IF NOT AVAIL proc-it-nota-fisc THEN DO:
           CREATE proc-it-nota-fisc.
           ASSIGN proc-it-nota-fisc.cod-estabel       = c-cod-est-proc 
                  proc-it-nota-fisc.cod-estab-faturam = nota-fiscal.cod-estabel
                  proc-it-nota-fisc.serie             = it-nota-fisc.serie        
                  proc-it-nota-fisc.nr-nota-fis       = it-nota-fisc.nr-nota-fis
                  proc-it-nota-fisc.nr-seq-fat        = it-nota-fisc.nr-seq-fat
                  proc-it-nota-fisc.it-codigo         = it-nota-fisc.it-codigo
                  proc-it-nota-fisc.nr-sequencia      = it-nota-fisc.nr-seq-ped 
                  proc-it-nota-fisc.nome-abrev        = it-nota-fisc.nome-ab-cli
                  proc-it-nota-fisc.nr-pedcli         = it-nota-fisc.nr-pedcli
                  proc-it-nota-fisc.cod-refer         = it-nota-fisc.cod-refer
                  proc-it-nota-fisc.nr-entrega        = it-nota-fisc.nr-entrega
                  proc-it-nota-fisc.nr-proc-exp       = nota-fiscal.nr-proc-exp.
        
            FIND FIRST proc-ped-ent NO-LOCK
                WHERE proc-ped-ent.cod-estabel  = c-cod-est-proc
                   AND proc-ped-ent.nr-proc-exp  = nota-fiscal.nr-proc-exp  
                   AND proc-ped-ent.nome-abrev   = it-nota-fisc.nome-ab-cli 
                   AND proc-ped-ent.nr-pedcli    = it-nota-fisc.nr-pedcli   
                   AND proc-ped-ent.nr-sequencia = it-nota-fisc.nr-seq-ped  
                   AND proc-ped-ent.it-codigo    = it-nota-fisc.it-codigo   
                   AND proc-ped-ent.cod-refer    = it-nota-fisc.cod-refer   
                   AND proc-ped-ent.nr-entrega   = it-nota-fisc.nr-entrega  NO-ERROR.
        
            IF AVAIL proc-ped-ent THEN
               ASSIGN proc-it-nota-fisc.cod-fabric = proc-ped-ent.cod-fabric.

            FIND FIRST ped-venda NO-LOCK 
                 WHERE ped-venda.nome-abrev = proc-it-nota-fisc.nome-abrev 
                   AND ped-venda.nr-pedcli  = proc-it-nota-fisc.nr-pedcli  NO-ERROR.
            IF AVAIL ped-venda THEN
               ASSIGN proc-it-nota-fisc.nr-pedido = ped-venda.nr-pedido.

        END. /* if not avail proc-it-nota-fisc ... */
    &if DEFINEd(bf_dis_proc_ent) &then
      END.
    &endif    
END PROCEDURE.
