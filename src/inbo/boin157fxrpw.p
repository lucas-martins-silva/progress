/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN157FXRPW 1.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
    {include/i-license-manager.i boin157fxrpw MCE}
&ENDIF

/******************************************************************************
***       
*** inbo/boin157fxaa.p - Gera Pedidos de Execuá∆o via RPW - Periodico.                  
***                             
******************************************************************************/
/*{cep/ce0703.i2}*/
{utp/ut-glob.i}

def new global shared var v_cod_aplicat_dtsul_corren as character format "x(3)":U  no-undo.
def new global shared var v_cod_grp_usuar_lst        as character format "x(3)":U  no-undo.
def new global shared var v_cod_idiom_usuar          as character format "x(8)":U  no-undo.
def new global shared var v_cod_pais_empres_usuar    as character format "x(3)":U  no-undo.
def new global shared var v_cod_usuar_corren         as character format "x(12)":U no-undo.
def new global shared var v_cod_usuar_corren_criptog as character format "x(16)":U no-undo.

{method/dbotterr.i}

def temp-table tt-retorno-erro no-undo
    field cod-erro         as integer format ">>>>>>>>9":U
    field desc-erro        as character.

def temp-table tt-pedido-execucao no-undo
    field num-ped-exec      as integer format "99999":U
    field data-exec         as date    format "99/99/9999":U
    field hora-exec         as char    format "99:99:99":U.


def temp-table tt-raw-digita no-undo
    field raw-digita   as raw.

DEFINE INPUT  PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT  PARAMETER TABLE FOR tt-raw-digita.
DEFINE INPUT  PARAMETER cArquivo     AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER cProgramName AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER cProgramCode AS INTEGER   NO-UNDO.
DEFINE INPUT  PARAMETER cRpFile      AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER cNumPedido   AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

find first empresa where empresa.ep-codigo = i-ep-codigo-usuario no-lock no-error.
if  not avail empresa then 
    return.

def var c-time-inic  as char    no-undo.
def var c-time-calc  as char    no-undo.
def var c-hora-inic  as char    no-undo.
def var i-hora       as integer no-undo. 
def var i-intervalo  as integer no-undo.
def var i-time-total as int     no-undo.
def var c-intervalo  as char    no-undo.
def var c-hora-rp    as char    no-undo.

DEFINE VARIABLE i AS INTEGER     NO-UNDO.

form
     space(06)
     tt-retorno-erro.cod-erro
     tt-retorno-erro.desc-erro format "x(100)":U
     with width 132 no-box down stream-io frame f-erro.
run utp/ut-trfrrp.p (input frame f-erro:handle).
form
     space(06)
     tt-pedido-execucao.num-ped-exec
     tt-pedido-execucao.data-exec
     tt-pedido-execucao.hora-exec
     with width 132 no-box down stream-io frame f-pedido.

run utp/ut-trfrrp.p (input frame f-pedido:handle).


find first agenda_rpw exclusive-lock
     where agenda_rpw.cdn_modul_refer = 0
     and   agenda_rpw.cdn_operac      = 0
     and   agenda_rpw.cdn_maq_dest    = 0
     and   agenda_rpw.cod_trans_mp    = cProgramName
     and   agenda_rpw.cod_trans_cld   = cProgramName
     and   agenda_rpw.cdn_trans_edi   = cProgramCode
     and   agenda_rpw.num_parcei_edi  = cProgramCode
     no-error.

if  not avail agenda_rpw then do:
    create agenda_rpw.
    assign agenda_rpw.cdn_modul_refer = 0
           agenda_rpw.cdn_operac      = 0
           agenda_rpw.cdn_maq_dest    = 0
           agenda_rpw.cod_trans_mp    = cProgramName
           agenda_rpw.cod_trans_cld   = cProgramName
           agenda_rpw.cdn_trans_edi   = cProgramCode
           agenda_rpw.num_parcei_edi  = cProgramCode.
end.

assign c-hora-rp               = string(time + 1800, "HH:MM":U)
       c-time-inic             = string(substr(c-hora-rp,1,2), "99":U) + "0000":U
       c-hora-inic             = string(substr(c-hora-rp,1,2), "99":U) + "0000":U
       c-time-calc             = string(time, "HH:MM:SS":U)
       c-time-calc             = replace(c-time-calc, ":":U, "":U)
       i-hora                  = int(substr(c-hora-rp,1,2)) * 60 * 60
       i-intervalo             = int(substr(c-hora-rp,4,2)) * 60 * 60
       i-intervalo             = i-intervalo + (30 * 60)
       agenda_rpw.dat_ult_exec = today
       agenda_rpw.num_livre_1  = 00
       agenda_rpw.num_livre_2  = 30.

/********************************************************
 Se o usu†rio informou uma data inferior a data atual do 
 sistema ent∆o ser† gerado o pedido RPW no pr¢ximo
 intervalo v†lido da peridiocidade informada.
 ********************************************************/

if  int(c-time-inic) < int(c-time-calc) then do:
    assign i-time-total = int(c-hora-inic)
           c-intervalo  = string(i-intervalo, "HH:MM:SS":U)
           c-intervalo  = replace(c-intervalo, ":":U, "":U).

    if  c-intervalo = "000000":U then
        assign c-intervalo = "240000":U.

    repeat:

        if  int(c-time-inic) < int(c-time-calc) then do:

            /*******************************************************
            A l¢gica abaixo Ç para o controle de quando o intervalo
            ultrapassar o dia seguinte, neste caso dever† ser somado
            um dia na data da geraá∆o do pedido.
            *******************************************************/

            assign i-time-total = i-time-total + int(c-intervalo).

            if  i-time-total >= 240000 then do:
                assign agenda_rpw.dat_ult_exec = agenda_rpw.dat_ult_exec + 1
                       c-time-inic = string(int(i-time-total - 240000), "999999":U).
                leave.
            end.

            /*******************************************************/

            assign i-hora      = i-hora + i-intervalo
                   c-time-inic = string(i-hora, "HH:MM:SS":U)
                   c-time-inic = replace(c-time-inic, ":":U, "":U).

        end.
        ELSE DO:
            LEAVE.
        END.

    end.
end.

assign agenda_rpw.hra_ult_exec = c-time-inic.

run inbo/boin157fxrpw2.p (input  raw-param, 
                          input  table tt-raw-digita,
                          INPUT  cArquivo,
                          input  cProgramName,
                          input  cProgramCode,
                          input  cRpFile,
                          output table tt-pedido-execucao,
                          output table tt-retorno-erro).

find first tt-retorno-erro no-lock no-error.
if  avail tt-retorno-erro then do:

    {utp/ut-liter.i Houve_erro_na_geraá∆o_do_pedido,_processo_n∆o_conclu°do!!!}
    put trim(RETURN-VALUE) format "x(100)":U skip(2).

    EMPTY TEMP-TABLE RowErrors.

    ASSIGN i = 0.

    for each tt-retorno-erro:
        ASSIGN i = i + 1.
        CREATE RowErrors.
        ASSIGN RowErrors.ErrorSequence = i
               RowErrors.ErrorNumber = tt-retorno-erro.cod-erro
               RowErrors.ErrorDescription = tt-retorno-erro.desc-erro
               RowErrors.ErrorType = "ERROR":U.
    end.
end.
else do:
    {utp/ut-liter.i Foi_Gerado_o_Pedido_Abaixo:}
    put "      ":U trim(RETURN-VALUE) format "x(100)":U skip(2).

    for each tt-pedido-execucao:
        ASSIGN cNumPedido = STRING(tt-pedido-execucao.num-ped-exec).
    end. 
end.

/* Fim de Programa */
