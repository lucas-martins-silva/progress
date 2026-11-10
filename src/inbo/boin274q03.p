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
{include/i-prgvrs.i BOIN274Q03 2.00.00.015} /*** "010015" 23/11/2023 16:19:45  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin274q03 MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : 
    Purpose    : O DBO (Datasul Business Objects) ‚ um programa PROGRESS
                 que cont‚m a l¢gica de neg¢cio e acesso a dados para uma
                 tabela do banco de dados.

    Parameters :

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName tt-ordem-compra
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions
&scoped-define FIRST-TABLE-IN-QUERY tt-ordem-compra
&GLOBAL-DEFINE TableName tt-ordem-compra
&GLOBAL-DEFINE TableLabel tt-ordem-compra
&GLOBAL-DEFINE QueryName qr{&TableName}

/*********************************************************************************
**  S¢ a DBO principal (boin274.p) est  com as fun‡äes de inclui (createRecord), 
**  modifica (updateRecord) e elimina (deleteRecord) habilitadas, 
**  porque Sà nela foram implementadas as triggers do dicion rio.
**  Para desabilitar as procedures foram usados os pr‚-processadores abaixo.
**  A procedure validateRecord dessa DBO nÆo deve ser usada.
*********************************************************************************/
&GLOBAL-DEFINE EXCLUDE-createRecord 0
&GLOBAL-DEFINE EXCLUDE-updateRecord 0
&GLOBAL-DEFINE EXCLUDE-deleteRecord 0


/*--- Include com defini‡Æo da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com
      extensÆo .i ---*/
{include/boini.i}
{inbo/boin274q03.i tt-ordem-compra}
{inbo/boin274q03.i RowObject}

/*--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo
      manual da query ---*/
{method/dboqry.i}


/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/* Include com pr‚-processadores que diferenciam releases */
{cdp/cdcfgmat.i}  /* Include com pr‚-processadores que indicam mudan‡as na base */

/* Vari veis necess rias aos setConstraint's */

    def var cCodEstabelIni   as char no-undo.
    def var cCodEstabelFim   as char no-undo.
    def var cCodComprado     as char no-undo.
    def var cItCodigoIni     as char no-undo.
    def var cItCodigoFim     as char no-undo.
    def var daDataEmissaoIni as date no-undo.
    def var daDataEmissaoFim as date no-undo.
    def var iNumOrdemIni     as int  no-undo.
    def var iNumOrdemFim     as int  no-undo.
    def var cNomeAbrevIni    as char no-undo.
    def var cNomeAbrevFim    as char no-undo.
    def var cFamiliaIni      as char no-undo.
    def var cFamiliaFim      as char no-undo.  
    def var iProcessoIni     as int  no-undo.
    def var iprocessoFim     as int  no-undo.  

    define buffer bfordem   for ordem-compra.
    
    def var r-first         as ROWID no-undo.
    def var r-last          as ROWID no-undo.
    def var c-naveg         as char  no-undo.
    def var r-ordem-compra  as ROWID no-undo.
    def var i-nrlinhas      as int   no-undo.
    DEF VAR r-rowid-last    AS ROWID NO-UNDO.
    DEF VAR r-rowid-first   AS ROWID NO-UNDO.
    DEF VAR l-achou-last    AS LOGICAL NO-UNDO.
    def var l-achou-first   as logical no-undo.
    
    def var l-existe-ordem  as log no-undo.

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
         HEIGHT             = 25
         WIDTH              = 61.86.
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



/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCopyBuffer2TT DBOProgram 
PROCEDURE afterCopyBuffer2TT :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN RowObject.r-rowid = {&TableName}.r-rowid.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterGetRowid DBOProgram 
PROCEDURE afterGetRowid :
/*------------------------------------------------------------------------------
  Purpose:     Envia rowid do registro corrente da table {&Tablename}
  Parameters:  retorna rowid
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE input-output PARAMETER pRowid  AS ROWID NO-UNDO.

    ASSIGN pRowid = {&TableName}.r-rowid.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeRepositionRecord DBOProgram 
PROCEDURE beforeRepositionRecord :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona query
  Parameters:  recebe rowid da tabela {&TableName}
  Notes:       Atualiza temptable RowObject (_copyBuffer2TT)
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pRowid  AS ROWID NO-UNDO.
    
    FIND {&TableName} WHERE {&TableName}.r-rowid = pRowid NO-LOCK NO-ERROR.
    
    ASSIGN pRowid = ROWID({&TableName}).
    
    /*--- Reposiciona query ---*/
    REPOSITION {&QueryName} TO ROWID pRowid NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        /*--- Erro 11: NÆo foi poss¡vel reposicionar a query ---*/
        {method/svc/errors/inserr.i &ErrorNumber="11"
                                    &ErrorType="INTERNAL"
                                    &ErrorSubType="ERROR"}
        
        RETURN "NOK":U.
    END.
    
    /*---  necess rio para o correto funcionamento do reposicionamento ---*/
    GET NEXT {&QueryName} NO-LOCK.
    
    /*--- Seta flag indicando que o registro atual foi reposicionado ---*/
    &if "{&DBType}" = "ORACLE":U &then
        ASSIGN lRepositioned = YES.
    &endif
    
    /*--- Atualiza temptable RowObject ---*/
    RUN _copyBuffer2TT IN THIS-PROCEDURE.
    
    
    RETURN "NOK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraOrdensPendenciasComprador DBOProgram 
PROCEDURE geraOrdensPendenciasComprador :
/*------------------------------------------------------------------------------
  Purpose:   Gera ordens para a consulta de pendˆncias do 
             comprador do m¢dulo de compras.
  Parƒmetros:
------------------------------------------------------------------------------*/
    def input param pcCodComprado     as char no-undo.
    def input param piNumOrdemIni     as int  no-undo.
    def input param piNumOrdemFim     as int  no-undo. 
    def input param pcCodEstabelIni   as char no-undo.
    def input param pcCodEstabelFim   as char no-undo.
    def input param pdaDataEmissaoIni as date no-undo.
    def input param pdaDataEmissaoFim as date no-undo.
    def input param pcItCodigoIni     as char no-undo.
    def input param pcItCodigoFim     as char no-undo.
    def input param pcNomeAbrevIni    as char no-undo.
    def input param pcNomeAbrevFim    as char no-undo.    
    def input param pcFamiliaIni      as char no-undo.
    def input param pcFamiliaFim      as char no-undo. 
    def input param piProcessoIni     as int  no-undo.
    def input param piProcessoFim     as int  no-undo.
    def input param pcRequisitanteIni as char no-undo.
    def input param pcRequisitanteFim as char no-undo.

    def var i-cont as integer no-undo format "99999".
    
    for each tt-ordem-compra:
        delete tt-ordem-compra.
    end.

    assign i-cont = 0.

    for each ordem-compra WHERE
             ordem-compra.cod-comprado = pcCodComprado      AND
             /* Filtro */
             ordem-compra.numero-ordem >= piNumOrdemIni     AND
             ordem-compra.numero-ordem <= piNumOrdemFim     AND
             ordem-compra.cod-estabel  >= pcCodEstabelIni   AND
             ordem-compra.cod-estabel  <= pcCodEstabelFim   AND
             ordem-compra.data-emissao >= pdaDataEmissaoIni AND
             ordem-compra.data-emissao <= pdaDataEmissaoFim AND
             ordem-compra.it-codigo    >= pcItCodigoIni     AND
             ordem-compra.it-codigo    <= pcItCodigoFim     AND
             ordem-compra.nr-processo  >= piProcessoIni     AND
             ordem-compra.nr-processo  <= piProcessoFim     AND
             ordem-compra.requisitante >= pcRequisitanteIni AND
             ordem-compra.requisitante <= pcRequisitanteFim AND
              /* Filtro */
            (ordem-compra.situacao = 5 or ordem-compra.situacao = 1) NO-LOCK,
       first emitente where
             emitente.cod-emitente  = ordem-compra.cod-emitente AND
             emitente.nome-abrev   >= pcNomeAbrevIni            AND
             emitente.nome-abrev   <= pcNomeAbrevFim         
             no-lock,
       first item where
             item.it-codigo  = ordem-compra.it-codigo           AND
             item.fm-codigo >= pcFamiliaIni                     AND
             item.fm-codigo <= pcFamiliaFim no-lock:

        assign i-cont = i-cont + 1.

        create tt-ordem-compra.
        assign tt-ordem-compra.numero-ordem  = ordem-compra.numero-ordem
               tt-ordem-compra.cod-estabel   = ordem-compra.cod-estabel
               tt-ordem-compra.dep-almoxar   = ordem-compra.dep-almoxar
               tt-ordem-compra.cod-emitente  = ordem-compra.cod-emitente
               tt-ordem-compra.data-emissao  = ordem-compra.data-emissao
               tt-ordem-compra.it-codigo     = ordem-compra.it-codigo
               tt-ordem-compra.situacao      = ordem-compra.situacao
               tt-ordem-compra.pre-unit-for  = ordem-compra.pre-unit-for
               tt-ordem-compra.qt-acum-dev   = ordem-compra.qt-acum-dev
               tt-ordem-compra.qt-acum-nec   = ordem-compra.qt-acum-nec
               tt-ordem-compra.qt-acum-rec   = ordem-compra.qt-acum-rec
               tt-ordem-compra.qt-solic      = ordem-compra.qt-solic
               tt-ordem-compra.narrativa     = ordem-compra.narrativa
               tt-ordem-compra.nr-requisicao = ordem-compra.nr-requisicao
               tt-ordem-compra.item-narrat   = item.narrativa
               tt-ordem-compra.r-ordem       = rowid(ordem-compra)
               tt-ordem-compra.r-rowid       = to-rowid("0x0" + string(i-cont,"99999")).

        if item.it-codigo = "" and item.tipo-contr = 4 then  /* debito direto */
            assign tt-ordem-compra.desc-item = substr(ordem-compra.narrativa,1,60).
        else
            assign tt-ordem-compra.desc-item = item.desc-item.
    end.
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraOrdensPendenciasCompradorWeb DBOProgram 
PROCEDURE geraOrdensPendenciasCompradorWeb :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------
  Purpose:   Gera ordens para a consulta de pendˆncias do 
             comprador do m¢dulo de compras.
  Parƒmetros:
------------------------------------------------------------------------------*/
    def input param pcCodComprado     as char no-undo.
    def input param piNumOrdemIni     as int  no-undo.
    def input param piNumOrdemFim     as int  no-undo. 
    def input param pcCodEstabelIni   as char no-undo.
    def input param pcCodEstabelFim   as char no-undo.
    def input param pdaDataEmissaoIni as date no-undo.
    def input param pdaDataEmissaoFim as date no-undo.
    def input param pcItCodigoIni     as char no-undo.
    def input param pcItCodigoFim     as char no-undo.
    def input param pcNomeAbrevIni    as char no-undo.
    def input param pcNomeAbrevFim    as char no-undo.    
    def input param pcFamiliaIni      as char no-undo.
    def input param pcFamiliaFim      as char no-undo. 
    def input param piProcessoIni     as int  no-undo.
    def input param piProcessoFim     as int  no-undo.
    def input param pcRequisitanteIni as char no-undo.
    def input param pcRequisitanteFim as char no-undo.

    def buffer b-ordem for ordem-compra.

    def var i-cont         as integer no-undo format "99999".
    def var l-existe-ordem as logical no-undo.
    
    /* O pr‚-processador abaixa testa a versÆo do PROGRESS */
    &IF INT (SUBSTRING (PROVERSION, 1, INDEX (PROVERSION, ".") - 1)) >= 9 &THEN          
        EMPTY TEMP-TABLE tt-ordem-compra.
    &ELSE
        FOR EACH tt-ordem-compra:
            DELETE tt-ordem-compra.
        END.
    &ENDIF   
    
    assign i-cont         = 0
           /* Esta atualizacao foi implementada para evitar que o programa mostre um
              registro a mais na tela quando o evento for = "ant" */
           l-existe-ordem = no
           r-first        = ?
           l-achou-last   = NO
           l-achou-first  = no.
           
    FOR EACH ordem-compra 
        FIELDS(cod-comprado numero-ordem cod-estabel   data-emissao
               it-codigo    requisitante cod-emitente  dep-almoxar
               situacao     pre-unit-for qt-acum-nec   qt-acum-rec
               qt-solic     narrativa    nr-requisicao qt-acum-dev
               nr-processo) USE-INDEX compr-sit
        WHERE ordem-compra.cod-comprado = pcCodComprado      
          AND ordem-compra.situacao     = 5
          AND ordem-compra.numero-ordem >= piNumOrdemIni     
          AND ordem-compra.numero-ordem <= piNumOrdemFim     
          AND ordem-compra.cod-estabel  >= pcCodEstabelIni   
          AND ordem-compra.cod-estabel  <= pcCodEstabelFim   
          AND ordem-compra.data-emissao >= pdaDataEmissaoIni 
          AND ordem-compra.data-emissao <= pdaDataEmissaoFim 
          AND ordem-compra.it-codigo    >= pcItCodigoIni     
          AND ordem-compra.it-codigo    <= pcItCodigoFim     
          AND ordem-compra.nr-processo  >= piProcessoIni     
          AND ordem-compra.nr-processo  <= piProcessoFim     
          AND ordem-compra.requisitante >= pcRequisitanteIni 
          AND ordem-compra.requisitante <= pcRequisitanteFim NO-LOCK,
        FIRST emitente FIELDS(cod-emitente nome-abrev) 
        WHERE emitente.cod-emitente  = ordem-compra.cod-emitente 
          AND emitente.nome-abrev   >= pcNomeAbrevIni            
          AND emitente.nome-abrev   <= pcNomeAbrevFim NO-LOCK,
        FIRST ITEM FIELDS(it-codigo fm-codigo narrativa tipo-contr desc-item) 
        WHERE ITEM.it-codigo  = ordem-compra.it-codigo           
          AND ITEM.fm-codigo >= pcFamiliaIni                     
          AND ITEM.fm-codigo <= pcFamiliaFim NO-LOCK:

        ASSIGN i-cont = i-cont + 1.
        CREATE tt-ordem-compra.
        ASSIGN tt-ordem-compra.numero-ordem  = ordem-compra.numero-ordem
               tt-ordem-compra.cod-estabel   = ordem-compra.cod-estabel
               tt-ordem-compra.dep-almoxar   = ordem-compra.dep-almoxar
               tt-ordem-compra.cod-emitente  = ordem-compra.cod-emitente
               tt-ordem-compra.data-emissao  = ordem-compra.data-emissao
               tt-ordem-compra.it-codigo     = ordem-compra.it-codigo
               tt-ordem-compra.situacao      = ordem-compra.situacao
               tt-ordem-compra.pre-unit-for  = ordem-compra.pre-unit-for
               tt-ordem-compra.qt-acum-dev   = ordem-compra.qt-acum-dev
               tt-ordem-compra.qt-acum-nec   = ordem-compra.qt-acum-nec
               tt-ordem-compra.qt-acum-rec   = ordem-compra.qt-acum-rec
               tt-ordem-compra.qt-solic      = ordem-compra.qt-solic
               tt-ordem-compra.narrativa     = ordem-compra.narrativa
               tt-ordem-compra.nr-requisicao = ordem-compra.nr-requisicao
               tt-ordem-compra.item-narrat   = ITEM.narrativa
               tt-ordem-compra.r-ordem       = ROWID(ordem-compra)
               tt-ordem-compra.r-rowid       = to-rowid("0x0" + string(i-cont,"99999")).


        IF  ITEM.it-codigo = "" AND ITEM.tipo-contr = 4 THEN  /* debito direto */
            ASSIGN tt-ordem-compra.desc-item = SUBSTR(ordem-compra.narrativa,1,60).
        ELSE
            ASSIGN tt-ordem-compra.desc-item = ITEM.desc-item.

    END.

    FOR EACH ordem-compra 
        FIELDS(cod-comprado numero-ordem cod-estabel   data-emissao
               it-codigo    requisitante cod-emitente  dep-almoxar
               situacao     pre-unit-for qt-acum-nec   qt-acum-rec
               qt-solic     narrativa    nr-requisicao qt-acum-dev
               nr-processo) USE-INDEX compr-sit
        WHERE ordem-compra.cod-comprado = pcCodComprado      
          AND ordem-compra.situacao     = 1
          AND ordem-compra.numero-ordem >= piNumOrdemIni     
          AND ordem-compra.numero-ordem <= piNumOrdemFim     
          AND ordem-compra.cod-estabel  >= pcCodEstabelIni   
          AND ordem-compra.cod-estabel  <= pcCodEstabelFim   
          AND ordem-compra.data-emissao >= pdaDataEmissaoIni 
          AND ordem-compra.data-emissao <= pdaDataEmissaoFim 
          AND ordem-compra.it-codigo    >= pcItCodigoIni     
          AND ordem-compra.it-codigo    <= pcItCodigoFim     
          AND ordem-compra.nr-processo  >= piProcessoIni     
          AND ordem-compra.nr-processo  <= piProcessoFim     
          AND ordem-compra.requisitante >= pcRequisitanteIni 
          AND ordem-compra.requisitante <= pcRequisitanteFim NO-LOCK,
        FIRST emitente FIELDS(cod-emitente nome-abrev) 
        WHERE emitente.cod-emitente  = ordem-compra.cod-emitente 
          AND emitente.nome-abrev   >= pcNomeAbrevIni            
          AND emitente.nome-abrev   <= pcNomeAbrevFim NO-LOCK,
        FIRST ITEM FIELDS(it-codigo fm-codigo narrativa tipo-contr desc-item) 
        WHERE ITEM.it-codigo  = ordem-compra.it-codigo           
          AND ITEM.fm-codigo >= pcFamiliaIni                     
          AND ITEM.fm-codigo <= pcFamiliaFim NO-LOCK:

        ASSIGN i-cont = i-cont + 1.
        CREATE tt-ordem-compra.
        ASSIGN tt-ordem-compra.numero-ordem  = ordem-compra.numero-ordem
               tt-ordem-compra.cod-estabel   = ordem-compra.cod-estabel
               tt-ordem-compra.dep-almoxar   = ordem-compra.dep-almoxar
               tt-ordem-compra.cod-emitente  = ordem-compra.cod-emitente
               tt-ordem-compra.data-emissao  = ordem-compra.data-emissao
               tt-ordem-compra.it-codigo     = ordem-compra.it-codigo
               tt-ordem-compra.situacao      = ordem-compra.situacao
               tt-ordem-compra.pre-unit-for  = ordem-compra.pre-unit-for
               tt-ordem-compra.qt-acum-dev   = ordem-compra.qt-acum-dev
               tt-ordem-compra.qt-acum-nec   = ordem-compra.qt-acum-nec
               tt-ordem-compra.qt-acum-rec   = ordem-compra.qt-acum-rec
               tt-ordem-compra.qt-solic      = ordem-compra.qt-solic
               tt-ordem-compra.narrativa     = ordem-compra.narrativa
               tt-ordem-compra.nr-requisicao = ordem-compra.nr-requisicao
               tt-ordem-compra.item-narrat   = ITEM.narrativa
               tt-ordem-compra.r-ordem       = ROWID(ordem-compra)
               tt-ordem-compra.r-rowid       = to-rowid("0x0" + string(i-cont,"99999")).


        IF  ITEM.it-codigo = "" AND ITEM.tipo-contr = 4 THEN  /* debito direto */
            ASSIGN tt-ordem-compra.desc-item = SUBSTR(ordem-compra.narrativa,1,60).
        ELSE
            ASSIGN tt-ordem-compra.desc-item = ITEM.desc-item.

    END.

    /*
    if can-find(first ordem-compra where
                      ordem-compra.cod-comprado = pcCodComprado      AND
                      /* Filtro */
                      ordem-compra.numero-ordem >= piNumOrdemIni     AND
                      ordem-compra.numero-ordem <= piNumOrdemFim     AND
                      ordem-compra.cod-estabel  >= pcCodEstabelIni   AND
                      ordem-compra.cod-estabel  <= pcCodEstabelFim   AND
                      ordem-compra.data-emissao >= pdaDataEmissaoIni AND
                      ordem-compra.data-emissao <= pdaDataEmissaoFim AND
                      ordem-compra.it-codigo    >= pcItCodigoIni     AND
                      ordem-compra.it-codigo    <= pcItCodigoFim     AND
                      ordem-compra.nr-processo  >= piProcessoIni     AND
                      ordem-compra.nr-processo  <= piProcessoFim     AND
                      ordem-compra.requisitante >= pcRequisitanteIni AND
                      ordem-compra.requisitante <= pcRequisitanteFim AND
                       (ordem-compra.situacao = 5 or ordem-compra.situacao = 1)) then do:
        for first ordem-compra fields(cod-comprado numero-ordem cod-estabel   data-emissao
                                      it-codigo    requisitante cod-emitente  dep-almoxar
                                      situacao     pre-unit-for qt-acum-nec   qt-acum-rec
                                      qt-solic     narrativa    nr-requisicao qt-acum-dev
                                      nr-processo) where
            ordem-compra.cod-comprado = pcCodComprado      AND
            /* Filtro */
            ordem-compra.numero-ordem >= piNumOrdemIni     AND
            ordem-compra.numero-ordem <= piNumOrdemFim     AND
            ordem-compra.cod-estabel  >= pcCodEstabelIni   AND
            ordem-compra.cod-estabel  <= pcCodEstabelFim   AND
            ordem-compra.data-emissao >= pdaDataEmissaoIni AND
            ordem-compra.data-emissao <= pdaDataEmissaoFim AND
            ordem-compra.it-codigo    >= pcItCodigoIni     AND
            ordem-compra.it-codigo    <= pcItCodigoFim     AND
            ordem-compra.nr-processo  >= piProcessoIni     AND
            ordem-compra.nr-processo  <= piProcessoFim     AND
            ordem-compra.requisitante >= pcRequisitanteIni AND
            ordem-compra.requisitante <= pcRequisitanteFim AND
            (ordem-compra.situacao = 5 or ordem-compra.situacao = 1) no-lock: end.

        for last b-ordem fields(cod-comprado numero-ordem cod-estabel   data-emissao
                                 it-codigo    requisitante cod-emitente  dep-almoxar
                                 situacao     pre-unit-for qt-acum-nec   qt-acum-rec
                                 qt-solic     narrativa    nr-requisicao qt-acum-dev
                                 nr-processo) where
            b-ordem.cod-comprado = pcCodComprado      AND
            /* Filtro */
            b-ordem.numero-ordem >= piNumOrdemIni     AND
            b-ordem.numero-ordem <= piNumOrdemFim     AND
            b-ordem.cod-estabel  >= pcCodEstabelIni   AND
            b-ordem.cod-estabel  <= pcCodEstabelFim   AND
            b-ordem.data-emissao >= pdaDataEmissaoIni AND
            b-ordem.data-emissao <= pdaDataEmissaoFim AND
            b-ordem.it-codigo    >= pcItCodigoIni     AND
            b-ordem.it-codigo    <= pcItCodigoFim     AND
            b-ordem.nr-processo  >= piProcessoIni     AND
            b-ordem.nr-processo  <= piProcessoFim     AND
            b-ordem.requisitante >= pcRequisitanteIni AND
            b-ordem.requisitante <= pcRequisitanteFim AND
            (b-ordem.situacao = 5 or b-ordem.situacao = 1) no-lock: end.

        assign l-existe-ordem = yes
               r-rowid-last = if avail b-ordem then 
                                  rowid(b-ordem) 
                              else 
                                  ?.
    end.
    
    if l-existe-ordem then do:
    
        assign r-rowid-first = rowid(ordem-compra).
        
        if r-ordem-compra <> ? then do:
            for first ordem-compra fields(cod-comprado numero-ordem cod-estabel   data-emissao
                                          it-codigo    requisitante cod-emitente  dep-almoxar
                                          situacao     pre-unit-for qt-acum-nec   qt-acum-rec
                                          qt-solic     narrativa    nr-requisicao qt-acum-dev
                                          nr-processo)   where
                rowid(ordem-compra) = r-ordem-compra no-lock: end.
            if avail ordem-compra then
                assign r-first = r-ordem-compra.
        end.
        
        do while i-cont <= i-nrlinhas:
            for first emitente fields(cod-emitente nome-abrev) where
                  emitente.cod-emitente  = ordem-compra.cod-emitente AND
                  emitente.nome-abrev   >= pcNomeAbrevIni            AND
                  emitente.nome-abrev   <= pcNomeAbrevFim         
                  no-lock: end.
            if avail emitente then 
                for first item fields(it-codigo fm-codigo narrativa tipo-contr desc-item) where
                      item.it-codigo  = ordem-compra.it-codigo           AND
                      item.fm-codigo >= pcFamiliaIni                     AND
                      item.fm-codigo <= pcFamiliaFim no-lock: end.
            if avail emitente and
               avail item then do:
                if not can-find(first tt-ordem-compra where
                                      tt-ordem-compra.numero-ordem = ordem-compra.numero-ordem) then do:
                    create tt-ordem-compra.
                    assign tt-ordem-compra.numero-ordem  = ordem-compra.numero-ordem
                           tt-ordem-compra.cod-estabel   = ordem-compra.cod-estabel
                           tt-ordem-compra.dep-almoxar   = ordem-compra.dep-almoxar
                           tt-ordem-compra.cod-emitente  = ordem-compra.cod-emitente
                           tt-ordem-compra.data-emissao  = ordem-compra.data-emissao
                           tt-ordem-compra.it-codigo     = ordem-compra.it-codigo
                           tt-ordem-compra.situacao      = ordem-compra.situacao
                           tt-ordem-compra.pre-unit-for  = ordem-compra.pre-unit-for
                           tt-ordem-compra.qt-acum-dev   = ordem-compra.qt-acum-dev
                           tt-ordem-compra.qt-acum-nec   = ordem-compra.qt-acum-nec
                           tt-ordem-compra.qt-acum-rec   = ordem-compra.qt-acum-rec
                           tt-ordem-compra.qt-solic      = ordem-compra.qt-solic
                           tt-ordem-compra.narrativa     = ordem-compra.narrativa
                           tt-ordem-compra.nr-requisicao = ordem-compra.nr-requisicao
                           tt-ordem-compra.item-narrat   = item.narrativa
                           tt-ordem-compra.r-ordem       = rowid(ordem-compra)
                           tt-ordem-compra.r-rowid       = rowid(ordem-compra)
                           i-cont                        = i-cont + 1
                           r-last                        = rowid(ordem-compra).
                                   
                    if item.it-codigo = "" and item.tipo-contr = 4 then  /* debito direto */
                        assign tt-ordem-compra.desc-item = substr(ordem-compra.narrativa,1,60).
                    else
                        assign tt-ordem-compra.desc-item = item.desc-item.
                end.
            end.
            if c-naveg = "ant":u then do:
                if rowid(ordem-compra) <> r-rowid-first then do:
                    assign r-first = rowid(ordem-compra).
                    find prev ordem-compra  where
                         ordem-compra.cod-comprado = pcCodComprado      AND
                         /* Filtro */
                         ordem-compra.numero-ordem >= piNumOrdemIni     AND
                         ordem-compra.numero-ordem <= piNumOrdemFim     AND
                         ordem-compra.cod-estabel  >= pcCodEstabelIni   AND
                         ordem-compra.cod-estabel  <= pcCodEstabelFim   AND
                         ordem-compra.data-emissao >= pdaDataEmissaoIni AND
                         ordem-compra.data-emissao <= pdaDataEmissaoFim AND
                         ordem-compra.it-codigo    >= pcItCodigoIni     AND
                         ordem-compra.it-codigo    <= pcItCodigoFim     AND
                         ordem-compra.nr-processo  >= piProcessoIni     AND
                         ordem-compra.nr-processo  <= piProcessoFim     AND
                         ordem-compra.requisitante >= pcRequisitanteIni AND
                         ordem-compra.requisitante <= pcRequisitanteFim AND
                         (ordem-compra.situacao = 5 or ordem-compra.situacao = 1) 
                         no-lock no-error.
                end.
                else do:
                    assign r-first = ?
                           i-cont  = 15
                           c-naveg = "pro":u.
                    find last tt-ordem-compra use-index codigo.
                    assign r-last = tt-ordem-compra.r-ordem. 

                    /*
                    /* O pr‚-processador abaixa testa a versÆo do PROGRESS */
                    &IF INT (SUBSTRING (PROVERSION, 1, INDEX (PROVERSION, ".") - 1)) >= 9 &THEN          
                        EMPTY TEMP-TABLE tt-ordem-compra.
                    &ELSE
                        FOR EACH tt-ordem-compra:
                            DELETE tt-ordem-compra.
                        END.
                    &ENDIF
                    for first ordem-compra fields(cod-comprado numero-ordem cod-estabel   data-emissao
                                                  it-codigo    requisitante cod-emitente  dep-almoxar
                                                  situacao     pre-unit-for qt-acum-nec   qt-acum-rec
                                                  qt-solic     narrativa    nr-requisicao qt-acum-dev
                                                  nr-processo) where
                        rowid(ordem-compra) = r-rowid-first no-lock: end.                    
                    */
                end.
            end.
            else do:
                find next ordem-compra  where
                    ordem-compra.cod-comprado = pcCodComprado      AND
                    /* Filtro */
                    ordem-compra.numero-ordem >= piNumOrdemIni     AND
                    ordem-compra.numero-ordem <= piNumOrdemFim     AND
                    ordem-compra.cod-estabel  >= pcCodEstabelIni   AND
                    ordem-compra.cod-estabel  <= pcCodEstabelFim   AND
                    ordem-compra.data-emissao >= pdaDataEmissaoIni AND
                    ordem-compra.data-emissao <= pdaDataEmissaoFim AND
                    ordem-compra.it-codigo    >= pcItCodigoIni     AND
                    ordem-compra.it-codigo    <= pcItCodigoFim     AND
                    ordem-compra.nr-processo  >= piProcessoIni     AND
                    ordem-compra.nr-processo  <= piProcessoFim     AND
                    ordem-compra.requisitante >= pcRequisitanteIni AND
                    ordem-compra.requisitante <= pcRequisitanteFim AND
                    (ordem-compra.situacao = 5 or ordem-compra.situacao = 1) 
                    no-lock no-error.
                if not avail ordem-compra then
                    assign i-cont = i-nrlinhas + 1.
            end.
        end.
    end.
    /********************************************************
    ** A Logica abaixo foi implementada com a intencao de  **
    ** forcar sempre que ultimo registro do browser seja   **
    ** mostrado na proxima tela.                           **
    ********************************************************/
       
    if c-naveg <> "ant" then do:
        find last tt-ordem-compra use-index codigo no-lock no-error.
        /*************************************************************
        ** Caso a condicao abaixo for satisfeita, a variavel r-last **
        ** devera ser atualizada com '?' para que o botao de nave-  **
        ** gacao 'proximo' do filho nao apareca                     **
        *************************************************************/
        IF r-last = r-rowid-last THEN 
            ASSIGN r-last = ?.

        if r-last <> ? AND 
           avail tt-ordem-compra then do:
            find prev tt-ordem-compra use-index codigo no-lock.
            assign r-last = if avail tt-ordem-compra then
                                tt-ordem-compra.r-ordem
                            else 
                                ?.
        end.
        if r-ordem-compra = ? then
            assign r-first = ?.        

    end.
    else do:
        find first tt-ordem-compra use-index codigo no-lock no-error.
        if avail tt-ordem-compra and 
           tt-ordem-compra.r-ordem = r-rowid-first then
            assign r-first = ?.
    end.
    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraPedidosOrdens DBOProgram 
PROCEDURE geraPedidosOrdens :
/*------------------------------------------------------------------------------
  Purpose:   Gera ordens para a consulta de pendˆncias do 
             comprador do m¢dulo de compras.
  Parƒmetros:
------------------------------------------------------------------------------*/
    def input param pcCodComprado     as char no-undo.
    def input param piNumOrdemIni     as int  no-undo.
    def input param piNumOrdemFim     as int  no-undo. 
    def input param pcCodEstabelIni   as char no-undo.
    def input param pcCodEstabelFim   as char no-undo.
    def input param pdaDataEmissaoIni as date no-undo.
    def input param pdaDataEmissaoFim as date no-undo.
    def input param pcItCodigoIni     as char no-undo.
    def input param pcItCodigoFim     as char no-undo.
    def input param pcNomeAbrevIni    as char no-undo.
    def input param pcNomeAbrevFim    as char no-undo.    
    def input param pcFamiliaIni      as char no-undo.
    def input param pcFamiliaFim      as char no-undo. 
    def input param pcRequisitanteIni as char no-undo.
    def input param pcRequisitanteFim as char no-undo.
    def input param piProcessoIni     as int  no-undo.
    def input param piProcessoFim     as int  no-undo.

    def var i-cont         as integer no-undo format "99999".
    def var l-existe-ordem as logical no-undo.
    
    /* O pr‚-processador abaixa testa a versÆo do PROGRESS */
    &IF INT (SUBSTRING (PROVERSION, 1, INDEX (PROVERSION, ".") - 1)) >= 9 &THEN          
        EMPTY TEMP-TABLE tt-ordem-compra.
    &ELSE
        FOR EACH tt-ordem-compra:
            DELETE tt-ordem-compra.
        END.
    &ENDIF   
    
    assign i-cont         = 0.
    
    
    for each ordem-compra WHERE
             ordem-compra.cod-comprado = pcCodComprado      AND
             /* Filtro */
             ordem-compra.numero-ordem >= piNumOrdemIni     AND
             ordem-compra.numero-ordem <= piNumOrdemFim     AND
             ordem-compra.cod-estabel  >= pcCodEstabelIni   AND
             ordem-compra.cod-estabel  <= pcCodEstabelFim   AND
             ordem-compra.data-emissao >= pdaDataEmissaoIni AND
             ordem-compra.data-emissao <= pdaDataEmissaoFim AND
             ordem-compra.it-codigo    >= pcItCodigoIni     AND
             ordem-compra.it-codigo    <= pcItCodigoFim     AND
             ordem-compra.requisitante >= pcRequisitanteIni AND
             ordem-compra.requisitante <= pcRequisitanteFim AND
              /* Filtro */
            ordem-compra.situacao = 3 NO-LOCK,
       first emitente where
             emitente.cod-emitente  = ordem-compra.cod-emitente AND
             emitente.nome-abrev   >= pcNomeAbrevIni            AND
             emitente.nome-abrev   <= pcNomeAbrevFim         
             no-lock,
       first item where
             item.it-codigo  = ordem-compra.it-codigo           AND
             item.fm-codigo >= pcFamiliaIni                     AND
             item.fm-codigo <= pcFamiliaFim no-lock:

        assign i-cont = i-cont + 1.

        create tt-ordem-compra.
        assign tt-ordem-compra.numero-ordem  = ordem-compra.numero-ordem
               tt-ordem-compra.cod-estabel   = ordem-compra.cod-estabel
               tt-ordem-compra.cod-emitente  = ordem-compra.cod-emitente
               tt-ordem-compra.dep-almoxar   = ordem-compra.dep-almoxar
               tt-ordem-compra.data-emissao  = ordem-compra.data-emissao
               tt-ordem-compra.it-codigo     = ordem-compra.it-codigo
               tt-ordem-compra.situacao      = ordem-compra.situacao
               tt-ordem-compra.pre-unit-for  = ordem-compra.pre-unit-for
               tt-ordem-compra.qt-acum-dev   = ordem-compra.qt-acum-dev
               tt-ordem-compra.qt-acum-nec   = ordem-compra.qt-acum-nec
               tt-ordem-compra.qt-acum-rec   = ordem-compra.qt-acum-rec
               tt-ordem-compra.qt-solic      = ordem-compra.qt-solic
               tt-ordem-compra.narrativa     = ordem-compra.narrativa
               tt-ordem-compra.nr-requisicao = ordem-compra.nr-requisicao
               tt-ordem-compra.item-narrat   = item.narrativa
               tt-ordem-compra.r-ordem       = rowid(ordem-compra)
               tt-ordem-compra.r-rowid       = to-rowid("0x0" + string(i-cont,"99999")).

        if item.it-codigo = "" and item.tipo-contr = 4 then  /* debito direto */
            assign tt-ordem-compra.desc-item = substr(ordem-compra.narrativa,1,60).
        else
            assign tt-ordem-compra.desc-item = item.desc-item.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "narrativa":U THEN ASSIGN pFieldValue = RowObject.narrativa.
        WHEN "item-narrat":U THEN ASSIGN pFieldValue = RowObject.item-narrat.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "desc-item":U THEN ASSIGN pFieldValue = RowObject.desc-item.
        WHEN "dep-almoxar":U THEN ASSIGN pFieldValue = RowObject.dep-almoxar.
        &if defined(bf_mat_contratos) &then
        &endif
        WHEN "cod-comprado":U THEN ASSIGN pFieldValue = RowObject.cod-comprado.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-emissao":U THEN ASSIGN pFieldValue = RowObject.data-emissao.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "pre-unit-for":U THEN ASSIGN pFieldValue = RowObject.pre-unit-for.
        WHEN "qt-acum-dev":U  THEN ASSIGN pFieldValue = RowObject.qt-acum-dev.
        WHEN "qt-acum-nec":U  THEN ASSIGN pFieldValue = RowObject.qt-acum-nec.
        WHEN "qt-acum-rec":U  THEN ASSIGN pFieldValue = RowObject.qt-acum-rec.
        WHEN "qt-solic":U     THEN ASSIGN pFieldValue = RowObject.qt-solic.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "numero-ordem":U THEN ASSIGN pFieldValue = RowObject.numero-ordem.
        WHEN "nr-requisicao":U THEN ASSIGN pFieldValue = RowObject.nr-requisicao.
        WHEN "situacao":U THEN ASSIGN pFieldValue = RowObject.situacao.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        &if defined(bf_mat_contratos) &then
        &endif
        WHEN "nr-processo":U THEN ASSIGN pFieldValue = RowObject.nr-processo.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice COMPRADOR
  Parameters:
               retorna valor dos campos do ¡ndice COMPRADOR
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-comprado LIKE ordem-compra.cod-comprado NO-UNDO.
    DEFINE OUTPUT PARAMETER pnumero-ordem LIKE ordem-compra.numero-ordem NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pcod-comprado = RowObject.cod-comprado.
    ASSIGN pnumero-ordem = RowObject.numero-ordem.

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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

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




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRowidField DBOProgram 
PROCEDURE getRowidField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo ROWID
  Parameters:
               recebe nome do campo
               retorna valor do campo
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS ROWID NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "r-rowid":U THEN ASSIGN pFieldValue = RowObject.r-rowid.
        WHEN "r-ordem":U THEN ASSIGN pFieldValue = RowObject.r-ordem.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRowidFirstLastTT DBOProgram 
PROCEDURE getRowidFirstLastTT :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def output param pr-first        as rowid no-undo.
    def output param pr-last         as rowid no-undo.

    ASSIGN pr-first = r-first
           pr-last  = r-last.

    RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ¡ndice ORDEM
  Parameters:
               recebe valor dos campos do ¡ndice ORDEM
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnumero-ordem LIKE ordem-compra.numero-ordem NO-UNDO.

    FIND FIRST {&TableName} WHERE
        {&TableName}.numero-ordem = pnumero-ordem
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE {&TableName} THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID({&TableName})).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE InformaNavegRowid DBOProgram 
PROCEDURE InformaNavegRowid :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def INPUT PARAMETER pc-naveg   as char no-undo.
    def INPUT PARAMETER pc-solic   as CHAR no-undo.
    def INPUT PARAMETER pi-linhas  as INT  no-undo.

    assign c-naveg        = pc-naveg
           r-ordem-compra = to-rowid(pc-solic)
           i-nrlinhas     = pi-linhas.

    if pc-naveg = 'ant':u then
        assign r-first    = r-ordem-compra.

    
    return "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByNumeroOrdem DBOProgram 
PROCEDURE openQueryByNumeroOrdem :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK BY {&TableName}.numero-ordem.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
