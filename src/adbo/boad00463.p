&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
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
{include/i-prgvrs.i BOAD00463 2.00.00.024 } /*** "010024" 13/11/2023 11:45:41 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boad00463 MUT}
&ENDIF


/*:T--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName BOAD00463
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName docum-est-esoc
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
{adbo/boad00463.i RowObject}
{adbo/boad00465.i tt-item-doc-est-esoc}
{rep/re1001u.i} /*tt-titulo*/
{adbo/boad00463.i RowObject-aux}

{adbo/boad00537.i tt-process-estab}

/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName}   FOR {&TableName}.
DEFINE BUFFER b-docum-est-esoc for docum-est-esoc.

DEFINE TEMP-TABLE tt-docum-est-esoc-aux NO-UNDO LIKE docum-est-esoc
    FIELD r-Rowid AS ROWID.

DEFINE TEMP-TABLE tt-docum-est-esoc-aux-isenta NO-UNDO LIKE tt-docum-est-esoc-aux.

DEFINE VARIABLE c-emitente        LIKE docum-est.cod-emitente               NO-UNDO.
DEFINE VARIABLE c-serie           LIKE docum-est.serie-docto                NO-UNDO.
DEFINE VARIABLE c-docto           LIKE docum-est.nro-docto                  NO-UNDO.
DEFINE VARIABLE c-nat-operacao    LIKE docum-est.nat-operacao               NO-UNDO.

DEFINE VARIABLE c-cod-estab-tit   LIKE docum-est-esoc.cod-estabel           NO-UNDO.
DEFINE VARIABLE c-cod-espec-tit   LIKE docum-est-esoc.cod-espec-docto       NO-UNDO.
DEFINE VARIABLE c-serie-tit       LIKE docum-est-esoc.serie-docto           NO-UNDO.
DEFINE VARIABLE c-cod-emit-tit    LIKE docum-est-esoc.cod-emitente          NO-UNDO.
DEFINE VARIABLE c-cod-titulo      LIKE docum-est-esoc.cod-tit-ap            NO-UNDO.
DEFINE VARIABLE c-cod-parc-tit    LIKE docum-est-esoc.cod-parcela           NO-UNDO.
DEFINE VARIABLE i-ep-codigo       like empresa.ep-codigo                    NO-UNDO.
DEFINE VARIABLE r-DocumEst        AS ROWID                                  NO-UNDO.
DEFINE VARIABLE de-vl-total-inss  LIKE docum-est-esoc.vl-bruto              NO-UNDO.

DEFINE VARIABLE c-cod-estab-rom   LIKE docum-est-esoc.cod-estabel           NO-UNDO.
DEFINE VARIABLE i-num-romaneio    LIKE docum-est-esoc.num-romaneio          NO-UNDO.
DEFINE VARIABLE i-num-seq         LIKE docum-est-esoc.num-seq               NO-UNDO.
DEFINE VARIABLE c-tipo-produtor   AS CHARACTER  FORMAT "x(9)"               NO-UNDO.
DEFINE VARIABLE c-cod-suspensao   LIKE proces-esocial-suspen.cod-seq-suspen NO-UNDO.

DEFINE VARIABLE h-dbo-imposto     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-reg-imposto     AS HANDLE NO-UNDO.
DEFINE VARIABLE hCampoDBO         AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boad00566       AS HANDLE NO-UNDO.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaDocumEstEsoc DBOProgram 
PROCEDURE atualizaDocumEstEsoc :
/*:T------------------------------------------------------------------------------
  Purpose:     Carrega as demais informações da docum-est-esoc
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pRowid AS ROWID NO-UNDO.

DEFINE VARIABLE c-ind-tip-impto AS CHARACTER FORMAT "X(35)":U  NO-UNDO.

DEFINE VARIABLE de-tot-bruto  AS DECIMAL NO-UNDO.

DEFINE VARIABLE de-tot-inss   AS DECIMAL NO-UNDO.
DEFINE VARIABLE de-tot-senar  AS DECIMAL NO-UNDO.
DEFINE VARIABLE de-tot-gilrat AS DECIMAL NO-UNDO.

DEFINE VARIABLE de-tot-inss-n-ret   AS DECIMAL NO-UNDO.
DEFINE VARIABLE de-tot-senar-n-ret  AS DECIMAL NO-UNDO.
DEFINE VARIABLE de-tot-gilrat-n-ret AS DECIMAL NO-UNDO.

DEFINE VARIABLE c-pais   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-estado AS CHARACTER   NO-UNDO.

DEFINE VARIABLE h-boad00537  AS HANDLE              NO-UNDO.
DEFINE VARIABLE i-num-seq-proces LIKE process-estab.num-seq NO-UNDO.

IF NOT VALID-HANDLE(h-boad00566) THEN
   RUN adbo/boad00566.p PERSISTENT SET h-boad00566 NO-ERROR.
     
IF  NOT VALID-HANDLE(h-dbo-imposto) THEN
    RUN prgint/utb/utb944wb.py PERSISTENT SET h-dbo-imposto NO-ERROR.

IF  NOT VALID-HANDLE(h-boad00537) THEN
    RUN adbo/boad00537.p PERSISTENT SET h-boad00537 NO-ERROR.

    EMPTY TEMP-TABLE tt-docum-est-esoc-aux        NO-ERROR.
    EMPTY TEMP-TABLE tt-docum-est-esoc-aux-isenta NO-ERROR.

    FOR FIRST docum-est NO-LOCK
        WHERE ROWID(docum-est) = pRowid:

        CREATE tt-docum-est-esoc-aux.
        ASSIGN tt-docum-est-esoc-aux.serie-docto  = docum-est.serie-docto 
               tt-docum-est-esoc-aux.cod-emitente = docum-est.cod-emitente
               tt-docum-est-esoc-aux.nro-docto    = docum-est.nro-docto   
               tt-docum-est-esoc-aux.nat-operacao = docum-est.nat-operacao
               tt-docum-est-esoc-aux.cod-estabel  = docum-est.cod-estabel
               tt-docum-est-esoc-aux.dt-trans     = docum-est.dt-emiss
               tt-docum-est-esoc-aux.vl-bruto     = 0
               tt-docum-est-esoc-aux.cod-layout   = "1250".
        
        ASSIGN OVERLAY(tt-docum-est-esoc-aux.cod-livre-1,1,1)  = "1"  /* TAG tpInscAdq - Tipo de inscrição do adquirente */
               OVERLAY(tt-docum-est-esoc-aux.cod-livre-1,21,1) = "1". /* TAG procEmi   - Processo de emissão do evento: 1- Aplicativo do empregador; 2 - Aplicativo governamental.*/
        
        FOR FIRST emitente NO-LOCK
             WHERE emitente.cod-emitente = docum-est.cod-emitente:

            IF emitente.natureza = 1 THEN DO: /* Pessoa Fisica */
               ASSIGN tt-docum-est-esoc-aux.tp-insc-cno   = 2 /* CPF */
                      tt-docum-est-esoc-aux.nr-insc-cno   = emitente.cgc
                      tt-docum-est-esoc-aux.tp-aquis      = INT(SUBSTRING(emitente.char-1,139,1)) /*indAquis*/
                      tt-docum-est-esoc-aux.tp-incidencia = 2.
            END.
            ELSE IF emitente.natureza = 2 /* Pessoa Juridica */
                 AND SUBSTRING(emitente.char-1,148,13) <> "":U   /* CPF */
                 THEN DO:
                 ASSIGN tt-docum-est-esoc-aux.tp-insc-cno   = 2 /* CPF */
                        tt-docum-est-esoc-aux.nr-insc-cno   = SUBSTRING(emitente.char-1,148,13)
                        tt-docum-est-esoc-aux.tp-aquis      = INT(SUBSTRING(emitente.char-1,139,1)) /*indAquis*/
                        tt-docum-est-esoc-aux.tp-incidencia = 2.
            END.
            ELSE DO:
                ASSIGN tt-docum-est-esoc-aux.tp-insc-cno   = 1 /* CNPJ */
                       tt-docum-est-esoc-aux.nr-insc-cno   = emitente.cgc
                       tt-docum-est-esoc-aux.tp-aquis      = INT(SUBSTRING(emitente.char-1,139,1)) /*indAquis*/
                       tt-docum-est-esoc-aux.tp-incidencia = 1.
            END.
            
            /*Carregar o campo que será utilizado na tag indOpcCP*/
            IF substr(emitente.char-1,140,1) = "1" THEN DO:
                ASSIGN tt-docum-est-esoc-aux.num-livre-1 = 1.
            END.
            ELSE DO:
                ASSIGN tt-docum-est-esoc-aux.num-livre-1 = 2.
            END.
        END.
        
        FOR FIRST estabelec NO-LOCK
             WHERE estabelec.cod-estabel = docum-est.cod-estabel:
            ASSIGN OVERLAY(tt-docum-est-esoc-aux.cod-livre-1,2,19) = estabelec.cgc
                           tt-docum-est-esoc-aux.ep-codigo         = estabelec.ep-codigo.        
        END.
    
        FOR EACH item-doc-est NO-LOCK
            OF docum-est:

            blItem:
            FOR FIRST natur-oper NO-LOCK
                WHERE natur-oper.nat-operacao = item-doc-est.nat-of:

                IF SUBSTRING(natur-oper.char-1,176,1) = "0"                        /* não é aquis rural OU */
                   OR SUBSTRING(item-doc-est.char-2,941,3) <> "" THEN NEXT blItem. /* é serviço */
                   
                IF  SUBSTRING(natur-oper.char-1,177,1) = "1" THEN DO: /*aquisicao isenta*/
                
                    FIND FIRST tt-docum-est-esoc-aux-isenta NO-ERROR.
                            
                    IF NOT AVAIL tt-docum-est-esoc-aux-isenta THEN DO:
                        CREATE tt-docum-est-esoc-aux-isenta.
                        BUFFER-COPY tt-docum-est-esoc-aux TO tt-docum-est-esoc-aux-isenta.
                        ASSIGN tt-docum-est-esoc-aux-isenta.tp-aquis = tt-docum-est-esoc-aux-isenta.tp-aquis + 3
                               tt-docum-est-esoc-aux-isenta.vl-bruto = 0.
                    END.

                    ASSIGN tt-docum-est-esoc-aux-isenta.vl-bruto = tt-docum-est-esoc-aux-isenta.vl-bruto + (item-doc-est.preco-total[1] +
                                                                                                            item-doc-est.despesas[1]    -
                                                                                                            item-doc-est.desconto[1])
                           tt-docum-est-esoc-aux-isenta.vl-contrib-prev   = 0  /* INSS   */
                           tt-docum-est-esoc-aux-isenta.vl-contrib-senar  = 0  /* SENAR  */
                           tt-docum-est-esoc-aux-isenta.vl-contrib-financ = 0  /* GILRAT */
                           tt-docum-est-esoc-aux-isenta.nat-operacao      = item-doc-est.nat-of
                           de-tot-bruto                                   = de-tot-bruto + (item-doc-est.preco-total[1] + item-doc-est.despesas[1] - item-doc-est.desconto[1]). /*14728 - Alterado para calcular corretamente os impostos das duplicatas*/

                END.
                ELSE DO: /*aquisicao tributada*/
                    ASSIGN tt-docum-est-esoc-aux.vl-bruto = tt-docum-est-esoc-aux.vl-bruto + (item-doc-est.preco-total[1] +
                                                                                              item-doc-est.despesas[1]    -
                                                                                              item-doc-est.desconto[1])
                           tt-docum-est-esoc-aux.nat-operacao = item-doc-est.nat-of
                           de-tot-bruto                       = de-tot-bruto + (item-doc-est.preco-total[1] + item-doc-est.despesas[1] - item-doc-est.desconto[1]). /*14728 - Alterado para calcular corretamente os impostos das duplicatas*/
                END.
            END.
                                         
        END.        
    
        FOR EACH dupli-imp 
           WHERE dupli-imp.serie-docto  = tt-docum-est-esoc-aux.serie-docto 
             AND dupli-imp.nro-docto    = tt-docum-est-esoc-aux.nro-docto 
             AND dupli-imp.cod-emitente = tt-docum-est-esoc-aux.cod-emitente
             AND dupli-imp.nat-operacao = docum-est.nat-operacao NO-LOCK:
        
            ASSIGN c-ind-tip-impto = dupli-imp.ind-tipo-imposto.

            IF c-ind-tip-impto = "" AND VALID-HANDLE(h-dbo-imposto) THEN DO:
                ASSIGN c-pais = "BRA"
                       c-estado = "".
        
                /*--- monta a query  ---*/
                RUN setQueryWhere IN h-dbo-imposto  (    "imposto.cod_pais         = '":U + STRING(c-pais)          + "'":U +
                                                    " AND imposto.cod_unid_federac = '":U + STRING(c-estado)        + "'":U +
                                                    " AND imposto.cod_imposto      = '":U + STRING(dupli-imp.int-1) + "'":U).
        
                /*--- abre a query dinamica e posiciona no primeiro registro ---*/
                RUN openQueryDynamic IN h-dbo-imposto.
        
                /*RUN pi_reposition_record IN h-dbo-imposto (INPUT v_rec_imposto).*/
                RUN getFirst IN h-dbo-imposto.
        
                /*--- busca handle do registro para ler os dados da tabela impostos (ems5) ---*/
                RUN getRecordInHandle IN h-dbo-imposto(OUTPUT h-reg-imposto).
        
                /* busca o tipo de imposto para eSocial */
                ASSIGN hCampoDBO       = h-reg-imposto:BUFFER-FIELD("ind_tip_impto":U)
                       c-ind-tip-impto = hCampoDBO:BUFFER-VALUE NO-ERROR.
            END. /*IF c-ind-tip-impto = "" AND VALID-HANDLE(h-dbo-imposto)*/
        
        
            /* INSS */
            IF c-ind-tip-impto = "Inst Nacional Seguro Social (INSS)" THEN DO:  /* INSS */

                de-tot-inss = de-tot-inss + dupli-imp.vl-imposto.

                /* calcula redução conforme cadastro de processo judicial */
                {adbo/boad00463.i1 de-tot-inss-n-ret}
                /**********************************************************/
            
            END.
            
            /* SENAR*/
            IF c-ind-tip-impto = "SENAR" THEN DO:
            
                de-tot-senar = de-tot-senar + dupli-imp.vl-imposto.
                        
                /* calcula redução conforme cadastro de processo judicial */
                {adbo/boad00463.i1 de-tot-senar-n-ret}
                /**********************************************************/
        
            END.
            
            /* GILRAT */
            IF c-ind-tip-impto = "GILRAT" THEN  DO:               

                de-tot-gilrat = de-tot-gilrat + dupli-imp.vl-imposto.
            
                /* calcula redução conforme cadastro de processo judicial */
                {adbo/boad00463.i1 de-tot-gilrat-n-ret}
                /**********************************************************/
            
            END.
        END. /* for each dupli-imp */  

        FOR FIRST tt-docum-est-esoc-aux:
            ASSIGN tt-docum-est-esoc-aux.vl-contrib-prev   = de-tot-inss  
                   tt-docum-est-esoc-aux.vl-contrib-senar  = de-tot-senar 
                   tt-docum-est-esoc-aux.vl-contrib-financ = de-tot-gilrat
                   tt-docum-est-esoc-aux.vl-servicos-15    = de-tot-inss-n-ret
                   tt-docum-est-esoc-aux.vl-servicos-20    = de-tot-senar-n-ret
                   tt-docum-est-esoc-aux.vl-servicos-25    = de-tot-gilrat-n-ret.
            IF tt-docum-est-esoc-aux.vl-bruto = 0 THEN DELETE tt-docum-est-esoc-aux.
            ELSE DO:
                /*Rateio SENAR*/
                tt-docum-est-esoc-aux.vl-contrib-senar  = de-tot-senar / de-tot-bruto * tt-docum-est-esoc-aux.vl-bruto.
                RUN emptyRowObject.
                RUN setRecord (INPUT TABLE tt-docum-est-esoc-aux).
                IF RETURN-VALUE = "OK":U THEN RUN createRecord.
            END.
        END.

        FOR FIRST tt-docum-est-esoc-aux-isenta:
            IF tt-docum-est-esoc-aux-isenta.vl-bruto = 0 THEN DELETE tt-docum-est-esoc-aux-isenta.
            ELSE DO:
                /*Rateio SENAR*/
                tt-docum-est-esoc-aux-isenta.vl-contrib-senar  = de-tot-senar / de-tot-bruto * tt-docum-est-esoc-aux-isenta.vl-bruto.
                RUN emptyRowObject.
                RUN setRecord (INPUT TABLE tt-docum-est-esoc-aux-isenta).
                IF RETURN-VALUE = "OK":U THEN RUN createRecord.
            END.
        END.
        

    END. /*FOR FIRST docum-est*/

IF VALID-HANDLE(h-dbo-imposto) THEN DO:
   DELETE PROCEDURE h-dbo-imposto.
   ASSIGN h-dbo-imposto = ?.
END.

IF VALID-HANDLE(h-boad00537) THEN DO:
   DELETE PROCEDURE h-boad00537.
   ASSIGN h-boad00537 = ?.
END.
IF VALID-HANDLE(h-boad00566) THEN DO:
   DELETE PROCEDURE h-boad00566.
   ASSIGN h-boad00566 = ?.
END.


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

   def var i-seq like docum-est-esoc.nro-docto-esoc no-undo.
   
   blk-1:
   repeat: 
       assign i-seq = next-value(seq-e-social, movadm).
       if  not can-find(b-docum-est-esoc
                  where b-docum-est-esoc.nro-docto-esoc = i-seq) then
           leave blk-1.
   end.
   
   assign RowObject.nro-docto-esoc = i-seq.
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteEsoc DBOProgram 
PROCEDURE deleteEsoc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pRowid AS ROWID NO-UNDO.

    FIND FIRST docum-est-esoc WHERE ROWID(docum-est-esoc) = pRowid EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL docum-est-esoc THEN DO:

        FOR EACH item-doc-est-esoc EXCLUSIVE-LOCK
           WHERE item-doc-est-esoc.nro-docto-esoc = docum-est-esoc.nro-docto-esoc:

            DELETE item-doc-est-esoc.
    
        END.
    
        DELETE docum-est-esoc.
    
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteEsocFinanceiro DBOProgram 
PROCEDURE deleteEsocFinanceiro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pNroDoctoEsoc AS DECIMAL NO-UNDO.

    FIND FIRST docum-est-esoc WHERE docum-est-esoc.nro-docto-esoc = pNroDoctoEsoc EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL docum-est-esoc THEN DO:
        
        IF docum-est-esoc.tp-origem = 2 THEN DO:
           FOR EACH item-doc-est-esoc EXCLUSIVE-LOCK
              WHERE item-doc-est-esoc.nro-docto-esoc = docum-est-esoc.nro-docto-esoc:

              DELETE item-doc-est-esoc.
           END.

           DELETE docum-est-esoc.
        END.
        ELSE                   
           ASSIGN docum-est-esoc.cod-espec-docto = ""                  
                  docum-est-esoc.cod-tit-ap      = ""
                  docum-est-esoc.cod-parcela     = "".       
    END.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteEsocRecebimento DBOProgram 
PROCEDURE deleteEsocRecebimento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pRowid AS ROWID NO-UNDO.

    FIND FIRST docum-est-esoc WHERE ROWID(docum-est-esoc) = pRowid EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL docum-est-esoc THEN DO:      
          
        CASE docum-est-esoc.tp-origem:
            WHEN 1 THEN DO:
                FOR EACH item-doc-est-esoc EXCLUSIVE-LOCK
                   WHERE item-doc-est-esoc.nro-docto-esoc = docum-est-esoc.nro-docto-esoc:

                   DELETE item-doc-est-esoc.
                END.

                DELETE docum-est-esoc.
            END.
            WHEN 3 THEN 
                ASSIGN docum-est-esoc.nro-docto = "".
            OTHERWISE 
                ASSIGN docum-est-esoc.serie-docto  = ""
                       docum-est-esoc.nro-docto    = "".
        END CASE.   
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-espec-docto":U THEN ASSIGN pFieldValue = RowObject.cod-espec-docto.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-layout":U THEN ASSIGN pFieldValue = RowObject.cod-layout.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-parcela":U THEN ASSIGN pFieldValue = RowObject.cod-parcela.
        WHEN "cod-tit-ap":U THEN ASSIGN pFieldValue = RowObject.cod-tit-ap.
        WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
        WHEN "id-arquivo":U THEN ASSIGN pFieldValue = RowObject.id-arquivo.
        WHEN "nat-operacao":U THEN ASSIGN pFieldValue = RowObject.nat-operacao.
        WHEN "nr-insc-cno":U THEN ASSIGN pFieldValue = RowObject.nr-insc-cno.
        WHEN "nr-proc-jud":U THEN ASSIGN pFieldValue = RowObject.nr-proc-jud.
        WHEN "cod-seq-suspen":U THEN ASSIGN pFieldValue = RowObject.cod-seq-suspen.
        WHEN "nro-docto":U THEN ASSIGN pFieldValue = RowObject.nro-docto.
        WHEN "serie-docto":U THEN ASSIGN pFieldValue = RowObject.serie-docto.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dat-livre-1":U THEN ASSIGN pFieldValue = RowObject.dat-livre-1.
        WHEN "dat-livre-2":U THEN ASSIGN pFieldValue = RowObject.dat-livre-2.
        WHEN "dt-repasse":U THEN ASSIGN pFieldValue = RowObject.dt-repasse.
        WHEN "dt-trans":U THEN ASSIGN pFieldValue = RowObject.dt-trans.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "nr-cno":U THEN ASSIGN pFieldValue = RowObject.nr-cno.
        /*WHEN "nro-docto-esoc":U THEN ASSIGN pFieldValue = RowObject.nro-docto-esoc.*/ /*NÆo descomentar devido ao erro de sequence, caso necess rio utilizar o getKey */
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
        WHEN "vl-adicional":U THEN ASSIGN pFieldValue = RowObject.vl-adicional.
        WHEN "vl-apurad":U THEN ASSIGN pFieldValue = RowObject.vl-apurad.
        WHEN "vl-base-calc":U THEN ASSIGN pFieldValue = RowObject.vl-base-calc.
        WHEN "vl-base-coop":U THEN ASSIGN pFieldValue = RowObject.vl-base-coop.
        WHEN "vl-base-coop-15":U THEN ASSIGN pFieldValue = RowObject.vl-base-coop-15.
        WHEN "vl-base-coop-20":U THEN ASSIGN pFieldValue = RowObject.vl-base-coop-20.
        WHEN "vl-base-coop-25":U THEN ASSIGN pFieldValue = RowObject.vl-base-coop-25.
        WHEN "vl-base-retencao":U THEN ASSIGN pFieldValue = RowObject.vl-base-retencao.
        WHEN "vl-bruto":U THEN ASSIGN pFieldValue = RowObject.vl-bruto.
        WHEN "vl-contrib-financ":U THEN ASSIGN pFieldValue = RowObject.vl-contrib-financ.
        WHEN "vl-contrib-prev":U THEN ASSIGN pFieldValue = RowObject.vl-contrib-prev.
        WHEN "vl-contrib-senar":U THEN ASSIGN pFieldValue = RowObject.vl-contrib-senar.
        WHEN "vl-deducao":U THEN ASSIGN pFieldValue = RowObject.vl-deducao.
        WHEN "vl-mat-equip":U THEN ASSIGN pFieldValue = RowObject.vl-mat-equip.
        WHEN "vl-nao-retido":U THEN ASSIGN pFieldValue = RowObject.vl-nao-retido.
        WHEN "vl-repasse":U THEN ASSIGN pFieldValue = RowObject.vl-repasse.
        WHEN "vl-ret-subempr":U THEN ASSIGN pFieldValue = RowObject.vl-ret-subempr.
        WHEN "vl-retido":U THEN ASSIGN pFieldValue = RowObject.vl-retido.
        WHEN "vl-servicos":U THEN ASSIGN pFieldValue = RowObject.vl-servicos.
        WHEN "vl-servicos-15":U THEN ASSIGN pFieldValue = RowObject.vl-servicos-15.
        WHEN "vl-servicos-20":U THEN ASSIGN pFieldValue = RowObject.vl-servicos-20.
        WHEN "vl-servicos-25":U THEN ASSIGN pFieldValue = RowObject.vl-servicos-25.
        WHEN "vl-total-retido":U THEN ASSIGN pFieldValue = RowObject.vl-total-retido.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "idi-ind-obra":U THEN ASSIGN pFieldValue = RowObject.idi-ind-obra.
        WHEN "num-contrato-gfe":U THEN ASSIGN pFieldValue = RowObject.num-contrato-gfe.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "num-romaneio":U THEN ASSIGN pFieldValue = RowObject.num-romaneio.
        WHEN "num-seq":U THEN ASSIGN pFieldValue = RowObject.num-seq.
        WHEN "tp-aquis":U THEN ASSIGN pFieldValue = RowObject.tp-aquis.
        WHEN "tp-incidencia":U THEN ASSIGN pFieldValue = RowObject.tp-incidencia.
        WHEN "tp-insc-cno":U THEN ASSIGN pFieldValue = RowObject.tp-insc-cno.
        WHEN "tp-origem":U THEN ASSIGN pFieldValue = RowObject.tp-origem.
        WHEN "tp-repasse":U THEN ASSIGN pFieldValue = RowObject.tp-repasse.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice dctstqsc_id
  Parameters:  
               retorna valor do campo nro-docto-esoc
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnro-docto-esoc LIKE docum-est-esoc.nro-docto-esoc NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnro-docto-esoc = RowObject.nro-docto-esoc.

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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
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
  Purpose:     Reposiciona registro com base no ¡ndice dctstqsc_id
  Parameters:  
               recebe valor do campo nro-docto-esoc
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnro-docto-esoc LIKE docum-est-esoc.nro-docto-esoc NO-UNDO.

    FIND FIRST bfdocum-est-esoc WHERE 
        bfdocum-est-esoc.nro-docto-esoc = pnro-docto-esoc NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfdocum-est-esoc THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfdocum-est-esoc)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDocumento DBOProgram 
PROCEDURE openQueryDocumento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

     OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
          WHERE {&tableName}.serie-docto  = c-serie
            AND {&tableName}.nro-docto    = c-docto
            AND {&tableName}.cod-emitente = c-emitente
            AND {&tableName}.nat-operacao = c-nat-operacao INDEXED-REPOSITION.

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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryRomaneio DBOProgram 
PROCEDURE openQueryRomaneio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
     OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
          WHERE {&tableName}.cod-estabel  = c-cod-estab-rom
            AND {&tableName}.num-romaneio = i-num-romaneio
            AND {&tableName}.num-seq      = i-num-seq INDEXED-REPOSITION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryTitulo DBOProgram 
PROCEDURE openQueryTitulo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

     OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
          WHERE {&tableName}.cod-estabel     = c-cod-estab-tit
            AND {&tableName}.cod-espec-docto = c-cod-espec-tit 
            AND {&tableName}.serie-docto     = c-serie-tit
            AND {&tableName}.cod-emitente    = c-cod-emit-tit 
            AND {&tableName}.cod-tit-ap      = c-cod-titulo 
            AND {&tableName}.cod-parcela     = c-cod-parc-tit 
            AND {&tableName}.ep-codigo       = i-ep-codigo    INDEXED-REPOSITION.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAtualizaTitulo DBOProgram 
PROCEDURE piAtualizaTitulo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER TABLE FOR tt-titulo-apb-esocial.

    FIND FIRST tt-titulo-apb-esocial NO-LOCK NO-ERROR.
    IF AVAIL tt-titulo-apb-esocial THEN DO:

        FIND FIRST docum-est-esoc EXCLUSIVE-LOCK 
             WHERE ROWID(docum-est-esoc) = tt-titulo-apb-esocial.r-rowid NO-ERROR.
        IF AVAIL docum-est-esoc THEN DO:

            ASSIGN docum-est-esoc.cod-estabel      = tt-titulo-apb-esocial.cod-estabel    
                   docum-est-esoc.cod-tit-ap       = tt-titulo-apb-esocial.cod-tit-ap     
                   docum-est-esoc.cod-emitente     = INT(tt-titulo-apb-esocial.cod-emitente)   
                   docum-est-esoc.serie-docto      = tt-titulo-apb-esocial.serie-docto    
                   docum-est-esoc.cod-espec-docto  = tt-titulo-apb-esocial.cod-espec-docto
                   docum-est-esoc.cod-parcela      = tt-titulo-apb-esocial.cod-parcela    
                   docum-est-esoc.vl-bruto         = tt-titulo-apb-esocial.vl-bruto.

        END.

    END.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piFormatoCpfCnpj DBOProgram 
PROCEDURE piFormatoCpfCnpj :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE OUTPUT PARAMETER pCpf  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pCnpj AS CHARACTER NO-UNDO.

    IF NOT AVAILABLE param-global THEN
       FIND FIRST param-global NO-LOCK NO-ERROR.

    IF AVAILABLE param-global THEN 
       ASSIGN pCpf  = param-global.formato-id-pessoal
              pCnpj = param-global.formato-id-federal.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRecalculoImposto DBOProgram 
PROCEDURE piRecalculoImposto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   DEFINE INPUT PARAMETER TABLE FOR RowObject-aux.

   FIND FIRST RowObject-aux NO-LOCK NO-ERROR.

   IF AVAIL RowObject-aux THEN DO:

       FIND FIRST docum-est-esoc WHERE ROWID(docum-est-esoc) = RowObject-aux.r-rowid NO-LOCK NO-ERROR.
       IF NOT AVAIL docum-est-esoc THEN
           LEAVE.

       FOR EACH item-doc-est-esoc EXCLUSIVE-LOCK
          WHERE item-doc-est-esoc.nro-docto-esoc = docum-est-esoc.nro-docto-esoc:
           
           ASSIGN item-doc-est-esoc.vl-base-retencao = (rowObject-aux.vl-base-retencao * item-doc-est-esoc.vl-base-retencao) / docum-est-esoc.vl-base-retencao.

       END.

       ASSIGN docum-est-esoc.vl-apurad        = RowObject-aux.vl-apurad        
              docum-est-esoc.vl-base-retencao = RowObject-aux.vl-base-retencao.
       
   END.

   RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaTotalItem DBOProgram 
PROCEDURE piValidaTotalItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER TABLE FOR tt-item-doc-est-esoc.

    ASSIGN de-vl-total-inss = 0.

    FOR EACH tt-item-doc-est-esoc:
        ASSIGN de-vl-total-inss = de-vl-total-inss + tt-item-doc-est-esoc.vl-bruto.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValorBaseRetencao DBOProgram 
PROCEDURE piValorBaseRetencao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/    
    
    DEFINE INPUT PARAM pVlBruto LIKE docum-est-esoc.vl-bruto NO-UNDO.
    
    ASSIGN de-vl-total-inss = 0
           de-vl-total-inss = pVlBruto.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintDocumEst DBOProgram 
PROCEDURE setConstraintDocumEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAM pCodEmitente    LIKE docum-est.cod-emitente NO-UNDO.
    DEFINE INPUT PARAM pSerie          LIKE docum-est.serie-docto  NO-UNDO.
    DEFINE INPUT PARAM pDocto          LIKE docum-est.nro-docto    NO-UNDO.
    DEFINE INPUT PARAM pNatOperacao    LIKE docum-est.nat-operacao NO-UNDO.

    ASSIGN c-emitente     = pCodEmitente 
           c-serie        = pSerie       
           c-docto        = pDocto       
           c-nat-operacao = pNatOperacao. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintRomaneio DBOProgram 
PROCEDURE setConstraintRomaneio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pCodEstabel     LIKE docum-est.cod-estabel       NO-UNDO.
    DEFINE INPUT PARAM pNumRomaneio    LIKE docum-est-esoc.num-romaneio NO-UNDO.
    DEFINE INPUT PARAM pNumSeq         LIKE docum-est-esoc.num-seq      NO-UNDO.


    ASSIGN c-cod-estab-rom  = pCodEstabel 
           i-num-romaneio   = pNumRomaneio       
           i-num-seq        = pNumSeq. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintTitulo DBOProgram 
PROCEDURE setConstraintTitulo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    DEFINE INPUT PARAM pCodEstab       LIKE docum-est-esoc.cod-estabel      NO-UNDO.
    DEFINE INPUT PARAM pCodEspec       LIKE docum-est-esoc.cod-espec-docto  NO-UNDO.
    DEFINE INPUT PARAM pSerie          LIKE docum-est-esoc.serie-docto      NO-UNDO.
    DEFINE INPUT PARAM pCodEmitente    LIKE docum-est-esoc.cod-emitente     NO-UNDO.
    DEFINE INPUT PARAM pCodTitulo      LIKE docum-est-esoc.cod-tit-ap       NO-UNDO.
    DEFINE INPUT PARAM pCodParcela     LIKE docum-est-esoc.cod-parcela      NO-UNDO.
    DEFINE INPUT PARAM piEpCodigo      like empresa.ep-codigo               NO-UNDO.

    ASSIGN c-cod-estab-tit = pCodEstab     
           c-cod-espec-tit = pCodEspec   
           c-serie-tit     = pSerie      
           c-cod-emit-tit  = pCodEmitente
           c-cod-titulo    = pCodTitulo  
           c-cod-parc-tit  = pCodParcela 
           i-ep-codigo     = piEpCodigo.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDocumEst DBOProgram 
PROCEDURE setDocumEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pRowid      AS ROWID NO-UNDO.
    DEFINE OUTPUT PARAMETER pRowidEsoc AS ROWID NO-UNDO.

    FIND FIRST docum-est WHERE ROWID(docum-est) = pRowid NO-LOCK NO-ERROR.
    IF AVAIL docum-est THEN DO:
    
        FIND FIRST docum-est-esoc 
             WHERE docum-est-esoc.serie-docto  = string(docum-est.serie-docto)
               AND docum-est-esoc.nro-docto    = string(docum-est.nro-docto)
               AND docum-est-esoc.cod-emitente = docum-est.cod-emitente
               AND docum-est-esoc.nat-operacao = string(docum-est.nat-operacao) EXCLUSIVE-LOCK NO-ERROR.
        
        ASSIGN pRowidEsoc = IF AVAIL docum-est-esoc THEN ROWID(docum-est-esoc) ELSE ?.

    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaDelete DBOProgram 
PROCEDURE validaDelete :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pPrograma AS CHAR NO-UNDO.
    DEFINE INPUT PARAMETER pTpOrigem AS INT  NO-UNDO.

    IF pPrograma = "RE1001U" AND
       pTpOrigem = 1 THEN DO:
        RUN deleteEsoc (INPUT rowid(docum-est-esoc)).
    END.
    IF pPrograma = "RE1001U" AND
       pTpOrigem = 2 THEN DO:
        RUN deleteEsoc (INPUT rowid(docum-est-esoc)).
    END.
    ELSE IF pPrograma = "RE1001V" AND
            pTpOrigem = 3 THEN DO:
        RUN deleteEsoc (INPUT rowid(docum-est-esoc)).
    END.
    ELSE IF pPrograma = "RE1001V" AND
            pTpOrigem = 1 THEN DO:
        RUN deleteEsoc (INPUT rowid(docum-est-esoc)).
    END.
    ELSE IF pPrograma = "GG2000" AND
            pTpOrigem = 3 THEN DO:
        RUN deleteEsoc (INPUT rowid(docum-est-esoc)).
    END.



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
    
    DEFINE VARIABLE h-boad00486 AS HANDLE NO-UNDO.
    DEFINE VARIABLE h-boad00487 AS HANDLE NO-UNDO.
    
    DEFINE VARIABLE dDatFimValid AS DATE    NO-UNDO.
    DEFINE VARIABLE iAbrangen    AS INTEGER NO-UNDO.
    
    /*:T--- Utilize o parƒmetro pType para identificar quais as valida‡äes a serem
          executadas ---*/
    /*:T--- Os valores poss¡veis para o parƒmetro sÆo: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as valida‡äes ---*/
    
    /*:T--- Verifica ocorrˆncia de erros ---*/

    FIND FIRST emitente 
         WHERE emitente.cod-emitente = int(rowobject.cod-emitente) NO-LOCK NO-ERROR.
         
    ASSIGN c-tipo-produtor = trim(SUBSTRING(emitente.char-2,104,8)) WHEN AVAILABLE emitente.
  
    IF rowobject.cod-layout = "1250" AND rowObject.nr-proc-jud <> "" THEN DO:
    
        FIND FIRST proces-esocial-recebimento NO-LOCK
             WHERE proces-esocial-recebimento.cdn-emitente      = rowObject.cod-emitente
             AND   proces-esocial-recebimento.cod-process-judic = rowObject.nr-proc-jud NO-ERROR.
             
        IF NOT AVAIL proces-esocial-recebimento THEN DO:
           {method/svc/errors/inserr.i &ErrorNumber="56496" 
                                       &ErrorType="EMS"
                                       &ErrorParameters= "'o processo ' + string(rowObject.nr-proc-jud)  + '~~~~' + 'emitente ' + STRING(rowObject.cod-emitente)"}
        END.
           
        FIND FIRST proces-esocial-suspen NO-LOCK
             WHERE proces-esocial-suspen.cod-process-judic = rowObject.nr-proc-jud
             AND   proces-esocial-suspen.cod-seq-suspen    = rowObject.cod-seq-suspen NO-ERROR.
        IF NOT AVAIL proces-esocial-suspen THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="56496" 
                                       &ErrorType="EMS"
                                       &ErrorParameters= "'o processo ' + string(rowObject.nr-proc-jud)  + '~~~~' + ' c¢digo suspensÆo ' + STRING(rowObject.cod-seq-suspen)"}
        
        END.
    END.

    IF rowobject.cod-layout = "1310" THEN
        IF de-vl-total-inss <> rowobject.vl-bruto THEN DO:
            {method/svc/errors/inserr.i
                   &ErrorNumber="53709"
                   &ErrorType="EMS"
                   &ErrorSubType="ERROR"}
        END.
        

    IF rowobject.cod-layout = "1330" OR
       rowobject.cod-layout = "1310" THEN DO:
    
        IF rowObject.vl-base-retencao > rowobject.vl-bruto THEN DO:
            {method/svc/errors/inserr.i
                   &ErrorNumber="53710"
                   &ErrorType="EMS"
                   &ErrorSubType="ERROR"}
        END.
    
        IF rowObject.vl-base-retencao > 0 AND rowobject.vl-apurad = 0 THEN DO:
            {method/svc/errors/inserr.i
                   &ErrorNumber="53696"
                   &ErrorType="EMS"
                   &ErrorSubType="ERROR"}
        END.
    
        IF rowObject.vl-ret-subempr > rowobject.vl-apurad THEN DO:
            {method/svc/errors/inserr.i
                   &ErrorNumber="53697"
                   &ErrorType="EMS"
                   &ErrorSubType="ERROR"}
        END.
    
        IF rowObject.vl-adicional <> ((rowObject.vl-servicos-15 * 0.04) + 
                                      (rowObject.vl-servicos-20 * 0.03) + 
                                      (rowObject.vl-servicos-25 * 0.02)) THEN DO:
            {method/svc/errors/inserr.i
                   &ErrorNumber="53698"
                   &ErrorType="EMS"
                   &ErrorSubType="ERROR"} 
        END.
   
        IF rowobject.vl-nao-retido > (rowobject.vl-retido + rowobject.vl-adicional) THEN DO:
    
            {method/svc/errors/inserr.i
                   &ErrorNumber="53699"
                   &ErrorType="EMS"
                   &ErrorSubType="ERROR"} 
    
        END.        
    END.
    
    IF rowobject.cod-layout = "1330" THEN DO:

        IF rowobject.vl-bruto <> (rowobject.vl-mat-equip + rowobject.vl-servicos) THEN DO:

            {method/svc/errors/inserr.i
                   &ErrorNumber="53703"
                   &ErrorType="EMS"
                   &ErrorSubType="ERROR"} 
    
        END.

    
    
        IF rowobject.vl-deducao > rowobject.vl-servicos THEN DO:
    
            {method/svc/errors/inserr.i
                   &ErrorNumber="53704"
                   &ErrorType="EMS"
                   &ErrorSubType="ERROR"} 
    
        END.
        
        IF rowObject.vl-base-coop < ((rowObject.vl-servicos-15) + 
                                     (rowObject.vl-servicos-20) + 
                                     (rowObject.vl-servicos-25)) THEN DO:
                                        
            {method/svc/errors/inserr.i
                   &ErrorNumber="53734"
                   &ErrorType="EMS"
                   &ErrorSubType="ERROR"}
                   
                             
        END.
        
        IF rowObject.vl-base-calc > rowObject.vl-base-coop THEN DO:
                                         
            {method/svc/errors/inserr.i
                   &ErrorNumber="53735"
                   &ErrorType="EMS"
                   &ErrorSubType="ERROR"}
                   
                             
        END.
        
        IF rowObject.vl-base-coop-15 > rowObject.vl-servicos-15 THEN DO:
                                         
            {method/svc/errors/inserr.i
                   &ErrorNumber="53736"
                   &ErrorType="EMS"
                   &ErrorSubType="ERROR"}
                   
                             
        END.
        
        IF rowObject.vl-base-coop-20 > rowObject.vl-servicos-20 THEN DO:
                                         
            {method/svc/errors/inserr.i
                   &ErrorNumber="53737"
                   &ErrorType="EMS"
                   &ErrorSubType="ERROR"}
                   
                             
        END.
        
        IF rowObject.vl-base-coop-25 > rowObject.vl-servicos-25 THEN DO:
                                         
            {method/svc/errors/inserr.i
                   &ErrorNumber="53738"
                   &ErrorType="EMS"
                   &ErrorSubType="ERROR"}
                   
                             
        END.
        
    END.
        
    IF rowobject.cod-layout = "1350":U THEN DO:

        IF c-tipo-produtor <> "PR Rural":U THEN DO:

            {method/svc/errors/inserr.i
                   &ErrorNumber="53714"
                   &ErrorType="EMS"
                   &ErrorSubType="ERROR"} 
    
        END.

        IF (rowobject.vl-contrib-prev + rowobject.vl-contrib-financ + rowobject.vl-contrib-senar) >= rowobject.vl-bruto THEN DO:
            {method/svc/errors/inserr.i
                   &ErrorNumber="53715"
                   &ErrorType="EMS"
                   &ErrorSubType="ERROR"} 
        END.

    END.
    
    IF rowobject.cod-layout = "1370" THEN DO:
       IF rowobject.nr-proc-jud = "" AND rowobject.vl-repasse <= 0 THEN DO:
          {method/svc/errors/inserr.i
                  &ErrorNumber="53706"
                  &ErrorType="EMS"
                  &ErrorSubType="ERROR"} 
    
       END.             
    END.


    
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

