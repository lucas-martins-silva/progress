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

/* ***************************  Definitions  **************************** */
{include/i-prgvrs.i BOIN107 2.00.00.004 } /*** "010004" 11/12/2023 10:13:30 ***/
/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN107
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName estabelec
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

&GLOBAL-DEFINE KeyField1 cod-estabel /*:T Informar os campos da chave quando o Progress n∆o conseguir resolver find {&TableName} OF RowObject. */
&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (mÇtodo Receive Message) */
&GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES                   
      
     
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
{inbo/boin107.i RowObject}


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
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 2
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
        WHEN "bairro":U THEN ASSIGN pFieldValue = RowObject.bairro.
        WHEN "cd-calen":U THEN ASSIGN pFieldValue = RowObject.cd-calen.
        WHEN "cgc":U THEN ASSIGN pFieldValue = RowObject.cgc.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cidade":U THEN ASSIGN pFieldValue = RowObject.cidade.
        WHEN "cod-cta-cofins-ativ-recup":U THEN ASSIGN pFieldValue = RowObject.cod-cta-cofins-ativ-recup.
        WHEN "cod-cta-cofins-recup":U THEN ASSIGN pFieldValue = RowObject.cod-cta-cofins-recup.
        WHEN "cod-cta-cofins-substto":U THEN ASSIGN pFieldValue = RowObject.cod-cta-cofins-substto.
        WHEN "cod-cta-icms-antecip":U THEN ASSIGN pFieldValue = RowObject.cod-cta-icms-antecip.
        WHEN "cod-cta-icms-ativ-recup":U THEN ASSIGN pFieldValue = RowObject.cod-cta-icms-ativ-recup.
        WHEN "cod-cta-icms-presmdo":U THEN ASSIGN pFieldValue = RowObject.cod-cta-icms-presmdo.
        WHEN "cod-cta-pis-ativ-recup":U THEN ASSIGN pFieldValue = RowObject.cod-cta-pis-ativ-recup.
        WHEN "cod-cta-pis-recup":U THEN ASSIGN pFieldValue = RowObject.cod-cta-pis-recup.
        WHEN "cod-cta-pis-substto":U THEN ASSIGN pFieldValue = RowObject.cod-cta-pis-substto.
        WHEN "cod-cta-transit-icms-antecip":U THEN ASSIGN pFieldValue = RowObject.cod-cta-transit-icms-antecip.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-suframa":U THEN ASSIGN pFieldValue = RowObject.cod-suframa.
        WHEN "condado":U THEN ASSIGN pFieldValue = RowObject.condado.
        WHEN "conta-cheque-dev":U THEN ASSIGN pFieldValue = RowObject.conta-cheque-dev.
        WHEN "conta-cheque-subs":U THEN ASSIGN pFieldValue = RowObject.conta-cheque-subs.
        WHEN "conta-cofins":U THEN ASSIGN pFieldValue = RowObject.conta-cofins.
        WHEN "conta-credito":U THEN ASSIGN pFieldValue = RowObject.conta-credito.
        WHEN "conta-cusprod":U THEN ASSIGN pFieldValue = RowObject.conta-cusprod.
        WHEN "conta-desconto":U THEN ASSIGN pFieldValue = RowObject.conta-desconto.
        WHEN "conta-desp-cart-pagas":U THEN ASSIGN pFieldValue = RowObject.conta-desp-cart-pagas.
        WHEN "conta-desp-cart-receb":U THEN ASSIGN pFieldValue = RowObject.conta-desp-cart-receb.
        WHEN "conta-desp-equaliz":U THEN ASSIGN pFieldValue = RowObject.conta-desp-equaliz.
        WHEN "conta-desp-fin":U THEN ASSIGN pFieldValue = RowObject.conta-desp-fin.
        WHEN "conta-desp-icms":U THEN ASSIGN pFieldValue = RowObject.conta-desp-icms.
        WHEN "conta-desp-iof":U THEN ASSIGN pFieldValue = RowObject.conta-desp-iof.
        WHEN "conta-desp-iss":U THEN ASSIGN pFieldValue = RowObject.conta-desp-iss.
        WHEN "conta-despesas":U THEN ASSIGN pFieldValue = RowObject.conta-despesas.
        WHEN "conta-dev-icms":U THEN ASSIGN pFieldValue = RowObject.conta-dev-icms.
        WHEN "conta-dev-ipi":U THEN ASSIGN pFieldValue = RowObject.conta-dev-ipi.
        WHEN "conta-devolucao":U THEN ASSIGN pFieldValue = RowObject.conta-devolucao.
        WHEN "conta-extorno-icms":U THEN ASSIGN pFieldValue = RowObject.conta-extorno-icms.
        WHEN "conta-extorno-ipi":U THEN ASSIGN pFieldValue = RowObject.conta-extorno-ipi.
        WHEN "conta-fin-pag":U THEN ASSIGN pFieldValue = RowObject.conta-fin-pag.
        WHEN "conta-icms":U THEN ASSIGN pFieldValue = RowObject.conta-icms.
        WHEN "conta-icms-comp":U THEN ASSIGN pFieldValue = RowObject.conta-icms-comp.
        WHEN "conta-icms-ft":U THEN ASSIGN pFieldValue = RowObject.conta-icms-ft.
        WHEN "conta-icms-ret":U THEN ASSIGN pFieldValue = RowObject.conta-icms-ret.
        WHEN "conta-icmsremes":U THEN ASSIGN pFieldValue = RowObject.conta-icmsremes.
        WHEN "conta-icmsub-ft":U THEN ASSIGN pFieldValue = RowObject.conta-icmsub-ft.
        WHEN "conta-inss":U THEN ASSIGN pFieldValue = RowObject.conta-inss.
        WHEN "conta-ipi":U THEN ASSIGN pFieldValue = RowObject.conta-ipi.
        WHEN "conta-ipi-fat":U THEN ASSIGN pFieldValue = RowObject.conta-ipi-fat.
        WHEN "conta-ir-ret":U THEN ASSIGN pFieldValue = RowObject.conta-ir-ret.
        WHEN "conta-iss":U THEN ASSIGN pFieldValue = RowObject.conta-iss.
        WHEN "conta-juros-pagos":U THEN ASSIGN pFieldValue = RowObject.conta-juros-pagos.
        WHEN "conta-pis":U THEN ASSIGN pFieldValue = RowObject.conta-pis.
        WHEN "conta-pis-pag":U THEN ASSIGN pFieldValue = RowObject.conta-pis-pag.
        WHEN "conta-pis-rec":U THEN ASSIGN pFieldValue = RowObject.conta-pis-rec.
        WHEN "conta-rec-equaliz":U THEN ASSIGN pFieldValue = RowObject.conta-rec-equaliz.
        WHEN "conta-recven":U THEN ASSIGN pFieldValue = RowObject.conta-recven.
        WHEN "conta-var-monet-cheq-menos":U THEN ASSIGN pFieldValue = RowObject.conta-var-monet-cheq-menos.
        WHEN "conta-var-monet-cheque-mais":U THEN ASSIGN pFieldValue = RowObject.conta-var-monet-cheque-mais.
        WHEN "ct-cheque-dev":U THEN ASSIGN pFieldValue = RowObject.ct-cheque-dev.
        WHEN "ct-cheque-subs":U THEN ASSIGN pFieldValue = RowObject.ct-cheque-subs.
        WHEN "ct-cofins-ft":U THEN ASSIGN pFieldValue = RowObject.ct-cofins-ft.
        WHEN "ct-conta-desp-cart-pagas":U THEN ASSIGN pFieldValue = RowObject.ct-conta-desp-cart-pagas.
        WHEN "ct-credito":U THEN ASSIGN pFieldValue = RowObject.ct-credito.
        WHEN "ct-cusprod":U THEN ASSIGN pFieldValue = RowObject.ct-cusprod.
        WHEN "ct-desconto":U THEN ASSIGN pFieldValue = RowObject.ct-desconto.
        WHEN "ct-desp-cart-receb":U THEN ASSIGN pFieldValue = RowObject.ct-desp-cart-receb.
        WHEN "ct-desp-iof":U THEN ASSIGN pFieldValue = RowObject.ct-desp-iof.
        WHEN "ct-desp-juros":U THEN ASSIGN pFieldValue = RowObject.ct-desp-juros.
        WHEN "ct-desp-juros-avc":U THEN ASSIGN pFieldValue = RowObject.ct-desp-juros-avc.
        WHEN "ct-despesa":U THEN ASSIGN pFieldValue = RowObject.ct-despesa.
        WHEN "ct-devolucao":U THEN ASSIGN pFieldValue = RowObject.ct-devolucao.
        WHEN "ct-equaliz-desp":U THEN ASSIGN pFieldValue = RowObject.ct-equaliz-desp.
        WHEN "ct-equaliz-rec":U THEN ASSIGN pFieldValue = RowObject.ct-equaliz-rec.
        WHEN "ct-ext-icms":U THEN ASSIGN pFieldValue = RowObject.ct-ext-icms.
        WHEN "ct-ext-ipi":U THEN ASSIGN pFieldValue = RowObject.ct-ext-ipi.
        WHEN "ct-fins-pg":U THEN ASSIGN pFieldValue = RowObject.ct-fins-pg.
        WHEN "ct-finsoc":U THEN ASSIGN pFieldValue = RowObject.ct-finsoc.
        WHEN "ct-icm":U THEN ASSIGN pFieldValue = RowObject.ct-icm.
        WHEN "ct-icms-comp":U THEN ASSIGN pFieldValue = RowObject.ct-icms-comp.
        WHEN "ct-icms-dev":U THEN ASSIGN pFieldValue = RowObject.ct-icms-dev.
        WHEN "ct-icms-ft":U THEN ASSIGN pFieldValue = RowObject.ct-icms-ft.
        WHEN "ct-icmsremes":U THEN ASSIGN pFieldValue = RowObject.ct-icmsremes.
        WHEN "ct-icmsub-ft":U THEN ASSIGN pFieldValue = RowObject.ct-icmsub-ft.
        WHEN "ct-ipi":U THEN ASSIGN pFieldValue = RowObject.ct-ipi.
        WHEN "ct-ipi-dev":U THEN ASSIGN pFieldValue = RowObject.ct-ipi-dev.
        WHEN "ct-ipi-ft":U THEN ASSIGN pFieldValue = RowObject.ct-ipi-ft.
        WHEN "ct-ir-ret":U THEN ASSIGN pFieldValue = RowObject.ct-ir-ret.
        WHEN "ct-iss":U THEN ASSIGN pFieldValue = RowObject.ct-iss.
        WHEN "ct-iss-ft":U THEN ASSIGN pFieldValue = RowObject.ct-iss-ft.
        WHEN "ct-pis":U THEN ASSIGN pFieldValue = RowObject.ct-pis.
        WHEN "ct-pis-pg":U THEN ASSIGN pFieldValue = RowObject.ct-pis-pg.
        WHEN "ct-recven":U THEN ASSIGN pFieldValue = RowObject.ct-recven.
        WHEN "ct-var-monet-cheque-mais":U THEN ASSIGN pFieldValue = RowObject.ct-var-monet-cheque-mais.
        WHEN "ct-var-monet-cheque-menos":U THEN ASSIGN pFieldValue = RowObject.ct-var-monet-cheque-menos.
        WHEN "dep-rej-cq":U THEN ASSIGN pFieldValue = RowObject.dep-rej-cq.
        WHEN "deposito-cq":U THEN ASSIGN pFieldValue = RowObject.deposito-cq.
        WHEN "des-local-arq":U THEN ASSIGN pFieldValue = RowObject.des-local-arq.
        WHEN "des-vers-layout":U THEN ASSIGN pFieldValue = RowObject.des-vers-layout.
        WHEN "endereco":U THEN ASSIGN pFieldValue = RowObject.endereco.
        WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
        WHEN "estado":U THEN ASSIGN pFieldValue = RowObject.estado.
        WHEN "grupo-aloca":U THEN ASSIGN pFieldValue = RowObject.grupo-aloca.
        WHEN "ins-estadual":U THEN ASSIGN pFieldValue = RowObject.ins-estadual.
        WHEN "ins-municipal":U THEN ASSIGN pFieldValue = RowObject.ins-municipal.
        WHEN "nome":U THEN ASSIGN pFieldValue = RowObject.nome.
        WHEN "pais":U THEN ASSIGN pFieldValue = RowObject.pais.
        WHEN "permissao":U THEN ASSIGN pFieldValue = RowObject.permissao.
        WHEN "sc-cheque-dev":U THEN ASSIGN pFieldValue = RowObject.sc-cheque-dev.
        WHEN "sc-cheque-subs":U THEN ASSIGN pFieldValue = RowObject.sc-cheque-subs.
        WHEN "sc-cofins-ft":U THEN ASSIGN pFieldValue = RowObject.sc-cofins-ft.
        WHEN "sc-conta-desp-cart-pagas":U THEN ASSIGN pFieldValue = RowObject.sc-conta-desp-cart-pagas.
        WHEN "sc-credito":U THEN ASSIGN pFieldValue = RowObject.sc-credito.
        WHEN "sc-cusprod":U THEN ASSIGN pFieldValue = RowObject.sc-cusprod.
        WHEN "sc-desconto":U THEN ASSIGN pFieldValue = RowObject.sc-desconto.
        WHEN "sc-desp-cart-receb":U THEN ASSIGN pFieldValue = RowObject.sc-desp-cart-receb.
        WHEN "sc-desp-iof":U THEN ASSIGN pFieldValue = RowObject.sc-desp-iof.
        WHEN "sc-desp-juros":U THEN ASSIGN pFieldValue = RowObject.sc-desp-juros.
        WHEN "sc-desp-juros-avc":U THEN ASSIGN pFieldValue = RowObject.sc-desp-juros-avc.
        WHEN "sc-despesa":U THEN ASSIGN pFieldValue = RowObject.sc-despesa.
        WHEN "sc-devolucao":U THEN ASSIGN pFieldValue = RowObject.sc-devolucao.
        WHEN "sc-equaliz-desp":U THEN ASSIGN pFieldValue = RowObject.sc-equaliz-desp.
        WHEN "sc-equaliz-rec":U THEN ASSIGN pFieldValue = RowObject.sc-equaliz-rec.
        WHEN "sc-ext-icms":U THEN ASSIGN pFieldValue = RowObject.sc-ext-icms.
        WHEN "sc-ext-ipi":U THEN ASSIGN pFieldValue = RowObject.sc-ext-ipi.
        WHEN "sc-fins-pg":U THEN ASSIGN pFieldValue = RowObject.sc-fins-pg.
        WHEN "sc-finsoc":U THEN ASSIGN pFieldValue = RowObject.sc-finsoc.
        WHEN "sc-icm":U THEN ASSIGN pFieldValue = RowObject.sc-icm.
        WHEN "sc-icms-comp":U THEN ASSIGN pFieldValue = RowObject.sc-icms-comp.
        WHEN "sc-icms-dev":U THEN ASSIGN pFieldValue = RowObject.sc-icms-dev.
        WHEN "sc-icms-ft":U THEN ASSIGN pFieldValue = RowObject.sc-icms-ft.
        WHEN "sc-icmsremes":U THEN ASSIGN pFieldValue = RowObject.sc-icmsremes.
        WHEN "sc-icmsub-ft":U THEN ASSIGN pFieldValue = RowObject.sc-icmsub-ft.
        WHEN "sc-ipi":U THEN ASSIGN pFieldValue = RowObject.sc-ipi.
        WHEN "sc-ipi-dev":U THEN ASSIGN pFieldValue = RowObject.sc-ipi-dev.
        WHEN "sc-ipi-ft":U THEN ASSIGN pFieldValue = RowObject.sc-ipi-ft.
        WHEN "sc-ir-ret":U THEN ASSIGN pFieldValue = RowObject.sc-ir-ret.
        WHEN "sc-iss":U THEN ASSIGN pFieldValue = RowObject.sc-iss.
        WHEN "sc-iss-ft":U THEN ASSIGN pFieldValue = RowObject.sc-iss-ft.
        WHEN "sc-pis":U THEN ASSIGN pFieldValue = RowObject.sc-pis.
        WHEN "sc-pis-pg":U THEN ASSIGN pFieldValue = RowObject.sc-pis-pg.
        WHEN "sc-recven":U THEN ASSIGN pFieldValue = RowObject.sc-recven.
        WHEN "sc-var-monet-cheque-mais":U THEN ASSIGN pFieldValue = RowObject.sc-var-monet-cheque-mais.
        WHEN "sc-var-monet-cheque-menos":U THEN ASSIGN pFieldValue = RowObject.sc-var-monet-cheque-menos.
        WHEN "serie":U THEN ASSIGN pFieldValue = RowObject.serie.
        WHEN "serie-manual":U THEN ASSIGN pFieldValue = RowObject.serie-manual.
        WHEN "zip-cod":U THEN ASSIGN pFieldValue = RowObject.zip-cod.
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
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "dt-vcto-cofins[1]":U THEN ASSIGN pFieldValue = RowObject.dt-vcto-cofins[1].
        WHEN "dt-vcto-cofins[2]":U THEN ASSIGN pFieldValue = RowObject.dt-vcto-cofins[2].
        WHEN "dt-vcto-cofins[3]":U THEN ASSIGN pFieldValue = RowObject.dt-vcto-cofins[3].
        WHEN "dt-vcto-icms[1]":U THEN ASSIGN pFieldValue = RowObject.dt-vcto-icms[1].
        WHEN "dt-vcto-icms[2]":U THEN ASSIGN pFieldValue = RowObject.dt-vcto-icms[2].
        WHEN "dt-vcto-icms[3]":U THEN ASSIGN pFieldValue = RowObject.dt-vcto-icms[3].
        WHEN "dt-vcto-ipi[1]":U THEN ASSIGN pFieldValue = RowObject.dt-vcto-ipi[1].
        WHEN "dt-vcto-ipi[2]":U THEN ASSIGN pFieldValue = RowObject.dt-vcto-ipi[2].
        WHEN "dt-vcto-ipi[3]":U THEN ASSIGN pFieldValue = RowObject.dt-vcto-ipi[3].
        WHEN "dt-vcto-irrf[1]":U THEN ASSIGN pFieldValue = RowObject.dt-vcto-irrf[1].
        WHEN "dt-vcto-irrf[2]":U THEN ASSIGN pFieldValue = RowObject.dt-vcto-irrf[2].
        WHEN "dt-vcto-irrf[3]":U THEN ASSIGN pFieldValue = RowObject.dt-vcto-irrf[3].
        WHEN "dt-vcto-iss[1]":U THEN ASSIGN pFieldValue = RowObject.dt-vcto-iss[1].
        WHEN "dt-vcto-iss[2]":U THEN ASSIGN pFieldValue = RowObject.dt-vcto-iss[2].
        WHEN "dt-vcto-iss[3]":U THEN ASSIGN pFieldValue = RowObject.dt-vcto-iss[3].
        WHEN "dt-vcto-pis[1]":U THEN ASSIGN pFieldValue = RowObject.dt-vcto-pis[1].
        WHEN "dt-vcto-pis[2]":U THEN ASSIGN pFieldValue = RowObject.dt-vcto-pis[2].
        WHEN "dt-vcto-pis[3]":U THEN ASSIGN pFieldValue = RowObject.dt-vcto-pis[3].
        WHEN "medio-ate":U THEN ASSIGN pFieldValue = RowObject.medio-ate.
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
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "qtd-up-prod[1]":U THEN ASSIGN pFieldValue = RowObject.qtd-up-prod[1].
        WHEN "qtd-up-prod[2]":U THEN ASSIGN pFieldValue = RowObject.qtd-up-prod[2].
        WHEN "qtd-up-prod[3]":U THEN ASSIGN pFieldValue = RowObject.qtd-up-prod[3].
        WHEN "tax-cidade":U THEN ASSIGN pFieldValue = RowObject.tax-cidade.
        WHEN "tax-condado":U THEN ASSIGN pFieldValue = RowObject.tax-condado.
        WHEN "tax-estado":U THEN ASSIGN pFieldValue = RowObject.tax-estado.
        WHEN "val-desp-total[1]":U THEN ASSIGN pFieldValue = RowObject.val-desp-total[1].
        WHEN "val-desp-total[2]":U THEN ASSIGN pFieldValue = RowObject.val-desp-total[2].
        WHEN "val-desp-total[3]":U THEN ASSIGN pFieldValue = RowObject.val-desp-total[3].
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
        WHEN "val-unit-up[1]":U THEN ASSIGN pFieldValue = RowObject.val-unit-up[1].
        WHEN "val-unit-up[2]":U THEN ASSIGN pFieldValue = RowObject.val-unit-up[2].
        WHEN "val-unit-up[3]":U THEN ASSIGN pFieldValue = RowObject.val-unit-up[3].
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
        WHEN "cd-tipo":U THEN ASSIGN pFieldValue = RowObject.cd-tipo.
        WHEN "cep":U THEN ASSIGN pFieldValue = RowObject.cep.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "cod-isencao":U THEN ASSIGN pFieldValue = RowObject.cod-isencao.
        WHEN "cod-sit-aval":U THEN ASSIGN pFieldValue = RowObject.cod-sit-aval.
        WHEN "custo-contab":U THEN ASSIGN pFieldValue = RowObject.custo-contab.
        WHEN "idi-control-emis-nfe":U THEN ASSIGN pFieldValue = RowObject.idi-control-emis-nfe.
        WHEN "idi-tip-emis-nf-eletro":U THEN ASSIGN pFieldValue = RowObject.idi-tip-emis-nf-eletro.
        WHEN "idi-tip-layout":U THEN ASSIGN pFieldValue = RowObject.idi-tip-layout.
        WHEN "idi-tip-transm":U THEN ASSIGN pFieldValue = RowObject.idi-tip-transm.
        WHEN "idi-tributac-cofins":U THEN ASSIGN pFieldValue = RowObject.idi-tributac-cofins.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "integr-ncr-app":U THEN ASSIGN pFieldValue = RowObject.integr-ncr-app.
        WHEN "integr-ncr-crp":U THEN ASSIGN pFieldValue = RowObject.integr-ncr-crp.
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
  Purpose:     Retorna valores dos campos do °ndice codigo
  Parameters:  
               retorna valor do campo cod-estabel
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE estabelec.cod-estabel NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-estabel = RowObject.cod-estabel.

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
        WHEN "cons-ap":U THEN ASSIGN pFieldValue = RowObject.cons-ap.
        WHEN "cons-cent-vend":U THEN ASSIGN pFieldValue = RowObject.cons-cent-vend.
        WHEN "cons-comp-corp":U THEN ASSIGN pFieldValue = RowObject.cons-comp-corp.
        WHEN "cons-cpv":U THEN ASSIGN pFieldValue = RowObject.cons-cpv.
        WHEN "cons-cr":U THEN ASSIGN pFieldValue = RowObject.cons-cr.
        WHEN "cons-ft":U THEN ASSIGN pFieldValue = RowObject.cons-ft.
        WHEN "cons-pd":U THEN ASSIGN pFieldValue = RowObject.cons-pd.
        WHEN "cons-transf-mat":U THEN ASSIGN pFieldValue = RowObject.cons-transf-mat.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "log-emite-danfe":U THEN ASSIGN pFieldValue = RowObject.log-emite-danfe.
        WHEN "log-livre-1":U THEN ASSIGN pFieldValue = RowObject.log-livre-1.
        WHEN "log-livre-2":U THEN ASSIGN pFieldValue = RowObject.log-livre-2.
        WHEN "log-livre-3":U THEN ASSIGN pFieldValue = RowObject.log-livre-3.
        WHEN "log-livre-4":U THEN ASSIGN pFieldValue = RowObject.log-livre-4.
        WHEN "log-livre-5":U THEN ASSIGN pFieldValue = RowObject.log-livre-5.
        WHEN "log-livre-6":U THEN ASSIGN pFieldValue = RowObject.log-livre-6.
        WHEN "usa-mensal":U THEN ASSIGN pFieldValue = RowObject.usa-mensal.
        WHEN "usa-on-line":U THEN ASSIGN pFieldValue = RowObject.usa-on-line.
        WHEN "usa-padrao":U THEN ASSIGN pFieldValue = RowObject.usa-padrao.
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
  Purpose:     Reposiciona registro com base no °ndice codigo
  Parameters:  
               recebe valor do campo cod-estabel
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE estabelec.cod-estabel NO-UNDO.

    FIND FIRST bfestabelec WHERE 
        bfestabelec.cod-estabel = pcod-estabel NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfestabelec THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfestabelec)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDefault DBOProgram 
PROCEDURE openQueryDefault :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
OPEN QUERY {&QueryName} FOR EACH estabelec NO-LOCK INDEXED-REPOSITION.

return 'OK':U.
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
	
	IF pType = "CREATE" OR pType = "UPDATE" THEN DO:
       
         /* Consiste deposito CQ */
        FIND FIRST deposito
             WHERE deposito.cod-depos = rowObject.deposito-cq NO-LOCK NO-ERROR.
        IF  NOT AVAIL deposito THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-table.i mgind deposito 1} /* Busca o label da tabela */
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters=TRIM(RETURN-VALUE)}
        END.
        ELSE DO:
            IF  NOT deposito.ind-dep-cq THEN DO:
			{method/svc/errors/inserr.i &ErrorNumber="1014"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"}
            END.
        END.

        /* Consiste deposito Rej */
        FIND FIRST deposito
            WHERE deposito.cod-depos = rowObject.dep-rej-cq NO-LOCK NO-ERROR.
        IF  NOT AVAIL deposito THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-table.i mgind deposito 1} /* Busca o label da tabela */
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters=TRIM(RETURN-VALUE)}
        END.
        ELSE DO:
            IF  NOT deposito.ind-dep-rej THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber="1015"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"}
            END.
        END.
	end.
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

