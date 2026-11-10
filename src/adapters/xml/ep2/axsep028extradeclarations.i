{adapters/xml/ep2/axsep017extradeclarations.i}


DEFINE VARIABLE lcXMLNFCom      AS LONGCHAR NO-UNDO.
DEFINE VARIABLE lObtemXMLNFCom  AS LOGICAL  NO-UNDO.

DEFINE TEMP-TABLE ttNFComTSS NO-UNDO
    FIELD ID   AS CHAR
    FIELD MAIL AS CHAR
    FIELD XML  AS CLOB.
    
DEFINE TEMP-TABLE ttNFComTSSRet NO-UNDO
    FIELD k    AS ROWID
    FIELD STR  AS CHAR LABEL "STRING".  
    
DEFINE TEMP-TABLE tt-rateio-vOutro-NFCom NO-UNDO
    FIELD nr-seq-fat LIKE it-nota-fisc.nr-seq-fat
    FIELD it-codigo  LIKE it-nota-fisc.it-codigo
    FIELD percentual AS DEC
    FIELD valor      AS DEC.    
    
DEFINE VARIABLE d-total-vl-desc-icms            AS DECIMAL                NO-UNDO.
DEFINE VARIABLE d-total-vFCP                    AS DECIMAL                NO-UNDO.
DEFINE VARIABLE d-total-vProd                   AS DECIMAL                NO-UNDO.
DEFINE VARIABLE d-total-vFUST                   AS DECIMAL                NO-UNDO.
DEFINE VARIABLE d-total-vFUNTTEL                AS DECIMAL                NO-UNDO.
DEFINE VARIABLE d-desconto-total                AS DECIMAL                NO-UNDO.
DEFINE VARIABLE l-CSRT                          AS LOGICAL INITIAL NO     NO-UNDO.
DEFINE VARIABLE l-prod-rural                    AS LOGICAL                NO-UNDO.                           

// Reforma Tribut ria
DEFINE VARIABLE d-total-vIS                     AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE d-total-vBCIBSCBS               AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE d-total-vDifIBSUF               AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE d-total-vDevTribIBSUF           AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE d-total-vIBSUF                  AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE d-total-vDifIBSMun              AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE d-total-vDevTribIBSMun          AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE d-total-vIBSMun                 AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE d-total-vIBS                    AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE d-total-transf-cred-vCBS        AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE d-total-transf-cred-vIBS        AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE d-total-vCredPresIBS            AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE d-total-vCredPresCondSusIBS     AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE d-total-vCredPresCBS            AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE d-total-vCredPresCondSusCBS     AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE d-total-vDifCBS                 AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE d-total-vDevTribCBS             AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE d-total-vCBS                    AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE d-total-vIBSMono                AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE d-total-vCBSMono                AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE d-total-vIBSMonoReten           AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE d-total-vCBSMonoReten           AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE d-total-vIBSMonoRet             AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE d-total-vCBSMonoRet             AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE d-total-vIBSEstCred             AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE d-total-vCBSEstCred             AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE d-total-vItem                   AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE d-total-vNFTot                  AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE d-aliq-efet-reg-ibs-uf          AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE d-trib-reg-ibs-uf               AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE d-aliq-efet-reg-ibs-mun         AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE d-trib-reg-ibs-mun              AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE d-aliq-efet-reg-cbs             AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE d-trib-reg-cbs                  AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE l-transf-cred                   AS LOGICAL INITIAL NO                    NO-UNDO.
DEFINE VARIABLE l-imunidade                     AS LOGICAL INITIAL NO                    NO-UNDO.
DEFINE VARIABLE l-monofasico                    AS LOGICAL INITIAL NO                    NO-UNDO.
DEFINE VARIABLE c-ibsCbs                        AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE c-cst-reg                       AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE c-class-trib-reg                AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE l-ajust-compet                  AS LOGICAL INITIAL NO                    NO-UNDO.
DEFINE VARIABLE l-estorno-cred                  AS LOGICAL INITIAL NO                    NO-UNDO.
DEFINE VARIABLE d-total-nf-deb-cred-vCBS        AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE d-total-nf-deb-cred-vIBS        AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE d-total-dfe                     AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE l-DeduzCredPres-ibs-uf          AS LOGICAL                               NO-UNDO.
DEFINE VARIABLE d-perc-red-aliq                 AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE l-gEstornoCred                  AS LOGICAL                               NO-UNDO.

DEF VAR l-NT2024002 AS LOGICAL INITIAL NO NO-UNDO.
ASSIGN  l-NT2024002 = CAN-FIND(FIRST funcao NO-LOCK
                               WHERE funcao.cd-funcao = "spp-NT2024002":U
                                 AND funcao.ativo ). 
                                 
DEF VAR l-mono-rt AS LOGICAL INITIAL NO NO-UNDO.
ASSIGN  l-mono-rt = CAN-FIND(FIRST funcao NO-LOCK
                               WHERE funcao.cd-funcao = "spp-mono-rt":U
                                 AND funcao.ativo ).                                     


FUNCTION fn-ajusta-campo-IE RETURNS CHAR (INPUT cCampo AS CHAR).

    /*Campos de Inscri‡Æo Estadual n£meros - Ocorrencia 2-14*/

    DEFINE VARIABLE cCampoAjustado AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE iCont          AS INTEGER     NO-UNDO.

    DO  iCont = 1 TO LENGTH(cCampo):
        IF  CAN-DO("0,1,2,3,4,5,6,7,8,9":U,SUBSTRING(cCampo,iCont,1)) THEN
            ASSIGN cCampoAjustado = cCampoAjustado + SUBSTRING(cCampo,iCont,1) NO-ERROR.
    END.
    /*IF  cCampoAjustado <> "":U THEN
        ASSIGN cCampoAjustado = TRIM(STRING(DEC(cCampoAjustado),">>>>>>>>>>>>99")) NO-ERROR. /*tamanho 14 - retirar zeros nao significativos*/*/

    IF  (cCampo = "ISENTO":U OR cCampo = "ISENTA":U) THEN
        ASSIGN cCampoAjustado = cCampo.

    RETURN TRIM(cCampoAjustado).

END FUNCTION.

FUNCTION fn-UN-busca-sigla RETURNS CHAR (INPUT cUN AS CHAR).

    DEFINE VARIABLE cUNSigla AS CHARACTER   NO-UNDO.

    ASSIGN cUNSigla = cUN.

    FOR FIRST tab-unidade NO-LOCK
        WHERE tab-unidade.un = cUN:

        IF  TRIM(SUBSTRING(tab-unidade.char-2,1,10)) <> "":U THEN
            ASSIGN cUNSigla = TRIM(SUBSTRING(tab-unidade.char-2,1,10)).
    END.

    RETURN TRIM(cUNSigla).

END FUNCTION.


FUNCTION fn-retorna-codigo-cidade RETURNS CHARACTER (INPUT c-cidade AS CHAR, INPUT c-estado AS CHAR, INPUT c-pais AS CHAR).

    DEFINE VARIABLE c-codigo-cidade AS CHARACTER NO-UNDO.

    DEFINE BUFFER bf-cidade FOR cidade.

    FOR FIRST bf-cidade NO-LOCK
        WHERE bf-cidade.cidade = TRIM(c-cidade)
          AND bf-cidade.estado = TRIM(c-estado)
          AND bf-cidade.pais   = TRIM(c-pais):

        IF  bf-cidade.pais = "Brasil" THEN
            ASSIGN c-codigo-cidade = STRING(bf-cidade.cdn-munpio-ibge).
        ELSE
            ASSIGN c-codigo-cidade = "9999999".
    END.
    IF  NOT AVAIL bf-cidade THEN
        ASSIGN c-codigo-cidade = "0".

    IF  TRIM(c-pais) <> "Brasil" THEN
        ASSIGN c-codigo-cidade = "9999999".

    RETURN c-codigo-cidade.
	
END FUNCTION.


