&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
USING rep.imp.*.
/***************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
****************************************************************************/
{include/i-prgvrs.i BOIN366 2.00.00.122} /*** "010022" 23/10/2026 10:55:18 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin366 MUT}
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
&GLOBAL-DEFINE DBOName      BOIN366
&GLOBAL-DEFINE DBOVersion   1.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName    rat-docum
&GLOBAL-DEFINE TableLabel   
&GLOBAL-DEFINE QueryName qr{&TableName} 


/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin366.i RowObject}
{inbo/boin366.i1 tt-imposto}           /* Definiá∆o TT-IMPOSTO */
{inbo/boin366.i1 tt-imposto-aux}           /* Definiá∆o TT-IMPOSTO */
{inbo/boin01091.i tt-item-doc-est-tribut} /*temp-table item-doc-est-tribut*/
{inbo/boin01091.i tt-item-doc-est-tribut-aux} /*temp-table item-doc-est-tribut*/
{cdp/cdapi1001.i} /* tt-sit-tribut */
{dibo/bodi01141.i tt-relacto-tributo} /*temp-table do cdapi1005*/

/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName}  FOR {&TableName}.
def buffer b-item-doc-est     for item-doc-est.
def buffer b-item-doc-est-aux for item-doc-est.
DEF BUFFER b-rat-docum        FOR rat-docum.
DEF BUFFER bf-emitente        FOR emitente.

/* Definicao de Temp-Table para Calculo dos Impostos */
{dibo/bodi317im2bra.i1}
{include/i-epc200.i BOIN366} /* Definicao tt-EPC */

def var i-cod-emitente   like docum-est.cod-emitente no-undo.
def var c-serie-docto    like docum-est.serie-docto  no-undo.
def var c-nro-docto      like docum-est.nro-docto    no-undo.
def var c-nat-operacao   like docum-est.nat-operacao no-undo.
def var h-boin090        as handle                   no-undo.
def var h-boin176        as handle                   no-undo.
def var h-boin172        as handle                   no-undo.
def var h-cdapi024       as handle                   no-undo.
DEF VAR h-reapi433       AS HANDLE                   NO-UNDO.
DEF VAR h-boin01091      AS HANDLE                   NO-UNDO.
DEF VAR lDoacao          AS LOG                      NO-UNDO.
DEF VAR h-boin01017      AS HANDLE                   NO-UNDO.

/*Vari†veis Engine de Regras*/
DEFINE TEMP-TABLE tt-variavel NO-UNDO
    FIELD cod-var-oper LIKE config-var-operac-regra-cond.cod-variavel
    FIELD cod-val-var  LIKE config-var-operac-regra-cond.cod-val-var.


DEFINE TEMP-TABLE tt-retorno NO-UNDO
    FIELD valor-retorno LIKE config-var-operac-regra-ret.cod-val-ret
    FIELD campo-retorno LIKE config-var-operac-regra-ret.cod-campo-ret
    FIELD perc-rateio   LIKE config-var-operac-regra-ret.cdd-perc-rat.   

DEFINE VARIABLE i-empresa         LIKE estabelec.ep-codigo NO-UNDO.
DEFINE VARIABLE l-item-doc-rateio AS LOGICAL INITIAL NO    NO-UNDO.

/*Vari†veis Engine de Regras*/
DEFINE VARIABLE i-cod-regra-utilizada LIKE config-var-operac-regra.cdn-regra-operac NO-UNDO.
DEFINE VARIABLE h-cdapi034 AS HANDLE NO-UNDO.

DEFINE VARIABLE h-cdapi995    AS HANDLE NO-UNDO.

DEFINE VARIABLE de-pc-pis    AS DECIMAL FORMAT ">9.9999" NO-UNDO.
DEFINE VARIABLE de-pc-cofins AS DECIMAL FORMAT ">9.9999" NO-UNDO.

DEFINE VARIABLE l-nat-of AS LOGICAL INITIAL NO NO-UNDO. /*Possui Natureza Traduzida*/
{cdp/cdcfgmat.i} /* Include uso de pre-processadores */
{cdp/cdcfgdis.i} /* Include uso de pre-processadores */
{include/i_dbvers.i}

{cdp/cd9590.i} /*Unidade Neg¢cio*/
{cdp/cd9701.i} /* Multiplas naturezas */


define temp-table tt-item-doc-est-un no-undo like item-doc-est.

DEFINE TEMP-TABLE tt-ext-item-doc-est NO-UNDO LIKE ext-item-doc-est
    FIELD r-Rowid          AS ROWID.

IF NOT VALID-HANDLE(h-cdapi995) THEN
    RUN cdp/cdapi995.p PERSISTENT SET h-cdapi995.

DEF VAR l-NT2024002 AS LOGICAL NO-UNDO.

ASSIGN l-NT2024002 = CAN-FIND (FIRST funcao NO-LOCK
                               WHERE funcao.cd-funcao = "spp-NT2024002"
                                 AND funcao.ativo     = YES).    
    
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
         HEIGHT             = 15.08
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDeleteRecord DBOProgram 
PROCEDURE beforeDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /* ALTERA SITUACAO DA NOTA ENVOLVIDA NO RATEIO, PERMITINDO QUE A MESMA
       SEJA DESATUALIZADA                                                     */
    find docum-est
        where docum-est.cod-emitente = rowObject.nf-emitente
        and   docum-est.serie-docto  = rowObject.nf-serie
        and   docum-est.nro-docto    = rowObject.nf-nro
        and   docum-est.nat-operacao = rowObject.nf-nat-oper 
        exclusive-lock no-error.

    if  avail docum-est then DO: 
        assign docum-est.ind-rateio = no.

        FOR EACH b-rat-docum EXCLUSIVE-LOCK
           WHERE b-rat-docum.nf-serie    = docum-est.serie-docto  
             AND b-rat-docum.nf-nro      = docum-est.nro-docto    
             AND b-rat-docum.nf-emitente = docum-est.cod-emitente 
             AND b-rat-docum.nf-nat-oper = docum-est.nat-operacao:

            IF NOT (b-rat-docum.cod-emitente = rat-docum.cod-emitente 
                AND b-rat-docum.nat-operacao = rat-docum.nat-operacao 
                AND b-rat-docum.serie-docto  = rat-docum.serie-docto  
                AND b-rat-docum.nro-docto    = rat-docum.nro-docto) THEN 
                ASSIGN docum-est.ind-rateio = YES.
        END.            
    END.

    return "OK":u.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDestroy DBOProgram 
PROCEDURE beforeDestroy :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    if  valid-handle (h-boin172) then do:
        delete procedure h-boin172.
        ASSIGN h-boin172 = ?.
    end.

    if  valid-handle (h-boin090) then do:
        run beforeDestroy in h-boin090.
        delete procedure h-boin090.
        ASSIGN h-boin090 = ?.
    end.    

    IF VALID-HANDLE(h-cdapi995) THEN DO:
        delete procedure h-cdapi995.
        ASSIGN h-cdapi995 = ?.
    END.

    return "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDestroy1 DBOProgram 
PROCEDURE beforeDestroy1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    return "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculateImpostosRateio DBOProgram 
PROCEDURE calculateImpostosRateio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var de-tot-pis         as decimal                  no-undo.
    def var de-pis-nota        as decimal                  no-undo.
    def var de-tot-cofins      as decimal                  no-undo.
    def var de-cofins-nota     as decimal                  no-undo.
    DEF VAR de-despesa         AS DECIMAL                  NO-UNDO.

    DEF VAR h-re1902a          AS HANDLE                   NO-UNDO.
    DEF VAR h-reapi414         AS HANDLE                   NO-UNDO.
    DEF VAR p-origem-it        AS INT                      NO-UNDO.
    DEF VAR p-cod-cst          AS INT                      NO-UNDO.
    DEF VAR de-aliq-pis        AS DECIMAL FORMAT ">9.9999" NO-UNDO.
    DEF VAR de-aliq-cofins     AS DECIMAL FORMAT ">9.9999" NO-UNDO.
    DEF VAR l-sugereAliqCBSIBS AS LOGICAL  INITIAL NO      NO-UNDO.
    
    ASSIGN l-NT2024002 = CAN-FIND (FIRST funcao NO-LOCK
                                   WHERE funcao.cd-funcao = "spp-NT2024002"
                                     AND funcao.ativo     = YES).
        
    IF NOT VALID-HANDLE(h-re1902a) THEN
       RUN rep/re1902a.p PERSISTENT SET h-re1902a.
    
    IF NOT VALID-HANDLE(h-reapi414) THEN
      RUN rep/reapi414.p PERSISTENT SET h-reapi414.
    
    IF NOT VALID-HANDLE(h-reapi433) THEN
       RUN rep/reapi433.p PERSISTENT SET h-reapi433.               
		   
    IF NOT VALID-HANDLE(h-boin01091) THEN
       RUN inbo/boin01091.p PERSISTENT SET h-boin01091.	    

    IF VALID-HANDLE(h-boin176) THEN
       RUN setHandleItemDocumEst in h-re1902a (input h-boin176 ).
       
    for each item-doc-est
        fields ( cod-emitente serie-docto nro-docto nat-operacao sequencia
                 it-codigo quantidade preco-total[1] desconto[1] despesas[1]
                 pr-total-cmi aliquota-ipi aliquota-icm aliquota-iss cd-trib-ipi
                 cd-trib-icm cd-trib-iss log-2 base-ipi[1] ipi-ntrib[1] ipi-outras[1]
                 ipi-outras[2] valor-ipi[1] base-iss valor-iss iss-ntrib iss-outras 
                 cd-trib-ipi base-icm[1])
        where item-doc-est.cod-emitente = docum-est.cod-emitente
          and item-doc-est.serie-docto  = docum-est.serie-docto
          and item-doc-est.nro-docto    = docum-est.nro-docto
          and item-doc-est.nat-operacao = docum-est.nat-operacao exclusive-lock:

        run CalculatePisCofins.
        IF l-NT2024002 THEN
           RUN efetivaAliqIBSCbs.                         
    end.
    IF l-NT2024002 THEN DO:
       IF docum-est.cod-chave-aces-nf-eletro <> "" AND
          docum-est.cod-chave-aces-nf-eletro <> ? THEN DO:
          FOR FIRST docto-orig-cte NO-LOCK
              WHERE docto-orig-cte.cod-aces-comp-nfe = docum-est.cod-chave-aces-nf-eletro
                AND docto-orig-cte.idi-orig-trad = 2 :
             ASSIGN l-sugereAliqCBSIBS = YES.
          END.
       END.
       RUN setSugereAliqCBSIBS IN h-re1902a (INPUT l-sugereAliqCBSIBS). //Para nota de rateio n∆o dever† fazer a sugest∆o, porÇm se for CT-e e veio do monitor tem que sugeri 
    END.
    
    /*RE1902a criado para que os impostos de IPI, ISS e ICMS sejam calculados utilizando a bodi317im2bra*/
    RUN setRowidDocumEst IN h-re1902a (INPUT ROWID(docum-est)).
    RUN piCalculoPorDocumEst IN h-re1902a.

    
    for each item-doc-est
        where item-doc-est.cod-emitente = docum-est.cod-emitente
          and item-doc-est.serie-docto  = docum-est.serie-docto
          and item-doc-est.nro-docto    = docum-est.nro-docto
          and item-doc-est.nat-operacao = docum-est.nat-operacao exclusive-lock:

        FOR FIRST emitente NO-LOCK
            WHERE emitente.cod-emitente = item-doc-est.cod-emitente: END.

        /* Sugest∆o de CST */
        RUN setTipoNota             IN h-reapi414 (INPUT 1). /*1-Entrada, 2-Saida*/
        RUN setCodEstabel           IN h-reapi414 (INPUT docum-est.cod-estabel).
        RUN setCodNatOperacao       IN h-reapi414 (INPUT IF item-doc-est.nat-of <> "" THEN item-doc-est.nat-of ELSE item-doc-est.nat-operacao).
        RUN setNcm                  IN h-reapi414 (INPUT item-doc-est.class-fiscal).
        RUN setItCodigo             IN h-reapi414 (INPUT SUBSTRING(docum-est.char-1,176,16)).
        RUN setCodGrupEmit          IN h-reapi414 (INPUT emitente.cod-gr-forn). 
        RUN setCodEmitente          IN h-reapi414 (INPUT item-doc-est.cod-emitente).
        RUN setDtEmissao            IN h-reapi414 (INPUT docum-est.dt-emissao).
                                   
        RUN posicionarRegistros     IN h-reapi414 (INPUT ROWID(item-doc-est)).
        RUN emptyTtItemDocEstTribut IN h-reapi414.

        RUN calcCSTCD0303           IN h-reapi414.
        RUN calcCSTICMS             IN h-reapi414.
                                    
        RUN getCodOrigemItem        IN h-reapi414 (OUTPUT p-origem-it).
        RUN getCodSitTribICMS       IN h-reapi414 (OUTPUT p-cod-cst).
        RUN getAliqPISCOFINSItDoc   IN h-reapi414 (INPUT ROWID(item-doc-est), 
                                                   OUTPUT de-aliq-pis, 
                                                   OUTPUT de-aliq-cofins).   
        RUN calcCSTIPI              IN h-reapi414 (INPUT item-doc-est.cd-trib-ipi, 
                                                   INPUT item-doc-est.aliquota-ipi).
        RUN calcCSTPIS              IN h-reapi414 (INPUT item-doc-est.idi-tributac-pis, 
                                                   INPUT de-aliq-pis).
        RUN calcCSTCOFINS           IN h-reapi414 (INPUT item-doc-est.idi-tributac-cofins, 
                                                   INPUT de-aliq-cofins).
        
        RUN createttSTICMS           IN h-reapi414.
        RUN createttCSTIPI           IN h-reapi414.
        RUN createttCSTPIS           IN h-reapi414.
        RUN createttCSTCOFINS        IN h-reapi414.
        RUN saveItemDocEstTribut     IN h-reapi414.
        
        ASSIGN OVERLAY(item-doc-est.char-2,637,3) = STRING(p-origem-it)
               OVERLAY(item-doc-est.char-2,502,3) = STRING(p-origem-it, "9") + STRING(p-cod-cst, "99").
        /* ------------------------------- */
        IF l-NT2024002 THEN
            RUN sugereCClassTrib.                         
        
        IF  AVAIL emitente
        AND SUBSTRING(emitente.char-1,133,1) = "S":U /*Optante do Simples Nacional*/ THEN
            RUN CalculateSimplesNacional.
        
    end.
    
    IF VALID-HANDLE(h-reapi433) THEN DO:
        DELETE PROCEDURE h-reapi433.
        ASSIGN h-reapi433 = ?.
    END.                           

    IF VALID-HANDLE(h-boin01091) THEN DO:
        DELETE PROCEDURE h-boin01091.     
        ASSIGN h-boin01091 = ?.
    END.        

    run setHandleDocumEst in h-boin176 ( h-boin090 ).

    /* Atualiza a vari†vel l-totaliza indicando o que documento dever† ser totalizado */
    run getTotalizaNota in h-boin176 ( 0 ).

    /* Calculo do ICMS, ICMS Subst, ICMS Complementar e totaliza a NF */
    run TransferTotalItensNota in h-boin176 ( docum-est.cod-emitente,
                                              docum-est.serie-docto,
                                              docum-est.nro-docto,
                                              docum-est.nat-operacao ).

    FINALLY:
        IF VALID-HANDLE(h-re1902a) THEN DO:
            DELETE PROCEDURE h-re1902a.
            ASSIGN h-re1902a = ?.
        END.

        IF VALID-HANDLE(h-reapi414) THEN DO:
            DELETE PROCEDURE h-reapi414.
            ASSIGN h-reapi414 = ?.
        END.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CalculatePisCofins DBOProgram 
PROCEDURE CalculateSimplesNacional :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR de-aliq-icms-sn     AS DECIMAL NO-UNDO.
    DEF VAR de-base-icms-sn     AS DECIMAL NO-UNDO.
    DEF VAR de-vl-icms-sn       AS DECIMAL NO-UNDO.
    DEF VAR c-cod-CSOSN         AS CHAR    NO-UNDO.
    DEF VAR i-cod-orig          AS INT     NO-UNDO.
    DEF VAR h-cdapi1001         AS HANDLE  NO-UNDO. 
    DEF VAR rw-sit-relacto      AS ROWID   NO-UNDO.

    /*Se a nota foi importada atravÇs do RE0522 deve-se utilizar as informaá‰es vindas no XML*/    
    FOR FIRST item-doc-orig-nfe FIELDS( icmssn101-cod-sit-oper-sn icmssn101-aliq-calc-cred icmssn101-vl-cred icms-orig2 
                                        icmssn201-cod-sit-oper-sn icmssn201-aliq-calc-cre icmssn201-vl-cred-icms
                                        icmssn102-cod-sit-oper-sn icmssn202-cod-sit-oper-sn icmssn500-cod-sit-oper-sn
                                        icmssn900-cod-sit-oper-sn icmssn900-aliq-aplic-cc-sn icmssn900-vl-cred-icms ) NO-LOCK
        WHERE item-doc-orig-nfe.ch-acesso-comp-nfe = docum-est.cod-chave-aces-nf-eletro
          AND item-doc-orig-nfe.idi-orig-trad      = 2
          AND item-doc-orig-nfe.seq-item           = INT(SUBSTRING(item-doc-est.char-2,832,5)):

        IF item-doc-orig-nfe.icmssn101-cod-sit-oper-sn <> "" THEN
            ASSIGN c-cod-CSOSN     = item-doc-orig-nfe.icms-orig2[3] + item-doc-orig-nfe.icmssn101-cod-sit-oper-sn
                  de-aliq-icms-sn  = IF item-doc-orig-nfe.icmssn101-aliq-calc-cred <> ? THEN item-doc-orig-nfe.icmssn101-aliq-calc-cred ELSE 0
                  de-vl-icms-sn    = IF item-doc-orig-nfe.icmssn101-vl-cred        <> ? THEN item-doc-orig-nfe.icmssn101-vl-cred        ELSE 0.
                  
        ELSE IF item-doc-orig-nfe.icmssn102-cod-sit-oper-sn <> "" THEN
            ASSIGN c-cod-CSOSN     = item-doc-orig-nfe.icms-orig2[4] + item-doc-orig-nfe.icmssn102-cod-sit-oper-sn.
            
        ELSE IF item-doc-orig-nfe.icmssn201-cod-sit-oper-sn <> "" THEN
            ASSIGN c-cod-CSOSN     = item-doc-orig-nfe.icms-orig2[5] + item-doc-orig-nfe.icmssn201-cod-sit-oper-sn
                  de-aliq-icms-sn = IF item-doc-orig-nfe.icmssn201-aliq-calc-cre <> ? THEN item-doc-orig-nfe.icmssn201-aliq-calc-cre ELSE 0
                  de-vl-icms-sn   = IF item-doc-orig-nfe.icmssn201-vl-cred-icms  <> ? THEN item-doc-orig-nfe.icmssn201-vl-cred-icms  ELSE 0.
                  
        ELSE IF  item-doc-orig-nfe.icmssn202-cod-sit-oper-sn <> "" THEN
            ASSIGN c-cod-CSOSN     = item-doc-orig-nfe.icms-orig2[6] + item-doc-orig-nfe.icmssn202-cod-sit-oper-sn.
            
        ELSE IF item-doc-orig-nfe.icmssn500-cod-sit-oper-sn <> "" THEN
            ASSIGN c-cod-CSOSN     = item-doc-orig-nfe.icms-orig2[7] + item-doc-orig-nfe.icmssn500-cod-sit-oper-sn.
            
        ELSE IF item-doc-orig-nfe.icmssn900-cod-sit-oper-sn <> "" THEN
            ASSIGN c-cod-CSOSN     = item-doc-orig-nfe.icms-orig2[8] + item-doc-orig-nfe.icmssn900-cod-sit-oper-sn
                   de-aliq-icms-sn = IF item-doc-orig-nfe.icmssn900-aliq-aplic-cc-sn <> ? THEN item-doc-orig-nfe.icmssn900-aliq-aplic-cc-sn ELSE 0
                   de-vl-icms-sn   = IF item-doc-orig-nfe.icmssn900-vl-cred-icms     <> ? THEN item-doc-orig-nfe.icmssn900-vl-cred-icms     ELSE 0.
                  
        IF de-aliq-icms-sn <> 0 AND de-vl-icms-sn <> 0 THEN
            ASSIGN de-base-icms-sn = de-vl-icms-sn * 100 / de-aliq-icms-sn.
            
    END.
      
    RUN findEmitente ( item-doc-est.cod-emitente,
                       ?).
    RUN findEstabelec ( docum-est.cod-estabel).

    /*Se encontrar registro no CD0303 deve sobrepor o que veio do XML*/
    RUN findItem ( item-doc-est.it-codigo ).
      
    RUN findItemUniEstab( docum-est.cod-estabel,
                          item-doc-est.it-codigo).  
                        
    run findNaturOper ( item-doc-est.nat-operacao ).                          
      
    ASSIGN i-cod-orig = ITEM.codigo-orig.
    IF AVAILABLE item-uni-estab AND
       TRIM(SUBSTRING(item-uni-estab.char-2,18,3)) <> "":U THEN
        ASSIGN i-cod-orig = INT(TRIM(SUBSTRING(item-uni-estab.char-2,18,3))).

    EMPTY TEMP-TABLE tt-sit-tribut.
    EMPTY TEMP-TABLE tt-retorna-rowid.  
    ASSIGN rw-sit-relacto = ?.   

    IF NOT VALID-HANDLE(h-cdapi1001) THEN
        RUN cdp/cdapi1001.p PERSISTENT SET h-cdapi1001.

    RUN pi-seta-tributos IN h-cdapi1001 (input "4"). 

    RUN pi-retorna-sit-tribut IN h-cdapi1001 (INPUT  1, /*entrada*/
                                              INPUT  docum-est.cod-estabel,
                                              INPUT  item-doc-est.nat-of,
                                              INPUT  item-doc-est.class-fiscal,
                                              INPUT  item-doc-est.it-codigo,
                                              INPUT  emitente.cod-gr-cli,
                                              INPUT  item-doc-est.cod-emitente,
                                              INPUT  docum-est.dt-emissao,
                                              OUTPUT TABLE tt-sit-tribut).
                                            
    RUN pi-retorna-rowid in h-cdapi1001 (OUTPUT TABLE tt-retorna-rowid).

    FOR FIRST tt-retorna-rowid NO-LOCK
        WHERE tt-retorna-rowid.cdn-tribut = 4:
        ASSIGN rw-sit-relacto = tt-retorna-rowid.rw-sit-tribut-relacto.
    END.                                                              
     
    if c-cod-CSOSN = "" then
        ASSIGN c-cod-CSOSN = STRING(i-cod-orig) + "900". /* CSOSN Outras */
    FOR EACH tt-sit-tribut NO-LOCK
       WHERE tt-sit-tribut.cdn-tribut = 4:
     
        IF tt-sit-tribut.cdn-sit-tribut <> 0 THEN DO:
            ASSIGN c-cod-CSOSN = STRING(i-cod-orig) + STRING(tt-sit-tribut.cdn-sit-tribut,"999"). /** CSOSN **/
            
            FOR FIRST sit-tribut-relacto NO-LOCK
                WHERE ROWID(sit-tribut-relacto) = rw-sit-relacto:
                
                ASSIGN de-aliq-icms-sn = sit-tribut-relacto.val-livre-1.
            END. 
        END.    
    END.

    ASSIGN de-base-icms-sn = ROUND((item-doc-est.base-icm[1] + item-doc-est.icm-outras[1] + item-doc-est.icm-ntrib[1]),2). /*Vl Base ICMS SN*/

    if rw-sit-relacto <> ? then 
        ASSIGN de-vl-icms-sn = ROUND(de-base-icms-sn * (de-aliq-icms-sn / 100),2). /*Vl Cred ICMS SN*/

    if natur-oper.tipo-compra = 9 then 
        ASSIGN c-cod-CSOSN     = STRING(i-cod-orig) + "400" /* CSOSN Isená∆o 400 e aliquota zerada Tipo compra nota crÇdito/dÇbito*/
               de-aliq-icms-sn = 0.
               
    EMPTY TEMP-TABLE tt-ext-item-doc-est.

    CREATE tt-ext-item-doc-est.
    ASSIGN tt-ext-item-doc-est.serie-docto  = item-doc-est.serie-docto
           tt-ext-item-doc-est.nro-docto    = item-doc-est.nro-docto
           tt-ext-item-doc-est.cod-emitente = item-doc-est.cod-emitente
           tt-ext-item-doc-est.nat-operacao = item-doc-est.nat-operacao
           tt-ext-item-doc-est.sequencia    = item-doc-est.sequencia
           tt-ext-item-doc-est.cod-param    = "simplesnacional".
    
    ASSIGN tt-ext-item-doc-est.val-livre-1               = de-aliq-icms-sn  /*aliq simples nac*/
           tt-ext-item-doc-est.val-livre-2               = de-base-icms-sn  /*base simples nac*/
           tt-ext-item-doc-est.val-livre-3               = de-vl-icms-sn    /*valor simples nac*/
           OVERLAY(tt-ext-item-doc-est.cod-livre-1,1,10) = c-cod-CSOSN.     /*CSOSN*/
     
    IF  NOT VALID-HANDLE(h-boin01017) THEN
        RUN inbo/boin01017.p PERSISTENT SET h-boin01017.
    
    RUN openQueryStatic IN h-boin01017 (INPUT "Main":U) NO-ERROR.

    RUN goToKey IN h-boin01017 (INPUT item-doc-est.serie-docto, 
                                INPUT item-doc-est.nro-docto,   
                                INPUT item-doc-est.cod-emitente,
                                INPUT item-doc-est.nat-operacao,
                                INPUT item-doc-est.sequencia,   
                                INPUT "simplesnacional"). 
                            
    IF  RETURN-VALUE = "OK":U THEN DO:
        RUN emptyRowErrors IN h-boin01017.
        RUN setRecord      IN h-boin01017 (INPUT TABLE tt-ext-item-doc-est).
        RUN updateRecord   IN h-boin01017.  
    END.    
    ELSE DO:
        RUN emptyRowErrors IN h-boin01017.
        RUN setRecord      IN h-boin01017 (INPUT TABLE tt-ext-item-doc-est).
        RUN createRecord   IN h-boin01017.
    END.
    
    RETURN 'OK':u.
           
    FINALLY:
        IF VALID-HANDLE(h-boin01017) THEN DO:
          DELETE PROCEDURE h-boin01017.
          ASSIGN h-boin01017 = ?.
        END.

        IF VALID-HANDLE(h-cdapi1001) THEN DO:
         DELETE PROCEDURE h-cdapi1001.
         ASSIGN h-cdapi1001 = ?.
        END.
        
    END FINALLY.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CalculatePisCofins DBOProgram 
PROCEDURE CalculatePisCofins :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/ 
    def var de-base-pis-cofins like item-doc-est.vl-ipi[1]   no-undo.    
    def var de-valor-pis       like item-doc-est.base-ipi[1] no-undo.
    def var de-valor-cofins    like item-doc-est.base-ipi[1] no-undo.    
    
    /* 
       tt-imposto-aux È criada pela procedure setTTImposto, chamada pela tela re1904 para manter 
       gravado os impostos parametrizados em tela.
       Quando a temp-table nao existir È porque tem origem em rotinas de integracao, portanto deve-se buscar
       os impostos relacionados a item-doc-est.nat-of.
       Implementacao para multiplas naturezas, se nao estiver ativo grava a natureza pai no campo item-doc-est.nat-of
    */
    IF CAN-FIND(FIRST tt-imposto-aux) 
    AND item-doc-est.nat-of = item-doc-est.nat-operacao THEN DO:
        EMPTY TEMP-TABLE tt-imposto NO-ERROR.
        BUFFER-COPY tt-imposto-aux TO tt-imposto.
    END.
    ELSE DO:
        RUN findNaturOper  (item-doc-est.nat-of).
        RUN getTTImposto (output table tt-imposto).
    END. 
        
    {rep/re1001.i12 item-doc-est.nat-of}   
    
    find first tt-imposto no-lock no-error.
 
    if  item-doc-est.cd-trib-ipi = 3 and
        l-inclui-ipi-outros then
        assign de-base-pis-cofins = item-doc-est.preco-total[1]
                                    + item-doc-est.valor-ipi[1]
                                    + item-doc-est.despesas[1]
                                    - item-doc-est.desconto[1]
                                    - dec(substr(item-doc-est.char-2,819,13)).
    else
        assign de-base-pis-cofins = item-doc-est.preco-total[1]
                                    + item-doc-est.despesas[1]
                                    - item-doc-est.desconto[1]
                                    - dec(substr(item-doc-est.char-2,819,13)).
    
    
    if  tt-imposto.cd-trib-pis = 1        /* Tributado */
    OR  tt-imposto.cd-trib-pis = 3 then   /* Outros */
        assign de-valor-pis =  round((de-base-pis-cofins * tt-imposto.aliquota-pis / 100),2).
    else
        assign de-valor-pis = 0.

    if  tt-imposto.cd-trib-cofins = 1         /* Tributado */
    OR  tt-imposto.cd-trib-cofins = 3  then   /* Outros */
        assign de-valor-cofins =  round((de-base-pis-cofins * tt-imposto.aliquota-cofins / 100),2).
    else
        assign de-valor-cofins = 0.

    &IF '{&bf_dis_versao_ems}' >= '2.06' &THEN
        assign item-doc-est.idi-tributac-pis     = tt-imposto.cd-trib-pis    
               item-doc-est.val-aliq-pis         = tt-imposto.aliquota-pis 
               item-doc-est.base-pis             = de-base-pis-cofins 
               item-doc-est.valor-pis            = de-valor-pis 
               item-doc-est.idi-tributac-cofins  = tt-imposto.cd-trib-cofins    
               item-doc-est.val-aliq-cofins      = tt-imposto.aliquota-cofins 
               item-doc-est.val-base-calc-cofins = de-base-pis-cofins 
               item-doc-est.val-cofins           = de-valor-cofins.
    &else
        assign OVERLAY(item-doc-est.char-2,21,1)   = string(int(tt-imposto.cd-trib-pis))    
               OVERLAY(item-doc-est.char-2,22,5)   = string(dec(tt-imposto.aliquota-pis),">9.99")
               OVERLAY(item-doc-est.char-2,27,14)  = string(dec(de-base-pis-cofins),">>>>>>>>>>.99")
               OVERLAY(item-doc-est.char-2,41,14)  = string(dec(de-valor-pis),">>>>>>>>>>.99" )
               OVERLAY(item-doc-est.char-2,83,1)   = string(int(tt-imposto.cd-trib-cofins))    
               OVERLAY(item-doc-est.char-2,84,5)   = string(dec(tt-imposto.aliquota-cofins),">9.99")
               OVERLAY(item-doc-est.char-2,89,14)  = string(dec(de-base-pis-cofins),">>>>>>>>>>.99")
               OVERLAY(item-doc-est.char-2,103,14) = string(dec(de-valor-cofins),">>>>>>>>>>.99" ).
    &endif
    
    RUN grava-aliquotas IN h-cdapi995 (INPUT "item-doc-est",
                                      INPUT item-doc-est.serie-docto + "/" + 
                                            item-doc-est.nro-docto + "/" + 
                                            string(item-doc-est.cod-emitente) + "/" + 
                                            item-doc-est.nat-operacao + "/" + 
                                            string(item-doc-est.sequencia), 
                                      INPUT tt-imposto.aliquota-pis,
                                      INPUT tt-imposto.aliquota-cofins).
                                
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createRateio DBOProgram 
PROCEDURE createRateio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def buffer b-docum-est      for docum-est.
    def buffer b-unid-neg-nota  for unid-neg-nota.
    
    def var de-tot-nota-val       as decimal                     no-undo.
    def var de-tot-nota-peso      as decimal                     no-undo.
    def var de-tot-valor          as decimal                     no-undo.
    def var de-tot-desc           as decimal                     no-undo.
    def var de-tot-desp           as decimal                     no-undo.
    def var de-tot-pedag          as decimal                     no-undo.
    def var de-tot-pis            as decimal                     no-undo.
    def var de-pis-nota           as decimal                     no-undo.
    def var de-tot-cofins         as decimal                     no-undo.
    def var de-cofins-nota        as decimal                     no-undo.
    def var i-sequencia           as integer                     no-undo.
    def var de-maior              as decimal                     no-undo.
    def var rw-maior              as rowid                       no-undo.
    def var c-cod-unid-negoc-aux  as character                   no-undo.
    def var de-tot-valor-un       as decimal                     no-undo.
    def var de-tot-desc-un        as decimal                     no-undo.
    def var de-tot-desp-un        as decimal                     no-undo.
    def var de-tot-pedag-un       as decimal                     no-undo.
    def var de-tot-valor-item-un  as decimal                     no-undo.
    def var de-tot-desc-item-un   as decimal                     no-undo.
    def var de-tot-desp-item-un   as decimal                     no-undo.
    def var de-tot-pedag-item-un  as decimal                     no-undo.
    def var de-maior-un           as decimal                     no-undo.
    def var rw-maior-un           as rowid                       no-undo.
    def var i-cd-trib-iss         as integer initial 1           no-undo.
    DEF VAR l-contagem-dif        AS LOGICAL                     NO-UNDO.
    DEF VAR de-tot-peso-un        AS DECIMAL                     NO-UNDO.
    DEF VAR de-tot-peso-item-un   AS DECIMAL                     NO-UNDO.
    DEF VAR de-tot-peso           AS DECIMAL                     NO-UNDO.
    
    DEFINE VARIABLE c-nat-of        AS CHARACTER                 NO-UNDO.
    DEFINE VARIABLE c-nat-nf-origem AS CHARACTER                 NO-UNDO.

    DEFINE VARIABLE c-cfop-nota-saida AS CHARACTER FORMAT "X(5)" NO-UNDO.

    run findDocumEst ( i-cod-emitente,
                       c-serie-docto,
                       c-nro-docto,
                       c-nat-operacao ).

    if  not avail docum-est
    or  not avail tt-imposto then 
        RETURN "NOK".

    FIND FIRST param-global NO-LOCK NO-ERROR.

    FOR FIRST param-estoq FIELDS(char-1) NO-LOCK:
        ASSIGN l-contagem-dif = (docum-est.rec-fisico AND
                                 SUBSTRING(param-estoq.char-1,23,1) = "1"). /* Contabiliza Diferenca Contagem */
    END.
        
    FIND FIRST estabelec NO-LOCK
         WHERE estabelec.cod-estabel = docum-est.cod-estabel NO-ERROR.
    
    IF AVAIL estabelec THEN
        ASSIGN i-empresa = estabelec.ep-codigo.
    
    /* Tributacao PIS/COFINS - Reduzido */
    if  tt-imposto.cd-trib-pis    = 4           
    or  tt-imposto.cd-trib-cofins = 4 then do:  

        /* Tributacao invalida p/ Despesa Acessoria/Nota Rateio */
        {method/svc/errors/inserr.i
                            &ErrorNumber="29975" 
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" }        
        return "NOK":U.                    
    end.

    /*--- TOTALIZA DOCUMENTOS ---*/
    assign de-tot-nota-val  = 0
           de-tot-nota-peso = 0.
    for each rat-docum {cdp/cd8900.i rat-docum docum-est} no-lock:
 
        for first b-docum-est
             fields ( cod-emitente nro-docto serie-docto
                      nat-operacao ind-rateio valor-mercad )
             where b-docum-est.serie-docto  = rat-docum.nf-serie
             and   b-docum-est.nro-docto    = rat-docum.nf-nro
             and   b-docum-est.cod-emitente = rat-docum.nf-emitente
             and   b-docum-est.nat-operacao = rat-docum.nf-nat-oper 
             exclusive-lock.
        end.     
 
        if  avail b-docum-est then
            assign b-docum-est.ind-rateio  = yes
                   de-tot-nota-val  = de-tot-nota-val + b-docum-est.valor-mercad
                   de-tot-nota-peso = de-tot-nota-peso + b-docum-est.tot-peso.
    end.
    
    /*--- EXECUTA BO ITEM-DOC-EST ---*/
    run openQueryStatic in h-boin176 (input "Main":U) no-error.

    /*--- EXECUTA BO ITEM ---*/
    IF  NOT VALID-HANDLE(h-boin172) THEN 
        RUN inbo/boin172.p PERSISTENT SET h-boin172. 

    /*--- EXECUTA API UNIDADE NEG‡CIO ---*/
    if not valid-handle(h-cdapi024) then
        run cdp/cdapi024.p persistent set h-cdapi024.

   
    /*--- EXECUTA ENGINE DE REGRAS ---*/ 
    IF NOT VALID-HANDLE(h-cdapi034) THEN
        RUN cdp/cdapi034.p PERSISTENT SET h-cdapi034 (INPUT i-empresa,
                                                      INPUT docum-est.cod-estabel,
                                                      INPUT "todos":U,
                                                      INPUT TABLE tt-variavel,
                                                      OUTPUT i-cod-regra-utilizada,
                                                      OUTPUT TABLE tt-retorno,
                                                      OUTPUT TABLE RowErrors).        

    
    run findDocumento in h-boin176 ( docum-est.cod-emitente,
                                     docum-est.serie-docto,
                                     docum-est.nro-docto,
                                     docum-est.nat-operacao ).
                                     
    /*--- Elimina Itens na Modificaá∆o ----*/
    run deleteItemDocEst. 
    
    run getSeqItem  in h-boin176 ( output i-sequencia ).
    
    /*--- LEITURA USUµRIO DO RECEBIMENTO ( PARAM-RE ) ---*/
    run findParamRe ( docum-est.usuario ).
    
    /*--- ZERA VARIµVEIS DE SOMAT‡RIA ---*/
    assign de-tot-valor    = 0
           de-tot-peso     = 0
           de-tot-desc     = 0
           de-tot-desp     = 0
           de-tot-pedag    = 0 
           de-maior        = 0
           de-tot-pis      = 0
           de-tot-cofins   = 0
           rw-maior        = ?.

    /* Calculo PIS por Nota */
    if  tt-imposto.cd-trib-pis = 1        /* Tributado */
    OR  tt-imposto.cd-trib-pis = 3 then   /* Outros */
        assign de-pis-nota =  round((( docum-est.valor-mercad + docum-est.despesa-nota - docum-est.tot-desconto )  
                                       * tt-imposto.aliquota-pis / 100),2).
    else
        assign de-pis-nota = 0.

    /* Calculo COFINS por Nota */
    if  tt-imposto.cd-trib-cofins = 1        /* Tributado */ 
    OR  tt-imposto.cd-trib-cofins = 3 then   /* Outros */
        assign de-cofins-nota =  round((( docum-est.valor-mercad + docum-est.despesa-nota - docum-est.tot-desconto )  
                                       * tt-imposto.aliquota-cofins / 100),2).
    else
        assign de-cofins-nota = 0.

    /*--- INICIA RATEIO DE ACORDO COM AS NOTAS INFORMADAS ---*/
    for each rat-docum {cdp/cd8900.i rat-docum docum-est} no-lock:
 
        for first b-docum-est             
             where b-docum-est.serie-docto  = rat-docum.nf-serie
             and   b-docum-est.nro-docto    = rat-docum.nf-nro
             and   b-docum-est.cod-emitente = rat-docum.nf-emitente
             and   b-docum-est.nat-operacao = rat-docum.nf-nat-oper no-lock:
        end.

        /* Geracao dos Itens */
        for each item-doc-est 
            where item-doc-est.cod-emitente = b-docum-est.cod-emitente
              and item-doc-est.serie-docto  = b-docum-est.serie-docto
              and item-doc-est.nro-docto    = b-docum-est.nro-docto
              and item-doc-est.nat-operacao = b-docum-est.nat-operacao no-lock:
            
            run findItem ( item-doc-est.it-codigo ). 
            
            IF  param-re.rateio-nfrateio    = 1 /*Peso*/
            AND item-doc-est.peso-liquido   = 0 THEN DO:
                
                DEFINE VARIABLE c-msg-sem-peso AS CHARACTER NO-UNDO.
                ASSIGN c-msg-sem-peso = STRING(item-doc-est.sequencia) + '~~':U +
                                        STRING(item-doc-est.nro-docto) + '~~':U +
                                        STRING(item-doc-est.serie-docto) + '~~':U +
                                        STRING(item-doc-est.cod-emitente)  + '~~':U +
                                        STRING(item-doc-est.nat-operacao)  + '~~':U +
                                        STRING(item-doc-est.it-codigo).
                {method/svc/errors/inserr.i
                            &ErrorNumber="57561" 
                            &ErrorType="EMS"
                            &ErrorSubType="WARNING"
                            &ErrorParameters="c-msg-sem-peso"}
                                    
                NEXT.
            END.
                        
            ASSIGN c-nat-of        = docum-est.nat-operacao /* natureza principal do documento de rateio */
                   c-nat-nf-origem = item-doc-est.nat-operacao /* natureza principal*/. 
           
           IF item-doc-est.nat-of <> "" AND item-doc-est.nat-of <> ? THEN
               ASSIGN c-nat-nf-origem = item-doc-est.nat-of.

           /*Se algum dos itens possui natureza fiscal diferente da natureza principal, do documento que esta vinculado ao rateio.*/
           IF item-doc-est.nat-operacao <> item-doc-est.nat-of THEN
               ASSIGN l-nat-of = YES. 
               
           RUN findNaturOper  (c-nat-nf-origem).
           
           RUN pi-engine-regras IN THIS-PROCEDURE( INPUT i-empresa,
                                                   INPUT item-doc-est.it-codigo,
                                                   INPUT c-nat-nf-origem,
                                                   INPUT b-docum-est.cod-estabel,
                                                   INPUT docum-est.cod-emitente, /* transportador */
                                                   INPUT b-docum-est.cod-emitente, /* fornecedor */
                                                   INPUT item-doc-est.ct-codigo,
                                                   INPUT item-doc-est.sc-codigo,
                                                   INPUT IF AVAIL natur-oper THEN natur-oper.cod-cfop ELSE "",
                                                   OUTPUT TABLE tt-retorno ).

           IF CAN-FIND(FIRST tt-retorno
                       WHERE tt-retorno.campo-retorno = "apropria-despesa-item":U
                         AND (tt-retorno.valor-retorno  = "NAO":U OR
                              tt-retorno.valor-retorno  = "NO":U)) THEN 
                         NEXT.
           
            IF l-mult-natur-receb THEN DO:
                FOR EACH tt-retorno
                   WHERE tt-retorno.campo-retorno = "nat-of" 
                      OR tt-retorno.campo-retorno = "cod-cfop":
                    ASSIGN c-nat-of = tt-retorno.valor-retorno.
                END.
               
                /* 
                   tt-imposto-aux È criada pela procedure setTTImposto, chamada pela tela re1904 para manter 
                   gravado os impostos parametrizados em tela.
                   Quando a temp-table nao existir È porque tem origem em rotinas de integracao, portanto deve-se buscar
                   os impostos relacionados a item-doc-est.nat-of.                  
                */
                IF c-nat-of = docum-est.nat-operacao AND CAN-FIND(FIRST tt-imposto-aux) THEN DO:
                     RUN findNaturOper  (c-nat-of).  
                     EMPTY TEMP-TABLE tt-imposto NO-ERROR.
                     BUFFER-COPY tt-imposto-aux TO tt-imposto.
                END.
                ELSE DO:
                    /* Acessa natureza de operacao traduzida*/
                    RUN findNaturOper  (c-nat-of).                 
                    /* Cria tt-imposto com base na natureza traduzida */
                    RUN getTTImposto  (OUTPUT TABLE tt-imposto).
                END.
                
                IF AVAIL natur-oper THEN DO:
                    IF NOT natur-oper.nota-rateio THEN DO:
                        /*Natureza de operaÁ„o traduzida inv·lida! .A natureza de operaÁ„o &1 deve estar parametrizada como nota rateio.*/
                        {method/svc/errors/inserr.i
                                            &ErrorNumber="54974" 
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR" 
                                            &ErrorParameters="c-nat-of"}
                        RETURN "NOK":U.   
                    END.
                END.
                
            END. 
            
            FIND FIRST tt-imposto EXCLUSIVE-LOCK NO-ERROR.    
            
                if avail item then
                    assign i-cd-trib-iss = if  natur-oper.cd-trib-iss = 1
                                           then if  item.cd-trib-iss = 1
                                                or  item.cd-trib-iss = 4
                                                then 1
                                                else item.cd-trib-iss
                                           else if  natur-oper.cd-trib-iss = 2
                                                or  natur-oper.cd-trib-iss = 3
                                                then natur-oper.cd-trib-iss
                                                else item.cd-trib-iss.
            
            
            /*********************************************************************************/
            /*   Se o cliente n∆o utiliza UN (l-mat-unid-negoc = no) ou se a unidade de      */
            /*   neg¢cio j† veio informada, criar† um item de rateio para cada item da       */
            /*   nota original.  l-mat-unid-negoc => parÉmetros de materiais                 */
            /*********************************************************************************/
            if not l-mat-unid-negoc 
            or item-doc-est.cod-unid-negoc <> "" 
            OR (NOT CAN-FIND(FIRST rat-lote {cdp/cd8900.i rat-lote item-doc-est}
                               AND rat-lote.sequencia = item-doc-est.sequencia) AND
                NOT CAN-FIND(FIRST unid-neg-nota 
                             WHERE unid-neg-nota.cod-emitente = item-doc-est.cod-emitente
                               AND unid-neg-nota.serie-docto  = item-doc-est.serie-docto
                               AND unid-neg-nota.nro-docto    = item-doc-est.nro-docto
                               AND unid-neg-nota.nat-operacao = item-doc-est.nat-operacao
                               AND unid-neg-nota.sequencia    = item-doc-est.sequencia)) then do:
                
                create b-item-doc-est.
                assign b-item-doc-est.sequencia      = i-sequencia
                       b-item-doc-est.nro-docto      = docum-est.nro-docto 
                       b-item-doc-est.serie-docto    = docum-est.serie-docto
                       b-item-doc-est.cod-emitente   = docum-est.cod-emitente
                       b-item-doc-est.nat-operacao   = docum-est.nat-operacao
                       b-item-doc-est.it-codigo      = item-doc-est.it-codigo
                       b-item-doc-est.cod-refer      = item-doc-est.cod-refer
                       b-item-doc-est.class-fiscal   = item-doc-est.class-fiscal
                       b-item-doc-est.un             = item-doc-est.un
                       overlay(b-item-doc-est.char-2,956,20) = IF substring(item-doc-est.char-2,956,20) <> ? THEN substring(item-doc-est.char-2,956,20) ELSE ''.
                IF param-re.rateio-nfrateio = 1 THEN DO:    /* Peso */
                    ASSIGN b-item-doc-est.preco-total[1]            = ROUND( item-doc-est.peso-liquido * docum-est.valor-mercad / de-tot-nota-peso, 2)
                           b-item-doc-est.preco-unit[1]             = b-item-doc-est.preco-total[1]
                           b-item-doc-est.desconto[1]               = ROUND( item-doc-est.peso-liquido * docum-est.tot-desconto / de-tot-nota-peso, 2)
                           b-item-doc-est.despesas[1]               = ROUND( item-doc-est.peso-liquido * docum-est.despesa-nota / de-tot-nota-peso, 2)
                           OVERLAY(b-item-doc-est.char-2,819,13)    = STRING(ROUND( item-doc-est.peso-liquido * DEC(SUBSTR(docum-est.char-2,153,13)) / de-tot-nota-peso, 2)).
                END.
                ELSE DO:                                    /* Valor */
                    ASSIGN b-item-doc-est.preco-total[1]            = ROUND( item-doc-est.preco-total[1] * docum-est.valor-mercad / de-tot-nota-val, 2)
                           b-item-doc-est.preco-unit[1]             = b-item-doc-est.preco-total[1]
                           b-item-doc-est.desconto[1]               = ROUND( item-doc-est.preco-total[1] * docum-est.tot-desconto / de-tot-nota-val, 2)
                           b-item-doc-est.despesas[1]               = ROUND( item-doc-est.preco-total[1] * docum-est.despesa-nota / de-tot-nota-val, 2)
                           OVERLAY(b-item-doc-est.char-2,819,13)    = STRING(ROUND( item-doc-est.preco-total[1] * DEC(SUBSTR(docum-est.char-2,153,13)) / de-tot-nota-val, 2)).
                END.
                ASSIGN b-item-doc-est.cd-trib-icm    = tt-imposto.cd-trib-icm
                       b-item-doc-est.aliquota-icm   = tt-imposto.aliquota-icm
                       b-item-doc-est.cd-trib-ipi    = tt-imposto.cd-trib-ipi
                       b-item-doc-est.aliquota-ipi   = tt-imposto.aliquota-ipi
                       b-item-doc-est.val-perc-rep-ipi  = tt-imposto.perc-red-ipi
                       b-item-doc-est.val-perc-red-icms = tt-imposto.perc-red-icm
                       b-item-doc-est.cd-trib-iss    = /*item-doc-est.cd-trib-iss*/ i-cd-trib-iss
                       b-item-doc-est.seq-comp       = item-doc-est.sequencia
                       b-item-doc-est.narrativa      = item-doc-est.narrativa
                       b-item-doc-est.nro-comp       = b-docum-est.nro-docto
                       b-item-doc-est.nat-comp       = b-docum-est.nat-operacao
                       b-item-doc-est.serie-comp     = b-docum-est.serie-docto
                       b-item-doc-est.emite-comp     = b-docum-est.cod-emitente
                       b-item-doc-est.nat-of-comp    = item-doc-est.nat-of
                       de-tot-valor                  = de-tot-valor + b-item-doc-est.preco-total[1]
                       de-tot-peso                   = de-tot-peso + b-item-doc-est.peso-liquido
                       de-tot-desc                   = de-tot-desc  + b-item-doc-est.desconto[1]
                       de-tot-desp                   = de-tot-desp  + b-item-doc-est.despesas[1]
                       de-tot-pedag                  = de-tot-pedag + DEC(SUBSTR(b-item-doc-est.char-2,819,13))
                       i-sequencia                   = i-sequencia  + param-re.inc-seq
                       b-item-doc-est.cod-unid-negoc = item-doc-est.cod-unid-negoc
                       b-item-doc-est.nat-of         = c-nat-of. /* Sempre grava a natureza fiscal */

                assign b-item-doc-est.idi-tributac-pis    = tt-imposto.cd-trib-pis    
                       b-item-doc-est.val-aliq-pis        = tt-imposto.aliquota-pis 
                       b-item-doc-est.idi-tributac-cofins = tt-imposto.cd-trib-cofins    
                       b-item-doc-est.val-aliq-cofins     = tt-imposto.aliquota-cofins.

                RUN grava-aliquotas IN h-cdapi995 (INPUT "item-doc-est",
                                                   INPUT b-item-doc-est.serie-docto + "/" + 
                                                         b-item-doc-est.nro-docto + "/" + 
                                                         string(b-item-doc-est.cod-emitente) + "/" + 
                                                         b-item-doc-est.nat-operacao + "/" + 
                                                         string(b-item-doc-est.sequencia), 
                                                   INPUT tt-imposto.aliquota-pis,
                                                   INPUT tt-imposto.aliquota-cofins).
                       
                       
                /* testa se existe EPC relacionada ao programa */
                if c-nom-prog-dpc-mg97  <> "" or
                   c-nom-prog-appc-mg97 <> "" or
                   c-nom-prog-upc-mg97  <> "" then do:

                    /* limpa os registros da temp-table da EPC */
                    for each tt-epc where tt-epc.cod-event = "BeforeCreateRateio":
                        delete tt-epc.
                    end.

                    /* carrega a temp-table da EPC */ 
                    {include/i-epc200.i2 &CodEvent       = "'BeforeCreateRateio'"
                                         &CodParameter   = "'rowid-item-doc-est'"
                                         &ValueParameter = "string(rowid(item-doc-est))"}
                                         
                    {include/i-epc200.i2 &CodEvent       = "'BeforeCreateRateio'"
                                         &CodParameter   = "'rowid-b-item-doc-est'"
                                         &ValueParameter = "string(rowid(b-item-doc-est))"}

                    /* executa EPC */
                    {include/i-epc201.i "BeforeCreateRateio"}
                    for each tt-epc 
                        where tt-epc.cod-event = "BeforeCreateRateio":
                        IF tt-epc.cod-parameter = "de-tot-valor-item" THEN 
                            ASSIGN de-tot-valor = de-tot-valor + DEC(tt-epc.val-parameter).
                        ELSE
                        IF tt-epc.cod-parameter = "de-tot-desc-item" THEN
                            ASSIGN de-tot-desc = de-tot-desc + DEC(tt-epc.val-parameter).
                        ELSE
                        IF tt-epc.cod-parameter = "de-tot-desp-item" THEN
                            ASSIGN de-tot-desp = de-tot-desp + DEC(tt-epc.val-parameter).
                        ELSE
                        IF tt-epc.cod-parameter = "de-tot-pedag-item" THEN
                            ASSIGN de-tot-pedag = de-tot-pedag + DEC(tt-epc.val-parameter).
                    END.
                end.
                /**************************************************************/

                if item.tipo-contr <> 2 /*"T"*/ then
                    assign b-item-doc-est.ct-codigo      = item-doc-est.ct-codigo
                           b-item-doc-est.sc-codigo      = item-doc-est.sc-codigo
                           b-item-doc-est.nr-ord-produ    = item-doc-est.nr-ord-produ.                           
                else do:
                    /*Se o item for de controle total e possuir OP, a UN ser† atualizada somente na atualizaá∆o da Nota
                    com uma unidade de neg¢cio referente ao Estoque e n∆o Ö Produá∆o. (C†lculo do preáo mÇdio do item)*/
                    if item-doc-est.nr-ord-produ > 0 then do:                        
                        /** Se o modulo de manutenÁ„o industrial estiver habilitado e o item tiver 
                            uma ordem de manutenÁ„o referenciada, a despesa deve ser aplicada a ordem **/
                        IF AVAIL param-global 
                             AND param-global.modulo-mi
                             AND CAN-FIND(FIRST ord-manut 
                                          WHERE ord-manut.nr-ord-produ = item-doc-est.nr-ord-produ) THEN DO:
                            ASSIGN b-item-doc-est.ct-codigo   = item-doc-est.ct-codigo
                                   b-item-doc-est.sc-codigo   = item-doc-est.sc-codigo
                                   b-item-doc-est.nr-ord-produ = item-doc-est.nr-ord-produ.
                        END.
                        ELSE 
                            ASSIGN b-item-doc-est.cod-unid-negoc = "".    
                    end.    
                end.

                if item-doc-est.num-ord-inv <> 0
                AND param-global.modulo-in then
                    assign b-item-doc-est.ct-codigo      = item-doc-est.ct-codigo
                           b-item-doc-est.sc-codigo      = item-doc-est.sc-codigo
                           b-item-doc-est.num-ord-inv    = item-doc-est.num-ord-inv.

                if  b-item-doc-est.preco-total[1] > de-maior then 
                    assign rw-maior = rowid(b-item-doc-est)
                           de-maior = b-item-doc-est.preco-total[1].

                find first rat-lote {cdp/cd8900.i rat-lote item-doc-est }
                    and rat-lote.sequencia = item-doc-est.sequencia no-lock no-error.
                if  avail rat-lote then 
                    assign b-item-doc-est.cod-depos   = rat-lote.cod-depos
                           b-item-doc-est.cod-localiz = rat-lote.cod-localiz
                           b-item-doc-est.lote        = rat-lote.lote.
                else
                    assign b-item-doc-est.cod-depos   = item-doc-est.cod-depos
                           b-item-doc-est.cod-localiz = item-doc-est.cod-localiz
                           b-item-doc-est.lote        = item-doc-est.lote.                

                /* Retorno do Engine de Regras para alterar conta e centro de custos */               
                FOR EACH tt-retorno:                
                    CASE tt-retorno.campo-retorno:
                        WHEN "ct-codigo":U        THEN ASSIGN   b-item-doc-est.ct-codigo    = STRING(tt-retorno.valor-retorno).
                        WHEN "sc-codigo":U        THEN ASSIGN   b-item-doc-est.sc-codigo    = STRING(tt-retorno.valor-retorno).
                    END CASE.                   
                END.
                
                IF  l-NT2024002 THEN 
                    ASSIGN b-item-doc-est.log-doacao = lDoacao.
                
                /*cfop da nota de saida*/
                RUN gotokey IN h-boin176 (INPUT b-item-doc-est.serie-docto,
                                          INPUT b-item-doc-est.nro-docto,
                                          INPUT b-item-doc-est.cod-emitente,
                                          INPUT b-item-doc-est.nat-operacao,
                                          INPUT b-item-doc-est.sequencia).
                RUN buscaCFOPSaida IN h-boin176 (OUTPUT c-cfop-nota-saida).
                ASSIGN b-item-doc-est.cod-cfop-saida = c-cfop-nota-saida.
                
            END.
            /*Se o cliente possui matriz informada para o documento principal, gera o rateio por essa matriz*/            
            ELSE IF CAN-FIND (FIRST unid-neg-nota 
                              WHERE unid-neg-nota.cod-emitente = item-doc-est.cod-emitente
                                and unid-neg-nota.serie-docto  = item-doc-est.serie-docto
                                and unid-neg-nota.nro-docto    = item-doc-est.nro-docto
                                and unid-neg-nota.nat-operacao = item-doc-est.nat-operacao
                                and unid-neg-nota.sequencia    = item-doc-est.sequencia) THEN DO:
                
                create b-item-doc-est.
                assign b-item-doc-est.sequencia      = i-sequencia
                       b-item-doc-est.nro-docto      = docum-est.nro-docto 
                       b-item-doc-est.serie-docto    = docum-est.serie-docto
                       b-item-doc-est.cod-emitente   = docum-est.cod-emitente
                       b-item-doc-est.nat-operacao   = docum-est.nat-operacao
                       b-item-doc-est.it-codigo      = item-doc-est.it-codigo
                       b-item-doc-est.cod-refer      = item-doc-est.cod-refer
                       b-item-doc-est.class-fiscal   = item-doc-est.class-fiscal
                       b-item-doc-est.un             = item-doc-est.un.
                IF param-re.rateio-nfrateio = 1 THEN DO:    /* Peso */
                    ASSIGN b-item-doc-est.preco-total[1]            = ROUND( item-doc-est.peso-liquido * docum-est.valor-mercad / de-tot-nota-peso, 2)
                           b-item-doc-est.preco-unit[1]             = b-item-doc-est.preco-total[1]
                           b-item-doc-est.desconto[1]               = ROUND( item-doc-est.peso-liquido * docum-est.tot-desconto / de-tot-nota-peso, 2)
                           b-item-doc-est.despesas[1]               = ROUND( item-doc-est.peso-liquido * docum-est.despesa-nota / de-tot-nota-peso, 2)  
                           OVERLAY(b-item-doc-est.char-2,819,13)    = STRING(ROUND( item-doc-est.peso-liquido * DEC(SUBSTR(docum-est.char-2,153,13)) / de-tot-nota-peso, 2)).
                END.
                ELSE DO:                                    /* Valor */             
                    ASSIGN b-item-doc-est.preco-total[1]            = ROUND( item-doc-est.preco-total[1] * docum-est.valor-mercad / de-tot-nota-val, 2)
                           b-item-doc-est.preco-unit[1]             = b-item-doc-est.preco-total[1]
                           b-item-doc-est.desconto[1]               = ROUND( item-doc-est.preco-total[1] * docum-est.tot-desconto / de-tot-nota-val, 2)
                           b-item-doc-est.despesas[1]               = ROUND( item-doc-est.preco-total[1] * docum-est.despesa-nota / de-tot-nota-val, 2)  
                           OVERLAY(b-item-doc-est.char-2,819,13)    = STRING(ROUND( item-doc-est.preco-total[1] * DEC(SUBSTR(docum-est.char-2,153,13)) / de-tot-nota-val, 2)).
                END.
                ASSIGN b-item-doc-est.cd-trib-icm    = tt-imposto.cd-trib-icm
                       b-item-doc-est.aliquota-icm   = tt-imposto.aliquota-icm
                       b-item-doc-est.cd-trib-ipi    = tt-imposto.cd-trib-ipi
                       b-item-doc-est.aliquota-ipi   = tt-imposto.aliquota-ipi
                       b-item-doc-est.val-perc-rep-ipi  = tt-imposto.perc-red-ipi
                       b-item-doc-est.val-perc-red-icms = tt-imposto.perc-red-icm
                       b-item-doc-est.cd-trib-iss    = /*item-doc-est.cd-trib-iss */ i-cd-trib-iss
                       b-item-doc-est.seq-comp       = item-doc-est.sequencia
                       b-item-doc-est.narrativa      = item-doc-est.narrativa
                       b-item-doc-est.nro-comp       = b-docum-est.nro-docto
                       b-item-doc-est.nat-comp       = b-docum-est.nat-operacao
                       b-item-doc-est.serie-comp     = b-docum-est.serie-docto
                       b-item-doc-est.emite-comp     = b-docum-est.cod-emitente
                       b-item-doc-est.nat-of-comp    = item-doc-est.nat-of
                       de-tot-valor                  = de-tot-valor + b-item-doc-est.preco-total[1]
                       de-tot-peso                   = de-tot-peso + b-item-doc-est.peso-liquido
                       de-tot-desc                   = de-tot-desc  + b-item-doc-est.desconto[1]
                       de-tot-desp                   = de-tot-desp  + b-item-doc-est.despesas[1]
                       de-tot-pedag                  = de-tot-pedag + DEC(SUBSTR(b-item-doc-est.char-2,819,13))
                       i-sequencia                   = i-sequencia  + param-re.inc-seq
                       b-item-doc-est.nat-of         = c-nat-of. /* Sempre grava a natureza fiscal */
                
                assign b-item-doc-est.idi-tributac-pis    = tt-imposto.cd-trib-pis    
                       b-item-doc-est.val-aliq-pis        = tt-imposto.aliquota-pis 
                       b-item-doc-est.idi-tributac-cofins = tt-imposto.cd-trib-cofins    
                       b-item-doc-est.val-aliq-cofins     = tt-imposto.aliquota-cofins.
                
                RUN grava-aliquotas IN h-cdapi995 (INPUT "item-doc-est",
                                                   INPUT b-item-doc-est.serie-docto + "/" + 
                                                         b-item-doc-est.nro-docto + "/" + 
                                                         string(b-item-doc-est.cod-emitente) + "/" + 
                                                         b-item-doc-est.nat-operacao + "/" + 
                                                         string(b-item-doc-est.sequencia), 
                                                   INPUT tt-imposto.aliquota-pis,
                                                   INPUT tt-imposto.aliquota-cofins).
                       
                /* testa se existe EPC relacionada ao programa */
                if c-nom-prog-dpc-mg97  <> "" or
                   c-nom-prog-appc-mg97 <> "" or
                   c-nom-prog-upc-mg97  <> "" then do:
        
                    /* limpa os registros da temp-table da EPC */
                    for each tt-epc where tt-epc.cod-event = "BeforeCreateRateio":
                        delete tt-epc.
                    end.
        
                    /* carrega a temp-table da EPC */ 
                    {include/i-epc200.i2 &CodEvent       = "'BeforeCreateRateio'"
                                         &CodParameter   = "'rowid-item-doc-est'"
                                         &ValueParameter = "string(rowid(item-doc-est))"}
                                         
                    {include/i-epc200.i2 &CodEvent       = "'BeforeCreateRateio'"
                                         &CodParameter   = "'rowid-b-item-doc-est'"
                                         &ValueParameter = "string(rowid(b-item-doc-est))"}
        
                    /* executa EPC */
                    {include/i-epc201.i "BeforeCreateRateio"}
                    for each tt-epc 
                        where tt-epc.cod-event = "BeforeCreateRateio":
                        IF tt-epc.cod-parameter = "de-tot-valor-item" THEN 
                            ASSIGN de-tot-valor = de-tot-valor + DEC(tt-epc.val-parameter).
                        ELSE
                        IF tt-epc.cod-parameter = "de-tot-desc-item" THEN
                            ASSIGN de-tot-desc = de-tot-desc + DEC(tt-epc.val-parameter).
                        ELSE
                        IF tt-epc.cod-parameter = "de-tot-desp-item" THEN
                            ASSIGN de-tot-desp = de-tot-desp + DEC(tt-epc.val-parameter).
                        ELSE
                        IF tt-epc.cod-parameter = "de-tot-pedag-item" THEN
                            ASSIGN de-tot-pedag = de-tot-pedag + DEC(tt-epc.val-parameter).
                    END.
                end.
                /**************************************************************/

                if item.tipo-contr <> 2 /*"T"*/ then
                    assign b-item-doc-est.ct-codigo      = item-doc-est.ct-codigo
                           b-item-doc-est.sc-codigo      = item-doc-est.sc-codigo
                           b-item-doc-est.nr-ord-produ    = item-doc-est.nr-ord-produ.
                else do:
                    /*Se o item for de controle total e possuir OP, a UN ser† atualizada somente na atualizaá∆o da Nota
                    com uma unidade de neg¢cio referente ao Estoque e n∆o Ö Produá∆o. (C†lculo do preáo mÇdio do item)*/
                    if item-doc-est.nr-ord-produ > 0 then do:
                        /** Se o modulo de manutenÁ„o industrial estiver habilitado e o item tiver 
                            uma ordem de manutenÁ„o referenciada, a despesa deve ser aplicada a ordem **/
                        IF AVAIL param-global 
                             AND param-global.modulo-mi
                             AND CAN-FIND(FIRST ord-manut 
                                          WHERE ord-manut.nr-ord-produ = item-doc-est.nr-ord-produ) THEN DO:
                            ASSIGN b-item-doc-est.ct-codigo   = item-doc-est.ct-codigo
                                   b-item-doc-est.sc-codigo   = item-doc-est.sc-codigo
                                   b-item-doc-est.nr-ord-produ = item-doc-est.nr-ord-produ.
                        END.
                        ELSE 
                            ASSIGN b-item-doc-est.cod-unid-negoc = "".                                  
                    end.
                end.
                
                if item-doc-est.num-ord-inv <> 0
                AND param-global.modulo-in then
                    assign b-item-doc-est.ct-codigo      = item-doc-est.ct-codigo
                           b-item-doc-est.sc-codigo      = item-doc-est.sc-codigo                                   
                           b-item-doc-est.num-ord-inv    = item-doc-est.num-ord-inv.
                
                if  b-item-doc-est.preco-total[1] > de-maior then 
                    assign rw-maior = rowid(b-item-doc-est)
                           de-maior = b-item-doc-est.preco-total[1].
                
                find first rat-lote {cdp/cd8900.i rat-lote item-doc-est }
                    and rat-lote.sequencia = item-doc-est.sequencia no-lock no-error.
                if  avail rat-lote then 
                    assign b-item-doc-est.cod-depos   = rat-lote.cod-depos
                           b-item-doc-est.cod-localiz = rat-lote.cod-localiz
                           b-item-doc-est.lote        = rat-lote.lote.
                else
                    assign b-item-doc-est.cod-depos   = item-doc-est.cod-depos
                           b-item-doc-est.cod-localiz = item-doc-est.cod-localiz
                           b-item-doc-est.lote        = item-doc-est.lote.  
                
                for each unid-neg-nota
                   where unid-neg-nota.cod-emitente = item-doc-est.cod-emitente
                     and unid-neg-nota.serie-docto  = item-doc-est.serie-docto
                     and unid-neg-nota.nro-docto    = item-doc-est.nro-docto
                     and unid-neg-nota.nat-operacao = item-doc-est.nat-operacao
                     and unid-neg-nota.sequencia    = item-doc-est.sequencia no-lock:
                     
                    create b-unid-neg-nota.
                    assign b-unid-neg-nota.cod-emitente   = b-item-doc-est.cod-emitente
                           b-unid-neg-nota.serie-docto    = b-item-doc-est.serie-docto 
                           b-unid-neg-nota.nro-docto      = b-item-doc-est.nro-docto
                           b-unid-neg-nota.nat-operacao   = b-item-doc-est.nat-operacao 
                           b-unid-neg-nota.sequencia      = b-item-doc-est.sequencia
                           b-unid-neg-nota.cod_unid_negoc = unid-neg-nota.cod_unid_negoc
                           b-unid-neg-nota.perc-unid-neg  = unid-neg-nota.perc-unid-neg.
                end.
                
                /* Retorno do Engine de Regras para alterar conta e centro de custos */
                FOR EACH tt-retorno:
                    CASE tt-retorno.campo-retorno:
                        WHEN "ct-codigo":U THEN ASSIGN b-item-doc-est.ct-codigo = STRING(tt-retorno.valor-retorno).
                        WHEN "sc-codigo":U THEN ASSIGN b-item-doc-est.sc-codigo = STRING(tt-retorno.valor-retorno).
                    END CASE.                               
                END.
                        
                IF  l-NT2024002 THEN 
                    ASSIGN b-item-doc-est.log-doacao = lDoacao.
                    
                /*cfop da nota de saida*/
                RUN gotokey IN h-boin176 (INPUT b-item-doc-est.serie-docto,
                                          INPUT b-item-doc-est.nro-docto,
                                          INPUT b-item-doc-est.cod-emitente,
                                          INPUT b-item-doc-est.nat-operacao,
                                          INPUT b-item-doc-est.sequencia).
                RUN buscaCFOPSaida IN h-boin176 (OUTPUT c-cfop-nota-saida).
                ASSIGN b-item-doc-est.cod-cfop-saida = c-cfop-nota-saida.        
                        
            END. 
            /**************************************************************************************/
            /* Se o cliente utiliza o novo conceito de UN ou se a unidade de neg¢cio n∆o veio     */
            /* informada no item da nota original, determinar† para cada dep¢sito da rat-lote uma */
            /* unidade de neg¢cio. Em seguida, estas unidades de neg¢cio ser∆o agrupadas, e assim */
            /* ser∆o criados os itens da nota de rateio. l-mat-unid-negoc - utiliza UN (param-re) */
            /**************************************************************************************/
            ELSE IF l-mat-unid-negoc then do:

                empty temp-table tt-item-doc-est-un.
                
                for each rat-lote {cdp/cd8900.i rat-lote item-doc-est }
                    and rat-lote.sequencia = item-doc-est.sequencia no-lock:

                    if valid-handle(h-cdapi024) then do:
                        run RetornaUnidadeNegocioExternaliz in h-cdapi024 (input docum-est.cod-estabel,
                                                                           input item-doc-est.it-codigo,
                                                                           input rat-lote.cod-depos,
                                                                           output c-cod-unid-negoc-aux).

                        find first tt-item-doc-est-un
                            where tt-item-doc-est-un.seq-comp       = item-doc-est.sequencia  
                            and   tt-item-doc-est-un.nro-comp       = b-docum-est.nro-docto   
                            and   tt-item-doc-est-un.nat-comp       = b-docum-est.nat-operacao
                            and   tt-item-doc-est-un.serie-comp     = b-docum-est.serie-docto 
                            and   tt-item-doc-est-un.emite-comp     = b-docum-est.cod-emitente
                            and   tt-item-doc-est-un.cod-unid-negoc = c-cod-unid-negoc-aux      no-error.

                        if not avail tt-item-doc-est-un then do:
                            
                            create tt-item-doc-est-un.
                            assign tt-item-doc-est-un.sequencia           = i-sequencia
                                   tt-item-doc-est-un.nro-docto           = docum-est.nro-docto    
                                   tt-item-doc-est-un.serie-docto         = docum-est.serie-docto 
                                   tt-item-doc-est-un.cod-emitente        = docum-est.cod-emitente
                                   tt-item-doc-est-un.nat-operacao        = docum-est.nat-operacao
                                   tt-item-doc-est-un.cod-unid-negoc      = c-cod-unid-negoc-aux
                                   tt-item-doc-est-un.cod-depos           = rat-lote.cod-depos
                                   tt-item-doc-est-un.cod-localiz         = rat-lote.cod-localiz
                                   tt-item-doc-est-un.lote                = rat-lote.lote     
                                   tt-item-doc-est-un.it-codigo           = item-doc-est.it-codigo
                                   tt-item-doc-est-un.cod-refer           = item-doc-est.cod-refer
                                   tt-item-doc-est-un.class-fiscal        = item-doc-est.class-fiscal
                                   tt-item-doc-est-un.un                  = item-doc-est.un
                                   tt-item-doc-est-un.cd-trib-icm         = tt-imposto.cd-trib-icm
                                   tt-item-doc-est-un.aliquota-icm        = tt-imposto.aliquota-icm
                                   tt-item-doc-est-un.cd-trib-ipi         = tt-imposto.cd-trib-ipi
                                   tt-item-doc-est-un.aliquota-ipi        = tt-imposto.aliquota-ipi
                                   tt-item-doc-est-un.val-perc-rep-ipi    = tt-imposto.perc-red-ipi
                                   tt-item-doc-est-un.val-perc-red-icms   = tt-imposto.perc-red-icm
                                   tt-item-doc-est-un.cd-trib-iss         = i-cd-trib-iss
                                   tt-item-doc-est-un.narrativa           = item-doc-est.narrativa
                                   tt-item-doc-est-un.seq-comp            = item-doc-est.sequencia 
                                   tt-item-doc-est-un.nro-comp            = b-docum-est.nro-docto
                                   tt-item-doc-est-un.nat-comp            = b-docum-est.nat-operacao
                                   tt-item-doc-est-un.serie-comp          = b-docum-est.serie-docto
                                   tt-item-doc-est-un.emite-comp          = b-docum-est.cod-emitente
                                   tt-item-doc-est-un.nat-of-comp         = item-doc-est.nat-of
                                   i-sequencia                            = i-sequencia  + param-re.inc-seq
                                   tt-item-doc-est-un.nat-of              = c-nat-of. /* Sempre grava a natureza fiscal */                        

                            assign tt-item-doc-est-un.idi-tributac-pis    = tt-imposto.cd-trib-pis    
                                   tt-item-doc-est-un.val-aliq-pis        = tt-imposto.aliquota-pis 
                                   tt-item-doc-est-un.idi-tributac-cofins = tt-imposto.cd-trib-cofins    
                                   tt-item-doc-est-un.val-aliq-cofins     = tt-imposto.aliquota-cofins.

                            RUN grava-aliquotas IN h-cdapi995 (INPUT "item-doc-est",
                                                               INPUT tt-item-doc-est-un.serie-docto + "/" + 
                                                                     tt-item-doc-est-un.nro-docto + "/" + 
                                                                     string(tt-item-doc-est-un.cod-emitente) + "/" + 
                                                                     tt-item-doc-est-un.nat-operacao + "/" + 
                                                                     string(tt-item-doc-est-un.sequencia), 
                                                               INPUT tt-imposto.aliquota-pis,
                                                               INPUT tt-imposto.aliquota-cofins).
                          
                            if item.tipo-contr <> 2 /*"T"*/ then 
                                assign tt-item-doc-est-un.ct-codigo      = item-doc-est.ct-codigo
                                       tt-item-doc-est-un.sc-codigo      = item-doc-est.sc-codigo
                                       tt-item-doc-est-un.nr-ord-produ    = item-doc-est.nr-ord-produ.
                                       
                            else do:
                                /** Se o modulo de manutenÁ„o industrial estiver habilitado e o item tiver 
                                    uma ordem de manutenÁ„o referenciada, a despesa deve ser aplicada a ordem **/
                                IF AVAIL param-global 
                                     AND param-global.modulo-mi
                                     AND CAN-FIND(FIRST ord-manut 
                                                  WHERE ord-manut.nr-ord-produ = item-doc-est.nr-ord-produ) THEN DO:
                                    ASSIGN tt-item-doc-est-un.ct-codigo   = item-doc-est.ct-codigo
                                           tt-item-doc-est-un.sc-codigo   = item-doc-est.sc-codigo
                                           tt-item-doc-est-un.nr-ord-produ = item-doc-est.nr-ord-produ.
                                END.
                            end.

                            if item-doc-est.num-ord-inv <> 0 
                            AND param-global.modulo-in then
                                assign tt-item-doc-est-un.ct-codigo      = item-doc-est.ct-codigo
                                       tt-item-doc-est-un.sc-codigo      = item-doc-est.sc-codigo
                                       tt-item-doc-est-un.num-ord-inv    = item-doc-est.num-ord-inv.
                        end.

                        /* Retorno do Engine de Regras para alterar conta e centro de custos */ 
                        FOR EACH tt-retorno:
                            CASE tt-retorno.campo-retorno:
                                WHEN "ct-codigo":U THEN ASSIGN tt-item-doc-est-un.ct-codigo = STRING(tt-retorno.valor-retorno).
                                WHEN "sc-codigo":U THEN ASSIGN tt-item-doc-est-un.sc-codigo = STRING(tt-retorno.valor-retorno).
                            END CASE.                               
                        END.
                       
                        /*Acumula quantidades de rat-lote com a mesma unidade de neg¢cio*/
                        assign  tt-item-doc-est-un.quantidade = tt-item-doc-est-un.quantidade + IF (item-doc-est.dec-1 <> 0 AND l-contagem-dif) 
                                                                                                THEN rat-lote.qtd-origin
                                                                                                ELSE rat-lote.quantidade.
                    end.
                end.

                assign de-tot-valor-un      = 0
                       de-tot-peso-un       = 0
                       de-tot-desc-un       = 0
                       de-tot-desp-un       = 0
                       de-tot-pedag-un      = 0
                       rw-maior-un          = ?
                       de-maior-un          = 0
                       de-tot-valor-item-un = 0
                       de-tot-peso-item-un  = 0 
                       de-tot-desc-item-un  = 0
                       de-tot-desp-item-un  = 0
                       de-tot-pedag-item-un = 0.
               
                /*Cria os registros onde foram agrupados os 
                itens da rat-lote por unidade de neg¢cio*/
                for each tt-item-doc-est-un:

                    create b-item-doc-est.
                    buffer-copy tt-item-doc-est-un to b-item-doc-est.

                    /*Rateio dos valores a n°vel de rat-lote*/
                    IF param-re.rateio-nfrateio = 1 THEN DO:    /* Peso */
                        ASSIGN b-item-doc-est.preco-total[1]            = ROUND( (item-doc-est.peso-liquido * docum-est.valor-mercad / de-tot-nota-peso) * (b-item-doc-est.quantidade / item-doc-est.quantidade), 2)
                               b-item-doc-est.preco-unit[1]             = b-item-doc-est.preco-total[1]
                               b-item-doc-est.desconto[1]               = ROUND( docum-est.tot-desconto / de-tot-nota-peso * (item-doc-est.peso-liquido / item-doc-est.quantidade * b-item-doc-est.quantidade), 2) 
                               b-item-doc-est.despesas[1]               = ROUND( docum-est.despesa-nota / de-tot-nota-peso * (item-doc-est.peso-liquido / item-doc-est.quantidade * b-item-doc-est.quantidade), 2)
                               OVERLAY(b-item-doc-est.char-2,819,13)    = STRING(ROUND( item-doc-est.peso-liquido * DEC(SUBSTR(docum-est.char-2,153,13)) / de-tot-nota-peso, 2)).
                    END.
                    ELSE DO:                                    /* Valor */
                        ASSIGN b-item-doc-est.preco-total[1]            = ROUND( (item-doc-est.preco-total[1] * docum-est.valor-mercad / de-tot-nota-val) * (b-item-doc-est.quantidade / item-doc-est.quantidade), 2)
                               b-item-doc-est.preco-unit[1]             = b-item-doc-est.preco-total[1]
                               b-item-doc-est.desconto[1]               = ROUND( docum-est.tot-desconto / de-tot-nota-val * (item-doc-est.preco-total[1] / item-doc-est.quantidade * b-item-doc-est.quantidade), 2) 
                               b-item-doc-est.despesas[1]               = ROUND( docum-est.despesa-nota / de-tot-nota-val * (item-doc-est.preco-total[1] / item-doc-est.quantidade * b-item-doc-est.quantidade), 2)
                               OVERLAY(b-item-doc-est.char-2,819,13)    = STRING(ROUND( item-doc-est.preco-total[1] * DEC(SUBSTR(docum-est.char-2,153,13)) / de-tot-nota-val, 2)).
                    END.
                    
                    /* testa se existe EPC relacionada ao programa */
                    if c-nom-prog-dpc-mg97  <> "" or
                       c-nom-prog-appc-mg97 <> "" or
                       c-nom-prog-upc-mg97  <> "" then do:
    
                        /* limpa os registros da temp-table da EPC */
                        for each tt-epc where tt-epc.cod-event = "BeforeCreateRateioUN":
                            delete tt-epc.
                        end.
    
                        /* carrega a temp-table da EPC */ 
                        {include/i-epc200.i2 &CodEvent       = "'BeforeCreateRateioUN'"
                                             &CodParameter   = "'rowid-item-doc-est'"
                                             &ValueParameter = "string(rowid(item-doc-est))"}
                                             
                        {include/i-epc200.i2 &CodEvent       = "'BeforeCreateRateioUN'"
                                             &CodParameter   = "'rowid-b-item-doc-est'"
                                             &ValueParameter = "string(rowid(b-item-doc-est))"}
    
                        /* executa EPC */
                        {include/i-epc201.i "BeforeCreateRateioUN"}
                    end.
                    /**************************************************************/

                    /*Acumula os valores que foram rateados gerando os itens da nota de rateio a n°vel de rat-lote,
                    em seguida, estes valores ser∆o comparados com os valores rateados a n°vel de item, se
                    houver discrepÉncia, ser∆o acertados os res°duos*/
                    assign de-tot-valor-un = de-tot-valor-un + b-item-doc-est.preco-total[1]
                           de-tot-peso-un  = de-tot-peso-un + b-item-doc-est.peso-liquido
                           de-tot-desc-un  = de-tot-desc-un  + b-item-doc-est.desconto[1]
                           de-tot-desp-un  = de-tot-desp-un  + b-item-doc-est.despesas[1]
                           de-tot-pedag-un = de-tot-pedag-un + DEC(SUBSTR(b-item-doc-est.char-2,819,13)).

                    /*Guarda o maior rowid para acerto de res°duos a n°vel de rat-lote*/
                    if b-item-doc-est.preco-total[1] > de-maior-un then
                        assign rw-maior-un = rowid(b-item-doc-est) 
                               de-maior-un = b-item-doc-est.preco-total[1].
                    
                    /*Guarda o maior rowid para acerto de res°duos a n°vel de item*/
                    if  b-item-doc-est.preco-total[1] > de-maior then 
                        assign rw-maior = rowid(b-item-doc-est)
                               de-maior = b-item-doc-est.preco-total[1].

                    /*Itens da nota de Rateio s∆o criados com quantidade zerada*/
                    assign b-item-doc-est.quantidade     = 0
                           b-item-doc-est.cod-unid-negoc = "".
                           
                    IF  l-NT2024002 THEN 
                        ASSIGN b-item-doc-est.log-doacao = lDoacao.                           
                           
                    RUN gotokey IN h-boin176 (INPUT b-item-doc-est.serie-docto,
                                              INPUT b-item-doc-est.nro-docto,
                                              INPUT b-item-doc-est.cod-emitente,
                                              INPUT b-item-doc-est.nat-operacao,
                                              INPUT b-item-doc-est.sequencia).
                    RUN buscaCFOPSaida IN h-boin176 (OUTPUT c-cfop-nota-saida).
                    ASSIGN b-item-doc-est.cod-cfop-saida = c-cfop-nota-saida.
                           
                end.

                /*S¢ acertar† res°duos em n°vel de rat-lote se o item for criado neste n°vel*/
                if  not can-find (first unid-neg-nota 
                                  where unid-neg-nota.cod-emitente = item-doc-est.cod-emitente
                                    and unid-neg-nota.serie-docto  = item-doc-est.serie-docto
                                    and unid-neg-nota.nro-docto    = item-doc-est.nro-docto
                                    and unid-neg-nota.nat-operacao = item-doc-est.nat-operacao
                                    and unid-neg-nota.sequencia    = item-doc-est.sequencia)
                AND item-doc-est.cod-unid-negoc = "" then do:
                       
                    /*Acumula os valores para o acerto dos res°duos das rat-lote a n°vel de item (aqui rateia o valor da nota de rateio
                      pelos itens, e n∆o por rat-lote, para posterior verificaá∆o: se os valores rateados por rat-lote somados n∆o fecharem com 
                      os valores rateados para o item, ser† feito o acerto de res°duos)*/
                    IF param-re.rateio-nfrateio = 1 THEN     /* Peso */
                        ASSIGN de-tot-valor-item-un  = ROUND( item-doc-est.peso-liquido * docum-est.valor-mercad / de-tot-nota-peso, 2)
                               de-tot-peso-item-un   = ROUND( item-doc-est.peso-liquido * docum-est.valor-mercad / de-tot-nota-peso, 2)
                               de-tot-desc-item-un   = ROUND( item-doc-est.peso-liquido * docum-est.tot-desconto / de-tot-nota-peso, 2)
                               de-tot-desp-item-un   = ROUND( item-doc-est.peso-liquido * docum-est.despesa-nota / de-tot-nota-peso, 2)
                               de-tot-pedag-item-un  = round( item-doc-est.peso-liquido * dec(substr(docum-est.char-2,153,13)) / de-tot-nota-peso, 2).
                    ELSE                                    /*Valor*/
                        ASSIGN de-tot-valor-item-un  = ROUND( item-doc-est.preco-total[1] * docum-est.valor-mercad / de-tot-nota-val, 2)
                               de-tot-peso-item-un   = ROUND( item-doc-est.peso-liquido * docum-est.valor-mercad / de-tot-nota-peso, 2)
                               de-tot-desc-item-un   = ROUND( item-doc-est.preco-total[1] * docum-est.tot-desconto / de-tot-nota-val, 2)
                               de-tot-desp-item-un   = ROUND( item-doc-est.preco-total[1] * docum-est.despesa-nota / de-tot-nota-val, 2)
                               de-tot-pedag-item-un  = ROUND( item-doc-est.preco-total[1] * DEC(SUBSTR(docum-est.char-2,153,13)) / de-tot-nota-val, 2).
                    
                    /* testa se existe EPC relacionada ao programa */
                    if c-nom-prog-dpc-mg97  <> "" or
                       c-nom-prog-appc-mg97 <> "" or
                       c-nom-prog-upc-mg97  <> "" then do:

                        /* limpa os registros da temp-table da EPC */
                        for each tt-epc where tt-epc.cod-event = "BeforeCreateRateioUNAct":
                            delete tt-epc.
                        end.

                        /* carrega a temp-table da EPC */ 
                        {include/i-epc200.i2 &CodEvent       = "'BeforeCreateRateioUNAct'"
                                             &CodParameter   = "'rowid-item-doc-est'"
                                             &ValueParameter = "string(rowid(item-doc-est))"}
                                             
                        {include/i-epc200.i2 &CodEvent       = "'BeforeCreateRateioUNAct'"
                                             &CodParameter   = "'rowid-docum-est'"
                                             &ValueParameter = "string(rowid(docum-est))"}

                        /* executa EPC */
                        {include/i-epc201.i "BeforeCreateRateioUNAct"}
                        for each tt-epc 
                            where tt-epc.cod-event = "BeforeCreateRateioUNAct":
                            IF tt-epc.cod-parameter = "de-tot-valor-item" THEN 
                                ASSIGN de-tot-valor-item-un = DEC(tt-epc.val-parameter).
                            ELSE
                            IF tt-epc.cod-parameter = "de-tot-desc-item" THEN
                                ASSIGN de-tot-desc-item-un = DEC(tt-epc.val-parameter).
                            ELSE
                            IF tt-epc.cod-parameter = "de-tot-desp-item" THEN
                                ASSIGN de-tot-desp-item-un = DEC(tt-epc.val-parameter).
                            ELSE
                            IF tt-epc.cod-parameter = "de-tot-pedag-item" THEN
                                ASSIGN de-tot-pedag-item-un = DEC(tt-epc.val-parameter).
                        END.
                    end.
                    /**************************************************************/

                    /*--- ACERTA RES÷DUOS POR ITEM (RAT-LOTE) UNIDADE DE NEG‡CIO---*/
                    if de-tot-valor-item-un <> de-tot-valor-un
                    OR de-tot-peso-item-un  <> de-tot-peso-un
                    or de-tot-desc-item-un  <> de-tot-desc-un
                    or de-tot-desp-item-un  <> de-tot-desp-un 
                    or de-tot-pedag-item-un <> de-tot-pedag-un   then do:
                  
                        for first b-item-doc-est-aux
                            fields ( preco-total[1]      preco-unit[1]   
                                     desconto[1]         despesas[1]
                                     peso-liquido )
                            where rowid(b-item-doc-est-aux) = rw-maior-un exclusive-lock:
                            
                            /*Valor rateio item - soma dos valores rateados por UN*/
                            ASSIGN b-item-doc-est-aux.preco-total[1]         = b-item-doc-est-aux.preco-total[1] + (de-tot-valor-item-un - de-tot-valor-un)
                                   b-item-doc-est-aux.preco-unit[1]          = b-item-doc-est-aux.preco-total[1]
                                   b-item-doc-est-aux.desconto[1]            = b-item-doc-est-aux.desconto[1]    + (de-tot-desc-item-un - de-tot-desc-un)
                                   b-item-doc-est-aux.despesas[1]            = b-item-doc-est-aux.despesas[1]    + (de-tot-desp-item-un - de-tot-desp-un)
                                   OVERLAY(b-item-doc-est-aux.char-2,819,13) = STRING(ROUND(DEC(SUBSTR(b-item-doc-est-aux.char-2,819,13)) + (de-tot-pedag-item-un - de-tot-pedag-un),2)).
                        end.
                    end.
                end. 

                /*Acumula valores para o acerto geral (a n°vel de itens) de res°duos nos itens gerados para a nota de rateio*/
                assign de-tot-valor = de-tot-valor + b-item-doc-est.preco-total[1]
                       de-tot-peso  = de-tot-peso  + b-item-doc-est.peso-liquido
                       de-tot-desc  = de-tot-desc  + b-item-doc-est.desconto[1]   
                       de-tot-desp  = de-tot-desp  + b-item-doc-est.despesas[1]
                       de-tot-pedag = de-tot-pedag + DEC(SUBSTR(b-item-doc-est.char-2,819,13)). 

            end. /*else if l-mat-unid-negoc*/
        end. /*for each item-doc-est*/
    end.

    /*--- ACERTA RES÷DUOS ---*/
    if  docum-est.valor-mercad <> de-tot-valor
    OR  docum-est.peso-liquido-tot <> de-tot-peso
    or  docum-est.tot-desconto <> de-tot-desc
    or  docum-est.despesa-nota <> de-tot-desp 
    or  dec(substr(docum-est.char-2,153,13)) <> de-tot-pedag then do:
    
        for first item-doc-est
           fields ( preco-total[1]      preco-unit[1]   
                    desconto[1]         despesas[1] 
                    peso-liquido)
            where rowid(item-doc-est) = rw-maior exclusive-lock:
        end.
        
        if  avail item-doc-est then do:  
            ASSIGN item-doc-est.preco-total[1] = item-doc-est.preco-total[1] + (docum-est.valor-mercad - de-tot-valor)
                   item-doc-est.preco-unit[1]           = item-doc-est.preco-total[1]
                   item-doc-est.desconto[1]             = item-doc-est.desconto[1] + (docum-est.tot-desconto - de-tot-desc)
                   item-doc-est.despesas[1]             = item-doc-est.despesas[1] + (docum-est.despesa-nota - de-tot-desp)
                   OVERLAY(item-doc-est.char-2,819,13)  = STRING(ROUND(DEC(SUBSTR(item-doc-est.char-2,819,13)) + (DEC(SUBSTR(docum-est.char-2,153,13)) - de-tot-pedag),2)).
            
        end.
    end.
    
    /************* CHAMADA EPC - NUTRON-3 - FO 1597.302 ***********/
    
    /* testa se existe EPC relacionada ao programa */
    if c-nom-prog-dpc-mg97  <> "" or
       c-nom-prog-appc-mg97 <> "" or
       c-nom-prog-upc-mg97  <> "" then do:
    
        /* limpa os registros da temp-table da EPC */
        for each tt-epc where tt-epc.cod-event = "afterCreateRateio":
            delete tt-epc.
        end.
    
        /* carrega a temp-table da EPC */ 
        {include/i-epc200.i2 &CodEvent       = "'afterCreateRateio'"
                             &CodParameter   = "'rowid-docum-est'"
                             &ValueParameter = "string(rowid(docum-est))"}
        
        /* executa EPC */
        {include/i-epc201.i "afterCreateRateio"}
        
    end.
    /**************************************************************/
    
    run calculateImpostosRateio.
    
    FINALLY:
        if valid-handle(h-cdapi024) then do:
            delete procedure h-cdapi024.
            assign h-cdapi024 = ?.
        end.
        
        IF VALID-HANDLE(h-cdapi034) THEN DO:
            DELETE PROCEDURE h-cdapi034.
            ASSIGN h-cdapi034 = ?.
        END.
    END.

END PROCEDURE.


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteItemDocEst DBOProgram 
PROCEDURE deleteItemDocEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    if  avail docum-est then
        for each item-doc-est
            fields ( cod-emitente serie-docto nro-docto nat-operacao sequencia)
            where item-doc-est.cod-emitente = docum-est.cod-emitente
              and item-doc-est.serie-docto  = docum-est.serie-docto
              and item-doc-est.nro-docto    = docum-est.nro-docto
              and item-doc-est.nat-operacao = docum-est.nat-operacao exclusive-lock:
              
            FOR EACH item-doc-est-tribut EXCLUSIVE-LOCK
                WHERE item-doc-est-tribut.cod-serie-docto   = item-doc-est.serie-docto 
                  AND item-doc-est-tribut.cod-num-docto     = item-doc-est.nro-docto
                  AND item-doc-est-tribut.cdn-emitente      = item-doc-est.cod-emitente
                  AND item-doc-est-tribut.cod-natur-operac  = item-doc-est.nat-operacao
                  AND item-doc-est-tribut.num-seq           = item-doc-est.sequencia:
                  DELETE item-doc-est-tribut. 
            END.  
            
            delete item-doc-est.
        end.    
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE canFindNatOf DBOProgram 
PROCEDURE canFindNatOf :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Retorna yes quando alguns do itens do documento tem natureza traduzida      
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER p-nat-of AS LOGICAL NO-UNDO.

    ASSIGN p-nat-of = l-nat-of. 
    
              
    RETURN "OK":U.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findDocumEst DBOProgram 
PROCEDURE findDocumEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param pCodEmitente    like docum-est.cod-emitente no-undo.
    def input param pSerieDocto     like docum-est.serie-docto  no-undo.
    def input param pNroDocto       like docum-est.nro-docto    no-undo.
    def input param pNatOperacao    like docum-est.nat-operacao no-undo.
    
    if  not avail docum-est 
    or  docum-est.cod-emitente <> pCodEmitente
    or  docum-est.serie-docto  <> pSerieDocto
    or  docum-est.nro-docto    <> pNroDocto
    or  docum-est.nat-operacao <> pNatOperacao then 
        
        for first docum-est
           fields ( cod-emitente    serie-docto
                    nro-docto       nat-operacao
                    ce-atual        valor-mercad
                    tot-desconto    despesa-nota
                    dt-emissao rec-fisico char-2 
                    cod-estabel)
            where docum-est.cod-emitente = pCodEmitente
              and docum-est.serie-docto  = pSerieDocto
              and docum-est.nro-docto    = pNroDocto
              and docum-est.nat-operacao = pNatOperacao no-lock:
        end.              

    return "OK":U.
    
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

    def input param piCodEmitente   like emitente.cod-emitente no-undo.
    def input param piNomeAbrev     like emitente.nome-abrev   no-undo.
    
    if  piCodEmitente <> ? then do:
    
        if  not avail emitente
        or  emitente.cod-emitente <> piCodEmitente then 
            for first emitente
               fields ( cod-emitente nome-abrev char-1
                        &if '{&bf_dis_versao_ems}' >= '2.06' &then 
                             idi-tributac-pis idi-tributac-cofins
                        &endif )
                where emitente.cod-emitente = piCodEmitente no-lock:
            end.
    end.
    else 
    if  piNomeAbrev <> ? then do:
        
        if  not avail emitente
        or  emitente.nome-abrev <> piNomeAbrev then 
            for first emitente
               fields ( cod-emitente nome-abrev )
                where emitente.nome-abrev = piNomeAbrev no-lock:
            end.
    end.
    
    if  not avail emitente then 
        RETURN "NOK":U.
    else 
        RETURN "OK":U.                                    
        

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findEmitente DBOProgram 
PROCEDURE findEmitenteFields :
/*------------------------------------------------------------------------------
  Purpose: Metodo criado para busca do emitente para mostrar 
           na tela re1904  
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param piCodEmitente   like emitente.cod-emitente no-undo.
    def input param piNomeAbrev     like emitente.nome-abrev   no-undo.
    
    if  piCodEmitente <> ? then do:    
        if  not avail bf-emitente
        or  bf-emitente.cod-emitente <> piCodEmitente then 
            for first bf-emitente
               fields ( cod-emitente nome-abrev char-1
                        &if '{&bf_dis_versao_ems}' >= '2.06' &then 
                             idi-tributac-pis idi-tributac-cofins
                        &endif )
                where bf-emitente.cod-emitente = piCodEmitente no-lock:
            end.
    end.
    else 
    if  piNomeAbrev <> ? then do:
        if  not avail bf-emitente
        or  bf-emitente.nome-abrev <> piNomeAbrev then 
            for first bf-emitente
               fields ( cod-emitente nome-abrev )
                where bf-emitente.nome-abrev = piNomeAbrev no-lock:
            end.
    end.
    
    IF  NOT AVAIL bf-emitente THEN
        RETURN "NOK":U.    
    ELSE    
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

    def input param piCodEstabel like docum-est.cod-estabel no-undo.

    if  not avail estabelec
    or  estabelec.cod-estabel <> piCodEstabel then 
    for first estabelec
       fields ( cod-estabel char-2
                &if '{&bf_dis_versao_ems}' >= '2.06' &then
                    idi-tributac-cofins 
                &endif )
        where estabelec.cod-estabel = piCodEstabel no-lock:
    end.

    return "OK":U.                    

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

    def input param piItCodigo   like item.it-codigo  no-undo.
    
    if  not avail item
    or  item.it-codigo <> piItCodigo then 
        for first item
            where item.it-codigo = piItCodigo no-lock:
        end.

    return "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findItem DBOProgram 
PROCEDURE findItemUniEstab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param p-cod-estabel like item-uni-estab.cod-estabel no-undo.
    def input param p-it-codigo   like item-uni-estab.it-codigo   no-undo.        

    for first item-uni-estab
        where item-uni-estab.it-codigo   = p-it-codigo
          and item-uni-estab.cod-estabel = p-cod-estabel no-lock:
    end.
    if  not avail item-uni-estab then do:
        {method/svc/errors/inserr.i
                   &ErrorNumber="25904"
                   &ErrorType="EMS"
                   &ErrorSubType="ERROR"
                   &ErrorParameters="item-doc-est.it-codigo + '~~~~' + p-cod-estabel"}
        RETURN "NOK":U.
    end.
    else 
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
    DEFINE INPUT PARAMETER piNatOperacao LIKE docum-est.nat-operacao NO-UNDO.
   
    IF NOT AVAIL natur-oper OR (natur-oper.nat-operacao <> piNatOperacao) THEN DO:
        FIND FIRST natur-oper NO-LOCK
             WHERE natur-oper.nat-operacao = piNatOperacao NO-ERROR.
    END.
        
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findParamOf DBOProgram 
PROCEDURE findParamOf :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piCodEstabel like docum-est.cod-estabel no-undo.

    if  not avail param-of
    or  param-of.cod-estabel <> piCodEstabel then 
    for first param-of
       fields ( cod-estabel char-2 
                &if '{&bf_dis_versao_ems}' >= '2.06' &then 
                     dat-pis-recup  dat-cofins-recup 
                &endif )
        where param-of.cod-estabel = piCodEstabel no-lock:
    end.
    
    return "OK":U.                    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findParamRe DBOProgram 
PROCEDURE findParamRe :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piUsuario   like param-re.usuario no-undo.
    
    if  not avail param-re
    or  param-re.usuario <> piUsuario then 
        for first param-re
           fields ( usuario inc-seq rateio-nfrateio)
            where param-re.usuario = piUsuario no-lock:
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "nat-operacao":U THEN ASSIGN pFieldValue = RowObject.nat-operacao.
        WHEN "nf-nat-oper":U THEN ASSIGN pFieldValue = RowObject.nf-nat-oper.
        WHEN "nf-nro":U THEN ASSIGN pFieldValue = RowObject.nf-nro.
        WHEN "nf-serie":U THEN ASSIGN pFieldValue = RowObject.nf-serie.
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
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
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescriptionField DBOProgram 
PROCEDURE getDescriptionField :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pFieldName   AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    CASE pFieldName:
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = if  avail bf-emitente then 
                                                            string(bf-emitente.cod-emitente)
                                                        else "":U.
        WHEN "nome-abrev":U   THEN ASSIGN pFieldValue = if  avail bf-emitente then 
                                                            bf-emitente.nome-abrev
                                                        else "":U.
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
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "nf-emitente":U THEN ASSIGN pFieldValue = RowObject.nf-emitente.
        WHEN "tipo-nota":U THEN ASSIGN pFieldValue = RowObject.tipo-nota.
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
               retorna valor do campo nf-serie
               retorna valor do campo nf-nro
               retorna valor do campo nf-emitente
               retorna valor do campo nf-nat-oper
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pserie-docto LIKE rat-docum.serie-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pnro-docto LIKE rat-docum.nro-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE rat-docum.cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pnat-operacao LIKE rat-docum.nat-operacao NO-UNDO.
    DEFINE OUTPUT PARAMETER pnf-serie LIKE rat-docum.nf-serie NO-UNDO.
    DEFINE OUTPUT PARAMETER pnf-nro LIKE rat-docum.nf-nro NO-UNDO.
    DEFINE OUTPUT PARAMETER pnf-emitente LIKE rat-docum.nf-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pnf-nat-oper LIKE rat-docum.nf-nat-oper NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pserie-docto = RowObject.serie-docto
           pnro-docto = RowObject.nro-docto
           pcod-emitente = RowObject.cod-emitente
           pnat-operacao = RowObject.nat-operacao
           pnf-serie = RowObject.nf-serie
           pnf-nro = RowObject.nf-nro
           pnf-emitente = RowObject.nf-emitente
           pnf-nat-oper = RowObject.nf-nat-oper.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTributaPisCofins DBOProgram 
PROCEDURE getTributaPisCofins :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def output param pi-trib-pis        as int.
    def output param pi-aliquota-pis    AS DECIMAL FORMAT ">9.9999".
    def output param pi-trib-cofins     as int.
    def output param pi-aliquota-cofins AS DECIMAL FORMAT ">9.9999".

    if  not avail docum-est then 
        return "NOK":U.

    if  not avail natur-oper then 
        return "NOK":U.

    if  not avail estabelec then 
        return "NOK":U.

    if  not avail emitente then 
        return "NOK":U.

    assign pi-trib-pis        = 2    
           pi-aliquota-pis    = 0
           pi-trib-cofins     = 2    
           pi-aliquota-cofins = 0.
 
    RUN recupera-aliquotas IN h-cdapi995 (INPUT "natur-oper",
                                         INPUT natur-oper.nat-operacao,
                                         OUTPUT de-pc-pis,
                                         OUTPUT de-pc-cofins).

    /* PIS */
    if (avail param-of and docum-est.dt-emissao >= param-of.dat-pis-recup )
    or (not avail param-of and docum-est.dt-emissao >= 12/01/2002) then do:

        if  estabelec.idi-tributac-cofins = 1 then do:               /* Trib Pis/Cofins*/
            if  int(substring(natur-oper.char-1,86,1)) = 1           /** Tributado **/  
            or  int(substring(natur-oper.char-1,86,1)) = 3           /** Outros    **/  
            or  int(substring(natur-oper.char-1,86,1)) = 4 then      /** Reduzido  **/
                       
                if  emitente.idi-tributac-pis = 1 then           /** Tributado **/

                    assign de-pc-pis       = natur-oper.perc-pis[1] WHEN de-pc-pis = 0
                           pi-trib-pis     = int(substring(natur-oper.char-1,86,1))
                           pi-aliquota-pis = if natur-oper.mercado = 1
                                             then de-pc-pis
                                             else natur-oper.perc-pis[2].
            
        end.
    end.

    /* COFINS */
    if (avail param-of and docum-est.dt-emissao >= param-of.dat-cofins-recup )
    or (not avail param-of and docum-est.dt-emissao >= 02/01/2004) then do:
 
        if  estabelec.idi-tributac-cofins = 1 then do:            /* Trib Pis/cofins*/
            if  int(substring(natur-oper.char-1,87,1)) = 1        /** Tributado **/ 
            or  int(substring(natur-oper.char-1,87,1)) = 3        /** Outros    **/ 
            or  int(substring(natur-oper.char-1,87,1)) = 4 then   /** Reduzido  **/ 
            
                if  emitente.idi-tributac-cofins = 1 then         /** Tributado **/ 

                    assign de-pc-cofins       = natur-oper.per-fin-soc[1] WHEN de-pc-cofins = 0
                           pi-trib-cofins     = int(substring(natur-oper.char-1,87,1))
                           pi-aliquota-cofins = if natur-oper.mercado = 1
                                                then de-pc-cofins
                                                else natur-oper.per-fin-soc[2].
        end.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTTImposto DBOProgram 
PROCEDURE getTTImposto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def output param table for tt-imposto.
    
    def var pi-trib-pis    as int                      no-undo.
    def var pi-aliq-pis    AS DECIMAL FORMAT ">9.9999" no-undo.
    def var pi-trib-cofins as int                      no-undo.
    def var pi-aliq-cofins AS DECIMAL FORMAT ">9.9999" no-undo.
    
    if  not avail natur-oper then 
        RETURN "NOK":U.        
        
    EMPTY TEMP-TABLE tt-imposto NO-ERROR.    
    create tt-imposto.        
    assign tt-imposto.cd-trib-ipi  = natur-oper.cd-trib-ipi
           tt-imposto.cd-trib-icm  = natur-oper.cd-trib-icm
           tt-imposto.aliquota-ipi = 0
           tt-imposto.aliquota-icm = natur-oper.aliquota-icm
           tt-imposto.perc-red-ipi = natur-oper.perc-red-ipi
           tt-imposto.perc-red-icm = natur-oper.perc-red-icm.

    run getTributaPisCofins ( output pi-trib-pis,
                              output pi-aliq-pis,
                              output pi-trib-cofins,
                              output pi-aliq-cofins ).

                              
    assign tt-imposto.cd-trib-pis     = pi-trib-pis
           tt-imposto.aliquota-pis    = pi-aliq-pis
           tt-imposto.cd-trib-cofins  = pi-trib-cofins
           tt-imposto.aliquota-cofins = pi-aliq-cofins.
           
    return "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getValorMercad DBOProgram 
PROCEDURE getValorMercad :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def output param piValorMercad  like docum-est.valor-mercad  no-undo.
    
    run findDocumEst ( i-cod-emitente,
                       c-serie-docto,
                       c-nro-docto,
                       c-nat-operacao ).
                       
    assign piValorMercad = if  avail docum-est
                           then docum-est.valor-mercad
                           else 0.

    return "OK":U.
            
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getValorPedagio DBOProgram 
PROCEDURE getValorPedagio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def output param piValorPedagio  like docum-est.valor-mercad  no-undo.
    
    run findDocumEst ( i-cod-emitente,
                       c-serie-docto,
                       c-nro-docto,
                       c-nat-operacao ).
                       
    assign piValorPedagio = if  avail docum-est
                           then dec(SUBSTR(docum-est.char-2,153,13))
                           else 0.

    return "OK":U.
            
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getValuesImpostos DBOProgram 
PROCEDURE getValuesImpostos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def output param piAliqIPI      like item-doc-est.aliquota-ipi  no-undo.
    def output param piCdTribIPI    like item-doc-est.cd-trib-ipi   no-undo.
    def output param piAliqICM      like item-doc-est.aliquota-icm  no-undo.
    def output param piCdTribICM    like item-doc-est.cd-trib-icm   no-undo.
    def output param pidePercIPI    as dec                          no-undo.
    def output param pidePercICM    as dec                          no-undo.
    def output param piCdTribPis    as int                          no-undo.
    def output param piAliqPis      AS DECIMAL FORMAT ">9.9999"     no-undo.
    def output param piCdTribCofins as int                          no-undo.
    def output param piAliqCofins   AS DECIMAL FORMAT ">9.9999"     no-undo.

    run findDocumEst ( i-cod-emitente,
                       c-serie-docto,
                       c-nro-docto,
                       c-nat-operacao ).

    if avail docum-est then do:
    
        IF l-mult-natur-receb THEN DO:    
            FOR FIRST  item-doc-est
                FIELDS (cod-emitente nro-docto
                        serie-docto  nat-operacao
                        aliquota-ipi cd-trib-ipi
                        aliquota-icm cd-trib-icm char-2
                        val-perc-rep-ipi 
                        val-perc-red-icms
                        &IF "{&bf_dis_versao_ems}" >= "2.06":U &THEN
                            idi-tributac-pis    val-aliq-pis
                            idi-tributac-cofins val-aliq-cofins
                        &ENDIF
                        sequencia )
                WHERE  item-doc-est.cod-emitente = docum-est.cod-emitente AND
                       item-doc-est.nro-docto    = docum-est.nro-docto    AND
                       item-doc-est.serie-docto  = docum-est.serie-docto  AND
                       item-doc-est.nat-operacao = docum-est.nat-operacao AND 
                       item-doc-est.nat-of       = docum-est.nat-operacao NO-LOCK:
            END.
        END.    
        ELSE DO: 
             FOR FIRST  item-doc-est
                FIELDS (cod-emitente nro-docto
                        serie-docto  nat-operacao
                        aliquota-ipi cd-trib-ipi
                        aliquota-icm cd-trib-icm char-2
                        val-perc-rep-ipi 
                        val-perc-red-icms
                        &IF "{&bf_dis_versao_ems}" >= "2.06":U &THEN
                            idi-tributac-pis    val-aliq-pis
                            idi-tributac-cofins val-aliq-cofins
                        &ENDIF
                        sequencia )
                WHERE  item-doc-est.cod-emitente = docum-est.cod-emitente AND
                       item-doc-est.nro-docto    = docum-est.nro-docto    AND
                       item-doc-est.serie-docto  = docum-est.serie-docto  AND
                       item-doc-est.nat-operacao = docum-est.nat-operacao NO-LOCK:
            END.        
        END.

        if  avail item-doc-est then do:
            ASSIGN de-pc-pis    = 0
                   de-pc-cofins = 0.
            
            RUN recupera-aliquotas IN h-cdapi995 (INPUT "item-doc-est",
                                                 INPUT item-doc-est.serie-docto + "/" + 
                                                       item-doc-est.nro-docto + "/" + 
                                                       string(item-doc-est.cod-emitente) + "/" + 
                                                       item-doc-est.nat-operacao + "/" + 
                                                       string(item-doc-est.sequencia), 
                                                 OUTPUT de-pc-pis,
                                                 OUTPUT de-pc-cofins).

            assign piAliqIPI      = item-doc-est.aliquota-ipi
                   piCdTribIPI    = item-doc-est.cd-trib-ipi
                   piAliqICM      = item-doc-est.aliquota-icm
                   piCdTribICM    = item-doc-est.cd-trib-icm
                   pidePercIPI    = item-doc-est.val-perc-rep-ipi /* perc ipi */
                   pidePercICM    = item-doc-est.val-perc-red-icms /* perc icm */.
            
            &if '{&bf_dis_versao_ems}' >= '2.06' &then
                IF de-pc-pis    = 0 THEN ASSIGN de-pc-pis    = item-doc-est.val-aliq-pis.
                IF de-pc-cofins = 0 THEN ASSIGN de-pc-cofins = item-doc-est.val-aliq-cofins.

                assign piCdTribPis    = item-doc-est.idi-tributac-pis
                       piAliqPis      = de-pc-pis
                       piCdTribCofins = item-doc-est.idi-tributac-cofins
                       piAliqCofins   = de-pc-cofins.
            &else
                IF de-pc-pis    = 0 THEN ASSIGN de-pc-pis    = dec(substring(item-doc-est.char-2,22,5)).
                IF de-pc-cofins = 0 THEN ASSIGN de-pc-cofins = dec(substring(item-doc-est.char-2,84,5)).
                assign piCdTribPis    = int(substring(item-doc-est.char-2,21,1))
                       piAliqPis      = de-pc-pis
                       piCdTribCofins = int(substring(item-doc-est.char-2,83,1))
                       piAliqCofins   = de-pc-cofins.
            &endif
        end.
        else
        do: 
            find first tt-imposto exclusive-lock no-error.
            if avail tt-imposto then
                assign piCdTribIPI    = tt-imposto.cd-trib-ipi
                       piCdTribICM    = tt-imposto.cd-trib-icm
                       piAliqIPI      = tt-imposto.aliquota-ipi
                       piAliqICM      = tt-imposto.aliquota-icm
                       pidePercIPI    = tt-imposto.perc-red-ipi
                       pidePercICM    = tt-imposto.perc-red-icm
                       piCdTribPis    = tt-imposto.cd-trib-pis
                       piAliqPis      = tt-imposto.aliquota-pis
                       piCdTribCofins = tt-imposto.cd-trib-cofins
                       piAliqCofins   = tt-imposto.aliquota-cofins.
        end.
    end.

    return "OK":U.
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
               recebe valor do campo nf-serie
               recebe valor do campo nf-nro
               recebe valor do campo nf-emitente
               recebe valor do campo nf-nat-oper
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pserie-docto LIKE rat-docum.serie-docto NO-UNDO.
    DEFINE INPUT PARAMETER pnro-docto LIKE rat-docum.nro-docto NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente LIKE rat-docum.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pnat-operacao LIKE rat-docum.nat-operacao NO-UNDO.
    DEFINE INPUT PARAMETER pnf-serie LIKE rat-docum.nf-serie NO-UNDO.
    DEFINE INPUT PARAMETER pnf-nro LIKE rat-docum.nf-nro NO-UNDO.
    DEFINE INPUT PARAMETER pnf-emitente LIKE rat-docum.nf-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pnf-nat-oper LIKE rat-docum.nf-nat-oper NO-UNDO.

    FIND FIRST bfrat-docum WHERE 
        bfrat-docum.serie-docto = pserie-docto AND 
        bfrat-docum.nro-docto = pnro-docto AND 
        bfrat-docum.cod-emitente = pcod-emitente AND 
        bfrat-docum.nat-operacao = pnat-operacao AND 
        bfrat-docum.nf-serie = pnf-serie AND 
        bfrat-docum.nf-nro = pnf-nro AND 
        bfrat-docum.nf-emitente = pnf-emitente AND 
        bfrat-docum.nf-nat-oper = pnf-nat-oper NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfrat-docum THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfrat-docum)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
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

    def input param piHandle as handle no-undo.
    
    run getKey in piHandle ( output i-cod-emitente,
                             output c-serie-docto,
                             output c-nro-docto,
                             output c-nat-operacao ).
                            
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

   open query qr{&tableName} 
       for each {&tableName}  no-lock
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

    open query qr{&tableName} 
        for each {&tableName}
            where {&tableName}.cod-emitente = i-cod-emitente  
              and {&tableName}.nro-docto    = c-nro-docto
              and {&tableName}.serie-docto  = c-serie-docto
              and {&tableName}.nat-operacao = c-nat-operacao no-lock
         indexed-reposition.
    
    return "OK":U.
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOfDocumEstNf DBOProgram 
PROCEDURE openQueryOfDocumEstNf :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    open query qr{&tableName} for each {&tableName} where
                                       {&tableName}.nf-emitente = i-cod-emitente and
                                       {&tableName}.nf-nro      = c-nro-docto    and
                                       {&tableName}.nf-serie    = c-serie-docto  and
                                       {&tableName}.nf-nat-oper = c-nat-operacao 
                                       no-lock indexed-reposition.
                                           
    return "OK":U.
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintMain DBOProgram 
PROCEDURE setConstraintMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    return "OK":U.
    
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDoacao DBOProgram 
PROCEDURE setDoacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM plDoacao  AS LOG  NO-UNDO.

    ASSIGN lDoacao = plDoacao.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setHandleItemDocumEst DBOProgram 
PROCEDURE setHandleItemDocumEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piboin176   as handle   no-undo.
    
    assign h-boin176 = piboin176.
 
    RETURN "OK":U.
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

    def input param piBOIN090   as handle   no-undo.
    
    assign h-boin090 = piBOIN090.
    
    run getKey in h-boin090 ( output i-cod-emitente,
                              output c-serie-docto,
                              output c-nro-docto,
                              output c-nat-operacao ).
                                    
    run findNaturOper ( c-nat-operacao ).

    run findEmitente ( i-cod-emitente,
                       ? ).
     
    run findDocumEst ( i-cod-emitente,
                       c-serie-docto,
                       c-nro-docto,
                       c-nat-operacao ).

    if  avail docum-est then do:
        run findEstabelec ( docum-est.cod-estabel ).

        run findParamOf ( docum-est.cod-estabel ).
    end.

    return "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setTTImposto DBOProgram 
PROCEDURE setTTImposto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM TABLE FOR tt-imposto.

    FIND FIRST tt-imposto NO-ERROR.
    IF NOT AVAIL tt-imposto then
        RETURN "NOK".  
    
    EMPTY TEMP-TABLE tt-imposto-aux NO-ERROR.
    BUFFER-COPY tt-imposto TO tt-imposto-aux NO-ERROR.
    FIND FIRST tt-imposto-aux NO-ERROR.
    
    RETURN "OK":U.
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

    def buffer bf-rat-docum   for rat-docum.

    /*--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as validaá‰es ---*/
    
    if  not avail ROWOBJECT then 
        return "NOK":U.
        
    /* VALIDA NOTA ORIGINAL */        
    run findDocumEst ( input RowObject.cod-emitente,
                       input RowObject.serie-docto,
                       input RowObject.nro-docto,
                       input RowObject.nat-operacao ).

    if  not avail docum-est then do:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-documento AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Documento" *}
        ASSIGN c-lbl-liter-documento = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lbl-liter-documento"}
    end.
    else do:
        if  docum-est.ce-atual then do:                            
            {method/svc/errors/inserr.i
                                &ErrorNumber="16599"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" }
        end.
    end.

    run findParamRe ( docum-est.usuario ).

    if  pType = "CREATE":U then do:        
    
        /* VALIDA NOTA INFORMADAS PARA RATEIO */
        run findDocumEst ( input RowObject.nf-emitente,
                           input RowObject.nf-serie,
                           input RowObject.nf-nro,
                           input RowObject.nf-nat-oper ).
                           
        if  not avail docum-est then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-nota-para-rateio AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Nota_para_Rateio" *}
            ASSIGN c-lbl-liter-nota-para-rateio = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                                &ErrorNumber="2"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" 
                                &ErrorParameters="c-lbl-liter-nota-para-rateio"}
        end.
        else do:                                
            if  RowObject.cod-emitente = RowObject.nf-emitente
            and RowObject.serie-docto  = RowObject.nf-serie
            and RowObject.nro-docto    = RowObject.nf-nro
            and RowObject.nat-operacao = RowObject.nf-nat-oper then do:
                {method/svc/errors/inserr.i
                                    &ErrorNumber="15158"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR" }
            end.

            if  not docum-est.ce-atual then do:
                {method/svc/errors/inserr.i
                                    &ErrorNumber="8216"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR" }
            end.                                    

            /* Logica baseada no in2106.p */
            FOR EACH item-doc-est OF docum-est NO-LOCK:
                IF item-doc-est.numero-ordem <> 0 THEN
                    FOR FIRST ordem-compra NO-LOCK
                        WHERE ordem-compra.numero-ordem = item-doc-est.numero-ordem,
                        FIRST plano-aprov NO-LOCK
                        WHERE plano-aprov.ep-codigo    = ordem-compra.ep-codigo
                          AND plano-aprov.cod-area     = 0
                          AND plano-aprov.num-ord-comp = ordem-compra.numero-ordem
                          AND plano-aprov.seq-comp     = 0,
                        FIRST ordem-inv NO-LOCK
                        WHERE ordem-inv.ep-codigo    = plano-aprov.ep-codigo
                          AND ordem-inv.cod-est-exec = plano-aprov.cod-est-exec
                          AND ordem-inv.num-projeto  = plano-aprov.num-projeto
                          AND ordem-inv.num-ordem    = plano-aprov.num-ordem:
                        IF ordem-inv.cod-situacao-inv = 3 THEN DO:
                            {method/svc/errors/inserr.i
                                    &ErrorNumber="26055"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"}
                        END.
                    END.
                ELSE
                    FOR EACH rat-ordem OF item-doc-est NO-LOCK,
                       FIRST ordem-compra NO-LOCK
                       WHERE ordem-compra.numero-ordem = rat-ordem.numero-ordem,
                       FIRST plano-aprov NO-LOCK
                       WHERE plano-aprov.ep-codigo    = ordem-compra.ep-codigo
                         AND plano-aprov.cod-area     = 0
                         AND plano-aprov.num-ord-comp = ordem-compra.numero-ordem
                         AND plano-aprov.seq-comp     = 0,
                       FIRST ordem-inv NO-LOCK
                       WHERE ordem-inv.ep-codigo    = plano-aprov.ep-codigo
                         AND ordem-inv.cod-est-exec = plano-aprov.cod-est-exec
                         AND ordem-inv.num-projeto  = plano-aprov.num-projeto
                         AND ordem-inv.num-ordem    = plano-aprov.num-ordem:
                        IF ordem-inv.cod-situacao-inv = 3 THEN DO:
                            {method/svc/errors/inserr.i
                                    &ErrorNumber="26055"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"}
                        END.
                    END.
            END.
        end.
        
        if  RowObject.dec-1 = 0 then do: /* Valor Mercadoria */
            {method/svc/errors/inserr.i
                                &ErrorNumber="15114"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" }
        end.                            
            
        if  can-find(bf-rat-docum
                     where bf-rat-docum.cod-emitente = RowObject.cod-emitente
                       and bf-rat-docum.serie-docto  = RowObject.serie-docto
                       and bf-rat-docum.nro-docto    = RowObject.nro-docto
                       and bf-rat-docum.nat-operacao = RowObject.nat-operacao
                       and bf-rat-docum.nf-emitente  = RowObject.nf-emitente
                       and bf-rat-docum.nf-serie     = RowObject.nf-serie
                       and bf-rat-docum.nf-nro       = RowObject.nf-nro
                       and bf-rat-docum.nf-nat-oper  = RowObject.nf-nat-oper ) then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-nota-de-rateio AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Nota_de_Rateio" *}
            ASSIGN c-lbl-liter-nota-de-rateio = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                                &ErrorNumber="7"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" 
                                &ErrorParameters="c-lbl-liter-nota-de-rateio"}
        end.
    end.            /* create */

    if  pType = "DELETE":U then do:
        if  not can-find(bf-rat-docum
                     where bf-rat-docum.cod-emitente = RowObject.cod-emitente
                       and bf-rat-docum.serie-docto  = RowObject.serie-docto
                       and bf-rat-docum.nro-docto    = RowObject.nro-docto
                       and bf-rat-docum.nat-operacao = RowObject.nat-operacao
                       and bf-rat-docum.nf-emitente  = RowObject.nf-emitente
                       and bf-rat-docum.nf-serie     = RowObject.nf-serie
                       and bf-rat-docum.nf-nro       = RowObject.nf-nro
                       and bf-rat-docum.nf-nat-oper  = RowObject.nf-nat-oper ) then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-nota-de-rateio-2 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Nota_de_Rateio" *}
            ASSIGN c-lbl-liter-nota-de-rateio-2 = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                                &ErrorNumber="2"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" 
                                &ErrorParameters="c-lbl-liter-nota-de-rateio-2"}
        end.
    end.
    
    /********* CHAMADA EPC PARA VALIDACOES ESPECIFICAS **********/
    
    /* testa se existe EPC relacionada ao programa */
    if c-nom-prog-dpc-mg97  <> "" or
       c-nom-prog-appc-mg97 <> "" or
       c-nom-prog-upc-mg97  <> "" then do:
    
        /* limpa os registros da temp-table da EPC */
        for each tt-epc where tt-epc.cod-event = "afterValidadeRecord":U.
            delete tt-epc.
        end.
    
        /* carrega a temp-table da EPC */ 
        {include/i-epc200.i2 &CodEvent       = "'afterValidadeRecord'"
                             &CodParameter   = "'object-handle'"
                             &ValueParameter = "string(this-procedure)"}

        /* executa EPC */
        {include/i-epc201.i "afterValidadeRecord"}                     

    end.
    /**************************************************************/
    
    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
    
END PROCEDURE.


PROCEDURE pi-engine-regras:

    DEFINE INPUT  PARAM p-empresa        LIKE param-global.empresa-prin    NO-UNDO.    
    DEFINE INPUT  PARAM p-it-codigo      AS CHARACTER                      NO-UNDO.
    DEFINE INPUT  PARAM p-nat-operacao   AS CHARACTER                      NO-UNDO.
    DEFINE INPUT  PARAM p-cod-estabel    AS CHARACTER                      NO-UNDO.
    DEFINE INPUT  PARAM p-cod-transp     AS INTEGER                        NO-UNDO.
    DEFINE INPUT  PARAM p-cod-fornec     AS INTEGER                        NO-UNDO.
    DEFINE INPUT  PARAM p-ct-codigo      AS CHARACTER                      NO-UNDO.
    DEFINE INPUT  PARAM p-sc-codigo      AS CHARACTER                      NO-UNDO.
    DEFINE INPUT  PARAM p-cod-cfop       AS CHARACTER                      NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR tt-retorno.
    
    /*Vari†veis da Engine de Regras*/    
    DEFINE VARIABLE c-var-ge-codigo AS CHAR NO-UNDO.
    DEFINE VARIABLE c-var-fm-codigo AS CHAR NO-UNDO.
    /*Vari†veis da Engine de Regras - FIM*/

    EMPTY TEMP-TABLE tt-variavel.
    EMPTY TEMP-TABLE tt-retorno.

    CREATE tt-variavel.
    ASSIGN tt-variavel.cod-var-oper = "it-codigo":U
           tt-variavel.cod-val-var  = TRIM(STRING(p-it-codigo)).

    CREATE tt-variavel.
    ASSIGN tt-variavel.cod-var-oper = "nat-operacao-nf":U
           tt-variavel.cod-val-var  = TRIM(STRING(p-nat-operacao)).
           
    CREATE tt-variavel.
    ASSIGN tt-variavel.cod-var-oper = "cod-estabel":U
           tt-variavel.cod-val-var  = TRIM(STRING(p-nat-operacao)).

    CREATE tt-variavel.
    ASSIGN tt-variavel.cod-var-oper = "cod-transp":U
           tt-variavel.cod-val-var  = TRIM(STRING(p-cod-transp)).
           
    CREATE tt-variavel.
    ASSIGN tt-variavel.cod-var-oper = "cod-fornec":U
           tt-variavel.cod-val-var  = TRIM(STRING(p-cod-fornec)).

    CREATE tt-variavel.
    ASSIGN tt-variavel.cod-var-oper = "ct-codigo":U
           tt-variavel.cod-val-var  = TRIM(STRING(p-ct-codigo)).

    CREATE tt-variavel.
    ASSIGN tt-variavel.cod-var-oper = "sc-codigo":U
           tt-variavel.cod-val-var  = TRIM(STRING(p-sc-codigo)).
           
    CREATE tt-variavel.
    ASSIGN tt-variavel.cod-var-oper = "cfop-nf":U
           tt-variavel.cod-val-var  = TRIM(STRING(p-cod-cfop)).

    IF VALID-HANDLE(h-boin172) THEN DO:
        RUN openQueryStatic IN h-boin172 (input "Main":U).
        run goToKey IN h-boin172 (input p-it-codigo).
        RUN getIntField  IN h-boin172 (INPUT "ge-codigo", OUTPUT c-var-ge-codigo).
        RUN getCharField IN h-boin172 (INPUT "fm-codigo", OUTPUT c-var-fm-codigo).
    END.
    
    CREATE tt-variavel.
    ASSIGN tt-variavel.cod-var-oper = "ge-codigo":U
           tt-variavel.cod-val-var  = TRIM(STRING(c-var-ge-codigo)). 
    
    CREATE tt-variavel.
    ASSIGN tt-variavel.cod-var-oper = "fm-codigo":U
           tt-variavel.cod-val-var  = TRIM(STRING(c-var-fm-codigo)).
           
     /*Verifica se a operacao item-doc-rateio est† cadastrada no CD0025*/
    FOR EACH config-operac NO-LOCK 
       WHERE config-operac.cdn-empresa    = i-empresa             
         AND config-operac.cod-estab      = docum-est.cod-estabel   
         AND (config-operac.cod-tip-operac = "NFRat-ItemConta":U OR 
              config-operac.cod-tip-operac = "NFRat-ItemNatOf":U OR 
              config-operac.cod-tip-operac = "NFRat-ApropDesp":U ):
              
        IF VALID-HANDLE(h-cdapi034) THEN                  
            RUN pi-inicializa IN h-cdapi034 (INPUT p-empresa,
                                             INPUT p-cod-estabel,
                                             INPUT config-operac.cod-tip-operac,
                                             INPUT TABLE tt-variavel,
                                             OUTPUT i-cod-regra-utilizada,
                                             OUTPUT TABLE tt-retorno APPEND,
                                             OUTPUT TABLE RowErrors APPEND).                            
    END.

    RETURN "OK":U.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sugereCClassTrib DBOProgram 
PROCEDURE sugereCClassTrib:
    
    DEF VAR cClassTrib     LIKE relac-class-trib.cod-cclass-trib     NO-UNDO.
    DEF VAR cCst           LIKE relac-class-trib.cod-cst             NO-UNDO.    
    DEF VAR cClassTribReg  LIKE relac-class-trib.cod-cclass-trib-reg NO-UNDO.
    DEF VAR cCstReg        LIKE relac-class-trib.cod-cst-reg         NO-UNDO.
    DEF VAR cCredPresCBS   LIKE relac-class-trib.cod-cred-pres       NO-UNDO.
    DEF VAR cCredPresIBS   LIKE relac-class-trib.cod-cred-pres       NO-UNDO.
    
    
    DEF BUFFER b-natur-oper-fisc FOR natur-oper. 
    DEF BUFFER b-item FOR item. 
    
    FIND FIRST b-natur-oper-fisc NO-LOCK
         WHERE b-natur-oper-fisc.nat-operacao = item-doc-est.nat-of NO-ERROR.
    
    FIND FIRST b-item NO-LOCK WHERE b-item.it-codigo =  SUBSTRING(docum-est.char-1,176,16) NO-ERROR.
    IF CAN-FIND (FIRST funcao no-lock 
                 WHERE funcao.cd-funcao = "spp-NT2024002"
                   AND funcao.ativo     = YES) THEN DO:
        
        RUN emptyTtRelacClassTrib IN h-reapi433. 
        RUN setTipoDocto          IN h-reapi433 (INPUT 1). /*Entrada*/
        RUN setDtIniValidade      IN h-reapi433 (INPUT docum-est.dt-emissao).
        RUN setCodEstabel         IN h-reapi433 (INPUT docum-est.cod-estabel).
        RUN setNatOperacao        IN h-reapi433 (INPUT item-doc-est.nat-of).
        RUN setItCodigo           IN h-reapi433 (INPUT SUBSTRING(docum-est.char-1,176,16)).
        RUN setClassifFiscal      IN h-reapi433 (INPUT b-item.class-fiscal).
       
        IF  substring(b-item.char-1,342,20) <> ? 
        AND substring(b-item.char-1,342,20) <> '' 
        AND AVAIL b-natur-oper-fisc
        AND (b-natur-oper-fisc.cod-model-nf-eletro = "56" OR b-natur-oper-fisc.log-nfse-nacional) THEN
            RUN setCodNbs             IN h-reapi433 (INPUT substring(b-item.char-1,342,20)).             
        ELSE 
            RUN setCodNbs             IN h-reapi433 (INPUT '*').
            
        RUN setCodGrupEmit        IN h-reapi433 (INPUT emitente.cod-gr-forn).
        RUN setCodEmitente        IN h-reapi433 (INPUT item-doc-est.cod-emitente).
        RUN setCFOP               IN h-reapi433 (INPUT b-natur-oper-fisc.cod-cfop).
        RUN setIndTributo         IN h-reapi433 (INPUT 1). /*1-IBS/CBS*/
        RUN buscarRelacClassTrib  IN h-reapi433. 
          
        /*Retorna os dados do cClassTrib, CST, cClassTrib regular e CST regular*/
        RUN getCSTcClassTribAndReg   IN h-reapi433 (OUTPUT cClassTrib,
                                                    OUTPUT cCst,
                                                    OUTPUT cClassTribReg,
                                                    OUTPUT cCstReg). 
                                                 
        RUN createTtItemDocEstTribut (INPUT rep.imp.Imposto:CBS,     INPUT AtributoImposto:C-CLASS-TRIB,     INPUT STRING(cClassTrib)).
        RUN createTtItemDocEstTribut (INPUT rep.imp.Imposto:CBS,     INPUT AtributoImposto:CST,              INPUT STRING(cCST)).
        RUN createTtItemDocEstTribut (INPUT rep.imp.Imposto:CBS,     INPUT AtributoImposto:C-CLASS-TRIB-REG, INPUT STRING(cClassTribReg)).
        RUN createTtItemDocEstTribut (INPUT rep.imp.Imposto:CBS,     INPUT AtributoImposto:CST-REG,          INPUT STRING(cCstReg)).
        
        RUN createTtItemDocEstTribut (INPUT rep.imp.Imposto:IBS-UF,  INPUT AtributoImposto:C-CLASS-TRIB, INPUT STRING(cClassTrib)).
        RUN createTtItemDocEstTribut (INPUT rep.imp.Imposto:IBS-UF,  INPUT AtributoImposto:CST,          INPUT STRING(cCST)).
        RUN createTtItemDocEstTribut (INPUT rep.imp.Imposto:IBS-UF,  INPUT AtributoImposto:C-CLASS-TRIB-REG, INPUT STRING(cClassTribReg)).
        RUN createTtItemDocEstTribut (INPUT rep.imp.Imposto:IBS-UF,  INPUT AtributoImposto:CST-REG,          INPUT STRING(cCstReg)).
        
        RUN createTtItemDocEstTribut (INPUT rep.imp.Imposto:IBS-MUN, INPUT AtributoImposto:C-CLASS-TRIB, INPUT STRING(cClassTrib)).
        RUN createTtItemDocEstTribut (INPUT rep.imp.Imposto:IBS-MUN, INPUT AtributoImposto:CST,          INPUT STRING(cCST)).       
        RUN createTtItemDocEstTribut (INPUT rep.imp.Imposto:IBS-MUN, INPUT AtributoImposto:C-CLASS-TRIB-REG, INPUT STRING(cClassTribReg)).
        RUN createTtItemDocEstTribut (INPUT rep.imp.Imposto:IBS-MUN, INPUT AtributoImposto:CST-REG,          INPUT STRING(cCstReg)).
         
        IF SUBSTRING(docum-est.cod-chave-aces-nf-eletro,21,2) = '55' 
        OR SUBSTRING(docum-est.cod-chave-aces-nf-eletro,21,2) = '56' THEN DO:
           RUN getcCredPres  IN h-reapi433 (OUTPUT cCredPresCBS,
                                            OUTPUT cCredPresIBS).    
           RUN createTtItemDocEstTribut (INPUT rep.imp.Imposto:CBS,     INPUT AtributoImposto:C-CLASS-CP,       INPUT STRING(cCredPresCBS)).
           RUN createTtItemDocEstTribut (INPUT rep.imp.Imposto:IBS-UF,  INPUT AtributoImposto:C-CLASS-CP,       INPUT STRING(cCredPresIBS)).
        END.
        
                                                   
    END.

END PROCEDURE.  
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setAliqIBSCbs DBOProgram 
PROCEDURE setAliqIBSCbs:
    DEFINE INPUT PARAM pAliqCbs    AS DECIMAL FORMAT ">9.9999" NO-UNDO.
    DEFINE INPUT PARAM pAliqIbsUf  AS DECIMAL FORMAT ">9.9999" NO-UNDO.
    DEFINE INPUT PARAM pAliqIbsMun AS DECIMAL FORMAT ">9.9999" NO-UNDO.
    
    run findDocumEst ( i-cod-emitente,
                       c-serie-docto,
                       c-nro-docto,
                       c-nat-operacao ).

    if  not avail docum-est THEN 
        RETURN "OK":U.
        
    IF docum-est.cod-tipo-ente-gov = 0 THEN DO:
       RUN createTtItemDocEstTributAux (INPUT rep.imp.Imposto:CBS,     INPUT AtributoImposto:ALIQUOTA,   INPUT STRING(pAliqCbs)). 
       RUN createTtItemDocEstTributAux (INPUT rep.imp.Imposto:IBS-UF,  INPUT AtributoImposto:ALIQUOTA,   INPUT STRING(pAliqIbsUf)).
       RUN createTtItemDocEstTributAux (INPUT rep.imp.Imposto:IBS-MUN, INPUT AtributoImposto:ALIQUOTA,   INPUT STRING(pAliqIbsMun)).     
    END.
    ELSE DO:
        RUN createTtItemDocEstTributAux (INPUT rep.imp.Imposto:CBS,     INPUT AtributoImposto:ALIQ-GOV,   INPUT STRING(pAliqCbs)). 
        RUN createTtItemDocEstTributAux (INPUT rep.imp.Imposto:IBS-UF,  INPUT AtributoImposto:ALIQ-GOV,   INPUT STRING(pAliqIbsUf)).
        RUN createTtItemDocEstTributAux (INPUT rep.imp.Imposto:IBS-MUN, INPUT AtributoImposto:ALIQ-GOV,   INPUT STRING(pAliqIbsMun)).     
        
    END.
    
    RETURN "OK":U.
END PROCEDURE.  
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME        */
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getAliqIBSCbs DBOProgram 
PROCEDURE getAliqIBSCbs:
    DEFINE INPUT  PARAM pitemRateio LIKE ITEM.it-codigo         NO-UNDO.
    DEFINE OUTPUT PARAM pAliqCbs    AS DECIMAL FORMAT ">9.9999" NO-UNDO.
    DEFINE OUTPUT PARAM pAliqIbsUf  AS DECIMAL FORMAT ">9.9999" NO-UNDO.
    DEFINE OUTPUT PARAM pAliqIbsMun AS DECIMAL FORMAT ">9.9999" NO-UNDO.
    
    DEF VAR h-cdapi1005        AS HANDLE                             NO-UNDO.
    DEF VAR dAliq              LIKE relacto-tributo.aliquota         NO-UNDO.
    DEF VAR dPercDifer         LIKE relacto-tributo.perc-diferido    NO-UNDO.
    DEF VAR dPercRed           LIKE relacto-tributo.perc-red         NO-UNDO.
    DEF VAR dPercCredPresum    LIKE relacto-tributo.perc-cred-presum NO-UNDO.
    DEF VAR dAliqDeson         LIKE relacto-tributo.aliquota         NO-UNDO. 
    DEF VAR dPercRedAliqGov    AS   DECIMAL                          NO-UNDO.   

    DEF BUFFER b-natur-oper-fisc FOR natur-oper. 
    DEF BUFFER b-item            FOR item. 
              
    /***Aliquotas CBS, IBS UF e IBS Mun*********************************/
    IF  CAN-FIND (FIRST funcao no-lock 
                  WHERE funcao.cd-funcao = "spp-NT2024002"
                AND funcao.ativo     = YES) THEN DO:
                
        FIND FIRST b-natur-oper-fisc NO-LOCK
             WHERE b-natur-oper-fisc.nat-operacao = docum-est.nat-operacao NO-ERROR.
        
        FIND FIRST b-item NO-LOCK 
             WHERE b-item.it-codigo = pitemRateio NO-ERROR.

        RUN emptyTtItemDocEstTributAux.
        
        IF NOT VALID-HANDLE(h-cdapi1005) THEN
            RUN cdp/cdapi1005.p PERSISTENT SET h-cdapi1005.    
        
        RUN emptyTtRelactoTributo IN h-cdapi1005. 
        RUN setDados              IN h-cdapi1005 (INPUT 1, /*Entrada*/
                                                  INPUT docum-est.dt-emissao,
                                                  INPUT docum-est.cod-estabel,
                                                  INPUT docum-est.nat-operacao,
                                                  INPUT pitemRateio,
                                                  INPUT b-item.class-fiscal,
                                                  INPUT emitente.cod-gr-forn,
                                                  INPUT docum-est.cod-emitente,
                                                  INPUT b-natur-oper-fisc.cod-cfop,
                                                  INPUT b-item.cod-servico,
                                                  INPUT estabelec.cidade,  /*cidade*/
                                                  INPUT estabelec.estado). /*UF*/
                                                  

        IF  substring(b-item.char-1,342,20) <> ? 
        AND substring(b-item.char-1,342,20) <> '' 
        AND AVAIL b-natur-oper-fisc
        AND (b-natur-oper-fisc.cod-model-nf-eletro = "56" OR b-natur-oper-fisc.log-nfse-nacional) THEN
            RUN setNbs IN h-cdapi1005 (INPUT substring(b-item.char-1,342,20)).             
        ELSE 
            RUN setNbs IN h-cdapi1005 (INPUT '*').
        
        RUN gerattcombinacao IN h-cdapi1005.

       ASSIGN dAliq           = 0
              dPercDifer      = 0
              dPercRed        = 0
              dPercCredPresum = 0
              dAliqDeson      = 0
              dPercRedAliqGov = 0.

        
        RUN emptyTtRelactoTributo IN h-cdapi1005. 
        RUN setIndTributo         IN h-cdapi1005 (INPUT 1). /*CBS*/ 
        RUN buscarRelactotributo  IN h-cdapi1005.           
        RUN getTributo            IN h-cdapi1005 (OUTPUT dAliq,
                                                  OUTPUT dPercDifer,
                                                  OUTPUT dPercRed,
                                                  OUTPUT dPercCredPresum,
                                                  OUTPUT dAliqDeson,
                                                  OUTPUT dPercRedAliqGov).  
                                                                                                    
        ASSIGN pAliqCbs = dAliq.
        
        RUN createTtItemDocEstTributAux (INPUT rep.imp.Imposto:CBS, INPUT AtributoImposto:ALIQUOTA,     INPUT STRING(dAliq)).
        RUN createTtItemDocEstTributAux (INPUT rep.imp.Imposto:CBS, INPUT AtributoImposto:PERC-DIFER,   INPUT STRING(dPercDifer)).
        RUN createTtItemDocEstTributAux (INPUT rep.imp.Imposto:CBS, INPUT AtributoImposto:ALIQ-RED,     INPUT STRING(dPercRed)).
        RUN createTtItemDocEstTributAux (INPUT rep.imp.Imposto:CBS, INPUT AtributoImposto:PERC-RED-GOV, INPUT STRING(dPercRedAliqGov)).  
        
        IF docum-est.cod-tipo-ente-gov > 0 THEN
            RUN createTtItemDocEstTributAux (INPUT rep.imp.Imposto:CBS, INPUT AtributoImposto:ALIQ-GOV,  INPUT STRING(dAliq)).

        
        IF SUBSTRING(docum-est.cod-chave-aces-nf-eletro,21,2) = '55' 
        OR SUBSTRING(docum-est.cod-chave-aces-nf-eletro,21,2) = '56' THEN
           RUN createTtItemDocEstTributAux (INPUT rep.imp.Imposto:CBS, INPUT AtributoImposto:PERC-CP,   INPUT STRING(dPercCredPresum)). 
        
        /*Al°quota efetiva ALC/ZFM (cadastro de al°quotas dos tributos) - apenas CBS*/
        EMPTY TEMP-TABLE tt-relacto-tributo.
        RUN getTtRelactoTributo IN h-cdapi1005 (OUTPUT TABLE tt-relacto-tributo).
        FOR FIRST tt-relacto-tributo:
            RUN createTtItemDocEstTributAux (INPUT rep.imp.Imposto:CBS, INPUT AtributoImposto:ALIQ-EFETIVA-ALCZFM, INPUT STRING(tt-relacto-tributo.perc-efet-alczfm)).
        END.
        
        ASSIGN dAliq           = 0
               dPercDifer      = 0
               dPercRed        = 0
               dPercCredPresum = 0
               dAliqDeson      = 0
               dPercRedAliqGov = 0.
     
        RUN emptyTtRelactoTributo IN h-cdapi1005. 
        RUN setIndTributo         IN h-cdapi1005 (INPUT 2). /*IBS UF*/ 
        RUN buscarRelactotributo  IN h-cdapi1005.           
        RUN getTributo            IN h-cdapi1005 (OUTPUT dAliq,
                                                  OUTPUT dPercDifer,
                                                  OUTPUT dPercRed,
                                                  OUTPUT dPercCredPresum,
                                                  OUTPUT dAliqDeson,
                                                  OUTPUT dPercRedAliqGov ).         
        
        ASSIGN pAliqIbsUf = dAliq.
        RUN createTtItemDocEstTributAux (INPUT rep.imp.Imposto:IBS-UF, INPUT AtributoImposto:ALIQUOTA,     INPUT STRING(dAliq)).
        RUN createTtItemDocEstTributAux (INPUT rep.imp.Imposto:IBS-UF, INPUT AtributoImposto:PERC-DIFER,   INPUT STRING(dPercDifer)).
        RUN createTtItemDocEstTributAux (INPUT rep.imp.Imposto:IBS-UF, INPUT AtributoImposto:ALIQ-RED,     INPUT STRING(dPercRed)).
        RUN createTtItemDocEstTributAux (INPUT rep.imp.Imposto:IBS-UF, INPUT AtributoImposto:PERC-RED-GOV, INPUT STRING(dPercRedAliqGov)).

        IF docum-est.cod-tipo-ente-gov > 0 THEN
            RUN createTtItemDocEstTributAux (INPUT rep.imp.Imposto:IBS-UF, INPUT AtributoImposto:ALIQ-GOV,  INPUT STRING(dAliq)).
        
        IF SUBSTRING(docum-est.cod-chave-aces-nf-eletro,21,2) = '55' 
        OR SUBSTRING(docum-est.cod-chave-aces-nf-eletro,21,2) = '56' THEN
           RUN createTtItemDocEstTributAux (INPUT rep.imp.Imposto:IBS-UF, INPUT AtributoImposto:PERC-CP,    INPUT STRING(dPercCredPresum)).   
      
                                     
        ASSIGN dAliq           = 0
               dPercDifer      = 0
               dPercRed        = 0
               dPercCredPresum = 0
               dAliqDeson      = 0
               dPercRedAliqGov = 0.
                   
        RUN emptyTtRelactoTributo IN h-cdapi1005.             
        RUN setIndTributo         IN h-cdapi1005 (INPUT 3). /*IBS MUN*/ 
        RUN buscarRelactotributo  IN h-cdapi1005.           
        RUN getTributo            IN h-cdapi1005 (OUTPUT dAliq,
                                                  OUTPUT dPercDifer,
                                                  OUTPUT dPercRed,
                                                  OUTPUT dPercCredPresum,
                                                  OUTPUT dAliqDeson,
                                                  OUTPUT dPercRedAliqGov).         
        
        ASSIGN pAliqIbsMun = dAliq.
        
        RUN createTtItemDocEstTributAux (INPUT rep.imp.Imposto:IBS-MUN, INPUT AtributoImposto:ALIQUOTA,   INPUT STRING(dAliq)).
        RUN createTtItemDocEstTributAux (INPUT rep.imp.Imposto:IBS-MUN, INPUT AtributoImposto:PERC-DIFER, INPUT STRING(dPercDifer)).
        RUN createTtItemDocEstTributAux (INPUT rep.imp.Imposto:IBS-MUN, INPUT AtributoImposto:ALIQ-RED,   INPUT STRING(dPercRed)).  
        RUN createTtItemDocEstTributAux (INPUT rep.imp.Imposto:IBS-MUN, INPUT AtributoImposto:PERC-RED-GOV, INPUT STRING(dPercRedAliqGov)).

        IF docum-est.cod-tipo-ente-gov > 0 THEN
           RUN createTtItemDocEstTributAux (INPUT rep.imp.Imposto:IBS-MUN, INPUT AtributoImposto:ALIQ-GOV,  INPUT STRING(dAliq)).

        
    END.
    /*******************************************************************/
    RETURN "OK":U.
    FINALLY:
        DELETE PROCEDURE h-cdapi1005.
        ASSIGN h-cdapi1005 = ?.
    END FINALLY.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE emptyTtItemDocEstTributAux DBOProgram 
PROCEDURE emptyTtItemDocEstTributAux:
    EMPTY TEMP-TABLE tt-item-doc-est-tribut-aux.
   
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME 
                                                              
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createTtItemDocEstTributAux DBOProgram 
PROCEDURE createTtItemDocEstTributAux:
    DEFINE INPUT PARAMETER pNomTribut AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER pCodCampo  AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER pconteudo  AS CHARACTER   NO-UNDO.
      
    FIND FIRST tt-item-doc-est-tribut-aux EXCLUSIVE-LOCK
         WHERE tt-item-doc-est-tribut-aux.cod-serie-docto   = c-serie-docto
           AND tt-item-doc-est-tribut-aux.cod-num-docto     = c-nro-docto
           AND tt-item-doc-est-tribut-aux.cdn-emitente      = i-cod-emitente
           AND tt-item-doc-est-tribut-aux.cod-natur-operac  = c-nat-operacao
           AND tt-item-doc-est-tribut-aux.nom-trib          = pNomTribut
           AND tt-item-doc-est-tribut-aux.cod-campo         = pCodCampo NO-ERROR.
           
    IF NOT AVAIL tt-item-doc-est-tribut-aux THEN DO:
       CREATE tt-item-doc-est-tribut-aux.
       ASSIGN tt-item-doc-est-tribut-aux.cod-serie-docto   = c-serie-docto
              tt-item-doc-est-tribut-aux.cod-num-docto     = c-nro-docto
              tt-item-doc-est-tribut-aux.cdn-emitente      = i-cod-emitente
              tt-item-doc-est-tribut-aux.cod-natur-operac  = c-nat-operacao
              tt-item-doc-est-tribut-aux.nom-trib          = pNomTribut
              tt-item-doc-est-tribut-aux.cod-campo         = pCodCampo. 
    END.
    
    ASSIGN tt-item-doc-est-tribut-aux.cod-conteudo      = pconteudo.    
     
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME   

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE efetivaAliqIBSCbs DBOProgram 
PROCEDURE efetivaAliqIBSCbs:

     FOR EACH tt-item-doc-est-tribut-aux
        WHERE tt-item-doc-est-tribut-aux.cod-serie-docto   = item-doc-est.serie-docto 
          AND tt-item-doc-est-tribut-aux.cod-num-docto     = item-doc-est.nro-docto
          AND tt-item-doc-est-tribut-aux.cdn-emitente      = item-doc-est.cod-emitente
          AND tt-item-doc-est-tribut-aux.cod-natur-operac  = item-doc-est.nat-operacao:
          RUN createTtItemDocEstTribut  (INPUT tt-item-doc-est-tribut-aux.nom-trib  , INPUT tt-item-doc-est-tribut-aux.cod-campo,   INPUT tt-item-doc-est-tribut-aux.cod-conteudo).
    END.

    /*Processo Suframa - sugest∆o baseada no cadastro do item da nota*/
    FIND FIRST reg-inf-compl NO-LOCK
        WHERE reg-inf-compl.cod-tab-inform   = "item-dist":U
          AND reg-inf-compl.cod-campo-inform = "c-Proc-Suframa":U NO-ERROR.
    IF AVAIL reg-inf-compl THEN DO:
        FIND FIRST inf-compl NO-LOCK
            WHERE inf-compl.cdn-identif = reg-inf-compl.cdn-identif
              AND inf-compl.num-campo   = 0
              AND inf-compl.cod-indice  = item-doc-est.it-codigo NO-ERROR.
        IF AVAIL inf-compl AND inf-compl.des-campo <> "" THEN
            RUN createTtItemDocEstTribut (INPUT rep.imp.Imposto:CBS, INPUT AtributoImposto:PROCESSO-SUFRAMA, INPUT inf-compl.des-campo).
    END.
   
    RETURN "OK":U.
END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createTtItemDocEstTribut DBOProgram 
PROCEDURE createTtItemDocEstTribut:
    DEFINE INPUT PARAMETER pNomTribut AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER pCodCampo  AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER pconteudo  AS CHARACTER   NO-UNDO.

    EMPTY TEMP-TABLE tt-item-doc-est-tribut.
   
    CREATE tt-item-doc-est-tribut.
    ASSIGN tt-item-doc-est-tribut.cod-serie-docto   = item-doc-est.serie-docto 
           tt-item-doc-est-tribut.cod-num-docto     = item-doc-est.nro-docto
           tt-item-doc-est-tribut.cdn-emitente      = item-doc-est.cod-emitente
           tt-item-doc-est-tribut.cod-natur-operac  = item-doc-est.nat-operacao
           tt-item-doc-est-tribut.num-seq           = item-doc-est.sequencia   
           tt-item-doc-est-tribut.nom-trib          = pNomTribut
           tt-item-doc-est-tribut.cod-campo         = pCodCampo
           tt-item-doc-est-tribut.cod-conteudo      = pconteudo.    
           
    RUN setConstraintOfDocumEst IN h-boin01091 (INPUT item-doc-est.serie-docto,     
                                                INPUT item-doc-est.nro-docto,      
                                                INPUT item-doc-est.cod-emitente,    
                                                INPUT item-doc-est.nat-operacao).      
    RUN openQueryStatic in h-boin01091 (INPUT "OfDocumEst":U).
        
    RUN goToKey IN h-boin01091 (INPUT tt-item-doc-est-tribut.cod-serie-docto,
                                INPUT tt-item-doc-est-tribut.cod-num-docto,    
                                INPUT tt-item-doc-est-tribut.cdn-emitente,     
                                INPUT tt-item-doc-est-tribut.cod-natur-operac,
                                INPUT tt-item-doc-est-tribut.num-seq,
                                INPUT tt-item-doc-est-tribut.nom-trib,         
                                INPUT tt-item-doc-est-tribut.cod-campo).
    IF  RETURN-VALUE = "OK":U THEN DO:
        RUN emptyRowErrors IN h-boin01091.
        RUN setRecord      IN h-boin01091 (INPUT TABLE tt-item-doc-est-tribut).
        RUN updateRecord   IN h-boin01091.  
    END.    
    ELSE DO:
        RUN emptyRowErrors IN h-boin01091.
        RUN setRecord      IN h-boin01091 (INPUT TABLE tt-item-doc-est-tribut).
        RUN createRecord   IN h-boin01091.
    END.

    IF VALID-HANDLE(h-boin176) THEN DO:
       RUN createTtItemDocEstTribut IN h-boin176 (INPUT tt-item-doc-est-tribut.nom-trib, 
	                                              INPUT tt-item-doc-est-tribut.cod-campo,
												  INPUT tt-item-doc-est-tribut.cod-conteudo).
    END.
    
    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
