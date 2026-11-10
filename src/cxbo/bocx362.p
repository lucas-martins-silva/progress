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
{include/i-prgvrs.i BOCX362 2.00.00.034 } /*** "010034" 07/10/2024 16:59:57 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i bocx362 MUT}
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
&GLOBAL-DEFINE DBOName BOCX362
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName proc-export-atualiz-log
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
{cxbo/bocx362.i RowObject}
{cxbo/bocx362.i tt-proc-export-atualiz-log}

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/* Definiá∆o Vari†veis Locais */
DEFINE VARIABLE c-cod-estabel AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-nr-proc-exp AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cEstabIni      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cEstabFim      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cProcExportIni AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cProcExportFim AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dtDataGeracIni AS DATE       NO-UNDO.
DEFINE VARIABLE dtDataGeracFim AS DATE       NO-UNDO.


DEF TEMP-TABLE tt-estab-medio NO-UNDO
    FIELD cod-estabel LIKE estabelec.cod-estabel.

def temp-table tt-proc-export-atualiz-log-2 no-undo
    field cod-estabel          as char    format "x(3)"
    field nr-proc-exp          as char    format "x(12)"
    field dat-gerac            as date    format "99/99/9999"
    field hra-gerac            as char    format "99:99:99"
    field idi-tip-proces       as inte    format "9"
    field cod-usuar-gerac      as char    format "x(12)"
    field idi-tip-operac       as inte    format ">9"
    field dat-embarq           as date    format "99/99/9999"
    field dat-cancel           as date    format "99/99/9999"
    field hra-cancel           as char    format "99:99:99"
    field cod-usuar-cancel     as char    format "x(12)"
    field dsl-motiv-cancel     as char    format "x(2000)"
    field idi-situacao         as inte    format "9"
    field cod-livre-1          as char    format "x(100)"
    field cod-livre-2          as char    format "x(100)"
    field log-livre-1          as log     format "Sim/N∆o"
    field log-livre-2          as log     format "Sim/N∆o"
    field num-livre-1          as inte    format "->>>>>>>>9"
    field num-livre-2          as inte    format "->>>>>>>>9"
    field val-livre-1          as dec     format "->>>>>>>>>>>9.9999"
    field val-livre-2          as dec     format "->>>>>>>>>>>9.9999"
    field dat-livre-1          as date    format "99/99/9999"
    field dat-livre-2          as date    format "99/99/9999"
    field idi-tip-dat-trans    as inte    format "9".

{utp/ut-glob.i}
{cdp/cdcfgdis.i}

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
         HEIGHT             = 9.67
         WIDTH              = 42.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizacaoSituacaoLogProcessoExportacao DBOProgram 
PROCEDURE atualizacaoSituacaoLogProcessoExportacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel    LIKE proc-export-atualiz-log.cod-estabel    NO-UNDO.
    DEFINE INPUT PARAMETER pnr-proc-exp    LIKE proc-export-atualiz-log.nr-proc-exp    NO-UNDO.
    DEFINE INPUT PARAMETER pdat-gerac      LIKE proc-export-atualiz-log.dat-gerac      NO-UNDO. 
    DEFINE INPUT PARAMETER phra-gerac      LIKE proc-export-atualiz-log.hra-gerac      NO-UNDO. 
    DEFINE INPUT PARAMETER ptip-proces     LIKE proc-export-atualiz-log.idi-tip-proces NO-UNDO. 
    DEFINE INPUT PARAMETER ptip-operac     LIKE proc-export-atualiz-log.idi-tip-operac NO-UNDO. 
    DEFINE INPUT PARAMETER pi-situacao     LIKE proc-export-atualiz-log.idi-situacao   NO-UNDO. 

    for first proc-export-atualiz-log fields(idi-situacao) exclusive-lock
        where proc-export-atualiz-log.cod-estabel     = pcod-estabel and
              proc-export-atualiz-log.nr-proc-exp     = pnr-proc-exp and
              proc-export-atualiz-log.dat-gerac       = pdat-gerac   and
              proc-export-atualiz-log.hra-gerac       = phra-gerac   and
              proc-export-atualiz-log.idi-tip-proces  = ptip-proces  and
              proc-export-atualiz-log.idi-tip-operac  = ptip-operac:

        assign  proc-export-atualiz-log.idi-situacao = pi-situacao.
    end.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraLogAtualizacaoProcessoExportacao DBOProgram 
PROCEDURE geraLogAtualizacaoProcessoExportacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel    LIKE proc-export-atualiz-log.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pnr-proc-exp    LIKE proc-export-atualiz-log.nr-proc-exp NO-UNDO.
    DEFINE INPUT PARAMETER pdt-efetiva     LIKE proc-export-atualiz-log.dat-embarq  NO-UNDO.
    DEFINE INPUT PARAMETER pdt-efetiva-old LIKE proc-export-atualiz-log.dat-embarq  NO-UNDO.
    DEFINE INPUT PARAMETER pc-operacao     AS CHAR                                  NO-UNDO. /* Informa, Retira, Altera*/
    DEFINE INPUT PARAMETER pTipoTrans      AS INTEGER                               NO-UNDO.

    DEFINE VARIABLE c-hora               AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-hora-cancel        AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE i-cont               AS INTEGER    NO-UNDO.
    DEFINE VARIABLE c-return             AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE l-ctblz-recta-embarq AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE lCtrlDuplExport      AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE h-bocx180            AS HANDLE     NO-UNDO.
    DEFINE VARIABLE l-gera-log           AS LOGICAL    NO-UNDO  EXTENT 5.
    DEFINE VARIABLE c-situacao-aux       AS CHARACTER  NO-UNDO.

    DEF BUFFER b-proc-export-atualiz-log FOR proc-export-atualiz-log.

    ASSIGN c-hora = REPLACE(STRING(TIME,"hh:mm:ss"),":","").

    if not valid-handle(h-bocx180) then
       run cxbo/bocx180.p persistent set h-bocx180.
      
    run findPk_estabel in h-bocx180 (input pcod-estabel,
                                     output c-return).
    if c-return = "":U THEN DO:
       run getLogField  in h-bocx180 (input "log-ctblz-recta-embarq",
                                      output l-ctblz-recta-embarq).
       
       &IF '{&bf_dis_versao_ems}' < '2.08' &THEN
        RUN getCharField  IN h-bocx180 (INPUT "char-1",
                                        OUTPUT c-return).
        ASSIGN lCtrlDuplExport = IF SUBSTR(c-return,28,1) = '1' THEN YES ELSE NO.
       &ELSE
        RUN getLogField  IN h-bocx180 (INPUT "log-controla-dupl-export",
                                       OUTPUT lCtrlDuplExport).
       &ENDIF
       
    END.

    ASSIGN l-gera-log = NO. /* cada posicao do vetor corresponde a um tipo de log */

    DO  i-cont = 1 TO 5: /*1-Contab Receita, 2-Contab CPV, 3-Integ Contas Receber , 4-Contab Despesas  ,5-Integ Contas Pagar*/
        
        IF  i-pais-impto-usuario <> 1
        AND (i-cont = 4 OR i-cont = 5) THEN
            NEXT.
        
        /* condicao 1 */
        /* nao contabiliza receita pela data do embarque */
        IF  i-cont >= 1 
        AND i-cont <= 3 
        AND NOT l-ctblz-recta-embarq THEN DO:
            IF  i-cont = 3 AND lCtrlDuplExport THEN
                ASSIGN l-gera-log[i-cont] = YES.
            ELSE DO:
               ASSIGN l-gera-log[i-cont] = NO.
               NEXT.
            END.
        END.

        /* condicao 2 */
        /* as notas do processo de exportacao nao geraram duplicatas */
        IF  i-cont = 1          /* contab receita */
        OR  i-cont = 3 THEN DO: /* substituicao de titulos no contas receber */ 

            ASSIGN l-gera-log[i-cont] = NO.

            FOR EACH proc-nota-fiscal NO-LOCK
                WHERE proc-nota-fiscal.cod-estabel = pcod-estabel
                  AND proc-nota-fiscal.nr-proc-exp = pnr-proc-exp,

                EACH nota-fiscal NO-LOCK
                WHERE nota-fiscal.cod-estabel  = proc-nota-fiscal.cod-estab-faturam
                  AND nota-fiscal.serie        = proc-nota-fiscal.serie
                  AND nota-fiscal.nr-nota-fis  = proc-nota-fiscal.nr-nota-fis
                  AND nota-fiscal.dt-cancela   = ?
                  AND nota-fiscal.emite-duplic = YES:
    
                ASSIGN l-gera-log[i-cont] = YES.
                LEAVE.
            END.
    
            IF  l-gera-log[i-cont] = NO THEN
                NEXT.
        END.
                
        /* condicao 3 */
        /* nao possui despesas que integram com o contas a pagar */
        IF  i-cont = 4          /* contab despesas */
        OR  i-cont = 5 THEN DO: /* geracao de titulos no contas a pagar */ 
            FOR FIRST proc-desp-itiner
                FIELDS () NO-LOCK
                WHERE proc-desp-itiner.cod-estabel          = pcod-estabel
                  AND proc-desp-itiner.nr-proc-exp          = pnr-proc-exp
                  AND proc-desp-itiner.log-despes-integr-ap = YES
                  AND proc-desp-itiner.val-desp             <> 0: /* gera desp no contas a pagar */
            END.
            
            IF  AVAIL proc-desp-itiner THEN 
                ASSIGN l-gera-log[i-cont] = YES.
            ELSE DO:
                ASSIGN l-gera-log[i-cont] = NO.
                NEXT.
            END.
        END.
        
        /* condicao 4 */
        /* as notas do processo de exportacao nao geraram movimento de saida no estoque */
        /* ou nao foram atualizadas no estoque pelo FT2100 */
        IF  i-cont = 2 THEN DO: /* contab CPV */

            /* verificar se as notas geraram movimento no estoque */
            ASSIGN l-gera-log[i-cont] = NO.

            FOR EACH proc-nota-fiscal NO-LOCK
                WHERE proc-nota-fiscal.cod-estabel = pcod-estabel
                  AND proc-nota-fiscal.nr-proc-exp = pnr-proc-exp,

                EACH nota-fiscal FIELDS (nota-fiscal.cod-emitente nota-fiscal.nat-operacao) NO-LOCK
                WHERE nota-fiscal.cod-estabel  = proc-nota-fiscal.cod-estab-faturam
                  AND nota-fiscal.serie        = proc-nota-fiscal.serie
                  AND nota-fiscal.nr-nota-fis  = proc-nota-fiscal.nr-nota-fis
                  AND nota-fiscal.dt-confirma <> ?
                  AND nota-fiscal.dt-cancela   = ?,

                EACH movto-estoq 
                FIELDS () NO-LOCK
                WHERE movto-estoq.cod-estabel  = nota-fiscal.cod-estabel
                  AND movto-estoq.serie-docto  = nota-fiscal.serie
                  AND movto-estoq.nro-docto    = nota-fiscal.nr-nota-fis
                  AND movto-estoq.cod-emitente = nota-fiscal.cod-emitente
                  AND movto-estoq.nat-operacao = nota-fiscal.nat-operacao
                  AND movto-estoq.tipo-trans   = 2: /* sa°da */
    
                ASSIGN l-gera-log[i-cont] = YES.
                LEAVE.
            END.

            /* verificar se tem nota n∆o atualizada no estoque */
            IF  l-gera-log[i-cont] = NO THEN DO:

                FOR EACH proc-nota-fiscal NO-LOCK
                    WHERE proc-nota-fiscal.cod-estabel = pcod-estabel
                      AND proc-nota-fiscal.nr-proc-exp = pnr-proc-exp,

                    EACH nota-fiscal 
                    FIELDS (nota-fiscal.cod-emitente
                            nota-fiscal.nat-operacao) NO-LOCK
                    WHERE nota-fiscal.cod-estabel  = proc-nota-fiscal.cod-estab-faturam
                      AND nota-fiscal.serie        = proc-nota-fiscal.serie
                      AND nota-fiscal.nr-nota-fis  = proc-nota-fiscal.nr-nota-fis
                      AND nota-fiscal.dt-confirma  = ?
                      AND nota-fiscal.dt-cancela   = ?:

                    ASSIGN l-gera-log[i-cont] = YES.
                    LEAVE.
                END.
            END.

            IF  l-gera-log[i-cont] = NO THEN
                NEXT.
        END.

        EMPTY TEMP-TABLE tt-proc-export-atualiz-log.
        CREATE tt-proc-export-atualiz-log.
        ASSIGN tt-proc-export-atualiz-log.cod-estabel       = pcod-estabel
               tt-proc-export-atualiz-log.nr-proc-exp       = pnr-proc-exp
               tt-proc-export-atualiz-log.dat-gerac         = TODAY
               tt-proc-export-atualiz-log.hra-gerac         = c-hora
               tt-proc-export-atualiz-log.idi-tip-proces    = i-cont
               tt-proc-export-atualiz-log.cod-usuar-gerac   = c-seg-usuario
               tt-proc-export-atualiz-log.dat-embarq        = IF pc-operacao = "Informa":U THEN pdt-efetiva ELSE pdt-efetiva-old
               tt-proc-export-atualiz-log.idi-tip-operac    = IF pc-operacao = "Informa":U THEN 1 /* Efetivaá∆o */ ELSE 2 /* Estorno */
               tt-proc-export-atualiz-log.idi-tip-dat-trans = IF pc-operacao = "Retira":U THEN 1 ELSE pTipoTrans.


        RUN openQueryStatic IN THIS-PROCEDURE (INPUT "Main":U).
        RUN emptyRowErrors  IN THIS-PROCEDURE.
        RUN emptyRowObject  IN THIS-PROCEDURE.
        RUN setRecord       IN THIS-PROCEDURE (INPUT TABLE tt-proc-export-atualiz-log).
        RUN createRecord    IN THIS-PROCEDURE.
        EMPTY TEMP-TABLE  tt-proc-export-atualiz-log.
        RUN getRecord       IN THIS-PROCEDURE (OUTPUT TABLE tt-proc-export-atualiz-log).

        FIND FIRST tt-proc-export-atualiz-log NO-ERROR.
        
        IF  tt-proc-export-atualiz-log.idi-tip-operac = 2 THEN DO:

            ASSIGN c-hora-cancel = REPLACE(STRING(TIME,"hh:mm:ss"),":","").
            FIND FIRST bf{&TableName}
                 WHERE bf{&TableName}.cod-estabel     = tt-proc-export-atualiz-log.cod-estabel
                   AND bf{&TableName}.nr-proc-exp     = tt-proc-export-atualiz-log.nr-proc-exp
                   AND bf{&TableName}.dat-gerac      <= tt-proc-export-atualiz-log.dat-gerac
                   AND bf{&tablename}.idi-tip-proces  = tt-proc-export-atualiz-log.idi-tip-proces
                   AND bf{&tablename}.idi-tip-operac  = 1 /* Efetivaá∆o */
                   AND bf{&tablename}.idi-situacao    <> 3 /* Processado com sucesso */ 
                   AND bf{&TableName}.dat-cancel      = ?
                   AND ROWID(bf{&TableName})          <> tt-proc-export-atualiz-log.r-rowid NO-LOCK NO-ERROR.

            IF  AVAIL bf{&TableName} THEN DO:
                FIND CURRENT bf{&TableName} EXCLUSIVE-LOCK NO-ERROR.

                ASSIGN c-situacao-aux                  = IF  bf{&tablename}.idi-situacao = 1
                                                         THEN "'N∆o Processado' "
                                                         ELSE "'Processado com erro' "
                       bf{&TableName}.dat-cancel       = TODAY
                       bf{&TableName}.hra-cancel       = c-hora-cancel
                       bf{&TableName}.cod-usuar-cancel = c-seg-usuario
                       bf{&TableName}.dsl-motiv-cancel = "CANCELAMENTO AUTOMµTICO: Este log de atualizaá∆o de 'efetivaá∆o' " 
                                                         + "foi cancelado porque estava com situaá∆o igual a " + c-situacao-aux 
                                                         + "e foi gerado um LOG de 'estorno'. DADOS DO LOG DE ESTORNO: Data da "
                                                         + "Geraá∆o: " + string(tt-proc-export-atualiz-log.dat-gerac) + ". Hora da " 
                                                         + "Geraá∆o: " + string(tt-proc-export-atualiz-log.hra-gerac,"99:99:99") 
                                                         + ". Usu†rio da Geraá∆o: " + tt-proc-export-atualiz-log.cod-usuar-gerac + ".".
                ASSIGN tt-proc-export-atualiz-log.dat-cancel       = TODAY
                       tt-proc-export-atualiz-log.hra-cancel       = c-hora-cancel
                       tt-proc-export-atualiz-log.cod-usuar-cancel = c-seg-usuario
                       tt-proc-export-atualiz-log.dsl-motiv-cancel = "CANCELAMENTO AUTOMµTICO: Este log de atualizaá∆o de 'estorno' "
                                                                  + "foi cancelado devido ao cancelamento DO LOG de 'efetivaá∆o' " 
                                                                  + "correspondente que estava com situaá∆o igual a " + c-situacao-aux  
                                                                  + "DADOS DO LOG DE EFETIVAÄ«O: Data da Geraá∆o: " 
                                                                  + string(bf{&TableName}.dat-gerac) + ". Hora da Geraá∆o: "
                                                                  + string(bf{&TableName}.hra-gerac,"99:99:99") + ". Usu†rio da Geraá∆o: "
                                                                  + bf{&TableName}.cod-usuar-gerac.

                RUN openQueryStatic IN THIS-PROCEDURE (INPUT "Main":U).
                RUN emptyRowErrors  IN THIS-PROCEDURE.
                RUN emptyRowObject  IN THIS-PROCEDURE.
                RUN goToKey         IN THIS-PROCEDURE (INPUT tt-proc-export-atualiz-log.cod-estabel,
                                                       INPUT tt-proc-export-atualiz-log.nr-proc-exp,
                                                       INPUT tt-proc-export-atualiz-log.dat-gerac,
                                                       INPUT tt-proc-export-atualiz-log.hra-gerac,
                                                       INPUT tt-proc-export-atualiz-log.idi-tip-proces,
                                                       INPUT tt-proc-export-atualiz-log.idi-tip-operac).
                RUN setRecord       IN THIS-PROCEDURE (INPUT TABLE tt-proc-export-atualiz-log).
                RUN updateRecord    IN THIS-PROCEDURE.

                FIND CURRENT bf{&TableName} NO-LOCK NO-ERROR.
            END.
        END.
        IF  pc-operacao = "Altera":U THEN DO:
            EMPTY TEMP-TABLE tt-proc-export-atualiz-log.
            CREATE tt-proc-export-atualiz-log.
            ASSIGN tt-proc-export-atualiz-log.cod-estabel       = pcod-estabel
                   tt-proc-export-atualiz-log.nr-proc-exp       = pnr-proc-exp
                   tt-proc-export-atualiz-log.dat-gerac         = TODAY
                   tt-proc-export-atualiz-log.hra-gerac         = c-hora
                   tt-proc-export-atualiz-log.idi-tip-proces    = i-cont
                   tt-proc-export-atualiz-log.cod-usuar-gerac   = c-seg-usuario
                   tt-proc-export-atualiz-log.dat-embarq        = pdt-efetiva
                   tt-proc-export-atualiz-log.idi-tip-operac    = 1 /* Efetivaá∆o */ 
                   tt-proc-export-atualiz-log.idi-tip-dat-trans = pTipoTrans.

            RUN openQueryStatic IN THIS-PROCEDURE (INPUT "Main":U).
            RUN emptyRowErrors  IN THIS-PROCEDURE.
            RUN emptyRowObject  IN THIS-PROCEDURE.
            RUN setRecord       IN THIS-PROCEDURE (INPUT TABLE tt-proc-export-atualiz-log).
            RUN createRecord    IN THIS-PROCEDURE.

        END.

        if  tt-proc-export-atualiz-log.idi-tip-proces = 4 then do: /* 4 = Contab Desp */
            /* atualizar a data de geracao do log na despesa do processo */
            for each proc-desp-itiner exclusive-lock
                where proc-desp-itiner.cod-estabel = processo-exp.cod-estabel
                and   proc-desp-itiner.nr-proc-exp = processo-exp.nr-proc-exp
                and   proc-desp-itiner.log-2       = NO /* nao contabilizada */
                and   proc-desp-itiner.data-1      = ?:

                assign proc-desp-itiner.data-1 = tt-proc-export-atualiz-log.dat-gerac.

            end.    
        end.

    END.

    FIND FIRST processo-exp
         WHERE processo-exp.cod-estabel = pcod-estabel
           AND processo-exp.nr-proc-exp = pnr-proc-exp EXCLUSIVE-LOCK NO-ERROR.

    /* atualizado na contabilidade */
    IF  l-gera-log[1] = NO      /* contab receita */
    AND l-gera-log[4] = NO THEN /* contab receita */
        ASSIGN processo-exp.log-atualiz-ctb = IF pc-operacao = "Retira" THEN NO ELSE YES.

    /* atualizado no estoque  */
    IF  l-gera-log[2] = NO THEN /* contab CPV */
        ASSIGN processo-exp.log-atualiz-ce = IF pc-operacao = "Retira" THEN NO ELSE YES.

    /* atualizado no contas a receber  */
    IF  l-gera-log[3] = NO THEN /* integracao com contas a receber */
        ASSIGN processo-exp.log-atualiz-crb = IF pc-operacao = "Retira" THEN NO ELSE YES.

    /* atualizado no contas a pagar */
    IF  l-gera-log[5] = NO THEN /* integracao com contas a pagar */
        ASSIGN processo-exp.log-atualiz-apb = IF pc-operacao = "Retira" THEN NO ELSE YES.

    IF VALID-HANDLE(h-bocx180) THEN DO:
       DELETE PROCEDURE h-bocx180.
       ASSIGN h-bocx180 = ?.
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
        WHEN "cod-usuar-cancel":U THEN ASSIGN pFieldValue = RowObject.cod-usuar-cancel.
        WHEN "cod-usuar-gerac":U THEN ASSIGN pFieldValue = RowObject.cod-usuar-gerac.
        WHEN "dsl-motiv-cancel":U THEN ASSIGN pFieldValue = RowObject.dsl-motiv-cancel.
        WHEN "hra-cancel":U THEN ASSIGN pFieldValue = RowObject.hra-cancel.
        WHEN "hra-gerac":U THEN ASSIGN pFieldValue = RowObject.hra-gerac.
        WHEN "nr-proc-exp":U THEN ASSIGN pFieldValue = RowObject.nr-proc-exp.
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
        WHEN "dat-cancel":U THEN ASSIGN pFieldValue = RowObject.dat-cancel.
        WHEN "dat-embarq":U THEN ASSIGN pFieldValue = RowObject.dat-embarq.
        WHEN "dat-gerac":U THEN ASSIGN pFieldValue = RowObject.dat-gerac.
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
        WHEN "idi-situacao":U THEN ASSIGN pFieldValue = RowObject.idi-situacao.
        WHEN "idi-tip-operac":U THEN ASSIGN pFieldValue = RowObject.idi-tip-operac.
        WHEN "idi-tip-proces":U THEN ASSIGN pFieldValue = RowObject.idi-tip-proces.
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
  Purpose:     Retorna valores dos campos do °ndice prcsxpra-id
  Parameters:  
               retorna valor do campo cod-estabel
               retorna valor do campo nr-proc-exp
               retorna valor do campo dat-gerac
               retorna valor do campo hra-gerac
               retorna valor do campo idi-tip-proces
               retorna valor do campo idi-tip-operac
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE proc-export-atualiz-log.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-proc-exp LIKE proc-export-atualiz-log.nr-proc-exp NO-UNDO.
    DEFINE OUTPUT PARAMETER pdat-gerac LIKE proc-export-atualiz-log.dat-gerac NO-UNDO.
    DEFINE OUTPUT PARAMETER phra-gerac LIKE proc-export-atualiz-log.hra-gerac NO-UNDO.
    DEFINE OUTPUT PARAMETER pidi-tip-proces LIKE proc-export-atualiz-log.idi-tip-proces NO-UNDO.
    DEFINE OUTPUT PARAMETER pidi-tip-operac LIKE proc-export-atualiz-log.idi-tip-operac NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-estabel = RowObject.cod-estabel
           pnr-proc-exp = RowObject.nr-proc-exp
           pdat-gerac = RowObject.dat-gerac
           phra-gerac = RowObject.hra-gerac
           pidi-tip-proces = RowObject.idi-tip-proces
           pidi-tip-operac = RowObject.idi-tip-operac.

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
  Purpose:     Reposiciona registro com base no °ndice prcsxpra-id
  Parameters:  
               recebe valor do campo cod-estabel
               recebe valor do campo nr-proc-exp
               recebe valor do campo dat-gerac
               recebe valor do campo hra-gerac
               recebe valor do campo idi-tip-proces
               recebe valor do campo idi-tip-operac
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE proc-export-atualiz-log.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pnr-proc-exp LIKE proc-export-atualiz-log.nr-proc-exp NO-UNDO.
    DEFINE INPUT PARAMETER pdat-gerac LIKE proc-export-atualiz-log.dat-gerac NO-UNDO.
    DEFINE INPUT PARAMETER phra-gerac LIKE proc-export-atualiz-log.hra-gerac NO-UNDO.
    DEFINE INPUT PARAMETER pidi-tip-proces LIKE proc-export-atualiz-log.idi-tip-proces NO-UNDO.
    DEFINE INPUT PARAMETER pidi-tip-operac LIKE proc-export-atualiz-log.idi-tip-operac NO-UNDO.

    FIND FIRST bfproc-export-atualiz-log WHERE 
        bfproc-export-atualiz-log.cod-estabel = pcod-estabel AND 
        bfproc-export-atualiz-log.nr-proc-exp = pnr-proc-exp AND 
        bfproc-export-atualiz-log.dat-gerac = pdat-gerac AND 
        bfproc-export-atualiz-log.hra-gerac = phra-gerac AND 
        bfproc-export-atualiz-log.idi-tip-proces = pidi-tip-proces AND 
        bfproc-export-atualiz-log.idi-tip-operac = pidi-tip-operac NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfproc-export-atualiz-log THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfproc-export-atualiz-log)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToprocesso-exp DBOProgram 
PROCEDURE linkToprocesso-exp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER hp_Parent AS HANDLE NO-UNDO.
    
    ASSIGN c-cod-estabel = ""
           c-nr-proc-exp = "".
    
    IF  VALID-HANDLE(hp_Parent) THEN DO:
        RUN getCharField IN hp_Parent (INPUT "cod-estabel":U, OUTPUT c-cod-estabel).
        RUN getCharField IN hp_Parent (INPUT "nr-proc-exp":U, OUTPUT c-nr-proc-exp).
    END.
    
    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCancel DBOProgram 
PROCEDURE openQueryCancel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK
         WHERE {&tablename}.cod-estabel >= cEstabIni      
           AND {&tablename}.cod-estabel <= cEstabFim      
           AND {&tablename}.nr-proc-exp >= cProcExportIni 
           AND {&tablename}.nr-proc-exp <= cProcExportFim 
           AND {&tablename}.dat-gerac   >= dtDataGeracIni 
           AND {&tablename}.dat-gerac   <= dtDataGeracFim 
           INDEXED-REPOSITION .
    
    RETURN "OK".    

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
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK INDEXED-REPOSITION.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryProcessoExp DBOProgram 
PROCEDURE openQueryProcessoExp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK
         WHERE {&tablename}.cod-estabel = c-cod-estabel
           AND {&tablename}.nr-proc-exp = c-nr-proc-exp
            BY {&tablename}.cod-estabel
            BY {&tablename}.nr-proc-exp
            BY {&tablename}.dat-gerac
            BY {&tablename}.hra-gerac
            BY {&tablename}.idi-tip-proces
            BY {&tablename}.idi-tip-operac DESCENDING
           INDEXED-REPOSITION.
    
    RETURN "OK".    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaLog DBOProgram 
PROCEDURE retornaLog :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pr-log AS ROWID NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-proc-export-atualiz-log.

    FIND bfproc-export-atualiz-log WHERE ROWID(bfproc-export-atualiz-log) = pr-log NO-LOCK NO-ERROR.
    IF AVAIL bfproc-export-atualiz-log THEN DO:
        EMPTY TEMP-TABLE tt-proc-export-atualiz-log.
        CREATE tt-proc-export-atualiz-log.
        BUFFER-COPY bfproc-export-atualiz-log TO tt-proc-export-atualiz-log.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCancel DBOProgram 
PROCEDURE setConstraintCancel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM pEstabIni      AS CHARACTER NO-UNDO.
    DEF INPUT PARAM pEstabFim      AS CHARACTER NO-UNDO.
    DEF INPUT PARAM pProcExportIni AS CHARACTER NO-UNDO.
    DEF INPUT PARAM pProcExportFim AS CHARACTER NO-UNDO.
    DEF INPUT PARAM pDataGeracIni  AS DATE      NO-UNDO.
    DEF INPUT PARAM pDataGeracFim  AS DATE      NO-UNDO.

    ASSIGN cEstabIni      = pEstabIni      
           cEstabFim      = pEstabFim      
           cProcExportIni = pProcExportIni  
           cProcExportFim = pProcExportFim
           dtDataGeracIni = pDataGeracIni 
           dtDataGeracFim = pDataGeracFim. 

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ValidaCalculoMedio DBOProgram 
PROCEDURE ValidaCalculoMedio : /*verificar ce0401rp.p*/
/*------------------------------------------------------------------------------
  Purpose:  Verificar se existe um log pendente de atualizacao   
  Parameters:  
  Notes:  este mÇtodo Ç chamado pelo programa ce0401rp.p      
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER p-dt-ini AS DATE NO-UNDO.
DEF INPUT PARAMETER p-dt-fim AS DATE NO-UNDO.
DEF INPUT PARAMETER TABLE FOR tt-estab-medio.
DEF OUTPUT PARAMETER p-l-possui-log AS LOG NO-UNDO.

FOR EACH tt-estab-medio:

    ASSIGN p-l-possui-log = (   CAN-FIND(FIRST proc-export-atualiz-log
                                         WHERE proc-export-atualiz-log.cod-estabel    = tt-estab-medio.cod-estabel
                                         AND   proc-export-atualiz-log.idi-situacao   = 1 /* n∆o processado */
                                         AND   proc-export-atualiz-log.dat-gerac     >= p-dt-ini
                                         AND   proc-export-atualiz-log.dat-gerac     <= p-dt-fim
                                         AND   proc-export-atualiz-log.dat-cancel     = ?
                                         AND   proc-export-atualiz-log.idi-tip-proces = 2 )
                             OR CAN-FIND(FIRST proc-export-atualiz-log
                                         WHERE proc-export-atualiz-log.cod-estabel    = tt-estab-medio.cod-estabel
                                         AND   proc-export-atualiz-log.idi-situacao   = 2 /* processado com erro*/
                                         AND   proc-export-atualiz-log.dat-gerac     >= p-dt-ini
                                         AND   proc-export-atualiz-log.dat-gerac     <= p-dt-fim
                                         AND   proc-export-atualiz-log.dat-cancel     = ?
                                         AND   proc-export-atualiz-log.idi-tip-proces = 2)).
    IF  p-l-possui-log THEN LEAVE.
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

    DEFINE VARIABLE c-desc-tip-operac  AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-desc-tip-proces  AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-desc-erro        AS CHARACTER  NO-UNDO.
    
    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/

    IF pType = "Update":U THEN DO:

        IF RowObject.dat-cancel <> ? THEN DO:
            FIND FIRST bf{&TableName} 
                 WHERE bf{&TableName}.cod-estabel    = RowObject.cod-estabel   
                   AND bf{&TableName}.nr-proc-exp    = RowObject.nr-proc-exp   
                   AND bf{&TableName}.dat-gerac      = RowObject.dat-gerac     
                   AND bf{&TableName}.hra-gerac      = RowObject.hra-gerac     
                   AND bf{&tablename}.idi-tip-proces = RowObject.idi-tip-proces
                   AND bf{&tablename}.idi-tip-operac = RowObject.idi-tip-operac NO-LOCK NO-ERROR.
            
            IF  AVAIL bf{&TableName} THEN DO:
                &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                    DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
                    ASSIGN cAuxTraducao001 = {cxinc/i02cx363.i 04 bf{&tablename}.
                    run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                                        INPUT "",
                                        INPUT "").
                    ASSIGN  c-desc-tip-operac = RETURN-VALUE.idi-tip-operac}.
                &else
                    ASSIGN c-desc-tip-operac = {cxinc/i02cx363.i 04 bf{&tablename}.idi-tip-operac}.
                &endif
                RUN utp/ut-liter.p(INPUT c-desc-tip-operac, INPUT "", INPUT "").
                ASSIGN c-desc-tip-operac = TRIM(RETURN-VALUE).
            
                &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                    DEFINE VARIABLE cAuxTraducao002 AS CHARACTER NO-UNDO.
                    ASSIGN cAuxTraducao002 = {cxinc/i01cx363.i 04 bf{&tablename}.
                    run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao002)," ","_"),
                                        INPUT "",
                                        INPUT "").
                    ASSIGN  c-desc-tip-proces = RETURN-VALUE.idi-tip-proces}.
                &else
                    ASSIGN c-desc-tip-proces = {cxinc/i01cx363.i 04 bf{&tablename}.idi-tip-proces}.
                &endif
                RUN utp/ut-liter.p(INPUT c-desc-tip-proces, INPUT "", INPUT "").
                ASSIGN c-desc-tip-proces = TRIM(RETURN-VALUE).

                IF bf{&tablename}.idi-situacao = 3 THEN DO:
                    ASSIGN c-desc-erro = bf{&TableName}.cod-estabel + "~~" +
                                         bf{&TableName}.nr-proc-exp + "~~" +
                                         STRING(bf{&TableName}.dat-gerac,"99/99/9999") + "~~" +
                                         STRING(bf{&TableName}.hra-gerac,"99:99:99")   + "~~" + 
                                         c-desc-tip-proces + "~~" +
                                         c-desc-tip-operac.
                        {method/svc/errors/inserr.i
                            &ErrorNumber="31348"
                            &ErrorType="EMS"
                            &ErrorSubType="Error"
                            &ErrorParameters="c-desc-erro"}
                END.
                 
                IF bf{&TableName}.dat-cancel <> ? THEN DO:
                    ASSIGN c-desc-erro = bf{&TableName}.cod-estabel + "~~" +
                                         bf{&TableName}.nr-proc-exp + "~~" +
                                         STRING(bf{&TableName}.dat-gerac,"99/99/9999") + "~~" +
                                         STRING(bf{&TableName}.hra-gerac,"99:99:99")   + "~~" + 
                                         c-desc-tip-proces + "~~" +
                                         c-desc-tip-operac.
                        {method/svc/errors/inserr.i
                            &ErrorNumber="31349"
                            &ErrorType="EMS"
                            &ErrorSubType="Error"
                            &ErrorParameters="c-desc-erro"}
                END.
            END.
        END.
    END.
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors 
                WHERE RowErrors.ErrorSubType  = "ERROR":U
                  AND RowErrors.ErrorType    <> "INTERNAL") THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE VerificaLogPendente DBOProgram 
PROCEDURE VerificaLogPendente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER p-cod-estabelec LIKE proc-export-atualiz-log.cod-estabel NO-UNDO.
DEF INPUT PARAMETER p-nr-proc-exp   LIKE proc-export-atualiz-log.nr-proc-exp NO-UNDO.

IF  CAN-FIND(FIRST proc-export-atualiz-log
            WHERE proc-export-atualiz-log.cod-estabel = p-cod-estabelec
            AND   proc-export-atualiz-log.nr-proc-exp = p-nr-proc-exp
            AND   proc-export-atualiz-log.idi-situacao   <= 2 /* nao processado ou processado com erro */
            AND   proc-export-atualiz-log.dat-cancel = ?) THEN
    RETURN "NOK":U.
              
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

PROCEDURE verificaProcessoExport:

    def input parameter p-dt-ini    as date format "99/99/9999" no-undo.
    def input parameter p-dt-fim    as date format "99/99/9999" no-undo.
    def input parameter p-ind-estab as log                      no-undo.
    def input parameter p-cod-estab as char format "x(3)"       no-undo.
    def input-output parameter table for tt-proc-export-atualiz-log-2.

    if p-ind-estab then
        FOR EACH proc-export-atualiz-log no-lock WHERE
            proc-export-atualiz-log.cod-estabel     = p-cod-estab AND
            (proc-export-atualiz-log.idi-situacao   = 1  OR
             proc-export-atualiz-log.idi-situacao   = 2)          AND
             proc-export-atualiz-log.dat-gerac     >= p-dt-ini    AND
             proc-export-atualiz-log.dat-gerac     <= p-dt-fim    AND
             proc-export-atualiz-log.idi-tip-proces = 2           AND
             proc-export-atualiz-log.dat-cancel     = ?:
    
             create tt-proc-export-atualiz-log-2.
             buffer-copy proc-export-atualiz-log to tt-proc-export-atualiz-log-2.
        END.
    else
        FOR EACH proc-export-atualiz-log no-lock WHERE
            (proc-export-atualiz-log.idi-situacao   = 1  OR
             proc-export-atualiz-log.idi-situacao   = 2)          AND
             proc-export-atualiz-log.dat-gerac     >= p-dt-ini    AND
             proc-export-atualiz-log.dat-gerac     <= p-dt-fim    AND
             proc-export-atualiz-log.idi-tip-proces = 2           AND
             proc-export-atualiz-log.dat-cancel     = ?:
    
             create tt-proc-export-atualiz-log-2.
             buffer-copy proc-export-atualiz-log to tt-proc-export-atualiz-log-2.
        END.


RETURN "OK":U.

end procedure.

PROCEDURE piverificaLogProcessado:
    /*
    Posiciona o registro da tabela no £ltimo log gerado com situacao nao cancelado
    */

    DEFINE INPUT  PARAMETER pcod-estabel    LIKE proc-export-atualiz-log.cod-estabel    NO-UNDO.
    DEFINE INPUT  PARAMETER pnr-proc-exp    LIKE proc-export-atualiz-log.nr-proc-exp    NO-UNDO.
    DEFINE INPUT  PARAMETER pidi-tip-proces LIKE proc-export-atualiz-log.idi-tip-proces NO-UNDO.
    DEFINE OUTPUT PARAMETER pidi-tip-operac LIKE proc-export-atualiz-log.idi-tip-operac NO-UNDO.
    DEFINE OUTPUT PARAMETER pidi-situacao   LIKE proc-export-atualiz-log.idi-situacao   NO-UNDO.
    DEFINE OUTPUT PARAMETER pd-dt-trans     LIKE  proc-export-atualiz-log.dat-gerac     NO-UNDO.
    
    FIND LAST bfproc-export-atualiz-log 
        WHERE bfproc-export-atualiz-log.cod-estabel    = pcod-estabel 
          AND bfproc-export-atualiz-log.nr-proc-exp    = pnr-proc-exp 
          AND bfproc-export-atualiz-log.idi-tip-proces = pidi-tip-proces 
          AND bfproc-export-atualiz-log.dat-cancel     = ? NO-LOCK NO-ERROR.
    
    IF AVAIL bfproc-export-atualiz-log  THEN
        ASSIGN pidi-tip-operac  = bfproc-export-atualiz-log.idi-tip-operac
               pidi-situacao    = bfproc-export-atualiz-log.idi-situacao
               pd-dt-trans      = IF   bfproc-export-atualiz-log.idi-tip-dat-trans = 1
                                  THEN bfproc-export-atualiz-log.dat-gerac
                                  ELSE bfproc-export-atualiz-log.dat-embarq.
    ELSE
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE piVerificaSituacaoLog:
    DEFINE INPUT  PARAMETER pcod-estabel        LIKE proc-export-atualiz-log.cod-estabel    NO-UNDO.
    DEFINE INPUT  PARAMETER pnr-proc-exp        LIKE proc-export-atualiz-log.nr-proc-exp    NO-UNDO.
    DEFINE OUTPUT PARAMETER l-desconsidera-exp  AS   LOGICAL                                NO-UNDO.

    FOR FIRST processo-exp
        WHERE processo-exp.cod-estabel = pcod-estabel
          AND processo-exp.nr-proc-exp = pnr-proc-exp NO-LOCK:

        IF  processo-exp.dt-embarque <> ? 
        AND CAN-FIND(FIRST proc-export-atualiz-log
                     WHERE proc-export-atualiz-log.cod-estabel = processo-exp.cod-estabel
                       AND proc-export-atualiz-log.nr-proc-exp = processo-exp.nr-proc-exp 
                       AND proc-export-atualiz-log.idi-tip-proces = 3 /*Geraá∆o de t°tulo no Contas a Receber*/
                       AND proc-export-atualiz-log.idi-tip-operac = 1 /*Efetivaá∆o*/
                       AND proc-export-atualiz-log.idi-situacao   = 3 /*Processado com Sucesso*/ ) THEN
                ASSIGN l-desconsidera-exp = YES.
        ELSE
            ASSIGN l-desconsidera-exp = NO.
    END.
    IF NOT AVAIL processo-exp THEN
        ASSIGN l-desconsidera-exp = YES.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE piverificaLogProcessadoEfetivacao:
    /*
    ** Identifica as informaá‰es do £ltimo Log de Efetivaá∆o processado
    */

    DEFINE INPUT  PARAMETER pcod-estabel    LIKE proc-export-atualiz-log.cod-estabel    NO-UNDO.
    DEFINE INPUT  PARAMETER pnr-proc-exp    LIKE proc-export-atualiz-log.nr-proc-exp    NO-UNDO.
    DEFINE INPUT  PARAMETER pidi-tip-proces LIKE proc-export-atualiz-log.idi-tip-proces NO-UNDO.
    DEFINE OUTPUT PARAMETER pidi-situacao   LIKE proc-export-atualiz-log.idi-situacao   NO-UNDO.
    DEFINE OUTPUT PARAMETER pd-dt-trans     LIKE  proc-export-atualiz-log.dat-gerac     NO-UNDO.
    
    FIND LAST bfproc-export-atualiz-log 
        WHERE bfproc-export-atualiz-log.cod-estabel    = pcod-estabel 
          AND bfproc-export-atualiz-log.nr-proc-exp    = pnr-proc-exp 
          AND bfproc-export-atualiz-log.idi-tip-proces = pidi-tip-proces 
          and bfproc-export-atualiz-log.idi-tip-operac = 1 /*Efetivaá∆o*/
          AND bfproc-export-atualiz-log.dat-cancel     = ? NO-LOCK NO-ERROR.
    IF AVAIL bfproc-export-atualiz-log THEN
        ASSIGN pidi-situacao    = bfproc-export-atualiz-log.idi-situacao
               pd-dt-trans      = IF   bfproc-export-atualiz-log.idi-tip-dat-trans = 1
                                  THEN bfproc-export-atualiz-log.dat-gerac
                                  ELSE bfproc-export-atualiz-log.dat-embarq.

    ELSE
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.
