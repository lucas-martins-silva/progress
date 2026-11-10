&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 

{include/i-prgvrs.i BOIN00961 2.00.00.049 } /*** "010049" 17/06/2025 16:40:41 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin00961 MAQ}
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
&GLOBAL-DEFINE DBOName BOIN00961
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName carg-rural
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

/******************************************************************************************
** TECNICA SEGURANCA ESTABELECIMENTO
******************************************************************************************/ 
{include/i-estab-security.i}
/******************************************************************************************
** TECNICA SEGURANCA ESTABELECIMENTO
******************************************************************************************/

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
{inbo/boin00961.i RowObject}
{inbo/boin01009.i1 tt-gera-nc row-errors-nc} /* nao conformidade */

{include/i_prdvers.i} /* Vers„o Produto */


DEFINE VARIABLE d-dt-trans       AS DATE      NO-UNDO.

DEFINE VARIABLE c-cod-estabel    AS CHARACTER NO-UNDO.
DEFINE VARIABLE i-num-carg-ini   AS INTEGER   NO-UNDO.
DEFINE VARIABLE i-num-carg-fim   AS INTEGER   NO-UNDO.
DEFINE VARIABLE c-carga-ini      AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-carga-fim      AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-item-ini       AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-item-fim       AS CHARACTER NO-UNDO.
DEFINE VARIABLE d-dt-trans-ini   AS DATE      NO-UNDO.
DEFINE VARIABLE d-dt-trans-fim   AS DATE      NO-UNDO.
DEFINE VARIABLE c-placa-ini      AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-placa-fim      AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cod-rota-ini   AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cod-rota-fim   AS CHARACTER NO-UNDO.
DEFINE VARIABLE l-recalc-per     AS LOGICAL   NO-UNDO.

DEFINE VARIABLE c-cod-rota-old   AS CHARACTER NO-UNDO.


DEFINE VARIABLE c-Status         AS CHARACTER            NO-UNDO.
DEFINE VARIABLE l-Iniciada       AS LOGICAL              NO-UNDO.
DEFINE VARIABLE l-em-descarg     AS LOGICAL              NO-UNDO.
DEFINE VARIABLE l-desc-concl     AS LOGICAL              NO-UNDO.
DEFINE VARIABLE l-estoq-atual    AS LOGICAL              NO-UNDO.
DEFINE VARIABLE l-Encerrada      AS LOGICAL              NO-UNDO.
DEFINE VARIABLE l-Reaberta       AS LOGICAL              NO-UNDO.
DEFINE VARIABLE l-criaProdutAut  AS LOGICAL  INITIAL YES NO-UNDO.


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
/*{method/dboqry.i}*/


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
DEFINE BUFFER b-carg-rural   FOR carg-rural.
DEFINE BUFFER bfProdutCarg   FOR produt-carg.
DEFINE BUFFER bf-liber-carg  FOR liber-carg.
DEFINE BUFFER bf-pesagem     FOR pesagem.
DEFINE BUFFER bf-ficha-cq    FOR ficha-cq.
DEFINE BUFFER bf-item        FOR ITEM.
DEFINE BUFFER bf-item-estab-rural FOR item-estab-rural.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaLiberCargAnalise DBOProgram 
PROCEDURE atualizaLiberCargAnalise :
/*------------------------------------------------------------------------------
  Purpose: atualiza situacao ap¢s retorno do roteiro de inspeá∆o    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER i-nr-ficha AS INTEGER NO-UNDO.

    DEFINE VARIABLE i-idi-aprova AS INTEGER NO-UNDO.

    FIND FIRST bf-ficha-cq NO-LOCK
         WHERE bf-ficha-cq.nr-ficha = i-nr-ficha NO-ERROR.

    IF NOT AVAIL bf-ficha-cq THEN RETURN 'NOK':U.
    
    IF  bf-ficha-cq.situacao = 4 THEN DO:
        IF bf-ficha-cq.qt-rejeitada > 0 THEN
            ASSIGN i-idi-aprova = 3. /* reprovado */
        ELSE IF (bf-ficha-cq.qt-aprovada > 0 OR bf-ficha-cq.qt-apr-cond > 0) THEN
            ASSIGN i-idi-aprova = 2. /* aprovado */
        ELSE 
            ASSIGN i-idi-aprova = 3. /* reprovado */    
    END.
    
    IF i-idi-aprova > 0 THEN DO:        
        FOR EACH bf-liber-carg EXCLUSIVE-LOCK
           &IF "{&product_version}" >= "12.1.C":U &THEN /*12.1.13*/
           WHERE bf-liber-carg.nr-ficha = i-nr-ficha:
           &ELSE
           WHERE bf-liber-carg.num-livre-1 = i-nr-ficha:           
           &ENDIF

            IF i-idi-aprova = 3 THEN DO:
                FOR FIRST b-carg-rural NO-LOCK
                    WHERE b-carg-rural.num-carg  = bf-liber-carg.num-carg:

                    FOR FIRST estabelec NO-LOCK
                        WHERE estabelec.cod-estabel = b-carg-rural.cod-estabel:

                       /* IF l-estab-security-active 
                        AND NOT CAN-FIND(FIRST {&ESTAB-SEC-TT} 
                                         WHERE {&ESTAB-SEC-TT-FIELD} = estabelec.cod-estabel) THEN NEXT.*/
    
                        IF estabelec.dep-rej-cq <> "" THEN 
                            ASSIGN bf-liber-carg.cod-depos = estabelec.dep-rej-cq.
                    END.

                END.
                FOR FIRST rej-ficha NO-LOCK
                    WHERE rej-ficha.nr-ficha = i-nr-ficha: 

                    ASSIGN bf-liber-carg.codigo-rejei = rej-ficha.codigo-rejei.
                    
                    &IF "{&product_version}" >= "12.1.C":U &THEN /*12.1.13*/                    
                    ASSIGN bf-liber-carg.cod-obs      = rej-ficha.observacao.
                    &ELSE
                    OVERLAY(bf-liber-carg.cod-livre-1, 1, 50) = rej-ficha.observacao.
                    &ENDIF
                END.
            END.

            ASSIGN bf-liber-carg.idi-aprova = i-idi-aprova.
        END.
    END.

    RETURN 'OK':U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaSituacao DBOProgram 
PROCEDURE atualizaSituacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pi-num-carg AS INTEGER NO-UNDO.    
    DEFINE INPUT PARAMETER pi-cdn-sit  AS INTEGER NO-UNDO.

    FOR FIRST b-carg-rural FIELDS(cdn-sit num-carg) EXCLUSIVE-LOCK
        WHERE b-carg-rural.num-carg = pi-num-carg: END.
    IF NOT AVAIL b-carg-rural THEN
        RETURN 'NOK':U.

    ASSIGN b-carg-rural.cdn-sit = pi-cdn-sit.

    RETURN 'OK':U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizCompartReprov DBOProgram 
PROCEDURE atualizCompartReprov PRIVATE :
/*------------------------------------------------------------------------------
  Purpose: Atualizar quantidade dos compartimentos reprovados que n∆o tenham
           sido descarregados.     
  Parameters:  N£mero da Carga
  Notes: Somente faz a atualizaá∆o se o compartimento estiver reprovado
         e a quantidade for igual a zero.       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-num-carg AS INTEGER NO-UNDO.

    DEFINE VARIABLE d-tot-compart AS DECIMAL NO-UNDO.

    FOR EACH bf-liber-carg FIELDS(num-carg idi-aprova val-quant cdn-compart) EXCLUSIVE-LOCK 
       WHERE bf-liber-carg.num-carg = p-num-carg:
    
        IF bf-liber-carg.idi-aprova <> 3 THEN NEXT.
        IF bf-liber-carg.val-quant <> 0 THEN NEXT.
    
        ASSIGN d-tot-compart = 0.
        FOR EACH bfProdutCarg FIELDS(cdn-compart qtd-coleta) NO-LOCK
           WHERE bfProdutCarg.num-carg = bf-liber-carg.num-carg:

            IF bfProdutCarg.cdn-compart <> bf-liber-carg.cdn-compart THEN NEXT.

            ASSIGN d-tot-compart = d-tot-compart + bfProdutCarg.qtd-coleta.
           
        END.
    
        ASSIGN bf-liber-carg.val-quant = d-tot-compart.

    END.

    RETURN 'OK':U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizQtdAferid DBOProgram 
PROCEDURE atualizaQtdEncerramento :
/*------------------------------------------------------------------------------
  Purpose: Atualizar quantidade aferida e coletada na tabela carg-rural 
           no momento do encerramento da carga
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pi-num-carg AS INTEGER NO-UNDO. 
    
    DEFINE VARIABLE d-qtd-aferid AS DECIMAL NO-UNDO.
    DEFINE VARIABLE d-qtd-coleta AS DECIMAL NO-UNDO.
    
    FOR FIRST b-carg-rural FIELDS(num-carg it-codigo cod-estabel) EXCLUSIVE-LOCK
        WHERE b-carg-rural.num-carg = pi-num-carg:
        
        /* BUSCA QUANTIDADE AFERIDA */
        FOR EACH bf-liber-carg FIELDS(val-quant) NO-LOCK
           WHERE bf-liber-carg.num-carg = pi-num-carg:
            ASSIGN d-qtd-aferid = d-qtd-aferid + bf-liber-carg.val-quant.
        END.
        
        /* BUSCA QUANTIDADE COLETADA */
        FOR EACH bfProdutCarg FIELDS(qtd-coleta) NO-LOCK
           WHERE bfProdutCarg.num-carg = pi-num-carg:        
            ASSIGN d-qtd-coleta = d-qtd-coleta + bfProdutCarg.qtd-coleta.
        END.
        
        ASSIGN b-carg-rural.qtd-aferid = d-qtd-aferid
               b-carg-rural.qtd-coleta = d-qtd-coleta.
    END.
    
    RETURN 'OK':U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDeleteRecord DBOProgram 
PROCEDURE beforeDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose: Elimina tabelas dependentes    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE h-boin00981 AS HANDLE      NO-UNDO.
    DEFINE VARIABLE h-boin00982 AS HANDLE      NO-UNDO.
    DEFINE VARIABLE h-boin00965 AS HANDLE      NO-UNDO.
    DEFINE VARIABLE h-boin00967 AS HANDLE      NO-UNDO.
    DEFINE VARIABLE h-boin01009 AS HANDLE      NO-UNDO.
    
    /* Pesagem */    
    RUN inbo/boin00981.p PERSISTENT SET h-boin00981. 
    RUN openQueryStatic IN h-boin00981(INPUT 'Main').
    RUN deletePesagem   IN h-boin00981(INPUT RowObject.num-carg).
    DELETE PROCEDURE h-boin00981.

    /* liber-carg */
    RUN inbo/boin00982.p PERSISTENT SET h-boin00982. 
    RUN openQueryStatic   IN h-boin00982(INPUT "Main").
    RUN deleteLiberCarg IN h-boin00982(INPUT RowObject.num-carg). 
    DELETE PROCEDURE h-boin00982.

    /* produt-carg*/
    RUN inbo/boin00965.p PERSISTENT SET h-boin00965 .
    RUN openQueryStatic   IN h-boin00965(INPUT "Main").
    RUN deleteProdutCargAut IN h-boin00965 (INPUT RowObject.num-carg,
                                            INPUT ?,
                                            INPUT ?,
                                            INPUT ?,
                                            INPUT ?,
                                            INPUT ?,
                                            INPUT YES) /* todos os produtores */. 
                                            
    DELETE PROCEDURE h-boin00965.

    /* alter-produt-carg */
    RUN inbo/boin00967.p PERSISTENT SET h-boin00967. 
    RUN deleteAlterProdutCarg IN h-boin00967(INPUT RowObject.num-carg). 
    DELETE PROCEDURE h-boin00967.
    
    /* naocfedade-carg */
    RUN inbo/boin01009.p PERSISTENT SET h-boin01009 .
    RUN delete-naocfedade-by-carg-rural IN h-boin01009(INPUT RowObject.num-carg).
    DELETE PROCEDURE h-boin01009.

    ASSIGN  h-boin00981 = ?
            h-boin00982 = ?
            h-boin00965 = ?
            h-boin00967 = ?.
            h-boin01009 = ?.            

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE aftercreateRecord  DBOProgram 
PROCEDURE aftercreateRecord  :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE h-boin00965 AS HANDLE NO-UNDO.
    DEFINE VARIABLE h-boin00982 AS HANDLE NO-UNDO.    
    
    /*cria produtores automaticamente*/ 
    IF l-criaProdutAut THEN DO:
        
        /* produt-carg*/
        RUN inbo/boin00965.p PERSISTENT SET h-boin00965.
        RUN openQueryStatic   IN h-boin00965(INPUT "Main").   
        
        RUN createProdutCargAut IN h-boin00965 (INPUT RowObject.cod-estabel,
                                                INPUT RowObject.num-carg,
                                                INPUT RowObject.dat-trans,                                 
                                                INPUT RowObject.it-codigo,
                                                INPUT 0,
                                                INPUT RowObject.cod-rota,
                                                INPUT 0).
                                                
                                                
        DELETE PROCEDURE h-boin00965.
        ASSIGN h-boin00965 = ?.

    END.
    
    /* CriaÁ„o de Pesagem*/
    IF RowObject.qtd-peso-brut > 0 THEN DO:
        IF NOT CAN-FIND(FIRST pesagem 
                        WHERE pesagem.num-carg = RowObject.num-carg
                          AND pesagem.cdn-pesagem = 1) THEN DO:
            CREATE pesagem.
            ASSIGN pesagem.num-carg       = RowObject.num-carg
                   pesagem.cdn-pesagem    = 1
                   pesagem.val-peso-balan = RowObject.qtd-peso-brut.  
                   
              /* produt-carg*/
            RUN inbo/boin00982.p PERSISTENT SET h-boin00982.
            RUN openQueryStatic   IN h-boin00982(INPUT "Main").                   
            RUN createLiberCarg   IN h-boin00982(INPUT RowObject.num-carg,
                                                 INPUT RowObject.qti-comptmento).
                                                  
            RUN getRowErrors IN h-boin00982(OUTPUT TABLE RowErrors).
            DELETE PROCEDURE h-boin00982.
            ASSIGN h-boin00982 = ?.
        END.
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
    FOR FIRST b-carg-rural FIELDS(cod-rota dat-trans) 
        WHERE b-carg-rural.num-carg = RowObject.num-carg:
        ASSIGN c-cod-rota-old = b-carg-rural.cod-rota.

        IF b-carg-rural.cod-rota  <> RowObject.cod-rota OR
           b-carg-rural.dat-trans <> RowObject.dat-trans THEN 
           ASSIGN l-recalc-per = YES. /*obrigar· a recalcular o perÌodo*/

    END.
    
    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterUpdateRecord DBOProgram 
PROCEDURE afterUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE h-boin00965 AS HANDLE NO-UNDO.

    IF l-recalc-per THEN DO:

        FOR EACH produt-carg FIELDS(log-livre-1) EXCLUSIVE-LOCK
           WHERE produt-carg.num-carg = RowObject.num-carg:

            ASSIGN produt-carg.log-livre-1 = FALSE /*o usu†rio modificou algo na carga que influencia no valor, dever† rodar apuraá∆o novamente*/
                   produt-carg.dat-trans   = RowObject.dat-trans.

        END.
    
    END.        

    IF c-cod-rota-old <> "" AND RowObject.cod-rota <> c-cod-rota-old THEN DO:
          /* produt-carg*/
        RUN inbo/boin00965.p PERSISTENT SET h-boin00965 .
        RUN openQueryStatic   IN h-boin00965(INPUT "Main").
        RUN deleteProdutCargAut IN h-boin00965 (INPUT RowObject.num-carg,
                                                INPUT ?,
                                                INPUT ?,
                                                INPUT ?,
                                                INPUT ?,
                                                INPUT ?,
                                                INPUT YES) /* todos os produtores */. 
                                                
        RUN createProdutCargAut IN h-boin00965 (INPUT RowObject.cod-estabel,
                                                INPUT RowObject.num-carg,
                                                INPUT RowObject.dat-trans,                                 
                                                INPUT RowObject.it-codigo,
                                                INPUT 0,
                                                INPUT RowObject.cod-rota,
                                                INPUT 0).
                                                
        DELETE PROCEDURE h-boin00965.
        ASSIGN h-boin00965 = ?.
    END.
    
    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE encerrarCarga DBOProgram 
PROCEDURE encerrarCarga :
/*------------------------------------------------------------------------------
  Purpose: Atualizar a quantidade total da carga pelo somatÛrio das quantidades 
           dos produtores
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pi-num-carg AS INTEGER NO-UNDO. 

    DEFINE VARIABLE d-tot-qtd-aferid AS DECIMAL NO-UNDO.
    DEFINE VARIABLE d-dif-qtd-aferid AS DECIMAL NO-UNDO.
    DEFINE VARIABLE i-cdn-identif    AS INTEGER NO-UNDO.

    FOR FIRST b-carg-rural FIELDS(it-codigo qtd-coleta qtd-aferid) NO-LOCK
        WHERE b-carg-rural.num-carg = pi-num-carg: END.

    IF NOT AVAIL b-carg-rural THEN RETURN 'NOK':U.
    
    RUN validaEncerramentoCarga IN THIS-PROCEDURE(INPUT pi-num-carg).    
    IF RETURN-VALUE = "NOK" THEN RETURN 'NOK':U.
    
    RUN gera-nao-conf-nao-coleta IN THIS-PROCEDURE(INPUT pi-num-carg).
    IF RETURN-VALUE = "NOK" THEN RETURN 'NOK':U.
    
    RUN gera-nao-conf-dif-qtde IN THIS-PROCEDURE(INPUT pi-num-carg). 
    IF RETURN-VALUE = "NOK" THEN RETURN 'NOK':U.    
    
    RUN gera-nao-conf-qualidade IN THIS-PROCEDURE(INPUT pi-num-carg). 
    IF RETURN-VALUE = "NOK" THEN RETURN 'NOK':U.    
    

    FOR FIRST bf-item FIELDS(fraciona)NO-LOCK 
        WHERE bf-item.it-codigo = b-carg-rural.it-codigo: END.  
    IF AVAIL bf-item THEN DO:
    
        FOR EACH bfProdutCarg FIELDS(num-carg cdn-identif qtd-coleta qtd-aferid) EXCLUSIVE-LOCK
           WHERE bfProdutCarg.num-carg = pi-num-carg
            BREAK BY bfProdutCarg.num-carg 
                  BY bfProdutCarg.qtd-coleta:

            IF bf-item.fraciona THEN                         
                ASSIGN bfProdutCarg.qtd-aferid = (b-carg-rural.qtd-aferid / b-carg-rural.qtd-coleta) * bfProdutCarg.qtd-coleta.
            ELSE
                ASSIGN bfProdutCarg.qtd-aferid = ROUND((b-carg-rural.qtd-aferid / b-carg-rural.qtd-coleta) * bfProdutCarg.qtd-coleta,0).               

            ASSIGN d-tot-qtd-aferid = d-tot-qtd-aferid + bfProdutCarg.qtd-aferid.
    
            IF LAST-OF(bfProdutCarg.num-carg) THEN
                ASSIGN i-cdn-identif = bfProdutCarg.cdn-identif.
        END.

        ASSIGN d-dif-qtd-aferid = b-carg-rural.qtd-aferid - d-tot-qtd-aferid.

        IF d-dif-qtd-aferid <> 0 THEN DO:
            FOR EACH bfProdutCarg FIELDS(qtd-aferid) EXCLUSIVE-LOCK
                WHERE bfProdutCarg.num-carg = pi-num-carg
                BY bfProdutCarg.qtd-coleta DESC:
                ASSIGN bfProdutCarg.qtd-aferid = bfProdutCarg.qtd-aferid + d-dif-qtd-aferid.
                LEAVE.
            END.
        END.
        
    END.

    RUN atualizCompartReprov IN THIS-PROCEDURE(INPUT pi-num-carg).

    RUN atualizaSituacao IN THIS-PROCEDURE(INPUT pi-num-carg, INPUT 5).
    
    RETURN 'OK'.    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gera-nao-conf-nao-coleta DBOProgram 
PROCEDURE gera-nao-conf-nao-coleta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
               
               
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pi-num-carg AS INTEGER NO-UNDO. 
    
    DEFINE VARIABLE h-boin01009 AS HANDLE NO-UNDO.  

    EMPTY TEMP-TABLE row-errors-nc NO-ERROR.
    EMPTY TEMP-TABLE tt-gera-nc    NO-ERROR.
    
    DEFINE VARIABLE c-des-naocfedade AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-msg            AS CHARACTER EXTENT 2 NO-UNDO.
    
    {utp/ut-liter.i NC_N∆o_Coleta._Motivo * }
    ASSIGN c-msg[1] = RETURN-VALUE + ": &1.".
    {utp/ut-liter.i Observaá∆o * }
    ASSIGN c-msg[2] = RETURN-VALUE + ": &2.".
    
    
    FOR EACH bfProdutCarg FIELDS(cdn-produt-respons num-carg cdn-identif 
                                 idi-nao-coleta cod-pto-coleta cdn-motiv-nao-coleta
                                 des-obs) NO-LOCK
       WHERE bfProdutCarg.num-carg         = pi-num-carg
         AND bfProdutCarg.cdn-produt-rural = bfProdutCarg.cdn-produt-respons:
         
        IF  bfProdutCarg.cdn-motiv-nao-coleta > 0
        AND bfProdutCarg.idi-nao-coleta = 1 THEN DO:
        
            CREATE tt-gera-nc.
            ASSIGN tt-gera-nc.num-carg           = bfProdutCarg.num-carg
                   tt-gera-nc.idi-tip-naocfedade = 3 /* Nao Coleta */
                   tt-gera-nc.cdn-identif        = bfProdutCarg.cdn-identif
                   tt-gera-nc.cdn-sit            = bfProdutCarg.idi-nao-coleta
                   tt-gera-nc.cod-pto-coleta     = bfProdutCarg.cod-pto-coleta.
             ASSIGN c-des-naocfedade = "".
             FOR FIRST motiv-nao-coleta NO-LOCK
                 WHERE motiv-nao-coleta.cdn-motiv-nao-coleta = bfProdutCarg.cdn-motiv-nao-coleta:
                ASSIGN c-des-naocfedade = REPLACE(c-msg[1], "&1", STRING(motiv-nao-coleta.cdn-motiv-nao-coleta) + " - " + motiv-nao-coleta.des-motivo).
                
                IF bfProdutCarg.des-obs <> "" THEN
                     ASSIGN c-des-naocfedade = c-des-naocfedade + " " + REPLACE(c-msg[2], "&2", bfProdutCarg.des-obs).
                     
                ASSIGN tt-gera-nc.des-naocfedade = c-des-naocfedade.                       
            END.
        END.
    END.    
    
    IF CAN-FIND(FIRST tt-gera-nc) THEN DO:
        RUN inbo/boin01009.p PERSISTENT SET h-boin01009.        
        RUN gera-nao-conformidade IN h-boin01009 (INPUT TABLE tt-gera-nc, 
                                                  OUTPUT TABLE row-errors-nc).   
        DELETE PROCEDURE h-boin01009.
        ASSIGN h-boin01009 = ?.
    END.
    
    IF CAN-FIND(FIRST row-errors-nc) THEN DO:
        FOR EACH row-errors-nc:
            CREATE RowErrors.
            BUFFER-COPY  row-errors-nc TO RowErrors.
        END.
        RETURN "NOK":U.
    END.
    
    RETURN 'OK':U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gera-nao-conf-dif-qtde DBOProgram 
PROCEDURE gera-nao-conf-dif-qtde :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
               
               
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pi-num-carg AS INTEGER NO-UNDO. 
    
    DEFINE VARIABLE h-boin01009 AS HANDLE NO-UNDO.  

    EMPTY TEMP-TABLE row-errors-nc NO-ERROR.
    EMPTY TEMP-TABLE tt-gera-nc    NO-ERROR.   
    
    DEFINE VARIABLE c-msg                    AS CHARACTER EXTENT 3 NO-UNDO.   
    DEFINE VARIABLE c-des-naocfedade         AS CHARACTER          NO-UNDO.
    DEFINE VARIABLE d-val-perc-variac-amaior AS DECIMAL            NO-UNDO.
    DEFINE VARIABLE d-val-perc-variac-amenor AS DECIMAL            NO-UNDO.
    DEFINE VARIABLE d-val-min                AS DECIMAL            NO-UNDO. 
    DEFINE VARIABLE d-val-max                AS DECIMAL            NO-UNDO.
    DEFINE VARIABLE d-diferenca              AS DECIMAL            NO-UNDO.
    
    {utp/ut-liter.i "NC_Diferenáa_Quantidade" * }
    ASSIGN c-msg[1] = RETURN-VALUE.
    {utp/ut-liter.i "Qtde_Aferida" * }
    ASSIGN c-msg[2] = RETURN-VALUE + ": &2.".
    {utp/ut-liter.i "Qtde_Coletada" * }
    ASSIGN c-msg[3] = RETURN-VALUE + ": &3.".
    
    FOR FIRST b-carg-rural NO-LOCK
        WHERE b-carg-rural.num-carg = pi-num-carg:
        FOR FIRST item-estab-rural
            WHERE item-estab-rural.it-codigo = b-carg-rural.it-codigo 
              AND item-estab-rural.cod-estabel = b-carg-rural.cod-estabel:
              
            ASSIGN d-val-perc-variac-amaior = 0
                   d-val-perc-variac-amenor = 0
                   d-val-min                = 0
                   d-val-max                = 0                   
                   d-val-perc-variac-amaior = b-carg-rural.qtd-coleta * (item-estab-rural.val-perc-variac-amaior / 100)
                   d-val-perc-variac-amenor = b-carg-rural.qtd-coleta * (item-estab-rural.val-perc-variac-amenor / 100)                   
                   d-val-min                = b-carg-rural.qtd-coleta - d-val-perc-variac-amenor /* Valor minimo permirtido */
                   d-val-max                = b-carg-rural.qtd-coleta + d-val-perc-variac-amaior /* Valor maximo permirtido */.
                   
            IF b-carg-rural.qtd-aferid < d-val-min 
            OR b-carg-rural.qtd-aferid > d-val-max THEN DO:
            
                ASSIGN d-diferenca =  b-carg-rural.qtd-aferid - b-carg-rural.qtd-coleta.

                IF d-diferenca < 0 THEN 
                    ASSIGN d-diferenca = d-diferenca * -1.
                    
                CREATE tt-gera-nc.
                ASSIGN tt-gera-nc.num-carg           = b-carg-rural.num-carg
                       tt-gera-nc.idi-tip-naocfedade = 1 /* Dif qtde */
                       tt-gera-nc.val-quant          = d-diferenca
                       tt-gera-nc.cdn-sit            = 1 /* Pendente */
                       tt-gera-nc.des-naocfedade     = c-msg[1] + ". " + 
                                                       REPLACE(c-msg[2],"&2", STRING(b-carg-rural.qtd-aferid )) + " " + 
                                                       REPLACE(c-msg[3],"&3", STRING(b-carg-rural.qtd-coleta )).
            END.
        END.
      
        RUN inbo/boin01009.p PERSISTENT SET h-boin01009.
        IF CAN-FIND(FIRST tt-gera-nc) THEN DO:
            RUN gera-nao-conformidade IN h-boin01009 (INPUT  TABLE tt-gera-nc, 
                                                      OUTPUT TABLE row-errors-nc).             
        END.
        ELSE DO:             
            RUN elimina-nao-conformidade IN h-boin01009 (INPUT b-carg-rural.num-carg,
                                                         INPUT 1, /*Dif. Qtde */ 
                                                         OUTPUT TABLE row-errors-nc).              
        END.
        DELETE PROCEDURE h-boin01009.
        ASSIGN h-boin01009 = ?.
        
        IF CAN-FIND(FIRST row-errors-nc) THEN DO:
            FOR EACH row-errors-nc:
                CREATE RowErrors.
                BUFFER-COPY  row-errors-nc TO RowErrors.
            END.
            RETURN "NOK":U.
        END.
    END.
    
    RETURN 'OK':U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gera-nao-conf-qualidade DBOProgram 
PROCEDURE gera-nao-conf-qualidade :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
               
               
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pi-num-carg AS INTEGER NO-UNDO. 
        
    DEFINE VARIABLE h-boin01009 AS HANDLE NO-UNDO.  
    
    EMPTY TEMP-TABLE row-errors-nc NO-ERROR.
    EMPTY TEMP-TABLE tt-gera-nc    NO-ERROR.   
    
    DEFINE VARIABLE c-des-naocfedade AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-msg            AS CHARACTER EXTENT 2 NO-UNDO.
    
    {utp/ut-liter.i NC_Qualidade._Rejeiá∆o * }
    ASSIGN c-msg[1] = RETURN-VALUE + ": &1.".
    {utp/ut-liter.i Observaá∆o * }
    ASSIGN c-msg[2] = RETURN-VALUE + ": &2.".    
    
    FOR EACH liber-carg FIELDS(num-carg cdn-compart val-quant codigo-rejei cod-livre-1 cod-obs) NO-LOCK
       WHERE liber-carg.num-carg = pi-num-carg
         AND liber-carg.idi-aprova = 3: /* Reprovado */
         
        CREATE tt-gera-nc.
        ASSIGN tt-gera-nc.num-carg           = liber-carg.num-carg
               tt-gera-nc.cdn-compart        = liber-carg.cdn-compart
               tt-gera-nc.val-quant          = liber-carg.val-quant
               tt-gera-nc.idi-tip-naocfedade = 2 /* Probl. Qualidade */
               tt-gera-nc.cdn-sit            = 1. /* Pendente */
               
        ASSIGN c-des-naocfedade = "".      
        FOR FIRST cod-rejeicao FIELDS(codigo-rejei descricao) NO-LOCK
            WHERE cod-rejeicao.codigo-rejei =  liber-carg.codigo-rejei:
            ASSIGN c-des-naocfedade = REPLACE(c-msg[1], "&1", STRING(cod-rejeicao.codigo-rejei) + " - " + cod-rejeicao.descricao).             
        END.

        &IF "{&product_version}" >= "12.1.C":U &THEN /*12.1.13*/            
         IF liber-carg.cod-obs <> "" THEN 
        &ELSE
         IF SUBSTRING(liber-carg.cod-livre-1, 1, 100) <> "" THEN 
        &ENDIF
             ASSIGN c-des-naocfedade = c-des-naocfedade + " " + REPLACE(c-msg[2], "&2", liber-carg.cod-obs).
             
        ASSIGN  tt-gera-nc.des-naocfedade = c-des-naocfedade.
    END.
    IF CAN-FIND(FIRST tt-gera-nc) THEN DO:
        RUN inbo/boin01009.p PERSISTENT SET h-boin01009.        
        RUN gera-nao-conformidade IN h-boin01009 (INPUT TABLE tt-gera-nc, 
                                                  OUTPUT TABLE row-errors-nc).   
        DELETE PROCEDURE h-boin01009.
        ASSIGN h-boin01009 = ?.
    END.
        
    IF CAN-FIND(FIRST row-errors-nc) THEN DO:
        FOR EACH row-errors-nc:
            CREATE RowErrors.
            BUFFER-COPY  row-errors-nc TO RowErrors.
        END.
        RETURN "NOK":U.
    END.
    
    RETURN 'OK':U.
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
        WHEN "cod-carga":U THEN ASSIGN pFieldValue = RowObject.cod-carga.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-inter-veic":U THEN ASSIGN pFieldValue = RowObject.cod-inter-veic.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-placa":U THEN ASSIGN pFieldValue = RowObject.cod-placa.
        WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
        WHEN "cod-rota":U THEN ASSIGN pFieldValue = RowObject.cod-rota.
        WHEN "cod-uf":U THEN ASSIGN pFieldValue = RowObject.cod-uf.
        WHEN "hra-entr":U THEN ASSIGN pFieldValue = RowObject.hra-entr.
        WHEN "hra-trans":U THEN ASSIGN pFieldValue = RowObject.hra-trans.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "nom-motorista":U THEN ASSIGN pFieldValue = RowObject.nom-motorista.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCreateSequence DBOProgram 
PROCEDURE getCreateSequence :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   DEFINE OUTPUT PARAMETER p-seq AS INTEGER NO-UNDO.
   
   blk-1:
   REPEAT: 
       ASSIGN p-seq = NEXT-VALUE(seq-carg-rural).
       IF NOT CAN-FIND(b-carg-rural
                 WHERE b-carg-rural.num-carg = p-seq) THEN
           LEAVE blk-1.
   END.
   
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
        WHEN "dat-entr":U THEN ASSIGN pFieldValue = RowObject.dat-entr.
        WHEN "dat-livre-1":U THEN ASSIGN pFieldValue = RowObject.dat-livre-1.
        WHEN "dat-livre-2":U THEN ASSIGN pFieldValue = RowObject.dat-livre-2.
        WHEN "dat-trans":U THEN ASSIGN pFieldValue = RowObject.dat-trans.
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
        WHEN "qtd-aferid":U THEN ASSIGN pFieldValue = RowObject.qtd-aferid.
        WHEN "qtd-peso-brut":U THEN ASSIGN pFieldValue = RowObject.qtd-peso-brut.
        WHEN "qtd-peso-liq":U THEN ASSIGN pFieldValue = RowObject.qtd-peso-liq.
        WHEN "qtd-peso-tara":U THEN ASSIGN pFieldValue = RowObject.qtd-peso-tara.
        WHEN "val-densidade":U THEN ASSIGN pFieldValue = RowObject.val-densidade.
        WHEN "val-hodom-final":U THEN ASSIGN pFieldValue = RowObject.val-hodom-final.
        WHEN "val-hodom-inicial":U THEN ASSIGN pFieldValue = RowObject.val-hodom-inicial.
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
        WHEN "cdn-sit":U THEN ASSIGN pFieldValue = RowObject.cdn-sit.
        WHEN "cod-transp":U THEN ASSIGN pFieldValue = RowObject.cod-transp.
        WHEN "num-carg":U THEN ASSIGN pFieldValue = RowObject.num-carg.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "qti-comptmento":U THEN ASSIGN pFieldValue = RowObject.qti-comptmento.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice num-carg
  Parameters:  
               retorna valor do campo num-carg
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnum-carg LIKE carg-rural.num-carg NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnum-carg = RowObject.num-carg.

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
  Purpose:     Reposiciona registro com base no °ndice num-carg
  Parameters:  
               recebe valor do campo num-carg
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnum-carg LIKE carg-rural.num-carg NO-UNDO.

    FIND FIRST bfcarg-rural WHERE 
        bfcarg-rural.num-carg = pnum-carg NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfcarg-rural THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfcarg-rural)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToEstabelec DBOProgram 
PROCEDURE linkToEstabelec :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pHandle AS HANDLE NO-UNDO.
    
    RUN getKey IN pHandle (OUTPUT c-cod-estabel).   
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryControleCargas DBOProgram 
PROCEDURE openQueryControleCargas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /* Seguranáa por estabelecimento */
    &scoped-define KEY-PHRASE {&TABLENAME}.num-carg >= i-num-carg-ini ~
                          AND {&TABLENAME}.num-carg <= i-num-carg-fim ~
                          AND {&TABLENAME}.cod-estabel = c-cod-estabel ~
                          AND {&TABLENAME}.dat-trans >= d-dt-trans-ini ~
                          AND {&TABLENAME}.dat-trans <= d-dt-trans-fim ~
                          AND {&TABLENAME}.cod-carga >= c-carga-ini ~
                          AND {&TABLENAME}.cod-carga <= c-carga-fim ~
                          AND {&TABLENAME}.it-codigo >= c-item-ini ~
                          AND {&TABLENAME}.it-codigo <= c-item-fim ~
                          AND {&TABLENAME}.cod-placa >= c-placa-ini ~
                          AND {&TABLENAME}.cod-placa <= c-placa-fim ~
                          AND {&TABLENAME}.cod-rota  >= c-cod-rota-ini ~
                          AND {&TABLENAME}.cod-rota  <= c-cod-rota-fim ~
                          AND (({&TableName}.cdn-sit = 1 AND l-Iniciada) ~
                            OR ({&TableName}.cdn-sit = 2 AND l-em-descarg) ~
                            OR ({&TableName}.cdn-sit = 3 AND l-desc-concl) ~
                            OR ({&TableName}.cdn-sit = 4 AND l-estoq-atual) ~
                            OR ({&TableName}.cdn-sit = 5 AND l-Encerrada) ~
                            OR ({&TableName}.cdn-sit = 6 AND l-Reaberta)) NO-LOCK
    /* inativo */                        
    &Scoped-define BY-ESTAB-IN by {&tableName}.num-carg  ~
                               by {&tableName}.cod-estabel
                     
                     
    /* ativo */                 
    &Scoped-define BY-ESTAB-AT by {&tableName}.cod-estabel ~
                                by {&tableName}.num-carg 
                                
    
    {include/i-estab-openquery.i}   
    

    RETURN "OK":U. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryEstabelec DBOProgram 
PROCEDURE openQueryEstabelec :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   
    /* Seguranáa por estabelecimento */
   &scoped-define KEY-PHRASE {&TABLENAME}.cod-estabel = c-cod-estabel NO-LOCK
   
    /* inativo */                        
    &Scoped-define BY-ESTAB-IN
    /* ativo */                 
    &Scoped-define BY-ESTAB-AT 
                               
    
    {include/i-estab-openquery.i}
   /*OPEN QUERY {&QueryName} 
      FOR EACH {&TableName}
         WHERE {&TableName}.cod-estabel = c-cod-estabel NO-LOCK INDEXED-REPOSITION.*/
         
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
    /* Seguranáa por estabelecimento */
    &scoped-define KEY-PHRASE TRUE NO-LOCK 
    /* inativo */                        
    &Scoped-define BY-ESTAB-IN
    /* ativo */                 
    &Scoped-define BY-ESTAB-AT
    
    {include/i-estab-openquery.i} 
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryNumCarg DBOProgram 
PROCEDURE openQueryNumCarg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
                                
    /* Seguranáa por estabelecimento */
    &scoped-define KEY-PHRASE {&TABLENAME}.num-carg >= i-num-carg-ini ~
                          AND {&TABLENAME}.num-carg <= i-num-carg-fim NO-LOCK
                          
    /* inativo */                        
    &Scoped-define BY-ESTAB-IN
    /* ativo */                 
    &Scoped-define BY-ESTAB-AT
    {include/i-estab-openquery.i}   

    
    {include/i-estab-openquery.i}                             

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaReaberturaCarga DBOProgram 
PROCEDURE validaReaberturaCarga:
/*------------------------------------------------------------------------------
  Purpose: Retornar a possibilidade de se abrir a carga
  Parameters: pi-num-carg => numero da carga

  Notes: naocfedade-carg.idi-tip-naocfedade =>  1 - Dif. Quantidade 
                                                2 - Qualidade
                                                3 - Nao Coleta
         naocfedade-carg.cdn-sit => 1 - Pendente 
                                    2 - Em analise
                                    3 - Resolvida
                                    
         Somente permite reabrir carga se todas as NC's estiverem pendentes 
         OU
         Encontrar NC com penalizacao
         E
         N„o houver nota gerada "para a carga"   
 
         Regra valida para diferenca de quantidade e problema de qualidade
                                    
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pi-num-carg AS INTEGER NO-UNDO.
    
    DEFINE VARIABLE l-permite-reabertura-nc AS LOGICAL INITIAL YES NO-UNDO.
    DEFINE VARIABLE l-permite-reabertura-pr AS LOGICAL INITIAL YES NO-UNDO.
    DEFINE VARIABLE c-msg-nc                AS CHARACTER           NO-UNDO.
    DEFINE VARIABLE c-msg-pr                AS CHARACTER           NO-UNDO.
    DEFINE VARIABLE c-msg-pr-aux            AS CHARACTER           NO-UNDO.
    DEFINE VARIABLE iErro                   AS INTEGER             NO-UNDO.
    DEFINE VARIABLE c-cod-propried LIKE fechto-produt-period.cod-propried NO-UNDO.
    DEFINE VARIABLE c-cod-period   LIKE fechto-produt-period.cod-period   NO-UNDO.

    FOR EACH naocfedade-carg 
       WHERE naocfedade-carg.num-carg = pi-num-carg
         AND naocfedade-carg.idi-tip-naocfedade < 3
         AND naocfedade-carg.cdn-sit = 3:  /* RESOLVIDAS*/        
        IF CAN-FIND(FIRST dest-cust-naocfedade  
                    WHERE dest-cust-naocfedade.cdn-naocfedade = naocfedade-carg.cdn-naocfedade) THEN DO: 
                        
            IF c-msg-nc <> "" THEN
                ASSIGN c-msg-nc = c-msg-nc + ",".
                
            ASSIGN c-msg-nc = c-msg-nc + STRING(naocfedade-carg.cdn-naocfedade).
            
            ASSIGN l-permite-reabertura-nc = NO.
            
        END.
    END.

    {utp/ut-liter.i Existe_nota_fiscal_gerada_para_o_produtor:_&1_e_propriedade:_&2. *}
    ASSIGN c-msg-pr = RETURN-VALUE.

    FOR EACH produt-carg FIELDS(cdn-produt-rural it-codigo cod-estabel cod-pto-coleta) NO-LOCK
        WHERE produt-carg.num-carg = pi-num-carg:

        FOR FIRST produt-pto-coleta FIELDS(cod-propried) NO-LOCK
            WHERE produt-pto-coleta.cdn-produt-rural = produt-carg.cdn-produt-rural
              AND produt-pto-coleta.cod-pto-coleta   = produt-carg.cod-pto-coleta:

            ASSIGN c-cod-propried = produt-pto-coleta.cod-propried.
        
        END.

        FOR FIRST param-aquis-rural FIELDS(cod-periodo) NO-LOCK
            WHERE param-aquis-rural.cod-estabel = produt-carg.cod-estabel:

            ASSIGN c-cod-period = IF INT(SUBSTRING(param-aquis-rural.cod-periodo,1,2)) < 9 
                                      THEN "0" + STRING(INT(SUBSTRING(param-aquis-rural.cod-periodo,1,2)) + 1) + SUBSTRING(param-aquis-rural.cod-periodo,3,4)
                                  ELSE IF INT(SUBSTRING(param-aquis-rural.cod-periodo,1,2)) < 12 
                                      THEN STRING(INT(SUBSTRING(param-aquis-rural.cod-periodo,1,2)) + 1) + SUBSTRING(param-aquis-rural.cod-periodo,3,4)    
                                  ELSE "01" +  STRING(INT(SUBSTRING(param-aquis-rural.cod-periodo,3,4)) + 1).

        END.

        IF CAN-FIND(FIRST fechto-produt-period
                    WHERE fechto-produt-period.cod-period       = c-cod-period
                      AND fechto-produt-period.cdn-produt-rural = produt-carg.cdn-produt-rural
                      AND fechto-produt-period.cod-propried     = c-cod-propried
                      AND fechto-produt-period.it-codigo        = produt-carg.it-codigo
                      AND fechto-produt-period.cod-estabel      = produt-carg.cod-estabel
                      AND fechto-produt-period.idi-situacao     = 3) THEN DO:

            ASSIGN l-permite-reabertura-pr = NO.

            FOR LAST RowErrors NO-LOCK:
                ASSIGN iErro = RowErrors.ErrorSequence.
            END.

            ASSIGN c-msg-pr-aux = REPLACE(c-msg-pr, '&1', STRING(produt-carg.cdn-produt-rural))
                   c-msg-pr-aux = REPLACE(c-msg-pr-aux, '&2', c-cod-propried) .

            CREATE RowErrors.
            ASSIGN RowErrors.ErrorSequence    = iErro + 1
                   RowErrors.ErrorNumber      = 55012
                   RowErrors.ErrorSubType     = "ERROR"
                   RowErrors.ErrorType        = "EMS"          
                   RowErrors.ErrorDescription = c-msg-pr-aux.



        END.

    END.

    IF NOT l-permite-reabertura-nc THEN DO:
        RUN utp/ut-msgs.p (INPUT 'msg':U, 
                           INPUT 54851, 
                           INPUT c-msg-nc).

        FOR LAST RowErrors NO-LOCK:
            ASSIGN iErro = RowErrors.ErrorSequence.
        END.

        CREATE rowErrors.
        ASSIGN RowErrors.ErrorSequence    = iErro + 1
               RowErrors.ErrorNumber      = 54851
               RowErrors.ErrorSubType     = "ERROR"
               RowErrors.ErrorType        = "EMS"          
               RowErrors.ErrorDescription = RETURN-VALUE.
        
    END.

    IF NOT l-permite-reabertura-nc OR NOT l-permite-reabertura-pr THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE reabrirCarga DBOProgram 
PROCEDURE reabrirCarga :
/*------------------------------------------------------------------------------
  Purpose: realizar a reabertura da carga    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pi-num-carg AS INTEGER NO-UNDO. 

    DEFINE VARIABLE c-label  AS CHARACTER  EXTENT 4  NO-UNDO.
    DEFINE VARIABLE iErrorSequence    AS INTEGER              NO-UNDO.

    FOR FIRST b-carg-rural FIELDS(it-codigo cod-estabel qtd-aferid num-carg) NO-LOCK
        WHERE b-carg-rural.num-carg = pi-num-carg: END.

    IF NOT AVAIL b-carg-rural THEN RETURN 'NOK':U.

    IF CAN-FIND(FIRST bfProdutCarg 
                WHERE bfProdutCarg.cdn-sit >= 2  /* nota gerada */
                  AND bfProdutCarg.num-carg = b-carg-rural.num-carg) THEN DO:
        {utp/ut-liter.i Emitente *}
        ASSIGN c-label[1] = RETURN-VALUE.
        {utp/ut-liter.i Documento *}
        ASSIGN c-label[2] = RETURN-VALUE.
        {utp/ut-liter.i Serie *}
        ASSIGN c-label[3] = RETURN-VALUE.

        EMPTY TEMP-TABLE rowErrors NO-ERROR.

        FOR EACH bfProdutCarg FIELDS(qtd-aferid)
              OF b-carg-rural EXCLUSIVE-LOCK:

            ASSIGN c-label[4] = c-label[1] + ":" + STRING(bfProdutCarg.cdn-produt-rural) + CHR(10) +
                                c-label[2] + ":" + STRING(bfProdutCarg.nro-docto) + CHR(10) +
                                c-label[3] + ":" + STRING(bfProdutCarg.serie-docto).

            IF bfProdutCarg.cdn-sit >= 2 THEN DO:
                RUN utp/ut-msgs.p (INPUT 'msg':U, 
                                   INPUT 54712, 
                                   INPUT bfProdutCarg.num-carg).
                 /*--- Atualiza variâvel de sequ›ncia de erros ---*/
                IF CAN-FIND(LAST rowErrors) THEN DO:
                    FIND LAST rowErrors NO-ERROR.
                    ASSIGN iErrorSequence = rowErrors.ErrorSequence + 1.
                END.
                ELSE
                    ASSIGN iErrorSequence = iErrorSequence + 1. 

                CREATE rowErrors.
                ASSIGN RowErrors.ErrorSequence    = iErrorSequence
                       RowErrors.ErrorNumber      = 54712
                       RowErrors.ErrorSubType     = "ERROR"
                       RowErrors.ErrorType        = "EMS"
                       RowErrors.ErrorHelp        = c-label[4]
                       RowErrors.ErrorDescription = RETURN-VALUE. 
               
            END.
        END. 

        RETURN 'NOK':U.
    END.
    ELSE DO:    
        /* Elimina n„o conformidade nao coleta que n„o estejam resolvidas */
        FOR EACH naocfedade-carg EXCLUSIVE-LOCK
           WHERE naocfedade-carg.num-carg = b-carg-rural.num-carg 
             AND naocfedade-carg.idi-tip-naocfedade = 3 /* NAO COLETA*/
             AND naocfedade-carg.cdn-sit < 3: /* 1- pendente 2- Em analise 3-Resolvido */             
            DELETE naocfedade-carg.
        END.
        
        FOR EACH bfProdutCarg FIELDS(qtd-aferid)
              OF b-carg-rural EXCLUSIVE-LOCK:
            /* Ao reabrir carga, passa situacao da NC para pendente */  
            IF bfProdutCarg.idi-nao-coleta  > 1 THEN
                ASSIGN bfProdutCarg.idi-nao-coleta = 1.
            ASSIGN bfProdutCarg.qtd-aferid = 0.
        END. 
    
        FOR FIRST bf-item-estab-rural FIELDS(idi-tip-aferic) NO-LOCK
            WHERE bf-item-estab-rural.it-codigo   = b-carg-rural.it-codigo
              AND bf-item-estab-rural.cod-estabel = b-carg-rural.cod-estabel:
            FOR FIRST b-carg-rural EXCLUSIVE-LOCK
                WHERE b-carg-rural.num-carg = pi-num-carg: 
                ASSIGN b-carg-rural.qtd-coleta = 0  /* Zera quantidade coletada*/
                       b-carg-rural.val-frete  = 0  /* Zera valor frete */                
                       b-carg-rural.qtd-aferid = 0.
            END.
        END.
             
        RUN atualizaSituacao IN THIS-PROCEDURE(INPUT pi-num-carg, INPUT 6). /* CARGA REABERTA */
        
    END.

    RETURN 'OK':U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintControleCargas DBOProgram 
PROCEDURE setConstraintControleCargas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-cod-estabel   AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-num-carg-ini  AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER p-num-carg-fim  AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER p-carga-ini     AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-carga-fim     AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-item-ini      AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-item-fim      AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-dt-trans-ini  AS DATE    NO-UNDO.
    DEFINE INPUT PARAMETER p-dt-trans-fim  AS DATE    NO-UNDO.
    DEFINE INPUT PARAMETER p-placa-ini     AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-placa-fim     AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-rota-ini  AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-rota-fim  AS CHARACTER NO-UNDO.
        
    DEFINE INPUT PARAMETER p-Iniciada       AS LOGICAL NO-UNDO.
    DEFINE INPUT PARAMETER p-em-descarg     AS LOGICAL NO-UNDO.
    DEFINE INPUT PARAMETER p-desc-concl     AS LOGICAL NO-UNDO.
    DEFINE INPUT PARAMETER p-estoq-atual    AS LOGICAL NO-UNDO.
    DEFINE INPUT PARAMETER p-Encerrada      AS LOGICAL NO-UNDO.
    DEFINE INPUT PARAMETER p-Reaberta       AS LOGICAL NO-UNDO.


    ASSIGN c-cod-estabel    = p-cod-estabel  
           i-num-carg-ini   = p-num-carg-ini     
           i-num-carg-fim   = p-num-carg-fim  
           c-carga-ini      = p-carga-ini     
           c-carga-fim      = p-carga-fim     
           c-item-ini       = p-item-ini      
           c-item-fim       = p-item-fim      
           d-dt-trans-ini   = p-dt-trans-ini  
           d-dt-trans-fim   = p-dt-trans-fim  
           c-placa-ini      = p-placa-ini     
           c-placa-fim      = p-placa-fim 
           c-cod-rota-ini   = p-cod-rota-ini  
           c-cod-rota-fim   = p-cod-rota-fim
              
           l-Iniciada       = p-Iniciada       
           l-em-descarg     = p-em-descarg   
           l-desc-concl     = p-desc-concl    
           l-estoq-atual    = p-estoq-atual            
           l-Encerrada      = p-Encerrada      
           l-Reaberta       = p-Reaberta. 

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintEstabData DBOProgram 
PROCEDURE setConstraintEstabData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cod-estabel AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-dt-trans    AS DATE      NO-UNDO.
    
    ASSIGN c-cod-estabel = p-cod-estabel
           d-dt-trans    = p-dt-trans.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintNumCarg DBOProgram 
PROCEDURE setConstraintNumCarg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE INPUT PARAMETER p-num-carg-ini AS INTEGER NO-UNDO.
   DEFINE INPUT PARAMETER p-num-carg-fim AS INTEGER NO-UNDO.

   ASSIGN i-num-carg-ini = p-num-carg-ini
          i-num-carg-fim = p-num-carg-fim.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setAtualiza DBOProgram 
PROCEDURE setAtualiza :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-num-carg AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER p-atualiza AS INT     NO-UNDO.
                       
    FOR FIRST b-carg-rural FIELDS(cdn-sit) NO-LOCK
        WHERE b-carg-rural.num-carg = p-num-carg: END.
    IF NOT AVAIL b-carg-rural THEN
        RETURN 'NOK':U.

    IF b-carg-rural.cdn-sit = 3 THEN
        ASSIGN p-atualiza = 1.

    IF b-carg-rural.cdn-sit = 4 OR b-carg-rural.cdn-sit = 6 THEN
        ASSIGN p-atualiza = 2.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setCreateProdutAut DBOProgram 
PROCEDURE setCreateProdutAut:
/*------------------------------------------------------------------------------
  Purpose: Atualiza variavÇl responsavel pela executaá∆o do mÇtodo de criaá∆o 
           automatica dos produtores da carga.
  Parameters:  pCria - executa ou n∆o mÇtodo de criacao automatica 
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pCria AS LOG NO-UNDO.
    
    ASSIGN l-criaProdutAut = pCria.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateAfericao DBOProgram 
PROCEDURE updateAfericao :
/*------------------------------------------------------------------------------
  Purpose: Atualizar valores de afericao ap¢s pesagem    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM p-num-carga AS INT NO-UNDO.

    DEFINE VARIABLE qtd-peso-brut  AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE qtd-peso-liq   AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE qtd-peso-tara  AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE qtd-aferid     AS DECIMAL     NO-UNDO.

    FOR EACH pesagem FIELDS(val-peso-balan val-quant val-peso-aferid num-carg) NO-LOCK
       WHERE pesagem.num-carg =  p-num-carga
        BREAK BY num-carg:
      
        IF FIRST-OF(pesagem.num-carg) THEN 
            ASSIGN qtd-peso-brut = pesagem.val-peso-balan.

        ASSIGN qtd-peso-liq = qtd-peso-liq + pesagem.val-quant
               qtd-aferid   = qtd-aferid   + pesagem.val-peso-aferid.
    END.

    ASSIGN qtd-peso-tara = qtd-peso-brut - qtd-aferid .

    FIND FIRST b-carg-rural EXCLUSIVE-LOCK
         WHERE b-carg-rural.num-carg = p-num-carga NO-ERROR.

    IF AVAIL  b-carg-rural THEN DO:
        ASSIGN b-carg-rural.qtd-peso-brut  = qtd-peso-brut
               b-carg-rural.qtd-peso-tara  = qtd-peso-tara
               b-carg-rural.qtd-peso-liq   = qtd-aferid .
    END.

    RETURN 'OK':U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateDensidade DBOProgram 
PROCEDURE updateDensidade :
/*------------------------------------------------------------------------------
  Purpose: Atualiza densidade informada na tela aq0305 e recalcula valores 
           com base no peso aferido 
  Parameters:  <none>
  Notes:       
-----------------------------------------------------------------------------*/
    DEFINE INPUT PARAM p-num-carg      LIKE {&TableName}.num-carg      NO-UNDO.
    DEFINE INPUT PARAM p-val-densidade LIKE {&TableName}.val-densidade NO-UNDO.

    DEFINE VARIABLE i-qtd-div   AS INTEGER NO-UNDO.
    DEFINE VARIABLE l-fraciona  AS LOGICAL NO-UNDO.
    DEFINE VARIABLE d-diferenca AS DECIMAL NO-UNDO.
    DEFINE VARIABLE d-qtd-total AS DECIMAL NO-UNDO.

    FIND FIRST b-carg-rural EXCLUSIVE-LOCK
         WHERE b-carg-rural.num-carg = p-num-carg NO-ERROR.
    IF AVAIL b-carg-rural THEN DO:
         FOR FIRST item FIELDS(fraciona) NO-LOCK
             WHERE item.it-codigo = b-carg-rural.it-codigo:
             ASSIGN l-fraciona = item.fraciona.
         END.
         
        IF p-val-densidade = 0 THEN DO:
            {utp/ut-liter.i campo_densidade *}
            {method/svc/errors/inserr.i
                     &ErrorNumber="32017"
                     &ErrorType="EMS"
                     &ErrorParameters="return-value"} 
            RETURN "NOK":U.        
        END.
        /* Atualiza densidade informada */
        ASSIGN b-carg-rural.val-densidade = p-val-densidade.
        FOR EACH bf-pesagem EXCLUSIVE-LOCK
           WHERE bf-pesagem.num-carg = b-carg-rural.num-carg:
           
            /* Controle de valor fracionado na pesagem */
            IF l-fraciona THEN
                ASSIGN bf-pesagem.val-quant = bf-pesagem.val-peso-aferid / p-val-densidade.
            ELSE 
                ASSIGN bf-pesagem.val-quant = ROUND(bf-pesagem.val-peso-aferid / p-val-densidade, 0).

            ASSIGN i-qtd-div   = 0.
            FOR EACH bf-liber-carg NO-LOCK 
               WHERE bf-liber-carg.num-carg = bf-pesagem.num-carg
                 AND bf-liber-carg.cdn-pesagem = bf-pesagem.cdn-pesagem
                 AND bf-liber-carg.idi-autoriz-descarga < 2:
                ASSIGN i-qtd-div   = i-qtd-div + 1.
            END.         

            ASSIGN d-qtd-total = 0.
            FOR EACH bf-liber-carg EXCLUSIVE-LOCK 
               WHERE bf-liber-carg.num-carg = p-num-carg
                 AND bf-liber-carg.cdn-pesagem = bf-pesagem.cdn-pesagem
                 AND bf-liber-carg.idi-autoriz-descarga < 2:
               
                ASSIGN bf-liber-carg.val-peso-liq = bf-pesagem.val-peso-aferid / i-qtd-div.
                
                /* Controle de valor fracionado para cada liber-carg */
                IF l-fraciona THEN                
                    ASSIGN bf-liber-carg.val-quant = ROUND(bf-pesagem.val-quant / i-qtd-div,4). 
                ELSE 
                    ASSIGN bf-liber-carg.val-quant = ROUND(bf-pesagem.val-quant / i-qtd-div,0). 

                ASSIGN d-qtd-total = d-qtd-total + bf-liber-carg.val-quant.                    

            END.
    
            /*ajuste rateio das quantidades*/
            IF bf-pesagem.val-quant <> d-qtd-total THEN DO:

                FOR LAST bf-liber-carg EXCLUSIVE-LOCK 
                    WHERE bf-liber-carg.num-carg = p-num-carg
                      AND bf-liber-carg.cdn-pesagem = bf-pesagem.cdn-pesagem
                      AND bf-liber-carg.idi-autoriz-descarga < 2:

                    ASSIGN d-diferenca             = TRUNC(ROUND(bf-pesagem.val-quant - d-qtd-total,0),0)
                           bf-liber-carg.val-quant = bf-liber-carg.val-quant + d-diferenca.

                END.

            END.
            /*******************************/


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

    DEFINE VARIABLE c-msg  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-msg2 AS CHARACTER   NO-UNDO.
    
    DEFINE VARIABLE l-per-fech AS LOGICAL NO-UNDO.
    
    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/
      
    IF pType = "Create" THEN DO:
    
    
        ASSIGN l-per-fech = NO.
        RUN verificaPeriodoFechado IN THIS-PROCEDURE(INPUT RowObject.cod-estabel, INPUT RowObject.dat-trans, OUTPUT l-per-fech).    
        /*verifica se o per°odo para a carga que est† sendo criada/modificada est† fechado*/
        IF l-per-fech THEN DO:          
            {utp/ut-liter.i  Incluir/Reabrir_carga *}
            ASSIGN c-msg = RETURN-VALUE.
        
            {utp/ut-liter.i  per°odo_fechado *}
            ASSIGN c-msg2 = RETURN-VALUE.
        
            {method/svc/errors/inserr.i
                            &ErrorNumber="54818"
                            &ErrorType=EMS
                            &ErrorSubType=ERROR
                            &ErrorParameters="c-msg + '~~~~' + c-msg2"}        
        END.
  
        IF CAN-FIND(FIRST bfcarg-rural
                    WHERE bfcarg-rural.num-carg = RowObject.num-carg) THEN DO:
            {utp/ut-liter.i Carga_Rural *}
            {method/svc/errors/inserr.i
                            &ErrorNumber="1"
                            &ErrorType=EMS
                            &ErrorSubType=ERROR
                            &ErrorParameters="return-value"}
            RETURN "NOK":U.                    
        END.

    END.
    
    IF CAN-FIND(FIRST bfcarg-rural
                WHERE bfcarg-rural.cod-carga = RowObject.cod-carga
                  AND bfcarg-rural.num-carg <> RowObject.num-carg) THEN DO:
        {utp/ut-liter.i C¢digo_da_carga *}
        {method/svc/errors/inserr.i
                        &ErrorNumber="31717"
                        &ErrorType=EMS
                        &ErrorSubType=ERROR
                        &ErrorParameters="return-value"}
        RETURN "NOK":U.                    
     END.     
    
    
    IF RowObject.dat-trans = ? THEN DO:
        {utp/ut-liter.i Data_Transaá∆o *}
        {method/svc/errors/inserr.i
                 &ErrorNumber="173"
                 &ErrorType="EMS"
                 &ErrorParameters="return-value"} 
    END.
    ELSE DO:
        IF RowObject.dat-trans > TODAY THEN DO:         
            {method/svc/errors/inserr.i
                     &ErrorNumber="54724"
                     &ErrorType="EMS"
                     &ErrorParameters="return-value"}    
        END.
    END.

    IF RowObject.cod-placa = "" THEN DO:
        {utp/ut-liter.i Placa *}
        {method/svc/errors/inserr.i
                 &ErrorNumber="164"
                 &ErrorType="EMS"
                 &ErrorParameters="return-value"} 
    END.
    ELSE IF RowObject.cod-inter-veic = "" THEN DO:
        {utp/ut-liter.i Veiculo *}
        {method/svc/errors/inserr.i
                 &ErrorNumber="164"
                 &ErrorType="EMS"
                 &ErrorParameters="return-value"} 
    END.
    ELSE IF RowObject.cod-uf = "" THEN DO:  
        {method/svc/errors/inserr.i
                 &ErrorNumber="54754"
                 &ErrorType="EMS"
                 &ErrorParameters=" "} 
    END.
    ELSE 
        IF NOT CAN-FIND(FIRST transpdor-veic 
                        WHERE transpdor-veic.cod-transp = RowObject.cod-transp
                          AND transpdor-veic.cod-placa  = RowObject.cod-placa) THEN DO:
            ASSIGN c-msg = RowObject.cod-placa + "~~" + STRING(RowObject.cod-transp).
            {method/svc/errors/inserr.i 
                     &ErrorNumber="54685" /* Veiculo nao cadastrado para o transportador */
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="c-msg"} 
        END.                       
    
    
   IF RowObject.qti-comptmento = 0
    OR RowObject.qti-comptmento = ? THEN DO:
        {utp/ut-liter.i Compartimento *}
         {method/svc/errors/inserr.i 
                     &ErrorNumber="36"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="return-value"} 
    END.

    IF RowObject.nom-motorista = ''
    OR RowObject.nom-motorista = ? THEN DO:
        {utp/ut-liter.i Nome_motorista *}
         {method/svc/errors/inserr.i 
                     &ErrorNumber="164"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="return-value"} 
    END.

    IF RowObject.val-hodom-inicial = 0
    OR RowObject.val-hodom-inicial = ? THEN DO:
        {utp/ut-liter.i Km_Inicial *}
        {method/svc/errors/inserr.i 
                     &ErrorNumber="265"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="return-value"} 
        RETURN "NOK":U.            
    END.
    ELSE IF RowObject.val-hodom-final = 0
         OR RowObject.val-hodom-final = ? THEN DO:

        {utp/ut-liter.i Km_final *}
        {method/svc/errors/inserr.i 
                     &ErrorNumber="265"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="return-value"} 
        RETURN "NOK":U.
    END.
    ELSE IF RowObject.val-hodom-final <  RowObject.val-hodom-inicial THEN DO: 

        {utp/ut-liter.i Km_final *}
        ASSIGN c-msg = RETURN-VALUE.
        {utp/ut-liter.i Km_inicial *}
        ASSIGN c-msg = c-msg + "~~" + RETURN-VALUE.
        {method/svc/errors/inserr.i 
                     &ErrorNumber="1207"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="c-msg"} 
    END.
    
    FOR FIRST bf-item FIELDS(tipo-contr tipo-con-est) NO-LOCK
        WHERE bf-item.it-codigo = RowObject.it-codigo: END.
    
    IF NOT AVAIL bf-item THEN DO:
        {utp/ut-table.i mgind item 1}
        {method/svc/errors/inserr.i 
                 &ErrorNumber="56"
                 &ErrorType="EMS"
                 &ErrorSubType="ERROR"
                 &ErrorParameters="return-value"} 
    END.
    ELSE DO:
        IF NOT CAN-FIND(FIRST item-estab-rural
                        WHERE item-estab-rural.it-codigo   = RowObject.it-codigo
                          AND item-estab-rural.cod-estabel = RowObject.cod-estabel) THEN DO:

            {utp/ut-table.i mgind item-estab-rural 1}
            {method/svc/errors/inserr.i 
                     &ErrorNumber="56"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="return-value"} 
        END.
        ELSE DO:
            IF bf-item.tipo-contr <> 2 THEN DO: /* CONTROLE TOTAL*/
                {method/svc/errors/inserr.i 
                         &ErrorNumber="15309"
                         &ErrorType="EMS"
                         &ErrorSubType="ERROR"
                         &ErrorParameters="return-value"}  
            END.
        END.
    
        IF bf-item.tipo-con-est = 4 THEN DO: /*REFERENCIA*/    
            IF RowObject.cod-refer = "" THEN DO:
                {utp/ut-liter.i C¢digo_Referància *}
                    {method/svc/errors/inserr.i
                             &ErrorNumber="164"
                             &ErrorType="EMS"
                             &ErrorParameters="return-value"}     
            END.
            ELSE DO:
                IF NOT CAN-FIND(FIRST ref-item
                                WHERE ref-item.cod-refer = RowObject.cod-refer
                                  AND ref-item.it-codigo = RowObject.it-codigo) THEN DO:
                    {method/svc/errors/inserr.i 
                             &ErrorNumber="529"
                             &ErrorType="EMS"
                             &ErrorSubType="ERROR"
                             &ErrorParameters="RowObject.cod-refer"}
                END.    
            END.  
        END.
        
        IF bf-item.tipo-con-est = 2 THEN DO: /*NUMERO DE SERIE */   
             {method/svc/errors/inserr.i 
                             &ErrorNumber="54749"
                             &ErrorType="EMS"
                             &ErrorSubType="ERROR"
                             &ErrorParameters="RowObject.cod-refer"}
        END.
        
    END. /* find bf-item */
    
    IF RowObject.cod-rota = "" THEN DO:
        {utp/ut-liter.i Rota *}
        {method/svc/errors/inserr.i 
                 &ErrorNumber="3145"
                 &ErrorType="EMS"
                 &ErrorSubType="ERROR"
                 &ErrorParameters="RETURN-VALUE"}
    END.
    ELSE DO: 
        IF NOT CAN-FIND(FIRST rota-coleta 
                        WHERE rota-coleta.cod-rota = RowObject.cod-rota) THEN DO:
            {utp/ut-table.i mgind rota-coleta 1}
            {method/svc/errors/inserr.i 
                     &ErrorNumber="56"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="return-value"}
        END.   
    END.    
    
    IF pType = "Delete" THEN DO:
    
        IF RowObject.cdn-sit > 3 THEN DO:         
            {method/svc/errors/inserr.i
                     &ErrorNumber="54601"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters=" "} 
        END.        
    END.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaEncerramentoCarga DBOProgram 
PROCEDURE validaEncerramentoCarga :
/*:T------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao Encerramento da Carga
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pi-num-carg AS INTEGER NO-UNDO.
    
    DEFINE VARIABLE c-txt         AS CHARACTER          NO-UNDO.
    DEFINE VARIABLE cargaLiberada AS LOGICAL INITIAL NO NO-UNDO.

    blk_carga:
    FOR EACH bf-liber-carg FIELDS(num-carg cdn-compart val-quant) NO-LOCK
       WHERE bf-liber-carg.num-carg = pi-num-carg:

      IF bf-liber-carg.val-quant > 0 THEN DO:
        IF CAN-FIND(FIRST bfProdutCarg 
                    WHERE bfProdutCarg.num-carg    = bf-liber-carg.num-carg
                      AND bfProdutCarg.cdn-compart = bf-liber-carg.cdn-compart
                      AND bfProdutCarg.qtd-coleta  > 0) THEN DO:
            ASSIGN cargaLiberada = YES.
            LEAVE blk_carga.
        END.
      END.
    END.

    IF NOT cargaLiberada THEN DO:
      {method/svc/errors/inserr.i 
                      &ErrorNumber="54761"
                      &ErrorType="EMS"
                      &ErrorSubType="ERROR"
                      &ErrorParameters= pi-num-carg}
      RETURN "NOK":U. 
    END.
    
    FOR EACH bfProdutCarg FIELDS(qtd-coleta cdn-motiv-nao-coleta cdn-compart cod-pto-coleta cdn-repos) NO-LOCK
       WHERE bfProdutCarg.num-carg         = pi-num-carg
         AND bfProdutCarg.cdn-produt-rural = bfProdutCarg.cdn-produt-respons: 
         
        IF  bfProdutCarg.qtd-coleta = 0 
        AND bfProdutCarg.cdn-motiv-nao-coleta = 0 
        AND bfProdutCarg.cdn-compart = 0 THEN DO:
            ASSIGN c-txt =  bfProdutCarg.cod-pto-coleta + "~~" + STRING(bfProdutCarg.cdn-repos).
            {method/svc/errors/inserr.i 
                     &ErrorNumber="54849"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="c-txt"}
        END.
    END.  
   
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.    
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaPeriodoFechado DBOProgram 
PROCEDURE verificaPeriodoFechado :
/*:T------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes a Reabertura da Carga
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-cod-estabel LIKE RowObject.cod-estabel NO-UNDO.
    DEFINE INPUT  PARAMETER p-dat-trans   LIKE RowObject.dat-trans   NO-UNDO.
    DEFINE OUTPUT PARAMETER p-per-fech    AS   LOGICAL               NO-UNDO.
    
    ASSIGN p-per-fech = NO.    
    FOR FIRST param-aquis-rural FIELDS(cod-estabel cod-periodo)
        WHERE param-aquis-rural.cod-estabel = p-cod-estabel:
        IF  INT(SUBSTRING(param-aquis-rural.cod-periodo,1,2)) >= INT(STRING(MONTH(p-dat-trans)))
        AND INT(SUBSTRING(param-aquis-rural.cod-periodo,3,4)) >= INT(STRING(YEAR(p-dat-trans))) THEN
            ASSIGN p-per-fech = YES.        
    END.    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
