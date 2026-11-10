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
{include/i-prgvrs.i BOIN738 2.00.00.095 } /*** "010095" 17/06/2025 16:40:52 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin738 MUT}
&ENDIF

{cdp/cdcfgmnt.i}
{cdp/cd9911.i}
{cdp/cd0666.i} /*Temp-Table de erro para retorno de erro da unidade de neg¢cio*/

{include/i-epc200.i boin738} 

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
&GLOBAL-DEFINE DBOName BOIN738
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName req-ord-produc
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

/******************************************************************************************
** TECNICA SEGURANCA ESTABELECIMENTO
******************************************************************************************/
&Scoped-define REPOSITION-PROCEDURE repositionEstab /*procedimento responsavel pelo reposition*/
&Scoped-define SEGUR-ESTAB-ATRIBUTE cod-estabel /*atributo que contem o estabelecimento na query*/

&Scoped-define KEY-PHRASE TRUE
{include/i-estab-security.i}

/******************************************************************************************
** TECNICA SEGURANCA ESTABELECIMENTO
******************************************************************************************/

/*:T--- Include com defini‡Æo da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com 
      extensÆo .i ---*/
{inbo/boin738.i RowObject}

{cdp/cdcfgmat.i}

/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
DEFINE BUFFER bf2{&TableName} FOR {&TableName}.
DEFINE VARIABLE iNrIni     like {&TableName}.nr-ord-produ  NO-UNDO.
DEFINE VARIABLE iNrFim     LIKE {&TableName}.nr-ord-produ  NO-UNDO.
DEFINE VARIABLE iReqIni    like {&TableName}.nr-requisicao NO-UNDO.
DEFINE VARIABLE iReqFim    like {&TableName}.nr-requisicao NO-UNDO.
DEFINE VARIABLE iTarefaIni like {&TableName}.num-tarefa    NO-UNDO.
DEFINE VARIABLE iTarefaFim like {&TableName}.num-tarefa    NO-UNDO.
DEFINE VARIABLE iSeqIni    like {&TableName}.sequencia     NO-UNDO.
DEFINE VARIABLE iSeqFim    like {&TableName}.sequencia     NO-UNDO.
DEFINE VARIABLE daDataIni  like {&TableName}.dat-trans     NO-UNDO.
DEFINE VARIABLE daDataFim  like {&TableName}.dat-trans     NO-UNDO.
DEFINE VARIABLE iNrOrdem   LIKE {&TableName}.nr-ord-produ  NO-UNDO.
DEFINE VARIABLE cPrograma  AS CHARACTER                    NO-UNDO.

DEFINE VARIABLE daPeriodoIni  like {&TableName}.dat-trans  INITIAL 01/01/1900   NO-UNDO.
DEFINE VARIABLE daPeriodoFim  like {&TableName}.dat-trans  INITIAL 12/31/9999   NO-UNDO.

/** Aprova‡Æo Eletr“nica **/
DEFINE VARIABLE i-tipo-doc AS INTEGER    NO-UNDO.
DEFINE VARIABLE l-pendente AS LOGICAL    NO-UNDO.
DEFINE VARIABLE l-conectado-ems5 AS LOGICAL INITIAL NO NO-UNDO.
DEFINE VARIABLE c-param     AS CHARACTER  NO-UNDO.

DEFINE VARIABLE h-abapi015 AS HANDLE NO-UNDO. /*** valida se frotas est  ativo ***/
DEFINE VARIABLE hBoSincroniz AS HANDLE NO-UNDO.

{cdp/cdunif001.i}
DEFINE VARIABLE cErroAux AS CHARACTER   NO-UNDO.

DEFINE TEMP-TABLE ttItRequisicao LIKE it-requisicao
     FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-erro-mla NO-UNDO
    FIELD i-sequen AS INTEGER
    FIELD cd-erro  AS INTEGER
    FIELD mensagem AS CHARACTER FORMAT "x(255)".

def new global shared var c-seg-usuario as char format "x(12)" no-undo.

{mip/ttMateriais.i} /* ttOmMateriais utilizada na Programa‡Æo da Manut */

/** Vari veis para Execu‡ao Or‡amentaria - MI **/
{cdp/cd1008.i}

run cdp/cd9902.p (input 3). /* Verifica se MV est  implantado */
IF  RETURN-VALUE = "OK":U THEN DO:
    {cdp/cd1008.i1} /* Vari veis para Execu‡ao Or‡amentaria - MV */
END.
    

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
         HEIGHT             = 20.21
         WIDTH              = 42.86.
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

define temp-table RowErrorsAux no-undo like RowErrors.
{method/svc/autentic/autentic.i         
            &vUserName="c-seg-usuario"}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeCreateRecord DBOProgram 
PROCEDURE beforeCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     beforeCreateRecord
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE BUFFER bf-ord-prod FOR ord-prod.

    /**
     * Seguran‡a por estabelecimento
     * Grava o c¢digo do estabelecimento da ordem na requisi‡Æo
     */
    FOR FIRST bf-ord-prod NO-LOCK
        WHERE bf-ord-prod.nr-ord-produ = RowObject.nr-ord-produ:
        ASSIGN RowObject.cod-estabel = bf-ord-prod.cod-estabel.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram 
PROCEDURE afterCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     afterCreateRecord
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN mnbo/bomni00307.p PERSISTENT SET hBoSincroniz.

    RUN adicionarSincroniz IN hBoSincroniz (INPUT "req-ord-produ":U,
                                            INPUT STRING(RowObject.nr-requisicao) + ";" + STRING(RowObject.sequencia),
                                            INPUT 1, /* Create */
                                            INPUT c-seg-usuario).

    RUN adicionarSincroniz IN hBoSincroniz (INPUT "ord-manut":U,
                                            INPUT STRING(RowObject.nr-ord-produ),
                                            INPUT 2, /* Update */
                                            INPUT c-seg-usuario). 

    IF VALID-HANDLE (hBoSincroniz) THEN
        DELETE OBJECT hBoSincroniz.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterUpdateRecord DBOProgram 
PROCEDURE afterUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     afterUpdateRecord
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN mnbo/bomni00307.p PERSISTENT SET hBoSincroniz.

    RUN adicionarSincroniz IN hBoSincroniz (INPUT "req-ord-produ":U,
                                            INPUT STRING(RowObject.nr-requisicao) + ";" + STRING(RowObject.sequencia),
                                            INPUT 2, /* Update */
                                            INPUT c-seg-usuario).

    RUN adicionarSincroniz IN hBoSincroniz (INPUT "ord-manut":U,
                                            INPUT STRING(RowObject.nr-ord-produ),
                                            INPUT 2, /* Update */
                                            INPUT c-seg-usuario). 

    IF VALID-HANDLE (hBoSincroniz) THEN
        DELETE OBJECT hBoSincroniz.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDeleteRecord DBOProgram 
PROCEDURE afterDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     afterDeleteRecord
  Parameters:  <none>
  Notes:       Override depois de deletar registro.
               Elimina‡Æo das tabelas de requisiÆo e item de requsi‡Æo.
------------------------------------------------------------------------------*/

    DEFINE VARIABLE l-pendente AS LOGICAL     NO-UNDO.
    
    if avail RowObject then do:
       /***Elimina os registros da tabela it-requisicao***/

        run piEliminaItRequisicao in this-procedure.
        
        IF RETURN-VALUE = "NOK":U THEN
           RETURN "NOK":U.
        /*** Se nÆo existir registros na tabela de it-requisicao para o registro corrente elimina registros da tabela de Requisi‡Æo***/
        if not can-find(first it-requisicao 
                        where it-requisicao.nr-requisicao = RowObject.nr-requisicao no-lock) then do:
            run piEliminaRequisicao in this-procedure.
            IF RETURN-VALUE = "NOK":U THEN
               RETURN "NOK":U.
        end.
        ELSE DO:
            FIND first requisicao
                where requisicao.nr-requisicao = RowObject.nr-requisicao NO-LOCK NO-ERROR.

            /**
             * Valida se existe alguma sequˆncia da solicita‡Æo de compra nÆo aprovada.
             * Se todas as sequˆncias estiverem aprovadas entÆo aprova a solicita‡Æo de compra.
             */
            if requisicao.tp-requis = 2 then DO:
                assign i-tipo-doc = 1
                       l-pendente = no.

                for each it-requisicao
                    where it-requisicao.nr-requisicao = requisicao.nr-requisicao
                    no-lock:
                    run cdp/cdapi172.p (i-tipo-doc, rowid(it-requisicao), output l-pendente).
                    if  l-pendente then leave.
                end.
        
                IF l-pendente = NO THEN DO:
                    FOR FIRST requisicao EXCLUSIVE-LOCK
                        WHERE requisicao.nr-requisicao = RowObject.nr-requisicao:
                        ASSIGN requisicao.estado = 1.
                    END.
        
                    RUN pi-msg-aprov.
                END.
            END.
        END.
    
        FIND FIRST it-requisicao 
              where (it-requisicao.situacao = 1 /* Aberta */
               or    it-requisicao.situacao = 3) /* Pendente Complemento */
               and   it-requisicao.nr-requisicao = RowObject.nr-requisicao no-lock no-error.
    
        IF AVAIL it-requisicao THEN DO:
            RUN piAprovaTotal (INPUT it-requisicao.nr-requisicao,
                               INPUT it-requisicao.sequencia,
                               INPUT RowObject.nr-ord-produ).
        END.        
    end.

    RUN mnbo/bomni00307.p PERSISTENT SET hBoSincroniz.

    RUN adicionarSincroniz IN hBoSincroniz (INPUT "req-ord-produ":U,
                                            INPUT STRING(RowObject.nr-requisicao) + ";" + STRING(RowObject.sequencia) + ";" + STRING(RowObject.nr-ord-produ),
                                            INPUT 3, /* Delete */
                                            INPUT c-seg-usuario).

    RUN adicionarSincroniz IN hBoSincroniz (INPUT "ord-manut":U,
                                            INPUT STRING(RowObject.nr-ord-produ),
                                            INPUT 2, /* Update */
                                            INPUT c-seg-usuario).

    IF VALID-HANDLE (hBoSincroniz) THEN
        DELETE OBJECT hBoSincroniz.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaDadosItem DBOProgram 
PROCEDURE buscaDadosItem :
/*------------------------------------------------------------------------------
  Purpose:     buscaDadosItem
  Parameters:  pItem        - Recebe o item seleciona
               pDescItem    - Retorna a descri‡Æo do Item
               pUnItem      - Retorna a unidade de medida do Item
               pTpCont      - Retorna o tipo de controle do item 
               pTpControle  - Retorna o valor do campo item.tipo-con-est
  Notes:       Busca informa‡äes do item.
------------------------------------------------------------------------------*/
DEF INPUT  PARAM pItem        LIKE ITEM.it-codigo    NO-UNDO.
DEF output PARAM pDescItem    LIKE ITEM.desc-item    NO-UNDO.
DEF output PARAM pUnItem      LIKE ITEM.un           NO-UNDO.
DEF output PARAM pTpCont      LIKE ITEM.tipo-contr   NO-UNDO.
DEF output PARAM pTpControle  LIKE item.tipo-con-est NO-UNDO.
/*** Busca o registro na tabela de Item***/
FOR FIRST ITEM FIELDS (it-codigo desc-item un tipo-contr tipo-con-est) 
    WHERE ITEM.it-codigo = pItem NO-LOCK:
    ASSIGN pDescItem   = ITEM.desc-item
           pUnItem     = ITEM.un
           pTpCont     = ITEM.tipo-contr
           pTpControle =  item.tipo-con-est.

END.


RETURN "Ok":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaData DBOProgram 
PROCEDURE buscaData :
/*------------------------------------------------------------------------------
  Purpose:     buscaData
  Parameters:  <none>
  Notes:       Recebe como parƒmetro a ordem de produ‡Æo e retorn a data de transsa‡Æo
------------------------------------------------------------------------------*/
DEF INPUT  PARAM pNrOrdProdu LIKE req-ord-produc.nr-ord-produ  NO-UNDO.
DEF INPUT  PARAM pTpRequis   LIKE  req-ord-produc.tp-requis    NO-UNDO.
/** Os dados iniciam como se nÆo existisse requisi‡Æo/solicita‡Æo **/
DEF OUTPUT PARAM pNrRequis   LIKE req-ord-produc.nr-requisicao NO-UNDO.
DEF OUTPUT PARAM pDAta       LIKE req-ord-produc.dat-trans     NO-UNDO.
DEF OUTPUT PARAM lAchou      AS LOGICAL                        NO-UNDO.

assign pNrRequis = 0
       pDAta     = today
       lAchou    = no.

/** Se o parametro Cria Nova Requisicao estiver marcado, sugere data requis igual today **/
IF CAN-FIND(FIRST mi-param-extens
    WHERE mi-param-extens.cdn-param = 113 AND mi-param-extens.des-valor = "Sim":U) THEN
        RETURN "OK":U.
            
/** Verifica se Encontra alguma Requisi‡Æo / Solicita‡Æo paara a OM **/
IF CAN-FIND (FIRST bf{&TableName}
             WHERE bf{&TableName}.nr-ord-produ = pNrOrdProdu
             and   bf{&TableName}.tp-requis    = pTpRequis no-lock) THEN DO:
    /** Percorre registros **/
    for each bf{&TableName} fields(nr-requisicao dat-trans)
        WHERE bf{&TableName}.nr-ord-produ = pNrOrdProdu
        and   bf{&TableName}.tp-requis    = pTpRequis no-lock
        break by bf{&TableName}.dat-trans desc:
        /** Verifica se a Requisi‡Æo est  aberta **/ 
        if can-find(first requisicao
                    where requisicao.nr-requisicao = bf{&TableName}.nr-requisicao
                    AND   requisicao.nome-abrev    = c-seg-usuario
                    and   requisicao.situacao      < 2 no-lock) then do:
            /** Busca £ltimo registro para atualizar a data **/
            FOR LAST bf2{&TableName} fields(dat-trans)
                WHERE bf2{&TableName}.nr-requisicao = bf{&TableName}.nr-requisicao NO-LOCK:
                ASSIGN lAchou    = YES
                       pData     = bf2{&TableName}.dat-trans
                       pNrRequis = bf{&TableName}.nr-requisicao.
                /** Sai do processamento para nÆo ler registros a mais **/
                return "OK":U.
            END.
        end.
    end.
END.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaDescricaoEqpto DBOProgram 
PROCEDURE buscaDescricaoEqpto :
/*------------------------------------------------------------------------------
  Purpose:     buscaDescricaoEqpto
  Parameters:  pEqpto, pDesc
  Notes:       Recebe o c¢digo do equipamento e retorna sua descri‡Æo     
------------------------------------------------------------------------------*/
DEF INPUT  PARAMETER pEqpto LIKE equipto.cd-equipto NO-UNDO.
DEF OUTPUT PARAMETER pDesc  LIKE equipto.descricao  NO-UNDO.

FOR FIRST equipto FIELDS (cd-equipto descricao)
    WHERE equipto.cd-equipto = pEqpto NO-LOCK:
    IF AVAIL equipto THEN
       ASSIGN pDesc = equipto.descricao.
    ELSE 
        pDesc = "":U.
END.
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaDescricaoTarefa DBOProgram 
PROCEDURE buscaDescricaoTarefa :
/*------------------------------------------------------------------------------
  Purpose:     buscaDescricaoTarefa
  Parameters:  pTarefa      = Recebe o c¢digo da tarefa  
               pDescTarefa  = Retorna a descri‡Æo da tarefa
  Notes:       Recebe o c¢digo da tarefa e retorna a descri‡Æo
------------------------------------------------------------------------------*/
def input  param pOrdem      like {&TableName}.nr-ord-produ no-undo.
def input  param pTarefa     like {&TableName}.num-tarefa no-undo.
def output param pDescTarefa as char no-undo.

for first ord-taref fields (cd-tarefa descricao nr-ord-produ )
     where ord-taref.nr-ord-produ = pOrdem 
     and   ord-taref.cd-tarefa    = pTarefa no-lock:
     assign pDescTarefa =  ord-taref.descricao.
end.
return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscadescricaoUn DBOProgram 
PROCEDURE buscadescricaoUn :
/*------------------------------------------------------------------------------
  Purpose:     buscadescricaoUn
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE  INPUT   PARAMETER pUn         LIKE tab-unidade.un        NO-UNDO. 
DEFINE  OUTPUT  PARAMETER pDescUn     LIKE tab-unidade.descricao NO-UNDO. 
FOR FIRST tab-unidade FIELDS (un descricao)
    WHERE tab-unidade.un = pUn NO-LOCK:
    IF AVAIL tab-unidade THEN
       ASSIGN pDescUn = tab-unidade.descricao.
    ELSE 
        ASSIGN pDescUn ="":U.

END.


RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaEqptoManutencao DBOProgram 
PROCEDURE buscaEqptoManutencao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input  param pNrOrdem   like {&TableName}.nr-ord-produ no-undo.
def output param pEqpto     like equipto.cd-equipto        no-undo.
def output param pDescEqpto like equipto.descricao         no-undo.

for first ord-manut FIELDS (cd-equipto nr-ord-produ)
     where ord-manut.nr-ord-produ = pNrOrdem no-lock:
     assign pEqpto = ord-manut.cd-equipto.
     FOR FIRST equipto FIELDS (cd-equipto descricao)
            WHERE equipto.cd-equipto = pEqpto NO-LOCK:
            IF AVAIL equipto THEN
               ASSIGN pDescEqpto = equipto.descricao.
            ELSE 
                pDescEqpto = "":U.
     END.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaEstado DBOProgram 
PROCEDURE buscaEstado :
/*------------------------------------------------------------------------------
  Purpose:     buscaEstado
  Parameters:  pNrOrdem - Numero da ordem
               pEstado  - Estado da Ordem de manuten‡Æo
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAM pNrOrdem  LIKE ord-manut.nr-ord-produ NO-UNDO. 
DEFINE OUTPUT PARAM pEstado   AS CHARACTER                NO-UNDO.

for first ord-manut fields(nr-ord-produ estado) 
    where ord-manut.nr-ord-produ = pNrOrdem no-lock:
    &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
        DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
        ASSIGN cAuxTraducao001 = {ininc/i01in271.i 04 ord-manut.estado}.
        run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                            INPUT "",
                            INPUT "").
        ASSIGN  pEstado = RETURN-VALUE.
    &else
        ASSIGN pEstado = {ininc/i01in271.i 04 ord-manut.estado}.
    &endif
end.

  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaRequisitante DBOProgram 
PROCEDURE buscaRequisitante :
/*------------------------------------------------------------------------------
  Purpose:     buscaRequisitante
  Parameters:  pNomeAbrev (Entrada) = Matr¡cula do Requisitante
               pNome      (Sa¡da)   = Nome do Requisitante
  Notes:       Retorna o nome do requisitante
------------------------------------------------------------------------------*/
DEF INPUT PARAM  pNomeAbrev LIKE it-requisicao.nome-abrev NO-UNDO.
DEF OUTPUT PARAM pNome      LIKE requisitante.nome        NO-UNDO.

ASSIGN pNome = "":U.

FOR FIRST requisitante FIELDS (nome)
    WHERE requisitante.nome-abrev = pNomeAbrev NO-LOCK:
    ASSIGN pNome = requisitante.nome.
end.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fecharRequisicao DBOProgram 
PROCEDURE fecharRequisicao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT  PARAM pNrRequisicao      LIKE {&TableName}.nr-requisicao NO-UNDO.
DEF INPUT  PARAM pNrSequencia       LIKE {&TableName}.sequencia     NO-UNDO.

&IF DEFINED(bf_mnt_ems206b) &THEN

    DEFINE BUFFER bf-it-requisicao FOR it-requisicao.

    FOR FIRST it-requisicao EXCLUSIVE-LOCK
        WHERE it-requisicao.nr-requisicao = pNrRequisicao
        AND   it-requisicao.sequencia     = pNrSequencia:
            ASSIGN it-requisicao.situacao     = 2
                   it-requisicao.qt-a-atender = 0.
    END.
        
    /** Valida‡Æo para fechar a requisicao se nÆo houver mais outros itens com situa‡Æo diferente de fechada **/
    IF AVAIL it-requisicao THEN DO:
        FIND CURRENT it-requisicao NO-LOCK NO-ERROR.
        BUFFER-COPY it-requisicao TO ttItRequisicao.       
                         
        IF (rowObject.origem = "MI" AND l-integra-material)
        OR (rowObject.origem = "MV" AND l-integra-mat-mmv) THEN DO:
            /** API de Execu‡ao Or‡amentaria MI/Frotas **/
            RUN cdp/cdapi282.p (INPUT ROWID(it-requisicao),   /** rowid it-requisicao                           **/                          
                                INPUT TABLE ttItRequisicao,   /** registro alterado                             **/                            
                                INPUT 3,                      /** funcao: 3-BeforeDeleteRecord Item-Requisicao  **/ 
                                INPUT rowObject.nr-ord-produ, /** Nœmero da Ordem de Manuten»’o Industrial      **/
                                INPUT ?,                      /** Rowid do registro antes de alterar            **/
                                OUTPUT TABLE RowErrors).      /** tt que retorna erro    */    
        END.
        
        IF  NOT CAN-FIND(FIRST bf-it-requisicao
                         WHERE bf-it-requisicao.nr-requisicao = it-requisicao.nr-requisicao
                           AND ROWID(bf-it-requisicao)       <> ROWID(it-requisicao)
                           AND bf-it-requisicao.situacao     <> 2) THEN DO:

            FIND requisicao WHERE
                 requisicao.nr-requisicao = it-requisicao.nr-requisicao EXCLUSIVE-LOCK NO-ERROR.
            IF  AVAIL requisicao THEN
                ASSIGN requisicao.situacao = 2.

            find current requisicao NO-LOCK no-error.
            find current it-requisicao NO-LOCK no-error.

       END.

    END.

&ENDIF


RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findReq DBOProgram 
PROCEDURE findReq :
/*------------------------------------------------------------------------------
  Purpose:     findReq
  Parameters:  <none>
  Notes:       Busca informa‡äesa da requisi‡Æo
------------------------------------------------------------------------------*/
def input  param pRequisicao       like requisicao.nr-requisicao no-undo.
def output param cEstab            as char no-undo.     
def output param cNome             as char no-undo.  
def output param iEstado           as int no-undo.  
def output param iSituacao         as int no-undo.

assign  cEstab                 =  "":U
        cNome                  =  "":U
        iEstado                =  2
        iSituacao              =  1.
/**Busca informa‡äes da Requisi‡Æo***/
if can-find (first requisicao 
             where requisicao.nr-requisicao = pRequisicao no-lock) then do:
    for first requisicao
        where requisicao.nr-requisicao = pRequisicao  no-lock:
        assign  cEstab                 =  requisicao.cod-estabel
                cNome                  =  requisicao.nome-abrev
                iEstado                =  requisicao.estado
                iSituacao              =  requisicao.situacao.
    end.                           
end.

return "OK":U.

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
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "origem":U THEN ASSIGN pFieldValue = RowObject.origem.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDados DBOProgram 
PROCEDURE getDados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input param  pNrOrdem  like ord-prod.nr-ord-produ no-undo.
def input param  pItem     like item.it-codigo        no-undo.
def input param  pNome     like requisicao.nome-abrev no-undo.
def output param pCAmpo    as char                    no-undo.
def output param pDeposito as char                    no-undo.
def output param pConta    as char                    no-undo.
def output param pCodigo   as char                    no-undo.
def output param pclassif  as log                     no-undo.
def output param pnat-desp as int                     no-undo.
/*** Busca Ordem de produ‡Æo***/
if can-find (first ord-prod  
   where ord-prod.nr-ord-produ = pNrOrdem no-lock ) then do:
   /*** Se encontra atualiza as informa‡äes da ordem***/
    for first ord-prod fields (ct-codigo sc-codigo nr-ord-produ cod-estabel)
        where ord-prod.nr-ord-produ = pNrOrdem no-lock:
        assign  pConta   = ord-prod.ct-codigo
                pCodigo  = ord-prod.sc-codigo.
        /***Busca informa‡äes da tabela item-uni-estab***/
        for first  item-uni-estab fields (it-codigo cod-estabel altera-conta nat-despesa )
            where item-uni-estab.it-codigo   = pItem 
            and   item-uni-estab.cod-estabel = ord-prod.cod-estabel no-lock:
              assign pclassif  = item-uni-estab.altera-conta
                     pnat-desp = item-uni-estab.nat-despesa.
               /***Busca informa‡äes da tabela usuar-mater***/
            for first usuar-mater where usuar-mater.cod-usuario  = pNome no-lock:
                if  substring(usuar-mater.char-1,1,1) = "y":U then do:
                    /***Busca informa‡äes da tabela utiliz-natu-despes***/
                    for first utiliz-natu-despes  fields (cod-nat-despesa cod-utiliz)
                         where utiliz-natu-despes.cod-nat-despesa  = item-uni-estab.nat-despesa no-lock:
                       if avail utiliz-natu-despes then do:
                          assign pCAmpo = utiliz-natu-despes.cod-utiliz.
                       end.
                    end.
                end.
                else do:
                     assign pCAmpo = "":U.
                end.
            end.
        end.
    end.
end.
else do: /***Se nÆo encontra atribui os valores default***/

     assign pCAmpo      = "":U  
            pDeposito   = "":U
            pConta      = "":U
            pCodigo     = "":U
            pclassif    = no
            pnat-desp   = 0.
end.
  
  


return "Ok":U.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getEstab DBOProgram 
PROCEDURE getEstab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT  PARAM pNrOrdem  LIKE ord-manut.nr-ord-produ NO-UNDO. 
DEFINE OUTPUT PARAM pEstab   AS CHARACTER                NO-UNDO.

if can-find (first ord-prod  
   where ord-prod.nr-ord-produ = pNrOrdem no-lock ) then do:
   /*** Se encontra atualiza as informa‡äes da ordem***/
   for first ord-prod fields(nr-ord-produ cod-estabel) 
        where ord-prod.nr-ord-produ = pNrOrdem no-lock:
        assign pEstab = ord-prod.cod-estabel.
  end.
end.
else do: /***Se nÆo encontra atribui os valores default***/
     assign pEstab      = "":U.  
end.

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
        WHEN "nr-ord-produ":U THEN ASSIGN pFieldValue = RowObject.nr-ord-produ.
        WHEN "nr-requisicao":U THEN ASSIGN pFieldValue = RowObject.nr-requisicao.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "num-tarefa":U THEN ASSIGN pFieldValue = RowObject.num-tarefa.
        WHEN "sequencia":U THEN ASSIGN pFieldValue = RowObject.sequencia.
        WHEN "tp-requis":U THEN ASSIGN pFieldValue = RowObject.tp-requis.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice rqrdprdc-id
  Parameters:  
               retorna valor do campo nr-requisicao
               retorna valor do campo sequencia
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnr-requisicao LIKE req-ord-produc.nr-requisicao NO-UNDO.
    DEFINE OUTPUT PARAMETER psequencia LIKE req-ord-produc.sequencia NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnr-requisicao = RowObject.nr-requisicao
           psequencia     = RowObject.sequencia.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getNextRequisicao DBOProgram 
PROCEDURE getNextRequisicao :
/*------------------------------------------------------------------------------
  Purpose:     getNextRequisicao
  Parameters:  pNrOrdProdu   - parƒmetro de input com o numero da ordem da produ‡Æo
               pRequisicao   - parƒmetro de output com o numeor da requisi‡Æo
               pRowid        - Rowid da requisi‡Æo encontrada
               pAchou        - parÆmetro logico para controle se a numera‡Æo da requisi‡Æo j  exite
  Notes:       Busca se j  exite requisi‡Æo para ordem informada e se a mesma ainda nÆo esta encerrada.
------------------------------------------------------------------------------*/
DEF INPUT  PARAM pNrOrdProdu LIKE {&TableName}.nr-ord-produ  NO-UNDO.
DEF INPUT  PARAM pTpRequis   LIKE {&TableName}.tp-requis     NO-UNDO.
DEF INPUT  PARAM Cnome       LIKE requisicao.nome-abrev      NO-UNDO.
DEF OUTPUT PARAM pRequisicao LIKE {&TableName}.nr-requisicao NO-UNDO.
DEF OUTPUT PARAM pRowid      AS ROWID                        NO-UNDO.
DEF OUTPUT PARAM pAchou      AS logical                      NO-UNDO.

DEFINE VARIABLE l-nova-requis AS LOGICAL                     NO-UNDO.
DEFINE VARIABLE cValParam     AS CHARACTER                   NO-UNDO.

disable triggers for dump of {&TableName}.
disable triggers for dump of requisicao.

/* Parametro Cria Nova Requisicao para Ordem - MI */
FIND FIRST mi-param-extens WHERE mi-param-extens.cdn-param = 113  NO-LOCK NO-ERROR.
    IF AVAIL mi-param-extens AND mi-param-extens.des-valor = "Sim" THEN
        ASSIGN l-nova-requis = YES.
        
/** Verifica se frotas esta implantado **/
RUN cdp/cd9902.p (INPUT 3).
IF  RETURN-VALUE = "OK":U THEN DO:
    /* Parametro Cria Nova Requisicao para Ordem - Frotas */
    IF NOT VALID-HANDLE(h-abapi015) THEN
         RUN abp/abapi015.p PERSISTENT SET h-abapi015.

    RUN pi-verifica-parametro IN h-abapi015 (INPUT  57, OUTPUT cValParam).

    IF VALID-HANDLE(h-abapi015) THEN DELETE OBJECT h-abapi015.               
END.

assign pRequisicao = 0
       pRowid      = ?
       pAchou      = no.

/* Ponto Inserido no chamado - TUGYEE */
IF c-nom-prog-upc-mg97  <> "":U THEN DO:

    FOR EACH tt-epc
        WHERE tt-epc.cod-event = "BeforeFindRequis":U:
        DELETE tt-epc.
    END.

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "BeforeFindRequis"
           tt-epc.cod-parameter = "NrOrdProdu"
           tt-epc.val-parameter = STRING(pNrOrdProdu).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "BeforeFindRequis"
           tt-epc.cod-parameter = "TpRequis"
           tt-epc.val-parameter = STRING(pTpRequis).

    {include/i-epc201.i "BeforeFindRequis"}

    FIND FIRST tt-epc
        WHERE tt-epc.cod-event     = "BeforeFindRequis":U
        AND   tt-epc.cod-parameter = "RetornaRequisicao" NO-LOCK NO-ERROR.
    
    IF AVAIL tt-epc THEN
        RETURN "OK":U.
END.

/** Verifica se Encontra alguma Requisição / Solicitação paara a OM **/
IF CAN-FIND (FIRST bf{&TableName}
             WHERE bf{&TableName}.nr-ord-produ = pNrOrdProdu
             and   bf{&TableName}.tp-requis    = pTpRequis no-lock) THEN DO:
    /** Percorre registros **/
    for each  bf{&TableName} fields(nr-requisicao dat-trans tp-requis origem) NO-LOCK
        WHERE bf{&TableName}.nr-ord-produ = pNrOrdProdu
        and   bf{&TableName}.tp-requis    = pTpRequis         
        break by bf{&TableName}.dat-trans desc:

        /** Verifica se a Requisição está aberta,
        OBS: deve-se criar uma nova requisição/solicitação, quando a mesma 
        estiver (2) Fechada (3) Pendente Compl ou (4) Com Ordem **/
        IF CAN-FIND(FIRST requisicao
                    WHERE requisicao.nr-requisicao = bf{&TableName}.nr-requisicao
                    AND   requisicao.situacao      = 1 
                    AND   requisicao.nome-abrev    = cNome  NO-LOCK) THEN DO:

            FIND FIRST requisicao 
                 WHERE requisicao.nr-requisicao = bf{&TableName}.nr-requisicao
                 AND   requisicao.situacao      = 1 
                 AND   requisicao.nome-abrev    = cNome NO-LOCK NO-ERROR.
            IF AVAIL requisicao THEN DO:
            
                IF bf{&TableName}.tp-requis = 2 /* Solicita‡ao de Compra */
                AND (cValParam = "1" AND bf{&TableName}.origem = "MV" OR
                    l-nova-requis    AND bf{&TableName}.origem = "MI") THEN DO:
                    /* Se o parƒmetro "Cria Nova Requisicao para Ordem" estiver marcado
                    e o estado da Solicita‡ao de Compra for igual a (2) - Nao Aprovada
                    cria uma nova sequencia na requisicao ja existente. Se o estado
                    for igual a (1) - Aprovada, cria uma nova solicita‡ao */
                    IF requisicao.estado = 2 THEN DO:                    
                        ASSIGN pRequisicao = requisicao.nr-requisicao  
                               pRowid      = ROWID(requisicao)
                               pAchou      = YES.       
                        RETURN "OK":U.
                    END.
                END.
                ELSE DO:            
                    ASSIGN pRequisicao = requisicao.nr-requisicao  
                           pRowid      = ROWID(requisicao)
                           pAchou      = YES. 
                    /** Sai do processamento para não ler registros a mais **/
                    RETURN "OK":U.
                END.
            END. /*IF AVAIL requisicao*/
        END. /*if can-find(first requisicao*/
    END. /*for each  bf{&TableName}*/
END. /*IF CAN-FIND (FIRST bf{&TableName}*/   
 
return "OK":U.

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
  Purpose:     Reposiciona registro com base no ¡ndice rqrdprdc-id
  Parameters:  
               recebe valor do campo nr-requisicao
               recebe valor do campo sequencia
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-requisicao LIKE req-ord-produc.nr-requisicao NO-UNDO.
    DEFINE INPUT PARAMETER psequencia LIKE req-ord-produc.sequencia NO-UNDO.

    FIND FIRST bfreq-ord-produc WHERE 
        bfreq-ord-produc.nr-requisicao = pnr-requisicao AND 
        bfreq-ord-produc.sequencia = psequencia NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfreq-ord-produc THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfreq-ord-produc)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToOrd-Prod DBOProgram 
PROCEDURE linkToOrd-Prod :
/*------------------------------------------------------------------------------
  Purpose:     linkToEquipamento
  Parameters:  entrada pHandle = Handle da DBO de Equipamento
  Notes:       Busca a ordem  e abre seta as restri‡äes para abertura da
               query.
------------------------------------------------------------------------------*/
define input parameter pHandle as handle no-undo.

run getKey in pHandle (output iNrOrdem).

run setConstraintOrd-Prod in this-procedure (input iNrOrdem).

return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryData DBOProgram 
PROCEDURE openQueryData :
/*------------------------------------------------------------------------------
  Purpose:     openQueryData
  Parameters:  <none>
  Notes:       Abre a query com todos os registros por faixa de c¢digo da Data
------------------------------------------------------------------------------*/
&Scoped-define KEY-PHRASE {&TableName}.dat-trans     >= daDataIni ~
                    and   {&TableName}.dat-trans     <= daDataFim ~
                    and   {&TableName}.nr-requisicao >= iReqIni ~
                    and   {&TableName}.nr-requisicao <= iReqFim ~
                    and   {&TableName}.sequencia     >= iSeqIni ~
                    and   {&TableName}.sequencia     <= iSeqFim NO-LOCK ~
                    by    {&TableName}.dat-trans ~
                    by    {&TableName}.nr-requisicao ~
                    by    {&TableName}.sequencia
{include/i-estab-openquery.i}

return "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     openQueryMain
  Parameters:  <none>
  Notes:       Abre a query com todos os registros
------------------------------------------------------------------------------*/

    IF l-estab-security-active = NO
    THEN DO: 
        &Scoped-define KEY-PHRASE TRUE USE-INDEX rqrdprdc-id no-lock
        {include/i-estab-openquery.i}
    END.
    ELSE DO:                
        &Scoped-define KEY-PHRASE TRUE USE-INDEX rqrdprdd_ix4 no-lock
        {include/i-estab-openquery.i}
    END.
    
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOrd-Prod DBOProgram 
PROCEDURE openQueryOrd-Prod :
/*------------------------------------------------------------------------------
  Purpose:     openQueryreq-ord
  Parameters:  <none>
  Notes:       Abre a query com os registros de ordem de pordu‡Æo
------------------------------------------------------------------------------*/
&Scoped-define KEY-PHRASE {&TableName}.nr-ord-produ    =  iNrOrdem ~
                   AND    {&TableName}.dat-trans     >=  daPeriodoIni ~
                   AND    {&TableName}.dat-trans     <=  daPeriodoFim ~
                   AND    {&TableName}.nr-requisicao >= iReqIni ~
                   AND    {&TableName}.nr-requisicao <= iReqFim ~
                   AND    {&TableName}.sequencia     >= iSeqIni ~
                   AND    {&TableName}.sequencia     <= iSeqFim NO-LOCK ~
                   BY     {&TableName}.nr-ord-produ ~
                   BY     {&TableName}.dat-trans ~
                   by     {&TableName}.nr-requisicao ~
                   by     {&TableName}.sequencia
    {include/i-estab-openquery.i}

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOrdem DBOProgram 
PROCEDURE openQueryOrdem :
/*------------------------------------------------------------------------------
  Purpose:     openQueryOrdem
  Parameters:  <none>
  Notes:       Abre a query com todos os registros por faixa de c¢digo de Ordem e Tarefa
------------------------------------------------------------------------------*/
&Scoped-define KEY-PHRASE {&TableName}.nr-requisicao >= iReqIni ~
                    and   {&TableName}.nr-requisicao <= iReqFim ~
                    and   {&TableName}.sequencia     >= iSeqIni ~
                    and   {&TableName}.sequencia     <= iSeqFim ~
                    and   {&TableName}.nr-ord-produ  >= iNrIni ~
                    and   {&TableName}.nr-ord-produ  <= iNrFim ~
                    and   {&TableName}.num-tarefa    >= iTarefaIni ~
                    and   {&TableName}.num-tarefa    <= iTarefaFim no-lock ~
                    by    {&TableName}.nr-ord-produ ~
                    by    {&TableName}.nr-requisicao ~
                    by    {&TableName}.sequencia
    {include/i-estab-openquery.i}

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryRequisicao DBOProgram 
PROCEDURE openQueryRequisicao :
/*------------------------------------------------------------------------------
  Purpose:     openQueryRequisicao
  Parameters:  <none>
  Notes:       Abre a query com todos os registros por faixa de c¢digo de Requisi‡Æo e Sequˆncia
------------------------------------------------------------------------------*/

IF l-estab-security-active THEN DO:
&Scoped-define KEY-PHRASE {&TableName}.nr-requisicao >= iReqIni ~
                    and   {&TableName}.nr-requisicao <= iReqFim ~
                    and   {&TableName}.sequencia     >= iSeqIni ~
                    and   {&TableName}.sequencia     <= iSeqFim no-lock ~
                    BY    {&TableName}.cod-estabel ~
                    by    {&TableName}.nr-requisicao ~
                    BY    {&TableName}.sequencia
    {include/i-estab-openquery.i}
END.
ELSE DO:
&Scoped-define KEY-PHRASE {&TableName}.nr-requisicao >= iReqIni ~
                    and   {&TableName}.nr-requisicao <= iReqFim ~
                    and   {&TableName}.sequencia     >= iSeqIni ~
                    and   {&TableName}.sequencia     <= iSeqFim no-lock ~
                    by    {&TableName}.nr-requisicao ~
                    BY    {&TableName}.sequencia
    {include/i-estab-openquery.i}
END.

return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-msg-aprov DBOProgram 
PROCEDURE pi-msg-aprov :
/*------------------------------------------------------------------------------
  Purpose:     pi-msg-aprov
  Parameters:  <none>
  Notes:       Mensagem de Aprova‡Æo
------------------------------------------------------------------------------*/
def var i-moeda-lim           as int   no-undo.
def var i-tipo-moeda          as int   no-undo.
def var de-valor-doc          as dec   no-undo.
def var de-valor-lim          as dec   no-undo.
def var c-moeda-lim           as char  no-undo.
def var c-tipo-moeda          as char  no-undo.

IF NOT AVAIL it-requisicao THEN
    FIND FIRST it-requisicao NO-LOCK
         WHERE it-requisicao.nr-requisicao = RowObject.nr-requisicao NO-ERROR.

IF AVAIL it-requisicao THEN DO:
    if i-tipo-doc > 0 then do:
        IF  NOT CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN DO:
            run cdp/cdapi174.p (i-tipo-doc,
                                rowid(it-requisicao),
                                output i-moeda-lim,
                                output i-tipo-moeda,
                                output de-valor-doc,
                                output de-valor-lim).
            find first moeda 
                 where moeda.mo-codigo = i-moeda-lim no-lock no-error.
            assign c-moeda-lim  = string(i-moeda-lim,"9") + " - ":U + moeda.descricao.
            case i-tipo-moeda:
                when 1 then do:
                    {utp/ut-liter.i (Usu rio) * r}
                    assign c-tipo-moeda = return-value.
                end.
                when 2 then do:
                    {utp/ut-liter.i (Aprovador) * r}
                    assign c-tipo-moeda = return-value.
                end.
                when 3 then do:
                    {utp/ut-liter.i (Fam¡lia) * r}
                    assign c-tipo-moeda = return-value.
                end.
                when 4 then do:
                    {utp/ut-liter.i (Mestre) * r}
                    assign c-tipo-moeda = return-value.
                end.
            end case.    
    
            if  it-requisicao.estado = 1 then do:
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
        END.
    end.
    else do:
        {method/svc/errors/inserr.i &ErrorNumber="16760"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U
                                    &ErrorParameters="''"} 
         return "NOK"  .                                
    end.
END.

return "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAprovaTotal DBOProgram 
PROCEDURE piAprovaTotal :
/*------------------------------------------------------------------------------
  Purpose:     piAprovaTotal
  Parameters:  entrada - p-nr-requisicao = N£mero da Requisi‡Æo
               entrada - p-sequencia     = Sequˆncia do item da requisi‡Æo
  Notes:       Aprova‡Æo de todas as parcelas da requisi‡Æo ~\ solicita‡Æo
------------------------------------------------------------------------------*/
define input parameter p-nr-requisicao like it-requisicao.nr-requisicao no-undo.
define input parameter p-sequencia     like it-requisicao.sequencia     no-undo.
DEFINE INPUT PARAMETER p-nr-ord        AS INTEGER                       NO-UNDO.

DEFINE VARIABLE r-it-requis   AS ROWID   NO-UNDO.
DEFINE VARIABLE i-tipo-trans  AS INTEGER NO-UNDO.
DEFINE VARIABLE h-mlaapi010a  AS HANDLE  NO-UNDO.
DEFINE VARIABLE h-mlaapi010b  AS HANDLE  NO-UNDO.

IF  NOT VALID-HANDLE(hBoSincroniz) THEN
    RUN mnbo/bomni00307.p PERSISTENT SET hBoSincroniz.

/** Verifica o tipo de transa»’o **/
ASSIGN i-tipo-trans = IF c-param = "create" THEN 1 ELSE 2.

define buffer b-it-requis for it-requisicao.

find first param-compra no-lock no-error.
find first param-estoq  no-lock no-error.

FOR FIRST it-requisicao 
    WHERE it-requisicao.nr-requisicao = requisicao.nr-requisicao NO-LOCK:
END.

IF AVAIL it-requisicao THEN DO:
    ASSIGN p-nr-requisicao = it-requisicao.nr-requisicao
           p-sequencia     = it-requisicao.sequencia.
END.

assign i-tipo-doc = 0.

/** Busca o Item da Requisi‡Æo **/
for first it-requisicao 
    where it-requisicao.nr-requisicao = p-nr-requisicao
    and   it-requisicao.sequencia     = p-sequencia no-lock:
    ASSIGN r-it-requis = rowid(it-requisicao).
    /** Busca a Requisi‡Æo **/
    for first requisicao 
        where requisicao.nr-requisicao = it-requisicao.nr-requisicao no-lock:
        /** Verifica o tipo de Documento **/
        if requisicao.tp-requis = 1 and substr(param-estoq.char-1,4,1) = "Y" then 
            assign i-tipo-doc = 2.
        else 
            if requisicao.tp-requis = 2 then 
                assign i-tipo-doc = 1.
            else 
                assign i-tipo-doc = 3.
    end.
end.
/** Valida Parƒmetros de Aprova‡Æo **/
if avail param-compra and param-compra.log-1 and avail requisicao and avail it-requisicao then do:       
    if i-tipo-doc < 3 then do:
       /** Aprova‡Æo Total **/
       if ((i-tipo-doc = 1 and substring(param-compra.char-2, 1, 3) = "sim":U) or 
           (i-tipo-doc = 2 and substring(param-compra.char-2, 4, 3) = "sim":U)) then do:
           /** Cria documento de pendˆncia **/

           IF  CAN-FIND(funcao WHERE
                        funcao.cd-funcao = "Integra_MLA_EMS" AND
                        funcao.ativo     = YES) THEN DO:
               RUN lap/mlaapi099.p (INPUT i-tipo-doc).
               IF  RETURN-VALUE <> "NOK" THEN DO:
                   CASE i-tipo-doc:
                       WHEN 1 THEN DO:                                                        
                            IF  NOT VALID-HANDLE(h-mlaapi010a) THEN
                                RUN lap/mlaapi010a.p PERSISTENT SET h-mlaapi010a (INPUT i-tipo-trans, INPUT r-it-requis, output table tt-erro).

                            IF  VALID-HANDLE(h-mlaapi010a) THEN DO:
                                RUN pi-seta-ordem IN h-mlaapi010a (INPUT p-nr-ord).
                                RUN pi-executar IN h-mlaapi010a (INPUT i-tipo-trans, INPUT r-it-requis, output table tt-erro).
                                RUN getRowErrors IN h-mlaapi010a (OUTPUT TABLE RowErrors APPEND).
                            END.

                            IF VALID-HANDLE(h-mlaapi010a) THEN
                                DELETE OBJECT h-mlaapi010a.	
                       END.
                       WHEN 2 THEN DO:
                            IF CAN-FIND(funcao WHERE
                                        funcao.cd-funcao = "Solicitacao_MLA" AND
                                        funcao.ativo = YES) THEN DO:
                                RUN cdp/cdapi171.p (i-tipo-doc, 2, ROWID(it-requisicao)).
                            END.
                            ELSE DO:
                                IF  NOT VALID-HANDLE(h-mlaapi010b) THEN
                                    RUN lap/mlaapi010b.p PERSISTENT SET h-mlaapi010b (INPUT i-tipo-trans, INPUT r-it-requis, output table tt-erro).

                                IF  VALID-HANDLE(h-mlaapi010b) THEN DO:
                                    RUN pi-seta-ordem IN h-mlaapi010b (INPUT p-nr-ord).
                                    RUN pi-executar IN h-mlaapi010b (INPUT i-tipo-trans, INPUT r-it-requis, output table tt-erro).
                                    RUN getRowErrors IN h-mlaapi010b (OUTPUT TABLE RowErrors APPEND).
                                END.
                            END.

                           IF VALID-HANDLE(h-mlaapi010b) THEN
                               DELETE OBJECT h-mlaapi010b.	
                       END.
                   END.
               END.
           END.
           ELSE DO:
               RUN cdp/cdapi171.p (i-tipo-doc, 2, ROWID(it-requisicao)).
           END.
           /** Busca tabelas para atualiza‡Æo **/
           find current requisicao exclusive-lock no-error.
           find current it-requisicao exclusive-lock no-error.

           assign requisicao.estado = 1
                  requisicao.nome-aprov = requisicao.nome-abrev.

           /**  Melhorias **/
           &if defined(bf_mat_aprova_eletronica) &then
               assign it-requisicao.estado = 1
                      it-requisicao.nome-aprov = requisicao.nome-abrev.
               /* Reabre outras parcelas */
               for each b-it-requis 
                  where b-it-requis.nr-requisicao = requisicao.nr-requisicao                            
                    and b-it-requis.sequencia    <> it-requisicao.sequencia
                    and (b-it-requis.situacao    = 1 or b-it-requis.situacao = 3) exclusive-lock:
                    assign b-it-requis.estado     = 1
                           b-it-requis.nome-aprov = requisicao.nome-abrev.    
               end.
           &endif
           if i-tipo-doc > 0 then do:
               assign l-pendente = no.
               run cdp/cdapi172.p (i-tipo-doc,rowid(it-requisicao), output l-pendente).
               if  l-pendente then do:
                   assign requisicao.estado = 2
                          requisicao.nome-aprov = "":U.                              
                   /**  Melhorias **/                       
                   &if defined(bf_mat_aprova_eletronica) &then
                       if  it-requisicao.situacao <> 2 then
                           assign it-requisicao.estado = 2
                                  it-requisicao.nome-aprov = "":U.
                       /* Reabre outras parcelas */
                       for each b-it-requis 
                          where b-it-requis.nr-requisicao = requisicao.nr-requisicao                            
                            and b-it-requis.sequencia <> it-requisicao.sequencia
                            and (b-it-requis.situacao = 1 or b-it-requis.situacao = 3) exclusive-lock:
                            assign b-it-requis.estado = 2
                                   b-it-requis.nome-aprov = "":U.    
                       end.
                   &endif
               end.                   
           end.
           find current requisicao NO-LOCK no-error.
           find current it-requisicao NO-LOCK no-error.

           RUN adicionarSincroniz IN hBoSincroniz (INPUT "req-ord-produ":U,
                                                   INPUT STRING(p-nr-requisicao) + ";" + STRING(p-sequencia),
                                                   INPUT 2, /* Update */
                                                   INPUT c-seg-usuario).


           run pi-msg-aprov in this-procedure.
       end.
    end.


    IF VALID-HANDLE (hBoSincroniz) THEN
        DELETE OBJECT hBoSincroniz.


    IF  CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.  

end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piEliminaItRequisicao DBOProgram 
PROCEDURE piEliminaItRequisicao :
/*------------------------------------------------------------------------------
  Purpose:     piEliminaItRequisicao
  Parameters:  <none>
  Notes:      Elimina o item da requisicao associado a tabela req-ord-produc
------------------------------------------------------------------------------*/
DEFINE VARIABLE hDBOItReq AS HANDLE    NO-UNDO.
DEFINE VARIABLE iErro     AS INTEGER   NO-UNDO.
DEFINE VARIABLE r-rowid   AS ROWID     NO-UNDO.
DEFINE VARIABLE l-om-mv   AS LOGICAL   INITIAL NO NO-UNDO.
DEFINE VARIABLE hDBOOMV   AS HANDLE    NO-UNDO.

/** Cria Temp-Table do Requisi‡Æo do Item **/
FOR FIRST it-requisicao
    WHERE it-requisicao.nr-requisicao = RowObject.nr-requisicao
    AND   it-requisicao.sequencia     = RowObject.sequencia  NO-LOCK:

    ASSIGN r-rowid = ROWID(it-requisicao).
    
    FOR FIRST usuar-mater WHERE usuar-mater.cod-usuario = c-seg-usuario NO-LOCK:
       IF  c-seg-usuario NE it-requisicao.nome-abrev AND SUBSTRING(usuar-mater.char-1,10,01) = "N" THEN DO:
           {method/svc/errors/inserr.i &ErrorNumber="27706"
                                       &ErrorType="EMS":U
                                       &ErrorSubType="ERROR":U} 
           RETURN "NOK":U.
       END.
    END.

   /* MLA */
   RUN eliminaRegistroMLA IN THIS-PROCEDURE.

   /** MV **/
   RUN cdp/cd9902.p (INPUT 3).
   IF RETURN-VALUE = "OK":U THEN DO:
        IF NOT VALID-HANDLE(hDBOOMV) THEN
            RUN frbo/bofr072.p PERSISTENT SET hDBOOMV.

        RUN openQueryStatic IN hDBOOMV (INPUT "Main":U) NO-ERROR.
        RUN goToKey         IN hDBOOMV (INPUT RowObject.nr-ord-produ).
        IF RETURN-VALUE = "OK":U THEN
            ASSIGN l-om-mv = YES.
 
        IF VALID-HANDLE(hDBOOMV) THEN
            RUN Destroy IN hDBOOMV.
   END.

   /*:T--- Verifica se o DBO j  est  inicializado ---*/
   IF  CAN-FIND (FIRST ord-manut WHERE ord-manut.nr-ord-produ = RowObject.nr-ord-produ NO-LOCK)
       OR l-om-mv THEN DO:

       /*:T--- Verifica se o DBO j  est  inicializado ---*/
       IF  NOT VALID-HANDLE(hDBOItReq)     OR
           hDBOItReq:TYPE <> "PROCEDURE":U OR
           hDBOItReq:FILE-NAME <> "inbo/boin168man.p":U THEN DO:
           RUN inbo/boin168man.p PERSISTENT SET hDBOItReq.
       END.
       /*--- Abre query do DBO do Requisi‡Æo do Item ---*/
       RUN openQueryStatic IN hDBOItReq (INPUT "Main":U).
       /*--- Posiciona a Query no Registro a ser deletado ---*/
       RUN repositionRecord IN hDBOItReq (INPUT r-rowid).
       RUN setNrOrdProdu    IN hDBOItReq (INPUT RowObject.nr-ord-produ).
   END.
   ELSE DO:
       /*:T--- Verifica se o DBO j  est  inicializado ---*/
       IF  NOT VALID-HANDLE(hDBOItReq)     OR
           hDBOItReq:TYPE <> "PROCEDURE":U OR
           hDBOItReq:FILE-NAME <> "inbo/boin168.p":U THEN DO:
           RUN inbo/boin168.p PERSISTENT SET hDBOItReq.
       END.
       /*--- Abre query do DBO do Requisi‡Æo do Item ---*/
       RUN openQueryStatic IN hDBOItReq (INPUT "Main":U).
       /*--- Posiciona a Query no Registro a ser deletado ---*/
       RUN repositionRecord IN hDBOItReq (INPUT r-rowid).
   END.
   /*--- Limpa temp-table RowErrors no DBO ---*/
   RUN emptyRowErrors IN hDBOItReq.
   /*--- Cria um novo registro ---*/
   RUN deleteRecord IN hDBOItReq.
   /*--- Verifica ocorrˆncia de erros durante a elimina‡Æo ---*/
   IF RETURN-VALUE = "NOK":U THEN DO:
       /*--- Retorna temp-table RowErrors do DBO ---*/
       RUN getRowErrors IN hDBOItReq (OUTPUT TABLE RowErrorsAux).
       /** Elimina handle da BO de it-requsiicao **/
       IF VALID-HANDLE(hDBOItReq) THEN
           RUN Destroy IN hDBOItReq.
       
        IF CAN-FIND(FIRST RowErrorsAux WHERE RowErrorsAux.ErrorType <> "INTERNAL":U NO-LOCK) THEN DO:
           ASSIGN iErro = 0.
           /** Busca £ltimo erro criado na BO **/
           FOR LAST RowErrors NO-LOCK:
               ASSIGN iErro = RowErrors.ErrorSequence.
           END.
           /** Percorre os erros**/
           FOR EACH RowErrorsAux WHERE RowErrorsAux.ErrorType <> "INTERNAL":U NO-LOCK:
               /** Cria eros na BO **/
               CREATE RowErrors.
               BUFFER-COPY RowErrorsAux EXCEPT ErrorSequence TO RowErrors
                   /** Coloca sequˆncia **/
                   ASSIGN RowErrors.ErrorSequence = iErro + 1.
               ASSIGN iErro = RowErrors.ErrorSequence.
           END.
           RETURN "NOK":U.
       END.

       /* Verifica se ocorreu erro devido a registro locado */
       FIND FIRST RowErrorsAux
            WHERE RowErrorsAux.ErrorNumber = 4 NO-LOCK NO-ERROR.
       IF  AVAIL RowErrorsAux THEN DO:
           ASSIGN iErro = 0.
           /** Busca £ltimo erro criado na BO **/
           FOR LAST RowErrors NO-LOCK:
               ASSIGN iErro = RowErrors.ErrorSequence.
           END.

           /** Cria eros na BO **/
           CREATE RowErrors.
           BUFFER-COPY RowErrorsAux EXCEPT ErrorSequence TO RowErrors
               /** Coloca sequencia **/
           ASSIGN RowErrors.ErrorSequence = iErro + 1.
           ASSIGN iErro = RowErrors.ErrorSequence.
           RETURN "NOK":U.
       END.

   END.
   /** Elimina handle da BO de it-requsiicao **/
   IF VALID-HANDLE(hDBOItReq) THEN
       RUN Destroy IN hDBOItReq.
END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piEliminaRequisicao DBOProgram 
PROCEDURE piEliminaRequisicao :
/*------------------------------------------------------------------------------
  Purpose:    piEliminaRequisicao
  Parameters:  <none>
  Notes:       Elimina o resgitro da tabela requisicao associado a tabela req-ord-produc
------------------------------------------------------------------------------*/
define variable hDBOReq as handle    no-undo.
define variable iErro   as integer   no-undo.
define variable r-rowid as rowid     no-undo.

/** Cria Temp-Table de Requisicao **/
for first requisicao
    where requisicao.nr-requisicao = RowObject.nr-requisicao no-lock:

    assign r-rowid = rowid(requisicao).

    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE(hDBOReq) OR 
       hDBOReq:TYPE <> "PROCEDURE":U OR
       hDBOReq:FILE-NAME <> "inbo/boin385.p":U THEN DO:
        run inbo/boin385.p persistent set hDBOReq.
    END.
    /*--- Abre query do DBO do Requisicao ---*/
    RUN openQueryStatic IN hDBOReq (INPUT "Main":U).
    /*--- Posiciona a Query no Registro a ser deletado ---*/
    run repositionRecord in hDBOReq (input r-rowid).
    /*--- Limpa temp-table RowErrors no DBO ---*/
    RUN emptyRowErrors IN hDBOReq.
    /*--- Cria um novo registro ---*/
    RUN deleteRecord IN hDBOReq.
    /*--- Verifica ocorrˆncia de erros durante a elimina‡Æo ---*/
    IF return-value = "NOK":U THEN DO:
        /*--- Retorna temp-table RowErrors do DBO ---*/
        RUN getRowErrors IN hDBOReq (OUTPUT TABLE RowErrorsAux).
        /** Elimina handle da BO da Requsicao **/
        if valid-handle(hDBOReq) then
           run Destroy in hDBOReq.
        IF CAN-FIND(FIRST RowErrorsAux WHERE RowErrorsAux.ErrorType <> "INTERNAL":U no-lock) THEN DO:
            assign iErro = 0.
            /** Busca £ltimo erro criado na BO **/
            for last RowErrors no-lock:
                assign iErro = RowErrors.ErrorSequence.
            end.
            /** Percorre os erros da API **/
            for each RowErrorsAux WHERE RowErrorsAux.ErrorType <> "INTERNAL":U no-lock:
                /** Cria eros na BO **/
                create RowErrors.
                buffer-copy RowErrorsAux except ErrorSequence to RowErrors
                    /** Coloca sequˆncia **/
                    assign RowErrors.ErrorSequence = iErro + 1.
                assign iErro = RowErrors.ErrorSequence.
            end.
            RETURN "NOK":U.
        END.
    end.
    /** Elimina handle da BO da Requsicao **/
    if valid-handle(hDBOReq) then
        run Destroy in hDBOReq.
end.

return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaRestricoesUnidNegoc DBOProgram 
PROCEDURE piValidaRestricoesUnidNegoc :
/*------------------------------------------------------------------------------
  Purpose: validar o relacionamento entre centro de custo e unidade de neg¢cio, 
           de acordo com o relacionamento efetuado no EMS5.   
  Notes: Utilizando somente em release 2.06b ou superior.      
------------------------------------------------------------------------------*/
    /** Vari vel para ser utilizada na chamada da cdapi024 **/
    DEFINE VARIABLE h-cdapi024           AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE l-valida-restr-ems5  AS LOGICAL                  NO-UNDO.
    DEFINE VARIABLE i-cont-erro          AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE h-bofr134            AS HANDLE                   NO-UNDO.

    /* Limpa a temp-table tt-erro */
    EMPTY TEMP-TABLE tt-erro.
    /** Verifica parametro Valida EMS 5 On-line **/
    IF  NOT AVAIL param-global THEN
        FIND FIRST param-global NO-LOCK NO-ERROR.
    /* Verifica Parametros Globais o parametro Valida Restri‡äes EMS 5 on-line */
    &IF "{&bf_mat_versao_ems}" <= "2.071" &THEN
        ASSIGN l-valida-restr-ems5 = IF SUBSTRING(param-global.char-2,31,1) = "2" THEN YES ELSE NO.
    &ELSE
        ASSIGN l-valida-restr-ems5 = param-global.log-validac-ems5.
    &ENDIF
    
    &IF DEFINED(bf_mnt_ems206b) &THEN
        IF RowObject.origem = "MI" THEN DO:
            /* Busca a Ordem de Manuten‡Æo corrente */
            FOR FIRST ord-manut FIELDS ( ct-desp sc-desp nr-ord-produ cod-estabel ep-codigo &IF DEFINED(bf_mnt_ems207) &THEN cod-unid-negoc &ELSEIF DEFINED(bf_mnt_ems206b) &THEN char-1 &ENDIF )
                WHERE ord-manut.nr-ord-produ = RowObject.nr-ord-produ NO-LOCK:
            END.
            /* Se encontrar a Ordem de Manuten‡Æo entÆo faz a valida‡Æo */
            IF AVAIL ord-manut THEN DO:
                IF l-valida-restr-ems5 AND ord-manut.ct-desp <> "" THEN DO:
                     /* Verifica se os Bancos do EMS5 est’o conectados */
                    IF CONNECTED("emsbas") AND CONNECTED("emsfin") AND CONNECTED("emsuni") THEN
                        ASSIGN l-conectado-ems5 = YES.
                    /* Caso a Ordem de Manuten‡Æo conter matriz de Unidade de Neg¢cio 
                    Valida todas as unidade de neg¢cio da matriz */
                    IF NOT VALID-HANDLE(h_api_cta_ctbl) THEN
                        RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.

                    EMPTY TEMP-TABLE tt_log_erro.

                    FOR EACH unid-negoc-om 
                       WHERE unid-negoc-om.num-ord-manut = ord-manut.nr-ord-produ NO-LOCK:
                        RUN pi_valida_conta_contabil IN h_api_cta_ctbl (INPUT  ord-manut.ep-codigo          , /** C«digo da Empresa do EMS2.                      **/
                                                                        INPUT  ord-manut.cod-estabel        , /** C«digo do Estabelecimento do EMS2.              **/
                                                                        INPUT  unid-negoc-om.cod-unid-negoc , /** C«digo da Unidade de Neg®cio                    **/
                                                                        INPUT  ""                           , /** C«digo do Plano de Contas                       **/ 
                                                                        INPUT  ord-manut.ct-desp            , /** C«digo da Conta                                 **/
                                                                        INPUT  ""                           , /** C«digo do Plano de Centro de Custo              **/
                                                                        INPUT  ord-manut.sc-desp            , /** C«digo do Centro de Custo                       **/
                                                                        INPUT  RowObject.dat-trans          , /** Data da TransaîÒo                               **/
                                                                        OUTPUT TABLE tt_log_erro APPEND     ). /** Erros ocorridos durante a execu¯Êo do mýtodo    **/


                        
                    END.
                    IF &IF DEFINED(bf_mnt_ems207) &THEN ord-manut.cod-unid-negoc <> "" &ELSEIF DEFINED(bf_mnt_ems206b) &THEN SUBSTRING(ord-manut.char-1,19,3) <> "" &ENDIF THEN DO:
                        RUN pi_valida_conta_contabil IN h_api_cta_ctbl (INPUT  ord-manut.ep-codigo          , /** C«digo da Empresa do EMS2.                      **/
                                                                        INPUT  ord-manut.cod-estabel        , /** C«digo do Estabelecimento do EMS2.              **/
                                                                        INPUT  ord-manut.cod-unid-negoc     , /** C«digo da Unidade de Neg®cio                    **/
                                                                        INPUT  ""                           , /** C«digo do Plano de Contas                       **/ 
                                                                        INPUT  ord-manut.ct-desp            , /** C«digo da Conta                                 **/
                                                                        INPUT  ""                           , /** C«digo do Plano de Centro de Custo              **/
                                                                        INPUT  ord-manut.sc-desp            , /** C«digo do Centro de Custo                       **/
                                                                        INPUT  RowObject.dat-trans          , /** Data da TransaîÒo                               **/
                                                                        OUTPUT TABLE tt_log_erro APPEND     ). /** Erros ocorridos durante a execu¯Êo do mýtodo    **/
                    END.
                    IF VALID-HANDLE(h_api_cta_ctbl) THEN
                        DELETE OBJECT h_api_cta_ctbl.

                    /* Carrega o erro retornado pela procedure na RowErrors */
                    IF  CAN-FIND(FIRST tt_log_erro) THEN DO:
                         FOR EACH tt_log_erro NO-LOCK:
                            {utp/ut-liter.i "C¢digo Erro Financeiro: "}
                             ASSIGN cErroAux = RETURN-VALUE + CHR(01) + STRING(tt_log_erro.ttv_num_cod_erro).
                            {method/svc/errors/inserr.i
                                             &ErrorNumber="52046" 
                                             &ErrorType="EMS"
                                             &ErrorSubType="ERROR"
                                             &ErrorParameters= "tt_log_erro.ttv_des_msg_erro + '~~~~' + tt_log_erro.ttv_des_msg_ajuda + '~~~~' + cErroAux"}  
                        END.
                    END.
                END.
            END.
        END.
        ELSE IF RowObject.origem = " MV":U THEN DO:
            IF NOT VALID-HANDLE(h-bofr134) THEN
                RUN frbo/bofr134.p PERSISTENT SET h-bofr134.

            RUN ValidaRestricoesUnidadeNegocio IN h-bofr134 (INPUT RowObject.nr-ord-produ,
                                                             INPUT RowObject.dat-trans,
                                                             OUTPUT TABLE tt-erro APPEND).
            IF VALID-HANDLE(h-bofr134) THEN
                RUN destroy IN h-bofr134.

            /* Carrega o erro retornado pela procedure na RowErrors */
            IF  CAN-FIND(FIRST tt-erro) THEN DO:
                FOR EACH tt-erro:
                    FOR LAST RowErrors NO-LOCK:
                        ASSIGN i-cont-erro = RowErrors.ErrorSequence.
                    END.
                    CREATE RowErrors.
                    ASSIGN RowErrors.ErrorSequence    = i-cont-erro + 1
                           RowErrors.ErrorNumber      = tt-erro.cd-erro
                           RowErrors.ErrorType        = "EMS"
                           RowErrors.ErrorSubType     = "ERROR"
                           RowErrors.ErrorDescription = SUBSTRING(tt-erro.mensagem,1,INDEX(tt-erro.mensagem,"|") - 1).
                           RowErrors.ErrorHelp        = SUBSTRING(tt-erro.mensagem,INDEX(tt-erro.mensagem,"|") + 1 ,255).

                    ASSIGN i-cont-erro = RowErrors.ErrorSequence.
                END.            
            END.
        END.
    &ENDIF
    
    /* Limpa a temp-table tt-erro */
    EMPTY TEMP-TABLE tt-erro.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setaPrograma DBOProgram 
PROCEDURE setaPrograma :
/*------------------------------------------------------------------------------
  Purpose:     setaPrograma
  Parameters:  entrada pPrograma = C¢digo do programa
  Notes:       Seta o Programa chamador da BO
------------------------------------------------------------------------------*/
define input parameter pPrograma as character no-undo.

assign cPrograma = pPrograma.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintData DBOProgram 
PROCEDURE setConstraintData :
/*------------------------------------------------------------------------------
  Purpose:     setConstraintOrdem
  Parameters:  entrada pReqIni = Data inicial
               entrada pReqFim = Data Final
  Notes:       Seta as restri‡äes para aberir a query por faixa de Datas
------------------------------------------------------------------------------*/
define input parameter pDataIni as date no-undo.
define input parameter pDataFim as date no-undo.
define input parameter pReqIni as integer no-undo.
define input parameter pReqFim as integer no-undo.
define input parameter pSeqIni as integer no-undo.
define input parameter pSeqFim as integer no-undo.
assign daDataIni  =  pDataIni
       daDataFim  =  pDataFim
       iReqIni    =  pReqIni 
       iReqFim    =  pReqFim 
       iSeqIni    =  pSeqIni 
       iSeqFim    =  pSeqFim.
 


return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintOrd-Prod DBOProgram 
PROCEDURE setConstraintOrd-Prod :
/*-------------------------------------- 
  Purpose:     setConstraintreq-ord
  Parameters:  entrada pNrOrdProdu = ordem de produ‡Æo
Notes:       Seta as restri‡äes para abertura da query por ordem 
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pNrOrdProdu  LIKE {&TableName}.nr-ord-produ   NO-UNDO. 

assign iNrOrdem  = pNrOrdProdu. 

return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintOrdem DBOProgram 
PROCEDURE setConstraintOrdem :
/*------------------------------------------------------------------------------
  Purpose:     setConstraintOrdem
  Parameters:  entrada pOMIni  = N£mero da Ordem inicial
               entrada pOMFim  = N£mero da Ordem Final
               entrada pTarIni = N£mero da Tarefa inicial
               entrada pTarFim = N£mero da Tarefa Final  
  Notes:       Seta as restri‡äes para aberir a query por faixa de ordens e tarefa
------------------------------------------------------------------------------*/
define input parameter pOMIni  as integer no-undo.
define input parameter pOMFim  as integer no-undo.
define input parameter pTarIni  as integer no-undo.
define input parameter pTarFim  as integer no-undo.
define input parameter pReqIni as integer no-undo.
define input parameter pReqFim as integer no-undo.
define input parameter pSeqIni as integer no-undo.
define input parameter pSeqFim as integer no-undo.

assign iReqIni     =  pReqIni 
       iReqFim     =  pReqFim 
       iSeqIni     =  pSeqIni 
       iSeqFim     =  pSeqFim
       iNrIni      =  pOMIni 
       iNrFim      =  pOMFim
       iTarefaIni  =  pTarIni
       iTarefaFim  =  pTarFim.

return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintPerido DBOProgram 
PROCEDURE setConstraintPerido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define input parameter pDataIni AS DATE NO-UNDO.
define input parameter pDataFim AS DATE NO-UNDO.
define input parameter pReqIni  as integer no-undo.
define input parameter pReqFim  as integer no-undo.
define input parameter pSeqIni  as integer no-undo.
define input parameter pSeqFim  as integer no-undo.

       
       
       
       

assign daPeriodoIni =  pDataIni
       daPeriodoFim =  pDataFim
       iReqIni      =  pReqIni 
       iReqFim      =  pReqFim 
       iSeqIni      =  pSeqIni 
       iSeqFim      =  pSeqFim. 

       

  

RETURN "ok":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintRequisicao DBOProgram 
PROCEDURE setConstraintRequisicao :
/*------------------------------------------------------------------------------
  Purpose:     setConstraintOrdem
  Parameters:  entrada pReqIni = N£mero da Requisicao inicial
               entrada pReqFim = N£mero da Requisicao Final
               entrada pSeqIni = N£mero da Sequencia inicial
               entrada pSeqFim = N£mero da Sequencia Final  
  Notes:       Seta as restri‡äes para aberir a query por faixa de Requisicao e Sequencia
------------------------------------------------------------------------------*/
define input parameter pReqIni as integer no-undo.
define input parameter pReqFim as integer no-undo.
define input parameter pSeqIni as integer no-undo.
define input parameter pSeqFim as integer no-undo.

assign iReqIni   =  pReqIni 
       iReqFim   =  pReqFim 
       iSeqIni   =  pSeqIni 
       iSeqFim   =  pSeqFim .


return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaCamposTela DBOProgram 
PROCEDURE validaCamposTela :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT  PARAM pNrOrdProdu LIKE {&TableName}.nr-ord-produ             NO-UNDO.
DEF INPUT  PARAM pOrigem     AS CHAR             NO-UNDO.
def input param pItem        like item.it-codigo no-undo.
def input param pTarefa      like ord-taref.cd-tarefa no-undo.
def input param pRequis      like requisicao.nome-abrev no-undo.
def input param pTipo        like {&TableName}.tp-requis no-undo.
DEFINE VARIABLE cTexto1      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTexto2      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE  hDBOMV   AS HANDLE                      NO-UNDO.

/** Ordem Inexistente **/
IF l-estab-security-active THEN DO:
    FOR FIRST ord-prod FIELDS(cod-estabel) NO-LOCK
        WHERE ord-prod.nr-ord-produ = pNrOrdProdu
          AND ord-prod.origem       = pOrigem:
        IF NOT CAN-FIND (FIRST tt_estab_ems2
                         WHERE tt_estab_ems2.tta_cod_estab = ord-prod.cod-estabel) THEN DO:
            ASSIGN cTexto2 = STRING(pNrOrdProdu).
            {utp/ut-liter.i "Ordem:"}
            ASSIGN cTexto1 = RETURN-VALUE + STRING(pNrOrdProdu).
            {method/svc/errors/inserr.i
                            &ErrorNumber="47"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"
                            &ErrorParameters="cTexto1"}
        END.
    END.
END.
ELSE DO:
    if not can-find(first ord-prod
       where ord-prod.nr-ord-produ = pNrOrdProdu
       AND   ord-prod.origem       = pOrigem no-lock) then do:
       ASSIGN cTexto2 = STRING(pNrOrdProdu).
       {utp/ut-liter.i "Ordem:"}
       ASSIGN cTexto1 = RETURN-VALUE + STRING(pNrOrdProdu).
       {method/svc/errors/inserr.i
                       &ErrorNumber="47"
                       &ErrorType="EMS"
                       &ErrorSubType="ERROR"
                       &ErrorParameters="cTexto1"}                    
    end.
END.

/** Ordem Inexistente **/
FOR FIRST item
    WHERE item.it-codigo = pItem no-lock:
END.
IF NOT AVAIL ITEM THEN DO:
    {utp/ut-liter.i "Item"}
    ASSIGN cTexto1 = RETURN-VALUE.
    {utp/ut-table.i mgind item 1}
    ASSIGN cTexto2 = RETURN-VALUE.
    {method/svc/errors/inserr.i
                    &ErrorNumber="56"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="cTexto1 + '~~~~' + cTexto2"}                   
END.
   


  /*** TEsta se Numero da tarefa ‚ maior que zero ***/
IF pTarefa > 0  and pOrigem = "MI":U THEN DO:
    /** Tarefa Inexistente **/
   if not can-find(first ord-taref
                  where ord-taref.nr-ord-produ = pNrOrdProdu
                  AND   ord-taref.cd-tarefa    = pTarefa no-lock) then do:
                 {method/svc/errors/inserr.i
                       &ErrorNumber="4308"
                       &ErrorType="EMS"
                       &ErrorSubType="ERROR"
                       &ErrorParameters="''"}             
   end.
end.

IF pTarefa > 0  and pOrigem = "MV":U THEN DO:
    /** Tarefa Inexistente **/
    /*** bo de tarefas **/
    IF NOT VALID-HANDLE(hDBOMV) OR
       hDBOMV:TYPE <> "PROCEDURE":U OR
       hDBOMV:FILE-NAME <> "frbo/bofr073.p":U THEN DO:
        run frbo/bofr073.p persistent set hDBOMV.
    END.
      /** Seta as restri‡äes pelo n£mero do ordeem **/
    run setConstraintFaixaOM in hDBOMV (input pNrOrdProdu,
                                        input pNrOrdProdu) NO-ERROR.
      /** Seta as restri‡äes pelo n£mero do tarefa **/
    run setConstraintFaixaTarefa in hDBOMV (input pTarefa,
                                            input pTarefa) NO-ERROR.
    RUN openQueryStatic IN hDBOMV (INPUT "OMTarefa":U) NO-ERROR.
    /** Posiciona BO no registro **/
    run getFirst in hDBOMV.
   /*** NÆo econtra mostra mensagem de erro****/
    if return-value = "NOK":U then do:
                 {method/svc/errors/inserr.i
                       &ErrorNumber="4308"
                       &ErrorType="EMS"
                       &ErrorSubType="ERROR"
                       &ErrorParameters="''"}  
    end.
 /*** Elimina as variaveis da mem¢ria ***/
  if valid-handle(hDBOMV) THEN   
      run Destroy in hDBOMV.
  
end.

 /**** Verifica se usu rio esta cadastrado ****/
for first usuar-mater fields(cod-usuario usuar-requis usuar-solic tp-preco) 
    where usuar-mater.cod-usuario = pRequis no-lock: 
end.
if not avail usuar-mater then do:
{utp/ut-liter.i "Requisitante"}
/* Usu rio de Materiais nÆo cadastrado */
{method/svc/errors/inserr.i &ErrorNumber="56"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"
                            &ErrorParameters="return-value"}  
end.
else do:

    if pTipo = 1 and
        not usuar-mater.usuar-requis then do:
        {method/svc/errors/inserr.i &ErrorNumber="15424"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="pRequis"}
    end.
    else if pTipo > 1 and
        not usuar-mater.usuar-solic then do:
        {method/svc/errors/inserr.i &ErrorNumber="1083"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="''"}        
    end.
end.


/*:T--- Verifica ocorrˆncia de erros ---*/
IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
    RETURN "NOK":U.



RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaSaldoEstoque DBOProgram 
PROCEDURE validaSaldoEstoque :
/*------------------------------------------------------------------------------
  Purpose:     validaSaldoEstoque
  Parameters:  Entrada pItem    = C¢digo do item
               Entrada pEstabel = C¢digo do estabelecimento
               Entrada pRefer   = C¢digo da referˆncia do item
               Entrada pQuant   = Quantidade requisitada
               Sa¡da   pSaldo   = Saldo em estoque do item
               Sa¡da   plSaldo  = Avisa se saldo ‚ suficiente
  Notes:       Esta valida‡Æo de saldo em estque ‚ realizada de acordo com a 
               leitura realizada nos saldos do item pelo programa de atendimento
               da requisi‡Æo.
------------------------------------------------------------------------------*/
define input  parameter pItem     like item.it-codigo          no-undo.
define input  parameter pEstabel  like item.cod-estabel        no-undo.
define input  parameter pRefer    like item.cod-refer          no-undo.
define input  parameter pQuant    like saldo-estoq.qtidade-atu no-undo.
define output parameter pSaldo    like saldo-estoq.qtidade-atu no-undo.
define output parameter plSaldo   as logical                   no-undo.

define variable de-total like saldo-estoq.qtidade-atu no-undo.

assign plSaldo  = no
       pSaldo   = 0
       de-total = 0.

for first item fields (tipo-con-est)
    where item.it-codigo = pItem no-lock:
    /**********************************************************
    *** Verifica o tipo de Controle do Item                  **
    **********************************************************/
    if  item.tipo-con-est = 4 then do:  /** Por Referˆncia **/
        for each saldo-estoq no-lock
            where saldo-estoq.it-codigo   = pItem
            and   saldo-estoq.cod-estabel = pEstabel
            and   saldo-estoq.cod-refer   = pRefer
            and  (saldo-estoq.qtidade-atu
                  - (saldo-estoq.qt-alocada
                     +  saldo-estoq.qt-aloc-ped
                     +  saldo-estoq.qt-aloc-prod)) > 0:
            assign de-total = de-total + (saldo-estoq.qtidade-atu - 
                                          (saldo-estoq.qt-alocada  + 
                                           saldo-estoq.qt-aloc-ped +  
                                           saldo-estoq.qt-aloc-prod)).
        end.
    end.
    else do:   /** Outros **/
        for each saldo-estoq no-lock
            where saldo-estoq.it-codigo   = pItem
            and   saldo-estoq.cod-estabel = pEstabel
            and  (saldo-estoq.qtidade-atu
                  - (saldo-estoq.qt-alocada
                     +  saldo-estoq.qt-aloc-ped
                     +  saldo-estoq.qt-aloc-prod)) > 0:
            assign de-total = de-total + (saldo-estoq.qtidade-atu - 
                                          (saldo-estoq.qt-alocada  + 
                                           saldo-estoq.qt-aloc-ped +  
                                           saldo-estoq.qt-aloc-prod)).
        end.
    end.
end.

if de-total > 0 then do:
    /** Guarda dados de retorno **/
    assign plSaldo = if de-total >= pQuant then yes else no
           pSaldo  = de-total.
end.

return "OK":U.

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
    
    DEFINE VARIABLE cTexto1 AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cTexto2 AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cTexto3 AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cTexto  AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cTexto4 AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cOrdem AS CHARACTER  NO-UNDO.

    ASSIGN c-param = pType.
    /*:T--- Utilize o parƒmetro pType para identificar quais as valida‡äes a serem
         executadas ---*/
   /*:T--- Os valores poss¡veis para o parƒmetro sÆo: Create, Delete e Update ---*/
   /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do 
         include: method/svc/errors/inserr.i ---*/
   /*:T--- Inclua aqui as valida‡äes ---*/

   /** Valida‡äes de Cria‡Æo **/
   if pType = "CREATE":U then do:
       /*** Valor da Ordem de manuten‡Æo nÆo pode ser gravado com valor zero ***/
       {utp/ut-liter.i "N£mero da Ordem de Manuten‡Æo"}
       if RowObject.nr-ord-produ = 0 then do:
             {method/svc/errors/inserr.i
                         &ErrorNumber="7965"
                         &ErrorType="EMS"
                         &ErrorSubType="ERROR"
                         &ErrorParameters="return-value"} 
       end.
       ELSE DO:
           /***Origem da Ordem ‚ de manuten‡Æo Industrial***/
           IF RowObject.origem = "MI":U THEN DO:
              /** Ordem Inexistente **/
              if not can-find(first ord-manut
                 where ord-manut.nr-ord-produ = RowObject.nr-ord-produ) then do:
                 ASSIGN cTexto2 = STRING(RowObject.nr-ord-produ).
                 {utp/ut-liter.i "Ordem de Manuten‡Æo"}
                 ASSIGN cTexto = RETURN-VALUE.
                 {utp/ut-liter.i "nÆo cadastrada"}
                 {method/svc/errors/inserr.i
                                 &ErrorNumber="17567"
                                 &ErrorType="EMS"
                                 &ErrorSubType="ERROR"
                                 &ErrorParameters="cTexto + '~~~~' + cTexto2 + '~~~~' + return-value"}                    
               end.
              /***Ordem nÆo pode ter o estado de encerrada**/
               for first ord-manut
                     where ord-manut.nr-ord-produ = RowObject.nr-ord-produ no-lock:
                     if ord-manut.estado = 8 then do:
                        assign cOrdem = string(RowObject.nr-ord-produ).
                        {method/svc/errors/inserr.i
                               &ErrorNumber="17543"
                               &ErrorType="EMS"
                               &ErrorSubType="ERROR"
                               &ErrorParameters="cOrdem"}  
                     end.
               end.

                if l-usa-unid-negoc AND RowObject.origem = "MI":U then do:
                    
                    define variable h-cdapi024 as handle no-undo.

                    run cdp/cdapi024.p persistent set h-cdapi024.
                    
                    for each RowErrors:
                        delete RowErrors.
                    end.

                    FOR FIRST ord-manut WHERE ord-manut.nr-ord-produ = RowObject.nr-ord-produ NO-LOCK: 
                        run ValidaUnidadeNegocioUsuario in h-cdapi024(input c-seg-usuario,
                                                                      input &if defined(bf_mnt_ems207) &then ord-manut.cod-unid-negoc &else substring(ord-manut.char-1,19,3) &endif,
                                                                      output table tt-Erro).
                        FOR EACH tt-erro:
                           ASSIGN cTexto4 = c-seg-usuario + "~~" + &if defined(bf_mnt_ems207) &then ord-manut.cod-unid-negoc &else substring(ord-manut.char-1,19,3) &endif.
                           {method/svc/errors/inserr.i
                               &ErrorNumber = tt-erro.cd-erro
                               &ErrorType = "EMS"
                               &ErrorSubType = "ERROR"
                               &ErrorParameters = cTexto4}
                           RETURN "NOK":U.
                        END.      
                    END.
                    
                    if valid-handle(h-cdapi024) then RUN pi-finalizar IN h-cdapi024.
                                            
                end.

           END.
           for first ord-prod fields (nr-ord-produ origem)
               where ord-prod.nr-ord-produ = RowObject.nr-ord-produ 
               and   ord-prod.origem       = "MI":U no-lock:
               /*** Testa se existe a ordem de produ‡Æo ***/
               if not avail ord-prod then do:
                    {method/svc/errors/inserr.i            
                                &ErrorNumber="2670"     
                                &ErrorType="EMS"        
                                &ErrorSubType="ERROR"   
                                &ErrorParameters="return-value"} 
               end.
               else do:
                 /*** Verifica se origem ‚ igual a informada em tela ****/
                 if ord-prod.origem <> RowObject.origem then do:
                     {utp/ut-liter.i "Origem da Ordem ‚ diferente da informada em tela"}
                     {method/svc/errors/inserr.i            
                                    &ErrorNumber="17567"     
                                    &ErrorType="EMS"        
                                    &ErrorSubType="ERROR"   
                                    &ErrorParameters="return-value"} 
                  end.
               end.
           end.
           IF RowObject.origem = "MI":U THEN DO:
               &IF DEFINED (bf_mnt_ems206b) &THEN
                   FOR FIRST ord-prod FIELDS (nr-ord-produ char-1)
                       WHERE ord-prod.nr-ord-produ = RowObject.nr-ord-produ  NO-LOCK:
                       IF date(substring(ord-prod.char-1,1,10)) >  RowObject.dat-trans THEN DO:
                          {utp/ut-liter.i "Data de Requisi‡Æo"}
                          assign cTexto1 = trim(return-value).
                          {utp/ut-liter.i " menor que a data de inicio da Ordem"} 
                          assign cTexto2 = trim(return-value).
                          {method/svc/errors/inserr.i            
                                    &ErrorNumber="17567"     
                                    &ErrorType="EMS"        
                                    &ErrorSubType="ERROR"   
                                    &ErrorParameters="cTexto1 + ' (' + string(RowObject.dat-trans) + ') ' + cTexto2 + ' (' + string (ord-prod.dt-emissao) + ')' "}  
                       END.
                   END. 
               &else
                   /** Data de transa‡Æo maior que a data de inicio **/
                   FOR FIRST ord-prod FIELDS (nr-ord-produ dt-inicio dt-emissao)
                       WHERE ord-prod.nr-ord-produ = RowObject.nr-ord-produ  NO-LOCK:
                       IF ord-prod.dt-emissao >  RowObject.dat-trans THEN DO:
                          {utp/ut-liter.i "Data de Requisi‡Æo"}
                           assign cTexto1 = trim(return-value).
                          {utp/ut-liter.i " menor que a data de inicio da Ordem"} 
                          assign cTexto2 = trim(return-value).
                              {method/svc/errors/inserr.i            
                                               &ErrorNumber="17567"     
                                               &ErrorType="EMS"        
                                               &ErrorSubType="ERROR"   
                                               &ErrorParameters="cTexto1 + ' (' + string(RowObject.dat-trans) + ') ' + cTexto2 + ' (' + string (ord-prod.dt-emissao) + ')' "}  
                          end.                                         
                    END.
               &endIf
           END.
           ELSE DO:
               FOR FIRST ord-prod FIELDS (nr-ord-produ dt-inicio dt-emissao)
                   WHERE ord-prod.nr-ord-produ = RowObject.nr-ord-produ  NO-LOCK:
                   IF ord-prod.dt-emissao >  RowObject.dat-trans THEN DO:
                      {utp/ut-liter.i "Data de Requisi‡Æo"}
                      assign cTexto1 = trim(return-value).
                      {utp/ut-liter.i " menor que a data de inicio da Ordem"} 
                      assign cTexto2 = trim(return-value).
                      {method/svc/errors/inserr.i            
                                &ErrorNumber="17567"     
                                &ErrorType="EMS"        
                                &ErrorSubType="ERROR"   
                                &ErrorParameters="cTexto1 + ' (' + string(RowObject.dat-trans) + ') ' + cTexto2 + ' (' + string (ord-prod.dt-emissao) + ')' "}  
                   END.
               END.
           END.
       END.
       /** Se a Ordem est  Finalizada ou Terminada nÆo permite a inclusÆo da Requisi‡Æo/Solicita‡Æo de Compra **/
       for first ord-prod fields(estado cod-estabel)
           where ord-prod.nr-ord-produ = RowObject.nr-ord-produ no-lock:
           
           CASE ord-prod.estado:
               /* Ordem Finalizada*/
               WHEN 7 THEN DO:
                   IF not can-find(first funcao 
                            where funcao.cd-funcao = "spp-ativa-ordem-term":U /*Existe uma fun‡Æo que permite requisitar para ordens finalizadas*/
                            and   funcao.ativo no-lock) then do:
                           {method/svc/errors/inserr.i
                               &ErrorNumber="1882"
                               &ErrorType="EMS"
                               &ErrorSubType="ERROR"
                               &ErrorParameters="RowObject.nr-ord-produ"}
        
                   END.
                   ELSE DO:
                        {method/svc/errors/inserr.i
                               &ErrorNumber="18803"
                               &ErrorType="EMS"
                               &ErrorSubType="ERROR"
                               &ErrorParameters="RowObject.nr-ord-produ"}
                   END.
               END.

               /* Ordem est  TERMINADA */
               WHEN 8 THEN DO:
                   {method/svc/errors/inserr.i
                       &ErrorNumber="17543"
                       &ErrorType="EMS"
                       &ErrorSubType="ERROR"
                       &ErrorParameters="RowObject.nr-ord-produ"}
               END.
           END CASE.

           /**
            * Valida seguran‡a por estabelecimento
            */
           IF l-estab-security-active THEN DO:
               IF NOT CAN-FIND (FIRST tt_estab_ems2
                                WHERE tt_estab_ems2.tta_cod_estab = ord-prod.cod-estabel) THEN DO:
                   {method/svc/errors/inserr.i            
                                &ErrorNumber="2670"     
                                &ErrorType="EMS"        
                                &ErrorSubType="ERROR"   
                                &ErrorParameters="return-value"}
               END.
           END.

       END.
   
   END.
   
    if pType = "DELETE":U  then do:
        if can-find(funcao where
                  funcao.cd-funcao = "Integra_AED_EMS" and
                  funcao.ativo     = yes) then do:
            IF RowObject.tp-requis = 1 THEN
                ASSIGN i-tipo-doc = 2.
            IF RowObject.tp-requis = 2 THEN
                ASSIGN i-tipo-doc = 1.
            for each it-requisicao 
                where it-requisicao.nr-requisicao = RowObject.nr-requisicao no-lock:
                run cdp/cdapi171.p (i-tipo-doc, 3, rowid(it-requisicao)).   
            END.
        END.
    END.
    
    &IF DEFINED(bf_mnt_ems206b) &THEN
        IF l-usa-unid-negoc AND ( pType = "update":U OR pType = "create":U ) THEN DO:
            RUN piValidaRestricoesUnidNegoc IN THIS-PROCEDURE.
        END.
    &ENDIF
    
    /*:T--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaMovimentoBGC DBOProgram 
PROCEDURE verificaMovimentoBGC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT  PARAM pNrRequisicao      LIKE {&TableName}.nr-requisicao NO-UNDO.
DEF INPUT  PARAM pNrSequencia       LIKE {&TableName}.sequencia     NO-UNDO.
DEF INPUT  PARAM pNrOrdProdu        LIKE {&TableName}.nr-ord-produ  NO-UNDO.
DEF OUTPUT PARAM lValidaMovtoReq    AS LOGICAL                      NO-UNDO.

    ASSIGN lValidaMovtoReq = NO.
    
    &IF DEFINED(bf_mnt_ems206b) &THEN

    /** Valida os movimentos de estoque com as requisi‡äes passadas **/
    FOR EACH  movto-estoq
        USE-INDEX  documento
       WHERE  movto-estoq.serie-docto = ""
       AND  movto-estoq.nro-docto   = STRING(pNrRequisicao,"999,999,999")
/*        AND  movto-estoq.num-sequen  = pNrSequencia */
       AND (movto-estoq.esp-docto   = 5   /* DEV */
        OR  movto-estoq.esp-docto   = 7   /* DRM */
        OR  movto-estoq.esp-docto   = 28  /* REQ */
        OR  movto-estoq.esp-docto   = 30) /* RM  */ NO-LOCK:
        
        /** Se j  achou movimento sai do bloco **/
        IF lValidaMovtoReq = YES THEN LEAVE.
        
        /** Posiciona na movto-mat, pois essa vai armazenar a sequˆncia correta  **/
        /** gerada para a movto-estoq                                            **/
        FOR FIRST movto-mat
            WHERE movto-mat.nr-ord-produ = pNrOrdProdu
            AND   movto-mat.nro-docto    = movto-estoq.nro-docto
            AND   movto-mat.num-sequen   = movto-estoq.num-sequen 
            AND   movto-mat.num-seq-req  = pNrSequencia NO-LOCK:
        END.
    
        IF NOT AVAIL movto-mat THEN NEXT.
    
        /** Procura o item-requisicao, validando movimenta‡äes da movto-mat e movto-estoq **/
        /** para a achar as informa‡äes                                                   **/
        IF CAN-FIND(FIRST it-requisicao
                    WHERE it-requisicao.nr-requisicao = INT(movto-estoq.nro-docto)
                    AND   it-requisicao.sequencia     = movto-mat.num-seq-req
                    AND   it-requisicao.it-codigo     = movto-estoq.it-codigo
                    AND   it-requisicao.cod-refer     = movto-estoq.cod-refer) THEN DO:
            
            ASSIGN lValidaMovtoReq = YES.
        END.
    END.

    &ENDIF



RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaStatusRequisicao DBOProgram 
PROCEDURE verificaStatusRequisicao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT  PARAM pNrRequisicao LIKE {&TableName}.nr-requisicao NO-UNDO.
DEF INPUT  PARAM pNrSequencia  LIKE {&TableName}.sequencia     NO-UNDO.
DEF OUTPUT PARAM pQuantidade   LIKE it-requisicao.qt-atendida NO-UNDO.
DEF OUTPUT PARAM pStatus       AS INTEGER                      NO-UNDO.
/***Busca registro na tabela it-requisicao***/
FOR FIRST it-requisicao FIELDS (qt-requisitada qt-atendida nr-requisicao situacao sequencia)
    WHERE it-requisicao.nr-requisicao =  pNrRequisicao
    AND   it-requisicao.sequencia     =  pNrSequencia NO-LOCK:
    /*** Verifica se Requisi‡Æo esta em aberto***/
    IF it-requisicao.situacao <> 2 THEN DO:
       IF it-requisicao.qt-atendida <> 0 
          and it-requisicao.qt-atendida = it-requisicao.qt-requisitada THEN DO:
             {utp/ut-liter.i "Item j  possui quantidade atendida, nÆo pode ser alterado"}    
             {method/svc/errors/inserr.i                     
                           &ErrorNumber="410"            
                           &ErrorType="EMS"                
                           &ErrorSubType="ERROR"           
                           &ErrorParameters="return-value"}
       END. 
       IF it-requisicao.qt-atendida <> 0 
          and it-requisicao.qt-atendida < it-requisicao.qt-requisitada THEN DO:
               ASSIGN pStatus     = 2
                      pQuantidade = it-requisicao.qt-requisitada - it-requisicao.qt-atendida.
                      if pQuantidade < 0 then
                         assign pQuantidade = 0.
       end.
       IF it-requisicao.qt-atendida = 0 then do:
           ASSIGN pStatus     = 2
                  pQuantidade = it-requisicao.qt-requisitada.
       END.
    END.
    ELSE DO:
        {utp/ut-liter.i "Requisi‡Æo esta encerrada"}                                                      
        {method/svc/errors/inserr.i                                                            
                        &ErrorNumber="17567"                                                   
                        &ErrorType="EMS"                                                       
                        &ErrorSubType="ERROR"                                                  
                        &ErrorParameters="return-value"}  
    END.
END.

/*:T--- Verifica ocorrˆncia de erros ---*/
IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
    RETURN "NOK":U.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaNecessidadeReq DBOProgram 
PROCEDURE buscaNecessidadeReq :
/*------------------------------------------------------------------------------
  Purpose:   
  Parameters:
  Notes:
------------------------------------------------------------------------------*/
DEFINE INPUT        PARAMETER pNrOrdProdu LIKE req-ord-produc.nr-ord-produ.
DEFINE INPUT        PARAMETER pCodEstabel AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER pCodEquipto AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER pPeriodo AS INT NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttOmsMateriais.


FOR EACH req-ord-produc 
    WHERE req-ord-produc.nr-ord-produ = pNrOrdProdu
    AND   req-ord-produc.tp-requis    = 1 NO-LOCK:
    FOR EACH it-requisicao 
        WHERE it-requisicao.nr-requisicao = req-ord-produc.nr-requisicao 
        AND   it-requisicao.sequencia     = req-ord-produc.sequencia NO-LOCK:
        IF NOT CAN-FIND(FIRST ttOmsMateriais
                        WHERE ttOmsMateriais.codItem = it-requisicao.it-codigo
                        AND   ttOmsMateriais.nrOrdem = req-ord-produc.nr-ord-produ ) THEN DO:

            CREATE ttOmsMateriais.
            ASSIGN ttOmsMateriais.codItem     = it-requisicao.it-codigo
                   ttOmsMateriais.chave       = it-requisicao.it-codigo
                   ttOmsMateriais.nrOrdem     = req-ord-produc.nr-ord-produ
                   ttOmsMateriais.solicReq    = it-requisicao.qt-requisitada
                   ttOmsMateriais.qtdAtendida = it-requisicao.qt-atendida
                   ttOmsMateriais.estabel     = pCodEstabel   
                   ttOmsMateriais.equipamento = pCodEquipto
                   ttOMsMateriais.periodo     = pPeriodo. 
        END.
        ELSE DO:
            FIND FIRST ttOmsMateriais
                WHERE ttOmsMateriais.codItem = it-requisicao.it-codigo
                AND   ttOmsMateriais.nrOrdem = req-ord-produc.nr-ord-produ NO-ERROR.
            IF AVAIL ttOmsMateriais THEN 
                ASSIGN ttOmsMateriais.solicReq    = ttOmsMateriais.solicReq + it-requisicao.qt-requisitada
                       ttOmsMateriais.qtdAtendida = ttOmsMateriais.qtdAtendida + it-requisicao.qt-atendida.
        END.

    END. /* for each it-requisicao */
END. /* for each req-ord-produc */

RETURN "OK":U.
END PROCEDURE.

PROCEDURE eliminaRegistroMLA:

    DEFINE VARIABLE h-mlaapi010a  AS HANDLE  NO-UNDO.
    DEFINE VARIABLE h-mlaapi010b  AS HANDLE  NO-UNDO.
    DEFINE VARIABLE i-tipo-doc AS INTEGER    NO-UNDO.

    IF  RowObject.tp-requis = 1 THEN
        ASSIGN i-tipo-doc = 2.
    IF  RowObject.tp-requis = 2 THEN
        ASSIGN i-tipo-doc = 1.

    RUN lap/mlaapi099.p (INPUT i-tipo-doc).

    if can-find(funcao where
                funcao.cd-funcao = "Integra_MLA_EMS" and
                funcao.ativo     = yes) AND RETURN-VALUE <> "NOK":U then do:
        FOR FIRST it-requisicao 
             where (it-requisicao.situacao = 1 /* Aberta */
             or     it-requisicao.situacao = 3) /* Pendente Complemento */
             and    it-requisicao.nr-requisicao = RowObject.nr-requisicao 
             AND    it-requisicao.sequencia = RowObject.sequencia no-lock:
             CASE i-tipo-doc:
                 WHEN 1 THEN DO:
                     IF  NOT VALID-HANDLE(h-mlaapi010a) THEN DO:
                         RUN lap/mlaapi010a.p PERSISTENT SET h-mlaapi010a (INPUT 3, INPUT ROWID(it-requisicao), OUTPUT TABLE tt-erro-mla).
                     END.

                     IF  VALID-HANDLE(h-mlaapi010a) THEN DO:
                         RUN pi-seta-ordem IN h-mlaapi010a (INPUT RowObject.nr-requisicao).
                         RUN pi-executar IN h-mlaapi010a (INPUT 3, INPUT ROWID(it-requisicao), OUTPUT TABLE tt-erro-mla).
                         RUN getRowErrors IN h-mlaapi010a (OUTPUT TABLE RowErrors).
                     END.

                     IF VALID-HANDLE(h-mlaapi010a) THEN
                         DELETE OBJECT h-mlaapi010a.	
                 END.
                 WHEN 2 THEN DO:
                     IF  NOT VALID-HANDLE(h-mlaapi010b) THEN DO:
                         RUN lap/mlaapi010b.p PERSISTENT SET h-mlaapi010b (INPUT 3, INPUT ROWID(it-requisicao), OUTPUT TABLE tt-erro-mla).
                     END.

                     IF  VALID-HANDLE(h-mlaapi010b) THEN DO:
                         RUN pi-seta-ordem IN h-mlaapi010b (INPUT RowObject.nr-requisicao).
                         RUN pi-executar IN h-mlaapi010b (INPUT 3, INPUT ROWID(it-requisicao), OUTPUT TABLE tt-erro-mla).
                         RUN getRowErrors IN h-mlaapi010b (OUTPUT TABLE RowErrors).
                     END.

                     IF VALID-HANDLE(h-mlaapi010b) THEN
                         DELETE OBJECT h-mlaapi010b.	
                 END.
             END CASE.
         END.
    END.

    RETURN "OK":U.
END PROCEDURE.
