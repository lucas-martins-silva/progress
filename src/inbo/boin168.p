/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN168 2.00.00.034 } /*** "010034" 06/08/2026 18:08:51 ***/


&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/*--------------------------------------------------------------------------
    File       : 
    Purpose    : O DBO (Datasul Business Objects) ï¿½ um programa PROGRESS
                 que contï¿½m a lï¿½gica de negï¿½cio e acesso a dados para uma
                 tabela do banco de dados.

    Parameters :

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de definiï¿½ï¿½o ---*/
&GLOBAL-DEFINE DBOName it-requisicao
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName it-requisicao
&GLOBAL-DEFINE TableLabel it-requisicao
&GLOBAL-DEFINE QueryName qr{&TableName}

/*--- Include com definiï¿½ï¿½o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diretï¿½rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idï¿½ntico ao nome do DBO mas com
      extensï¿½o .i ---*/
{inbo/boin168.i RowObject}
{inbo/boin658fx.i ttUnidNegRequis}

{include/i-epc200.i boin168}
{include/i_dbvers.i}
{cdp/cd0669.i}
{cdp/cd1001.i}
{btb/btb009za.i}

/*--- Include com definiï¿½ï¿½o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraï¿½ï¿½o da definiï¿½ï¿½o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiï¿½ï¿½o
      manual da query ---*/
{method/dboqry.i}

{cdp/cdcfgmat.i} /* Mudanï¿½a de base */
{cdp/cdcfgdis.i} /* Definiï¿½ï¿½o dos prï¿½-processadores que diferenciam releases*/

{cep/ceapi030.i}


/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
DEFINE BUFFER b-{&TableName} FOR {&TableName}.

/**************Definiï¿½ï¿½o das variaveis *****************/
    def var i-nr-requisicao       LIKE requisicao.nr-requisicao init 0 no-undo. 
    def var i-requis-ini          LIKE requisicao.nr-requisicao init 0 no-undo.
    def var i-requis-fin          LIKE requisicao.nr-requisicao init 999999999 no-undo.
    def var r-chave-it-requisicao as rowid no-undo.
    def var inum-ordem            as int   no-undo.
    def var ccod-comprado         as char  no-undo.
    def var depreco               as dec   no-undo.
    def var l-retorno             as logical no-undo.
    def var l-ScCodigo            as logical no-undo.
    def var c-cod-utiliz-aux      as char no-undo.
    def var i-moeda-req           as int no-undo.
    def var de-limite-req         as dec no-undo.
    def var de-solic              as dec no-undo.
    def var de-total-req          as dec no-undo.
    def var i-moeda-solic         as dec no-undo.
    def var de-tot-solic          as dec no-undo.
    def var i-tipo-doc            as int   no-undo.
    def var i-tipo-trans          as int   no-undo.
    def var de-preco-u            as dec   no-undo.
    def var r-requisicao          as rowid no-undo.
    def var de-sal-ant            as dec   no-undo.
    def var r-item-re             as rowid no-undo.
    def var l-pendente            as log   no-undo.
    def var l-integra-his              as logical no-undo.
    def var l-sistema-his-rm           as logical no-undo.
&IF "{&mguni_version}" >= "2.071" &THEN
    def var i-ep-codigo-usuario   LIKE empresa.ep-codigo   no-undo.
&ELSE
    def var i-ep-codigo-usuario   as int   no-undo.
&ENDIF
    def var l-achou               as log   no-undo.
    def var c-sc-codigo           as char  no-undo.
    def var c-ct-codigo           as char  no-undo.    
    def var l-classif             as log   no-undo.
    def var i-nat-desp            as int   no-undo.
    def var c-param               as char  no-undo.
    def var i-tp-ressup           as int   no-undo.
    def var c-cod-utiliz          as char  no-undo.
    def var l-deb-direto          as log   no-undo.
    def var l-retorno-aprov       as log   no-undo.
    def var i-seq                 as int   no-undo.
    def var i-moeda-lim           as int   no-undo.
    def var i-tipo-moeda          as int   no-undo.
    def var de-valor-doc          as dec   no-undo.
    def var de-valor-lim          as dec   no-undo.
    def var c-tipo-moeda          as char  no-undo.
    def var c-moeda-lim           as char  no-undo.    
    def var c-lista-prioridade    as char  no-undo.
    def var c-cod-estabel         as char  no-undo.
    def var irequisicao           as int   no-undo.
    def var pSequencia            as int   no-undo.
    def var lAprovacaoItem        as log init yes no-undo.
    def var lAprovacaoTotal       as log   no-undo.
    def var cPrograma             as char init "":U no-undo.
    def var iEmpresa like param-global.empresa-prin no-undo. 
    def var de-valor-item         as dec   no-undo.
    def var de-valor-total        as dec   no-undo.
    def var h_api_cta_ctbl        as handle    no-undo.
    def var v_des_cta_ctbl        as character no-undo.
    def var v_cod_cta_ctbl        as char      no-undo.
    def var v_num_tip_cta_ctbl    as char      no-undo. 
    def var v_num_sit_cta_ctbl    as char      no-undo. 
    def var v_ind_finalid_cta     as char      no-undo. 
    def var i-estoque             as integer   no-undo.
    def var ind                   as integer   no-undo.
    def var v_cod_finalid         as character no-undo.
    def var l-retorno-aprova      as logical   no-undo.
    def var h-btb009za            as handle    no-undo.
    
    def new global shared var gl-proxima-aprovacao  as logical no-undo.
    def new global shared var gi-proxima-prioridade as integer no-undo.
    def new global shared var c-seg-usuario         as char format "x(12)" no-undo.
    def shared var            v_cod_usuar_corren    as char format "x(12)" no-undo.

    DEFINE TEMP-TABLE ttSummaryInventoryBalance NO-UNDO 
       FIELD cod-depos LIKE saldo-estoq.cod-depos
       FIELD cod-localiz LIKE saldo-estoq.cod-localiz
       FIELD lote LIKE saldo-estoq.lote
       FIELD dt-vali-lote LIKE saldo-estoq.dt-vali-lote
       FIELD cod-refer LIKE movto-estoq.cod-refer
       FIELD qtidade-atu LIKE saldo-estoq.qtidade-atu
       FIELD qt-a-atender LIKE it-requisicao.qt-a-atender
       FIELD close AS logical
       FIELD nr-requisicao LIKE it-requisicao.nr-requisicao
       FIELD sequencia LIKE it-requisicao.sequencia
       FIELD dt-trans LIKE movto-estoq.dt-trans
       FIELD showMsg AS logical
       FIELD logprocesswms AS CHARACTER. /* LIKE it-requisicao.log-process-wms */

    DEFINE TEMP-TABLE tt-it-requisicao-dest NO-UNDO LIKE it-requisicao
           field nr-requis-orig LIKE requisicao.nr-requisicao
           field seq-requis-orig as integer
           field r-rowid as rowid.

    DEFINE TEMP-TABLE tt-unid-neg-requis NO-UNDO LIKE unid-neg-requis.

    /*DEFINE TEMP-TABLE ttItRequisicao NO-UNDO 
    LIKE it-requisicao
    FIELD dt-requisicao LIKE requisicao.dt-requisicao
    FIELD desc-item     LIKE ITEM.desc-item
    FIELD sit           AS INTEGER
    FIELD tipo-con-est  LIKE item.tipo-con-est
    fIELD desc-status   AS CHARACTER      
    FIELD rRowid        AS ROWID
    FIELD ind-saldo     AS INTEGER.*/

    DEFINE TEMP-TABLE ttItRequisicao NO-UNDO SERIALIZE-NAME 'ItemRequisicao':U
    FIELD nr-requisicao     AS INTEGER    INITIAL ? SERIALIZE-NAME 'nrRequisicao':U
    FIELD sequencia   AS INTEGER    INITIAL ? SERIALIZE-NAME 'sequencia':U
    FIELD qt-a-atender   AS DECIMAL    INITIAL ? SERIALIZE-NAME 'qtAAtender':U.
   
    DEFINE TEMP-TABLE ttItRequisicaoCount NO-UNDO LIKE ttItRequisicao.

    DEFINE DATASET dsAtendimento FOR ttItRequisicao. 

    DEFINE TEMP-TABLE ttSummaryInventoryBalanceAux NO-UNDO
    LIKE ttSummaryInventoryBalance.

    DEFINE TEMP-TABLE ttInventoryBalanceOrdered NO-UNDO
    LIKE ttSummaryInventoryBalance
    FIELD seq AS INT.

    DEFINE TEMP-TABLE ttItRequisicaoSelec NO-UNDO
    LIKE ttItRequisicao.
    DEFINE TEMP-TABLE ttItRequisicao-aux NO-UNDO
    LIKE ttItRequisicao.

    DEFINE VARIABLE h-ceapi400       AS HANDLE NO-UNDO.
    /*DEFINE VARIABLE h-boin168        AS HANDLE NO-UNDO.*/
    DEFINE VARIABLE d-saldo-deposito AS DEC    NO-UNDO.
    DEFINE VARIABLE l-perm-sald-neg  AS LOG    NO-UNDO.
    
    DEFINE BUFFER bf-ttItRequisicaoSelec FOR ttItRequisicaoSelec.

    def temp-table tt-erro-invest no-undo
        field i-sequen  as int             
        field cd-erro   as int
        field mensagem  as char format "x(255)"
        field c-param   as char .

    def temp-table tt-erro-aed no-undo
        field i-sequen as int             
        field cd-erro  as int
        field mensagem as char format "x(255)"
        field c-param  as char.
    
    def temp-table tt_log_erro no-undo
        field ttv_num_cod_erro                 as integer format ">>>>,>>9" label "Nï¿½mero" column-label "Nï¿½mero"
        field ttv_des_msg_ajuda                as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
        field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsistï¿½ncia".    

    &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
        def temp-table tt-erro-aux no-undo
            field i-sequen as int              
            field cd-erro  as int
            field mensagem as char format "x(255)".
    
        DEF TEMP-TABLE tt-matriz NO-UNDO
            FIELD cod-unid-neg AS CHAR
            FIELD perc-rateio  AS DEC.

        {cdp/cd9590.i}
    &else
       DEFINE VARIABLE l-mat-unid-negoc AS LOGICAL    NO-UNDO.
       DEFINE VARIABLE l-unidade-negocio AS LOGICAL    NO-UNDO.
    &ENDIF

    assign l-integra-his = can-find(first funcao where funcao.cd-funcao = "spp-integra-ems-his" and funcao.ativo).
    ASSIGN l-sistema-his-rm = CAN-FIND (FIRST funcao WHERE funcao.cd-funcao = "spp-sistema-his-rm":U AND funcao.ativo).

    /*--- ivbo/boiv029.p ---*/
    DEFINE TEMP-TABLE tt-unid-neg-inv NO-UNDO
        FIELD cod-unid-neg AS CHARACTER
        FIELD perc-rateio  AS DECIMAL.

    /*--- ivbo/boiv029.p ---*/
    DEFINE TEMP-TABLE tt-erro-inv NO-UNDO
        FIELD i-sequen AS INTEGER            
        FIELD cd-erro  AS INTEGER
        FIELD mensagem AS CHARACTER FORMAT "x(255)":U.
    
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram



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
         HEIGHT             = 2.01
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


{method/svc/autentic/autentic.i         
            &vUserName="c-seg-usuario"}

find first param-global no-lock no-error.
find first param-estoq  no-lock no-error.
find first param-compra no-lock no-error.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableFields DBOProgram 
PROCEDURE enableFields :
    DEFINE INPUT  PARAMETER pType        AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER pFieldName   AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pEnableField AS LOGICAL   NO-UNDO.
    DEF VAR l-unica AS LOGICAL INITIAL YES NO-UNDO.
    
    DEFINE VARIABLE i-empresa      AS CHARACTER NO-UNDO. /* cd9970.i */
    DEFINE VARIABLE lUseCostCenter AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE hUtb742za      AS HANDLE    NO-UNDO.

    IF (RowObject.nr-requisicao = 0 OR RowObject.nr-requisicao = ?) THEN RETURN "NOK":U.

    {cdp/findrequisicao.i RowObject.nr-requisicao}
    IF NOT AVAIL requisicao THEN RETURN "NOK":U.

    {cdp/findusuarmater.i requisicao.nome-abrev}
    IF NOT AVAIL usuar-mater THEN RETURN "NOK":U.

    {cdp/findparamglobal.i}
    IF NOT AVAIL param-global THEN RETURN "NOK":U.

    CASE pFieldName:
        WHEN "sequencia":U THEN DO:
            pEnableField = FALSE.
        END.
        WHEN "it-codigo":U THEN DO:
            pEnableField = (pType = "CREATE":U).
        END.
        WHEN "cod-refer":U THEN DO:
            {cdp/finditem.i RowObject.it-codigo}
            IF NOT AVAIL item THEN RETURN "NOK":U.

            pEnableField = (item.tipo-con-est = 4) AND (pType <> "UPDATE":U).

            RowObject.cod-refer = IF pEnableField OR pType = "UPDATE":U THEN RowObject.cod-refer ELSE "":U.
        END.
        WHEN "un":U THEN DO:
            pEnableField = FALSE.
        END.
        WHEN "qt-requisitada":U THEN DO:
            pEnableField = TRUE.
        END.
        WHEN "preco-unit":U THEN DO:
            pEnableField = FALSE.
        END.
        WHEN "qt-a-atender":U THEN DO:
            pEnableField = TRUE.
        END.
        WHEN "dt-entrega":U THEN DO:
            pEnableField = TRUE.
        END.
        WHEN "hra-entrega":U THEN DO:
            pEnableField = TRUE.
        END.
        WHEN "narrativa":U THEN DO:
            pEnableField = TRUE.
        END.
        WHEN "prioridade-aprov":U THEN DO:
            pEnableField = (pType <> "UPDATE":U).
        END.
        WHEN "log-1":U THEN DO:
            pEnableField = (pType <> "UPDATE":U).
        END.
        WHEN "num-ord-inv":U THEN DO:
            /* Quando existe ordem de produ‡Æo, bloquear ordem de investimento */
            IF (RowObject.nr-ord-produ <> 0 AND RowObject.nr-ord-produ <> ?) THEN DO:
                pEnableField = FALSE.
            END.
            ELSE DO:
                pEnableField = (UPPER(pType) = "CREATE":U AND CONNECTED("mginv") AND param-global.modulo-in).
            END.
        END.
        WHEN "ep-codigo":U THEN DO:
            pEnableField = FALSE.
        END.
        WHEN "char-2":U THEN DO: /* cod-utiliz */
            pEnableField = IF (RowObject.num-ord-inv <> 0 AND RowObject.num-ord-inv <> ?) THEN FALSE ELSE SUBSTR(usuar-mater.char-1,1,1) = "Y":U .

            RowObject.char-2 = IF pEnableField OR pType = "UPDATE":U THEN RowObject.char-2 ELSE "":U.
        END.
        WHEN "ct-codigo":U THEN DO:

            /* Se existe ordem de produ‡Æo bloquear conta cont bil */
            IF (RowObject.nr-ord-produ <> 0 AND RowObject.nr-ord-produ <> ?) THEN DO:
                pEnableField = FALSE.
                RETURN "OK":U.
            END.

            {cdp/finditem.i RowObject.it-codigo}
            IF NOT AVAIL item THEN RETURN "NOK":U.         
            
            FIND FIRST item-uni-estab 
                 where item-uni-estab.it-codigo   = item.it-codigo
                 and   item-uni-estab.cod-estabel = requisicao.cod-estabel 
                NO-LOCK NO-ERROR.
            IF AVAIL item-uni-estab THEN
                pEnableField  = item-uni-estab.altera-conta.
            ELSE DO:
                FIND FIRST fam-mat-estab 
                     where fam-mat-estab.fm-codigo   = item.fm-codigo
                     and   fam-mat-estab.cod-estabel = requisicao.cod-estabel 
                    NO-LOCK NO-ERROR.
                IF AVAIL fam-mat-estab THEN
                    pEnableField  = fam-mat-estab.altera-conta.
            END.  
            
            IF NOT pEnableField THEN
                pEnableField = usuar-mater.log-1.
            ELSE DO:
                pEnableField = FALSE.
            END.
            
        END.
        WHEN "sc-codigo":U THEN DO:
            
            /* Se existe ordem de produ‡Æo bloquear centro de custo */
            IF (RowObject.nr-ord-produ <> 0 AND RowObject.nr-ord-produ <> ?) THEN DO:
                pEnableField = FALSE.
                RETURN "OK":U.
            END.

            {cdp/finditem.i RowObject.it-codigo}
            IF NOT AVAIL item THEN RETURN "NOK":U.
            
            FIND FIRST item-uni-estab
                 where item-uni-estab.it-codigo   = item.it-codigo
                 and   item-uni-estab.cod-estabel = requisicao.cod-estabel 
                NO-LOCK NO-ERROR.
            IF AVAIL item-uni-estab THEN
                pEnableField  = item-uni-estab.altera-conta.
            ELSE DO:
                FIND FIRST fam-mat-estab
                    where fam-mat-estab.fm-codigo   = item.fm-codigo
                    and   fam-mat-estab.cod-estabel = requisicao.cod-estabel 
                    NO-LOCK NO-ERROR.
                if avail fam-mat-estab THEN
                    pEnableField  = fam-mat-estab.altera-conta.
            END.
            
            IF NOT pEnableField THEN DO:
            
                IF NOT VALID-HANDLE(hUtb742za) THEN RUN prgint/utb/utb742za.py PERSISTENT SET hUtb742za.
                RUN pi_verifica_utilizacao_ccusto IN hUtb742za (
                    INPUT  i-empresa,
                    INPUT  requisicao.cod-estabel,
                    INPUT  "",
                    INPUT  RowObject.ct-codigo,
                    INPUT  TODAY,
                    OUTPUT lUseCostCenter,
                    OUTPUT TABLE tt_log_erro
                ).
                pEnableField = IF lUseCostCenter THEN usuar-mater.log-2 ELSE lUseCostCenter.
            END.
            ELSE DO:
                pEnableField = FALSE.
            END.
            RowObject.sc-codigo = IF pEnableField THEN RowObject.sc-codigo ELSE "":U.
        END.
        WHEN "cod-unid-negoc":U THEN DO:
            /* Se existe ordem de produ‡Æo bloquear unidade de neg¢cio */
            IF (RowObject.nr-ord-produ <> 0 AND RowObject.nr-ord-produ <> ?) THEN DO:
                pEnableField = FALSE.
                RETURN "OK":U.
            END.

            pEnableField = (RowObject.num-ord-inv = ? OR RowObject.num-ord-inv = 0)
                        AND (l-unidade-negocio = yes)
                        AND (pType <> "UPDATE":U).

            RowObject.cod-unid-negoc =
                IF pEnableField THEN RowObject.cod-unid-negoc ELSE "":U.
        END.
        WHEN "nr-ord-produ":U THEN DO:
            pEnableField = (RowObject.num-ord-inv = ? OR RowObject.num-ord-inv = 0).
        END.
        WHEN "item-pai":U THEN DO:

            FIND FIRST ord-prod
                WHERE ord-prod.nr-ord-produ = RowObject.nr-ord-produ
            NO-LOCK NO-ERROR.

             assign l-unica = YES.
            IF AVAILABLE ord-prod THEN DO:
               
                /* Busca opera‡äes da ordem */
                FOR EACH oper-ord
                    WHERE oper-ord.nr-ord-produ = ord-prod.nr-ord-produ
                    AND oper-ord.cod-roteiro <> ""
                    NO-LOCK:

                    /* Se encontrar mais de uma opera‡Æo */
                    IF l-unica = NO THEN DO:
                        /* Bloqueia campos */
                        pEnableField = FALSE.
                        LEAVE.
                    END.

                    /* Se for a primeira opera‡Æo encontrada */
                    ELSE DO:
                        /* Habilita campos */
                        pEnableField = TRUE.
                        ASSIGN l-unica = NO.
                    END.
                
                END.
            
                FIND FIRST oper-ord 
                WHERE oper-ord.nr-ord-produ = ord-prod.nr-ord-produ 
                AND oper-ord.cod-roteiro     <> "" NO-LOCK NO-ERROR.
                
                IF AVAIL oper-ord THEN
                    pEnableField = TRUE.

            END.
            ELSE 
                 pEnableField = FALSE.
        
        END.
        WHEN "cod-roteiro":U THEN DO:
            FIND FIRST ord-prod
                WHERE ord-prod.nr-ord-produ = RowObject.nr-ord-produ
            NO-LOCK NO-ERROR.

             assign l-unica = YES.
            IF AVAILABLE ord-prod THEN DO:
               
                /* Busca opera‡äes da ordem */
                FOR EACH oper-ord
                    WHERE oper-ord.nr-ord-produ = ord-prod.nr-ord-produ
                    AND oper-ord.cod-roteiro <> ""
                    NO-LOCK:

                    /* Se encontrar mais de uma opera‡Æo */
                    IF l-unica = NO THEN DO:
                        /* Bloqueia campos */
                        pEnableField = FALSE.
                        LEAVE.
                    END.

                    /* Se for a primeira opera‡Æo encontrada */
                    ELSE DO:
                        /* Habilita campos */
                        pEnableField = TRUE.
                        ASSIGN l-unica = NO.
                    END.

                END.

                FIND FIRST oper-ord 
                WHERE oper-ord.nr-ord-produ = ord-prod.nr-ord-produ 
                AND oper-ord.cod-roteiro     <> "" NO-LOCK NO-ERROR.
                
                IF AVAIL oper-ord THEN
                    pEnableField = TRUE.
            END.
            ELSE 
                 pEnableField = FALSE.
        END.
        WHEN "op-seq":U THEN DO:
            FIND FIRST ord-prod
                WHERE ord-prod.nr-ord-produ = RowObject.nr-ord-produ
            NO-LOCK NO-ERROR.

           assign l-unica = YES.
            IF AVAILABLE ord-prod THEN DO:

                /* Busca opera‡äes da ordem */
                FOR EACH oper-ord
                    WHERE oper-ord.nr-ord-produ = ord-prod.nr-ord-produ
                    AND oper-ord.cod-roteiro <> ""
                    NO-LOCK:

                    /* Se encontrar mais de uma opera‡Æo */
                    IF l-unica = NO THEN DO:
                        /* Bloqueia campos */
                        pEnableField = FALSE.
                        LEAVE.
                    END.

                    /* Se for a primeira opera‡Æo encontrada */
                    ELSE DO:
                        /* Habilita campos */
                        pEnableField = TRUE.
                        ASSIGN l-unica = NO.
                    END.

                END.

                FIND FIRST oper-ord 
                WHERE oper-ord.nr-ord-produ = ord-prod.nr-ord-produ 
                AND oper-ord.cod-roteiro     <> "" NO-LOCK NO-ERROR.
                
                IF AVAIL oper-ord THEN
                    pEnableField = TRUE.
            END. 
            ELSE 
                 pEnableField = FALSE.
        END.
    
    END. 

    RETURN "OK":U.

    FINALLY:
        DELETE OBJECT hUtb742za NO-ERROR.
    END FINALLY.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE alteraCompradorEDepositoItRequisicao DBOProgram 
PROCEDURE alteraCompradorEDepositoItRequisicao :
/*------------------------------------------------------------------------------
  Purpose: Valida e altera o comprador e o depï¿½sito das ordens selecionadas.  
  Parameters: 
             ipar1 : prItRequisicao : rowid do item da requisicao
             ipar2 : pcCodDepos     : cï¿½digo do depï¿½sito 
             ipar3 : pcCodComprado  : cï¿½digo do comprador
             ipar4 : plCodDepos     : indica se o depï¿½sito deverï¿½ ser alterado 
             ipar5 : plCodComprado  : indica se o comprador deverï¿½ ser alterado
             opar6 : rowErrors      : tabela de erros
  Notes:       
------------------------------------------------------------------------------*/

    def input  param prOrdemCompra  as rowid no-undo.
    def input  param pcCodDepos     as char  no-undo.
    def input  param pcCodComprado  as char  no-undo.
    def input  param plCodDepos     as log   no-undo.
    def input  param plCodComprado  as log   no-undo.
    def output param table for RowErrors.
    
    if plCodComprado then do:
        if  not can-find (comprador where comprador.cod-comprado = pcCodComprado)
        then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-comprador AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Comprador" *}
            ASSIGN c-lbl-liter-comprador = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                               &ErrorNumber="47"
                               &ErrorType="EMS"
                               &ErrorSubType="ERROR" 
                               &ErrorParameters="c-lbl-liter-comprador"} 
        end. 
    end.
               
    if  plCodDepos then do:           
        if  not can-find(deposito where deposito.cod-depos = pcCodDepos)
        then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-deposito AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Deposito" *}
            ASSIGN c-lbl-liter-deposito = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                               &ErrorNumber="47"
                               &ErrorType="EMS"
                               &ErrorSubType="ERROR" 
                               &ErrorParameters="c-lbl-liter-deposito"}
        end.     
    end.
   
    
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN 
        RETURN "NOK":U.  

    ELSE DO: 
        FOR EACH it-requisicao fields (cod-depos char-1)
            where rowid(it-requisicao) = prOrdemCompra EXCLUSIVE-LOCK:
            if plCodDepos then     
                assign it-requisicao.cod-depos  = pcCodDepos. 
            if plCodComprado then DO:
                &if '{&bf_mat_versao_ems}' >= '2.071' &then
                    ASSIGN it-requisicao.cod-comprado = pcCodComprado.
                &ELSE
                    assign substring(it-requisicao.char-1,2,12) = pcCodComprado.
                &endif
            END.
        END.    
    END.

    RETURN "OK". 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atribuiPrecoDebitoNaoDireto DBOProgram 
PROCEDURE atribuiPrecoDebitoNaoDireto :
/*------------------------------------------------------------------------------
  Purpose:    Include.: CD1406A.i5 Objetivo: Validar campos a partir da narrativa.
  Parameters:  
  Notes:
------------------------------------------------------------------------------*/ 
    find first item-estab no-lock 
         where item-estab.it-codigo   = RowObject.it-codigo
           and item-estab.cod-estabel = requisicao.cod-estabel no-error.
    if not avail item-estab then do:
        create item-estab.
        assign item-estab.it-codigo   = RowObject.it-codigo
               item-estab.cod-estabel = requisicao.cod-estabel.
    end.

    &if defined(bf_mat_custeio_item) &then
         find first estab-mat no-lock 
              where estab-mat.cod-estabel = item-estab.cod-estabel no-error.
    &endif
    
    find first estabelec no-lock 
         where estabelec.cod-estabel = item-estab.cod-estabel no-error.
    if item.tipo-contr <> 4 or
      (item.it-codigo  <> " " and
       item.it-codigo  <> ?) then do:
       if usuar-mater.tp-preco = 1 and item.tipo-contr <> 4 then do:
            &if  defined(bf_mat_custeio_item) &then
                if  avail estab-mat then do:
                    if  estab-mat.custo-contab = 1 then
                        assign de-preco-u = (item-estab.val-unit-mat-m[1]
                                             +  item-estab.val-unit-ggf-m[1]
                                             +  item-estab.val-unit-mob-m[1]).
                    else
                    if  estab-mat.custo-contab = 2 then
                        assign de-preco-u = (item-estab.val-unit-mat-o[1]
                                             +  item-estab.val-unit-ggf-o[1]
                                             +  item-estab.val-unit-mob-o[1]).
                end.            
            &else
                if  avail estabelec then do:
                    if  estabelec.custo-contab = 1 then
                        assign de-preco-u = (item-estab.val-unit-mat-m[1]
                                             +  item-estab.val-unit-ggf-m[1]
                                             +  item-estab.val-unit-mob-m[1]).
                    else
                    if  estabelec.custo-contab = 2 then
                        assign de-preco-u = (item-estab.val-unit-mat-o[1]
                                             +  item-estab.val-unit-ggf-o[1]
                                             +  item-estab.val-unit-mob-o[1]).
                    else
                    if  estabelec.custo-contab = 3 then
                        assign de-preco-u = (item-estab.val-unit-mat-p[1]
                                             +  item-estab.val-unit-ggf-p[1]
                                             +  item-estab.val-unit-mob-p[1]).
                end.
            &endif
            
            if  de-preco-u = 0 then do:
                assign de-preco-u = item.preco-ul-ent.        
                  if avail estabelec then do:
                    for first item-uni-estab fields(it-codigo cod-estabel preco-ul-ent) where 
                        item-uni-estab.it-codigo   = item.it-codigo and
                        item-uni-estab.cod-estabel = estabelec.cod-estabel no-lock: end.
                    if avail item-uni-estab then    
                       assign de-preco-u = item-uni-estab.preco-ul-ent.
                  end.    

                if  de-preco-u <> 0 then do:
                    /* ï¿½ltima Entrada */
                    {method/svc/errors/inserr.i
                                       &ErrorNumber="3168"
                                       &ErrorType="EMS"
                                       &ErrorSubType="ERROR" 
                                       &ErrorParameters="''"}
                end.
                else do:
                    assign de-preco-u = item.preco-repos.
                      if avail estabelec then do:
                        for first item-uni-estab fields(it-codigo cod-estabel preco-repos) where 
                            item-uni-estab.it-codigo   = item.it-codigo and
                            item-uni-estab.cod-estabel = estabelec.cod-estabel no-lock: end.
                        if avail item-uni-estab then    
                           assign de-preco-u = item-uni-estab.preco-repos.
                      end.     
                    if  de-preco-u <> 0 then do: /* Preï¿½o Reposiï¿½ï¿½o */
                        {method/svc/errors/inserr.i
                                           &ErrorNumber="3169"
                                           &ErrorType="EMS"
                                           &ErrorSubType="INFORMATION"}
                    end.     
                    else do:
                        assign de-preco-u = item.preco-base.
                          if avail estabelec then do:
                            for first item-uni-estab fields(it-codigo cod-estabel preco-base) where 
                                item-uni-estab.it-codigo   = item.it-codigo and
                                item-uni-estab.cod-estabel = estabelec.cod-estabel no-lock: end.
                            if avail item-uni-estab then    
                               assign de-preco-u = item-uni-estab.preco-base.
                          end.     
                        if  de-preco-u <> 0 then do: /* Preï¿½o Base */
                            {method/svc/errors/inserr.i
                                               &ErrorNumber="3170"
                                               &ErrorType="EMS"
                                               &ErrorSubType="ERROR" 
                                               &ErrorParameters="''"} 
                        end.     
                        else do:
                            assign de-preco-u = 1.
                            /* Valorizada a 1,00 */
                            {method/svc/errors/inserr.i
                                               &ErrorNumber="8509"
                                               &ErrorType="EMS"
                                               &ErrorSubType="ERROR" 
                                               &ErrorParameters="''"}     
                        end.
                    end.
                end.
            end.

       end.
       else do:
            if (usuar-mater.tp-preco = 2 and item.tipo-contr <> 4)
            or  item.tipo-contr       = 4  then do:
                assign de-preco-u = item.preco-base.
                  if avail estabelec then do:
                    for first item-uni-estab fields(it-codigo cod-estabel preco-base) where 
                        item-uni-estab.it-codigo   = item.it-codigo and
                        item-uni-estab.cod-estabel = estabelec.cod-estabel no-lock: end.
                    if avail item-uni-estab then    
                       assign de-preco-u = item-uni-estab.preco-base.
                  end.     
                if  de-preco-u = 0 then do:
                    assign de-preco-u = item.preco-ul-ent.
                      if avail estabelec then do:
                        for first item-uni-estab fields(it-codigo cod-estabel preco-ul-ent) where 
                            item-uni-estab.it-codigo   = item.it-codigo and
                            item-uni-estab.cod-estabel = estabelec.cod-estabel no-lock: end.
                        if avail item-uni-estab then    
                           assign de-preco-u = item-uni-estab.preco-ul-ent.
                      end.     
                    if  de-preco-u <> 0 then do: /* ï¿½ltima Entrada */
                        {method/svc/errors/inserr.i
                                           &ErrorNumber="3168"
                                           &ErrorType="EMS"
                                           &ErrorSubType="ERROR" 
                                           &ErrorParameters="''"}   
                    end.                                     
                    else do:
                        assign de-preco-u = item.preco-repos.
                          if avail estabelec then do:
                            for first item-uni-estab fields(it-codigo cod-estabel preco-repos) where 
                                item-uni-estab.it-codigo   = item.it-codigo and
                                item-uni-estab.cod-estabel = estabelec.cod-estabel no-lock: end.
                            if avail item-uni-estab then    
                               assign de-preco-u = item-uni-estab.preco-repos.
                          end.     
                        if  de-preco-u <> 0 then do:
                            {method/svc/errors/inserr.i
                                               &ErrorNumber="3169"
                                               &ErrorType="EMS"
                                               &ErrorSubType="INFORMATION"}
                        end.                                     
                        else do:
                            assign de-preco-u = 1.
                                {method/svc/errors/inserr.i
                                                   &ErrorNumber="8509"
                                                   &ErrorType="EMS"
                                                   &ErrorSubType="ERROR" 
                                                   &ErrorParameters="''"}
                        end.
                    end.
                end.
            end.
            else do:
                if (usuar-mater.tp-preco = 3 and item.tipo-contr <> 4)
                or  item.tipo-contr       = 4 then do:
                    assign de-preco-u = item.preco-repos.
                      if avail estabelec then do:
                        for first item-uni-estab fields(it-codigo cod-estabel preco-repos) where 
                            item-uni-estab.it-codigo   = item.it-codigo and
                            item-uni-estab.cod-estabel = estabelec.cod-estabel no-lock: end.
                        if avail item-uni-estab then    
                           assign de-preco-u = item-uni-estab.preco-repos.
                      end.     
                    if  de-preco-u = 0 then do:
                        assign de-preco-u = item.preco-ul-ent.
                          if avail estabelec then do:
                            for first item-uni-estab fields(it-codigo cod-estabel preco-ul-ent) where 
                                item-uni-estab.it-codigo   = item.it-codigo and
                                item-uni-estab.cod-estabel = estabelec.cod-estabel no-lock: end.
                            if avail item-uni-estab then    
                               assign de-preco-u = item-uni-estab.preco-ul-ent.
                          end.     
                        if  de-preco-u <> 0 then do:
                            {method/svc/errors/inserr.i
                                               &ErrorNumber="3168"
                                               &ErrorType="EMS"
                                               &ErrorSubType="ERROR" 
                                               &ErrorParameters="''"}  
                        end.                                      
                        else do:
                            assign de-preco-u = item.preco-base.
                              if avail estabelec then do:
                                for first item-uni-estab fields(it-codigo cod-estabel preco-base) where 
                                    item-uni-estab.it-codigo   = item.it-codigo and
                                    item-uni-estab.cod-estabel = estabelec.cod-estabel no-lock: end.
                                if avail item-uni-estab then    
                                   assign de-preco-u = item-uni-estab.preco-base.
                              end.     
                            if  de-preco-u <> 0 then do:
                                {method/svc/errors/inserr.i
                                                   &ErrorNumber="3170"
                                                   &ErrorType="EMS"
                                                   &ErrorSubType="ERROR" 
                                                   &ErrorParameters="''"}
                            end.                                      
                            else do:
                                assign de-preco-u = 1.
                                {method/svc/errors/inserr.i
                                                   &ErrorNumber="8508"
                                                   &ErrorType="EMS"
                                                   &ErrorSubType="ERROR" 
                                                   &ErrorParameters="''"}  
                            end.
                        end.
                    end.
                end.
                else do:
                    if (usuar-mater.tp-preco = 4
                    and item.tipo-contr      <> 4)
                    or  item.tipo-contr       = 4 then do:
                        assign de-preco-u = item.preco-ul-ent.
                          if avail estabelec then do:
                            for first item-uni-estab fields(it-codigo cod-estabel preco-ul-ent) where 
                                item-uni-estab.it-codigo   = item.it-codigo and
                                item-uni-estab.cod-estabel = estabelec.cod-estabel no-lock: end.
                            if avail item-uni-estab then    
                               assign de-preco-u = item-uni-estab.preco-ul-ent.
                          end.     
                        if  de-preco-u = 0 then do:
                            assign de-preco-u = item.preco-repos.
                              if avail estabelec then do:
                                for first item-uni-estab fields(it-codigo cod-estabel preco-repos) where 
                                    item-uni-estab.it-codigo   = item.it-codigo and
                                    item-uni-estab.cod-estabel = estabelec.cod-estabel no-lock: end.
                                if avail item-uni-estab then    
                                   assign de-preco-u = item-uni-estab.preco-repos.
                              end.     
                            if  de-preco-u <> 0 then do:
                                {method/svc/errors/inserr.i
                                                   &ErrorNumber="3169"
                                                   &ErrorType="EMS"
                                                   &ErrorSubType="INFORMATION"}
                            end.    
                            else do:
                                assign de-preco-u = item.preco-base.
                                  if avail estabelec then do:
                                    for first item-uni-estab fields(it-codigo cod-estabel preco-base) where 
                                        item-uni-estab.it-codigo   = item.it-codigo and
                                        item-uni-estab.cod-estabel = estabelec.cod-estabel no-lock: end.
                                    if avail item-uni-estab then    
                                       assign de-preco-u = item-uni-estab.preco-base.
                                  end.     
                                if  de-preco-u <> 0 then do:
                                    {method/svc/errors/inserr.i
                                                       &ErrorNumber="3170"
                                                       &ErrorType="EMS"
                                                       &ErrorSubType="ERROR" 
                                                       &ErrorParameters="''"}
                                end.    
                                else do:
                                    assign de-preco-u = 1.
                                    {method/svc/errors/inserr.i
                                                       &ErrorNumber="8509"
                                                       &ErrorType="EMS"
                                                       &ErrorSubType="ERROR" 
                                                       &ErrorParameters="''"}
                                end.
                            end.
                        end.
                    end.
                     else do:
                        {method/svc/errors/inserr.i
                                           &ErrorNumber="1627"
                                           &ErrorType="EMS"
                                           &ErrorSubType="ERROR" 
                                           &ErrorParameters="''"}   
                    end.
                end.
            end.
       end.
    end.
    assign r-requisicao = rowid(requisicao).

    
/*    /*---------------------- chamada IN2201 --------------------
 *     if  param-global.modulo-in = yes then do:
 *         run inp/in2201.p (input  ROWID(RowObject),
 *                           output l-achou, output i-ct-codigo,
 *                           output i-sc-codigo).
 *         /*
 *         if  not l-achou
 *         and RowObject.num-ord-inv <> 0 then do:
 *             run utp/ut-msgs.p (input "show", input 7175, input "").
 *             apply 'entry' to RowObject.it-codigo in frame {&frame-name}.
 *             return 'adm-error'.
 *         end.
 *         */ /*****estï¿½ comentado no uib*******/*/
    
        find estabelec where estabelec.cod-estabel = 
             RowObject.cod-estabel no-lock no-error.
        
        assign RowObject.num-ord-inv 
               RowObject.ep-codigo = if param-global.modulo-in and 
                                         RowObject.num-ord-inv <> 0
                                         then if avail estabelec estabelec.ep-codigo
                                         else  param-global.empresa-prin.
    end.
    
/*    ----------------------- chamada IN2101 --------------------
 *     if  param-global.modulo-in
 *     and RowObject.num-ord-inv <> 0 then do:
 *         assign r-requisicao = rowid(requisicao)
 *                r-item-re    = rowid(RowObject).
 *         run inp/in2101.p (input r-requisicao, 
 *                           input r-item-re,
 *                           input c-opcao-aux).
 *     end.
 *     -----------------------------------------------------------*/*/
    /* fim include */

    return "OK". 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BeforeCreateRecord DBOProgram 
PROCEDURE BeforeCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &if  "{&mgadm_version}" >= "2.04" &then 
         /*API de Execuï¿½ï¿½o Orï¿½amentï¿½ria*/
         RUN cdp/cdapi193.p (INPUT ?,                 /*rowid it-requisicao*/
                             INPUT TABLE rowobject,   /*registro alterado*/
                             INPUT 1,                 /*funcao: 1-BeforeCreateRecord Item-Requisicao*/
                             OUTPUT TABLE RowErrors). /*tt que retorna erro*/
    &endif

    IF  CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    ELSE
        RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BeforeDeleteRecord DBOProgram 
PROCEDURE BeforeDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &if  "{&mgadm_version}" >= "2.04" &then     
         /*API de Execuï¿½ï¿½o Orcamentï¿½ria*/
        RUN cdp/cdapi193.p (INPUT ROWID(it-requisicao), /*rowid it-requisicao*/
                            INPUT TABLE rowobject,      /*rowid do registro alterado*/
                            INPUT 3,                    /*funcao: 1-BeforeDeleteRecord Item-Requisiï¿½ï¿½o*/
                            OUTPUT TABLE Rowerrors).    /*tt que retorna erro*/
    &endif
    /*************************************************************
    **  Validaï¿½ï¿½es necessï¿½rias para Tabela (req-ord-produc)     **
    *************************************************************/
    define variable l-ordem-requis as logical no-undo.
    /** Valida se Registros de Movimentos de Estoque do tipo 7 (DRM) e 30 (RM)
        contï¿½m a extensï¿½o <req-ord-produc> para a tabela <it-requisicao> **/
    &IF '{&bf_mat_versao_ems}' >= '2.05' &THEN
        assign l-ordem-requis = yes.
    &else
        assign l-ordem-requis = no.
        &IF '{&bf_mat_versao_ems}' >= '2.04' &THEN
            for first funcao
                where funcao.cd-funcao = "spp-int-req-om":U
                and   funcao.ativo     = yes no-lock:
                assign l-ordem-requis = yes.
            end.
        &ENDIF
    &ENDIF
    /************************************************************/
    /* exclusï¿½o do relacionamento entre item da requisiï¿½ï¿½o e ordem de manutenï¿½ï¿½o */
    if l-ordem-requis then
        run cdp/cd0741.p (input it-requisicao.nr-requisicao,
                          input it-requisicao.sequencia).
    /* Fim exclusï¿½o do relacionamento entre item da requisiï¿½ï¿½o e ordem de manutenï¿½ï¿½o */

  

    /*--- Verifica ocorrï¿½ncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
       RETURN "NOK":U.


    RETURN "OK":U.

END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterDeleteRecord DBOProgram 
PROCEDURE AfterDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Tratamento para regerar as pedencias caso nï¿½o seja o ultimo item e seja aprovaï¿½ï¿½o por total*/
if avail param-compra and 
   param-compra.log-1 and
   ((i-tipo-doc = 1 and substring(param-compra.char-2, 1, 3) = "sim") or
    (i-tipo-doc = 2 and substring(param-compra.char-2, 4, 3) = "sim") or 
    i-tipo-doc > 2 )  
    and avail requisicao then do:
        find first it-requisicao where  
            (it-requisicao.situacao = 1 or it-requisicao.situacao = 3) and
             it-requisicao.nr-requisicao = requisicao.nr-requisicao no-lock no-error.

        if  avail it-requisicao and i-tipo-doc <> 5
            then run cdp/cdapi171.p (i-tipo-doc, 2, rowid(it-requisicao)).
end.

END PROCEDURE.



/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BeforeUpdateRecord DBOProgram 
PROCEDURE BeforeUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &if  "{&mgadm_version}" >= "2.04" &then               
         /*API de Execuï¿½ï¿½o Orcamentï¿½ria*/
         RUN cdp/cdapi193.p (INPUT ROWID(it-requisicao), /*rowid it-requisicao*/
                             INPUT TABLE rowobject,      /*registro alterado*/
                             INPUT 2,                    /*funcao: 5-BeforeUpdateRecord Item-Requisicao*/
                             OUTPUT TABLE Rowerrors).    /*tt que retorna erro*/
    &endif

    IF  CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    ELSE
        RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableButtonsItRequisicao DBOProgram 
PROCEDURE enableButtonsItRequisicao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:
------------------------------------------------------------------------------*/
    def input  param prRequisicao    as rowid no-undo.
    def input  param pcUsuario       as char  no-undo.
    def output param plbt-habilitado as log   no-undo.
    
    def var c-usuario-aux as char no-undo.
    
    assign c-usuario-aux = pcUsuario.
    
    find requisicao where 
         rowid(requisicao) = prRequisicao 
         no-lock no-error.
         
    find first it-requisicao where 
         it-requisicao.nr-requisicao = requisicao.nr-requisicao 
         no-lock no-error.

    if avail it-requisicao then
        assign i-seq = it-requisicao.sequencia.
    
    if avail requisicao then do:
        for first usuar-mater fields (cod-usuario char-1)
           where usuar-mater.cod-usuario = c-usuario-aux
           no-lock: END.
        if requisicao.nome-abrev <> c-usuario-aux   
        &if defined(bf_mat_aprova_eletronica) &then
        and avail usuar-mater 
        and substring(usuar-mater.char-1,10,01) <> "Y" &endif
        then
            assign plbt-habilitado = no /* disable */.
        else do:
            assign plbt-habilitado = yes /*enable*/.
            if avail it-requisicao then do:
                if it-requisicao.situacao = 2 or it-requisicao.situacao = 4 then do:         
                    assign plbt-habilitado = no /* disable */.
                end.  
                else
                    assign plbt-habilitado = yes /*enable*/.
            end. 
            else
                assign plbt-habilitado = yes /*enable*/.
        end.
    end.
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableFieldsMod DBOProgram 
PROCEDURE enableFieldsMod :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:
------------------------------------------------------------------------------*/

    def input  param prItRequisicao as rowid no-undo.
    def input  param prRequisicao   as rowid no-undo.
    def output param plCtCodigo     as log   no-undo.
    def output param plScCodigo     as log   no-undo.
    def output param plCodUtiliz    as log   no-undo.
    def output param plNumOrdInv    as log   no-undo.
    def output param plCodRefer     as log   no-undo.
    def output param plPrecoUnit    as log   no-undo.
    def output param plClassif      as log   no-undo.
    def output param piNatDesp      as int   no-undo.
    
    ASSIGN plCodRefer  = yes 
           plCtCodigo  = yes 
           plSCCodigo  = yes 
           plCodUtiliz = yes
           plNumOrdInv = yes
           plCodRefer  = yes
           plPrecoUnit = no.
    
    find it-requisicao where 
         rowid(it-requisicao) = prItRequisicao
         no-lock no-error.

    find requisicao where
         rowid(requisicao) = prRequisicao
         no-lock no-error.

    find first param-global 
        no-lock no-error.
    
    if avail it-requisicao then 
        find first item where
             item.it-codigo = it-requisicao.it-codigo
             no-lock no-error.

    find usuar-mater where 
         usuar-mater.cod-usuario = requisicao.nome-abrev 
         no-lock no-error.           
        
    /*mod*/     
    
    if  requisicao.tp-requis = 2 then /* solicitaï¿½ï¿½o de compras */
        assign plPrecoUnit = yes.

    if avail usuar-mater then
        assign plCtCodigo  = usuar-mater.log-1
               plScCodigo  = usuar-mater.log-2        
               plCodUtiliz = substring(usuar-mater.char-1,1,1) = "y" and
                             (not avail it-requisicao or 
                              (avail it-requisicao and it-requisicao.num-ord-inv = 0)).
                                         
    if avail it-requisicao then do:
        find item where
             item.it-codigo = it-requisicao.it-codigo 
             no-lock no-error.

        if  avail item and item.tipo-con-est = 4 then 
            assign plCodRefer = yes. /*enable*/
        
        if avail item then do:
            for first item-uni-estab fields (it-codigo cod-estabel nat-despesa altera-conta)
                where item-uni-estab.it-codigo   = item.it-codigo
                and   item-uni-estab.cod-estabel = requisicao.cod-estabel 
                no-lock: end.
            if avail item-uni-estab then
                assign l-classif  = item-uni-estab.altera-conta   /*se NO entï¿½o deve montar a conta*/
                       i-nat-desp = item-uni-estab.nat-despesa. /*nat-despesa*/
            else do:
                for first fam-mat-estab fields (fm-codigo cod-estabel nat-despesa altera-conta)
                    where fam-mat-estab.fm-codigo   = item.fm-codigo
                    and   fam-mat-estab.cod-estabel = requisicao.cod-estabel 
                    no-lock: end.
                if avail fam-mat-estab then 
                    assign l-classif  = fam-mat-estab.altera-conta
                           i-nat-desp = fam-mat-estab.nat-despesa. /*nat-despesa*/
                else 
                    assign l-classif  = no
                           i-nat-desp = item.nat-despesa. /*nat-despesa*/
            end.
        end.
        /* Se utilizar classificaï¿½ï¿½o contï¿½bil, nï¿½o sugere a conta
           (mesmo que o usuï¿½rio tenha permissï¿½o para alterar a conta/sub-conta */
           
        if l-classif then 
           assign  plCtCodigo = no /*disable*/ 
                   plScCodigo = no.

        if (it-requisicao.num-ord-inv <> 0 and
            it-requisicao.num-ord-inv <> ?) or
           param-global.modulo-in = no then do:
             assign plNumOrdInv = no.
        end.   
        /* Deverï¿½ ser retirado quando for feita uma DTR e corrigida a integraï¿½ï¿½o */
        assign plNumOrdInv = no.
    end.

/***
    find first param-estoq no-lock no-error.
    if avail param-estoq then do:
       if substr(param-estoq.char-1,3,1) = "Y" then assign plScCodigo = no.
    end.
****/

    assign plClassif = l-classif
           piNatDesp = i-nat-desp.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findRequis DBOProgram 
PROCEDURE findRequis :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter i-nr-requisicao LIKE requisicao.nr-requisicao  no-undo.
def input parameter i-sequencia     as int  no-undo.
def output parameter c-return       as char no-undo.

    RUN openQueryStatic (input "Main":U).

    RUN goToKeyReqSeq (input i-nr-requisicao,
                       input i-sequencia).
                      
  
    if return-value = "OK" then assign c-return = "".  
    
    if return-value = "NOK" then do:
        {utp/ut-table.i mgind {&TABLENAME} 1}
        run utp/ut-msgs.p (input "msg":U,
                           input 2,
                           input return-value).
        assign c-return =  return-value.  
    end.

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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject estï¿½ disponï¿½vel, caso nï¿½o esteja serï¿½
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "lote":U THEN ASSIGN pFieldValue = RowObject.lote.
        WHEN "narrativa":U THEN ASSIGN pFieldValue = RowObject.narrativa.
        WHEN "nome-abrev":U THEN ASSIGN pFieldValue = RowObject.nome-abrev.
        WHEN "nome-aprov":U THEN ASSIGN pFieldValue = RowObject.nome-aprov.
        WHEN "sc-codigo":U THEN ASSIGN pFieldValue = RowObject.sc-codigo.
        WHEN "un":U THEN ASSIGN pFieldValue = RowObject.un.
   &IF "{&mguni_version}" >= "2.071" &THEN
        WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
   &ELSE
   &ENDIF
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-depos":U THEN ASSIGN pFieldValue = RowObject.cod-depos.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-localiz":U THEN ASSIGN pFieldValue = RowObject.cod-localiz.
        WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
        WHEN "ct-codigo":U THEN ASSIGN pFieldValue = RowObject.ct-codigo.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.

    /*--- Verifica se temptable RowObject estï¿½ disponï¿½vel, caso nï¿½o esteja serï¿½
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "dt-atend":U THEN ASSIGN pFieldValue = RowObject.dt-atend.
        WHEN "dt-entrega":U THEN ASSIGN pFieldValue = RowObject.dt-entrega.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.

    /*--- Verifica se temptable RowObject estï¿½ disponï¿½vel, caso nï¿½o esteja serï¿½
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "qt-devolvida":U THEN ASSIGN pFieldValue = RowObject.qt-devolvida.
        WHEN "preco-unit":U THEN ASSIGN pFieldValue = RowObject.preco-unit.
        WHEN "qt-a-atender":U THEN ASSIGN pFieldValue = RowObject.qt-a-atender.
        WHEN "qt-a-devolver":U THEN ASSIGN pFieldValue = RowObject.qt-a-devolver.
        WHEN "qt-atendida":U THEN ASSIGN pFieldValue = RowObject.qt-atendida.
        WHEN "qt-requisitada":U THEN ASSIGN pFieldValue = RowObject.qt-requisitada.
        WHEN "val-item":U THEN ASSIGN pFieldValue = RowObject.val-item.
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.

    /*--- Verifica se temptable RowObject estï¿½ disponï¿½vel, caso nï¿½o esteja serï¿½
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "nr-requisicao":U THEN ASSIGN pFieldValue = RowObject.nr-requisicao.
        WHEN "num-ord-inv":U THEN ASSIGN pFieldValue = RowObject.num-ord-inv.
        WHEN "numero-ordem":U THEN ASSIGN pFieldValue = RowObject.numero-ordem.
        WHEN "seq-planej":U THEN ASSIGN pFieldValue = RowObject.seq-planej.
        WHEN "sequencia":U THEN ASSIGN pFieldValue = RowObject.sequencia.
        WHEN "situacao":U THEN ASSIGN pFieldValue = RowObject.situacao.
        &if defined(bf_mat_aprova_eletronica) &then
              WHEN "estado":U THEN ASSIGN pFieldValue = RowObject.estado.
        &endif
   &IF "{&mguni_version}" >= "2.071" &THEN
   &ELSE
        WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
   &ENDIF
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ï¿½ndice ITEM-REQ
  Parameters:
               retorna valor dos campos do ï¿½ndice ITEM-REQ
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnr-requisicao LIKE it-requisicao.nr-requisicao NO-UNDO.
    DEFINE OUTPUT PARAMETER psequencia LIKE it-requisicao.sequencia NO-UNDO.
    DEFINE OUTPUT PARAMETER pit-codigo LIKE it-requisicao.it-codigo NO-UNDO.

    /*--- Verifica se temptable RowObject estï¿½ disponï¿½vel, caso nï¿½o esteja serï¿½
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pnr-requisicao = RowObject.nr-requisicao.
    ASSIGN psequencia = RowObject.sequencia.
    ASSIGN pit-codigo = RowObject.it-codigo.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogField DBOProgram 
PROCEDURE getLogField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo lï¿½gico
  Parameters:
               recebe nome do campo
               retorna valor do campo
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject estï¿½ disponï¿½vel, caso nï¿½o esteja serï¿½
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RAW NO-UNDO.

    /*--- Verifica se temptable RowObject estï¿½ disponï¿½vel, caso nï¿½o esteja serï¿½
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




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRowidRequisicao DBOProgram 
PROCEDURE getRowidRequisicao :
/*------------------------------------------------------------------------------
  Purpose:     
    Procura o rowid da requisiï¿½ï¿½o a partir do numero da requisiï¿½ï¿½o
    que vem da tabela it-requisicao.
  Parameters:  
      ipar1 : r-it-requisicao : rowid do registro da tabela it-requisicao
      opar2 : r-requisicao    : rowid da tabela requisicao
  Notes:       
------------------------------------------------------------------------------*/
 
 def input  param r-it-requisicao as rowid no-undo.
 def output param r-requisicao    as rowid no-undo.    

    find it-requisicao where
         rowid(it-requisicao) = r-it-requisicao 
         no-lock no-error.
    
    if avail it-requisicao then do:
        find first requisicao where
                   requisicao.nr-requisicao = it-requisicao.nr-requisicao
                   no-lock no-error.
         if avail requisicao then
            assign r-requisicao = rowid(requisicao).
    end.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ï¿½ndice ITEM-REQ
  Parameters:
               recebe valor dos campos do ï¿½ndice ITEM-REQ
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-requisicao LIKE it-requisicao.nr-requisicao NO-UNDO.
    DEFINE INPUT PARAMETER psequencia LIKE it-requisicao.sequencia NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo LIKE it-requisicao.it-codigo NO-UNDO.

    FIND FIRST bfit-requisicao WHERE
        bfit-requisicao.nr-requisicao = pnr-requisicao AND
        bfit-requisicao.sequencia = psequencia AND
        bfit-requisicao.it-codigo = pit-codigo
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro serï¿½ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfit-requisicao THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atravï¿½s de rowid e verifica a ocorrï¿½ncia de erros, caso
          existam erros serï¿½ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfit-requisicao)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKeyReqSeq DBOProgram 
PROCEDURE goToKeyReqSeq :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter i-nr-requisicao LIKE requisicao.nr-requisicao no-undo.
def input parameter i-sequencia     as int no-undo.
 
    find first bfit-requisicao where
        bfit-requisicao.nr-requisicao = i-nr-requisicao and
        bfit-requisicao.sequencia = i-sequencia
        no-lock no-error.

    /*--- Verifica se registro foi encontrado, em caso de erro serï¿½ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfit-requisicao THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atravï¿½s de rowid e verifica a ocorrï¿½ncia de erros, caso
          existam erros serï¿½ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfit-requisicao)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE HabilitaBotaoBrowserItensCompra DBOProgram 
PROCEDURE HabilitaBotaoBrowserItensCompra :
/*------------------------------------------------------------------------------
  Purpose:     
    Verifica se os botoes Ordem,Parcela,Cotacao,Pedido,Recebimento,Narrativa podem ser habilitados
    ou nï¿½o.
  Parameters: 
    ipar1:  p-campos   : rowid it-requisicao, ordem e item do registro selecionado no browser Concatenados.
    opar2:  p-ordem    : rowid ordem-compra.
    opar3:  p-pedid    : rowid pedido.
    opar4:  p-receb    : rowid recebimento
    opar5:  p-item     : rowid item
    opar6:  p-bot-ordem: habilita botï¿½o ordem(yes/no)
    opar7:  p-bot-parce: habilita botï¿½o parcelas(yes/no)
    opar8:  p-bot-cotac: habilita botï¿½o cotaï¿½ï¿½o(yes/no)
    opar9:  p-bot-pedid: habilita botï¿½o pedido(yes/no)
    opar10: p-bot-receb: habilita botï¿½o recebimento(yes/no)
    opar11: p-bot-narra: habilita botï¿½o narrativa(yes/no)
  Notes:       
------------------------------------------------------------------------------*/
def input  param p-campos    as char  no-undo.
def output param p-ordem     as rowid no-undo.
def output param p-pedid     as rowid no-undo.
def output param p-receb     as rowid no-undo.
def output param p-item      as rowid no-undo.
def output param p-bot-ordem as char  no-undo.
def output param p-bot-parce as char  no-undo.
def output param p-bot-cotac as char  no-undo.
def output param p-bot-pedid as char  no-undo.
def output param p-bot-receb as char  no-undo.
def output param p-bot-narra as char  no-undo.
def var r-it-requis          as rowid no-undo.  
def var c-it-codigo          as char  no-undo.
def var i-ordem              as int   no-undo.
  assign
     p-bot-ordem = 'no'
     p-bot-parce = 'no'
     p-bot-cotac = 'no'
     p-bot-pedid = 'no'
     p-bot-receb = 'no'
     p-bot-narra = 'no'.
     
  assign r-it-requis = to-rowid(entry(1,p-campos))
         c-it-codigo = entry(2,p-campos)
         i-ordem     = int(entry(3,p-campos)).
         
      find first item where item.it-codigo = c-it-codigo no-lock no-error.
      if available item then 
          assign p-item = rowid(item).
      find ordem-compra where 
            ordem-compra.numero-ordem = i-ordem
            no-lock no-error.
      
      if available ordem-compra then do:
            assign  p-bot-ordem = 'yes'
                    p-bot-parce = 'yes'
                    p-bot-narra = 'yes'
                    p-ordem   = rowid(ordem-compra).

            find first cotacao-item where
                       cotacao-item.numero-ordem = ordem-compra.numero-ordem and
                       cotacao-item.cot-aprovada = yes no-lock no-error.
                    if available cotacao-item then 
                        assign p-bot-cotac = 'yes'.
            
            find pedido-compr where
                 pedido-compr.num-pedido = ordem-compra.num-pedido no-lock no-error.
            if available pedido-compr then do: 
               assign p-bot-pedid = 'yes'
                      p-pedid = rowid(pedido-compr).
               find first recebimento where 
                          recebimento.num-pedido   = pedido-compr.num-pedido and
                          recebimento.numero-ordem = ordem-compra.numero-ordem no-lock no-error.
               if avail recebimento then do:
                  assign p-receb = rowid(recebimento).
                  if recebimento.quant-receb > 0 then
                     assign p-bot-receb = 'yes'.  
                  else
                     assign p-bot-receb = 'no'.
               end.                        
            end.
            else
               assign p-bot-receb = 'no'.
      end.
      else do:
           assign  p-bot-ordem   = 'no'
                   p-bot-parce   = 'no'
                   p-bot-narra   = 'no'.      
      end.  
  return string(c-it-codigo) + string(i-ordem).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDefaultFields DBOProgram 
PROCEDURE initializeDefaultFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:
------------------------------------------------------------------------------*/
    def input  param prItRequisicao as rowid no-undo.
&IF "{&mguni_version}" >= "2.071" &THEN
    def output param piCodEmp       LIKE empresa.ep-codigo no-undo.
&ELSE
    def output param piCodEmp       as int no-undo.
&ENDIF
    def output param pdePreco       as dec no-undo.
    def output param plUrgente      as log no-undo.
    def output param plHomologa     as log no-undo.
    def output param plAfetaQlde    as log no-undo.
    def output param piPrioridade   as int no-undo.

    find first param-global
         no-lock no-error.
    
    find it-requisicao where 
         rowid(it-requisicao) = prItRequisicao
         no-lock no-error.

    find first requisicao where 
         requisicao.nr-requisicao = it-requisicao.nr-requisicao
         no-lock no-error.
    
    if avail requisicao then 
        find estabelec where 
             estabelec.cod-estabel = requisicao.cod-estabel 
             no-lock no-error.      
        if avail estabelec and param-global.modulo-in = yes
               then assign piCodEmp = estabelec.ep-codigo.
    
    if  avail it-requisicao then do:
       assign dePreco = it-requisicao.val-item / it-requisicao.qt-a-atender.

       if  dePreco <> 0 and dePreco <> ? then
           assign pdePreco = dePreco.
           
        if  it-requisicao.log-1 = yes then
            assign plUrgente = yes.
        else
            assign plUrgente = no.
        if  it-requisicao.log-2 = yes then
            assign plHomologa = yes.
        else
            assign plHomologa = no.
        if  substr(it-requisicao.char-1,1,1) = "Y" then
            assign plAfetaQlde = yes.
        else
            assign plAfetaQlde = no.
            
        &if defined(bf_mat_aprova_eletronica) &then
             if it-requisicao.prioridade-aprov >= 0 and
                it-requisicao.prioridade-aprov <= 300 then
                assign piPrioridade = 4.
             if it-requisicao.prioridade-aprov >  300 and
                it-requisicao.prioridade-aprov <= 600 then
                assign piPrioridade = 3.
             if it-requisicao.prioridade-aprov >  600 and
                it-requisicao.prioridade-aprov <  999 then
                assign piPrioridade = 2.
             if it-requisicao.prioridade-aprov =  999 then
                assign piPrioridade = 1.
        &endif  
    end.
    else assign piPrioridade = 4.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToOrdem-Compra DBOProgram 
PROCEDURE linkToOrdem-Compra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param ph-ordem as handle no-undo.
    
    RUN GetKey in ph-ordem (output ccod-comprado, output inum-ordem).
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToRequisicao DBOProgram 
PROCEDURE linkToRequisicao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param pRequisicao as handle no-undo.
    
    RUN GetKey in pRequisicao (OUTPUT c-cod-estabel, OUTPUT i-nr-requisicao).
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE unidNegRequisOfItem DBOProgram 
PROCEDURE unidNegRequisOfItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER TABLE FOR tt-it-requisicao-dest.
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-unid-neg-requis.

    for each tt-it-requisicao-dest:
        for each unid-neg-requis
            where unid-neg-requis.nr-requisicao = tt-it-requisicao-dest.nr-requis-orig
              and unid-neg-requis.sequencia     = tt-it-requisicao-dest.seq-requis-orig
              and unid-neg-requis.it-codigo     = tt-it-requisicao-dest.it-codigo no-lock:
            create tt-unid-neg-requis.
            buffer-copy unid-neg-requis except nr-requisicao sequencia to tt-unid-neg-requis.
            assign tt-unid-neg-requis.nr-requisicao = tt-it-requisicao-dest.nr-requisicao
                   tt-unid-neg-requis.sequencia     = tt-it-requisicao-dest.sequencia.
        end.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mensagemAprovacaoItemRequisicao DBOProgram 
PROCEDURE mensagemAprovacaoItemRequisicao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /**
    ***   Mensagem de Aprovaï¿½ï¿½o
    **/

    if i-tipo-doc > 0 then do:
        run cdp/cdapi174.p (i-tipo-doc,
                            rowid(it-requisicao),
                            output i-moeda-lim,
                            output i-tipo-moeda,
                            output de-valor-doc,
                            output de-valor-lim).
        find moeda where
            moeda.mo-codigo = i-moeda-lim
            no-lock no-error.
        assign c-moeda-lim  = string(i-moeda-lim,"9") + " - ":U + moeda.descricao.
        case i-tipo-moeda:
            when 1 then do:
                {utp/ut-liter.i (Usuï¿½rio) * r}
                assign c-tipo-moeda = return-value.
            end.
            when 2 then do:
                {utp/ut-liter.i (Aprovador) * r}
                assign c-tipo-moeda = return-value.
            end.
            when 3 then do:
                {utp/ut-liter.i (Famï¿½lia) * r}
                assign c-tipo-moeda = return-value.
            end.
            when 4 then do:
                {utp/ut-liter.i (Mestre) * r}
                assign c-tipo-moeda = return-value.
            end.
        end case.
       
       
        if it-requisicao.estado = 1 then do:
                {method/svc/errors/inserr.i &ErrorNumber="16725"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="INFORMATION":U
                                            &ErrorParameters="c-moeda-lim + '~~~~' 
                                                             + string(de-valor-lim,'zzz,zzz,zzz,zzz,zz9.99') 
                                                             + c-tipo-moeda + '~~~~' 
                                                             + string(de-valor-doc,'zzz,zzz,zzz,zzz,zz9.99')"}    
        end.
        else do:
                {method/svc/errors/inserr.i &ErrorNumber="16724"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="INFORMATION":U
                                            &ErrorParameters="c-moeda-lim + '~~~~' 
                                                             + string(de-valor-lim,'zzz,zzz,zzz,zzz,zz9.99') 
                                                             + c-tipo-moeda + '~~~~' 
                                                             + string(de-valor-doc,'zzz,zzz,zzz,zzz,zz9.99')"}             

        end.
    end.
    else do:
        {method/svc/errors/inserr.i &ErrorNumber="16760"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="INFORMATION":U
                                    &ErrorParameters="''"} 
         return "NOK"  .                                
    end.




    return "OK".
    
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE nextSeqItRequisicao DBOProgram 
PROCEDURE nextSeqItRequisicao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:
------------------------------------------------------------------------------*/

    def input  param prRequisicao     as rowid no-undo.
    def output param pi-sequencia     as int   no-undo.
    def output param pi-nr-requisicao LIKE requisicao.nr-requisicao   no-undo.
    def output param pc-centro-custo  as char  no-undo.

    find requisicao where 
         rowid(requisicao) = prRequisicao 
         no-lock no-error.
    
    if  avail requisicao then do:
    
        find usuar-mater where 
             usuar-mater.cod-usuario = requisicao.nome-abrev 
             no-lock no-error.           
        if avail usuar-mater then
           assign pc-centro-custo = usuar-mater.sc-codigo.
    
        find last it-requisicao where 
             it-requisicao.nr-requisicao = requisicao.nr-requisicao
             no-lock no-error.
        if  avail it-requisicao then
            assign pi-sequencia = it-requisicao.sequencia + 10.
        if  not avail it-requisicao then
            assign pi-sequencia = 10.
        assign pi-nr-requisicao  = requisicao.nr-requisicao.
    end.


        
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuery DBOProgram 
PROCEDURE openQuery :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */

    define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then
            RUN openQueryStatic (input "Main":U) .
        when 2 then
            RUN openQueryStatic (input "ByOrdem-Compra":U) .
        when 3 then
            RUN openQueryStatic (input "ByItemReq":U) .
        when 4 then
            RUN openQueryStatic (input "ByRequisicao":U) .
        when 5 then
            RUN openQueryStatic (input "ByFaixaRequisicao":U) .

    end case.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByFaixaRequisicao DBOProgram 
PROCEDURE openQueryByFaixaRequisicao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    open query {&QUERYNAME} for each {&TABLENAME} where
                                     it-requisicao.nr-requisicao >= i-requis-ini and
                                     it-requisicao.nr-requisicao <= i-requis-fin no-lock INDEXED-REPOSITION. 
    RETURN "OK":U.                   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByItemReq DBOProgram 
PROCEDURE openQueryByItemReq :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    open query {&QUERYNAME} for each {&TABLENAME} where
                                     {&TABLENAME}.nr-requisicao = i-nr-requisicao and
                                     {&TABLENAME}.sequencia     = i-seq           no-lock
                                     INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByOrdem-Compra DBOProgram 
PROCEDURE openQueryByOrdem-Compra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    open query {&QUERYNAME} for each {&TABLENAME} where
                                      it-requisicao.numero-ordem = inum-ordem no-lock INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByRequisicao DBOProgram 
PROCEDURE openQueryByRequisicao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    open query {&QUERYNAME} for each {&TABLENAME} where
                                     {&TABLENAME}.nr-requisicao = i-nr-requisicao
                                     NO-LOCK INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH it-requisicao NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaDescricaoItem DBOProgram 
PROCEDURE retornaDescricaoItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    define input  parameter pc-it-codigo      as char  no-undo.
    define input  parameter prRowidRequisicao as rowid no-undo.
    define output parameter pc-descricao      as char  no-undo.

    find item where item.it-codigo = pc-it-codigo no-lock no-error.
    if avail item then do:
        find item-mat where item-mat.it-codigo = item.it-codigo no-lock no-error. 
        if avail item-mat and item-mat.log-1 = yes /*item Genï¿½rico*/ and item.tipo-contr = 4 /* dï¿½bito direto */ then do:
            /* busca descriï¿½ï¿½o da ordem-compra */
            find it-requisicao where rowid(it-requisicao) = prRowidRequisicao no-lock no-error.
            if avail it-requisicao then do:
               assign pc-descricao = substring(it-requisicao.narrativa,1,60).
            end.
            else do:
               assign pc-descricao = item.desc-item.
            end.   
        end.
        else do:
          assign pc-descricao = item.desc-item.
        end.  
    end.
    return "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setconstraint2 DBOProgram 
PROCEDURE setconstraint2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 /* ------------------------ PROXIES BO 1.1 ----------------------------- */
    def input parameter p-r-chave as rowid no-undo.
   
    RUN setconstraintOfOrdemCompra (input p-r-chave).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setconstraint3 DBOProgram 
PROCEDURE setconstraint3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    def input parameter p-rowid-requisicao as rowid no-undo.

    RUN setconstraintOfRequisicao (input p-rowid-requisicao).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setconstraint4 DBOProgram 
PROCEDURE setconstraint4 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 /* ------------------------ PROXIES BO 1.1 ----------------------------- */

    def input parameter p-nr-requisicao LIKE requisicao.nr-requisicao no-undo.
    
    RUN setconstraintByScCodigo (input p-nr-requisicao).    
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setconstraint5 DBOProgram 
PROCEDURE setconstraint5 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 /* ------------------------ PROXIES BO 1.1 ----------------------------- */

def input param  p-requis-ini LIKE requisicao.nr-requisicao no-undo.
def input param  p-requis-fin LIKE requisicao.nr-requisicao no-undo.

    RUN setconstraintNrRequisicao(input p-requis-ini, 
                                  input p-requis-fin).           
           
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setconstraint6 DBOProgram 
PROCEDURE setconstraint6 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    define input  parameter p-rowid-requisicao as rowid no-undo.
    define output parameter p-rowid-itrequis   as rowid no-undo.

    run setconstraintOfRequisicao-1 (input p-rowid-requisicao,
                                     output p-rowid-itrequis ).

END PROCEDURE.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setconstraintByScCodigo DBOProgram 
PROCEDURE setconstraintByScCodigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input paramete p-nr-requisicao LIKE requisicao.nr-requisicao no-undo.
    
    assign i-nr-requisicao = p-nr-requisicao.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setconstraintNrRequisicao DBOProgram 
PROCEDURE setconstraintNrRequisicao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter p-requis-ini LIKE requisicao.nr-requisicao   no-undo.
def input parameter p-requis-fin LIKE requisicao.nr-requisicao   no-undo.

assign i-requis-ini    = p-requis-ini
       i-requis-fin    = p-requis-fin.     

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setconstraintRequisicao DBOProgram 
PROCEDURE setConstraintRequisicao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter p-requisicao LIKE requisicao.nr-requisicao   no-undo.
def input parameter p-sequencia  LIKE requisicao.nr-requisicao   no-undo.

assign i-nr-requisicao    = p-requisicao
       i-seq              = p-sequencia.  

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setconstraintOfOrdemCompra DBOProgram 
PROCEDURE setconstraintOfOrdemCompra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter p-rowid-ordem-compra as rowid no-undo.

    find ordem-compra where rowid(ordem-compra) = p-rowid-ordem-compra no-lock no-error. 
    
    assign i-nr-requisicao = ordem-compra.nr-requisicao
           i-seq           = ordem-compra.sequencia.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setconstraintOfRequisicao DBOProgram 
PROCEDURE setconstraintOfRequisicao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter p-rowid-requisicao as rowid no-undo.

    find requisicao where rowid(requisicao) = p-rowid-requisicao no-lock no-error.
     
    assign i-nr-requisicao = requisicao.nr-requisicao.

END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setconstraintOfRequisicao-1 DBOProgram 
PROCEDURE setconstraintOfRequisicao-1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define input  parameter p-rowid-requisicao as rowid no-undo.
define output parameter p-rowid-itrequis   as rowid no-undo.

    find requisicao where rowid(requisicao) = p-rowid-requisicao no-lock no-error.
    if avail requisicao then do:
       find first it-requisicao
            where it-requisicao.nr-requisicao = requisicao.nr-requisicao no-lock no-error.

       if avail it-requisicao then
           assign p-rowid-itrequis = rowid(it-requisicao).
    end.


end procedure.

 /* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByRequisicao DBOProgram 
PROCEDURE setConstraintByRequisicao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter p-nr-requisicao like requisicao.nr-requisicao no-undo.

    assign i-nr-requisicao = p-nr-requisicao.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addItemRequisTarget DBOProgram 
PROCEDURE addItemRequisTarget :
/*------------------------------------------------------------------------------
  Purpose: Adicionar item na temp-table tt-it-requisicao-dest
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER c-it-codigo           LIKE it-requisicao.it-codigo     NO-UNDO.
DEFINE INPUT PARAMETER i-nr-requisicao       LIKE it-requisicao.nr-requisicao NO-UNDO.
DEFINE INPUT PARAMETER c-cod-estabel         LIKE requisicao.cod-estabel      NO-UNDO.
DEFINE INPUT PARAMETER i-nr-requisicao-dest  LIKE it-requisicao.nr-requisicao NO-UNDO.
DEFINE INPUT PARAMETER i-incremento-seq      LIKE it-requisicao.sequencia     NO-UNDO.
DEFINE INPUT PARAMETER da-nova-entrega       LIKE it-requisicao.dt-entrega    NO-UNDO.
DEFINE INPUT PARAMETER i-sequencia           LIKE it-requisicao.sequencia     NO-UNDO.
DEFINE INPUT PARAMETER l-adiciona-tempo        AS LOGICAL                     NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-it-requisicao-dest.

DEFINE VARIABLE i-new-seq AS INTEGER    NO-UNDO.
DEFINE VARIABLE i-seq-ant AS INTEGER    NO-UNDO.

find last it-requisicao
    where it-requisicao.nr-requisicao = i-nr-requisicao-dest
    no-lock no-error.
if avail it-requisicao then do:
    if (it-requisicao.sequencia + i-incremento-seq) > 999 then do:
        assign i-seq-ant = 1.
        repeat:
            if not can-find(it-requisicao
                        where it-requisicao.nr-requisicao = i-nr-requisicao-dest
                          and it-requisicao.sequencia     = i-seq-ant) then do:
                if not can-find(tt-it-requisicao-dest
                        where tt-it-requisicao-dest.sequencia = i-seq-ant) then do:
                    leave.
                end.
            end.
            assign i-seq-ant = i-seq-ant + 1.
        end.
        assign i-new-seq = i-seq-ant.
    end.
    else do:
        find last tt-it-requisicao-dest no-error.
        if avail tt-it-requisicao-dest then do:
            if (tt-it-requisicao-dest.sequencia + i-incremento-seq) > 999 then do:
                assign i-seq-ant = 1.
                repeat:
                    if not can-find(it-requisicao
                                where it-requisicao.nr-requisicao = i-nr-requisicao-dest
                                  and it-requisicao.sequencia     = i-seq-ant) then do:
                        if not can-find(tt-it-requisicao-dest
                                where tt-it-requisicao-dest.sequencia = i-seq-ant) then do:
                            leave.
                        end.
                    end.
                    assign i-seq-ant = i-seq-ant + 1.
                end.
                assign i-new-seq = i-seq-ant.
            end.
            else do:
                assign i-new-seq = tt-it-requisicao-dest.sequencia + i-incremento-seq.
            end.
        end.
        else do:
            assign i-new-seq = it-requisicao.sequencia + i-incremento-seq.
        end.
    end.
end.
else do:
    find last tt-it-requisicao-dest no-error.
    if avail tt-it-requisicao-dest then do:
        if (tt-it-requisicao-dest.sequencia + i-incremento-seq) > 999 then do:
            assign i-seq-ant = 1.
            repeat:
                if not can-find(tt-it-requisicao-dest
                        where tt-it-requisicao-dest.sequencia = i-seq-ant) then do:
                    leave.
                end.
                assign i-seq-ant = i-seq-ant + 1.
            end.
            assign i-new-seq = i-seq-ant.
        end.
        else do:
            assign i-new-seq = tt-it-requisicao-dest.sequencia + i-incremento-seq.
        end.
    end.
    else do:
        assign i-new-seq = i-incremento-seq.
    end.
end.

if i-new-seq > 999 then
    return "NOK":U.

FIND FIRST item-uni-estab
     WHERE item-uni-estab.it-codigo   = c-it-codigo   AND
           item-uni-estab.cod-estabel = c-cod-estabel NO-LOCK NO-ERROR.

IF  l-adiciona-tempo THEN DO:
    IF  AVAIL item-uni-estab THEN
        ASSIGN da-nova-entrega = da-nova-entrega
                               + item-uni-estab.res-int-comp
                               + item-uni-estab.res-for-comp.
END.

find it-requisicao 
    where it-requisicao.it-codigo     = c-it-codigo 
    and   it-requisicao.nr-requisicao = i-nr-requisicao
    and   it-requisicao.sequencia     = i-sequencia
    no-lock no-error.

find requisicao 
	where requisicao.nr-requisicao = i-nr-requisicao-dest no-lock no-error.

if avail it-requisicao then do:
    create tt-it-requisicao-dest.
    buffer-copy it-requisicao except nr-requisicao sequencia qt-a-atender situacao to tt-it-requisicao-dest.
    assign tt-it-requisicao-dest.r-rowid              = rowid(it-requisicao)
           tt-it-requisicao-dest.nr-requis-orig       = it-requisicao.nr-requisicao
           tt-it-requisicao-dest.seq-requis-orig      = it-requisicao.sequencia
           tt-it-requisicao-dest.nr-requisicao        = i-nr-requisicao-dest
           tt-it-requisicao-dest.sequencia            = i-new-seq
           tt-it-requisicao-dest.dt-entrega           = da-nova-entrega
           tt-it-requisicao-dest.seq-planej           = 0
           tt-it-requisicao-dest.qt-a-atender         = tt-it-requisicao-dest.qt-requisitada
           tt-it-requisicao-dest.situacao             = 1
           tt-it-requisicao-dest.int-1                = 0
		   tt-it-requisicao-dest.tp-requis            = requisicao.tp-requis.
	
	
    FOR FIRST  requisicao
        FIELDS (nome-abrev)
        WHERE  requisicao.nr-requisicao = it-requisicao.nr-requisicao NO-LOCK:
        FOR FIRST  usuar-mater
            FIELDS (char-1)
            WHERE  usuar-mater.cod-usuario = requisicao.nome-abrev NO-LOCK:

            /* Usuario possui Utilizacao de Material? */
            IF  SUBSTRING(usuar-mater.char-1,1,1) = "y":U THEN DO:
                IF  SUBSTRING(tt-it-requisicao-dest.char-2,01,12) = "":U THEN DO:
                    IF  AVAIL item-uni-estab THEN DO:
                        FOR FIRST  utiliz-natu-despes
                            FIELDS (cod-utiliz)
                            WHERE  utiliz-natu-despes.cod-nat-despesa = item-uni-estab.nat-despesa NO-LOCK:
                            ASSIGN OVERLAY(tt-it-requisicao-dest.char-2,01,12) = STRING(utiliz-natu-despes.cod-utiliz).
                        END.
                    END.
                END.
            END.
            ELSE
                ASSIGN OVERLAY(tt-it-requisicao-dest.char-2,01,12) = "":U.
        END.
    END.
end.
else
    return "NOK":U.


return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE delItemRequisTarget DBOProgram 
PROCEDURE delItemRequisTarget :
/*------------------------------------------------------------------------------
  Purpose: Adicionar item na temp-table tt-it-requisicao-dest
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER c-it-codigo           LIKE it-requisicao.it-codigo     NO-UNDO.
DEFINE INPUT PARAMETER i-nr-requisicao       LIKE it-requisicao.nr-requisicao NO-UNDO.
DEFINE INPUT PARAMETER i-sequencia           LIKE it-requisicao.sequencia     NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR RowObject.

find it-requisicao 
    where it-requisicao.it-codigo     = c-it-codigo 
    and   it-requisicao.nr-requisicao = i-nr-requisicao
    and   it-requisicao.sequencia     = i-sequencia
    no-lock no-error.

if avail it-requisicao then do:
    if not can-find(RowObject 
                    where RowObject.it-codigo     = it-requisicao.it-codigo
                      and RowObject.nr-requisicao = it-requisicao.nr-requisicao
                      and RowObject.sequencia     = it-requisicao.sequencia) then do:
        create RowObject.
        buffer-copy it-requisicao to RowObject.
        assign RowObject.r-rowid         = rowid(it-requisicao).
    end.
end.
else
    return "NOK":U.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateCreateUpdateItRequisicao DBOProgram 
PROCEDURE validateCreateUpdateItRequisicao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:
------------------------------------------------------------------------------*/
    def input param pcParam               as char no-undo.
    def input param pcCodUtiliz           as char no-undo.
    def input param pcbPrioridade         as int  no-undo.    
    def input param plUrgente             as log  no-undo.
    def input param plHomologa            as log  no-undo.
    def input param plAfetaQlde           as log  no-undo.
    def input param plClassif             as log  no-undo.
    def input param piNatDesp             as int  no-undo.
    def input param plScCodigo            as log  no-undo.

    assign l-ScCodigo    = plScCodigo.
           

    def var r-chave as rowid no-undo.

    assign c-lista-prioridade = "Muito Alta,Alta,Mï¿½dia,Baixa".

    find first rowobject no-error.
    if not avail rowObject then do:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-item-da-requisicao AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Item_da_Requisiï¿½ï¿½o" *}
        ASSIGN c-lbl-liter-item-da-requisicao = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                             &ErrorNumber="16283"
                             &ErrorType="EMS"
                             &ErrorSubType="ERROR"
                             &ErrorParameters="c-lbl-liter-item-da-requisicao"}
        RETURN "NOK":U.
    end.

    assign l-classif  = plClassif
           i-nat-desp = piNatDesp 
           c-param    = pcParam
           c-cod-utiliz = pcCodUtiliz .

    find first param-global no-lock no-error.
    find first param-estoq  no-lock no-error.
    find first param-compra no-lock no-error.

    assign c-cod-utiliz-aux = pcCodUtiliz.

    find first requisicao where
         requisicao.nr-requisicao = rowObject.nr-requisicao
         exclusive-LOCK no-error.

         
    if avail requisicao then 
    assign r-requisicao = rowid(requisicao).
    find usuar-mater where
         usuar-mater.cod-usuario = requisicao.nome-abrev
         no-lock no-error.


    if pcParam = "add" then do:     
       find it-requisicao where 
             it-requisicao.nr-requisicao = RowObject.nr-requisicao and
             it-requisicao.sequencia     = RowObject.sequencia
             no-lock no-error.
        if  avail it-requisicao then do:
              {method/svc/errors/inserr.i
                               &ErrorNumber="5576"
                               &ErrorType="EMS"
                               &ErrorSubType="ERROR"}
        end.
    end.
    
    find first item where
         item.it-codigo = rowObject.it-codigo
         no-lock no-error.

    if avail item
    and (  (item.tipo-contr <> 4)
        or (item.tipo-contr  = 4 and requisicao.tp-requis <> 2)) then
        assign RowObject.preco-unit = 0.
    
    if cPrograma <> "CD0738":U then do:
        run validateFieldItemItRequisicao.
    end.

    if c-param <> "Add":U and (avail it-requisicao and it-requisicao.num-ord-inv = 0) then       
       run validateFieldCodUtilizItRequisicao.
    
    run validateFieldNumOrdInvItRequisicao.

    /*--------- Validaï¿½ï¿½es do item requisitado/solicitado --------------*/
    /******************** {cdp/cd1406a.i3} COM SHOW *********************/
    run validateItemRequisicao.
    /********************************************************************/
   
    if avail requisicao and requisicao.tp-requis <> 1 then do:
        find item-uni-estab where 
             item-uni-estab.it-codigo   = RowObject.it-codigo
         and item-uni-estab.cod-estabel = requisicao.cod-estabel
             no-lock no-error.
        if avail item-uni-estab then DO:
            &if '{&bf_mat_versao_ems}' >= '2.071' &then
                ASSIGN RowObject.cod-comprado = item-uni-estab.cod-comprado.
            &ELSE
                assign substring(RowObject.char-1,2,12) = item-uni-estab.cod-comprado.
            &endif
        END.
        else do:
            find first item where
                 item.it-codigo = RowObject.it-codigo
                 no-lock no-error.
            if avail item then DO:
                &if '{&bf_mat_versao_ems}' >= '2.071' &then
                    ASSIGN RowObject.cod-comprado = item.cod-comprado.
                &ELSE
                    assign substring(RowObject.char-1,2,12) = item.cod-comprado.
                &endif
            END.
        end.     
    end.

    /*****  Antiga chamada da cd1406a.i2 *****/
    /************* {cdp/cd1406a.i5} Atribui preï¿½o caso nï¿½o for Dï¿½bito Direto COM SHOW *********/
    run atribuiPrecoDebitoNaoDireto.
    /******************************************************************************************/
    if  avail item 
        and   item.tipo-contr      = 4 
        and   requisicao.tp-requis = 2 and /* Reatribui valor da tela - item dï¿½bito direto e solicitaï¿½ï¿½o */
        &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
             (  NOT usuar-mater.log-suger-preco-item-db-diret OR  c-param <> "Add":U   OR
               (usuar-mater.log-suger-preco-item-db-diret     AND RowObject.preco-unit <> 0) )
        &ElSE
             (  SUBSTR(usuar-mater.char-1,12,1) =  "N"  OR  c-param <> "Add":U   OR
               (SUBSTR(usuar-mater.char-1,12,1) <> "N"  AND RowObject.preco-unit <> 0) ) 
        &ENDIF then
        assign de-preco-u = RowObject.preco-unit.
        
    if  avail requisicao then do:
        find usuar-mater
            where usuar-mater.cod-usuario = requisicao.nome-abrev no-lock no-error.
        if  requisicao.tp-requis = 1 then do: /* Requisicao */
            if  avail usuar-mater then
                assign de-limite-req = usuar-mater.lim-requis
                       i-moeda-req   = usuar-mater.mo-codigo
                       de-total-req  = 0.                  
            run  cdp/cd0812.p (input  i-moeda-req,
                               input  0,
                               input  de-limite-req,
                               input  today,
                               output de-limite-req).
            assign RowObject.val-item = RowObject.qt-a-atender * de-preco-u.
        end.
        else do: /* solicitacao */
            if  avail usuar-mater then
                assign de-solic      = usuar-mater.lim-solic
                       i-moeda-solic = usuar-mater.mo-codigo
                       de-tot-solic  = 0.
            if  i-moeda-solic <> 0 then
                run cdp/cd0812.p (input  i-moeda-solic,
                                  input  0,
                                  input  de-solic,
                                  input  today,
                                  output de-solic).
            assign RowObject.val-item = RowObject.qt-a-atender * de-preco-u.
        end.
    end.

/*****  Fim antiga chamada da cd1406a.i2 *****/

    

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN do:
        RETURN "NOK":U.
    end.
    else do:
        if pcParam = "add" then do :
            run createRecord.
            assign r-chave =  rowid({&TableName}).
        end.
        else do:
            find current {&TableName} exclusive-lock no-error.
            assign r-chave = rowid({&TableName}).
            run updateRecord.
        end.
    end.
    find first it-requisicao where 
         rowid(it-requisicao) = r-chave EXCLUSIVE-LOCK no-error.

    assign r-item-re = rowid(it-requisicao).  
    find first item where
         item.it-codigo = it-requisicao.it-codigo
         no-lock no-error.
    
    /**  Melhorias
    **/
    &if defined(bf_mat_aprova_eletronica) &then
        case pcbPrioridade :
            when 1 then assign it-requisicao.prioridade-aprov = 999.
            when 2 then assign it-requisicao.prioridade-aprov = 750.
            when 3 then assign it-requisicao.prioridade-aprov = 450.
            when 4 then assign it-requisicao.prioridade-aprov = 150.
        end case.
    &endif
    assign it-requisicao.num-ord-inv   = RowObject.num-ord-inv.
    if  pcParam = "mod" then
        assign it-requisicao.qt-requisitada = it-requisicao.qt-a-atender
                                       + it-requisicao.qt-atendida
                                       - it-requisicao.qt-devolvida.
    else
        assign it-requisicao.qt-requisitada            = RowObject.qt-a-atender
               it-requisicao.qt-atendida          = 0
               it-requisicao.qt-devolvida         = 0
               it-requisicao.qt-a-devolver        = 0
               OVERLAY(it-requisicao.char-1,15,1) = "N":U.
    
     find estabelec where 
          estabelec.cod-estabel = requisicao.cod-estabel
          no-lock no-error.
     if param-global.modulo-in and 
        RowObject.num-ord-inv <> 0
     then  assign  it-requisicao.ep-codigo   = if avail estabelec 
                                               then estabelec.ep-codigo
                                               else param-global.empresa-prin.
    if avail item then
        assign it-requisicao.nome-abrev    = requisicao.nome-abrev
               it-requisicao.cod-estabel   = requisicao.cod-estabel
               it-requisicao.log-1         = plUrgente
               it-requisicao.log-2         = plHomologa.
               
    if pcParam = "add" then do:
        if avail item then
            assign it-requisicao.cod-depos = item.deposito-pad.
        
        if can-find(first funcao where
                    funcao.cd-funcao = "spp-whs-item-site" and
                    funcao.ativo     = yes) then do:
    
             find item-uni-estab where 
                  item-uni-estab.it-codigo   = it-requisicao.it-codigo and 
                  item-uni-estab.cod-estabel = requisicao.cod-estabel no-lock no-error.
             if avail item-uni-estab then
                  assign it-requisicao.cod-depos = item-uni-estab.deposito-pad.  
        end.
    end.
    if it-requisicao.num-ord-inv = 0 then
       assign substring(it-requisicao.char-2,1,12) = c-cod-utiliz-aux.
               
        assign substr(it-requisicao.char-1,1,1,"character") = if plAfetaQlde = yes then "Y" else "N".

     /*****  Antiga chamada da cd1406a.i2 - o val-item passou a ser calculado antes da gravaï¿½ï¿½o para ser validado *****/

    if avail item and item.tipo-con-est = 2 then
        assign it-requisicao.qt-a-atender = 1.
        
    if  it-requisicao.preco-unit = 0 then
        assign it-requisicao.preco-unit = it-requisicao.val-item / it-requisicao.qt-requisitada.
        
    assign de-sal-ant = it-requisicao.qt-a-atender.
    
    if  it-requisicao.qt-a-atender = 0 then do:
        assign it-requisicao.situacao = 2.
        find first b-it-requisicao
            where  b-it-requisicao.nr-requisicao = requisicao.nr-requisicao
            and   (b-it-requisicao.situacao = 1 or b-it-requisicao.situacao = 3)
            no-error.
        if  not avail b-it-requisicao and requisicao.situacao = 1 then do:
            assign requisicao.situacao = 2.
            find b-it-requisicao
                where rowid(it-requisicao) = r-item-re no-lock no-error.
        end.
        else
            find b-it-requisicao
                where rowid(it-requisicao) = r-item-re no-lock no-error.
    end.

    if pcParam = "add" then 
        run ccp/ccapi642.p (1, rowid(it-requisicao), 1).
    else
        run ccp/ccapi642.p (1, rowid(it-requisicao), 2).
    
    if  lAprovacaoItem
    and i-tipo-doc > 0 then do:
        if  (i-tipo-doc = 1 and substring(param-compra.char-2, 1, 3) = "nao")
        or  (i-tipo-doc = 2 and substring(param-compra.char-2, 4, 3) = "nao")
        or  i-tipo-doc > 2 THEN 
            run cdp/cdapi171.p (i-tipo-doc, i-tipo-trans, rowid(it-requisicao)).
    END.


    assign requisicao.estado = 1
           requisicao.nome-aprov = requisicao.nome-abrev.
    
    RUN returnAprovTotal ( INPUT ROWID(requisicao),
                           OUTPUT lAprovacaoTotal).
    IF lAprovacaoTotal THEN DO:
        /**  Melhorias
        **/
        &if defined(bf_mat_aprova_eletronica) &then
            assign it-requisicao.estado = 2
                   it-requisicao.nome-aprov = "":U.
        &endif
    END.
    ELSE DO:
        /**  Melhorias
        **/
        &if defined(bf_mat_aprova_eletronica) &then
            assign it-requisicao.estado = 1
                   it-requisicao.nome-aprov = requisicao.nome-abrev.
        &endif
        
        if  i-tipo-doc > 0 
        and lAprovacaoItem then do:
            assign l-pendente = no.
            run cdp/cdapi172.p (i-tipo-doc,rowid(it-requisicao), output l-pendente).
            if  l-pendente then do:
                assign requisicao.estado = 2
                       requisicao.nome-aprov = "":U.
                assign it-requisicao.estado = 2
                       it-requisicao.nome-aprov = "":U.
            end.                   
            else do:
                if  can-find (first b-it-requisicao where 
                                    b-it-requisicao.nr-requisicao = it-requisicao.nr-requisicao and
                                    b-it-requisicao.estado = 2 ) then
                    assign requisicao.estado = 2 
                           requisicao.nome-aprov = "":U.
            end.                   
        end.
    END.
/*************************
    if  pcParam = "add"
    and requisicao.tp-requis <> 1  then do: /* Requisiï¿½ï¿½o */
       /**** Unidade de Negï¿½cio ****/
       find first param-estoq no-lock no-error.
       if  substring(param-estoq.char-2,2,1) = "@" and
           (can-find(funcao where funcao.cd-funcao = "adm-apb-ems-5.00"
                              and funcao.ativo = yes
                              and funcao.log-1 = yes) 
           or  can-find(funcao where funcao.cd-funcao = "adm-cfl-ems-5.00"
                              and funcao.ativo = yes  
                              and funcao.log-1 = yes)) then do:                      
               run pi-conecta-ems5 ( yes, output l-retorno ).
               ASSIGN v-ROW-PARENT = ROWID (it-requisicao)
                      {&WINDOW-NAME}:sensitive = false.
               run cdp/cd9760.p ( input 2, /* tipo requisiï¿½ï¿½o */
                                  input it-requisicao.it-codigo,
                                  input rowid(it-requisicao) ).    
               run cdp/cd9766.w (input v-row-parent).
               assign {&WINDOW-NAME}:sensitive = true.
               run pi-conecta-ems5 ( no, output l-retorno ).
        end.
    end.
*******************/  

/*    /********* INVESTIMENTOS ********/
 *     if connected("mginv")     and
 *        param-global.modulo-in and 
 *        RowObject.num-ord-inv <> 0 then do:   
 *        if pcParam = "add" then   
 *              run inp/in2101.p(input rowid(requisicao), input rowid(it-requisicao) , "Inclui").
 *        else if pcParam = "mod" then   
 *              run inp/in2101.p(input rowid(requisicao), input rowid(it-requisicao) , "Modifica").
 *     end.
 *     /********************************/*/
    
    if it-requisicao.num-ord-inv <> 0 and
       it-requisicao.num-ord-inv <> ? and
       requisicao.situacao = 3 and param-global.modulo-in = yes then do:
       assign requisicao.situacao = 1.           
    end.
    
    if  avail param-compra
    and param-compra.log-1
    and (  (i-tipo-doc = 1 and substring(param-compra.char-2, 1, 3) = "nao") 
        or (i-tipo-doc = 2 and substring(param-compra.char-2, 4, 3) = "nao")
        or i-tipo-doc > 2 )
    and lAprovacaoItem then do:
        run mensagemAprovacaoItemRequisicao.
    end.

    if avail param-compra and param-compra.log-1 
        and c-param <> "mod" and c-param <> "add" 
        and (  (i-tipo-doc = 1 and substring(param-compra.char-2, 1, 3) = "sim") 
        or (i-tipo-doc = 2 and substring(param-compra.char-2, 4, 3) = "sim")
        or i-tipo-doc > 2 )THEN DO:

        run mensagemAprovacaoItemRequisicao.

    end.
/********** run pi-msg-aprov. *********/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN 
        RETURN "NOK":U.

    return "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateCreateUpdateItRequisicao DBOProgram 
PROCEDURE validateCreateUpdateItRequisicao2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:
------------------------------------------------------------------------------*/
    def input param pcParam               as char no-undo.
    def input param pcCodUtiliz           as char no-undo.
    def input param pcbPrioridade         as int  no-undo.    
    def input param plUrgente             as log  no-undo.
    def input param plHomologa            as log  no-undo.
    def input param plAfetaQlde           as log  no-undo.
    def input param plClassif             as log  no-undo.
    def input param piNatDesp             as int  no-undo.
    def input param plScCodigo            as log  no-undo.

    assign l-ScCodigo    = plScCodigo.
           

    def var r-chave as rowid no-undo.

    assign c-lista-prioridade = "Muito Alta,Alta,Mï¿½dia,Baixa".

    find first rowobject no-error.
    if not avail rowObject then do:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-item-da-requisicao-2 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Item_da_Requisiï¿½ï¿½o" *}
        ASSIGN c-lbl-liter-item-da-requisicao-2 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                             &ErrorNumber="16283"
                             &ErrorType="EMS"
                             &ErrorSubType="ERROR"
                             &ErrorParameters="c-lbl-liter-item-da-requisicao-2"}
        RETURN "NOK":U.
    end.

    assign l-classif  = plClassif
           i-nat-desp = piNatDesp 
           c-param    = pcParam
           c-cod-utiliz = pcCodUtiliz .

    find first param-global no-lock no-error.
    find first param-estoq  no-lock no-error.
    find first param-compra no-lock no-error.

    assign c-cod-utiliz-aux = pcCodUtiliz.

    find first requisicao where
         requisicao.nr-requisicao = rowObject.nr-requisicao
         exclusive-LOCK no-error.

         
    if avail requisicao then 
    assign r-requisicao = rowid(requisicao).
    find usuar-mater where
         usuar-mater.cod-usuario = requisicao.nome-abrev
         no-lock no-error.


    if pcParam = "add" then do:     
       find it-requisicao where 
             it-requisicao.nr-requisicao = RowObject.nr-requisicao and
             it-requisicao.sequencia     = RowObject.sequencia
             no-lock no-error.
        if  avail it-requisicao then do:
              {method/svc/errors/inserr.i
                               &ErrorNumber="5576"
                               &ErrorType="EMS"
                               &ErrorSubType="ERROR"}
        end.
    end.
    
    find first item where
         item.it-codigo = rowObject.it-codigo
         no-lock no-error.

    if avail item
    and (  (item.tipo-contr <> 4)
        or (item.tipo-contr  = 4 and requisicao.tp-requis <> 2)) then
        assign RowObject.preco-unit = 0.
       
    if c-param <> "Add":U and (avail it-requisicao and it-requisicao.num-ord-inv = 0) then       
       run validateFieldCodUtilizItRequisicao.

    
    run validateFieldNumOrdInvItRequisicao.


    /*--------- Validaï¿½ï¿½es do item requisitado/solicitado --------------*/
    /******************** {cdp/cd1406a.i3} COM SHOW *********************/
    run validateItemRequisicao.
    /********************************************************************/
   
    if  avail requisicao and requisicao.tp-requis <> 1 then do:
        if param-compra.int-2 = 2 /*Por Comprador*/ then do:
            find item-uni-estab where 
                 item-uni-estab.it-codigo   = RowObject.it-codigo
             and item-uni-estab.cod-estabel = requisicao.cod-estabel
                 no-lock no-error.
            if avail item-uni-estab then DO:
                &if '{&bf_mat_versao_ems}' >= '2.071' &then
                    ASSIGN RowObject.cod-comprado = item-uni-estab.cod-comprado.
                &ELSE
                    assign substring(RowObject.char-1,2,12) = item-uni-estab.cod-comprado.
                &endif
            END.
            else do:
                find first item where
                     item.it-codigo = RowObject.it-codigo
                     no-lock no-error.
                if avail item then DO:
                    &if '{&bf_mat_versao_ems}' >= '2.071' &then
                        ASSIGN RowObject.cod-comprado = item.cod-comprado.
                    &ELSE
                        assign substring(RowObject.char-1,2,12) = item.cod-comprado.
                    &endif
                END.
            end.
        end.
        else do: /* Por Grupo de Compras */
            find first item-uni-estab 
                 where item-uni-estab.it-codigo   = RowObject.it-codigo
                   and item-uni-estab.cod-estabel = requisicao.cod-estabel no-lock no-error.
            if avail item-uni-estab then
                assign RowObject.cod-grp-compra = item-uni-estab.cod-grp-compra.
            else do:
                find first item 
                     where item.it-codigo = RowObject.it-codigo no-lock no-error.
                if avail item then do:
                     &if "{&mgind_dbtype}" = "progress" &then
                        assign RowObject.cod-grp-compra = substring(item.char-2,188,12).
                    &else
                        assign RowObject.cod-grp-compra = substring(item.char-2,88,12).
                    &endif
                end.
            end.
        end.
    end.

    /*****  Antiga chamada da cd1406a.i2 *****/
    /************* {cdp/cd1406a.i5} Atribui preï¿½o caso nï¿½o for Dï¿½bito Direto COM SHOW *********/
    run atribuiPrecoDebitoNaoDireto.
    /******************************************************************************************/
    if  avail item 
        and   item.tipo-contr      = 4 
        and   requisicao.tp-requis = 2 and /* Reatribui valor da tela - item dï¿½bito direto e solicitaï¿½ï¿½o */
        &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
             (  NOT usuar-mater.log-suger-preco-item-db-diret OR  c-param <> "Add":U   OR
               (usuar-mater.log-suger-preco-item-db-diret     AND RowObject.preco-unit <> 0) )
        &ElSE
             (  SUBSTR(usuar-mater.char-1,12,1) =  "N"  OR  c-param <> "Add":U   OR
               (SUBSTR(usuar-mater.char-1,12,1) <> "N"  AND RowObject.preco-unit <> 0) ) 
        &ENDIF then
        assign de-preco-u = RowObject.preco-unit.
        
    if  avail requisicao then do:
        find usuar-mater
            where usuar-mater.cod-usuario = requisicao.nome-abrev no-lock no-error.
        if  requisicao.tp-requis = 1 then do: /* Requisicao */
            if  avail usuar-mater then
                assign de-limite-req = usuar-mater.lim-requis
                       i-moeda-req   = usuar-mater.mo-codigo
                       de-total-req  = 0.                  
            run  cdp/cd0812.p (input  i-moeda-req,
                               input  0,
                               input  de-limite-req,
                               input  today,
                               output de-limite-req).
            assign RowObject.val-item = RowObject.qt-a-atender * de-preco-u.
        end.
        else do: /* solicitacao */
            if  avail usuar-mater then
                assign de-solic      = usuar-mater.lim-solic
                       i-moeda-solic = usuar-mater.mo-codigo
                       de-tot-solic  = 0.
            if  i-moeda-solic <> 0 then
                run cdp/cd0812.p (input  i-moeda-solic,
                                  input  0,
                                  input  de-solic,
                                  input  today,
                                  output de-solic).
            assign RowObject.val-item = RowObject.qt-a-atender * de-preco-u.
        end.
    end.

/*****  Fim antiga chamada da cd1406a.i2 *****/

    

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN do:
        RETURN "NOK":U.
    end.
    else do:
        if pcParam = "add" then do :
            run createRecord.
            assign r-chave =  rowid({&TableName}).
        end.
        else do:
            find current {&TableName} exclusive-lock no-error.
            assign r-chave = rowid({&TableName}).
            run updateRecord.
        end.
    end.

    find first it-requisicao exclusive-lock 
         where rowid(it-requisicao) = r-chave no-error.
    if avail it-requisicao then do:

        assign r-item-re = rowid(it-requisicao).
        find first item no-lock 
             where item.it-codigo = it-requisicao.it-codigo no-error.

        /**  Melhorias **/
        &if defined(bf_mat_aprova_eletronica) &then
            case pcbPrioridade:
                when 1 then assign it-requisicao.prioridade-aprov = 999.
                when 2 then assign it-requisicao.prioridade-aprov = 750.
                when 3 then assign it-requisicao.prioridade-aprov = 450.
                when 4 then assign it-requisicao.prioridade-aprov = 150.
            end case.
        &endif

        assign it-requisicao.num-ord-inv   = RowObject.num-ord-inv.
        if  pcParam = "mod" then
            assign it-requisicao.qt-requisitada = (it-requisicao.qt-a-atender + it-requisicao.qt-atendida) - it-requisicao.qt-devolvida.
        else
            assign it-requisicao.qt-requisitada     = RowObject.qt-a-atender
                   it-requisicao.qt-atendida   = 0
                   it-requisicao.qt-devolvida  = 0
                   it-requisicao.qt-a-devolver = 0.
        
        find first estabelec no-lock 
             where estabelec.cod-estabel = requisicao.cod-estabel no-error.
        if param-global.modulo-in and RowObject.num-ord-inv <> 0 then  
            assign  it-requisicao.ep-codigo   = if avail estabelec then estabelec.ep-codigo else param-global.empresa-prin.

        if avail item then
            assign it-requisicao.nome-abrev    = requisicao.nome-abrev
                   it-requisicao.cod-estabel   = requisicao.cod-estabel
                   it-requisicao.log-1         = plUrgente
                   it-requisicao.log-2         = plHomologa.
        
        if pcParam = "add" then do:
            if avail item then
                assign it-requisicao.cod-depos = item.deposito-pad.

            if can-find(first funcao where
                        funcao.cd-funcao = "spp-whs-item-site" and
                        funcao.ativo     = yes) then do:

                 find item-uni-estab where 
                      item-uni-estab.it-codigo   = it-requisicao.it-codigo and 
                      item-uni-estab.cod-estabel = requisicao.cod-estabel no-lock no-error.
                 if avail item-uni-estab then
                      assign it-requisicao.cod-depos = item-uni-estab.deposito-pad.  
            end.
        end.

        if it-requisicao.num-ord-inv = 0 then
           assign substring(it-requisicao.char-2,1,12) = c-cod-utiliz-aux.

            assign substr(it-requisicao.char-1,1,1,"character") = if plAfetaQlde = yes then "Y" else "N".

        /*****  Antiga chamada da cd1406a.i2 - o val-item passou a ser calculado antes da gravaï¿½ï¿½o para ser validado *****/
        if avail item and item.tipo-con-est = 2 then
            assign it-requisicao.qt-a-atender = 1.

        if  it-requisicao.preco-unit = 0 then
            assign it-requisicao.preco-unit = it-requisicao.val-item / it-requisicao.qt-requisitada.

        assign de-sal-ant = it-requisicao.qt-a-atender.

        if  it-requisicao.qt-a-atender = 0 then do:
            assign it-requisicao.situacao = 2.
            find first b-it-requisicao
                where  b-it-requisicao.nr-requisicao = requisicao.nr-requisicao
                and   (b-it-requisicao.situacao = 1 or b-it-requisicao.situacao = 3)
                no-error.
            if  not avail b-it-requisicao and requisicao.situacao = 1 then do:
                assign requisicao.situacao = 2.
                find b-it-requisicao
                    where rowid(it-requisicao) = r-item-re no-lock no-error.
            end.
            else
                find b-it-requisicao
                    where rowid(it-requisicao) = r-item-re no-lock no-error.
        end.

        if pcParam = "add" then 
            run ccp/ccapi642.p (1, rowid(it-requisicao), 1).
        else
            run ccp/ccapi642.p (1, rowid(it-requisicao), 2).

        if  lAprovacaoItem
        and i-tipo-doc > 0 then do:
            if  (i-tipo-doc = 1 and substring(param-compra.char-2, 1, 3) = "nao")
            or  (i-tipo-doc = 2 and substring(param-compra.char-2, 4, 3) = "nao")
            or  i-tipo-doc > 2 THEN 
                run cdp/cdapi171.p (i-tipo-doc, i-tipo-trans, rowid(it-requisicao)).
        END.

        assign requisicao.estado = 1
               requisicao.nome-aprov = requisicao.nome-abrev.

        /**  Melhorias
        **/
        &if defined(bf_mat_aprova_eletronica) &then
            assign it-requisicao.estado = 1
                   it-requisicao.nome-aprov = requisicao.nome-abrev.
        &endif

        if  i-tipo-doc > 0 
        and lAprovacaoItem then do:
            assign l-pendente = no.
            run cdp/cdapi172.p (i-tipo-doc,rowid(it-requisicao), output l-pendente).
            if  l-pendente then do:
                assign requisicao.estado = 2
                       requisicao.nome-aprov = "":U.
                assign it-requisicao.estado = 2
                       it-requisicao.nome-aprov = "":U.
            end.                   
            else do:
                if  can-find (first b-it-requisicao where 
                                    b-it-requisicao.nr-requisicao = it-requisicao.nr-requisicao and
                                    b-it-requisicao.estado = 2 ) then
                    assign requisicao.estado = 2 
                           requisicao.nome-aprov = "":U.
            end.                   
        end.

        if it-requisicao.num-ord-inv <> 0 and
           it-requisicao.num-ord-inv <> ? and
           requisicao.situacao = 3 and param-global.modulo-in = yes then do:
           assign requisicao.situacao = 1.           
        end.
    end.

    
    if avail param-compra and param-compra.log-1 and ( (i-tipo-doc = 1 and substring(param-compra.char-2, 1, 3) = "nao") or 
                                                       (i-tipo-doc = 2 and substring(param-compra.char-2, 4, 3) = "nao") or 
                                                        i-tipo-doc > 2 )
    and lAprovacaoItem then do:
        run mensagemAprovacaoItemRequisicao.
    end.

    if avail param-compra and param-compra.log-1 and c-param <> "mod" and c-param <> "add" and 
       ( (i-tipo-doc = 1 and substring(param-compra.char-2, 1, 3) = "sim") or 
         (i-tipo-doc = 2 and substring(param-compra.char-2, 4, 3) = "sim") or 
          i-tipo-doc > 2 )THEN DO:
        run mensagemAprovacaoItemRequisicao.
    end.
/********** run pi-msg-aprov. *********/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN 
        RETURN "NOK":U.

    return "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateFieldCodUtilizItRequisicao DBOProgram 
PROCEDURE validateFieldCodUtilizItRequisicao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:
------------------------------------------------------------------------------*/ 

    if not l-classif AND c-cod-utiliz <> "" and cPrograma <> "CD0738":U then do:

        for first utiliz-natu-despes no-lock
            where utiliz-natu-despes.cod-nat-despesa = i-nat-desp 
                and utiliz-natu-despes.cod-utiliz = c-cod-utiliz: end.
        if avail utiliz-natu-despes then
            assign RowObject.ct-codigo = utiliz-natu-despes.ct-codigo
                   RowObject.sc-codigo = utiliz-natu-despes.sc-codigo.
    
        find first estabelec no-lock 
             where estabelec.cod-estabel = requisicao.cod-estabel no-error.
        assign iEmpresa = estabelec.ep-codigo when avail estabelec.

        run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
        run pi_valida_conta_contabil in h_api_cta_ctbl (input  iEmpresa,                /* EMPRESA EMS2 */
                                                        input  RowObject.cod-estabel,   /* ESTABELECIMENTO EMS2 */
                                                        input  "",                      /* UNIDADE NEGï¿½CIO */
                                                        input  "",                      /* PLANO CONTAS */ 
                                                        input  RowObject.ct-codigo,     /* CONTA */
                                                        input  "",                      /* PLANO CCUSTO */ 
                                                        input  RowObject.sc-codigo,     /* CCUSTO */
                                                        input  RowObject.dt-entrega,    /* DATA TRANSACAO */
                                                        output table tt_log_erro).      /* ERROS */
        for first tt_log_erro:
            {method/svc/errors/inserr.i &ErrorNumber="17006"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="STRING(tt_log_erro.ttv_des_msg_erro)"}
            return "NOK".
        end.

        if valid-handle(h_api_cta_ctbl) then
            delete object h_api_cta_ctbl.
    end.

    RETURN "OK":U.
 END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateFieldItemItRequisicao DBOProgram 
PROCEDURE validateFieldItemItRequisicao :
/*------------------------------------------------------------------------------
  Purpose:    
  Parameters:  
  Notes:
------------------------------------------------------------------------------*/ 

    /* Verifica se o item/familia possui classificaï¿½ï¿½o contï¿½bil (CD0250/CD0251) */
    if avail item then do:      
        for first item-uni-estab fields(it-codigo cod-estabel nat-despesa altera-conta) where
            item-uni-estab.it-codigo   = item.it-codigo and
            item-uni-estab.cod-estabel = requisicao.cod-estabel no-lock: end.
        if avail item-uni-estab then do:
            assign i-nat-desp = item-uni-estab.nat-despesa
                   l-classif  = item-uni-estab.altera-conta.
        end.
        else do:
            for first fam-mat-estab fields (fm-codigo cod-estabel nat-despesa altera-conta)
                where fam-mat-estab.fm-codigo   = item.fm-codigo
                and   fam-mat-estab.cod-estabel = requisicao.cod-estabel 
                no-lock: end.
                if avail fam-mat-estab then 
                    assign i-nat-desp = fam-mat-estab.nat-despesa
                           l-classif  = fam-mat-estab.altera-conta.
                else 
                    assign i-nat-desp = item.nat-despesa
                           l-classif  = no.
        end.


        if not l-classif then do:
            for first natureza-despesa no-lock
                where natureza-despesa.nat-despesa = i-nat-desp: end.
            if avail natureza-despesa then do:
                if substring(usuar-mater.char-1,1,1) = "y" and 
                   rowObject.num-ord-inv = 0 then do:  /**** Utilizaï¿½ï¿½o de Material ******/
                    if avail natureza-despesa and c-param = "add" then do:
                            for first utiliz-natu-despes no-lock
                                where utiliz-natu-despes.cod-nat-despesa = natureza-despesa.nat-despesa 
                                  and utiliz-natu-despes.cod-utiliz      = c-cod-utiliz: end.
                            if avail utiliz-natu-despes then do:
                                for first utilizacao-mater fields (cod-utiliz des-utiliz) where
                                    utilizacao-mater.cod-utiliz = utiliz-natu-despes.cod-utiliz 
                                    no-lock: end.
    
                                assign substring(rowObject.char-2,1,12) = utiliz-natu-despes.cod-utiliz.
                                assign rowObject.ct-codigo              = utiliz-natu-despes.ct-codigo.
                                assign rowObject.sc-codigo              = utiliz-natu-despes.sc-codigo.
                            end.
                    end.
                end.
                else 
                     assign rowObject.ct-codigo = natureza-despesa.ct-codigo.
                            rowObject.sc-codigo = natureza-despesa.sc-codigo.
            END.
            
            if avail requisicao then DO:
                find usuar-mater where usuar-mater.cod-usuario = requisicao.nome-abrev no-lock no-error.
                if not l-ScCodigo /* disable */ then do:
                   if avail usuar-mater then assign rowObject.sc-codigo = usuar-mater.sc-codigo.
                end.
                /* se o campo estava habilitado na tela, a rowObject permanecerï¿½ com o valor informado */
            end.                
        end.      

        if item.tipo-con-est <> 4 then
           assign rowObject.cod-refer = "".
    end.

    return "OK".
     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateFieldNumOrdInvItRequisicao DBOProgram 
PROCEDURE validateFieldNumOrdInvItRequisicao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:
------------------------------------------------------------------------------*/
  find estabelec where 
       estabelec.cod-estabel = requisicao.cod-estabel
       no-lock no-error.
  if avail estabelec and param-global.modulo-in = yes then
    assign i-ep-codigo-usuario = estabelec.ep-codigo.

/*/*---------------------- chamada IN2201 --------------------*/
 *   if RowObject.num-ord-inv <> 0 then do:
 *       run inp/in2201.p (input  RowObject.num-ord-inv,
 *                         input  yes,
 *                         output l-achou,
 *                         output c-ct-codigo,
 *                         output c-sc-codigo).
 *      
 *       if  l-achou = yes then do:
 *       
 *           assign iEmpresa = param-global.empresa-prin.
 *           &if defined (bf_dis_consiste_conta) &then
 *               find estabelec where
 *                    estabelec.cod-estabel = requisicao.cod-estabel no-lock no-error.
 *               if avail estabelec then     
 *               run cdp/cd9970.p (input  rowid(estabelec),
 *                                 output iEmpresa).
 *           &endif
 * 
 *           find conta-contab
 *               where conta-contab.ep-codigo = iEmpresa
 *               and   conta-contab.ct-codigo = c-ct-codigo
 *               and   conta-contab.sc-codigo = c-sc-codigo
 *               no-lock no-error.
 *           if  avail conta-contab then do:
 *               assign RowObject.conta-contabil = conta-contab.conta-contabil
 *                      RowObject.ct-codigo      = c-ct-codigo  
 *                      RowObject.sc-codigo      = c-sc-codigo    .   
 * 
 *           end.
 *           else do:
 *             /* Conta contï¿½bil nï¿½o cadastrada */
 *             {method/svc/errors/inserr.i
 *                                &ErrorNumber="47"
 *                                &ErrorType="EMS"
 *                                &ErrorSubType="ERROR" 
 *                                &ErrorParameters="'Conta Contï¿½bil'"}             
 *           end.
 *       end.
 *       else do: 
 *         /* Ordem de investimentos nï¿½o cadastrada */
 *             {method/svc/errors/inserr.i
 *                                &ErrorNumber="47"
 *                                &ErrorType="EMS"
 *                                &ErrorSubType="ERROR" 
 *                                &ErrorParameters="'Ordem de Investimento'"}             
 *       end.
 *   end. */
  
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN 
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateItemRequisicao DBOProgram 
PROCEDURE validateItemRequisicao :
/*------------------------------------------------------------------------------
  Purpose: Include: CD1406a.i3 Funï¿½ï¿½o.: Validaï¿½ï¿½es do item da requisiï¿½ï¿½o    
  Parameters:  
  Notes:
------------------------------------------------------------------------------*/  
    
    /* Validaï¿½ï¿½o do movimento X conta contï¿½bil de investimento */
    &IF DEFINED(bf_mat_conta_contab_inp) &THEN
        {inp/inapi060.i requisicao.cod-estabel rowObject.ct-codigo rowObject.sc-codigo rowObject.num-ord-inv NO tt-erro-invest}
    
        IF RETURN-VALUE = "NOK":U THEN DO:
            FIND FIRST tt-erro-invest EXCLUSIVE-LOCK NO-ERROR.
            {method/svc/errors/inserr.i
                            &ErrorNumber="tt-erro-invest.cd-erro"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="tt-erro-invest.c-param"}
            
            DELETE tt-erro-invest.
        END.
    &ENDIF
    /*----*/
    if c-param = "add" and
        can-find (b-it-requisicao where 
                  b-it-requisicao.nr-requisicao = rowObject.nr-requisicao and
                  b-it-requisicao.sequencia     = rowObject.sequencia) then do:
         /* Inicio -- Projeto Internacional */
         DEFINE VARIABLE c-lbl-liter-item-requisicao AS CHARACTER NO-UNDO.
         {utp/ut-liter.i "Item_Requisiï¿½ï¿½o" *}
         ASSIGN c-lbl-liter-item-requisicao = TRIM(RETURN-VALUE).
         {method/svc/errors/inserr.i
                            &ErrorNumber="1"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lbl-liter-item-requisicao"}  
    end.        
    assign i-tp-ressup = 1.
    
    &if defined(bf_mat_tipo_ressup) &then
        if avail item and requisicao.tp-requis > 1 then
            run cdp/cd1406a2.p (item.it-codigo,
                                requisicao.cod-estabel,
                                output i-tp-ressup).
    &endif
    
    /* Valida Centro de Custo - CE0101 */
    find first item-uni-estab where item-uni-estab.it-codigo   = item.it-codigo 
         and   item-uni-estab.cod-estabel = requisicao.cod-estabel no-lock no-error.
    if  substr(param-estoq.char-1,3,1) = "Y" and
        avail item-uni-estab                 and 
        item-uni-estab.altera-conta = no     and 
        rowobject.sc-codigo <> ""            then do:
          find usuar-ccusto where
             usuar-ccusto.sc-codigo   = rowObject.sc-codigo    and    
             usuar-ccusto.cod-usuario = requisicao.nome-abrev no-lock no-error.
       if  not avail usuar-ccusto then do:
            {method/svc/errors/inserr.i
                               &ErrorNumber="16040"
                               &ErrorType="EMS"
                               &ErrorSubType="ERROR"}
        end.
    end.
    assign l-deb-direto = no.
    
    find item where 
         item.it-codigo = rowObject.it-codigo
         no-lock no-error.
    if  not avail item then do:
         /* Inicio -- Projeto Internacional */
         DEFINE VARIABLE c-lbl-liter-item AS CHARACTER NO-UNDO.
         {utp/ut-liter.i "Item" *}
         ASSIGN c-lbl-liter-item = TRIM(RETURN-VALUE).
         {method/svc/errors/inserr.i
                            &ErrorNumber="56"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lbl-liter-item"}        
    end.
    else do:
           if can-find(estabelec 
              where estabelec.cod-estabel = requisicao.cod-estabel no-lock) then
                    for first item-uni-estab fields(it-codigo cod-estabel cod-obsoleto ) where
                         item-uni-estab.it-codigo   = item.it-codigo and
                         item-uni-estab.cod-estabel = requisicao.cod-estabel no-lock: end.
           if avail item-uni-estab then do:
                if  requisicao.tp-requis = 2 or requisicao.tp-requis = 3 then do:
                    if  item-uni-estab.cod-obsoleto = 3 or item-uni-estab.cod-obsoleto = 4 then do:
                         {method/svc/errors/inserr.i
                                            &ErrorNumber="1568"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR" 
                                            &ErrorParameters="''"} 
                    end.
                end.
                if  requisicao.tp-requis = 1 then do:
                    if  item-uni-estab.cod-obsoleto = 4 then do:
                         {method/svc/errors/inserr.i
                                            &ErrorNumber="1568"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR" 
                                            &ErrorParameters="''"}                    
                    end.
                end.
           end.
           else do:
                if  requisicao.tp-requis = 2 or requisicao.tp-requis = 3 then do:
                    if  item.cod-obsoleto = 3 or item.cod-obsoleto = 4 then do:
                         {method/svc/errors/inserr.i
                                            &ErrorNumber="1568"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR" 
                                            &ErrorParameters="''"} 
                    end.
                end.
                if  requisicao.tp-requis = 1 then do:
                    if  item.cod-obsoleto = 4 then do:
                         {method/svc/errors/inserr.i
                                            &ErrorNumber="1568"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR" 
                                            &ErrorParameters="''"} 
    
                    end.
                end.
           end.         
    
        if  item.tipo-contr = 4 and requisicao.tp-requis = 1 then do:
             {method/svc/errors/inserr.i
                                &ErrorNumber="1569"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" 
                                &ErrorParameters="''"} 
        end.        
        if  param-global.modulo-cc then do:
            if can-find(estabelec 
                where estabelec.cod-estabel = requisicao.cod-estabel no-lock) then
                  for first item-uni-estab fields(it-codigo cod-estabel cod-comprado cod-grp-compra) where
                      item-uni-estab.it-codigo   = item.it-codigo and
                      item-uni-estab.cod-estabel = requisicao.cod-estabel no-lock: end.
            
            if param-compra.int-2 = 1 then do:         
               if avail item-uni-estab and item-uni-estab.cod-grp-compra = "" then do:
                     {method/svc/errors/inserr.i
                                        &ErrorNumber="16419"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR" 
                                        &ErrorParameters="''"} 
               end.
            end.       
            if param-compra.int-2 = 2 then do:            
               if requisicao.tp-requis <> 1 then do:        
                     if avail item-uni-estab then
                        find comprador where comprador.cod-comprado = item-uni-estab.cod-comprado no-lock no-error.
                     if not avail comprador then do:
                         {method/svc/errors/inserr.i
                                            &ErrorNumber="15712"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR" 
                                            &ErrorParameters="''"} 
    
                     end.
               end.   
            end.              
        end.  
        if  item.tipo-con-est <> 2 and 
           (c-param = "add" or (c-param = "mod" and requisicao.tp-requis <> 1))           
           then do:
            if  rowObject.qt-a-atender = 0 then do:
                 {method/svc/errors/inserr.i
                                    &ErrorNumber="1570"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR" 
                                    &ErrorParameters="''"} 
            end.
        end.
        if  requisicao.tp-requis <> 1 and requisicao.tp-requis <> 3 then do:
            if  item.tipo-contr = 4 and rowObject.preco-unit = 0  and
                &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
                     NOT usuar-mater.log-suger-preco-item-db-diret
                &ElSE
                     SUBSTR(usuar-mater.char-1,12,1) = "N"
                &ENDIF  then do:
                     {method/svc/errors/inserr.i
                                        &ErrorNumber="1573"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR" 
                                        &ErrorParameters="''"}         
            end.
        end.
    end.
    
    if avail ITEM AND rowObject.qt-a-atender <> 0 then do:
         if  not(item.fraciona)
         and rowObject.qt-a-atender <>
             rowObject.qt-a-atender then do:
             /* Quantidade deve ser um valor inteiro */
                  {method/svc/errors/inserr.i
                                     &ErrorNumber="847"
                                     &ErrorType="EMS"
                                     &ErrorSubType="ERROR" 
                                     &ErrorParameters="''"} 
         end.
    end.   
    if avail item then do:
         if  rowObject.it-codigo = ?
         or  rowObject.it-codigo = ""
         or  item.tipo-contr = 4 then do:
             find first tab-unidade
                 where  tab-unidade.un = rowObject.un
                 no-lock no-error.
             if  not avail tab-unidade then do:
                  /* Inicio -- Projeto Internacional */
                  DEFINE VARIABLE c-lbl-liter-unidade-de-medida AS CHARACTER NO-UNDO.
                  {utp/ut-liter.i "Unidade_de_Medida" *}
                  ASSIGN c-lbl-liter-unidade-de-medida = TRIM(RETURN-VALUE).
                  {method/svc/errors/inserr.i
                                     &ErrorNumber="56"
                                     &ErrorType="EMS"
                                     &ErrorSubType="ERROR" 
                                     &ErrorParameters="c-lbl-liter-unidade-de-medida"} 
             end.
             
             find first item-fornec 
                 where item-fornec.ativo and
                       item-fornec.it-codigo = item.it-codigo
                       no-lock no-error.
             if avail item-fornec then do:
                 if  rowObject.un <> item.un then do: 
                      {method/svc/errors/inserr.i
                                         &ErrorNumber="1571"
                                         &ErrorType="EMS"
                                         &ErrorSubType="ERROR"} 
                 end.
             end.
         end.
         else do:
               if  rowObject.un <> item.un then do:
                    {method/svc/errors/inserr.i
                                       &ErrorNumber="1571"
                                       &ErrorType="EMS"
                                       &ErrorSubType="ERROR"} 
               end.
         end.     
    end.     
    if avail item then do:
         if  item.tipo-contr = 4
         and item.it-codigo  = ""
         and rowObject.narrativa = "" then do:
              {method/svc/errors/inserr.i
                                 &ErrorNumber="1572"
                                 &ErrorType="EMS"
                                 &ErrorSubType="ERROR" 
                                 &ErrorParameters="''"}
         end.
    end.
    
     /* Verifica se o item/familia possui classificaï¿½ï¿½o contï¿½bil (CD0250/CD0251) */
     /* Release 2.02 */
    
     IF AVAIL item THEN DO:
         IF  CAN-FIND (FIRST estabelec
                       WHERE estabelec.cod-estabel = requisicao.cod-estabel NO-LOCK) THEN
             FOR FIRST  item-uni-estab
                 FIELDS (it-codigo cod-estabel nat-despesa altera-conta)
                 WHERE  item-uni-estab.it-codigo   = rowObject.it-codigo    AND
                        item-uni-estab.cod-estabel = requisicao.cod-estabel NO-LOCK: END.
    
         IF  AVAIL item-uni-estab THEN
             ASSIGN l-classif  = item-uni-estab.altera-conta
                    i-nat-desp = item-uni-estab.nat-despesa.
         ELSE DO:
             FOR FIRST  fam-mat-estab
                 FIELDS (fm-codigo cod-estabel nat-despesa altera-conta)
                 WHERE  fam-mat-estab.fm-codigo   = item.fm-codigo         AND
                        fam-mat-estab.cod-estabel = requisicao.cod-estabel NO-LOCK: END.
    
             IF  AVAIL fam-mat-estab THEN
                 ASSIGN l-classif  = fam-mat-estab.altera-conta
                        i-nat-desp = fam-mat-estab.nat-despesa.
             ELSE
                 ASSIGN l-classif  = NO
                        i-nat-desp = item.nat-despesa.
         END.
     END.

     
            
    /* Se nï¿½o utilizar Classificaï¿½ï¿½o Contï¿½bil ou utilizar e o usuï¿½rio alterou a conta do documento (tinha permissï¿½o/utilizaï¿½ï¿½o de material), valida a conta */
    if not l-classif then do:
        find first estabelec no-lock 
             where estabelec.cod-estabel = requisicao.cod-estabel no-error.
        if avail estabelec then      
            assign iEmpresa = estabelec.ep-codigo when avail estabelec.

        assign c-ct-codigo = RowObject.ct-codigo.
        run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
        run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        iEmpresa,                   /* EMPRESA EMS2 */
                                                       input        "",                         /* PLANO DE CONTAS */
                                                       input-output c-ct-codigo,                /* CONTA */
                                                       input        RowObject.dt-entrega,       /* DATA TRANSACAO */
                                                       output       v_des_cta_ctbl,             /* DESCRICAO CONTA */
                                                       output       v_num_tip_cta_ctbl,         /* TIPO DA CONTA */
                                                       output       v_num_sit_cta_ctbl,         /* SITUAï¿½ï¿½O DA CONTA */
                                                       output       v_ind_finalid_cta,          /* FINALIDADES DA CONTA */
                                                       output table tt_log_erro).               /* ERROS */
        if valid-handle(h_api_cta_ctbl) then
            delete object h_api_cta_ctbl.
        
        
        if not can-find(tt_log_erro) then do:
            if ((int(v_num_tip_cta_ctbl) <> 1 and
                 int(v_num_tip_cta_ctbl) <> 2 and   
                 int(v_num_tip_cta_ctbl) <> 4 and   
                 int(v_num_tip_cta_ctbl) <> 5) or
                 int(v_num_sit_cta_ctbl) <> 3) then do:
             /* Conta deve ser de Despesa, Passivo ou Ativo, e de Sistema */
             {method/svc/errors/inserr.i
                                &ErrorNumber="1576"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" 
                                &ErrorParameters="''"}
            end.
        
            /* Verifica Estoque */
            assign ind       = 1
                   i-estoque = 0.
            do while ind <= 10:
                assign v_cod_finalid = {adinc/i05ad049.i 4 ind}.
            
                if lookup(v_cod_finalid, v_ind_finalid_cta) > 0 then do:
                    assign i-estoque = ind.
                    leave.
                end.
            
                assign ind = ind + 1.
            end.
        
            if (i-estoque = 0 or 
               (i-estoque <> 1 and  
                i-estoque <> 2 and  
                i-estoque <> 3 and  
                i-estoque <> 5 and  
                i-estoque <> 6)) then do:
                /* Conta contabil nao aceita movimento */
                {method/svc/errors/inserr.i
                                    &ErrorNumber="1577"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR" 
                                    &ErrorParameters="''"}
            end.
        end.
    end.

    if substring(usuar-mater.char-1,1,1) = "y" and rowobject.num-ord-inv = 0 then do:
        find first utilizacao-mater no-lock 
             where utilizacao-mater.cod-utiliz = c-cod-utiliz no-error.
        if not avail utilizacao-mater then do:
             /* Inicio -- Projeto Internacional */
             DEFINE VARIABLE c-lbl-liter-utilizacao-de-materias AS CHARACTER NO-UNDO.
             {utp/ut-liter.i "Utilizaï¿½ï¿½o_de_Materias" *}
             ASSIGN c-lbl-liter-utilizacao-de-materias = TRIM(RETURN-VALUE).
             {method/svc/errors/inserr.i
                                &ErrorNumber="56"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" 
                                &ErrorParameters="c-lbl-liter-utilizacao-de-materias"}  
        end.
        for first utiliz-natu-despes no-lock
            where utiliz-natu-despes.cod-nat-despesa = i-nat-desp 
              and utiliz-natu-despes.cod-utiliz = c-cod-utiliz: end.
        if not avail utiliz-natu-despes then do:
             {method/svc/errors/inserr.i
                                &ErrorNumber="16848"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" 
                                &ErrorParameters="string(i-nat-desp) + '~~~~' + c-cod-utiliz"}
        end.
    end.

    if rowObject.dt-entrega < today then do:
         /* Inicio -- Projeto Internacional */
         DEFINE VARIABLE c-lbl-liter-data-de-entrega AS CHARACTER NO-UNDO.
         {utp/ut-liter.i "data_de_entrega" *}
         ASSIGN c-lbl-liter-data-de-entrega = TRIM(RETURN-VALUE).
         {method/svc/errors/inserr.i
                            &ErrorNumber="16935"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lbl-liter-data-de-entrega"}         
    end.
    
    /*****  Aprovaï¿½ï¿½o Eletrï¿½nica  *****/
    assign i-tipo-trans = if c-param = "add" 
                          then 1 
                          else 2
           i-tipo-doc = 0.  /*Inicializa com Zero*/
    
    if  requisicao.tp-requis = 1    /*Se for Requisicao e Aprova Requisicao*/
    and substr(param-estoq.char-1,4,1) = "Y"
    and param-compra.log-1  then
        assign i-tipo-doc = 2.
    else if  requisicao.tp-requis = 2 /*Senï¿½o, Se for Solicitaï¿½ï¿½o e utiliza aprovaï¿½ï¿½o eletrï¿½nica*/
         and param-compra.log-1 then
        assign i-tipo-doc = 1.
    
    if i-tipo-doc > 0 then do:
        run cdp/cdapi173.p (input  i-tipo-doc,
                            input  rowObject.it-codigo,
                            input  requisicao.nome-abrev,
                            output l-retorno-aprov).
        if can-find(funcao where
             funcao.cd-funcao = "Integra_AED_EMS" and
             funcao.ativo     = yes) then do:
             ASSIGN de-valor-item = rowObject.val-item
                    de-valor-total = de-valor-item.
               
             FOR EACH it-requisicao WHERE 
                      it-requisicao.nr-requisicao = requisicao.nr-requisicao NO-LOCK:
                    ASSIGN de-valor-total = de-valor-total + it-requisicao.val-item.
             END.  
             run aedp/aedapi173.p (input i-tipo-doc,
                                   input rowObject.it-codigo,
                                   input requisicao.nome-abrev,
                                   input rowObject.ct-codigo,
                                   input requisicao.cod-estabel,
                                   input rowObject.sc-codigo,
                                   input de-valor-item,
                                   input de-valor-total,
                                   input requisicao.cod-estabel,
                                   output table tt-erro).
    
             if  return-value = "NOK":U then do:
                    find first tt-erro no-error.
                    if  avail tt-erro then do:
                        {method/svc/errors/inserr.i
                                    &ErrorNumber="tt-erro.cd-erro"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR" 
                                    &ErrorParameters="tt-erro.c-param"}
                                    
                        return "nok":U.
                    end.
             end.
        end.

        RUN lap/mlaapi099.p (INPUT i-tipo-doc).

        if can-find(funcao where
             funcao.cd-funcao = "Integra_MLA_EMS" and
             funcao.ativo     = yes) AND RETURN-VALUE <> "NOK":U then do:
             ASSIGN de-valor-item = rowObject.val-item
                    de-valor-total = de-valor-item.
               
             FOR EACH it-requisicao WHERE 
                      it-requisicao.nr-requisicao = requisicao.nr-requisicao NO-LOCK:
                    ASSIGN de-valor-total = de-valor-total + it-requisicao.val-item.
             END. 
             
             run lap/mlaapi173.p (input i-tipo-doc,
                                   input rowObject.it-codigo,
                                   input requisicao.nome-abrev,
                                   input rowObject.ct-codigo,
                                   input requisicao.cod-estabel,
                                   input rowObject.sc-codigo,
                                   input de-valor-item,
                                   input de-valor-total,
                                   input requisicao.cod-estabel,
                                   output table tt-erro).
    
             if  return-value = "NOK":U then do:
                    find first tt-erro no-error.
                    if  avail tt-erro then do:
                        {method/svc/errors/inserr.i
                                    &ErrorNumber="tt-erro.cd-erro"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR" 
                                    &ErrorParameters="tt-erro.c-param"}
                                    
                        return "nok":U.
                    end.
             end.
        end.
    
        /*  Inï¿½cio EPC Grendene */
        FOR EACH tt-epc
           WHERE tt-epc.cod-event = "validateItem" :
            DELETE tt-epc.
        END.
    
        CREATE tt-epc.
        ASSIGN tt-epc.cod-event     = "validateItem":U
               tt-epc.cod-parameter = "retorno-aprov":U
               tt-epc.val-parameter = string(l-retorno-aprov).
    
        CREATE tt-epc.
        ASSIGN tt-epc.cod-event     = "validateItem":U
               tt-epc.cod-parameter = "item":U
               tt-epc.val-parameter = rowObject.it-codigo.
    
        {include/i-epc201.i "validateItem"}
    
        FIND FIRST tt-epc
             WHERE tt-epc.cod-event     = "validateItem":U
               AND tt-epc.cod-parameter = "retorno-aprov":U NO-ERROR.
        IF AVAIL tt-epc THEN
            ASSIGN l-retorno-aprov = IF tt-epc.val-parameter = "yes" THEN YES ELSE NO.
    
        /* Fim EPC Grendene */ 
    
        if not l-retorno-aprov then do:
             {method/svc/errors/inserr.i
                                &ErrorNumber="15661"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" 
                                &ErrorParameters="''"}                                
        end.
    end.
    
    /*****  Estatï¿½sticas Compras  *****/
    if c-param = "mod" then do:
        run ccp/ccapi642.p (1, rowid(it-requisicao), 3).
    end.
    /**********************************/
    /* Fim da Include */

    return "OK".   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Valida temptable RowObject
  Parameters:  recebe o tipo de validaï¿½ï¿½o (Create, Delete, )
  Notes:
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    /*--- Utilize o parï¿½metro pType para identificar quais as validaï¿½ï¿½es a serem
          executadas ---*/
    /*--- Os valores possï¿½veis para o parï¿½metro sï¿½o: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atravï¿½s do
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as validaï¿½ï¿½es ---*/

    /*--- Verifica ocorrï¿½ncia de erros ---*/

   /** Validaï¿½ï¿½es de Criaï¿½ï¿½o do registro **/
   if pType = "CREATE":U then do:
      /******************************************************************************/
      /** Validaï¿½ï¿½es utilizadas apenas para quando a BO for executada pelo CD0738. **/
      /** OBS: necessï¿½rio isto, para nï¿½o interferir no processo WEBSPEED do CD1406 **/
      /******************************************************************************/
      if cPrograma = "CD0738":U then do:
          /*** Requisitante inexistente***/
          if not can-find (first requisitante
                           where requisitante.nome-abrev = RowObject.nome-abrev no-lock) then do:
              {utp/ut-liter.i "Requisitante Inexistente"}
              {method/svc/errors/inserr.i
                      &ErrorNumber="17567"
                      &ErrorType="EMS"
                      &ErrorSubType="ERROR"
                      &ErrorParameters="return-value"}
          end.
          /***  Item Inexistente ***/
          if not can-find (first item
                           where item.it-codigo = RowObject.it-codigo no-lock) then do:
              {utp/ut-liter.i "Item Inexistente"}
              {method/svc/errors/inserr.i
                      &ErrorNumber="17567"
                      &ErrorType="EMS"
                      &ErrorSubType="ERROR"
                      &ErrorParameters="return-value"}
          end.
          /*** Quantidade nï¿½o pode ser igual a zero**/
          if RowObject.qt-atendida = 0 and RowObject.qt-a-atender = 0 then do:
              {utp/ut-liter.i "Quantidade deve ser diferente de zero"}
              {method/svc/errors/inserr.i
                      &ErrorNumber="1570"
                      &ErrorType="EMS"
                      &ErrorSubType="ERROR"
                      &ErrorParameters="return-value"}
          end.
          /***Unidade de medida Inexistente***/
          if not can-find (first tab-unidade
                           where tab-unidade.un = rowObject.un no-lock) then do:
              {utp/ut-liter.i "Unidade de Medida Inexistente"}
              {method/svc/errors/inserr.i
                      &ErrorNumber="17567"
                      &ErrorType="EMS"
                      &ErrorSubType="ERROR" 
                      &ErrorParameters="return-value"}
          end. 
      end.
      /******************************************************************************/
      /**                    Fim das validaï¿½ï¿½es para o CD0738                      **/
      /******************************************************************************/
   end. /** CREATE **/

    if pType = "DELETE":U then do:
        find first requisicao
            where requisicao.nr-requisicao = RowObject.nr-requisicao no-lock no-error.

        if  requisicao.tp-requis = 1    /*Se for Requisicao e Aprova Requisicao*/
            and substr(param-estoq.char-1,4,1) = "Y"
            and param-compra.log-1  then

            assign i-tipo-doc = 2.

        else if  requisicao.tp-requis = 2 /*Senï¿½o, Se for Solicitaï¿½ï¿½o e utiliza aprovaï¿½ï¿½o eletrï¿½nica*/
            and param-compra.log-1 then
            
            assign i-tipo-doc = 1.

        run cdp/cdapi171.p (i-tipo-doc, 3, rowid(it-requisicao)).


        /*Verifica situaï¿½ï¿½o*/
        FIND FIRST b-it-requisicao
             WHERE b-it-requisicao.nr-requisicao = RowObject.nr-requisicao
               AND b-it-requisicao.sequencia     = RowObject.sequencia
               AND b-it-requisicao.it-codigo     = RowObject.it-codigo NO-LOCK NO-ERROR.
       IF AVAIL b-it-requisicao THEN DO:

           IF  b-it-requisicao.situacao = 4 THEN DO:

               /* Inicio -- Projeto Internacional */
               DEFINE VARIABLE c-lbl-liter-item-2 AS CHARACTER NO-UNDO.
               {utp/ut-liter.i "Item" *}
               ASSIGN c-lbl-liter-item-2 = TRIM(RETURN-VALUE).
               DEFINE VARIABLE c-lbl-liter-noo-pode-ser-excludo-pois-poss AS CHARACTER NO-UNDO.
               {utp/ut-liter.i "nï¿½o_pode_ser_excluï¿½do_pois_possui_ordem_de_compra" *}
               ASSIGN c-lbl-liter-noo-pode-ser-excludo-pois-poss = TRIM(RETURN-VALUE).
               {method/svc/errors/inserr.i
                     &ErrorNumber="17006"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR" 
                     &ErrorParameters="c-lbl-liter-item-2 + ' ' + RowObject.it-codigo + ' ' + c-lbl-liter-noo-pode-ser-excludo-pois-poss + '.'"}/*ver msg*/
                     
               RETURN "NOK":U. 
           END.
           ELSE IF b-it-requisicao.situacao = 2 THEN DO:

               /* Inicio -- Projeto Internacional */
               DEFINE VARIABLE c-lbl-liter-item-3 AS CHARACTER NO-UNDO.
               {utp/ut-liter.i "Item" *}
               ASSIGN c-lbl-liter-item-3 = TRIM(RETURN-VALUE).
               DEFINE VARIABLE c-lbl-liter-noo-pode-ser-excludo-pois-soli AS CHARACTER NO-UNDO.
               {utp/ut-liter.i "nï¿½o_pode_ser_excluï¿½do_pois_Solicitaï¿½ï¿½o_estï¿½_fechada" *}
               ASSIGN c-lbl-liter-noo-pode-ser-excludo-pois-soli = TRIM(RETURN-VALUE).
               {method/svc/errors/inserr.i
                     &ErrorNumber="17006"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR" 
                     &ErrorParameters="c-lbl-liter-item-3 + ' ' + RowObject.it-codigo + ' ' + c-lbl-liter-noo-pode-ser-excludo-pois-soli + '.'"}/*ver msg*/
                     
               RETURN "NOK":U.
           END.
       END.
    END.

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetlAprovacaoItem DBOProgram 
PROCEDURE SetlAprovacaoItem :
/*------------------------------------------------------------------------------
  Purpose:   
  Parameters:
  Notes:
------------------------------------------------------------------------------*/
    define input parameter plAprovacaoItem as logical no-undo.

    assign lAprovacaoItem = plAprovacaoItem.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnAprovTotal DBOProgram 
PROCEDURE returnAprovTotal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input  parameter prRequisicao as rowid   no-undo.
    define output parameter lAprovTotal  as logical no-undo.

    for first param-compra no-lock: end.
    for first param-estoq no-lock: end.

    for first requisicao where
              rowid(requisicao) = prRequisicao no-lock:
        lAprovTotal = if ((requisicao.tp-requis = 1 and 
                             substr(param-estoq.char-1,4,1) = "Y" and 
                             param-compra.log-1 and
                             substring(param-compra.char-2, 4, 3) = "sim") or 
                            (requisicao.tp-requis = 2 and
                             param-compra.log-1 and
                             substring(param-compra.char-2, 1, 3) = "sim")) then yes else no.
    end.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraPendenciaAprovacaoTotal DBOProgram 
PROCEDURE geraPendenciaAprovacaoTotal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:
------------------------------------------------------------------------------*/ 
    def input  param prItRequisicao as row no-undo.
   
    for first param-estoq no-lock: end.
    for first param-compra no-lock: end.

    for first it-requisicao where
              rowid(it-requisicao) = prItRequisicao no-lock:
        for first requisicao where
                  requisicao.nr-requisicao = it-requisicao.nr-requisicao exclusive-lock:
            if requisicao.tp-requis = 1 and 
               substr(param-estoq.char-1,4,1) = "Y" and 
               param-compra.log-1 then assign i-tipo-doc = 2.
            else if requisicao.tp-requis = 2 and 
                 param-compra.log-1 then assign i-tipo-doc = 1.

            run cdp/cdapi171.p (i-tipo-doc, 1, rowid(it-requisicao)).

            assign requisicao.estado = 1
                   requisicao.nome-aprov = requisicao.nome-abrev.
            /**  Melhorias
            **/
            &if defined(bf_mat_aprova_eletronica) &then
                for each b-it-requisicao where
                         b-it-requisicao.nr-requisicao = requisicao.nr-requisicao exclusive-lock:
                    assign b-it-requisicao.estado = 1
                           b-it-requisicao.nome-aprov = requisicao.nome-abrev.
                end.
            &endif
            
            
            assign l-pendente = no.
            run cdp/cdapi172.p (i-tipo-doc, rowid(it-requisicao), output l-pendente).

            if  l-pendente then do:
                assign requisicao.estado = 2
                       requisicao.nome-aprov = "":U.
                /**  Melhorias 
                **/
                &if defined(bf_mat_aprova_eletronica) &then
                    for each b-it-requisicao where
                             b-it-requisicao.nr-requisicao = requisicao.nr-requisicao exclusive-lock:
                        assign b-it-requisicao.estado = 2
                               b-it-requisicao.nome-aprov = "".
                    end.
                &endif
            end.                               
            
            run mensagemAprovacaoItemRequisicao.
        end.
    end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setaPrograma DBOProgram 
PROCEDURE setaPrograma :
/*------------------------------------------------------------------------------
  Purpose:   
  Parameters:
  Notes:
------------------------------------------------------------------------------*/
    define input parameter pPrograma as char no-undo.

    assign cPrograma = pPrograma.

return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RetornaOrdemInvSolum DBOProgram 
PROCEDURE RetornaOrdemInvSolum:
/*------------------------------------------------------------------------------
  Purpose:     Retorna a ordem de investimento.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER  c-id-proj AS CHAR NO-UNDO.
    DEFINE INPUT PARAMETER  c-id-tarefa AS CHAR NO-UNDO.
    DEFINE INPUT PARAMETER  p-ep-codigo LIKE empresa.ep-codigo.
    DEFINE OUTPUT PARAMETER c-num-ord  AS INT NO-UNDO.
    
    
    FIND FIRST proj-inv NO-LOCK
               WHERE proj-inv.sigla = c-id-proj and
                     proj-inv.ep-codigo = p-ep-codigo NO-ERROR.

    &if '{&bf_mat_versao_ems}' < '2.08' &then
        IF AVAIL proj-inv THEN
        FIND FIRST sub-div-ordem NO-LOCK
            WHERE sub-div-ordem.num-projeto = proj-inv.num-projeto
              AND substring(sub-div-ordem.char-1,1,100) = c-id-tarefa 
              AND sub-div-ordem.ep-codigo = proj-inv.ep-codigo NO-ERROR.
    &else
       IF AVAIL proj-inv THEN
        FIND FIRST sub-div-ordem NO-LOCK
            WHERE sub-div-ordem.num-projeto = proj-inv.num-projeto
              AND sub-div-ordem.cod-id-solum = c-id-tarefa
              AND sub-div-ordem.ep-codigo = proj-inv.ep-codigo NO-ERROR.
    &endif
    IF AVAIL sub-div-ordem THEN
        ASSIGN c-num-ord = sub-div-ordem.num-ord-magnus.
    ELSE 
        {method/svc/errors/inserr.i
                  &ErrorNumber="34765"
                  &ErrorType="EMS"
                  &ErrorSubType="ERROR"
                  &ErrorParameters="c-id-proj + '/' + c-id-tarefa"}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-conecta-ems5 V-table-Win 
PROCEDURE pi-conecta-ems5 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input  param l-conecta   as logical no-undo.
    def input  param p-empresa   like param-global.empresa-prin no-undo.
    def output param l-erro-ems5 as logical no-undo.

    def var l-ja-conec-emsbas as logical no-undo.
    def var l-ja-conec-emsuni as logical no-undo.

    assign l-erro-ems5 = no. 

    if  l-conecta then do:
        if  search("prgint/utb/utb907za.py") = ? 
        and search("prgint/utb/utb907za.r")  = ? then do:
            run utp/ut-msgs.p (input "show":U, input 6246,
                               input "prgint/utb/utb907za.py" ).
            assign l-erro-ems5 = yes. 
        end.
        else do:        
            if  connected("emsuni") 
                then assign l-ja-conec-emsuni = yes.
                else assign l-ja-conec-emsuni = no.

            if  connected("emsbas") 
                then assign l-ja-conec-emsbas = yes.
                else assign l-ja-conec-emsbas = no.        

            if  l-ja-conec-emsuni = no or 
                l-ja-conec-emsbas = no then do:
                run pi-conecta-bco IN h-btb009za (input 1,                        /* Versao API          */
                                                  input 1,                        /* 1 - Conexao, 2 - Desconexao */
                                                  input p-empresa,                /* Codigo da Empresa   */
                                                  input "all":U,                  /* Nome do Banco       */
                                                  output table tt_erros_conexao). /* Temp-Table de Erros */        

                if  return-value <> "OK":U then do:
                    find first tt_erros_conexao no-lock no-error.
                    if avail tt_erros_conexao then do:
                       {method/svc/errors/inserr.i
                             &ErrorNumber="tt_erros_conexao.cd-erro"
                             &ErrorType="EMS"
                             &ErrorSubType="ERROR" 
                             &ErrorParameters="tt_erros_conexao.param-1"}
                           assign l-erro-ems5 = yes.
                    end.               
                end.
                else do:
                    if  not connected("emsuni") then do:
                        {utp/ut-liter.i "EMSUNI"}
                        {method/svc/errors/inserr.i
                             &ErrorNumber="17718"
                             &ErrorType="EMS"
                             &ErrorSubType="ERROR" 
                             &ErrorParameters="return-value"}
                        assign l-erro-ems5 = yes.
                    end.

                    if  not connected("emsbas") then do: 
                        {utp/ut-liter.i "emsbas"}
                        {method/svc/errors/inserr.i
                             &ErrorNumber="17718"
                             &ErrorType="EMS"
                             &ErrorSubType="ERROR" 
                             &ErrorParameters="return-value"}
                        assign l-erro-ems5 = yes.
                    end.
                end.               
            end.    
        end.
    end.

    if  not l-conecta or l-erro-ems5 then do:
        if  l-ja-conec-emsuni = no or 
            l-ja-conec-emsbas = no then do: 
            run pi-conecta-bco IN h-btb009za (input 1,                        /* Versao API          */
                                              input 2,                        /* 1 - Conexao, 2 - Desconexao */
                                              input p-empresa,                /* Codigo da Empresa   */
                                              input "all":U,                  /* Nome do Banco       */
                                              output table tt_erros_conexao). /* Temp-Table de Erros */
            if return-value <> "OK":U then do:
                find first tt_erros_conexao no-lock no-error.
                if avail tt_erros_conexao then do:
                   run utp/ut-msgs.p ( input "msg":U,
                                       input tt_erros_conexao.cd-erro,
                                       input tt_erros_conexao.param-1).
                   assign l-erro-ems5 = yes.
                   {utp/ut-liter.i Erros_Progress }                    
                end.
            end.
        end.
    end.             

END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-conecta-ems5 V-table-Win 
PROCEDURE validate-record-rm:
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
       DEFINE INPUT PARAMETER TABLE FOR tt-matriz.
    &endif
    DEFINE VARIABLE i-tp-ressup      AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-empresa        LIKE empresa.ep-codigo     NO-UNDO.
    DEFINE VARIABLE h-boiv029        AS HANDLE      NO-UNDO.
    DEFINE VARIABLE h-cdapi024       AS HANDLE      NO-UNDO.
    DEFINE VARIABLE de-valor-item    AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-valor-total   AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-tot-unid      AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE l-classif-item   AS LOGICAL     NO-UNDO INITIAL NO.
    
    
    ASSIGN  l-mat-unid-negoc = param-mat.ind-unid-neg.
    
    if pType = "CREATE":U OR pType = "UPDATE":U  then do:
            
        /*Verifica situaï¿½ï¿½o*/
        FIND FIRST b-it-requisicao
             WHERE b-it-requisicao.nr-requisicao = RowObject.nr-requisicao
               AND b-it-requisicao.sequencia     = RowObject.sequencia
               AND b-it-requisicao.it-codigo     = RowObject.it-codigo NO-LOCK NO-ERROR.
        IF AVAIL b-it-requisicao THEN DO:
            IF  b-it-requisicao.situacao = 4 THEN DO:

                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-item-4 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Item" *}
                ASSIGN c-lbl-liter-item-4 = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-noo-pode-ser-alterado-pois-pos AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "nï¿½o_pode_ser_alterado_pois_possui_ordem_de_compra" *}
                ASSIGN c-lbl-liter-noo-pode-ser-alterado-pois-pos = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                      &ErrorNumber="17006"
                      &ErrorType="EMS"
                      &ErrorSubType="ERROR" 
                      &ErrorParameters="c-lbl-liter-item-4 + ' ' + RowObject.it-codigo + ' ' + c-lbl-liter-noo-pode-ser-alterado-pois-pos + '.'"}
                      
                RETURN "NOK":U. 
            END.
            ELSE IF b-it-requisicao.situacao = 2 THEN DO:

                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-item-5 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Item" *}
                ASSIGN c-lbl-liter-item-5 = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-noo-pode-ser-alterado-pois-sol AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "nï¿½o_pode_ser_alterado_pois_Solicitaï¿½ï¿½o_estï¿½_fechada" *}
                ASSIGN c-lbl-liter-noo-pode-ser-alterado-pois-sol = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                      &ErrorNumber="17006"
                      &ErrorType="EMS"
                      &ErrorSubType="ERROR" 
                      &ErrorParameters="c-lbl-liter-item-5 + ' ' + RowObject.it-codigo + ' ' + c-lbl-liter-noo-pode-ser-alterado-pois-sol + '.'"}/*ver msg*/
                      
                RETURN "NOK":U.       
            END.
        END.

        IF NOT AVAIL requisicao THEN
            FIND FIRST requisicao EXCLUSIVE-LOCK 
                 WHERE requisicao.nr-requisicao = RowObject.nr-requisicao NO-ERROR.
        IF AVAIL requisicao THEN
            find first usuar-mater no-lock 
                 where usuar-mater.cod-usuario = requisicao.nome-abrev no-error.     
        IF NOT AVAIL item-uni-estab THEN
            FIND FIRST item-uni-estab NO-LOCK 
                 WHERE item-uni-estab.it-codigo   = RowObject.it-codigo
                   AND item-uni-estab.cod-estabel = requisicao.cod-estabel NO-ERROR.
        IF NOT AVAIL estabelec THEN DO:
            IF AVAIL requisicao THEN
                FIND FIRST estabelec NO-LOCK 
                     WHERE estabelec.cod-estabel = requisicao.cod-estabel NO-ERROR.
        END.
        
        /*IF NOT AVAIL ITEM THEN*/
        FIND FIRST ITEM NO-LOCK 
             WHERE ITEM.it-codigo = RowObject.it-codigo NO-ERROR.        
        IF NOT AVAIL param-global THEN
            FIND FIRST param-global NO-LOCK NO-ERROR.
        IF NOT AVAIL param-compra THEN
            FIND FIRST param-compra NO-LOCK NO-ERROR.
        
        IF pType = "CREATE":U THEN DO:
            /*Validaï¿½ï¿½o Sub-Conta*/
            FIND FIRST item-uni-estab NO-LOCK 
                 WHERE item-uni-estab.it-codigo   = RowObject.it-codigo
                   AND item-uni-estab.cod-estabel = RowObject.cod-estabel NO-ERROR.
            IF AVAIL item-uni-estab THEN DO:
                IF NOT(item-uni-estab.altera-conta) THEN DO:
                    IF  RowObject.sc-codigo = "" THEN DO:
                      {utp/ut-liter.i "Sub-Conta Contï¿½bil"}
                      {method/svc/errors/inserr.i
                             &ErrorNumber="265"
                             &ErrorType="EMS"
                             &ErrorSubType="ERROR"
                             &ErrorParameters="return-value"}
                    END.
                END.
                ELSE
                    ASSIGN l-classif-item = YES.
            END.
        
            IF RowObject.sequencia = 0 THEN DO:
                 find requisicao where 
                       requisicao.nr-requisicao = RowObject.nr-requisicao EXCLUSIVE-LOCK no-error.
                 if  avail requisicao then do:
                      find last it-requisicao where 
                                it-requisicao.nr-requisicao = requisicao.nr-requisicao EXCLUSIVE-LOCK no-error.
                      if  avail it-requisicao then
                          assign RowObject.sequencia = it-requisicao.sequencia + 10.
                      ELSE
                          assign RowObject.sequencia = 10.
                      
                 END.
            END.                            
            
            IF RowObject.sequencia > 999 THEN DO:

                  /* Inicio -- Projeto Internacional */
                  DEFINE VARIABLE c-lbl-liter-sequuncia AS CHARACTER NO-UNDO.
                  {utp/ut-liter.i "Sequï¿½ncia" *}
                  ASSIGN c-lbl-liter-sequuncia = TRIM(RETURN-VALUE).
                  DEFINE VARIABLE c-lbl-liter-invalida AS CHARACTER NO-UNDO.
                  {utp/ut-liter.i "invï¿½lida" *}
                  ASSIGN c-lbl-liter-invalida = TRIM(RETURN-VALUE).
                  {method/svc/errors/inserr.i
                         &ErrorNumber="17006"
                         &ErrorType="EMS"
                         &ErrorSubType="ERROR"
                         &ErrorParameters="c-lbl-liter-sequuncia + ' ' + string(RowObject.sequencia) + ' ' + c-lbl-liter-invalida + '.'"}
            END.                               
        
            IF AVAIL requisicao THEN DO:
                IF requisicao.tp-requis = 2 THEN DO:
                   IF AVAIL item-uni-estab
                        AND RowObject.dt-entrega < (TODAY + item-uni-estab.res-int-comp + item-uni-estab.res-for-comp) THEN DO:
                       
                       {method/svc/errors/inserr.i
                           &ErrorNumber="33330"
                           &ErrorType="EMS"
                           &ErrorSubType="ERROR" 
                           &ErrorParameters="STRING(TODAY + item-uni-estab.res-int-comp + item-uni-estab.res-for-comp) + '~~~~' +
                                             STRING(item-uni-estab.res-int-comp) + '~~~~' + STRING(item-uni-estab.res-for-comp)"}
                   END.
                END.
            END.
            IF CAN-FIND (FIRST it-requisicao where        
                               it-requisicao.nr-requisicao = RowObject.nr-requisicao AND
                               it-requisicao.sequencia     = RowObject.sequencia) THEN DO:
                {utp/ut-table.i mgind it-requisicao 1}
                {method/svc/errors/inserr.i
                       &ErrorNumber="1"
                       &ErrorType="EMS"
                       &ErrorSubType="ERROR" 
                       &ErrorParameters="return-value"}
        
            END.
            /******************************************************************************/
            /**                    Fim das validaï¿½ï¿½es para o CD0738                      **/
            /******************************************************************************/
            
        END.
        
        IF NOT CAN-FIND (FIRST requisicao WHERE requisicao.nr-requisicao = RowObject.nr-requisicao) THEN DO:
            {utp/ut-liter.i "Nï¿½mero da Requisiï¿½ï¿½o"}
            {method/svc/errors/inserr.i
                       &ErrorNumber="2"
                       &ErrorType="EMS"
                       &ErrorSubType="ERROR" 
                       &ErrorParameters="return-value"} 
                       RETURN "NOK":U.
        END.
        
        
        IF AVAIL ITEM AND
           ITEM.tipo-con-est = 4 THEN DO:
              IF RowObject.cod-refer = "" THEN DO:
                  {method/svc/errors/inserr.i
                       &ErrorNumber="1399"
                       &ErrorType="EMS"
                       &ErrorSubType="ERROR" 
                       &ErrorParameters=" "} 
              END.
              ELSE
                   IF NOT CAN-FIND(FIRST ref-item WHERE
                                   ref-item.cod-refer = RowObject.cod-refer AND
                                   ref-item.it-codigo = RowObject.it-codigo) THEN DO:
        
                       {method/svc/errors/inserr.i
                           &ErrorNumber="1736"
                           &ErrorType="EMS"
                           &ErrorSubType="ERROR" 
                           &ErrorParameters="RowObject.cod-refer + '~~~~' + RowObject.it-codigo"}
                   END.
        
        END.
        ELSE 
            ASSIGN RowObject.cod-refer = "".
        
        IF NOT AVAIL ITEM THEN DO:
            {utp/ut-table.i mgind ITEM 1}
            {method/svc/errors/inserr.i
                   &ErrorNumber="56"
                   &ErrorType="EMS"
                   &ErrorSubType="ERROR" 
                   &ErrorParameters= "RETURN-VALUE + ' ' + RowObject.it-codigo"}
              RETURN "NOK":U.                 
        END.
        ELSE DO:
            ASSIGN i-tp-ressup = 1.
            IF AVAIL requisicao 
               AND AVAIL ITEM
               AND requisicao.tp-requis > 1 
               AND item.tipo-contr     <> 4 THEN 
        
                  RUN cdp/cd1406a2.p (item.it-codigo,
                             requisicao.cod-estabel,
                             OUTPUT i-tp-ressup).
        
            IF AVAIL item-uni-estab AND 
               AVAIL requisicao THEN DO:
                IF requisicao.tp-requis = 2 OR requisicao.tp-requis = 3 THEN DO:
                    IF  item-uni-estab.cod-obsoleto = 2 OR
                        item-uni-estab.cod-obsoleto = 3 OR 
                        item-uni-estab.cod-obsoleto = 4 THEN DO: 
        
                        {method/svc/errors/inserr.i
                           &ErrorNumber="1885"
                           &ErrorType="EMS"
                           &ErrorSubType="ERROR" 
                           &ErrorParameters=" "}
                    END.
                END.
                ELSE DO:
                   IF AVAIL item-uni-estab THEN DO:
                       IF item-uni-estab.cod-obsoleto = 4 THEN DO:
        
                           {method/svc/errors/inserr.i
                               &ErrorNumber="1885"
                               &ErrorType="EMS"
                               &ErrorSubType="ERROR" 
                               &ErrorParameters=" "}
                       END.
                   END.
                END.
            END.
            ELSE DO:
                 /***************************************************************
                 ** Item nao esta relecionado ao estabelecimento da requisicao **
                 ***************************************************************/
              /*  {method/svc/errors/inserr.i
                       &ErrorNumber="25904"
                       &ErrorType="EMS"
                       &ErrorSubType="ERROR" 
                       &ErrorParameters="string(item.it-codigo) + '~~~~' +
                                         string(requisicao.cod-estabel)"}*/
            END.
            IF AVAIL requisicao
            AND AVAIL ITEM THEN DO:
                IF item.tipo-contr      = 4 AND
                   requisicao.tp-requis = 1 THEN DO:
                    {method/svc/errors/inserr.i
                           &ErrorNumber="1569"
                           &ErrorType="EMS"
                           &ErrorSubType="ERROR" 
                           &ErrorParameters=" "}  
                END.
                
                IF param-global.modulo-cc THEN DO:
                   IF param-compra.int-2 = 1 THEN DO:         
                       IF requisicao.tp-requis <> 1 THEN 
                           IF item-uni-estab.cod-grp-compra = "" THEN DO:
                               {method/svc/errors/inserr.i
                                    &ErrorNumber="16419"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR" 
                                    &ErrorParameters=" "}  
                           END.
                   END.
                   IF param-compra.int-2 = 2 THEN DO:  
                        IF requisicao.tp-requis <> 1 THEN DO:    
                            FIND comprador WHERE 
                               comprador.cod-comprado = item-uni-estab.cod-comprado NO-LOCK NO-ERROR.
                            IF NOT AVAIL comprador THEN DO:
                               {method/svc/errors/inserr.i
                                    &ErrorNumber="15712"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR" 
                                    &ErrorParameters=" "}      
                            END.
                        END.
                   END.
                END.
                
                IF ITEM.tipo-con-est <> 2 AND
                   (pType = "CREATE":U OR (pType <> "CREATE":U AND requisicao.tp-requis <> 1)) THEN DO:
                     IF RowObject.qt-a-atender = 0 THEN DO:
                         {method/svc/errors/inserr.i
                                &ErrorNumber="1570"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" 
                                &ErrorParameters=" "}  
                     END.
                END.
            END.
        END.
        IF AVAIL ITEM THEN DO:
            IF ((item.tipo-contr = 4 OR 
                item.tipo-contr = 1) AND 
                AVAIL requisicao AND
                requisicao.tp-requis = 2) AND
                RowObject.preco-unit = 0 THEN DO:
                {method/svc/errors/inserr.i
                        &ErrorNumber="1573"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR" 
                        &ErrorParameters=" "}
            END.
            IF RowObject.qt-a-atender <> 0 THEN DO:
                IF NOT(item.fraciona) AND
                    (RowObject.qt-a-atender / round(RowObject.qt-a-atender,0) ) <> 1 THEN DO:
                    {method/svc/errors/inserr.i
                        &ErrorNumber="847"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR" 
                        &ErrorParameters=" "}
                END.
            END.
            IF RowObject.it-codigo = ?  OR
               RowObject.it-codigo = "" OR 
               item.tipo-contr = 4 THEN DO:
                FIND FIRST tab-unidade
                    WHERE  tab-unidade.un = RowObject.un no-lock no-error.
                 IF NOT AVAIL tab-unidade THEN DO:
                     {utp/ut-table.i mgind tab-unidade 1}
                     {method/svc/errors/inserr.i
                         &ErrorNumber="56"
                         &ErrorType="EMS"
                         &ErrorSubType="ERROR" 
                         &ErrorParameters="return-value"}
                 END.
                 FIND FIRST item-fornec 
                     WHERE item-fornec.ativo 
                       AND item-fornec.it-codigo = item.it-codigo NO-LOCK NO-ERROR.
                 IF AVAIL item-fornec THEN DO:
                     IF RowObject.un <> item.un THEN DO:
                         {method/svc/errors/inserr.i
                             &ErrorNumber="1571"
                             &ErrorType="EMS"
                             &ErrorSubType="ERROR" 
                             &ErrorParameters=" "}
                     END.
                 END.
            END.
            ELSE DO:
                 IF RowObject.un <> item.un THEN DO:
                     {method/svc/errors/inserr.i
                         &ErrorNumber="1571"
                         &ErrorType="EMS"
                         &ErrorSubType="ERROR" 
                         &ErrorParameters=" "}
                 END.
            END.
            IF  item.tipo-contr = 4  and
                item.it-codigo  = "" and
                RowObject.narrativa = " " THEN DO:
                {method/svc/errors/inserr.i
                     &ErrorNumber="1572"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR" 
                     &ErrorParameters=" "}
            END.
        END.
        IF RowObject.num-ord-inv <> 0 AND
           param-global.modulo-in THEN DO:
             run inp/in2201.p (input  estabelec.ep-codigo,
                               input  RowObject.num-ord-inv,
                               input  no,
                               output l-achou,
                               output c-ct-codigo,
                               output c-sc-codigo).
              IF RETURN-VALUE = "NOK":U THEN  DO:
                  {utp/ut-liter.i "Em Investimentos"}
                  {method/svc/errors/inserr.i
                     &ErrorNumber="15239"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR" 
                     &ErrorParameters="return-value"}
              END.
              IF l-achou = NO THEN DO:
                  /* Ordem de Investimento nï¿½o cadastrado */
                  {utp/ut-table.i mginv ordem-inv 1}
                  {method/svc/errors/inserr.i
                     &ErrorNumber="56"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR" 
                     &ErrorParameters="return-value"}
              END.
        END.
        
        if avail item-uni-estab and not item-uni-estab.altera-conta then do:

            find first estabelec no-lock 
                 where estabelec.cod-estabel = RowObject.cod-estabel no-error.
            assign i-empresa = estabelec.ep-codigo when avail estabelec.

            assign c-ct-codigo = RowObject.ct-codigo.
            run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
            run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,                  /* EMPRESA EMS2 */
                                                           input        "",                         /* PLANO DE CONTAS */
                                                           input-output c-ct-codigo,                /* CONTA */
                                                           input        RowObject.dt-entrega,       /* DATA TRANSACAO */
                                                           output       v_des_cta_ctbl,             /* DESCRICAO CONTA */
                                                           output       v_num_tip_cta_ctbl,         /* TIPO DA CONTA */
                                                           output       v_num_sit_cta_ctbl,         /* SITUAï¿½ï¿½O DA CONTA */
                                                           output       v_ind_finalid_cta,          /* FINALIDADES DA CONTA */
                                                           output table tt_log_erro).               /* ERROS */        
            if valid-handle(h_api_cta_ctbl) then
                delete object h_api_cta_ctbl.

            
            for first tt_log_erro:
                {method/svc/errors/inserr.i &ErrorNumber="17006"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="STRING(tt_log_erro.ttv_des_msg_erro)"}
                return "NOK".
            end.

            IF ((int(v_num_tip_cta_ctbl) <> 1 AND
                 int(v_num_tip_cta_ctbl) <> 2 AND
                 int(v_num_tip_cta_ctbl) <> 4 AND
                 int(v_num_tip_cta_ctbl) <> 5) OR
                 int(v_num_sit_cta_ctbl) <> 3) THEN DO:
                /* Conta deve ser de Despesa, Passivo ou Ativo, e de Sistema */
                {method/svc/errors/inserr.i
                        &ErrorNumber="1576"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR" 
                        &ErrorParameters=" "}
            END.

            /* Verifica Estoque */
            assign ind       = 1
                   i-estoque = 0.
            do while ind <= 10:
                assign v_cod_finalid = {adinc/i05ad049.i 4 ind}.

                if lookup(v_cod_finalid, v_ind_finalid_cta) > 0 then do:
                    assign i-estoque = ind.
                    leave.
                end.

                assign ind = ind + 1.
            end.

            IF (i-estoque  = 0 OR  
               (i-estoque <> 1 AND  
                i-estoque <> 2 AND  
                i-estoque <> 3 AND  
                i-estoque <> 5 AND  
                i-estoque <> 6)) THEN DO:
                /* Conta contabil nao aceita movimento */
                {method/svc/errors/inserr.i
                        &ErrorNumber="1577"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR" 
                        &ErrorParameters=" "}
            END.
        END.

        /* Valida Centro de Custo - CE0101 */
        IF AVAIL item-uni-estab AND AVAIL requisicao AND NOT item-uni-estab.altera-conta AND SUBSTR(param-estoq.char-1,3,1) = "Y" AND RowObject.sc-codigo <> "":U THEN DO:
            FIND FIRST usuar-ccusto NO-LOCK 
                 WHERE usuar-ccusto.sc-codigo   = RowObject.sc-codigo 
                   AND usuar-ccusto.cod-usuario = requisicao.nome-abrev NO-ERROR.
            IF NOT AVAIL usuar-ccusto THEN DO:
                {method/svc/errors/inserr.i
                        &ErrorNumber="16040"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR" 
                        &ErrorParameters=" "}
            END.
        END.
        IF AVAIL usuar-mater AND substring(usuar-mater.char-1,1,1) = "y" AND (RowObject.num-ord-inv = 0 OR NOT param-global.modulo-in) THEN DO: 
            IF substring(RowObject.char-2,1,12) = "" THEN DO:
                FOR FIRST  utiliz-natu-despes
                    FIELDS (cod-utiliz)
                    WHERE  utiliz-natu-despes.cod-nat-despesa = item-uni-estab.nat-despesa NO-LOCK:
                    ASSIGN OVERLAY(rowObject.char-2,01,12) = STRING(utiliz-natu-despes.cod-utiliz).
                END.
            END.
            FIND FIRST utilizacao-mater NO-LOCK 
                 WHERE utilizacao-mater.cod-utiliz = substring(RowObject.char-2,1,12) NO-ERROR.
            IF NOT AVAIL utilizacao-mater THEN DO:
                {utp/ut-table.i mgind utilizacao-mater 1}
                {method/svc/errors/inserr.i
                    &ErrorNumber="56"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR" 
                    &ErrorParameters="return-value"}
            END.
            IF AVAIL item-uni-estab THEN DO:
                /*it-requisicao.char-2,1,12*/
                FOR FIRST utiliz-natu-despes 
                   FIELDS (cod-nat-despesa ct-codigo cod-utiliz) 
                    WHERE utiliz-natu-despes.cod-nat-despesa = item-uni-estab.nat-despesa
                      AND utiliz-natu-despes.cod-utiliz = substring(RowObject.char-2,1,12) NO-LOCK: END.
                IF NOT AVAIL utiliz-natu-despes THEN DO:
                    {method/svc/errors/inserr.i
                        &ErrorNumber="16848"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR" 
                        &ErrorParameters="string(item-uni-estab.nat-despesa) + '~~~~' +
                                                 substring(RowObject.char-2,1,12)"}
                END.
            END.
        END.
        IF RowObject.dt-entrega < TODAY THEN DO:
             /* Inicio -- Projeto Internacional */
             DEFINE VARIABLE c-lbl-liter-de-entrega AS CHARACTER NO-UNDO.
             {utp/ut-liter.i "de_entrega" *}
             ASSIGN c-lbl-liter-de-entrega = TRIM(RETURN-VALUE).
             {method/svc/errors/inserr.i
                    &ErrorNumber="16935"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR" 
                    &ErrorParameters="c-lbl-liter-de-entrega"}
        END.
        assign i-tipo-trans = if c-param = "add" 
                           then 1 
                           else 2.
        
        IF AVAIL requisicao
        AND requisicao.tp-requis = 1    /*Se for Requisicao e Aprova Requisicao*/
        AND SUBSTR(param-estoq.char-1,4,1) = "Y"
        AND param-compra.log-1  THEN
            ASSIGN i-tipo-doc = 2. 
        ELSE IF AVAIL requisicao
             AND requisicao.tp-requis = 2 /*Senï¿½o, Se for Solicitaï¿½ï¿½o e utiliza aprovaï¿½ï¿½o eletrï¿½nica*/
             AND param-compra.log-1 THEN
            ASSIGN i-tipo-doc = 1.
        
        IF  i-tipo-doc > 0 THEN DO:
            run cdp/cdapi173.p (input  i-tipo-doc,
                                input  RowObject.it-codigo,
                                input  requisicao.nome-abrev,
                                output l-retorno-aprova).
             IF NOT l-retorno-aprova THEN DO:
                 {method/svc/errors/inserr.i
                        &ErrorNumber="15661"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR" 
                        &ErrorParameters=" "}
             END.
        END.

        &IF DEFINED(bf_mat_conta_contab_inp) &THEN
             IF (RowObject.ct-codigo + RowObject.sc-codigo) <> "" AND AVAIL requisicao THEN DO:
                 {inp/inapi060.i requisicao.cod-estabel RowObject.ct-codigo RowObject.sc-codigo rowObject.num-ord-inv NO tt-erro-invest}
                 IF  RETURN-VALUE = "NOK":U THEN DO:
                     FOR EACH tt-erro-invest:
                         {method/svc/errors/inserr.i
                                         &ErrorNumber="tt-erro-invest.cd-erro"
                                         &ErrorType="EMS"
                                         &ErrorSubType="ERROR" 
                                         &ErrorParameters="tt-erro-invest.c-param"}
                         DELETE tt-erro-invest.
                     END.
                 END.
             END.
        &ENDIF
        
        &if  "{&mgadm_version}" >= "2.04" &then
           IF pType = "UPDATE":U AND AVAIL requisicao AND requisicao.tp-requis <> 3 THEN DO:
               run cdp/cdapi198.p(input RowObject.r-rowid,  /*rowid requisicao*/
                                  input 1,
                                  input no,
                                  input-output table tt_xml_input_1).   /*registro alterado*/ 
           END.
        &endif
                
        RUN pi-unidade-negocio(INPUT pType).
        
        if  AVAIL requisicao AND requisicao.tp-requis = 1    /*Se for Requisicao e Aprova Requisicao*/
        and substr(param-estoq.char-1,4,1) = "Y"
        and param-compra.log-1  then
            assign i-tipo-doc = 2.
        else if  AVAIL requisicao AND requisicao.tp-requis = 2 /*Senï¿½o, Se for Solicitaï¿½ï¿½o e utiliza aprovaï¿½ï¿½o eletrï¿½nica*/
             and param-compra.log-1 then
        assign i-tipo-doc = 1.
        
        IF CAN-FIND(funcao WHERE
           funcao.cd-funcao = "Integra_AED_EMS" AND
           funcao.ativo     = YES) THEN DO:
           IF i-tipo-doc > 0 THEN DO:
               ASSIGN de-valor-item = RowObject.preco-unit * RowObject.qt-a-atender
                      de-valor-total = de-valor-item.
        
               IF AVAIL requisicao THEN DO:
                   FOR EACH b-it-requisicao WHERE 
                            b-it-requisicao.nr-requisicao = requisicao.nr-requisicao NO-LOCK:
                       ASSIGN de-valor-total = de-valor-total + b-it-requisicao.val-item .
                   END. 
                   run aedp/aedapi173.p  (input  i-tipo-doc,
                                          input  RowObject.it-codigo,
                                          input  requisicao.nome-abrev,
                                          input  RowObject.ct-codigo,
                                          input  requisicao.cod-estabel,
                                          input  RowObject.sc-codigo,
                                          input  de-valor-item,
                                          input  de-valor-total,
                                          input  requisicao.cod-estabel,  
                                          output table tt-erro-aed).
                   IF RETURN-VALUE = "nok":U THEN DO:
                       FOR EACH tt-erro-aed:
                           {method/svc/errors/inserr.i
                                   &ErrorNumber="tt-erro-aed.cd-erro"
                                   &ErrorType="EMS"
                                   &ErrorSubType="ERROR"
                                   &ErrorParameters=" "}
                       END.
                   END.
               END.
           END.
        END.

        RUN lap/mlaapi099.p (INPUT i-tipo-doc).

        IF CAN-FIND(funcao WHERE
           funcao.cd-funcao = "Integra_MLA_EMS" AND
           funcao.ativo     = YES) AND RETURN-VALUE <> "NOK":U THEN DO:
           IF i-tipo-doc > 0 THEN DO:
               ASSIGN de-valor-item = RowObject.preco-unit * RowObject.qt-a-atender
                      de-valor-total = de-valor-item.
        
               FOR EACH b-it-requisicao WHERE 
                        b-it-requisicao.nr-requisicao = requisicao.nr-requisicao NO-LOCK:
                   ASSIGN de-valor-total = de-valor-total + b-it-requisicao.val-item .
               END. 
               run lap/mlaapi173.p (input  i-tipo-doc,
                                    input  RowObject.it-codigo,
                                    input  requisicao.nome-abrev,
                                    input  RowObject.ct-codigo,
                                    input  requisicao.cod-estabel,
                                    input  RowObject.sc-codigo,
                                    input  de-valor-item,
                                    input  de-valor-total,
                                    input  requisicao.cod-estabel,  
                                    output table tt-erro-aed).
               IF RETURN-VALUE = "nok":U THEN DO:
                   FOR EACH tt-erro-aed:
                       {method/svc/errors/inserr.i
                               &ErrorNumber="tt-erro-aed.cd-erro"
                               &ErrorType="EMS"
                               &ErrorSubType="ERROR"
                               &ErrorParameters=" "}
                   END.
               END.
           END.
        END.
        IF AVAIL ITEM AND
           item.tipo-con-est = 2 AND
          RowObject.qt-a-atender > 1 THEN DO:
            {method/svc/errors/inserr.i
                   &ErrorNumber="35095"
                   &ErrorType="EMS"
                   &ErrorSubType="ERROR"
                   &ErrorParameters="RowObject.it-codigo"}
                   
        END.
        IF AVAIL ITEM THEN DO:
            IF (pType = "CREATE":U        or 
               RowObject.num-ord-inv = 0 or
               RowObject.preco-unit  = 0) AND
                AVAIL usuar-mater then do:
                if NOT( item.tipo-contr <> 4 
                OR  (item.it-codigo  <> " " 
                AND  item.it-codigo  <> ?)) then do:
                    if NOT ((usuar-mater.tp-preco = 2 
                    and item.tipo-contr <> 4)
                    or  item.tipo-contr = 4)  then do:
                        IF NOT ((usuar-mater.tp-preco = 3 
                        AND item.tipo-contr <> 4)
                        OR  item.tipo-contr  = 4) then do:
                            if NOT ((usuar-mater.tp-preco = 4
                               and item.tipo-contr      <> 4)
                               or  item.tipo-contr       = 4)then do:
                                {method/svc/errors/inserr.i
                                       &ErrorNumber="1627"
                                       &ErrorType="EMS"
                                       &ErrorSubType="ERROR"
                                       &ErrorParameters=" "}
                            END.
                        END.
                    END.
                END.
            END.
        END.
        RUN btb/btb009za.p PERSISTENT SET h-btb009za.
        &IF '{&bf_mat_versao_ems}' < '2.062' &THEN
           if pType = "CREATE":U and requisicao.tp-requis <> 1 then do:

                  find first estabelec no-lock 
                       where estabelec.cod-estabel = requisicao.cod-estabel no-error.
                  assign i-empresa = estabelec.ep-codigo when avail estabelec.
            
                  run pi-conecta-ems5 (input  yes,      /* Connect */
                                       input  param-global.empresa-prin,
                                       output l-retorno).
                  if l-retorno then return.
        
                  run cdp/cd9760.p (input 2, /* tipo requisiï¿½ï¿½o */
                                    input RowObject.it-codigo,
                                    input RowObject.r-rowid).  
        
                  assign de-tot-unid = 0.
        
                  if  not param-mat.pede-unid-neg-cc then 
                      for each unid-neg-requis
                      where unid-neg-requis.nr-requisicao = RowObject.nr-requisicao
                      and unid-neg-requis.sequencia     = RowObject.sequencia
                      and unid-neg-requis.it-codigo     = RowObject.it-codigo NO-LOCK:
                      assign de-tot-unid = de-tot-unid + unid-neg-requis.perc-unid-neg.
                  end.
                 
                  run pi-conecta-ems5 (input  no, /* Disconnect */
                                       input  param-global.empresa-prin,
                                       output l-retorno).
           END.
        &endif
        IF VALID-HANDLE(h-btb009za) THEN
          DELETE PROCEDURE h-btb009za.
        
        &if '{&bf_mat_versao_ems}' >= '2.062' &then
          IF RowObject.num-ord-inv <> 0 
              AND param-global.modulo-in THEN DO:
              FOR EACH tt-matriz:
                  FIND FIRST unid-neg-requis EXCLUSIVE-LOCK
                       WHERE unid-neg-requis.nr-requisicao  = RowObject.nr-requisicao
                         AND unid-neg-requis.it-codigo      = RowObject.it-codigo
                         AND unid-neg-requis.sequencia      = RowObject.sequencia
                         AND unid-neg-requis.cod_unid_negoc = tt-matriz.cod-unid-neg NO-ERROR.
                  IF  NOT AVAIL unid-neg-requis THEN DO:
                      CREATE unid-neg-requis.
                      ASSIGN unid-neg-requis.nr-requisicao  = RowObject.nr-requisicao
                             unid-neg-requis.it-codigo      = RowObject.it-codigo
                             unid-neg-requis.sequencia      = RowObject.sequencia
                             unid-neg-requis.cod_unid_negoc = tt-matriz.cod-unid-neg.
                  END.
                  ASSIGN unid-neg-requis.perc-unid-neg = tt-matriz.perc-rateio.
              END.
          END.
        &endif
        
        IF  RowObject.num-ord-inv <> 0 and
            RowObject.num-ord-inv <> ? and
            requisicao.situacao = 3 and 
            param-global.modulo-in = yes then do:
            assign requisicao.situacao = 1.           
            for each RowObject 
                where RowObject.nr-requisicao = requisicao.nr-requisicao 
                and RowObject.situacao = 3 exclusive-lock:
                assign RowObject.situacao = 1.
            END.
        END.
        &if  "{&mgadm_version}" >= "2.04" &then
          if  requisicao.tp-requis <> 3 then do: /* Solicitaï¿½ï¿½o Cotaï¿½ï¿½o */
              /*API de Execuï¿½ï¿½o Orï¿½amentï¿½ria*/
              run cdp/cdapi198.p (input RowObject.r-rowid, /*rowid it-requisicao*/
                                  input 2,
                                  input yes,
                                  input-output table tt_xml_input_1).  /*botï¿½o ok*/
              IF RETURN-VALUE = "NOK":U THEN DO:
                  {utp/ut-liter.i "Em Execuï¿½ï¿½o Orï¿½amentï¿½ria"}
                  {method/svc/errors/inserr.i
                         &ErrorNumber="15239"
                         &ErrorType="EMS"
                         &ErrorSubType="ERROR" 
                         &ErrorParameters="return-value"}
              END.
          END.
        &endif
         /********************************/
    END. /** CREATE and UPDATE **/
    
    RUN atribuiPrecoDebitoNaoDireto.
    assign RowObject.val-item = RowObject.qt-a-atender * de-preco-u
           RowObject.preco-unit = de-preco-u.
    
    IF l-classif-item THEN
        ASSIGN rowObject.sc-codigo = ""
               rowObject.ct-codigo = "".
               
END PROCEDURE.
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-invest V-table-Win 
PROCEDURE pi-invest:
  DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

  /********* INVESTIMENTOS ********/
  if connected("mginv")     and
     param-global.modulo-in and 
     RowObject.num-ord-inv <> 0
      AND param-global.modulo-in then do:   
     if pType = "CREATE":U  then   
           run inp/in2101.p(input rowid(requisicao), input RowObject.r-rowid , "Inclui":U).
     else if  pType <> "CREATE":U  then   
           run inp/in2101.p(input rowid(requisicao), input RowObject.r-rowid , "Modifica":U).
     IF RETURN-VALUE = "NOK":U THEN DO:
         {utp/ut-liter.i "Em Investimentos"}
         {method/svc/errors/inserr.i
            &ErrorNumber="15239"
            &ErrorType="EMS"
            &ErrorSubType="ERROR" 
            &ErrorParameters="return-value"}
     END.
  end.

END PROCEDURE.
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-sugere-ct-contabil V-table-Win 
PROCEDURE pi-sugere-ct-contabil:
    
  
  DEFINE INPUT PARAM it-codigo   AS CHAR  NO-UNDO.
  DEFINE INPUT PARAM nome-abrev  AS CHAR  NO-UNDO.
  DEFINE INPUT PARAM cod-estabel AS CHAR  NO-UNDO.
  DEFINE INPUT PARAM num-ord-inv AS INT   NO-UNDO.
  DEFINE OUTPUT PARAM ct-codigo  AS CHAR  NO-UNDO.


  DEFINE VARIABLE i-nat-desp AS INTEGER     NO-UNDO.
  DEFINE VARIABLE l-classif  AS LOGICAL     NO-UNDO.
  
  IF num-ord-inv = ? THEN
      ASSIGN num-ord-inv = 0.
  
 
  find param-mat no-lock no-error.
  if not avail usuar-mater then
          find usuar-mater where usuar-mater.cod-usuario = nome-abrev no-lock no-error.    
   FIND FIRST ITEM
        WHERE ITEM.it-codigo = it-codigo NO-LOCK NO-ERROR. 
   IF AVAIL ITEM THEN DO:
       
      
      /* Verifica se o item/familia possui classificacao contabil (CD0250/CD0251) */
      for first item-uni-estab fields(it-codigo cod-estabel nat-despesa altera-conta res-int-comp res-for-comp prioridade-aprov) where
                item-uni-estab.it-codigo   = item.it-codigo and
                item-uni-estab.cod-estabel = cod-estabel no-lock: end.
      if avail item-uni-estab then do:
          
         assign i-nat-desp = item-uni-estab.nat-despesa
                l-classif  = item-uni-estab.altera-conta.
        
      end.
      
      IF NOT l-classif THEN DO:
          for first natureza-despesa fields (nat-despesa ct-codigo) where
                    natureza-despesa.nat-despesa = i-nat-desp
                    no-lock: end.
          
          if avail natureza-despesa and num-ord-inv = 0 then do:
             if substring(usuar-mater.char-1,1,1) = "y" then do:  /**** Utilizacao de Material ******/
                  for first utiliz-natu-despes fields (cod-nat-despesa ct-codigo cod-utiliz) where
                      utiliz-natu-despes.cod-nat-despesa = natureza-despesa.nat-despesa
                      no-lock: end.
                  if avail utiliz-natu-despes then do:
                      for first utilizacao-mater fields (cod-utiliz des-utiliz) where
                          utilizacao-mater.cod-utiliz = utiliz-natu-despes.cod-utiliz
                          no-lock: end.
                       
                      assign ct-codigo = utiliz-natu-despes.ct-codigo.
                  end.
              end.
              else 
                  assign ct-codigo = natureza-despesa.ct-codigo.
              
          end.
      end.      
   END.
END PROCEDURE.
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-aprovacao-eletronica V-table-Win 
PROCEDURE pi-aprovacao-eletronica:
    
    DEF INPUT PARAMETER r-it-requis AS ROWID NO-UNDO.
    DEF VAR l-aprov-item AS LOGICAL NO-UNDO.

    

    find b-it-requisicao where rowid(it-requisicao) = r-it-requis 
                exclusive-lock no-error.

    
    if  i-tipo-doc > 0 then do:
        if (i-tipo-doc = 1 and substring(param-compra.char-2, 1, 3) = "nao":U)
        or (i-tipo-doc = 2 and substring(param-compra.char-2, 4, 3) = "nao":U)
        or  i-tipo-doc > 2 THEN DO:
            /*run cdp/cdapi171.p (i-tipo-doc, i-tipo-trans, rowid(it-requisicao)).*/
            run cdp/cdapi171.p (i-tipo-doc, i-tipo-trans, r-it-requis).
            ASSIGN l-aprov-item = YES.
        END.
    end.
    
    IF AVAIL b-it-requisicao THEN DO:
    
        assign requisicao.estado = 1
               requisicao.nome-aprov = requisicao.nome-abrev.
    
        /**  Melhorias
        **/
        assign b-it-requisicao.estado = 1
               b-it-requisicao.nome-aprov = requisicao.nome-abrev.
    
        if  i-tipo-doc > 0 then do:
            assign l-pendente = no.
            run cdp/cdapi172.p (i-tipo-doc,rowid(b-it-requisicao), output l-pendente).
            
            if  l-pendente then do:
                assign requisicao.estado = 2
                       requisicao.nome-aprov = "":U.
    
                /**  Melhorias
                **/
                assign b-it-requisicao.estado = 2
                       b-it-requisicao.nome-aprov = "":U.
            end.                   
            else do:
                if  can-find (first b-it-requisicao where 
                    b-it-requisicao.nr-requisicao = b-it-requisicao.nr-requisicao and
                    b-it-requisicao.estado = 2 ) then
                    assign requisicao.estado = 2 
                           requisicao.nome-aprov = "":U.
            end.
        end.
    END.

    IF l-aprov-item THEN
        RUN mensagemAprovacaoItemRequisicao.

END PROCEDURE.
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-aprovacao-eletronica V-table-Win 
PROCEDURE pi-aprovacao-eletronica-total:
    
    DEF INPUT PARAMETER r-it-requis AS ROWID NO-UNDO.
    DEF VAR i-tipo-doc-aux AS INTEGER NO-UNDO.
    DEF VAR l-pendente-aux AS LOGICAL NO-UNDO.

    find first param-compra no-lock no-error.
    find first param-estoq no-lock no-error.
    find it-requisicao where rowid(it-requisicao) = r-it-requis no-lock no-error.
    if  avail it-requisicao then 
    find requisicao where requisicao.nr-requisicao = it-requisicao.nr-requisicao no-lock no-error.

    if  avail requisicao then do:
        if requisicao.tp-requis = 1 and
           substr(param-estoq.char-1,4,1) = "Y" then
           assign i-tipo-doc-aux = 2.
        else if requisicao.tp-requis = 2 then 
            assign i-tipo-doc-aux = 1.
        else 
            assign i-tipo-doc-aux = 3.
    end.
    
   
    if  param-compra.log-1 and avail requisicao and avail it-requisicao then do:       
        if i-tipo-doc-aux < 3 then do:    
           if ((i-tipo-doc-aux = 1 and substring(param-compra.char-2, 1, 3) = "sim":U) or 
               (i-tipo-doc-aux = 2 and substring(param-compra.char-2, 4, 3) = "sim":U))
           then do:
               
               run cdp/cdapi171.p (i-tipo-doc-aux, 2, rowid(it-requisicao)).

               find current requisicao exclusive-lock no-error.
               find current it-requisicao exclusive-lock no-error.

               assign requisicao.estado = 1
                      requisicao.nome-aprov = requisicao.nome-abrev.

               /**  Melhorias
               **/
               &if defined(bf_mat_aprova_eletronica) &then

                   assign it-requisicao.estado = 1
                          it-requisicao.nome-aprov = requisicao.nome-abrev.
                   /* Reabre outras parcelas */
                   for each b-it-requisicao 
                      where b-it-requisicao.nr-requisicao = requisicao.nr-requisicao                            
                        and b-it-requisicao.sequencia <> it-requisicao.sequencia
                        and (b-it-requisicao.situacao = 1 or b-it-requisicao.situacao = 3)EXCLUSIVE-LOCK:                            
                        assign b-it-requisicao.estado = 1
                               b-it-requisicao.nome-aprov = requisicao.nome-abrev.    
                   end.                   
               &endif

               if  i-tipo-doc-aux > 0 then do:
                   assign l-pendente-aux = no.
                   run cdp/cdapi172.p (i-tipo-doc-aux,rowid(it-requisicao), output l-pendente-aux).
                   if  l-pendente-aux then do:
                       assign requisicao.estado = 2
                              requisicao.nome-aprov = "":U.                              
                       /**  Melhorias
                       **/                       
                       &if defined(bf_mat_aprova_eletronica) &then
                       assign it-requisicao.estado = 2
                              it-requisicao.nome-aprov = "":U.
                       /* Reabre outras parcelas */
                       for each b-it-requisicao 
                          where b-it-requisicao.nr-requisicao = requisicao.nr-requisicao                            
                            and b-it-requisicao.sequencia <> it-requisicao.sequencia
                            and (b-it-requisicao.situacao = 1 or b-it-requisicao.situacao = 3) EXCLUSIVE-LOCK:                            
                            assign b-it-requisicao.estado = 2
                                   b-it-requisicao.nome-aprov = "":U.    
                       end.
                       &endif
                   end.                   
               end.

               find current requisicao no-lock no-error.
               find current it-requisicao no-lock no-error.

               run mensagemAprovacaoItemRequisicao.
           end.
        end.   
    end.

END PROCEDURE.
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-unidade-negocio V-table-Win 
PROCEDURE pi-unidade-negocio:
    DEFINE INPUT PARAMETER pType AS CHAR NO-UNDO.
    DEF VAR h-cdapi024 AS HANDLE NO-UNDO.
    DEF VAR h-boiv029  AS HANDLE NO-UNDO.
    DEFINE VARIABLE l-unid-neg       AS LOGICAL     NO-UNDO.

    &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
    
        
        IF NOT CAN-FIND(FIRST tt-matriz) AND l-unidade-negocio AND l-mat-unid-negoc THEN DO:
    
            
            run cdp/cdapi024.p PERSISTENT set h-cdapi024.
        
            FIND requisicao
                WHERE requisicao.nr-requisicao = rowObject.nr-requisicao NO-LOCK NO-ERROR.
        
            /*UNIDADE DE NEGï¿½CIO - 206B*/
            
              /* "Requisiï¿½ï¿½o  Estoque" + "Funï¿½ï¿½o EMS2-UNIDADE-NEGOCIO"
                 "Solicitaï¿½ï¿½o Compras/Cotaï¿½ï¿½o" + "Usa Unidade de Negï¿½cio" (Parï¿½metros de materias) */
                
                
                if  rowObject.cod-unid-negoc = ""
                    and ((requisicao.tp-requis  = 1 and l-unidade-negocio)
                    or (requisicao.tp-requis  = 2 or requisicao.tp-requis = 3) and l-mat-unid-negoc) then do:
                    
                    if valid-handle(h-cdapi024) then 
                        run RetornaUnidadeNegocioExternaliz in h-cdapi024 (input rowObject.cod-estabel,
                                                                           input rowObject.it-codigo,
                                                                           input "", /*Depï¿½sito*/
                                                                           output rowObject.cod-unid-negoc).
                    
                end.
           
          
            
                /* "Requisiï¿½ï¿½o  Estoque" + "Funï¿½ï¿½o EMS2-UNIDADE-NEGOCIO"
                   "Solicitaï¿½ï¿½o Compras/Cotaï¿½ï¿½o" + "Usa Unidade de Negï¿½cio" (Parï¿½metros de materias) */
                
                IF  rowObject.num-ord-inv <> 0 
                    AND param-global.modulo-in THEN DO:
                    ASSIGN rowObject.cod-unid-negoc = "".
                    assign iEmpresa = param-global.empresa-prin.
                    IF NOT AVAIL estabelec 
                    OR (AVAIL estabelec AND estabelec.cod-estabel <> rowObject.cod-estabel) THEN
                        FIND FIRST estabelec WHERE 
                             estabelec.cod-estabel = rowObject.cod-estabel NO-LOCK NO-ERROR.
                    &IF "{&mguni_version}" >= "2.071" &THEN
                    if AVAIL estabelec AND estabelec.ep-codigo <> "" then 
                    &ELSE
                    if AVAIL estabelec AND estabelec.ep-codigo <> 0 then 
                    &ENDIF
                        ASSIGN iEmpresa = estabelec.ep-codigo.
        
                    RUN ivbo/boiv029.p PERSISTENT SET h-boiv029.
                    RUN recebeEmpresa IN h-boiv029 (INPUT iempresa).
                    RUN retornaMatrizUnidNegoc IN h-boiv029 (INPUT  rowObject.num-ord-inv,
                                                             OUTPUT TABLE tt-matriz,
                                                             OUTPUT TABLE tt-erro-aux).
                    DELETE PROCEDURE h-boiv029.
                    
                    FIND FIRST tt-erro-aux NO-LOCK NO-ERROR.
                    IF  AVAIL tt-erro-aux THEN DO:
                        /*RUN cdp/cd0666.w (INPUT TABLE tt-erro-aux). /* transformar em erro da bo */*/
                         {method/svc/errors/inserr.i
                                       &ErrorNumber="tt-erro-aux.cd-erro"
                                       &ErrorType="EMS"
                                       &ErrorSubType="ERROR"
                                       &ErrorParameters="RowObject.ct-codigo + RowObject.sc-codigo"}
                         
                    END. 
                END.
                ELSE DO:
                    if (requisicao.tp-requis      = 1 and l-unidade-negocio)
                        or ((requisicao.tp-requis = 2 or requisicao.tp-requis = 3) and l-mat-unid-negoc) then do:
            
                        /*if not adm-new-record then do: /* teste modificao */*/
                        IF pType = "UPDATE":U THEN DO:
                        
                            
                            if not can-find (first unid-neg-requis where
                                                   unid-neg-requis.nr-requisicao = rowObject.nr-requisicao and
                                                   unid-neg-requis.sequencia     = rowObject.sequencia) then do:
        
                                if rowObject.cod-unid-negoc = "" then do:
                                     {utp/ut-liter.i "Unidade de Negï¿½cio"}
                                     {method/svc/errors/inserr.i
                                        &ErrorNumber="265"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR" 
                                        &ErrorParameters="return-value"}
                                end.
                            end.
                            else do:
                                if rowObject.cod-unid-negoc <> "" then do:
                                    for each unid-neg-requis exclusive-lock where
                                         unid-neg-requis.nr-requisicao = rowObject.nr-requisicao and
                                         unid-neg-requis.sequencia     = rowObject.sequencia:
                                        delete unid-neg-requis.
                                    end.
                                end.
                            end.
                        end.
                        else do:
        
                             if rowObject.cod-unid-negoc = "" then do:
                                {utp/ut-liter.i "Unidade de Negï¿½cio"}
                                {method/svc/errors/inserr.i
                                     &ErrorNumber="265"
                                     &ErrorType="EMS"
                                     &ErrorSubType="ERROR" 
                                     &ErrorParameters="return-value"}
                            end.
                            else do:
                                if not can-find (first unid-negoc
                                                 where unid-negoc.cod-unid-negoc = rowObject.cod-unid-negoc) then do:
        
                                    {utp/ut-liter.i "Unidade de Negï¿½cio"}
                                    {method/svc/errors/inserr.i
                                        &ErrorNumber="2"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR" 
                                        &ErrorParameters="return-value + rowObject.cod-unid-negoc"}
                                end.
                            end.
                        end.
        
                        if  valid-handle(h-cdapi024) 
                        and rowObject.cod-unid-negoc <> "" then do:
                
                            empty temp-table tt-erro-aux.
                
                            /*UN X Estabelecimento*/
                            run ValidaUnidadeNegocioEstabel in h-cdapi024 (input rowObject.cod-estabel,
                                                                           input requisicao.dt-requisicao,
                                                                           input rowObject.cod-unid-negoc, 
                                                                           output table tt-erro-aux).
        
                            /*UN X Usuï¿½rio*/
                            run ValidaUnidadeNegocioUsuario in h-cdapi024 (input rowObject.nome-abrev,
                                                                           input rowObject.cod-unid-negoc, 
                                                                           output table tt-erro-aux append).
        
                            /*UN x Centro de Custo - API Finanï¿½as*/
                            if not avail param-global then
                                find first param-global no-lock no-error.
        
                            if (RowObject.ct-codigo + RowObject.sc-codigo) <> "" and rowObject.cod-unid-negoc <> "" then do:
                                assign l-unid-neg = yes.
                                
                                &IF "{&bf_mat_versao_ems}" <= "2.072" &THEN
                                    ASSIGN l-unid-neg = IF SUBSTRING(param-global.char-2,31,1) = "2" THEN YES ELSE NO.
                                &ELSE
                                    ASSIGN l-unid-neg = param-global.log-validac-ems5.
                                &ENDIF
                            end.
                            else 
                                assign l-unid-neg = no.
                                
                            if l-unid-neg then do:
                                RUN ValidaRestricoesUnidadeNegocio IN h-cdapi024 (INPUT  rowObject.cod-estabel,
                                                                                  INPUT  rowObject.ct-codigo,
                                                                                  INPUT  rowObject.sc-codigo,
                                                                                  INPUT  rowObject.cod-unid-negoc,
                                                                                  INPUT  rowObject.dt-entrega,
                                                                                  INPUT  NO,
                                                                                  OUTPUT TABLE tt-erro-aux APPEND).
                            END.
                            /**********/
        
                            IF CAN-FIND(FIRST tt-erro-aux) THEN DO:
                                FOR EACH tt-erro-aux: 
                                    {method/svc/errors/inserr.i
                                         &ErrorNumber="tt-erro-aux.cd-erro"
                                         &ErrorType="EMS"
                                         &ErrorSubType="ERROR"
                                         &ErrorParameters=" "}
                                END.
                            end.
                        end.
                    end.
                END.
           
            
            DELETE PROCEDURE h-cdapi024.
        END.
        ELSE
            ASSIGN rowObject.cod-unid-negoc = "".
      
    &endif
               

END PROCEDURE.
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-unidade-negocio-matriz V-table-Win 
PROCEDURE pi-unidade-negocio-matriz:

    &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
    
        DEF INPUT  PARAMETER pr-it-requisicao AS ROWID NO-UNDO.
        DEF INPUT  PARAMETER TABLE FOR tt-matriz.  
        DEFINE VARIABLE l-unid-neg AS LOGICAL    NO-UNDO.
        DEF VAR h-cdapi024 AS HANDLE NO-UNDO.
        DEF VAR l-modifica AS LOGICAL NO-UNDO.
        DEFINE VARIABLE pl-unidade-negocio-matriz AS LOGICAL  NO-UNDO.
        DEFINE BUFFER b-item FOR ITEM.
        DEFINE BUFFER b-item-uni-estab FOR item-uni-estab.
    
        run cdp/cdapi024.p PERSISTENT set h-cdapi024.
    
        IF NOT CAN-FIND(FIRST tt-matriz) THEN
            RETURN "OK":U.
    
        IF NOT l-unidade-negocio OR NOT l-mat-unid-negoc THEN
            RETURN "OK":U.
        
        FIND FIRST tt-matriz NO-ERROR.
        
        FIND b-it-requisicao
            WHERE ROWID(b-it-requisicao) = pr-it-requisicao NO-LOCK NO-ERROR.
        IF AVAIL b-it-requisicao  THEN DO:
            IF b-it-requisicao.situacao = 2 OR b-it-requisicao.situacao = 4 THEN
                ASSIGN l-modifica = NO.
            ELSE 
                ASSIGN l-modifica = YES.
        
            find b-item where
                b-item.it-codigo = b-it-requisicao.it-codigo no-lock no-error.
            
            if avail b-item then do:
              find b-item-uni-estab no-lock where
                   b-item-uni-estab.it-codigo   = b-it-requisicao.it-codigo and
                   b-item-uni-estab.cod-estabel = b-it-requisicao.cod-estabel no-error.
              if avail b-item-uni-estab then do:
            
                  &if '{&bf_mat_versao_ems}' >= '2.062' &then
                      if not l-unidade-negocio or (l-unidade-negocio and b-it-requisicao.num-ord-inv = 0) then do:
                          /* Se nï¿½o for Requisiï¿½ï¿½o do estoque */
                          if (requisicao.tp-requis <> 1 and 
                              l-modifica) and 
                              ((b-item.tipo-contr = 1 or b-item.tipo-contr = 4) or 
                               (b-item.tipo-contr = 2 and 
                               (b-it-requisicao.ct-codigo + b-it-requisicao.sc-codigo) <> "" or b-item-uni-estab.altera-conta)) then
                              assign pl-unidade-negocio-matriz = yes.
                          else
                              assign pl-unidade-negocio-matriz = no.
                      end.
                      else do:
                          if (l-modifica and 
                              (b-item.tipo-contr = 1 or b-item.tipo-contr = 4)) or 
                               (b-item.tipo-contr = 2 and 
                               (b-it-requisicao.ct-codigo + b-it-requisicao.sc-codigo) <> "" or b-item-uni-estab.altera-conta) then
                              assign pl-unidade-negocio-matriz = yes.
                          else
                              assign pl-unidade-negocio-matriz = no.
                      end.
                  &else
                      if (requisicao.tp-requis <> 1 and /* Se nï¿½o for Requisiï¿½ï¿½o do estoque */
                          l-modifica and 
                          ((b-item.tipo-contr = 1 or b-item.tipo-contr = 4) or 
                           (b-item.tipo-contr = 2 and 
                          ((b-it-requisicao.ct-codigo + b-it-requisicao.sc-codigo) <> "" or b-item-uni-estab.altera-conta)))) then
                          assign pl-unidade-negocio-matriz = yes.
                      else
                          assign pl-unidade-negocio-matriz = no.
                  &endif
              end.
              else
                  assign pl-unidade-negocio-matriz = no.
            end.
            else
              assign pl-unidade-negocio-matriz = no.
        END.
    
        IF NOT pl-unidade-negocio-matriz THEN DO:
            {method/svc/errors/inserr.i
                  &ErrorNumber="35108"
                  &ErrorType="EMS"
                  &ErrorSubType="ERROR" 
                  &ErrorParameters="''"}
        END.
        ELSE DO:
            empty temp-table tt-erro-aux.
                
            /*UN X Estabelecimento*/
            run ValidaUnidadeNegocioEstabel in h-cdapi024 (input rowObject.cod-estabel,
                                                           input requisicao.dt-requisicao,
                                                           input tt-matriz.cod-unid-neg, 
                                                           output table tt-erro-aux).
    
            /*UN X Usuï¿½rio*/
            run ValidaUnidadeNegocioUsuario in h-cdapi024 (input rowObject.nome-abrev,
                                                           input tt-matriz.cod-unid-neg, 
                                                           output table tt-erro-aux append).
    
            /*UN x Centro de Custo - API Finanï¿½as*/
            if not avail param-global then
                find first param-global no-lock no-error.
    
            if (b-it-requisicao.ct-codigo + b-it-requisicao.sc-codigo) <> "" and rowObject.cod-unid-negoc <> "" then do:
                assign l-unid-neg = yes.
                
                &IF "{&bf_mat_versao_ems}" <= "2.072" &THEN
                    ASSIGN l-unid-neg = IF SUBSTRING(param-global.char-2,31,1) = "2" THEN YES ELSE NO.
                &ELSE
                    ASSIGN l-unid-neg = param-global.log-validac-ems5.
                &ENDIF
            end.
            else 
                assign l-unid-neg = no.
                
            if l-unid-neg then do:
                RUN ValidaRestricoesUnidadeNegocio IN h-cdapi024 (INPUT  rowObject.cod-estabel,
                                                                  INPUT  b-it-requisicao.ct-codigo, 
                                                                  INPUT  b-it-requisicao.sc-codigo,
                                                                  INPUT  tt-matriz.cod-unid-neg,
                                                                  INPUT  rowObject.dt-entrega,
                                                                  INPUT  NO,
                                                                  OUTPUT TABLE tt-erro-aux APPEND).
            END.
    
            IF CAN-FIND(FIRST tt-erro-aux) THEN DO:
                FOR EACH tt-erro-aux: 
                    {method/svc/errors/inserr.i
                         &ErrorNumber="tt-erro-aux.cd-erro"
                         &ErrorType="EMS"
                         &ErrorSubType="ERROR"
                         &ErrorParameters=" "}
                END.
            end.
            ELSE DO:
              &if '{&bf_mat_versao_ems}' >= '2.062' &then
                    FOR EACH tt-matriz:
                        FIND FIRST unid-neg-requis EXCLUSIVE-LOCK
                             WHERE unid-neg-requis.nr-requisicao  = RowObject.nr-requisicao
                               AND unid-neg-requis.it-codigo      = RowObject.it-codigo
                               AND unid-neg-requis.sequencia      = RowObject.sequencia
                               AND unid-neg-requis.cod_unid_negoc = tt-matriz.cod-unid-neg NO-ERROR.
                        IF  NOT AVAIL unid-neg-requis THEN DO:
                            CREATE unid-neg-requis.
                            ASSIGN unid-neg-requis.nr-requisicao  = RowObject.nr-requisicao
                                   unid-neg-requis.it-codigo      = RowObject.it-codigo
                                   unid-neg-requis.sequencia      = RowObject.sequencia
                                   unid-neg-requis.cod_unid_negoc = tt-matriz.cod-unid-neg.
                        END.
                        ASSIGN unid-neg-requis.perc-unid-neg = tt-matriz.perc-rateio.
                    END.
              &endif
            END.
        END.
       
    &endif

END PROCEDURE.
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnLogProcessWMS DBOFunction 
FUNCTION fnLogProcessWMS RETURNS CHARACTER (INPUT pGeraWMS AS CHARACTER):
    IF pGeraWMS = "Y":U THEN {utp/ut-liter.i "Sim" *}
                        ELSE {utp/ut-liter.i "NÃ†o" *}.
    RETURN RETURN-VALUE.
END.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-retorna-qtd-disponivel DBOFunction 
FUNCTION fn-retorna-qtd-disponivel RETURNS DECIMAL
  ( TABLE FOR ttSummaryInventoryBalance ):
  
    DEFINE VARIABLE d-qtd AS DECIMAL NO-UNDO.
    
    FOR EACH ttSummaryInventoryBalance:
        ASSIGN d-qtd = d-qtd + ttSummaryInventoryBalance.qtidade-atu.
    END.

    RETURN d-qtd. 
END FUNCTION.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-retorna-qtd-disponivel-lote DBOFunction 
FUNCTION fn-retorna-qtd-disponivel-lote RETURNS DECIMAL
  ( TABLE FOR ttSummaryInventoryBalance ):
  
    DEFINE VARIABLE d-qtd AS DECIMAL NO-UNDO.
    
    FOR EACH ttSummaryInventoryBalance
       WHERE ttSummaryInventoryBalance.dt-vali-lote >= TODAY:
        ASSIGN d-qtd = d-qtd + ttSummaryInventoryBalance.qtidade-atu.
    END.

    RETURN d-qtd. 
END FUNCTION.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-qtd-suficiente-atendimento DBOFunction 
FUNCTION fn-qtd-suficiente-atendimento RETURNS LOGICAL
  ( d-qtd-disponivel AS DECIMAL, d-qtd-atender AS DECIMAL):
  
    RETURN d-qtd-disponivel >= d-qtd-atender.
END FUNCTION.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getItemBalance DBOFunction 
PROCEDURE getItemBalance:
    /*------------------------------------------------------------------------------
      Purpose:Retornar Saldo em Estoque
      Parameters:  <none>
      Notes:       
    ------------------------------------------------------------------------------*/
        
        DEFINE INPUT PARAMETER pr-rowid    AS ROWID   NO-UNDO.
        DEFINE INPUT PARAMETER pl-grouplot AS LOGICAL NO-UNDO.    
        DEFINE OUTPUT PARAMETER TABLE FOR ttSummaryInventoryBalance.
        
        DEFINE VARIABLE de-qtidade-saldo  LIKE saldo-estoq.qtidade-atu NO-UNDO.
        DEFINE VARIABLE c-log-process-wms AS CHARACTER NO-UNDO.
        def var l-ordem-mi                as logical INIT NO no-undo.
    
        if  c-nom-prog-upc-mg97 <> "" then do:
            for each tt-epc
                where tt-epc.cod-event = "BeforeGetItemBalance":
                delete tt-epc.
            end.
    
            {include/i-epc200.i2 &CodEvent       = '"BeforeGetItemBalance"'
                                 &CodParameter   = '"rowid-it-requisicao"'
                                 &ValueParameter = "string(pr-rowid)"}
    
            {include/i-epc201.i "BeforeGetItemBalance"}
        end.
        
      &if '{&bf_lote_avancado_liberado}' >= 'yes' &then
        DEFINE VARIABLE l-lote-avancado AS LOGICAL NO-UNDO.
        DEFINE VARIABLE l-retorno       AS LOGICAL NO-UNDO.
        DEFINE VARIABLE h-ceapi030      AS HANDLE  NO-UNDO.
        
        IF CAN-FIND(FIRST funcao 
                    WHERE funcao.cd-funcao = 'lote-avancado':U
                      AND funcao.ativo) then do:
                      
            ASSIGN l-lote-avancado = YES.
    
            IF NOT VALID-HANDLE(h-ceapi030) THEN
                RUN cep/ceapi030.p PERSISTENT SET h-ceapi030 (INPUT TABLE tt-dados-fda,
                                                              OUTPUT TABLE tt-valores,
                                                              OUTPUT TABLE tt-erro).
        END.
      &endif
    
        EMPTY TEMP-TABLE ttSummaryInventoryBalance NO-ERROR.
        
        userCodeBlock:
        DO ON ERROR UNDO, LEAVE userCodeBlock
           ON STOP  UNDO, LEAVE userCodeBlock
           ON QUIT  UNDO, LEAVE userCodeBlock:
    
            FOR FIRST it-requisicao FIELDS(it-codigo cod-estabel char-1 nr-requisicao sequencia cod-refer) NO-LOCK
                WHERE ROWID(it-requisicao) = pr-rowid: END.
                
            IF NOT AVAIL it-requisicao THEN RETURN "NOK":U.
        
            FOR FIRST item FIELDS(tipo-con-est ) NO-LOCK
                WHERE item.it-codigo = it-requisicao.it-codigo: END.
        
            FOR FIRST item-uni-estab FIELDS(perm-saldo-neg) NO-LOCK
                WHERE item-uni-estab.it-codigo   = it-requisicao.it-codigo 
                  AND item-uni-estab.cod-estabel = it-requisicao.cod-estabel: END.
                  
            IF AVAIL item-uni-estab THEN DO:
        
                IF item-uni-estab.perm-saldo-neg = 1 THEN DO: /* NAO PERMITE SALDO NEGATIVO */
                
                    FOR EACH saldo-estoq FIELDS(cod-depos    it-codigo cod-estabel lote dt-vali-lote 
                                                qtidade-atu  qt-alocada qt-aloc-ped qt-aloc-prod 
                                                cod-localiz  cod-refer) NO-LOCK
                       WHERE saldo-estoq.it-codigo   = it-requisicao.it-codigo         
                         AND saldo-estoq.cod-estabel = it-requisicao.cod-estabel,     
                       FIRST deposito NO-LOCK                                        
                       WHERE deposito.cod-depos = saldo-estoq.cod-depos
                         AND deposito.ind-dep-cq = NO:
    
                      &if '{&bf_lote_avancado_liberado}' >= 'yes' &then
                        ASSIGN l-retorno = YES.
    
                        IF  l-lote-avancado  
                        AND item.tipo-con-est > 2 THEN DO: /* Numero serie (i01in122.i) */
                        
                            RUN pi-identifica-saldo IN h-ceapi030 (INPUT 1,
                                                                   INPUT saldo-estoq.it-codigo,
                                                                   INPUT saldo-estoq.cod-estabel,
                                                                   INPUT saldo-estoq.lote,
                                                                   INPUT 0,
                                                                   OUTPUT l-retorno,
                                                                   OUTPUT TABLE tt-valores2,
                                                                   OUTPUT TABLE tt-erro).
                        END.
    
                        IF NOT l-retorno THEN
                            ASSIGN de-qtidade-saldo = 0.
                        ELSE
                      &endif
                      
                         ASSIGN de-qtidade-saldo = saldo-estoq.qtidade-atu   - 
                                                  (saldo-estoq.qt-alocada    +  
                                                   saldo-estoq.qt-aloc-ped   +  
                                                   saldo-estoq.qt-aloc-prod).
                             
                         ASSIGN l-ordem-mi = NO.
    
                         for first req-ord-produc no-lock
                             where req-ord-produc.nr-requisicao    =  it-requisicao.nr-requisicao
                               and req-ord-produc.sequencia        =  it-requisicao.sequencia,
                             first ord-prod no-lock
                             where ord-prod.nr-ord-produ = req-ord-produc.nr-ord-produ. end.
    
                         IF AVAIL req-ord-produc 
                              AND AVAIL ord-prod 
                              AND ord-prod.origem = "MI" 
                              AND saldo-estoq.qt-aloc-prod > 0 THEN 
                             ASSIGN l-ordem-mi = YES.
    
                         IF l-ordem-mi THEN DO:
                             FOR EACH req-ord-produc
                                WHERE req-ord-produc.nr-requisicao = it-requisicao.nr-requisicao
                                  AND req-ord-produc.sequencia     = it-requisicao.sequencia NO-LOCK:
    
                                 IF AVAIL req-ord-produc THEN DO:
    
                                     FIND FIRST reservas
                                          WHERE reservas.nr-ord-produ = req-ord-produc.nr-ord-produ
                                          AND   reservas.it-codigo    = it-requisicao.it-codigo NO-LOCK NO-ERROR.
        
                                     IF AVAIL reservas THEN DO:
        
                                         RUN criaTTSummaryInventoryBalance IN THIS-PROCEDURE(INPUT it-requisicao.nr-requisicao,
                                                                                             INPUT it-requisicao.sequencia,
                                                                                             INPUT saldo-estoq.cod-depos,
                                                                                             INPUT saldo-estoq.cod-localiz,
                                                                                             INPUT saldo-estoq.lote,
                                                                                             INPUT saldo-estoq.dt-vali-lote,
                                                                                             INPUT saldo-estoq.cod-refer,
                                                                                             INPUT reservas.quant-aloc + de-qtidade-saldo,
                                                                                             INPUT 0,
                                                                                             INPUT c-log-process-wms,
                                                                                             INPUT NO).
                                     END.
                                 END.
                             END.
                         END.
                         ELSE IF de-qtidade-saldo > 0 THEN DO:
    
                            ASSIGN c-log-process-wms = fnLogProcessWMS(SUBSTRING(it-requisicao.char-1,15,1)).
        
                            RUN criaTTSummaryInventoryBalance IN THIS-PROCEDURE(INPUT it-requisicao.nr-requisicao,
                                                                                INPUT it-requisicao.sequencia,
                                                                                INPUT saldo-estoq.cod-depos,
                                                                                INPUT saldo-estoq.cod-localiz,
                                                                                INPUT saldo-estoq.lote,
                                                                                INPUT saldo-estoq.dt-vali-lote,
                                                                                INPUT saldo-estoq.cod-refer,
                                                                                INPUT de-qtidade-saldo,
                                                                                INPUT 0,
                                                                                INPUT c-log-process-wms,
                                                                                INPUT NO).
                            
                        END.
                    END.
                END.
                ELSE DO: /* PERMITE SALDO NEGATIVO */
                    IF item.tipo-con-est = 4 THEN DO: /* ReferË†ncia (i01in122.i) */
         
                        FOR EACH saldo-estoq FIELDS(cod-depos    it-codigo   cod-estabel  lote qtidade-atu  
                                                    qt-alocada   qt-aloc-ped qt-aloc-prod cod-localiz 
                                                    dt-vali-lote cod-refer) NO-LOCK                   
                           WHERE saldo-estoq.it-codigo   = it-requisicao.it-codigo         
                             AND saldo-estoq.cod-estabel = it-requisicao.cod-estabel       
                             AND saldo-estoq.cod-refer   = it-requisicao.cod-refer,
                           FIRST deposito NO-LOCK
                           WHERE deposito.cod-depos = saldo-estoq.cod-depos
                             AND deposito.ind-dep-cq = NO: 
                          &if '{&bf_lote_avancado_liberado}' >= 'yes' &then
                            ASSIGN l-retorno = YES.
                            
                            IF l-lote-avancado THEN DO:                           
                                RUN pi-identifica-saldo in h-ceapi030 (INPUT 1,
                                                                       INPUT saldo-estoq.it-codigo,
                                                                       INPUT saldo-estoq.cod-estabel,
                                                                       INPUT saldo-estoq.lote,
                                                                       INPUT 0,
                                                                       OUTPUT l-retorno,
                                                                       OUTPUT TABLE tt-valores2,
                                                                       OUTPUT TABLE tt-erro).
                            END.
        
                            IF NOT l-retorno THEN
                                ASSIGN de-qtidade-saldo = 0.
                            ELSE
                          &endif
                                ASSIGN de-qtidade-saldo = saldo-estoq.qtidade-atu - 
                                                         (saldo-estoq.qt-alocada +  
                                                          saldo-estoq.qt-aloc-ped +  
                                                          saldo-estoq.qt-aloc-prod).
    
                            ASSIGN c-log-process-wms = fnLogProcessWMS(SUBSTRING(it-requisicao.char-1,15,1)).
                            
                            RUN criaTTSummaryInventoryBalance IN THIS-PROCEDURE(INPUT it-requisicao.nr-requisicao,
                                                                                INPUT it-requisicao.sequencia,
                                                                                INPUT saldo-estoq.cod-depos,
                                                                                INPUT saldo-estoq.cod-localiz,
                                                                                INPUT saldo-estoq.lote,
                                                                                INPUT saldo-estoq.dt-vali-lote,
                                                                                INPUT saldo-estoq.cod-refer,
                                                                                INPUT de-qtidade-saldo,
                                                                                INPUT 0,
                                                                                INPUT c-log-process-wms,
                                                                                INPUT NO).
                        END.
                    END.            
                    ELSE DO: /* ITEM NAO CONTROLADO POR REFERENCIA */
        
                        FOR EACH saldo-estoq FIELDS(cod-depos    it-codigo   cod-estabel  lote qtidade-atu  
                                                    qt-alocada   qt-aloc-ped qt-aloc-prod cod-localiz 
                                                    dt-vali-lote cod-refer) NO-LOCK
                           WHERE saldo-estoq.it-codigo   = it-requisicao.it-codigo
                             AND saldo-estoq.cod-estabel = it-requisicao.cod-estabel,
                           FIRST deposito NO-LOCK
                           WHERE deposito.cod-depos  = saldo-estoq.cod-depos
                             AND deposito.ind-dep-cq = NO:
                            
                          &if '{&bf_lote_avancado_liberado}' >= 'yes' &then
                            ASSIGN l-retorno = YES.
        
                            IF l-lote-avancado 
                            AND item.tipo-con-est = 3 THEN DO:  /* LOTE (i01in122.i) */
                               
                                RUN pi-identifica-saldo IN h-ceapi030 (INPUT 1,
                                                                       INPUT saldo-estoq.it-codigo,
                                                                       INPUT saldo-estoq.cod-estabel,
                                                                       INPUT saldo-estoq.lote,
                                                                       INPUT 0,
                                                                       OUTPUT l-retorno,
                                                                       OUTPUT TABLE tt-valores2,
                                                                       OUTPUT TABLE tt-erro).
        
                            END.
        
                            IF NOT l-retorno THEN
                                ASSIGN de-qtidade-saldo = 0.
                            ELSE
                          &endif
                                ASSIGN de-qtidade-saldo = saldo-estoq.qtidade-atu - 
                                                         (saldo-estoq.qt-alocada +  
                                                          saldo-estoq.qt-aloc-ped +  
                                                          saldo-estoq.qt-aloc-prod).
                                                          
                            ASSIGN c-log-process-wms = fnLogProcessWMS(SUBSTRING(it-requisicao.char-1,15,1)).
                            
                            RUN criaTTSummaryInventoryBalance IN THIS-PROCEDURE(INPUT it-requisicao.nr-requisicao,
                                                                                INPUT it-requisicao.sequencia,
                                                                                INPUT saldo-estoq.cod-depos,
                                                                                INPUT saldo-estoq.cod-localiz,
                                                                                INPUT saldo-estoq.lote,
                                                                                INPUT saldo-estoq.dt-vali-lote,
                                                                                INPUT saldo-estoq.cod-refer,
                                                                                INPUT de-qtidade-saldo,
                                                                                INPUT 0,
                                                                                INPUT c-log-process-wms,
                                                                                INPUT NO).
                        END.
                    END.
                END.
            END.
            
        END. 
    
        if  c-nom-prog-upc-mg97 <> "" then do:
            for each tt-epc
                where tt-epc.cod-event = "AfterGetItemBalance":
                delete tt-epc.
            end.
    
            {include/i-epc200.i2 &CodEvent       = '"AfterGetItemBalance"'
                                 &CodParameter   = '"ttSummaryInventoryBalance"'
                                 &ValueParameter = "string(TEMP-TABLE ttSummaryInventoryBalance:HANDLE)"}
    
            {include/i-epc201.i "AfterGetItemBalance"}
        end.
    
        /* Agrupa Lotes WMS */
        IF pl-grouplot THEN    
            RUN groupLotWMS IN THIS-PROCEDURE(INPUT pl-grouplot, INPUT-OUTPUT TABLE ttSummaryInventoryBalance).
    
      &if '{&bf_lote_avancado_liberado}' >= 'yes' &then
        IF VALID-HANDLE(h-ceapi030) THEN DO:
          DELETE PROCEDURE h-ceapi030.
          ASSIGN h-ceapi030 = ?.
        END.
      &endif
        
        RETURN "OK":U.
    END PROCEDURE.
    /* _UIB-CODE-BLOCK-END */
    &ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaTTSummaryInventoryBalance DBOFunction 
PROCEDURE criaTTSummaryInventoryBalance PRIVATE:
    /*------------------------------------------------------------------------------
      Purpose: Cria temp table se saldo em estoque do item     
      Parameters:  <none>
      Notes:       
    ------------------------------------------------------------------------------*/
        DEFINE INPUT PARAMETER p-nr-requisicao   LIKE it-requisicao.nr-requisicao NO-UNDO.
        DEFINE INPUT PARAMETER p-sequencia       LIKE it-requisicao.sequencia     NO-UNDO.
        DEFINE INPUT PARAMETER p-cod-depos       LIKE saldo-estoq.cod-depos       NO-UNDO.
        DEFINE INPUT PARAMETER p-cod-localiz     LIKE saldo-estoq.cod-localiz     NO-UNDO.
        DEFINE INPUT PARAMETER p-lote            LIKE saldo-estoq.lote            NO-UNDO.
        DEFINE INPUT PARAMETER p-dt-vali-lote    LIKE saldo-estoq.dt-vali-lote    NO-UNDO.
        DEFINE INPUT PARAMETER p-cod-refer       LIKE saldo-estoq.cod-refer       NO-UNDO.
        DEFINE INPUT PARAMETER p-qtidade-atu     AS DECIMAL                       NO-UNDO.
        DEFINE INPUT PARAMETER p-qt-a-atender    AS DECIMAL                       NO-UNDO.
        DEFINE INPUT PARAMETER p-logprocesswms   AS CHARACTER                     NO-UNDO.
        DEFINE INPUT PARAMETER p-close           AS LOGICAL                       NO-UNDO.
        
        CREATE ttSummaryInventoryBalance.
        ASSIGN ttSummaryInventoryBalance.nr-requisicao  = p-nr-requisicao
               ttSummaryInventoryBalance.sequencia      = p-sequencia
               ttSummaryInventoryBalance.cod-depos      = p-cod-depos    
               ttSummaryInventoryBalance.cod-localiz    = p-cod-localiz  
               ttSummaryInventoryBalance.lote           = p-lote         
               ttSummaryInventoryBalance.dt-vali-lote   = p-dt-vali-lote 
               ttSummaryInventoryBalance.cod-refer      = p-cod-refer    
               ttSummaryInventoryBalance.qtidade-atu    = p-qtidade-atu  
               ttSummaryInventoryBalance.qt-a-atender   = p-qt-a-atender 
               ttSummaryInventoryBalance.logprocesswms  = p-logprocesswms
               ttSummaryInventoryBalance.close          = p-close.
               
        RETURN "OK":U.
    END PROCEDURE.
    /* _UIB-CODE-BLOCK-END */
    &ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createRowErrors DBOFunction 
PROCEDURE createRowErrors PRIVATE: 
    /*------------------------------------------------------------------------------
      Purpose:     
      Parameters:  pTipoErro: 1 - Cria RowErrors pelo c¢digo da mensagem
                              2 - Cria RowErrors pela tt-erro
      Notes:       
    ------------------------------------------------------------------------------*/     
        DEFINE INPUT PARAMETER pTipoErro         AS INTEGER   NO-UNDO.
        DEFINE INPUT PARAMETER pErrorNumber      AS INTEGER   NO-UNDO.
        DEFINE INPUT PARAMETER pErrorDescription AS CHARACTER NO-UNDO.
        
        DEFINE VARIABLE i-seq-erro AS INTEGER    NO-UNDO.
        DEFINE VARIABLE cErrorHelp AS CHARACTER  NO-UNDO.
    
        FIND LAST RowErrors NO-ERROR.
        IF  AVAIL RowErrors then
            ASSIGN i-seq-erro = RowErrors.ErrorSequence + 1.
        ELSE 
            ASSIGN i-seq-erro = 1.
            
    
        /** Busca Help da Mensagem **/
        RUN utp/ut-msgs.p (INPUT "HELP":U,
                           INPUT pErrorNumber,  
                           INPUT pErrorDescription).   
        ASSIGN cErrorHelp = RETURN-VALUE.
            
        /*Busca Descri?’o da Mensagem*/
        RUN utp/ut-msgs.p (INPUT 'msg':U,
                           INPUT pErrorNumber,
                           INPUT pErrorDescription).    
    
        CREATE RowErrors.
        ASSIGN RowErrors.ErrorSequence    = i-seq-erro
               RowErrors.ErrorNumber      = pErrorNumber
               RowErrors.ErrorType        = "EMS":U
               RowErrors.ErrorSubType     = "ERROR":U
               RowErrors.ErrorDescription = IF pTipoErro = 1 THEN RETURN-VALUE ELSE pErrorDescription
               RowErrors.ErrorHelp        = cErrorHelp.
    
        RETURN "OK":U.
    END PROCEDURE.
    /* _UIB-CODE-BLOCK-END */
    &ANALYZE-RESUME

    &ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaSaldosUsuarDepEstab DBOFunction 
PROCEDURE retornaSaldosUsuarDepEstab:
    /*------------------------------------------------------------------------------
      Purpose:     Retornar temp-table somente com os saldos que o usu rio
                    tem permissÆo.
      Parameters:  Quantidade a Atender e temp-table com os saldos em estoque
      Notes:       
    ------------------------------------------------------------------------------*/
        DEFINE INPUT PARAMETER pc-cod-estabel AS CHARACTER NO-UNDO.
        DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttSummaryInventoryBalance.
        DEFINE VARIABLE cNomeAbrev AS CHARACTER NO-UNDO.

        RUN getDefaultRequester (OUTPUT cNomeAbrev).
        
        FOR EACH ttSummaryInventoryBalance:
            IF NOT CAN-FIND(FIRST usuar-depos
                            WHERE usuar-depos.cod-depos   = ttSummaryInventoryBalance.cod-depos
                              AND usuar-depos.cod-estabel = pc-cod-estabel
                              AND usuar-depos.cod-usuario   = cNomeAbrev
                              AND usuar-depos.dat-val-fim >= TODAY) THEN DO:
                DELETE ttSummaryInventoryBalance.
                NEXT.
            END.
        END.
        
        RETURN "OK":U.
        
    END PROCEDURE.
    /* _UIB-CODE-BLOCK-END */
    &ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaQtdeAtender DBOFunction 
PROCEDURE validaQtdeAtender:
    /*------------------------------------------------------------------------------
      Purpose:     Validar possibilidade de atendimento da requisi?’o
      Parameters:  Quantidade a Atender e temp-table com os saldos em estoque
      Notes:       
    ------------------------------------------------------------------------------*/
    
        DEFINE INPUT PARAMETER p-qtd-atender AS DECIMAL NO-UNDO.
        DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttSummaryInventoryBalance.
            
        DEFINE VARIABLE de-qtde-total-disp AS DECIMAL     NO-UNDO.
        DEFINE VARIABLE de-qtde-total-perm AS DECIMAL     NO-UNDO.
        DEFINE VARIABLE de-qtde-venc-lote  AS DECIMAL     NO-UNDO.
        
        DEFINE VARIABLE l-item-contr-lote AS LOGICAL NO-UNDO.    
      
        ASSIGN l-item-contr-lote = AVAILABLE item AND item.tipo-con-est >= 3.
        
        IF p-qtd-atender > it-requisicao.qt-a-atender THEN DO:    
            RUN createRowErrors IN THIS-PROCEDURE(INPUT 1, INPUT 412, INPUT ""). /* Quantidade digitada maior que a requisitada (a atender). */                   
            RETURN "NOK":U.
        END.
        
        RUN retornaSaldosUsuarDepEstab IN THIS-PROCEDURE(INPUT it-requisicao.cod-estabel,
                                                         INPUT-OUTPUT TABLE ttSummaryInventoryBalance).
                                                         
        IF NOT CAN-FIND(FIRST ttSummaryInventoryBalance) THEN DO:
            /* Usu rio sem permissÆo em nenhum deposito */
            RUN createRowErrors IN THIS-PROCEDURE(INPUT 1, INPUT 55258, INPUT ""). /* Usu rio nÆo possui permissÆo para atendimento */
            RETURN "NOK".
        END.
        
        
        ASSIGN de-qtde-total-perm = fn-retorna-qtd-disponivel(TABLE ttSummaryInventoryBalance).
        
        IF l-item-contr-lote THEN
             ASSIGN de-qtde-venc-lote = fn-retorna-qtd-disponivel-lote(TABLE ttSummaryInventoryBalance).
    
        IF l-item-contr-lote THEN DO:           
            /* QUANTIDADE POR LOTE MENOR QUE A QUANTIDADE PERMITIDA */
            IF (de-qtde-venc-lote < de-qtde-total-perm) THEN DO:         
                /* QUANTIDADE POR LOTE  INSUFICIENTE MAS QUANTIDADE DISPONIVEL SUFICIENTE*/
                IF  NOT fn-qtd-suficiente-atendimento(de-qtde-venc-lote, p-qtd-atender)
                AND fn-qtd-suficiente-atendimento(de-qtde-total-perm, p-qtd-atender) THEN DO:              
                
                    /*55257 - Sem saldo dispon¡vel em estoque para o usu rio. Saldo em estoque com data de validade......  */
                    RUN createRowErrors IN THIS-PROCEDURE(INPUT 1, INPUT 55257, INPUT it-requisicao.it-codigo).  
                    
                    RETURN "NOK".
                END.
                
                 /* QUANTIDADE POR LOTE INSUFICIENTE E QUANTIDADE DISPONIVEL INSUFICIENTE */
                IF  NOT fn-qtd-suficiente-atendimento(de-qtde-venc-lote, p-qtd-atender) 
                AND NOT fn-qtd-suficiente-atendimento(de-qtde-total-perm, p-qtd-atender) THEN DO:
                
                    RUN createRowErrors IN THIS-PROCEDURE(INPUT 1, INPUT 55256, INPUT ""). /*Sem saldo dispon¡vel em estoque para o usu rio.   */
                    RETURN "NOK":U.
                END.
            END.
            ELSE DO:
                /* VERIFICA SE A QUANTIDADE DISPONÖVEL  INSUFICIENTE PARA REALIZAR O ATENDIMENTO */
                IF NOT l-perm-sald-neg AND NOT fn-qtd-suficiente-atendimento(de-qtde-total-perm, p-qtd-atender) THEN DO: 
                    RUN createRowErrors IN THIS-PROCEDURE(INPUT 1, INPUT 55256, INPUT ""). /*Sem saldo dispon¡vel em estoque para o usu rio.   */
                    RETURN "NOK":U.
                END.
            END.
        END.
        ELSE DO:
            /* VERIFICA SE QUANTIDADE DISPONÖVEL  SUFICIENTE PARA REALIZAR O ATENDIMENTO */
            IF NOT l-perm-sald-neg AND NOT fn-qtd-suficiente-atendimento(de-qtde-total-perm, p-qtd-atender) THEN DO:
                RUN createRowErrors IN THIS-PROCEDURE(INPUT 1, INPUT 55256, INPUT ""). /*Sem saldo dispon¡vel em estoque para o usu rio.   */
                RETURN "NOK":U.
            END.
        END.
        
        RETURN "OK":U.
    
    END PROCEDURE.
    /* _UIB-CODE-BLOCK-END */
    &ANALYZE-RESUME

    &ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ordenaDepositos DBOFunction 
PROCEDURE ordenaDepositos PRIVATE:

    /********************************************************
    ORDENA OS DEP…SITOS PARA FAZER O ATENDIMENTO SIMPLIFICADO
    ********************************************************/

    DEF VAR i-seq AS INT NO-UNDO.

    EMPTY TEMP-TABLE ttInventoryBalanceOrdered.

    IF AVAIL ITEM AND item.tipo-con-est >= 3 THEN DO:

        /*ORDENA POR DATA DE VALIDADE QUANDO A DATA FOR MAIOR QUE HOJE E QUANTIDADE MAIOR QUE ZERO*/
        FOR EACH ttSummaryInventoryBalance
           WHERE ttSummaryInventoryBalance.dt-vali-lote >= TODAY
             AND ttSummaryInventoryBalance.qtidade-atu > 0
              BY ttSummaryInventoryBalance.dt-vali-lote
              BY ttSummaryInventoryBalance.qtidade-atu DESC:
            
            ASSIGN i-seq = i-seq + 1.
    
            CREATE ttInventoryBalanceOrdered.
            BUFFER-COPY ttSummaryInventoryBalance TO ttInventoryBalanceOrdered.
            ASSIGN ttInventoryBalanceOrdered.seq = i-seq
                   d-saldo-deposito = d-saldo-deposito + ttSummaryInventoryBalance.qtidade-atu.
    
            DELETE ttSummaryInventoryBalance.
    
        END.
    
        /*ORDENA SOMENTE PELA QUANTIDADE QUANDO A DATA FOR MAIOR QUE TODAY*/
        FOR EACH ttSummaryInventoryBalance
           WHERE ttSummaryInventoryBalance.dt-vali-lote >= TODAY
              BY ttSummaryInventoryBalance.qtidade-atu DESC:
            
            ASSIGN i-seq = i-seq + 1.
    
            CREATE ttInventoryBalanceOrdered.
            BUFFER-COPY ttSummaryInventoryBalance TO ttInventoryBalanceOrdered.
            ASSIGN ttInventoryBalanceOrdered.seq = i-seq
                   d-saldo-deposito = d-saldo-deposito + ttSummaryInventoryBalance.qtidade-atu.
    
            DELETE ttSummaryInventoryBalance.
    
        END.
        
    END.
    ELSE DO:
    
        /*ORDENA OS DEPOSITOS RESTANTES*/
        FOR EACH ttSummaryInventoryBalance
              BY ttSummaryInventoryBalance.qtidade-atu DESC:
            
            ASSIGN i-seq = i-seq + 1.
    
            CREATE ttInventoryBalanceOrdered.
            BUFFER-COPY ttSummaryInventoryBalance TO ttInventoryBalanceOrdered.
            ASSIGN ttInventoryBalanceOrdered.seq = i-seq
            d-saldo-deposito = d-saldo-deposito + ttSummaryInventoryBalance.qtidade-atu.
    
            DELETE ttSummaryInventoryBalance.
    
        END.

    END.

    RETURN "OK":U.
    
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

    &ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE selectedRequisitionProcessing DBOFunction 
PROCEDURE selectedRequisitionProcessing:
    /*------------------------------------------------------------------------------
      Purpose: Atendimento de Requisi?’o por Selecionados  
      Parameters: 
      Notes: 
    ------------------------------------------------------------------------------*/
        
        DEFINE INPUT  PARAMETER TABLE FOR ttItRequisicaoSelec.
        DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.
    
    
        EMPTY TEMP-TABLE RowErrors NO-ERROR.
        userCodeBlock:
        DO TRANSACTION ON ERROR UNDO, LEAVE userCodeBlock
                       ON STOP  UNDO, LEAVE userCodeBlock
                       ON QUIT  UNDO, LEAVE userCodeBlock:
           
            FOR EACH ttItRequisicaoSelec:
            
               IF CAN-FIND(FIRST bf-ttItRequisicaoSelec 
                           WHERE bf-ttItRequisicaoSelec.nr-requisicao <>  ttItRequisicaoSelec.nr-requisicao) THEN DO:
                    RUN createRowErrors IN THIS-PROCEDURE(INPUT 1, INPUT 55229, INPUT ""). /* Atender Selecionados nÆo permitido. */
                    RETURN "NOK":U.
               END.
               EMPTY TEMP-TABLE ttItRequisicao-aux.
    
               CREATE ttItRequisicao-aux.
               BUFFER-COPY ttItRequisicaoSelec TO ttItRequisicao-aux.
    
               EMPTY TEMP-TABLE RowErrors NO-ERROR.
               RUN simplifiedRequisitionProcessing (INPUT TABLE ttItRequisicao-aux,
                                                    OUTPUT TABLE RowErrors).
               IF CAN-FIND(FIRST RowErrors 
                           WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
                   UNDO userCodeBlock,  RETURN "NOK":U.
            END.
            
        END.
        
        RETURN "OK":U.
    END PROCEDURE.
    /* _UIB-CODE-BLOCK-END */
    &ANALYZE-RESUME
    
    &ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE simplifiedRequisitionProcessing DBOFunction 
    PROCEDURE simplifiedRequisitionProcessing:
    /*------------------------------------------------------------------------------
      Purpose: Atendimento de Requisi?’o por Saldo (cd1409html)
      Parameters:  <none>
      Notes:       
    ------------------------------------------------------------------------------*/
        DEFINE INPUT  PARAMETER TABLE FOR ttItRequisicao.
        DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.
    
        DEF VARIABLE de-qtd-atender  AS DECIMAL NO-UNDO.
        DEF VAR c-chave              AS CHAR                        NO-UNDO.

        ASSIGN de-qtd-atender = 0.
        
        DO  ON ERROR UNDO, LEAVE
            ON STOP  UNDO, LEAVE
            ON QUIT  UNDO, LEAVE:
    
            IF  NOT VALID-HANDLE(h-ceapi400) THEN
                RUN cep/ceapi400.p PERSISTENT SET h-ceapi400.
            END. 
       
        blk:
        DO  ON ERROR UNDO, LEAVE blk
            ON STOP  UNDO, LEAVE blk
            ON QUIT  UNDO, LEAVE blk: 
    
            /*INICIO PONTO UPC 6999049*/
            if  c-nom-prog-upc-mg97 <> "" then do:
                for each tt-epc
                    where tt-epc.cod-event = "SimplifiedRequisitionProcessing":
                    delete tt-epc.
                end.
                
                {include/i-epc200.i2 &CodEvent       = '"SimplifiedRequisitionProcessing"'
                                     &CodParameter   = '"h-ttItRequisicao"'
                                     &ValueParameter = "string(TEMP-TABLE ttItRequisicao:HANDLE)"}
                                     
                {include/i-epc200.i2 &CodEvent       = '"SimplifiedRequisitionProcessing"'
                                     &CodParameter   = '"h-RowErrors"'
                                     &ValueParameter = "string(TEMP-TABLE RowErrors:HANDLE)"}
                
                {include/i-epc201.i "SimplifiedRequisitionProcessing"}
                    
                IF CAN-FIND(FIRST RowErrors) THEN DO:
                    UNDO blk, LEAVE blk.
                END.
            END.
            /*FIM PONTO UPC 6999049*/
    
            FOR EACH ttItRequisicao:
    
                ASSIGN l-perm-sald-neg = YES.
    
                FOR FIRST requisicao FIELDS(cod-estabel)
                    WHERE requisicao.nr-requisicao = ttItRequisicao.nr-requisicao NO-LOCK:
                END.
    
                FOR FIRST it-requisicao FIELDS(it-codigo cod-refer cod-estabel qt-a-atender)
                    WHERE it-requisicao.nr-requisicao = ttItRequisicao.nr-requisicao 
                      AND it-requisicao.sequencia     = ttItRequisicao.sequencia NO-LOCK:
    
                    FOR FIRST item FIELDS(tipo-con-est perm-saldo-neg) NO-LOCK 
                        WHERE item.it-codigo = it-requisicao.it-codigo: 
                    END.
    
                    FOR first item-uni-estab FIELDS(perm-saldo-neg)
                        where item-uni-estab.it-codigo   = it-requisicao.it-codigo
                          and item-uni-estab.cod-estabel = requisicao.cod-estabel no-lock:
                    END.

    
                    ASSIGN de-qtd-atender = it-Requisicao.qt-a-atender.
                    
                    EMPTY TEMP-TABLE ttSummaryInventoryBalance.
                    EMPTY TEMP-TABLE ttSummaryInventoryBalanceAux.
    
                    /*Verifica se item aceita saldo negativo*/
                    IF AVAIL item-uni-estab THEN DO:
                        IF item-uni-estab.perm-saldo-neg = 1 THEN
                            ASSIGN l-perm-sald-neg = NO.                
                    END.
                    ELSE DO:
                        IF AVAIL ITEM AND item.perm-saldo-neg = 1 THEN
                            ASSIGN l-perm-sald-neg = NO.
                    END.
    
                    
                    RUN getItemBalance IN THIS-PROCEDURE (INPUT ROWID(it-requisicao), 
                                                              INPUT NO,                
                                                              OUTPUT TABLE ttSummaryInventoryBalance).
                    
                    RUN validaQtdeAtender IN THIS-PROCEDURE (INPUT de-qtd-atender,
                                                             INPUT-OUTPUT TABLE ttSummaryInventoryBalance).
                   
                    /*Se ocorreu algum erro na valida?’o da quantidade a atender n’o faz o atendimento*/
                    IF CAN-FIND(FIRST rowErrors) THEN
                        LEAVE.
    
                    /*faz a ordena?’o dos dep½sitos*/
                    RUN ordenaDepositos IN THIS-PROCEDURE.
    
                    /*Regra para distribui?’o das quantidades caso dep½sito n’o tenha quantidade suficiente para atender a requisi?’o */
                    FOR EACH ttInventoryBalanceOrdered
                          BY ttInventoryBalanceOrdered.seq:
    
                        EMPTY TEMP-TABLE rowErrors. 
    
                        IF AVAIL ITEM AND item.tipo-con-est >= 3 /*refer e lote*/ 
                            AND ttInventoryBalanceOrdered.dt-vali-lote < TODAY THEN
                            RUN createRowErrors IN THIS-PROCEDURE(INPUT 1, INPUT 3007, INPUT ""). /* Lote com data vencida */
    
                        /* Valida Deposito */
                        FOR FIRST deposito FIELDS(ind-dep-cq ind-dep-rej) NO-LOCK 
                            WHERE deposito.cod-depos = ttInventoryBalanceOrdered.cod-depos:             
                            IF deposito.ind-dep-cq THEN
                                RUN createRowErrors IN THIS-PROCEDURE(INPUT 1, INPUT 8374, INPUT ""). /* Dep½sito de CQ n’o pode ser movimentado */
                                
                            IF deposito.ind-dep-rej THEN
                                RUN createRowErrors IN THIS-PROCEDURE(INPUT 1, INPUT 5713, INPUT ""). /* Dep½sito de rejei?’o n’o pode ser movimentado */
                            if  l-integra-his AND l-sistema-his-rm = NO 
                                and (deposito.log-orig-ext) then do:
                                    RUN createRowErrors IN THIS-PROCEDURE(INPUT 1, INPUT 55079, INPUT ""). 
                                end.
                        END.

                        /* Validacoes HIS - item e grupo de estoque */
                        if  l-integra-his AND l-sistema-his-rm = NO then do:

                            for first item fields(it-codigo log-orig-ext ge-codigo)
                                where item.it-codigo = it-requisicao.it-codigo no-lock:

                                if item.log-orig-ext then do:
                                    RUN createRowErrors IN THIS-PROCEDURE(INPUT 1, INPUT 55079, INPUT "").
                                end.

                                for first grup-estoque fields(ge-codigo log-orig-ext)
                                    where grup-estoque.ge-codigo = item.ge-codigo 
                                    and grup-estoque.log-orig-ext no-lock:
                                        RUN createRowErrors IN THIS-PROCEDURE(INPUT 1, INPUT 55079, INPUT "").
                                end.
                            end.
                        end.
    
                        IF CAN-FIND(FIRST rowErrors) THEN
                            NEXT.
                        
                        CREATE ttSummaryInventoryBalanceAux.
                        ASSIGN ttSummaryInventoryBalanceAux.nr-requisicao = ttItRequisicao.nr-requisicao
                               ttSummaryInventoryBalanceAux.sequencia     = ttItRequisicao.sequencia
                               ttSummaryInventoryBalanceAux.cod-depos     = ttInventoryBalanceOrdered.cod-depos
                               ttSummaryInventoryBalanceAux.cod-localiz   = ttInventoryBalanceOrdered.cod-localiz
                               ttSummaryInventoryBalanceAux.lote          = ttInventoryBalanceOrdered.lote
                               ttSummaryInventoryBalanceAux.dt-vali-lote  = ttInventoryBalanceOrdered.dt-vali-lote
                               ttSummaryInventoryBalanceAux.cod-refer     = ttInventoryBalanceOrdered.cod-refer
                               ttSummaryInventoryBalanceAux.qtidade-atu   = ttInventoryBalanceOrdered.qtidade-atu.
    
                        /* SEM SALDO EM ESTOQUE POREM ACEITA SALDO NEGATIVO */
                        IF d-saldo-deposito <= 0 THEN DO:
                               /*GRAVA A CHAVE DO REGISTRO ATUAL*/ 
                               ASSIGN c-chave = ttSummaryInventoryBalanceAux.cod-depos      + "|" + 
                                                ttSummaryInventoryBalanceAux.cod-localiz    + "|" + 
                                                ttSummaryInventoryBalanceAux.lote           + "|" + 
                                                ttSummaryInventoryBalanceAux.cod-refer.
                            LEAVE.
                        END.
                        /*Atende totalmente a quantidade requisitada quando a quantidade em estoque ? maior ou quando aceita saldo negativo*/
                        IF ttInventoryBalanceOrdered.qtidade-atu > de-qtd-atender /*OR
                          (ttInventoryBalanceOrdered.qtidade-atu <= 0)*/ THEN
                            ASSIGN ttSummaryInventoryBalanceAux.qt-a-atender = de-qtd-atender
                                   de-qtd-atender = 0.
                        ELSE IF ttInventoryBalanceOrdered.qtidade-atu > 0 THEN /*Atendimento parcial no dep½sito corrente*/
                            ASSIGN ttSummaryInventoryBalanceAux.qt-a-atender = ttInventoryBalanceOrdered.qtidade-atu
                                   de-qtd-atender = de-qtd-atender - ttInventoryBalanceOrdered.qtidade-atu
                                   
                                   /*GRAVA A CHAVE DO REGISTRO ATUAL*/ 
                                   c-chave = ttSummaryInventoryBalanceAux.cod-depos      + "|" + 
                                             ttSummaryInventoryBalanceAux.cod-localiz    + "|" + 
                                             ttSummaryInventoryBalanceAux.lote           + "|" + 
                                             ttSummaryInventoryBalanceAux.cod-refer.
                                             
                        IF de-qtd-atender = 0 THEN
                            LEAVE.
                    END.
                    
                    /*Se n’o conseguiu atender totalmente a requisi?’o verifica se o item aceita saldo negativo e soma o saldo no ultimo deposito
                      que ocorreu atendimento */
                    IF de-qtd-atender > 0 AND l-perm-sald-neg THEN DO: 
                        FIND FIRST ttSummaryInventoryBalanceAux 
                             WHERE ttSummaryInventoryBalanceAux.cod-depos   = TRIM(ENTRY(1,c-chave, "|"))
                               AND ttSummaryInventoryBalanceAux.cod-localiz = TRIM(ENTRY(2,c-chave, "|"))
                               AND ttSummaryInventoryBalanceAux.lote        = TRIM(ENTRY(3,c-chave, "|"))
                               AND ttSummaryInventoryBalanceAux.cod-refer   = TRIM(ENTRY(4,c-chave, "|")) NO-ERROR.
                        IF AVAILABLE ttSummaryInventoryBalanceAux THEN                
                            ASSIGN ttSummaryInventoryBalanceAux.qt-a-atender = ttSummaryInventoryBalanceAux.qt-a-atender + de-qtd-atender
                                   de-qtd-atender = 0.
                    END.
    
                    /*Item n’o possui saldo suficiente em estoque*/
                    IF NOT CAN-FIND(FIRST rowErrors) AND de-qtd-atender > 0 THEN
                        RUN createRowErrors IN THIS-PROCEDURE(INPUT 1, INPUT 27007, INPUT ""). /* Item sem saldo disponivel para atender requisi?’o  */
    
                END.
                
            END. 
    
            IF NOT CAN-FIND(FIRST RowErrors) THEN DO:        
                IF VALID-HANDLE(h-ceapi400) THEN 
                    RUN materialRequisitionProcessing IN h-ceapi400(
                        INPUT TODAY,
                        INPUT NO, /* FECHAR REQUISICAO */
                        INPUT TABLE ttSummaryInventoryBalanceAux,
                        OUTPUT TABLE RowErrors
                    ).
            END.
    
            /*Cria mensagem de requisi?’o atendida com sucesso*/
            FIND FIRST rowErrors NO-LOCK NO-ERROR.
            IF NOT AVAIL rowErrors THEN DO:
                
                {utp/ut-liter.i "Atendimento_realizado_com_sucesso" *}
    
                CREATE RowErrors.
                ASSIGN RowErrors.ErrorNumber     = 32388
                       RowErrors.ErrorDescription = TRIM(RETURN-VALUE).
                
            END.        
            
        END.
        
        IF VALID-HANDLE(h-ceapi400) THEN DO:
            DELETE OBJECT h-ceapi400.
            ASSIGN h-ceapi400 = ?.
        END.
    
        /*IF VALID-HANDLE(h-boin168) THEN DO:
            DELETE OBJECT h-boin168.
            ASSIGN h-boin168 = ?.
        END.*/
    
        RETURN "OK":U.
    END PROCEDURE.
    /* _UIB-CODE-BLOCK-END */
    &ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDeliveryDate DBOProgram
PROCEDURE setDeliveryDate:
    DEFINE INPUT  PARAMETER cItem          LIKE item.it-codigo           NO-UNDO.
    DEFINE INPUT  PARAMETER iTargetRequest LIKE requisicao.nr-requisicao NO-UNDO.
    DEFINE OUTPUT PARAMETER dDeliveryDate  LIKE it-requisicao.dt-entrega NO-UNDO.

    dDeliveryDate = TODAY.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setState DBOProgram 
PROCEDURE setState:
    DEFINE OUTPUT PARAMETER iState LIKE requisicao.estado NO-UNDO.

    iState = 2. /* NÆo Aprovado */

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setStatus DBOProgram 
PROCEDURE setStatus:
    DEFINE OUTPUT PARAMETER iStatus LIKE requisicao.situacao NO-UNDO.

    iStatus = 1. /* Aberta */

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDeliveryTime DBOProgram 
PROCEDURE setDeliveryTime:
    DEFINE OUTPUT PARAMETER cDeliveryTime LIKE it-requisicao.hra-entrega NO-UNDO.

    cDeliveryTime = "23:59":U.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setPriority DBOProgram 
PROCEDURE setPriority:
    DEFINE OUTPUT PARAMETER iPriority LIKE it-requisicao.prioridade-aprov NO-UNDO.

    //iPriority = 450. /* M‚dia */

    IF AVAILABLE RowObject THEN DO:
        FIND FIRST item-mat NO-LOCK
             WHERE item-mat.it-codigo = RowObject.it-codigo NO-ERROR.
             
        IF AVAILABLE item-mat THEN
            ASSIGN iPriority = item-mat.prioridade-aprov.
    END.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setSequence DBOProgram 
PROCEDURE setSequence:
    DEFINE OUTPUT PARAMETER iSequence LIKE it-requisicao.sequencia NO-UNDO.

    DEFINE VARIABLE iCount AS INTEGER NO-UNDO.
    DEFINE VARIABLE lUnit AS LOGICAL NO-UNDO.

    lUnit = CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-seq-req-solic":U AND funcao.ativo).

    iSequence = IF lUnit THEN 1 ELSE 10.
    FOR LAST it-requisicao FIELDS(sequencia) NO-LOCK
        WHERE it-requisicao.nr-requisicao = RowObject.nr-requisicao:
        iSequence = it-requisicao.sequencia + (IF lUnit THEN 1 ELSE 10).
    END.

    IF (iSequence > 999) THEN DO:
        DO iCount = 1 TO 999:
            IF CAN-FIND(FIRST it-requisicao
                WHERE it-requisicao.nr-requisicao = requisicao.nr-requisicao
                  AND it-requisicao.sequencia = iCount
            ) THEN DO:
                iSequence = 1.
            END.
            ELSE DO:
                iSequence = iCount.
                LEAVE.
            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDefaults DBOProgram 
PROCEDURE setDefaults:
    RUN setState (OUTPUT RowObject.estado).

    RUN setStatus (OUTPUT RowObject.situacao).

    RUN setSequence (OUTPUT RowObject.sequencia).

    RUN setDeliveryTime (OUTPUT RowObject.hra-entrega).

    RUN setPriority(OUTPUT RowObject.prioridade-aprov).

    RUN setDeliveryDate(INPUT ?, INPUT ?, OUTPUT RowObject.dt-entrega).

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setRequestedQuantity DBOProgram 
PROCEDURE setRequestedQuantity:
    DEFINE OUTPUT PARAMETER iRequestedQuantity LIKE it-requisicao.qt-a-atender NO-UNDO.

    IF NOT AVAIL RowObject THEN FIND RowObject.
    iRequestedQuantity = RowObject.qt-a-atender.

    {cdp/finditem.i RowObject.it-codigo}
    IF (AVAIL item) AND (item.tipo-con-est = 2) THEN iRequestedQuantity = 1. /* N£mero de S‚rie */

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setAdditionalDescription DBOProgram 
PROCEDURE setAdditionalDescription:
    DEFINE OUTPUT PARAMETER cDescription LIKE it-requisicao.narrativa NO-UNDO.

    {cdp/findnarrativa.i RowObject.it-codigo}
    IF (AVAIL narrativa) THEN cDescription = narrativa.descricao.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setUtilizationCode DBOProgram 
PROCEDURE setUtilizationCode:
    DEFINE OUTPUT PARAMETER cUtilizationCode AS CHARACTER NO-UNDO.

    IF NOT AVAIL RowObject THEN FIND RowObject.
    cUtilizationCode = SUBSTRING(RowObject.char-2,1,12).

    {cdp/findrequisicao.i RowObject.nr-requisicao}
    IF NOT AVAIL requisicao THEN RETURN "NOK":U.

    IF (RowObject.num-ord-inv = 0 OR RowObject.num-ord-inv = ?) THEN DO:

        {cdp/finditemuniestab.i RowObject.it-codigo requisicao.cod-estabel}
        IF AVAIL item-uni-estab AND item-uni-estab.altera-conta = FALSE THEN DO:

            FIND FIRST usuar-mater
            WHERE usuar-mater.cod-usuario = requisicao.nome-abrev EXCLUSIVE-LOCK NO-ERROR.
            FIND CURRENT usuar-mater NO-LOCK NO-ERROR.

            IF AVAIL usuar-mater AND SUBSTRING(usuar-mater.char-1,1,1) = "Y":U THEN DO: /* Utilizacoes Material */

                {cdp/findnaturezadespesa.i item-uni-estab.nat-despesa}
                IF AVAIL natureza-despesa THEN DO:

                    FOR FIRST utiliz-natu-despes FIELDS(cod-utiliz)
                    WHERE (utiliz-natu-despes.cod-nat-despesa = natureza-despesa.nat-despesa) NO-LOCK:

                        {cdp/findutilizacaomater.i utiliz-natu-despes.cod-utiliz}
                        IF AVAIL utilizacao-mater THEN cUtilizationCode = TRIM(utilizacao-mater.cod-utiliz).
                    END.
                END.
            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setAccountsByInvestmentOrder DBOProgram 
PROCEDURE setAccountsByInvestmentOrder:
    DEFINE OUTPUT PARAMETER cAccount LIKE it-requisicao.ct-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER cSubAccount LIKE it-requisicao.sc-codigo NO-UNDO.

    DEFINE VARIABLE lFind AS LOGICAL NO-UNDO.

    {cdp/findparamglobal.i}
    IF (NOT AVAIL param-global) THEN RETURN "NOK":U.

    {cdp/findrequisicao.i RowObject.nr-requisicao}
    IF (AVAIL requisicao) THEN DO:

        {cdp/findestabelec.i requisicao.cod-estabel}
        IF (AVAIL estabelec) THEN DO:

            IF CONNECTED("mginv":U) AND (param-global.modulo-in) THEN DO:
                RUN inp/in2201.p (
                    INPUT  estabelec.ep-codigo,
                    INPUT  RowObject.num-ord-inv,
                    INPUT  YES,
                    OUTPUT lFind,
                    OUTPUT cAccount,
                    OUTPUT cSubAccount
                ).

                IF (RETURN-VALUE = "NOK":U) THEN DO:
                    cAccount = "":U.
                    cSubAccount = "":U.
                    RETURN "NOK":U.
                END.
            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setOpSeq DBOProgram 
PROCEDURE setOpSeq:
    DEFINE OUTPUT PARAMETER iOpSeq LIKE it-requisicao.op-seq NO-UNDO.

    FIND FIRST ord-prod
    WHERE ord-prod.nr-ord-produ = RowObject.nr-ord-produ
    NO-LOCK NO-ERROR.

    FIND FIRST oper-ord
    WHERE oper-ord.nr-ord-produ = ord-prod.nr-ord-produ
    AND oper-ord.cod-roteiro <> ""
    NO-LOCK NO-ERROR.

    if AVAIL oper-ord then
    ASSIGN iOpSeq = oper-ord.op-codigo.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setRoteiro DBOProgram 
PROCEDURE setRoteiro:
    DEFINE OUTPUT PARAMETER setRoteiro LIKE it-requisicao.cod-roteiro NO-UNDO.

    FIND FIRST ord-prod
    WHERE ord-prod.nr-ord-produ = RowObject.nr-ord-produ
    NO-LOCK NO-ERROR.

    FIND FIRST oper-ord
    WHERE oper-ord.nr-ord-produ = ord-prod.nr-ord-produ
    AND oper-ord.cod-roteiro <> ""
    NO-LOCK NO-ERROR.

    if AVAIL oper-ord then
    ASSIGN setRoteiro = oper-ord.cod-roteiro.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setItemPai DBOProgram 
PROCEDURE setItemPai:
    DEFINE OUTPUT PARAMETER setItemPai LIKE it-requisicao.item-pai NO-UNDO.

    FIND FIRST ord-prod
    WHERE ord-prod.nr-ord-produ = RowObject.nr-ord-produ
    NO-LOCK NO-ERROR.

    ASSIGN setItemPai = ord-prod.it-codigo.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setAccount DBOProgram 
PROCEDURE setAccount:
    DEFINE OUTPUT PARAMETER cAccount LIKE it-requisicao.ct-codigo NO-UNDO.
    
    DEFINE VARIABLE cSubAccount LIKE it-requisicao.sc-codigo NO-UNDO.

    IF (RowObject.num-ord-inv <> 0) THEN DO:
        RUN setAccountsByInvestmentOrder (OUTPUT cAccount, OUTPUT cSubAccount). 
    END.
    ELSE IF (RowObject.nr-ord-produ <> 0) THEN DO:
           FIND FIRST ord-prod
                    WHERE ord-prod.nr-ord-produ = RowObject.nr-ord-produ
                NO-LOCK NO-ERROR.

            IF AVAIL ord-prod THEN DO:
                cAccount = ord-prod.ct-codigo.
            END.
    END.
    ELSE DO:
        {cdp/findrequisicao.i RowObject.nr-requisicao}
        IF AVAIL requisicao THEN DO:

            {cdp/finditemuniestab.i RowObject.it-codigo requisicao.cod-estabel}
            IF AVAIL item-uni-estab AND item-uni-estab.altera-conta = FALSE THEN DO:

                FIND FIRST usuar-mater
                WHERE usuar-mater.cod-usuario = requisicao.nome-abrev EXCLUSIVE-LOCK NO-ERROR.
                FIND CURRENT usuar-mater NO-LOCK NO-ERROR.
                
                IF AVAIL usuar-mater AND SUBSTRING(usuar-mater.char-1,1,1) = "Y":U THEN DO: /* Utilizacoes Material */

                    {cdp/findnaturezadespesa.i item-uni-estab.nat-despesa}
                    IF AVAIL natureza-despesa THEN DO:

                        FOR FIRST utiliz-natu-despes FIELDS(ct-codigo) NO-LOCK
                            WHERE utiliz-natu-despes.cod-nat-despesa = natureza-despesa.nat-despesa
                              AND utiliz-natu-despes.cod-utiliz      = SUBSTRING(RowObject.char-2,1,12):
                            cAccount = utiliz-natu-despes.ct-codigo.
                        END.
                    END.
                END.
                ELSE DO:
                    {cdp/findnaturezadespesa.i item-uni-estab.nat-despesa}
                    IF AVAIL natureza-despesa THEN DO:
                        cAccount = natureza-despesa.ct-codigo.
                    END.
                END.
            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setSubAccount DBOProgram 
PROCEDURE setSubAccount:
    DEFINE OUTPUT PARAMETER cSubAccount LIKE it-requisicao.sc-codigo NO-UNDO.

    IF NOT AVAIL RowObject THEN FIND FIRST RowObject.
    cSubAccount = RowObject.sc-codigo.

    DEFINE VARIABLE i-empresa AS CHARACTER NO-UNDO. /* cd9970.i */
    DEFINE VARIABLE lUseCostCenter AS LOGICAL NO-UNDO.
    DEFINE VARIABLE cAccount AS CHARACTER NO-UNDO.
    DEFINE VARIABLE hUtb742za AS HANDLE NO-UNDO.

    IF (RowObject.num-ord-inv <> 0) THEN DO:
        IF cSubAccount = "":U THEN
            RUN setAccountsByInvestmentOrder (OUTPUT cAccount, OUTPUT cSubAccount).
    END.
    ELSE IF (RowObject.nr-ord-produ <> 0) THEN DO:
        FIND FIRST ord-prod
            WHERE ord-prod.nr-ord-produ = RowObject.nr-ord-produ
            NO-LOCK NO-ERROR.

        IF AVAIL ord-prod THEN DO:
            IF cSubAccount = "":U THEN
                cSubAccount = ord-prod.sc-codigo.
        END.
    END.
    ELSE DO:
        
        {cdp/findrequisicao.i RowObject.nr-requisicao}
        IF (AVAIL requisicao) THEN DO:

            {cdp/finditemuniestab.i RowObject.it-codigo requisicao.cod-estabel}
            IF (AVAIL item-uni-estab) AND (NOT item-uni-estab.altera-conta) THEN DO:

                IF NOT VALID-HANDLE(hUtb742za) THEN DO:
                    RUN prgint/utb/utb742za.py PERSISTENT SET hUtb742za.
                END.

                {cdp/cd9970.i requisicao.cod-estabel}
                RUN pi_verifica_utilizacao_ccusto IN hUtb742za (
                    INPUT  i-empresa,
                    INPUT  requisicao.cod-estabel,
                    INPUT  "",
                    INPUT  RowObject.ct-codigo,
                    INPUT  TODAY,
                    OUTPUT lUseCostCenter,
                    OUTPUT TABLE tt_log_erro
                ).

                IF (lUseCostCenter) THEN DO:
                    IF cSubAccount = "":U THEN DO:
                        FIND FIRST usuar-mater
                        WHERE usuar-mater.cod-usuario = requisicao.nome-abrev EXCLUSIVE-LOCK NO-ERROR.
                        FIND CURRENT usuar-mater NO-LOCK NO-ERROR.
                        IF (AVAIL usuar-mater) THEN 
                            assign cSubAccount = usuar-mater.sc-codigo.
                    END.
                END.
                ELSE 
                    assign cSubAccount = "":U.
            END.
        END.
    END.

    RETURN "OK":U.

    FINALLY:
        DELETE OBJECT hUtb742za NO-ERROR.
    END FINALLY.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setMeasurementUnit DBOProgram 
PROCEDURE setMeasurementUnit:
    DEFINE OUTPUT PARAMETER cMeasurementUnit LIKE it-requisicao.un NO-UNDO.

    {cdp/findparammat.i}
    IF (AVAIL param-mat) AND (param-mat.ind-sit-un = 2) THEN DO: /* Default Item */
        {cdp/finditem.i RowObject.it-codigo}
        IF (AVAIL item) THEN DO:
            cMeasurementUnit = item.un.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getAveragePrice DBOProgram 
PROCEDURE getAveragePrice:
    DEFINE OUTPUT PARAMETER dAveragePrice LIKE it-requisicao.preco-unit NO-UNDO.

    {cdp/findrequisicao.i RowObject.nr-requisicao}
    IF (AVAIL requisicao) THEN DO:

        {cdp/findestabmat.i requisicao.cod-estabel}
        IF (AVAIL estab-mat) THEN DO:

            {cdp/finditemestab.i RowObject.it-codigo requisicao.cod-estabel}
            IF AVAIL (item-estab) THEN DO:

                IF (estab-mat.custo-contab = 1) THEN DO: /* Mensal */
                    dAveragePrice = (
                        item-estab.val-unit-mat-m[1] +
                        item-estab.val-unit-ggf-m[1] +
                        item-estab.val-unit-mob-m[1]
                    ).
                END.
                ELSE IF (estab-mat.custo-contab = 2) THEN DO: /* On-line */
                    dAveragePrice = (
                        item-estab.val-unit-mat-o[1] +
                        item-estab.val-unit-ggf-o[1] +
                        item-estab.val-unit-mob-o[1]
                    ).
                END.
            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getBasePrice DBOProgram 
PROCEDURE getBasePrice:
    DEFINE OUTPUT PARAMETER dBasePrice LIKE it-requisicao.preco-unit NO-UNDO.

    {cdp/findrequisicao.i RowObject.nr-requisicao}
    IF (AVAIL requisicao) THEN DO:

        {cdp/finditem.i RowObject.it-codigo}
        IF (AVAIL item) THEN dBasePrice = item.preco-base.

        {cdp/finditemuniestab.i RowObject.it-codigo requisicao.cod-estabel}
        IF (AVAIL item-uni-estab) THEN dBasePrice = item-uni-estab.preco-base.
    END.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLastReceiptPrice DBOProgram 
PROCEDURE getLastReceiptPrice:
    DEFINE OUTPUT PARAMETER dLastReceiptPrice LIKE it-requisicao.preco-unit NO-UNDO.

    {cdp/findrequisicao.i RowObject.nr-requisicao}
    IF (AVAIL requisicao) THEN DO:

        {cdp/finditem.i RowObject.it-codigo}
        IF (AVAIL item) THEN dLastReceiptPrice = item.preco-ul-ent.

        {cdp/finditemuniestab.i RowObject.it-codigo requisicao.cod-estabel}
        IF (AVAIL item-uni-estab) THEN dLastReceiptPrice = item-uni-estab.preco-ul-ent.
    END.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getReplacementPrice DBOProgram 
PROCEDURE getReplacementPrice:
    DEFINE OUTPUT PARAMETER dReplacementPrice LIKE it-requisicao.preco-unit NO-UNDO.

    {cdp/findrequisicao.i RowObject.nr-requisicao}
    IF (AVAIL requisicao) THEN DO:

        {cdp/finditem.i RowObject.it-codigo}
        IF (AVAIL item) THEN dReplacementPrice = item.preco-repos.

        {cdp/finditemuniestab.i RowObject.it-codigo requisicao.cod-estabel}
        IF (AVAIL item-uni-estab) THEN dReplacementPrice = item-uni-estab.preco-repos.
    END.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setUnitPrice DBOProgram 
PROCEDURE setUnitPrice:
    DEFINE OUTPUT PARAMETER dUnitPrice LIKE it-requisicao.preco-unit NO-UNDO.

    {cdp/findrequisicao.i RowObject.nr-requisicao}
    IF (AVAIL requisicao) THEN DO:

        {cdp/findusuarmater.i requisicao.nome-abrev}
        IF (AVAIL usuar-mater) THEN DO:

            CASE usuar-mater.tp-preco:
                WHEN 1 THEN DO: /* Pre‡o M‚dio */
                    RUN getAveragePrice (OUTPUT dUnitPrice).
                    IF (dUnitPrice = 0) THEN RUN getLastReceiptPrice (OUTPUT dUnitPrice).
                    IF (dUnitPrice = 0) THEN RUN getReplacementPrice (OUTPUT dUnitPrice).
                    IF (dUnitPrice = 0) THEN RUN getBasePrice (OUTPUT dUnitPrice).
                    IF (dUnitPrice = 0) THEN dUnitPrice = 1.
                END.
                WHEN 2 THEN DO: /* Pre‡o Base */
                    RUN getBasePrice (OUTPUT dUnitPrice).
                    IF (dUnitPrice = 0) THEN RUN getLastReceiptPrice (OUTPUT dUnitPrice).
                    IF (dUnitPrice = 0) THEN RUN getReplacementPrice (OUTPUT dUnitPrice).
                    IF (dUnitPrice = 0) THEN dUnitPrice = 1.
                END.
                WHEN 3 THEN DO: /* Pre‡o Reposi‡Æo */
                    RUN getReplacementPrice (OUTPUT dUnitPrice).
                    IF (dUnitPrice = 0) THEN RUN getLastReceiptPrice (OUTPUT dUnitPrice).
                    IF (dUnitPrice = 0) THEN RUN getBasePrice (OUTPUT dUnitPrice).
                    IF (dUnitPrice = 0) THEN dUnitPrice = 1.
                END.
                WHEN 4 THEN DO: /* Pre‡o éltima Entrada */
                    RUN getLastReceiptPrice (OUTPUT dUnitPrice).
                    IF (dUnitPrice = 0) THEN RUN getReplacementPrice (OUTPUT dUnitPrice).
                    IF (dUnitPrice = 0) THEN RUN getBasePrice (OUTPUT dUnitPrice).
                    IF (dUnitPrice = 0) THEN dUnitPrice = 1.
                END.
            END CASE.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setUnitPriceItem DBOProgram 
PROCEDURE setUnitPriceItem:
    DEFINE OUTPUT PARAMETER dUnitPrice LIKE it-requisicao.preco-unit NO-UNDO.

    {cdp/findrequisicao.i RowObject.nr-requisicao}
    IF (AVAIL requisicao) THEN DO:
        IF (requisicao.tp-requis = 2) THEN DO: /* Solicita‡Æo Compra */

            {cdp/finditem.i RowObject.it-codigo}
            IF (AVAIL item) THEN DO:
                IF (item.tipo-contr = 4) THEN DO: /* D‚bito Direto */

                    {cdp/findusuarmater.i requisicao.nome-abrev}
                    IF (AVAIL usuar-mater) AND (usuar-mater.log-suger-preco-item-db-diret) THEN DO:
                        RUN setUnitPrice (OUTPUT dUnitPrice).
                    END.
                END.
                ELSE DO:
                    IF ((RowObject.num-ord-inv) = 0 OR (RowObject.num-ord-inv = ?))
                        OR ((RowObject.preco-unit = 0) OR (RowObject.preco-unit = ?))
                    THEN DO:
                        RUN setUnitPrice (OUTPUT dUnitPrice).
                    END.
                END.
            END.
        END.
        ELSE DO:
            RUN setUnitPrice (OUTPUT dUnitPrice).
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setStockBalance DBOProgram 
PROCEDURE setStockBalance:
    DEFINE OUTPUT PARAMETER dStockBalance LIKE it-requisicao.dec-2 NO-UNDO.

    {cdp/findrequisicao.i RowObject.nr-requisicao}
    IF (AVAIL requisicao) THEN DO:

        {cdp/finditem.i RowObject.it-codigo}
        IF (AVAIL item) THEN DO:

            FOR EACH saldo-estoq FIELDS(cod-depos cod-refer qtidade-atu qt-alocada qt-aloc-prod)
                WHERE (saldo-estoq.it-codigo = item.it-codigo) AND (saldo-estoq.cod-estabel = requisicao.cod-estabel) NO-LOCK:

                IF NOT CAN-FIND(
                    FIRST deposito
                        WHERE (deposito.cod-depos    = saldo-estoq.cod-depos)
                          AND (deposito.cons-saldo   = TRUE)
                          AND (deposito.ind-tipo-dep = 1) /* Interno */
                ) THEN NEXT.

                IF (item.tipo-con-est = 4) AND (saldo-estoq.cod-refer <> RowObject.cod-refer) THEN NEXT.

                dStockBalance = dStockBalance + (saldo-estoq.qtidade-atu - saldo-estoq.qt-alocada - saldo-estoq.qt-aloc-prod).
            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setBusinessUnit DBOProgram 
PROCEDURE setBusinessUnit:
    DEFINE OUTPUT PARAMETER TABLE FOR ttUnidNegRequis.

    DEFINE VARIABLE cCodUnidNegoc LIKE unid-neg-requis.cod_unid_negoc NO-UNDO.
    DEFINE VARIABLE hCdapi024 AS HANDLE NO-UNDO.
    DEFINE VARIABLE hBoiv029 AS HANDLE NO-UNDO.

    {cdp/findrequisicao.i RowObject.nr-requisicao}
    IF (AVAIL requisicao) THEN DO:

        IF (l-unidade-negocio AND (requisicao.tp-requis = 1)) OR /* Requisi‡Æo de Estoque */
            (l-mat-unid-negoc AND ((requisicao.tp-requis = 2) OR (requisicao.tp-requis = 3))) /* Solicita‡Æo de Compra ou Solicita‡Æo de Cota‡Æo */
        THEN DO:

            IF (RowObject.num-ord-inv <> 0) THEN DO:
                IF NOT VALID-HANDLE(hBoiv029) THEN DO:
                    RUN ivbo/boiv029.p PERSISTENT SET hBoiv029.
                END.

                IF VALID-HANDLE(hBoiv029) THEN DO:
                    RUN retornaMatrizUnidNegoc IN hBoiv029 (
                        INPUT  RowObject.num-ord-inv,
                        OUTPUT TABLE tt-unid-neg-inv,
                        OUTPUT TABLE tt-erro-inv
                    ).

                    IF NOT CAN-FIND(FIRST tt-erro) THEN DO:
                        FOR EACH tt-unid-neg-inv:
                            CREATE ttUnidNegRequis.
                            ASSIGN ttUnidNegRequis.cod_unid_negoc = tt-unid-neg-inv.cod-unid-neg
                                   ttUnidNegRequis.perc-unid-neg  = tt-unid-neg-inv.perc-rateio.

                            {cdp/findunidnegoc.i ttUnidNegRequis.cod_unid_negoc}
                            IF AVAIL unid-negoc THEN ASSIGN ttUnidNegRequis.char-1 = unid-negoc.des-unid-negoc.
                        END.
                    END.
                END.
            END.
            ELSE IF (RowObject.nr-ord-produ <> 0) THEN DO:
                 FIND FIRST ord-prod
                    WHERE ord-prod.nr-ord-produ = RowObject.nr-ord-produ
                    NO-LOCK NO-ERROR.

                IF AVAIL ord-prod THEN DO:
                    cCodUnidNegoc = ord-prod.cod-unid-negoc.
                    
                    CREATE ttUnidNegRequis.
                    ASSIGN ttUnidNegRequis.cod_unid_negoc = cCodUnidNegoc
                           ttUnidNegRequis.perc-unid-neg  = 100.

                    {cdp/findunidnegoc.i ttUnidNegRequis.cod_unid_negoc}
                    IF AVAIL unid-negoc THEN ASSIGN ttUnidNegRequis.char-1 = unid-negoc.des-unid-negoc.
                END.
            END.
            ELSE DO:

                IF NOT VALID-HANDLE(hCdapi024) THEN DO:
                    RUN cdp/cdapi024.p PERSISTENT SET hCdapi024.
                END.

                IF VALID-HANDLE(hCdapi024) THEN DO:
                    RUN RetornaUnidadeNegocioExternaliz IN hCdapi024 (
                        INPUT  requisicao.cod-estabel,
                        INPUT  RowObject.it-codigo,
                        INPUT  "", /* Dep¢sito */
                        OUTPUT cCodUnidNegoc
                    ).

                    CREATE ttUnidNegRequis.
                    ASSIGN ttUnidNegRequis.cod_unid_negoc = cCodUnidNegoc
                           ttUnidNegRequis.perc-unid-neg  = 100.

                    {cdp/findunidnegoc.i ttUnidNegRequis.cod_unid_negoc}
                    IF AVAIL unid-negoc THEN ASSIGN ttUnidNegRequis.char-1 = unid-negoc.des-unid-negoc.
                END.
                
            END.
        END.
    END.

    RETURN "OK":U.

    FINALLY:
        DELETE OBJECT hCdapi024 NO-ERROR.
        DELETE OBJECT hBoiv029 NO-ERROR.
    END FINALLY.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setCompany DBOProgram 
PROCEDURE setCompany:
    DEFINE OUTPUT PARAMETER cCompany LIKE it-requisicao.ep-codigo INITIAL ? NO-UNDO.

    IF (RowObject.num-ord-inv <> 0 AND RowObject.num-ord-inv <> ?) THEN DO:

        {cdp/findparamglobal.i}
        IF AVAIL param-global AND param-global.modulo-in THEN DO:

            {cdp/findrequisicao.i RowObject.nr-requisicao}
            IF AVAIL requisicao THEN DO:

                {cdp/findestabelec.i requisicao.cod-estabel}
                IF AVAIL estabelec THEN DO:
                    cCompany = estabelec.ep-codigo.
                END.
            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setCodRefer DBOProgram 
PROCEDURE setCodRefer:
    DEFINE OUTPUT PARAMETER cCodRefer LIKE it-requisicao.cod-refer NO-UNDO.
    
    {cdp/finditem.i RowObject.it-codigo}
    IF NOT AVAIL item THEN RETURN "NOK":U.

    if item.tipo-con-est <> 4 then
        assign cCodRefer = "":U.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE leaveItem DBOProgram 
PROCEDURE leaveItem :

    DEFINE OUTPUT PARAMETER TABLE FOR ttUnidNegRequis.

    DEFINE VARIABLE cUtilizationCode AS CHARACTER NO-UNDO.

    IF can-find(FIRST param-mat WHERE param-mat.ind-unid-neg <> NO) THEN
        ASSIGN l-unidade-negocio = YES.
    ELSE
        ASSIGN l-unidade-negocio = NO.   

    RUN setRequestedQuantity (OUTPUT RowObject.qt-a-atender).

    RUN setCodRefer(OUTPUT RowObject.cod-refer).

    RUN setAdditionalDescription (OUTPUT RowObject.narrativa).

    IF (RowObject.char-2 = ?) THEN ASSIGN RowObject.char-2 = "":U.
    RUN setUtilizationCode (OUTPUT cUtilizationCode).
    OVERLAY(RowObject.char-2,1,12) = cUtilizationCode.

    RUN setAccount (OUTPUT RowObject.ct-codigo).

    RUN setSubAccount (OUTPUT RowObject.sc-codigo).

    RUN setMeasurementUnit (OUTPUT RowObject.un).

    RUN setUnitPriceItem (OUTPUT RowObject.preco-unit).

    RUN setStockBalance (OUTPUT RowObject.dec-2).

    IF l-unidade-negocio THEN
        RUN setBusinessUnit (OUTPUT TABLE ttUnidNegRequis).

    RUN setPriority(OUTPUT RowObject.prioridade-aprov).

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE leaveNumOrdProd DBOProgram 
PROCEDURE leaveNumOrdProd :

    DEFINE OUTPUT PARAMETER TABLE FOR ttUnidNegRequis.

    IF can-find(FIRST param-mat WHERE param-mat.ind-unid-neg <> NO) THEN
        ASSIGN l-unidade-negocio = YES.
    ELSE
        ASSIGN l-unidade-negocio = NO.   

    RUN setAccount (OUTPUT RowObject.ct-codigo). 

    RUN setSubAccount (OUTPUT RowObject.sc-codigo). 

    RUN setOpSeq (OUTPUT RowObject.op-seq).

    RUN setRoteiro (OUTPUT RowObject.cod-roteiro).

    RUN setItemPai (OUTPUT RowObject.item-pai).

    IF l-unidade-negocio THEN
        RUN setBusinessUnit (OUTPUT TABLE ttUnidNegRequis). 

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE leaveInvestmentOrder DBOProgram 
PROCEDURE leaveInvestmentOrder:
    DEFINE OUTPUT PARAMETER TABLE FOR ttUnidNegRequis.

    DEFINE VARIABLE cUtilizationCode AS CHARACTER NO-UNDO.

    RUN setCompany (OUTPUT RowObject.ep-codigo).

    IF (RowObject.char-2 = ?) THEN ASSIGN RowObject.char-2 = "":U.
    RUN setUtilizationCode (OUTPUT cUtilizationCode).
    OVERLAY(RowObject.char-2,1,12) = cUtilizationCode.

    RUN setAccount (OUTPUT RowObject.ct-codigo).

    RUN setSubAccount (OUTPUT RowObject.sc-codigo).

    RUN setUnitPriceItem (OUTPUT RowObject.preco-unit).

    RUN setBusinessUnit (OUTPUT TABLE ttUnidNegRequis).

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE leaveAccount DBOProgram 
PROCEDURE leaveAccount:
    DEFINE OUTPUT PARAMETER TABLE FOR ttUnidNegRequis.

    RUN setSubAccount (OUTPUT RowObject.sc-codigo).

    RUN setBusinessUnit (OUTPUT TABLE ttUnidNegRequis).

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE leaveSubAccount DBOProgram 
PROCEDURE leaveSubAccount:
    DEFINE OUTPUT PARAMETER TABLE FOR ttUnidNegRequis.

    RUN setSubAccount (OUTPUT RowObject.sc-codigo).

    RUN setBusinessUnit (OUTPUT TABLE ttUnidNegRequis).

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE leaveUtilizationCode DBOProgram 
PROCEDURE leaveUtilizationCode:
    DEFINE OUTPUT PARAMETER TABLE FOR ttUnidNegRequis.

	RUN setAccount (OUTPUT RowObject.ct-codigo).

	RUN setSubAccount (OUTPUT RowObject.sc-codigo).

    RUN setBusinessUnit (OUTPUT TABLE ttUnidNegRequis).

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE leaveUtilizationCode DBOProgram 
PROCEDURE leaveReference:
    DEFINE OUTPUT PARAMETER TABLE FOR ttUnidNegRequis.

    RUN setStockBalance (OUTPUT RowObject.dec-2).

    RUN setBusinessUnit (OUTPUT TABLE ttUnidNegRequis).

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDefaultRequester DBOProgram 
PROCEDURE getDefaultRequester:
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER cNomeAbrev LIKE requisicao.nome-abrev NO-UNDO.

    IF c-seg-usuario <> "" THEN
        cNomeAbrev = c-seg-usuario.
    ELSE
        cNomeAbrev = v_cod_usuar_corren.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
