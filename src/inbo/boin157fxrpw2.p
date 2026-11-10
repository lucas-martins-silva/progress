/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN157FXRPW2 1.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
    {include/i-license-manager.i boin157fxrpw2 MCE}
&ENDIF

/******************************************************************************
***       
*** inbo/boin157fxaaa.p - Gera Pedidos de Execuá∆o via RPW - Periodico.                  
***                             
******************************************************************************/

{cdp/cdcfgmat.i}

def new global shared var v_cod_aplicat_dtsul_corren as character format "x(3)":U  no-undo.

&if '{&bf_mat_versao_ems}' >= '2.071' &then
  def new global shared var i-ep-codigo-usuario        as character format "x(3)"    no-undo.
&else
  def new global shared var v_cod_empres_usuar         as character format "x(3)":U  no-undo.
&endif

def new global shared var v_cod_grp_usuar_lst        as character format "x(3)":U  no-undo.
def new global shared var v_cod_idiom_usuar          as character format "x(8)":U  no-undo.
def new global shared var v_cod_pais_empres_usuar    as character format "x(3)":U  no-undo.
def new global shared var v_cod_usuar_corren         as character format "x(12)":U no-undo.
def new global shared var v_cod_usuar_corren_criptog as character format "x(16)":U no-undo.

define temp-table tt-retorno-erro no-undo
    field cod-erro     as integer   format ">>>>>>>>9"
    field desc-erro    as character.

define temp-table tt-pedido-execucao no-undo
    field num-ped-exec as integer   format "99999"
    field data-exec    as date      format "99/99/9999"
    field hora-exec    as character format "99:99:99".

def temp-table tt-raw-digita no-undo
    field raw-digita   as raw.

{btb/btb912zc.i2}

define input  parameter raw-param as raw no-undo.
define input  parameter table for tt-raw-digita.
define input  parameter cArquivo     AS CHARACTER NO-UNDO.
define input  parameter cProgramName AS CHARACTER NO-UNDO.
define input  parameter cProgramCode AS INTEGER   NO-UNDO.
define input  parameter cRpFile      AS CHARACTER NO-UNDO.
define output parameter table for tt-pedido-execucao.
define output parameter table for tt-retorno-erro.


define variable i-pedido      as integer   no-undo.
define variable i-hora        as integer   no-undo.
define variable i-minuto      as integer   no-undo.
define variable i-dif-hora    as integer   no-undo.
define variable i-dif-min     as integer   no-undo.
define variable i-sequencia   as integer   no-undo.
define variable da-data       as date      no-undo.
define variable c-time        as character no-undo.
define variable c-arquivo     as character no-undo.
define variable c-versao-prog as character no-undo.
define variable h-handle-api  as handle    no-undo.

define buffer b-agenda_rpw for agenda_rpw.


Main_Block:
do  transaction on error  undo Main_Block, leave Main_Block
                on quit   undo Main_Block, leave Main_Block
                on stop   undo Main_Block, leave Main_Block
                on endkey undo Main_Block, leave Main_Block:
            
    find first agenda_rpw no-lock
         where agenda_rpw.cdn_modul_refer     = 0
         and   agenda_rpw.cdn_operac          = 0
         and   agenda_rpw.cdn_maq_dest        = 0
         and   agenda_rpw.cod_trans_mp        = cProgramName
         and   agenda_rpw.cod_trans_cld       = cProgramName
         and   agenda_rpw.cdn_trans_edi       = cProgramCode
         and   agenda_rpw.num_parcei_edi      = cProgramCode
         no-error.


    if  avail agenda_rpw then do:

        assign i-pedido = 1.
        assign c-time = replace(string(TIME,"hh:mm:ss"),":","").
        assign da-data = today.        
                                    
        run pi-criar-pedido-rpw.
                
        find first tt-retorno-erro no-lock no-error.
        if  not avail tt-retorno-erro then do:
                    
            find first tt_ped_exec_aux_2 no-lock no-error.
            if  avail tt_ped_exec_aux_2 then do:
                        
                create tt-pedido-execucao.
                assign tt-pedido-execucao.num-ped-exec = tt_ped_exec_aux_2.tta_num_ped_exec
                       tt-pedido-execucao.data-exec    = tt_ped_exec_aux_2.tta_dat_exec_ped_exec
                       tt-pedido-execucao.hora-exec    = tt_ped_exec_aux_2.tta_hra_exec_ped_exec.
                        
                find b-agenda_rpw where rowid(b-agenda_rpw) = rowid(agenda_rpw) exclusive-lock no-error.
                if  avail b-agenda_rpw then
                    assign b-agenda_rpw.val_livre_1  = tt_ped_exec_aux_2.tta_num_ped_exec
                           b-agenda_rpw.dat_ult_exec = da-data
                           b-agenda_rpw.hra_ult_exec = c-time
                           b-agenda_rpw.cod_livre_1  = "XYZ":U.
                    
            end.
        end.
                
    end.
end.

/*--- pi-criar-pedido-rpw ---*/
PROCEDURE pi-criar-pedido-rpw:
        
    for each tt_param_segur:
        delete tt_param_segur.
    end. 
        
    for each tt_ped_exec_aux_2:
        delete tt_ped_exec_aux_2.
    end.
        
    for each tt_ped_exec_param:
        delete tt_ped_exec_param.
    end.
        
    for each tt_ped_exec_param_aux:
        delete tt_ped_exec_param_aux.
    end.
        
    for each tt_ped_exec_sel:
        delete tt_ped_exec_sel.
    end.
        
    for each tt_erros_envio_email:
        delete tt_erros_envio_email.
    end.
    
    for each tt-retorno-erro:
        delete tt-retorno-erro.
    end.
    

    /*********************** CRIA TEMP-TABLE TT_PARAM_SEGUR *************************/
    create tt_param_segur.
    assign tt_param_segur.tta_num_vers_integr_api      = 003
           tt_param_segur.tta_cod_aplicat_dtsul_corren = v_cod_aplicat_dtsul_corren

        &if '{&bf_mat_versao_ems}' >= '2.071' &then
          tt_param_segur.tta_cod_empres_usuar         = i-ep-codigo-usuario
        &else
          tt_param_segur.tta_cod_empres_usuar         = v_cod_empres_usuar
        &endif

           tt_param_segur.tta_cod_grp_usuar_lst        = v_cod_grp_usuar_lst
           tt_param_segur.tta_cod_idiom_usuar          = v_cod_idiom_usuar
           tt_param_segur.tta_cod_modul_dtsul_corren   = "MCE"
           tt_param_segur.tta_cod_pais_empres_usuar    = v_cod_pais_empres_usuar
           tt_param_segur.tta_cod_usuar_corren         = v_cod_usuar_corren
           tt_param_segur.tta_cod_usuar_corren_criptog = v_cod_usuar_corren_criptog.
        
        
    /*********************** CRIA TEMP-TABLE TT_PED_EXEC_AUX_2 **********************/
    find usuar_mestre no-lock
        where usuar_mestre.cod_usuario = v_cod_usuar_corren no-error.

    create tt_ped_exec_aux_2.
    assign tt_ped_exec_aux_2.tta_num_seq                = i-pedido  
           tt_ped_exec_aux_2.tta_num_ped_exec           = 0
           tt_ped_exec_aux_2.tta_cod_usuario            = v_cod_usuar_corren
           tt_ped_exec_aux_2.tta_dat_exec_ped_exec      = da-data
           tt_ped_exec_aux_2.tta_hra_exec_ped_exec      = c-time
           tt_ped_exec_aux_2.tta_cod_servid_exec        = usuar_mestre.cod_servid_exec
           tt_ped_exec_aux_2.tta_cdn_estil_dwb          = 97
           tt_ped_exec_aux_2.tta_cod_orig_ped_exec      = ""
           tt_ped_exec_aux_2.tta_cod_prog_dtsul_rp      = cRpFile
           tt_ped_exec_aux_2.tta_cod_prog_dtsul         = cProgramName.

    assign c-arquivo = substring(tt_ped_exec_aux_2.tta_cod_prog_dtsul_rp, 1, 13) + "r".
        
    run utp/ut-vrbin.p (input  c-arquivo,
                        input  yes,
                        output c-versao-prog).
                        
    if  c-versao-prog <> ? then 
        assign tt_ped_exec_aux_2.tta_cod_release_prog_dtsul = c-versao-prog.  
    else    
        assign tt_ped_exec_aux_2.tta_cod_release_prog_dtsul = "0.00.00.000".
    
    assign tt_ped_exec_aux_2.ttv_des_inf_aplic = " " + string(da-data, "99/99/9999") + " " + string(c-time, "99:99:99").
        
    /*********************** CRIA TEMP-TABLE TT_PED_EXEC_PARAM *************************/
    create tt_ped_exec_param.
    assign tt_ped_exec_param.tta_num_seq              = i-pedido
           tt_ped_exec_param.tta_cod_dwb_file         = cArquivo /** COLOCAR UM PARAMETRO NOVO **/ /*tt-param.arquivo*/
           tt_ped_exec_param.tta_cod_dwb_output       = "ARQUIVO" /*if tt-param.destino = 1 then "IMPRESSORA" else "ARQUIVO"*/.
            
    /*--- ê necess†rio a l¢gica abaixo porque a sa°da ser† de acordo
          com o arquivo ou impressora/layout definido pelo usu†rio e,
          n∆o necessariamente ser† o mesmo destino do layout do 
          relat¢rio. ---*/
            
    /*-- ê necess†rio a atualizaá∆o abaixo para que o programa cd0200rp.p
         executa a l¢gica de atualizaá∆o, n∆o gerando novos pedidos RPW,
         caso contr†rio o programa ficar† criando novos pedidos. ---*/
    
    ASSIGN tt_ped_exec_param.tta_raw_param_ped_exec = raw-param.

    /********************* CRIA TEMP-TABLE TT_PED_EXEC_PARAM_AUX ***********************/
    assign i-sequencia = 0.
            
    for each tt-raw-digita:
        assign i-sequencia = i-sequencia + 1.
            
        create tt_ped_exec_param_aux.
        assign tt_ped_exec_param_aux.tta_num_seq       = i-pedido
               tt_ped_exec_param_aux.tta_num_dwb_order = i-sequencia
               tt_ped_exec_param_aux.tta_raw_param_ped_exec = tt-raw-digita.raw-digita.
            
    end.
        
    run btb/btb912zc.p persistent set h-handle-api.
            
    run pi-execute-2 in h-handle-api (input-output table tt_param_segur,
                                      input-output table tt_ped_exec_aux_2,
                                      input        table tt_ped_exec_param,
                                      input        table tt_ped_exec_param_aux,
                                      input        table tt_ped_exec_sel,
                                      output       table tt_erros_envio_email).
                                      
    delete procedure h-handle-api.        

    find first tt_param_segur no-lock no-error.         
    if  avail tt_param_segur and tt_param_segur.ttv_num_msg_erro <> 0 then do:
        create tt-retorno-erro.
        assign tt-retorno-erro.cod-erro  = tt_param_segur.ttv_num_msg_erro
               tt-retorno-erro.desc-erro = tt_param_segur.ttv_des_msg.
    end.
    
    find first tt_ped_exec_aux_2 no-lock no-error.
    if  avail tt_ped_exec_aux_2 and tt_ped_exec_aux_2.ttv_num_msg_erro <> 0 then do:
        create tt-retorno-erro.
        assign tt-retorno-erro.cod-erro  = tt_ped_exec_aux_2.ttv_num_msg_erro
               tt-retorno-erro.desc-erro = tt_ped_exec_aux_2.ttv_cod_msg_parameters.
    end.
                   
END PROCEDURE.

/* Fim de Programa */
