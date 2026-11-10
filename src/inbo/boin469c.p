/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN469C 2.00.00.014 } /*** "010014" 17/06/2025 16:40:50 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN469C MUT}
&ENDIF
    
def var v-log-tempo-extra as logical no-undo.
DEFINE VARIABLE tgDentroParada AS LOGICAL     NO-UNDO.

{cdp/cdcfgman.i}
{inbo/boin469c.i}

/*****************************************************************************
** Procedure Interna.....: DeterminarTempoTurnoCtrab
** Objetivo..............: Determinar o tempo por turno entre uma data/hora
                           e outra data/hora para um centro de trabalho.
** Parƒmetros............: tt-tempo-turno-ctrab
*****************************************************************************/
PROCEDURE DeterminarTempoTurnoCtrab:

    define parameter buffer b1-tt-ctrab for tt-tempo-turno-ctrab. 

    define buffer b2-tt-ctrab for tt-tempo-turno-ctrab.

    def var v-dat-inic-valid                  as date                        no-undo.
    def var v-dat-fim-valid                   as date                        no-undo.
    def var i-turno                           as int                         no-undo.
    def var v-cod-turno                      like turno-dia.cod-model-turno no-undo.


    if b1-tt-ctrab.cod-ctrab <> "" and
       b1-tt-ctrab.gm-codigo <> "" then do:
        run DeterminarModelTurnoCtrab (input  b1-tt-ctrab.cod-area,
                                       input  b1-tt-ctrab.gm-codigo,
                                       input  b1-tt-ctrab.cod-ctrab,
                                       input  b1-tt-ctrab.dat-inic,
                                       output v-dat-inic-valid,
                                       output v-dat-fim-valid,
                                       output v-cod-turno).
    end.                                  

    /*** DeterminaModelo associado a area de produ‡Æo ***/
    else do:
        run DeterminarModelTurnoGrpArea (input b1-tt-ctrab.cod-area,
                                         input b1-tt-ctrab.dat-inic,
                                         output v-dat-inic-valid,
                                         output v-dat-fim-valid,
                                         output v-cod-turno).
     end.

    if v-dat-fim-valid <= b1-tt-ctrab.dat-fim then do:
       create b2-tt-ctrab.
       buffer-copy b1-tt-ctrab to b2-tt-ctrab
       assign b2-tt-ctrab.dat-inic      = v-dat-fim-valid
              b2-tt-ctrab.qtd-segs-inic = 0
              b1-tt-ctrab.dat-fim       = v-dat-fim-valid
              b1-tt-ctrab.qtd-segs-fim  = 0.

       find first tt-tempo-turno no-error.
       if not available tt-tempo-turno then       
           create tt-tempo-turno.
       buffer-copy b1-tt-ctrab to tt-tempo-turno
          assign tt-tempo-turno.cod-model-turno = v-cod-turno
                 tt-tempo-turno.qtd-tempo-turno = 0.

       run DeterminarTempoTurno (buffer tt-tempo-turno).

       do i-turno = 1 to 9:
          assign b1-tt-ctrab.qtd-tempo-turno[i-turno] = tt-tempo-turno.qtd-tempo-turno[i-turno].
       end.   

       run DeterminarTempoTurnoCtrab (buffer b2-tt-ctrab).

       do i-turno = 1 to 9:
          assign b1-tt-ctrab.qtd-tempo-turno[i-turno] = b1-tt-ctrab.qtd-tempo-turno[i-turno] +
                                                        b2-tt-ctrab.qtd-tempo-turno[i-turno].
       end.
       delete b2-tt-ctrab.
       if available tt-tempo-turno then 
           delete tt-tempo-turno.   
    end.
    else do:
       create tt-tempo-turno.
       buffer-copy b1-tt-ctrab to tt-tempo-turno
          assign tt-tempo-turno.cod-model-turno = v-cod-turno
                 tt-tempo-turno.qtd-tempo-turno = 0.

       run DeterminarTempoTurno (buffer tt-tempo-turno).
       do i-turno = 1 to 9:
          assign b1-tt-ctrab.qtd-tempo-turno[i-turno] = tt-tempo-turno.qtd-tempo-turno[i-turno].
       end. 

       if available tt-tempo-turno then 
           delete tt-tempo-turno.   
    end.
END PROCEDURE.



/*****************************************************************************
** Procedure Interna.....: DeterminarTempoTurno
** Objetivo..............: Determinar o tempo por turno entre uma data/hora
                           e outra data/hora.
** Parƒmetros............: tt-tempo-turno
*****************************************************************************/
PROCEDURE DeterminarTempoTurno:

    define parameter buffer b-tt-turno for tt-tempo-turno. 

    def var v-dat-aux   as date    no-undo.
    def var v-hra-aux   as decimal no-undo.
    def var i-turno     as integer no-undo.
    DEF VAR r-turno     AS ROWID   NO-UNDO.

    assign v-dat-aux = b-tt-turno.dat-inic
           v-hra-aux = b-tt-turno.qtd-segs-inic / 3600.

    find first turno-dia where
               turno-dia.cod-model-turno = b-tt-turno.cod-model-turno  and  
               turno-dia.num-dia         = weekday(v-dat-aux)         /* Ativ. 164.087  
               and
               turno-dia.qtd-hra-inicio   <= v-hra-aux                   and
               turno-dia.qtd-hra-fim    >  v-hra-aux */         no-lock no-error.

    blk-repeat:
    repeat:           

        IF AVAILABLE turno-dia
        THEN DO:
            assign v-hra-aux   = turno-dia.qtd-hra-fim
                  i-turno     = min(9, turno-dia.num-turno).

            IF v-dat-aux < b-tt-turno.dat-fim
            THEN DO:
                ASSIGN b-tt-turno.qtd-tempo-turno[i-turno] = b-tt-turno.qtd-tempo-turno[i-turno] + turno-dia.qtd-hra-fim.
            END.
            ELSE DO:
                ASSIGN b-tt-turno.qtd-tempo-turno[i-turno] = b-tt-turno.qtd-tempo-turno[i-turno] + MIN(b-tt-turno.qtd-segs-fim / 3600, turno-dia.qtd-hra-fim).
            END.
            IF v-dat-aux > b-tt-turno.dat-inic
            THEN DO:
                ASSIGN b-tt-turno.qtd-tempo-turno[i-turno] = b-tt-turno.qtd-tempo-turno[i-turno] - turno-dia.qtd-hra-inicio.
            END.
            ELSE DO:
                IF (b-tt-turno.qtd-tempo-turno[i-turno] - MAX (b-tt-turno.qtd-segs-inic / 3600, turno-dia.qtd-hra-inicio)) < 0
                THEN
                    ASSIGN b-tt-turno.qtd-tempo-turno[i-turno] = b-tt-turno.qtd-tempo-turno[i-turno] - turno-dia.qtd-hra-fim.
                ELSE 
                    ASSIGN b-tt-turno.qtd-tempo-turno[i-turno] = b-tt-turno.qtd-tempo-turno[i-turno] - MAX (b-tt-turno.qtd-segs-inic / 3600, turno-dia.qtd-hra-inicio).
            END.
        END.
        ELSE DO:
            ASSIGN v-dat-aux = v-dat-aux + 1
                   v-hra-aux = 0.
        END.           

        if  v-dat-aux > b-tt-turno.dat-fim or
          (v-dat-aux = b-tt-turno.dat-fim and
           v-hra-aux >= b-tt-turno.qtd-segs-fim / 3600) then leave blk-repeat.

        ASSIGN r-turno = ROWID(turno-dia).

        find first turno-dia
             where turno-dia.cod-model-turno = b-tt-turno.cod-model-turno
               and turno-dia.num-dia         = WEEKDAY(v-dat-aux)
               and turno-dia.qtd-hra-inicio   >= v-hra-aux
               and rowid(turno-dia)         <> r-turno
              no-lock no-error.
    end.

END PROCEDURE.

&IF DEFINED (bf_man_sfc_lc) &THEN

{inbo/boin469b.i7}  /*** Determinar (ModelTurno/Calend) Ctrab ***/

&ENDIF

{inbo/boin469b.i6}  /*** Determinar (ModelTurno/Calend) GrpArea ***/

PROCEDURE RecebeParametros:
DEFINE INPUT PARAMETER p-log-tempo-extra    AS LOGICAL  NO-UNDO.
ASSIGN v-log-tempo-extra = p-log-tempo-extra.

END PROCEDURE.
