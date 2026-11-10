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
{include/i-prgvrs.i BOCX402 2.00.00.031 } /*** "010031" 16/12/2025 13:48:13 ***/
/* ***************************  Definitions  **************************** */
 
/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOCX402
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName decla-import-adic-itens
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
{cxbo/bocx402.i RowObject}
{cxbo/bocx403.i tt-decla-import-adic}
{cxbo/bocx404.i tt-decla-import-ord}
{cxbo/bocx00512.i tt-decla-imp-adic-it-trib}

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
DEFINE BUFFER bf-decla-import-adic FOR decla-import-adic.
DEF VAR i-num-adic   LIKE {&TABLENAME}.num-adic   NO-UNDO.
DEF VAR i-num-di-ems LIKE {&TABLENAME}.num-di-ems NO-UNDO.
DEF VAR de-cdd-siscomex-dts LIKE {&TABLENAME}.cdd-siscomex-dts NO-UNDO.
DEF VAR h-bocx403 AS HANDLE NO-UNDO.
DEF VAR h-bocx404 AS HANDLE NO-UNDO.
DEF VAR h-bocx383a AS HANDLE NO-UNDO.
def var h-bocx00512  as handle no-undo.
DEF VAR l-nt2024002  AS LOGICAL NO-UNDO.

ASSIGN l-nt2024002 = CAN-FIND(FIRST funcao NO-LOCK
                              WHERE funcao.cd-funcao = "spp-NT2024002":U AND funcao.ativo).

define temp-table tt-adicoes no-undo
    field cdn-adicao as integer
    field class-fiscal as CHAR
    field des-unid-medid-comerc as char
    field num-ocor-item as int
    field qt-itens as int
    field l-preco-maior as logical.

/*--- [ Referente alteraá∆o do IPP3 - Projeto 79 - Vis∆o DI ]-------------------------------*/ 
  /*{cxbo/bocx220a.i} /* Temp-table tt-parametros */*/
  {imp/im0100x.i tt-parametros}
  {cxbo/bocx220c.i tt-itens-aux} /* Temp-table auxiliar para criaá∆o dos itens do desembarque */  
  {include/boerrtab.i} /* Temp-table tt-bo-erro */
  DEF VAR i-seq-erro       AS   INTEGER NO-UNDO.
  DEF VAR i-cod-via-transp LIKE docum-est.via-transp NO-UNDO.
  DEF VAR i-cod-itiner     LIKE itinerario.cod-itiner NO-UNDO.
  DEF VAR i-mo-codigo      LIKE moeda.mo-codigo NO-UNDO.
  DEF VAR i-cod-cond-pag   LIKE cond-pagto.cod-cond-pag NO-UNDO.
  DEF VAR de-cotacao-dia   AS   DECIMAL FORMAT ">>>,>9.99999999" NO-UNDO.

  {include/i-epc200.i bocx402}  /* Temp-table tt-epc */
  {cdp/cd4300.i3} /* include tratamento atributo livre */

  DEFINE TEMP-TABLE tt-embarqueDI NO-UNDO 
      FIELD num-di-ems       LIKE decla-import.num-di-ems
      FIELD cod-estab        LIKE decla-import.cod-estab
      FIELD cod-embarq       LIKE decla-import-embarq.cod-embarq
      FIELD nro-docto        LIKE docum-est.nro-docto
      FIELD serie-docto      LIKE docum-est.serie-docto
      FIELD nat-operacao     LIKE docum-est.nat-operacao
      FIELD cod-emitente     LIKE docum-est.cod-emitente
      FIELD cod-estab-fiscal LIKE docum-est.cod-estabel
      FIELD dt-emissao       LIKE docum-est.dt-emissao
      FIELD dt-trans         LIKE docum-est.dt-trans
      FIELD dt-venc-icm      LIKE docum-est.dt-venc-icm
      FIELD dt-venc-ipi      LIKE docum-est.dt-venc-ipi
      FIELD ct-transit       AS   CHARACTER FORMAT "X(20)":U 
      FIELD sc-transit       AS   CHARACTER FORMAT "X(20)":U 
      FIELD tot-desconto     AS   DECIMAL FORMAT ">>>>>9,99":U
      FIELD aliquota-icm     AS   LOGICAL
      FIELD observacao       AS   CHARACTER FORMAT "x(2000)":U
      FIELD log-marcado      AS   LOGICAL
      FIELD log-nf-gerada    AS   LOGICAL.

  DEF VAR i-pto-contr-base LIKE pto-contr.cod-pto-contr NO-UNDO.
  DEF VAR c-pzo-com-refer  AS CHAR FORMAT "x(8)" NO-UNDO.
/*------------------------------------------------------------------------------------------*/

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
         HEIGHT             = 15.67
         WIDTH              = 39.43.
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
RUN pi-atualiza-import-ordem.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDeleteRecord DBOProgram 
PROCEDURE afterDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    IF  l-nt2024002 THEN DO:
        IF  NOT VALID-HANDLE(h-bocx00512) THEN 
            RUN cxbo/bocx00512.p PERSISTENT SET h-bocx00512.
        
        FOR EACH decla-imp-adic-it-trib EXCLUSIVE-LOCK
            WHERE decla-imp-adic-it-trib.num-di-ems       = RowObject.num-di-ems
            AND   decla-imp-adic-it-trib.num-adic         = RowObject.num-adic
            AND   decla-imp-adic-it-trib.num-seq          = RowObject.num-seq
            AND   decla-imp-adic-it-trib.cdd-siscomex-dts = RowObject.cdd-siscomex-dts:

            EMPTY TEMP-TABLE tt-decla-imp-adic-it-trib.
            CREATE tt-decla-imp-adic-it-trib.
            BUFFER-COPY decla-imp-adic-it-trib TO tt-decla-imp-adic-it-trib.

            IF  VALID-HANDLE(h-bocx00512) THEN DO:
                RUN openQueryStatic IN h-bocx00512 (INPUT 'Main':U).
                RUN emptyRowErrors  IN h-bocx00512.
                RUN goToKey         IN h-bocx00512 (input tt-decla-imp-adic-it-trib.num-di-ems, 
                                                    input tt-decla-imp-adic-it-trib.num-adic,
                                                    input tt-decla-imp-adic-it-trib.num-seq,
                                                    input tt-decla-imp-adic-it-trib.cdd-siscomex-dts,
                                                    input tt-decla-imp-adic-it-trib.nom-trib,
                                                    input tt-decla-imp-adic-it-trib.cod-campo).
                IF  RETURN-VALUE = "OK":U THEN DO:
                    RUN deleteRecord IN h-bocx00512.
                END. /* IF  RETURN-VALUE = "OK":U */
            END. /* IF  VALID-HANDLE(h-bocx00512) THEN DO: */
        END.
        
        IF VALID-HANDLE(h-bocx00512) THEN 
            DELETE PROCEDURE h-bocx00512.
        ASSIGN h-bocx00512 = ?.
    END.

    IF NOT CAN-FIND(FIRST bf{&tablename} 
                    WHERE bf{&TableName}.num-di-ems = RowObject.num-di-ems
                    AND   bf{&TableName}.num-adic   = RowObject.num-adic
                    AND   bf{&TableName}.cdd-siscomex-dts = RowObject.cdd-siscomex-dts) THEN DO:
    
        IF NOT VALID-HANDLE(h-bocx403) THEN RUN cxbo/bocx403.p PERSISTENT SET h-bocx403.    
        FOR FIRST bf-decla-import-adic NO-LOCK
            WHERE bf-decla-import-adic.num-di-ems = RowObject.num-di-ems
            AND   bf-decla-import-adic.num-adic   = RowObject.num-adic
            AND   bf-decla-import-adic.cdd-siscomex-dts = RowObject.cdd-siscomex-dts:

            EMPTY TEMP-TABLE tt-decla-import-adic.
            CREATE tt-decla-import-adic.
            BUFFER-COPY bf-decla-import-adic TO tt-decla-import-adic.

            IF  VALID-HANDLE(h-bocx403) THEN DO:
                RUN openQueryStatic IN h-bocx403 (INPUT 'Main':U).
                RUN emptyRowErrors  IN h-bocx403.
                RUN goToKey         IN h-bocx403 (INPUT tt-decla-import-adic.num-di-ems, INPUT tt-decla-import-adic.num-adic, INPUT tt-decla-import-adic.cdd-siscomex-dts).
                IF  RETURN-VALUE = "OK":U THEN DO:
                    RUN deleteRecord    IN h-bocx403.
                END. /* IF  RETURN-VALUE = "OK":U */
            END. /* IF  VALID-HANDLE(h-bocx403) THEN DO: */
        END. /* FOR FIRST decla-import-adic */
    END. /* IF  NOT CAN-FIND(FIRST bf{&TableName} */

    IF VALID-HANDLE(h-bocx403) THEN 
        DELETE PROCEDURE h-bocx403.
    ASSIGN h-bocx403 = ?.

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
RUN pi-atualiza-import-ordem.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gerarAdicoes DBOProgram 
PROCEDURE gerarAdicoes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:    
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pnum-di-ems LIKE decla-import-adic-itens.num-di-ems NO-UNDO.
  DEFINE INPUT PARAMETER pnum-adic   LIKE decla-import-adic-itens.num-adic NO-UNDO.
  DEFINE INPUT PARAMETER pnum-seq    LIKE decla-import-adic-itens.num-seq NO-UNDO.
  
  def var i-ult-adicao as integer no-undo.

  RUN validaCriacaoAdicoes (INPUT pnum-di-ems).
  IF  RETURN-VALUE = "NOK":U THEN RETURN "NOK":U.
  
  FOR EACH decla-import-adic-itens EXCLUSIVE-LOCK 
     WHERE decla-import-adic-itens.num-di-ems = pnum-di-ems:
    ASSIGN decla-import-adic-itens.num-adic = 0.
  END.

  ASSIGN i-ult-adicao = 0.

  empty temp-table tt-adicoes.
  
  FOR EACH decla-import-adic-itens EXCLUSIVE-LOCK
      WHERE decla-import-adic-itens.num-di-ems = pnum-di-ems:

     FIND FIRST ITEM NO-LOCK 
           WHERE ITEM.it-codigo = decla-import-adic-itens.cod-item NO-ERROR.
      IF NOT AVAIL ITEM THEN NEXT.

      IF NOT AVAIL tt-adicoes THEN DO:     

         ASSIGN i-ult-adicao = i-ult-adicao + 1.
         CREATE tt-adicoes.
         ASSIGN tt-adicoes.cdn-adicao            = i-ult-adicao
                tt-adicoes.class-fiscal          = ""
                tt-adicoes.des-unid-medid-comerc = ""
                tt-adicoes.num-ocor-item         = 0
                tt-adicoes.qt-itens              = 0
                tt-adicoes.l-preco-maior         = no.
      END.
  end.
  RELEASE decla-import-adic-itens.

  RUN atualizarAdicoes (INPUT pnum-di-ems ,
                        INPUT pnum-adic,
                        INPUT pnum-seq).
  
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
        WHEN "cod-embarq":U THEN ASSIGN pFieldValue = RowObject.cod-embarq.
        WHEN "cod-estab":U THEN ASSIGN pFieldValue = RowObject.cod-estab.
        WHEN "cod-item":U THEN ASSIGN pFieldValue = RowObject.cod-item.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-natur-operac":U THEN ASSIGN pFieldValue = RowObject.cod-natur-operac.
        WHEN "dsl-especif":U THEN ASSIGN pFieldValue = RowObject.dsl-especif.
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
        WHEN "qtd-adic[1]":U THEN ASSIGN pFieldValue = RowObject.qtd-adic[1].
        WHEN "qtd-adic[2]":U THEN ASSIGN pFieldValue = RowObject.qtd-adic[2].
        WHEN "val-acresc":U THEN ASSIGN pFieldValue = RowObject.val-acresc.
        WHEN "val-acresc-me[1]":U THEN ASSIGN pFieldValue = RowObject.val-acresc-me[1].
        WHEN "val-acresc-me[2]":U THEN ASSIGN pFieldValue = RowObject.val-acresc-me[2].
        WHEN "val-aliq-cofins":U THEN ASSIGN pFieldValue = RowObject.val-aliq-cofins.
        WHEN "val-aliq-icms":U THEN ASSIGN pFieldValue = RowObject.val-aliq-icms.
        WHEN "val-aliq-ii":U THEN ASSIGN pFieldValue = RowObject.val-aliq-ii.
        WHEN "val-aliq-ipi":U THEN ASSIGN pFieldValue = RowObject.val-aliq-ipi.
        WHEN "val-aliq-pis":U THEN ASSIGN pFieldValue = RowObject.val-aliq-pis.
        WHEN "val-base-cofins":U THEN ASSIGN pFieldValue = RowObject.val-base-cofins.
        WHEN "val-base-icms":U THEN ASSIGN pFieldValue = RowObject.val-base-icms.
        WHEN "val-base-ii":U THEN ASSIGN pFieldValue = RowObject.val-base-ii.
        WHEN "val-base-ipi":U THEN ASSIGN pFieldValue = RowObject.val-base-ipi.
        WHEN "val-base-pis":U THEN ASSIGN pFieldValue = RowObject.val-base-pis.
        WHEN "val-cofins-db-cr":U THEN ASSIGN pFieldValue = RowObject.val-cofins-db-cr.
        WHEN "val-cofins-nao-tributad":U THEN ASSIGN pFieldValue = RowObject.val-cofins-nao-tributad.
        WHEN "val-cofins-outras":U THEN ASSIGN pFieldValue = RowObject.val-cofins-outras.
        WHEN "val-cotac":U THEN ASSIGN pFieldValue = RowObject.val-cotac.
        WHEN "val-cub-tot":U THEN ASSIGN pFieldValue = RowObject.val-cub-tot.
        WHEN "val-frete":U THEN ASSIGN pFieldValue = RowObject.val-frete.
        WHEN "val-frete-me[1]":U THEN ASSIGN pFieldValue = RowObject.val-frete-me[1].
        WHEN "val-frete-me[2]":U THEN ASSIGN pFieldValue = RowObject.val-frete-me[2].
        WHEN "val-icms-db-cr":U THEN ASSIGN pFieldValue = RowObject.val-icms-db-cr.
        WHEN "val-icms-nao-tributad":U THEN ASSIGN pFieldValue = RowObject.val-icms-nao-tributad.
        WHEN "val-icms-outras":U THEN ASSIGN pFieldValue = RowObject.val-icms-outras.
        WHEN "val-ii-db-cr":U THEN ASSIGN pFieldValue = RowObject.val-ii-db-cr.
        WHEN "val-ii-nao-tribut":U THEN ASSIGN pFieldValue = RowObject.val-ii-nao-tribut.
        WHEN "val-ii-outras":U THEN ASSIGN pFieldValue = RowObject.val-ii-outras.
        WHEN "val-ipi-db-cr":U THEN ASSIGN pFieldValue = RowObject.val-ipi-db-cr.
        WHEN "val-ipi-nao-tributad":U THEN ASSIGN pFieldValue = RowObject.val-ipi-nao-tributad.
        WHEN "val-ipi-outras":U THEN ASSIGN pFieldValue = RowObject.val-ipi-outras.
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
        WHEN "val-perc-reduc-cofins":U THEN ASSIGN pFieldValue = RowObject.val-perc-reduc-cofins.
        WHEN "val-perc-reduc-icms":U THEN ASSIGN pFieldValue = RowObject.val-perc-reduc-icms.
        WHEN "val-perc-reduc-impto-import":U THEN ASSIGN pFieldValue = RowObject.val-perc-reduc-impto-import.
        WHEN "val-perc-reduc-ipi":U THEN ASSIGN pFieldValue = RowObject.val-perc-reduc-ipi.
        WHEN "val-perc-reduc-pis":U THEN ASSIGN pFieldValue = RowObject.val-perc-reduc-pis.
        WHEN "val-peso-brut-merc":U THEN ASSIGN pFieldValue = RowObject.val-peso-brut-merc.
        WHEN "val-peso-liq":U THEN ASSIGN pFieldValue = RowObject.val-peso-liq.
        WHEN "val-pis-db-cr":U THEN ASSIGN pFieldValue = RowObject.val-pis-db-cr.
        WHEN "val-pis-nao-tributad":U THEN ASSIGN pFieldValue = RowObject.val-pis-nao-tributad.
        WHEN "val-pis-outras":U THEN ASSIGN pFieldValue = RowObject.val-pis-outras.
        WHEN "val-seguro":U THEN ASSIGN pFieldValue = RowObject.val-seguro.
        WHEN "val-seguro-me[1]":U THEN ASSIGN pFieldValue = RowObject.val-seguro-me[1].
        WHEN "val-seguro-me[2]":U THEN ASSIGN pFieldValue = RowObject.val-seguro-me[2].
        WHEN "val-unit-cofins":U THEN ASSIGN pFieldValue = RowObject.val-unit-cofins.
        WHEN "val-unit-icms":U THEN ASSIGN pFieldValue = RowObject.val-unit-icms.
        WHEN "val-unit-ii":U THEN ASSIGN pFieldValue = RowObject.val-unit-ii.
        WHEN "val-unit-ipi":U THEN ASSIGN pFieldValue = RowObject.val-unit-ipi.
        WHEN "val-unit-pis":U THEN ASSIGN pFieldValue = RowObject.val-unit-pis.
        WHEN "val-vmcv":U THEN ASSIGN pFieldValue = RowObject.val-vmcv.
        WHEN "val-vmcv-me[1]":U THEN ASSIGN pFieldValue = RowObject.val-vmcv-me[1].
        WHEN "val-vmcv-me[2]":U THEN ASSIGN pFieldValue = RowObject.val-vmcv-me[2].
        WHEN "val-vmld":U THEN ASSIGN pFieldValue = RowObject.val-vmld.
        WHEN "val-vmld-me[1]":U THEN ASSIGN pFieldValue = RowObject.val-vmld-me[1].
        WHEN "val-vmld-me[2]":U THEN ASSIGN pFieldValue = RowObject.val-vmld-me[2].
        WHEN "val-vmle":U THEN ASSIGN pFieldValue = RowObject.val-vmle.
        WHEN "val-vmle-me[1]":U THEN ASSIGN pFieldValue = RowObject.val-vmle-me[1].
        WHEN "val-vmle-me[2]":U THEN ASSIGN pFieldValue = RowObject.val-vmle-me[2].
        WHEN "val-vucv":U THEN ASSIGN pFieldValue = RowObject.val-vucv.
        WHEN "val-vucv-me[1]":U THEN ASSIGN pFieldValue = RowObject.val-vucv-me[1].
        WHEN "val-vucv-me[2]":U THEN ASSIGN pFieldValue = RowObject.val-vucv-me[2].
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
        WHEN "cdn-moed-acresc":U THEN ASSIGN pFieldValue = RowObject.cdn-moed-acresc.
        WHEN "cdn-moed-frete":U THEN ASSIGN pFieldValue = RowObject.cdn-moed-frete.
        WHEN "cdn-moed-seguro":U THEN ASSIGN pFieldValue = RowObject.cdn-moed-seguro.
        WHEN "cdn-moed-vucv":U THEN ASSIGN pFieldValue = RowObject.cdn-moed-vucv.
        WHEN "cdn-moeda":U THEN ASSIGN pFieldValue = RowObject.cdn-moeda.
        WHEN "idi-tributac-cofins":U THEN ASSIGN pFieldValue = RowObject.idi-tributac-cofins.
        WHEN "idi-tributac-icms":U THEN ASSIGN pFieldValue = RowObject.idi-tributac-icms.
        WHEN "idi-tributac-impto-import":U THEN ASSIGN pFieldValue = RowObject.idi-tributac-impto-import.
        WHEN "idi-tributac-ipi":U THEN ASSIGN pFieldValue = RowObject.idi-tributac-ipi.
        WHEN "idi-tributac-pis":U THEN ASSIGN pFieldValue = RowObject.idi-tributac-pis.
        WHEN "num-adic":U THEN ASSIGN pFieldValue = RowObject.num-adic.
        WHEN "num-di-ems":U THEN ASSIGN pFieldValue = RowObject.num-di-ems.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "num-ordem":U THEN ASSIGN pFieldValue = RowObject.num-ordem.
        WHEN "num-parcela":U THEN ASSIGN pFieldValue = RowObject.num-parcela.
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
  Purpose:     Retorna valores dos campos do °ndice dclmpdct-id
  Parameters:  
               retorna valor do campo num-di-ems
               retorna valor do campo num-adic
               retorna valor do campo num-seq
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnum-di-ems LIKE decla-import-adic-itens.num-di-ems NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-adic LIKE decla-import-adic-itens.num-adic NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-seq LIKE decla-import-adic-itens.num-seq NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnum-di-ems = RowObject.num-di-ems
           pnum-adic = RowObject.num-adic
           pnum-seq = RowObject.num-seq.

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
        WHEN "log-cofins-unid":U THEN ASSIGN pFieldValue = RowObject.log-cofins-unid.
        WHEN "log-ipi-unid":U THEN ASSIGN pFieldValue = RowObject.log-ipi-unid.
        WHEN "log-livre-1":U THEN ASSIGN pFieldValue = RowObject.log-livre-1.
        WHEN "log-livre-2":U THEN ASSIGN pFieldValue = RowObject.log-livre-2.
        WHEN "log-pis-unid":U THEN ASSIGN pFieldValue = RowObject.log-pis-unid.
        WHEN "log-suspens-impto-import":U THEN ASSIGN pFieldValue = RowObject.log-suspens-impto-import.
        WHEN "log-suspens-ipi-import":U THEN ASSIGN pFieldValue = RowObject.log-suspens-ipi-import.
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
  Purpose:     Reposiciona registro com base no °ndice dclmpdct-id
  Parameters:  
               recebe valor do campo num-di-ems
               recebe valor do campo num-adic
               recebe valor do campo num-seq
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnum-di-ems LIKE decla-import-adic-itens.num-di-ems NO-UNDO.
    DEFINE INPUT PARAMETER pnum-adic LIKE decla-import-adic-itens.num-adic NO-UNDO.
    DEFINE INPUT PARAMETER pnum-seq LIKE decla-import-adic-itens.num-seq NO-UNDO.
    DEFINE INPUT PARAMETER pcdd-siscomex-dts LIKE decla-import-adic-itens.cdd-siscomex-dts NO-UNDO.

    FIND FIRST bfdecla-import-adic-itens WHERE 
        bfdecla-import-adic-itens.num-di-ems = pnum-di-ems AND 
        bfdecla-import-adic-itens.num-adic = pnum-adic AND 
        bfdecla-import-adic-itens.num-seq = pnum-seq AND 
        bfdecla-import-adic-itens.cdd-siscomex-dts = pcdd-siscomex-dts NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfdecla-import-adic-itens THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfdecla-import-adic-itens)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByAdicao DBOProgram 
PROCEDURE openQueryByAdicao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
OPEN QUERY {&QUERYNAME} FOR EACH  {&TABLENAME} NO-LOCK 
                            WHERE {&TABLENAME}.num-di-ems = i-num-di-ems
                            AND   {&TABLENAME}.num-adic   = i-num-adic 
                            AND   {&TABLENAME}.cdd-siscomex-dts = de-cdd-siscomex-dts INDEXED-REPOSITION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByDI DBOProgram 
PROCEDURE openQueryByDI :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
OPEN QUERY {&QUERYNAME} FOR EACH  {&TABLENAME} 
                            WHERE {&TABLENAME}.num-di-ems = i-num-di-ems 
                              AND {&TABLENAME}.cdd-siscomex-dts = de-cdd-siscomex-dts NO-LOCK INDEXED-REPOSITION.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-import-ordem DBOProgram 
PROCEDURE pi-atualiza-import-ordem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE i-seq AS INTEGER     NO-UNDO.

FIND LAST decla-import-ord
    WHERE decla-import-ord.num-di-ems  = RowObject.num-di-ems
    AND   decla-import-ord.num-adic    = RowObject.num-adic 
    AND   decla-import-ord.cdd-siscomex-dts = RowObject.cdd-siscomex-dts NO-LOCK NO-ERROR.
IF AVAIL decla-import-ord THEN
    ASSIGN i-seq = decla-import-ord.num-seq + 1.
ELSE 
    ASSIGN i-seq = 1.

FOR FIRST decla-import-ord EXCLUSIVE-LOCK
    WHERE decla-import-ord.num-di-ems  = RowObject.num-di-ems  
    AND   decla-import-ord.num-ordem   = RowObject.num-ordem   
    AND   decla-import-ord.num-parcela = RowObject.num-parcela 
    AND   decla-import-ord.num-seq     = 0
    AND   decla-import-ord.cdd-siscomex-dts = RowObject.cdd-siscomex-dts:

    EMPTY TEMP-TABLE tt-decla-import-ord.
    CREATE tt-decla-import-ord.
    BUFFER-COPY decla-import-ord TO tt-decla-import-ord.
    ASSIGN tt-decla-import-ord.num-adic = RowObject.num-adic
           tt-decla-import-ord.num-seq  = i-seq.
            
    IF NOT VALID-HANDLE(h-bocx404) THEN 
        RUN cxbo/bocx404.p PERSISTENT SET h-bocx404.
    
    RUN openQueryStatic  IN h-bocx404 (INPUT 'Main':U).
    RUN goToKey          IN h-bocx404 (INPUT tt-decla-import-ord.num-di-ems,
                                       INPUT tt-decla-import-ord.num-ordem,
                                       INPUT tt-decla-import-ord.num-parcela,
                                       INPUT tt-decla-import-ord.cdd-siscomex-dts).
    IF RETURN-VALUE = "NOK" THEN DO:
        RUN setRecord      IN h-bocx404 (INPUT TABLE tt-decla-import-ord).
        RUN createRecord   IN h-bocx404.
    END.
    ELSE DO:
        RUN setRecord      IN h-bocx404 (INPUT TABLE tt-decla-import-ord).
        RUN updateRecord   IN h-bocx404.
    END.
END.

IF VALID-HANDLE(h-bocx404) THEN 
    DELETE PROCEDURE h-bocx404.
ASSIGN h-bocx404 = ?.

RELEASE decla-import-ord.
RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-valores-impostos DBOProgram 
PROCEDURE pi-busca-valores-impostos :
/*------------------------------------------------------------------------------
  Purpose:     Procedure respons†vel por buscar os valores dos impostos calculados
               pelo configurador na tabela "decla-import-adic-itens" e atualizar 
               as mesmas por "Adiá∆o" (IM0410B)
  Parameters:  pi-num-di-ems             (entrada): n£mero da DI EMS da adiá∆o (integer)
               pi-num-adic               (entrada): n£mero da Adiá∆o da DI     (integer)
               pde-val-aliq-fcp          (sa°da): al°quota do FCP              (decimal)
               pde-val-base-fcp          (sa°da): base do FCP                  (decimal)
               pde-val-fcp               (sa°da): valor do FCP                 (decimal)
               pde-val-aliq-fcp-substto  (sa°da): al°quota do FCP ST           (decimal)
               pde-val-base-fcp-substto  (sa°da): base do FCP ST               (decimal)
               pde-val-fcp-substto       (sa°da): valor do FCP ST              (decimal)
               pde-val-base-icms-substto (sa°da): base do ICMS ST              (decimal)
               pde-val-icms-substto      (sa°da): valor do ICMS ST             (decimal)
               pde-val-base-icms-compltar(sa°da): base do ICMS complementar    (decimal)
               pde-val-icms-compltar     (sa°da): valor do ICMS complementar   (decimal)
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pi-num-di-ems               LIKE decla-import-adic.num-di-ems                   NO-UNDO.
    DEFINE INPUT  PARAMETER pi-num-adic                 LIKE decla-import-adic.num-adic                     NO-UNDO.
    DEFINE INPUT  PARAMETER p-cdd-siscomex-dts          LIKE decla-import-adic.cdd-siscomex-dts             NO-UNDO.
    DEFINE OUTPUT PARAMETER pde-val-aliq-fcp            LIKE decla-import-adic-itens.val-aliq-fcp           NO-UNDO.
    DEFINE OUTPUT PARAMETER pde-val-base-fcp            LIKE decla-import-adic-itens.val-base-fcp           NO-UNDO.
    DEFINE OUTPUT PARAMETER pde-val-fcp                 LIKE decla-import-adic-itens.val-fcp                NO-UNDO.
    DEFINE OUTPUT PARAMETER pde-val-aliq-fcp-substto    LIKE decla-import-adic-itens.val-aliq-fcp-substto   NO-UNDO.
    DEFINE OUTPUT PARAMETER pde-val-base-fcp-substto    LIKE decla-import-adic-itens.val-base-fcp-substto   NO-UNDO.
    DEFINE OUTPUT PARAMETER pde-val-fcp-substto         LIKE decla-import-adic-itens.val-fcp-substto        NO-UNDO.
    DEFINE OUTPUT PARAMETER pde-val-base-icms-substto   LIKE decla-import-adic-itens.val-base-icms-substto  NO-UNDO.
    DEFINE OUTPUT PARAMETER pde-val-icms-substto        LIKE decla-import-adic-itens.val-icms-substto       NO-UNDO.
    DEFINE OUTPUT PARAMETER pde-val-base-icms-compltar  LIKE decla-import-adic-itens.val-base-icms-compltar NO-UNDO.
    DEFINE OUTPUT PARAMETER pde-val-icms-compltar       LIKE decla-import-adic-itens.val-icms-compltar      NO-UNDO.
    
    FOR EACH decla-import-adic-itens
       WHERE decla-import-adic-itens.num-di-ems = pi-num-di-ems
         AND decla-import-adic-itens.num-adic   = pi-num-adic   
         AND decla-import-adic-itens.cdd-siscomex-dts = p-cdd-siscomex-dts NO-LOCK:

        ASSIGN pde-val-aliq-fcp           = decla-import-adic-itens.val-aliq-fcp           
               pde-val-base-fcp           = pde-val-base-fcp           + decla-import-adic-itens.val-base-fcp          
               pde-val-fcp                = pde-val-fcp                + decla-import-adic-itens.val-fcp               
               pde-val-aliq-fcp-substto   = decla-import-adic-itens.val-aliq-fcp-substto  
               pde-val-base-fcp-substto   = pde-val-base-fcp-substto   + decla-import-adic-itens.val-base-fcp-substto  
               pde-val-fcp-substto        = pde-val-fcp-substto        + decla-import-adic-itens.val-fcp-substto       
               pde-val-base-icms-substto  = pde-val-base-icms-substto  + decla-import-adic-itens.val-base-icms-substto 
               pde-val-icms-substto       = pde-val-icms-substto       + decla-import-adic-itens.val-icms-substto      
               pde-val-base-icms-compltar = pde-val-base-icms-compltar + decla-import-adic-itens.val-base-icms-compltar
               pde-val-icms-compltar      = pde-val-icms-compltar      + decla-import-adic-itens.val-icms-compltar.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-forn-fabr DBOProgram 
PROCEDURE pi-forn-fabr :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    def  input param pcod-item       like decla-import-adic-itens.cod-item no-undo.
    def  input param pcdn-fornec     like decla-import-adic.cdn-fornec no-undo.
    def output param pcdn-fabrican   like decla-import-adic.cdn-fabrican no-undo.
    def output param patualiza-campo as   logical no-undo.

    find first cotacao-item no-lock
        where  cotacao-item.it-codigo = pcod-item no-error.
    if  avail  cotacao-item 
    then assign pcdn-fabrican = cotacao-item.cdn-fabrican.
    else do:
        find first item-fornec no-lock
            where  item-fornec.it-codigo = pcod-item no-error.
        if  avail  item-fornec
        then assign pcdn-fabrican = item-fornec.cod-emitente.
        else do:
            find first item-mat no-lock
                where  item-mat.it-codigo = pcod-item no-error.
            if  avail  item-mat 
            then assign pcdn-fabrican = item-mat.cdn-fabrican.
            else assign pcdn-fabrican = 0.
        end. /* else do: */
    end. /* else do: */

    if  pcdn-fabrican <> 0 then assign patualiza-campo = yes.
                           else assign patualiza-campo = no.

    return 'ok':U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-chave-cd0763 DBOProgram 
PROCEDURE pi-retorna-chave-cd0763 :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pi-num-di-ems         LIKE decla-import-adic-itens.num-di-ems NO-UNDO.
    DEFINE INPUT  PARAMETER pd-cdd-siscomex-dts   LIKE decla-import-adic-itens.cdd-siscomex-dts NO-UNDO.
    DEFINE OUTPUT PARAMETER pi-cod-emitente       LIKE decla-import-adic.cdn-fornec       NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-nat-operacao       LIKE decla-import-ord.cod-natur-operac  NO-UNDO.

    FOR FIRST decla-import
        WHERE decla-import.num-di-ems = pi-num-di-ems
          AND decla-import.cdd-siscomex-dts = pd-cdd-siscomex-dts
          AND decla-import.log-ativo,
        FIRST decla-import-ord 
        WHERE decla-import-ord.num-di-ems = decla-import.num-di-ems
          AND decla-import-ord.cdd-siscomex-dts = decla-import.cdd-siscomex-dts,
        FIRST decla-import-adic
        WHERE decla-import-adic.num-di-ems = decla-import-ord.num-di-ems
          AND decla-import-adic.cdd-siscomex-dts = decla-import-ord.cdd-siscomex-dts:

        ASSIGN pi-cod-emitente = decla-import-adic.cdn-fornec
               pc-nat-operacao = decla-import-ord.cod-natur-operac.

    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piContaRegistro DBOProgram 
PROCEDURE piContaRegistro :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    
    def  input param pnum-di-ems       like bf{&TableName}.num-di-ems       no-undo.
    def  input param pcdd-siscomex-dts like bf{&TableName}.cdd-siscomex-dts no-undo.
    def  input param pnum-adic         like bf{&TableName}.num-adic         no-undo.
    def output param pnum-registros    as   integer                         no-undo.

    def var i-conta as integer no-undo.

    assign i-conta = 0.

    for each  bf{&TABLENAME} no-lock 
        where bf{&TABLENAME}.num-di-ems       = pnum-di-ems
        AND   bf{&TABLENAME}.cdd-siscomex-dts = pcdd-siscomex-dts
        AND   bf{&TABLENAME}.num-adic         = pnum-adic:
        assign i-conta = i-conta + 1.
    end. /* for each  decla-import-ord */

    assign pnum-registros = i-conta.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaCondPagto DBOProgram 
PROCEDURE retornaCondPagto :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    DEF OUTPUT  PARAM p-cod-cond-pagto   LIKE cond-pagto.cod-cond-pag NO-UNDO.

    ASSIGN p-cod-cond-pagto = i-cod-cond-pag.
 
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaItinerario DBOProgram 
PROCEDURE retornaItinerario :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    DEF OUTPUT  PARAM p-cod-itiner   LIKE itinerario.cod-itiner NO-UNDO.

    ASSIGN p-cod-itiner = i-cod-itiner.
 
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaMoCodigo DBOProgram 
PROCEDURE retornaMoCodigo :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    DEF OUTPUT  PARAM p-mo-codigo   LIKE moeda.mo-codigo NO-UNDO.

    ASSIGN p-mo-codigo = i-mo-codigo.
 
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaProxNota DBOProgram 
PROCEDURE retornaProxNota :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER pnat-operacao LIKE docum-est.nat-operacao NO-UNDO.
    DEFINE INPUT  PARAMETER pcod-estabel  LIKE docum-est.cod-estabel  NO-UNDO.
    DEFINE INPUT  PARAMETER pserie-docto  LIKE docum-est.serie-docto  NO-UNDO.
    DEFINE INPUT  PARAMETER pcod-embarq   LIKE decla-import-embarq.cod-embarq NO-UNDO.
    DEFINE INPUT  PARAMETER TABLE FOR tt-embarqueDI.
    DEFINE OUTPUT PARAMETER pProx-nro     AS   CHARACTER NO-UNDO.

    ASSIGN pProx-nro = "".

    IF  CAN-FIND(FIRST natur-oper 
                 WHERE natur-oper.nat-operacao = pnat-operacao
                 AND   natur-oper.imp-nota /* Gera Nota Faturamento */) THEN DO:
        FIND FIRST ser-estab NO-LOCK
            WHERE  ser-estab.serie       = pserie-docto
            AND    ser-estab.cod-estabel = pcod-estabel NO-ERROR.
        IF  AVAIL  ser-estab THEN DO:

            IF CAN-FIND(FIRST tt-embarqueDI
                        WHERE tt-embarqueDI.cod-estab    = ser-estab.cod-estabel
                        AND   tt-embarqueDI.serie-docto  = ser-estab.serie
                        AND   tt-embarqueDI.nat-operacao = pnat-operacao
                        AND   tt-embarqueDI.cod-embarq  <> pcod-embarq ) THEN DO:
                
                FOR LAST  tt-embarqueDI
                    WHERE tt-embarqueDI.cod-estab    = ser-estab.cod-estabel
                    AND   tt-embarqueDI.serie-docto  = ser-estab.serie
                    AND   tt-embarqueDI.nat-operacao = pnat-operacao
                    AND   tt-embarqueDI.cod-embarq  <> pcod-embarq :
                
                    &if '{&bf_libera_15_posicoes}' = 'yes' &then
                        ASSIGN pProx-nro = STRING(DEC(tt-embarqueDI.nro-docto) + 1,">>>>>>>>9999999":U).
                    &else
                        ASSIGN pProx-nro = STRING(DEC(tt-embarqueDI.nro-docto) + 1,">>>9999999":U).
                    &endif
                END.
            END.
            ELSE DO:
                &if '{&bf_libera_15_posicoes}' = 'yes' &then
                    ASSIGN pProx-nro = STRING(DEC(ser-estab.nr-ult-nota) + 1,">>>>>>>>9999999":U).
                &else
                    ASSIGN pProx-nro = STRING(DEC(ser-estab.nr-ult-nota) + 1,">>>9999999":U).
                &endif
            END.
        END.            
        ELSE ASSIGN pProx-nro = "".
    END. /* IF  CAN-FIND(FIRST natur-oper */
    ELSE ASSIGN pProx-nro = "".

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaPtoControlBase DBOProgram 
PROCEDURE retornaPtoControlBase :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    DEF OUTPUT  PARAM p-pto-contr-base   LIKE pto-contr.cod-pto-contr NO-UNDO.

    ASSIGN p-pto-contr-base = i-pto-contr-base.
 
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gerarItensbyDI DBOProgram 
{cxbo/bocx402.i1} /* PROCEDURE gerarItensbyDI : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByAdicao DBOProgram 
PROCEDURE setConstraintByAdicao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM p-num-di-ems LIKE {&TABLENAME}.num-di-ems NO-UNDO.
DEF INPUT PARAM p-num-adic   LIKE {&TABLENAME}.num-adic   NO-UNDO.
DEF INPUT PARAM p-cdd-siscomex-dts LIKE {&TABLENAME}.cdd-siscomex-dts NO-UNDO.

ASSIGN i-num-adic   = p-num-adic   
       i-num-di-ems = p-num-di-ems
       de-cdd-siscomex-dts = p-cdd-siscomex-dts.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByDI DBOProgram 
PROCEDURE setConstraintByDI :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM pNumDiEms LIKE {&TABLENAME}.num-di-ems NO-UNDO.
DEF INPUT PARAM pCddSiscomexDts LIKE {&TABLENAME}.cdd-siscomex-dts NO-UNDO.

ASSIGN i-num-di-ems = pNumDiEms
       de-cdd-siscomex-dts = pCddSiscomexDts.

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
    
    /*
    EM COMENTµRIO ATê A CRIAÄ«O DO CAMPO NA TABELA ...
    IF  RowObject.cdn-fabrican = "" THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber      = "17394"
                                    &ErrorDescription = "Fabricante Ç obrigat¢rio(a)."
                                    &ErrorType        = "EMS"
                                    &ErrorSubType     = "ERROR"}
    END.
    else do:
        if  not can-find(first emitente
                         where emitente.cod-emitente = RowObject.cdn-fabrican then do:
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS"
                                        &ErrorParameters="'Fabricante'"}
        end. /* if not can-find(first emitente */
    end. /* else do: */
    */
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaCalculosDI DBOProgram 
PROCEDURE verificaCalculosDI :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER pnum-di-siscomex  LIKE decla-import.cod-di-siscomex NO-UNDO.
    DEFINE OUTPUT PARAMETER plog-situacao     AS   LOGICAL NO-UNDO.
    DEFINE OUTPUT PARAMETER pcalculo-faltante AS   CHARACTER FORMAT 'x(20)':U NO-UNDO.

    ASSIGN plog-situacao     = YES
           pcalculo-faltante = "":U.

    /*---[ Rateio de Valores ]-----------------------------------*/
    IF  NOT CAN-FIND(FIRST decla-import
                     WHERE decla-import.cod-di-siscomex = pnum-di-siscomex
                     AND   decla-import.log-pend-rat) THEN DO:
        ASSIGN plog-situacao     = NO
               pcalculo-faltante = 'Rateio de Valores':U.

        RETURN 'NOK':U.
    END. /* IF  NOT CAN-FIND(FIRST decla-import */

    /*---[ C†lculo dos Impostos ]--------------------------------*/
    IF  NOT CAN-FIND(FIRST decla-import
                     WHERE decla-import.cod-di-siscomex = pnum-di-siscomex
                     AND   &if '{&bf_mat_versao_ems}' < '2.09' &then
                           decla-import.log-livre-2
                           &else
                           decla-import.log-pend-impto
                           &endif) THEN DO:
        ASSIGN plog-situacao     = NO
               pcalculo-faltante = 'C†lculo de Impostos':U.

        RETURN 'NOK':U.
    END. /* IF  NOT CAN-FIND(FIRST decla-import */

    RETURN 'OK':U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaRelacAdicItens DBOProgram 
PROCEDURE verificaRelacAdicItens :
/*------------------------------------------------------------------------------
  Purpose: Verificar se existe adiá‰es geradas para um embarque.
  Parameters: Recebe c¢digo do embarque e do estabelecimento
              Retorna se encontrou um registro 
   Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM pembarque        LIKE decla-import-embarq.cod-embarq  NO-UNDO.
    DEF INPUT  PARAM pcod-estabel     LIKE decla-import-embarq.cod-estab   NO-UNDO.
    DEF OUTPUT PARAM pl-encontrou-adic-itens  AS LOGICAL                   NO-UNDO.
    
    ASSIGN pl-encontrou-adic-itens  = NO.

    FIND FIRST decla-import-embarq NO-LOCK
         WHERE decla-import-embarq.cod-embarq = pembarque
           AND decla-import-embarq.cod-estab  = pcod-estabel NO-ERROR.

    IF  AVAIL  decla-import-embarq THEN DO:
        FOR FIRST decla-import NO-LOCK
            WHERE decla-import.num-di-ems = decla-import-embarq.num-di-ems
              AND decla-import.cdd-siscomex-dts = decla-import-embarq.cdd-siscomex-dts:
            
            FIND FIRST bf{&TABLENAME} NO-LOCK
                 WHERE bf{&TABLENAME}.num-di-ems = decla-import.num-di-ems
                   AND bf{&TABLENAME}.cdd-siscomex-dts = decla-import.cdd-siscomex-dts
                   AND bf{&TABLENAME}.cod-embarq = pembarque 
                   AND bf{&TABLENAME}.cod-estab  = decla-import.cod-estab NO-ERROR.
            
            IF AVAIL bf{&TABLENAME} THEN
                ASSIGN pl-encontrou-adic-itens = YES.         
                    
        END. /* FOR FIRST decla-import */
    END. /* IF  AVAIL  decla-import-embarq */

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaRelacionamentos DBOProgram 
PROCEDURE verificaRelacionamentos :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT  PARAM pembarque        LIKE decla-import-embarq.cod-embarq NO-UNDO.
    DEF INPUT  PARAM pcod-estabel     LIKE decla-import-embarq.cod-estab  NO-UNDO.
    DEF OUTPUT PARAM pnum-di-siscomex LIKE decla-import.cod-di-siscomex   NO-UNDO.
    DEF OUTPUT PARAM pl-encontrou     AS LOGICAL                          NO-UNDO.
    DEF OUTPUT PARAM pdata-di         LIKE decla-import.dat-di            NO-UNDO.
    DEF OUTPUT PARAM pnat-operacao    LIKE decla-import.cod-natur-operac  NO-UNDO.
    
    ASSIGN pl-encontrou = NO.
    FIND FIRST decla-import-embarq NO-LOCK
        WHERE  decla-import-embarq.cod-embarq = pembarque
        AND    decla-import-embarq.cod-estab  = pcod-estabel NO-ERROR.

    IF  AVAIL  decla-import-embarq THEN DO:
        
        FOR FIRST decla-import NO-LOCK
            WHERE decla-import.num-di-ems = decla-import-embarq.num-di-ems
              AND decla-import.cdd-siscomex-dts = decla-import-embarq.cdd-siscomex-dts:
            
            FIND FIRST decla-import-ord NO-LOCK
                WHERE decla-import-ord.num-di-ems = decla-import.num-di-ems
                AND   decla-import-ord.cdd-siscomex-dts = decla-import.cdd-siscomex-dts
                AND   decla-import-ord.cod-embarq = pembarque 
                AND   decla-import-ord.cod-estab  = decla-import.cod-estab NO-ERROR.
            
            IF AVAIL decla-import-ord THEN
                ASSIGN pl-encontrou     = YES                             
                       pnum-di-siscomex = decla-import.cod-di-siscomex
                       pdata-di         = decla-import.dat-di
                       pnat-operacao    = decla-import-ord.cod-natur-operac. 
            ELSE
                IF CAN-FIND(FIRST decla-import-embarq NO-LOCK
                                WHERE decla-import-embarq.num-di-ems = decla-import.num-di-ems
                                AND   decla-import-embarq.cdd-siscomex-dts = decla-import.cdd-siscomex-dts
                                AND   decla-import-embarq.cod-embarq = pembarque ) THEN
                    ASSIGN pl-encontrou     = YES
                           pnum-di-siscomex = decla-import.cod-di-siscomex
                           pdata-di         = decla-import.dat-di .
        END. /* FOR FIRST decla-import */
    END. /* IF  AVAIL  decla-import-embarq */
    ELSE ASSIGN pl-encontrou     = NO
                pnum-di-siscomex = ""
                pdata-di         = ?
                pnat-operacao    = "".
 
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



