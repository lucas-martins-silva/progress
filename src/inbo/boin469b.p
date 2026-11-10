/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN469B 2.00.00.031 } /* 16/05/2024 10:47:31 */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i boin469b MUT}
&ENDIF      

/*****************************************************************************
**
** PROGRAMA  BOIN469B - funcoes de tratamento de tempo / Evolu‡Æo da BOIN469A
******   O "Bug" descrito abaixo foi corrigido, para mais detalhes vide coment rios na boin469b.i5. ****
** BUG: A data nÆo util afeta o dispon¡vel em periodos de virada i.e.
**      de 22:00 at‚ 24:00 num turno de 22:00 at‚ 06:00 serÆo consideradas
**      apenas 6 horas quando o dia antecessor for feriado (deveria ser 8).
**      No mesmo caso quando se trata do terceiro turno quando o dia sucessor
**      for feriado serÆo consideradas apenas 2 horas (deveria ser 8)
**      Para mais detalhes falar com Jos‚ Carlos
**
******************************************************************************/

/*** Tempor rias e vari veis internas comuns ***/

def temp-table tt-turno-semana    NO-UNDO    
    field num-dia-sema           as int form "9"      init 1
    field num-turno-produc       as int form ">9"     init 1
    field qtd-tempo-dispon-turno as dec form ">>,>>9" init 0
    field qtd-segs-inic-turno    as dec form ">>,>>9" init 0
    field qtd-segs-fim-turno     as dec form ">>,>>9" init 0
    FIELD num-dia-turno          AS INT FORM "9"      INIT 0
    index tt-turno-semana-fim          is unique
          num-dia-sema                 ascending
          qtd-segs-fim-turno           ascending
    index tt-turno-semana-id           is primary unique
          num-dia-sema                 ascending
          qtd-segs-inic-turno          ascending.

def var v-qtd-tempo-dispon-dia     as dec format ">>,>>9" decimals 0 init 0 extent 7 no-undo.
def var v-val-fat-correcao-hra     as decimal         no-undo.
def var v-dat-calcul               as date            no-undo.
def var v-qtd-segs-calcul          as decimal         no-undo.
def var v-dat-fim-valid            as date            no-undo.
def var v-dat-inic-valid           as date            no-undo.
def var v-num-dia-sema             as integer         no-undo.
def var v-qtd-tempo-gasto-turno    as decimal         no-undo.
def var v-qtd-tempo-resid-dia      as decimal         no-undo.
def var v-qtd-tempo-resid-turno    as decimal         no-undo.

{cdp/cdcfgman.i}

/*Efetua a regera‡Æo dos dados da tabela turno-dia (atrav‚s da trigger de write da tabela turno-semana.
  Essa regera‡Æo est  sendo for‡ada devido a corre‡Æo feita para Logoplaste (FO 1672.976), na qual foi necess rio
  gravar no turno-dia.int-1 a informa‡Æo de data a qual pertence o turno-dia em questÆo, com o objetivo de calcular de forma
  correta o tempo dispon¡vel do Centro de Trabalho. */
FIND FIRST param-sfc NO-LOCK NO-ERROR.
IF AVAIL param-sfc AND SUBSTRING(param-sfc.char-2,100,1) <> "W":U THEN DO:
    FOR EACH turno-semana EXCLUSIVE-LOCK:
        ASSIGN turno-semana.log-regera-turno = YES.
    END.
    FIND CURRENT param-sfc EXCLUSIVE-LOCK NO-ERROR.
    ASSIGN OVERLAY(param-sfc.char-2,100,1) = "W":U.
    FIND CURRENT param-sfc NO-LOCK NO-ERROR.
END.

/*****************************************************************************
** Procedure Interna.....: CalcularTemposCtrab
** Objetivo .............: Determina data/hora final   ou 
                                     data/hora inicial ou
                                     tempo util entre duas datas baseandose
                                     na parametriza‡Æo de um centro de trabalho.

** PARAMETROS: ENTRADA: grupo de maquina, calendario do grupo de maquina,
**             ENTRADA E SAIDA: 
**             tempo de processo: Em horas 
**             data de inicio 
**             hora de inicio:    Em segundos
**             data final 
**             hora final:        Em segundos
** Parƒmetros ...........: io p-cod-area
                           io p-gm-codigo
                           i  p-cod-ctrab
                           io p-cod-calend
                           io p-dat-fim
                           io p-qtd-segs-fim
                           io p-dat-inic
                           io p-qtd-segs-inic
                           io p-qtd-tempo-proces
*****************************************************************************/
PROCEDURE CalcularTemposCtrabExtra:

    def input-output param p-cod-area         as char    format "x(12)"          no-undo.
    def input-output param p-cod-grp-maq      as char    format "x(9)"           no-undo.
    def input        param p-cod-ctrab        as char    format "x(16)"          no-undo.
    def input-output param p-cod-calend       as char    format "x(8)"           no-undo.
    def input-output param p-dat-fim          as date    format "99/99/9999"     no-undo.
    def input-output param p-qtd-segs-fim     as decimal format "->>>>,>>9.9999" decimals 4 no-undo.
    def input-output param p-dat-inic         as date    format "99/99/9999"     no-undo.
    def input-output param p-qtd-segs-inic    as decimal format "->>>>,>>9.9999" decimals 4 no-undo.
    DEF INPUT        PARAM p-cod-model-turno  AS CHAR                                       NO-UNDO.
    def input-output param p-qtd-tempo        as decimal format ">,>>>,>>9.9999"   decimals 4 no-undo.
    DEF OUTPUT       PARAM p-qtd-tempo-extra  AS decimal format ">,>>>,>>9.9999"   decimals 4 no-undo.
    DEF OUTPUT       PARAM p-num-turno        AS INTEGER                                    NO-UNDO.

    /* procura calendario caso nao seja definido */
    if  p-cod-calend = ? then do:

        if p-cod-ctrab <> ? then 
            run DeterminarCalendCtrab (input-output p-cod-area, 
                                       input-output p-cod-grp-maq,
                                       input        p-cod-ctrab,
                                       input        p-dat-inic,
                                       output       p-cod-calend). 
        else if p-cod-grp-maq <> ? then
            run DeterminarCalendGrpArea (input  2,  /*** Calend rio do grupo m quina ***/
                                         input  p-cod-area,
                                         output p-cod-calend).

            else if p-cod-area <> ? then
                run DeterminarCalendGrpArea (input  1,  /*** Calend rio do grupo m quina ***/
                                             input  p-cod-area,
                                             output p-cod-calend).
    end.                                         

    if  p-dat-inic = ? and 
        p-dat-fim = ? then return.

    if  p-dat-inic <> ? and p-dat-fim = ? then do:
        run pi-determina-fim-evento (input  p-cod-area,
                                     input  p-cod-grp-maq,
                                     input  p-cod-ctrab,
                                     input  p-cod-calend, 
                                     output p-dat-fim,
                                     output p-qtd-segs-fim,
                                     input  p-dat-inic,
                                     input  p-qtd-segs-inic,
                                     input  p-qtd-tempo).
    end.
    else do:   
        if  p-dat-inic = ? and p-dat-fim <> ? then do:
            run pi-determina-inicio-evento (input  p-cod-area,
                                            input  p-cod-grp-maq,
                                            input  p-cod-ctrab,
                                            input  p-cod-calend, 
                                            input  p-dat-fim,
                                            input  p-qtd-segs-fim,
                                            output p-dat-inic,
                                            output p-qtd-segs-inic,
                                            input  p-qtd-tempo).
        end.
        else do:
            run pi-determina-tempo-evento-extra (input  p-cod-area,
                                                 input  p-cod-grp-maq,
                                                 input  p-cod-ctrab,
                                                 input  p-cod-calend, 
                                                 input  p-dat-fim,
                                                 input  p-qtd-segs-fim,
                                                 input  p-dat-inic,
                                                 input  p-qtd-segs-inic,
                                                 INPUT  p-cod-model-turno,
                                                 output p-qtd-tempo,
                                                 OUTPUT p-qtd-tempo-extra,
                                                 OUTPUT p-num-turno).
        end.
    end.       

END PROCEDURE.

DEF VAR LL-p-qtd-tempo-extra as decimal format ">,>>>,>>9.9999"   decimals 4 no-undo.
DEF VAR LL-p-num-turno       AS INTEGER                                    NO-UNDO.

PROCEDURE CalcularTemposCtrab:

    def input-output param p-cod-area         as char    format "x(12)"          no-undo.
    def input-output param p-cod-grp-maq      as char    format "x(9)"           no-undo.
    def input        param p-cod-ctrab        as char    format "x(16)"          no-undo.
    def input-output param p-cod-calend       as char    format "x(8)"           no-undo.
    def input-output param p-dat-fim          as date    format "99/99/9999"     no-undo.
    def input-output param p-qtd-segs-fim     as decimal format "->>>>,>>9.9999" decimals 4 no-undo.
    def input-output param p-dat-inic         as date    format "99/99/9999"     no-undo.
    def input-output param p-qtd-segs-inic    as decimal format "->>>>,>>9.9999" decimals 4 no-undo.
    def input-output param p-qtd-tempo        as decimal format ">,>>>,>>9.9999"   decimals 4 no-undo.

    DEF VAR p-qtd-tempo-extra as decimal format ">,>>>,>>9.99"   decimals 4 no-undo.
    DEF VAR p-num-turno       AS INTEGER                                    NO-UNDO.

    RUN CalcularTemposCtrabExtra (INPUT-OUTPUT p-cod-area,     
                                  input-output p-cod-grp-maq,
                                  input        p-cod-ctrab,    
                                  input-output p-cod-calend,   
                                  input-output p-dat-fim,      
                                  input-output p-qtd-segs-fim,
                                  input-output p-dat-inic,     
                                  input-output p-qtd-segs-inic,
                                  INPUT        "":U,
                                  input-output p-qtd-tempo,
                                  OUTPUT       p-qtd-tempo-extra,
                                  OUTPUT       p-num-turno).
    ASSIGN  LL-p-qtd-tempo-extra   = p-qtd-tempo-extra
            LL-p-num-turno         = p-num-turno.

END PROCEDURE.


PROCEDURE piRetornaDadosExtras:
    DEF OUTPUT       PARAM p-qtd-tempo-extra  AS decimal format ">,>>>,>>9.99"   decimals 4 no-undo.
    DEF OUTPUT       PARAM p-num-turno        AS INTEGER                                    NO-UNDO.

    ASSIGN  p-qtd-tempo-extra   = LL-p-qtd-tempo-extra
            p-num-turno         = LL-p-num-turno.

END PROCEDURE.


/*****************************************************************************
** Procedure Interna.....: CalcularTemposGrpMaq
** Objetivo .............: Determina data/hora final   ou 
                                     data/hora inicial ou
                                     tempo util entre duas datas baseandose
                                     na parametriza‡Æo de um grupo de m quina.

** PARAMETROS: ENTRADA: grupo de maquina, calendario do grupo de maquina,
**             ENTRADA E SAIDA: 
**             tempo de processo: Em horas 
**             data de inicio 
**             hora de inicio:    Em segundos
**             data final 
**             hora final:        Em segundos
** Parƒmetros ...........: i  p-gm-codigo
                           io p-cod-calend
                           io p-dat-fim
                           io p-qtd-segs-fim
                           io p-dat-inic
                           io p-qtd-segs-inic
                           io p-qtd-tempo-proces
*****************************************************************************/
PROCEDURE CalcularTemposGrpMaq:

    def input        param p-cod-grp-maq      as char    format "x(9)"           no-undo.
    def input-output param p-cod-calend       as char    format "x(8)"           no-undo.
    def input-output param p-dat-fim          as date    format "99/99/9999"     no-undo.
    def input-output param p-qtd-segs-fim     as decimal format "->>>>,>>9.9999" decimals 4 no-undo.
    def input-output param p-dat-inic         as date    format "99/99/9999"     no-undo.
    def input-output param p-qtd-segs-inic    as decimal format "->>>>,>>9.9999" decimals 4 no-undo.
    def input-output param p-qtd-tempo        as decimal format ">,>>>,>>9.99"   decimals 2 no-undo.

    /* procura calendario caso nao seja definido */
    if  p-cod-calend = ? then 
        run DeterminarCalendGrpArea (input 2,  /*** Calend rio do grupo ***/
                                     input p-cod-grp-maq,
                                     output p-cod-calend).

    if  p-dat-inic = ? and 
        p-dat-fim = ? then return.

    if  p-dat-inic <> ? and p-dat-fim = ? then do:
        run pi-determina-fim-evento (input  ?,
                                     input  p-cod-grp-maq,
                                     input  ?,
                                     input  p-cod-calend, 
                                     output p-dat-fim,
                                     output p-qtd-segs-fim,
                                     input  p-dat-inic,
                                     input  p-qtd-segs-inic,
                                     input  p-qtd-tempo).
    end.
    else do:   
        if  p-dat-inic = ? and p-dat-fim <> ? then do:
            run pi-determina-inicio-evento (input  ?,
                                            input  p-cod-grp-maq,
                                            input  ?,
                                            input  p-cod-calend, 
                                            input  p-dat-fim,
                                            input  p-qtd-segs-fim,
                                            output p-dat-inic,
                                            output p-qtd-segs-inic,
                                            input  p-qtd-tempo).
        end.
        else do:
            run pi-determina-tempo-evento-extra (input  ?,
                                                 input  p-cod-grp-maq,
                                                 input  ?,
                                                 input  p-cod-calend, 
                                                 input  p-dat-fim,
                                                 input  p-qtd-segs-fim,
                                                 input  p-dat-inic,
                                                 input  p-qtd-segs-inic,
                                                 output p-qtd-tempo).
        end.
    end.       

END PROCEDURE.


/*****************************************************************************
** Procedure Interna.....: CalcularTemposArea
** Objetivo .............: Determina data/hora final   ou 
                                     data/hora inicial ou
                                     tempo util entre duas datas baseandose
                                     na parametriza‡Æo da area de produ‡Æo.

** PARAMETROS: ENTRADA: grupo de maquina, calendario do grupo de maquina,
**             ENTRADA E SAIDA: 
**             tempo de processo: Em horas 
**             data de inicio 
**             hora de inicio:    Em segundos
**             data final 
**             hora final:        Em segundos
** Parƒmetros ...........: i  p-cod-area
                           io p-cod-calend
                           io p-dat-fim
                           io p-qtd-segs-fim
                           io p-dat-inic
                           io p-qtd-segs-inic
                           io p-qtd-tempo-proces
*****************************************************************************/
PROCEDURE CalcularTemposArea:

    def input        param p-cod-area         as char    format "x(12)"          no-undo.
    def input-output param p-cod-calend       as char    format "x(8)"           no-undo.
    def input-output param p-dat-fim          as date    format "99/99/9999"     no-undo.
    def input-output param p-qtd-segs-fim     as decimal format "->>>>,>>9.9999" decimals 4 no-undo.
    def input-output param p-dat-inic         as date    format "99/99/9999"     no-undo.
    def input-output param p-qtd-segs-inic    as decimal format "->>>>,>>9.9999" decimals 4 no-undo.
    def input-output param p-qtd-tempo        as decimal format ">,>>>,>>9.99"   decimals 2 no-undo.

    /* procura calendario caso nao seja definido */
    if  p-cod-calend = ? then 
        run DeterminarCalendGrpArea (input  1,  /*** Calend rio da area ***/
                                     input  p-cod-area,
                                     output p-cod-calend).

    if  p-dat-inic = ? and 
        p-dat-fim = ? then return.

    if  p-dat-inic <> ? and p-dat-fim = ? then do:
        run pi-determina-fim-evento (input  p-cod-area,
                                     input  ?,
                                     input  ?,
                                     input  p-cod-calend, 
                                     output p-dat-fim,
                                     output p-qtd-segs-fim,
                                     input  p-dat-inic,
                                     input  p-qtd-segs-inic,
                                     input  p-qtd-tempo).
    end.
    else do:   
        if  p-dat-inic = ? and p-dat-fim <> ? then do:
            run pi-determina-inicio-evento (input  p-cod-area,
                                            input  ?,
                                            input  ?,
                                            input  p-cod-calend, 
                                            input  p-dat-fim,
                                            input  p-qtd-segs-fim,
                                            output p-dat-inic,
                                            output p-qtd-segs-inic,
                                            input  p-qtd-tempo).
        end.
        else do:
            run pi-determina-tempo-evento (input  p-cod-area,
                                           input  ?,
                                           input  ?,
                                           input  p-cod-calend, 
                                           input  p-dat-fim,
                                           input  p-qtd-segs-fim,
                                           input  p-dat-inic,
                                           input  p-qtd-segs-inic,
                                           output p-qtd-tempo).
        end.
    end.       

END PROCEDURE.

/********** PROCEDURES INTERNAS AUXILIARES ***********************************/

&IF DEFINED (bf_man_sfc_lc) &THEN

{inbo/boin469b.i7}  /*** Determinar (ModelTurno/Calend) Ctrab ***/

&ENDIF

{inbo/boin469b.i8}  /*** Determinar hora de inicio e fim conforme o turno ***/
{inbo/boin469b.i6}  /*** Determinar (ModelTurno/Calend) GrpArea ***/
{inbo/boin469b.i5}  /*** pi-determina-tempo-evento ***/
{inbo/boin469b.i4}  /*** pi-determina-inicio-evento ***/
{inbo/boin469b.i3}  /*** pi-determina-fim-evento ***/
{inbo/boin469b.i2}  /*** pi-calcular-tempo-resid-dia ***/
{inbo/boin469b.i1}  /*** pi-gera-tt-turno ***/

/* Fim do Programa */

