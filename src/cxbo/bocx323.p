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
{include/i-prgvrs.i BOCX323 2.00.00.012 } /*** "010012" 07/10/2024 16:59:56 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bocx323 MUT}
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
{cdp/cdcfgcex.i}
{cdp/cdcfgdis.i}

/*--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOCX323
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName ped-venda-desp
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

&GLOBAL-DEFINE XMLReceiver YES    /* DBO atua como receiver de mensagens enviado pelo Message Broker (mÇtodo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /* Nome da Query que d† acessos a todos os registros, exceto os exclu°dos pela constraint de seguranáa. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /* Informar os campos da chave quando o Progress n∆o conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{cxbo/bocx323.i RowObject}
{cxbo/bocx160.i tt-ped-venda-cex}
{dibo/bodi159.i tt-ped-venda}
{cxbo/bocx323.i tt-ped-venda-desp}

DEF VAR h-bocx358 AS HANDLE NO-UNDO.
DEF VAR c-return1 AS CHAR NO-UNDO.

/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE i-sequencia-atual AS INTEGER    NO-UNDO.
DEFINE VARIABLE iNrPedido         AS INTEGER    NO-UNDO.
define variable c-function        as char       no-undo.
DEFINE VARIABLE i-sequencia       AS INTEGER    NO-UNDO.
DEFINE VARIABLE l-validate-desp   AS LOGICAL    INIT TRUE NO-UNDO.

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
         HEIGHT             = 2.21
         WIDTH              = 28.14.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraDespesas DBOProgram 
PROCEDURE geraDespesas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcod-itiner AS INT  NO-UNDO.
DEFINE INPUT PARAMETER pnome-abrev AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pnr-pedcli  AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pnum-pedido AS INT  NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt-ped-venda-desp.

EMPTY TEMP-TABLE tt-ped-venda-desp.

 FOR EACH desp-itiner NO-LOCK
    WHERE desp-itiner.cod-itiner = pcod-itiner:

     CREATE tt-ped-venda-desp.
     ASSIGN tt-ped-venda-desp.nome-abrev    = pnome-abrev
            tt-ped-venda-desp.nr-pedcli     = pnr-pedcli
            tt-ped-venda-desp.num-pedido    = pnum-pedido
            tt-ped-venda-desp.cod-itiner    = desp-itiner.cod-itiner   
            tt-ped-venda-desp.cod-pto-contr = desp-itiner.cod-pto-contr
            tt-ped-venda-desp.cdn-despes    = desp-itiner.cod-desp
            i-sequencia                     = i-sequencia + 1 
            tt-ped-venda-desp.sequencia     = i-sequencia
            tt-ped-venda-desp.log-despes-integr-ap = NO.

     &IF '{&bf_cex_versao_ems}' >= '2.062' &THEN
         FOR FIRST desp-imp FIELDS(cod-emitente inc-val-frete inc-val-seguro inc-val-embal char-1)
             WHERE desp-imp.cod-desp = desp-itiner.cod-desp NO-LOCK:

             &IF "{&bf_dis_versao_ems}":U >= "2.062":U &THEN
                 ASSIGN tt-ped-venda-desp.cod-emitente-desp  = desp-imp.cod-emitente.
             &ELSE
                 ASSIGN tt-ped-venda-desp.cod-emitente-desp  = int(substring(desp-imp.char-1,1,9)).
             &ENDIF
    
             IF  desp-imp.inc-val-frete THEN
                 ASSIGN tt-ped-venda-desp.cdn-classif-despes = 2.
             ELSE
                 IF  desp-imp.inc-val-seguro THEN
                     ASSIGN tt-ped-venda-desp.cdn-classif-despes = 3.
                 ELSE
                     IF  desp-imp.inc-val-embal THEN
                         ASSIGN tt-ped-venda-desp.cdn-classif-despes = 4.
                     ELSE
                         ASSIGN tt-ped-venda-desp.cdn-classif-despes = 1.

             FOR FIRST emitente
                 WHERE emitente.cod-emitente = tt-ped-venda-desp.cod-emitente-desp NO-LOCK:
                 ASSIGN tt-ped-venda-desp.cod-cond-pag = emitente.cod-cond-pag.
             END.

             FIND FIRST ped-venda-cex
                  WHERE ped-venda-cex.nome-abrev = pnome-abrev
                    AND ped-venda-cex.nr-pedcli  = pnr-pedcli NO-LOCK NO-ERROR.

             IF AVAIL ped-venda-cex THEN DO:
                 FOR EACH desp-incoterm NO-LOCK
                    WHERE desp-incoterm.cod-incoterm = ped-venda-cex.cod-incoterm
                      AND desp-incoterm.cod-desp     = tt-ped-venda-desp.cdn-despes:

                    &IF "{&bf_dis_versao_ems}" >= "2.09":U &THEN
                        ASSIGN tt-ped-venda-desp.log-despesa-inclusa = desp-incoterm.log-despes-inclusa
                               tt-ped-venda-desp.log-destaca-despesa = desp-incoterm.log-destaca-despes.
                    &ELSE
                        ASSIGN OVERLAY(tt-ped-venda-desp.cod-livre-1,1,1) = trim(substring(desp-incoterm.char-1,1,1))
                               OVERLAY(tt-ped-venda-desp.cod-livre-1,2,1) = trim(substring(desp-incoterm.char-1,2,1)).
                    &ENDIF
                 END.
                 IF NOT CAN-FIND(FIRST desp-incoterm
                                 WHERE desp-incoterm.cod-incoterm = ped-venda-cex.cod-incoterm
                                   AND desp-incoterm.cod-desp     = tt-ped-venda-desp.cdn-despes) THEN DO:
                    &IF "{&bf_dis_versao_ems}" >= "2.09":U &THEN
                        ASSIGN tt-ped-venda-desp.log-despesa-inclusa = NO
                               tt-ped-venda-desp.log-destaca-despesa = YES.
                    &ELSE
                        ASSIGN OVERLAY(tt-ped-venda-desp.cod-livre-1,1,1) = "2":U
                               OVERLAY(tt-ped-venda-desp.cod-livre-1,2,1) = "1".
                    &ENDIF

                 END.
             END.
         END.
         
     &ENDIF
 END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraDespesas-incoterm DBOProgram 
PROCEDURE geraDespesas-incoterm :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcod-incoterm AS CHAR NO-UNDO.
DEFINE INPUT  PARAMETER pnome-abrev   AS CHAR NO-UNDO.
DEFINE INPUT  PARAMETER pnr-pedcli    AS CHAR NO-UNDO.
DEFINE INPUT  PARAMETER pnum-pedido   AS INT  NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt-ped-venda-desp.

    FOR EACH  desp-incoterm NO-LOCK
        WHERE desp-incoterm.cod-incoterm = pcod-incoterm:
    
        find first tt-ped-venda-desp 
            where  tt-ped-venda-desp.nome-abrev = pnome-abrev
            and    tt-ped-venda-desp.nr-pedcli  = pnr-pedcli
            and    tt-ped-venda-desp.cdn-despes = desp-incoterm.cod-desp no-error.
        if  not avail tt-ped-venda-desp then do:
            create tt-ped-venda-desp.
            assign tt-ped-venda-desp.nome-abrev = pnome-abrev
                   tt-ped-venda-desp.nr-pedcli  = pnr-pedcli
                   tt-ped-venda-desp.cdn-despes = desp-incoterm.cod-desp
                   tt-ped-venda-desp.num-pedido = pnum-pedido
                   i-sequencia                  = i-sequencia + 1
                   tt-ped-venda-desp.sequencia  = i-sequencia
                   tt-ped-venda-desp.log-despes-integr-ap = NO.

            &IF '{&bf_cex_versao_ems}' >= '2.062' &THEN
                FOR FIRST desp-imp FIELDS(cod-emitente inc-val-frete inc-val-seguro inc-val-embal char-1)
                    WHERE desp-imp.cod-desp = desp-incoterm.cod-desp NO-LOCK:
    
                    &IF "{&bf_dis_versao_ems}":U >= "2.062":U &THEN
                        ASSIGN tt-ped-venda-desp.cod-emitente-desp  = desp-imp.cod-emitente.
                    &ELSE
                        ASSIGN tt-ped-venda-desp.cod-emitente-desp  = int(substring(desp-imp.char-1,1,9)).
                    &ENDIF
        
                    IF  desp-imp.inc-val-frete THEN
                        ASSIGN tt-ped-venda-desp.cdn-classif-despes = 2.
                    ELSE
                        IF  desp-imp.inc-val-seguro THEN
                            ASSIGN tt-ped-venda-desp.cdn-classif-despes = 3.
                        ELSE
                            IF  desp-imp.inc-val-embal THEN
                                ASSIGN tt-ped-venda-desp.cdn-classif-despes = 4.
                            ELSE
                                ASSIGN tt-ped-venda-desp.cdn-classif-despes = 1.
    
                    FOR FIRST emitente
                        WHERE emitente.cod-emitente = tt-ped-venda-desp.cod-emitente-desp NO-LOCK:
                        ASSIGN tt-ped-venda-desp.cod-cond-pag = emitente.cod-cond-pag.
                    END.
    
                    &IF "{&bf_dis_versao_ems}" >= "2.09":U &THEN
                       ASSIGN tt-ped-venda-desp.log-despesa-inclusa = desp-incoterm.log-despes-inclusa
                              tt-ped-venda-desp.log-destaca-despesa = desp-incoterm.log-destaca-despes.
                   &ELSE
                       ASSIGN OVERLAY(tt-ped-venda-desp.cod-livre-1,1,1) = trim(substring(desp-incoterm.char-1,1,1))
                              OVERLAY(tt-ped-venda-desp.cod-livre-1,2,1) = trim(substring(desp-incoterm.char-1,2,1)).
                   &ENDIF
                END.
            &ENDIF
        END.
        ELSE DO:
            &IF "{&bf_dis_versao_ems}" >= "2.09":U &THEN
               ASSIGN tt-ped-venda-desp.log-despesa-inclusa = desp-incoterm.log-despes-inclusa
                      tt-ped-venda-desp.log-destaca-despesa = desp-incoterm.log-destaca-despes.
            &ELSE
               ASSIGN OVERLAY(tt-ped-venda-desp.cod-livre-1,1,1) = trim(substring(desp-incoterm.char-1,1,1))
                      OVERLAY(tt-ped-venda-desp.cod-livre-1,2,1) = trim(substring(desp-incoterm.char-1,2,1)).
            &ENDIF
        END.
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
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "contato":U THEN ASSIGN pFieldValue = RowObject.contato.
        WHEN "nome-abrev":U THEN ASSIGN pFieldValue = RowObject.nome-abrev.
        WHEN "nr-pedcli":U THEN ASSIGN pFieldValue = RowObject.nr-pedcli.
        WHEN "nr-tab":U THEN ASSIGN pFieldValue = RowObject.nr-tab.
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
        WHEN "dat-cotac-despes":U THEN ASSIGN pFieldValue = RowObject.dat-cotac-despes.
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
        WHEN "val-min-desc":U THEN ASSIGN pFieldValue = RowObject.val-min-desc.
        WHEN "val-min-despes":U THEN ASSIGN pFieldValue = RowObject.val-min-despes.
        WHEN "val-perc-desc":U THEN ASSIGN pFieldValue = RowObject.val-perc-desc.
        WHEN "val-perc-tax":U THEN ASSIGN pFieldValue = RowObject.val-perc-tax.
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
        WHEN "cdn-classif-despes":U THEN ASSIGN pFieldValue = RowObject.cdn-classif-despes.
        WHEN "cdn-despes":U THEN ASSIGN pFieldValue = RowObject.cdn-despes.
        WHEN "cod-cond-pag":U THEN ASSIGN pFieldValue = RowObject.cod-cond-pag.
        WHEN "cod-emitente-desp":U THEN ASSIGN pFieldValue = RowObject.cod-emitente-desp.
        WHEN "cod-itiner":U THEN ASSIGN pFieldValue = RowObject.cod-itiner.
        WHEN "cod-pto-contr":U THEN ASSIGN pFieldValue = RowObject.cod-pto-contr.
        WHEN "mo-codigo":U THEN ASSIGN pFieldValue = RowObject.mo-codigo.
        WHEN "num-dias-tax":U THEN ASSIGN pFieldValue = RowObject.num-dias-tax.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "num-pedido":U THEN ASSIGN pFieldValue = RowObject.num-pedido.
        WHEN "sequencia":U THEN ASSIGN pFieldValue = RowObject.sequencia.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice pdvddsps-01
  Parameters:  
               retorna valor do campo nome-abrev
               retorna valor do campo nr-pedcli
               retorna valor do campo cdn-despes
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnome-abrev LIKE ped-venda-desp.nome-abrev NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-pedcli LIKE ped-venda-desp.nr-pedcli NO-UNDO.
    DEFINE OUTPUT PARAMETER pcdn-despes LIKE ped-venda-desp.cdn-despes NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnome-abrev = RowObject.nome-abrev
           pnr-pedcli  = RowObject.nr-pedcli
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
        WHEN "log-confirmada":U       THEN ASSIGN pFieldValue = RowObject.log-confirmada.
        WHEN "log-forma-preco":U      THEN ASSIGN pFieldValue = RowObject.log-forma-preco.
        &IF DEFINED(bf_comex206b-1) &THEN
            WHEN "log-despes-integr-ap":U THEN ASSIGN pFieldValue = RowObject.log-despes-integr-ap.
        &ENDIF
        WHEN "log-livre-1":U          THEN ASSIGN pFieldValue = RowObject.log-livre-1.
        WHEN "log-livre-2":U          THEN ASSIGN pFieldValue = RowObject.log-livre-2.
        WHEN "log-tax-financ":U       THEN ASSIGN pFieldValue = RowObject.log-tax-financ.
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
  Purpose:     Reposiciona registro com base no °ndice pdvddsps-01
  Parameters:  
               recebe valor do campo nome-abrev
               recebe valor do campo nr-pedcli
               recebe valor do campo cdn-despes
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnome-abrev LIKE ped-venda-desp.nome-abrev NO-UNDO.
    DEFINE INPUT PARAMETER pnr-pedcli LIKE ped-venda-desp.nr-pedcli NO-UNDO.
    DEFINE INPUT PARAMETER pcdn-despes LIKE ped-venda-desp.cdn-despes NO-UNDO.

    FIND FIRST bfped-venda-desp WHERE 
        bfped-venda-desp.nome-abrev = pnome-abrev AND 
        bfped-venda-desp.nr-pedcli = pnr-pedcli AND 
        bfped-venda-desp.cdn-despes = pcdn-despes NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfped-venda-desp THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfped-venda-desp)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

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
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK.
    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOfPedVenda DBOProgram 
PROCEDURE openQueryOfPedVenda :
/*------------------------------------------------------------------------------
  Purpose: Criado na engenharia do PD4050
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH {&TableName} 
                               WHERE {&TableName}.num-pedido = iNrPedido NO-LOCK.

    RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOfPedVendaCex DBOProgram 
PROCEDURE openQueryOfPedVendaCex :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF NOT AVAIL ped-venda-cex THEN
    RETURN "NOK".

OPEN QUERY {&QueryName} FOR EACH  {&TableName} 
                            WHERE {&TableName}.num-pedido = ped-venda-cex.nr-pedido NO-LOCK.
    RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retorna-despesas DBOProgram 
PROCEDURE retorna-despesas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        DEFINE INPUT  PARAMETER pr-ped-venda-cex      AS   ROWID                     NO-UNDO.
        DEFINE OUTPUT PARAMETER pde-vl-frete-nac      LIKE ped-venda-desp.val-despes NO-UNDO.
        DEFINE OUTPUT PARAMETER pde-vl-frete-internac LIKE ped-venda-desp.val-despes NO-UNDO.
        DEFINE OUTPUT PARAMETER pde-vl-seguro         LIKE ped-venda-desp.val-despes NO-UNDO.
        DEFINE OUTPUT PARAMETER pde-vl-embalagem      LIKE ped-venda-desp.val-despes NO-UNDO.
                                                                               
        /* Vari†veis aux para realizar os c†lculos */
        DEFINE  VARIABLE de-vl-despesa         LIKE ped-venda-desp.val-despes   NO-UNDO.
        DEFINE  VARIABLE de-vl-taxa-pedido     LIKE ped-venda-desp.val-despes NO-UNDO.
        DEFINE  VARIABLE de-vl-taxa-despesa    LIKE ped-venda-desp.val-despes NO-UNDO.
        DEFINE  VARIABLE de-vl-despesa-convert LIKE ped-venda-desp.val-despes NO-UNDO.

        DEF VAR de-vl-frete-nac      LIKE ped-venda-desp.val-despes NO-UNDO.
        DEF VAR de-vl-frete-internac LIKE ped-venda-desp.val-despes NO-UNDO.
        DEF VAR de-vl-seguro         LIKE ped-venda-desp.val-despes NO-UNDO.
        DEF VAR de-vl-embalagem      LIKE ped-venda-desp.val-despes NO-UNDO.

        def var i-mo-codigo like moeda.mo-codigo           no-undo.
        def var da-dt-cotacao as date                      no-undo.
        
        FIND FIRST ped-venda-cex                                           
             WHERE ROWID(ped-venda-cex) = pr-ped-venda-cex NO-LOCK NO-ERROR. 

        for first ped-venda fields(nr-pedido nome-abrev nr-pedcli) no-lock 
            where ped-venda.nr-pedido  = ped-venda-cex.nr-pedido :
        end.
        
        if avail ped-venda then do:
            find ped-venda no-lock 
                where ped-venda.nome-abrev = ped-venda-cex.nome-abrev 
                  and ped-venda.nr-pedcli  = ped-venda-cex.nr-pedcli use-index ch-pedido no-error.
            if avail ped-venda then do:
                for first moeda fields(sigla mo-codigo) no-lock 
                    where moeda.mo-codigo = ped-venda.mo-codigo:
                end.
                if avail moeda then
                    assign i-mo-codigo = moeda.mo-codigo.
            end. 
        end.

        for each ped-venda-desp no-lock
           WHERE ped-venda-desp.num-pedido = ped-venda.nr-pedido
             and ped-venda-desp.log-forma-preco = yes:
        
            /* Somente considera despesas que est∆o marcadas para "Destacar Depesa" */
            &IF "{&bf_dis_versao_ems}" >= "2.09":U &THEN
                if ped-venda-desp.log-destaca-despes THEN DO:
            &ELSE                                       
                if trim(substring(ped-venda-desp.cod-livre-1,2,1)) = "1":U THEN DO:
            &ENDIF
        
                ASSIGN de-vl-despesa-convert = 0
                       de-vl-despesa-convert = ped-venda-desp.val-despes.
                
                 if ped-venda-desp.mo-codigo <> i-mo-codigo then do:

                    {pdp/pd9100.i "ped-venda.mo-codigo"
                                  "ped-venda.dt-emissao"
                                  "de-vl-taxa-pedido"}
                    IF  NOT AVAIL cotacao THEN
                        ASSIGN de-vl-taxa-pedido = 1.
        
                    {pdp/pd9100.i "ped-venda-desp.mo-codigo"
                                  "ped-venda.dt-emissao"
                                  "de-vl-taxa-despesa"}
                    IF  NOT AVAIL cotacao THEN
                        ASSIGN de-vl-taxa-despesa = 1.
        
                    IF  de-vl-taxa-pedido <> ?
                    and de-vl-taxa-despesa <> ? THEN
                        ASSIGN de-vl-despesa-convert = de-vl-despesa-convert * (de-vl-taxa-despesa / de-vl-taxa-pedido).
                 end.

                ASSIGN de-vl-despesa = 0.

                &IF "{&bf_dis_versao_ems}" >= "2.09":U &THEN
                    if ped-venda-desp.log-destaca-despes then
                &ELSE                                       
                    if trim(substring(ped-venda-desp.cod-livre-1,2,1)) = "1":U then
                &ENDIF
                       assign de-vl-despesa = de-vl-despesa-convert.
                    ELSE
                       ASSIGN de-vl-despesa = 0.
        
                 CASE ped-venda-desp.cdn-classif-despes:
                     WHEN 2 THEN DO: /*Frete*/
                         FIND FIRST desp-imp
                              WHERE desp-imp.cod-desp = ped-venda-desp.cdn-despes NO-LOCK NO-ERROR.

                         IF AVAIL desp-imp THEN DO:
                             IF trim(substring(desp-imp.char-1,19,1)) = "" THEN DO: /*Frete Nacional de Exportaá∆o*/ 
                                 ASSIGN de-vl-frete-nac = de-vl-frete-nac + de-vl-despesa.
                             END.
                             ELSE 
                                 IF int(trim(substring(desp-imp.char-1,19,1))) = 1 THEN DO:  /*Frete Internacional de Exportaá∆o*/
                                     ASSIGN de-vl-frete-internac = de-vl-frete-internac + de-vl-despesa.
                                 END.
                         END.
                
                     END.
                     WHEN 3 THEN DO: /*Seguro*/
                         ASSIGN de-vl-seguro = de-vl-seguro + de-vl-despesa.
                
                     END.
                     WHEN 4 THEN DO: /*Embalagem*/
                         ASSIGN de-vl-embalagem = de-vl-embalagem + de-vl-despesa.
                
                     END.
                 END.

                 ASSIGN pde-vl-frete-nac       = de-vl-frete-nac      
                        pde-vl-frete-internac  = de-vl-frete-internac 
                        pde-vl-seguro          = de-vl-seguro         
                        pde-vl-embalagem       = de-vl-embalagem.     
                 
             END.
        END.
         
     RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintOfPedVenda DBOProgram 
PROCEDURE setConstraintOfPedVenda :
/*------------------------------------------------------------------------------
  Purpose: Criado na engenharia do PD4050
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-nr-pedido AS INTEGER    NO-UNDO.

    ASSIGN iNrPedido = p-nr-pedido.

    RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintOfPedVendaCex DBOProgram 
PROCEDURE setConstraintOfPedVendaCex :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER r-ped-venda-cex AS ROWID      NO-UNDO.
FIND ped-venda-cex WHERE ROWID(ped-venda-cex) = r-ped-venda-cex NO-LOCK NO-ERROR.

IF AVAIL ped-venda-cex THEN
    RETURN "OK":U.
ELSE
    RETURN "NOK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setCurrentSequence DBOProgram 
PROCEDURE setCurrentSequence :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER i-sequencia AS INTEGER    NO-UNDO.
ASSIGN i-sequencia-atual = i-sequencia.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setFunction DBOProgram 
PROCEDURE setFunction :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   def input parameter p-function as char no-undo.

   assign c-function = p-function.

END procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setValidateDesp DBOProgram 
PROCEDURE setValidateDesp :
/*------------------------------------------------------------------------------
  Purpose:     Seta a vari†vel que informa se deve ou n∆o fazer as validaá‰es 
                das despesas
  Parameters:  
               pValidaDesp -> Se valida ou n∆o as despesas, por padr∆o vai
               estar como TRUE, se n∆o quizer que valide informar FALSE
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pValidaDesp AS LOGICAL NO-UNDO.

    ASSIGN l-validate-desp = pValidaDesp.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updatePedVendaDesp DBOProgram 
PROCEDURE updatePedVendaDesp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR RowObjectAux.
DEFINE INPUT        PARAMETER TABLE FOR tt-ped-venda.
DEFINE INPUT        PARAMETER TABLE FOR tt-ped-venda-cex.
DEFINE OUTPUT       PARAMETER TABLE FOR rowErrors.

FIND FIRST rowObject        NO-ERROR.
FIND FIRST tt-ped-venda     NO-ERROR.
FIND FIRST tt-ped-venda-cex NO-ERROR.

FOR EACH rowErrors:
    DELETE rowErrors.
END.

    FOR EACH ped-venda-desp OF tt-ped-venda NO-LOCK:
        FIND FIRST rowObjectAux WHERE 
                   rowObjectAux.num-pedido  = ped-venda-desp.num-pedido and
                   rowObjectAux.cdn-despes  = ped-venda-desp.cdn-despes EXCLUSIVE-LOCK NO-ERROR.

        IF AVAIL rowObjectAux THEN DO:
            /* Tabela espelho no comex */
            FOR FIRST proc-desp-itiner WHERE 
                       proc-desp-itiner.cod-estabel       = tt-ped-venda.cod-estabel AND
                       proc-desp-itiner.nr-proc-exp       = tt-ped-venda.nr-invoice  AND
                       proc-desp-itiner.cod-itiner        = tt-ped-venda-cex.cod-itiner AND
                       proc-desp-itiner.cod-pto-contr     = ped-venda-desp.cod-pto-contr AND 
                       proc-desp-itiner.cod-emitente-desp = ped-venda-desp.cod-emitente-desp 
                       EXCLUSIVE-LOCK:
                   ASSIGN proc-desp-itiner.cod-estabel          = tt-ped-venda.cod-estabel 
                          proc-desp-itiner.nr-proc-exp          = tt-ped-venda.nr-invoice  
                          proc-desp-itiner.cod-itiner           = tt-ped-venda-cex.cod-itiner 
                          proc-desp-itiner.cod-pto-contr        = ped-venda-desp.cod-pto-contr  
                          proc-desp-itiner.cod-emitente-desp    = ped-venda-desp.cod-emitente-desp
                          proc-desp-itiner.classif-despesa      = ped-venda-desp.cdn-classif-despes
                          proc-desp-itiner.cod-desp             = ped-venda-desp.cdn-despes 
                          proc-desp-itiner.data-cotacao-desp    = ped-venda-desp.dat-cotac-despes
                          proc-desp-itiner.confirmada           = ped-venda-desp.log-confirmada
                          proc-desp-itiner.l-forma-preco        = ped-venda-desp.log-forma-preco
                          proc-desp-itiner.taxa-financ          = ped-venda-desp.log-tax-financ
                          proc-desp-itiner.nr-dias-taxa         = ped-venda-desp.num-dias-tax
                          proc-desp-itiner.val-desp             = ped-venda-desp.val-despes
                          proc-desp-itiner.val-min              = ped-venda-desp.val-min-desc
                          proc-desp-itiner.val-min-desp         = ped-venda-desp.val-min-despes
                          proc-desp-itiner.perc-descto          = ped-venda-desp.val-perc-desc
                          proc-desp-itiner.perc-taxa            = ped-venda-desp.val-perc-tax
                   &IF DEFINED(bf_comex206b-1) &THEN
                          proc-desp-itiner.log-despes-integr-ap = ped-venda-desp.log-despes-integr-ap
                   &ENDIF 
                   
                   &IF "{&bf_dis_versao_ems}" >= "2.09":U &THEN
                          proc-desp-itiner.log-despes-inclusa  = ped-venda-desp.log-despesa-inclusa
                          proc-desp-itiner.log-destaca-despes  = ped-venda-desp.log-destaca-despesa
                          proc-desp-itiner.log-val-tot-faturam = ped-venda-desp.log-val-tot-faturam

                   &ELSE
                          overlay(proc-desp-itiner.char-1,1,1) = TRIM(SUBSTRING(ped-venda-desp.cod-livre-1,1,1))
                          overlay(proc-desp-itiner.char-1,2,1) = TRIM(SUBSTRING(ped-venda-desp.cod-livre-1,2,1))
                          overlay(proc-desp-itiner.char-1,3,1) = TRIM(SUBSTRING(ped-venda-desp.cod-livre-1,3,1))
                   &ENDIF   
                .
                   BUFFER-COPY ped-venda-desp TO proc-desp-itiner.
            END.

            RUN repositionRecord (INPUT ROWID(ped-venda-desp)).
            RUN setRecord (INPUT TABLE rowObjectAux).
            RUN updateRecord.
            DELETE rowObjectAux.
        END.
        ELSE DO:
            FOR FIRST proc-desp-itiner WHERE 
                      proc-desp-itiner.cod-estabel       = tt-ped-venda.cod-estabel AND
                      proc-desp-itiner.nr-proc-exp       = tt-ped-venda.nr-invoice  AND
                      proc-desp-itiner.cod-itiner        = tt-ped-venda-cex.cod-itiner AND
                      proc-desp-itiner.cod-pto-contr     = ped-venda-desp.cod-pto-contr AND 
                      proc-desp-itiner.cod-emitente-desp = ped-venda-desp.cod-emitente-desp 
                      EXCLUSIVE-LOCK:
                DELETE proc-desp-itiner.
            END.

            RUN repositionRecord (INPUT ROWID(ped-venda-desp)).
            RUN setRecord (INPUT TABLE rowObjectAux).
            RUN deleteRecord.
        END.
    END.

    FOR EACH rowObjectAux:
        IF NOT CAN-FIND (FIRST proc-desp-itiner WHERE 
                               proc-desp-itiner.cod-estabel       = tt-ped-venda.cod-estabel     AND
                               proc-desp-itiner.nr-proc-exp       = tt-ped-venda.nr-invoice      AND
                               proc-desp-itiner.cod-itiner        = tt-ped-venda-cex.cod-itiner  AND
                               proc-desp-itiner.cod-pto-contr     = rowObjectAux.cod-pto-contr   AND 
                               proc-desp-itiner.cod-emitente-desp = rowObjectAux.cod-emitente-desp)
                               THEN DO:
          CREATE proc-desp-itiner.
          ASSIGN proc-desp-itiner.cod-estabel          = tt-ped-venda.cod-estabel 
                 proc-desp-itiner.nr-proc-exp          = tt-ped-venda.nr-invoice  
                 proc-desp-itiner.cod-itiner           = tt-ped-venda-cex.cod-itiner 
                 proc-desp-itiner.cod-pto-contr        = rowObjectAux.cod-pto-contr  
                 proc-desp-itiner.cod-emitente-desp    = rowObjectAux.cod-emitente-desp
                 proc-desp-itiner.classif-despesa      = rowObjectAux.cdn-classif-despes
                 proc-desp-itiner.cod-desp             = rowObjectAux.cdn-despes 
                 proc-desp-itiner.data-cotacao-desp    = rowObjectAux.dat-cotac-despes
                 proc-desp-itiner.confirmada           = rowObjectAux.log-confirmada
                 proc-desp-itiner.l-forma-preco        = rowObjectAux.log-forma-preco
                 proc-desp-itiner.taxa-financ          = rowObjectAux.log-tax-financ
                 proc-desp-itiner.nr-dias-taxa         = rowObjectAux.num-dias-tax
                 proc-desp-itiner.val-desp             = rowObjectAux.val-despes
                 proc-desp-itiner.val-min              = rowObjectAux.val-min-desc
                 proc-desp-itiner.val-min-desp         = rowObjectAux.val-min-despes
                 proc-desp-itiner.perc-descto          = rowObjectAux.val-perc-desc
                 proc-desp-itiner.perc-taxa            = rowObjectAux.val-perc-tax
                 &IF DEFINED(bf_comex206b-1) &THEN
                     proc-desp-itiner.log-despes-integr-ap = rowObjectAux.log-despes-integr-ap
                 &ENDIF
                 &IF "{&bf_dis_versao_ems}" >= "2.09":U &THEN
                      proc-desp-itiner.log-despes-inclusa = rowObjectAux.log-despesa-inclusa
                      proc-desp-itiner.log-destaca-despes = rowObjectAux.log-destaca-despesa
                      proc-desp-itiner.log-val-tot-faturam = rowObjectAux.log-val-tot-faturam   
                 &ELSE
                      overlay(proc-desp-itiner.char-1,1,1) = TRIM(SUBSTRING(rowObjectAux.cod-livre-1,1,1))
                      overlay(proc-desp-itiner.char-1,2,1) = TRIM(SUBSTRING(rowObjectAux.cod-livre-1,2,1)) 
                      overlay(proc-desp-itiner.char-1,3,1) = TRIM(SUBSTRING(rowObjectAux.cod-livre-1,3,1))
                 &ENDIF
                 .
          
          BUFFER-COPY rowObjectAux TO proc-desp-itiner.
        END.
        RUN setRecord (INPUT TABLE rowObjectAux).
        RUN createRecord IN THIS-PROCEDURE.
        DELETE rowObjectAux.
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

    /*--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as validaá‰es ---*/
    
    IF NOT l-validate-desp THEN
        RETURN "OK":U.

    FIND FIRST ped-venda-cex NO-LOCK
         WHERE ped-venda-cex.nome-abrev = rowObject.nome-abrev
           AND ped-venda-cex.nr-pedcli  = rowObject.nr-pedcli NO-ERROR.
    FOR EACH tt-ped-venda-cex:
        DELETE tt-ped-venda-cex.
    END.
    IF AVAIL ped-venda-cex THEN DO:
        CREATE tt-ped-venda-cex.
        BUFFER-COPY ped-venda-cex TO tt-ped-venda-cex.
        ASSIGN tt-ped-venda-cex.r-rowid = ROWID(ped-venda-cex).
        RUN validateRowObject IN THIS-PROCEDURE (INPUT TABLE tt-ped-venda-cex,
                                                 INPUT TABLE RowObject).
    END.


    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRowObject DBOProgram 
PROCEDURE validateRowObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER TABLE FOR tt-ped-venda-cex.
DEFINE INPUT PARAMETER TABLE FOR RowObject.

    EMPTY TEMP-TABLE RowErrors.

    DEF VAR de-val-despes-fatur AS DEC NO-UNDO.

    FIND FIRST tt-ped-venda-cex NO-ERROR.

    IF i-sequencia-atual > 0 
    THEN FIND FIRST RowObject WHERE rowObject.sequencia = i-sequencia-atual NO-ERROR.
    ELSE FIND FIRST RowObject NO-ERROR.
    
    FIND FIRST pto-contr NO-LOCK
         WHERE pto-contr.cod-pto-contr = RowObject.cod-pto-contr NO-ERROR.
    IF NOT AVAIL pto-contr THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-ponto-de-controle AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Ponto_de_Controle" *}
        ASSIGN c-lbl-liter-ponto-de-controle = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i &ErrorNumber="2"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="Error":U
                                    &ErrorParameters="c-lbl-liter-ponto-de-controle"}
        
    END.

    FIND FIRST pto-itiner NO-LOCK
         WHERE pto-itiner.cod-itiner    = RowObject.cod-itiner
           AND pto-itiner.cod-pto-contr = RowObject.cod-pto-contr NO-ERROR.

    IF NOT AVAIL pto-itiner THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="30785"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="Error":U
                                    &ErrorParameters=" string(RowObject.cod-pto-contr) + '~~~~' + string(RowObject.cdn-despes) + '~~~~' + string(RowObject.cod-itiner)"}
    END.

    IF  RowObject.cod-emitente-desp = 0 THEN DO:
       /* Inicio -- Projeto Internacional */
       DEFINE VARIABLE c-lbl-liter-fornecedor-despesa AS CHARACTER NO-UNDO.
       {utp/ut-liter.i "Fornecedor_Despesa" *}
       ASSIGN c-lbl-liter-fornecedor-despesa = TRIM(RETURN-VALUE).
       {method/svc/errors/inserr.i
                    &ErrorNumber="265"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="c-lbl-liter-fornecedor-despesa"}
    END.
    ELSE DO:
        FIND FIRST emitente NO-LOCK
             WHERE emitente.cod-emitente = RowObject.cod-emitente-desp NO-ERROR.
        IF NOT AVAIL emitente THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-fornecedor-despesa-2 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Fornecedor_Despesa" *}
            ASSIGN c-lbl-liter-fornecedor-despesa-2 = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="Error":U
                                        &ErrorParameters="c-lbl-liter-fornecedor-despesa-2"}
                                       
        END.
        ELSE 
            IF emitente.identific = 1 THEN DO:
               /* Inicio -- Projeto Internacional */
               DEFINE VARIABLE c-lbl-liter-emitente AS CHARACTER NO-UNDO.
               {utp/ut-liter.i "Emitente" *}
               ASSIGN c-lbl-liter-emitente = TRIM(RETURN-VALUE).
               {method/svc/errors/inserr.i &ErrorNumber="25370"  /* emitente n∆o Ç fornecedor */
                                           &ErrorType="EMS":U
                                           &ErrorSubType="Error":U
                                           &ErrorParameters="c-lbl-liter-emitente"}
            END.
    END.

    FIND FIRST desp-imp NO-LOCK
         WHERE desp-imp.cod-desp = RowObject.cdn-despes NO-ERROR.
    IF NOT AVAIL desp-imp THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-despesa-de-exportacao AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Despesa_de_Exportaá∆o" *}
        ASSIGN c-lbl-liter-despesa-de-exportacao = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i &ErrorNumber="2"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="Error":U
                                    &ErrorParameters="c-lbl-liter-despesa-de-exportacao"}
    END.

    FIND FIRST moeda NO-LOCK
         WHERE moeda.mo-codigo = RowObject.mo-codigo NO-ERROR.
    IF NOT AVAIL moeda THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-moeda AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Moeda" *}
        ASSIGN c-lbl-liter-moeda = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i &ErrorNumber="2"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="Error":U
                                    &ErrorParameters="c-lbl-liter-moeda"}
    END.

    IF RowObject.cod-cond-pag > 0 THEN
    IF NOT CAN-FIND(FIRST cond-pagto WHERE cond-pagto.cod-cond-pag = RowObject.cod-cond-pag) THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-condicao-de-pagamento AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Condiá∆o_de_Pagamento" *}
        ASSIGN c-lbl-liter-condicao-de-pagamento = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i &ErrorNumber="2"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="Error":U
                                    &ErrorParameters="c-lbl-liter-condicao-de-pagamento"}
    END.
    
    IF RowObject.cdn-classif-despes < 1 OR
       RowObject.cdn-classif-despes > 4 THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-classificacao-da-despesa AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Classificaá∆o_da_Despesa" *}
        ASSIGN c-lbl-liter-classificacao-da-despesa = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-01nenhum-02frete-03seguro-ou-0 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "01=Nenhum,_02=Frete,_03=Seguro_ou_04=Embalagem" *}
        ASSIGN c-lbl-liter-01nenhum-02frete-03seguro-ou-0 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i &ErrorNumber="17541"
                                    &ErrorType="EMS"
                                    &ErrorSubType="Error"
                                    &ErrorParameters="c-lbl-liter-classificacao-da-despesa + '~~~~' + c-lbl-liter-01nenhum-02frete-03seguro-ou-0"}
    END.
    
    IF RowObject.val-despes <= 0 THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-valor-da-despesa AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Valor_da_Despesa" *}
        ASSIGN c-lbl-liter-valor-da-despesa = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i &ErrorNumber="36"
                                    &ErrorType="EMS"
                                    &ErrorSubType="Error"
                                    &ErrorParameters="c-lbl-liter-valor-da-despesa"}
    END.

    IF RowObject.log-forma-preco <> YES AND
       RowObject.log-forma-preco <> NO  THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-indicador-forma-preco-de-venda AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Indicador_Forma_Preáo_de_Venda" *}
        ASSIGN c-lbl-liter-indicador-forma-preco-de-venda = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i &ErrorNumber="36"
                                    &ErrorType="EMS"
                                    &ErrorSubType="Error"
                                    &ErrorParameters="c-lbl-liter-indicador-forma-preco-de-venda"}
    END.

    &IF DEFINED(bf_comex206b-1) &THEN
        IF  RowObject.log-despes-integr-ap
        AND rowObject.cod-cond-pag = 0 THEN DO:
             {method/svc/errors/inserr.i &ErrorNumber="2118"
                                    &ErrorType="EMS"
                                    &ErrorSubType="Error"
                                    &ErrorParameters="''"}
            
        END.

        IF RowObject.log-despes-integr-ap <> YES AND
           RowObject.log-despes-integr-ap <> NO  THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-considera-despesa-no-ap AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Considera_Despesa_no_AP" *}
            ASSIGN c-lbl-liter-considera-despesa-no-ap = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="36"
                                        &ErrorType="EMS"
                                        &ErrorSubType="Error"
                                        &ErrorParameters="c-lbl-liter-considera-despesa-no-ap"}
        END.
                                        
        IF rowObject.dat-base-cobr-despes = ? THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-dt-base-cobranca AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Dt_Base_Cobranáa" *}
            ASSIGN c-lbl-liter-dt-base-cobranca = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="822"
                                        &ErrorType="EMS"
                                        &ErrorSubType="Error"
                                        &ErrorParameters="c-lbl-liter-dt-base-cobranca"}
        END.

        FOR FIRST processo-exp
            WHERE processo-exp.cod-estabel = tt-ped-venda.cod-estabel
              AND processo-exp.nr-proc-exp = tt-ped-venda.nr-invoice
            NO-LOCK.
            IF rowObject.dat-base-cobr-despes < processo-exp.dat-impl-proces-export then do:
               {method/svc/errors/inserr.i &ErrorNumber="31825"
                                           &ErrorType="EMS"
                                           &ErrorSubType="Error"
                                           &ErrorParameters="string(processo-exp.dat-impl-proces-export)"}
            END.
        END.

        IF  rowObject.log-forma-preco THEN DO:

            RUN cxbo/bocx358.p persistent set h-bocx358.
            RUN piRetornaDespesasFaturadasPedido in h-bocx358 (INPUT  tt-ped-venda-cex.nome-abrev,
                                                               INPUT  tt-ped-venda-cex.nr-pedcli,
                                                               INPUT  rowobject.cdn-despes,
                                                               OUTPUT de-val-despes-fatur).

           IF  rowObject.val-despes < de-val-despes-fatur THEN DO:

               {method/svc/errors/inserr.i &ErrorNumber="31948"
                                           &ErrorType="EMS"
                                           &ErrorSubType="Error"
                                           &ErrorParameters="''"}
           END.

           DELETE PROCEDURE h-bocx358.
           ASSIGN h-bocx358 = ?.
        END.

    &ENDIF
    
    IF  RowObject.log-forma-preco    = YES 
    AND RowObject.cdn-classif-despes = 1 THEN DO: /*n∆o permite criaá∆o de despesa de exportaá∆o com classificaá∆o "nenhuma"*/
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-classificacao-da-despesa-2 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Classificaá∆o_da_Despesa" *}
        ASSIGN c-lbl-liter-classificacao-da-despesa-2 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i &ErrorNumber="33332"
                                    &ErrorType="EMS"
                                    &ErrorSubType="Error"
                                    &ErrorParameters="c-lbl-liter-classificacao-da-despesa-2"}
    END.
    
    ASSIGN i-sequencia-atual = 0.

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaAlteracaoDespesas DBOProgram 
PROCEDURE verificaAlteracaoDespesas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE INPUT PARAMETER pnome-abrev LIKE ped-venda-desp.nome-abrev NO-UNDO.
 DEFINE INPUT PARAMETER pnr-pedcli  LIKE ped-venda-desp.nr-pedcli  NO-UNDO.
 DEFINE INPUT PARAMETER TABLE FOR tt-ped-venda-desp.

    FOR EACH tt-ped-venda-desp NO-LOCK.
        FIND FIRST ped-venda-desp 
             WHERE ped-venda-desp.nome-abrev = tt-ped-venda-desp.nome-abrev
               AND ped-venda-desp.nr-pedcli  = tt-ped-venda-desp.nr-pedcli   
               AND ped-venda-desp.cdn-despes = tt-ped-venda-desp.cdn-despes NO-LOCK NO-ERROR.

           IF AVAIL ped-venda-desp 
                AND ped-venda-desp.val-despes <> tt-ped-venda-desp.val-despes THEN
                
               RETURN "NOK":U.
       ELSE 
           IF NOT AVAIL ped-venda-desp THEN
                RETURN "NOK":U.
    END.

    FOR EACH ped-venda-desp NO-LOCK
       WHERE ped-venda-desp.nome-abrev = pnome-abrev
         AND ped-venda-desp.nr-pedcli  = pnr-pedcli.

        FIND FIRST tt-ped-venda-desp 
             WHERE tt-ped-venda-desp.nome-abrev = ped-venda-desp.nome-abrev
               AND tt-ped-venda-desp.nr-pedcli  = ped-venda-desp.nr-pedcli   
               AND tt-ped-venda-desp.cdn-despes = ped-venda-desp.cdn-despes NO-LOCK NO-ERROR.

               IF NOT AVAIL tt-ped-venda-desp THEN
                RETURN "NOK":U.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
