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
{include/i-prgvrs.i BOIN176Q04 2.00.00.025 } /*** "010025" 17/06/2025 16:40:47 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin176q04 MUT}
&ENDIF

/*:T--------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) ‚ um programa PROGRESS 
                 que cont‚m a l¢gica de neg¢cio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName BOIN176
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName tt-Nota
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

&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (m‚todo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /*:T Nome da Query que d  acessos a todos os registros, exceto os exclu¡dos pela constraint de seguran‡a. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /*:T Informar os campos da chave quando o Progress nÆo conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

/*:T--- Include com defini‡Æo da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com 
      extensÆo .i ---*/
{inbo/boin176.i RowObject}

DEFINE TEMP-TABLE tt-Nota NO-UNDO LIKE item-doc-est
       FIELD cod-estabel  LIKE it-nota-fisc.cod-estabel
       FIELD vl-tot-item  LIKE it-nota-fisc.vl-tot-item 
       FIELD dt-emis-nota LIKE it-nota-fisc.dt-emis-nota
       FIELD int-nac      AS INT 
       FIELD r-rowid      AS ROWID

       INDEX documento IS PRIMARY
             serie-docto  ASCENDING
             nro-docto    ASCENDING
             cod-emitente ASCENDING
             nat-operacao ASCENDING
             sequencia    ASCENDING
       INDEX nota-fisc 
             cod-estabel  ASCENDING
             serie-docto  ASCENDING
             nro-docto    ASCENDING
             sequencia    ASCENDING
             it-codigo    ASCENDING.

DEFINE TEMP-TABLE tt-item-doc-est NO-UNDO LIKE item-doc-est
        field r-rowid as rowid.
/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
/*{method/dboqry.i}*/

DEFINE QUERY {&QueryName} FOR tt-Nota SCROLLING.

/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
DEFINE BUFFER bfitem-doc-est FOR item-doc-est.

DEF VAR i-cod-emitente-ini AS INT  NO-UNDO.
DEF VAR i-cod-emitente-fim AS INT  NO-UNDO.
DEF VAR c-serie-docto-ini  AS CHAR NO-UNDO. 
DEF VAR c-serie-docto-fim  AS CHAR NO-UNDO.
DEF VAR c-nro-docto-ini    AS CHAR NO-UNDO.
DEF VAR c-nro-docto-fim    AS CHAR NO-UNDO.
DEF VAR c-nat-operacao-ini AS CHAR NO-UNDO.
DEF VAR c-nat-operacao-fim AS CHAR NO-UNDO.
DEF VAR i-seq-ini          AS INT  NO-UNDO.
DEF VAR i-seq-fim          AS INT  NO-UNDO.
DEF VAR c-estabel-ini      AS CHAR NO-UNDO. 
DEF VAR c-estabel-fim      AS CHAR NO-UNDO. 

{cdp/cdcfgdis.i}
{cdp/cdcfgmat.i}

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
         HEIGHT             = 6.13
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FindDocumEmbarqueImp DBOProgram 
PROCEDURE FindDocumEmbarqueImp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pserie-docto   LIKE item-doc-est.serie-docto       NO-UNDO.
    DEFINE INPUT  PARAMETER pnro-docto     LIKE item-doc-est.nro-docto         NO-UNDO.
    DEFINE INPUT  PARAMETER pcod-emitente  LIKE item-doc-est.cod-emitente      NO-UNDO.
    DEFINE INPUT  PARAMETER pnat-operacao  LIKE item-doc-est.nat-operacao      NO-UNDO.
    DEFINE INPUT  PARAMETER psequencia     LIKE item-doc-est.sequencia         NO-UNDO.
    DEFINE OUTPUT PARAMETER pdi            LIKE item-doc-est.declaracao-import NO-UNDO.
    DEFINE OUTPUT PARAMETER pdt-di         AS DATE                             NO-UNDO.
    DEFINE OUTPUT PARAMETER pdt-emissao    AS DATE                             NO-UNDO.
    DEFINE OUTPUT PARAMETER pdt-trans      AS DATE                             NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estabel   AS CHAR                             NO-UNDO.
    DEFINE OUTPUT PARAMETER pd-cotacao     AS DECIMAL                          NO-UNDO.
    DEFINE OUTPUT PARAMETER pnumero-ordem  AS DECIMAL                          NO-UNDO.
    DEFINE OUTPUT PARAMETER ppreco-total   AS DECIMAL                          NO-UNDO.

    DEFINE VARIABLE cPeriodo         AS   CHARACTER                    NO-UNDO.
    DEFINE VARIABLE i-num-ord-import LIKE ordem-compra.numero-ordem    NO-UNDO.

    FIND docum-est
         WHERE docum-est.serie-docto  = pserie-docto 
           AND docum-est.nro-docto    = pnro-docto   
           AND docum-est.cod-emitente = pcod-emitente
           AND docum-est.nat-operacao = pnat-operacao
           AND docum-est.ce-atual     = YES  NO-LOCK NO-ERROR.

    IF AVAIL docum-est THEN DO:

        FIND item-doc-est
            WHERE item-doc-est.serie-docto  = docum-est.serie-docto
              AND item-doc-est.nro-docto    = docum-est.nro-docto
              AND item-doc-est.cod-emitente = docum-est.cod-emitente
              AND item-doc-est.nat-operacao = docum-est.nat-operacao
              AND item-doc-est.sequencia    = psequencia NO-LOCK NO-ERROR.

       /*Nota Fiscal Simples Remessa*/ 
       &IF '{&bf_mat_versao_ems}':U >= '2.06':U &THEN
           IF docum-est.idi-nf-simples-remes = 1 THEN DO: 
       &ELSE
           IF SUBSTRING(docum-est.char-2,101,1) = "1" THEN DO:
       &ENDIF
              IF AVAIL item-doc-est THEN DO:
                 &IF '{&bf_mat_versao_ems}' >= '2.06' &then
                     ASSIGN i-num-ord-import  = item-doc-est.num-ord-import.
                 &ELSE
                     ASSIGN i-num-ord-import  = DECIMAL(SUBSTRING(item-doc-est.char-2,145,8)).
                 &ENDIF
              END.
       END.
       ELSE
           IF AVAIL item-doc-est THEN
              ASSIGN i-num-ord-import  = item-doc-est.numero-ordem.

       {cdp/cd4300.i3} /* Tratamento do atributo livre */
       {rep/re1001a.i50}
    
       {cdp/cd4300.i4 "yes" docum-est.char-1} 
       {rep/re1001a.i51 "yes"}

       FIND embarque-imp
           WHERE embarque-imp.cod-estabel = docum-est.cod-estabel
             AND embarque-imp.embarque    = c-embarque NO-LOCK NO-ERROR .

       IF AVAIL embarque-imp THEN DO:
          ASSIGN pdi    = embarque-imp.declaracao-import
                 pdt-di = embarque-imp.data-di .
        
          ASSIGN cPeriodo = STRING(YEAR(embarque-imp.data-1), "9999":U)
                          + STRING(MONTH(embarque-imp.data-1), "99":U).
       END.
       ELSE
           ASSIGN cPeriodo = STRING(YEAR(docum-est.dt-emissao), "9999":U)
                           + STRING(MONTH(docum-est.dt-emissao), "99":U).

       IF AVAIL item-doc-est THEN DO:
           FIND ordem-compra WHERE ordem-compra.numero-ordem = &IF '{&bf_mat_versao_ems}' >= '2.04' &THEN
                                                                   i-num-ord-import
                                                               &ELSE
                                                                   item-doc-est.numero-ordem 
                                                               &ENDIF
                                                               NO-LOCK NO-ERROR.
           IF AVAIL ordem-compra THEN DO:
                   
               IF ordem-compra.mo-codigo <> 0 THEN DO:
                  FIND cotacao 
                    WHERE cotacao.mo-codigo   = ordem-compra.mo-codigo
                      AND cotacao.ano-periodo = cPeriodo NO-LOCK NO-ERROR.
                    IF NOT AVAIL cotacao THEN
                        LEAVE.
    
                    IF  AVAIL embarque-imp THEN
                        ASSIGN pd-cotacao = cotacao.cotacao[DAY(embarque-imp.data-1)].
                    ELSE
                        ASSIGN pd-cotacao = cotacao.cotacao[DAY(docum-est.dt-emissao)].
               END.
               ELSE 
                    ASSIGN pd-cotacao = 1.
           END.
           ELSE
               ASSIGN pd-cotacao = 1.
       END.

       ASSIGN pdt-emissao    = docum-est.dt-emissao
              pdt-trans      = docum-est.dt-trans
              pcod-estabel   = docum-est.cod-estabel
              pnumero-ordem  = item-doc-est.numero-ordem 
              ppreco-total   = item-doc-est.preco-total[1].  

    END.

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FindMoeda DBOProgram 
PROCEDURE FindMoeda :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pit-codigo    LIKE item-doc-est.it-codigo    NO-UNDO.
    DEFINE INPUT  PARAMETER pnumero-ordem LIKE item-doc-est.numero-ordem NO-UNDO.
    DEFINE OUTPUT PARAMETER pmoeda        AS INTEGER                     NO-UNDO.

    FIND cotacao-item
        WHERE cotacao-item.it-codigo    = pit-codigo 
          AND cotacao-item.numero-ordem = pnumero-ordem   
          AND cotacao-item.cot-aprovada = YES NO-LOCK NO-ERROR .

    IF AVAIL cotacao-item THEN
       ASSIGN pmoeda = cotacao-item.mo-codigo .

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-tt-Nota DBOProgram 
PROCEDURE get-tt-Nota :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: i-filtro = 1 apenas fornecedores estrangeiros; i-filtro = 2 todos os fornecedores exceto os estrangeiros      
------------------------------------------------------------------------------*/
   DEFINE INPUT PARAM i-filtro AS INTEGER NO-UNDO.
   DEFINE OUTPUT PARAM TABLE FOR tt-item-doc-est.

   EMPTY TEMP-TABLE tt-item-doc-est.

   IF i-filtro = 1 THEN DO:
        FOR EACH docum-est
           WHERE docum-est.serie-docto  >= c-serie-docto-ini  
             AND docum-est.serie-docto  <= c-serie-docto-fim  
             AND docum-est.nro-docto    >= c-nro-docto-ini    
             AND docum-est.nro-docto    <= c-nro-docto-fim 
             AND docum-est.cod-emitente >= i-cod-emitente-ini
             AND docum-est.cod-emitente <= i-cod-emitente-fim
             AND docum-est.nat-operacao >= c-nat-operacao-ini 
             AND docum-est.nat-operacao <= c-nat-operacao-fim 
             AND docum-est.ce-atual      = YES NO-LOCK,
            EACH item-doc-est OF docum-est 
           WHERE item-doc-est.sequencia    >= i-seq-ini  
             AND item-doc-est.sequencia    <= i-seq-fim NO-LOCK,
            EACH emitente OF item-doc-est WHERE emitente.natureza = 3
                                             OR emitente.natureza = 4 NO-LOCK
              BY item-doc-est.nro-docto
              BY item-doc-est.cod-emitente
              BY item-doc-est.nat-operacao
              BY item-doc-est.serie-docto
              BY item-doc-est.sequencia:
         
           IF CAN-FIND(FIRST tt-item-doc-est 
                       WHERE tt-item-doc-est.serie-docto  = item-doc-est.serie-docto
                         AND tt-item-doc-est.nro-docto    = item-doc-est.nro-docto 
                         AND tt-item-doc-est.cod-emitente = item-doc-est.cod-emitente
                         AND tt-item-doc-est.nat-operacao = item-doc-est.nat-operacao
                         AND tt-item-doc-est.sequencia    = item-doc-est.sequencia) THEN NEXT.
           
           CREATE tt-item-doc-est.
           BUFFER-COPY item-doc-est TO tt-item-doc-est.
        END.
   END.
   ELSE DO:
        FOR EACH docum-est
           WHERE docum-est.serie-docto  >= c-serie-docto-ini  
             AND docum-est.serie-docto  <= c-serie-docto-fim  
             AND docum-est.nro-docto    >= c-nro-docto-ini    
             AND docum-est.nro-docto    <= c-nro-docto-fim 
             AND docum-est.cod-emitente >= i-cod-emitente-ini
             AND docum-est.cod-emitente <= i-cod-emitente-fim
             AND docum-est.nat-operacao >= c-nat-operacao-ini 
             AND docum-est.nat-operacao <= c-nat-operacao-fim 
             AND docum-est.ce-atual      = YES NO-LOCK,
            EACH item-doc-est OF docum-est 
           WHERE item-doc-est.sequencia    >= i-seq-ini  
             AND item-doc-est.sequencia    <= i-seq-fim NO-LOCK,
            EACH emitente OF item-doc-est WHERE emitente.natureza <> 3
                                             AND emitente.natureza <> 4 NO-LOCK
              BY item-doc-est.nro-docto
              BY item-doc-est.cod-emitente
              BY item-doc-est.nat-operacao
              BY item-doc-est.serie-docto
              BY item-doc-est.sequencia:
         
           IF CAN-FIND(FIRST tt-item-doc-est 
                       WHERE tt-item-doc-est.serie-docto  = item-doc-est.serie-docto
                         AND tt-item-doc-est.nro-docto    = item-doc-est.nro-docto 
                         AND tt-item-doc-est.cod-emitente = item-doc-est.cod-emitente
                         AND tt-item-doc-est.nat-operacao = item-doc-est.nat-operacao
                         AND tt-item-doc-est.sequencia    = item-doc-est.sequencia) THEN NEXT.
           

           CREATE tt-item-doc-est.
           BUFFER-COPY item-doc-est TO tt-item-doc-est.
           ASSIGN overlay(tt-item-doc-est.char-1,1,3) = docum-est.cod-estabel
                  tt-item-doc-est.cod-emitente = docum-est.cod-emitente.
        END.
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
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "c-nr-invoice":U THEN ASSIGN pFieldValue = RowObject.c-nr-invoice.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "class-fiscal":U THEN ASSIGN pFieldValue = RowObject.class-fiscal.
        WHEN "cod-depos":U THEN ASSIGN pFieldValue = RowObject.cod-depos.
        &IF '{&bf_dis_versao_ems}' >= '2.05' &THEN
            WHEN "cod-despesa":U THEN ASSIGN pFieldValue = RowObject.cod-despesa.
            WHEN "cod-disposicao":U THEN ASSIGN pFieldValue = RowObject.cod-disposicao.
            WHEN "cod-motivo":U THEN ASSIGN pFieldValue = RowObject.cod-motivo.
        &ENDIF
        WHEN "cod-esp":U THEN ASSIGN pFieldValue = RowObject.cod-esp.
        WHEN "cod-localiz":U THEN ASSIGN pFieldValue = RowObject.cod-localiz.
        WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
        WHEN "cod-roteiro":U THEN ASSIGN pFieldValue = RowObject.cod-roteiro.
        WHEN "ct-codigo":U THEN ASSIGN pFieldValue = RowObject.ct-codigo.
        WHEN "declaracao-import":U THEN ASSIGN pFieldValue = RowObject.declaracao-import.
        WHEN "est-cob":U THEN ASSIGN pFieldValue = RowObject.est-cob.
        WHEN "hora":U THEN ASSIGN pFieldValue = RowObject.hora.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "item-pai":U THEN ASSIGN pFieldValue = RowObject.item-pai.
        WHEN "lote":U THEN ASSIGN pFieldValue = RowObject.lote.
        WHEN "narrativa":U THEN ASSIGN pFieldValue = RowObject.narrativa.
        WHEN "nat-comp":U THEN ASSIGN pFieldValue = RowObject.nat-comp.
        WHEN "nat-of":U THEN ASSIGN pFieldValue = RowObject.nat-of.
        WHEN "nat-operacao":U THEN ASSIGN pFieldValue = RowObject.nat-operacao.
        WHEN "nat-terc":U THEN ASSIGN pFieldValue = RowObject.nat-terc.
        WHEN "nivel-restituicao":U THEN ASSIGN pFieldValue = RowObject.nivel-restituicao.
        WHEN "nr-ato-concessorio":U THEN ASSIGN pFieldValue = RowObject.nr-ato-concessorio.
        WHEN "nr-docto-ap":U THEN ASSIGN pFieldValue = RowObject.nr-docto-ap.
        WHEN "nr-pedcli":U THEN ASSIGN pFieldValue = RowObject.nr-pedcli.
        WHEN "nr-proc-imp":U THEN ASSIGN pFieldValue = RowObject.nr-proc-imp.
        WHEN "nro-comp":U THEN ASSIGN pFieldValue = RowObject.nro-comp.
        WHEN "nro-docto":U THEN ASSIGN pFieldValue = RowObject.nro-docto.
        WHEN "nro-docto-terc":U THEN ASSIGN pFieldValue = RowObject.nro-docto-terc.
        WHEN "sc-codigo":U THEN ASSIGN pFieldValue = RowObject.sc-codigo.
        WHEN "serie-comp":U THEN ASSIGN pFieldValue = RowObject.serie-comp.
        WHEN "serie-docto":U THEN ASSIGN pFieldValue = RowObject.serie-docto.
        WHEN "serie-terc":U THEN ASSIGN pFieldValue = RowObject.serie-terc.
        WHEN "un":U THEN ASSIGN pFieldValue = RowObject.un.
        WHEN "usuario":U THEN ASSIGN pFieldValue = RowObject.usuario.
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
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE      NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data":U THEN ASSIGN pFieldValue = RowObject.data.
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "data-comp":U THEN ASSIGN pFieldValue = RowObject.data-comp.
        WHEN "dt-ent-prev":U THEN ASSIGN pFieldValue = RowObject.dt-ent-prev.
        WHEN "dt-nota-comp":U THEN ASSIGN pFieldValue = RowObject.dt-nota-comp.
        WHEN "dt-retorno":U THEN ASSIGN pFieldValue = RowObject.dt-retorno.
        WHEN "dt-vali-lote":U THEN ASSIGN pFieldValue = RowObject.dt-vali-lote.
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
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL   NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "aliquota-icm":U THEN ASSIGN pFieldValue = RowObject.aliquota-icm.
        WHEN "aliquota-ipi":U THEN ASSIGN pFieldValue = RowObject.aliquota-ipi.
        WHEN "aliquota-iss":U THEN ASSIGN pFieldValue = RowObject.aliquota-iss.
        WHEN "base-cofins-subs":U THEN ASSIGN pFieldValue = RowObject.base-cofins-subs.
        WHEN "base-icm[1]":U THEN ASSIGN pFieldValue = RowObject.base-icm[1].
        WHEN "base-icm[2]":U THEN ASSIGN pFieldValue = RowObject.base-icm[2].
        WHEN "base-icm-cmi":U THEN ASSIGN pFieldValue = RowObject.base-icm-cmi.
        WHEN "base-ipi[1]":U THEN ASSIGN pFieldValue = RowObject.base-ipi[1].
        WHEN "base-ipi[2]":U THEN ASSIGN pFieldValue = RowObject.base-ipi[2].
        WHEN "base-ipi-cmi":U THEN ASSIGN pFieldValue = RowObject.base-ipi-cmi.
        WHEN "base-iss[1]":U THEN ASSIGN pFieldValue = RowObject.base-iss[1].
        WHEN "base-iss[2]":U THEN ASSIGN pFieldValue = RowObject.base-iss[2].
        WHEN "base-iss-cmi":U THEN ASSIGN pFieldValue = RowObject.base-iss-cmi.
        WHEN "base-pis-subs":U THEN ASSIGN pFieldValue = RowObject.base-pis-subs.
        WHEN "base-subs[1]":U THEN ASSIGN pFieldValue = RowObject.base-subs[1].
        WHEN "base-subs[2]":U THEN ASSIGN pFieldValue = RowObject.base-subs[2].
        WHEN "base-subs-cmi":U THEN ASSIGN pFieldValue = RowObject.base-subs-cmi.
        WHEN "cota-moeda[1]":U THEN ASSIGN pFieldValue = RowObject.cota-moeda[1].
        WHEN "cota-moeda[2]":U THEN ASSIGN pFieldValue = RowObject.cota-moeda[2].
        WHEN "cotacao-alt[1]":U THEN ASSIGN pFieldValue = RowObject.cotacao-alt[1].
        WHEN "cotacao-alt[2]":U THEN ASSIGN pFieldValue = RowObject.cotacao-alt[2].
        WHEN "cotacao-cmi":U THEN ASSIGN pFieldValue = RowObject.cotacao-cmi.
        WHEN "cotacao-fasb":U THEN ASSIGN pFieldValue = RowObject.cotacao-fasb.
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "desconto[1]":U THEN ASSIGN pFieldValue = RowObject.desconto[1].
        WHEN "desconto[2]":U THEN ASSIGN pFieldValue = RowObject.desconto[2].
        WHEN "desconto-cmi":U THEN ASSIGN pFieldValue = RowObject.desconto-cmi.
        WHEN "desconto-me":U THEN ASSIGN pFieldValue = RowObject.desconto-me.
        WHEN "despesas[1]":U THEN ASSIGN pFieldValue = RowObject.despesas[1].
        WHEN "despesas[2]":U THEN ASSIGN pFieldValue = RowObject.despesas[2].
        WHEN "despesas-cmi":U THEN ASSIGN pFieldValue = RowObject.despesas-cmi.
        WHEN "despesas-me[1]":U THEN ASSIGN pFieldValue = RowObject.despesas-me[1].
        WHEN "despesas-me[2]":U THEN ASSIGN pFieldValue = RowObject.despesas-me[2].
        WHEN "icm-comp-cmi":U THEN ASSIGN pFieldValue = RowObject.icm-comp-cmi.
        WHEN "icm-complem[1]":U THEN ASSIGN pFieldValue = RowObject.icm-complem[1].
        WHEN "icm-complem[2]":U THEN ASSIGN pFieldValue = RowObject.icm-complem[2].
        WHEN "icm-ntr-cmi":U THEN ASSIGN pFieldValue = RowObject.icm-ntr-cmi.
        WHEN "icm-ntrib[1]":U THEN ASSIGN pFieldValue = RowObject.icm-ntrib[1].
        WHEN "icm-ntrib[2]":U THEN ASSIGN pFieldValue = RowObject.icm-ntrib[2].
        WHEN "icm-out-cmi":U THEN ASSIGN pFieldValue = RowObject.icm-out-cmi.
        WHEN "icm-outras[1]":U THEN ASSIGN pFieldValue = RowObject.icm-outras[1].
        WHEN "icm-outras[2]":U THEN ASSIGN pFieldValue = RowObject.icm-outras[2].
        WHEN "ipi-ntr-cmi":U THEN ASSIGN pFieldValue = RowObject.ipi-ntr-cmi.
        WHEN "ipi-ntrib[1]":U THEN ASSIGN pFieldValue = RowObject.ipi-ntrib[1].
        WHEN "ipi-ntrib[2]":U THEN ASSIGN pFieldValue = RowObject.ipi-ntrib[2].
        WHEN "ipi-out-cmi":U THEN ASSIGN pFieldValue = RowObject.ipi-out-cmi.
        WHEN "ipi-outras[1]":U THEN ASSIGN pFieldValue = RowObject.ipi-outras[1].
        WHEN "ipi-outras[2]":U THEN ASSIGN pFieldValue = RowObject.ipi-outras[2].
        WHEN "iss-ntr-cmi":U THEN ASSIGN pFieldValue = RowObject.iss-ntr-cmi.
        WHEN "iss-ntrib[1]":U THEN ASSIGN pFieldValue = RowObject.iss-ntrib[1].
        WHEN "iss-ntrib[2]":U THEN ASSIGN pFieldValue = RowObject.iss-ntrib[2].
        WHEN "iss-out-cmi":U THEN ASSIGN pFieldValue = RowObject.iss-out-cmi.
        WHEN "iss-outras[1]":U THEN ASSIGN pFieldValue = RowObject.iss-outras[1].
        WHEN "iss-outras[2]":U THEN ASSIGN pFieldValue = RowObject.iss-outras[2].
        WHEN "pc-restituicao":U THEN ASSIGN pFieldValue = RowObject.pc-restituicao.
        WHEN "perc-isr":U THEN ASSIGN pFieldValue = RowObject.perc-isr.
        WHEN "perc-sales-tax":U THEN ASSIGN pFieldValue = RowObject.perc-sales-tax.
        WHEN "perc-vat":U THEN ASSIGN pFieldValue = RowObject.perc-vat.
        &IF '{&bf_dis_versao_ems}' >= '2.05' &THEN
            WHEN "peso-bruto-item":U THEN ASSIGN pFieldValue = RowObject.peso-bruto-item.
            WHEN "peso-liquido-item":U THEN ASSIGN pFieldValue = RowObject.peso-liquido-item.
            WHEN "val-perc-red-icms":U THEN ASSIGN pFieldValue = RowObject.val-perc-red-icms.
            WHEN "val-perc-rep-ipi":U THEN ASSIGN pFieldValue = RowObject.val-perc-rep-ipi.
            WHEN "val-perc-restocagem":U THEN ASSIGN pFieldValue = RowObject.val-perc-restocagem.
            WHEN "val-restocagem":U THEN ASSIGN pFieldValue = RowObject.val-restocagem.
            WHEN "val-sdo-alocad-oc":U THEN ASSIGN pFieldValue = RowObject.val-sdo-alocad-oc.
            WHEN "val-sdo-alocad-terc":U THEN ASSIGN pFieldValue = RowObject.val-sdo-alocad-terc.
        &ENDIF
        WHEN "peso-liquido":U THEN ASSIGN pFieldValue = RowObject.peso-liquido.
        WHEN "pr-mob-cmi":U THEN ASSIGN pFieldValue = RowObject.pr-mob-cmi.
        WHEN "pr-total[1]":U THEN ASSIGN pFieldValue = RowObject.pr-total[1].
        WHEN "pr-total[2]":U THEN ASSIGN pFieldValue = RowObject.pr-total[2].
        WHEN "pr-total[3]":U THEN ASSIGN pFieldValue = RowObject.pr-total[3].
        WHEN "pr-total-cmi":U THEN ASSIGN pFieldValue = RowObject.pr-total-cmi.
        WHEN "pr-unit-cmi":U THEN ASSIGN pFieldValue = RowObject.pr-unit-cmi.
        WHEN "pre-unit-mob[1]":U THEN ASSIGN pFieldValue = RowObject.pre-unit-mob[1].
        WHEN "pre-unit-mob[2]":U THEN ASSIGN pFieldValue = RowObject.pre-unit-mob[2].
        WHEN "preco-fatura":U THEN ASSIGN pFieldValue = RowObject.preco-fatura.
        WHEN "preco-total[1]":U THEN ASSIGN pFieldValue = RowObject.preco-total[1].
        WHEN "preco-total[2]":U THEN ASSIGN pFieldValue = RowObject.preco-total[2].
        WHEN "preco-total-alt[1]":U THEN ASSIGN pFieldValue = RowObject.preco-total-alt[1].
        WHEN "preco-total-alt[2]":U THEN ASSIGN pFieldValue = RowObject.preco-total-alt[2].
        WHEN "preco-total-me":U THEN ASSIGN pFieldValue = RowObject.preco-total-me.
        WHEN "preco-unit[1]":U THEN ASSIGN pFieldValue = RowObject.preco-unit[1].
        WHEN "preco-unit[2]":U THEN ASSIGN pFieldValue = RowObject.preco-unit[2].
        WHEN "preco-unit-me":U THEN ASSIGN pFieldValue = RowObject.preco-unit-me.
        WHEN "qt-do-forn":U THEN ASSIGN pFieldValue = RowObject.qt-do-forn.
        WHEN "qt-real":U THEN ASSIGN pFieldValue = RowObject.qt-real.
        WHEN "qt-saldo":U THEN ASSIGN pFieldValue = RowObject.qt-saldo.
        WHEN "quant-conf":U THEN ASSIGN pFieldValue = RowObject.quant-conf.
        WHEN "quantidade":U THEN ASSIGN pFieldValue = RowObject.quantidade.
        WHEN "valor-frete":U THEN ASSIGN pFieldValue = RowObject.valor-frete.
        WHEN "valor-frete-me":U THEN ASSIGN pFieldValue = RowObject.valor-frete-me.
        WHEN "valor-icm[1]":U THEN ASSIGN pFieldValue = RowObject.valor-icm[1].
        WHEN "valor-icm[2]":U THEN ASSIGN pFieldValue = RowObject.valor-icm[2].
        WHEN "valor-ipi[1]":U THEN ASSIGN pFieldValue = RowObject.valor-ipi[1].
        WHEN "valor-ipi[2]":U THEN ASSIGN pFieldValue = RowObject.valor-ipi[2].
        WHEN "valor-iss[1]":U THEN ASSIGN pFieldValue = RowObject.valor-iss[1].
        WHEN "valor-iss[2]":U THEN ASSIGN pFieldValue = RowObject.valor-iss[2].
        WHEN "vl-cofins-subs":U THEN ASSIGN pFieldValue = RowObject.vl-cofins-subs.
        WHEN "vl-icm-cmi":U THEN ASSIGN pFieldValue = RowObject.vl-icm-cmi.
        WHEN "vl-imp-cmi":U THEN ASSIGN pFieldValue = RowObject.vl-imp-cmi.
        WHEN "vl-imp-impor[1]":U THEN ASSIGN pFieldValue = RowObject.vl-imp-impor[1].
        WHEN "vl-imp-impor[2]":U THEN ASSIGN pFieldValue = RowObject.vl-imp-impor[2].
        WHEN "vl-ipi-cmi":U THEN ASSIGN pFieldValue = RowObject.vl-ipi-cmi.
        WHEN "vl-isr":U THEN ASSIGN pFieldValue = RowObject.vl-isr.
        WHEN "vl-isr-me":U THEN ASSIGN pFieldValue = RowObject.vl-isr-me.
        WHEN "vl-iss-cmi":U THEN ASSIGN pFieldValue = RowObject.vl-iss-cmi.
        WHEN "vl-pis-subs":U THEN ASSIGN pFieldValue = RowObject.vl-pis-subs.
        WHEN "vl-subs[1]":U THEN ASSIGN pFieldValue = RowObject.vl-subs[1].
        WHEN "vl-subs[2]":U THEN ASSIGN pFieldValue = RowObject.vl-subs[2].
        WHEN "vl-subs-cmi":U THEN ASSIGN pFieldValue = RowObject.vl-subs-cmi.
        WHEN "vl-taxa":U THEN ASSIGN pFieldValue = RowObject.vl-taxa.
        WHEN "vl-taxa-me":U THEN ASSIGN pFieldValue = RowObject.vl-taxa-me.
        WHEN "vl-unit-mob":U THEN ASSIGN pFieldValue = RowObject.vl-unit-mob.
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
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER   NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cd-trib-icm":U THEN ASSIGN pFieldValue = RowObject.cd-trib-icm.
        WHEN "cd-trib-ipi":U THEN ASSIGN pFieldValue = RowObject.cd-trib-ipi.
        WHEN "cd-trib-iss":U THEN ASSIGN pFieldValue = RowObject.cd-trib-iss.
        &IF '{&bf_dis_versao_ems}' >= '2.05' &THEN
            WHEN "cdn-devolucao":U THEN ASSIGN pFieldValue = RowObject.cdn-devolucao.
            WHEN "fornec-comp":U THEN ASSIGN pFieldValue = RowObject.fornec-comp.
            WHEN "num-event-contrat":U THEN ASSIGN pFieldValue = RowObject.num-event-contrat.
            WHEN "num-ret-om":U THEN ASSIGN pFieldValue = RowObject.num-ret-om.
            WHEN "num-seq-rma":U THEN ASSIGN pFieldValue = RowObject.num-seq-rma.
        &ENDIF
        WHEN "cod-emit-benef":U THEN ASSIGN pFieldValue = RowObject.cod-emit-benef.
        WHEN "cod-emit-terc":U THEN ASSIGN pFieldValue = RowObject.cod-emit-terc.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "cod-tax":U THEN ASSIGN pFieldValue = RowObject.cod-tax.
        WHEN "cod-tax-isr":U THEN ASSIGN pFieldValue = RowObject.cod-tax-isr.
        WHEN "codigo-rejei":U THEN ASSIGN pFieldValue = RowObject.codigo-rejei.
        WHEN "emite-comp":U THEN ASSIGN pFieldValue = RowObject.emite-comp.
        WHEN "etiquetas":U THEN ASSIGN pFieldValue = RowObject.etiquetas.
        WHEN "flag-atu":U THEN ASSIGN pFieldValue = RowObject.flag-atu.
        WHEN "fn-docto-ap":U THEN ASSIGN pFieldValue = RowObject.fn-docto-ap.
        WHEN "i-nr-gi":U THEN ASSIGN pFieldValue = RowObject.i-nr-gi.
        WHEN "i-seq-inv":U THEN ASSIGN pFieldValue = RowObject.i-seq-inv.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "nr-ficha":U THEN ASSIGN pFieldValue = RowObject.nr-ficha.
        WHEN "nr-ord-produ":U THEN ASSIGN pFieldValue = RowObject.nr-ord-produ.
        WHEN "nr-pd-ent":U THEN ASSIGN pFieldValue = RowObject.nr-pd-ent.
        WHEN "nr-pd-seq":U THEN ASSIGN pFieldValue = RowObject.nr-pd-seq.
        WHEN "num-ord-inv":U THEN ASSIGN pFieldValue = RowObject.num-ord-inv.
        WHEN "num-pedido":U THEN ASSIGN pFieldValue = RowObject.num-pedido.
        WHEN "numero-ordem":U THEN ASSIGN pFieldValue = RowObject.numero-ordem.
        WHEN "op-codigo":U THEN ASSIGN pFieldValue = RowObject.op-codigo.
        WHEN "origem":U THEN ASSIGN pFieldValue = RowObject.origem.
        WHEN "parcela":U THEN ASSIGN pFieldValue = RowObject.parcela.
        WHEN "qt-etiquetas":U THEN ASSIGN pFieldValue = RowObject.qt-etiquetas.
        WHEN "seq-comp":U THEN ASSIGN pFieldValue = RowObject.seq-comp.
        WHEN "seq-evento":U THEN ASSIGN pFieldValue = RowObject.seq-evento.
        WHEN "seq-terc":U THEN ASSIGN pFieldValue = RowObject.seq-terc.
        WHEN "sequencia":U THEN ASSIGN pFieldValue = RowObject.sequencia.
        WHEN "sit-item":U THEN ASSIGN pFieldValue = RowObject.sit-item.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice documento
  Parameters:  
               retorna valor do campo serie-docto
               retorna valor do campo nro-docto
               retorna valor do campo cod-emitente
               retorna valor do campo nat-operacao
               retorna valor do campo sequencia
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pserie-docto  LIKE item-doc-est.serie-docto  NO-UNDO.
    DEFINE OUTPUT PARAMETER pnro-docto    LIKE item-doc-est.nro-docto    NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE item-doc-est.cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pnat-operacao LIKE item-doc-est.nat-operacao NO-UNDO.
    DEFINE OUTPUT PARAMETER psequencia    LIKE item-doc-est.sequencia    NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pserie-docto  = RowObject.serie-docto
           pnro-docto    = RowObject.nro-docto
           pcod-emitente = RowObject.cod-emitente
           pnat-operacao = RowObject.nat-operacao
           psequencia    = RowObject.sequencia.

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
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL   NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "atualiza-pa":U THEN ASSIGN pFieldValue = RowObject.atualiza-pa.
        WHEN "baixa-ce":U THEN ASSIGN pFieldValue = RowObject.baixa-ce.
        WHEN "componente":U THEN ASSIGN pFieldValue = RowObject.componente.
        WHEN "encerra-pa":U THEN ASSIGN pFieldValue = RowObject.encerra-pa.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "log-fifo-oc":U THEN ASSIGN pFieldValue = RowObject.log-fifo-oc.
        &IF '{&bf_dis_versao_ems}' >= '2.05' &THEN
            WHEN "log-geracao-ncr-ap":U THEN ASSIGN pFieldValue = RowObject.log-geracao-ncr-ap.
        &ENDIF
        WHEN "log-icm-retido":U THEN ASSIGN pFieldValue = RowObject.log-icm-retido.
        WHEN "reabre-pa":U THEN ASSIGN pFieldValue = RowObject.reabre-pa.
        WHEN "reabre-pd":U THEN ASSIGN pFieldValue = RowObject.reabre-pd.
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
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RAW       NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
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
  Purpose:     Reposiciona registro com base no ¡ndice documento
  Parameters:  
               recebe valor do campo serie-docto
               recebe valor do campo nro-docto
               recebe valor do campo cod-emitente
               recebe valor do campo nat-operacao
               recebe valor do campo sequencia
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pserie-docto  LIKE item-doc-est.serie-docto  NO-UNDO.
    DEFINE INPUT PARAMETER pnro-docto    LIKE item-doc-est.nro-docto    NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente LIKE item-doc-est.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pnat-operacao LIKE item-doc-est.nat-operacao NO-UNDO.
    DEFINE INPUT PARAMETER psequencia    LIKE item-doc-est.sequencia    NO-UNDO.

    FIND FIRST bfitem-doc-est WHERE 
        bfitem-doc-est.serie-docto  = pserie-docto  AND 
        bfitem-doc-est.nro-docto    = pnro-docto    AND 
        bfitem-doc-est.cod-emitente = pcod-emitente AND 
        bfitem-doc-est.nat-operacao = pnat-operacao AND 
        bfitem-doc-est.sequencia    = psequencia NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfitem-doc-est THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfitem-doc-est)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryItemDoctoEst DBOProgram 
PROCEDURE openQueryItemDoctoEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY qr{&tableName} FOR EACH {&tableName}
         WHERE {&tableName}.serie-docto   >= c-serie-docto-ini    
           AND {&tableName}.serie-docto   <= c-serie-docto-fim    
           AND {&tableName}.nro-docto     >= c-nro-docto-ini      
           AND {&tableName}.nro-docto     <= c-nro-docto-fim      
           AND {&tableName}.cod-emitente  >= i-cod-emitente-ini   
           AND {&tableName}.cod-emitente  <= i-cod-emitente-fim   
           AND {&tableName}.nat-operacao  >= c-nat-operacao-ini   
           AND {&tableName}.nat-operacao  <= c-nat-operacao-fim   
           AND {&tableName}.sequencia     >= i-seq-ini            
           AND {&tableName}.sequencia     <= i-seq-fim            
           AND {&tableName}.int-nac        = 1 INDEXED-REPOSITION.
        
    RETURN "OK":U. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryItemNotaFisc DBOProgram 
PROCEDURE openQueryItemNotaFisc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY qr{&tableName} FOR EACH {&tableName} USE-INDEX nota-fisc
         WHERE {&tableName}.cod-estabel >= c-estabel-ini    
           AND {&tableName}.cod-estabel <= c-estabel-fim    
           AND {&tableName}.serie-docto >= c-serie-docto-ini
           AND {&tableName}.serie-docto <= c-serie-docto-fim
           AND {&tableName}.nro-docto   >= c-nro-docto-ini  
           AND {&tableName}.nro-docto   <= c-nro-docto-fim  
           AND {&tableName}.sequencia   >= i-seq-ini        
           AND {&tableName}.sequencia   <= i-seq-fim         
           AND {&tableName}.int-nac     = 2 INDEXED-REPOSITION.
            
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
  OPEN QUERY qr{&tableName} FOR EACH {&tableName} NO-LOCK INDEXED-REPOSITION. 
  
  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintItemDoctoEst DBOProgram 
PROCEDURE setConstraintItemDoctoEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM cnr-docto-ini  AS CHAR NO-UNDO.
    DEF INPUT PARAM cnr-docto-fim  AS CHAR NO-UNDO.
    DEF INPUT PARAM icod-emit-ini  AS INT  NO-UNDO.
    DEF INPUT PARAM icod-emit-fim  AS INT  NO-UNDO.
    DEF INPUT PARAM cnat-oper-ini  AS CHAR NO-UNDO.
    DEF INPUT PARAM cnat-oper-fim  AS CHAR NO-UNDO.
    DEF INPUT PARAM cser-docto-ini AS CHAR NO-UNDO.
    DEF INPUT PARAM cser-docto-fim AS CHAR NO-UNDO.
    DEF INPUT PARAM cseq-ini       AS INT  NO-UNDO.
    DEF INPUT PARAM cseq-fim       AS INT  NO-UNDO.
    DEF INPUT PARAM cestabel-ini   AS CHAR NO-UNDO.
    DEF INPUT PARAM cestabel-fim   AS CHAR NO-UNDO.

    ASSIGN c-nro-docto-ini    = cnr-docto-ini 
           c-nro-docto-fim    = cnr-docto-fim 
           i-cod-emitente-ini = icod-emit-ini 
           i-cod-emitente-fim = icod-emit-fim 
           c-nat-operacao-ini = cnat-oper-ini 
           c-nat-operacao-fim = cnat-oper-fim
           c-serie-docto-ini  = cser-docto-ini
           c-serie-docto-fim  = cser-docto-fim
           i-seq-ini          = cseq-ini 
           i-seq-fim          = cseq-fim 
           c-estabel-ini      = cestabel-ini 
           c-estabel-fim      = cestabel-fim.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintMain DBOProgram 
PROCEDURE setConstraintMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
 RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Valida‡äes pertinentes ao DBO
  Parameters:  recebe o tipo de valida‡Æo (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    /*:T--- Utilize o parƒmetro pType para identificar quais as valida‡äes a serem
          executadas ---*/
    /*:T--- Os valores poss¡veis para o parƒmetro sÆo: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as valida‡äes ---*/
    
    /*:T--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

