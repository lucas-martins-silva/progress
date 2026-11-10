/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9034C 2.00.00.001}  /*** 010001 ***/

/**********************************************************************************
**     Programa...: bc9034c.p
**
**     Finalidade.: Parada de M quina
**
**     Criado em..: Junho/2006
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
    EXTENT 14
    INITIAL ["tipo-rep":U,
             "cod-ctrab":U,
             "cod-equipe":U,
             "cod-operador":U,
             "cod-parada":U,
             "dat-fim-parada":U,
             "dat-inic-parada":U,
             "hr-fim-parada":U,
             "hr-inic-parada":U,
             "num-om-progda":U,
             "val-refer-fim-parada":U,
             "val-refer-inic-parada":U,
             "linha":U,
             "erro":U].

DEFINE VARIABLE cNeededFieldsTypes AS CHARACTER  NO-UNDO
    EXTENT 14
    INITIAL ["Integer":U,
             "Character":U,
             "Character":U,
             "Integer":U,
             "Date":U,
             "Decimal":U,
             "Date":U,
             "Decimal":U,
             "Decimal":U,
             "Decimal":U,
             "Character":U,
             "Character":U,
             "Integer":U,
             "Logical":U].

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
    FIND LAST Param-BC NO-LOCK  NO-ERROR.

    IF  NOT AVAILABLE Param-BC THEN RETURN 'NOK'.

    &if '{&mgcld_version}' <= '2.04' &then
        ASSIGN i-NumProduto = Param-BC.int-2.
    &else
        ASSIGN i-NumProduto = Param-BC.ind-sistema.
    &endif

    CASE i-NumProduto:
        WHEN 1 THEN
            ASSIGN c-AdapterProgram = "bcp/bc9034d.p":U.
        WHEN 2 THEN
            ASSIGN c-AdapterProgram = "bcp/bc9034e.p":U.
    END.

/* Campos as serem alimentados (Valores Default ou bc-trans-filho)

    field   tipo-rep        as  integer   /*** tipo de transa‡Æo 1- incluir 2- iniciar 3 - finalizar ***/
    field   cod-ctrab       as  character /***  centro de trabalho  ***/
    field   cod-parada      as  character /*** parada   ***/
    field   num-om-progda   as  integer /*** numero da ordem ***/
    field   dat-inic-parada as  date    /*** data de inicio   ***/
    field   hr-inic-parada  as  decimal /*** hora de inicio em segundos***/
    field   dat-fim-parada  as  date    /*** data termino   ***/
    field   hr-fim-parada   as  decimal /*** hora termino em segundos   ***/
    field   val-refer-inic-parada   as  decimal decimals 5  /*** valor referencia inicio yyyymmddsssss nÆo ‚ necess rio preencher  ***/
    field   val-refer-fim-parada    as  decimal decimals 5  /*** valor referencia termino yyyymmddsssss nÆo ‚ necess rio preencher  ***/
    field   cod-equipe      as  character   /***  equipe de produ‡Æo  ***/
    field   cod-operador    as  character   format  "99999-9" /***  operador do centro de trabalho  ***/
    field   linha               as  integer
    field   erro                as  logical    
    index   id-parada is primary cod-ctrab val-refer-inic-parada
    index   om  num-om-progda cod-ctrab
    index   fim cod-ctrab val-refer-fim-parada
    index   num-linha linha.
*/
    FIND FIRST bc-trans WHERE nr-trans = pNumTrans NO-LOCK NO-ERROR.

    IF AVAILABLE bc-trans THEN DO:

        ASSIGN c-cod-trans    = bc-trans.cd-trans
               c-hora-atualiz = bc-trans.hora-atualizacao
               d-data-atualiz = bc-trans.data-atualizacao.

        FOR EACH  bc-trans-filho NO-LOCK
            WHERE bc-trans-filho.nr-trans = bc-trans.nr-trans:

            ASSIGN c-cod-equipamento = ENTRY(1,bc-trans-filho.conteudo-trans,CHR(30))
                   c-cod-var-ems     = ENTRY(2,bc-trans-filho.conteudo-trans,CHR(30)) 
                   c-valor-var       = ENTRY(3,bc-trans-filho.conteudo-trans,CHR(30)).

            FIND FIRST bc-eqpto WHERE bc-eqpto.cod-eqpto = c-cod-equipamento NO-LOCK NO-ERROR.

            IF AVAILABLE bc-eqpto THEN DO:

                ASSIGN c-cod-servidor = bc-eqpto.cod-servid.

                CASE c-cod-var-ems:
                    WHEN "cod-ctrab":U OR
                    WHEN "cod-parada":U OR
                    WHEN "cod-equipe":U OR
                    WHEN "cod-operador":U THEN
                        _AddField(c-cod-var-ems, STRING(c-valor-var), "Character":U).

                    WHEN "dat-inic-parada":U OR
                    WHEN "dat-fim-parada":U THEN
                        _AddField(c-cod-var-ems, STRING(c-valor-var), "Date":U).

                    WHEN "hr-inic-parada":U OR
                    WHEN "hr-fim-parada":U OR
                    WHEN "val-refer-inic-parada":U OR
                    WHEN "val-refer-fim-parada":U THEN
                        _AddField(c-cod-var-ems, STRING(c-valor-var), "Decimal":U).

                    WHEN "tipo-rep":U OR
                    WHEN "num-om-progda":U THEN
                        _AddField(c-cod-var-ems, STRING(c-valor-var), "Integer":U).

                    WHEN "erro":U THEN
                        _AddField(c-cod-var-ems, STRING(c-valor-var), "Logical":U).

                END CASE.
            END.
        END.
    END.

    RUN createInitialFields IN THIS-PROCEDURE.
    RUN createNeededFields  IN THIS-PROCEDURE.

    RUN VALUE(c-AdapterProgram) (INPUT              pNumTrans,
                                 INPUT        TABLE ttIntegracao,
                                 INPUT-OUTPUT TABLE tt-erro).
END.

PROCEDURE createInitialFields:
    IF NOT CAN-FIND(FIRST ttIntegracao NO-LOCK
                    WHERE ttIntegracao.atributo = "tipo-rep":U) THEN
        _AddField("tipo-rep":U, "1":U, "Integer":U).

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
