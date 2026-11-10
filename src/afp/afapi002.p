
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AFAPI002 2.00.00.003 } /*** 010003 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i afapi002 MAF}
&ENDIF

/********************************************************************************************
**
**       Programa.: AFAPI002.P   
**
**       Data.....: Fevereiro de 2013
**
**       Objetivo.: C lculo de per¡odos
**
**       Cria‡Æo..: Rodrigo 
**
*******************************************************************************************/

{afp/afapi002.i}

DEFINE INPUT PARAMETER pi-ano AS INTEGER NO-UNDO.
DEFINE INPUT PARAMETER pi-periodos AS INTEGER NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR tt-periodos.

EMPTY TEMP-TABLE tt-periodos.

IF pi-periodos > 12 THEN
    RETURN "NOK":U.

IF (pi-periodos <> 1 AND  pi-periodos <> 2 AND
    pi-periodos <> 3 AND pi-periodos <> 4 AND
    pi-periodos <> 6 AND pi-periodos <> 12) OR pi-ano <= 0 THEN
    RETURN "NOK":U.

RUN pi-gera-periodos IN THIS-PROCEDURE (INPUT pi-periodos).

PROCEDURE pi-gera-periodos:
    DEFINE INPUT PARAM i-num-periodos AS INT NO-UNDO.

    DEFINE VARIABLE i-cont               AS INTEGER INIT 0  NO-UNDO.
    DEFINE VARIABLE dt-inicio-periodo    AS DATE            NO-UNDO.
    DEFINE VARIABLE i-mes-final-periodo  AS INTEGER         NO-UNDO.

    ASSIGN dt-inicio-periodo    = DATE(01, 01, pi-ano)
           i-mes-final-periodo  = (12 / i-num-periodos).


    DO WHILE i-cont <> i-num-periodos:

        /* Busca £ltimo dia do mˆs */
        DEFINE VARIABLE dt-ultimo-dia AS DATE               NO-UNDO.

        assign dt-ultimo-dia = date(i-mes-final-periodo, 28, pi-ano).

        DO WHILE TRUE:
           ASSIGN dt-ultimo-dia = dt-ultimo-dia + 1.
           IF MONTH(dt-ultimo-dia) <> i-mes-final-periodo THEN DO:
              ASSIGN dt-ultimo-dia = dt-ultimo-dia - 1.
              LEAVE.
           END.
        END.   

        CREATE tt-periodos.
        ASSIGN tt-periodos.date-ini  = dt-inicio-periodo 
               tt-periodos.date-fim  = dt-ultimo-dia
               tt-periodos.sequencia = i-cont + 1.

        CASE i-num-periodos:
            WHEN 1 THEN DO:
                ASSIGN tt-periodos.periodo = "Ano " + STRING(pi-ano).
            END.
            WHEN 2 THEN DO:
                ASSIGN tt-periodos.periodo = string(i-cont + 1) + "ø Semestre".
            END.
            WHEN 3 THEN DO:
                ASSIGN tt-periodos.periodo = string(i-cont + 1) + "ø Quadrimestre".
            END.
            WHEN 4 THEN DO:
                ASSIGN tt-periodos.periodo = string(i-cont + 1) + "ø Trimestre".
            END.
            WHEN 6 THEN DO:
                ASSIGN tt-periodos.periodo = string(i-cont + 1) + "ø Bimestre".
            END.
            WHEN 12 THEN DO:
                CASE i-cont:
                    WHEN 0 THEN ASSIGN tt-periodos.periodo  = "Janeiro".
                    WHEN 1 THEN ASSIGN tt-periodos.periodo  = "Fevereiro".
                    WHEN 2 THEN ASSIGN tt-periodos.periodo  = "Mar‡o".
                    WHEN 3 THEN ASSIGN tt-periodos.periodo  = "Abril".
                    WHEN 4 THEN ASSIGN tt-periodos.periodo  = "Maio".
                    WHEN 5 THEN ASSIGN tt-periodos.periodo  = "Junho".
                    WHEN 6 THEN ASSIGN tt-periodos.periodo  = "Julho".
                    WHEN 7 THEN ASSIGN tt-periodos.periodo  = "Agosto".
                    WHEN 8 THEN ASSIGN tt-periodos.periodo  = "Setembro".
                    WHEN 9 THEN ASSIGN tt-periodos.periodo  = "Outubro".
                    WHEN 10 THEN ASSIGN tt-periodos.periodo = "Novembro".
                    WHEN 11 THEN ASSIGN tt-periodos.periodo = "Dezembro".
                END CASE.
            END.
        END CASE.

        ASSIGN dt-inicio-periodo   = tt-periodos.date-fim + 1 
               i-mes-final-periodo = i-mes-final-periodo + (12 / i-num-periodos)  
               i-cont              = i-cont + 1.
    END.

    RETURN "OK".
END.

RETURN "OK".
