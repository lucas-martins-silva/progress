&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME

{include/i-prgvrs.i BOIN00965 2.00.00.037 } /*** "010037" 17/06/2025 16:40:41 ***/

/* Connected Databases 
          emsfnd           PROGRESS
          movind            PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-alter-produt-carg NO-UNDO LIKE alter-produt-carg
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-produt-carg NO-UNDO LIKE produt-carg
       FIELD r-rowid AS ROWID.
DEFINE TEMP-TABLE ttProdutCargAux NO-UNDO LIKE produt-carg
       FIELD r-rowid AS ROWID.
DEFINE TEMP-TABLE ttProdutCargCol NO-UNDO LIKE produt-carg
       FIELD cod-rota AS CHAR
       FIELD r-rowid AS ROWID
       .

/*temp-table usada para mÇtodo que retorna fornecedores por ponto coleta para o EMS 5*/
def temp-table tt_fornecedor_pto_coleta no-undo
    field tta_cod_prop_rural               as character format "x(16)" label "Propriedade Rural" column-label "Prop Rural"
    field tta_cod_pto_coleta               as character format "x(12)" label "Ponto Coleta" column-label "Pto Coleta"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_nom_abrev                    as character format "x(15)" label "Nome Abreviado" column-label "Nome Abreviado"
    field ttv_log_respons                  as logical format "Sim/N„o" initial no
    field ttv_qtd_coleta                   as decimal format ">>>>,>>>,>>9.9999" decimals 4
    field ttv_qtd_percent_coleta           as decimal format ">>9.99" decimals 2 label "Percentual" column-label "Percentual"
    field ttv_val_valor                    as decimal format "->>,>>>,>>>,>>9.99" decimals 2 label "Valor" column-label "Valor"
    field ttv_val_quantidade               as decimal format "->>>>,>>>,>>9.9999" decimals 4 label "Quantidade" column-label "Qtdade"
    field tta_num_id_movto_conven          as integer format "999999999" initial 0 label "ID Movto ConvÍnio" column-label "ID Movto"
    .


/*temp-table usada para mÇtodo que retorna quantidade de coleta por fornecedor por dia para o EMS 5*/
def temp-table tt_fornec_produt_vol no-undo
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field ttv_num_dias                     as integer format ">>>>,>>9" label "N£mero de Dias" column-label "N£mero de Dias"
    field ttv_qtd_volume                   as decimal format "->>>>,>>9.9999" decimals 4 label "Volume" column-label "Volume"
    index tt_fornec_idx                    is primary
          tta_cdn_fornecedor               ascending
    .
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin00965 MAQ}
&ENDIF

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
&GLOBAL-DEFINE DBOName BOIN00965
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName produt-carg
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
{inbo/boin00965.i RowObject}

DEFINE VARIABLE i-num-carg    AS INTEGER NO-UNDO.
DEFINE VARIABLE i-produt-resp AS INTEGER NO-UNDO.
DEFINE VARIABLE c-pto-coleta  AS CHARACTER NO-UNDO.
DEFINE VARIABLE i-cdn-compart AS INTEGER NO-UNDO.
DEFINE VARIABLE i-cdn-repos   AS INTEGER NO-UNDO.
DEFINE VARIABLE v_num_dat_aux AS INTEGER NO-UNDO.


DEFINE VARIABLE iNumCarg      AS INTEGER NO-UNDO.
DEFINE VARIABLE cCodPtoColeta AS CHARACTER NO-UNDO.
DEFINE VARIABLE iCdnCompart   AS INTEGER NO-UNDO.
DEFINE VARIABLE dQtdColeta    AS DECIMAL NO-UNDO.
DEFINE VARIABLE dQtdColetiva  AS DECIMAL NO-UNDO.
DEFINE VARIABLE iCdnRepos     AS INTEGER NO-UNDO.

DEFINE VARIABLE c-texto       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iProdutResposns AS INTEGER NO-UNDO.

DEFINE VARIABLE lCreateAut   AS LOGICAL     NO-UNDO.

/*fechamento do per°odo*/
DEFINE VARIABLE c-fechto-estabel        LIKE produt-carg.cod-estabel      NO-UNDO.
DEFINE VARIABLE da-fechto-trans         LIKE produt-carg.dat-trans        NO-UNDO.
DEFINE VARIABLE cdn-fechto-produt-rural LIKE produt-carg.cdn-produt-rural NO-UNDO.
DEFINE VARIABLE c-fechto-it-codigo      LIKE produt-carg.it-codigo        NO-UNDO.

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName}       FOR {&TableName}.
DEFINE BUFFER bfProdutCarg         FOR {&TableName}.
DEFINE BUFFER bfProdutPtoColeta    FOR produt-pto-coleta.
DEFINE BUFFER bf-produt-pto-coleta FOR produt-pto-coleta. 
DEFINE BUFFER bfCargRural          FOR carg-rural.
{utp/ut-glob.i}

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
   Temp-Tables and Buffers:
      TABLE: tt-alter-produt-carg T "?" NO-UNDO movind alter-produt-carg
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-produt-carg T "?" NO-UNDO movind produt-carg
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttProdutCargAux T "?" NO-UNDO movind produt-carg
      ADDITIONAL-FIELDS:
          FIELD r-rowid AS ROWID
      END-FIELDS.
      TABLE: ttProdutCargCol T "?" NO-UNDO movind produt-carg
      ADDITIONAL-FIELDS:
          FIELD cod-rota AS CHAR
          FIELD r-rowid AS ROWID
          
      END-FIELDS.
   END-TABLES.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram 
PROCEDURE afterCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN create-alter-produt-carg IN THIS-PROCEDURE.
    
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

    /*como deleá∆o impacta no preáo, foráa rodar apuraá∆o novamente*/
    DEFINE VARIABLE c-period     AS   CHARACTER                       NO-UNDO.
    DEFINE VARIABLE c-cod-period LIKE fechto-produt-period.cod-period NO-UNDO.
    DEFINE VARIABLE da-dat-ini   LIKE RowObject.dat-trans             NO-UNDO.
    DEFINE VARIABLE da-dat-fim   LIKE RowObject.dat-trans             NO-UNDO.

    ASSIGN c-cod-period = IF MONTH(da-fechto-trans) < 10
                              THEN "0" + STRING(MONTH(da-fechto-trans)) + STRING(YEAR(da-fechto-trans))
                              ELSE       STRING(MONTH(da-fechto-trans)) + STRING(YEAR(da-fechto-trans)) 
           c-period     = IF MONTH(da-fechto-trans) < 10
                             THEN "0" + STRING(MONTH(da-fechto-trans)) + String("/") + STRING(YEAR(da-fechto-trans))
                             ELSE STRING(MONTH(da-fechto-trans)) + String("/") + STRING(YEAR(da-fechto-trans))
           da-dat-ini   = DATE("01/" + c-period)
           da-dat-fim   = IF INT(SUBSTRING(c-period,1,2)) < 12 
                              THEN DATE("01/" + STRING(MONTH(da-dat-ini) + 1) + "/" + STRING(YEAR(da-dat-ini))) - 1 /* ˙ltimo dia do mÍs */
                              ELSE DATE("31/" +         "12"                  + "/" + STRING(YEAR(da-dat-ini))).    /* digitado em tela  */
    
    /*foráa rodar apuraá∆o novamente para o produtor que teve carga deletada*/
    FOR FIRST produt-carg EXCLUSIVE-LOCK
        WHERE produt-carg.cod-estabel      = c-fechto-estabel 
          AND produt-carg.cdn-produt-rural = cdn-fechto-produt-rural
          AND produt-carg.dat-trans       >= da-dat-ini
          AND produt-carg.dat-trans       <= da-dat-fim:

        ASSIGN produt-carg.log-livre-1 = FALSE.

    END.
    /*caso n∆o encontre produt-carg produtor n∆o tem mais nenhuma carga no per°odo, deletar poss°veis fechto's*/
    IF NOT AVAIL produt-carg THEN DO:

        FOR EACH fechto-produt-period EXCLUSIVE-LOCK
            WHERE fechto-produt-period.cod-period       = c-cod-period
              AND fechto-produt-period.cod-estabel      = c-fechto-estabel
              AND fechto-produt-period.cdn-produt-rural = cdn-fechto-produt-rural
              AND fechto-produt-period.it-codigo        = c-fechto-it-codigo:

            DELETE fechto-produt-period.

        END.

    END.
    /************************************************************************/
    
    /* SOMENTE ELIMINA PRODUTORES COLETIVOS SE FOR A ELIMINA«√O DO PRODUTOR RESPONSAVEL */ 
    IF RowObject.cdn-produt-respons = RowObject.cdn-produt-rural THEN 
        RUN deleteProdutCargAut IN THIS-PROCEDURE(INPUT RowObject.num-carg,
                                                  INPUT RowObject.cod-pto-coleta,
                                                  INPUT RowObject.cdn-produt-respons, 
                                                  INPUT RowObject.cdn-compart, 
                                                  INPUT RowObject.cdn-repos,
                                                  INPUT RowObject.cod-propried,
                                                  INPUT NO).
                                              
    RUN create-alter-produt-carg IN THIS-PROCEDURE.
    
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
    RUN create-alter-produt-carg IN THIS-PROCEDURE.
    
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

    /* caso n„o tenha sido informado, salva a propriedade do relacionamento produtor/pto_coleta */
    IF RowObject.cod-propried = "" THEN DO:     
        FOR FIRST bfProdutPtoColeta FIELDS(cod-propried) NO-LOCK
            WHERE bfProdutPtoColeta.cod-pto-coleta   = RowObject.cod-pto-coleta
              AND bfProdutPtoColeta.cdn-produt-rural = RowObject.cdn-produt-rural:              
            ASSIGN RowObject.cod-propried = bfProdutPtoColeta.cod-propried.
        END. 
    END.
    
    
    FOR FIRST carg-rural FIELDS(cdn-sit) NO-LOCK
        WHERE carg-rural.num-carg = RowObject.num-carg:    
        IF carg-rural.cdn-sit = 6 THEN /* REABERTA */
            RUN create-tt-alter-produt-carg IN THIS-PROCEDURE(INPUT 'ADD':U).
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDeleteRecord DBOProgram 
PROCEDURE beforeDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    ASSIGN c-fechto-estabel        = RowObject.cod-estabel     
           da-fechto-trans         = RowObject.dat-trans       
           cdn-fechto-produt-rural = RowObject.cdn-produt-rural
           c-fechto-it-codigo      = RowObject.it-codigo.
           
    FOR FIRST carg-rural FIELDS(cdn-sit) NO-LOCK
        WHERE carg-rural.num-carg = RowObject.num-carg:    
        IF carg-rural.cdn-sit = 6 THEN /* REABERTA */            
            RUN create-tt-alter-produt-carg IN THIS-PROCEDURE(INPUT 'DELETE':U).
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
    DEFINE VARIABLE c-diferencas AS CHARACTER          NO-UNDO.
    DEFINE VARIABLE i            AS INTEGER            NO-UNDO.
    DEFINE VARIABLE c-txt        AS CHARACTER EXTENT 2 NO-UNDO.

    DEFINE VARIABLE qh AS HANDLE EXTENT 2 NO-UNDO.
    DEFINE VARIABLE bh AS HANDLE EXTENT 2 NO-UNDO.

    {utp/ut-liter.i DE * }
    ASSIGN c-txt[1] = RETURN-VALUE.
    {utp/ut-liter.i PARA * }
    ASSIGN c-txt[2] = RETURN-VALUE.

    CREATE BUFFER bh[1] FOR TABLE "produt-carg":U.
    CREATE BUFFER bh[2] FOR TABLE "RowObject":U.

    CREATE QUERY qh[1].
    CREATE QUERY qh[2].

    qh[1]:SET-BUFFERS(bh[1]).
    qh[2]:SET-BUFFERS(bh[2]).

    qh[1]:QUERY-PREPARE("FOR EACH produt-carg WHERE produt-carg.cdn-identif = " + STRING(RowObject.cdn-identif)).
    qh[2]:QUERY-PREPARE("FOR EACH RowObject").
     
    qh[1]:QUERY-OPEN().
    qh[2]:QUERY-OPEN(). 

    qh[1]:GET-NEXT().
    qh[2]:GET-NEXT().

    IF qh[1]:NUM-RESULTS = 1 AND qh[2]:NUM-RESULTS = 1 THEN DO:
        FOR FIRST carg-rural WHERE carg-rural.num-carg = int(bh[2]:BUFFER-FIELD('num-carg'):BUFFER-VALUE)  NO-LOCK:

            IF carg-rural.cdn-sit = 6 THEN DO: /* carga reaberta */
                FOR FIRST bfProdutCarg 
                    WHERE bfProdutCarg.cdn-identif = RowObject.cdn-identif NO-LOCK:

                    BUFFER-COMPARE bfProdutCarg TO RowObject SAVE RESULT IN c-diferencas.
                   
                    IF c-diferencas <> "" THEN DO:
                         EMPTY TEMP-TABLE tt-alter-produt-carg NO-ERROR.
                         DO i = 1 TO NUM-ENTRIES(c-diferencas):

                            CREATE tt-alter-produt-carg.
                            ASSIGN tt-alter-produt-carg.cdn-identif = RowObject.cdn-identif
                                   tt-alter-produt-carg.dat-alter   = TODAY
                                   tt-alter-produt-carg.hora-alter  = STRING(TIME,"HH:MM:SS")
                                   tt-alter-produt-carg.cod-usuar   = c-seg-usuario
                                   tt-alter-produt-carg.cod-campo   = ENTRY(i, c-diferencas, ",")
                                   tt-alter-produt-carg.conteudo    = c-txt[1] + " => " + STRING(bh[1]:BUFFER-FIELD(string(ENTRY(i, c-diferencas, ","))):BUFFER-VALUE) + ' ' +
                                                                      c-txt[2] + " => " + STRING(bh[2]:BUFFER-FIELD(string(ENTRY(i, c-diferencas, ","))):BUFFER-VALUE)
                                   tt-alter-produt-carg.des-motivo  = c-texto
                                   tt-alter-produt-carg.num-carg    = RowObject.num-carg.
                         END.
                    END.

                END.
            END.

        END.
    END.   
    
    IF RowObject.cod-propried = "" THEN DO:        
        FOR FIRST bfProdutPtoColeta FIELDS(cod-propried) NO-LOCK
            WHERE bfProdutPtoColeta.cod-pto-coleta   = RowObject.cod-pto-coleta
              AND bfProdutPtoColeta.cdn-produt-rural = RowObject.cdn-produt-rural:
            ASSIGN RowObject.cod-propried =  bfProdutPtoColeta.cod-propried.
        END. 
    END.    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE create-alter-produt-carg DBOProgram 
PROCEDURE create-alter-produt-carg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE h-boin00967 AS HANDLE      NO-UNDO.

    RUN inbo/boin00967.p PERSISTENT SET h-boin00967.
    RUN openQueryStatic IN h-boin00967(INPUT 'Main':U).

    /*busca alteraá‰es que impactem no preáo e foráa a rodar apuraá∆o novamente*/
    FOR EACH tt-alter-produt-carg 
        WHERE tt-alter-produt-carg.cod-campo = "qtd-coleta"
           OR tt-alter-produt-carg.cod-campo = "cod-pto-coleta"
           OR tt-alter-produt-carg.cod-campo = "cdn-produt-rural":


        FOR FIRST produt-carg EXCLUSIVE-LOCK
                WHERE produt-carg.cdn-identif = tt-alter-produt-carg.cdn-identif:
            
            ASSIGN produt-carg.log-livre-1 = FALSE.
    
        END.

    END.
    /***************************************************************************/

    RUN crateAlterProdutCarg IN h-boin00967(INPUT TABLE tt-alter-produt-carg).

    DELETE PROCEDURE h-boin00967.
    ASSIGN h-boin00967 = ?.

    RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE create-tt-alter-produt-carg DBOProgram 
PROCEDURE create-tt-alter-produt-carg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER c-cod-campo AS CHARACTER NO-UNDO.
                        
    EMPTY TEMP-TABLE tt-alter-produt-carg NO-ERROR.
    
    CREATE tt-alter-produt-carg.
    ASSIGN tt-alter-produt-carg.cdn-identif = RowObject.cdn-identif
           tt-alter-produt-carg.dat-alter   = TODAY
           tt-alter-produt-carg.hora-alter  = STRING(TIME,"HH:MM:SS")
           tt-alter-produt-carg.cod-usuar   = c-seg-usuario
           tt-alter-produt-carg.cod-campo   = c-cod-campo
           tt-alter-produt-carg.conteudo    = "Produtor => " + '' + STRING(RowObject.cdn-produt-rural) + ' ' + "QTD => " + STRING(RowObject.qtd-coleta)
           tt-alter-produt-carg.des-motivo  = c-texto
           tt-alter-produt-carg.num-carg    = RowObject.num-carg.
           
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizarObservacao DBOProgram 
PROCEDURE atualizarObservacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER i-cdn-identif AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER c-texto       AS CHARACTER NO-UNDO.
    
    FIND FIRST bfProdutCarg EXCLUSIVE-LOCK
         WHERE bfProdutCarg.cdn-identif = i-cdn-identif NO-ERROR.
         
    IF NOT AVAIL bfProdutCarg THEN RETURN 'NOK':U.
         
    ASSIGN bfProdutCarg.des-obs = c-texto.

    RETURN 'OK':U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaCamposColetivos DBOProgram 
PROCEDURE atualizaCamposColetivos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER TABLE FOR ttProdutCargAux. 
    
    RUN openQueryMain IN THIS-PROCEDURE.    
    FOR EACH ttProdutCargAux:     
        FOR EACH bfProdutCarg no-lock 
           WHERE bfProdutCarg.num-carg           = ttProdutCargAux.num-carg 
             AND bfProdutCarg.cdn-produt-respons = ttProdutCargAux.cdn-produt-respons
             AND bfProdutCarg.cdn-repos          = ttProdutCargAux.cdn-repos
             AND bfProdutCarg.cod-pto-coleta     = ttProdutCargAux.cod-pto-coleta:
             
            EMPTY TEMP-TABLE tt-produt-carg NO-ERROR.
            CREATE tt-produt-carg.
            BUFFER-COPY bfProdutCarg to tt-produt-carg.
            ASSIGN tt-produt-carg.cod-amostra  = ttProdutCargAux.cod-amostra 
                   tt-produt-carg.val-temperat = ttProdutCargAux.val-temperat
                   tt-produt-carg.cod-lacre    = ttProdutCargAux.cod-lacre   
                   tt-produt-carg.cdn-compart  = ttProdutCargAux.cdn-compart.
                   
            FIND FIRST tt-produt-carg NO-ERROR.
            RUN goToKey IN THIS-PROCEDURE (INPUT tt-produt-carg.cdn-identif) NO-ERROR.
            RUN setRecord      IN THIS-PROCEDURE (INPUT TABLE tt-produt-carg).
            RUN emptyRowErrors IN THIS-PROCEDURE.
            RUN updateRecord   IN THIS-PROCEDURE. 
        END.
    END.
    
    RETURN 'OK':U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME





&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createProdutCargAut DBOProgram 
PROCEDURE createProdutCargAut :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cod-estabel AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-num-carg    AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER p-dat-trans   AS DATE      NO-UNDO.
    DEFINE INPUT PARAMETER p-it-codigo   AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-cdn-compart AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-rota    AS CHARACTER NO-UNDO.    
    DEFINE INPUT PARAMETER p-cdn-sit     AS INTEGER   NO-UNDO.    
    
    DEFINE VARIABLE iProdutResposns AS INTEGER NO-UNDO.

    FIND FIRST rota-coleta NO-LOCK
         WHERE rota-coleta.cod-rota = p-cod-rota NO-ERROR.
         
    IF NOT AVAILABLE rota-coleta THEN RETURN "NOK":U.

    RUN openQueryMain IN THIS-PROCEDURE.
    
    ASSIGN lCreateAut = YES.    
    FOR EACH pto-rota-coleta FIELDS(cod-pto-coleta) NO-LOCK
       WHERE pto-rota-coleta.cod-rota = rota-coleta.cod-rota
          BY pto-rota-coleta.cdn-seq:      

        FOR FIRST pto-coleta FIELDS(cod-pto-coleta cod-propried) NO-LOCK
            WHERE pto-coleta.cod-pto-coleta = pto-rota-coleta.cod-pto-coleta: END.
            
        IF NOT AVAILABLE pto-coleta THEN NEXT.

        FOR FIRST bf-produt-pto-coleta FIELDS(cdn-produt-rural) NO-LOCK
            WHERE bf-produt-pto-coleta.cod-pto-coleta = pto-coleta.cod-pto-coleta
              AND bf-produt-pto-coleta.cod-propried   = pto-coleta.cod-propried
              AND bf-produt-pto-coleta.log-respons: END.

        IF NOT AVAIL bf-produt-pto-coleta THEN NEXT.

        IF CAN-FIND(FIRST produt-rural
                    WHERE produt-rural.cdn-produt-rural = bf-produt-pto-coleta.cdn-produt-rural
                    AND   produt-rural.log-livre-1 = NO) THEN NEXT.
            
        ASSIGN iProdutResposns = IF AVAIL bf-produt-pto-coleta THEN bf-produt-pto-coleta.cdn-produt-rural ELSE ?.
        
        FOR EACH bf-produt-pto-coleta FIELDS(cod-pto-coleta cdn-produt-rural cod-propried log-livre-1) NO-LOCK
           WHERE bf-produt-pto-coleta.cod-pto-coleta    = pto-coleta.cod-pto-coleta
           AND   bf-produt-pto-coleta.log-livre-1       = YES:

            /* Relacionamentos Inativos*/
            IF NOT bf-produt-pto-coleta.log-livre-1 THEN 
              NEXT.

            IF CAN-FIND(FIRST propried-rural
                        WHERE propried-rural.cod-propried = bf-produt-pto-coleta.cod-propried 
                        AND   propried-rural.log-livre-1  = NO) THEN NEXT.

            FOR EACH reposit FIELDS(cdn-repos) NO-LOCK
               WHERE reposit.cod-pto-coleta = pto-coleta.cod-pto-coleta
                AND  reposit.log-livre-1    = YES:

                FIND FIRST produt-carg NO-LOCK 
                     WHERE produt-carg.num-carg         = p-num-carg
                       AND produt-carg.cod-pto-coleta   = bf-produt-pto-coleta.cod-pto-coleta
                       AND produt-carg.cdn-produt-rural = bf-produt-pto-coleta.cdn-produt-rural
                       AND produt-carg.cod-propried     = bf-produt-pto-coleta.cod-propried
                       AND produt-carg.cdn-compart      = p-cdn-compart
                       AND produt-carg.cdn-repos        = reposit.cdn-repos no-error.

                IF AVAIL produt-carg THEN 
                    NEXT.

                EMPTY TEMP-TABLE ttProdutCargAux NO-ERROR.
                CREATE ttProdutCargAux.
                RUN getCreateSequence IN THIS-PROCEDURE (OUTPUT ttProdutCargAux.cdn-identif).
               
                ASSIGN ttProdutCargAux.num-carg           = p-num-carg
                       ttProdutCargAux.cod-estabel        = p-cod-estabel 
                       ttProdutCargAux.cod-pto-coleta     = pto-coleta.cod-pto-coleta
                       ttProdutCargAux.cod-propried       = bf-produt-pto-coleta.cod-propried 
                       ttProdutCargAux.dat-trans          = p-dat-trans
                       ttProdutCargAux.it-codigo          = p-it-codigo                   
                       ttProdutCargAux.cdn-compart        = p-cdn-compart               
                       ttProdutCargAux.cdn-produt-respons = iProdutResposns
                       ttProdutCargAux.cdn-produt-rural   = bf-produt-pto-coleta.cdn-produt-rural
                       ttProdutCargAux.cdn-repos          = reposit.cdn-repos
                       ttProdutCargAux.cdn-sit            = 1.
                       
                IF p-cdn-sit > 0 THEN 
                    ASSIGN ttProdutCargAux.cdn-sit = p-cdn-sit.
                 
                RUN setRecord      IN THIS-PROCEDURE (INPUT TABLE ttProdutCargAux).
                RUN emptyRowErrors IN THIS-PROCEDURE.
                RUN createRecord   IN THIS-PROCEDURE.
            END.
        END.
        
    END.
    
    ASSIGN lCreateAut = NO.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createProdutCargNaoColeta DBOProgram 
PROCEDURE createProdutCargNaoColeta :
/*------------------------------------------------------------------------------
  Purpose: Criar produtor nao coletado para carga    
  Parameters:  <none>
  Notes:      
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER TABLE FOR ttProdutCargCol.
    DEFINE OUTPUT PARAMETER pi-identif-repos AS INTEGER NO-UNDO.
    DEFINE VARIABLE l-erro AS LOGICAL NO-UNDO.   
    
    FOR FIRST ttProdutCargCol:    
        FOR FIRST produt-pto-coleta NO-LOCK
            WHERE produt-pto-coleta.cod-pto-coleta = ttProdutCargCol.cod-pto-coleta
              AND produt-pto-coleta.log-respons:
              
            EMPTY TEMP-TABLE ttProdutCargAux NO-ERROR.        
            CREATE ttProdutCargAux.
            RUN getCreateSequence IN THIS-PROCEDURE (OUTPUT ttProdutCargAux.cdn-identif).
            ASSIGN ttProdutCargAux.num-carg             = ttProdutCargCol.num-carg
                   ttProdutCargAux.cod-estabel          = ttProdutCargCol.cod-estabel 
                   ttProdutCargAux.cod-pto-coleta       = ttProdutCargCol.cod-pto-coleta
                   ttProdutCargAux.dat-trans            = ttProdutCargCol.dat-trans
                   ttProdutCargAux.it-codigo            = ttProdutCargCol.it-codigo
                   ttProdutCargAux.cdn-compart          = ttProdutCargCol.cdn-compart
                   ttProdutCargAux.cdn-produt-respons   = produt-pto-coleta.cdn-produt-rural
                   ttProdutCargAux.cdn-produt-rural     = produt-pto-coleta.cdn-produt-rural
                   ttProdutCargAux.cod-propried         = produt-pto-coleta.cod-propried
                   ttProdutCargAux.cdn-sit              = 1
                   ttProdutCargAux.cdn-motiv-nao-coleta = ttProdutCargCol.cdn-motiv-nao-coleta
                   ttProdutCargAux.idi-nao-coleta       = 1
                   ttProdutCargAux.cdn-repos            =  ttProdutCargCol.cdn-repos
                   ttProdutCargAux.des-obs              =  ttProdutCargCol.des-obs.

            RUN setRecord      IN THIS-PROCEDURE (INPUT TABLE ttProdutCargAux).
            RUN emptyRowErrors IN THIS-PROCEDURE.               
            RUN validateMotivoNaoColeta IN THIS-PROCEDURE.
            ASSIGN l-erro = RETURN-VALUE <> "OK".               
            
            IF NOT l-erro THEN DO:               
                RUN createRecord   IN THIS-PROCEDURE.
                ASSIGN l-erro = RETURN-VALUE <> "OK".                 
            END.    
        END. 
    END.
    
    IF l-erro THEN 
        UNDO, LEAVE.    

    RETURN 'OK':U.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateProdutCargNaoColeta DBOProgram 
PROCEDURE updateProdutCargNaoColeta :
/*------------------------------------------------------------------------------
  Purpose: Atualizar produtor nao coletado para carga    
  Parameters:  <none>
  Notes:      
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-num-carg             AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-pto-coleta       AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-cdn-produt-respons   AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER p-cdn-compart          AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER p-cdn-repos            AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER p-cdn-motiv-nao-coleta AS INTEGER   NO-UNDO.   
    
    DEFINE VARIABLE l-erro AS LOGICAL NO-UNDO.    
    blockColetivo:
    FOR EACH bfProdutCarg EXCLUSIVE-LOCK
       WHERE bfProdutCarg.num-carg           = p-num-carg       
         AND bfProdutCarg.cod-pto-coleta     = p-cod-pto-coleta
         AND bfProdutCarg.cdn-produt-respons = p-cdn-produt-respons
         AND bfProdutCarg.cdn-compart        = p-cdn-compart
         AND bfProdutCarg.cdn-repos          = p-cdn-repos:
           
        RUN goToKey IN THIS-PROCEDURE (INPUT bfProdutCarg.cdn-identif) NO-ERROR.             
        EMPTY TEMP-TABLE ttProdutCargAux NO-ERROR. 
        RUN getRecord IN THIS-PROCEDURE (OUTPUT TABLE ttProdutCargAux).

        FIND FIRST ttProdutCargAux NO-ERROR.
        IF NOT AVAILABLE ttProdutCargAux THEN NEXT.
        
        ASSIGN ttProdutCargAux.qtd-coleta = 0
               ttProdutCargAux.cdn-motiv-nao-coleta = p-cdn-motiv-nao-coleta
               ttProdutCargAux.idi-nao-coleta = 1
               ttProdutCargAux.cdn-compart = 0.

       
        RUN setRecord      IN THIS-PROCEDURE (INPUT TABLE ttProdutCargAux).
        RUN emptyRowErrors IN THIS-PROCEDURE.
        RUN validateMotivoNaoColeta IN THIS-PROCEDURE.
        ASSIGN l-erro = RETURN-VALUE = "NOK".
        IF NOT l-erro THEN DO:               
           RUN updateRecord   IN THIS-PROCEDURE.                 
        END.   
        ASSIGN l-erro = RETURN-VALUE = "NOK".
        
        IF l-erro THEN DO:
            UNDO blockColetivo, LEAVE blockColetivo.
        END.        
    END.    
    
    IF l-erro THEN
        RETURN 'NOK':U. 
        
    RETURN 'OK':U.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createProdutCargCol DBOProgram 
PROCEDURE createProdutCargCol :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER TABLE FOR ttProdutCargCol.
    DEFINE OUTPUT PARAMETER pi-identif-repos AS INTEGER NO-UNDO.
    
    DEFINE VARIABLE l-erro AS LOGICAL NO-UNDO.

    DEFINE VARIABLE i-produt-respons AS INTEGER INITIAL ? NO-UNDO.
    
    FIND FIRST ttProdutCargCol NO-ERROR.    
    IF NOT AVAIL ttProdutCargCol THEN RETURN 'NOK':U.    
    
  
    FOR FIRST produt-pto-coleta FIELDS(cdn-produt-rural) NO-LOCK
        WHERE produt-pto-coleta.cod-pto-coleta = ttProdutCargCol.cod-pto-coleta
          AND produt-pto-coleta.log-respons:          
        ASSIGN i-produt-respons = IF AVAIL produt-pto-coleta THEN produt-pto-coleta.cdn-produt-rural ELSE ?.
    END.
    IF i-produt-respons = ? THEN RETURN 'NOK':U.
   
    blockColetivo:
    DO TRANS:
        FOR EACH produt-pto-coleta FIELDS(cod-pto-coleta cdn-produt-rural log-livre-1 cod-propried) NO-LOCK
           WHERE produt-pto-coleta.cod-pto-coleta = ttProdutCargCol.cod-pto-coleta:

            /* Relacionamentos Inativos*/
            IF NOT produt-pto-coleta.log-livre-1 THEN
              NEXT.
                          
            EMPTY TEMP-TABLE ttProdutCargAux NO-ERROR.
            
            CREATE ttProdutCargAux.
            RUN getCreateSequence IN THIS-PROCEDURE (OUTPUT ttProdutCargAux.cdn-identif).
            IF CAN-FIND(FIRST produt-carg NO-LOCK 
                        WHERE produt-carg.num-carg          = ttProdutCargCol.num-carg
                          AND produt-carg.cod-pto-coleta    = ttProdutCargCol.cod-pto-coleta
                          AND produt-carg.cdn-produt-rural  = produt-pto-coleta.cdn-produt-rural
                          AND produt-carg.cdn-compart       = ttProdutCargCol.cdn-compart
                          AND produt-carg.cdn-repos         = ttProdutCargCol.cdn-repos
                          AND produt-carg.cod-propried      = ttProdutCargCol.cod-propried) THEN DO:
                NEXT.
            END.
            
            IF i-produt-respons = produt-pto-coleta.cdn-produt-rural THEN DO:
                ASSIGN pi-identif-repos            = ttProdutCargAux.cdn-identif /* Salva o id do responsavel pelo ponto de coleta */                  
                       ttProdutCargAux.cod-amostra = ttProdutCargCol.cod-amostra
                       ttProdutCargAux.cod-lacre   = ttProdutCargCol.cod-lacre.   


                IF ttProdutCargCol.cdn-motiv-nao-coleta > 0 THEN DO:
                    ASSIGN ttProdutCargAux.cdn-motiv-nao-coleta = ttProdutCargCol.cdn-motiv-nao-coleta
                           ttProdutCargAux.idi-nao-coleta       = 1.
                END.

            END.
            ASSIGN ttProdutCargAux.num-carg           = ttProdutCargCol.num-carg
                   ttProdutCargAux.cod-estabel        = ttProdutCargCol.cod-estabel 
                   ttProdutCargAux.cod-pto-coleta     = ttProdutCargCol.cod-pto-coleta
                   ttProdutCargAux.dat-trans          = ttProdutCargCol.dat-trans
                   ttProdutCargAux.it-codigo          = ttProdutCargCol.it-codigo
                   ttProdutCargAux.cdn-compart        = ttProdutCargCol.cdn-compart
                   ttProdutCargAux.cdn-produt-respons = i-produt-respons
                   ttProdutCargAux.cdn-produt-rural   = produt-pto-coleta.cdn-produt-rural
                   ttProdutCargAux.cdn-sit            = 1
                   ttProdutCargAux.val-temperat       = ttProdutCargCol.val-temperat
                   ttProdutCargAux.cdn-repos          = ttProdutCargCol.cdn-repos
                   ttProdutCargAux.des-obs            = ttProdutCargCol.des-obs
                   ttProdutCargAux.cod-propried       = produt-pto-coleta.cod-propried.
          
            RUN setRecord      IN THIS-PROCEDURE (INPUT TABLE ttProdutCargAux).
            RUN emptyRowErrors IN THIS-PROCEDURE.  
            IF ttProdutCargCol.cdn-motiv-nao-coleta > 0 THEN DO:
                RUN validateMotivoNaoColeta IN THIS-PROCEDURE.
                ASSIGN l-erro = RETURN-VALUE <> "OK".
            END.
            
            IF NOT l-erro THEN DO:               
                RUN createRecord IN THIS-PROCEDURE.

                IF RETURN-VALUE = "NOK" THEN DO:
                    ASSIGN l-erro = YES.
                    UNDO blockColetivo, LEAVE blockColetivo.                
                END.
            END.
            ELSE
                UNDO blockColetivo, LEAVE blockColetivo.       
        END.
    END.
   
    IF l-erro then 
        RETURN "NOK":U.
        
    RETURN 'OK':U.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteProdutCargAut DBOProgram 
PROCEDURE deleteProdutCargAut :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-num-carg        AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-pto-coleta  AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-cdn-produt-resp AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER p-cdn-compart     AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER p-cdn-repos       AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-propried    AS CHARACTER NO-UNDO.    
    DEFINE INPUT PARAMETER p-del-carg        AS LOGICAL   NO-UNDO.
    
    RUN openQueryStatic IN THIS-PROCEDURE(INPUT "Main":U).

    IF p-del-Carg THEN
        FOR EACH bfProdutCarg FIELDS(cdn-identif) NO-LOCK
           WHERE bfProdutCarg.num-carg = p-num-carg:

             RUN goToKey IN THIS-PROCEDURE (INPUT bfProdutCarg.cdn-identif) NO-ERROR.    
             IF RETURN-VALUE = "NOK":U THEN NEXT.

             RUN emptyRowErrors IN THIS-PROCEDURE.
             RUN deleteRecord   IN THIS-PROCEDURE.
        END.
    ELSE DO:   
    
        /* Se o produtor que est· sendo eliminado È o responasavel,
           desconsidera a propriedade para eliminar os produtores coletivos */
        IF CAN-FIND(FIRST produt-pto-coleta
                    WHERE produt-pto-coleta.cdn-produt-rural = p-cdn-produt-resp
                      AND produt-pto-coleta.cod-propried     = p-cod-propried
                      AND produt-pto-coleta.cod-pto-coleta   = p-cod-pto-coleta
                      AND produt-pto-coleta.log-respons) THEN DO:
                      
            FOR EACH bfProdutCarg FIELDS(cdn-identif) NO-LOCK
               WHERE bfProdutCarg.num-carg           = p-num-carg
                 AND bfProdutCarg.cdn-produt-respons = p-cdn-produt-resp
                 AND bfProdutCarg.cdn-compart        = p-cdn-compart
                 AND bfProdutCarg.cdn-repos          = p-cdn-repos
                 AND bfProdutCarg.cod-pto-coleta     = p-cod-pto-coleta:
                 
                 RUN goToKey IN THIS-PROCEDURE (INPUT bfProdutCarg.cdn-identif) NO-ERROR.
                 
                 IF RETURN-VALUE = "NOK":U THEN NEXT.
                 
                 RUN emptyRowErrors IN THIS-PROCEDURE.
                 RUN deleteRecord   IN THIS-PROCEDURE.                             
            END.
        END.
        ELSE DO:
            /* Elimina produtor coletivo individualmente */
            FOR EACH bfProdutCarg FIELDS(cdn-identif) NO-LOCK
               WHERE bfProdutCarg.num-carg           = p-num-carg
                 AND bfProdutCarg.cdn-produt-respons = p-cdn-produt-resp
                 AND bfProdutCarg.cdn-compart        = p-cdn-compart
                 AND bfProdutCarg.cdn-repos          = p-cdn-repos
                 AND bfProdutCarg.cod-propried       = p-cod-propried
                 AND bfProdutCarg.cod-pto-coleta     = p-cod-pto-coleta:
                 
                 RUN goToKey IN THIS-PROCEDURE (INPUT bfProdutCarg.cdn-identif) NO-ERROR.    
                 IF RETURN-VALUE = "NOK":U THEN NEXT.
            
                 RUN emptyRowErrors IN THIS-PROCEDURE.
                 RUN deleteRecord   IN THIS-PROCEDURE.             
                
            END.
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
        WHEN "cod-depos":U THEN ASSIGN pFieldValue = RowObject.cod-depos.
        WHEN "cod-docto-produt":U THEN ASSIGN pFieldValue = RowObject.cod-docto-produt.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-lote":U THEN ASSIGN pFieldValue = RowObject.cod-lote.
        WHEN "cod-model-docto-produt":U THEN ASSIGN pFieldValue = RowObject.cod-model-docto-produt.
        WHEN "cod-propried":U THEN ASSIGN pFieldValue = RowObject.cod-propried.
        WHEN "cod-pto-coleta":U THEN ASSIGN pFieldValue = RowObject.cod-pto-coleta.
        WHEN "cod-ser-docto-produt":U THEN ASSIGN pFieldValue = RowObject.cod-ser-docto-produt.
        WHEN "des-obs":U THEN ASSIGN pFieldValue = RowObject.des-obs.
        WHEN "hra-coleta":U THEN ASSIGN pFieldValue = RowObject.hra-coleta.        
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "nat-operacao":U THEN ASSIGN pFieldValue = RowObject.nat-operacao.
        WHEN "nro-docto":U THEN ASSIGN pFieldValue = RowObject.nro-docto.
        WHEN "serie-docto":U THEN ASSIGN pFieldValue = RowObject.serie-docto.
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

    FOR LAST bfprodut-carg FIELDS(cdn-identif) NO-LOCK: END.
    IF AVAILABLE bfprodut-carg THEN 
       ASSIGN p-seq = bfprodut-carg.cdn-identif + 1.
    ELSE ASSIGN p-seq = 1.

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
        WHEN "dat-trans":U THEN ASSIGN pFieldValue = RowObject.dat-trans.
        WHEN "dat-coleta":U THEN ASSIGN pFieldValue = RowObject.dat-coleta.
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
        WHEN "qtd-coleta":U THEN ASSIGN pFieldValue = RowObject.qtd-coleta.
        WHEN "qtd-medid-regua":U THEN ASSIGN pFieldValue = RowObject.qtd-medid-regua.        
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
        WHEN "val-temperat":U THEN ASSIGN pFieldValue = RowObject.val-temperat.
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
        WHEN "cdn-compart":U THEN ASSIGN pFieldValue = RowObject.cdn-compart.
        WHEN "cdn-repos":U THEN ASSIGN pFieldValue = RowObject.cdn-repos.     
        WHEN "cdn-identif":U THEN ASSIGN pFieldValue = RowObject.cdn-identif.
        WHEN "cdn-motiv-nao-coleta":U THEN ASSIGN pFieldValue = RowObject.cdn-motiv-nao-coleta.        
        WHEN "cdn-produt-respons":U THEN ASSIGN pFieldValue = RowObject.cdn-produt-respons.
        WHEN "cdn-produt-rural":U THEN ASSIGN pFieldValue = RowObject.cdn-produt-rural.
        WHEN "cdn-sit":U THEN ASSIGN pFieldValue = RowObject.cdn-sit.
        WHEN "idi-nao-coleta":U THEN ASSIGN pFieldValue = RowObject.idi-nao-coleta.        
        WHEN "num-carg":U THEN ASSIGN pFieldValue = RowObject.num-carg.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
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
  Purpose:     Retorna valores dos campos do °ndice produt-carg-id
  Parameters:  
               retorna valor do campo cdn-identif
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcdn-identif LIKE produt-carg.cdn-identif NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcdn-identif = RowObject.cdn-identif.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getQtdTotalCarga DBOProgram 
PROCEDURE getQtdTotalCarga :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-num-carg   AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER p-qtd-total AS DECIMAL NO-UNDO.

   
    FOR EACH bfProdutCarg NO-LOCK
       WHERE bfProdutCarg.num-carg = p-num-carg:

        ASSIGN p-qtd-total = p-qtd-total + bfProdutCarg.qtd-coleta.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getQtdTotalPtoColeta DBOProgram 
PROCEDURE getQtdTotalPtoColeta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-num-carg    AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER p-pto-coleta  AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-cdn-compart AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER p-cdn-repos   AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER p-qtd-total  AS DECIMAL   NO-UNDO.
       
    FOR EACH bfProdutCarg NO-LOCK
       WHERE bfProdutCarg.num-carg       = p-num-carg 
         AND bfProdutCarg.cod-pto-coleta = p-pto-coleta
         AND bfProdutCarg.cdn-compart    = p-cdn-compart
         AND bfProdutCarg.cdn-repos      = p-cdn-repos:

        ASSIGN p-qtd-total = p-qtd-total + bfProdutCarg.qtd-coleta.
    END.

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
  Purpose:     Reposiciona registro com base no °ndice produt-carg-id
  Parameters:  
               recebe valor do campo cdn-identif
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcdn-identif LIKE produt-carg.cdn-identif NO-UNDO.

    FIND FIRST bfprodut-carg WHERE 
        bfprodut-carg.cdn-identif = pcdn-identif NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfprodut-carg THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfprodut-carg)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE can-find-produt-carg :
/*------------------------------------------------------------------------------
  Purpose:  Verifica existencia de produtor informadO para a carga  
  Parameters:  
               
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnum-carg         LIKE produt-carg.num-carg NO-UNDO.
    DEFINE INPUT PARAMETER pcdn-produt-rural LIKE produt-carg.cdn-identif NO-UNDO.

    
    IF NOT CAN-FIND(FIRST produt-carg 
                    WHERE produt-carg.num-carg         = pnum-carg
                      AND produt-carg.cdn-produt-rural = pcdn-produt-rural) THEN
        RETURN "NOK":U.
        
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkTocarg-rural DBOProgram 
PROCEDURE linkTocarg-rural :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pHandle AS HANDLE NO-UNDO.
    
    RUN getKey IN pHandle (OUTPUT i-num-carg).   
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkTopto-coleta DBOProgram 
PROCEDURE linkTopto-coleta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pHandle AS HANDLE NO-UNDO.
    
    RUN getKey IN pHandle (OUTPUT c-pto-coleta).   
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCarga DBOProgram 
PROCEDURE openQueryCarga :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH {&TableName} 
                               WHERE {&TableName}.num-carg = i-num-carg NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryColetiva DBOProgram 
PROCEDURE openQueryColetiva :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} 
                               WHERE {&TableName}.num-carg           = i-num-carg 
                                 AND {&TableName}.cod-pto-coleta     = c-pto-coleta
                                 AND {&TableName}.cdn-produt-respons = i-produt-resp 
                                 AND {&TableName}.cdn-compart        = i-cdn-compart 
                                 AND {&TableName}.cdn-repos          = i-cdn-repos NO-LOCK INDEXED-REPOSITION.

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

   OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK INDEXED-REPOSITION. 
   RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryProdutoresCarga DBOProgram 
PROCEDURE openQueryProdutoresCarga :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   OPEN QUERY {&QueryName} 
     FOR EACH {&TableName} 
        WHERE {&TableName}.num-carg = i-num-carg 
          AND {&TableName}.cdn-produt-respons = {&TableName}.cdn-produt-rural NO-LOCK 
          INDEXED-REPOSITION.

   RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ratearDiferenca DBOProgram 
PROCEDURE ratearDiferenca :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE VARIABLE d-dif-total  AS DECIMAL NO-UNDO.
   DEFINE VARIABLE d-qtd-total  AS DECIMAL NO-UNDO.   
   DEFINE VARIABLE d-somatorio  AS DECIMAL NO-UNDO.         
   DEFINE VARIABLE d-dif-produt AS DECIMAL NO-UNDO.      
   DEFINE VARIABLE i-casas      AS INTEGER NO-UNDO.
     
   ASSIGN d-qtd-total = 0 
          d-dif-total  = (dQtdColeta - dQtdColetiva).  /* (total do ponto - somatorio produtores) */
          
    FOR EACH bfProdutCarg  EXCLUSIVE-LOCK
       WHERE bfProdutCarg.num-carg           = iNumCarg
         AND bfProdutCarg.cod-pto-coleta     = cCodPtoColeta
         AND bfProdutCarg.cdn-compart        = iCdnCompart        
         AND bfProdutCarg.cdn-produt-respons = iProdutResposns
         AND bfProdutCarg.cdn-repos          = iCdnRepos
         BREAK BY bfProdutCarg.num-carg 
               BY bfProdutCarg.qtd-coleta :
         
        IF FIRST-OF(bfProdutCarg.num-carg) THEN DO:
            FOR FIRST item FIELDS(fraciona) NO-LOCK
                WHERE item.it-codigo = carg-rural.it-codigo:
                ASSIGN i-casas = IF item.fraciona THEN 4 ELSE 0.
            END.
        END.

        ASSIGN d-dif-produt             = d-dif-total * (bfProdutCarg.qtd-coleta / dQtdColetiva) /* diferenca proporcional */      
               bfProdutCarg.qtd-coleta  = bfProdutCarg.qtd-coleta + TRUNC(d-dif-produt,i-casas)
               d-somatorio              = d-somatorio + bfProdutCarg.qtd-coleta.        
        
        IF LAST-OF(bfProdutCarg.num-carg) THEN           
            ASSIGN bfProdutCarg.qtd-coleta =  bfProdutCarg.qtd-coleta + (dQtdColeta -  d-somatorio).
    END.
    
    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCarga DBOProgram 
PROCEDURE setConstraintCarga :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-num-carg AS INTEGER NO-UNDO.
        
    ASSIGN i-num-carg = p-num-carg. 
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintColetiva DBOProgram 
PROCEDURE setConstraintColetiva :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-num-carg    AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER p-pto-coleta  AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-produt-resp AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER p-cdn-compart AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER p-cdn-repos   AS INTEGER NO-UNDO.
        
    ASSIGN i-num-carg    = p-num-carg  
           c-pto-coleta  = p-pto-coleta
           i-produt-resp = p-produt-resp
           i-cdn-compart = p-cdn-compart
           i-cdn-repos   = p-cdn-repos. 
   
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintRatearDiferenca DBOProgram 
PROCEDURE setConstraintRatearDiferenca :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE INPUT PARAMETER p-num-carg    AS INTEGER   NO-UNDO.
   DEFINE INPUT PARAMETER p-pto-coleta  AS CHARACTER NO-UNDO.   
   DEFINE INPUT PARAMETER p-cdn-compart AS INTEGER   NO-UNDO.  
   DEFINE INPUT PARAMETER p-cdn-repos   AS INTEGER   NO-UNDO. 
   DEFINE INPUT PARAMETER pQtdColeta    AS DECIMAL   NO-UNDO.
   DEFINE INPUT PARAMETER pQtdColetiva  AS DECIMAL   NO-UNDO.

   
   ASSIGN iNumCarg      = p-num-carg   
          cCodPtoColeta = p-pto-coleta 
          iCdnCompart   = p-cdn-compart
          dQtdColeta    = pQtdColeta   
          dQtdColetiva  = pQtdColetiva
          iCdnRepos     = p-cdn-repos.
          
   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintTexto DBOProgram 
PROCEDURE setConstraintTexto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-texto AS CHARACTER.

    ASSIGN c-texto = pc-texto.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateProdutCargAut DBOProgram 
PROCEDURE updateProdutCargAut :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-num-carg    AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER p-dat-trans   AS DATE      NO-UNDO.
    DEFINE INPUT PARAMETER p-it-codigo   AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-cdn-compart AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER p-cdn-sit     AS INTEGER   NO-UNDO.

    FOR EACH bfProdutCarg FIELDS(cdn-identif) NO-LOCK
       WHERE bfProdutCarg.num-carg = p-num-carg:
                                     
         RUN goToKey IN THIS-PROCEDURE (INPUT bfProdutCarg.cdn-identif) NO-ERROR.

         IF RETURN-VALUE = "NOK":U THEN NEXT.
         
         EMPTY TEMP-TABLE ttProdutCargAux NO-ERROR. 

         RUN getRecord IN THIS-PROCEDURE (OUTPUT TABLE ttProdutCargAux).

         FIND FIRST ttProdutCargAux NO-ERROR.

         IF NOT AVAILABLE ttProdutCargAux THEN NEXT.

         ASSIGN ttProdutCargAux.dat-trans = p-dat-trans WHEN p-dat-trans <> ?
                ttProdutCargAux.it-codigo = p-it-codigo WHEN p-it-codigo <> ? 
                ttProdutCargAux.cdn-compart = p-cdn-compart WHEN p-cdn-compart <> ?
                ttProdutCargAux.cdn-sit = p-cdn-sit WHEN p-cdn-sit <> ?.

         RUN setRecord      IN THIS-PROCEDURE (INPUT TABLE ttProdutCargAux).
         RUN emptyRowErrors IN THIS-PROCEDURE.
         RUN updateRecord   IN THIS-PROCEDURE.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateProdutCargColetivo DBOProgram 
PROCEDURE updateProdutCargColetivo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-num-carg AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-pto-coleta AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-cdn-produt-respons AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER p-cdn-compart AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER p-cdn-repos AS INTEGER NO-UNDO.    
    DEFINE INPUT PARAMETER TABLE FOR tt-produt-carg.
    
    DEFINE VARIABLE l-erro AS LOGICAL NO-UNDO.
    
    FIND FIRST tt-produt-carg NO-ERROR.    
    IF NOT AVAIL tt-produt-carg THEN RETURN 'NOK':U.
    
    RUN openQueryMain IN THIS-PROCEDURE.
        
  
    blockColetivo:  
    FOR EACH bfProdutCarg FIELDS(cdn-identif cdn-produt-rural cdn-produt-rural) NO-LOCK
       WHERE bfProdutCarg.num-carg           = p-num-carg       
         AND bfProdutCarg.cod-pto-coleta     = p-cod-pto-coleta
         AND bfProdutCarg.cdn-produt-respons = p-cdn-produt-respons
         AND bfProdutCarg.cdn-compart        = p-cdn-compart
         AND bfProdutCarg.cdn-repos          = p-cdn-repos: 
         
         RUN goToKey IN THIS-PROCEDURE (INPUT bfProdutCarg.cdn-identif) NO-ERROR.
         IF RETURN-VALUE = "NOK":U THEN NEXT.
         
         EMPTY TEMP-TABLE ttProdutCargAux NO-ERROR. 
         RUN getRecord IN THIS-PROCEDURE (OUTPUT TABLE ttProdutCargAux).

         FIND FIRST ttProdutCargAux NO-ERROR.
         IF NOT AVAILABLE ttProdutCargAux THEN NEXT.

         ASSIGN ttProdutCargAux.cdn-compart          =  tt-produt-carg.cdn-compart
                ttProdutCargAux.val-temperat         =  tt-produt-carg.val-temperat
                ttProdutCargAux.cod-amostra          =  tt-produt-carg.cod-amostra
                ttProdutCargAux.cod-lacre            =  tt-produt-carg.cod-lacre
                ttProdutCargAux.cdn-motiv-nao-coleta = tt-produt-carg.cdn-motiv-nao-coleta
                ttProdutCargAux.idi-nao-coleta       = if tt-produt-carg.cdn-motiv-nao-coleta > 0 THEN 1 ELSE 0.
                  
                
         RUN setRecord      IN THIS-PROCEDURE (INPUT TABLE ttProdutCargAux).
         RUN emptyRowErrors IN THIS-PROCEDURE.
         RUN updateRecord   IN THIS-PROCEDURE.
         ASSIGN l-erro =  RETURN-VALUE = "NOK".

         IF l-erro THEN DO:
            UNDO blockColetivo, LEAVE blockColetivo.
         END.
         
    END.   
    IF l-erro THEN 
        RETURN 'NOK':U.

    RETURN 'OK':U.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaProdutoresColetivos DBOProgram 
PROCEDURE buscaProdutoresColetivos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  pi-cdn-identif = identificador do responasavel pelo ponto de coleta
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pi-cdn-identif AS INTEGER NO-UNDO. 
    DEFINE OUTPUT PARAMETER TABLE FOR ttProdutCargAux.
    
    DEFINE VARIABLE i-cdn-produt-respons AS INTEGER NO-UNDO.
    
    EMPTY TEMP-TABLE ttProdutCargAux NO-ERROR.
    
    FOR FIRST bfProdutCarg FIELDS(cdn-identif num-carg cdn-repos cdn-produt-respons bfProdutCarg.cdn-compart cod-pto-coleta) NO-LOCK
        WHERE bfProdutCarg.cdn-identif = pi-cdn-identif:       
        
        FOR EACH  produt-carg NO-LOCK
            WHERE produt-carg.num-carg = bfProdutCarg.num-carg
            AND   produt-carg.cdn-repos = bfProdutCarg.cdn-repos
            AND   produt-carg.cdn-compart = bfProdutCarg.cdn-compart
            AND   produt-carg.cdn-produt-respons = bfProdutCarg.cdn-produt-respons
            AND   produt-carg.cod-pto-coleta = bfProdutCarg.cod-pto-coleta,
            
            FIRST Produt-rural NO-LOCK
            WHERE Produt-rural.cdn-produt-rural = produt-carg.cdn-produt-rural
            AND   Produt-rural.log-livre-1      = YES:

             CREATE ttProdutCargAux.
             BUFFER-COPY produt-carg TO ttProdutCargAux.
        END.
    END.
    
    RETURN 'OK':U.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaQtdColetiva DBOProgram 
PROCEDURE validaQtdColetiva :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-num-carg   AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER p-pto-coleta AS CHARACTER NO-UNDO.

    DEFINE VARIABLE d-qtd AS DECIMAL NO-UNDO.
   
    FOR EACH bfProdutCarg FIELDS(qtd-coleta) NO-LOCK
       WHERE bfProdutCarg.num-carg            = p-num-carg 
         AND bfProdutCarg.cod-pto-coleta      = p-pto-coleta
         AND bfProdutCarg.cdn-produt-respons <> bfProdutCarg.cdn-produt-rural:
         
        IF bfProdutCarg.qtd-coleta > 0 THEN 
           ASSIGN d-qtd = d-qtd + bfProdutCarg.qtd-coleta.          
    END.
    
    IF d-qtd > 0 THEN  RETURN "OK":U.
    
    RETURN "NOK":U.
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
    DEFINE VARIABLE c-msg AS CHARACTER   NO-UNDO.
    
    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/    
    IF pType = "Create" THEN DO:
        IF RowObject.cdn-motiv-nao-coleta = 0 
        AND CAN-FIND(FIRST produt-carg 
                     WHERE produt-carg.num-carg         = RowObject.num-carg
                       AND produt-carg.cod-pto-coleta   = RowObject.cod-pto-coleta
                       AND produt-carg.cdn-produt-rural = RowObject.cdn-produt-rural
                       AND produt-carg.cod-propried     = RowObject.cod-propried
                       AND produt-carg.cdn-compart      = RowObject.cdn-compart
                       AND produt-carg.cdn-repos        = RowObject.cdn-repos) THEN DO:
           
             {method/svc/errors/inserr.i
                      &ErrorNumber="54617"
                      &ErrorType="EMS"
                      &ErrorParameters=RowObject.cdn-compart}
        END.
        
        IF CAN-FIND( FIRST produt-carg 
                     WHERE produt-carg.num-carg         = RowObject.num-carg
                       AND produt-carg.cod-pto-coleta   = RowObject.cod-pto-coleta
                       AND produt-carg.cdn-produt-rural = RowObject.cdn-produt-rural
                       AND produt-carg.cod-propried     = RowObject.cod-propried
                       AND produt-carg.cdn-repos        = RowObject.cdn-repos
                       AND produt-carg.cdn-motiv-nao-coleta > 0 ) THEN DO:  

            {method/svc/errors/inserr.i
                &ErrorNumber="54838"
                &ErrorType="EMS"
                &ErrorParameters="string(RowObject.cdn-repos)" } 
        end.
        ELSE DO:
            IF RowObject.cdn-motiv-nao-coleta > 0 THEN DO:
                FOR FIRST bfProdutCarg FIELDS(cdn-compart) NO-LOCK
                    WHERE bfProdutCarg.num-carg         = RowObject.num-carg
                      AND bfProdutCarg.cod-pto-coleta   = RowObject.cod-pto-coleta
                      AND bfProdutCarg.cdn-produt-rural = RowObject.cdn-produt-rural
                      AND bfProdutCarg.cod-propried     = RowObject.cod-propried 
                      AND bfProdutCarg.cdn-repos        = RowObject.cdn-repos
                      AND bfProdutCarg.cdn-motiv-nao-coleta = 0:
                    {utp/ut-liter.i incluir *}
                    {method/svc/errors/inserr.i
                         &ErrorNumber="54839"
                         &ErrorType="EMS"
                         &ErrorParameters="RETURN-VALUE + '~~~~' + string(RowObject.cdn-repos) + '~~~~' + string(RowObject.cod-pto-coleta) + '~~~~' + string(bfProdutCarg.cdn-compart)" }            
                END.
            END.        
        END.
        
        
    END.
    ELSE IF pType = "Update" THEN DO:    
        IF  RowObject.cdn-motiv-nao-coleta = 0
        AND CAN-FIND(FIRST produt-carg 
                     WHERE produt-carg.num-carg         = RowObject.num-carg
                       AND produt-carg.cod-pto-coleta   = RowObject.cod-pto-coleta
                       AND produt-carg.cdn-produt-rural = RowObject.cdn-produt-rural
                       AND produt-carg.cod-propried     = RowObject.cod-propried
                       AND produt-carg.cdn-compart      = RowObject.cdn-compart
                       AND produt-carg.cdn-repos        = RowObject.cdn-repos
                       AND produt-carg.cdn-identif     <> RowObject.cdn-identif) THEN DO:    
                       
            {method/svc/errors/inserr.i
                      &ErrorNumber="54617"
                      &ErrorType="EMS"
                      &ErrorParameters=RowObject.cdn-compart}
    
        END.
        
        IF CAN-FIND( FIRST produt-carg 
                     WHERE produt-carg.num-carg         = RowObject.num-carg
                       AND produt-carg.cod-pto-coleta   = RowObject.cod-pto-coleta
                       AND produt-carg.cdn-produt-rural = RowObject.cdn-produt-rural                       
                       AND produt-carg.cod-propried     = RowObject.cod-propried
                       AND produt-carg.cdn-repos        = RowObject.cdn-repos
                       AND produt-carg.cdn-motiv-nao-coleta > 0 
                       AND produt-carg.cdn-identif     <> RowObject.cdn-identif) THEN DO:  

            {method/svc/errors/inserr.i
                &ErrorNumber="54838"
                &ErrorType="EMS"
                &ErrorParameters="string(RowObject.cdn-repos)" }                       
        END.
        ELSE DO:
            IF RowObject.cdn-motiv-nao-coleta > 0 THEN DO:
                FOR FIRST bfProdutCarg FIELDS(cdn-compart) NO-LOCK
                    WHERE bfProdutCarg.num-carg         = RowObject.num-carg
                      AND bfProdutCarg.cod-pto-coleta   = RowObject.cod-pto-coleta
                      AND bfProdutCarg.cdn-produt-rural = RowObject.cdn-produt-rural                       
                      AND bfProdutCarg.cod-propried     = RowObject.cod-propried 
                      AND bfProdutCarg.cdn-repos        = RowObject.cdn-repos
                      AND bfProdutCarg.cdn-motiv-nao-coleta = 0 
                      AND bfProdutCarg.cdn-identif     <> RowObject.cdn-identif: 
                      {utp/ut-liter.i alterar *}
                    {method/svc/errors/inserr.i
                         &ErrorNumber="54839"
                         &ErrorType="EMS"                         
                         &ErrorParameters="RETURN-VALUE + '~~~~' + string(RowObject.cdn-repos) + '~~~~' + string(RowObject.cod-pto-coleta) + '~~~~' + string(bfProdutCarg.cdn-compart)" }
                END.
            END.        
        END. 
        
        IF RowObject.cdn-sit > 1 THEN DO:         
            {method/svc/errors/inserr.i
                     &ErrorNumber="54727" /*Produtor possui nota fiscal gerada!*/
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="RowObject.cdn-produt-rural"} 
        END.
    END.
    

    IF pType = "Create" OR  pType = "Update" THEN DO:
    
        IF RowObject.cod-pto-coleta = "" THEN DO:
            {utp/ut-liter.i Pto_Coleta *}
            {method/svc/errors/inserr.i
                     &ErrorNumber="164"
                     &ErrorType="EMS"
                     &ErrorParameters="return-value"} 
        END.
        ELSE 
            IF NOT CAN-FIND(FIRST pto-coleta 
                            WHERE pto-coleta.cod-pto-coleta = RowObject.cod-pto-coleta) THEN DO:
                                
                {utp/ut-liter.i Pto_Coleta *}
                {method/svc/errors/inserr.i 
                         &ErrorNumber="56"
                         &ErrorType="EMS"
                         &ErrorSubType="ERROR"
                         &ErrorParameters="return-value"} 
            END.  

        IF NOT CAN-FIND(FIRST reposit
                        WHERE reposit.cdn-repos =  RowObject.cdn-repos
                          AND reposit.cod-pto-coleta =  RowObject.cod-pto-coleta) THEN DO:
            {utp/ut-liter.i Reposit¢rio *}
            {method/svc/errors/inserr.i 
                     &ErrorNumber="56"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="return-value"}        
        END.        
        
        IF NOT lCreateAut THEN DO:
            IF RowObject.cdn-compart = 0 
            AND RowObject.cdn-motiv-nao-coleta = 0 
            AND RowObject.qtd-coleta > 0  THEN DO:
                {utp/ut-liter.i Compartimento *}
                {method/svc/errors/inserr.i 
                         &ErrorNumber="36"
                         &ErrorType="EMS"
                         &ErrorSubType="ERROR"
                         &ErrorParameters="return-value"} 
            END.
            ELSE DO:
                FIND FIRST bfCargRural NO-LOCK 
                     WHERE bfCargRural.num-carg = RowObject.num-carg NO-ERROR.
                IF AVAIL bfCargRural  THEN DO:
                    IF RowObject.cdn-compart > bfCargRural.qti-comptmento THEN DO:

                    DEFINE VARIABLE cParams AS CHARACTER   NO-UNDO.
                  
                    ASSIGN cParams = STRING(bfCargRural.num-carg) + "~~" +  STRING(bfCargRural.qti-comptmento).

                    {method/svc/errors/inserr.i 
                                 &ErrorNumber="54655" /*Compartimento inv†lido!*/
                                 &ErrorType="EMS"
                                 &ErrorSubType="ERROR"
                                 &ErrorParameters=cParams} 
                                 
                     END.
                END.
            END.
        END.


        IF RowObject.cdn-produt-rural = ? THEN DO:
            {utp/ut-liter.i Produtor_Rural *}
            {method/svc/errors/inserr.i
                     &ErrorNumber="164"
                     &ErrorType="EMS"
                     &ErrorParameters="return-value"} 
        END.
        ELSE DO:
            IF NOT CAN-FIND(FIRST produt-rural
                            WHERE produt-rural.cdn-produt-rural = RowObject.cdn-produt-rural) THEN DO:
                                
                {utp/ut-liter.i Produtor_Rural *}
                {method/svc/errors/inserr.i 
                         &ErrorNumber="56"
                         &ErrorType="EMS"
                         &ErrorSubType="ERROR"
                         &ErrorParameters="return-value"} 
            END.
            ELSE DO:
                
                IF NOT lCreateAut THEN DO:
                    IF NOT CAN-FIND(FIRST produt-pto-coleta
                                    WHERE produt-pto-coleta.cod-pto-coleta   = RowObject.cod-pto-coleta
                                      AND produt-pto-coleta.cdn-produt-rural = RowObject.cdn-produt-rural
                                      AND produt-pto-coleta.cod-propried     = RowObject.cod-propried 
                                      AND produt-pto-coleta.log-livre-1      = YES) THEN DO:

                         {utp/ut-liter.i Produtor_Rural *}
                         ASSIGN c-msg = RETURN-VALUE + ' ' + STRING(RowObject.cdn-produt-rural).
                         {utp/ut-liter.i Ponto_de_Coleta * }
                         ASSIGN c-msg = c-msg + "~~" + RETURN-VALUE + ' ' + RowObject.cod-pto-coleta.
                        {method/svc/errors/inserr.i 
                                 &ErrorNumber="54678"
                                 &ErrorType="EMS"
                                 &ErrorSubType="ERROR"
                                 &ErrorParameters="c-msg"} 
                    END.
                END.
            END.
        END.
        
        IF RowObject.cod-propried <> "" THEN DO:
            IF NOT CAN-FIND(FIRST produt-pto-coleta
                            WHERE produt-pto-coleta.cod-pto-coleta   = RowObject.cod-pto-coleta
                              AND produt-pto-coleta.cdn-produt-rural = RowObject.cdn-produt-rural
                              AND produt-pto-coleta.cod-propried     = RowObject.cod-propried
                              AND produt-pto-coleta.log-livre-1      = YES) THEN DO:                              
                 {method/svc/errors/inserr.i 
                     &ErrorNumber="54845" /* Propriedade nao cadastrada para para produtor */
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters=" "}
            END.
        END.
    END.   

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateMotivoNaoColeta DBOProgram 
PROCEDURE validateMotivoNaoColeta :
/*:T------------------------------------------------------------------------------
  Purpose:     
  Parameters: 
  Notes:   
------------------------------------------------------------------------------*/
    IF  RowObject.cdn-motiv-nao-coleta > 0
    AND NOT CAN-FIND(FIRST motiv-nao-coleta 
                     WHERE motiv-nao-coleta.cdn-motiv-nao-coleta = RowObject.cdn-motiv-nao-coleta) THEN DO:
        {utp/ut-table.i mgind motiv-nao-coleta 1}
        {method/svc/errors/inserr.i 
                 &ErrorNumber="56"
                 &ErrorType="EMS"
                 &ErrorSubType="ERROR"
                 &ErrorParameters="return-value"}
        RETURN "NOK":U.
    END.        
    
    IF  RowObject.qtd-coleta = 0 
    AND RowObject.cdn-motiv-nao-coleta = 0 
    AND RowObject.cdn-produt-respons = RowObject.cdn-produt-rural THEN DO:    
        {utp/ut-table.i mgind motiv-nao-coleta 1}
        {method/svc/errors/inserr.i 
                 &ErrorNumber="265"
                 &ErrorType="EMS"
                 &ErrorSubType="ERROR"
                 &ErrorParameters="return-value"}
    END.
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaRateio DBOProgram 
PROCEDURE verificaRateio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/   
   IF (dQtdColeta - dQtdColetiva) = 0 THEN RETURN "NOK":U.  
   
   FIND FIRST bf{&TableName} NO-LOCK
       WHERE bf{&TableName}.num-carg       = iNumCarg
         AND bf{&TableName}.cod-pto-coleta = cCodPtoColeta
         AND bf{&TableName}.cdn-compart    = iCdnCompart  
         AND bf{&TableName}.cdn-repos      = iCdnRepos  NO-ERROR.
         
   IF NOT AVAIL bf{&TableName} THEN RETURN "NOK":U.  
   
   ASSIGN iProdutResposns = bf{&TableName}.cdn-produt-respons. 

   IF NOT CAN-FIND(FIRST bfProdutCarg 
                   WHERE bfProdutCarg.num-carg           = iNumCarg
                     AND bfProdutCarg.cod-pto-coleta     = cCodPtoColeta
                     AND bfProdutCarg.cdn-compart        = iCdnCompart        
                     AND bfProdutCarg.cdn-produt-respons = iProdutResposns
                     AND bfProdutCarg.cdn-repos          = iCdnRepos
                     AND bfProdutCarg.cdn-produt-rural  <> iProdutResposns) THEN RETURN "NOK":U.

    RETURN "OK":U.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaFornecedoresPontoColeta DBOProgram 
PROCEDURE retornaFornecedoresPontoColeta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Retornar temp-table com todos os fornecedores por ponto de coleta
         e quantidade depositadas por fornecedor no ponto de coleta.
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER p-cod-pto-coleta AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-propried AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER p-dat-inic AS DATE NO-UNDO.
    DEFINE INPUT  PARAMETER p-dat-fim AS DATE NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt_fornecedor_pto_coleta.

    FOR EACH tt_fornecedor_pto_coleta:
        DELETE tt_fornecedor_pto_coleta.
    END.

    FOR EACH produt-pto-coleta FIELDS(cdn-produt-rural cod-pto-coleta cod-propried log-respons) NO-LOCK
        WHERE produt-pto-coleta.cod-pto-coleta = p-cod-pto-coleta:
        CREATE tt_fornecedor_pto_coleta.
        ASSIGN tt_fornecedor_pto_coleta.tta_cod_prop_rural = produt-pto-coleta.cod-propried
               tt_fornecedor_pto_coleta.tta_cod_pto_coleta = produt-pto-coleta.cod-pto-coleta
               tt_fornecedor_pto_coleta.tta_cdn_fornecedor = produt-pto-coleta.cdn-produt-rural
               tt_fornecedor_pto_coleta.ttv_log_respons    = produt-pto-coleta.log-respons
               tt_fornecedor_pto_coleta.ttv_qtd_coleta     = 0.

        FOR EACH bf{&TableName} FIELDS(qtd-coleta) NO-LOCK
           WHERE bf{&TableName}.cod-pto-coleta   = tt_fornecedor_pto_coleta.tta_cod_pto_coleta
             AND bf{&TableName}.cdn-produt-rural = tt_fornecedor_pto_coleta.tta_cdn_fornecedor
             AND bf{&TableName}.dat-trans       >= p-dat-inic
             AND bf{&TableName}.dat-trans       <= p-dat-fim:

            ASSIGN tt_fornecedor_pto_coleta.ttv_qtd_coleta = tt_fornecedor_pto_coleta.ttv_qtd_coleta + bf{&TableName}.qtd-coleta.
        END.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaQuantidadeColetadaDia DBOProgram 
PROCEDURE retornaQuantidadeColetadaDia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Retornar temp-table com todas as quantidade de coleta por fornecedor por dia.
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER p-cdn-fornecedor AS INTEGER NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-propried AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER p-dat-inic AS DATE NO-UNDO.
    DEFINE INPUT  PARAMETER p-dat-fim AS DATE NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt_fornec_produt_vol.

    FOR EACH tt_fornec_produt_vol EXCLUSIVE-LOCK:
        DELETE tt_fornec_produt_vol.
    END.

    FOR EACH bf{&TableName} FIELDS(qtd-coleta cdn-produt-rural cod-pto-coleta dat-trans qtd-aferid) NO-LOCK
       WHERE bf{&TableName}.cdn-produt-rural = p-cdn-fornecedor
         AND bf{&TableName}.dat-trans       >= p-dat-inic
         AND bf{&TableName}.dat-trans       <= p-dat-fim
        BREAK BY bf{&TableName}.dat-trans:

        FIND FIRST produt-pto-coleta NO-LOCK
            WHERE produt-pto-coleta.cdn-produt-rural = bf{&TableName}.cdn-produt-rural
              and produt-pto-coleta.cod-pto-coleta   = bf{&TableName}.cod-pto-coleta NO-ERROR.
        IF AVAIL produt-pto-coleta AND produt-pto-coleta.cod-propried <> p-cod-propried THEN NEXT.

        IF v_num_dat_aux <> DAY(bf{&TableName}.dat-trans) THEN DO:
            CREATE tt_fornec_produt_vol.
            ASSIGN tt_fornec_produt_vol.tta_cdn_fornecedor = bf{&TableName}.cdn-produt-rural
                   tt_fornec_produt_vol.ttv_num_dias       = DAY(bf{&TableName}.dat-trans)
                   tt_fornec_produt_vol.ttv_qtd_volume     = bf{&TableName}.qtd-coleta.
        END.
        ELSE do:
            ASSIGN tt_fornec_produt_vol.ttv_qtd_volume = tt_fornec_produt_vol.ttv_qtd_volume + bf{&TableName}.qtd-coleta.
        END.

        ASSIGN v_num_dat_aux = DAY(bf{&TableName}.dat-trans).
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
