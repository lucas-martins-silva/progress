/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BH0102BB 2.00.00.006}  /*** 010006 ***/
/********************************************************************************
**  Copyright DATASUL S.A. (1997)
**  Todos os Direitos Reservados.
**
**  Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
**  parcial ou total por qualquer meio, so podera ser feita mediante
**  autorizacao expressa.
**
**  BH0102bb.p - Elimina‡Æo T¡tulos Contas a Receber.
**
**  AUTOR : ANDERSON NASS
*******************************************************************************/          
&GLOBAL-DEFINE BASE  HISADM

/**** MINIFLEXIBILIZACAO ***/
{cdp/cdcfgfin.i}
/***************************/



/*=====  Defini‡Æo dos BUFFERïS   =====*/

DEF BUFFER b-cheque FOR  {&BASE}.cheque.

/*=====================================*/

/*===== Defini‡Æo das  TEMP-TABLES =====*/

/*** TT-CHEQUE ***/
define temp-table tt-cheque like {&BASE}.cheque
       field r-rowid as rowid.

/*** W-PER ***/
{bhp/bh0102.i2}

/*======================================*/

/*=====  Defini‡Æo das variaveis  =====*/

def var i-apaga-titulo  as integer no-undo.
def var i-apaga-mov-tit as integer no-undo.
def var i-apaga-outros  as integer no-undo.
def var i-lido-titulo   as integer no-undo.
def var i-lido-mov-tit  as integer no-undo.
def var i-lido-outros   as integer no-undo.
def var l-bancos-historicos as logical no-undo.
def var h-bh-prog           as handle  no-undo.
&IF "{&mguni_version}" >= "2.071" &THEN
def var i-empresa           LIKE empresa.ep-codigo no-undo.
&ELSE
def var i-empresa           as integer no-undo.
&ENDIF

{include/i-epc200.i "cr0512ab"}
/*=====================================*/


/*---- INICIO ELIMINA€ÇO -----*/
Main-Block:
DO  ON STOP UNDO Main-Block, LEAVE Main-Block:

end.

/*=========================[ PROCEDURES INTERNAS ]==========================*/
{crp/cr0512ab.i}

PROCEDURE pi-cria-bh-periodos :
    for each w-per:
        find first bh-periodos
             where bh-periodos.ep-codigo = w-per.i-emp
             and   bh-periodos.modulos   = w-per.c-mod
             EXCLUSIVE-LOCK no-error.
        if  not avail bh-periodos then do:
            create bh-periodos.
            assign bh-periodos.ep-codigo = w-per.i-emp
                   bh-periodos.modulos   = w-per.c-mod
                   bh-periodos.area      = "A".
        end.
        assign bh-periodos.periodo = w-per.da-per.
    end.

END PROCEDURE.

/*======================[ FIM DAS PROCEDURES INTERNAS ]========================*/

