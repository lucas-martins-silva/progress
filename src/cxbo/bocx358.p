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
{include/i-prgvrs.i BOCX358 2.00.00.036 } /*** "010036" 15/10/2025 07:56:43 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i bocx358 MUT}
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
&GLOBAL-DEFINE DBOName BOCX358
&GLOBAL-DEFINE DBOVersion 2
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName proc-ped-ent-desp
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
{cxbo/bocx358.i RowObject}
{cdp/cdcfgdis.i}
{cdp/cdcfgcex.i}

define temp-table tt-desp-entr no-undo
    FIELD cod-emitente-desp AS INTEGER   FORMAT ">>>>>>>>9"
    FIELD nome-emit         AS CHARACTER FORMAT "x(40)"
    FIELD cdn-despes        AS INTEGER   FORMAT ">>,>>9"
    FIELD desc-desp         AS CHARACTER FORMAT "x(30)"
    FIELD cod-pto-contr     AS INTEGER   FORMAT ">>,>>9" 
    FIELD desc-pto-contr    AS CHARACTER FORMAT "x(30)"
    FIELD log-forma-preco   AS LOGICAL   FORMAT "Sim/Nío"
    FIELD mo-codigo         AS INTEGER   FORMAT ">9"
    FIELD desc-mo           AS CHARACTER FORMAT "x(12)"
    FIELD val-desp          AS DECIMAL   FORMAT ">>>,>>>,>>9.99".

{exp/exapi015.i} /* Definiªío Temp-tables Rateio Despesas para as Entregas */
{cxbo/bocx358.i tt-proc-ped-ent-desp}
{cxbo/bocx205.i tt-proc-desp-itiner}
{include/boerrtab.i}

DEFINE TEMP-TABLE tt-despes-fatur NO-UNDO
    FIELD cdn-despes   LIKE ped-venda-desp.cdn-despes
    FIELD val-despes   LIKE ped-venda-desp.val-despes
    FIELD mo-codigo    LIKE ped-venda-desp.mo-codigo.

DEFINE VARIABLE h-bocx205           AS HANDLE                 NO-UNDO.
DEFINE VARIABLE r-chave             AS ROWID                  NO-UNDO.
DEFINE VARIABLE l-elimina-despesas  AS LOGICAL  INITIAL YES   NO-UNDO.
DEFINE VARIABLE c-return            AS CHARACTER              NO-UNDO.

DEFINE VARIABLE c-cod-estabel-origem LIKE processo-exp.cod-estabel   NO-UNDO.
DEFINE VARIABLE c-nr-proc-exp-origem LIKE processo-exp.nr-proc-exp   NO-UNDO.

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

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
         HEIGHT             = 7
         WIDTH              = 40.14.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AtualizaDespProcNota DBOProgram 
PROCEDURE AtualizaDespProcNota :
/*:T------------------------------------------------------------------------------
  Purpose:     Atualiza Despesas do Processo e das entregas do processo apartir da nota fiscal
  Parameters:  recebe o cod-estabel e nr-proc-exp
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER p-cod-estabel       LIKE processo-exp.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER p-nr-proc-exp       LIKE processo-exp.nr-proc-exp NO-UNDO.
    DEFINE INPUT PARAMETER pl-elimina-desp     AS   LOGICAL                  NO-UNDO.

    ASSIGN l-elimina-despesas = pl-elimina-desp.

    IF pl-elimina-desp THEN DO:
        RUN deleteDespProc IN THIS-PROCEDURE (INPUT p-cod-estabel,
                                              INPUT p-nr-proc-exp).
    END.
    
    RUN AtualizaDespProcNotaAux IN THIS-PROCEDURE (INPUT p-cod-estabel,
                                                   INPUT p-nr-proc-exp).

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AtualizaDespProcNotaAux DBOProgram 
PROCEDURE AtualizaDespProcNotaAux :
/*:T------------------------------------------------------------------------------
  Purpose:     Atualiza Despesas do Processo e das entregas do processo apartir da nota fiscal
  Parameters:  cod-estabel - Codigo do estabelecimento 
                           nr-proc-exp - Numero processo de exportacao
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cod-estabel       LIKE processo-exp.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER p-nr-proc-exp       LIKE processo-exp.nr-proc-exp NO-UNDO.

    FOR EACH tt-bo-erro:
        DELETE tt-bo-erro.
    END.

    FIND processo-exp WHERE
         processo-exp.cod-estabel = p-cod-estabel AND
         processo-exp.nr-proc-exp = p-nr-proc-exp EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL processo-exp THEN DO:
        FOR EACH proc-nota-fiscal WHERE 
                 proc-nota-fiscal.cod-estabel = processo-exp.cod-estabel AND
                 proc-nota-fiscal.nr-proc-exp = processo-exp.nr-proc-exp NO-LOCK:
            FIND nota-fiscal WHERE 
                 nota-fiscal.cod-estabel = proc-nota-fiscal.cod-estab-faturam AND
                 nota-fiscal.nr-nota-fis = proc-nota-fiscal.nr-nota-fis       AND
                 nota-fiscal.serie       = proc-nota-fiscal.serie             AND 
                 nota-fiscal.dt-cancela  = ? NO-LOCK NO-ERROR.
            IF AVAIL nota-fiscal THEN DO:
                FOR EACH it-nota-fisc WHERE 
                         it-nota-fisc.cod-estabel = nota-fiscal.cod-estabel AND
                         it-nota-fisc.nr-nota-fis = nota-fiscal.nr-nota-fis AND
                         it-nota-fisc.serie       = nota-fiscal.serie NO-LOCK:
                     FOR EACH  proc-it-nota-desp NO-LOCK
                         where proc-it-nota-desp.cod-estab-faturam = it-nota-fisc.cod-estabel
                         and   proc-it-nota-desp.serie             = it-nota-fisc.serie
                         and   proc-it-nota-desp.nr-nota-fis       = it-nota-fisc.nr-nota-fis
                         and   proc-it-nota-desp.nr-seq-fat        = it-nota-fisc.nr-seq-fat
                         and   proc-it-nota-desp.it-codigo         = it-nota-fisc.it-codigo:
                        
                        FIND tt-proc-ped-ent-desp WHERE
                             tt-proc-ped-ent-desp.cod-estabel   = proc-it-nota-desp.cod-estabel AND
                             tt-proc-ped-ent-desp.nr-proc-exp   = processo-exp.nr-proc-exp      AND
                             tt-proc-ped-ent-desp.nr-sequencia  = it-nota-fisc.nr-seq-ped       AND
                             tt-proc-ped-ent-desp.it-codigo     = it-nota-fisc.it-codigo        AND
                             tt-proc-ped-ent-desp.cod-refer     = it-nota-fisc.cod-refer        AND
                             tt-proc-ped-ent-desp.nome-abrev    = it-nota-fisc.nome-ab-cli      AND
                             tt-proc-ped-ent-desp.nr-pedcli     = it-nota-fisc.nr-pedcli        AND
                             tt-proc-ped-ent-desp.nr-entrega    = it-nota-fisc.nr-entrega       AND
                             tt-proc-ped-ent-desp.cdn-despes    = proc-it-nota-desp.cdn-despes  NO-ERROR.
                        IF AVAIL tt-proc-ped-ent-desp THEN DO:
                             ASSIGN tt-proc-ped-ent-desp.val-despes = tt-proc-ped-ent-desp.val-despes + proc-it-nota-desp.val-despes.
                        END.
                        ELSE DO:
                             create tt-proc-ped-ent-desp.
                             assign tt-proc-ped-ent-desp.cod-estabel   = p-cod-estabel
                                    tt-proc-ped-ent-desp.nr-proc-exp   = p-nr-proc-exp
                                    tt-proc-ped-ent-desp.nome-abrev    = it-nota-fisc.nome-ab-cli  
                                    tt-proc-ped-ent-desp.nr-pedcli     = it-nota-fisc.nr-pedcli   
                                    tt-proc-ped-ent-desp.nr-sequencia  = it-nota-fisc.nr-seq-ped
                                    tt-proc-ped-ent-desp.it-codigo     = it-nota-fisc.it-codigo   
                                    tt-proc-ped-ent-desp.cod-refer     = it-nota-fisc.cod-refer   
                                    tt-proc-ped-ent-desp.nr-entrega    = it-nota-fisc.nr-entrega  
                                    tt-proc-ped-ent-desp.cdn-despes    = proc-it-nota-desp.cdn-despes
                                    tt-proc-ped-ent-desp.val-despes    = proc-it-nota-desp.val-despes.
                        END.

                        FOR FIRST historico-proc-exp FIELDS(sequencia)
                            WHERE historico-proc-exp.cod-estabel   = proc-it-nota-desp.cod-estabel
                              AND historico-proc-exp.nr-proc-exp   = proc-it-nota-desp.nr-proc-exp
                              AND historico-proc-exp.cod-itiner    = proc-it-nota-desp.cod-itiner 
                              AND historico-proc-exp.cod-pto-contr = proc-it-nota-desp.cod-pto-contr NO-LOCK:

                            FIND FIRST tt-proc-desp-itiner
                                 WHERE tt-proc-desp-itiner.cod-estabel       = proc-it-nota-desp.cod-estabel
                                   AND tt-proc-desp-itiner.nr-proc-exp       = proc-it-nota-desp.nr-proc-exp
                                   AND tt-proc-desp-itiner.cod-itiner        = proc-it-nota-desp.cod-itiner
                                   AND tt-proc-desp-itiner.sequencia         = historico-proc-exp.sequencia 
                                   AND tt-proc-desp-itiner.cod-desp          = proc-it-nota-desp.cdn-despes
                                   AND tt-proc-desp-itiner.cod-emitente-desp = proc-it-nota-desp.cod-emitente-desp NO-ERROR.
                            IF  NOT AVAIL tt-proc-desp-itiner THEN DO:
                                CREATE tt-proc-desp-itiner.
                                ASSIGN tt-proc-desp-itiner.nr-proc-exp          = proc-it-nota-desp.nr-proc-exp
                                       tt-proc-desp-itiner.cod-estabel          = proc-it-nota-desp.cod-estabel
                                       tt-proc-desp-itiner.cod-itiner           = proc-it-nota-desp.cod-itiner
                                       tt-proc-desp-itiner.sequencia            = historico-proc-exp.sequencia 
                                       tt-proc-desp-itiner.cod-pto-contr        = proc-it-nota-desp.cod-pto-contr
                                       tt-proc-desp-itiner.cod-desp             = proc-it-nota-desp.cdn-despes
                                       tt-proc-desp-itiner.cod-emitente-desp    = proc-it-nota-desp.cod-emitente-desp
                                       tt-proc-desp-itiner.mo-codigo            = proc-it-nota-desp.mo-codigo
                                       tt-proc-desp-itiner.l-forma-preco        = proc-it-nota-desp.log-forma-preco
                                       tt-proc-desp-itiner.classif-despesa      = proc-it-nota-desp.cdn-classif-despes
                                       tt-proc-desp-itiner.cod-cond-pag         = proc-it-nota-desp.cod-cond-pag
                                       tt-proc-desp-itiner.log-despes-integr-ap = proc-it-nota-desp.log-despes-integr-ap
                                       tt-proc-desp-itiner.dat-base-cobr-despes = proc-it-nota-desp.dat-base-cobr-despes
                                       &IF "{&bf_dis_versao_ems}" >= "2.09":U &THEN
                                           tt-proc-desp-itiner.log-despes-inclusa = proc-it-nota-desp.log-despes-inclusa
                                           tt-proc-desp-itiner.log-destaca-despes = proc-it-nota-desp.log-destaca-despes
                                       &ELSE
                                           overlay(tt-proc-desp-itiner.char-1,1,1) = trim(substring(proc-it-nota-desp.cod-livre-1,1,1))
                                           overlay(tt-proc-desp-itiner.char-1,2,1) = trim(substring(proc-it-nota-desp.cod-livre-1,2,1))
                                       &ENDIF
                                       .
                            END.
                            
                            IF AVAIL tt-proc-desp-itiner THEN DO:
                                /* Busca a descriá∆o da despesa */
                                RUN piRetornaDescricaoDespesa IN THIS-PROCEDURE (INPUT proc-it-nota-desp.cod-estabel,
                                                                                 INPUT proc-it-nota-desp.nr-proc-exp,
                                                                                 INPUT proc-it-nota-desp.cod-itiner,
                                                                                 INPUT proc-it-nota-desp.cod-pto-contr,
                                                                                 INPUT proc-it-nota-desp.cdn-despes,
                                                                                 OUTPUT tt-proc-desp-itiner.descricao).
                                ASSIGN tt-proc-desp-itiner.val-desp = tt-proc-desp-itiner.val-desp + proc-it-nota-desp.val-despes.
                            END.
                        END.
                    END.
                END.
            END.
        END.

        FOR EACH tt-proc-ped-ent-desp:
           RUN openQueryStatic IN THIS-PROCEDURE (INPUT "Main":U).           
           RUN emptyRowErrors  IN THIS-PROCEDURE.
           RUN emptyRowObject  IN THIS-PROCEDURE.
           RUN setRecord       IN THIS-PROCEDURE (INPUT TABLE tt-proc-ped-ent-desp).
           RUN createRecord    IN THIS-PROCEDURE.
           
           DELETE tt-proc-ped-ent-desp.
        END.

        IF  NOT VALID-HANDLE(h-bocx205) THEN
            RUN cxbo/bocx205.p PERSISTENT SET h-bocx205.

        FOR EACH tt-proc-desp-itiner:
           IF NOT l-elimina-despesas THEN
               RUN setaCriacao IN h-bocx205 (INPUT YES).

           RUN openQuery       IN h-bocx205 (INPUT 1).           
           RUN setModoExecucao IN h-bocx205(input YES).
           RUN findPk_proc_desp_itiner IN h-bocx205 (INPUT tt-proc-desp-itiner.cod-estabel,
                                                     INPUT tt-proc-desp-itiner.nr-proc-exp,
                                                     INPUT tt-proc-desp-itiner.cod-itiner,
                                                     INPUT tt-proc-desp-itiner.sequencia,
                                                     INPUT tt-proc-desp-itiner.cod-pto-contr,
                                                     INPUT tt-proc-desp-itiner.cod-desp,
                                                     OUTPUT c-return).
           IF c-return <> "" THEN DO:
               RUN validateCreate  IN h-bocx205(input table tt-proc-desp-itiner, 
                                                output table tt-bo-erro, 
                                                output r-chave).
           END.
           ELSE DO:
               RUN pi-retorna-rowid IN h-bocx205 (OUTPUT r-chave).
               RUN validateUpdate   IN h-bocx205 (INPUT TABLE tt-proc-desp-itiner,
                                                  INPUT r-chave,
                                                  OUTPUT TABLE tt-bo-erro).
           END.
           DELETE tt-proc-desp-itiner.
        END.

        IF  VALID-HANDLE(h-bocx205) THEN DO:
            DELETE PROCEDURE h-bocx205.
            ASSIGN h-bocx205 = ?.
        END.

        ASSIGN processo-exp.log-1 = YES.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteDespProc DBOProgram 
PROCEDURE deleteDespProc :
/*:T------------------------------------------------------------------------------
  Purpose:     Elimina despesas do processo e das entregas do processo
  Parameters:  recebe cod-estabel e nr-proc-exp
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER p-cod-estabel       LIKE processo-exp.cod-estabel.
    DEFINE INPUT PARAMETER p-nr-proc-exp       LIKE processo-exp.nr-proc-exp.
    
    FOR EACH proc-ped-ent-desp WHERE 
             proc-ped-ent-desp.cod-estabel = p-cod-estabel AND
             proc-ped-ent-desp.nr-proc-exp = p-nr-proc-exp EXCLUSIVE-LOCK:
        DELETE proc-ped-ent-desp.
    END.

    FOR EACH proc-desp-itiner WHERE 
             proc-desp-itiner.cod-estabel = p-cod-estabel AND
             proc-desp-itiner.nr-proc-exp = p-nr-proc-exp EXCLUSIVE-LOCK:
        DELETE proc-desp-itiner.
    END.
    
    FIND processo-exp WHERE 
         processo-exp.cod-estabel = p-cod-estabel AND
         processo-exp.nr-proc-exp = p-nr-proc-exp EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL processo-exp THEN
        ASSIGN processo-exp.log-1 = NO.

    RELEASE processo-exp.

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
        WHEN "val-despes":U THEN ASSIGN pFieldValue = RowObject.val-despes.
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
        WHEN "cdn-despes":U THEN ASSIGN pFieldValue = RowObject.cdn-despes.
        WHEN "nr-entrega":U THEN ASSIGN pFieldValue = RowObject.nr-entrega.
        WHEN "nr-sequencia":U THEN ASSIGN pFieldValue = RowObject.nr-sequencia.
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
  Purpose:     Retorna valores dos campos do °ndice prcspdna-id
  Parameters:  
               retorna valor do campo cod-estabel
               retorna valor do campo nr-proc-exp
               retorna valor do campo nr-sequencia
               retorna valor do campo it-codigo
               retorna valor do campo cod-refer
               retorna valor do campo nome-abrev
               retorna valor do campo nr-pedcli
               retorna valor do campo nr-entrega
               retorna valor do campo cdn-despes
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE proc-ped-ent-desp.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-proc-exp LIKE proc-ped-ent-desp.nr-proc-exp NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-sequencia LIKE proc-ped-ent-desp.nr-sequencia NO-UNDO.
    DEFINE OUTPUT PARAMETER pit-codigo LIKE proc-ped-ent-desp.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-refer LIKE proc-ped-ent-desp.cod-refer NO-UNDO.
    DEFINE OUTPUT PARAMETER pnome-abrev LIKE proc-ped-ent-desp.nome-abrev NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-pedcli LIKE proc-ped-ent-desp.nr-pedcli NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-entrega LIKE proc-ped-ent-desp.nr-entrega NO-UNDO.
    DEFINE OUTPUT PARAMETER pcdn-despes LIKE proc-ped-ent-desp.cdn-despes NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-estabel = RowObject.cod-estabel
           pnr-proc-exp = RowObject.nr-proc-exp
           pnr-sequencia = RowObject.nr-sequencia
           pit-codigo = RowObject.it-codigo
           pcod-refer = RowObject.cod-refer
           pnome-abrev = RowObject.nome-abrev
           pnr-pedcli = RowObject.nr-pedcli
           pnr-entrega = RowObject.nr-entrega
           pcdn-despes = RowObject.cdn-despes.

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
  Purpose:     Reposiciona registro com base no °ndice prcspdna-id
  Parameters:  
               recebe valor do campo cod-estabel
               recebe valor do campo nr-proc-exp
               recebe valor do campo nr-sequencia
               recebe valor do campo it-codigo
               recebe valor do campo cod-refer
               recebe valor do campo nome-abrev
               recebe valor do campo nr-pedcli
               recebe valor do campo nr-entrega
               recebe valor do campo cdn-despes
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE proc-ped-ent-desp.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pnr-proc-exp LIKE proc-ped-ent-desp.nr-proc-exp NO-UNDO.
    DEFINE INPUT PARAMETER pnr-sequencia LIKE proc-ped-ent-desp.nr-sequencia NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo LIKE proc-ped-ent-desp.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-refer LIKE proc-ped-ent-desp.cod-refer NO-UNDO.
    DEFINE INPUT PARAMETER pnome-abrev LIKE proc-ped-ent-desp.nome-abrev NO-UNDO.
    DEFINE INPUT PARAMETER pnr-pedcli LIKE proc-ped-ent-desp.nr-pedcli NO-UNDO.
    DEFINE INPUT PARAMETER pnr-entrega LIKE proc-ped-ent-desp.nr-entrega NO-UNDO.
    DEFINE INPUT PARAMETER pcdn-despes LIKE proc-ped-ent-desp.cdn-despes NO-UNDO.

    FIND FIRST bfproc-ped-ent-desp WHERE 
        bfproc-ped-ent-desp.cod-estabel = pcod-estabel AND 
        bfproc-ped-ent-desp.nr-proc-exp = pnr-proc-exp AND 
        bfproc-ped-ent-desp.nr-sequencia = pnr-sequencia AND 
        bfproc-ped-ent-desp.it-codigo = pit-codigo AND 
        bfproc-ped-ent-desp.cod-refer = pcod-refer AND 
        bfproc-ped-ent-desp.nome-abrev = pnome-abrev AND 
        bfproc-ped-ent-desp.nr-pedcli = pnr-pedcli AND 
        bfproc-ped-ent-desp.nr-entrega = pnr-entrega AND 
        bfproc-ped-ent-desp.cdn-despes = pcdn-despes NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfproc-ped-ent-desp THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfproc-ped-ent-desp)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openqueryMain DBOProgram 
PROCEDURE openqueryMain :
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRateioDespesas DBOProgram 
PROCEDURE piRateioDespesas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE INPUT PARAMETER p-cod-estabel AS CHARACTER NO-UNDO.
   DEFINE INPUT PARAMETER p-nr-proc-exp AS CHARACTER NO-UNDO.
   define variable pde-quantidade       as dec init 0 no-undo.
      
   DEF VAR h-exapi015 AS HANDLE NO-UNDO.
   def var h-bocx195  as handle no-undo.
   
   DEF VAR de-despes-fatur LIKE ped-venda-desp.val-despes      NO-UNDO.
   DEF VAR de-valor-despes AS DECIMAL FORMAT "->>>,>>>,>>9.99" NO-UNDO.
   DEF VAR de-fator-conver AS   DECIMAL INITIAL 1              NO-UNDO.

   FIND processo-exp WHERE 
        processo-exp.cod-estabel = p-cod-estabel AND
        processo-exp.nr-proc-exp = p-nr-proc-exp NO-LOCK NO-ERROR.
   IF AVAIL processo-exp THEN
      IF processo-exp.log-1 THEN LEAVE.

   IF  NOT VALID-HANDLE(h-exapi015) THEN
       RUN exp/exapi015.p PERSISTENT SET h-exapi015.

   IF  NOT VALID-HANDLE(h-bocx195) THEN
       RUN cxbo/bocx195.p PERSISTENT SET h-bocx195.       

    /*Convers∆o do valor do volume do item*/
    FOR FIRST para-dis NO-LOCK:
        /*Unidade de Medida da Convers∆o 1 = Cent°metros 2 = Metros*/
        IF para-dis.int-1 = 1 THEN
            ASSIGN de-fator-conver = 0.000001.
        ELSE
            ASSIGN de-fator-conver = 1.
    END.

        EMPTY TEMP-TABLE tt-entrega.
        EMPTY TEMP-TABLE tt-proc-ped-ent-desp.
        
        FOR EACH proc-ped-ent-desp EXCLUSIVE-LOCK
           WHERE proc-ped-ent-desp.cod-estabel = p-cod-estabel
             AND proc-ped-ent-desp.nr-proc-exp = p-nr-proc-exp:
          DELETE proc-ped-ent-desp.
        END.

        FOR EACH proc-ped-ent WHERE 
                 proc-ped-ent.cod-estabel = p-cod-estabel AND
                 proc-ped-ent.nr-proc-exp = p-nr-proc-exp and 
                 proc-ped-ent.ind-componen <> 3 NO-LOCK:

            FIND FIRST ped-ent OF proc-ped-ent NO-LOCK NO-ERROR.
            IF AVAIL ped-ent THEN DO:
                FOR FIRST ITEM FIELDS(peso-liquido largura comprim altura)
                    WHERE ITEM.it-codigo = ped-ent.it-codigo NO-LOCK: 
                END.
                FIND FIRST ped-item OF ped-ent NO-LOCK NO-ERROR.

                run calculaQuantidadeAtendida in h-bocx195 (input  proc-ped-ent.cod-estabel,
                                                            input  proc-ped-ent.nr-proc-exp,
                                                            input  proc-ped-ent.nome-abrev,
                                                            input  proc-ped-ent.nr-pedcli,
                                                            input  proc-ped-ent.nr-sequencia,
                                                            input  proc-ped-ent.it-codigo,
                                                            input  proc-ped-ent.cod-refer,
                                                            input  proc-ped-ent.nr-entrega,
                                                            output pde-quantidade).
                
                CREATE tt-entrega.
                ASSIGN tt-entrega.nome-abrev   = ped-ent.nome-abrev
                       tt-entrega.nr-pedcli    = ped-ent.nr-pedcli 
                       tt-entrega.nr-sequencia = ped-ent.nr-sequencia
                       tt-entrega.it-codigo    = ped-ent.it-codigo   
                       tt-entrega.cod-refer    = ped-ent.cod-refer   
                       tt-entrega.nr-entrega   = ped-ent.nr-entrega  
                       /*tt-entrega.quantidade   = proc-ped-ent.quantidade[1] - ped-ent.qt-atendida /*Dranka*/*/
                       tt-entrega.quantidade   = proc-ped-ent.quantidade[1] - pde-quantidade
                       tt-entrega.valor        = proc-ped-ent.vl-preuni
                       tt-entrega.peso-liquido = (proc-ped-ent.peso-liquido / proc-ped-ent.quantidade[1]) * tt-entrega.quantidade
                       tt-entrega.volume       = IF AVAIL ITEM THEN (ITEM.largura * ITEM.comprim * ITEM.altura) * de-fator-conver ELSE 0.
                 
                FOR EACH proc-it-nota-fisc WHERE 
                         proc-it-nota-fisc.cod-estabel  = proc-ped-ent.cod-estabel  AND
                         proc-it-nota-fisc.nr-proc-exp  = proc-ped-ent.nr-proc-exp  AND
                         proc-it-nota-fisc.nome-abrev   = proc-ped-ent.nome-abrev   AND
                         proc-it-nota-fisc.nr-pedcli    = proc-ped-ent.nr-pedcli    AND
                         proc-it-nota-fisc.nr-sequencia = proc-ped-ent.nr-sequencia AND
                         proc-it-nota-fisc.it-codigo    = proc-ped-ent.it-codigo    AND
                         proc-it-nota-fisc.cod-refer    = proc-ped-ent.cod-refer    AND
                         proc-it-nota-fisc.nr-entrega   = proc-ped-ent.nr-entrega   NO-LOCK:

                    FIND FIRST it-nota-fisc WHERE
                               it-nota-fisc.cod-estabel = proc-it-nota-fisc.cod-estab-faturam AND
                               it-nota-fisc.serie       = proc-it-nota-fisc.serie       AND
                               it-nota-fisc.nr-nota-fis = proc-it-nota-fisc.nr-nota-fis AND
                               it-nota-fisc.nr-seq-fat  = proc-it-nota-fisc.nr-seq-fat  AND
                               it-nota-fisc.it-codigo   = proc-it-nota-fisc.it-codigo   NO-LOCK NO-ERROR.

                    IF AVAIL it-nota-fisc THEN DO:
                        FOR FIRST nota-fiscal FIELDS (dt-cancela) WHERE
                                  nota-fiscal.cod-estabel = it-nota-fisc.cod-estabel  AND
                                  nota-fiscal.nr-nota-fis = it-nota-fisc.nr-nota-fis  AND
                                  nota-fiscal.serie       = it-nota-fisc.serie        NO-LOCK:
                        END.
                        IF  AVAIL nota-fiscal 
                        AND nota-fiscal.dt-cancela  <> ? THEN NEXT.
                            
                        FOR EACH proc-it-nota-desp WHERE 
                                 proc-it-nota-desp.cod-estabel = proc-ped-ent.cod-estabel AND 
                                 proc-it-nota-desp.nr-proc-exp = proc-ped-ent.nr-proc-exp AND 
                                 proc-it-nota-desp.cod-estab-faturam = it-nota-fisc.cod-estabel AND 
                                 proc-it-nota-desp.serie       = it-nota-fisc.serie       AND 
                                 proc-it-nota-desp.nr-nota-fis = it-nota-fisc.nr-nota-fis AND 
                                 proc-it-nota-desp.nr-seq-fat  = it-nota-fisc.nr-seq-fat  AND 
                                 proc-it-nota-desp.it-codigo   = it-nota-fisc.it-codigo   NO-LOCK:
    
                            /*Acumula despesas j† faturadas totais por cod-desp*/
                            FIND tt-despes-fatur WHERE tt-despes-fatur.cdn-despes = proc-it-nota-desp.cdn-despes NO-ERROR.
                            IF NOT AVAIL tt-despes-fatur THEN DO:
                                CREATE tt-despes-fatur.
                                ASSIGN tt-despes-fatur.cdn-despes = proc-it-nota-desp.cdn-despes
                                       tt-despes-fatur.val-despes = proc-it-nota-desp.val-despes.
                            END.
                            ELSE DO:
                                ASSIGN tt-despes-fatur.val-despes = tt-despes-fatur.val-despes + proc-it-nota-desp.val-despes.                             
                            END.
                              
                            /*Cria temp-table de rateio para as despesas j† faturadas pois seu valor n∆o poder† ser alterado*/
                            FIND FIRST tt-proc-ped-ent-desp WHERE
                                       tt-proc-ped-ent-desp.cod-estabel   = p-cod-estabel               AND
                                       tt-proc-ped-ent-desp.nr-proc-exp   = p-nr-proc-exp               AND
                                       tt-proc-ped-ent-desp.nome-abrev    = it-nota-fisc.nome-ab-cli    AND
                                       tt-proc-ped-ent-desp.nr-pedcli     = it-nota-fisc.nr-pedcli      AND
                                       tt-proc-ped-ent-desp.nr-sequencia  = it-nota-fisc.nr-seq-ped     AND
                                       tt-proc-ped-ent-desp.it-codigo     = proc-it-nota-desp.it-codigo AND
                                       tt-proc-ped-ent-desp.cod-refer     = it-nota-fisc.cod-refer      AND
                                       tt-proc-ped-ent-desp.nr-entrega    = it-nota-fisc.nr-entrega     AND
                                       tt-proc-ped-ent-desp.cdn-despes    = proc-it-nota-desp.cdn-despes NO-LOCK NO-ERROR.
                            IF  NOT AVAIL tt-proc-ped-ent-desp THEN DO:
                             
                               CREATE tt-proc-ped-ent-desp.
                               ASSIGN tt-proc-ped-ent-desp.cod-estabel   = p-cod-estabel
                                      tt-proc-ped-ent-desp.nr-proc-exp   = p-nr-proc-exp
                                      tt-proc-ped-ent-desp.nome-abrev    = it-nota-fisc.nome-ab-cli  
                                      tt-proc-ped-ent-desp.nr-pedcli     = it-nota-fisc.nr-pedcli   
                                      tt-proc-ped-ent-desp.nr-sequencia  = it-nota-fisc.nr-seq-ped
                                      tt-proc-ped-ent-desp.it-codigo     = proc-it-nota-desp.it-codigo   
                                      tt-proc-ped-ent-desp.cod-refer     = it-nota-fisc.cod-refer   
                                      tt-proc-ped-ent-desp.nr-entrega    = it-nota-fisc.nr-entrega  
                                      tt-proc-ped-ent-desp.cdn-despes    = proc-it-nota-desp.cdn-despes.
                            END.
    
                            ASSIGN tt-proc-ped-ent-desp.val-despes = tt-proc-ped-ent-desp.val-despes + proc-it-nota-desp.val-despes.
    
                        END.
                    END.
                END.
            END.
        END.
    
        EMPTY TEMP-TABLE tt-despesa.

        FOR EACH proc-desp-itiner
           WHERE proc-desp-itiner.cod-estabel = p-cod-estabel
             AND proc-desp-itiner.nr-proc-exp = p-nr-proc-exp NO-LOCK:

            FIND tt-despes-fatur WHERE tt-despes-fatur.cdn-despes = proc-desp-itiner.cod-desp NO-ERROR.
            IF AVAIL tt-despes-fatur THEN 
                ASSIGN de-despes-fatur = tt-despes-fatur.val-despes.
            ELSE ASSIGN de-despes-fatur = 0.
            
            ASSIGN de-valor-despes = (proc-desp-itiner.val-desp - de-despes-fatur).
            IF de-valor-despes < 0 THEN de-valor-despes = 0.

            IF de-valor-despes <> 0 THEN DO:
                CREATE tt-despesa.
                ASSIGN tt-despesa.cdn-despes = proc-desp-itiner.cod-desp
                       tt-despesa.val-despes = de-valor-despes
                       tt-despesa.mo-codigo  = proc-desp-itiner.mo-codigo.
            END.
        END.
    
        EMPTY TEMP-TABLE tt-despes-fatur.
        EMPTY TEMP-TABLE tt-param.

        FOR FIRST ped-venda-cex FIELDS(volume)
            WHERE ped-venda-cex.nr-pedido = ped-venda.nr-pedido NO-LOCK:
            CREATE tt-param.
            ASSIGN tt-param.campo = "Volume":U
                   tt-param.valor = ped-venda-cex.volume.
        END.
    
        RUN geraTTPedEntDesp IN h-exapi015 (INPUT  TABLE tt-entrega,
                                            INPUT  TABLE tt-despesa,
                                            INPUT  TABLE tt-param,
                                            OUTPUT TABLE tt-despes-entr).
    
        FOR EACH tt-despes-entr:
            /*Verifica se j† existe um registro na temp-table de rateio, se existir quer dizer que esta despesa ja foi faturada parcialmente
              sendo assim somente dever† ser acumulado o valor rateado em aberto*/
            FIND tt-proc-ped-ent-desp WHERE
                 tt-proc-ped-ent-desp.cod-estabel   = p-cod-estabel               AND
                 tt-proc-ped-ent-desp.nr-proc-exp   = p-nr-proc-exp               AND
                 tt-proc-ped-ent-desp.nr-sequencia  = tt-despes-entr.nr-sequencia AND
                 tt-proc-ped-ent-desp.it-codigo     = tt-despes-entr.it-codigo    AND
                 tt-proc-ped-ent-desp.cod-refer     = tt-despes-entr.cod-refer    AND
                 tt-proc-ped-ent-desp.nome-abrev    = tt-despes-entr.nome-abrev   AND
                 tt-proc-ped-ent-desp.nr-pedcli     = tt-despes-entr.nr-pedcli    AND
                 tt-proc-ped-ent-desp.nr-entrega    = tt-despes-entr.nr-entrega   AND
                 tt-proc-ped-ent-desp.cdn-despes    = tt-despes-entr.cdn-despes   NO-ERROR.
            IF AVAIL tt-proc-ped-ent-desp THEN DO:
                ASSIGN tt-proc-ped-ent-desp.val-despes = tt-proc-ped-ent-desp.val-despes + tt-despes-entr.val-despes.
            END.
            ELSE DO:
                create tt-proc-ped-ent-desp.
                assign tt-proc-ped-ent-desp.cod-estabel   = p-cod-estabel
                       tt-proc-ped-ent-desp.nr-proc-exp   = p-nr-proc-exp
                       tt-proc-ped-ent-desp.nome-abrev    = tt-despes-entr.nome-abrev  
                       tt-proc-ped-ent-desp.nr-pedcli     = tt-despes-entr.nr-pedcli   
                       tt-proc-ped-ent-desp.nr-sequencia  = tt-despes-entr.nr-sequencia
                       tt-proc-ped-ent-desp.it-codigo     = tt-despes-entr.it-codigo   
                       tt-proc-ped-ent-desp.cod-refer     = tt-despes-entr.cod-refer   
                       tt-proc-ped-ent-desp.nr-entrega    = tt-despes-entr.nr-entrega  
                       tt-proc-ped-ent-desp.cdn-despes    = tt-despes-entr.cdn-despes
                       tt-proc-ped-ent-desp.val-despes    = tt-despes-entr.val-despes.
            END.
        END.
        
        FOR EACH tt-proc-ped-ent-desp:
           RUN openQueryStatic IN THIS-PROCEDURE (INPUT "Main":U).           
           RUN emptyRowErrors  IN THIS-PROCEDURE.
           RUN emptyRowObject  IN THIS-PROCEDURE.
           RUN setRecord       IN THIS-PROCEDURE (INPUT TABLE tt-proc-ped-ent-desp).
           RUN createRecord    IN THIS-PROCEDURE.
           
           DELETE tt-proc-ped-ent-desp.
        END.

        FIND processo-exp WHERE 
             processo-exp.cod-estabel = p-cod-estabel AND
             processo-exp.nr-proc-exp = p-nr-proc-exp EXCLUSIVE-LOCK NO-ERROR.
        IF AVAIL processo-exp THEN
            ASSIGN processo-exp.log-1 = YES.
        
        IF  VALID-HANDLE (h-exapi015) THEN DO:
            DELETE PROCEDURE h-exapi015.
            ASSIGN h-exapi015 = ?.
        END.

        IF  VALID-HANDLE (h-bocx195) THEN DO:
            DELETE PROCEDURE h-bocx195.
            ASSIGN h-bocx195 = ?.
        END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRetornaDescricaoDespesa DBOProgram 
PROCEDURE piRetornaDescricaoDespesa :
/*------------------------------------------------------------------------------
  Purpose:  Retornar descriá∆o da despesa.
  Parameters: INPUT p-cod-estabel  : Estabelecimento do processo de exportaá∆o (CHARACTER)
              INPUT p-nr-proc-exp  : N£mero do processo de exportaá∆o          (CHARACTER)
              INPUT p-cod-itiner   : Itiner†rio do processo                    (INTEGER)
              INPUT p-cod-pto-contr: C¢digo de controle da despesa             (INTEGER)
              INPUT p-cod-desp     : C¢digo da despesa                         (INTEGER)
              OUTPUT p-descricao   : Descriá∆o da despesa                      (CHARACTER)
  Notes:    Tenta localizar proc-desp-itiner para retornar a descriá∆o. 
            Caso n∆o consiga localizar ou a descriá∆o esteja em branco, busca a descriá∆o padr∆o. (desp-imp)
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cod-estabel       LIKE processo-exp.cod-estabel        NO-UNDO. 
    DEFINE INPUT PARAMETER p-nr-proc-exp       LIKE processo-exp.nr-proc-exp        NO-UNDO. 
    DEFINE INPUT PARAMETER p-cod-itiner        LIKE proc-desp-itiner.cod-itiner     NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-pto-contr     LIKE proc-desp-itiner.cod-pto-contr  NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-desp          LIKE proc-desp-itiner.cod-desp       NO-UNDO.
    DEFINE OUTPUT PARAMETER p-descricao        LIKE proc-desp-itiner.descricao      NO-UNDO.

    /* Se os valores do processo origem n∆o estiverem preenchidos, utiliza os valores recebidos por parÉmetro */
    IF TRIM(c-cod-estabel-origem) = "":U THEN
        ASSIGN c-cod-estabel-origem = p-cod-estabel.
    IF TRIM(c-nr-proc-exp-origem) = "":U THEN
        ASSIGN c-nr-proc-exp-origem = p-nr-proc-exp.

    FOR FIRST proc-desp-itiner FIELDS(descricao) NO-LOCK
        WHERE proc-desp-itiner.cod-estabel   = c-cod-estabel-origem 
          AND proc-desp-itiner.nr-proc-exp   = c-nr-proc-exp-origem 
          AND proc-desp-itiner.cod-itiner    = p-cod-itiner   
          AND proc-desp-itiner.cod-pto-contr = p-cod-pto-contr
          AND proc-desp-itiner.cod-desp      = p-cod-desp:   
        ASSIGN p-descricao = proc-desp-itiner.descricao.
    END.

    IF TRIM(p-descricao) = "":U OR NOT AVAIL proc-desp-itiner THEN DO:
        FOR FIRST desp-imp FIELDS(descricao) NO-LOCK
            WHERE desp-imp.cod-desp = p-cod-desp:
            ASSIGN p-descricao = desp-imp.descricao.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRetornaDespesasFaturadas DBOProgram 
PROCEDURE piRetornaDespesasFaturadas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE INPUT PARAMETER p-cod-estabel AS CHARACTER NO-UNDO.
   DEFINE INPUT PARAMETER p-nr-proc-exp AS CHARACTER NO-UNDO.
   DEFINE INPUT PARAMETER p-cod-desp    AS INTEGER   NO-UNDO.
   DEFINE OUTPUT PARAMETER TABLE FOR tt-despes-fatur.
   
   DEF VAR de-despes-fatur LIKE ped-venda-desp.val-despes NO-UNDO.
   DEF VAR de-valor-despes AS DECIMAL FORMAT "->>>,>>>,>>9.99" NO-UNDO.

   def var de-qt-fatur     like it-nota-fisc.qt-faturada[1] no-undo.
   def var de-tot-devol    like devol-cli.qt-devolvida      no-undo.

   EMPTY TEMP-TABLE tt-proc-ped-ent-desp.
    
   IF p-cod-desp <> 0 THEN DO:
      FOR EACH proc-it-nota-desp WHERE
               proc-it-nota-desp.cod-estabel  = p-cod-estabel AND
               proc-it-nota-desp.nr-proc-exp  = p-nr-proc-exp AND
               proc-it-nota-desp.cdn-despes   = p-cod-desp NO-LOCK:
         FIND FIRST nota-fiscal WHERE 
                    nota-fiscal.cod-estabel   = proc-it-nota-desp.cod-estab-faturam AND
                    nota-fiscal.serie         = proc-it-nota-desp.serie       AND 
                    nota-fiscal.nr-nota-fis   = proc-it-nota-desp.nr-nota-fis NO-LOCK NO-ERROR.
         IF AVAIL nota-fiscal
         AND nota-fiscal.dt-cancela <> ? THEN NEXT. /*Desconsidera notas canceladas*/

         assign de-tot-devol = 0
                de-qt-fatur  = 0.
         for each it-nota-fisc fields (qt-faturada) no-lock
            where it-nota-fisc.cod-estabel = proc-it-nota-desp.cod-estab-faturam
              and it-nota-fisc.serie       = proc-it-nota-desp.serie
              and it-nota-fisc.nr-nota-fis = proc-it-nota-desp.nr-nota-fis
              and it-nota-fisc.nr-seq-fat  = proc-it-nota-desp.nr-seq-fat
              and it-nota-fisc.it-codigo   = proc-it-nota-desp.it-codigo:
             assign de-qt-fatur   = de-qt-fatur  + it-nota-fisc.qt-faturada[1].
         end.                  
         for each devol-cli fields(vl-devol qt-devolvida) no-lock
            where devol-cli.cod-estabel  = proc-it-nota-desp.cod-estab-faturam    
              and devol-cli.serie        = proc-it-nota-desp.serie                
              and devol-cli.nr-nota-fis  = proc-it-nota-desp.nr-nota-fis          
              and devol-cli.nr-sequencia = proc-it-nota-desp.nr-seq-fat           
              and devol-cli.it-codigo    = proc-it-nota-desp.it-codigo:           
              assign de-tot-devol = de-tot-devol + devol-cli.qt-devolvida.
         end.

         /*Acumula despesas j† faturadas totais por cod-desp*/
         FIND tt-despes-fatur WHERE tt-despes-fatur.cdn-despes = proc-it-nota-desp.cdn-despes NO-ERROR.
         IF NOT AVAIL tt-despes-fatur THEN DO:
             CREATE tt-despes-fatur.
             ASSIGN tt-despes-fatur.cdn-despes = proc-it-nota-desp.cdn-despes
                    tt-despes-fatur.val-despes = proc-it-nota-desp.val-despes - (proc-it-nota-desp.val-despes * de-tot-devol / de-qt-fatur).
         END.
         ELSE DO:
             ASSIGN tt-despes-fatur.val-despes = tt-despes-fatur.val-despes + 
                                                 proc-it-nota-desp.val-despes - (proc-it-nota-desp.val-despes * de-tot-devol / de-qt-fatur).
         END.

      END.
   END.
   ELSE DO:
       FOR EACH proc-it-nota-desp WHERE
                proc-it-nota-desp.cod-estabel  = p-cod-estabel AND
                proc-it-nota-desp.nr-proc-exp  = p-nr-proc-exp NO-LOCK:
           FIND FIRST nota-fiscal WHERE 
                      nota-fiscal.cod-estabel   = proc-it-nota-desp.cod-estab-faturam AND
                      nota-fiscal.serie         = proc-it-nota-desp.serie       AND 
                      nota-fiscal.nr-nota-fis   = proc-it-nota-desp.nr-nota-fis NO-LOCK NO-ERROR.
           IF AVAIL nota-fiscal
           AND nota-fiscal.dt-cancela <> ? THEN NEXT. /*Desconsidera notas canceladas*/

          assign de-tot-devol = 0
                 de-qt-fatur  = 0.
          for each it-nota-fisc fields (qt-faturada) no-lock
             where it-nota-fisc.cod-estabel = proc-it-nota-desp.cod-estab-faturam
               and it-nota-fisc.serie       = proc-it-nota-desp.serie
               and it-nota-fisc.nr-nota-fis = proc-it-nota-desp.nr-nota-fis
               and it-nota-fisc.nr-seq-fat  = proc-it-nota-desp.nr-seq-fat
               and it-nota-fisc.it-codigo   = proc-it-nota-desp.it-codigo:
              assign de-qt-fatur   = de-qt-fatur  + it-nota-fisc.qt-faturada[1].
          end.                  
          for each devol-cli fields(vl-devol) no-lock
             where devol-cli.cod-estabel  = it-nota-fisc.cod-estabel
               and devol-cli.serie        = it-nota-fisc.serie      
               and devol-cli.nr-nota-fis  = it-nota-fisc.nr-nota-fis
               and devol-cli.nr-sequencia = it-nota-fisc.nr-seq-fat 
               and devol-cli.it-codigo    = it-nota-fisc.it-codigo:
               assign de-tot-devol = de-tot-devol + devol-cli.qt-devolvida.
          end.

          /*Acumula despesas j† faturadas totais por cod-desp*/
          FIND tt-despes-fatur WHERE tt-despes-fatur.cdn-despes = proc-it-nota-desp.cdn-despes NO-ERROR.
          IF NOT AVAIL tt-despes-fatur THEN DO:
              CREATE tt-despes-fatur.
              ASSIGN tt-despes-fatur.cdn-despes = proc-it-nota-desp.cdn-despes
                     tt-despes-fatur.val-despes = proc-it-nota-desp.val-despes - (proc-it-nota-desp.val-despes * de-tot-devol / de-qt-fatur).
          END.
          ELSE DO:
              ASSIGN tt-despes-fatur.val-despes = tt-despes-fatur.val-despes + 
                                                  proc-it-nota-desp.val-despes - (proc-it-nota-desp.val-despes * de-tot-devol / de-qt-fatur).
          END.
      END.
   END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRetornaDespesasFaturadasPedido DBOProgram 
PROCEDURE piRetornaDespesasFaturadasPedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-nome-abrev  AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER p-nr-pedcli   AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-despes  AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER de-val-despes AS DECIMAL   NO-UNDO.

    ASSIGN de-val-despes = 0.

    FOR EACH it-nota-fisc WHERE
             it-nota-fisc.nome-ab-cli = p-nome-abrev AND
             it-nota-fisc.nr-pedcli   = p-nr-pedcli  NO-LOCK:

        FIND FIRST nota-fiscal WHERE 
                   nota-fiscal.cod-estabel   = it-nota-fisc.cod-estabel AND 
                   nota-fiscal.serie         = it-nota-fisc.serie       AND 
                   nota-fiscal.nr-nota-fis   = it-nota-fisc.nr-nota-fis NO-LOCK NO-ERROR.
    
        IF  AVAIL nota-fiscal 
        AND nota-fiscal.dt-cancela <> ? THEN NEXT. /*Desconsidera notas canceladas*/

        FOR EACH proc-it-nota-desp WHERE
                 proc-it-nota-desp.cod-estab-faturam = it-nota-fisc.cod-estabel AND
                 proc-it-nota-desp.serie       = it-nota-fisc.serie       AND
                 proc-it-nota-desp.nr-nota-fis = it-nota-fisc.nr-nota-fis AND
                 proc-it-nota-desp.nr-seq-fat  = it-nota-fisc.nr-seq-fat  AND
                 proc-it-nota-desp.it-codigo   = it-nota-fisc.it-codigo   AND
                 proc-it-nota-desp.cdn-despes  = p-cod-despes NO-LOCK:

            ASSIGN de-val-despes = de-val-despes + proc-it-nota-desp.val-despes.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSetaProcessoOrigem DBOProgram 
PROCEDURE piSetaProcessoOrigem :
/*------------------------------------------------------------------------------
  Purpose:  Armazena o processo de exportaá∆o origem do subprocesso.    
  Parameters:  INPUT  p-cod-estabel : Estabelecimento do processo origem
               INPUT  p-nr-proc-exp : N£mero do processo origem
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cod-estabel       LIKE processo-exp.cod-estabel        NO-UNDO.
    DEFINE INPUT PARAMETER p-nr-proc-exp       LIKE processo-exp.nr-proc-exp        NO-UNDO.    

    ASSIGN c-cod-estabel-origem = p-cod-estabel
           c-nr-proc-exp-origem = p-nr-proc-exp.
                  
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ValidaDeleteDespProc DBOProgram 
PROCEDURE ValidaDeleteDespProc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pc-cod-estabel LIKE processo-exp.cod-estabel NO-UNDO.
    DEFINE INPUT  PARAMETER pc-nr-proc-exp LIKE processo-exp.nr-proc-exp NO-UNDO.
    DEFINE OUTPUT PARAMETER pl-existe-desp AS   LOGICAL                  NO-UNDO.

    FIND FIRST processo-exp
         WHERE processo-exp.cod-estabel = pc-cod-estabel
           AND processo-exp.nr-proc-exp = pc-nr-proc-exp NO-LOCK NO-ERROR.
    IF AVAIL processo-exp THEN DO:
        IF CAN-FIND(FIRST proc-desp-itiner 
                    WHERE proc-desp-itiner.cod-estabel = processo-exp.cod-estabel
                      AND proc-desp-itiner.nr-proc-exp = processo-exp.nr-proc-exp) THEN DO:
            FOR EACH proc-nota-fiscal WHERE 
                     proc-nota-fiscal.cod-estabel = processo-exp.cod-estabel AND
                     proc-nota-fiscal.nr-proc-exp = processo-exp.nr-proc-exp NO-LOCK:
                FIND nota-fiscal WHERE 
                     nota-fiscal.cod-estabel = proc-nota-fiscal.cod-estab-faturam AND
                     nota-fiscal.nr-nota-fis = proc-nota-fiscal.nr-nota-fis AND
                     nota-fiscal.serie       = proc-nota-fiscal.serie       AND 
                     nota-fiscal.dt-cancela  = ? NO-LOCK NO-ERROR. /* Considera somente notas fiscais nao canceladas */
                IF AVAIL nota-fiscal THEN DO:
                    FOR EACH it-nota-fisc WHERE 
                             it-nota-fisc.cod-estabel = nota-fiscal.cod-estabel AND
                             it-nota-fisc.nr-nota-fis = nota-fiscal.nr-nota-fis AND
                             it-nota-fisc.serie       = nota-fiscal.serie NO-LOCK:
                        IF NOT CAN-FIND(FIRST proc-it-nota-desp
                                        WHERE proc-it-nota-desp.cod-estab-faturam = it-nota-fisc.cod-estabel
                                          AND proc-it-nota-desp.serie       = it-nota-fisc.serie
                                          AND proc-it-nota-desp.nr-nota-fis = it-nota-fisc.nr-nota-fis
                                          AND proc-it-nota-desp.nr-seq-fat  = it-nota-fisc.nr-seq-fat
                                          AND proc-it-nota-desp.it-codigo   = it-nota-fisc.it-codigo) THEN DO:
                            ASSIGN pl-existe-desp = NO.
                            LEAVE.
                        END.
                        ELSE DO:
                            ASSIGN pl-existe-desp = YES.
                            LEAVE.
                        END.
                    END.
                END.
            END.
        END.
        ELSE
            ASSIGN pl-existe-desp = YES.

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
    
    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piVerificaPontoDespesa DBOProgram 
PROCEDURE piVerificaPontoDespesa :
/*:T------------------------------------------------------------------------------
  Purpose:     Verifica se o ponto de controle da despesa existe no 
               acompanhamento do subprocesso de exportacao
  Parameters:  Entrada: Estabelecimento do Processo
               Entrada: SubProcesso de Exportacao
               Sa°da: tt-erro
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pc-cod-estabel    LIKE processo-exp.cod-estabel        NO-UNDO.
    DEFINE INPUT  PARAMETER pc-subprocesso    LIKE processo-exp.nr-proc-exp        NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-desc-pto-contr AS   CHARACTER                       NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-desc-despesa   AS   CHARACTER                       NO-UNDO.
    DEFINE OUTPUT PARAMETER pl-existe         AS   LOGICAL                         NO-UNDO.
    
    DEFINE BUFFER bf-proc-it-nota-desp FOR proc-it-nota-desp.

    DEFINE VARIABLE c-descricao-despesa      AS CHARACTER                         NO-UNDO.
    DEFINE VARIABLE c-return                 AS CHARACTER                         NO-UNDO.
    DEFINE VARIABLE h-bocx200                AS HANDLE                            NO-UNDO.
    DEFINE VARIABLE h-bocx110                AS HANDLE                            NO-UNDO.

    IF NOT VALID-HANDLE(h-bocx200) THEN
        RUN cxbo/bocx200.p PERSISTENT SET h-bocx200.

    IF NOT VALID-HANDLE(h-bocx110) THEN
        RUN cxbo/bocx110.p PERSISTENT SET h-bocx110.

    FOR FIRST processo-exp NO-LOCK
        WHERE processo-exp.cod-estabel = pc-cod-estabel
          AND processo-exp.nr-proc-exp = c-nr-proc-exp-origem:
    END.
    
    ASSIGN pl-existe = YES.
    FOR EACH bf-proc-it-nota-desp
       WHERE bf-proc-it-nota-desp.cod-estabel = processo-exp.cod-estabel
         AND bf-proc-it-nota-desp.nr-proc-exp = processo-exp.nr-proc-exp
         AND bf-proc-it-nota-desp.cod-itiner  = processo-exp.cod-itiner:

        IF NOT CAN-FIND(FIRST historico-proc-exp
                        WHERE historico-proc-exp.cod-estabel   = pc-cod-estabel
                          AND historico-proc-exp.nr-proc-exp   = pc-subprocesso
                          AND historico-proc-exp.cod-itiner    = bf-proc-it-nota-desp.cod-itiner
                          AND historico-proc-exp.cod-pto-contr = bf-proc-it-nota-desp.cod-pto-contr) THEN DO:

            RUN findCh_proc_pto_itiner IN h-bocx200 (INPUT bf-proc-it-nota-desp.cod-estabel,  
                                                     INPUT bf-proc-it-nota-desp.nr-proc-exp,  
                                                     INPUT bf-proc-it-nota-desp.cod-itiner,   
                                                     INPUT bf-proc-it-nota-desp.cod-pto-contr,
                                                     OUTPUT c-return).
            IF c-return = "":U THEN DO:
                RUN getCharField IN h-bocx200 (INPUT "descricao":U, OUTPUT pc-desc-pto-contr).
                IF pc-desc-pto-contr <> "":U THEN
                    ASSIGN pc-desc-pto-contr = STRING(bf-proc-it-nota-desp.cod-pto-contr) + " - " + pc-desc-pto-contr.
            END.
            ELSE DO:
                RUN findCodigo IN h-bocx110 (INPUT bf-proc-it-nota-desp.cod-pto-contr, OUTPUT c-return).
                IF c-return = "":U THEN
                    RUN getCharField IN h-bocx110 (INPUT "descricao":U, OUTPUT pc-desc-pto-contr).
                ASSIGN pc-desc-pto-contr = STRING(bf-proc-it-nota-desp.cod-pto-contr) + " - ":U + pc-desc-pto-contr.
            END.


            RUN piRetornaDescricaoDespesa IN THIS-PROCEDURE (INPUT bf-proc-it-nota-desp.cod-estabel,
                                                             INPUT bf-proc-it-nota-desp.nr-proc-exp,
                                                             INPUT bf-proc-it-nota-desp.cod-itiner,
                                                             INPUT bf-proc-it-nota-desp.cod-pto-contr,
                                                             INPUT bf-proc-it-nota-desp.cdn-despes,
                                                             OUTPUT c-descricao-despesa).
            ASSIGN pc-desc-despesa  = string(bf-proc-it-nota-desp.cdn-despes) + " - " + c-descricao-despesa
                   pl-existe        = NO.

            LEAVE.
        END.
        ELSE
            ASSIGN pl-existe = YES.
    END.

    IF VALID-HANDLE(h-bocx200) THEN DO:
        DELETE PROCEDURE h-bocx200.
        ASSIGN h-bocx200 = ?.
    END.

    IF VALID-HANDLE(h-bocx110) THEN DO:
        DELETE PROCEDURE h-bocx110.
        ASSIGN h-bocx110 = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
