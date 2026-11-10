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

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN065
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName contrato-for
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
{inbo/boin065q01.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
def buffer b-contrato-for for contrato-for.
def buffer b-item-contrat for item-contrat.
def buffer b-pedido-compr for pedido-compr.


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
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-comprado":U THEN ASSIGN pFieldValue = RowObject.cod-comprado.
        WHEN "cod-estab-cobr":U THEN ASSIGN pFieldValue = RowObject.cod-estab-cobr.
        WHEN "cod-estab-entr":U THEN ASSIGN pFieldValue = RowObject.cod-estab-entr.
        WHEN "cod-estab-gestor":U THEN ASSIGN pFieldValue = RowObject.cod-estab-gestor.
        WHEN "cod-estab-orig":U THEN ASSIGN pFieldValue = RowObject.cod-estab-orig.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-projeto":U THEN ASSIGN pFieldValue = RowObject.cod-projeto.
        WHEN "conta-contab":U THEN ASSIGN pFieldValue = RowObject.conta-contab.
        WHEN "contato":U THEN ASSIGN pFieldValue = RowObject.contato.
        WHEN "ct-codigo":U THEN ASSIGN pFieldValue = RowObject.ct-codigo.
        WHEN "des-contrat":U THEN ASSIGN pFieldValue = RowObject.des-contrat.
        WHEN "email-alert":U THEN ASSIGN pFieldValue = RowObject.email-alert.
        WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
        WHEN "gestor-tecnico":U THEN ASSIGN pFieldValue = RowObject.gestor-tecnico.
        WHEN "motivo-cancel":U THEN ASSIGN pFieldValue = RowObject.motivo-cancel.
        WHEN "narrat-contrat":U THEN ASSIGN pFieldValue = RowObject.narrat-contrat.
        WHEN "nr-contrato-comp":U THEN ASSIGN pFieldValue = RowObject.nr-contrato-comp.
        WHEN "nr-tab":U THEN ASSIGN pFieldValue = RowObject.nr-tab.
        WHEN "observacao":U THEN ASSIGN pFieldValue = RowObject.observacao.
        WHEN "sc-codigo":U THEN ASSIGN pFieldValue = RowObject.sc-codigo.
        WHEN "versao":U THEN ASSIGN pFieldValue = RowObject.versao.
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
        WHEN "dat-revisao":U THEN ASSIGN pFieldValue = RowObject.dat-revisao.
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "dt-contrato":U THEN ASSIGN pFieldValue = RowObject.dt-contrato.
        WHEN "dt-ini-validade":U THEN ASSIGN pFieldValue = RowObject.dt-ini-validade.
        WHEN "dt-ter-validade":U THEN ASSIGN pFieldValue = RowObject.dt-ter-validade.
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
        WHEN "acum-rec-qtd":U THEN ASSIGN pFieldValue = RowObject.acum-rec-qtd.
        WHEN "acum-rec-val":U THEN ASSIGN pFieldValue = RowObject.acum-rec-val.
        WHEN "acum-val-pago":U THEN ASSIGN pFieldValue = RowObject.acum-val-pago.
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "perc-alert-saldo":U THEN ASSIGN pFieldValue = RowObject.perc-alert-saldo.
        WHEN "qtd-total":U THEN ASSIGN pFieldValue = RowObject.qtd-total.
        WHEN "sal-qtd-liber-med":U THEN ASSIGN pFieldValue = RowObject.sal-qtd-liber-med.
        WHEN "sld-qtd":U THEN ASSIGN pFieldValue = RowObject.sld-qtd.
        WHEN "sld-qtd-liber":U THEN ASSIGN pFieldValue = RowObject.sld-qtd-liber.
        WHEN "sld-qtd-med":U THEN ASSIGN pFieldValue = RowObject.sld-qtd-med.
        WHEN "sld-val":U THEN ASSIGN pFieldValue = RowObject.sld-val.
        WHEN "sld-val-liber":U THEN ASSIGN pFieldValue = RowObject.sld-val-liber.
        WHEN "sld-val-liber-med":U THEN ASSIGN pFieldValue = RowObject.sld-val-liber-med.
        WHEN "sld-val-med":U THEN ASSIGN pFieldValue = RowObject.sld-val-med.
        WHEN "sld-val-receb":U THEN ASSIGN pFieldValue = RowObject.sld-val-receb.
        WHEN "val-fatur-minimo":U THEN ASSIGN pFieldValue = RowObject.val-fatur-minimo.
        WHEN "val-total":U THEN ASSIGN pFieldValue = RowObject.val-total.
        WHEN "variacao-preco":U THEN ASSIGN pFieldValue = RowObject.variacao-preco.
        WHEN "variacao-qtd":U THEN ASSIGN pFieldValue = RowObject.variacao-qtd.
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
        WHEN "cod-cond-fatur":U THEN ASSIGN pFieldValue = RowObject.cod-cond-fatur.
        WHEN "cod-cond-pag":U THEN ASSIGN pFieldValue = RowObject.cod-cond-pag.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "cod-mensagem":U THEN ASSIGN pFieldValue = RowObject.cod-mensagem.
        WHEN "cod-tipo-contrat":U THEN ASSIGN pFieldValue = RowObject.cod-tipo-contrat.
        WHEN "cod-transp":U THEN ASSIGN pFieldValue = RowObject.cod-transp.
        WHEN "frete":U THEN ASSIGN pFieldValue = RowObject.frete.
        WHEN "ind-control-rec":U THEN ASSIGN pFieldValue = RowObject.ind-control-rec.
        WHEN "ind-preco":U THEN ASSIGN pFieldValue = RowObject.ind-preco.
        WHEN "ind-sit-contrat":U THEN ASSIGN pFieldValue = RowObject.ind-sit-contrat.
        WHEN "ind-via-envio":U THEN ASSIGN pFieldValue = RowObject.ind-via-envio.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "mo-codigo":U THEN ASSIGN pFieldValue = RowObject.mo-codigo.
        WHEN "moeda":U THEN ASSIGN pFieldValue = RowObject.moeda.
        WHEN "natureza":U THEN ASSIGN pFieldValue = RowObject.natureza.
        WHEN "nr-contrato":U THEN ASSIGN pFieldValue = RowObject.nr-contrato.
        WHEN "nro-proc-saida":U THEN ASSIGN pFieldValue = RowObject.nro-proc-saida.
        WHEN "num-ord-inv":U THEN ASSIGN pFieldValue = RowObject.num-ord-inv.
        WHEN "num-ord-invest":U THEN ASSIGN pFieldValue = RowObject.num-ord-invest.
        WHEN "tp-fornecim":U THEN ASSIGN pFieldValue = RowObject.tp-fornecim.
        WHEN "tp-freq":U THEN ASSIGN pFieldValue = RowObject.tp-freq.
        WHEN "via-transp":U THEN ASSIGN pFieldValue = RowObject.via-transp.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram  
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice contrato
  Parameters:  
               retorna valor do campo nr-contrato
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnr-contrato LIKE contrato-for.nr-contrato NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnr-contrato = RowObject.nr-contrato.

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
        WHEN "gera-edi":U THEN ASSIGN pFieldValue = RowObject.gera-edi.
        WHEN "impr-contrat":U THEN ASSIGN pFieldValue = RowObject.impr-contrat.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "log-libera":U THEN ASSIGN pFieldValue = RowObject.log-libera.
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
  Purpose:     Reposiciona registro com base no °ndice contrato
  Parameters:  
               recebe valor do campo nr-contrato
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-contrato LIKE contrato-for.nr-contrato NO-UNDO.

    FIND FIRST bfcontrato-for WHERE 
        bfcontrato-for.nr-contrato = pnr-contrato NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfcontrato-for THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfcontrato-for)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType  AS CHARACTER  NO-UNDO.
    
    DEFINE VARIABLE c-lbl-liter   AS CHARACTER  NO-UNDO.
        
    FIND FIRST rowObject NO-LOCK NO-ERROR.
     
    IF pType = 'update' THEN DO:
    
        /* Validaá∆o: N£mero Contrato */
        if rowObject.nr-contrato = ? then do:
            {utp/ut-liter.i "Numero_Contrato" *}
            ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="265"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="c-lbl-liter"}
            return "NOK".
        end.

        RUN piValidateContrato IN THIS-PROCEDURE. 
        
    END. 
    
    IF pType = 'create' THEN DO:

        RUN piValidateContrato IN THIS-PROCEDURE. 

        /* Validaá∆o: Fornecedor (cod-emitente) */
        if rowObject.cod-emitente = ? then do:
            {utp/ut-liter.i "Fornecedor" *}
            ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="265"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="c-lbl-liter"}
            return "NOK".
        end.
        
        IF NOT CAN-FIND(FIRST emitente WHERE emitente.cod-emitente = rowObject.cod-emitente) THEN DO:
            {utp/ut-liter.i "Fornecedor" *}
            ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="47"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="c-lbl-liter"}
            return "NOK".
            
        END.
        
        /* Validaá∆o: Estabelecimento */
        IF  rowObject.cod-estabel = ? THEN DO:
            {utp/ut-liter.i "Estabelecimento" *}
            ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="265"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="c-lbl-liter"}
            return "NOK".
        END.
        
        /* Validaá∆o: Estabelecimento */
        IF  rowObject.cod-estabel <> ""
        AND NOT CAN-FIND(FIRST estabelec WHERE estabelec.cod-estabel = rowObject.cod-estabel) THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="13"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="rowObject.cod-estabel"}
            return "NOK".
        END.
     
        /* Validaá∆o: Estabelecimento Cobranáa */
        if rowObject.cod-estab-cobr = ? then do:
            {utp/ut-liter.i "Estabelecimento_Cobranáa" *}
            ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="265"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="c-lbl-liter"}
            return "NOK".
        end.
        
        IF  rowObject.cod-estab-cobr <> ""
        AND NOT CAN-FIND(FIRST estabelec WHERE estabelec.cod-estabel = rowObject.cod-estab-cobr) THEN DO:
            {utp/ut-liter.i "Estabelecimento_Cobranáa" *}
            ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="13"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="c-lbl-liter"}
            return "NOK".
        END.
     
        /* Validaá∆o: Estabelecimento Origem */
        if rowObject.cod-estab-orig = ? then do:
            {utp/ut-liter.i "Estab_Origem" *}
            ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="265"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="c-lbl-liter"}
            return "NOK".
        end.
        
        IF  rowObject.cod-estab-orig <> ""
        AND NOT CAN-FIND(FIRST estabelec WHERE estabelec.cod-estabel = rowObject.cod-estab-orig) THEN DO:
            {utp/ut-liter.i "Estabelecimento_Origem" *}
            ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="13"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="c-lbl-liter"}
            return "NOK".
        END.
        
        /* Validaá∆o: Tipo Contrato */
        if rowObject.cod-tipo-contrat = ? then do:
            {utp/ut-liter.i "Tipo_Contrato" *}
            ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="265"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="c-lbl-liter"}
            return "NOK".
        end.
        
        find first tipo-contrat where tipo-contrat.cod-tipo-contr = rowObject.cod-tipo-contrat
                                no-lock no-error.
        if not avail tipo-contrat then do:            
            run utp/ut-msgs.p (input "show":U, 
                               input 8293, 
                               input "").
            return "NOK".
        end.
                
        /* Validaá∆o: Data Revis∆o */
        if rowObject.dat-revisao = ? then do:
            {utp/ut-liter.i "Data_Revisao" *}
            ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="265"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="c-lbl-liter"}
            return "NOK".
        end.
 
        /* Validaá∆o: Data Contrato */
        if rowObject.dt-contrato = ? then do:        
            {utp/ut-liter.i "Data_Contrato" *}
            ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="265"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="c-lbl-liter"}
            return "NOK".
        end.
        
        /* Validaá∆o: Data TÇrmino Validade */
        if rowObject.dt-ter-validade = ? then do:        
            {utp/ut-liter.i "Data_Fim_Validade" *}
            ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="265"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="c-lbl-liter"}
            return "NOK".
        end.

        /* Validaá∆o: Data In°cio Validade */
        if rowObject.dt-ini-validade = ? then do:
            {utp/ut-liter.i "Data_Ini_Validade" *}
            ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="265"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="c-lbl-liter"}
            return "NOK".
        end.
        
        /* Validaá∆o: Frete */
        if rowObject.frete = ? then do:
            {utp/ut-liter.i "Frete" *}
            ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="265"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="c-lbl-liter"}
            return "NOK".
        end.
        
        /* Validaá∆o: C¢digo Moeda */
        if rowObject.mo-codigo = ? then do:
            {utp/ut-liter.i "Moeda" *}
            ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="265"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="c-lbl-liter"}
            return "NOK".
        end.
     
        
            
        /* Validaá∆o: Transportador */
        if rowObject.cod-transp = ? then do:
            {utp/ut-liter.i "Transportador" *}
            ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="265"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="c-lbl-liter"}
            return "NOK".
        end.
     
        /* Validaá∆o: Gestor TÇcnico */
        if rowObject.gestor-tecnico = ? then do:
            {utp/ut-liter.i "Gestor_Tecnico" *}
            ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="265"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="c-lbl-liter"}
            return "NOK".
        end.
     
        /* Validaá∆o: Imprime Contrato */
        if rowObject.impr-contrat = ? then do:
            {utp/ut-liter.i "Imprime_Contrato" *}
            ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="265"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="c-lbl-liter"}
            return "NOK".
        end.
     
        /* Validaá∆o: Log Libera */
        if rowObject.log-libera = ? then do:
            {utp/ut-liter.i "Libera_Contrato" *}
            ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="265"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="c-lbl-liter"}
            return "NOK".
        end.
        
        /* Validaá∆o: Moeda */
        if rowObject.moeda = ? then do:
            {utp/ut-liter.i "Moeda" *}
            ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="265"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="c-lbl-liter"}
            return "NOK".
        end.
                  
     
        /* Validaá∆o: Natureza */
        if rowObject.natureza = ? then do:
            {utp/ut-liter.i "Natureza" *}
            ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="265"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="c-lbl-liter"}
            return "NOK".
        end.            
        
        /* Validaá∆o: Saldo Valor Recebido */
        if rowObject.sld-val-receb = ? then do:
            {utp/ut-liter.i "Saldo_Valor_Receb" *}
            ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="265"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="c-lbl-liter"}
            return "NOK".
        end.        
    END.
    
    
    /* Verifica ocorrància de erros */
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE piValidateContrato:
    /* Implementaá∆o da validaá∆o do contrato */

    DEFINE VARIABLE l-erro        AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE cItemContrat  AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cNumContrat   AS CHARACTER  NO-UNDO.

    /* Valida se existe outro contrato ativo com o mesmo per°odo de validade para o mesmo fornecedor */
    FOR EACH item-contrat
        WHERE item-contrat.nr-contrat        = rowObject.nr-contrato AND
              item-contrat.ind-tipo-control <> 1 AND
              item-contrat.ind-sit-item     <> 3 AND
              item-contrat.ind-sit-item     <> 4 NO-LOCK:
        FIND item WHERE item.it-codigo       = item-contrat.it-codigo NO-LOCK NO-ERROR.

        IF item-contrat.it-codigo = "" OR
           (AVAIL item AND
            item.tipo-contr = 4 AND
            NOT CAN-FIND (FIRST item-fornec WHERE item-fornec.it-codigo = item-contrat.it-codigo
                          AND item-fornec.cod-emitente = rowObject.cod-emitente
                          AND item-fornec.ativo)) THEN NEXT.

        FOR EACH b-item-contrat
            WHERE b-item-contrat.it-codigo        =  item-contrat.it-codigo AND
                  b-item-contrat.nr-contrat       <> item-contrat.nr-contrat AND
                  b-item-contrat.ind-tipo-control <> 1 AND
                  b-item-contrat.ind-sit-item     <> 3 AND
                  b-item-contrat.ind-sit-item     <> 4 NO-LOCK:

            FIND b-contrato-for WHERE
                b-contrato-for.nr-contrato      = b-item-contrat.nr-contrat AND
                b-contrato-for.cod-emitente     = rowObject.cod-emitente AND
                b-contrato-for.dt-ini-validade  <= rowObject.dt-ter-validade AND
                b-contrato-for.dt-ter-validade  >= rowObject.dt-ini-validade AND
                b-contrato-for.log-libera       = YES
                NO-LOCK NO-ERROR.

            IF AVAIL b-contrato-for THEN DO:
                ASSIGN l-erro = NO.
                FOR EACH b-pedido-compr FIELD (nr-contrato end-entrega)
                    WHERE b-pedido-compr.nr-contrato = rowObject.nr-contrato NO-LOCK:
                    IF CAN-FIND (FIRST pedido-compr WHERE pedido-compr.end-entrega = b-pedido-compr.end-entrega
                                   AND pedido-compr.nr-contrato = b-contrato-for.nr-contrato) THEN DO:
                        ASSIGN l-erro = YES.
                        LEAVE.
                    END.
                END.
                IF l-erro THEN DO:
                    ASSIGN cItemContrat = item-contrat.it-codigo.
                    ASSIGN cNumContrat  = STRING(b-contrato-for.nr-contrato).
                    {method/svc/errors/inserr.i &ErrorNumber="19478"
                                                &ErrorType="EMS"
                                                &ErrorParameters="cItemContrat + '~~~~' + cNumContrat"}
                    RETURN "NOK".
                END.
            END.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
