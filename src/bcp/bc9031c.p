/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9031C 2.00.00.002} /*** "010002" 27/08/2024 08:50:25 ***/

/**********************************************************************************
**     Programa...: bc9031c.p
**
**     Finalidade.: Pre-api de Reporte por Ordem, Por Opera‡Æo, Por Ponto Controle
**
**     Criado em..: Marco/2006
**
**     Versao.....: 1.00.00.000 
**********************************************************************************/

/*********************************************************************************/
{bcp/bc9102.i}   /* Definicao da temp-table de erros do coleta de dados          */
{bcp/bc9107.i}   /* Campos de comunicacao com o adapter                          */
/*********************************************************************************/

/*********************************************************************************/
DEFINE INPUT  PARAMETER pNumTrans    AS INTEGER    NO-UNDO.
DEFINE INPUT  PARAMETER pRawConteudo AS RAW        NO-UNDO.

DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-erro.
/*********************************************************************************/

/*********************************************************************************/
DEFINE VARIABLE cNeededFields AS CHARACTER  NO-UNDO
    EXTENT 31
    INITIAL ["tipo-rep":U,
    	     "nr-ord-produ":U,
    	     "num-operac-sfc":U,
    	     "num-split-operac":U,
    	     "cod-roteiro":U,
    	     "op-codigo":U,
    	     "cod-ctrab":U,
    	     "it-codigo":U,
    	     "cod-refer":U,
    	     "lote-serie":U,
    	     "dat-valid-lote":U,
    	     "qtd-produzida":U,
    	     "cod-motiv-refugo":U,
    	     "qtd-refugada":U,
    	     "qtd-retrabalho":U,
    	     "ct-refugo":U,
             "sc-refugo":U,
    	     "dat-inic-rep":U,
    	     "hr-inic-rep":U,
    	     "dat-fim-rep":U,
    	     "hr-fim-rep":U,
    	     "dat-inic-setup":U,
    	     "hr-inic-setup":U,
    	     "dat-fim-setup":U,
    	     "hr-fim-setup":U,
    	     "cod-equipe":U,
    	     "cod-operador":U,
    	     "cod-ferramenta":U,
    	     "finaliza":U,
    	     "linha":U,
    	     "erro":U].

DEFINE VARIABLE cNeededFieldsTypes AS CHARACTER  NO-UNDO
    EXTENT 31
    INITIAL ["integer":U,
    	     "integer":U,
    	     "integer":U,
    	     "integer":U,
    	     "character":U,
    	     "integer":U,
    	     "character":U,
    	     "character":U,
    	     "character":U,
    	     "character":U,
    	     "date":U,
    	     "decimal":U,
    	     "character":U,
    	     "decimal":U,
    	     "decimal":U,
    	     "character":U,
             "character":U,
    	     "date":U,
    	     "decimal":U,
    	     "date":U,
    	     "decimal":U,
    	     "date":U,
    	     "decimal":U,
    	     "date":U,
    	     "decimal":U,
    	     "character":U,
    	     "character":U,
    	     "character":U,
    	     "logical":U,
    	     "integer":U,
    	     "logical":U].

DEFINE VARIABLE c-AdapterProgram  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-cod-equipamento AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-cod-servidor    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-cod-trans       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-cod-var-ems     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-cod-var-equip   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-hora-atualiz    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-valor-var       AS CHARACTER  NO-UNDO.

DEFINE VARIABLE d-data-atualiz AS DATE       NO-UNDO.

DEFINE VARIABLE i-NumProduto AS INTEGER    NO-UNDO.
/*********************************************************************************/

/*********************************************************************************/
DO:
    FIND LAST param-bc NO-LOCK NO-ERROR.

    IF NOT AVAILABLE param-bc THEN
        RETURN 'NOK':U.

    &if '{&mgcld_version}' <= '2.04' &then
        ASSIGN i-NumProduto = param-bc.int-2.
    &else
        ASSIGN i-NumProduto = param-bc.ind-sistema.
    &endif

    CASE i-NumProduto:
        WHEN 1 THEN
            /*Assign vAdapterProgram = 'bcp/bc9003d.p'.*/
            ASSIGN c-AdapterProgram = 'bcp/bc9031d.p':U.
        WHEN 2 THEN
            ASSIGN c-AdapterProgram = 'bcp/bc9003e.p':U.
    END.

    FIND FIRST bc-trans WHERE bc-trans.nr-trans = pNumTrans NO-LOCK NO-ERROR.

    IF AVAILABLE bc-trans THEN DO:

/* Campos as serem alimentados (Valores Default ou bc-trans-filho)

    field   tipo-rep            as  integer 
    field   nr-ord-produ        as  integer     
    field   num-operac-sfc      as  integer 
    field   num-split-operac    as  integer
    field   cod-roteiro         as  character
    field   op-codigo           as  integer
    field   cod-ctrab           as  character
    field   it-codigo           as  character
    field   cod-refer           as  character
    field   lote-serie          as  character
    field   dat-valid-lote      as  date
    field   qtd-produzida       as  DECIMAL     /*** quantidade aprovada    ***/
    FIELD   cod-motiv-refugo    AS  CHARACTER
    field   qtd-refugada        as  decimal
    FIELD   qtd-retrabalho      AS  DECIMAL
    FIELD   ct-refugo           like rep-prod.ct-refugo
    FIELD   sc-refugo           like rep-prod.sc-refugo
    field   dat-inic-rep        as  date
    field   hr-inic-rep         as  decimal
    field   dat-fim-rep         as  date
    field   hr-fim-rep          as  decimal
    field   dat-inic-setup      as  date
    field   hr-inic-setup       as  decimal
    field   dat-fim-setup       as  date
    field   hr-fim-setup        as  decimal
    field   cod-equipe          as  character
    field   cod-operador        as  character   format  "9999999-9"
    field   cod-ferramenta      as  character
    field   finaliza            as  logical
    field   linha               as  integer
    field   erro                as  logical
    index   split   is primary  tipo-rep it-codigo 
    index   num-linha linha.
*/
        ASSIGN c-cod-trans    = bc-trans.cd-trans
               c-hora-atualiz = bc-trans.hora-atualizacao
               d-data-atualiz = bc-trans.data-atualizacao.

        FOR EACH  bc-trans-filho NO-LOCK
            WHERE bc-trans-filho.nr-trans = bc-trans.nr-trans:

            ASSIGN c-cod-equipamento = ENTRY(1,bc-trans-filho.conteudo-trans,CHR(30))
                   c-cod-var-ems     = ENTRY(2,bc-trans-filho.conteudo-trans,CHR(30)) 
                   c-valor-var       = ENTRY(3,bc-trans-filho.conteudo-trans,CHR(30)).

            FIND FIRST bc-eqpto NO-LOCK
                 WHERE bc-eqpto.cod-eqpto = c-cod-equipamento NO-ERROR.

            IF AVAILABLE bc-eqpto THEN DO:

                ASSIGN c-cod-servidor = bc-eqpto.cod-servid.

/*                _AddField("cod-servidor":U , STRING(c-cod-servidor)   , "Character":U).
                _AddField("cod-eqpto":U    , STRING(c-cod-equipamento), "Character":U).
                _AddField("cd-trans":U     , STRING(c-cod-trans)      , "Character":U).
                _AddField("dt-geracao":U   , STRING(d-data-atualiz)   , "Date":U).
                _AddField("hr-geracao":U   , STRING(c-hora-atualiz)   , "Character":U).
                _AddField("cod-var-eqpto":U, STRING(c-cod-var-equip)  , "Character":U).
                _AddField("cod-var-dtsul":U, STRING(c-cod-var-ems)    , "Character":U).
                _AddField("valor":U        , STRING(c-valor-var)      , "Character":U).
*/
                CASE c-cod-var-ems:
                    WHEN "cod-ctrab":U OR
                    WHEN "cod-equipe":U OR
                    WHEN "cod-ferramenta":U OR
                    WHEN "cod-motiv-refugo":U OR
                    WHEN "cod-operador":U OR
                    WHEN "cod-refer":U OR
                    WHEN "cod-roteiro":U OR
                    WHEN "ct-refugo":U OR
                    WHEN "sc-refugo":U OR
                    WHEN "it-codigo":U OR
                    WHEN "lote-serie":U THEN DO:
                        _AddField(c-cod-var-ems, STRING(c-valor-var), "Character":U).
                    END.

                    WHEN "dat-fim-rep":U OR
                    WHEN "dat-fim-setup":U OR
                    WHEN "dat-inic-rep":U OR
                    WHEN "dat-inic-setup":U OR
                    WHEN "dat-valid-lote":U THEN
                        _AddField(c-cod-var-ems, STRING(c-valor-var), "Date":U).

                    WHEN "hr-fim-rep":U OR
                    WHEN "hr-fim-setup":U OR
                    WHEN "hr-inic-rep":U OR
                    WHEN "hr-inic-setup":U OR
                    WHEN "qtd-produzida":U OR
                    WHEN "qtd-refugada":U OR
                    WHEN "qtd-retrabalho":U THEN
                        _AddField(c-cod-var-ems, STRING(c-valor-var), "Decimal":U).

                    WHEN "linha":U OR
                    WHEN "nr-ord-produ":U OR
                    WHEN "num-operac-sfc":U OR
                    WHEN "num-split-operac":U OR
                    WHEN "op-codigo":U OR
                    WHEN "tipo-rep":U THEN                    
                        _AddField(c-cod-var-ems, STRING(c-valor-var), "Integer":U).

                    WHEN "erro":U OR
                    WHEN "finaliza":U THEN                    
                        _AddField(c-cod-var-ems, STRING(c-valor-var), "Logical":U).

                END CASE.
            END.                       
        END.
    END.

    RUN createInitialFields IN THIS-PROCEDURE.
    RUN createNeededFields  IN THIS-PROCEDURE.

    RUN VALUE(c-AdapterProgram) (INPUT        pNumTrans,
                                 INPUT        TABLE ttIntegracao,
                                 INPUT-OUTPUT TABLE tt-erro).
END.
/***********************************************************************************************************/

PROCEDURE createInitialFields:
    IF NOT CAN-FIND(FIRST ttIntegracao NO-LOCK
                    WHERE ttIntegracao.atributo = "tipo-rep":U) THEN
        _AddField("tipo-rep":U, "1":U, "Integer":U).

    IF NOT CAN-FIND(FIRST ttIntegracao NO-LOCK
                    WHERE ttIntegracao.atributo = "dat-valid-lote":U) THEN
        _AddField("dat-valid-lote":U, "31/12/9999":U, "Date":U).

END PROCEDURE.

PROCEDURE createNeededFields:
    DEFINE VARIABLE cValueAux AS CHARACTER  NO-UNDO.

    DEFINE VARIABLE iCount AS INTEGER    NO-UNDO.

    DO iCount = 1 TO EXTENT(cNeededFields):

        IF NOT CAN-FIND(FIRST ttIntegracao NO-LOCK
                        WHERE ttIntegracao.Atributo = cNeededFields[iCount]) THEN DO:

            CASE cNeededFieldsTypes[iCount]:
                WHEN "Character":U THEN
                    ASSIGN cValueAux = "":U.
                WHEN "Date":U THEN
                    ASSIGN cValueAux = &IF "{&ems_dbtype}":U = "MSS":U &THEN "01/01/1800":U &ELSE "01/01/0001":U &ENDIF .
                WHEN "Decimal":U THEN
                    ASSIGN cValueAux = "0":U.
                WHEN "Integer":U THEN
                    ASSIGN cValueAux = "0":U.
                WHEN "Logical":U THEN
                    ASSIGN cValueAux = "NO":U.

            END CASE.

            _AddField(cNeededFields[iCount], cValueAux, cNeededFieldsTypes[iCount]).
        END.
    END.

END PROCEDURE.
