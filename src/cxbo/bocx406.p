&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
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
{include/i-prgvrs.i BOCX406 2.00.00.014 } /*** "010014" 14/11/2025 16:15:32 ***/
/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOCX406
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName despes-decla-import
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
{cxbo/bocx406.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE i-num-di-ems   LIKE {&TABLENAME}.num-di-ems       NO-UNDO.
DEFINE VARIABLE de-cdd-siscomex-dts LIKE {&TABLENAME}.cdd-siscomex-dts NO-UNDO.
DEFINE VARIABLE c-erro         AS CHARACTER             NO-UNDO.
DEFINE VARIABLE h-bocx407      AS HANDLE                NO-UNDO.
DEFINE VARIABLE l-tipo-geracao AS LOGICAL  INITIAL NO   NO-UNDO.
DEFINE VARIABLE l-despesa-imposto AS LOGICAL INITIAL NO NO-UNDO.
DEFINE VARIABLE c-mensagem     AS CHAR                  NO-UNDO.
DEFINE VARIABLE h-bocx383a            AS HANDLE                NO-UNDO.
DEFINE VARIABLE l-automatico   AS LOGICAL INITIAL NO    NO-UNDO.
DEFINE VARIABLE i-cod-desp     AS INTEGER               NO-UNDO.
DEFINE VARIABLE de-cdd-num-di-ems AS DECIMAL     NO-UNDO.
DEFINE VARIABLE c-cod-num-di-ems AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-cdn-despes-siscomex AS INTEGER NO-UNDO.
DEFINE VARIABLE i-cdn-emit-siscomex   AS INTEGER NO-UNDO.
DEFINE VARIABLE l-taxa-siscomex       AS LOGICAL NO-UNDO.
DEFINE VARIABLE l-encontrou           AS LOGICAL NO-UNDO.

{cdp/cd4300.i3}  /* include tratamento atributo livre */
{cxbo/bocx250.i50} /* include tratamento atributo livre */
def var i-cod-desp-ii     like desp-imp.cod-desp              no-undo.

DEFINE VARIABLE i-cdn-moeda-old              LIKE despes-decla-import.cdn-moeda              NO-UNDO.
DEFINE VARIABLE d-val-despes-old             LIKE despes-decla-import.val-despes             NO-UNDO.
DEFINE VARIABLE l-log-forma-preco-compra-old LIKE despes-decla-import.log-forma-preco-compra  NO-UNDO.
DEFINE VARIABLE i-idi-tip-incid-nf-old       LIKE despes-decla-import.idi-tip-incid-nf       NO-UNDO.
DEFINE VARIABLE l-log-incid-vmle-old         LIKE despes-decla-import.log-incid-vmle         NO-UNDO.

DEFINE VARIABLE l-nt2024002   AS logical NO-UNDO.

ASSIGN l-nt2024002 = CAN-FIND(FIRST funcao NO-LOCK
                              WHERE funcao.cd-funcao = "spp-NT2024002":U AND funcao.ativo).

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
         HEIGHT             = 14.5
         WIDTH              = 50.57.
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

RUN pi-atualiza-log-pend-rat.

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
RUN pi-atualiza-log-pend-rat.

/* fazer as remoáoes ligadas a remocao da taxa siscomex da DI*/
RUN pi-busca-despes-siscomex (INPUT RowObject.num-di-ems,
                              INPUT RowObject.cdd-siscomex-dts,
                              OUTPUT i-cdn-despes-siscomex, 
                              OUTPUT i-cdn-emit-siscomex,
                              OUTPUT l-taxa-siscomex).

IF RowObject.cdn-despes      = i-cdn-despes-siscomex AND
   RowObject.cdn-emit-despes = i-cdn-emit-siscomex THEN DO:
    IF l-taxa-siscomex THEN DO:
        RUN pi-seta-l-automatico (INPUT YES). /*seta a variavel l-automatico para yes para burlar a validaá∆o */
        FOR EACH despes-adic EXCLUSIVE-LOCK
                WHERE despes-adic.num-di-ems = RowObject.num-di-ems
                AND   despes-adic.cdn-despes = i-cdn-despes-siscomex
                AND   despes-adic.cdd-siscomex-dts = RowObject.cdd-siscomex-dts:
            
            FOR EACH decla-import-ord NO-LOCK
                WHERE decla-import-ord.num-adic = despes-adic.num-adic:
                
                FOR FIRST ordens-embarque EXCLUSIVE-LOCK
                    WHERE ordens-embarque.cod-estabel  = decla-import-ord.cod-estab
                    AND   ordens-embarque.embarque     = decla-import-ord.cod-embarq
                    AND   ordens-embarque.numero-ordem = decla-import-ord.num-ordem
                    AND   ordens-embarque.parcela      = decla-import-ord.num-parcela:
                    
                    /* atualiza o valor da ordens embarque para 0 */
                    &if '{&BF_DIS_VERSAO_EMS}' >= '2.07'  &then
                        assign ordens-embarque.val-tax-siscomex = 0.
                    &else
                        assign OVERLAY(ordens-embarque.char-1, 64, 16) = "0".
                    &endif
                    
                END.
             END.
             DELETE despes-adic.
        END.  
        RUN pi-seta-l-automatico (INPUT NO).
    END.
END.

/* remover a despesa da ADCIÄ«O relacionada a despesa da DI que est† sendo removida */
FOR EACH despes-adic EXCLUSIVE-LOCK 
    WHERE despes-adic.num-di-ems      = RowObject.num-di-ems
    AND   despes-adic.cdn-despes      = RowObject.cdn-despes
    AND   despes-adic.cdn-emit-despes = RowObject.cdn-emit-despes
    AND   despes-adic.cdd-siscomex-dts = RowObject.cdd-siscomex-dts:

    DELETE despes-adic VALIDATE(TRUE,"").

END.

FOR EACH despes-adic-itens EXCLUSIVE-LOCK 
    WHERE despes-adic-itens.num-di-ems      = RowObject.num-di-ems
    AND   despes-adic-itens.cdn-despes      = RowObject.cdn-despes
    AND   despes-adic-itens.cdn-emit-despes = RowObject.cdn-emit-despes
    AND   despes-adic-itens.cdd-siscomex-dts = RowObject.cdd-siscomex-dts:

    DELETE despes-adic-itens VALIDATE(TRUE,"").

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
/* validar se o valor foi alterado, se sim, ent∆o rodar a pi-atualiza-log-pend-rat */
IF i-cdn-moeda-old              <> RowObject.cdn-moeda              OR
   d-val-despes-old             <> RowObject.val-despes             OR 
   l-log-forma-preco-compra-old <> RowObject.log-forma-preco-compra OR
   i-idi-tip-incid-nf-old       <> RowObject.idi-tip-incid-nf       OR
   l-log-incid-vmle-old         <> RowObject.log-incid-vmle         THEN DO:

    IF l-log-forma-preco-compra-old <> RowObject.log-forma-preco-compra OR 
       l-log-incid-vmle-old         <> RowObject.log-incid-vmle THEN
        RUN pi-atualiza-despes-adic-relac.


    RUN pi-atualiza-log-pend-rat.

END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeCreateRecord DBOProgram 
PROCEDURE beforeCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE p-cdn-despes-siscomex AS INTEGER NO-UNDO.
DEFINE VARIABLE p-cdn-emit-siscomex   AS INTEGER NO-UNDO.
DEFINE VARIABLE p-taxa-siscomex       AS LOGICAL NO-UNDO.
/*SE FOR GERAÄ«O PELO IM0420 E POSSUIR EMBARQUES COM MAIS DE 1 DESPESAS 
DE FRETE OU SEGURO COM C‡DIGOS DIFERENTES S‡ DEVE MANTER A PRIMEIRA DESPESA GERADA*/
IF l-tipo-geracao THEN DO:
    FOR FIRST RowErrors
        WHERE RowErrors.errorNumber = 52207 :
        RETURN "NOK":U.
    END.

    IF l-despesa-imposto THEN
        RETURN "NOK":U.

END.

IF RowObject.idi-tip-incid-nf = 1 THEN DO:
    FOR FIRST histor-decla-import NO-LOCK
        WHERE histor-decla-import.num-di-ems = RowObject.num-di-ems 
          AND histor-decla-import.cdd-siscomex-dts = RowObject.cdd-siscomex-dts:
        ASSIGN RowObject.cdn-pto-control = histor-decla-import.cdn-pto-nacionaliz.
    END.
END.
ELSE DO:
    DEF BUFFER bf-histor-decla-import FOR histor-decla-import.
    FOR FIRST histor-decla-import NO-LOCK
        WHERE histor-decla-import.num-di-ems = RowObject.num-di-ems
          AND histor-decla-import.cdd-siscomex-dts = RowObject.cdd-siscomex-dts,
        FIRST bf-histor-decla-import NO-LOCK
        WHERE bf-histor-decla-import.num-di-ems = histor-decla-import.num-di-ems
        AND   bf-histor-decla-import.num-seq      > histor-decla-import.num-seq
        AND   bf-histor-decla-import.cdd-siscomex-dts = histor-decla-import.cdd-siscomex-dts:
        ASSIGN RowObject.cdn-pto-control = bf-histor-decla-import.cdn-pto-control.
    END.                                                      
END.


/* valida se a despesa Ç depois do ponto de nacionalizaá∆o caso j† possua documento gerado no recebimento */
IF NOT VALID-HANDLE(h-bocx383a) THEN
    RUN cxbo/bocx383a.p PERSISTEN SET h-bocx383a.

FOR FIRST decla-import NO-LOCK
    WHERE decla-import.num-di-ems = RowObject.num-di-ems 
      AND decla-import.cdd-siscomex-dts = RowObject.cdd-siscomex-dts:
END.


RUN piDoctoRecebimento IN h-bocx383a(INPUT decla-import.cod-di-siscomex, OUTPUT l-encontrou).

DELETE PROCEDURE h-bocx383a.
ASSIGN h-bocx383a = ?.

/* busca o codigo da despesa de siscomex na tabela de parametro*/
RUN pi-busca-despes-siscomex(INPUT  RowObject.num-di-ems,
                             INPUT  RowObject.cdd-siscomex-dts,
                             OUTPUT p-cdn-despes-siscomex,
                             OUTPUT p-cdn-emit-siscomex,
                             OUTPUT p-taxa-siscomex).

IF l-encontrou AND
   RowObject.idi-tip-incid-nf <> 2 and
   RowObject.cdn-despes <> p-cdn-despes-siscomex THEN DO:
    /* Inicio -- Projeto Internacional */
    DEFINE VARIABLE c-lbl-liter-so-e-permitido-inserir-despesa AS CHARACTER NO-UNDO.
    {utp/ut-liter.i "S¢_Ç_permitido_inserir_despesas_ap¢s_o_ponto_de_nacionalizaá∆o" *}
    ASSIGN c-lbl-liter-so-e-permitido-inserir-despesa = TRIM(RETURN-VALUE).
    {method/svc/errors/inserr.i
                      &ErrorNumber="17006"
                      &ErrorType="EMS"
                      &ErrorParameters="c-lbl-liter-so-e-permitido-inserir-despesa + '!'"}
    RETURN "NOK":U.
END.


RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeUpdateRecord DBOProgram 
PROCEDURE beforeUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* validar se o valor foi alterado, se sim, ent∆o rodar a pi-atualiza-log-pend-rat */
FOR FIRST bfdespes-decla-import NO-LOCK
      WHERE bfdespes-decla-import.num-di-ems       = RowObject.num-di-ems
      AND   bfdespes-decla-import.cdn-pto-control  = RowObject.cdn-pto-control
      AND   bfdespes-decla-import.cdn-despes       = RowObject.cdn-despes
      AND   bfdespes-decla-import.cdn-emit-despes  = RowObject.cdn-emit-despes
      AND   bfdespes-decla-import.cdd-siscomex-dts = RowObject.cdd-siscomex-dts:


    ASSIGN i-cdn-moeda-old               = bfdespes-decla-import.cdn-moeda
           d-val-despes-old              = bfdespes-decla-import.val-despes
           l-log-forma-preco-compra-old  = bfdespes-decla-import.log-forma-preco-compra
           i-idi-tip-incid-nf-old        = bfdespes-decla-import.idi-tip-incid-nf
           l-log-incid-vmle-old          = bfdespes-decla-import.log-incid-vmle.

END.
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
        WHEN "cod-incoterm-rat":U THEN ASSIGN pFieldValue = RowObject.cod-incoterm-rat.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
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
        WHEN "val-cotac-despes-compltar":U THEN ASSIGN pFieldValue = RowObject.val-cotac-despes-compltar.
        WHEN "val-despes":U THEN ASSIGN pFieldValue = RowObject.val-despes.
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
        WHEN "cdd-siscomex-dts":U THEN ASSIGN pFieldValue = RowObject.cdd-siscomex-dts.
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
        WHEN "cdn-cond-pagto":U THEN ASSIGN pFieldValue = RowObject.cdn-cond-pagto.
        WHEN "cdn-despes":U THEN ASSIGN pFieldValue = RowObject.cdn-despes.
        WHEN "cdn-emit-despes":U THEN ASSIGN pFieldValue = RowObject.cdn-emit-despes.
        WHEN "cdn-itiner":U THEN ASSIGN pFieldValue = RowObject.cdn-itiner.
        WHEN "cdn-moeda":U THEN ASSIGN pFieldValue = RowObject.cdn-moeda.
        WHEN "cdn-pto-control":U THEN ASSIGN pFieldValue = RowObject.cdn-pto-control.
        WHEN "idi-tip-incid-nf":U THEN ASSIGN pFieldValue = RowObject.idi-tip-incid-nf.
        WHEN "num-di-ems":U THEN ASSIGN pFieldValue = RowObject.num-di-ems.
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
  Purpose:     Retorna valores dos campos do °ndice dspsdclm-id
  Parameters:  
               retorna valor do campo num-di-ems
               retorna valor do campo cdn-pto-control
               retorna valor do campo cdn-despes
               retorna valor do campo cdn-emit-despes
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnum-di-ems LIKE despes-decla-import.num-di-ems NO-UNDO.
    DEFINE OUTPUT PARAMETER pcdn-pto-control LIKE despes-decla-import.cdn-pto-control NO-UNDO.
    DEFINE OUTPUT PARAMETER pcdn-despes LIKE despes-decla-import.cdn-despes NO-UNDO.
    DEFINE OUTPUT PARAMETER pcdn-emit-despes LIKE despes-decla-import.cdn-emit-despes NO-UNDO.
    DEFINE OUTPUT PARAMETER pcdd-siscomex-dts LIKE despes-decla-import.cdd-siscomex-dts NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnum-di-ems = RowObject.num-di-ems
           pcdn-pto-control = RowObject.cdn-pto-control
           pcdn-despes = RowObject.cdn-despes
           pcdn-emit-despes = RowObject.cdn-emit-despes
           pcdd-siscomex-dts = RowObject.cdd-siscomex-dts.

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
        WHEN "log-forma-preco-compra":U THEN ASSIGN pFieldValue = RowObject.log-forma-preco-compra.
        WHEN "log-incid-vmle":U THEN ASSIGN pFieldValue = RowObject.log-incid-vmle.
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
  Purpose:     Reposiciona registro com base no °ndice dspsdclm-id
  Parameters:  
               recebe valor do campo num-di-ems
               recebe valor do campo cdn-pto-control
               recebe valor do campo cdn-despes
               recebe valor do campo cdn-emit-despes
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnum-di-ems LIKE despes-decla-import.num-di-ems NO-UNDO.
    DEFINE INPUT PARAMETER pcdn-pto-control LIKE despes-decla-import.cdn-pto-control NO-UNDO.
    DEFINE INPUT PARAMETER pcdn-despes LIKE despes-decla-import.cdn-despes NO-UNDO.
    DEFINE INPUT PARAMETER pcdn-emit-despes LIKE despes-decla-import.cdn-emit-despes NO-UNDO.
    DEFINE INPUT PARAMETER pcdd-siscomex-dts LIKE despes-decla-import.cdd-siscomex-dts NO-UNDO.

    FIND FIRST bfdespes-decla-import WHERE 
        bfdespes-decla-import.num-di-ems = pnum-di-ems AND 
        bfdespes-decla-import.cdn-pto-control = pcdn-pto-control AND 
        bfdespes-decla-import.cdn-despes = pcdn-despes AND 
        bfdespes-decla-import.cdn-emit-despes = pcdn-emit-despes AND
        bfdespes-decla-import.cdd-siscomex-dts = pcdd-siscomex-dts
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfdespes-decla-import THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfdespes-decla-import)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByDeclaImport DBOProgram 
PROCEDURE openQueryByDeclaImport :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} NO-LOCK
                            WHERE {&TABLENAME}.num-di-ems = i-num-di-ems 
                              AND {&TABLENAME}.cdd-siscomex-dts = de-cdd-siscomex-dts INDEXED-REPOSITION.
                              
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
OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} NO-LOCK INDEXED-REPOSITION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-log-pend-rat DBOProgram 
PROCEDURE pi-atualiza-log-pend-rat :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FOR FIRST decla-import EXCLUSIVE-LOCK
        WHERE decla-import.num-di-ems = RowObject.num-di-ems
        AND   decla-import.log-ativo
        AND   decla-import.cdd-siscomex-dts = RowObject.cdd-siscomex-dts:
    END.

    IF RowObject.idi-tip-incid-nf = 1 THEN /*1-Despesa Nacionalizaá∆o, 2-Despesa Complementar*/
        ASSIGN decla-import.log-pend-rat = NO.
    ELSE
        &if "{&bf_mat_versao_ems}" < "2.09" &then
            ASSIGN OVERLAY(decla-import.cod-livre-1,1,1) = "N"
                   decla-import.log-livre-2              = NO WHEN RowObject.idi-tip-incid-nf = 1.
        &ELSE
            ASSIGN decla-import.log-pend-despes-compltar = NO
                   decla-import.log-pend-impto           = NO WHEN RowObject.idi-tip-incid-nf = 1.
        &ENDIF

    RELEASE decla-import.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-despes-adic-relac DBOProgram 
PROCEDURE pi-atualiza-despes-adic-relac :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FOR EACH despes-adic EXCLUSIVE-LOCK
        WHERE despes-adic.num-di-ems = RowObject.num-di-ems
        AND   despes-adic.cdn-despes = RowObject.cdn-despes 
        AND   despes-adic.cdd-siscomex-dts = RowObject.cdd-siscomex-dts:

        ASSIGN despes-adic.log-forma-preco-compra = RowObject.log-forma-preco-compra
               despes-adic.log-incid-vmle         = RowObject.log-incid-vmle.

    END.

    RELEASE despes-adic.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-despes-siscomex DBOProgram 
PROCEDURE pi-busca-despes-siscomex :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Esta procedure faz a consulta do c¢digo do c¢digo da 
         despesa no parametro de importaá∆o (param-imp).
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER p-num-di-ems          LIKE decla-import.num-di-ems NO-UNDO.
DEFINE INPUT  PARAMETE  p-cdd-siscomex-dts    LIKE decla-import.cdd-siscomex-dts NO-UNDO.
DEFINE OUTPUT PARAMETER p-cdn-despes-siscomex AS INTEGER                   NO-UNDO.
DEFINE OUTPUT PARAMETER p-cdn-emit-siscomex   AS INTEGER                   NO-UNDO.
DEFINE OUTPUT PARAMETER p-taxa-siscomex       AS LOGICAL                   NO-UNDO.


FIND FIRST decla-import NO-LOCK
     WHERE decla-import.num-di-ems = p-num-di-ems 
       AND decla-import.cdd-siscomex-dts = p-cdd-siscomex-dts NO-ERROR.
    
FIND FIRST param-imp NO-LOCK
        WHERE param-imp.cod-estabel = decla-import.cod-estab NO-ERROR.

&IF '{&BF_MAT_VERSAO_EMS}' >= '2.07' &THEN
    ASSIGN p-cdn-despes-siscomex = param-imp.cdn-despes-siscomex
           p-cdn-emit-siscomex   = param-imp.cdn-emit-siscomex
           p-taxa-siscomex       = param-imp.log-tax-siscomex.
&ELSE
    ASSIGN p-cdn-despes-siscomex = INTEGER(SUBSTRING(param-imp.char-1,91,5))
           p-cdn-emit-siscomex   = INTEGER(SUBSTRING(param-imp.char-1,96,9))
           p-taxa-siscomex       = YES WHEN INTEGER(SUBSTRING(param-imp.char-1,105,1)) = 1
           p-taxa-siscomex       = NO WHEN INTEGER(SUBSTRING(param-imp.char-1,105,1)) = 0 . 
&ENDIF

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-despes-siscomex DBOProgram 
PROCEDURE pi-busca-despes-afrmm :
/*------------------------------------------------------------------------------
  Purpose:                                                                              
  Parameters:  <none>
  Notes: Esta procedure faz a busca do valor da despesa AFRMM 
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER p-cod-di-siscomex     LIKE decla-import.cod-di-siscomex NO-UNDO.  
DEFINE INPUT  PARAMETER p-cdd-siscomex-dts    LIKE decla-import.cdd-siscomex-dts NO-UNDO.
DEFINE OUTPUT PARAMETER p-val-afrmm           AS DECIMAL                        NO-UNDO.

FIND FIRST decla-import 
    WHERE decla-import.cod-di-siscomex = p-cod-di-siscomex NO-LOCK NO-ERROR.
IF AVAIL decla-import THEN DO:
    FOR EACH despes-decla-import 
            WHERE despes-decla-import.num-di-ems = decla-import.num-di-ems 
              AND despes-decla-import.cdd-siscomex-dts = decla-import.cdd-siscomex-dts NO-LOCK:
            /*** ???? verificar se precisa converter esse valor para moeda Real ?????? ***/        
            IF despes-decla-import.log-livre-1 THEN
               /* Valor AFRMM */
               ASSIGN p-val-afrmm = despes-decla-import.val-despes.   
    END.
END.
RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seta-l-automatico DBOProgram 
PROCEDURE pi-seta-l-automatico :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-automatico AS LOGICAL NO-UNDO.

    ASSIGN l-automatico = p-automatico.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-ponto-controle-chegada DBOProgram 
PROCEDURE pi-valida-ponto-controle-chegada :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT  PARAM pNumDiEms LIKE decla-import.num-di-ems      NO-UNDO.
DEF INPUT  PARAM pPtoContr LIKE {&TABLENAME}.cdn-pto-control NO-UNDO.
DEF INPUT  PARAM pCddSiscomexDts LIKE {&TABLENAME}.cdd-siscomex-dts NO-UNDO.
DEF OUTPUT PARAM pRetorno AS LOGICAL                         NO-UNDO.

DEFINE VARIABLE i-pto-cheg        AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-seq-pto-control AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-seq-pto-chegada AS INTEGER     NO-UNDO.

IF NOT VALID-HANDLE(h-bocx407) THEN
    RUN cxbo/bocx407.p PERSISTENT SET h-bocx407.

ASSIGN i-pto-cheg        = 0
       i-seq-pto-chegada = 0
       i-seq-pto-control = 0.

FOR FIRST decla-import-embarq NO-LOCK
    WHERE decla-import-embarq.num-di-ems = pNumDiEms
      AND decla-import-embarq.cdd-siscomex-dts = pCddSiscomexDts:

    RUN retorna-ponto-chegada IN h-bocx407 (INPUT decla-import-embarq.cod-embarq,
                                            INPUT decla-import-embarq.cod-estab,
                                            OUTPUT i-pto-cheg).
END.

DELETE PROCEDURE h-bocx407.
ASSIGN h-bocx407 = ? .

FOR FIRST histor-decla-import NO-LOCK
    WHERE histor-decla-import.num-di-ems      = pNumDiEms
    AND   histor-decla-import.cdn-pto-control = pPtoContr 
    AND   histor-decla-import.cdd-siscomex-dts = pCddSiscomexDts:

    ASSIGN i-seq-pto-control = histor-decla-import.num-seq.

END.

FOR FIRST histor-decla-import NO-LOCK
    WHERE histor-decla-import.num-di-ems      = pNumDiEms
    AND   histor-decla-import.cdn-pto-control = i-pto-cheg 
    AND   histor-decla-import.cdd-siscomex-dts = pCddSiscomexDts:

    ASSIGN i-seq-pto-chegada = histor-decla-import.num-seq.

END.

IF i-seq-pto-control < i-seq-pto-chegada THEN
    ASSIGN pRetorno = YES.
ELSE
    ASSIGN pRetorno = NO.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validateCreate DBOProgram 
PROCEDURE pi-validateCreate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    ASSIGN c-erro = "".
    
    DEF BUFFER bf-desp-imp FOR desp-imp.

    /*if not can-find(pto-contr where pto-contr.cod-pto-contr = rowObject.cdn-pto-control) then do:
        {method/svc/errors/inserr.i
              &ErrorNumber="4586"
              &ErrorType="EMS"
              &ErrorParameters= rowObject.cdn-pto-control}
    end. */

    /* validaá∆o para n∆o permitir cadastrar duas despesas com mesmo c¢digo para a mesma DI */
    IF CAN-FIND(FIRST despes-adic
                    WHERE despes-adic.num-di-ems    = RowObject.num-di-ems
                    AND   despes-adic.cdn-despes    = RowObject.cdn-despes
                    AND   despes-adic.idi-orig-despes = 1
                    AND   despes-adic.cdn-despes    <> i-cod-desp
                    AND   despes-adic.cdd-siscomex-dts = RowObject.cdd-siscomex-dts) THEN DO:
        
        FIND FIRST despes-adic
                WHERE despes-adic.num-di-ems    = RowObject.num-di-ems
                AND   despes-adic.cdn-despes    = RowObject.cdn-despes
                AND   despes-adic.cdd-siscomex-dts = RowObject.cdd-siscomex-dts
                AND   despes-adic.idi-orig-desp = 1 NO-LOCK NO-ERROR.
        ASSIGN c-mensagem = 'Despesa ' + string(RowObject.cdn-despes) + ' j† inclusa ' + string(despes-adic.num-adic).
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-inclusao-de-despesa-nao-permit AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Inclus∆o_de_Despesa_n∆o_permitida" *}
        ASSIGN c-lbl-liter-inclusao-de-despesa-nao-permit = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i &ErrorNumber="17006"
                                    &ErrorType="EMS"
                                    &ErrorParameters="c-lbl-liter-inclusao-de-despesa-nao-permit + '!' + '~~~~' + c-mensagem"}.
    END.
    
    if not can-find(desp-imp where desp-imp.cod-desp = rowObject.cdn-despes) then do:
        {utp/ut-field.i mgcex desp-embarque cod-desp 1}              

        ASSIGN c-erro = RETURN-VALUE + " " + string(rowObject.cdn-despes).

        {method/svc/errors/inserr.i
              &ErrorNumber="47"
              &ErrorType="EMS"
              &ErrorParameters= c-erro}
    end. 

    IF NOT CAN-FIND(FIRST emitente 
                    where emitente.cod-emitente = rowObject.cdn-emit-despes) then do:
        {method/svc/errors/inserr.i
              &ErrorNumber="3486"
              &ErrorType="EMS"
              &ErrorParameters= rowObject.cdn-emit-despes}
    END.

    IF CAN-FIND(emitente WHERE emitente.cod-emitente = RowObject.cdn-emit-despes
                         &IF DEFINED(bf-mat-comex) &THEN
                           AND emitente.identific = "C":U
                         &ELSE
                           AND emitente.identific = 1
                         &ENDIF
                         ) THEN DO:
        {method/svc/errors/inserr.i
              &ErrorNumber="8738"
              &ErrorType="EMS"
              &ErrorParameters="''"}
    END.

    FOR FIRST decla-import NO-LOCK
        WHERE decla-import.num-di-ems = RowObject.num-di-ems
          AND decla-import.cdd-siscomex-dts = RowObject.cdd-siscomex-dts,
        FIRST param-imp NO-LOCK
        WHERE param-imp.cod-estabel = decla-import.cod-estab : END.
    
    /*Geraá∆o pelo im0400*/
    IF NOT l-tipo-geracao THEN DO:
        /*A DECLARAÄ«O DE IMPORTAÄ«O S‡ PODE TER UMA DESPESA FRETE*/
        IF CAN-FIND(FIRST desp-imp NO-LOCK
                    WHERE desp-imp.cod-desp = RowObject.cdn-despes 
                    AND   desp-imp.inc-val-frete) THEN DO:
            FOR EACH bf{&TABLENAME} NO-LOCK
                WHERE bf{&TABLENAME}.num-di-ems = RowObject.num-di-ems 
                  AND bf{&TABLENAME}.cdd-siscomex-dts = RowObject.cdd-siscomex-dts:
                IF CAN-FIND(FIRST desp-imp
                            WHERE desp-imp.cod-desp   = bf{&TABLENAME}.cdn-despes 
                            AND   desp-imp.inc-val-frete
                            AND   desp-imp.cod-desp  <> RowObject.cdn-despes)THEN DO:
                    /* Inicio -- Projeto Internacional */
                    DO:
                    DEFINE VARIABLE c-lbl-liter-frete AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Frete" *}
                    ASSIGN c-lbl-liter-frete = TRIM(RETURN-VALUE).
                    {method/svc/errors/inserr.i
                          &ErrorNumber="52205"
                          &ErrorType="EMS"
                          &ErrorParameters="c-lbl-liter-frete"}
                    END. 
                    LEAVE.                          
                END.
            END.
        END.
    
        /*A DECLARAÄ«O DE IMPORTAÄ«O S‡ PODE TER UMA DESPESA SEGURO*/
        IF CAN-FIND(FIRST desp-imp NO-LOCK
                    WHERE desp-imp.cod-desp = RowObject.cdn-despes 
                    AND   desp-imp.inc-val-seguro) THEN DO:
            FOR EACH bf{&TABLENAME} NO-LOCK
                WHERE bf{&TABLENAME}.num-di-ems = RowObject.num-di-ems 
                  AND bf{&TABLENAME}.cdd-siscomex-dts = RowObject.cdd-siscomex-dts:
                IF CAN-FIND(FIRST desp-imp
                            WHERE desp-imp.cod-desp   = bf{&TABLENAME}.cdn-despes 
                            AND   desp-imp.inc-val-seguro
                            AND   desp-imp.cod-desp   <> RowObject.cdn-despes) THEN DO:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-seguro AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Seguro" *}
                    ASSIGN c-lbl-liter-seguro = TRIM(RETURN-VALUE).
                    {method/svc/errors/inserr.i
                          &ErrorNumber="52205"
                          &ErrorType="EMS"
                          &ErrorParameters="c-lbl-liter-seguro"}
                    LEAVE.                          
                END.
            END.
        END.

        {cdp/cd4300.i4 "yes" param-imp.char-1}
        {cxbo/bocx250.i51 "yes"}
        
        assign i-cod-desp-ii     = i-desp-ii-i50.

        /*VERIFICA SE A DESPESA ê UMA DESPESA DE IMPOSTO*/
        IF  RowObject.cdn-despes = param-imp.cdn-despes-impto-ipi    OR
            RowObject.cdn-despes = param-imp.cdn-despes-impto-icms   OR
            RowObject.cdn-despes = param-imp.cdn-despes-impto-cofins OR
            RowObject.cdn-despes = param-imp.cdn-despes-impto-pis    OR 
            RowObject.cdn-despes = i-cod-desp-ii                     THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-despesa-parametrizada-como-des AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Despesa_parametrizada_como_despesa_de_imposto" *}
            ASSIGN c-lbl-liter-despesa-parametrizada-como-des = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-esta-despesa-esta-parametrizad AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Esta_despesa_esta_parametrizada_como_despesa_de_imposto_nos_parÉmetros_do_m¢dulo_(im0000)_n∆o_sendo_poss°vel_incluir_na_Declaraá∆o_de_Importaá∆o" *}
            ASSIGN c-lbl-liter-esta-despesa-esta-parametrizad = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-inserr-despesa-parametrizada-como-d AS CHARACTER NO-UNDO.
            ASSIGN c-lbl-inserr-despesa-parametrizada-como-d = c-lbl-liter-despesa-parametrizada-como-des + '!' + '~~~~' + 
                                                            c-lbl-liter-esta-despesa-esta-parametrizad + '!'.
            {method/svc/errors/inserr.i &ErrorNumber     = "17006"
                                        &ErrorType       = "EMS"
                                        &ErrorParameters = "c-lbl-inserr-despesa-parametrizada-como-d"}
        END. /* IF  RowObject.cdn-desp */

        IF l-nt2024002 AND AVAIL param-imp-trib THEN DO:
            IF  RowObject.cdn-despes = param-imp-trib.cdn-despes-impto-CBS    
            OR  RowObject.cdn-despes = param-imp-trib.cdn-despes-impto-IBSUF   
            OR  RowObject.cdn-despes = param-imp-trib.cdn-despes-impto-IS
            OR  RowObject.cdn-despes = param-imp-trib.cdn-despes-impto-IBSMun THEN DO:
                DEFINE VARIABLE c-liter-despesa AS CHARACTER NO-UNDO.
                DEFINE VARIABLE c-liter-despesa-parametrizada AS CHARACTER NO-UNDO.
                ASSIGN c-liter-despesa = "Despesa parametrizada como despesa de imposto":U.
                ASSIGN c-liter-despesa-parametrizada = "Esta despesa esta parametrizada como despesa de imposto nos parÉmetros do m¢dulo (im0000) n∆o sendo poss°vel incluir na Declaraá∆o de Importaá∆o":U.
                {method/svc/errors/inserr.i &ErrorNumber="17006"
                                            &ErrorType="EMS"
                                            &ErrorParameters="c-liter-despesa + '!' + '~~~~' + c-liter-despesa-parametrizada + '!'"}
            END.
        END.
        
        /*--- Validando o Rateio Siscomex [ IM0000 ]------------------------------*/
        IF l-automatico = NO THEN DO:
            &IF '{&BF_MAT_VERSAO_EMS}' >= '2.07' &THEN
                IF  (param-imp.log-tax-siscomex 
                AND  param-imp.cdn-despes-siscomex = RowObject.cdn-despes) THEN DO:
            &ELSE
                IF  (SUBSTR(param-imp.char-1,105,1) = '1' /* YES */
                AND  SUBSTR(param-imp.char-1,91,5)  = string(RowObject.cdn-despes)) THEN DO:
            &ENDIF
                    {method/svc/errors/inserr.i &ErrorNumber="33677"
                                                &ErrorType="EMS"}
                    LEAVE.                          
                END.
        END.
        /*------------------------------------------------------------------------*/

        /* verifica se a despesa esta no embarque */
        FOR EACH decla-import-embarq NO-LOCK
                WHERE decla-import-embarq.num-di-ems = RowObject.num-di-ems
                  AND decla-import-embarq.cdd-siscomex-dts = RowObject.cdd-siscomex-dts,
                FIRST decla-import
                WHERE decla-import.num-di-ems = RowObject.num-di-ems
                  AND decla-import.cdd-siscomex-dts = RowObject.cdd-siscomex-dts:
        
            IF CAN-FIND(FIRST desp-embarque
                        WHERE desp-embarque.cod-estabel = decla-import.cod-estab
                        AND   desp-embarque.embarque    = decla-import-embarq.cod-embarq
                        AND   desp-embarque.cod-desp    = RowObject.cdn-despes) THEN DO:
                ASSIGN c-erro = "Despesa " + STRING(RowObject.cdn-despes) + "~~" + " Embarque " + decla-import-embarq.cod-embarq.
                {method/svc/errors/inserr.i
                      &ErrorNumber="52229"
                      &ErrorType="EMS"
                      &ErrorParameters= c-erro}
            END.
        END.
        /* fim - verifica se a despesa esta no embarque */

    END.
    ELSE DO:
        /*Geraá∆o pelo im0420 apenas gera alerta e n∆o vincula a despesa*/
        /*A DECLARAÄ«O DE IMPORTAÄ«O S‡ PODE TER UMA DESPESA FRETE*/
        IF CAN-FIND(FIRST desp-imp NO-LOCK
                    WHERE desp-imp.cod-desp = RowObject.cdn-despes 
                    AND   desp-imp.inc-val-frete) THEN DO:
            FOR EACH bf{&TABLENAME} NO-LOCK
                WHERE bf{&TABLENAME}.num-di-ems = RowObject.num-di-ems 
                  AND bf{&TABLENAME}.cdd-siscomex-dts = RowObject.cdd-siscomex-dts:
                IF CAN-FIND(FIRST desp-imp
                            WHERE desp-imp.cod-desp   = bf{&TABLENAME}.cdn-despes 
                            AND   desp-imp.inc-val-frete
                            AND   desp-imp.cod-desp  <> RowObject.cdn-despes)THEN do:
                    /* Inicio -- Projeto Internacional */
                    DO:
                    DEFINE VARIABLE c-lbl-liter-frete-2 AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Frete" *}
                    ASSIGN c-lbl-liter-frete-2 = TRIM(RETURN-VALUE).
                    {method/svc/errors/inserr.i
                          &ErrorNumber="52207"
                          &ErrorType="EMS"
                          &ErrorParameters="c-lbl-liter-frete-2"}
                    END. 
                    LEAVE.                         
                END.
            END.
        END.

        /*A DECLARAÄ«O DE IMPORTAÄ«O S‡ PODE TER UMA DESPESA SEGURO*/
        IF CAN-FIND(FIRST desp-imp NO-LOCK
                    WHERE desp-imp.cod-desp = RowObject.cdn-despes 
                    AND   desp-imp.inc-val-seguro) THEN DO:
            FOR EACH bf{&TABLENAME} NO-LOCK
                WHERE bf{&TABLENAME}.num-di-ems = RowObject.num-di-ems 
                  AND bf{&TABLENAME}.cdd-siscomex-dts = RowObject.cdd-siscomex-dts:
                IF CAN-FIND(FIRST desp-imp
                            WHERE desp-imp.cod-desp   = bf{&TABLENAME}.cdn-despes 
                            AND   desp-imp.inc-val-seguro
                            AND   desp-imp.cod-desp   <> RowObject.cdn-despes) THEN DO:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-seguro-2 AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Seguro" *}
                    ASSIGN c-lbl-liter-seguro-2 = TRIM(RETURN-VALUE).
                    {method/svc/errors/inserr.i
                          &ErrorNumber="52207"
                          &ErrorType="EMS"
                          &ErrorParameters="c-lbl-liter-seguro-2"}
                    LEAVE.
                END.
            END.
        END.

        ASSIGN l-despesa-imposto = NO.

        {cdp/cd4300.i4 "yes" param-imp.char-1}
        {cxbo/bocx250.i51 "yes"}
        
        assign i-cod-desp-ii     = i-desp-ii-i50.

        /*VERIFICA SE A DESPESA ê UMA DESPESA DE IMPOSTO*/
        IF  RowObject.cdn-despes = param-imp.cdn-despes-impto-ipi    OR
            RowObject.cdn-despes = param-imp.cdn-despes-impto-icms   OR
            RowObject.cdn-despes = param-imp.cdn-despes-impto-cofins OR
            RowObject.cdn-despes = param-imp.cdn-despes-impto-pis    OR
            RowObject.cdn-despes = i-cod-desp-ii                     THEN DO:
            
            ASSIGN l-despesa-imposto = YES.
            LEAVE.

        END. /* IF  RowObject.cdn-desp */

        IF l-nt2024002 AND AVAIL param-imp-trib THEN DO:
            IF  RowObject.cdn-despes = param-imp-trib.cdn-despes-impto-CBS    
            OR  RowObject.cdn-despes = param-imp-trib.cdn-despes-impto-IBSUF   
            OR  RowObject.cdn-despes = param-imp-trib.cdn-despes-impto-IS 
            OR  RowObject.cdn-despes = param-imp-trib.cdn-despes-impto-IBSMun THEN DO:
                ASSIGN l-despesa-imposto = YES.
                LEAVE.
            END.
        END.
        
        /*--- Validando o Rateio Siscomex [ IM0000 ]------------------------------*/
        &IF '{&BF_MAT_VERSAO_EMS}' >= '2.07' &THEN
            IF  (param-imp.log-tax-siscomex 
            AND  param-imp.cdn-despes-siscomex = RowObject.cdn-despes) THEN DO:
        &ELSE
            IF  (SUBSTR(param-imp.char-1,105,1) = '1' /* YES */
            AND  SUBSTR(param-imp.char-1,91,5)  = string(RowObject.cdn-despes)) THEN DO:
        &ENDIF
                ASSIGN l-despesa-imposto = YES.
                LEAVE.                          
            END.
        /*------------------------------------------------------------------------*/
    END.

    run pi-validateFields (INPUT pType).   
    
RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validateDelete DBOProgram 
PROCEDURE pi-validateDelete :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validateFields DBOProgram 
PROCEDURE pi-validateFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    ASSIGN c-erro = "".

    IF pType <> "DELETE" THEN DO:
    
        if not can-find(moeda where moeda.mo-codigo = rowObject.cdn-moeda) then do:
            {method/svc/errors/inserr.i
                  &ErrorNumber="151"
                  &ErrorType="EMS"
                  &ErrorParameters= rowObject.cdn-moeda}
        end.           
    
        if not can-find(cond-pagto where cond-pagto.cod-cond-pag = rowObject.cdn-cond-pagto) then do:
            {method/svc/errors/inserr.i
                  &ErrorNumber="8303"
                  &ErrorType="EMS"
                  &ErrorParameters= rowObject.cdn-cond-pagto}
        end.           
        
        if rowObject.val-despes = 0 AND
           RowObject.cdn-despes <> i-cod-desp then do:
            {utp/ut-field.i mgcex desp-embarque val-desp 1}
            {method/svc/errors/inserr.i
                  &ErrorNumber="265"
                  &ErrorType="EMS"
                  &ErrorParameters= RETURN-VALUE} 
        end.  
    
    
    
        /* Verifica se o Incoterm de rateio esta disponivel no Cad. de Incoterms */
        if  rowObject.cod-incoterm-rat <> "" then do:
            for first inco-cx fields (cod-incoterm)
                where inco-cx.cod-incoterm = rowObject.cod-incoterm-rat no-lock: end.
    
            if  avail inco-cx then do:
    
                for first desp-incoterm fields (cod-desp)
                    where desp-incoterm.cod-incoterm = inco-cx.cod-incoterm
                    and   desp-incoterm.cod-desp     = rowObject.cdn-despes no-lock: end.
                if  avail desp-incoterm then do:
    
                    /* A incoterm de rateio informada nao deve conter em sua 
                       parametrizacao a propria despesa a ser rateada        */
    
                    ASSIGN c-erro = inco-cx.cod-incoterm + "~~" +
                                             string(rowObject.cdn-despes).
    
                    {method/svc/errors/inserr.i
                          &ErrorNumber="30164"
                          &ErrorType="EMS"
                          &ErrorParameters= c-erro} 
    
                end.
            end.
            else do:
    
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-incoterm AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Incoterm" *}
                ASSIGN c-lbl-liter-incoterm = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                      &ErrorNumber="2"
                      &ErrorType="EMS"
                      &ErrorParameters="c-lbl-liter-incoterm"} 
            end.
        end.
            
        /*A DECLARAÄ«O DE IMPORTAÄ«O S‡ PODE TER UMA DESPESA AFRMM*/
        IF RowObject.log-livre-1 THEN DO:
            FOR EACH bf{&TABLENAME} NO-LOCK
                WHERE bf{&TABLENAME}.num-di-ems = RowObject.num-di-ems 
                  AND bf{&TABLENAME}.cdd-siscomex-dts = RowObject.cdd-siscomex-dts:
            
                IF (RowObject.cdn-despes <> bf{&TABLENAME}.cdn-despes) 
                    AND bf{&TABLENAME}.log-livre-1 THEN DO:
                    {method/svc/errors/inserr.i
                          &ErrorNumber="52205"
                          &ErrorType="EMS"
                          &ErrorParameters="'AFRMM'"}
                    LEAVE.
                END.
            END.
        END.
        
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validateUpdate DBOProgram 
PROCEDURE pi-validateUpdate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    run pi-validateFields (INPUT pType).

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-despesas-embarque DBOProgram 
PROCEDURE pi-verifica-despesas-embarque :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT  PARAM pNumDiEms LIKE {&TABLENAME}.num-di-ems NO-UNDO.
DEF INPUT  PARAM pCdnDesp  LIKE {&TABLENAME}.cdn-desp   NO-UNDO.
DEF INPUT  PARAM pCddSiscomexDts LIKE {&TABLENAME}.cdd-siscomex-dts NO-UNDO.
DEF OUTPUT PARAM pRetorno  AS LOGICAL                   NO-UNDO.

DEFINE VARIABLE i-cont AS INTEGER     NO-UNDO.

ASSIGN i-cont = 0.

FOR EACH decla-import-embarq NO-LOCK
    WHERE decla-import-embarq.num-di-ems = pNumDiEms
      AND decla-import-embarq.cdd-siscomex-dts = pCddSiscomexDts:

    FOR EACH desp-embarque NO-LOCK
        WHERE desp-embarque.cod-estabel = decla-import-embarq.cod-estab
        AND   desp-embarque.embarque    = decla-import-embarq.cod-embarq
        AND   desp-embarque.cod-desp    = pCdnDesp:
        ASSIGN i-cont = i-cont + 1.
    END.                                           
END.

IF i-cont <> 1 THEN
    ASSIGN pRetorno = NO.
ELSE
    ASSIGN pRetorno = YES.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE salvaPontoControle DBOProgram 
PROCEDURE salvaPontoControle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM p-idi-tip-incid-nf LIKE despes-decla-import.idi-tip-incid-nf NO-UNDO.
DEF INPUT PARAM p-num-di-ems       LIKE despes-decla-import.num-di-ems       NO-UNDO.
DEF INPUT PARAM p-cdd-siscomex-dts LIKE despes-decla-import.cdd-siscomex-dts NO-UNDO.
DEF OUTPUT PARAM p-pto-controle    LIKE despes-decla-import.cdn-pto-control  NO-UNDO.

IF p-idi-tip-incid-nf = 1 THEN DO:
    FOR FIRST histor-decla-import NO-LOCK
        WHERE histor-decla-import.num-di-ems = p-num-di-ems 
          AND histor-decla-import.cdd-siscomex-dts = p-cdd-siscomex-dts:
        ASSIGN p-pto-controle = histor-decla-import.cdn-pto-nacionaliz.
    END.
END.
ELSE DO:
    DEF BUFFER bf-histor-decla-import FOR histor-decla-import.
    FOR FIRST histor-decla-import NO-LOCK
        WHERE histor-decla-import.num-di-ems = p-num-di-ems
          AND histor-decla-import.cdd-siscomex-dts = p-cdd-siscomex-dts,
        FIRST bf-histor-decla-import NO-LOCK
        WHERE bf-histor-decla-import.num-di-ems = histor-decla-import.num-di-ems
        AND   bf-histor-decla-import.num-seq      > histor-decla-import.num-seq
        AND   bf-histor-decla-import.cdd-siscomex-dts = histor-decla-import.cdd-siscomex-dts :
        ASSIGN p-pto-controle = bf-histor-decla-import.cdn-pto-control.
    END.                                                      
END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setaTipoGeracao DBOProgram 
PROCEDURE setaTipoGeracao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT  PARAM p-tipo-geracao AS LOGICAL NO-UNDO.

ASSIGN l-tipo-geracao = p-tipo-geracao.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByDeclaImport DBOProgram 
PROCEDURE setConstraintByDeclaImport :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM pNumDiEms       LIKE {&TABLENAME}.num-di-ems NO-UNDO.
DEF INPUT PARAM pCddSiscomexDts LIKE {&TABLENAME}.cdd-siscomex-dts NO-UNDO.


ASSIGN i-num-di-ems = pNumDiEms
       de-cdd-siscomex-dts = pCddSiscomexDts.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaIntegraDespDi DBOProgram 
PROCEDURE validaIntegraDespDi :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT  PARAM pEmbarque LIKE decla-import-embarq.cod-embarq NO-UNDO.
DEF INPUT  PARAM pEstab    LIKE decla-import-embarq.cod-estab  NO-UNDO.
DEF INPUT  PARAM pCdnDesp  LIKE despes-decla-import.cdn-desp   NO-UNDO.
DEF OUTPUT PARAM pRetorno  AS LOGICAL                          NO-UNDO.

IF NOT CAN-FIND(FIRST decla-import-embarq                            
                WHERE decla-import-embarq.cod-estab  = pEstab
                AND   decla-import-embarq.cod-embarq = pEmbarque) THEN
    ASSIGN pRetorno = NO.        
ELSE DO:
    FOR FIRST decla-import-embarq NO-LOCK
        WHERE decla-import-embarq.cod-estab  = pEstab
        AND   decla-import-embarq.cod-embarq = pEmbarque :

        IF CAN-FIND(FIRST despes-decla-import
                    WHERE despes-decla-import.num-di-ems = decla-import-embarq.num-di-ems
                    AND   despes-decla-import.cdn-desp   = pCdnDesp
                    AND   despes-decla-import.cdd-siscomex-dts = decla-import-embarq.cdd-siscomex-dts) THEN DO:
            FOR FIRST despes-decla-import NO-LOCK
                WHERE despes-decla-import.num-di-ems = decla-import-embarq.num-di-ems
                AND   despes-decla-import.cdn-desp   = pCdnDesp
                AND   despes-decla-import.cdd-siscomex-dts = decla-import-embarq.cdd-siscomex-dts:
    
                ASSIGN pRetorno = YES.
        
            END.
        END.
        ELSE DO:
            ASSIGN pRetorno = NO.
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
    
    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/
    
    /*Metodo usado para buscar o ponto de controle pelo tipo de incidencia*/
    

    /* busca o codigo da despesa e do emitente da despesa do siscomex */
    FIND FIRST decla-import NO-LOCK
        WHERE decla-import.num-di-ems = RowObject.num-di-ems 
          AND decla-import.cdd-siscomex-dts = RowObject.cdd-siscomex-dts NO-ERROR.
        
    FIND FIRST param-imp NO-LOCK
            WHERE param-imp.cod-estabel = decla-import.cod-estab NO-ERROR.
    
     &if '{&bf_mat_versao_ems}' >= '2.07' &then
         ASSIGN i-cod-desp          = param-imp.cdn-despes-siscomex.
     &else
         ASSIGN i-cod-desp          = INTEGER(SUBSTRING(param-imp.char-1,91,5)).
     &endif

    IF pType = "CREATE" 
        OR pType = "COPY" THEN DO:
        IF CAN-FIND (FIRST despes-decla-import
                     WHERE despes-decla-import.num-di-ems      = RowObject.num-di-ems
                     AND   despes-decla-import.cdn-pto-control = RowObject.cdn-pto-control
                     AND   despes-decla-import.cdn-despes      = RowObject.cdn-despes
                     AND   despes-decla-import.cdn-emit-despes = RowObject.cdn-emit-despes   
                     AND   despes-decla-import.cdd-siscomex-dts = RowObject.cdd-siscomex-dts) THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-despesa-declaracao-importacao AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Despesa_Declaraá∆o_Importaá∆o" *}
            ASSIGN c-lbl-liter-despesa-declaracao-importacao = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                  &ErrorNumber="1"
                  &ErrorType="EMS"
                  &ErrorParameters="c-lbl-liter-despesa-declaracao-importacao"}
        END.
    END.

    IF pType = "CREATE" THEN
        RUN pi-validateCreate(INPUT pType).

    IF pType = "UPDATE" THEN
        RUN pi-validateUpdate(INPUT pType).

    IF pType = "DELETE" THEN
        RUN pi-validateDelete(INPUT pType).

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

