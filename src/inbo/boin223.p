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
{include/i-prgvrs.i BOIN223 2.00.00.054 } /*** "010054" 17/06/2025 16:40:47 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin223 MUT}
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

/*--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN223
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName movto-pend
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin223.i RowObject}
{inbo/boin223.i2} /*Definiá∆o do tt-docum-est*/


/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/* Esta vari†vel Ç utilizada para evitar Erro de Documento j† Existe */
def new global shared var l-verifica-docto            as logical init no no-undo.

def buffer b-docum-est  for docum-est.
DEF BUFFER b-doc-fisico FOR doc-fisico.
def buffer b-movto-pend for movto-pend.

def var i-cod-emitente as int                         no-undo.
def var c-serie-docto  as char                        no-undo.
def var c-nro-docto    as char                        no-undo.
def var c-nat-operacao as char                        no-undo.

def var i-emitente   as int                           no-undo.
def var c-serie-comp as char                          no-undo.
def var c-nro-comp   as char                          no-undo.
def var c-nat-comp   as char                          no-undo.

def var h-boin090      as handle                      no-undo.
def var rDocumEst      as rowid                       no-undo.
def var de-qt-ori      as decimal                     no-undo.
def var i-empresa      like param-global.empresa-prin no-undo.
DEF VAR l-cria-documento AS LOGICAL                   NO-UNDO.
DEF VAR c-lbl-liter-msg  AS CHARACTER                 NO-UNDO.
DEF VAR l-gera-com-doc-fisico AS LOGICAL INITIAL FALSE NO-UNDO.
DEF VAR i-tipo-nota-fisico    AS INTEGER              NO-UNDO.

def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro  as integer format ">>>>,>>9" label "Numero" column-label "Numero"
    field ttv_des_msg_ajuda as character format "x(40)" label "Mensagem Aluda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro  as character format "x(60)" label "Mensagem Erro" column-label "Inconsistencia".


DEFINE TEMP-TABLE tt-natOper-itens-aux NO-UNDO /* Temp-table Aux apenas para chamar createDoctoItemOfRecFisico */
       FIELD sequencia   LIKE it-doc-fisico.sequencia
       FIELD nat-of      LIKE item-doc-est.nat-of
       INDEX i-sequencia IS PRIMARY sequencia.

def var h_api_cta_ctbl   as handle no-undo.
def var h_api_ccusto     as handle no-undo.
def var c-formato-conta  as char   no-undo.
def var c-formato-ccusto as char   no-undo.
def var v_des_cta_ctbl   as char   no-undo.
def var v_des_ccusto     as char   no-undo.

/* Vari†veis conta ctbl */
def var v_cod_cta_ctbl       as char   no-undo.
def var v_titulo_cta_ctbl    as char   no-undo.
def var v_num_tip_cta_ctbl   as int    no-undo.
def var v_num_sit_cta_ctbl   as int    no-undo.
def var v_ind_finalid_cta    as char   no-undo.
def var v_cod_formato        as char   no-undo.

/* Vari†veis centro de custo */ 
def var v_cod_ccusto         as char   no-undo.
def var v_titulo_ccusto      as char   no-undo.
def var v_log_utz_ccusto     as log    no-undo.

{cep/ce1234.i}   /* Validaá∆o Decimais               */
{cdp/cd4329.i2}  /* Aloca/Desaloca parcela de Compra */
{cdp/cdcfgmat.i} /* PrÇ-processadores Materiais      */

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
         HEIGHT             = 18.75
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

find first param-global no-lock no-error.

find first param-estoq no-lock no-error.

ASSIGN l-cria-documento = YES.

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
    
    DEFINE BUFFER b-docto FOR docum-est.

    DEFINE VARIABLE r-docum-est AS ROWID   NO-UNDO.
    DEFINE VARIABLE l-erro-imp  AS LOGICAL NO-UNDO.

    FOR FIRST b-docto
        FIELDS ( cod-emitente serie-docto nro-docto nat-operacao )
        WHERE b-docto.cod-emitente = RowObject.cod-emitente
          AND b-docto.serie-docto  = RowObject.serie-comp
          AND b-docto.nro-docto    = Rowobject.nro-comp
          AND b-docto.nat-operacao = RowObject.nat-comp NO-LOCK: END.
    
    IF  RowObject.tipo = 2 /* Agregado */
        AND l-cria-documento 
        AND NOT AVAIL b-docto THEN DO:

        FOR EACH tt-docum-est: 
            DELETE tt-docum-est. /* Limpa TT */
        END.

        CREATE tt-docum-est.

        IF  l-gera-com-doc-fisico THEN DO: /* Gera itens com base no documento f°sico (re1001h2) */

            RUN assignDocFisicoKey. /* Atribui chave */
            RUN emptyRowObject IN h-boin090. /* Limpa a temp-table RowObject */
            RUN setRecord      IN h-boin090 (INPUT TABLE tt-docum-est). /* Copia as informaá‰es da tt-docum-est para a RowObject */
            RUN emptyRowErrors IN h-boin090. /* Limpa a temp-table RowErros */

            /* Temp-table tt-natOper-itens-aux Ç enviada vazia - Seguindo o fluxo para gerar os itens com a natureza principal... */
            RUN createDoctoItemOfRecFisico IN h-boin090 (INPUT TABLE tt-natOper-itens-aux, OUTPUT r-docum-est, OUTPUT l-erro-imp).
            /* createDoctoItemOfRecFisico ->  Cria a docum-est e a(s) item-doc-est com base nos registros do documento f°sico. */

            IF  CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-conv-nfe-entrada":U AND funcao.ativo NO-LOCK) THEN DO:
                RUN repositionRecord IN h-boin090 (INPUT r-docum-est).
                RUN atualizaChaveNfeEletronica IN h-boin090.
            END.
        END.
        ELSE DO:
            
            ASSIGN tt-docum-est.cod-emitente  = RowObject.cod-emitente
                   tt-docum-est.serie-docto   = RowObject.serie-comp
                   tt-docum-est.nro-docto     = RowObject.nro-comp
                   tt-docum-est.nat-operacao  = RowObject.nat-comp
                   tt-docum-est.cod-observa   = RowObject.cod-observa
                   tt-docum-est.cod-estabel   = docum-est.cod-estabel
                   tt-docum-est.estab-fisc    = docum-est.estab-fisc
                   tt-docum-est.dt-emissao    = docum-est.dt-emissao
                   tt-docum-est.dt-trans      = docum-est.dt-trans
                   tt-docum-est.nff           = docum-est.nff
                   tt-docum-est.tipo-docto    = natur-oper.tipo
                   tt-docum-est.uf            = docum-est.uf
                   tt-docum-est.via-transp    = docum-est.via-transp
                   tt-docum-est.dt-venc-ipi   = docum-est.dt-venc-ipi
                   tt-docum-est.dt-venc-icm   = docum-est.dt-venc-icm
                   tt-docum-est.dt-venc-iss   = docum-est.dt-venc-iss
                   tt-docum-est.ct-transit    = RowObject.ct-codigo 
                   tt-docum-est.sc-transit    = RowObject.sc-codigo
                   tt-docum-est.usuario       = docum-est.usuario
                   tt-docum-est.sit-docum     = if docum-est.nff 
                                                or (    not docum-est.nff 
                                                    and not natur-oper.emite-duplic )
                                                then 1 
                                                else 2
                   tt-docum-est.sit-atual     = 2
    
                   /* Indica Nota de Material Agregado */
                   tt-docum-est.mod-atual     = IF AVAIL natur-oper AND natur-oper.tipo-compra = 4 THEN 1 ELSE 0
                   &if "{&bf_mat_versao_ems}" < "2.07" &then
                      overlay(tt-docum-est.char-1,93,60) = SUBSTRING(RowObject.char-1,8,60)
                   &else
                      tt-docum-est.cod-chave-aces-nf-eletro = RowObject.cod-chave-aces-nf-eletro
                   &endif
                   .
    
            run openQueryStatic in h-boin090 ("Docto":U).
            run emptyRowObject  in h-boin090.
            run setRecord       in h-boin090 ( input table tt-docum-est ).
            run emptyRowErrors  in h-boin090.
            run createRecord    in h-boin090.
            
        END. /* END ELSE (l-gera-com-doc-fisico) */

        RUN getRowErrors    IN h-boin090 (OUTPUT TABLE rowErrors).
        
        /* Verifica se n£mero do documento criado foi alterado */
        IF  CAN-FIND(FIRST RowErrors WHERE rowErrors.errornumber = 5268) THEN DO:
            RUN getRecord IN h-boin090 (OUTPUT TABLE tt-docum-est).

            FOR FIRST tt-docum-est NO-LOCK:
                FIND CURRENT movto-pend EXCLUSIVE-LOCK NO-ERROR.
                IF AVAIL movto-pend THEN 
                    ASSIGN movto-pend.nro-comp = tt-docum-est.nro-docto.
            END.
        END.
        
        /*--- Verifica ocorrància de erros ---*/
        IF  CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
            RETURN "NOK":U.
        ELSE 
            RETURN "OK":U.

    END. /* END IF RowObject.tipo = 2 (Agregado) AND l-cria-documento */
    
    IF  RowObject.numero-ordem <> 0 THEN DO:
        RUN findPrazoCompra ( RowObject.numero-ordem, RowObject.parcela ).
 
        IF  AVAIL prazo-compra THEN
            RUN pi-aloca-ordem-cc ( yes, /* Aloca */ 
                                    RowObject.quantidade,
                                    rowid(prazo-compra) ).
    END.
   
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
    
    if  RowObject.tipo = 1 then do:
        if  RowObject.numero-ordem <> 0 then do:

            run findPrazoCompra ( RowObject.numero-ordem,
                                  RowObject.parcela ).
 
            if  avail prazo-compra then
                run pi-aloca-ordem-cc ( no, /* Desaloca */
                                        RowObject.quantidade,
                                        rowid(prazo-compra) ).
        end.
    end.
    else do: /*Agregado*/
        IF  l-verifica-docto 
        AND l-cria-documento then do:
    
            FOR first b-docum-est
                where b-docum-est.serie-docto  = c-serie-docto
                  and b-docum-est.nro-docto    = c-nro-docto
                  and b-docum-est.nat-operacao = c-nat-operacao
                  and b-docum-est.cod-emitente = i-cod-emitente NO-LOCK: END.
     
            for each tt-docum-est:
                delete tt-docum-est.
            end.
                                        
            create tt-docum-est.
            assign tt-docum-est.cod-emitente = RowObject.cod-emitente
                   tt-docum-est.serie-docto  = RowObject.serie-comp
                   tt-docum-est.nro-docto    = RowObject.nro-comp
                   tt-docum-est.nat-operacao = RowObject.nat-comp
                   tt-docum-est.cod-estabel  = b-docum-est.cod-estabel
                   tt-docum-est.usuario      = b-docum-est.usuario
                   tt-docum-est.cod-observa  = RowObject.cod-observa.
    
            run setRecord in h-boin090 ( input table tt-docum-est ).
    
            run goToKey in h-boin090 ( input tt-docum-est.serie-docto,
                                       input tt-docum-est.nro-docto,
                                       input tt-docum-est.cod-emitente,
                                       input tt-docum-est.nat-operacao ).
    
            run emptyRowErrors in h-boin090.
    
            run deleteRecord in h-boin090.
    
            run getRowErrors in h-boin090 ( output table rowErrors ).
            
            /*--- Verifica ocorrància de erros ---*/
            IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
                RETURN "NOK":U.
            else        
                RETURN "OK":U.
    
            run repositionRecord in h-boin090 ( input rDocumEst).
        end.            
    end.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterNewRecord DBOProgram 
PROCEDURE afterNewRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN findDocumento ( INPUT i-cod-emitente,
                        INPUT c-serie-docto,
                        INPUT c-nro-docto,
                        INPUT c-nat-operacao ).
    IF  RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    FOR FIRST estab-mat
        FIELDS ( cod-estabel-prin  cod-cta-fornec-unif  cod-ccusto-fornec-unif )
        WHERE estab-mat.cod-estabel-prin = docum-est.cod-estabel NO-LOCK: 
    END.
        
    ASSIGN RowObject.serie-comp  = docum-est.serie-docto
           RowObject.nro-comp    = docum-est.nro-docto
           RowObject.cod-observa = docum-est.cod-observa.

    run getSequencia ( output RowObject.sequencia ).

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

    if  RowObject.numero-ordem <> 0 then do:

        run findPrazoCompra ( RowObject.numero-ordem,
                              RowObject.parcela ).
 
        if  avail prazo-compra then do:
            run pi-aloca-ordem-cc ( no, /* Desaloca */
                                    de-qt-ori,
                                    rowid(prazo-compra) ).

            run pi-aloca-ordem-cc ( yes, /* Aloca */
                                    RowObject.quantidade,
                                    rowid(prazo-compra)).
        end.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignDocFisicoKey DBOProgram 
PROCEDURE assignDocFisicoKey :
/*------------------------------------------------------------------------------
  Purpose:     Atribuir valores da chave da doc-fisico ao novo registro da 
               docum-est para posterior chamada da "createDoctoItemOfRecFisico"
               na boin090 (docum-est).
  Parameters:  <none>
  Notes:       Esta procedure deve ser chamada apenas se o registro Ö ser gerado
               na docum-est for baseado em um documento f°sico (doc-fisico),
               re1001h2.
------------------------------------------------------------------------------*/
    
    ASSIGN tt-docum-est.cod-emitente = RowObject.cod-emitente
           tt-docum-est.serie-docto  = RowObject.serie-comp
           tt-docum-est.nro-docto    = RowObject.nro-comp
           tt-docum-est.tipo-nota    = i-tipo-nota-fisico /* Vem da tela do re1001h2 */
           tt-docum-est.nat-operacao = RowObject.nat-comp
           tt-docum-est.cod-observa  = RowObject.cod-observa
           tt-docum-est.dt-trans     = docum-est.dt-trans. 
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE contaUtilizaCentroCusto DBOProgram 
PROCEDURE contaUtilizaCentroCusto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param p-ct-codigo    like item-doc-est.ct-codigo no-undo.
    def input param p-dt-transacao like docum-est.dt-trans no-undo.
    def input param p-cod-estabel  like docum-est.cod-estabel no-undo.
    
    run prgint/utb/utb742za.py persistent set h_api_ccusto.
    
    run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS 2 */
                                                       input  p-cod-estabel,      /* ESTABELECIMENTO EMS2 */
                                                       input  "",                 /* PLANO CONTAS */
                                                       input  p-ct-codigo,        /* CONTA */
                                                       input  p-dt-transacao,     /* DT TRANSACAO */
                                                       output v_log_utz_ccusto,   /* UTILIZA CCUSTO ? */
                                                       output table tt_log_erro). /* ERROS */
           
    delete object h_api_ccusto.
    
    if v_log_utz_ccusto then
        RETURN "OK":U.
    else
        RETURN "NOK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createAcabadoByOP DBOProgram 
PROCEDURE createAcabadoByOP :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-nivel AS INTEGER INIT 1   NO-UNDO.
    DEFINE VARIABLE l-cria  AS LOGICAL INIT YES NO-UNDO.
    
    IF l-cria THEN DO:

        if  not avail docum-est then 
            RETURN "NOK":U.
    
        assign i-cod-emitente = docum-est.cod-emitente
               c-serie-docto  = docum-est.serie-docto
               c-nro-docto    = docum-est.nro-docto
               c-nat-operacao = docum-est.nat-operacao.
               
    
        run openQueryStatic ( input "Main" ).
        
        for each item-doc-est
           where item-doc-est.cod-emitente = docum-est.cod-emitente
             and item-doc-est.serie-docto  = docum-est.serie-docto
             and item-doc-est.nro-docto    = docum-est.nro-docto
             and item-doc-est.nat-operacao = docum-est.nat-operacao
             and item-doc-est.nr-ord-produ <> 0 no-lock:
             
             IF  CAN-FIND(FIRST bf{&tableName}
                          WHERE bf{&tableName}.nr-ord-produ  = item-doc-est.nr-ord-produ 
                            AND bf{&tableName}.quantidade   = item-doc-est.quantidade 
                            AND bf{&tableName}.tipo         = 1                       
                            AND bf{&tableName}.cod-emitente = docum-est.cod-emitente  
                            AND bf{&tableName}.serie-docto  = docum-est.serie-docto   
                            AND bf{&tableName}.nro-docto    = docum-est.nro-docto     
                            AND bf{&tableName}.nat-operacao = docum-est.nat-operacao  
                            AND bf{&tableName}.cod-depos    = item-doc-est.cod-depos
                            AND bf{&tableName}.sequencia    = item-doc-est.sequencia) THEN
                 NEXT.
    
             run emptyRowErrors.
             
             run emptyRowObject.
             
             run newRecord.
             
             assign RowObject.nr-ord-produ  = item-doc-est.nr-ord-produ
                    RowObject.quantidade   = item-doc-est.quantidade
                    RowObject.tipo         = 1
                    RowObject.cod-emitente = docum-est.cod-emitente
                    RowObject.serie-docto  = docum-est.serie-docto 
                    RowObject.nro-docto    = docum-est.nro-docto
                    RowObject.nat-operacao = docum-est.nat-operacao
                    RowObject.cod-depos    = item-doc-est.cod-depos
                    RowObject.cod-localiz  = item-doc-est.cod-localiz.

            
             run findOrdProd ( RowObject.nr-ord-produ ).

             if  avail ord-prod THEN DO:
                  assign RowObject.it-codigo      = ord-prod.it-codigo.
      
                  run findItem ( RowObject.it-codigo ).

                  if  return-value = "NOK":U then
                      return "NOK":U.

                  run findItemUniEstab ( RowObject.it-codigo,
                                         docum-est.cod-estabel ).

                  assign RowObject.cod-depos   = if  avail item-uni-estab
                                                 then item-uni-estab.deposito-pad
                                                 else item.deposito-pad.
                  assign RowObject.cod-localiz = if avail item-uni-estab 
                                                 then item-uni-estab.cod-localiz 
                                                 else item.cod-localiz.
             
             END.

             run createRecord.
            
             if  return-value <> "OK":U then 
                RETURN "NOK":U.
             
        end.         
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createByDocFisico DBOProgram 
PROCEDURE createByDocFisico :
/*------------------------------------------------------------------------------
  Purpose:     Atribuir vari†vel que indica que o registro Ö ser gerado Ç 
               baseado em um documento do recebimento f°sico.
  Parameters:  l-p-true-or-false -> True ou False -> Indicador Ö ser atribu°do.
               i-p-tipo-nota     -> Tipo da nota -> Inicialmente sempre ser† 1
                                                    (Compra) - re1001h2.
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER l-p-true-or-false AS LOGICAL NO-UNDO.
    DEFINE INPUT PARAMETER i-p-tipo-nota     AS INTEGER NO-UNDO.

    ASSIGN l-gera-com-doc-fisico = l-p-true-or-false
           i-tipo-nota-fisico    = i-p-tipo-nota.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableFields DBOProgram 
PROCEDURE enableFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
        1. Input pType          -> Tipo de Transaá∆o ( "Create" ou "Update" ) 
        2. Input pFieldName     -> Atributo da Tabela Item-Doc-Est
        3. Output pFieldEnable  -> Habilita ou N∆o o Atributo 
  Notes:       
        PrÇ-requisitos:
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER  pType        AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER  pFieldName   AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldEnable AS LOGICAL   NO-UNDO.
    
    
    IF  NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "nr-ord-produ":U      THEN ASSIGN pFieldEnable =   avail param-global
                                                            and param-global.modulo-cp
                                                            and pType = "Create":U.
                                                            
        WHEN "it-codigo":U         THEN ASSIGN pFieldEnable =   avail param-global
                                                            and not param-global.modulo-cp.

        WHEN "num-pedido":U        THEN ASSIGN pFieldEnable =   avail param-global
                                                            and not param-global.modulo-cp.

        WHEN "numero-ordem":U      THEN ASSIGN pFieldEnable =   avail param-global
                                                            and not param-global.modulo-cp.

        WHEN "parcela":U           THEN ASSIGN pFieldEnable =   avail param-global
                                                            and not param-global.modulo-cp.

        WHEN "cod-refer":U         THEN ASSIGN pFieldEnable =   avail param-global
                                                            and not param-global.modulo-cp
                                                            and (  pType = "Create":U 
                                                                or ( avail item and item.tipo-con-est = 4 )).

        WHEN "ct-codigo":U         THEN ASSIGN pFieldEnable =   avail param-global
                                                            and not param-global.modulo-cp.
                                                            
        WHEN "sc-codigo":U         THEN ASSIGN pFieldEnable =   avail param-global
                                                            and not param-global.modulo-cp.                                                            

        WHEN "preco-total":U       THEN ASSIGN pFieldEnable =   avail param-global
                                                            and not param-global.modulo-cp.

        WHEN "proporcao":U         THEN ASSIGN pFieldEnable =   avail param-global
                                                            and not param-global.modulo-cp.

        WHEN "cod-localiz":U       THEN ASSIGN pFieldEnable =  pType = "Create":U  
                                                            or ( avail item
                                                            and not item.loc-unica ).                                                            

        WHEN "lote":U              THEN ASSIGN pFieldEnable =  pType = "Create":U  
                                                            or ( avail item
                                                            and can-do("2,3,4",string(item.tipo-con-est)) ).                                                            
                                                            
        WHEN "dt-vali-lote":U      THEN ASSIGN pFieldEnable = pType = "Create":U 
                                                            or  ( avail item
                                                            and can-do("3,4",string(item.tipo-con-est))).                                                            
                                                            
        WHEN "ct-aplic":U          THEN ASSIGN pFieldEnable =   avail item
                                                            and can-do("1,4",string(item.tipo-contr)).
                                                            
        WHEN "sc-aplic":U          THEN ASSIGN pFieldEnable =   avail item
                                                            and can-do("1,4",string(item.tipo-contr)).                                                            
        
        WHEN "log-1":U             THEN ASSIGN pFieldEnable =   avail param-re
                                                            and param-re.encerra-cc
                                                            and ( ( avail RowObject 
                                                                    and RowObject.numero-ordem <> 0 )
                                                               or pType = "Create":U ).

        WHEN "valor-mat[1]":U      THEN ASSIGN pFieldEnable =   avail param-global
                                                            and not param-global.modulo-cp.
                                                            
        WHEN "valor-mat[2]":U      THEN ASSIGN pFieldEnable =   avail param-global
                                                            and not param-global.modulo-cp.

        WHEN "valor-mat[3]":U      THEN ASSIGN pFieldEnable =   avail param-global
                                                            and not param-global.modulo-cp.

        WHEN "valor-mob[1]":U      THEN ASSIGN pFieldEnable =   avail param-global
                                                            and not param-global.modulo-cp.

        WHEN "valor-mob[2]":U      THEN ASSIGN pFieldEnable =   avail param-global
                                                            and not param-global.modulo-cp.

        WHEN "valor-mob[3]":U      THEN ASSIGN pFieldEnable =   avail param-global
                                                            and not param-global.modulo-cp.

        WHEN "narrativa":U         THEN ASSIGN pFieldEnable =  pType = "Create":U 
                                                            and ( avail item
                                                            and item.tipo-contr = 4 ).
        
        OTHERWISE ASSIGN pFieldEnable = yes.
        
    END CASE.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findCentroCusto DBOProgram 
PROCEDURE findCentroCusto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piScCodigo   like item-doc-est.sc-codigo no-undo.
    def input param dt-transacao like docum-est.dt-trans no-undo.
    
    run prgint/utb/utb742za.py persistent set h_api_ccusto.
    
    /* Busca dados do centro de custo */
    run pi_busca_dados_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                               input  "",                 /* CODIGO DO PLANO CCUSTO */
                                               input  piScCodigo,         /* CCUSTO */
                                               input  dt-transacao,       /* DATA DE TRANSACAO */
                                               output v_titulo_ccusto,    /* DESCRICAO DO CCUSTO */
                                               output table tt_log_erro). /* ERROS */

    find first tt_log_erro no-lock no-error.
    if avail tt_log_erro then do:
       {utp/ut-liter.i "Centro_Custo" *}
       ASSIGN c-lbl-liter-msg = TRIM(RETURN-VALUE).
       {method/svc/errors/inserr.i
                           &ErrorNumber="2"
                           &ErrorType="EMS"
                           &ErrorSubType="ERROR" 
                           &ErrorParameters="c-lbl-liter-msg"}
                               
       delete object h_api_ccusto.
       RETURN "NOK":U.      
    end.
    
    delete object h_api_ccusto.
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findContaContabil DBOProgram 
PROCEDURE findContaContabil :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piCtCodigo   like item-doc-est.ct-codigo no-undo.
    def input param dt-transacao like docum-est.dt-trans no-undo.
    
    run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
    
    run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,          /* EMPRESA EMS2 */
                                                   input        "",                 /* PLANO DE CONTAS */
                                                   input-output piCtCodigo,         /* CONTA */
                                                   input        dt-transacao,       /* DATA TRANSACAO */   
                                                   output       v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                   output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                   output       v_num_sit_cta_ctbl, /* SITUAõ¯O DA CONTA */
                                                   output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                   output table tt_log_erro).       /* ERROS */    
    
    delete object h_api_cta_ctbl.
    
    if return-value = "NOK" and piCtCodigo <> "" then do:
        {utp/ut-liter.i "Conta_Cont†bil" *}
        ASSIGN c-lbl-liter-msg = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"
                            &ErrorParameters="c-lbl-liter-msg"}
        RETURN "NOK":U.
    end.
    else         
        RETURN "OK":U.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findDeposito DBOProgram 
PROCEDURE findDeposito :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piCodDepos   like movto-pend.cod-depos no-undo.
    
    if  not avail deposito
    or  deposito.cod-depos <> piCodDepos then 
    
        for first deposito fields ( cod-depos nome )
            where deposito.cod-depos = piCodDepos no-lock.
        end.
        
    if  not avail deposito then do:
        {utp/ut-liter.i "Dep¢sito" *}
        ASSIGN c-lbl-liter-msg = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lbl-liter-msg"}
        RETURN "NOK":U.
    end.
    else         
        RETURN "OK":U.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findDocumento DBOProgram 
PROCEDURE findDocumento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piCod-emit   like item-doc-est.cod-emitente no-undo.
    def input param piSerie      like item-doc-est.serie-docto  no-undo.
    def input param piNro-docto  like item-doc-est.nro-docto    no-undo.
    def input param piNat-oper   like item-doc-est.nat-operacao no-undo.
    
    
    if  not avail docum-est 
    or  (docum-est.serie-docto  <> piSerie     AND piSerie     <> "")
    or  (docum-est.nro-docto    <> piNro-docto AND piNro-docto <> "")
    or  (docum-est.nat-operacao <> piNat-oper  AND piNat-oper  <> "")
    or  (docum-est.cod-emitente <> piCod-emit  AND piCod-emit  <> 0 ) then 
    
        for first docum-est
            fields ( serie-docto   nro-docto     nat-operacao
                     cod-emitente  esp-docto     cod-estabel
                     rec-fisico    usuario       mod-atual
                     dt-trans      dt-emissao    tot-desconto
                     cod-observa   cp-atual      ce-atual 
                     nff                                       )
                     
            where docum-est.serie-docto  = piSerie
              and docum-est.nro-docto    = piNro-docto
              and docum-est.nat-operacao = piNat-oper
              and docum-est.cod-emitente = piCod-emit no-lock.
        end.

    if  not avail docum-est then do:
        {utp/ut-liter.i "Documento" *}
        ASSIGN c-lbl-liter-msg = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lbl-liter-msg"}
        RETURN "NOK":U.
    end.
    else         
        RETURN "OK":U.        


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findEmitente DBOProgram 
PROCEDURE findEmitente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piEmitente   like item-doc-est.cod-emitente no-undo.
    
    if  not avail emitente
    or  emitente.cod-emitente <> piEmitente then 
    
        for first emitente
            fields ( cod-emitente  nome-abrev )
                     
            where emitente.cod-emitente = piEmitente no-lock.
        end.
        
    if  not avail emitente then do:
        {utp/ut-liter.i "Emitente" *}
        ASSIGN c-lbl-liter-msg = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lbl-liter-msg"}
        RETURN "NOK":U.
    end.
    else         
        RETURN "OK":U.  


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findEstabelec DBOProgram 
PROCEDURE findEstabelec :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piEstab   like docum-est.cod-estabel no-undo.
    
    assign i-empresa = param-global.empresa-prin.
    
    if  not avail estabelec
    or  estabelec.cod-estabel <> piEstab then 
    
        for first estabelec
            fields ( cod-estabel  cod-emitente
                     estado                    )
                     
            where estabelec.cod-estabel = piEstab no-lock.
        end.
        
    if  not avail estabelec then do:
        {utp/ut-liter.i "Estabelecimento" *}
        ASSIGN c-lbl-liter-msg = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lbl-liter-msg"}
        RETURN "NOK":U.
    end.
    else do:

        assign i-empresa = estabelec.ep-codigo.
        
        RETURN "OK":U.        
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findItem DBOProgram 
PROCEDURE findItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piItem   like item-doc-est.it-codigo no-undo.
    
    if  not avail item
    or  item.it-codigo <> piItem then 
    
        for first item
            fields ( it-codigo tipo-contr tipo-con-est cod-obsoleto un loc-unica
                     deposito-pad cod-localiz ct-codigo sc-codigo desc-item )
            where item.it-codigo = piItem no-lock.
        end.
        
    if  not avail item then do:
        {utp/ut-liter.i "Item" *}
        ASSIGN c-lbl-liter-msg = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lbl-liter-msg"}
        RETURN "NOK":U.
    end.
    else         
        RETURN "OK":U.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findItemFornec DBOProgram 
PROCEDURE findItemFornec :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piItem     like item-doc-est.it-codigo    no-undo.
    def input param piEmitente like item-doc-est.cod-emitente no-undo.    
        
    if  piEmitente = 0 then
        assign piEmitente = RowObject.cod-emitente.
            
    if  not avail item-fornec
    or  item-fornec.it-codigo <> piItem
    or  item-fornec.cod-emitente  <> piEmitente  then 
    
        for first item-fornec fields ( it-codigo cod-emitente unid-med-for )
            where item-fornec.it-codigo    = piItem
              and item-fornec.cod-emitente = piEmitente no-lock.
        end.
        
    if  not avail item-fornec then 
        RETURN "NOK":U.
    else         
        RETURN "OK":U.   

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findItemUniEstab DBOProgram 
PROCEDURE findItemUniEstab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piItem  like item-doc-est.it-codigo no-undo.
    def input param piEstab like docum-est.cod-estabel  no-undo.
    
    if  not avail item-uni-estab
    or  item-uni-estab.cod-estabel <> piEstab
    or  item-uni-estab.it-codigo   <> piItem then 

        for first item-uni-estab
            fields ( it-codigo  cod-estabel deposito-pad
                     var-qtd-re lim-var-qtd cod-localiz)
            where item-uni-estab.it-codigo   = RowObject.it-codigo
              and item-uni-estab.cod-estabel = docum-est.cod-estabel no-lock.
            
        end.

    if  not avail item-uni-estab then do:
        {utp/ut-liter.i "Item_Estabelecimento" *}
        ASSIGN c-lbl-liter-msg = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lbl-liter-msg"}
        RETURN "NOK":U.
    end.
    else         
        RETURN "OK":U.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findLocalizacao DBOProgram 
PROCEDURE findLocalizacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piEstab   like docum-est.cod-estabel    no-undo.
    def input param piLocaliz like item-doc-est.cod-localiz no-undo.
    def input param piDepos   like item-doc-est.cod-depos   no-undo.
    
    if  not avail localizacao
    or  localizacao.cod-estabel <> piEstab
    or  localizacao.cod-localiz <> piLocaliz 
    or  localizacao.cod-depos   <> piDepos then 
    
        for first localizacao
            fields ( cod-estabel cod-localiz cod-depos descricao )
            where localizacao.cod-estabel = piEstab
              and localizacao.cod-localiz = piLocaliz
              and localizacao.cod-depos   = piDepos  no-lock.
        end.
        
    if  not avail localizacao then do:
        {utp/ut-liter.i "Localizaá∆o" *}
        ASSIGN c-lbl-liter-msg = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lbl-liter-msg"}
        RETURN "NOK":U.
    end.
    else         
        RETURN "OK":U.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findMovtoPend DBOProgram 
PROCEDURE findMovtoPend :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piCod-emit   like movto-pend.cod-emitente  no-undo.
    def input param piSerie      like movto-pend.serie-docto   no-undo.
    def input param piNro-docto  like movto-pend.nro-docto     no-undo.
    def input param piNat-oper   like movto-pend.nat-operacao  no-undo.
    def input param piTipo       like movto-pend.tipo          no-undo.
    
    for last movto-pend
        fields ( serie-docto nro-docto nat-operacao
                 cod-emitente  sequencia  tipo )
        where movto-pend.cod-emitente = piCod-emit
          and movto-pend.serie-docto  = piSerie
          and movto-pend.nro-docto    = piNro-docto
          and movto-pend.nat-operacao = piNat-oper 
          and movto-pend.tipo         = piTipo  no-lock.
    end.

    RETURN "OK":U.        

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findNaturOper DBOProgram 
PROCEDURE findNaturOper :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piNatOperacao   like docum-est.nat-operacao no-undo.
    
    if  not avail natur-oper
    or  natur-oper.nat-operacao <> piNatOperacao then 
    
        for first natur-oper
            fields ( nat-operacao     denominacao 
                     tipo             transf
                     terceiros        emite-duplic )
            where natur-oper.nat-operacao = piNatOperacao no-lock.
        end.
        
    if  not avail natur-oper then do:
        {utp/ut-liter.i "Natureza_de_Operaá∆o" *}
        ASSIGN c-lbl-liter-msg = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lbl-liter-msg"}
        RETURN "NOK":U.
    end.
    else         
        RETURN "OK":U.     


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findOrdemCompra DBOProgram 
PROCEDURE findOrdemCompra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piOrdem   like item-doc-est.numero-ordem no-undo.
    
    if  not avail ordem-compra
    or  ordem-compra.numero-ordem <> piOrdem then 

        for first ordem-compra
            fields ( numero-ordem   num-pedido    it-codigo 
                     ct-codigo      sc-codigo     dep-almoxar     
                     nr-contrato    narrativa )
            where ordem-compra.numero-ordem = piOrdem no-lock.
        end.
        
    if  not avail ordem-compra then do:
        {utp/ut-liter.i "N£mero_Ordem" *}
        ASSIGN c-lbl-liter-msg = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lbl-liter-msg"}
        RETURN "NOK":U.
    end.
    else         
        RETURN "OK":U.       
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findOrdProd DBOProgram 
PROCEDURE findOrdProd :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piNrOrdProd   like movto-pend.nr-ord-produ no-undo.
    
    if  not avail ord-prod
    or  ord-prod.nr-ord-produ <> piNrOrdProd then 
    
        for first ord-prod
            fields ( nr-ord-produ it-codigo    ct-codigo sc-codigo un
                     qt-ordem    qt-produzida cod-refer 
                     lote-serie  cod-estabel )
            where ord-prod.nr-ord-produ = piNrOrdProd no-lock.
        end.
        
    if  not avail ord-prod then do:
        {utp/ut-liter.i "Ordem_Produá∆o" *}
        ASSIGN c-lbl-liter-msg = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lbl-liter-msg"}
        RETURN "NOK":U.
    end.
    else         
        RETURN "OK":U.      

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findPedidoCompr DBOProgram 
PROCEDURE findPedidoCompr :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piPedido   like item-doc-est.num-pedido no-undo.
    
    if  not avail pedido-compr
    or  pedido-compr.num-pedido <> piPedido then 

        for first pedido-compr
            fields ( num-pedido cod-emitente situacao natureza )
            where pedido-compr.num-pedido = piPedido no-lock.
        end.
        
    if  not avail pedido-compr then do:
        {utp/ut-liter.i "N£mero_Pedido" *}
        ASSIGN c-lbl-liter-msg = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lbl-liter-msg"}
        RETURN "NOK":U.
    end.
    else         
        RETURN "OK":U.       

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findPrazoCompra DBOProgram 
PROCEDURE findPrazoCompra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piOrdem   like item-doc-est.numero-ordem no-undo.
    def input param piParcela like item-doc-est.parcela      no-undo.
    
    if  not avail prazo-compra
    or  prazo-compra.parcela <> piParcela then 

        for first prazo-compra
            fields ( parcela numero-ordem
                     situacao quant-saldo dec-1 )
            where prazo-compra.numero-ordem = piOrdem
              and prazo-compra.parcela      = piParcela no-lock.
        end.
        
    if  not avail prazo-compra then do:
        {utp/ut-liter.i "Parcela" *}
        ASSIGN c-lbl-liter-msg = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lbl-liter-msg"}
        RETURN "NOK":U.
    end.
    else         
        RETURN "OK":U.       


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findReferencia DBOProgram 
PROCEDURE findReferencia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param pi-refer like referencia.cod-refer no-undo.
    
    for first referencia fields()
        where referencia.cod-refer = pi-refer no-lock:
    end.
    
    if  not avail referencia then do:
        {utp/ut-liter.i "Referància" *}
        ASSIGN c-lbl-liter-msg = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                            &ErrorNumber="2" /* N∆o foi encontrada referencia */
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"
                            &ErrorParameters="c-lbl-liter-msg" }
        return "NOK":U.
    end.
    
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findSaldoEstoq DBOProgram 
PROCEDURE findSaldoEstoq :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piItem    like movto-pend.it-codigo no-undo.
    def input param piLote    like movto-pend.lote      no-undo.
    
    if  not avail saldo-estoq
    or  saldo-estoq.it-codigo <> piItem
    or  saldo-estoq.lote      <> piLote then 

        for first saldo-estoq fields ( it-codigo lote dt-vali-lote cod-refer )
            where saldo-estoq.it-codigo = piItem
              and saldo-estoq.lote      = piLote no-lock.
        end.
        
    if  not avail saldo-estoq then 
        RETURN "NOK":U.
    else         
        RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findUnidade DBOProgram 
PROCEDURE findUnidade :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piUn   like movto-pend.un no-undo.
    
    if  not avail tab-unidade
    or  tab-unidade.un <> piUn then 
    
        for first tab-unidade fields ( un descricao )
            where tab-unidade.un = piUn no-lock.
        end.
        
    if  not avail tab-unidade then do:
        {utp/ut-liter.i "Unidade_de_Medida" *}
        ASSIGN c-lbl-liter-msg = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lbl-liter-msg"}
        RETURN "NOK":U.
    end.
    else         
        RETURN "OK":U.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findUsuario DBOProgram 
PROCEDURE findUsuario :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    if  avail docum-est then do:
        if  not avail param-re
        or  param-re.usuario <> docum-est.usuario then 
    
            for first param-re
                where param-re.usuario = docum-est.usuario no-lock.
            end.
    end.
        
    if  not avail param-re
    or  not avail docum-est then do:
        {utp/ut-liter.i "Usu†rio_Recebimento" *}
        ASSIGN c-lbl-liter-msg = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lbl-liter-msg"}
        RETURN "NOK":U.
    end.
    else         
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
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-depos":U THEN ASSIGN pFieldValue = RowObject.cod-depos.
        WHEN "cod-localiz":U THEN ASSIGN pFieldValue = RowObject.cod-localiz.
        WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
        WHEN "ct-aplic":U THEN ASSIGN pFieldValue = RowObject.ct-aplic.
        WHEN "ct-codigo":U THEN ASSIGN pFieldValue = RowObject.ct-codigo.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "lote":U THEN ASSIGN pFieldValue = RowObject.lote.
        WHEN "narrativa":U THEN ASSIGN pFieldValue = RowObject.narrativa.
        WHEN "nat-operacao":U THEN ASSIGN pFieldValue = RowObject.nat-operacao.
        WHEN "nro-docto":U THEN ASSIGN pFieldValue = RowObject.nro-docto.
        WHEN "sc-aplic":U THEN ASSIGN pFieldValue = RowObject.sc-aplic.
        WHEN "sc-codigo":U THEN ASSIGN pFieldValue = RowObject.sc-codigo.
        WHEN "serie-docto":U THEN ASSIGN pFieldValue = RowObject.serie-docto.
        WHEN "un":U THEN ASSIGN pFieldValue = RowObject.un.
        WHEN "serie-comp":U THEN ASSIGN pFieldValue = RowObject.serie-comp.
        WHEN "nro-comp":U THEN ASSIGN pFieldValue = RowObject.nro-comp.
        WHEN "nat-comp":U THEN ASSIGN pFieldValue = RowObject.nat-comp.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getContaContabil DBOProgram 
PROCEDURE getContaContabil :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def output param c-ct-codigo like movto-pend.ct-codigo no-undo.
    def output param c-sc-codigo like movto-pend.sc-codigo no-undo.

    if  not avail docum-est then
        return "NOK":U.
        
    for first estab-mat
        fields ( cod-estabel-prin cod-cta-fornec-unif cod-ccusto-fornec-unif )        
        where estab-mat.cod-estabel = docum-est.cod-estabel no-lock:
    end.
        
    assign c-ct-codigo = if  avail estab-mat 
                             then estab-mat.cod-cta-fornec-unif    /* cod-cta-fornec-unif */
                             else "".
    assign c-sc-codigo = if  avail estab-mat 
                             then estab-mat.cod-ccusto-fornec-unif    /* cod-ccusto-fornec-unif */
                             else "".
    
    return "OK":U.                              

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
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
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
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "desconto-agreg":U THEN ASSIGN pFieldValue = RowObject.desconto-agreg.
        WHEN "quantidade":U THEN ASSIGN pFieldValue = RowObject.quantidade.
        WHEN "valor-ggf-m[1]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-m[1].
        WHEN "valor-ggf-m[2]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-m[2].
        WHEN "valor-ggf-m[3]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-m[3].
        WHEN "valor-ggf-o[1]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-o[1].
        WHEN "valor-ggf-o[2]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-o[2].
        WHEN "valor-ggf-o[3]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-o[3].
        WHEN "valor-ggf-p[1]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-p[1].
        WHEN "valor-ggf-p[2]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-p[2].
        WHEN "valor-ggf-p[3]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-p[3].
        WHEN "valor-mat[1]":U THEN ASSIGN pFieldValue = RowObject.valor-mat[1].
        WHEN "valor-mat[2]":U THEN ASSIGN pFieldValue = RowObject.valor-mat[2].
        WHEN "valor-mat[3]":U THEN ASSIGN pFieldValue = RowObject.valor-mat[3].
        WHEN "valor-mat-m[1]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-m[1].
        WHEN "valor-mat-m[2]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-m[2].
        WHEN "valor-mat-m[3]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-m[3].
        WHEN "valor-mat-o[1]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-o[1].
        WHEN "valor-mat-o[2]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-o[2].
        WHEN "valor-mat-o[3]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-o[3].
        WHEN "valor-mat-p[1]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-p[1].
        WHEN "valor-mat-p[2]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-p[2].
        WHEN "valor-mat-p[3]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-p[3].
        WHEN "valor-mob[1]":U THEN ASSIGN pFieldValue = RowObject.valor-mob[1].
        WHEN "valor-mob[2]":U THEN ASSIGN pFieldValue = RowObject.valor-mob[2].
        WHEN "valor-mob[3]":U THEN ASSIGN pFieldValue = RowObject.valor-mob[3].
        WHEN "valor-mob-m[1]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-m[1].
        WHEN "valor-mob-m[2]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-m[2].
        WHEN "valor-mob-m[3]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-m[3].
        WHEN "valor-mob-o[1]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-o[1].
        WHEN "valor-mob-o[2]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-o[2].
        WHEN "valor-mob-o[3]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-o[3].
        WHEN "valor-mob-p[1]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-p[1].
        WHEN "valor-mob-p[2]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-p[2].
        WHEN "valor-mob-p[3]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-p[3].
        WHEN "vl-mat-agreg[1]":U THEN ASSIGN pFieldValue = RowObject.vl-mat-agreg[1].
        WHEN "vl-mat-agreg[2]":U THEN ASSIGN pFieldValue = RowObject.vl-mat-agreg[2].
        WHEN "vl-mat-agreg[3]":U THEN ASSIGN pFieldValue = RowObject.vl-mat-agreg[3].
        WHEN "vl-mat-env[1]":U THEN ASSIGN pFieldValue = RowObject.vl-mat-env[1].
        WHEN "vl-mat-env[2]":U THEN ASSIGN pFieldValue = RowObject.vl-mat-env[2].
        WHEN "vl-mat-env[3]":U THEN ASSIGN pFieldValue = RowObject.vl-mat-env[3].
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescriptionFields DBOProgram 
PROCEDURE getDescriptionFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input  param pFieldName        as char no-undo.
    def output param pDescription      as char no-undo.

    CASE pFieldName:
        WHEN "desc-natur":U     THEN ASSIGN pDescription = if  avail natur-oper then 
                                                               natur-oper.denominacao
                                                           else "".
        WHEN "desc-conta":U     THEN ASSIGN pDescription = v_titulo_cta_ctbl.
        WHEN "desc-ccusto":U    THEN ASSIGN pDescription = v_titulo_ccusto.
        WHEN "desc-item":U      THEN ASSIGN pDescription = if  avail item then
                                                               item.desc-item
                                                           else
                                                               "".

        WHEN "un":U             THEN ASSIGN pDescription = if  avail RowObject then 
                                                               RowObject.un
                                                           else 
                                                           if  avail item-fornec then 
                                                               item-fornec.unid-med-for
                                                           else 
                                                           if  avail item then 
                                                               item.un 
                                                           else 
                                                               " ".

        WHEN "ord-prod.item":U  THEN ASSIGN pDescription = if  avail ord-prod then
                                                               ord-prod.it-codigo
                                                           else "".   
                                                           
        WHEN "ord-prod.un":U    THEN ASSIGN pDescription = if  avail ord-prod then
                                                               ord-prod.un
                                                           else "".   
        OTHERWISE RETURN "NOK":U.
        
    END CASE.

    RETURN "OK":U.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getFormatoConta DBOProgram 
PROCEDURE getFormatoConta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF OUTPUT PARAM p-format-conta AS CHAR NO-UNDO.

    run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.

    EMPTY TEMP-TABLE tt_log_erro.

    ASSIGN v_cod_formato = ''.

    run pi_retorna_formato_cta_ctbl in h_api_cta_ctbl (input  i-empresa,          /* EMPRESA EMS2 */
                                                       input  "",                 /* PLANO CONTAS */
                                                       input  today,              /* DATA DE TRANSACAO */ 
                                                       output v_cod_formato,      /* FORMATO CONTA */
                                                       output table tt_log_erro). /* ERROS */

    ASSIGN p-format-conta = v_cod_formato.

    delete object h_api_cta_ctbl.

    RETURN "ok".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getInitialValues DBOProgram 
PROCEDURE getInitialValues :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piQuantidade like movto-pend.quantidade no-undo.
    
    assign de-qt-ori = piQuantidade.
    
    return "OK":U.

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
        WHEN "cd-trib-icm":U THEN ASSIGN pFieldValue = RowObject.cd-trib-icm.
        WHEN "cd-trib-ipi":U THEN ASSIGN pFieldValue = RowObject.cd-trib-ipi.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "nr-ord-produ":U THEN ASSIGN pFieldValue = RowObject.nr-ord-produ.
        WHEN "nr-reporte":U THEN ASSIGN pFieldValue = RowObject.nr-reporte.
        WHEN "num-pedido":U THEN ASSIGN pFieldValue = RowObject.num-pedido.
        WHEN "numero-ordem":U THEN ASSIGN pFieldValue = RowObject.numero-ordem.
        WHEN "parcela":U THEN ASSIGN pFieldValue = RowObject.parcela.
        WHEN "sequencia":U THEN ASSIGN pFieldValue = RowObject.sequencia.
        WHEN "tipo":U THEN ASSIGN pFieldValue = RowObject.tipo.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice documento
  Parameters:  
               retorna valor do campo serie-docto
               retorna valor do campo nro-docto
               retorna valor do campo cod-emitente
               retorna valor do campo nat-operacao
               retorna valor do campo tipo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pserie-docto LIKE movto-pend.serie-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pnro-docto LIKE movto-pend.nro-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE movto-pend.cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pnat-operacao LIKE movto-pend.nat-operacao NO-UNDO.
    DEFINE OUTPUT PARAMETER ptipo LIKE movto-pend.tipo NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pserie-docto  = RowObject.serie-docto
           pnro-docto    = RowObject.nro-docto
           pcod-emitente = RowObject.cod-emitente
           pnat-operacao = RowObject.nat-operacao
           ptipo         = RowObject.tipo.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey1 DBOProgram 
PROCEDURE getKey1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Retorna os campos para navegaá∆o no re1001H.w       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE movto-pend.cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pserie-docto LIKE movto-pend.serie-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pnro-docto LIKE movto-pend.nro-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pnat-operacao LIKE movto-pend.nat-operacao NO-UNDO.


    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pserie-docto  = RowObject.serie-comp
           pnro-docto    = RowObject.nro-comp
           pcod-emitente = RowObject.cod-emitente
           pnat-operacao = RowObject.nat-comp.
           

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getkeyDocumEst DBOProgram 
PROCEDURE getkeyDocumEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def output param pi-cod-emitente as int  no-undo.
    def output param pc-serie-docto  as char no-undo.
    def output param pc-nro-docto    as char no-undo.
    def output param pc-nat-docto    as char no-undo.

    assign pi-cod-emitente = i-cod-emitente
           pc-serie-docto  = c-serie-docto
           pc-nro-docto    = c-nro-docto
           pc-nat-docto    = c-nat-operacao.
           

    return "OK":U.

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
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getSequencia DBOProgram 
PROCEDURE getSequencia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def output param piSeq like movto-pend.sequencia no-undo.
    
    if not avail param-re then
        find param-re where param-re.usuario = docum-est.usuario no-lock no-error.
    if  not avail docum-est then
        return "NOK":U.
        
    find last b-movto-pend
        where b-movto-pend.cod-emitente = docum-est.cod-emitente
          and b-movto-pend.serie-docto  = docum-est.serie-docto
          and b-movto-pend.nro-docto    = docum-est.nro-docto
          and b-movto-pend.nat-operacao = docum-est.nat-operacao no-lock no-error.
    
    if  avail b-movto-pend then do:
        repeat:
            assign piSeq = b-movto-pend.sequencia + param-re.inc-seq.
            find first b-movto-pend
                where b-movto-pend.cod-emitente = docum-est.cod-emitente
                  and b-movto-pend.serie-docto  = docum-est.serie-docto
                  and b-movto-pend.nro-docto    = docum-est.nro-docto
                  and b-movto-pend.nat-operacao = docum-est.nat-operacao 
                  and b-movto-pend.sequencia    = piSeq no-lock no-error.
            if  not avail b-movto-pend then leave.      
        end.
    end.        
    else             
        assign piSeq = param-re.seq-item-um.
           
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getValidaCcusto DBOProgram 
PROCEDURE getValidaCcusto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM p-ccuto       AS CHAR NO-UNDO.
    DEF OUTPUT PARAM p-desc-ccusto AS CHAR NO-UNDO.

    ASSIGN p-desc-ccusto = ''.

    run prgint/utb/utb742za.py persistent set h_api_ccusto.

    run pi_busca_dados_ccusto in h_api_ccusto (input  STRING(i-empresa),  /* EMPRESA EMS2 */
                                               input  "",                 /* CODIGO DO PLANO CCUSTO */
                                               input  p-ccuto,            /* CCUSTO */
                                               input  today,              /* DATA DE TRANSACAO */
                                               output v_des_ccusto,       /* DESCRICAO DO CCUSTO */
                                               output table tt_log_erro). /* ERROS */
    delete object h_api_ccusto.
    IF RETURN-VALUE = "NOK" THEN
        RETURN "NOK".
    
    ASSIGN p-desc-ccusto = v_des_ccusto.

    RETURN "ok".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getValidaConta DBOProgram 
PROCEDURE getValidaConta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT-OUTPUT PARAM p-conta        AS CHAR NO-UNDO.
    DEF INPUT        PARAM p-cod-estabel  AS CHAR NO-UNDO.    
    DEF INPUT        PARAM p-dt-transacao AS DATE NO-UNDO.
    DEF OUTPUT       PARAM p-desc-conta   AS CHAR NO-UNDO.
    DEF OUTPUT       PARAM p-utiliza-cc   AS LOG  NO-UNDO.
    

    ASSIGN p-desc-conta = ''.

    run prgint/utb/utb742za.py persistent set h_api_ccusto.
    run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.

    EMPTY TEMP-TABLE tt_log_erro.

    RUN pi_busca_dados_cta_ctbl IN h_api_cta_ctbl (INPUT        i-empresa,          /* EMPRESA EMS2 */
                                                   INPUT        "",                 /* PLANO DE CONTAS */
                                                   INPUT-OUTPUT p-conta,            /* CONTA */
                                                   INPUT        p-dt-transacao,     /* DATA TRANSACAO */   
                                                   OUTPUT       v_des_cta_ctbl,     /* DESCRICAO CONTA */
                                                   OUTPUT       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                   OUTPUT       v_num_sit_cta_ctbl, /* SITUA∞ÄO DA CONTA */
                                                   OUTPUT       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                   OUTPUT TABLE tt_log_erro).       /* ERROS */
    delete object h_api_cta_ctbl.
    IF RETURN-VALUE = "NOK" THEN
        RETURN "NOK".

    run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS 2 */
                                                       input  p-cod-estabel,      /* ESTABELECIMENTO EMS2 */
                                                       input  "",                 /* PLANO CONTAS */
                                                       input  p-conta,            /* CONTA */
                                                       input  p-dt-transacao,     /* DT TRANSACAO */
                                                       output v_log_utz_ccusto,   /* UTILIZA CCUSTO ? */
                                                       output table tt_log_erro). /* ERROS */
    delete object h_api_ccusto.
    IF RETURN-VALUE = "NOK" THEN
        RETURN "NOK".

    ASSIGN p-desc-conta = v_des_cta_ctbl
           p-utiliza-cc = v_log_utz_ccusto.

    RETURN "ok".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getValuesItemUniEstab DBOProgram 
PROCEDURE getValuesItemUniEstab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def output param de-var-perc-qt   as decimal no-undo.
    def output param de-var-lim-qt    as decimal no-undo.

    run findItemUniEstab ( RowObject.it-codigo,
                           docum-est.cod-estabel ).

    if  not avail item-uni-estab
    or (     avail item-uni-estab 
        and (   item-uni-estab.var-qtd-re  = 0
             or item-uni-estab.lim-var-qtd = 0 ) ) then do:
        for first item-mat
            fields ( it-codigo var-qtd-re lim-var-qtd ) 
            where item-mat.it-codigo = RowObject.it-codigo no-lock.
        end.
    end.

    assign de-var-perc-qt = if  avail item-uni-estab
                            and item-uni-estab.var-qtd-re > 0 
                            then item-uni-estab.var-qtd-re
                            else item-mat.var-qtd-re
                                 
           de-var-lim-qt  = if  avail item-uni-estab
                            and item-uni-estab.lim-var-qtd > 0 
                            then item-uni-estab.lim-var-qtd
                            else item-mat.lim-var-qtd.

    return "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getZoomCcusto DBOProgram 
PROCEDURE getZoomCcusto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF OUTPUT PARAM p-ccusto      AS CHAR NO-UNDO.
    DEF OUTPUT PARAM p-desc-ccusto AS CHAR NO-UNDO.

    run prgint/utb/utb742za.py persistent set h_api_ccusto.

    run pi_zoom_ccusto in h_api_ccusto (input string(i-empresa),   /* EMPRESA EMS2 */
                                        input "",                  /* CODIGO DO PLANO CCUSTO */
                                        input "",                  /* UNIDADE DE NEGOCIO */
                                        input today,               /* DATA DE TRANSACAO */
                                        output v_cod_ccusto,       /* CODIGO CCUSTO */
                                        output v_des_ccusto,       /* DESCRICAO CCUSTO */
                                        output table tt_log_erro). /* ERROS */ 

    ASSIGN p-ccusto      = v_cod_ccusto
           p-desc-ccusto = v_des_ccusto.

    delete object h_api_ccusto.

    RETURN "ok".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getZoomConta DBOProgram 
PROCEDURE getZoomConta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF OUTPUT PARAM p-conta      AS CHAR NO-UNDO.
    DEF OUTPUT PARAM p-desc-conta AS CHAR NO-UNDO.

    run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.

    run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (input  string(i-empresa),  /* EMPRESA EMS2 */
                                                   input  "CEP",              /* MπDULO */
                                                   input  "",                 /* PLANO DE CONTAS */
                                                   input  "(nenhum)",         /* FINALIDADES */
                                                   input  today,              /* DATA TRANSACAO */
                                                   output v_cod_cta_ctbl,     /* CODIGO CONTA */
                                                   output v_des_cta_ctbl,     /* DESCRICAO CONTA */
                                                   output v_ind_finalid_cta,  /* FINALIDADE DA CONTA */
                                                   output table tt_log_erro). /* ERROS */

    ASSIGN p-conta      = v_cod_cta_ctbl
           p-desc-conta = v_des_cta_ctbl.

    delete object h_api_cta_ctbl.

    RETURN "ok".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice documento
  Parameters:  
               recebe valor do campo serie-docto
               recebe valor do campo nro-docto
               recebe valor do campo cod-emitente
               recebe valor do campo nat-operacao
               recebe valor do campo tipo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pserie-docto LIKE movto-pend.serie-docto NO-UNDO.
    DEFINE INPUT PARAMETER pnro-docto LIKE movto-pend.nro-docto NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente LIKE movto-pend.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pnat-operacao LIKE movto-pend.nat-operacao NO-UNDO.
    DEFINE INPUT PARAMETER ptipo LIKE movto-pend.tipo NO-UNDO.

    FIND FIRST bfmovto-pend WHERE 
        bfmovto-pend.serie-docto = pserie-docto AND 
        bfmovto-pend.nro-docto = pnro-docto AND 
        bfmovto-pend.cod-emitente = pcod-emitente AND 
        bfmovto-pend.nat-operacao = pnat-operacao AND 
        bfmovto-pend.tipo = ptipo NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfmovto-pend THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmovto-pend)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeFind DBOProgram 
PROCEDURE initializeFind :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    for first param-global no-lock:
    end.
    
    for first param-estoq no-lock:
    end.
    
    run findDocumento ( input i-cod-emitente,
                        input c-serie-docto,
                        input c-nro-docto,
                        input c-nat-operacao ).

    run findUsuario.
    
    if  avail docum-est then 
        run findEstabelec ( input docum-est.cod-estabel ).
    
    return "OK":U.
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeUpdate DBOProgram 
PROCEDURE initializeUpdate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    assign de-qt-ori = RowObject.quantidade.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToAgregado DBOProgram 
PROCEDURE linkToAgregado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param pHandle as handle no-undo.
        
    run returnKeyOfDocumEst in pHandle(output i-emitente,
                                       output c-serie-comp,
                                       output c-nro-comp,
                                       output c-nat-comp).
                                       
    if  return-value = "NOK":U then
        assign i-emitente   = 0
               c-serie-comp = "":U
               c-nro-comp   = "":U
               c-nat-comp   = "":U.     

return "OK":U.    


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToDocumEst DBOProgram 
PROCEDURE linkToDocumEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  def input param pHandle as handle no-undo.
  
  run getKey in pHandle(output i-cod-emitente,
                        output c-serie-docto,
                        output c-nro-docto,
                        output c-nat-operacao).
                        
  return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE localizeRowidDocumEst DBOProgram 
PROCEDURE localizeRowidDocumEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def output param p-rDocumEst as rowid  no-undo.
    
    for first b-docum-est
        fields ( cod-emitente   serie-docto
                 nro-docto      nat-operacao )
        where b-docum-est.cod-emitente = RowObject.cod-emitente
          and b-docum-est.serie-docto  = RowObject.serie-comp
          and b-docum-est.nro-docto    = RowObject.nro-comp
          and b-docum-est.nat-operacao = RowObject.nat-comp no-lock.
    end.
    if  avail b-docum-est then 
        assign p-rDocumEst = rowid(b-docum-est).

    return "OK":U.
    
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

  open query qr{&tableName} for each {&tableName}
       no-lock 
       indexed-reposition.
       
       
  return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOfAgregado DBOProgram 
PROCEDURE openQueryOfAgregado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  open query qr{&tableName} for each {&tableName}
       where {&tableName}.cod-emitente = i-emitente
         and {&tableName}.serie-docto  = c-serie-comp
         and {&tableName}.nro-docto    = c-nro-comp
         and {&tableName}.nat-operacao = c-nat-comp
         and {&tableName}.tipo = 1
         no-lock BY movto-pend.sequencia
         indexed-reposition.

  return "OK":U. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOfDocumEst DBOProgram 
PROCEDURE openQueryOfDocumEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  open query qr{&tableName} for each {&tableName}
       where {&tableName}.cod-emitente = i-cod-emitente
         and {&tableName}.serie-docto  = c-serie-docto
         and {&tableName}.nro-docto    = c-nro-docto
         and {&tableName}.nat-operacao = c-nat-operacao
         and {&tableName}.tipo = 2
         no-lock BY movto-pend.sequencia
         indexed-reposition.
         
         
  return "OK":U.       
         
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOfDocumEst1 DBOProgram 
PROCEDURE openQueryOfDocumEst1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  open query qr{&tableName} for each {&tableName}
       where {&tableName}.cod-emitente = i-cod-emitente
         and {&tableName}.serie-docto  = c-serie-docto
         and {&tableName}.nro-docto    = c-nro-docto
         and {&tableName}.nat-operacao = c-nat-operacao
         and {&tableName}.tipo = 1
         no-lock BY movto-pend.sequencia
         indexed-reposition.
         
  return "OK":U. 


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnKeyOfDocumEst DBOProgram 
PROCEDURE returnKeyOfDocumEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes: retorna a chave do documento relacionado ao material agregado, esta 
         chave ser† usada para pesquisa do material acabado do documento.
------------------------------------------------------------------------------*/
def output param pi-cod-emitente as int  no-undo.
def output param pi-serie-comp   as char no-undo.
def output param pi-nro-comp     as char no-undo.
def output param pi-nat-comp     as char no-undo.

    if  not avail rowObject then
        return "NOK":U.
       
    assign pi-cod-emitente = rowObject.cod-emitente
           pi-serie-comp   = rowObject.serie-comp
           pi-nro-comp     = rowObject.nro-comp
           pi-nat-comp     = rowObject.nat-comp.
 
return "OK":U.   

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setaCriaDocumento DBOProgram 
PROCEDURE setaCriaDocumento :
/*------------------------------------------------------------------------------
  Purpose: Atualiza vari†vel referente a criaá∆o do documento     
  Parameters: p-cria-documento: Indica se o documento deve ou n∆o ser criado
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cria-documento AS LOGICAL NO-UNDO.

    ASSIGN l-cria-documento = p-cria-documento.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintOfDocumEst DBOProgram 
PROCEDURE setConstraintOfDocumEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param i-cod-emit  as int  no-undo.
    def input param c-ser-docto as char no-undo.
    def input param c-nr-docto  as char no-undo.
    def input param c-nat-oper  as char no-undo.

        assign i-cod-emitente = i-cod-emit
               c-serie-docto  = c-ser-docto
               c-nro-docto    = c-nr-docto
               c-nat-operacao = c-nat-oper.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDefaultsFields DBOProgram 
PROCEDURE setDefaultsFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF  NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.
    
    if  RowObject.nr-ord-produ <> 0 then do:
        run findOrdProd ( RowObject.nr-ord-produ ).
        
        if  avail ord-prod then
            assign RowObject.it-codigo      = ord-prod.it-codigo
                   RowObject.un             = ord-prod.un
                   RowObject.ct-codigo      = ord-prod.ct-codigo
                   RowObject.sc-codigo      = ord-prod.sc-codigo.
    end.
        
    if  RowObject.numero-ordem <> 0 
    or  RowObject.num-pedido   <> 0 then do:

        run findOrdemCompra ( RowObject.numero-ordem ).
    
        if  return-value <> "OK":U then
            return "NOK":U.

        if  avail ordem-compra then do:
        
            if  RowObject.num-pedido = 0 then 
                assign RowObject.num-pedido = ordem-compra.num-pedido.
            
            assign RowObject.it-codigo      = ordem-compra.it-codigo
                   RowObject.narrativa      = if  RowObject.narrativa = "":U then 
                                                   ordem-compra.narrativa
                                              else RowObject.narrativa.
            
            if RowObject.ct-aplic = "":U then
                assign RowObject.ct-aplic = ordem-compra.ct-codigo
                       RowObject.sc-aplic = ordem-compra.sc-codigo.                              
                                              
        end.                                              
    end.

    run findItem ( RowObject.it-codigo ).

    if  return-value = "NOK":U then
        return "NOK":U.

    run findItemUniEstab ( RowObject.it-codigo,
                           docum-est.cod-estabel ).
                     
    if  RowObject.cod-depos = "":U then do:
        assign RowObject.cod-depos   = if  avail ordem-compra
                                       then ordem-compra.dep-almoxar
                                       else if  avail item-uni-estab
                                            then item-uni-estab.deposito-pad
                                            else item.deposito-pad.

        assign RowObject.cod-localiz = if avail item-uni-estab 
                                       then item-uni-estab.cod-localiz 
                                       else item.cod-localiz.
    END.
    
    IF item.loc-unica THEN DO:
    
        assign RowObject.cod-localiz = if avail item-uni-estab 
                                       then item-uni-estab.cod-localiz 
                                       else item.cod-localiz.
    END.
                                   
    if  can-do("2,3,4",string(item.tipo-con-est)) then do: /* Controlado por Lote ou Referencia */

        if  avail ord-prod then do:
            if  RowObject.cod-refer = "":U then 
                assign RowObject.cod-refer = ord-prod.cod-refer.
            
            if  RowObject.lote = "":U then do:
                assign RowObject.lote = if  ord-prod.lote-serie <> " "
                                        then ord-prod.lote-serie
                                        else if  ord-prod.nr-ord-produ > 999999 
                                             then string(ord-prod.nr-ord-produ, "999999999")
                                             else ord-prod.cod-estabel + "." +
                                                  string(ord-prod.nr-ord-produ,"999999").
        
            end.                
        end.            
        
        run findSaldoEstoq ( RowObject.it-codigo,
                             RowObject.lote ).

        assign RowObject.dt-vali-lote = if avail saldo-estoq                then saldo-estoq.dt-vali-lote
                                        else if  RowObject.dt-vali-lote = ? then date(12,31,9999)
                                        else RowObject.dt-vali-lote.
    end.
    else 
        assign RowObject.lote = "":U
               RowObject.dt-vali-lote = ?
               RowObject.cod-refer = "":U.

    if  can-do("1,4",string(item.tipo-contr)) then do: /* Fisico ou Debito Direto */
        
        if  RowObject.ct-aplic = "":U then do:
            if avail ordem-compra then
                assign RowObject.ct-aplic = ordem-compra.ct-codigo
                       RowObject.sc-aplic = ordem-compra.sc-codigo.
            else
                assign RowObject.ct-aplic = item.ct-codigo
                       RowObject.sc-aplic = item.sc-codigo.            
        end.                                                
                                           
    end.
    else 
        assign RowObject.ct-aplic = "":U
               RowObject.sc-aplic = "":U.
        
    if  RowObject.un = " " then do:
        run findItemFornec  ( RowObject.it-codigo,
                              RowObject.cod-emitente ).
    
        assign RowObject.un = if  avail ordem-compra
                              and avail item-fornec 
                              then item-fornec.unid-med-for
                              else item.un.
    end.


    if  RowObject.tipo <> 1  /* ACABADO */
    or  RowObject.nr-ord-produ = 0 then do:
        /* O campo RowObject.dec-1 contem a Proporcao e */
        /* o campo RowObject.dec-2 contem o Preco Total */
        
        assign RowObject.dec-1 = if  avail param-global
                                 and not param-global.modulo-cp
                                 and RowObject.dec-1 = 0 
                                 then 100             /* 100 por cento */
                                 else RowObject.dec-1.
    
    
        if  RowObject.dec-2 = 0 
        and RowObject.numero-ordem <> 0 then
            run setDefaultsPrecoTotal. 
        else  do:
            if  RowObject.valor-mat[1] = 0 
            and RowObject.valor-mob[1] = 0 then 
                assign RowObject.valor-mat[1] = fn_ajust_dec((round((RowObject.dec-2 * RowObject.dec-1 / 100), 2)), 0)
                       RowObject.valor-mob[1] = fn_ajust_dec((RowObject.dec-2 - RowObject.valor-mat[1]), 0).
        end.                   
    end.
    
/*    run findMovtoPend ( input RowObject.cod-emitente,
 *                         input RowObject.serie-docto,
 *                         input RowObject.nro-docto,
 *                         input RowObject.nat-operacao,
 *                         RowObject.tipo ).
 *     
 *     assign RowObject.sequencia = if  not avail movto-pend 
 *                                  then 1
 *                                  else movto-pend.sequencia + 1.  */
               
    return "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDefaultsPrecoTotal DBOProgram 
PROCEDURE setDefaultsPrecoTotal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def var de-preco-unit      as decimal no-undo.
    def var de-desconto        as decimal no-undo.
    def var de-val-contrato    as decimal no-undo.
    def var de-val-aux         as decimal no-undo.
    def var de-val-formula     as decimal no-undo.
    def var de-vl-preuni       as decimal no-undo.
    def var de-taxa            as decimal no-undo.

    run findOrdemCompra ( RowObject.numero-ordem ).

    if  avail ordem-compra then do:
        run rep/re1908.p ( rowid(ordem-compra),
                           docum-est.dt-emissao,
                           output de-preco-unit,  
                           output de-desconto,
                           output de-taxa).
                          
        if  param-global.modulo-cn 
        and ordem-compra.nr-contrato <> 0 then do:
            run cnp/cn9060.p ( &IF "{&bf_mat_versao_ems}":U >= "2.062":U &THEN
                                   INPUT 0,
                               &ENDIF
                               ?,
                               RowObject.numero-ordem,
                               0,
                               no,
                               RowObject.quantidade,
                               docum-est.dt-emissao,
                               output de-val-contrato,
                               output de-val-aux,
                               output de-val-formula,
                               output de-val-aux).
                     
            assign de-desconto   = 0
                   de-preco-unit = if  de-val-formula > 0 
                                   then de-val-formula
                                   else if  de-val-contrato > 0 
                                        then de-val-contrato
                                        else 0.
        end.
        
        /* O campo RowObject.dec-1 contem a Proporcao e */ 
        /* o campo RowObject.dec-2 cpntem o Preco Total */
        
        assign de-vl-preuni           = de-preco-unit - de-desconto
               RowObject.dec-2        = fn_ajust_dec((RowObject.quantidade * de-vl-preuni), 0)
               RowObject.valor-mat[1] = fn_ajust_dec((round((RowObject.dec-2 * RowObject.dec-1 / 100), 2)), 0)
               RowObject.valor-mob[1] = fn_ajust_dec((RowObject.dec-2 - RowObject.valor-mat[1]), 0).
    end.

    return "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setHandleDocumEst DBOProgram 
PROCEDURE setHandleDocumEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param p-boin090   as handle no-undo.
    def input param p-rDocumEst as rowid  no-undo.
    
    assign h-boin090 = p-boin090
           rDocumEst = p-rDocumEst.

    return "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateContaContabil DBOProgram 
PROCEDURE validateContaContabil :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    if  v_num_sit_cta_ctbl <> 3 then do:
        {method/svc/errors/inserr.i
                            &ErrorNumber="1062" /*Conta Cont†bil n∆o Ç de sistema*/
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" }
    end.
    
    if  RowObject.tipo = 1 
    and avail param-global
    and not param-global.modulo-cp then do:

        if  lookup({adinc/i05ad049.i 4 1}, v_ind_finalid_cta) <> 0 then do:
            {method/svc/errors/inserr.i
                                &ErrorNumber="4049" /* Conta e de consumo */
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" }
        end.
    
        if  lookup({adinc/i05ad049.i 4 10}, v_ind_finalid_cta) <> 0 then do:
            {method/svc/errors/inserr.i
                                &ErrorNumber="4994" /* Conta Cont†bil inv†lida para documento */
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" }
        end.
    end.    

    if  RowObject.tipo = 2 then do:
       
        if  lookup({adinc/i05ad049.i 4 2}, v_ind_finalid_cta) = 0 and 
            lookup({adinc/i05ad049.i 4 7}, v_ind_finalid_cta) = 0 then do: 
                        
            {method/svc/errors/inserr.i
                                &ErrorNumber="4994" /*Conta Cont†bil inv†lida para documento*/
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" }
        end.     
           
    end. 

    return "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateDecimals DBOProgram 
PROCEDURE validateDecimals :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    assign RowObject.dec-2        = fn_ajust_dec(RowObject.dec-2, 0).
    assign RowObject.valor-mat[1] = fn_ajust_dec(RowObject.valor-mat[1], 0).
    assign RowObject.valor-mob[1] = fn_ajust_dec(RowObject.valor-mob[1], 0).
    assign RowObject.valor-mat[2] = fn_ajust_dec(RowObject.valor-mat[2], param-estoq.moeda1).
    assign RowObject.valor-mat[3] = fn_ajust_dec(RowObject.valor-mat[3], param-estoq.moeda2).
    assign RowObject.valor-mob[2] = fn_ajust_dec(RowObject.valor-mob[2], param-estoq.moeda1).
    assign RowObject.valor-mob[3] = fn_ajust_dec(RowObject.valor-mob[3], param-estoq.moeda2).

    if  l-rejeita-dec then do:    
        {method/svc/errors/inserr.i
                            &ErrorNumber="18130" /* Valor com quantidade de casas decimais invalida */
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" }
    end.
    
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
    
    assign l-verifica-docto = yes.
    
    IF  NOT AVAIL param-global THEN
        FOR FIRST param-global NO-LOCK: END.

    IF  NOT AVAIL param-estoq THEN
        FOR FIRST param-estoq NO-LOCK: END.
        
    RUN emptyRowErrors IN THIS-PROCEDURE.
    
    {method/svc/custom/custom.i &Event = "beforeValidateRecord"}
        
    RUN findDocumento (INPUT RowObject.cod-emitente,
                       INPUT RowObject.serie-docto,
                       INPUT RowObject.nro-docto,
                       INPUT RowObject.nat-operacao).
    
    IF  RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.
    
    IF  RowObject.tipo = 2 THEN DO: /* Agregado */
        IF  NOT l-gera-com-doc-fisico THEN DO: /* N∆o gera Ö partir do f°sico (re1001h2) */
            FOR FIRST b-docum-est
                FIELDS ( cod-emitente serie-docto nro-docto nat-operacao ce-atual )
                WHERE b-docum-est.cod-emitente = RowObject.cod-emitente
                  AND b-docum-est.serie-docto  = RowObject.serie-comp
                  AND b-docum-est.nro-docto    = RowObject.nro-comp
                  AND b-docum-est.nat-operacao = RowObject.nat-comp NO-LOCK: END.
            
            IF  AVAIL b-docum-est
                AND   b-docum-est.ce-atual 
                AND   l-verifica-docto THEN DO:
                {method/svc/errors/inserr.i
                                   &ErrorNumber="19515" /* Nota fiscal j† atualizada */
                                   &ErrorType="EMS"
                                   &ErrorSubType="ERROR" }
                RETURN "NOK":U.                   
            END.
        END.
    END.

    IF  RowObject.tipo = 1 THEN DO: /* Acabado */
        IF  docum-est.cp-atual then do:
            {method/svc/errors/inserr.i
                                &ErrorNumber="19501" /*M¢dulo de produá∆o j† atualizado*/
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" }
        END.
        IF  docum-est.ce-atual then do:
            {method/svc/errors/inserr.i
                                &ErrorNumber="19515" /*Nota fiscal j† atualizada*/
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" }
        END.        
    END.
    

    IF  pType <> "DELETE":U THEN DO:
        
        IF  pType = "CREATE":U 
            AND RowObject.tipo = 1 THEN /* Acabado */
            RUN setDefaultsFields.
        
        RUN findEmitente ( docum-est.cod-emitente ).
        RUN findEstabelec ( docum-est.cod-estabel ).
    
    
        IF  RowObject.tipo = 2 THEN DO: /* Agregado */
            
            if  RowObject.ct-codigo = "" then 
                run getContaContabil ( output RowObject.ct-codigo, output RowObject.sc-codigo ).
                
            RUN findNaturOper ( RowObject.nat-comp ).
            IF  AVAIL natur-oper
                AND (natur-oper.tipo = 2 OR natur-oper.transf OR natur-oper.terceiros ) THEN DO:
                {method/svc/errors/inserr.i
                                   &ErrorNumber="32528" /*Natureza de Operaá∆o Inv†lida para notas de Material Agregado*/
                                   &ErrorType="EMS"
                                   &ErrorSubType="ERROR" }
            END.
    
            IF  pType = "CREATE":U THEN DO:

                IF  l-gera-com-doc-fisico THEN DO: /* Gera a partir do f°sico (re1001h2) */
                    FOR FIRST b-doc-fisico
                        WHERE b-doc-fisico.serie-docto  = RowObject.serie-comp
                        AND   b-doc-fisico.nro-docto    = RowObject.nro-comp
                        AND   b-doc-fisico.cod-emitente = RowObject.cod-emitente
                        AND   b-doc-fisico.tipo-nota    = 1 NO-LOCK: /* tipo-nota sempre = 1 (Compra) */
        
                        IF  b-doc-fisico.situacao = 1 THEN DO: /* digitado no rec. fisico */
                            {method/svc/errors/inserr.i &ErrorNumber="17381" /* Documento n∆o Atualizado no Recebimento F°sico. */
                                                        &ErrorType="EMS"
                                                        &ErrorSubType="ERROR" }
                            RETURN "NOK":U.                        
                        END.
                        ELSE IF b-doc-fisico.situacao = 3 OR b-doc-fisico.situacao = 4 THEN DO: /* digitada ou atualizada no rec. fisico */
                            {method/svc/errors/inserr.i &ErrorNumber="6051" /* Documento Fiscal j† existente */
                                                        &ErrorType="EMS"
                                                        &ErrorSubType="ERROR" }
                            RETURN "NOK":U.                        
                        END.
                    END.
                    IF  NOT AVAIL b-doc-fisico THEN DO:
                        {utp/ut-liter.i "Documento_f°sico" *}
                        {method/svc/errors/inserr.i &ErrorNumber="2" /* N∆o encontrado & para a chave informada */
                                                    &ErrorType="EMS"
                                                    &ErrorSubType="ERROR"
                                                    &ErrorParameters="RETURN-VALUE"}
                        RETURN "NOK":U.
                    END.
                END.
                ELSE DO:
                    FOR FIRST b-docum-est
                        FIELDS ( cod-emitente serie-docto nro-docto nat-operacao )
                        WHERE b-docum-est.cod-emitente = RowObject.cod-emitente
                          AND b-docum-est.serie-docto  = RowObject.serie-comp
                          AND b-docum-est.nro-docto    = RowObject.nro-comp
                          AND b-docum-est.nat-operacao = RowObject.nat-comp NO-LOCK. END.

                    IF  l-cria-documento THEN DO:
                        IF  l-verifica-docto THEN DO:
                            IF  AVAIL b-docum-est THEN DO:
                                {utp/ut-liter.i "Documento" *}
                                ASSIGN c-lbl-liter-msg = TRIM(RETURN-VALUE).
                                {method/svc/errors/inserr.i
                                                   &ErrorNumber="1"
                                                   &ErrorType="EMS"
                                                   &ErrorSubType="ERROR" 
                                                   &ErrorParameters="c-lbl-liter-msg"}
                                RETURN "NOK":U.                   
                            END.
                        END.
                        ELSE DO:
                            IF  NOT AVAIL b-docum-est THEN DO:
                                {utp/ut-liter.i "Documento" *}
                                ASSIGN c-lbl-liter-msg = TRIM(RETURN-VALUE).
                                {method/svc/errors/inserr.i
                                                   &ErrorNumber="2"
                                                   &ErrorType="EMS"
                                                   &ErrorSubType="ERROR" 
                                                   &ErrorParameters="c-lbl-liter-msg"}
                                RETURN "NOK":U.                    
                            END.
                        END.
                    END.
                END.
            END. /* END IF pType = "CREATE" */
        END. /* END IF RowObject.tipo = 2 (Agregado) */
        
        RUN findContaContabil ( RowObject.ct-codigo, docum-est.dt-trans ).
        IF  RowObject.ct-codigo <> "" THEN DO:
            RUN validateContaContabil.
            
            /* Busca centro de custo somente se a conta utiliza centro de custo */
            RUN contaUtilizaCentroCusto ( RowObject.ct-codigo, docum-est.dt-trans, docum-est.cod-estabel ).
            IF  RETURN-VALUE = "OK" THEN
                RUN findCentroCusto ( RowObject.sc-codigo, docum-est.dt-trans).
        END.
    
        if  RowObject.tipo = 1 then do: /* Acabado */
    
            if  avail param-global
            and param-global.modulo-cp then
                run findOrdProd ( RowObject.nr-ord-produ ).
            
            run findItem ( RowObject.it-codigo ).
        
            if  avail item
            AND not can-do("1,4",string(item.tipo-contr)) then  /* Fisico ou Debito Direto */
                assign RowObject.ct-aplic = "":U
                       RowObject.sc-aplic = "":U.
            else
                if  RowObject.ct-aplic = "" then do:
                    if avail item then
                        assign RowObject.ct-aplic = item.ct-codigo
                               RowObject.sc-aplic = item.sc-codigo.                    
                end.

            if  RowObject.ct-aplic <> "" then do:
                run findContaContabil ( RowObject.ct-aplic, docum-est.dt-trans ).
                if RowObject.ct-aplic <> "" then do:
                    run validateContaContabil.
                    
                    /* Busca centro de custo somente se a conta utiliza centro de custo */
                    run contaUtilizaCentroCusto ( RowObject.ct-aplic, docum-est.dt-trans, docum-est.cod-estabel ).
                    if return-value = "OK" then
                        run findCentroCusto ( RowObject.sc-aplic, docum-est.dt-trans).   
                end.             
            end.
            else 
                if  avail item
                and can-do("1,4", string(item.tipo-contr)) then do:
                    {method/svc/errors/inserr.i
                                        &ErrorNumber="6726" /*Conta cont†bil deve ser informada*/
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"} 
                end.
                
            if  RowObject.quantidade = 0 then do:
                {method/svc/errors/inserr.i
                                    &ErrorNumber="1570"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR" 
                                    &ErrorParameters=" "}
           end.

            
            if  RowObject.num-pedido <> 0 then do:
        
                run findPedidoCompr ( RowObject.num-pedido ).
                
                if  avail pedido-compr then do:
                    if  pedido-compr.situacao = 3 then do:
                        {method/svc/errors/inserr.i
                                            &ErrorNumber="1813" /* Pedido ja Eliminado */
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR" }
                    end.     
                  
                    if  pedido-compr.natureza <> 3 then do:
                        {method/svc/errors/inserr.i
                                            &ErrorNumber="6412" /* Pedido nao possui ordens de beneficiamento */
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR" }
                    end.
            
                    if  pedido-compr.cod-emitente <> RowObject.cod-emitente then do:
                        {method/svc/errors/inserr.i
                                            &ErrorNumber="5696" /* Fornecedor da nota difere do fornecedor do pedido */
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR" }
                    end.
                end.
                
                run findOrdemCompra ( RowObject.numero-ordem ).
            
                if  avail ordem-compra then do:
                    if  ordem-compra.num-pedido <> RowObject.num-pedido then do:
                        {method/svc/errors/inserr.i
                                            &ErrorNumber="5701" /* Ordem nao pertence ao pedido de compra */
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR" }
                    end.
                
                    if  ordem-compra.it-codigo <> RowObject.it-codigo then do:
                        {method/svc/errors/inserr.i
                                            &ErrorNumber="5055" /* Item da ordem difere do item da transacao */
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR" }
                    end.
                end.
        
                run findPrazoCompra ( RowObject.numero-ordem, 
                                      RowObject.parcela ).
               
                if  avail prazo-compra 
                and prazo-compra.situacao <> 2 then do:
                    {method/svc/errors/inserr.i
                                        &ErrorNumber="6359" /* Parcela com situacao invalida */
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR" }
                end.   
                
                if  avail prazo-compra then
                    run validateVariationQuantity ( input pType ).
                
            end.
        
            if  avail item then do:
                if  item.cod-obsoleto = 3 then do:
                    {method/svc/errors/inserr.i
                                        &ErrorNumber="999" /* Item esta obsoleto */
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR" }
                end.
        
                if  item.tipo-con-est <> 3 
                and item.tipo-con-est <> 4 then do:
                    assign RowObject.dt-vali-lote = ?.
                    if  item.tipo-con-est = 1 then
                        assign RowObject.lote = "".
                end.                        

                if  item.tipo-con-est = 2 
                or  item.tipo-con-est = 3
                or  item.tipo-con-est = 4 then do:
                    if  RowObject.lote = " " then do:
                        {method/svc/errors/inserr.i
                                            &ErrorNumber="1818" 
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR" }
                    end.                        
                 
                    if (    item.tipo-con-est = 3 
                        or  item.tipo-con-est = 4)
                    and RowObject.dt-vali-lote = ? then do:
                        {method/svc/errors/inserr.i
                                &ErrorNumber="1786" 
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" }
                    end.            
                end.
        
                if  item.tipo-con-est = 4 then
                    run findReferencia ( RowObject.cod-refer ).
            
            
                if  item.tipo-con-est > 2  /* Controlado por Lote ou Referencia */
                and (   RowObject.dt-vali-lote = ? 
                or RowObject.dt-vali-lote < today ) then do:
                    {method/svc/errors/inserr.i
                                        &ErrorNumber="1247"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR" 
                                        &ErrorParameters=" "}
                end.
    
    
                /* Verifica saldo em estoque para item controlado por numero de serie */ 
                if  item.tipo-con-est = 2 then do:
            
            
                    if RowObject.quantidade <> 1 then do:
                       /* Quantidade de item por serie deve ser 1 */
                       {method/svc/errors/inserr.i  &ErrorNumber="1234"
                                                    &ErrorType="EMS"
                                                    &ErrorParameters="''"}      
                    end. 

                    find first b-movto-pend {cdp/cd8900.i b-movto-pend docum-est} 
                        and b-movto-pend.it-codigo  = RowObject.it-codigo 
                        and b-movto-pend.lote       = RowObject.lote no-lock no-error.
               
                    if  avail b-movto-pend then do:
                        /* Item Controlado por Nr. Serie ja Existe em Outra Sequencia */
                        {method/svc/errors/inserr.i
                                            &ErrorNumber="6388"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR" 
                                            &ErrorParameters=" "}
                    end.          

                    for first saldo-estoq fields ( dt-vali-lote it-codigo lote qtidade-atu )
                        where saldo-estoq.it-codigo   = RowObject.it-codigo
                          and saldo-estoq.lote        = RowObject.lote
                          and saldo-estoq.qtidade-atu > 0 no-lock.
                    end.
                 
                    if  avail saldo-estoq then do:
                        /* Item Controlado por Nr. Serie ja Existe em Saldo Estoque */
                        {method/svc/errors/inserr.i
                                            &ErrorNumber="1252"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR" 
                                            &ErrorParameters=" "}
                    end.    
                end.    
    
                if  avail param-estoq 
                and item.tipo-con-est = 4 then /* Controlado por Referencia */
                    
                    if  substr(param-estoq.char-2,1,1) <> "#" then do:
                        
                        for first saldo-estoq 
                            fields ( dt-vali-lote it-codigo lote cod-refer ) use-index lote
                            where saldo-estoq.it-codigo = RowObject.it-codigo
                            and   saldo-estoq.lote      = RowObject.lote no-lock.
                        end.
            
                        if  avail saldo-estoq
                        and saldo-estoq.cod-refer <> RowObject.cod-refer then do:
                            /* Referencia informada nao confere com a referendia do lote. */
                            {method/svc/errors/inserr.i
                                                &ErrorNumber="1785"
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR" 
                                                &ErrorParameters=" "}
                        end.
                    end.
                    
                if  RowObject.un = " "
                or  (    RowObject.un <> item.un
                     and item.tipo-contr <> 4 ) then 
                do:
                    {method/svc/errors/inserr.i
                                        &ErrorNumber="1225" /* Unidade de medida difere do item */
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR" }
                end.                                    
            end.
        
            run findLocalizacao ( docum-est.cod-estabel, 
                                  RowObject.cod-localiz, 
                                  RowObject.cod-depos ).
                                  
            run validateDecimals.
            
        END.
    END.
    
    /*--- Verifica ocorrància de erros ---*/
    IF  CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateVariationQuantity DBOProgram 
PROCEDURE validateVariationQuantity :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param pType    as char    no-undo.

    def var de-qtd-tot-ordem as decimal no-undo.
    def var de-percentual-qt as decimal no-undo.
    def var de-limite-qt     as decimal no-undo.
    def var de-qtd-var       as decimal no-undo.
    def var de-qtd-aux       as decimal no-undo.
    def var de-var-max-perc  as decimal no-undo.
    def var de-var-max-lim   as decimal no-undo.
    def var de-qtd-max       as decimal no-undo.
    def var l-erro           as logical no-undo.

    if  pType = "CREATE":U then 
        assign de-qtd-aux = 0.
    else 
        assign de-qtd-aux = de-qt-ori.
                
    assign de-qtd-max = (prazo-compra.quant-saldo - prazo-compra.dec-1) 
                      + de-qtd-aux.

    run getValuesItemUniEstab ( output de-percentual-qt,
                                output de-limite-qt ).

    for each prazo-compra 
        fields ( numero-ordem     quantidade
                 quant-saldo      dec-1
                 quant-receb      quant-rejeit )
        use-index ordem
        where prazo-compra.numero-ordem = RowObject.numero-ordem
        no-lock:
        
        assign de-qtd-tot-ordem = de-qtd-tot-ordem + prazo-compra.quantidade.

        if (prazo-compra.quant-receb + prazo-compra.dec-1 - quant-rejeit) >       
                                             prazo-compra.quantidade then
            assign de-qtd-var = de-qtd-var
                              + (prazo-compra.quant-receb
                              +  prazo-compra.dec-1
                              -  prazo-compra.quant-rejeit)
                              -  prazo-compra.quantidade.
    end.
    
    assign de-qtd-aux = round(de-qtd-tot-ordem * de-percentual-qt / 100 , 4).
           de-qtd-aux = de-qtd-aux - de-qtd-var.
           de-qtd-aux = if   de-qtd-aux < 0 then 0 
                        else de-qtd-aux.
    
    assign de-var-max-perc = de-qtd-max + de-qtd-aux
           de-var-max-lim  = de-qtd-max + de-limite-qt.

    assign l-erro = no.
            
    if  de-percentual-qt = 0
    and de-limite-qt = 0 then do:
        if  RowObject.quantidade > de-var-max-perc
        or  RowObject.quantidade > de-var-max-lim then
            assign l-erro = yes.    
    end.        
    else 
        if  RowObject.quantidade <=  de-var-max-perc 
        or  de-percentual-qt = 0 then 
            if  RowObject.quantidade > de-var-max-lim  
            and de-limite-qt <> 0 then  
                 assign l-erro = yes. 
            else  
                 assign l-erro = no. 
        else 
            assign l-erro = yes. 
            
    if  l-erro then do:

        if  param-re.aceita-var = no then do:                               
            {method/svc/errors/inserr.i
                                &ErrorNumber="5928" /*mensagem: Quantidade fora da variacao permitida */
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" }

        end.
        else do:        
            {method/svc/errors/inserr.i
                                &ErrorNumber="18799" /*mensagem: Quantidade fora da variacao permitida.*/
                                &ErrorType="EMS"
                                &ErrorSubType="WARNING" }
        end.    
    end.

    return "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

