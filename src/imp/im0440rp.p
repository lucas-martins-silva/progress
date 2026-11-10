/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0440RP 2.00.00.013 } /*** "010013" 22/01/2026 14:18:20  ***/
/*****************************************************************************
**
**       Programa: IM0440RP.P
**
**       Data....: 01/03/2012
**
**       Autor...: DATASUL S.A.
**
**       Objetivo: Relat¢rio da Declara‡Æo de importa‡Æo
**
**       Vers’o..: 1.00.000 - imp
**
**       OBS.....: Relat¢rio em excel
**
*******************************************************************************/

/****************** Defini»’o de Tabelas Temporÿrias do Relat½rio **********************/

def temp-table tt-raw-digita
    field raw-digita as raw.

define temp-table tt-param no-undo
    field c-diems-ini         LIKE decla-import.num-di-ems
    field c-diems-fim         LIKE decla-import.num-di-ems
    field c-siscomex-ini      LIKE decla-import.cod-di-siscomex
    field c-siscomex-fim      LIKE decla-import.cod-di-siscomex
    FIELD d-datadi-ini        LIKE decla-import.dat-di
    FIELD d-datadi-fim        LIKE decla-import.dat-di
    FIELD c-estab-ini         LIKE decla-import.cod-estab
    FIELD c-estab-fim         LIKE decla-import.cod-estab
    FIELD c-via-transp-ini    AS CHAR FORMAT "x(16)"
    FIELD c-via-transp-fim    AS CHAR FORMAT "x(16)"
    FIELD l-Obervacoes        as logical format "Sim/NÆo"
    FIELD l-transporte        as logical format "Sim/NÆo"
    FIELD l-Itinerario        as logical format "Sim/NÆo"
    FIELD l-Despesas          as logical format "Sim/NÆo"
    FIELD l-cus-nacio         as logical format "Sim/NÆo"
    FIELD l-listaradicoes     as logical format "Sim/NÆo"
    FIELD l-despesas-adicoes  as logical format "Sim/NÆo"
    FIELD l-LItens            as logical format "Sim/NÆo"
    FIELD l-cambio            as logical format "Sim/NÆo"
    FIELD rsDestiny           AS INTEGER
    FIELD rsExecution         as logical format "Sim/NÆo"
    field destino             as integer
    field arquivo             as char format "x(35)":U
    field usuario             as char format "x(12)":U
    field data-exec           as date format "99/99/9999"
    field hora-exec           as integer
    field classifica          as integer
    field desc-classifica     as char format "x(40)":U
    field modelo              AS char format "x(35)":U
    /*Alterado 15/02/2005 - tech1007 - Criado campo l¢gico para verificar se o RTF foi habilitado*/
    field l-habilitaRtf       as LOGICAL FORMAT "Sim/NÆo".
    /*Fim alteracao 15/02/2005*/

define temp-table tt-digita no-undo
    field num-di-ems        LIKE decla-import.num-di-ems
    field cod-di-siscomex   LIKE decla-import.cod-di-siscomex
    FIELD data-di           LIKE decla-import.dat-di.

{cxbo/bocx383.i tt-decla-import}

FOR FIRST tt-raw-digita:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita TO tt-digita.
END.

/****************** INCLUDE COM VARIæVEIS GLOBAIS *********************/
/*** In­cio ut-glob.i Defini»’o de variÿveis globais ***/ 

&if  defined(GLOBALS) &then 

&else
     &glob GLOBALS ok 

     def new global shared var i-ep-codigo-usuario  like empresa.ep-codigo no-undo.
     def new Global shared var l-implanta           as logical    init no.
     def new Global shared var c-seg-usuario        as char format "x(12)" no-undo.
     def new global shared var i-num-ped-exec-rpw  as integer no-undo.   
     def var rw-log-exec                            as rowid no-undo.
     def new global shared var i-pais-impto-usuario as integer format ">>9" no-undo.
     def new global shared var l-rpc as logical no-undo.
     def new global shared temp-table tt-servid-rpc-aplicat
         field tta-cod-aplicat-dtsul like aplicat_dtsul.cod_aplicat_dtsul
         field tta-hdl-servid-rpc    as   handle.
     def var c-erro-rpc as character format "x(60)" initial " " no-undo.
     def var c-erro-aux as character format "x(60)" initial " " no-undo.
     def new global shared var r-registro-atual as rowid no-undo.
     def new global shared var c-arquivo-log    as char  format "x(60)"no-undo.

      /* Variÿveis Padr’o DWB / Datasul HR */
     def new global shared var i-num-ped as integer no-undo.         
     def new global shared var v_cdn_empres_usuar   like empresa.ep-codigo        no-undo.
     def new global shared var v_cod_usuar_corren   like usuar_mestre.cod_usuario no-undo.
     def new global shared var h_prog_segur_estab     as handle                   no-undo.
     def new global shared var v_cod_grp_usuar_lst    as char                     no-undo.
     def new global shared var v_num_tip_aces_usuar   as int                      no-undo.     
&endif

/*** Fim ut-glob.i Defini»’o de variÿveis globais ***/ /****************** FIM INCLUDE COM VARIæVEIS GLOBAIS *********************/
/****************** Defini»ao de Par³metros do Relat½rio *********************/ 

def new shared var l-lista-req as logical format "Sim/N’o" label "Lista requisi»’o" view-as toggle-box.
def new shared var l-lista-dev as logical format "Sim/N’o" label "Lista devolu»’o" view-as toggle-box.


/****************** Defini»ao de Variÿveis de Sele»’o do Relat½rio *********************/ 

def new shared var c-diems-ini     LIKE decla-import.num-di-ems.
def new shared var c-diems-fim     LIKE decla-import.num-di-ems.       
def new shared var c-siscomex-ini  LIKE decla-import.cod-di-siscomex.
def new shared var c-siscomex-fim  LIKE decla-import.cod-di-siscomex.  
def new shared var d-datadi-ini    LIKE decla-import.dat-di.
def new shared var d-datadi-fim    LIKE decla-import.dat-di.          
def new shared var c-estab-ini     LIKE decla-import.cod-estab.
def new shared var c-estab-fim     LIKE decla-import.cod-estab.       

/****************** Defini»ao de Variÿveis p/ Campos Virtuais do Relat½rio *******************/ 

/*###define variable movto-estoq-ext-esp-docto as character no-undo.*/

/****************** Defini»ao de Variÿveis Campo do Layout do Relat½rio **********************/ 

/****************** Defini»ao de Variÿveis do Relat½rio N’o Pedidas em Tela ******************/ 

/****************** Defini»ao de Variÿveis de Total do Relat½rio *****************************/ 

/*def var de-quantidade-tt-001 like movto-estoq.quantidade no-undo.*/

/****************** Defini»ao de Variÿveis dos Calculos do Relat½rio *************************/ 

def input param raw-param as raw no-undo.
def input param table for tt-raw-digita.
DEF VAR c-formato AS CHAR NO-UNDO.
DEF VAR c-txt01 AS CHAR NO-UNDO.
DEF VAR c-txt02 AS CHAR NO-UNDO.

/****************** Defini»ao de Variÿveis de Processamento do Relat½rio *********************/

def var h-im0440 as handle no-undo.
def var v-cod-destino-impres as char   no-undo.
def var v-num-reg-lidos      as int    no-undo.
def var v-num-point          as int    no-undo.
def var v-num-set            as int    no-undo.

DEF VAR i-via-transp-ini AS INT NO-UNDO.
DEF VAR i-via-transp-fim AS INT NO-UNDO.

def var i-empresa LIKE param-global.empresa-prin.

find first param-estoq  no-lock no-error.
find first param-global no-lock no-error.      

/****************** Defini»ao de Forms do Relat½rio 132 Colunas ***************************************/ 

create tt-param.
raw-transfer raw-param to tt-param.


def temp-table tt-editor no-undo
    field linha      as integer
    field conteudo   as character format 'x(80)'
    index editor-id is primary unique 
          linha.

/* In­cio i-rpvar */

define var c-empresa      as character format "x(40)" no-undo.
define var c-titulo-relat as character format "x(50)" no-undo.
define var c-sistema      as character format "x(25)" no-undo.
define var i-numper-x     as integer   format "ZZ"    no-undo.
define var da-iniper-x    as date format "99/99/9999" no-undo.
define var da-fimper-x    as date format "99/99/9999" no-undo.
define var c-rodape       as character                no-undo.
define var c-use-task-manager as character                  no-undo.  
define var l-use-task-manager as logical                    no-undo. 
DEF VAR i-num_lin_pag                               AS INT      NO-UNDO.    
DEF VAR c-cod_pag_carac_conver                      AS CHAR     NO-UNDO.   
define var v_num_count    as integer                  no-undo.

define var c-programa     as character format "x(08)" no-undo.
define var c-versao       as character format "x(04)" no-undo.
define var c-revisao      as character format "999"   no-undo.

define var c-impressora   as char no-undo.
define var c-layout       as char no-undo.

def buffer b_ped_exec_style for ped_exec.
def buffer b_servid_exec_style for servid_exec.

/* Fim i-rpvar */
FIND FIRST tt-param NO-LOCK NO-ERROR.
IF tt-param.classifica = 1 THEN DO:
    {utp/ut-liter.i "Relat¢rio da Declara‡Æo de Importa‡Æo Por Adi‡Æo" *}
    assign c-programa     = "im0440a":U
           c-versao       = "1.00":U
           c-revisao      = "000":U
           c-titulo-relat = RETURN-VALUE
           c-sistema      = "".
END.
ELSE DO:
    {utp/ut-liter.i "Relat¢rio da Declara‡Æo de Importa‡Æo Por Embarque" *}
    assign c-programa     = "im0440b":U
           c-versao       = "1.00":U
           c-revisao      = "000":U
           c-titulo-relat = RETURN-VALUE
           c-sistema      = "".
END.


    /* In­cio i-rpcab.i */

    {utp/ut-liter.i "Folha:" *}
    Assign c-txt01=Return-Value.
    {utp/ut-liter.i "Periodo:" *}
    Assign c-txt02=Return-Value.

   &IF  "{&stream}" = "" &THEN

   form header
       fill("-", 132) format "x(132)" skip
       c-empresa c-titulo-relat at 50
       c-txt01 at 122 format "x(6)" page-number  at 128 format ">>>>9" skip
       fill("-", 112) format "x(110)" today format "99/99/9999"
       "-" string(time, "HH:MM:SS") skip(1)
       with stream-io width 132 no-labels no-box page-top frame f-cabec.

   form header
       fill("-", 132) format "x(132)" SKIP
       c-empresa c-titulo-relat at 50
       c-txt01 at 122 format "x(6)" PAGE-NUMBER  at 128 format ">>>>9" skip
       c-txt02 i-numper-x at 10 "-"
       da-iniper-x at 15 "a" da-fimper-x
       fill("-", 74) format "x(72)" TODAY FORMAT "99/99/9999"
       "-" string(time, "HH:MM:SS") SKIP(1)
       with stream-io width 132 no-labels no-box page-top frame f-cabper.

   &ELSE

   form header
       fill("-", 132) format "x(132)" skip
       c-empresa c-titulo-relat at 50
       c-txt01 at 122 format "x(6)" page-number({&stream})  at 128 format ">>>>9" skip
       fill("-", 112) format "x(110)" today format "99/99/9999"
       "-" string(time, "HH:MM:SS") skip(1)
       with stream-io width 132 no-labels no-box page-top frame f-cabec.

   form header
       fill("-", 132) format "x(132)" skip
       c-empresa c-titulo-relat at 50
       c-txt01 at 122 format "x(6)" page-number({&stream})  at 128 format ">>>>9" skip
       c-txt02 i-numper-x at 10 "-"
       da-iniper-x at 15 "a" da-fimper-x
       fill("-", 74) format "x(72)" today format "99/99/9999"
       "-" string(time, "HH:MM:SS") skip(1)
       with stream-io width 132 no-labels no-box page-top frame f-cabper.

   &ENDIF

   c-rodape = "DATASUL - " + c-sistema + " - " + c-programa + " - V:" + c-versao + "." + c-revisao.
   c-rodape = fill("-", 132 - length(c-rodape)) + c-rodape.

   form header
       c-rodape format "x(132)"
       with stream-io width 132 no-labels no-box page-bottom frame f-rodape.

   /* Fim i-rpcab.i */

/*** In­cio i-rpout.i ***/

def new global shared var c-dir-spool-servid-exec as char no-undo.
def new global shared var i-num-ped-exec-rpw as int no-undo.
def var c-arq-control as char no-undo.

if  tt-param.destino = 1 then do:
   &if "{&tofile}" = "" &then 
    if num-entries(tt-param.arquivo,":") = 2 then do:
   &elseif "{&tofile}" <> "" &then
    if num-entries({&tofile},":") = 2 then do:
   &endif.                            
    &if "{&tofile}" = "" &then 
        assign c-impressora = substring(tt-param.arquivo,1,index(tt-param.arquivo,":") - 1).
        assign c-layout     = substring(tt-param.arquivo,index(tt-param.arquivo,":") + 1,length(tt-param.arquivo) - index(tt-param.arquivo,":")). 
    &elseif "{&tofile}" <> "" &then
        assign c-impressora = substring({&tofile},1,index({&tofile},":") - 1).
        assign c-layout     = substring({&tofile},index({&tofile},":") + 1,length({&tofile}) - index({&tofile},":")). 
    &endif.                            

    find layout_impres no-lock
        where layout_impres.nom_impressora    = c-impressora
        and   layout_impres.cod_layout_impres = c-layout no-error.
    find imprsor_usuar no-lock
        where imprsor_usuar.nom_impressora = c-impressora
        and   imprsor_usuar.cod_usuario    = tt-param.usuario
        use-index imprsrsr_id no-error.
    find impressora  of imprsor_usuar no-lock no-error.
    find tip_imprsor of impressora    no-lock no-error.

    if  i-num-ped-exec-rpw <> 0 then do:
             find b_ped_exec_style where b_ped_exec_style.num_ped_exec = i-num-ped-exec-rpw no-lock no-error. 
             RUN getProperty (INPUT "use.task.manager", OUTPUT c-use-task-manager).
             ASSIGN l-use-task-manager = LOGICAL(c-use-task-manager) NO-ERROR.

             IF l-use-task-manager THEN DO:
                FIND ped_exec_param NO-LOCK
                    WHERE ped_exec_param.num_ped_exec = b_ped_exec_style.num_ped_exec.
                FIND b_servid_exec_style NO-LOCK
                    WHERE b_servid_exec_style.cod_servid_exec = b_ped_exec_style.cod_servid_exec
                      AND b_servid_exec_style.cdn_empres_servid = ENTRY(3,ped_exec_param.cod_empresa,CHR(10))
                      AND b_servid_exec_style.log_livre_2 = TRUE NO-ERROR.

                IF OPSYS = 'UNIX' THEN
                    ASSIGN i-num_lin_pag          = layout_impres.num_lin_pag
                           c-cod_pag_carac_conver = tip_imprsor.cod_pag_carac_conver.
             END.
             ELSE DO:   
                FIND b_servid_exec_style 
                    WHERE b_servid_exec_style.cod_servid_exec = b_ped_exec_style.cod_servid_exec 
                      AND b_servid_exec_style.log_livre_2 = FALSE NO-LOCK NO-ERROR.

                IF AVAILABLE b_servid_exec_style AND b_servid_exec_style.ind_tip_fila_exec = 'UNIX' THEN
                    ASSIGN i-num_lin_pag          = layout_impres.num_lin_pag
                           c-cod_pag_carac_conver = tip_imprsor.cod_pag_carac_conver.
             END.        find servid_exec_imprsor of b_servid_exec_style no-lock no-error.

        if  available b_servid_exec_style and b_servid_exec_style.ind_tip_fila_exec = 'UNIX'
        then do:
            if layout_impres.num_lin_pag = 0 then do:
               output {&stream} through to servid_exec_imprsor.nom_disposit_so
                      page-size 0 convert target tip_imprsor.cod_pag_carac_conver.
            end.
            else do:
               output {&stream} through value(servid_exec_imprsor.nom_disposit_so)
                      paged page-size value(layout_impres.num_lin_pag) convert target tip_imprsor.cod_pag_carac_conver.
            end.
        end /* if */.
        else do:
            if layout_impres.num_lin_pag = 0 then do:
               output {&stream}  to value(servid_exec_imprsor.nom_disposit_so)
                      page-size 0 convert target tip_imprsor.cod_pag_carac_conver.
            end.
            else do:
               output {&stream} to value(servid_exec_imprsor.nom_disposit_so)
                      paged page-size value(layout_impres.num_lin_pag) convert target tip_imprsor.cod_pag_carac_conver.
            end.
        end /* else */.
    end.
    else do:
        if layout_impres.num_lin_pag = 0 then do:
            /* sem salta pÙgina */
            output  {&stream} 
                    to value(imprsor_usuar.nom_disposit_so)
                    page-size 0
                    convert target tip_imprsor.cod_pag_carac_conver . 
        end.
        else do:
            /* com salta pÿgina */
            output {&stream} 
                    to value(imprsor_usuar.nom_disposit_so)
                    paged page-size value(layout_impres.num_lin_pag) 
                    convert target tip_imprsor.cod_pag_carac_conver.
        end.
    end.

    for each configur_layout_impres no-lock
        where configur_layout_impres.num_id_layout_impres = layout_impres.num_id_layout_impres
        by configur_layout_impres.num_ord_funcao_imprsor:

        find configur_tip_imprsor no-lock
            where configur_tip_imprsor.cod_tip_imprsor        = layout_impres.cod_tip_imprsor
            and   configur_tip_imprsor.cod_funcao_imprsor     = configur_layout_impres.cod_funcao_imprsor
            and   configur_tip_imprsor.cod_opc_funcao_imprsor = configur_layout_impres.cod_opc_funcao_imprsor
            use-index cnfgrtpm_id no-error.

        do v_num_count = 1 to extent(configur_tip_imprsor.num_carac_configur):
          case configur_tip_imprsor.num_carac_configur[v_num_count]:
            when 0 then put {&stream} control null.
            when ? then leave.
            otherwise   put {&stream} control CODEPAGE-CONVERT(chr(configur_tip_imprsor.num_carac_configur[v_num_count]),
                                                               session:cpinternal, 
                                                               tip_imprsor.cod_pag_carac_conver).
          end case.
        end.
    end.
  end.
  else do:
    &if "{&tofile}" = "" &then 
        assign c-impressora  = entry(1,tt-param.arquivo,":").
        assign c-layout      = entry(2,tt-param.arquivo,":"). 
        if num-entries(tt-param.arquivo,":") = 4 then
          assign c-arq-control = entry(3,tt-param.arquivo,":") + ":" + entry(4,tt-param.arquivo,":").
        else 
          assign c-arq-control = entry(3,tt-param.arquivo,":").
    &elseif "{&tofile}" <> "" &then
        assign c-impressora  = entry(1,{&tofile},":").
        assign c-layout      = entry(2,{&tofile},":").
      &if "{&tofile}" = "" &then 
        if num-entries(tt-param.arquivo,":") = 4 then
      &elseif "{&tofile}" <> "" &then
        if num-entries({&tofile},":") = 4 then
      &endif
          assign c-arq-control = entry(3,{&tofile},":") + ":" + entry(4,{&tofile},":").
        else
          assign c-arq-control = entry(3,{&tofile},":").
    &endif.                            

    find layout_impres no-lock
        where layout_impres.nom_impressora    = c-impressora
        and   layout_impres.cod_layout_impres = c-layout no-error.
    find imprsor_usuar no-lock
        where imprsor_usuar.nom_impressora = c-impressora
        and   imprsor_usuar.cod_usuario    = tt-param.usuario
        use-index imprsrsr_id no-error.
    find impressora  of imprsor_usuar no-lock no-error.
    find tip_imprsor of impressora    no-lock no-error.

    if  i-num-ped-exec-rpw <> 0 then do:
        find b_ped_exec_style where b_ped_exec_style.num_ped_exec = i-num-ped-exec-rpw no-lock no-error. 

        RUN getProperty (INPUT "use.task.manager", OUTPUT c-use-task-manager).
        ASSIGN l-use-task-manager = LOGICAL(c-use-task-manager) NO-ERROR.

        IF l-use-task-manager THEN DO:
           FIND ped_exec_param NO-LOCK
               WHERE ped_exec_param.num_ped_exec = b_ped_exec_style.num_ped_exec.
           FIND b_servid_exec_style NO-LOCK
               WHERE b_servid_exec_style.cod_servid_exec = b_ped_exec_style.cod_servid_exec
                 AND b_servid_exec_style.cdn_empres_servid = ENTRY(3,ped_exec_param.cod_empresa,CHR(10))
                 AND b_servid_exec_style.log_livre_2 = TRUE NO-ERROR.

           IF OPSYS = 'UNIX' THEN
                ASSIGN i-num_lin_pag          = layout_impres.num_lin_pag
                       c-arq-control          = c-dir-spool-servid-exec + "~/" + c-arq-control
                       c-cod_pag_carac_conver = tip_imprsor.cod_pag_carac_conver.
        END.
        ELSE DO:   
           FIND b_servid_exec_style 
               WHERE b_servid_exec_style.cod_servid_exec = b_ped_exec_style.cod_servid_exec 
                 AND b_servid_exec_style.log_livre_2 = FALSE NO-LOCK NO-ERROR.

           IF AVAILABLE b_servid_exec_style AND b_servid_exec_style.ind_tip_fila_exec = 'UNIX' THEN
                ASSIGN i-num_lin_pag          = layout_impres.num_lin_pag
                       c-arq-control          = c-dir-spool-servid-exec + "~/" + c-arq-control
                       c-cod_pag_carac_conver = tip_imprsor.cod_pag_carac_conver.
        END.
        find servid_exec_imprsor of b_servid_exec_style no-lock no-error.

        if  available b_servid_exec_style and b_servid_exec_style.ind_tip_fila_exec = 'UNIX'
        then do:
            if layout_impres.num_lin_pag = 0 then do:
               output {&stream} to value(c-dir-spool-servid-exec + "~/" + c-arq-control)
                      page-size 0 convert target tip_imprsor.cod_pag_carac_conver.
            end.
            else do:
               output {&stream} to value(c-dir-spool-servid-exec + "~/" + c-arq-control)
                      paged page-size value(layout_impres.num_lin_pag) convert target tip_imprsor.cod_pag_carac_conver.
            end.
        end /* if */.
        else do:
            if layout_impres.num_lin_pag = 0 then do:
               output {&stream}  to value(c-dir-spool-servid-exec + "~/" + c-arq-control)
                      page-size 0 convert target tip_imprsor.cod_pag_carac_conver.
            end.
            else do:
               output {&stream} to value(c-dir-spool-servid-exec + "~/" + c-arq-control)
                      paged page-size value(layout_impres.num_lin_pag) convert target tip_imprsor.cod_pag_carac_conver.
            end.
        end /* else */.
    end.
    else do:
        if layout_impres.num_lin_pag = 0 then do:
            /* sem salta pÙgina */
            output  {&stream} 
                    to value(c-arq-control)
                    page-size 0
                    convert target tip_imprsor.cod_pag_carac_conver . 
        end.
        else do:
            /* com salta pÿgina */
            output {&stream} 
                    to value(c-arq-control)
                    paged page-size value(layout_impres.num_lin_pag) 
                    convert target tip_imprsor.cod_pag_carac_conver.
        end.
    end.

    for each configur_layout_impres no-lock
        where configur_layout_impres.num_id_layout_impres = layout_impres.num_id_layout_impres
        by configur_layout_impres.num_ord_funcao_imprsor:

        find configur_tip_imprsor no-lock
            where configur_tip_imprsor.cod_tip_imprsor        = layout_impres.cod_tip_imprsor
            and   configur_tip_imprsor.cod_funcao_imprsor     = configur_layout_impres.cod_funcao_imprsor
            and   configur_tip_imprsor.cod_opc_funcao_imprsor = configur_layout_impres.cod_opc_funcao_imprsor
            use-index cnfgrtpm_id no-error.

        do v_num_count = 1 to extent(configur_tip_imprsor.num_carac_configur):
          case configur_tip_imprsor.num_carac_configur[v_num_count]:
            when 0 then put {&stream} control null.
            when ? then leave.
            otherwise   put {&stream} control CODEPAGE-CONVERT(chr(configur_tip_imprsor.num_carac_configur[v_num_count]),
                                                               session:cpinternal, 
                                                               tip_imprsor.cod_pag_carac_conver).
          end case.
        end.
    end.
  end.  
end.
else do:
    &if "{&tofile}" = "" &then
        if  i-num-ped-exec-rpw <> 0 then do:
            output {&stream} 
                   to value(c-dir-spool-servid-exec + "~/" + tt-param.arquivo) 
                   paged page-size 64
                   convert target "iso8859-1" {&append}.
        end.                             
        else do:
            output {&stream} 
                   to value(tt-param.arquivo) 
                   paged page-size 64 
                   convert target "iso8859-1" {&append}.
        end.    
    &else    
        if  i-num-ped-exec-rpw <> 0 then do:
            output {&stream} 
                   to value(c-dir-spool-servid-exec + "~/" + {&tofile}) 
                   paged page-size 64
                   convert target "iso8859-1" {&append}.         
        end.        
        else do:
            output {&stream} 
                   to value({&tofile}) 
                   paged page-size 64 
                   convert target "iso8859-1" {&append}.         
        end.  
    &endif
end.

/*** Fim i-rpout.i ***/

    /*assign i-ep-codigo-usuario = tt-param.ep-codigo
           v_cdn_empres_usuar  = i-ep-codigo-usuario.*/

    assign c-diems-ini      = tt-param.c-diems-ini     
           c-diems-fim      = tt-param.c-diems-fim     
           c-siscomex-ini   = tt-param.c-siscomex-ini  
           c-siscomex-fim   = tt-param.c-siscomex-fim  
           d-datadi-ini     = tt-param.d-datadi-ini    
           d-datadi-fim     = tt-param.d-datadi-fim    
           c-estab-ini      = tt-param.c-estab-ini     
           c-estab-fim      = tt-param.c-estab-fim
           c-via-transp-ini = tt-param.c-via-transp-ini
           c-via-transp-fim = tt-param.c-via-transp-fim.

&GLOB LANGUAGE-CODE POR 
/* Inicio var00002.i */ 

&IF "{&LANGUAGE-CODE}" = "POR":U &THEN
&glob val1 Impressora
&glob val2 Arquivo
&glob val3 Terminal
&ENDIF

&IF "{&LANGUAGE-CODE}" = "ESP":U &THEN
&glob val1 Impresora
&glob val2 Archivo
&glob val3 Terminal
&ENDIF

&IF "{&LANGUAGE-CODE}" = "ING":U &THEN
&glob val1 Printer
&glob val2 File
&glob val3 Terminal
&ENDIF
&if "{&val11}" <> "" &then
    &message *** ({&file-name}): Para indicadores com mais de 10 items deve ser usado o include ind11-50.i !
&endif

&if  ("{1}" = "04" or "{1}" = "4") and "{2}" = "" &then
    &message *** ({&file-name}): Para a funcao ITEM deve ser especificado o valor !
    &message *** Exemplo: ind01-10.i 04 1
&endif

&if  ("{1}" = "06"  or "{1}" = "6") and  "{2}" = "" &then
    &message *** ({&file-name}): Para a funcao IND deve ser especificado o elemento !
    &message *** Exemplo: ind01-10.i 06 string

&endif

&if  lookup("{1}", "03,04,05,06,3,4,5,6") &then
     &scop lista-items {&val1}
     &if  "{&val2}" <> "" &then
          &scop lista-items {&lista-items},{&val2}
     &endif
     &if  "{&val3}" <> "" &then
          &scop lista-items {&lista-items},{&val3}
     &endif
     &if  "{&val4}" <> "" &then
          &scop lista-items {&lista-items},{&val4}
     &endif
     &if  "{&val5}" <> "" &then
          &scop lista-items {&lista-items},{&val5}
     &endif
     &if  "{&val6}" <> "" &then
          &scop lista-items {&lista-items},{&val6}
     &endif
     &if  "{&val7}" <> "" &then
          &scop lista-items {&lista-items},{&val7}
     &endif
     &if  "{&val8}" <> "" &then
          &scop lista-items {&lista-items},{&val8}
     &endif
     &if  "{&val9}" <> "" &then
          &scop lista-items {&lista-items},{&val9}
     &endif
     &if  "{&val10}" <> "" &then
          &scop lista-items {&lista-items},{&val10}
     &endif
&endif

&if "{1}" = "01" or "{1}" = "1" &then
    "{&val1}"
    &if "{&val2}" <> "" &then
        , "{&val2}"
    &endif
    &if "{&val3}" <> "" &then
        , "{&val3}"
    &endif
    &if "{&val4}" <> "" &then
        , "{&val4}"
    &endif
    &if "{&val5}" <> "" &then
        , "{&val5}"
    &endif
    &if "{&val6}" <> "" &then
        , "{&val6}"
    &endif
    &if "{&val7}" <> "" &then
        , "{&val7}"
    &endif
    &if "{&val8}" <> "" &then
        , "{&val8}"
    &endif
    &if "{&val9}" <> "" &then
        , "{&val9}"
    &endif
    &if "{&val10}" <> "" &then
        , "{&val10}"
    &endif
&endif

&if  "{1}" = "02" or "{1}" = "2" &then
    "{&val1}", 1
    &if "{&val2}" <> "" &then
         , "{&val2}", 2
    &endif
    &if "{&val3}" <> "" &then
         , "{&val3}", 3    
    &endif
    &if "{&val4}" <> "" &then
         , "{&val4}", 4    
    &endif
    &if "{&val5}" <> "" &then
         , "{&val5}", 5    
    &endif
    &if "{&val6}" <> "" &then
         , "{&val6}", 6    
    &endif
    &if "{&val7}" <> "" &then
         , "{&val7}", 7    
    &endif
    &if "{&val8}" <> "" &then
         , "{&val8}", 8    
    &endif
    &if "{&val9}" <> "" &then
         , "{&val9}", 9    
    &endif
    &if "{&val10}" <> "" &then
         , "{&val10}", 10    
    &endif
&endif

&if  "{1}" = "03"  or "{1}" = "3" &then
     '{&lista-items}'
&endif

&if  "{1}" = "05" or "{1}" = "5" &then
     num-entries("{&lista-items}")
&endif

&if "{1}" = "04" or "{1}" = "4" &then
     entry({2}, "{&lista-items}")
&endif


&if  ("{1}" = "06" or "{1}" = "6") and "{2}" <> "" &then
     lookup({2}, "{&lista-items}")
&endif

&if "{1}" = "07" or "{1}" = "7" &then
    &if "{2}" <> "" &then
        assign {2}:list-items = "{&val1}".
        &if defined(val2) > 0 &then
            assign {2}:list-items = {2}:list-items + "," + "{&val2}".
        &endif
        &if defined(val3) > 0 &then
            assign {2}:list-items = {2}:list-items + "," + "{&val3}".
        &endif
        &if defined(val4) > 0 &then
            assign {2}:list-items = {2}:list-items + "," + "{&val4}".
        &endif
        &if defined(val5) > 0 &then
            assign {2}:list-items = {2}:list-items + "," + "{&val5}".
        &endif
        &if defined(val6) > 0 &then
            assign {2}:list-items = {2}:list-items + "," + "{&val6}".
        &endif
        &if defined(val7) > 0 &then
            assign {2}:list-items = {2}:list-items + "," + "{&val7}".
        &endif
        &if defined(val8) > 0 &then
            assign {2}:list-items = {2}:list-items + "," + "{&val8}".
        &endif
        &if defined(val9) > 0 &then
            assign {2}:list-items = {2}:list-items + "," + "{&val9}".
        &endif
        &if defined(val10) > 0 &then
            assign {2}:list-items = {2}:list-items + "," + "{&val10}".
        &endif
    &endif
&endif

&if defined(lista-items) > 0 &then
    &undefine lista-items
&endif
&if defined(val1) > 0 &then
    &undefine val1
&endif
&if defined(val2) > 0 &then
    &undefine val2
&endif
&if defined(val3) > 0 &then
    &undefine val3
&endif
&if defined(val4) > 0 &then
    &undefine val4
&endif
&if defined(val5) > 0 &then
    &undefine val5
&endif
&if defined(val6) > 0 &then
    &undefine val6
&endif
&if defined(val7) > 0 &then
    &undefine val7
&endif
&if defined(val8) > 0 &then
    &undefine val8
&endif
&if defined(val9) > 0 &then
    &undefine val9
&endif
&if defined(val10) > 0 &then
    &undefine val10
&endif

find first empresa no-lock
    where empresa.ep-codigo = i-ep-codigo-usuario no-error.
if  avail empresa
then
    assign c-empresa = empresa.razao-social.
else
    assign c-empresa = "".

/* for each e disp */

def var l-imprime as logical no-undo.

assign l-imprime = no.
if  tt-param.destino = 1
then
    assign v-cod-destino-impres = "Impressora".
else
    if  tt-param.destino = 2
    then
        assign v-cod-destino-impres = "Arquivo".
    else
        assign v-cod-destino-impres = "Terminal".


run utp/ut-acomp.p persistent set h-im0440.

{utp/ut-liter.i "Item" *}
run pi-inicializar in h-im0440(input RETURN-VALUE).

assign v-num-reg-lidos = 0.

/*##### montagem das temp-tables necessarias para gerar o relat¢rio.*/
FOR FIRST tt-param: END.

ASSIGN i-via-transp-ini = {adinc/i01ad268.i 06 tt-param.c-via-transp-ini}
       i-via-transp-fim = {adinc/i01ad268.i 06 tt-param.c-via-transp-fim}.

IF NOT CAN-FIND(FIRST tt-digita) THEN DO:
    FOR EACH decla-import 
            WHERE decla-import.num-di-ems           >= tt-param.c-diems-ini    AND
                  decla-import.num-di-ems           <= tt-param.c-diems-fim    AND
                  decla-import.cod-di-siscomex      >= tt-param.c-siscomex-ini AND  
                  decla-import.cod-di-siscomex      <= tt-param.c-siscomex-fim AND  
                  (     (decla-import.dat-di           >=  tt-param.d-datadi-ini
                   AND   decla-import.dat-di           <=  tt-param.d-datadi-fim
                   AND   decla-import.dat-di           <>  ? )
                          OR    decla-import.dat-di = ? ) AND
                  decla-import.cod-estab            >= tt-param.c-estab-ini    AND
                  decla-import.cod-estab            <= tt-param.c-estab-fim    AND
                  decla-import.idi-via-transp-di    >= i-via-transp-ini        AND
                  decla-import.idi-via-transp-di    <= i-via-transp-fim        AND
                  decla-import.cdd-siscomex-dts      = 0
        BREAK BY decla-import.num-di-ems:

        IF LAST-OF(decla-import.num-di-ems) THEN DO:
            CREATE tt-decla-import.
            BUFFER-COPY decla-import TO tt-decla-import.
        END.
    END.
END.
ELSE DO:
    FOR EACH tt-digita,
            EACH decla-import 
                WHERE decla-import.num-di-ems             =  tt-digita.num-di-ems    AND
                      decla-import.cod-di-siscomex        =  tt-digita.cod-di-siscomex AND
                      decla-import.dat-di                 =  tt-digita.data-di         AND
                      decla-import.cdd-siscomex-dts       = 0
            BREAK BY decla-import.num-di-ems:

            IF LAST-OF(decla-import.num-di-ems) THEN DO:
                CREATE tt-decla-import.
                BUFFER-COPY decla-import TO tt-decla-import.
            END.
    END.
END.




if  l-imprime = no then do:
    view frame f-cabec.
    view frame f-rodape.
    disp " " with stream-io frame f-nulo.
end.

IF tt-param.classifica = 1 THEN
    RUN imp/im0440a.p (INPUT TABLE tt-decla-import,
                       INPUT TABLE tt-param,
                       INPUT TABLE tt-digita).
ELSE DO:
    RUN imp/im0440b.p (INPUT TABLE tt-decla-import,
                       INPUT TABLE tt-param,
                       INPUT TABLE tt-digita).
END.

run pi-finalizar in h-im0440.

page.
output close.

output {&stream} close.

procedure pi-print-editor:
    def input param c-editor    as char    no-undo.
    def input param i-len       as integer no-undo.

    def var i-linha  as integer no-undo.
    def var i-aux    as integer no-undo.
    def var c-aux    as char    no-undo.
    def var c-ret    as char    no-undo.

    for each tt-editor:
        delete tt-editor.
    end.

    assign c-ret = chr(255) + chr(255).

    do  while c-editor <> "":
        if  c-editor <> "" then do:
            assign i-aux = index(c-editor, chr(10)).
            if  i-aux > i-len or (i-aux = 0 and length(c-editor) > i-len) then
                assign i-aux = r-index(c-editor, " ", i-len + 1).
            if  i-aux = 0 then
                assign c-aux = substr(c-editor, 1, i-len)
                       c-editor = substr(c-editor, i-len + 1).
            else
                assign c-aux = substr(c-editor, 1, i-aux - 1)
                       c-editor = substr(c-editor, i-aux + 1).
            if  i-len = 0 then
                assign entry(1, c-ret, chr(255)) = c-aux.
            else do:
                assign i-linha = i-linha + 1.
                create tt-editor.
                assign tt-editor.linha    = i-linha
                       tt-editor.conteudo = c-aux.
            end.
        end.
        if  i-len = 0 then
            return c-ret.
    end.
    return c-ret.
end procedure.

return 'OK'.


